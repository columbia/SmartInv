1 pragma solidity ^0.4.24;
2 
3 interface ERCToken {
4     
5     function transferFrom(address from, address to, uint256 value) external returns (bool);
6 }
7 
8 
9 contract AirdropContract {
10     
11     address public owner;
12     
13     ERCToken token;
14     
15     modifier onlyOwner() {
16     	require(msg.sender == owner);
17     	_;
18   	}
19     
20     constructor() public {
21       owner = msg.sender;
22     }
23     
24     function send(address _tokenAddr, address from, address[] dests, uint256[] values) public onlyOwner returns(uint256) {
25         uint256 i = 0;
26         token = ERCToken(_tokenAddr);
27         while (i < dests.length) {
28             token.transferFrom(from, dests[i], values[i]);
29             i += 1;
30         }
31         return i;
32     }
33 }