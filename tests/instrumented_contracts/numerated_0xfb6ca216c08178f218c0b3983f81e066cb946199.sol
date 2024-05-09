1 /**
2  * SPDX-License-Identifier: MIT
3 */
4 pragma solidity ^0.6.12;
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `+` operator.
119      *
120      * Requirements:
121      *
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the multiplication of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `*` operator.
167      *
168      * Requirements:
169      *
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         return div(a, b, "SafeMath: division by zero");
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b != 0, errorMessage);
252         return a % b;
253     }
254 }
255 
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies in extcodesize, which returns 0 for contracts in
280         // construction, since the code is only stored at the end of the
281         // constructor execution.
282 
283         uint256 size;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { size := extcodesize(account) }
286         return size > 0;
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
309         (bool success, ) = recipient.call{ value: amount }("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain`call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332       return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337      * `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
342         return _functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         return _functionCallWithValue(target, data, value, errorMessage);
369     }
370 
371     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
372         require(isContract(target), "Address: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 // solhint-disable-next-line no-inline-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 /**
396  * @title SafeERC20
397  * @dev Wrappers around ERC20 operations that throw on failure (when the token
398  * contract returns false). Tokens that return no value (and instead revert or
399  * throw on failure) are also supported, non-reverting calls are assumed to be
400  * successful.
401  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
402  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
403  */
404 library SafeERC20 {
405     using SafeMath for uint256;
406     using Address for address;
407 
408     function safeTransfer(IERC20 token, address to, uint256 value) internal {
409         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
410     }
411 
412     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
413         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
414     }
415 
416     /**
417      * @dev Deprecated. This function has issues similar to the ones found in
418      * {IERC20-approve}, and its usage is discouraged.
419      *
420      * Whenever possible, use {safeIncreaseAllowance} and
421      * {safeDecreaseAllowance} instead.
422      */
423     function safeApprove(IERC20 token, address spender, uint256 value) internal {
424         // safeApprove should only be called when setting an initial allowance,
425         // or when resetting it to zero. To increase and decrease it, use
426         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
427         // solhint-disable-next-line max-line-length
428         require((value == 0) || (token.allowance(address(this), spender) == 0),
429             "SafeERC20: approve from non-zero to non-zero allowance"
430         );
431         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
432     }
433 
434     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).add(value);
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     /**
445      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
446      * on the return value: the return value is optional (but if data is returned, it must not be false).
447      * @param token The token targeted by the call.
448      * @param data The call data (encoded using abi.encode or one of its variants).
449      */
450     function _callOptionalReturn(IERC20 token, bytes memory data) private {
451         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
452         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
453         // the target address contains contract code and also asserts for success in the low-level call.
454 
455         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
456         if (returndata.length > 0) { // Return data is optional
457             // solhint-disable-next-line max-line-length
458             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
459         }
460     }
461 }
462 
463 
464 
465 /**
466  * @dev Contract module which provides a basic access control mechanism, where
467  * there is an account (an owner) that can be granted exclusive access to
468  * specific functions.
469  *
470  * By default, the owner account will be the one that deploys the contract. This
471  * can later be changed with {transferOwnership}.
472  *
473  * This module is used through inheritance. It will make available the modifier
474  * `onlyOwner`, which can be applied to your functions to restrict their use to
475  * the owner.
476  */
477 contract Ownable is Context {
478     address private _owner;
479 
480     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
481 
482     /**
483      * @dev Initializes the contract setting the deployer as the initial owner.
484      */
485     constructor () internal {
486         address msgSender = _msgSender();
487         _owner = msgSender;
488         emit OwnershipTransferred(address(0), msgSender);
489     }
490 
491     /**
492      * @dev Returns the address of the current owner.
493      */
494     function owner() public view returns (address) {
495         return _owner;
496     }
497 
498     /**
499      * @dev Throws if called by any account other than the owner.
500      */
501     modifier onlyOwner() {
502         require(_owner == _msgSender(), "Ownable: caller is not the owner");
503         _;
504     }
505 
506     /**
507      * @dev Leaves the contract without owner. It will not be possible to call
508      * `onlyOwner` functions anymore. Can only be called by the current owner.
509      *
510      * NOTE: Renouncing ownership will leave the contract without an owner,
511      * thereby removing any functionality that is only available to the owner.
512      */
513     function renounceOwnership() public virtual onlyOwner {
514         emit OwnershipTransferred(_owner, address(0));
515         _owner = address(0);
516     }
517 
518     /**
519      * @dev Transfers ownership of the contract to a new account (`newOwner`).
520      * Can only be called by the current owner.
521      */
522     function transferOwnership(address newOwner) public virtual onlyOwner {
523         require(newOwner != address(0), "Ownable: new owner is the zero address");
524         emit OwnershipTransferred(_owner, newOwner);
525         _owner = newOwner;
526     }
527 }
528 
529 
530 /**
531  * @dev Implementation of the {IERC20} interface.
532  *
533  * This implementation is agnostic to the way tokens are created. This means
534  * that a supply mechanism has to be added in a derived contract using {_mint}.
535  * For a generic mechanism see {ERC20PresetMinterPauser}.
536  *
537  * TIP: For a detailed writeup see our guide
538  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
539  * to implement supply mechanisms].
540  *
541  * We have followed general OpenZeppelin guidelines: functions revert instead
542  * of returning `false` on failure. This behavior is nonetheless conventional
543  * and does not conflict with the expectations of ERC20 applications.
544  *
545  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
546  * This allows applications to reconstruct the allowance for all accounts just
547  * by listening to said events. Other implementations of the EIP may not emit
548  * these events, as it isn't required by the specification.
549  *
550  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
551  * functions have been added to mitigate the well-known issues around setting
552  * allowances. See {IERC20-approve}.
553  */
554 contract ERC20 is Context, IERC20 {
555     using SafeMath for uint256;
556     using Address for address;
557 
558     mapping (address => uint256) private _balances;
559 
560     mapping (address => mapping (address => uint256)) private _allowances;
561 
562     uint256 private _totalSupply;
563 
564     string private _name;
565     string private _symbol;
566     uint8 private _decimals;
567 
568     /**
569      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
570      * a default value of 18.
571      *
572      * To select a different value for {decimals}, use {_setupDecimals}.
573      *
574      * All three of these values are immutable: they can only be set once during
575      * construction.
576      */
577     constructor (string memory name, string memory symbol) public {
578         _name = name;
579         _symbol = symbol;
580         _decimals = 18;
581     }
582 
583     /**
584      * @dev Returns the name of the token.
585      */
586     function name() public view returns (string memory) {
587         return _name;
588     }
589 
590     /**
591      * @dev Returns the symbol of the token, usually a shorter version of the
592      * name.
593      */
594     function symbol() public view returns (string memory) {
595         return _symbol;
596     }
597 
598     /**
599      * @dev Returns the number of decimals used to get its user representation.
600      * For example, if `decimals` equals `2`, a balance of `505` tokens should
601      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
602      *
603      * Tokens usually opt for a value of 18, imitating the relationship between
604      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
605      * called.
606      *
607      * NOTE: This information is only used for _display_ purposes: it in
608      * no way affects any of the arithmetic of the contract, including
609      * {IERC20-balanceOf} and {IERC20-transfer}.
610      */
611     function decimals() public view returns (uint8) {
612         return _decimals;
613     }
614 
615     /**
616      * @dev See {IERC20-totalSupply}.
617      */
618     function totalSupply() public view override returns (uint256) {
619         return _totalSupply;
620     }
621 
622     /**
623      * @dev See {IERC20-balanceOf}.
624      */
625     function balanceOf(address account) public view override returns (uint256) {
626         return _balances[account];
627     }
628 
629     /**
630      * @dev See {IERC20-transfer}.
631      *
632      * Requirements:
633      *
634      * - `recipient` cannot be the zero address.
635      * - the caller must have a balance of at least `amount`.
636      */
637     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
638         _transfer(_msgSender(), recipient, amount);
639         return true;
640     }
641 
642     /**
643      * @dev See {IERC20-allowance}.
644      */
645     function allowance(address owner, address spender) public view virtual override returns (uint256) {
646         return _allowances[owner][spender];
647     }
648 
649     /**
650      * @dev See {IERC20-approve}.
651      *
652      * Requirements:
653      *
654      * - `spender` cannot be the zero address.
655      */
656     function approve(address spender, uint256 amount) public virtual override returns (bool) {
657         _approve(_msgSender(), spender, amount);
658         return true;
659     }
660 
661     /**
662      * @dev See {IERC20-transferFrom}.
663      *
664      * Emits an {Approval} event indicating the updated allowance. This is not
665      * required by the EIP. See the note at the beginning of {ERC20};
666      *
667      * Requirements:
668      * - `sender` and `recipient` cannot be the zero address.
669      * - `sender` must have a balance of at least `amount`.
670      * - the caller must have allowance for ``sender``'s tokens of at least
671      * `amount`.
672      */
673     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
674         _transfer(sender, recipient, amount);
675         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
676         return true;
677     }
678 
679     /**
680      * @dev Atomically increases the allowance granted to `spender` by the caller.
681      *
682      * This is an alternative to {approve} that can be used as a mitigation for
683      * problems described in {IERC20-approve}.
684      *
685      * Emits an {Approval} event indicating the updated allowance.
686      *
687      * Requirements:
688      *
689      * - `spender` cannot be the zero address.
690      */
691     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
692         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
693         return true;
694     }
695 
696     /**
697      * @dev Atomically decreases the allowance granted to `spender` by the caller.
698      *
699      * This is an alternative to {approve} that can be used as a mitigation for
700      * problems described in {IERC20-approve}.
701      *
702      * Emits an {Approval} event indicating the updated allowance.
703      *
704      * Requirements:
705      *
706      * - `spender` cannot be the zero address.
707      * - `spender` must have allowance for the caller of at least
708      * `subtractedValue`.
709      */
710     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
711         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
712         return true;
713     }
714 
715     /**
716      * @dev Moves tokens `amount` from `sender` to `recipient`.
717      *
718      * This is internal function is equivalent to {transfer}, and can be used to
719      * e.g. implement automatic token fees, slashing mechanisms, etc.
720      *
721      * Emits a {Transfer} event.
722      *
723      * Requirements:
724      *
725      * - `sender` cannot be the zero address.
726      * - `recipient` cannot be the zero address.
727      * - `sender` must have a balance of at least `amount`.
728      */
729     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
730         require(sender != address(0), "ERC20: transfer from the zero address");
731         require(recipient != address(0), "ERC20: transfer to the zero address");
732 
733         _beforeTokenTransfer(sender, recipient, amount);
734 
735         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
736         _balances[recipient] = _balances[recipient].add(amount);
737         emit Transfer(sender, recipient, amount);
738     }
739 
740     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
741      * the total supply.
742      *
743      * Emits a {Transfer} event with `from` set to the zero address.
744      *
745      * Requirements
746      *
747      * - `to` cannot be the zero address.
748      */
749     function _mint(address account, uint256 amount) internal virtual {
750         require(account != address(0), "ERC20: mint to the zero address");
751 
752         _beforeTokenTransfer(address(0), account, amount);
753 
754         _totalSupply = _totalSupply.add(amount);
755         _balances[account] = _balances[account].add(amount);
756         emit Transfer(address(0), account, amount);
757     }
758 
759     /**
760      * @dev Destroys `amount` tokens from `account`, reducing the
761      * total supply.
762      *
763      * Emits a {Transfer} event with `to` set to the zero address.
764      *
765      * Requirements
766      *
767      * - `account` cannot be the zero address.
768      * - `account` must have at least `amount` tokens.
769      */
770     function _burn(address account, uint256 amount) internal virtual {
771         require(account != address(0), "ERC20: burn from the zero address");
772 
773         _beforeTokenTransfer(account, address(0), amount);
774 
775         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
776         _totalSupply = _totalSupply.sub(amount);
777         emit Transfer(account, address(0), amount);
778     }
779 
780     /**
781      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
782      *
783      * This is internal function is equivalent to `approve`, and can be used to
784      * e.g. set automatic allowances for certain subsystems, etc.
785      *
786      * Emits an {Approval} event.
787      *
788      * Requirements:
789      *
790      * - `owner` cannot be the zero address.
791      * - `spender` cannot be the zero address.
792      */
793     function _approve(address owner, address spender, uint256 amount) internal virtual {
794         require(owner != address(0), "ERC20: approve from the zero address");
795         require(spender != address(0), "ERC20: approve to the zero address");
796 
797         _allowances[owner][spender] = amount;
798         emit Approval(owner, spender, amount);
799     }
800 
801     /**
802      * @dev Sets {decimals} to a value other than the default one of 18.
803      *
804      * WARNING: This function should only be called from the constructor. Most
805      * applications that interact with token contracts will not expect
806      * {decimals} to ever change, and may work incorrectly if it does.
807      */
808     function _setupDecimals(uint8 decimals_) internal {
809         _decimals = decimals_;
810     }
811 
812     /**
813      * @dev Hook that is called before any transfer of tokens. This includes
814      * minting and burning.
815      *
816      * Calling conditions:
817      *
818      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
819      * will be to transferred to `to`.
820      * - when `from` is zero, `amount` tokens will be minted for `to`.
821      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
822      * - `from` and `to` are never both zero.
823      *
824      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
825      */
826     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
827 }
828 
829 
830 contract FTCToken is ERC20("fantaCoin", "FTC"), Ownable {
831     /*
832     uint256 private constant gamesEarnSupply = 75600000 * 1e18;
833     uint256 private constant stakingRewardSupply =  97200000 * 1e18;
834     uint256 private constant ecologicalFundsSupply = 32400000 * 1e18;
835     uint256 private constant teamSupply = 79200000 * 1e18;
836     uint256 private constant airdropSupply = 10800000 * 1e18;
837     uint256 private constant privateSaleSupply = 21600000 * 1e18;
838     uint256 private constant pubiceSaleSupply = 43200000 * 1e18;
839    
840     address public constant  gameEarnsAddress = 0x8A06436a4E6DdA2523fD7d854f5A531DC3C3D411;
841     address public constant  stakingRewardAddress = 0x8A06436a4E6DdA2523fD7d854f5A531DC3C3D411;
842     address public constant  ecologicalFundsAddress = 0x8A06436a4E6DdA2523fD7d854f5A531DC3C3D411;
843     address public constant  teamAddress = 0x8A06436a4E6DdA2523fD7d854f5A531DC3C3D411;
844     address public constant  airdropAddress = 0x8A06436a4E6DdA2523fD7d854f5A531DC3C3D411;
845     address public constant  privateSaleAddress = 0x8A06436a4E6DdA2523fD7d854f5A531DC3C3D411;
846     address public constant  publicSaleAddress = 0x8A06436a4E6DdA2523fD7d854f5A531DC3C3D411;
847 
848    */
849     address public constant  allAddress = 0x5BC305C8d1Cc344D323458753459cd19f71afEB0;
850     uint256 private constant maxSupply = 360000000 * 1e18;
851    
852     constructor() public{
853           _mint(allAddress, maxSupply);
854         /*
855         _mint(gameEarnsAddress, gamesEarnSupply);
856         _mint(stakingRewardAddress, stakingRewardSupply);
857         _mint(ecologicalFundsAddress, ecologicalFundsSupply);
858         _mint(teamAddress, teamSupply);
859         _mint(airdropAddress, airdropSupply);
860         _mint(privateSaleAddress, privateSaleSupply);
861         _mint(publicSaleAddress, pubiceSaleSupply);
862         */
863     }
864    
865     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
866         if (_amount.add(totalSupply()) > maxSupply) {
867             return false;
868         }
869         _mint(_to, _amount);
870         return true;
871     }
872 }