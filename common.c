#define DEBUG 0

#include "common.h"

_saved_callback *perl_save_callback_new(SV *func, SV *data) {
    _saved_callback *cb;

    cb = (_saved_callback *)malloc(sizeof(_saved_callback));
    memset(cb, '\0', sizeof(_saved_callback));

    cb->func = newSVsv(func);

    if (data && SvOK(data)) {
        if (SvROK(data)) {
            cb->data = newSVsv(data);
        }
        else {
            croak("Call back data is not a reference at %x\n", data);
        }
    }

    return cb;
}

void call_perl_sub(void *data, Evas_Object *obj, void *event_info) {
    dSP;

    if (data == NULL) {
        fprintf(stderr, "cb == NULL in perl_xmmsclient_callback_invoke\n");
    }

    int count;
    _saved_callback *perl_saved_cb = data;

    if (!perl_saved_cb->func) {
        return;
    }

    ENTER;
    SAVETMPS;

    PUSHMARK(SP);

    if (perl_saved_cb->data && SvOK(perl_saved_cb->data)) {
        if (DEBUG) {
            fprintf(stderr, "pushing data at %x\n", perl_saved_cb->data);
        }

       /* TODO rest of params */
       XPUSHs(perl_saved_cb->data);
    }

    PUTBACK;

    if (DEBUG) {
        fprintf(stderr, "call_perl_sub func: %x, SV *: %x, data: %x\n",
                perl_saved_cb->func,
                perl_saved_cb,
                perl_saved_cb->data);
    }

    count = call_sv(perl_saved_cb->func, G_DISCARD);
    if (count != 0) {
        croak("Expected 0 value got %d\n", count);
    }

    FREETMPS;
    LEAVE;

    /* TODO free data? */
}
