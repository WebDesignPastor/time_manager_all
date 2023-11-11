import { createApp } from 'vue'
import './style.css'
import './index.css'
import App from './App.vue'
import store from './store'
import router from './router'
import Vue3EasyDataTable from 'vue3-easy-data-table';
import 'vue3-easy-data-table/dist/style.css';

createApp(App).use(router).use(store).component('EasyDataTable', Vue3EasyDataTable).mount('#app')
