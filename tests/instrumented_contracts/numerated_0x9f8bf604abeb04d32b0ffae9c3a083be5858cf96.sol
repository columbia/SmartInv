1 contract GameOfThrones {
2     address public trueGods;
3     // King's Jester
4     address public jester;
5     // Record the last collection time
6     uint public lastCollection;
7     // Record the last fell time
8     uint public lastFell;
9     // Record king life
10     uint public onThrone;
11     uint public kingCost;
12     // Piggy Bank Amount
13     uint public piggyBank;
14     // Collected Fee Amount
15     uint public godBank;
16     uint public jesterBank;
17     uint public kingBank;
18 
19     // Track the citizens who helped to arm race
20     address[] public citizensAddresses;
21     uint[] public citizensAmounts;
22     uint32 public totalCitizens;
23     uint32 public lastCitizenPaid;
24     // The mad king establishes the government
25     address public madKing;
26     // Record how many times the castle had fell
27     uint32 public round;
28     // Amount already paid back in this round
29     uint public amountAlreadyPaidBack;
30     // Amount invested in this round
31     uint public amountInvested;
32 
33     uint constant TWENTY_FOUR_HOURS = 60 * 60 * 24;
34     uint constant PEACE_PERIOD = 60 * 60 * 240;
35 
36     function GameOfThrones() {
37         // Define the first castle
38         trueGods = msg.sender;
39         madKing = msg.sender;
40         jester = msg.sender;
41         lastFell = block.timestamp;
42         lastCollection = block.timestamp;
43         onThrone = block.timestamp;
44         kingCost = 1 ether;
45         amountAlreadyPaidBack = 0;
46         amountInvested = 0;
47         totalCitizens = 0;
48     }
49 
50     function protectKingdom() returns(bool) {
51         uint amount = msg.value;
52         // Check if the minimum amount if reached
53         if (amount < 10 finney) {
54             msg.sender.send(msg.value);
55             return false;
56         }
57         // If the amount received is more than 100 ETH return the difference
58         if (amount > 100 ether) {
59             msg.sender.send(msg.value - 100 ether);
60             amount = 100 ether;
61         }
62 
63         // Check if the Castle has fell
64         if (lastCollection + TWENTY_FOUR_HOURS < block.timestamp) {
65             // Send the Piggy Bank to the last 3 citizens
66             // If there is no one who contributed this last 24 hours, no action needed
67             if (totalCitizens == 1) {
68                 // If there is only one Citizen who contributed, he gets the full Pigg Bank
69                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 95 / 100);
70             } else if (totalCitizens == 2) {
71                 // If only 2 citizens contributed
72                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 60 / 100);
73                 citizensAddresses[citizensAddresses.length - 2].send(piggyBank * 35 / 100);
74             } else if (totalCitizens >= 3) {
75                 // If there is 3 or more citizens who contributed
76                 citizensAddresses[citizensAddresses.length - 1].send(piggyBank * 50 / 100);
77                 citizensAddresses[citizensAddresses.length - 2].send(piggyBank * 30 / 100);
78                 citizensAddresses[citizensAddresses.length - 3].send(piggyBank * 15 / 100);
79             }
80 
81             godBank += piggyBank * 5 / 100;
82             // Define the new Piggy Bank
83             piggyBank = 0;
84 
85             // Define the new Castle
86             jester = msg.sender;
87 
88             lastFell = block.timestamp;
89             citizensAddresses.push(msg.sender);
90             citizensAmounts.push(amount * 110 / 100);
91             totalCitizens += 1;
92             investInTheSystem(amount);
93             godAutomaticCollectFee();
94             // 95% goes to the Piggy Bank
95             piggyBank += amount * 90 / 100;
96 
97             round += 1;
98         } else {
99             if (lastFell + TWENTY_FOUR_HOURS * 2 >= block.timestamp) {
100                 citizensAddresses.push(msg.sender);
101                 citizensAmounts.push(amount * 130 / 100);
102             } else {
103                 citizensAddresses.push(msg.sender);
104                 citizensAmounts.push(amount * 110 / 100);
105             }
106             totalCitizens += 1;
107             investInTheSystem(amount);
108 
109             while (citizensAmounts[lastCitizenPaid] < (address(this).balance - piggyBank - godBank - kingBank - jesterBank) && lastCitizenPaid <= totalCitizens) {
110                 citizensAddresses[lastCitizenPaid].send(citizensAmounts[lastCitizenPaid]);
111                 amountAlreadyPaidBack += citizensAmounts[lastCitizenPaid];
112                 lastCitizenPaid += 1;
113             }
114         }
115     }
116 
117     // fallback function
118     function() internal {
119         protectKingdom();
120     }
121 
122     function investInTheSystem(uint amount) internal {
123         // The Castle is still up
124         lastCollection = block.timestamp;
125         amountInvested += amount;
126         // The Jetster takes 5%
127         jesterBank += amount * 5 / 100;
128         // The mad king takes 5%
129         kingBank += amount * 5 / 100;
130         // 5% goes to the Piggy Bank
131         piggyBank += (amount * 5 / 100);
132 
133         kingAutomaticCollectFee();
134         jesterAutomaticCollectFee();
135     }
136 
137     // When the mad king decides to give his seat to someone else
138     // the king cost will be reset to 1 ether
139     function abdicate() {
140         if (msg.sender == madKing && msg.sender != trueGods) {
141             madKing.send(kingBank);
142             if (piggyBank > kingCost * 40 / 100) {
143                 madKing.send(kingCost * 40 / 100);
144                 piggyBank -= kingCost * 40 / 100;
145             }
146             else {
147                 madKing.send(piggyBank);
148                 piggyBank = 0;
149             }
150 
151             madKing = trueGods;
152             kingCost = 1 ether;
153         }
154     }
155 
156     function murder() {
157         uint amount = 100 finney;
158         if (msg.value >= amount && msg.sender != jester) {
159             // return jester
160             jester.send(jesterBank);
161             jesterBank = 0;
162 
163             jester = msg.sender;
164             msg.sender.send(msg.value - amount);
165             investInTheSystem(amount);
166         } else {
167             throw;
168         }
169     }
170 
171     // Anyone can usurpation the kingship
172     function usurpation() {
173         uint amount = msg.value;
174         // Add more money for king usurpation cost
175         if (msg.sender == madKing) {
176             investInTheSystem(amount);
177             kingCost += amount;
178         } else {
179             if (onThrone + PEACE_PERIOD <= block.timestamp && amount >= kingCost * 150 / 100) {
180                 // return the fees to before king
181                 madKing.send(kingBank);
182                 // offer sacrifices to the Gods
183                 godBank += amount * 5 / 100;
184                 // new king
185                 kingCost = amount;
186                 madKing = msg.sender;
187                 onThrone = block.timestamp;
188                 investInTheSystem(amount);
189             } else {
190                 throw;
191             }
192         }
193     }
194 
195     // When the king decides to collect his fees
196     function collectFee() {
197         if (msg.sender == trueGods) {
198             trueGods.send(godBank);
199         }
200     }
201 
202     function godAutomaticCollectFee() internal {
203         if (godBank >= 1 ether) {
204           trueGods.send(godBank);
205           godBank = 0;
206         }
207     }
208 
209     function kingAutomaticCollectFee() internal {
210         if (kingBank >= 100 finney) {
211           madKing.send(kingBank);
212           kingBank = 0;
213         }
214     }
215 
216     function jesterAutomaticCollectFee() internal {
217         if (jesterBank >= 100 finney) {
218           jester.send(jesterBank);
219           jesterBank = 0;
220         }
221     }
222 }