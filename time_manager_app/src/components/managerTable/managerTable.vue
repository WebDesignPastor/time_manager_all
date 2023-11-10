<script>
import 'vue3-easy-data-table/dist/style.css';
import { ApiGet } from "../../utils/api.js";
import dataTable from '../dataTable/dataTable.vue';

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
            {text: "team", value: "teamsId", sortable: "true"},
        ],
        searchField: ["username", "email", "role", "teamsId"],
        searchValue: "",
        sortBy: "teamsId",
        loading: false
        }
    },
    created() {
        this.getUsers()
    },
    methods: {
        async getUsers() {
        this.loading = true
        this.items = await ApiGet('/users')
        this.loading = false
        },
    }
}
</script>

<template>
  <div class="w-full h-62 p-5 bg-summarybg rounded-3xl shadow flex flex-col" tabindex="0" aria-label="Team management array">
    <div class="flex">
      <span class="text-second-text">Search user: </span>
      <input type="text" v-model="searchValue" class="bg-summarybg border border-second-text text-second-text text-sm rounded-lg block w-52 h-7 ml-4 p-2.5" aria-label="search a user, input">
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
