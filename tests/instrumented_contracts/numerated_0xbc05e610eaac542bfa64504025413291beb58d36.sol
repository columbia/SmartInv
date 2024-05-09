1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Owned - Ownership model with 2 phase transfers
5 // Enuma Blockchain Platform
6 //
7 // Copyright (c) 2017 Enuma Technologies.
8 // https://www.enuma.io/
9 // ----------------------------------------------------------------------------
10 
11 
12 // Implements a simple ownership model with 2-phase transfer.
13 contract Owned {
14 
15    address public owner;
16    address public proposedOwner;
17 
18    event OwnershipTransferInitiated(address indexed _proposedOwner);
19    event OwnershipTransferCompleted(address indexed _newOwner);
20    event OwnershipTransferCanceled();
21 
22 
23    function Owned() public
24    {
25       owner = msg.sender;
26    }
27 
28 
29    modifier onlyOwner() {
30       require(isOwner(msg.sender) == true);
31       _;
32    }
33 
34 
35    function isOwner(address _address) public view returns (bool) {
36       return (_address == owner);
37    }
38 
39 
40    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
41       require(_proposedOwner != address(0));
42       require(_proposedOwner != address(this));
43       require(_proposedOwner != owner);
44 
45       proposedOwner = _proposedOwner;
46 
47       OwnershipTransferInitiated(proposedOwner);
48 
49       return true;
50    }
51 
52 
53    function cancelOwnershipTransfer() public onlyOwner returns (bool) {
54       if (proposedOwner == address(0)) {
55          return true;
56       }
57 
58       proposedOwner = address(0);
59 
60       OwnershipTransferCanceled();
61 
62       return true;
63    }
64 
65 
66    function completeOwnershipTransfer() public returns (bool) {
67       require(msg.sender == proposedOwner);
68 
69       owner = msg.sender;
70       proposedOwner = address(0);
71 
72       OwnershipTransferCompleted(owner);
73 
74       return true;
75    }
76 }
77 
78 // ----------------------------------------------------------------------------
79 // OpsManaged - Implements an Owner and Ops Permission Model
80 // Enuma Blockchain Platform
81 //
82 // Copyright (c) 2017 Enuma Technologies.
83 // https://www.enuma.io/
84 // ----------------------------------------------------------------------------
85 
86 
87 
88 //
89 // Implements a security model with owner and ops.
90 //
91 contract OpsManaged is Owned {
92 
93    address public opsAddress;
94 
95    event OpsAddressUpdated(address indexed _newAddress);
96 
97 
98    function OpsManaged() public
99       Owned()
100    {
101    }
102 
103 
104    modifier onlyOwnerOrOps() {
105       require(isOwnerOrOps(msg.sender));
106       _;
107    }
108 
109 
110    function isOps(address _address) public view returns (bool) {
111       return (opsAddress != address(0) && _address == opsAddress);
112    }
113 
114 
115    function isOwnerOrOps(address _address) public view returns (bool) {
116       return (isOwner(_address) || isOps(_address));
117    }
118 
119 
120    function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool) {
121       require(_newOpsAddress != owner);
122       require(_newOpsAddress != address(this));
123 
124       opsAddress = _newOpsAddress;
125 
126       OpsAddressUpdated(opsAddress);
127 
128       return true;
129    }
130 }
131 
132 // ----------------------------------------------------------------------------
133 // Math - General Math Utility Library
134 // Enuma Blockchain Platform
135 //
136 // Copyright (c) 2017 Enuma Technologies.
137 // https://www.enuma.io/
138 // ----------------------------------------------------------------------------
139 
140 
141 library Math {
142 
143    function add(uint256 a, uint256 b) internal pure returns (uint256) {
144       uint256 r = a + b;
145 
146       require(r >= a);
147 
148       return r;
149    }
150 
151 
152    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153       require(a >= b);
154 
155       return a - b;
156    }
157 
158 
159    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160       uint256 r = a * b;
161 
162       require(a == 0 || r / a == b);
163 
164       return r;
165    }
166 
167 
168    function div(uint256 a, uint256 b) internal pure returns (uint256) {
169       return a / b;
170    }
171 }
172 
173 // ----------------------------------------------------------------------------
174 // ERC20Interface - Standard ERC20 Interface Definition
175 // Enuma Blockchain Platform
176 //
177 // Copyright (c) 2017 Enuma Technologies.
178 // https://www.enuma.io/
179 // ----------------------------------------------------------------------------
180 
181 // ----------------------------------------------------------------------------
182 // Based on the final ERC20 specification at:
183 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
184 // ----------------------------------------------------------------------------
185 contract ERC20Interface {
186 
187    event Transfer(address indexed _from, address indexed _to, uint256 _value);
188    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
189 
190    function name() public view returns (string);
191    function symbol() public view returns (string);
192    function decimals() public view returns (uint8);
193    function totalSupply() public view returns (uint256);
194 
195    function balanceOf(address _owner) public view returns (uint256 balance);
196    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
197 
198    function transfer(address _to, uint256 _value) public returns (bool success);
199    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
200    function approve(address _spender, uint256 _value) public returns (bool success);
201 }
202 
203 // ----------------------------------------------------------------------------
204 // ERC20Token - Standard ERC20 Implementation
205 // Enuma Blockchain Platform
206 //
207 // Copyright (c) 2017 Enuma Technologies.
208 // https://www.enuma.io/
209 // ----------------------------------------------------------------------------
210 
211 
212 contract ERC20Token is ERC20Interface {
213 
214    using Math for uint256;
215 
216    string  private tokenName;
217    string  private tokenSymbol;
218    uint8   private tokenDecimals;
219    uint256 internal tokenTotalSupply;
220 
221    mapping(address => uint256) internal balances;
222    mapping(address => mapping (address => uint256)) allowed;
223 
224 
225    function ERC20Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {
226       tokenName = _name;
227       tokenSymbol = _symbol;
228       tokenDecimals = _decimals;
229       tokenTotalSupply = _totalSupply;
230 
231       // The initial balance of tokens is assigned to the given token holder address.
232       balances[_initialTokenHolder] = _totalSupply;
233 
234       // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.
235       Transfer(0x0, _initialTokenHolder, _totalSupply);
236    }
237 
238 
239    function name() public view returns (string) {
240       return tokenName;
241    }
242 
243 
244    function symbol() public view returns (string) {
245       return tokenSymbol;
246    }
247 
248 
249    function decimals() public view returns (uint8) {
250       return tokenDecimals;
251    }
252 
253 
254    function totalSupply() public view returns (uint256) {
255       return tokenTotalSupply;
256    }
257 
258 
259    function balanceOf(address _owner) public view returns (uint256 balance) {
260       return balances[_owner];
261    }
262 
263 
264    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
265       return allowed[_owner][_spender];
266    }
267 
268 
269    function transfer(address _to, uint256 _value) public returns (bool success) {
270       balances[msg.sender] = balances[msg.sender].sub(_value);
271       balances[_to] = balances[_to].add(_value);
272 
273       Transfer(msg.sender, _to, _value);
274 
275       return true;
276    }
277 
278 
279    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
280       balances[_from] = balances[_from].sub(_value);
281       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
282       balances[_to] = balances[_to].add(_value);
283 
284       Transfer(_from, _to, _value);
285 
286       return true;
287    }
288 
289 
290    function approve(address _spender, uint256 _value) public returns (bool success) {
291       allowed[msg.sender][_spender] = _value;
292 
293       Approval(msg.sender, _spender, _value);
294 
295       return true;
296    }
297 }
298 
299 // ----------------------------------------------------------------------------
300 // Finalizable - Basic implementation of the finalization pattern
301 // Enuma Blockchain Platform
302 //
303 // Copyright (c) 2017 Enuma Technologies.
304 // https://www.enuma.io/
305 // ----------------------------------------------------------------------------
306 
307 
308 
309 contract Finalizable is Owned {
310 
311    bool public finalized;
312 
313    event Finalized();
314 
315 
316    function Finalizable() public
317       Owned()
318    {
319       finalized = false;
320    }
321 
322 
323    function finalize() public onlyOwner returns (bool) {
324       require(!finalized);
325 
326       finalized = true;
327 
328       Finalized();
329 
330       return true;
331    }
332 }
333 
334 // ----------------------------------------------------------------------------
335 // FinalizableToken - Extension to ERC20Token with ops and finalization
336 // Enuma Blockchain Platform
337 //
338 // Copyright (c) 2017 Enuma Technologies.
339 // https://www.enuma.io/
340 // ----------------------------------------------------------------------------
341 
342 
343 
344 //
345 // ERC20 token with the following additions:
346 //    1. Owner/Ops Ownership
347 //    2. Finalization
348 //
349 contract FinalizableToken is ERC20Token, OpsManaged, Finalizable {
350 
351    using Math for uint256;
352 
353 
354    // The constructor will assign the initial token supply to the owner (msg.sender).
355    function FinalizableToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public
356       ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)
357       OpsManaged()
358       Finalizable()
359    {
360    }
361 
362 
363    function transfer(address _to, uint256 _value) public returns (bool success) {
364       validateTransfer(msg.sender, _to);
365 
366       return super.transfer(_to, _value);
367    }
368 
369 
370    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
371       validateTransfer(msg.sender, _to);
372 
373       return super.transferFrom(_from, _to, _value);
374    }
375 
376 
377    function validateTransfer(address _sender, address _to) private view {
378       require(_to != address(0));
379 
380       // Once the token is finalized, everybody can transfer tokens.
381       if (finalized) {
382          return;
383       }
384 
385       if (isOwner(_to)) {
386          return;
387       }
388 
389       // Before the token is finalized, only owner and ops are allowed to initiate transfers.
390       // This allows them to move tokens while the sale is still ongoing for example.
391       require(isOwnerOrOps(_sender));
392    }
393 }
394 
395 
396 
397 // ----------------------------------------------------------------------------
398 // FlexibleTokenSale - Token Sale Contract
399 // Enuma Blockchain Platform
400 //
401 // Copyright (c) 2017 Enuma Technologies.
402 // https://www.enuma.io/
403 // ----------------------------------------------------------------------------
404 
405 
406 
407 contract FlexibleTokenSale is Finalizable, OpsManaged {
408 
409    using Math for uint256;
410 
411    //
412    // Lifecycle
413    //
414    uint256 public startTime;
415    uint256 public endTime;
416    bool public suspended;
417 
418    //
419    // Pricing
420    //
421    uint256 public tokensPerKEther;
422    uint256 public bonus;
423    uint256 public maxTokensPerAccount;
424    uint256 public contributionMin;
425    uint256 public tokenConversionFactor;
426 
427    //
428    // Wallets
429    //
430    address public walletAddress;
431 
432    //
433    // Token
434    //
435    FinalizableToken public token;
436 
437    //
438    // Counters
439    //
440    uint256 public totalTokensSold;
441    uint256 public totalEtherCollected;
442 
443 
444    //
445    // Events
446    //
447    event Initialized();
448    event TokensPerKEtherUpdated(uint256 _newValue);
449    event MaxTokensPerAccountUpdated(uint256 _newMax);
450    event BonusUpdated(uint256 _newValue);
451    event SaleWindowUpdated(uint256 _startTime, uint256 _endTime);
452    event WalletAddressUpdated(address _newAddress);
453    event SaleSuspended();
454    event SaleResumed();
455    event TokensPurchased(address _beneficiary, uint256 _cost, uint256 _tokens);
456    event TokensReclaimed(uint256 _amount);
457 
458 
459    function FlexibleTokenSale(uint256 _startTime, uint256 _endTime, address _walletAddress) public
460       OpsManaged()
461    {
462       require(_endTime > _startTime);
463 
464       require(_walletAddress != address(0));
465       require(_walletAddress != address(this));
466 
467       walletAddress = _walletAddress;
468 
469       finalized = false;
470       suspended = false;
471 
472       startTime = _startTime;
473       endTime   = _endTime;
474 
475       // Use some defaults config values. Classes deriving from FlexibleTokenSale
476       // should set their own defaults
477       tokensPerKEther     = 100000;
478       bonus               = 0;
479       maxTokensPerAccount = 0;
480       contributionMin     = 0.1 ether;
481 
482       totalTokensSold     = 0;
483       totalEtherCollected = 0;
484    }
485 
486 
487    function currentTime() public constant returns (uint256) {
488       return now;
489    }
490 
491 
492    // Initialize should be called by the owner as part of the deployment + setup phase.
493    // It will associate the sale contract with the token contract and perform basic checks.
494    function initialize(FinalizableToken _token) external onlyOwner returns(bool) {
495       require(address(token) == address(0));
496       require(address(_token) != address(0));
497       require(address(_token) != address(this));
498       require(address(_token) != address(walletAddress));
499       require(isOwnerOrOps(address(_token)) == false);
500 
501       token = _token;
502 
503       // This factor is used when converting cost <-> tokens.
504       // 18 is because of the ETH -> Wei conversion.
505       // 3 because prices are in K ETH instead of just ETH.
506       // 4 because bonuses are expressed as 0 - 10000 for 0.00% - 100.00% (with 2 decimals).
507       tokenConversionFactor = 10**(uint256(18).sub(_token.decimals()).add(3).add(4));
508       require(tokenConversionFactor > 0);
509 
510       Initialized();
511 
512       return true;
513    }
514 
515 
516    //
517    // Owner Configuation
518    //
519 
520    // Allows the owner to change the wallet address which is used for collecting
521    // ether received during the token sale.
522    function setWalletAddress(address _walletAddress) external onlyOwner returns(bool) {
523       require(_walletAddress != address(0));
524       require(_walletAddress != address(this));
525       require(_walletAddress != address(token));
526       require(isOwnerOrOps(_walletAddress) == false);
527 
528       walletAddress = _walletAddress;
529 
530       WalletAddressUpdated(_walletAddress);
531 
532       return true;
533    }
534 
535 
536    // Allows the owner to set an optional limit on the amount of tokens that can be purchased
537    // by a contributor. It can also be set to 0 to remove limit.
538    function setMaxTokensPerAccount(uint256 _maxTokens) external onlyOwner returns(bool) {
539 
540       maxTokensPerAccount = _maxTokens;
541 
542       MaxTokensPerAccountUpdated(_maxTokens);
543 
544       return true;
545    }
546 
547 
548    // Allows the owner to specify the conversion rate for ETH -> tokens.
549    // For example, passing 1,000,000 would mean that 1 ETH would purchase 1000 tokens.
550    function setTokensPerKEther(uint256 _tokensPerKEther) external onlyOwner returns(bool) {
551       require(_tokensPerKEther > 0);
552 
553       tokensPerKEther = _tokensPerKEther;
554 
555       TokensPerKEtherUpdated(_tokensPerKEther);
556 
557       return true;
558    }
559 
560 
561    // Allows the owner to set a bonus to apply to all purchases.
562    // For example, setting it to 2000 means that instead of receiving 200 tokens,
563    // for a given price, contributors would receive 240 tokens (20.00% bonus).
564    function setBonus(uint256 _bonus) external onlyOwner returns(bool) {
565       require(_bonus <= 10000);
566 
567       bonus = _bonus;
568 
569       BonusUpdated(_bonus);
570 
571       return true;
572    }
573 
574 
575    // Allows the owner to set a sale window which will allow the sale (aka buyTokens) to
576    // receive contributions between _startTime and _endTime. Once _endTime is reached,
577    // the sale contract will automatically stop accepting incoming contributions.
578    function setSaleWindow(uint256 _startTime, uint256 _endTime) external onlyOwner returns(bool) {
579       require(_startTime > 0);
580       require(_endTime > _startTime);
581 
582       startTime = _startTime;
583       endTime   = _endTime;
584 
585       SaleWindowUpdated(_startTime, _endTime);
586 
587       return true;
588    }
589 
590 
591    // Allows the owner to suspend the sale until it is manually resumed at a later time.
592    function suspend() external onlyOwner returns(bool) {
593       if (suspended == true) {
594           return false;
595       }
596 
597       suspended = true;
598 
599       SaleSuspended();
600 
601       return true;
602    }
603 
604 
605    // Allows the owner to resume the sale.
606    function resume() external onlyOwner returns(bool) {
607       if (suspended == false) {
608           return false;
609       }
610 
611       suspended = false;
612 
613       SaleResumed();
614 
615       return true;
616    }
617 
618 
619    //
620    // Contributions
621    //
622 
623    // Default payable function which can be used to purchase tokens.
624    function () payable public {
625       buyTokens(msg.sender);
626    }
627 
628 
629    // Allows the caller to purchase tokens for a specific beneficiary (proxy purchase).
630    function buyTokens(address _beneficiary) public payable returns (uint256) {
631       return buyTokensInternal(_beneficiary, bonus);
632    }
633 
634 
635    function buyTokensInternal(address _beneficiary, uint256 _bonus) internal returns (uint256) {
636       require(!finalized);
637       require(!suspended);
638       require(currentTime() >= startTime);
639       require(currentTime() <= endTime);
640       require(msg.value >= contributionMin);
641       require(_beneficiary != address(0));
642       require(_beneficiary != address(this));
643       require(_beneficiary != address(token));
644 
645       // We don't want to allow the wallet collecting ETH to
646       // directly be used to purchase tokens.
647       require(msg.sender != address(walletAddress));
648 
649       // Check how many tokens are still available for sale.
650       uint256 saleBalance = token.balanceOf(address(this));
651       require(saleBalance > 0);
652 
653       // Calculate how many tokens the contributor could purchase based on ETH received.
654       uint256 tokens = msg.value.mul(tokensPerKEther).mul(_bonus.add(10000)).div(tokenConversionFactor);
655       require(tokens > 0);
656 
657       uint256 cost = msg.value;
658       uint256 refund = 0;
659 
660       // Calculate what is the maximum amount of tokens that the contributor
661       // should be allowed to purchase
662       uint256 maxTokens = saleBalance;
663 
664       if (maxTokensPerAccount > 0) {
665          // There is a maximum amount of tokens per account in place.
666          // Check if the user already hit that limit.
667          uint256 userBalance = getUserTokenBalance(_beneficiary);
668          require(userBalance < maxTokensPerAccount);
669 
670          uint256 quotaBalance = maxTokensPerAccount.sub(userBalance);
671 
672          if (quotaBalance < saleBalance) {
673             maxTokens = quotaBalance;
674          }
675       }
676 
677       require(maxTokens > 0);
678 
679       if (tokens > maxTokens) {
680          // The contributor sent more ETH than allowed to purchase.
681          // Limit the amount of tokens that they can purchase in this transaction.
682          tokens = maxTokens;
683 
684          // Calculate the actual cost for that new amount of tokens.
685          cost = tokens.mul(tokenConversionFactor).div(tokensPerKEther.mul(_bonus.add(10000)));
686 
687          if (msg.value > cost) {
688             // If the contributor sent more ETH than needed to buy the tokens,
689             // the balance should be refunded.
690             refund = msg.value.sub(cost);
691          }
692       }
693 
694       // This is the actual amount of ETH that can be sent to the wallet.
695       uint256 contribution = msg.value.sub(refund);
696       walletAddress.transfer(contribution);
697 
698       // Update our stats counters.
699       totalTokensSold     = totalTokensSold.add(tokens);
700       totalEtherCollected = totalEtherCollected.add(contribution);
701 
702       // Transfer tokens to the beneficiary.
703       require(token.transfer(_beneficiary, tokens));
704 
705       // Issue a refund for the excess ETH, as needed.
706       if (refund > 0) {
707          msg.sender.transfer(refund);
708       }
709 
710       TokensPurchased(_beneficiary, cost, tokens);
711 
712       return tokens;
713    }
714 
715 
716    // Returns the number of tokens that the user has purchased. Will be checked against the
717    // maximum allowed. Can be overriden in a sub class to change the calculations.
718    function getUserTokenBalance(address _beneficiary) internal view returns (uint256) {
719       return token.balanceOf(_beneficiary);
720    }
721 
722 
723    // Allows the owner to take back the tokens that are assigned to the sale contract.
724    function reclaimTokens() external onlyOwner returns (bool) {
725       uint256 tokens = token.balanceOf(address(this));
726 
727       if (tokens == 0) {
728          return false;
729       }
730 
731       address tokenOwner = token.owner();
732       require(tokenOwner != address(0));
733 
734       require(token.transfer(tokenOwner, tokens));
735 
736       TokensReclaimed(tokens);
737 
738       return true;
739    }
740 }
741 
742 
743 // ----------------------------------------------------------------------------
744 // BluzelleTokenConfig - Token Contract Configuration
745 //
746 // Copyright (c) 2017 Bluzelle Networks Pte Ltd.
747 // http://www.bluzelle.com/
748 //
749 // The MIT Licence.
750 // ----------------------------------------------------------------------------
751 
752 
753 contract BluzelleTokenConfig {
754 
755     string  public constant TOKEN_SYMBOL      = "BLZ";
756     string  public constant TOKEN_NAME        = "Bluzelle Token";
757     uint8   public constant TOKEN_DECIMALS    = 18;
758 
759     uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);
760     uint256 public constant TOKEN_TOTALSUPPLY = 500000000 * DECIMALSFACTOR;
761 }
762 
763 
764 // ----------------------------------------------------------------------------
765 // BluzelleTokenSaleConfig - Token Sale Configuration
766 //
767 // Copyright (c) 2017 Bluzelle Networks Pte Ltd.
768 // http://www.bluzelle.com/
769 //
770 // The MIT Licence.
771 // ----------------------------------------------------------------------------
772 
773 
774 
775 contract BluzelleTokenSaleConfig is BluzelleTokenConfig {
776 
777     //
778     // Time
779     //
780     uint256 public constant INITIAL_STARTTIME      = 1516240800; // 2018-01-18, 02:00:00 UTC
781     uint256 public constant INITIAL_ENDTIME        = 1517536800; // 2018-02-02, 02:00:00 UTC
782     uint256 public constant INITIAL_STAGE          = 1;
783 
784 
785     //
786     // Purchases
787     //
788 
789     // Minimum amount of ETH that can be used for purchase.
790     uint256 public constant CONTRIBUTION_MIN      = 0.1 ether;
791 
792     // Price of tokens, based on the 1 ETH = 1700 BLZ conversion ratio.
793     uint256 public constant TOKENS_PER_KETHER     = 1700000;
794 
795     // Amount of bonus applied to the sale. 2000 = 20.00% bonus, 750 = 7.50% bonus, 0 = no bonus.
796     uint256 public constant BONUS                 = 0;
797 
798     // Maximum amount of tokens that can be purchased for each account.
799     uint256 public constant TOKENS_ACCOUNT_MAX    = 17000 * DECIMALSFACTOR;
800 }
801 
802 
803 // ----------------------------------------------------------------------------
804 // BluzelleToken - ERC20 Compatible Token
805 //
806 // Copyright (c) 2017 Bluzelle Networks Pte Ltd.
807 // http://www.bluzelle.com/
808 //
809 // The MIT Licence.
810 // ----------------------------------------------------------------------------
811 
812 
813 
814 // ----------------------------------------------------------------------------
815 // The Bluzelle token is a standard ERC20 token with the addition of a few
816 // concepts such as:
817 //
818 // 1. Finalization
819 // Tokens can only be transfered by contributors after the contract has
820 // been finalized.
821 //
822 // 2. Ops Managed Model
823 // In addition to owner, there is a ops role which is used during the sale,
824 // by the sale contract, in order to transfer tokens.
825 // ----------------------------------------------------------------------------
826 contract BluzelleToken is FinalizableToken, BluzelleTokenConfig {
827 
828 
829    event TokensReclaimed(uint256 _amount);
830 
831 
832    function BluzelleToken() public
833       FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY)
834    {
835    }
836 
837 
838    // Allows the owner to reclaim tokens that have been sent to the token address itself.
839    function reclaimTokens() public onlyOwner returns (bool) {
840 
841       address account = address(this);
842       uint256 amount  = balanceOf(account);
843 
844       if (amount == 0) {
845          return false;
846       }
847 
848       balances[account] = balances[account].sub(amount);
849       balances[owner] = balances[owner].add(amount);
850 
851       Transfer(account, owner, amount);
852 
853       TokensReclaimed(amount);
854 
855       return true;
856    }
857 }
858 
859 
860 // ----------------------------------------------------------------------------
861 // BluzelleTokenSale - Token Sale Contract
862 //
863 // Copyright (c) 2017 Bluzelle Networks Pte Ltd.
864 // http://www.bluzelle.com/
865 //
866 // The MIT Licence.
867 // ----------------------------------------------------------------------------
868 
869 
870 
871 contract BluzelleTokenSale is FlexibleTokenSale, BluzelleTokenSaleConfig {
872 
873    //
874    // Whitelist
875    //
876 
877    // This is the stage or whitelist group that is currently in effect.
878    // Everybody that's been whitelisted for earlier stages should be able to
879    // contribute in the current stage.
880    uint256 public currentStage;
881 
882    // Keeps track of the amount of bonus to apply for a given stage. If set
883    // to 0, the base class bonus will be used.
884    mapping(uint256 => uint256) public stageBonus;
885 
886    // Keeps track of the amount of tokens that a specific account has received.
887    mapping(address => uint256) public accountTokensPurchased;
888 
889    // This a mapping of address -> stage that they are allowed to participate in.
890    // For example, if someone has been whitelisted for stage 2, they will be able
891    // to participate for stages 2 and above but they would not be able to participate
892    // in stage 1. A stage value of 0 means that the participant is not whitelisted.
893    mapping(address => uint256) public whitelist;
894 
895 
896    //
897    // Events
898    //
899    event CurrentStageUpdated(uint256 _newStage);
900    event StageBonusUpdated(uint256 _stage, uint256 _bonus);
901    event WhitelistedStatusUpdated(address indexed _address, uint256 _stage);
902 
903 
904    function BluzelleTokenSale(address wallet) public
905       FlexibleTokenSale(INITIAL_STARTTIME, INITIAL_ENDTIME, wallet)
906    {
907       currentStage        = INITIAL_STAGE;
908       tokensPerKEther     = TOKENS_PER_KETHER;
909       bonus               = BONUS;
910       maxTokensPerAccount = TOKENS_ACCOUNT_MAX;
911       contributionMin     = CONTRIBUTION_MIN;
912    }
913 
914 
915    // Allows the admin to determine what is the current stage for
916    // the sale. It can only move forward.
917    function setCurrentStage(uint256 _stage) public onlyOwner returns(bool) {
918       require(_stage > 0);
919 
920       if (currentStage == _stage) {
921          return false;
922       }
923 
924       currentStage = _stage;
925 
926       CurrentStageUpdated(_stage);
927 
928       return true;
929    }
930 
931 
932    // Allows the admin to set a bonus amount to apply for a specific stage.
933    function setStageBonus(uint256 _stage, uint256 _bonus) public onlyOwner returns(bool) {
934       require(_stage > 0);
935       require(_bonus <= 10000);
936 
937       if (stageBonus[_stage] == _bonus) {
938          // Nothing to change.
939          return false;
940       }
941 
942       stageBonus[_stage] = _bonus;
943 
944       StageBonusUpdated(_stage, _bonus);
945 
946       return true;
947    }
948 
949 
950    // Allows the owner or ops to add/remove people from the whitelist.
951    function setWhitelistedStatus(address _address, uint256 _stage) public onlyOwnerOrOps returns (bool) {
952       return setWhitelistedStatusInternal(_address, _stage);
953    }
954 
955 
956    function setWhitelistedStatusInternal(address _address, uint256 _stage) private returns (bool) {
957       require(_address != address(0));
958       require(_address != address(this));
959       require(_address != walletAddress);
960 
961       whitelist[_address] = _stage;
962 
963       WhitelistedStatusUpdated(_address, _stage);
964 
965       return true;
966    }
967 
968 
969    // Allows the owner or ops to add/remove people from the whitelist, in batches. This makes
970    // it easier/cheaper/faster to upload whitelist data in bulk. Note that the function is using an
971    // unbounded loop so the call should take care to not exceed the tx gas limit or block gas limit.
972    function setWhitelistedBatch(address[] _addresses, uint256 _stage) public onlyOwnerOrOps returns (bool) {
973       require(_addresses.length > 0);
974 
975       for (uint256 i = 0; i < _addresses.length; i++) {
976          require(setWhitelistedStatusInternal(_addresses[i], _stage));
977       }
978 
979       return true;
980    }
981 
982 
983    // This is an extension to the buyToken function in FlexibleTokenSale which also takes
984    // care of checking contributors against the whitelist. Since buyTokens supports proxy payments
985    // we check that both the sender and the beneficiary have been whitelisted.
986    function buyTokensInternal(address _beneficiary, uint256 _bonus) internal returns (uint256) {
987       require(whitelist[msg.sender] > 0);
988       require(whitelist[_beneficiary] > 0);
989       require(currentStage >= whitelist[msg.sender]);
990 
991       uint256 _beneficiaryStage = whitelist[_beneficiary];
992       require(currentStage >= _beneficiaryStage);
993 
994       uint256 applicableBonus = stageBonus[_beneficiaryStage];
995       if (applicableBonus == 0) {
996          applicableBonus = _bonus;
997       }
998 
999       uint256 tokensPurchased = super.buyTokensInternal(_beneficiary, applicableBonus);
1000 
1001       accountTokensPurchased[_beneficiary] = accountTokensPurchased[_beneficiary].add(tokensPurchased);
1002 
1003       return tokensPurchased;
1004    }
1005 
1006 
1007    // Returns the number of tokens that the user has purchased. We keep a separate balance from
1008    // the token contract in case we'd like to do additional sales with new purchase limits. This behavior
1009    // is different from the base implementation which just checks the token balance from the token
1010    // contract directly.
1011    function getUserTokenBalance(address _beneficiary) internal view returns (uint256) {
1012       return accountTokensPurchased[_beneficiary];
1013    }
1014 }