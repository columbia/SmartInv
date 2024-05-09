1 // SPDX-License-Identifier:  AGPL-3.0-or-later // hevm: flattened sources of contracts/MplRewards.sol
2 pragma solidity =0.6.11 >=0.6.0 <0.8.0 >=0.6.2 <0.8.0;
3 
4 ////// contracts/interfaces/IERC2258.sol
5 /* pragma solidity 0.6.11; */
6 
7 interface IERC2258 {
8 
9     // Increase the custody limit of a custodian either directly or via signed authorization
10     function increaseCustodyAllowance(address custodian, uint256 amount) external;
11 
12     // Query individual custody limit and total custody limit across all custodians
13     function custodyAllowance(address account, address custodian) external view returns (uint256);
14     function totalCustodyAllowance(address account) external view returns (uint256);
15 
16     // Allows a custodian to exercise their right to transfer custodied tokens
17     function transferByCustodian(address account, address receiver, uint256 amount) external;
18 
19     // Custody Events
20     event CustodyTransfer(address custodian, address from, address to, uint256 amount);
21     event CustodyAllowanceChanged(address account, address custodian, uint256 oldAllowance, uint256 newAllowance);
22 
23 }
24 
25 ////// lib/openzeppelin-contracts/contracts/GSN/Context.sol
26 /* pragma solidity >=0.6.0 <0.8.0; */
27 
28 /*
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with GSN meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address payable) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes memory) {
44         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
45         return msg.data;
46     }
47 }
48 
49 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
50 /* pragma solidity >=0.6.0 <0.8.0; */
51 
52 /* import "../GSN/Context.sol"; */
53 /**
54  * @dev Contract module which provides a basic access control mechanism, where
55  * there is an account (an owner) that can be granted exclusive access to
56  * specific functions.
57  *
58  * By default, the owner account will be the one that deploys the contract. This
59  * can later be changed with {transferOwnership}.
60  *
61  * This module is used through inheritance. It will make available the modifier
62  * `onlyOwner`, which can be applied to your functions to restrict their use to
63  * the owner.
64  */
65 abstract contract Ownable is Context {
66     address private _owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev Initializes the contract setting the deployer as the initial owner.
72      */
73     constructor () internal {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     /**
95      * @dev Leaves the contract without owner. It will not be possible to call
96      * `onlyOwner` functions anymore. Can only be called by the current owner.
97      *
98      * NOTE: Renouncing ownership will leave the contract without an owner,
99      * thereby removing any functionality that is only available to the owner.
100      */
101     function renounceOwnership() public virtual onlyOwner {
102         emit OwnershipTransferred(_owner, address(0));
103         _owner = address(0);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Can only be called by the current owner.
109      */
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         emit OwnershipTransferred(_owner, newOwner);
113         _owner = newOwner;
114     }
115 }
116 
117 ////// lib/openzeppelin-contracts/contracts/math/Math.sol
118 /* pragma solidity >=0.6.0 <0.8.0; */
119 
120 /**
121  * @dev Standard math utilities missing in the Solidity language.
122  */
123 library Math {
124     /**
125      * @dev Returns the largest of two numbers.
126      */
127     function max(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a >= b ? a : b;
129     }
130 
131     /**
132      * @dev Returns the smallest of two numbers.
133      */
134     function min(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a < b ? a : b;
136     }
137 
138     /**
139      * @dev Returns the average of two numbers. The result is rounded towards
140      * zero.
141      */
142     function average(uint256 a, uint256 b) internal pure returns (uint256) {
143         // (a + b) / 2 can overflow, so we distribute
144         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
145     }
146 }
147 
148 ////// lib/openzeppelin-contracts/contracts/math/SafeMath.sol
149 /* pragma solidity >=0.6.0 <0.8.0; */
150 
151 /**
152  * @dev Wrappers over Solidity's arithmetic operations with added overflow
153  * checks.
154  *
155  * Arithmetic operations in Solidity wrap on overflow. This can easily result
156  * in bugs, because programmers usually assume that an overflow raises an
157  * error, which is the standard behavior in high level programming languages.
158  * `SafeMath` restores this intuition by reverting the transaction when an
159  * operation overflows.
160  *
161  * Using this library instead of the unchecked operations eliminates an entire
162  * class of bugs, so it's recommended to use it always.
163  */
164 library SafeMath {
165     /**
166      * @dev Returns the addition of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `+` operator.
170      *
171      * Requirements:
172      *
173      * - Addition cannot overflow.
174      */
175     function add(uint256 a, uint256 b) internal pure returns (uint256) {
176         uint256 c = a + b;
177         require(c >= a, "SafeMath: addition overflow");
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the subtraction of two unsigned integers, reverting on
184      * overflow (when the result is negative).
185      *
186      * Counterpart to Solidity's `-` operator.
187      *
188      * Requirements:
189      *
190      * - Subtraction cannot overflow.
191      */
192     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
193         return sub(a, b, "SafeMath: subtraction overflow");
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
198      * overflow (when the result is negative).
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      *
204      * - Subtraction cannot overflow.
205      */
206     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b <= a, errorMessage);
208         uint256 c = a - b;
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the multiplication of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `*` operator.
218      *
219      * Requirements:
220      *
221      * - Multiplication cannot overflow.
222      */
223     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
225         // benefit is lost if 'b' is also tested.
226         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
227         if (a == 0) {
228             return 0;
229         }
230 
231         uint256 c = a * b;
232         require(c / a == b, "SafeMath: multiplication overflow");
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers. Reverts on
239      * division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator. Note: this function uses a
242      * `revert` opcode (which leaves remaining gas untouched) while Solidity
243      * uses an invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function div(uint256 a, uint256 b) internal pure returns (uint256) {
250         return div(a, b, "SafeMath: division by zero");
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
255      * division by zero. The result is rounded towards zero.
256      *
257      * Counterpart to Solidity's `/` operator. Note: this function uses a
258      * `revert` opcode (which leaves remaining gas untouched) while Solidity
259      * uses an invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b > 0, errorMessage);
267         uint256 c = a / b;
268         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
269 
270         return c;
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275      * Reverts when dividing by zero.
276      *
277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
278      * opcode (which leaves remaining gas untouched) while Solidity uses an
279      * invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
286         return mod(a, b, "SafeMath: modulo by zero");
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * Reverts with custom message when dividing by zero.
292      *
293      * Counterpart to Solidity's `%` operator. This function uses a `revert`
294      * opcode (which leaves remaining gas untouched) while Solidity uses an
295      * invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b != 0, errorMessage);
303         return a % b;
304     }
305 }
306 
307 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
308 /* pragma solidity >=0.6.0 <0.8.0; */
309 
310 /**
311  * @dev Interface of the ERC20 standard as defined in the EIP.
312  */
313 interface IERC20 {
314     /**
315      * @dev Returns the amount of tokens in existence.
316      */
317     function totalSupply() external view returns (uint256);
318 
319     /**
320      * @dev Returns the amount of tokens owned by `account`.
321      */
322     function balanceOf(address account) external view returns (uint256);
323 
324     /**
325      * @dev Moves `amount` tokens from the caller's account to `recipient`.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transfer(address recipient, uint256 amount) external returns (bool);
332 
333     /**
334      * @dev Returns the remaining number of tokens that `spender` will be
335      * allowed to spend on behalf of `owner` through {transferFrom}. This is
336      * zero by default.
337      *
338      * This value changes when {approve} or {transferFrom} are called.
339      */
340     function allowance(address owner, address spender) external view returns (uint256);
341 
342     /**
343      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * IMPORTANT: Beware that changing an allowance with this method brings the risk
348      * that someone may use both the old and the new allowance by unfortunate
349      * transaction ordering. One possible solution to mitigate this race
350      * condition is to first reduce the spender's allowance to 0 and set the
351      * desired value afterwards:
352      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
353      *
354      * Emits an {Approval} event.
355      */
356     function approve(address spender, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Moves `amount` tokens from `sender` to `recipient` using the
360      * allowance mechanism. `amount` is then deducted from the caller's
361      * allowance.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
368 
369     /**
370      * @dev Emitted when `value` tokens are moved from one account (`from`) to
371      * another (`to`).
372      *
373      * Note that `value` may be zero.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 value);
376 
377     /**
378      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
379      * a call to {approve}. `value` is the new allowance.
380      */
381     event Approval(address indexed owner, address indexed spender, uint256 value);
382 }
383 
384 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
385 /* pragma solidity >=0.6.2 <0.8.0; */
386 
387 /**
388  * @dev Collection of functions related to the address type
389  */
390 library Address {
391     /**
392      * @dev Returns true if `account` is a contract.
393      *
394      * [IMPORTANT]
395      * ====
396      * It is unsafe to assume that an address for which this function returns
397      * false is an externally-owned account (EOA) and not a contract.
398      *
399      * Among others, `isContract` will return false for the following
400      * types of addresses:
401      *
402      *  - an externally-owned account
403      *  - a contract in construction
404      *  - an address where a contract will be created
405      *  - an address where a contract lived, but was destroyed
406      * ====
407      */
408     function isContract(address account) internal view returns (bool) {
409         // This method relies on extcodesize, which returns 0 for contracts in
410         // construction, since the code is only stored at the end of the
411         // constructor execution.
412 
413         uint256 size;
414         // solhint-disable-next-line no-inline-assembly
415         assembly { size := extcodesize(account) }
416         return size > 0;
417     }
418 
419     /**
420      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
421      * `recipient`, forwarding all available gas and reverting on errors.
422      *
423      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
424      * of certain opcodes, possibly making contracts go over the 2300 gas limit
425      * imposed by `transfer`, making them unable to receive funds via
426      * `transfer`. {sendValue} removes this limitation.
427      *
428      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
429      *
430      * IMPORTANT: because control is transferred to `recipient`, care must be
431      * taken to not create reentrancy vulnerabilities. Consider using
432      * {ReentrancyGuard} or the
433      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
434      */
435     function sendValue(address payable recipient, uint256 amount) internal {
436         require(address(this).balance >= amount, "Address: insufficient balance");
437 
438         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
439         (bool success, ) = recipient.call{ value: amount }("");
440         require(success, "Address: unable to send value, recipient may have reverted");
441     }
442 
443     /**
444      * @dev Performs a Solidity function call using a low level `call`. A
445      * plain`call` is an unsafe replacement for a function call: use this
446      * function instead.
447      *
448      * If `target` reverts with a revert reason, it is bubbled up by this
449      * function (like regular Solidity function calls).
450      *
451      * Returns the raw returned data. To convert to the expected return value,
452      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
453      *
454      * Requirements:
455      *
456      * - `target` must be a contract.
457      * - calling `target` with `data` must not revert.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
462       return functionCall(target, data, "Address: low-level call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
467      * `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
472         return functionCallWithValue(target, data, 0, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but also transferring `value` wei to `target`.
478      *
479      * Requirements:
480      *
481      * - the calling contract must have an ETH balance of at least `value`.
482      * - the called Solidity function must be `payable`.
483      *
484      * _Available since v3.1._
485      */
486     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
492      * with `errorMessage` as a fallback revert reason when `target` reverts.
493      *
494      * _Available since v3.1._
495      */
496     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
497         require(address(this).balance >= value, "Address: insufficient balance for call");
498         require(isContract(target), "Address: call to non-contract");
499 
500         // solhint-disable-next-line avoid-low-level-calls
501         (bool success, bytes memory returndata) = target.call{ value: value }(data);
502         return _verifyCallResult(success, returndata, errorMessage);
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
507      * but performing a static call.
508      *
509      * _Available since v3.3._
510      */
511     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
512         return functionStaticCall(target, data, "Address: low-level static call failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
517      * but performing a static call.
518      *
519      * _Available since v3.3._
520      */
521     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
522         require(isContract(target), "Address: static call to non-contract");
523 
524         // solhint-disable-next-line avoid-low-level-calls
525         (bool success, bytes memory returndata) = target.staticcall(data);
526         return _verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
530         if (success) {
531             return returndata;
532         } else {
533             // Look for revert reason and bubble it up if present
534             if (returndata.length > 0) {
535                 // The easiest way to bubble the revert reason is using memory via assembly
536 
537                 // solhint-disable-next-line no-inline-assembly
538                 assembly {
539                     let returndata_size := mload(returndata)
540                     revert(add(32, returndata), returndata_size)
541                 }
542             } else {
543                 revert(errorMessage);
544             }
545         }
546     }
547 }
548 
549 ////// lib/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol
550 /* pragma solidity >=0.6.0 <0.8.0; */
551 
552 /* import "./IERC20.sol"; */
553 /* import "../../math/SafeMath.sol"; */
554 /* import "../../utils/Address.sol"; */
555 
556 /**
557  * @title SafeERC20
558  * @dev Wrappers around ERC20 operations that throw on failure (when the token
559  * contract returns false). Tokens that return no value (and instead revert or
560  * throw on failure) are also supported, non-reverting calls are assumed to be
561  * successful.
562  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
563  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
564  */
565 library SafeERC20 {
566     using SafeMath for uint256;
567     using Address for address;
568 
569     function safeTransfer(IERC20 token, address to, uint256 value) internal {
570         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
571     }
572 
573     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
574         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
575     }
576 
577     /**
578      * @dev Deprecated. This function has issues similar to the ones found in
579      * {IERC20-approve}, and its usage is discouraged.
580      *
581      * Whenever possible, use {safeIncreaseAllowance} and
582      * {safeDecreaseAllowance} instead.
583      */
584     function safeApprove(IERC20 token, address spender, uint256 value) internal {
585         // safeApprove should only be called when setting an initial allowance,
586         // or when resetting it to zero. To increase and decrease it, use
587         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
588         // solhint-disable-next-line max-line-length
589         require((value == 0) || (token.allowance(address(this), spender) == 0),
590             "SafeERC20: approve from non-zero to non-zero allowance"
591         );
592         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
593     }
594 
595     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
596         uint256 newAllowance = token.allowance(address(this), spender).add(value);
597         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
598     }
599 
600     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
601         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
602         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
603     }
604 
605     /**
606      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
607      * on the return value: the return value is optional (but if data is returned, it must not be false).
608      * @param token The token targeted by the call.
609      * @param data The call data (encoded using abi.encode or one of its variants).
610      */
611     function _callOptionalReturn(IERC20 token, bytes memory data) private {
612         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
613         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
614         // the target address contains contract code and also asserts for success in the low-level call.
615 
616         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
617         if (returndata.length > 0) { // Return data is optional
618             // solhint-disable-next-line max-line-length
619             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
620         }
621     }
622 }
623 
624 ////// contracts/MplRewards.sol
625 /* pragma solidity 0.6.11; */
626 
627 /* import "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
628 /* import "lib/openzeppelin-contracts/contracts/math/Math.sol"; */
629 /* import "lib/openzeppelin-contracts/contracts/math/SafeMath.sol"; */
630 /* import "lib/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol"; */
631 
632 /* import "./interfaces/IERC2258.sol"; */
633 
634 // https://docs.synthetix.io/contracts/source/contracts/stakingrewards
635 /// @title MplRewards Synthetix farming contract fork for liquidity mining.
636 contract MplRewards is Ownable {
637 
638     using SafeMath  for uint256;
639     using SafeERC20 for IERC20;
640 
641     IERC20    public immutable rewardsToken;
642     IERC2258  public immutable stakingToken;
643 
644     uint256 public periodFinish;
645     uint256 public rewardRate;
646     uint256 public rewardsDuration;
647     uint256 public lastUpdateTime;
648     uint256 public rewardPerTokenStored;
649     uint256 public lastPauseTime;
650     bool    public paused;
651 
652     mapping(address => uint256) public userRewardPerTokenPaid;
653     mapping(address => uint256) public rewards;
654 
655     uint256 private _totalSupply;
656 
657     mapping(address => uint256) private _balances;
658 
659     event            RewardAdded(uint256 reward);
660     event                 Staked(address indexed account, uint256 amount);
661     event              Withdrawn(address indexed account, uint256 amount);
662     event             RewardPaid(address indexed account, uint256 reward);
663     event RewardsDurationUpdated(uint256 newDuration);
664     event              Recovered(address token, uint256 amount);
665     event           PauseChanged(bool isPaused);
666 
667     constructor(address _rewardsToken, address _stakingToken, address _owner) public {
668         rewardsToken    = IERC20(_rewardsToken);
669         stakingToken    = IERC2258(_stakingToken);
670         rewardsDuration = 7 days;
671         transferOwnership(_owner);
672     }
673 
674     function _updateReward(address account) internal {
675         uint256 _rewardPerTokenStored = rewardPerToken();
676         rewardPerTokenStored          = _rewardPerTokenStored;
677         lastUpdateTime                = lastTimeRewardApplicable();
678 
679         if (account != address(0)) {
680             rewards[account] = earned(account);
681             userRewardPerTokenPaid[account] = _rewardPerTokenStored;
682         }
683     }
684 
685     function _notPaused() internal view {
686         require(!paused, "R:PAUSED");
687     }
688 
689     function totalSupply() external view returns (uint256) {
690         return _totalSupply;
691     }
692 
693     function balanceOf(address account) external view returns (uint256) {
694         return _balances[account];
695     }
696 
697     function lastTimeRewardApplicable() public view returns (uint256) {
698         return Math.min(block.timestamp, periodFinish);
699     }
700 
701     function rewardPerToken() public view returns (uint256) {
702         return _totalSupply == 0
703             ? rewardPerTokenStored
704             : rewardPerTokenStored.add(
705                   lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
706               );
707     }
708 
709     function earned(address account) public view returns (uint256) {
710         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
711     }
712 
713     function getRewardForDuration() external view returns (uint256) {
714         return rewardRate.mul(rewardsDuration);
715     }
716 
717     /**
718         @dev It emits a `Staked` event.
719     */
720     function stake(uint256 amount) external {
721         _notPaused();
722         _updateReward(msg.sender);
723         uint256 newBalance = _balances[msg.sender].add(amount);
724         require(amount > 0, "R:ZERO_STAKE");
725         require(stakingToken.custodyAllowance(msg.sender, address(this)) >= newBalance, "R:INSUF_CUST_ALLOWANCE");
726         _totalSupply          = _totalSupply.add(amount);
727         _balances[msg.sender] = newBalance;
728         emit Staked(msg.sender, amount);
729     }
730 
731     /**
732         @dev It emits a `Withdrawn` event.
733     */
734     function withdraw(uint256 amount) public {
735         _notPaused();
736         _updateReward(msg.sender);
737         require(amount > 0, "R:ZERO_WITHDRAW");
738         _totalSupply = _totalSupply.sub(amount);
739         _balances[msg.sender] = _balances[msg.sender].sub(amount);
740         stakingToken.transferByCustodian(msg.sender, msg.sender, amount);
741         emit Withdrawn(msg.sender, amount);
742     }
743 
744     /**
745         @dev It emits a `RewardPaid` event if any rewards are received.
746     */
747     function getReward() public {
748         _notPaused();
749         _updateReward(msg.sender);
750         uint256 reward = rewards[msg.sender];
751 
752         if (reward == uint256(0)) return;
753 
754         rewards[msg.sender] = uint256(0);
755         rewardsToken.safeTransfer(msg.sender, reward);
756         emit RewardPaid(msg.sender, reward);
757     }
758 
759     function exit() external {
760         withdraw(_balances[msg.sender]);
761         getReward();
762     }
763 
764     /**
765         @dev Only the contract Owner may call this.
766         @dev It emits a `RewardAdded` event.
767     */
768     function notifyRewardAmount(uint256 reward) external onlyOwner {
769         _updateReward(address(0));
770 
771         uint256 _rewardRate = block.timestamp >= periodFinish
772             ? reward.div(rewardsDuration)
773             : reward.add(
774                   periodFinish.sub(block.timestamp).mul(rewardRate)
775               ).div(rewardsDuration);
776 
777         rewardRate = _rewardRate;
778 
779         // Ensure the provided reward amount is not more than the balance in the contract.
780         // This keeps the reward rate in the right range, preventing overflows due to
781         // very high values of rewardRate in the earned and rewardsPerToken functions;
782         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
783         uint256 balance = rewardsToken.balanceOf(address(this));
784         require(_rewardRate <= balance.div(rewardsDuration), "R:REWARD_TOO_HIGH");
785 
786         lastUpdateTime = block.timestamp;
787         periodFinish   = block.timestamp.add(rewardsDuration);
788         emit RewardAdded(reward);
789     }
790 
791     /**
792         @dev End rewards emission earlier. Only the contract Owner may call this.
793     */
794     function updatePeriodFinish(uint256 timestamp) external onlyOwner {
795         _updateReward(address(0));
796         periodFinish = timestamp;
797     }
798 
799     /**
800         @dev Added to support recovering tokens unintentionally sent to this contract.
801              Only the contract Owner may call this.
802         @dev It emits a `Recovered` event.
803     */
804     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
805         IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
806         emit Recovered(tokenAddress, tokenAmount);
807     }
808 
809     /**
810         @dev Only the contract Owner may call this.
811         @dev It emits a `RewardsDurationUpdated` event.
812     */
813     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
814         require(block.timestamp > periodFinish, "R:PERIOD_NOT_FINISHED");
815         rewardsDuration = _rewardsDuration;
816         emit RewardsDurationUpdated(rewardsDuration);
817     }
818 
819     /**
820         @dev Change the paused state of the contract. Only the contract Owner may call this.
821         @dev It emits a `PauseChanged` event.
822     */
823     function setPaused(bool _paused) external onlyOwner {
824         // Ensure we're actually changing the state before we do anything
825         require(_paused != paused, "R:ALREADY_SET");
826 
827         // Set our paused state.
828         paused = _paused;
829 
830         // If applicable, set the last pause time.
831         if (_paused) lastPauseTime = block.timestamp;
832 
833         // Let everyone know that our pause state has changed.
834         emit PauseChanged(paused);
835     }
836 
837 }
