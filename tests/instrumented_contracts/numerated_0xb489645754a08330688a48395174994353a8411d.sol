1 // SPDX-License-Identifier: AGPL V3.0
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: AddressUpgradeable
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library AddressUpgradeable {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
152         if (success) {
153             return returndata;
154         } else {
155             // Look for revert reason and bubble it up if present
156             if (returndata.length > 0) {
157                 // The easiest way to bubble the revert reason is using memory via assembly
158 
159                 // solhint-disable-next-line no-inline-assembly
160                 assembly {
161                     let returndata_size := mload(returndata)
162                     revert(add(32, returndata), returndata_size)
163                 }
164             } else {
165                 revert(errorMessage);
166             }
167         }
168     }
169 }
170 
171 // Part: IERC20Upgradeable
172 
173 /**
174  * @dev Interface of the ERC20 standard as defined in the EIP.
175  */
176 interface IERC20Upgradeable {
177     /**
178      * @dev Returns the amount of tokens in existence.
179      */
180     function totalSupply() external view returns (uint256);
181 
182     /**
183      * @dev Returns the amount of tokens owned by `account`.
184      */
185     function balanceOf(address account) external view returns (uint256);
186 
187     /**
188      * @dev Moves `amount` tokens from the caller's account to `recipient`.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transfer(address recipient, uint256 amount) external returns (bool);
195 
196     /**
197      * @dev Returns the remaining number of tokens that `spender` will be
198      * allowed to spend on behalf of `owner` through {transferFrom}. This is
199      * zero by default.
200      *
201      * This value changes when {approve} or {transferFrom} are called.
202      */
203     function allowance(address owner, address spender) external view returns (uint256);
204 
205     /**
206      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
207      *
208      * Returns a boolean value indicating whether the operation succeeded.
209      *
210      * IMPORTANT: Beware that changing an allowance with this method brings the risk
211      * that someone may use both the old and the new allowance by unfortunate
212      * transaction ordering. One possible solution to mitigate this race
213      * condition is to first reduce the spender's allowance to 0 and set the
214      * desired value afterwards:
215      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216      *
217      * Emits an {Approval} event.
218      */
219     function approve(address spender, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Moves `amount` tokens from `sender` to `recipient` using the
223      * allowance mechanism. `amount` is then deducted from the caller's
224      * allowance.
225      *
226      * Returns a boolean value indicating whether the operation succeeded.
227      *
228      * Emits a {Transfer} event.
229      */
230     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Emitted when `value` tokens are moved from one account (`from`) to
234      * another (`to`).
235      *
236      * Note that `value` may be zero.
237      */
238     event Transfer(address indexed from, address indexed to, uint256 value);
239 
240     /**
241      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
242      * a call to {approve}. `value` is the new allowance.
243      */
244     event Approval(address indexed owner, address indexed spender, uint256 value);
245 }
246 
247 // Part: Initializable
248 
249 /**
250  * @title Initializable
251  *
252  * @dev Helper contract to support initializer functions. To use it, replace
253  * the constructor with a function that has the `initializer` modifier.
254  * WARNING: Unlike constructors, initializer functions must be manually
255  * invoked. This applies both to deploying an Initializable contract, as well
256  * as extending an Initializable contract via inheritance.
257  * WARNING: When used with inheritance, manual care must be taken to not invoke
258  * a parent initializer twice, or ensure that all initializers are idempotent,
259  * because this is not dealt with automatically as with constructors.
260  */
261 contract Initializable {
262     /**
263      * @dev Indicates that the contract has been initialized.
264      */
265     bool private initialized;
266 
267     /**
268      * @dev Indicates that the contract is in the process of being initialized.
269      */
270     bool private initializing;
271 
272     /**
273      * @dev Modifier to use in the initializer function of a contract.
274      */
275     modifier initializer() {
276         require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
277 
278         bool isTopLevelCall = !initializing;
279         if (isTopLevelCall) {
280             initializing = true;
281             initialized = true;
282         }
283 
284         _;
285 
286         if (isTopLevelCall) {
287             initializing = false;
288         }
289     }
290 
291     /// @dev Returns true if and only if the function is running in the constructor
292     function isConstructor() private view returns (bool) {
293         // extcodesize checks the size of the code stored in an address, and
294         // address returns the current address. Since the code is still not
295         // deployed when running a constructor, any checks on its code size will
296         // yield zero, making it an effective way to detect if a contract is
297         // under construction or not.
298         address self = address(this);
299         uint256 cs;
300         assembly {
301             cs := extcodesize(self)
302         }
303         return cs == 0;
304     }
305 
306     // Reserved storage space to allow for layout changes in the future.
307     uint256[50] private ______gap;
308 }
309 
310 // Part: Roles
311 
312 /**
313  * @title Roles
314  * @dev Library for managing addresses assigned to a Role.
315  */
316 library Roles {
317     struct Role {
318         mapping(address => bool) bearer;
319     }
320 
321     /**
322      * @dev Give an account access to this role.
323      */
324     function add(Role storage role, address account) internal {
325         require(!has(role, account), "Roles: account already has role");
326         role.bearer[account] = true;
327     }
328 
329     /**
330      * @dev Remove an account's access to this role.
331      */
332     function remove(Role storage role, address account) internal {
333         require(has(role, account), "Roles: account does not have role");
334         role.bearer[account] = false;
335     }
336 
337     /**
338      * @dev Check if an account has this role.
339      * @return bool
340      */
341     function has(Role storage role, address account) internal view returns (bool) {
342         require(account != address(0), "Roles: account is the zero address");
343         return role.bearer[account];
344     }
345 }
346 
347 // Part: SafeMathUpgradeable
348 
349 /**
350  * @dev Wrappers over Solidity's arithmetic operations with added overflow
351  * checks.
352  *
353  * Arithmetic operations in Solidity wrap on overflow. This can easily result
354  * in bugs, because programmers usually assume that an overflow raises an
355  * error, which is the standard behavior in high level programming languages.
356  * `SafeMath` restores this intuition by reverting the transaction when an
357  * operation overflows.
358  *
359  * Using this library instead of the unchecked operations eliminates an entire
360  * class of bugs, so it's recommended to use it always.
361  */
362 library SafeMathUpgradeable {
363     /**
364      * @dev Returns the addition of two unsigned integers, reverting on
365      * overflow.
366      *
367      * Counterpart to Solidity's `+` operator.
368      *
369      * Requirements:
370      *
371      * - Addition cannot overflow.
372      */
373     function add(uint256 a, uint256 b) internal pure returns (uint256) {
374         uint256 c = a + b;
375         require(c >= a, "SafeMath: addition overflow");
376 
377         return c;
378     }
379 
380     /**
381      * @dev Returns the subtraction of two unsigned integers, reverting on
382      * overflow (when the result is negative).
383      *
384      * Counterpart to Solidity's `-` operator.
385      *
386      * Requirements:
387      *
388      * - Subtraction cannot overflow.
389      */
390     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
391         return sub(a, b, "SafeMath: subtraction overflow");
392     }
393 
394     /**
395      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
396      * overflow (when the result is negative).
397      *
398      * Counterpart to Solidity's `-` operator.
399      *
400      * Requirements:
401      *
402      * - Subtraction cannot overflow.
403      */
404     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
405         require(b <= a, errorMessage);
406         uint256 c = a - b;
407 
408         return c;
409     }
410 
411     /**
412      * @dev Returns the multiplication of two unsigned integers, reverting on
413      * overflow.
414      *
415      * Counterpart to Solidity's `*` operator.
416      *
417      * Requirements:
418      *
419      * - Multiplication cannot overflow.
420      */
421     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
422         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
423         // benefit is lost if 'b' is also tested.
424         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
425         if (a == 0) {
426             return 0;
427         }
428 
429         uint256 c = a * b;
430         require(c / a == b, "SafeMath: multiplication overflow");
431 
432         return c;
433     }
434 
435     /**
436      * @dev Returns the integer division of two unsigned integers. Reverts on
437      * division by zero. The result is rounded towards zero.
438      *
439      * Counterpart to Solidity's `/` operator. Note: this function uses a
440      * `revert` opcode (which leaves remaining gas untouched) while Solidity
441      * uses an invalid opcode to revert (consuming all remaining gas).
442      *
443      * Requirements:
444      *
445      * - The divisor cannot be zero.
446      */
447     function div(uint256 a, uint256 b) internal pure returns (uint256) {
448         return div(a, b, "SafeMath: division by zero");
449     }
450 
451     /**
452      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
453      * division by zero. The result is rounded towards zero.
454      *
455      * Counterpart to Solidity's `/` operator. Note: this function uses a
456      * `revert` opcode (which leaves remaining gas untouched) while Solidity
457      * uses an invalid opcode to revert (consuming all remaining gas).
458      *
459      * Requirements:
460      *
461      * - The divisor cannot be zero.
462      */
463     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
464         require(b > 0, errorMessage);
465         uint256 c = a / b;
466         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
467 
468         return c;
469     }
470 
471     /**
472      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
473      * Reverts when dividing by zero.
474      *
475      * Counterpart to Solidity's `%` operator. This function uses a `revert`
476      * opcode (which leaves remaining gas untouched) while Solidity uses an
477      * invalid opcode to revert (consuming all remaining gas).
478      *
479      * Requirements:
480      *
481      * - The divisor cannot be zero.
482      */
483     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
484         return mod(a, b, "SafeMath: modulo by zero");
485     }
486 
487     /**
488      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
489      * Reverts with custom message when dividing by zero.
490      *
491      * Counterpart to Solidity's `%` operator. This function uses a `revert`
492      * opcode (which leaves remaining gas untouched) while Solidity uses an
493      * invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      *
497      * - The divisor cannot be zero.
498      */
499     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
500         require(b != 0, errorMessage);
501         return a % b;
502     }
503 }
504 
505 // Part: ContextUpgradeable
506 
507 /*
508  * @dev Provides information about the current execution context, including the
509  * sender of the transaction and its data. While these are generally available
510  * via msg.sender and msg.data, they should not be accessed in such a direct
511  * manner, since when dealing with GSN meta-transactions the account sending and
512  * paying for execution may not be the actual sender (as far as an application
513  * is concerned).
514  *
515  * This contract is only required for intermediate, library-like contracts.
516  */
517 abstract contract ContextUpgradeable is Initializable {
518     function __Context_init() internal initializer {
519         __Context_init_unchained();
520     }
521 
522     function __Context_init_unchained() internal initializer {
523     }
524     function _msgSender() internal view virtual returns (address payable) {
525         return msg.sender;
526     }
527 
528     function _msgData() internal view virtual returns (bytes memory) {
529         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
530         return msg.data;
531     }
532     uint256[50] private __gap;
533 }
534 
535 // Part: SafeERC20Upgradeable
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
546 library SafeERC20Upgradeable {
547     using SafeMathUpgradeable for uint256;
548     using AddressUpgradeable for address;
549 
550     function safeTransfer(IERC20Upgradeable token, address to, uint256 value) internal {
551         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
552     }
553 
554     function safeTransferFrom(IERC20Upgradeable token, address from, address to, uint256 value) internal {
555         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
556     }
557 
558     /**
559      * @dev Deprecated. This function has issues similar to the ones found in
560      * {IERC20-approve}, and its usage is discouraged.
561      *
562      * Whenever possible, use {safeIncreaseAllowance} and
563      * {safeDecreaseAllowance} instead.
564      */
565     function safeApprove(IERC20Upgradeable token, address spender, uint256 value) internal {
566         // safeApprove should only be called when setting an initial allowance,
567         // or when resetting it to zero. To increase and decrease it, use
568         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
569         // solhint-disable-next-line max-line-length
570         require((value == 0) || (token.allowance(address(this), spender) == 0),
571             "SafeERC20: approve from non-zero to non-zero allowance"
572         );
573         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
574     }
575 
576     function safeIncreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
577         uint256 newAllowance = token.allowance(address(this), spender).add(value);
578         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
579     }
580 
581     function safeDecreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
582         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
583         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
584     }
585 
586     /**
587      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
588      * on the return value: the return value is optional (but if data is returned, it must not be false).
589      * @param token The token targeted by the call.
590      * @param data The call data (encoded using abi.encode or one of its variants).
591      */
592     function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
593         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
594         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
595         // the target address contains contract code and also asserts for success in the low-level call.
596 
597         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
598         if (returndata.length > 0) { // Return data is optional
599             // solhint-disable-next-line max-line-length
600             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
601         }
602     }
603 }
604 
605 // Part: MinterRole
606 
607 contract MinterRole is Initializable, ContextUpgradeable {
608     using Roles for Roles.Role;
609 
610     event MinterAdded(address indexed account);
611     event MinterRemoved(address indexed account);
612 
613     Roles.Role private _minters;
614 
615     function initialize(address sender) public virtual initializer {
616         __Context_init_unchained();
617         if (!isMinter(sender)) {
618             _addMinter(sender);
619         }
620     }
621 
622     modifier onlyMinter() {
623         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
624         _;
625     }
626 
627     function isMinter(address account) public view returns (bool) {
628         return _minters.has(account);
629     }
630 
631     function addMinter(address account) public onlyMinter {
632         _addMinter(account);
633     }
634 
635     function renounceMinter() public {
636         _removeMinter(_msgSender());
637     }
638 
639     function _addMinter(address account) internal {
640         _minters.add(account);
641         emit MinterAdded(account);
642     }
643 
644     function _removeMinter(address account) internal {
645         _minters.remove(account);
646         emit MinterRemoved(account);
647     }
648 
649     uint256[50] private ______gap;
650 }
651 
652 // Part: OwnableUpgradeable
653 
654 /**
655  * @dev Contract module which provides a basic access control mechanism, where
656  * there is an account (an owner) that can be granted exclusive access to
657  * specific functions.
658  *
659  * By default, the owner account will be the one that deploys the contract. This
660  * can later be changed with {transferOwnership}.
661  *
662  * This module is used through inheritance. It will make available the modifier
663  * `onlyOwner`, which can be applied to your functions to restrict their use to
664  * the owner.
665  */
666 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
667     address private _owner;
668 
669     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
670 
671     /**
672      * @dev Initializes the contract setting the deployer as the initial owner.
673      */
674     function __Ownable_init() internal initializer {
675         __Context_init_unchained();
676         __Ownable_init_unchained();
677     }
678 
679     function __Ownable_init_unchained() internal initializer {
680         address msgSender = _msgSender();
681         _owner = msgSender;
682         emit OwnershipTransferred(address(0), msgSender);
683     }
684 
685     /**
686      * @dev Returns the address of the current owner.
687      */
688     function owner() public view returns (address) {
689         return _owner;
690     }
691 
692     /**
693      * @dev Throws if called by any account other than the owner.
694      */
695     modifier onlyOwner() {
696         require(_owner == _msgSender(), "Ownable: caller is not the owner");
697         _;
698     }
699 
700     /**
701      * @dev Leaves the contract without owner. It will not be possible to call
702      * `onlyOwner` functions anymore. Can only be called by the current owner.
703      *
704      * NOTE: Renouncing ownership will leave the contract without an owner,
705      * thereby removing any functionality that is only available to the owner.
706      */
707     function renounceOwnership() public virtual onlyOwner {
708         emit OwnershipTransferred(_owner, address(0));
709         _owner = address(0);
710     }
711 
712     /**
713      * @dev Transfers ownership of the contract to a new account (`newOwner`).
714      * Can only be called by the current owner.
715      */
716     function transferOwnership(address newOwner) public virtual onlyOwner {
717         require(newOwner != address(0), "Ownable: new owner is the zero address");
718         emit OwnershipTransferred(_owner, newOwner);
719         _owner = newOwner;
720     }
721     uint256[49] private __gap;
722 }
723 
724 // Part: VestedAkroSenderRole
725 
726 contract VestedAkroSenderRole is Initializable, ContextUpgradeable {
727     using Roles for Roles.Role;
728 
729     event SenderAdded(address indexed account);
730     event SenderRemoved(address indexed account);
731 
732     Roles.Role private _senders;
733 
734     function initialize(address sender) public virtual initializer {
735         __Context_init_unchained();
736         if (!isSender(sender)) {
737             _addSender(sender);
738         }
739     }
740 
741     modifier onlySender() {
742         require(isSender(_msgSender()), "SenderRole: caller does not have the Sender role");
743         _;
744     }
745 
746     function isSender(address account) public view returns (bool) {
747         return _senders.has(account);
748     }
749 
750     function addSender(address account) public onlySender {
751         _addSender(account);
752     }
753 
754     function renounceSender() public {
755         _removeSender(_msgSender());
756     }
757 
758     function _addSender(address account) internal {
759         _senders.add(account);
760         emit SenderAdded(account);
761     }
762 
763     function _removeSender(address account) internal {
764         _senders.remove(account);
765         emit SenderRemoved(account);
766     }
767 
768     uint256[50] private ______gap;
769 }
770 
771 // File: VestedAkro.sol
772 
773 /**
774  * @notice VestedAkro token represents AKRO token vested for a vestingPeriod set by owner of this VestedAkro token.
775  * Generic holders of this token CAN NOT transfer it. They only can redeem AKRO from unlocked vAKRO.
776  * Minters can mint unlocked vAKRO from AKRO to special VestedAkroSenders.
777  * VestedAkroSender can send his unlocked vAKRO to generic holders, and this vAKRO will be vested. He can not redeem AKRO himself.
778  */
779 contract VestedAkro is OwnableUpgradeable, IERC20Upgradeable, MinterRole, VestedAkroSenderRole {
780     using SafeMathUpgradeable for uint256;
781     using SafeERC20Upgradeable for IERC20Upgradeable;
782 
783     event Locked(address indexed holder, uint256 amount);
784     event Unlocked(address indexed holder, uint256 amount);
785     event AkroAdded(uint256 amount);
786 
787     struct VestedBatch {
788         uint256 amount; // Full amount of vAKRO vested in this batch
789         uint256 start; // Vesting start time;
790         uint256 end; // Vesting end time
791         uint256 claimed; // vAKRO already claimed from this batch to unlocked balance of holder
792     }
793 
794     struct Balance {
795         VestedBatch[] batches; // Array of vesting batches
796         uint256 locked; // Amount locked in batches
797         uint256 unlocked; // Amount of unlocked vAKRO (which either was previously claimed, or received from Minter)
798         uint256 firstUnclaimedBatch; // First batch which is not fully claimed
799     }
800 
801     string private _name;
802     string private _symbol;
803     uint8 private _decimals;
804 
805     uint256 public override totalSupply;
806     IERC20Upgradeable public akro;
807     uint256 public vestingPeriod; //set by owner of this VestedAkro token
808     uint256 public vestingStart; //set by owner, default value 01 May 2021, 00:00:00 GMT+0
809     uint256 public vestingCliff; //set by owner, cliff for akro unlock, 1 month by default
810     mapping(address => mapping(address => uint256)) private allowances;
811     mapping(address => Balance) private holders;
812 
813     uint256 public swapToAkroRateNumerator; //Amount of 1 vAkro for 1 AKRO - 1 by default
814     uint256 public swapToAkroRateDenominator;
815 
816     function initialize(address _akro, uint256 _vestingPeriod) public initializer {
817         __Ownable_init();
818         MinterRole.initialize(_msgSender());
819         VestedAkroSenderRole.initialize(_msgSender());
820 
821         _name = "Vested AKRO";
822         _symbol = "vAKRO";
823         _decimals = 18;
824 
825         akro = IERC20Upgradeable(_akro);
826         require(_vestingPeriod > 0, "VestedAkro: vestingPeriod should be > 0");
827         vestingPeriod = _vestingPeriod;
828         vestingStart = 1619827200; //01 May 2021, 00:00:00 GMT+0
829         vestingCliff = 31 * 24 * 60 * 60; //1 month - 31 day in May
830 
831         swapToAkroRateNumerator = 1;
832         swapToAkroRateDenominator = 1;
833     }
834 
835     // Stub for compiler purposes only
836     function initialize(address sender) public override(MinterRole, VestedAkroSenderRole) {}
837 
838     function name() public view returns (string memory) {
839         return _name;
840     }
841 
842     function symbol() public view returns (string memory) {
843         return _symbol;
844     }
845 
846     function decimals() public view returns (uint8) {
847         return _decimals;
848     }
849 
850     function allowance(address owner, address spender) public view override returns (uint256) {
851         return allowances[owner][spender];
852     }
853 
854     function approve(address spender, uint256 amount) public override returns (bool) {
855         _approve(_msgSender(), spender, amount);
856         return true;
857     }
858 
859     function transferFrom(
860         address sender,
861         address recipient,
862         uint256 amount
863     ) public override onlySender returns (bool) {
864         // We require both sender and _msgSender() to have VestedAkroSender role
865         // to prevent sender from redeem and prevent unauthorized transfers via transferFrom.
866         require(isSender(sender), "VestedAkro: sender should have VestedAkroSender role");
867 
868         _transfer(sender, recipient, amount);
869         _approve(sender, _msgSender(), allowances[sender][_msgSender()].sub(amount, "VestedAkro: transfer amount exceeds allowance"));
870         return true;
871     }
872 
873     function transfer(address recipient, uint256 amount) public override onlySender returns (bool) {
874         _transfer(_msgSender(), recipient, amount);
875         return true;
876     }
877 
878     function setVestingPeriod(uint256 _vestingPeriod) public onlyOwner {
879         require(_vestingPeriod > 0, "VestedAkro: vestingPeriod should be > 0");
880         vestingPeriod = _vestingPeriod;
881     }
882 
883     /**
884      * @notice Sets vesting start date (as unix timestamp). Owner only
885      * @param _vestingStart Unix timestamp.
886      */
887     function setVestingStart(uint256 _vestingStart) public onlyOwner {
888         require(_vestingStart > 0, "VestedAkro: vestingStart should be > 0");
889         vestingStart = _vestingStart;
890     }
891 
892     /**
893      * @notice Sets vesting start date (as unix timestamp). Owner only
894      * @param _vestingCliff Cliff in seconds (1 month by default)
895      */
896     function setVestingCliff(uint256 _vestingCliff) public onlyOwner {
897         vestingCliff = _vestingCliff;
898     }
899 
900     /**
901      * @notice Sets the rate of ADEL to vAKRO swap: 1 ADEL = _swapRateNumerator/_swapRateDenominator vAKRO
902      * @notice By default is set to 0, that means that swap is disabled
903      * @param _swapRateNumerator Numerator for Adel converting. Can be set to 0 - that stops the swap.
904      * @param _swapRateDenominator Denominator for Adel converting. Can't be set to 0
905      */
906     function setSwapRate(uint256 _swapRateNumerator, uint256 _swapRateDenominator) external onlyOwner {
907         require(_swapRateDenominator > 0, "Incorrect value");
908         swapToAkroRateNumerator = _swapRateNumerator;
909         swapToAkroRateDenominator = _swapRateDenominator;
910     }
911 
912     function mint(address beneficiary, uint256 amount) public onlyMinter {
913         totalSupply = totalSupply.add(amount);
914         holders[beneficiary].unlocked = holders[beneficiary].unlocked.add(amount);
915         emit Transfer(address(0), beneficiary, amount);
916     }
917 
918     /**
919      * @notice Burns locked token from the user by the Minter
920      * @param sender User to burn tokens from
921      * @param amount Amount to burn
922      */
923     function burnFrom(address sender, uint256 amount) public onlyMinter {
924         require(amount > 0, "Incorrect amount");
925         require(sender != address(0), "Zero address");
926 
927         require(block.timestamp <= vestingStart, "Vesting has started");
928 
929         Balance storage b = holders[sender];
930 
931         require(b.locked >= amount, "Insufficient vAkro");
932         require(b.batches.length > 0 || b.firstUnclaimedBatch < b.batches.length, "Nothing to burn");
933 
934         totalSupply = totalSupply.sub(amount);
935         b.locked = b.locked.sub(amount);
936 
937         uint256 batchAmount = b.batches[b.firstUnclaimedBatch].amount;
938         b.batches[b.firstUnclaimedBatch].amount = batchAmount.sub(amount);
939 
940         emit Transfer(sender, address(0), amount);
941     }
942 
943     /**
944      * @notice Adds AKRO liquidity to the swap contract
945      * @param _amount Amout of AKRO added to the contract.
946      */
947     function addAkroLiquidity(uint256 _amount) public onlyMinter {
948         require(_amount > 0, "Incorrect amount");
949 
950         IERC20Upgradeable(akro).safeTransferFrom(_msgSender(), address(this), _amount);
951 
952         emit AkroAdded(_amount);
953     }
954 
955     /**
956      * @notice Unlocks all avilable vAKRO for a holder
957      * @param holder Whose funds to unlock
958      * @return total unlocked amount awailable for redeem
959      */
960     function unlockAvailable(address holder) public returns (uint256) {
961         require(holders[holder].batches.length > 0, "VestedAkro: nothing to unlock");
962         claimAllFromBatches(holder);
963         return holders[holder].unlocked;
964     }
965 
966     /**
967      * @notice Unlock all available vAKRO and redeem it
968      * @return Amount redeemed
969      */
970     function unlockAndRedeemAll() public returns (uint256) {
971         address beneficiary = _msgSender();
972         claimAllFromBatches(beneficiary);
973         return redeemAllUnlocked();
974     }
975 
976     /**
977      * @notice Redeem all already unlocked vAKRO. Sends AKRO by the set up rate
978      * @return Amount vAkro redeemed
979      */
980     function redeemAllUnlocked() public returns (uint256) {
981         address beneficiary = _msgSender();
982         require(!isSender(beneficiary), "VestedAkro: VestedAkroSender is not allowed to redeem");
983         uint256 amount = holders[beneficiary].unlocked;
984         if (amount == 0) return 0;
985 
986         uint256 akroAmount = amount.mul(swapToAkroRateNumerator).div(swapToAkroRateDenominator);
987         require(akro.balanceOf(address(this)) >= akroAmount, "Not enough AKRO");
988 
989         holders[beneficiary].unlocked = 0;
990         totalSupply = totalSupply.sub(amount);
991 
992         akro.safeTransfer(beneficiary, akroAmount);
993 
994         emit Transfer(beneficiary, address(0), amount);
995         return amount;
996     }
997 
998     /**
999      * @notice Calculates AKRO amount according to vAkro
1000      * @param account Whose funds to get balance
1001      * @return Akro amount recalculated
1002      */
1003     function balanceOfAkro(address account) public view returns (uint256) {
1004         Balance storage b = holders[account];
1005         uint256 amount = b.locked.add(b.unlocked);
1006         uint256 akroAmount = amount.mul(swapToAkroRateNumerator).div(swapToAkroRateDenominator);
1007         return akroAmount;
1008     }
1009 
1010     function balanceOf(address account) public view override returns (uint256) {
1011         Balance storage b = holders[account];
1012         return b.locked.add(b.unlocked);
1013     }
1014 
1015     function balanceInfoOf(address account)
1016         public
1017         view
1018         returns (
1019             uint256 locked,
1020             uint256 unlocked,
1021             uint256 unlockable
1022         )
1023     {
1024         Balance storage b = holders[account];
1025         return (b.locked, b.unlocked, calculateClaimableFromBatches(account));
1026     }
1027 
1028     function batchesInfoOf(address account) public view returns (uint256 firstUnclaimedBatch, uint256 totalBatches) {
1029         Balance storage b = holders[account];
1030         return (b.firstUnclaimedBatch, b.batches.length);
1031     }
1032 
1033     function batchInfo(address account, uint256 batch)
1034         public
1035         view
1036         returns (
1037             uint256 amount,
1038             uint256 start,
1039             uint256 end,
1040             uint256 claimed,
1041             uint256 claimable
1042         )
1043     {
1044         VestedBatch storage vb = holders[account].batches[batch];
1045         (claimable, ) = calculateClaimableFromBatch(vb);
1046         return (vb.amount, vestingStart, vestingStart.add(vestingPeriod), vb.claimed, claimable);
1047     }
1048 
1049     function _approve(
1050         address owner,
1051         address spender,
1052         uint256 amount
1053     ) internal {
1054         require(owner != address(0), "VestedAkro: approve from the zero address");
1055         require(spender != address(0), "VestedAkro: approve to the zero address");
1056 
1057         allowances[owner][spender] = amount;
1058         emit Approval(owner, spender, amount);
1059     }
1060 
1061     function _transfer(
1062         address sender,
1063         address recipient,
1064         uint256 amount
1065     ) internal {
1066         require(sender != address(0), "VestedAkro: transfer from the zero address");
1067         require(recipient != address(0), "VestedAkro: transfer to the zero address");
1068 
1069         holders[sender].unlocked = holders[sender].unlocked.sub(amount, "VestedAkro: transfer amount exceeds unlocked balance");
1070         createOrModifyBatch(recipient, amount);
1071 
1072         emit Transfer(sender, recipient, amount);
1073     }
1074 
1075     function createOrModifyBatch(address holder, uint256 amount) internal {
1076         Balance storage b = holders[holder];
1077 
1078         if (b.batches.length == 0 || b.firstUnclaimedBatch == b.batches.length) {
1079             b.batches.push(VestedBatch({amount: amount, start: vestingStart, end: vestingStart.add(vestingPeriod), claimed: 0}));
1080         } else {
1081             uint256 batchAmount = b.batches[b.firstUnclaimedBatch].amount;
1082             b.batches[b.firstUnclaimedBatch].amount = batchAmount.add(amount);
1083         }
1084         b.locked = b.locked.add(amount);
1085         emit Locked(holder, amount);
1086     }
1087 
1088     function claimAllFromBatches(address holder) internal {
1089         claimAllFromBatches(holder, holders[holder].batches.length);
1090     }
1091 
1092     function claimAllFromBatches(address holder, uint256 tillBatch) internal {
1093         Balance storage b = holders[holder];
1094         bool firstUnclaimedFound;
1095         uint256 claiming;
1096         for (uint256 i = b.firstUnclaimedBatch; i < tillBatch; i++) {
1097             (uint256 claimable, bool fullyClaimable) = calculateClaimableFromBatch(b.batches[i]);
1098             if (claimable > 0) {
1099                 b.batches[i].claimed = b.batches[i].claimed.add(claimable);
1100                 claiming = claiming.add(claimable);
1101             }
1102             if (!fullyClaimable && !firstUnclaimedFound) {
1103                 b.firstUnclaimedBatch = i;
1104                 firstUnclaimedFound = true;
1105             }
1106         }
1107         if (!firstUnclaimedFound) {
1108             b.firstUnclaimedBatch = b.batches.length;
1109         }
1110         if (claiming > 0) {
1111             b.locked = b.locked.sub(claiming);
1112             b.unlocked = b.unlocked.add(claiming);
1113             emit Unlocked(holder, claiming);
1114         }
1115     }
1116 
1117     /**
1118      * @notice Calculates claimable amount from all batches
1119      * @param holder pointer to a batch
1120      * @return claimable amount
1121      */
1122     function calculateClaimableFromBatches(address holder) internal view returns (uint256) {
1123         Balance storage b = holders[holder];
1124         uint256 claiming;
1125         for (uint256 i = b.firstUnclaimedBatch; i < b.batches.length; i++) {
1126             (uint256 claimable, ) = calculateClaimableFromBatch(b.batches[i]);
1127             claiming = claiming.add(claimable);
1128         }
1129         return claiming;
1130     }
1131 
1132     /**
1133      * @notice Calculates one batch
1134      * @param vb pointer to a batch
1135      * @return claimable amount and bool which is true if batch is fully claimable
1136      */
1137     function calculateClaimableFromBatch(VestedBatch storage vb) internal view returns (uint256, bool) {
1138         if (now < vestingStart.add(vestingCliff)) {
1139             return (0, false); // No unlcoks before cliff period is over
1140         }
1141         if (now >= vestingStart.add(vestingPeriod)) {
1142             return (vb.amount.sub(vb.claimed), true);
1143         }
1144         uint256 claimable = (vb.amount.mul(now.sub(vestingStart)).div(vestingPeriod)).sub(vb.claimed);
1145         return (claimable, false);
1146     }
1147 }