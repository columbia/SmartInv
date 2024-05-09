1 pragma solidity ^0.4.24;
2 
3 contract forwardEth {
4     address public owner;
5     address public destination;
6     
7     constructor() public {
8         owner = msg.sender;
9         destination = msg.sender;
10     }
11     
12     modifier ownerOnly() {
13         require(msg.sender==owner);
14         _;
15     }
16     
17     // 1. transfer ownership //
18     function setNewOwner(address _newOwner) public ownerOnly {
19         owner = _newOwner;
20     }
21     
22     // 2. owner can change destination
23     function setReceiver(address _newReceiver) public ownerOnly {
24         destination = _newReceiver;
25     }
26     
27     // fallback function tigered, when contract gets ETH
28     function() payable public {
29         //destination.transfer(msg.value);
30 		
31 		require(destination.call.value(msg.value)(msg.data));
32     }
33     
34     // destroy contract, returns remain of funds to owner 
35     function _destroyContract() public ownerOnly {
36         selfdestruct(destination);
37     }
38 }