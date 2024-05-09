1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 	function mul(uint a, uint b) internal returns (uint) {
10 		uint c = a * b;
11 		assert(a == 0 || c / a == b);
12 		return c;
13 	}
14 	function safeSub(uint a, uint b) internal returns (uint) {
15 		assert(b <= a);
16 		return a - b;
17 	}
18 	function div(uint a, uint b) internal returns (uint) {
19 		assert(b > 0);
20 		uint c = a / b;
21 		assert(a == b * c + a % b);
22 		return c;
23 	}
24 	function sub(uint a, uint b) internal returns (uint) {
25 		assert(b <= a);
26 		return a - b;
27 	}
28 	function add(uint a, uint b) internal returns (uint) {
29 		uint c = a + b;
30 		assert(c >= a);
31 		return c;
32 	}
33 	function max64(uint64 a, uint64 b) internal constant returns (uint64) {
34 		return a >= b ? a : b;
35 	}
36 	function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37 		return a < b ? a : b;
38 	}
39 	function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40 		return a >= b ? a : b;
41 	}
42 	function min256(uint256 a, uint256 b) internal constant returns (uint256) {
43 		return a < b ? a : b;
44 	}
45 	function assert(bool assertion) internal {
46 		if (!assertion) {
47 			throw;
48 		}
49 	}
50 }
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     address public owner;
60     function Ownable() {
61         owner = msg.sender;
62     }
63     modifier onlyOwner {
64         if (msg.sender != owner) throw;
65         _;
66     }
67     function transferOwnership(address newOwner) onlyOwner {
68         if (newOwner != address(0)) {
69             owner = newOwner;
70         }
71     }
72 }
73 
74 
75 /**
76  * @title Pausable
77  * @dev Base contract which allows children to implement an emergency stop mechanism.
78  */
79 contract Pausable is Ownable {
80 	bool public stopped;
81 	modifier stopInEmergency {
82 		if (stopped) {
83 			throw;
84 		}
85 		_;
86 	}
87 
88 	modifier onlyInEmergency {
89 		if (!stopped) {
90 		  throw;
91 		}
92 	_;
93 	}
94 	// called by the owner on emergency, triggers stopped state
95 	function emergencyStop() external onlyOwner {
96 		stopped = true;
97 	}
98 	// called by the owner on end of emergency, returns to normal state
99 	function release() external onlyOwner onlyInEmergency {
100 		stopped = false;
101 	}
102 }
103 
104 
105 
106 /**
107  * @title PullPayment
108  * @dev Base contract supporting async send for pull payments. Inherit from this
109  * contract and use asyncSend instead of send.
110  */
111 contract PullPayment {
112 	using SafeMath for uint;
113 
114 	mapping(address => uint) public payments;
115 	event LogRefundETH(address to, uint value);
116 	/**
117 	*  Store sent amount as credit to be pulled, called by payer 
118 	**/
119 	function asyncSend(address dest, uint amount) internal {
120 		payments[dest] = payments[dest].add(amount);
121 	}
122 	// withdraw accumulated balance, called by payee
123 	function withdrawPayments() {
124 		address payee = msg.sender;
125 		uint payment = payments[payee];
126 
127 		if (payment == 0) {
128 			throw;
129 		}
130 		if (this.balance < payment) {
131 		    throw;
132 		}
133 		payments[payee] = 0;
134 		if (!payee.send(payment)) {
135 		    throw;
136 		}
137 		LogRefundETH(payee,payment);
138 	}
139 }
140 
141 
142 
143 /**
144  * @title ERC20Basic
145  * @dev Simpler version of ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/179
147  */
148 contract ERC20Basic {
149 	uint public totalSupply;
150 	function balanceOf(address who) constant returns (uint);
151 	function transfer(address to, uint value);
152 	event Transfer(address indexed from, address indexed to, uint value);
153 }
154 
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161 	function allowance(address owner, address spender) constant returns (uint);
162 	function transferFrom(address from, address to, uint value);
163 	function approve(address spender, uint value);
164 	event Approval(address indexed owner, address indexed spender, uint value);
165 }
166 
167 
168 /**
169  * @title Basic token
170  * @dev Basic version of StandardToken, with no allowances. 
171  */
172 contract BasicToken is ERC20Basic {
173   
174 	using SafeMath for uint;
175 
176 	mapping(address => uint) balances;
177 
178 	/*
179 	* Fix for the ERC20 short address attack  
180 	*/
181 	modifier onlyPayloadSize(uint size) {
182 	   if(msg.data.length < size + 4) {
183 	     throw;
184 	   }
185 	 _;
186 	}
187 	function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
188 		balances[msg.sender] = balances[msg.sender].sub(_value);
189 		balances[_to] = balances[_to].add(_value);
190 		Transfer(msg.sender, _to, _value);
191 	}
192 	function balanceOf(address _owner) constant returns (uint balance) {
193 		return balances[_owner];
194 	}
195 }
196 
197 
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implementation of the basic standard token.
202  * @dev https://github.com/ethereum/EIPs/issues/20
203  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
204  */
205 contract StandardToken is BasicToken, ERC20 {
206 	mapping (address => mapping (address => uint)) allowed;
207 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
208 		var _allowance = allowed[_from][msg.sender];
209 		balances[_to] = balances[_to].add(_value);
210 		balances[_from] = balances[_from].sub(_value);
211 		allowed[_from][msg.sender] = _allowance.sub(_value);
212 		Transfer(_from, _to, _value);
213     }
214 	function approve(address _spender, uint _value) {
215 		if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
216 		allowed[msg.sender][_spender] = _value;
217 		Approval(msg.sender, _spender, _value);
218 	}
219 	function allowance(address _owner, address _spender) constant returns (uint remaining) {
220 		return allowed[_owner][_spender];
221 	}
222 }
223 
224 
225 /**
226  *  Devvote tokens contract.
227  */
228 contract DevotteToken is StandardToken, Ownable {
229 	
230   using SafeMath for uint;
231   
232 
233     /**
234      * Variables
235     */
236     string public constant name = "DEVVOTE";
237     string public constant symbol = "VVE";
238     uint256 public constant decimals = 0;
239 
240    
241     /**
242      * @dev Contract constructor
243      */ 
244     function DevotteToken() {
245     totalSupply = 100000000;
246     balances[msg.sender] = totalSupply;
247     }
248     
249     
250     /**
251     *  Burn away the specified amount of ClusterToken tokens.
252     * @return Returns success boolean.
253     */
254     function burn(uint _value) onlyOwner returns (bool) {
255         balances[msg.sender] = balances[msg.sender].sub(_value);
256         totalSupply = totalSupply.sub(_value);
257         Transfer(msg.sender, 0x0, _value);
258         return true;
259     }
260     
261 }
262 
263 
264 contract DevvotePrefund is Pausable, PullPayment {
265     
266     using SafeMath for uint;
267     
268     
269     enum memberRanking { Executive, boardMember, ActiveMember, supportingMember }
270     memberRanking ranking;
271 
272 
273   	struct Backer {
274 		uint weiReceived;
275 		uint coinSent;
276 		memberRanking userRank;
277 	}
278 
279 	/*
280 	* Constants
281 	*/
282 
283 	uint public constant MIN_CAP = 5000; // 
284 	uint public constant MAX_CAP = 250000; // 
285 	
286 	/* Minimum amount to invest */
287 	uint public constant MIN_INVEST_ETHER = 100 finney;
288 	uint public constant MIN_INVEST_BOARD = 10 ether ;
289 	uint public constant MIN_INVEST_ACTIVE = 3 ether;
290 	uint public constant MIN_INVEST_SUPPORT = 100 finney;
291 
292 	uint private constant DevvotePrefund_PERIOD = 30 days;
293 
294 	uint public constant COIN_PER_ETHER = 1000;
295 	uint public constant COIN_PER_ETHER_BOARD = 2500;
296 	uint public constant COIN_PER_ETHER_ACTIVE = 1500;
297 	uint public constant COIN_PER_ETHER_SUPPORT = 1000;
298 
299 
300 	/*
301 	* Variables
302 	*/
303 
304 	DevotteToken public coin;
305 	address public multisigEther;
306 	uint public etherReceived;
307 	uint public coinSentToEther;
308 
309 	uint public startTime;
310 	uint public endTime;
311 	bool public DevvotePrefundClosed;
312 
313 	/* Backers Ether indexed by their Ethereum address */
314 	mapping(address => Backer) public backers;
315 
316 
317 	/*
318 	* Modifiers
319 	*/
320 	modifier minCapNotReached() {
321 		if ((now < endTime) || coinSentToEther >= MIN_CAP ) throw;
322 		_;
323 	}
324 
325 	modifier respectTimeFrame() {
326 		if ((now < startTime) || (now > endTime )) throw;
327 		_;
328 	}
329 
330 	/*
331 	 * Event
332 	*/
333 	event LogReceivedETH(address addr, uint value);
334 	event LogCoinsEmited(address indexed from, uint amount);
335 
336 	/*
337 	 * Constructor
338 	*/
339 	function DevvotePrefund(address _devvoteAddress, address _to) {
340 		coin = DevotteToken(_devvoteAddress);
341 		multisigEther = _to;
342 		start();
343 	}
344 
345 	/* 
346 	 * The fallback function corresponds to a donation in ETH
347 	 */
348 	function() stopInEmergency respectTimeFrame payable {
349 		receiveETH(msg.sender);
350 	}
351 
352 	/* 
353 	 * To call to start the DevvotePrefund
354 	 */
355 	function start() onlyOwner {
356 		if (startTime != 0) throw; // DevvotePrefund was already started
357 
358 		startTime = now ;            
359 		endTime =  now + DevvotePrefund_PERIOD;    
360 	}
361 
362 	/*
363 	 *	Receives a donation in Ether
364 	*/
365 	function receiveETH(address beneficiary) internal {
366 	    
367 	    memberRanking setRank;
368 	    uint coinToSend;
369 	    
370 		if (msg.value < MIN_INVEST_ETHER) throw; 
371 		
372 		
373 		if (msg.value < MIN_INVEST_ACTIVE && msg.value >= MIN_INVEST_ETHER ) { 
374 		    setRank = memberRanking.supportingMember;
375 		    coinToSend = bonus(msg.value.mul(COIN_PER_ETHER_SUPPORT).div(1 ether));
376 		}
377 		if (msg.value < MIN_INVEST_BOARD  && msg.value >= MIN_INVEST_ACTIVE) {
378 		    setRank = memberRanking.ActiveMember;
379 		    coinToSend = bonus(msg.value.mul(COIN_PER_ETHER_ACTIVE).div(1 ether));
380 		}
381 		if (msg.value >= MIN_INVEST_BOARD ) {
382 		    setRank = memberRanking.boardMember;
383 		    coinToSend = bonus(msg.value.mul(COIN_PER_ETHER_BOARD).div(1 ether));
384 		}
385 		
386 		
387 		if (coinToSend.add(coinSentToEther) > MAX_CAP) throw;	
388 
389 		Backer backer = backers[beneficiary];
390 		coin.transfer(beneficiary, coinToSend); 
391 		backer.coinSent = backer.coinSent.add(coinToSend);
392 		backer.weiReceived = backer.weiReceived.add(msg.value);    
393 		backer.userRank = setRank;
394 
395 		etherReceived = etherReceived.add(msg.value);
396 		coinSentToEther = coinSentToEther.add(coinToSend);
397 
398 		LogCoinsEmited(msg.sender ,coinToSend);
399 		LogReceivedETH(beneficiary, etherReceived); 
400 	}
401 	
402 
403 	/*
404 	 *Compute the Devvote bonus according to the investment period
405 	 */
406 	function bonus(uint amount) internal constant returns (uint) {
407 		return amount.add(amount.div(5));   // bonus 20%
408 	}
409 
410 	/*	
411 	 * Finalize the DevvotePrefund, should be called after the refund period
412 	*/
413 	function finalize() onlyOwner public {
414 
415 		if (now < endTime) { // Cannot finalise before DevvotePrefund_PERIOD or before selling all coins
416 			if (coinSentToEther == MAX_CAP) {
417 			} else {
418 				throw;
419 			}
420 		}
421 
422 		if (coinSentToEther < MIN_CAP && now < endTime + 15 days) throw; // If MIN_CAP is not reached donors have 15days to get refund before we can finalise
423 
424 		if (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address
425 		
426 		uint remains = coin.balanceOf(this);
427 		if (remains > 0) { // Burn the rest of Devvotes
428 			if (!coin.burn(remains)) throw ;
429 		}
430 		DevvotePrefundClosed = true;
431 	}
432 
433 	/*	
434 	* Failsafe drain
435 	*/
436 	function drain() onlyOwner {
437 		if (!owner.send(this.balance)) throw;
438 	}
439 
440 	/**
441 	 * Allow to change the team multisig address in the case of emergency.
442 	 */
443 	function setMultisig(address addr) onlyOwner public {
444 		if (addr == address(0)) throw;
445 		multisigEther = addr;
446 	}
447 
448 	/**
449 	 * Manually back Devvote owner address.
450 	 */
451 	function backDevvoteOwner() onlyOwner public {
452 		coin.transferOwnership(owner);
453 	}
454 
455 	/**
456 	 * Transfer remains to owner in case if impossible to do min invest
457 	 */
458 	function getRemainCoins() onlyOwner public {
459 		var remains = MAX_CAP - coinSentToEther;
460 		uint minCoinsToSell = bonus(MIN_INVEST_ETHER.mul(COIN_PER_ETHER) / (1 ether));
461 
462 		if(remains > minCoinsToSell) throw;
463 
464 		Backer backer = backers[owner];
465 		coin.transfer(owner, remains); // Transfer Devvotes right now 
466 
467 		backer.coinSent = backer.coinSent.add(remains);
468 
469 		coinSentToEther = coinSentToEther.add(remains);
470 
471 		// Send events
472 		LogCoinsEmited(this ,remains);
473 		LogReceivedETH(owner, etherReceived); 
474 	}
475 
476 
477 	/* 
478   	 * When MIN_CAP is not reach:
479   	 * 1) backer call the "approve" function of the Devvote token contract with the amount of all Devvotes they got in order to be refund
480   	 * 2) backer call the "refund" function of the DevvotePrefund contract with the same amount of Devvotes
481    	 * 3) backer call the "withdrawPayments" function of the DevvotePrefund contract to get a refund in ETH
482    	 */
483 	function refund(uint _value) minCapNotReached public {
484 		
485 		if (_value != backers[msg.sender].coinSent) throw; // compare value from backer balance
486 
487 		coin.transferFrom(msg.sender, address(this), _value); // get the token back to the DevvotePrefund contract
488 
489 		if (!coin.burn(_value)) throw ; // token sent for refund are burnt
490 
491 		uint ETHToSend = backers[msg.sender].weiReceived;
492 		backers[msg.sender].weiReceived=0;
493 
494 		if (ETHToSend > 0) {
495 			asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
496 		}
497 	}
498 
499 }