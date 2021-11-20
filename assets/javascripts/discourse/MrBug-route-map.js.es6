export default function() {
 	this.route('MrBug', { path: '/MrBug' });
 	this.route('megaadd', { path: '/admin/megaadd' });
	this.route('Rentagama', { path: '/renta-haleguu' });
	this.route('user', function() {
 		this.route('kek');
 	});
};
