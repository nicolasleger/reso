import Vue from 'vue/dist/vue.esm'

import router from './router'
import appDataSetter from './appDataSetter.vue'
// import store from './store'
import i18n from './locales/diagnosesLocales'
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
  i18n,
  components: {
    appDataSetter
  },
  data: {
  },
  computed: {
  },
  created: function () {
  },
  methods: {
  }
})
