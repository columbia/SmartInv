1 pragma solidity ^0.6.12;
2 // SPDX-License-Identifier: MIT
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
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 /**
99  * @dev Wrappers over Solidity's arithmetic operations with added overflow
100  * checks.
101  *
102  * Arithmetic operations in Solidity wrap on overflow. This can easily result
103  * in bugs, because programmers usually assume that an overflow raises an
104  * error, which is the standard behavior in high level programming languages.
105  * `SafeMath` restores this intuition by reverting the transaction when an
106  * operation overflows.
107  *
108  * Using this library instead of the unchecked operations eliminates an entire
109  * class of bugs, so it's recommended to use it always.
110  */
111 library SafeMath {
112     /**
113      * @dev Returns the addition of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `+` operator.
117      *
118      * Requirements:
119      *
120      * - Addition cannot overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b <= a, errorMessage);
155         uint256 c = a - b;
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the multiplication of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `*` operator.
165      *
166      * Requirements:
167      *
168      * - Multiplication cannot overflow.
169      */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
172         // benefit is lost if 'b' is also tested.
173         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
174         if (a == 0) {
175             return 0;
176         }
177 
178         uint256 c = a * b;
179         require(c / a == b, "SafeMath: multiplication overflow");
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         return div(a, b, "SafeMath: division by zero");
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         uint256 c = a / b;
215         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         return mod(a, b, "SafeMath: modulo by zero");
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts with custom message when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b != 0, errorMessage);
250         return a % b;
251     }
252 }
253 
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if `account` is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, `isContract` will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      */
276     function isContract(address account) internal view returns (bool) {
277         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
278         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
279         // for accounts without code, i.e. `keccak256('')`
280         bytes32 codehash;
281         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
282         // solhint-disable-next-line no-inline-assembly
283         assembly { codehash := extcodehash(account) }
284         return (codehash != accountHash && codehash != 0x0);
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
307         (bool success, ) = recipient.call{ value: amount }("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 
311     /**
312      * @dev Performs a Solidity function call using a low level `call`. A
313      * plain`call` is an unsafe replacement for a function call: use this
314      * function instead.
315      *
316      * If `target` reverts with a revert reason, it is bubbled up by this
317      * function (like regular Solidity function calls).
318      *
319      * Returns the raw returned data. To convert to the expected return value,
320      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
321      *
322      * Requirements:
323      *
324      * - `target` must be a contract.
325      * - calling `target` with `data` must not revert.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
330       return functionCall(target, data, "Address: low-level call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
335      * `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
340         return _functionCallWithValue(target, data, 0, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but also transferring `value` wei to `target`.
346      *
347      * Requirements:
348      *
349      * - the calling contract must have an ETH balance of at least `value`.
350      * - the called Solidity function must be `payable`.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
360      * with `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
365         require(address(this).balance >= value, "Address: insufficient balance for call");
366         return _functionCallWithValue(target, data, value, errorMessage);
367     }
368 
369     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
370         require(isContract(target), "Address: call to non-contract");
371 
372         // solhint-disable-next-line avoid-low-level-calls
373         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
374         if (success) {
375             return returndata;
376         } else {
377             // Look for revert reason and bubble it up if present
378             if (returndata.length > 0) {
379                 // The easiest way to bubble the revert reason is using memory via assembly
380 
381                 // solhint-disable-next-line no-inline-assembly
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 }
392 
393 /**
394  * @title SafeERC20
395  * @dev Wrappers around ERC20 operations that throw on failure (when the token
396  * contract returns false). Tokens that return no value (and instead revert or
397  * throw on failure) are also supported, non-reverting calls are assumed to be
398  * successful.
399  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
400  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
401  */
402 library SafeERC20 {
403     using SafeMath for uint256;
404     using Address for address;
405 
406     function safeTransfer(IERC20 token, address to, uint256 value) internal {
407         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
408     }
409 
410     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
411         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
412     }
413 
414     /**
415      * @dev Deprecated. This function has issues similar to the ones found in
416      * {IERC20-approve}, and its usage is discouraged.
417      *
418      * Whenever possible, use {safeIncreaseAllowance} and
419      * {safeDecreaseAllowance} instead.
420      */
421     function safeApprove(IERC20 token, address spender, uint256 value) internal {
422         // safeApprove should only be called when setting an initial allowance,
423         // or when resetting it to zero. To increase and decrease it, use
424         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
425         // solhint-disable-next-line max-line-length
426         require((value == 0) || (token.allowance(address(this), spender) == 0),
427             "SafeERC20: approve from non-zero to non-zero allowance"
428         );
429         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
430     }
431 
432     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
433         uint256 newAllowance = token.allowance(address(this), spender).add(value);
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
435     }
436 
437     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
438         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
439         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
440     }
441 
442     /**
443      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
444      * on the return value: the return value is optional (but if data is returned, it must not be false).
445      * @param token The token targeted by the call.
446      * @param data The call data (encoded using abi.encode or one of its variants).
447      */
448     function _callOptionalReturn(IERC20 token, bytes memory data) private {
449         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
450         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
451         // the target address contains contract code and also asserts for success in the low-level call.
452 
453         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
454         if (returndata.length > 0) { // Return data is optional
455             // solhint-disable-next-line max-line-length
456             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
457         }
458     }
459 }
460 
461 
462 
463 /**
464  * @dev Contract module which provides a basic access control mechanism, where
465  * there is an account (an owner) that can be granted exclusive access to
466  * specific functions.
467  *
468  * By default, the owner account will be the one that deploys the contract. This
469  * can later be changed with {transferOwnership}.
470  *
471  * This module is used through inheritance. It will make available the modifier
472  * `onlyOwner`, which can be applied to your functions to restrict their use to
473  * the owner.
474  */
475 contract Ownable is Context {
476     address private _owner;
477 
478     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
479 
480     /**
481      * @dev Initializes the contract setting the deployer as the initial owner.
482      */
483     constructor () internal {
484         address msgSender = _msgSender();
485         _owner = msgSender;
486         emit OwnershipTransferred(address(0), msgSender);
487     }
488 
489     /**
490      * @dev Returns the address of the current owner.
491      */
492     function owner() public view returns (address) {
493         return _owner;
494     }
495 
496     /**
497      * @dev Throws if called by any account other than the owner.
498      */
499     modifier onlyOwner() {
500         require(_owner == _msgSender(), "Ownable: caller is not the owner");
501         _;
502     }
503 
504     /**
505      * @dev Leaves the contract without owner. It will not be possible to call
506      * `onlyOwner` functions anymore. Can only be called by the current owner.
507      *
508      * NOTE: Renouncing ownership will leave the contract without an owner,
509      * thereby removing any functionality that is only available to the owner.
510      */
511     function renounceOwnership() public virtual onlyOwner {
512         emit OwnershipTransferred(_owner, address(0));
513         _owner = address(0);
514     }
515 
516     /**
517      * @dev Transfers ownership of the contract to a new account (`newOwner`).
518      * Can only be called by the current owner.
519      */
520     function transferOwnership(address newOwner) public virtual onlyOwner {
521         require(newOwner != address(0), "Ownable: new owner is the zero address");
522         emit OwnershipTransferred(_owner, newOwner);
523         _owner = newOwner;
524     }
525 }
526 
527 
528 /**
529  * @dev Implementation of the {IERC20} interface.
530  *
531  * This implementation is agnostic to the way tokens are created. This means
532  * that a supply mechanism has to be added in a derived contract using {_mint}.
533  * For a generic mechanism see {ERC20PresetMinterPauser}.
534  *
535  * TIP: For a detailed writeup see our guide
536  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
537  * to implement supply mechanisms].
538  *
539  * We have followed general OpenZeppelin guidelines: functions revert instead
540  * of returning `false` on failure. This behavior is nonetheless conventional
541  * and does not conflict with the expectations of ERC20 applications.
542  *
543  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
544  * This allows applications to reconstruct the allowance for all accounts just
545  * by listening to said events. Other implementations of the EIP may not emit
546  * these events, as it isn't required by the specification.
547  *
548  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
549  * functions have been added to mitigate the well-known issues around setting
550  * allowances. See {IERC20-approve}.
551  */
552 contract ERC20 is Context, IERC20 {
553     using SafeMath for uint256;
554     using Address for address;
555 
556     mapping (address => uint256) private _balances;
557 
558     mapping (address => mapping (address => uint256)) private _allowances;
559 
560     uint256 private _totalSupply;
561 
562     string private _name;
563     string private _symbol;
564     uint8 private _decimals;
565 
566     /**
567      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
568      * a default value of 18.
569      *
570      * To select a different value for {decimals}, use {_setupDecimals}.
571      *
572      * All three of these values are immutable: they can only be set once during
573      * construction.
574      */
575     constructor (string memory name, string memory symbol) public {
576         _name = name;
577         _symbol = symbol;
578         _decimals = 18;
579     }
580 
581     /**
582      * @dev Returns the name of the token.
583      */
584     function name() public view returns (string memory) {
585         return _name;
586     }
587 
588     /**
589      * @dev Returns the symbol of the token, usually a shorter version of the
590      * name.
591      */
592     function symbol() public view returns (string memory) {
593         return _symbol;
594     }
595 
596     /**
597      * @dev Returns the number of decimals used to get its user representation.
598      * For example, if `decimals` equals `2`, a balance of `505` tokens should
599      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
600      *
601      * Tokens usually opt for a value of 18, imitating the relationship between
602      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
603      * called.
604      *
605      * NOTE: This information is only used for _display_ purposes: it in
606      * no way affects any of the arithmetic of the contract, including
607      * {IERC20-balanceOf} and {IERC20-transfer}.
608      */
609     function decimals() public view returns (uint8) {
610         return _decimals;
611     }
612 
613     /**
614      * @dev See {IERC20-totalSupply}.
615      */
616     function totalSupply() public view override returns (uint256) {
617         return _totalSupply;
618     }
619 
620     /**
621      * @dev See {IERC20-balanceOf}.
622      */
623     function balanceOf(address account) public view override returns (uint256) {
624         return _balances[account];
625     }
626 
627     /**
628      * @dev See {IERC20-transfer}.
629      *
630      * Requirements:
631      *
632      * - `recipient` cannot be the zero address.
633      * - the caller must have a balance of at least `amount`.
634      */
635     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
636         _transfer(_msgSender(), recipient, amount);
637         return true;
638     }
639 
640     /**
641      * @dev See {IERC20-allowance}.
642      */
643     function allowance(address owner, address spender) public view virtual override returns (uint256) {
644         return _allowances[owner][spender];
645     }
646 
647     /**
648      * @dev See {IERC20-approve}.
649      *
650      * Requirements:
651      *
652      * - `spender` cannot be the zero address.
653      */
654     function approve(address spender, uint256 amount) public virtual override returns (bool) {
655         _approve(_msgSender(), spender, amount);
656         return true;
657     }
658 
659     /**
660      * @dev See {IERC20-transferFrom}.
661      *
662      * Emits an {Approval} event indicating the updated allowance. This is not
663      * required by the EIP. See the note at the beginning of {ERC20};
664      *
665      * Requirements:
666      * - `sender` and `recipient` cannot be the zero address.
667      * - `sender` must have a balance of at least `amount`.
668      * - the caller must have allowance for ``sender``'s tokens of at least
669      * `amount`.
670      */
671     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
672         _transfer(sender, recipient, amount);
673         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
674         return true;
675     }
676 
677     /**
678      * @dev Atomically increases the allowance granted to `spender` by the caller.
679      *
680      * This is an alternative to {approve} that can be used as a mitigation for
681      * problems described in {IERC20-approve}.
682      *
683      * Emits an {Approval} event indicating the updated allowance.
684      *
685      * Requirements:
686      *
687      * - `spender` cannot be the zero address.
688      */
689     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
690         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
691         return true;
692     }
693 
694     /**
695      * @dev Atomically decreases the allowance granted to `spender` by the caller.
696      *
697      * This is an alternative to {approve} that can be used as a mitigation for
698      * problems described in {IERC20-approve}.
699      *
700      * Emits an {Approval} event indicating the updated allowance.
701      *
702      * Requirements:
703      *
704      * - `spender` cannot be the zero address.
705      * - `spender` must have allowance for the caller of at least
706      * `subtractedValue`.
707      */
708     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
709         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
710         return true;
711     }
712 
713     /**
714      * @dev Moves tokens `amount` from `sender` to `recipient`.
715      *
716      * This is internal function is equivalent to {transfer}, and can be used to
717      * e.g. implement automatic token fees, slashing mechanisms, etc.
718      *
719      * Emits a {Transfer} event.
720      *
721      * Requirements:
722      *
723      * - `sender` cannot be the zero address.
724      * - `recipient` cannot be the zero address.
725      * - `sender` must have a balance of at least `amount`.
726      */
727     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
728         require(sender != address(0), "ERC20: transfer from the zero address");
729         require(recipient != address(0), "ERC20: transfer to the zero address");
730 
731         _beforeTokenTransfer(sender, recipient, amount);
732 
733         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
734         _balances[recipient] = _balances[recipient].add(amount);
735         emit Transfer(sender, recipient, amount);
736     }
737 
738     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
739      * the total supply.
740      *
741      * Emits a {Transfer} event with `from` set to the zero address.
742      *
743      * Requirements
744      *
745      * - `to` cannot be the zero address.
746      */
747     function _mint(address account, uint256 amount) internal virtual {
748         require(account != address(0), "ERC20: mint to the zero address");
749 
750         _beforeTokenTransfer(address(0), account, amount);
751 
752         _totalSupply = _totalSupply.add(amount);
753         _balances[account] = _balances[account].add(amount);
754         emit Transfer(address(0), account, amount);
755     }
756 
757     /**
758      * @dev Destroys `amount` tokens from `account`, reducing the
759      * total supply.
760      *
761      * Emits a {Transfer} event with `to` set to the zero address.
762      *
763      * Requirements
764      *
765      * - `account` cannot be the zero address.
766      * - `account` must have at least `amount` tokens.
767      */
768     function _burn(address account, uint256 amount) internal virtual {
769         require(account != address(0), "ERC20: burn from the zero address");
770 
771         _beforeTokenTransfer(account, address(0), amount);
772 
773         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
774         _totalSupply = _totalSupply.sub(amount);
775         emit Transfer(account, address(0), amount);
776     }
777 
778     /**
779      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
780      *
781      * This is internal function is equivalent to `approve`, and can be used to
782      * e.g. set automatic allowances for certain subsystems, etc.
783      *
784      * Emits an {Approval} event.
785      *
786      * Requirements:
787      *
788      * - `owner` cannot be the zero address.
789      * - `spender` cannot be the zero address.
790      */
791     function _approve(address owner, address spender, uint256 amount) internal virtual {
792         require(owner != address(0), "ERC20: approve from the zero address");
793         require(spender != address(0), "ERC20: approve to the zero address");
794 
795         _allowances[owner][spender] = amount;
796         emit Approval(owner, spender, amount);
797     }
798 
799     /**
800      * @dev Sets {decimals} to a value other than the default one of 18.
801      *
802      * WARNING: This function should only be called from the constructor. Most
803      * applications that interact with token contracts will not expect
804      * {decimals} to ever change, and may work incorrectly if it does.
805      */
806     function _setupDecimals(uint8 decimals_) internal {
807         _decimals = decimals_;
808     }
809 
810     /**
811      * @dev Hook that is called before any transfer of tokens. This includes
812      * minting and burning.
813      *
814      * Calling conditions:
815      *
816      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
817      * will be to transferred to `to`.
818      * - when `from` is zero, `amount` tokens will be minted for `to`.
819      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
820      * - `from` and `to` are never both zero.
821      *
822      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
823      */
824     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
825 }
826 
827 // MoondustToken with Governance.
828 contract MoondustToken is ERC20("MoondustToken", "MOONDUST"), Ownable {
829     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
830     function mint(address _to, uint256 _amount) public onlyOwner {
831         _mint(_to, _amount);
832     }
833 }
834 
835 contract MOONDUSTChef is Ownable {
836     using SafeMath for uint256;
837     using SafeERC20 for IERC20;
838 
839     // Info of each user.
840     struct UserInfo {
841         uint256 amount;     // How many LP tokens the user has provided.
842         uint256 rewardDebt; // Reward debt. See explanation below.
843         //
844         // We do some fancy math here. Basically, any point in time, the amount of MOONDUSTs
845         // entitled to a user but is pending to be distributed is:
846         //
847         //   pending reward = (user.amount * pool.accMOONDUSTPerShare) - user.rewardDebt
848         //
849         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
850         //   1. The pool's `accMOONDUSTPerShare` (and `lastRewardBlock`) gets updated.
851         //   2. User receives the pending reward sent to his/her address.
852         //   3. User's `amount` gets updated.
853         //   4. User's `rewardDebt` gets updated.
854     }
855 
856     // Info of each pool.
857     struct PoolInfo {
858         IERC20 lpToken;           // Address of LP token contract.
859         uint256 allocPoint;       // How many allocation points assigned to this pool. MOONDUSTs to distribute per block.
860         uint256 lastRewardBlock;  // Last block number that MOONDUSTs distribution occurs.
861         uint256 accMOONDUSTPerShare; // Accumulated MOONDUSTs per share, times 1e12. See below.
862     }
863 
864     // The MOONDUST TOKEN!
865     MoondustToken public MOONDUST;
866     // Dev address.
867     address public devaddr;
868     // Block number when bonus MOONDUST period ends.
869     uint256 public bonusEndBlock;
870     // MOONDUST tokens created per block.
871     uint256 public MOONDUSTPerBlock;
872     // Bonus muliplier for early MOONDUST makers.
873     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
874 
875     // No of blocks in a day  - 7000
876     uint256 public constant perDayBlocks = 7000; // no bonus
877 
878     // Info of each pool.
879     PoolInfo[] public poolInfo;
880     // Info of each user that stakes LP tokens.
881     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
882     // Total allocation poitns. Must be the sum of all allocation points in all pools.
883     uint256 public totalAllocPoint = 0;
884     // The block number when MOONDUST mining starts.
885     uint256 public startBlock;
886 
887     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
888     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
889     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
890 
891     constructor(
892         MoondustToken _MOONDUST,
893         address _devaddr,
894         uint256 _MOONDUSTPerBlock,
895         uint256 _startBlock,
896         uint256 _bonusEndBlock
897     ) public {
898         MOONDUST = _MOONDUST;
899         devaddr = _devaddr;
900         MOONDUSTPerBlock = _MOONDUSTPerBlock;
901         bonusEndBlock = _bonusEndBlock;
902         startBlock = _startBlock;
903     }
904 
905     function poolLength() external view returns (uint256) {
906         return poolInfo.length;
907     }
908 
909     // Add a new lp to the pool. Can only be called by the owner.
910     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
911     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
912         if (_withUpdate) {
913             massUpdatePools();
914         }
915         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
916         totalAllocPoint = totalAllocPoint.add(_allocPoint);
917         poolInfo.push(PoolInfo({
918             lpToken: _lpToken,
919             allocPoint: _allocPoint,
920             lastRewardBlock: lastRewardBlock,
921             accMOONDUSTPerShare: 0
922         }));
923     }
924 
925     // Update the given pool's MOONDUST allocation point. Can only be called by the owner.
926     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
927         if (_withUpdate) {
928             massUpdatePools();
929         }
930         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
931         poolInfo[_pid].allocPoint = _allocPoint;
932     }
933 
934 
935 
936     // Return reward multiplier over the given _from to _to block.
937     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
938         if (_to <= bonusEndBlock) {
939             return _to.sub(_from).mul(BONUS_MULTIPLIER);
940         } else if (_from >= bonusEndBlock) {
941             return _to.sub(_from);
942         } else {
943             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
944                 _to.sub(bonusEndBlock)
945             );
946         }
947     }
948     
949      // reward prediction at specific block
950     function getRewardPerBlock(uint blockNumber) public view returns (uint256) {
951         if (blockNumber >= startBlock){
952 
953             uint256 blockDaysPassed = (blockNumber.sub(startBlock)).div(perDayBlocks);
954 
955             if(blockDaysPassed <= 0){
956                  return MOONDUSTPerBlock;
957             }
958             else if(blockDaysPassed > 0 && blockDaysPassed <= 7){
959                  return MOONDUSTPerBlock.div(2);
960             }
961             else if(blockDaysPassed > 7 && blockDaysPassed <= 30){
962                  return MOONDUSTPerBlock.div(4);
963             }
964             else if(blockDaysPassed > 30 && blockDaysPassed <= 90){
965                  return MOONDUSTPerBlock.div(8);
966             }
967             else {
968                 return MOONDUSTPerBlock.div(10);
969             }
970 
971         } else {
972             return 0;
973         }
974     }
975 
976     // View function to see pending MOONDUSTs on frontend.
977     function pendingMOONDUST(uint256 _pid, address _user) external view returns (uint256) {
978         PoolInfo storage pool = poolInfo[_pid];
979         UserInfo storage user = userInfo[_pid][_user];
980         uint256 accMOONDUSTPerShare = pool.accMOONDUSTPerShare;
981         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
982         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
983             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
984             uint256 rewardThisBlock = getRewardPerBlock(block.number);
985             uint256 MOONDUSTReward = multiplier.mul(rewardThisBlock).mul(pool.allocPoint).div(totalAllocPoint);
986             accMOONDUSTPerShare = accMOONDUSTPerShare.add(MOONDUSTReward.mul(1e12).div(lpSupply));
987         }
988         return user.amount.mul(accMOONDUSTPerShare).div(1e12).sub(user.rewardDebt);
989     }
990 
991     // Update reward vairables for all pools. Be careful of gas spending!
992     function massUpdatePools() public {
993         uint256 length = poolInfo.length;
994         for (uint256 pid = 0; pid < length; ++pid) {
995             updatePool(pid);
996         }
997     }
998 
999 
1000     // Update reward variables of the given pool to be up-to-date.
1001     function updatePool(uint256 _pid) public {
1002         PoolInfo storage pool = poolInfo[_pid];
1003         if (block.number <= pool.lastRewardBlock) {
1004             return;
1005         }
1006         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1007         if (lpSupply == 0) {
1008             pool.lastRewardBlock = block.number;
1009             return;
1010         }
1011         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1012         uint256 rewardThisBlock = getRewardPerBlock(block.number);
1013         uint256 MOONDUSTReward = multiplier.mul(rewardThisBlock).mul(pool.allocPoint).div(totalAllocPoint);
1014         MOONDUST.mint(devaddr, MOONDUSTReward.div(25)); // 4%
1015         MOONDUST.mint(address(this), MOONDUSTReward);
1016         pool.accMOONDUSTPerShare = pool.accMOONDUSTPerShare.add(MOONDUSTReward.mul(1e12).div(lpSupply));
1017         pool.lastRewardBlock = block.number;
1018     }
1019 
1020     // Deposit LP tokens to MasterChef for MOONDUST allocation.
1021     function deposit(uint256 _pid, uint256 _amount) public {
1022         PoolInfo storage pool = poolInfo[_pid];
1023         UserInfo storage user = userInfo[_pid][msg.sender];
1024         updatePool(_pid);
1025         if (user.amount > 0) {
1026             uint256 pending = user.amount.mul(pool.accMOONDUSTPerShare).div(1e12).sub(user.rewardDebt);
1027             safeMOONDUSTTransfer(msg.sender, pending);
1028         }
1029         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1030         user.amount = user.amount.add(_amount);
1031         user.rewardDebt = user.amount.mul(pool.accMOONDUSTPerShare).div(1e12);
1032         emit Deposit(msg.sender, _pid, _amount);
1033     }
1034 
1035     // Withdraw LP tokens from MasterChef.
1036     function withdraw(uint256 _pid, uint256 _amount) public {
1037         PoolInfo storage pool = poolInfo[_pid];
1038         UserInfo storage user = userInfo[_pid][msg.sender];
1039         require(user.amount >= _amount, "withdraw: not good");
1040         updatePool(_pid);
1041         uint256 pending = user.amount.mul(pool.accMOONDUSTPerShare).div(1e12).sub(user.rewardDebt);
1042         safeMOONDUSTTransfer(msg.sender, pending);
1043         user.amount = user.amount.sub(_amount);
1044         user.rewardDebt = user.amount.mul(pool.accMOONDUSTPerShare).div(1e12);
1045         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1046         emit Withdraw(msg.sender, _pid, _amount);
1047     }
1048 
1049     // Withdraw without caring about rewards. EMERGENCY ONLY.
1050     function emergencyWithdraw(uint256 _pid) public {
1051         PoolInfo storage pool = poolInfo[_pid];
1052         UserInfo storage user = userInfo[_pid][msg.sender];
1053         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1054         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1055         user.amount = 0;
1056         user.rewardDebt = 0;
1057     }
1058 
1059     // Safe MOONDUST transfer function, just in case if rounding error causes pool to not have enough MOONDUSTs.
1060     function safeMOONDUSTTransfer(address _to, uint256 _amount) internal {
1061         uint256 MOONDUSTBal = MOONDUST.balanceOf(address(this));
1062         if (_amount > MOONDUSTBal) {
1063             MOONDUST.transfer(_to, MOONDUSTBal);
1064         } else {
1065             MOONDUST.transfer(_to, _amount);
1066         }
1067     }
1068 
1069     // Update dev address by the previous dev.
1070     function dev(address _devaddr) public {
1071         require(msg.sender == devaddr, "dev: wut?");
1072         devaddr = _devaddr;
1073     }
1074 }