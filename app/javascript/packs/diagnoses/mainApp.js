import Vue from 'vue/dist/vue.esm'

import router from './router'
import appDataSetter from './appDataSetter.vue'
// import store from './store'
import TurbolinksAdapter from 'vue-turbolinks'
import AxiosConfigurator from '../common/axiosConfigurator'
import ErrorService from '../common/errorService'

Vue.use(TurbolinksAdapter)
AxiosConfigurator.configure()
ErrorService.configureFramework(Vue)

new Vue({ // eslint-disable-line no-new
  el: '#diagnoses-app',
  // store,
  router,
  components: {
    appDataSetter
  },
  data: {
  },
  computed: {
  },
  methods: {
  }
})