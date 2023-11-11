<script>

import ChartManager from '../components/chartManager/ChartManager.vue';
import Header from '../components/header/Header.vue';
import Sidebar from '../components/sidebar/Sidebar.vue';
import UserDashboard from '../components/userDashboard/userDashboard.vue';
import ManagerTable from '../components/managerTable/managerTable.vue';
import GeneralManagerTable from '../components/generalManagerTable/generalManagerTable.vue';

export default {
  name: 'Dashboard',
  components: { Header, Sidebar, UserDashboard, UserDashboard, ChartManager, ManagerTable, GeneralManagerTable },
  computed: {
    isDashboard() {
        return this.$store.state.currentContent === "Dashboard" ? true : false
    },
    isTeams() {
      return this.$store.state.currentContent === "Teams" ? true : false
    },
    isGraphs() {
        return this.$store.state.currentContent === "Graphs" ? true : false
    },
    isEmployesDashboard() {
        return this.$store.state.currentContent === "Employes-dashboard" ? true : false
    }
  }
}

</script>

<template>
    <div class="wrapper w-full sm:w-11/12 md:w-10/12 lg:w-9/12 xl:w-8/12 2xl:w-7/12">
        <Header />
        <div class="flex">
            <Sidebar />
            <div v-if="isDashboard" class="w-full mt-6 sm:mt-12 p-2 sm:p-0">
                <UserDashboard />
            </div>
            <div v-if="isTeams" class="w-full mt-6 sm:mt-12 p-2 sm:p-0">
              <ManagerTable/>
            </div>
            <div v-if="isGraphs" class="w-full mt-6 sm:mt-12 p-2 sm:p-0">
                <ChartManager />
            </div>
            <div v-if="isEmployesDashboard" class="w-full mt-6 sm:mt-12 p-2 sm:p-0">
                <GeneralManagerTable/>
            </div>
        </div>
    </div>
</template>

<style>
</style>
