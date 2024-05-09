1 pragma solidity ^0.4.15;
2 
3 pragma solidity ^0.4.15;
4 
5 contract Token {
6     uint256 public totalSupply;
7 
8     function balanceOf(address _owner) constant returns (uint256 balance);
9     function transfer(address _to, uint256 _value) returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
11     function approve(address _spender, uint256 _value) returns (bool success);
12     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 }
16 
17 
18 /*  ERC 20 token */
19 contract StandardToken is Token {
20 
21     mapping (address => uint256) balances;
22     mapping (address => mapping (address => uint256)) allowed;
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25       if (balances[msg.sender] >= _value && _value > 0) {
26         balances[msg.sender] -= _value;
27         balances[_to] += _value;
28         Transfer(msg.sender, _to, _value);
29         return true;
30         } else {
31             return false;
32         }
33     }
34 
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
36       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
37         balances[_to] += _value;
38         balances[_from] -= _value;
39         allowed[_from][msg.sender] -= _value;
40         Transfer(_from, _to, _value);
41         return true;
42         } else {
43             return false;
44         }
45     }
46 
47     function balanceOf(address _owner) constant returns (uint256 balance) {
48         return balances[_owner];
49     }
50 
51     function approve(address _spender, uint256 _value) returns (bool success) {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
58       return allowed[_owner][_spender];
59   }
60 
61 
62 }
63 
64 pragma solidity ^0.4.15;
65 
66 
67 pragma solidity ^0.4.15;
68 
69 contract Ownable {
70   address public owner;
71 
72   function Ownable() {
73     owner = msg.sender;
74   }
75 
76   modifier onlyOwner() {
77     if (msg.sender == owner)
78       _;
79   }
80 
81   function transferOwnership(address newOwner) onlyOwner {
82     if (newOwner != address(0)) owner = newOwner;
83   }
84 
85 }
86 
87 
88 
89 /*
90  * Pausable
91  * Abstract contract that allows children to implement an
92  * emergency stop mechanism.
93  */
94 
95 contract Pausable is Ownable {
96   bool public stopped;
97 
98   modifier stopInEmergency {
99     if (stopped) {
100       throw;
101     }
102     _;
103   }
104 
105   modifier onlyInEmergency {
106     if (!stopped) {
107       throw;
108     }
109     _;
110   }
111 
112   // called by the owner on emergency, triggers stopped state
113   function emergencyStop() external onlyOwner {
114     stopped = true;
115   }
116 
117   // called by the owner on end of emergency, returns to normal state
118   function release() external onlyOwner onlyInEmergency {
119     stopped = false;
120   }
121 
122 }
123 
124 pragma solidity ^0.4.15;
125 
126 contract Utils{
127 
128   //verifies the amount greater than zero
129 
130   modifier greaterThanZero(uint256 _value){
131     require(_value>0);
132     _;
133   }
134 
135   ///verifies an address
136 
137   modifier validAddress(address _add){
138     require(_add!=0x0);
139     _;
140   }
141 }
142 
143 
144 pragma solidity ^0.4.15;
145 
146 
147 /**
148  * Math operations with safety checks
149  */
150 contract SafeMath {
151   function safeMul(uint a, uint b) internal returns (uint) {
152     uint c = a * b;
153     assert(a == 0 || c / a == b);
154     return c;
155   }
156 
157   function safeDiv(uint a, uint b) internal returns (uint) {
158     assert(b > 0);
159     uint c = a / b;
160     assert(a == b * c + a % b);
161     return c;
162   }
163 
164   function safeSub(uint a, uint b) internal returns (uint) {
165     assert(b <= a);
166     return a - b;
167   }
168 
169   function safeAdd(uint a, uint b) internal returns (uint) {
170     uint c = a + b;
171     assert(c>=a && c>=b);
172     return c;
173   }
174 
175   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
176     return a >= b ? a : b;
177   }
178 
179   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
180     return a < b ? a : b;
181   }
182 
183   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
184     return a >= b ? a : b;
185   }
186 
187   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
188     return a < b ? a : b;
189   }
190 
191 }
192 
193 
194 
195 
196 contract Crowdsale is StandardToken, Pausable, SafeMath, Utils{
197 	string public constant name = "BlockAim Token";
198 	string public constant symbol = "BA";
199 	uint256 public constant decimals = 18;
200 	string public version = "1.0";
201 	bool public tradingStarted = false;
202 
203     /**
204    * @dev modifier that throws if trading has not started yet
205    */
206    modifier hasStartedTrading() {
207    	require(tradingStarted);
208    	_;
209    }
210   /**
211    * @dev Allows the owner to enable the trading. This can not be undone
212    */
213    function startTrading() onlyOwner() {
214    	tradingStarted = true;
215    }
216 
217    function transfer(address _to, uint _value) hasStartedTrading returns (bool success) {super.transfer(_to, _value);}
218 
219    function transferFrom(address _from, address _to, uint _value) hasStartedTrading returns (bool success) {super.transferFrom(_from, _to, _value);}
220 
221    enum State{
222    	Inactive,
223    	Funding,
224    	Success,
225    	Failure
226    }
227 
228    uint256 public investmentETH;
229    mapping(uint256 => bool) transactionsClaimed;
230    uint256 public initialSupply;
231    address wallet;
232    uint256 public constant _totalSupply = 100 * (10**6) * 10 ** decimals; // 100M ~ 10 Crores
233    uint256 public fundingStartBlock; // crowdsale start block
234    uint256 public tokensPerEther = 300; // 1 ETH = 300 tokens
235    uint256 public constant tokenCreationMax = 10 * (10**6) * 10 ** decimals; // 10M ~ 1 Crores
236    address[] public investors;
237 
238    //displays number of uniq investors
239    function investorsCount() constant external returns(uint) { return investors.length; }
240 
241    function Crowdsale(uint256 _fundingStartBlock, address _owner, address _wallet){
242       owner = _owner;
243       fundingStartBlock =_fundingStartBlock;
244       totalSupply = _totalSupply;
245       initialSupply = 0;
246       wallet = _wallet;
247 
248       //check configuration if something in setup is looking weird
249       if (
250         tokensPerEther == 0
251         || owner == 0x0
252         || wallet == 0x0
253         || fundingStartBlock == 0
254         || totalSupply == 0
255         || tokenCreationMax == 0
256         || fundingStartBlock <= block.number)
257       throw;
258 
259    }
260 
261    // don't just send ether to the contract expecting to get tokens
262    //function() { throw; }
263    ////@dev This function manages the Crowdsale State machine
264    ///We make it a function and do not assign to a variable//
265    ///so that no chance of stale variable
266    function getState() constant public returns(State){
267    	///once we reach success lock the State
268    	if(block.number<fundingStartBlock) return State.Inactive;
269    	else if(block.number>fundingStartBlock && initialSupply<tokenCreationMax) return State.Funding;
270    	else if (initialSupply >= tokenCreationMax) return State.Success;
271    	else return State.Failure;
272    }
273 
274    ///get total tokens in that address mapping
275    function getTokens(address addr) public returns(uint256){
276    	return balances[addr];
277    }
278 
279  
280    function() external payable stopInEmergency{
281    	// Abort if not in Funding Active state.
282    	if(getState() == State.Success) throw;
283    	if (msg.value == 0) throw;
284    	uint256 newCreatedTokens = safeMul(msg.value,tokensPerEther);
285    	///since we are creating tokens we need to increase the total supply
286    	initialSupply = safeAdd(initialSupply,newCreatedTokens);
287    	if(initialSupply>tokenCreationMax) throw;
288       if (balances[msg.sender] == 0) investors.push(msg.sender);
289       investmentETH += msg.value;
290       balances[msg.sender] = safeAdd(balances[msg.sender],newCreatedTokens);
291       Transfer(this, msg.sender, newCreatedTokens);
292       // Pocket the money
293       if(!wallet.send(msg.value)) throw;
294    }
295 
296 
297    ///to be done only the owner can run this function
298    function tokenMint(address addr,uint256 tokens)
299    external
300    stopInEmergency
301    onlyOwner()
302    {
303    	if(getState() == State.Success) throw;
304     if(addr == 0x0) throw;
305    	if (tokens == 0) throw;
306    	uint256 newCreatedTokens = tokens * 1 ether;
307    	initialSupply = safeAdd(initialSupply,newCreatedTokens);
308    	if(initialSupply>tokenCreationMax) throw;
309       if (balances[addr] == 0) investors.push(addr);
310       balances[addr] = safeAdd(balances[addr],newCreatedTokens);
311       Transfer(this, addr, newCreatedTokens);
312    }
313 
314    
315    ///change exchange rate ~ update price everyday
316    function changeExchangeRate(uint256 eth)
317    external
318    onlyOwner()
319    {
320      if(eth == 0) throw;
321      tokensPerEther = eth;
322   }
323 
324   ///blacklist the users which are fraudulent
325   ///from getting any tokens
326   ///to do also refund just in cases
327   function blacklist(address addr)
328   external
329   onlyOwner()
330   {
331      balances[addr] = 0;
332   }
333 
334 }