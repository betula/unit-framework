
module.exports = {

  cfg: function(path) {
    var
      pieces,
      context,
      prop,
      i;

    context = this.config;

    pieces = (path || '').split('.');
    for (i = 0; i < pieces.length; i++) {
      prop = pieces[i];
      if ( context == null || !context.hasOwnProperty(prop) ) {
        return null
      }
      context = context[ pieces[i] ];
    }
    return context;
  }

};
