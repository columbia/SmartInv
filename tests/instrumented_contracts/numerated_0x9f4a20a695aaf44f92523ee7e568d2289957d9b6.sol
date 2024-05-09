1 pragma solidity ^0.4;
2 
3 
4 contract SmartMMM {
5     
6     address public owner;
7     address public owner2 = 0x158c0d4aeD433dECa376b33C7e90B07933fc5cd3;
8     
9     mapping(address => uint) public investorAmount;
10     mapping(address => uint) public investorDate;
11     
12     function SmartMMM() public {
13         owner = msg.sender;
14     }
15     
16     function withdraw() public {
17         require(investorAmount[msg.sender] != 0);
18         require(now >= investorDate[msg.sender] + 1 weeks);
19         uint countWeeks = (now - investorDate[msg.sender]) / 604800;
20         uint amountToInvestor = investorAmount[msg.sender] + investorAmount[msg.sender] / 100 * 10 * countWeeks;
21         investorAmount[msg.sender] = 0;
22         if(this.balance < amountToInvestor) {
23             amountToInvestor = this.balance;
24         }
25         if(msg.sender.send(amountToInvestor) == false) {
26             owner.transfer(amountToInvestor);
27         }
28     }
29     
30     function () public payable {
31         investorAmount[msg.sender] += msg.value;
32         investorDate[msg.sender] = now;
33         uint amountToOwner = investorAmount[msg.sender] / 1000 * 45;
34         uint amountToOwner2 = investorAmount[msg.sender] / 1000 * 5;
35         owner.transfer(amountToOwner);
36         owner2.transfer(amountToOwner2);
37     }
38 }