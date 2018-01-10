export default {
  resource: 'user',
  path: 'users/:username',
  map() {
    this.resource('mrbug', { path: '/mrbug' });
  }
}
