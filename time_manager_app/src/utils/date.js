const formatDate = (date = new Date()) => {
    const year = date.toLocaleString('default', {year: 'numeric'})
    const month = date.toLocaleString('default', {
      month: '2-digit',
    })
    const day = date.toLocaleString('default', {day: '2-digit'})
  
    return [year, month, day].join('-')
}

export const getFirstDayOfWeeks = (startRange, endRange) => {
    const d1 = new Date(startRange)
    const d2 = new Date(endRange)
    const result = []

    const startDate = new Date(d1)
    startDate.setDate(d1.getDate() - d1.getDay())

    const endDate = new Date(d2) 
    endDate.setDate(d2.getDate() - d2.getDay())

    while (startDate <= endDate) {
        result.push(new Date(startDate))
        startDate.setDate(startDate.getDate() + 7)
    }

    return result
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

export const getDatesRange = (date) => {

    const result = {}

    const fourthLastWeekStart = new Date(date)
    fourthLastWeekStart.setDate(date.getDate() - (date.getDay() + 7 * 4))

    const currentWeekEnd = new Date(date)
    currentWeekEnd.setDate(date.getDate() + (6 - date.getDay()))

    result.startDate = fourthLastWeekStart
    result.endDate = currentWeekEnd

    return result
}

export const getWeekNumbersInRange = (startDate, endDate) => {

    const result = []

    const d1 = new Date(startDate)
    const d2 = new Date(endDate)

    d1.setDate(d1.getDate() - d1.getDay())

    while(d1 <= d2) {
        const weekNumber = getWeek(d1)
        result.push(weekNumber + 1)

        d1.setDate(d1.getDate() + 7)
    }

    return result
}