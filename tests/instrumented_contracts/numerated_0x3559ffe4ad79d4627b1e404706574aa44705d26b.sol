1 contract DigitalPadlock {
2     string public message;
3 
4     function DigitalPadlock(string _m) public {
5         message = _m;
6     }
7 }
8 
9 contract EthernalLoveParent {
10   address owner;
11   address[] public padlocks;
12   event LogCreatedValentine(address padlock); // maybe listen for events
13 
14   function EthernalLoveParent() public {
15     owner = msg.sender;
16   }
17 
18   function createPadlock(string _m) public {
19     DigitalPadlock d = new DigitalPadlock(_m);
20     LogCreatedValentine(d); // emit an event
21     padlocks.push(d); 
22   }
23 }