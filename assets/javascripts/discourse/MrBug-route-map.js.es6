export default function() {
 	this.route('MrBug', { path: '/MrBug' });
 	this.route('MegaAdd', { path: '/admin/MegaAdd' });
	this.route('Rentagama', { path: '/renta-haleguu' });
	this.route('user', function() {
 		this.route('kek');
 	});
};
