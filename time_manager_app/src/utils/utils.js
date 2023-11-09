export const firstLetterUpper = (word) => {
    let firstLetter = word[0]
    let rest = word.slice(1)
    let firstUpper = firstLetter.toUpperCase()
    return firstUpper + rest
}