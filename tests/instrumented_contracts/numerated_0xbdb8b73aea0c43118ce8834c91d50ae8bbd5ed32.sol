1 pragma solidity ^0.4.11;
2 
3 contract MumsTheWord {
4 
5     uint32 public lastCreditorPayedOut;
6     uint public lastTimeOfNewCredit;
7     uint public jackpot;
8     address[] public creditorAddresses;
9     uint[] public creditorAmounts;
10     address public owner;
11 	uint8 public round;
12 	
13 	// eight hours
14     uint constant EIGHT_HOURS = 28800;
15 	uint constant MIN_AMOUNT = 10 ** 16;
16 
17     function MumsTheWord() {
18         // owner of the contract will provide the initial jackpot!
19         jackpot = msg.value;
20         owner = msg.sender;
21         lastTimeOfNewCredit = now;
22     }
23 
24     function enter() payable returns (bool) {
25         uint amount = msg.value;
26         // check if 8h have passed
27         if (lastTimeOfNewCredit + EIGHT_HOURS > now) {
28             // Return money to sender
29             msg.sender.transfer(amount);
30             // Sends jackpot to the last player
31             creditorAddresses[creditorAddresses.length - 1].transfer(jackpot);
32             owner.transfer(this.balance);
33             // Reset contract state
34             lastCreditorPayedOut = 0;
35             lastTimeOfNewCredit = now;
36             jackpot = 0;
37             creditorAddresses = new address[](0);
38             creditorAmounts = new uint[](0);
39             round += 1;
40             return false;
41         } else {
42             // the system needs to collect at least 1% of the profit from a crash to stay alive
43             if (amount >= MIN_AMOUNT) {
44                 // the System has received fresh money, it will survive at least 8h more
45                 lastTimeOfNewCredit = now;
46                 // register the new creditor and his amount with 10% interest rate
47                 creditorAddresses.push(msg.sender);
48                 creditorAmounts.push(amount * 110 / 100);
49 				
50                 // 5% fee
51                 owner.transfer(amount * 5/100);
52 				
53                 // 5% are going to the jackpot (will increase the value for the last person standing)
54                 if (jackpot < 100 ether) {
55                     jackpot += amount * 5/100;
56                 }
57 				
58                 // 90% of the money will be used to pay out old creditors
59                 if (creditorAmounts[lastCreditorPayedOut] <= address(this).balance - jackpot) {
60                     creditorAddresses[lastCreditorPayedOut].transfer(creditorAmounts[lastCreditorPayedOut]);
61                     lastCreditorPayedOut += 1;
62                 }
63                 return true;
64             } else {
65                 msg.sender.transfer(amount);
66                 return false;
67             }
68         }
69     }
70 
71     // fallback function
72     function() payable {
73         enter();
74     }
75 
76     function totalDebt() returns (uint debt) {
77         for(uint i=lastCreditorPayedOut; i<creditorAmounts.length; i++){
78             debt += creditorAmounts[i];
79         }
80     }
81 
82     function totalPayedOut() returns (uint payout) {
83         for(uint i=0; i<lastCreditorPayedOut; i++){
84             payout += creditorAmounts[i];
85         }
86     }
87 
88     // better don't do it (unless you want to increase the jackpot)
89     function raiseJackpot() payable {
90         jackpot += msg.value;
91     }
92 
93     function getCreditorAddresses() returns (address[]) {
94         return creditorAddresses;
95     }
96 
97     function getCreditorAmounts() returns (uint[]) {
98         return creditorAmounts;
99     }
100 }