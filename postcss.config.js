module.exports = (ctx) => ({
  'no-map': true,
  plugins: {
    'postcss-easy-import': {},
    'stylelint': {},
    'postcss-cssnext': {
      browser: ['> 5%, not IE < 11'],
      features: {
        autoprefixer: {
          flexbox: 'no-2009',
          grid: false,
          cascade: false
        }
      }
    },
    'css-mqpacker': {},
    'cssnano': ctx.file.extname === '.min.css' ? {} : false,
    'postcss-reporter': {

    }
  }
})
