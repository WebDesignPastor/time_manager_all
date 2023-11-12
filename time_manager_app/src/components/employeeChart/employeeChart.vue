<script>

import Clock from '../clock/Clock.vue';
import Summary from '../summary/Summary.vue';
import Random from '../random/Random.vue'
import Workingtime from '../workingtime/Workingtime.vue';
import DashboardGraph from '../dashboardGraph/DashboardGraph.vue';
import { customToolTip, workingTimeDataFormat } from '../../utils/chart'
import { ApiGet, ApiPost } from '../../utils/api';
import { getWeekFromDate } from '../../utils/date'

export default {
    name: 'EmployeeChart',
    components: { Clock, Summary, Random, Workingtime, DashboardGraph },
    mounted() {
        this.getAllUsers().then(() => {
            this.usersList = this.$store.state.usersList
        })
    },
    data() {
        return {
            isInitialized: false,
            chartData: [
                ['day', 'shift', 'b', 'c', 'd', {type:'string',role:'tooltip'}],
                ['Mon', 8, 18, 8, 18, customToolTip(8, 18)],
                ['Tue', 7, 15, 7, 15, customToolTip(7, 15)],
                ['Wed', 8, 15, 8, 15, customToolTip(8, 15)],
                ['Thu', null, null, null, null, customToolTip(0, 0)],
                ['Fri', 10, 19, 10, 19, customToolTip(10, 19)]
            ],
            bgColor: '#B9C1B6',
            modalOpen: false,
            workingHours: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
            modalDatepicker: null,
            modalStartHour: null,
            modalEndHour: null,
            isError: false,
            errorMessage: '',
            usersList: null,
            userIdView: null,
            isUserDashboard: false,
            bgColor2: '#BFB293',
        }
    },
    methods: {
        async getAllUsers() {
            this.$store.state.usersList = await ApiGet('/users', this.$store.state.token)
        },
        async employeeView(e) {
            this.isInitialized = false
            this.userIdView = e.target.value
            let formatedDate = getWeekFromDate(new Date())
            let newUrl = formatedDate['url']
            let res = await ApiGet(`/workingtimes/${this.userIdView}?${newUrl}`, this.$store.state.token)
            let toDisplay = workingTimeDataFormat(res, formatedDate['days'])
            this.chartData = toDisplay
            this.$store.dispatch('changeFocus', this.userIdView)
            if(this.isUserDashboard) {
                this.$store.dispatch('changeFocusDashboard').then(() => {
                        this.isUserDashboard = false
                })
            }
            this.isInitialized = true
        },
        modalOpener() {
            this.modalOpen = !this.modalOpen
        },
        errorHandler() {
            this.isError = !this.isError
        },
        async handleCreateWorkingtime() {
            if(this.modalDatepicker !== null) {
                if(this.modalEndHour !== null && this.modalStartHour !== null) {
                    if(this.modalEndHour > this.modalStartHour) {
                        let start = ''
                        let end = ''
                        if (this.modalStartHour < 10) {
                            start = `${this.modalDatepicker}T0${this.modalStartHour}:00:00`
                        } else {
                            start = `${this.modalDatepicker}T${this.modalStartHour}:00:00`
                        }
                        if (this.modalEndHour < 10) {
                            end = `${this.modalDatepicker}T0${this.modalEndHour}:00:00`
                        } else {
                            end = `${this.modalDatepicker}T${this.modalEndHour}:00:00`
                        }
                        let body = {
                            start: start,
                            end: end,
                        }
                        let userId = this.$store.state.userFocus.id
                        let res = await ApiPost(`/workingtimes/${userId}`, body, this.$store.state.token)
                        this.modalOpen = false
                    } else if (this.modalEndHour < this.modalStartHour) {
                        // display error msg
                        this.errorMessage = 'End hour must be after the start one.'
                        this.isError = true
                    }
                }
            } else {
                this.errorMessage = 'You must select a date'
                this.isError = true
            }
        },
        async viewEmployeeDashboard() {
            if(!this.isUserDashboard) {
                let res = await ApiGet(`/users/${this.$store.state.userFocus.id}`, this.$store.state.token)
                this.$store.dispatch('changeUserFocus', res).then(() => {
                    this.$store.dispatch('changeFocusDashboard').then(() => {
                        this.isUserDashboard = true
                    })
                })
            } else {
                this.$store.dispatch('changeFocusDashboard').then(() => {
                    this.isUserDashboard = false
                })
            }
        }
    }
}


</script>

