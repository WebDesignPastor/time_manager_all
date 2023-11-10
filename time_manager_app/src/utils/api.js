import axios from "axios"

let apiUrl = import.meta.env.VITE_BASE_API_URL

export const ApiGet = async (url, token) => {
    let isAuthNeeded = false
    if(token !== null && token !== undefined) {
        isAuthNeeded = true
    }
    if(isAuthNeeded) {
        let config = {
            headers: { Authorization: `Bearer ${token}` }
        }
        return await axios.get(apiUrl + url, config)
        .then(res => res.data)
        .catch(err => console.log(err))
    } else {
        return await axios.get(apiUrl + url)
        .then(res => res.data)
        .catch(err => console.log(err))
    }
}

export const ApiPost = async (url, body, token) => {
    let isAuthNeeded = false
    if(token !== null && token !== undefined) {
        isAuthNeeded = true
    }
    if(isAuthNeeded) {
        let config = {
            headers: { Authorization: `Bearer ${token}` }
        }
        return await axios.post(apiUrl + url, body, config)
        .then(res => { return res })
        .catch(err => console.log(err))
    } else {
        return await axios.post(apiUrl + url, body)
        .then(res => { return res })
        .catch(err => console.log(err))
    }
}

export const ApiDelete = async (url, token) => {
    let isAuthNeeded = false
    if(token !== null && token !== undefined) {
        isAuthNeeded = true
    }
    if(isAuthNeeded) {
        let config = {
            headers: { Authorization: `Bearer ${token}` }
        }
        return await axios.delete(apiUrl + url, config)
        .then(res => res.data)
        .catch(err => console.log(err))
    } else {
        return await axios.delete(apiUrl + url)
        .then(res => res.data)
        .catch(err => console.log(err))
    }
}

export const ApiPut = async (url, body, token) => {
    let isAuthNeeded = false
    if(token !== null && token !== undefined) {
        isAuthNeeded = true
    }
    if(isAuthNeeded) {
        let config = {
            headers: { Authorization: `Bearer ${token}` }
        }
        return await axios.patch(apiUrl + url, body, config)
        .then(res => res.data)
        .catch(err => console.log(err))
    } else {
        return await axios.patch(apiUrl + url, body)
        .then(res => res.data)
        .catch(err => console.log(err))
    }
}
