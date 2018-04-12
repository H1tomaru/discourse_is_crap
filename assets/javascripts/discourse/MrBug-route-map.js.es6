export default function() {
	this.route('MrBug', { path: '/MrBug' });
	this.route('MegaAdd', { path: '/admin/MegaAdd' });
};

export default {
	map() {
		this.route('kek');
	},
	path: 'users/:username',
	resource: 'user'
};
