1 pragma solidity ^0.4.11;
2 
3 
4 contract DoNotDeployThisGetTheRightOneCosParityPutsThisOnTop {
5     uint256 nothing;
6 
7     function DoNotDeployThisGetTheRightOneCosParityPutsThisOnTop() {
8         nothing = 27;
9     }
10 }
11 
12 
13 //*************** Ownable
14 
15 contract Ownable {
16   address public owner;
17 
18   function Ownable() {
19     owner = msg.sender;
20   }
21 
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     
25     _;
26   }
27 
28   function transferOwnership(address newOwner) onlyOwner {
29     if (newOwner != address(0)) {
30       owner = newOwner;
31     }
32   }
33 
34 }
35 
36 //***********Pausible
37 
38 contract Pausable is Ownable {
39   event Pause();
40   event Unpause();
41 
42   bool public paused = false;
43 
44   /**
45    * @dev modifier to allow actions only when the contract IS paused
46    */
47   modifier whenNotPaused() {
48     require (!paused);
49     _;
50   }
51 
52   /**
53    * @dev modifier to allow actions only when the contract IS NOT paused
54    */
55   modifier whenPaused {
56     require (paused) ;
57     _;
58   }
59 
60   /**
61    * @dev called by the owner to pause, triggers stopped state
62    */
63   function pause() onlyOwner whenNotPaused returns (bool) {
64     paused = true;
65     Pause();
66     return true;
67   }
68 
69   /**
70    * @dev called by the owner to unpause, returns to normal state
71    */
72   function unpause() onlyOwner whenPaused returns (bool) {
73     paused = false;
74     Unpause();
75     return true;
76   }
77 }
78 
79 //*************ERC20
80 
81 contract ERC20 {
82   uint public totalSupply;
83   function balanceOf(address who) constant returns (uint);
84   function allowance(address owner, address spender) constant returns (uint);
85 
86   function transfer(address to, uint value) returns (bool ok);
87   function transferFrom(address from, address to, uint value) returns (bool ok);
88   function approve(address spender, uint value) returns (bool ok);
89   event Transfer(address indexed from, address indexed to, uint value);
90   event Approval(address indexed owner, address indexed spender, uint value);
91 }
92 
93 //*************** SafeMath
94 
95 contract SafeMath {
96   function safeMul(uint a, uint b) internal returns (uint) {
97     uint c = a * b;
98     assert(a == 0 || c / a == b);
99     return c;
100   }
101 
102   function safeDiv(uint a, uint b) internal returns (uint) {
103     assert(b > 0);
104     uint c = a / b;
105     assert(a == b * c + a % b);
106     return c;
107   }
108 
109   function safeSub(uint a, uint b) internal returns (uint) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   function safeAdd(uint a, uint b) internal returns (uint) {
115     uint c = a + b;
116     assert(c>=a && c>=b);
117     return c;
118   }
119 
120   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
121     return a >= b ? a : b;
122   }
123 
124   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
125     return a < b ? a : b;
126   }
127 
128   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
129     return a >= b ? a : b;
130   }
131 
132   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
133     return a < b ? a : b;
134   }
135 
136 }
137 
138 //**************** StandardToken
139 
140 contract StandardToken is ERC20, SafeMath {
141 
142   /**
143    * @dev Fix for the ERC20 short address attack.
144    */
145   modifier onlyPayloadSize(uint size) {
146      require(msg.data.length >= size + 4);
147      _;
148   }
149 
150   mapping(address => uint) balances;
151   mapping (address => mapping (address => uint)) allowed;
152 
153   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)  returns (bool success){
154     balances[msg.sender] = safeSub(balances[msg.sender], _value);
155     balances[_to] = safeAdd(balances[_to], _value);
156     Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {
161     var _allowance = allowed[_from][msg.sender];
162 
163     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
164     // if (_value > _allowance) throw;
165 
166     balances[_to] = safeAdd(balances[_to], _value);
167     balances[_from] = safeSub(balances[_from], _value);
168     allowed[_from][msg.sender] = safeSub(_allowance, _value);
169     Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   function balanceOf(address _owner) constant returns (uint balance) {
174     return balances[_owner];
175   }
176 
177   function approve(address _spender, uint _value) returns (bool success) {
178     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
179     allowed[msg.sender][_spender] = _value;
180     Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   function allowance(address _owner, address _spender) constant returns (uint remaining) {
185     return allowed[_owner][_spender];
186   }
187 
188 }
189 
190 contract GBT {
191   function parentChange(address,uint);
192   function parentFees(address);
193   function setHGT(address _hgt);
194 }
195 
196 //************ HELLOGOLDTOKEN
197 
198 contract HelloGoldToken is ERC20, SafeMath, Pausable, StandardToken {
199 
200   string public name;
201   string public symbol;
202   uint8  public decimals;
203 
204   GBT  goldtoken;
205   
206 
207   function setGBT(address gbt_) onlyOwner {
208     goldtoken = GBT(gbt_);
209   }
210 
211   function GBTAddress() constant returns (address) {
212     return address(goldtoken);
213   }
214 
215   function HelloGoldToken(address _reserve) {
216     name = "HelloGold Token";
217     symbol = "HGT";
218     decimals = 8;
219  
220     totalSupply = 1 * 10 ** 9 * 10 ** uint256(decimals);
221     balances[_reserve] = totalSupply;
222   }
223 
224 
225   function parentChange(address _to) internal {
226     require(address(goldtoken) != 0x0);
227     goldtoken.parentChange(_to,balances[_to]);
228   }
229   function parentFees(address _to) internal {
230     require(address(goldtoken) != 0x0);
231     goldtoken.parentFees(_to);
232   }
233 
234   function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
235     parentFees(_from);
236     parentFees(_to);
237     success = super.transferFrom(_from,_to,_value);
238     parentChange(_from);
239     parentChange(_to);
240     return;
241   }
242 
243   function transfer(address _to, uint _value) whenNotPaused returns (bool success)  {
244     parentFees(msg.sender);
245     parentFees(_to);
246     success = super.transfer(_to,_value);
247     parentChange(msg.sender);
248     parentChange(_to);
249     return;
250   }
251 
252   function approve(address _spender, uint _value) whenNotPaused returns (bool success)  {
253     return super.approve(_spender,_value);
254   }
255 }
256 
257 //********* GOLDFEES ************************
258 
259 contract GoldFees is SafeMath,Ownable {
260     // e.g. if rate = 0.0054
261     //uint rateN = 9999452055;
262     uint rateN = 9999452054794520548;
263     uint rateD = 19;
264     uint public maxDays;
265     uint public maxRate;
266 
267     
268     function GoldFees() {
269         calcMax();
270     }
271 
272     function calcMax() {
273         maxDays = 1;
274         maxRate = rateN;
275         
276         
277         uint pow = 2;
278         do {
279             uint newN = rateN ** pow;
280             if (newN / maxRate != maxRate) {
281                 maxDays = pow / 2;
282                 break;
283             }
284             maxRate = newN;
285             pow *= 2;
286         } while (pow < 2000);
287         
288     }
289 
290     function updateRate(uint256 _n, uint256 _d) onlyOwner{
291         rateN = _n;
292         rateD = _d;
293         calcMax();
294     }
295     
296     function rateForDays(uint256 numDays) constant returns (uint256 rate) {
297         if (numDays <= maxDays) {
298             uint r = rateN ** numDays;
299             uint d = rateD * numDays;
300             if (d > 18) {
301                 uint div =  10 ** (d-18);
302                 rate = r / div;
303             } else {
304                 div = 10 ** (18 - d);
305                 rate = r * div;
306             }
307         } else {
308             uint256 md1 = numDays / 2;
309             uint256 md2 = numDays - md1;
310              uint256 r2;
311 
312             uint256 r1 = rateForDays(md1);
313             if (md1 == md2) {
314                 r2 = r1;
315             } else {
316                 r2 = rateForDays(md2);
317             }
318            
319 
320             //uint256 r1 = rateForDays(maxDays);
321             //uint256 r2 = rateForDays(numDays-maxDays);
322             rate  = safeMul( r1 , r2)  / 10 ** 18;
323         }
324         return; 
325         
326     }
327 
328     uint256 constant public UTC2MYT = 1483200000;
329 
330     function wotDay(uint256 time) returns (uint256) {
331         return (time - UTC2MYT) / (1 days);
332     }
333 
334     // minimum fee is 1 unless same day
335     function calcFees(uint256 start, uint256 end, uint256 startAmount) constant returns (uint256 amount, uint256 fee) {
336         if (startAmount == 0) return;
337         uint256 numberOfDays = wotDay(end) - wotDay(start);
338         if (numberOfDays == 0) {
339             amount = startAmount;
340             return;
341         }
342         amount = (rateForDays(numberOfDays) * startAmount) / (1 ether);
343         if ((fee == 0) && (amount !=  0)) amount--;
344         fee = safeSub(startAmount,amount);
345     }
346 }
347 
348 //******************** GoldBackedToken
349 
350 contract GoldBackedToken is Ownable, SafeMath, ERC20, Pausable {
351 
352   event Transfer(address indexed from, address indexed to, uint value);
353   event Approval(address indexed owner, address indexed spender, uint value);
354   event DeductFees(address indexed owner,uint256 amount);
355 
356   event TokenMinted(address destination, uint256 amount);
357   event TokenBurned(address source, uint256 amount);
358   
359 	string public name = "HelloGold Gold Backed Token";
360 	string public symbol = "GBT";
361 	uint256 constant public  decimals = 18;  // same as ETH
362 	uint256 constant public  hgtDecimals = 8;
363 		
364 	uint256 constant public allocationPool = 1 *  10**9 * 10**hgtDecimals;      // total HGT holdings
365 	uint256	constant public	maxAllocation  = 38 * 10**5 * 10**decimals;			// max GBT that can ever ever be given out
366 	uint256	         public	totAllocation;			// amount of GBT so far
367 	
368 	address			 public feeCalculator;
369 	address		     public HGT;					// HGT contract address
370 
371 
372 
373 	function setFeeCalculator(address newFC) onlyOwner {
374 		feeCalculator = newFC;
375 	}
376 
377 
378 	function calcFees(uint256 from, uint256 to, uint256 amount) returns (uint256 val, uint256 fee) {
379 		return GoldFees(feeCalculator).calcFees(from,to,amount);
380 	}
381 
382 	function GoldBackedToken(address feeCalc) {
383 		feeCalculator = feeCalc;
384 	}
385 
386     struct allocation { 
387         uint256     amount;
388         uint256     date;
389     }
390 	
391 	allocation[]   public allocationsOverTime;
392 	allocation[]   public currentAllocations;
393 
394 	function currentAllocationLength() constant returns (uint256) {
395 		return currentAllocations.length;
396 	}
397 
398 	function aotLength() constant returns (uint256) {
399 		return allocationsOverTime.length;
400 	}
401 
402 	
403     struct Balance {
404         uint256 amount;                 // amount through update or transfer
405         uint256 lastUpdated;            // DATE last updated
406         uint256 nextAllocationIndex;    // which allocationsOverTime record contains next update
407         uint256 allocationShare;        // the share of allocationPool that this holder gets (means they hold HGT)
408     }
409 
410 	/*Creates an array with all balances*/
411 	mapping (address => Balance) public balances;
412 	mapping (address => mapping (address => uint)) allowed;
413 	
414 	function update(address where) internal {
415         uint256 pos;
416 		uint256 fees;
417 		uint256 val;
418         (val,fees,pos) = updatedBalance(where);
419 	    balances[where].nextAllocationIndex = pos;
420 	    balances[where].amount = val;
421         balances[where].lastUpdated = now;
422 	}
423 	
424 	function updatedBalance(address where) constant public returns (uint val, uint fees, uint pos) {
425 		uint256 c_val;
426 		uint256 c_fees;
427 		uint256 c_amount;
428 
429 		(val, fees) = calcFees(balances[where].lastUpdated,now,balances[where].amount);
430 
431 	    pos = balances[where].nextAllocationIndex;
432 		if ((pos < currentAllocations.length) &&  (balances[where].allocationShare != 0)) {
433 
434 			c_amount = currentAllocations[balances[where].nextAllocationIndex].amount * balances[where].allocationShare / allocationPool;
435 
436 			(c_val,c_fees)   = calcFees(currentAllocations[balances[where].nextAllocationIndex].date,now,c_amount);
437 
438 		} 
439 
440 	    val  += c_val;
441 		fees += c_fees;
442 		pos   = currentAllocations.length;
443 	}
444 
445     function balanceOf(address where) constant returns (uint256 val) {
446         uint256 fees;
447 		uint256 pos;
448         (val,fees,pos) = updatedBalance(where);
449         return ;
450     }
451 
452 	event Allocation(uint256 amount, uint256 date);
453 	event FeeOnAllocation(uint256 fees, uint256 date);
454 
455 	event PartComplete();
456 	event StillToGo(uint numLeft);
457 	uint256 public partPos;
458 	uint256 public partFees;
459 	uint256 partL;
460 	allocation[]   public partAllocations;
461 
462 	function partAllocationLength() constant returns (uint) {
463 		return partAllocations.length;
464 	}
465 
466 	function addAllocationPartOne(uint newAllocation,uint numSteps) onlyOwner{
467 		uint256 thisAllocation = newAllocation;
468 
469 		require(totAllocation < maxAllocation);		// cannot allocate more than this;
470 
471 		if (currentAllocations.length > partAllocations.length) {
472 			partAllocations = currentAllocations;
473 		}
474 
475 		if (totAllocation + thisAllocation > maxAllocation) {
476 			thisAllocation = maxAllocation - totAllocation;
477 			log0("max alloc reached");
478 		}
479 		totAllocation += thisAllocation;
480 
481 		Allocation(thisAllocation,now);
482 
483         allocation memory newDiv;
484         newDiv.amount = thisAllocation;
485         newDiv.date = now;
486 		// store into history
487 	    allocationsOverTime.push(newDiv);
488 		// add this record to the end of currentAllocations
489 		partL = partAllocations.push(newDiv);
490 		// update all other records with calcs from last record
491 		if (partAllocations.length < 2) { // no fees to consider
492 			PartComplete();
493 			currentAllocations = partAllocations;
494 			FeeOnAllocation(0,now);
495 			return;
496 		}
497 		//
498 		// The only fees that need to be collected are the fees on location zero.
499 		// Since they are the last calculated = they come out with the break
500 		//
501 		for (partPos = partAllocations.length - 2; partPos >= 0; partPos-- ){
502 			(partAllocations[partPos].amount,partFees) = calcFees(partAllocations[partPos].date,now,partAllocations[partPos].amount);
503 
504 			partAllocations[partPos].amount += partAllocations[partL - 1].amount;
505 			partAllocations[partPos].date    = now;
506 			if ((partPos == 0) || (partPos == partAllocations.length-numSteps)){
507 				break; 
508 			}
509 		}
510 		if (partPos != 0) {
511 			StillToGo(partPos);
512 			return; // not done yet
513 		}
514 		PartComplete();
515 		FeeOnAllocation(partFees,now);
516 		currentAllocations = partAllocations;
517 	}
518 
519 	function addAllocationPartTwo(uint numSteps) onlyOwner {
520 		require(numSteps > 0);
521 		require(partPos > 0);
522 		for (uint i = 0; i < numSteps; i++ ){
523 			partPos--;
524 			(partAllocations[partPos].amount,partFees) = calcFees(partAllocations[partPos].date,now,partAllocations[partPos].amount);
525 
526 			partAllocations[partPos].amount += partAllocations[partL - 1].amount;
527 			partAllocations[partPos].date    = now;
528 			if (partPos == 0) {
529 				break; 
530 			}
531 		}
532 		if (partPos != 0) {
533 			StillToGo(partPos);
534 			return; // not done yet
535 		}
536 		PartComplete();
537 		FeeOnAllocation(partFees,now);
538 		currentAllocations = partAllocations;
539 	}
540 
541 
542 	function setHGT(address _hgt) onlyOwner {
543 		HGT = _hgt;
544 	}
545 
546 	function parentFees(address where) whenNotPaused {
547 		require(msg.sender == HGT);
548 	    update(where);		
549 	}
550 	
551 	function parentChange(address where, uint newValue) whenNotPaused { // called when HGT balance changes
552 		require(msg.sender == HGT);
553 	    balances[where].allocationShare = newValue;
554 	}
555 	
556 	/* send GBT */
557 	function transfer(address _to, uint256 _value) whenNotPaused returns (bool ok) {
558 	    update(msg.sender);              // Do this to ensure sender has enough funds.
559 		update(_to); 
560 
561         balances[msg.sender].amount = safeSub(balances[msg.sender].amount, _value);
562         balances[_to].amount = safeAdd(balances[_to].amount, _value);
563 
564 		Transfer(msg.sender, _to, _value); //Notify anyone listening that this transfer took place
565         return true;
566 	}
567 
568 	function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool success) {
569 		var _allowance = allowed[_from][msg.sender];
570 
571 	    update(_from);              // Do this to ensure sender has enough funds.
572 		update(_to); 
573 
574 		balances[_to].amount = safeAdd(balances[_to].amount, _value);
575 		balances[_from].amount = safeSub(balances[_from].amount, _value);
576 		allowed[_from][msg.sender] = safeSub(_allowance, _value);
577 		Transfer(_from, _to, _value);
578 		return true;
579 	}
580 
581   	function approve(address _spender, uint _value) whenNotPaused returns (bool success) {
582 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
583     	allowed[msg.sender][_spender] = _value;
584     	Approval(msg.sender, _spender, _value);
585     	return true;
586   	}
587 
588   	function allowance(address _owner, address _spender) constant returns (uint remaining) {
589     	return allowed[_owner][_spender];
590   	}
591 
592 	// Minting Functions 
593 	address public authorisedMinter;
594 
595 	function setMinter(address minter) onlyOwner {
596 		authorisedMinter = minter;
597 	}
598 	
599 	function mintTokens(address destination, uint256 amount) {
600 		require(msg.sender == authorisedMinter);
601 		update(destination);
602 		balances[destination].amount = safeAdd(balances[destination].amount, amount);
603 		balances[destination].lastUpdated = now;
604 		balances[destination].nextAllocationIndex = currentAllocations.length;
605 		TokenMinted(destination,amount);
606 	}
607 
608 	function burnTokens(address source, uint256 amount) {
609 		require(msg.sender == authorisedMinter);
610 		update(source);
611 		balances[source].amount = safeSub(balances[source].amount,amount);
612 		balances[source].lastUpdated = now;
613 		balances[source].nextAllocationIndex = currentAllocations.length;
614 		TokenBurned(source,amount);
615 	}
616 }
617 
618 //**************** HelloGoldSale
619 
620 contract HelloGoldSale is Pausable, SafeMath {
621 
622   uint256 public decimals = 8;
623 
624   uint256 public startDate = 1503892800;      // Monday, August 28, 2017 12:00:00 PM GMT+08:00
625   uint256 public endDate   = 1504497600;      // Monday, September 4, 2017 12:00:00 PM GMT+08:00
626 
627   uint256 tranchePeriod = 1 weeks;
628 
629   // address of HGT Token. HGT must Approve this contract to disburse 180M tokens
630   HelloGoldToken          token;
631 
632   uint256 constant MaxCoinsR1      =  80 * 10**6 * 10**8;   // 180M HGT
633   uint256 public coinsRemaining    =  80 * 10**6 * 10**8; 
634   uint256 coinsPerTier             =  16 * 10**6 * 10**8;   // 40M HGT
635   uint256 public coinsLeftInTier   =  16 * 10**6 * 10**8;
636 
637   uint256 public minimumCap        =  0;    // presale achieved
638 
639   uint256 numTiers               = 5;
640   uint16  public tierNo;
641   uint256 public preallocCoins;   // used for testing against cap (inc placement)
642   uint256 public purchasedCoins;  // used for testing against tier pricing
643   uint256 public ethRaised;
644   uint256 public personalMax     = 10 ether;     // max ether per person during public sale
645   uint256 public contributors;
646 
647   address public cs;
648   address public multiSig;
649   address public HGT_Reserve;
650   
651   struct csAction  {
652       bool        passedKYC;
653       bool        blocked;
654   }
655 
656   /* This creates an array with all balances */
657   mapping (address => csAction) public permissions;
658   mapping (address => uint256)  public deposits;
659 
660   modifier MustBeEnabled(address x) {
661       require (!permissions[x].blocked) ;
662       require (permissions[x].passedKYC) ;
663       
664       _;
665   }
666 
667   function HelloGoldSale(address _cs, address _hgt, address _multiSig, address _reserve) {
668     cs          = _cs;
669     token       = HelloGoldToken(_hgt);
670     multiSig    = _multiSig;
671     HGT_Reserve = _reserve;
672   }
673 
674   // We only expect to use this to set/reset the start of the contract under exceptional circumstances
675   function setStart(uint256 when_) onlyOwner {
676       startDate = when_;
677       endDate = when_ + tranchePeriod;
678   }
679 
680   modifier MustBeCs() {
681       require (msg.sender == cs) ;
682       
683       _;
684   }
685 
686 
687   // 1 ether = N HGT tokens 
688   uint256[5] public hgtRates = [1248900000000,1196900000000,1144800000000,1092800000000,1040700000000];
689                       
690 
691     /* Approve the account for operation */
692     function approve(address user) MustBeCs {
693         permissions[user].passedKYC = true;
694     }
695     
696     function block(address user) MustBeCs {
697         permissions[user].blocked = true;
698     }
699 
700     function unblock(address user) MustBeCs {
701          permissions[user].blocked = false;
702     }
703 
704     function newCs(address newCs) onlyOwner {
705         cs = newCs;
706     }
707 
708     function setPeriod(uint256 period_) onlyOwner {
709         require (!funding()) ;
710         tranchePeriod = period_;
711         endDate = startDate + tranchePeriod;
712         if (endDate < now + tranchePeriod) {
713             endDate = now + tranchePeriod;
714         }
715     }
716 
717     function when()  constant returns (uint256) {
718         return now;
719     }
720 
721   function funding() constant returns (bool) {     
722     if (paused) return false;               // frozen
723     if (now < startDate) return false;      // too early
724     if (now > endDate) return false;        // too late
725     if (coinsRemaining == 0) return false;  // no more coins
726     if (tierNo >= numTiers ) return false;  // passed end of top tier. Tiers start at zero
727     return true;
728   }
729 
730   function success() constant returns (bool succeeded) {
731     if (coinsRemaining == 0) return true;
732     bool complete = (now > endDate) ;
733     bool didOK = (coinsRemaining <= (MaxCoinsR1 - minimumCap)); // not even 40M Gone?? Aargh.
734     succeeded = (complete && didOK)  ;  // (out of steam but enough sold) 
735     return ;
736   }
737 
738   function failed() constant returns (bool didNotSucceed) {
739     bool complete = (now > endDate  );
740     bool didBad = (coinsRemaining > (MaxCoinsR1 - minimumCap));
741     didNotSucceed = (complete && didBad);
742     return;
743   }
744 
745   
746   function () payable MustBeEnabled(msg.sender) whenNotPaused {    
747     createTokens(msg.sender,msg.value);
748   }
749 
750   function linkCoin(address coin) onlyOwner {
751     token = HelloGoldToken(coin);
752   }
753 
754   function coinAddress() constant returns (address) {
755       return address(token);
756   }
757 
758   // hgtRates in whole tokens per ETH
759   // max individual contribution in whole ETH
760   function setHgtRates(uint256 p0,uint256 p1,uint256 p2,uint256 p3,uint256 p4, uint256 _max ) onlyOwner {
761               require (now < startDate) ;
762               hgtRates[0]   = p0 * 10**8;
763               hgtRates[1]   = p1 * 10**8;
764               hgtRates[2]   = p2 * 10**8;
765               hgtRates[3]   = p3 * 10**8;
766               hgtRates[4]   = p4 * 10**8;
767               personalMax = _max * 1 ether;           // max ETH per person
768   }
769 
770   
771   event Purchase(address indexed buyer, uint256 level,uint256 value, uint256 tokens);
772   event Reduction(string msg, address indexed buyer, uint256 wanted, uint256 allocated);
773   event MaxFunds(address sender, uint256 taken, uint256 returned);
774   
775   function createTokens(address recipient, uint256 value) private {
776     uint256 totalTokens;
777     uint256 hgtRate;
778     require (funding()) ;
779     require (value >= 1 finney) ;
780     require (deposits[recipient] < personalMax);
781 
782     uint256 maxRefund = 0;
783     if ((deposits[recipient] + value) > personalMax) {
784         maxRefund = deposits[recipient] + value - personalMax;
785         value -= maxRefund;
786         MaxFunds(recipient,value,maxRefund);
787     }  
788 
789     uint256 val = value;
790 
791     ethRaised = safeAdd(ethRaised,value);
792     if (deposits[recipient] == 0) contributors++;
793     
794     
795     do {
796       hgtRate = hgtRates[tierNo];                 // hgtRate must include the 10^8
797       uint tokens = safeMul(val, hgtRate);      // (val in eth * 10^18) * #tokens per eth
798       tokens = safeDiv(tokens, 1 ether);      // val is in ether, msg.value is in wei
799    
800       if (tokens <= coinsLeftInTier) {
801         uint256 actualTokens = tokens;
802         uint refund = 0;
803         if (tokens > coinsRemaining) { //can't sell desired # tokens
804             Reduction("in tier",recipient,tokens,coinsRemaining);
805             actualTokens = coinsRemaining;
806             refund = safeSub(tokens, coinsRemaining ); // refund amount in tokens
807             refund = safeDiv(refund*1 ether,hgtRate );  // refund amount in ETH
808             // need a refund mechanism here too
809             coinsRemaining = 0;
810             val = safeSub( val,refund);
811         } else {
812             coinsRemaining  = safeSub(coinsRemaining,  actualTokens);
813         }
814         purchasedCoins  = safeAdd(purchasedCoins, actualTokens);
815 
816         totalTokens = safeAdd(totalTokens,actualTokens);
817 
818         require (token.transferFrom(HGT_Reserve, recipient,totalTokens)) ;
819 
820         Purchase(recipient,tierNo,val,actualTokens); // event
821 
822         deposits[recipient] = safeAdd(deposits[recipient],val); // in case of refund - could pull off etherscan
823         refund += maxRefund;
824         if (refund > 0) {
825             ethRaised = safeSub(ethRaised,refund);
826             recipient.transfer(refund);
827         }
828         if (coinsRemaining <= (MaxCoinsR1 - minimumCap)){ // has passed success criteria
829             if (!multiSig.send(this.balance)) {                // send funds to HGF
830                 log0("cannot forward funds to owner");
831             }
832         }
833         coinsLeftInTier = safeSub(coinsLeftInTier,actualTokens);
834         if ((coinsLeftInTier == 0) && (coinsRemaining != 0)) { // exact sell out of non final tier
835             coinsLeftInTier = coinsPerTier;
836             tierNo++;
837             endDate = now + tranchePeriod;
838         }
839         return;
840       }
841       // check that coinsLeftInTier >= coinsRemaining
842 
843       uint256 coins2buy = min256(coinsLeftInTier , coinsRemaining); 
844 
845       endDate = safeAdd( now, tranchePeriod);
846       // Have bumped levels - need to modify end date here
847       purchasedCoins = safeAdd(purchasedCoins, coins2buy);  // give all coins remaining in this tier
848       totalTokens    = safeAdd(totalTokens,coins2buy);
849       coinsRemaining = safeSub(coinsRemaining,coins2buy);
850 
851       uint weiCoinsLeftInThisTier = safeMul(coins2buy,1 ether);
852       uint costOfTheseCoins = safeDiv(weiCoinsLeftInThisTier, hgtRate);  // how much did that cost?
853 
854       Purchase(recipient, tierNo,costOfTheseCoins,coins2buy); // event
855 
856       deposits[recipient] = safeAdd(deposits[recipient],costOfTheseCoins);
857       val    = safeSub(val,costOfTheseCoins);
858       tierNo = tierNo + 1;
859       coinsLeftInTier = coinsPerTier;
860     } while ((val > 0) && funding());
861 
862     // escaped because we passed the end of the universe.....
863     // so give them their tokens
864     require (token.transferFrom(HGT_Reserve, recipient,totalTokens)) ;
865 
866     if ((val > 0) || (maxRefund > 0)){
867         Reduction("finished crowdsale, returning ",recipient,value,totalTokens);
868         // return the remainder !
869         recipient.transfer(val+maxRefund); // if you can't return the balance, abort whole process
870     }
871     if (!multiSig.send(this.balance)) {
872         ethRaised = safeSub(ethRaised,this.balance);
873         log0("cannot send at tier jump");
874     }
875   }
876   
877   function allocatedTokens(address grantee, uint256 numTokens) onlyOwner {
878     require (now < startDate) ;
879     if (numTokens < coinsRemaining) {
880         coinsRemaining = safeSub(coinsRemaining, numTokens);
881        
882     } else {
883         numTokens = coinsRemaining;
884         coinsRemaining = 0;
885     }
886     preallocCoins = safeAdd(preallocCoins,numTokens);
887     require (token.transferFrom(HGT_Reserve,grantee,numTokens));
888   }
889 
890   function withdraw() { // it failed. Come and get your ether.
891       if (failed()) {
892           if (deposits[msg.sender] > 0) {
893               uint256 val = deposits[msg.sender];
894               deposits[msg.sender] = 0;
895               msg.sender.transfer(val);
896           }
897       }
898   }
899 
900   function complete() onlyOwner {  // this should not have to be called. Extreme measures.
901       if (success()) {
902           uint256 val = this.balance;
903           if (val > 0) {
904             if (!multiSig.send(val)) {
905                 log0("cannot withdraw");
906             } else {
907                 log0("funds withdrawn");
908             }
909           } else {
910               log0("nothing to withdraw");
911           }
912       }
913   }
914 
915 }