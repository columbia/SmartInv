1 pragma solidity ^0.4.8;
2 
3 contract ERC20 {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6   function allowance(address owner, address spender) constant returns (uint);
7 
8   function transfer(address to, uint value) returns (bool ok);
9   function transferFrom(address from, address to, uint value) returns (bool ok);
10   function approve(address spender, uint value) returns (bool ok);
11   event Transfer(address indexed from, address indexed to, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 
16 contract Ownable {
17   address public owner;
18 
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23   modifier onlyOwner() {
24     if (msg.sender == owner)
25       _;
26   }
27 
28   function transferOwnership(address newOwner) onlyOwner {
29     if (newOwner != address(0)) owner = newOwner;
30   }
31 
32 }
33 
34 contract TokenSpender {
35     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
36 }
37 
38 contract SafeMath {
39   function safeMul(uint a, uint b) internal returns (uint) {
40     uint c = a * b;
41     assert(a == 0 || c / a == b);
42     return c;
43   }
44 
45   function safeDiv(uint a, uint b) internal returns (uint) {
46     assert(b > 0);
47     uint c = a / b;
48     assert(a == b * c + a % b);
49     return c;
50   }
51 
52   function safeSub(uint a, uint b) internal returns (uint) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   function safeAdd(uint a, uint b) internal returns (uint) {
58     uint c = a + b;
59     assert(c>=a && c>=b);
60     return c;
61   }
62 
63   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
64     return a >= b ? a : b;
65   }
66 
67   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
68     return a < b ? a : b;
69   }
70 
71   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
72     return a >= b ? a : b;
73   }
74 
75   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
76     return a < b ? a : b;
77   }
78 
79   function assert(bool assertion) internal {
80     if (!assertion) {
81       throw;
82     }
83   }
84 }
85 
86 contract PullPayment {
87   mapping(address => uint) public payments;
88   event RefundETH(address to, uint value);
89   // store sent amount as credit to be pulled, called by payer
90   function asyncSend(address dest, uint amount) internal {
91     payments[dest] += amount;
92   }
93 
94   // withdraw accumulated balance, called by payee
95   function withdrawPayments() {
96     address payee = msg.sender;
97     uint payment = payments[payee];
98     
99     if (payment == 0) {
100       throw;
101     }
102 
103     if (this.balance < payment) {
104       throw;
105     }
106 
107     payments[payee] = 0;
108 
109     if (!payee.send(payment)) {
110       throw;
111     }
112     RefundETH(payee,payment);
113   }
114 }
115 
116 contract Pausable is Ownable {
117   bool public stopped;
118 
119   modifier stopInEmergency {
120     if (stopped) {
121       throw;
122     }
123     _;
124   }
125   
126   modifier onlyInEmergency {
127     if (!stopped) {
128       throw;
129     }
130     _;
131   }
132 
133   // called by the owner on emergency, triggers stopped state
134   function emergencyStop() external onlyOwner {
135     stopped = true;
136   }
137 
138   // called by the owner on end of emergency, returns to normal state
139   function release() external onlyOwner onlyInEmergency {
140     stopped = false;
141   }
142 
143 }
144 
145 
146 contract RLC is ERC20, SafeMath, Ownable {
147 
148     /* Public variables of the token */
149   string public name;       //fancy name
150   string public symbol;
151   uint8 public decimals;    //How many decimals to show.
152   string public version = 'v0.1'; 
153   uint public initialSupply;
154   uint public totalSupply;
155   bool public locked;
156   //uint public unlockBlock;
157 
158   mapping(address => uint) balances;
159   mapping (address => mapping (address => uint)) allowed;
160 
161   // lock transfer during the ICO
162   modifier onlyUnlocked() {
163     if (msg.sender != owner && locked) throw;
164     _;
165   }
166 
167   /*
168    *  The RLC Token created with the time at which the crowdsale end
169    */
170 
171   function RLC() {
172     // lock the transfer function during the crowdsale
173     locked = true;
174     //unlockBlock=  now + 45 days; // (testnet) - for mainnet put the block number
175 
176     initialSupply = 87000000000000000;
177     totalSupply = initialSupply;
178     balances[msg.sender] = initialSupply;// Give the creator all initial tokens                    
179     name = 'iEx.ec Network Token';        // Set the name for display purposes     
180     symbol = 'RLC';                       // Set the symbol for display purposes  
181     decimals = 9;                        // Amount of decimals for display purposes
182   }
183 
184   function unlock() onlyOwner {
185     locked = false;
186   }
187 
188   function burn(uint256 _value) returns (bool){
189     balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
190     totalSupply = safeSub(totalSupply, _value);
191     Transfer(msg.sender, 0x0, _value);
192     return true;
193   }
194 
195   function transfer(address _to, uint _value) onlyUnlocked returns (bool) {
196     balances[msg.sender] = safeSub(balances[msg.sender], _value);
197     balances[_to] = safeAdd(balances[_to], _value);
198     Transfer(msg.sender, _to, _value);
199     return true;
200   }
201 
202   function transferFrom(address _from, address _to, uint _value) onlyUnlocked returns (bool) {
203     var _allowance = allowed[_from][msg.sender];
204     
205     balances[_to] = safeAdd(balances[_to], _value);
206     balances[_from] = safeSub(balances[_from], _value);
207     allowed[_from][msg.sender] = safeSub(_allowance, _value);
208     Transfer(_from, _to, _value);
209     return true;
210   }
211 
212   function balanceOf(address _owner) constant returns (uint balance) {
213     return balances[_owner];
214   }
215 
216   function approve(address _spender, uint _value) returns (bool) {
217     allowed[msg.sender][_spender] = _value;
218     Approval(msg.sender, _spender, _value);
219     return true;
220   }
221 
222     /* Approve and then comunicate the approved contract in a single tx */
223   function approveAndCall(address _spender, uint256 _value, bytes _extraData){    
224       TokenSpender spender = TokenSpender(_spender);
225       if (approve(_spender, _value)) {
226           spender.receiveApproval(msg.sender, _value, this, _extraData);
227       }
228   }
229 
230   function allowance(address _owner, address _spender) constant returns (uint remaining) {
231     return allowed[_owner][_spender];
232   }
233   
234 }
235 
236 
237 
238 
239 contract Crowdsale is SafeMath, PullPayment, Pausable {
240 
241   	struct Backer {
242 		uint weiReceived;	// Amount of ETH given
243 		string btc_address;  //store the btc address for full traceability
244 		uint satoshiReceived;	// Amount of BTC given
245 		uint rlcSent;
246 	}
247 
248 	RLC 	public rlc;         // RLC contract reference
249 	address public owner;       // Contract owner (iEx.ec team)
250 	address public multisigETH; // Multisig contract that will receive the ETH
251 	address public BTCproxy;	// address of the BTC Proxy
252 
253 	uint public RLCPerETH;      // Number of RLC per ETH
254 	uint public RLCPerSATOSHI;  // Number of RLC per SATOSHI
255 	uint public ETHReceived;    // Number of ETH received
256 	uint public BTCReceived;    // Number of BTC received
257 	uint public RLCSentToETH;   // Number of RLC sent to ETH contributors
258 	uint public RLCSentToBTC;   // Number of RLC sent to BTC contributors
259 	uint public startBlock;     // Crowdsale start block
260 	uint public endBlock;       // Crowdsale end block
261 	uint public minCap;         // Minimum number of RLC to sell
262 	uint public maxCap;         // Maximum number of RLC to sell
263 	bool public maxCapReached;  // Max cap has been reached
264 	uint public minInvestETH;   // Minimum amount to invest
265 	uint public minInvestBTC;   // Minimum amount to invest
266 	bool public crowdsaleClosed;// Is crowdsale still on going
267 
268 	address public bounty;		// address at which the bounty RLC will be sent
269 	address public reserve; 	// address at which the contingency reserve will be sent
270 	address public team;		// address at which the team RLC will be sent
271 
272 	uint public rlc_bounty;		// amount of bounties RLC
273 	uint public rlc_reserve;	// amount of the contingency reserve
274 	uint public rlc_team;		// amount of the team RLC 
275 	mapping(address => Backer) public backers; //backersETH indexed by their ETH address
276 
277 	modifier onlyBy(address a){
278 		if (msg.sender != a) throw;  
279 		_;
280 	}
281 
282 	modifier minCapNotReached() {
283 		if ((now<endBlock) || RLCSentToETH + RLCSentToBTC >= minCap ) throw;
284 		_;
285 	}
286 
287 	modifier respectTimeFrame() {
288 		if ((now < startBlock) || (now > endBlock )) throw;
289 		_;
290 	}
291 
292 	/*
293 	* Event
294 	*/
295 	event ReceivedETH(address addr, uint value);
296 	event ReceivedBTC(address addr, string from, uint value, string txid);
297 	event RefundBTC(string to, uint value);
298 	event Logs(address indexed from, uint amount, string value);
299 
300 	/*
301 	*	Constructor
302 	*/
303 	//function Crowdsale() {
304 	function Crowdsale() {
305 		owner = msg.sender;
306 		BTCproxy = 0x75c6cceb1a33f177369053f8a0e840de96b4ed0e;
307 		rlc = RLC(0x607F4C5BB672230e8672085532f7e901544a7375);
308 		multisigETH = 0xAe307e3871E5A321c0559FBf0233A38c937B826A;
309 		team = 0xd65380D773208a6Aa49472Bf55186b855B393298;
310 		reserve = 0x24F6b37770C6067D05ACc2aD2C42d1Bafde95d48;
311 		bounty = 0x8226a24dA0870Fb8A128E4Fc15228a9c4a5baC29;
312 		RLCSentToETH = 0;
313 		RLCSentToBTC = 0;
314 		minInvestETH = 1 ether;
315 		minInvestBTC = 5000000;			// approx 50 USD or 0.05000000 BTC
316 		startBlock = 0 ;            	// should wait for the call of the function start
317 		endBlock =  0;  				// should wait for the call of the function start
318 		RLCPerETH = 200000000000;		// will be update every 10min based on the kraken ETHBTC
319 		RLCPerSATOSHI = 50000;			// 5000 RLC par BTC == 50,000 RLC per satoshi
320 		minCap=12000000000000000;
321 		maxCap=60000000000000000;
322 		rlc_bounty=1700000000000000;	// max 6000000 RLC
323 		rlc_reserve=1700000000000000;	// max 6000000 RLC
324 		rlc_team=12000000000000000;
325 	}
326 
327 	/* 
328 	 * The fallback function corresponds to a donation in ETH
329 	 */
330 	function() payable {
331 		if (now > endBlock) throw;
332 		receiveETH(msg.sender);
333 	}
334 
335 	/* 
336 	 * To call to start the crowdsale
337 	 */
338 	function start() onlyBy(owner) {
339 		startBlock = now ;            
340 		endBlock =  now + 30 days;    
341 	}
342 
343 	/*
344 	*	Receives a donation in ETH
345 	*/
346 	function receiveETH(address beneficiary) internal stopInEmergency  respectTimeFrame  {
347 		if (msg.value < minInvestETH) throw;								//don't accept funding under a predefined threshold
348 		uint rlcToSend = bonus(safeMul(msg.value,RLCPerETH)/(1 ether));		//compute the number of RLC to send
349 		if (safeAdd(rlcToSend, safeAdd(RLCSentToETH, RLCSentToBTC)) > maxCap) throw;	
350 
351 		Backer backer = backers[beneficiary];
352 		if (!rlc.transfer(beneficiary, rlcToSend)) throw;     				// Do the RLC transfer right now 
353 		backer.rlcSent = safeAdd(backer.rlcSent, rlcToSend);
354 		backer.weiReceived = safeAdd(backer.weiReceived, msg.value);		// Update the total wei collected during the crowdfunding for this backer    
355 		ETHReceived = safeAdd(ETHReceived, msg.value);						// Update the total wei collected during the crowdfunding
356 		RLCSentToETH = safeAdd(RLCSentToETH, rlcToSend);
357 
358 		emitRLC(rlcToSend);													// compute the variable part 
359 		ReceivedETH(beneficiary,ETHReceived);								// send the corresponding contribution event
360 	}
361 	
362 	/*
363 	* receives a donation in BTC
364 	*/
365 	function receiveBTC(address beneficiary, string btc_address, uint value, string txid) stopInEmergency respectTimeFrame onlyBy(BTCproxy) returns (bool res){
366 		if (value < minInvestBTC) throw;											// this verif is also made on the btcproxy
367 
368 		uint rlcToSend = bonus(safeMul(value,RLCPerSATOSHI));						//compute the number of RLC to send
369 		if (safeAdd(rlcToSend, safeAdd(RLCSentToETH, RLCSentToBTC)) > maxCap) {		// check if we are not reaching the maxCap by accepting this donation
370 			RefundBTC(btc_address , value);
371 			return false;
372 		}
373 
374 		Backer backer = backers[beneficiary];
375 		if (!rlc.transfer(beneficiary, rlcToSend)) throw;							// Do the transfer right now 
376 		backer.rlcSent = safeAdd(backer.rlcSent , rlcToSend);
377 		backer.btc_address = btc_address;
378 		backer.satoshiReceived = safeAdd(backer.satoshiReceived, value);
379 		BTCReceived =  safeAdd(BTCReceived, value);									// Update the total satoshi collected during the crowdfunding for this backer
380 		RLCSentToBTC = safeAdd(RLCSentToBTC, rlcToSend);							// Update the total satoshi collected during the crowdfunding
381 		emitRLC(rlcToSend);
382 		ReceivedBTC(beneficiary, btc_address, BTCReceived, txid);
383 		return true;
384 	}
385 
386 	/*
387 	 *Compute the variable part
388 	 */
389 	function emitRLC(uint amount) internal {
390 		rlc_bounty = safeAdd(rlc_bounty, amount/10);
391 		rlc_team = safeAdd(rlc_team, amount/20);
392 		rlc_reserve = safeAdd(rlc_reserve, amount/10);
393 		Logs(msg.sender ,amount, "emitRLC");
394 	}
395 
396 	/*
397 	 *Compute the RLC bonus according to the investment period
398 	 */
399 	function bonus(uint amount) internal constant returns (uint) {
400 		if (now < safeAdd(startBlock, 10 days)) return (safeAdd(amount, amount/5));   // bonus 20%
401 		if (now < safeAdd(startBlock, 20 days)) return (safeAdd(amount, amount/10));  // bonus 10%
402 		return amount;
403 	}
404 
405 	/* 
406 	 * When mincap is not reach backer can call the approveAndCall function of the RLC token contract
407 	 * with this crowdsale contract on parameter with all the RLC they get in order to be refund
408 	 */
409 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) minCapNotReached public {
410 		if (msg.sender != address(rlc)) throw; 
411 		if (_extraData.length != 0) throw;								// no extradata needed
412 		if (_value != backers[_from].rlcSent) throw;					// compare value from backer balance
413 		if (!rlc.transferFrom(_from, address(this), _value)) throw ;	// get the token back to the crowdsale contract
414 		if (!rlc.burn(_value)) throw ;									// token sent for refund are burnt
415 		uint ETHToSend = backers[_from].weiReceived;
416 		backers[_from].weiReceived=0;
417 		uint BTCToSend = backers[_from].satoshiReceived;
418 		backers[_from].satoshiReceived = 0;
419 		if (ETHToSend > 0) {
420 			asyncSend(_from,ETHToSend);									// pull payment to get refund in ETH
421 		}
422 		if (BTCToSend > 0)
423 			RefundBTC(backers[_from].btc_address ,BTCToSend);			// event message to manually refund BTC
424 	}
425 
426 	/*
427 	* Update the rate RLC per ETH, computed externally by using the ETHBTC index on kraken every 10min
428 	*/
429 	function setRLCPerETH(uint rate) onlyBy(BTCproxy) {
430 		RLCPerETH=rate;
431 	}
432 	
433 	/*	
434 	* Finalize the crowdsale, should be called after the refund period
435 	*/
436 	function finalize() onlyBy(owner) {
437 		// check
438 		if (RLCSentToETH + RLCSentToBTC < maxCap - 5000000000000 && now < endBlock) throw;	// cannot finalise before 30 day until maxcap is reached minus 1BTC
439 		if (RLCSentToETH + RLCSentToBTC < minCap && now < endBlock + 15 days) throw ;		// if mincap is not reached donors have 15days to get refund before we can finalise
440 		if (!multisigETH.send(this.balance)) throw;											// moves the remaining ETH to the multisig address
441 		if (rlc_reserve > 6000000000000000){												// moves RLC to the team, reserve and bounty address
442 			if(!rlc.transfer(reserve,6000000000000000)) throw;								// max cap 6000000RLC
443 			rlc_reserve = 6000000000000000;
444 		} else {
445 			if(!rlc.transfer(reserve,rlc_reserve)) throw;  
446 		}
447 		if (rlc_bounty > 6000000000000000){
448 			if(!rlc.transfer(bounty,6000000000000000)) throw;								// max cap 6000000RLC
449 			rlc_bounty = 6000000000000000;
450 		} else {
451 			if(!rlc.transfer(bounty,rlc_bounty)) throw;
452 		}
453 		if (!rlc.transfer(team,rlc_team)) throw;
454 		uint RLCEmitted = rlc_reserve + rlc_bounty + rlc_team + RLCSentToBTC + RLCSentToETH;
455 		if (RLCEmitted < rlc.totalSupply())													// burn the rest of RLC
456 			  rlc.burn(rlc.totalSupply() - RLCEmitted);
457 		rlc.unlock();
458 		crowdsaleClosed = true;
459 	}
460 
461 	/*	
462 	* Failsafe drain
463 	*/
464 	function drain() onlyBy(owner) {
465 		if (!owner.send(this.balance)) throw;
466 	}
467 }