1 pragma solidity ^ 0.4 .6;
2 
3 contract CloseIfBug {
4 
5         address public JohanNygren;
6         bool public bugDiscovered; // closes everything but sell()
7 
8         function CloseIfBug() {
9                 bugDiscovered = false;
10         }
11 
12         modifier onlyJohan {
13                 if (msg.sender != JohanNygren) throw;
14                 _;
15         }
16 
17         modifier isOpen {
18                 if (bugDiscovered != false) throw;
19                 _;
20         }
21 
22         function closeCampaign() onlyJohan {
23                 bugDiscovered = true;
24         }
25 
26 }
27 
28 
29 
30 contract RES is CloseIfBug {
31 
32         /* Public variables of the token */
33         string public name;
34         string public symbol;
35         uint8 public decimals;
36 
37         uint public totalSupply;
38 
39         /* This creates an array with all balances */
40         mapping(address => uint256) public balanceOf;
41 
42         /* This generates a public event on the blockchain that will notify clients */
43         event Transfer(address indexed from, address indexed to, uint256 value);
44 
45         /* Bought or sold */
46 
47         event Bought(address from, uint amount);
48         event Sold(address from, uint amount);
49 
50         /* Initializes contract with name, symbol and decimals */
51 
52         function RES() {
53                 name = "RES";
54                 symbol = "RES";
55                 decimals = 18;
56         }
57 
58         function buy() isOpen public payable {
59                 balanceOf[msg.sender] += msg.value;
60                 totalSupply += msg.value;
61                 Bought(msg.sender, msg.value);
62         }
63 
64         function sell(uint256 _value) public {
65                 if (balanceOf[msg.sender] < _value) throw;
66                 balanceOf[msg.sender] -= _value;
67 
68                 if (!msg.sender.send(_value)) throw;
69 
70                 totalSupply -= _value;
71                 Sold(msg.sender, _value);
72 
73         }
74 
75 }
76 
77 contract SwarmRedistribution is CloseIfBug, RES {
78 
79         struct dividendPathway {
80                 address from;
81                 uint amount;
82                 uint timeStamp;
83         }
84 
85         mapping(address => dividendPathway[]) public dividendPathways;
86 
87         mapping(address => bool) public isHuman;
88 
89         mapping(address => uint256) public totalBasicIncome;
90 
91         uint taxRate;
92         uint exchangeRate;
93 
94         address[] humans;
95         mapping(address => bool) inHumans;
96 
97         event Swarm(address indexed leaf, address indexed node, uint256 share);
98 
99         function SwarmRedistribution() {
100 
101                 /* Tax-rate in parts per thousand */
102                 taxRate = 20;
103 
104                 /* Exchange-rate in parts per thousand */
105                 exchangeRate = 0;
106 
107         }
108 
109         /* Send coins */
110         function transfer(address _to, uint256 _value) isOpen {
111                 /* reject transaction to self to prevent dividend pathway loops*/
112                 if (_to == msg.sender) throw;
113 
114                 /* if the sender doenst have enough balance then stop */
115                 if (balanceOf[msg.sender] < _value) throw;
116                 if (balanceOf[_to] + _value < balanceOf[_to]) throw;
117 
118                 /* Calculate tax */
119                 uint256 taxCollected = _value * taxRate / 1000;
120                 uint256 sentAmount;
121 
122                 /* Create the dividend pathway */
123                 dividendPathways[_to].push(dividendPathway({
124                         from: msg.sender,
125                         amount: _value,
126                         timeStamp: now
127                 }));
128 
129                 iterateThroughSwarm(_to, now, taxCollected);
130 
131                 if (humans.length > 0) {
132                         doSwarm(_to, taxCollected);
133                         sentAmount = _value;
134                 } else sentAmount = _value - taxCollected; /* Return tax */
135 
136 
137                 /* Add and subtract new balances */
138 
139                 balanceOf[msg.sender] -= sentAmount;
140                 balanceOf[_to] += _value - taxCollected;
141 
142                 /* Notifiy anyone listening that this transfer took place */
143                 Transfer(msg.sender, _to, sentAmount);
144         }
145 
146 
147         function iterateThroughSwarm(address _node, uint _timeStamp, uint _taxCollected) internal {
148                 for (uint i = 0; i < dividendPathways[_node].length; i++) {
149 
150                         uint timeStamp = dividendPathways[_node][i].timeStamp;
151                         if (timeStamp <= _timeStamp) {
152 
153                                 address node = dividendPathways[_node][i].from;
154 
155                                 if (
156                                         isHuman[node] == true &&
157                                         inHumans[node] == false
158                                 ) {
159                                         humans.push(node);
160                                         inHumans[node] = true;
161                                 }
162 
163                                 if (dividendPathways[_node][i].amount - _taxCollected > 0) {
164                                         dividendPathways[_node][i].amount -= _taxCollected;
165                                 } else removeDividendPathway(_node, i);
166 
167                                 iterateThroughSwarm(node, timeStamp, _taxCollected);
168                         }
169                 }
170         }
171 
172         function doSwarm(address _leaf, uint256 _taxCollected) internal {
173 
174                 uint256 share = _taxCollected / humans.length;
175 
176                 for (uint i = 0; i < humans.length; i++) {
177 
178                         balanceOf[humans[i]] += share;
179                         totalBasicIncome[humans[i]] += share;
180 
181                         inHumans[humans[i]] = false;
182 
183                         /* Notifiy anyone listening that this swarm took place */
184                         Swarm(_leaf, humans[i], share);
185                 }
186                 delete humans;
187         }
188 
189         function removeDividendPathway(address node, uint index) internal {
190                 delete dividendPathways[node][index];
191                 for (uint i = index; i < dividendPathways[node].length - 1; i++) {
192                         dividendPathways[node][i] = dividendPathways[node][i + 1];
193                 }
194                 dividendPathways[node].length--;
195         }
196 
197 }
198 
199 contract Resilience is CloseIfBug, RES, SwarmRedistribution {
200         
201         function Resilience() {
202         }
203         
204         function setBeneficiary() {
205             if(JohanNygren != 0) throw;
206             JohanNygren = msg.sender;
207             isHuman[JohanNygren] = true;
208         }
209 
210 
211 }