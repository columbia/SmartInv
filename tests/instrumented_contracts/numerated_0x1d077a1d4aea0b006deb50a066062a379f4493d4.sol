1 // * Alluma (LUMA) Selfdrop
2 // * Send 0 ETH to contract address 0x1D077A1d4aEA0B006Deb50A066062a379f4493D4
3 // * (sending any extra amount of ETH will be considered as donations)
4 // * Use 120 000 Gas if sending
5 
6 
7 // * Token Structure
8 
9 // * Token Name: Alluma
10 // * Token Symbol: LUMA
11 // * Token Decimal: 8
12 // * Token Supply: 500,000,000
13 // * Smart Contract: 0x1D077A1d4aEA0B006Deb50A066062a379f4493D4
14 
15 // * Website: https://token.alluma.io
16 // * Whitepaper: https://go.alluma.io/whitepaper-download
17 
18 
19 // * The LUMA Token
20 
21 // * Alluma's vision is to provide access and education to the next billion people on the blockchain.
22 // * The Alluma exchange provides the opportunity for users to access highly liquid cryptocurrency markets and engage with the Alluma Training Academy to learn the ins and outs of the crypto world.
23 // * To support our vision and fuel our ecosystem we’re introducing Alluma utility token: The LUMA Token.
24 
25 // * LUMA will power numerous aspects of the Alluma ecosystem.
26 // * The LUMA token is an ERC-20 compliant token to be issued on the Ethereum blockchain, and its use cases include:
27 
28 // * Settling Trading Fees
29 // * All users will have the ability to settle trading fees on Alluma’s Exchange
30 
31 // * Alluma Loyalty Program
32 // * A first of its kind membership-based tiered loyalty program
33 
34 // * Community Voting
35 // * Participation in Alluma’s product developments including token listing initiatives
36 
37 // * Alluma Training Academy
38 // * A digital education platform to learn about cryptocurrency and blockchain technology
39 
40 // * Token Sale Platform
41 // * A platform for the next generation of technology companies in emerging markets
42 
43 // * Decentralized Chat
44 // * P2P chat allowing users to connect and communicate throughout the Alluma ecosystem
45 
46 
47 // * Follow us on social
48 
49 // * Telegram: https://t.me/allumaexchange
50 // * Medium: https://medium.com/alluma
51 // * Facebook: https://www.facebook.com/alluma
52 // * Twitter: https://twitter.com/allumaexchange
53 // * Reddit: https://www.reddit.com/r/alluma
54 // * Linkedin: https://www.linkedin.com/company/alluma-exchange/
55 // * Google+: https://plus.google.com/u/0/b/105558719635795800693/105558719635795800693
56 
57 
58 pragma solidity ^0.4.22;
59 
60 library SafeMath {
61   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a * b;
63     assert(a == 0 || c / a == b);
64     return c;
65   }
66 
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a / b;
69     return c;
70   }
71 
72   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   function add(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 contract ForeignToken {
85     function balanceOf(address _owner) constant public returns (uint256);
86     function transfer(address _to, uint256 _value) public returns (bool);
87 }
88 
89 contract ERC20Basic {
90     uint256 public totalSupply;
91     function balanceOf(address who) public constant returns (uint256);
92     function transfer(address to, uint256 value) public returns (bool);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 contract ERC20 is ERC20Basic {
97     function allowance(address owner, address spender) public constant returns (uint256);
98     function transferFrom(address from, address to, uint256 value) public returns (bool);
99     function approve(address spender, uint256 value) public returns (bool);
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 interface Token { 
104     function distr(address _to, uint256 _value) external returns (bool);
105     function totalSupply() constant external returns (uint256 supply);
106     function balanceOf(address _owner) constant external returns (uint256 balance);
107 }
108 
109 contract Alluma is ERC20 {
110 
111     
112     using SafeMath for uint256;
113     address owner = msg.sender;
114 
115     mapping (address => uint256) balances;
116     mapping (address => mapping (address => uint256)) allowed;
117     mapping (address => bool) public blacklist;
118 
119     string public constant name = "Alluma";
120     string public constant symbol = "LUMA";
121     uint public constant decimals = 8;
122     
123 uint256 public totalSupply = 500000000e8;
124     
125 uint256 public totalDistributed = 450000000e8;
126     
127 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
128     
129 uint256 public value = 150e8;
130 
131 
132 
133     event Transfer(address indexed _from, address indexed _to, uint256 _value);
134     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
135     
136     event Distr(address indexed to, uint256 amount);
137     event DistrFinished();
138     
139     event Burn(address indexed burner, uint256 value);
140 
141     bool public distributionFinished = false;
142     
143     modifier canDistr() {
144         require(!distributionFinished);
145         _;
146     }
147     
148     modifier onlyOwner() {
149         require(msg.sender == owner);
150         _;
151     }
152     
153     modifier onlyWhitelist() {
154         require(blacklist[msg.sender] == false);
155         _;
156     }
157     
158     function Alluma() public {
159         owner = msg.sender;
160         balances[owner] = totalDistributed;
161     }
162     
163     function transferOwnership(address newOwner) onlyOwner public {
164         if (newOwner != address(0)) {
165             owner = newOwner;
166         }
167     }
168     
169     function finishDistribution() onlyOwner canDistr public returns (bool) {
170         distributionFinished = true;
171         emit DistrFinished();
172         return true;
173     }
174     
175     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
176         totalDistributed = totalDistributed.add(_amount);
177         totalRemaining = totalRemaining.sub(_amount);
178         balances[_to] = balances[_to].add(_amount);
179         emit Distr(_to, _amount);
180         emit Transfer(address(0), _to, _amount);
181         return true;
182         
183         if (totalDistributed >= totalSupply) {
184             distributionFinished = true;
185         }
186     }
187     
188     function () external payable {
189         getTokens();
190      }
191     
192     function getTokens() payable canDistr onlyWhitelist public {
193         if (value > totalRemaining) {
194             value = totalRemaining;
195         }
196         
197         require(value <= totalRemaining);
198         
199         address investor = msg.sender;
200         uint256 toGive = value;
201         
202         distr(investor, toGive);
203         
204         if (toGive > 0) {
205             blacklist[investor] = true;
206         }
207 
208         if (totalDistributed >= totalSupply) {
209             distributionFinished = true;
210         }
211         
212         value = value.div(100000).mul(99999);
213     }
214 
215     function balanceOf(address _owner) constant public returns (uint256) {
216         return balances[_owner];
217     }
218 
219     modifier onlyPayloadSize(uint size) {
220         assert(msg.data.length >= size + 4);
221         _;
222     }
223     
224     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
225         require(_to != address(0));
226         require(_amount <= balances[msg.sender]);
227         
228         balances[msg.sender] = balances[msg.sender].sub(_amount);
229         balances[_to] = balances[_to].add(_amount);
230         emit Transfer(msg.sender, _to, _amount);
231         return true;
232     }
233     
234     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
235         require(_to != address(0));
236         require(_amount <= balances[_from]);
237         require(_amount <= allowed[_from][msg.sender]);
238         
239         balances[_from] = balances[_from].sub(_amount);
240         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
241         balances[_to] = balances[_to].add(_amount);
242         emit Transfer(_from, _to, _amount);
243         return true;
244     }
245     
246     function approve(address _spender, uint256 _value) public returns (bool success) {
247         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
248         allowed[msg.sender][_spender] = _value;
249         emit Approval(msg.sender, _spender, _value);
250         return true;
251     }
252     
253     function allowance(address _owner, address _spender) constant public returns (uint256) {
254         return allowed[_owner][_spender];
255     }
256     
257     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
258         ForeignToken t = ForeignToken(tokenAddress);
259         uint bal = t.balanceOf(who);
260         return bal;
261     }
262     
263     function withdraw() onlyOwner public {
264         uint256 etherBalance = address(this).balance;
265         owner.transfer(etherBalance);
266     }
267     
268     function burn(uint256 _value) onlyOwner public {
269         require(_value <= balances[msg.sender]);
270 
271         address burner = msg.sender;
272         balances[burner] = balances[burner].sub(_value);
273         totalSupply = totalSupply.sub(_value);
274         totalDistributed = totalDistributed.sub(_value);
275         emit Burn(burner, _value);
276     }
277     
278     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
279         ForeignToken token = ForeignToken(_tokenContract);
280         uint256 amount = token.balanceOf(address(this));
281         return token.transfer(owner, amount);
282     }
283 }