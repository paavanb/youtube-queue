var browserify = require('browserify')
var gulp = require('gulp');
var source = require('vinyl-source-stream')

gulp.task('browserify', function() {
    return browserify({
                entries: './src/app.js',
                extensions: ['.coffee']
            })
            .bundle()
            .pipe(source('youtube-queue.js'))
            .pipe(gulp.dest('./extension/js/'))
})
gulp.task('default', ['browserify'])
