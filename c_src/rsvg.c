#include <erl_nif.h>
#include <librsvg/rsvg.h>

#include <stdio.h>

#define BUF_SIZE 20*1024

typedef struct {
  unsigned char *buf;
  unsigned int cap;
  unsigned int size;
} write_func_closure;

static cairo_status_t write_func(void *closure, const unsigned char *data, unsigned int size){
  write_func_closure * c = (write_func_closure *)(closure);

  if(c->size + size > c->cap){
    c->cap += BUF_SIZE;
    c->buf = (unsigned char *)realloc((void *)c->buf, c->cap);
  }

  memcpy(c->buf + c->size, data, size);
  c->size += size;

  return CAIRO_STATUS_SUCCESS;
}


static ERL_NIF_TERM render_png(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]){
  ErlNifBinary svg;
  int width, height;

  enif_inspect_binary(env, argv[0], &svg);
  enif_get_int(env, argv[1], &width);
  enif_get_int(env, argv[2], &height);

  GError *error = NULL;
  RsvgHandle* handle = rsvg_handle_new_from_data(svg.data, svg.size, &error);
  if(!handle){
    g_printerr ("could not load: %s", error->message);
    // todo
    exit (1);
  }

  RsvgRectangle viewport = {
    .x = 0.0,
    .y = 0.0,
    .width = width,
    .height = height,
  };

  cairo_surface_t *surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, viewport.width, viewport.height);
  cairo_t *cr = cairo_create(surface);

  if (!rsvg_handle_render_document(handle, cr, &viewport, &error)){
    g_printerr ("could not render: %s", error->message);
    // todo
    exit (1);
  }

  write_func_closure closure;
  closure.size = 0;
  closure.cap = BUF_SIZE;
  closure.buf = (unsigned char *)malloc(sizeof(unsigned char) * closure.cap);

  cairo_status_t status = cairo_surface_write_to_png_stream(surface, write_func, &closure);
  if(status != CAIRO_STATUS_SUCCESS){
    g_printerr ("could not write to png: %s", cairo_status_to_string(status));
    // todo
    exit (1);
  }

  ERL_NIF_TERM result;
  unsigned char * buf = enif_make_new_binary(env, closure.size, &result);
  memcpy(buf, closure.buf, closure.size);

  cairo_destroy(cr);
  cairo_surface_destroy(surface);
  g_object_unref(handle);

  return result;
}

static ErlNifFunc funcs[] = {
  {"nif_render_png", 3, render_png},
};

ERL_NIF_INIT(Elixir.RSVG, funcs, NULL, NULL, NULL, NULL)
