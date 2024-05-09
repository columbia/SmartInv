1 pragma solidity ^0.4.15;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 
35 }
36 
37 contract Pausable is Ownable {
38   bool public stopped;
39 
40   modifier stopInEmergency {
41     require(!stopped);
42     _;
43   }
44   
45   modifier onlyInEmergency {
46     require(stopped);
47     _;
48   }
49 
50   // called by the owner on emergency, triggers stopped state
51   function emergencyStop() external onlyOwner {
52     stopped = true;
53   }
54 
55   // called by the owner on end of emergency, returns to normal state
56   function release() external onlyOwner onlyInEmergency {
57     stopped = false;
58   }
59 
60 }
61 
62 library SafeMath {
63   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a * b;
65     assert(a == 0 || c / a == b);
66     return c;
67   }
68 
69   function div(uint256 a, uint256 b) internal constant returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75 
76   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   function add(uint256 a, uint256 b) internal constant returns (uint256) {
82     uint256 c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 }
87 
88 contract PullPayment {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) public payments;
92   uint256 public totalPayments;
93 
94   /**
95   * @dev Called by the payer to store the sent amount as credit to be pulled.
96   * @param dest The destination address of the funds.
97   * @param amount The amount to transfer.
98   */
99   function asyncSend(address dest, uint256 amount) internal {
100     payments[dest] = payments[dest].add(amount);
101     totalPayments = totalPayments.add(amount);
102   }
103 
104   /**
105   * @dev withdraw accumulated balance, called by payee.
106   */
107   function withdrawPayments() {
108     address payee = msg.sender;
109     uint256 payment = payments[payee];
110 
111     require(payment != 0);
112     require(this.balance >= payment);
113 
114     totalPayments = totalPayments.sub(payment);
115     payments[payee] = 0;
116 
117     assert(payee.send(payment));
118   }
119 }
120 
121 contract Crowdsale is Pausable, PullPayment {
122 
123     using SafeMath for uint;
124 
125   	struct Backer {
126 		uint weiReceived; // Amount of Ether given
127 		uint256 coinSent;
128 	}
129 
130 
131 	/*
132 	* Constants
133 	*/
134 	/* Minimum number of DARFtoken to sell */
135 	uint public constant MIN_CAP = 100000 ether; // 100,000 DARFtokens
136 
137 	/* Maximum number of DARFtoken to sell */
138 	uint public constant MAX_CAP = 8000000 ether; // 8,000,000 DARFtokens
139 
140 	/* Minimum amount to BUY */
141 	uint public constant MIN_BUY_ETHER = 100 finney;
142 
143     /*
144     If backer buy over 1 000 000 DARF (2000 Ether) he/she can clame to become an investor after signing additional agreement with KYC procedure and get 1% of project profit per every 1 000 000 DARF
145     */
146     struct Potential_Investor {
147 		uint weiReceived; // Amount of Ether given
148 		uint256 coinSent;
149         uint  profitshare; // Amount of Ether given
150     }
151     uint public constant MIN_INVEST_BUY = 2000 ether;
152 
153     /* But only 49%  of profit can be distributed this way for bakers who will be first
154     */
155 
156     uint  public  MAX_INVEST_SHARE = 4900; //  4900 from 10000 is 49%, becouse Soliditi stil don't support fixed
157 
158 /* Crowdsale period */
159 	uint private constant CROWDSALE_PERIOD = 62 days;
160 
161 	/* Number of DARFtokens per Ether */
162 	uint public constant COIN_PER_ETHER = 500; // 500 DARF per ether
163 
164 	uint public constant BIGSELL = COIN_PER_ETHER * 100 ether; // when 1 buy is over 50000 DARF (or 100 ether), in means additional bonus 30%
165 
166 
167 	/*
168 	* Variables
169 	*/
170 	/* DARFtoken contract reference */
171 	DARFtoken public coin;
172 
173     /* Multisig contract that will receive the Ether */
174 	address public multisigEther;
175 
176 	/* Number of Ether received */
177 	uint public etherReceived;
178 
179 	/* Number of DARFtokens sent to Ether contributors */
180 	uint public coinSentToEther;
181 
182 	/* Number of DARFtokens sent to potential investors */
183 	uint public invcoinSentToEther;
184 
185 
186 	/* Crowdsale start time */
187 	uint public startTime;
188 
189 	/* Crowdsale end time */
190 	uint public endTime;
191 
192  	/* Is crowdsale still on going */
193 	bool public crowdsaleClosed;
194 
195 	/* Backers Ether indexed by their Ethereum address */
196 	mapping(address => Backer) public backers;
197 
198     mapping(address => Potential_Investor) public Potential_Investors; // list of potential investors
199 
200 
201 	/*
202 	* Modifiers
203 	*/
204 	modifier minCapNotReached() {
205 		require(!((now < endTime) || coinSentToEther >= MIN_CAP ));
206 		_;
207 	}
208 
209 	modifier respectTimeFrame() {
210 		require(!((now < startTime) || (now > endTime )));
211 		_;
212 	}
213 
214 	/*
215 	 * Event
216 	*/
217 	event LogReceivedETH(address addr, uint value);
218 	event LogCoinsEmited(address indexed from, uint amount);
219 	event LogInvestshare(address indexed from, uint share);
220 
221 	/*
222 	 * Constructor
223 	*/
224 	function Crowdsale(address _DARFtokenAddress, address _to) {
225 		coin = DARFtoken(_DARFtokenAddress);
226 		multisigEther = _to;
227 	}
228 
229 	/*
230 	 * The fallback function corresponds to a donation in ETH
231 	 */
232 	function() stopInEmergency respectTimeFrame payable {
233 		receiveETH(msg.sender);
234 	}
235 
236 	/*
237 	 * To call to start the crowdsale
238 	 */
239 	function start() onlyOwner {
240 		require (startTime == 0);
241 
242 		startTime = now ;
243 		endTime =  now + CROWDSALE_PERIOD;
244 	}
245 
246 	/*
247 	 *	Receives a donation in Ether
248 	*/
249 	function receiveETH(address beneficiary) internal {
250 		require(!(msg.value < MIN_BUY_ETHER)); // Don't accept funding under a predefined threshold
251         if (multisigEther ==  beneficiary) return ; // Don't pay tokens if team refund ethers
252     uint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER));// Compute the number of DARFtoken to send
253 		require(!(coinToSend.add(coinSentToEther) > MAX_CAP));
254 
255         Backer backer = backers[beneficiary];
256 		coin.transfer(beneficiary, coinToSend); // Transfer DARFtokens right now
257 
258 		backer.coinSent = backer.coinSent.add(coinToSend);
259 		backer.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer
260         multisigEther.send(msg.value);
261 
262         if (backer.weiReceived > MIN_INVEST_BUY) {
263 
264             // calculate profit share
265             uint share = msg.value.mul(10000).div(MIN_INVEST_BUY); // 100 = 1% from 10000
266 			// compare to all profit share will LT 49%
267 			LogInvestshare(msg.sender,share);
268 			if (MAX_INVEST_SHARE > share) {
269 
270 				Potential_Investor potential_investor = Potential_Investors[beneficiary];
271 				potential_investor.coinSent = backer.coinSent;
272 				potential_investor.weiReceived = backer.weiReceived; // Update the total wei collected during the crowdfunding for this potential investor
273                 // add share to potential_investor
274 				if (potential_investor.profitshare == 0 ) {
275 					uint startshare = potential_investor.weiReceived.mul(10000).div(MIN_INVEST_BUY);
276 					MAX_INVEST_SHARE = MAX_INVEST_SHARE.sub(startshare);
277 					potential_investor.profitshare = potential_investor.profitshare.add(startshare);
278 				} else {
279 					MAX_INVEST_SHARE = MAX_INVEST_SHARE.sub(share);
280 					potential_investor.profitshare = potential_investor.profitshare.add(share);
281 					LogInvestshare(msg.sender,potential_investor.profitshare);
282 
283 				}
284             }
285 
286         }
287 
288 		etherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding
289 		coinSentToEther = coinSentToEther.add(coinToSend);
290 
291 		// Send events
292 		LogCoinsEmited(msg.sender ,coinToSend);
293 		LogReceivedETH(beneficiary, etherReceived);
294 	}
295 
296 
297 	/*
298 	 *Compute the DARFtoken bonus according to the BUYment period
299 	 */
300 	function bonus(uint256 amount) internal constant returns (uint256) {
301 		/*
302 			25%in the first 15 days
303 			20% 16 days 18 days
304 			15% 19 days 21 days
305 			10% 22 days 24 days
306 			5% from 25 days to 27 days
307 			0% from 28 days to 42 days
308 
309 			*/
310 
311 		if (amount >=  BIGSELL ) {
312 				amount = amount.add(amount.div(10).mul(3));
313 		}// bonus 30% to buying  over 50000 DARF
314 		if (now < startTime.add(16 days)) return amount.add(amount.div(4));   // bonus 25%
315 		if (now < startTime.add(18 days)) return amount.add(amount.div(5));   // bonus 20%
316 		if (now < startTime.add(22 days)) return amount.add(amount.div(20).mul(3));   // bonus 15%
317 		if (now < startTime.add(25 days)) return amount.add(amount.div(10));   // bonus 10%
318 		if (now < startTime.add(28 days)) return amount.add(amount.div(20));   // bonus 5
319 
320 
321 		return amount;
322 	}
323 
324 /*
325  * Finalize the crowdsale, should be called after the refund period
326 */
327 	function finalize() onlyOwner public {
328 
329 		if (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all coins
330 			require (coinSentToEther == MAX_CAP);
331 		}
332 
333 		require(!(coinSentToEther < MIN_CAP && now < endTime + 15 days)); // If MIN_CAP is not reached donors have 15days to get refund before we can finalise
334 
335 		require(multisigEther.send(this.balance)); // Move the remaining Ether to the multisig address
336 
337 		uint remains = coin.balanceOf(this);
338 		// No burn all of my precisiossss!
339 		// if (remains > 0) { // Burn the rest of DARFtokens
340 		//	require(coin.burn(remains)) ;
341 		//}
342 		crowdsaleClosed = true;
343 	}
344 
345 	/*
346 	* Failsafe drain
347 	*/
348 	function drain() onlyOwner {
349 		require(owner.send(this.balance)) ;
350 	}
351 
352 	/**
353 	 * Allow to change the team multisig address in the case of emergency.
354 	 */
355 	function setMultisig(address addr) onlyOwner public {
356 		require(addr != address(0)) ;
357 		multisigEther = addr;
358 	}
359 
360 	/**
361 	 * Manually back DARFtoken owner address.
362 	 */
363 	function backDARFtokenOwner() onlyOwner public {
364 		coin.transferOwnership(owner);
365 	}
366 
367 	/**
368 	 * Transfer remains to owner in case if impossible to do min BUY
369 	 */
370 	function getRemainCoins() onlyOwner public {
371 		var remains = MAX_CAP - coinSentToEther;
372 		uint minCoinsToSell = bonus(MIN_BUY_ETHER.mul(COIN_PER_ETHER) / (1 ether));
373 
374 		require(!(remains > minCoinsToSell));
375 
376 		Backer backer = backers[owner];
377 		coin.transfer(owner, remains); // Transfer DARFtokens right now
378 
379 		backer.coinSent = backer.coinSent.add(remains);
380 
381 
382         coinSentToEther = coinSentToEther.add(remains);
383 
384 		// Send events
385 		LogCoinsEmited(this ,remains);
386 		LogReceivedETH(owner, etherReceived);
387 	}
388 
389 
390 	/*
391   	 * When MIN_CAP is not reach:
392   	 * 1) backer call the "approve" function of the DARFtoken token contract with the amount of all DARFtokens they got in order to be refund
393   	 * 2) backer call the "refund" function of the Crowdsale contract with the same amount of DARFtokens
394    	 * 3) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
395    	 */
396 	function refund(uint _value) minCapNotReached public {
397 
398 		require (_value == backers[msg.sender].coinSent) ; // compare value from backer balance
399 
400 		coin.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract
401 		// No burn all of my precisiossss!
402 		//require (coin.burn(_value)); // token sent for refund are burnt
403 
404 		uint ETHToSend = backers[msg.sender].weiReceived;
405 		backers[msg.sender].weiReceived=0;
406 
407 		if (ETHToSend > 0) {
408 			asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
409 		}
410 	}
411 
412 }
413 
414 contract ERC20Basic {
415   uint256 public totalSupply;
416   function balanceOf(address who) constant returns (uint256);
417   function transfer(address to, uint256 value) returns (bool);
418   event Transfer(address indexed from, address indexed to, uint256 value);
419 }
420 
421 contract BasicToken is ERC20Basic {
422   using SafeMath for uint256;
423 
424   mapping(address => uint256) balances;
425 
426   /**
427   * @dev transfer token for a specified address
428   * @param _to The address to transfer to.
429   * @param _value The amount to be transferred.
430   */
431   function transfer(address _to, uint256 _value) returns (bool) {
432     balances[msg.sender] = balances[msg.sender].sub(_value);
433     balances[_to] = balances[_to].add(_value);
434     Transfer(msg.sender, _to, _value);
435     return true;
436   }
437 
438   /**
439   * @dev Gets the balance of the specified address.
440   * @param _owner The address to query the the balance of. 
441   * @return An uint256 representing the amount owned by the passed address.
442   */
443   function balanceOf(address _owner) constant returns (uint256 balance) {
444     return balances[_owner];
445   }
446 
447 }
448 
449 contract ERC20 is ERC20Basic {
450   function allowance(address owner, address spender) constant returns (uint256);
451   function transferFrom(address from, address to, uint256 value) returns (bool);
452   function approve(address spender, uint256 value) returns (bool);
453   event Approval(address indexed owner, address indexed spender, uint256 value);
454 }
455 
456 contract StandardToken is ERC20, BasicToken {
457 
458   mapping (address => mapping (address => uint256)) allowed;
459 
460 
461   /**
462    * @dev Transfer tokens from one address to another
463    * @param _from address The address which you want to send tokens from
464    * @param _to address The address which you want to transfer to
465    * @param _value uint256 the amout of tokens to be transfered
466    */
467   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
468     var _allowance = allowed[_from][msg.sender];
469 
470     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
471     // require (_value <= _allowance);
472 
473     balances[_to] = balances[_to].add(_value);
474     balances[_from] = balances[_from].sub(_value);
475     allowed[_from][msg.sender] = _allowance.sub(_value);
476     Transfer(_from, _to, _value);
477     return true;
478   }
479 
480   /**
481    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
482    * @param _spender The address which will spend the funds.
483    * @param _value The amount of tokens to be spent.
484    */
485   function approve(address _spender, uint256 _value) returns (bool) {
486 
487     // To change the approve amount you first have to reduce the addresses`
488     //  allowance to zero by calling `approve(_spender, 0)` if it is not
489     //  already 0 to mitigate the race condition described here:
490     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
491     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
492 
493     allowed[msg.sender][_spender] = _value;
494     Approval(msg.sender, _spender, _value);
495     return true;
496   }
497 
498   /**
499    * @dev Function to check the amount of tokens that an owner allowed to a spender.
500    * @param _owner address The address which owns the funds.
501    * @param _spender address The address which will spend the funds.
502    * @return A uint256 specifing the amount of tokens still avaible for the spender.
503    */
504   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
505     return allowed[_owner][_spender];
506   }
507 
508 }
509 
510 contract DARFtoken is StandardToken, Ownable {
511   string public constant name = "DARFtoken";
512   string public constant symbol = "DAR";
513   uint public constant decimals = 18;
514 
515 
516   // Constructor
517   function DARFtoken() {
518       totalSupply = 84000000 ether; // to make right number  84 000 000
519       balances[msg.sender] = totalSupply; // Send all tokens to owner
520   }
521 
522   /**
523    *  Burn away the specified amount of DARFtoken tokens
524    */
525   function burn(uint _value) onlyOwner returns (bool) {
526     balances[msg.sender] = balances[msg.sender].sub(_value);
527     totalSupply = totalSupply.sub(_value);
528     Transfer(msg.sender, 0x0, _value);
529     return true;
530   }
531 
532 }