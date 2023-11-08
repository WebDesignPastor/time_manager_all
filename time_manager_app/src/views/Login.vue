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
            isClickable: true
        }
    },
    methods: {
        async signIn(e) {
            e.preventDefault()
            if(this.email.length > 0 && this.password.length > 0) {
                this.isClickable = false
                let body = {
                    email: this.email,
                    password: this.password
                }
                let res = await ApiPost('/users/login', body)

                if (res.status === 200) {
                    //dispatch les infos users que je veux ici
                    this.isClickable = true
                    let userData = res.data
                    userData["isAuth"] = true
                    this.$store.dispatch('login', userData).then(() => this.$router.push('/'))
                }
            }
        },
        prevent(e) {
            e.preventDefault()
        }
    }
}


</script>

<template>
    <div class="wrapper sm:w-11/12 md:w-10/12 lg:w-9/12 xl:w-8/12 ">
        <Header />
        <div class="flex justify-center text-slate-950">
            <div class="w-full bg-secondary rounded-3xl md:mt-8 sm:max-w-md xl:p-0">
                <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
                    <h1 class="text-xl font-bold leading-tight tracking-tight md:text-2xl text-second-text">
                        Sign in to your account
                    </h1>
                    <form class="space-y-4 md:space-y-6" action="#">
                        <div>
                            <label for="email" class="block mb-2 text-sm font-medium text-second-text">Your email</label>
                            <input v-model="email" type="email" name="email" id="email" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" placeholder="name@company.com" required="">
                        </div>
                        <div>
                            <label for="password" class="block mb-2 text-sm font-medium text-second-text">Password</label>
                            <input v-model="password" type="password" name="password" id="password" placeholder="••••••••" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" required="">
                        </div>
                        <button v-on="isClickable ? { click: signIn } : { click: prevent}" class="w-full text-second-text bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center">Sign in</button>
                        <p class="text-sm font-light text-second-text">
                            Don’t have an account yet? <a href="#" class="font-medium text-second-text hover:underline">Sign up</a>
                        </p>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<style>
</style>