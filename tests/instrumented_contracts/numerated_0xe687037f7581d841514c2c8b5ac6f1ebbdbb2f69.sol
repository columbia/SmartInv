1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/utils/Context.sol
82 
83 
84 pragma solidity >=0.6.0 <0.8.0;
85 
86 /*
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with GSN meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address payable) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes memory) {
102         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
103         return msg.data;
104     }
105 }
106 
107 // File: @openzeppelin/contracts/access/Ownable.sol
108 
109 
110 pragma solidity >=0.6.0 <0.8.0;
111 
112 /**
113  * @dev Contract module which provides a basic access control mechanism, where
114  * there is an account (an owner) that can be granted exclusive access to
115  * specific functions.
116  *
117  * By default, the owner account will be the one that deploys the contract. This
118  * can later be changed with {transferOwnership}.
119  *
120  * This module is used through inheritance. It will make available the modifier
121  * `onlyOwner`, which can be applied to your functions to restrict their use to
122  * the owner.
123  */
124 abstract contract Ownable is Context {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132     constructor () internal {
133         address msgSender = _msgSender();
134         _owner = msgSender;
135         emit OwnershipTransferred(address(0), msgSender);
136     }
137 
138     /**
139      * @dev Returns the address of the current owner.
140      */
141     function owner() public view virtual returns (address) {
142         return _owner;
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         require(owner() == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     /**
154      * @dev Leaves the contract without owner. It will not be possible to call
155      * `onlyOwner` functions anymore. Can only be called by the current owner.
156      *
157      * NOTE: Renouncing ownership will leave the contract without an owner,
158      * thereby removing any functionality that is only available to the owner.
159      */
160     function renounceOwnership() public virtual onlyOwner {
161         emit OwnershipTransferred(_owner, address(0));
162         _owner = address(0);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Can only be called by the current owner.
168      */
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         emit OwnershipTransferred(_owner, newOwner);
172         _owner = newOwner;
173     }
174 }
175 
176 // File: @openzeppelin/contracts/math/SafeMath.sol
177 
178 
179 pragma solidity >=0.6.0 <0.8.0;
180 
181 /**
182  * @dev Wrappers over Solidity's arithmetic operations with added overflow
183  * checks.
184  *
185  * Arithmetic operations in Solidity wrap on overflow. This can easily result
186  * in bugs, because programmers usually assume that an overflow raises an
187  * error, which is the standard behavior in high level programming languages.
188  * `SafeMath` restores this intuition by reverting the transaction when an
189  * operation overflows.
190  *
191  * Using this library instead of the unchecked operations eliminates an entire
192  * class of bugs, so it's recommended to use it always.
193  */
194 library SafeMath {
195     /**
196      * @dev Returns the addition of two unsigned integers, with an overflow flag.
197      *
198      * _Available since v3.4._
199      */
200     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
201         uint256 c = a + b;
202         if (c < a) return (false, 0);
203         return (true, c);
204     }
205 
206     /**
207      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
208      *
209      * _Available since v3.4._
210      */
211     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
212         if (b > a) return (false, 0);
213         return (true, a - b);
214     }
215 
216     /**
217      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
218      *
219      * _Available since v3.4._
220      */
221     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
222         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
223         // benefit is lost if 'b' is also tested.
224         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
225         if (a == 0) return (true, 0);
226         uint256 c = a * b;
227         if (c / a != b) return (false, 0);
228         return (true, c);
229     }
230 
231     /**
232      * @dev Returns the division of two unsigned integers, with a division by zero flag.
233      *
234      * _Available since v3.4._
235      */
236     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         if (b == 0) return (false, 0);
238         return (true, a / b);
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
243      *
244      * _Available since v3.4._
245      */
246     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
247         if (b == 0) return (false, 0);
248         return (true, a % b);
249     }
250 
251     /**
252      * @dev Returns the addition of two unsigned integers, reverting on
253      * overflow.
254      *
255      * Counterpart to Solidity's `+` operator.
256      *
257      * Requirements:
258      *
259      * - Addition cannot overflow.
260      */
261     function add(uint256 a, uint256 b) internal pure returns (uint256) {
262         uint256 c = a + b;
263         require(c >= a, "SafeMath: addition overflow");
264         return c;
265     }
266 
267     /**
268      * @dev Returns the subtraction of two unsigned integers, reverting on
269      * overflow (when the result is negative).
270      *
271      * Counterpart to Solidity's `-` operator.
272      *
273      * Requirements:
274      *
275      * - Subtraction cannot overflow.
276      */
277     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
278         require(b <= a, "SafeMath: subtraction overflow");
279         return a - b;
280     }
281 
282     /**
283      * @dev Returns the multiplication of two unsigned integers, reverting on
284      * overflow.
285      *
286      * Counterpart to Solidity's `*` operator.
287      *
288      * Requirements:
289      *
290      * - Multiplication cannot overflow.
291      */
292     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
293         if (a == 0) return 0;
294         uint256 c = a * b;
295         require(c / a == b, "SafeMath: multiplication overflow");
296         return c;
297     }
298 
299     /**
300      * @dev Returns the integer division of two unsigned integers, reverting on
301      * division by zero. The result is rounded towards zero.
302      *
303      * Counterpart to Solidity's `/` operator. Note: this function uses a
304      * `revert` opcode (which leaves remaining gas untouched) while Solidity
305      * uses an invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function div(uint256 a, uint256 b) internal pure returns (uint256) {
312         require(b > 0, "SafeMath: division by zero");
313         return a / b;
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * reverting when dividing by zero.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      *
326      * - The divisor cannot be zero.
327      */
328     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
329         require(b > 0, "SafeMath: modulo by zero");
330         return a % b;
331     }
332 
333     /**
334      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
335      * overflow (when the result is negative).
336      *
337      * CAUTION: This function is deprecated because it requires allocating memory for the error
338      * message unnecessarily. For custom revert reasons use {trySub}.
339      *
340      * Counterpart to Solidity's `-` operator.
341      *
342      * Requirements:
343      *
344      * - Subtraction cannot overflow.
345      */
346     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
347         require(b <= a, errorMessage);
348         return a - b;
349     }
350 
351     /**
352      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
353      * division by zero. The result is rounded towards zero.
354      *
355      * CAUTION: This function is deprecated because it requires allocating memory for the error
356      * message unnecessarily. For custom revert reasons use {tryDiv}.
357      *
358      * Counterpart to Solidity's `/` operator. Note: this function uses a
359      * `revert` opcode (which leaves remaining gas untouched) while Solidity
360      * uses an invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      *
364      * - The divisor cannot be zero.
365      */
366     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
367         require(b > 0, errorMessage);
368         return a / b;
369     }
370 
371     /**
372      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
373      * reverting with custom message when dividing by zero.
374      *
375      * CAUTION: This function is deprecated because it requires allocating memory for the error
376      * message unnecessarily. For custom revert reasons use {tryMod}.
377      *
378      * Counterpart to Solidity's `%` operator. This function uses a `revert`
379      * opcode (which leaves remaining gas untouched) while Solidity uses an
380      * invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
387         require(b > 0, errorMessage);
388         return a % b;
389     }
390 }
391 
392 // File: @openzeppelin/contracts/utils/Address.sol
393 
394 
395 pragma solidity >=0.6.2 <0.8.0;
396 
397 /**
398  * @dev Collection of functions related to the address type
399  */
400 library Address {
401     /**
402      * @dev Returns true if `account` is a contract.
403      *
404      * [IMPORTANT]
405      * ====
406      * It is unsafe to assume that an address for which this function returns
407      * false is an externally-owned account (EOA) and not a contract.
408      *
409      * Among others, `isContract` will return false for the following
410      * types of addresses:
411      *
412      *  - an externally-owned account
413      *  - a contract in construction
414      *  - an address where a contract will be created
415      *  - an address where a contract lived, but was destroyed
416      * ====
417      */
418     function isContract(address account) internal view returns (bool) {
419         // This method relies on extcodesize, which returns 0 for contracts in
420         // construction, since the code is only stored at the end of the
421         // constructor execution.
422 
423         uint256 size;
424         // solhint-disable-next-line no-inline-assembly
425         assembly { size := extcodesize(account) }
426         return size > 0;
427     }
428 
429     /**
430      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
431      * `recipient`, forwarding all available gas and reverting on errors.
432      *
433      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
434      * of certain opcodes, possibly making contracts go over the 2300 gas limit
435      * imposed by `transfer`, making them unable to receive funds via
436      * `transfer`. {sendValue} removes this limitation.
437      *
438      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
439      *
440      * IMPORTANT: because control is transferred to `recipient`, care must be
441      * taken to not create reentrancy vulnerabilities. Consider using
442      * {ReentrancyGuard} or the
443      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
444      */
445     function sendValue(address payable recipient, uint256 amount) internal {
446         require(address(this).balance >= amount, "Address: insufficient balance");
447 
448         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
449         (bool success, ) = recipient.call{ value: amount }("");
450         require(success, "Address: unable to send value, recipient may have reverted");
451     }
452 
453     /**
454      * @dev Performs a Solidity function call using a low level `call`. A
455      * plain`call` is an unsafe replacement for a function call: use this
456      * function instead.
457      *
458      * If `target` reverts with a revert reason, it is bubbled up by this
459      * function (like regular Solidity function calls).
460      *
461      * Returns the raw returned data. To convert to the expected return value,
462      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
463      *
464      * Requirements:
465      *
466      * - `target` must be a contract.
467      * - calling `target` with `data` must not revert.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
472       return functionCall(target, data, "Address: low-level call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
477      * `errorMessage` as a fallback revert reason when `target` reverts.
478      *
479      * _Available since v3.1._
480      */
481     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
482         return functionCallWithValue(target, data, 0, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but also transferring `value` wei to `target`.
488      *
489      * Requirements:
490      *
491      * - the calling contract must have an ETH balance of at least `value`.
492      * - the called Solidity function must be `payable`.
493      *
494      * _Available since v3.1._
495      */
496     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
497         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
502      * with `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
507         require(address(this).balance >= value, "Address: insufficient balance for call");
508         require(isContract(target), "Address: call to non-contract");
509 
510         // solhint-disable-next-line avoid-low-level-calls
511         (bool success, bytes memory returndata) = target.call{ value: value }(data);
512         return _verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but performing a static call.
518      *
519      * _Available since v3.3._
520      */
521     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
522         return functionStaticCall(target, data, "Address: low-level static call failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
532         require(isContract(target), "Address: static call to non-contract");
533 
534         // solhint-disable-next-line avoid-low-level-calls
535         (bool success, bytes memory returndata) = target.staticcall(data);
536         return _verifyCallResult(success, returndata, errorMessage);
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
541      * but performing a delegate call.
542      *
543      * _Available since v3.4._
544      */
545     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
546         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
551      * but performing a delegate call.
552      *
553      * _Available since v3.4._
554      */
555     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
556         require(isContract(target), "Address: delegate call to non-contract");
557 
558         // solhint-disable-next-line avoid-low-level-calls
559         (bool success, bytes memory returndata) = target.delegatecall(data);
560         return _verifyCallResult(success, returndata, errorMessage);
561     }
562 
563     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
564         if (success) {
565             return returndata;
566         } else {
567             // Look for revert reason and bubble it up if present
568             if (returndata.length > 0) {
569                 // The easiest way to bubble the revert reason is using memory via assembly
570 
571                 // solhint-disable-next-line no-inline-assembly
572                 assembly {
573                     let returndata_size := mload(returndata)
574                     revert(add(32, returndata), returndata_size)
575                 }
576             } else {
577                 revert(errorMessage);
578             }
579         }
580     }
581 }
582 
583 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
584 
585 
586 pragma solidity >=0.6.0 <0.8.0;
587 
588 
589 
590 
591 /**
592  * @title SafeERC20
593  * @dev Wrappers around ERC20 operations that throw on failure (when the token
594  * contract returns false). Tokens that return no value (and instead revert or
595  * throw on failure) are also supported, non-reverting calls are assumed to be
596  * successful.
597  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
598  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
599  */
600 library SafeERC20 {
601     using SafeMath for uint256;
602     using Address for address;
603 
604     function safeTransfer(IERC20 token, address to, uint256 value) internal {
605         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
606     }
607 
608     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
609         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
610     }
611 
612     /**
613      * @dev Deprecated. This function has issues similar to the ones found in
614      * {IERC20-approve}, and its usage is discouraged.
615      *
616      * Whenever possible, use {safeIncreaseAllowance} and
617      * {safeDecreaseAllowance} instead.
618      */
619     function safeApprove(IERC20 token, address spender, uint256 value) internal {
620         // safeApprove should only be called when setting an initial allowance,
621         // or when resetting it to zero. To increase and decrease it, use
622         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
623         // solhint-disable-next-line max-line-length
624         require((value == 0) || (token.allowance(address(this), spender) == 0),
625             "SafeERC20: approve from non-zero to non-zero allowance"
626         );
627         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
628     }
629 
630     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
631         uint256 newAllowance = token.allowance(address(this), spender).add(value);
632         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
633     }
634 
635     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
636         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
637         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
638     }
639 
640     /**
641      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
642      * on the return value: the return value is optional (but if data is returned, it must not be false).
643      * @param token The token targeted by the call.
644      * @param data The call data (encoded using abi.encode or one of its variants).
645      */
646     function _callOptionalReturn(IERC20 token, bytes memory data) private {
647         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
648         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
649         // the target address contains contract code and also asserts for success in the low-level call.
650 
651         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
652         if (returndata.length > 0) { // Return data is optional
653             // solhint-disable-next-line max-line-length
654             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
655         }
656     }
657 }
658 
659 // File: contracts/BDPDistributor.sol
660 
661 
662 pragma solidity ^0.6.12;
663 
664 
665 
666 
667 
668 contract BDPDistributor is Ownable {
669   using SafeERC20 for IERC20;
670   using SafeMath for uint256;
671 
672   address public token;
673   address public signer;
674 
675   uint256 public totalClaimed;
676 
677   mapping(address => bool) public isClaimed;
678   event Claimed(address account, uint256 amount);
679 
680   constructor(address _token, address _signer) public {
681     token = _token;
682     signer = _signer;
683   }
684 
685   function setSigner(address _signer) public onlyOwner {
686     signer = _signer;
687   }
688 
689   function claim(
690     address account,
691     uint256 amount,
692     uint8 v,
693     bytes32 r,
694     bytes32 s
695   ) external {
696     require(msg.sender == account, "BDPDistributor: wrong sender");
697     require(!isClaimed[account], "BDPDistributor: Already claimed");
698     require(verifyProof(account, amount, v, r, s), "BDPDistributor: Invalid signer");  
699 
700     totalClaimed = totalClaimed + amount;
701     isClaimed[account] = true;
702     IERC20(token).safeTransfer(account, amount);
703 
704     emit Claimed(account, amount);
705   }
706 
707   function verifyProof(
708     address account,
709     uint256 amount,
710     uint8 v,
711     bytes32 r,
712     bytes32 s
713   ) public view returns (bool) {
714     bytes32 digest = keccak256(abi.encodePacked(account, amount));
715     address signatory = ecrecover(digest, v, r, s);
716     return signatory == signer;
717   }
718 
719   function withdraw(address _token) external onlyOwner {
720     if (_token == address(0)) {
721       payable(owner()).transfer(address(this).balance);
722     } else {
723       uint256 balance = IERC20(_token).balanceOf(address(this));
724       IERC20(_token).safeTransfer(owner(), balance);
725     }
726   }
727 }