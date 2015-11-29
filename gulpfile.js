var browserify = require('browserify')
var gulp = require('gulp');
var watch = require('gulp-watch')
var batch = require('gulp-batch')
var buffer = require('vinyl-buffer')
var sass = require('gulp-sass')
var uglify = require('gulp-uglify')
var notify = require('gulp-notify')
var source = require('vinyl-source-stream')
var sourcemaps = require('gulp-sourcemaps')


gulp.task('browserify', function() {
    return browserify({
                entries: './src/app.js',
                extensions: ['.coffee'],
                paths: ['./src']
            })
            .bundle()
            .pipe(source('youtube-queue.js'))
            .pipe(buffer())
            .pipe(sourcemaps.init())
            .pipe(sourcemaps.write('./'))
            .pipe(gulp.dest('./extension/js/'))
            .pipe(notify("Task 'browserify' completed."))
})

gulp.task('watch', function() {
    watch(['./src/coffee/**/*.coffee', 
           './src/templates/**/*.html',
           './src/**/*.js'], batch(function(events, done) {
        gulp.start('browserify', done)
    }))
    watch('./src/sass/**/*.scss', batch(function(events, done) {
        gulp.start('sass', done)
    }))
    // TODO Watch for material design changes
})

gulp.task('sass', function() {
    return gulp.src("./src/sass/*.scss")
               .pipe(sass())
               .pipe(gulp.dest('./extension/css/'))
               .pipe(notify("Task 'sass' completed."))
})

gulp.task('material-js', function() {
    return gulp.src('./node_modules/material-design-lite/material.js')
            .pipe(uglify())
            .pipe(gulp.dest('./extension/js/'))
})

gulp.task('material-css', function() {
    return gulp.src('./node_modules/material-design-lite/material.css')
            .pipe(gulp.dest('./extension/css/'))
})

gulp.task('material', function() {
    gulp.start('material-js', 'material-css')
})

gulp.task('default', ['browserify', 'sass', 'material', 'watch'])
