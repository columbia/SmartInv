1 pragma solidity ^0.4.23;
2 
3 interface FrescoToken {
4     
5     function transfer(address to, uint256 value) external returns (bool);
6 }
7 
8 
9 contract AirdropContract {
10     
11     address public owner;
12     
13     FrescoToken token;
14    
15     
16     modifier onlyOwner() {
17     	require(msg.sender == owner);
18     	_;
19   	}
20     
21     constructor() public {
22       owner = msg.sender;
23       token = FrescoToken(0x351d5eA36941861D0c03fdFB24A8C2cB106E068b);
24     }
25     
26     function send(address[] dests, uint256[] values) public onlyOwner returns(uint256) {
27         uint256 i = 0;
28         while (i < dests.length) {
29             token.transfer(dests[i], values[i]);
30             i += 1;
31         }
32         return i;
33         
34     }
35     
36     
37 }