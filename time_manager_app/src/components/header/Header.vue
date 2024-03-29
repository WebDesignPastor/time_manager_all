<script>
import { ApiPut, ApiDelete, ApiPost, ApiGet } from '../../utils/api'
import { firstLetterUpper } from '../../utils/utils'


export default {
  name: 'Header',
  components: {},
  data() {
    return {
        username: this.$store.state.currUser.username != null ? firstLetterUpper(this.$store.state.currUser.username) : 'Se connecter',
        modalOpen: false,
        usernameForm: '',
        emailForm: '',
        password: '',
        isResponsive: window.innerWidth > 1280 ? false : true
    }
  },
  mounted() {
    if(this.$router.currentRoute._value.path != '/login' && !this.$store.state.isAuth) {
        this.$router.push('/login')
    } else if(this.$router.currentRoute._value.path == '/login' && this.$store.state.isAuth) {
        this.$router.push('/')
    }
  },
  methods: {
    async updateUser() {
        let newData = {}
        if(this.emailForm !== '') {
            newData['email'] = this.emailForm
        }
        if(this.usernameForm !== '') {
            newData['username'] = this.usernameForm
        }
        if(this.password !== '') {
            const password = this.password;
            const encoder = new TextEncoder()
            const data = encoder.encode(password)
            const hash = await crypto.subtle.digest("SHA-256", data)
            const hashArray = Array.from(new Uint8Array(hash))
            const hashHex = hashArray.map((b) => b.toString(16).padStart(2, "0")).join("")
            newData['password'] = hashHex
        }
        if(Object.keys(newData).length > 0) {
            let res = await ApiPut(`/users/${this.$store.state.currUser.id}`, newData, this.$store.state.token)
            this.$store.dispatch('changeUpdateUser', res).then(() => {
                this.modalOpen = false
            })
        }
    },
    async deleteUser() {
        let res = await ApiDelete(`/users/${this.$store.state.currUser.id}`, this.$store.state.token)
        this.$store.dispatch('logout')
    },
    async logout() {
        let res = await ApiGet('/users/logout', this.$store.state.token).then(() => {
            this.$store.dispatch('logout').then(() => this.$router.push('/login'))
        })
    },
    handleNav() {
        if(this.$store.state.currUser.role === "employee") {
            this.$store.dispatch('changeContent', {newContent: 'Dashboard'})
        } else {
            this.$store.dispatch('changeNav')
        }
    }
  }
}

</script>

<template>
    <header class="flex justify-between items-center xl:w-full max-w-7xl sm:m-8 m-4">
        <div class="flex justify-between items-center">
            <button class="text-primary flex justify-center items-center rounded-full mr-4 sm:mr-12 p-2 text-3xl font-semibold w-11 h-11 border border-solid" tabindex="0" aria-label="Go to dashboard">
                <span v-if="this.$store.state.currUser.role !== null && this.$store.state.currUser.role === 'employee'">G</span>
                <svg @click="handleNav" class="cursor-pointer" v-else-if="this.$store.state.currUser.role !== null && this.$store.state.currUser.role != 'employee' && isResponsive" xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="28" height="28" viewBox="0 0 50 50" fill="none" stroke="currentColor">
                    <path d="M 0 9 L 0 11 L 50 11 L 50 9 Z M 0 24 L 0 26 L 50 26 L 50 24 Z M 0 39 L 0 41 L 50 41 L 50 39 Z"></path>
                </svg>
                <span v-else>G</span>
            </button>
            <div>
                <h1 v-if="this.$store.state.currentContent !== 'Employes-dashboard'" class="m-0 text-2xl sm:text-3xl font-normal text-white">{{ this.$store.state.currentContent }}</h1>
                <h1 v-else class="m-0 text-lg sm:text-3xl font-normal text-white">{{ this.$store.state.currentContent }}</h1>
            </div>
        </div>
        <div class="flex justify-between items-center" v-if="this.$router.currentRoute._value.path != '/login'">
            <div class="text-xl sm:text-2xl mr-2 font-normal cursor-pointer" @click="modalOpen = true">
                <span>{{ username }}</span>
            </div>
            <button class="flex items-center [&>*]:w-9 [&>*]:h-9 [&>*]:cursor-pointer" @click="modalOpen = true" aria-label="Account settings">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M17.982 18.725A7.488 7.488 0 0012 15.75a7.488 7.488 0 00-5.982 2.975m11.963 0a9 9 0 10-11.963 0m11.963 0A8.966 8.966 0 0112 21a8.966 8.966 0 01-5.982-2.275M15 9.75a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
            </button>
        </div>
    </header>
    <div v-if="modalOpen" class="fixed w-full h-full z-50 bg-second-text bg-opacity-50 top-0 left-0 flex justify-center items-center" >
        <div class="w-full bg-secondary rounded-3xl sm:max-w-md xl:p-0">
                <div class="p-6 space-y-4 md:space-y-6 sm:p-8" tabindex="0" aria-labelled="Update your account">
                    <div class="flex justify-between items-center">
                        <h1 class="text-xl font-bold leading-tight tracking-tight md:text-2xl text-second-text">
                            Manage your account
                        </h1>
                        <div @click="modalOpen = false" class="text-second-text flex items-center cursor-pointer">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                    </div>
                    <form class="space-y-4 md:space-y-6" action="#">
                        <div class="flex flex-col w-full items-center">
                            <button @click="logout" type="button" class="w-full hover:text-white border border-tertiary text-tertiary focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center hover:text-white hover:bg-tertiary">Logout</button>
                        </div>
                        <div>
                            <label for="emailForm" class="block mt-2 mb-2 text-sm font-medium text-second-text">Your email</label>
                            <input v-model="emailForm" id="emailForm" type="email" name="emailForm" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" placeholder="name@company.com">
                        </div>
                        <div>
                            <label for="usernameForm" class="block mb-2 text-sm font-medium text-second-text">Your username</label>
                            <input v-model="usernameForm" id="usernameForm" type="text" name="usernameForm" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" placeholder="username">
                        </div>
                        <div>
                            <label for="password" class="block mb-2 text-sm font-medium text-second-text">Your password</label>
                            <input v-model="password" type="password" name="password" id="password" placeholder="••••••••" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 text-white" required="" aria-label="enter your password">
                        </div>
                        <div class="flex flex-col">
                            <button @click="updateUser" type="button" class="text-red-700 hover:text-white border border-tertiary text-tertiary focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 hover:text-white hover:bg-tertiary">Update</button>
                            <button @click="deleteUser" type="submit" class="text-second-text hover:text-danger focus:ring-4 focus:outline-none focus:ring-primary-300 rounded-lg text-xs px-2 py-2.5 text-center">Delete your account</button>
                        </div>
                    </form>
                </div>
            </div>
    </div>
</template>

<style>
</style>
