1 pragma solidity ^0.4.9;
2 
3 /*
4 Protect The Castle !
5 
6 The castle is under attack and needs the help of its citizens to support the cost of war.
7 
8 If you are a loyal citizen and help to finance the defense of the castle, the King will pay you back 2 times what you invested when its fund will allow him to.
9 
10 If no one contributes to the reparation for 6 hours, the castle will fall under the attack and the last 3 citizens who financed the defense will get the King’s Piggy bank (respectively 55%, 30% and 15%).
11 
12 If you are the first one to invest after the castle has fallen, you will be the new King's Jester and take 3% of all the transactions until the castle falls again.
13 
14 There are always some people to bribe, so a small fee of 3% is taken to ensure the system keeps working.
15 
16 NO SURRENDER EDITION - no self-destruct - this game will run forever!
17 */
18 
19 contract ProtectTheCastle {
20     // King's Jester
21     address public jester;
22     // Record the last Reparation time
23     uint public lastReparation;
24     // Piggy Bank Amount
25     uint public piggyBank;
26 
27     // Collected Fee Amount
28     uint public collectedFee;
29 
30     // Track the citizens who helped to repair the castle
31     address[] public citizensAddresses;
32     uint[] public citizensAmounts;
33     uint32 public totalCitizens;
34     uint32 public lastCitizenPaid;
35     // Bribed Citizen who made the system works
36     address public bribedCitizen;
37     // Record how many times the castle has fallen
38     uint32 public round;
39     // Amount already paid back in this round
40     uint public amountAlreadyPaidBack;
41     // Amount invested in this round
42     uint public amountInvested;
43 
44     uint constant SIX_HOURS = 60 * 60 * 6;
45 
46     function ProtectTheCastle() {
47         // Define the first castle
48         bribedCitizen = msg.sender;
49         jester = msg.sender;
50         lastReparation = block.timestamp;
51         amountAlreadyPaidBack = 0;
52         amountInvested = 0;
53         totalCitizens = 0;
54     }
55 
56     function repairTheCastle() payable returns(bool) {
57         uint amount = msg.value;
58         // Check if the minimum amount if reached
59         if (amount < 10 finney) {
60             msg.sender.send(msg.value);
61             return false;
62         }
63         // If the amount received is more than 100 ETH return the difference
64         if (amount > 100 ether) {
65             msg.sender.send(msg.value - 100 ether);
66             amount = 100 ether;
67         }
68 
69         // Check if the Castle has fell
70         if (lastReparation + SIX_HOURS < block.timestamp) {
71             // Send the Piggy Bank to the last 3 citizens
72             // If there is no one who contributed this last 6 hours, no action needed
73             if (totalCitizens == 1) {
74                 // If there is only one Citizen who contributed, he gets the full Pigg Bank
75                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank);
76             } else if (totalCitizens == 2) {
77                 // If only 2 citizens contributed
78                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 65 / 100);
79                 citizensAddresses[citizensAddresses.length - 2].send(piggyBank * 35 / 100);
80             } else if (totalCitizens >= 3) {
81                 // If there are 3 or more citizens who contributed
82                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 55 / 100);
83                 citizensAddresses[citizensAddresses.length - 2].send(piggyBank * 30 / 100);
84                 citizensAddresses[citizensAddresses.length - 3].send(piggyBank * 15 / 100);
85             }
86 
87             // Define the new Piggy Bank
88             piggyBank = 0;
89 
90             // Define the new Castle
91             jester = msg.sender;
92             lastReparation = block.timestamp;
93             citizensAddresses.push(msg.sender);
94             citizensAmounts.push(amount * 2);
95             totalCitizens += 1;
96             amountInvested += amount;
97 
98             // All goes to the Piggy Bank
99             piggyBank += amount;
100 
101             // The Jester take 3%
102             jester.send(amount * 3 / 100);
103 
104             // The bribed Citizen takes 3%
105             collectedFee += amount * 3 / 100;
106 
107             round += 1;
108         } else {
109             // The Castle is still up
110             lastReparation = block.timestamp;
111             citizensAddresses.push(msg.sender);
112             citizensAmounts.push(amount * 2);
113             totalCitizens += 1;
114             amountInvested += amount;
115 
116             // 5% goes to the Piggy Bank
117             piggyBank += (amount * 5 / 100);
118 
119             // The Jester takes 3%
120             jester.send(amount * 3 / 100);
121 
122             // The bribed Citizen takes 3%
123             collectedFee += amount * 3 / 100;
124 
125             while (citizensAmounts[lastCitizenPaid] < (address(this).balance - piggyBank - collectedFee) && lastCitizenPaid <= totalCitizens) {
126                 citizensAddresses[lastCitizenPaid].send(citizensAmounts[lastCitizenPaid]);
127                 amountAlreadyPaidBack += citizensAmounts[lastCitizenPaid];
128                 lastCitizenPaid += 1;
129             }
130         }
131     }
132 
133     // fallback function
134     function() payable {
135         repairTheCastle();
136     }
137 
138     // When the bribed Citizen decides to give his seat to someone else
139     function newBribedCitizen(address newBribedCitizen) {
140         if (msg.sender == bribedCitizen) {
141             bribedCitizen = newBribedCitizen;
142         }
143     }
144 
145     // When the bribed Citizen decides to collect his fees
146     function collectFee() payable {
147         if (msg.sender == bribedCitizen) {
148             bribedCitizen.send(collectedFee);
149         }
150     }
151 
152     // When the jester can't handle it anymore, he can give his position to someone else
153     function newJester(address newJester) {
154         if (msg.sender == jester) {
155             jester = newJester;
156         }
157     }       
158 }