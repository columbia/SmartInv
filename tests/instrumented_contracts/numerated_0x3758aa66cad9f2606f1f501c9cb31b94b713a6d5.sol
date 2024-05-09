1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-09
3 */
4 
5 pragma solidity ^0.5.5;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following 
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
30         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
31         // for accounts without code, i.e. `keccak256('')`
32         bytes32 codehash;
33         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { codehash := extcodehash(account) }
36         return (codehash != accountHash && codehash != 0x0);
37     }
38 
39     /**
40      * @dev Converts an `address` into `address payable`. Note that this is
41      * simply a type cast: the actual underlying value is not changed.
42      *
43      * _Available since v2.4.0._
44      */
45     function toPayable(address account) internal pure returns (address payable) {
46         return address(uint160(account));
47     }
48 
49     /**
50      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
51      * `recipient`, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by `transfer`, making them unable to receive funds via
56      * `transfer`. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to `recipient`, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      *
65      * _Available since v2.4.0._
66      */
67     function sendValue(address payable recipient, uint256 amount) internal {
68         require(address(this).balance >= amount, "Address: insufficient balance");
69 
70         // solhint-disable-next-line avoid-call-value
71         (bool success, ) = recipient.call.value(amount)("");
72         require(success, "Address: unable to send value, recipient may have reverted");
73     }
74 }
75 /**
76  * @dev Wrappers over Solidity's arithmetic operations with added overflow
77  * checks.
78  *
79  * Arithmetic operations in Solidity wrap on overflow. This can easily result
80  * in bugs, because programmers usually assume that an overflow raises an
81  * error, which is the standard behavior in high level programming languages.
82  * `SafeMath` restores this intuition by reverting the transaction when an
83  * operation overflows.
84  *
85  * Using this library instead of the unchecked operations eliminates an entire
86  * class of bugs, so it's recommended to use it always.
87  */
88 library SafeMath {
89     /**
90      * @dev Returns the addition of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `+` operator.
94      *
95      * Requirements:
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      * - Subtraction cannot overflow.
113      */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      * - Subtraction cannot overflow.
126      *
127      * _Available since v2.4.0._
128      */
129     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b <= a, errorMessage);
131         uint256 c = a - b;
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the multiplication of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `*` operator.
141      *
142      * Requirements:
143      * - Multiplication cannot overflow.
144      */
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147         // benefit is lost if 'b' is also tested.
148         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
149         if (a == 0) {
150             return 0;
151         }
152 
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         return div(a, b, "SafeMath: division by zero");
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      * - The divisor cannot be zero.
184      *
185      * _Available since v2.4.0._
186      */
187     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         // Solidity only automatically asserts when dividing by 0
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      * - The divisor cannot be zero.
206      */
207     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208         return mod(a, b, "SafeMath: modulo by zero");
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts with custom message when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      * - The divisor cannot be zero.
221      *
222      * _Available since v2.4.0._
223      */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 /**
230  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
231  * the optional functions; to access them see {ERC20Detailed}.
232  */
233 interface IERC20 {
234     /**
235      * @dev Returns the amount of tokens in existence.
236      */
237     function totalSupply() external view returns (uint256);
238 
239     /**
240      * @dev Returns the amount of tokens owned by `account`.
241      */
242     function balanceOf(address account) external view returns (uint256);
243 
244     /**
245      * @dev Moves `amount` tokens from the caller's account to `recipient`.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * Emits a {Transfer} event.
250      */
251     function transfer(address recipient, uint256 amount) external returns (bool);
252 
253     /**
254      * @dev Returns the remaining number of tokens that `spender` will be
255      * allowed to spend on behalf of `owner` through {transferFrom}. This is
256      * zero by default.
257      *
258      * This value changes when {approve} or {transferFrom} are called.
259      */
260     function allowance(address owner, address spender) external view returns (uint256);
261 
262     /**
263      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
264      *
265      * Returns a boolean value indicating whether the operation succeeded.
266      *
267      * IMPORTANT: Beware that changing an allowance with this method brings the risk
268      * that someone may use both the old and the new allowance by unfortunate
269      * transaction ordering. One possible solution to mitigate this race
270      * condition is to first reduce the spender's allowance to 0 and set the
271      * desired value afterwards:
272      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273      *
274      * Emits an {Approval} event.
275      */
276     function approve(address spender, uint256 amount) external returns (bool);
277 
278     /**
279      * @dev Moves `amount` tokens from `sender` to `recipient` using the
280      * allowance mechanism. `amount` is then deducted from the caller's
281      * allowance.
282      *
283      * Returns a boolean value indicating whether the operation succeeded.
284      *
285      * Emits a {Transfer} event.
286      */
287     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
288 
289     /**
290      * @dev Emitted when `value` tokens are moved from one account (`from`) to
291      * another (`to`).
292      *
293      * Note that `value` may be zero.
294      */
295     event Transfer(address indexed from, address indexed to, uint256 value);
296 
297     /**
298      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
299      * a call to {approve}. `value` is the new allowance.
300      */
301     event Approval(address indexed owner, address indexed spender, uint256 value);
302 }
303 
304 /**
305  * @title SafeERC20
306  * @dev Wrappers around ERC20 operations that throw on failure (when the token
307  * contract returns false). Tokens that return no value (and instead revert or
308  * throw on failure) are also supported, non-reverting calls are assumed to be
309  * successful.
310  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
311  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
312  */
313 library SafeERC20 {
314     using SafeMath for uint256;
315     using Address for address;
316 
317     function safeTransfer(IERC20 token, address to, uint256 value) internal {
318         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
319     }
320 
321     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
322         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
323     }
324 
325     function safeApprove(IERC20 token, address spender, uint256 value) internal {
326         // safeApprove should only be called when setting an initial allowance,
327         // or when resetting it to zero. To increase and decrease it, use
328         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
329         // solhint-disable-next-line max-line-length
330         require((value == 0) || (token.allowance(address(this), spender) == 0),
331             "SafeERC20: approve from non-zero to non-zero allowance"
332         );
333         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
334     }
335 
336     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
337         uint256 newAllowance = token.allowance(address(this), spender).add(value);
338         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
339     }
340 
341     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
342         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
343         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
344     }
345 
346     /**
347      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
348      * on the return value: the return value is optional (but if data is returned, it must not be false).
349      * @param token The token targeted by the call.
350      * @param data The call data (encoded using abi.encode or one of its variants).
351      */
352     function callOptionalReturn(IERC20 token, bytes memory data) private {
353         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
354         // we're implementing it ourselves.
355 
356         // A Solidity high level call has three parts:
357         //  1. The target address is checked to verify it contains contract code
358         //  2. The call itself is made, and success asserted
359         //  3. The return value is decoded, which in turn checks the size of the returned data.
360         // solhint-disable-next-line max-line-length
361         require(address(token).isContract(), "SafeERC20: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = address(token).call(data);
365         require(success, "SafeERC20: low-level call failed");
366 
367         if (returndata.length > 0) { // Return data is optional
368             // solhint-disable-next-line max-line-length
369             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
370         }
371     }
372 }
373 
374 contract MultiSigWallet {
375     using Address for address;
376     using SafeERC20 for IERC20;
377     using SafeMath for uint256;
378 
379     modifier isOwner{
380         require(owner == msg.sender, "Only owner can execute it");
381         _;
382     }
383     modifier isManager{
384         require(managers[msg.sender] == 1, "Only manager can execute it");
385         _;
386     }
387     // 用于提现
388     struct TxWithdraw {
389         uint8 e;
390         address payable to;
391         uint256 amount;
392         bool isERC20;
393         address ERC20;
394         Signature signature;
395     }
396     // 用于管理员变更
397     struct TxManagerChange {
398         uint8 e;
399         address[] adds;
400         address[] removes;
401         Signature signature;
402     }
403     // 用于合约升级
404     struct TxUpgrade {
405         uint8 e;
406         Signature signature;
407     }
408     struct Signature {
409         uint8 signatureCount;
410         address[] signed;
411         mapping(address => uint8) signatures;
412     }
413     struct Validator {
414         uint8 e;
415         mapping(address => uint8) addsMap;
416         mapping(address => uint8) removesMap;
417     }
418     bool public upgrade = false;
419     // 最大管理员数量
420     uint public max_managers = 15;
421     // 最小签名比例 66%
422     uint public rate = 66;
423     // 比例分母
424     uint constant DENOMINATOR = 100;
425     string constant UPDATE_SEED_MANAGERS = "updateSeedManagers";
426     // 当前提现交易的最小签名数量
427     uint8 public current_withdraw_min_signatures;
428     address public owner;
429     mapping(address => uint8) private seedManagers;
430     address[] public seedManagerArray;
431     mapping(address => uint8) private managers;
432     address[] private managerArray;
433     mapping(string => TxWithdraw) private pendingTxWithdraws;
434     mapping(string => TxManagerChange) private pendingTxManagerChanges;
435     mapping(string => TxUpgrade) private pendingTxUpgrade;
436     uint public pendingChangeCount = 0;
437     mapping(string => uint8) private completedTxs;
438     mapping(string => Validator) private validatorManager;
439 
440     constructor(address[] memory _managers) public{
441         require(_managers.length <= max_managers, "Exceeded the maximum number of managers");
442         owner = msg.sender;
443         managerArray = _managers;
444         for (uint8 i = 0; i < managerArray.length; i++) {
445             managers[managerArray[i]] = 1;
446             seedManagers[managerArray[i]] = 1;
447             seedManagerArray.push(managerArray[i]);
448         }
449         require(managers[owner] == 0, "Contract creator cannot act as manager");
450         // 设置当前提现交易的最小签名数量
451         current_withdraw_min_signatures = calMinSignatures(managerArray.length);
452     }
453     function() external payable {
454         emit DepositFunds(msg.sender, msg.value);
455     }
456     function createOrSignWithdraw(string memory txKey, address payable to, uint256 amount, bool isERC20, address ERC20) public isManager {
457         require(to != address(0), "Withdraw: transfer to the zero address");
458         require(amount > 0, "Withdrawal amount must be greater than 0");
459         // 校验已经完成的交易
460         require(completedTxs[txKey] == 0, "Transaction has been completed");
461         // 若交易已创建，则签名交易
462         if (pendingTxWithdraws[txKey].e != 0) {
463             signTx(txKey);
464             return;
465         }
466         if (isERC20) {
467             validateTransferERC20(ERC20, to, amount);
468         } else {
469             require(address(this).balance >= amount, "This contract address does not have sufficient balance of ether");
470         }
471         TxWithdraw memory tx1;
472         pendingTxWithdraws[txKey] = tx1;
473         TxWithdraw storage _tx = pendingTxWithdraws[txKey];
474         _tx.e = 1;
475         _tx.to = to;
476         _tx.amount = amount;
477         _tx.isERC20 = isERC20;
478         _tx.ERC20 = ERC20;
479         _tx.signature.signatureCount = 1;
480         _tx.signature.signed.push(msg.sender);
481         _tx.signature.signatures[msg.sender] = 1;
482     }
483     function signTx(string memory txKey) internal {
484         TxWithdraw storage tx1 = pendingTxWithdraws[txKey];
485         bool canWithdraw = isCompleteSign(tx1.signature, current_withdraw_min_signatures, 0);
486         if (canWithdraw) {
487             address[] memory signers = getSigners(tx1.signature);
488             if (tx1.isERC20) {
489                 transferERC20(tx1.ERC20, tx1.to, tx1.amount);
490             } else {
491                 // 实际到账
492                 uint transferAmount = tx1.amount;
493                 require(address(this).balance >= transferAmount, "This contract address does not have sufficient balance of ether");
494                 tx1.to.transfer(transferAmount);
495                 emit TransferFunds(tx1.to, transferAmount);
496             }
497             emit TxWithdrawCompleted(signers, txKey);
498             // 移除暂存数据
499             deletePendingTx(txKey, tx1.e, 1);
500         }
501     }
502     function createOrSignManagerChange(string memory txKey, address[] memory adds, address[] memory removes, uint8 count) public isManager {
503         require(adds.length > 0 || removes.length > 0, "There are no managers joining or exiting");
504         // 校验已经完成的交易
505         require(completedTxs[txKey] == 0, "Transaction has been completed");
506         // 若交易已创建，则签名交易
507         if (pendingTxManagerChanges[txKey].e != 0) {
508             signTxManagerChange(txKey);
509             return;
510         }
511         preValidateAddsAndRemoves(txKey, adds, removes, false);
512         TxManagerChange memory tx1;
513         pendingTxManagerChanges[txKey] = tx1;
514         TxManagerChange storage _tx = pendingTxManagerChanges[txKey];
515         if (count == 0) {
516             count = 1;
517         }
518         _tx.e = count;
519         _tx.adds = adds;
520         _tx.removes = removes;
521         _tx.signature.signed.push(msg.sender);
522         _tx.signature.signatures[msg.sender] = 1;
523         _tx.signature.signatureCount = 1;
524         pendingChangeCount++;
525     }
526     function signTxManagerChange(string memory txKey) internal {
527         TxManagerChange storage tx1 = pendingTxManagerChanges[txKey];
528         address[] memory removes = tx1.removes;
529         uint removeLengh = removes.length;
530         if(removeLengh > 0) {
531             for (uint i = 0; i < removeLengh; i++) {
532                 if (removes[i] == msg.sender) {
533                     revert("Exiting manager cannot participate in manager change transactions");
534                 }
535             }
536         }
537         bool canChange = isCompleteSign(tx1.signature, 0, removeLengh);
538         if (canChange) {
539             // 变更管理员
540             removeManager(tx1.removes, false);
541             addManager(tx1.adds, false);
542             // 更新当前提现交易的最小签名数
543             current_withdraw_min_signatures = calMinSignatures(managerArray.length);
544             pendingChangeCount--;
545             address[] memory signers = getSigners(tx1.signature);
546             // add managerChange event
547             emit TxManagerChangeCompleted(signers, txKey);
548             // 移除暂存数据
549             deletePendingTx(txKey, tx1.e, 2);
550         }
551     }
552     function createOrSignUpgrade(string memory txKey) public isManager {
553         // 校验已经完成的交易
554         require(completedTxs[txKey] == 0, "Transaction has been completed");
555         // 若交易已创建，则签名交易
556         if (pendingTxUpgrade[txKey].e != 0) {
557             signTxUpgrade(txKey);
558             return;
559         }
560         TxUpgrade memory tx1;
561         pendingTxUpgrade[txKey] = tx1;
562         TxUpgrade storage _tx = pendingTxUpgrade[txKey];
563         _tx.e = 1;
564         _tx.signature.signed.push(msg.sender);
565         _tx.signature.signatures[msg.sender] = 1;
566         _tx.signature.signatureCount = 1;
567     }
568     function signTxUpgrade(string memory txKey) internal {
569         TxUpgrade storage tx1 = pendingTxUpgrade[txKey];
570         bool canUpgrade= isCompleteSign(tx1.signature, current_withdraw_min_signatures, 0);
571         if (canUpgrade) {
572             // 变更可升级
573             upgrade = true;
574             address[] memory signers = getSigners(tx1.signature);
575             // add managerChange event
576             emit TxUpgradeCompleted(signers, txKey);
577             // 移除暂存数据
578             deletePendingTx(txKey, tx1.e, 3);
579         }
580     }
581     function isCompleteSign(Signature storage signature, uint8 min_signatures, uint removeLengh) internal returns (bool){
582         bool complete = false;
583         // 计算当前有效签名
584         signature.signatureCount = calValidSignatureCount(signature);
585         if (min_signatures == 0) {
586             min_signatures = calMinSignatures(managerArray.length - removeLengh);
587         }
588         if (signature.signatureCount >= min_signatures) {
589             complete = true;
590         }
591         if (!complete) {
592             require(signature.signatures[msg.sender] == 0, "Duplicate signature");
593             signature.signed.push(msg.sender);
594             signature.signatures[msg.sender] = 1;
595             signature.signatureCount++;
596             if (signature.signatureCount >= min_signatures) {
597                 complete = true;
598             }
599         }
600         return complete;
601     }
602     function calValidSignatureCount(Signature storage signature) internal returns (uint8){
603         // 遍历已签名列表，筛选有效签名数量
604         uint8 count = 0;
605         uint len = signature.signed.length;
606         for (uint i = 0; i < len; i++) {
607             if (managers[signature.signed[i]] > 0) {
608                 count++;
609             } else {
610                 delete signature.signatures[signature.signed[i]];
611             }
612         }
613         return count;
614     }
615     function getSigners(Signature storage signature) internal returns (address[] memory){
616         address[] memory signers = new address[](signature.signatureCount);
617         // 遍历管理员列表，筛选已签名数组
618         uint len = managerArray.length;
619         uint k = 0;
620         for (uint i = 0; i < len; i++) {
621             if (signature.signatures[managerArray[i]] > 0) {
622                 signers[k++] = managerArray[i];
623                 delete signature.signatures[managerArray[i]];
624             }
625         }
626         return signers;
627     }
628     function preValidateAddsAndRemoves(string memory txKey, address[] memory adds, address[] memory removes, bool _isOwner) internal {
629         Validator memory _validator;
630         validatorManager[txKey] = _validator;
631         // 校验adds
632         mapping(address => uint8) storage validateAdds = validatorManager[txKey].addsMap;
633         uint addLen = adds.length;
634         for (uint i = 0; i < addLen; i++) {
635             address add = adds[i];
636             require(managers[add] == 0, "The address list that is being added already exists as a manager");
637             require(validateAdds[add] == 0, "Duplicate parameters for the address to join");
638             validateAdds[add] = 1;
639         }
640         require(validateAdds[owner] == 0, "Contract creator cannot act as manager");
641         // 校验removes
642         mapping(address => uint8) storage validateRemoves = validatorManager[txKey].removesMap;
643         uint removeLen = removes.length;
644         for (uint i = 0; i < removeLen; i++) {
645             address remove = removes[i];
646             require(_isOwner || seedManagers[remove] == 0, "Can't exit seed manager");
647             require(!_isOwner || seedManagers[remove] == 1, "Can only exit the seed manager");
648             require(managers[remove] == 1, "There are addresses in the exiting address list that are not manager");
649             require(validateRemoves[remove] == 0, "Duplicate parameters for the address to exit");
650             validateRemoves[remove] = 1;
651         }
652         require(validateRemoves[msg.sender] == 0, "Exiting manager cannot participate in manager change transactions");
653         require(managerArray.length + addLen - removeLen <= max_managers, "Exceeded the maximum number of managers");
654         clearValidatorManager(txKey, adds, removes);
655     }
656     function clearValidatorManager(string memory txKey, address[] memory adds, address[] memory removes) internal {
657         uint addLen = adds.length;
658         if(addLen > 0) {
659             mapping(address => uint8) storage validateAdds = validatorManager[txKey].addsMap;
660             for (uint i = 0; i < addLen; i++) {
661                 delete validateAdds[adds[i]];
662             }
663         }
664         uint removeLen = removes.length;
665         if(removeLen > 0) {
666             mapping(address => uint8) storage validateRemoves = validatorManager[txKey].removesMap;
667             for (uint i = 0; i < removeLen; i++) {
668                 delete validateRemoves[removes[i]];
669             }
670         }
671         delete validatorManager[txKey];
672     }
673     function updateSeedManagers(address[] memory adds, address[] memory removes) public isOwner {
674         require(adds.length > 0 || removes.length > 0, "There are no managers joining or exiting");
675         preValidateAddsAndRemoves(UPDATE_SEED_MANAGERS, adds, removes, true);
676         // 变更管理员
677         removeManager(removes, true);
678         addManager(adds, true);
679         // 更新当前提现交易的最小签名数
680         current_withdraw_min_signatures = calMinSignatures(managerArray.length);
681         // add managerChange event
682         emit TxManagerChangeCompleted(new address[](0), UPDATE_SEED_MANAGERS);
683     }
684     function updateMaxManagers(uint _max_managers) public isOwner {
685         max_managers = _max_managers;
686     }
687     /*
688      根据 `当前有效管理员数量` 和 `最小签名比例` 计算最小签名数量，向上取整
689     */
690     function calMinSignatures(uint managerCounts) internal view returns (uint8) {
691         if (managerCounts == 0) {
692             return 0;
693         }
694         uint numerator = rate * managerCounts + DENOMINATOR - 1;
695         return uint8(numerator / DENOMINATOR);
696     }
697     function removeManager(address[] memory removes, bool _isSeed) internal {
698         if (removes.length == 0) {
699             return;
700         }
701         for (uint i = 0; i < removes.length; i++) {
702             address remove = removes[i];
703             managers[remove] = 0;
704             if (_isSeed) {
705                 seedManagers[remove] = 0;
706             }
707         }
708         uint newLength = managerArray.length - removes.length;
709         address[] memory tempManagers = new address[](newLength);
710         // 遍历修改前管理员列表
711         uint k = 0;
712         for (uint i = 0; i < managerArray.length; i++) {
713             if (managers[managerArray[i]] == 1) {
714                 tempManagers[k++] = managerArray[i];
715             }
716         }
717         delete managerArray;
718         managerArray = tempManagers;
719         if (_isSeed) {
720             uint _newLength = seedManagerArray.length - removes.length;
721             address[] memory _tempManagers = new address[](_newLength);
722             // 遍历修改前管理员列表
723             uint t = 0;
724             for (uint i = 0; i < seedManagerArray.length; i++) {
725                 if (seedManagers[seedManagerArray[i]] == 1) {
726                     _tempManagers[t++] = seedManagerArray[i];
727                 }
728             }
729             delete seedManagerArray;
730             seedManagerArray = _tempManagers;
731         }
732     }
733     function addManager(address[] memory adds, bool _isSeed) internal {
734         if (adds.length == 0) {
735             return;
736         }
737         for (uint i = 0; i < adds.length; i++) {
738             address add = adds[i];
739             if(managers[add] == 0) {
740                 managers[add] = 1;
741                 managerArray.push(add);
742             }
743             if (_isSeed && seedManagers[add] == 0) {
744                 seedManagers[add] = 1;
745                 seedManagerArray.push(add);
746             }
747         }
748     }
749     function deletePendingTx(string memory txKey, uint8 e, uint types) internal {
750         completedTxs[txKey] = e;
751         if (types == 1) {
752             delete pendingTxWithdraws[txKey];
753         } else if (types == 3) {
754             delete pendingTxUpgrade[txKey];
755         }
756     }
757     function validateTransferERC20(address ERC20, address to, uint256 amount) internal view {
758         require(to != address(0), "ERC20: transfer to the zero address");
759         require(address(this) != ERC20, "Do nothing by yourself");
760         require(ERC20.isContract(), "the address is not a contract address");
761         IERC20 token = IERC20(ERC20);
762         uint256 balance = token.balanceOf(address(this));
763         require(balance >= amount, "No enough balance");
764     }
765     function transferERC20(address ERC20, address to, uint256 amount) internal {
766         IERC20 token = IERC20(ERC20);
767         uint256 balance = token.balanceOf(address(this));
768         require(balance >= amount, "No enough balance");
769         token.safeTransfer(to, amount);
770     }
771     function upgradeContractS1() public isOwner {
772         require(upgrade, "Denied");
773         address(uint160(owner)).transfer(address(this).balance);
774     }
775     function upgradeContractS2(address ERC20, address to, uint256 amount) public isOwner {
776         require(upgrade, "Denied");
777         validateTransferERC20(ERC20, to, amount);
778         transferERC20(ERC20, to, amount);
779     }
780     function isCompletedTx(string memory txKey) public view returns (bool){
781         return completedTxs[txKey] > 0;
782     }
783     function pendingWithdrawTx(string memory txKey) public view returns (address to, uint256 amount, bool isERC20, address ERC20, uint8 signatureCount) {
784         TxWithdraw storage tx1 = pendingTxWithdraws[txKey];
785         return (tx1.to, tx1.amount, tx1.isERC20, tx1.ERC20, tx1.signature.signatureCount);
786     }
787     function pendingManagerChangeTx(string memory txKey) public view returns (uint8 txCount, string memory key, address[] memory adds, address[] memory removes, uint8 signatureCount) {
788         TxManagerChange storage tx1 = pendingTxManagerChanges[txKey];
789         return (tx1.e, txKey, tx1.adds, tx1.removes, tx1.signature.signatureCount);
790     }
791     function ifManager(address _manager) public view returns (bool) {
792         return managers[_manager] == 1;
793     }
794     function allManagers() public view returns (address[] memory) {
795         return managerArray;
796     }
797     event DepositFunds(address from, uint amount);
798     event TransferFunds( address to, uint amount );
799     event TxWithdrawCompleted( address[] signers, string txKey );
800     event TxManagerChangeCompleted( address[] signers, string txKey );
801     event TxUpgradeCompleted( address[] signers, string txKey );
802 }