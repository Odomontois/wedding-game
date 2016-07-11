'use strict';

var webpack = require('webpack'),
    jsPath = 'src',
    path = require('path'),
    srcPath = path.join(__dirname, 'src');

var PROD = (process.env.NODE_ENV === 'production');

var config = {
    target: 'web',
    entry:  path.join(srcPath, 'app.js')  ,
    resolve: {
        alias: {},
        root: srcPath,
        extensions: ['', '.js'],
        modulesDirectories: ['node_modules', jsPath]
    },
    output: {
        path: path.resolve(__dirname),
        publicPath: '',
        filename: 'bundle.js',
        pathInfo: true
    },

    module: {
        noParse: [],
        loaders: [
            {
                test: /\.jsx?$/,
                exclude: /node_modules/,
                loader: 'babel',
                query:{
                  "presets": ["es2017"],
                  "plugins": [
                    "transform-class-properties",
                    "transform-runtime",
                    "babel-plugin-transform-decorators-legacy"
                  ]
                }
            },
            {
                test: /.json$/,
                exclude: /node_modules/,
                loader: 'json'
            }
        ]
    },
    plugins: [
        new webpack.NoErrorsPlugin()]
        .concat(
        PROD ? [
            //new webpack.optimize.CommonsChunkPlugin('common', 'common.js'),
            new webpack.optimize.UglifyJsPlugin({
                compress: {warnings: false},
                output: {comments: false}
            })] : [])

};

module.exports = config;
