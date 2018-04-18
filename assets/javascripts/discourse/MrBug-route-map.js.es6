export default function() {
 	this.route('MrBug', { path: '/MrBug' });
 	this.route('MegaAdd', { path: '/admin/MegaAdd' });
	this.route('user', function() {
 		this.route('kek');
 	});
};
