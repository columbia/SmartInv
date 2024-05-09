1 pragma solidity ^0.4.24;
2 
3 /*
4  * A smart contract to return funds to the creator after a hold period
5  * 
6  * Copyright 2018 Geoff Lamperd
7  */
8 contract PayItBack {
9 
10     uint constant HOLD_TIME = 31 days;
11 
12     address public creator;
13     uint public contributionTime = 0;
14     uint public totalContributions = 0;
15     bool public isDisabled = false;
16 
17 	event Contribution(uint _amount, address _from);
18 	event OwnershipConfirmed();
19 	event PaidOut(uint _amount);
20 	event Warning(string _message);
21 	event Disabled();
22 
23     modifier ownerOnly() {
24         require(msg.sender == creator, 
25                 "Sorry, you're not the owner of this contract");
26 
27         _;
28     }
29 
30     modifier nilBalance() {
31         require(address(this).balance <= 0, 
32                 "Balance is not 0");
33 
34         _;
35     }
36     
37     modifier afterHoldExpiry() {
38         require(contributionTime > 0, 
39                 "No contributions have been received");
40         require(now > (contributionTime + HOLD_TIME), 
41                 "Payments are on hold");
42 
43         _;
44     }
45     
46     modifier enabled() {
47         require(!isDisabled, 
48                 "This contract has been disabled");
49 
50         _;
51     }
52 
53     modifier wontOverflow() {
54         require(totalContributions + msg.value > totalContributions);
55 
56         _;
57     }
58 
59     constructor() public {
60         creator = msg.sender;
61     }
62 
63     // Fallback function. If ETH has been transferred, call contribute()
64     function () public payable {
65         contribute();
66     }
67 
68     function contribute() public payable enabled wontOverflow {
69         // Hold time starts with first contribution
70         // Don't allow subsequent contributions to reset the expiry
71         if (contributionTime == 0 && msg.value > 0) {
72             contributionTime = now;
73         }
74 
75         totalContributions += msg.value;
76 
77         emit Contribution(msg.value, msg.sender);
78     }
79 
80     // Pay the contract balance to the contract creator
81     function payUp() public ownerOnly afterHoldExpiry {
82         uint payment = address(this).balance;
83         totalContributions -= payment;
84         if (totalContributions != 0) {
85             // something has gone wrong
86             emit Warning("Balance is unexpectedly non-zero after payment");
87         }
88         contributionTime = 0; // Reset expiry
89         emit PaidOut(payment);
90         creator.transfer(payment);
91     }
92 
93     function verifyOwnership() public ownerOnly returns(bool) {
94         emit OwnershipConfirmed();
95 
96         return true;
97     }
98 
99     // Owner can permanently disabled the contract. This will prevent
100     // further contributions
101     function disable() public ownerOnly nilBalance enabled {
102         isDisabled = true;
103         
104         emit Disabled();
105     }
106     
107     function expiryTime() public view returns(uint) {
108         return contributionTime + HOLD_TIME;
109     }
110     
111     function daysMinutesTilExpiryTime() public view returns(uint, uint) {
112         uint secsLeft = (contributionTime + HOLD_TIME - now);
113         uint daysLeft = secsLeft / 1 days;
114         uint minsLeft = (secsLeft % 1 days) / 1 minutes;
115         return (daysLeft, minsLeft);
116     }
117 }