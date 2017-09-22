<template lang="pug">
    .index-component
        create-diagnosis-button
        h1 {{ $t('index.title') }}


</template>

<script>
  import createDiagnosisButton from './createDiagnosisButton.vue'

  export default {
    name: 'index-component',
    components: {
      'create-diagnosis-button': createDiagnosisButton
    },
    props: [],
    data () {
    },
    created: function () {
      document.title = this.$t('index.title')
    },
    computed: {},
    methods: {}
  }
</script>

<style lang="sass">
</style>
