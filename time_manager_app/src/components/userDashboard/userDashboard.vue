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
    <div class="w-full flex justify-between gap-6">
        <Summary />
        <Random />
        <Clock />
    </div>
    <div class="w-full flex justifybetween gap-6 mt-6">
        <Workingtime />
        <DashboardGraph />
    </div>
</template>

<style>

</style>