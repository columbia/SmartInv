1 pragma solidity ^0.4.6;
2 
3 contract RES { 
4 
5     /* Public variables of the token */
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     
10     uint public totalSupply;
11     
12     /* This creates an array with all balances */
13     mapping (address => uint256) public balanceOf;
14     
15     /* This generates a public event on the blockchain that will notify clients */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     
18 
19     /* Bought or sold */
20 
21     event Bought(address from, uint amount);
22     event Sold(address from, uint amount);
23     event BoughtViaJohan(address from, uint amount);
24 
25     /* Initializes contract with name, symbol and decimals */
26 
27     function RES() {
28         name = "RES";     
29         symbol = "RES";
30         decimals = 18;
31     }
32 
33 }
34 
35 contract SwarmRedistribution is RES {
36     
37     address public JohanNygren;
38     bool public campaignOpen;    
39 
40     struct dividendPathway {
41       address from;
42       uint amount;
43       uint timeStamp;
44     }
45 
46     mapping(address => dividendPathway[]) public dividendPathways;
47     
48     mapping(address => uint256) public totalBasicIncome;
49 
50     uint taxRate;
51 
52     struct Node {
53       address node;
54       address parent;
55       uint index;
56     }
57     
58     /* Generate a swarm tree */
59     Node[] swarmTree;
60     
61     mapping(address => bool) inSwarmTree;
62     
63     bool JohanInSwarm;
64 
65     event Swarm(address indexed leaf, address indexed node, uint256 share);
66 
67     function SwarmRedistribution() {
68       
69     /* Tax-rate in parts per thousand */
70     taxRate = 20;
71     JohanNygren = 0x948176CB42B65d835Ee4324914B104B66fB93B52;
72     campaignOpen = true;
73     
74     }
75     
76     modifier onlyJohan {
77       if(msg.sender != JohanNygren) throw;
78       _;
79     }
80 
81     modifier isOpen {
82       if(campaignOpen != true) throw;
83       _;
84     }
85     
86     function changeJohanNygrensAddress(address _newAddress) onlyJohan {
87       JohanNygren = _newAddress;
88     }
89     
90     function closeCampaign() onlyJohan {
91         campaignOpen = false;
92     }
93 
94     function buy() isOpen public payable {
95       balanceOf[msg.sender] += msg.value;
96       totalSupply += msg.value;
97       Bought(msg.sender, msg.value);
98     }  
99 
100     function buyViaJohan() isOpen public payable {
101       balanceOf[msg.sender] += msg.value;
102       totalSupply += msg.value;  
103 
104       /* Create the dividend pathway */
105       dividendPathways[msg.sender].push(dividendPathway({
106                                       from: JohanNygren, 
107                                       amount:  msg.value,
108                                       timeStamp: now
109                                     }));
110 
111       BoughtViaJohan(msg.sender, msg.value);
112     }
113 
114     function sell(uint256 _value) public {
115       if(balanceOf[msg.sender] < _value) throw;
116       balanceOf[msg.sender] -= _value;
117     
118       if (!msg.sender.send(_value)) throw;
119 
120       totalSupply -= _value;
121       Sold(msg.sender, _value);
122 
123     }
124 
125     /* Send coins */
126     function transfer(address _to, uint256 _value) isOpen {
127         /* reject transaction to self to prevent dividend pathway loops*/
128         if(_to == msg.sender) throw;
129         
130         /* if the sender doenst have enough balance then stop */
131         if (balanceOf[msg.sender] < _value) throw;
132         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
133         
134         /* Calculate tax */
135         uint256 taxCollected = _value * taxRate / 1000;
136         uint256 sentAmount;
137 
138         /* Create the dividend pathway */
139         dividendPathways[_to].push(dividendPathway({
140                                         from: msg.sender, 
141                                         amount:  _value,
142                                         timeStamp: now
143                                       }));
144         
145         if(swarmRedistribution(_to, taxCollected) == true) {
146           sentAmount = _value;
147         }
148         else {
149           /* Return tax */
150           sentAmount = _value - taxCollected;
151         }
152         
153           /* Add and subtract new balances */
154 
155           balanceOf[msg.sender] -= sentAmount;
156           balanceOf[_to] += _value - taxCollected;
157         
158 
159         /* Notifiy anyone listening that this transfer took place */
160         Transfer(msg.sender, _to, sentAmount);
161     }
162 
163     function swarmRedistribution(address _to, uint256 _taxCollected) internal returns (bool) {
164            iterateThroughSwarm(_to, now);
165            if(swarmTree.length != 0) {
166            return doSwarm(_to, _taxCollected);
167            }
168            else return false;
169       }
170 
171     function iterateThroughSwarm(address _node, uint _timeStamp) internal {
172       if(dividendPathways[_node].length != 0) {
173         for(uint i = 0; i < dividendPathways[_node].length; i++) {
174           if(inSwarmTree[dividendPathways[_node][i].from] == false) { 
175             
176             uint timeStamp = dividendPathways[_node][i].timeStamp;
177             if(timeStamp <= _timeStamp) {
178                 
179               if(dividendPathways[_node][i].from == JohanNygren) JohanInSwarm = true;
180     
181                 Node memory node = Node({
182                             node: dividendPathways[_node][i].from, 
183                             parent: _node,
184                             index: i
185                           });
186                           
187                   swarmTree.push(node);
188                   inSwarmTree[node.node] = true;
189                   iterateThroughSwarm(node.node, timeStamp);
190               }
191           }
192         }
193       }
194     }
195 
196     function doSwarm(address _leaf, uint256 _taxCollected) internal returns (bool) {
197       
198       uint256 share;
199       if(JohanInSwarm) share = _taxCollected;
200       else share = 0;
201     
202       for(uint i = 0; i < swarmTree.length; i++) {
203         
204         address node = swarmTree[i].node;
205         address parent = swarmTree[i].parent;
206         uint index = swarmTree[i].index;
207         
208         bool isJohan;
209         if(node == JohanNygren) isJohan = true;
210 
211         if(isJohan) {
212           balanceOf[swarmTree[i].node] += share;
213         totalBasicIncome[node] += share;
214         }
215           
216         if(dividendPathways[parent][index].amount - _taxCollected > 0) {
217           dividendPathways[parent][index].amount -= _taxCollected; 
218         }
219         else removeDividendPathway(parent, index);
220         
221         inSwarmTree[node] = false;
222         
223         /* Notifiy anyone listening that this swarm took place */
224         if(isJohan) Swarm(_leaf, swarmTree[i].node, share);
225       }
226       delete swarmTree;
227       bool JohanWasInSwarm = JohanInSwarm;
228       delete JohanInSwarm;
229 
230       if(!JohanWasInSwarm) return false;
231       return true;
232     }
233     
234     function removeDividendPathway(address node, uint index) internal {
235                 delete dividendPathways[node][index];
236                 for (uint i = index; i < dividendPathways[node].length - 1; i++) {
237                         dividendPathways[node][i] = dividendPathways[node][i + 1];
238                 }
239                 dividendPathways[node].length--;
240         }
241 
242 }