# LIBKAFKA_CHECK_CONFIG ([DEFAULT-ACTION])
# ----------------------------------------------------------
#
# Checks for kafka.  DEFAULT-ACTION is the string yes or no to
# specify whether to default to --with-kafka or --without-kafka.
# If not supplied, DEFAULT-ACTION is no.
#
# This macro #defines HAVE_KAFKA if a required header files is
# found, and sets @KAFKA_CFLAGS@, @KAFKA_LDFLAGS@ and @KAFKA_LIBS@
# to the necessary values.
#
# Users may override the detected values by doing something like:
# KAFKA_LIBS="-lrdkafka -lz -lpthread -ltr" KAFKA_CFLAGS="-I/usr/myinclude" ./configure
#
# This macro is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

AC_DEFUN([LIBKAFKA_CHECK_CONFIG],
[
  AC_ARG_WITH(kafka,
    [If you want to check KAFKA Library:
AC_HELP_STRING([--with-kafka@<:@=DIR@:>@],[Include KAFKA support @<:@default=no@:>@. DIR is the KAFKA Library base install directory, default is to search through a number of common places for the KAFKA files.])],
     [ if test "$withval" = "no"; then
            want_kafka="no"
            _libkafka_with="no"
        elif test "$withval" = "yes"; then
            want_kafka="yes"
            _libkafka_with="yes"
        else
            want_kafka="yes"
            _libkafka_with=$withval
        fi
     ],[_libkafka_with=ifelse([$1],,[no],[$1])])

  if test "x$_libkafka_with" != x"no"; then
       AC_MSG_CHECKING(for KAFKA support)

       if test "$_libkafka_with" = "yes"; then
               if test -f /usr/local/include/librdkafka/rdkafka.h; then
                       KAFKA_INCDIR=/usr/local/include
                       KAFKA_LIBDIR=/usr/local/lib
		       found_kafka="yes"
               elif test -f /usr/include/librdkafka/rdkafka.h; then
                       KAFKA_INCDIR=/usr/include
                       KAFKA_LIBDIR=/usr/lib
		       found_kafka="yes"
               else
                       found_kafka="no"
                       AC_MSG_RESULT(no)
               fi
       else
               if test -f $_libkafka_with/include/librdkafka/rdkafka.h; then
                       KAFKA_INCDIR=$_libkafka_with/include
                       KAFKA_LIBDIR=$_libkafka_with/lib
		       found_kafka="yes"
               else
                       found_kafka="no"
                       AC_MSG_RESULT(no)
               fi
       fi

       if test "x$found_kafka" != "xno"; then
               if test "x$enable_static" = "xyes"; then
                       KAFKA_LIBS=" -lpthread -lz -ltr $KAFKA_LIBS"
               fi

               KAFKA_CFLAGS="-I$KAFKA_INCDIR"
               KAFKA_LDFLAGS="-L$KAFKA_LIBDIR"
               KAFKA_LIBS="-lrdkafka -lpthread -lz -lrt $KAFKA_LIBS"

               found_kafka="yes"
               AC_DEFINE(HAVE_KAFKA,1,[Define to 1 if KAFKA should be enabled.])
               AC_MSG_RESULT(yes)

	       if test "x$enable_static" = "xyes"; then
                       AC_CHECK_LIB(pthread, main, , AC_MSG_ERROR([Not found Pthread library]))
               fi

       fi
  fi

  AC_SUBST(KAFKA_CFLAGS)
  AC_SUBST(KAFKA_LDFLAGS)
  AC_SUBST(KAFKA_LIBS)

  unset _libkafka_with
])dnl
