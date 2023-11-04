/** @type {import('tailwindcss').Config} */
module.exports = {
  purge: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    colors: {
      'primary': '#ffeea2',
      'secondary': '#B0D2C1',
      'tertiary': '#26221F',
      'smallbg': '#C4C3AA',
      'second-text': '#020617',
      'clockbg': '#BAB6C1',
      'summarybg': '#B9C1B6',
      'gray': '#333333',
      'graph-bg': '#BFB293',
      'graph-bg-2': '#C4C3AA',
      'white': '#fff',
      'danger': '#dc3545'
    },
  },
  plugins: [],
}
