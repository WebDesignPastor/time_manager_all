<script>
import Clock from '../clock/Clock.vue';
import Summary from '../summary/Summary.vue';
import Random from '../random/Random.vue'
import Workingtime from '../workingtime/Workingtime.vue';
import DashboardGraph from '../dashboardGraph/DashboardGraph.vue';

export default {
    name: 'UserDashboard',
    components: { Clock, Summary, Random, Workingtime, DashboardGraph },
    data() {
        return {
        }
    }
}
</script>

<template>
    <div class="flex flex-col sm:flex-row w-full justify-between gap-6">
        <Summary />
        <Random />
        <Clock />
    </div>
    <div class="flex flex-col sm:flex-row w-full justify-between gap-6 mt-8">
        <Workingtime />
        <DashboardGraph />
    </div>
</template>

<style>

</style>
