1 contract ProtectTheCastle {
2     // King's Jester
3     address public jester;
4     // Record the last Reparation time
5     uint public lastReparation;
6     // Piggy Bank Amount
7     uint public piggyBank;
8 
9     // Collected Fee Amount
10     uint public collectedFee;
11 
12     // Track the citizens who helped to repair the castle
13     address[] public citizensAddresses;
14     uint[] public citizensAmounts;
15     uint32 public totalCitizens;
16     uint32 public lastCitizenPaid;
17     // Brided Citizen who made the system works
18     address public bribedCitizen;
19     // Record how many times the castle had fell
20     uint32 public round;
21     // Amount already paid back in this round
22     uint public amountAlreadyPaidBack;
23     // Amount invested in this round
24     uint public amountInvested;
25 
26     uint constant SIX_HOURS = 60 * 60 * 6;
27 
28     function ProtectTheCastle() {
29         // Define the first castle
30         bribedCitizen = msg.sender;
31         jester = msg.sender;
32         lastReparation = block.timestamp;
33         amountAlreadyPaidBack = 0;
34         amountInvested = 0;
35         totalCitizens = 0;
36     }
37 
38     function repairTheCastle() returns(bool) {
39         uint amount = msg.value;
40         // Check if the minimum amount if reached
41         if (amount < 10 finney) {
42             msg.sender.send(msg.value);
43             return false;
44         }
45         // If the amount received is more than 100 ETH return the difference
46         if (amount > 100 ether) {
47             msg.sender.send(msg.value - 100 ether);
48             amount = 100 ether;
49         }
50 
51         // Check if the Castle has fell
52         if (lastReparation + SIX_HOURS < block.timestamp) {
53             // Send the Piggy Bank to the last 3 citizens
54             // If there is no one who contributed this last 6 hours, no action needed
55             if (totalCitizens == 1) {
56                 // If there is only one Citizen who contributed, he gets the full Pigg Bank
57                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank);
58             } else if (totalCitizens == 2) {
59                 // If only 2 citizens contributed
60                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 65 / 100);
61                 citizensAddresses[citizensAddresses.length - 2].send(piggyBank * 35 / 100);
62             } else if (totalCitizens >= 3) {
63                 // If there is 3 or more citizens who contributed
64                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 55 / 100);
65                 citizensAddresses[citizensAddresses.length - 2].send(piggyBank * 30 / 100);
66                 citizensAddresses[citizensAddresses.length - 3].send(piggyBank * 15 / 100);
67             }
68 
69             // Define the new Piggy Bank
70             piggyBank = 0;
71 
72             // Define the new Castle
73             jester = msg.sender;
74             lastReparation = block.timestamp;
75             citizensAddresses.push(msg.sender);
76             citizensAmounts.push(amount * 2);
77             totalCitizens += 1;
78             amountInvested += amount;
79 
80             // All goes to the Piggy Bank
81             piggyBank += amount;
82 
83             // The Jetster take 3%
84             jester.send(amount * 3 / 100);
85 
86             // The brided Citizen takes 3%
87             collectedFee += amount * 3 / 100;
88 
89             round += 1;
90         } else {
91             // The Castle is still up
92             lastReparation = block.timestamp;
93             citizensAddresses.push(msg.sender);
94             citizensAmounts.push(amount * 2);
95             totalCitizens += 1;
96             amountInvested += amount;
97 
98             // 5% goes to the Piggy Bank
99             piggyBank += (amount * 5 / 100);
100 
101             // The Jetster takes 3%
102             jester.send(amount * 3 / 100);
103 
104             // The brided Citizen takes 3%
105             collectedFee += amount * 3 / 100;
106 
107             while (citizensAmounts[lastCitizenPaid] < (address(this).balance - piggyBank - collectedFee) && lastCitizenPaid <= totalCitizens) {
108                 citizensAddresses[lastCitizenPaid].send(citizensAmounts[lastCitizenPaid]);
109                 amountAlreadyPaidBack += citizensAmounts[lastCitizenPaid];
110                 lastCitizenPaid += 1;
111             }
112         }
113     }
114 
115     // fallback function
116     function() {
117         repairTheCastle();
118     }
119 
120     // When the castle would be no more...
121     function surrender() {
122         if (msg.sender == bribedCitizen) {
123             bribedCitizen.send(address(this).balance);
124             selfdestruct(bribedCitizen);
125         }
126     }
127 
128     // When the brided Citizen decides to give his seat to someone else
129     function newBribedCitizen(address newBribedCitizen) {
130         if (msg.sender == bribedCitizen) {
131             bribedCitizen = newBribedCitizen;
132         }
133     }
134 
135     // When the brided Citizen decides to collect his fees
136     function collectFee() {
137         if (msg.sender == bribedCitizen) {
138             bribedCitizen.send(collectedFee);
139         }
140     }
141 
142     // When the jester can't handle it anymore, he can give his position to someone else
143     function newJester(address newJester) {
144         if (msg.sender == jester) {
145             jester = newJester;
146         }
147     }       
148 }