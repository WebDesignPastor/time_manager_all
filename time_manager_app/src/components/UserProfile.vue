<template>
  <div class="widget-user-profile">
    <h1>{{ msg }}</h1>
    <div v-if="userData">
      <p>Username: {{ userData.username }}</p>
      <p>Email: {{ userData.email }}</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'UserProfile',
  props: {
    msg: String,
    userId: {
      type: Number,
      default: null
    }
  },
  data() {
    return {
      userData: null
    };
  },
  watch: {
    userId: function(newValue) {
      if (newValue) {
        this.fetchUserData(newValue);
      }
    }
  },
  methods: {
    async fetchUserData(userId) {
      try {
        const response = await axios.get(`http://52.47.210.151:4000/api/users/${userId}`);
        this.userData = response.data.data;
      } catch (error) {
        console.error("There was an error fetching the user data:", error);
      }
    }
  }
}
</script>

<style>
.widget-user-profile {
  background-color: rgb(172, 255, 127);
  width: 20%;
  color: aqua;
}
</style>
