1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67     address public owner;
68 
69 
70     event OwnershipRenounced(address indexed previousOwner);
71     event OwnershipTransferred(
72         address indexed previousOwner,
73         address indexed newOwner
74     );
75 
76 
77     /**
78      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79      * account.
80      */
81     constructor() public {
82         owner = msg.sender;
83     }
84 
85     /**
86      * @dev Throws if called by any account other than the owner.
87      */
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92 
93     /**
94      * @dev Allows the current owner to transfer control of the contract to a newOwner.
95      * @param newOwner The address to transfer ownership to.
96      */
97     function transferOwnership(address newOwner) public onlyOwner {
98         require(newOwner != address(0));
99         emit OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101     }
102 
103     /**
104      * @dev Allows the current owner to relinquish control of the contract.
105      */
106     function renounceOwnership() public onlyOwner {
107         emit OwnershipRenounced(owner);
108         owner = address(0);
109     }
110 }
111 
112 /**
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117     function allowance(address owner, address spender)
118     public view returns (uint256);
119 
120     function transferFrom(address from, address to, uint256 value)
121     public returns (bool);
122 
123     function approve(address spender, uint256 value) public returns (bool);
124     event Approval(
125         address indexed owner,
126         address indexed spender,
127         uint256 value
128     );
129 }
130 
131 /**
132  * @title Crowdsale
133  * @dev Crowdsale is a base contract for managing a token crowdsale,
134  * allowing investors to purchase tokens with ether. This contract implements
135  * such functionality in its most fundamental form and can be extended to provide additional
136  * functionality and/or custom behavior.
137  * The external interface represents the basic interface for purchasing tokens, and conform
138  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
139  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
140  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
141  * behavior.
142  */
143 contract Crowdsale {
144     using SafeMath for uint256;
145 
146     // The token being sold
147     ERC20 public token;
148 
149     // Address where funds are collected
150     address public wallet;
151 
152     // How many token units a buyer gets per wei
153     uint256 public rate;
154 
155     // Amount of wei raised
156     uint256 public weiRaised;
157 
158     /**
159      * Event for token purchase logging
160      * @param purchaser who paid for the tokens
161      * @param beneficiary who got the tokens
162      * @param value weis paid for purchase
163      * @param amount amount of tokens purchased
164      */
165     event TokenPurchase(
166         address indexed purchaser,
167         address indexed beneficiary,
168         uint256 value,
169         uint256 amount
170     );
171 
172     /**
173      * @param _rate Number of token units a buyer gets per wei
174      * @param _wallet Address where collected funds will be forwarded to
175      * @param _token Address of the token being sold
176      */
177     constructor(uint256 _rate, address _wallet, ERC20 _token) public {
178         require(_rate > 0);
179         require(_wallet != address(0));
180         require(_token != address(0));
181 
182         rate = _rate;
183         wallet = _wallet;
184         token = _token;
185     }
186 
187     // -----------------------------------------
188     // Crowdsale external interface
189     // -----------------------------------------
190 
191     /**
192      * @dev fallback function ***DO NOT OVERRIDE***
193      */
194     function () external payable {
195         buyTokens(msg.sender);
196     }
197 
198     /**
199      * @dev low level token purchase ***DO NOT OVERRIDE***
200      * @param _beneficiary Address performing the token purchase
201      */
202     function buyTokens(address _beneficiary) public payable {
203 
204         uint256 weiAmount = msg.value;
205         _preValidatePurchase(_beneficiary, weiAmount);
206 
207         // calculate token amount to be created
208         uint256 tokens = _getTokenAmount(weiAmount);
209 
210         // update state
211         weiRaised = weiRaised.add(weiAmount);
212 
213         _processPurchase(_beneficiary, tokens);
214         emit TokenPurchase(
215             msg.sender,
216             _beneficiary,
217             weiAmount,
218             tokens
219         );
220 
221         _forwardFunds();
222     }
223 
224     // -----------------------------------------
225     // Internal interface (extensible)
226     // -----------------------------------------
227 
228     /**
229      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
230      * @param _beneficiary Address performing the token purchase
231      * @param _weiAmount Value in wei involved in the purchase
232      */
233     function _preValidatePurchase(
234         address _beneficiary,
235         uint256 _weiAmount
236     )
237     internal view
238     {
239         require(_beneficiary != address(0));
240         require(_weiAmount != 0);
241         require(weiRaised.add(_weiAmount) != 0);
242     }
243 
244     /**
245      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
246      * @param _beneficiary Address performing the token purchase
247      * @param _tokenAmount Number of tokens to be emitted
248      */
249     function _allocateTokens(
250         address _beneficiary,
251         uint256 _tokenAmount
252     )
253     internal
254     {
255         token.transfer(_beneficiary, _tokenAmount);
256     }
257 
258     /**
259      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
260      * @param _beneficiary Address receiving the tokens
261      * @param _tokenAmount Number of tokens to be purchased
262      */
263     function _processPurchase(
264         address _beneficiary,
265         uint256 _tokenAmount
266     )
267     internal
268     {
269         _allocateTokens(_beneficiary, _tokenAmount);
270     }
271 
272     /**
273      * @dev Override to extend the way in which ether is converted to tokens.
274      * @param _weiAmount Value in wei to be converted into tokens
275      * @return Number of tokens that can be purchased with the specified _weiAmount
276      */
277     function _getTokenAmount(uint256 _weiAmount)
278     internal view returns (uint256)
279     {
280         return _weiAmount.mul(rate);
281     }
282 
283     /**
284      * @dev Determines how ETH is stored/forwarded on purchases.
285      */
286     function _forwardFunds() internal {
287         wallet.transfer(msg.value);
288     }
289 }
290 
291 /**
292  * @title Basic token
293  * @dev Basic version of StandardToken, with no allowances.
294  */
295 contract BasicToken is ERC20Basic {
296     using SafeMath for uint256;
297 
298     mapping(address => uint256) balances;
299 
300     uint256 totalSupply_;
301 
302     /**
303     * @dev total number of tokens in existence
304     */
305     function totalSupply() public view returns (uint256) {
306         return totalSupply_;
307     }
308 
309     /**
310     * @dev transfer token for a specified address
311     * @param _to The address to transfer to.
312     * @param _value The amount to be transferred.
313     */
314     function transfer(address _to, uint256 _value) public returns (bool) {
315         require(_to != address(0));
316         require(_value <= balances[msg.sender]);
317 
318         balances[msg.sender] = balances[msg.sender].sub(_value);
319         balances[_to] = balances[_to].add(_value);
320         emit Transfer(msg.sender, _to, _value);
321         return true;
322     }
323 
324     /**
325     * @dev Gets the balance of the specified address.
326     * @param _owner The address to query the the balance of.
327     * @return An uint256 representing the amount owned by the passed address.
328     */
329     function balanceOf(address _owner) public view returns (uint256) {
330         return balances[_owner];
331     }
332 
333 }
334 
335 /**
336  * @title Standard ERC20 token
337  *
338  * @dev Implementation of the basic standard token.
339  * @dev https://github.com/ethereum/EIPs/issues/20
340  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
341  */
342 contract StandardToken is ERC20, BasicToken {
343 
344     mapping (address => mapping (address => uint256)) internal allowed;
345 
346 
347     /**
348      * @dev Transfer tokens from one address to another
349      * @param _from address The address which you want to send tokens from
350      * @param _to address The address which you want to transfer to
351      * @param _value uint256 the amount of tokens to be transferred
352      */
353     function transferFrom(
354         address _from,
355         address _to,
356         uint256 _value
357     )
358     public
359     returns (bool)
360     {
361         require(_to != address(0));
362         require(_value <= balances[_from]);
363         require(_value <= allowed[_from][msg.sender]);
364 
365         balances[_from] = balances[_from].sub(_value);
366         balances[_to] = balances[_to].add(_value);
367         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
368         emit Transfer(_from, _to, _value);
369         return true;
370     }
371 
372     /**
373      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
374      *
375      * Beware that changing an allowance with this method brings the risk that someone may use both the old
376      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
377      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
378      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
379      * @param _spender The address which will spend the funds.
380      * @param _value The amount of tokens to be spent.
381      */
382     function approve(address _spender, uint256 _value) public returns (bool) {
383         allowed[msg.sender][_spender] = _value;
384         emit Approval(msg.sender, _spender, _value);
385         return true;
386     }
387 
388     /**
389      * @dev Function to check the amount of tokens that an owner allowed to a spender.
390      * @param _owner address The address which owns the funds.
391      * @param _spender address The address which will spend the funds.
392      * @return A uint256 specifying the amount of tokens still available for the spender.
393      */
394     function allowance(
395         address _owner,
396         address _spender
397     )
398     public
399     view
400     returns (uint256)
401     {
402         return allowed[_owner][_spender];
403     }
404 
405     /**
406      * @dev Increase the amount of tokens that an owner allowed to a spender.
407      *
408      * approve should be called when allowed[_spender] == 0. To increment
409      * allowed value is better to use this function to avoid 2 calls (and wait until
410      * the first transaction is mined)
411      * From MonolithDAO Token.sol
412      * @param _spender The address which will spend the funds.
413      * @param _addedValue The amount of tokens to increase the allowance by.
414      */
415     function increaseApproval(
416         address _spender,
417         uint _addedValue
418     )
419     public
420     returns (bool)
421     {
422         allowed[msg.sender][_spender] = (
423         allowed[msg.sender][_spender].add(_addedValue));
424         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
425         return true;
426     }
427 
428     /**
429      * @dev Decrease the amount of tokens that an owner allowed to a spender.
430      *
431      * approve should be called when allowed[_spender] == 0. To decrement
432      * allowed value is better to use this function to avoid 2 calls (and wait until
433      * the first transaction is mined)
434      * From MonolithDAO Token.sol
435      * @param _spender The address which will spend the funds.
436      * @param _subtractedValue The amount of tokens to decrease the allowance by.
437      */
438     function decreaseApproval(
439         address _spender,
440         uint _subtractedValue
441     )
442     public
443     returns (bool)
444     {
445         uint oldValue = allowed[msg.sender][_spender];
446         if (_subtractedValue > oldValue) {
447             allowed[msg.sender][_spender] = 0;
448         } else {
449             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
450         }
451         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
452         return true;
453     }
454 
455 }
456 
457 /**
458  * @title Mintable token
459  * @dev Simple ERC20 Token example, with mintable token creation
460  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
461  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
462  */
463 contract MintableToken is StandardToken, Ownable {
464     event Mint(address indexed to, uint256 amount);
465     event MintFinished();
466 
467     bool public mintingFinished = false;
468 
469 
470     modifier canMint() {
471         require(!mintingFinished);
472         _;
473     }
474 
475     modifier hasMintPermission() {
476         require(msg.sender == owner);
477         _;
478     }
479 
480     /**
481      * @dev Function to mint tokens
482      * @param _to The address that will receive the minted tokens.
483      * @param _amount The amount of tokens to mint.
484      * @return A boolean that indicates if the operation was successful.
485      */
486     function mint(
487         address _to,
488         uint256 _amount
489     )
490     hasMintPermission
491     canMint
492     public
493     returns (bool)
494     {
495         totalSupply_ = totalSupply_.add(_amount);
496         balances[_to] = balances[_to].add(_amount);
497         emit Mint(_to, _amount);
498         emit Transfer(address(0), _to, _amount);
499         return true;
500     }
501 
502     /**
503      * @dev Function to stop minting new tokens.
504      * @return True if the operation was successful.
505      */
506     function finishMinting() onlyOwner canMint external returns (bool) {
507         mintingFinished = true;
508         emit MintFinished();
509         return true;
510     }
511 }
512 
513 /**
514  * @title CappedCrowdsale
515  * @dev Crowdsale with a limit for total contributions.
516  */
517 contract CappedCrowdsale is Crowdsale {
518     using SafeMath for uint256;
519 
520     uint256 public cap;
521 
522     /**
523      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
524      * @param _cap Max amount of wei to be contributed
525      */
526     constructor(uint256 _cap) public {
527         require(_cap > 0);
528         cap = _cap;
529     }
530 
531     /**
532      * @dev Checks whether the cap has been reached.
533      * @return Whether the cap was reached
534      */
535     function capReached() external view returns (bool) {
536         return weiRaised >= cap;
537     }
538 
539     /**
540      * @dev Extend parent behavior requiring purchase to respect the funding cap.
541      * @param _beneficiary Token purchaser
542      * @param _weiAmount Amount of wei contributed
543      */
544     function _preValidatePurchase(
545         address _beneficiary,
546         uint256 _weiAmount
547     )
548     internal view
549     {
550         super._preValidatePurchase(_beneficiary, _weiAmount);
551         require(weiRaised.add(_weiAmount) <= cap);
552     }
553 
554 }
555 
556 /**
557  * @title IndividuallyCappedCrowdsale
558  * @dev Crowdsale with individual contributor cap and minimum investment limit.
559  */
560 contract IndividuallyCappedCrowdsale is Crowdsale, CappedCrowdsale {
561     using SafeMath for uint256;
562 
563     mapping(address => uint256) public contributions;
564     uint256 public individualCap;
565     uint256 public miniumInvestment;
566 
567     /**
568      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale and minimum limit for individuals.
569      * @param _individualCap Max amount of wei that can be contributed by individuals
570      * @param _miniumInvestment Min amount of wei that can be contributed by individuals
571      */
572     constructor(uint256 _individualCap, uint256 _miniumInvestment) public {
573         require(_individualCap > 0);
574         require(_miniumInvestment > 0);
575         individualCap = _individualCap;
576         miniumInvestment = _miniumInvestment;
577     }
578 
579 
580     /**
581      * @dev Extend parent behavior requiring purchase to respect the contributor's funding cap.
582      * @param _beneficiary Address of contributor
583      * @param _weiAmount Amount of wei contributed
584      */
585     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
586         super._preValidatePurchase(_beneficiary, _weiAmount);
587         require(_weiAmount <= individualCap);
588         require(_weiAmount >= miniumInvestment);
589     }
590 }
591 
592 /**
593  * @title Pausable
594  * @dev Base contract which allows children to implement an emergency stop mechanism.
595  */
596 contract Pausable is Ownable {
597     event Pause();
598     event Unpause();
599 
600     bool public paused = false;
601 
602     /**
603      * @dev Modifier to make a function callable only when the contract is not paused.
604      */
605     modifier whenNotPaused() {
606         require(!paused);
607         _;
608     }
609 
610     /**
611      * @dev Modifier to make a function callable only when the contract is paused.
612      */
613     modifier whenPaused() {
614         require(paused);
615         _;
616     }
617 
618     /**
619      * @dev called by the owner to pause, triggers stopped state
620      */
621     function pause() onlyOwner whenNotPaused external {
622         paused = true;
623         emit Pause();
624     }
625 
626     /**
627      * @dev called by the owner to unpause, returns to normal state
628      */
629     function unpause() onlyOwner whenPaused external {
630         paused = false;
631         emit Unpause();
632     }
633 }
634 
635 
636 contract Namahecrowdsale is Pausable, IndividuallyCappedCrowdsale {
637 
638     using SafeMath for uint256;
639 
640     uint256 public openingTime;
641     uint256 public closingTime;
642     bool public isFinalized = false;
643 
644     bool public quarterFirst = true;
645     bool public quarterSecond = true;
646     bool public quarterThird = true;
647     bool public quarterFourth = true;
648 
649     uint256 public rate = 1000;
650     bool public preAllocationsPending = true;         // Indicates if pre allocations are pending
651     uint256 public totalAllocated = 0;
652     mapping(address => uint256) public allocated;     // To track allocated tokens
653     address[] public allocatedAddresses;              // To track list of contributors
654 
655     address public constant _controller  = 0x6E21c63511b0dD8f2C67BB5230C5b831f6cd7986;
656     address public constant _reserve     = 0xE4627eE46f9E0071571614ca86441AFb42972A66;
657     address public constant _promo       = 0x894387C61144f1F3a2422D17E61638B3263286Ee;
658     address public constant _holding     = 0xC7592b24b4108b387A9F413fa4eA2506a7F32Ae9;
659 
660     address public constant _founder_one = 0x3f7dB633ABAb31A687dd1DFa0876Df12Bfc18DBE;
661     address public constant _founder_two = 0xCDb0EF350717d743d47A358EADE1DF2CB71c1E4F;
662 
663     uint256 public constant PROMO_TOKEN_AMOUNT   = 6000000E18; // Promotional 6,000,000;
664     uint256 public constant RESERVE_TOKEN_AMOUNT = 24000000E18; // Reserved tokens 24,000,000;
665     uint256 public constant TEAM_TOKEN_AMOUNT    = 15000000E18; // Team and Advisors 15,000,000 each;
666 
667     uint256 public constant QUARTERLY_RELEASE    = 3750000E18; // To allocate 3,750,000;
668 
669     MintableToken public token;
670 
671     event AllocationApproved(address indexed purchaser, uint256 amount);
672     event Finalized();
673 
674     constructor (
675         uint256 _openingTime,
676         uint256 _closingTime,
677         uint256 _cap,
678         uint256 _miniumInvestment,
679         uint256 _individualCap,
680         MintableToken _token
681     )
682 
683     public
684     Crowdsale(rate, _controller, _token)
685     CappedCrowdsale(_cap)
686     IndividuallyCappedCrowdsale(_individualCap, _miniumInvestment)
687     {
688         openingTime = _openingTime;
689         closingTime = _closingTime;
690         token = _token;
691 
692     }
693 
694     /**
695     * @dev Reverts if not in crowdsale time range.
696     */
697     modifier onlyWhileOpen {
698         require(block.timestamp >= openingTime && block.timestamp <= closingTime);
699         _;
700     }
701 
702     /**
703     * @dev Complete pre-allocations to team, promotions and reserve pool
704     */
705     function doPreAllocations() external onlyOwner returns (bool) {
706         require(preAllocationsPending);
707 
708         //Allocate promo tokens immediately
709         token.transfer(_promo, PROMO_TOKEN_AMOUNT);
710 
711         //Allocate team tokens _team account through internal method
712         //_allocateTokens(_team, TEAM_TOKEN_AMOUNT);
713         _allocateTokens(_founder_one, TEAM_TOKEN_AMOUNT);
714         _allocateTokens(_founder_two, TEAM_TOKEN_AMOUNT);
715 
716         //Allocate reserved tokens to _reserve account through internal method
717         _allocateTokens(_reserve, RESERVE_TOKEN_AMOUNT);
718 
719         totalAllocated = totalAllocated.add(PROMO_TOKEN_AMOUNT);
720         preAllocationsPending = false;
721         return true;
722     }
723 
724     /**
725     * @dev Approves tokens allocated to a beneficiary
726     * @param _beneficiary Token purchaser
727     */
728     function approveAllocation(address _beneficiary) external onlyOwner returns (bool) {
729         require(_beneficiary != address(0));
730         require(_beneficiary != _founder_one);
731         require(_beneficiary != _founder_two);
732         require(_beneficiary != _reserve);
733 
734         uint256 allocatedTokens = allocated[_beneficiary];
735         token.transfer(_beneficiary, allocated[_beneficiary]);
736         allocated[_beneficiary] = 0;
737         emit AllocationApproved(_beneficiary, allocatedTokens);
738 
739         return true;
740     }
741 
742     /**
743     * @dev Release reserved tokens to _reserve address only after vesting period
744     */
745     function releaseReservedTokens() external onlyOwner {
746         require(block.timestamp > (openingTime.add(52 weeks)));
747         require(allocated[_reserve] > 0);
748 
749         token.transfer(_reserve, RESERVE_TOKEN_AMOUNT);
750         allocated[_reserve] = 0;
751     }
752 
753     /**
754      * @dev Must be called after crowdsale ends, to do some extra finalization
755      * work. Calls the contract's finalization function.
756      */
757     function finalize() external onlyOwner {
758         require(!isFinalized);
759         require(hasClosed());
760         require(!preAllocationsPending);
761 
762         finalization();
763         emit Finalized();
764 
765         isFinalized = true;
766     }
767 
768     /**
769      * @dev Extends crowdsale end date
770      */
771     function extendCrowdsale(uint256 _closingTime) external onlyOwner {
772         require(_closingTime > closingTime);
773         require(block.timestamp <= openingTime.add(36 weeks));
774 
775         closingTime = _closingTime;
776     }
777 
778     /**
779      * @dev Every quarter release, 25% of token to the founders
780      */
781     function releaseFounderTokens() external onlyOwner returns (bool) {
782         if (quarterFirst && block.timestamp >= (openingTime.add(10 weeks))) {
783             quarterFirst = false;
784             token.transfer(_founder_one, QUARTERLY_RELEASE);
785             token.transfer(_founder_two, QUARTERLY_RELEASE);
786             allocated[_founder_one] = allocated[_founder_one].sub(QUARTERLY_RELEASE);
787             allocated[_founder_two] = allocated[_founder_two].sub(QUARTERLY_RELEASE);
788             totalAllocated = totalAllocated.sub(QUARTERLY_RELEASE);
789             totalAllocated = totalAllocated.sub(QUARTERLY_RELEASE);
790 
791         }
792 
793         if (quarterSecond && block.timestamp >= (openingTime.add(22 weeks))) {
794             quarterSecond = false;
795             token.transfer(_founder_one, QUARTERLY_RELEASE);
796             token.transfer(_founder_two, QUARTERLY_RELEASE);
797             allocated[_founder_one] = allocated[_founder_one].sub(QUARTERLY_RELEASE);
798             allocated[_founder_two] = allocated[_founder_two].sub(QUARTERLY_RELEASE);
799             totalAllocated = totalAllocated.sub(QUARTERLY_RELEASE);
800             totalAllocated = totalAllocated.sub(QUARTERLY_RELEASE);
801         }
802 
803         if (quarterThird && block.timestamp >= (openingTime.add(34 weeks))) {
804             quarterThird = false;
805             token.transfer(_founder_one, QUARTERLY_RELEASE);
806             token.transfer(_founder_two, QUARTERLY_RELEASE);
807             allocated[_founder_one] = allocated[_founder_one].sub(QUARTERLY_RELEASE);
808             allocated[_founder_two] = allocated[_founder_two].sub(QUARTERLY_RELEASE);
809             totalAllocated = totalAllocated.sub(QUARTERLY_RELEASE);
810             totalAllocated = totalAllocated.sub(QUARTERLY_RELEASE);
811         }
812 
813         if (quarterFourth && block.timestamp >= (openingTime.add(46 weeks))) {
814             quarterFourth = false;
815             token.transfer(_founder_one, QUARTERLY_RELEASE);
816             token.transfer(_founder_two, QUARTERLY_RELEASE);
817             allocated[_founder_one] = allocated[_founder_one].sub(QUARTERLY_RELEASE);
818             allocated[_founder_two] = allocated[_founder_two].sub(QUARTERLY_RELEASE);
819             totalAllocated = totalAllocated.sub(QUARTERLY_RELEASE);
820             totalAllocated = totalAllocated.sub(QUARTERLY_RELEASE);
821         }
822 
823         return true;
824     }
825 
826     /**
827     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
828     * @return Whether crowdsale period has elapsed
829     */
830     function hasClosed() public view returns (bool) {
831         return block.timestamp > closingTime;
832     }
833 
834     /**
835     * @dev Returns rate as per bonus structure
836     * @return Rate
837     */
838     function getRate() public view returns (uint256) {
839 
840         if (block.timestamp <= (openingTime.add(14 days))) {return rate.add(200);}
841         if (block.timestamp <= (openingTime.add(28 days))) {return rate.add(100);}
842         if (block.timestamp <= (openingTime.add(49 days))) {return rate.add(50);}
843 
844         return rate;
845     }
846 
847     /**
848     * @dev Releases unapproved tokens to _holding address. Only called during finalization.
849     */
850     function reclaimAllocated() internal {
851 
852         uint256 unapprovedTokens = 0;
853         for (uint256 i = 0; i < allocatedAddresses.length; i++) {
854             // skip counting _team and _reserve allocations
855             if (allocatedAddresses[i] != _founder_one && allocatedAddresses[i] != _founder_two && allocatedAddresses[i] != _reserve) {
856                 unapprovedTokens = unapprovedTokens.add(allocated[allocatedAddresses[i]]);
857                 allocated[allocatedAddresses[i]] = 0;
858             }
859         }
860         token.transfer(_holding, unapprovedTokens);
861     }
862 
863     /**
864     * @dev Reclaim remaining tokens after crowdsale is complete. Tokens allocated to
865     * _team and _balance will be left out to arrive at balance tokens.
866     */
867     function reclaimBalanceTokens() internal {
868 
869         uint256 balanceTokens = token.balanceOf(this);
870         balanceTokens = balanceTokens.sub(allocated[_founder_one]);
871         balanceTokens = balanceTokens.sub(allocated[_founder_two]);
872         balanceTokens = balanceTokens.sub(allocated[_reserve]);
873         token.transfer(_controller, balanceTokens);
874     }
875 
876     /**
877     * @dev Overridden to add finalization logic.
878     */
879     function finalization() internal {
880         reclaimAllocated();
881         reclaimBalanceTokens();
882     }
883 
884     /**
885     * @dev Overridden to adjust the rate including bonus
886     * @param _weiAmount Value in wei to be converted into tokens
887     * @return Number of tokens that can be purchased with the given _weiAmount
888     */
889     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
890         uint256 tokenAmount = _weiAmount.mul(getRate());
891         return tokenAmount;
892     }
893 
894     /**
895     * @dev Extend parent behavior requiring to be within contributing period.
896     * If purchases are paused, transactions fail.
897     * @param _beneficiary Token purchaser
898     * @param _weiAmount Amount of wei contributed
899     */
900     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view onlyWhileOpen whenNotPaused {
901         super._preValidatePurchase(_beneficiary, _weiAmount);
902     }
903 
904     /**
905     * @dev Overriden method to update tokens allocated to a beneficiary
906     * @param _beneficiary Address sending ether
907     * @param _tokenAmount Number of token to be allocated
908     */
909     function _allocateTokens(address _beneficiary, uint256 _tokenAmount) internal {
910         //token.transfer(_beneficiary, _tokenAmount);
911         require(token.balanceOf(this) >= totalAllocated.add(_tokenAmount));
912         allocated[_beneficiary] = allocated[_beneficiary].add(_tokenAmount);
913         totalAllocated = totalAllocated.add(_tokenAmount);
914         allocatedAddresses.push(_beneficiary);
915 
916     }
917 }