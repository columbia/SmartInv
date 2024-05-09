1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-02
3 */
4 
5 // Sources flattened with hardhat v2.4.1 https://hardhat.org
6 
7 // File @openzeppelin/contracts/math/Math.sol@v3.4.1
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity >=0.6.0 <0.8.0;
12 
13 /**
14  * @dev Standard math utilities missing in the Solidity language.
15  */
16 library Math {
17     /**
18      * @dev Returns the largest of two numbers.
19      */
20     function max(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a >= b ? a : b;
22     }
23 
24     /**
25      * @dev Returns the smallest of two numbers.
26      */
27     function min(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a < b ? a : b;
29     }
30 
31     /**
32      * @dev Returns the average of two numbers. The result is rounded towards
33      * zero.
34      */
35     function average(uint256 a, uint256 b) internal pure returns (uint256) {
36         // (a + b) / 2 can overflow, so we distribute
37         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
38     }
39 }
40 
41 
42 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
43 
44 // SPDX-License-Identifier: MIT
45 
46 pragma solidity >=0.6.0 <0.8.0;
47 
48 /**
49  * @dev Interface of the ERC20 standard as defined in the EIP.
50  */
51 interface IERC20 {
52     /**
53      * @dev Returns the amount of tokens in existence.
54      */
55     function totalSupply() external view returns (uint256);
56 
57     /**
58      * @dev Returns the amount of tokens owned by `account`.
59      */
60     function balanceOf(address account) external view returns (uint256);
61 
62     /**
63      * @dev Moves `amount` tokens from the caller's account to `recipient`.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transfer(address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Returns the remaining number of tokens that `spender` will be
73      * allowed to spend on behalf of `owner` through {transferFrom}. This is
74      * zero by default.
75      *
76      * This value changes when {approve} or {transferFrom} are called.
77      */
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80     /**
81      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * IMPORTANT: Beware that changing an allowance with this method brings the risk
86      * that someone may use both the old and the new allowance by unfortunate
87      * transaction ordering. One possible solution to mitigate this race
88      * condition is to first reduce the spender's allowance to 0 and set the
89      * desired value afterwards:
90      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
91      *
92      * Emits an {Approval} event.
93      */
94     function approve(address spender, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Moves `amount` tokens from `sender` to `recipient` using the
98      * allowance mechanism. `amount` is then deducted from the caller's
99      * allowance.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Emitted when `value` tokens are moved from one account (`from`) to
109      * another (`to`).
110      *
111      * Note that `value` may be zero.
112      */
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     /**
116      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
117      * a call to {approve}. `value` is the new allowance.
118      */
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 
123 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
124 
125 // SPDX-License-Identifier: MIT
126 
127 pragma solidity >=0.6.0 <0.8.0;
128 
129 /*
130  * @dev Provides information about the current execution context, including the
131  * sender of the transaction and its data. While these are generally available
132  * via msg.sender and msg.data, they should not be accessed in such a direct
133  * manner, since when dealing with GSN meta-transactions the account sending and
134  * paying for execution may not be the actual sender (as far as an application
135  * is concerned).
136  *
137  * This contract is only required for intermediate, library-like contracts.
138  */
139 abstract contract Context {
140     function _msgSender() internal view virtual returns (address payable) {
141         return msg.sender;
142     }
143 
144     function _msgData() internal view virtual returns (bytes memory) {
145         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
146         return msg.data;
147     }
148 }
149 
150 
151 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
152 
153 // SPDX-License-Identifier: MIT
154 
155 pragma solidity >=0.6.0 <0.8.0;
156 
157 /**
158  * @dev Contract module which provides a basic access control mechanism, where
159  * there is an account (an owner) that can be granted exclusive access to
160  * specific functions.
161  *
162  * By default, the owner account will be the one that deploys the contract. This
163  * can later be changed with {transferOwnership}.
164  *
165  * This module is used through inheritance. It will make available the modifier
166  * `onlyOwner`, which can be applied to your functions to restrict their use to
167  * the owner.
168  */
169 abstract contract Ownable is Context {
170     address private _owner;
171 
172     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
173 
174     /**
175      * @dev Initializes the contract setting the deployer as the initial owner.
176      */
177     constructor () internal {
178         address msgSender = _msgSender();
179         _owner = msgSender;
180         emit OwnershipTransferred(address(0), msgSender);
181     }
182 
183     /**
184      * @dev Returns the address of the current owner.
185      */
186     function owner() public view virtual returns (address) {
187         return _owner;
188     }
189 
190     /**
191      * @dev Throws if called by any account other than the owner.
192      */
193     modifier onlyOwner() {
194         require(owner() == _msgSender(), "Ownable: caller is not the owner");
195         _;
196     }
197 
198     /**
199      * @dev Leaves the contract without owner. It will not be possible to call
200      * `onlyOwner` functions anymore. Can only be called by the current owner.
201      *
202      * NOTE: Renouncing ownership will leave the contract without an owner,
203      * thereby removing any functionality that is only available to the owner.
204      */
205     function renounceOwnership() public virtual onlyOwner {
206         emit OwnershipTransferred(_owner, address(0));
207         _owner = address(0);
208     }
209 
210     /**
211      * @dev Transfers ownership of the contract to a new account (`newOwner`).
212      * Can only be called by the current owner.
213      */
214     function transferOwnership(address newOwner) public virtual onlyOwner {
215         require(newOwner != address(0), "Ownable: new owner is the zero address");
216         emit OwnershipTransferred(_owner, newOwner);
217         _owner = newOwner;
218     }
219 }
220 
221 
222 // File contracts/IRewardDistributionRecipient.sol
223 
224 // SPDX-License-Identifier: MIT
225 
226 pragma solidity ^0.6.2;
227 
228 abstract contract IRewardDistributionRecipient is Ownable {
229     address rewardDistribution;
230 
231     function notifyRewardAmount(uint256 reward) external virtual;
232 
233     modifier onlyRewardDistribution() {
234         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
235         _;
236     }
237 
238     function setRewardDistribution(address _rewardDistribution)
239         public
240         /* external */
241         onlyOwner
242     {
243         rewardDistribution = _rewardDistribution;
244     }
245 }
246 
247 
248 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
249 
250 // SPDX-License-Identifier: MIT
251 
252 pragma solidity >=0.6.0 <0.8.0;
253 
254 /**
255  * @dev Wrappers over Solidity's arithmetic operations with added overflow
256  * checks.
257  *
258  * Arithmetic operations in Solidity wrap on overflow. This can easily result
259  * in bugs, because programmers usually assume that an overflow raises an
260  * error, which is the standard behavior in high level programming languages.
261  * `SafeMath` restores this intuition by reverting the transaction when an
262  * operation overflows.
263  *
264  * Using this library instead of the unchecked operations eliminates an entire
265  * class of bugs, so it's recommended to use it always.
266  */
267 library SafeMath {
268     /**
269      * @dev Returns the addition of two unsigned integers, with an overflow flag.
270      *
271      * _Available since v3.4._
272      */
273     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
274         uint256 c = a + b;
275         if (c < a) return (false, 0);
276         return (true, c);
277     }
278 
279     /**
280      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
281      *
282      * _Available since v3.4._
283      */
284     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
285         if (b > a) return (false, 0);
286         return (true, a - b);
287     }
288 
289     /**
290      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
291      *
292      * _Available since v3.4._
293      */
294     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
295         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
296         // benefit is lost if 'b' is also tested.
297         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
298         if (a == 0) return (true, 0);
299         uint256 c = a * b;
300         if (c / a != b) return (false, 0);
301         return (true, c);
302     }
303 
304     /**
305      * @dev Returns the division of two unsigned integers, with a division by zero flag.
306      *
307      * _Available since v3.4._
308      */
309     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
310         if (b == 0) return (false, 0);
311         return (true, a / b);
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
316      *
317      * _Available since v3.4._
318      */
319     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
320         if (b == 0) return (false, 0);
321         return (true, a % b);
322     }
323 
324     /**
325      * @dev Returns the addition of two unsigned integers, reverting on
326      * overflow.
327      *
328      * Counterpart to Solidity's `+` operator.
329      *
330      * Requirements:
331      *
332      * - Addition cannot overflow.
333      */
334     function add(uint256 a, uint256 b) internal pure returns (uint256) {
335         uint256 c = a + b;
336         require(c >= a, "SafeMath: addition overflow");
337         return c;
338     }
339 
340     /**
341      * @dev Returns the subtraction of two unsigned integers, reverting on
342      * overflow (when the result is negative).
343      *
344      * Counterpart to Solidity's `-` operator.
345      *
346      * Requirements:
347      *
348      * - Subtraction cannot overflow.
349      */
350     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
351         require(b <= a, "SafeMath: subtraction overflow");
352         return a - b;
353     }
354 
355     /**
356      * @dev Returns the multiplication of two unsigned integers, reverting on
357      * overflow.
358      *
359      * Counterpart to Solidity's `*` operator.
360      *
361      * Requirements:
362      *
363      * - Multiplication cannot overflow.
364      */
365     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
366         if (a == 0) return 0;
367         uint256 c = a * b;
368         require(c / a == b, "SafeMath: multiplication overflow");
369         return c;
370     }
371 
372     /**
373      * @dev Returns the integer division of two unsigned integers, reverting on
374      * division by zero. The result is rounded towards zero.
375      *
376      * Counterpart to Solidity's `/` operator. Note: this function uses a
377      * `revert` opcode (which leaves remaining gas untouched) while Solidity
378      * uses an invalid opcode to revert (consuming all remaining gas).
379      *
380      * Requirements:
381      *
382      * - The divisor cannot be zero.
383      */
384     function div(uint256 a, uint256 b) internal pure returns (uint256) {
385         require(b > 0, "SafeMath: division by zero");
386         return a / b;
387     }
388 
389     /**
390      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
391      * reverting when dividing by zero.
392      *
393      * Counterpart to Solidity's `%` operator. This function uses a `revert`
394      * opcode (which leaves remaining gas untouched) while Solidity uses an
395      * invalid opcode to revert (consuming all remaining gas).
396      *
397      * Requirements:
398      *
399      * - The divisor cannot be zero.
400      */
401     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
402         require(b > 0, "SafeMath: modulo by zero");
403         return a % b;
404     }
405 
406     /**
407      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
408      * overflow (when the result is negative).
409      *
410      * CAUTION: This function is deprecated because it requires allocating memory for the error
411      * message unnecessarily. For custom revert reasons use {trySub}.
412      *
413      * Counterpart to Solidity's `-` operator.
414      *
415      * Requirements:
416      *
417      * - Subtraction cannot overflow.
418      */
419     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
420         require(b <= a, errorMessage);
421         return a - b;
422     }
423 
424     /**
425      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
426      * division by zero. The result is rounded towards zero.
427      *
428      * CAUTION: This function is deprecated because it requires allocating memory for the error
429      * message unnecessarily. For custom revert reasons use {tryDiv}.
430      *
431      * Counterpart to Solidity's `/` operator. Note: this function uses a
432      * `revert` opcode (which leaves remaining gas untouched) while Solidity
433      * uses an invalid opcode to revert (consuming all remaining gas).
434      *
435      * Requirements:
436      *
437      * - The divisor cannot be zero.
438      */
439     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
440         require(b > 0, errorMessage);
441         return a / b;
442     }
443 
444     /**
445      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
446      * reverting with custom message when dividing by zero.
447      *
448      * CAUTION: This function is deprecated because it requires allocating memory for the error
449      * message unnecessarily. For custom revert reasons use {tryMod}.
450      *
451      * Counterpart to Solidity's `%` operator. This function uses a `revert`
452      * opcode (which leaves remaining gas untouched) while Solidity uses an
453      * invalid opcode to revert (consuming all remaining gas).
454      *
455      * Requirements:
456      *
457      * - The divisor cannot be zero.
458      */
459     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
460         require(b > 0, errorMessage);
461         return a % b;
462     }
463 }
464 
465 
466 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
467 
468 // SPDX-License-Identifier: MIT
469 
470 pragma solidity >=0.6.2 <0.8.0;
471 
472 /**
473  * @dev Collection of functions related to the address type
474  */
475 library Address {
476     /**
477      * @dev Returns true if `account` is a contract.
478      *
479      * [IMPORTANT]
480      * ====
481      * It is unsafe to assume that an address for which this function returns
482      * false is an externally-owned account (EOA) and not a contract.
483      *
484      * Among others, `isContract` will return false for the following
485      * types of addresses:
486      *
487      *  - an externally-owned account
488      *  - a contract in construction
489      *  - an address where a contract will be created
490      *  - an address where a contract lived, but was destroyed
491      * ====
492      */
493     function isContract(address account) internal view returns (bool) {
494         // This method relies on extcodesize, which returns 0 for contracts in
495         // construction, since the code is only stored at the end of the
496         // constructor execution.
497 
498         uint256 size;
499         // solhint-disable-next-line no-inline-assembly
500         assembly { size := extcodesize(account) }
501         return size > 0;
502     }
503 
504     /**
505      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
506      * `recipient`, forwarding all available gas and reverting on errors.
507      *
508      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
509      * of certain opcodes, possibly making contracts go over the 2300 gas limit
510      * imposed by `transfer`, making them unable to receive funds via
511      * `transfer`. {sendValue} removes this limitation.
512      *
513      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
514      *
515      * IMPORTANT: because control is transferred to `recipient`, care must be
516      * taken to not create reentrancy vulnerabilities. Consider using
517      * {ReentrancyGuard} or the
518      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
519      */
520     function sendValue(address payable recipient, uint256 amount) internal {
521         require(address(this).balance >= amount, "Address: insufficient balance");
522 
523         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
524         (bool success, ) = recipient.call{ value: amount }("");
525         require(success, "Address: unable to send value, recipient may have reverted");
526     }
527 
528     /**
529      * @dev Performs a Solidity function call using a low level `call`. A
530      * plain`call` is an unsafe replacement for a function call: use this
531      * function instead.
532      *
533      * If `target` reverts with a revert reason, it is bubbled up by this
534      * function (like regular Solidity function calls).
535      *
536      * Returns the raw returned data. To convert to the expected return value,
537      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
538      *
539      * Requirements:
540      *
541      * - `target` must be a contract.
542      * - calling `target` with `data` must not revert.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
547       return functionCall(target, data, "Address: low-level call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
552      * `errorMessage` as a fallback revert reason when `target` reverts.
553      *
554      * _Available since v3.1._
555      */
556     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
557         return functionCallWithValue(target, data, 0, errorMessage);
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
562      * but also transferring `value` wei to `target`.
563      *
564      * Requirements:
565      *
566      * - the calling contract must have an ETH balance of at least `value`.
567      * - the called Solidity function must be `payable`.
568      *
569      * _Available since v3.1._
570      */
571     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
572         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
577      * with `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
582         require(address(this).balance >= value, "Address: insufficient balance for call");
583         require(isContract(target), "Address: call to non-contract");
584 
585         // solhint-disable-next-line avoid-low-level-calls
586         (bool success, bytes memory returndata) = target.call{ value: value }(data);
587         return _verifyCallResult(success, returndata, errorMessage);
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
592      * but performing a static call.
593      *
594      * _Available since v3.3._
595      */
596     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
597         return functionStaticCall(target, data, "Address: low-level static call failed");
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
602      * but performing a static call.
603      *
604      * _Available since v3.3._
605      */
606     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
607         require(isContract(target), "Address: static call to non-contract");
608 
609         // solhint-disable-next-line avoid-low-level-calls
610         (bool success, bytes memory returndata) = target.staticcall(data);
611         return _verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a delegate call.
617      *
618      * _Available since v3.4._
619      */
620     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
621         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a delegate call.
627      *
628      * _Available since v3.4._
629      */
630     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
631         require(isContract(target), "Address: delegate call to non-contract");
632 
633         // solhint-disable-next-line avoid-low-level-calls
634         (bool success, bytes memory returndata) = target.delegatecall(data);
635         return _verifyCallResult(success, returndata, errorMessage);
636     }
637 
638     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
639         if (success) {
640             return returndata;
641         } else {
642             // Look for revert reason and bubble it up if present
643             if (returndata.length > 0) {
644                 // The easiest way to bubble the revert reason is using memory via assembly
645 
646                 // solhint-disable-next-line no-inline-assembly
647                 assembly {
648                     let returndata_size := mload(returndata)
649                     revert(add(32, returndata), returndata_size)
650                 }
651             } else {
652                 revert(errorMessage);
653             }
654         }
655     }
656 }
657 
658 
659 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
660 
661 // SPDX-License-Identifier: MIT
662 
663 pragma solidity >=0.6.0 <0.8.0;
664 
665 
666 
667 /**
668  * @title SafeERC20
669  * @dev Wrappers around ERC20 operations that throw on failure (when the token
670  * contract returns false). Tokens that return no value (and instead revert or
671  * throw on failure) are also supported, non-reverting calls are assumed to be
672  * successful.
673  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
674  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
675  */
676 library SafeERC20 {
677     using SafeMath for uint256;
678     using Address for address;
679 
680     function safeTransfer(IERC20 token, address to, uint256 value) internal {
681         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
682     }
683 
684     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
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
695     function safeApprove(IERC20 token, address spender, uint256 value) internal {
696         // safeApprove should only be called when setting an initial allowance,
697         // or when resetting it to zero. To increase and decrease it, use
698         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
699         // solhint-disable-next-line max-line-length
700         require((value == 0) || (token.allowance(address(this), spender) == 0),
701             "SafeERC20: approve from non-zero to non-zero allowance"
702         );
703         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
704     }
705 
706     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
707         uint256 newAllowance = token.allowance(address(this), spender).add(value);
708         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
709     }
710 
711     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
712         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
713         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
714     }
715 
716     /**
717      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
718      * on the return value: the return value is optional (but if data is returned, it must not be false).
719      * @param token The token targeted by the call.
720      * @param data The call data (encoded using abi.encode or one of its variants).
721      */
722     function _callOptionalReturn(IERC20 token, bytes memory data) private {
723         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
724         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
725         // the target address contains contract code and also asserts for success in the low-level call.
726 
727         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
728         if (returndata.length > 0) { // Return data is optional
729             // solhint-disable-next-line max-line-length
730             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
731         }
732     }
733 }
734 
735 
736 // File contracts/LPTokenWrapper.sol
737 
738 // SPDX-License-Identifier: MIT
739 
740 pragma solidity ^0.6.2;
741 
742 
743 
744 contract LPTokenWrapper {
745     using SafeMath for uint256;
746     using SafeERC20 for IERC20;
747 
748     IERC20 public stakeToken;
749 
750     uint256 private _totalSupply;
751     mapping(address => uint256) private _balances;
752 
753     function totalSupply() public view returns (uint256) {
754         return _totalSupply;
755     }
756 
757     function balanceOf(address account) public view returns (uint256) {
758         return _balances[account];
759     }
760 
761     function stake(uint256 amount) public virtual {
762         _totalSupply = _totalSupply.add(amount);
763         _balances[msg.sender] = _balances[msg.sender].add(amount);
764         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
765     }
766 
767     function withdraw(uint256 amount) public virtual {
768         _totalSupply = _totalSupply.sub(amount);
769         _balances[msg.sender] = _balances[msg.sender].sub(amount);
770         stakeToken.safeTransfer(msg.sender, amount);
771     }
772 }
773 
774 
775 // File contracts/interfaces/IEmiswap.sol
776 
777 // SPDX-License-Identifier: UNLICENSED
778 
779 pragma solidity ^0.6.2;
780 
781 interface IEmiswapRegistry {
782     function pools(IERC20 token1, IERC20 token2) external view returns (IEmiswap);
783 
784     function isPool(address addr) external view returns (bool);
785 
786     function deploy(IERC20 tokenA, IERC20 tokenB) external returns (IEmiswap);
787 
788     function getAllPools() external view returns (IEmiswap[] memory);
789 }
790 
791 interface IEmiswap {
792     function fee() external view returns (uint256);
793 
794     function tokens(uint256 i) external view returns (IERC20);
795 
796     function deposit(
797         uint256[] calldata amounts,
798         uint256[] calldata minAmounts,
799         address referral
800     ) external payable returns (uint256 fairSupply);
801 
802     function withdraw(uint256 amount, uint256[] calldata minReturns) external;
803 
804     function getBalanceForAddition(IERC20 token) external view returns (uint256);
805 
806     function getBalanceForRemoval(IERC20 token) external view returns (uint256);
807 
808     function getReturn(
809         IERC20 fromToken,
810         IERC20 destToken,
811         uint256 amount
812     ) external view returns (uint256, uint256);
813 
814     function swap(
815         IERC20 fromToken,
816         IERC20 destToken,
817         uint256 amount,
818         uint256 minReturn,
819         address to,
820         address referral
821     ) external payable returns (uint256 returnAmount);
822 
823     function initialize(IERC20[] calldata assets) external;
824 }
825 
826 
827 // File contracts/libraries/EmiswapLib.sol
828 
829 // SPDX-License-Identifier: UNLICENSED
830 
831 pragma solidity ^0.6.2;
832 
833 
834 
835 library EmiswapLib {
836     using SafeMath for uint256;
837     uint256 public constant FEE_DENOMINATOR = 1e18;
838 
839     function previewSwapExactTokenForToken(
840         address factory,
841         address tokenFrom,
842         address tokenTo,
843         uint256 ammountFrom
844     ) internal view returns (uint256 ammountTo) {
845         IEmiswap pairContract = IEmiswapRegistry(factory).pools(IERC20(tokenFrom), IERC20(tokenTo));
846 
847         if (pairContract != IEmiswap(0)) {
848             (, ammountTo) = pairContract.getReturn(IERC20(tokenFrom), IERC20(tokenTo), ammountFrom);
849         }
850     }
851 
852     /**************************************************************************************
853      * get preview result of virtual swap by route of tokens
854      **************************************************************************************/
855     function previewSwapbyRoute(
856         address factory,
857         address[] memory path,
858         uint256 ammountFrom
859     ) internal view returns (uint256 ammountTo) {
860         for (uint256 i = 0; i < path.length - 1; i++) {
861             if (path.length >= 2) {
862                 ammountTo = previewSwapExactTokenForToken(factory, path[i], path[i + 1], ammountFrom);
863 
864                 if (i == (path.length - 2)) {
865                     return (ammountTo);
866                 } else {
867                     ammountFrom = ammountTo;
868                 }
869             }
870         }
871     }
872 
873     function fee(address factory) internal view returns (uint256) {
874         return IEmiswap(factory).fee();
875     }
876 
877     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
878     function getAmountIn(
879         address factory,
880         uint256 amountOut,
881         uint256 reserveIn,
882         uint256 reserveOut
883     ) internal view returns (uint256 amountIn) {
884         require(amountOut > 0, "EmiswapLibrary: INSUFFICIENT_OUTPUT_AMOUNT");
885         require(reserveIn > 0 && reserveOut > 0, "EmiswapLibrary: INSUFFICIENT_LIQUIDITY");
886         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
887         uint256 denominator = reserveOut.sub(amountOut).mul(uint256(1000000000000000000).sub(fee(factory)).div(1e15)); // 997
888         amountIn = (numerator / denominator).add(1);
889     }
890 
891     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
892     function getAmountOut(
893         address factory,
894         uint256 amountIn,
895         uint256 reserveIn,
896         uint256 reserveOut
897     ) internal view returns (uint256 amountOut) {
898         if (amountIn == 0 || reserveIn == 0 || reserveOut == 0) {
899             return (0);
900         }
901 
902         uint256 amountInWithFee = amountIn.mul(uint256(1000000000000000000).sub(fee(factory)).div(1e15)); //997
903         uint256 numerator = amountInWithFee.mul(reserveOut);
904         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
905         amountOut = (denominator == 0 ? 0 : amountOut = numerator / denominator);
906     }
907 
908     // performs chained getAmountIn calculations on any number of pairs
909     function getAmountsIn(
910         address factory,
911         uint256 amountOut,
912         address[] memory path
913     ) internal view returns (uint256[] memory amounts) {
914         require(path.length >= 2, "EmiswapLibrary: INVALID_PATH");
915         amounts = new uint256[](path.length);
916         amounts[amounts.length - 1] = amountOut;
917         for (uint256 i = path.length - 1; i > 0; i--) {
918             IEmiswap pairContract = IEmiswapRegistry(factory).pools(IERC20(IERC20(path[i])), IERC20(path[i - 1]));
919 
920             uint256 reserveIn;
921             uint256 reserveOut;
922 
923             if (address(pairContract) != address(0)) {
924                 reserveIn = IEmiswap(pairContract).getBalanceForAddition(IERC20(path[i - 1]));
925                 reserveOut = IEmiswap(pairContract).getBalanceForRemoval(IERC20(path[i]));
926             }
927 
928             amounts[i - 1] = getAmountIn(factory, amounts[i], reserveIn, reserveOut);
929         }
930     }
931 
932     // performs chained getAmountOut calculations on any number of pairs
933     function getAmountsOut(
934         address factory,
935         uint256 amountIn,
936         address[] memory path
937     ) internal view returns (uint256[] memory amounts) {
938         require(path.length >= 2, "EmiswapLibrary: INVALID_PATH");
939         amounts = new uint256[](path.length);
940         amounts[0] = amountIn;
941         for (uint256 i = 0; i < path.length - 1; i++) {
942             IEmiswap pairContract = IEmiswapRegistry(factory).pools(IERC20(IERC20(path[i])), IERC20(path[i + 1]));
943 
944             uint256 reserveIn;
945             uint256 reserveOut;
946 
947             if (address(pairContract) != address(0)) {
948                 reserveIn = IEmiswap(pairContract).getBalanceForAddition(IERC20(path[i]));
949                 reserveOut = IEmiswap(pairContract).getBalanceForRemoval(IERC20(path[i + 1]));
950             }
951 
952             amounts[i + 1] = getAmountOut(factory, amounts[i], reserveIn, reserveOut);
953         }
954     }
955 
956     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
957     function quote(
958         uint256 amountA,
959         uint256 reserveA,
960         uint256 reserveB
961     ) internal pure returns (uint256 amountB) {
962         require(amountA > 0, "EmiswapLibrary: INSUFFICIENT_AMOUNT");
963         require(reserveA > 0 && reserveB > 0, "EmiswapLibrary: INSUFFICIENT_LIQUIDITY");
964         amountB = amountA.mul(reserveB) / reserveA;
965     }
966 }
967 
968 
969 
970 
971 // File contracts/RewardPool.sol
972 
973 // SPDX-License-Identifier: MIT
974 
975 pragma solidity ^0.6.2;
976 
977 
978 
979 
980 
981 
982 contract RewardPool is LPTokenWrapper, IRewardDistributionRecipient {
983     address public emiFactory;
984     uint256 public totalStakeLimit; // max value in USD coin (last in route), rememeber decimals!
985     address[] public route;
986     uint8 marketID;
987     uint8 id;
988 
989     IERC20 public rewardToken;
990     uint256 public minPriceAmount;
991     uint256 public constant DURATION = 90 days;
992 
993     uint256 public periodFinish = 0;
994     uint256 public periodStop = 0;
995     uint256 public rewardRate = 0;
996     uint256 public lastUpdateTime;
997     uint256 public rewardPerTokenStored;
998     uint256 public tokenMode; // 0 = simple ERC20 token, 1 = Emiswap LP-token
999     mapping(address => uint256) public userRewardPerTokenPaid;
1000     mapping(address => uint256) public rewards;
1001 
1002     event RewardAdded(uint256 reward);
1003     event Staked(address indexed user, uint256 amount);
1004     event Withdrawn(address indexed user, uint256 amount);
1005     event RewardPaid(address indexed user, uint256 reward);
1006 
1007     constructor(
1008         address _rewardToken,
1009         address _stakeToken,
1010         address rewardAdmin,
1011         uint256 _tokenMode,
1012         uint256 _totalStakeLimit,
1013         uint256 _minPriceAmount
1014     ) public {
1015         rewardToken = IERC20(_rewardToken);
1016         stakeToken = IERC20(_stakeToken);
1017         setRewardDistribution(rewardAdmin);
1018         tokenMode = _tokenMode;
1019         totalStakeLimit = _totalStakeLimit;
1020         minPriceAmount = _minPriceAmount;
1021     }
1022 
1023     modifier updateReward(address account) {
1024         rewardPerTokenStored = rewardPerToken();
1025         lastUpdateTime = lastTimeRewardApplicable();
1026         if (account != address(0)) {
1027             rewards[account] = earned(account);
1028             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1029         }
1030         _;
1031     }
1032 
1033     function setEmiPriceData(address _emiFactory, address[] memory _route) public onlyOwner {
1034         if (emiFactory != _emiFactory) {
1035             emiFactory = _emiFactory;
1036         }
1037         if (route.length > 0) {
1038             delete route;
1039         }
1040         for (uint256 index = 0; index < _route.length; index++) {
1041             route.push(_route[index]);
1042         }
1043     }
1044 
1045     function setTotalStakeLimit(uint256 _totalStakeLimit) public onlyOwner {
1046         require(totalStakeLimit != _totalStakeLimit);
1047         totalStakeLimit = _totalStakeLimit;
1048     }
1049 
1050     function setMinPriceAmount(uint256 newMinPriceAmount) public onlyOwner {
1051         minPriceAmount = newMinPriceAmount;
1052     }
1053 
1054     function lastTimeRewardApplicable() public view returns (uint256) {
1055         return Math.min(block.timestamp, periodFinish);
1056     }
1057 
1058     function rewardPerToken() public view returns (uint256) {
1059         if (totalSupply() == 0) {
1060             return rewardPerTokenStored;
1061         }
1062         return
1063             rewardPerTokenStored.add(
1064                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(totalSupply())
1065             );
1066     }
1067 
1068     function earned(address account) public view returns (uint256) {
1069         return
1070             balanceOf(account).mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(
1071                 rewards[account]
1072             );
1073     }
1074 
1075     function stake(uint256 amount) public override updateReward(msg.sender) {
1076         require(amount > 0, "Cannot stake 0");
1077         require(block.timestamp <= periodFinish && block.timestamp <= periodStop, "Cannot stake yet");
1078         super.stake(amount);
1079         (, uint256 totalStake) = getStakedValuesinUSD(msg.sender);
1080         require(totalStake <= totalStakeLimit, "Limit exceeded");
1081         emit Staked(msg.sender, amount);
1082     }
1083 
1084     function withdraw(uint256 amount) public override updateReward(msg.sender) {
1085         require(amount > 0, "Cannot withdraw 0");
1086         super.withdraw(amount);
1087         emit Withdrawn(msg.sender, amount);
1088     }
1089 
1090     function exit() external {
1091         withdraw(balanceOf(msg.sender));
1092         getReward();
1093     }
1094 
1095     function getReward() public updateReward(msg.sender) {
1096         uint256 reward = earned(msg.sender);
1097         if (reward > 0) {
1098             rewards[msg.sender] = 0;
1099             rewardToken.safeTransfer(msg.sender, reward);
1100             emit RewardPaid(msg.sender, reward);
1101         }
1102     }
1103 
1104     // use it after create and approve of reward token
1105 
1106     function notifyRewardAmount(uint256 reward) external override onlyRewardDistribution updateReward(address(0)) {
1107         if (block.timestamp >= periodFinish) {
1108             rewardRate = reward.div(DURATION);
1109         } else {
1110             uint256 remaining = periodFinish.sub(block.timestamp);
1111             uint256 leftover = remaining.mul(rewardRate);
1112             rewardRate = reward.add(leftover).div(DURATION);
1113         }
1114         lastUpdateTime = block.timestamp;
1115         periodFinish = block.timestamp.add(DURATION);
1116         periodStop = periodFinish;
1117         rewardToken.safeTransferFrom(msg.sender, address(this), reward);
1118         emit RewardAdded(reward);
1119     }
1120 
1121     function setPeriodStop(uint256 _periodStop) external onlyRewardDistribution {
1122         require(periodStop <= periodFinish, "Incorrect stop");
1123         periodStop = _periodStop;
1124     }
1125 
1126     function getStakedValuesinUSD(address wallet) public view returns (uint256 senderStake, uint256 totalStake) {
1127         uint256 price = getAmountOut(minPriceAmount, route); /*1e18 default value of ESW, first of route always ESW*/
1128         // simple ERC-20
1129         if (tokenMode == 0) {
1130             senderStake = balanceOf(wallet).mul(price).div(minPriceAmount);
1131             totalStake = totalSupply().mul(price).div(minPriceAmount);
1132         }
1133         if (tokenMode == 1) {
1134             /*uint256 lpFractionWallet = balanceOf(wallet).mul(1e18).div(stakeToken.totalSupply());
1135             uint256 lpFractionTotal = totalSupply().mul(1e18).div(stakeToken.totalSupply());
1136             uint256 ESWreserveWallet = IEmiswap(address(stakeToken)).getBalanceForAddition( IERC20(route[0]) ).mul(2).mul(lpFractionWallet).div(1e18);
1137             uint256 ESWreserveTotal = IEmiswap(address(stakeToken)).getBalanceForAddition( IERC20(route[0]) ).mul(2).mul(lpFractionTotal).div(1e18);
1138             senderStake = ESWreserveWallet.mul(price).div(minPriceAmount);
1139             totalStake = ESWreserveTotal.mul(price).div(minPriceAmount);*/
1140 
1141             senderStake = IEmiswap(address(stakeToken))
1142             .getBalanceForAddition(IERC20(route[0]))
1143             .mul(2)
1144             .mul(balanceOf(wallet).mul(1e18).div(stakeToken.totalSupply()))
1145             .div(1e18)
1146             .mul(price)
1147             .div(minPriceAmount);
1148             totalStake = IEmiswap(address(stakeToken))
1149             .getBalanceForAddition(IERC20(route[0]))
1150             .mul(2)
1151             .mul(totalSupply().mul(1e18).div(stakeToken.totalSupply()))
1152             .div(1e18)
1153             .mul(price)
1154             .div(minPriceAmount);
1155         }
1156     }
1157 
1158     function getAmountOut(uint256 amountIn, address[] memory path) public view returns (uint256) {
1159         return EmiswapLib.getAmountsOut(emiFactory, amountIn, path)[path.length - 1];
1160     }
1161 
1162     // ------------------------------------------------------------------------
1163     //
1164     // ------------------------------------------------------------------------
1165     /**
1166      * @dev Owner can transfer out any accidentally sent ERC20 tokens
1167      * @param tokenAddress Address of ERC-20 token to transfer
1168      * @param beneficiary Address to transfer to
1169      * @param amount of tokens to transfer
1170      */
1171     function transferAnyERC20Token(
1172         address tokenAddress,
1173         address beneficiary,
1174         uint256 amount
1175     ) public onlyOwner returns (bool success) {
1176         require(tokenAddress != address(0), "address 0!");
1177         require(tokenAddress != address(stakeToken), "not staketoken");
1178 
1179         return IERC20(tokenAddress).transfer(beneficiary, amount);
1180     }
1181 }