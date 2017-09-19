import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

Vue.use(VueRouter)


const Foo = { template: '<div>foo</div>' }
const Bar = { template: '<div>bar</div>' }

export default new VueRouter({
  mode: 'history',
  base: '/diagnoses',
  routes: [
    { path: '/step-1', component: Foo },
    { path: '*', component: Bar },
  ]
})