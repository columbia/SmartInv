1 /**
2  * Tokensale.sol
3  * MPS Token (Mt Pelerin Share) token sale : private round.
4 
5  * More info about MPS : https://github.com/MtPelerin/MtPelerin-share-MPS
6 
7  * The unflattened code is available through this github tag:
8  * https://github.com/MtPelerin/MtPelerin-protocol/tree/etherscan-verify-batch-1
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
24 pragma solidity ^0.4.24;
25 
26 // File: contracts/interface/IUserRegistry.sol
27 
28 /**
29  * @title IUserRegistry
30  * @dev IUserRegistry interface
31  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
32  *
33  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
34  * @notice Please refer to the top of this file for the license.
35  **/
36 contract IUserRegistry {
37 
38   function registerManyUsers(address[] _addresses, uint256 _validUntilTime)
39     public;
40 
41   function attachManyAddresses(uint256[] _userIds, address[] _addresses)
42     public;
43 
44   function detachManyAddresses(address[] _addresses)
45     public;
46 
47   function userCount() public view returns (uint256);
48   function userId(address _address) public view returns (uint256);
49   function addressConfirmed(address _address) public view returns (bool);
50   function validUntilTime(uint256 _userId) public view returns (uint256);
51   function suspended(uint256 _userId) public view returns (bool);
52   function extended(uint256 _userId, uint256 _key)
53     public view returns (uint256);
54 
55   function isAddressValid(address _address) public view returns (bool);
56   function isValid(uint256 _userId) public view returns (bool);
57 
58   function registerUser(address _address, uint256 _validUntilTime) public;
59   function attachAddress(uint256 _userId, address _address) public;
60   function confirmSelf() public;
61   function detachAddress(address _address) public;
62   function detachSelf() public;
63   function detachSelfAddress(address _address) public;
64   function suspendUser(uint256 _userId) public;
65   function unsuspendUser(uint256 _userId) public;
66   function suspendManyUsers(uint256[] _userIds) public;
67   function unsuspendManyUsers(uint256[] _userIds) public;
68   function updateUser(uint256 _userId, uint256 _validUntil, bool _suspended)
69     public;
70 
71   function updateManyUsers(
72     uint256[] _userIds,
73     uint256 _validUntil,
74     bool _suspended) public;
75 
76   function updateUserExtended(uint256 _userId, uint256 _key, uint256 _value)
77     public;
78 
79   function updateManyUsersExtended(
80     uint256[] _userIds,
81     uint256 _key,
82     uint256 _value) public;
83 }
84 
85 // File: contracts/interface/IRatesProvider.sol
86 
87 /**
88  * @title IRatesProvider
89  * @dev IRatesProvider interface
90  *
91  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
92  *
93  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
94  * @notice Please refer to the top of this file for the license.
95  */
96 contract IRatesProvider {
97   function rateWEIPerCHFCent() public view returns (uint256);
98   function convertWEIToCHFCent(uint256 _amountWEI)
99     public view returns (uint256);
100 
101   function convertCHFCentToWEI(uint256 _amountCHFCent)
102     public view returns (uint256);
103 }
104 
105 // File: contracts/zeppelin/token/ERC20/ERC20Basic.sol
106 
107 /**
108  * @title ERC20Basic
109  * @dev Simpler version of ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/179
111  */
112 contract ERC20Basic {
113   function totalSupply() public view returns (uint256);
114   function balanceOf(address who) public view returns (uint256);
115   function transfer(address to, uint256 value) public returns (bool);
116   event Transfer(address indexed from, address indexed to, uint256 value);
117 }
118 
119 // File: contracts/zeppelin/token/ERC20/ERC20.sol
120 
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 contract ERC20 is ERC20Basic {
126   function allowance(address owner, address spender)
127     public view returns (uint256);
128 
129   function transferFrom(address from, address to, uint256 value)
130     public returns (bool);
131 
132   function approve(address spender, uint256 value) public returns (bool);
133   event Approval(
134     address indexed owner,
135     address indexed spender,
136     uint256 value
137   );
138 }
139 
140 // File: contracts/interface/ITokensale.sol
141 
142 /**
143  * @title ITokensale
144  * @dev ITokensale interface
145  *
146  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
147  *
148  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
149  * @notice Please refer to the top of this file for the license.
150  */
151 contract ITokensale {
152 
153   function () external payable;
154 
155   // Minimal Auto Withdraw must be allow the nominal price
156   // to ensure enough remains on the balance to refund the investors
157   uint256 constant MINIMAL_AUTO_WITHDRAW = 0.5 ether;
158   uint256 constant MINIMAL_BALANCE = 0.5 ether;
159   uint256 constant BASE_PRICE_CHF_CENT = 500;
160 
161   function minimalAutoWithdraw() public view returns (uint256);
162   function minimalBalance() public view returns (uint256);
163   function basePriceCHFCent() public view returns (uint256);
164 
165   /* General sale details */
166   function token() public view returns (ERC20);
167   function vaultETH() public view returns (address);
168   function vaultERC20() public view returns (address);
169   function userRegistry() public view returns (IUserRegistry);
170   function ratesProvider() public view returns (IRatesProvider);
171   function sharePurchaseAgreementHash() public view returns (bytes32);
172 
173   /* Sale status */
174   function startAt() public view returns (uint256);
175   function endAt() public view returns (uint256);
176   function raisedETH() public view returns (uint256);
177   function raisedCHF() public view returns (uint256);
178   function totalRaisedCHF() public view returns (uint256);
179   function refundedETH() public view returns (uint256);
180   function availableSupply() public view returns (uint256);
181 
182   /* Investor specific attributes */
183   function investorUnspentETH(uint256 _investorId)
184     public view returns (uint256);
185 
186   function investorInvestedCHF(uint256 _investorId)
187     public view returns (uint256);
188 
189   function investorAcceptedSPA(uint256 _investorId)
190     public view returns (bool);
191 
192   function investorAllocations(uint256 _investorId)
193     public view returns (uint256);
194 
195   function investorTokens(uint256 _investorId) public view returns (uint256);
196   function investorCount() public view returns (uint256);
197 
198   /* Share Purchase Agreement */
199   function defineSPA(bytes32 _sharePurchaseAgreementHash)
200     public returns (bool);
201 
202   function acceptSPA(bytes32 _sharePurchaseAgreementHash)
203     public payable returns (bool);
204 
205   /* Investment */
206   function investETH() public payable;
207   function addOffChainInvestment(address _investor, uint256 _amountCHF)
208     public;
209 
210   /* Schedule */
211   function updateSchedule(uint256 _startAt, uint256 _endAt) public;
212 
213   /* Allocations admin */
214   function allocateTokens(address _investor, uint256 _amount)
215     public returns (bool);
216 
217   function allocateManyTokens(address[] _investors, uint256[] _amounts)
218     public returns (bool);
219 
220   /* ETH administration */
221   function fundETH() public payable;
222   function refundManyUnspentETH(address[] _receivers) public;
223   function refundUnspentETH(address _receiver) public;
224   function withdrawETHFunds() public;
225   function autoWithdrawETHFunds() private;
226 
227   event SalePurchaseAgreementHash(bytes32 sharePurchaseAgreement);
228   event Allocation(
229     uint256 investorId,
230     uint256 tokens
231   );
232   event Investment(
233     uint256 investorId,
234     uint256 spentCHF
235   );
236   event ChangeETHCHF(
237     address investor,
238     uint256 amount,
239     uint256 converted,
240     uint256 rate
241   );
242   event FundETH(uint256 amount);
243   event WithdrawETH(address receiver, uint256 amount);
244 }
245 
246 // File: contracts/zeppelin/math/SafeMath.sol
247 
248 /**
249  * @title SafeMath
250  * @dev Math operations with safety checks that throw on error
251  */
252 library SafeMath {
253 
254   /**
255   * @dev Multiplies two numbers, throws on overflow.
256   */
257   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
258     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
259     // benefit is lost if 'b' is also tested.
260     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
261     if (a == 0) {
262       return 0;
263     }
264 
265     c = a * b;
266     assert(c / a == b);
267     return c;
268   }
269 
270   /**
271   * @dev Integer division of two numbers, truncating the quotient.
272   */
273   function div(uint256 a, uint256 b) internal pure returns (uint256) {
274     // assert(b > 0); // Solidity automatically throws when dividing by 0
275     // uint256 c = a / b;
276     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
277     return a / b;
278   }
279 
280   /**
281   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
282   */
283   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
284     assert(b <= a);
285     return a - b;
286   }
287 
288   /**
289   * @dev Adds two numbers, throws on overflow.
290   */
291   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
292     c = a + b;
293     assert(c >= a);
294     return c;
295   }
296 }
297 
298 // File: contracts/zeppelin/ownership/Ownable.sol
299 
300 /**
301  * @title Ownable
302  * @dev The Ownable contract has an owner address, and provides basic authorization control
303  * functions, this simplifies the implementation of "user permissions".
304  */
305 contract Ownable {
306   address public owner;
307 
308 
309   event OwnershipRenounced(address indexed previousOwner);
310   event OwnershipTransferred(
311     address indexed previousOwner,
312     address indexed newOwner
313   );
314 
315 
316   /**
317    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
318    * account.
319    */
320   constructor() public {
321     owner = msg.sender;
322   }
323 
324   /**
325    * @dev Throws if called by any account other than the owner.
326    */
327   modifier onlyOwner() {
328     require(msg.sender == owner);
329     _;
330   }
331 
332   /**
333    * @dev Allows the current owner to relinquish control of the contract.
334    */
335   function renounceOwnership() public onlyOwner {
336     emit OwnershipRenounced(owner);
337     owner = address(0);
338   }
339 
340   /**
341    * @dev Allows the current owner to transfer control of the contract to a newOwner.
342    * @param _newOwner The address to transfer ownership to.
343    */
344   function transferOwnership(address _newOwner) public onlyOwner {
345     _transferOwnership(_newOwner);
346   }
347 
348   /**
349    * @dev Transfers control of the contract to a newOwner.
350    * @param _newOwner The address to transfer ownership to.
351    */
352   function _transferOwnership(address _newOwner) internal {
353     require(_newOwner != address(0));
354     emit OwnershipTransferred(owner, _newOwner);
355     owner = _newOwner;
356   }
357 }
358 
359 // File: contracts/Authority.sol
360 
361 /**
362  * @title Authority
363  * @dev The Authority contract has an authority address, and provides basic authorization control
364  * functions, this simplifies the implementation of "user permissions".
365  * Authority means to represent a legal entity that is entitled to specific rights
366  *
367  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
368  *
369  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
370  * @notice Please refer to the top of this file for the license.
371  *
372  * Error messages
373  * AU01: Message sender must be an authority
374  */
375 contract Authority is Ownable {
376 
377   address authority;
378 
379   /**
380    * @dev Throws if called by any account other than the authority.
381    */
382   modifier onlyAuthority {
383     require(msg.sender == authority, "AU01");
384     _;
385   }
386 
387   /**
388    * @dev return the address associated to the authority
389    */
390   function authorityAddress() public view returns (address) {
391     return authority;
392   }
393 
394   /**
395    * @dev rdefines an authority
396    * @param _name the authority name
397    * @param _address the authority address.
398    */
399   function defineAuthority(string _name, address _address) public onlyOwner {
400     emit AuthorityDefined(_name, _address);
401     authority = _address;
402   }
403 
404   event AuthorityDefined(
405     string name,
406     address _address
407   );
408 }
409 
410 // File: contracts/tokensale/Tokensale.sol
411 
412 /**
413  * @title Tokensale
414  * @dev Tokensale interface
415  *
416  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
417  *
418  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
419  * @notice Please refer to the top of this file for the license.
420  *
421  * Error messages
422  * TOS01: It must be before the sale is opened
423  * TOS02: Sale must be open
424  * TOS03: It must be before the sale is closed
425  * TOS04: It must be after the sale is closed
426  * TOS05: No data must be sent while sending ETH
427  * TOS06: Share Purchase Agreement Hashes must match
428  * TOS07: User/Investor must exist
429  * TOS08: SPA must be accepted before any ETH investment
430  * TOS09: Cannot update schedule once started
431  * TOS10: Investor must exist
432  * TOS11: Cannot allocate more tokens than available supply
433  * TOS12: Length of investorIds and amounts arguments must match
434  * TOS13: Investor must exist
435  * TOS14: Must refund ETH unspent
436  * TOS15: Must withdraw ETH to vaultETH
437  * TOS16: Cannot invest onchain and offchain at the same time
438  * TOS17: A ETHCHF rate must exist to invest
439  * TOS18: User must be valid
440  * TOS19: Cannot invest if no tokens are available
441  * TOS20: Cannot unspend more CHF than BASE_TOKEN_PRICE_CHF
442  * TOS21: Token transfer must be successful
443  */
444 contract Tokensale is ITokensale, Authority {
445   using SafeMath for uint256;
446 
447   /* General sale details */
448   ERC20 public token;
449   address public vaultETH;
450   address public vaultERC20;
451   IUserRegistry public userRegistry;
452   IRatesProvider public ratesProvider;
453 
454   uint256 public minimalBalance = MINIMAL_BALANCE;
455   bytes32 public sharePurchaseAgreementHash;
456 
457   uint256 public startAt = 4102441200;
458   uint256 public endAt = 4102441200;
459   uint256 public raisedETH;
460   uint256 public raisedCHF;
461   uint256 public totalRaisedCHF;
462   uint256 public refundedETH;
463   uint256 public allocatedTokens;
464 
465   struct Investor {
466     uint256 unspentETH;
467     uint256 investedCHF;
468     bool acceptedSPA;
469     uint256 allocations;
470     uint256 tokens;
471   }
472   mapping(uint256 => Investor) investors;
473   uint256 public investorCount;
474 
475   /**
476    * @dev Throws after sale opening
477    */
478   modifier beforeSaleIsOpened {
479     require(currentTime() < startAt, "TOS01");
480     _;
481   }
482 
483   /**
484    * @dev Throws if sale is not open
485    */
486   modifier saleIsOpened {
487     require(currentTime() >= startAt && currentTime() <= endAt, "TOS02");
488     _;
489   }
490 
491   /**
492    * @dev Throws once the sale is closed
493    */
494   modifier beforeSaleIsClosed {
495     require(currentTime() <= endAt, "TOS03");
496     _;
497   }
498 
499   /**
500    * @dev constructor
501    */
502   constructor(
503     ERC20 _token,
504     IUserRegistry _userRegistry,
505     IRatesProvider _ratesProvider,
506     address _vaultERC20,
507     address _vaultETH
508   ) public
509   {
510     token = _token;
511     userRegistry = _userRegistry;
512     ratesProvider = _ratesProvider;
513     vaultERC20 = _vaultERC20;
514     vaultETH = _vaultETH;
515   }
516 
517   /**
518    * @dev fallback function
519    */
520   function () external payable {
521     require(msg.data.length == 0, "TOS05");
522     investETH();
523   }
524 
525   /**
526    * @dev returns the token sold
527    */
528   function token() public view returns (ERC20) {
529     return token;
530   }
531 
532   /**
533    * @dev returns the vault used to hold ETH
534    */
535   function vaultETH() public view returns (address) {
536     return vaultETH;
537   }
538 
539   /**
540    * @dev returns the vault which holds tokens
541    */
542   function vaultERC20() public view returns (address) {
543     return vaultERC20;
544   }
545 
546   function userRegistry() public view returns (IUserRegistry) {
547     return userRegistry;
548   }
549 
550   function ratesProvider() public view returns (IRatesProvider) {
551     return ratesProvider;
552   }
553 
554   function sharePurchaseAgreementHash() public view returns (bytes32) {
555     return sharePurchaseAgreementHash;
556   }
557 
558   /* Sale status */
559   function startAt() public view returns (uint256) {
560     return startAt;
561   }
562 
563   function endAt() public view returns (uint256) {
564     return endAt;
565   }
566 
567   function raisedETH() public view returns (uint256) {
568     return raisedETH;
569   }
570 
571   function raisedCHF() public view returns (uint256) {
572     return raisedCHF;
573   }
574 
575   function totalRaisedCHF() public view returns (uint256) {
576     return totalRaisedCHF;
577   }
578 
579   function refundedETH() public view returns (uint256) {
580     return refundedETH;
581   }
582 
583   function availableSupply() public view returns (uint256) {
584     uint256 vaultSupply = token.balanceOf(vaultERC20);
585     uint256 allowance = token.allowance(vaultERC20, address(this));
586     return (vaultSupply < allowance) ? vaultSupply : allowance;
587   }
588  
589   /* Investor specific attributes */
590   function investorUnspentETH(uint256 _investorId)
591     public view returns (uint256)
592   {
593     return investors[_investorId].unspentETH;
594   }
595 
596   function investorInvestedCHF(uint256 _investorId)
597     public view returns (uint256)
598   {
599     return investors[_investorId].investedCHF;
600   }
601 
602   function investorAcceptedSPA(uint256 _investorId)
603     public view returns (bool)
604   {
605     return investors[_investorId].acceptedSPA;
606   }
607 
608   function investorAllocations(uint256 _investorId)
609     public view returns (uint256)
610   {
611     return investors[_investorId].allocations;
612   }
613 
614   function investorTokens(uint256 _investorId) public view returns (uint256) {
615     return investors[_investorId].tokens;
616   }
617 
618   function investorCount() public view returns (uint256) {
619     return investorCount;
620   }
621 
622   /**
623    * @dev minimal autowithdraw threshold
624    */
625   function minimalAutoWithdraw() public view returns (uint256) {
626     return MINIMAL_AUTO_WITHDRAW;
627   }
628 
629   /**
630    * @dev minimal balance
631    */
632   function minimalBalance() public view returns (uint256) {
633     return minimalBalance;
634   }
635 
636   /**
637    * @dev token base price in CHF cents
638    */
639   function basePriceCHFCent() public view returns (uint256) {
640     return BASE_PRICE_CHF_CENT;
641   }
642 
643   /**
644    * @dev updateMinimalBalance
645    */
646   function updateMinimalBalance(uint256 _minimalBalance) public returns (uint256) {
647     minimalBalance = _minimalBalance;
648   }
649 
650   /* Share Purchase Agreement */
651   /**
652    * @dev define SPA
653    */
654   function defineSPA(bytes32 _sharePurchaseAgreementHash)
655     public onlyOwner returns (bool)
656   {
657     sharePurchaseAgreementHash = _sharePurchaseAgreementHash;
658     emit SalePurchaseAgreementHash(_sharePurchaseAgreementHash);
659   }
660 
661   /**
662    * @dev Accept SPA and invest if msg.value > 0
663    */
664   function acceptSPA(bytes32 _sharePurchaseAgreementHash)
665     public beforeSaleIsClosed payable returns (bool)
666   {
667     require(
668       _sharePurchaseAgreementHash == sharePurchaseAgreementHash, "TOS06");
669     uint256 investorId = userRegistry.userId(msg.sender);
670     require(investorId > 0, "TOS07");
671     investors[investorId].acceptedSPA = true;
672     investorCount++;
673 
674     if (msg.value > 0) {
675       investETH();
676     }
677   }
678 
679   /* Investment */
680   function investETH() public saleIsOpened payable {
681     //Accepting SharePurchaseAgreement is temporarily offchain
682     //uint256 investorId = userRegistry.userId(msg.sender);
683     //require(investors[investorId].acceptedSPA, "TOS08");
684     investInternal(msg.sender, msg.value, 0);
685     autoWithdrawETHFunds();
686   }
687 
688   /**
689    * @dev add off chain investment
690    */
691   function addOffChainInvestment(address _investor, uint256 _amountCHF)
692     public onlyAuthority
693   {
694     investInternal(_investor, 0, _amountCHF);
695   }
696 
697   /* Schedule */ 
698   /**
699    * @dev update schedule
700    */
701   function updateSchedule(uint256 _startAt, uint256 _endAt)
702     public onlyAuthority beforeSaleIsOpened
703   {
704     require(_startAt < _endAt, "TOS09");
705     startAt = _startAt;
706     endAt = _endAt;
707   }
708 
709   /* Allocations admin */
710   /**
711    * @dev allocate
712    */
713   function allocateTokens(address _investor, uint256 _amount)
714     public onlyAuthority beforeSaleIsClosed returns (bool)
715   {
716     uint256 investorId = userRegistry.userId(_investor);
717     require(investorId > 0, "TOS10");
718     Investor storage investor = investors[investorId];
719     
720     allocatedTokens = allocatedTokens.sub(investor.allocations).add(_amount);
721     require(allocatedTokens <= availableSupply(), "TOS11");
722 
723     investor.allocations = _amount;
724     emit Allocation(investorId, _amount);
725   }
726 
727   /**
728    * @dev allocate many
729    */
730   function allocateManyTokens(address[] _investors, uint256[] _amounts)
731     public onlyAuthority beforeSaleIsClosed returns (bool)
732   {
733     require(_investors.length == _amounts.length, "TOS12");
734     for (uint256 i = 0; i < _investors.length; i++) {
735       allocateTokens(_investors[i], _amounts[i]);
736     }
737   }
738 
739   /* ETH administration */
740   /**
741    * @dev fund ETH
742    */
743   function fundETH() public payable onlyAuthority {
744     emit FundETH(msg.value);
745   }
746 
747   /**
748    * @dev refund unspent ETH many
749    */
750   function refundManyUnspentETH(address[] _receivers) public onlyAuthority {
751     for(uint256 i = 0; i < _receivers.length; i++) {
752       refundUnspentETH(_receivers[i]);
753     }
754   }
755 
756   /**
757    * @dev refund unspent ETH
758    */
759   function refundUnspentETH(address _receiver) public onlyAuthority {
760     uint256 investorId = userRegistry.userId(_receiver);
761     require(investorId != 0, "TOS13");
762     Investor storage investor = investors[investorId];
763 
764     if (investor.unspentETH > 0) {
765       // solium-disable-next-line security/no-send
766       require(_receiver.send(investor.unspentETH), "TOS14");
767       refundedETH = refundedETH.add(investor.unspentETH);
768       emit WithdrawETH(_receiver, investor.unspentETH);
769       investor.unspentETH = 0;
770     }
771   }
772 
773   /**
774    * @dev withdraw ETH funds
775    */
776   function withdrawETHFunds() public onlyAuthority {
777     uint256 balance = address(this).balance;
778     if (balance > minimalBalance) {
779       uint256 amount = balance.sub(minimalBalance);
780       // solium-disable-next-line security/no-send
781       require(vaultETH.send(amount), "TOS15");
782       emit WithdrawETH(vaultETH, amount);
783     }
784   }
785 
786   /**
787    * @dev withdraw all ETH funds
788    */
789   function withdrawAllETHFunds() public onlyAuthority {
790     uint256 balance = address(this).balance;
791     // solium-disable-next-line security/no-send
792     require(vaultETH.send(balance), "TOS15");
793     emit WithdrawETH(vaultETH, balance);
794   }
795 
796   /**
797    * @dev auto withdraw ETH funds
798    */
799   function autoWithdrawETHFunds() private {
800     uint256 balance = address(this).balance;
801     if (balance >= minimalBalance.add(MINIMAL_AUTO_WITHDRAW)) {
802       uint256 amount = balance.sub(minimalBalance);
803       // solium-disable-next-line security/no-send
804       if (vaultETH.send(amount)) {
805         emit WithdrawETH(vaultETH, amount);
806       }
807     }
808   }
809 
810   /**
811    * @dev invest internal
812    */
813   function investInternal(
814     address _investor, uint256 _amountETH, uint256 _amountCHF)
815     private
816   {
817     // investment with _amountETH is decentralized
818     // investment with _amountCHF is centralized
819     // They are mutually exclusive
820     require((_amountETH != 0 && _amountCHF == 0) ||
821       (_amountETH == 0 && _amountCHF != 0), "TOS16");
822 
823     require(ratesProvider.rateWEIPerCHFCent() != 0, "TOS17");
824     uint256 investorId = userRegistry.userId(_investor);
825     require(userRegistry.isValid(investorId), "TOS18");
826 
827     Investor storage investor = investors[investorId];
828 
829     uint256 contributionCHF = ratesProvider.convertWEIToCHFCent(
830       investor.unspentETH);
831 
832     if (_amountETH > 0) {
833       contributionCHF = contributionCHF.add(
834         ratesProvider.convertWEIToCHFCent(_amountETH));
835     }
836     if (_amountCHF > 0) {
837       contributionCHF = contributionCHF.add(_amountCHF);
838     }
839 
840     uint256 tokens = contributionCHF.div(BASE_PRICE_CHF_CENT);
841     uint256 availableTokens = availableSupply().sub(
842       allocatedTokens).add(investor.allocations);
843     require(availableTokens != 0, "TOS19");
844 
845     if (tokens > availableTokens) {
846       tokens = availableTokens;
847     }
848 
849     /** Calculating unspentETH value **/
850     uint256 investedCHF = tokens.mul(BASE_PRICE_CHF_CENT);
851     uint256 unspentContributionCHF = contributionCHF.sub(investedCHF);
852 
853     uint256 unspentETH = 0;
854     if (unspentContributionCHF != 0) {
855       if (_amountCHF > 0) {
856         // Prevent CHF investment LARGER than available supply
857         // from creating a too large and dangerous unspentETH value
858         require(unspentContributionCHF < BASE_PRICE_CHF_CENT, "TOS20");
859       }
860       unspentETH = ratesProvider.convertCHFCentToWEI(
861         unspentContributionCHF);
862     }
863 
864     /** Spent ETH **/
865     uint256 spentETH = 0;
866     if (investor.unspentETH == unspentETH) {
867       spentETH = _amountETH;
868     } else {
869       uint256 unspentETHDiff = (unspentETH > investor.unspentETH)
870         ? unspentETH.sub(investor.unspentETH)
871         : investor.unspentETH.sub(unspentETH);
872 
873       if (_amountCHF > 0) {
874         if (unspentETH < investor.unspentETH) {
875           spentETH = unspentETHDiff;
876         }
877         // if unspentETH > investor.unspentETH
878         // then CHF has been converted into ETH
879         // and no ETH were spent
880       }
881       if (_amountETH > 0) {
882         spentETH = (unspentETH > investor.unspentETH)
883           ? _amountETH.sub(unspentETHDiff)
884           : _amountETH.add(unspentETHDiff);
885       }
886     }
887 
888     investor.unspentETH = unspentETH;
889     investor.investedCHF = investor.investedCHF.add(investedCHF);
890     investor.tokens = investor.tokens.add(tokens);
891     raisedCHF = raisedCHF.add(_amountCHF);
892     raisedETH = raisedETH.add(spentETH);
893     totalRaisedCHF = totalRaisedCHF.add(investedCHF);
894 
895     allocatedTokens = allocatedTokens.sub(investor.allocations);
896     investor.allocations = (investor.allocations > tokens)
897       ? investor.allocations.sub(tokens) : 0;
898     allocatedTokens = allocatedTokens.add(investor.allocations);
899     require(
900       token.transferFrom(vaultERC20, _investor, tokens),
901       "TOS21");
902 
903     if (spentETH > 0) {
904       emit ChangeETHCHF(
905         _investor,
906         spentETH,
907         ratesProvider.convertWEIToCHFCent(spentETH),
908         ratesProvider.rateWEIPerCHFCent());
909     }
910     emit Investment(investorId, investedCHF);
911   }
912 
913   /* Util */
914   /**
915    * @dev current time
916    */
917   function currentTime() private view returns (uint256) {
918     // solium-disable-next-line security/no-block-members
919     return now;
920   }
921 }