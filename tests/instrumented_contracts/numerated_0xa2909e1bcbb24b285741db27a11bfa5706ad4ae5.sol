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
182 contract Manus is StandardToken, Ownable {
183   string public constant name = "Manus";
184   string public constant symbol = "MANUS";
185   uint public constant decimals = 18;
186   // Constructor
187   function Manus() {
188       totalSupply =40000000000000000000000000 ;
189       balances[msg.sender] = totalSupply; // Send all tokens to owner
190   }
191   /**
192    *  Burn away the specified amount of manus tokens
193    */
194   function burn(uint _value) onlyOwner returns (bool) {
195     balances[msg.sender] = balances[msg.sender].sub(_value);
196     totalSupply = totalSupply.sub(_value);
197     Transfer(msg.sender, 0x0, _value);
198     return true;
199   }
200 }
201 /*
202 
203   This smart contract collects ETH, and in return emits manus tokens to the backers
204 */
205 contract Crowdsale is Pausable, PullPayment {
206 
207     using SafeMath for uint;
208 
209   	struct Backer {
210 		uint weiReceived; // Amount of Ether given
211 		uint manusSent;
212 	}
213 
214 	/*
215 	* Constants
216 	*/
217 	/* Minimum number of manus to sell */
218 	uint public constant MIN_CAP = 2000000000000000000000000;
219 	/* Maximum number of manus to sell */
220 	uint public constant MAX_CAP =4000000000000000000000000 ;
221   /* Crowdsale period */
222 	uint private constant CROWDSALE_PERIOD = 90 days;
223   /* Number of manus per Ether */
224 	uint public constant MANUS_PER_ETHER = 6000000000000000000000; // 6,000 manus
225 
226 
227 	/*
228 	* Variables
229 	*/
230 	/* Manus contract reference */
231 	Manus public manus;
232     /* Multisig contract that will receive the Ether */
233 	address public multisigEther;
234 	/* Number of Ether received */
235 	uint public etherReceived;
236 	/* Number of manus sent to Ether contributors */
237 	uint public manusSentToEther;
238   /* Crowdsale start time */
239 	uint public startTime;
240 	/* Crowdsale end time */
241 	uint public endTime;
242  	/* Is crowdsale still on going */
243 	bool public crowdsaleClosed;
244 
245 	/* Backers Ether indexed by their Ethereum address */
246 	mapping(address => Backer) public backers;
247 
248 
249 	/*
250 	* Modifiers
251 	*/
252 	modifier minCapNotReached() {
253 		if ((now < endTime) || manusSentToEther >= MIN_CAP ) throw;
254 		_;
255 	}
256 
257 	modifier respectTimeFrame() {
258 		if ((now < startTime) || (now > endTime )) throw;
259 		_;
260 	}
261 
262 	/*
263 	 * Event
264 	*/
265 	event LogReceivedETH(address addr, uint value);
266 	event LogManusEmited(address indexed from, uint amount);
267 
268 	/*
269 	 * Constructor
270 	*/
271 	function Crowdsale(address _manusAddress, address _to) {
272 		manus = Manus(_manusAddress);
273 		multisigEther = _to;
274 	}
275 
276 	/*
277 	 * The fallback function corresponds to a donation in ETH
278 	 */
279 	function() stopInEmergency respectTimeFrame payable {
280 		receiveETH(msg.sender);
281 	}
282 
283 	/*
284 	 * To call to start the crowdsale
285 	 */
286 	function start() onlyOwner {
287 		if (startTime != 0) throw; // Crowdsale was already started
288 
289 		startTime = now ;
290 		endTime =  now + CROWDSALE_PERIOD;
291 	}
292 
293 	/*
294 	 *	Receives a donation in Ether
295 	*/
296 	function receiveETH(address beneficiary) internal {
297 
298 		uint manusToSend = bonus(msg.value.mul(MANUS_PER_ETHER).div(1 ether)); // Compute the number of manus to send
299 		if (manusToSend.add(manusSentToEther) > MAX_CAP) throw;
300 
301 		Backer backer = backers[beneficiary];
302 		manus.transfer(beneficiary, manusToSend); // Transfer ManusToken right now
303 
304 		backer.manusSent = backer.manusSent.add(manusToSend);
305 		backer.weiReceived = backer.weiReceived.add(msg.value); // Update the total wei collected during the crowdfunding for this backer
306 
307 		etherReceived = etherReceived.add(msg.value); // Update the total wei collected during the crowdfunding
308 		manusSentToEther = manusSentToEther.add(manusToSend);
309 
310 		// Send events
311 		LogManusEmited(msg.sender ,manusToSend);
312 		LogReceivedETH(beneficiary, etherReceived);
313 	}
314 
315 
316 	/*
317 	 *Compute the manus bonus according to the investment period
318 	 */
319 	function bonus(uint amount) internal constant returns (uint) {
320 		if (now < startTime.add(2 days)) return amount.add(amount.div(5));   // bonus 20%
321 		return amount;
322 	}
323 
324 	/*
325 	 * Finalize the crowdsale, should be called after the refund period
326 	*/
327 	function finalize() onlyOwner public {
328 
329 		if (now < endTime) { // Cannot finalise before CROWDSALE_PERIOD or before selling all manus
330 			if (manusSentToEther == MAX_CAP) {
331 			} else {
332 				throw;
333 			}
334 		}
335 
336 		if (manusSentToEther < MIN_CAP && now < endTime + 15 days) throw; // If MIN_CAP is not reached donors have 15days to get refund before we can finalise
337 
338 		if (!multisigEther.send(this.balance)) throw; // Move the remaining Ether to the multisig address
339 
340 		uint remains = manus.balanceOf(this);
341 		if (remains > 0) { // Burn the rest of manus
342 			if (!manus.burn(remains)) throw ;
343 		}
344 		crowdsaleClosed = true;
345 	}
346 
347 	/*
348 	* Failsafe drain
349 	*/
350 	function drain() onlyOwner {
351 		if (!owner.send(this.balance)) throw;
352 	}
353 
354 	/**
355 	 * Allow to change the team multisig address in the case of emergency.
356 	 */
357 	function setMultisig(address addr) onlyOwner public {
358 		if (addr == address(0)) throw;
359 		multisigEther = addr;
360 	}
361 
362 	/**
363 	 * Manually back manus owner address.
364 	 */
365 	function backManusOwner() onlyOwner public {
366 		manus.transferOwnership(owner);
367 	}
368 
369 	/**
370 	 * Transfer remains to owner in case if impossible to do min invest
371 	 */
372 	function getRemainManus() onlyOwner public {
373 		var remains = MAX_CAP - manusSentToEther;
374 		uint minManusToSell = bonus((MANUS_PER_ETHER) / (1 ether));
375 
376 		if(remains > minManusToSell) throw;
377 
378 		Backer backer = backers[owner];
379 		manus.transfer(owner, remains); // Transfer manus right now
380 
381 		backer.manusSent = backer.manusSent.add(remains);
382 
383 		manusSentToEther = manusSentToEther.add(remains);
384 
385 		// Send events
386 		LogManusEmited(this ,remains);
387 		LogReceivedETH(owner, etherReceived);
388 	}
389 
390 
391 	/*
392   	 * When MIN_CAP is not reach:
393   	 * 1) backer call the "approve" function of the manus token contract with the amount of all manus they got in order to be refund
394   	 * 2) backer call the "refund" function of the Crowdsale contract with the same amount of manus
395    	 * 3) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
396    	 */
397 	function refund(uint _value) minCapNotReached public {
398 
399 		if (_value != backers[msg.sender].manusSent) throw; // compare value from backer balance
400 
401 		manus.transferFrom(msg.sender, address(this), _value); // get the token back to the crowdsale contract
402 
403 		if (!manus.burn(_value)) throw ; // token sent for refund are burnt
404 
405 		uint ETHToSend = backers[msg.sender].weiReceived;
406 		backers[msg.sender].weiReceived=0;
407 
408 		if (ETHToSend > 0) {
409 			asyncSend(msg.sender, ETHToSend); // pull payment to get refund in ETH
410 		}
411 	}
412 
413 }
414 
415 contract Airdropper is Ownable
416 {
417 function multisend(address _tokenAddr, address[] dests, uint256[] values)
418     onlyOwner
419     returns (uint256) {
420         uint256 i = 0;
421         while (i < dests.length) {
422            ERC20(_tokenAddr).transfer(dests[i], values[i]);
423            i += 1;
424         }
425         return(i);
426     }
427 
428 }