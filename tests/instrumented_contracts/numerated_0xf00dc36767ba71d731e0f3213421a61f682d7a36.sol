1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(
173         uint256 a,
174         uint256 b,
175         string memory errorMessage
176     ) internal pure returns (uint256) {
177         require(b <= a, errorMessage);
178         return a - b;
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * CAUTION: This function is deprecated because it requires allocating memory for the error
186      * message unnecessarily. For custom revert reasons use {tryDiv}.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(
197         uint256 a,
198         uint256 b,
199         string memory errorMessage
200     ) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         return a / b;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting with custom message when dividing by zero.
208      *
209      * CAUTION: This function is deprecated because it requires allocating memory for the error
210      * message unnecessarily. For custom revert reasons use {tryMod}.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 // File @openzeppelin/contracts/utils/Context.sol@v3.4.0
231 
232 pragma solidity >=0.6.0 <0.8.0;
233 
234 /*
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with GSN meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address payable) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes memory) {
250         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
251         return msg.data;
252     }
253 }
254 
255 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.0
256 
257 pragma solidity >=0.6.0 <0.8.0;
258 
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * By default, the owner account will be the one that deploys the contract. This
265  * can later be changed with {transferOwnership}.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 abstract contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev Initializes the contract setting the deployer as the initial owner.
278      */
279     constructor() internal {
280         address msgSender = _msgSender();
281         _owner = msgSender;
282         emit OwnershipTransferred(address(0), msgSender);
283     }
284 
285     /**
286      * @dev Returns the address of the current owner.
287      */
288     function owner() public view virtual returns (address) {
289         return _owner;
290     }
291 
292     /**
293      * @dev Throws if called by any account other than the owner.
294      */
295     modifier onlyOwner() {
296         require(owner() == _msgSender(), "Ownable: caller is not the owner");
297         _;
298     }
299 
300     /**
301      * @dev Leaves the contract without owner. It will not be possible to call
302      * `onlyOwner` functions anymore. Can only be called by the current owner.
303      *
304      * NOTE: Renouncing ownership will leave the contract without an owner,
305      * thereby removing any functionality that is only available to the owner.
306      */
307     function renounceOwnership() public virtual onlyOwner {
308         emit OwnershipTransferred(_owner, address(0));
309         _owner = address(0);
310     }
311 
312     /**
313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
314      * Can only be called by the current owner.
315      */
316     function transferOwnership(address newOwner) public virtual onlyOwner {
317         require(newOwner != address(0), "Ownable: new owner is the zero address");
318         emit OwnershipTransferred(_owner, newOwner);
319         _owner = newOwner;
320     }
321 }
322 
323 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.0
324 
325 pragma solidity >=0.6.0 <0.8.0;
326 
327 /**
328  * @dev Interface of the ERC20 standard as defined in the EIP.
329  */
330 interface IERC20 {
331     /**
332      * @dev Returns the amount of tokens in existence.
333      */
334     function totalSupply() external view returns (uint256);
335 
336     /**
337      * @dev Returns the amount of tokens owned by `account`.
338      */
339     function balanceOf(address account) external view returns (uint256);
340 
341     /**
342      * @dev Moves `amount` tokens from the caller's account to `recipient`.
343      *
344      * Returns a boolean value indicating whether the operation succeeded.
345      *
346      * Emits a {Transfer} event.
347      */
348     function transfer(address recipient, uint256 amount) external returns (bool);
349 
350     /**
351      * @dev Returns the remaining number of tokens that `spender` will be
352      * allowed to spend on behalf of `owner` through {transferFrom}. This is
353      * zero by default.
354      *
355      * This value changes when {approve} or {transferFrom} are called.
356      */
357     function allowance(address owner, address spender) external view returns (uint256);
358 
359     /**
360      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * IMPORTANT: Beware that changing an allowance with this method brings the risk
365      * that someone may use both the old and the new allowance by unfortunate
366      * transaction ordering. One possible solution to mitigate this race
367      * condition is to first reduce the spender's allowance to 0 and set the
368      * desired value afterwards:
369      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
370      *
371      * Emits an {Approval} event.
372      */
373     function approve(address spender, uint256 amount) external returns (bool);
374 
375     /**
376      * @dev Moves `amount` tokens from `sender` to `recipient` using the
377      * allowance mechanism. `amount` is then deducted from the caller's
378      * allowance.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * Emits a {Transfer} event.
383      */
384     function transferFrom(
385         address sender,
386         address recipient,
387         uint256 amount
388     ) external returns (bool);
389 
390     /**
391      * @dev Emitted when `value` tokens are moved from one account (`from`) to
392      * another (`to`).
393      *
394      * Note that `value` may be zero.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 value);
397 
398     /**
399      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
400      * a call to {approve}. `value` is the new allowance.
401      */
402     event Approval(address indexed owner, address indexed spender, uint256 value);
403 }
404 
405 // File @openzeppelin/contracts/utils/Address.sol@v3.4.0
406 
407 pragma solidity >=0.6.2 <0.8.0;
408 
409 /**
410  * @dev Collection of functions related to the address type
411  */
412 library Address {
413     /**
414      * @dev Returns true if `account` is a contract.
415      *
416      * [IMPORTANT]
417      * ====
418      * It is unsafe to assume that an address for which this function returns
419      * false is an externally-owned account (EOA) and not a contract.
420      *
421      * Among others, `isContract` will return false for the following
422      * types of addresses:
423      *
424      *  - an externally-owned account
425      *  - a contract in construction
426      *  - an address where a contract will be created
427      *  - an address where a contract lived, but was destroyed
428      * ====
429      */
430     function isContract(address account) internal view returns (bool) {
431         // This method relies on extcodesize, which returns 0 for contracts in
432         // construction, since the code is only stored at the end of the
433         // constructor execution.
434 
435         uint256 size;
436         // solhint-disable-next-line no-inline-assembly
437         assembly {
438             size := extcodesize(account)
439         }
440         return size > 0;
441     }
442 
443     /**
444      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
445      * `recipient`, forwarding all available gas and reverting on errors.
446      *
447      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
448      * of certain opcodes, possibly making contracts go over the 2300 gas limit
449      * imposed by `transfer`, making them unable to receive funds via
450      * `transfer`. {sendValue} removes this limitation.
451      *
452      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
453      *
454      * IMPORTANT: because control is transferred to `recipient`, care must be
455      * taken to not create reentrancy vulnerabilities. Consider using
456      * {ReentrancyGuard} or the
457      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
458      */
459     function sendValue(address payable recipient, uint256 amount) internal {
460         require(address(this).balance >= amount, "Address: insufficient balance");
461 
462         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
463         (bool success, ) = recipient.call{ value: amount }("");
464         require(success, "Address: unable to send value, recipient may have reverted");
465     }
466 
467     /**
468      * @dev Performs a Solidity function call using a low level `call`. A
469      * plain`call` is an unsafe replacement for a function call: use this
470      * function instead.
471      *
472      * If `target` reverts with a revert reason, it is bubbled up by this
473      * function (like regular Solidity function calls).
474      *
475      * Returns the raw returned data. To convert to the expected return value,
476      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
477      *
478      * Requirements:
479      *
480      * - `target` must be a contract.
481      * - calling `target` with `data` must not revert.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
486         return functionCall(target, data, "Address: low-level call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
491      * `errorMessage` as a fallback revert reason when `target` reverts.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(
496         address target,
497         bytes memory data,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         return functionCallWithValue(target, data, 0, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but also transferring `value` wei to `target`.
506      *
507      * Requirements:
508      *
509      * - the calling contract must have an ETH balance of at least `value`.
510      * - the called Solidity function must be `payable`.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(
515         address target,
516         bytes memory data,
517         uint256 value
518     ) internal returns (bytes memory) {
519         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
524      * with `errorMessage` as a fallback revert reason when `target` reverts.
525      *
526      * _Available since v3.1._
527      */
528     function functionCallWithValue(
529         address target,
530         bytes memory data,
531         uint256 value,
532         string memory errorMessage
533     ) internal returns (bytes memory) {
534         require(address(this).balance >= value, "Address: insufficient balance for call");
535         require(isContract(target), "Address: call to non-contract");
536 
537         // solhint-disable-next-line avoid-low-level-calls
538         (bool success, bytes memory returndata) = target.call{ value: value }(data);
539         return _verifyCallResult(success, returndata, errorMessage);
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
544      * but performing a static call.
545      *
546      * _Available since v3.3._
547      */
548     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
549         return functionStaticCall(target, data, "Address: low-level static call failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
554      * but performing a static call.
555      *
556      * _Available since v3.3._
557      */
558     function functionStaticCall(
559         address target,
560         bytes memory data,
561         string memory errorMessage
562     ) internal view returns (bytes memory) {
563         require(isContract(target), "Address: static call to non-contract");
564 
565         // solhint-disable-next-line avoid-low-level-calls
566         (bool success, bytes memory returndata) = target.staticcall(data);
567         return _verifyCallResult(success, returndata, errorMessage);
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
572      * but performing a delegate call.
573      *
574      * _Available since v3.4._
575      */
576     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
577         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
582      * but performing a delegate call.
583      *
584      * _Available since v3.4._
585      */
586     function functionDelegateCall(
587         address target,
588         bytes memory data,
589         string memory errorMessage
590     ) internal returns (bytes memory) {
591         require(isContract(target), "Address: delegate call to non-contract");
592 
593         // solhint-disable-next-line avoid-low-level-calls
594         (bool success, bytes memory returndata) = target.delegatecall(data);
595         return _verifyCallResult(success, returndata, errorMessage);
596     }
597 
598     function _verifyCallResult(
599         bool success,
600         bytes memory returndata,
601         string memory errorMessage
602     ) private pure returns (bytes memory) {
603         if (success) {
604             return returndata;
605         } else {
606             // Look for revert reason and bubble it up if present
607             if (returndata.length > 0) {
608                 // The easiest way to bubble the revert reason is using memory via assembly
609 
610                 // solhint-disable-next-line no-inline-assembly
611                 assembly {
612                     let returndata_size := mload(returndata)
613                     revert(add(32, returndata), returndata_size)
614                 }
615             } else {
616                 revert(errorMessage);
617             }
618         }
619     }
620 }
621 
622 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.0
623 
624 pragma solidity >=0.6.0 <0.8.0;
625 
626 /**
627  * @title SafeERC20
628  * @dev Wrappers around ERC20 operations that throw on failure (when the token
629  * contract returns false). Tokens that return no value (and instead revert or
630  * throw on failure) are also supported, non-reverting calls are assumed to be
631  * successful.
632  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
633  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
634  */
635 library SafeERC20 {
636     using SafeMath for uint256;
637     using Address for address;
638 
639     function safeTransfer(
640         IERC20 token,
641         address to,
642         uint256 value
643     ) internal {
644         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
645     }
646 
647     function safeTransferFrom(
648         IERC20 token,
649         address from,
650         address to,
651         uint256 value
652     ) internal {
653         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
654     }
655 
656     /**
657      * @dev Deprecated. This function has issues similar to the ones found in
658      * {IERC20-approve}, and its usage is discouraged.
659      *
660      * Whenever possible, use {safeIncreaseAllowance} and
661      * {safeDecreaseAllowance} instead.
662      */
663     function safeApprove(
664         IERC20 token,
665         address spender,
666         uint256 value
667     ) internal {
668         // safeApprove should only be called when setting an initial allowance,
669         // or when resetting it to zero. To increase and decrease it, use
670         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
671         // solhint-disable-next-line max-line-length
672         require(
673             (value == 0) || (token.allowance(address(this), spender) == 0),
674             "SafeERC20: approve from non-zero to non-zero allowance"
675         );
676         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
677     }
678 
679     function safeIncreaseAllowance(
680         IERC20 token,
681         address spender,
682         uint256 value
683     ) internal {
684         uint256 newAllowance = token.allowance(address(this), spender).add(value);
685         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
686     }
687 
688     function safeDecreaseAllowance(
689         IERC20 token,
690         address spender,
691         uint256 value
692     ) internal {
693         uint256 newAllowance =
694             token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
695         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
696     }
697 
698     /**
699      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
700      * on the return value: the return value is optional (but if data is returned, it must not be false).
701      * @param token The token targeted by the call.
702      * @param data The call data (encoded using abi.encode or one of its variants).
703      */
704     function _callOptionalReturn(IERC20 token, bytes memory data) private {
705         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
706         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
707         // the target address contains contract code and also asserts for success in the low-level call.
708 
709         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
710         if (returndata.length > 0) {
711             // Return data is optional
712             // solhint-disable-next-line max-line-length
713             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
714         }
715     }
716 }
717 
718 // File contracts/Vesting.sol
719 
720 // SPDX-License-Identifier: MIT
721 
722 pragma solidity 0.6.12;
723 
724 contract Vesting is Ownable {
725     using SafeMath for uint256;
726     using SafeERC20 for IERC20;
727 
728     struct Program {
729         uint256 amount;
730         uint256 start;
731         uint256 cliff;
732         uint256 end;
733         uint256 claimed;
734     }
735 
736     IERC20 private immutable _token;
737     mapping(address => Program) private _programs;
738     uint256 private _totalVesting;
739 
740     event ProgramCreated(address indexed owner, uint256 amount);
741     event ProgramCanceled(address indexed owner);
742     event Claimed(address indexed owner, uint256 amount);
743 
744     /**
745      * @dev Constructor that initializes the address of the Vesting contract.
746      */
747     constructor(IERC20 token) public {
748         require(address(token) != address(0), "INVALID_ADDRESS");
749 
750         _token = token;
751     }
752 
753     /**
754      * @dev Returns a program for a given owner.
755      */
756     function program(address owner)
757         external
758         view
759         returns (
760             uint256,
761             uint256,
762             uint256,
763             uint256,
764             uint256
765         )
766     {
767         Program memory p = _programs[owner];
768 
769         return (p.amount, p.start, p.cliff, p.end, p.claimed);
770     }
771 
772     /**
773      * @dev Returns the total remaining vesting tokens in the contract.
774      */
775     function totalVesting() external view returns (uint256) {
776         return _totalVesting;
777     }
778 
779     /**
780      * @dev Creates a new vesting program for a given owner.
781      */
782     function addProgram(
783         address owner,
784         uint256 amount,
785         uint256 start,
786         uint256 cliff,
787         uint256 end
788     ) external onlyOwner {
789         require(owner != address(0), "INVALID_ADDRESS");
790         require(amount > 0, "INVALID_AMOUNT");
791         require(start <= cliff && cliff <= end, "INVALID_TIME");
792 
793         require(_programs[owner].amount == 0, "ALREADY_EXISTS");
794 
795         _programs[owner] = Program({ amount: amount, start: start, cliff: cliff, end: end, claimed: 0 });
796 
797         _totalVesting = _totalVesting.add(amount);
798 
799         emit ProgramCreated(owner, amount);
800     }
801 
802     /**
803      * @dev Cancels an existing vesting program (including unclaimed vested tokens).
804      */
805     function cancelProgram(address owner) external onlyOwner {
806         Program memory p = _programs[owner];
807 
808         require(p.amount > 0, "INVALID_ADDRESS");
809 
810         _totalVesting = _totalVesting.sub(p.amount.sub(p.claimed));
811 
812         delete _programs[owner];
813 
814         emit ProgramCanceled(owner);
815     }
816 
817     /**
818      * @dev Returns the current claimable vested amount.
819      */
820     function claimable(address owner) external view returns (uint256) {
821         return _claimable(_programs[owner]);
822     }
823 
824     /**
825      * @dev Claims vested tokens and sends them to the owner.
826      */
827     function claim() external {
828         Program storage p = _programs[msg.sender];
829         require(p.amount > 0, "INVALID_ADDRESS");
830 
831         uint256 unclaimed = _claimable(p);
832         if (unclaimed == 0) {
833             return;
834         }
835 
836         p.claimed = p.claimed.add(unclaimed);
837 
838         _totalVesting = _totalVesting.sub(unclaimed);
839 
840         _token.safeTransfer(msg.sender, unclaimed);
841 
842         emit Claimed(msg.sender, unclaimed);
843     }
844 
845     /**
846      * @dev Admin-only emergency transfer of contract's funds.
847      */
848     function withdraw(
849         IERC20 token,
850         address target,
851         uint256 amount
852     ) external onlyOwner {
853         require(target != address(0), "INVALID_ADDRESS");
854 
855         token.safeTransfer(target, amount);
856     }
857 
858     /**
859      * @dev Returns the current claimable amount.
860      */
861     function _claimable(Program memory p) private view returns (uint256) {
862         if (p.amount == 0) {
863             return 0;
864         }
865 
866         uint256 vested = _vested(p);
867         if (vested == 0) {
868             return 0;
869         }
870 
871         return vested.sub(p.claimed);
872     }
873 
874     /**
875      * @dev Returns the current claimable amount for a owner at the specific time.
876      */
877     function _vested(Program memory p) private view returns (uint256) {
878         uint256 time = _time();
879 
880         if (time < p.cliff) {
881             return 0;
882         }
883 
884         if (time >= p.end) {
885             return p.amount;
886         }
887 
888         // Interpolate vesting: claimable = amount * ((time - start) / (end - start)).
889         return p.amount.mul(time.sub(p.start)).div(p.end.sub(p.start));
890     }
891 
892     /**
893      * @dev Returns the current time (and used for testing).
894      */
895     function _time() internal view virtual returns (uint256) {
896         return block.timestamp;
897     }
898 }