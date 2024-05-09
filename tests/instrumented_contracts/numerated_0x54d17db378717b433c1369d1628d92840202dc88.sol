1 pragma solidity ^0.4.19;
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
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 
47 
48 
49 
50 
51 
52 
53 
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   uint256 totalSupply_;
80 
81   /**
82   * @dev total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95     require(_value <= balances[msg.sender]);
96 
97     // SafeMath.sub will throw if there is not enough balance.
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256 balance) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 
116 
117 
118 
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 contract ERC20 is ERC20Basic {
125   function allowance(address owner, address spender) public view returns (uint256);
126   function transferFrom(address from, address to, uint256 value) public returns (bool);
127   function approve(address spender, uint256 value) public returns (bool);
128   event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142   mapping (address => mapping (address => uint256)) internal allowed;
143 
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint256 the amount of tokens to be transferred
150    */
151   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[_from]);
154     require(_value <= allowed[_from][msg.sender]);
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    *
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     allowed[msg.sender][_spender] = _value;
175     Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(address _owner, address _spender) public view returns (uint256) {
186     return allowed[_owner][_spender];
187   }
188 
189   /**
190    * @dev Increase the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To increment
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _addedValue The amount of tokens to increase the allowance by.
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   /**
206    * @dev Decrease the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To decrement
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _subtractedValue The amount of tokens to decrease the allowance by.
214    */
215   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
216     uint oldValue = allowed[msg.sender][_spender];
217     if (_subtractedValue > oldValue) {
218       allowed[msg.sender][_spender] = 0;
219     } else {
220       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221     }
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226 }
227 
228 
229 
230 
231 contract GigERC20 is StandardToken, Ownable {
232     /* Public variables of the token */
233     uint256 public creationBlock;
234 
235     uint8 public decimals;
236 
237     string public name;
238 
239     string public symbol;
240 
241     string public standard;
242 
243     bool public locked;
244 
245     /* Initializes contract with initial supply tokens to the creator of the contract */
246     function GigERC20(
247         uint256 _totalSupply,
248         string _tokenName,
249         uint8 _decimalUnits,
250         string _tokenSymbol,
251         bool _transferAllSupplyToOwner,
252         bool _locked
253     ) public {
254         standard = 'ERC20 0.1';
255         locked = _locked;
256         totalSupply_ = _totalSupply;
257 
258         if (_transferAllSupplyToOwner) {
259             balances[msg.sender] = totalSupply_;
260         } else {
261             balances[this] = totalSupply_;
262         }
263         name = _tokenName;
264         // Set the name for display purposes
265         symbol = _tokenSymbol;
266         // Set the symbol for display purposes
267         decimals = _decimalUnits;
268         // Amount of decimals for display purposes
269         creationBlock = block.number;
270     }
271 
272     function setLocked(bool _locked) public onlyOwner {
273         locked = _locked;
274     }
275 
276     /* public methods */
277     function transfer(address _to, uint256 _value) public returns (bool) {
278         require(locked == false);
279         return super.transfer(_to, _value);
280     }
281 
282     function approve(address _spender, uint256 _value) public returns (bool success) {
283         if (locked) {
284             return false;
285         }
286         return super.approve(_spender, _value);
287     }
288 
289     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
290         if (locked) {
291             return false;
292         }
293         return super.increaseApproval(_spender, _addedValue);
294     }
295 
296     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
297         if (locked) {
298             return false;
299         }
300         return super.decreaseApproval(_spender, _subtractedValue);
301     }
302 
303     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
304         if (locked) {
305             return false;
306         }
307 
308         return super.transferFrom(_from, _to, _value);
309     }
310 
311 }
312 
313 
314 
315 
316 /**
317  * @title SafeMath
318  * @dev Math operations with safety checks that throw on error
319  */
320 library SafeMath {
321 
322   /**
323   * @dev Multiplies two numbers, throws on overflow.
324   */
325   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
326     if (a == 0) {
327       return 0;
328     }
329     uint256 c = a * b;
330     assert(c / a == b);
331     return c;
332   }
333 
334   /**
335   * @dev Integer division of two numbers, truncating the quotient.
336   */
337   function div(uint256 a, uint256 b) internal pure returns (uint256) {
338     // assert(b > 0); // Solidity automatically throws when dividing by 0
339     uint256 c = a / b;
340     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
341     return c;
342   }
343 
344   /**
345   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
346   */
347   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
348     assert(b <= a);
349     return a - b;
350   }
351 
352   /**
353   * @dev Adds two numbers, throws on overflow.
354   */
355   function add(uint256 a, uint256 b) internal pure returns (uint256) {
356     uint256 c = a + b;
357     assert(c >= a);
358     return c;
359   }
360 }
361 
362 
363 
364 /*
365 This contract manages the minters and the modifier to allow mint to happen only if called by minters
366 This contract contains basic minting functionality though
367 */
368 contract MintingERC20 is GigERC20 {
369 
370     using SafeMath for uint256;
371 
372     //Variables
373     mapping (address => bool) public minters;
374 
375     uint256 public maxSupply;
376 
377     //Modifiers
378     modifier onlyMinters () {
379         require(true == minters[msg.sender]);
380         _;
381     }
382 
383     function MintingERC20(
384         uint256 _initialSupply,
385         uint256 _maxSupply,
386         string _tokenName,
387         uint8 _decimals,
388         string _symbol,
389         bool _transferAllSupplyToOwner,
390         bool _locked
391     )
392         public GigERC20(_initialSupply, _tokenName, _decimals, _symbol, _transferAllSupplyToOwner, _locked)
393     {
394         standard = 'MintingERC20 0.1';
395         minters[msg.sender] = true;
396         maxSupply = _maxSupply;
397     }
398 
399     function addMinter(address _newMinter) public onlyOwner {
400         minters[_newMinter] = true;
401     }
402 
403     function removeMinter(address _minter) public onlyOwner {
404         minters[_minter] = false;
405     }
406 
407     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
408         if (true == locked) {
409             return uint256(0);
410         }
411 
412         if (_amount == uint256(0)) {
413             return uint256(0);
414         }
415 
416         if (totalSupply_.add(_amount) > maxSupply) {
417             return uint256(0);
418         }
419 
420         totalSupply_ = totalSupply_.add(_amount);
421         balances[_addr] = balances[_addr].add(_amount);
422         Transfer(address(0), _addr, _amount);
423 
424         return _amount;
425     }
426 
427 }
428 
429 
430 
431 /*
432     Tests:
433     - check that created token has correct name, symbol, decimals, locked, maxSupply
434     - check that setPrivateSale updates privateSale, and not affects crowdSaleEndTime
435     - check that setCrowdSale updates crowdSale, and changes crowdSaleEndTime
436     - check that trasnferFrom, approve, increaseApproval, decreaseApproval are forbidden to call before end of ICO
437     - check that burn is not allowed to call before end of CrowdSale
438     - check that increaseLockedBalance only increases investor locked amount
439     - check that isTransferAllowed failed if transferFrozen
440     - check that isTransferAllowed failed if user has not enough unlocked balance
441     - check that isTransferAllowed failed if user has not enough unlocked balance, after transfering enough tokens balance
442     - check that isTransferAllowed succeed if user has enough unlocked balance
443     - check that isTransferAllowed succeed if user has enough unlocked balance, after transfering enough tokens balance
444 */
445 
446 contract GigToken is MintingERC20 {
447     SellableToken public crowdSale; // Pre ICO & ICO
448     SellableToken public privateSale;
449 
450     bool public transferFrozen = false;
451 
452     uint256 public crowdSaleEndTime;
453 
454     mapping(address => uint256) public lockedBalancesReleasedAfterOneYear;
455 
456     modifier onlyCrowdSale() {
457         require(crowdSale != address(0) && msg.sender == address(crowdSale));
458 
459         _;
460     }
461 
462     modifier onlySales() {
463         require((privateSale != address(0) && msg.sender == address(privateSale)) ||
464             (crowdSale != address(0) && msg.sender == address(crowdSale)));
465 
466         _;
467     }
468 
469     event MaxSupplyBurned(uint256 burnedTokens);
470 
471     function GigToken(bool _locked) public
472         MintingERC20(0, maxSupply, 'GigBit', 18, 'GBTC', false, _locked)
473     {
474         standard = 'GBTC 0.1';
475 
476         maxSupply = uint256(1000000000).mul(uint256(10) ** decimals);
477     }
478 
479     function setCrowdSale(address _crowdSale) public onlyOwner {
480         require(_crowdSale != address(0));
481 
482         crowdSale = SellableToken(_crowdSale);
483 
484         crowdSaleEndTime = crowdSale.endTime();
485     }
486 
487     function setPrivateSale(address _privateSale) public onlyOwner {
488         require(_privateSale != address(0));
489 
490         privateSale = SellableToken(_privateSale);
491     }
492 
493     function freezing(bool _transferFrozen) public onlyOwner {
494         transferFrozen = _transferFrozen;
495     }
496 
497     function isTransferAllowed(address _from, uint256 _value) public view returns (bool status) {
498         uint256 senderBalance = balanceOf(_from);
499         if (transferFrozen == true || senderBalance < _value) {
500             return false;
501         }
502 
503         uint256 lockedBalance = lockedBalancesReleasedAfterOneYear[_from];
504 
505         // check if holder tries to transfer more than locked tokens
506     if (lockedBalance > 0 && senderBalance.sub(_value) < lockedBalance) {
507             uint256 unlockTime = crowdSaleEndTime + 1 years;
508 
509             // fail if unlock time is not come
510             if (crowdSaleEndTime == 0 || block.timestamp < unlockTime) {
511                 return false;
512             }
513 
514             uint256 secsFromUnlock = block.timestamp.sub(unlockTime);
515 
516             // number of months over from unlock
517             uint256 months = secsFromUnlock / 30 days;
518 
519             if (months > 12) {
520                 months = 12;
521             }
522 
523             uint256 tokensPerMonth = lockedBalance / 12;
524 
525             uint256 unlockedBalance = tokensPerMonth.mul(months);
526 
527             uint256 actualLockedBalance = lockedBalance.sub(unlockedBalance);
528 
529             if (senderBalance.sub(_value) < actualLockedBalance) {
530                 return false;
531             }
532         }
533 
534         if (block.timestamp < crowdSaleEndTime &&
535             crowdSale != address(0) &&
536             crowdSale.isTransferAllowed(_from, _value) == false
537         ) {
538             return false;
539         }
540 
541 
542         return true;
543     }
544 
545     function transfer(address _to, uint _value) public returns (bool) {
546         require(isTransferAllowed(msg.sender, _value));
547 
548         return super.transfer(_to, _value);
549     }
550 
551     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
552         // transferFrom & approve are disabled before end of ICO
553         require((crowdSaleEndTime <= block.timestamp) && isTransferAllowed(_from, _value));
554 
555         return super.transferFrom(_from, _to, _value);
556     }
557 
558     function approve(address _spender, uint256 _value) public returns (bool success) {
559         // transferFrom & approve are disabled before end of ICO
560 
561         require(crowdSaleEndTime <= block.timestamp);
562 
563         return super.approve(_spender, _value);
564     }
565 
566     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
567         // transferFrom & approve are disabled before end of ICO
568 
569         require(crowdSaleEndTime <= block.timestamp);
570 
571         return super.increaseApproval(_spender, _addedValue);
572     }
573 
574     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
575         // transferFrom & approve are disabled before end of ICO
576 
577         require(crowdSaleEndTime <= block.timestamp);
578 
579         return super.decreaseApproval(_spender, _subtractedValue);
580     }
581 
582     function increaseLockedBalance(address _address, uint256 _tokens) public onlySales {
583         lockedBalancesReleasedAfterOneYear[_address] =
584             lockedBalancesReleasedAfterOneYear[_address].add(_tokens);
585     }
586 
587     // burn tokens if soft cap is not reached
588     function burnInvestorTokens(
589         address _address,
590         uint256 _amount
591     ) public onlyCrowdSale returns (uint256) {
592         require(block.timestamp > crowdSaleEndTime);
593 
594         require(_amount <= balances[_address]);
595 
596         balances[_address] = balances[_address].sub(_amount);
597 
598         totalSupply_ = totalSupply_.sub(_amount);
599 
600         Transfer(_address, address(0), _amount);
601 
602         return _amount;
603     }
604 
605     // decrease max supply of tokens that are not sold
606     function burnUnsoldTokens(uint256 _amount) public onlyCrowdSale {
607         require(block.timestamp > crowdSaleEndTime);
608 
609         maxSupply = maxSupply.sub(_amount);
610 
611         MaxSupplyBurned(_amount);
612     }
613 }
614 
615 
616 
617 
618 
619 
620 
621 
622 contract Multivest is Ownable {
623 
624     using SafeMath for uint256;
625 
626     /* public variables */
627     mapping (address => bool) public allowedMultivests;
628 
629     /* events */
630     event MultivestSet(address multivest);
631 
632     event MultivestUnset(address multivest);
633 
634     event Contribution(address holder, uint256 value, uint256 tokens);
635 
636     modifier onlyAllowedMultivests(address _addresss) {
637         require(allowedMultivests[_addresss] == true);
638         _;
639     }
640 
641     /* constructor */
642     function Multivest() public {}
643 
644     function setAllowedMultivest(address _address) public onlyOwner {
645         allowedMultivests[_address] = true;
646         MultivestSet(_address);
647     }
648 
649     function unsetAllowedMultivest(address _address) public onlyOwner {
650         allowedMultivests[_address] = false;
651         MultivestUnset(_address);
652     }
653 
654     function multivestBuy(address _address, uint256 _value) public onlyAllowedMultivests(msg.sender) {
655         require(buy(_address, _value) == true);
656     }
657 
658     function multivestBuy(
659         address _address,
660         uint8 _v,
661         bytes32 _r,
662         bytes32 _s
663     ) public payable onlyAllowedMultivests(verify(keccak256(msg.sender), _v, _r, _s)) {
664         require(_address == msg.sender && buy(msg.sender, msg.value) == true);
665     }
666 
667     function verify(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns (address) {
668         bytes memory prefix = '\x19Ethereum Signed Message:\n32';
669 
670         return ecrecover(keccak256(prefix, _hash), _v, _r, _s);
671     }
672 
673     function buy(address _address, uint256 _value) internal returns (bool);
674 
675 }
676 
677 
678 
679 contract SellableToken is Multivest {
680     uint256 public constant MONTH_IN_SEC = 2629743;
681     GigToken public token;
682 
683     uint256 public minPurchase = 100 * 10 ** 5;
684     uint256 public maxPurchase;
685 
686     uint256 public softCap;
687     uint256 public hardCap;
688 
689     uint256 public startTime;
690     uint256 public endTime;
691 
692     uint256 public maxTokenSupply;
693 
694     uint256 public soldTokens;
695 
696     uint256 public collectedEthers;
697 
698     address public etherHolder;
699 
700     uint256 public collectedUSD;
701 
702     uint256 public etherPriceInUSD;
703     uint256 public priceUpdateAt;
704 
705     mapping(address => uint256) public etherBalances;
706 
707     Tier[] public tiers;
708 
709     struct Tier {
710         uint256 discount;
711         uint256 startTime;
712         uint256 endTime;
713     }
714 
715     event Refund(address _holder, uint256 _ethers, uint256 _tokens);
716     event NewPriceTicker(string _price);
717 
718     function SellableToken(
719         address _token,
720         address _etherHolder,
721         uint256 _startTime,
722         uint256 _endTime,
723         uint256 _maxTokenSupply,
724         uint256 _etherPriceInUSD
725     )
726     public Multivest()
727     {
728         require(_token != address(0) && _etherHolder != address(0));
729         token = GigToken(_token);
730 
731         require(_startTime < _endTime);
732         etherHolder = _etherHolder;
733         require((_maxTokenSupply == uint256(0)) || (_maxTokenSupply <= token.maxSupply()));
734 
735         startTime = _startTime;
736         endTime = _endTime;
737         maxTokenSupply = _maxTokenSupply;
738         etherPriceInUSD = _etherPriceInUSD;
739 
740         priceUpdateAt = block.timestamp;
741     }
742 
743     function setTokenContract(address _token) public onlyOwner {
744         require(_token != address(0));
745         token = GigToken(_token);
746     }
747 
748     function setEtherHolder(address _etherHolder) public onlyOwner {
749         if (_etherHolder != address(0)) {
750             etherHolder = _etherHolder;
751         }
752     }
753 
754     function setPurchaseLimits(uint256 _min, uint256 _max) public onlyOwner {
755         if (_min < _max) {
756             minPurchase = _min;
757             maxPurchase = _max;
758         }
759     }
760 
761     function mint(address _address, uint256 _tokenAmount) public onlyOwner returns (uint256) {
762         return mintInternal(_address, _tokenAmount);
763     }
764 
765     function isActive() public view returns (bool);
766 
767     function isTransferAllowed(address _from, uint256 _value) public view returns (bool);
768 
769     function withinPeriod() public view returns (bool);
770 
771     function getMinEthersInvestment() public view returns (uint256) {
772         return uint256(1 ether).mul(minPurchase).div(etherPriceInUSD);
773     }
774 
775     function calculateTokensAmount(uint256 _value) public view returns (uint256 tokenAmount, uint256 usdAmount);
776 
777     function calculateEthersAmount(uint256 _tokens) public view returns (uint256 ethers, uint256 bonus);
778 
779     function updatePreICOMaxTokenSupply(uint256 _amount) public;
780 
781     // set ether price in USD with 5 digits after the decimal point
782     //ex. 308.75000
783     //for updating the price through  multivest
784     function setEtherInUSD(string _price) public onlyAllowedMultivests(msg.sender) {
785         bytes memory bytePrice = bytes(_price);
786         uint256 dot = bytePrice.length.sub(uint256(6));
787 
788         // check if dot is in 6 position  from  the last
789         require(0x2e == uint(bytePrice[dot]));
790 
791         uint256 newPrice = uint256(10 ** 23).div(parseInt(_price, 5));
792 
793         require(newPrice > 0);
794 
795         etherPriceInUSD = parseInt(_price, 5);
796 
797         priceUpdateAt = block.timestamp;
798 
799         NewPriceTicker(_price);
800     }
801 
802     function mintInternal(address _address, uint256 _tokenAmount) internal returns (uint256) {
803         uint256 mintedAmount = token.mint(_address, _tokenAmount);
804 
805         require(mintedAmount == _tokenAmount);
806 
807         soldTokens = soldTokens.add(_tokenAmount);
808         if (maxTokenSupply > 0) {
809             require(maxTokenSupply >= soldTokens);
810         }
811 
812         return _tokenAmount;
813     }
814 
815     function transferEthers() internal;
816 
817     function parseInt(string _a, uint _b) internal pure returns (uint) {
818         bytes memory bresult = bytes(_a);
819         uint res = 0;
820         bool decimals = false;
821         for (uint i = 0; i < bresult.length; i++) {
822             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
823                 if (decimals) {
824                     if (_b == 0) break;
825                     else _b--;
826                 }
827                 res *= 10;
828                 res += uint(bresult[i]) - 48;
829             } else if (bresult[i] == 46) decimals = true;
830         }
831         if (_b > 0) res *= 10 ** _b;
832         return res;
833     }
834 }
835 
836 
837 contract CrowdSale is SellableToken {
838     uint256 public constant PRE_ICO_TIER_FIRST = 0;
839     uint256 public constant PRE_ICO_TIER_LAST = 4;
840     uint256 public constant ICO_TIER_FIRST = 5;
841     uint256 public constant ICO_TIER_LAST = 8;
842 
843     SellableToken public privateSale;
844 
845     uint256 public price;
846 
847     Stats public preICOStats;
848     mapping(address => uint256) public icoBalances;
849 
850     struct Stats {
851         uint256 soldTokens;
852         uint256 maxTokenSupply;
853         uint256 collectedUSD;
854         uint256 collectedEthers;
855         bool burned;
856     }
857 
858     function CrowdSale(
859         address _token,
860         address _etherHolder,
861         uint256 _maxPreICOTokenSupply,
862     //10000000000000000000000000-527309544043097299200271 + 177500000000000000000000000 = 186972690455956902700799729
863         uint256 _maxICOTokenSupply, //62500000000000000000000000
864         uint256 _price,
865         uint256[2] _preIcoDuration, //1530432000  -1533081599
866         uint256[2] _icoDuration, // 1533110400 - 1538351999
867         uint256 _etherPriceInUSD
868     ) public
869     SellableToken(
870         _token,
871         _etherHolder,
872             _preIcoDuration[0],
873             _icoDuration[1],
874         _maxPreICOTokenSupply.add(_maxICOTokenSupply),
875         _etherPriceInUSD
876     ) {
877         softCap = 250000000000;
878         hardCap = 3578912800000;
879         price = _price;
880         preICOStats.maxTokenSupply = _maxPreICOTokenSupply;
881         //0.2480* 10^5
882         //PreICO
883         tiers.push(
884             Tier(
885                 uint256(65),
886                 _preIcoDuration[0],
887                 _preIcoDuration[0].add(1 hours)
888             )
889         );
890         tiers.push(
891             Tier(
892                 uint256(60),
893                 _preIcoDuration[0].add(1 hours),
894                 _preIcoDuration[0].add(1 days)
895             )
896         );
897         tiers.push(
898             Tier(
899                 uint256(57),
900                 _preIcoDuration[0].add(1 days),
901                 _preIcoDuration[0].add(2 days)
902             )
903         );
904         tiers.push(
905             Tier(
906                 uint256(55),
907                 _preIcoDuration[0].add(2 days),
908                 _preIcoDuration[0].add(3 days)
909             )
910         );
911         tiers.push(
912             Tier(
913                 uint256(50),
914                 _preIcoDuration[0].add(3 days),
915                 _preIcoDuration[1]
916             )
917         );
918         //ICO
919         tiers.push(
920             Tier(
921                 uint256(25),
922                 _icoDuration[0],
923                 _icoDuration[0].add(1 weeks)
924             )
925         );
926         tiers.push(
927             Tier(
928                 uint256(15),
929                 _icoDuration[0].add(1 weeks),
930                 _icoDuration[0].add(2 weeks)
931             )
932         );
933         tiers.push(
934             Tier(
935                 uint256(10),
936                 _icoDuration[0].add(2 weeks),
937                 _icoDuration[0].add(3 weeks)
938             )
939         );
940         tiers.push(
941             Tier(
942                 uint256(5),
943                 _icoDuration[0].add(3 weeks),
944                 _icoDuration[1]
945             )
946         );
947 
948     }
949 
950     function changeICODates(uint256 _tierId, uint256 _start, uint256 _end) public onlyOwner {
951         require(_start != 0 && _start < _end && _tierId < tiers.length);
952         Tier storage icoTier = tiers[_tierId];
953         icoTier.startTime = _start;
954         icoTier.endTime = _end;
955         if (_tierId == PRE_ICO_TIER_FIRST) {
956             startTime = _start;
957         } else if (_tierId == ICO_TIER_LAST) {
958             endTime = _end;
959         }
960     }
961 
962     function isActive() public view returns (bool) {
963         if (hardCap == collectedUSD.add(preICOStats.collectedUSD)) {
964             return false;
965         }
966         if (soldTokens == maxTokenSupply) {
967             return false;
968         }
969 
970         return withinPeriod();
971     }
972 
973     function withinPeriod() public view returns (bool) {
974         return getActiveTier() != tiers.length;
975     }
976 
977     function setPrivateSale(address _privateSale) public onlyOwner {
978         if (_privateSale != address(0)) {
979             privateSale = SellableToken(_privateSale);
980         }
981     }
982 
983     function getActiveTier() public view returns (uint256) {
984         for (uint256 i = 0; i < tiers.length; i++) {
985             if (block.timestamp >= tiers[i].startTime && block.timestamp <= tiers[i].endTime) {
986                 return i;
987             }
988         }
989 
990         return uint256(tiers.length);
991     }
992 
993     function calculateTokensAmount(uint256 _value) public view returns (uint256 tokenAmount, uint256 usdAmount) {
994         if (_value == 0) {
995             return (0, 0);
996         }
997         uint256 activeTier = getActiveTier();
998 
999         if (activeTier == tiers.length) {
1000             if (endTime < block.timestamp) {
1001                 return (0, 0);
1002             }
1003             if (startTime > block.timestamp) {
1004                 activeTier = PRE_ICO_TIER_FIRST;
1005             }
1006         }
1007         usdAmount = _value.mul(etherPriceInUSD);
1008 
1009         tokenAmount = usdAmount.div(price * (100 - tiers[activeTier].discount) / 100);
1010 
1011         usdAmount = usdAmount.div(uint256(10) ** 18);
1012 
1013         if (usdAmount < minPurchase) {
1014             return (0, 0);
1015         }
1016     }
1017 
1018     function calculateEthersAmount(uint256 _tokens) public view returns (uint256 ethers, uint256 usdAmount) {
1019         if (_tokens == 0) {
1020             return (0, 0);
1021         }
1022 
1023         uint256 activeTier = getActiveTier();
1024 
1025         if (activeTier == tiers.length) {
1026             if (endTime < block.timestamp) {
1027                 return (0, 0);
1028             }
1029             if (startTime > block.timestamp) {
1030                 activeTier = PRE_ICO_TIER_FIRST;
1031             }
1032         }
1033 
1034         usdAmount = _tokens.mul((price * (100 - tiers[activeTier].discount) / 100));
1035         ethers = usdAmount.div(etherPriceInUSD);
1036 
1037         if (ethers < getMinEthersInvestment()) {
1038             return (0, 0);
1039         }
1040 
1041         usdAmount = usdAmount.div(uint256(10) ** 18);
1042     }
1043 
1044     function getStats(uint256 _ethPerBtc) public view returns (
1045         uint256 sold,
1046         uint256 maxSupply,
1047         uint256 min,
1048         uint256 soft,
1049         uint256 hard,
1050         uint256 tokenPrice,
1051         uint256 tokensPerEth,
1052         uint256 tokensPerBtc,
1053         uint256[24] tiersData
1054     ) {
1055         sold = soldTokens;
1056         maxSupply = maxTokenSupply.sub(preICOStats.maxTokenSupply);
1057         min = minPurchase;
1058         soft = softCap;
1059         hard = hardCap;
1060         tokenPrice = price;
1061         uint256 usd;
1062         (tokensPerEth, usd) = calculateTokensAmount(1 ether);
1063         (tokensPerBtc, usd) = calculateTokensAmount(_ethPerBtc);
1064         uint256 j = 0;
1065         for (uint256 i = 0; i < tiers.length; i++) {
1066             tiersData[j++] = uint256(tiers[i].discount);
1067             tiersData[j++] = uint256(tiers[i].startTime);
1068             tiersData[j++] = uint256(tiers[i].endTime);
1069         }
1070     }
1071 
1072     function burnUnsoldTokens() public onlyOwner {
1073         if (block.timestamp >= endTime && maxTokenSupply > soldTokens) {
1074             token.burnUnsoldTokens(maxTokenSupply.sub(soldTokens));
1075             maxTokenSupply = soldTokens;
1076         }
1077     }
1078 
1079     function isTransferAllowed(address _from, uint256 _value) public view returns (bool status){
1080         if (collectedUSD.add(preICOStats.collectedUSD) < softCap) {
1081             if (token.balanceOf(_from) >= icoBalances[_from] && token.balanceOf(_from).sub(icoBalances[_from])> _value) {
1082                 return true;
1083             }
1084             return false;
1085         }
1086         return true;
1087     }
1088 
1089     function isRefundPossible() public view returns (bool) {
1090         if (isActive() || block.timestamp < startTime || collectedUSD.add(preICOStats.collectedUSD) >= softCap) {
1091             return false;
1092         }
1093         return true;
1094     }
1095 
1096     function refund() public returns (bool) {
1097         if (!isRefundPossible() || etherBalances[msg.sender] == 0) {
1098             return false;
1099         }
1100 
1101         uint256 burnedAmount = token.burnInvestorTokens(msg.sender, icoBalances[msg.sender]);
1102         if (burnedAmount == 0) {
1103             return false;
1104         }
1105         uint256 etherBalance = etherBalances[msg.sender];
1106         etherBalances[msg.sender] = 0;
1107 
1108         msg.sender.transfer(etherBalance);
1109 
1110         Refund(msg.sender, etherBalance, burnedAmount);
1111 
1112         return true;
1113     }
1114 
1115     function updatePreICOMaxTokenSupply(uint256 _amount) public {
1116         if (msg.sender == address(privateSale)) {
1117             maxTokenSupply = maxTokenSupply.add(_amount);
1118             preICOStats.maxTokenSupply = preICOStats.maxTokenSupply.add(_amount);
1119         }
1120     }
1121 
1122     function moveUnsoldTokensToICO() public onlyOwner {
1123         uint256 unsoldTokens = preICOStats.maxTokenSupply - preICOStats.soldTokens;
1124         if (unsoldTokens > 0) {
1125             preICOStats.maxTokenSupply = preICOStats.soldTokens;
1126         }
1127     }
1128 
1129     function transferEthers() internal {
1130         if (collectedUSD.add(preICOStats.collectedUSD) >= softCap) {
1131             etherHolder.transfer(this.balance);
1132         }
1133     }
1134 
1135     function mintPreICO(
1136         address _address,
1137         uint256 _tokenAmount,
1138         uint256 _ethAmount,
1139         uint256 _usdAmount
1140     ) internal returns (uint256) {
1141         uint256 mintedAmount = token.mint(_address, _tokenAmount);
1142 
1143         require(mintedAmount == _tokenAmount);
1144 
1145         preICOStats.soldTokens = preICOStats.soldTokens.add(_tokenAmount);
1146         preICOStats.collectedEthers = preICOStats.collectedEthers.add(_ethAmount);
1147         preICOStats.collectedUSD = preICOStats.collectedUSD.add(_usdAmount);
1148 
1149         require(preICOStats.maxTokenSupply >= preICOStats.soldTokens);
1150         require(maxTokenSupply >= preICOStats.soldTokens);
1151 
1152         return _tokenAmount;
1153     }
1154 
1155     function buy(address _address, uint256 _value) internal returns (bool) {
1156         if (_value == 0 || _address == address(0)) {
1157             return false;
1158         }
1159 
1160         uint256 activeTier = getActiveTier();
1161         if (activeTier == tiers.length) {
1162             return false;
1163         }
1164 
1165         uint256 tokenAmount;
1166         uint256 usdAmount;
1167         uint256 mintedAmount;
1168 
1169         (tokenAmount, usdAmount) = calculateTokensAmount(_value);
1170         require(usdAmount > 0 && tokenAmount > 0);
1171 
1172         if (activeTier >= PRE_ICO_TIER_FIRST && activeTier <= PRE_ICO_TIER_LAST) {
1173             mintedAmount = mintPreICO(_address, tokenAmount, _value, usdAmount);
1174             etherHolder.transfer(this.balance);
1175         } else {
1176             mintedAmount = mintInternal(_address, tokenAmount);
1177             require(soldTokens <= maxTokenSupply.sub(preICOStats.maxTokenSupply));
1178             collectedUSD = collectedUSD.add(usdAmount);
1179             require(hardCap >= collectedUSD.add(preICOStats.collectedUSD) && usdAmount > 0 && mintedAmount > 0);
1180 
1181             collectedEthers = collectedEthers.add(_value);
1182             etherBalances[_address] = etherBalances[_address].add(_value);
1183             icoBalances[_address] = icoBalances[_address].add(tokenAmount);
1184             transferEthers();
1185         }
1186 
1187         Contribution(_address, _value, tokenAmount);
1188 
1189         return true;
1190     }
1191 }