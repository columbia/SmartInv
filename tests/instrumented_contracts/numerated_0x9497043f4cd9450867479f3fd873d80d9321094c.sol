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
47     function protectKingdom() returns(bool) {
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
90             // 95% goes to the Piggy Bank
91             piggyBank += amount * 90 / 100;
92 
93             round += 1;
94         } else {
95             citizensAddresses.push(msg.sender);
96             citizensAmounts.push(amount * 110 / 100);
97             totalCitizens += 1;
98             investInTheSystem(amount);
99 
100             while (citizensAmounts[lastCitizenPaid] < (address(this).balance - piggyBank - godBank - kingBank - jesterBank) && lastCitizenPaid <= totalCitizens) {
101                 citizensAddresses[lastCitizenPaid].send(citizensAmounts[lastCitizenPaid]);
102                 amountAlreadyPaidBack += citizensAmounts[lastCitizenPaid];
103                 lastCitizenPaid += 1;
104             }
105         }
106     }
107 
108     // fallback function
109     function() internal {
110         protectKingdom();
111     }
112 
113     function investInTheSystem(uint amount) internal {
114         // The Castle is still up
115         lastCollection = block.timestamp;
116         amountInvested += amount;
117         // The Jetster takes 5%
118         jesterBank += amount * 5 / 100;
119         // The mad king takes 5%
120         kingBank += amount * 5 / 100;
121         // 5% goes to the Piggy Bank
122         piggyBank += (amount * 5 / 100);
123 
124         kingAutomaticCollectFee();
125         jesterAutomaticCollectFee();
126     }
127 
128     // When the mad king decides to give his seat to someone else
129     // the king cost will be reset to 1 ether
130     function abdicate() {
131         if (msg.sender == madKing && msg.sender != trueGods) {
132             madKing.send(kingBank);
133             if (piggyBank > kingCost * 40 / 100) {
134                 madKing.send(kingCost * 40 / 100);
135                 piggyBank -= kingCost * 40 / 100;
136             }
137             else {
138                 madKing.send(piggyBank);
139                 piggyBank = 0;
140             }
141 
142             madKing = trueGods;
143             kingCost = 1 ether;
144         }
145     }
146 
147     function murder() {
148         uint amount = 100 finney;
149         if (msg.value >= amount && msg.sender != jester) {
150             // return jester
151             jester.send(jesterBank);
152             jesterBank = 0;
153 
154             jester = msg.sender;
155             msg.sender.send(msg.value - amount);
156             investInTheSystem(amount);
157         } else {
158             throw;
159         }
160     }
161 
162     // Anyone can usurpation the kingship
163     function usurpation() {
164         uint amount = msg.value;
165         // Add more money for king usurpation cost
166         if (msg.sender == madKing) {
167             investInTheSystem(amount);
168             kingCost += amount;
169         } else {
170             if (onThrone + PEACE_PERIOD <= block.timestamp && amount >= kingCost * 150 / 100) {
171                 // return the fees to before king
172                 madKing.send(kingBank);
173                 // offer sacrifices to the Gods
174                 godBank += amount * 5 / 100;
175                 // new king
176                 kingCost = amount;
177                 madKing = msg.sender;
178                 onThrone = block.timestamp;
179                 investInTheSystem(amount);
180             } else {
181                 throw;
182             }
183         }
184     }
185 
186     // When the king decides to collect his fees
187     function collectFee() {
188         if (msg.sender == trueGods) {
189             trueGods.send(godBank);
190         }
191     }
192 
193     function godAutomaticCollectFee() internal {
194         if (godBank >= 1 ether) {
195           trueGods.send(godBank);
196           godBank = 0;
197         }
198     }
199 
200     function kingAutomaticCollectFee() internal {
201         if (kingBank >= 100 finney) {
202           madKing.send(kingBank);
203           kingBank = 0;
204         }
205     }
206 
207     function jesterAutomaticCollectFee() internal {
208         if (jesterBank >= 100 finney) {
209           jester.send(jesterBank);
210           jesterBank = 0;
211         }
212     }
213 }