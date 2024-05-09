1 pragma solidity 0.4.8;
2 
3 contract MyPasswordHint {
4     string public hint;
5     address public owner;
6     /* Constructor */
7     function MyPasswordHint() {
8         hint = "";
9         owner = msg.sender;
10     }
11     function setHint(string nHint) {
12         if (msg.sender == owner) {
13             hint = nHint;
14         }
15     }
16     function kill() {
17         if (msg.sender == owner) {
18             selfdestruct(owner);
19         }
20     }
21 }