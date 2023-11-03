<template>
  <UserList @selectedUser="updateSelectedUser" msg="Select the User"/>
  <WorkingTimes :userId="selectedUserId" msg="User's working times"/>
  <UserProfile :userId="selectedUserId" msg="User Profile"/>

  <!-- <WorkingTime/>
  <ChartManager/>
  <ClockManager/> -->

</template>

<script>
// import ChartManager from './components/ChartManager.vue';
// import ClockManager from './components/ClockManager.vue';
import UserProfile from './components/UserProfile.vue';
// import WorkingTime from './components/WorkingTime.vue';
import WorkingTimes from './components/WorkingTimes.vue';
import UserList from'./components/UserList.vue';

export default {
  name: 'App',
  components: {
    UserProfile,
    // WorkingTime,
    WorkingTimes,
    UserList,
    // ChartManager,
    // ClockManager
},
  data() {
      return {
        selectedUserId: null
      };
  },
  methods: {
    updateSelectedUser(user) {
      this.selectedUserId = user.id;
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
