<template lang="pug">
    .create-diagnosis-button
        .ui.fluid.labeled.icon.large.green.basic.button(v-on:click='buttonClicked')
            i.plus.icon
            | {{ $t('index.create_new_diagnosis') }}

</template>

<script>
export default {
  name: 'create-diagnosis-button',
  methods: {
    buttonClicked: function () {
      this.emit('click')
    }
  }
}
</script>

<style lang="sass">
    .create-diagnosis-button
        margin: 20px 0
        .ui.basic.icon.labeled.button
            text-align: left
            > .icon
                background: transparent
</style>
