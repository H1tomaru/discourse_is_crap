export default function() {
 	this.route('MrBug', { path: '/MrBug' });
	this.route('MrBugP4', { path: '/MrBugP4' });
 	this.route('MegaAdd', { path: '/admin/MegaAdd' });
	this.route('Rentagama', { path: '/renta-haleguu' });
	this.route('user', function() {
 		this.route('kek');
 	});
};
