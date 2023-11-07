<script>

import ChartManager from '../components/chartManager/ChartManager.vue';
import Header from '../components/header/Header.vue';
import Sidebar from '../components/sidebar/Sidebar.vue';
import UserDashboard from '../components/userDashboard/userDashboard.vue';

export default {
  name: 'Dashboard',
  components: { Header, Sidebar, UserDashboard, UserDashboard, ChartManager },
  computed: {
    isDashboard() {
        return this.$store.state.currentContent === "dashboard" ? true : false
    },
    isGraphs() {
        return this.$store.state.currentContent === "graphs" ? true : false
    }
  }
}

</script>

<template>
    <div class="wrapper">
        <Header />
        <div class="content flex">
            <Sidebar />
            <div v-if="isDashboard" class="w-full sm:mt-12">
                <UserDashboard />
            </div>
            <div v-if="isGraphs" class="w-full sm:mt-12">
                <ChartManager />
            </div>
        </div>
    </div>
</template>

<style>
.wrapper {
    width: 80vw;
}

@media(max-width: 640px){
  .wrapper {
    width: 100vw;
    padding: 20px;
  }
}
</style>
