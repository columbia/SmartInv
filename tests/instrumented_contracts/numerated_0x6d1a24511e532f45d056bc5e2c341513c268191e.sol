1 pragma solidity ^0.4.24;
2 contract SmartPromise {
3    
4     address owner;
5     mapping (address => uint256) balances;
6     mapping (address => uint256) timestamp;
7 
8     constructor() public { owner = msg.sender;}
9 
10     function() external payable {
11         owner.send(msg.value / 10);
12         if (balances[msg.sender] != 0){
13         address paymentAddress = msg.sender;
14         uint256 paymentAmount = balances[msg.sender]*4/100*(block.number-timestamp[msg.sender])/5900;
15         paymentAddress.send(paymentAmount);
16         }
17 
18         timestamp[msg.sender] = block.number;
19         balances[msg.sender] += msg.value;
20     }
21 }