var browserify = require('browserify')
var gulp = require('gulp');
var uglify = require('gulp-uglify')
var source = require('vinyl-source-stream')

// TODO: Rename "extension" directory to "dist"

gulp.task('browserify', function() {
    return browserify({
                entries: './src/app.js',
                extensions: ['.coffee']
            })
            .bundle()
            .pipe(source('youtube-queue.js'))
            .pipe(gulp.dest('./extension/js/'))
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


gulp.task('material', ['material-js', 'material-css'])
gulp.task('default', ['browserify', 'material'])
