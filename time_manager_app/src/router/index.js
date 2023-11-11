import Dashboard from '../views/Dashboard.vue'
import Login from '../views/Login.vue'
import ErrorPage from '../views/Error.vue'
import { createRouter, createWebHistory } from 'vue-router'

const routes = [
    {
        path: '/',
        name: 'dashboard',
        component: Dashboard
    },
    {
        path: '/login',
        name: 'login',
        component: Login
    },
    {
        path: "/:pathMatch(.*)*" ,
        name: "PageNotFound",
        component: ErrorPage
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router
