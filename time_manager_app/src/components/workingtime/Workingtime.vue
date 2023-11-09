<script>

import { GChart } from 'vue-google-charts'
import { workingTimeDataFormat } from '../../utils/chart'
import { getWeek, getWeekFromDate } from '../../utils/date'
import { ApiGet, ApiPost } from '../../utils/api'

export default {
  name: 'workingtime',
  components: {
    GChart
  },
  props: {
    data: Array,
    bgColor: String,
    currUserId: Number
  },
  mounted() {
    this.init()
  },
  methods: {
    init() {
      if(this.$store.state.currWeekDisplayed === null) {
        let value = getWeek(new Date)
        this.$store.dispatch('changeWeek', value).then(() => {
          this.isLoaded = true
        })
        // ajouter l'appel pour avoir les données et les tranformer ici
      } else {
        this.isLoaded = true
      }
    },
    async handleDatePicker(e) {
      this.isLoaded = false
      let formatedDate = getWeekFromDate(e.target.value)
      let newUrl = formatedDate['url']
      let user = this.$store.state.currUser.id
      let res = await ApiGet(`/workingtimes/${user}?${newUrl}`)
      let toDisplay = workingTimeDataFormat(res, formatedDate['days'])
      this.chartData = toDisplay
      this.$store.dispatch('changeWeek', formatedDate['week']).then(() => {
          this.isLoaded = true
      })
    }
  },
  data() {
    return {
      isLoaded: false,
      datepicker: '',
      chartData: this.data,
      chartOptions: {
        legend: 'none',
        fill: this.bgColor,
        bar: { groupWidth: '80%' },
        'backgroundColor': {
          'fill': this.bgColor,
          'opacity': 100
        },
        chartArea: {'width': '90%', 'height': '60%'},
        vAxis: {
          ticks: [6, 8, 10, 12, 14, 16, 18, 20]
        },
        candlestick: {
          fallingColor: { strokeWidth: 0, fill: '#FFC28E' }
        }
      }
    }
  }
}

// logique du composant => un select avec une valeur par défault d'une semaine
// plutot qu'un select ce sera un datepicker qui récupère la semaine courantes
// fetch les working times en question (ou alors le fait a l'initialisation)
// affiche dans un bar chart avec les jours de la semaine en absices et les heures en ordonées

</script>

<template>
  <div v-if="isLoaded">
    <div class="flex justify-between items-center">
      <span class="text-second-text ml-2 text-2xl font-bold">Week {{ this.$store.state.currWeekDisplayed }}</span> 
      <div class="relative w-32">
        <input datepicker v-model="datepicker" type="date" @input="handleDatePicker" class="bg-second-text text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5" placeholder="Select date">
      </div>
    </div>
    <GChart 
      type="CandlestickChart"
      :data="chartData"
      :options="chartOptions"
    />
  </div>
  <div v-else>
      <div class="flex justify-between items-center">
        <span>Loading...</span>
      </div>
  </div>
</template>

<style>

</style>