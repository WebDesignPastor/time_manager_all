<script>

import Header from '../components/header/Header.vue';
import {ApiPost} from '../utils/api'

export default {
    name: 'Login',
    components: { Header },
    data() {
        return {
            email: '',
            password: '',
            username: '',
            isClickable: true,
            isLoginPage: true
        }
    },
    methods: {
        async signIn(e) {
            e.preventDefault()
            if(this.email.length > 0 && this.password.length > 0) {
                this.isClickable = false

                const password = this.password;
                const encoder = new TextEncoder()
                const data = encoder.encode(password)
                const hash = await crypto.subtle.digest("SHA-256", data)
                const hashArray = Array.from(new Uint8Array(hash))
                const hashHex = hashArray.map((b) => b.toString(16).padStart(2, "0")).join("")

                let body = {
                    email: this.email,
                    password: this.password
                }
                let res = await ApiPost('/users/login', body)

                if (res.status === 200) {
                    this.isClickable = true
                    let userData = res.data
                    userData["isAuth"] = true
                    this.$store.dispatch('login', userData).then(() => this.$router.push('/'))
                } else {
                    this.isClickable = true
                }
            }
        },
        prevent(e) {
            e.preventDefault()
        },
        setPage(e) {
            e.preventDefault()
            this.isLoginPage = !this.isLoginPage
        },
        async createAcc(e) {
            // hash password
            e.preventDefault()
            if(this.email.length > 0 && this.password.length > 0 && this.username.length > 0) {
                this.isClickable = false

                const password = this.password;
                const encoder = new TextEncoder()
                const data = encoder.encode(password)
                const hash = await crypto.subtle.digest("SHA-256", data)
                const hashArray = Array.from(new Uint8Array(hash))
                const hashHex = hashArray.map((b) => b.toString(16).padStart(2, "0")).join("")

                let body = {
                    email: this.email,
                    password: hashHex,
                    username: this.username
                }
                let res = await ApiPost('/users', body)
                
                if (res.status === 201) {
                    this.isLoginPage = true
                    this.isClickable = false
                }
            }
        }
    }
}


</script>

<template>
    <div class="wrapper w-full sm:w-11/12 md:w-10/12 lg:w-9/12 xl:w-8/12 ">
        <Header />
        <div class="flex justify-center text-slate-950">
            <div class="w-11/12 sm:w-full bg-secondary rounded-3xl md:mt-8 sm:max-w-md xl:p-0 mt-14 mx-1 sm:mx-0">
                <div v-if="isLoginPage" class="p-6 space-y-4 md:space-y-6 sm:p-8" tabindex="0" aria-label="Sign in to your account">
                    <h1 class="text-xl font-bold leading-tight tracking-tight md:text-2xl text-second-text">
                        Login to your account
                    </h1>
                    <form class="space-y-4 md:space-y-6" action="#">
                        <div>
                            <label for="email" class="block mb-2 text-sm font-medium text-second-text">Your email</label>
                            <input v-model="email" type="email" name="email" id="email" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 text-white" placeholder="name@company.com" required="" aria-label="enter your email">
                        </div>
                        <div>
                            <label for="password" class="block mb-2 text-sm font-medium text-second-text">Password</label>
                            <input v-model="password" type="password" name="password" id="password" placeholder="••••••••" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 text-white" required="" aria-label="enter your password">
                        </div>
                        <button v-on="isClickable ? { click: signIn } : { click: prevent}" class="w-full text-second-text bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center">Sign in</button>
                        <p class="text-sm font-light text-second-text">
                            Don’t have an account yet? <a href="#" @click="setPage" class="font-medium text-second-text hover:underline">Sign up</a>
                        </p>
                    </form>
                </div>
                <div v-else class="p-6 space-y-4 md:space-y-6 sm:p-8" tabindex="0" aria-label="Sign in to your account">
                    <h1 class="text-xl font-bold leading-tight tracking-tight md:text-2xl text-second-text">
                        Create your account
                    </h1>
                    <form class="space-y-4 md:space-y-6" action="#">
                        <div>
                            <label for="username" class="block mb-2 text-sm font-medium text-second-text">Your username</label>
                            <input v-model="username" id="username" type="text" name="usernameForm" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 text-white" placeholder="username">
                        </div>
                        <div>
                            <label for="email" class="block mb-2 text-sm font-medium text-second-text">Your email</label>
                            <input v-model="email" type="email" name="email" id="email" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 text-white" placeholder="name@company.com" required="" aria-label="enter your email">
                        </div>
                        <div>
                            <label for="password" class="block mb-2 text-sm font-medium text-second-text">Password</label>
                            <input v-model="password" type="password" name="password" id="password" placeholder="••••••••" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 text-white" required="" aria-label="enter your password">
                        </div>
                        <button v-on="isClickable ? { click: createAcc } : { click: prevent}" class="w-full text-second-text bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center">Sign in</button>
                        <p class="text-sm font-light text-second-text">
                            Already have a account ? <a href="#" @click="setPage" class="font-medium text-second-text hover:underline">Login</a>
                        </p>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<style>
</style>
