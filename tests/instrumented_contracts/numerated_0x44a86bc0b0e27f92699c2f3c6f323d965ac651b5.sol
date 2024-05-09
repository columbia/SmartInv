1 /**
2  * Tokensale.sol
3  * Mt Pelerin Share (MPS) token sale : public phase.
4 
5  * More info about MPS : https://github.com/MtPelerin/MtPelerin-share-MPS
6 
7  * The unflattened code is available through this github tag:
8  * https://github.com/MtPelerin/MtPelerin-protocol/tree/etherscan-verify-batch-2
9 
10  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
11 
12  * @notice All matters regarding the intellectual property of this code 
13  * @notice or software are subject to Swiss Law without reference to its 
14  * @notice conflicts of law rules.
15 
16  * @notice License for each contract is available in the respective file
17  * @notice or in the LICENSE.md file.
18  * @notice https://github.com/MtPelerin/
19 
20  * @notice Code by OpenZeppelin is copyrighted and licensed on their repository:
21  * @notice https://github.com/OpenZeppelin/openzeppelin-solidity
22  */
23 
24 
25 pragma solidity ^0.4.24;
26 
27 // File: contracts/interface/IUserRegistry.sol
28 
29 /**
30  * @title IUserRegistry
31  * @dev IUserRegistry interface
32  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
33  *
34  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
35  * @notice Please refer to the top of this file for the license.
36  **/
37 contract IUserRegistry {
38 
39   function registerManyUsers(address[] _addresses, uint256 _validUntilTime)
40     public;
41 
42   function attachManyAddresses(uint256[] _userIds, address[] _addresses)
43     public;
44 
45   function detachManyAddresses(address[] _addresses)
46     public;
47 
48   function userCount() public view returns (uint256);
49   function userId(address _address) public view returns (uint256);
50   function addressConfirmed(address _address) public view returns (bool);
51   function validUntilTime(uint256 _userId) public view returns (uint256);
52   function suspended(uint256 _userId) public view returns (bool);
53   function extended(uint256 _userId, uint256 _key)
54     public view returns (uint256);
55 
56   function isAddressValid(address _address) public view returns (bool);
57   function isValid(uint256 _userId) public view returns (bool);
58 
59   function registerUser(address _address, uint256 _validUntilTime) public;
60   function attachAddress(uint256 _userId, address _address) public;
61   function confirmSelf() public;
62   function detachAddress(address _address) public;
63   function detachSelf() public;
64   function detachSelfAddress(address _address) public;
65   function suspendUser(uint256 _userId) public;
66   function unsuspendUser(uint256 _userId) public;
67   function suspendManyUsers(uint256[] _userIds) public;
68   function unsuspendManyUsers(uint256[] _userIds) public;
69   function updateUser(uint256 _userId, uint256 _validUntil, bool _suspended)
70     public;
71 
72   function updateManyUsers(
73     uint256[] _userIds,
74     uint256 _validUntil,
75     bool _suspended) public;
76 
77   function updateUserExtended(uint256 _userId, uint256 _key, uint256 _value)
78     public;
79 
80   function updateManyUsersExtended(
81     uint256[] _userIds,
82     uint256 _key,
83     uint256 _value) public;
84 }
85 
86 // File: contracts/interface/IRatesProvider.sol
87 
88 /**
89  * @title IRatesProvider
90  * @dev IRatesProvider interface
91  *
92  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
93  *
94  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
95  * @notice Please refer to the top of this file for the license.
96  */
97 contract IRatesProvider {
98   function rateWEIPerCHFCent() public view returns (uint256);
99   function convertWEIToCHFCent(uint256 _amountWEI)
100     public view returns (uint256);
101 
102   function convertCHFCentToWEI(uint256 _amountCHFCent)
103     public view returns (uint256);
104 }
105 
106 // File: contracts/zeppelin/token/ERC20/ERC20Basic.sol
107 
108 /**
109  * @title ERC20Basic
110  * @dev Simpler version of ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/179
112  */
113 contract ERC20Basic {
114   function totalSupply() public view returns (uint256);
115   function balanceOf(address who) public view returns (uint256);
116   function transfer(address to, uint256 value) public returns (bool);
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 // File: contracts/zeppelin/token/ERC20/ERC20.sol
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender)
128     public view returns (uint256);
129 
130   function transferFrom(address from, address to, uint256 value)
131     public returns (bool);
132 
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(
135     address indexed owner,
136     address indexed spender,
137     uint256 value
138   );
139 }
140 
141 // File: contracts/interface/ITokensale.sol
142 
143 /**
144  * @title ITokensale
145  * @dev ITokensale interface
146  *
147  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
148  *
149  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
150  * @notice Please refer to the top of this file for the license.
151  */
152 contract ITokensale {
153 
154   function () external payable;
155 
156   uint256 constant MINIMAL_AUTO_WITHDRAW = 0.5 ether;
157   uint256 constant MINIMAL_BALANCE = 0.5 ether;
158   uint256 constant MINIMAL_INVESTMENT = 50; // tokens
159   uint256 constant BASE_PRICE_CHF_CENT = 500;
160   uint256 constant KYC_LEVEL_KEY = 1;
161 
162   function minimalAutoWithdraw() public view returns (uint256);
163   function minimalBalance() public view returns (uint256);
164   function basePriceCHFCent() public view returns (uint256);
165 
166   /* General sale details */
167   function token() public view returns (ERC20);
168   function vaultETH() public view returns (address);
169   function vaultERC20() public view returns (address);
170   function userRegistry() public view returns (IUserRegistry);
171   function ratesProvider() public view returns (IRatesProvider);
172   function sharePurchaseAgreementHash() public view returns (bytes32);
173 
174   /* Sale status */
175   function startAt() public view returns (uint256);
176   function endAt() public view returns (uint256);
177   function raisedETH() public view returns (uint256);
178   function raisedCHF() public view returns (uint256);
179   function totalRaisedCHF() public view returns (uint256);
180   function totalUnspentETH() public view returns (uint256);
181   function totalRefundedETH() public view returns (uint256);
182   function availableSupply() public view returns (uint256);
183 
184   /* Investor specific attributes */
185   function investorUnspentETH(uint256 _investorId)
186     public view returns (uint256);
187 
188   function investorInvestedCHF(uint256 _investorId)
189     public view returns (uint256);
190 
191   function investorAcceptedSPA(uint256 _investorId)
192     public view returns (bool);
193 
194   function investorAllocations(uint256 _investorId)
195     public view returns (uint256);
196 
197   function investorTokens(uint256 _investorId) public view returns (uint256);
198   function investorCount() public view returns (uint256);
199 
200   function investorLimit(uint256 _investorId) public view returns (uint256);
201 
202   /* Share Purchase Agreement */
203   function defineSPA(bytes32 _sharePurchaseAgreementHash)
204     public returns (bool);
205 
206   function acceptSPA(bytes32 _sharePurchaseAgreementHash)
207     public payable returns (bool);
208 
209   /* Investment */
210   function investETH() public payable;
211   function addOffChainInvestment(address _investor, uint256 _amountCHF)
212     public;
213 
214   /* Schedule */
215   function updateSchedule(uint256 _startAt, uint256 _endAt) public;
216 
217   /* Allocations admin */
218   function allocateTokens(address _investor, uint256 _amount)
219     public returns (bool);
220 
221   function allocateManyTokens(address[] _investors, uint256[] _amounts)
222     public returns (bool);
223 
224   /* ETH administration */
225   function fundETH() public payable;
226   function refundManyUnspentETH(address[] _receivers) public;
227   function refundUnspentETH(address _receiver) public;
228   function withdrawETHFunds() public;
229 
230   event SalePurchaseAgreementHash(bytes32 sharePurchaseAgreement);
231   event Allocation(
232     uint256 investorId,
233     uint256 tokens
234   );
235   event Investment(
236     uint256 investorId,
237     uint256 spentCHF
238   );
239   event ChangeETHCHF(
240     address investor,
241     uint256 amount,
242     uint256 converted,
243     uint256 rate
244   );
245   event FundETH(uint256 amount);
246   event WithdrawETH(address receiver, uint256 amount);
247 }
248 
249 // File: contracts/zeppelin/math/SafeMath.sol
250 
251 /**
252  * @title SafeMath
253  * @dev Math operations with safety checks that throw on error
254  */
255 library SafeMath {
256 
257   /**
258   * @dev Multiplies two numbers, throws on overflow.
259   */
260   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
261     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
262     // benefit is lost if 'b' is also tested.
263     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
264     if (a == 0) {
265       return 0;
266     }
267 
268     c = a * b;
269     assert(c / a == b);
270     return c;
271   }
272 
273   /**
274   * @dev Integer division of two numbers, truncating the quotient.
275   */
276   function div(uint256 a, uint256 b) internal pure returns (uint256) {
277     // assert(b > 0); // Solidity automatically throws when dividing by 0
278     // uint256 c = a / b;
279     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
280     return a / b;
281   }
282 
283   /**
284   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
285   */
286   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
287     assert(b <= a);
288     return a - b;
289   }
290 
291   /**
292   * @dev Adds two numbers, throws on overflow.
293   */
294   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
295     c = a + b;
296     assert(c >= a);
297     return c;
298   }
299 }
300 
301 // File: contracts/zeppelin/ownership/Ownable.sol
302 
303 /**
304  * @title Ownable
305  * @dev The Ownable contract has an owner address, and provides basic authorization control
306  * functions, this simplifies the implementation of "user permissions".
307  */
308 contract Ownable {
309   address public owner;
310 
311 
312   event OwnershipRenounced(address indexed previousOwner);
313   event OwnershipTransferred(
314     address indexed previousOwner,
315     address indexed newOwner
316   );
317 
318 
319   /**
320    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
321    * account.
322    */
323   constructor() public {
324     owner = msg.sender;
325   }
326 
327   /**
328    * @dev Throws if called by any account other than the owner.
329    */
330   modifier onlyOwner() {
331     require(msg.sender == owner);
332     _;
333   }
334 
335   /**
336    * @dev Allows the current owner to relinquish control of the contract.
337    */
338   function renounceOwnership() public onlyOwner {
339     emit OwnershipRenounced(owner);
340     owner = address(0);
341   }
342 
343   /**
344    * @dev Allows the current owner to transfer control of the contract to a newOwner.
345    * @param _newOwner The address to transfer ownership to.
346    */
347   function transferOwnership(address _newOwner) public onlyOwner {
348     _transferOwnership(_newOwner);
349   }
350 
351   /**
352    * @dev Transfers control of the contract to a newOwner.
353    * @param _newOwner The address to transfer ownership to.
354    */
355   function _transferOwnership(address _newOwner) internal {
356     require(_newOwner != address(0));
357     emit OwnershipTransferred(owner, _newOwner);
358     owner = _newOwner;
359   }
360 }
361 
362 // File: contracts/zeppelin/lifecycle/Pausable.sol
363 
364 /**
365  * @title Pausable
366  * @dev Base contract which allows children to implement an emergency stop mechanism.
367  */
368 contract Pausable is Ownable {
369   event Pause();
370   event Unpause();
371 
372   bool public paused = false;
373 
374 
375   /**
376    * @dev Modifier to make a function callable only when the contract is not paused.
377    */
378   modifier whenNotPaused() {
379     require(!paused);
380     _;
381   }
382 
383   /**
384    * @dev Modifier to make a function callable only when the contract is paused.
385    */
386   modifier whenPaused() {
387     require(paused);
388     _;
389   }
390 
391   /**
392    * @dev called by the owner to pause, triggers stopped state
393    */
394   function pause() onlyOwner whenNotPaused public {
395     paused = true;
396     emit Pause();
397   }
398 
399   /**
400    * @dev called by the owner to unpause, returns to normal state
401    */
402   function unpause() onlyOwner whenPaused public {
403     paused = false;
404     emit Unpause();
405   }
406 }
407 
408 // File: contracts/Authority.sol
409 
410 /**
411  * @title Authority
412  * @dev The Authority contract has an authority address, and provides basic authorization control
413  * functions, this simplifies the implementation of "user permissions".
414  * Authority means to represent a legal entity that is entitled to specific rights
415  *
416  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
417  *
418  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
419  * @notice Please refer to the top of this file for the license.
420  *
421  * Error messages
422  * AU01: Message sender must be an authority
423  */
424 contract Authority is Ownable {
425 
426   address authority;
427 
428   /**
429    * @dev Throws if called by any account other than the authority.
430    */
431   modifier onlyAuthority {
432     require(msg.sender == authority, "AU01");
433     _;
434   }
435 
436   /**
437    * @dev Returns the address associated to the authority
438    */
439   function authorityAddress() public view returns (address) {
440     return authority;
441   }
442 
443   /** Define an address as authority, with an arbitrary name included in the event
444    * @dev returns the authority of the
445    * @param _name the authority name
446    * @param _address the authority address.
447    */
448   function defineAuthority(string _name, address _address) public onlyOwner {
449     emit AuthorityDefined(_name, _address);
450     authority = _address;
451   }
452 
453   event AuthorityDefined(
454     string name,
455     address _address
456   );
457 }
458 
459 // File: contracts/tokensale/Tokensale.sol
460 
461 /**
462  * @title Tokensale
463  * @dev Tokensale contract
464  *
465  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
466  *
467  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
468  * @notice Please refer to the top of this file for the license.
469  *
470  * Error messages
471  * TOS01: It must be before the sale is opened
472  * TOS02: Sale must be open
473  * TOS03: It must be before the sale is closed
474  * TOS04: It must be after the sale is closed
475  * TOS05: No data must be sent while sending ETH
476  * TOS06: Share Purchase Agreement Hashes must match
477  * TOS07: User/Investor must exist
478  * TOS08: SPA must be accepted before any ETH investment
479  * TOS09: Cannot update schedule once started
480  * TOS10: Investor must exist
481  * TOS11: Cannot allocate more tokens than available supply
482  * TOS12: Length of InvestorIds and amounts arguments must match
483  * TOS13: Investor must exist
484  * TOS14: Must refund ETH unspent
485  * TOS15: Must withdraw ETH to vaultETH
486  * TOS16: Cannot invest onchain and offchain at the same time
487  * TOS17: A ETHCHF rate must exist to invest
488  * TOS18: User must be valid
489  * TOS19: Cannot invest if no tokens are available
490  * TOS20: Investment is below the minimal investment
491  * TOS21: Cannot unspend more CHF than BASE_TOKEN_PRICE_CHF
492  * TOS22: Token transfer must be successful
493  */
494 contract Tokensale is ITokensale, Authority, Pausable {
495   using SafeMath for uint256;
496 
497   uint32[5] contributionLimits = [
498     5000,
499     500000,
500     1500000,
501     10000000,
502     25000000
503   ];
504 
505   /* General sale details */
506   ERC20 public token;
507   address public vaultETH;
508   address public vaultERC20;
509   IUserRegistry public userRegistry;
510   IRatesProvider public ratesProvider;
511 
512   uint256 public minimalBalance = MINIMAL_BALANCE;
513   bytes32 public sharePurchaseAgreementHash;
514 
515   uint256 public startAt = 4102441200;
516   uint256 public endAt = 4102441200;
517   uint256 public raisedETH;
518   uint256 public raisedCHF;
519   uint256 public totalRaisedCHF;
520   uint256 public totalUnspentETH;
521   uint256 public totalRefundedETH;
522   uint256 public allocatedTokens;
523 
524   struct Investor {
525     uint256 unspentETH;
526     uint256 investedCHF;
527     bool acceptedSPA;
528     uint256 allocations;
529     uint256 tokens;
530   }
531   mapping(uint256 => Investor) investors;
532   mapping(uint256 => uint256) investorLimits;
533   uint256 public investorCount;
534 
535   /**
536    * @dev Throws unless before sale opening
537    */
538   modifier beforeSaleIsOpened {
539     require(currentTime() < startAt, "TOS01");
540     _;
541   }
542 
543   /**
544    * @dev Throws if sale is not open
545    */
546   modifier saleIsOpened {
547     require(currentTime() >= startAt && currentTime() <= endAt, "TOS02");
548     _;
549   }
550 
551   /**
552    * @dev Throws once the sale is closed
553    */
554   modifier beforeSaleIsClosed {
555     require(currentTime() <= endAt, "TOS03");
556     _;
557   }
558 
559   /**
560    * @dev constructor
561    */
562   constructor(
563     ERC20 _token,
564     IUserRegistry _userRegistry,
565     IRatesProvider _ratesProvider,
566     address _vaultERC20,
567     address _vaultETH
568   ) public
569   {
570     token = _token;
571     userRegistry = _userRegistry;
572     ratesProvider = _ratesProvider;
573     vaultERC20 = _vaultERC20;
574     vaultETH = _vaultETH;
575   }
576 
577   /**
578    * @dev fallback function
579    */
580   function () external payable {
581     require(msg.data.length == 0, "TOS05");
582     investETH();
583   }
584 
585   /**
586    * @dev returns the token sold
587    */
588   function token() public view returns (ERC20) {
589     return token;
590   }
591 
592   /**
593    * @dev returns the vault use to
594    */
595   function vaultETH() public view returns (address) {
596     return vaultETH;
597   }
598 
599   /**
600    * @dev returns the vault to receive ETH
601    */
602   function vaultERC20() public view returns (address) {
603     return vaultERC20;
604   }
605 
606   function userRegistry() public view returns (IUserRegistry) {
607     return userRegistry;
608   }
609 
610   function ratesProvider() public view returns (IRatesProvider) {
611     return ratesProvider;
612   }
613 
614   function sharePurchaseAgreementHash() public view returns (bytes32) {
615     return sharePurchaseAgreementHash;
616   }
617 
618   /* Sale status */
619   function startAt() public view returns (uint256) {
620     return startAt;
621   }
622 
623   function endAt() public view returns (uint256) {
624     return endAt;
625   }
626 
627   function raisedETH() public view returns (uint256) {
628     return raisedETH;
629   }
630 
631   function raisedCHF() public view returns (uint256) {
632     return raisedCHF;
633   }
634 
635   function totalRaisedCHF() public view returns (uint256) {
636     return totalRaisedCHF;
637   }
638 
639   function totalUnspentETH() public view returns (uint256) {
640     return totalUnspentETH;
641   }
642 
643   function totalRefundedETH() public view returns (uint256) {
644     return totalRefundedETH;
645   }
646 
647   function availableSupply() public view returns (uint256) {
648     uint256 vaultSupply = token.balanceOf(vaultERC20);
649     uint256 allowance = token.allowance(vaultERC20, address(this));
650     return (vaultSupply < allowance) ? vaultSupply : allowance;
651   }
652  
653   /* Investor specific attributes */
654   function investorUnspentETH(uint256 _investorId)
655     public view returns (uint256)
656   {
657     return investors[_investorId].unspentETH;
658   }
659 
660   function investorInvestedCHF(uint256 _investorId)
661     public view returns (uint256)
662   {
663     return investors[_investorId].investedCHF;
664   }
665 
666   function investorAcceptedSPA(uint256 _investorId)
667     public view returns (bool)
668   {
669     return investors[_investorId].acceptedSPA;
670   }
671 
672   function investorAllocations(uint256 _investorId)
673     public view returns (uint256)
674   {
675     return investors[_investorId].allocations;
676   }
677 
678   function investorTokens(uint256 _investorId) public view returns (uint256) {
679     return investors[_investorId].tokens;
680   }
681 
682   function investorCount() public view returns (uint256) {
683     return investorCount;
684   }
685 
686   function investorLimit(uint256 _investorId) public view returns (uint256) {
687     return investorLimits[_investorId];
688   }
689 
690   /**
691    * @dev get minimak auto withdraw threshold
692    */
693   function minimalAutoWithdraw() public view returns (uint256) {
694     return MINIMAL_AUTO_WITHDRAW;
695   }
696 
697   /**
698    * @dev get minimal balance to maintain in contract
699    */
700   function minimalBalance() public view returns (uint256) {
701     return minimalBalance;
702   }
703 
704   /**
705    * @dev get base price in CHF cents
706    */
707   function basePriceCHFCent() public view returns (uint256) {
708     return BASE_PRICE_CHF_CENT;
709   }
710 
711   /**
712    * @dev contribution limit based on kyc level
713    */
714   function contributionLimit(uint256 _investorId)
715     public view returns (uint256)
716   {
717     uint256 kycLevel = userRegistry.extended(_investorId, KYC_LEVEL_KEY);
718     uint256 limit = 0;
719     if (kycLevel < 5) {
720       limit = contributionLimits[kycLevel];
721     } else {
722       limit = (investorLimits[_investorId] > 0
723         ) ? investorLimits[_investorId] : contributionLimits[4];
724     }
725     return limit.sub(investors[_investorId].investedCHF);
726   }
727 
728   /**
729    * @dev update minimal balance to be kept in contract
730    */
731   function updateMinimalBalance(uint256 _minimalBalance)
732     public returns (uint256)
733   {
734     minimalBalance = _minimalBalance;
735   }
736 
737   /**
738    * @dev define investor limit
739    */
740   function updateInvestorLimits(uint256[] _investorIds, uint256 _limit)
741     public returns (uint256)
742   {
743     for (uint256 i = 0; i < _investorIds.length; i++) {
744       investorLimits[_investorIds[i]] = _limit;
745     }
746   }
747 
748   /* Share Purchase Agreement */
749   /**
750    * @dev define SPA
751    */
752   function defineSPA(bytes32 _sharePurchaseAgreementHash)
753     public onlyOwner returns (bool)
754   {
755     sharePurchaseAgreementHash = _sharePurchaseAgreementHash;
756     emit SalePurchaseAgreementHash(_sharePurchaseAgreementHash);
757   }
758 
759   /**
760    * @dev Accept SPA and invest if msg.value > 0
761    */
762   function acceptSPA(bytes32 _sharePurchaseAgreementHash)
763     public beforeSaleIsClosed payable returns (bool)
764   {
765     require(
766       _sharePurchaseAgreementHash == sharePurchaseAgreementHash, "TOS06");
767     uint256 investorId = userRegistry.userId(msg.sender);
768     require(investorId > 0, "TOS07");
769     investors[investorId].acceptedSPA = true;
770     investorCount++;
771 
772     if (msg.value > 0) {
773       investETH();
774     }
775   }
776 
777   /* Investment */
778   function investETH() public
779     saleIsOpened whenNotPaused payable
780   {
781     //Accepting SharePurchaseAgreement is temporarily offchain
782     //uint256 investorId = userRegistry.userId(msg.sender);
783     //require(investors[investorId].acceptedSPA, "TOS08");
784     investInternal(msg.sender, msg.value, 0);
785     withdrawETHFundsInternal();
786   }
787 
788   /**
789    * @dev add off chain investment
790    */
791   function addOffChainInvestment(address _investor, uint256 _amountCHF)
792     public onlyAuthority
793   {
794     investInternal(_investor, 0, _amountCHF);
795   }
796 
797   /* Schedule */ 
798   /**
799    * @dev update schedule
800    */
801   function updateSchedule(uint256 _startAt, uint256 _endAt)
802     public onlyAuthority beforeSaleIsOpened
803   {
804     require(_startAt < _endAt, "TOS09");
805     startAt = _startAt;
806     endAt = _endAt;
807   }
808 
809   /* Allocations admin */
810   /**
811    * @dev allocate
812    */
813   function allocateTokens(address _investor, uint256 _amount)
814     public onlyAuthority beforeSaleIsClosed returns (bool)
815   {
816     uint256 investorId = userRegistry.userId(_investor);
817     require(investorId > 0, "TOS10");
818     Investor storage investor = investors[investorId];
819     
820     allocatedTokens = allocatedTokens.sub(investor.allocations).add(_amount);
821     require(allocatedTokens <= availableSupply(), "TOS11");
822 
823     investor.allocations = _amount;
824     emit Allocation(investorId, _amount);
825   }
826 
827   /**
828    * @dev allocate many
829    */
830   function allocateManyTokens(address[] _investors, uint256[] _amounts)
831     public onlyAuthority beforeSaleIsClosed returns (bool)
832   {
833     require(_investors.length == _amounts.length, "TOS12");
834     for (uint256 i = 0; i < _investors.length; i++) {
835       allocateTokens(_investors[i], _amounts[i]);
836     }
837   }
838 
839   /* ETH administration */
840   /**
841    * @dev fund ETH
842    */
843   function fundETH() public payable onlyAuthority {
844     emit FundETH(msg.value);
845   }
846 
847   /**
848    * @dev refund unspent ETH many
849    */
850   function refundManyUnspentETH(address[] _receivers) public onlyAuthority {
851     for (uint256 i = 0; i < _receivers.length; i++) {
852       refundUnspentETH(_receivers[i]);
853     }
854   }
855 
856   /**
857    * @dev refund unspent ETH
858    */
859   function refundUnspentETH(address _receiver) public onlyAuthority {
860     uint256 investorId = userRegistry.userId(_receiver);
861     require(investorId != 0, "TOS13");
862     Investor storage investor = investors[investorId];
863 
864     if (investor.unspentETH > 0) {
865       // solium-disable-next-line security/no-send
866       require(_receiver.send(investor.unspentETH), "TOS14");
867       totalRefundedETH = totalRefundedETH.add(investor.unspentETH);
868       emit WithdrawETH(_receiver, investor.unspentETH);
869       totalUnspentETH = totalUnspentETH.sub(investor.unspentETH);
870       investor.unspentETH = 0;
871     }
872   }
873 
874   /**
875    * @dev withdraw ETH funds
876    */
877   function withdrawETHFunds() public onlyAuthority {
878     withdrawETHFundsInternal();
879   }
880 
881   /**
882    * @dev withdraw all ETH funds
883    */
884   function withdrawAllETHFunds() public onlyAuthority {
885     uint256 balance = address(this).balance;
886     // solium-disable-next-line security/no-send
887     require(vaultETH.send(balance), "TOS15");
888     emit WithdrawETH(vaultETH, balance);
889   }
890 
891   /**
892    * @dev allowed token investment
893    */
894   function allowedTokenInvestment(
895     uint256 _investorId, uint256 _contributionCHF)
896     public view returns (uint256)
897   {
898     uint256 tokens = 0;
899     uint256 allowedContributionCHF = contributionLimit(_investorId);
900     if (_contributionCHF < allowedContributionCHF) {
901       allowedContributionCHF = _contributionCHF;
902     }
903     tokens = allowedContributionCHF.div(BASE_PRICE_CHF_CENT);
904     uint256 availableTokens = availableSupply().sub(
905       allocatedTokens).add(investors[_investorId].allocations);
906     if (tokens > availableTokens) {
907       tokens = availableTokens;
908     }
909     if (tokens < MINIMAL_INVESTMENT) {
910       tokens = 0;
911     }
912     return tokens;
913   }
914 
915   /**
916    * @dev withdraw ETH funds internal
917    */
918   function withdrawETHFundsInternal() internal {
919     uint256 balance = address(this).balance;
920 
921     if (balance > totalUnspentETH && balance > minimalBalance) {
922       uint256 amount = balance.sub(minimalBalance);
923       // solium-disable-next-line security/no-send
924       require(vaultETH.send(amount), "TOS15");
925       emit WithdrawETH(vaultETH, amount);
926     }
927   }
928 
929   /**
930    * @dev invest internal
931    */
932   function investInternal(
933     address _investor, uint256 _amountETH, uint256 _amountCHF)
934     private
935   {
936     // investment with _amountETH is decentralized
937     // investment with _amountCHF is centralized
938     // They are mutually exclusive
939     bool isInvesting = (
940         _amountETH != 0 && _amountCHF == 0
941       ) || (
942       _amountETH == 0 && _amountCHF != 0
943       );
944     require(isInvesting, "TOS16");
945     require(ratesProvider.rateWEIPerCHFCent() != 0, "TOS17");
946     uint256 investorId = userRegistry.userId(_investor);
947     require(userRegistry.isValid(investorId), "TOS18");
948 
949     Investor storage investor = investors[investorId];
950 
951     uint256 contributionCHF = ratesProvider.convertWEIToCHFCent(
952       investor.unspentETH);
953 
954     if (_amountETH > 0) {
955       contributionCHF = contributionCHF.add(
956         ratesProvider.convertWEIToCHFCent(_amountETH));
957     }
958     if (_amountCHF > 0) {
959       contributionCHF = contributionCHF.add(_amountCHF);
960     }
961 
962     uint256 tokens = allowedTokenInvestment(investorId, contributionCHF);
963     require(tokens != 0, "TOS19");
964 
965     /** Calculating unspentETH value **/
966     uint256 investedCHF = tokens.mul(BASE_PRICE_CHF_CENT);
967     uint256 unspentContributionCHF = contributionCHF.sub(investedCHF);
968 
969     uint256 unspentETH = 0;
970     if (unspentContributionCHF != 0) {
971       if (_amountCHF > 0) {
972         // Prevent CHF investment LARGER than available supply
973         // from creating a too large and dangerous unspentETH value
974         require(unspentContributionCHF < BASE_PRICE_CHF_CENT, "TOS21");
975       }
976       unspentETH = ratesProvider.convertCHFCentToWEI(
977         unspentContributionCHF);
978     }
979 
980     /** Spent ETH **/
981     uint256 spentETH = 0;
982     if (investor.unspentETH == unspentETH) {
983       spentETH = _amountETH;
984     } else {
985       uint256 unspentETHDiff = (unspentETH > investor.unspentETH)
986         ? unspentETH.sub(investor.unspentETH)
987         : investor.unspentETH.sub(unspentETH);
988 
989       if (_amountCHF > 0) {
990         if (unspentETH < investor.unspentETH) {
991           spentETH = unspentETHDiff;
992         }
993         // if unspentETH > investor.unspentETH
994         // then CHF has been converted into ETH
995         // and no ETH were spent
996       }
997       if (_amountETH > 0) {
998         spentETH = (unspentETH > investor.unspentETH)
999           ? _amountETH.sub(unspentETHDiff)
1000           : _amountETH.add(unspentETHDiff);
1001       }
1002     }
1003 
1004     totalUnspentETH = totalUnspentETH.sub(
1005       investor.unspentETH).add(unspentETH);
1006     investor.unspentETH = unspentETH;
1007     investor.investedCHF = investor.investedCHF.add(investedCHF);
1008     investor.tokens = investor.tokens.add(tokens);
1009     raisedCHF = raisedCHF.add(_amountCHF);
1010     raisedETH = raisedETH.add(spentETH);
1011     totalRaisedCHF = totalRaisedCHF.add(investedCHF);
1012 
1013     allocatedTokens = allocatedTokens.sub(investor.allocations);
1014     investor.allocations = (investor.allocations > tokens)
1015       ? investor.allocations.sub(tokens) : 0;
1016     allocatedTokens = allocatedTokens.add(investor.allocations);
1017     require(
1018       token.transferFrom(vaultERC20, _investor, tokens),
1019       "TOS22");
1020 
1021     if (spentETH > 0) {
1022       emit ChangeETHCHF(
1023         _investor,
1024         spentETH,
1025         ratesProvider.convertWEIToCHFCent(spentETH),
1026         ratesProvider.rateWEIPerCHFCent());
1027     }
1028     emit Investment(investorId, investedCHF);
1029   }
1030 
1031   /* Util */
1032   /**
1033    * @dev current time
1034    */
1035   function currentTime() private view returns (uint256) {
1036     // solium-disable-next-line security/no-block-members
1037     return now;
1038   }
1039 }