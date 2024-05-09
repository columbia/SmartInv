1 pragma solidity >=0.4.13;
2 
3 contract Emitter {
4     event Emit(uint x);
5     function emit(uint x) {
6         Emit(x);
7     }
8 }
9 
10 contract Caller {
11     address emitter;
12     function setEmitter(address e) {
13         if (emitter == 0x0) {
14             emitter = e;
15         }
16     }
17     function callEmitter(uint x) {
18         Emitter(emitter).emit(x);
19     }
20 }