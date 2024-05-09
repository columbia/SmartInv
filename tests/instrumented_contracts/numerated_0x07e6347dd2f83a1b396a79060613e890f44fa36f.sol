1 pragma solidity ^0.4.23;
2 
3 /**
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48  /**
49  * @dev The Ownable contract has an owner address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52  contract Ownable {
53   address public owner;
54 
55 
56   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   function Ownable() public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     emit OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 
85 }
86 
87 contract ERC20Basic {
88   function totalSupply() public view returns (uint256);
89   function balanceOf(address who) public view returns (uint256);
90   function transfer(address to, uint256 value) public returns (bool);
91   event Transfer(address indexed from, address indexed to, uint256 value);
92 }
93 
94 
95 contract BasicToken is ERC20Basic {
96   using SafeMath for uint256;
97 
98   mapping(address => uint256) balances;
99 
100   uint256 totalSupply_;
101 
102   /**
103   * @dev total number of tokens in existence
104   */
105   function totalSupply() public view returns (uint256) {
106     return totalSupply_;
107   }
108 
109   /**
110   * @dev transfer token for a specified address
111   * @param _to The address to transfer to.
112   * @param _value The amount to be transferred.
113   */
114   function transfer(address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value <= balances[msg.sender]);
117 
118     // SafeMath.sub will throw if there is not enough balance.
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     emit Transfer(msg.sender, _to, _value);
122     return true;
123   }
124   
125   function transferFromContract(address _to, uint256 _value) internal returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[address(this)]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[address(this)] = balances[address(this)].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     emit Transfer(address(this), _to, _value);
133     return true;
134   }  
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 contract BurnableToken is BasicToken {
148 
149   event Burn(address indexed burner, uint256 value);
150 
151   /**
152    * @dev Burns a specific amount of tokens.
153    * @param _value The amount of token to be burned.
154    */
155   function burn(uint256 _value) internal {
156     require(_value <= balances[msg.sender]);
157     // no need to require value <= totalSupply, since that would imply the
158     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
159 
160     address burner = msg.sender;
161     balances[burner] = balances[burner].sub(_value);
162     totalSupply_ = totalSupply_.sub(_value);
163     emit Burn(burner, _value);
164     emit Transfer(burner, address(0), _value);
165   }
166 }
167 
168 
169 contract MintableToken is BasicToken {
170  /**
171  * @dev Simple ERC20 Token example, with mintable token creation
172  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
173  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
174  */ 
175   event Mint(address indexed to, uint256 amount);
176 
177   /**
178    * @dev Function to mint tokens
179    * @param _to The address that will receive the minted tokens.
180    * @param _amount The amount of tokens to mint.
181    * @return A boolean that indicates if the operation was successful.
182    */
183   function mint(address _to, uint256 _amount) internal returns (bool) {
184     totalSupply_ = totalSupply_.add(_amount);
185     balances[_to] = balances[_to].add(_amount);
186     emit Mint(_to, _amount);
187     emit Transfer(address(0), _to, _amount);
188     return true;
189   }
190   
191 } 
192 
193 contract EFToken is MintableToken, BurnableToken, Ownable {
194   string public constant name = "EtherFactoryToken"; 
195   string public constant symbol = "EFT"; 
196   uint8 public constant decimals = 0;  
197   
198   uint256 internal presellStart = now;
199   
200   mapping(uint256 => address) internal InviterAddress; 
201   mapping(address => uint256) public InviterToID; 
202  
203   uint256 private InviterID = 0;
204   
205   function sellTokens(uint256 _value) public gameStarted {
206   
207     require (balances[msg.sender] >= _value && _value > 0);
208 	uint256 balance = address(this).balance;
209 	require (balance > 0);
210 	
211     uint256 total = totalSupply();
212 	uint256 sellRate = uint256( balance.div( total ) );
213 	uint256 ethValue = sellRate.mul(_value);
214 	msg.sender.transfer(ethValue);
215 	burn(_value);
216 	
217   } 
218   
219   function buyTokens() public gameStarted payable {
220     
221 	uint256 eth = msg.value;
222     require ( msg.value>0 );
223 	uint256 tokensAmount = balances[address(this)];
224 	uint256 balance = uint256(SafeMath.sub(address(this).balance,msg.value));
225 	if (balance < 0.1 ether)
226 		balance = 0.1 ether;
227     uint256 total = totalSupply();
228 	uint256 sellRate = uint256( balance.div( total ) );
229 	uint256 eftValue = uint256(eth.div(sellRate));
230 	require ( eftValue <= tokensAmount && eftValue > 0 );
231 	
232 	transferFromContract(msg.sender, eftValue);
233 
234 	uint256 fee = uint256(SafeMath.div(msg.value, 10)); 
235 	// dev fee 10%
236 	owner.transfer(fee); 	
237   } 
238 
239   function inviterReg() public {
240 	require (msg.sender != address(0) && InviterToID[msg.sender] == 0);
241 	
242 	InviterID++;
243 	InviterAddress[InviterID] = msg.sender;
244 	InviterToID[msg.sender] = InviterID;
245   }
246   
247   function tokensRate() public view returns (uint256 rate, uint256 yourEFT, uint256 totalEFT, uint256 ethBalance, uint256 eftBalance) {
248     yourEFT = balanceOf (msg.sender);
249     totalEFT = totalSupply();
250 	ethBalance = address(this).balance;
251 	rate = uint256(ethBalance.div(totalEFT));
252 	eftBalance = balances[address(this)];
253   }
254   
255   //views
256   function presellTimer() public view returns (uint256 presellLeft) {
257 	presellLeft = uint256(SafeMath.div(now.sub(presellStart), 60));
258   }
259   
260   //modifiers
261   modifier gameStarted() {
262     require(now - presellStart >= 604800); // 604800 sec = one  week
263     _;
264   }
265     
266 }
267 
268 contract EtherFactory is EFToken {
269 
270   //FactoryID -> workers qualification (depends on factory level) -> workers amount
271   mapping(uint256 => mapping(uint8 => uint256)) internal FactoryPersonal; 
272   
273   //FactoryID -> owner address
274   mapping(uint256 => address) internal FactoryOwner; 
275   
276   //FactoryID -> start work date (timestamp). For profit calculate;
277   mapping(uint256 => uint256) internal FactoryWorkStart; 
278   
279   //FactoryID -> factory level;
280   mapping(uint256 => uint8) internal FactoryLevel; 
281   
282    //FactoryID -> factory eth price;
283   mapping(uint256 => uint256) internal FactoryPrice; 
284 
285    //FactoryID -> factory name;
286   mapping(uint256 => string) internal FactoryName; 
287   
288   //Worker -> qualification
289   mapping(address => uint8) internal WorkerQualification; 
290   
291   //Worker -> FactoryID
292   mapping(address => uint256) internal WorkerFactory; 
293   
294   //Worker -> start work date (timestamp). For profit calculate;
295   mapping(address => uint256) internal WorkerWorkStart;   
296   
297   uint256 FactoryID = 0;
298   
299   //Factories core
300   
301   function setFactoryName(uint256 _FactoryID, string _Name) public {
302 	require (FactoryOwner[_FactoryID] == msg.sender);	
303 	require(bytes(_Name).length <= 50);
304 	FactoryName[_FactoryID] = _Name; 
305   }
306   
307   function getFactoryProfit(uint256 _FactoryID, address _FactoryOwner) public gameStarted {
308 	require (FactoryOwner[_FactoryID] == _FactoryOwner);
309 	
310 	//Factory profit equal to the earnings of all workers.
311 	uint256 profitMinutes = uint256(SafeMath.div(SafeMath.sub(now, FactoryWorkStart[_FactoryID]), 60));
312 	if (profitMinutes > 0) {
313 		uint256 profit = 0;
314 		
315 		for (uint8 level=1; level<=FactoryLevel[_FactoryID]; level++) {
316 		   profit += SafeMath.mul(SafeMath.mul(uint256(level),profitMinutes), FactoryPersonal[_FactoryID][level]);
317 		}
318 		
319 		if (profit > 0) {
320 			mint(_FactoryOwner,profit);
321 			FactoryWorkStart[_FactoryID] = now;
322 		}
323 	}
324 	
325   }
326 
327   function buildFactory(uint8 _level, uint256 _inviterID) public payable {
328   
329     require (_level>0 && _level<=100);
330 	
331     uint256 buildCost = uint256(_level).mul( getFactoryPrice() );
332 	require (msg.value == buildCost);
333 	
334 	FactoryID++;
335 	FactoryOwner[FactoryID] = msg.sender;
336 	FactoryLevel[FactoryID] = _level;
337 	FactoryPrice[FactoryID] = SafeMath.mul(0.15 ether, _level);
338 	
339 	//for EFT-ETH rate balance
340 	mint(address(this), SafeMath.mul(1000000, _level));
341 	
342 	
343 	address Inviter = InviterAddress[_inviterID];
344 
345 	uint256 fee = uint256(SafeMath.div(msg.value, 20)); 
346 	
347 	if ( Inviter != address(0)) {
348 		//bounty for invite -> 5% from payment
349 		Inviter.transfer(fee); 
350 	} else {
351 	    //no inviter, dev fee - 10%
352 		fee = fee.mul(2);
353 	}
354 	
355 	// dev fee
356 	owner.transfer(fee); 	
357   }  
358   
359   function upgradeFactory(uint256 _FactoryID) public payable {
360   
361     require (FactoryOwner[_FactoryID] == msg.sender);
362 	require (FactoryLevel[_FactoryID] < 100);
363 	
364 	require (msg.value == getFactoryPrice() );
365 
366 	FactoryLevel[_FactoryID]++ ;
367 	FactoryPrice[FactoryID] += 0.15 ether;
368 	
369 	//for EFT-ETH rate balance
370 	mint(address(this), 1000000);
371 	
372 	uint256 fee = uint256(SafeMath.div(msg.value, 10)); 
373 	// dev fee 10%
374 	owner.transfer(fee); 
375 	
376   }    
377   
378   function buyExistFactory(uint256 _FactoryID) public payable {
379   
380     address factoryOwner = FactoryOwner[_FactoryID];
381 	
382     require ( factoryOwner != address(0) && factoryOwner != msg.sender && msg.sender != address(0) );
383 
384     uint256 factoryPrice = FactoryPrice[_FactoryID];
385     require(msg.value >= factoryPrice);
386 	
387 	//new owner
388 	FactoryOwner[_FactoryID] = msg.sender;
389 	
390 	//90% to previous factory owner
391 	uint256 Payment90percent = uint256(SafeMath.div(SafeMath.mul(factoryPrice, 9), 10)); 
392 
393 	//5% dev fee
394 	uint256 fee = uint256(SafeMath.div(SafeMath.mul(factoryPrice, 5), 100)); 
395 	
396 	//new price +50%
397 	FactoryPrice[_FactoryID] = uint256(SafeMath.div(SafeMath.mul(factoryPrice, 3), 2)); 
398 
399 	
400     factoryOwner.transfer(Payment90percent); 
401 	owner.transfer(fee); 
402 	
403 	//return excess pay
404     if (msg.value > factoryPrice) { 
405 		msg.sender.transfer(msg.value - factoryPrice);
406 	}
407   }   
408   
409   function increaseMarketValue(uint256 _FactoryID, uint256 _tokens) public gameStarted {
410   
411 	uint256 eftTOethRATE = 200000000000;
412 	
413 	require (FactoryOwner[_FactoryID] == msg.sender);
414 	require (balances[msg.sender] >= _tokens && _tokens>0);
415 	
416 	FactoryPrice[_FactoryID] = FactoryPrice[_FactoryID] + _tokens*eftTOethRATE;
417 	burn(_tokens);
418   }
419   
420   
421   
422   //workers core
423   
424   function findJob(uint256 _FactoryID) public gameStarted {
425     
426     require (WorkerFactory[msg.sender] != _FactoryID);
427   
428 	if (WorkerQualification[msg.sender] == 0) {
429 		WorkerQualification[msg.sender] = 1;
430 	}
431 
432 	uint8 qualification = WorkerQualification[msg.sender];
433 		
434 	require (FactoryLevel[_FactoryID] >= qualification);
435 	
436 	//100 is limit for each worker qualificationon on the factory
437 	require (FactoryPersonal[_FactoryID][qualification] < 100);
438 	
439 	//reset factory and worker profit timer
440 	if (WorkerFactory[msg.sender]>0) {
441 		getFactoryProfit(_FactoryID, FactoryOwner[_FactoryID]);
442 		getWorkerProfit();
443 	} else {
444 		WorkerWorkStart[msg.sender] = now;
445 	}
446 	
447 	//previous factory lost worker
448 	if (WorkerFactory[msg.sender] > 0 ) {
449 	   FactoryPersonal[WorkerFactory[msg.sender]][qualification]--;
450 	}
451 	
452 	WorkerFactory[msg.sender] = _FactoryID;
453 	
454 	FactoryPersonal[_FactoryID][qualification]++;
455 	
456 	if (FactoryWorkStart[_FactoryID] ==0)
457 		FactoryWorkStart[_FactoryID] = now;
458 	
459   } 
460   
461   function getWorkerProfit() public gameStarted {
462 	require (WorkerFactory[msg.sender] > 0);
463 	
464 	//Worker with qualification "ONE" earn 1 token per minute, "TWO" earn 2 tokens, etc...
465 	uint256 profitMinutes = uint256(SafeMath.div(SafeMath.sub(now, WorkerWorkStart[msg.sender]), 60));
466 	if (profitMinutes > 0) {
467 		uint8 qualification = WorkerQualification[msg.sender];
468 		
469 		uint256 profitEFT = SafeMath.mul(uint256(qualification),profitMinutes);
470 		
471 		require (profitEFT > 0);
472 		
473 		mint(msg.sender,profitEFT);
474 		
475 		WorkerWorkStart[msg.sender] = now;
476 	}
477 	
478   }  
479   
480   function upgradeQualificationByTokens() public gameStarted {
481 	
482 	require (WorkerQualification[msg.sender]<100);
483 	
484     uint256 upgradeCost = 10000;
485 	require (balances[msg.sender] >= upgradeCost);
486 	
487 	if (WorkerFactory[msg.sender] > 0)
488 		getWorkerProfit();
489     
490 	uint8 oldQualification = WorkerQualification[msg.sender];
491 	
492 	uint256 WorkerFactoryID = WorkerFactory[msg.sender];
493 
494 	if (WorkerQualification[msg.sender]==0) 
495 		WorkerQualification[msg.sender]=2;
496 	else 
497 		WorkerQualification[msg.sender]++;
498 	
499 	if (WorkerFactoryID > 0) {
500 		getFactoryProfit(WorkerFactoryID, FactoryOwner[WorkerFactoryID]);
501 		FactoryPersonal[WorkerFactoryID][oldQualification]--;
502 	
503 		if (FactoryLevel[WorkerFactoryID] >= oldQualification+1) {
504 			FactoryPersonal[WorkerFactoryID][oldQualification+1]++;
505 		} else {
506 			//will unemployed
507 			WorkerFactory[msg.sender] = 0;
508 		}
509 	}
510 	
511 	// burn tokens
512 	burn(upgradeCost);
513 	
514   }   
515   
516   function upgradeQualificationByEther(uint256 _inviterID) public payable {
517 	
518 	require (WorkerQualification[msg.sender]<100);
519 	
520 	//0.001 ether or 0.00075 presell
521 	require ( msg.value == SafeMath.div(getFactoryPrice(),100) );
522 	
523 	uint256 fee = uint256(SafeMath.div(msg.value, 20)); //5%
524 	
525 	address Inviter = InviterAddress[_inviterID];
526 
527 	if ( Inviter != address(0)) {
528 		//bounty for invite -> 5% from payment
529 		Inviter.transfer(fee); 
530 	} else {
531 	    //no inviter, dev fee - 10%
532 		fee = fee.mul(2);
533 	}
534 	
535 	// dev fee
536 	owner.transfer(fee); 
537 	
538 	if (WorkerFactory[msg.sender] > 0)
539 		getWorkerProfit();
540     
541 	uint8 oldQualification = WorkerQualification[msg.sender];
542 	
543 	uint256 WorkerFactoryID = WorkerFactory[msg.sender];
544 	
545 	if (WorkerQualification[msg.sender]==0) 
546 		WorkerQualification[msg.sender]=2;
547 	else 
548 		WorkerQualification[msg.sender]++;
549 	
550 	
551 	
552 	if (WorkerFactoryID > 0) {
553 		getFactoryProfit(WorkerFactoryID, FactoryOwner[WorkerFactoryID]);
554 		FactoryPersonal[WorkerFactoryID][oldQualification]--;
555 	
556 		if (FactoryLevel[WorkerFactoryID] >= oldQualification+1) {
557 			FactoryPersonal[WorkerFactoryID][oldQualification+1]++;
558 		} else {
559 			//will unemployed
560 			WorkerFactory[msg.sender] = 0;
561 		}
562 	}
563 	
564 	
565   }  
566   
567   function getFactoryPrice() internal view returns (uint256 price) {
568 	if (now - presellStart >= 604800)
569 		price = 0.1 ether;
570 	else 
571 		price = 0.075 ether;
572   }
573   
574   
575   //views
576 
577   function allFactories() public constant returns(address[] owner, uint256[] profitMinutes, uint256[] price, uint8[] level) {    
578 
579     //FactoryID is count of factories
580 	price = new uint256[](FactoryID);
581 	profitMinutes = new uint256[](FactoryID);
582 	owner = new address[](FactoryID);
583 	level = new uint8[](FactoryID);
584 
585 	for (uint256 index=1; index<=FactoryID; index++) {
586 		price[index-1] = FactoryPrice[index];
587 		profitMinutes[index-1] = uint256(SafeMath.div(now - FactoryWorkStart[index],60));
588 		owner[index-1] = FactoryOwner[index];
589 		level[index-1] = FactoryLevel[index];
590 	}
591 	
592   }
593   
594   function aboutFactoryWorkers(uint256 _FactoryID)  public constant returns(uint256[] workers, string factoryName) {    
595 	uint8 factoryLevel = FactoryLevel[_FactoryID];
596 	factoryName = FactoryName[_FactoryID];
597 	
598 	workers = new uint256[](factoryLevel+1);
599 	for (uint8 qualification=1; qualification<=factoryLevel; qualification++)
600 		workers[qualification] = FactoryPersonal[_FactoryID][qualification];
601 	
602   }  
603   
604   function aboutWorker(address _worker) public constant returns(uint8 qualification, uint256 factoryId, uint256 profitMinutes, uint8 factoryLevel) {    
605 	qualification = WorkerQualification[_worker];	
606 	if (qualification==0)
607 		qualification=1;
608 	factoryId = WorkerFactory[_worker];	
609 	factoryLevel = FactoryLevel[factoryId];
610 	profitMinutes = uint256(SafeMath.div(now - WorkerWorkStart[_worker],60));
611   }
612   
613   function contractBalance() public constant returns(uint256 ethBalance) {    
614 	ethBalance = address(this).balance;
615   }  
616   
617 
618 }