1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Roles
5  * @author Francisco Giordano (@frangio)
6  * @dev Library for managing addresses assigned to a Role.
7  *      See RBAC.sol for example usage.
8  */
9 library Roles {
10   struct Role {
11     mapping (address => bool) bearer;
12   }
13 
14   /**
15    * @dev give an address access to this role
16    */
17   function add(Role storage role, address addr)
18     internal
19   {
20     role.bearer[addr] = true;
21   }
22 
23   /**
24    * @dev remove an address' access to this role
25    */
26   function remove(Role storage role, address addr)
27     internal
28   {
29     role.bearer[addr] = false;
30   }
31 
32   /**
33    * @dev check if an address has this role
34    * // reverts
35    */
36   function check(Role storage role, address addr)
37     view
38     internal
39   {
40     require(has(role, addr));
41   }
42 
43   /**
44    * @dev check if an address has this role
45    * @return bool
46    */
47   function has(Role storage role, address addr)
48     view
49     internal
50     returns (bool)
51   {
52     return role.bearer[addr];
53   }
54 }
55 
56 /**
57  * @title RBAC (Role-Based Access Control)
58  * @author Matt Condon (@Shrugs)
59  * @dev Stores and provides setters and getters for roles and addresses.
60  * @dev Supports unlimited numbers of roles and addresses.
61  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
62  * This RBAC method uses strings to key roles. It may be beneficial
63  *  for you to write your own implementation of this interface using Enums or similar.
64  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
65  *  to avoid typos.
66  */
67 contract RBAC {
68   using Roles for Roles.Role;
69 
70   mapping (string => Roles.Role) private roles;
71 
72   event RoleAdded(address addr, string roleName);
73   event RoleRemoved(address addr, string roleName);
74 
75   /**
76    * @dev reverts if addr does not have role
77    * @param addr address
78    * @param roleName the name of the role
79    * // reverts
80    */
81   function checkRole(address addr, string roleName)
82     view
83     public
84   {
85     roles[roleName].check(addr);
86   }
87 
88   /**
89    * @dev determine if addr has role
90    * @param addr address
91    * @param roleName the name of the role
92    * @return bool
93    */
94   function hasRole(address addr, string roleName)
95     view
96     public
97     returns (bool)
98   {
99     return roles[roleName].has(addr);
100   }
101 
102   /**
103    * @dev add a role to an address
104    * @param addr address
105    * @param roleName the name of the role
106    */
107   function addRole(address addr, string roleName)
108     internal
109   {
110     roles[roleName].add(addr);
111     emit RoleAdded(addr, roleName);
112   }
113 
114   /**
115    * @dev remove a role from an address
116    * @param addr address
117    * @param roleName the name of the role
118    */
119   function removeRole(address addr, string roleName)
120     internal
121   {
122     roles[roleName].remove(addr);
123     emit RoleRemoved(addr, roleName);
124   }
125 
126   /**
127    * @dev modifier to scope access to a single role (uses msg.sender as addr)
128    * @param roleName the name of the role
129    * // reverts
130    */
131   modifier onlyRole(string roleName)
132   {
133     checkRole(msg.sender, roleName);
134     _;
135   }
136 
137   /**
138    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
139    * @param roleNames the names of the roles to scope access to
140    * // reverts
141    *
142    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
143    *  see: https://github.com/ethereum/solidity/issues/2467
144    */
145   // modifier onlyRoles(string[] roleNames) {
146   //     bool hasAnyRole = false;
147   //     for (uint8 i = 0; i < roleNames.length; i++) {
148   //         if (hasRole(msg.sender, roleNames[i])) {
149   //             hasAnyRole = true;
150   //             break;
151   //         }
152   //     }
153 
154   //     require(hasAnyRole);
155 
156   //     _;
157   // }
158 }
159 
160 /**
161  * @title RBACWithAdmin
162  * @author Matt Condon (@Shrugs)
163  * @dev It's recommended that you define constants in the contract,
164  * @dev like ROLE_ADMIN below, to avoid typos.
165  */
166 contract RBACWithAdmin is RBAC {
167   /**
168    * A constant role name for indicating admins.
169    */
170   string public constant ROLE_ADMIN = "admin";
171 
172   /**
173    * @dev modifier to scope access to admins
174    * // reverts
175    */
176   modifier onlyAdmin()
177   {
178     checkRole(msg.sender, ROLE_ADMIN);
179     _;
180   }
181 
182   /**
183    * @dev constructor. Sets msg.sender as admin by default
184    */
185   function RBACWithAdmin()
186     public
187   {
188     addRole(msg.sender, ROLE_ADMIN);
189   }
190 
191   /**
192    * @dev add a role to an address
193    * @param addr address
194    * @param roleName the name of the role
195    */
196   function adminAddRole(address addr, string roleName)
197     onlyAdmin
198     public
199   {
200     addRole(addr, roleName);
201   }
202 
203   /**
204    * @dev remove a role from an address
205    * @param addr address
206    * @param roleName the name of the role
207    */
208   function adminRemoveRole(address addr, string roleName)
209     onlyAdmin
210     public
211   {
212     removeRole(addr, roleName);
213   }
214 }
215 
216 /**
217  * @title SafeMath
218  * @dev Math operations with safety checks that throw on error
219  */
220 library SafeMath {
221 
222     /**
223     * @dev Multiplies two numbers, throws on overflow.
224     */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
226         if (a == 0) {
227             return 0;
228         }
229         c = a * b;
230         assert(c / a == b);
231         return c;
232     }
233 
234     /**
235     * @dev Integer division of two numbers, truncating the quotient.
236     */
237     function div(uint256 a, uint256 b) internal pure returns (uint256) {
238         // assert(b > 0); // Solidity automatically throws when dividing by 0
239         // uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241         return a / b;
242     }
243 
244     /**
245     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
246     */
247     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248         assert(b <= a);
249         return a - b;
250     }
251 
252     /**
253     * @dev Adds two numbers, throws on overflow.
254     */
255     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
256         c = a + b;
257         assert(c >= a);
258         return c;
259     }
260 }
261 
262 contract ERC20 {
263     function balanceOf(address _owner) public constant returns (uint256 balance);
264     function transfer(address _to, uint256 _value) public returns (bool success);
265 }
266 
267 
268 // Contract Code for Faculty - Faculty Devs
269 contract FacultyPool is RBACWithAdmin {
270 
271     using SafeMath for uint;
272 
273     // Constants
274     // ========================================================
275     uint8 constant CONTRACT_OPEN = 1;
276     uint8 constant CONTRACT_CLOSED = 2;
277     uint8 constant CONTRACT_SUBMIT_FUNDS = 3;
278     // 500,000 max gas
279     uint256 constant public gasLimit = 50000000000;
280     // 0.1 ether
281     uint256 constant public minContribution = 100000000000000000;
282 
283     // State Vars
284     // ========================================================
285     // recipient address for fee
286     address public owner;
287     // the fee taken in tokens from the pool
288     uint256 public feePct;
289     // open our contract initially
290     uint8 public contractStage = CONTRACT_OPEN;
291     // the current Beneficiary Cap level in wei
292     uint256 public currentBeneficiaryCap;
293     // the total cap in wei of the pool
294     uint256 public totalPoolCap;
295     // the destination for this contract
296     address public receiverAddress;
297     // our beneficiaries
298     mapping (address => Beneficiary) beneficiaries;
299     // the total we raised before closing pool
300     uint256 public finalBalance;
301     // a set of refund amounts we may need to process
302     uint256[] public ethRefundAmount;
303     // mapping that holds the token allocation struct for each token address
304     mapping (address => TokenAllocation) tokenAllocationMap;
305     // the default token address
306     address public defaultToken;
307 
308 
309     // Modifiers and Structs
310     // ========================================================
311     // only run certain methods when contract is open
312     modifier isOpenContract() {
313         require (contractStage == CONTRACT_OPEN);
314         _;
315     }
316 
317     // stop double processing attacks
318     bool locked;
319     modifier noReentrancy() {
320         require(!locked);
321         locked = true;
322         _;
323         locked = false;
324     }
325 
326     // Beneficiary
327     struct Beneficiary {
328         uint256 ethRefund;
329         uint256 balance;
330         uint256 cap;
331         mapping (address => uint256) tokensClaimed;
332     }
333 
334     // data structure for holding information related to token withdrawals.
335     struct TokenAllocation {
336         ERC20 token;
337         uint256[] pct;
338         uint256 balanceRemaining;
339     }
340 
341     // Events
342     // ========================================================
343     event BeneficiaryBalanceChanged(address indexed beneficiary, uint256 totalBalance);
344     event ReceiverAddressSet(address indexed receiverAddress);
345     event ERC223Received(address indexed token, uint256 value);
346     event DepositReceived(address indexed beneficiary, uint256 amount, uint256 gas, uint256 gasprice, uint256 gasLimit);
347     event PoolStageChanged(uint8 stage);
348     event PoolSubmitted(address indexed receiver, uint256 amount);
349     event RefundReceived(address indexed sender, uint256 amount);
350     event TokenWithdrawal(address indexed beneficiary, address indexed token, uint256 amount);
351     event EthRefunded(address indexed beneficiary, uint256 amount);
352 
353     // CODE BELOW HERE
354     // ========================================================
355 
356     /*
357      * Construct a pool with a set of admins, the poolCap and the cap each beneficiary gets. And,
358      * optionally, the receiving address if know at time of contract creation.
359      * fee is in bips so 3.5% would be set as 350 and 100% == 100*100 => 10000
360      */
361     constructor(address[] _admins, uint256 _poolCap, uint256 _beneficiaryCap, address _receiverAddr, uint256 _feePct) public {
362         require(_admins.length > 0, "Must have at least one admin apart from msg.sender");
363         require(_poolCap >= _beneficiaryCap, "Cannot have the poolCap <= beneficiaryCap");
364         require(_feePct >=  0 && _feePct < 10000);
365         feePct = _feePct;
366         receiverAddress = _receiverAddr;
367         totalPoolCap = _poolCap;
368         currentBeneficiaryCap = _beneficiaryCap;
369         // setup privileges
370         owner = msg.sender;
371         addRole(msg.sender, ROLE_ADMIN);
372         for (uint8 i = 0; i < _admins.length; i++) {
373             addRole(_admins[i], ROLE_ADMIN);
374         }
375     }
376 
377     // we pay in here
378     function () payable public {
379         if (contractStage == CONTRACT_OPEN) {
380             emit DepositReceived(msg.sender, msg.value, gasleft(), tx.gasprice, gasLimit);
381             _receiveDeposit();
382         } else {
383             _receiveRefund();
384         }
385     }
386 
387     // receive funds. gas limited. min contrib.
388     function _receiveDeposit() isOpenContract internal {
389         require(tx.gasprice <= gasLimit, "Gas too high");
390         require(address(this).balance <= totalPoolCap, "Deposit will put pool over limit. Reverting.");
391         // Now the code
392         Beneficiary storage b = beneficiaries[msg.sender];
393         uint256 newBalance = b.balance.add(msg.value);
394         require(newBalance >= minContribution, "contribution is lower than minContribution");
395         if(b.cap > 0){
396             require(newBalance <= b.cap, "balance is less than set cap for beneficiary");
397         } else if(currentBeneficiaryCap == 0) {
398             // we have an open cap, no limits
399             b.cap = totalPoolCap;
400         }else {
401             require(newBalance <= currentBeneficiaryCap, "balance is more than currentBeneficiaryCap");
402             // we set it to the default cap
403             b.cap = currentBeneficiaryCap;
404         }
405         b.balance = newBalance;
406         emit BeneficiaryBalanceChanged(msg.sender, newBalance);
407     }
408 
409     // Handle refunds only in closed state.
410     function _receiveRefund() internal {
411         assert(contractStage >= 2);
412         require(hasRole(msg.sender, ROLE_ADMIN) || msg.sender == receiverAddress, "Receiver or Admins only");
413         ethRefundAmount.push(msg.value);
414         emit RefundReceived(msg.sender, msg.value);
415     }
416 
417     function getCurrentBeneficiaryCap() public view returns(uint256 cap) {
418         return currentBeneficiaryCap;
419     }
420 
421     function getPoolDetails() public view returns(uint256 total, uint256 currentBalance, uint256 remaining) {
422         remaining = totalPoolCap.sub(address(this).balance);
423         return (totalPoolCap, address(this).balance, remaining);
424     }
425 
426     // close the pool from receiving more funds
427     function closePool() onlyAdmin isOpenContract public {
428         contractStage = CONTRACT_CLOSED;
429         emit PoolStageChanged(contractStage);
430     }
431 
432     function submitPool(uint256 weiAmount) public onlyAdmin noReentrancy {
433         require(contractStage < CONTRACT_SUBMIT_FUNDS, "Cannot resubmit pool.");
434         require(receiverAddress != 0x00, "receiver address cannot be empty");
435         uint256 contractBalance = address(this).balance;
436         if(weiAmount == 0){
437             weiAmount = contractBalance;
438         }
439         require(minContribution <= weiAmount && weiAmount <= contractBalance, "submitted amount too small or larger than the balance");
440         finalBalance = contractBalance;
441         // transfer to upstream receiverAddress
442         require(receiverAddress.call.value(weiAmount)
443             .gas(gasleft().sub(5000))(),
444             "Error submitting pool to receivingAddress");
445         // get balance post transfer
446         contractBalance = address(this).balance;
447         if(contractBalance > 0) {
448             ethRefundAmount.push(contractBalance);
449         }
450         contractStage = CONTRACT_SUBMIT_FUNDS;
451         emit PoolSubmitted(receiverAddress, weiAmount);
452     }
453 
454     function viewBeneficiaryDetails(address beneficiary) public view returns (uint256 cap, uint256 balance, uint256 remaining, uint256 ethRefund){
455         Beneficiary storage b = beneficiaries[beneficiary];
456         return (b.cap, b.balance, b.cap.sub(b.balance), b.ethRefund);
457     }
458 
459     function withdraw(address _tokenAddress) public {
460         Beneficiary storage b = beneficiaries[msg.sender];
461         require(b.balance > 0, "msg.sender has no balance. Nice Try!");
462         if(contractStage == CONTRACT_OPEN){
463             uint256 transferAmt = b.balance;
464             b.balance = 0;
465             msg.sender.transfer(transferAmt);
466             emit BeneficiaryBalanceChanged(msg.sender, 0);
467         } else {
468             _withdraw(msg.sender, _tokenAddress);
469         }
470     }
471 
472     // This function allows the contract owner to force a withdrawal to any contributor.
473     function withdrawFor (address _beneficiary, address tokenAddr) public onlyAdmin {
474         require (contractStage == CONTRACT_SUBMIT_FUNDS, "Can only be done on Submitted Contract");
475         require (beneficiaries[_beneficiary].balance > 0, "Beneficary has no funds to withdraw");
476         _withdraw(_beneficiary, tokenAddr);
477     }
478 
479     function _withdraw (address _beneficiary, address _tokenAddr) internal {
480         require(contractStage == CONTRACT_SUBMIT_FUNDS, "Cannot withdraw when contract is not CONTRACT_SUBMIT_FUNDS");
481         Beneficiary storage b = beneficiaries[_beneficiary];
482         if (_tokenAddr == 0x00) {
483             _tokenAddr = defaultToken;
484         }
485         TokenAllocation storage ta = tokenAllocationMap[_tokenAddr];
486         require ( (ethRefundAmount.length > b.ethRefund) || ta.pct.length > b.tokensClaimed[_tokenAddr] );
487 
488         if (ethRefundAmount.length > b.ethRefund) {
489             uint256 pct = _toPct(b.balance,finalBalance);
490             uint256 ethAmount = 0;
491             for (uint i= b.ethRefund; i < ethRefundAmount.length; i++) {
492                 ethAmount = ethAmount.add(_applyPct(ethRefundAmount[i],pct));
493             }
494             b.ethRefund = ethRefundAmount.length;
495             if (ethAmount > 0) {
496                 _beneficiary.transfer(ethAmount);
497                 emit EthRefunded(_beneficiary, ethAmount);
498             }
499         }
500         if (ta.pct.length > b.tokensClaimed[_tokenAddr]) {
501             uint tokenAmount = 0;
502             for (i= b.tokensClaimed[_tokenAddr]; i< ta.pct.length; i++) {
503                 tokenAmount = tokenAmount.add(_applyPct(b.balance, ta.pct[i]));
504             }
505             b.tokensClaimed[_tokenAddr] = ta.pct.length;
506             if (tokenAmount > 0) {
507                 require(ta.token.transfer(_beneficiary,tokenAmount));
508                 ta.balanceRemaining = ta.balanceRemaining.sub(tokenAmount);
509                 emit TokenWithdrawal(_beneficiary, _tokenAddr, tokenAmount);
510             }
511         }
512     }
513 
514     function setReceiver(address addr) public onlyAdmin {
515         require (contractStage < CONTRACT_SUBMIT_FUNDS);
516         receiverAddress = addr;
517         emit ReceiverAddressSet(addr);
518     }
519 
520     // once we have tokens we can enable the withdrawal
521     // setting this _useAsDefault to true will set this incoming address to the defaultToken.
522     function enableTokenWithdrawals (address _tokenAddr, bool _useAsDefault) public onlyAdmin noReentrancy {
523         require (contractStage == CONTRACT_SUBMIT_FUNDS, "wrong contract stage");
524         if (_useAsDefault) {
525             defaultToken = _tokenAddr;
526         } else {
527             require (defaultToken != 0x00, "defaultToken must be set");
528         }
529         TokenAllocation storage ta  = tokenAllocationMap[_tokenAddr];
530         if (ta.pct.length==0){
531             ta.token = ERC20(_tokenAddr);
532         }
533         uint256 amount = ta.token.balanceOf(this).sub(ta.balanceRemaining);
534         require (amount > 0);
535         if (feePct > 0) {
536             uint256 feePctFromBips = _toPct(feePct, 10000);
537             uint256 feeAmount = _applyPct(amount, feePctFromBips);
538             require (ta.token.transfer(owner, feeAmount));
539             emit TokenWithdrawal(owner, _tokenAddr, feeAmount);
540         }
541         amount = ta.token.balanceOf(this).sub(ta.balanceRemaining);
542         ta.balanceRemaining = ta.token.balanceOf(this);
543         ta.pct.push(_toPct(amount,finalBalance));
544     }
545 
546     // get the available tokens
547     function checkAvailableTokens (address addr, address tokenAddr) view public returns (uint tokenAmount) {
548         Beneficiary storage b = beneficiaries[addr];
549         TokenAllocation storage ta = tokenAllocationMap[tokenAddr];
550         for (uint i = b.tokensClaimed[tokenAddr]; i < ta.pct.length; i++) {
551             tokenAmount = tokenAmount.add(_applyPct(b.balance, ta.pct[i]));
552         }
553         return tokenAmount;
554     }
555 
556     // This is a standard function required for ERC223 compatibility.
557     function tokenFallback (address from, uint value, bytes data) public {
558         emit ERC223Received (from, value);
559     }
560 
561     // returns a value as a % accurate to 20 decimal points
562     function _toPct (uint numerator, uint denominator ) internal pure returns (uint) {
563         return numerator.mul(10 ** 20) / denominator;
564     }
565 
566     // returns % of any number, where % given was generated with toPct
567     function _applyPct (uint numerator, uint pct) internal pure returns (uint) {
568         return numerator.mul(pct) / (10 ** 20);
569     }
570 
571 
572 }