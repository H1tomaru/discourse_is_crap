export default function() {
	this.route('MrBug', { path: '/MrBug' });
	this.route('MegaAdd', { path: '/admin/MegaAdd' });
	//this.route('KeK', { path: '/u/:username/kek' });
	this.resource('user', { path: '/u/:username' }, function() {
		this.route('KeK', { path: '/kek' });
	});
};
