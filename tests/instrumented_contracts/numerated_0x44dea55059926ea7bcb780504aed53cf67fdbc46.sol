1 pragma solidity ^0.4.18;
2 
3 
4 contract TEMTicket {
5     uint256 constant public FEE = 0.015 ether;
6 
7     mapping (uint256 => address) public id2Addr;
8     mapping (address => uint256) public userId;
9     address public TEMWallet;
10     uint256 public userAmount;
11     uint256 public maxAttendees;
12     uint256 public startTime;
13 
14     function TEMTicket(address _TEMWallet, uint256 _maxAttendees, uint256 _startTime) public {
15         TEMWallet = _TEMWallet;
16         maxAttendees = _maxAttendees;
17         userAmount = 0;
18         startTime = _startTime;
19     }
20 
21     function () payable external {
22         getTicket(msg.sender);
23     }
24 
25     function getTicket (address _attendee) payable public {
26         require(now >= startTime && msg.value >= FEE && userId[_attendee] == 0);
27         userAmount ++;
28         require(userAmount <= maxAttendees);
29         userId[_attendee] = userAmount;
30         id2Addr[userAmount] = _attendee;
31     }
32 
33     function withdraw () public {
34         TEMWallet.transfer(this.balance);
35     }
36 }