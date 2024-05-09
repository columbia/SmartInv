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
615 contract SellableToken is Multivest {
616     uint256 public constant MONTH_IN_SEC = 2629743;
617     GigToken public token;
618 
619     uint256 public minPurchase = 100 * 10 ** 5;
620     uint256 public maxPurchase;
621 
622     uint256 public softCap;
623     uint256 public hardCap;
624 
625     uint256 public startTime;
626     uint256 public endTime;
627 
628     uint256 public maxTokenSupply;
629 
630     uint256 public soldTokens;
631 
632     uint256 public collectedEthers;
633 
634     address public etherHolder;
635 
636     uint256 public collectedUSD;
637 
638     uint256 public etherPriceInUSD;
639     uint256 public priceUpdateAt;
640 
641     mapping(address => uint256) public etherBalances;
642 
643     Tier[] public tiers;
644 
645     struct Tier {
646         uint256 discount;
647         uint256 startTime;
648         uint256 endTime;
649     }
650 
651     event Refund(address _holder, uint256 _ethers, uint256 _tokens);
652     event NewPriceTicker(string _price);
653 
654     function SellableToken(
655         address _token,
656         address _etherHolder,
657         uint256 _startTime,
658         uint256 _endTime,
659         uint256 _maxTokenSupply,
660         uint256 _etherPriceInUSD
661     )
662     public Multivest()
663     {
664         require(_token != address(0) && _etherHolder != address(0));
665         token = GigToken(_token);
666 
667         require(_startTime < _endTime);
668         etherHolder = _etherHolder;
669         require((_maxTokenSupply == uint256(0)) || (_maxTokenSupply <= token.maxSupply()));
670 
671         startTime = _startTime;
672         endTime = _endTime;
673         maxTokenSupply = _maxTokenSupply;
674         etherPriceInUSD = _etherPriceInUSD;
675 
676         priceUpdateAt = block.timestamp;
677     }
678 
679     function setTokenContract(address _token) public onlyOwner {
680         require(_token != address(0));
681         token = GigToken(_token);
682     }
683 
684     function setEtherHolder(address _etherHolder) public onlyOwner {
685         if (_etherHolder != address(0)) {
686             etherHolder = _etherHolder;
687         }
688     }
689 
690     function setPurchaseLimits(uint256 _min, uint256 _max) public onlyOwner {
691         if (_min < _max) {
692             minPurchase = _min;
693             maxPurchase = _max;
694         }
695     }
696 
697     function mint(address _address, uint256 _tokenAmount) public onlyOwner returns (uint256) {
698         return mintInternal(_address, _tokenAmount);
699     }
700 
701     function isActive() public view returns (bool);
702 
703     function isTransferAllowed(address _from, uint256 _value) public view returns (bool);
704 
705     function withinPeriod() public view returns (bool);
706 
707     function getMinEthersInvestment() public view returns (uint256) {
708         return uint256(1 ether).mul(minPurchase).div(etherPriceInUSD);
709     }
710 
711     function calculateTokensAmount(uint256 _value) public view returns (uint256 tokenAmount, uint256 usdAmount);
712 
713     function calculateEthersAmount(uint256 _tokens) public view returns (uint256 ethers, uint256 bonus);
714 
715     function updatePreICOMaxTokenSupply(uint256 _amount) public;
716 
717     // set ether price in USD with 5 digits after the decimal point
718     //ex. 308.75000
719     //for updating the price through  multivest
720     function setEtherInUSD(string _price) public onlyAllowedMultivests(msg.sender) {
721         bytes memory bytePrice = bytes(_price);
722         uint256 dot = bytePrice.length.sub(uint256(6));
723 
724         // check if dot is in 6 position  from  the last
725         require(0x2e == uint(bytePrice[dot]));
726 
727         uint256 newPrice = uint256(10 ** 23).div(parseInt(_price, 5));
728 
729         require(newPrice > 0);
730 
731         etherPriceInUSD = parseInt(_price, 5);
732 
733         priceUpdateAt = block.timestamp;
734 
735         NewPriceTicker(_price);
736     }
737 
738     function mintInternal(address _address, uint256 _tokenAmount) internal returns (uint256) {
739         uint256 mintedAmount = token.mint(_address, _tokenAmount);
740 
741         require(mintedAmount == _tokenAmount);
742 
743         soldTokens = soldTokens.add(_tokenAmount);
744         if (maxTokenSupply > 0) {
745             require(maxTokenSupply >= soldTokens);
746         }
747 
748         return _tokenAmount;
749     }
750 
751     function transferEthers() internal;
752 
753     function parseInt(string _a, uint _b) internal pure returns (uint) {
754         bytes memory bresult = bytes(_a);
755         uint res = 0;
756         bool decimals = false;
757         for (uint i = 0; i < bresult.length; i++) {
758             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
759                 if (decimals) {
760                     if (_b == 0) break;
761                     else _b--;
762                 }
763                 res *= 10;
764                 res += uint(bresult[i]) - 48;
765             } else if (bresult[i] == 46) decimals = true;
766         }
767         if (_b > 0) res *= 10 ** _b;
768         return res;
769     }
770 }
771 
772 
773 contract TokenAllocation is Ownable {
774     using SafeERC20 for ERC20Basic;
775     using SafeMath for uint256;
776 
777     address public ecosystemIncentive = 0xd339D9aeDFFa244E09874D65290c09d64b2356E0;
778     address public marketingAndBounty = 0x26d6EF95A51BF0A2048Def4Fb7c548c3BDE37410;
779     address public liquidityFund = 0x3D458b6f9024CDD9A2a7528c2E6451DD3b29e4cc;
780     address public treasure = 0x00dEaFC5959Dd0E164bB00D06B08d972A276bf8E;
781     address public amirShaikh = 0x31b17e7a2F86d878429C03f3916d17555C0d4884;
782     address public sadiqHameed = 0x27B5cb71ff083Bd6a34764fBf82700b3669137f3;
783     address public omairLatif = 0x92Db818bF10Bf3BfB73942bbB1f184274aA63833;
784 
785     uint256 public icoEndTime;
786 
787     address public vestingApplicature;
788     address public vestingSimonCocking;
789     address public vestingNathanChristian;
790     address public vestingEdwinVanBerg;
791 
792     mapping(address => bool) public tokenInited;
793     address[] public vestings;
794 
795     event VestingCreated(
796         address _vesting,
797         address _beneficiary,
798         uint256 _start,
799         uint256 _cliff,
800         uint256 _duration,
801         uint256 _periods,
802         bool _revocable
803     );
804 
805     event VestingRevoked(address _vesting);
806 
807     function setICOEndTime(uint256 _icoEndTime) public onlyOwner {
808         icoEndTime = _icoEndTime;
809     }
810 
811     function initVesting() public onlyOwner() {
812         require(vestingApplicature == address(0) &&
813         vestingSimonCocking == address(0) &&
814         vestingNathanChristian == address(0) &&
815         vestingEdwinVanBerg == address(0) &&
816         icoEndTime != 0
817         );
818 
819         uint256 oneYearAfterIcoEnd = icoEndTime.add(1 years);
820 
821         vestingApplicature = createVesting(
822             0x760864dcdC58FDA80dB6883ce442B6ce44921Cf9, oneYearAfterIcoEnd, 0, 1 years, 2, false
823         );
824 
825         vestingSimonCocking = createVesting(
826             0x7f438d78a51886B24752941ba98Cc00aBA217495, oneYearAfterIcoEnd, 0, 1 years, 2, true
827         );
828 
829         vestingNathanChristian = createVesting(
830             0xfD86B8B016de558Fe39B1697cBf525592A233B2c, oneYearAfterIcoEnd, 0, 1 years, 2, true
831         );
832 
833         vestingEdwinVanBerg = createVesting(
834             0x2451A73F35874028217bC833462CCd90c72dbE6D, oneYearAfterIcoEnd, 0, 1 years, 2, true
835         );
836     }
837 
838     function allocate(MintingERC20 token) public onlyOwner() {
839         require(tokenInited[token] == false);
840 
841         tokenInited[token] = true;
842 
843         require(vestingApplicature != address(0));
844         require(vestingSimonCocking != address(0));
845         require(vestingNathanChristian != address(0));
846         require(vestingEdwinVanBerg != address(0));
847 
848         uint256 tokenPrecision = uint256(10) ** uint256(token.decimals());
849 
850         // allocate funds
851         token.mint(ecosystemIncentive, 200000000 * tokenPrecision);
852         token.mint(marketingAndBounty, 50000000 * tokenPrecision);
853         token.mint(liquidityFund, 50000000 * tokenPrecision);
854         token.mint(treasure, 200000000 * tokenPrecision);
855 
856         // allocate funds to founders
857         token.mint(amirShaikh, 73350000 * tokenPrecision);
858         token.mint(sadiqHameed, 36675000 * tokenPrecision);
859         token.mint(omairLatif, 36675000 * tokenPrecision);
860 
861         // allocate funds to advisors
862         token.mint(vestingApplicature, 1500000 * tokenPrecision);
863         token.mint(vestingSimonCocking, 750000 * tokenPrecision);
864         token.mint(vestingNathanChristian, 750000 * tokenPrecision);
865         token.mint(vestingEdwinVanBerg, 300000 * tokenPrecision);
866     }
867 
868     function createVesting(
869         address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, uint256 _periods, bool _revocable
870     ) public onlyOwner() returns (PeriodicTokenVesting) {
871         PeriodicTokenVesting vesting = new PeriodicTokenVesting(
872             _beneficiary, _start, _cliff, _duration, _periods, _revocable
873         );
874 
875         vestings.push(vesting);
876 
877         VestingCreated(vesting, _beneficiary, _start, _cliff, _duration, _periods, _revocable);
878 
879         return vesting;
880     }
881 
882     function revokeVesting(PeriodicTokenVesting _vesting, MintingERC20 token) public onlyOwner() {
883         _vesting.revoke(token);
884 
885         VestingRevoked(_vesting);
886     }
887 }
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
903 contract TokenVesting is Ownable {
904   using SafeMath for uint256;
905   using SafeERC20 for ERC20Basic;
906 
907   event Released(uint256 amount);
908   event Revoked();
909 
910   // beneficiary of tokens after they are released
911   address public beneficiary;
912 
913   uint256 public cliff;
914   uint256 public start;
915   uint256 public duration;
916 
917   bool public revocable;
918 
919   mapping (address => uint256) public released;
920   mapping (address => bool) public revoked;
921 
922   /**
923    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
924    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
925    * of the balance will have vested.
926    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
927    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
928    * @param _duration duration in seconds of the period in which the tokens will vest
929    * @param _revocable whether the vesting is revocable or not
930    */
931   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
932     require(_beneficiary != address(0));
933     require(_cliff <= _duration);
934 
935     beneficiary = _beneficiary;
936     revocable = _revocable;
937     duration = _duration;
938     cliff = _start.add(_cliff);
939     start = _start;
940   }
941 
942   /**
943    * @notice Transfers vested tokens to beneficiary.
944    * @param token ERC20 token which is being vested
945    */
946   function release(ERC20Basic token) public {
947     uint256 unreleased = releasableAmount(token);
948 
949     require(unreleased > 0);
950 
951     released[token] = released[token].add(unreleased);
952 
953     token.safeTransfer(beneficiary, unreleased);
954 
955     Released(unreleased);
956   }
957 
958   /**
959    * @notice Allows the owner to revoke the vesting. Tokens already vested
960    * remain in the contract, the rest are returned to the owner.
961    * @param token ERC20 token which is being vested
962    */
963   function revoke(ERC20Basic token) public onlyOwner {
964     require(revocable);
965     require(!revoked[token]);
966 
967     uint256 balance = token.balanceOf(this);
968 
969     uint256 unreleased = releasableAmount(token);
970     uint256 refund = balance.sub(unreleased);
971 
972     revoked[token] = true;
973 
974     token.safeTransfer(owner, refund);
975 
976     Revoked();
977   }
978 
979   /**
980    * @dev Calculates the amount that has already vested but hasn't been released yet.
981    * @param token ERC20 token which is being vested
982    */
983   function releasableAmount(ERC20Basic token) public view returns (uint256) {
984     return vestedAmount(token).sub(released[token]);
985   }
986 
987   /**
988    * @dev Calculates the amount that has already vested.
989    * @param token ERC20 token which is being vested
990    */
991   function vestedAmount(ERC20Basic token) public view returns (uint256) {
992     uint256 currentBalance = token.balanceOf(this);
993     uint256 totalBalance = currentBalance.add(released[token]);
994 
995     if (now < cliff) {
996       return 0;
997     } else if (now >= start.add(duration) || revoked[token]) {
998       return totalBalance;
999     } else {
1000       return totalBalance.mul(now.sub(start)).div(duration);
1001     }
1002   }
1003 }
1004 
1005 contract PeriodicTokenVesting is TokenVesting {
1006     uint256 public periods;
1007 
1008     function PeriodicTokenVesting(
1009         address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, uint256 _periods, bool _revocable
1010     )
1011         public TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable)
1012     {
1013         periods = _periods;
1014     }
1015 
1016     /**
1017     * @dev Calculates the amount that has already vested.
1018     * @param token ERC20 token which is being vested
1019     */
1020     function vestedAmount(ERC20Basic token) public view returns (uint256) {
1021         uint256 currentBalance = token.balanceOf(this);
1022         uint256 totalBalance = currentBalance.add(released[token]);
1023 
1024         if (now < cliff) {
1025             return 0;
1026         } else if (now >= start.add(duration * periods) || revoked[token]) {
1027             return totalBalance;
1028         } else {
1029 
1030             uint256 periodTokens = totalBalance.div(periods);
1031 
1032             uint256 periodsOver = now.sub(start).div(duration) + 1;
1033 
1034             if (periodsOver >= periods) {
1035                 return totalBalance;
1036             }
1037 
1038             return periodTokens.mul(periodsOver);
1039         }
1040     }
1041 }
1042 
1043 contract PrivateSale is SellableToken {
1044 
1045     uint256 public price;
1046     uint256 public discount;
1047     SellableToken public crowdSale;
1048 
1049     function PrivateSale(
1050         address _token,
1051         address _etherHolder,
1052         uint256 _startTime,
1053         uint256 _endTime,
1054         uint256 _maxTokenSupply, //14000000000000000000000000
1055         uint256 _etherPriceInUSD
1056     ) public SellableToken(
1057         _token,
1058         _etherHolder,
1059         _startTime,
1060         _endTime,
1061         _maxTokenSupply,
1062         _etherPriceInUSD
1063     ) {
1064         price = 24800;// $0.2480 * 10 ^ 5
1065         discount = 75;// $75%
1066     }
1067 
1068     function changeSalePeriod(uint256 _start, uint256 _end) public onlyOwner {
1069         if (_start != 0 && _start < _end) {
1070             startTime = _start;
1071             endTime = _end;
1072         }
1073     }
1074 
1075     function isActive() public view returns (bool) {
1076         if (soldTokens == maxTokenSupply) {
1077             return false;
1078         }
1079 
1080         return withinPeriod();
1081     }
1082 
1083     function withinPeriod() public view returns (bool) {
1084         return block.timestamp >= startTime && block.timestamp <= endTime;
1085     }
1086 
1087     function calculateTokensAmount(uint256 _value) public view returns (uint256 tokenAmount, uint256 usdAmount) {
1088         if (_value == 0) {
1089             return (0, 0);
1090         }
1091 
1092         usdAmount = _value.mul(etherPriceInUSD);
1093 
1094         tokenAmount = usdAmount.div(price * (100 - discount) / 100);
1095 
1096         usdAmount = usdAmount.div(uint256(10) ** 18);
1097 
1098         if (usdAmount < minPurchase) {
1099             return (0, 0);
1100         }
1101     }
1102 
1103     function calculateEthersAmount(uint256 _tokens) public view returns (uint256 ethers, uint256 usdAmount) {
1104         if (_tokens == 0) {
1105             return (0, 0);
1106         }
1107 
1108         usdAmount = _tokens.mul((price * (100 - discount) / 100));
1109         ethers = usdAmount.div(etherPriceInUSD);
1110 
1111         if (ethers < getMinEthersInvestment()) {
1112             return (0, 0);
1113         }
1114 
1115         usdAmount = usdAmount.div(uint256(10) ** 18);
1116     }
1117 
1118     function getStats(uint256 _ethPerBtc) public view returns (
1119         uint256 start,
1120         uint256 end,
1121         uint256 sold,
1122         uint256 maxSupply,
1123         uint256 min,
1124         uint256 tokensPerEth,
1125         uint256 tokensPerBtc
1126     ) {
1127         start = startTime;
1128         end = endTime;
1129         sold = soldTokens;
1130         maxSupply = maxTokenSupply;
1131         min = minPurchase;
1132         uint256 usd;
1133         (tokensPerEth, usd) = calculateTokensAmount(1 ether);
1134         (tokensPerBtc, usd) = calculateTokensAmount(_ethPerBtc);
1135     }
1136 
1137     function setCrowdSale(address _crowdSale) public onlyOwner {
1138         require(_crowdSale != address(0));
1139 
1140         crowdSale = SellableToken(_crowdSale);
1141     }
1142 
1143     function moveUnsoldTokens() public onlyOwner {
1144         require(address(crowdSale) != address(0) && now >= endTime && !isActive() && maxTokenSupply > soldTokens);
1145 
1146         crowdSale.updatePreICOMaxTokenSupply(maxTokenSupply.sub(soldTokens));
1147         maxTokenSupply = soldTokens;
1148     }
1149 
1150     function updatePreICOMaxTokenSupply(uint256) public {
1151         require(false);
1152     }
1153 
1154     function isTransferAllowed(address, uint256) public view returns (bool) {
1155         return false;
1156     }
1157 
1158     function buy(address _address, uint256 _value) internal returns (bool) {
1159         if (_value == 0 || _address == address(0)) {
1160             return false;
1161         }
1162 
1163         uint256 tokenAmount;
1164         uint256 usdAmount;
1165 
1166         (tokenAmount, usdAmount) = calculateTokensAmount(_value);
1167 
1168         uint256 mintedAmount = mintInternal(_address, tokenAmount);
1169         collectedUSD = collectedUSD.add(usdAmount);
1170         require(usdAmount > 0 && mintedAmount > 0);
1171 
1172         collectedEthers = collectedEthers.add(_value);
1173         etherBalances[_address] = etherBalances[_address].add(_value);
1174 
1175         token.increaseLockedBalance(_address, mintedAmount);
1176 
1177         transferEthers();
1178 
1179         Contribution(_address, _value, tokenAmount);
1180         return true;
1181     }
1182 
1183     function transferEthers() internal {
1184         etherHolder.transfer(this.balance);
1185     }
1186 }
1187 
1188 contract CrowdSale is SellableToken {
1189     uint256 public constant PRE_ICO_TIER_FIRST = 0;
1190     uint256 public constant PRE_ICO_TIER_LAST = 4;
1191     uint256 public constant ICO_TIER_FIRST = 5;
1192     uint256 public constant ICO_TIER_LAST = 8;
1193 
1194     SellableToken public privateSale;
1195 
1196     uint256 public price;
1197 
1198     Stats public preICOStats;
1199     mapping(address => uint256) public icoBalances;
1200 
1201     struct Stats {
1202         uint256 soldTokens;
1203         uint256 maxTokenSupply;
1204         uint256 collectedUSD;
1205         uint256 collectedEthers;
1206         bool burned;
1207     }
1208 
1209     function CrowdSale(
1210         address _token,
1211         address _etherHolder,
1212         uint256 _maxPreICOTokenSupply,
1213     //10000000000000000000000000-527309544043097299200271 + 177500000000000000000000000 = 186972690455956902700799729
1214         uint256 _maxICOTokenSupply, //62500000000000000000000000
1215         uint256 _price,
1216         uint256[2] _preIcoDuration, //1530432000  -1533081599
1217         uint256[2] _icoDuration, // 1533110400 - 1538351999
1218         uint256 _etherPriceInUSD
1219     ) public
1220     SellableToken(
1221         _token,
1222         _etherHolder,
1223             _preIcoDuration[0],
1224             _icoDuration[1],
1225         _maxPreICOTokenSupply.add(_maxICOTokenSupply),
1226         _etherPriceInUSD
1227     ) {
1228         softCap = 250000000000;
1229         hardCap = 3578912800000;
1230         price = _price;
1231         preICOStats.maxTokenSupply = _maxPreICOTokenSupply;
1232         //0.2480* 10^5
1233         //PreICO
1234         tiers.push(
1235             Tier(
1236                 uint256(65),
1237                 _preIcoDuration[0],
1238                 _preIcoDuration[0].add(1 hours)
1239             )
1240         );
1241         tiers.push(
1242             Tier(
1243                 uint256(60),
1244                 _preIcoDuration[0].add(1 hours),
1245                 _preIcoDuration[0].add(1 days)
1246             )
1247         );
1248         tiers.push(
1249             Tier(
1250                 uint256(57),
1251                 _preIcoDuration[0].add(1 days),
1252                 _preIcoDuration[0].add(2 days)
1253             )
1254         );
1255         tiers.push(
1256             Tier(
1257                 uint256(55),
1258                 _preIcoDuration[0].add(2 days),
1259                 _preIcoDuration[0].add(3 days)
1260             )
1261         );
1262         tiers.push(
1263             Tier(
1264                 uint256(50),
1265                 _preIcoDuration[0].add(3 days),
1266                 _preIcoDuration[1]
1267             )
1268         );
1269         //ICO
1270         tiers.push(
1271             Tier(
1272                 uint256(25),
1273                 _icoDuration[0],
1274                 _icoDuration[0].add(1 weeks)
1275             )
1276         );
1277         tiers.push(
1278             Tier(
1279                 uint256(15),
1280                 _icoDuration[0].add(1 weeks),
1281                 _icoDuration[0].add(2 weeks)
1282             )
1283         );
1284         tiers.push(
1285             Tier(
1286                 uint256(10),
1287                 _icoDuration[0].add(2 weeks),
1288                 _icoDuration[0].add(3 weeks)
1289             )
1290         );
1291         tiers.push(
1292             Tier(
1293                 uint256(5),
1294                 _icoDuration[0].add(3 weeks),
1295                 _icoDuration[1]
1296             )
1297         );
1298 
1299     }
1300 
1301     function changeICODates(uint256 _tierId, uint256 _start, uint256 _end) public onlyOwner {
1302         require(_start != 0 && _start < _end && _tierId < tiers.length);
1303         Tier storage icoTier = tiers[_tierId];
1304         icoTier.startTime = _start;
1305         icoTier.endTime = _end;
1306         if (_tierId == PRE_ICO_TIER_FIRST) {
1307             startTime = _start;
1308         } else if (_tierId == ICO_TIER_LAST) {
1309             endTime = _end;
1310         }
1311     }
1312 
1313     function isActive() public view returns (bool) {
1314         if (hardCap == collectedUSD.add(preICOStats.collectedUSD)) {
1315             return false;
1316         }
1317         if (soldTokens == maxTokenSupply) {
1318             return false;
1319         }
1320 
1321         return withinPeriod();
1322     }
1323 
1324     function withinPeriod() public view returns (bool) {
1325         return getActiveTier() != tiers.length;
1326     }
1327 
1328     function setPrivateSale(address _privateSale) public onlyOwner {
1329         if (_privateSale != address(0)) {
1330             privateSale = SellableToken(_privateSale);
1331         }
1332     }
1333 
1334     function getActiveTier() public view returns (uint256) {
1335         for (uint256 i = 0; i < tiers.length; i++) {
1336             if (block.timestamp >= tiers[i].startTime && block.timestamp <= tiers[i].endTime) {
1337                 return i;
1338             }
1339         }
1340 
1341         return uint256(tiers.length);
1342     }
1343 
1344     function calculateTokensAmount(uint256 _value) public view returns (uint256 tokenAmount, uint256 usdAmount) {
1345         if (_value == 0) {
1346             return (0, 0);
1347         }
1348         uint256 activeTier = getActiveTier();
1349 
1350         if (activeTier == tiers.length) {
1351             if (endTime < block.timestamp) {
1352                 return (0, 0);
1353             }
1354             if (startTime > block.timestamp) {
1355                 activeTier = PRE_ICO_TIER_FIRST;
1356             }
1357         }
1358         usdAmount = _value.mul(etherPriceInUSD);
1359 
1360         tokenAmount = usdAmount.div(price * (100 - tiers[activeTier].discount) / 100);
1361 
1362         usdAmount = usdAmount.div(uint256(10) ** 18);
1363 
1364         if (usdAmount < minPurchase) {
1365             return (0, 0);
1366         }
1367     }
1368 
1369     function calculateEthersAmount(uint256 _tokens) public view returns (uint256 ethers, uint256 usdAmount) {
1370         if (_tokens == 0) {
1371             return (0, 0);
1372         }
1373 
1374         uint256 activeTier = getActiveTier();
1375 
1376         if (activeTier == tiers.length) {
1377             if (endTime < block.timestamp) {
1378                 return (0, 0);
1379             }
1380             if (startTime > block.timestamp) {
1381                 activeTier = PRE_ICO_TIER_FIRST;
1382             }
1383         }
1384 
1385         usdAmount = _tokens.mul((price * (100 - tiers[activeTier].discount) / 100));
1386         ethers = usdAmount.div(etherPriceInUSD);
1387 
1388         if (ethers < getMinEthersInvestment()) {
1389             return (0, 0);
1390         }
1391 
1392         usdAmount = usdAmount.div(uint256(10) ** 18);
1393     }
1394 
1395     function getStats(uint256 _ethPerBtc) public view returns (
1396         uint256 sold,
1397         uint256 maxSupply,
1398         uint256 min,
1399         uint256 soft,
1400         uint256 hard,
1401         uint256 tokenPrice,
1402         uint256 tokensPerEth,
1403         uint256 tokensPerBtc,
1404         uint256[27] tiersData
1405     ) {
1406         sold = soldTokens;
1407         maxSupply = maxTokenSupply.sub(preICOStats.maxTokenSupply);
1408         min = minPurchase;
1409         soft = softCap;
1410         hard = hardCap;
1411         tokenPrice = price;
1412         uint256 usd;
1413         (tokensPerEth, usd) = calculateTokensAmount(1 ether);
1414         (tokensPerBtc, usd) = calculateTokensAmount(_ethPerBtc);
1415         uint256 j = 0;
1416         for (uint256 i = 0; i < tiers.length; i++) {
1417             tiersData[j++] = uint256(tiers[i].discount);
1418             tiersData[j++] = uint256(tiers[i].startTime);
1419             tiersData[j++] = uint256(tiers[i].endTime);
1420         }
1421     }
1422 
1423     function burnUnsoldTokens() public onlyOwner {
1424         if (block.timestamp >= endTime && maxTokenSupply > soldTokens) {
1425             token.burnUnsoldTokens(maxTokenSupply.sub(soldTokens));
1426             maxTokenSupply = soldTokens;
1427         }
1428     }
1429 
1430     function isTransferAllowed(address _from, uint256 _value) public view returns (bool status){
1431         if (collectedUSD.add(preICOStats.collectedUSD) < softCap) {
1432             if (token.balanceOf(_from) >= icoBalances[_from] && token.balanceOf(_from).sub(icoBalances[_from])> _value) {
1433                 return true;
1434             }
1435             return false;
1436         }
1437         return true;
1438     }
1439 
1440     function isRefundPossible() public view returns (bool) {
1441         if (isActive() || block.timestamp < startTime || collectedUSD.add(preICOStats.collectedUSD) >= softCap) {
1442             return false;
1443         }
1444         return true;
1445     }
1446 
1447     function refund() public returns (bool) {
1448         if (!isRefundPossible() || etherBalances[msg.sender] == 0) {
1449             return false;
1450         }
1451 
1452         uint256 burnedAmount = token.burnInvestorTokens(msg.sender, icoBalances[msg.sender]);
1453         if (burnedAmount == 0) {
1454             return false;
1455         }
1456         uint256 etherBalance = etherBalances[msg.sender];
1457         etherBalances[msg.sender] = 0;
1458 
1459         msg.sender.transfer(etherBalance);
1460 
1461         Refund(msg.sender, etherBalance, burnedAmount);
1462 
1463         return true;
1464     }
1465 
1466     function updatePreICOMaxTokenSupply(uint256 _amount) public {
1467         if (msg.sender == address(privateSale)) {
1468             maxTokenSupply = maxTokenSupply.add(_amount);
1469             preICOStats.maxTokenSupply = preICOStats.maxTokenSupply.add(_amount);
1470         }
1471     }
1472 
1473     function moveUnsoldTokensToICO() public onlyOwner {
1474         uint256 unsoldTokens = preICOStats.maxTokenSupply - preICOStats.soldTokens;
1475         if (unsoldTokens > 0) {
1476             preICOStats.maxTokenSupply = preICOStats.soldTokens;
1477         }
1478     }
1479 
1480     function transferEthers() internal {
1481         if (collectedUSD.add(preICOStats.collectedUSD) >= softCap) {
1482             etherHolder.transfer(this.balance);
1483         }
1484     }
1485 
1486     function mintPreICO(
1487         address _address,
1488         uint256 _tokenAmount,
1489         uint256 _ethAmount,
1490         uint256 _usdAmount
1491     ) internal returns (uint256) {
1492         uint256 mintedAmount = token.mint(_address, _tokenAmount);
1493 
1494         require(mintedAmount == _tokenAmount);
1495 
1496         preICOStats.soldTokens = preICOStats.soldTokens.add(_tokenAmount);
1497         preICOStats.collectedEthers = preICOStats.collectedEthers.add(_ethAmount);
1498         preICOStats.collectedUSD = preICOStats.collectedUSD.add(_usdAmount);
1499 
1500         require(preICOStats.maxTokenSupply >= preICOStats.soldTokens);
1501         require(maxTokenSupply >= preICOStats.soldTokens);
1502 
1503         return _tokenAmount;
1504     }
1505 
1506     function buy(address _address, uint256 _value) internal returns (bool) {
1507         if (_value == 0 || _address == address(0)) {
1508             return false;
1509         }
1510 
1511         uint256 activeTier = getActiveTier();
1512         if (activeTier == tiers.length) {
1513             return false;
1514         }
1515 
1516         uint256 tokenAmount;
1517         uint256 usdAmount;
1518         uint256 mintedAmount;
1519 
1520         (tokenAmount, usdAmount) = calculateTokensAmount(_value);
1521         require(usdAmount > 0 && tokenAmount > 0);
1522 
1523         if (activeTier >= PRE_ICO_TIER_FIRST && activeTier <= PRE_ICO_TIER_LAST) {
1524             mintedAmount = mintPreICO(_address, tokenAmount, _value, usdAmount);
1525             etherHolder.transfer(this.balance);
1526         } else {
1527             mintedAmount = mintInternal(_address, tokenAmount);
1528             require(soldTokens <= maxTokenSupply.sub(preICOStats.maxTokenSupply));
1529             collectedUSD = collectedUSD.add(usdAmount);
1530             require(hardCap >= collectedUSD.add(preICOStats.collectedUSD) && usdAmount > 0 && mintedAmount > 0);
1531 
1532             collectedEthers = collectedEthers.add(_value);
1533             etherBalances[_address] = etherBalances[_address].add(_value);
1534             icoBalances[_address] = icoBalances[_address].add(tokenAmount);
1535             transferEthers();
1536         }
1537 
1538         Contribution(_address, _value, tokenAmount);
1539 
1540         return true;
1541     }
1542 }