1 pragma solidity ^0.4.18;
2 
3 /**
4 *
5 *    I  N    P  I  Z  Z  A     W  E     C  R  U  S  T
6 *  
7 *    ______ ____   _____       _____ _
8 *   |  ____/ __ \ / ____|     |  __ (_)
9 *   | |__ | |  | | (___       | |__) | __________ _
10 *   |  __|| |  | |\___ \      |  ___/ |_  /_  / _` |
11 *   | |___| |__| |____) |  _  | |   | |/ / / / (_| |
12 *   |______\____/|_____/  (_) |_|   |_/___/___\__,_|
13 *
14 *
15 *
16 *   CHECK HTTPS://EOS.PIZZA ON HOW TO GET YOUR SLICE
17 *   END: 18 MAY 2018
18 *
19 *   This is for the fun. Thank you token factory for your smart contract inspiration.
20 *   Jummy & crusty. Get your ?EPS while it's hot. 
21 *
22 *   https://eos.pizza
23 *
24 *
25 **/
26 
27 // File: contracts\configs\EosPizzaSliceConfig.sol
28 
29 
30 /**
31  * @title EosPizzaSliceConfig
32  *
33  * @dev The static configuration for the EOS Pizza Slice.
34  */
35 contract EosPizzaSliceConfig {
36     // The name of the token.
37     string constant NAME = "EOS.Pizza";
38 
39     // The symbol of the token.
40     string constant SYMBOL = "EPS";
41 
42     // The number of decimals for the token.
43     uint8 constant DECIMALS = 18;  // Same as ethers.
44 
45     // Decimal factor for multiplication purposes.
46     uint constant DECIMALS_FACTOR = 10 ** uint(DECIMALS);
47 }
48 
49 // File: contracts\interfaces\ERC20TokenInterface.sol
50 
51 /**
52  * @dev The standard ERC20 Token interface.
53  */
54 contract ERC20TokenInterface {
55     uint public totalSupply;  /* shorthand for public function and a property */
56     event Transfer(address indexed _from, address indexed _to, uint _value);
57     event Approval(address indexed _owner, address indexed _spender, uint _value);
58     function balanceOf(address _owner) public constant returns (uint balance);
59     function transfer(address _to, uint _value) public returns (bool success);
60     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
61     function approve(address _spender, uint _value) public returns (bool success);
62     function allowance(address _owner, address _spender) public constant returns (uint remaining);
63 
64 }
65 
66 // File: contracts\libraries\SafeMath.sol
67 
68 /**
69  * @dev Library that helps prevent integer overflows and underflows,
70  * inspired by https://github.com/OpenZeppelin/zeppelin-solidity
71  */
72 library SafeMath {
73     function plus(uint a, uint b) internal pure returns (uint) {
74         uint c = a + b;
75         assert(c >= a);
76 
77         return c;
78     }
79 
80     function minus(uint a, uint b) internal pure returns (uint) {
81         assert(b <= a);
82 
83         return a - b;
84     }
85 
86     function mul(uint a, uint b) internal pure returns (uint) {
87         uint c = a * b;
88         assert(a == 0 || c / a == b);
89 
90         return c;
91     }
92 
93     function div(uint a, uint b) internal pure returns (uint) {
94         uint c = a / b;
95 
96         return c;
97     }
98 }
99 
100 // File: contracts\traits\ERC20Token.sol
101 
102 /**
103  * @title ERC20Token
104  *
105  * @dev Implements the operations declared in the `ERC20TokenInterface`.
106  */
107 contract ERC20Token is ERC20TokenInterface {
108     using SafeMath for uint;
109 
110     // Token account balances.
111     mapping (address => uint) balances;
112 
113     // Delegated number of tokens to transfer.
114     mapping (address => mapping (address => uint)) allowed;
115 
116 
117 
118     /**
119      * @dev Checks the balance of a certain address.
120      *
121      * @param _account The address which's balance will be checked.
122      *
123      * @return Returns the balance of the `_account` address.
124      */
125     function balanceOf(address _account) public constant returns (uint balance) {
126         return balances[_account];
127     }
128 
129     /**
130      * @dev Transfers tokens from one address to another.
131      *
132      * @param _to The target address to which the `_value` number of tokens will be sent.
133      * @param _value The number of tokens to send.
134      *
135      * @return Whether the transfer was successful or not.
136      */
137     function transfer(address _to, uint _value) public returns (bool success) {
138         if (balances[msg.sender] < _value || _value == 0) {
139 
140             return false;
141         }
142 
143         balances[msg.sender] -= _value;
144         balances[_to] = balances[_to].plus(_value);
145 
146 
147         Transfer(msg.sender, _to, _value);
148 
149         return true;
150     }
151 
152     /**
153      * @dev Send `_value` tokens to `_to` from `_from` if `_from` has approved the process.
154      *
155      * @param _from The address of the sender.
156      * @param _to The address of the recipient.
157      * @param _value The number of tokens to be transferred.
158      *
159      * @return Whether the transfer was successful or not.
160      */
161     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
162         if (balances[_from] < _value || allowed[_from][msg.sender] < _value || _value == 0) {
163             return false;
164         }
165 
166         balances[_to] = balances[_to].plus(_value);
167         balances[_from] -= _value;
168         allowed[_from][msg.sender] -= _value;
169 
170 
171         Transfer(_from, _to, _value);
172 
173         return true;
174     }
175 
176     /**
177      * @dev Allows another contract to spend some tokens on your behalf.
178      *
179      * @param _spender The address of the account which will be approved for transfer of tokens.
180      * @param _value The number of tokens to be approved for transfer.
181      *
182      * @return Whether the approval was successful or not.
183      */
184     function approve(address _spender, uint _value) public returns (bool success) {
185         allowed[msg.sender][_spender] = _value;
186 
187         Approval(msg.sender, _spender, _value);
188 
189         return true;
190     }
191 
192     /**
193      * @dev Shows the number of tokens approved by `_owner` that are allowed to be transferred by `_spender`.
194      *
195      * @param _owner The account which allowed the transfer.
196      * @param _spender The account which will spend the tokens.
197      *
198      * @return The number of tokens to be transferred.
199      */
200     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
201         return allowed[_owner][_spender];
202     }
203 }
204 
205 // File: contracts\traits\HasOwner.sol
206 
207 /**
208  * @title HasOwner
209  *
210  * @dev Allows for exclusive access to certain functionality.
211  */
212 contract HasOwner {
213     // Current owner.
214     address public owner;
215 
216     // Conditionally the new owner.
217     address public newOwner;
218 
219     /**
220      * @dev The constructor.
221      *
222      * @param _owner The address of the owner.
223      */
224     function HasOwner(address _owner) internal {
225         owner = _owner;
226     }
227 
228     /**
229      * @dev Access control modifier that allows only the current owner to call the function.
230      */
231     modifier onlyOwner {
232         require(msg.sender == owner);
233         _;
234     }
235 
236     /**
237      * @dev The event is fired when the current owner is changed.
238      *
239      * @param _oldOwner The address of the previous owner.
240      * @param _newOwner The address of the new owner.
241      */
242     event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);
243 
244     /**
245      * @dev Transfering the ownership is a two-step process, as we prepare
246      * for the transfer by setting `newOwner` and requiring `newOwner` to accept
247      * the transfer. This prevents accidental lock-out if something goes wrong
248      * when passing the `newOwner` address.
249      *
250      * @param _newOwner The address of the proposed new owner.
251      */
252     function transferOwnership(address _newOwner) public onlyOwner {
253         newOwner = _newOwner;
254     }
255 
256     /**
257      * @dev The `newOwner` finishes the ownership transfer process by accepting the
258      * ownership.
259      */
260     function acceptOwnership() public {
261         require(msg.sender == newOwner);
262 
263         OwnershipTransfer(owner, newOwner);
264 
265         owner = newOwner;
266     }
267 }
268 
269 // File: contracts\traits\Freezable.sol
270 
271 /**
272  * @title Freezable
273  * @dev This trait allows to freeze the transactions in a Token
274  */
275 contract Freezable is HasOwner {
276   bool public frozen = false;
277 
278   /**
279    * @dev Modifier makes methods callable only when the contract is not frozen.
280    */
281   modifier requireNotFrozen() {
282     require(!frozen);
283     _;
284   }
285 
286   /**
287    * @dev Allows the owner to "freeze" the contract.
288    */
289   function freeze() onlyOwner public {
290     frozen = true;
291   }
292 
293   /**
294    * @dev Allows the owner to "unfreeze" the contract.
295    */
296   function unfreeze() onlyOwner public {
297     frozen = false;
298   }
299 }
300 
301 // File: contracts\traits\FreezableERC20Token.sol
302 
303 /**
304  * @title FreezableERC20Token
305  *
306  * @dev Extends ERC20Token and adds ability to freeze all transfers of tokens.
307  */
308 contract FreezableERC20Token is ERC20Token, Freezable {
309     /**
310      * @dev Overrides the original ERC20Token implementation by adding whenNotFrozen modifier.
311      *
312      * @param _to The target address to which the `_value` number of tokens will be sent.
313      * @param _value The number of tokens to send.
314      *
315      * @return Whether the transfer was successful or not.
316      */
317     function transfer(address _to, uint _value) public requireNotFrozen returns (bool success) {
318         return super.transfer(_to, _value);
319     }
320 
321     /**
322      * @dev Send `_value` tokens to `_to` from `_from` if `_from` has approved the process.
323      *
324      * @param _from The address of the sender.
325      * @param _to The address of the recipient.
326      * @param _value The number of tokens to be transferred.
327      *
328      * @return Whether the transfer was successful or not.
329      */
330     function transferFrom(address _from, address _to, uint _value) public requireNotFrozen returns (bool success) {
331         return super.transferFrom(_from, _to, _value);
332     }
333 
334     /**
335      * @dev Allows another contract to spend some tokens on your behalf.
336      *
337      * @param _spender The address of the account which will be approved for transfer of tokens.
338      * @param _value The number of tokens to be approved for transfer.
339      *
340      * @return Whether the approval was successful or not.
341      */
342     function approve(address _spender, uint _value) public requireNotFrozen returns (bool success) {
343         return super.approve(_spender, _value);
344     }
345 
346 }
347 
348 // File: contracts\EosPizzaSlice.sol
349 
350 /**
351  * @title EOS Pizza Slice
352  *
353  * @dev A standard token implementation of the ERC20 token standard with added
354  *      HasOwner trait and initialized using the configuration constants.
355  */
356 contract EosPizzaSlice is EosPizzaSliceConfig, HasOwner, FreezableERC20Token {
357     // The name of the token.
358     string public name;
359 
360     // The symbol for the token.
361     string public symbol;
362 
363     // The decimals of the token.
364     uint8 public decimals;
365 
366     /**
367      * @dev The constructor. Initially sets `totalSupply` and the balance of the
368      *      `owner` address according to the initialization parameter.
369      */
370     function EosPizzaSlice(uint _totalSupply) public
371         HasOwner(msg.sender)
372     {
373         name = NAME;
374         symbol = SYMBOL;
375         decimals = DECIMALS;
376         totalSupply = _totalSupply;
377         balances[owner] = _totalSupply;
378     }
379 }
380 
381 // File: contracts\configs\EosPizzaSliceDonationraiserConfig.sol
382 
383 /**
384  * @title EosPizzaSliceDonationraiserConfig
385  *
386  * @dev The static configuration for the EOS Pizza Slice donationraiser.
387  */
388 contract EosPizzaSliceDonationraiserConfig is EosPizzaSliceConfig {
389     // The number of ? per 1 ETH.
390     uint constant CONVERSION_RATE = 100000;
391 
392     // The public sale hard cap of the donationraiser.
393     uint constant TOKENS_HARD_CAP = 95 * (10**7) * DECIMALS_FACTOR;
394 
395     // The start date of the donationraiser: Friday, 9 March 2018 21:22:22 UTC.
396     uint constant START_DATE = 1520630542;
397 
398     // The end date of the donationraiser:  May 18, 2018, 12:35:20 AM UTC - Bitcoin Pizza 8th year celebration moment.
399     uint constant END_DATE =  1526603720;
400 
401 
402     // Total number of tokens locked for the ? core team.
403     uint constant TOKENS_LOCKED_CORE_TEAM = 35 * (10**6) * DECIMALS_FACTOR;
404 
405     // Total number of tokens locked for ? advisors.
406     uint constant TOKENS_LOCKED_ADVISORS = 125 * (10**5) * DECIMALS_FACTOR;
407 
408     // The release date for tokens locked for the ? core team.
409     uint constant TOKENS_LOCKED_CORE_TEAM_RELEASE_DATE = END_DATE + 1 days;
410 
411     // The release date for tokens locked for ? advisors.
412     uint constant TOKENS_LOCKED_ADVISORS_RELEASE_DATE = END_DATE + 1 days;
413 
414     // Total number of tokens locked for bounty program.
415     uint constant TOKENS_BOUNTY_PROGRAM = 25 * (10**5) * DECIMALS_FACTOR;
416 
417     // Maximum gas price limit
418     uint constant MAX_GAS_PRICE = 90000000000 wei; // 90 gwei/shanon
419 
420     // Minimum individual contribution
421     uint constant MIN_CONTRIBUTION =  0.05 ether;
422 
423     // Individual limit in ether
424     uint constant INDIVIDUAL_ETHER_LIMIT =  4999 ether;
425 }
426 
427 // File: contracts\traits\TokenSafe.sol
428 
429 /**
430  * @title TokenSafe
431  *
432  * @dev A multi-bundle token safe contract that contains locked tokens released after a date for the specific bundle type.
433  */
434 contract TokenSafe {
435     using SafeMath for uint;
436 
437     struct AccountsBundle {
438         // The total number of tokens locked.
439         uint lockedTokens;
440         // The release date for the locked tokens
441         // Note: Unix timestamp fits uint32, however block.timestamp is uint
442         uint releaseDate;
443         // The balances for the ? locked token accounts.
444         mapping (address => uint) balances;
445     }
446 
447     // The account bundles of locked tokens grouped by release date
448     mapping (uint8 => AccountsBundle) public bundles;
449 
450     // The `ERC20TokenInterface` contract.
451     ERC20TokenInterface token;
452 
453     /**
454      * @dev The constructor.
455      *
456      * @param _token The address of the EOS Pizza Slices (donation) contract.
457      */
458     function TokenSafe(address _token) public {
459         token = ERC20TokenInterface(_token);
460     }
461 
462     /**
463      * @dev The function initializes the bundle of accounts with a release date.
464      *
465      * @param _type Bundle type.
466      * @param _releaseDate Unix timestamp of the time after which the tokens can be released
467      */
468     function initBundle(uint8 _type, uint _releaseDate) internal {
469         bundles[_type].releaseDate = _releaseDate;
470     }
471 
472     /**
473      * @dev Add new account with locked token balance to the specified bundle type.
474      *
475      * @param _type Bundle type.
476      * @param _account The address of the account to be added.
477      * @param _balance The number of tokens to be locked.
478      */
479     function addLockedAccount(uint8 _type, address _account, uint _balance) internal {
480         var bundle = bundles[_type];
481         bundle.balances[_account] = bundle.balances[_account].plus(_balance);
482         bundle.lockedTokens = bundle.lockedTokens.plus(_balance);
483     }
484 
485     /**
486      * @dev Allows an account to be released if it meets the time constraints.
487      *
488      * @param _type Bundle type.
489      * @param _account The address of the account to be released.
490      */
491     function releaseAccount(uint8 _type, address _account) internal {
492         var bundle = bundles[_type];
493         require(now >= bundle.releaseDate);
494         uint tokens = bundle.balances[_account];
495         require(tokens > 0);
496         bundle.balances[_account] = 0;
497         bundle.lockedTokens = bundle.lockedTokens.minus(tokens);
498         if (!token.transfer(_account, tokens)) {
499             revert();
500         }
501     }
502 }
503 
504 // File: contracts\EosPizzaSliceSafe.sol
505 
506 /**
507  * @title EosPizzaSliceSafe
508  *
509  * @dev The EOS Pizza Slice safe containing all details about locked tokens.
510  */
511 contract EosPizzaSliceSafe is TokenSafe, EosPizzaSliceDonationraiserConfig {
512     // Bundle type constants
513     uint8 constant CORE_TEAM = 0;
514     uint8 constant ADVISORS = 1;
515 
516     /**
517      * @dev The constructor.
518      *
519      * @param _token The address of the EOS Pizza (donation) contract.
520      */
521     function EosPizzaSliceSafe(address _token) public
522         TokenSafe(_token)
523     {
524         token = ERC20TokenInterface(_token);
525 
526         /// Core team.
527         initBundle(CORE_TEAM,
528             TOKENS_LOCKED_CORE_TEAM_RELEASE_DATE
529         );
530 
531         // Accounts with tokens locked for the ? core team.
532         addLockedAccount(CORE_TEAM, 0x3ce215b2e4dC9D2ba0e2fC5099315E4Fa05d8AA2, 35 * (10**6) * DECIMALS_FACTOR);
533 
534 
535         // Verify that the tokens add up to the constant in the configuration.
536         assert(bundles[CORE_TEAM].lockedTokens == TOKENS_LOCKED_CORE_TEAM);
537 
538         /// Advisors.
539         initBundle(ADVISORS,
540             TOKENS_LOCKED_ADVISORS_RELEASE_DATE
541         );
542 
543         // Accounts with ? tokens locked for advisors.
544         addLockedAccount(ADVISORS, 0xC0e321E9305c21b72F5Ee752A9E8D9eCD0f2e2b1, 25 * (10**5) * DECIMALS_FACTOR);
545         addLockedAccount(ADVISORS, 0x55798CF234FEa760b0591537517C976FDb0c53Ba, 25 * (10**5) * DECIMALS_FACTOR);
546         addLockedAccount(ADVISORS, 0xbc732e73B94A5C4a8f60d0D98C4026dF21D500f5, 25 * (10**5) * DECIMALS_FACTOR);
547         addLockedAccount(ADVISORS, 0x088EEEe7C4c26041FBb4e83C10CB0784C81c86f9, 25 * (10**5) * DECIMALS_FACTOR);
548         addLockedAccount(ADVISORS, 0x52d640c9c417D9b7E3770d960946Dd5Bd2EB63db, 25 * (10**5) * DECIMALS_FACTOR);
549 
550 
551         // Verify that the tokens add up to the constant in the configuration.
552         assert(bundles[ADVISORS].lockedTokens == TOKENS_LOCKED_ADVISORS);
553     }
554 
555     /**
556      * @dev Returns the total locked tokens. This function is called by the donationraiser to determine number of tokens to create upon finalization.
557      *
558      * @return The current total number of locked EOS Pizza Slices.
559      */
560     function totalTokensLocked() public constant returns (uint) {
561         return bundles[CORE_TEAM].lockedTokens.plus(bundles[ADVISORS].lockedTokens);
562     }
563 
564     /**
565      * @dev Allows core team account ? tokens to be released.
566      */
567     function releaseCoreTeamAccount() public {
568         releaseAccount(CORE_TEAM, msg.sender);
569     }
570 
571     /**
572      * @dev Allows advisors account ? tokens to be released.
573      */
574     function releaseAdvisorsAccount() public {
575         releaseAccount(ADVISORS, msg.sender);
576     }
577 }
578 
579 // File: contracts\traits\Whitelist.sol
580 
581 contract Whitelist is HasOwner
582 {
583     // Whitelist mapping
584     mapping(address => bool) public whitelist;
585 
586     /**
587      * @dev The constructor.
588      */
589     function Whitelist(address _owner) public
590         HasOwner(_owner)
591     {
592 
593     }
594 
595     /**
596      * @dev Access control modifier that allows only whitelisted address to call the method.
597      */
598     modifier onlyWhitelisted {
599         require(whitelist[msg.sender]);
600         _;
601     }
602 
603     /**
604      * @dev Internal function that sets whitelist status in batch.
605      *
606      * @param _entries An array with the entries to be updated
607      * @param _status The new status to apply
608      */
609     function setWhitelistEntries(address[] _entries, bool _status) internal {
610         for (uint32 i = 0; i < _entries.length; ++i) {
611             whitelist[_entries[i]] = _status;
612         }
613     }
614 
615     /**
616      * @dev Public function that allows the owner to whitelist multiple entries
617      *
618      * @param _entries An array with the entries to be whitelisted
619      */
620     function whitelistAddresses(address[] _entries) public onlyOwner {
621         setWhitelistEntries(_entries, true);
622     }
623 
624     /**
625      * @dev Public function that allows the owner to blacklist multiple entries
626      *
627      * @param _entries An array with the entries to be blacklist
628      */
629     function blacklistAddresses(address[] _entries) public onlyOwner {
630         setWhitelistEntries(_entries, false);
631     }
632 }
633 
634 // File: contracts\EosPizzaSliceDonationraiser.sol
635 
636 /**
637  * @title EosPizzaSliceDonationraiser
638  *
639  * @dev The EOS Pizza Slice donationraiser contract.
640  */
641 contract EosPizzaSliceDonationraiser is EosPizzaSlice, EosPizzaSliceDonationraiserConfig, Whitelist {
642     // Indicates whether the donationraiser has ended or not.
643     bool public finalized = false;
644 
645     // The address of the account which will receive the funds gathered by the donationraiser.
646     address public beneficiary;
647 
648     // The number of ? participants will receive per 1 ETH.
649     uint public conversionRate;
650 
651     // Donationraiser start date.
652     uint public startDate;
653 
654     // Donationraiser end date.
655     uint public endDate;
656 
657     // Donationraiser tokens hard cap.
658     uint public hardCap;
659 
660     // The `EosPizzaSliceSafe` contract.
661     EosPizzaSliceSafe public eosPizzaSliceSafe;
662 
663     // The minimum amount of ether allowed in the public sale
664     uint internal minimumContribution;
665 
666     // The maximum amount of ether allowed per address
667     uint internal individualLimit;
668 
669     // Number of tokens sold during the donationraiser.
670     uint private tokensSold;
671 
672 
673 
674     /**
675      * @dev The event fires every time a new buyer enters the donationraiser.
676      *
677      * @param _address The address of the buyer.
678      * @param _ethers The number of ethers sent.
679      * @param _tokens The number of tokens received by the buyer.
680      * @param _newTotalSupply The updated total number of tokens currently in circulation.
681      * @param _conversionRate The conversion rate at which the tokens were bought.
682      */
683     event FundsReceived(address indexed _address, uint _ethers, uint _tokens, uint _newTotalSupply, uint _conversionRate);
684 
685     /**
686      * @dev The event fires when the beneficiary of the donationraiser is changed.
687      *
688      * @param _beneficiary The address of the new beneficiary.
689      */
690     event BeneficiaryChange(address _beneficiary);
691 
692     /**
693      * @dev The event fires when the number of ?EPS per 1 ETH is changed.
694      *
695      * @param _conversionRate The new number of ?EPS per 1 ETH.
696      */
697     event ConversionRateChange(uint _conversionRate);
698 
699     /**
700      * @dev The event fires when the donationraiser is successfully finalized.
701      *
702      * @param _beneficiary The address of the beneficiary.
703      * @param _ethers The number of ethers transfered to the beneficiary.
704      * @param _totalSupply The total number of tokens in circulation.
705      */
706     event Finalized(address _beneficiary, uint _ethers, uint _totalSupply);
707 
708     /**
709      * @dev The constructor.
710      *
711      * @param _beneficiary The address which will receive the funds gathered by the donationraiser.
712      */
713     function EosPizzaSliceDonationraiser(address _beneficiary) public
714         EosPizzaSlice(0)
715         Whitelist(msg.sender)
716     {
717         require(_beneficiary != 0);
718 
719         beneficiary = _beneficiary;
720         conversionRate = CONVERSION_RATE;
721         startDate = START_DATE;
722         endDate = END_DATE;
723         hardCap = TOKENS_HARD_CAP;
724         tokensSold = 0;
725         minimumContribution = MIN_CONTRIBUTION;
726         individualLimit = INDIVIDUAL_ETHER_LIMIT * CONVERSION_RATE;
727 
728         eosPizzaSliceSafe = new EosPizzaSliceSafe(this);
729 
730         // Freeze the transfers for the duration of the donationraiser. Removed this, you can immediately transfer your ?EPS to any ether address you like!
731         // freeze();
732     }
733 
734     /**
735      * @dev Changes the beneficiary of the donationraiser.
736      *
737      * @param _beneficiary The address of the new beneficiary.
738      */
739     function setBeneficiary(address _beneficiary) public onlyOwner {
740         require(_beneficiary != 0);
741 
742         beneficiary = _beneficiary;
743 
744         BeneficiaryChange(_beneficiary);
745     }
746 
747     /**
748      * @dev Sets converstion rate of 1 ETH to ?EPS. Can only be changed before the donationraiser starts.
749      *
750      * @param _conversionRate The new number of EOS Pizza Slices per 1 ETH.
751      */
752     function setConversionRate(uint _conversionRate) public onlyOwner {
753         require(now < startDate);
754         require(_conversionRate > 0);
755 
756         conversionRate = _conversionRate;
757         individualLimit = INDIVIDUAL_ETHER_LIMIT * _conversionRate;
758 
759         ConversionRateChange(_conversionRate);
760     }
761 
762 
763 
764     /**
765      * @dev The default function which will fire every time someone sends ethers to this contract's address.
766      */
767     function() public payable {
768         buyTokens();
769     }
770 
771     /**
772      * @dev Creates new tokens based on the number of ethers sent and the conversion rate.
773      */
774     //function buyTokens() public payable onlyWhitelisted {
775     function buyTokens() public payable {
776         require(!finalized);
777         require(now >= startDate);
778         require(now <= endDate);
779         require(tx.gasprice <= MAX_GAS_PRICE);  // gas price limit
780         require(msg.value >= minimumContribution);  // required minimum contribution
781         require(tokensSold <= hardCap);
782 
783         // Calculate the number of tokens the buyer will receive.
784         uint tokens = msg.value.mul(conversionRate);
785         balances[msg.sender] = balances[msg.sender].plus(tokens);
786 
787         // Ensure that the individual contribution limit has not been reached
788         require(balances[msg.sender] <= individualLimit);
789 
790 
791 
792         tokensSold = tokensSold.plus(tokens);
793         totalSupply = totalSupply.plus(tokens);
794 
795         Transfer(0x0, msg.sender, tokens);
796 
797         FundsReceived(
798             msg.sender,
799             msg.value,
800             tokens,
801             totalSupply,
802             conversionRate
803         );
804     }
805 
806 
807 
808     /**
809      * @dev Finalize the donationraiser if `endDate` has passed or if `hardCap` is reached.
810      */
811     function finalize() public onlyOwner {
812         require((totalSupply >= hardCap) || (now >= endDate));
813         require(!finalized);
814 
815         address contractAddress = this;
816         Finalized(beneficiary, contractAddress.balance, totalSupply);
817 
818         /// Send the total number of ETH gathered to the beneficiary.
819         beneficiary.transfer(contractAddress.balance);
820 
821         /// Allocate locked tokens to the `EosPizzaSliceSafe` contract.
822         uint totalTokensLocked = eosPizzaSliceSafe.totalTokensLocked();
823         balances[address(eosPizzaSliceSafe)] = balances[address(eosPizzaSliceSafe)].plus(totalTokensLocked);
824         totalSupply = totalSupply.plus(totalTokensLocked);
825 
826         // Transfer the funds for the bounty program.
827         balances[owner] = balances[owner].plus(TOKENS_BOUNTY_PROGRAM);
828         totalSupply = totalSupply.plus(TOKENS_BOUNTY_PROGRAM);
829 
830         /// Finalize the donationraiser. Keep in mind that this cannot be undone.
831         finalized = true;
832 
833         // Unfreeze transfers
834         unfreeze();
835     }
836 
837     /**
838      * @dev allow owner to collect balance of contract during donation period
839      */
840 
841     function collect() public onlyOwner {
842 
843         address contractAddress = this;
844         /// Send the total number of ETH gathered to the beneficiary.
845         beneficiary.transfer(contractAddress.balance);
846 
847     }
848 }