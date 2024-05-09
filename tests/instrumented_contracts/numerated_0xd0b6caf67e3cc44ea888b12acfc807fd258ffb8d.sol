1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // ERC20Interface - Standard ERC20 Interface Definition
5 // Enuma Blockchain Platform
6 //
7 // Copyright (c) 2017 Enuma Technologies Limited.
8 // https://www.enuma.io/
9 // ----------------------------------------------------------------------------
10 
11 // ----------------------------------------------------------------------------
12 // Based on the final ERC20 specification at:
13 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
14 // ----------------------------------------------------------------------------
15 contract ERC20Interface {
16 
17    event Transfer(address indexed _from, address indexed _to, uint256 _value);
18    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20    function name() public view returns (string);
21    function symbol() public view returns (string);
22    function decimals() public view returns (uint8);
23    function totalSupply() public view returns (uint256);
24 
25    function balanceOf(address _owner) public view returns (uint256 balance);
26    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
27 
28    function transfer(address _to, uint256 _value) public returns (bool success);
29    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30    function approve(address _spender, uint256 _value) public returns (bool success);
31 }
32 
33 // ----------------------------------------------------------------------------
34 // Math - General Math Utility Library
35 // Enuma Blockchain Platform
36 //
37 // Copyright (c) 2017 Enuma Technologies Limited.
38 // https://www.enuma.io/
39 // ----------------------------------------------------------------------------
40 
41 
42 library Math {
43 
44    function add(uint256 a, uint256 b) internal pure returns (uint256) {
45       uint256 r = a + b;
46 
47       require(r >= a);
48 
49       return r;
50    }
51 
52 
53    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54       require(a >= b);
55 
56       return a - b;
57    }
58 
59 
60    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61       if (a == 0) {
62          return 0;
63       }
64 
65       uint256 r = a * b;
66 
67       require(r / a == b);
68 
69       return r;
70    }
71 
72 
73    function div(uint256 a, uint256 b) internal pure returns (uint256) {
74       return a / b;
75    }
76 }
77 
78 // ----------------------------------------------------------------------------
79 // Owned - Ownership model with 2 phase transfers
80 // Enuma Blockchain Platform
81 //
82 // Copyright (c) 2017 Enuma Technologies Limited.
83 // https://www.enuma.io/
84 // ----------------------------------------------------------------------------
85 
86 
87 // Implements a simple ownership model with 2-phase transfer.
88 contract Owned {
89 
90    address public owner;
91    address public proposedOwner;
92 
93    event OwnershipTransferInitiated(address indexed _proposedOwner);
94    event OwnershipTransferCompleted(address indexed _newOwner);
95 
96 
97    constructor() public
98    {
99       owner = msg.sender;
100    }
101 
102 
103    modifier onlyOwner() {
104       require(isOwner(msg.sender) == true);
105       _;
106    }
107 
108 
109    function isOwner(address _address) public view returns (bool) {
110       return (_address == owner);
111    }
112 
113 
114    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
115       require(_proposedOwner != address(0));
116       require(_proposedOwner != address(this));
117       require(_proposedOwner != owner);
118 
119       proposedOwner = _proposedOwner;
120 
121       emit OwnershipTransferInitiated(proposedOwner);
122 
123       return true;
124    }
125 
126 
127    function completeOwnershipTransfer() public returns (bool) {
128       require(msg.sender == proposedOwner);
129 
130       owner = msg.sender;
131       proposedOwner = address(0);
132 
133       emit OwnershipTransferCompleted(owner);
134 
135       return true;
136    }
137 }
138 
139 // ----------------------------------------------------------------------------
140 // Finalizable - Basic implementation of the finalization pattern
141 // Enuma Blockchain Platform
142 //
143 // Copyright (c) 2017 Enuma Technologies Limited.
144 // https://www.enuma.io/
145 // ----------------------------------------------------------------------------
146 
147 
148 contract Finalizable is Owned() {
149 
150    bool public finalized;
151 
152    event Finalized();
153 
154 
155    constructor() public
156    {
157       finalized = false;
158    }
159 
160 
161    function finalize() public onlyOwner returns (bool) {
162       require(!finalized);
163 
164       finalized = true;
165 
166       emit Finalized();
167 
168       return true;
169    }
170 }
171 
172 // ----------------------------------------------------------------------------
173 // OpsManaged - Implements an Owner and Ops Permission Model
174 // Enuma Blockchain Platform
175 //
176 // Copyright (c) 2017 Enuma Technologies Limited.
177 // https://www.enuma.io/
178 // ----------------------------------------------------------------------------
179 
180 
181 
182 //
183 // Implements a security model with owner and ops.
184 //
185 contract OpsManaged is Owned() {
186 
187    address public opsAddress;
188 
189    event OpsAddressUpdated(address indexed _newAddress);
190 
191 
192    constructor() public
193    {
194    }
195 
196 
197    modifier onlyOwnerOrOps() {
198       require(isOwnerOrOps(msg.sender));
199       _;
200    }
201 
202 
203    function isOps(address _address) public view returns (bool) {
204       return (opsAddress != address(0) && _address == opsAddress);
205    }
206 
207 
208    function isOwnerOrOps(address _address) public view returns (bool) {
209       return (isOwner(_address) || isOps(_address));
210    }
211 
212 
213    function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool) {
214       require(_newOpsAddress != owner);
215       require(_newOpsAddress != address(this));
216 
217       opsAddress = _newOpsAddress;
218 
219       emit OpsAddressUpdated(opsAddress);
220 
221       return true;
222    }
223 }
224 
225 // ----------------------------------------------------------------------------
226 // ERC20Token - Standard ERC20 Implementation
227 // Enuma Blockchain Platform
228 //
229 // Copyright (c) 2017 Enuma Technologies Limited.
230 // https://www.enuma.io/
231 // ----------------------------------------------------------------------------
232 
233 
234 contract ERC20Token is ERC20Interface {
235 
236    using Math for uint256;
237 
238    string  private tokenName;
239    string  private tokenSymbol;
240    uint8   private tokenDecimals;
241    uint256 internal tokenTotalSupply;
242 
243    mapping(address => uint256) internal balances;
244    mapping(address => mapping (address => uint256)) allowed;
245 
246 
247    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {
248       tokenName = _name;
249       tokenSymbol = _symbol;
250       tokenDecimals = _decimals;
251       tokenTotalSupply = _totalSupply;
252 
253       // The initial balance of tokens is assigned to the given token holder address.
254       balances[_initialTokenHolder] = _totalSupply;
255 
256       // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.
257       emit Transfer(0x0, _initialTokenHolder, _totalSupply);
258    }
259 
260 
261    function name() public view returns (string) {
262       return tokenName;
263    }
264 
265 
266    function symbol() public view returns (string) {
267       return tokenSymbol;
268    }
269 
270 
271    function decimals() public view returns (uint8) {
272       return tokenDecimals;
273    }
274 
275 
276    function totalSupply() public view returns (uint256) {
277       return tokenTotalSupply;
278    }
279 
280 
281    function balanceOf(address _owner) public view returns (uint256 balance) {
282       return balances[_owner];
283    }
284 
285 
286    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
287       return allowed[_owner][_spender];
288    }
289 
290 
291    function transfer(address _to, uint256 _value) public returns (bool success) {
292       balances[msg.sender] = balances[msg.sender].sub(_value);
293       balances[_to] = balances[_to].add(_value);
294 
295       emit Transfer(msg.sender, _to, _value);
296 
297       return true;
298    }
299 
300 
301    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
302       balances[_from] = balances[_from].sub(_value);
303       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
304       balances[_to] = balances[_to].add(_value);
305 
306       emit Transfer(_from, _to, _value);
307 
308       return true;
309    }
310 
311 
312    function approve(address _spender, uint256 _value) public returns (bool success) {
313       allowed[msg.sender][_spender] = _value;
314 
315       emit Approval(msg.sender, _spender, _value);
316 
317       return true;
318    }
319 }
320 
321 // ----------------------------------------------------------------------------
322 // FinalizableToken - Extension to ERC20Token with ops and finalization
323 // Enuma Blockchain Platform
324 //
325 // Copyright (c) 2017 Enuma Technologies Limited.
326 // https://www.enuma.io/
327 // ----------------------------------------------------------------------------
328 
329 
330 //
331 // ERC20 token with the following additions:
332 //    1. Owner/Ops Ownership
333 //    2. Finalization
334 //
335 contract FinalizableToken is ERC20Token, OpsManaged, Finalizable {
336 
337    using Math for uint256;
338 
339 
340    // The constructor will assign the initial token supply to the owner (msg.sender).
341    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public
342       ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)
343       OpsManaged()
344       Finalizable()
345    {
346    }
347 
348 
349    function transfer(address _to, uint256 _value) public returns (bool success) {
350       validateTransfer(msg.sender, _to);
351 
352       return super.transfer(_to, _value);
353    }
354 
355 
356    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
357       validateTransfer(msg.sender, _to);
358 
359       return super.transferFrom(_from, _to, _value);
360    }
361 
362 
363    function validateTransfer(address _sender, address _to) private view {
364       // Once the token is finalized, everybody can transfer tokens.
365       if (finalized) {
366          return;
367       }
368 
369       if (isOwner(_to)) {
370          return;
371       }
372 
373       // Before the token is finalized, only owner and ops are allowed to initiate transfers.
374       // This allows them to move tokens while the sale is still ongoing for example.
375       require(isOwnerOrOps(_sender));
376    }
377 }
378 
379 
380 
381 // ----------------------------------------------------------------------------
382 // FlexibleTokenSale - Token Sale Contract
383 // Enuma Blockchain Platform
384 //
385 // Copyright (c) 2017 Enuma Technologies Limited.
386 // https://www.enuma.io/
387 // ----------------------------------------------------------------------------
388 
389 
390 contract FlexibleTokenSale is Finalizable, OpsManaged {
391 
392    using Math for uint256;
393 
394    //
395    // Lifecycle
396    //
397    uint256 public startTime;
398    uint256 public endTime;
399    bool public suspended;
400 
401    //
402    // Pricing
403    //
404    uint256 public tokensPerKEther;
405    uint256 public bonus;
406    uint256 public maxTokensPerAccount;
407    uint256 public contributionMin;
408    uint256 public tokenConversionFactor;
409 
410    //
411    // Wallets
412    //
413    address public walletAddress;
414 
415    //
416    // Token
417    //
418    FinalizableToken public token;
419 
420    //
421    // Counters
422    //
423    uint256 public totalTokensSold;
424    uint256 public totalEtherCollected;
425 
426 
427    //
428    // Events
429    //
430    event Initialized();
431    event TokensPerKEtherUpdated(uint256 _newValue);
432    event MaxTokensPerAccountUpdated(uint256 _newMax);
433    event BonusUpdated(uint256 _newValue);
434    event SaleWindowUpdated(uint256 _startTime, uint256 _endTime);
435    event WalletAddressUpdated(address _newAddress);
436    event SaleSuspended();
437    event SaleResumed();
438    event TokensPurchased(address _beneficiary, uint256 _cost, uint256 _tokens);
439    event TokensReclaimed(uint256 _amount);
440 
441 
442    constructor(uint256 _startTime, uint256 _endTime, address _walletAddress) public
443       OpsManaged()
444    {
445       require(_endTime > _startTime);
446 
447       require(_walletAddress != address(0));
448       require(_walletAddress != address(this));
449 
450       walletAddress = _walletAddress;
451 
452       finalized = false;
453       suspended = false;
454 
455       startTime = _startTime;
456       endTime   = _endTime;
457 
458       // Use some defaults config values. Classes deriving from FlexibleTokenSale
459       // should set their own defaults
460       tokensPerKEther     = 100000;
461       bonus               = 0;
462       maxTokensPerAccount = 0;
463       contributionMin     = 0.1 ether;
464 
465       totalTokensSold     = 0;
466       totalEtherCollected = 0;
467    }
468 
469 
470    function currentTime() public constant returns (uint256) {
471       return now;
472    }
473 
474 
475    // Initialize should be called by the owner as part of the deployment + setup phase.
476    // It will associate the sale contract with the token contract and perform basic checks.
477    function initialize(FinalizableToken _token) external onlyOwner returns(bool) {
478       require(address(token) == address(0));
479       require(address(_token) != address(0));
480       require(address(_token) != address(this));
481       require(address(_token) != address(walletAddress));
482       require(isOwnerOrOps(address(_token)) == false);
483 
484       token = _token;
485 
486       // This factor is used when converting cost <-> tokens.
487       // 18 is because of the ETH -> Wei conversion.
488       // 3 because prices are in K ETH instead of just ETH.
489       // 4 because bonuses are expressed as 0 - 10000 for 0.00% - 100.00% (with 2 decimals).
490       tokenConversionFactor = 10**(uint256(18).sub(_token.decimals()).add(3).add(4));
491       require(tokenConversionFactor > 0);
492 
493       emit Initialized();
494 
495       return true;
496    }
497 
498 
499    //
500    // Owner Configuation
501    //
502 
503    // Allows the owner to change the wallet address which is used for collecting
504    // ether received during the token sale.
505    function setWalletAddress(address _walletAddress) external onlyOwner returns(bool) {
506       require(_walletAddress != address(0));
507       require(_walletAddress != address(this));
508       require(_walletAddress != address(token));
509       require(isOwnerOrOps(_walletAddress) == false);
510 
511       walletAddress = _walletAddress;
512 
513       emit WalletAddressUpdated(_walletAddress);
514 
515       return true;
516    }
517 
518 
519    // Allows the owner to set an optional limit on the amount of tokens that can be purchased
520    // by a contributor. It can also be set to 0 to remove limit.
521    function setMaxTokensPerAccount(uint256 _maxTokens) external onlyOwner returns(bool) {
522 
523       maxTokensPerAccount = _maxTokens;
524 
525       emit MaxTokensPerAccountUpdated(_maxTokens);
526 
527       return true;
528    }
529 
530 
531    // Allows the owner to specify the conversion rate for ETH -> tokens.
532    // For example, passing 1,000,000 would mean that 1 ETH would purchase 1000 tokens.
533    function setTokensPerKEther(uint256 _tokensPerKEther) external onlyOwner returns(bool) {
534       require(_tokensPerKEther > 0);
535 
536       tokensPerKEther = _tokensPerKEther;
537 
538       emit TokensPerKEtherUpdated(_tokensPerKEther);
539 
540       return true;
541    }
542 
543 
544    // Allows the owner to set a bonus to apply to all purchases.
545    // For example, setting it to 2000 means that instead of receiving 200 tokens,
546    // for a given price, contributors would receive 240 tokens (20.00% bonus).
547    function setBonus(uint256 _bonus) external onlyOwner returns(bool) {
548       require(_bonus <= 10000);
549 
550       bonus = _bonus;
551 
552       emit BonusUpdated(_bonus);
553 
554       return true;
555    }
556 
557 
558    // Allows the owner to set a sale window which will allow the sale (aka buyTokens) to
559    // receive contributions between _startTime and _endTime. Once _endTime is reached,
560    // the sale contract will automatically stop accepting incoming contributions.
561    function setSaleWindow(uint256 _startTime, uint256 _endTime) external onlyOwner returns(bool) {
562       require(_startTime > 0);
563       require(_endTime > _startTime);
564 
565       startTime = _startTime;
566       endTime   = _endTime;
567 
568       emit SaleWindowUpdated(_startTime, _endTime);
569 
570       return true;
571    }
572 
573 
574    // Allows the owner to suspend the sale until it is manually resumed at a later time.
575    function suspend() external onlyOwner returns(bool) {
576       if (suspended == true) {
577           return false;
578       }
579 
580       suspended = true;
581 
582       emit SaleSuspended();
583 
584       return true;
585    }
586 
587 
588    // Allows the owner to resume the sale.
589    function resume() external onlyOwner returns(bool) {
590       if (suspended == false) {
591           return false;
592       }
593 
594       suspended = false;
595 
596       emit SaleResumed();
597 
598       return true;
599    }
600 
601 
602    //
603    // Contributions
604    //
605 
606    // Default payable function which can be used to purchase tokens.
607    function () payable public {
608       buyTokens(msg.sender);
609    }
610 
611 
612    // Allows the caller to purchase tokens for a specific beneficiary (proxy purchase).
613    function buyTokens(address _beneficiary) public payable returns (uint256) {
614       return buyTokensInternal(_beneficiary, bonus);
615    }
616 
617 
618    function buyTokensInternal(address _beneficiary, uint256 _bonus) internal returns (uint256) {
619       require(!finalized);
620       require(!suspended);
621       require(currentTime() >= startTime);
622       require(currentTime() <= endTime);
623       require(msg.value >= contributionMin);
624       require(_beneficiary != address(0));
625       require(_beneficiary != address(this));
626       require(_beneficiary != address(token));
627 
628       // We don't want to allow the wallet collecting ETH to
629       // directly be used to purchase tokens.
630       require(msg.sender != address(walletAddress));
631 
632       // Check how many tokens are still available for sale.
633       uint256 saleBalance = token.balanceOf(address(this));
634       require(saleBalance > 0);
635 
636       // Calculate how many tokens the contributor could purchase based on ETH received.
637       uint256 tokens = msg.value.mul(tokensPerKEther).mul(_bonus.add(10000)).div(tokenConversionFactor);
638       require(tokens > 0);
639 
640       uint256 cost = msg.value;
641       uint256 refund = 0;
642 
643       // Calculate what is the maximum amount of tokens that the contributor
644       // should be allowed to purchase
645       uint256 maxTokens = saleBalance;
646 
647       if (maxTokensPerAccount > 0) {
648          // There is a maximum amount of tokens per account in place.
649          // Check if the user already hit that limit.
650          uint256 userBalance = getUserTokenBalance(_beneficiary);
651          require(userBalance < maxTokensPerAccount);
652 
653          uint256 quotaBalance = maxTokensPerAccount.sub(userBalance);
654 
655          if (quotaBalance < saleBalance) {
656             maxTokens = quotaBalance;
657          }
658       }
659 
660       require(maxTokens > 0);
661 
662       if (tokens > maxTokens) {
663          // The contributor sent more ETH than allowed to purchase.
664          // Limit the amount of tokens that they can purchase in this transaction.
665          tokens = maxTokens;
666 
667          // Calculate the actual cost for that new amount of tokens.
668          cost = tokens.mul(tokenConversionFactor).div(tokensPerKEther.mul(_bonus.add(10000)));
669 
670          if (msg.value > cost) {
671             // If the contributor sent more ETH than needed to buy the tokens,
672             // the balance should be refunded.
673             refund = msg.value.sub(cost);
674          }
675       }
676 
677       // This is the actual amount of ETH that can be sent to the wallet.
678       uint256 contribution = msg.value.sub(refund);
679       walletAddress.transfer(contribution);
680 
681       // Update our stats counters.
682       totalTokensSold     = totalTokensSold.add(tokens);
683       totalEtherCollected = totalEtherCollected.add(contribution);
684 
685       // Transfer tokens to the beneficiary.
686       require(token.transfer(_beneficiary, tokens));
687 
688       // Issue a refund for the excess ETH, as needed.
689       if (refund > 0) {
690          msg.sender.transfer(refund);
691       }
692 
693       emit TokensPurchased(_beneficiary, cost, tokens);
694 
695       return tokens;
696    }
697 
698 
699    // Returns the number of tokens that the user has purchased. Will be checked against the
700    // maximum allowed. Can be overriden in a sub class to change the calculations.
701    function getUserTokenBalance(address _beneficiary) internal view returns (uint256) {
702       return token.balanceOf(_beneficiary);
703    }
704 
705 
706    // Allows the owner to take back the tokens that are assigned to the sale contract.
707    function reclaimTokens() external onlyOwner returns (bool) {
708       uint256 tokens = token.balanceOf(address(this));
709 
710       if (tokens == 0) {
711          return false;
712       }
713 
714       address tokenOwner = token.owner();
715       require(tokenOwner != address(0));
716 
717       require(token.transfer(tokenOwner, tokens));
718 
719       emit TokensReclaimed(tokens);
720 
721       return true;
722    }
723 }
724 
725 
726 // ----------------------------------------------------------------------------
727 // CaspianTokenConfig - Token Contract Configuration
728 //
729 // Copyright (c) 2018 Caspian, Limited (TM).
730 // http://www.caspian.tech/
731 // ----------------------------------------------------------------------------
732 
733 
734 contract CaspianTokenConfig {
735 
736     string  public constant TOKEN_SYMBOL      = "CSP";
737     string  public constant TOKEN_NAME        = "Caspian Token";
738     uint8   public constant TOKEN_DECIMALS    = 18;
739 
740     uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);
741     uint256 public constant TOKEN_TOTALSUPPLY = 1000000000 * DECIMALSFACTOR;
742 }
743 
744 
745 
746 // ----------------------------------------------------------------------------
747 // CaspianTokenSaleConfig - Token Sale Configuration
748 //
749 // Copyright (c) 2018 Caspian, Limited (TM).
750 // http://www.caspian.tech/
751 // ----------------------------------------------------------------------------
752 
753 
754 contract CaspianTokenSaleConfig is CaspianTokenConfig {
755 
756     //
757     // Time
758     //
759     uint256 public constant INITIAL_STARTTIME    = 1538553600; // 2018-10-03, 08:00:00 UTC
760     uint256 public constant INITIAL_ENDTIME      = 1538726400; // 2018-10-05, 08:00:00 UTC
761 
762 
763     //
764     // Purchases
765     //
766 
767     // Minimum amount of ETH that can be used for purchase.
768     uint256 public constant CONTRIBUTION_MIN     = 0.5 ether;
769 
770     // Price of tokens, based on the 1 ETH = 4000 CSP conversion ratio.
771     uint256 public constant TOKENS_PER_KETHER    = 4000000;
772 
773     // Amount of bonus applied to the sale. 2000 = 20.00% bonus, 750 = 7.50% bonus, 0 = no bonus.
774     uint256 public constant BONUS                = 0;
775 
776     // Maximum amount of tokens that can be purchased for each account. 0 for no maximum.
777     uint256 public constant TOKENS_ACCOUNT_MAX   = 400000 * DECIMALSFACTOR; // 100 ETH Max
778 }
779 
780 
781 // ----------------------------------------------------------------------------
782 // CaspianTokenSale - Token Sale Contract
783 //
784 // Copyright (c) 2018 Caspian, Limited (TM).
785 // http://www.caspian.tech/
786 //
787 // Based on code from Enuma Technologies.
788 // Copyright (c) 2017 Enuma Technologies Limited.
789 // ----------------------------------------------------------------------------
790 
791 
792 contract CaspianTokenSale is FlexibleTokenSale, CaspianTokenSaleConfig {
793 
794    //
795    // Whitelist
796    //
797    uint8 public currentPhase;
798 
799    mapping(address => uint8) public whitelist;
800 
801 
802    //
803    // Events
804    //
805    event WhitelistUpdated(address indexed _account, uint8 _phase);
806 
807 
808    constructor(address wallet) public
809       FlexibleTokenSale(INITIAL_STARTTIME, INITIAL_ENDTIME, wallet)
810    {
811       tokensPerKEther     = TOKENS_PER_KETHER;
812       bonus               = BONUS;
813       maxTokensPerAccount = TOKENS_ACCOUNT_MAX;
814       contributionMin     = CONTRIBUTION_MIN;
815       currentPhase        = 1;
816    }
817 
818 
819    // Allows the owner or ops to add/remove people from the whitelist.
820    function updateWhitelist(address _address, uint8 _phase) external onlyOwnerOrOps returns (bool) {
821       return updateWhitelistInternal(_address, _phase);
822    }
823 
824 
825    function updateWhitelistInternal(address _address, uint8 _phase) internal returns (bool) {
826       require(_address != address(0));
827       require(_address != address(this));
828       require(_address != walletAddress);
829       require(_phase <= 1);
830 
831       whitelist[_address] = _phase;
832 
833       emit WhitelistUpdated(_address, _phase);
834 
835       return true;
836    }
837 
838 
839    // Allows the owner or ops to add/remove people from the whitelist, in batches.
840    function updateWhitelistBatch(address[] _addresses, uint8 _phase) external onlyOwnerOrOps returns (bool) {
841       require(_addresses.length > 0);
842 
843       for (uint256 i = 0; i < _addresses.length; i++) {
844          require(updateWhitelistInternal(_addresses[i], _phase));
845       }
846 
847       return true;
848    }
849 
850 
851    // This is an extension to the buyToken function in FlexibleTokenSale which also takes
852    // care of checking contributors against the whitelist. Since buyTokens supports proxy payments
853    // we check that both the sender and the beneficiary have been whitelisted.
854    function buyTokensInternal(address _beneficiary, uint256 _bonus) internal returns (uint256) {
855       require(whitelist[msg.sender] >= currentPhase);
856       require(whitelist[_beneficiary] >= currentPhase);
857 
858       return super.buyTokensInternal(_beneficiary, _bonus);
859    }
860 }