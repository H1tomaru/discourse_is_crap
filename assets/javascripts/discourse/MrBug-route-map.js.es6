export default function() {
	this.route('MrBug', { path: '/MrBug' });
	this.route('MegaAdd', { path: '/admin/MegaAdd' });
	//this.route('KeK', { path: '/users/:username/kek' });
	this.resource('user', { path: '/users/:username' }, function() {
   	this.route('KeK', { path: '/kek' }); });
};
