<script>
import 'vue3-easy-data-table/dist/style.css';
import { ApiGet, ApiPut } from "../../utils/api.js";
import dataTable from '../dataTable/dataTable.vue';
import {toRaw} from 'vue'

export default {
    name: 'ManagerTable',
    components: {
        dataTable,
    },
    data() {
        return {
          items: [],
          headers: [
              {text: "Username", value: "username"},
              {text: "Email", value: "email"},
              {text: "Role", value: "role"},
              {text: "team", value: "teamsId", sortable: "true"}
          ],
          searchField: ["username", "email", "role", "teamsId"],
          searchValue: "",
          sortBy: "teamsId",
          loading: false
        }
    },

    created() {
      this.init()
  },

  methods: {
    async init() {
      let res = await ApiGet('/users', this.$store.state.token)
      let items = res.filter((user) => user.role !== 'general_manager')
      this.items = items
    },
    async updateUserSelect(e, user, toUpdate) {
      this.loading = true
      let body = {}
      body[toUpdate] = e.target.value
      
      let res = await ApiPut(`/users/${user.id}`, body, this.$store.state.token)
      
      this.loading = false
    },
    async createNewTeam() {
      this.loading = true 
      
      let body = {}

      let managedTeamsToUpdate = this.$store.state.currUser.managedTeams

      if(this.$store.state.currUser.managedTeams !== null) {
        let newTeamId = managedTeamsToUpdate[this.$store.state.currUser.managedTeams.length - 1] + 1
        let teamToSend = toRaw(managedTeamsToUpdate)
        teamToSend.push(newTeamId)
        body['managed_teams'] = teamToSend
      } else {
        body['managed_teams'] = [1]
      }
      let res = await ApiPut(`/users/${this.$store.state.currUser.id}`, body, this.$store.state.token)
      this.$store.dispatch('changeManagedTeams', res.managedTeams)

      this.loading = false
    }
  }
}
</script>

<template>
  <div class="w-full h-62 p-5 bg-summarybg rounded-3xl shadow flex flex-col" tabindex="0" aria-label="Team management array">
    <div class="flex justify-between">
      <div class="flex">
        <span class="text-second-text hidden sm:block">Search user: </span>
        <input type="text" v-model="searchValue" class="bg-summarybg border border-second-text text-second-text text-sm rounded-lg block w-32 sm:w-52 h-7 sm:ml-4 p-2.5" aria-label="search a user, input">
      </div>
      <div class="flex text-second-text items-center" @click="createNewTeam" v-if="this.$store.state.currUser.role === 'manager'">
        <span class="mr-2">Create a team</span>
        <button class="flex items-center">
          <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="18" height="18" viewBox="0 0 50 50">
            <path d="M 25 2 C 12.309295 2 2 12.309295 2 25 C 2 37.690705 12.309295 48 25 48 C 37.690705 48 48 37.690705 48 25 C 48 12.309295 37.690705 2 25 2 z M 25 4 C 36.609824 4 46 13.390176 46 25 C 46 36.609824 36.609824 46 25 46 C 13.390176 46 4 36.609824 4 25 C 4 13.390176 13.390176 4 25 4 z M 24 13 L 24 24 L 13 24 L 13 26 L 24 26 L 24 37 L 26 37 L 26 26 L 37 26 L 37 24 L 26 24 L 26 13 L 24 13 z"></path>
          </svg>
        </button>
      </div>
    </div>
    <dataTable
      :headers="headers"
      :items="items"
      :search-field="searchField"
      :search-value="searchValue"
      :sortBy="sortBy"
      :loading="loading"
    />
  </div>
</template>
