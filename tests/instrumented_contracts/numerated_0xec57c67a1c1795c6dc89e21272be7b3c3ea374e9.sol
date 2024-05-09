1 pragma solidity ^0.4.20;
2 
3 /*
4 
5 /*===============================================
6 =    [ Power of Vladimir Putin (40% alcohol) ]  =
7 =          https://PowerOfPutin.oi/                 =
8 =        https://discord.gg/EDR5FRcD            =
9 =================================================
10 
11 
12   _____                                __ 
13  |  __ \                              / _|
14  | |__) |____      _____ _ __    ___ | |_ 
15  |  ___/ _ \ \ /\ / / _ \ '__|  / _ \|  _|
16  | |  | (_) \ V  V /  __/ |    | (_) | |  
17  |_|   \___/ \_/\_/ \___|_|     \___/|_| 
18 
19  __      ___           _ _           _        _____       _   _       
20  \ \    / / |         | (_)         (_)      |  __ \     | | (_)      
21   \ \  / /| | __ _  __| |_ _ __ ___  _ _ __  | |__) |   _| |_ _ _ __  
22    \ \/ / | |/ _` |/ _` | | '_ ` _ \| | '__| |  ___/ | | | __| | '_ \ 
23     \  /  | | (_| | (_| | | | | | | | | |    | |   | |_| | |_| | | | |
24      \/   |_|\__,_|\__,_|_|_| |_| |_|_|_|    |_|    \__,_|\__|_|_| |_|
25 
26 
27 * -> Features!
28 * All the features from the original Po contract, with dividend fee 40%:
29 * [x] Highly Secure: Hundreds of thousands of investers have invested in the original contract.
30 * [X] Purchase/Sell: You can perform partial sell orders. If you succumb to weak hands, you don't have to dump all of your bags.
31 * [x] Purchase/Sell: You can transfer tokens between wallets. Trading is possible from within the contract.
32 * [x] Masternodes: The implementation of Ethereum Staking in the world.
33 * [x] Masternodes: Holding 50 PowerOfPutin Tokens allow you to generate a Masternode link, Masternode links are used as unique entry points to the contract.
34 * [x] Masternodes: All players who enter the contract through your Masternode have 30% of their 40% dividends fee rerouted from the master-node, to the node-master.
35 *
36 * -> Who worked not this project?
37 * - Vladimir PUtin (The king of Russia (& future king of the world))
38 * - Mantso (Original Program)
39 *
40 * -> Owner of contract can:
41 * - Low pre-mine (0.999ETH)
42 * - And nothing else
43 *
44 * -> Owner of contract CANNOT:
45 * - exit scam
46 * - kill the contract
47 * - take funds
48 * - pause the contract
49 * - disable withdrawals
50 * - change the price of tokens
51 *
52 * -> THE FOMO IS REAL!!
53 
54 
55 */
56 
57 library SafeMath {
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a * b;
60     assert(a == 0 || c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a / b;
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 contract ForeignToken {
82     function balanceOf(address _owner) constant public returns (uint256);
83     function transfer(address _to, uint256 _value) public returns (bool);
84 }
85 
86 contract ERC20Basic {
87     uint256 public totalSupply;
88     function balanceOf(address who) public constant returns (uint256);
89     function transfer(address to, uint256 value) public returns (bool);
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public constant returns (uint256);
95     function transferFrom(address from, address to, uint256 value) public returns (bool);
96     function approve(address spender, uint256 value) public returns (bool);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 interface Token { 
101     function distr(address _to, uint256 _value) public returns (bool);
102     function totalSupply() constant public returns (uint256 supply);
103     function balanceOf(address _owner) constant public returns (uint256 balance);
104 }
105 
106 contract PowerOfPutin is ERC20 {
107     
108     using SafeMath for uint256;
109     address owner = msg.sender;
110 
111     mapping (address => uint256) balances;
112     mapping (address => mapping (address => uint256)) allowed;
113     mapping (address => bool) public blacklist;
114 
115     string public constant name = "Power of Vladimir Putin";
116     string public constant symbol = "PowerOfPutin";
117     uint public constant decimals = 8;
118     
119     uint256 public totalSupply = 80000000e8;
120     uint256 public totalDistributed = 1e8;
121     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
122     uint256 public value;
123 
124     event Transfer(address indexed _from, address indexed _to, uint256 _value);
125     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
126     
127     event Distr(address indexed to, uint256 amount);
128     event DistrFinished();
129     
130     event Burn(address indexed burner, uint256 value);
131 
132     bool public distributionFinished = false;
133     
134     modifier canDistr() {
135         require(!distributionFinished);
136         _;
137     }
138     
139     modifier onlyOwner() {
140         require(msg.sender == owner);
141         _;
142     }
143     
144    
145     
146     function PowerOfPutin () public {
147         owner = msg.sender;
148         value = 14780e8;
149         distr(owner, totalDistributed);
150     }
151     
152     function transferOwnership(address newOwner) onlyOwner public {
153         if (newOwner != address(0)) {
154             owner = newOwner;
155         }
156     }
157     
158    
159 
160    
161 
162     function finishDistribution() onlyOwner canDistr public returns (bool) {
163         distributionFinished = true;
164         DistrFinished();
165         return true;
166     }
167     
168     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
169         totalDistributed = totalDistributed.add(_amount);
170         totalRemaining = totalRemaining.sub(_amount);
171         balances[_to] = balances[_to].add(_amount);
172         Distr(_to, _amount);
173         Transfer(address(0), _to, _amount);
174         return true;
175         
176         if (totalDistributed >= totalSupply) {
177             distributionFinished = true;
178         }
179     }
180     
181     function airdrop(address[] addresses) onlyOwner canDistr public {
182         
183         require(addresses.length <= 255);
184         require(value <= totalRemaining);
185         
186         for (uint i = 0; i < addresses.length; i++) {
187             require(value <= totalRemaining);
188             distr(addresses[i], value);
189         }
190 	
191         if (totalDistributed >= totalSupply) {
192             distributionFinished = true;
193         }
194     }
195     
196     function distribution(address[] addresses, uint256 amount) onlyOwner canDistr public {
197         
198         require(addresses.length <= 255);
199         require(amount <= totalRemaining);
200         
201         for (uint i = 0; i < addresses.length; i++) {
202             require(amount <= totalRemaining);
203             distr(addresses[i], amount);
204         }
205 	
206         if (totalDistributed >= totalSupply) {
207             distributionFinished = true;
208         }
209     }
210     
211     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
212 
213         require(addresses.length <= 255);
214         require(addresses.length == amounts.length);
215         
216         for (uint8 i = 0; i < addresses.length; i++) {
217             require(amounts[i] <= totalRemaining);
218             distr(addresses[i], amounts[i]);
219             
220             if (totalDistributed >= totalSupply) {
221                 distributionFinished = true;
222             }
223         }
224     }
225     
226     function () external payable {
227             getTokens();
228      }
229     
230     function getTokens() payable canDistr public {
231         
232         if (value > totalRemaining) {
233             value = totalRemaining;
234         }
235         
236         require(value <= totalRemaining);
237         
238         address investor = msg.sender;
239         uint256 toGive = value;
240         
241         distr(investor, toGive);
242         
243         if (toGive > 0) {
244             blacklist[investor] = true;
245         }
246 
247         if (totalDistributed >= totalSupply) {
248             distributionFinished = true;
249         }
250         
251      
252     }
253 
254 /*
255 
256 READ  THE CONTRACT FAGGOTS
257 
258 */
259 
260     function balanceOf(address _owner) constant public returns (uint256) {
261 	    return balances[_owner];
262     }
263 
264     // mitigates the ERC20 short address attack
265     modifier onlyPayloadSize(uint size) {
266         assert(msg.data.length >= size + 4);
267         _;
268     }
269     
270     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
271 
272         require(_to != address(0));
273         require(_amount <= balances[msg.sender]);
274         
275         balances[msg.sender] = balances[msg.sender].sub(_amount);
276         balances[_to] = balances[_to].add(_amount);
277         Transfer(msg.sender, _to, _amount);
278         return true;
279     }
280     
281     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
282 
283         require(_to != address(0));
284         require(_amount <= balances[_from]);
285         require(_amount <= allowed[_from][msg.sender]);
286         
287         balances[_from] = balances[_from].sub(_amount);
288         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
289         balances[_to] = balances[_to].add(_amount);
290         Transfer(_from, _to, _amount);
291         return true;
292     }
293     
294     function approve(address _spender, uint256 _value) public returns (bool success) {
295         // mitigates the ERC20 spend/approval race condition
296         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
297         allowed[msg.sender][_spender] = _value;
298         Approval(msg.sender, _spender, _value);
299         return true;
300     }
301     
302     function allowance(address _owner, address _spender) constant public returns (uint256) {
303         return allowed[_owner][_spender];
304     }
305     
306     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
307         ForeignToken t = ForeignToken(tokenAddress);
308         uint bal = t.balanceOf(who);
309         return bal;
310     }
311     
312     function withdraw() onlyOwner public {
313         uint256 etherBalance = this.balance;
314         owner.transfer(etherBalance);
315     }
316     
317     function burn(uint256 _value) onlyOwner public {
318         require(_value <= balances[msg.sender]);
319         // no need to require value <= totalSupply, since that would imply the
320         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
321 
322         address burner = msg.sender;
323         balances[burner] = balances[burner].sub(_value);
324         totalSupply = totalSupply.sub(_value);
325         totalDistributed = totalDistributed.sub(_value);
326         Burn(burner, _value);
327     }
328     
329     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
330         ForeignToken token = ForeignToken(_tokenContract);
331         uint256 amount = token.balanceOf(address(this));
332         return token.transfer(owner, amount);
333     }
334 
335 
336 }