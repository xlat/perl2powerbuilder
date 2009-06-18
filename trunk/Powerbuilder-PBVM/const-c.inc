#define PERL_constant_NOTFOUND	1
#define PERL_constant_NOTDEF	2
#define PERL_constant_ISIV	3
#define PERL_constant_ISNO	4
#define PERL_constant_ISNV	5
#define PERL_constant_ISPV	6
#define PERL_constant_ISPVN	7
#define PERL_constant_ISSV	8
#define PERL_constant_ISUNDEF	9
#define PERL_constant_ISUV	10
#define PERL_constant_ISYES	11

#ifndef NVTYPE
typedef double NV; /* 5.6 and later define NVTYPE, and typedef NV to it.  */
#endif
#ifndef aTHX_
#define aTHX_ /* 5.6 or later define this for threading support.  */
#endif
#ifndef pTHX_
#define pTHX_ /* 5.6 or later define this for threading support.  */
#endif

static int
constant_11 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     PBX_SUCCESS pbvalue_any pbvalue_dec pbvalue_int */
  /* Offset 8 gives the best switch position.  */
  switch (name[8]) {
  case 'E':
    if (memEQ(name, "PBX_SUCCESS", 11)) {
    /*                       ^         */
      *iv_return = PBX_SUCCESS;
      return PERL_constant_ISIV;
    }
    break;
  case 'a':
    if (memEQ(name, "pbvalue_any", 11)) {
    /*                       ^         */
      *iv_return = pbvalue_any;
      return PERL_constant_ISIV;
    }
    break;
  case 'd':
    if (memEQ(name, "pbvalue_dec", 11)) {
    /*                       ^         */
      *iv_return = pbvalue_dec;
      return PERL_constant_ISIV;
    }
    break;
  case 'i':
    if (memEQ(name, "pbvalue_int", 11)) {
    /*                       ^         */
      *iv_return = pbvalue_int;
      return PERL_constant_ISIV;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_12 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     pbgroup_menu pbvalue_blob pbvalue_byte pbvalue_char pbvalue_date
     pbvalue_long pbvalue_real pbvalue_time pbvalue_uint */
  /* Offset 8 gives the best switch position.  */
  switch (name[8]) {
  case 'b':
    if (memEQ(name, "pbvalue_blob", 12)) {
    /*                       ^          */
      *iv_return = pbvalue_blob;
      return PERL_constant_ISIV;
    }
    if (memEQ(name, "pbvalue_byte", 12)) {
    /*                       ^          */
      *iv_return = pbvalue_byte;
      return PERL_constant_ISIV;
    }
    break;
  case 'c':
    if (memEQ(name, "pbvalue_char", 12)) {
    /*                       ^          */
      *iv_return = pbvalue_char;
      return PERL_constant_ISIV;
    }
    break;
  case 'd':
    if (memEQ(name, "pbvalue_date", 12)) {
    /*                       ^          */
      *iv_return = pbvalue_date;
      return PERL_constant_ISIV;
    }
    break;
  case 'l':
    if (memEQ(name, "pbvalue_long", 12)) {
    /*                       ^          */
      *iv_return = pbvalue_long;
      return PERL_constant_ISIV;
    }
    break;
  case 'm':
    if (memEQ(name, "pbgroup_menu", 12)) {
    /*                       ^          */
      *iv_return = pbgroup_menu;
      return PERL_constant_ISIV;
    }
    break;
  case 'r':
    if (memEQ(name, "pbvalue_real", 12)) {
    /*                       ^          */
      *iv_return = pbvalue_real;
      return PERL_constant_ISIV;
    }
    break;
  case 't':
    if (memEQ(name, "pbvalue_time", 12)) {
    /*                       ^          */
      *iv_return = pbvalue_time;
      return PERL_constant_ISIV;
    }
    break;
  case 'u':
    if (memEQ(name, "pbvalue_uint", 12)) {
    /*                       ^          */
      *iv_return = pbvalue_uint;
      return PERL_constant_ISIV;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_13 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     PBRT_FUNCTION pbgroup_proxy pbvalue_ulong */
  /* Offset 4 gives the best switch position.  */
  switch (name[4]) {
  case '_':
    if (memEQ(name, "PBRT_FUNCTION", 13)) {
    /*                   ^               */
      *iv_return = PBRT_FUNCTION;
      return PERL_constant_ISIV;
    }
    break;
  case 'l':
    if (memEQ(name, "pbvalue_ulong", 13)) {
    /*                   ^               */
      *iv_return = pbvalue_ulong;
      return PERL_constant_ISIV;
    }
    break;
  case 'o':
    if (memEQ(name, "pbgroup_proxy", 13)) {
    /*                   ^               */
      *iv_return = pbgroup_proxy;
      return PERL_constant_ISIV;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_14 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     pbgroup_window pbvalue_double pbvalue_dummy1 pbvalue_dummy2 pbvalue_dummy3
     pbvalue_dummy4 pbvalue_notype pbvalue_string */
  /* Offset 13 gives the best switch position.  */
  switch (name[13]) {
  case '1':
    if (memEQ(name, "pbvalue_dummy", 13)) {
    /*                            1      */
      *iv_return = pbvalue_dummy1;
      return PERL_constant_ISIV;
    }
    break;
  case '2':
    if (memEQ(name, "pbvalue_dummy", 13)) {
    /*                            2      */
      *iv_return = pbvalue_dummy2;
      return PERL_constant_ISIV;
    }
    break;
  case '3':
    if (memEQ(name, "pbvalue_dummy", 13)) {
    /*                            3      */
      *iv_return = pbvalue_dummy3;
      return PERL_constant_ISIV;
    }
    break;
  case '4':
    if (memEQ(name, "pbvalue_dummy", 13)) {
    /*                            4      */
      *iv_return = pbvalue_dummy4;
      return PERL_constant_ISIV;
    }
    break;
  case 'e':
    if (memEQ(name, "pbvalue_doubl", 13)) {
    /*                            e      */
      *iv_return = pbvalue_double;
      return PERL_constant_ISIV;
    }
    if (memEQ(name, "pbvalue_notyp", 13)) {
    /*                            e      */
      *iv_return = pbvalue_notype;
      return PERL_constant_ISIV;
    }
    break;
  case 'g':
    if (memEQ(name, "pbvalue_strin", 13)) {
    /*                            g      */
      *iv_return = pbvalue_string;
      return PERL_constant_ISIV;
    }
    break;
  case 'w':
    if (memEQ(name, "pbgroup_windo", 13)) {
    /*                            w      */
      *iv_return = pbgroup_window;
      return PERL_constant_ISIV;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_16 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     PB_DEBUG_SERVICE PB_TXNSERVER_EJB PB_TXNSERVER_MTS pbgroup_function
     pbvalue_datetime pbvalue_longlong */
  /* Offset 15 gives the best switch position.  */
  switch (name[15]) {
  case 'B':
    if (memEQ(name, "PB_TXNSERVER_EJ", 15)) {
    /*                              B      */
      *iv_return = PB_TXNSERVER_EJB;
      return PERL_constant_ISIV;
    }
    break;
  case 'E':
    if (memEQ(name, "PB_DEBUG_SERVIC", 15)) {
    /*                              E      */
      *iv_return = PB_DEBUG_SERVICE;
      return PERL_constant_ISIV;
    }
    break;
  case 'S':
    if (memEQ(name, "PB_TXNSERVER_MT", 15)) {
    /*                              S      */
      *iv_return = PB_TXNSERVER_MTS;
      return PERL_constant_ISIV;
    }
    break;
  case 'e':
    if (memEQ(name, "pbvalue_datetim", 15)) {
    /*                              e      */
      *iv_return = pbvalue_datetime;
      return PERL_constant_ISIV;
    }
    break;
  case 'g':
    if (memEQ(name, "pbvalue_longlon", 15)) {
    /*                              g      */
      *iv_return = pbvalue_longlong;
      return PERL_constant_ISIV;
    }
    break;
  case 'n':
    if (memEQ(name, "pbgroup_functio", 15)) {
    /*                              n      */
      *iv_return = pbgroup_function;
      return PERL_constant_ISIV;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_18 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     PBX_E_OUTOF_MEMORY PB_LOGGING_SERVICE pbgroup_datawindow
     pbgroup_userobject */
  /* Offset 15 gives the best switch position.  */
  switch (name[15]) {
  case 'I':
    if (memEQ(name, "PB_LOGGING_SERVICE", 18)) {
    /*                              ^         */
      *iv_return = PB_LOGGING_SERVICE;
      return PERL_constant_ISIV;
    }
    break;
  case 'O':
    if (memEQ(name, "PBX_E_OUTOF_MEMORY", 18)) {
    /*                              ^         */
      *iv_return = PBX_E_OUTOF_MEMORY;
      return PERL_constant_ISIV;
    }
    break;
  case 'd':
    if (memEQ(name, "pbgroup_datawindow", 18)) {
    /*                              ^         */
      *iv_return = pbgroup_datawindow;
      return PERL_constant_ISIV;
    }
    break;
  case 'e':
    if (memEQ(name, "pbgroup_userobject", 18)) {
    /*                              ^         */
      *iv_return = pbgroup_userobject;
      return PERL_constant_ISIV;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_19 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     PBX_E_NO_SUCH_CLASS PBX_E_READONLY_ARGS PB_SECURITY_SERVICE
     PB_TXNSERVER_JAGUAR PB_TXNSERVER_SERVER pbgroup_application */
  /* Offset 13 gives the best switch position.  */
  switch (name[13]) {
  case 'E':
    if (memEQ(name, "PB_SECURITY_SERVICE", 19)) {
    /*                            ^            */
      *iv_return = PB_SECURITY_SERVICE;
      return PERL_constant_ISIV;
    }
    break;
  case 'J':
    if (memEQ(name, "PB_TXNSERVER_JAGUAR", 19)) {
    /*                            ^            */
      *iv_return = PB_TXNSERVER_JAGUAR;
      return PERL_constant_ISIV;
    }
    break;
  case 'S':
    if (memEQ(name, "PB_TXNSERVER_SERVER", 19)) {
    /*                            ^            */
      *iv_return = PB_TXNSERVER_SERVER;
      return PERL_constant_ISIV;
    }
    break;
  case 'Y':
    if (memEQ(name, "PBX_E_READONLY_ARGS", 19)) {
    /*                            ^            */
      *iv_return = PBX_E_READONLY_ARGS;
      return PERL_constant_ISIV;
    }
    break;
  case '_':
    if (memEQ(name, "PBX_E_NO_SUCH_CLASS", 19)) {
    /*                            ^            */
      *iv_return = PBX_E_NO_SUCH_CLASS;
      return PERL_constant_ISIV;
    }
    break;
  case 'c':
    if (memEQ(name, "pbgroup_application", 19)) {
    /*                            ^            */
      *iv_return = pbgroup_application;
      return PERL_constant_ISIV;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant (pTHX_ const char *name, STRLEN len, IV *iv_return) {
  /* Initially switch on the length of the name.  */
  /* When generated this function returned values for the list of names given
     in this section of perl code.  Rather than manually editing these functions
     to add or remove constants, which would result in this comment and section
     of code becoming inaccurate, we recommend that you edit this section of
     code, and use it to regenerate a new set of constant functions which you
     then use to replace the originals.

     Regenerate these constant functions by feeding this entire source file to
     perl -x

#!C:\Perl\bin\perl.exe -w
use ExtUtils::Constant qw (constant_types C_constant XS_constant);

my $types = {map {($_, 1)} qw(IV)};
my @names = (qw(PBRT_ANY PBRT_EVENT PBRT_FUNCTION
	       PBX_E_ARRAY_INDEX_OUTOF_BOUNDS PBX_E_BUILD_GROUP_FAILED
	       PBX_E_CAN_NOT_LOCATE_APPLICATION PBX_E_GET_PBVM_FAILED
	       PBX_E_INVALID_ARGUMENT PBX_E_INVALID_METHOD_ID
	       PBX_E_INVOKE_FAILURE PBX_E_INVOKE_METHOD_AMBIGUOUS
	       PBX_E_INVOKE_METHOD_INACCESSABLE PBX_E_INVOKE_REFARG_ERROR
	       PBX_E_INVOKE_WRONG_NUM_ARGS PBX_E_MISMATCHED_DATA_TYPE
	       PBX_E_NO_REGISTER_FUNCTION PBX_E_NO_SUCH_CLASS
	       PBX_E_OUTOF_MEMORY PBX_E_READONLY_ARGS PBX_E_REGISTRATION_FAILED
	       PBX_FAIL PBX_OK PBX_SUCCESS PB_CONNECTION_CACHE_C_SERVICE
	       PB_CONNECTION_CACHE_SERVICE PB_DEBUG_SERVICE PB_LOGGING_SERVICE
	       PB_SECURITY_SERVICE PB_TRANSACTION_SERVICE PB_TXNSERVER_EJB
	       PB_TXNSERVER_JAGUAR PB_TXNSERVER_MTS PB_TXNSERVER_NONE
	       PB_TXNSERVER_NORMAL_APP PB_TXNSERVER_SERVER pbgroup_application
	       pbgroup_datawindow pbgroup_function pbgroup_menu pbgroup_proxy
	       pbgroup_structure pbgroup_unknown pbgroup_userobject
	       pbgroup_window pbvalue_any pbvalue_blob pbvalue_boolean
	       pbvalue_byte pbvalue_char pbvalue_date pbvalue_datetime
	       pbvalue_dec pbvalue_double pbvalue_dummy1 pbvalue_dummy2
	       pbvalue_dummy3 pbvalue_dummy4 pbvalue_int pbvalue_long
	       pbvalue_longlong pbvalue_notype pbvalue_real pbvalue_string
	       pbvalue_time pbvalue_uint pbvalue_ulong));

print constant_types(); # macro defs
foreach (C_constant ("Powerbuilder::PBVM", 'constant', 'IV', $types, undef, 3, @names) ) {
    print $_, "\n"; # C constant subs
}
print "#### XS Section:\n";
print XS_constant ("Powerbuilder::PBVM", $types);
__END__
   */

  switch (len) {
  case 6:
    if (memEQ(name, "PBX_OK", 6)) {
      *iv_return = PBX_OK;
      return PERL_constant_ISIV;
    }
    break;
  case 8:
    /* Names all of length 8.  */
    /* PBRT_ANY PBX_FAIL */
    /* Offset 6 gives the best switch position.  */
    switch (name[6]) {
    case 'I':
      if (memEQ(name, "PBX_FAIL", 8)) {
      /*                     ^       */
        *iv_return = PBX_FAIL;
        return PERL_constant_ISIV;
      }
      break;
    case 'N':
      if (memEQ(name, "PBRT_ANY", 8)) {
      /*                     ^       */
        *iv_return = PBRT_ANY;
        return PERL_constant_ISIV;
      }
      break;
    }
    break;
  case 10:
    if (memEQ(name, "PBRT_EVENT", 10)) {
      *iv_return = PBRT_EVENT;
      return PERL_constant_ISIV;
    }
    break;
  case 11:
    return constant_11 (aTHX_ name, iv_return);
    break;
  case 12:
    return constant_12 (aTHX_ name, iv_return);
    break;
  case 13:
    return constant_13 (aTHX_ name, iv_return);
    break;
  case 14:
    return constant_14 (aTHX_ name, iv_return);
    break;
  case 15:
    /* Names all of length 15.  */
    /* pbgroup_unknown pbvalue_boolean */
    /* Offset 9 gives the best switch position.  */
    switch (name[9]) {
    case 'n':
      if (memEQ(name, "pbgroup_unknown", 15)) {
      /*                        ^            */
        *iv_return = pbgroup_unknown;
        return PERL_constant_ISIV;
      }
      break;
    case 'o':
      if (memEQ(name, "pbvalue_boolean", 15)) {
      /*                        ^            */
        *iv_return = pbvalue_boolean;
        return PERL_constant_ISIV;
      }
      break;
    }
    break;
  case 16:
    return constant_16 (aTHX_ name, iv_return);
    break;
  case 17:
    /* Names all of length 17.  */
    /* PB_TXNSERVER_NONE pbgroup_structure */
    /* Offset 12 gives the best switch position.  */
    switch (name[12]) {
    case '_':
      if (memEQ(name, "PB_TXNSERVER_NONE", 17)) {
      /*                           ^           */
        *iv_return = PB_TXNSERVER_NONE;
        return PERL_constant_ISIV;
      }
      break;
    case 'c':
      if (memEQ(name, "pbgroup_structure", 17)) {
      /*                           ^           */
        *iv_return = pbgroup_structure;
        return PERL_constant_ISIV;
      }
      break;
    }
    break;
  case 18:
    return constant_18 (aTHX_ name, iv_return);
    break;
  case 19:
    return constant_19 (aTHX_ name, iv_return);
    break;
  case 20:
    if (memEQ(name, "PBX_E_INVOKE_FAILURE", 20)) {
      *iv_return = PBX_E_INVOKE_FAILURE;
      return PERL_constant_ISIV;
    }
    break;
  case 21:
    if (memEQ(name, "PBX_E_GET_PBVM_FAILED", 21)) {
      *iv_return = PBX_E_GET_PBVM_FAILED;
      return PERL_constant_ISIV;
    }
    break;
  case 22:
    /* Names all of length 22.  */
    /* PBX_E_INVALID_ARGUMENT PB_TRANSACTION_SERVICE */
    /* Offset 15 gives the best switch position.  */
    switch (name[15]) {
    case 'R':
      if (memEQ(name, "PBX_E_INVALID_ARGUMENT", 22)) {
      /*                              ^             */
        *iv_return = PBX_E_INVALID_ARGUMENT;
        return PERL_constant_ISIV;
      }
      break;
    case 'S':
      if (memEQ(name, "PB_TRANSACTION_SERVICE", 22)) {
      /*                              ^             */
        *iv_return = PB_TRANSACTION_SERVICE;
        return PERL_constant_ISIV;
      }
      break;
    }
    break;
  case 23:
    /* Names all of length 23.  */
    /* PBX_E_INVALID_METHOD_ID PB_TXNSERVER_NORMAL_APP */
    /* Offset 14 gives the best switch position.  */
    switch (name[14]) {
    case 'M':
      if (memEQ(name, "PBX_E_INVALID_METHOD_ID", 23)) {
      /*                             ^               */
        *iv_return = PBX_E_INVALID_METHOD_ID;
        return PERL_constant_ISIV;
      }
      break;
    case 'O':
      if (memEQ(name, "PB_TXNSERVER_NORMAL_APP", 23)) {
      /*                             ^               */
        *iv_return = PB_TXNSERVER_NORMAL_APP;
        return PERL_constant_ISIV;
      }
      break;
    }
    break;
  case 24:
    if (memEQ(name, "PBX_E_BUILD_GROUP_FAILED", 24)) {
      *iv_return = PBX_E_BUILD_GROUP_FAILED;
      return PERL_constant_ISIV;
    }
    break;
  case 25:
    /* Names all of length 25.  */
    /* PBX_E_INVOKE_REFARG_ERROR PBX_E_REGISTRATION_FAILED */
    /* Offset 15 gives the best switch position.  */
    switch (name[15]) {
    case 'F':
      if (memEQ(name, "PBX_E_INVOKE_REFARG_ERROR", 25)) {
      /*                              ^                */
        *iv_return = PBX_E_INVOKE_REFARG_ERROR;
        return PERL_constant_ISIV;
      }
      break;
    case 'I':
      if (memEQ(name, "PBX_E_REGISTRATION_FAILED", 25)) {
      /*                              ^                */
        *iv_return = PBX_E_REGISTRATION_FAILED;
        return PERL_constant_ISIV;
      }
      break;
    }
    break;
  case 26:
    /* Names all of length 26.  */
    /* PBX_E_MISMATCHED_DATA_TYPE PBX_E_NO_REGISTER_FUNCTION */
    /* Offset 6 gives the best switch position.  */
    switch (name[6]) {
    case 'M':
      if (memEQ(name, "PBX_E_MISMATCHED_DATA_TYPE", 26)) {
      /*                     ^                          */
        *iv_return = PBX_E_MISMATCHED_DATA_TYPE;
        return PERL_constant_ISIV;
      }
      break;
    case 'N':
      if (memEQ(name, "PBX_E_NO_REGISTER_FUNCTION", 26)) {
      /*                     ^                          */
        *iv_return = PBX_E_NO_REGISTER_FUNCTION;
        return PERL_constant_ISIV;
      }
      break;
    }
    break;
  case 27:
    /* Names all of length 27.  */
    /* PBX_E_INVOKE_WRONG_NUM_ARGS PB_CONNECTION_CACHE_SERVICE */
    /* Offset 17 gives the best switch position.  */
    switch (name[17]) {
    case 'G':
      if (memEQ(name, "PBX_E_INVOKE_WRONG_NUM_ARGS", 27)) {
      /*                                ^                */
        *iv_return = PBX_E_INVOKE_WRONG_NUM_ARGS;
        return PERL_constant_ISIV;
      }
      break;
    case 'H':
      if (memEQ(name, "PB_CONNECTION_CACHE_SERVICE", 27)) {
      /*                                ^                */
        *iv_return = PB_CONNECTION_CACHE_SERVICE;
        return PERL_constant_ISIV;
      }
      break;
    }
    break;
  case 29:
    /* Names all of length 29.  */
    /* PBX_E_INVOKE_METHOD_AMBIGUOUS PB_CONNECTION_CACHE_C_SERVICE */
    /* Offset 18 gives the best switch position.  */
    switch (name[18]) {
    case 'D':
      if (memEQ(name, "PBX_E_INVOKE_METHOD_AMBIGUOUS", 29)) {
      /*                                 ^                 */
        *iv_return = PBX_E_INVOKE_METHOD_AMBIGUOUS;
        return PERL_constant_ISIV;
      }
      break;
    case 'E':
      if (memEQ(name, "PB_CONNECTION_CACHE_C_SERVICE", 29)) {
      /*                                 ^                 */
        *iv_return = PB_CONNECTION_CACHE_C_SERVICE;
        return PERL_constant_ISIV;
      }
      break;
    }
    break;
  case 30:
    if (memEQ(name, "PBX_E_ARRAY_INDEX_OUTOF_BOUNDS", 30)) {
      *iv_return = PBX_E_ARRAY_INDEX_OUTOF_BOUNDS;
      return PERL_constant_ISIV;
    }
    break;
  case 32:
    /* Names all of length 32.  */
    /* PBX_E_CAN_NOT_LOCATE_APPLICATION PBX_E_INVOKE_METHOD_INACCESSABLE */
    /* Offset 10 gives the best switch position.  */
    switch (name[10]) {
    case 'K':
      if (memEQ(name, "PBX_E_INVOKE_METHOD_INACCESSABLE", 32)) {
      /*                         ^                            */
        *iv_return = PBX_E_INVOKE_METHOD_INACCESSABLE;
        return PERL_constant_ISIV;
      }
      break;
    case 'N':
      if (memEQ(name, "PBX_E_CAN_NOT_LOCATE_APPLICATION", 32)) {
      /*                         ^                            */
        *iv_return = PBX_E_CAN_NOT_LOCATE_APPLICATION;
        return PERL_constant_ISIV;
      }
      break;
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

