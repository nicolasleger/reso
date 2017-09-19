<template>
    <div></div>
</template>

<script>
  export default {
    name: 'app-data-setter',
    props: [
      'path'
    ],
    created: function () {
      this.$router.push({path: this.path})
    }
  }
</script>

<style lang="sass">
</style>
