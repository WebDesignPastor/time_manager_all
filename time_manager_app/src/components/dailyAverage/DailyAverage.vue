<script>

import { toRaw } from 'vue'
import { GChart } from 'vue-google-charts'
import { formatDataDailyAverage } from '../../utils/chart'
import { ApiPost } from '../../utils/api'
import { getWeekFromDate } from '../../utils/date'

export default {
    name: 'DailyAverage',
    components: {
        GChart
    },
    data() {
        return {
            teams: [],
            teamsToDisplay: [1],
            teamsAlreadyDisplayed: [1],
            dateRangeStart: '',
            dateRangeEnd: '',
            isComboChart: false,
            chartData: [],  
            averageClocksHours: [],
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
            chartType: 'ColumnChart',
            showClock: false
        }
    },
    mounted() {
        this.init()
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
                        let newIndex = this.chartData[0].indexOf('Average hours worked')
                        let newObj = {}
                        newObj[newIndex - 1] = {type: 'line'}
                        this.chartOptions['series'] = newObj
                    }
                }
            }
        },
        async handleDatePicker(e) {
            if(this.dateRangeStart !== '') {
                let days = getWeekFromDate(new Date(this.dateRangeStart))
                let body = {
                    start: `${days['days'].firstDay}T00:00:01`,
                    end: `${days['days'].lastDay}T23:59:59`
                }
                let res = await ApiPost('/chartmanager', body, this.$store.state.token)
                if(res.status === 200) {
                    let val = formatDataDailyAverage(res.data.teams, new Date())
                    this.teams = val['teams']
                    this.chartData = val['chartData']
                    this.averageClocksHours = val['averageClocks']
                    this.teamsToDisplay = [1]
                    this.isComboChart = false
                    let toCheck = [...val['averageClocks']]
                    toCheck.shift()
                    if(toCheck.length > 0 && toCheck.reduce((i, j) => { return i + j}) !== 0) {
                        this.showClock = true
                    }
                }
            }
        },
        handleComboChart(e) {
            this.isComboChart = !this.isComboChart
            if(this.isComboChart) {
                // il faut qu'au click cela ajoute les datas necessaire pour transformer ca en combochart
                let currClocks = this.averageClocksHours
                let newData = toRaw(this.chartData)
                let newSeries = {}
                newSeries[newData[0].length - 1] = {type: 'line'}
                this.chartOptions['series'] = newSeries
                this.chartType = 'ComboChart'
                this.chartData.map((row, index) => {
                    newData[index][row.length] = currClocks[index]
                })
                this.chartData = newData
            } else {
                let indexToErease = this.chartData[0].indexOf('Average hours worked')
                let newData = []
                this.chartData.map((row) => {
                    newData.push(row.filter((data, idx) => idx !== indexToErease))
                })
                this.chartData = newData
                this.chartOptions['series'] = ''
                this.chartType = 'ColumnChart'
            }
        },
        async init() {
            let days = getWeekFromDate(new Date())
            let body = {
                start: `${days['days'].firstDay}T00:00:01`,
                end: `${days['days'].lastDay}T23:59:59`
            }
            let res = await ApiPost('/chartmanager', body, this.$store.state.token)
            if (res.status === 200) {
                let val = formatDataDailyAverage(res.data.teams, new Date())
                this.teams = val['teams']
                this.chartData = val['chartData']
                this.averageClocksHours = val['averageClocks']
                let toCheck = [...val['averageClocks']]
                toCheck.shift()
                if(toCheck.length > 0 && toCheck.reduce((i, j) => { return i + j}) !== 0) {
                    this.showClock = true
                }
            }
        }
    }
}

</script>

<template>
    <div class="w-full md:w-6/12 min-h-62 p-3 md:p-2 lg:p-3 bg-clockbg rounded-3xl shadow flex flex-col justify-between" aria-label="Graph with daily average hours worked by teams" tabindex="0">
        <span class="m-0 mb-2 text-xl font-bold tracking-tight text-second-text mx-2">Daily average hours worked by teams :</span>
        <div class="flex md:flex-col lg:flex-row mx-2">
            <div date-rangepicker class="flex items-center mr-4 justify-end mb-1" tabindex="0" aria-label="Selected range date">
                <div class="relative">
                    <input @change="handleDatePicker" required v-model="dateRangeStart" name="start" type="date" class="bg-second-text text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full pl-4 p-1.5" placeholder="Select date start" aria-label="Starting date">
                </div>
            </div>
            <ul v-if="teams.length > 0" class="items-center w-full text-sm font-medium bg-clockbg flex" tabindex="0" aria-label="Checkbox by team, press space to select">
                <li class="w-3/12 sm:w-2/12" v-for="(team, index) in teams">
                    <div class="flex items-center pl-3" v-if="team.id !== undefined">
                        <input @click="handleCheckbox" v-model="teamsToDisplay" :id="'vue-checkbox-list' + team.id" type="checkbox" :value="team.id" class="w-4 h-4 text-second-text focus:ring-blue-500" :disabled="index === 0 && 'disabled'" >
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
        <div class="flex items-center mb-2 sm:mr-2" v-if="showClock">
            <span class="mr-4 text-second-text">Compare with clocks </span>
            <input @click="handleComboChart" v-model="isComboChart" id="'vue-checkbox-list-worked-hours" type="checkbox" class="w-4 h-4 text-second-text focus:ring-blue-500" aria-label="Compare with clock">
        </div>
    </div>
</template>

<style>

</style>