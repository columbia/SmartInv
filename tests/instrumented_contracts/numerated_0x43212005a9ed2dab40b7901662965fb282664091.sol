1 pragma solidity ^0.6.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 // File: @openzeppelin/contracts/access/Ownable.sol
25 
26 pragma solidity ^0.6.0;
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor () internal {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Leaves the contract without owner. It will not be possible to call
71      * `onlyOwner` functions anymore. Can only be called by the current owner.
72      *
73      * NOTE: Renouncing ownership will leave the contract without an owner,
74      * thereby removing any functionality that is only available to the owner.
75      */
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         emit OwnershipTransferred(_owner, newOwner);
88         _owner = newOwner;
89     }
90 }
91 
92 pragma solidity ^0.6.0;
93 
94 /**
95  * @dev Interface of the ERC20 standard as defined in the EIP.
96  */
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102 
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107 
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125 
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Emitted when `value` tokens are moved from one account (`from`) to
155      * another (`to`).
156      *
157      * Note that `value` may be zero.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 value);
160 
161     /**
162      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
163      * a call to {approve}. `value` is the new allowance.
164      */
165     event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 pragma solidity ^0.6.0;
169 
170 
171 /**
172  * @title SafeERC20
173  */
174 library SafeERC20 {
175     using SafeMath for uint256;
176     using Address for address;
177 
178     function safeTransfer(IERC20 token, address to, uint256 value) internal {
179         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
180     }
181 
182     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
183         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
184     }
185 
186     /**
187      * @dev Deprecated. This function has issues similar to the ones found in
188      * {IERC20-approve}, and its usage is discouraged.
189      *
190      * Whenever possible, use {safeIncreaseAllowance} and
191      * {safeDecreaseAllowance} instead.
192      */
193     function safeApprove(IERC20 token, address spender, uint256 value) internal {
194         // safeApprove should only be called when setting an initial allowance,
195         // or when resetting it to zero. To increase and decrease it, use
196         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
197         // solhint-disable-next-line max-line-length
198         require((value == 0) || (token.allowance(address(this), spender) == 0),
199             "SafeERC20: approve from non-zero to non-zero allowance"
200         );
201         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
202     }
203 
204     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
205         uint256 newAllowance = token.allowance(address(this), spender).add(value);
206         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
207     }
208 
209     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
210         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
211         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
212     }
213 
214     /**
215      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
216      * on the return value: the return value is optional (but if data is returned, it must not be false).
217      * @param token The token targeted by the call.
218      * @param data The call data (encoded using abi.encode or one of its variants).
219      */
220     function _callOptionalReturn(IERC20 token, bytes memory data) private {
221         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
222         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
223         // the target address contains contract code and also asserts for success in the low-level call.
224 
225         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
226         if (returndata.length > 0) { // Return data is optional
227             // solhint-disable-next-line max-line-length
228             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
229         }
230     }
231 }
232 
233 pragma solidity ^0.6.0;
234 
235 /**
236  * @dev Wrappers over Solidity's arithmetic operations with added overflow
237  * checks.
238  *
239  * Arithmetic operations in Solidity wrap on overflow. This can easily result
240  * in bugs, because programmers usually assume that an overflow raises an
241  * error, which is the standard behavior in high level programming languages.
242  * `SafeMath` restores this intuition by reverting the transaction when an
243  * operation overflows.
244  *
245  * Using this library instead of the unchecked operations eliminates an entire
246  * class of bugs, so it's recommended to use it always.
247  */
248 library SafeMath {
249     /**
250      * @dev Returns the addition of two unsigned integers, reverting on
251      * overflow.
252      *
253      * Counterpart to Solidity's `+` operator.
254      *
255      * Requirements:
256      *
257      * - Addition cannot overflow.
258      */
259     function add(uint256 a, uint256 b) internal pure returns (uint256) {
260         uint256 c = a + b;
261         require(c >= a, "SafeMath: addition overflow");
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting on
268      * overflow (when the result is negative).
269      *
270      * Counterpart to Solidity's `-` operator.
271      *
272      * Requirements:
273      *
274      * - Subtraction cannot overflow.
275      */
276     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
277         return sub(a, b, "SafeMath: subtraction overflow");
278     }
279 
280     /**
281      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
282      * overflow (when the result is negative).
283      *
284      * Counterpart to Solidity's `-` operator.
285      *
286      * Requirements:
287      *
288      * - Subtraction cannot overflow.
289      */
290     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
291         require(b <= a, errorMessage);
292         uint256 c = a - b;
293 
294         return c;
295     }
296 
297     /**
298      * @dev Returns the multiplication of two unsigned integers, reverting on
299      * overflow.
300      *
301      * Counterpart to Solidity's `*` operator.
302      *
303      * Requirements:
304      *
305      * - Multiplication cannot overflow.
306      */
307     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
308         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
309         // benefit is lost if 'b' is also tested.
310         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
311         if (a == 0) {
312             return 0;
313         }
314 
315         uint256 c = a * b;
316         require(c / a == b, "SafeMath: multiplication overflow");
317 
318         return c;
319     }
320 
321     /**
322      * @dev Returns the integer division of two unsigned integers. Reverts on
323      * division by zero. The result is rounded towards zero.
324      *
325      * Counterpart to Solidity's `/` operator. Note: this function uses a
326      * `revert` opcode (which leaves remaining gas untouched) while Solidity
327      * uses an invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      *
331      * - The divisor cannot be zero.
332      */
333     function div(uint256 a, uint256 b) internal pure returns (uint256) {
334         return div(a, b, "SafeMath: division by zero");
335     }
336 
337     /**
338      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
339      * division by zero. The result is rounded towards zero.
340      *
341      * Counterpart to Solidity's `/` operator. Note: this function uses a
342      * `revert` opcode (which leaves remaining gas untouched) while Solidity
343      * uses an invalid opcode to revert (consuming all remaining gas).
344      *
345      * Requirements:
346      *
347      * - The divisor cannot be zero.
348      */
349     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
350         require(b > 0, errorMessage);
351         uint256 c = a / b;
352         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
353 
354         return c;
355     }
356 
357     /**
358      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
359      * Reverts when dividing by zero.
360      *
361      * Counterpart to Solidity's `%` operator. This function uses a `revert`
362      * opcode (which leaves remaining gas untouched) while Solidity uses an
363      * invalid opcode to revert (consuming all remaining gas).
364      *
365      * Requirements:
366      *
367      * - The divisor cannot be zero.
368      */
369     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
370         return mod(a, b, "SafeMath: modulo by zero");
371     }
372 
373     /**
374      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
375      * Reverts with custom message when dividing by zero.
376      *
377      * Counterpart to Solidity's `%` operator. This function uses a `revert`
378      * opcode (which leaves remaining gas untouched) while Solidity uses an
379      * invalid opcode to revert (consuming all remaining gas).
380      *
381      * Requirements:
382      *
383      * - The divisor cannot be zero.
384      */
385     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
386         require(b != 0, errorMessage);
387         return a % b;
388     }
389 }
390 
391 pragma solidity ^0.6.2;
392 
393 
394 library Address {
395     /**
396      * @dev Returns true if `account` is a contract.
397      *
398      * [IMPORTANT]
399      * ====
400      * It is unsafe to assume that an address for which this function returns
401      * false is an externally-owned account (EOA) and not a contract.
402      *
403      * Among others, `isContract` will return false for the following
404      * types of addresses:
405      *
406      *  - an externally-owned account
407      *  - a contract in construction
408      *  - an address where a contract will be created
409      *  - an address where a contract lived, but was destroyed
410      * ====
411      */
412     function isContract(address account) internal view returns (bool) {
413         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
414         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
415         // for accounts without code, i.e. `keccak256('')`
416         bytes32 codehash;
417         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
418         // solhint-disable-next-line no-inline-assembly
419         assembly { codehash := extcodehash(account) }
420         return (codehash != accountHash && codehash != 0x0);
421     }
422 
423     /**
424      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
425      * `recipient`, forwarding all available gas and reverting on errors.
426      *
427      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
428      * of certain opcodes, possibly making contracts go over the 2300 gas limit
429      * imposed by `transfer`, making them unable to receive funds via
430      * `transfer`. {sendValue} removes this limitation.
431      *
432      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
433      *
434      * IMPORTANT: because control is transferred to `recipient`, care must be
435      * taken to not create reentrancy vulnerabilities. Consider using
436      * {ReentrancyGuard} or the
437      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
438      */
439     function sendValue(address payable recipient, uint256 amount) internal {
440         require(address(this).balance >= amount, "Address: insufficient balance");
441 
442         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
443         (bool success, ) = recipient.call{ value: amount }("");
444         require(success, "Address: unable to send value, recipient may have reverted");
445     }
446 
447     /**
448      * @dev Performs a Solidity function call using a low level `call`. A
449      * plain`call` is an unsafe replacement for a function call: use this
450      * function instead.
451      *
452      * If `target` reverts with a revert reason, it is bubbled up by this
453      * function (like regular Solidity function calls).
454      *
455      * Returns the raw returned data. To convert to the expected return value,
456      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
457      *
458      * Requirements:
459      *
460      * - `target` must be a contract.
461      * - calling `target` with `data` must not revert.
462      *
463      * _Available since v3.1._
464      */
465     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
466       return functionCall(target, data, "Address: low-level call failed");
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
471      * `errorMessage` as a fallback revert reason when `target` reverts.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
476         return _functionCallWithValue(target, data, 0, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but also transferring `value` wei to `target`.
482      *
483      * Requirements:
484      *
485      * - the calling contract must have an ETH balance of at least `value`.
486      * - the called Solidity function must be `payable`.
487      *
488      * _Available since v3.1._
489      */
490     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
491         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
496      * with `errorMessage` as a fallback revert reason when `target` reverts.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
501         require(address(this).balance >= value, "Address: insufficient balance for call");
502         return _functionCallWithValue(target, data, value, errorMessage);
503     }
504 
505     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
506         require(isContract(target), "Address: call to non-contract");
507 
508         // solhint-disable-next-line avoid-low-level-calls
509         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516 
517                 // solhint-disable-next-line no-inline-assembly
518                 assembly {
519                     let returndata_size := mload(returndata)
520                     revert(add(32, returndata), returndata_size)
521                 }
522             } else {
523                 revert(errorMessage);
524             }
525         }
526     }
527 }
528 
529 pragma solidity ^0.6.0;
530 
531 contract Pausable is Context {
532     /**
533      * @dev Emitted when the pause is triggered by `account`.
534      */
535     event Paused(address account);
536 
537     /**
538      * @dev Emitted when the pause is lifted by `account`.
539      */
540     event Unpaused(address account);
541 
542     bool private _paused;
543 
544     /**
545      * @dev Initializes the contract in unpaused state.
546      */
547     constructor () internal {
548         _paused = false;
549     }
550 
551     /**
552      * @dev Returns true if the contract is paused, and false otherwise.
553      */
554     function paused() public view returns (bool) {
555         return _paused;
556     }
557 
558     /**
559      * @dev Modifier to make a function callable only when the contract is not paused.
560      *
561      * Requirements:
562      *
563      * - The contract must not be paused.
564      */
565     modifier whenNotPaused() {
566         require(!_paused, "Pausable: paused");
567         _;
568     }
569 
570     /**
571      * @dev Modifier to make a function callable only when the contract is paused.
572      *
573      * Requirements:
574      *
575      * - The contract must be paused.
576      */
577     modifier whenPaused() {
578         require(_paused, "Pausable: not paused");
579         _;
580     }
581 
582     /**
583      * @dev Triggers stopped state.
584      *
585      * Requirements:
586      *
587      * - The contract must not be paused.
588      */
589     function _pause() internal virtual whenNotPaused {
590         _paused = true;
591         emit Paused(_msgSender());
592     }
593 
594     /**
595      * @dev Returns to normal state.
596      *
597      * Requirements:
598      *
599      * - The contract must be paused.
600      */
601     function _unpause() internal virtual whenPaused {
602         _paused = false;
603         emit Unpaused(_msgSender());
604     }
605 }
606 
607 pragma solidity ^0.6.0;
608 
609 contract ReentrancyGuard {
610     // Booleans are more expensive than uint256 or any type that takes up a full
611     // word because each write operation emits an extra SLOAD to first read the
612     // slot's contents, replace the bits taken up by the boolean, and then write
613     // back. This is the compiler's defense against contract upgrades and
614     // pointer aliasing, and it cannot be disabled.
615 
616     // The values being non-zero value makes deployment a bit more expensive,
617     // but in exchange the refund on every call to nonReentrant will be lower in
618     // amount. Since refunds are capped to a percentage of the total
619     // transaction's gas, it is best to keep them low in cases like this one, to
620     // increase the likelihood of the full refund coming into effect.
621     uint256 private constant _NOT_ENTERED = 1;
622     uint256 private constant _ENTERED = 2;
623 
624     uint256 private _status;
625 
626     constructor () internal {
627         _status = _NOT_ENTERED;
628     }
629 
630     /**
631      * @dev Prevents a contract from calling itself, directly or indirectly.
632      * Calling a `nonReentrant` function from another `nonReentrant`
633      * function is not supported. It is possible to prevent this from happening
634      * by making the `nonReentrant` function external, and make it call a
635      * `private` function that does the actual work.
636      */
637     modifier nonReentrant() {
638         // On the first call to nonReentrant, _notEntered will be true
639         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
640 
641         // Any calls to nonReentrant after this point will fail
642         _status = _ENTERED;
643 
644         _;
645 
646         // By storing the original value once again, a refund is triggered (see
647         // https://eips.ethereum.org/EIPS/eip-2200)
648         _status = _NOT_ENTERED;
649     }
650 }
651 
652 pragma solidity ^0.6.0;
653 
654 library ECDSA {
655     /**
656      * @dev Returns the address that signed a hashed message (`hash`) with
657      * `signature`. This address can then be used for verification purposes.
658      *
659      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
660      * this function rejects them by requiring the `s` value to be in the lower
661      * half order, and the `v` value to be either 27 or 28.
662      *
663      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
664      * verification to be secure: it is possible to craft signatures that
665      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
666      * this is by receiving a hash of the original message (which may otherwise
667      * be too long), and then calling {toEthSignedMessageHash} on it.
668      */
669     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
670         // Check the signature length
671         if (signature.length != 65) {
672             revert("ECDSA: invalid signature length");
673         }
674 
675         // Divide the signature in r, s and v variables
676         bytes32 r;
677         bytes32 s;
678         uint8 v;
679 
680         // ecrecover takes the signature parameters, and the only way to get them
681         // currently is to use assembly.
682         // solhint-disable-next-line no-inline-assembly
683         assembly {
684             r := mload(add(signature, 0x20))
685             s := mload(add(signature, 0x40))
686             v := byte(0, mload(add(signature, 0x60)))
687         }
688 
689         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
690         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
691         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
692         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
693         //
694         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
695         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
696         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
697         // these malleable signatures as well.
698         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
699             revert("ECDSA: invalid signature 's' value");
700         }
701 
702         if (v != 27 && v != 28) {
703             revert("ECDSA: invalid signature 'v' value");
704         }
705 
706         // If the signature is valid (and not malleable), return the signer address
707         address signer = ecrecover(hash, v, r, s);
708         require(signer != address(0), "ECDSA: invalid signature");
709 
710         return signer;
711     }
712 
713     /**
714      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
715      * replicates the behavior of the
716      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
717      * JSON-RPC method.
718      *
719      * See {recover}.
720      */
721     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
722         // 32 is the length in bytes of hash,
723         // enforced by the type signature above
724         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
725     }
726 }
727 
728 pragma solidity ^0.6.0;
729 
730 contract BridgeContract is Ownable, Pausable, ReentrancyGuard {
731     using SafeERC20 for IERC20;
732     /*
733      *  Events
734      */
735     event Swap(address indexed token, address recipient, uint amount);
736     event Withdraw(address indexed token, address indexed recipient, uint amount);
737     event AddedVerifierList(address _verifier);
738     event RemovedVerifierList(address _verifier);
739     event AddedBlackList(address _address);
740     event RemovedBlackList(address _address);
741     
742     mapping (address => bool) public isVerifier;
743     mapping (address => bool) public isAddressBlackListed;
744     mapping (address => bool) public isTokenBlackListed;
745     mapping (bytes => bool) public usedNonce;
746     
747     uint public targetChainId;
748     
749     constructor (address _verifier, uint _targetChainId) public {
750         isVerifier[_verifier] = true;
751         targetChainId = _targetChainId;
752     }
753     
754     // Verifier
755     function addVerifier (address _verifier) public onlyOwner {
756         isVerifier[_verifier] = true;
757         emit AddedVerifierList(_verifier);
758     }
759 
760     function removeVerifier (address _verifier) public onlyOwner {
761         delete isVerifier[_verifier];
762         emit RemovedVerifierList(_verifier);
763     }
764     
765     // Blacklist
766     function addTokenBlackList (address _token) public onlyOwner {
767         isTokenBlackListed[_token] = true;
768         emit AddedBlackList(_token);
769     }
770 
771     function removeTokenBlackList (address _token) public onlyOwner {
772         delete isTokenBlackListed[_token];
773         emit RemovedBlackList(_token);
774     }
775     
776     function addAddressBlackList (address _address) public onlyOwner {
777         isAddressBlackListed[_address] = true;
778         emit AddedBlackList(_address);
779     }
780 
781     function removeAddressBlackList (address _address) public onlyOwner {
782         delete isAddressBlackListed[_address];
783         emit RemovedBlackList(_address);
784     }
785 
786     // Pause/Unpause
787     function pause() external onlyOwner {
788         _pause();
789     }
790 
791     function unpause() external onlyOwner {
792         _unpause();
793     }
794     
795     // Swap/Unswap
796     function swapErc20(IERC20 token, address recipient, uint amount) external nonReentrant whenNotPaused {
797         require(amount > 0, "Swap amount must be positive");
798         require(token.allowance(msg.sender, address(this)) >= amount, "Swap amount exceeds allowance");
799 
800         token.safeTransferFrom(msg.sender, address(this), amount);
801 
802         if (!isTokenBlackListed[address(token)] && !isAddressBlackListed[recipient] && !isAddressBlackListed[msg.sender]) {
803             emit Swap(address(token), recipient, amount);   
804         }
805     }
806 
807     function swapEth(address recipient) external payable nonReentrant whenNotPaused {
808         uint amount = msg.value;
809         require(amount > 0, "Swap amount must be positive");
810 
811         if (!isAddressBlackListed[recipient]) {
812             emit Swap(address(0), recipient, amount);   
813         }
814     }
815 
816     function withdrawEth(address payable recipient, uint256 amount, uint256 txId, bytes32 txHash, uint target_chain, bytes calldata signature) external nonReentrant whenNotPaused {
817         require(target_chain == targetChainId, "Must not transfer to the same chain");
818         require(!isAddressBlackListed[recipient], "Recipient blacklisted");
819         require(!isAddressBlackListed[msg.sender], "Sender blacklisted");
820         bytes32 message = keccak256(abi.encodePacked(
821             address(0),
822             txHash,
823             recipient,
824             txId,
825             amount,
826             target_chain
827         ));
828         bytes32 hash = ECDSA.toEthSignedMessageHash(message);
829         address signer = ECDSA.recover(hash, signature);
830 
831         require(isVerifier[signer], 'Invalid signature');
832         require(!usedNonce[signature], "Used nonce");
833         usedNonce[signature] = true;
834         
835         recipient.transfer(amount);
836 
837         emit Withdraw(address(0), recipient, amount);
838     }
839     
840     function withdrawERC20(IERC20 token, address recipient, uint256 amount, uint256 txId, bytes32 txHash, uint target_chain, bytes calldata signature) external whenNotPaused nonReentrant {
841         require(target_chain == targetChainId, "Must not transfer to the same chain");
842         require(!isTokenBlackListed[address(token)], "Token blacklisted");
843         require(!isAddressBlackListed[recipient], "Recipient blacklisted");
844         require(!isAddressBlackListed[msg.sender], "Sender blacklisted");
845         bytes32 message = keccak256(abi.encodePacked(
846             address(token),
847             txHash,
848             recipient,
849             txId,
850             amount,
851             target_chain
852         ));
853         bytes32 hash = ECDSA.toEthSignedMessageHash(message);
854         address signer = ECDSA.recover(hash, signature);
855 
856         require(isVerifier[signer], 'Invalid signature');
857         require(!usedNonce[signature], "Used signature");
858         usedNonce[signature] = true;
859 
860         token.safeTransfer(recipient, amount);
861 
862         emit Withdraw(address(token), recipient, amount);
863     }
864 
865     function ownerWithdrawErc20(IERC20 token, uint amount) external onlyOwner {
866         token.safeTransfer(msg.sender, amount);
867         emit Withdraw(address(token), msg.sender, amount);
868     }
869     
870     function ownerWithdrawEth(uint amount) external onlyOwner {
871         msg.sender.transfer(amount);
872         emit Withdraw(address(0), msg.sender, amount);
873     }
874 }