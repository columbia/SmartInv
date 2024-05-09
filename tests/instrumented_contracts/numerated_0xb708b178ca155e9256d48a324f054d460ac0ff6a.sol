1 pragma solidity ^0.4.21;
2 
3 // Secvault.io 
4 
5 // File: contracts/library/SafeMath.sol
6 
7 /**
8  * @title Safe Math
9  *
10  * @dev Library for safe mathematical operations.
11  */
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a * b;
15         assert(a == 0 || c / a == b);
16 
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a / b;
22 
23         return c;
24     }
25 
26     function minus(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28 
29         return a - b;
30     }
31 
32     function plus(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35 
36         return c;
37     }
38 }
39 
40 // File: contracts/token/ERC20Token.sol
41 
42 /**
43  * @dev The standard ERC20 Token contract base.
44  */
45 contract ERC20Token {
46     uint256 public totalSupply;  /* shorthand for public function and a property */
47     
48     function balanceOf(address _owner) public view returns (uint256 balance);
49     function transfer(address _to, uint256 _value) public returns (bool success);
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
51     function approve(address _spender, uint256 _value) public returns (bool success);
52     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56 }
57 
58 // File: contracts/component/TokenSafe.sol
59 
60 /**
61  * @title TokenSafe
62  *
63  * @dev Abstract contract that serves as a base for the token safes. It is a multi-group token safe, where each group
64  *      has it's own release time and multiple accounts with locked tokens.
65  */
66 contract TokenSafe {
67     using SafeMath for uint;
68 
69     // The ERC20 token contract.
70     ERC20Token token;
71 
72     struct Group {
73         // The release date for the locked tokens
74         // Note: Unix timestamp fits in uint32, however block.timestamp is uint256
75         uint256 releaseTimestamp;
76         // The total remaining tokens in the group.
77         uint256 remaining;
78         // The individual account token balances in the group.
79         mapping (address => uint) balances;
80     }
81 
82     // The groups of locked tokens
83     mapping (uint8 => Group) public groups;
84 
85     /**
86      * @dev The constructor.
87      *
88      * @param _token The address of the Fabric Token (fundraiser) contract.
89      */
90     constructor(address _token) public {
91         token = ERC20Token(_token);
92     }
93 
94     /**
95      * @dev The function initializes a group with a release date.
96      *
97      * @param _id Group identifying number.
98      * @param _releaseTimestamp Unix timestamp of the time after which the tokens can be released
99      */
100     function init(uint8 _id, uint _releaseTimestamp) internal {
101         require(_releaseTimestamp > 0);
102         
103         Group storage group = groups[_id];
104         group.releaseTimestamp = _releaseTimestamp;
105     }
106 
107     /**
108      * @dev Add new account with locked token balance to the specified group id.
109      *
110      * @param _id Group identifying number.
111      * @param _account The address of the account to be added.
112      * @param _balance The number of tokens to be locked.
113      */
114     function add(uint8 _id, address _account, uint _balance) internal {
115         Group storage group = groups[_id];
116         group.balances[_account] = group.balances[_account].plus(_balance);
117         group.remaining = group.remaining.plus(_balance);
118     }
119 
120     /**
121      * @dev Allows an account to be released if it meets the time constraints of the group.
122      *
123      * @param _id Group identifying number.
124      * @param _account The address of the account to be released.
125      */
126     function release(uint8 _id, address _account) public {
127         Group storage group = groups[_id];
128         require(now >= group.releaseTimestamp);
129         
130         uint tokens = group.balances[_account];
131         require(tokens > 0);
132         
133         group.balances[_account] = 0;
134         group.remaining = group.remaining.minus(tokens);
135         
136         if (!token.transfer(_account, tokens)) {
137             revert();
138         }
139     }
140 }
141 
142 // File: contracts/token/StandardToken.sol
143 
144 /**
145  * @title Standard Token
146  *
147  * @dev The standard abstract implementation of the ERC20 interface.
148  */
149 contract StandardToken is ERC20Token {
150     using SafeMath for uint256;
151 
152     string public name;
153     string public symbol;
154     uint8 public decimals;
155     
156     mapping (address => uint256) balances;
157     mapping (address => mapping (address => uint256)) internal allowed;
158     
159     /**
160      * @dev The constructor assigns the token name, symbols and decimals.
161      */
162     constructor(string _name, string _symbol, uint8 _decimals) internal {
163         name = _name;
164         symbol = _symbol;
165         decimals = _decimals;
166     }
167 
168     /**
169      * @dev Get the balance of an address.
170      *
171      * @param _address The address which's balance will be checked.
172      *
173      * @return The current balance of the address.
174      */
175     function balanceOf(address _address) public view returns (uint256 balance) {
176         return balances[_address];
177     }
178 
179     /**
180      * @dev Checks the amount of tokens that an owner allowed to a spender.
181      *
182      * @param _owner The address which owns the funds allowed for spending by a third-party.
183      * @param _spender The third-party address that is allowed to spend the tokens.
184      *
185      * @return The number of tokens available to `_spender` to be spent.
186      */
187     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
188         return allowed[_owner][_spender];
189     }
190 
191     /**
192      * @dev Give permission to `_spender` to spend `_value` number of tokens on your behalf.
193      * E.g. You place a buy or sell order on an exchange and in that example, the 
194      * `_spender` address is the address of the contract the exchange created to add your token to their 
195      * website and you are `msg.sender`.
196      *
197      * @param _spender The address which will spend the funds.
198      * @param _value The amount of tokens to be spent.
199      *
200      * @return Whether the approval process was successful or not.
201      */
202     function approve(address _spender, uint256 _value) public returns (bool) {
203         allowed[msg.sender][_spender] = _value;
204 
205         emit Approval(msg.sender, _spender, _value);
206 
207         return true;
208     }
209 
210     /**
211      * @dev Transfers `_value` number of tokens to the `_to` address.
212      *
213      * @param _to The address of the recipient.
214      * @param _value The number of tokens to be transferred.
215      */
216     function transfer(address _to, uint256 _value) public returns (bool) {
217         executeTransfer(msg.sender, _to, _value);
218 
219         return true;
220     }
221 
222     /**
223      * @dev Allows another contract to spend tokens on behalf of the `_from` address and send them to the `_to` address.
224      *
225      * @param _from The address which approved you to spend tokens on their behalf.
226      * @param _to The address where you want to send tokens.
227      * @param _value The number of tokens to be sent.
228      *
229      * @return Whether the transfer was successful or not.
230      */
231     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
232         require(_value <= allowed[_from][msg.sender]);
233         
234         allowed[_from][msg.sender] = allowed[_from][msg.sender].minus(_value);
235         executeTransfer(_from, _to, _value);
236 
237         return true;
238     }
239 
240     /**
241      * @dev Internal function that this reused by the transfer functions
242      */
243     function executeTransfer(address _from, address _to, uint256 _value) internal {
244         require(_to != address(0));
245         require(_value != 0 && _value <= balances[_from]);
246         
247         balances[_from] = balances[_from].minus(_value);
248         balances[_to] = balances[_to].plus(_value);
249 
250         emit Transfer(_from, _to, _value);
251     }
252 }
253 
254 // File: contracts/token/MintableToken.sol
255 
256 /**
257  * @title Mintable Token
258  *
259  * @dev Allows the creation of new tokens.
260  */
261 contract MintableToken is StandardToken {
262     /// @dev The only address allowed to mint coins
263     address public minter;
264 
265     /// @dev Indicates whether the token is still mintable.
266     bool public mintingDisabled = false;
267 
268     /**
269      * @dev Event fired when minting is no longer allowed.
270      */
271     event MintingDisabled();
272 
273     /**
274      * @dev Allows a function to be executed only if minting is still allowed.
275      */
276     modifier canMint() {
277         require(!mintingDisabled);
278         _;
279     }
280 
281     /**
282      * @dev Allows a function to be called only by the minter
283      */
284     modifier onlyMinter() {
285         require(msg.sender == minter);
286         _;
287     }
288 
289     /**
290      * @dev The constructor assigns the minter which is allowed to mind and disable minting
291      */
292     constructor(address _minter) internal {
293         minter = _minter;
294     }
295 
296     /**
297     * @dev Creates new `_value` number of tokens and sends them to the `_to` address.
298     *
299     * @param _to The address which will receive the freshly minted tokens.
300     * @param _value The number of tokens that will be created.
301     */
302     function mint(address _to, uint256 _value) onlyMinter canMint public {
303         totalSupply = totalSupply.plus(_value);
304         balances[_to] = balances[_to].plus(_value);
305 
306         emit Transfer(0x0, _to, _value);
307     }
308 
309     /**
310     * @dev Disable the minting of new tokens. Cannot be reversed.
311     *
312     * @return Whether or not the process was successful.
313     */
314     function disableMinting() onlyMinter canMint public {
315         mintingDisabled = true;
316        
317         emit MintingDisabled();
318     }
319 }
320 
321 // File: contracts/trait/HasOwner.sol
322 
323 /**
324  * @title HasOwner
325  *
326  * @dev Allows for exclusive access to certain functionality.
327  */
328 contract HasOwner {
329     // The current owner.
330     address public owner;
331 
332     // Conditionally the new owner.
333     address public newOwner;
334 
335     /**
336      * @dev The constructor.
337      *
338      * @param _owner The address of the owner.
339      */
340     constructor(address _owner) public {
341         owner = _owner;
342     }
343 
344     /** 
345      * @dev Access control modifier that allows only the current owner to call the function.
346      */
347     modifier onlyOwner {
348         require(msg.sender == owner);
349         _;
350     }
351 
352     /**
353      * @dev The event is fired when the current owner is changed.
354      *
355      * @param _oldOwner The address of the previous owner.
356      * @param _newOwner The address of the new owner.
357      */
358     event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);
359 
360     /**
361      * @dev Transfering the ownership is a two-step process, as we prepare
362      * for the transfer by setting `newOwner` and requiring `newOwner` to accept
363      * the transfer. This prevents accidental lock-out if something goes wrong
364      * when passing the `newOwner` address.
365      *
366      * @param _newOwner The address of the proposed new owner.
367      */
368     function transferOwnership(address _newOwner) public onlyOwner {
369         newOwner = _newOwner;
370     }
371  
372     /**
373      * @dev The `newOwner` finishes the ownership transfer process by accepting the
374      * ownership.
375      */
376     function acceptOwnership() public {
377         require(msg.sender == newOwner);
378 
379         emit OwnershipTransfer(owner, newOwner);
380 
381         owner = newOwner;
382     }
383 }
384 
385 // File: contracts/fundraiser/AbstractFundraiser.sol
386 
387 contract AbstractFundraiser {
388     /// The ERC20 token contract.
389     ERC20Token public token;
390 
391     /**
392      * @dev The event fires every time a new buyer enters the fundraiser.
393      *
394      * @param _address The address of the buyer.
395      * @param _ethers The number of ethers funded.
396      * @param _tokens The number of tokens purchased.
397      */
398     event FundsReceived(address indexed _address, uint _ethers, uint _tokens);
399 
400 
401     /**
402      * @dev The initialization method for the token
403      *
404      * @param _token The address of the token of the fundraiser
405      */
406     function initializeFundraiserToken(address _token) internal
407     {
408         token = ERC20Token(_token);
409     }
410 
411     /**
412      * @dev The default function which is executed when someone sends funds to this contract address.
413      */
414     function() public payable {
415         receiveFunds(msg.sender, msg.value);
416     }
417 
418     /**
419      * @dev this overridable function returns the current conversion rate for the fundraiser
420      */
421     function getConversionRate() public view returns (uint256);
422 
423     /**
424      * @dev checks whether the fundraiser passed `endTime`.
425      *
426      * @return whether the fundraiser has ended.
427      */
428     function hasEnded() public view returns (bool);
429 
430     /**
431      * @dev Create and sends tokens to `_address` considering amount funded and `conversionRate`.
432      *
433      * @param _address The address of the receiver of tokens.
434      * @param _amount The amount of received funds in ether.
435      */
436     function receiveFunds(address _address, uint256 _amount) internal;
437     
438     /**
439      * @dev It throws an exception if the transaction does not meet the preconditions.
440      */
441     function validateTransaction() internal view;
442     
443     /**
444      * @dev this overridable function makes and handles tokens to buyers
445      */
446     function handleTokens(address _address, uint256 _tokens) internal;
447 
448     /**
449      * @dev this overridable function forwards the funds (if necessary) to a vault or directly to the beneficiary
450      */
451     function handleFunds(address _address, uint256 _ethers) internal;
452 
453 }
454 
455 // File: contracts/fundraiser/BasicFundraiser.sol
456 
457 /**
458  * @title Basic Fundraiser
459  *
460  * @dev An abstract contract that is a base for fundraisers. 
461  * It implements a generic procedure for handling received funds:
462  * 1. Validates the transaciton preconditions
463  * 2. Calculates the amount of tokens based on the conversion rate.
464  * 3. Delegate the handling of the tokens (mint, transfer or conjure)
465  * 4. Delegate the handling of the funds
466  * 5. Emit event for received funds
467  */
468 contract BasicFundraiser is HasOwner, AbstractFundraiser {
469     using SafeMath for uint256;
470 
471     // The number of decimals for the token.
472     uint8 constant DECIMALS = 18;  // Enforced
473 
474     // Decimal factor for multiplication purposes.
475     uint256 constant DECIMALS_FACTOR = 10 ** uint256(DECIMALS);
476 
477     // The start time of the fundraiser - Unix timestamp.
478     uint256 public startTime;
479 
480     // The end time of the fundraiser - Unix timestamp.
481     uint256 public endTime;
482 
483     // The address where funds collected will be sent.
484     address public beneficiary;
485 
486     // The conversion rate with decimals difference adjustment,
487     // When converion rate is lower than 1 (inversed), the function calculateTokens() should use division
488     uint256 public conversionRate;
489 
490     // The total amount of ether raised.
491     uint256 public totalRaised;
492 
493     /**
494      * @dev The event fires when the number of token conversion rate has changed.
495      *
496      * @param _conversionRate The new number of tokens per 1 ether.
497      */
498     event ConversionRateChanged(uint _conversionRate);
499 
500     /**
501      * @dev The basic fundraiser initialization method.
502      *
503      * @param _startTime The start time of the fundraiser - Unix timestamp.
504      * @param _endTime The end time of the fundraiser - Unix timestamp.
505      * @param _conversionRate The number of tokens create for 1 ETH funded.
506      * @param _beneficiary The address which will receive the funds gathered by the fundraiser.
507      */
508     function initializeBasicFundraiser(
509         uint256 _startTime,
510         uint256 _endTime,
511         uint256 _conversionRate,
512         address _beneficiary
513     )
514         internal
515     {
516         require(_endTime >= _startTime);
517         require(_conversionRate > 0);
518         require(_beneficiary != address(0));
519 
520         startTime = _startTime;
521         endTime = _endTime;
522         conversionRate = _conversionRate;
523         beneficiary = _beneficiary;
524     }
525 
526     /**
527      * @dev Sets the new conversion rate
528      *
529      * @param _conversionRate New conversion rate
530      */
531     function setConversionRate(uint256 _conversionRate) public onlyOwner {
532         require(_conversionRate > 0);
533 
534         conversionRate = _conversionRate;
535 
536         emit ConversionRateChanged(_conversionRate);
537     }
538 
539     /**
540      * @dev Sets The beneficiary of the fundraiser.
541      *
542      * @param _beneficiary The address of the beneficiary.
543      */
544     function setBeneficiary(address _beneficiary) public onlyOwner {
545         require(_beneficiary != address(0));
546 
547         beneficiary = _beneficiary;
548     }
549 
550     /**
551      * @dev Create and sends tokens to `_address` considering amount funded and `conversionRate`.
552      *
553      * @param _address The address of the receiver of tokens.
554      * @param _amount The amount of received funds in ether.
555      */
556     function receiveFunds(address _address, uint256 _amount) internal {
557         validateTransaction();
558 
559         uint256 tokens = calculateTokens(_amount);
560         require(tokens > 0);
561 
562         totalRaised = totalRaised.plus(_amount);
563         handleTokens(_address, tokens);
564         handleFunds(_address, _amount);
565 
566         emit FundsReceived(_address, msg.value, tokens);
567     }
568 
569     /**
570      * @dev this overridable function returns the current conversion rate multiplied by the conversion rate factor
571      */
572     function getConversionRate() public view returns (uint256) {
573         return conversionRate;
574     }
575 
576     /**
577      * @dev this overridable function that calculates the tokens based on the ether amount
578      */
579     function calculateTokens(uint256 _amount) internal view returns(uint256 tokens) {
580         tokens = _amount.mul(getConversionRate());
581     }
582 
583     /**
584      * @dev It throws an exception if the transaction does not meet the preconditions.
585      */
586     function validateTransaction() internal view {
587         require(msg.value != 0);
588         require(now >= startTime && now < endTime);
589     }
590 
591     /**
592      * @dev checks whether the fundraiser passed `endtime`.
593      *
594      * @return whether the fundraiser is passed its deadline or not.
595      */
596     function hasEnded() public view returns (bool) {
597         return now >= endTime;
598     }
599 }
600 
601 // File: contracts/token/StandardMintableToken.sol
602 
603 contract StandardMintableToken is MintableToken {
604     constructor(address _minter, string _name, string _symbol, uint8 _decimals)
605         StandardToken(_name, _symbol, _decimals)
606         MintableToken(_minter)
607         public
608     {
609     }
610 }
611 
612 // File: contracts/fundraiser/MintableTokenFundraiser.sol
613 
614 /**
615  * @title Fundraiser With Mintable Token
616  */
617 contract MintableTokenFundraiser is BasicFundraiser {
618     /**
619      * @dev The initialization method that creates a new mintable token.
620      *
621      * @param _name Token name
622      * @param _symbol Token symbol
623      * @param _decimals Token decimals
624      */
625     function initializeMintableTokenFundraiser(string _name, string _symbol, uint8 _decimals) internal {
626         token = new StandardMintableToken(
627             address(this), // The fundraiser is the token minter
628             _name,
629             _symbol,
630             _decimals
631         );
632     }
633 
634     /**
635      * @dev Mint the specific amount tokens
636      */
637     function handleTokens(address _address, uint256 _tokens) internal {
638         MintableToken(token).mint(_address, _tokens);
639     }
640 }
641 
642 // File: contracts/fundraiser/IndividualCapsFundraiser.sol
643 
644 /**
645  * @title Fundraiser with individual caps
646  *
647  * @dev Allows you to set a hard cap on your fundraiser.
648  */
649 contract IndividualCapsFundraiser is BasicFundraiser {
650     uint256 public individualMinCap;
651     uint256 public individualMaxCap;
652     uint256 public individualMaxCapTokens;
653 
654 
655     event IndividualMinCapChanged(uint256 _individualMinCap);
656     event IndividualMaxCapTokensChanged(uint256 _individualMaxCapTokens);
657 
658     /**
659      * @dev The initialization method.
660      *
661      * @param _individualMinCap The minimum amount of ether contribution per address.
662      * @param _individualMaxCap The maximum amount of ether contribution per address.
663      */
664     function initializeIndividualCapsFundraiser(uint256 _individualMinCap, uint256 _individualMaxCap) internal {
665         individualMinCap = _individualMinCap;
666         individualMaxCap = _individualMaxCap;
667         individualMaxCapTokens = _individualMaxCap * conversionRate;
668     }
669 
670     function setConversionRate(uint256 _conversionRate) public onlyOwner {
671         super.setConversionRate(_conversionRate);
672 
673         if (individualMaxCap == 0) {
674             return;
675         }
676         
677         individualMaxCapTokens = individualMaxCap * _conversionRate;
678 
679         emit IndividualMaxCapTokensChanged(individualMaxCapTokens);
680     }
681 
682     function setIndividualMinCap(uint256 _individualMinCap) public onlyOwner {
683         individualMinCap = _individualMinCap;
684 
685         emit IndividualMinCapChanged(individualMinCap);
686     }
687 
688     function setIndividualMaxCap(uint256 _individualMaxCap) public onlyOwner {
689         individualMaxCap = _individualMaxCap;
690         individualMaxCapTokens = _individualMaxCap * conversionRate;
691 
692         emit IndividualMaxCapTokensChanged(individualMaxCapTokens);
693     }
694 
695     /**
696      * @dev Extends the transaction validation to check if the value this higher than the minumum cap.
697      */
698     function validateTransaction() internal view {
699         super.validateTransaction();
700         require(msg.value >= individualMinCap);
701     }
702 
703     /**
704      * @dev We validate the new amount doesn't surpass maximum contribution cap
705      */
706     function handleTokens(address _address, uint256 _tokens) internal {
707         require(individualMaxCapTokens == 0 || token.balanceOf(_address).plus(_tokens) <= individualMaxCapTokens);
708 
709         super.handleTokens(_address, _tokens);
710     }
711 }
712 
713 // File: contracts/fundraiser/GasPriceLimitFundraiser.sol
714 
715 /**
716  * @title GasPriceLimitFundraiser
717  *
718  * @dev This fundraiser allows to set gas price limit for the participants in the fundraiser
719  */
720 contract GasPriceLimitFundraiser is HasOwner, BasicFundraiser {
721     uint256 public gasPriceLimit;
722 
723     event GasPriceLimitChanged(uint256 gasPriceLimit);
724 
725     /**
726      * @dev This function puts the initial gas limit
727      */
728     function initializeGasPriceLimitFundraiser(uint256 _gasPriceLimit) internal {
729         gasPriceLimit = _gasPriceLimit;
730     }
731 
732     /**
733      * @dev This function allows the owner to change the gas limit any time during the fundraiser
734      */
735     function changeGasPriceLimit(uint256 _gasPriceLimit) onlyOwner() public {
736         gasPriceLimit = _gasPriceLimit;
737 
738         emit GasPriceLimitChanged(_gasPriceLimit);
739     }
740 
741     /**
742      * @dev The transaction is valid if the gas price limit is lifted-off or the transaction meets the requirement
743      */
744     function validateTransaction() internal view {
745         require(gasPriceLimit == 0 || tx.gasprice <= gasPriceLimit);
746 
747         return super.validateTransaction();
748     }
749 }
750 
751 // File: contracts/fundraiser/CappedFundraiser.sol
752 
753 /**
754  * @title Capped Fundraiser
755  *
756  * @dev Allows you to set a hard cap on your fundraiser.
757  */
758 contract CappedFundraiser is BasicFundraiser {
759     /// The maximum amount of ether allowed for the fundraiser.
760     uint256 public hardCap;
761 
762     /**
763      * @dev The initialization method.
764      *
765      * @param _hardCap The maximum amount of ether allowed to be raised.
766      */
767     function initializeCappedFundraiser(uint256 _hardCap) internal {
768         require(_hardCap > 0);
769 
770         hardCap = _hardCap;
771     }
772 
773     /**
774      * @dev Adds additional check if the hard cap has been reached.
775      *
776      * @return Whether the token purchase will be allowed.
777      */
778     function validateTransaction() internal view {
779         super.validateTransaction();
780         require(totalRaised < hardCap);
781     }
782 
783     /**
784      * @dev Overrides the method from the default `Fundraiser` contract
785      * to additionally check if the `hardCap` is reached.
786      *
787      * @return Whether or not the fundraiser has ended.
788      */
789     function hasEnded() public view returns (bool) {
790         return (super.hasEnded() || totalRaised >= hardCap);
791     }
792 }
793 
794 // File: contracts/fundraiser/ForwardFundsFundraiser.sol
795 
796 /**
797  * @title Forward Funds to Beneficiary Fundraiser
798  *
799  * @dev This contract forwards the funds received to the beneficiary.
800  */
801 contract ForwardFundsFundraiser is BasicFundraiser {
802     /**
803      * @dev Forward funds directly to beneficiary
804      */
805     function handleFunds(address, uint256 _ethers) internal {
806         // Forward the funds directly to the beneficiary
807         beneficiary.transfer(_ethers);
808     }
809 }
810 
811 // File: contracts/fundraiser/PresaleFundraiser.sol
812 
813 /**
814  * @title PresaleFundraiser
815  *
816  * @dev This is the standard fundraiser contract which allows
817  * you to raise ETH in exchange for your tokens.
818  */
819 contract PresaleFundraiser is MintableTokenFundraiser {
820     /// @dev The token hard cap for the pre-sale
821     uint256 public presaleSupply;
822 
823     /// @dev The token hard cap for the pre-sale
824     uint256 public presaleMaxSupply;
825 
826     /// @dev The start time of the pre-sale (Unix timestamp).
827     uint256 public presaleStartTime;
828 
829     /// @dev The end time of the pre-sale (Unix timestamp).
830     uint256 public presaleEndTime;
831 
832     /// @dev The conversion rate for the pre-sale
833     uint256 public presaleConversionRate;
834 
835     /**
836      * @dev The initialization method.
837      *
838      * @param _startTime The timestamp of the moment when the pre-sale starts
839      * @param _endTime The timestamp of the moment when the pre-sale ends
840      * @param _conversionRate The conversion rate during the pre-sale
841      */
842     function initializePresaleFundraiser(
843         uint256 _presaleMaxSupply,
844         uint256 _startTime,
845         uint256 _endTime,
846         uint256 _conversionRate
847     )
848         internal
849     {
850         require(_endTime >= _startTime);
851         require(_conversionRate > 0);
852 
853         presaleMaxSupply = _presaleMaxSupply;
854         presaleStartTime = _startTime;
855         presaleEndTime = _endTime;
856         presaleConversionRate = _conversionRate;
857     }
858 
859     /**
860      * @dev Internal funciton that helps to check if the pre-sale is active
861      */
862     
863     function isPresaleActive() internal view returns (bool) {
864         return now < presaleEndTime && now >= presaleStartTime;
865     }
866     /**
867      * @dev this function different conversion rate while in presale
868      */
869     function getConversionRate() public view returns (uint256) {
870         if (isPresaleActive()) {
871             return presaleConversionRate;
872         }
873         return super.getConversionRate();
874     }
875 
876     /**
877      * @dev It throws an exception if the transaction does not meet the preconditions.
878      */
879     function validateTransaction() internal view {
880         require(msg.value != 0);
881         require(now >= startTime && now < endTime || isPresaleActive());
882     }
883 
884     function handleTokens(address _address, uint256 _tokens) internal {
885         if (isPresaleActive()) {
886             presaleSupply = presaleSupply.plus(_tokens);
887             require(presaleSupply <= presaleMaxSupply);
888         }
889 
890         super.handleTokens(_address, _tokens);
891     }
892 
893 }
894 
895 // File: contracts/Fundraiser.sol
896 
897 /**
898  * @title SecvaultToken
899  */
900 
901 contract SecvaultToken is MintableToken {
902     constructor(address _minter)
903         StandardToken(
904             "Secvault",   // Token name
905             "BPI", // Token symbol
906             18  // Token decimals
907         )
908         
909         MintableToken(_minter)
910         public
911     {
912     }
913 }
914 
915 
916 
917 /**
918  * @title SecvaultTokenSafe
919  */
920 
921 contract SecvaultTokenSafe is TokenSafe {
922   constructor(address _token)
923     TokenSafe(_token)
924     public
925   {
926     
927     // Group "Team + Advisors"
928     init(
929       1, // Group Id
930       1542261600 // Release date = 2018-11-15 06:00 UTC
931     );
932     add(
933       1, // Group Id
934       0xE95767DF573778366C3b8cE79DA89C692A384d63,  // Token Safe Entry Address
935       42000000000000000000000000  // Allocated tokens
936     );
937     
938     // Group "Bounty"
939     init(
940       2, // Group Id
941       1540141200 // Release date = 2018-10-21 17:00 UTC
942     );
943     add(
944       2, // Group Id
945       0x089B79da930C8210C825E2379518311ecD9d9f39,  // Token Safe Entry Address
946       24500000000000000000000000  // Allocated tokens
947     );
948     
949     // Group "Ecosystem & Partnership"
950     init(
951       3, // Group Id
952       1540141200 // Release date = 2018-10-21 17:00 UTC
953     );
954     add(
955       3, // Group Id
956       0x82c7DEf4F7eEA9a8FF6aD7ca72025f3E20C151D4,  // Token Safe Entry Address
957       129500000000000000000000000  // Allocated tokens
958     );
959   }
960 }
961 
962 
963 
964 /**
965  * @title SecvaultTokenFundraiser
966  */
967 
968 contract SecvaultTokenFundraiser is MintableTokenFundraiser, PresaleFundraiser, IndividualCapsFundraiser, CappedFundraiser, ForwardFundsFundraiser, GasPriceLimitFundraiser {
969     SecvaultTokenSafe public tokenSafe;
970 
971     constructor()
972         HasOwner(msg.sender)
973         public
974     {
975         token = new SecvaultToken(
976         
977         address(this)  // The fundraiser is the minter
978         );
979 
980         tokenSafe = new SecvaultTokenSafe(token);
981         MintableToken(token).mint(address(tokenSafe), 196000000000000000000000000);
982 
983         initializeBasicFundraiser(
984             1547100000, // Start date = 2019-01-10 06:00 UTC
985             1549821600,  // End date = 2019-02-10 18:00 UTC
986             600, // Conversion rate = 600 BPI per 1 ether
987             0xE95767DF573778366C3b8cE79DA89C692A384d63     // Beneficiary
988         );
989 
990         initializeIndividualCapsFundraiser(
991             (0.5 ether), // Minimum contribution
992             (0 ether)  // Maximum individual cap
993         );
994 
995         initializeGasPriceLimitFundraiser(
996             0 // Gas price limit in wei
997         );
998 
999         initializePresaleFundraiser(
1000             28000000000000000000000000,
1001             1540141200, // Start = 2018-10-21 17:00 UTC
1002             1543168800,   // End = 2018-11-25 18:00 UTC
1003             900
1004         );
1005 
1006         initializeCappedFundraiser(
1007             (280000 ether) // Hard cap
1008         );
1009 
1010         
1011 
1012         
1013     }
1014     
1015     
1016 }