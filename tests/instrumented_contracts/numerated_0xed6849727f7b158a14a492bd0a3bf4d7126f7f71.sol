1 pragma solidity ^0.4.22;
2 
3 // File: contracts/library/SafeMath.sol
4 
5 /**
6  * @title Safe Math
7  *
8  * @dev Library for safe mathematical operations.
9  */
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14 
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a / b;
20 
21         return c;
22     }
23 
24     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26 
27         return a - b;
28     }
29 
30     function plus(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33 
34         return c;
35     }
36 }
37 
38 // File: contracts/token/ERC20Token.sol
39 
40 /**
41  * @dev The standard ERC20 Token contract base.
42  */
43 contract ERC20Token {
44     uint256 public totalSupply;  /* shorthand for public function and a property */
45     
46     function balanceOf(address _owner) public view returns (uint256 balance);
47     function transfer(address _to, uint256 _value) public returns (bool success);
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
49     function approve(address _spender, uint256 _value) public returns (bool success);
50     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 // File: contracts/component/TokenSafe.sol
57 
58 /**
59  * @title TokenSafe
60  *
61  * @dev Abstract contract that serves as a base for the token safes. It is a multi-group token safe, where each group
62  *      has it's own release time and multiple accounts with locked tokens.
63  */
64 contract TokenSafe {
65     using SafeMath for uint;
66 
67     // The ERC20 token contract.
68     ERC20Token token;
69 
70     struct Group {
71         // The release date for the locked tokens
72         // Note: Unix timestamp fits in uint32, however block.timestamp is uint256
73         uint256 releaseTimestamp;
74         // The total remaining tokens in the group.
75         uint256 remaining;
76         // The individual account token balances in the group.
77         mapping (address => uint) balances;
78     }
79 
80     // The groups of locked tokens
81     mapping (uint8 => Group) public groups;
82 
83     /**
84      * @dev The constructor.
85      *
86      * @param _token The address of the Fabric Token (fundraiser) contract.
87      */
88     constructor(address _token) public {
89         token = ERC20Token(_token);
90     }
91 
92     /**
93      * @dev The function initializes a group with a release date.
94      *
95      * @param _id Group identifying number.
96      * @param _releaseTimestamp Unix timestamp of the time after which the tokens can be released
97      */
98     function init(uint8 _id, uint _releaseTimestamp) internal {
99         require(_releaseTimestamp > 0, "TokenSafe group release timestamp is not set");
100         
101         Group storage group = groups[_id];
102         group.releaseTimestamp = _releaseTimestamp;
103     }
104 
105     /**
106      * @dev Add new account with locked token balance to the specified group id.
107      *
108      * @param _id Group identifying number.
109      * @param _account The address of the account to be added.
110      * @param _balance The number of tokens to be locked.
111      */
112     function add(uint8 _id, address _account, uint _balance) internal {
113         Group storage group = groups[_id];
114         group.balances[_account] = group.balances[_account].plus(_balance);
115         group.remaining = group.remaining.plus(_balance);
116     }
117 
118     /**
119      * @dev Allows an account to be released if it meets the time constraints of the group.
120      *
121      * @param _id Group identifying number.
122      * @param _account The address of the account to be released.
123      */
124     function release(uint8 _id, address _account) public {
125         Group storage group = groups[_id];
126         require(now >= group.releaseTimestamp, "Group funds are not released yet");
127         
128         uint tokens = group.balances[_account];
129         require(tokens > 0, "The account is empty or non-existent");
130         
131         group.balances[_account] = 0;
132         group.remaining = group.remaining.minus(tokens);
133         
134         if (!token.transfer(_account, tokens)) {
135             revert("Token transfer failed");
136         }
137     }
138 }
139 
140 // File: contracts/token/StandardToken.sol
141 
142 /**
143  * @title Standard Token
144  *
145  * @dev The standard abstract implementation of the ERC20 interface.
146  */
147 contract StandardToken is ERC20Token {
148     using SafeMath for uint256;
149 
150     string public name;
151     string public symbol;
152     uint8 public decimals;
153 
154     mapping (address => uint256) balances;
155     mapping (address => mapping (address => uint256)) internal allowed;
156 
157     /**
158      * @dev The constructor assigns the token name, symbols and decimals.
159      */
160     constructor(string _name, string _symbol, uint8 _decimals) internal {
161         name = _name;
162         symbol = _symbol;
163         decimals = _decimals;
164     }
165 
166     /**
167      * @dev Get the balance of an address.
168      *
169      * @param _address The address which's balance will be checked.
170      *
171      * @return The current balance of the address.
172      */
173     function balanceOf(address _address) public view returns (uint256 balance) {
174         return balances[_address];
175     }
176 
177     /**
178      * @dev Checks the amount of tokens that an owner allowed to a spender.
179      *
180      * @param _owner The address which owns the funds allowed for spending by a third-party.
181      * @param _spender The third-party address that is allowed to spend the tokens.
182      *
183      * @return The number of tokens available to `_spender` to be spent.
184      */
185     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
186         return allowed[_owner][_spender];
187     }
188 
189     /**
190      * @dev Give permission to `_spender` to spend `_value` number of tokens on your behalf.
191      * E.g. You place a buy or sell order on an exchange and in that example, the 
192      * `_spender` address is the address of the contract the exchange created to add your token to their 
193      * website and you are `msg.sender`.
194      *
195      * @param _spender The address which will spend the funds.
196      * @param _value The amount of tokens to be spent.
197      *
198      * @return Whether the approval process was successful or not.
199      */
200     function approve(address _spender, uint256 _value) public returns (bool) {
201         allowed[msg.sender][_spender] = _value;
202 
203         emit Approval(msg.sender, _spender, _value);
204 
205         return true;
206     }
207 
208     /**
209      * @dev Transfers `_value` number of tokens to the `_to` address.
210      *
211      * @param _to The address of the recipient.
212      * @param _value The number of tokens to be transferred.
213      */
214     function transfer(address _to, uint256 _value) public returns (bool) {
215         executeTransfer(msg.sender, _to, _value);
216 
217         return true;
218     }
219 
220     /**
221      * @dev Allows another contract to spend tokens on behalf of the `_from` address and send them to the `_to` address.
222      *
223      * @param _from The address which approved you to spend tokens on their behalf.
224      * @param _to The address where you want to send tokens.
225      * @param _value The number of tokens to be sent.
226      *
227      * @return Whether the transfer was successful or not.
228      */
229     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
230         require(_value <= allowed[_from][msg.sender], "Insufficient allowance");
231 
232         allowed[_from][msg.sender] = allowed[_from][msg.sender].minus(_value);
233         executeTransfer(_from, _to, _value);
234 
235         return true;
236     }
237 
238     /**
239      * @dev Internal function that this reused by the transfer functions
240      */
241     function executeTransfer(address _from, address _to, uint256 _value) internal {
242         require(_to != address(0), "Invalid transfer to address zero");
243         require(_value <= balances[_from], "Insufficient account balance");
244 
245         balances[_from] = balances[_from].minus(_value);
246         balances[_to] = balances[_to].plus(_value);
247 
248         emit Transfer(_from, _to, _value);
249     }
250 }
251 
252 // File: contracts/token/MintableToken.sol
253 
254 /**
255  * @title Mintable Token
256  *
257  * @dev Allows the creation of new tokens.
258  */
259 contract MintableToken is StandardToken {
260     /// @dev The only address allowed to mint coins
261     address public minter;
262 
263     /// @dev Indicates whether the token is still mintable.
264     bool public mintingDisabled = false;
265 
266     /**
267      * @dev Event fired when minting is no longer allowed.
268      */
269     event MintingDisabled();
270 
271     /**
272      * @dev Allows a function to be executed only if minting is still allowed.
273      */
274     modifier canMint() {
275         require(!mintingDisabled, "Minting is disabled");
276         _;
277     }
278 
279     /**
280      * @dev Allows a function to be called only by the minter
281      */
282     modifier onlyMinter() {
283         require(msg.sender == minter, "Only the minter address can mint");
284         _;
285     }
286 
287     /**
288      * @dev The constructor assigns the minter which is allowed to mind and disable minting
289      */
290     constructor(address _minter) internal {
291         minter = _minter;
292     }
293 
294     /**
295     * @dev Creates new `_value` number of tokens and sends them to the `_to` address.
296     *
297     * @param _to The address which will receive the freshly minted tokens.
298     * @param _value The number of tokens that will be created.
299     */
300     function mint(address _to, uint256 _value) public onlyMinter canMint {
301         totalSupply = totalSupply.plus(_value);
302         balances[_to] = balances[_to].plus(_value);
303 
304         emit Transfer(0x0, _to, _value);
305     }
306 
307     /**
308     * @dev Disable the minting of new tokens. Cannot be reversed.
309     *
310     * @return Whether or not the process was successful.
311     */
312     function disableMinting() public onlyMinter canMint {
313         mintingDisabled = true;
314        
315         emit MintingDisabled();
316     }
317 }
318 
319 // File: contracts/trait/HasOwner.sol
320 
321 /**
322  * @title HasOwner
323  *
324  * @dev Allows for exclusive access to certain functionality.
325  */
326 contract HasOwner {
327     // The current owner.
328     address public owner;
329 
330     // Conditionally the new owner.
331     address public newOwner;
332 
333     /**
334      * @dev The constructor.
335      *
336      * @param _owner The address of the owner.
337      */
338     constructor(address _owner) public {
339         owner = _owner;
340     }
341 
342     /** 
343      * @dev Access control modifier that allows only the current owner to call the function.
344      */
345     modifier onlyOwner {
346         require(msg.sender == owner, "Only owner can call this function");
347         _;
348     }
349 
350     /**
351      * @dev The event is fired when the current owner is changed.
352      *
353      * @param _oldOwner The address of the previous owner.
354      * @param _newOwner The address of the new owner.
355      */
356     event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);
357 
358     /**
359      * @dev Transfering the ownership is a two-step process, as we prepare
360      * for the transfer by setting `newOwner` and requiring `newOwner` to accept
361      * the transfer. This prevents accidental lock-out if something goes wrong
362      * when passing the `newOwner` address.
363      *
364      * @param _newOwner The address of the proposed new owner.
365      */
366     function transferOwnership(address _newOwner) public onlyOwner {
367         newOwner = _newOwner;
368     }
369  
370     /**
371      * @dev The `newOwner` finishes the ownership transfer process by accepting the
372      * ownership.
373      */
374     function acceptOwnership() public {
375         require(msg.sender == newOwner, "Only the newOwner can accept ownership");
376 
377         emit OwnershipTransfer(owner, newOwner);
378 
379         owner = newOwner;
380     }
381 }
382 
383 // File: contracts/fundraiser/AbstractFundraiser.sol
384 
385 contract AbstractFundraiser {
386     /// The ERC20 token contract.
387     ERC20Token public token;
388 
389     /**
390      * @dev The event fires every time a new buyer enters the fundraiser.
391      *
392      * @param _address The address of the buyer.
393      * @param _ethers The number of ethers funded.
394      * @param _tokens The number of tokens purchased.
395      */
396     event FundsReceived(address indexed _address, uint _ethers, uint _tokens);
397 
398 
399     /**
400      * @dev The initialization method for the token
401      *
402      * @param _token The address of the token of the fundraiser
403      */
404     function initializeFundraiserToken(address _token) internal
405     {
406         token = ERC20Token(_token);
407     }
408 
409     /**
410      * @dev The default function which is executed when someone sends funds to this contract address.
411      */
412     function() public payable {
413         receiveFunds(msg.sender, msg.value);
414     }
415 
416     /**
417      * @dev this overridable function returns the current conversion rate for the fundraiser
418      */
419     function getConversionRate() public view returns (uint256);
420 
421     /**
422      * @dev checks whether the fundraiser passed `endTime`.
423      *
424      * @return whether the fundraiser has ended.
425      */
426     function hasEnded() public view returns (bool);
427 
428     /**
429      * @dev Create and sends tokens to `_address` considering amount funded and `conversionRate`.
430      *
431      * @param _address The address of the receiver of tokens.
432      * @param _amount The amount of received funds in ether.
433      */
434     function receiveFunds(address _address, uint256 _amount) internal;
435     
436     /**
437      * @dev It throws an exception if the transaction does not meet the preconditions.
438      */
439     function validateTransaction() internal view;
440     
441     /**
442      * @dev this overridable function makes and handles tokens to buyers
443      */
444     function handleTokens(address _address, uint256 _tokens) internal;
445 
446     /**
447      * @dev this overridable function forwards the funds (if necessary) to a vault or directly to the beneficiary
448      */
449     function handleFunds(address _address, uint256 _ethers) internal;
450 
451 }
452 
453 // File: contracts/fundraiser/BasicFundraiser.sol
454 
455 /**
456  * @title Basic Fundraiser
457  *
458  * @dev An abstract contract that is a base for fundraisers. 
459  * It implements a generic procedure for handling received funds:
460  * 1. Validates the transaction preconditions
461  * 2. Calculates the amount of tokens based on the conversion rate.
462  * 3. Delegate the handling of the tokens (mint, transfer or create)
463  * 4. Delegate the handling of the funds
464  * 5. Emit event for received funds
465  */
466 contract BasicFundraiser is HasOwner, AbstractFundraiser {
467     using SafeMath for uint256;
468 
469     // The number of decimals for the token.
470     uint8 constant DECIMALS = 18;  // Enforced
471 
472     // Decimal factor for multiplication purposes.
473     uint256 constant DECIMALS_FACTOR = 10 ** uint256(DECIMALS);
474 
475     // The start time of the fundraiser - Unix timestamp.
476     uint256 public startTime;
477 
478     // The end time of the fundraiser - Unix timestamp.
479     uint256 public endTime;
480 
481     // The address where funds collected will be sent.
482     address public beneficiary;
483 
484     // The conversion rate with decimals difference adjustment,
485     // When converion rate is lower than 1 (inversed), the function calculateTokens() should use division
486     uint256 public conversionRate;
487 
488     // The total amount of ether raised.
489     uint256 public totalRaised;
490 
491     /**
492      * @dev The event fires when the number of token conversion rate has changed.
493      *
494      * @param _conversionRate The new number of tokens per 1 ether.
495      */
496     event ConversionRateChanged(uint _conversionRate);
497 
498     /**
499      * @dev The basic fundraiser initialization method.
500      *
501      * @param _startTime The start time of the fundraiser - Unix timestamp.
502      * @param _endTime The end time of the fundraiser - Unix timestamp.
503      * @param _conversionRate The number of tokens create for 1 ETH funded.
504      * @param _beneficiary The address which will receive the funds gathered by the fundraiser.
505      */
506     function initializeBasicFundraiser(
507         uint256 _startTime,
508         uint256 _endTime,
509         uint256 _conversionRate,
510         address _beneficiary
511     )
512         internal
513     {
514         require(_endTime >= _startTime, "Fundraiser's end is before its start");
515         require(_conversionRate > 0, "Conversion rate is not set");
516         require(_beneficiary != address(0), "The beneficiary is not set");
517 
518         startTime = _startTime;
519         endTime = _endTime;
520         conversionRate = _conversionRate;
521         beneficiary = _beneficiary;
522     }
523 
524     /**
525      * @dev Sets the new conversion rate
526      *
527      * @param _conversionRate New conversion rate
528      */
529     function setConversionRate(uint256 _conversionRate) public onlyOwner {
530         require(_conversionRate > 0, "Conversion rate is not set");
531 
532         conversionRate = _conversionRate;
533 
534         emit ConversionRateChanged(_conversionRate);
535     }
536 
537     /**
538      * @dev Sets The beneficiary of the fundraiser.
539      *
540      * @param _beneficiary The address of the beneficiary.
541      */
542     function setBeneficiary(address _beneficiary) public onlyOwner {
543         require(_beneficiary != address(0), "The beneficiary is not set");
544 
545         beneficiary = _beneficiary;
546     }
547 
548     /**
549      * @dev Create and sends tokens to `_address` considering amount funded and `conversionRate`.
550      *
551      * @param _address The address of the receiver of tokens.
552      * @param _amount The amount of received funds in ether.
553      */
554     function receiveFunds(address _address, uint256 _amount) internal {
555         validateTransaction();
556 
557         uint256 tokens = calculateTokens(_amount);
558         require(tokens > 0, "The transaction results in zero tokens");
559 
560         totalRaised = totalRaised.plus(_amount);
561         handleTokens(_address, tokens);
562         handleFunds(_address, _amount);
563 
564         emit FundsReceived(_address, msg.value, tokens);
565     }
566 
567     /**
568      * @dev this overridable function returns the current conversion rate multiplied by the conversion rate factor
569      */
570     function getConversionRate() public view returns (uint256) {
571         return conversionRate;
572     }
573 
574     /**
575      * @dev this overridable function that calculates the tokens based on the ether amount
576      */
577     function calculateTokens(uint256 _amount) internal view returns(uint256 tokens) {
578         tokens = _amount.mul(getConversionRate());
579     }
580 
581     /**
582      * @dev It throws an exception if the transaction does not meet the preconditions.
583      */
584     function validateTransaction() internal view {
585         require(msg.value != 0, "Transaction value is zero");
586         require(now >= startTime && now < endTime, "The fundraiser is not active");
587     }
588 
589     /**
590      * @dev checks whether the fundraiser passed `endtime`.
591      *
592      * @return whether the fundraiser is passed its deadline or not.
593      */
594     function hasEnded() public view returns (bool) {
595         return now >= endTime;
596     }
597 }
598 
599 // File: contracts/token/StandardMintableToken.sol
600 
601 contract StandardMintableToken is MintableToken {
602     constructor(address _minter, string _name, string _symbol, uint8 _decimals)
603         StandardToken(_name, _symbol, _decimals)
604         MintableToken(_minter)
605         public
606     {
607     }
608 }
609 
610 // File: contracts/fundraiser/MintableTokenFundraiser.sol
611 
612 /**
613  * @title Fundraiser With Mintable Token
614  */
615 contract MintableTokenFundraiser is BasicFundraiser {
616     /**
617      * @dev The initialization method that creates a new mintable token.
618      *
619      * @param _name Token name
620      * @param _symbol Token symbol
621      * @param _decimals Token decimals
622      */
623     function initializeMintableTokenFundraiser(string _name, string _symbol, uint8 _decimals) internal {
624         token = new StandardMintableToken(
625             address(this), // The fundraiser is the token minter
626             _name,
627             _symbol,
628             _decimals
629         );
630     }
631 
632     /**
633      * @dev Mint the specific amount tokens
634      */
635     function handleTokens(address _address, uint256 _tokens) internal {
636         MintableToken(token).mint(_address, _tokens);
637     }
638 }
639 
640 // File: contracts/fundraiser/IndividualCapsFundraiser.sol
641 
642 /**
643  * @title Fundraiser with individual caps
644  *
645  * @dev Allows you to set a hard cap on your fundraiser.
646  */
647 contract IndividualCapsFundraiser is BasicFundraiser {
648     uint256 public individualMinCap;
649     uint256 public individualMaxCap;
650     uint256 public individualMaxCapTokens;
651 
652 
653     event IndividualMinCapChanged(uint256 _individualMinCap);
654     event IndividualMaxCapTokensChanged(uint256 _individualMaxCapTokens);
655 
656     /**
657      * @dev The initialization method.
658      *
659      * @param _individualMinCap The minimum amount of ether contribution per address.
660      * @param _individualMaxCap The maximum amount of ether contribution per address.
661      */
662     function initializeIndividualCapsFundraiser(uint256 _individualMinCap, uint256 _individualMaxCap) internal {
663         individualMinCap = _individualMinCap;
664         individualMaxCap = _individualMaxCap;
665         individualMaxCapTokens = _individualMaxCap * conversionRate;
666     }
667 
668     function setConversionRate(uint256 _conversionRate) public onlyOwner {
669         super.setConversionRate(_conversionRate);
670 
671         if (individualMaxCap == 0) {
672             return;
673         }
674         
675         individualMaxCapTokens = individualMaxCap * _conversionRate;
676 
677         emit IndividualMaxCapTokensChanged(individualMaxCapTokens);
678     }
679 
680     function setIndividualMinCap(uint256 _individualMinCap) public onlyOwner {
681         individualMinCap = _individualMinCap;
682 
683         emit IndividualMinCapChanged(individualMinCap);
684     }
685 
686     function setIndividualMaxCap(uint256 _individualMaxCap) public onlyOwner {
687         individualMaxCap = _individualMaxCap;
688         individualMaxCapTokens = _individualMaxCap * conversionRate;
689 
690         emit IndividualMaxCapTokensChanged(individualMaxCapTokens);
691     }
692 
693     /**
694      * @dev Extends the transaction validation to check if the value is higher than the minimum cap.
695      */
696     function validateTransaction() internal view {
697         super.validateTransaction();
698         require(
699             msg.value >= individualMinCap,
700             "The transaction value does not pass the minimum contribution cap"
701         );
702     }
703 
704     /**
705      * @dev We validate the new amount doesn't surpass maximum contribution cap
706      */
707     function handleTokens(address _address, uint256 _tokens) internal {
708         require(
709             individualMaxCapTokens == 0 || token.balanceOf(_address).plus(_tokens) <= individualMaxCapTokens,
710             "The transaction exceeds the individual maximum cap"
711         );
712 
713         super.handleTokens(_address, _tokens);
714     }
715 }
716 
717 // File: contracts/fundraiser/GasPriceLimitFundraiser.sol
718 
719 /**
720  * @title GasPriceLimitFundraiser
721  *
722  * @dev This fundraiser allows to set gas price limit for the participants in the fundraiser
723  */
724 contract GasPriceLimitFundraiser is HasOwner, BasicFundraiser {
725     uint256 public gasPriceLimit;
726 
727     event GasPriceLimitChanged(uint256 gasPriceLimit);
728 
729     /**
730      * @dev This function puts the initial gas limit
731      */
732     function initializeGasPriceLimitFundraiser(uint256 _gasPriceLimit) internal {
733         gasPriceLimit = _gasPriceLimit;
734     }
735 
736     /**
737      * @dev This function allows the owner to change the gas limit any time during the fundraiser
738      */
739     function changeGasPriceLimit(uint256 _gasPriceLimit) public onlyOwner {
740         gasPriceLimit = _gasPriceLimit;
741 
742         emit GasPriceLimitChanged(_gasPriceLimit);
743     }
744 
745     /**
746      * @dev The transaction is valid if the gas price limit is lifted-off or the transaction meets the requirement
747      */
748     function validateTransaction() internal view {
749         require(gasPriceLimit == 0 || tx.gasprice <= gasPriceLimit, "Transaction exceeds the gas price limit");
750 
751         return super.validateTransaction();
752     }
753 }
754 
755 // File: contracts/fundraiser/ForwardFundsFundraiser.sol
756 
757 /**
758  * @title Forward Funds to Beneficiary Fundraiser
759  *
760  * @dev This contract forwards the funds received to the beneficiary.
761  */
762 contract ForwardFundsFundraiser is BasicFundraiser {
763     /**
764      * @dev Forward funds directly to beneficiary
765      */
766     function handleFunds(address, uint256 _ethers) internal {
767         // Forward the funds directly to the beneficiary
768         beneficiary.transfer(_ethers);
769     }
770 }
771 
772 // File: contracts/fundraiser/PresaleFundraiser.sol
773 
774 /**
775  * @title PresaleFundraiser
776  *
777  * @dev This is the standard fundraiser contract which allows
778  * you to raise ETH in exchange for your tokens.
779  */
780 contract PresaleFundraiser is MintableTokenFundraiser {
781     /// @dev The token hard cap for the pre-sale
782     uint256 public presaleSupply;
783 
784     /// @dev The token hard cap for the pre-sale
785     uint256 public presaleMaxSupply;
786 
787     /// @dev The start time of the pre-sale (Unix timestamp).
788     uint256 public presaleStartTime;
789 
790     /// @dev The end time of the pre-sale (Unix timestamp).
791     uint256 public presaleEndTime;
792 
793     /// @dev The conversion rate for the pre-sale
794     uint256 public presaleConversionRate;
795 
796     /**
797      * @dev The initialization method.
798      *
799      * @param _startTime The timestamp of the moment when the pre-sale starts
800      * @param _endTime The timestamp of the moment when the pre-sale ends
801      * @param _conversionRate The conversion rate during the pre-sale
802      */
803     function initializePresaleFundraiser(
804         uint256 _presaleMaxSupply,
805         uint256 _startTime,
806         uint256 _endTime,
807         uint256 _conversionRate
808     )
809         internal
810     {
811         require(_endTime >= _startTime, "Pre-sale's end is before its start");
812         require(_conversionRate > 0, "Conversion rate is not set");
813 
814         presaleMaxSupply = _presaleMaxSupply;
815         presaleStartTime = _startTime;
816         presaleEndTime = _endTime;
817         presaleConversionRate = _conversionRate;
818     }
819 
820     /**
821      * @dev Internal funciton that helps to check if the pre-sale is active
822      */
823     
824     function isPresaleActive() internal view returns (bool) {
825         return now < presaleEndTime && now >= presaleStartTime;
826     }
827     /**
828      * @dev this function different conversion rate while in presale
829      */
830     function getConversionRate() public view returns (uint256) {
831         if (isPresaleActive()) {
832             return presaleConversionRate;
833         }
834         return super.getConversionRate();
835     }
836 
837     /**
838      * @dev It throws an exception if the transaction does not meet the preconditions.
839      */
840     function validateTransaction() internal view {
841         require(msg.value != 0, "Transaction value is zero");
842         require(
843             now >= startTime && now < endTime || isPresaleActive(),
844             "Neither the pre-sale nor the fundraiser are currently active"
845         );
846     }
847 
848     function handleTokens(address _address, uint256 _tokens) internal {
849         if (isPresaleActive()) {
850             presaleSupply = presaleSupply.plus(_tokens);
851             require(
852                 presaleSupply <= presaleMaxSupply,
853                 "Transaction exceeds the pre-sale maximum token supply"
854             );
855         }
856 
857         super.handleTokens(_address, _tokens);
858     }
859 
860 }
861 
862 // File: contracts/fundraiser/TieredFundraiser.sol
863 
864 /**
865  * @title TieredFundraiser
866  *
867  * @dev A fundraiser that improves the base conversion precision to allow percent bonuses
868  */
869 
870 contract TieredFundraiser is BasicFundraiser {
871     // Conversion rate factor for better precision.
872     uint256 constant CONVERSION_RATE_FACTOR = 100;
873 
874     /**
875       * @dev Define conversion rates based on the tier start and end date
876       */
877     function getConversionRate() public view returns (uint256) {
878         return super.getConversionRate().mul(CONVERSION_RATE_FACTOR);
879     }
880 
881     /**
882      * @dev this overridable function that calculates the tokens based on the ether amount
883      */
884     function calculateTokens(uint256 _amount) internal view returns(uint256 tokens) {
885         return super.calculateTokens(_amount).div(CONVERSION_RATE_FACTOR);
886     }
887 
888     /**
889      * @dev this overridable function returns the current conversion rate factor
890      */
891     function getConversionRateFactor() public pure returns (uint256) {
892         return CONVERSION_RATE_FACTOR;
893     }
894 }
895 
896 // File: contracts/Fundraiser.sol
897 
898 /**
899  * @title TIMEToken
900  */
901 
902 contract TIMEToken is MintableToken {
903     constructor(address _minter)
904         StandardToken(
905             "TIME",   // Token name
906             "TM", // Token symbol
907             18  // Token decimals
908         )
909         
910         MintableToken(_minter)
911         public
912     {
913     }
914 }
915 
916 
917 
918 /**
919  * @title TIMETokenSafe
920  */
921 
922 contract TIMETokenSafe is TokenSafe {
923   constructor(address _token)
924     TokenSafe(_token)
925     public
926   {
927     
928     // Group "Core Team Members Safe"
929     init(
930       1, // Group Id
931       1555049100 // Release date = 2019-04-12 06:05 UTC
932     );
933     add(
934       1, // Group Id
935       0x892f34F709Dd7090e6E2BeC8220E88CbdF57ed7B,  // Token Safe Entry Address
936       4375000000000000000000000  // Allocated tokens
937     );
938   }
939 }
940 
941 
942 
943 /**
944  * @title TIMETokenFundraiser
945  */
946 
947 contract TIMETokenFundraiser is MintableTokenFundraiser, PresaleFundraiser, IndividualCapsFundraiser, ForwardFundsFundraiser, TieredFundraiser, GasPriceLimitFundraiser {
948     TIMETokenSafe public tokenSafe;
949 
950     constructor()
951         HasOwner(msg.sender)
952         public
953     {
954         token = new TIMEToken(
955         
956         address(this)  // The fundraiser is the minter
957         );
958 
959         tokenSafe = new TIMETokenSafe(token);
960         MintableToken(token).mint(address(tokenSafe), 4375000000000000000000000);
961 
962         initializeBasicFundraiser(
963             1555048920, // Start date = 2019-04-12 06:02 UTC
964             1893391380,  // End date = 2029-12-31 06:03 UTC
965             1, // Conversion rate = 1 TM per 1 ether
966             0xaC4F9BE57419Aed5e71739Cd22a0cf2da4c90Fe4     // Beneficiary
967         );
968 
969         initializeIndividualCapsFundraiser(
970             (0 ether), // Minimum contribution
971             (0 ether)  // Maximum individual cap
972         );
973 
974         initializeGasPriceLimitFundraiser(
975             3000000000000000 // Gas price limit in wei
976         );
977 
978         initializePresaleFundraiser(
979             12500000000000000000000000,
980             1555048800, // Start = 2019-04-12 06:00 UTC
981             1555048860,   // End = 2019-04-12 06:01 UTC
982             1
983         );
984 
985         
986 
987         
988 
989         
990     }
991     
992     /**
993       * @dev Define conversion rates based on the tier start and end date
994       */
995     function getConversionRate() public view returns (uint256) {
996         uint256 rate = super.getConversionRate();
997         if (now >= 1555049040 && now < 1555049100)
998             return rate.mul(105).div(100);
999         
1000 
1001         return rate;
1002     }
1003 
1004     /**
1005       * @dev Fundraiser with mintable token allows the owner to mint through the Fundraiser contract
1006       */
1007     function mint(address _to, uint256 _value) public onlyOwner {
1008         MintableToken(token).mint(_to, _value);
1009     }
1010 
1011     /**
1012       * @dev Irreversibly disable minting
1013       */
1014     function disableMinting() public onlyOwner {
1015         MintableToken(token).disableMinting();
1016     }
1017     
1018 }