<template>
    <div class="w-full px-6 py-4 bg-summarybg rounded-3xl shadow flex flex-col mt-6 mb-8">
        <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center mb-4">
            <span class="text-second-text ml-2 text-xl font-bold">Employee working hours chart</span>
            <div class="mt-2 sm:mt-0">
                <select id="employee" @change="employeeView" class="bg-second-text text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5">
                <option :value="null" aria-label="Selected country"></option>
                <option v-for="user in usersList" :value="user.id">{{ user.email }}</option>
                </select>
                <!-- Gestion l'accessibilité des injections  -->
            </div>
        </div>
        <div class="w-full flex justify-between items-center flex-col sm:flex-row" v-if="isInitialized">
            <div class="w-full sm:w-6/12 mt-4 sm:mt-0">
                <Workingtime :bg-color="bgColor" :data="chartData" />
            </div>
            <div class="w-full sm:w-6/12 flex justify-center items-center flex-col mt-4 sm:mt-0">
                <div>
                    <button type="button" @click="modalOpener" class="text-red-700 hover:text-white border border-tertiary text-tertiary focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 hover:text-white hover:bg-second-text">Create a new working time</button>
                </div>
                <div>
                    <button type="button" @click="viewEmployeeDashboard" class="text-red-700 hover:text-white border border-tertiary text-tertiary focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 hover:text-white hover:bg-second-text">{{ isUserDashboard ? 'Close employee dashboard' : 'View full employee dashboard' }}</button>
                </div>
            </div>
        </div>
        <div class="w-full flex justify-center text-second-text text-xl mt-12 mb-12" v-else>
            <span>Select an employee</span>
        </div>
        <div v-if="isUserDashboard" class="w-full py-2 sm:py-4 bg-summarybg flex flex-col gap-6 mt-4">
            <div class="flex gap-6 flex-col sm:flex-row">
                <div class="w-full sm:w-6/12 h-56 px-6 py-4 bg-graph-bg rounded-3xl shadow flex flex-col justify-between">
                    <Random />
                </div>
                <div class="w-full sm:w-6/12 h-56 p-3 bg-graph-bg-2 rounded-3xl shadow flex flex-col mb-6 md:mb-0 justify-between">
                    <Clock />
                </div>
            </div>
        </div>
        <div v-if="modalOpen" class="fixed w-full h-full z-50 bg-second-text bg-opacity-50 top-0 left-0 flex justify-center items-center">
            <div class="w-full bg-secondary rounded-3xl sm:max-w-md xl:p-0 m-2 sm:m-0">
                    <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
                        <div class="flex justify-between items-center">
                            <h1 class="text-xl font-bold leading-tight tracking-tight md:text-2xl text-second-text">
                                Add Workingtime
                            </h1>
                            <div @click="modalOpener" class="text-second-text flex items-center cursor-pointer">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                            </div>
                        </div>
                        <form class="space-y-4 md:space-y-6" action="#">
                            <div v-if="isError" class="bg-danger px-4 py-3 rounded relative" role="alert">
                                <span class="block sm:inline">{{ errorMessage }}</span>
                                <span @click="errorHandler" class="absolute top-0 bottom-0 right-0 px-4 py-3">
                                    <svg class="fill-current h-6 w-6 text-red-500" role="button" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><title>Close</title><path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"/></svg>
                                </span>
                            </div>
                            <div>
                                <label for="workingtime-datepicker" class="block mb-2 text-sm font-medium text-second-text">Select the day</label>
                                <input v-model="modalDatepicker" datepicker type="date" id="workingtime-datepicker" class="bg-tertiary text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5" placeholder="Select date">
                            </div>
                            <div class="flex gap-6">
                                <div class="w-6/12">
                                    <label for="workingtime-start-hour" class="block mb-2 text-sm font-medium text-second-text">Start hour</label>
                                    <select v-model="modalStartHour" id="workingtime-start-hour" class="bg-tertiary w-full text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5">
                                        <option v-for="hour in workingHours" :value="hour">
                                            {{ hour }}
                                        </option>
                                    </select>
                                </div>
                                <div class="w-6/12">
                                    <label for="workingtime-end-hour" class="block mb-2 text-sm font-medium text-second-text">End hour</label>
                                    <select v-model="modalEndHour" id="workingtime-end-hour" class="bg-tertiary w-full text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5">
                                        <option v-for="hour in workingHours" :value="hour">
                                            {{ hour }}
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="flex flex-col">
                                <button @click="handleCreateWorkingtime" type="button" class="text-red-700 hover:text-white border border-tertiary text-tertiary focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 hover:text-white hover:bg-tertiary">Create</button>
                            </div>
                        </form>
                    </div>
            </div>
        </div>
    </div>
</template>

<style>

</style>
