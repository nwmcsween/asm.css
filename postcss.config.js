module.exports = (ctx) => ({
  'no-map': true,
  plugins: {
    'postcss-easy-import': {},
    'stylelint': {},
    'postcss-cssnext': {
      browsers: ['> 5%', 'not IE < 11'],
      autoprefixer: {
        cascade: false,
        flexbox: "no-2009",
        grid: false
      }
    },
    'css-mqpacker': {},
    'cssnano': ctx.env === 'production' ? {} : false,
    'postcss-reporter': {}
  }
})
