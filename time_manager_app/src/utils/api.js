import axios from "axios"

export const ApiGet = async (url) => {
    return await axios.get(`http://35.180.63.135:4000/api${url}`)
    .then(res => res.data)
    .catch(err => console.log(err))
}

export const ApiPost = async (url, body) => {
    return await axios.post(`http://35.180.63.135:4000/api${url}`, body)
    .then(res => { return res })
    .catch(err => console.log(err))
}

export const ApiDelete = async (url) => {
    return await axios.delete(`http://35.180.63.135:4000/api${url}`)
    .then(res => res.data)
    .catch(err => console.log(err))
}

export const ApiPut = async (url, body) => {
    return await axios.put(`http://35.180.63.135:4000/api${url}`, body)
    .then(res => res.data)
    .catch(err => console.log(err))
}