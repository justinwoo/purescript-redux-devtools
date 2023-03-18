export const _getExtension = function() {
  return window && window.__REDUX_DEVTOOLS_EXTENSION__;
};

export const _connect = function(ext, options) {
  return ext.connect(options);
};

export const _subscribe = function(inst, cb) {
  inst.subscribe(cb);
};

export const _unsubscribe = function(inst) {
  inst.unsubscribe();
};

export const _send = function(inst, action, state) {
  inst.send(action, state);
};

export const _init = function(inst, state) {
  inst.init(state);
};

export const _error = function(msg) {
  inst.error(msg);
};
