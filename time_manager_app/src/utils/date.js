const formatDate = (date = new Date()) => {
    const year = date.toLocaleString('default', {year: 'numeric'})
    const month = date.toLocaleString('default', {
      month: '2-digit',
    })
    const day = date.toLocaleString('default', {day: '2-digit'})
  
    return [year, month, day].join('-')
}

export const getFullRange = (startDay, endDay) => {
    const startDate = new Date(startDay)
    const endDate = new Date(endDay)
    endDate.setDate(endDate.getDate() + 1)
    const date = new Date(startDate.getTime())

    const dates = []

    while (date < endDate) {
        dates.push(new Date(date))
        date.setDate(date.getDate() + 1)
    }

    return dates
}

export const getWeek = (date) => {
    let curr = new Date(date)
    let startDate = new Date(curr.getFullYear(), 0, 1)
    var days = Math.floor((curr - startDate) /
    (24 * 60 * 60 * 1000));
    var week = Math.ceil(days / 7)
    return week
}

export const getWeekFromDate = (date) => {
    let dayVal = new Date(date)
    const firstDay = new Date(
        dayVal.setDate(dayVal.getDate() - dayVal.getDay()),
    )
    const lastDay = new Date(
        dayVal.setDate(dayVal.getDate() - dayVal.getDay() + 6),
    )
    let toSend = {'firstDay': formatDate(firstDay), 'lastDay': formatDate(lastDay)}
    let newUrl = `start=${formatDate(firstDay)}T01:00:00&end=${formatDate(lastDay)}T23:00:00`
    return {'days': toSend, 'url': newUrl, 'week': getWeek(date)}
}

export const formatDisplayDate = (date) => {
    let val = new Date(date)
    let hours = date.slice(date.indexOf('T') + 1).slice(0, -3)
    return `${val.toDateString()} ${hours}`
}