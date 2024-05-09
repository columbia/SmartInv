1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36   function assert(bool assertion) internal {
37     if (!assertion) {
38       throw;
39     }
40   }
41 }
42 
43 contract Ownable {
44     address public owner;
45 
46     function Ownable() {
47         owner = msg.sender;
48     }
49 
50     modifier onlyOwner {
51         if (msg.sender != owner) throw;
52         _;
53     }
54 
55     function transferOwnership(address newOwner) onlyOwner {
56         if (newOwner != address(0)) {
57             owner = newOwner;
58         }
59     }
60 }
61 
62 /*
63  * Pausable
64  * Abstract contract that allows children to implement an
65  * emergency stop mechanism.
66  */
67 
68 contract Pausable is Ownable {
69   bool public stopped;
70 
71   modifier stopInEmergency {
72     if (stopped) {
73       throw;
74     }
75     _;
76   }
77   
78   modifier onlyInEmergency {
79     if (!stopped) {
80       throw;
81     }
82     _;
83   }
84 
85   // called by the owner on emergency, triggers stopped state
86   function emergencyStop() external onlyOwner {
87     stopped = true;
88   }
89 
90   // called by the owner on end of emergency, returns to normal state
91   function release() external onlyOwner onlyInEmergency {
92     stopped = false;
93   }
94 
95 }
96 
97 
98 contract ERC20Basic {
99   uint public totalSupply;
100   function balanceOf(address who) constant returns (uint);
101   function transfer(address to, uint value);
102   event Transfer(address indexed from, address indexed to, uint value);
103 }
104 
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) constant returns (uint);
107   function transferFrom(address from, address to, uint value);
108   function approve(address spender, uint value);
109   event Approval(address indexed owner, address indexed spender, uint value);
110 }
111 
112 /*
113  * PullPayment
114  * Base contract supporting async send for pull payments.
115  * Inherit from this contract and use asyncSend instead of send.
116  */
117 contract PullPayment {
118 
119   using SafeMath for uint;
120   
121   mapping(address => uint) public payments;
122 
123   event LogRefundETH(address to, uint value);
124 
125 
126   /**
127   *  Store sent amount as credit to be pulled, called by payer 
128   **/
129   function asyncSend(address dest, uint amount) internal {
130     payments[dest] = payments[dest].add(amount);
131   }
132 
133   // withdraw accumulated balance, called by payee
134   function withdrawPayments() {
135     address payee = msg.sender;
136     uint payment = payments[payee];
137     
138     if (payment == 0) {
139       throw;
140     }
141 
142     if (this.balance < payment) {
143       throw;
144     }
145 
146     payments[payee] = 0;
147 
148     if (!payee.send(payment)) {
149       throw;
150     }
151     LogRefundETH(payee,payment);
152   }
153 }
154 
155 
156 contract BasicToken is ERC20Basic {
157   
158   using SafeMath for uint;
159   
160   mapping(address => uint) balances;
161   
162   /*
163    * Fix for the ERC20 short address attack  
164   */
165   modifier onlyPayloadSize(uint size) {
166      if(msg.data.length < size + 4) {
167        throw;
168      }
169      _;
170   }
171 
172   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     Transfer(msg.sender, _to, _value);
176   }
177 
178   function balanceOf(address _owner) constant returns (uint balance) {
179     return balances[_owner];
180   }
181 }
182 
183 
184 contract StandardToken is BasicToken, ERC20 {
185   mapping (address => mapping (address => uint)) allowed;
186 
187   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
188     var _allowance = allowed[_from][msg.sender];
189     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
190     // if (_value > _allowance) throw;
191     balances[_to] = balances[_to].add(_value);
192     balances[_from] = balances[_from].sub(_value);
193     allowed[_from][msg.sender] = _allowance.sub(_value);
194     Transfer(_from, _to, _value);
195   }
196 
197   function approve(address _spender, uint _value) {
198     // To change the approve amount you first have to reduce the addresses`
199     //  allowance to zero by calling `approve(_spender, 0)` if it is not
200     //  already 0 to mitigate the race condition described here:
201     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
203     allowed[msg.sender][_spender] = _value;
204     Approval(msg.sender, _spender, _value);
205   }
206 
207   function allowance(address _owner, address _spender) constant returns (uint remaining) {
208     return allowed[_owner][_spender];
209   }
210 }
211 
212 
213 
214 
215 /**
216  *  Red Pill Token token contract. Implements
217  */
218 contract RedPillToken is StandardToken, Ownable {
219   string public constant name = "RedPill";
220   string public constant symbol = "RPIL";
221   uint public constant decimals = 8;
222 
223 
224   // Constructor
225   function RedPillToken() {
226       totalSupply = 20000000000000000;
227       balances[msg.sender] = totalSupply; // Send all tokens to owner
228   }
229 
230   /**
231    *  Burn away the specified amount of Red Pill Token tokens
232    */
233   function burn(uint _value) onlyOwner returns (bool) {
234     balances[msg.sender] = balances[msg.sender].sub(_value);
235     totalSupply = totalSupply.sub(_value);
236     Transfer(msg.sender, 0x0, _value);
237     return true;
238   }
239 
240 }
241 
242 /*
243   Crowdsale Smart Contract for the RedPillToken.org project
244   This smart contract collects ETH, and in return emits RedPillToken tokens to the backers
245 */
246 contract Crowdsale is Pausable, PullPayment {
247     
248     using SafeMath for uint;
249 
250   	struct Backer {
251 		uint weiReceived; // Amount of Ether given
252 		uint coinSent;
253 	}
254 
255 	/*
256 	* Constants
257 	*/
258 	/* Minimum number of RedPillToken to sell */
259 	/*uint public constant MIN_CAP = 1000000000000000; // 10,000,000 RedPillTokens (10 millions)*/
260  uint public constant MIN_CAP = 0; // no minimum cap
261 	/* Maximum number of RedPillToken to sell */
262 	uint public constant MAX_CAP = 10000000000000000; // 100,000,000 RedPillTokens (100 millions)
263 	/* Minimum amount to invest */
264 	uint public constant MIN_INVEST_ETHER = 40 finney; //0.04 ether
265 	/* Crowdsale period */
266 	uint private constant CROWDSALE_PERIOD = 34 days;
267  /*uint private constant CROWDSALE_PERIOD = 1 seconds;*/
268 	/* Number of RedPillTokens per Ether */
269 	uint public constant COIN_PER_ETHER = 536100000000; // 5,361 RedPillTokens  1 eth=5361 RedPillTokens
270                                         
271 
272 	/*
273 	* Variables
274 	*/
275 	/* RedPillToken contract reference */
276 	RedPillToken public coin;
277     /* Multisig contract that will receive the Ether */
278 	address public multisigEther;
279 	/* Number of Ether received */
280 	uint public etherReceived;
281 	/* Number of RedPillTokens sent to Ether contributors */
282 	uint public coinSentToEther;
283 	/* Crowdsale start time */
284 	uint public startTime;
285 	/* Crowdsale end time */
286 	uint public endTime;
287  	/* Is crowdsale still on going */
288 	bool public crowdsaleClosed;
289 
290 	/* Backers Ether indexed by their Ethereum address */
291 	mapping(address => Backer) public backers;
292 
293 
294 	/*
295 	* Modifiers
296 	*/
297 	modifier minCapNotReached() {
298 		if ((now < endTime) || coinSentToEther >= MIN_CAP ) throw;
299 		_;
300 	}
301 
302 	modifier respectTimeFrame() {
303 		if ((now < startTime) || (now > endTime )) throw;
304 		_;
305 	}
306 
307 	/*
308 	 * Event
309 	*/
310 	event LogReceivedETH(address addr, uint value);
311 	event LogCoinsEmited(address indexed from, uint amount);
312 
313 	/*
314 	 * Constructor
315 	*/
316 	function Crowdsale(address _RedPillTokenAddress, address _to) {
317 		coin = RedPillToken(_RedPillTokenAddress);
318 		multisigEther = _to;
319 	}
320 
321 	/* 
322 	 * The fallback function corresponds to a donation in ETH
323 	 */
324 	function() stopInEmergency respectTimeFrame payable {
325 		receiveETH(msg.sender);
326 	}
327 
328 	/* 
329 	 * To call to start the crowdsale
330 	 */
331 	function start() onlyOwner {
332 		if (startTime != 0) throw; // Crowdsale was already started
333 
334 		/*startTime = now ;*/           
335 		/*endTime =  now + CROWDSALE_PERIOD; */   
336    
337   startTime = 1506484800;            
338   endTime =  1506484800 + CROWDSALE_PERIOD;   
339    
340 	}
341 
342 	/*
343 	 *	Receives a donation in Ether
344 	*/
345 	function receiveETH(address beneficiary) internal {
346 		if (msg.value < MIN_INVEST_ETHER) throw; // Don't accept funding under a predefined threshold
347 		
348 		uint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Compute the number of RedPillToken to send
349 		if (coinToSend.add(coinSentToEther) > MAX_CAP) throw;	
350 
351 		Backer backer = backers[beneficiary];
352 		coin.transfer(beneficiary, coinToSend); // Transfer RedPillTokens right now 
353 
354 		backer.coinSent = backer.coinSent.add(coinToSend);
355 		backer.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer    
356 
357 		etherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding
358 		coinSentToEther = coinSentToEther.add(coinToSend);
359 
360 		// Send events
361 		LogCoinsEmited(msg.sender ,coinToSend);
362 		LogReceivedETH(beneficiary, etherReceived); 
363 	}
364 	
365 
366 	/*
367 	 *Compute the RedPillToken bonus according to the investment period
368 	 */
369 	function bonus(uint amount) internal constant returns (uint) {
370 		/*if (now < startTime.add(2 days)) return amount.add(amount.div(5)); */   // bonus 20%
371 		return amount;
372 	}
373 
374 	/*	
375 	 * Finalize the crowdsale, should be called after the refund period
376 	*/
377 	function finalize() onlyOwner public {
378 
379 		if (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all coins
380 			if (coinSentToEther == MAX_CAP) {
381 			} else {
382 				throw;
383 			}
384 		}
385 
386 		if (coinSentToEther < MIN_CAP && now < endTime + 15 days) throw; // If MIN_CAP is not reached donors have 15days to get refund before we can finalise
387 
388 		if (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address
389 		
390 		uint remains = coin.balanceOf(this);
391 		if (remains > 0) { // Burn the rest of RedPillTokens
392 			if (!coin.burn(remains)) throw ;
393 		}
394 		crowdsaleClosed = true;
395 	}
396 
397 	/*	
398 	* Failsafe drain
399 	*/
400 	function drain() onlyOwner {
401 		if (!owner.send(this.balance)) throw;
402 	}
403 
404 	/**
405 	 * Allow to change the team multisig address in the case of emergency.
406 	 */
407 	function setMultisig(address addr) onlyOwner public {
408 		if (addr == address(0)) throw;
409 		multisigEther = addr;
410 	}
411 
412 	/**
413 	 * Manually back RedPillToken owner address.
414 	 */
415 	function backRedPillTokenOwner() onlyOwner public {
416 		coin.transferOwnership(owner);
417 	}
418 
419 	/**
420 	 * Transfer remains to owner in case if impossible to do min invest
421 	 */
422 	function getRemainCoins() onlyOwner public {
423 		var remains = MAX_CAP - coinSentToEther;
424 		uint minCoinsToSell = bonus(MIN_INVEST_ETHER.mul(COIN_PER_ETHER) / (1 ether));
425 
426 		if(remains > minCoinsToSell) throw;
427 
428 		Backer backer = backers[owner];
429 		coin.transfer(owner, remains); // Transfer RedPillTokens right now 
430 
431 		backer.coinSent = backer.coinSent.add(remains);
432 
433 		coinSentToEther = coinSentToEther.add(remains);
434 
435 		// Send events
436 		LogCoinsEmited(this ,remains);
437 		LogReceivedETH(owner, etherReceived); 
438 	}
439 
440 
441 	/* 
442   	 * When MIN_CAP is not reach:
443   	 * 1) backer call the "approve" function of the RedPillToken token contract with the amount of all RedPillTokens they got in order to be refund
444   	 * 2) backer call the "refund" function of the Crowdsale contract with the same amount of RedPillTokens
445    	 * 3) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
446    	 */
447 	function refund(uint _value) minCapNotReached public {
448 		
449 		if (_value != backers[msg.sender].coinSent) throw; // compare value from backer balance
450 
451 		coin.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract
452 
453 		if (!coin.burn(_value)) throw ; // token sent for refund are burnt
454 
455 		uint ETHToSend = backers[msg.sender].weiReceived;
456 		backers[msg.sender].weiReceived=0;
457 
458 		if (ETHToSend > 0) {
459 			asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
460 		}
461 	}
462 
463 }