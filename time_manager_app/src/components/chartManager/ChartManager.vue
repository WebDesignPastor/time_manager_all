<script>
import DailyAverage from '../dailyAverage/DailyAverage.vue';
import EmployeeChart from '../employeeChart/employeeChart.vue';
import WeeklyAverage from '../weeklyAverage/WeeklyAverage.vue';


export default {
    name: 'ChartManager',
    components: { DailyAverage, WeeklyAverage, EmployeeChart }
}

</script>

<template>
    <div class="flex flex-col sm:flex-row w-full justify-between gap-6">
        <DailyAverage />
        <WeeklyAverage />
    </div>
    <div>
        <EmployeeChart />
    </div>

</template>

<style>

</style>
