<script>
import Clock from '../clock/Clock.vue';
import Summary from '../summary/Summary.vue';
import Random from '../random/Random.vue'
import Workingtime from '../workingtime/Workingtime.vue';
import DashboardGraph from '../dashboardGraph/DashboardGraph.vue';
import { customToolTip, workingTimeDataFormat } from '../../utils/chart'
import { getWeekFromDate } from '../../utils/date'
import { ApiGet } from '../../utils/api';

export default {
    name: 'UserDashboard',
    components: { Clock, Summary, Random, Workingtime, DashboardGraph },
    data() {
        return {
            chartData: [],
            bgColor: '#BFB293',
            isLoaded: false
        }
    },
    mounted() {
        let formatedDate = getWeekFromDate(new Date())
        let i = workingTimeDataFormat(this.$store.state.currUser.workingtimes, formatedDate['days'])
        this.chartData = i
        this.isLoaded = true
    },
    methods: {
    }
}
</script>

<template>
    <div class="w-full flex justify-between gap-6 flex-col sm:flex-row">
        <div class="w-full sm:w-4/12 sm:h-56 h-40 px-6 py-4 bg-summarybg rounded-3xl shadow flex flex-col justify-between">
            <Summary />
        </div>
        <div class="w-full sm:w-4/12 sm:h-56 h-40 px-6 py-4 bg-secondary rounded-3xl shadow flex flex-col justify-between">
            <Random />
        </div>
        <div class="w-full sm:w-4/12 h-56 px-6 py-4 bg-clockbg rounded-3xl shadow flex flex-col justify-between">
            <Clock />
        </div>
    </div>
    <div class=" flex flex-col md:flex-row gap-6 mt-6">
        <div v-if="isLoaded" class="w-full md:w-6/12 min-h-56 p-3 bg-graph-bg rounded-3xl shadow flex flex-col sm:mb-6 md:mb-0">
            <Workingtime :data="chartData" :bg-color="bgColor"/>
        </div>
        <div class="w-full md:w-6/12 h-full p-3 bg-graph-bg-2 rounded-3xl shadow flex flex-col mb-6 md:mb-0" tabindex="0" aria-label="TODO">
            <DashboardGraph />
        </div>
    </div>
</template>

<style>

</style>
