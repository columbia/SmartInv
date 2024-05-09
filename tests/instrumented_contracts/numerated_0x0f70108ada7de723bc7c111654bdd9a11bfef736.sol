1 pragma solidity ^0.4.19;
2 
3 
4 contract theRelayer {
5     address public owner;
6     address public target;
7     
8     function theRelayer(address _target) public {
9         owner = msg.sender;
10         target = _target;
11     }
12     
13     function () public {
14         require(msg.sender == owner);
15         require(gasleft() > 400000);
16         
17         uint256 gasToForward = 400000 - 200;
18         gasToForward -= gasToForward % 8191;
19         gasToForward += 388;
20         
21         target.call.gas(gasToForward)(msg.data);
22     }
23     
24     function setTarget(address _target) public {
25         require(msg.sender == owner);
26         
27         target = _target;
28     }
29 }