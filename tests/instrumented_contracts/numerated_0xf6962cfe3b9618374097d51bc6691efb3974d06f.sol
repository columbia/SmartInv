1 /**
2 *
3 * Inspired by FirstBlood Token - firstblood.io
4 *
5 */
6 
7 pragma solidity ^0.4.16;
8 
9 /**
10 * @title SafeMath
11 * @dev Math operations with safety checks that throw on error
12 **/
13 library SafeMath {
14 	function mul(uint256 a, uint256 b) internal returns (uint256) {
15 		uint256 c = a * b;
16 		assert(a == 0 || c / a == b);
17 		return c;
18   	}
19 
20   	function div(uint256 a, uint256 b) internal returns (uint256) {
21 		uint256 c = a / b;
22 		return c;
23   	}
24 
25 	function sub(uint256 a, uint256 b) internal returns (uint256) {
26 		assert(b <= a);
27 		return a - b;
28 	}
29 
30 	function add(uint256 a, uint256 b) internal returns (uint256) {
31 		 uint256 c = a + b;
32 		 assert(c >= a);
33 		 return c;
34 	}
35 }
36 
37 /**
38 * @title Ownable
39 * @dev The Ownable contract has an owner address, and provides basic authorization control
40 * functions, this simplifies the implementation of "user permissions".
41 **/
42 contract Ownable {
43 	address public owner;
44 
45 	/**
46 	* @dev The Ownable constructor sets the original 'owner' of the contract to the sender
47 	* account.
48 	**/
49 	function Ownable() {
50 		owner = msg.sender;
51 	}
52 
53 	/**
54 	* @dev Throws if called by any account other than the owner.
55 	**/
56 	modifier onlyOwner() {
57 		require(msg.sender == owner);
58 		_;
59 	}
60 
61 	/**
62 	* @dev Allows the current owner to transfer control of the contract to a newOwner.
63 	* @param newOwner The address to transfer ownership to.
64 	**/
65 	function transferOwnership(address newOwner) onlyOwner {
66 		if (newOwner != address(0)) {
67 			owner = newOwner;
68 		}
69 	}
70 }
71 
72 /**
73 * @title Pausable
74 * @dev Base contract which allows children to implement an emergency stop mechanism.
75 **/
76 contract Pausable is Ownable {
77 	event Pause();
78 	event Unpause();
79 	event PauseRefund();
80 	event UnpauseRefund();
81 
82 	bool public paused = true;
83 	bool public refundPaused = true;
84 	// Deadline set to December 29th, 2017 at 11:59pm PST
85 	uint256 public durationInMinutes = 60*24*29+60*3+10;
86 	uint256 public dayAfterInMinutes = 60*24*30+60*3+10;
87 	uint256 public deadline = now + durationInMinutes * 1 minutes;
88 	uint256 public dayAfterDeadline = now + dayAfterInMinutes * 1 minutes;
89 
90 	/**
91 	* @dev modifier to allow actions only when the contract IS NOT paused
92 	**/
93 	modifier whenNotPaused() {
94 		require(!paused);
95 		_;
96 	}
97 
98 	/**
99 	* @dev modifier to allow actions only when the refund IS NOT paused
100 	**/
101 	modifier whenRefundNotPaused() {
102 		require(!refundPaused);
103 		_;
104 	}
105 
106 	/**
107 	* @dev modifier to allow actions only when the contract IS paused
108 	**/
109 	modifier whenPaused {
110 		require(paused);
111 		_;
112 	}
113 
114 	/**
115 	* @dev modifier to allow actions only when the refund IS paused
116 	**/
117 	modifier whenRefundPaused {
118 		require(refundPaused);
119 		_;
120 	}
121 
122 	/**
123 	* @dev modifier to allow actions only when the crowdsale has ended
124 	**/
125 	modifier whenCrowdsaleEnded {
126 		require(deadline < now);
127 		_;
128 	}
129 
130 	/**
131 	* @dev modifier to allow actions only when the crowdsale has not ended
132 	**/
133 	modifier whenCrowdsaleNotEnded {
134 		require(deadline >= now);
135 		_;
136 	}
137 
138 	/**
139 	* @dev called by the owner to pause, triggers stopped state
140 	**/
141 	function pause() onlyOwner whenNotPaused returns (bool) {
142 		paused = true;
143 		Pause();
144 		return true;
145 	}
146 
147 	/**
148 	* @dev called by the owner to pause, triggers stopped state
149 	**/
150 	function pauseRefund() onlyOwner whenRefundNotPaused returns (bool) {
151 		refundPaused = true;
152 		PauseRefund();
153 		return true;
154 	}
155 
156 	/**
157 	* @dev called by the owner to unpause, returns to normal state
158 	**/
159 	function unpause() onlyOwner whenPaused returns (bool) {
160 		paused = false;
161 		Unpause();
162 		return true;
163 	}
164 
165 	/**
166 	* @dev called by the owner to unpause, returns to normal state
167 	**/
168 	function unpauseRefund() onlyOwner whenRefundPaused returns (bool) {
169 		refundPaused = false;
170 		UnpauseRefund();
171 		return true;
172 	}
173 }
174 
175 /**
176 * @title ERC20Basic
177 * @dev Simpler version of ERC20 interface
178 * @dev see https://github.com/ethereum/EIPs/issues/179
179 **/
180 contract ERC20Basic {
181 	uint256 public totalSupply;
182 	function balanceOf(address who) constant returns (uint256);
183 	function transfer(address to, uint256 value) returns (bool);
184 	event Transfer(address indexed from, address indexed to, uint256 value);
185 }
186 
187 /**
188 * @title Basic token
189 * @dev Basic version of StandardToken, with no allowances.
190 **/
191 contract BasicToken is ERC20Basic {
192 	using SafeMath for uint256;
193 
194 	mapping(address => uint256) balances;
195 
196 	/**
197 	* @dev transfer token for a specified address
198 	* @param _to The address to transfer to.
199 	* @param _value The amount to be transferred.
200 	**/
201 	function transfer(address _to, uint256 _value) returns (bool) {
202 		balances[msg.sender] = balances[msg.sender].sub(_value);
203 		balances[_to] = balances[_to].add(_value);
204 		Transfer(msg.sender, _to, _value);
205 		return true;
206 	}
207 
208 	/**
209 	* @dev Gets the balance of the specified address.
210 	* @param _owner The address to query the the balance of.
211 	* @return An uint256 representing the amount owned by the passed address.
212 	**/
213 	function balanceOf(address _owner) constant returns (uint256 balance) {
214 		return balances[_owner];
215 	}
216 }
217 
218 /**
219 * @title ERC20 interface
220 * @dev see https://github.com/ethereum/EIPs/issues/20
221 **/
222 contract ERC20 is ERC20Basic {
223 	function allowance(address owner, address spender) constant returns (uint256);
224 	function transferFrom(address from, address to, uint256 value) returns (bool);
225 	function approve(address spender, uint256 value) returns (bool);
226 	event Approval(address indexed owner, address indexed spender, uint256 value);
227 }
228 
229 /**
230 * @title Standard ERC20 token
231 *
232 * @dev Implementation of the basic standard token.
233 * @dev https://github.com/ethereum/EIPs/issues/20
234 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
235 **/
236 contract StandardToken is ERC20, BasicToken {
237 
238 	mapping (address => mapping (address => uint256)) allowed;
239 
240 	/**
241 	* @dev Transfer tokens from one address to another
242 	* @param _from address The address which you want to send tokens from
243 	* @param _to address The address which you want to transfer to
244 	* @param _value uint256 the amout of tokens to be transfered
245 	**/
246 	function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
247 		var _allowance = allowed[_from][msg.sender];
248 
249 		require (_value <= _allowance);
250 
251 		balances[_to] = balances[_to].add(_value);
252 		balances[_from] = balances[_from].sub(_value);
253 		allowed[_from][msg.sender] = _allowance.sub(_value);
254 		
255 		Transfer(_from, _to, _value);
256 		
257 		return true;
258 	}
259 
260 	/**
261 	* @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
262 	* @param _spender The address which will spend the funds.
263 	* @param _value The amount of tokens to be spent.
264 	**/
265 	function approve(address _spender, uint256 _value) returns (bool) {
266 		
267 		/**
268 		* To change the approve amount you first have to reduce the addresses'
269 		* allowance to zero by calling 'approve(_spender, 0)' if it is not
270 		* already 0 to mitigate the race condition described here: 
271 		https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
272 		**/
273 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
274 
275 		allowed[msg.sender][_spender] = _value;
276 		Approval(msg.sender, _spender, _value);
277 		return true;
278 	}
279 
280 	/**
281 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
282 	* @param _owner address The address which owns the funds.
283 	* @param _spender address The address which will spend the funds.
284 	* @return A uint256 specifing the amount of tokens still available for the spender.
285 	**/
286 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
287 		return allowed[_owner][_spender];
288 	}
289 
290 }
291 
292 /**
293 * @title hodlToken
294 * @dev All tokens are pre-assigned to the creator.
295 * Tokens can be transferred using 'transfer' and other
296 * 'StandardToken' functions.
297 **/
298 contract hodlToken is Pausable, StandardToken {
299 
300 	using SafeMath for uint256;
301 
302 	address public escrow = this;
303 
304 	//20% Finder allocation 
305 	uint256 public purchasableTokens = 112000 * 10**18;
306 	uint256 public founderAllocation = 28000 * 10**18;
307 
308 	string public name = "TeamHODL Token";
309 	string public symbol = "THODL";
310 	uint256 public decimals = 18;
311 	uint256 public INITIAL_SUPPLY = 140000 * 10**18;
312 
313 	uint256 public RATE = 200;
314 	uint256 public REFUND_RATE = 200;
315 
316 	/**
317 	* @dev Contructor that gives msg.sender all of existing tokens.
318 	**/
319 	function hodlToken() {
320 		totalSupply = INITIAL_SUPPLY;
321 		balances[msg.sender] = INITIAL_SUPPLY;
322 	}
323 
324 	/**
325 	* @dev Allows the current owner to transfer control of the contract to a newOwner.
326 	* @param newOwner The address to transfer ownership to.
327 	**/
328 	function transferOwnership(address newOwner) onlyOwner {
329 		address oldOwner = owner;
330 		super.transferOwnership(newOwner);
331 		balances[newOwner] = balances[oldOwner];
332 		balances[oldOwner] = 0;
333 	}
334 
335 	/**
336 	* @dev Allows the current owner to transfer escrowship of the contract to a escrow account.
337 	* @param newEscrow The address to transfer the escrow account to.
338 	**/
339 	function transferEscrowship(address newEscrow) onlyOwner {
340 		if (newEscrow != address(0)) {
341 			escrow = newEscrow;
342 		}
343 	}
344 
345 	/**
346 	* @dev Allows the current owner to set the new total supply, to be used iff not all tokens sold during crowdsale.
347 	**/
348 	function setTotalSupply() onlyOwner whenCrowdsaleEnded {
349 		if (purchasableTokens > 0) {
350 			totalSupply = totalSupply.sub(purchasableTokens);
351 		}
352 	}
353 
354 	/**
355 	* @dev Allows the current owner to withdraw ether funds after ICO ended.
356 	**/
357 	function cashOut() onlyOwner whenCrowdsaleEnded {
358 		
359 		/**
360 		* Transfer money from escrow wallet up to 1 day after ICO end.
361 		**/
362 		if (dayAfterDeadline >= now) {
363 			owner.transfer(escrow.balance);
364 		}
365 	}
366   
367 	/**
368 	* @dev Allows owner to change the exchange rate of tokens (default 0.005 Ether)
369 	**/
370 	function setRate(uint256 rate) {
371 
372 		/**
373 		* If break-even point has been reached (3500 Eth = 3.5*10**21 Wei),
374 		* rate updates to 20% of total revenue (100% of dedicated wallet after forwarding contract)
375 		**/
376 		if (escrow.balance >= 7*10**20) {
377 
378 			/**
379 			* Rounds up to address division error
380 			**/
381 			RATE = (((totalSupply.mul(10000)).div(escrow.balance)).add(9999)).div(10000);
382 		}
383 	}
384   
385 	/**
386 	* @dev Allows owner to change the refund exchange rate of tokens (default 0.005 Ether)
387 	* @param rate The number of tokens to release
388 	**/
389 	function setRefundRate(uint256 rate) {
390 
391 		/**
392 		* If break-even point has been reached (3500 Eth = 3.5*10**21 Wei),
393 		* refund rate updates to 20% of total revenue (100% of dedicated wallet after forwarding contract)
394 		**/
395 		if (escrow.balance >= 7*10**20) {
396 
397 			/**
398 			* Rounds up to address division error
399 			**/
400 			REFUND_RATE = (((totalSupply.mul(10000)).div(escrow.balance)).add(9999)).div(10000);
401 		}
402 	}
403 
404 	/**
405 	* @dev fallback function
406 	**/
407 	function () payable {
408 		if(now <= deadline){
409 			buyTokens(msg.sender);
410 		}
411 	}
412 
413 	/**
414 	* @dev function that sells available tokens
415 	**/
416 	function buyTokens(address addr) payable whenNotPaused whenCrowdsaleNotEnded {
417 		
418 		/**
419 		* Calculate tokens to sell and check that they are purchasable
420 		**/
421 		uint256 weiAmount = msg.value;
422 		uint256 tokens = weiAmount.mul(RATE);
423 		require(purchasableTokens >= tokens);
424 
425 		/**
426 		* Send tokens to buyer
427 		**/
428 		purchasableTokens = purchasableTokens.sub(tokens);
429 		balances[owner] = balances[owner].sub(tokens);
430 		balances[addr] = balances[addr].add(tokens);
431 
432 		Transfer(owner, addr, tokens);
433 	}
434   
435 	function fund() payable {}
436 
437 	function defund() onlyOwner {}
438 
439 	function refund(uint256 _amount) payable whenNotPaused whenCrowdsaleEnded {
440 
441 		/**
442 		* Calculate amount of THODL to refund
443 		**/
444 		uint256 refundTHODL = _amount.mul(10**18);
445 		require(balances[msg.sender] >= refundTHODL);
446 
447 		/**
448 		* Calculate refund in wei
449 		**/
450 		uint256 weiAmount = refundTHODL.div(REFUND_RATE);
451 		require(this.balance >= weiAmount);
452 
453 		balances[msg.sender] = balances[msg.sender].sub(refundTHODL);
454 		
455 		/**
456 		* The tokens are burned
457 		**/
458 		totalSupply = totalSupply.sub(refundTHODL);
459 
460 		msg.sender.transfer(weiAmount);
461 	}
462 }