1 /*
2  * banCORE Farm
3  * https://bancore.pro
4 */
5 
6 pragma solidity ^0.6.12;
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
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      *
124      * - Addition cannot overflow.
125      */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a, "SafeMath: addition overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 
258 
259 /**
260  * @dev Collection of functions related to the address type
261  */
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
282         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
283         // for accounts without code, i.e. `keccak256('')`
284         bytes32 codehash;
285         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { codehash := extcodehash(account) }
288         return (codehash != accountHash && codehash != 0x0);
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
311         (bool success, ) = recipient.call{ value: amount }("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316      * @dev Performs a Solidity function call using a low level `call`. A
317      * plain`call` is an unsafe replacement for a function call: use this
318      * function instead.
319      *
320      * If `target` reverts with a revert reason, it is bubbled up by this
321      * function (like regular Solidity function calls).
322      *
323      * Returns the raw returned data. To convert to the expected return value,
324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325      *
326      * Requirements:
327      *
328      * - `target` must be a contract.
329      * - calling `target` with `data` must not revert.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334       return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339      * `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
344         return _functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         return _functionCallWithValue(target, data, value, errorMessage);
371     }
372 
373     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
374         require(isContract(target), "Address: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 // solhint-disable-next-line no-inline-assembly
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 /**
398  * @title SafeERC20
399  * @dev Wrappers around ERC20 operations that throw on failure (when the token
400  * contract returns false). Tokens that return no value (and instead revert or
401  * throw on failure) are also supported, non-reverting calls are assumed to be
402  * successful.
403  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
404  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
405  */
406 library SafeERC20 {
407     using SafeMath for uint256;
408     using Address for address;
409 
410     function safeTransfer(IERC20 token, address to, uint256 value) internal {
411         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
412     }
413 
414     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
415         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
416     }
417 
418     /**
419      * @dev Deprecated. This function has issues similar to the ones found in
420      * {IERC20-approve}, and its usage is discouraged.
421      *
422      * Whenever possible, use {safeIncreaseAllowance} and
423      * {safeDecreaseAllowance} instead.
424      */
425     function safeApprove(IERC20 token, address spender, uint256 value) internal {
426         // safeApprove should only be called when setting an initial allowance,
427         // or when resetting it to zero. To increase and decrease it, use
428         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
429         // solhint-disable-next-line max-line-length
430         require((value == 0) || (token.allowance(address(this), spender) == 0),
431             "SafeERC20: approve from non-zero to non-zero allowance"
432         );
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
434     }
435 
436     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
437         uint256 newAllowance = token.allowance(address(this), spender).add(value);
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
439     }
440 
441     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
442         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
443         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
444     }
445 
446     /**
447      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
448      * on the return value: the return value is optional (but if data is returned, it must not be false).
449      * @param token The token targeted by the call.
450      * @param data The call data (encoded using abi.encode or one of its variants).
451      */
452     function _callOptionalReturn(IERC20 token, bytes memory data) private {
453         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
454         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
455         // the target address contains contract code and also asserts for success in the low-level call.
456 
457         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
458         if (returndata.length > 0) { // Return data is optional
459             // solhint-disable-next-line max-line-length
460             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
461         }
462     }
463 }
464 
465 
466 
467 /**
468  * @dev Contract module which provides a basic access control mechanism, where
469  * there is an account (an owner) that can be granted exclusive access to
470  * specific functions.
471  *
472  * By default, the owner account will be the one that deploys the contract. This
473  * can later be changed with {transferOwnership}.
474  *
475  * This module is used through inheritance. It will make available the modifier
476  * `onlyOwner`, which can be applied to your functions to restrict their use to
477  * the owner.
478  */
479 contract Ownable is Context {
480     address private _owner;
481 
482     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
483 
484     /**
485      * @dev Initializes the contract setting the deployer as the initial owner.
486      */
487     constructor () internal {
488         address msgSender = _msgSender();
489         _owner = msgSender;
490         emit OwnershipTransferred(address(0), msgSender);
491     }
492 
493     /**
494      * @dev Returns the address of the current owner.
495      */
496     function owner() public view returns (address) {
497         return _owner;
498     }
499 
500     /**
501      * @dev Throws if called by any account other than the owner.
502      */
503     modifier onlyOwner() {
504         require(_owner == _msgSender(), "Ownable: caller is not the owner");
505         _;
506     }
507 
508     /**
509      * @dev Leaves the contract without owner. It will not be possible to call
510      * `onlyOwner` functions anymore. Can only be called by the current owner.
511      *
512      * NOTE: Renouncing ownership will leave the contract without an owner,
513      * thereby removing any functionality that is only available to the owner.
514      */
515     function renounceOwnership() public virtual onlyOwner {
516         emit OwnershipTransferred(_owner, address(0));
517         _owner = address(0);
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Can only be called by the current owner.
523      */
524     function transferOwnership(address newOwner) public virtual onlyOwner {
525         require(newOwner != address(0), "Ownable: new owner is the zero address");
526         emit OwnershipTransferred(_owner, newOwner);
527         _owner = newOwner;
528     }
529 }
530 
531 
532 /**
533  * @dev Implementation of the {IERC20} interface.
534  *
535  * This implementation is agnostic to the way tokens are created. This means
536  * that a supply mechanism has to be added in a derived contract using {_mint}.
537  * For a generic mechanism see {ERC20PresetMinterPauser}.
538  *
539  * TIP: For a detailed writeup see our guide
540  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
541  * to implement supply mechanisms].
542  *
543  * We have followed general OpenZeppelin guidelines: functions revert instead
544  * of returning `false` on failure. This behavior is nonetheless conventional
545  * and does not conflict with the expectations of ERC20 applications.
546  *
547  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
548  * This allows applications to reconstruct the allowance for all accounts just
549  * by listening to said events. Other implementations of the EIP may not emit
550  * these events, as it isn't required by the specification.
551  *
552  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
553  * functions have been added to mitigate the well-known issues around setting
554  * allowances. See {IERC20-approve}.
555  */
556 contract ERC20 is Context, IERC20 {
557     using SafeMath for uint256;
558     using Address for address;
559 
560     mapping (address => uint256) private _balances;
561 
562     mapping (address => mapping (address => uint256)) private _allowances;
563 
564     uint256 private _totalSupply;
565 
566     string private _name;
567     string private _symbol;
568     uint8 private _decimals;
569 
570     /**
571      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
572      * a default value of 18.
573      *
574      * To select a different value for {decimals}, use {_setupDecimals}.
575      *
576      * All three of these values are immutable: they can only be set once during
577      * construction.
578      */
579     constructor (string memory name, string memory symbol) public {
580         _name = name;
581         _symbol = symbol;
582         _decimals = 18;
583     }
584 
585     /**
586      * @dev Returns the name of the token.
587      */
588     function name() public view returns (string memory) {
589         return _name;
590     }
591 
592     /**
593      * @dev Returns the symbol of the token, usually a shorter version of the
594      * name.
595      */
596     function symbol() public view returns (string memory) {
597         return _symbol;
598     }
599 
600     /**
601      * @dev Returns the number of decimals used to get its user representation.
602      * For example, if `decimals` equals `2`, a balance of `505` tokens should
603      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
604      *
605      * Tokens usually opt for a value of 18, imitating the relationship between
606      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
607      * called.
608      *
609      * NOTE: This information is only used for _display_ purposes: it in
610      * no way affects any of the arithmetic of the contract, including
611      * {IERC20-balanceOf} and {IERC20-transfer}.
612      */
613     function decimals() public view returns (uint8) {
614         return _decimals;
615     }
616 
617     /**
618      * @dev See {IERC20-totalSupply}.
619      */
620     function totalSupply() public view override returns (uint256) {
621         return _totalSupply;
622     }
623 
624     /**
625      * @dev See {IERC20-balanceOf}.
626      */
627     function balanceOf(address account) public view override returns (uint256) {
628         return _balances[account];
629     }
630 
631     /**
632      * @dev See {IERC20-transfer}.
633      *
634      * Requirements:
635      *
636      * - `recipient` cannot be the zero address.
637      * - the caller must have a balance of at least `amount`.
638      */
639     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
640         _transfer(_msgSender(), recipient, amount);
641         return true;
642     }
643 
644     /**
645      * @dev See {IERC20-allowance}.
646      */
647     function allowance(address owner, address spender) public view virtual override returns (uint256) {
648         return _allowances[owner][spender];
649     }
650 
651     /**
652      * @dev See {IERC20-approve}.
653      *
654      * Requirements:
655      *
656      * - `spender` cannot be the zero address.
657      */
658     function approve(address spender, uint256 amount) public virtual override returns (bool) {
659         _approve(_msgSender(), spender, amount);
660         return true;
661     }
662 
663     /**
664      * @dev See {IERC20-transferFrom}.
665      *
666      * Emits an {Approval} event indicating the updated allowance. This is not
667      * required by the EIP. See the note at the beginning of {ERC20};
668      *
669      * Requirements:
670      * - `sender` and `recipient` cannot be the zero address.
671      * - `sender` must have a balance of at least `amount`.
672      * - the caller must have allowance for ``sender``'s tokens of at least
673      * `amount`.
674      */
675     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
676         _transfer(sender, recipient, amount);
677         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
678         return true;
679     }
680 
681     /**
682      * @dev Atomically increases the allowance granted to `spender` by the caller.
683      *
684      * This is an alternative to {approve} that can be used as a mitigation for
685      * problems described in {IERC20-approve}.
686      *
687      * Emits an {Approval} event indicating the updated allowance.
688      *
689      * Requirements:
690      *
691      * - `spender` cannot be the zero address.
692      */
693     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
694         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
695         return true;
696     }
697 
698     /**
699      * @dev Atomically decreases the allowance granted to `spender` by the caller.
700      *
701      * This is an alternative to {approve} that can be used as a mitigation for
702      * problems described in {IERC20-approve}.
703      *
704      * Emits an {Approval} event indicating the updated allowance.
705      *
706      * Requirements:
707      *
708      * - `spender` cannot be the zero address.
709      * - `spender` must have allowance for the caller of at least
710      * `subtractedValue`.
711      */
712     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
713         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
714         return true;
715     }
716 
717     /**
718      * @dev Moves tokens `amount` from `sender` to `recipient`.
719      *
720      * This is internal function is equivalent to {transfer}, and can be used to
721      * e.g. implement automatic token fees, slashing mechanisms, etc.
722      *
723      * Emits a {Transfer} event.
724      *
725      * Requirements:
726      *
727      * - `sender` cannot be the zero address.
728      * - `recipient` cannot be the zero address.
729      * - `sender` must have a balance of at least `amount`.
730      */
731     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
732         require(sender != address(0), "ERC20: transfer from the zero address");
733         require(recipient != address(0), "ERC20: transfer to the zero address");
734 
735         _beforeTokenTransfer(sender, recipient, amount);
736 
737         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
738         _balances[recipient] = _balances[recipient].add(amount);
739         emit Transfer(sender, recipient, amount);
740     }
741 
742     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
743      * the total supply.
744      *
745      * Emits a {Transfer} event with `from` set to the zero address.
746      *
747      * Requirements
748      *
749      * - `to` cannot be the zero address.
750      */
751     function _mint(address account, uint256 amount) internal virtual {
752         require(account != address(0), "ERC20: mint to the zero address");
753 
754         _beforeTokenTransfer(address(0), account, amount);
755 
756         _totalSupply = _totalSupply.add(amount);
757         _balances[account] = _balances[account].add(amount);
758         emit Transfer(address(0), account, amount);
759     }
760 
761     /**
762      * @dev Destroys `amount` tokens from `account`, reducing the
763      * total supply.
764      *
765      * Emits a {Transfer} event with `to` set to the zero address.
766      *
767      * Requirements
768      *
769      * - `account` cannot be the zero address.
770      * - `account` must have at least `amount` tokens.
771      */
772     function _burn(address account, uint256 amount) internal virtual {
773         require(account != address(0), "ERC20: burn from the zero address");
774 
775         _beforeTokenTransfer(account, address(0), amount);
776 
777         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
778         _totalSupply = _totalSupply.sub(amount);
779         emit Transfer(account, address(0), amount);
780     }
781 
782     /**
783      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
784      *
785      * This is internal function is equivalent to `approve`, and can be used to
786      * e.g. set automatic allowances for certain subsystems, etc.
787      *
788      * Emits an {Approval} event.
789      *
790      * Requirements:
791      *
792      * - `owner` cannot be the zero address.
793      * - `spender` cannot be the zero address.
794      */
795     function _approve(address owner, address spender, uint256 amount) internal virtual {
796         require(owner != address(0), "ERC20: approve from the zero address");
797         require(spender != address(0), "ERC20: approve to the zero address");
798 
799         _allowances[owner][spender] = amount;
800         emit Approval(owner, spender, amount);
801     }
802 
803     /**
804      * @dev Sets {decimals} to a value other than the default one of 18.
805      *
806      * WARNING: This function should only be called from the constructor. Most
807      * applications that interact with token contracts will not expect
808      * {decimals} to ever change, and may work incorrectly if it does.
809      */
810     function _setupDecimals(uint8 decimals_) internal {
811         _decimals = decimals_;
812     }
813 
814     /**
815      * @dev Hook that is called before any transfer of tokens. This includes
816      * minting and burning.
817      *
818      * Calling conditions:
819      *
820      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
821      * will be to transferred to `to`.
822      * - when `from` is zero, `amount` tokens will be minted for `to`.
823      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
824      * - `from` and `to` are never both zero.
825      *
826      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
827      */
828     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
829 }
830 
831 // BanCOREToken with Governance.
832 contract BanCOREToken is ERC20("BANCORE.PRO", "BAN"), Ownable {
833     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
834     function mint(address _to, uint256 _amount) public onlyOwner {
835         _mint(_to, _amount);
836     }
837 }
838 
839 contract BanCOREFarming is Ownable {
840     using SafeMath for uint256;
841     using SafeERC20 for IERC20;
842 
843     // Info of each user.
844     struct UserInfo {
845         uint256 amount;     // How many LP tokens the user has provided.
846         uint256 rewardDebt; // Reward debt. See explanation below.
847         //
848         // We do some fancy math here. Basically, any point in time, the amount of BANs
849         // entitled to a user but is pending to be distributed is:
850         //
851         //   pending reward = (user.amount * pool.accBanPerShare) - user.rewardDebt
852         //
853         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
854         //   1. The pool's `accBanPerShare` (and `lastRewardBlock`) gets updated.
855         //   2. User receives the pending reward sent to his/her address.
856         //   3. User's `amount` gets updated.
857         //   4. User's `rewardDebt` gets updated.
858     }
859 
860     // Info of each pool.
861     struct PoolInfo {
862         IERC20 lpToken;           // Address of LP token contract.
863         uint256 allocPoint;       // How many allocation points assigned to this pool. BANs to distribute per block.
864         uint256 lastRewardBlock;  // Last block number that BANs distribution occurs.
865         uint256 accBanPerShare; // Accumulated BANs per share, times 1e12. See below.
866     }
867 
868     // The BAN TOKEN!
869     BanCOREToken public ban;
870     // Dev address.
871     address public devaddr;
872     // Block number when bonus BAN period ends.
873     uint256 public bonusEndBlock;
874     // BAN tokens created per block.
875     uint256 public banPerBlock;
876     // Bonus muliplier for early ban makers.
877     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
878 
879     // Info of each pool.
880     PoolInfo[] public poolInfo;
881     // Deposit fees for each pool
882     mapping(uint256 => uint256) public fees;
883     // Info of each user that stakes LP tokens.
884     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
885     // Total allocation poitns. Must be the sum of all allocation points in all pools.
886     uint256 public totalAllocPoint = 0;
887     // The block number when BAN mining starts.
888     uint256 public startBlock;
889 
890     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
891     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
892     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
893 
894     constructor(
895         BanCOREToken _ban,
896         address _devaddr,
897         uint256 _banPerBlock,
898         uint256 _startBlock,
899         uint256 _bonusEndBlock
900     ) public {
901         ban = _ban;
902         devaddr = _devaddr;
903         banPerBlock = _banPerBlock;
904         bonusEndBlock = _bonusEndBlock;
905         startBlock = _startBlock;
906     }
907 
908     function poolLength() external view returns (uint256) {
909         return poolInfo.length;
910     }
911 
912     //As a percentage multiplied by 1e18
913     function setDepositFee(uint256 _pid, uint256 _fee) external onlyOwner {
914         //Maximum fee of 5%
915         require(_fee > 0 && _fee <= 5e16);
916         fees[_pid] = _fee;
917     }
918 
919     // Add a new lp to the pool. Can only be called by the owner.
920     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
921     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
922         if (_withUpdate) {
923             massUpdatePools();
924         }
925         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
926         totalAllocPoint = totalAllocPoint.add(_allocPoint);
927         poolInfo.push(PoolInfo({
928             lpToken: _lpToken,
929             allocPoint: _allocPoint,
930             lastRewardBlock: lastRewardBlock,
931             accBanPerShare: 0
932         }));
933     }
934 
935     // Update the given pool's BAN allocation point. Can only be called by the owner.
936     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
937         if (_withUpdate) {
938             massUpdatePools();
939         }
940         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
941         poolInfo[_pid].allocPoint = _allocPoint;
942     }
943 
944 
945 
946     // Return reward multiplier over the given _from to _to block.
947     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
948         if (_to <= bonusEndBlock) {
949             return _to.sub(_from).mul(BONUS_MULTIPLIER);
950         } else if (_from >= bonusEndBlock) {
951             return _to.sub(_from);
952         } else {
953             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
954                 _to.sub(bonusEndBlock)
955             );
956         }
957     }
958 
959     // View function to see pending BANs on frontend.
960     function pendingBan(uint256 _pid, address _user) external view returns (uint256) {
961         PoolInfo storage pool = poolInfo[_pid];
962         UserInfo storage user = userInfo[_pid][_user];
963         uint256 accBanPerShare = pool.accBanPerShare;
964         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
965         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
966             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
967             uint256 banReward = multiplier.mul(banPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
968             accBanPerShare = accBanPerShare.add(banReward.mul(1e12).div(lpSupply));
969         }
970         return user.amount.mul(accBanPerShare).div(1e12).sub(user.rewardDebt);
971     }
972 
973     // Update reward vairables for all pools. Be careful of gas spending!
974     function massUpdatePools() public {
975         uint256 length = poolInfo.length;
976         for (uint256 pid = 0; pid < length; ++pid) {
977             updatePool(pid);
978         }
979     }
980     // Update reward variables of the given pool to be up-to-date.
981     function updatePool(uint256 _pid) public {
982         PoolInfo storage pool = poolInfo[_pid];
983         if (block.number <= pool.lastRewardBlock) {
984             return;
985         }
986         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
987         if (lpSupply == 0) {
988             pool.lastRewardBlock = block.number;
989             return;
990         }
991         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
992         uint256 banReward = multiplier.mul(banPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
993         ban.mint(devaddr, (banReward.mul(75)).div(1000)); // 7.5%
994         ban.mint(address(this), banReward);
995         pool.accBanPerShare = pool.accBanPerShare.add(banReward.mul(1e12).div(lpSupply));
996         pool.lastRewardBlock = block.number;
997     }
998 
999     // Deposit LP tokens to MasterChef for BAN allocation.
1000     function deposit(uint256 _pid, uint256 _amount) public {
1001         PoolInfo storage pool = poolInfo[_pid];
1002         UserInfo storage user = userInfo[_pid][msg.sender];
1003         updatePool(_pid);
1004         if (user.amount > 0) {
1005             uint256 pending = user.amount.mul(pool.accBanPerShare).div(1e12).sub(user.rewardDebt);
1006             safeBanTransfer(msg.sender, pending);
1007         }
1008         uint256 _fee = (_amount.mul(fees[_pid])).div(1e18);
1009         uint256 _amountMinusFees = _amount.sub(_fee);
1010         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1011         pool.lpToken.safeTransfer(address(devaddr), _fee);        
1012         user.amount = user.amount.add(_amountMinusFees);
1013         user.rewardDebt = user.amount.mul(pool.accBanPerShare).div(1e12);
1014         emit Deposit(msg.sender, _pid, _amountMinusFees);
1015     }
1016 
1017     // Withdraw LP tokens from MasterChef.
1018     function withdraw(uint256 _pid, uint256 _amount) public {
1019         PoolInfo storage pool = poolInfo[_pid];
1020         UserInfo storage user = userInfo[_pid][msg.sender];
1021         require(user.amount >= _amount, "withdraw: not good");
1022         updatePool(_pid);
1023         uint256 pending = user.amount.mul(pool.accBanPerShare).div(1e12).sub(user.rewardDebt);
1024         safeBanTransfer(msg.sender, pending);
1025         user.amount = user.amount.sub(_amount);
1026         user.rewardDebt = user.amount.mul(pool.accBanPerShare).div(1e12);
1027         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1028         emit Withdraw(msg.sender, _pid, _amount);
1029     }
1030 
1031     // Withdraw without caring about rewards. EMERGENCY ONLY.
1032     function emergencyWithdraw(uint256 _pid) public {
1033         PoolInfo storage pool = poolInfo[_pid];
1034         UserInfo storage user = userInfo[_pid][msg.sender];
1035         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1036         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1037         user.amount = 0;
1038         user.rewardDebt = 0;
1039     }
1040 
1041     // Safe ban transfer function, just in case if rounding error causes pool to not have enough BANs.
1042     function safeBanTransfer(address _to, uint256 _amount) internal {
1043         uint256 banBal = ban.balanceOf(address(this));
1044         if (_amount > banBal) {
1045             ban.transfer(_to, banBal);
1046         } else {
1047             ban.transfer(_to, _amount);
1048         }
1049     }
1050 
1051     // Update dev address by the previous dev.
1052     function dev(address _devaddr) public {
1053         require(msg.sender == devaddr, "dev: wut?");
1054         devaddr = _devaddr;
1055     }
1056 }