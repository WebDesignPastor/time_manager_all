<script>
import { ApiGet } from '../../utils/api';
import { formatDisplayDate } from '../../utils/date'
import { toRaw } from 'vue'

export default {
    name: 'Clock',
    components: {},
    computed: {
        clock() {
            if(!this.$store.isUserFocusDashboard) {
                return this.$store.state.currUser.clock != null ? this.$store.state.currUser.clock : null
            } else {
                return this.$store.state.userFocus.clock != null ? this.$store.state.userFocus.clock : null
            }
        }
    },
    mounted() {
        if(!this.$store.state.isUserFocusDashboard) {
            if(this.$store.state.currUser.clock != null) {
                if(this.$store.state.currUser.clock.end !== null) {
                    this.endHour = formatDisplayDate(toRaw(this.$store.state.currUser.clock.end))
                }
                this.startHour = formatDisplayDate(toRaw(this.$store.state.currUser.clock.start))
                this.isLoaded = true
            }
        } else {
            if(this.$store.state.userFocus.clock != null) {
                if(this.$store.state.userFocus.clock.end !== null) {
                    this.endHour = formatDisplayDate(toRaw(this.$store.state.userFocus.clock.end))
                }
                this.startHour = formatDisplayDate(toRaw(this.$store.state.userFocus.clock.start))
                this.isLoaded = true
            }
        }
    },
    data() {
        return {
            endHour: '',
            startHour: '' ,
            isLoaded: false,
            userConfirmed: null
        }
    },
    methods: {
        async handleClock() {
          this.userConfirmed = window.confirm('Are you sure ?')
          // vérifie si le store est bien initialiser
          if(this.userConfirmed) {
              this.isLoaded = false
              if(!this.$store.isUserFocusDashboard) {
                  if (this.$store.state.currUser.clock !== null) {
                      let res = await ApiGet(`/clocks/${this.$store.state.currUser.id}`, this.$store.state.token)
                      this.$store.dispatch('changeClock', res).then(() => {
                          if(this.$store.state.currUser.clock.end !== null) {
                              this.endHour = formatDisplayDate(toRaw(this.$store.state.currUser.clock.end))
                          }
                          this.startHour = formatDisplayDate(toRaw(this.$store.state.currUser.clock.start))
                          this.isLoaded = true
                      })
                  } else {
                      let res = await ApiGet(`/clocks/${this.$store.state.currUser.id}`, this.$store.state.token)
                      this.$store.dispatch('changeClock', res).then(() => {
                          if(this.$store.state.currUser.clock.end !== null) {
                              this.endHour = formatDisplayDate(toRaw(this.$store.state.currUser.clock.end))
                          }
                          this.startHour = formatDisplayDate(toRaw(this.$store.state.currUser.clock.start))
                          this.isLoaded = true
                      })
                  }
              } else {
                  if (this.$store.state.userFocus.clock !== null) {
                      let res = await ApiGet(`/clocks/${this.$store.state.userFocus.id}`, this.$store.state.token)
                      this.$store.dispatch('changeFocusClock', res).then(() => {
                          if(this.$store.state.userFocus.clock.end !== null) {
                              this.endHour = formatDisplayDate(toRaw(this.$store.state.userFocus.clock.end))
                          }
                          this.startHour = formatDisplayDate(toRaw(this.$store.state.userFocus.clock.start))
                          this.isLoaded = true
                      })
                  } else {
                      let res = await ApiGet(`/clocks/${this.$store.state.userFocus.id}`, this.$store.state.token)
                      this.$store.dispatch('changeClock', res).then(() => {
                          if(this.$store.state.userFocus.clock.end !== null) {
                              this.endHour = formatDisplayDate(toRaw(this.$store.state.userFocus.clock.end))
                          }
                          this.startHour = formatDisplayDate(toRaw(this.$store.state.userFocus.clock.start))
                          this.isLoaded = true
                      })
                  }
              }
            }
        },
    }
}

</script>

<template>
        <h2 class="m-0 text-2xl font-bold tracking-tight text-second-text">Clock</h2>
        <div class="flex justify-center items-center flex-col" v-if="isLoaded && clock">
            <span class="text-gray text-2xl mb-2" tabindex="0" :aria-label="clock.status ? 'Time start at :' + startHour.toLocaleString() : 'Time stop at :' + endHour.toLocaleString() ">{{ clock.status ? 'Started at :' : 'Ended :' }}</span>
            <span class="text-second-text text-xl">{{ clock.status ? startHour : endHour }}</span>
        </div>
        <div v-else class="flex justify-center items-center flex-col">
            <span class="text-gray text-sm mb-2">Start the timer</span>
        </div>
        <div class="flex justify-center items-center" v-if="clock">
            <button @click="handleClock" class="py-2.5 px-6 rounded-lg text-sm font-medium bg-second-text" :aria-label="clock.status ? 'stop the timer' : 'start the timer'">{{ clock.status ? 'stop': 'start' }}</button>
        </div>
        <div class="flex justify-center items-center" v-else>
            <button @click="handleClock" class="py-2.5 px-6 rounded-lg text-sm font-medium bg-second-text">start</button>
        </div>
</template>

<style>

</style>
