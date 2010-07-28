// vim: filetype=ragel

%%{

  machine unpack;

  action start {
    count = 1;
    rest = false;
    platform = false;
  }

  action start_digit {
    count = fc - '0';
  }

  action count {
    count = count * 10 + (fc - '0');
  }

  action rest {
    count = 0;
    rest = true;
  }

  action platform {
    platform = true;
  }

  action byte_width {
    width = 1;
  }

  action short_width {
    width = 2;
  }

  action int_width {
    width = 4;
  }

  action long_width {
    width = 8;
  }

  action platform_width {
    if(platform) {
#if RBX_SIZEOF_LONG == 4
      width = 4;
#else
      width = 8;
#endif
    } else {
      width = 4;
    }
  }

  action set_stop {
    stop = rest ? size() + 1 : index + width * count;
    if(stop > size()) {
      stop = index + ((size() - index) / width) * width;
    }
  }

  action extra {
    while(count > 0) {
      array->append(state, Qnil);
      count--;
    }
  }

  action C {
    UNPACK_ELEMENTS(FIXNUM, UBYTE);
  }

  action c {
    UNPACK_ELEMENTS(FIXNUM, SBYTE);
  }

  action S {
    UNPACK_ELEMENTS(FIXNUM, U16BITS);
  }

  action s {
    UNPACK_ELEMENTS(FIXNUM, S16BITS);
  }

  action I {
    UNPACK_ELEMENTS(INTEGER, U32BITS);
  }

  action i {
    UNPACK_ELEMENTS(INTEGER, S32BITS);
  }

  action L {
    if(platform) {
#if RBX_SIZEOF_LONG == 4
      UNPACK_ELEMENTS(INTEGER, U32BITS);
#else
      UNPACK_ELEMENTS(INTEGER, U64BITS);
#endif
    } else {
      UNPACK_ELEMENTS(INTEGER, U32BITS);
    }
  }

  action l {
    if(platform) {
#if RBX_SIZEOF_LONG == 4
      UNPACK_ELEMENTS(INTEGER, S32BITS);
#else
      UNPACK_ELEMENTS(INTEGER, S64BITS);
#endif
    } else {
      UNPACK_ELEMENTS(INTEGER, S32BITS);
    }
  }

  action N {
    UNPACK_ELEMENTS(INTEGER, BE_U32BITS);
  }

  action n {
    UNPACK_ELEMENTS(FIXNUM, BE_U16BITS);
  }

  action V {
    UNPACK_ELEMENTS(INTEGER, LE_U32BITS);
  }

  action v {
    UNPACK_ELEMENTS(FIXNUM, LE_U16BITS);
  }

  action Q {
    UNPACK_ELEMENTS(INTEGER, U64BITS);
  }

  action q {
    UNPACK_ELEMENTS(INTEGER, S64BITS);
  }

  action non_native_error {
#define NON_NATIVE_ERROR_SIZE 36

    char non_native_msg[NON_NATIVE_ERROR_SIZE];
    snprintf(non_native_msg, NON_NATIVE_ERROR_SIZE,
             "'%c' allowed only after types sSiIlL", *p);
    Exception::argument_error(state, non_native_msg);
  }

  action done {
    return array;
  }
}%%
