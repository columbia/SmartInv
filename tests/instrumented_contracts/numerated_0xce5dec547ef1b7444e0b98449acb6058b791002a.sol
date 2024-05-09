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
104 /**
105  * @title ERC20Basic
106  * @dev Simpler version of ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/179
108  */
109 contract ERC20Basic {
110 	uint public totalSupply;
111 	function balanceOf(address who) constant returns (uint);
112 	function transfer(address to, uint value);
113 	event Transfer(address indexed from, address indexed to, uint value);
114 }
115 
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122 	function allowance(address owner, address spender) constant returns (uint);
123 	function transferFrom(address from, address to, uint value);
124 	function approve(address spender, uint value);
125 	event Approval(address indexed owner, address indexed spender, uint value);
126 }
127 
128 
129 /**
130  * @title Basic token
131  * @dev Basic version of StandardToken, with no allowances. 
132  */
133 contract BasicToken is ERC20Basic {
134   
135 	using SafeMath for uint;
136 
137 	mapping(address => uint) balances;
138 
139 	/*
140 	* Fix for the ERC20 short address attack  
141 	*/
142 	modifier onlyPayloadSize(uint size) {
143 	   if(msg.data.length < size + 4) {
144 	     throw;
145 	   }
146 	 _;
147 	}
148 	function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
149 		balances[msg.sender] = balances[msg.sender].sub(_value);
150 		balances[_to] = balances[_to].add(_value);
151 		Transfer(msg.sender, _to, _value);
152 	}
153 	function balanceOf(address _owner) constant returns (uint balance) {
154 		return balances[_owner];
155 	}
156 }
157 
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract StandardToken is BasicToken, ERC20 {
167 	mapping (address => mapping (address => uint)) allowed;
168 	function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
169 		var _allowance = allowed[_from][msg.sender];
170 		balances[_to] = balances[_to].add(_value);
171 		balances[_from] = balances[_from].sub(_value);
172 		allowed[_from][msg.sender] = _allowance.sub(_value);
173 		Transfer(_from, _to, _value);
174     }
175 	function approve(address _spender, uint _value) {
176 		if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
177 		allowed[msg.sender][_spender] = _value;
178 		Approval(msg.sender, _spender, _value);
179 	}
180 	function allowance(address _owner, address _spender) constant returns (uint remaining) {
181 		return allowed[_owner][_spender];
182 	}
183 }
184 
185 
186 /**
187  *  Resilium token contract. Implements
188  */
189 contract Resilium is StandardToken, Ownable {
190   string public constant name = "Resilium";
191   string public constant symbol = "RES";
192   uint public constant decimals = 6;
193 
194 
195   // Constructor
196   function Resilium() {
197       totalSupply = 1000000000000000;
198       balances[msg.sender] = totalSupply; // Send all tokens to owner
199   }
200 
201   /**
202    *  Burn away the specified amount of tokens
203    */
204   function burn(uint _value) onlyOwner returns (bool) {
205     balances[msg.sender] = balances[msg.sender].sub(_value);
206     totalSupply = totalSupply.sub(_value);
207     Transfer(msg.sender, 0x0, _value);
208     return true;
209   }
210 
211 }
212 
213 
214 /**
215  * @title PullPayment
216  * @dev Base contract supporting async send for pull payments. Inherit from this
217  * contract and use asyncSend instead of send.
218  */
219 contract PullPayment {
220 	using SafeMath for uint;
221 
222 	mapping(address => uint) public payments;
223 	event LogRefundETH(address to, uint value);
224 	/**
225 	*  Store sent amount as credit to be pulled, called by payer 
226 	**/
227 	function asyncSend(address dest, uint amount) internal {
228 		payments[dest] = payments[dest].add(amount);
229 	}
230 	// withdraw accumulated balance, called by payee
231 	function withdrawPayments() {
232 		address payee = msg.sender;
233 		uint payment = payments[payee];
234 
235 		if (payment == 0) {
236 			throw;
237 		}
238 		if (this.balance < payment) {
239 		    throw;
240 		}
241 		payments[payee] = 0;
242 		if (!payee.send(payment)) {
243 		    throw;
244 		}
245 		LogRefundETH(payee,payment);
246 	}
247 }
248 
249 
250 /*
251   Crowdsale Smart Contract for the skincoin.org project
252   This smart contract collects ETH, and in return emits Resilium tokens to the backers
253 */
254 contract Crowdsale is Pausable, PullPayment {
255     
256     using SafeMath for uint;
257 
258   	struct Backer {
259 		uint weiReceived; // Amount of Ether given
260 		uint coinSent;
261 	}
262 
263 	/*
264 	* Constants
265 	*/
266 	/* Minimum number of Resilium to sell */
267 	uint public constant MIN_CAP = 10000000000; // 10.000 Resiliums
268 	/* Maximum number of Resilium to sell */
269 	uint public constant MAX_CAP = 100000000000; // 100000 Resiliums
270 	/* Minimum amount to invest */
271 	uint public constant MIN_INVEST_ETHER = 100 finney;
272 	/* Crowdsale period */
273 	uint private constant CROWDSALE_PERIOD = 30 days;
274 	/* Number of Resiliums per Ether */
275 	uint public constant COIN_PER_ETHER = 1000000000; // 1,000 Resiliums
276 
277 
278 	/*
279 	* Variables
280 	*/
281 	/* Resilium contract reference */
282 	Resilium public coin;
283     /* Multisig contract that will receive the Ether */
284 	address public multisigEther;
285 	/* Number of Ether received */
286 	uint public etherReceived;
287 	/* Number of Resiliums sent to Ether contributors */
288 	uint public coinSentToEther;
289 	/* Crowdsale start time */
290 	uint public startTime;
291 	/* Crowdsale end time */
292 	uint public endTime;
293  	/* Is crowdsale still on going */
294 	bool public crowdsaleClosed;
295 
296 	/* Backers Ether indexed by their Ethereum address */
297 	mapping(address => Backer) public backers;
298 
299 
300 	/*
301 	* Modifiers
302 	*/
303 	modifier minCapNotReached() {
304 		if ((now < endTime) || coinSentToEther >= MIN_CAP ) throw;
305 		_;
306 	}
307 
308 	modifier respectTimeFrame() {
309 		if ((now < startTime) || (now > endTime )) throw;
310 		_;
311 	}
312 
313 	/*
314 	 * Event
315 	*/
316 	event LogReceivedETH(address addr, uint value);
317 	event LogCoinsEmited(address indexed from, uint amount);
318 
319 	/*
320 	 * Constructor
321 	*/
322 	function Crowdsale(address _tokenAddress, address _to) {
323 		coin = Resilium(_tokenAddress);
324 		multisigEther = _to;
325 	}
326 
327 	/* 
328 	 * The fallback function corresponds to a donation in ETH
329 	 */
330 	function() stopInEmergency respectTimeFrame payable {
331 		receiveETH(msg.sender);
332 	}
333 
334 	/* 
335 	 * To call to start the crowdsale
336 	 */
337 	function start() onlyOwner {
338 		if (startTime != 0) throw; // Crowdsale was already started
339 
340 		startTime = now ;            
341 		endTime =  now + CROWDSALE_PERIOD;    
342 	}
343 
344 	/*
345 	 *	Receives a donation in Ether
346 	*/
347 	function receiveETH(address beneficiary) internal {
348 		if (msg.value < MIN_INVEST_ETHER) throw; // Don't accept funding under a predefined threshold
349 		
350 		uint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Compute the number of Resilium to send
351 		if (coinToSend.add(coinSentToEther) > MAX_CAP) throw;	
352 
353 		Backer backer = backers[beneficiary];
354 		coin.transfer(beneficiary, coinToSend); // Transfer Resiliums right now 
355 
356 		backer.coinSent = backer.coinSent.add(coinToSend);
357 		backer.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer    
358 
359 		etherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding
360 		coinSentToEther = coinSentToEther.add(coinToSend);
361 
362 		// Send events
363 		LogCoinsEmited(msg.sender ,coinToSend);
364 		LogReceivedETH(beneficiary, etherReceived); 
365 	}
366 	
367 
368 	/*
369 	 *Compute the Resilium bonus according to the investment period
370 	 */
371 	function bonus(uint amount) internal constant returns (uint) {
372 		return amount.add(amount.div(2)); // Bonus pre-ico 50%
373 	}
374 
375 	/*	
376 	 * Finalize the crowdsale, should be called after the refund period
377 	*/
378 	function finalize() onlyOwner public {
379 
380 		if (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all coins
381 			if (coinSentToEther == MAX_CAP) {
382 			} else {
383 				throw;
384 			}
385 		}
386 
387 		if (coinSentToEther < MIN_CAP && now < endTime + 15 days) throw; // If MIN_CAP is not reached donors have 15days to get refund before we can finalise
388 
389 		if (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address
390 		
391 		uint remains = coin.balanceOf(this);
392 		if (remains > 0) { // Burn the rest of Resiliums
393 			if (!coin.burn(remains)) throw ;
394 		}
395 		crowdsaleClosed = true;
396 	}
397 
398 	/*	
399 	* Failsafe drain
400 	*/
401 	function drain() onlyOwner {
402 		if (!owner.send(this.balance)) throw;
403 	}
404 
405 	/**
406 	 * Allow to change the team multisig address in the case of emergency.
407 	 */
408 	function setMultisig(address addr) onlyOwner public {
409 		if (addr == address(0)) throw;
410 		multisigEther = addr;
411 	}
412 
413 	/**
414 	 * Manually back Resilium owner address.
415 	 */
416 	function backResiliumOwner() onlyOwner public {
417 		coin.transferOwnership(owner);
418 	}
419 
420 	/**
421 	 * Transfer remains to owner in case if impossible to do min invest
422 	 */
423 	function getRemainCoins() onlyOwner public {
424 		var remains = MAX_CAP - coinSentToEther;
425 		uint minCoinsToSell = bonus(MIN_INVEST_ETHER.mul(COIN_PER_ETHER) / (1 ether));
426 
427 		if(remains > minCoinsToSell) throw;
428 
429 		Backer backer = backers[owner];
430 		coin.transfer(owner, remains); // Transfer Resiliums right now 
431 
432 		backer.coinSent = backer.coinSent.add(remains);
433 
434 		coinSentToEther = coinSentToEther.add(remains);
435 
436 		// Send events
437 		LogCoinsEmited(this ,remains);
438 		LogReceivedETH(owner, etherReceived); 
439 	}
440 
441 
442 	/* 
443   	 * When MIN_CAP is not reach:
444   	 * 1) backer call the "approve" function of the Resilium token contract with the amount of all Resiliums they got in order to be refund
445   	 * 2) backer call the "refund" function of the Crowdsale contract with the same amount of Resiliums
446    	 * 3) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
447    	 */
448 	function refund(uint _value) minCapNotReached public {
449 		
450 		if (_value != backers[msg.sender].coinSent) throw; // compare value from backer balance
451 
452 		coin.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract
453 
454 		if (!coin.burn(_value)) throw ; // token sent for refund are burnt
455 
456 		uint ETHToSend = backers[msg.sender].weiReceived;
457 		backers[msg.sender].weiReceived=0;
458 
459 		if (ETHToSend > 0) {
460 			asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
461 		}
462 	}
463 
464 }