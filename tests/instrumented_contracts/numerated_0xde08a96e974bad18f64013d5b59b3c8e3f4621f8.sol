1 pragma solidity ^0.4.20;
2 
3 contract Mintable {
4     
5   function mint(address _to, uint256 _amount) public returns (bool);
6   
7   function transfer(address to, uint256 value) public returns (bool);
8   
9 }
10 
11 
12 contract SimpleDistributor {
13     
14   address public owner;
15     
16   Mintable public token = Mintable(0x552Ed8253f341fb770E8BAdff5A0E0Ee2fd57B43);
17     
18   function SimpleDistributor() public {
19     owner = msg.sender;
20   }
21    
22   function addReceivers(address[] receivers, uint[] balances) public {
23     require(msg.sender == owner);
24     for(uint i = 0; i < receivers.length; i++) {
25       token.mint(this, balances[i]);  
26       token.transfer(receivers[i], balances[i]);
27     }
28   } 
29   
30 }