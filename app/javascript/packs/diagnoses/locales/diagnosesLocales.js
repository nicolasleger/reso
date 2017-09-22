import Vue from 'vue/dist/vue.esm'
import VueI18n from 'vue-i18n'

Vue.use(VueI18n)

const messages = {
  fr: {
    index: {
      title: 'Liste des analyses',
      create_new_diagnosis: 'Faire une nouvelle analyse'
    }
    // car: 'car | cars', --> For plural
    // apple: 'no apples | one apple | {count} apples' --> For none, one, and plural
    // message: {
    //   hello: 'hello world' --> Accessed from {{ $t("message.hello") }}
    // }
  }
}

export default new VueI18n({
  locale: 'fr',
  messages
})
