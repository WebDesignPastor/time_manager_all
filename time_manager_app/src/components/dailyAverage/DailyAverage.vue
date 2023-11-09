<script>

import { toRaw } from 'vue'
import { GChart } from 'vue-google-charts'

export default {
    name: 'DailyAverage',
    components: {
        GChart
    },
    methods: {
        handleCheckbox(e) {
            if(!this.teamsAlreadyDisplayed.includes(parseInt(e.target.value))) {
                let newKey = this.chartData[0].length
                this.chartData[0][newKey] = e.target.value
                this.teams.map((team) => {
                    if(team.id == e.target.value) {
                        team.value.map((val, index) => {
                            this.chartData[index + 1][newKey] = val
                        })
                    }
                })
                this.teamsAlreadyDisplayed.push(parseInt(e.target.value))
            } else {
                if(this.teamsAlreadyDisplayed.length > 1) {
                    let toRemove = this.teamsAlreadyDisplayed.indexOf(parseInt(e.target.value))
                    this.teamsAlreadyDisplayed.splice(toRemove, 1)
                    let valToErease = this.chartData[0].indexOf(e.target.value)
                    this.chartData.map((row) => {
                        row.splice(valToErease, 1)
                    })
                    if(this.chartOptions['series'] !== '') {
                        let newIndex = this.chartData[0].indexOf('average')
                        let newObj = {}
                        newObj[newIndex - 1] = {type: 'line'}
                        this.chartOptions['series'] = newObj
                    }
                }
            }
        },
        handleDatePicker(e) {
            console.log(this.dateRangeStart)
            console.log(this.dateRangeEnd)
            // logique du code pour le daily average
            // au clique du btn qui envoie les dates pickers
            // il faut fetch toutes les données relative a cette range
            // puis les trier par team
            // puis en faire la moyenne
            // puis renvoyer un tableau de valeur 
        },
        handleComboChart(e) {
            this.isComboChart = !this.isComboChart
            if(this.isComboChart) {
                // il faut qu'au click cela ajoute les datas necessaire pour transformer ca en combochart
                let avegareClockHours = ['average', 7, 6, 6, 8]
                let newData = toRaw(this.chartData)
                let newSeries = {}
                newSeries[newData[0].length - 1] = {type: 'line'}
                this.chartOptions['series'] = newSeries
                this.chartType = 'ComboChart'
                this.chartData.map((row, index) => {
                    newData[index][row.length] = avegareClockHours[index]
                })
                this.chartData = newData
            } else {
                let indexToErease = this.chartData[0].indexOf('average')
                let newData = []
                this.chartData.map((row) => {
                    newData.push(row.filter((data, idx) => idx !== indexToErease))
                })
                this.chartData = newData
                this.chartOptions['series'] = ''
                this.chartType = 'ColumnChart'
            }
        }
    },
    data() {
        return {
            teams: [
                {id: 1, name: 1, value: [4, 6, 7, 8]},
                {id: 2, name: 2, value: [4, 5, 2, 9]},
                {id: 3, name: 3, value: [7, 4, 5, 4]},
                {id: 4, name: 4, value: [3, 2, 3, 2]}
            ],
            teamsToDisplay: [1],
            teamsAlreadyDisplayed: [1],
            dateRangeStart: '',
            dateRangeEnd: '',
            isComboChart: false,
            chartData: [
                ['Days', 'Hours worked on average'],
                ['2013', 2],
                ['2014', 4],
                ['2015', 6],
                ['2016', 8]
            ],  
            chartOptions: {
                legend: 'none',
                vAxis: { minValue: 0 },
                chartArea: { width: '85%', height: '65%' },
                seriesType: 'bars',
                series: '',
                'backgroundColor': {
                    'fill': 'BAB6C1',
                    'opacity': 100
                },
            },
            chartType: 'ColumnChart'
        }
    }
}

</script>

<template>
    <div class="w-6/12 h-62 p-3 bg-clockbg rounded-3xl shadow flex flex-col">
        <div class="flex flex-col mx-2">
            <span class="m-0 mb-2 text-xl font-bold tracking-tight text-second-text">Daily average hours worked by teams :</span>
            <div date-rangepicker class="flex items-center mr-4 justify-between mb-1">
                <div class="relative">
                    <input required v-model="dateRangeStart" name="start" type="date" class="bg-second-text text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full pl-4 p-1.5" placeholder="Select date start">
                </div>
                <span class="mx-4 text-second-text">to</span>
                <div class="relative">
                    <input required v-model="dateRangeEnd" name="end" type="date" class="bg-second-text text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full pl-4 p-1.5" placeholder="Select date end">
                </div>
                <button @click="handleDatePicker" type="button" class="ml-2 text-white bg-second-text focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-2 py-2.5 text-center inline-flex items-center">
                    <svg class="w-3.5 h-3.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 10">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 5h12m0 0L9 1m4 4L9 9"/>
                    </svg>
                </button>
            </div>
            <ul class="items-center w-full text-sm font-medium bg-clockbg sm:flex">
                <li class="w-2/12" v-for="(team, index) in teams">
                    <div class="flex items-center pl-3">
                        <input @click="handleCheckbox" v-model="teamsToDisplay" :id="'vue-checkbox-list' + team.id" type="checkbox" :value="team.id" class="w-4 h-4 text-second-text focus:ring-blue-500" :disabled="index === 0 && 'disabled'">
                        <label :for="'vue-checkbox-list' + team.id" class="w-full py-2 ml-2 text-sm font-medium text-second-text">{{  team.name  }}</label>
                    </div>
                </li>
            </ul>
        </div>
        <GChart 
            :type="chartType"
            :data="chartData"
            :options="chartOptions"
        />
        <div class="flex items-center mb-2 mr-2">
            <span class="mr-4 text-second-text">Compare with clocks </span>
            <input @click="handleComboChart" v-model="isComboChart" id="'vue-checkbox-list-worked-hours" type="checkbox" class="w-4 h-4 text-second-text focus:ring-blue-500">
        </div>
    </div>
</template>

<style>

</style>