1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // Token Trustee Implementation
5 //
6 // Copyright (c) 2017 OpenST Ltd.
7 // https://simpletoken.org/
8 //
9 // The MIT Licence.
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // SafeMath Library Implementation
14 //
15 // Copyright (c) 2017 OpenST Ltd.
16 // https://simpletoken.org/
17 //
18 // The MIT Licence.
19 //
20 // Based on the SafeMath library by the OpenZeppelin team.
21 // Copyright (c) 2016 Smart Contract Solutions, Inc.
22 // https://github.com/OpenZeppelin/zeppelin-solidity
23 // The MIT License.
24 // ----------------------------------------------------------------------------
25 
26 
27 library SafeMath {
28 
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a * b;
31 
32         assert(a == 0 || c / a == b);
33 
34         return c;
35     }
36 
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         // Solidity automatically throws when dividing by 0
40         uint256 c = a / b;
41 
42         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43         return c;
44     }
45 
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         assert(b <= a);
49 
50         return a - b;
51     }
52 
53 
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56 
57         assert(c >= a);
58 
59         return c;
60     }
61 }
62 
63 //
64 // Implements basic ownership with 2-step transfers.
65 //
66 contract Owned {
67 
68     address public owner;
69     address public proposedOwner;
70 
71     event OwnershipTransferInitiated(address indexed _proposedOwner);
72     event OwnershipTransferCompleted(address indexed _newOwner);
73 
74 
75     function Owned() public {
76         owner = msg.sender;
77     }
78 
79 
80     modifier onlyOwner() {
81         require(isOwner(msg.sender));
82         _;
83     }
84 
85 
86     function isOwner(address _address) internal view returns (bool) {
87         return (_address == owner);
88     }
89 
90 
91     function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
92         proposedOwner = _proposedOwner;
93 
94         OwnershipTransferInitiated(_proposedOwner);
95 
96         return true;
97     }
98 
99 
100     function completeOwnershipTransfer() public returns (bool) {
101         require(msg.sender == proposedOwner);
102 
103         owner = proposedOwner;
104         proposedOwner = address(0);
105 
106         OwnershipTransferCompleted(owner);
107 
108         return true;
109     }
110 }
111 
112 //
113 // Implements a more advanced ownership and permission model based on owner,
114 // admin and ops per Simple Token key management specification.
115 //
116 contract OpsManaged is Owned {
117 
118     address public opsAddress;
119     address public adminAddress;
120 
121     event AdminAddressChanged(address indexed _newAddress);
122     event OpsAddressChanged(address indexed _newAddress);
123 
124 
125     function OpsManaged() public
126         Owned()
127     {
128     }
129 
130 
131     modifier onlyAdmin() {
132         require(isAdmin(msg.sender));
133         _;
134     }
135 
136 
137     modifier onlyAdminOrOps() {
138         require(isAdmin(msg.sender) || isOps(msg.sender));
139         _;
140     }
141 
142 
143     modifier onlyOwnerOrAdmin() {
144         require(isOwner(msg.sender) || isAdmin(msg.sender));
145         _;
146     }
147 
148 
149     modifier onlyOps() {
150         require(isOps(msg.sender));
151         _;
152     }
153 
154 
155     function isAdmin(address _address) internal view returns (bool) {
156         return (adminAddress != address(0) && _address == adminAddress);
157     }
158 
159 
160     function isOps(address _address) internal view returns (bool) {
161         return (opsAddress != address(0) && _address == opsAddress);
162     }
163 
164 
165     function isOwnerOrOps(address _address) internal view returns (bool) {
166         return (isOwner(_address) || isOps(_address));
167     }
168 
169 
170     // Owner and Admin can change the admin address. Address can also be set to 0 to 'disable' it.
171     function setAdminAddress(address _adminAddress) external onlyOwnerOrAdmin returns (bool) {
172         require(_adminAddress != owner);
173         require(_adminAddress != address(this));
174         require(!isOps(_adminAddress));
175 
176         adminAddress = _adminAddress;
177 
178         AdminAddressChanged(_adminAddress);
179 
180         return true;
181     }
182 
183 
184     // Owner and Admin can change the operations address. Address can also be set to 0 to 'disable' it.
185     function setOpsAddress(address _opsAddress) external onlyOwnerOrAdmin returns (bool) {
186         require(_opsAddress != owner);
187         require(_opsAddress != address(this));
188         require(!isAdmin(_opsAddress));
189 
190         opsAddress = _opsAddress;
191 
192         OpsAddressChanged(_opsAddress);
193 
194         return true;
195     }
196 }
197 
198 contract SimpleTokenConfig {
199 
200     string  public constant TOKEN_SYMBOL   = "ST";
201     string  public constant TOKEN_NAME     = "Simple Token";
202     uint8   public constant TOKEN_DECIMALS = 18;
203 
204     uint256 public constant DECIMALSFACTOR = 10**uint256(TOKEN_DECIMALS);
205     uint256 public constant TOKENS_MAX     = 800000000 * DECIMALSFACTOR;
206 }
207 
208 contract ERC20Interface {
209 
210     event Transfer(address indexed _from, address indexed _to, uint256 _value);
211     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
212 
213     function name() public view returns (string);
214     function symbol() public view returns (string);
215     function decimals() public view returns (uint8);
216     function totalSupply() public view returns (uint256);
217 
218     function balanceOf(address _owner) public view returns (uint256 balance);
219     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
220 
221     function transfer(address _to, uint256 _value) public returns (bool success);
222     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
223     function approve(address _spender, uint256 _value) public returns (bool success);
224 }
225 
226 //
227 // Standard ERC20 implementation, with ownership.
228 //
229 contract ERC20Token is ERC20Interface, Owned {
230 
231     using SafeMath for uint256;
232 
233     string  private tokenName;
234     string  private tokenSymbol;
235     uint8   private tokenDecimals;
236     uint256 internal tokenTotalSupply;
237 
238     mapping(address => uint256) balances;
239     mapping(address => mapping (address => uint256)) allowed;
240 
241 
242     function ERC20Token(string _symbol, string _name, uint8 _decimals, uint256 _totalSupply) public
243         Owned()
244     {
245         tokenSymbol      = _symbol;
246         tokenName        = _name;
247         tokenDecimals    = _decimals;
248         tokenTotalSupply = _totalSupply;
249         balances[owner]  = _totalSupply;
250 
251         // According to the ERC20 standard, a token contract which creates new tokens should trigger
252         // a Transfer event and transfers of 0 values must also fire the event.
253         Transfer(0x0, owner, _totalSupply);
254     }
255 
256 
257     function name() public view returns (string) {
258         return tokenName;
259     }
260 
261 
262     function symbol() public view returns (string) {
263         return tokenSymbol;
264     }
265 
266 
267     function decimals() public view returns (uint8) {
268         return tokenDecimals;
269     }
270 
271 
272     function totalSupply() public view returns (uint256) {
273         return tokenTotalSupply;
274     }
275 
276 
277     function balanceOf(address _owner) public view returns (uint256) {
278         return balances[_owner];
279     }
280 
281 
282     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
283         return allowed[_owner][_spender];
284     }
285 
286 
287     function transfer(address _to, uint256 _value) public returns (bool success) {
288         // According to the EIP20 spec, "transfers of 0 values MUST be treated as normal
289         // transfers and fire the Transfer event".
290         // Also, should throw if not enough balance. This is taken care of by SafeMath.
291         balances[msg.sender] = balances[msg.sender].sub(_value);
292         balances[_to] = balances[_to].add(_value);
293 
294         Transfer(msg.sender, _to, _value);
295 
296         return true;
297     }
298 
299 
300     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
301         balances[_from] = balances[_from].sub(_value);
302         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
303         balances[_to] = balances[_to].add(_value);
304 
305         Transfer(_from, _to, _value);
306 
307         return true;
308     }
309 
310 
311     function approve(address _spender, uint256 _value) public returns (bool success) {
312 
313         allowed[msg.sender][_spender] = _value;
314 
315         Approval(msg.sender, _spender, _value);
316 
317         return true;
318     }
319 }
320 
321 //
322 // SimpleToken is a standard ERC20 token with some additional functionality:
323 // - It has a concept of finalize
324 // - Before finalize, nobody can transfer tokens except:
325 //     - Owner and operations can transfer tokens
326 //     - Anybody can send back tokens to owner
327 // - After finalize, no restrictions on token transfers
328 //
329 
330 //
331 // Permissions, according to the ST key management specification.
332 //
333 //                                    Owner    Admin   Ops
334 // transfer (before finalize)           x               x
335 // transferForm (before finalize)       x               x
336 // finalize                                      x
337 //
338 
339 contract SimpleToken is ERC20Token, OpsManaged, SimpleTokenConfig {
340 
341     bool public finalized;
342 
343 
344     // Events
345     event Burnt(address indexed _from, uint256 _amount);
346     event Finalized();
347 
348 
349     function SimpleToken() public
350         ERC20Token(TOKEN_SYMBOL, TOKEN_NAME, TOKEN_DECIMALS, TOKENS_MAX)
351         OpsManaged()
352     {
353         finalized = false;
354     }
355 
356 
357     // Implementation of the standard transfer method that takes into account the finalize flag.
358     function transfer(address _to, uint256 _value) public returns (bool success) {
359         checkTransferAllowed(msg.sender, _to);
360 
361         return super.transfer(_to, _value);
362     }
363 
364 
365     // Implementation of the standard transferFrom method that takes into account the finalize flag.
366     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
367         checkTransferAllowed(msg.sender, _to);
368 
369         return super.transferFrom(_from, _to, _value);
370     }
371 
372 
373     function checkTransferAllowed(address _sender, address _to) private view {
374         if (finalized) {
375             // Everybody should be ok to transfer once the token is finalized.
376             return;
377         }
378 
379         // Owner and Ops are allowed to transfer tokens before the sale is finalized.
380         // This allows the tokens to move from the TokenSale contract to a beneficiary.
381         // We also allow someone to send tokens back to the owner. This is useful among other
382         // cases, for the Trustee to transfer unlocked tokens back to the owner (reclaimTokens).
383         require(isOwnerOrOps(_sender) || _to == owner);
384     }
385 
386     // Implement a burn function to permit msg.sender to reduce its balance
387     // which also reduces tokenTotalSupply
388     function burn(uint256 _value) public returns (bool success) {
389         require(_value <= balances[msg.sender]);
390 
391         balances[msg.sender] = balances[msg.sender].sub(_value);
392         tokenTotalSupply = tokenTotalSupply.sub(_value);
393 
394         Burnt(msg.sender, _value);
395 
396         return true;
397     }
398 
399 
400     // Finalize method marks the point where token transfers are finally allowed for everybody.
401     function finalize() external onlyAdmin returns (bool success) {
402         require(!finalized);
403 
404         finalized = true;
405 
406         Finalized();
407 
408         return true;
409     }
410 }
411 
412 //
413 // Implements a simple trustee which can release tokens based on
414 // an explicit call from the owner.
415 //
416 
417 //
418 // Permissions, according to the ST key management specification.
419 //
420 //                                Owner    Admin   Ops   Revoke
421 // grantAllocation                           x      x
422 // revokeAllocation                                        x
423 // processAllocation                                x
424 // reclaimTokens                             x
425 // setRevokeAddress                 x                      x
426 //
427 
428 contract Trustee is OpsManaged {
429 
430     using SafeMath for uint256;
431 
432 
433     SimpleToken public tokenContract;
434 
435     struct Allocation {
436         uint256 amountGranted;
437         uint256 amountTransferred;
438         bool    revokable;
439     }
440 
441     // The trustee has a special 'revoke' key which is allowed to revoke allocations.
442     address public revokeAddress;
443 
444     // Total number of tokens that are currently allocated.
445     // This does not include tokens that have been processed (sent to an address) already or
446     // the ones in the trustee's account that have not been allocated yet.
447     uint256 public totalLocked;
448 
449     mapping (address => Allocation) public allocations;
450 
451 
452     //
453     // Events
454     //
455     event AllocationGranted(address indexed _from, address indexed _account, uint256 _amount, bool _revokable);
456     event AllocationRevoked(address indexed _from, address indexed _account, uint256 _amountRevoked);
457     event AllocationProcessed(address indexed _from, address indexed _account, uint256 _amount);
458     event RevokeAddressChanged(address indexed _newAddress);
459     event TokensReclaimed(uint256 _amount);
460 
461 
462     function Trustee(SimpleToken _tokenContract) public
463         OpsManaged()
464     {
465         require(address(_tokenContract) != address(0));
466 
467         tokenContract = _tokenContract;
468     }
469 
470 
471     modifier onlyOwnerOrRevoke() {
472         require(isOwner(msg.sender) || isRevoke(msg.sender));
473         _;
474     }
475 
476 
477     modifier onlyRevoke() {
478         require(isRevoke(msg.sender));
479         _;
480     }
481 
482 
483     function isRevoke(address _address) private view returns (bool) {
484         return (revokeAddress != address(0) && _address == revokeAddress);
485     }
486 
487 
488     // Owner and revoke can change the revoke address. Address can also be set to 0 to 'disable' it.
489     function setRevokeAddress(address _revokeAddress) external onlyOwnerOrRevoke returns (bool) {
490         require(_revokeAddress != owner);
491         require(!isAdmin(_revokeAddress));
492         require(!isOps(_revokeAddress));
493 
494         revokeAddress = _revokeAddress;
495 
496         RevokeAddressChanged(_revokeAddress);
497 
498         return true;
499     }
500 
501 
502     // Allows admin or ops to create new allocations for a specific account.
503     function grantAllocation(address _account, uint256 _amount, bool _revokable) public onlyAdminOrOps returns (bool) {
504         require(_account != address(0));
505         require(_account != address(this));
506         require(_amount > 0);
507 
508         // Can't create an allocation if there is already one for this account.
509         require(allocations[_account].amountGranted == 0);
510 
511         if (isOps(msg.sender)) {
512             // Once the token contract is finalized, the ops key should not be able to grant allocations any longer.
513             // Before finalized, it is used by the TokenSale contract to allocate pre-sales.
514             require(!tokenContract.finalized());
515         }
516 
517         totalLocked = totalLocked.add(_amount);
518         require(totalLocked <= tokenContract.balanceOf(address(this)));
519 
520         allocations[_account] = Allocation({
521             amountGranted     : _amount,
522             amountTransferred : 0,
523             revokable         : _revokable
524         });
525 
526         AllocationGranted(msg.sender, _account, _amount, _revokable);
527 
528         return true;
529     }
530 
531 
532     // Allows the revoke key to revoke allocations, if revoke is allowed.
533     function revokeAllocation(address _account) external onlyRevoke returns (bool) {
534         require(_account != address(0));
535 
536         Allocation memory allocation = allocations[_account];
537 
538         require(allocation.revokable);
539 
540         uint256 ownerRefund = allocation.amountGranted.sub(allocation.amountTransferred);
541 
542         delete allocations[_account];
543 
544         totalLocked = totalLocked.sub(ownerRefund);
545 
546         AllocationRevoked(msg.sender, _account, ownerRefund);
547 
548         return true;
549     }
550 
551 
552     // Push model which allows ops to transfer tokens to the beneficiary.
553     // The exact amount to transfer is calculated based on agreements with
554     // the beneficiaries. Here we only restrict that the total amount transfered cannot
555     // exceed what has been granted.
556     function processAllocation(address _account, uint256 _amount) external onlyOps returns (bool) {
557         require(_account != address(0));
558         require(_amount > 0);
559 
560         Allocation storage allocation = allocations[_account];
561 
562         require(allocation.amountGranted > 0);
563 
564         uint256 transferable = allocation.amountGranted.sub(allocation.amountTransferred);
565 
566         if (transferable < _amount) {
567            return false;
568         }
569 
570         allocation.amountTransferred = allocation.amountTransferred.add(_amount);
571 
572         // Note that transfer will fail if the token contract has not been finalized yet.
573         require(tokenContract.transfer(_account, _amount));
574 
575         totalLocked = totalLocked.sub(_amount);
576 
577         AllocationProcessed(msg.sender, _account, _amount);
578 
579         return true;
580     }
581 
582 
583     // Allows the admin to claim back all tokens that are not currently allocated.
584     // Note that the trustee should be able to move tokens even before the token is
585     // finalized because SimpleToken allows sending back to owner specifically.
586     function reclaimTokens() external onlyAdmin returns (bool) {
587         uint256 ownBalance = tokenContract.balanceOf(address(this));
588 
589         // If balance <= amount locked, there is nothing to reclaim.
590         require(ownBalance > totalLocked);
591 
592         uint256 amountReclaimed = ownBalance.sub(totalLocked);
593 
594         address tokenOwner = tokenContract.owner();
595         require(tokenOwner != address(0));
596 
597         require(tokenContract.transfer(tokenOwner, amountReclaimed));
598 
599         TokensReclaimed(amountReclaimed);
600 
601         return true;
602     }
603 }
604 
605 // ----------------------------------------------------------------------------
606 // Pausable Contract Implementation
607 //
608 // Copyright (c) 2017 OpenST Ltd.
609 // https://simpletoken.org/
610 //
611 // The MIT Licence.
612 //
613 // Based on the Pausable contract by the OpenZeppelin team.
614 // Copyright (c) 2016 Smart Contract Solutions, Inc.
615 // https://github.com/OpenZeppelin/zeppelin-solidity
616 // The MIT License.
617 // ----------------------------------------------------------------------------
618 
619 contract Pausable is OpsManaged {
620 
621   event Pause();
622   event Unpause();
623 
624   bool public paused = false;
625 
626 
627   modifier whenNotPaused() {
628     require(!paused);
629     _;
630   }
631 
632 
633   modifier whenPaused() {
634     require(paused);
635     _;
636   }
637 
638 
639   function pause() public onlyAdmin whenNotPaused {
640     paused = true;
641 
642     Pause();
643   }
644 
645 
646   function unpause() public onlyAdmin whenPaused {
647     paused = false;
648 
649     Unpause();
650   }
651 }
652 
653 contract TokenSaleConfig is SimpleTokenConfig {
654 
655     uint256 public constant PHASE1_START_TIME         = 1510664400; // 2017-11-14, 13:00:00 UTC
656     uint256 public constant PHASE2_START_TIME         = 1510750800; // 2017-11-15, 13:00:00 UTC
657     uint256 public constant END_TIME                  = 1512133199; // 2017-12-01, 12:59:59 UTC
658     uint256 public constant CONTRIBUTION_MIN          = 0.1 ether;
659     uint256 public constant CONTRIBUTION_MAX          = 10000.0 ether;
660 
661     // This is the maximum number of tokens each individual account is allowed to
662     // buy during Phase 1 of the token sale (whitelisted phase)
663     // Calculated based on 300 USD/ETH * 10 ETH / 0.0833 USD / token = ~36,000
664     uint256 public constant PHASE1_ACCOUNT_TOKENS_MAX = 36000     * DECIMALSFACTOR;
665 
666     uint256 public constant TOKENS_SALE               = 240000000 * DECIMALSFACTOR;
667     uint256 public constant TOKENS_FOUNDERS           = 80000000  * DECIMALSFACTOR;
668     uint256 public constant TOKENS_ADVISORS           = 80000000  * DECIMALSFACTOR;
669     uint256 public constant TOKENS_EARLY_BACKERS      = 44884831  * DECIMALSFACTOR;
670     uint256 public constant TOKENS_ACCELERATOR        = 217600000 * DECIMALSFACTOR;
671     uint256 public constant TOKENS_FUTURE             = 137515169 * DECIMALSFACTOR;
672 
673     // We use a default for when the contract is deployed but this can be changed afterwards
674     // by calling the setTokensPerKEther function
675     // For the public sale, tokens are priced at 0.0833 USD/token.
676     // So if we have 300 USD/ETH -> 300,000 USD/KETH / 0.0833 USD/token = ~3,600,000
677     uint256 public constant TOKENS_PER_KETHER         = 3600000;
678 
679     // Constant used by buyTokens as part of the cost <-> tokens conversion.
680     // 18 for ETH -> WEI, TOKEN_DECIMALS (18 for Simple Token), 3 for the K in tokensPerKEther.
681     uint256 public constant PURCHASE_DIVIDER          = 10**(uint256(18) - TOKEN_DECIMALS + 3);
682 
683 }
684 
685 //
686 // Implementation of the 1st token sale for Simple Token
687 //
688 // * Lifecycle *
689 // Initialization sequence should be as follow:
690 //    1. Deploy SimpleToken contract
691 //    2. Deploy Trustee contract
692 //    3. Deploy TokenSale contract
693 //    4. Set operationsAddress of SimpleToken contract to TokenSale contract
694 //    5. Set operationsAddress of Trustee contract to TokenSale contract
695 //    6. Set operationsAddress of TokenSale contract to some address
696 //    7. Transfer tokens from owner to TokenSale contract
697 //    8. Transfer tokens from owner to Trustee contract
698 //    9. Initialize TokenSale contract
699 //
700 // Pre-sale sequence:
701 //    - Set tokensPerKEther
702 //    - Set phase1AccountTokensMax
703 //    - Add presales
704 //    - Add allocations for founders, advisors, etc.
705 //    - Update whitelist
706 //
707 // After-sale sequence:
708 //    1. Finalize the TokenSale contract
709 //    2. Finalize the SimpleToken contract
710 //    3. Set operationsAddress of TokenSale contract to 0
711 //    4. Set operationsAddress of SimpleToken contract to 0
712 //    5. Set operationsAddress of Trustee contract to some address
713 //
714 // Anytime
715 //    - Add/Remove allocations
716 //
717 
718 //
719 // Permissions, according to the ST key management specification.
720 //
721 //                                Owner    Admin   Ops
722 // initialize                       x
723 // changeWallet                              x
724 // updateWhitelist                                  x
725 // setTokensPerKEther                        x
726 // setPhase1AccountTokensMax                 x
727 // addPresale                                x
728 // pause / unpause                           x
729 // reclaimTokens                             x
730 // burnUnsoldTokens                          x
731 // finalize                                  x
732 //
733 
734 contract TokenSale is OpsManaged, Pausable, TokenSaleConfig { // Pausable is also Owned
735 
736     using SafeMath for uint256;
737 
738 
739     // We keep track of whether the sale has been finalized, at which point
740     // no additional contributions will be permitted.
741     bool public finalized;
742 
743     // The sale end time is initially defined by the END_TIME constant but it
744     // may get extended if the sale is paused.
745     uint256 public endTime;
746     uint256 public pausedTime;
747 
748     // Number of tokens per 1000 ETH. See TokenSaleConfig for details.
749     uint256 public tokensPerKEther;
750 
751     // Keeps track of the maximum amount of tokens that an account is allowed to purchase in phase 1.
752     uint256 public phase1AccountTokensMax;
753 
754     // Address where the funds collected during the sale will be forwarded.
755     address public wallet;
756 
757     // Token contract that the sale contract will interact with.
758     SimpleToken public tokenContract;
759 
760     // Trustee contract to hold on token balances. The following token pools will be held by trustee:
761     //    - Founders
762     //    - Advisors
763     //    - Early investors
764     //    - Presales
765     Trustee public trusteeContract;
766 
767     // Total amount of tokens sold during presale + public sale. Excludes pre-sale bonuses.
768     uint256 public totalTokensSold;
769 
770     // Total amount of tokens given as bonus during presale. Will influence accelerator token balance.
771     uint256 public totalPresaleBase;
772     uint256 public totalPresaleBonus;
773 
774     // Map of addresses that have been whitelisted in advance (and passed KYC).
775     // The whitelist value indicates what phase (1 or 2) the address has been whitelisted for.
776     // Addresses whitelisted for phase 1 can also contribute during phase 2.
777     mapping(address => uint8) public whitelist;
778 
779 
780     //
781     // EVENTS
782     //
783     event Initialized();
784     event PresaleAdded(address indexed _account, uint256 _baseTokens, uint256 _bonusTokens);
785     event WhitelistUpdated(address indexed _account, uint8 _phase);
786     event TokensPurchased(address indexed _beneficiary, uint256 _cost, uint256 _tokens, uint256 _totalSold);
787     event TokensPerKEtherUpdated(uint256 _amount);
788     event Phase1AccountTokensMaxUpdated(uint256 _tokens);
789     event WalletChanged(address _newWallet);
790     event TokensReclaimed(uint256 _amount);
791     event UnsoldTokensBurnt(uint256 _amount);
792     event Finalized();
793 
794 
795     function TokenSale(SimpleToken _tokenContract, Trustee _trusteeContract, address _wallet) public
796         OpsManaged()
797     {
798         require(address(_tokenContract) != address(0));
799         require(address(_trusteeContract) != address(0));
800         require(_wallet != address(0));
801 
802         require(PHASE1_START_TIME >= currentTime());
803         require(PHASE2_START_TIME > PHASE1_START_TIME);
804         require(END_TIME > PHASE2_START_TIME);
805         require(TOKENS_PER_KETHER > 0);
806         require(PHASE1_ACCOUNT_TOKENS_MAX > 0);
807 
808         // Basic check that the constants add up to TOKENS_MAX
809         uint256 partialAllocations = TOKENS_FOUNDERS.add(TOKENS_ADVISORS).add(TOKENS_EARLY_BACKERS);
810         require(partialAllocations.add(TOKENS_SALE).add(TOKENS_ACCELERATOR).add(TOKENS_FUTURE) == TOKENS_MAX);
811 
812         wallet                 = _wallet;
813         pausedTime             = 0;
814         endTime                = END_TIME;
815         finalized              = false;
816         tokensPerKEther        = TOKENS_PER_KETHER;
817         phase1AccountTokensMax = PHASE1_ACCOUNT_TOKENS_MAX;
818 
819         tokenContract   = _tokenContract;
820         trusteeContract = _trusteeContract;
821     }
822 
823 
824     // Initialize is called to check some configuration parameters.
825     // It expects that a certain amount of tokens have already been assigned to the sale contract address.
826     function initialize() external onlyOwner returns (bool) {
827         require(totalTokensSold == 0);
828         require(totalPresaleBase == 0);
829         require(totalPresaleBonus == 0);
830 
831         uint256 ownBalance = tokenContract.balanceOf(address(this));
832         require(ownBalance == TOKENS_SALE);
833 
834         // Simple check to confirm that tokens are present
835         uint256 trusteeBalance = tokenContract.balanceOf(address(trusteeContract));
836         require(trusteeBalance >= TOKENS_FUTURE);
837 
838         Initialized();
839 
840         return true;
841     }
842 
843 
844     // Allows the admin to change the wallet where ETH contributions are sent.
845     function changeWallet(address _wallet) external onlyAdmin returns (bool) {
846         require(_wallet != address(0));
847         require(_wallet != address(this));
848         require(_wallet != address(trusteeContract));
849         require(_wallet != address(tokenContract));
850 
851         wallet = _wallet;
852 
853         WalletChanged(wallet);
854 
855         return true;
856     }
857 
858 
859 
860     //
861     // TIME
862     //
863 
864     function currentTime() public view returns (uint256 _currentTime) {
865         return now;
866     }
867 
868 
869     modifier onlyBeforeSale() {
870         require(hasSaleEnded() == false);
871         require(currentTime() < PHASE1_START_TIME);
872        _;
873     }
874 
875 
876     modifier onlyDuringSale() {
877         require(hasSaleEnded() == false && currentTime() >= PHASE1_START_TIME);
878         _;
879     }
880 
881     modifier onlyAfterSale() {
882         // require finalized is stronger than hasSaleEnded
883         require(finalized);
884         _;
885     }
886 
887 
888     function hasSaleEnded() private view returns (bool) {
889         // if sold out or finalized, sale has ended
890         if (totalTokensSold >= TOKENS_SALE || finalized) {
891             return true;
892         // else if sale is not paused (pausedTime = 0) 
893         // and endtime has past, then sale has ended
894         } else if (pausedTime == 0 && currentTime() >= endTime) {
895             return true;
896         // otherwise it is not past and not paused; or paused
897         // and as such not ended
898         } else {
899             return false;
900         }
901     }
902 
903 
904 
905     //
906     // WHITELIST
907     //
908 
909     // Allows ops to add accounts to the whitelist.
910     // Only those accounts will be allowed to contribute during the sale.
911     // _phase = 1: Can contribute during phases 1 and 2 of the sale.
912     // _phase = 2: Can contribute during phase 2 of the sale only.
913     // _phase = 0: Cannot contribute at all (not whitelisted).
914     function updateWhitelist(address _account, uint8 _phase) external onlyOps returns (bool) {
915         require(_account != address(0));
916         require(_phase <= 2);
917         require(!hasSaleEnded());
918 
919         whitelist[_account] = _phase;
920 
921         WhitelistUpdated(_account, _phase);
922 
923         return true;
924     }
925 
926 
927 
928     //
929     // PURCHASES / CONTRIBUTIONS
930     //
931 
932     // Allows the admin to set the price for tokens sold during phases 1 and 2 of the sale.
933     function setTokensPerKEther(uint256 _tokensPerKEther) external onlyAdmin onlyBeforeSale returns (bool) {
934         require(_tokensPerKEther > 0);
935 
936         tokensPerKEther = _tokensPerKEther;
937 
938         TokensPerKEtherUpdated(_tokensPerKEther);
939 
940         return true;
941     }
942 
943 
944     // Allows the admin to set the maximum amount of tokens that an account can buy during phase 1 of the sale.
945     function setPhase1AccountTokensMax(uint256 _tokens) external onlyAdmin onlyBeforeSale returns (bool) {
946         require(_tokens > 0);
947 
948         phase1AccountTokensMax = _tokens;
949 
950         Phase1AccountTokensMaxUpdated(_tokens);
951 
952         return true;
953     }
954 
955 
956     function () external payable whenNotPaused onlyDuringSale {
957         buyTokens();
958     }
959 
960 
961     // This is the main function to process incoming ETH contributions.
962     function buyTokens() public payable whenNotPaused onlyDuringSale returns (bool) {
963         require(msg.value >= CONTRIBUTION_MIN);
964         require(msg.value <= CONTRIBUTION_MAX);
965         require(totalTokensSold < TOKENS_SALE);
966 
967         // All accounts need to be whitelisted to purchase.
968         uint8 whitelistedPhase = whitelist[msg.sender];
969         require(whitelistedPhase > 0);
970 
971         uint256 tokensMax = TOKENS_SALE.sub(totalTokensSold);
972 
973         if (currentTime() < PHASE2_START_TIME) {
974             // We are in phase 1 of the sale
975             require(whitelistedPhase == 1);
976 
977             uint256 accountBalance = tokenContract.balanceOf(msg.sender);
978 
979             // Can only purchase up to a maximum per account.
980             // Calculate how much of that amount is still available.
981             uint256 phase1Balance = phase1AccountTokensMax.sub(accountBalance);
982 
983             if (phase1Balance < tokensMax) {
984                 tokensMax = phase1Balance;
985             }
986         }
987 
988         require(tokensMax > 0);
989 
990         uint256 tokensBought = msg.value.mul(tokensPerKEther).div(PURCHASE_DIVIDER);
991         require(tokensBought > 0);
992 
993         uint256 cost = msg.value;
994         uint256 refund = 0;
995 
996         if (tokensBought > tokensMax) {
997             // Not enough tokens available for full contribution, we will do partial.
998             tokensBought = tokensMax;
999 
1000             // Calculate actual cost for partial amount of tokens.
1001             cost = tokensBought.mul(PURCHASE_DIVIDER).div(tokensPerKEther);
1002 
1003             // Calculate refund for contributor.
1004             refund = msg.value.sub(cost);
1005         }
1006 
1007         totalTokensSold = totalTokensSold.add(tokensBought);
1008 
1009         // Transfer tokens to the account
1010         require(tokenContract.transfer(msg.sender, tokensBought));
1011 
1012         // Issue a ETH refund for any unused portion of the funds.
1013         if (refund > 0) {
1014             msg.sender.transfer(refund);
1015         }
1016 
1017         // Transfer the contribution to the wallet
1018         wallet.transfer(msg.value.sub(refund));
1019 
1020         TokensPurchased(msg.sender, cost, tokensBought, totalTokensSold);
1021 
1022         // If all tokens available for sale have been sold out, finalize the sale automatically.
1023         if (totalTokensSold == TOKENS_SALE) {
1024             finalizeInternal();
1025         }
1026 
1027         return true;
1028     }
1029 
1030 
1031     //
1032     // PRESALES
1033     //
1034 
1035     // Allows the admin to record pre-sales, before the public sale starts. Presale base tokens come out of the
1036     // main sale pool (the 30% allocation) while bonus tokens come from the remaining token pool.
1037     function addPresale(address _account, uint256 _baseTokens, uint256 _bonusTokens) external onlyAdmin onlyBeforeSale returns (bool) {
1038         require(_account != address(0));
1039 
1040         // Presales may have 0 bonus tokens but need to have a base amount of tokens sold.
1041         require(_baseTokens > 0);
1042         require(_bonusTokens < _baseTokens);
1043 
1044         // We do not count bonus tokens as part of the sale cap.
1045         totalTokensSold = totalTokensSold.add(_baseTokens);
1046         require(totalTokensSold <= TOKENS_SALE);
1047 
1048         uint256 ownBalance = tokenContract.balanceOf(address(this));
1049         require(_baseTokens <= ownBalance);
1050 
1051         totalPresaleBase  = totalPresaleBase.add(_baseTokens);
1052         totalPresaleBonus = totalPresaleBonus.add(_bonusTokens);
1053 
1054         // Move base tokens to the trustee
1055         require(tokenContract.transfer(address(trusteeContract), _baseTokens));
1056 
1057         // Presale allocations are marked as locked, they cannot be removed by the owner.
1058         uint256 tokens = _baseTokens.add(_bonusTokens);
1059         require(trusteeContract.grantAllocation(_account, tokens, false /* revokable */));
1060 
1061         PresaleAdded(_account, _baseTokens, _bonusTokens);
1062 
1063         return true;
1064     }
1065 
1066 
1067     //
1068     // PAUSE / UNPAUSE
1069     //
1070 
1071     // Allows the owner or admin to pause the sale for any reason.
1072     function pause() public onlyAdmin whenNotPaused {
1073         require(hasSaleEnded() == false);
1074 
1075         pausedTime = currentTime();
1076 
1077         return super.pause();
1078     }
1079 
1080 
1081     // Unpause may extend the end time of the public sale.
1082     // Note that we do not extend the start time of each phase.
1083     // Currently does not extend phase 1 end time, only final end time.
1084     function unpause() public onlyAdmin whenPaused {
1085 
1086         // If owner unpauses before sale starts, no impact on end time.
1087         uint256 current = currentTime();
1088 
1089         // If owner unpauses after sale starts, calculate how to extend end.
1090         if (current > PHASE1_START_TIME) {
1091             uint256 timeDelta;
1092 
1093             if (pausedTime < PHASE1_START_TIME) {
1094                 // Pause was triggered before the start time, extend by time that
1095                 // passed from proposed start time until now.
1096                 timeDelta = current.sub(PHASE1_START_TIME);
1097             } else {
1098                 // Pause was triggered while the sale was already started.
1099                 // Extend end time by amount of time since pause.
1100                 timeDelta = current.sub(pausedTime);
1101             }
1102 
1103             endTime = endTime.add(timeDelta);
1104         }
1105 
1106         pausedTime = 0;
1107 
1108         return super.unpause();
1109     }
1110 
1111 
1112     // Allows the admin to move bonus tokens still available in the sale contract
1113     // out before burning all remaining unsold tokens in burnUnsoldTokens().
1114     // Used to distribute bonuses to token sale participants when the sale has ended
1115     // and all bonuses are known.
1116     function reclaimTokens(uint256 _amount) external onlyAfterSale onlyAdmin returns (bool) {
1117         uint256 ownBalance = tokenContract.balanceOf(address(this));
1118         require(_amount <= ownBalance);
1119         
1120         address tokenOwner = tokenContract.owner();
1121         require(tokenOwner != address(0));
1122 
1123         require(tokenContract.transfer(tokenOwner, _amount));
1124 
1125         TokensReclaimed(_amount);
1126 
1127         return true;
1128     }
1129 
1130 
1131     // Allows the admin to burn all unsold tokens in the sale contract.
1132     function burnUnsoldTokens() external onlyAfterSale onlyAdmin returns (bool) {
1133         uint256 ownBalance = tokenContract.balanceOf(address(this));
1134 
1135         require(tokenContract.burn(ownBalance));
1136 
1137         UnsoldTokensBurnt(ownBalance);
1138 
1139         return true;
1140     }
1141 
1142 
1143     // Allows the admin to finalize the sale and complete allocations.
1144     // The SimpleToken.admin also needs to finalize the token contract
1145     // so that token transfers are enabled.
1146     function finalize() external onlyAdmin returns (bool) {
1147         return finalizeInternal();
1148     }
1149 
1150 
1151     // The internal one will be called if tokens are sold out or
1152     // the end time for the sale is reached, in addition to being called
1153     // from the public version of finalize().
1154     function finalizeInternal() private returns (bool) {
1155         require(!finalized);
1156 
1157         finalized = true;
1158 
1159         Finalized();
1160 
1161         return true;
1162     }
1163 }