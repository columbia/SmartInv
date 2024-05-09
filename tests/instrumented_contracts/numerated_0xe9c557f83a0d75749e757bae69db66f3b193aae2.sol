1 pragma solidity ^0.4.21;
2 
3 
4 // File: contracts/library/SafeMath.sol
5 
6 /**
7  * @title Safe Math
8  *
9  * @dev Library for safe mathematical operations.
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a * b;
14         assert(a == 0 || c / a == b);
15 
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a / b;
21 
22         return c;
23     }
24 
25     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27 
28         return a - b;
29     }
30 
31     function plus(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34 
35         return c;
36     }
37 }
38 
39 // File: contracts/token/ERC20Token.sol
40 
41 /**
42  * @dev The standard ERC20 Token contract base.
43  */
44 contract ERC20Token {
45     uint256 public totalSupply;  /* shorthand for public function and a property */
46     
47     function balanceOf(address _owner) public view returns (uint256 balance);
48     function transfer(address _to, uint256 _value) public returns (bool success);
49     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
50     function approve(address _spender, uint256 _value) public returns (bool success);
51     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
52 
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 // File: contracts/component/TokenSafe.sol
58 
59 /**
60  * @title TokenSafe
61  *
62  * @dev Abstract contract that serves as a base for the token safes. It is a multi-group token safe, where each group
63  *      has it's own release time and multiple accounts with locked tokens.
64  */
65 contract TokenSafe {
66     using SafeMath for uint;
67 
68     // The ERC20 token contract.
69     ERC20Token token;
70 
71     struct Group {
72         // The release date for the locked tokens
73         // Note: Unix timestamp fits in uint32, however block.timestamp is uint256
74         uint256 releaseTimestamp;
75         // The total remaining tokens in the group.
76         uint256 remaining;
77         // The individual account token balances in the group.
78         mapping (address => uint) balances;
79     }
80 
81     // The groups of locked tokens
82     mapping (uint8 => Group) public groups;
83 
84     /**
85      * @dev The constructor.
86      *
87      * @param _token The address of the Fabric Token (fundraiser) contract.
88      */
89     constructor(address _token) public {
90         token = ERC20Token(_token);
91     }
92 
93     /**
94      * @dev The function initializes a group with a release date.
95      *
96      * @param _id Group identifying number.
97      * @param _releaseTimestamp Unix timestamp of the time after which the tokens can be released
98      */
99     function init(uint8 _id, uint _releaseTimestamp) internal {
100         require(_releaseTimestamp > 0);
101         
102         Group storage group = groups[_id];
103         group.releaseTimestamp = _releaseTimestamp;
104     }
105 
106     /**
107      * @dev Add new account with locked token balance to the specified group id.
108      *
109      * @param _id Group identifying number.
110      * @param _account The address of the account to be added.
111      * @param _balance The number of tokens to be locked.
112      */
113     function add(uint8 _id, address _account, uint _balance) internal {
114         Group storage group = groups[_id];
115         group.balances[_account] = group.balances[_account].plus(_balance);
116         group.remaining = group.remaining.plus(_balance);
117     }
118 
119     /**
120      * @dev Allows an account to be released if it meets the time constraints of the group.
121      *
122      * @param _id Group identifying number.
123      * @param _account The address of the account to be released.
124      */
125     function release(uint8 _id, address _account) public {
126         Group storage group = groups[_id];
127         require(now >= group.releaseTimestamp);
128         
129         uint tokens = group.balances[_account];
130         require(tokens > 0);
131         
132         group.balances[_account] = 0;
133         group.remaining = group.remaining.minus(tokens);
134         
135         if (!token.transfer(_account, tokens)) {
136             revert();
137         }
138     }
139 }
140 
141 // File: contracts/token/StandardToken.sol
142 
143 /**
144  * @title Standard Token
145  *
146  * @dev The standard abstract implementation of the ERC20 interface.
147  */
148 contract StandardToken is ERC20Token {
149     using SafeMath for uint256;
150 
151     string public name;
152     string public symbol;
153     uint8 public decimals;
154     
155     mapping (address => uint256) balances;
156     mapping (address => mapping (address => uint256)) internal allowed;
157     
158     /**
159      * @dev The constructor assigns the token name, symbols and decimals.
160      */
161     constructor(string _name, string _symbol, uint8 _decimals) internal {
162         name = _name;
163         symbol = _symbol;
164         decimals = _decimals;
165     }
166 
167     /**
168      * @dev Get the balance of an address.
169      *
170      * @param _address The address which's balance will be checked.
171      *
172      * @return The current balance of the address.
173      */
174     function balanceOf(address _address) public view returns (uint256 balance) {
175         return balances[_address];
176     }
177 
178     /**
179      * @dev Checks the amount of tokens that an owner allowed to a spender.
180      *
181      * @param _owner The address which owns the funds allowed for spending by a third-party.
182      * @param _spender The third-party address that is allowed to spend the tokens.
183      *
184      * @return The number of tokens available to `_spender` to be spent.
185      */
186     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
187         return allowed[_owner][_spender];
188     }
189 
190     /**
191      * @dev Give permission to `_spender` to spend `_value` number of tokens on your behalf.
192      * E.g. You place a buy or sell order on an exchange and in that example, the 
193      * `_spender` address is the address of the contract the exchange created to add your token to their 
194      * website and you are `msg.sender`.
195      *
196      * @param _spender The address which will spend the funds.
197      * @param _value The amount of tokens to be spent.
198      *
199      * @return Whether the approval process was successful or not.
200      */
201     function approve(address _spender, uint256 _value) public returns (bool) {
202         allowed[msg.sender][_spender] = _value;
203 
204         emit Approval(msg.sender, _spender, _value);
205 
206         return true;
207     }
208 
209     /**
210      * @dev Transfers `_value` number of tokens to the `_to` address.
211      *
212      * @param _to The address of the recipient.
213      * @param _value The number of tokens to be transferred.
214      */
215     function transfer(address _to, uint256 _value) public returns (bool) {
216         executeTransfer(msg.sender, _to, _value);
217 
218         return true;
219     }
220 
221     /**
222      * @dev Allows another contract to spend tokens on behalf of the `_from` address and send them to the `_to` address.
223      *
224      * @param _from The address which approved you to spend tokens on their behalf.
225      * @param _to The address where you want to send tokens.
226      * @param _value The number of tokens to be sent.
227      *
228      * @return Whether the transfer was successful or not.
229      */
230     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
231         require(_value <= allowed[_from][msg.sender]);
232         
233         allowed[_from][msg.sender] = allowed[_from][msg.sender].minus(_value);
234         executeTransfer(_from, _to, _value);
235 
236         return true;
237     }
238 
239     /**
240      * @dev Internal function that this reused by the transfer functions
241      */
242     function executeTransfer(address _from, address _to, uint256 _value) internal {
243         require(_to != address(0));
244         require(_value != 0 && _value <= balances[_from]);
245         
246         balances[_from] = balances[_from].minus(_value);
247         balances[_to] = balances[_to].plus(_value);
248 
249         emit Transfer(_from, _to, _value);
250     }
251 }
252 
253 // File: contracts/token/MintableToken.sol
254 
255 /**
256  * @title Mintable Token
257  *
258  * @dev Allows the creation of new tokens.
259  */
260 contract MintableToken is StandardToken {
261     /// @dev The only address allowed to mint coins
262     address public minter;
263 
264     /// @dev Indicates whether the token is still mintable.
265     bool public mintingDisabled = false;
266 
267     /**
268      * @dev Event fired when minting is no longer allowed.
269      */
270     event MintingDisabled();
271 
272     /**
273      * @dev Allows a function to be executed only if minting is still allowed.
274      */
275     modifier canMint() {
276         require(!mintingDisabled);
277         _;
278     }
279 
280     /**
281      * @dev Allows a function to be called only by the minter
282      */
283     modifier onlyMinter() {
284         require(msg.sender == minter);
285         _;
286     }
287 
288     /**
289      * @dev The constructor assigns the minter which is allowed to mind and disable minting
290      */
291     constructor(address _minter) internal {
292         minter = _minter;
293     }
294 
295     /**
296     * @dev Creates new `_value` number of tokens and sends them to the `_to` address.
297     *
298     * @param _to The address which will receive the freshly minted tokens.
299     * @param _value The number of tokens that will be created.
300     */
301     function mint(address _to, uint256 _value) public onlyMinter canMint {
302         totalSupply = totalSupply.plus(_value);
303         balances[_to] = balances[_to].plus(_value);
304 
305         emit Transfer(0x0, _to, _value);
306     }
307 
308     /**
309     * @dev Disable the minting of new tokens. Cannot be reversed.
310     *
311     * @return Whether or not the process was successful.
312     */
313     function disableMinting() public onlyMinter canMint {
314         mintingDisabled = true;
315        
316         emit MintingDisabled();
317     }
318 }
319 
320 // File: contracts/trait/HasOwner.sol
321 
322 /**
323  * @title HasOwner
324  *
325  * @dev Allows for exclusive access to certain functionality.
326  */
327 contract HasOwner {
328     // The current owner.
329     address public owner;
330 
331     // Conditionally the new owner.
332     address public newOwner;
333 
334     /**
335      * @dev The constructor.
336      *
337      * @param _owner The address of the owner.
338      */
339     constructor(address _owner) public {
340         owner = _owner;
341     }
342 
343     /** 
344      * @dev Access control modifier that allows only the current owner to call the function.
345      */
346     modifier onlyOwner {
347         require(msg.sender == owner);
348         _;
349     }
350 
351     /**
352      * @dev The event is fired when the current owner is changed.
353      *
354      * @param _oldOwner The address of the previous owner.
355      * @param _newOwner The address of the new owner.
356      */
357     event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);
358 
359     /**
360      * @dev Transfering the ownership is a two-step process, as we prepare
361      * for the transfer by setting `newOwner` and requiring `newOwner` to accept
362      * the transfer. This prevents accidental lock-out if something goes wrong
363      * when passing the `newOwner` address.
364      *
365      * @param _newOwner The address of the proposed new owner.
366      */
367     function transferOwnership(address _newOwner) public onlyOwner {
368         newOwner = _newOwner;
369     }
370  
371     /**
372      * @dev The `newOwner` finishes the ownership transfer process by accepting the
373      * ownership.
374      */
375     function acceptOwnership() public {
376         require(msg.sender == newOwner);
377 
378         emit OwnershipTransfer(owner, newOwner);
379 
380         owner = newOwner;
381     }
382 }
383 
384 // File: contracts/fundraiser/AbstractFundraiser.sol
385 
386 contract AbstractFundraiser {
387     /// The ERC20 token contract.
388     ERC20Token public token;
389 
390     /**
391      * @dev The event fires every time a new buyer enters the fundraiser.
392      *
393      * @param _address The address of the buyer.
394      * @param _ethers The number of ethers funded.
395      * @param _tokens The number of tokens purchased.
396      */
397     event FundsReceived(address indexed _address, uint _ethers, uint _tokens);
398 
399 
400     /**
401      * @dev The initialization method for the token
402      *
403      * @param _token The address of the token of the fundraiser
404      */
405     function initializeFundraiserToken(address _token) internal
406     {
407         token = ERC20Token(_token);
408     }
409 
410     /**
411      * @dev The default function which is executed when someone sends funds to this contract address.
412      */
413     function() public payable {
414         receiveFunds(msg.sender, msg.value);
415     }
416 
417     /**
418      * @dev this overridable function returns the current conversion rate for the fundraiser
419      */
420     function getConversionRate() public view returns (uint256);
421 
422     /**
423      * @dev checks whether the fundraiser passed `endTime`.
424      *
425      * @return whether the fundraiser has ended.
426      */
427     function hasEnded() public view returns (bool);
428 
429     /**
430      * @dev Create and sends tokens to `_address` considering amount funded and `conversionRate`.
431      *
432      * @param _address The address of the receiver of tokens.
433      * @param _amount The amount of received funds in ether.
434      */
435     function receiveFunds(address _address, uint256 _amount) internal;
436     
437     /**
438      * @dev It throws an exception if the transaction does not meet the preconditions.
439      */
440     function validateTransaction() internal view;
441     
442     /**
443      * @dev this overridable function makes and handles tokens to buyers
444      */
445     function handleTokens(address _address, uint256 _tokens) internal;
446 
447     /**
448      * @dev this overridable function forwards the funds (if necessary) to a vault or directly to the beneficiary
449      */
450     function handleFunds(address _address, uint256 _ethers) internal;
451 
452 }
453 
454 // File: contracts/fundraiser/BasicFundraiser.sol
455 
456 /**
457  * @title Basic Fundraiser
458  *
459  * @dev An abstract contract that is a base for fundraisers. 
460  * It implements a generic procedure for handling received funds:
461  * 1. Validates the transaciton preconditions
462  * 2. Calculates the amount of tokens based on the conversion rate.
463  * 3. Delegate the handling of the tokens (mint, transfer or conjure)
464  * 4. Delegate the handling of the funds
465  * 5. Emit event for received funds
466  */
467 contract BasicFundraiser is HasOwner, AbstractFundraiser {
468     using SafeMath for uint256;
469 
470     // The number of decimals for the token.
471     uint8 constant DECIMALS = 18;  // Enforced
472 
473     // Decimal factor for multiplication purposes.
474     uint256 constant DECIMALS_FACTOR = 10 ** uint256(DECIMALS);
475 
476     // The start time of the fundraiser - Unix timestamp.
477     uint256 public startTime;
478 
479     // The end time of the fundraiser - Unix timestamp.
480     uint256 public endTime;
481 
482     // The address where funds collected will be sent.
483     address public beneficiary;
484 
485     // The conversion rate with decimals difference adjustment,
486     // When converion rate is lower than 1 (inversed), the function calculateTokens() should use division
487     uint256 public conversionRate;
488 
489     // The total amount of ether raised.
490     uint256 public totalRaised;
491 
492     /**
493      * @dev The event fires when the number of token conversion rate has changed.
494      *
495      * @param _conversionRate The new number of tokens per 1 ether.
496      */
497     event ConversionRateChanged(uint _conversionRate);
498 
499     /**
500      * @dev The basic fundraiser initialization method.
501      *
502      * @param _startTime The start time of the fundraiser - Unix timestamp.
503      * @param _endTime The end time of the fundraiser - Unix timestamp.
504      * @param _conversionRate The number of tokens create for 1 ETH funded.
505      * @param _beneficiary The address which will receive the funds gathered by the fundraiser.
506      */
507     function initializeBasicFundraiser(
508         uint256 _startTime,
509         uint256 _endTime,
510         uint256 _conversionRate,
511         address _beneficiary
512     )
513         internal
514     {
515         require(_endTime >= _startTime);
516         require(_conversionRate > 0);
517         require(_beneficiary != address(0));
518 
519         startTime = _startTime;
520         endTime = _endTime;
521         conversionRate = _conversionRate;
522         beneficiary = _beneficiary;
523     }
524 
525     /**
526      * @dev Sets the new conversion rate
527      *
528      * @param _conversionRate New conversion rate
529      */
530     function setConversionRate(uint256 _conversionRate) public onlyOwner {
531         require(_conversionRate > 0);
532 
533         conversionRate = _conversionRate;
534 
535         emit ConversionRateChanged(_conversionRate);
536     }
537 
538     /**
539      * @dev Sets The beneficiary of the fundraiser.
540      *
541      * @param _beneficiary The address of the beneficiary.
542      */
543     function setBeneficiary(address _beneficiary) public onlyOwner {
544         require(_beneficiary != address(0));
545 
546         beneficiary = _beneficiary;
547     }
548 
549     /**
550      * @dev Create and sends tokens to `_address` considering amount funded and `conversionRate`.
551      *
552      * @param _address The address of the receiver of tokens.
553      * @param _amount The amount of received funds in ether.
554      */
555     function receiveFunds(address _address, uint256 _amount) internal {
556         validateTransaction();
557 
558         uint256 tokens = calculateTokens(_amount);
559         require(tokens > 0);
560 
561         totalRaised = totalRaised.plus(_amount);
562         handleTokens(_address, tokens);
563         handleFunds(_address, _amount);
564 
565         emit FundsReceived(_address, msg.value, tokens);
566     }
567 
568     /**
569      * @dev this overridable function returns the current conversion rate multiplied by the conversion rate factor
570      */
571     function getConversionRate() public view returns (uint256) {
572         return conversionRate;
573     }
574 
575     /**
576      * @dev this overridable function that calculates the tokens based on the ether amount
577      */
578     function calculateTokens(uint256 _amount) internal view returns(uint256 tokens) {
579         tokens = _amount.mul(getConversionRate());
580     }
581 
582     /**
583      * @dev It throws an exception if the transaction does not meet the preconditions.
584      */
585     function validateTransaction() internal view {
586         require(msg.value != 0);
587         require(now >= startTime && now < endTime);
588     }
589 
590     /**
591      * @dev checks whether the fundraiser passed `endtime`.
592      *
593      * @return whether the fundraiser is passed its deadline or not.
594      */
595     function hasEnded() public view returns (bool) {
596         return now >= endTime;
597     }
598 }
599 
600 // File: contracts/token/StandardMintableToken.sol
601 
602 contract StandardMintableToken is MintableToken {
603     constructor(address _minter, string _name, string _symbol, uint8 _decimals)
604         StandardToken(_name, _symbol, _decimals)
605         MintableToken(_minter)
606         public
607     {
608     }
609 }
610 
611 // File: contracts/fundraiser/MintableTokenFundraiser.sol
612 
613 /**
614  * @title Fundraiser With Mintable Token
615  */
616 contract MintableTokenFundraiser is BasicFundraiser {
617     /**
618      * @dev The initialization method that creates a new mintable token.
619      *
620      * @param _name Token name
621      * @param _symbol Token symbol
622      * @param _decimals Token decimals
623      */
624     function initializeMintableTokenFundraiser(string _name, string _symbol, uint8 _decimals) internal {
625         token = new StandardMintableToken(
626             address(this), // The fundraiser is the token minter
627             _name,
628             _symbol,
629             _decimals
630         );
631     }
632 
633     /**
634      * @dev Mint the specific amount tokens
635      */
636     function handleTokens(address _address, uint256 _tokens) internal {
637         MintableToken(token).mint(_address, _tokens);
638     }
639 }
640 
641 // File: contracts/fundraiser/IndividualCapsFundraiser.sol
642 
643 /**
644  * @title Fundraiser with individual caps
645  *
646  * @dev Allows you to set a hard cap on your fundraiser.
647  */
648 contract IndividualCapsFundraiser is BasicFundraiser {
649     uint256 public individualMinCap;
650     uint256 public individualMaxCap;
651     uint256 public individualMaxCapTokens;
652 
653 
654     event IndividualMinCapChanged(uint256 _individualMinCap);
655     event IndividualMaxCapTokensChanged(uint256 _individualMaxCapTokens);
656 
657     /**
658      * @dev The initialization method.
659      *
660      * @param _individualMinCap The minimum amount of ether contribution per address.
661      * @param _individualMaxCap The maximum amount of ether contribution per address.
662      */
663     function initializeIndividualCapsFundraiser(uint256 _individualMinCap, uint256 _individualMaxCap) internal {
664         individualMinCap = _individualMinCap;
665         individualMaxCap = _individualMaxCap;
666         individualMaxCapTokens = _individualMaxCap * conversionRate;
667     }
668 
669     function setConversionRate(uint256 _conversionRate) public onlyOwner {
670         super.setConversionRate(_conversionRate);
671 
672         if (individualMaxCap == 0) {
673             return;
674         }
675         
676         individualMaxCapTokens = individualMaxCap * _conversionRate;
677 
678         emit IndividualMaxCapTokensChanged(individualMaxCapTokens);
679     }
680 
681     function setIndividualMinCap(uint256 _individualMinCap) public onlyOwner {
682         individualMinCap = _individualMinCap;
683 
684         emit IndividualMinCapChanged(individualMinCap);
685     }
686 
687     function setIndividualMaxCap(uint256 _individualMaxCap) public onlyOwner {
688         individualMaxCap = _individualMaxCap;
689         individualMaxCapTokens = _individualMaxCap * conversionRate;
690 
691         emit IndividualMaxCapTokensChanged(individualMaxCapTokens);
692     }
693 
694     /**
695      * @dev Extends the transaction validation to check if the value this higher than the minumum cap.
696      */
697     function validateTransaction() internal view {
698         super.validateTransaction();
699         require(msg.value >= individualMinCap);
700     }
701 
702     /**
703      * @dev We validate the new amount doesn't surpass maximum contribution cap
704      */
705     function handleTokens(address _address, uint256 _tokens) internal {
706         require(individualMaxCapTokens == 0 || token.balanceOf(_address).plus(_tokens) <= individualMaxCapTokens);
707 
708         super.handleTokens(_address, _tokens);
709     }
710 }
711 
712 // File: contracts/fundraiser/GasPriceLimitFundraiser.sol
713 
714 /**
715  * @title GasPriceLimitFundraiser
716  *
717  * @dev This fundraiser allows to set gas price limit for the participants in the fundraiser
718  */
719 contract GasPriceLimitFundraiser is HasOwner, BasicFundraiser {
720     uint256 public gasPriceLimit;
721 
722     event GasPriceLimitChanged(uint256 gasPriceLimit);
723 
724     /**
725      * @dev This function puts the initial gas limit
726      */
727     function initializeGasPriceLimitFundraiser(uint256 _gasPriceLimit) internal {
728         gasPriceLimit = _gasPriceLimit;
729     }
730 
731     /**
732      * @dev This function allows the owner to change the gas limit any time during the fundraiser
733      */
734     function changeGasPriceLimit(uint256 _gasPriceLimit) onlyOwner() public {
735         gasPriceLimit = _gasPriceLimit;
736 
737         emit GasPriceLimitChanged(_gasPriceLimit);
738     }
739 
740     /**
741      * @dev The transaction is valid if the gas price limit is lifted-off or the transaction meets the requirement
742      */
743     function validateTransaction() internal view {
744         require(gasPriceLimit == 0 || tx.gasprice <= gasPriceLimit);
745 
746         return super.validateTransaction();
747     }
748 }
749 
750 // File: contracts/fundraiser/ForwardFundsFundraiser.sol
751 
752 /**
753  * @title Forward Funds to Beneficiary Fundraiser
754  *
755  * @dev This contract forwards the funds received to the beneficiary.
756  */
757 contract ForwardFundsFundraiser is BasicFundraiser {
758     /**
759      * @dev Forward funds directly to beneficiary
760      */
761     function handleFunds(address, uint256 _ethers) internal {
762         // Forward the funds directly to the beneficiary
763         beneficiary.transfer(_ethers);
764     }
765 }
766 
767 // File: contracts/fundraiser/PresaleFundraiser.sol
768 
769 /**
770  * @title PresaleFundraiser
771  *
772  * @dev This is the standard fundraiser contract which allows
773  * you to raise ETH in exchange for your tokens.
774  */
775 contract PresaleFundraiser is MintableTokenFundraiser {
776     /// @dev The token hard cap for the pre-sale
777     uint256 public presaleSupply;
778 
779     /// @dev The token hard cap for the pre-sale
780     uint256 public presaleMaxSupply;
781 
782     /// @dev The start time of the pre-sale (Unix timestamp).
783     uint256 public presaleStartTime;
784 
785     /// @dev The end time of the pre-sale (Unix timestamp).
786     uint256 public presaleEndTime;
787 
788     /// @dev The conversion rate for the pre-sale
789     uint256 public presaleConversionRate;
790 
791     /**
792      * @dev The initialization method.
793      *
794      * @param _startTime The timestamp of the moment when the pre-sale starts
795      * @param _endTime The timestamp of the moment when the pre-sale ends
796      * @param _conversionRate The conversion rate during the pre-sale
797      */
798     function initializePresaleFundraiser(
799         uint256 _presaleMaxSupply,
800         uint256 _startTime,
801         uint256 _endTime,
802         uint256 _conversionRate
803     )
804         internal
805     {
806         require(_endTime >= _startTime);
807         require(_conversionRate > 0);
808 
809         presaleMaxSupply = _presaleMaxSupply;
810         presaleStartTime = _startTime;
811         presaleEndTime = _endTime;
812         presaleConversionRate = _conversionRate;
813     }
814 
815     /**
816      * @dev Internal funciton that helps to check if the pre-sale is active
817      */
818     
819     function isPresaleActive() internal view returns (bool) {
820         return now < presaleEndTime && now >= presaleStartTime;
821     }
822     /**
823      * @dev this function different conversion rate while in presale
824      */
825     function getConversionRate() public view returns (uint256) {
826         if (isPresaleActive()) {
827             return presaleConversionRate;
828         }
829         return super.getConversionRate();
830     }
831 
832     /**
833      * @dev It throws an exception if the transaction does not meet the preconditions.
834      */
835     function validateTransaction() internal view {
836         require(msg.value != 0);
837         require(now >= startTime && now < endTime || isPresaleActive());
838     }
839 
840     function handleTokens(address _address, uint256 _tokens) internal {
841         if (isPresaleActive()) {
842             presaleSupply = presaleSupply.plus(_tokens);
843             require(presaleSupply <= presaleMaxSupply);
844         }
845 
846         super.handleTokens(_address, _tokens);
847     }
848 
849 }
850 
851 // File: contracts/fundraiser/TieredFundraiser.sol
852 
853 /**
854  * @title TieredFundraiser
855  *
856  * @dev A fundraiser that improves the base conversion precision to allow percent bonuses
857  */
858 
859 contract TieredFundraiser is BasicFundraiser {
860     // Conversion rate factor for better precision.
861     uint256 constant CONVERSION_RATE_FACTOR = 100;
862 
863     /**
864       * @dev Define conversion rates based on the tier start and end date
865       */
866     function getConversionRate() public view returns (uint256) {
867         return super.getConversionRate().mul(CONVERSION_RATE_FACTOR);
868     }
869 
870     /**
871      * @dev this overridable function that calculates the tokens based on the ether amount
872      */
873     function calculateTokens(uint256 _amount) internal view returns(uint256 tokens) {
874         return super.calculateTokens(_amount).div(CONVERSION_RATE_FACTOR);
875     }
876 
877     /**
878      * @dev this overridable function returns the current conversion rate factor
879      */
880     function getConversionRateFactor() public pure returns (uint256) {
881         return CONVERSION_RATE_FACTOR;
882     }
883 }
884 
885 // File: contracts/Fundraiser.sol
886 
887 /**
888  * @title SPACEToken
889  */
890 
891 contract SPACEToken is MintableToken {
892     constructor(address _minter)
893         StandardToken(
894             "SPACE",   // Token name
895             "SP", // Token symbol
896             18  // Token decimals
897         )
898         
899         MintableToken(_minter)
900         public
901     {
902     }
903 }
904 
905 
906 
907 /**
908  * @title SPACETokenSafe
909  */
910 
911 contract SPACETokenSafe is TokenSafe {
912   constructor(address _token)
913     TokenSafe(_token)
914     public
915   {
916     
917     // Group "Core Team Members and Project Advisors"
918     init(
919       1, // Group Id
920       1547510400 // Release date = 2019-01-15 00:00 UTC
921     );
922     add(
923       1, // Group Id
924       0x80C82349860c720e1A2197bA603FF69E396021fc,  // Token Safe Entry Address
925       315000000000000000000000  // Allocated tokens
926     );
927   }
928 }
929 
930 
931 
932 /**
933  * @title SPACETokenFundraiser
934  */
935 
936 contract SPACETokenFundraiser is MintableTokenFundraiser, PresaleFundraiser, IndividualCapsFundraiser, ForwardFundsFundraiser, TieredFundraiser, GasPriceLimitFundraiser {
937     SPACETokenSafe public tokenSafe;
938 
939     constructor()
940         HasOwner(msg.sender)
941         public
942     {
943         token = new SPACEToken(
944         
945         address(this)  // The fundraiser is the minter
946         );
947 
948         tokenSafe = new SPACETokenSafe(token);
949         MintableToken(token).mint(address(tokenSafe), 315000000000000000000000);
950 
951         initializeBasicFundraiser(
952             1546300800, // Start date = 2019-01-01 00:00 UTC
953             1567295940,  // End date = 2019-08-31 23:59 UTC
954             1, // Conversion rate = 1 SP per 1 ether
955             0x413C7299268466e2E68A179750EBB7aC2d1D9160     // Beneficiary
956         );
957 
958         initializeIndividualCapsFundraiser(
959             (0 ether), // Minimum contribution
960             (0 ether)  // Maximum individual cap
961         );
962 
963         initializeGasPriceLimitFundraiser(
964             200000000000000 // Gas price limit in wei
965         );
966 
967         initializePresaleFundraiser(
968             900000000000000000000000,
969             1542412800, // Start = 2018-11-17 00:00 UTC
970             1546300740,   // End = 2018-12-31 23:59 UTC
971             1
972         );
973 
974         
975 
976         
977 
978         
979     }
980     
981     /**
982       * @dev Define conversion rates based on the tier start and end date
983       */
984     function getConversionRate() public view returns (uint256) {
985         uint256 rate = super.getConversionRate();
986         if (now >= 1546300800 && now < 1548979140)
987             return rate.mul(110).div(100);
988         
989         if (now >= 1548979200 && now < 1556668740)
990             return rate.mul(105).div(100);
991         
992         if (now >= 1556668800 && now < 1567295940)
993             return rate.mul(105).div(100);
994         
995 
996         return rate;
997     }
998 
999     /**
1000       * @dev Fundraiser with mintable token allows the owner to mint through the Fundraiser contract
1001       */
1002     function mint(address _to, uint256 _value) public onlyOwner {
1003         MintableToken(token).mint(_to, _value);
1004     }
1005 
1006     /**
1007       * @dev Irreversibly disable minting
1008       */
1009     function disableMinting() public onlyOwner {
1010         MintableToken(token).disableMinting();
1011     }
1012     
1013 }