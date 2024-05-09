1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
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
107 
108 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * By default, the owner account will be the one that deploys the contract. This
116  * can later be changed with {transferOwnership}.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be applied to your functions to restrict their use to
120  * the owner.
121  */
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor () internal {
131         address msgSender = _msgSender();
132         _owner = msgSender;
133         emit OwnershipTransferred(address(0), msgSender);
134     }
135 
136     /**
137      * @dev Returns the address of the current owner.
138      */
139     function owner() public view virtual returns (address) {
140         return _owner;
141     }
142 
143     /**
144      * @dev Throws if called by any account other than the owner.
145      */
146     modifier onlyOwner() {
147         require(owner() == _msgSender(), "Ownable: caller is not the owner");
148         _;
149     }
150 
151     /**
152      * @dev Leaves the contract without owner. It will not be possible to call
153      * `onlyOwner` functions anymore. Can only be called by the current owner.
154      *
155      * NOTE: Renouncing ownership will leave the contract without an owner,
156      * thereby removing any functionality that is only available to the owner.
157      */
158     function renounceOwnership() public virtual onlyOwner {
159         emit OwnershipTransferred(_owner, address(0));
160         _owner = address(0);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Can only be called by the current owner.
166      */
167     function transferOwnership(address newOwner) public virtual onlyOwner {
168         require(newOwner != address(0), "Ownable: new owner is the zero address");
169         emit OwnershipTransferred(_owner, newOwner);
170         _owner = newOwner;
171     }
172 }
173 
174 
175 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.1
176 
177 /**
178  * @dev Contract module that helps prevent reentrant calls to a function.
179  *
180  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
181  * available, which can be applied to functions to make sure there are no nested
182  * (reentrant) calls to them.
183  *
184  * Note that because there is a single `nonReentrant` guard, functions marked as
185  * `nonReentrant` may not call one another. This can be worked around by making
186  * those functions `private`, and then adding `external` `nonReentrant` entry
187  * points to them.
188  *
189  * TIP: If you would like to learn more about reentrancy and alternative ways
190  * to protect against it, check out our blog post
191  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
192  */
193 abstract contract ReentrancyGuard {
194     // Booleans are more expensive than uint256 or any type that takes up a full
195     // word because each write operation emits an extra SLOAD to first read the
196     // slot's contents, replace the bits taken up by the boolean, and then write
197     // back. This is the compiler's defense against contract upgrades and
198     // pointer aliasing, and it cannot be disabled.
199 
200     // The values being non-zero value makes deployment a bit more expensive,
201     // but in exchange the refund on every call to nonReentrant will be lower in
202     // amount. Since refunds are capped to a percentage of the total
203     // transaction's gas, it is best to keep them low in cases like this one, to
204     // increase the likelihood of the full refund coming into effect.
205     uint256 private constant _NOT_ENTERED = 1;
206     uint256 private constant _ENTERED = 2;
207 
208     uint256 private _status;
209 
210     constructor () internal {
211         _status = _NOT_ENTERED;
212     }
213 
214     /**
215      * @dev Prevents a contract from calling itself, directly or indirectly.
216      * Calling a `nonReentrant` function from another `nonReentrant`
217      * function is not supported. It is possible to prevent this from happening
218      * by making the `nonReentrant` function external, and make it call a
219      * `private` function that does the actual work.
220      */
221     modifier nonReentrant() {
222         // On the first call to nonReentrant, _notEntered will be true
223         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
224 
225         // Any calls to nonReentrant after this point will fail
226         _status = _ENTERED;
227 
228         _;
229 
230         // By storing the original value once again, a refund is triggered (see
231         // https://eips.ethereum.org/EIPS/eip-2200)
232         _status = _NOT_ENTERED;
233     }
234 }
235 
236 
237 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
238 
239 /**
240  * @dev Wrappers over Solidity's arithmetic operations with added overflow
241  * checks.
242  *
243  * Arithmetic operations in Solidity wrap on overflow. This can easily result
244  * in bugs, because programmers usually assume that an overflow raises an
245  * error, which is the standard behavior in high level programming languages.
246  * `SafeMath` restores this intuition by reverting the transaction when an
247  * operation overflows.
248  *
249  * Using this library instead of the unchecked operations eliminates an entire
250  * class of bugs, so it's recommended to use it always.
251  */
252 library SafeMath {
253     /**
254      * @dev Returns the addition of two unsigned integers, with an overflow flag.
255      *
256      * _Available since v3.4._
257      */
258     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
259         uint256 c = a + b;
260         if (c < a) return (false, 0);
261         return (true, c);
262     }
263 
264     /**
265      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
266      *
267      * _Available since v3.4._
268      */
269     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
270         if (b > a) return (false, 0);
271         return (true, a - b);
272     }
273 
274     /**
275      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
276      *
277      * _Available since v3.4._
278      */
279     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
280         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
281         // benefit is lost if 'b' is also tested.
282         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
283         if (a == 0) return (true, 0);
284         uint256 c = a * b;
285         if (c / a != b) return (false, 0);
286         return (true, c);
287     }
288 
289     /**
290      * @dev Returns the division of two unsigned integers, with a division by zero flag.
291      *
292      * _Available since v3.4._
293      */
294     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
295         if (b == 0) return (false, 0);
296         return (true, a / b);
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
301      *
302      * _Available since v3.4._
303      */
304     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
305         if (b == 0) return (false, 0);
306         return (true, a % b);
307     }
308 
309     /**
310      * @dev Returns the addition of two unsigned integers, reverting on
311      * overflow.
312      *
313      * Counterpart to Solidity's `+` operator.
314      *
315      * Requirements:
316      *
317      * - Addition cannot overflow.
318      */
319     function add(uint256 a, uint256 b) internal pure returns (uint256) {
320         uint256 c = a + b;
321         require(c >= a, "SafeMath: addition overflow");
322         return c;
323     }
324 
325     /**
326      * @dev Returns the subtraction of two unsigned integers, reverting on
327      * overflow (when the result is negative).
328      *
329      * Counterpart to Solidity's `-` operator.
330      *
331      * Requirements:
332      *
333      * - Subtraction cannot overflow.
334      */
335     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
336         require(b <= a, "SafeMath: subtraction overflow");
337         return a - b;
338     }
339 
340     /**
341      * @dev Returns the multiplication of two unsigned integers, reverting on
342      * overflow.
343      *
344      * Counterpart to Solidity's `*` operator.
345      *
346      * Requirements:
347      *
348      * - Multiplication cannot overflow.
349      */
350     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
351         if (a == 0) return 0;
352         uint256 c = a * b;
353         require(c / a == b, "SafeMath: multiplication overflow");
354         return c;
355     }
356 
357     /**
358      * @dev Returns the integer division of two unsigned integers, reverting on
359      * division by zero. The result is rounded towards zero.
360      *
361      * Counterpart to Solidity's `/` operator. Note: this function uses a
362      * `revert` opcode (which leaves remaining gas untouched) while Solidity
363      * uses an invalid opcode to revert (consuming all remaining gas).
364      *
365      * Requirements:
366      *
367      * - The divisor cannot be zero.
368      */
369     function div(uint256 a, uint256 b) internal pure returns (uint256) {
370         require(b > 0, "SafeMath: division by zero");
371         return a / b;
372     }
373 
374     /**
375      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
376      * reverting when dividing by zero.
377      *
378      * Counterpart to Solidity's `%` operator. This function uses a `revert`
379      * opcode (which leaves remaining gas untouched) while Solidity uses an
380      * invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
387         require(b > 0, "SafeMath: modulo by zero");
388         return a % b;
389     }
390 
391     /**
392      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
393      * overflow (when the result is negative).
394      *
395      * CAUTION: This function is deprecated because it requires allocating memory for the error
396      * message unnecessarily. For custom revert reasons use {trySub}.
397      *
398      * Counterpart to Solidity's `-` operator.
399      *
400      * Requirements:
401      *
402      * - Subtraction cannot overflow.
403      */
404     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
405         require(b <= a, errorMessage);
406         return a - b;
407     }
408 
409     /**
410      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
411      * division by zero. The result is rounded towards zero.
412      *
413      * CAUTION: This function is deprecated because it requires allocating memory for the error
414      * message unnecessarily. For custom revert reasons use {tryDiv}.
415      *
416      * Counterpart to Solidity's `/` operator. Note: this function uses a
417      * `revert` opcode (which leaves remaining gas untouched) while Solidity
418      * uses an invalid opcode to revert (consuming all remaining gas).
419      *
420      * Requirements:
421      *
422      * - The divisor cannot be zero.
423      */
424     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
425         require(b > 0, errorMessage);
426         return a / b;
427     }
428 
429     /**
430      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
431      * reverting with custom message when dividing by zero.
432      *
433      * CAUTION: This function is deprecated because it requires allocating memory for the error
434      * message unnecessarily. For custom revert reasons use {tryMod}.
435      *
436      * Counterpart to Solidity's `%` operator. This function uses a `revert`
437      * opcode (which leaves remaining gas untouched) while Solidity uses an
438      * invalid opcode to revert (consuming all remaining gas).
439      *
440      * Requirements:
441      *
442      * - The divisor cannot be zero.
443      */
444     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
445         require(b > 0, errorMessage);
446         return a % b;
447     }
448 }
449 
450 
451 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
452 
453 /**
454  * @dev Collection of functions related to the address type
455  */
456 library Address {
457     /**
458      * @dev Returns true if `account` is a contract.
459      *
460      * [IMPORTANT]
461      * ====
462      * It is unsafe to assume that an address for which this function returns
463      * false is an externally-owned account (EOA) and not a contract.
464      *
465      * Among others, `isContract` will return false for the following
466      * types of addresses:
467      *
468      *  - an externally-owned account
469      *  - a contract in construction
470      *  - an address where a contract will be created
471      *  - an address where a contract lived, but was destroyed
472      * ====
473      */
474     function isContract(address account) internal view returns (bool) {
475         // This method relies on extcodesize, which returns 0 for contracts in
476         // construction, since the code is only stored at the end of the
477         // constructor execution.
478 
479         uint256 size;
480         // solhint-disable-next-line no-inline-assembly
481         assembly { size := extcodesize(account) }
482         return size > 0;
483     }
484 
485     /**
486      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
487      * `recipient`, forwarding all available gas and reverting on errors.
488      *
489      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
490      * of certain opcodes, possibly making contracts go over the 2300 gas limit
491      * imposed by `transfer`, making them unable to receive funds via
492      * `transfer`. {sendValue} removes this limitation.
493      *
494      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
495      *
496      * IMPORTANT: because control is transferred to `recipient`, care must be
497      * taken to not create reentrancy vulnerabilities. Consider using
498      * {ReentrancyGuard} or the
499      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
500      */
501     function sendValue(address payable recipient, uint256 amount) internal {
502         require(address(this).balance >= amount, "Address: insufficient balance");
503 
504         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
505         (bool success, ) = recipient.call{ value: amount }("");
506         require(success, "Address: unable to send value, recipient may have reverted");
507     }
508 
509     /**
510      * @dev Performs a Solidity function call using a low level `call`. A
511      * plain`call` is an unsafe replacement for a function call: use this
512      * function instead.
513      *
514      * If `target` reverts with a revert reason, it is bubbled up by this
515      * function (like regular Solidity function calls).
516      *
517      * Returns the raw returned data. To convert to the expected return value,
518      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
519      *
520      * Requirements:
521      *
522      * - `target` must be a contract.
523      * - calling `target` with `data` must not revert.
524      *
525      * _Available since v3.1._
526      */
527     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
528       return functionCall(target, data, "Address: low-level call failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
533      * `errorMessage` as a fallback revert reason when `target` reverts.
534      *
535      * _Available since v3.1._
536      */
537     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
538         return functionCallWithValue(target, data, 0, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but also transferring `value` wei to `target`.
544      *
545      * Requirements:
546      *
547      * - the calling contract must have an ETH balance of at least `value`.
548      * - the called Solidity function must be `payable`.
549      *
550      * _Available since v3.1._
551      */
552     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
553         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
558      * with `errorMessage` as a fallback revert reason when `target` reverts.
559      *
560      * _Available since v3.1._
561      */
562     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
563         require(address(this).balance >= value, "Address: insufficient balance for call");
564         require(isContract(target), "Address: call to non-contract");
565 
566         // solhint-disable-next-line avoid-low-level-calls
567         (bool success, bytes memory returndata) = target.call{ value: value }(data);
568         return _verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
573      * but performing a static call.
574      *
575      * _Available since v3.3._
576      */
577     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
578         return functionStaticCall(target, data, "Address: low-level static call failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
588         require(isContract(target), "Address: static call to non-contract");
589 
590         // solhint-disable-next-line avoid-low-level-calls
591         (bool success, bytes memory returndata) = target.staticcall(data);
592         return _verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but performing a delegate call.
598      *
599      * _Available since v3.4._
600      */
601     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
602         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
607      * but performing a delegate call.
608      *
609      * _Available since v3.4._
610      */
611     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
612         require(isContract(target), "Address: delegate call to non-contract");
613 
614         // solhint-disable-next-line avoid-low-level-calls
615         (bool success, bytes memory returndata) = target.delegatecall(data);
616         return _verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
620         if (success) {
621             return returndata;
622         } else {
623             // Look for revert reason and bubble it up if present
624             if (returndata.length > 0) {
625                 // The easiest way to bubble the revert reason is using memory via assembly
626 
627                 // solhint-disable-next-line no-inline-assembly
628                 assembly {
629                     let returndata_size := mload(returndata)
630                     revert(add(32, returndata), returndata_size)
631                 }
632             } else {
633                 revert(errorMessage);
634             }
635         }
636     }
637 }
638 
639 
640 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
641 
642 
643 
644 /**
645  * @title SafeERC20
646  * @dev Wrappers around ERC20 operations that throw on failure (when the token
647  * contract returns false). Tokens that return no value (and instead revert or
648  * throw on failure) are also supported, non-reverting calls are assumed to be
649  * successful.
650  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
651  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
652  */
653 library SafeERC20 {
654     using SafeMath for uint256;
655     using Address for address;
656 
657     function safeTransfer(IERC20 token, address to, uint256 value) internal {
658         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
659     }
660 
661     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
662         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
663     }
664 
665     /**
666      * @dev Deprecated. This function has issues similar to the ones found in
667      * {IERC20-approve}, and its usage is discouraged.
668      *
669      * Whenever possible, use {safeIncreaseAllowance} and
670      * {safeDecreaseAllowance} instead.
671      */
672     function safeApprove(IERC20 token, address spender, uint256 value) internal {
673         // safeApprove should only be called when setting an initial allowance,
674         // or when resetting it to zero. To increase and decrease it, use
675         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
676         // solhint-disable-next-line max-line-length
677         require((value == 0) || (token.allowance(address(this), spender) == 0),
678             "SafeERC20: approve from non-zero to non-zero allowance"
679         );
680         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
681     }
682 
683     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
684         uint256 newAllowance = token.allowance(address(this), spender).add(value);
685         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
686     }
687 
688     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
689         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
690         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
691     }
692 
693     /**
694      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
695      * on the return value: the return value is optional (but if data is returned, it must not be false).
696      * @param token The token targeted by the call.
697      * @param data The call data (encoded using abi.encode or one of its variants).
698      */
699     function _callOptionalReturn(IERC20 token, bytes memory data) private {
700         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
701         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
702         // the target address contains contract code and also asserts for success in the low-level call.
703 
704         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
705         if (returndata.length > 0) { // Return data is optional
706             // solhint-disable-next-line max-line-length
707             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
708         }
709     }
710 }
711 
712 
713 // File contracts/lib/FixedPointMath.sol
714 
715 /*
716     Copyright 2021 Cook Finance.
717 
718     Licensed under the Apache License, Version 2.0 (the "License");
719     you may not use this file except in compliance with the License.
720     You may obtain a copy of the License at
721 
722     http://www.apache.org/licenses/LICENSE-2.0
723 
724     Unless required by applicable law or agreed to in writing, software
725     distributed under the License is distributed on an "AS IS" BASIS,
726     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
727     See the License for the specific language governing permissions and
728     limitations under the License.
729 */
730 
731 library FixedPointMath {
732   uint256 public constant DECIMALS = 18;
733   uint256 public constant SCALAR = 10**DECIMALS;
734 
735   struct uq192x64 {
736     uint256 x;
737   }
738 
739   function fromU256(uint256 value) internal pure returns (uq192x64 memory) {
740     uint256 x;
741     require(value == 0 || (x = value * SCALAR) / SCALAR == value);
742     return uq192x64(x);
743   }
744 
745   function maximumValue() internal pure returns (uq192x64 memory) {
746     return uq192x64(uint256(-1));
747   }
748 
749   function add(uq192x64 memory self, uq192x64 memory value) internal pure returns (uq192x64 memory) {
750     uint256 x;
751     require((x = self.x + value.x) >= self.x);
752     return uq192x64(x);
753   }
754 
755   function add(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
756     return add(self, fromU256(value));
757   }
758 
759   function sub(uq192x64 memory self, uq192x64 memory value) internal pure returns (uq192x64 memory) {
760     uint256 x;
761     require((x = self.x - value.x) <= self.x);
762     return uq192x64(x);
763   }
764 
765   function sub(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
766     return sub(self, fromU256(value));
767   }
768 
769   function mul(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
770     uint256 x;
771     require(value == 0 || (x = self.x * value) / value == self.x);
772     return uq192x64(x);
773   }
774 
775   function div(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
776     require(value != 0);
777     return uq192x64(self.x / value);
778   }
779 
780   function cmp(uq192x64 memory self, uq192x64 memory value) internal pure returns (int256) {
781     if (self.x < value.x) {
782       return -1;
783     }
784 
785     if (self.x > value.x) {
786       return 1;
787     }
788 
789     return 0;
790   }
791 
792   function decode(uq192x64 memory self) internal pure returns (uint256) {
793     return self.x / SCALAR;
794   }
795 }
796 
797 
798 // File contracts/interfaces/IDetailedERC20.sol
799 
800 /*
801     Copyright 2021 Cook Finance.
802 
803     Licensed under the Apache License, Version 2.0 (the "License");
804     you may not use this file except in compliance with the License.
805     You may obtain a copy of the License at
806 
807     http://www.apache.org/licenses/LICENSE-2.0
808 
809     Unless required by applicable law or agreed to in writing, software
810     distributed under the License is distributed on an "AS IS" BASIS,
811     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
812     See the License for the specific language governing permissions and
813     limitations under the License.
814 */
815 
816 interface IDetailedERC20 is IERC20 {
817   function name() external returns (string memory);
818   function symbol() external returns (string memory);
819   function decimals() external returns (uint8);
820 }
821 
822 
823 // File contracts/interfaces/IMintableERC20.sol
824 
825 /*
826     Copyright 2021 Cook Finance.
827 
828     Licensed under the Apache License, Version 2.0 (the "License");
829     you may not use this file except in compliance with the License.
830     You may obtain a copy of the License at
831 
832     http://www.apache.org/licenses/LICENSE-2.0
833 
834     Unless required by applicable law or agreed to in writing, software
835     distributed under the License is distributed on an "AS IS" BASIS,
836     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
837     See the License for the specific language governing permissions and
838     limitations under the License.
839 */
840 
841 interface IMintableERC20 is IDetailedERC20{
842   function mint(address _recipient, uint256 _amount) external;
843   function burnFrom(address account, uint256 amount) external;
844   function lowerHasMinted(uint256 amount) external;
845   function lowerHasMintedIfNeeded(uint256 amount) external;
846 }
847 
848 
849 // File contracts/interfaces/IRewardVesting.sol
850 
851 /*
852     Copyright 2021 Cook Finance.
853 
854     Licensed under the Apache License, Version 2.0 (the "License");
855     you may not use this file except in compliance with the License.
856     You may obtain a copy of the License at
857 
858     http://www.apache.org/licenses/LICENSE-2.0
859 
860     Unless required by applicable law or agreed to in writing, software
861     distributed under the License is distributed on an "AS IS" BASIS,
862     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
863     See the License for the specific language governing permissions and
864     limitations under the License.
865 */
866 
867 interface IRewardVesting  {
868     function addEarning(address user, uint256 amount, uint256 durationInSecs) external;
869     function userBalances(address user) external view returns (uint256 bal);
870 }
871 
872 
873 // File @openzeppelin/contracts/math/Math.sol@v3.4.1
874 
875 
876 /**
877  * @dev Standard math utilities missing in the Solidity language.
878  */
879 library Math {
880     /**
881      * @dev Returns the largest of two numbers.
882      */
883     function max(uint256 a, uint256 b) internal pure returns (uint256) {
884         return a >= b ? a : b;
885     }
886 
887     /**
888      * @dev Returns the smallest of two numbers.
889      */
890     function min(uint256 a, uint256 b) internal pure returns (uint256) {
891         return a < b ? a : b;
892     }
893 
894     /**
895      * @dev Returns the average of two numbers. The result is rounded towards
896      * zero.
897      */
898     function average(uint256 a, uint256 b) internal pure returns (uint256) {
899         // (a + b) / 2 can overflow, so we distribute
900         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
901     }
902 }
903 
904 
905 // File contracts/farm/Pool.sol
906 
907 /*
908     Copyright 2021 Cook Finance.
909 
910     Licensed under the Apache License, Version 2.0 (the "License");
911     you may not use this file except in compliance with the License.
912     You may obtain a copy of the License at
913 
914     http://www.apache.org/licenses/LICENSE-2.0
915 
916     Unless required by applicable law or agreed to in writing, software
917     distributed under the License is distributed on an "AS IS" BASIS,
918     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
919     See the License for the specific language governing permissions and
920     limitations under the License.
921 
922 */
923 pragma experimental ABIEncoderV2;
924 
925 
926 
927 
928 
929 /// @title Pool
930 ///
931 /// @dev A library which provides the Pool data struct and associated functions.
932 library Pool {
933   using FixedPointMath for FixedPointMath.uq192x64;
934   using Pool for Pool.Data;
935   using Pool for Pool.List;
936   using SafeMath for uint256;
937 
938   struct Context {
939     uint256 rewardRate;
940     uint256 totalRewardWeight;
941   }
942 
943   struct Data {
944     IERC20 token;
945     uint256 totalDeposited;
946     uint256 rewardWeight;
947     FixedPointMath.uq192x64 accumulatedRewardWeight;
948     // for vesting
949     uint256 lastUpdatedBlock;
950     bool needVesting;
951     // for referral power calculation
952     uint256 vestingDurationInSecs;
953     bool onReferralBonus;
954     uint256 totalReferralAmount; // deposited through referral
955     FixedPointMath.uq192x64 accumulatedReferralWeight;
956   }
957 
958   struct List {
959     Data[] elements;
960   }
961 
962   /// @dev Updates the pool.
963   ///
964   /// @param _ctx the pool context.
965   function update(Data storage _data, Context storage _ctx) internal {
966     _data.accumulatedRewardWeight = _data.getUpdatedAccumulatedRewardWeight(_ctx);
967 
968     if (_data.onReferralBonus) {
969       _data.accumulatedReferralWeight = _data.getUpdatedAccumulatedReferralWeight(_ctx);
970     }
971 
972     _data.lastUpdatedBlock = block.number;
973   }
974 
975   /// @dev Gets the rate at which the pool will distribute rewards to stakers.
976   ///
977   /// @param _ctx the pool context.
978   ///
979   /// @return the reward rate of the pool in tokens per block.
980   function getRewardRate(Data storage _data, Context storage _ctx)
981     internal view
982     returns (uint256)
983   {
984     return _ctx.rewardRate.mul(_data.rewardWeight).div(_ctx.totalRewardWeight);
985   }
986 
987   /// @dev Gets the accumulated reward weight of a pool.
988   ///
989   /// @param _ctx the pool context.
990   ///
991   /// @return the accumulated reward weight.
992   function getUpdatedAccumulatedRewardWeight(Data storage _data, Context storage _ctx)
993     internal view
994     returns (FixedPointMath.uq192x64 memory)
995   {
996     if (_data.totalDeposited == 0) {
997       return _data.accumulatedRewardWeight;
998     }
999 
1000     uint256 _elapsedTime = block.number.sub(_data.lastUpdatedBlock);
1001     if (_elapsedTime == 0) {
1002       return _data.accumulatedRewardWeight;
1003     }
1004 
1005     uint256 _rewardRate = _data.getRewardRate(_ctx);
1006     uint256 _distributeAmount = _rewardRate.mul(_elapsedTime);
1007 
1008     if (_distributeAmount == 0) {
1009       return _data.accumulatedRewardWeight;
1010     }
1011 
1012     FixedPointMath.uq192x64 memory _rewardWeight = FixedPointMath.fromU256(_distributeAmount).div(_data.totalDeposited);
1013     return _data.accumulatedRewardWeight.add(_rewardWeight);
1014   }
1015 
1016   /// @dev Gets the accumulated referral weight of a pool.
1017   ///
1018   /// @param _ctx the pool context.
1019   ///
1020   /// @return the accumulated reward weight.
1021   function getUpdatedAccumulatedReferralWeight(Data storage _data, Context storage _ctx)
1022     internal view
1023     returns (FixedPointMath.uq192x64 memory)
1024   {
1025     if (_data.totalReferralAmount == 0) {
1026 
1027       return _data.accumulatedReferralWeight;
1028     }
1029 
1030     uint256 _elapsedTime = block.number.sub(_data.lastUpdatedBlock);
1031     if (_elapsedTime == 0) {
1032       return _data.accumulatedReferralWeight;
1033     }
1034 
1035     uint256 _rewardRate = _data.getRewardRate(_ctx);
1036     uint256 _distributeAmount = _rewardRate.mul(_elapsedTime);
1037 
1038     if (_distributeAmount == 0) {
1039       return _data.accumulatedReferralWeight;
1040     }
1041 
1042     FixedPointMath.uq192x64 memory _rewardWeight = FixedPointMath.fromU256(_distributeAmount).div(_data.totalReferralAmount);
1043     return _data.accumulatedReferralWeight.add(_rewardWeight);
1044   }  
1045 
1046   /// @dev Adds an element to the list.
1047   ///
1048   /// @param _element the element to add.
1049   function push(List storage _self, Data memory _element) internal {
1050     _self.elements.push(_element);
1051   }
1052 
1053   /// @dev Gets an element from the list.
1054   ///
1055   /// @param _index the index in the list.
1056   ///
1057   /// @return the element at the specified index.
1058   function get(List storage _self, uint256 _index) internal view returns (Data storage) {
1059     return _self.elements[_index];
1060   }
1061 
1062   /// @dev Gets the last element in the list.
1063   ///
1064   /// This function will revert if there are no elements in the list.
1065   ///ck
1066   /// @return the last element in the list.
1067   function last(List storage _self) internal view returns (Data storage) {
1068     return _self.elements[_self.lastIndex()];
1069   }
1070 
1071   /// @dev Gets the index of the last element in the list.
1072   ///
1073   /// This function will revert if there are no elements in the list.
1074   ///
1075   /// @return the index of the last element.
1076   function lastIndex(List storage _self) internal view returns (uint256) {
1077     uint256 _length = _self.length();
1078     return _length.sub(1, "Pool.List: list is empty");
1079   }
1080 
1081   /// @dev Gets the number of elements in the list.
1082   ///
1083   /// @return the number of elements.
1084   function length(List storage _self) internal view returns (uint256) {
1085     return _self.elements.length;
1086   }
1087 }
1088 
1089 
1090 // File contracts/farm/Stake.sol
1091 
1092 /*
1093     Copyright 2021 Cook Finance.
1094 
1095     Licensed under the Apache License, Version 2.0 (the "License");
1096     you may not use this file except in compliance with the License.
1097     You may obtain a copy of the License at
1098 
1099     http://www.apache.org/licenses/LICENSE-2.0
1100 
1101     Unless required by applicable law or agreed to in writing, software
1102     distributed under the License is distributed on an "AS IS" BASIS,
1103     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1104     See the License for the specific language governing permissions and
1105     limitations under the License.
1106 
1107 */
1108 pragma solidity ^0.6.2;
1109 
1110 
1111 
1112 
1113 
1114 /// @title Stake
1115 ///
1116 /// @dev A library which provides the Stake data struct and associated functions.
1117 library Stake {
1118   using FixedPointMath for FixedPointMath.uq192x64;
1119   using Pool for Pool.Data;
1120   using SafeMath for uint256;
1121   using Stake for Stake.Data;
1122 
1123   struct Data {
1124     uint256 totalDeposited;
1125     uint256 totalUnclaimed;
1126     FixedPointMath.uq192x64 lastAccumulatedWeight;
1127   }
1128 
1129   function update(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx) internal {
1130     _self.totalUnclaimed = _self.getUpdatedTotalUnclaimed(_pool, _ctx);
1131     _self.lastAccumulatedWeight = _pool.getUpdatedAccumulatedRewardWeight(_ctx);
1132   }
1133 
1134   function getUpdatedTotalUnclaimed(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx)
1135     internal view
1136     returns (uint256)
1137   {
1138     FixedPointMath.uq192x64 memory _currentAccumulatedWeight = _pool.getUpdatedAccumulatedRewardWeight(_ctx);
1139     FixedPointMath.uq192x64 memory _lastAccumulatedWeight = _self.lastAccumulatedWeight;
1140 
1141     if (_currentAccumulatedWeight.cmp(_lastAccumulatedWeight) == 0) {
1142       return _self.totalUnclaimed;
1143     }
1144 
1145     uint256 _distributedAmount = _currentAccumulatedWeight
1146       .sub(_lastAccumulatedWeight)
1147       .mul(_self.totalDeposited)
1148       .decode();
1149 
1150     return _self.totalUnclaimed.add(_distributedAmount);
1151   }
1152 }
1153 
1154 
1155 // File contracts/farm/ReferralPower.sol
1156 
1157 /*
1158     Copyright 2021 Cook Finance.
1159 
1160     Licensed under the Apache License, Version 2.0 (the "License");
1161     you may not use this file except in compliance with the License.
1162     You may obtain a copy of the License at
1163 
1164     http://www.apache.org/licenses/LICENSE-2.0
1165 
1166     Unless required by applicable law or agreed to in writing, software
1167     distributed under the License is distributed on an "AS IS" BASIS,
1168     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1169     See the License for the specific language governing permissions and
1170     limitations under the License.
1171 
1172 */
1173 pragma solidity ^0.6.2;
1174 
1175 
1176 
1177 
1178 /// @title ReferralPower
1179 ///
1180 /// @dev A library which provides the ReferralPower data struct and associated functions.
1181 library ReferralPower {
1182   using FixedPointMath for FixedPointMath.uq192x64;
1183   using Pool for Pool.Data;
1184   using SafeMath for uint256;
1185   using ReferralPower for ReferralPower.Data;
1186 
1187   struct Data {
1188     uint256 totalDeposited;
1189     uint256 totalReferralPower;
1190     FixedPointMath.uq192x64 lastAccumulatedReferralPower;
1191   }
1192 
1193   function update(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx) internal {
1194     _self.totalReferralPower = _self.getUpdatedTotalReferralPower(_pool, _ctx);
1195     _self.lastAccumulatedReferralPower = _pool.getUpdatedAccumulatedReferralWeight(_ctx);
1196   }
1197 
1198   function getUpdatedTotalReferralPower(Data storage _self, Pool.Data storage _pool, Pool.Context storage _ctx)
1199     internal view
1200     returns (uint256)
1201   {
1202     FixedPointMath.uq192x64 memory _currentAccumulatedReferralPower = _pool.getUpdatedAccumulatedReferralWeight(_ctx);
1203     FixedPointMath.uq192x64 memory lastAccumulatedReferralPower = _self.lastAccumulatedReferralPower;
1204 
1205     if (_currentAccumulatedReferralPower.cmp(lastAccumulatedReferralPower) == 0) {
1206       return _self.totalReferralPower;
1207     }
1208 
1209     uint256 _distributedAmount = _currentAccumulatedReferralPower
1210       .sub(lastAccumulatedReferralPower)
1211       .mul(_self.totalDeposited)
1212       .decode();
1213 
1214     return _self.totalReferralPower.add(_distributedAmount);
1215   }
1216 }
1217 
1218 
1219 // File contracts/farm/StakingPool.sol
1220 
1221 /*
1222     Copyright 2021 Cook Finance.
1223 
1224     Licensed under the Apache License, Version 2.0 (the "License");
1225     you may not use this file except in compliance with the License.
1226     You may obtain a copy of the License at
1227 
1228     http://www.apache.org/licenses/LICENSE-2.0
1229 
1230     Unless required by applicable law or agreed to in writing, software
1231     distributed under the License is distributed on an "AS IS" BASIS,
1232     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1233     See the License for the specific language governing permissions and
1234     limitations under the License.
1235 
1236 */
1237 pragma solidity ^0.6.2;
1238 
1239 
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 // import "hardhat/console.sol";
1249 
1250 /// @dev A contract which allows users to stake to farm tokens.
1251 ///
1252 /// This contract was inspired by Chef Nomi's 'MasterChef' contract which can be found in this
1253 /// repository: https://github.com/sushiswap/sushiswap.
1254 contract StakingPools is ReentrancyGuard {
1255   using FixedPointMath for FixedPointMath.uq192x64;
1256   using Pool for Pool.Data;
1257   using Pool for Pool.List;
1258   using SafeERC20 for IERC20;
1259   using SafeMath for uint256;
1260   using Stake for Stake.Data;
1261   using ReferralPower for ReferralPower.Data;
1262 
1263   event PendingGovernanceUpdated(
1264     address pendingGovernance
1265   );
1266 
1267   event GovernanceUpdated(
1268     address governance
1269   );
1270 
1271   event RewardRateUpdated(
1272     uint256 rewardRate
1273   );
1274 
1275   event PoolRewardWeightUpdated(
1276     uint256 indexed poolId,
1277     uint256 rewardWeight
1278   );
1279 
1280   event PoolCreated(
1281     uint256 indexed poolId,
1282     IERC20 indexed token
1283   );
1284 
1285   event TokensDeposited(
1286     address indexed user,
1287     uint256 indexed poolId,
1288     uint256 amount
1289   );
1290 
1291   event TokensWithdrawn(
1292     address indexed user,
1293     uint256 indexed poolId,
1294     uint256 amount
1295   );
1296 
1297   event TokensClaimed(
1298     address indexed user,
1299     uint256 indexed poolId,
1300     uint256 amount
1301   );
1302 
1303   event PauseUpdated(
1304     bool status
1305   );
1306 
1307   event SentinelUpdated(
1308     address sentinel
1309   );
1310 
1311   event RewardVestingUpdated(
1312     IRewardVesting rewardVesting
1313   );
1314 
1315   event NewReferralAdded(
1316     address referral, address referee
1317   );
1318 
1319   /// @dev The token which will be minted as a reward for staking.
1320   IERC20 public reward;
1321 
1322   /// @dev The address of reward vesting.
1323   IRewardVesting public rewardVesting;
1324 
1325   /// @dev The address of the account which currently has administrative capabilities over this contract.
1326   address public governance;
1327 
1328   address public pendingGovernance;
1329 
1330   /// @dev The address of the account which can perform emergency activities
1331   address public sentinel;
1332 
1333   /// @dev Tokens are mapped to their pool identifier plus one. Tokens that do not have an associated pool
1334   /// will return an identifier of zero.
1335   mapping(IERC20 => uint256) public tokenPoolIds;
1336 
1337   /// @dev The context shared between the pools.
1338   Pool.Context private _ctx;
1339 
1340   /// @dev A list of all of the pools.
1341   Pool.List private _pools;
1342 
1343   /// @dev A mapping of all of the user stakes mapped first by pool and then by address.
1344   mapping(address => mapping(uint256 => Stake.Data)) private _stakes;
1345 
1346   /// @dev A mapping of all of the referral power mapped first by pool and then by address.
1347   mapping(address => mapping(uint256 => ReferralPower.Data)) private _referralPowers;
1348 
1349 /// @dev A mapping of all of the referee staker power mapped first by pool and then by referral address.
1350   mapping(address => mapping(uint256 => address)) public myReferral;
1351 
1352   /// @dev A mapping of known referrals mapped first by pool and then by address.
1353   mapping(address => mapping(uint256 => bool)) public referralIsKnown;
1354 
1355   /// @dev A mapping of referral Address mapped first by pool and then by nextReferral.
1356   mapping(uint256 => mapping(uint256 => address)) public referralList;
1357 
1358   /// @dev index record next user index mapped by pool
1359   mapping(uint256 => uint256) public nextReferral;
1360 
1361   // @dev A mapping of all of the referee staker referred by me. Mapping as by pool id and then by my address then referee array
1362   mapping(uint256 => mapping(address => address[])) public myreferees;
1363 
1364   /// @dev A flag indicating if claim should be halted
1365   bool public pause;
1366 
1367   constructor(
1368     IMintableERC20 _reward,
1369     address _governance,
1370     address _sentinel,
1371     IRewardVesting _rewardVesting
1372   ) public {
1373     require(_governance != address(0), "StakingPools: governance address cannot be 0x0");
1374     require(_sentinel != address(0), "StakingPools: sentinel address cannot be 0x0");
1375 
1376     reward = _reward;
1377     governance = _governance;
1378     sentinel = _sentinel;
1379     rewardVesting = _rewardVesting;
1380   }
1381 
1382   /// @dev A modifier which reverts when the caller is not the governance.
1383   modifier onlyGovernance() {
1384     require(msg.sender == governance, "StakingPools: only governance");
1385     _;
1386   }
1387 
1388   ///@dev modifier add referral to referrallist. Users are indexed in order to keep track of
1389   modifier checkIfNewReferral(uint256 pid, address referral) {
1390     Pool.Data storage _pool = _pools.get(pid);
1391 
1392     if (_pool.onReferralBonus && referral != address(0)) {
1393       if (!referralIsKnown[referral][pid]) {
1394           referralList[pid][nextReferral[pid]] = referral;
1395           referralIsKnown[referral][pid] = true;
1396           nextReferral[pid]++;
1397 
1398           emit NewReferralAdded(referral, msg.sender);
1399       }
1400 
1401       // add referee to referral's myreferee array
1402       bool toAdd = true;
1403       address refereeAddr = msg.sender;
1404       address[] storage  referees = myreferees[pid][referral];
1405       for (uint256 i = 0; i < referees.length; i++) {
1406         if (referees[i] == refereeAddr) {
1407           toAdd = false;
1408         }
1409       }
1410 
1411       if (toAdd) {
1412         referees.push(refereeAddr);
1413       }
1414     } 
1415 
1416     _;
1417   }
1418 
1419   /// @dev Sets the governance.
1420   ///
1421   /// This function can only called by the current governance.
1422   ///
1423   /// @param _pendingGovernance the new pending governance.
1424   function setPendingGovernance(address _pendingGovernance) external onlyGovernance {
1425     require(_pendingGovernance != address(0), "StakingPools: pending governance address cannot be 0x0");
1426     pendingGovernance = _pendingGovernance;
1427 
1428     emit PendingGovernanceUpdated(_pendingGovernance);
1429   }
1430 
1431   function acceptGovernance() external {
1432     require(msg.sender == pendingGovernance, "StakingPools: only pending governance");
1433 
1434     address _pendingGovernance = pendingGovernance;
1435     governance = _pendingGovernance;
1436 
1437     emit GovernanceUpdated(_pendingGovernance);
1438   }
1439 
1440   /// @dev Sets the distribution reward rate.
1441   ///
1442   /// This will update all of the pools.
1443   ///
1444   /// @param _rewardRate The number of tokens to distribute per second.
1445   function setRewardRate(uint256 _rewardRate) external onlyGovernance {
1446     _updatePools();
1447 
1448     _ctx.rewardRate = _rewardRate;
1449 
1450     emit RewardRateUpdated(_rewardRate);
1451   }
1452 
1453   /// @dev Creates a new pool.
1454   function createPool(IERC20 _token, bool _needVesting, uint256 durationInSecs) external onlyGovernance returns (uint256) {
1455     require(tokenPoolIds[_token] == 0, "StakingPools: token already has a pool");
1456 
1457     uint256 _poolId = _pools.length();
1458 
1459     _pools.push(Pool.Data({
1460       token: _token,
1461       totalDeposited: 0,
1462       rewardWeight: 0,
1463       accumulatedRewardWeight: FixedPointMath.uq192x64(0),
1464       lastUpdatedBlock: block.number,
1465       needVesting: _needVesting,
1466       vestingDurationInSecs: durationInSecs,
1467       onReferralBonus: false,
1468       totalReferralAmount: 0,
1469       accumulatedReferralWeight: FixedPointMath.uq192x64(0)
1470     }));
1471 
1472     tokenPoolIds[_token] = _poolId + 1;
1473 
1474     emit PoolCreated(_poolId, _token);
1475 
1476     return _poolId;
1477   }
1478 
1479   /// @dev Sets the reward weights of all of the pools.
1480   ///
1481   /// @param _rewardWeights The reward weights of all of the pools.
1482   function setRewardWeights(uint256[] calldata _rewardWeights) external onlyGovernance {
1483     require(_rewardWeights.length == _pools.length(), "StakingPools: weights length mismatch");
1484 
1485     _updatePools();
1486 
1487     uint256 _totalRewardWeight = _ctx.totalRewardWeight;
1488     for (uint256 _poolId = 0; _poolId < _pools.length(); _poolId++) {
1489       Pool.Data storage _pool = _pools.get(_poolId);
1490 
1491       uint256 _currentRewardWeight = _pool.rewardWeight;
1492       if (_currentRewardWeight == _rewardWeights[_poolId]) {
1493         continue;
1494       }
1495 
1496       // FIXME
1497       _totalRewardWeight = _totalRewardWeight.sub(_currentRewardWeight).add(_rewardWeights[_poolId]);
1498       _pool.rewardWeight = _rewardWeights[_poolId];
1499 
1500       emit PoolRewardWeightUpdated(_poolId, _rewardWeights[_poolId]);
1501     }
1502 
1503     _ctx.totalRewardWeight = _totalRewardWeight;
1504   }
1505 
1506   /// @dev Stakes tokens into a pool.
1507   ///
1508   /// @param _poolId        the pool to deposit tokens into.
1509   /// @param _depositAmount the amount of tokens to deposit.
1510   /// @param referral       the address of referral.
1511   function deposit(uint256 _poolId, uint256 _depositAmount, address referral) external nonReentrant checkIfNewReferral(_poolId, referral) {
1512     Pool.Data storage _pool = _pools.get(_poolId);
1513     _pool.update(_ctx);
1514 
1515     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1516     _stake.update(_pool, _ctx);
1517 
1518     address _referral = myReferral[msg.sender][_poolId];
1519     if (_pool.onReferralBonus) {
1520       if (referral != address(0)) {
1521         require (_referral == address(0) || _referral == referral, "referred already");
1522         myReferral[msg.sender][_poolId] = referral;
1523       }
1524 
1525       _referral = myReferral[msg.sender][_poolId];
1526       if (_referral != address(0)) {
1527         ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1528         _referralPower.update(_pool, _ctx);
1529       }
1530     }
1531 
1532     _deposit(_poolId, _depositAmount, _referral);
1533   }
1534 
1535   /// @dev Withdraws staked tokens from a pool.
1536   ///
1537   /// @param _poolId          The pool to withdraw staked tokens from.
1538   /// @param _withdrawAmount  The number of tokens to withdraw.
1539   function withdraw(uint256 _poolId, uint256 _withdrawAmount) external nonReentrant {
1540     Pool.Data storage _pool = _pools.get(_poolId);
1541     _pool.update(_ctx);
1542 
1543     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1544     _stake.update(_pool, _ctx);
1545 
1546     address _referral = _pool.onReferralBonus ? myReferral[msg.sender][_poolId] : address(0);
1547 
1548     if (_pool.onReferralBonus && _referral != address(0)) {
1549       ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1550       _referralPower.update(_pool, _ctx);
1551     }
1552 
1553     _claim(_poolId);
1554     _withdraw(_poolId, _withdrawAmount, _referral);
1555   }
1556 
1557   /// @dev Claims all rewarded tokens from a pool.
1558   ///
1559   /// @param _poolId The pool to claim rewards from.
1560   ///
1561   /// @notice use this function to claim the tokens from a corresponding pool by ID.
1562   function claim(uint256 _poolId) external nonReentrant {
1563     Pool.Data storage _pool = _pools.get(_poolId);
1564     _pool.update(_ctx);
1565 
1566     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1567 
1568     _stake.update(_pool, _ctx);
1569 
1570     _claim(_poolId);
1571   }
1572 
1573   /// @dev Claims all rewards from a pool and then withdraws all staked tokens.
1574   ///
1575   /// @param _poolId the pool to exit from.
1576   function exit(uint256 _poolId) external nonReentrant {
1577     Pool.Data storage _pool = _pools.get(_poolId);
1578     _pool.update(_ctx);
1579 
1580     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1581     _stake.update(_pool, _ctx);
1582 
1583     address _referral = _pool.onReferralBonus ? myReferral[msg.sender][_poolId] : address(0);
1584 
1585     if (_pool.onReferralBonus && _referral != address(0)) {
1586       ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1587       _referralPower.update(_pool, _ctx);
1588     }
1589 
1590     _claim(_poolId);
1591     _withdraw(_poolId, _stake.totalDeposited, _referral);
1592   }
1593 
1594   /// @dev Gets the rate at which tokens are minted to stakers for all pools.
1595   ///
1596   /// @return the reward rate.
1597   function rewardRate() external view returns (uint256) {
1598     return _ctx.rewardRate;
1599   }
1600 
1601   /// @dev Gets the total reward weight between all the pools.
1602   ///
1603   /// @return the total reward weight.
1604   function totalRewardWeight() external view returns (uint256) {
1605     return _ctx.totalRewardWeight;
1606   }
1607 
1608   /// @dev Gets the number of pools that exist.
1609   ///
1610   /// @return the pool count.
1611   function poolCount() external view returns (uint256) {
1612     return _pools.length();
1613   }
1614 
1615   /// @dev Gets the token a pool accepts.
1616   ///
1617   /// @param _poolId the identifier of the pool.
1618   ///
1619   /// @return the token.
1620   function getPoolToken(uint256 _poolId) external view returns (IERC20) {
1621     Pool.Data storage _pool = _pools.get(_poolId);
1622     return _pool.token;
1623   }
1624 
1625   /// @dev Gets the total amount of funds staked in a pool.
1626   ///
1627   /// @param _poolId the identifier of the pool.
1628   ///
1629   /// @return the total amount of staked or deposited tokens.
1630   function getPoolTotalDeposited(uint256 _poolId) external view returns (uint256) {
1631     Pool.Data storage _pool = _pools.get(_poolId);
1632     return _pool.totalDeposited;
1633   }
1634 
1635   /// @dev Gets the total amount of referreal power in a pool.
1636   ///
1637   /// @param _poolId the identifier of the pool.
1638   ///
1639   /// @return the total amount of referreal power in pool.
1640   function getPoolTotalReferralAmount(uint256 _poolId) external view returns (uint256) {
1641     Pool.Data storage _pool = _pools.get(_poolId);
1642     return _pool.totalReferralAmount;
1643   }
1644 
1645   /// @dev Gets the reward weight of a pool which determines how much of the total rewards it receives per block.
1646   ///
1647   /// @param _poolId the identifier of the pool.
1648   ///
1649   /// @return the pool reward weight.
1650   function getPoolRewardWeight(uint256 _poolId) external view returns (uint256) {
1651     Pool.Data storage _pool = _pools.get(_poolId);
1652     return _pool.rewardWeight;
1653   }
1654 
1655   /// @dev Gets the amount of tokens per block being distributed to stakers for a pool.
1656   ///
1657   /// @param _poolId the identifier of the pool.
1658   ///
1659   /// @return the pool reward rate.
1660   function getPoolRewardRate(uint256 _poolId) external view returns (uint256) {
1661     Pool.Data storage _pool = _pools.get(_poolId);
1662     return _pool.getRewardRate(_ctx);
1663   }
1664 
1665   /// @dev Gets the number of tokens a user has staked into a pool.
1666   ///
1667   /// @param _account The account to query.
1668   /// @param _poolId  the identifier of the pool.
1669   ///
1670   /// @return the amount of deposited tokens.
1671   function getStakeTotalDeposited(address _account, uint256 _poolId) external view returns (uint256) {
1672     Stake.Data storage _stake = _stakes[_account][_poolId];
1673     return _stake.totalDeposited;
1674   }
1675 
1676   /// @dev Gets the number of unclaimed reward tokens a user can claim from a pool.
1677   ///
1678   /// @param _account The account to get the unclaimed balance of.
1679   /// @param _poolId  The pool to check for unclaimed rewards.
1680   ///
1681   /// @return the amount of unclaimed reward tokens a user has in a pool.
1682   function getStakeTotalUnclaimed(address _account, uint256 _poolId) external view returns (uint256) {
1683     Stake.Data storage _stake = _stakes[_account][_poolId];
1684     return _stake.getUpdatedTotalUnclaimed(_pools.get(_poolId), _ctx);
1685   }
1686 
1687   /// @dev Gets address accumulated power.
1688   ///
1689   /// @param _referral The referral account to get accumulated power.
1690   /// @param _poolId  The pool to check for accumulated referral power.
1691   ///
1692   /// @return the amount of accumulated power a user has in a pool.
1693   function getAccumulatedReferralPower(address _referral, uint256 _poolId) external view returns (uint256) {
1694     ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1695     return _referralPower.getUpdatedTotalReferralPower(_pools.get(_poolId), _ctx);
1696   }
1697 
1698   /// @dev Gets address of referral address by index
1699   ///
1700   /// @param _poolId The pool to get referral address
1701   /// @param _referralIndex the index to get referral address
1702   ///
1703   /// @return the referral address in a specifgic pool with index. 
1704   function getPoolReferral(uint256 _poolId, uint256 _referralIndex) external view returns (address) {
1705     return referralList[_poolId][_referralIndex];
1706   }
1707 
1708   /// @dev Gets addressed of referee referred by a referral
1709   ///
1710   /// @param _poolId The pool to get referral address
1711   /// @param referral the address of referral to find all its referees
1712   ///
1713   /// @return the address array of referees
1714   function getPoolreferee(uint256 _poolId, address referral) external view returns(address[] memory) {
1715     return myreferees[_poolId][referral];
1716   }
1717 
1718   /// @dev Updates all of the pools.
1719   function _updatePools() internal {
1720     for (uint256 _poolId = 0; _poolId < _pools.length(); _poolId++) {
1721       Pool.Data storage _pool = _pools.get(_poolId);
1722       _pool.update(_ctx);
1723     }
1724   }
1725 
1726   /// @dev Stakes tokens into a pool.
1727   ///
1728   /// The pool and stake MUST be updated before calling this function.
1729   ///
1730   /// @param _poolId        the pool to deposit tokens into.
1731   /// @param _depositAmount the amount of tokens to deposit.
1732   /// @param _referral      the address of referral.
1733   function _deposit(uint256 _poolId, uint256 _depositAmount, address _referral) internal {
1734     Pool.Data storage _pool = _pools.get(_poolId);
1735     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1736 
1737     _pool.totalDeposited = _pool.totalDeposited.add(_depositAmount);
1738     _stake.totalDeposited = _stake.totalDeposited.add(_depositAmount);
1739 
1740     if (_pool.onReferralBonus && _referral != address(0)) {
1741       ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1742       _pool.totalReferralAmount = _pool.totalReferralAmount.add(_depositAmount);
1743       _referralPower.totalDeposited = _referralPower.totalDeposited.add(_depositAmount);
1744     }
1745 
1746     _pool.token.safeTransferFrom(msg.sender, address(this), _depositAmount);
1747 
1748     emit TokensDeposited(msg.sender, _poolId, _depositAmount);
1749   }
1750 
1751   /// @dev Withdraws staked tokens from a pool.
1752   ///
1753   /// The pool and stake MUST be updated before calling this function.
1754   ///
1755   /// @param _poolId          The pool to withdraw staked tokens from.
1756   /// @param _withdrawAmount  The number of tokens to withdraw.
1757   /// @param _referral        The referral's address for reducing referral power accumulation.
1758   function _withdraw(uint256 _poolId, uint256 _withdrawAmount, address _referral) internal {
1759     Pool.Data storage _pool = _pools.get(_poolId);
1760     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1761 
1762     _pool.totalDeposited = _pool.totalDeposited.sub(_withdrawAmount);
1763     _stake.totalDeposited = _stake.totalDeposited.sub(_withdrawAmount);
1764 
1765     if (_pool.onReferralBonus && _referral != address(0)) {
1766       ReferralPower.Data storage _referralPower = _referralPowers[_referral][_poolId];
1767       _pool.totalReferralAmount = _pool.totalReferralAmount.sub(_withdrawAmount);
1768       _referralPower.totalDeposited = _referralPower.totalDeposited.sub(_withdrawAmount);
1769     }
1770 
1771     _pool.token.safeTransfer(msg.sender, _withdrawAmount);
1772 
1773     emit TokensWithdrawn(msg.sender, _poolId, _withdrawAmount);
1774   }
1775 
1776   /// @dev Claims all rewarded tokens from a pool.
1777   ///
1778   /// The pool and stake MUST be updated before calling this function.
1779   ///
1780   /// @param _poolId The pool to claim rewards from.
1781   ///
1782   /// @notice use this function to claim the tokens from a corresponding pool by ID.
1783   function _claim(uint256 _poolId) internal {
1784     require(!pause, "StakingPools: emergency pause enabled");
1785 
1786     Pool.Data storage _pool = _pools.get(_poolId);
1787     Stake.Data storage _stake = _stakes[msg.sender][_poolId];
1788 
1789     uint256 _claimAmount = _stake.totalUnclaimed;
1790     _stake.totalUnclaimed = 0;
1791 
1792     if(_pool.needVesting){
1793       reward.approve(address(rewardVesting),uint(-1));
1794       rewardVesting.addEarning(msg.sender, _claimAmount, _pool.vestingDurationInSecs);
1795     } else {
1796       reward.safeTransfer(msg.sender, _claimAmount);
1797     }
1798 
1799     emit TokensClaimed(msg.sender, _poolId, _claimAmount);
1800   }
1801 
1802   /// @dev Updates the reward vesting contract
1803   ///
1804   /// @param _rewardVesting the new reward vesting contract
1805   function setRewardVesting(IRewardVesting _rewardVesting) external {
1806     require(pause && (msg.sender == governance || msg.sender == sentinel), "StakingPools: not paused, or not governance or sentinel");
1807     rewardVesting = _rewardVesting;
1808     emit RewardVestingUpdated(_rewardVesting);
1809   }
1810 
1811   /// @dev Sets the address of the sentinel
1812   ///
1813   /// @param _sentinel address of the new sentinel
1814   function setSentinel(address _sentinel) external onlyGovernance {
1815       require(_sentinel != address(0), "StakingPools: sentinel address cannot be 0x0.");
1816       sentinel = _sentinel;
1817       emit SentinelUpdated(_sentinel);
1818   }
1819 
1820   /// @dev Sets if the contract should enter emergency pause mode.
1821   ///
1822   /// There are 2 main reasons to pause:
1823   ///     1. Need to shut down claims in case of any issues in the reward vesting contract
1824   ///     2. Need to migrate to a new reward vesting contract
1825   ///
1826   /// While this contract is paused, claim is disabled
1827   ///
1828   /// @param _pause if the contract should enter emergency pause mode.
1829   function setPause(bool _pause) external {
1830       require(msg.sender == governance || msg.sender == sentinel, "StakingPools: !(gov || sentinel)");
1831       pause = _pause;
1832       emit PauseUpdated(_pause);
1833   }
1834 
1835   /// @dev To start referral power calculation for a pool, referral power caculation won't turn on if the onReferralBonus is not set
1836   ///
1837   /// @param _poolId the pool to start referral power accumulation
1838   function startReferralBonus(uint256 _poolId) external {
1839       require(msg.sender == governance || msg.sender == sentinel, "startReferralBonus: !(gov || sentinel)");
1840       Pool.Data storage _pool = _pools.get(_poolId);
1841       require(_pool.onReferralBonus == false, "referral bonus already on");
1842       _pool.onReferralBonus = true;
1843   }
1844 
1845   /// @dev To stop referral power calculation for a pool, referral power caculation won't turn on if the onReferralBonus is not set
1846   ///
1847   /// @param _poolId the pool to stop referral power accumulation
1848   function stoptReferralBonus(uint256 _poolId) external {
1849       require(msg.sender == governance || msg.sender == sentinel, "stoptReferralBonus: !(gov || sentinel)");
1850       Pool.Data storage _pool = _pools.get(_poolId);
1851       require(_pool.onReferralBonus == true, "referral not turned on");
1852       _pool.onReferralBonus = false;
1853   }
1854 }