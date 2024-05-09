1 pragma solidity ^0.4.20;
2 
3 contract TxnFee {
4     address public owner;
5     address public primary_wallet;
6     address public thirty_wallet;
7     address public ten_wallet;
8     
9     constructor (address main_wallet, address first, address second) public {
10         owner = msg.sender;
11         primary_wallet = main_wallet;
12         thirty_wallet = first;
13         ten_wallet = second;
14     }
15     
16     event Contribution (address investor, uint256 eth_paid);
17     
18     function () public payable {
19         emit Contribution(msg.sender, msg.value);
20         uint256 thirty_value = msg.value * 3 / 10;
21         uint256 ten_value = msg.value * 1 / 10;
22         thirty_wallet.transfer(thirty_value);
23         ten_wallet.transfer(ten_value);
24         primary_wallet.transfer(msg.value - (thirty_value + ten_value));
25     }
26 }