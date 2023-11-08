<script>
import { ApiGet } from '../../utils/api';
import { formatDisplayDate } from '../../utils/date'
import { toRaw } from 'vue'

export default {
    name: 'Clock',
    components: {},
    computed: {
        clock() {
            return this.$store.state.currUser.clock != null ? this.$store.state.currUser.clock : null
        }
    },
    mounted() {
        if(this.$store.state.currUser.clock != null) {
            if(this.$store.state.currUser.clock.end !== null) {
                this.endHour = formatDisplayDate(toRaw(this.$store.state.currUser.clock.end))
            }
            this.startHour = formatDisplayDate(toRaw(this.$store.state.currUser.clock.start))
            this.isLoaded = true
        }
    },
    data() {
        return {
            endHour: '',
            startHour: '' ,
            isLoaded: false
        }
    },
    methods: {
        async handleClock() {
            this.isLoaded = false
            // vérifie si le store est bien initialiser
            if (this.$store.state.currUser.clock !== null) {
                let res = await ApiGet(`/clocks/${this.$store.state.currUser.id}`)
                this.$store.dispatch('changeClock', res).then(() => {
                    if(this.$store.state.currUser.clock.end !== null) {
                        this.endHour = formatDisplayDate(toRaw(this.$store.state.currUser.clock.end))
                    }
                    this.startHour = formatDisplayDate(toRaw(this.$store.state.currUser.clock.start))
                    this.isLoaded = true
                })
            } else {
                let res = await ApiGet(`/clocks/${this.$store.state.currUser.id}`)
            }
        }
    }
}

</script>

<template>
    <div class="w-4/12 h-56 px-6 py-4 bg-clockbg rounded-3xl shadow flex flex-col justify-between">
        <h2 class="m-0 text-2xl font-bold tracking-tight text-second-text">Clock</h2>
        <div class="flex justify-center items-center flex-col" v-if="isLoaded && clock">
            <span class="text-gray text-2xl mb-2">{{ clock.status ? 'Started at :' : 'Ended :' }}</span>
            <span class="text-second-text text-xl">{{ clock.status ? startHour : endHour }}</span>
        </div>
        <div v-else class="flex justify-center items-center flex-col">
            <span class="text-gray text-sm mb-2">Start the timer</span>
        </div>
        <div class="flex justify-center items-center" v-if="clock">
            <button @click="handleClock" class="py-2.5 px-6 rounded-lg text-sm font-medium bg-second-text">{{ clock.status ? 'stop': 'start' }}</button>
        </div>
        <div class="flex justify-center items-center" v-else>
            <button @click="handleClock" class="py-2.5 px-6 rounded-lg text-sm font-medium bg-second-text">start</button>
        </div>
    </div>
</template>

<style>

</style>