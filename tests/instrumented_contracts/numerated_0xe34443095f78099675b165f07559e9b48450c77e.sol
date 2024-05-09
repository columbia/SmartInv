1 pragma solidity ^0.4.18;
2 
3 
4 contract Depay {
5 
6     address public developer;
7     uint public donations;
8 
9     function Depay() public {
10         developer = msg.sender;
11     }
12 
13     event Payment(address indexed sender, address indexed receiver, uint indexed amount, uint donation);
14     function pay(address recipient, uint donation) public payable {
15         require(donation < msg.value);
16         recipient.transfer(msg.value - donation);
17         donations += donation;
18         Payment(msg.sender, recipient, msg.value - donation, donation);
19     }
20 
21     function withdrawDonations(address recipient) public {
22         require(msg.sender == developer);
23         recipient.transfer(donations);
24         donations = 0;
25     }
26 }