<script>

import { GChart } from 'vue-google-charts'
import { customToolTip, workingTimeDataFormat } from '../../utils/chart'
import { getWeek, getWeekFromDate } from '../../utils/date'
import { ApiGet } from '../../utils/api'

export default {
  name: 'workingtime',
  components: {
    GChart
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
    handleDatePicker(e) {
      this.isLoaded = false
      let formatedDate = getWeekFromDate(e.target.value)
      let newUrl = formatedDate['url']
      let resData = [
            {
                "start": "2023-10-27T12:34:56",
                "end": "2023-10-27T19:34:56"
            },
            {
                "start": "2023-10-28T12:00:56",
                "end": "2023-10-28T18:30:56"
            },
            {
                "start": "2023-11-01T13:30:56",
                "end": "2023-11-01T19:34:56"
            }
        ]
      // let resData = ApiGet(`/workingtimes/${this.$store.state.currUser.id}/${newUrl}`)
      // ici ajoutez logique de call l'api pour changer les valeurs du datepicker
      let toDisplay = workingTimeDataFormat(resData, formatedDate['days'])
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
      chartData: [
        ['day', 'shift', 'b', 'c', 'd', {type:'string',role:'tooltip'}],
        ['Mon', 8, 18, 8, 18, customToolTip(8, 18)],
        ['Tue', 7, 15, 7, 15, customToolTip(7, 15)],
        ['Wed', 8, 15, 8, 15, customToolTip(8, 15)],
        ['Thu', null, null, null, null, customToolTip(0, 0)],
        ['Fri', 10, 19, 10, 19, customToolTip(10, 19)]
      ],
      chartOptions: {
        legend: 'none',
        fill: '#e0440e',
        bar: { groupWidth: '80%' },
        'backgroundColor': {
          'fill': '#BFB293',
          'opacity': 100
        },
        chartArea: {'width': '85%', 'height': '60%'},
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
    <div class="w-6/12 h-62 p-3 bg-graph-bg rounded-3xl shadow flex flex-col">
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
          <span>Loading...</span>
      </div>
    </div>
</template>

<style>

</style>