The gist of Redux DevTools is:

```js
// grab the devTools extension instance and connect to it to create an instance
const inst = window.__REDUX_DEVTOOLS_EXTENSION__.connect({
  name: "hello world"
});

// subscribe to the instance messages
inst.subscribe(console.log);

// you might have some non-JSON state like the following class
class MyCrap {
  constructor() {
    this.crap = "mycrap";
    return 123;
  }
}

const crap = new MyCrap();

// when you feed the instance your initial state, the state will be JSONified
inst.init(crap);

// example error you can display in the devTools
inst.error("hi error");

crap.crap = "changed crap";
// sending updates to the devtool
inst.send("my action", crap);

crap.crap = "changed crap 2";
inst.send("my action2", crap);

crap.crap = "changed crap 3";
inst.send("my action3", crap);
```

Example JUMP command:

```js
{
  "type": "DISPATCH",
  "payload": {
    "type": "JUMP_TO_ACTION",
    "actionId": 3
  },
  "state": "{\"crap\":\"changed crap 3\"}",
  "id": "1",
  "source": "@devtools-extension"
}
```
