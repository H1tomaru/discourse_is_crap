export default function() {
 	this.route('MrBug', { path: '/MrBug' });
 	this.route('MegaAdd', { path: '/admin/MegaAdd' });
	this.route('user', { path: '/u/:username'} , function() {
 		this.route('KeK', { path: 'kek' });
 	});
};
