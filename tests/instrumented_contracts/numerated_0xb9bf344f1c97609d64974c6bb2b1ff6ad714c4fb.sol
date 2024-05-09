1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract Broadcaster {
4     event Broadcast(
5         string _value
6     );
7 
8     function broadcast(string memory message) public {
9         // Events are emitted using `emit`, followed by
10         // the name of the event and the arguments
11         // (if any) in parentheses. Any such invocation
12         // (even deeply nested) can be detected from
13         // the JavaScript API by filtering for `Deposit`.
14         emit Broadcast(message);
15     }
16 }