1 pragma solidity ^0.4.20;
2 
3 contract Mintable {
4     
5   function mint(address _to, uint256 _amount) public returns (bool);
6   
7 }
8 
9 
10 contract SimpleDistributor {
11     
12   address public owner;
13     
14   Mintable public token = Mintable(0x552Ed8253f341fb770E8BAdff5A0E0Ee2fd57B43);
15     
16   function SimpleDistributor() public {
17     owner = msg.sender;
18   }
19    
20   function addReceivers(address[] receivers, uint[] balances) public {
21     require(msg.sender == owner);
22     for(uint i = 0; i < receivers.length; i++) {
23       token.mint(receivers[i], balances[i]);
24     }
25   } 
26   
27 }