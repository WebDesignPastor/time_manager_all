<script>

import ChartManager from '../components/chartManager/ChartManager.vue';
import Header from '../components/header/Header.vue';
import Sidebar from '../components/sidebar/Sidebar.vue';
import UserDashboard from '../components/userDashboard/userDashboard.vue';
import ManagerTable from '../components/managerTable/managerTable.vue';

export default {
  name: 'Dashboard',
  components: { Header, Sidebar, UserDashboard, UserDashboard, ChartManager, ManagerTable },
  computed: {
    isDashboard() {
        return this.$store.state.currentContent === "Dashboard" ? true : false
    },
    isTeams() {
      return this.$store.state.currentContent === "Teams" ? true : false
    },
    isGraphs() {
        return this.$store.state.currentContent === "Graphs" ? true : false
    }
  }
}

</script>

<template>
    <div class="wrapper sm:w-11/12 md:w-10/12 lg:w-9/12 xl:w-8/12 2xl:w-7/12">
        <Header />
        <div class="content flex">
            <Sidebar />
            <div v-if="isDashboard" class="w-full mt-12">
                <UserDashboard />
            </div>
            <div v-if="isTeams" class="w-full mt-12">
              <ManagerTable/>
            </div>
            <div v-if="isGraphs" class="w-full mt-12">
                <ChartManager />
            </div>
        </div>
    </div>
</template>

<style>
</style>