<script>
  import Vue3EasyDataTable from 'vue3-easy-data-table';

  export default {
    name: 'DataTable',
    components: {
      Vue3EasyDataTable,
    },

    props: {
      items: Array,
      headers: Array,
      searchField: Array,
      searchValue: String,
      loading: Boolean,
      sortBy: String,
    },

    methods: {
      deleteUser(user) {
        console.log(`deleted ${user}`)
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
      table-class-name="customize-table"
    >
    <template #item-username="item">
      <div>
        <button @click="console.log(`go to ${item.username} dashboard`)">{{ item.username }}</button>
      </div>
    </template>
    <template #item-teamsId="item">
      <div v-if="item.teamsId == null">
        <p>No team</p>
      </div>
      <div v-else>
        <select class="bg-clockbg">
          <option>{{ item.teamsId }}</option>
        </select>
      </div>
    </template>
    <template #item-role="item">
      <div v-if="this.$store.state.currUser.role == 'general_manager'">
        <div>
          <select class="bg-clockbg">
            <option value="">{{ item.role }}</option>
            <option value="">manager</option>
          </select>
        </div>
      </div>
      <div v-else>
        <p>{{ item.role }}</p>
      </div>
    </template>
    <template #item-action="item">
      <div v-if="this.$store.state.currUser.role == 'general_manager'">
        <button @click="deleteUser(item.username)">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-trash-2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
        </button>
      </div>
    </template>
    <template #empty-message>
      <p>No user corresponding</p>
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
  }
</style>