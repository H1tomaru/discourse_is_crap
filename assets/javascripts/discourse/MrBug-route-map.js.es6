export default function() {
	this.route('MrBug', { path: '/MrBug' });
	this.route('MegaAdd', { path: '/admin/MegaAdd' });
	//this.route('KeK', { path: '/users/:username/kek' });
	
	resource: 'user',
	path: 'users/:username',
	map() {
	this.route('KeK', { path: '/kek' })
	}
};
