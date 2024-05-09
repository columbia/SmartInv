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
454         token.mint(account, tokenAmount);
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
474         token.mint(account, tokenAmount);
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
492 contract Tge is Minter {
493     using SafeMath for uint;
494 
495     /* --- CONSTANTS --- */
496 
497     uint constant public MIMIMUM_CONTRIBUTION_AMOUNT_PREICO = 1 ether;
498     uint constant public MIMIMUM_CONTRIBUTION_AMOUNT_ICO = 1 ether / 5;
499     
500     uint constant public PRICE_MULTIPLIER_PREICO1 = 2600500;
501     uint constant public PRICE_MULTIPLIER_PREICO2 = 2510800;
502 
503     uint constant public PRICE_MULTIPLIER_ICO1 = 2275400;
504     uint constant public PRICE_MULTIPLIER_ICO2 = 2206400;
505     uint constant public PRICE_MULTIPLIER_ICO3 = 2080300;
506     uint constant public PRICE_MULTIPLIER_ICO4 = 2022500;
507     uint constant public PRICE_MULTIPLIER_ICO5 = 1916000;
508     uint constant public PRICE_MULTIPLIER_ICO6 = 1820200;
509     uint constant public PRICE_DIVIDER = 1000;
510 
511     /* --- EVENTS --- */
512 
513     event StateChanged(uint from, uint to);
514     event PrivateIcoInitialized(uint _cap, uint _tokensForEther, uint _startTime, uint _endTime, uint _minimumContribution);
515     event PrivateIcoFinalized();
516 
517     /* --- FIELDS --- */
518 
519     // minters
520     address public crowdsale;
521     address public deferredKyc;
522     address public referralManager;
523     address public allocator;
524     address public airdropper;
525 
526     // state
527     enum State {Presale, Preico1, Preico2, Break, Ico1, Ico2, Ico3, Ico4, Ico5, Ico6, FinishingIco, Allocating, Airdropping, Finished}
528     State public currentState = State.Presale;
529     mapping(uint => uint) public startTimes;
530     mapping(uint => uint) public etherCaps;
531 
532     // private ico
533     bool public privateIcoFinalized = true;
534     uint public privateIcoCap = 0;
535     uint public privateIcoTokensForEther = 0;
536     uint public privateIcoStartTime = 0;
537     uint public privateIcoEndTime = 0;
538     uint public privateIcoMinimumContribution = 0;
539 
540     /* --- MODIFIERS --- */
541 
542     modifier onlyInState(State _state) {
543         require(_state == currentState);
544         _;
545     }
546 
547     modifier onlyValidAddress(address account) {
548         require(account != 0x0);
549         _;
550     }
551 
552     /* --- CONSTRUCTOR / INITIALIZATION --- */
553 
554     constructor(
555         CrowdfundableToken _token,
556         uint _saleEtherCap
557     ) public Minter(_token, _saleEtherCap) { }
558 
559     // initialize states start times and caps
560     function setupStates(uint saleStart, uint singleStateEtherCap, uint[] stateLengths) internal {
561         require(!isPrivateIcoActive());
562 
563         startTimes[uint(State.Preico1)] = saleStart;
564         setStateLength(State.Preico1, stateLengths[0]);
565         setStateLength(State.Preico2, stateLengths[1]);
566         setStateLength(State.Break, stateLengths[2]);
567         setStateLength(State.Ico1, stateLengths[3]);
568         setStateLength(State.Ico2, stateLengths[4]);
569         setStateLength(State.Ico3, stateLengths[5]);
570         setStateLength(State.Ico4, stateLengths[6]);
571         setStateLength(State.Ico5, stateLengths[7]);
572         setStateLength(State.Ico6, stateLengths[8]);
573 
574         // the total sale ether cap is distributed evenly over all selling states
575         // the cap from previous states is accumulated in consequent states
576         // adding confirmed sale ether from private ico
577         etherCaps[uint(State.Preico1)] = singleStateEtherCap;
578         etherCaps[uint(State.Preico2)] = singleStateEtherCap.mul(2);
579         etherCaps[uint(State.Ico1)] = singleStateEtherCap.mul(3);
580         etherCaps[uint(State.Ico2)] = singleStateEtherCap.mul(4);
581         etherCaps[uint(State.Ico3)] = singleStateEtherCap.mul(5);
582         etherCaps[uint(State.Ico4)] = singleStateEtherCap.mul(6);
583         etherCaps[uint(State.Ico5)] = singleStateEtherCap.mul(7);
584         etherCaps[uint(State.Ico6)] = singleStateEtherCap.mul(8);
585     }
586 
587     function setup(
588         address _crowdsale,
589         address _deferredKyc,
590         address _referralManager,
591         address _allocator,
592         address _airdropper,
593         uint saleStartTime,
594         uint singleStateEtherCap,
595         uint[] stateLengths
596     )
597     public
598     onlyOwner
599     onlyInState(State.Presale)
600     onlyValidAddress(_crowdsale)
601     onlyValidAddress(_deferredKyc)
602     onlyValidAddress(_referralManager)
603     onlyValidAddress(_allocator)
604     onlyValidAddress(_airdropper)
605     {
606         require(stateLengths.length == 9); // preico 1-2, break, ico 1-6
607         require(saleStartTime >= now);
608         require(singleStateEtherCap > 0);
609         crowdsale = _crowdsale;
610         deferredKyc = _deferredKyc;
611         referralManager = _referralManager;
612         allocator = _allocator;
613         airdropper = _airdropper;
614         setupStates(saleStartTime, singleStateEtherCap, stateLengths);
615     }
616 
617     /* --- PUBLIC / EXTERNAL METHODS --- */
618 
619     function moveState(uint from, uint to) external onlyInUpdatedState onlyOwner {
620         require(uint(currentState) == from);
621         advanceStateIfNewer(State(to));
622     }
623 
624     // override
625     function transferTokenOwnership() external onlyInUpdatedState onlyOwner {
626         require(currentState == State.Finished);
627         token.transferOwnership(owner);
628     }
629 
630     // override
631     function getTokensForEther(uint etherAmount) public view returns(uint) {
632         uint tokenAmount = 0;
633         if (isPrivateIcoActive()) tokenAmount = etherAmount.mul(privateIcoTokensForEther).div(PRICE_DIVIDER);
634         else if (currentState == State.Preico1) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_PREICO1).div(PRICE_DIVIDER);
635         else if (currentState == State.Preico2) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_PREICO2).div(PRICE_DIVIDER);
636         else if (currentState == State.Ico1) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO1).div(PRICE_DIVIDER);
637         else if (currentState == State.Ico2) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO2).div(PRICE_DIVIDER);
638         else if (currentState == State.Ico3) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO3).div(PRICE_DIVIDER);
639         else if (currentState == State.Ico4) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO4).div(PRICE_DIVIDER);
640         else if (currentState == State.Ico5) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO5).div(PRICE_DIVIDER);
641         else if (currentState == State.Ico6) tokenAmount = etherAmount.mul(PRICE_MULTIPLIER_ICO6).div(PRICE_DIVIDER);
642 
643         return tokenAmount;
644     }
645 
646     function isSellingState() public view returns(bool) {
647         if (currentState == State.Presale) return isPrivateIcoActive();
648         return (
649             uint(currentState) >= uint(State.Preico1) &&
650             uint(currentState) <= uint(State.Ico6) &&
651             uint(currentState) != uint(State.Break)
652         );
653     }
654 
655     function isPrivateIcoActive() public view returns(bool) {
656         return now >= privateIcoStartTime && now < privateIcoEndTime;
657     }
658 
659     function initPrivateIco(uint _cap, uint _tokensForEther, uint _startTime, uint _endTime, uint _minimumContribution) external onlyOwner {
660         require(_startTime > privateIcoEndTime); // should start after previous private ico
661         require(now >= privateIcoEndTime); // previous private ico should be finished
662         require(privateIcoFinalized); // previous private ico should be finalized
663         require(_tokensForEther > 0);
664         require(_endTime > _startTime);
665         require(_endTime < startTimes[uint(State.Preico1)]);
666 
667         privateIcoCap = _cap;
668         privateIcoTokensForEther = _tokensForEther;
669         privateIcoStartTime = _startTime;
670         privateIcoEndTime = _endTime;
671         privateIcoMinimumContribution = _minimumContribution;
672         privateIcoFinalized = false;
673         emit PrivateIcoInitialized(_cap, _tokensForEther, _startTime, _endTime, _minimumContribution);
674     }
675 
676     function finalizePrivateIco() external onlyOwner {
677         require(!isPrivateIcoActive());
678         require(now >= privateIcoEndTime); // previous private ico should be finished
679         require(!privateIcoFinalized);
680         require(reservedSaleEther == 0); // kyc needs to be finished
681 
682         privateIcoFinalized = true;
683         confirmedSaleEther = 0;
684         emit PrivateIcoFinalized();
685     }
686 
687     /* --- INTERNAL METHODS --- */
688 
689     // override
690     function getMinimumContribution() public view returns(uint) {
691         if (currentState == State.Preico1 || currentState == State.Preico2) {
692             return MIMIMUM_CONTRIBUTION_AMOUNT_PREICO;
693         }
694         if (uint(currentState) >= uint(State.Ico1) && uint(currentState) <= uint(State.Ico6)) {
695             return MIMIMUM_CONTRIBUTION_AMOUNT_ICO;
696         }
697         if (isPrivateIcoActive()) {
698             return privateIcoMinimumContribution;
699         }
700         return 0;
701     }
702 
703     // override
704     function canMint(address account) public view returns(bool) {
705         if (currentState == State.Presale) {
706             // external sales and private ico
707             return account == crowdsale || account == deferredKyc;
708         }
709         else if (isSellingState()) {
710             // crowdsale: external sales
711             // deferredKyc: adding and approving kyc
712             // referralManager: referral fees
713             return account == crowdsale || account == deferredKyc || account == referralManager;
714         }
715         else if (currentState == State.Break || currentState == State.FinishingIco) {
716             // crowdsale: external sales
717             // deferredKyc: approving kyc
718             // referralManager: referral fees
719             return account == crowdsale || account == deferredKyc || account == referralManager;
720         }
721         else if (currentState == State.Allocating) {
722             // Community and Bounty allocations
723             // Advisors, Developers, Ambassadors and Partners allocations
724             // Customer Rewards allocations
725             // Team allocations
726             return account == allocator;
727         }
728         else if (currentState == State.Airdropping) {
729             // airdropping for all token holders
730             return account == airdropper;
731         }
732         return false;
733     }
734 
735     // override
736     function updateState() public {
737         updateStateBasedOnTime();
738         updateStateBasedOnContributions();
739     }
740 
741     function updateStateBasedOnTime() internal {
742         // move to the next state, if the current one has finished
743         if (now >= startTimes[uint(State.FinishingIco)]) advanceStateIfNewer(State.FinishingIco);
744         else if (now >= startTimes[uint(State.Ico6)]) advanceStateIfNewer(State.Ico6);
745         else if (now >= startTimes[uint(State.Ico5)]) advanceStateIfNewer(State.Ico5);
746         else if (now >= startTimes[uint(State.Ico4)]) advanceStateIfNewer(State.Ico4);
747         else if (now >= startTimes[uint(State.Ico3)]) advanceStateIfNewer(State.Ico3);
748         else if (now >= startTimes[uint(State.Ico2)]) advanceStateIfNewer(State.Ico2);
749         else if (now >= startTimes[uint(State.Ico1)]) advanceStateIfNewer(State.Ico1);
750         else if (now >= startTimes[uint(State.Break)]) advanceStateIfNewer(State.Break);
751         else if (now >= startTimes[uint(State.Preico2)]) advanceStateIfNewer(State.Preico2);
752         else if (now >= startTimes[uint(State.Preico1)]) advanceStateIfNewer(State.Preico1);
753     }
754 
755     function updateStateBasedOnContributions() internal {
756         // move to the next state, if the current one's cap has been reached
757         uint totalEtherContributions = confirmedSaleEther.add(reservedSaleEther);
758         if(isPrivateIcoActive()) {
759             // if private ico cap exceeded, revert transaction
760             require(totalEtherContributions <= privateIcoCap);
761             return;
762         }
763         
764         if (!isSellingState()) {
765             return;
766         }
767         
768         else if (int(currentState) < int(State.Break)) {
769             // preico
770             if (totalEtherContributions >= etherCaps[uint(State.Preico2)]) advanceStateIfNewer(State.Break);
771             else if (totalEtherContributions >= etherCaps[uint(State.Preico1)]) advanceStateIfNewer(State.Preico2);
772         }
773         else {
774             // ico
775             if (totalEtherContributions >= etherCaps[uint(State.Ico6)]) advanceStateIfNewer(State.FinishingIco);
776             else if (totalEtherContributions >= etherCaps[uint(State.Ico5)]) advanceStateIfNewer(State.Ico6);
777             else if (totalEtherContributions >= etherCaps[uint(State.Ico4)]) advanceStateIfNewer(State.Ico5);
778             else if (totalEtherContributions >= etherCaps[uint(State.Ico3)]) advanceStateIfNewer(State.Ico4);
779             else if (totalEtherContributions >= etherCaps[uint(State.Ico2)]) advanceStateIfNewer(State.Ico3);
780             else if (totalEtherContributions >= etherCaps[uint(State.Ico1)]) advanceStateIfNewer(State.Ico2);
781         }
782     }
783 
784     function advanceStateIfNewer(State newState) internal {
785         if (uint(newState) > uint(currentState)) {
786             emit StateChanged(uint(currentState), uint(newState));
787             currentState = newState;
788         }
789     }
790 
791     function setStateLength(State state, uint length) internal {
792         // state length is determined by next state's start time
793         startTimes[uint(state)+1] = startTimes[uint(state)].add(length);
794     }
795 
796     function isInitialized() public view returns(bool) {
797         return crowdsale != 0x0 && referralManager != 0x0 && allocator != 0x0 && airdropper != 0x0 && deferredKyc != 0x0;
798     }
799 }
800 
801 
802 contract LockingContract is Ownable {
803     using SafeMath for uint256;
804 
805     event NotedTokens(address indexed _beneficiary, uint256 _tokenAmount);
806     event ReleasedTokens(address indexed _beneficiary);
807     event ReducedLockingTime(uint256 _newUnlockTime);
808 
809     ERC20 public tokenContract;
810     mapping(address => uint256) public tokens;
811     uint256 public totalTokens;
812     uint256 public unlockTime;
813 
814     function isLocked() public view returns(bool) {
815         return now < unlockTime;
816     }
817 
818     modifier onlyWhenUnlocked() {
819         require(!isLocked());
820         _;
821     }
822 
823     modifier onlyWhenLocked() {
824         require(isLocked());
825         _;
826     }
827 
828     function LockingContract(ERC20 _tokenContract, uint256 _unlockTime) public {
829         require(_unlockTime > now);
830         require(address(_tokenContract) != 0x0);
831         unlockTime = _unlockTime;
832         tokenContract = _tokenContract;
833     }
834 
835     function balanceOf(address _owner) public view returns (uint256 balance) {
836         return tokens[_owner];
837     }
838 
839     // Should only be done from another contract.
840     // To ensure that the LockingContract can release all noted tokens later,
841     // one should mint/transfer tokens to the LockingContract's account prior to noting
842     function noteTokens(address _beneficiary, uint256 _tokenAmount) external onlyOwner onlyWhenLocked {
843         uint256 tokenBalance = tokenContract.balanceOf(this);
844         require(tokenBalance >= totalTokens.add(_tokenAmount));
845 
846         tokens[_beneficiary] = tokens[_beneficiary].add(_tokenAmount);
847         totalTokens = totalTokens.add(_tokenAmount);
848         emit NotedTokens(_beneficiary, _tokenAmount);
849     }
850 
851     function releaseTokens(address _beneficiary) public onlyWhenUnlocked {
852         require(msg.sender == owner || msg.sender == _beneficiary);
853         uint256 amount = tokens[_beneficiary];
854         tokens[_beneficiary] = 0;
855         require(tokenContract.transfer(_beneficiary, amount)); 
856         totalTokens = totalTokens.sub(amount);
857         emit ReleasedTokens(_beneficiary);
858     }
859 
860     function reduceLockingTime(uint256 _newUnlockTime) public onlyOwner onlyWhenLocked {
861         require(_newUnlockTime >= now);
862         require(_newUnlockTime < unlockTime);
863         unlockTime = _newUnlockTime;
864         emit ReducedLockingTime(_newUnlockTime);
865     }
866 }
867 
868 
869 contract DeferredKyc is Ownable {
870     using SafeMath for uint;
871 
872     /* --- EVENTS --- */
873 
874     event AddedToKyc(address indexed investor, uint etherAmount, uint tokenAmount);
875     event Approved(address indexed investor, uint etherAmount, uint tokenAmount);
876     event Rejected(address indexed investor, uint etherAmount, uint tokenAmount);
877     event RejectedWithdrawn(address indexed investor, uint etherAmount);
878     event ApproverTransferred(address newApprover);
879     event TreasuryUpdated(address newTreasury);
880 
881     /* --- FIELDS --- */
882 
883     address public treasury;
884     Minter public minter;
885     address public approver;
886     mapping(address => uint) public etherInProgress;
887     mapping(address => uint) public tokenInProgress;
888     mapping(address => uint) public etherRejected;
889 
890     /* --- MODIFIERS --- */ 
891 
892     modifier onlyApprover() {
893         require(msg.sender == approver);
894         _;
895     }
896 
897     modifier onlyValidAddress(address account) {
898         require(account != 0x0);
899         _;
900     }
901 
902     /* --- CONSTRUCTOR --- */
903 
904     constructor(Minter _minter, address _approver, address _treasury)
905         public
906         onlyValidAddress(address(_minter))
907         onlyValidAddress(_approver)
908         onlyValidAddress(_treasury)
909     {
910         minter = _minter;
911         approver = _approver;
912         treasury = _treasury;
913     }
914 
915     /* --- PUBLIC / EXTERNAL METHODS --- */
916 
917     function updateTreasury(address newTreasury) external onlyOwner {
918         treasury = newTreasury;
919         emit TreasuryUpdated(newTreasury);
920     }
921 
922     function addToKyc(address investor) external payable onlyOwner {
923         minter.reserve(msg.value);
924         uint tokenAmount = minter.getTokensForEther(msg.value);
925         require(tokenAmount > 0);
926         emit AddedToKyc(investor, msg.value, tokenAmount);
927 
928         etherInProgress[investor] = etherInProgress[investor].add(msg.value);
929         tokenInProgress[investor] = tokenInProgress[investor].add(tokenAmount);
930     }
931 
932     function approve(address investor) external onlyApprover {
933         minter.mintReserved(investor, etherInProgress[investor], tokenInProgress[investor]);
934         emit Approved(investor, etherInProgress[investor], tokenInProgress[investor]);
935         
936         uint value = etherInProgress[investor];
937         etherInProgress[investor] = 0;
938         tokenInProgress[investor] = 0;
939         treasury.transfer(value);
940     }
941 
942     function reject(address investor) external onlyApprover {
943         minter.unreserve(etherInProgress[investor]);
944         emit Rejected(investor, etherInProgress[investor], tokenInProgress[investor]);
945 
946         etherRejected[investor] = etherRejected[investor].add(etherInProgress[investor]);
947         etherInProgress[investor] = 0;
948         tokenInProgress[investor] = 0;
949     }
950 
951     function withdrawRejected() external {
952         uint value = etherRejected[msg.sender];
953         etherRejected[msg.sender] = 0;
954         (msg.sender).transfer(value);
955         emit RejectedWithdrawn(msg.sender, value);
956     }
957 
958     function forceWithdrawRejected(address investor) external onlyApprover {
959         uint value = etherRejected[investor];
960         etherRejected[investor] = 0;
961         (investor).transfer(value);
962         emit RejectedWithdrawn(investor, value);
963     }
964 
965     function transferApprover(address newApprover) external onlyApprover {
966         approver = newApprover;
967         emit ApproverTransferred(newApprover);
968     }
969 }
970 
971 contract SingleLockingContract is Ownable {
972     using SafeMath for uint256;
973 
974     /* --- EVENTS --- */
975 
976     event ReleasedTokens(address indexed _beneficiary);
977 
978     /* --- FIELDS --- */
979 
980     ERC20 public tokenContract;
981     uint256 public unlockTime;
982     address public beneficiary;
983 
984     /* --- MODIFIERS --- */
985 
986     modifier onlyWhenUnlocked() {
987         require(!isLocked());
988         _;
989     }
990 
991     modifier onlyWhenLocked() {
992         require(isLocked());
993         _;
994     }
995 
996     /* --- CONSTRUCTOR --- */
997 
998     function SingleLockingContract(ERC20 _tokenContract, uint256 _unlockTime, address _beneficiary) public {
999         require(_unlockTime > now);
1000         require(address(_tokenContract) != 0x0);
1001         require(_beneficiary != 0x0);
1002 
1003         unlockTime = _unlockTime;
1004         tokenContract = _tokenContract;
1005         beneficiary = _beneficiary;
1006     }
1007 
1008     /* --- PUBLIC / EXTERNAL METHODS --- */
1009 
1010     function isLocked() public view returns(bool) {
1011         return now < unlockTime;
1012     }
1013 
1014     function balanceOf() public view returns (uint256 balance) {
1015         return tokenContract.balanceOf(address(this));
1016     }
1017 
1018     function releaseTokens() public onlyWhenUnlocked {
1019         require(msg.sender == owner || msg.sender == beneficiary);
1020         require(tokenContract.transfer(beneficiary, balanceOf())); 
1021         emit ReleasedTokens(beneficiary);
1022     }
1023 }
1024 
1025 contract Crowdsale is Ownable {
1026     using SafeMath for uint;
1027 
1028     /* --- EVENTS --- */
1029 
1030     event Bought(address indexed account, uint etherAmount);
1031     event SaleNoted(address indexed account, uint etherAmount, uint tokenAmount);
1032     event SaleLockedNoted(address indexed account, uint etherAmount, uint tokenAmount, uint lockingPeriod, address lockingContract);
1033 
1034     /* --- FIELDS --- */
1035 
1036     Minter public minter;
1037     DeferredKyc public deferredKyc;
1038 
1039     /* --- MODIFIERS --- */
1040 
1041     modifier onlyValidAddress(address account) {
1042         require(account != 0x0);
1043         _;
1044     }
1045 
1046     /* --- CONSTRUCTOR --- */
1047 
1048     function updateTreasury(address newTreasury) external onlyOwner onlyValidAddress(newTreasury) {
1049         deferredKyc.updateTreasury(newTreasury);
1050     }
1051 
1052     constructor(Minter _minter, address _approver, address _treasury)
1053         public
1054         onlyValidAddress(address(_minter))
1055         onlyValidAddress(_approver)
1056         onlyValidAddress(_treasury)
1057     {
1058         minter = _minter;
1059         deferredKyc = new DeferredKyc(_minter, _approver, _treasury);
1060     }
1061 
1062     /* --- PUBLIC / EXTERNAL METHODS --- */
1063     
1064     function buy() public payable {
1065         deferredKyc.addToKyc.value(msg.value)(msg.sender);
1066         emit Bought(msg.sender, msg.value);
1067     }
1068 
1069     function noteSale(address account, uint etherAmount, uint tokenAmount) public onlyOwner {
1070         minter.mint(account, etherAmount, tokenAmount);
1071         emit SaleNoted(account, etherAmount, tokenAmount);
1072     }
1073 
1074     function noteSaleLocked(address account, uint etherAmount, uint tokenAmount, uint lockingPeriod) public onlyOwner {
1075         SingleLockingContract lockingContract = new SingleLockingContract(ERC20(minter.token()), now.add(lockingPeriod), account);
1076         minter.mint(address(lockingContract), etherAmount, tokenAmount);
1077         emit SaleLockedNoted(account, etherAmount, tokenAmount, lockingPeriod, address(lockingContract));
1078     }
1079 
1080     function() public payable {
1081         buy();
1082     }
1083 }