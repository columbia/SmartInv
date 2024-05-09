1 pragma solidity ^0.4.18;
2 
3 /**
4 * REKTCOIN.CASH
5 * GOT REKT? COME TO STEEMFEST 2018 IN KRAKOW! - GET AWAY FROM THOSE CANDLES - HAVE A DRINK AND A GOOD TIME - THEN MOON.
6 *
7 * ALL PROCEEDINGS GO TOWARDS FUNDING STEEMFEST - REKTCOIN.CASH LEAD SPONSOR OF STEEMFEST 2018
8 **/
9 
10 // File: contracts\configs\RektCoinCashConfig.sol
11 
12 
13 /**
14  * @title RektCoinCashConfig
15  *
16  * @dev The static configuration for the RektCoin.cash.
17  */
18 contract RektCoinCashConfig {
19     // The name of the token.
20     string constant NAME = "RektCoin.Cash";
21 
22     // The symbol of the token.
23     string constant SYMBOL = "RKTC";
24 
25     // The number of decimals for the token.
26     uint8 constant DECIMALS = 18;  // Same as ethers.
27 
28     // Decimal factor for multiplication purposes.
29     uint constant DECIMALS_FACTOR = 10 ** uint(DECIMALS);
30 }
31 
32 // File: contracts\interfaces\ERC20TokenInterface.sol
33 
34 /**
35  * @dev The standard ERC20 Token interface.
36  */
37 contract ERC20TokenInterface {
38     uint public totalSupply;  /* shorthand for public function and a property */
39     event Transfer(address indexed _from, address indexed _to, uint _value);
40     event Approval(address indexed _owner, address indexed _spender, uint _value);
41     function balanceOf(address _owner) public constant returns (uint balance);
42     function transfer(address _to, uint _value) public returns (bool success);
43     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
44     function approve(address _spender, uint _value) public returns (bool success);
45     function allowance(address _owner, address _spender) public constant returns (uint remaining);
46 
47 }
48 
49 // File: contracts\libraries\SafeMath.sol
50 
51 /**
52  * @dev Library that helps prevent integer overflows and underflows,
53  * inspired by https://github.com/OpenZeppelin/zeppelin-solidity
54  */
55 library SafeMath {
56     function plus(uint a, uint b) internal pure returns (uint) {
57         uint c = a + b;
58         assert(c >= a);
59 
60         return c;
61     }
62 
63     function minus(uint a, uint b) internal pure returns (uint) {
64         assert(b <= a);
65 
66         return a - b;
67     }
68 
69     function mul(uint a, uint b) internal pure returns (uint) {
70         uint c = a * b;
71         assert(a == 0 || c / a == b);
72 
73         return c;
74     }
75 
76     function div(uint a, uint b) internal pure returns (uint) {
77         uint c = a / b;
78 
79         return c;
80     }
81 }
82 
83 // File: contracts\traits\ERC20Token.sol
84 
85 /**
86  * @title ERC20Token
87  *
88  * @dev Implements the operations declared in the `ERC20TokenInterface`.
89  */
90 contract ERC20Token is ERC20TokenInterface {
91     using SafeMath for uint;
92 
93     // Token account balances.
94     mapping (address => uint) balances;
95 
96     // Delegated number of tokens to transfer.
97     mapping (address => mapping (address => uint)) allowed;
98 
99 
100 
101     /**
102      * @dev Checks the balance of a certain address.
103      *
104      * @param _account The address which's balance will be checked.
105      *
106      * @return Returns the balance of the `_account` address.
107      */
108     function balanceOf(address _account) public constant returns (uint balance) {
109         return balances[_account];
110     }
111 
112     /**
113      * @dev Transfers tokens from one address to another.
114      *
115      * @param _to The target address to which the `_value` number of tokens will be sent.
116      * @param _value The number of tokens to send.
117      *
118      * @return Whether the transfer was successful or not.
119      */
120     function transfer(address _to, uint _value) public returns (bool success) {
121         if (balances[msg.sender] < _value || _value == 0) {
122 
123             return false;
124         }
125 
126         balances[msg.sender] -= _value;
127         balances[_to] = balances[_to].plus(_value);
128 
129 
130         Transfer(msg.sender, _to, _value);
131 
132         return true;
133     }
134 
135     /**
136      * @dev Send `_value` tokens to `_to` from `_from` if `_from` has approved the process.
137      *
138      * @param _from The address of the sender.
139      * @param _to The address of the recipient.
140      * @param _value The number of tokens to be transferred.
141      *
142      * @return Whether the transfer was successful or not.
143      */
144     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
145         if (balances[_from] < _value || allowed[_from][msg.sender] < _value || _value == 0) {
146             return false;
147         }
148 
149         balances[_to] = balances[_to].plus(_value);
150         balances[_from] -= _value;
151         allowed[_from][msg.sender] -= _value;
152 
153 
154         Transfer(_from, _to, _value);
155 
156         return true;
157     }
158 
159     /**
160      * @dev Allows another contract to spend some tokens on your behalf.
161      *
162      * @param _spender The address of the account which will be approved for transfer of tokens.
163      * @param _value The number of tokens to be approved for transfer.
164      *
165      * @return Whether the approval was successful or not.
166      */
167     function approve(address _spender, uint _value) public returns (bool success) {
168         allowed[msg.sender][_spender] = _value;
169 
170         Approval(msg.sender, _spender, _value);
171 
172         return true;
173     }
174 
175     /**
176      * @dev Shows the number of tokens approved by `_owner` that are allowed to be transferred by `_spender`.
177      *
178      * @param _owner The account which allowed the transfer.
179      * @param _spender The account which will spend the tokens.
180      *
181      * @return The number of tokens to be transferred.
182      */
183     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
184         return allowed[_owner][_spender];
185     }
186 }
187 
188 // File: contracts\traits\HasOwner.sol
189 
190 /**
191  * @title HasOwner
192  *
193  * @dev Allows for exclusive access to certain functionality.
194  */
195 contract HasOwner {
196     // Current owner.
197     address public owner;
198 
199     // Conditionally the new owner.
200     address public newOwner;
201 
202     /**
203      * @dev The constructor.
204      *
205      * @param _owner The address of the owner.
206      */
207     function HasOwner(address _owner) internal {
208         owner = _owner;
209     }
210 
211     /**
212      * @dev Access control modifier that allows only the current owner to call the function.
213      */
214     modifier onlyOwner {
215         require(msg.sender == owner);
216         _;
217     }
218 
219     /**
220      * @dev The event is fired when the current owner is changed.
221      *
222      * @param _oldOwner The address of the previous owner.
223      * @param _newOwner The address of the new owner.
224      */
225     event OwnershipTransfer(address indexed _oldOwner, address indexed _newOwner);
226 
227     /**
228      * @dev Transfering the ownership is a two-step process, as we prepare
229      * for the transfer by setting `newOwner` and requiring `newOwner` to accept
230      * the transfer. This prevents accidental lock-out if something goes wrong
231      * when passing the `newOwner` address.
232      *
233      * @param _newOwner The address of the proposed new owner.
234      */
235     function transferOwnership(address _newOwner) public onlyOwner {
236         newOwner = _newOwner;
237     }
238 
239     /**
240      * @dev The `newOwner` finishes the ownership transfer process by accepting the
241      * ownership.
242      */
243     function acceptOwnership() public {
244         require(msg.sender == newOwner);
245 
246         OwnershipTransfer(owner, newOwner);
247 
248         owner = newOwner;
249     }
250 }
251 
252 // File: contracts\traits\Freezable.sol
253 
254 /**
255  * @title Freezable
256  * @dev This trait allows to freeze the transactions in a Token
257  */
258 contract Freezable is HasOwner {
259   bool public frozen = false;
260 
261   /**
262    * @dev Modifier makes methods callable only when the contract is not frozen.
263    */
264   modifier requireNotFrozen() {
265     require(!frozen);
266     _;
267   }
268 
269   /**
270    * @dev Allows the owner to "freeze" the contract.
271    */
272   function freeze() onlyOwner public {
273     frozen = true;
274   }
275 
276   /**
277    * @dev Allows the owner to "unfreeze" the contract.
278    */
279   function unfreeze() onlyOwner public {
280     frozen = false;
281   }
282 }
283 
284 // File: contracts\traits\FreezableERC20Token.sol
285 
286 /**
287  * @title FreezableERC20Token
288  *
289  * @dev Extends ERC20Token and adds ability to freeze all transfers of tokens.
290  */
291 contract FreezableERC20Token is ERC20Token, Freezable {
292     /**
293      * @dev Overrides the original ERC20Token implementation by adding whenNotFrozen modifier.
294      *
295      * @param _to The target address to which the `_value` number of tokens will be sent.
296      * @param _value The number of tokens to send.
297      *
298      * @return Whether the transfer was successful or not.
299      */
300     function transfer(address _to, uint _value) public requireNotFrozen returns (bool success) {
301         return super.transfer(_to, _value);
302     }
303 
304     /**
305      * @dev Send `_value` tokens to `_to` from `_from` if `_from` has approved the process.
306      *
307      * @param _from The address of the sender.
308      * @param _to The address of the recipient.
309      * @param _value The number of tokens to be transferred.
310      *
311      * @return Whether the transfer was successful or not.
312      */
313     function transferFrom(address _from, address _to, uint _value) public requireNotFrozen returns (bool success) {
314         return super.transferFrom(_from, _to, _value);
315     }
316 
317     /**
318      * @dev Allows another contract to spend some tokens on your behalf.
319      *
320      * @param _spender The address of the account which will be approved for transfer of tokens.
321      * @param _value The number of tokens to be approved for transfer.
322      *
323      * @return Whether the approval was successful or not.
324      */
325     function approve(address _spender, uint _value) public requireNotFrozen returns (bool success) {
326         return super.approve(_spender, _value);
327     }
328 
329 }
330 
331 // File: contracts\RektCoinCash.sol
332 
333 /**
334  * @title RektCoin.cash
335  *
336  * @dev A standard token implementation of the ERC20 token standard with added
337  *      HasOwner trait and initialized using the configuration constants.
338  */
339 contract RektCoinCash is RektCoinCashConfig, HasOwner, FreezableERC20Token {
340     // The name of the token.
341     string public name;
342 
343     // The symbol for the token.
344     string public symbol;
345 
346     // The decimals of the token.
347     uint8 public decimals;
348 
349     /**
350      * @dev The constructor. Initially sets `totalSupply` and the balance of the
351      *      `owner` address according to the initialization parameter.
352      */
353     function RektCoinCash(uint _totalSupply) public
354         HasOwner(msg.sender)
355     {
356         name = NAME;
357         symbol = SYMBOL;
358         decimals = DECIMALS;
359         totalSupply = _totalSupply;
360         balances[owner] = _totalSupply;
361     }
362 }
363 
364 // File: contracts\configs\RektCoinCashSponsorfundraiserConfig.sol
365 
366 /**
367  * @title RektCoinCashSponsorfundraiserConfig
368  *
369  * @dev The static configuration for the RektCoin.cash sponsorfundraiser.
370  */
371 contract RektCoinCashSponsorfundraiserConfig is RektCoinCashConfig {
372     // The number of RKTC per 1 ETH.
373     uint constant CONVERSION_RATE = 1000000;
374 
375     // The public sale hard cap of the sponsorfundraiser.
376     uint constant TOKENS_HARD_CAP = 294553323 * DECIMALS_FACTOR;
377 
378     // The start date of the sponsorfundraiser: Sun, 09 Sep 2018 09:09:09 +0000
379     uint constant START_DATE = 1536484149;
380 
381     // The end date of the sponsorfundraiser:  Wed, 07 Nov 2018 19:00:00 +0000 // start of SteemFest 2018 in Kraków
382     uint constant END_DATE =  1541617200;
383 
384     // Maximum gas price limit
385     uint constant MAX_GAS_PRICE = 90000000000 wei; // 90 gwei/shanon
386 
387     // Minimum individual contribution
388     uint constant MIN_CONTRIBUTION =  0.1337 ether;
389 
390     // Individual limit in ether
391     uint constant INDIVIDUAL_ETHER_LIMIT =  1337 ether;
392 }
393 
394 // File: contracts\traits\TokenSafe.sol
395 
396 /**
397  * @title TokenSafe
398  *
399  * @dev A multi-bundle token safe contract that contains locked tokens released after a date for the specific bundle type.
400  */
401 contract TokenSafe {
402     using SafeMath for uint;
403 
404     struct AccountsBundle {
405         // The total number of tokens locked.
406         uint lockedTokens;
407         // The release date for the locked tokens
408         // Note: Unix timestamp fits uint32, however block.timestamp is uint
409         uint releaseDate;
410         // The balances for the RKTC locked token accounts.
411         mapping (address => uint) balances;
412     }
413 
414     // The account bundles of locked tokens grouped by release date
415     mapping (uint8 => AccountsBundle) public bundles;
416 
417     // The `ERC20TokenInterface` contract.
418     ERC20TokenInterface token;
419 
420     /**
421      * @dev The constructor.
422      *
423      * @param _token The address of the RektCoin.cash contract.
424      */
425     function TokenSafe(address _token) public {
426         token = ERC20TokenInterface(_token);
427     }
428 
429 }
430 
431 // File: contracts\RektCoinCashSafe.sol
432 
433 /**
434  * @title RektCoinCashSafe
435  *
436  * @dev The RektCoin.cash safe containing all details about locked tokens.
437  */
438 contract RektCoinCashSafe is TokenSafe, RektCoinCashSponsorfundraiserConfig {
439 
440     /**
441      * @dev The constructor.
442      *
443      * @param _token The address of the RektCoin.cash contract.
444      */
445     function RektCoinCashSafe(address _token) public TokenSafe(_token)
446     {
447         token = ERC20TokenInterface(_token);
448 
449 
450     }
451 
452 
453 }
454 
455 // File: contracts\traits\Whitelist.sol
456 
457 contract Whitelist is HasOwner
458 {
459     // Whitelist mapping
460     mapping(address => bool) public whitelist;
461 
462     /**
463      * @dev The constructor.
464      */
465     function Whitelist(address _owner) public
466         HasOwner(_owner)
467     {
468 
469     }
470 
471     /**
472      * @dev Access control modifier that allows only whitelisted address to call the method.
473      */
474     modifier onlyWhitelisted {
475         require(whitelist[msg.sender]);
476         _;
477     }
478 
479     /**
480      * @dev Internal function that sets whitelist status in batch.
481      *
482      * @param _entries An array with the entries to be updated
483      * @param _status The new status to apply
484      */
485     function setWhitelistEntries(address[] _entries, bool _status) internal {
486         for (uint32 i = 0; i < _entries.length; ++i) {
487             whitelist[_entries[i]] = _status;
488         }
489     }
490 
491     /**
492      * @dev Public function that allows the owner to whitelist multiple entries
493      *
494      * @param _entries An array with the entries to be whitelisted
495      */
496     function whitelistAddresses(address[] _entries) public onlyOwner {
497         setWhitelistEntries(_entries, true);
498     }
499 
500     /**
501      * @dev Public function that allows the owner to blacklist multiple entries
502      *
503      * @param _entries An array with the entries to be blacklist
504      */
505     function blacklistAddresses(address[] _entries) public onlyOwner {
506         setWhitelistEntries(_entries, false);
507     }
508 }
509 
510 // File: contracts\RektCoinCashSponsorfundraiser.sol
511 
512 /**
513  * @title RektCoinCashSponsorfundraiser
514  *
515  * @dev The RektCoin.cash sponsorfundraiser contract.
516  */
517 contract RektCoinCashSponsorfundraiser is RektCoinCash, RektCoinCashSponsorfundraiserConfig, Whitelist {
518     // Indicates whether the sponsorfundraiser has ended or not.
519     bool public finalized = false;
520 
521     // The address of the account which will receive the funds gathered by the sponsorfundraiser.
522     address public beneficiary;
523 
524     // The number of RKTC participants will receive per 1 ETH.
525     uint public conversionRate;
526 
527     // Sponsorfundraiser start date.
528     uint public startDate;
529 
530     // Sponsorfundraiser end date.
531     uint public endDate;
532 
533     // Sponsorfundraiser tokens hard cap.
534     uint public hardCap;
535 
536     // The `RektCoinCashSafe` contract.
537     RektCoinCashSafe public rektCoinCashSafe;
538 
539     // The minimum amount of ether allowed in the public sale
540     uint internal minimumContribution;
541 
542     // The maximum amount of ether allowed per address
543     uint internal individualLimit;
544 
545     // Number of tokens sold during the sponsorfundraiser.
546     uint private tokensSold;
547 
548 
549 
550     /**
551      * @dev The event fires every time a new buyer enters the sponsorfundraiser.
552      *
553      * @param _address The address of the buyer.
554      * @param _ethers The number of ethers sent.
555      * @param _tokens The number of tokens received by the buyer.
556      * @param _newTotalSupply The updated total number of tokens currently in circulation.
557      * @param _conversionRate The conversion rate at which the tokens were bought.
558      */
559     event FundsReceived(address indexed _address, uint _ethers, uint _tokens, uint _newTotalSupply, uint _conversionRate);
560 
561     /**
562      * @dev The event fires when the beneficiary of the sponsorfundraiser is changed.
563      *
564      * @param _beneficiary The address of the new beneficiary.
565      */
566     event BeneficiaryChange(address _beneficiary);
567 
568     /**
569      * @dev The event fires when the number of RKTC per 1 ETH is changed.
570      *
571      * @param _conversionRate The new number of RKTC per 1 ETH.
572      */
573     event ConversionRateChange(uint _conversionRate);
574 
575     /**
576      * @dev The event fires when the sponsorfundraiser is successfully finalized.
577      *
578      * @param _beneficiary The address of the beneficiary.
579      * @param _ethers The number of ethers transfered to the beneficiary.
580      * @param _totalSupply The total number of tokens in circulation.
581      */
582     event Finalized(address _beneficiary, uint _ethers, uint _totalSupply);
583 
584     /**
585      * @dev The constructor.
586      *
587      * @param _beneficiary The address which will receive the funds gathered by the sponsorfundraiser.
588      */
589     function RektCoinCashSponsorfundraiser(address _beneficiary) public
590         RektCoinCash(0)
591         Whitelist(msg.sender)
592     {
593         require(_beneficiary != 0);
594 
595         beneficiary = _beneficiary;
596         conversionRate = CONVERSION_RATE;
597         startDate = START_DATE;
598         endDate = END_DATE;
599         hardCap = TOKENS_HARD_CAP;
600         tokensSold = 0;
601         minimumContribution = MIN_CONTRIBUTION;
602         individualLimit = INDIVIDUAL_ETHER_LIMIT * CONVERSION_RATE;
603 
604         rektCoinCashSafe = new RektCoinCashSafe(this);
605 
606         // Freeze the transfers for the duration of the sponsorfundraiser. Removed this, you can immediately transfer your RKTC to any ether address you like!
607         // freeze();
608     }
609 
610     /**
611      * @dev Changes the beneficiary of the sponsorfundraiser.
612      *
613      * @param _beneficiary The address of the new beneficiary.
614      */
615     function setBeneficiary(address _beneficiary) public onlyOwner {
616         require(_beneficiary != 0);
617 
618         beneficiary = _beneficiary;
619 
620         BeneficiaryChange(_beneficiary);
621     }
622 
623     /**
624      * @dev Sets converstion rate of 1 ETH to RKTC. Can only be changed before the sponsorfundraiser starts.
625      *
626      * @param _conversionRate The new number of RektCoin.cashs per 1 ETH.
627      */
628     function setConversionRate(uint _conversionRate) public onlyOwner {
629         require(now < startDate);
630         require(_conversionRate > 0);
631 
632         conversionRate = _conversionRate;
633         individualLimit = INDIVIDUAL_ETHER_LIMIT * _conversionRate;
634 
635         ConversionRateChange(_conversionRate);
636     }
637 
638 
639 
640     /**
641      * @dev The default function which will fire every time someone sends ethers to this contract's address.
642      */
643     function() public payable {
644         buyTokens();
645     }
646 
647     /**
648      * @dev Creates new tokens based on the number of ethers sent and the conversion rate.
649      */
650     //function buyTokens() public payable onlyWhitelisted {
651     function buyTokens() public payable {
652         require(!finalized);
653         require(now >= startDate);
654         require(now <= endDate);
655         require(tx.gasprice <= MAX_GAS_PRICE);  // gas price limit
656         require(msg.value >= minimumContribution);  // required minimum contribution
657         require(tokensSold <= hardCap);
658 
659         // Calculate the number of tokens the buyer will receive.
660         uint tokens = msg.value.mul(conversionRate);
661         balances[msg.sender] = balances[msg.sender].plus(tokens);
662 
663         // Ensure that the individual contribution limit has not been reached
664         require(balances[msg.sender] <= individualLimit);
665 
666 
667 
668         tokensSold = tokensSold.plus(tokens);
669         totalSupply = totalSupply.plus(tokens);
670 
671         Transfer(0x0, msg.sender, tokens);
672 
673         FundsReceived(
674             msg.sender,
675             msg.value,
676             tokens,
677             totalSupply,
678             conversionRate
679         );
680     }
681 
682 
683 
684     /**
685      * @dev Finalize the sponsorfundraiser if `endDate` has passed or if `hardCap` is reached.
686      */
687     function finalize() public onlyOwner {
688         require((totalSupply >= hardCap) || (now >= endDate));
689         require(!finalized);
690 
691         address contractAddress = this;
692         Finalized(beneficiary, contractAddress.balance, totalSupply);
693 
694         /// Send the total number of ETH gathered to the beneficiary.
695         beneficiary.transfer(contractAddress.balance);
696 
697         /// Finalize the sponsorfundraiser. Keep in mind that this cannot be undone.
698         finalized = true;
699 
700         // Unfreeze transfers
701         unfreeze();
702     }
703 
704     /**
705      * @dev allow owner to collect balance of contract during donation period
706      */
707 
708     function collect() public onlyOwner {
709 
710         address contractAddress = this;
711         /// Send the total number of ETH gathered to the beneficiary.
712         beneficiary.transfer(contractAddress.balance);
713 
714     }
715 }