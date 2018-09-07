exports._getExtension = function() {
  return window && window.__REDUX_DEVTOOLS_EXTENSION__;
};

exports._connect = function(ext, options) {
  return ext.connect(options);
};

exports._subscribe = function(inst, cb) {
  inst.subscribe(cb);
};

exports._unsubscribe = function(inst) {
  inst.unsubscribe();
};

exports._send = function(inst, action, state) {
  inst.send(action, state);
};

exports._init = function(inst, state) {
  inst.init(state);
};

exports._error = function(msg) {
  inst.error(msg);
};
