<script>

export default {
  name: 'Header',
  components: {},
  data() {
    return {
        username: this.$store.state.currUser.username != null ? this.$store.state.currUser.username : 'Se connecter',
        modalOpen: false,
        usernameForm: '',
        emailForm: '',
        passwordForm: ''
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
    updateUser() {
        let newData = {'username' : this.usernameForm, 'email' : this.emailForm,'password' : this.password}
    },
    toggleSidebar() {
    this.$store.commit('toggleSidebar');
  },
  }
}

</script>

<template>
    <header class="flex justify-between items-center max-w-7xl m-8">
        <div class="flex justify-between items-center">
            <div @onClick="" class="text-primary flex justify-center items-center rounded-full mr-12 p-2 text-3xl font-semibold w-11 h-11 border border-solid">
                <span>G</span>
            </div>
            <div>
                <h1 class="m-0 text-3xl font-normal text-white">Dashboard</h1>
            </div>
        </div>
        <div class="flex justify-between items-center" v-if="this.$router.currentRoute._value.path != '/login'">
            <div class="text-2xl mr-2 font-normal cursor-pointer" @click="modalOpen = true">
                <span>{{ username }}</span>
            </div>
            <div class="flex items-center [&>*]:w-9 [&>*]:h-9 [&>*]:cursor-pointer" @click="modalOpen = true">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M17.982 18.725A7.488 7.488 0 0012 15.75a7.488 7.488 0 00-5.982 2.975m11.963 0a9 9 0 10-11.963 0m11.963 0A8.966 8.966 0 0112 21a8.966 8.966 0 01-5.982-2.275M15 9.75a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
            </div>
        </div>
    </header>
    <div v-if="modalOpen" class="fixed w-full h-full z-50 bg-second-text bg-opacity-50 top-0 left-0 flex justify-center items-center">
        <div class="w-full bg-secondary rounded-3xl sm:max-w-md xl:p-0">
                <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
                    <div class="flex justify-between items-center">
                        <h1 class="text-xl font-bold leading-tight tracking-tight md:text-2xl text-second-text">
                            Update your account
                        </h1>
                        <div @click="modalOpen = false" class="text-second-text flex items-center cursor-pointer">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                    </div>
                    <form class="space-y-4 md:space-y-6" action="#">
                        <div>
                            <label for="emailForm" class="block mb-2 text-sm font-medium text-second-text">Your email</label>
                            <input v-model="emailForm" id="emailForm" type="email" name="emailForm" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" placeholder="name@company.com">
                        </div>
                        <div>
                            <label for="usernameForm" class="block mb-2 text-sm font-medium text-second-text">Your username</label>
                            <input v-model="usernameForm" id="usernameForm" type="text" name="usernameForm" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" placeholder="username">
                        </div>
                        <div>
                            <label for="passwordForm" class="block mb-2 text-sm font-medium text-second-text">Password</label>
                            <input v-model="passwordForm" id="passwordForm" type="password" name="passwordForm" placeholder="••••••••" class="bg-tertiary text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5">
                        </div>
                        <div class="flex flex-col">
                            <button @click="updateUser" type="button" class="text-red-700 hover:text-white border border-tertiary text-tertiary focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center my-2 hover:text-white hover:bg-tertiary">Update</button>
                            <button type="submit" class="text-second-text hover:text-danger focus:ring-4 focus:outline-none focus:ring-primary-300 rounded-lg text-xs px-5 py-2.5 text-center">Delete your account</button>
                        </div>
                    </form>
                </div>
            </div>
    </div>
</template>

<style>
</style>
