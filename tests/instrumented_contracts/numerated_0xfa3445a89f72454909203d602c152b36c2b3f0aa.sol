1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title SafeCompare
6  */
7 library SafeCompare {
8   function stringCompare(string str1, string str2) internal pure returns(bool) {
9     return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
10   }
11 }
12 
13 
14 
15 
16 library SafeMath {
17 
18   /**
19    * @dev Multiplies two numbers, throws on overflow.
20    */
21   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31    * @dev Integer division of two numbers, truncating the quotient.
32    */
33   function div(uint256 a, uint256 b) internal pure returns(uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   /**
41    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42    */
43   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49    * @dev Adds two numbers, throws on overflow.
50    */
51   function add(uint256 a, uint256 b) internal pure returns(uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract UsdtERC20Basic {
64     uint public _totalSupply;
65     function totalSupply() public constant returns (uint);
66     function balanceOf(address who) public constant returns (uint);
67     function transfer(address to, uint value) public;
68     event Transfer(address indexed from, address indexed to, uint value);
69 }
70 
71 
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   function totalSupply() public view returns(uint256);
80 
81   function balanceOf(address who) public view returns(uint256);
82 
83   function transfer(address to, uint256 value) public returns(bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 
89 /**
90  * @title Roles
91  * @author Francisco Giordano (@frangio)
92  * @dev Library for managing addresses assigned to a Role.
93  * See RBAC.sol for example usage.
94  */
95 library Roles {
96   struct Role {
97     mapping(address => bool) bearer;
98   }
99 
100   /**
101    * @dev give an address access to this role
102    */
103   function add(Role storage _role, address _addr)
104   internal {
105     _role.bearer[_addr] = true;
106   }
107 
108   /**
109    * @dev remove an address' access to this role
110    */
111   function remove(Role storage _role, address _addr)
112   internal {
113     _role.bearer[_addr] = false;
114   }
115 
116   /**
117    * @dev check if an address has this role
118    * // reverts
119    */
120   function check(Role storage _role, address _addr)
121   internal
122   view {
123     require(has(_role, _addr));
124   }
125 
126   /**
127    * @dev check if an address has this role
128    * @return bool
129    */
130   function has(Role storage _role, address _addr)
131   internal
132   view
133   returns(bool) {
134     return _role.bearer[_addr];
135   }
136 }
137 
138 
139 /**
140  * Utility library of inline functions on addresses
141  */
142 library AddressUtils {
143 
144   /**
145    * Returns whether there is code in the target address
146    * @dev This function will return false if invoked during the constructor of a contract,
147    *  as the code is not actually created until after the constructor finishes.
148    * @param addr address address to check
149    * @return whether there is code in the target address
150    */
151   function isContract(address addr) internal view returns(bool) {
152     uint256 size;
153     assembly {
154       size: = extcodesize(addr)
155     }
156     return size > 0;
157   }
158 
159 }
160 
161 
162 
163 /**
164  * @title Ownable
165  * @dev The Ownable contract has an owner address, and provides basic authorization control
166  * functions, this simplifies the implementation of "user permissions".
167  */
168 contract Ownable {
169   address public owner;
170 
171 
172   event OwnershipRenounced(address indexed previousOwner);
173   event OwnershipTransferred(
174     address indexed previousOwner,
175     address indexed newOwner
176   );
177 
178 
179   /**
180    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
181    * account.
182    */
183   constructor() public {
184     owner = msg.sender;
185   }
186 
187   /**
188    * @dev Throws if called by any account other than the owner.
189    */
190   modifier onlyOwner() {
191     require(msg.sender == owner);
192     _;
193   }
194 
195   /**
196    * @dev Allows the current owner to relinquish control of the contract.
197    * @notice Renouncing to ownership will leave the contract without an owner.
198    * It will not be possible to call the functions with the `onlyOwner`
199    * modifier anymore.
200    */
201   function renounceOwnership() public onlyOwner {
202     emit OwnershipRenounced(owner);
203     owner = address(0);
204   }
205 
206   /**
207    * @dev Allows the current owner to transfer control of the contract to a newOwner.
208    * @param _newOwner The address to transfer ownership to.
209    */
210   function transferOwnership(address _newOwner) public onlyOwner {
211     _transferOwnership(_newOwner);
212   }
213 
214   /**
215    * @dev Transfers control of the contract to a newOwner.
216    * @param _newOwner The address to transfer ownership to.
217    */
218   function _transferOwnership(address _newOwner) internal {
219     require(_newOwner != address(0));
220     emit OwnershipTransferred(owner, _newOwner);
221     owner = _newOwner;
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
304   /**
305    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
306    * @param _roles the names of the roles to scope access to
307    * // reverts
308    *
309    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
310    *  see: https://github.com/ethereum/solidity/issues/2467
311    */
312   // modifier onlyRoles(string[] _roles) {
313   //     bool hasAnyRole = false;
314   //     for (uint8 i = 0; i < _roles.length; i++) {
315   //         if (hasRole(msg.sender, _roles[i])) {
316   //             hasAnyRole = true;
317   //             break;
318   //         }
319   //     }
320 
321   //     require(hasAnyRole);
322 
323   //     _;
324   // }
325 }
326 
327 
328 
329 
330 contract PartnerAuthority is Ownable {
331 
332 
333   address public partner;
334   /**
335    * Event for setPartner logging
336    * @param oldPartner the old  Partner
337    * @param newPartner the new  Partner
338    */
339   event SetPartner(address oldPartner, address newPartner);
340 
341   /**
342    * @dev Throws if called by any account other than the owner or the Partner.
343    */
344   modifier onlyOwnerOrPartner() {
345     require(msg.sender == owner || msg.sender == partner);
346     _;
347   }
348 
349   /**
350    * @dev Throws if called by any account other than the Partner.
351    */
352   modifier onlyPartner() {
353     require(msg.sender == partner);
354     _;
355   }
356 
357 
358   /**
359    * @dev setPartner, set the  partner address.
360    */
361   function setPartner(address _partner) public onlyOwner {
362     require(_partner != address(0));
363     emit SetPartner(partner, _partner);
364     partner = _partner;
365   }
366 
367 
368 
369   /**
370    * @dev removePartner, remove  partner address.
371    */
372   function removePartner() public onlyOwner {
373     delete partner;
374   }
375 
376 
377 }
378 
379 
380 
381 
382 
383 
384 contract RBACOperator is Ownable, RBAC {
385 
386   /**
387    * A constant role name for indicating operator.
388    */
389   string public constant ROLE_OPERATOR = "operator";
390 
391   address public partner;
392   /**
393    * Event for setPartner logging
394    * @param oldPartner the old  Partner
395    * @param newPartner the new  Partner
396    */
397   event SetPartner(address oldPartner, address newPartner);
398 
399   /**
400    * @dev Throws if called by any account other than the owner or the Partner.
401    */
402   modifier onlyOwnerOrPartner() {
403     require(msg.sender == owner || msg.sender == partner);
404     _;
405   }
406 
407   /**
408    * @dev Throws if called by any account other than the Partner.
409    */
410   modifier onlyPartner() {
411     require(msg.sender == partner);
412     _;
413   }
414 
415 
416   /**
417    * @dev setPartner, set the  partner address.
418    * @param _partner the new  partner address.
419    */
420   function setPartner(address _partner) public onlyOwner {
421     require(_partner != address(0));
422     emit SetPartner(partner, _partner);
423     partner = _partner;
424   }
425 
426 
427   /**
428    * @dev removePartner, remove  partner address.
429    */
430   function removePartner() public onlyOwner {
431     delete partner;
432   }
433 
434   /**
435    * @dev the modifier to operate
436    */
437   modifier hasOperationPermission() {
438     checkRole(msg.sender, ROLE_OPERATOR);
439     _;
440   }
441 
442 
443 
444   /**
445    * @dev add a operator role to an address
446    * @param _operator address
447    */
448   function addOperater(address _operator) public onlyOwnerOrPartner {
449     addRole(_operator, ROLE_OPERATOR);
450   }
451 
452   /**
453    * @dev remove a operator role from an address
454    * @param _operator address
455    */
456   function removeOperater(address _operator) public onlyOwnerOrPartner {
457     removeRole(_operator, ROLE_OPERATOR);
458   }
459 }
460 
461 
462 
463 
464 
465 
466 
467 
468 /**
469  * @title ERC20 interface
470  * @dev see https://github.com/ethereum/EIPs/issues/20
471  */
472 contract ERC20 is ERC20Basic {
473   function allowance(address owner, address spender) public view returns(uint256);
474 
475   function transferFrom(address from, address to, uint256 value) public returns(bool);
476 
477   function approve(address spender, uint256 value) public returns(bool);
478   event Approval(address indexed owner, address indexed spender, uint256 value);
479 }
480 
481 
482 
483 /**
484  * @title ERC20 interface
485  * @dev see https://github.com/ethereum/EIPs/issues/20
486  */
487 contract UsdtERC20 is UsdtERC20Basic {
488     function allowance(address owner, address spender) public constant returns (uint);
489     function transferFrom(address from, address to, uint value) public;
490     function approve(address spender, uint value) public;
491     event Approval(address indexed owner, address indexed spender, uint value);
492 }
493 
494 
495 
496 
497 
498 
499 
500 
501 /**
502  * @title pledge pool base
503  * @dev a base tokenPool, any tokenPool for a specific token should inherit from this tokenPool.
504  */
505 contract PledgePoolBase is RBACOperator {
506   using SafeMath for uint256;
507   using AddressUtils for address;
508 
509   // Record pledge details.
510   mapping(uint256 => Escrow) internal escrows;
511 
512   /**
513    * @dev Information structure of pledge.
514    */
515   struct Escrow {
516     uint256 pledgeSum;
517     address payerAddress;
518     string tokenName;
519   }
520 
521   // -----------------------------------------
522   // TokenPool external interface
523   // -----------------------------------------
524 
525   /**
526    * @dev addRecord, interface to add record.
527    * @param _payerAddress Address performing the pleadge.
528    * @param _pledgeSum the value to pleadge.
529    * @param _pledgeId pledge contract index number.
530    * @param _tokenName pledge token name.
531    */
532   function addRecord(address _payerAddress, uint256 _pledgeSum, uint256 _pledgeId, string _tokenName) public hasOperationPermission returns(bool) {
533     _preValidateAddRecord(_payerAddress, _pledgeSum, _pledgeId, _tokenName);
534     _processAddRecord(_payerAddress, _pledgeSum, _pledgeId, _tokenName);
535     return true;
536   }
537 
538 
539    /**
540     * @dev withdrawToken, withdraw pledge token.
541     * @param _pledgeId pledge contract index number.
542     * @param _maker borrower address.
543     * @param _num withdraw token sum.
544     */
545   function withdrawToken(uint256 _pledgeId, address _maker, uint256 _num) public hasOperationPermission returns(bool) {
546     _preValidateWithdraw(_maker, _num, _pledgeId);
547     _processWithdraw(_maker, _num, _pledgeId);
548     return true;
549   }
550 
551 
552   /**
553    * @dev refundTokens, interface to refund
554    * @param _pledgeId pledge contract index number.
555    * @param _targetAddress transfer target address.
556    * @param _returnSum return token sum.
557    */
558   function refundTokens(uint256 _pledgeId, uint256 _returnSum, address _targetAddress) public hasOperationPermission returns(bool) {
559     _preValidateRefund(_returnSum, _targetAddress, _pledgeId);
560     _processRefund(_returnSum, _targetAddress, _pledgeId);
561     return true;
562   }
563 
564   /**
565    * @dev getLedger, Query the pledge details of the pledge number in the pool.
566    * @param _pledgeId pledge contract index number.
567    */
568   function getLedger(uint256 _pledgeId) public view returns(uint256 num, address payerAddress, string tokenName) {
569     require(_pledgeId > 0);
570     num = escrows[_pledgeId].pledgeSum;
571     payerAddress = escrows[_pledgeId].payerAddress;
572     tokenName = escrows[_pledgeId].tokenName;
573   }
574 
575 
576 
577   // -----------------------------------------
578   // TokenPool internal interface (extensible)
579   // -----------------------------------------
580 
581 
582 
583   /**
584    * @dev _preValidateAddRecord, Validation of an incoming AddRecord. Use require statemens to revert state when conditions are not met.
585    * @param _payerAddress Address performing the pleadge.
586    * @param _pledgeSum the value to pleadge.
587    * @param _pledgeId pledge contract index number.
588    * @param _tokenName pledge token name.
589    */
590   function _preValidateAddRecord(address _payerAddress, uint256 _pledgeSum, uint256 _pledgeId, string _tokenName) view internal {
591     require(_pledgeSum > 0 && _pledgeId > 0
592       && _payerAddress != address(0)
593       && bytes(_tokenName).length > 0
594       && address(msg.sender).isContract()
595       && PledgeContract(msg.sender).getPledgeId()==_pledgeId
596     );
597   }
598 
599   /**
600    * @dev _processAddRecord, Executed when a AddRecord has been validated and is ready to be executed. Not necessarily emits/sends tokens.
601    * @param _payerAddress Address performing the pleadge.
602    * @param _pledgeSum the value to pleadge.
603    * @param _pledgeId pledge contract index number.
604    * @param _tokenName pledge token name.
605    */
606   function _processAddRecord(address _payerAddress, uint256 _pledgeSum, uint256 _pledgeId, string _tokenName) internal {
607     Escrow memory escrow = Escrow(_pledgeSum, _payerAddress, _tokenName);
608     escrows[_pledgeId] = escrow;
609   }
610 
611 
612 
613   /**
614    * @dev _preValidateRefund, Validation of an incoming refund. Use require statemens to revert state when conditions are not met.
615    * @param _pledgeId pledge contract index number.
616    * @param _targetAddress transfer target address.
617    * @param _returnSum return token sum.
618    */
619   function _preValidateRefund(uint256 _returnSum, address _targetAddress, uint256 _pledgeId) view internal {
620     require(_returnSum > 0 && _pledgeId > 0
621       && _targetAddress != address(0)
622       && address(msg.sender).isContract()
623       && _returnSum <= escrows[_pledgeId].pledgeSum
624       && PledgeContract(msg.sender).getPledgeId()==_pledgeId
625     );
626   }
627 
628 
629   /**
630    * @dev _processRefund, Executed when a Refund has been validated and is ready to be executed. Not necessarily emits/sends tokens.
631    * @param _pledgeId pledge contract index number.
632    * @param _targetAddress transfer target address.
633    * @param _returnSum return token sum.
634    */
635   function _processRefund(uint256 _returnSum, address _targetAddress, uint256 _pledgeId) internal {
636     escrows[_pledgeId].pledgeSum = escrows[_pledgeId].pledgeSum.sub(_returnSum);
637   }
638 
639 
640 
641   /**
642    * @dev _preValidateWithdraw, Withdraw initiated parameter validation.
643    * @param _pledgeId pledge contract index number.
644    * @param _maker borrower address.
645    * @param _num withdraw token sum.
646    */
647   function _preValidateWithdraw(address _maker, uint256 _num, uint256 _pledgeId) view internal {
648     require(_num > 0 && _pledgeId > 0
649        && _maker != address(0)
650        && address(msg.sender).isContract()
651        && _num <= escrows[_pledgeId].pledgeSum
652        && PledgeContract(msg.sender).getPledgeId()==_pledgeId
653     );
654   }
655 
656 
657   /**
658    * @dev _processWithdraw, Withdraw data update.
659    * @param _pledgeId pledge contract index number.
660    * @param _maker borrower address.
661    * @param _num withdraw token sum.
662    */
663   function _processWithdraw(address _maker, uint256 _num, uint256 _pledgeId) internal {
664     escrows[_pledgeId].pledgeSum = escrows[_pledgeId].pledgeSum.sub(_num);
665   }
666 
667 }
668 
669 
670 
671 
672 
673 
674 
675 
676 
677 
678 /**
679  * @title OrderManageContract
680  * @dev Order process management contract.
681  */
682 contract OrderManageContract is PartnerAuthority {
683   using SafeMath for uint256;
684   using SafeCompare for string;
685 
686   /**
687    * @dev Status of current business execution contract.
688    */
689   enum StatusChoices {
690     NO_LOAN,
691     REPAYMENT_WAITING,
692     REPAYMENT_ALL,
693     CLOSE_POSITION,
694     OVERDUE_STOP
695   }
696 
697   string internal constant TOKEN_ETH = "ETH";
698   string internal constant TOKEN_USDT = "USDT";
699   address public maker;
700   address public taker;
701   address internal token20;
702 
703   uint256 public toTime;
704   // the amount of the borrower’s final loan.
705   uint256 public outLoanSum;
706   uint256 public repaymentSum;
707   uint256 public lastRepaymentSum;
708   string public loanTokenName;
709   // Borrower's record of the pledge.
710   StatusChoices internal status;
711 
712   // Record the amount of the borrower's offline transfer.
713   mapping(address => uint256) public ethAmount;
714 
715   /**
716    * Event for takerOrder logging.
717    * @param taker address of investor.
718    * @param outLoanSum the amount of the borrower’s final loan.
719    */
720   event TakerOrder(address indexed taker, uint256 outLoanSum);
721 
722 
723   /**
724    * Event for executeOrder logging.
725    * @param maker address of borrower.
726    * @param lastRepaymentSum current order repayment amount.
727    */
728   event ExecuteOrder(address indexed maker, uint256 lastRepaymentSum);
729 
730   /**
731    * Event for forceCloseOrder logging.
732    * @param toTime order repayment due date.
733    * @param transferSum balance under current contract.
734    */
735   event ForceCloseOrder(uint256 indexed toTime, uint256 transferSum);
736 
737   /**
738    * Event for WithdrawToken logging.
739    * @param taker address of investor.
740    * @param refundSum number of tokens withdrawn.
741    */
742   event WithdrawToken(address indexed taker, uint256 refundSum);
743 
744 
745 
746   function() external payable {
747     // Record basic information about the borrower's REPAYMENT ETH
748     ethAmount[msg.sender] = ethAmount[msg.sender].add(msg.value);
749   }
750 
751 
752   /**
753    * @dev Constructor initial contract configuration parameters
754    * @param _loanTokenAddress order type supported by the token.
755    */
756   constructor(string _loanTokenName, address _loanTokenAddress, address _maker) public {
757     require(bytes(_loanTokenName).length > 0 && _maker != address(0));
758     if (!_loanTokenName.stringCompare(TOKEN_ETH)) {
759       require(_loanTokenAddress != address(0));
760       token20 = _loanTokenAddress;
761     }
762     toTime = now;
763     maker = _maker;
764     loanTokenName = _loanTokenName;
765     status = StatusChoices.NO_LOAN;
766   }
767 
768   /**
769    * @dev Complete an order combination and issue the loan to the borrower.
770    * @param _taker address of investor.
771    * @param _toTime order repayment due date.
772    * @param _repaymentSum total amount of money that the borrower ultimately needs to return.
773    */
774   function takerOrder(address _taker, uint32 _toTime, uint256 _repaymentSum) public onlyOwnerOrPartner {
775     require(_taker != address(0) && _toTime > 0 && now <= _toTime && _repaymentSum > 0 && status == StatusChoices.NO_LOAN);
776     taker = _taker;
777     toTime = _toTime;
778     repaymentSum = _repaymentSum;
779 
780     // Transfer the token provided by the investor to the borrower's address
781     if (loanTokenName.stringCompare(TOKEN_ETH)) {
782       require(ethAmount[_taker] > 0 && address(this).balance > 0);
783       outLoanSum = address(this).balance;
784       maker.transfer(outLoanSum);
785     } else {
786       require(token20 != address(0) && ERC20(token20).balanceOf(address(this)) > 0);
787       outLoanSum = ERC20(token20).balanceOf(address(this));
788       require(safeErc20Transfer(maker, outLoanSum));
789     }
790 
791     // Update contract business execution status.
792     status = StatusChoices.REPAYMENT_WAITING;
793 
794     emit TakerOrder(taker, outLoanSum);
795   }
796 
797 
798 
799 
800 
801 
802   /**
803    * @dev Only the full repayment will execute the contract agreement.
804    */
805   function executeOrder() public onlyOwnerOrPartner {
806     require(now <= toTime && status == StatusChoices.REPAYMENT_WAITING);
807     // The borrower pays off the loan and performs two-way operation.
808     if (loanTokenName.stringCompare(TOKEN_ETH)) {
809       require(ethAmount[maker] >= repaymentSum && address(this).balance >= repaymentSum);
810       lastRepaymentSum = address(this).balance;
811       taker.transfer(repaymentSum);
812     } else {
813       require(ERC20(token20).balanceOf(address(this)) >= repaymentSum);
814       lastRepaymentSum = ERC20(token20).balanceOf(address(this));
815       require(safeErc20Transfer(taker, repaymentSum));
816     }
817 
818     PledgeContract(owner)._conclude();
819     status = StatusChoices.REPAYMENT_ALL;
820     emit ExecuteOrder(maker, lastRepaymentSum);
821   }
822 
823 
824 
825   /**
826    * @dev Close position or due repayment operation.
827    */
828   function forceCloseOrder() public onlyOwnerOrPartner {
829     require(status == StatusChoices.REPAYMENT_WAITING);
830     uint256 transferSum = 0;
831 
832     if (now <= toTime) {
833       status = StatusChoices.CLOSE_POSITION;
834     } else {
835       status = StatusChoices.OVERDUE_STOP;
836     }
837 
838     if(loanTokenName.stringCompare(TOKEN_ETH)){
839         if(ethAmount[maker] > 0 && address(this).balance > 0){
840             transferSum = address(this).balance;
841             maker.transfer(transferSum);
842         }
843     }else{
844         if(ERC20(token20).balanceOf(address(this)) > 0){
845             transferSum = ERC20(token20).balanceOf(address(this));
846             require(safeErc20Transfer(maker, transferSum));
847         }
848     }
849 
850     // Return pledge token.
851     PledgeContract(owner)._forceConclude(taker);
852     emit ForceCloseOrder(toTime, transferSum);
853   }
854 
855 
856 
857   /**
858    * @dev Withdrawal of the token invested by the taker.
859    * @param _taker address of investor.
860    * @param _refundSum refundSum number of tokens withdrawn.
861    */
862   function withdrawToken(address _taker, uint256 _refundSum) public onlyOwnerOrPartner {
863     require(status == StatusChoices.NO_LOAN);
864     require(_taker != address(0) && _refundSum > 0);
865     if (loanTokenName.stringCompare(TOKEN_ETH)) {
866       require(address(this).balance >= _refundSum && ethAmount[_taker] >= _refundSum);
867       _taker.transfer(_refundSum);
868       ethAmount[_taker] = ethAmount[_taker].sub(_refundSum);
869     } else {
870       require(ERC20(token20).balanceOf(address(this)) >= _refundSum);
871       require(safeErc20Transfer(_taker, _refundSum));
872     }
873     emit WithdrawToken(_taker, _refundSum);
874   }
875 
876 
877   /**
878    * @dev Since the implementation of usdt ERC20.sol transfer code does not design the return value,
879    * @dev which is different from most ERC20 token interfaces,most erc20 transfer token agreements return bool.
880    * @dev it is necessary to independently adapt the interface for usdt token in order to transfer successfully
881    * @dev if not, the transfer may fail.
882    */
883   function safeErc20Transfer(address _toAddress,uint256 _transferSum) internal returns (bool) {
884     if(loanTokenName.stringCompare(TOKEN_USDT)){
885       UsdtERC20(token20).transfer(_toAddress, _transferSum);
886     }else{
887       require(ERC20(token20).transfer(_toAddress, _transferSum));
888     }
889     return true;
890   }
891 
892 
893 
894   /**
895    * @dev Get current contract order status.
896    */
897   function getPledgeStatus() public view returns(string pledgeStatus) {
898     if (status == StatusChoices.NO_LOAN) {
899       pledgeStatus = "NO_LOAN";
900     } else if (status == StatusChoices.REPAYMENT_WAITING) {
901       pledgeStatus = "REPAYMENT_WAITING";
902     } else if (status == StatusChoices.REPAYMENT_ALL) {
903       pledgeStatus = "REPAYMENT_ALL";
904     } else if (status == StatusChoices.CLOSE_POSITION) {
905       pledgeStatus = "CLOSE_POSITION";
906     } else {
907       pledgeStatus = "OVERDUE_STOP";
908     }
909   }
910 
911 }
912 
913 
914 
915 
916 
917 
918 /**
919  * @title EscrowMaintainContract
920  * @dev Provides configuration and external interfaces.
921  */
922 contract EscrowMaintainContract is PartnerAuthority {
923   address public pledgeFactory;
924 
925   // map of token name to token pool address;
926   mapping(string => address) internal nameByPool;
927   // map of token name to erc20 token address;
928   mapping(string => address) internal nameByToken;
929 
930 
931 
932   // -----------------------------------------
933   // External interface
934   // -----------------------------------------
935 
936   /**
937    * @dev Create a pledge subcontract
938    * @param _pledgeId index number of the pledge contract.
939    */
940   function createPledgeContract(uint256 _pledgeId) public onlyPartner returns(bool) {
941     require(_pledgeId > 0 && pledgeFactory!=address(0));
942     require(PledgeFactory(pledgeFactory).createPledgeContract(_pledgeId,partner));
943     return true;
944   }
945 
946 
947   /**
948    * @dev Batch create a pledge subcontract
949    * @param _pledgeIds index number of the pledge contract.
950    */
951   function batchCreatePledgeContract(uint256[] _pledgeIds) public onlyPartner {
952     require(_pledgeIds.length > 0);
953     PledgeFactory(pledgeFactory).batchCreatePledgeContract(_pledgeIds,partner);
954   }
955 
956 
957   /**
958    * @dev Use the index to get the basic information of the corresponding pledge contract.
959    * @param _pledgeId index number of the pledge contract
960    */
961   function getEscrowPledge(uint256 _pledgeId) public view returns(string tokenName, address pledgeContract) {
962     require(_pledgeId > 0);
963     (tokenName,pledgeContract) = PledgeFactory(pledgeFactory).getEscrowPledge(_pledgeId);
964   }
965 
966 
967   /**
968    * @dev setTokenPool, set the token pool contract address of a token name.
969    * @param _tokenName set token pool name.
970    * @param _address the token pool contract address.
971    */
972   function setTokenPool(string _tokenName, address _address) public onlyOwner {
973     require(_address != address(0) && bytes(_tokenName).length > 0);
974     nameByPool[_tokenName] = _address;
975   }
976 
977    /**
978    * @dev setToken, set the token contract address of a token name.
979    * @param _tokenName token name
980    * @param _address the ERC20 token contract address.
981    */
982   function setToken(string _tokenName, address _address) public onlyOwner {
983     require(_address != address(0) && bytes(_tokenName).length > 0);
984     nameByToken[_tokenName] = _address;
985   }
986 
987 
988   /**
989   * @dev setPledgeFactory, Plant contract for configuration management pledge business.
990   * @param _factory pledge factory contract.
991   */
992   function setPledgeFactory(address _factory) public onlyOwner {
993     require(_factory != address(0));
994     pledgeFactory = _factory;
995   }
996 
997   /**
998    * @dev Checks whether the current token pool is supported.
999    * @param _tokenName token name
1000    */
1001   function includeTokenPool(string _tokenName) view public returns(address) {
1002     require(bytes(_tokenName).length > 0);
1003     return nameByPool[_tokenName];
1004   }
1005 
1006 
1007   /**
1008    * @dev Checks whether the current erc20 token is supported.
1009    * @param _tokenName token name
1010    */
1011   function includeToken(string _tokenName) view public returns(address) {
1012     require(bytes(_tokenName).length > 0);
1013     return nameByToken[_tokenName];
1014   }
1015 
1016 }
1017 
1018 
1019 /**
1020  * @title PledgeContract
1021  * @dev Pledge process management contract
1022  */
1023 contract PledgeContract is PartnerAuthority {
1024 
1025   using SafeMath for uint256;
1026   using SafeCompare for string;
1027 
1028   /**
1029    * @dev Type of execution state of the pledge contract（irreversible）
1030    */
1031   enum StatusChoices {
1032     NO_PLEDGE_INFO,
1033     PLEDGE_CREATE_MATCHING,
1034     PLEDGE_REFUND
1035   }
1036 
1037   string public pledgeTokenName;
1038   uint256 public pledgeId;
1039   address internal maker;
1040   address internal token20;
1041   address internal factory;
1042   address internal escrowContract;
1043   uint256 internal pledgeAccountSum;
1044   // order contract address
1045   address internal orderContract;
1046   string internal loanTokenName;
1047   StatusChoices internal status;
1048   address internal tokenPoolAddress;
1049   string internal constant TOKEN_ETH = "ETH";
1050   string internal constant TOKEN_USDT = "USDT";
1051   // ETH pledge account
1052   mapping(address => uint256) internal verifyEthAccount;
1053 
1054 
1055   /**
1056    * Event for createOrderContract logging.
1057    * @param newOrderContract management contract address.
1058    */
1059   event CreateOrderContract(address newOrderContract);
1060 
1061 
1062   /**
1063    * Event for WithdrawToken logging.
1064    * @param maker address of investor.
1065    * @param pledgeTokenName token name.
1066    * @param refundSum number of tokens withdrawn.
1067    */
1068   event WithdrawToken(address indexed maker, string pledgeTokenName, uint256 refundSum);
1069 
1070 
1071   /**
1072    * Event for appendEscrow logging.
1073    * @param maker address of borrower.
1074    * @param appendSum append amount.
1075    */
1076   event AppendEscrow(address indexed maker, uint256 appendSum);
1077 
1078 
1079   /**
1080    * @dev Constructor initial contract configuration parameters
1081    */
1082   constructor(uint256 _pledgeId, address _factory , address _escrowContract) public {
1083     require(_pledgeId > 0 && _factory != address(0) && _escrowContract != address(0));
1084     pledgeId = _pledgeId;
1085     factory = _factory;
1086     status = StatusChoices.NO_PLEDGE_INFO;
1087     escrowContract = _escrowContract;
1088   }
1089 
1090 
1091 
1092   // -----------------------------------------
1093   // external interface
1094   // -----------------------------------------
1095 
1096 
1097 
1098   function() external payable {
1099     require(status != StatusChoices.PLEDGE_REFUND);
1100     // Identify the borrower.
1101     if (maker != address(0)) {
1102       require(address(msg.sender) == maker);
1103     }
1104     // Record basic information about the borrower's pledge ETH
1105     verifyEthAccount[msg.sender] = verifyEthAccount[msg.sender].add(msg.value);
1106   }
1107 
1108 
1109   /**
1110    * @dev Add the pledge information and transfer the pledged token into the corresponding currency pool.
1111    * @param _pledgeTokenName maker pledge token name.
1112    * @param _maker borrower address.
1113    * @param _pledgeSum pledge amount.
1114    * @param _loanTokenName pledge token type.
1115    */
1116   function addRecord(string _pledgeTokenName, address _maker, uint256 _pledgeSum, string _loanTokenName) public onlyOwner {
1117     require(_maker != address(0) && _pledgeSum > 0 && status != StatusChoices.PLEDGE_REFUND);
1118     // Add the pledge information for the first time.
1119     if (status == StatusChoices.NO_PLEDGE_INFO) {
1120       // public data init.
1121       maker = _maker;
1122       pledgeTokenName = _pledgeTokenName;
1123       tokenPoolAddress = checkedTokenPool(pledgeTokenName);
1124       PledgeFactory(factory).updatePledgeType(pledgeId, pledgeTokenName);
1125       // Assign rights to the operation of the contract pool
1126       PledgeFactory(factory).tokenPoolOperater(tokenPoolAddress, address(this));
1127       // Create order management contracts.
1128       createOrderContract(_loanTokenName);
1129     }
1130     // Record information of each pledge.
1131     pledgeAccountSum = pledgeAccountSum.add(_pledgeSum);
1132     PledgePoolBase(tokenPoolAddress).addRecord(maker, pledgeAccountSum, pledgeId, pledgeTokenName);
1133     // Transfer the pledge token to the appropriate token pool.
1134     if (pledgeTokenName.stringCompare(TOKEN_ETH)) {
1135       require(verifyEthAccount[maker] >= _pledgeSum);
1136       tokenPoolAddress.transfer(_pledgeSum);
1137     } else {
1138       token20 = checkedToken(pledgeTokenName);
1139       require(ERC20(token20).balanceOf(address(this)) >= _pledgeSum);
1140       require(safeErc20Transfer(token20,tokenPoolAddress, _pledgeSum));
1141     }
1142   }
1143 
1144   /**
1145    * @dev Increase the number of pledged tokens.
1146    * @param _appendSum append amount.
1147    */
1148   function appendEscrow(uint256 _appendSum) public onlyOwner {
1149     require(status == StatusChoices.PLEDGE_CREATE_MATCHING);
1150     addRecord(pledgeTokenName, maker, _appendSum, loanTokenName);
1151     emit AppendEscrow(maker, _appendSum);
1152   }
1153 
1154 
1155   /**
1156    * @dev Withdraw pledge behavior.
1157    * @param _maker borrower address.
1158    */
1159   function withdrawToken(address _maker) public onlyOwner {
1160     require(status != StatusChoices.PLEDGE_REFUND);
1161     uint256 pledgeSum = 0;
1162     // there are two types of retractions.
1163     if (status == StatusChoices.NO_PLEDGE_INFO) {
1164       pledgeSum = classifySquareUp(_maker);
1165     } else {
1166       status = StatusChoices.PLEDGE_REFUND;
1167       require(PledgePoolBase(tokenPoolAddress).withdrawToken(pledgeId, maker, pledgeAccountSum));
1168       pledgeSum = pledgeAccountSum;
1169     }
1170     emit WithdrawToken(_maker, pledgeTokenName, pledgeSum);
1171   }
1172 
1173 
1174   /**
1175    * @dev Executed in some extreme unforsee cases, to avoid eth locked.
1176    * @param _tokenName recycle token type.
1177    * @param _amount Number of eth to recycle.
1178    */
1179   function recycle(string _tokenName, uint256 _amount) public onlyOwner {
1180     require(status != StatusChoices.NO_PLEDGE_INFO && _amount>0);
1181     if (_tokenName.stringCompare(TOKEN_ETH)) {
1182       require(address(this).balance >= _amount);
1183       owner.transfer(_amount);
1184     } else {
1185       address token = checkedToken(_tokenName);
1186       require(ERC20(token).balanceOf(address(this)) >= _amount);
1187       require(safeErc20Transfer(token,owner, _amount));
1188     }
1189   }
1190 
1191 
1192 
1193   /**
1194    * @dev Since the implementation of usdt ERC20.sol transfer code does not design the return value,
1195    * @dev which is different from most ERC20 token interfaces,most erc20 transfer token agreements return bool.
1196    * @dev it is necessary to independently adapt the interface for usdt token in order to transfer successfully
1197    * @dev if not, the transfer may fail.
1198    */
1199   function safeErc20Transfer(address _token20,address _toAddress,uint256 _transferSum) internal returns (bool) {
1200     if(loanTokenName.stringCompare(TOKEN_USDT)){
1201       UsdtERC20(_token20).transfer(_toAddress, _transferSum);
1202     }else{
1203       require(ERC20(_token20).transfer(_toAddress, _transferSum));
1204     }
1205     return true;
1206   }
1207 
1208 
1209 
1210   // -----------------------------------------
1211   // internal interface
1212   // -----------------------------------------
1213 
1214 
1215 
1216   /**
1217    * @dev Create an order process management contract for the match and repayment business.
1218    * @param _loanTokenName expect loan token type.
1219    */
1220   function createOrderContract(string _loanTokenName) internal {
1221     require(bytes(_loanTokenName).length > 0);
1222     status = StatusChoices.PLEDGE_CREATE_MATCHING;
1223     address loanToken20 = checkedToken(_loanTokenName);
1224     OrderManageContract newOrder = new OrderManageContract(_loanTokenName, loanToken20, maker);
1225     setPartner(address(newOrder));
1226     newOrder.setPartner(owner);
1227     // update contract public data.
1228     orderContract = newOrder;
1229     loanTokenName = _loanTokenName;
1230     emit CreateOrderContract(address(newOrder));
1231   }
1232 
1233   /**
1234    * @dev classification withdraw.
1235    * @dev Execute without changing the current contract data state.
1236    * @param _maker borrower address.
1237    */
1238   function classifySquareUp(address _maker) internal returns(uint256 sum) {
1239     if (pledgeTokenName.stringCompare(TOKEN_ETH)) {
1240       uint256 pledgeSum = verifyEthAccount[_maker];
1241       require(pledgeSum > 0 && address(this).balance >= pledgeSum);
1242       _maker.transfer(pledgeSum);
1243       verifyEthAccount[_maker] = 0;
1244       sum = pledgeSum;
1245     } else {
1246       uint256 balance = ERC20(token20).balanceOf(address(this));
1247       require(balance > 0);
1248       require(safeErc20Transfer(token20,_maker, balance));
1249       sum = balance;
1250     }
1251   }
1252 
1253   /**
1254    * @dev Check wether the token is included for a token name.
1255    * @param _tokenName token name.
1256    */
1257   function checkedToken(string _tokenName) internal view returns(address) {
1258     address tokenAddress = EscrowMaintainContract(escrowContract).includeToken(_tokenName);
1259     require(tokenAddress != address(0));
1260     return tokenAddress;
1261   }
1262 
1263   /**
1264    * @dev Check wether the token pool is included for a token name.
1265    * @param _tokenName pledge token name.
1266    */
1267   function checkedTokenPool(string _tokenName) internal view returns(address) {
1268     address tokenPool = EscrowMaintainContract(escrowContract).includeTokenPool(_tokenName);
1269     require(tokenPool != address(0));
1270     return tokenPool;
1271   }
1272 
1273 
1274 
1275   // -----------------------------------------
1276   // business relationship interface
1277   // (Only the order contract has authority to operate)
1278   // -----------------------------------------
1279 
1280 
1281 
1282   /**
1283    * @dev Refund of the borrower’s pledge.
1284    */
1285   function _conclude() public onlyPartner {
1286     require(status == StatusChoices.PLEDGE_CREATE_MATCHING);
1287     status = StatusChoices.PLEDGE_REFUND;
1288     require(PledgePoolBase(tokenPoolAddress).refundTokens(pledgeId, pledgeAccountSum, maker));
1289   }
1290 
1291   /**
1292    * @dev Expired for repayment or close position.
1293    * @param _taker address of investor.
1294    */
1295   function _forceConclude(address _taker) public onlyPartner {
1296     require(_taker != address(0) && status == StatusChoices.PLEDGE_CREATE_MATCHING);
1297     status = StatusChoices.PLEDGE_REFUND;
1298     require(PledgePoolBase(tokenPoolAddress).refundTokens(pledgeId, pledgeAccountSum, _taker));
1299   }
1300 
1301 
1302 
1303   // -----------------------------------------
1304   // query interface (use no gas)
1305   // -----------------------------------------
1306 
1307 
1308 
1309   /**
1310    * @dev Get current contract order status.
1311    * @return pledgeStatus state indicate.
1312    */
1313   function getPledgeStatus() public view returns(string pledgeStatus) {
1314     if (status == StatusChoices.NO_PLEDGE_INFO) {
1315       pledgeStatus = "NO_PLEDGE_INFO";
1316     } else if (status == StatusChoices.PLEDGE_CREATE_MATCHING) {
1317       pledgeStatus = "PLEDGE_CREATE_MATCHING";
1318     } else {
1319       pledgeStatus = "PLEDGE_REFUND";
1320     }
1321   }
1322 
1323   /**
1324    * @dev get order contract address. use no gas.
1325    */
1326   function getOrderContract() public view returns(address) {
1327     return orderContract;
1328   }
1329 
1330   /**
1331    * @dev Gets the total number of tokens pledged under the current contract.
1332    */
1333   function getPledgeAccountSum() public view returns(uint256) {
1334     return pledgeAccountSum;
1335   }
1336 
1337   /**
1338    * @dev get current contract borrower address.
1339    */
1340   function getMakerAddress() public view returns(address) {
1341     return maker;
1342   }
1343 
1344   /**
1345    * @dev get current contract pledge Id.
1346    */
1347   function getPledgeId() external view returns(uint256) {
1348     return pledgeId;
1349   }
1350 
1351 }
1352 
1353 
1354 
1355 
1356 /**
1357  * @title PledgeFactory
1358  * @dev Pledge factory contract.
1359  * @dev Specially provides the pledge guarantee creation and the statistics function.
1360  */
1361 contract PledgeFactory is RBACOperator {
1362   using AddressUtils for address;
1363 
1364   // initial type of pledge contract.
1365   string internal constant INIT_TOKEN_NAME = "UNKNOWN";
1366 
1367   mapping(uint256 => EscrowPledge) internal pledgeEscrowById;
1368   // pledge number unique screening.
1369   mapping(uint256 => bool) internal isPledgeId;
1370 
1371   /**
1372    * @dev Pledge guarantee statistics.
1373    */
1374   struct EscrowPledge {
1375     address pledgeContract;
1376     string tokenName;
1377   }
1378 
1379   /**
1380    * Event for createOrderContract logging.
1381    * @param pledgeId management contract id.
1382    * @param newPledgeAddress pledge management contract address.
1383    */
1384   event CreatePledgeContract(uint256 indexed pledgeId, address newPledgeAddress);
1385 
1386 
1387   /**
1388    * @dev Create a pledge subcontract
1389    * @param _pledgeId index number of the pledge contract.
1390    */
1391   function createPledgeContract(uint256 _pledgeId, address _escrowPartner) public onlyPartner returns(bool) {
1392     require(_pledgeId > 0 && !isPledgeId[_pledgeId] && _escrowPartner!=address(0));
1393 
1394     // Give the pledge contract the right to update statistics.
1395     PledgeContract pledgeAddress = new PledgeContract(_pledgeId, address(this),partner);
1396     pledgeAddress.transferOwnership(_escrowPartner);
1397     addOperater(address(pledgeAddress));
1398 
1399     // update pledge contract info
1400     isPledgeId[_pledgeId] = true;
1401     pledgeEscrowById[_pledgeId] = EscrowPledge(pledgeAddress, INIT_TOKEN_NAME);
1402 
1403     emit CreatePledgeContract(_pledgeId, address(pledgeAddress));
1404     return true;
1405   }
1406 
1407 
1408 
1409   /**
1410    * @dev Batch create a pledge subcontract
1411    * @param _pledgeIds index number of the pledge contract.
1412    */
1413   function batchCreatePledgeContract(uint256[] _pledgeIds, address _escrowPartner) public onlyPartner {
1414     require(_pledgeIds.length > 0 && _escrowPartner.isContract());
1415     for (uint i = 0; i < _pledgeIds.length; i++) {
1416       require(createPledgeContract(_pledgeIds[i],_escrowPartner));
1417     }
1418   }
1419 
1420   /**
1421    * @dev Use the index to get the basic information of the corresponding pledge contract.
1422    * @param _pledgeId index number of the pledge contract
1423    */
1424   function getEscrowPledge(uint256 _pledgeId) public view returns(string tokenName, address pledgeContract) {
1425     require(_pledgeId > 0);
1426     tokenName = pledgeEscrowById[_pledgeId].tokenName;
1427     pledgeContract = pledgeEscrowById[_pledgeId].pledgeContract;
1428   }
1429 
1430 
1431 
1432 
1433   // -----------------------------------------
1434   // Internal interface (Only the pledge contract has authority to operate)
1435   // -----------------------------------------
1436 
1437 
1438   /**
1439    * @dev Configure permissions to operate on the token pool.
1440    * @param _tokenPool token pool contract address.
1441    * @param _pledge pledge contract address.
1442    */
1443   function tokenPoolOperater(address _tokenPool, address _pledge) public hasOperationPermission {
1444     require(_pledge != address(0) && address(msg.sender).isContract() && address(msg.sender) == _pledge);
1445     PledgePoolBase(_tokenPool).addOperater(_pledge);
1446   }
1447 
1448 
1449   /**
1450    * @dev Update the basic data of the pledge contract.
1451    * @param _pledgeId index number of the pledge contract.
1452    * @param _tokenName pledge contract supported token type.
1453    */
1454   function updatePledgeType(uint256 _pledgeId, string _tokenName) public hasOperationPermission {
1455     require(_pledgeId > 0 && bytes(_tokenName).length > 0 && address(msg.sender).isContract());
1456     pledgeEscrowById[_pledgeId].tokenName = _tokenName;
1457   }
1458 }