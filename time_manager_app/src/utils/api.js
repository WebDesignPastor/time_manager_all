import axios from "axios"

export const ApiGet = async (url) => {
    return await axios.get(`localhost:4000/api${url}`)
    .then(res => res.data)
    .catch(err => console.log(err))
}

export const ApiPost = async (url, body) => {
    return await axios.post(`localhost:4000/api${url}`, body)
    .then(res => { return res })
    .catch(err => console.log(err))
}

export const ApiDelete = async (url) => {
    return await axios.delete(`localhost:4000/api${url}`)
    .then(res => res.data)
    .catch(err => console.log(err))
}

export const ApiPut = async (url, body) => {
    return await axios.put(`localhost:4000/api${url}`, body)
    .then(res => res.data)
    .catch(err => console.log(err))
}
