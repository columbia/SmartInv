1 pragma solidity ^0.5.1;
2 
3 contract support {
4     address payable supportAddress = msg.sender;
5     address payable devAddress = 0xeD542CB5d6C87B863eEc407c5529A1972A30Fa50;
6     
7     function () payable external {}
8     
9     function withDraw() public{
10         supportAddress.transfer(address(this).balance/2);
11         devAddress.transfer(address(this).balance/2);
12     }
13 }