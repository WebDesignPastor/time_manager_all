<script>
import 'vue3-easy-data-table/dist/style.css';
import { ApiDelete, ApiGet, ApiPut } from "../../utils/api.js";
import dataTable from '../dataTable/dataTable.vue';

export default {
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
        {text: "manager", value: "managerId"},
        {text: "action", value: "action"}
      ],
      searchField: ["username", "email", "role", "teamsId"],
      searchValue: "",
      sortBy: "teamsId",
      loading: false,
      managerList: null
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
      if(this.$store.state.currUser.role == 'general_manager' && this.$store.state.currentContent == 'Employes-dashboard') {
        let managerList = this.items.filter((x) => x.role === 'manager')
        this.managerList = managerList
      }
    },
    async updateUserSelect(e, user, toUpdate) {

      this.loading = true

      let body = {}

      if(toUpdate === 'role') {
        body[toUpdate] = e.target.value
      } else if(toUpdate === 'manager_id') {
        body[toUpdate] = this.items.filter((x) => x.username === e.target.value)[0].id
      }

      let res = await ApiPut(`/users/${user.id}`, body, this.$store.state.token)
      console.log(res)
      let upateIndex = this.items.findIndex((x) => x.id === res.id)
      let updateItems = this.items.filter((x) => x.id !== res.id)
      let newItems = [
        ...updateItems.slice(0, upateIndex),
        res,
        ...updateItems.slice(upateIndex)
      ]
      this.items = newItems
      this.loading = false
    },
    async deleteUser(user) {
      this.loading = true
      let res = await ApiDelete(`/users/${user.id}`, this.$store.state.token)
      let updateItems = this.items.filter((x) => x.id !== user.id)
      this.items = updateItems
      alert('The user ' + user.email + ' has been deleted.')
      this.loading = false
    }
  }
  }
</script>

<template>
  <div class="w-full h-62 p-5 bg-summarybg rounded-3xl shadow flex flex-col">
    <div class="flex">
      <span class="text-second-text">Search user: </span>
      <input type="text" v-model="searchValue" class="bg-summarybg border border-second-text text-second-text text-sm rounded-lg block w-52 h-7 ml-4 p-2.5">
    </div>
    <dataTable
      :headers="headers"
      :items="items"
      :search-field="searchField"
      :search-value="searchValue"
      :sortBy="sortBy"
      :loading="loading"
      :manager-list="managerList"
    />
  </div>
</template>
