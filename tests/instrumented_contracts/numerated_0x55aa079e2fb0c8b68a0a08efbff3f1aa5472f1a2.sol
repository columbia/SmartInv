1 pragma solidity ^0.4.21;
2 
3 contract WannabeSmartInvestor {
4     
5     address private owner;
6     mapping(address => uint) public incomeFrom;
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11     
12     function invest(address _to, uint _gas) public payable {
13         require(msg.sender == owner);
14         require(_to.call.gas(_gas).value(msg.value)());
15     }
16     
17     function withdraw() public {
18         require(msg.sender == owner);
19         owner.transfer(address(this).balance);
20     }
21 
22     function () public payable {
23         incomeFrom[msg.sender] = incomeFrom[msg.sender] + msg.value;
24     }     
25 
26 }