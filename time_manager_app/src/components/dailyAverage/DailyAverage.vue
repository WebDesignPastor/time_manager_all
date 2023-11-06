<script>

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
                }
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
                'backgroundColor': {
                    'fill': 'BAB6C1',
                    'opacity': 100
                },
            }
        }
    }
}

</script>

<template>
    <div class="w-6/12 h-62 p-3 bg-clockbg rounded-3xl shadow flex flex-col">
        <div class="flex flex-col mx-2">
            <span class="m-0 mb-2 text-xl font-bold tracking-tight text-second-text">Daily average hours worked by teams :</span>
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
            type="AreaChart"
            :data="chartData"
            :options="chartOptions"
        />
    </div>
</template>

<style>

</style>
