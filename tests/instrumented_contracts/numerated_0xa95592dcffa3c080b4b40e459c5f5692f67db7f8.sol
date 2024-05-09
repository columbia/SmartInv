1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title SafeERC20
6  * @dev Wrappers around ERC20 operations that throw on failure.
7  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
8  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
9  */
10 library SafeERC20 {
11   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
12     assert(token.transfer(to, value));
13   }
14 
15   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
16     assert(token.transferFrom(from, to, value));
17   }
18 
19   function safeApprove(ERC20 token, address spender, uint256 value) internal {
20     assert(token.approve(spender, value));
21   }
22 }
23 
24 
25 /**
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 
63 }
64 
65 /**
66  * @title ERC20Basic
67  * @dev Simpler version of ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/179
69  */
70 contract ERC20Basic {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 totalSupply_;
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     // SafeMath.sub will throw if there is not enough balance.
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256 balance) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender) public view returns (uint256);
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
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
229 contract ElyERC20 is StandardToken, Ownable {
230     /* Public variables of the token */
231     uint256 public creationBlock;
232 
233     uint8 public decimals;
234 
235     string public name;
236 
237     string public symbol;
238 
239     string public standard;
240 
241     bool public locked;
242 
243     /* Initializes contract with initial supply tokens to the creator of the contract */
244     function ElyERC20(
245         uint256 _totalSupply,
246         string _tokenName,
247         uint8 _decimalUnits,
248         string _tokenSymbol,
249         bool _transferAllSupplyToOwner,
250         bool _locked
251     ) public {
252         standard = 'ERC20 0.1';
253         locked = _locked;
254         totalSupply_ = _totalSupply;
255 
256         if (_transferAllSupplyToOwner) {
257             balances[msg.sender] = totalSupply_;
258         } else {
259             balances[this] = totalSupply_;
260         }
261         name = _tokenName;
262         // Set the name for display purposes
263         symbol = _tokenSymbol;
264         // Set the symbol for display purposes
265         decimals = _decimalUnits;
266         // Amount of decimals for display purposes
267         creationBlock = block.number;
268     }
269 
270     /* public methods */
271     function transfer(address _to, uint256 _value) public returns (bool) {
272         require(locked == false);
273         return super.transfer(_to, _value);
274     }
275 
276     function approve(address _spender, uint256 _value) public returns (bool success) {
277         if (locked) {
278             return false;
279         }
280         return super.approve(_spender, _value);
281     }
282 
283     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
284         if (locked) {
285             return false;
286         }
287         return super.increaseApproval(_spender, _addedValue);
288     }
289 
290     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
291         if (locked) {
292             return false;
293         }
294         return super.decreaseApproval(_spender, _subtractedValue);
295     }
296 
297     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
298         if (locked) {
299             return false;
300         }
301 
302         return super.transferFrom(_from, _to, _value);
303     }
304 
305 }
306 
307 
308 /**
309  * @title SafeMath
310  * @dev Math operations with safety checks that throw on error
311  */
312 library SafeMath {
313 
314   /**
315   * @dev Multiplies two numbers, throws on overflow.
316   */
317   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
318     if (a == 0) {
319       return 0;
320     }
321     uint256 c = a * b;
322     assert(c / a == b);
323     return c;
324   }
325 
326   /**
327   * @dev Integer division of two numbers, truncating the quotient.
328   */
329   function div(uint256 a, uint256 b) internal pure returns (uint256) {
330     // assert(b > 0); // Solidity automatically throws when dividing by 0
331     uint256 c = a / b;
332     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
333     return c;
334   }
335 
336   /**
337   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
338   */
339   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
340     assert(b <= a);
341     return a - b;
342   }
343 
344   /**
345   * @dev Adds two numbers, throws on overflow.
346   */
347   function add(uint256 a, uint256 b) internal pure returns (uint256) {
348     uint256 c = a + b;
349     assert(c >= a);
350     return c;
351   }
352 }
353 
354 /*
355 This contract manages the minters and the modifier to allow mint to happen only if called by minters
356 This contract contains basic minting functionality though
357 */
358 contract MintingERC20 is ElyERC20 {
359 
360     using SafeMath for uint256;
361 
362     //Variables
363     mapping (address => bool) public minters;
364 
365     uint256 public maxSupply;
366 
367     //Modifiers
368     modifier onlyMinters () {
369         require(true == minters[msg.sender]);
370         _;
371     }
372 
373     function MintingERC20(
374         uint256 _initialSupply,
375         uint256 _maxSupply,
376         string _tokenName,
377         uint8 _decimals,
378         string _symbol,
379         bool _transferAllSupplyToOwner,
380         bool _locked
381     )
382         public ElyERC20(_initialSupply, _tokenName, _decimals, _symbol, _transferAllSupplyToOwner, _locked)
383     {
384         standard = 'MintingERC20 0.1';
385         minters[msg.sender] = true;
386         maxSupply = _maxSupply;
387     }
388 
389     function addMinter(address _newMinter) public onlyOwner {
390         minters[_newMinter] = true;
391     }
392 
393     function removeMinter(address _minter) public onlyOwner {
394         minters[_minter] = false;
395     }
396 
397     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
398         if (true == locked) {
399             return uint256(0);
400         }
401 
402         if (_amount == uint256(0)) {
403             return uint256(0);
404         }
405 
406         if (totalSupply_.add(_amount) > maxSupply) {
407             return uint256(0);
408         }
409 
410         totalSupply_ = totalSupply_.add(_amount);
411         balances[_addr] = balances[_addr].add(_amount);
412         Transfer(address(0), _addr, _amount);
413 
414         return _amount;
415     }
416 
417 }
418 
419 contract ElyToken is MintingERC20 {
420 
421     SellableToken public ico;
422     SellableToken public privateSale;
423     LockupContract public lockupContract;
424 
425     address public bountyAddress;
426 
427     bool public transferFrozen = true;
428 
429     modifier onlySellable() {
430         require(msg.sender == address(ico) || msg.sender == address(privateSale));
431         _;
432     }
433 
434     event Burn(address indexed burner, uint256 value);
435 
436     function ElyToken(
437         address _bountyAddress,
438         bool _locked
439     )
440         public MintingERC20(0, maxSupply, 'Elycoin', 18, 'ELY', false, _locked)
441     {
442         require(_bountyAddress != address(0));
443         bountyAddress = _bountyAddress;
444         standard = 'ELY 0.1';
445         maxSupply = uint(1000000000).mul(uint(10) ** decimals);
446         uint256 bountyAmount = uint(10000000).mul(uint(10) ** decimals);
447         require(bountyAmount == super.mint(bountyAddress, bountyAmount));
448     }
449 
450     function setICO(address _ico) public onlyOwner {
451         require(_ico != address(0));
452         ico = SellableToken(_ico);
453     }
454 
455     function setPrivateSale(address _privateSale) public onlyOwner {
456         require(_privateSale != address(0));
457         privateSale = SellableToken(_privateSale);
458     }
459 
460     function setLockupContract(address _lockupContract) public onlyOwner {
461         require(_lockupContract != address(0));
462         lockupContract = LockupContract(_lockupContract);
463     }
464 
465     function setLocked(bool _locked) public onlyOwner {
466         locked = _locked;
467     }
468 
469     function freezing(bool _transferFrozen) public onlyOwner {
470         if (address(ico) != address(0) && !ico.isActive() && block.timestamp >= ico.startTime()) {
471             transferFrozen = _transferFrozen;
472         }
473     }
474 
475     function mint(address _addr, uint256 _amount) public onlyMinters returns (uint256) {
476         if (msg.sender == owner) {
477             require(address(ico) != address(0));
478             if (!ico.isActive()) {
479                 return super.mint(_addr, _amount);
480             }
481             return uint256(0);
482         }
483         return super.mint(_addr, _amount);
484     }
485 
486     function transferAllowed(address _address, uint256 _amount) public view returns (bool) {
487         return !transferFrozen && lockupContract.isTransferAllowed(_address, _amount);
488     }
489 
490     function transfer(address _to, uint _value) public returns (bool) {
491         require(msg.sender == bountyAddress || transferAllowed(msg.sender, _value));
492         if (msg.sender == bountyAddress) {
493             lockupContract.log(_to, _value);
494         }
495         return super.transfer(_to, _value);
496     }
497 
498     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
499         require(_from == bountyAddress || transferAllowed(_from, _value));
500         if (_from == bountyAddress) {
501             lockupContract.log(_to, _value);
502         }
503         return super.transferFrom(_from, _to, _value);
504     }
505 
506     function burnTokens(uint256 _amount) public onlySellable {
507         if (totalSupply_.add(_amount) > maxSupply) {
508             Burn(address(this), maxSupply.sub(totalSupply_));
509             totalSupply_ = maxSupply;
510         } else {
511             totalSupply_ = totalSupply_.add(_amount);
512             Burn(address(this), _amount);
513         }
514     }
515 
516     function burnInvestorTokens(address _address, uint256 _amount) public constant onlySellable returns (uint256) {
517         require(balances[_address] >= _amount);
518         balances[_address] = balances[_address].sub(_amount);
519         Burn(_address, _amount);
520         Transfer(_address, address(0), _amount);
521 
522         return _amount;
523     }
524 
525 }
526 
527 contract Multivest is Ownable {
528 
529     using SafeMath for uint256;
530 
531     /* public variables */
532     mapping (address => bool) public allowedMultivests;
533 
534     /* events */
535     event MultivestSet(address multivest);
536 
537     event MultivestUnset(address multivest);
538 
539     event Contribution(address holder, uint256 value, uint256 tokens);
540 
541     modifier onlyAllowedMultivests(address _addresss) {
542         require(allowedMultivests[_addresss] == true);
543         _;
544     }
545 
546     /* constructor */
547     function Multivest() public {}
548 
549     function setAllowedMultivest(address _address) public onlyOwner {
550         allowedMultivests[_address] = true;
551         MultivestSet(_address);
552     }
553 
554     function unsetAllowedMultivest(address _address) public onlyOwner {
555         allowedMultivests[_address] = false;
556         MultivestUnset(_address);
557     }
558 
559     function multivestBuy(address _address, uint256 _value) public onlyAllowedMultivests(msg.sender) {
560         require(buy(_address, _value) == true);
561     }
562 
563     function multivestBuy(
564         address _address,
565         uint8 _v,
566         bytes32 _r,
567         bytes32 _s
568     ) public payable onlyAllowedMultivests(verify(keccak256(msg.sender), _v, _r, _s)) {
569         require(_address == msg.sender && buy(msg.sender, msg.value) == true);
570     }
571 
572     function verify(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns (address) {
573         bytes memory prefix = '\x19Ethereum Signed Message:\n32';
574 
575         return ecrecover(keccak256(prefix, _hash), _v, _r, _s);
576     }
577 
578     function buy(address _address, uint256 _value) internal returns (bool);
579 
580 }
581 
582 contract SellableToken is Multivest {
583 
584     ElyToken public token;
585 
586     uint256 public constant DECIMALS = 18;
587 
588     uint256 public minPurchase = 1000000;//10usd * 10 ^ 5
589 
590     uint256 public softCap = 300000000000;//usd * 10 ^ 5
591     uint256 public hardCap = 1500000000000;//usd * 10 ^ 5
592 
593     uint256 public compensationAmount = 5100000000;//usd * 10 ^ 5
594     uint256 public compensatedAmount;
595 
596     uint256 public startTime;
597     uint256 public endTime;
598 
599     uint256 public maxTokenSupply;
600 
601     uint256 public soldTokens;
602 
603     uint256 public collectedEthers;
604 
605     uint256 public priceUpdateAt;
606 
607     address public etherHolder;
608 
609     address public compensationAddress;
610 
611     uint256 public collectedUSD;
612 
613     uint256 public etherPriceInUSD; //$753.25  75325000
614 
615     mapping (address => uint256) public etherBalances;
616 
617     mapping (address => bool) public whitelist;
618 
619     Tier[] public tiers;
620 
621     struct Tier {
622         uint256 maxAmount;
623         uint256 price;
624         uint256 startTime;
625         uint256 endTime;
626     }
627 
628     event WhitelistSet(address indexed contributorAddress, bool isWhitelisted);
629 
630     event Refund(address _holder, uint256 _ethers, uint256 _tokens);
631 
632     function SellableToken(
633         address _token,
634         address _etherHolder,
635         address _compensationAddress,
636         uint256 _etherPriceInUSD,
637         uint256 _maxTokenSupply
638     )
639         public Multivest()
640     {
641         require(_token != address(0));
642         token = ElyToken(_token);
643 
644         require(_etherHolder != address(0) && _compensationAddress != address(0));
645         etherHolder = _etherHolder;
646         compensationAddress = _compensationAddress;
647         require((_maxTokenSupply == uint256(0)) || (_maxTokenSupply <= token.maxSupply()));
648 
649         etherPriceInUSD = _etherPriceInUSD;
650         maxTokenSupply = _maxTokenSupply;
651 
652         priceUpdateAt = block.timestamp;
653     }
654 
655     function() public payable {
656         require(true == whitelist[msg.sender] && buy(msg.sender, msg.value) == true);
657     }
658 
659     function setTokenContract(address _token) public onlyOwner {
660         require(_token != address(0));
661         token = ElyToken(_token);
662     }
663 
664     function isActive() public view returns (bool) {
665         if (maxTokenSupply > uint256(0) && soldTokens == maxTokenSupply) {
666             return false;
667         }
668 
669         return withinPeriod();
670     }
671 
672     function withinPeriod() public view returns (bool) {
673         return block.timestamp >= startTime && block.timestamp <= endTime;
674     }
675 
676     function setEtherHolder(address _etherHolder) public onlyOwner {
677         if (_etherHolder != address(0)) {
678             etherHolder = _etherHolder;
679         }
680     }
681 
682     function updateWhitelist(address _address, bool isWhitelisted) public onlyOwner {
683         whitelist[_address] = isWhitelisted;
684         WhitelistSet(_address, isWhitelisted);
685     }
686 
687     function mint(address _address, uint256 _tokenAmount) public onlyOwner returns (uint256) {
688         return mintInternal(_address, _tokenAmount);
689     }
690 
691     function setEtherPriceInUSD(string _price) public onlyOwner {
692         setEtherInUSDInternal(_price);
693     }
694 
695     function setEtherInUSD(string _price) public onlyAllowedMultivests(msg.sender) {
696         setEtherInUSDInternal(_price);
697     }
698 
699     // set ether price in USD with 5 digits after the decimal point
700     //ex. 308.75000
701     //for updating the price through  multivest
702     function setEtherInUSDInternal(string _price) internal {
703         bytes memory bytePrice = bytes(_price);
704         uint256 dot = bytePrice.length.sub(uint256(6));
705 
706         // check if dot is in 6 position  from  the last
707         require(0x2e == uint(bytePrice[dot]));
708 
709         uint256 newPrice = uint256(10 ** 23).div(parseInt(_price, 5));
710 
711         require(newPrice > 0);
712 
713         etherPriceInUSD = parseInt(_price, 5);
714 
715         priceUpdateAt = block.timestamp;
716     }
717 
718     function mintInternal(address _address, uint256 _tokenAmount) internal returns (uint256) {
719         uint256 mintedAmount = token.mint(_address, _tokenAmount);
720 
721         require(mintedAmount == _tokenAmount);
722 
723         mintedAmount = mintedAmount.add(token.mint(compensationAddress, _tokenAmount.mul(5).div(1000)));
724 
725         soldTokens = soldTokens.add(_tokenAmount);
726         if (maxTokenSupply > 0) {
727             require(maxTokenSupply >= soldTokens);
728         }
729 
730         return _tokenAmount;
731     }
732 
733     function transferEthersInternal() internal {
734         if (collectedUSD >= softCap) {
735             if (compensatedAmount < compensationAmount) {
736                 uint256 amount = uint256(1 ether).mul(compensationAmount.sub(compensatedAmount)).div(etherPriceInUSD);
737                 compensatedAmount = compensationAmount;
738                 compensationAddress.transfer(amount);
739             }
740 
741             etherHolder.transfer(this.balance);
742         }
743     }
744 
745     function parseInt(string _a, uint _b) internal pure returns (uint) {
746         bytes memory bresult = bytes(_a);
747         uint mintt = 0;
748         bool decimals = false;
749         for (uint i = 0; i < bresult.length; i++) {
750             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
751                 if (decimals) {
752                     if (_b == 0) break;
753                     else _b--;
754                 }
755                 mintt *= 10;
756                 mintt += uint(bresult[i]) - 48;
757             } else if (bresult[i] == 46) decimals = true;
758         }
759         if (_b > 0) mintt *= 10 ** _b;
760         return mintt;
761     }
762 
763 }
764 
765 contract ICO is SellableToken {
766 
767     SellableToken public privateSale;
768     LockupContract public lockupContract;
769 
770     uint8 public constant PRE_ICO_TIER = 0;
771     uint8 public constant ICO_TIER_FIRST = 1;
772     uint8 public constant ICO_TIER_TWO = 2;
773     uint8 public constant ICO_TIER_LAST = 3;
774 
775     Stats public preICOStats;
776 
777     uint256 public lockupThreshold = 10000000000;
778 
779     mapping(address => uint256) public icoBalances;
780     mapping(address => uint256) public icoLockedBalance;
781 
782     struct Stats {
783         uint256 soldTokens;
784         uint256 collectedUSD;
785         uint256 collectedEthers;
786         bool burned;
787     }
788 
789     function ICO(
790         address _token,
791         address _etherHolder,
792         address _compensationAddress,
793         uint256 _etherPriceInUSD, // if price 709.38000 the  value has to be 70938000
794         uint256 _maxTokenSupply
795     ) public SellableToken(
796         _token,
797         _etherHolder,
798         _compensationAddress,
799         _etherPriceInUSD,
800         _maxTokenSupply
801     ) {
802         tiers.push(
803             Tier(
804                 uint256(40000000).mul(uint256(10) ** DECIMALS),
805                 uint256(6000),
806                 1526886000,
807                 1528095599
808             )
809         );//@ 0,06 USD PreICO
810         tiers.push(
811             Tier(
812                 uint256(150000000).mul(uint256(10) ** DECIMALS),
813                 uint256(8000),
814                 1528095600,
815                 1528700399
816             )
817         );//@ 0,08 USD
818         tiers.push(
819             Tier(
820                 uint256(150000000).mul(uint256(10) ** DECIMALS),
821                 uint256(10000),
822                 1528700400,
823                 1529305199
824             )
825         );//@ 0,10 USD
826         tiers.push(
827             Tier(
828                 uint256(150000000).mul(uint256(10) ** DECIMALS),
829                 uint256(12000),
830                 1529305200,
831                 1529909999
832             )
833         );//@ 0,12 USD
834 
835         startTime = 1528095600;
836         endTime = 1529909999;
837     }
838 
839     function setPrivateSale(address _privateSale) public onlyOwner {
840         if (_privateSale != address(0)) {
841             privateSale = SellableToken(_privateSale);
842         }
843     }
844 
845     function setLockupContract(address _lockupContract) public onlyOwner {
846         require(_lockupContract != address(0));
847         lockupContract = LockupContract(_lockupContract);
848     }
849 
850     function changePreICODates(uint256 _start, uint256 _end) public onlyOwner {
851         if (_start != 0 && _start < _end) {
852             Tier storage preICOTier = tiers[PRE_ICO_TIER];
853             preICOTier.startTime = _start;
854             preICOTier.endTime = _end;
855         }
856     }
857 
858     function changeICODates(uint8 _tierId, uint256 _start, uint256 _end) public onlyOwner {
859         if (_start != 0 && _start < _end && _tierId < tiers.length) {
860             Tier storage icoTier = tiers[_tierId];
861             icoTier.startTime = _start;
862             icoTier.endTime = _end;
863             if (_tierId == ICO_TIER_FIRST) {
864                 startTime = _start;
865             } else if (_tierId == ICO_TIER_LAST) {
866                 endTime = _end;
867             }
868         }
869     }
870 
871     function burnUnsoldTokens() public onlyOwner {
872         if (block.timestamp >= tiers[PRE_ICO_TIER].endTime && preICOStats.burned == false) {
873             token.burnTokens(tiers[PRE_ICO_TIER].maxAmount.sub(preICOStats.soldTokens));
874             preICOStats.burned = true;
875         }
876         if (block.timestamp >= endTime && maxTokenSupply > soldTokens) {
877             token.burnTokens(maxTokenSupply.sub(soldTokens));
878             maxTokenSupply = soldTokens;
879         }
880     }
881 
882     function transferEthers() public onlyOwner {
883         super.transferEthersInternal();
884     }
885 
886     function transferCompensationEthers() public {
887         if (msg.sender == compensationAddress) {
888             super.transferEthersInternal();
889         }
890     }
891 
892     function getActiveTier() public view returns (uint8) {
893         for (uint8 i = 0; i < tiers.length; i++) {
894             if (block.timestamp >= tiers[i].startTime && block.timestamp <= tiers[i].endTime) {
895                 return i;
896             }
897         }
898 
899         return uint8(tiers.length);
900     }
901 
902     function calculateTokensAmount(uint256 _value, bool _isEther) public view returns (
903         uint256 tokenAmount,
904         uint256 currencyAmount
905     ) {
906         uint8 activeTier = getActiveTier();
907 
908         if (activeTier == tiers.length) {
909             if (endTime < block.timestamp) {
910                 return (0, 0);
911             }
912             if (startTime > block.timestamp) {
913                 activeTier = PRE_ICO_TIER;
914             }
915         }
916 
917         if (_isEther) {
918             currencyAmount = _value.mul(etherPriceInUSD);
919             tokenAmount = currencyAmount.div(tiers[activeTier].price);
920             if (currencyAmount < minPurchase.mul(1 ether)) {
921                 return (0, 0);
922             }
923             currencyAmount = currencyAmount.div(1 ether);
924         } else {
925             if (_value < minPurchase) {
926                 return (0, 0);
927             }
928             currencyAmount = uint256(1 ether).mul(_value).div(etherPriceInUSD);
929             tokenAmount = _value.mul(uint256(10) ** DECIMALS).div(tiers[activeTier].price);
930         }
931     }
932 
933     function calculateEthersAmount(uint256 _amount) public view returns (uint256 ethersAmount) {
934         uint8 activeTier = getActiveTier();
935 
936         if (activeTier == tiers.length) {
937             if (endTime < block.timestamp) {
938                 return 0;
939             }
940             if (startTime > block.timestamp) {
941                 activeTier = PRE_ICO_TIER;
942             }
943         }
944 
945         if (_amount == 0 || _amount.mul(tiers[activeTier].price) < minPurchase) {
946             return 0;
947         }
948 
949         ethersAmount = _amount.mul(tiers[activeTier].price).div(etherPriceInUSD);
950     }
951 
952     function getMinEthersInvestment() public view returns (uint256) {
953         return uint256(1 ether).mul(minPurchase).div(etherPriceInUSD);
954     }
955 
956     function getStats() public view returns (
957         uint256 start,
958         uint256 end,
959         uint256 sold,
960         uint256 totalSoldTokens,
961         uint256 maxSupply,
962         uint256 min,
963         uint256 soft,
964         uint256 hard,
965         uint256 tokensPerEth,
966         uint256[16] tiersData
967     ) {
968         start = startTime;
969         end = endTime;
970         sold = soldTokens;
971         totalSoldTokens = soldTokens.add(preICOStats.soldTokens);
972         if (address(privateSale) != address(0)) {
973             totalSoldTokens = totalSoldTokens.add(privateSale.soldTokens());
974         }
975         maxSupply = maxTokenSupply;
976         min = minPurchase;
977         soft = softCap;
978         hard = hardCap;
979         uint256 usd;
980         (tokensPerEth, usd) = calculateTokensAmount(1 ether, true);
981         uint256 j = 0;
982         for (uint256 i = 0; i < tiers.length; i++) {
983             tiersData[j++] = uint256(tiers[i].maxAmount);
984             tiersData[j++] = uint256(tiers[i].price);
985             tiersData[j++] = uint256(tiers[i].startTime);
986             tiersData[j++] = uint256(tiers[i].endTime);
987         }
988     }
989 
990     function isRefundPossible() public view returns (bool) {
991         if (getActiveTier() != tiers.length || block.timestamp < startTime || collectedUSD >= softCap) {
992             return false;
993         }
994         return true;
995     }
996 
997     function refund() public returns (bool) {
998         uint256 balance = etherBalances[msg.sender];
999         if (!isRefundPossible() || balance == 0) {
1000             return false;
1001         }
1002 
1003         uint256 burnedAmount = token.burnInvestorTokens(msg.sender, icoBalances[msg.sender]);
1004         if (burnedAmount == 0) {
1005             return false;
1006         }
1007         if (icoLockedBalance[msg.sender] > 0) {
1008             lockupContract.decreaseAfterBurn(msg.sender, icoLockedBalance[msg.sender]);
1009         }
1010         Refund(msg.sender, balance, burnedAmount);
1011         etherBalances[msg.sender] = 0;
1012         msg.sender.transfer(balance);
1013 
1014         return true;
1015     }
1016 
1017     function mintPreICO(
1018         address _address,
1019         uint256 _tokenAmount,
1020         uint256 _ethAmount,
1021         uint256 _usdAmount
1022     ) internal returns (uint256) {
1023         uint256 mintedAmount = token.mint(_address, _tokenAmount);
1024 
1025         require(mintedAmount == _tokenAmount);
1026 
1027         preICOStats.soldTokens = preICOStats.soldTokens.add(_tokenAmount);
1028         preICOStats.collectedEthers = preICOStats.collectedEthers.add(_ethAmount);
1029         preICOStats.collectedUSD = preICOStats.collectedUSD.add(_usdAmount);
1030 
1031         require(tiers[PRE_ICO_TIER].maxAmount >= preICOStats.soldTokens);
1032 
1033         if (preICOStats.collectedUSD <= compensationAmount) {
1034             compensatedAmount = compensatedAmount.add(_usdAmount);
1035             compensationAddress.transfer(this.balance);
1036         }
1037 
1038         return _tokenAmount;
1039     }
1040 
1041     function buy(address _address, uint256 _value) internal returns (bool) {
1042         if (_value == 0 || _address == address(0)) {
1043             return false;
1044         }
1045         uint8 activeTier = getActiveTier();
1046         if (activeTier == tiers.length) {
1047             return false;
1048         }
1049 
1050         uint256 tokenAmount;
1051         uint256 usdAmount;
1052         uint256 mintedAmount;
1053 
1054         (tokenAmount, usdAmount) = calculateTokensAmount(_value, true);
1055         require(usdAmount > 0 && tokenAmount > 0);
1056 
1057         if (usdAmount >= lockupThreshold) {
1058             lockupContract.logLargeContribution(_address, tokenAmount);
1059             icoLockedBalance[_address] = icoLockedBalance[_address].add(tokenAmount);
1060         }
1061 
1062         if (activeTier == PRE_ICO_TIER) {
1063             mintedAmount = mintPreICO(_address, tokenAmount, _value, usdAmount);
1064         } else {
1065             mintedAmount = mintInternal(_address, tokenAmount);
1066 
1067             collectedEthers = collectedEthers.add(_value);
1068             collectedUSD = collectedUSD.add(usdAmount);
1069 
1070             require(hardCap >= collectedUSD);
1071 
1072             etherBalances[_address] = etherBalances[_address].add(_value);
1073             icoBalances[_address] = icoBalances[_address].add(tokenAmount);
1074         }
1075 
1076         Contribution(_address, _value, tokenAmount);
1077 
1078         return true;
1079     }
1080 
1081 }
1082 
1083 contract PrivateSale is SellableToken {
1084 
1085     uint256 public price = 4000;//0.04 cents * 10 ^ 5
1086 
1087     function PrivateSale(
1088         address _token,
1089         address _etherHolder,
1090         address _compensationAddress,
1091         uint256 _startTime,
1092         uint256 _endTime,
1093         uint256 _etherPriceInUSD, // if price 709.38000 the  value has to be 70938000
1094         uint256 _maxTokenSupply
1095     ) public SellableToken(
1096         _token,
1097         _etherHolder,
1098         _compensationAddress,
1099         _etherPriceInUSD,
1100         _maxTokenSupply
1101     ) {
1102         require(_startTime > 0 && _endTime > _startTime);
1103         startTime = _startTime;
1104         endTime = _endTime;
1105     }
1106 
1107     function changeSalePeriod(uint256 _start, uint256 _end) public onlyOwner {
1108         if (_start != 0 && _start < _end) {
1109             startTime = _start;
1110             endTime = _end;
1111         }
1112     }
1113 
1114     function burnUnsoldTokens() public onlyOwner {
1115         if (block.timestamp >= endTime && maxTokenSupply > soldTokens) {
1116             token.burnTokens(maxTokenSupply.sub(soldTokens));
1117             maxTokenSupply = soldTokens;
1118         }
1119     }
1120 
1121     function calculateTokensAmount(uint256 _value) public view returns (uint256 tokenAmount, uint256 usdAmount) {
1122         if (_value == 0) {
1123             return (0, 0);
1124         }
1125 
1126         usdAmount = _value.mul(etherPriceInUSD);
1127         if (usdAmount < minPurchase.mul(1 ether)) {
1128             return (0, 0);
1129         }
1130         tokenAmount = usdAmount.div(price);
1131 
1132         usdAmount = usdAmount.div(1 ether);
1133     }
1134 
1135     function calculateEthersAmount(uint256 _amount) public view returns (uint256 ethersAmount) {
1136         if (_amount == 0 || _amount.mul(price) < minPurchase.mul(1 ether)) {
1137             return 0;
1138         }
1139 
1140         ethersAmount = _amount.mul(price).div(etherPriceInUSD);
1141     }
1142 
1143     function getMinEthersInvestment() public view returns (uint256) {
1144         return uint256(1 ether).mul(minPurchase).div(etherPriceInUSD);
1145     }
1146 
1147     function getStats() public view returns (
1148         uint256 start,
1149         uint256 end,
1150         uint256 sold,
1151         uint256 maxSupply,
1152         uint256 min,
1153         uint256 soft,
1154         uint256 hard,
1155         uint256 priceAmount,
1156         uint256 tokensPerEth
1157     ) {
1158         start = startTime;
1159         end = endTime;
1160         sold = soldTokens;
1161         maxSupply = maxTokenSupply;
1162         min = minPurchase;
1163         soft = softCap;
1164         hard = hardCap;
1165         priceAmount = price;
1166         uint256 usd;
1167         (tokensPerEth, usd) = calculateTokensAmount(1 ether);
1168     }
1169 
1170     function buy(address _address, uint256 _value) internal returns (bool) {
1171         if (_value == 0) {
1172             return false;
1173         }
1174         require(_address != address(0) && withinPeriod());
1175 
1176         uint256 tokenAmount;
1177         uint256 usdAmount;
1178 
1179         (tokenAmount, usdAmount) = calculateTokensAmount(_value);
1180 
1181         uint256 mintedAmount = token.mint(_address, tokenAmount);
1182         soldTokens = soldTokens.add(tokenAmount);
1183         require(mintedAmount == tokenAmount && maxTokenSupply >= soldTokens && usdAmount > 0 && mintedAmount > 0);
1184 
1185         collectedEthers = collectedEthers.add(_value);
1186         collectedUSD = collectedUSD.add(usdAmount);
1187 
1188         Contribution(_address, _value, tokenAmount);
1189 
1190         etherHolder.transfer(this.balance);
1191         return true;
1192     }
1193 
1194 }
1195 
1196 contract Referral is Multivest {
1197 
1198     ElyToken public token;
1199     LockupContract public lockupContract;
1200 
1201     uint256 public constant DECIMALS = 18;
1202 
1203     uint256 public totalSupply = 10000000 * 10 ** DECIMALS;
1204 
1205     address public tokenHolder;
1206 
1207     mapping (address => bool) public claimed;
1208 
1209     /* constructor */
1210     function Referral(
1211         address _token,
1212         address _tokenHolder
1213     ) public Multivest() {
1214         require(_token != address(0) && _tokenHolder != address(0));
1215         token = ElyToken(_token);
1216         tokenHolder = _tokenHolder;
1217     }
1218 
1219     function setTokenContract(address _token) public onlyOwner {
1220         if (_token != address(0)) {
1221             token = ElyToken(_token);
1222         }
1223     }
1224 
1225     function setLockupContract(address _lockupContract) public onlyOwner {
1226         require(_lockupContract != address(0));
1227         lockupContract = LockupContract(_lockupContract);
1228     }
1229 
1230     function setTokenHolder(address _tokenHolder) public onlyOwner {
1231         if (_tokenHolder != address(0)) {
1232             tokenHolder = _tokenHolder;
1233         }
1234     }
1235 
1236     function multivestMint(
1237         address _address,
1238         uint256 _amount,
1239         uint8 _v,
1240         bytes32 _r,
1241         bytes32 _s
1242     ) public onlyAllowedMultivests(verify(keccak256(msg.sender, _amount), _v, _r, _s)) {
1243         _amount = _amount.mul(10 ** DECIMALS);
1244         require(
1245             claimed[_address] == false &&
1246             _address == msg.sender &&
1247             _amount > 0 &&
1248             _amount <= totalSupply &&
1249             _amount == token.mint(_address, _amount)
1250         );
1251 
1252         totalSupply = totalSupply.sub(_amount);
1253         claimed[_address] = true;
1254         lockupContract.log(_address, _amount);
1255     }
1256 
1257     function claimUnsoldTokens() public {
1258         if (msg.sender == tokenHolder && totalSupply > 0) {
1259             require(totalSupply == token.mint(msg.sender, totalSupply));
1260             totalSupply = 0;
1261         }
1262     }
1263 
1264     function buy(address _address, uint256 value) internal returns (bool) {
1265         _address = _address;
1266         value = value;
1267         return true;
1268     }
1269 }
1270 
1271 contract LockupContract is Ownable {
1272 
1273     ElyToken public token;
1274     SellableToken public ico;
1275     Referral public referral;
1276 
1277     using SafeMath for uint256;
1278 
1279     uint256 public lockPeriod = 2 weeks;
1280     uint256 public contributionLockPeriod = uint256(1 years).div(2);
1281 
1282     mapping (address => uint256) public lockedAmount;
1283     mapping (address => uint256) public lockedContributions;
1284 
1285     function LockupContract(
1286         address _token,
1287         address _ico,
1288         address _referral
1289     ) public {
1290         require(_token != address(0) && _ico != address(0) && _referral != address(0));
1291         token = ElyToken(_token);
1292         ico = SellableToken(_ico);
1293         referral = Referral(_referral);
1294     }
1295 
1296     function setTokenContract(address _token) public onlyOwner {
1297         require(_token != address(0));
1298         token = ElyToken(_token);
1299     }
1300 
1301     function setICO(address _ico) public onlyOwner {
1302         require(_ico != address(0));
1303         ico = SellableToken(_ico);
1304     }
1305 
1306     function setRefferal(address _referral) public onlyOwner {
1307         require(_referral != address(0));
1308         referral = Referral(_referral);
1309     }
1310 
1311     function setLockPeriod(uint256 _period) public onlyOwner {
1312         lockPeriod = _period;
1313     }
1314 
1315     function setContributionLockPeriod(uint256 _period) public onlyOwner {
1316         contributionLockPeriod = _period;
1317     }
1318 
1319     function log(address _address, uint256 _amount) public {
1320         if (msg.sender == address(referral) || msg.sender == address(token)) {
1321             lockedAmount[_address] = lockedAmount[_address].add(_amount);
1322         }
1323     }
1324 
1325     function decreaseAfterBurn(address _address, uint256 _amount) public {
1326         if (msg.sender == address(ico)) {
1327             lockedContributions[_address] = lockedContributions[_address].sub(_amount);
1328         }
1329     }
1330 
1331     function logLargeContribution(address _address, uint256 _amount) public {
1332         if (msg.sender == address(ico)) {
1333             lockedContributions[_address] = lockedContributions[_address].add(_amount);
1334         }
1335     }
1336 
1337     function isTransferAllowed(address _address, uint256 _value) public view returns (bool) {
1338         if (ico.endTime().add(lockPeriod) < block.timestamp) {
1339             return checkLargeContributionsLock(_address, _value);
1340         }
1341         if (token.balanceOf(_address).sub(lockedAmount[_address]) >= _value) {
1342             return checkLargeContributionsLock(_address, _value);
1343         }
1344 
1345         return false;
1346     }
1347 
1348     function checkLargeContributionsLock(address _address, uint256 _value) public view returns (bool) {
1349         if (ico.endTime().add(contributionLockPeriod) < block.timestamp) {
1350             return true;
1351         }
1352         if (token.balanceOf(_address).sub(lockedContributions[_address]) >= _value) {
1353             return true;
1354         }
1355 
1356         return false;
1357     }
1358 
1359 }
1360 
1361 /**
1362  * @title TokenVesting
1363  * @dev A token holder contract that can release its token balance gradually like a
1364  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
1365  * owner.
1366  */
1367 contract TokenVesting is Ownable {
1368   using SafeMath for uint256;
1369   using SafeERC20 for ERC20Basic;
1370 
1371   event Released(uint256 amount);
1372   event Revoked();
1373 
1374   // beneficiary of tokens after they are released
1375   address public beneficiary;
1376 
1377   uint256 public cliff;
1378   uint256 public start;
1379   uint256 public duration;
1380 
1381   bool public revocable;
1382 
1383   mapping (address => uint256) public released;
1384   mapping (address => bool) public revoked;
1385 
1386   /**
1387    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
1388    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
1389    * of the balance will have vested.
1390    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
1391    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
1392    * @param _duration duration in seconds of the period in which the tokens will vest
1393    * @param _revocable whether the vesting is revocable or not
1394    */
1395   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
1396     require(_beneficiary != address(0));
1397     require(_cliff <= _duration);
1398 
1399     beneficiary = _beneficiary;
1400     revocable = _revocable;
1401     duration = _duration;
1402     cliff = _start.add(_cliff);
1403     start = _start;
1404   }
1405 
1406   /**
1407    * @notice Transfers vested tokens to beneficiary.
1408    * @param token ERC20 token which is being vested
1409    */
1410   function release(ERC20Basic token) public {
1411     uint256 unreleased = releasableAmount(token);
1412 
1413     require(unreleased > 0);
1414 
1415     released[token] = released[token].add(unreleased);
1416 
1417     token.safeTransfer(beneficiary, unreleased);
1418 
1419     Released(unreleased);
1420   }
1421 
1422   /**
1423    * @notice Allows the owner to revoke the vesting. Tokens already vested
1424    * remain in the contract, the rest are returned to the owner.
1425    * @param token ERC20 token which is being vested
1426    */
1427   function revoke(ERC20Basic token) public onlyOwner {
1428     require(revocable);
1429     require(!revoked[token]);
1430 
1431     uint256 balance = token.balanceOf(this);
1432 
1433     uint256 unreleased = releasableAmount(token);
1434     uint256 refund = balance.sub(unreleased);
1435 
1436     revoked[token] = true;
1437 
1438     token.safeTransfer(owner, refund);
1439 
1440     Revoked();
1441   }
1442 
1443   /**
1444    * @dev Calculates the amount that has already vested but hasn't been released yet.
1445    * @param token ERC20 token which is being vested
1446    */
1447   function releasableAmount(ERC20Basic token) public view returns (uint256) {
1448     return vestedAmount(token).sub(released[token]);
1449   }
1450 
1451   /**
1452    * @dev Calculates the amount that has already vested.
1453    * @param token ERC20 token which is being vested
1454    */
1455   function vestedAmount(ERC20Basic token) public view returns (uint256) {
1456     uint256 currentBalance = token.balanceOf(this);
1457     uint256 totalBalance = currentBalance.add(released[token]);
1458 
1459     if (now < cliff) {
1460       return 0;
1461     } else if (now >= start.add(duration) || revoked[token]) {
1462       return totalBalance;
1463     } else {
1464       return totalBalance.mul(now.sub(start)).div(duration);
1465     }
1466   }
1467 }
1468 
1469 contract PeriodicTokenVesting is TokenVesting {
1470     uint256 public periods;
1471 
1472     function PeriodicTokenVesting(
1473         address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, uint256 _periods, bool _revocable
1474     )
1475     public TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable)
1476     {
1477         periods = _periods;
1478     }
1479 
1480     /**
1481     * @dev Calculates the amount that has already vested.
1482     * @param token ERC20 token which is being vested
1483     */
1484     function vestedAmount(ERC20Basic token) public view returns (uint256) {
1485         uint256 currentBalance = token.balanceOf(this);
1486         uint256 totalBalance = currentBalance.add(released[token]);
1487 
1488         if (now < cliff) {
1489             return 0;
1490         } else if (now >= start.add(duration * periods) || revoked[token]) {
1491             return totalBalance;
1492         } else {
1493 
1494             uint256 periodTokens = totalBalance.div(periods);
1495 
1496             uint256 periodsOver = now.sub(start).div(duration) + 1;
1497 
1498             if (periodsOver >= periods) {
1499                 return totalBalance;
1500             }
1501 
1502             return periodTokens.mul(periodsOver);
1503         }
1504     }
1505 }
1506 
1507 contract ElyAllocation is Ownable {
1508 
1509     using SafeERC20 for ERC20Basic;
1510     using SafeMath for uint256;
1511 
1512     uint256 public icoEndTime;
1513 
1514     address[] public vestings;
1515 
1516     event VestingCreated(
1517         address _vesting,
1518         address _beneficiary,
1519         uint256 _start,
1520         uint256 _cliff,
1521         uint256 _duration,
1522         uint256 _periods,
1523         bool _revocable
1524     );
1525 
1526     event VestingRevoked(address _vesting);
1527 
1528     function setICOEndTime(uint256 _icoEndTime) public onlyOwner {
1529         icoEndTime = _icoEndTime;
1530     }
1531 
1532     function vestingMint(PeriodicTokenVesting _vesting, MintingERC20 _token, uint256 _amount) public onlyOwner {
1533         require(_amount > 0 && _token.mint(address(_vesting), _amount) == _amount);
1534     }
1535 
1536     function createVesting(
1537         address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, uint256 _periods, bool _revocable
1538     ) public onlyOwner returns (PeriodicTokenVesting) {
1539         PeriodicTokenVesting vesting = new PeriodicTokenVesting(
1540             _beneficiary, _start, _cliff, _duration, _periods, _revocable
1541         );
1542 
1543         vestings.push(vesting);
1544 
1545         VestingCreated(vesting, _beneficiary, _start, _cliff, _duration, _periods, _revocable);
1546 
1547         return vesting;
1548     }
1549 
1550     function revokeVesting(PeriodicTokenVesting _vesting, MintingERC20 token) public onlyOwner() {
1551         _vesting.revoke(token);
1552 
1553         VestingRevoked(_vesting);
1554     }
1555 }