1 pragma solidity 0.4.25;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library AddressUtils {
7 
8   /**
9    * Returns whether there is code in the target address
10    * @dev This function will return false if invoked during the constructor of a contract,
11    *  as the code is not actually created until after the constructor finishes.
12    * @param addr address address to check
13    * @return whether there is code in the target address
14    */
15   function isContract(address addr) internal view returns(bool) {
16     uint256 size;
17     assembly {
18       size: = extcodesize(addr)
19     }
20     return size > 0;
21   }
22 
23 }
24 
25 
26 
27 /**
28  * @title SafeCompare
29  */
30 library SafeCompare {
31   function stringCompare(string str1, string str2) internal pure returns(bool) {
32     return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
33   }
34 }
35 
36 
37 
38 
39 library SafeMath {
40 
41   /**
42    * @dev Multiplies two numbers, throws on overflow.
43    */
44   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
45     if (a == 0) {
46       return 0;
47     }
48     uint256 c = a * b;
49     assert(c / a == b);
50     return c;
51   }
52 
53   /**
54    * @dev Integer division of two numbers, truncating the quotient.
55    */
56   function div(uint256 a, uint256 b) internal pure returns(uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   /**
64    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65    */
66   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   /**
72    * @dev Adds two numbers, throws on overflow.
73    */
74   function add(uint256 a, uint256 b) internal pure returns(uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 
82 
83 /**
84  * @title Ownable
85  * @dev The Ownable contract has an owner address, and provides basic authorization control
86  * functions, this simplifies the implementation of "user permissions".
87  */
88 contract Ownable {
89   address public owner;
90 
91 
92   event OwnershipRenounced(address indexed previousOwner);
93   event OwnershipTransferred(
94     address indexed previousOwner,
95     address indexed newOwner
96   );
97 
98 
99   /**
100    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
101    * account.
102    */
103   constructor() public {
104     owner = msg.sender;
105   }
106 
107   /**
108    * @dev Throws if called by any account other than the owner.
109    */
110   modifier onlyOwner() {
111     require(msg.sender == owner);
112     _;
113   }
114 
115   /**
116    * @dev Allows the current owner to relinquish control of the contract.
117    * @notice Renouncing to ownership will leave the contract without an owner.
118    * It will not be possible to call the functions with the `onlyOwner`
119    * modifier anymore.
120    */
121   function renounceOwnership() public onlyOwner {
122     emit OwnershipRenounced(owner);
123     owner = address(0);
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param _newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address _newOwner) public onlyOwner {
131     _transferOwnership(_newOwner);
132   }
133 
134   /**
135    * @dev Transfers control of the contract to a newOwner.
136    * @param _newOwner The address to transfer ownership to.
137    */
138   function _transferOwnership(address _newOwner) internal {
139     require(_newOwner != address(0));
140     emit OwnershipTransferred(owner, _newOwner);
141     owner = _newOwner;
142   }
143 }
144 
145 /**
146  * @title ERC20Basic
147  * @dev Simpler version of ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract UsdtERC20Basic {
151     uint public _totalSupply;
152     function totalSupply() public constant returns (uint);
153     function balanceOf(address who) public constant returns (uint);
154     function transfer(address to, uint value) public;
155     event Transfer(address indexed from, address indexed to, uint value);
156 }
157 
158 
159 
160 /**
161  * @title ERC20Basic
162  * @dev Simpler version of ERC20 interface
163  * @dev see https://github.com/ethereum/EIPs/issues/179
164  */
165 contract ERC20Basic {
166   function totalSupply() public view returns(uint256);
167 
168   function balanceOf(address who) public view returns(uint256);
169 
170   function transfer(address to, uint256 value) public returns(bool);
171   event Transfer(address indexed from, address indexed to, uint256 value);
172 }
173 
174 
175 
176 /**
177  * @title Roles
178  * @author Francisco Giordano (@frangio)
179  * @dev Library for managing addresses assigned to a Role.
180  * See RBAC.sol for example usage.
181  */
182 library Roles {
183   struct Role {
184     mapping(address => bool) bearer;
185   }
186 
187   /**
188    * @dev give an address access to this role
189    */
190   function add(Role storage _role, address _addr)
191   internal {
192     _role.bearer[_addr] = true;
193   }
194 
195   /**
196    * @dev remove an address' access to this role
197    */
198   function remove(Role storage _role, address _addr)
199   internal {
200     _role.bearer[_addr] = false;
201   }
202 
203   /**
204    * @dev check if an address has this role
205    * // reverts
206    */
207   function check(Role storage _role, address _addr)
208   internal
209   view {
210     require(has(_role, _addr));
211   }
212 
213   /**
214    * @dev check if an address has this role
215    * @return bool
216    */
217   function has(Role storage _role, address _addr)
218   internal
219   view
220   returns(bool) {
221     return _role.bearer[_addr];
222   }
223 }
224 
225 
226 
227 
228 
229 /**
230  * @title RBAC (Role-Based Access Control)
231  * @author Matt Condon (@Shrugs)
232  * @dev Stores and provides setters and getters for roles and addresses.
233  * Supports unlimited numbers of roles and addresses.
234  * See //contracts/mocks/RBACMock.sol for an example of usage.
235  * This RBAC method uses strings to key roles. It may be beneficial
236  * for you to write your own implementation of this interface using Enums or similar.
237  */
238 contract RBAC {
239   using Roles
240   for Roles.Role;
241 
242   mapping(string => Roles.Role) private roles;
243 
244   event RoleAdded(address indexed operator, string role);
245   event RoleRemoved(address indexed operator, string role);
246 
247   /**
248    * @dev reverts if addr does not have role
249    * @param _operator address
250    * @param _role the name of the role
251    * // reverts
252    */
253   function checkRole(address _operator, string _role)
254   public
255   view {
256     roles[_role].check(_operator);
257   }
258 
259   /**
260    * @dev determine if addr has role
261    * @param _operator address
262    * @param _role the name of the role
263    * @return bool
264    */
265   function hasRole(address _operator, string _role)
266   public
267   view
268   returns(bool) {
269     return roles[_role].has(_operator);
270   }
271 
272   /**
273    * @dev add a role to an address
274    * @param _operator address
275    * @param _role the name of the role
276    */
277   function addRole(address _operator, string _role)
278   internal {
279     roles[_role].add(_operator);
280     emit RoleAdded(_operator, _role);
281   }
282 
283   /**
284    * @dev remove a role from an address
285    * @param _operator address
286    * @param _role the name of the role
287    */
288   function removeRole(address _operator, string _role)
289   internal {
290     roles[_role].remove(_operator);
291     emit RoleRemoved(_operator, _role);
292   }
293 
294   /**
295    * @dev modifier to scope access to a single role (uses msg.sender as addr)
296    * @param _role the name of the role
297    * // reverts
298    */
299   modifier onlyRole(string _role) {
300     checkRole(msg.sender, _role);
301     _;
302   }
303 
304 }
305 
306 
307 
308 
309 
310 
311 
312 
313 contract RBACOperator is Ownable, RBAC {
314 
315   /**
316    * A constant role name for indicating operator.
317    */
318   string public constant ROLE_OPERATOR = "operator";
319 
320   address public partner;
321   /**
322    * Event for setPartner logging
323    * @param oldPartner the old  Partner
324    * @param newPartner the new  Partner
325    */
326   event SetPartner(address oldPartner, address newPartner);
327 
328   /**
329    * @dev Throws if called by any account other than the owner or the Partner.
330    */
331   modifier onlyOwnerOrPartner() {
332     require(msg.sender == owner || msg.sender == partner);
333     _;
334   }
335 
336   /**
337    * @dev Throws if called by any account other than the Partner.
338    */
339   modifier onlyPartner() {
340     require(msg.sender == partner);
341     _;
342   }
343 
344 
345   /**
346    * @dev setPartner, set the  partner address.
347    * @param _partner the new  partner address.
348    */
349   function setPartner(address _partner) public onlyOwner {
350     require(_partner != address(0));
351     emit SetPartner(partner, _partner);
352     partner = _partner;
353   }
354 
355 
356   /**
357    * @dev removePartner, remove  partner address.
358    */
359   function removePartner() public onlyOwner {
360     delete partner;
361   }
362 
363   /**
364    * @dev the modifier to operate
365    */
366   modifier hasOperationPermission() {
367     checkRole(msg.sender, ROLE_OPERATOR);
368     _;
369   }
370 
371 
372 
373   /**
374    * @dev add a operator role to an address
375    * @param _operator address
376    */
377   function addOperater(address _operator) public onlyOwnerOrPartner {
378     addRole(_operator, ROLE_OPERATOR);
379   }
380 
381   /**
382    * @dev remove a operator role from an address
383    * @param _operator address
384    */
385   function removeOperater(address _operator) public onlyOwnerOrPartner {
386     removeRole(_operator, ROLE_OPERATOR);
387   }
388 }
389 
390 
391 
392 
393 
394 
395 
396 
397 
398 /**
399  * @title ERC20 interface
400  * @dev see https://github.com/ethereum/EIPs/issues/20
401  */
402 contract ERC20 is ERC20Basic {
403   function allowance(address owner, address spender) public view returns(uint256);
404 
405   function transferFrom(address from, address to, uint256 value) public returns(bool);
406 
407   function approve(address spender, uint256 value) public returns(bool);
408   event Approval(address indexed owner, address indexed spender, uint256 value);
409 }
410 
411 
412 
413 /**
414  * @title ERC20 interface
415  * @dev see https://github.com/ethereum/EIPs/issues/20
416  */
417 contract UsdtERC20 is UsdtERC20Basic {
418     function allowance(address owner, address spender) public constant returns (uint);
419     function transferFrom(address from, address to, uint value) public;
420     function approve(address spender, uint value) public;
421     event Approval(address indexed owner, address indexed spender, uint value);
422 }
423 
424 
425 
426 
427 
428 contract PartnerAuthority is Ownable {
429 
430 
431   address public partner;
432   /**
433    * Event for setPartner logging
434    * @param oldPartner the old  Partner
435    * @param newPartner the new  Partner
436    */
437   event SetPartner(address oldPartner, address newPartner);
438 
439   /**
440    * @dev Throws if called by any account other than the owner or the Partner.
441    */
442   modifier onlyOwnerOrPartner() {
443     require(msg.sender == owner || msg.sender == partner);
444     _;
445   }
446 
447   /**
448    * @dev Throws if called by any account other than the Partner.
449    */
450   modifier onlyPartner() {
451     require(msg.sender == partner);
452     _;
453   }
454 
455 
456   /**
457    * @dev setPartner, set the  partner address.
458    */
459   function setPartner(address _partner) public onlyOwner {
460     require(_partner != address(0));
461     emit SetPartner(partner, _partner);
462     partner = _partner;
463   }
464 
465 
466 
467   /**
468    * @dev removePartner, remove  partner address.
469    */
470   function removePartner() public onlyOwner {
471     delete partner;
472   }
473 
474 
475 }
476 
477 
478 
479 
480 
481 
482 
483 
484 
485 /**
486  * @title OrderManageContract
487  * @dev Order process management contract.
488  */
489 contract OrderManageContract is PartnerAuthority {
490   using SafeMath for uint256;
491   using SafeCompare for string;
492 
493   /**
494    * @dev Status of current business execution contract.
495    */
496   enum StatusChoices {
497     NO_LOAN,
498     REPAYMENT_WAITING,
499     REPAYMENT_ALL,
500     CLOSE_POSITION,
501     OVERDUE_STOP
502   }
503 
504   string internal constant TOKEN_ETH = "ETH";
505   string internal constant TOKEN_USDT = "USDT";
506   address public maker;
507   address public taker;
508   address internal token20;
509 
510   uint256 public toTime;
511   // the amount of the borrower’s final loan.
512   uint256 public outLoanSum;
513   uint256 public repaymentSum;
514   uint256 public lastRepaymentSum;
515   string public loanTokenName;
516   // Borrower's record of the pledge.
517   StatusChoices internal status;
518 
519   // Record the amount of the borrower's offline transfer.
520   mapping(address => uint256) public ethAmount;
521 
522   /**
523    * Event for takerOrder logging.
524    * @param taker address of investor.
525    * @param outLoanSum the amount of the borrower’s final loan.
526    */
527   event TakerOrder(address indexed taker, uint256 outLoanSum);
528 
529 
530   /**
531    * Event for executeOrder logging.
532    * @param maker address of borrower.
533    * @param lastRepaymentSum current order repayment amount.
534    */
535   event ExecuteOrder(address indexed maker, uint256 lastRepaymentSum);
536 
537   /**
538    * Event for forceCloseOrder logging.
539    * @param toTime order repayment due date.
540    * @param transferSum balance under current contract.
541    */
542   event ForceCloseOrder(uint256 indexed toTime, uint256 transferSum);
543 
544   /**
545    * Event for WithdrawToken logging.
546    * @param taker address of investor.
547    * @param refundSum number of tokens withdrawn.
548    */
549   event WithdrawToken(address indexed taker, uint256 refundSum);
550 
551 
552 
553   function() external payable {
554     // Record basic information about the borrower's REPAYMENT ETH
555     ethAmount[msg.sender] = ethAmount[msg.sender].add(msg.value);
556   }
557 
558 
559   /**
560    * @dev Constructor initial contract configuration parameters
561    * @param _loanTokenAddress order type supported by the token.
562    */
563   constructor(string _loanTokenName, address _loanTokenAddress, address _maker) public {
564     require(bytes(_loanTokenName).length > 0 && _maker != address(0));
565     if (!_loanTokenName.stringCompare(TOKEN_ETH)) {
566       require(_loanTokenAddress != address(0));
567       token20 = _loanTokenAddress;
568     }
569     toTime = now;
570     maker = _maker;
571     loanTokenName = _loanTokenName;
572     status = StatusChoices.NO_LOAN;
573   }
574 
575   /**
576    * @dev Complete an order combination and issue the loan to the borrower.
577    * @param _taker address of investor.
578    * @param _toTime order repayment due date.
579    * @param _repaymentSum total amount of money that the borrower ultimately needs to return.
580    */
581   function takerOrder(address _taker, uint32 _toTime, uint256 _repaymentSum) public onlyOwnerOrPartner {
582     require(_taker != address(0) && _toTime > 0 && now <= _toTime && _repaymentSum > 0 && status == StatusChoices.NO_LOAN);
583     taker = _taker;
584     toTime = _toTime;
585     repaymentSum = _repaymentSum;
586 
587     // Transfer the token provided by the investor to the borrower's address
588     if (loanTokenName.stringCompare(TOKEN_ETH)) {
589       require(ethAmount[_taker] > 0 && address(this).balance > 0);
590       outLoanSum = address(this).balance;
591       maker.transfer(outLoanSum);
592     } else {
593       require(token20 != address(0) && ERC20(token20).balanceOf(address(this)) > 0);
594       outLoanSum = ERC20(token20).balanceOf(address(this));
595       require(safeErc20Transfer(maker, outLoanSum));
596     }
597 
598     // Update contract business execution status.
599     status = StatusChoices.REPAYMENT_WAITING;
600 
601     emit TakerOrder(taker, outLoanSum);
602   }
603 
604 
605 
606 
607 
608 
609   /**
610    * @dev Only the full repayment will execute the contract agreement.
611    */
612   function executeOrder() public onlyOwnerOrPartner {
613     require(now <= toTime && status == StatusChoices.REPAYMENT_WAITING);
614     // The borrower pays off the loan and performs two-way operation.
615     if (loanTokenName.stringCompare(TOKEN_ETH)) {
616       require(ethAmount[maker] >= repaymentSum && address(this).balance >= repaymentSum);
617       lastRepaymentSum = address(this).balance;
618       taker.transfer(repaymentSum);
619     } else {
620       require(ERC20(token20).balanceOf(address(this)) >= repaymentSum);
621       lastRepaymentSum = ERC20(token20).balanceOf(address(this));
622       require(safeErc20Transfer(taker, repaymentSum));
623     }
624 
625     PledgeContract(owner)._conclude();
626     status = StatusChoices.REPAYMENT_ALL;
627     emit ExecuteOrder(maker, lastRepaymentSum);
628   }
629 
630 
631 
632   /**
633    * @dev Close position or due repayment operation.
634    */
635   function forceCloseOrder() public onlyOwnerOrPartner {
636     require(status == StatusChoices.REPAYMENT_WAITING);
637     uint256 transferSum = 0;
638 
639     if (now <= toTime) {
640       status = StatusChoices.CLOSE_POSITION;
641     } else {
642       status = StatusChoices.OVERDUE_STOP;
643     }
644 
645     if(loanTokenName.stringCompare(TOKEN_ETH)){
646         if(ethAmount[maker] > 0 && address(this).balance > 0){
647             transferSum = address(this).balance;
648             maker.transfer(transferSum);
649         }
650     }else{
651         if(ERC20(token20).balanceOf(address(this)) > 0){
652             transferSum = ERC20(token20).balanceOf(address(this));
653             require(safeErc20Transfer(maker, transferSum));
654         }
655     }
656 
657     // Return pledge token.
658     PledgeContract(owner)._forceConclude(taker);
659     emit ForceCloseOrder(toTime, transferSum);
660   }
661 
662 
663 
664   /**
665    * @dev Withdrawal of the token invested by the taker.
666    * @param _taker address of investor.
667    * @param _refundSum refundSum number of tokens withdrawn.
668    */
669   function withdrawToken(address _taker, uint256 _refundSum) public onlyOwnerOrPartner {
670     require(status == StatusChoices.NO_LOAN);
671     require(_taker != address(0) && _refundSum > 0);
672     if (loanTokenName.stringCompare(TOKEN_ETH)) {
673       require(address(this).balance >= _refundSum && ethAmount[_taker] >= _refundSum);
674       _taker.transfer(_refundSum);
675       ethAmount[_taker] = ethAmount[_taker].sub(_refundSum);
676     } else {
677       require(ERC20(token20).balanceOf(address(this)) >= _refundSum);
678       require(safeErc20Transfer(_taker, _refundSum));
679     }
680     emit WithdrawToken(_taker, _refundSum);
681   }
682 
683 
684   /**
685    * @dev Since the implementation of usdt ERC20.sol transfer code does not design the return value,
686    * @dev which is different from most ERC20 token interfaces,most erc20 transfer token agreements return bool.
687    * @dev it is necessary to independently adapt the interface for usdt token in order to transfer successfully
688    * @dev if not, the transfer may fail.
689    */
690   function safeErc20Transfer(address _toAddress,uint256 _transferSum) internal returns (bool) {
691     if(loanTokenName.stringCompare(TOKEN_USDT)){
692       UsdtERC20(token20).transfer(_toAddress, _transferSum);
693     }else{
694       require(ERC20(token20).transfer(_toAddress, _transferSum));
695     }
696     return true;
697   }
698 
699 
700 
701   /**
702    * @dev Get current contract order status.
703    */
704   function getPledgeStatus() public view returns(string pledgeStatus) {
705     if (status == StatusChoices.NO_LOAN) {
706       pledgeStatus = "NO_LOAN";
707     } else if (status == StatusChoices.REPAYMENT_WAITING) {
708       pledgeStatus = "REPAYMENT_WAITING";
709     } else if (status == StatusChoices.REPAYMENT_ALL) {
710       pledgeStatus = "REPAYMENT_ALL";
711     } else if (status == StatusChoices.CLOSE_POSITION) {
712       pledgeStatus = "CLOSE_POSITION";
713     } else {
714       pledgeStatus = "OVERDUE_STOP";
715     }
716   }
717 
718 }
719 
720 
721 
722 
723 
724 
725 
726 
727 /**
728  * @title PledgeFactory
729  * @dev Pledge factory contract.
730  * @dev Specially provides the pledge guarantee creation and the statistics function.
731  */
732 contract PledgeFactory is RBACOperator {
733   using AddressUtils for address;
734 
735   // initial type of pledge contract.
736   string internal constant INIT_TOKEN_NAME = "UNKNOWN";
737 
738   mapping(uint256 => EscrowPledge) internal pledgeEscrowById;
739   // pledge number unique screening.
740   mapping(uint256 => bool) internal isPledgeId;
741 
742   /**
743    * @dev Pledge guarantee statistics.
744    */
745   struct EscrowPledge {
746     address pledgeContract;
747     string tokenName;
748   }
749 
750   /**
751    * Event for createOrderContract logging.
752    * @param pledgeId management contract id.
753    * @param newPledgeAddress pledge management contract address.
754    */
755   event CreatePledgeContract(uint256 indexed pledgeId, address newPledgeAddress);
756 
757 
758   /**
759    * @dev Create a pledge subcontract
760    * @param _pledgeId index number of the pledge contract.
761    */
762   function createPledgeContract(uint256 _pledgeId, address _escrowPartner) public onlyPartner returns(bool) {
763     require(_pledgeId > 0 && !isPledgeId[_pledgeId] && _escrowPartner!=address(0));
764 
765     // Give the pledge contract the right to update statistics.
766     PledgeContract pledgeAddress = new PledgeContract(_pledgeId, address(this),partner);
767     pledgeAddress.transferOwnership(_escrowPartner);
768     addOperater(address(pledgeAddress));
769 
770     // update pledge contract info
771     isPledgeId[_pledgeId] = true;
772     pledgeEscrowById[_pledgeId] = EscrowPledge(pledgeAddress, INIT_TOKEN_NAME);
773 
774     emit CreatePledgeContract(_pledgeId, address(pledgeAddress));
775     return true;
776   }
777 
778 
779 
780   /**
781    * @dev Batch create a pledge subcontract
782    * @param _pledgeIds index number of the pledge contract.
783    */
784   function batchCreatePledgeContract(uint256[] _pledgeIds, address _escrowPartner) public onlyPartner {
785     require(_pledgeIds.length > 0 && _escrowPartner.isContract());
786     for (uint i = 0; i < _pledgeIds.length; i++) {
787       require(createPledgeContract(_pledgeIds[i],_escrowPartner));
788     }
789   }
790 
791   /**
792    * @dev Use the index to get the basic information of the corresponding pledge contract.
793    * @param _pledgeId index number of the pledge contract
794    */
795   function getEscrowPledge(uint256 _pledgeId) public view returns(string tokenName, address pledgeContract) {
796     require(_pledgeId > 0);
797     tokenName = pledgeEscrowById[_pledgeId].tokenName;
798     pledgeContract = pledgeEscrowById[_pledgeId].pledgeContract;
799   }
800 
801 
802 
803 
804   // -----------------------------------------
805   // Internal interface (Only the pledge contract has authority to operate)
806   // -----------------------------------------
807 
808 
809   /**
810    * @dev Configure permissions to operate on the token pool.
811    * @param _tokenPool token pool contract address.
812    * @param _pledge pledge contract address.
813    */
814   function tokenPoolOperater(address _tokenPool, address _pledge) public hasOperationPermission {
815     require(_pledge != address(0) && address(msg.sender).isContract() && address(msg.sender) == _pledge);
816     PledgePoolBase(_tokenPool).addOperater(_pledge);
817   }
818 
819 
820   /**
821    * @dev Update the basic data of the pledge contract.
822    * @param _pledgeId index number of the pledge contract.
823    * @param _tokenName pledge contract supported token type.
824    */
825   function updatePledgeType(uint256 _pledgeId, string _tokenName) public hasOperationPermission {
826     require(_pledgeId > 0 && bytes(_tokenName).length > 0 && address(msg.sender).isContract());
827     pledgeEscrowById[_pledgeId].tokenName = _tokenName;
828   }
829 
830 
831 }
832 
833 
834 
835 
836 /**
837  * @title EscrowMaintainContract
838  * @dev Provides configuration and external interfaces.
839  */
840 contract EscrowMaintainContract is PartnerAuthority {
841   address public pledgeFactory;
842 
843   // map of token name to token pool address;
844   mapping(string => address) internal nameByPool;
845   // map of token name to erc20 token address;
846   mapping(string => address) internal nameByToken;
847 
848 
849 
850   // -----------------------------------------
851   // External interface
852   // -----------------------------------------
853 
854   /**
855    * @dev Create a pledge subcontract
856    * @param _pledgeId index number of the pledge contract.
857    */
858   function createPledgeContract(uint256 _pledgeId) public onlyPartner returns(bool) {
859     require(_pledgeId > 0 && pledgeFactory!=address(0));
860     require(PledgeFactory(pledgeFactory).createPledgeContract(_pledgeId,partner));
861     return true;
862   }
863 
864 
865   /**
866    * @dev Batch create a pledge subcontract
867    * @param _pledgeIds index number of the pledge contract.
868    */
869   function batchCreatePledgeContract(uint256[] _pledgeIds) public onlyPartner {
870     require(_pledgeIds.length > 0);
871     PledgeFactory(pledgeFactory).batchCreatePledgeContract(_pledgeIds,partner);
872   }
873 
874 
875   /**
876    * @dev Use the index to get the basic information of the corresponding pledge contract.
877    * @param _pledgeId index number of the pledge contract
878    */
879   function getEscrowPledge(uint256 _pledgeId) public view returns(string tokenName, address pledgeContract) {
880     require(_pledgeId > 0);
881     (tokenName,pledgeContract) = PledgeFactory(pledgeFactory).getEscrowPledge(_pledgeId);
882   }
883 
884 
885   /**
886    * @dev setTokenPool, set the token pool contract address of a token name.
887    * @param _tokenName set token pool name.
888    * @param _address the token pool contract address.
889    */
890   function setTokenPool(string _tokenName, address _address) public onlyOwner {
891     require(_address != address(0) && bytes(_tokenName).length > 0);
892     nameByPool[_tokenName] = _address;
893   }
894 
895    /**
896    * @dev setToken, set the token contract address of a token name.
897    * @param _tokenName token name
898    * @param _address the ERC20 token contract address.
899    */
900   function setToken(string _tokenName, address _address) public onlyOwner {
901     require(_address != address(0) && bytes(_tokenName).length > 0);
902     nameByToken[_tokenName] = _address;
903   }
904 
905 
906   /**
907   * @dev setPledgeFactory, Plant contract for configuration management pledge business.
908   * @param _factory pledge factory contract.
909   */
910   function setPledgeFactory(address _factory) public onlyOwner {
911     require(_factory != address(0));
912     pledgeFactory = _factory;
913   }
914 
915   /**
916    * @dev Checks whether the current token pool is supported.
917    * @param _tokenName token name
918    */
919   function includeTokenPool(string _tokenName) view public returns(address) {
920     require(bytes(_tokenName).length > 0);
921     return nameByPool[_tokenName];
922   }
923 
924 
925   /**
926    * @dev Checks whether the current erc20 token is supported.
927    * @param _tokenName token name
928    */
929   function includeToken(string _tokenName) view public returns(address) {
930     require(bytes(_tokenName).length > 0);
931     return nameByToken[_tokenName];
932   }
933 
934 }
935 
936 
937 /**
938  * @title PledgeContract
939  * @dev Pledge process management contract
940  */
941 contract PledgeContract is PartnerAuthority {
942 
943   using SafeMath for uint256;
944   using SafeCompare for string;
945 
946   /**
947    * @dev Type of execution state of the pledge contract（irreversible）
948    */
949   enum StatusChoices {
950     NO_PLEDGE_INFO,
951     PLEDGE_CREATE_MATCHING,
952     PLEDGE_REFUND
953   }
954 
955   string public pledgeTokenName;
956   uint256 public pledgeId;
957   address internal maker;
958   address internal token20;
959   address internal factory;
960   address internal escrowContract;
961   uint256 internal pledgeAccountSum;
962   // order contract address
963   address internal orderContract;
964   string internal loanTokenName;
965   StatusChoices internal status;
966   address internal tokenPoolAddress;
967   string internal constant TOKEN_ETH = "ETH";
968   string internal constant TOKEN_USDT = "USDT";
969   // ETH pledge account
970   mapping(address => uint256) internal verifyEthAccount;
971 
972 
973   /**
974    * Event for createOrderContract logging.
975    * @param newOrderContract management contract address.
976    */
977   event CreateOrderContract(address newOrderContract);
978 
979 
980   /**
981    * Event for WithdrawToken logging.
982    * @param maker address of investor.
983    * @param pledgeTokenName token name.
984    * @param refundSum number of tokens withdrawn.
985    */
986   event WithdrawToken(address indexed maker, string pledgeTokenName, uint256 refundSum);
987 
988 
989   /**
990    * Event for appendEscrow logging.
991    * @param maker address of borrower.
992    * @param appendSum append amount.
993    */
994   event AppendEscrow(address indexed maker, uint256 appendSum);
995 
996 
997   /**
998    * @dev Constructor initial contract configuration parameters
999    */
1000   constructor(uint256 _pledgeId, address _factory , address _escrowContract) public {
1001     require(_pledgeId > 0 && _factory != address(0) && _escrowContract != address(0));
1002     pledgeId = _pledgeId;
1003     factory = _factory;
1004     status = StatusChoices.NO_PLEDGE_INFO;
1005     escrowContract = _escrowContract;
1006   }
1007 
1008 
1009 
1010   // -----------------------------------------
1011   // external interface
1012   // -----------------------------------------
1013 
1014 
1015 
1016   function() external payable {
1017     require(status != StatusChoices.PLEDGE_REFUND);
1018     // Identify the borrower.
1019     if (maker != address(0)) {
1020       require(address(msg.sender) == maker);
1021     }
1022     // Record basic information about the borrower's pledge ETH
1023     verifyEthAccount[msg.sender] = verifyEthAccount[msg.sender].add(msg.value);
1024   }
1025 
1026 
1027   /**
1028    * @dev Add the pledge information and transfer the pledged token into the corresponding currency pool.
1029    * @param _pledgeTokenName maker pledge token name.
1030    * @param _maker borrower address.
1031    * @param _pledgeSum pledge amount.
1032    * @param _loanTokenName pledge token type.
1033    */
1034   function addRecord(string _pledgeTokenName, address _maker, uint256 _pledgeSum, string _loanTokenName) public onlyOwner {
1035     require(_maker != address(0) && _pledgeSum > 0 && status != StatusChoices.PLEDGE_REFUND);
1036     // Add the pledge information for the first time.
1037     if (status == StatusChoices.NO_PLEDGE_INFO) {
1038       // public data init.
1039       maker = _maker;
1040       pledgeTokenName = _pledgeTokenName;
1041       tokenPoolAddress = checkedTokenPool(pledgeTokenName);
1042       PledgeFactory(factory).updatePledgeType(pledgeId, pledgeTokenName);
1043       // Assign rights to the operation of the contract pool
1044       PledgeFactory(factory).tokenPoolOperater(tokenPoolAddress, address(this));
1045       // Create order management contracts.
1046       createOrderContract(_loanTokenName);
1047     }
1048     // Record information of each pledge.
1049     pledgeAccountSum = pledgeAccountSum.add(_pledgeSum);
1050     PledgePoolBase(tokenPoolAddress).addRecord(maker, pledgeAccountSum, pledgeId, pledgeTokenName);
1051     // Transfer the pledge token to the appropriate token pool.
1052     if (pledgeTokenName.stringCompare(TOKEN_ETH)) {
1053       require(verifyEthAccount[maker] >= _pledgeSum);
1054       tokenPoolAddress.transfer(_pledgeSum);
1055     } else {
1056       token20 = checkedToken(pledgeTokenName);
1057       require(ERC20(token20).balanceOf(address(this)) >= _pledgeSum);
1058       require(safeErc20Transfer(token20,tokenPoolAddress, _pledgeSum));
1059     }
1060   }
1061 
1062   /**
1063    * @dev Increase the number of pledged tokens.
1064    * @param _appendSum append amount.
1065    */
1066   function appendEscrow(uint256 _appendSum) public onlyOwner {
1067     require(status == StatusChoices.PLEDGE_CREATE_MATCHING);
1068     addRecord(pledgeTokenName, maker, _appendSum, loanTokenName);
1069     emit AppendEscrow(maker, _appendSum);
1070   }
1071 
1072 
1073   /**
1074    * @dev Withdraw pledge behavior.
1075    * @param _maker borrower address.
1076    */
1077   function withdrawToken(address _maker) public onlyOwner {
1078     require(status != StatusChoices.PLEDGE_REFUND);
1079     uint256 pledgeSum = 0;
1080     // there are two types of retractions.
1081     if (status == StatusChoices.NO_PLEDGE_INFO) {
1082       pledgeSum = classifySquareUp(_maker);
1083     } else {
1084       status = StatusChoices.PLEDGE_REFUND;
1085       require(PledgePoolBase(tokenPoolAddress).withdrawToken(pledgeId, maker, pledgeAccountSum));
1086       pledgeSum = pledgeAccountSum;
1087     }
1088     emit WithdrawToken(_maker, pledgeTokenName, pledgeSum);
1089   }
1090 
1091 
1092   /**
1093    * @dev Executed in some extreme unforsee cases, to avoid eth locked.
1094    * @param _tokenName recycle token type.
1095    * @param _amount Number of eth to recycle.
1096    */
1097   function recycle(string _tokenName, uint256 _amount) public onlyOwner {
1098     require(status != StatusChoices.NO_PLEDGE_INFO && _amount>0);
1099     if (_tokenName.stringCompare(TOKEN_ETH)) {
1100       require(address(this).balance >= _amount);
1101       owner.transfer(_amount);
1102     } else {
1103       address token = checkedToken(_tokenName);
1104       require(ERC20(token).balanceOf(address(this)) >= _amount);
1105       require(safeErc20Transfer(token,owner, _amount));
1106     }
1107   }
1108 
1109 
1110 
1111   /**
1112    * @dev Since the implementation of usdt ERC20.sol transfer code does not design the return value,
1113    * @dev which is different from most ERC20 token interfaces,most erc20 transfer token agreements return bool.
1114    * @dev it is necessary to independently adapt the interface for usdt token in order to transfer successfully
1115    * @dev if not, the transfer may fail.
1116    */
1117   function safeErc20Transfer(address _token20,address _toAddress,uint256 _transferSum) internal returns (bool) {
1118     if(loanTokenName.stringCompare(TOKEN_USDT)){
1119       UsdtERC20(_token20).transfer(_toAddress, _transferSum);
1120     }else{
1121       require(ERC20(_token20).transfer(_toAddress, _transferSum));
1122     }
1123     return true;
1124   }
1125 
1126 
1127 
1128   // -----------------------------------------
1129   // internal interface
1130   // -----------------------------------------
1131 
1132 
1133 
1134   /**
1135    * @dev Create an order process management contract for the match and repayment business.
1136    * @param _loanTokenName expect loan token type.
1137    */
1138   function createOrderContract(string _loanTokenName) internal {
1139     require(bytes(_loanTokenName).length > 0);
1140     status = StatusChoices.PLEDGE_CREATE_MATCHING;
1141     address loanToken20 = checkedToken(_loanTokenName);
1142     OrderManageContract newOrder = new OrderManageContract(_loanTokenName, loanToken20, maker);
1143     setPartner(address(newOrder));
1144     newOrder.setPartner(owner);
1145     // update contract public data.
1146     orderContract = newOrder;
1147     loanTokenName = _loanTokenName;
1148     emit CreateOrderContract(address(newOrder));
1149   }
1150 
1151   /**
1152    * @dev classification withdraw.
1153    * @dev Execute without changing the current contract data state.
1154    * @param _maker borrower address.
1155    */
1156   function classifySquareUp(address _maker) internal returns(uint256 sum) {
1157     if (pledgeTokenName.stringCompare(TOKEN_ETH)) {
1158       uint256 pledgeSum = verifyEthAccount[_maker];
1159       require(pledgeSum > 0 && address(this).balance >= pledgeSum);
1160       _maker.transfer(pledgeSum);
1161       verifyEthAccount[_maker] = 0;
1162       sum = pledgeSum;
1163     } else {
1164       uint256 balance = ERC20(token20).balanceOf(address(this));
1165       require(balance > 0);
1166       require(safeErc20Transfer(token20,_maker, balance));
1167       sum = balance;
1168     }
1169   }
1170 
1171   /**
1172    * @dev Check wether the token is included for a token name.
1173    * @param _tokenName token name.
1174    */
1175   function checkedToken(string _tokenName) internal view returns(address) {
1176     address tokenAddress = EscrowMaintainContract(escrowContract).includeToken(_tokenName);
1177     require(tokenAddress != address(0));
1178     return tokenAddress;
1179   }
1180 
1181   /**
1182    * @dev Check wether the token pool is included for a token name.
1183    * @param _tokenName pledge token name.
1184    */
1185   function checkedTokenPool(string _tokenName) internal view returns(address) {
1186     address tokenPool = EscrowMaintainContract(escrowContract).includeTokenPool(_tokenName);
1187     require(tokenPool != address(0));
1188     return tokenPool;
1189   }
1190 
1191 
1192 
1193   // -----------------------------------------
1194   // business relationship interface
1195   // (Only the order contract has authority to operate)
1196   // -----------------------------------------
1197 
1198 
1199 
1200   /**
1201    * @dev Refund of the borrower’s pledge.
1202    */
1203   function _conclude() public onlyPartner {
1204     require(status == StatusChoices.PLEDGE_CREATE_MATCHING);
1205     status = StatusChoices.PLEDGE_REFUND;
1206     require(PledgePoolBase(tokenPoolAddress).refundTokens(pledgeId, pledgeAccountSum, maker));
1207   }
1208 
1209   /**
1210    * @dev Expired for repayment or close position.
1211    * @param _taker address of investor.
1212    */
1213   function _forceConclude(address _taker) public onlyPartner {
1214     require(_taker != address(0) && status == StatusChoices.PLEDGE_CREATE_MATCHING);
1215     status = StatusChoices.PLEDGE_REFUND;
1216     require(PledgePoolBase(tokenPoolAddress).refundTokens(pledgeId, pledgeAccountSum, _taker));
1217   }
1218 
1219 
1220 
1221   // -----------------------------------------
1222   // query interface (use no gas)
1223   // -----------------------------------------
1224 
1225 
1226 
1227   /**
1228    * @dev Get current contract order status.
1229    * @return pledgeStatus state indicate.
1230    */
1231   function getPledgeStatus() public view returns(string pledgeStatus) {
1232     if (status == StatusChoices.NO_PLEDGE_INFO) {
1233       pledgeStatus = "NO_PLEDGE_INFO";
1234     } else if (status == StatusChoices.PLEDGE_CREATE_MATCHING) {
1235       pledgeStatus = "PLEDGE_CREATE_MATCHING";
1236     } else {
1237       pledgeStatus = "PLEDGE_REFUND";
1238     }
1239   }
1240 
1241   /**
1242    * @dev get order contract address. use no gas.
1243    */
1244   function getOrderContract() public view returns(address) {
1245     return orderContract;
1246   }
1247 
1248   /**
1249    * @dev Gets the total number of tokens pledged under the current contract.
1250    */
1251   function getPledgeAccountSum() public view returns(uint256) {
1252     return pledgeAccountSum;
1253   }
1254 
1255   /**
1256    * @dev get current contract borrower address.
1257    */
1258   function getMakerAddress() public view returns(address) {
1259     return maker;
1260   }
1261 
1262   /**
1263    * @dev get current contract pledge Id.
1264    */
1265   function getPledgeId() external view returns(uint256) {
1266     return pledgeId;
1267   }
1268 
1269 }
1270 
1271 
1272 
1273 /**
1274  * @title pledge pool base
1275  * @dev a base tokenPool, any tokenPool for a specific token should inherit from this tokenPool.
1276  */
1277 contract PledgePoolBase is RBACOperator {
1278   using SafeMath for uint256;
1279   using AddressUtils for address;
1280 
1281   // Record pledge details.
1282   mapping(uint256 => Escrow) internal escrows;
1283 
1284   /**
1285    * @dev Information structure of pledge.
1286    */
1287   struct Escrow {
1288     uint256 pledgeSum;
1289     address payerAddress;
1290     string tokenName;
1291   }
1292 
1293   // -----------------------------------------
1294   // TokenPool external interface
1295   // -----------------------------------------
1296 
1297   /**
1298    * @dev addRecord, interface to add record.
1299    * @param _payerAddress Address performing the pleadge.
1300    * @param _pledgeSum the value to pleadge.
1301    * @param _pledgeId pledge contract index number.
1302    * @param _tokenName pledge token name.
1303    */
1304   function addRecord(address _payerAddress, uint256 _pledgeSum, uint256 _pledgeId, string _tokenName) public hasOperationPermission returns(bool) {
1305     _preValidateAddRecord(_payerAddress, _pledgeSum, _pledgeId, _tokenName);
1306     _processAddRecord(_payerAddress, _pledgeSum, _pledgeId, _tokenName);
1307     return true;
1308   }
1309 
1310 
1311    /**
1312     * @dev withdrawToken, withdraw pledge token.
1313     * @param _pledgeId pledge contract index number.
1314     * @param _maker borrower address.
1315     * @param _num withdraw token sum.
1316     */
1317   function withdrawToken(uint256 _pledgeId, address _maker, uint256 _num) public hasOperationPermission returns(bool) {
1318     _preValidateWithdraw(_maker, _num, _pledgeId);
1319     _processWithdraw(_maker, _num, _pledgeId);
1320     return true;
1321   }
1322 
1323 
1324   /**
1325    * @dev refundTokens, interface to refund
1326    * @param _pledgeId pledge contract index number.
1327    * @param _targetAddress transfer target address.
1328    * @param _returnSum return token sum.
1329    */
1330   function refundTokens(uint256 _pledgeId, uint256 _returnSum, address _targetAddress) public hasOperationPermission returns(bool) {
1331     _preValidateRefund(_returnSum, _targetAddress, _pledgeId);
1332     _processRefund(_returnSum, _targetAddress, _pledgeId);
1333     return true;
1334   }
1335 
1336   /**
1337    * @dev getLedger, Query the pledge details of the pledge number in the pool.
1338    * @param _pledgeId pledge contract index number.
1339    */
1340   function getLedger(uint256 _pledgeId) public view returns(uint256 num, address payerAddress, string tokenName) {
1341     require(_pledgeId > 0);
1342     num = escrows[_pledgeId].pledgeSum;
1343     payerAddress = escrows[_pledgeId].payerAddress;
1344     tokenName = escrows[_pledgeId].tokenName;
1345   }
1346 
1347 
1348 
1349   // -----------------------------------------
1350   // TokenPool internal interface (extensible)
1351   // -----------------------------------------
1352 
1353 
1354 
1355   /**
1356    * @dev _preValidateAddRecord, Validation of an incoming AddRecord. Use require statemens to revert state when conditions are not met.
1357    * @param _payerAddress Address performing the pleadge.
1358    * @param _pledgeSum the value to pleadge.
1359    * @param _pledgeId pledge contract index number.
1360    * @param _tokenName pledge token name.
1361    */
1362   function _preValidateAddRecord(address _payerAddress, uint256 _pledgeSum, uint256 _pledgeId, string _tokenName) view internal {
1363     require(_pledgeSum > 0 && _pledgeId > 0
1364       && _payerAddress != address(0)
1365       && bytes(_tokenName).length > 0
1366       && address(msg.sender).isContract()
1367       && PledgeContract(msg.sender).getPledgeId()==_pledgeId
1368     );
1369   }
1370 
1371   /**
1372    * @dev _processAddRecord, Executed when a AddRecord has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1373    * @param _payerAddress Address performing the pleadge.
1374    * @param _pledgeSum the value to pleadge.
1375    * @param _pledgeId pledge contract index number.
1376    * @param _tokenName pledge token name.
1377    */
1378   function _processAddRecord(address _payerAddress, uint256 _pledgeSum, uint256 _pledgeId, string _tokenName) internal {
1379     Escrow memory escrow = Escrow(_pledgeSum, _payerAddress, _tokenName);
1380     escrows[_pledgeId] = escrow;
1381   }
1382 
1383 
1384 
1385   /**
1386    * @dev _preValidateRefund, Validation of an incoming refund. Use require statemens to revert state when conditions are not met.
1387    * @param _pledgeId pledge contract index number.
1388    * @param _targetAddress transfer target address.
1389    * @param _returnSum return token sum.
1390    */
1391   function _preValidateRefund(uint256 _returnSum, address _targetAddress, uint256 _pledgeId) view internal {
1392     require(_returnSum > 0 && _pledgeId > 0
1393       && _targetAddress != address(0)
1394       && address(msg.sender).isContract()
1395       && _returnSum <= escrows[_pledgeId].pledgeSum
1396       && PledgeContract(msg.sender).getPledgeId()==_pledgeId
1397     );
1398   }
1399 
1400 
1401   /**
1402    * @dev _processRefund, Executed when a Refund has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1403    * @param _pledgeId pledge contract index number.
1404    * @param _targetAddress transfer target address.
1405    * @param _returnSum return token sum.
1406    */
1407   function _processRefund(uint256 _returnSum, address _targetAddress, uint256 _pledgeId) internal {
1408     escrows[_pledgeId].pledgeSum = escrows[_pledgeId].pledgeSum.sub(_returnSum);
1409   }
1410 
1411 
1412 
1413   /**
1414    * @dev _preValidateWithdraw, Withdraw initiated parameter validation.
1415    * @param _pledgeId pledge contract index number.
1416    * @param _maker borrower address.
1417    * @param _num withdraw token sum.
1418    */
1419   function _preValidateWithdraw(address _maker, uint256 _num, uint256 _pledgeId) view internal {
1420     require(_num > 0 && _pledgeId > 0
1421        && _maker != address(0)
1422        && address(msg.sender).isContract()
1423        && _num <= escrows[_pledgeId].pledgeSum
1424        && PledgeContract(msg.sender).getPledgeId()==_pledgeId
1425     );
1426   }
1427 
1428 
1429   /**
1430    * @dev _processWithdraw, Withdraw data update.
1431    * @param _pledgeId pledge contract index number.
1432    * @param _maker borrower address.
1433    * @param _num withdraw token sum.
1434    */
1435   function _processWithdraw(address _maker, uint256 _num, uint256 _pledgeId) internal {
1436     escrows[_pledgeId].pledgeSum = escrows[_pledgeId].pledgeSum.sub(_num);
1437   }
1438 
1439 }
1440 
1441 
1442 
1443 /**
1444  * @title eth pledge pool.
1445  * @dev the tokenPool for ETH.
1446  */
1447 contract EthPledgePool is PledgePoolBase {
1448   using SafeMath for uint256;
1449   using AddressUtils for address;
1450   // -----------------------------------------
1451   // TokenPool external interface
1452   // -----------------------------------------
1453 
1454   /**
1455    * @dev fallback function
1456    */
1457   function() external payable {}
1458 
1459 
1460   /**
1461    * @dev recycle, Executed in some extreme unforsee cases, to avoid eth locked.
1462    * @param _amount Number of eth to withdraw
1463    * @param _contract Multi-signature contracts, for the fair and just treatment of funds.
1464    */
1465   function recycle(uint256 _amount,address _contract) public onlyOwner returns(bool) {
1466     require(_amount <= address(this).balance && _contract.isContract());
1467     _contract.transfer(_amount);
1468     return true;
1469   }
1470 
1471 
1472   /**
1473    * @dev kill, kills the contract and send everything to `_address`..
1474    */
1475   function kills() public onlyOwner {
1476     selfdestruct(owner);
1477   }
1478 
1479 
1480   // -----------------------------------------
1481   // token pool internal interface (extensible)
1482   // -----------------------------------------
1483 
1484 
1485   /**
1486    * @dev Executed when a Refund has been validated and is ready to be executed.
1487    *  Not necessarily emits/sends tokens.
1488    */
1489   function _processRefund(uint256 _returnSum, address _targetAddress, uint256 _pledgeId) internal {
1490     super._processRefund(_returnSum, _targetAddress, _pledgeId);
1491     require(address(this).balance >= _returnSum);
1492     _targetAddress.transfer(_returnSum);
1493   }
1494 
1495   /**
1496    * @dev Withdraw pledge token.
1497    */
1498   function _processWithdraw(address _maker, uint256 _num, uint256 _pledgeId) internal {
1499     super._processWithdraw(_maker, _num, _pledgeId);
1500     require(address(this).balance >= _num);
1501     _maker.transfer(_num);
1502   }
1503 
1504 }