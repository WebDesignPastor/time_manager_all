<template>
  <div class="widget-user-list">
    <h1>{{ msg }}</h1>

    <!-- Dropdown menu for usernames -->
    <select v-model="selectedUser">
      <option v-for="user in userData" :key="user.id" :value="user">
        {{ user.username }}
      </option>
    </select>

    <!-- Display details for the selected user -->
    <div v-if="selectedUser">
      <p>Username: {{ selectedUser.username }}</p>
      <!-- You can add more user details here if needed -->
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'UserList',
  props: {
    msg: String
  },
  data() {
    return {
      userData: null,
      selectedUser: null  // To keep track of the selected user from the dropdown
    };
  },
  mounted() {
    this.fetchUserData();
  },
  watch: {
    selectedUser: function(newValue) {
      this.$emit('selectedUser', newValue);
    }
  },
  methods: {
    async fetchUserData() {
      try {
        const response = await axios.get('http://localhost:4000/api/users/');
        this.userData = response.data.data;
      } catch (error) {
        console.error("There was an error fetching the user data:", error);
      }
    }
  }
}
</script>

<style>
.widget-user-list{
  background-color: rgb(255, 251, 127);
  color: brown;
  width: 20%;
}</style>
