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
43     function Ownable() {
44         owner = msg.sender;
45     }
46     modifier onlyOwner {
47         if (msg.sender != owner) throw;
48         _;
49     }
50     function transferOwnership(address newOwner) onlyOwner {
51         if (newOwner != address(0)) {
52             owner = newOwner;
53         }
54     }
55 }
56 /*
57  * Pausable
58  * Abstract contract that allows children to implement an
59  * emergency stop mechanism.
60  */
61 contract Pausable is Ownable {
62   bool public stopped;
63   modifier stopInEmergency {
64     if (stopped) {
65       throw;
66     }
67     _;
68   }
69 
70   modifier onlyInEmergency {
71     if (!stopped) {
72       throw;
73     }
74     _;
75   }
76   // called by the owner on emergency, triggers stopped state
77   function emergencyStop() external onlyOwner {
78     stopped = true;
79   }
80   // called by the owner on end of emergency, returns to normal state
81   function release() external onlyOwner onlyInEmergency {
82     stopped = false;
83   }
84 }
85 contract ERC20Basic {
86   uint public totalSupply;
87   function balanceOf(address who) constant returns (uint);
88   function transfer(address to, uint value);
89   event Transfer(address indexed from, address indexed to, uint value);
90 }
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) constant returns (uint);
93   function transferFrom(address from, address to, uint value);
94   function approve(address spender, uint value);
95   event Approval(address indexed owner, address indexed spender, uint value);
96 }
97 /*
98  * PullPayment
99  * Base contract supporting async send for pull payments.
100  * Inherit from this contract and use asyncSend instead of send.
101  */
102 contract PullPayment {
103   using SafeMath for uint;
104 
105   mapping(address => uint) public payments;
106   event LogRefundETH(address to, uint value);
107   /**
108   *  Store sent amount as credit to be pulled, called by payer
109   **/
110   function asyncSend(address dest, uint amount) internal {
111     payments[dest] = payments[dest].add(amount);
112   }
113   // withdraw accumulated balance, called by payee
114   function withdrawPayments() {
115     address payee = msg.sender;
116     uint payment = payments[payee];
117 
118     if (payment == 0) {
119       throw;
120     }
121     if (this.balance < payment) {
122       throw;
123     }
124     payments[payee] = 0;
125     if (!payee.send(payment)) {
126       throw;
127     }
128     LogRefundETH(payee,payment);
129   }
130 }
131 contract BasicToken is ERC20Basic {
132 
133   using SafeMath for uint;
134 
135   mapping(address => uint) balances;
136 
137   /*
138    * Fix for the ERC20 short address attack
139   */
140   modifier onlyPayloadSize(uint size) {
141      if(msg.data.length < size + 4) {
142        throw;
143      }
144      _;
145   }
146   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150   }
151   function balanceOf(address _owner) constant returns (uint balance) {
152     return balances[_owner];
153   }
154 }
155 contract StandardToken is BasicToken, ERC20 {
156   mapping (address => mapping (address => uint)) allowed;
157   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
158     var _allowance = allowed[_from][msg.sender];
159     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
160     // if (_value > _allowance) throw;
161     balances[_to] = balances[_to].add(_value);
162     balances[_from] = balances[_from].sub(_value);
163     allowed[_from][msg.sender] = _allowance.sub(_value);
164     Transfer(_from, _to, _value);
165   }
166   function approve(address _spender, uint _value) {
167     // To change the approve amount you first have to reduce the addresses`
168     //  allowance to zero by calling `approve(_spender, 0)` if it is not
169     //  already 0 to mitigate the race condition described here:
170     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174   }
175   function allowance(address _owner, address _spender) constant returns (uint remaining) {
176     return allowed[_owner][_spender];
177   }
178 }
179 /**
180  *  manus token contract. Implements
181  */
182 contract Utcoin is StandardToken, Ownable {
183   string public constant name = "UTOPIA";
184   string public constant symbol = "utcoin";
185   uint public constant decimals = 8;
186   // Constructor
187   function Utcoin() {
188       totalSupply =10000000000000000 ;
189       balances[msg.sender] = totalSupply; // Send all tokens to owner
190   }
191   /**
192    *  Burn away the specified amount of utcoin tokens
193    */
194   function burn(uint _value) onlyOwner returns (bool) {
195     balances[msg.sender] = balances[msg.sender].sub(_value);
196     totalSupply = totalSupply.sub(_value);
197     Transfer(msg.sender, 0x0, _value);
198     return true;
199   }
200 }
201 /*
202   This smart contract collects ETH, and in return emits utcoin tokens to the backers
203 */
204 contract Crowdsale is Pausable, PullPayment {
205 
206     using SafeMath for uint;
207 
208   	struct Backer {
209 		uint weiReceived; // Amount of Ether given
210 		uint utcoinSent;
211 	}
212 
213 	/*
214 	* Constants
215 	*/
216 	/* Minimum number of manus to sell */
217 	uint public constant MIN_CAP = 5000000000000000;
218 	/* Maximum number of manus to sell */
219 	uint public constant MAX_CAP =8000000000000000 ;
220   /* Crowdsale period */
221 	uint private constant CROWDSALE_PERIOD = 120 days;
222   /* Number of utcoin per Ether */
223 	uint public constant UTCOIN_PER_ETHER = 45500000000;
224 
225 	/*
226 	* Variables
227 	*/
228 	/* Utcoin contract reference */
229 	Utcoin public utcoin;
230     /* Multisig contract that will receive the Ether */
231 	address public multisigEther;
232 	/* Number of Ether received */
233 	uint public etherReceived;
234 	/* Number of utcoin sent to Ether contributors */
235 	uint public utcoinSentToEther;
236   /* Crowdsale start time */
237 	uint public startTime;
238 	/* Crowdsale end time */
239 	uint public endTime;
240  	/* Is crowdsale still on going */
241 	bool public crowdsaleClosed;
242 
243 	/* Backers Ether indexed by their Ethereum address */
244 	mapping(address => Backer) public backers;
245 
246 
247 	/*
248 	* Modifiers
249 	*/
250 	modifier minCapNotReached() {
251 		if ((now < endTime) || utcoinSentToEther >= MIN_CAP ) throw;
252 		_;
253 	}
254 
255 	modifier respectTimeFrame() {
256 		if ((now < startTime) || (now > endTime )) throw;
257 		_;
258 	}
259 
260 	/*
261 	 * Event
262 	*/
263 	event LogReceivedETH(address addr, uint value);
264 	event LogUtcoinEmited(address indexed from, uint amount);
265 
266 	/*
267 	 * Constructor
268 	*/
269 	function Crowdsale(address _utcoinAddress, address _to) {
270 		utcoin = Utcoin(_utcoinAddress);
271 		multisigEther = _to;
272 	}
273 
274 	/*
275 	 * The fallback function corresponds to a donation in ETH
276 	 */
277 	function() stopInEmergency respectTimeFrame payable {
278 		receiveETH(msg.sender);
279 	}
280 
281 	/*
282 	 * To call to start the crowdsale
283 	 */
284 	function start() onlyOwner {
285 		if (startTime != 0) throw; // Crowdsale was already started
286 
287 		startTime = now ;
288 		endTime =  now + CROWDSALE_PERIOD;
289 	}
290 
291 	/*
292 	 *	Receives a donation in Ether
293 	*/
294 	function receiveETH(address beneficiary) internal {
295 
296 		uint utcoinToSend = bonus(msg.value.mul(UTCOIN_PER_ETHER).div(1 ether)); // Compute the number of utcoin to send
297 		if (utcoinToSend.add(utcoinSentToEther) > MAX_CAP) throw;
298 
299 		Backer backer = backers[beneficiary];
300 		utcoin.transfer(beneficiary, utcoinToSend); // Transfer utcoin right now
301 
302 		backer.utcoinSent = backer.utcoinSent.add(utcoinToSend);
303 		backer.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer
304 
305 		etherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding
306 		utcoinSentToEther = utcoinSentToEther.add(utcoinToSend);
307 
308 		// Send events
309 		LogUtcoinEmited(msg.sender ,utcoinToSend);
310 		LogReceivedETH(beneficiary, etherReceived);
311 	}
312 
313 
314 	/*
315 	 *Compute the utcoin bonus according to the investment period
316 	 */
317 	function bonus(uint amount) internal constant returns (uint) {
318 		if (now < startTime.add(2 days)) return amount.add(amount.div(5));   // bonus 20%
319 		return amount;
320 	}
321 
322 	/*
323 	 * Finalize the crowdsale, should be called after the refund period
324 	*/
325 	function finalize() onlyOwner public {
326 
327 		if (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all manus
328 			if (utcoinSentToEther == MAX_CAP) {
329 			} else {
330 				throw;
331 			}
332 		}
333 
334 		if (utcoinSentToEther < MIN_CAP && now < endTime + 15 days) throw; // If MIN_CAP is not reached donors have 15days to get refund before we can finalise
335 
336 		if (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address
337 
338 		uint remains = utcoin.balanceOf(this);
339 		if (remains > 0) { // Burn the rest of utcoin
340 			if (!utcoin.burn(remains)) throw ;
341 		}
342 		crowdsaleClosed = true;
343 	}
344 
345 	/*
346 	* Failsafe drain
347 	*/
348 	function drain() onlyOwner {
349 		if (!owner.send(this.balance)) throw;
350 	}
351 
352 	/**
353 	 * Allow to change the team multisig address in the case of emergency.
354 	 */
355 	function setMultisig(address addr) onlyOwner public {
356 		if (addr == address(0)) throw;
357 		multisigEther = addr;
358 	}
359 
360 	/**
361 	 * Manually back utcoin owner address.
362 	 */
363 	function backUtcoinOwner() onlyOwner public {
364 		utcoin.transferOwnership(owner);
365 	}
366 
367 	/**
368 	 * Transfer remains to owner in case if impossible to do min invest
369 	 */
370 	function getRemainUtcoin() onlyOwner public {
371 		var remains = MAX_CAP - utcoinSentToEther;
372 		uint minUtcoinToSell = bonus((UTCOIN_PER_ETHER) / (1 ether));
373 
374 		if(remains > minUtcoinToSell) throw;
375 
376 		Backer backer = backers[owner];
377 		utcoin.transfer(owner, remains); // Transfer utcoin right now
378 
379 		backer.utcoinSent = backer.utcoinSent.add(remains);
380 
381 		utcoinSentToEther = utcoinSentToEther.add(remains);
382 
383 		// Send events
384 		LogUtcoinEmited(this ,remains);
385 		LogReceivedETH(owner, etherReceived);
386 	}
387 
388 
389 	/*
390   	 * When MIN_CAP is not reach:
391   	 * 1) backer call the "approve" function of the utcoin token contract with the amount of all utcoin they got in order to be refund
392   	 * 2) backer call the "refund" function of the Crowdsale contract with the same amount of utcoin
393    	 * 3) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
394    	 */
395 	function refund(uint _value) minCapNotReached public {
396 
397 		if (_value != backers[msg.sender].utcoinSent) throw; // compare value from backer balance
398 
399 		utcoin.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract
400 
401 		if (!utcoin.burn(_value)) throw ; // token sent for refund are burnt
402 
403 		uint ETHToSend = backers[msg.sender].weiReceived;
404 		backers[msg.sender].weiReceived=0;
405 
406 		if (ETHToSend > 0) {
407 			asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
408 		}
409 	}
410 
411 }