export default function() {
 	this.route('mrbug', { path: '/MrBug' });
 	this.route('megaadd', { path: '/admin/MegaAdd' });
	this.route('rentagama', { path: '/renta-haleguu' });
	this.route('user', function() {
 		this.route('kek');
 	});
	this.resource('customroute', { path: '/customroute' });
};
