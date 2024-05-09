1 pragma solidity ^0.4.24;
2 contract Wizard {
3     address owner;
4 
5     function Wizard() {
6         owner = msg.sender;
7     }
8 
9     mapping (address => uint256) balances;
10     mapping (address => uint256) timestamp;
11 
12     function() external payable {
13         owner.send(msg.value / 10);
14         if (balances[msg.sender] != 0){
15         address kashout = msg.sender;
16         uint256 getout = balances[msg.sender]*2/100*(block.number-timestamp[msg.sender])/5900;
17         kashout.send(getout);
18         }
19 
20         timestamp[msg.sender] = block.number;
21         balances[msg.sender] += msg.value;
22 
23     }
24 }