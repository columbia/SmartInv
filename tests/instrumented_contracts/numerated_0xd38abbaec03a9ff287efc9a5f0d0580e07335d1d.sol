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
11   /**
12    * @dev Returns the amount of tokens in existence.
13    */
14   function totalSupply() external view returns (uint256);
15 
16   /**
17    * @dev Returns the amount of tokens owned by `account`.
18    */
19   function balanceOf(address account) external view returns (uint256);
20 
21   /**
22    * @dev Moves `amount` tokens from the caller's account to `recipient`.
23    *
24    * Returns a boolean value indicating whether the operation succeeded.
25    *
26    * Emits a {Transfer} event.
27    */
28   function transfer(address recipient, uint256 amount) external returns (bool);
29 
30   /**
31    * @dev Returns the remaining number of tokens that `spender` will be
32    * allowed to spend on behalf of `owner` through {transferFrom}. This is
33    * zero by default.
34    *
35    * This value changes when {approve} or {transferFrom} are called.
36    */
37   function allowance(address owner, address spender) external view returns (uint256);
38 
39   /**
40    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41    *
42    * Returns a boolean value indicating whether the operation succeeded.
43    *
44    * IMPORTANT: Beware that changing an allowance with this method brings the risk
45    * that someone may use both the old and the new allowance by unfortunate
46    * transaction ordering. One possible solution to mitigate this race
47    * condition is to first reduce the spender's allowance to 0 and set the
48    * desired value afterwards:
49    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50    *
51    * Emits an {Approval} event.
52    */
53   function approve(address spender, uint256 amount) external returns (bool);
54 
55   /**
56    * @dev Moves `amount` tokens from `sender` to `recipient` using the
57    * allowance mechanism. `amount` is then deducted from the caller's
58    * allowance.
59    *
60    * Returns a boolean value indicating whether the operation succeeded.
61    *
62    * Emits a {Transfer} event.
63    */
64   function transferFrom(
65     address sender,
66     address recipient,
67     uint256 amount
68   ) external returns (bool);
69 
70   /**
71    * @dev Emitted when `value` tokens are moved from one account (`from`) to
72    * another (`to`).
73    *
74    * Note that `value` may be zero.
75    */
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 
78   /**
79    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80    * a call to {approve}. `value` is the new allowance.
81    */
82   event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: @openzeppelin/contracts/math/SafeMath.sol
86 
87 pragma solidity >=0.6.0 <0.8.0;
88 
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations with added overflow
91  * checks.
92  *
93  * Arithmetic operations in Solidity wrap on overflow. This can easily result
94  * in bugs, because programmers usually assume that an overflow raises an
95  * error, which is the standard behavior in high level programming languages.
96  * `SafeMath` restores this intuition by reverting the transaction when an
97  * operation overflows.
98  *
99  * Using this library instead of the unchecked operations eliminates an entire
100  * class of bugs, so it's recommended to use it always.
101  */
102 library SafeMath {
103   /**
104    * @dev Returns the addition of two unsigned integers, with an overflow flag.
105    *
106    * _Available since v3.4._
107    */
108   function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
109     uint256 c = a + b;
110     if (c < a) return (false, 0);
111     return (true, c);
112   }
113 
114   /**
115    * @dev Returns the substraction of two unsigned integers, with an overflow flag.
116    *
117    * _Available since v3.4._
118    */
119   function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120     if (b > a) return (false, 0);
121     return (true, a - b);
122   }
123 
124   /**
125    * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
126    *
127    * _Available since v3.4._
128    */
129   function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
131     // benefit is lost if 'b' is also tested.
132     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
133     if (a == 0) return (true, 0);
134     uint256 c = a * b;
135     if (c / a != b) return (false, 0);
136     return (true, c);
137   }
138 
139   /**
140    * @dev Returns the division of two unsigned integers, with a division by zero flag.
141    *
142    * _Available since v3.4._
143    */
144   function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145     if (b == 0) return (false, 0);
146     return (true, a / b);
147   }
148 
149   /**
150    * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
151    *
152    * _Available since v3.4._
153    */
154   function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155     if (b == 0) return (false, 0);
156     return (true, a % b);
157   }
158 
159   /**
160    * @dev Returns the addition of two unsigned integers, reverting on
161    * overflow.
162    *
163    * Counterpart to Solidity's `+` operator.
164    *
165    * Requirements:
166    *
167    * - Addition cannot overflow.
168    */
169   function add(uint256 a, uint256 b) internal pure returns (uint256) {
170     uint256 c = a + b;
171     require(c >= a, 'SafeMath: addition overflow');
172     return c;
173   }
174 
175   /**
176    * @dev Returns the subtraction of two unsigned integers, reverting on
177    * overflow (when the result is negative).
178    *
179    * Counterpart to Solidity's `-` operator.
180    *
181    * Requirements:
182    *
183    * - Subtraction cannot overflow.
184    */
185   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186     require(b <= a, 'SafeMath: subtraction overflow');
187     return a - b;
188   }
189 
190   /**
191    * @dev Returns the multiplication of two unsigned integers, reverting on
192    * overflow.
193    *
194    * Counterpart to Solidity's `*` operator.
195    *
196    * Requirements:
197    *
198    * - Multiplication cannot overflow.
199    */
200   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201     if (a == 0) return 0;
202     uint256 c = a * b;
203     require(c / a == b, 'SafeMath: multiplication overflow');
204     return c;
205   }
206 
207   /**
208    * @dev Returns the integer division of two unsigned integers, reverting on
209    * division by zero. The result is rounded towards zero.
210    *
211    * Counterpart to Solidity's `/` operator. Note: this function uses a
212    * `revert` opcode (which leaves remaining gas untouched) while Solidity
213    * uses an invalid opcode to revert (consuming all remaining gas).
214    *
215    * Requirements:
216    *
217    * - The divisor cannot be zero.
218    */
219   function div(uint256 a, uint256 b) internal pure returns (uint256) {
220     require(b > 0, 'SafeMath: division by zero');
221     return a / b;
222   }
223 
224   /**
225    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226    * reverting when dividing by zero.
227    *
228    * Counterpart to Solidity's `%` operator. This function uses a `revert`
229    * opcode (which leaves remaining gas untouched) while Solidity uses an
230    * invalid opcode to revert (consuming all remaining gas).
231    *
232    * Requirements:
233    *
234    * - The divisor cannot be zero.
235    */
236   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237     require(b > 0, 'SafeMath: modulo by zero');
238     return a % b;
239   }
240 
241   /**
242    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
243    * overflow (when the result is negative).
244    *
245    * CAUTION: This function is deprecated because it requires allocating memory for the error
246    * message unnecessarily. For custom revert reasons use {trySub}.
247    *
248    * Counterpart to Solidity's `-` operator.
249    *
250    * Requirements:
251    *
252    * - Subtraction cannot overflow.
253    */
254   function sub(
255     uint256 a,
256     uint256 b,
257     string memory errorMessage
258   ) internal pure returns (uint256) {
259     require(b <= a, errorMessage);
260     return a - b;
261   }
262 
263   /**
264    * @dev Returns the integer division of two unsigned integers, reverting with custom message on
265    * division by zero. The result is rounded towards zero.
266    *
267    * CAUTION: This function is deprecated because it requires allocating memory for the error
268    * message unnecessarily. For custom revert reasons use {tryDiv}.
269    *
270    * Counterpart to Solidity's `/` operator. Note: this function uses a
271    * `revert` opcode (which leaves remaining gas untouched) while Solidity
272    * uses an invalid opcode to revert (consuming all remaining gas).
273    *
274    * Requirements:
275    *
276    * - The divisor cannot be zero.
277    */
278   function div(
279     uint256 a,
280     uint256 b,
281     string memory errorMessage
282   ) internal pure returns (uint256) {
283     require(b > 0, errorMessage);
284     return a / b;
285   }
286 
287   /**
288    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
289    * reverting with custom message when dividing by zero.
290    *
291    * CAUTION: This function is deprecated because it requires allocating memory for the error
292    * message unnecessarily. For custom revert reasons use {tryMod}.
293    *
294    * Counterpart to Solidity's `%` operator. This function uses a `revert`
295    * opcode (which leaves remaining gas untouched) while Solidity uses an
296    * invalid opcode to revert (consuming all remaining gas).
297    *
298    * Requirements:
299    *
300    * - The divisor cannot be zero.
301    */
302   function mod(
303     uint256 a,
304     uint256 b,
305     string memory errorMessage
306   ) internal pure returns (uint256) {
307     require(b > 0, errorMessage);
308     return a % b;
309   }
310 }
311 
312 // File: @openzeppelin/contracts/utils/Address.sol
313 
314 pragma solidity >=0.6.2 <0.8.0;
315 
316 /**
317  * @dev Collection of functions related to the address type
318  */
319 library Address {
320   /**
321    * @dev Returns true if `account` is a contract.
322    *
323    * [IMPORTANT]
324    * ====
325    * It is unsafe to assume that an address for which this function returns
326    * false is an externally-owned account (EOA) and not a contract.
327    *
328    * Among others, `isContract` will return false for the following
329    * types of addresses:
330    *
331    *  - an externally-owned account
332    *  - a contract in construction
333    *  - an address where a contract will be created
334    *  - an address where a contract lived, but was destroyed
335    * ====
336    */
337   function isContract(address account) internal view returns (bool) {
338     // This method relies on extcodesize, which returns 0 for contracts in
339     // construction, since the code is only stored at the end of the
340     // constructor execution.
341 
342     uint256 size;
343     // solhint-disable-next-line no-inline-assembly
344     assembly {
345       size := extcodesize(account)
346     }
347     return size > 0;
348   }
349 
350   /**
351    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
352    * `recipient`, forwarding all available gas and reverting on errors.
353    *
354    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
355    * of certain opcodes, possibly making contracts go over the 2300 gas limit
356    * imposed by `transfer`, making them unable to receive funds via
357    * `transfer`. {sendValue} removes this limitation.
358    *
359    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
360    *
361    * IMPORTANT: because control is transferred to `recipient`, care must be
362    * taken to not create reentrancy vulnerabilities. Consider using
363    * {ReentrancyGuard} or the
364    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
365    */
366   function sendValue(address payable recipient, uint256 amount) internal {
367     require(address(this).balance >= amount, 'Address: insufficient balance');
368 
369     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
370     (bool success, ) = recipient.call{ value: amount }('');
371     require(success, 'Address: unable to send value, recipient may have reverted');
372   }
373 
374   /**
375    * @dev Performs a Solidity function call using a low level `call`. A
376    * plain`call` is an unsafe replacement for a function call: use this
377    * function instead.
378    *
379    * If `target` reverts with a revert reason, it is bubbled up by this
380    * function (like regular Solidity function calls).
381    *
382    * Returns the raw returned data. To convert to the expected return value,
383    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
384    *
385    * Requirements:
386    *
387    * - `target` must be a contract.
388    * - calling `target` with `data` must not revert.
389    *
390    * _Available since v3.1._
391    */
392   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
393     return functionCall(target, data, 'Address: low-level call failed');
394   }
395 
396   /**
397    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
398    * `errorMessage` as a fallback revert reason when `target` reverts.
399    *
400    * _Available since v3.1._
401    */
402   function functionCall(
403     address target,
404     bytes memory data,
405     string memory errorMessage
406   ) internal returns (bytes memory) {
407     return functionCallWithValue(target, data, 0, errorMessage);
408   }
409 
410   /**
411    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412    * but also transferring `value` wei to `target`.
413    *
414    * Requirements:
415    *
416    * - the calling contract must have an ETH balance of at least `value`.
417    * - the called Solidity function must be `payable`.
418    *
419    * _Available since v3.1._
420    */
421   function functionCallWithValue(
422     address target,
423     bytes memory data,
424     uint256 value
425   ) internal returns (bytes memory) {
426     return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
427   }
428 
429   /**
430    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
431    * with `errorMessage` as a fallback revert reason when `target` reverts.
432    *
433    * _Available since v3.1._
434    */
435   function functionCallWithValue(
436     address target,
437     bytes memory data,
438     uint256 value,
439     string memory errorMessage
440   ) internal returns (bytes memory) {
441     require(address(this).balance >= value, 'Address: insufficient balance for call');
442     require(isContract(target), 'Address: call to non-contract');
443 
444     // solhint-disable-next-line avoid-low-level-calls
445     (bool success, bytes memory returndata) = target.call{ value: value }(data);
446     return _verifyCallResult(success, returndata, errorMessage);
447   }
448 
449   /**
450    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451    * but performing a static call.
452    *
453    * _Available since v3.3._
454    */
455   function functionStaticCall(address target, bytes memory data)
456     internal
457     view
458     returns (bytes memory)
459   {
460     return functionStaticCall(target, data, 'Address: low-level static call failed');
461   }
462 
463   /**
464    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465    * but performing a static call.
466    *
467    * _Available since v3.3._
468    */
469   function functionStaticCall(
470     address target,
471     bytes memory data,
472     string memory errorMessage
473   ) internal view returns (bytes memory) {
474     require(isContract(target), 'Address: static call to non-contract');
475 
476     // solhint-disable-next-line avoid-low-level-calls
477     (bool success, bytes memory returndata) = target.staticcall(data);
478     return _verifyCallResult(success, returndata, errorMessage);
479   }
480 
481   /**
482    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
483    * but performing a delegate call.
484    *
485    * _Available since v3.4._
486    */
487   function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
488     return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
489   }
490 
491   /**
492    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
493    * but performing a delegate call.
494    *
495    * _Available since v3.4._
496    */
497   function functionDelegateCall(
498     address target,
499     bytes memory data,
500     string memory errorMessage
501   ) internal returns (bytes memory) {
502     require(isContract(target), 'Address: delegate call to non-contract');
503 
504     // solhint-disable-next-line avoid-low-level-calls
505     (bool success, bytes memory returndata) = target.delegatecall(data);
506     return _verifyCallResult(success, returndata, errorMessage);
507   }
508 
509   function _verifyCallResult(
510     bool success,
511     bytes memory returndata,
512     string memory errorMessage
513   ) private pure returns (bytes memory) {
514     if (success) {
515       return returndata;
516     } else {
517       // Look for revert reason and bubble it up if present
518       if (returndata.length > 0) {
519         // The easiest way to bubble the revert reason is using memory via assembly
520 
521         // solhint-disable-next-line no-inline-assembly
522         assembly {
523           let returndata_size := mload(returndata)
524           revert(add(32, returndata), returndata_size)
525         }
526       } else {
527         revert(errorMessage);
528       }
529     }
530   }
531 }
532 
533 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
534 
535 pragma solidity >=0.6.0 <0.8.0;
536 
537 /**
538  * @title SafeERC20
539  * @dev Wrappers around ERC20 operations that throw on failure (when the token
540  * contract returns false). Tokens that return no value (and instead revert or
541  * throw on failure) are also supported, non-reverting calls are assumed to be
542  * successful.
543  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
544  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
545  */
546 library SafeERC20 {
547   using SafeMath for uint256;
548   using Address for address;
549 
550   function safeTransfer(
551     IERC20 token,
552     address to,
553     uint256 value
554   ) internal {
555     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
556   }
557 
558   function safeTransferFrom(
559     IERC20 token,
560     address from,
561     address to,
562     uint256 value
563   ) internal {
564     _callOptionalReturn(
565       token,
566       abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
567     );
568   }
569 
570   /**
571    * @dev Deprecated. This function has issues similar to the ones found in
572    * {IERC20-approve}, and its usage is discouraged.
573    *
574    * Whenever possible, use {safeIncreaseAllowance} and
575    * {safeDecreaseAllowance} instead.
576    */
577   function safeApprove(
578     IERC20 token,
579     address spender,
580     uint256 value
581   ) internal {
582     // safeApprove should only be called when setting an initial allowance,
583     // or when resetting it to zero. To increase and decrease it, use
584     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
585     // solhint-disable-next-line max-line-length
586     require(
587       (value == 0) || (token.allowance(address(this), spender) == 0),
588       'SafeERC20: approve from non-zero to non-zero allowance'
589     );
590     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
591   }
592 
593   function safeIncreaseAllowance(
594     IERC20 token,
595     address spender,
596     uint256 value
597   ) internal {
598     uint256 newAllowance = token.allowance(address(this), spender).add(value);
599     _callOptionalReturn(
600       token,
601       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
602     );
603   }
604 
605   function safeDecreaseAllowance(
606     IERC20 token,
607     address spender,
608     uint256 value
609   ) internal {
610     uint256 newAllowance =
611       token.allowance(address(this), spender).sub(
612         value,
613         'SafeERC20: decreased allowance below zero'
614       );
615     _callOptionalReturn(
616       token,
617       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
618     );
619   }
620 
621   /**
622    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
623    * on the return value: the return value is optional (but if data is returned, it must not be false).
624    * @param token The token targeted by the call.
625    * @param data The call data (encoded using abi.encode or one of its variants).
626    */
627   function _callOptionalReturn(IERC20 token, bytes memory data) private {
628     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
629     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
630     // the target address contains contract code and also asserts for success in the low-level call.
631 
632     bytes memory returndata = address(token).functionCall(data, 'SafeERC20: low-level call failed');
633     if (returndata.length > 0) {
634       // Return data is optional
635       // solhint-disable-next-line max-line-length
636       require(abi.decode(returndata, (bool)), 'SafeERC20: ERC20 operation did not succeed');
637     }
638   }
639 }
640 
641 // File: @openzeppelin/contracts/math/Math.sol
642 
643 pragma solidity >=0.6.0 <0.8.0;
644 
645 /**
646  * @dev Standard math utilities missing in the Solidity language.
647  */
648 library Math {
649   /**
650    * @dev Returns the largest of two numbers.
651    */
652   function max(uint256 a, uint256 b) internal pure returns (uint256) {
653     return a >= b ? a : b;
654   }
655 
656   /**
657    * @dev Returns the smallest of two numbers.
658    */
659   function min(uint256 a, uint256 b) internal pure returns (uint256) {
660     return a < b ? a : b;
661   }
662 
663   /**
664    * @dev Returns the average of two numbers. The result is rounded towards
665    * zero.
666    */
667   function average(uint256 a, uint256 b) internal pure returns (uint256) {
668     // (a + b) / 2 can overflow, so we distribute
669     return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
670   }
671 }
672 
673 // File: @openzeppelin/contracts/utils/Context.sol
674 
675 pragma solidity >=0.6.0 <0.8.0;
676 
677 /*
678  * @dev Provides information about the current execution context, including the
679  * sender of the transaction and its data. While these are generally available
680  * via msg.sender and msg.data, they should not be accessed in such a direct
681  * manner, since when dealing with GSN meta-transactions the account sending and
682  * paying for execution may not be the actual sender (as far as an application
683  * is concerned).
684  *
685  * This contract is only required for intermediate, library-like contracts.
686  */
687 abstract contract Context {
688   function _msgSender() internal view virtual returns (address payable) {
689     return msg.sender;
690   }
691 
692   function _msgData() internal view virtual returns (bytes memory) {
693     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
694     return msg.data;
695   }
696 }
697 
698 // File: @openzeppelin/contracts/access/Ownable.sol
699 
700 pragma solidity >=0.6.0 <0.8.0;
701 
702 /**
703  * @dev Contract module which provides a basic access control mechanism, where
704  * there is an account (an owner) that can be granted exclusive access to
705  * specific functions.
706  *
707  * By default, the owner account will be the one that deploys the contract. This
708  * can later be changed with {transferOwnership}.
709  *
710  * This module is used through inheritance. It will make available the modifier
711  * `onlyOwner`, which can be applied to your functions to restrict their use to
712  * the owner.
713  */
714 abstract contract Ownable is Context {
715   address private _owner;
716 
717   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
718 
719   /**
720    * @dev Initializes the contract setting the deployer as the initial owner.
721    */
722   constructor() internal {
723     address msgSender = _msgSender();
724     _owner = msgSender;
725     emit OwnershipTransferred(address(0), msgSender);
726   }
727 
728   /**
729    * @dev Returns the address of the current owner.
730    */
731   function owner() public view virtual returns (address) {
732     return _owner;
733   }
734 
735   /**
736    * @dev Throws if called by any account other than the owner.
737    */
738   modifier onlyOwner() {
739     require(owner() == _msgSender(), 'Ownable: caller is not the owner');
740     _;
741   }
742 
743   /**
744    * @dev Leaves the contract without owner. It will not be possible to call
745    * `onlyOwner` functions anymore. Can only be called by the current owner.
746    *
747    * NOTE: Renouncing ownership will leave the contract without an owner,
748    * thereby removing any functionality that is only available to the owner.
749    */
750   function renounceOwnership() public virtual onlyOwner {
751     emit OwnershipTransferred(_owner, address(0));
752     _owner = address(0);
753   }
754 
755   /**
756    * @dev Transfers ownership of the contract to a new account (`newOwner`).
757    * Can only be called by the current owner.
758    */
759   function transferOwnership(address newOwner) public virtual onlyOwner {
760     require(newOwner != address(0), 'Ownable: new owner is the zero address');
761     emit OwnershipTransferred(_owner, newOwner);
762     _owner = newOwner;
763   }
764 }
765 
766 // File: contracts/MasterChefMod.sol
767 
768 pragma solidity >=0.6.0 <0.8.0;
769 
770 contract MasterChefMod is Ownable {
771   using SafeMath for uint256;
772   using SafeERC20 for IERC20;
773 
774   event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
775   event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
776   event Claim(address indexed user, uint256 indexed pid, uint256 amount);
777   event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
778 
779   /// @notice Detail of each user.
780   struct UserInfo {
781     uint256 amount; // Number of tokens staked
782     uint256 rewardDebt; // A base for future reward claims. Works as a threshold, updated on each reward claim
783     //
784     // At any point in time, pending user reward for a given pool is:
785     // pending reward = (user.amount * pool.accRewardPerShare) - user.rewardFloor
786     //
787     // Whenever a user deposits or withdraws a pool token:
788     //   1. The pool's `accRewardPerShare` (and `lastUpdate`) gets updated.
789     //   2. User receives the pending reward sent to their address.
790     //   3. User's `amount` gets updated.
791     //   4. User's `rewardFloor` gets updated.
792   }
793 
794   /// @notice Detail of each pool.
795   struct PoolInfo {
796     address token; // Token to stake.
797     uint256 allocPoint; // How many allocation points assigned to this pool. Rewards to distribute per second.
798     uint256 lastUpdateTime; // Last time that distribution happened.
799     uint256 accRewardPerShare; // Accumulated rewards per share.
800     uint256 totalStaked; // Amount of tokens staked in the pool.
801     uint256 accUndistributedReward; // Accumulated rewards when a pool has no stake in it.
802   }
803 
804   /// @dev Division precision.
805   uint256 private precision = 1e18;
806 
807   /// @dev Reward token balance.
808   uint256 public rewardTokenBalance;
809 
810   /// @notice Total allocation points. Must be the sum of all allocation points in all pools.
811   uint256 public totalAllocPoint;
812 
813   /// @notice Time of the contract deployment.
814   uint256 public timeDeployed;
815 
816   /// @notice Total rewards accumulated since contract deployment.
817   uint256 public totalRewards;
818 
819   /// @notice Reward token.
820   address public rewardToken;
821 
822   /// @notice Detail of each pool.
823   PoolInfo[] public poolInfo;
824 
825   /// @notice Period in which the latest distribution of rewards will end.
826   uint256 public periodFinish;
827 
828   /// @notice Reward rate per second. Has increased precision (when doing math with it, do div(precision))
829   uint256 public rewardRate;
830 
831   ///  @notice New rewards are equaly split between the duration.
832   uint256 public rewardsDuration;
833 
834   /// @notice Detail of each user who stakes tokens.
835   mapping(uint256 => mapping(address => UserInfo)) public userInfo;
836   mapping(address => bool) private poolToken;
837 
838   constructor(address _rewardToken, uint256 _rewardsDuration) {
839     rewardToken = _rewardToken;
840     rewardsDuration = _rewardsDuration;
841     timeDeployed = block.timestamp;
842     periodFinish = timeDeployed.add(rewardsDuration);
843   }
844 
845   /// @notice Average reward per second generated since contract deployment.
846   function avgRewardsPerSecondTotal() external view returns (uint256 avgPerSecond) {
847     return totalRewards.div(block.timestamp.sub(timeDeployed));
848   }
849 
850   /// @notice Total pools.
851   function poolLength() external view returns (uint256) {
852     return poolInfo.length;
853   }
854 
855   /// @notice Display user rewards for a specific pool.
856   function pendingReward(uint256 _pid, address _user) public view returns (uint256) {
857     PoolInfo storage pool = poolInfo[_pid];
858     UserInfo storage user = userInfo[_pid][_user];
859     uint256 accRewardPerShare = pool.accRewardPerShare;
860 
861     if (pool.totalStaked != 0 && totalAllocPoint != 0) {
862       accRewardPerShare = accRewardPerShare.add(
863         _getPoolRewardsSinceLastUpdate(_pid).mul(precision).div(pool.totalStaked)
864       );
865     }
866 
867     return user.amount.mul(accRewardPerShare).div(precision).sub(user.rewardDebt);
868   }
869 
870   /// @notice Add a new pool.
871   function add(
872     uint256 _allocPoint,
873     address _token,
874     bool _withUpdate
875   ) public onlyOwner {
876     if (_withUpdate) {
877       massUpdatePools();
878     }
879 
880     require(
881       poolToken[address(_token)] == false,
882       'MasterChefMod: Stake token has already been added'
883     );
884 
885     totalAllocPoint = totalAllocPoint.add(_allocPoint);
886 
887     poolInfo.push(
888       PoolInfo({
889         token: _token,
890         allocPoint: _allocPoint,
891         lastUpdateTime: block.timestamp,
892         accRewardPerShare: 0,
893         totalStaked: 0,
894         accUndistributedReward: 0
895       })
896     );
897 
898     poolToken[address(_token)] = true;
899   }
900 
901   /// @notice Update the given pool's allocation point.
902   function set(
903     uint256 _pid,
904     uint256 _allocPoint,
905     bool _withUpdate
906   ) public onlyOwner {
907     if (_withUpdate) {
908       massUpdatePools();
909     }
910 
911     totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
912     poolInfo[_pid].allocPoint = _allocPoint;
913   }
914 
915   /// @notice Deposit tokens to pool for reward allocation.
916   function deposit(uint256 _pid, uint256 _amount) public {
917     PoolInfo storage pool = poolInfo[_pid];
918     UserInfo storage user = userInfo[_pid][msg.sender];
919 
920     _updatePool(_pid);
921 
922     uint256 pending;
923 
924     if (pool.totalStaked == 0) {
925       // Special case: no one was staking, the pool was accumulating rewards.
926       pending = pool.accUndistributedReward;
927       pool.accUndistributedReward = 0;
928     }
929     if (user.amount != 0) {
930       pending = _getUserPendingReward(_pid);
931     }
932 
933     _claimFromPool(_pid, pending);
934     _transferAmountIn(_pid, _amount);
935     _updateRewardDebt(_pid);
936 
937     emit Deposit(msg.sender, _pid, _amount);
938   }
939 
940   // Withdraw tokens from pool. Claims rewards implicitly (only claims rewards when called with _amount = 0)
941   function withdraw(uint256 _pid, uint256 _amount) public {
942     UserInfo storage user = userInfo[_pid][msg.sender];
943     require(user.amount >= _amount, 'MasterChefMod: Withdraw amount is greater than user stake.');
944 
945     _updatePool(_pid);
946     _claimFromPool(_pid, _getUserPendingReward(_pid));
947     _transferAmountOut(_pid, _amount);
948     _updateRewardDebt(_pid);
949 
950     emit Withdraw(msg.sender, _pid, _amount);
951   }
952 
953   // Withdraw without caring about rewards. EMERGENCY ONLY.
954   // !Caution this will remove all your pending rewards!
955   function emergencyWithdraw(uint256 _pid) public {
956     PoolInfo storage pool = poolInfo[_pid];
957     UserInfo storage user = userInfo[_pid][msg.sender];
958 
959     uint256 _amount = user.amount;
960     user.amount = 0;
961     user.rewardDebt = 0;
962     pool.totalStaked = pool.totalStaked.sub(_amount);
963 
964     IERC20(pool.token).safeTransfer(address(msg.sender), _amount);
965     emit EmergencyWithdraw(msg.sender, _pid, _amount);
966     // No mass update dont update pending rewards
967   }
968 
969   /// Adds and evenly distributes any rewards that were sent to the contract since last reward update.
970   function updateRewards(uint256 amount) external onlyOwner {
971     require(amount != 0, 'MasterChefMod: Reward amount must be greater than zero');
972 
973     IERC20(rewardToken).safeTransferFrom(msg.sender, address(this), amount);
974     rewardTokenBalance = rewardTokenBalance.add(amount);
975 
976     if (totalAllocPoint == 0) {
977       return;
978     }
979 
980     massUpdatePools();
981 
982     // note: if increasing rewards after the last period has ended, just divide the amount by period length
983     if (block.timestamp >= periodFinish) {
984       rewardRate = amount.mul(precision).div(rewardsDuration);
985     } else {
986       uint256 periodSecondsLeft = periodFinish.sub(block.timestamp);
987       uint256 periodRewardsLeft = periodSecondsLeft.mul(rewardRate);
988       rewardRate = periodRewardsLeft.add(amount.mul(precision)).div(rewardsDuration);
989     }
990 
991     totalRewards = totalRewards.add(amount);
992     periodFinish = block.timestamp.add(rewardsDuration);
993   }
994 
995   /// @notice Updates rewards for all pools by adding pending rewards.
996   /// Can spend a lot of gas.
997   function massUpdatePools() public {
998     uint256 length = poolInfo.length;
999     for (uint256 pid = 0; pid < length; ++pid) {
1000       _updatePool(pid);
1001     }
1002   }
1003 
1004   /// @notice Keeps pool properties (lastUpdateTime, accRewardPerShare, accUndistributedReward) up to date.
1005   function _updatePool(uint256 _pid) internal {
1006     if (totalAllocPoint == 0) return;
1007 
1008     PoolInfo storage pool = poolInfo[_pid];
1009     uint256 poolRewards = _getPoolRewardsSinceLastUpdate(_pid);
1010 
1011     if (pool.totalStaked == 0) {
1012       pool.accRewardPerShare = pool.accRewardPerShare.add(poolRewards);
1013       pool.accUndistributedReward = pool.accUndistributedReward.add(poolRewards);
1014     } else {
1015       pool.accRewardPerShare = pool.accRewardPerShare.add(
1016         poolRewards.mul(precision).div(pool.totalStaked)
1017       );
1018     }
1019 
1020     pool.lastUpdateTime = block.timestamp;
1021   }
1022 
1023   function _getPoolRewardsSinceLastUpdate(uint256 _pid)
1024     internal
1025     view
1026     returns (uint256 _poolRewards)
1027   {
1028     PoolInfo storage pool = poolInfo[_pid];
1029     uint256 lastTimeRewardApplicable = Math.min(block.timestamp, periodFinish);
1030     uint256 numSeconds = Math.max(lastTimeRewardApplicable.sub(pool.lastUpdateTime), 0);
1031     return numSeconds.mul(rewardRate).mul(pool.allocPoint).div(totalAllocPoint).div(precision);
1032   }
1033 
1034   function _safeRewardTokenTransfer(address _to, uint256 _amount)
1035     internal
1036     returns (uint256 _claimed)
1037   {
1038     _claimed = Math.min(_amount, rewardTokenBalance);
1039     IERC20(rewardToken).transfer(_to, _claimed);
1040     rewardTokenBalance = rewardTokenBalance.sub(_claimed);
1041   }
1042 
1043   function withdrawStuckTokens(address _token, uint256 _amount) public onlyOwner {
1044     require(_token != address(rewardToken), 'MasterChefMod: Cannot withdraw reward tokens');
1045     require(poolToken[address(_token)] == false, 'MasterChefMod: Cannot withdraw stake tokens');
1046     IERC20(_token).safeTransfer(msg.sender, _amount);
1047   }
1048 
1049   function _getUserPendingReward(uint256 _pid) internal view returns (uint256 _reward) {
1050     PoolInfo storage pool = poolInfo[_pid];
1051     UserInfo storage user = userInfo[_pid][msg.sender];
1052     return user.amount.mul(pool.accRewardPerShare).div(precision).sub(user.rewardDebt);
1053   }
1054 
1055   function _claimFromPool(uint256 _pid, uint256 _amount) internal {
1056     if (_amount != 0) {
1057       uint256 amountClaimed = _safeRewardTokenTransfer(msg.sender, _amount);
1058       emit Claim(msg.sender, _pid, amountClaimed);
1059     }
1060   }
1061 
1062   function _transferAmountIn(uint256 _pid, uint256 _amount) internal {
1063     PoolInfo storage pool = poolInfo[_pid];
1064     UserInfo storage user = userInfo[_pid][msg.sender];
1065 
1066     if (_amount != 0) {
1067       IERC20(pool.token).safeTransferFrom(msg.sender, address(this), _amount);
1068       user.amount = user.amount.add(_amount);
1069       pool.totalStaked = pool.totalStaked.add(_amount);
1070     }
1071   }
1072 
1073   function _transferAmountOut(uint256 _pid, uint256 _amount) internal {
1074     PoolInfo storage pool = poolInfo[_pid];
1075     UserInfo storage user = userInfo[_pid][msg.sender];
1076 
1077     if (_amount != 0) {
1078       IERC20(pool.token).safeTransfer(msg.sender, _amount);
1079       user.amount = user.amount.sub(_amount);
1080       pool.totalStaked = pool.totalStaked.sub(_amount);
1081     }
1082   }
1083 
1084   function _updateRewardDebt(uint256 _pid) internal {
1085     UserInfo storage user = userInfo[_pid][msg.sender];
1086     user.rewardDebt = user.amount.mul(poolInfo[_pid].accRewardPerShare).div(precision);
1087   }
1088 }