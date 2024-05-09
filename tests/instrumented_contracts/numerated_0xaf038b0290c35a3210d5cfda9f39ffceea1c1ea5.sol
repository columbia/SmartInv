1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender) public view returns (uint256);
60   function transferFrom(address from, address to, uint256 value) public returns (bool);
61   function approve(address spender, uint256 value) public returns (bool);
62   event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) internal allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[_from]);
122     require(_value <= allowed[_from][msg.sender]);
123 
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127     Transfer(_from, _to, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    *
134    * Beware that changing an allowance with this method brings the risk that someone may use both the old
135    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) public returns (bool) {
142     allowed[msg.sender][_spender] = _value;
143     Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153   function allowance(address _owner, address _spender) public view returns (uint256) {
154     return allowed[_owner][_spender];
155   }
156 
157   /**
158    * @dev Increase the amount of tokens that an owner allowed to a spender.
159    *
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    * @param _spender The address which will spend the funds.
165    * @param _addedValue The amount of tokens to increase the allowance by.
166    */
167   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   /**
174    * @dev Decrease the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To decrement
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _subtractedValue The amount of tokens to decrease the allowance by.
182    */
183   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
184     uint oldValue = allowed[msg.sender][_spender];
185     if (_subtractedValue > oldValue) {
186       allowed[msg.sender][_spender] = 0;
187     } else {
188       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189     }
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194 }
195 
196 
197 contract Multivest is Ownable {
198 
199     using SafeMath for uint256;
200 
201     /* public variables */
202     mapping (address => bool) public allowedMultivests;
203 
204     /* events */
205     event MultivestSet(address multivest);
206 
207     event MultivestUnset(address multivest);
208 
209     event Contribution(address holder, uint256 value, uint256 tokens);
210 
211     modifier onlyAllowedMultivests(address _addresss) {
212         require(allowedMultivests[_addresss] == true);
213         _;
214     }
215 
216     /* constructor */
217     function Multivest() public {}
218 
219     function setAllowedMultivest(address _address) public onlyOwner {
220         allowedMultivests[_address] = true;
221         MultivestSet(_address);
222     }
223 
224     function unsetAllowedMultivest(address _address) public onlyOwner {
225         allowedMultivests[_address] = false;
226         MultivestUnset(_address);
227     }
228 
229     function multivestBuy(address _address, uint256 _value) public onlyAllowedMultivests(msg.sender) {
230         require(buy(_address, _value) == true);
231     }
232 
233     function multivestBuy(
234         address _address,
235         uint8 _v,
236         bytes32 _r,
237         bytes32 _s
238     ) public payable onlyAllowedMultivests(verify(keccak256(msg.sender), _v, _r, _s)) {
239         require(_address == msg.sender && buy(msg.sender, msg.value) == true);
240     }
241 
242     function verify(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns (address) {
243         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
244 
245         return ecrecover(keccak256(prefix, _hash), _v, _r, _s);
246     }
247 
248     function buy(address _address, uint256 _value) internal returns (bool);
249 
250 }
251 
252 
253 library SafeMath {
254 
255   /**
256   * @dev Multiplies two numbers, throws on overflow.
257   */
258   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
259     if (a == 0) {
260       return 0;
261     }
262     uint256 c = a * b;
263     assert(c / a == b);
264     return c;
265   }
266 
267   /**
268   * @dev Integer division of two numbers, truncating the quotient.
269   */
270   function div(uint256 a, uint256 b) internal pure returns (uint256) {
271     // assert(b > 0); // Solidity automatically throws when dividing by 0
272     uint256 c = a / b;
273     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
274     return c;
275   }
276 
277   /**
278   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
279   */
280   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281     assert(b <= a);
282     return a - b;
283   }
284 
285   /**
286   * @dev Adds two numbers, throws on overflow.
287   */
288   function add(uint256 a, uint256 b) internal pure returns (uint256) {
289     uint256 c = a + b;
290     assert(c >= a);
291     return c;
292   }
293 }
294 
295 
296 contract GigERC20 is StandardToken, Ownable {
297     /* Public variables of the token */
298     uint256 public creationBlock;
299 
300     uint8 public decimals;
301 
302     string public name;
303 
304     string public symbol;
305 
306     string public standard;
307 
308     bool public locked;
309 
310     /* Initializes contract with initial supply tokens to the creator of the contract */
311     function GigERC20(
312         uint256 _totalSupply,
313         string _tokenName,
314         uint8 _decimalUnits,
315         string _tokenSymbol,
316         bool _transferAllSupplyToOwner,
317         bool _locked
318     ) public {
319         standard = "ERC20 0.1";
320         locked = _locked;
321         totalSupply_ = _totalSupply;
322 
323         if (_transferAllSupplyToOwner) {
324             balances[msg.sender] = totalSupply_;
325         } else {
326             balances[this] = totalSupply_;
327         }
328         name = _tokenName;
329         // Set the name for display purposes
330         symbol = _tokenSymbol;
331         // Set the symbol for display purposes
332         decimals = _decimalUnits;
333         // Amount of decimals for display purposes
334         creationBlock = block.number;
335     }
336 
337     function setLocked(bool _locked) public onlyOwner {
338         locked = _locked;
339     }
340 
341     /* public methods */
342     function transfer(address _to, uint256 _value) public returns (bool) {
343         require(locked == false);
344         return super.transfer(_to, _value);
345     }
346 
347     function approve(address _spender, uint256 _value) public returns (bool success) {
348         if (locked) {
349             return false;
350         }
351         return super.approve(_spender, _value);
352     }
353 
354     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
355         if (locked) {
356             return false;
357         }
358         return super.increaseApproval(_spender, _addedValue);
359     }
360 
361     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
362         if (locked) {
363             return false;
364         }
365         return super.decreaseApproval(_spender, _subtractedValue);
366     }
367 
368     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
369         if (locked) {
370             return false;
371         }
372 
373         return super.transferFrom(_from, _to, _value);
374     }
375 
376 }
377 
378 
379 /*
380 This contract manages the minters and the modifier to allow mint to happen only if called by minters
381 This contract contains basic minting functionality though
382 */
383 contract MintingERC20 is GigERC20 {
384 
385     using SafeMath for uint256;
386 
387     //Variables
388     mapping (address => bool) public minters;
389 
390     uint256 public maxSupply;
391 
392     //Modifiers
393     modifier onlyMinters () {
394         require(true == minters[msg.sender]);
395         _;
396     }
397 
398     function MintingERC20(
399         uint256 _initialSupply,
400         uint256 _maxSupply,
401         string _tokenName,
402         uint8 _decimals,
403         string _symbol,
404         bool _transferAllSupplyToOwner,
405         bool _locked
406     )
407         public GigERC20(_initialSupply, _tokenName, _decimals, _symbol, _transferAllSupplyToOwner, _locked)
408     {
409         standard = "MintingERC20 0.1";
410         minters[msg.sender] = true;
411         maxSupply = _maxSupply;
412     }
413 
414     function addMinter(address _newMinter) public onlyOwner {
415         minters[_newMinter] = true;
416     }
417 
418     function removeMinter(address _minter) public onlyOwner {
419         minters[_minter] = false;
420     }
421 
422     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
423         if (true == locked) {
424             return uint256(0);
425         }
426 
427         if (_amount == uint256(0)) {
428             return uint256(0);
429         }
430 
431         if (totalSupply_.add(_amount) > maxSupply) {
432             return uint256(0);
433         }
434 
435         totalSupply_ = totalSupply_.add(_amount);
436         balances[_addr] = balances[_addr].add(_amount);
437         Transfer(address(0), _addr, _amount);
438 
439         return _amount;
440     }
441 
442 }
443 
444 
445 contract GigToken is MintingERC20 {
446     SellableToken public crowdSale; // Pre ICO & ICO
447     SellableToken public privateSale;
448 
449     bool public transferFrozen = false;
450 
451     uint256 public crowdSaleEndTime;
452 
453     mapping(address => uint256) public lockedBalancesReleasedAfterOneYear;
454 
455     modifier onlyCrowdSale() {
456         require(crowdSale != address(0) && msg.sender == address(crowdSale));
457 
458         _;
459     }
460 
461     modifier onlySales() {
462         require((privateSale != address(0) && msg.sender == address(privateSale)) ||
463             (crowdSale != address(0) && msg.sender == address(crowdSale)));
464 
465         _;
466     }
467 
468     event MaxSupplyBurned(uint256 burnedTokens);
469 
470     function GigToken(bool _locked) public
471         MintingERC20(0, maxSupply, "GigBit", 18, "GBTC", false, _locked)
472     {
473         standard = "GBTC 0.1";
474 
475         maxSupply = uint256(1000000000).mul(uint256(10) ** decimals);
476     }
477 
478     function setCrowdSale(address _crowdSale) public onlyOwner {
479         require(_crowdSale != address(0));
480 
481         crowdSale = SellableToken(_crowdSale);
482 
483         crowdSaleEndTime = crowdSale.endTime();
484     }
485 
486     function setPrivateSale(address _privateSale) public onlyOwner {
487         require(_privateSale != address(0));
488 
489         privateSale = SellableToken(_privateSale);
490     }
491 
492     function freezing(bool _transferFrozen) public onlyOwner {
493         transferFrozen = _transferFrozen;
494     }
495 
496     function isTransferAllowed(address _from, uint256 _value) public view returns (bool status) {
497         uint256 senderBalance = balanceOf(_from);
498         if (transferFrozen == true || senderBalance < _value) {
499             return false;
500         }
501 
502         uint256 lockedBalance = lockedBalancesReleasedAfterOneYear[_from];
503 
504         // check if holder tries to transfer more than locked tokens
505     if (lockedBalance > 0 && senderBalance.sub(_value) < lockedBalance) {
506             uint256 unlockTime = crowdSaleEndTime + 1 years;
507 
508             // fail if unlock time is not come
509             if (crowdSaleEndTime == 0 || block.timestamp < unlockTime) {
510                 return false;
511             }
512 
513             uint256 secsFromUnlock = block.timestamp.sub(unlockTime);
514 
515             // number of months over from unlock
516             uint256 months = secsFromUnlock / 30 days;
517 
518             if (months > 12) {
519                 months = 12;
520             }
521 
522             uint256 tokensPerMonth = lockedBalance / 12;
523 
524             uint256 unlockedBalance = tokensPerMonth.mul(months);
525 
526             uint256 actualLockedBalance = lockedBalance.sub(unlockedBalance);
527 
528             if (senderBalance.sub(_value) < actualLockedBalance) {
529                 return false;
530             }
531         }
532 
533         if (block.timestamp < crowdSaleEndTime &&
534             crowdSale != address(0) &&
535             crowdSale.isTransferAllowed(_from, _value) == false
536         ) {
537             return false;
538         }
539 
540 
541         return true;
542     }
543 
544     function transfer(address _to, uint _value) public returns (bool) {
545         require(isTransferAllowed(msg.sender, _value));
546 
547         return super.transfer(_to, _value);
548     }
549 
550     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
551         // transferFrom & approve are disabled before end of ICO
552         require((crowdSaleEndTime <= block.timestamp) && isTransferAllowed(_from, _value));
553 
554         return super.transferFrom(_from, _to, _value);
555     }
556 
557     function approve(address _spender, uint256 _value) public returns (bool success) {
558         // transferFrom & approve are disabled before end of ICO
559 
560         require(crowdSaleEndTime <= block.timestamp);
561 
562         return super.approve(_spender, _value);
563     }
564 
565     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
566         // transferFrom & approve are disabled before end of ICO
567 
568         require(crowdSaleEndTime <= block.timestamp);
569 
570         return super.increaseApproval(_spender, _addedValue);
571     }
572 
573     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
574         // transferFrom & approve are disabled before end of ICO
575 
576         require(crowdSaleEndTime <= block.timestamp);
577 
578         return super.decreaseApproval(_spender, _subtractedValue);
579     }
580 
581     function increaseLockedBalance(address _address, uint256 _tokens) public onlySales {
582         lockedBalancesReleasedAfterOneYear[_address] =
583             lockedBalancesReleasedAfterOneYear[_address].add(_tokens);
584     }
585 
586     // burn tokens if soft cap is not reached
587     function burnInvestorTokens(
588         address _address,
589         uint256 _amount
590     ) public onlyCrowdSale returns (uint256) {
591         require(block.timestamp > crowdSaleEndTime);
592 
593         require(_amount <= balances[_address]);
594 
595         balances[_address] = balances[_address].sub(_amount);
596 
597         totalSupply_ = totalSupply_.sub(_amount);
598 
599         Transfer(_address, address(0), _amount);
600 
601         return _amount;
602     }
603 
604     // decrease max supply of tokens that are not sold
605     function burnUnsoldTokens(uint256 _amount) public onlyCrowdSale {
606         require(block.timestamp > crowdSaleEndTime);
607 
608         maxSupply = maxSupply.sub(_amount);
609 
610         MaxSupplyBurned(_amount);
611     }
612 }
613 
614 contract SellableToken is Multivest {
615     uint256 public constant MONTH_IN_SEC = 2629743;
616     GigToken public token;
617 
618     uint256 public minPurchase = 100 * 10 ** 5;
619     uint256 public maxPurchase;
620 
621     uint256 public softCap;
622     uint256 public hardCap;
623 
624     uint256 public startTime;
625     uint256 public endTime;
626 
627     uint256 public maxTokenSupply;
628 
629     uint256 public soldTokens;
630 
631     uint256 public collectedEthers;
632 
633     address public etherHolder;
634 
635     uint256 public collectedUSD;
636 
637     uint256 public etherPriceInUSD;
638     uint256 public priceUpdateAt;
639 
640     mapping(address => uint256) public etherBalances;
641 
642     Tier[] public tiers;
643 
644     struct Tier {
645         uint256 discount;
646         uint256 startTime;
647         uint256 endTime;
648     }
649 
650     event Refund(address _holder, uint256 _ethers, uint256 _tokens);
651     event NewPriceTicker(string _price);
652 
653     function SellableToken(
654         address _token,
655         address _etherHolder,
656         uint256 _startTime,
657         uint256 _endTime,
658         uint256 _maxTokenSupply,
659         uint256 _etherPriceInUSD
660     )
661     public Multivest()
662     {
663         require(_token != address(0) && _etherHolder != address(0));
664         token = GigToken(_token);
665 
666         require(_startTime < _endTime);
667         etherHolder = _etherHolder;
668         require((_maxTokenSupply == uint256(0)) || (_maxTokenSupply <= token.maxSupply()));
669 
670         startTime = _startTime;
671         endTime = _endTime;
672         maxTokenSupply = _maxTokenSupply;
673         etherPriceInUSD = _etherPriceInUSD;
674 
675         priceUpdateAt = block.timestamp;
676     }
677 
678     function setTokenContract(address _token) public onlyOwner {
679         require(_token != address(0));
680         token = GigToken(_token);
681     }
682 
683     function setEtherHolder(address _etherHolder) public onlyOwner {
684         if (_etherHolder != address(0)) {
685             etherHolder = _etherHolder;
686         }
687     }
688 
689     function setPurchaseLimits(uint256 _min, uint256 _max) public onlyOwner {
690         if (_min < _max) {
691             minPurchase = _min;
692             maxPurchase = _max;
693         }
694     }
695 
696     function mint(address _address, uint256 _tokenAmount) public onlyOwner returns (uint256) {
697         return mintInternal(_address, _tokenAmount);
698     }
699 
700     function isActive() public view returns (bool);
701 
702     function isTransferAllowed(address _from, uint256 _value) public view returns (bool);
703 
704     function withinPeriod() public view returns (bool);
705 
706     function getMinEthersInvestment() public view returns (uint256) {
707         return uint256(1 ether).mul(minPurchase).div(etherPriceInUSD);
708     }
709 
710     function calculateTokensAmount(uint256 _value) public view returns (uint256 tokenAmount, uint256 usdAmount);
711 
712     function calculateEthersAmount(uint256 _tokens) public view returns (uint256 ethers, uint256 bonus);
713 
714     function updatePreICOMaxTokenSupply(uint256 _amount) public;
715 
716     // set ether price in USD with 5 digits after the decimal point
717     //ex. 308.75000
718     //for updating the price through  multivest
719     function setEtherInUSD(string _price) public onlyAllowedMultivests(msg.sender) {
720         bytes memory bytePrice = bytes(_price);
721         uint256 dot = bytePrice.length.sub(uint256(6));
722 
723         // check if dot is in 6 position  from  the last
724         require(0x2e == uint(bytePrice[dot]));
725 
726         uint256 newPrice = uint256(10 ** 23).div(parseInt(_price, 5));
727 
728         require(newPrice > 0);
729 
730         etherPriceInUSD = parseInt(_price, 5);
731 
732         priceUpdateAt = block.timestamp;
733 
734         NewPriceTicker(_price);
735     }
736 
737     function mintInternal(address _address, uint256 _tokenAmount) internal returns (uint256) {
738         uint256 mintedAmount = token.mint(_address, _tokenAmount);
739 
740         require(mintedAmount == _tokenAmount);
741 
742         soldTokens = soldTokens.add(_tokenAmount);
743         if (maxTokenSupply > 0) {
744             require(maxTokenSupply >= soldTokens);
745         }
746 
747         return _tokenAmount;
748     }
749 
750     function transferEthers() internal;
751 
752     function parseInt(string _a, uint _b) internal pure returns (uint) {
753         bytes memory bresult = bytes(_a);
754         uint res = 0;
755         bool decimals = false;
756         for (uint i = 0; i < bresult.length; i++) {
757             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
758                 if (decimals) {
759                     if (_b == 0) break;
760                     else _b--;
761                 }
762                 res *= 10;
763                 res += uint(bresult[i]) - 48;
764             } else if (bresult[i] == 46) decimals = true;
765         }
766         if (_b > 0) res *= 10 ** _b;
767         return res;
768     }
769 }
770 
771 
772 contract TokenAllocation is Ownable {
773     using SafeERC20 for ERC20Basic;
774     using SafeMath for uint256;
775 
776     address public ecosystemIncentive = 0xd339D9aeDFFa244E09874D65290c09d64b2356E0;
777     address public marketingAndBounty = 0x26d6EF95A51BF0A2048Def4Fb7c548c3BDE37410;
778     address public liquidityFund = 0x3D458b6f9024CDD9A2a7528c2E6451DD3b29e4cc;
779     address public treasure = 0x00dEaFC5959Dd0E164bB00D06B08d972A276bf8E;
780     address public amirShaikh = 0x31b17e7a2F86d878429C03f3916d17555C0d4884;
781     address public sadiqHameed = 0x27B5cb71ff083Bd6a34764fBf82700b3669137f3;
782     address public omairLatif = 0x92Db818bF10Bf3BfB73942bbB1f184274aA63833;
783 
784     uint256 public icoEndTime;
785 
786     address public vestingApplicature;
787     address public vestingSimonCocking;
788     address public vestingNathanChristian;
789     address public vestingEdwinVanBerg;
790 
791     mapping(address => bool) public tokenInited;
792     address[] public vestings;
793 
794     event VestingCreated(
795         address _vesting,
796         address _beneficiary,
797         uint256 _start,
798         uint256 _cliff,
799         uint256 _duration,
800         uint256 _periods,
801         bool _revocable
802     );
803 
804     event VestingRevoked(address _vesting);
805 
806     function setICOEndTime(uint256 _icoEndTime) public onlyOwner {
807         icoEndTime = _icoEndTime;
808     }
809 
810     function initVesting() public onlyOwner() {
811         require(vestingApplicature == address(0) &&
812         vestingSimonCocking == address(0) &&
813         vestingNathanChristian == address(0) &&
814         vestingEdwinVanBerg == address(0) &&
815         icoEndTime != 0
816         );
817 
818         uint256 oneYearAfterIcoEnd = icoEndTime.add(1 years);
819 
820         vestingApplicature = createVesting(
821             0x760864dcdC58FDA80dB6883ce442B6ce44921Cf9, oneYearAfterIcoEnd, 0, 1 years, 2, false
822         );
823 
824         vestingSimonCocking = createVesting(
825             0x7f438d78a51886B24752941ba98Cc00aBA217495, oneYearAfterIcoEnd, 0, 1 years, 2, true
826         );
827 
828         vestingNathanChristian = createVesting(
829             0xfD86B8B016de558Fe39B1697cBf525592A233B2c, oneYearAfterIcoEnd, 0, 1 years, 2, true
830         );
831 
832         vestingEdwinVanBerg = createVesting(
833             0x2451A73F35874028217bC833462CCd90c72dbE6D, oneYearAfterIcoEnd, 0, 1 years, 2, true
834         );
835     }
836 
837     function allocate(MintingERC20 token) public onlyOwner() {
838         require(tokenInited[token] == false);
839 
840         tokenInited[token] = true;
841 
842         require(vestingApplicature != address(0));
843         require(vestingSimonCocking != address(0));
844         require(vestingNathanChristian != address(0));
845         require(vestingEdwinVanBerg != address(0));
846 
847         uint256 tokenPrecision = uint256(10) ** uint256(token.decimals());
848 
849         // allocate funds
850         token.mint(ecosystemIncentive, 200000000 * tokenPrecision);
851         token.mint(marketingAndBounty, 50000000 * tokenPrecision);
852         token.mint(liquidityFund, 50000000 * tokenPrecision);
853         token.mint(treasure, 200000000 * tokenPrecision);
854 
855         // allocate funds to founders
856         token.mint(amirShaikh, 73350000 * tokenPrecision);
857         token.mint(sadiqHameed, 36675000 * tokenPrecision);
858         token.mint(omairLatif, 36675000 * tokenPrecision);
859 
860         // allocate funds to advisors
861         token.mint(vestingApplicature, 1500000 * tokenPrecision);
862         token.mint(vestingSimonCocking, 750000 * tokenPrecision);
863         token.mint(vestingNathanChristian, 750000 * tokenPrecision);
864         token.mint(vestingEdwinVanBerg, 300000 * tokenPrecision);
865     }
866 
867     function createVesting(
868         address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, uint256 _periods, bool _revocable
869     ) public onlyOwner() returns (PeriodicTokenVesting) {
870         PeriodicTokenVesting vesting = new PeriodicTokenVesting(
871             _beneficiary, _start, _cliff, _duration, _periods, _revocable
872         );
873 
874         vestings.push(vesting);
875 
876         VestingCreated(vesting, _beneficiary, _start, _cliff, _duration, _periods, _revocable);
877 
878         return vesting;
879     }
880 
881     function revokeVesting(PeriodicTokenVesting _vesting, MintingERC20 token) public onlyOwner() {
882         _vesting.revoke(token);
883 
884         VestingRevoked(_vesting);
885     }
886 }
887 
888 
889 library SafeERC20 {
890   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
891     assert(token.transfer(to, value));
892   }
893 
894   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
895     assert(token.transferFrom(from, to, value));
896   }
897 
898   function safeApprove(ERC20 token, address spender, uint256 value) internal {
899     assert(token.approve(spender, value));
900   }
901 }
902 
903 
904 contract TokenVesting is Ownable {
905   using SafeMath for uint256;
906   using SafeERC20 for ERC20Basic;
907 
908   event Released(uint256 amount);
909   event Revoked();
910 
911   // beneficiary of tokens after they are released
912   address public beneficiary;
913 
914   uint256 public cliff;
915   uint256 public start;
916   uint256 public duration;
917 
918   bool public revocable;
919 
920   mapping (address => uint256) public released;
921   mapping (address => bool) public revoked;
922 
923   /**
924    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
925    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
926    * of the balance will have vested.
927    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
928    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
929    * @param _duration duration in seconds of the period in which the tokens will vest
930    * @param _revocable whether the vesting is revocable or not
931    */
932   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
933     require(_beneficiary != address(0));
934     require(_cliff <= _duration);
935 
936     beneficiary = _beneficiary;
937     revocable = _revocable;
938     duration = _duration;
939     cliff = _start.add(_cliff);
940     start = _start;
941   }
942 
943   /**
944    * @notice Transfers vested tokens to beneficiary.
945    * @param token ERC20 token which is being vested
946    */
947   function release(ERC20Basic token) public {
948     uint256 unreleased = releasableAmount(token);
949 
950     require(unreleased > 0);
951 
952     released[token] = released[token].add(unreleased);
953 
954     token.safeTransfer(beneficiary, unreleased);
955 
956     Released(unreleased);
957   }
958 
959   /**
960    * @notice Allows the owner to revoke the vesting. Tokens already vested
961    * remain in the contract, the rest are returned to the owner.
962    * @param token ERC20 token which is being vested
963    */
964   function revoke(ERC20Basic token) public onlyOwner {
965     require(revocable);
966     require(!revoked[token]);
967 
968     uint256 balance = token.balanceOf(this);
969 
970     uint256 unreleased = releasableAmount(token);
971     uint256 refund = balance.sub(unreleased);
972 
973     revoked[token] = true;
974 
975     token.safeTransfer(owner, refund);
976 
977     Revoked();
978   }
979 
980   /**
981    * @dev Calculates the amount that has already vested but hasn't been released yet.
982    * @param token ERC20 token which is being vested
983    */
984   function releasableAmount(ERC20Basic token) public view returns (uint256) {
985     return vestedAmount(token).sub(released[token]);
986   }
987 
988   /**
989    * @dev Calculates the amount that has already vested.
990    * @param token ERC20 token which is being vested
991    */
992   function vestedAmount(ERC20Basic token) public view returns (uint256) {
993     uint256 currentBalance = token.balanceOf(this);
994     uint256 totalBalance = currentBalance.add(released[token]);
995 
996     if (now < cliff) {
997       return 0;
998     } else if (now >= start.add(duration) || revoked[token]) {
999       return totalBalance;
1000     } else {
1001       return totalBalance.mul(now.sub(start)).div(duration);
1002     }
1003   }
1004 }
1005 
1006 
1007 contract PeriodicTokenVesting is TokenVesting {
1008     uint256 public periods;
1009 
1010     function PeriodicTokenVesting(
1011         address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, uint256 _periods, bool _revocable
1012     )
1013         public TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable)
1014     {
1015         periods = _periods;
1016     }
1017 
1018     /**
1019     * @dev Calculates the amount that has already vested.
1020     * @param token ERC20 token which is being vested
1021     */
1022     function vestedAmount(ERC20Basic token) public view returns (uint256) {
1023         uint256 currentBalance = token.balanceOf(this);
1024         uint256 totalBalance = currentBalance.add(released[token]);
1025 
1026         if (now < cliff) {
1027             return 0;
1028         } else if (now >= start.add(duration * periods) || revoked[token]) {
1029             return totalBalance;
1030         } else {
1031 
1032             uint256 periodTokens = totalBalance.div(periods);
1033 
1034             uint256 periodsOver = now.sub(start).div(duration) + 1;
1035 
1036             if (periodsOver >= periods) {
1037                 return totalBalance;
1038             }
1039 
1040             return periodTokens.mul(periodsOver);
1041         }
1042     }
1043 }
1044 
1045 
1046 contract PrivateSale is SellableToken {
1047 
1048     uint256 public price;
1049     uint256 public discount;
1050     SellableToken public crowdSale;
1051 
1052     function PrivateSale(
1053         address _token,
1054         address _etherHolder,
1055         uint256 _startTime,
1056         uint256 _endTime,
1057         uint256 _maxTokenSupply, //14000000000000000000000000
1058         uint256 _etherPriceInUSD
1059     ) public SellableToken(
1060         _token,
1061         _etherHolder,
1062         _startTime,
1063         _endTime,
1064         _maxTokenSupply,
1065         _etherPriceInUSD
1066     ) {
1067         price = 24800;// $0.2480 * 10 ^ 5
1068         discount = 75;// $75%
1069     }
1070 
1071     function changeSalePeriod(uint256 _start, uint256 _end) public onlyOwner {
1072         if (_start != 0 && _start < _end) {
1073             startTime = _start;
1074             endTime = _end;
1075         }
1076     }
1077 
1078     function isActive() public view returns (bool) {
1079         if (soldTokens == maxTokenSupply) {
1080             return false;
1081         }
1082 
1083         return withinPeriod();
1084     }
1085 
1086     function withinPeriod() public view returns (bool) {
1087         return block.timestamp >= startTime && block.timestamp <= endTime;
1088     }
1089 
1090     function calculateTokensAmount(uint256 _value) public view returns (uint256 tokenAmount, uint256 usdAmount) {
1091         if (_value == 0) {
1092             return (0, 0);
1093         }
1094 
1095         usdAmount = _value.mul(etherPriceInUSD);
1096 
1097         tokenAmount = usdAmount.div(price * (100 - discount) / 100);
1098 
1099         usdAmount = usdAmount.div(uint256(10) ** 18);
1100 
1101         if (usdAmount < minPurchase) {
1102             return (0, 0);
1103         }
1104     }
1105 
1106     function calculateEthersAmount(uint256 _tokens) public view returns (uint256 ethers, uint256 usdAmount) {
1107         if (_tokens == 0) {
1108             return (0, 0);
1109         }
1110 
1111         usdAmount = _tokens.mul((price * (100 - discount) / 100));
1112         ethers = usdAmount.div(etherPriceInUSD);
1113 
1114         if (ethers < getMinEthersInvestment()) {
1115             return (0, 0);
1116         }
1117 
1118         usdAmount = usdAmount.div(uint256(10) ** 18);
1119     }
1120 
1121     function getStats(uint256 _ethPerBtc) public view returns (
1122         uint256 start,
1123         uint256 end,
1124         uint256 sold,
1125         uint256 maxSupply,
1126         uint256 min,
1127         uint256 tokensPerEth,
1128         uint256 tokensPerBtc
1129     ) {
1130         start = startTime;
1131         end = endTime;
1132         sold = soldTokens;
1133         maxSupply = maxTokenSupply;
1134         min = minPurchase;
1135         uint256 usd;
1136         (tokensPerEth, usd) = calculateTokensAmount(1 ether);
1137         (tokensPerBtc, usd) = calculateTokensAmount(_ethPerBtc);
1138     }
1139 
1140     function setCrowdSale(address _crowdSale) public onlyOwner {
1141         require(_crowdSale != address(0));
1142 
1143         crowdSale = SellableToken(_crowdSale);
1144     }
1145 
1146     function moveUnsoldTokens() public onlyOwner {
1147         require(address(crowdSale) != address(0) && now >= endTime && !isActive() && maxTokenSupply > soldTokens);
1148 
1149         crowdSale.updatePreICOMaxTokenSupply(maxTokenSupply.sub(soldTokens));
1150         maxTokenSupply = soldTokens;
1151     }
1152 
1153     function updatePreICOMaxTokenSupply(uint256) public {
1154         require(false);
1155     }
1156 
1157     function isTransferAllowed(address, uint256) public view returns (bool) {
1158         return false;
1159     }
1160 
1161     function buy(address _address, uint256 _value) internal returns (bool) {
1162         if (_value == 0 || _address == address(0)) {
1163             return false;
1164         }
1165 
1166         uint256 tokenAmount;
1167         uint256 usdAmount;
1168 
1169         (tokenAmount, usdAmount) = calculateTokensAmount(_value);
1170 
1171         uint256 mintedAmount = mintInternal(_address, tokenAmount);
1172         collectedUSD = collectedUSD.add(usdAmount);
1173         require(usdAmount > 0 && mintedAmount > 0);
1174 
1175         collectedEthers = collectedEthers.add(_value);
1176         etherBalances[_address] = etherBalances[_address].add(_value);
1177 
1178         token.increaseLockedBalance(_address, mintedAmount);
1179 
1180         transferEthers();
1181 
1182         Contribution(_address, _value, tokenAmount);
1183         return true;
1184     }
1185 
1186     function transferEthers() internal {
1187         etherHolder.transfer(this.balance);
1188     }
1189 }