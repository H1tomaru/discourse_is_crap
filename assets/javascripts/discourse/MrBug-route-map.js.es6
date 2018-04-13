export default function() {
	this.route('MrBug', { path: '/MrBug' });
	this.route('MegaAdd', { path: '/admin/MegaAdd' });
	this.route('KeK', { path: '/u/:username/kek' });
	this.route('user', { resetNamespace: true, path: '/u/:username'} , function() {
		this.route('kek');
	});
};
