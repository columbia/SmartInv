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
86     function closeCampaign() onlyJohan {
87         campaignOpen = false;
88     }
89 
90     function buy() isOpen public payable {
91       balanceOf[msg.sender] += msg.value;
92       totalSupply += msg.value;
93       Bought(msg.sender, msg.value);
94     }  
95 
96     function buyViaJohan() isOpen public payable {
97       balanceOf[msg.sender] += msg.value;
98       totalSupply += msg.value;  
99 
100       /* Create the dividend pathway */
101       dividendPathways[msg.sender].push(dividendPathway({
102                                       from: JohanNygren, 
103                                       amount:  msg.value,
104                                       timeStamp: now
105                                     }));
106 
107       BoughtViaJohan(msg.sender, msg.value);
108     }
109 
110     function sell(uint256 _value) public {
111       if(balanceOf[msg.sender] < _value) throw;
112       balanceOf[msg.sender] -= _value;
113     
114       if (!msg.sender.send(_value)) throw;
115 
116       totalSupply -= _value;
117       Sold(msg.sender, _value);
118 
119     }
120 
121     /* Send coins */
122     function transfer(address _to, uint256 _value) isOpen {
123         /* reject transaction to self to prevent dividend pathway loops*/
124         if(_to == msg.sender) throw;
125         
126         /* if the sender doenst have enough balance then stop */
127         if (balanceOf[msg.sender] < _value) throw;
128         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
129         
130         /* Calculate tax */
131         uint256 taxCollected = _value * taxRate / 1000;
132         uint256 sentAmount;
133 
134         /* Create the dividend pathway */
135         dividendPathways[_to].push(dividendPathway({
136                                         from: msg.sender, 
137                                         amount:  _value,
138                                         timeStamp: now
139                                       }));
140         
141         if(swarmRedistribution(_to, taxCollected) == true) {
142           sentAmount = _value;
143         }
144         else {
145           /* Return tax */
146           sentAmount = _value - taxCollected;
147         }
148         
149           /* Add and subtract new balances */
150 
151           balanceOf[msg.sender] -= sentAmount;
152           balanceOf[_to] += _value - taxCollected;
153         
154 
155         /* Notifiy anyone listening that this transfer took place */
156         Transfer(msg.sender, _to, sentAmount);
157     }
158 
159     function swarmRedistribution(address _to, uint256 _taxCollected) internal returns (bool) {
160            iterateThroughSwarm(_to, now);
161            if(swarmTree.length != 0) {
162            return doSwarm(_to, _taxCollected);
163            }
164            else return false;
165       }
166 
167     function iterateThroughSwarm(address _node, uint _timeStamp) internal {
168       if(dividendPathways[_node].length != 0) {
169         for(uint i = 0; i < dividendPathways[_node].length; i++) {
170           if(inSwarmTree[dividendPathways[_node][i].from] == false) { 
171             
172             uint timeStamp = dividendPathways[_node][i].timeStamp;
173             if(timeStamp <= _timeStamp) {
174                 
175               if(dividendPathways[_node][i].from == JohanNygren) JohanInSwarm = true;
176     
177                 Node memory node = Node({
178                             node: dividendPathways[_node][i].from, 
179                             parent: _node,
180                             index: i
181                           });
182                           
183                   swarmTree.push(node);
184                   inSwarmTree[node.node] = true;
185                   iterateThroughSwarm(node.node, timeStamp);
186               }
187           }
188         }
189       }
190     }
191 
192     function doSwarm(address _leaf, uint256 _taxCollected) internal returns (bool) {
193       
194       uint256 share;
195       if(JohanInSwarm) share = _taxCollected;
196       else share = 0;
197     
198       for(uint i = 0; i < swarmTree.length; i++) {
199         
200         address node = swarmTree[i].node;
201         address parent = swarmTree[i].parent;
202         uint index = swarmTree[i].index;
203         
204         bool isJohan;
205         if(node == JohanNygren) isJohan = true;
206 
207         if(isJohan) {
208           balanceOf[swarmTree[i].node] += share;
209         totalBasicIncome[node] += share;
210         }
211           
212         if(dividendPathways[parent][index].amount - _taxCollected > 0) {
213           dividendPathways[parent][index].amount -= _taxCollected; 
214         }
215         else removeDividendPathway(parent, index);
216         
217         inSwarmTree[node] = false;
218         
219         /* Notifiy anyone listening that this swarm took place */
220         if(isJohan) Swarm(_leaf, swarmTree[i].node, share);
221       }
222       delete swarmTree;
223       bool JohanWasInSwarm = JohanInSwarm;
224       delete JohanInSwarm;
225 
226       if(!JohanWasInSwarm) return false;
227       return true;
228     }
229     
230     function removeDividendPathway(address node, uint index) internal {
231                 delete dividendPathways[node][index];
232                 for (uint i = index; i < dividendPathways[node].length - 1; i++) {
233                         dividendPathways[node][i] = dividendPathways[node][i + 1];
234                 }
235                 dividendPathways[node].length--;
236         }
237 
238 }