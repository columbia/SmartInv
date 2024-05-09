1 pragma solidity ^0.4.24;
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
44 contract Whitelist is Ownable {
45     mapping(address => bool) whitelist;
46     event AddedToWhitelist(address indexed account);
47     event RemovedFromWhitelist(address indexed account);
48 
49     modifier onlyWhitelisted() {
50         require(isWhitelisted(msg.sender));
51         _;
52     }
53 
54     function add(address _address) public onlyOwner {
55         whitelist[_address] = true;
56         emit AddedToWhitelist(_address);
57     }
58 
59     function remove(address _address) public onlyOwner {
60         whitelist[_address] = false;
61         emit RemovedFromWhitelist(_address);
62     }
63 
64     function isWhitelisted(address _address) public view returns(bool) {
65         return whitelist[_address];
66     }
67 }
68 
69 
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/179
74  */
75 contract ERC20Basic {
76   function totalSupply() public view returns (uint256);
77   function balanceOf(address who) public view returns (uint256);
78   function transfer(address to, uint256 value) public returns (bool);
79   event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93     if (a == 0) {
94       return 0;
95     }
96     uint256 c = a * b;
97     assert(c / a == b);
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers, truncating the quotient.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   /**
112   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   /**
120   * @dev Adds two numbers, throws on overflow.
121   */
122   function add(uint256 a, uint256 b) internal pure returns (uint256) {
123     uint256 c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 }
128 
129 
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139 
140   uint256 totalSupply_;
141 
142   /**
143   * @dev total number of tokens in existence
144   */
145   function totalSupply() public view returns (uint256) {
146     return totalSupply_;
147   }
148 
149   /**
150   * @dev transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[msg.sender]);
157 
158     // SafeMath.sub will throw if there is not enough balance.
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256 balance) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 
177 
178 
179 
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address owner, address spender) public view returns (uint256);
187   function transferFrom(address from, address to, uint256 value) public returns (bool);
188   function approve(address spender, uint256 value) public returns (bool);
189   event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 
193 
194 /**
195  * @title Standard ERC20 token
196  *
197  * @dev Implementation of the basic standard token.
198  * @dev https://github.com/ethereum/EIPs/issues/20
199  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
200  */
201 contract StandardToken is ERC20, BasicToken {
202 
203   mapping (address => mapping (address => uint256)) internal allowed;
204 
205 
206   /**
207    * @dev Transfer tokens from one address to another
208    * @param _from address The address which you want to send tokens from
209    * @param _to address The address which you want to transfer to
210    * @param _value uint256 the amount of tokens to be transferred
211    */
212   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
213     require(_to != address(0));
214     require(_value <= balances[_from]);
215     require(_value <= allowed[_from][msg.sender]);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(address _owner, address _spender) public view returns (uint256) {
247     return allowed[_owner][_spender];
248   }
249 
250   /**
251    * @dev Increase the amount of tokens that an owner allowed to a spender.
252    *
253    * approve should be called when allowed[_spender] == 0. To increment
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _addedValue The amount of tokens to increase the allowance by.
259    */
260   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
261     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
262     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266   /**
267    * @dev Decrease the amount of tokens that an owner allowed to a spender.
268    *
269    * approve should be called when allowed[_spender] == 0. To decrement
270    * allowed value is better to use this function to avoid 2 calls (and wait until
271    * the first transaction is mined)
272    * From MonolithDAO Token.sol
273    * @param _spender The address which will spend the funds.
274    * @param _subtractedValue The amount of tokens to decrease the allowance by.
275    */
276   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
277     uint oldValue = allowed[msg.sender][_spender];
278     if (_subtractedValue > oldValue) {
279       allowed[msg.sender][_spender] = 0;
280     } else {
281       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
282     }
283     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287 }
288 
289 
290 
291 
292 
293 /**
294  * @title Mintable token
295  * @dev Simple ERC20 Token example, with mintable token creation
296  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
297  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
298  */
299 contract MintableToken is StandardToken, Ownable {
300   event Mint(address indexed to, uint256 amount);
301   event MintFinished();
302 
303   bool public mintingFinished = false;
304 
305 
306   modifier canMint() {
307     require(!mintingFinished);
308     _;
309   }
310 
311   /**
312    * @dev Function to mint tokens
313    * @param _to The address that will receive the minted tokens.
314    * @param _amount The amount of tokens to mint.
315    * @return A boolean that indicates if the operation was successful.
316    */
317   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
318     totalSupply_ = totalSupply_.add(_amount);
319     balances[_to] = balances[_to].add(_amount);
320     Mint(_to, _amount);
321     Transfer(address(0), _to, _amount);
322     return true;
323   }
324 
325   /**
326    * @dev Function to stop minting new tokens.
327    * @return True if the operation was successful.
328    */
329   function finishMinting() onlyOwner canMint public returns (bool) {
330     mintingFinished = true;
331     MintFinished();
332     return true;
333   }
334 }
335 
336 
337 contract CrowdfundableToken is MintableToken {
338     string public name;
339     string public symbol;
340     uint8 public decimals;
341     uint256 public cap;
342 
343     function CrowdfundableToken(uint256 _cap, string _name, string _symbol, uint8 _decimals) public {
344         require(_cap > 0);
345         require(bytes(_name).length > 0);
346         require(bytes(_symbol).length > 0);
347         cap = _cap;
348         name = _name;
349         symbol = _symbol;
350         decimals = _decimals;
351     }
352 
353     // override
354     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
355         require(totalSupply_.add(_amount) <= cap);
356         return super.mint(_to, _amount);
357     }
358 
359     // override
360     function transfer(address _to, uint256 _value) public returns (bool) {
361         require(mintingFinished == true);
362         return super.transfer(_to, _value);
363     }
364 
365     // override
366     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
367         require(mintingFinished == true);
368         return super.transferFrom(_from, _to, _value);
369     }
370 
371     function burn(uint amount) public {
372         totalSupply_ = totalSupply_.sub(amount);
373         balances[msg.sender] = balances[msg.sender].sub(amount);
374     }
375 }
376 
377 contract Minter is Ownable {
378     using SafeMath for uint;
379 
380     /* --- EVENTS --- */
381 
382     event Minted(address indexed account, uint etherAmount, uint tokenAmount);
383     event Reserved(uint etherAmount);
384     event MintedReserved(address indexed account, uint etherAmount, uint tokenAmount);
385     event Unreserved(uint etherAmount);
386 
387     /* --- FIELDS --- */
388 
389     CrowdfundableToken public token;
390     uint public saleEtherCap;
391     uint public confirmedSaleEther;
392     uint public reservedSaleEther;
393 
394     /* --- MODIFIERS --- */
395 
396     modifier onlyInUpdatedState() {
397         updateState();
398         _;
399     }
400 
401     modifier upToSaleEtherCap(uint additionalEtherAmount) {
402         uint totalEtherAmount = confirmedSaleEther.add(reservedSaleEther).add(additionalEtherAmount);
403         require(totalEtherAmount <= saleEtherCap);
404         _;
405     }
406 
407     modifier onlyApprovedMinter() {
408         require(canMint(msg.sender));
409         _;
410     }
411 
412     modifier atLeastMinimumAmount(uint etherAmount) {
413         require(etherAmount >= getMinimumContribution());
414         _;
415     }
416 
417     modifier onlyValidAddress(address account) {
418         require(account != 0x0);
419         _;
420     }
421 
422     /* --- CONSTRUCTOR --- */
423 
424     constructor(CrowdfundableToken _token, uint _saleEtherCap) public onlyValidAddress(address(_token)) {
425         require(_saleEtherCap > 0);
426 
427         token = _token;
428         saleEtherCap = _saleEtherCap;
429     }
430 
431     /* --- PUBLIC / EXTERNAL METHODS --- */
432 
433     function transferTokenOwnership() external onlyOwner {
434         token.transferOwnership(owner);
435     }
436 
437     function reserve(uint etherAmount) external
438         onlyInUpdatedState
439         onlyApprovedMinter
440         upToSaleEtherCap(etherAmount)
441         atLeastMinimumAmount(etherAmount)
442     {
443         reservedSaleEther = reservedSaleEther.add(etherAmount);
444         updateState();
445         emit Reserved(etherAmount);
446     }
447 
448     function mintReserved(address account, uint etherAmount, uint tokenAmount) external
449         onlyInUpdatedState
450         onlyApprovedMinter
451     {
452         reservedSaleEther = reservedSaleEther.sub(etherAmount);
453         confirmedSaleEther = confirmedSaleEther.add(etherAmount);
454         require(token.mint(account, tokenAmount));
455         updateState();
456         emit MintedReserved(account, etherAmount, tokenAmount);
457     }
458 
459     function unreserve(uint etherAmount) public
460         onlyInUpdatedState
461         onlyApprovedMinter
462     {
463         reservedSaleEther = reservedSaleEther.sub(etherAmount);
464         updateState();
465         emit Unreserved(etherAmount);
466     }
467 
468     function mint(address account, uint etherAmount, uint tokenAmount) public
469         onlyInUpdatedState
470         onlyApprovedMinter
471         upToSaleEtherCap(etherAmount)
472     {
473         confirmedSaleEther = confirmedSaleEther.add(etherAmount);
474         require(token.mint(account, tokenAmount));
475         updateState();
476         emit Minted(account, etherAmount, tokenAmount);
477     }
478 
479     // abstract
480     function getMinimumContribution() public view returns(uint);
481 
482     // abstract
483     function updateState() public;
484 
485     // abstract
486     function canMint(address sender) public view returns(bool);
487 
488     // abstract
489     function getTokensForEther(uint etherAmount) public view returns(uint);
490 }
491 
492 contract ExternalMinter {
493     Minter public minter;
494 }
495 
496 contract Tge is Minter {
497     using SafeMath for uint;
498 
499     /* --- CONSTANTS --- */
500 
501     uint constant public MIMIMUM_CONTRIBUTION_AMOUNT_PREICO = 3 ether;
502     uint constant public MIMIMUM_CONTRIBUTION_AMOUNT_ICO = 1 ether / 5;
503     
504     uint constant public PRICE_MULTIPLIER_PREICO1 = 1443000;
505     uint constant public PRICE_MULTIPLIER_PREICO2 = 1415000;
506 
507     uint constant public PRICE_MULTIPLIER_ICO1 = 1332000;
508     uint constant public PRICE_MULTIPLIER_ICO2 = 1304000;
509     uint constant public PRICE_MULTIPLIER_ICO3 = 1248000;
510     uint constant public PRICE_MULTIPLIER_ICO4 = 1221000;
511     uint constant public PRICE_MULTIPLIER_ICO5 = 1165000;
512     uint constant public PRICE_MULTIPLIER_ICO6 = 1110000;
513     uint constant public PRICE_DIVIDER = 1000;
514 
515     /* --- EVENTS --- */
516 
517     event StateChanged(uint from, uint to);
518     event PrivateIcoInitialized(uint _cap, uint _tokensForEther, uint _startTime, uint _endTime, uint _minimumContribution);
519     event PrivateIcoFinalized();
520 
521     /* --- FIELDS --- */
522 
523     // minters
524     address public crowdsale;
525     address public deferredKyc;
526     address public referralManager;
527     address public allocator;
528     address public airdropper;
529 
530     // state
531     enum State {Presale, Preico1, Preico2, Break, Ico1, Ico2, Ico3, Ico4, Ico5, Ico6, FinishingIco, Allocating, Airdropping, Finished}
532     State public currentState = State.Presale;
533     mapping(uint => uint) public startTimes;
534     mapping(uint => uint) public etherCaps;
535 
536     // private ico
537     bool public privateIcoFinalized = true;
538     uint public privateIcoCap = 0;
539     uint public privateIcoTokensForEther = 0;
540     uint public privateIcoStartTime = 0;
541     uint public privateIcoEndTime = 0;
542     uint public privateIcoMinimumContribution = 0;
543 
544     /* --- MODIFIERS --- */
545 
546     modifier onlyInState(State _state) {
547         require(_state == currentState);
548         _;
549     }
550 
551     modifier onlyProperExternalMinters(address minter1, address minter2, address minter3, address minter4, address minter5) {
552         require(ExternalMinter(minter1).minter() == address(this));
553         require(ExternalMinter(minter2).minter() == address(this));
554         require(ExternalMinter(minter3).minter() == address(this));
555         require(ExternalMinter(minter4).minter() == address(this));
556         require(ExternalMinter(minter5).minter() == address(this));
557         _;
558     }
559 
560     /* --- CONSTRUCTOR / INITIALIZATION --- */
561 
562     constructor(
563         CrowdfundableToken _token,
564         uint _saleEtherCap
565     ) public Minter(_token, _saleEtherCap) {
566         require(keccak256(_token.symbol()) == keccak256("ALL"));
567     }
568 
569     // initialize states start times and caps
570     function setupStates(uint saleStart, uint singleStateEtherCap, uint[] stateLengths) internal {
571         require(!isPrivateIcoActive());
572 
573         startTimes[uint(State.Preico1)] = saleStart;
574         setStateLength(State.Preico1, stateLengths[0]);
575         setStateLength(State.Preico2, stateLengths[1]);
576         setStateLength(State.Break, stateLengths[2]);
577         setStateLength(State.Ico1, stateLengths[3]);
578         setStateLength(State.Ico2, stateLengths[4]);
579         setStateLength(State.Ico3, stateLengths[5]);
580         setStateLength(State.Ico4, stateLengths[6]);
581         setStateLength(State.Ico5, stateLengths[7]);
582         setStateLength(State.Ico6, stateLengths[8]);
583 
584         // the total sale ether cap is distributed evenly over all selling states
585         // the cap from previous states is accumulated in consequent states
586         // adding confirmed sale ether from private ico
587         etherCaps[uint(State.Preico1)] = singleStateEtherCap;
588         etherCaps[uint(State.Preico2)] = singleStateEtherCap.mul(2);
589         etherCaps[uint(State.Ico1)] = singleStateEtherCap.mul(3);
590         etherCaps[uint(State.Ico2)] = singleStateEtherCap.mul(4);
591         etherCaps[uint(State.Ico3)] = singleStateEtherCap.mul(5);
592         etherCaps[uint(State.Ico4)] = singleStateEtherCap.mul(6);
593         etherCaps[uint(State.Ico5)] = singleStateEtherCap.mul(7);
594         etherCaps[uint(State.Ico6)] = singleStateEtherCap.mul(8);
595     }
596 
597     function setup(
598         address _crowdsale,
599         address _deferredKyc,
600         address _referralManager,
601         address _allocator,
602         address _airdropper,
603         uint saleStartTime,
604         uint singleStateEtherCap,
605         uint[] stateLengths
606     )
607     public
608     onlyOwner
609     onlyInState(State.Presale)
610     onlyProperExternalMinters(_crowdsale, _deferredKyc, _referralManager, _allocator, _airdropper)
611     {
612         require(stateLengths.length == 9); // preico 1-2, break, ico 1-6
613         require(saleStartTime >= now);
614         require(singleStateEtherCap > 0);
615         require(singleStateEtherCap.mul(8) <= saleEtherCap);
616         crowdsale = _crowdsale;
617         deferredKyc = _deferredKyc;
618         referralManager = _referralManager;
619         allocator = _allocator;
620         airdropper = _airdropper;
621         setupStates(saleStartTime, singleStateEtherCap, stateLengths);
622     }
623 
624     /* --- PUBLIC / EXTERNAL METHODS --- */
625 
626     function moveState(uint from, uint to) external onlyInUpdatedState onlyOwner {
627         require(uint(currentState) == from);
628         advanceStateIfNewer(State(to));
629     }
630 
631     // override
632     function transferTokenOwnership() external onlyInUpdatedState onlyOwner {
633         require(currentState == State.Finished);
634         token.transferOwnership(owner);
635     }
636 
637     // override
638     function getTokensForEther(uint etherAmount) public view returns(uint) {
639         uint tokenAmount = 0;
640         if (isPrivateIcoActive()) tokenAmount = etherAmount.mul(privateIcoTokensForEther).div(PRICE_DIVIDER);
641         else if (currentState == State.Preico1) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_PREICO1).div(PRICE_DIVIDER);
642         else if (currentState == State.Preico2) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_PREICO2).div(PRICE_DIVIDER);
643         else if (currentState == State.Ico1) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO1).div(PRICE_DIVIDER);
644         else if (currentState == State.Ico2) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO2).div(PRICE_DIVIDER);
645         else if (currentState == State.Ico3) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO3).div(PRICE_DIVIDER);
646         else if (currentState == State.Ico4) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO4).div(PRICE_DIVIDER);
647         else if (currentState == State.Ico5) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO5).div(PRICE_DIVIDER);
648         else if (currentState == State.Ico6) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO6).div(PRICE_DIVIDER);
649 
650         return tokenAmount;
651     }
652 
653     function isSellingState() public view returns(bool) {
654         if (currentState == State.Presale) return isPrivateIcoActive();
655         return (
656             uint(currentState) >= uint(State.Preico1) &&
657             uint(currentState) <= uint(State.Ico6) &&
658             uint(currentState) != uint(State.Break)
659         );
660     }
661 
662     function isPrivateIcoActive() public view returns(bool) {
663         return now >= privateIcoStartTime && now < privateIcoEndTime;
664     }
665 
666     function initPrivateIco(uint _cap, uint _tokensForEther, uint _startTime, uint _endTime, uint _minimumContribution) external onlyOwner {
667         require(_startTime > privateIcoEndTime); // should start after previous private ico
668         require(now >= privateIcoEndTime); // previous private ico should be finished
669         require(privateIcoFinalized); // previous private ico should be finalized
670         require(_tokensForEther > 0);
671         require(_endTime > _startTime);
672         require(_endTime < startTimes[uint(State.Preico1)]);
673 
674         privateIcoCap = _cap;
675         privateIcoTokensForEther = _tokensForEther;
676         privateIcoStartTime = _startTime;
677         privateIcoEndTime = _endTime;
678         privateIcoMinimumContribution = _minimumContribution;
679         privateIcoFinalized = false;
680         emit PrivateIcoInitialized(_cap, _tokensForEther, _startTime, _endTime, _minimumContribution);
681     }
682 
683     function finalizePrivateIco() external onlyOwner {
684         require(!isPrivateIcoActive());
685         require(now >= privateIcoEndTime); // previous private ico should be finished
686         require(!privateIcoFinalized);
687         require(reservedSaleEther == 0); // kyc needs to be finished
688 
689         privateIcoFinalized = true;
690         confirmedSaleEther = 0;
691         emit PrivateIcoFinalized();
692     }
693 
694     /* --- INTERNAL METHODS --- */
695 
696     // override
697     function getMinimumContribution() public view returns(uint) {
698         if (currentState == State.Preico1 || currentState == State.Preico2) {
699             return MIMIMUM_CONTRIBUTION_AMOUNT_PREICO;
700         }
701         if (uint(currentState) >= uint(State.Ico1) && uint(currentState) <= uint(State.Ico6)) {
702             return MIMIMUM_CONTRIBUTION_AMOUNT_ICO;
703         }
704         if (isPrivateIcoActive()) {
705             return privateIcoMinimumContribution;
706         }
707         return 0;
708     }
709 
710     // override
711     function canMint(address account) public view returns(bool) {
712         if (currentState == State.Presale) {
713             // external sales and private ico
714             return account == crowdsale || account == deferredKyc;
715         }
716         else if (isSellingState()) {
717             // crowdsale: external sales
718             // deferredKyc: adding and approving kyc
719             // referralManager: referral fees
720             return account == crowdsale || account == deferredKyc || account == referralManager;
721         }
722         else if (currentState == State.Break || currentState == State.FinishingIco) {
723             // crowdsale: external sales
724             // deferredKyc: approving kyc
725             // referralManager: referral fees
726             return account == crowdsale || account == deferredKyc || account == referralManager;
727         }
728         else if (currentState == State.Allocating) {
729             // Community and Bounty allocations
730             // Advisors, Developers, Ambassadors and Partners allocations
731             // Customer Rewards allocations
732             // Team allocations
733             return account == allocator;
734         }
735         else if (currentState == State.Airdropping) {
736             // airdropping for all token holders
737             return account == airdropper;
738         }
739         return false;
740     }
741 
742     // override
743     function updateState() public {
744         updateStateBasedOnTime();
745         updateStateBasedOnContributions();
746     }
747 
748     function updateStateBasedOnTime() internal {
749         // move to the next state, if the current one has finished
750         if (now >= startTimes[uint(State.FinishingIco)]) advanceStateIfNewer(State.FinishingIco);
751         else if (now >= startTimes[uint(State.Ico6)]) advanceStateIfNewer(State.Ico6);
752         else if (now >= startTimes[uint(State.Ico5)]) advanceStateIfNewer(State.Ico5);
753         else if (now >= startTimes[uint(State.Ico4)]) advanceStateIfNewer(State.Ico4);
754         else if (now >= startTimes[uint(State.Ico3)]) advanceStateIfNewer(State.Ico3);
755         else if (now >= startTimes[uint(State.Ico2)]) advanceStateIfNewer(State.Ico2);
756         else if (now >= startTimes[uint(State.Ico1)]) advanceStateIfNewer(State.Ico1);
757         else if (now >= startTimes[uint(State.Break)]) advanceStateIfNewer(State.Break);
758         else if (now >= startTimes[uint(State.Preico2)]) advanceStateIfNewer(State.Preico2);
759         else if (now >= startTimes[uint(State.Preico1)]) advanceStateIfNewer(State.Preico1);
760     }
761 
762     function updateStateBasedOnContributions() internal {
763         // move to the next state, if the current one's cap has been reached
764         uint totalEtherContributions = confirmedSaleEther.add(reservedSaleEther);
765         if(isPrivateIcoActive()) {
766             // if private ico cap exceeded, revert transaction
767             require(totalEtherContributions <= privateIcoCap);
768             return;
769         }
770         
771         if (!isSellingState()) {
772             return;
773         }
774         
775         else if (int(currentState) < int(State.Break)) {
776             // preico
777             if (totalEtherContributions >= etherCaps[uint(State.Preico2)]) advanceStateIfNewer(State.Break);
778             else if (totalEtherContributions >= etherCaps[uint(State.Preico1)]) advanceStateIfNewer(State.Preico2);
779         }
780         else {
781             // ico
782             if (totalEtherContributions >= etherCaps[uint(State.Ico6)]) advanceStateIfNewer(State.FinishingIco);
783             else if (totalEtherContributions >= etherCaps[uint(State.Ico5)]) advanceStateIfNewer(State.Ico6);
784             else if (totalEtherContributions >= etherCaps[uint(State.Ico4)]) advanceStateIfNewer(State.Ico5);
785             else if (totalEtherContributions >= etherCaps[uint(State.Ico3)]) advanceStateIfNewer(State.Ico4);
786             else if (totalEtherContributions >= etherCaps[uint(State.Ico2)]) advanceStateIfNewer(State.Ico3);
787             else if (totalEtherContributions >= etherCaps[uint(State.Ico1)]) advanceStateIfNewer(State.Ico2);
788         }
789     }
790 
791     function advanceStateIfNewer(State newState) internal {
792         if (uint(newState) > uint(currentState)) {
793             emit StateChanged(uint(currentState), uint(newState));
794             currentState = newState;
795         }
796     }
797 
798     function setStateLength(State state, uint length) internal {
799         // state length is determined by next state's start time
800         startTimes[uint(state)+1] = startTimes[uint(state)].add(length);
801     }
802 
803     function isInitialized() public view returns(bool) {
804         return crowdsale != 0x0 && referralManager != 0x0 && allocator != 0x0 && airdropper != 0x0 && deferredKyc != 0x0;
805     }
806 }