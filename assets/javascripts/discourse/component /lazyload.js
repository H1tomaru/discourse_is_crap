import Ember from 'ember';
import $ from 'jquery';

export default Ember.Component.extend({
    didInsertElement() {
        $.getScript('https://cdnjs.cloudflare.com/ajax/libs/lazysizes/5.1.2/lazysizes.min.js')
    }
})
