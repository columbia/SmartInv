1 pragma solidity ^0.4.6;
2 
3 contract Campaign {
4     
5     address public JohanNygren;
6     bool campaignOpen;
7     
8     function Campaign() {
9         JohanNygren = msg.sender;
10         campaignOpen = true;
11     }
12     
13     modifier onlyJohan {
14       if(msg.sender != JohanNygren) throw;
15       _;
16     }
17 
18     modifier isOpen {
19       if(campaignOpen != true) throw;
20       _;
21     }
22     
23     function closeCampaign() onlyJohan {
24         campaignOpen = false;
25     }
26     
27 }
28 
29 
30 
31 contract RES is Campaign { 
32 
33     /* Public variables of the token */
34     string public name;
35     string public symbol;
36     uint8 public decimals;
37     
38     uint public totalSupply;
39     
40     /* This creates an array with all balances */
41     mapping (address => uint256) public balanceOf;
42     
43     /* This generates a public event on the blockchain that will notify clients */
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     
46     /* Bought or sold */
47 
48     event Bought(address from, uint amount);
49     event Sold(address from, uint amount);
50 
51     /* Initializes contract with name, symbol and decimals */
52 
53     function RES() {
54         name = "RES";     
55         symbol = "RES";
56         decimals = 18;
57     }
58     
59     function buy() isOpen public payable {
60       balanceOf[msg.sender] += msg.value;
61       totalSupply += msg.value;
62       Bought(msg.sender, msg.value);
63     }  
64 
65     function sell(uint256 _value) public {
66       if(balanceOf[msg.sender] < _value) throw;
67       balanceOf[msg.sender] -= _value;
68     
69       if (!msg.sender.send(_value)) throw;
70 
71       totalSupply -= _value;
72       Sold(msg.sender, _value);
73 
74     }
75 
76 }
77 
78 contract SwarmRedistribution is Campaign, RES {
79     
80     struct dividendPathway {
81       address from;
82       uint amount;
83       uint timeStamp;
84     }
85 
86     mapping(address => dividendPathway[]) public dividendPathways;
87     
88     mapping(address => bool) public isHuman;
89     
90     mapping(address => uint256) public totalBasicIncome;
91 
92     uint taxRate;
93     uint exchangeRate;
94     
95     address[] humans;
96     mapping(address => bool) inHumans;
97     
98     event Swarm(address indexed leaf, address indexed node, uint256 share);
99 
100     function SwarmRedistribution() {
101       
102     /* Tax-rate in parts per thousand */
103     taxRate = 20;
104     
105     /* Exchange-rate in parts per thousand */
106     exchangeRate = 0;
107     
108     }
109 
110     /* Send coins */
111     function transfer(address _to, uint256 _value) isOpen {
112         /* reject transaction to self to prevent dividend pathway loops*/
113         if(_to == msg.sender) throw;
114         
115         /* if the sender doenst have enough balance then stop */
116         if (balanceOf[msg.sender] < _value) throw;
117         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
118         
119         /* Calculate tax */
120         uint256 taxCollected = _value * taxRate / 1000;
121         uint256 sentAmount;
122 
123         /* Create the dividend pathway */
124         dividendPathways[_to].push(dividendPathway({
125                                         from: msg.sender, 
126                                         amount:  _value,
127                                         timeStamp: now
128                                       }));
129                                       
130         iterateThroughSwarm(_to, now, taxCollected);
131 
132         if(humans.length > 0) {
133             doSwarm(_to, taxCollected);
134             sentAmount = _value;
135         }
136         else sentAmount = _value - taxCollected; /* Return tax */
137         
138 
139         /* Add and subtract new balances */
140 
141         balanceOf[msg.sender] -= sentAmount;
142         balanceOf[_to] += _value - taxCollected;
143 
144         /* Notifiy anyone listening that this transfer took place */
145         Transfer(msg.sender, _to, sentAmount);
146     }
147     
148     
149     function iterateThroughSwarm(address _node, uint _timeStamp, uint _taxCollected) internal {
150         for(uint i = 0; i < dividendPathways[_node].length; i++) {
151             
152             uint timeStamp = dividendPathways[_node][i].timeStamp;
153             if(timeStamp <= _timeStamp) {
154                 
155                 address node = dividendPathways[_node][i].from;
156                 
157               if(
158                   isHuman[node] == true 
159                   && 
160                   inHumans[node] == false
161                 ) 
162                 {
163                     humans.push(node);
164                     inHumans[node] = true;
165                 }
166 
167               if(dividendPathways[_node][i].amount - _taxCollected > 0) {
168                 dividendPathways[_node][i].amount -= _taxCollected; 
169               }
170               else removeDividendPathway(_node, i);
171                                 
172               iterateThroughSwarm(node, timeStamp, _taxCollected);
173             }
174         }
175     }
176 
177     function doSwarm(address _leaf, uint256 _taxCollected) internal {
178       
179       uint256 share = _taxCollected / humans.length;
180     
181       for(uint i = 0; i < humans.length; i++) {
182 
183         balanceOf[humans[i]] += share;
184         totalBasicIncome[humans[i]] += share;
185         
186         inHumans[humans[i]] = false;
187         
188         /* Notifiy anyone listening that this swarm took place */
189         Swarm(_leaf, humans[i], share);
190       }
191       delete humans;
192     }
193     
194     function removeDividendPathway(address node, uint index) internal {
195                 delete dividendPathways[node][index];
196                 for (uint i = index; i < dividendPathways[node].length - 1; i++) {
197                         dividendPathways[node][i] = dividendPathways[node][i + 1];
198                 }
199                 dividendPathways[node].length--;
200         }
201 
202 }
203 
204 contract CampaignBeneficiary is Campaign, RES, SwarmRedistribution {
205 
206     event BuyWithPathwayFromBeneficiary(address from, uint amount);
207 
208     function CampaignBeneficiary() {
209       isHuman[JohanNygren] = true;
210     }
211 
212     function simulatePathwayFromBeneficiary() isOpen public payable {
213       balanceOf[msg.sender] += msg.value;
214       totalSupply += msg.value;  
215 
216       /* Create the dividend pathway */
217       dividendPathways[msg.sender].push(dividendPathway({
218                                       from: JohanNygren, 
219                                       amount:  msg.value,
220                                       timeStamp: now
221                                     }));
222 
223       BuyWithPathwayFromBeneficiary(msg.sender, msg.value);
224     }
225 
226 }