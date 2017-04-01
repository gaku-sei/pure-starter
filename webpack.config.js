const path = require('path');

module.exports = {
  devServer: {
    contentBase: './demo',
    port: 3000,
  },

  entry: './src/Main.purs',

  output: {
    filename: 'bundle.js',
    library: 'app',
    path: path.join(__dirname, 'dist'),
    pathinfo: true,
  },

  resolve: {
    modules: ['node_modules', 'bower_components'],
    extensions: ['.purs', '.js']
  },

  module: {
    loaders: [
      {
        test: /\.purs$/,
        loader: 'purs-loader',
        exclude: /node_modules/,
        query: {
          bundle: false,
          main: 'main',
          module: 'Main',
          src: ['bower_components/purescript-*/src/**/*.purs', 'src/**/*.purs'],
          pscIde: false,
        },
      },
    ],
  },
};
