1 pragma solidity ^0.4.8;
2 
3 
4 contract SafeMath {
5 
6   function assert(bool assertion) internal {
7     if (!assertion) throw;
8   }
9 
10   function safeMul(uint a, uint b) internal returns (uint) {
11     uint c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function safeDiv(uint a, uint b) internal returns (uint) {
17     assert(b > 0);
18     uint c = a / b;
19     assert(a == b * c + a % b);
20     return c;
21   }
22 
23 }
24 
25 
26 contract StandardTokenProtocol {
27 
28     function totalSupply() constant returns (uint256 totalSupply) {}
29     function balanceOf(address _owner) constant returns (uint256 balance) {}
30     function transfer(address _recipient, uint256 _value) returns (bool success) {}
31     function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
32     function approve(address _spender, uint256 _value) returns (bool success) {}
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
34 
35     event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38 }
39 
40 
41 contract StandardToken is StandardTokenProtocol {
42 
43     modifier when_can_transfer(address _from, uint256 _value) {
44         if (balances[_from] >= _value) _;
45     }
46 
47     modifier when_can_receive(address _recipient, uint256 _value) {
48         if (balances[_recipient] + _value > balances[_recipient]) _;
49     }
50 
51     modifier when_is_allowed(address _from, address _delegate, uint256 _value) {
52         if (allowed[_from][_delegate] >= _value) _;
53     }
54 
55     function transfer(address _recipient, uint256 _value)
56         when_can_transfer(msg.sender, _value)
57         when_can_receive(_recipient, _value)
58         returns (bool o_success)
59     {
60         balances[msg.sender] -= _value;
61         balances[_recipient] += _value;
62         Transfer(msg.sender, _recipient, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _recipient, uint256 _value)
67         when_can_transfer(_from, _value)
68         when_can_receive(_recipient, _value)
69         when_is_allowed(_from, msg.sender, _value)
70         returns (bool o_success)
71     {
72         allowed[_from][msg.sender] -= _value;
73         balances[_from] -= _value;
74         balances[_recipient] += _value;
75         Transfer(_from, _recipient, _value);
76         return true;
77     }
78 
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) returns (bool o_success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) constant returns (uint256 o_remaining) {
90         return allowed[_owner][_spender];
91     }
92 
93     mapping (address => uint256) balances;
94     mapping (address => mapping (address => uint256)) allowed;
95     uint256 public totalSupply;
96 
97 }
98 
99 contract GUPToken is StandardToken {
100 
101 	//FIELDS
102 	string public name = "Guppy";
103     string public symbol = "GUP";
104     uint public decimals = 3;
105 
106 	//CONSTANTS
107 	uint public constant LOCKOUT_PERIOD = 1 years; //time after end date that illiquid GUP can be transferred
108 
109 	//ASSIGNED IN INITIALIZATION
110 	uint public endMintingTime; //Timestamp after which no more tokens can be created
111 	address public minter; //address of the account which may mint new tokens
112 
113 	mapping (address => uint) public illiquidBalance; //Balance of 'Frozen funds'
114 
115 	//MODIFIERS
116 	//Can only be called by contribution contract.
117 	modifier only_minter {
118 		if (msg.sender != minter) throw;
119 		_;
120 	}
121 
122 	// Can only be called if illiquid tokens may be transformed into liquid.
123 	// This happens when `LOCKOUT_PERIOD` of time passes after `endMintingTime`.
124 	modifier when_thawable {
125 		if (now < endMintingTime + LOCKOUT_PERIOD) throw;
126 		_;
127 	}
128 
129 	// Can only be called if (liquid) tokens may be transferred. Happens
130 	// immediately after `endMintingTime`.
131 	modifier when_transferable {
132 		if (now < endMintingTime) throw;
133 		_;
134 	}
135 
136 	// Can only be called if the `crowdfunder` is allowed to mint tokens. Any
137 	// time before `endMintingTime`.
138 	modifier when_mintable {
139 		if (now >= endMintingTime) throw;
140 		_;
141 	}
142 
143 	// Initialization contract assigns address of crowdfund contract and end time.
144 	function GUPToken(address _minter, uint _endMintingTime) {
145 		endMintingTime = _endMintingTime;
146 		minter = _minter;
147 	}
148 
149 	// Create new tokens when called by the crowdfund contract.
150 	// Only callable before the end time.
151 	function createToken(address _recipient, uint _value)
152 		when_mintable
153 		only_minter
154 		returns (bool o_success)
155 	{
156 		balances[_recipient] += _value;
157 		totalSupply += _value;
158 		return true;
159 	}
160 
161 	// Create an illiquidBalance which cannot be traded until end of lockout period.
162 	// Can only be called by crowdfund contract before the end time.
163 	function createIlliquidToken(address _recipient, uint _value)
164 		when_mintable
165 		only_minter
166 		returns (bool o_success)
167 	{
168 		illiquidBalance[_recipient] += _value;
169 		totalSupply += _value;
170 		return true;
171 	}
172 
173 	// Make sender's illiquid balance liquid when called after lockout period.
174 	function makeLiquid()
175 		when_thawable
176 	{
177 		balances[msg.sender] += illiquidBalance[msg.sender];
178 		illiquidBalance[msg.sender] = 0;
179 	}
180 
181 	// Transfer amount of tokens from sender account to recipient.
182 	// Only callable after the crowd fund end date.
183 	function transfer(address _recipient, uint _amount)
184 		when_transferable
185 		returns (bool o_success)
186 	{
187 		return super.transfer(_recipient, _amount);
188 	}
189 
190 	// Transfer amount of tokens from a specified address to a recipient.
191 	// Only callable after the crowd fund end date.
192 	function transferFrom(address _from, address _recipient, uint _amount)
193 		when_transferable
194 		returns (bool o_success)
195 	{
196 		return super.transferFrom(_from, _recipient, _amount);
197 	}
198 }
199 
200 
201 contract Contribution is SafeMath {
202 
203 	//FIELDS
204 
205 	//CONSTANTS
206 	//Time limits
207 	uint public constant STAGE_ONE_TIME_END = 5 hours;
208 	uint public constant STAGE_TWO_TIME_END = 72 hours;
209 	uint public constant STAGE_THREE_TIME_END = 2 weeks;
210 	uint public constant STAGE_FOUR_TIME_END = 4 weeks;
211 	//Prices of GUP
212 	uint public constant PRICE_STAGE_ONE   = 480000;
213 	uint public constant PRICE_STAGE_TWO   = 440000;
214 	uint public constant PRICE_STAGE_THREE = 400000;
215 	uint public constant PRICE_STAGE_FOUR  = 360000;
216 	uint public constant PRICE_BTCS        = 480000;
217 	//GUP Token Limits
218 	uint public constant MAX_SUPPLY =        100000000000;
219 	uint public constant ALLOC_ILLIQUID_TEAM = 8000000000;
220 	uint public constant ALLOC_LIQUID_TEAM =  13000000000;
221 	uint public constant ALLOC_BOUNTIES =      2000000000;
222 	uint public constant ALLOC_NEW_USERS =    17000000000;
223 	uint public constant ALLOC_CROWDSALE =    60000000000;
224 	uint public constant BTCS_PORTION_MAX = 31250 * PRICE_BTCS;
225 	//ASSIGNED IN INITIALIZATION
226 	//Start and end times
227 	uint public publicStartTime; //Time in seconds public crowd fund starts.
228 	uint public privateStartTime; //Time in seconds when BTCSuisse can purchase up to 31250 ETH worth of GUP;
229 	uint public publicEndTime; //Time in seconds crowdsale ends
230 	//Special Addresses
231 	address public btcsAddress; //Address used by BTCSuisse
232 	address public multisigAddress; //Address to which all ether flows.
233 	address public matchpoolAddress; //Address to which ALLOC_BOUNTIES, ALLOC_LIQUID_TEAM, ALLOC_NEW_USERS, ALLOC_ILLIQUID_TEAM is sent to.
234 	address public ownerAddress; //Address of the contract owner. Can halt the crowdsale.
235 	//Contracts
236 	GUPToken public gupToken; //External token contract hollding the GUP
237 	//Running totals
238 	uint public etherRaised; //Total Ether raised.
239 	uint public gupSold; //Total GUP created
240 	uint public btcsPortionTotal; //Total of Tokens purchased by BTC Suisse. Not to exceed BTCS_PORTION_MAX.
241 	//booleans
242 	bool public halted; //halts the crowd sale if true.
243 
244 	//FUNCTION MODIFIERS
245 
246 	//Is currently in the period after the private start time and before the public start time.
247 	modifier is_pre_crowdfund_period() {
248 		if (now >= publicStartTime || now < privateStartTime) throw;
249 		_;
250 	}
251 
252 	//Is currently the crowdfund period
253 	modifier is_crowdfund_period() {
254 		if (now < publicStartTime || now >= publicEndTime) throw;
255 		_;
256 	}
257 
258 	//May only be called by BTC Suisse
259 	modifier only_btcs() {
260 		if (msg.sender != btcsAddress) throw;
261 		_;
262 	}
263 
264 	//May only be called by the owner address
265 	modifier only_owner() {
266 		if (msg.sender != ownerAddress) throw;
267 		_;
268 	}
269 
270 	//May only be called if the crowdfund has not been halted
271 	modifier is_not_halted() {
272 		if (halted) throw;
273 		_;
274 	}
275 
276 	// EVENTS
277 
278 	event PreBuy(uint _amount);
279 	event Buy(address indexed _recipient, uint _amount);
280 
281 
282 	// FUNCTIONS
283 
284 	//Initialization function. Deploys GUPToken contract assigns values, to all remaining fields, creates first entitlements in the GUP Token contract.
285 	function Contribution(
286 		address _btcs,
287 		address _multisig,
288 		address _matchpool,
289 		uint _publicStartTime,
290 		uint _privateStartTime
291 	) {
292 		ownerAddress = msg.sender;
293 		publicStartTime = _publicStartTime;
294 		privateStartTime = _privateStartTime;
295 		publicEndTime = _publicStartTime + 4 weeks;
296 		btcsAddress = _btcs;
297 		multisigAddress = _multisig;
298 		matchpoolAddress = _matchpool;
299 		gupToken = new GUPToken(this, publicEndTime);
300 		gupToken.createIlliquidToken(matchpoolAddress, ALLOC_ILLIQUID_TEAM);
301 		gupToken.createToken(matchpoolAddress, ALLOC_BOUNTIES);
302 		gupToken.createToken(matchpoolAddress, ALLOC_LIQUID_TEAM);
303 		gupToken.createToken(matchpoolAddress, ALLOC_NEW_USERS);
304 	}
305 
306 	//May be used by owner of contract to halt crowdsale and no longer except ether.
307 	function toggleHalt(bool _halted)
308 		only_owner
309 	{
310 		halted = _halted;
311 	}
312 
313 	//constant function returns the current GUP price.
314 	function getPriceRate()
315 		constant
316 		returns (uint o_rate)
317 	{
318 		if (now <= publicStartTime + STAGE_ONE_TIME_END) return PRICE_STAGE_ONE;
319 		if (now <= publicStartTime + STAGE_TWO_TIME_END) return PRICE_STAGE_TWO;
320 		if (now <= publicStartTime + STAGE_THREE_TIME_END) return PRICE_STAGE_THREE;
321 		if (now <= publicStartTime + STAGE_FOUR_TIME_END) return PRICE_STAGE_FOUR;
322 		else return 0;
323 	}
324 
325 	// Given the rate of a purchase and the remaining tokens in this tranche, it
326 	// will throw if the sale would take it past the limit of the tranche.
327 	// It executes the purchase for the appropriate amount of tokens, which
328 	// involves adding it to the total, minting GUP tokens and stashing the
329 	// ether.
330 	// Returns `amount` in scope as the number of GUP tokens that it will
331 	// purchase.
332 	function processPurchase(uint _rate, uint _remaining)
333 		internal
334 		returns (uint o_amount)
335 	{
336 		o_amount = safeDiv(safeMul(msg.value, _rate), 1 ether);
337 		if (o_amount > _remaining) throw;
338 		if (!multisigAddress.send(msg.value)) throw;
339 		if (!gupToken.createToken(msg.sender, o_amount)) throw;
340 		gupSold += o_amount;
341 		etherRaised += msg.value;
342 	}
343 
344 	//Special Function can only be called by BTC Suisse and only during the pre-crowdsale period.
345 	//Allows the purchase of up to 125000 Ether worth of GUP Tokens.
346 	function preBuy()
347 		payable
348 		is_pre_crowdfund_period
349 		only_btcs
350 		is_not_halted
351 	{
352 		uint amount = processPurchase(PRICE_BTCS, BTCS_PORTION_MAX - btcsPortionTotal);
353 		btcsPortionTotal += amount;
354 		PreBuy(amount);
355 	}
356 
357 	//Default function called by sending Ether to this address with no arguments.
358 	//Results in creation of new GUP Tokens if transaction would not exceed hard limit of GUP Token.
359 	function()
360 		payable
361 		is_crowdfund_period
362 		is_not_halted
363 	{
364 		uint amount = processPurchase(getPriceRate(), ALLOC_CROWDSALE - gupSold);
365 		Buy(msg.sender, amount);
366 	}
367 
368 	//failsafe drain
369 	function drain()
370 		only_owner
371 	{
372 		if (!ownerAddress.send(this.balance)) throw;
373 	}
374 }