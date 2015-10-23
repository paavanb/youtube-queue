var browserify = require('browserify')
var gulp = require('gulp');
var source = require('vinyl-source-stream')

gulp.task('browserify', function() {
    return browserify('./src/app.js')
            .bundle()
            .pipe(source('bundle.js'))
            .pipe(gulp.dest('./build/'))
})
gulp.task('default', ['browserify'])
