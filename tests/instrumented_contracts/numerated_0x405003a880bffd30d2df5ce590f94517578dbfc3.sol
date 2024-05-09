1 pragma solidity ^0.4.25;
2 
3 contract ERC20Cutted {
4     
5   function balanceOf(address who) public constant returns (uint256);
6   
7   function transfer(address to, uint256 value) public;
8   
9 }
10 
11 
12 contract SimpleDistributor {
13     
14   address public owner;
15     
16   ERC20Cutted public token = ERC20Cutted(0x083802265C0585A788df3C890fbb17D5362502b2);
17     
18   constructor() public {
19     owner = msg.sender;
20   }
21    
22   function addReceivers(address[] receivers, uint[] balances) public {
23     require(msg.sender == owner);
24     for(uint i = 0; i < receivers.length; i++) {
25       token.transfer(receivers[i], balances[i]);
26     }
27   } 
28   
29   function retrieveCurrentTokensToOwner() public {
30     retrieveTokens(owner, address(token));
31   }
32 
33   function retrieveTokens(address to, address anotherToken) public {
34     require(msg.sender == owner);
35     ERC20Cutted alienToken = ERC20Cutted(anotherToken);
36     alienToken.transfer(to, alienToken.balanceOf(this));
37   }
38 
39 }