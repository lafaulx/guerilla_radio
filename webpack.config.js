var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var autoprefixer = require('autoprefixer');

module.exports = {
  entry: ['./web/static/css/app.less', './web/static/js/app.js'],

  output: {
    path: './priv/static',
    filename: 'js/app.js'
  },

  resolve: {
    modulesDirectories: [
      __dirname + '/web/static/js',
      'node_modules'],
    alias: {
      phoenix_html:
        __dirname + '/deps/phoenix_html/web/static/js/phoenix_html.js',
      phoenix:
        __dirname + '/deps/phoenix/web/static/js/phoenix.js'
    }
  },

  module: {
    loaders: [{
      test: /\.js$/,
      exclude: /node_modules/,
      loader: 'babel',
      query: {
        presets: ['es2015', 'react']
      }
    }, {
      test: /\.css$/,
      loader: ExtractTextPlugin.extract('style', 'css')
    }, {
      test: /\.less$/,
      loader: ExtractTextPlugin.extract(
        'style',
        'css!postcss!less'
      )
    }]
  },

  postcss: [autoprefixer({
    browsers: ['last 2 version'],
    remove: false
  })],

  plugins: [
    new ExtractTextPlugin('css/app.css'),
    new CopyWebpackPlugin([{ from: './web/static/assets' }])
  ]
};