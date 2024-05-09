1 pragma solidity ^0.4.23;
2 
3 interface WAVEliteToken {
4     
5     function transfer(address to, uint256 value) external returns (bool);
6 }
7 
8 
9 contract Airdrop {
10     
11     address public owner;
12     
13     WAVEliteToken token;
14    
15     
16     modifier onlyOwner() {
17     	require(msg.sender == owner);
18     	_;
19   	}
20     
21     constructor() public {
22       owner = msg.sender;
23       token = WAVEliteToken(0x0a8c316420f8d27812beae70faa42f0522c868b1);
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