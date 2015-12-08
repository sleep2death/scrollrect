var flash = require('gulp-flash');
var gulp = require('gulp');
gulp.task('default', function() {
  gulp.src('src/main.as')
    .pipe(flash('bin/', {
      'static-link-runtime-shared-libraries': true,
      'swf-version': 15,
      'source-path': [
        './minimalcomps/src',
        './src'
      ],
      'debug': true,
      'optimize': false,
    }))
});
