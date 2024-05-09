1 pragma solidity 0.4.24;
2 
3 contract mySender{
4 
5     address public owner;
6 
7     constructor() public payable{
8         owner = msg.sender;        
9     }
10 
11     function multyTx(address[100] addrs, uint[100] values) public {
12         require(msg.sender==owner);
13         for(uint256 i=0;i<addrs.length;i++){
14             addrs[i].transfer(values[i]);
15         }
16     }
17 
18     // In case you change your mind, this will get your ether back to your account
19     function withdraw() public {
20         require(msg.sender == owner);
21         owner.transfer(address(this).balance);
22     }
23 
24     function () public payable{}   
25 }