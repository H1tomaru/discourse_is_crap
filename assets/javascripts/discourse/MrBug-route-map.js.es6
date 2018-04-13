export default function() {
	this.route('MrBug', { path: '/MrBug' });
	this.route('MegaAdd', { path: '/admin/MegaAdd' });
	this.route('user', { resetNamespace: true, path: '/users/:username'} , function() {
		this.route('KeK', { path: 'kek' });
	});
};
