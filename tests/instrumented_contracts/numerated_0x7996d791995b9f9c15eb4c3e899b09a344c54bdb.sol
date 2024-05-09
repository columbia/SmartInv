1 contract GameOfThrones {
2     address public trueGods;
3     // King's Jester
4     address public jester;
5     // Record the last collection time
6     uint public lastCollection;
7     // Record king life
8     uint public onThrone;
9     uint public kingCost;
10     // Piggy Bank Amount
11     uint public piggyBank;
12     // Collected Fee Amount
13     uint public godBank;
14     uint public jesterBank;
15     uint public kingBank;
16 
17     // Track the citizens who helped to arm race
18     address[] public citizensAddresses;
19     uint[] public citizensAmounts;
20     uint32 public totalCitizens;
21     uint32 public lastCitizenPaid;
22     // The mad king establishes the government
23     address public madKing;
24     // Record how many times the castle had fell
25     uint32 public round;
26     // Amount already paid back in this round
27     uint public amountAlreadyPaidBack;
28     // Amount invested in this round
29     uint public amountInvested;
30 
31     uint constant TWENTY_FOUR_HOURS = 60 * 60 * 24;
32     uint constant PEACE_PERIOD = 60 * 60 * 240;
33 
34     function GameOfThrones() {
35         // Define the first castle
36         trueGods = msg.sender;
37         madKing = msg.sender;
38         jester = msg.sender;
39         lastCollection = block.timestamp;
40         onThrone = block.timestamp;
41         kingCost = 1 ether;
42         amountAlreadyPaidBack = 0;
43         amountInvested = 0;
44         totalCitizens = 0;
45     }
46 
47     function repairTheCastle() returns(bool) {
48         uint amount = msg.value;
49         // Check if the minimum amount if reached
50         if (amount < 10 finney) {
51             msg.sender.send(msg.value);
52             return false;
53         }
54         // If the amount received is more than 100 ETH return the difference
55         if (amount > 100 ether) {
56             msg.sender.send(msg.value - 100 ether);
57             amount = 100 ether;
58         }
59 
60         // Check if the Castle has fell
61         if (lastCollection + TWENTY_FOUR_HOURS < block.timestamp) {
62             // Send the Piggy Bank to the last 3 citizens
63             // If there is no one who contributed this last 24 hours, no action needed
64             if (totalCitizens == 1) {
65                 // If there is only one Citizen who contributed, he gets the full Pigg Bank
66                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 95 / 100);
67             } else if (totalCitizens == 2) {
68                 // If only 2 citizens contributed
69                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 60 / 100);
70                 citizensAddresses[citizensAddresses.length - 2].send(piggyBank * 35 / 100);
71             } else if (totalCitizens >= 3) {
72                 // If there is 3 or more citizens who contributed
73                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 50 / 100);
74                 citizensAddresses[citizensAddresses.length - 2].send(piggyBank * 30 / 100);
75                 citizensAddresses[citizensAddresses.length - 3].send(piggyBank * 15 / 100);
76             }
77 
78             godBank += piggyBank * 5 / 100;
79             // Define the new Piggy Bank
80             piggyBank = 0;
81 
82             // Define the new Castle
83             jester = msg.sender;
84 
85             citizensAddresses.push(msg.sender);
86             citizensAmounts.push(amount * 110 / 100);
87             totalCitizens += 1;
88             investInTheSystem(amount);
89             godAutomaticCollectFee();
90             // All goes to the Piggy Bank
91             piggyBank += amount;
92 
93             round += 1;
94         } else {
95             citizensAddresses.push(msg.sender);
96             citizensAmounts.push(amount * 110 / 100);
97             totalCitizens += 1;
98             investInTheSystem(amount);
99 
100             // 5% goes to the Piggy Bank
101             piggyBank += (amount * 5 / 100);
102 
103             while (citizensAmounts[lastCitizenPaid] < (address(this).balance - piggyBank - godBank - kingBank - jesterBank) && lastCitizenPaid <= totalCitizens) {
104                 citizensAddresses[lastCitizenPaid].send(citizensAmounts[lastCitizenPaid]);
105                 amountAlreadyPaidBack += citizensAmounts[lastCitizenPaid];
106                 lastCitizenPaid += 1;
107             }
108         }
109     }
110 
111     // fallback function
112     function() {
113         repairTheCastle();
114     }
115 
116     function investInTheSystem(uint amount) internal {
117         // The Castle is still up
118         lastCollection = block.timestamp;
119         amountInvested += amount;
120         // The Jetster takes 5%
121         jesterBank += amount * 5 / 100;
122         // The mad king takes 5%
123         kingBank += amount * 5 / 100;
124         // 5% goes to the Piggy Bank
125         piggyBank += (amount * 5 / 100);
126 
127         kingAutomaticCollectFee();
128         jesterAutomaticCollectFee();
129     }
130 
131     // When the mad king decides to give his seat to someone else
132     // the king cost will be reset to 2 ether
133     function newKing(address newKing) {
134         if (msg.sender == madKing) {
135             madKing = newKing;
136             kingCost = 1 ether;
137         }
138     }
139 
140     function bribery() {
141         uint amount = 100 finney;
142         if (msg.value >= amount) {
143             // return jester
144             jester.send(jesterBank);
145             jesterBank = 0;
146 
147             jester = msg.sender;
148             msg.sender.send(msg.value - amount);
149             investInTheSystem(amount);
150         } else {
151             throw;
152         }
153     }
154 
155     // Anyone can usurpation the kingship
156     function usurpation() {
157         // Add more money for king usurpation cost
158         if (msg.sender == madKing) {
159             investInTheSystem(msg.value);
160             kingCost += msg.value;
161         } else {
162             if (onThrone + PEACE_PERIOD <= block.timestamp && msg.value >= kingCost * 110 / 100) {
163                 // return the fees to before king
164                 madKing.send(kingBank);
165                 // offer sacrifices to the Gods
166                 godBank += msg.value * 5 / 100;
167                 investInTheSystem(msg.value);
168                 // new king
169                 kingCost = msg.value;
170                 madKing = msg.sender;
171                 onThrone = block.timestamp;
172             } else {
173                 throw;
174             }
175         }
176     }
177 
178     // When the king decides to collect his fees
179     function collectFee() {
180         if (msg.sender == trueGods) {
181             trueGods.send(godBank);
182         }
183     }
184 
185     function godAutomaticCollectFee() internal {
186         if (godBank >= 1 ether) {
187           trueGods.send(godBank);
188           godBank = 0;
189         }
190     }
191 
192     function kingAutomaticCollectFee() internal {
193         if (kingBank >= 100 finney) {
194           madKing.send(kingBank);
195           kingBank = 0;
196         }
197     }
198 
199     function jesterAutomaticCollectFee() internal {
200         if (jesterBank >= 100 finney) {
201           jester.send(jesterBank);
202           jesterBank = 0;
203         }
204     }
205 }