1 // SPDX-License-Identifier: NONE
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
83 // File: @openzeppelin/contracts/utils/Context.sol
84 
85 
86 pragma solidity >=0.6.0 <0.8.0;
87 
88 /*
89  * @dev Provides information about the current execution context, including the
90  * sender of the transaction and its data. While these are generally available
91  * via msg.sender and msg.data, they should not be accessed in such a direct
92  * manner, since when dealing with GSN meta-transactions the account sending and
93  * paying for execution may not be the actual sender (as far as an application
94  * is concerned).
95  *
96  * This contract is only required for intermediate, library-like contracts.
97  */
98 abstract contract Context {
99     function _msgSender() internal view virtual returns (address payable) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view virtual returns (bytes memory) {
104         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
105         return msg.data;
106     }
107 }
108 
109 // File: @openzeppelin/contracts/access/Ownable.sol
110 
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 abstract contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor () internal {
135         address msgSender = _msgSender();
136         _owner = msgSender;
137         emit OwnershipTransferred(address(0), msgSender);
138     }
139 
140     /**
141      * @dev Returns the address of the current owner.
142      */
143     function owner() public view virtual returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         require(owner() == _msgSender(), "Ownable: caller is not the owner");
152         _;
153     }
154 
155     /**
156      * @dev Leaves the contract without owner. It will not be possible to call
157      * `onlyOwner` functions anymore. Can only be called by the current owner.
158      *
159      * NOTE: Renouncing ownership will leave the contract without an owner,
160      * thereby removing any functionality that is only available to the owner.
161      */
162     function renounceOwnership() public virtual onlyOwner {
163         emit OwnershipTransferred(_owner, address(0));
164         _owner = address(0);
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Can only be called by the current owner.
170      */
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 }
177 
178 // File: @openzeppelin/contracts/math/SafeMath.sol
179 
180 
181 pragma solidity >=0.6.0 <0.8.0;
182 
183 /**
184  * @dev Wrappers over Solidity's arithmetic operations with added overflow
185  * checks.
186  *
187  * Arithmetic operations in Solidity wrap on overflow. This can easily result
188  * in bugs, because programmers usually assume that an overflow raises an
189  * error, which is the standard behavior in high level programming languages.
190  * `SafeMath` restores this intuition by reverting the transaction when an
191  * operation overflows.
192  *
193  * Using this library instead of the unchecked operations eliminates an entire
194  * class of bugs, so it's recommended to use it always.
195  */
196 library SafeMath {
197     /**
198      * @dev Returns the addition of two unsigned integers, with an overflow flag.
199      *
200      * _Available since v3.4._
201      */
202     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
203         uint256 c = a + b;
204         if (c < a) return (false, 0);
205         return (true, c);
206     }
207 
208     /**
209      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
210      *
211      * _Available since v3.4._
212      */
213     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
214         if (b > a) return (false, 0);
215         return (true, a - b);
216     }
217 
218     /**
219      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
220      *
221      * _Available since v3.4._
222      */
223     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
224         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
225         // benefit is lost if 'b' is also tested.
226         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
227         if (a == 0) return (true, 0);
228         uint256 c = a * b;
229         if (c / a != b) return (false, 0);
230         return (true, c);
231     }
232 
233     /**
234      * @dev Returns the division of two unsigned integers, with a division by zero flag.
235      *
236      * _Available since v3.4._
237      */
238     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
239         if (b == 0) return (false, 0);
240         return (true, a / b);
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
245      *
246      * _Available since v3.4._
247      */
248     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
249         if (b == 0) return (false, 0);
250         return (true, a % b);
251     }
252 
253     /**
254      * @dev Returns the addition of two unsigned integers, reverting on
255      * overflow.
256      *
257      * Counterpart to Solidity's `+` operator.
258      *
259      * Requirements:
260      *
261      * - Addition cannot overflow.
262      */
263     function add(uint256 a, uint256 b) internal pure returns (uint256) {
264         uint256 c = a + b;
265         require(c >= a, "SafeMath: addition overflow");
266         return c;
267     }
268 
269     /**
270      * @dev Returns the subtraction of two unsigned integers, reverting on
271      * overflow (when the result is negative).
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      *
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
280         require(b <= a, "SafeMath: subtraction overflow");
281         return a - b;
282     }
283 
284     /**
285      * @dev Returns the multiplication of two unsigned integers, reverting on
286      * overflow.
287      *
288      * Counterpart to Solidity's `*` operator.
289      *
290      * Requirements:
291      *
292      * - Multiplication cannot overflow.
293      */
294     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
295         if (a == 0) return 0;
296         uint256 c = a * b;
297         require(c / a == b, "SafeMath: multiplication overflow");
298         return c;
299     }
300 
301     /**
302      * @dev Returns the integer division of two unsigned integers, reverting on
303      * division by zero. The result is rounded towards zero.
304      *
305      * Counterpart to Solidity's `/` operator. Note: this function uses a
306      * `revert` opcode (which leaves remaining gas untouched) while Solidity
307      * uses an invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function div(uint256 a, uint256 b) internal pure returns (uint256) {
314         require(b > 0, "SafeMath: division by zero");
315         return a / b;
316     }
317 
318     /**
319      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
320      * reverting when dividing by zero.
321      *
322      * Counterpart to Solidity's `%` operator. This function uses a `revert`
323      * opcode (which leaves remaining gas untouched) while Solidity uses an
324      * invalid opcode to revert (consuming all remaining gas).
325      *
326      * Requirements:
327      *
328      * - The divisor cannot be zero.
329      */
330     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
331         require(b > 0, "SafeMath: modulo by zero");
332         return a % b;
333     }
334 
335     /**
336      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
337      * overflow (when the result is negative).
338      *
339      * CAUTION: This function is deprecated because it requires allocating memory for the error
340      * message unnecessarily. For custom revert reasons use {trySub}.
341      *
342      * Counterpart to Solidity's `-` operator.
343      *
344      * Requirements:
345      *
346      * - Subtraction cannot overflow.
347      */
348     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
349         require(b <= a, errorMessage);
350         return a - b;
351     }
352 
353     /**
354      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
355      * division by zero. The result is rounded towards zero.
356      *
357      * CAUTION: This function is deprecated because it requires allocating memory for the error
358      * message unnecessarily. For custom revert reasons use {tryDiv}.
359      *
360      * Counterpart to Solidity's `/` operator. Note: this function uses a
361      * `revert` opcode (which leaves remaining gas untouched) while Solidity
362      * uses an invalid opcode to revert (consuming all remaining gas).
363      *
364      * Requirements:
365      *
366      * - The divisor cannot be zero.
367      */
368     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
369         require(b > 0, errorMessage);
370         return a / b;
371     }
372 
373     /**
374      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
375      * reverting with custom message when dividing by zero.
376      *
377      * CAUTION: This function is deprecated because it requires allocating memory for the error
378      * message unnecessarily. For custom revert reasons use {tryMod}.
379      *
380      * Counterpart to Solidity's `%` operator. This function uses a `revert`
381      * opcode (which leaves remaining gas untouched) while Solidity uses an
382      * invalid opcode to revert (consuming all remaining gas).
383      *
384      * Requirements:
385      *
386      * - The divisor cannot be zero.
387      */
388     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
389         require(b > 0, errorMessage);
390         return a % b;
391     }
392 }
393 
394 // File: @openzeppelin/contracts/utils/Address.sol
395 
396 
397 pragma solidity >=0.6.2 <0.8.0;
398 
399 /**
400  * @dev Collection of functions related to the address type
401  */
402 library Address {
403     /**
404      * @dev Returns true if `account` is a contract.
405      *
406      * [IMPORTANT]
407      * ====
408      * It is unsafe to assume that an address for which this function returns
409      * false is an externally-owned account (EOA) and not a contract.
410      *
411      * Among others, `isContract` will return false for the following
412      * types of addresses:
413      *
414      *  - an externally-owned account
415      *  - a contract in construction
416      *  - an address where a contract will be created
417      *  - an address where a contract lived, but was destroyed
418      * ====
419      */
420     function isContract(address account) internal view returns (bool) {
421         // This method relies on extcodesize, which returns 0 for contracts in
422         // construction, since the code is only stored at the end of the
423         // constructor execution.
424 
425         uint256 size;
426         // solhint-disable-next-line no-inline-assembly
427         assembly { size := extcodesize(account) }
428         return size > 0;
429     }
430 
431     /**
432      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
433      * `recipient`, forwarding all available gas and reverting on errors.
434      *
435      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
436      * of certain opcodes, possibly making contracts go over the 2300 gas limit
437      * imposed by `transfer`, making them unable to receive funds via
438      * `transfer`. {sendValue} removes this limitation.
439      *
440      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
441      *
442      * IMPORTANT: because control is transferred to `recipient`, care must be
443      * taken to not create reentrancy vulnerabilities. Consider using
444      * {ReentrancyGuard} or the
445      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
446      */
447     function sendValue(address payable recipient, uint256 amount) internal {
448         require(address(this).balance >= amount, "Address: insufficient balance");
449 
450         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
451         (bool success, ) = recipient.call{ value: amount }("");
452         require(success, "Address: unable to send value, recipient may have reverted");
453     }
454 
455     /**
456      * @dev Performs a Solidity function call using a low level `call`. A
457      * plain`call` is an unsafe replacement for a function call: use this
458      * function instead.
459      *
460      * If `target` reverts with a revert reason, it is bubbled up by this
461      * function (like regular Solidity function calls).
462      *
463      * Returns the raw returned data. To convert to the expected return value,
464      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
465      *
466      * Requirements:
467      *
468      * - `target` must be a contract.
469      * - calling `target` with `data` must not revert.
470      *
471      * _Available since v3.1._
472      */
473     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
474       return functionCall(target, data, "Address: low-level call failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
479      * `errorMessage` as a fallback revert reason when `target` reverts.
480      *
481      * _Available since v3.1._
482      */
483     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
484         return functionCallWithValue(target, data, 0, errorMessage);
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
489      * but also transferring `value` wei to `target`.
490      *
491      * Requirements:
492      *
493      * - the calling contract must have an ETH balance of at least `value`.
494      * - the called Solidity function must be `payable`.
495      *
496      * _Available since v3.1._
497      */
498     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
499         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
504      * with `errorMessage` as a fallback revert reason when `target` reverts.
505      *
506      * _Available since v3.1._
507      */
508     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
509         require(address(this).balance >= value, "Address: insufficient balance for call");
510         require(isContract(target), "Address: call to non-contract");
511 
512         // solhint-disable-next-line avoid-low-level-calls
513         (bool success, bytes memory returndata) = target.call{ value: value }(data);
514         return _verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but performing a static call.
520      *
521      * _Available since v3.3._
522      */
523     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
524         return functionStaticCall(target, data, "Address: low-level static call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
534         require(isContract(target), "Address: static call to non-contract");
535 
536         // solhint-disable-next-line avoid-low-level-calls
537         (bool success, bytes memory returndata) = target.staticcall(data);
538         return _verifyCallResult(success, returndata, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but performing a delegate call.
544      *
545      * _Available since v3.4._
546      */
547     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
548         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
553      * but performing a delegate call.
554      *
555      * _Available since v3.4._
556      */
557     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
558         require(isContract(target), "Address: delegate call to non-contract");
559 
560         // solhint-disable-next-line avoid-low-level-calls
561         (bool success, bytes memory returndata) = target.delegatecall(data);
562         return _verifyCallResult(success, returndata, errorMessage);
563     }
564 
565     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
566         if (success) {
567             return returndata;
568         } else {
569             // Look for revert reason and bubble it up if present
570             if (returndata.length > 0) {
571                 // The easiest way to bubble the revert reason is using memory via assembly
572 
573                 // solhint-disable-next-line no-inline-assembly
574                 assembly {
575                     let returndata_size := mload(returndata)
576                     revert(add(32, returndata), returndata_size)
577                 }
578             } else {
579                 revert(errorMessage);
580             }
581         }
582     }
583 }
584 
585 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
586 
587 
588 pragma solidity >=0.6.0 <0.8.0;
589 
590 
591 
592 
593 /**
594  * @title SafeERC20
595  * @dev Wrappers around ERC20 operations that throw on failure (when the token
596  * contract returns false). Tokens that return no value (and instead revert or
597  * throw on failure) are also supported, non-reverting calls are assumed to be
598  * successful.
599  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
600  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
601  */
602 library SafeERC20 {
603     using SafeMath for uint256;
604     using Address for address;
605 
606     function safeTransfer(IERC20 token, address to, uint256 value) internal {
607         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
608     }
609 
610     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
611         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
612     }
613 
614     /**
615      * @dev Deprecated. This function has issues similar to the ones found in
616      * {IERC20-approve}, and its usage is discouraged.
617      *
618      * Whenever possible, use {safeIncreaseAllowance} and
619      * {safeDecreaseAllowance} instead.
620      */
621     function safeApprove(IERC20 token, address spender, uint256 value) internal {
622         // safeApprove should only be called when setting an initial allowance,
623         // or when resetting it to zero. To increase and decrease it, use
624         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
625         // solhint-disable-next-line max-line-length
626         require((value == 0) || (token.allowance(address(this), spender) == 0),
627             "SafeERC20: approve from non-zero to non-zero allowance"
628         );
629         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
630     }
631 
632     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
633         uint256 newAllowance = token.allowance(address(this), spender).add(value);
634         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
635     }
636 
637     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
638         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
639         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
640     }
641 
642     /**
643      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
644      * on the return value: the return value is optional (but if data is returned, it must not be false).
645      * @param token The token targeted by the call.
646      * @param data The call data (encoded using abi.encode or one of its variants).
647      */
648     function _callOptionalReturn(IERC20 token, bytes memory data) private {
649         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
650         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
651         // the target address contains contract code and also asserts for success in the low-level call.
652 
653         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
654         if (returndata.length > 0) { // Return data is optional
655             // solhint-disable-next-line max-line-length
656             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
657         }
658     }
659 }
660 
661 
662 pragma solidity ^0.6.12;
663 
664 contract bBetaAirdrop is Ownable {
665   using SafeERC20 for IERC20;
666   using SafeMath for uint256;
667 
668   address public token;
669   address public signer;
670 
671   uint256 public totalClaimed;
672 
673   mapping(address => bool) public isClaimed;
674   event Claimed(address account, uint256 amount);
675 
676   constructor(address _signer) public {
677     signer = _signer;
678   }
679 
680 
681   function setToken(address _token) public onlyOwner {
682     token = _token;
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
696     // require(msg.sender == account, "bBetaAirdrop: wrong sender");
697     require(!isClaimed[account], "bBetaAirdrop: Already claimed");
698     require(verifyProof(account, amount, v, r, s), "bBetaAirdrop: Invalid signer");  
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