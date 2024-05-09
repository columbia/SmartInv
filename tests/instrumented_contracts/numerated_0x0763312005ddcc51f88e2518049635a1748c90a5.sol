1 pragma solidity ^0.4.6;
2 
3 contract Campaign {
4     
5     address public JohanNygren;
6     bool campaignOpen;
7     
8     function Campaign() {
9         JohanNygren = 0x948176CB42B65d835Ee4324914B104B66fB93B52;
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
29 contract RES is Campaign { 
30 
31     /* Public variables of the token */
32     string public name;
33     string public symbol;
34     uint8 public decimals;
35     
36     uint public totalSupply;
37     
38     /* This creates an array with all balances */
39     mapping (address => uint256) public balanceOf;
40     
41     /* This generates a public event on the blockchain that will notify clients */
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     
44 
45     /* Bought or sold */
46 
47     event Bought(address from, uint amount);
48     event Sold(address from, uint amount);
49     event BoughtViaJohan(address from, uint amount);
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
108     isHuman[JohanNygren] = true;
109     
110     }
111 
112     function buyViaJohan() isOpen public payable {
113       balanceOf[msg.sender] += msg.value;
114       totalSupply += msg.value;  
115 
116       /* Create the dividend pathway */
117       dividendPathways[msg.sender].push(dividendPathway({
118                                       from: JohanNygren, 
119                                       amount:  msg.value,
120                                       timeStamp: now
121                                     }));
122 
123       BoughtViaJohan(msg.sender, msg.value);
124     }
125 
126 
127     /* Send coins */
128     function transfer(address _to, uint256 _value) isOpen {
129         /* reject transaction to self to prevent dividend pathway loops*/
130         if(_to == msg.sender) throw;
131         
132         /* if the sender doenst have enough balance then stop */
133         if (balanceOf[msg.sender] < _value) throw;
134         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
135         
136         /* Calculate tax */
137         uint256 taxCollected = _value * taxRate / 1000;
138         uint256 sentAmount;
139 
140         /* Create the dividend pathway */
141         dividendPathways[_to].push(dividendPathway({
142                                         from: msg.sender, 
143                                         amount:  _value,
144                                         timeStamp: now
145                                       }));
146                                       
147         iterateThroughSwarm(_to, now, taxCollected);
148 
149         if(humans.length > 0) {
150             doSwarm(_to, taxCollected);
151             sentAmount = _value;
152         }
153         else sentAmount = _value - taxCollected; /* Return tax */
154         
155 
156         /* Add and subtract new balances */
157 
158         balanceOf[msg.sender] -= sentAmount;
159         balanceOf[_to] += _value - taxCollected;
160 
161         /* Notifiy anyone listening that this transfer took place */
162         Transfer(msg.sender, _to, sentAmount);
163     }
164     
165     
166     function iterateThroughSwarm(address _node, uint _timeStamp, uint _taxCollected) internal {
167         for(uint i = 0; i < dividendPathways[_node].length; i++) {
168             
169             uint timeStamp = dividendPathways[_node][i].timeStamp;
170             if(timeStamp <= _timeStamp) {
171                 
172                 address node = dividendPathways[_node][i].from;
173                 
174               if(
175                   isHuman[node] == true 
176                   && 
177                   inHumans[node] == false
178                 ) 
179                 {
180                     humans.push(node);
181                     inHumans[node] = true;
182                 }
183 
184               if(dividendPathways[_node][i].amount - _taxCollected > 0) {
185                 dividendPathways[_node][i].amount -= _taxCollected; 
186               }
187               else removeDividendPathway(_node, i);
188                                 
189               iterateThroughSwarm(node, timeStamp, _taxCollected);
190             }
191         }
192     }
193 
194     function doSwarm(address _leaf, uint256 _taxCollected) internal {
195       
196       uint256 share = _taxCollected / humans.length;
197     
198       for(uint i = 0; i < humans.length; i++) {
199 
200         balanceOf[humans[i]] += share;
201         totalBasicIncome[humans[i]] += share;
202         
203         inHumans[humans[i]] = false;
204         
205         /* Notifiy anyone listening that this swarm took place */
206         Swarm(_leaf, humans[i], share);
207       }
208       delete humans;
209     }
210     
211     function removeDividendPathway(address node, uint index) internal {
212                 delete dividendPathways[node][index];
213                 for (uint i = index; i < dividendPathways[node].length - 1; i++) {
214                         dividendPathways[node][i] = dividendPathways[node][i + 1];
215                 }
216                 dividendPathways[node].length--;
217         }
218 
219 }