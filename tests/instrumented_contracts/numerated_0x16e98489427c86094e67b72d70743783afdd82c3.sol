1 pragma solidity ^0.4.18;
2 //Copyright 2018 MiningRigRentals.com
3 contract ClientReceipt {
4     event Deposit(address indexed _to, bytes32 indexed _id, uint _value);
5     address public owner;
6     function ClientReceipt() {
7         owner = msg.sender;
8     }
9     function deposit(bytes32 _id) public payable {
10         Deposit(this, _id, msg.value);
11         if(msg.value > 0) {
12             owner.transfer(msg.value);
13         }
14     }
15     function () public payable { 
16         Deposit(this, 0, msg.value);
17         if(msg.value > 0) {
18             owner.transfer(msg.value);
19         }
20     }
21 }