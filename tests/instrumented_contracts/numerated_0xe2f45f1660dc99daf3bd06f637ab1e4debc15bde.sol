1 pragma solidity ^0.4.11;
2 library SafeMath {
3   function mul(uint a, uint b) internal returns (uint) {
4     uint c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function div(uint a, uint b) internal returns (uint) {
9     assert(b > 0);
10     uint c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14   function sub(uint a, uint b) internal returns (uint) {
15     assert(b <= a);
16     return a - b;
17   }
18   function add(uint a, uint b) internal returns (uint) {
19     uint c = a + b;
20     assert(c >= a);
21     return c;
22   }
23   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
24     return a >= b ? a : b;
25   }
26   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
27     return a < b ? a : b;
28   }
29   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
30     return a >= b ? a : b;
31   }
32   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
33     return a < b ? a : b;
34   }
35   function assert(bool assertion) internal {
36     if (!assertion) {
37       throw;
38     }
39   }
40 }
41 contract Ownable {
42     address public owner;
43 
44     function Ownable() {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         if (msg.sender != owner) throw;
50         _;
51     }
52 
53     function transferOwnership(address newOwner) onlyOwner {
54         if (newOwner != address(0)) {
55             owner = newOwner;
56         }
57     }
58 }
59 contract Pausable is Ownable {
60   bool public stopped;
61 
62   modifier stopInEmergency {
63     if (stopped) {
64       throw;
65     }
66     _;
67   }
68   modifier onlyInEmergency {
69     if (!stopped) {
70       throw;
71     }
72     _;
73   }
74 
75   // called by the owner on emergency, triggers stopped state
76   function emergencyStop() external onlyOwner {
77     stopped = true;
78   }
79 
80   // called by the owner on end of emergency, returns to normal state
81   function release() external onlyOwner onlyInEmergency {
82     stopped = false;
83   }
84 
85 }
86 contract ERC20Basic {
87   uint public totalSupply;
88   function balanceOf(address who) constant returns (uint);
89   function transfer(address to, uint value);
90   event Transfer(address indexed from, address indexed to, uint value);
91 }
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) constant returns (uint);
94   function transferFrom(address from, address to, uint value);
95   function approve(address spender, uint value);
96   event Approval(address indexed owner, address indexed spender, uint value);
97 }
98 contract PullPayment {
99 
100   using SafeMath for uint;
101 
102   mapping(address => uint) public payments;
103 
104   event LogRefundETH(address to, uint value);
105 
106 
107   /**
108   *  Store sent amount as credit to be pulled, called by payer
109   **/
110   function asyncSend(address dest, uint amount) internal {
111     payments[dest] = payments[dest].add(amount);
112   }
113 
114   // withdraw accumulated balance, called by payee
115   function withdrawPayments() {
116     address payee = msg.sender;
117     uint payment = payments[payee];
118 
119     if (payment == 0) {
120       throw;
121     }
122 
123     if (this.balance < payment) {
124       throw;
125     }
126 
127     payments[payee] = 0;
128 
129     if (!payee.send(payment)) {
130       throw;
131     }
132     LogRefundETH(payee,payment);
133   }
134 }
135 contract BasicToken is ERC20Basic {
136 
137   using SafeMath for uint;
138 
139   mapping(address => uint) balances;
140 
141   /*
142    * Fix for the ERC20 short address attack
143   */
144   modifier onlyPayloadSize(uint size) {
145      if(msg.data.length < size + 4) {
146        throw;
147      }
148      _;
149   }
150 
151   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
152     balances[msg.sender] = balances[msg.sender].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     Transfer(msg.sender, _to, _value);
155   }
156 
157   function balanceOf(address _owner) constant returns (uint balance) {
158     return balances[_owner];
159   }
160 }
161 contract StandardToken is BasicToken, ERC20 {
162   mapping (address => mapping (address => uint)) allowed;
163 
164   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
165     var _allowance = allowed[_from][msg.sender];
166     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
167     // if (_value > _allowance) throw;
168     balances[_to] = balances[_to].add(_value);
169     balances[_from] = balances[_from].sub(_value);
170     allowed[_from][msg.sender] = _allowance.sub(_value);
171     Transfer(_from, _to, _value);
172   }
173   function approve(address _spender, uint _value) {
174     // To change the approve amount you first have to reduce the addresses`
175     //  allowance to zero by calling `approve(_spender, 0)` if it is not
176     //  already 0 to mitigate the race condition described here:
177     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
179     allowed[msg.sender][_spender] = _value;
180     Approval(msg.sender, _spender, _value);
181   }
182 
183   function allowance(address _owner, address _spender) constant returns (uint remaining) {
184     return allowed[_owner][_spender];
185   }
186 }
187 contract SggCoin is StandardToken, Ownable {
188   string public constant name = "SggCoin";
189   string public constant symbol = "SGG";
190   uint public constant decimals = 6;
191 
192 
193   // Constructor
194   function SggCoin() {
195       totalSupply = 1000000000000000;     // one billion
196       balances[msg.sender] = totalSupply; // Send all tokens to owner
197   }
198 
199   /**
200    *  Burn away the specified amount of SggCoin tokens
201    */
202   function burn(uint _value) onlyOwner returns (bool) {
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204     totalSupply = totalSupply.sub(_value);
205     Transfer(msg.sender, 0x0, _value);
206     return true;
207   }
208 
209 }
210 /*
211   Crowdsale Smart Contract for the StuffGoGo Project
212   Created and deployed by DAAPPS company
213   This smart contract collects ETH, and in return emits SggCoin tokens to the backers
214 */
215 contract Crowdsale is Pausable, PullPayment {
216 
217     using SafeMath for uint;
218 
219   	struct Backer {
220 		uint weiReceived; // Amount of Ether given
221 		uint coinSent;
222 	}
223 
224 	/*
225 	* Constants
226 	*/
227 	uint public constant MIN_CAP = 5000000000;           // min: 5,000 SggCoins = 1 eth
228 	uint public constant MAX_CAP = 500000000000000;      // max: 500,000,000 SggCoins = 100000 eth
229 	uint public constant MIN_INVEST_ETHER = 100 finney;  // 0.1 eth
230 	uint private constant CROWDSALE_PERIOD = 28 days;    // 4 weeks
231 	uint public constant COIN_PER_ETHER = 5000000000;    // 5,000 SggCoins/ETH
232 
233 
234 	/*
235 	* Variables
236 	*/
237 	/* SggCoin contract reference */
238 	SggCoin public coin;
239     /* Multisig contract that will receive the Ether */
240 	address public multisigEther;
241 	/* Number of Ether received */
242 	uint public etherReceived;
243 	/* Number of SggCoins sent to Ether contributors */
244 	uint public coinSentToEther;
245 	/* Crowdsale start time */
246 	uint public startTime;
247 	/* Crowdsale end time */
248 	uint public endTime;
249  	/* Is crowdsale still on going */
250 	bool public crowdsaleClosed;
251 
252 	/* Backers Ether indexed by their Ethereum address */
253 	mapping(address => Backer) public backers;
254 
255 
256 	/*
257 	* Modifiers
258 	*/
259 	modifier minCapNotReached() {
260 		if ((now < endTime) || coinSentToEther >= MIN_CAP ) throw;
261 		_;
262 	}
263 
264 	modifier respectTimeFrame() {
265 		if ((now < startTime) || (now > endTime )) throw;
266 		_;
267 	}
268 
269 	/*
270 	 * Event
271 	*/
272 	event LogReceivedETH(address addr, uint value);
273 	event LogCoinsEmited(address indexed from, uint amount);
274 
275 	/*
276 	 * Constructor
277 	*/
278 	function Crowdsale(address _SggCoinAddress, address _to) {
279 		coin = SggCoin(_SggCoinAddress);
280 		multisigEther = _to;
281 	}
282 
283 	/*
284 	 * The fallback function corresponds to a donation in ETH
285 	 */
286 	function() stopInEmergency respectTimeFrame payable {
287 		receiveETH(msg.sender);
288 	}
289 
290 	/*
291 	 * To call to start the crowdsale
292 	 */
293 	function start() onlyOwner {
294 		if (startTime != 0) throw; // Crowdsale was already started
295 
296 		startTime = now ;
297 		endTime =  now + CROWDSALE_PERIOD;
298 	}
299 
300 	/*
301 	 *	Receives a donation in Ether
302 	*/
303 	function receiveETH(address beneficiary) internal {
304 		if (msg.value < MIN_INVEST_ETHER) throw; // Don't accept funding under a predefined threshold
305 
306 		uint coinToSend = bonus(msg.value.mul(COIN_PER_ETHER).div(1 ether)); // Compute the number of SggCoin to send
307 		if (coinToSend.add(coinSentToEther) > MAX_CAP) throw;
308 
309 		Backer backer = backers[beneficiary];
310 		coin.transfer(beneficiary, coinToSend); // Transfer SggCoins right now
311 
312 		backer.coinSent = backer.coinSent.add(coinToSend);
313 		backer.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer
314 
315 		etherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding
316 		coinSentToEther = coinSentToEther.add(coinToSend);
317 
318 		// Send events
319 		LogCoinsEmited(msg.sender ,coinToSend);
320 		LogReceivedETH(beneficiary, etherReceived);
321 	}
322 
323 
324 	/*
325 	 *Compute the SggCoin bonus according to the investment period
326 	 */
327 	function bonus(uint amount) internal constant returns (uint) {
328 		if (now < startTime.add(2 days)) return amount.add(amount.div(5));   // bonus 20%
329 		return amount;
330 	}
331 
332 	/*
333 	 * Finalize the crowdsale, should be called after the refund period
334 	*/
335 	function finalize() onlyOwner public {
336 
337 		if (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all coins
338 			if (coinSentToEther == MAX_CAP) {
339 			} else {
340 				throw;
341 			}
342 		}
343 
344 		if (coinSentToEther < MIN_CAP && now < endTime + 15 days) throw; // If MIN_CAP is not reached donors have 15days to get refund before we can finalise
345 
346 		if (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address
347 
348 		uint remains = coin.balanceOf(this);
349 		if (remains > 0) { // Burn the rest of SggCoins
350 			if (!coin.burn(remains)) throw ;
351 		}
352 		crowdsaleClosed = true;
353 	}
354 
355 	/*
356 	* Failsafe drain
357 	*/
358 	function drain() onlyOwner {
359 		if (!owner.send(this.balance)) throw;
360 	}
361 
362 	/**
363 	 * Allow to change the team multisig address in the case of emergency.
364 	 */
365 	function setMultisig(address addr) onlyOwner public {
366 		if (addr == address(0)) throw;
367 		multisigEther = addr;
368 	}
369 
370 	/**
371 	 * Manually back SggCoin owner address.
372 	 */
373 	function backSggCoinOwner() onlyOwner public {
374 		coin.transferOwnership(owner);
375 	}
376 
377 	/**
378 	 * Transfer remains to owner in case if impossible to do min invest
379 	 */
380 	function getRemainCoins() onlyOwner public {
381 		var remains = MAX_CAP - coinSentToEther;
382 		uint minCoinsToSell = bonus(MIN_INVEST_ETHER.mul(COIN_PER_ETHER) / (1 ether));
383 
384 		if(remains > minCoinsToSell) throw;
385 
386 		Backer backer = backers[owner];
387 		coin.transfer(owner, remains); // Transfer SggCoins right now
388 
389 		backer.coinSent = backer.coinSent.add(remains);
390 
391 		coinSentToEther = coinSentToEther.add(remains);
392 
393 		// Send events
394 		LogCoinsEmited(this ,remains);
395 		LogReceivedETH(owner, etherReceived);
396 	}
397 
398 
399 	/*
400   	 * When MIN_CAP is not reach:
401   	 * 1) backer call the "approve" function of the SggCoin token contract with the amount of all SggCoins they got in order to be refund
402   	 * 2) backer call the "refund" function of the Crowdsale contract with the same amount of SggCoins
403    	 * 3) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
404    	 */
405 	function refund(uint _value) minCapNotReached public {
406 
407 		if (_value != backers[msg.sender].coinSent) throw; // compare value from backer balance
408 
409 		coin.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract
410 
411 		if (!coin.burn(_value)) throw ; // token sent for refund are burnt
412 
413 		uint ETHToSend = backers[msg.sender].weiReceived;
414 		backers[msg.sender].weiReceived=0;
415 
416 		if (ETHToSend > 0) {
417 			asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
418 		}
419 	}
420 
421 }