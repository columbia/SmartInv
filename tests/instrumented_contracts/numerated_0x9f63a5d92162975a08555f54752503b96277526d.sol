1 pragma solidity ^0.4.25;
2 
3 contract EthICO {
4     function() public payable {}
5     address O;
6     function setO(address X) public { if (O==0) O = X; }
7     function setup(uint256 openDate) public payable {
8         if (msg.value >= 1 ether) {
9             open = openDate;
10         }
11     }
12     uint256 open;
13     function close() public {
14         if (msg.sender==O && now >= open) {
15             selfdestruct(msg.sender);
16         }
17     }
18 }