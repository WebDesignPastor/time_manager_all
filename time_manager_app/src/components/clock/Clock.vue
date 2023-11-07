<script>

export default {
    name: 'Clock',
    components: {},
    computed: {
        clock() {
            return this.$store.state.currUser.clock.start != null ? this.$store.state.currUser.clock : null
        }
    },
    methods: {
        handleClock() {
            // vérifie si le store est bien initialisé
            if (this.$store.state.currUser.clock.isClocking !== null) {
                if (!this.$store.state.currUser.clock.isClocking) {
                    // vérif si l'on est dans une période de working time
                    // appel api pour débuter la clock
                } else {
                    // appel api pour l'arreter
                    // sans oublier de tout enregistrer dans le store
                }
            }
        }
    }
}

</script>

<template>
    <div class="w-full sm:w-4/12 h-56 px-6 py-4 bg-clockbg rounded-3xl shadow flex flex-col justify-between">
        <h2 class="m-0 text-2xl font-bold tracking-tight text-second-text">Clock</h2>
        <div class="flex justify-center items-center flex-col" v-if="clock.isClocking">
            <span class="text-gray text-sm mb-2">Started at :</span>
            <span class="text-second-text text-xl">{{ clock.start }}</span>
        </div>
        <div v-else class="flex justify-center items-center flex-col">
            <span class="text-gray text-sm mb-2">Start the timer</span>
        </div>
        <div class="flex justify-center items-center">
            <button class="py-2.5 px-6 rounded-lg text-sm font-medium bg-second-text">Start</button>
        </div>
    </div>
</template>

<style>

</style>
