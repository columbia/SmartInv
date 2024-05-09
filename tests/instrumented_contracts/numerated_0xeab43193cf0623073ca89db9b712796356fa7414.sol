1 pragma solidity ^0.4.17;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 /**
47  * @title Pausable
48  * @dev Base contract which allows children to implement an emergency stop mechanism.
49  */
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53 
54   bool public paused = false;
55 
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is not paused.
59    */
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is paused.
67    */
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   /**
74    * @dev called by the owner to pause, triggers stopped state
75    */
76   function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     Pause();
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused public {
85     paused = false;
86     Unpause();
87   }
88 }
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that throw on error
93  */
94 library SafeMath {
95   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96     if (a == 0) {
97       return 0;
98     }
99     uint256 c = a * b;
100     assert(c / a == b);
101     return c;
102   }
103 
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112     assert(b <= a);
113     return a - b;
114   }
115 
116   function add(uint256 a, uint256 b) internal pure returns (uint256) {
117     uint256 c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }
122 
123 
124 /**
125  * @title ERC20Basic
126  * @dev Simpler version of ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/179
128  */
129 contract ERC20Basic {
130   //uint256 public totalSupply;
131   function balanceOf(address who) public view returns (uint256);
132   function transfer(address to, uint256 value) public returns (bool);
133   event Transfer(address indexed from, address indexed to, uint256 value);
134 }
135 
136 
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20 
141  */
142 contract ERC20 is ERC20Basic {
143   function allowance(address owner, address spender) public view returns (uint256);
144   function transferFrom(address from, address to, uint256 value) public returns (bool);
145   function approve(address spender, uint256 value) public returns (bool);
146   event Approval(address indexed owner, address indexed spender, uint256 value);
147 }
148 
149 contract GoldFees is Ownable {
150     using SafeMath for uint256;
151     
152     // e.g. if rate = 0.0054
153     //uint rateN = 9999452055;
154     uint rateN = 9999452054794520548;
155     uint rateD = 19;
156     uint public maxDays;
157     uint public maxRate;
158 
159     
160     function GoldFees() public {
161         calcMax();
162     }
163 
164     function calcMax() internal {
165         maxDays = 1;
166         maxRate = rateN;
167         
168         
169         uint pow = 2;
170         do {
171             uint newN = rateN ** pow;
172             if (newN / maxRate != maxRate) {
173                 maxDays = pow / 2;
174                 break;
175             }
176             maxRate = newN;
177             pow *= 2;
178         } while (pow < 2000);
179         
180     }
181 
182     function updateRate(uint256 _n, uint256 _d) public onlyOwner {
183         rateN = _n;
184         rateD = _d;
185         calcMax();
186     }
187     
188     function rateForDays(uint256 numDays) public view returns (uint256 rate) {
189         if (numDays <= maxDays) {
190             uint r = rateN ** numDays;
191             uint d = rateD * numDays;
192             if (d > 18) {
193                 uint div = 10 ** (d-18);
194                 rate = r / div;
195             } else {
196                 div = 10 ** (18 - d);
197                 rate = r * div;
198             }
199         } else {
200             uint256 md1 = numDays / 2;
201             uint256 md2 = numDays - md1;
202              uint256 r2;
203 
204             uint256 r1 = rateForDays(md1);
205             if (md1 == md2) {
206                 r2 = r1;
207             } else {
208                 r2 = rateForDays(md2);
209             }
210            
211 
212             //uint256 r1 = rateForDays(maxDays);
213             //uint256 r2 = rateForDays(numDays-maxDays);
214             rate = r1.mul(r2)/(10**18);
215         }
216         return; 
217         
218     }
219 
220     uint256 constant public UTC2MYT = 1483200000;
221 
222     function wotDay(uint256 time) public pure returns (uint256) {
223         return (time - UTC2MYT) / (1 days);
224     }
225 
226     // minimum fee is 1 unless same day
227     function calcFees(uint256 start, uint256 end, uint256 startAmount) public view returns (uint256 amount, uint256 fee) {
228         if (startAmount == 0) 
229             return;
230         uint256 numberOfDays = wotDay(end) - wotDay(start);
231         if (numberOfDays == 0) {
232             amount = startAmount;
233             return;
234         }
235         amount = (rateForDays(numberOfDays) * startAmount) / (1 ether);
236         if ((fee == 0) && (amount != 0)) 
237             amount--;
238         fee = startAmount.sub(amount);
239     }
240 }
241 
242 
243 contract Reclaimable is Ownable {
244 	ERC20Basic constant internal RECLAIM_ETHER = ERC20Basic(0x0);
245 
246 	function reclaim(ERC20Basic token)
247         public
248         onlyOwner
249     {
250         address reclaimer = msg.sender;
251         if (token == RECLAIM_ETHER) {
252             reclaimer.transfer(this.balance);
253         } else {
254             uint256 balance = token.balanceOf(this);
255             require(token.transfer(reclaimer, balance));
256         }
257     }
258 }
259 
260 
261 // This is primarity used for the migration. Use in the GBT contract is for convenience
262 contract GBTBasic {
263 
264     struct Balance {
265         uint256 amount;                 // amount through update or transfer
266         uint256 lastUpdated;            // DATE last updated
267         uint256 nextAllocationIndex;    // which allocationsOverTime record contains next update
268         uint256 allocationShare;        // the share of allocationPool that this holder gets (means they hold HGT)
269 	}
270 
271 	/*Creates an array with all balances*/
272 	mapping (address => Balance) public balances;
273 	
274     struct Allocation { 
275         uint256     amount;
276         uint256     date;
277     }
278 	
279 	Allocation[]   public allocationsOverTime;
280 	Allocation[]   public currentAllocations;
281 
282 	function currentAllocationLength() view public returns (uint256) {
283 		return currentAllocations.length;
284 	}
285 
286 	function aotLength() view public returns (uint256) {
287 		return allocationsOverTime.length;
288 	}
289 }
290 
291 
292 contract GoldBackedToken is Ownable, ERC20, Pausable, GBTBasic, Reclaimable {
293 	using SafeMath for uint;
294 
295 	function GoldBackedToken(GoldFees feeCalc, GBTBasic _oldToken) public {
296 		uint delta = 3799997201200178500814753;
297 		feeCalculator = feeCalc;
298         oldToken = _oldToken;
299 		// now migrate the non balance stuff
300 		uint x;
301 		for (x = 0; x < oldToken.aotLength(); x++) {
302 			Allocation memory al;
303 			(al.amount, al.date) = oldToken.allocationsOverTime(x);
304 			allocationsOverTime.push(al);
305 		}
306 		allocationsOverTime[3].amount = allocationsOverTime[3].amount.sub(delta);
307 		for (x = 0; x < oldToken.currentAllocationLength(); x++) {
308 			(al.amount, al.date) = oldToken.currentAllocations(x);
309 			al.amount = al.amount.sub(delta);
310 			currentAllocations.push(al);
311 		}
312 
313 		// 1st Minting : TxHash 0x8ba9175d77ed5d3bbf0ddb3666df496d3789da5aa41e46228df91357d9eae8bd
314 		// amount = 528359800000000000000;
315 		// date = 1512646845;
316 		
317 		// 2nd Minting : TxHash 0xb3ec483dc8cf7dbbe29f4b86bd371702dd0fdaccd91d1b2d57d5e9a18b23d022
318 		// date = 1513855345;
319 		// amount = 1003203581831868623088;
320 
321 		// Get values of first minting at second minting date
322 		// feeCalc(1512646845,1513855345,528359800000000000000) => (527954627221032516031,405172778967483969)
323 
324 		mintedGBT.date = 1515700247;
325 		mintedGBT.amount = 1529313490861692541644;
326 	}
327 
328   function totalSupply() view public returns (uint256) {
329 	  uint256 minted;
330 	  uint256 mFees;
331 	  uint256 uminted;
332 	  uint256 umFees;
333 	  uint256 allocated;
334 	  uint256 aFees;
335 	  (minted,mFees) = calcFees(mintedGBT.date,now,mintedGBT.amount);
336 	  (uminted,umFees) = calcFees(unmintedGBT.date,now,unmintedGBT.amount);
337 	  (allocated,aFees) = calcFees(currentAllocations[0].date,now,currentAllocations[0].amount);
338 	  if (minted+allocated>uminted) {
339 	  	return minted.add(allocated).sub(uminted);
340 	  } else {
341 		return 0;
342 	  }
343   }
344 
345   event Transfer(address indexed from, address indexed to, uint value);
346   event Approval(address indexed owner, address indexed spender, uint value);
347   event DeductFees(address indexed owner,uint256 amount);
348 
349   event TokenMinted(address destination, uint256 amount);
350   event TokenBurned(address source, uint256 amount);
351   
352 	string public name = "GOLDX";
353 	string public symbol = "GOLDX";
354 	uint256 constant public  decimals = 18;  // same as ETH
355 	uint256 constant public  hgtDecimals = 8;
356 		
357 	uint256 constant public allocationPool = 1 * 10**9 * 10**hgtDecimals;      // total HGT holdings
358 	uint256	         public	maxAllocation  = 38 * 10**5 * 10**decimals;			// max GBT that can ever ever be given out
359 	uint256	         public	totAllocation;			// amount of GBT so far
360 	
361 	GoldFees		 public feeCalculator;
362 	address		     public HGT;					// HGT contract address
363 
364 	function updateMaxAllocation(uint256 newMax) public onlyOwner {
365 		require(newMax > 38 * 10**5 * 10**decimals);
366 		maxAllocation = newMax;
367 	}
368 
369 	function setFeeCalculator(GoldFees newFC) public onlyOwner {
370 		feeCalculator = newFC;
371 	}
372 
373 	
374 	// GoldFees needs to take care of Domain Offset - do not do here
375 
376 	function calcFees(uint256 from, uint256 to, uint256 amount) view public returns (uint256 val, uint256 fee) {
377 		return feeCalculator.calcFees(from,to,amount);
378 	}
379 
380 	
381 	mapping (address => mapping (address => uint)) public allowance;
382     mapping (address => bool) updated;
383 
384     GBTBasic oldToken;
385 
386 	function migrateBalance(address where) public {
387 		if (!updated[where]) {
388             uint256 am;
389             uint256 lu;
390             uint256 ne;
391             uint256 al;
392             (am,lu,ne,al) = oldToken.balances(where);
393             balances[where] = Balance(am,lu,ne,al);
394             updated[where] = true;
395         }
396 
397 	}
398 	
399 	function update(address where) internal {
400         uint256 pos;
401 		uint256 fees;
402 		uint256 val;
403 		migrateBalance(where);
404         (val,fees,pos) = updatedBalance(where);
405 	    balances[where].nextAllocationIndex = pos;
406 	    balances[where].amount = val;
407         balances[where].lastUpdated = now;
408 	}
409 	
410 	function updatedBalance(address where) view public returns (uint val, uint fees, uint pos) {
411 		uint256 cVal;
412 		uint256 cFees;
413 		uint256 cAmount;
414 
415         uint256 am;
416         uint256 lu;
417         uint256 ne;
418         uint256 al;
419 		Balance memory bb;
420 
421 		// calculate update of balance in account
422         if (updated[where]) {
423             bb = balances[where];
424             am = bb.amount;
425             lu = bb.lastUpdated;
426             ne = bb.nextAllocationIndex;
427             al = bb.allocationShare;
428         } else {
429             (am,lu,ne,al) = oldToken.balances(where);
430         }
431 		(val,fees) = calcFees(lu,now,am);
432 		// calculate update based on accrued disbursals
433 	    pos = ne;
434 		if ((pos < currentAllocations.length) && (al != 0)) {
435 			cAmount = currentAllocations[ne].amount.mul(al).div( allocationPool);
436 			(cVal,cFees) = calcFees(currentAllocations[ne].date,now,cAmount);
437 		} 
438 	    val = val.add(cVal);
439 		fees = fees.add(cFees);
440 		pos = currentAllocations.length;
441 	}
442 
443     function balanceOf(address where) view public returns (uint256 val) {
444         uint256 fees;
445 		uint256 pos;
446         (val,fees,pos) = updatedBalance(where);
447         return ;
448     }
449 
450 	event GoldAllocation(uint256 amount, uint256 date);
451 	event FeeOnAllocation(uint256 fees, uint256 date);
452 
453 	event PartComplete();
454 	event StillToGo(uint numLeft);
455 	uint256 public partPos;
456 	uint256 public partFees;
457 	uint256 partL;
458 	Allocation[]   public partAllocations;
459 
460 	function partAllocationLength() view public returns (uint) {
461 		return partAllocations.length;
462 	}
463 
464 	function addAllocationPartOne(uint newAllocation,uint numSteps) 
465 		public 
466 		onlyMinter 
467 	{
468 		require(partPos == 0);
469 		uint256 thisAllocation = newAllocation;
470 
471 		require(totAllocation < maxAllocation);		// cannot allocate more than this;
472 
473 		if (currentAllocations.length > partAllocations.length) {
474 			partAllocations = currentAllocations;
475 		}
476 
477 		if (totAllocation + thisAllocation > maxAllocation) {
478 			thisAllocation = maxAllocation.sub(totAllocation);
479 			log0("max alloc reached");
480 		}
481 		totAllocation = totAllocation.add(thisAllocation);
482 
483 		GoldAllocation(thisAllocation,now);
484 
485         Allocation memory newDiv;
486         newDiv.amount = thisAllocation;
487         newDiv.date = now;
488 		// store into history
489 	    allocationsOverTime.push(newDiv);
490 		// add this record to the end of currentAllocations
491 		partL = partAllocations.push(newDiv);
492 		// update all other records with calcs from last record
493 		if (partAllocations.length < 2) { // no fees to consider
494 			PartComplete();
495 			currentAllocations = partAllocations;
496 			FeeOnAllocation(0,now);
497 			return;
498 		}
499 		//
500 		// The only fees that need to be collected are the fees on location zero.
501 		// Since they are the last calculated = they come out with the break
502 		//
503 		for (partPos = partAllocations.length - 2; partPos >= 0; partPos-- ) {
504 			(partAllocations[partPos].amount,partFees) = calcFees(partAllocations[partPos].date,now,partAllocations[partPos].amount);
505 
506 			partAllocations[partPos].amount = partAllocations[partPos].amount.add(partAllocations[partL - 1].amount);
507 			partAllocations[partPos].date = now;
508 			if ((partPos == 0) || (partPos == partAllocations.length-numSteps)) {
509 				break; 
510 			}
511 		}
512 		if (partPos != 0) {
513 			StillToGo(partPos);
514 			return; // not done yet
515 		}
516 		PartComplete();
517 		FeeOnAllocation(partFees,now);
518 		currentAllocations = partAllocations;
519 	}
520 
521 	function addAllocationPartTwo(uint numSteps) 
522 		public 
523 		onlyMinter 
524 	{
525 		require(numSteps > 0);
526 		require(partPos > 0);
527 		for (uint i = 0; i < numSteps; i++ ) {
528 			partPos--;
529 			(partAllocations[partPos].amount,partFees) = calcFees(partAllocations[partPos].date,now,partAllocations[partPos].amount);
530 			partAllocations[partPos].amount = partAllocations[partPos].amount.add(partAllocations[partL - 1].amount);
531 			partAllocations[partPos].date = now;
532 			if (partPos == 0) {
533 				break; 
534 			}
535 		}
536 		if (partPos != 0) {
537 			StillToGo(partPos);
538 			return; // not done yet
539 		}
540 		PartComplete();
541 		FeeOnAllocation(partFees,now);
542 		currentAllocations = partAllocations;
543 	}
544 
545 	function setHGT(address _hgt) public onlyOwner {
546 		HGT = _hgt;
547 	}
548 
549 	function parentFees(address where) public whenNotPaused {
550 		require(msg.sender == HGT);
551 	    update(where);		
552 	}
553 	
554 	function parentChange(address where, uint newValue) public whenNotPaused { // called when HGT balance changes
555 		require(msg.sender == HGT);
556 	    balances[where].allocationShare = newValue;
557 	}
558 	
559 	/* send GBT */
560 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool ok) {
561 		require(_to != address(0));
562 	    update(msg.sender);              // Do this to ensure sender has enough funds.
563 		update(_to); 
564 
565         balances[msg.sender].amount = balances[msg.sender].amount.sub(_value);
566         balances[_to].amount = balances[_to].amount.add(_value);
567 		Transfer(msg.sender, _to, _value); //Notify anyone listening that this transfer took place
568         return true;
569 	}
570 
571 	function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool success) {
572 		require(_to != address(0));
573 		var _allowance = allowance[_from][msg.sender];
574 
575 	    update(_from);              // Do this to ensure sender has enough funds.
576 		update(_to); 
577 
578 		balances[_to].amount = balances[_to].amount.add(_value);
579 		balances[_from].amount = balances[_from].amount.sub(_value);
580 		allowance[_from][msg.sender] = _allowance.sub(_value);
581 		Transfer(_from, _to, _value);
582 		return true;
583 	}
584 
585   	function approve(address _spender, uint _value) public whenNotPaused returns (bool success) {
586 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
587     	allowance[msg.sender][_spender] = _value;
588     	Approval(msg.sender, _spender, _value);
589     	return true;
590   	}
591 
592   /**
593    * approve should be called when allowed[_spender] == 0. To increment
594    * allowed value is better to use this function to avoid 2 calls (and wait until
595    * the first transaction is mined)
596    * From MonolithDAO Token.sol
597    */
598   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
599     allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
600     Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
601     return true;
602   }
603 
604   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
605     uint oldValue = allowance[msg.sender][_spender];
606     if (_subtractedValue > oldValue) {
607       allowance[msg.sender][_spender] = 0;
608     } else {
609       allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
610     }
611     Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
612     return true;
613   }
614 
615   	function allowance(address _owner, address _spender) public view returns (uint remaining) {
616     	return allowance[_owner][_spender];
617   	}
618 
619 	// Minting Functions 
620 	address public authorisedMinter;
621 
622 	function setMinter(address minter) public onlyOwner {
623 		authorisedMinter = minter;
624 	}
625 
626 	modifier onlyMinter() {
627 		require(msg.sender == authorisedMinter);
628 		_;
629 	}
630 
631 	Allocation public mintedGBT;		// minting adds to this one
632 	Allocation public unmintedGBT;		// allocating adds here, burning takes from here if minted is empty
633 	
634 	function mintTokens(address destination, uint256 amount) 
635 		onlyMinter
636 		public 
637 	{
638 		require(msg.sender == authorisedMinter);
639 		update(destination);
640 		balances[destination].amount = balances[destination].amount.add(amount);
641 		TokenMinted(destination,amount);
642 		Transfer(0x0,destination,amount); // ERC20 compliance
643 		//
644 		// TotalAllocation stuff
645 		//
646 		uint256 fees;
647 		(mintedGBT.amount,fees) = calcFees(mintedGBT.date,now,mintedGBT.amount);
648 		mintedGBT.amount = mintedGBT.amount.add(amount);
649 		mintedGBT.date = now;
650 	}
651 
652 	function burnTokens(address source, uint256 amount) 
653 		onlyMinter
654 		public 
655 	{
656 		update(source);
657 		balances[source].amount = balances[source].amount.sub(amount);
658 		TokenBurned(source,amount);
659 		Transfer(source,0x0,amount); // ERC20 compliance
660 		//
661 		// TotalAllocation stuff
662 		//
663 		uint256 fees;
664 		(unmintedGBT.amount,fees) = calcFees(unmintedGBT.date,now,unmintedGBT.amount);
665 		unmintedGBT.date = now;
666 		unmintedGBT.amount = unmintedGBT.amount.add(amount);
667 	}
668 
669 }