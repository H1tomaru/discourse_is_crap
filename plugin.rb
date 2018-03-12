# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

gem 'bson', "4.3.0"
gem 'mongo', "2.5.0"

require 'mongo'
require 'base64'
require 'openssl'

register_asset 'stylesheets/MrBug.scss'

after_initialize do

	Discourse::Application.routes.append do
		get '/MrBug' => 'mrbug#show'
		get '/MrBug/troikopoisk/:miloakka' => 'mrbug#troikopoisk'
	end

	class ::MrbugController < ::ApplicationController

	#	include CurrentUser

		db = Mongo::Client.new([ '93.171.216.230:33775' ], user: 'troiko_user', password: '47TTGLRLR3' )
		@@gamedb = db.use('AutoZ_gameDB')
		@@userlistdb = db.use('AutoZ_gameZ')
		@@userdb = db.use('userdb')
		@@userfb = db.use('userfb')

		def show
			#db variables
			ulist = @@userlistdb['uListP4'].find().to_a
			#other variables
			finalvar = {}
			finalvar['qzstuff'] = false

			#if viever registered, count his fb
			if current_user
				fbcount = 0
				feedbacks = @@userfb['userfb'].find( { UID: current_user['username'] } ).to_a
				feedbacks.each {
					if feedbacks['SCORE'] < 0
						fbcount = 0
						break
					end
					fbcount = fbcount + feedbacks['SCORE']
				}
				finalvar['qzstuff'] = true if fbcount >= 10
			end

			finalvar['qzstuff'] = true
			#get all games from db and make a qz variable with codes and stuff
			if finalvar['qzstuff']
				glist = @@gamedb['gameDB'].find( { _id: { '$ne': '_encodedcodes' } } ).sort( { gameNAME: 1 } ).to_a
				qzlist = @@gamedb['gameDB'].find( { _id: '_encodedcodes' } ).to_a
				glist.each {
					if (qzlist[0][current_user['username']][glist['_id']] rescue false)
						#qzlist[0].dig(current_user['username'], glist['_id'])
						finalvar['qzlist'] = {
							glist['_id'] : {'gCODE' : qzlist[0][current_user['username']][glist['_id']]['gCODE'],
									'gNAME' : glist['gameNAME']}
						}
					else
						finalvar['qzlist'] = {
							glist['_id'] :	{'gCODE' : glist['_id'].encrypt('urban'),
									'gNAME' : glist['gameNAME']}
						}
					end
				}
			end

			render json: { finalvar: finalvar, CurrentUser: current_user, gamelist: glist, userlist: ulist }
		end
		
		
		def troikopoisk
			#decode shit
			troikopoisk = Base64.decode64(params['miloakka']).strip.downcase
			#do stuff when finding acc or not
			if troikopoisk.length > 20 && troikopoisk.length < 40
				zapislist = @@userdb['PS4db'].find( { _id: troikopoisk }, projection: { DATE: 0 } ).to_a
				if zapislist[0]
					render json: { poiskwin: true, troikopoisk: zapislist[0] }
				else
					render json: { poiskwin: false }
				end
			else 
				render json: { poiskwin: false }
			end
		end 

	end
end

#encrypt decrypt stuff
class String
  def encrypt(key)
    cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC').encrypt
    cipher.key = Digest::SHA1.hexdigest key
    s = cipher.update(self) + cipher.final

    s.unpack('H*')[0].upcase
  end

  def decrypt(key)
    cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC').decrypt
    cipher.key = Digest::SHA1.hexdigest key
    s = [self].pack("H*").unpack("C*").pack("c*")

    cipher.update(s) + cipher.final
  end
end
