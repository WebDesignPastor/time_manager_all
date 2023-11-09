import { getFullRange, getWeek } from "./date"
import { getWeekFromDate } from "./date"

export const customToolTip = (startVal, endVal, ) => {
    return `Start: ${startVal} \n End: ${endVal}`       
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
    if(workingtimes !== undefined && workingtimes !== null) {
        const start = new Date(days.firstDay)
        const end = new Date(days.lastDay)
        const DAY = 24 * 60 * 60 * 1000
        const daysOfTheWeek = []
        for (let newStart = start.valueOf(); newStart < end; newStart += DAY * 7) {
            for (let d = newStart; d < newStart + 7 * DAY; d += DAY) {
                daysOfTheWeek.push(new Date(d))
            }
        }
        if(workingtimes.length > 0) {
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
            return result
        } else {
            nameOfDays.map((name) => {
                result.push([
                    name, 0, 0, 0, 0, customToolTip(0, 0, null)
                ])
            })
            return result
        }       
    }   else {
            nameOfDays.map((name) => {
                result.push([
                    name, 0, 0, 0, 0, customToolTip(0, 0, null)
                ])
            })
        return result
    }   
}

const getHoursDiffFromRange = (start, end) => {
    return (Math.abs(start - end) / 36e5)
}

const getCol2dArray = (array, col) => {
    let column = []
    for(let i = 0; i<array.length; i++) {
        column.push(array[i][col])
    }
    return column
}

function compareDay( a, b ) {
    if ( a.day < b.day ){
      return -1;
    }
    if ( a.day > b.day ){
      return 1;
    }
    return 0;
}

const week = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

