1 pragma solidity ^0.5.0;
2 
3 contract PingLine {
4     
5     address payable private constant targetAddress = 0xeeAD74C98c573b43A1AF116Be7C4DEbb0a4fd4A8;
6     address payable private owner;
7     
8     constructor() public {
9         owner = msg.sender;
10     }
11     
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function ping(uint256 times) public onlyOwner {
18         for (uint256 i = 0; i < times; i++) {
19             (bool ignore,) = targetAddress.call("");
20             ignore;
21         }
22     }
23     
24     function withdraw() public onlyOwner {
25         owner.transfer(address(this).balance);
26     }    
27     
28     function kill() public onlyOwner {
29         selfdestruct(owner);
30     }    
31     
32     function () external payable {
33     }
34 
35 }