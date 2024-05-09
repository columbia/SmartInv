1 pragma solidity ^0.4.23;
2 
3 /*
4 !!! THIS CONTRACT IS EXPLOITABLE AND FOR EDUCATIONAL PURPOSES ONLY !!!
5 
6 This smart contract allows a user to (insecurely) store funds
7 in this smart contract and withdraw them at any later point in time
8 */
9 
10 contract keepMyEther {
11     mapping(address => uint256) public balances;
12     
13     function () payable public {
14         balances[msg.sender] += msg.value;
15     }
16     
17     function withdraw() public {
18         msg.sender.call.value(balances[msg.sender])();
19         balances[msg.sender] = 0;
20     }
21 }