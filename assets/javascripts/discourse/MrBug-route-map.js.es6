//export default function() {
//	this.route('MrBug', { path: '/MrBug' });
//	this.route('MegaAdd', { path: '/admin/MegaAdd' });
//	this.route('KeK', { path: '/u/:username/kek' });
//};
export default {
	resource: 'user',
	path: '/u/:username',
	map(){
		this.route('KeK');
	}
}
