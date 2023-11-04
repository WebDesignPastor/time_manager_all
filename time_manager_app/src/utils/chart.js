export const customToolTip = (startVal, endVal, date) => {
    if (date !== null) {
        return `${new Date(date).getMonth() +1}/${new Date(date).getDate()} \n Start: ${startVal} \n End: ${endVal}`       
    } else {
        return ``
    }
}

const hoursToInt = (hours) => {
    let newHours = parseInt(hours.slice(0,2))
    let min = parseInt(hours.slice(3, 5))
    return newHours + parseFloat((min/60).toFixed(2))
}

const nameOfDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

export const workingTimeDataFormat = (workingtimes, days) => {

    let result = [
        ['day', 'shift', 'b', 'c', 'd', {type:'string',role:'tooltip'}],
    ]

    const start = new Date(days.firstDay)
    const end = new Date(days.lastDay)
    const DAY = 24 * 60 * 60 * 1000
    const daysOfTheWeek = []
    for (let newStart = start.valueOf(); newStart < end; newStart += DAY * 7) {
        for (let d = newStart; d < newStart + 7 * DAY; d += DAY) {
            daysOfTheWeek.push(new Date(d))
        }
    }
    daysOfTheWeek.map((day) => {
        workingtimes.map((w) => {
            if(new Date(w.start).getDate() === new Date(day).getDate() && new Date(w.start).getDay() === new Date(day).getDay() ) {
                let d = new Date(day)
                let ds = nameOfDays[d.getDay()]
                let s = hoursToInt(w.start.split('T')[1])
                let e = hoursToInt(w.end.split('T')[1])
                result.push([
                    ds, s, e, s, e, customToolTip(s, e, d)
                ])
            }
        })
    })

    if(result.length > 1) {
        return result
    } else {
        nameOfDays.map((name) => {
            result.push([
                name, 0, 0, 0, 0, customToolTip(0, 0, null)
            ])
        })
        return result
    }
        
}