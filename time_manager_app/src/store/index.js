import { createStore } from "vuex";

export default createStore({
    state () {
        return {
            currentContent: "Dashboard",
            token: null,
            isAuth: false,
            currUser: {
                "id": null,
                "username": null,
                "email": null,
                "role": null,
                "clock": null,
                "workingtimes": null,
                "managedTeams": null
            },
            currWeekDisplayed: null,
            usersList: null,
            isNavOpen: false,
            userFocus: {
                "id": null,
                "username": null,
                "email": null,
                "role": null,
                "clock": null,
                "workingtimes": null
            },
            isUserFocusDashboard: false
        }
    },
    mutations: {
        setCurrentContent (state, payload) {
            state.currentContent = payload.newContent
        },
        setSignIn (state, payload) {
            state.isAuth = true
            state.currUser.id = payload.id
            state.currUser.username = payload.username
            state.currUser.email = payload.email
            state.currUser.role = payload.role
            state.currUser.clock = payload.clock
            state.currUser.workingtimes = payload.workingTimes
            state.currUser.managedTeams = payload.managedTeams
            state.token = payload.token
            state.currentContent = "Dashboard"
        },
        setCurrWeek(state, payload) {
            state.currWeekDisplayed = payload
        },
        resetState(state) {
            state.currentContent = 'Dashboard'
            state.token = null
            state.isAuth = false
            state.currUser = {
                "id": null,
                "username": null,
                "email": null,
                "role": null,
                "clock": null,
                "workingtimes": null,
                "managedTeams": null
            },
            state.currWeekDisplayed = null,
            state.usersList = null,
            state.isNavOpen = false,
            state.userFocus = null
        },
        setClock(state, payload) {
            state.currUser.clock = payload
        },
        setNav(state) {
            state.isNavOpen = !state.isNavOpen
        },
        setUserFocusId(state, payload) {
            state.userFocus.id = payload
        },
        setUserFocus(state, payload) {
            state.userFocus.username = payload.username
            state.userFocus.email = payload.email
            state.userFocus.role = payload.role
            state.userFocus.clock = payload.clock
            state.userFocus.workingtimes = payload.workingTimes
        },
        setUpdateUser(state, payload) {
            state.currUser.username = payload.username
            state.currUser.email = payload.email
        },
        setFocusClock(state, payload) {
            state.userFocus.clock = payload
        },
        setIsUserDashboard (state) {
            state.isUserFocusDashboard = !state.isUserFocusDashboard
        },
        setUserList (state, payload) {
            state.usersList = payload
        },
        setManagedTeams (state, payload) {
            state.currUser.managedTeams = payload
        }
    },
    actions: {
        changeContent ({ commit },payload) {
            commit('setCurrentContent', payload)
        },
        login ({ commit }, payload) {
            commit('setSignIn', payload)
        },
        changeWeek ({ commit }, payload) {
            commit('setCurrWeek', payload)
        },
        logout ({ commit }) {
            commit('resetState')
        },
        changeClock ({ commit }, payload) {
            commit('setClock', payload)
        },
        changeNav ({ commit }) {
            commit('setNav')
        },
        changeFocus ({ commit }, payload) {
            commit('setUserFocusId', payload)
        },
        changeUpdateUser ({ commit }, payload) {
            commit('setUpdateUser', payload)
        },
        changeUserFocus ({ commit }, payload) {
            commit('setUserFocus', payload)
        },
        changeFocusClock ({ commit }, payload) {
            commit('setFocusClock', payload)
        },
        changeFocusDashboard ({ commit }) {
            commit('setIsUserDashboard')
        },
        changeUserList ({ commit }, payload) {
            commit('setUserList', payload)
        },
        changeManagedTeams ({ commit }, payload) {
            commit('setManagedTeams', payload)
        }
    }
})
