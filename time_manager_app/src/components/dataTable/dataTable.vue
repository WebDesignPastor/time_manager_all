<script>
  import Vue3EasyDataTable from 'vue3-easy-data-table';

  export default {
    name: 'DataTable',
    components: {
      Vue3EasyDataTable,
    },

    data() {
      return {
        teams: this.$store.state.currUser.managedTeams,
        isGeneral: this.$store.state.currUser.role === 'general_manager' ? true : false
      }
    },

    props: {
      items: Array,
      headers: Array,
      searchField: Array,
      searchValue: String,
      loading: Boolean,
      sortBy: String,
      managerList: Array
    },
    methods: {
      displayRoles(user) {
        if (user.role === 'employee') {
          return 'manager'
        } else {
          return 'employee'
        }
      },
      updateUserSelect(e, user, toUpdate) {
        this.$parent.updateUserSelect(e, user, toUpdate)
      },
      deleteUser(user) {
        if(this.$store.state.currentContent === 'Employes-dashboard') {
          this.$parent.deleteUser(user)
        }
      },
      createNewTeam() {
        if(this.$store.state.currentContent === 'Teams' && this.$store.state.currUser.role === 'manager') {
          this.$parent.createNewTeam()
        }
      }
    }
  }
</script>

<template>
  <div>
    <Vue3EasyDataTable
      :items="items"
      :headers="headers"
      :searchField="searchField"
      :searchValue="searchValue"
      :sortBy="sortBy"
      :loading="loading"
      :managerList="managerList"
      table-class-name="customize-table"
    >
      <template #item-username="item">
        <div>
          <button>{{ item.username }}</button>
        </div>
      </template>
      <template #item-teamsId="item">
        <div v-if="isGeneral">
          <p>{{ item.teamsId }}</p>
        </div>
        <div v-if="teams === null && this.$store.state.currUser.role === 'manager'">
          <p>0</p>
        </div>
        <div v-else-if="this.$store.state.currUser.role === 'manager'">
          <select @change="updateUserSelect($event, item, 'teams_id')" style="background-color: #B9C1B6;">
            <option selected>{{ item.teamsId }}</option>
            <option v-for="team in teams" :key="team">
              {{ team }}
            </option>
          </select>
        </div>
      </template>
      <template #item-role="item">
        <div v-if="this.$store.state.currUser.role == 'general_manager'">
          <div>
            <select @change="updateUserSelect($event, item, 'role')" style="background-color: #B9C1B6;">
              <option>{{item.role}}</option>
              <option>{{ displayRoles(item) }}</option>
            </select>
          </div>
        </div>
        <div v-else>
          <div>
            <span>{{ item.role }}</span>
          </div>
        </div>
      </template>
      <template #item-managerId="item">
        <div v-if="this.$store.state.currUser.role == 'general_manager' && this.$store.state.currentContent == 'Employes-dashboard'">
          <div v-if="item.role !== 'manager'">
            <select @change="updateUserSelect($event, item, 'manager_id')" style="background-color: #B9C1B6;">
              <option v-if="item.managerId !== null" selected>{{ managerList.filter((x) => x.id === item.managerId)[0].username }}</option>
              <option v-else selected></option>
              <option v-for="manager in managerList">{{ manager.username }}</option>
            </select>
          </div>
        </div>
      </template>
      <template #item-action="item">
          <button @click="deleteUser(item)">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-trash-2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
          </button>
      </template>
    </Vue3EasyDataTable>
  </div>
</template>

<style>
  .customize-table {
    --easy-table-header-background-color: #B9C1B6;
    --easy-table-body-row-background-color: #B9C1B6;
    --easy-table-footer-background-color: #B9C1B6;
    --easy-table-border: none;
    --easy-table-body-row-hover-background-color: none;
  }
</style>