export const formatDataDailyAverage = (data, date) => {

    let teamsToReturn = []
    let currRange = getWeekFromDate(date)
    let startRange = currRange['days'].firstDay
    let endRange = currRange['days'].lastDay
    let fullRange = getFullRange(startRange, endRange)
    let allClocks = []

    // create the data that will be displayed
    data.map((team) => {
        let newObj = {id: team.teamsId, name: team.teamsId}
        let teamAverage = []
        team.users.map((user) => {
            let userWorkingtimeAverage = []
            // get all workingtime in ragne and return hours val
            let toCheck = []
            fullRange.map((day, index) => {
                for(let i = 0; i < user.workintimes.length; i++) {
                    if((user.workintimes[i].start >= startRange && user.workintimes[i].start <= endRange) && (user.workintimes[i].end >= startRange && user.workintimes[i].end <= endRange)) {
                        if(day.getDay() === new Date(user.workintimes[i].start).getDay()) {
                            toCheck.push({checked: true, val: i, day: index})
                        }
                    }
                }
                for(let i = 0; i < user.clocks.length; i++) {
                    if(user.clocks[i].start >= startRange && user.clocks[i].start <= endRange && user.clocks[i].end >= startRange && user.clocks[i].end <= endRange) {
                        if(day.getDay() === new Date(user.clocks[i].start).getDay()) {
                            allClocks.push({day: day.getDay(), user: user.id, start: user.clocks[i].start, end: user.clocks[i].end})
                        }
                    }
                }
            })
            // ensuite il faut voir quel jour il manque pour les ajouter a 0 
            for(let i = 0; i < 7; i++) {
                if(toCheck[i] !== undefined) {
                    if(toCheck[i].day == i) {
                        let d1 = user.workintimes[toCheck[i].val].start
                        let d2 = user.workintimes[toCheck[i].val].end
                        userWorkingtimeAverage.push(getHoursDiffFromRange(new Date(d1), new Date(d2)))
                    }
                }else {
                    userWorkingtimeAverage.push(0)
                }
            }
            teamAverage.push(userWorkingtimeAverage)
        })
        if(teamAverage.length > 0) {
            // sort matrix of hours to do the average
            let teamWorkingtimeAverage = []
            for(let i = 0; i<teamAverage[0].length; i++) {
                teamWorkingtimeAverage.push(getCol2dArray(teamAverage, i)
                .reduce((y, j) => {return y + j}, 0) / getCol2dArray(teamAverage, i).length)
            }
            newObj['value'] = teamWorkingtimeAverage
            teamsToReturn.push(newObj)
        }
    })
    // s'ocupper des clocks
    // les trier par jour, puis calculer la moyenne
    allClocks = allClocks.sort(compareDay)
    let sunClock = allClocks.map(clock => clock.day == 0 ? clock : null).filter((i) => i !== null)
    let monClock = allClocks.map(clock => clock.day == 1 ? clock : null).filter((i) => i !== null)
    let tueClock = allClocks.map(clock => clock.day == 2 ? clock : null).filter((i) => i !== null)
    let wedClcok = allClocks.map(clock => clock.day == 3 ? clock : null).filter((i) => i !== null)
    let thuClock = allClocks.map(clock => clock.day == 4 ? clock : null).filter((i) => i !== null)
    let friClock = allClocks.map(clock => clock.day == 5 ? clock : null).filter((i) => i !== null)
    let satClock = allClocks.map(clock => clock.day == 6 ? clock : null).filter((i) => i !== null)

    let clockSunVal = []
    let clockMonVal = []
    let clockTueVal = []
    let clockWedVal = []
    let clockThuVal = []
    let clockFriVal = []
    let clockSatVal = []

    let finalSunVal = 0
    let finalMonVal = 0
    let finalTueVal = 0
    let finalWedVal = 0
    let finalThuVal = 0
    let finalFriVal = 0
    let finalSatVal = 0

    if(sunClock.length > 0) {
        sunClock.map((clock) => {
            clockSunVal.push(getHoursDiffFromRange(new Date(clock.start), new Date(clock.end)))
        })
        finalSunVal = Math.round(clockSunVal.reduce((i, j) => i + j) / clockSunVal.length * 100) / 100 
    } else {
        clockSunVal.push(0)
    }
    if(monClock.length > 0) {
        monClock.map((clock) => {
            clockMonVal.push(getHoursDiffFromRange(new Date(clock.start), new Date(clock.end)))
        })
        finalMonVal = Math.round(clockMonVal.reduce((i, j) => i + j) / clockMonVal.length * 100) / 100 
    } else {
        clockMonVal.push(0)
    }
    if(tueClock.length > 0) {
        tueClock.map((clock) => {
            clockTueVal.push(getHoursDiffFromRange(new Date(clock.start), new Date(clock.end)))
        })
        finalTueVal = Math.round(clockTueVal.reduce((i, j) => i + j) / clockTueVal.length * 100) / 100 
    } else {
        clockTueVal.push(0)
    }
    if(wedClcok.length > 0) {
        wedClcok.map((clock) => {
            clockWedVal.push(getHoursDiffFromRange(new Date(clock.start), new Date(clock.end)))
        })
        finalWedVal = Math.round(clockWedVal.reduce((i, j) => i + j) / clockWedVal.length * 100) / 100 
    } else {
        clockWedVal.push(0)
    }
    if(thuClock.length > 0) {
        thuClock.map((clock) => {
            clockThuVal.push(getHoursDiffFromRange(new Date(clock.start), new Date(clock.end)))
        })
        finalThuVal = Math.round(clockThuVal.reduce((i, j) => i + j) / clockThuVal.length * 100) / 100 
    } else {
        clockThuVal.push(0)
    }
    if(friClock.length > 0) {
        friClock.map((clock) => {
            clockFriVal.push(getHoursDiffFromRange(new Date(clock.start), new Date(clock.end)))
        })
        finalFriVal = Math.round(clockFriVal.reduce((i, j) => i + j) / clockFriVal.length * 100) / 100 
    } else {
        clockFriVal.push(0)
    }
    if(satClock.length > 0) {
        satClock.map((clock) => {
            clockSatVal.push(getHoursDiffFromRange(new Date(clock.start), new Date(clock.end)))
        })
        finalSatVal = Math.round(clockSatVal.reduce((i, j) => i + j) / clockSatVal.length * 100) / 100 
    } else {
        clockSatVal.push(0)
    }

    let avegareClockHours = ['Average hours worked', finalSunVal, finalMonVal, finalTueVal, finalWedVal, finalThuVal, finalFriVal, finalSatVal]

    // create the chartdata object to setup the graph
    let newChartData = [
        ['Days', 'Hours worked on average']
    ]
    if(teamsToReturn.length > 0) {
        week.map((day, index) => {
            newChartData.push([day, teamsToReturn[0].value[index]])
        })
    }
    let dailyAverage = {teams: teamsToReturn, chartData: newChartData, averageClocks: avegareClockHours}
    return dailyAverage
}

export const formatDataWeeklyAverage = () => {

}