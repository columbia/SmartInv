1 pragma solidity ^0.4.18;
2 
3 // File: contracts\configs\FabricTokenConfig.sol
4 
5 /**
6  * @title FabricTokenConfig
7  *
8  * @dev The static configuration for the Fabric Token.
9  */
10 contract FabricTokenConfig {
11     // The name of the token.
12     string constant NAME = "Fabric Token";
13 
14     // The symbol of the token.
15     string constant SYMBOL = "FT";
16 
17     // The number of decimals for the token.
18     uint8 constant DECIMALS = 18;  // Same as ethers.
19 
20     // Decimal factor for multiplication purposes.
21     uint constant DECIMALS_FACTOR = 10 ** uint(DECIMALS);
22 }
23 
24 // File: contracts\interfaces\ERC20TokenInterface.sol
25 
26 /**
27  * @dev The standard ERC20 Token interface.
28  */
29 contract ERC20TokenInterface {
30     uint public totalSupply;  /* shorthand for public function and a property */
31     event Transfer(address indexed _from, address indexed _to, uint _value);
32     event Approval(address indexed _owner, address indexed _spender, uint _value);
33     function balanceOf(address _owner) public constant returns (uint balance);
34     function transfer(address _to, uint _value) public returns (bool success);
35     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
36     function approve(address _spender, uint _value) public returns (bool success);
37     function allowance(address _owner, address _spender) public constant returns (uint remaining);
38 }
39 
40 // File: contracts\libraries\SafeMath.sol
41 
42 /**
43  * @dev Library that helps prevent integer overflows and underflows,
44  * inspired by https://github.com/OpenZeppelin/zeppelin-solidity
45  */
46 library SafeMath {
47     function plus(uint a, uint b) internal pure returns (uint) {
48         uint c = a + b;
49         assert(c >= a);
50 
51         return c;
52     }
53 
54     function minus(uint a, uint b) internal pure returns (uint) {
55         assert(b <= a);
56 
57         return a - b;
58     }
59 
60     function mul(uint a, uint b) internal pure returns (uint) {
61         uint c = a * b;
62         assert(a == 0 || c / a == b);
63         
64         return c;
65     }
66 
67     function div(uint a, uint b) internal pure returns (uint) {
68         uint c = a / b;
69 
70         return c;
71     }
72 }
73 
74 // File: contracts\traits\ERC20Token.sol
75 
76 /**
77  * @title ERC20Token
78  *
79  * @dev Implements the operations declared in the `ERC20TokenInterface`.
80  */
81 contract ERC20Token is ERC20TokenInterface {
82     using SafeMath for uint;
83 
84     // Token account balances.
85     mapping (address => uint) balances;
86 
87     // Delegated number of tokens to transfer.
88     mapping (address => mapping (address => uint)) allowed;
89 
90     /**
91      * @dev Checks the balance of a certain address.
92      *
93      * @param _account The address which's balance will be checked.
94      *
95      * @return Returns the balance of the `_account` address.
96      */
97     function balanceOf(address _account) public constant returns (uint balance) {
98         return balances[_account];
99     }
100 
101     /**
102      * @dev Transfers tokens from one address to another.
103      *
104      * @param _to The target address to which the `_value` number of tokens will be sent.
105      * @param _value The number of tokens to send.
106      *
107      * @return Whether the transfer was successful or not.
108      */
109     function transfer(address _to, uint _value) public returns (bool success) {
110         if (balances[msg.sender] < _value || _value == 0) {
111 
112             return false;
113         }
114 
115         balances[msg.sender] -= _value;
116         balances[_to] = balances[_to].plus(_value);
117 
118         Transfer(msg.sender, _to, _value);
119 
120         return true;
121     }
122 
123     /**
124      * @dev Send `_value` tokens to `_to` from `_from` if `_from` has approved the process.
125      *
126      * @param _from The address of the sender.
127      * @param _to The address of the recipient.
128      * @param _value The number of tokens to be transferred.
129      *
130      * @return Whether the transfer was successful or not.
131      */
132     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
133         if (balances[_from] < _value || allowed[_from][msg.sender] < _value || _value == 0) {
134             return false;
135         }
136 
137         balances[_to] = balances[_to].plus(_value);
138         balances[_from] -= _value;
139         allowed[_from][msg.sender] -= _value;
140 
141         Transfer(_from, _to, _value);
142 
143         return true;
144     }
145 
146     /**
147      * @dev Allows another contract to spend some tokens on your behalf.
148      *
149      * @param _spender The address of the account which will be approved for transfer of tokens.
150      * @param _value The number of tokens to be approved for transfer.
151      *
152      * @return Whether the approval was successful or not.
153      */
154     function approve(address _spender, uint _value) public returns (bool success) {
155         allowed[msg.sender][_spender] = _value;
156 
157         Approval(msg.sender, _spender, _value);
158 
159         return true;
160     }
161 
162     /**
163      * @dev Shows the number of tokens approved by `_owner` that are allowed to be transferred by `_spender`.
164      *
165      * @param _owner The account which allowed the transfer.
166      * @param _spender The account which will spend the tokens.
167      *
168      * @return The number of tokens to be transferred.
169      */
170     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
171         return allowed[_owner][_spender];
172     }    
173 }
174 
175 // File: contracts\traits\HasOwner.sol
176 
177 /**
178  * @title HasOwner
179  *
180  * @dev Allows for exclusive access to certain functionality.
181  */
182 contract HasOwner {
183     // Current owner.
184     address public owner;
185 
186     // Conditionally the new owner.
187     address public newOwner;
188 
189     /**
190      * @dev The constructor.
191      *
192      * @param _owner The address of the owner.
193      */
194     function HasOwner(address _owner) internal {
195         owner = _owner;
196     }
197 
198     /** 
199      * @dev Access control modifier that allows only the current owner to call the function.
200      */
201     modifier onlyOwner {
202         require(msg.sender == owner);
203         _;
204     }
205 
206     /**
207      * @dev The event is fired when the current owner is changed.
208      *
209      * @param _oldOwner The address of the previous owner.
210      * @param _newOwner The address of the new owner.
211      */
212     event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);
213 
214     /**
215      * @dev Transfering the ownership is a two-step process, as we prepare
216      * for the transfer by setting `newOwner` and requiring `newOwner` to accept
217      * the transfer. This prevents accidental lock-out if something goes wrong
218      * when passing the `newOwner` address.
219      *
220      * @param _newOwner The address of the proposed new owner.
221      */
222     function transferOwnership(address _newOwner) public onlyOwner {
223         newOwner = _newOwner;
224     }
225  
226     /**
227      * @dev The `newOwner` finishes the ownership transfer process by accepting the
228      * ownership.
229      */
230     function acceptOwnership() public {
231         require(msg.sender == newOwner);
232 
233         OwnershipTransfer(owner, newOwner);
234 
235         owner = newOwner;
236     }
237 }
238 
239 // File: contracts\traits\Freezable.sol
240 
241 /**
242  * @title Freezable
243  * @dev This trait allows to freeze the transactions in a Token
244  */
245 contract Freezable is HasOwner {
246   bool public frozen = false;
247 
248   /**
249    * @dev Modifier makes methods callable only when the contract is not frozen.
250    */
251   modifier requireNotFrozen() {
252     require(!frozen);
253     _;
254   }
255 
256   /**
257    * @dev Allows the owner to "freeze" the contract.
258    */
259   function freeze() onlyOwner public {
260     frozen = true;
261   }
262 
263   /**
264    * @dev Allows the owner to "unfreeze" the contract.
265    */
266   function unfreeze() onlyOwner public {
267     frozen = false;
268   }
269 }
270 
271 // File: contracts\traits\FreezableERC20Token.sol
272 
273 /**
274  * @title FreezableERC20Token
275  *
276  * @dev Extends ERC20Token and adds ability to freeze all transfers of tokens.
277  */
278 contract FreezableERC20Token is ERC20Token, Freezable {
279     /**
280      * @dev Overrides the original ERC20Token implementation by adding whenNotFrozen modifier.
281      *
282      * @param _to The target address to which the `_value` number of tokens will be sent.
283      * @param _value The number of tokens to send.
284      *
285      * @return Whether the transfer was successful or not.
286      */
287     function transfer(address _to, uint _value) public requireNotFrozen returns (bool success) {
288         return super.transfer(_to, _value);
289     }
290 
291     /**
292      * @dev Send `_value` tokens to `_to` from `_from` if `_from` has approved the process.
293      *
294      * @param _from The address of the sender.
295      * @param _to The address of the recipient.
296      * @param _value The number of tokens to be transferred.
297      *
298      * @return Whether the transfer was successful or not.
299      */
300     function transferFrom(address _from, address _to, uint _value) public requireNotFrozen returns (bool success) {
301         return super.transferFrom(_from, _to, _value);
302     }
303 
304     /**
305      * @dev Allows another contract to spend some tokens on your behalf.
306      *
307      * @param _spender The address of the account which will be approved for transfer of tokens.
308      * @param _value The number of tokens to be approved for transfer.
309      *
310      * @return Whether the approval was successful or not.
311      */
312     function approve(address _spender, uint _value) public requireNotFrozen returns (bool success) {
313         return super.approve(_spender, _value);
314     }
315 
316 }
317 
318 // File: contracts\FabricToken.sol
319 
320 /**
321  * @title Fabric Token
322  *
323  * @dev A standard token implementation of the ERC20 token standard with added
324  *      HasOwner trait and initialized using the configuration constants.
325  */
326 contract FabricToken is FabricTokenConfig, HasOwner, FreezableERC20Token {
327     // The name of the token.
328     string public name;
329 
330     // The symbol for the token.
331     string public symbol;
332 
333     // The decimals of the token.
334     uint8 public decimals;
335 
336     /**
337      * @dev The constructor. Initially sets `totalSupply` and the balance of the
338      *      `owner` address according to the initialization parameter.
339      */
340     function FabricToken(uint _totalSupply) public
341         HasOwner(msg.sender)
342     {
343         name = NAME;
344         symbol = SYMBOL;
345         decimals = DECIMALS;
346         totalSupply = _totalSupply;
347         balances[owner] = _totalSupply;
348     }
349 }
350 
351 // File: contracts\configs\FabricTokenFundraiserConfig.sol
352 
353 /**
354  * @title FabricTokenFundraiserConfig
355  *
356  * @dev The static configuration for the Fabric Token fundraiser.
357  */
358 contract FabricTokenFundraiserConfig is FabricTokenConfig {
359     // The number of FT per 1 ETH.
360     uint constant CONVERSION_RATE = 9000;
361 
362     // The public sale hard cap of the fundraiser.
363     uint constant TOKENS_HARD_CAP = 71250 * (10**3) * DECIMALS_FACTOR;
364 
365     // The start date of the fundraiser: Thursday, 2018-02-15 10:00:00 UTC.
366     uint constant START_DATE = 1518688800;
367 
368     // The end date of the fundraiser: Sunday, 2018-04-01 10:00:00 UTC (45 days after `START_DATE`).
369     uint constant END_DATE = 1522576800;
370     
371     // Total number of tokens locked for the FT core team.
372     uint constant TOKENS_LOCKED_CORE_TEAM = 12 * (10**6) * DECIMALS_FACTOR;
373 
374     // Total number of tokens locked for FT advisors.
375     uint constant TOKENS_LOCKED_ADVISORS = 7 * (10**6) * DECIMALS_FACTOR;
376 
377     // The release date for tokens locked for the FT core team.
378     uint constant TOKENS_LOCKED_CORE_TEAM_RELEASE_DATE = START_DATE + 1 years;
379 
380     // The release date for tokens locked for FT advisors.
381     uint constant TOKENS_LOCKED_ADVISORS_RELEASE_DATE = START_DATE + 180 days;
382 
383     // Total number of tokens locked for bounty program.
384     uint constant TOKENS_BOUNTY_PROGRAM = 1 * (10**6) * DECIMALS_FACTOR;
385 
386     // Maximum gas price limit
387     uint constant MAX_GAS_PRICE = 50000000000 wei; // 50 gwei/shanon
388 
389     // Minimum individual contribution
390     uint constant MIN_CONTRIBUTION =  0.1 ether;
391 
392     // Individual limit in ether
393     uint constant INDIVIDUAL_ETHER_LIMIT =  9 ether;
394 }
395 
396 // File: contracts\traits\TokenSafe.sol
397 
398 /**
399  * @title TokenSafe
400  *
401  * @dev A multi-bundle token safe contract that contains locked tokens released after a date for the specific bundle type.
402  */
403 contract TokenSafe {
404     using SafeMath for uint;
405 
406     struct AccountsBundle {
407         // The total number of tokens locked.
408         uint lockedTokens;
409         // The release date for the locked tokens
410         // Note: Unix timestamp fits uint32, however block.timestamp is uint
411         uint releaseDate;
412         // The balances for the FT locked token accounts.
413         mapping (address => uint) balances;
414     }
415 
416     // The account bundles of locked tokens grouped by release date
417     mapping (uint8 => AccountsBundle) public bundles;
418 
419     // The `ERC20TokenInterface` contract.
420     ERC20TokenInterface token;
421 
422     /**
423      * @dev The constructor.
424      *
425      * @param _token The address of the Fabric Token (fundraiser) contract.
426      */
427     function TokenSafe(address _token) public {
428         token = ERC20TokenInterface(_token);
429     }
430 
431     /**
432      * @dev The function initializes the bundle of accounts with a release date.
433      *
434      * @param _type Bundle type.
435      * @param _releaseDate Unix timestamp of the time after which the tokens can be released
436      */
437     function initBundle(uint8 _type, uint _releaseDate) internal {
438         bundles[_type].releaseDate = _releaseDate;
439     }
440 
441     /**
442      * @dev Add new account with locked token balance to the specified bundle type.
443      *
444      * @param _type Bundle type.
445      * @param _account The address of the account to be added.
446      * @param _balance The number of tokens to be locked.
447      */
448     function addLockedAccount(uint8 _type, address _account, uint _balance) internal {
449         var bundle = bundles[_type];
450         bundle.balances[_account] = bundle.balances[_account].plus(_balance);
451         bundle.lockedTokens = bundle.lockedTokens.plus(_balance);
452     }
453 
454     /**
455      * @dev Allows an account to be released if it meets the time constraints.
456      *
457      * @param _type Bundle type.
458      * @param _account The address of the account to be released.
459      */
460     function releaseAccount(uint8 _type, address _account) internal {
461         var bundle = bundles[_type];
462         require(now >= bundle.releaseDate);
463         uint tokens = bundle.balances[_account];
464         require(tokens > 0);
465         bundle.balances[_account] = 0;
466         bundle.lockedTokens = bundle.lockedTokens.minus(tokens);
467         if (!token.transfer(_account, tokens)) {
468             revert();
469         }
470     }
471 }
472 
473 // File: contracts\FabricTokenSafe.sol
474 
475 /**
476  * @title FabricTokenSafe
477  *
478  * @dev The Fabric Token safe containing all details about locked tokens.
479  */
480 contract FabricTokenSafe is TokenSafe, FabricTokenFundraiserConfig {
481     // Bundle type constants
482     uint8 constant CORE_TEAM = 0;
483     uint8 constant ADVISORS = 1;
484 
485     /**
486      * @dev The constructor.
487      *
488      * @param _token The address of the Fabric Token (fundraiser) contract.
489      */
490     function FabricTokenSafe(address _token) public
491         TokenSafe(_token)
492     {
493         token = ERC20TokenInterface(_token);
494 
495         /// Core team.
496         initBundle(CORE_TEAM,
497             TOKENS_LOCKED_CORE_TEAM_RELEASE_DATE
498         );
499 
500         // Accounts with tokens locked for the FT core team.
501         addLockedAccount(CORE_TEAM, 0xB494096548aA049C066289A083204E923cBf4413, 4 * (10**6) * DECIMALS_FACTOR);
502         addLockedAccount(CORE_TEAM, 0xE3506B01Bee377829ee3CffD8bae650e990c5d68, 4 * (10**6) * DECIMALS_FACTOR);
503         addLockedAccount(CORE_TEAM, 0x3d13219dc1B8913E019BeCf0772C2a54318e5718, 4 * (10**6) * DECIMALS_FACTOR);
504 
505         // Verify that the tokens add up to the constant in the configuration.
506         assert(bundles[CORE_TEAM].lockedTokens == TOKENS_LOCKED_CORE_TEAM);
507 
508         /// Advisors.
509         initBundle(ADVISORS,
510             TOKENS_LOCKED_ADVISORS_RELEASE_DATE
511         );
512 
513         // Accounts with FT tokens locked for advisors.
514         addLockedAccount(ADVISORS, 0x4647Da07dAAb17464278B988CDE59A4b911EBe44, 2 * (10**6) * DECIMALS_FACTOR);
515         addLockedAccount(ADVISORS, 0x3eA2caac5A0A4a55f9e304AcD09b3CEe6cD4Bc39, 1 * (10**6) * DECIMALS_FACTOR);
516         addLockedAccount(ADVISORS, 0xd5f791EC3ED79f79a401b12f7625E1a972382437, 1 * (10**6) * DECIMALS_FACTOR);
517         addLockedAccount(ADVISORS, 0xcaeae3CD1a5d3E6E950424C994e14348ac3Ec5dA, 1 * (10**6) * DECIMALS_FACTOR);
518         addLockedAccount(ADVISORS, 0xb6EA6193058F3c8A4A413d176891d173D62E00bE, 1 * (10**6) * DECIMALS_FACTOR);
519         addLockedAccount(ADVISORS, 0x8b3E184Cf5C3bFDaB1C4D0F30713D30314FcfF7c, 1 * (10**6) * DECIMALS_FACTOR);
520 
521         // Verify that the tokens add up to the constant in the configuration.
522         assert(bundles[ADVISORS].lockedTokens == TOKENS_LOCKED_ADVISORS);
523     }
524 
525     /**
526      * @dev Returns the total locked tokens. This function is called by the fundraiser to determine number of tokens to create upon finalization.
527      *
528      * @return The current total number of locked Fabric Tokens.
529      */
530     function totalTokensLocked() public constant returns (uint) {
531         return bundles[CORE_TEAM].lockedTokens.plus(bundles[ADVISORS].lockedTokens);
532     }
533 
534     /**
535      * @dev Allows core team account FT tokens to be released.
536      */
537     function releaseCoreTeamAccount() public {
538         releaseAccount(CORE_TEAM, msg.sender);
539     }
540 
541     /**
542      * @dev Allows advisors account FT tokens to be released.
543      */
544     function releaseAdvisorsAccount() public {
545         releaseAccount(ADVISORS, msg.sender);
546     }
547 }
548 
549 // File: contracts\traits\Whitelist.sol
550 
551 contract Whitelist is HasOwner
552 {
553     // Whitelist mapping
554     mapping(address => bool) public whitelist;
555 
556     /**
557      * @dev The constructor.
558      */
559     function Whitelist(address _owner) public
560         HasOwner(_owner)
561     {
562 
563     }
564 
565     /**
566      * @dev Access control modifier that allows only whitelisted address to call the method.
567      */
568     modifier onlyWhitelisted {
569         require(whitelist[msg.sender]);
570         _;
571     }
572 
573     /**
574      * @dev Internal function that sets whitelist status in batch.
575      *
576      * @param _entries An array with the entries to be updated
577      * @param _status The new status to apply
578      */
579     function setWhitelistEntries(address[] _entries, bool _status) internal {
580         for (uint32 i = 0; i < _entries.length; ++i) {
581             whitelist[_entries[i]] = _status;
582         }
583     }
584 
585     /**
586      * @dev Public function that allows the owner to whitelist multiple entries
587      *
588      * @param _entries An array with the entries to be whitelisted
589      */
590     function whitelistAddresses(address[] _entries) public onlyOwner {
591         setWhitelistEntries(_entries, true);
592     }
593 
594     /**
595      * @dev Public function that allows the owner to blacklist multiple entries
596      *
597      * @param _entries An array with the entries to be blacklist
598      */
599     function blacklistAddresses(address[] _entries) public onlyOwner {
600         setWhitelistEntries(_entries, false);
601     }
602 }
603 
604 // File: contracts\FabricTokenFundraiser.sol
605 
606 /**
607  * @title FabricTokenFundraiser
608  *
609  * @dev The Fabric Token fundraiser contract.
610  */
611 contract FabricTokenFundraiser is FabricToken, FabricTokenFundraiserConfig, Whitelist {
612     // Indicates whether the fundraiser has ended or not.
613     bool public finalized = false;
614 
615     // The address of the account which will receive the funds gathered by the fundraiser.
616     address public beneficiary;
617 
618     // The number of FT participants will receive per 1 ETH.
619     uint public conversionRate;
620 
621     // Fundraiser start date.
622     uint public startDate;
623 
624     // Fundraiser end date.
625     uint public endDate;
626 
627     // Fundraiser tokens hard cap.
628     uint public hardCap;
629 
630     // The `FabricTokenSafe` contract.
631     FabricTokenSafe public fabricTokenSafe;
632 
633     // The minimum amount of ether allowed in the public sale
634     uint internal minimumContribution;
635 
636     // The maximum amount of ether allowed per address
637     uint internal individualLimit;
638 
639     // Number of tokens sold during the fundraiser.
640     uint private tokensSold;
641 
642     // Indicates whether the tokens are claimed by the partners
643     bool private partnerTokensClaimed = false;
644 
645     /**
646      * @dev The event fires every time a new buyer enters the fundraiser.
647      *
648      * @param _address The address of the buyer.
649      * @param _ethers The number of ethers sent.
650      * @param _tokens The number of tokens received by the buyer.
651      * @param _newTotalSupply The updated total number of tokens currently in circulation.
652      * @param _conversionRate The conversion rate at which the tokens were bought.
653      */
654     event FundsReceived(address indexed _address, uint _ethers, uint _tokens, uint _newTotalSupply, uint _conversionRate);
655 
656     /**
657      * @dev The event fires when the beneficiary of the fundraiser is changed.
658      *
659      * @param _beneficiary The address of the new beneficiary.
660      */
661     event BeneficiaryChange(address _beneficiary);
662 
663     /**
664      * @dev The event fires when the number of FT per 1 ETH is changed.
665      *
666      * @param _conversionRate The new number of FT per 1 ETH.
667      */
668     event ConversionRateChange(uint _conversionRate);
669 
670     /**
671      * @dev The event fires when the fundraiser is successfully finalized.
672      *
673      * @param _beneficiary The address of the beneficiary.
674      * @param _ethers The number of ethers transfered to the beneficiary.
675      * @param _totalSupply The total number of tokens in circulation.
676      */
677     event Finalized(address _beneficiary, uint _ethers, uint _totalSupply);
678 
679     /**
680      * @dev The constructor.
681      *
682      * @param _beneficiary The address which will receive the funds gathered by the fundraiser.
683      */
684     function FabricTokenFundraiser(address _beneficiary) public
685         FabricToken(0)
686         Whitelist(msg.sender)
687     {
688         require(_beneficiary != 0);
689 
690         beneficiary = _beneficiary;
691         conversionRate = CONVERSION_RATE;
692         startDate = START_DATE;
693         endDate = END_DATE;
694         hardCap = TOKENS_HARD_CAP;
695         tokensSold = 0;
696         minimumContribution = MIN_CONTRIBUTION;
697         individualLimit = INDIVIDUAL_ETHER_LIMIT * CONVERSION_RATE;
698 
699         fabricTokenSafe = new FabricTokenSafe(this);
700 
701         // Freeze the transfers for the duration of the fundraiser.
702         freeze();
703     }
704 
705     /**
706      * @dev Changes the beneficiary of the fundraiser.
707      *
708      * @param _beneficiary The address of the new beneficiary.
709      */
710     function setBeneficiary(address _beneficiary) public onlyOwner {
711         require(_beneficiary != 0);
712 
713         beneficiary = _beneficiary;
714 
715         BeneficiaryChange(_beneficiary);
716     }
717 
718     /**
719      * @dev Sets converstion rate of 1 ETH to FT. Can only be changed before the fundraiser starts.
720      *
721      * @param _conversionRate The new number of Fabric Tokens per 1 ETH.
722      */
723     function setConversionRate(uint _conversionRate) public onlyOwner {
724         require(now < startDate);
725         require(_conversionRate > 0);
726 
727         conversionRate = _conversionRate;
728         individualLimit = INDIVIDUAL_ETHER_LIMIT * _conversionRate;
729 
730         ConversionRateChange(_conversionRate);
731     }
732 
733     /**
734      * @dev The default function which will fire every time someone sends ethers to this contract's address.
735      */
736     function() public payable {
737         buyTokens();
738     }
739 
740     /**
741      * @dev Creates new tokens based on the number of ethers sent and the conversion rate.
742      */
743     function buyTokens() public payable onlyWhitelisted {
744         require(!finalized);
745         require(now >= startDate);
746         require(now <= endDate);
747         require(tx.gasprice <= MAX_GAS_PRICE);  // gas price limit
748         require(msg.value >= minimumContribution);  // required minimum contribution
749         require(tokensSold <= hardCap);
750 
751         // Calculate the number of tokens the buyer will receive.
752         uint tokens = msg.value.mul(conversionRate);
753         balances[msg.sender] = balances[msg.sender].plus(tokens);
754 
755         // Ensure that the individual contribution limit has not been reached
756         require(balances[msg.sender] <= individualLimit);
757 
758         tokensSold = tokensSold.plus(tokens);
759         totalSupply = totalSupply.plus(tokens);
760 
761         Transfer(0x0, msg.sender, tokens);
762 
763         FundsReceived(
764             msg.sender,
765             msg.value, 
766             tokens, 
767             totalSupply, 
768             conversionRate
769         );
770     }
771 
772     /**
773      * @dev Distributes the tokens allocated for the strategic partners.
774      */
775     function claimPartnerTokens() public {
776         require(!partnerTokensClaimed);
777         require(now >= startDate);
778 
779         partnerTokensClaimed = true;
780 
781         address partner1 = 0xA6556B9BD0AAbf0d8824374A3C425d315b09b832;
782         balances[partner1] = balances[partner1].plus(125 * (10**4) * DECIMALS_FACTOR);
783 
784         address partner2 = 0x783A1cBc37a8ef2F368908490b72BfE801DA1877;
785         balances[partner2] = balances[partner2].plus(750 * (10**4) * DECIMALS_FACTOR);
786 
787         totalSupply = totalSupply.plus(875 * (10**4) * DECIMALS_FACTOR);
788     }
789 
790     /**
791      * @dev Finalize the fundraiser if `endDate` has passed or if `hardCap` is reached.
792      */
793     function finalize() public onlyOwner {
794         require((totalSupply >= hardCap) || (now >= endDate));
795         require(!finalized);
796 
797         Finalized(beneficiary, this.balance, totalSupply);
798 
799         /// Send the total number of ETH gathered to the beneficiary.
800         beneficiary.transfer(this.balance);
801 
802         /// Allocate locked tokens to the `FabricTokenSafe` contract.
803         uint totalTokensLocked = fabricTokenSafe.totalTokensLocked();
804         balances[address(fabricTokenSafe)] = balances[address(fabricTokenSafe)].plus(totalTokensLocked);
805         totalSupply = totalSupply.plus(totalTokensLocked);
806 
807         // Transfer the funds for the bounty program.
808         balances[owner] = balances[owner].plus(TOKENS_BOUNTY_PROGRAM);
809         totalSupply = totalSupply.plus(TOKENS_BOUNTY_PROGRAM);
810 
811         /// Finalize the fundraiser. Keep in mind that this cannot be undone.
812         finalized = true;
813 
814         // Unfreeze transfers
815         unfreeze();
816     }
817 }