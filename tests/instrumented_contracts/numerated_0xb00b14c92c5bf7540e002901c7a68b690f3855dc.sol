1 // Sources flattened with hardhat v2.3.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1-solc-0.7-2
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1-solc-0.7-2
29 
30 pragma solidity ^0.7.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File @openzeppelin/contracts/math/Math.sol@v3.4.1-solc-0.7-2
97 
98 pragma solidity ^0.7.0;
99 
100 /**
101  * @dev Standard math utilities missing in the Solidity language.
102  */
103 library Math {
104     /**
105      * @dev Returns the largest of two numbers.
106      */
107     function max(uint256 a, uint256 b) internal pure returns (uint256) {
108         return a >= b ? a : b;
109     }
110 
111     /**
112      * @dev Returns the smallest of two numbers.
113      */
114     function min(uint256 a, uint256 b) internal pure returns (uint256) {
115         return a < b ? a : b;
116     }
117 
118     /**
119      * @dev Returns the average of two numbers. The result is rounded towards
120      * zero.
121      */
122     function average(uint256 a, uint256 b) internal pure returns (uint256) {
123         // (a + b) / 2 can overflow, so we distribute
124         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
125     }
126 }
127 
128 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1-solc-0.7-2
129 
130 pragma solidity ^0.7.0;
131 
132 /**
133  * @dev Wrappers over Solidity's arithmetic operations with added overflow
134  * checks.
135  *
136  * Arithmetic operations in Solidity wrap on overflow. This can easily result
137  * in bugs, because programmers usually assume that an overflow raises an
138  * error, which is the standard behavior in high level programming languages.
139  * `SafeMath` restores this intuition by reverting the transaction when an
140  * operation overflows.
141  *
142  * Using this library instead of the unchecked operations eliminates an entire
143  * class of bugs, so it's recommended to use it always.
144  */
145 library SafeMath {
146     /**
147      * @dev Returns the addition of two unsigned integers, with an overflow flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         uint256 c = a + b;
153         if (c < a) return (false, 0);
154         return (true, c);
155     }
156 
157     /**
158      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
159      *
160      * _Available since v3.4._
161      */
162     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         if (b > a) return (false, 0);
164         return (true, a - b);
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
169      *
170      * _Available since v3.4._
171      */
172     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) return (true, 0);
177         uint256 c = a * b;
178         if (c / a != b) return (false, 0);
179         return (true, c);
180     }
181 
182     /**
183      * @dev Returns the division of two unsigned integers, with a division by zero flag.
184      *
185      * _Available since v3.4._
186      */
187     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
188         if (b == 0) return (false, 0);
189         return (true, a / b);
190     }
191 
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
194      *
195      * _Available since v3.4._
196      */
197     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
198         if (b == 0) return (false, 0);
199         return (true, a % b);
200     }
201 
202     /**
203      * @dev Returns the addition of two unsigned integers, reverting on
204      * overflow.
205      *
206      * Counterpart to Solidity's `+` operator.
207      *
208      * Requirements:
209      *
210      * - Addition cannot overflow.
211      */
212     function add(uint256 a, uint256 b) internal pure returns (uint256) {
213         uint256 c = a + b;
214         require(c >= a, "SafeMath: addition overflow");
215         return c;
216     }
217 
218     /**
219      * @dev Returns the subtraction of two unsigned integers, reverting on
220      * overflow (when the result is negative).
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      *
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229         require(b <= a, "SafeMath: subtraction overflow");
230         return a - b;
231     }
232 
233     /**
234      * @dev Returns the multiplication of two unsigned integers, reverting on
235      * overflow.
236      *
237      * Counterpart to Solidity's `*` operator.
238      *
239      * Requirements:
240      *
241      * - Multiplication cannot overflow.
242      */
243     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
244         if (a == 0) return 0;
245         uint256 c = a * b;
246         require(c / a == b, "SafeMath: multiplication overflow");
247         return c;
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers, reverting on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator. Note: this function uses a
255      * `revert` opcode (which leaves remaining gas untouched) while Solidity
256      * uses an invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
263         require(b > 0, "SafeMath: division by zero");
264         return a / b;
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * reverting when dividing by zero.
270      *
271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
272      * opcode (which leaves remaining gas untouched) while Solidity uses an
273      * invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
280         require(b > 0, "SafeMath: modulo by zero");
281         return a % b;
282     }
283 
284     /**
285      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
286      * overflow (when the result is negative).
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {trySub}.
290      *
291      * Counterpart to Solidity's `-` operator.
292      *
293      * Requirements:
294      *
295      * - Subtraction cannot overflow.
296      */
297     function sub(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         require(b <= a, errorMessage);
303         return a - b;
304     }
305 
306     /**
307      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
308      * division by zero. The result is rounded towards zero.
309      *
310      * CAUTION: This function is deprecated because it requires allocating memory for the error
311      * message unnecessarily. For custom revert reasons use {tryDiv}.
312      *
313      * Counterpart to Solidity's `/` operator. Note: this function uses a
314      * `revert` opcode (which leaves remaining gas untouched) while Solidity
315      * uses an invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      *
319      * - The divisor cannot be zero.
320      */
321     function div(
322         uint256 a,
323         uint256 b,
324         string memory errorMessage
325     ) internal pure returns (uint256) {
326         require(b > 0, errorMessage);
327         return a / b;
328     }
329 
330     /**
331      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
332      * reverting with custom message when dividing by zero.
333      *
334      * CAUTION: This function is deprecated because it requires allocating memory for the error
335      * message unnecessarily. For custom revert reasons use {tryMod}.
336      *
337      * Counterpart to Solidity's `%` operator. This function uses a `revert`
338      * opcode (which leaves remaining gas untouched) while Solidity uses an
339      * invalid opcode to revert (consuming all remaining gas).
340      *
341      * Requirements:
342      *
343      * - The divisor cannot be zero.
344      */
345     function mod(
346         uint256 a,
347         uint256 b,
348         string memory errorMessage
349     ) internal pure returns (uint256) {
350         require(b > 0, errorMessage);
351         return a % b;
352     }
353 }
354 
355 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1-solc-0.7-2
356 
357 pragma solidity ^0.7.0;
358 
359 /**
360  * @dev Interface of the ERC20 standard as defined in the EIP.
361  */
362 interface IERC20 {
363     /**
364      * @dev Returns the amount of tokens in existence.
365      */
366     function totalSupply() external view returns (uint256);
367 
368     /**
369      * @dev Returns the amount of tokens owned by `account`.
370      */
371     function balanceOf(address account) external view returns (uint256);
372 
373     /**
374      * @dev Moves `amount` tokens from the caller's account to `recipient`.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transfer(address recipient, uint256 amount) external returns (bool);
381 
382     /**
383      * @dev Returns the remaining number of tokens that `spender` will be
384      * allowed to spend on behalf of `owner` through {transferFrom}. This is
385      * zero by default.
386      *
387      * This value changes when {approve} or {transferFrom} are called.
388      */
389     function allowance(address owner, address spender) external view returns (uint256);
390 
391     /**
392      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
393      *
394      * Returns a boolean value indicating whether the operation succeeded.
395      *
396      * IMPORTANT: Beware that changing an allowance with this method brings the risk
397      * that someone may use both the old and the new allowance by unfortunate
398      * transaction ordering. One possible solution to mitigate this race
399      * condition is to first reduce the spender's allowance to 0 and set the
400      * desired value afterwards:
401      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
402      *
403      * Emits an {Approval} event.
404      */
405     function approve(address spender, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Moves `amount` tokens from `sender` to `recipient` using the
409      * allowance mechanism. `amount` is then deducted from the caller's
410      * allowance.
411      *
412      * Returns a boolean value indicating whether the operation succeeded.
413      *
414      * Emits a {Transfer} event.
415      */
416     function transferFrom(
417         address sender,
418         address recipient,
419         uint256 amount
420     ) external returns (bool);
421 
422     /**
423      * @dev Emitted when `value` tokens are moved from one account (`from`) to
424      * another (`to`).
425      *
426      * Note that `value` may be zero.
427      */
428     event Transfer(address indexed from, address indexed to, uint256 value);
429 
430     /**
431      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
432      * a call to {approve}. `value` is the new allowance.
433      */
434     event Approval(address indexed owner, address indexed spender, uint256 value);
435 }
436 
437 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1-solc-0.7-2
438 
439 pragma solidity ^0.7.0;
440 
441 /**
442  * @dev Collection of functions related to the address type
443  */
444 library Address {
445     /**
446      * @dev Returns true if `account` is a contract.
447      *
448      * [IMPORTANT]
449      * ====
450      * It is unsafe to assume that an address for which this function returns
451      * false is an externally-owned account (EOA) and not a contract.
452      *
453      * Among others, `isContract` will return false for the following
454      * types of addresses:
455      *
456      *  - an externally-owned account
457      *  - a contract in construction
458      *  - an address where a contract will be created
459      *  - an address where a contract lived, but was destroyed
460      * ====
461      */
462     function isContract(address account) internal view returns (bool) {
463         // This method relies on extcodesize, which returns 0 for contracts in
464         // construction, since the code is only stored at the end of the
465         // constructor execution.
466 
467         uint256 size;
468         // solhint-disable-next-line no-inline-assembly
469         assembly {
470             size := extcodesize(account)
471         }
472         return size > 0;
473     }
474 
475     /**
476      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
477      * `recipient`, forwarding all available gas and reverting on errors.
478      *
479      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
480      * of certain opcodes, possibly making contracts go over the 2300 gas limit
481      * imposed by `transfer`, making them unable to receive funds via
482      * `transfer`. {sendValue} removes this limitation.
483      *
484      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
485      *
486      * IMPORTANT: because control is transferred to `recipient`, care must be
487      * taken to not create reentrancy vulnerabilities. Consider using
488      * {ReentrancyGuard} or the
489      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
490      */
491     function sendValue(address payable recipient, uint256 amount) internal {
492         require(address(this).balance >= amount, "Address: insufficient balance");
493 
494         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
495         (bool success, ) = recipient.call{ value: amount }("");
496         require(success, "Address: unable to send value, recipient may have reverted");
497     }
498 
499     /**
500      * @dev Performs a Solidity function call using a low level `call`. A
501      * plain`call` is an unsafe replacement for a function call: use this
502      * function instead.
503      *
504      * If `target` reverts with a revert reason, it is bubbled up by this
505      * function (like regular Solidity function calls).
506      *
507      * Returns the raw returned data. To convert to the expected return value,
508      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
509      *
510      * Requirements:
511      *
512      * - `target` must be a contract.
513      * - calling `target` with `data` must not revert.
514      *
515      * _Available since v3.1._
516      */
517     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
518         return functionCall(target, data, "Address: low-level call failed");
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
523      * `errorMessage` as a fallback revert reason when `target` reverts.
524      *
525      * _Available since v3.1._
526      */
527     function functionCall(
528         address target,
529         bytes memory data,
530         string memory errorMessage
531     ) internal returns (bytes memory) {
532         return functionCallWithValue(target, data, 0, errorMessage);
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
537      * but also transferring `value` wei to `target`.
538      *
539      * Requirements:
540      *
541      * - the calling contract must have an ETH balance of at least `value`.
542      * - the called Solidity function must be `payable`.
543      *
544      * _Available since v3.1._
545      */
546     function functionCallWithValue(
547         address target,
548         bytes memory data,
549         uint256 value
550     ) internal returns (bytes memory) {
551         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
556      * with `errorMessage` as a fallback revert reason when `target` reverts.
557      *
558      * _Available since v3.1._
559      */
560     function functionCallWithValue(
561         address target,
562         bytes memory data,
563         uint256 value,
564         string memory errorMessage
565     ) internal returns (bytes memory) {
566         require(address(this).balance >= value, "Address: insufficient balance for call");
567         require(isContract(target), "Address: call to non-contract");
568 
569         // solhint-disable-next-line avoid-low-level-calls
570         (bool success, bytes memory returndata) = target.call{ value: value }(data);
571         return _verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but performing a static call.
577      *
578      * _Available since v3.3._
579      */
580     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
581         return functionStaticCall(target, data, "Address: low-level static call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
586      * but performing a static call.
587      *
588      * _Available since v3.3._
589      */
590     function functionStaticCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal view returns (bytes memory) {
595         require(isContract(target), "Address: static call to non-contract");
596 
597         // solhint-disable-next-line avoid-low-level-calls
598         (bool success, bytes memory returndata) = target.staticcall(data);
599         return _verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
604      * but performing a delegate call.
605      *
606      * _Available since v3.4._
607      */
608     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
609         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
614      * but performing a delegate call.
615      *
616      * _Available since v3.4._
617      */
618     function functionDelegateCall(
619         address target,
620         bytes memory data,
621         string memory errorMessage
622     ) internal returns (bytes memory) {
623         require(isContract(target), "Address: delegate call to non-contract");
624 
625         // solhint-disable-next-line avoid-low-level-calls
626         (bool success, bytes memory returndata) = target.delegatecall(data);
627         return _verifyCallResult(success, returndata, errorMessage);
628     }
629 
630     function _verifyCallResult(
631         bool success,
632         bytes memory returndata,
633         string memory errorMessage
634     ) private pure returns (bytes memory) {
635         if (success) {
636             return returndata;
637         } else {
638             // Look for revert reason and bubble it up if present
639             if (returndata.length > 0) {
640                 // The easiest way to bubble the revert reason is using memory via assembly
641 
642                 // solhint-disable-next-line no-inline-assembly
643                 assembly {
644                     let returndata_size := mload(returndata)
645                     revert(add(32, returndata), returndata_size)
646                 }
647             } else {
648                 revert(errorMessage);
649             }
650         }
651     }
652 }
653 
654 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1-solc-0.7-2
655 
656 pragma solidity ^0.7.0;
657 
658 /**
659  * @title SafeERC20
660  * @dev Wrappers around ERC20 operations that throw on failure (when the token
661  * contract returns false). Tokens that return no value (and instead revert or
662  * throw on failure) are also supported, non-reverting calls are assumed to be
663  * successful.
664  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
665  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
666  */
667 library SafeERC20 {
668     using SafeMath for uint256;
669     using Address for address;
670 
671     function safeTransfer(
672         IERC20 token,
673         address to,
674         uint256 value
675     ) internal {
676         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
677     }
678 
679     function safeTransferFrom(
680         IERC20 token,
681         address from,
682         address to,
683         uint256 value
684     ) internal {
685         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
686     }
687 
688     /**
689      * @dev Deprecated. This function has issues similar to the ones found in
690      * {IERC20-approve}, and its usage is discouraged.
691      *
692      * Whenever possible, use {safeIncreaseAllowance} and
693      * {safeDecreaseAllowance} instead.
694      */
695     function safeApprove(
696         IERC20 token,
697         address spender,
698         uint256 value
699     ) internal {
700         // safeApprove should only be called when setting an initial allowance,
701         // or when resetting it to zero. To increase and decrease it, use
702         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
703         // solhint-disable-next-line max-line-length
704         require(
705             (value == 0) || (token.allowance(address(this), spender) == 0),
706             "SafeERC20: approve from non-zero to non-zero allowance"
707         );
708         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
709     }
710 
711     function safeIncreaseAllowance(
712         IERC20 token,
713         address spender,
714         uint256 value
715     ) internal {
716         uint256 newAllowance = token.allowance(address(this), spender).add(value);
717         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
718     }
719 
720     function safeDecreaseAllowance(
721         IERC20 token,
722         address spender,
723         uint256 value
724     ) internal {
725         uint256 newAllowance = token.allowance(address(this), spender).sub(
726             value,
727             "SafeERC20: decreased allowance below zero"
728         );
729         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
730     }
731 
732     /**
733      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
734      * on the return value: the return value is optional (but if data is returned, it must not be false).
735      * @param token The token targeted by the call.
736      * @param data The call data (encoded using abi.encode or one of its variants).
737      */
738     function _callOptionalReturn(IERC20 token, bytes memory data) private {
739         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
740         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
741         // the target address contains contract code and also asserts for success in the low-level call.
742 
743         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
744         if (returndata.length > 0) {
745             // Return data is optional
746             // solhint-disable-next-line max-line-length
747             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
748         }
749     }
750 }
751 
752 // File contracts/IPussyFarm.sol
753 
754 interface IPussyFarm {
755     event Staked(address indexed account, uint256 amount);
756     event Withdrawn(address indexed account, uint256 amount);
757     event Claimed(address indexed account, uint256 reward);
758 
759     function getProgram()
760         external
761         view
762         returns (
763             uint256,
764             uint256,
765             uint256,
766             uint256
767         );
768 
769     function getStake(address account) external view returns (uint256);
770 
771     function getClaimed(address account) external view returns (uint256);
772 
773     function getTotalStaked() external view returns (uint256);
774 
775     function stake(uint256 amount) external;
776 
777     function withdraw(uint256 amount) external;
778 
779     function getPendingRewards(address account) external view returns (uint256);
780 
781     function claim() external returns (uint256);
782 }
783 
784 // File contracts/PussyFarm.sol
785 
786 // SPDX-License-Identifier: MIT
787 
788 contract PussyFarm is IPussyFarm, Ownable {
789     using Math for uint256;
790     using SafeMath for uint256;
791     using SafeERC20 for IERC20;
792 
793     uint256 private constant RATE_FACTOR = 1e18;
794 
795     IERC20 internal immutable _stakeToken;
796     IERC20 internal immutable _rewardToken;
797     uint256 internal immutable _startTime;
798     uint256 internal immutable _endTime;
799     uint256 private immutable _rewardRate;
800 
801     mapping(address => uint256) internal _stakes;
802     uint256 internal _totalStaked;
803 
804     uint256 private _lastUpdateTime;
805     uint256 private _rewardPerTokenStored;
806     mapping(address => uint256) private _stakerRewardPerTokenPaid;
807     mapping(address => uint256) private _rewards;
808     mapping(address => uint256) private _claimed;
809 
810     /**
811      * @dev Constructor that initializes the contract.
812      */
813     constructor(
814         IERC20 stakeToken,
815         IERC20 rewardToken,
816         uint256 startTime,
817         uint256 endTime,
818         uint256 rewardRate
819     ) {
820         require(address(stakeToken) != address(0) && address(rewardToken) != address(0), "INVALID_ADDRESS");
821         require(startTime < endTime && endTime > _time(), "INVALID_DURATION");
822         require(rewardRate > 0, "INVALID_VALUE");
823 
824         _stakeToken = stakeToken;
825         _rewardToken = rewardToken;
826         _startTime = startTime;
827         _endTime = endTime;
828         _rewardRate = rewardRate;
829     }
830 
831     /**
832      * @dev Updates msg.sender's pending rewards and rate.
833      */
834     modifier updateReward() {
835         _rewardPerTokenStored = _rewardPerToken();
836         _lastUpdateTime = Math.min(_time(), _endTime);
837 
838         _rewards[msg.sender] = _pendingRewards(msg.sender);
839         _stakerRewardPerTokenPaid[msg.sender] = _rewardPerTokenStored;
840 
841         _;
842     }
843 
844     /**
845      * @dev Returns the parameters for this vesting contract.
846      */
847     function getProgram()
848         external
849         view
850         override
851         returns (
852             uint256,
853             uint256,
854             uint256,
855             uint256
856         )
857     {
858         return (_startTime, _endTime, _rewardRate, _endTime.sub(_startTime).mul(_rewardRate));
859     }
860 
861     /**
862      * @dev Returns the current stake of a given account.
863      */
864     function getStake(address account) external view override returns (uint256) {
865         return (_stakes[account]);
866     }
867 
868     /**
869      * @dev Returns the total claimed rewards amount for a given account.
870      */
871     function getClaimed(address account) external view override returns (uint256) {
872         return (_claimed[account]);
873     }
874 
875     /**
876      * @dev Returns the total staked tokens in the contract.
877      */
878     function getTotalStaked() external view override returns (uint256) {
879         return _totalStaked;
880     }
881 
882     /**
883      * @dev Stakes the specified token amount into the contract.
884      */
885     function stake(uint256 amount) public virtual override updateReward {
886         require(amount > 0, "INVALID_AMOUNT");
887 
888         _stakes[msg.sender] = _stakes[msg.sender].add(amount);
889         _totalStaked = _totalStaked.add(amount);
890 
891         _stakeToken.safeTransferFrom(msg.sender, address(this), amount);
892 
893         emit Staked(msg.sender, amount);
894     }
895 
896     /**
897      * @dev Unstakes the specified token amount from the contract.
898      */
899     function withdraw(uint256 amount) public virtual override updateReward {
900         require(amount > 0, "INVALID_AMOUNT");
901 
902         _stakes[msg.sender] = _stakes[msg.sender].sub(amount);
903         _totalStaked = _totalStaked.sub(amount);
904 
905         _stakeToken.safeTransfer(msg.sender, amount);
906 
907         emit Withdrawn(msg.sender, amount);
908     }
909 
910     /**
911      * @dev Returns the pending rewards for a given account.
912      */
913     function getPendingRewards(address account) external view override returns (uint256) {
914         return _pendingRewards(account);
915     }
916 
917     /**
918      * @dev Claims pending rewards and sends them to the owner.
919      */
920     function claim() external virtual override updateReward returns (uint256) {
921         uint256 reward = _pendingRewards(msg.sender);
922         if (reward == 0) {
923             return reward;
924         }
925 
926         _rewards[msg.sender] = 0;
927         _claimed[msg.sender] = _claimed[msg.sender].add(reward);
928 
929         _rewardToken.safeTransfer(msg.sender, reward);
930 
931         emit Claimed(msg.sender, reward);
932 
933         return reward;
934     }
935 
936     /**
937      * @dev Admin-only emergency transfer of contract owned funds. Please note that community funds are excluded.
938      */
939     function withdrawTokens(IERC20 token, uint256 amount) external onlyOwner {
940         require(
941             address(token) != address(_stakeToken) || amount <= token.balanceOf(address(this)).sub(_totalStaked),
942             "INVALID_AMOUNT"
943         );
944 
945         token.safeTransfer(msg.sender, amount);
946     }
947 
948     /**
949      * @dev Calculates current reward per-token amount.
950      */
951     function _rewardPerToken() private view returns (uint256) {
952         if (_totalStaked == 0) {
953             return _rewardPerTokenStored;
954         }
955 
956         uint256 currentTime = _time();
957         if (currentTime < _startTime) {
958             return 0;
959         }
960 
961         uint256 stakingEndTime = Math.min(currentTime, _endTime);
962         uint256 stakingStartTime = Math.max(_startTime, _lastUpdateTime);
963         if (stakingStartTime == stakingEndTime) {
964             return _rewardPerTokenStored;
965         }
966 
967         return
968             _rewardPerTokenStored.add(
969                 stakingEndTime.sub(stakingStartTime).mul(_rewardRate).mul(RATE_FACTOR).div(_totalStaked)
970             );
971     }
972 
973     /**
974      * @dev Calculates account's pending rewards.
975      */
976     function _pendingRewards(address account) private view returns (uint256) {
977         return
978             _stakes[account].mul(_rewardPerToken().sub(_stakerRewardPerTokenPaid[account])).div(RATE_FACTOR).add(
979                 _rewards[account]
980             );
981     }
982 
983     /**
984      * @dev Returns the current time (and used for testing).
985      */
986     function _time() internal view virtual returns (uint256) {
987         return block.timestamp;
988     }
989 }