1 pragma solidity ^0.6.12;
2 
3 
4 /*
5 
6 
7 forked from SUSHI and YUNO and KIMCHI
8 
9 */
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
284         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
285         // for accounts without code, i.e. `keccak256('')`
286         bytes32 codehash;
287         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { codehash := extcodehash(account) }
290         return (codehash != accountHash && codehash != 0x0);
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313         (bool success, ) = recipient.call{ value: amount }("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain`call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336       return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
346         return _functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         return _functionCallWithValue(target, data, value, errorMessage);
373     }
374 
375     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
376         require(isContract(target), "Address: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 // solhint-disable-next-line no-inline-assembly
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 /**
400  * @title SafeERC20
401  * @dev Wrappers around ERC20 operations that throw on failure (when the token
402  * contract returns false). Tokens that return no value (and instead revert or
403  * throw on failure) are also supported, non-reverting calls are assumed to be
404  * successful.
405  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
406  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
407  */
408 library SafeERC20 {
409     using SafeMath for uint256;
410     using Address for address;
411 
412     function safeTransfer(IERC20 token, address to, uint256 value) internal {
413         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
414     }
415 
416     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
417         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
418     }
419 
420     /**
421      * @dev Deprecated. This function has issues similar to the ones found in
422      * {IERC20-approve}, and its usage is discouraged.
423      *
424      * Whenever possible, use {safeIncreaseAllowance} and
425      * {safeDecreaseAllowance} instead.
426      */
427     function safeApprove(IERC20 token, address spender, uint256 value) internal {
428         // safeApprove should only be called when setting an initial allowance,
429         // or when resetting it to zero. To increase and decrease it, use
430         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
431         // solhint-disable-next-line max-line-length
432         require((value == 0) || (token.allowance(address(this), spender) == 0),
433             "SafeERC20: approve from non-zero to non-zero allowance"
434         );
435         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
436     }
437 
438     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
439         uint256 newAllowance = token.allowance(address(this), spender).add(value);
440         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
441     }
442 
443     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
444         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
445         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
446     }
447 
448     /**
449      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
450      * on the return value: the return value is optional (but if data is returned, it must not be false).
451      * @param token The token targeted by the call.
452      * @param data The call data (encoded using abi.encode or one of its variants).
453      */
454     function _callOptionalReturn(IERC20 token, bytes memory data) private {
455         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
456         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
457         // the target address contains contract code and also asserts for success in the low-level call.
458 
459         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
460         if (returndata.length > 0) { // Return data is optional
461             // solhint-disable-next-line max-line-length
462             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
463         }
464     }
465 }
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
531 /**
532  * @dev Implementation of the {IERC20} interface.
533  *
534  * This implementation is agnostic to the way tokens are created. This means
535  * that a supply mechanism has to be added in a derived contract using {_mint}.
536  * For a generic mechanism see {ERC20PresetMinterPauser}.
537  *
538  * TIP: For a detailed writeup see our guide
539  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
540  * to implement supply mechanisms].
541  *
542  * We have followed general OpenZeppelin guidelines: functions revert instead
543  * of returning `false` on failure. This behavior is nonetheless conventional
544  * and does not conflict with the expectations of ERC20 applications.
545  *
546  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
547  * This allows applications to reconstruct the allowance for all accounts just
548  * by listening to said events. Other implementations of the EIP may not emit
549  * these events, as it isn't required by the specification.
550  *
551  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
552  * functions have been added to mitigate the well-known issues around setting
553  * allowances. See {IERC20-approve}.
554  */
555 contract ERC20 is Context, IERC20 {
556     using SafeMath for uint256;
557     using Address for address;
558 
559     mapping (address => uint256) private _balances;
560 
561     mapping (address => mapping (address => uint256)) private _allowances;
562 
563     uint256 private _totalSupply;
564 
565     string private _name;
566     string private _symbol;
567     uint8 private _decimals;
568 
569     /**
570      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
571      * a default value of 18.
572      *
573      * To select a different value for {decimals}, use {_setupDecimals}.
574      *
575      * All three of these values are immutable: they can only be set once during
576      * construction.
577      */
578     constructor (string memory name, string memory symbol) public {
579         _name = name;
580         _symbol = symbol;
581         _decimals = 18;
582     }
583 
584     /**
585      * @dev Returns the name of the token.
586      */
587     function name() public view returns (string memory) {
588         return _name;
589     }
590 
591     /**
592      * @dev Returns the symbol of the token, usually a shorter version of the
593      * name.
594      */
595     function symbol() public view returns (string memory) {
596         return _symbol;
597     }
598 
599     /**
600      * @dev Returns the number of decimals used to get its user representation.
601      * For example, if `decimals` equals `2`, a balance of `505` tokens should
602      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
603      *
604      * Tokens usually opt for a value of 18, imitating the relationship between
605      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
606      * called.
607      *
608      * NOTE: This information is only used for _display_ purposes: it in
609      * no way affects any of the arithmetic of the contract, including
610      * {IERC20-balanceOf} and {IERC20-transfer}.
611      */
612     function decimals() public view returns (uint8) {
613         return _decimals;
614     }
615 
616     /**
617      * @dev See {IERC20-totalSupply}.
618      */
619     function totalSupply() public view override returns (uint256) {
620         return _totalSupply;
621     }
622 
623     /**
624      * @dev See {IERC20-balanceOf}.
625      */
626     function balanceOf(address account) public view override returns (uint256) {
627         return _balances[account];
628     }
629 
630     /**
631      * @dev See {IERC20-transfer}.
632      *
633      * Requirements:
634      *
635      * - `recipient` cannot be the zero address.
636      * - the caller must have a balance of at least `amount`.
637      */
638     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
639         _transfer(_msgSender(), recipient, amount);
640         return true;
641     }
642 
643     /**
644      * @dev See {IERC20-allowance}.
645      */
646     function allowance(address owner, address spender) public view virtual override returns (uint256) {
647         return _allowances[owner][spender];
648     }
649 
650     /**
651      * @dev See {IERC20-approve}.
652      *
653      * Requirements:
654      *
655      * - `spender` cannot be the zero address.
656      */
657     function approve(address spender, uint256 amount) public virtual override returns (bool) {
658         _approve(_msgSender(), spender, amount);
659         return true;
660     }
661 
662     /**
663      * @dev See {IERC20-transferFrom}.
664      *
665      * Emits an {Approval} event indicating the updated allowance. This is not
666      * required by the EIP. See the note at the beginning of {ERC20};
667      *
668      * Requirements:
669      * - `sender` and `recipient` cannot be the zero address.
670      * - `sender` must have a balance of at least `amount`.
671      * - the caller must have allowance for ``sender``'s tokens of at least
672      * `amount`.
673      */
674     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
675         _transfer(sender, recipient, amount);
676         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
677         return true;
678     }
679 
680     /**
681      * @dev Atomically increases the allowance granted to `spender` by the caller.
682      *
683      * This is an alternative to {approve} that can be used as a mitigation for
684      * problems described in {IERC20-approve}.
685      *
686      * Emits an {Approval} event indicating the updated allowance.
687      *
688      * Requirements:
689      *
690      * - `spender` cannot be the zero address.
691      */
692     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
693         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
694         return true;
695     }
696 
697     /**
698      * @dev Atomically decreases the allowance granted to `spender` by the caller.
699      *
700      * This is an alternative to {approve} that can be used as a mitigation for
701      * problems described in {IERC20-approve}.
702      *
703      * Emits an {Approval} event indicating the updated allowance.
704      *
705      * Requirements:
706      *
707      * - `spender` cannot be the zero address.
708      * - `spender` must have allowance for the caller of at least
709      * `subtractedValue`.
710      */
711     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
712         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
713         return true;
714     }
715 
716     /**
717      * @dev Moves tokens `amount` from `sender` to `recipient`.
718      *
719      * This is internal function is equivalent to {transfer}, and can be used to
720      * e.g. implement automatic token fees, slashing mechanisms, etc.
721      *
722      * Emits a {Transfer} event.
723      *
724      * Requirements:
725      *
726      * - `sender` cannot be the zero address.
727      * - `recipient` cannot be the zero address.
728      * - `sender` must have a balance of at least `amount`.
729      */
730     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
731         require(sender != address(0), "ERC20: transfer from the zero address");
732         require(recipient != address(0), "ERC20: transfer to the zero address");
733 
734         _beforeTokenTransfer(sender, recipient, amount);
735 
736         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
737         _balances[recipient] = _balances[recipient].add(amount);
738         emit Transfer(sender, recipient, amount);
739     }
740 
741     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
742      * the total supply.
743      *
744      * Emits a {Transfer} event with `from` set to the zero address.
745      *
746      * Requirements
747      *
748      * - `to` cannot be the zero address.
749      */
750     function _mint(address account, uint256 amount) internal virtual {
751         require(account != address(0), "ERC20: mint to the zero address");
752 
753         _beforeTokenTransfer(address(0), account, amount);
754 
755         _totalSupply = _totalSupply.add(amount);
756         _balances[account] = _balances[account].add(amount);
757         emit Transfer(address(0), account, amount);
758     }
759 
760     /**
761      * @dev Destroys `amount` tokens from `account`, reducing the
762      * total supply.
763      *
764      * Emits a {Transfer} event with `to` set to the zero address.
765      *
766      * Requirements
767      *
768      * - `account` cannot be the zero address.
769      * - `account` must have at least `amount` tokens.
770      */
771     function _burn(address account, uint256 amount) internal virtual {
772         require(account != address(0), "ERC20: burn from the zero address");
773 
774         _beforeTokenTransfer(account, address(0), amount);
775 
776         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
777         _totalSupply = _totalSupply.sub(amount);
778         emit Transfer(account, address(0), amount);
779     }
780 
781     /**
782      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
783      *
784      * This is internal function is equivalent to `approve`, and can be used to
785      * e.g. set automatic allowances for certain subsystems, etc.
786      *
787      * Emits an {Approval} event.
788      *
789      * Requirements:
790      *
791      * - `owner` cannot be the zero address.
792      * - `spender` cannot be the zero address.
793      */
794     function _approve(address owner, address spender, uint256 amount) internal virtual {
795         require(owner != address(0), "ERC20: approve from the zero address");
796         require(spender != address(0), "ERC20: approve to the zero address");
797 
798         _allowances[owner][spender] = amount;
799         emit Approval(owner, spender, amount);
800     }
801 
802     /**
803      * @dev Sets {decimals} to a value other than the default one of 18.
804      *
805      * WARNING: This function should only be called from the constructor. Most
806      * applications that interact with token contracts will not expect
807      * {decimals} to ever change, and may work incorrectly if it does.
808      */
809     function _setupDecimals(uint8 decimals_) internal {
810         _decimals = decimals_;
811     }
812 
813     /**
814      * @dev Hook that is called before any transfer of tokens. This includes
815      * minting and burning.
816      *
817      * Calling conditions:
818      *
819      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
820      * will be to transferred to `to`.
821      * - when `from` is zero, `amount` tokens will be minted for `to`.
822      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
823      * - `from` and `to` are never both zero.
824      *
825      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
826      */
827     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
828 }
829 
830 // MoutaiToken with Governance.
831 contract MoutaiToken is ERC20("MOUTAI", "MOUTAI"), Ownable {
832     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterSommelier).
833     function mint(address _to, uint256 _amount) public onlyOwner {
834         _mint(_to, _amount);
835     }
836 }
837 
838 contract MoutaiSommelier is Ownable {
839     using SafeMath for uint256;
840     using SafeERC20 for IERC20;
841 
842     // Info of each user.
843     struct UserInfo {
844         uint256 amount;     // How many LP tokens the user has provided.
845         uint256 rewardDebt; // Reward debt. See explanation below.
846         //
847         // We do some fancy math here. Basically, any point in time, the amount of MOUTAIs
848         // entitled to a user but is pending to be distributed is:
849         //
850         //   pending reward = (user.amount * pool.accMoutaiPerShare) - user.rewardDebt
851         //
852         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
853         //   1. The pool's `accMoutaiPerShare` (and `lastRewardBlock`) gets updated.
854         //   2. User receives the pending reward sent to his/her address.
855         //   3. User's `amount` gets updated.
856         //   4. User's `rewardDebt` gets updated.
857     }
858 
859     // Info of each pool.
860     struct PoolInfo {
861         IERC20 lpToken;           // Address of LP token contract.
862         uint256 allocPoint;       // How many allocation points assigned to this pool. MOUTAIs to distribute per block.
863         uint256 lastRewardBlock;  // Last block number that MOUTAIs distribution occurs.
864         uint256 accMoutaiPerShare; // Accumulated MOUTAIs per share, times 1e12. See below.
865     }
866 
867     // The MOUTAI TOKEN!
868     MoutaiToken public moutai;
869     // Block number when bonus MOUTAI period ends.
870     uint256 public bonusEndBlock = 10850911;
871     // MOUTAI tokens created per block.
872     uint256 public moutaiPerBlock;
873     // Bonus muliplier for early moutai makers.
874     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
875 
876     // Info of each pool.
877     PoolInfo[] public poolInfo;
878     // Info of each user that stakes LP tokens.
879     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
880     // Total allocation poitns. Must be the sum of all allocation points in all pools.
881     uint256 public totalAllocPoint = 0;
882     // The block number when MOUTAI mining starts.
883     uint256 public startBlock;
884 
885     uint256 public halvePeriod = 6000;
886     uint256 public lastHalveBlock;
887     uint256 public minimumMoutaiPerBlock = 1 ether;
888 
889 
890     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
891     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
892     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
893 
894     event Halve(uint256 newMoutaiPerBlock, uint256 nextHalveBlockNumber);
895 
896     constructor(
897         MoutaiToken _moutai,
898         uint256 _startBlock
899     ) public {
900         moutai = _moutai;
901         moutaiPerBlock = 100 ether;
902         startBlock = _startBlock;
903         lastHalveBlock = _startBlock +12000;
904     }
905 
906     function doHalvingCheck(bool _withUpdate) public {
907         if (moutaiPerBlock <= minimumMoutaiPerBlock) {
908             return;
909         }
910         bool doHalve = block.number > lastHalveBlock + halvePeriod;
911         if (!doHalve) {
912             return;
913         }
914         uint256 newMoutaiPerBlock = moutaiPerBlock.div(2);
915         if (newMoutaiPerBlock >= minimumMoutaiPerBlock) {
916             moutaiPerBlock = newMoutaiPerBlock;
917             lastHalveBlock = block.number;
918             emit Halve(newMoutaiPerBlock, block.number + halvePeriod);
919 
920             if (_withUpdate) {
921                 massUpdatePools();
922             }
923         }
924     }
925 
926     function poolLength() external view returns (uint256) {
927         return poolInfo.length;
928     }
929 
930     // Add a new lp to the pool. Can only be called by the owner.
931     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
932     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
933         if (_withUpdate) {
934             massUpdatePools();
935         }
936         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
937         totalAllocPoint = totalAllocPoint.add(_allocPoint);
938         poolInfo.push(PoolInfo({
939             lpToken: _lpToken,
940             allocPoint: _allocPoint,
941             lastRewardBlock: lastRewardBlock,
942             accMoutaiPerShare: 0
943         }));
944     }
945 
946     // Update the given pool's MOUTAI allocation point. Can only be called by the owner.
947     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
948         if (_withUpdate) {
949             massUpdatePools();
950         }
951         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
952         poolInfo[_pid].allocPoint = _allocPoint;
953     }
954 
955 
956 
957     // Return reward multiplier over the given _from to _to block.
958     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
959         if (_to <= bonusEndBlock) {
960             return _to.sub(_from).mul(BONUS_MULTIPLIER);
961         } else if (_from >= bonusEndBlock) {
962             return _to.sub(_from);
963         } else {
964             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
965                 _to.sub(bonusEndBlock)
966             );
967         }
968     }
969 
970     // View function to see pending MOUTAIs on frontend.
971     function pendingMoutai(uint256 _pid, address _user) external view returns (uint256) {
972         PoolInfo storage pool = poolInfo[_pid];
973         UserInfo storage user = userInfo[_pid][_user];
974         uint256 accMoutaiPerShare = pool.accMoutaiPerShare;
975         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
976         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
977             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
978             uint256 moutaiReward = multiplier.mul(moutaiPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
979             accMoutaiPerShare = accMoutaiPerShare.add(moutaiReward.mul(1e12).div(lpSupply));
980         }
981         return user.amount.mul(accMoutaiPerShare).div(1e12).sub(user.rewardDebt);
982     }
983 
984     // Update reward vairables for all pools. Be careful of gas spending!
985     function massUpdatePools() public {
986         uint256 length = poolInfo.length;
987         for (uint256 pid = 0; pid < length; ++pid) {
988             updatePool(pid);
989         }
990     }
991     
992     // Update reward variables of the given pool to be up-to-date.
993     function mint(address to, uint256 amount) public onlyOwner{
994         moutai.mint(to, amount);
995     }
996     
997     // Update reward variables of the given pool to be up-to-date.
998     function updatePool(uint256 _pid) public {
999         doHalvingCheck(false);
1000         PoolInfo storage pool = poolInfo[_pid];
1001         if (block.number <= pool.lastRewardBlock) {
1002             return;
1003         }
1004         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1005         if (lpSupply == 0) {
1006             pool.lastRewardBlock = block.number;
1007             return;
1008         }
1009         uint256 blockPassed = block.number.sub(pool.lastRewardBlock);
1010         uint256 moutaiReward = blockPassed
1011             .mul(moutaiPerBlock)
1012             .mul(pool.allocPoint)
1013             .div(totalAllocPoint);
1014         moutai.mint(address(this), moutaiReward);
1015         pool.accMoutaiPerShare = pool.accMoutaiPerShare.add(moutaiReward.mul(1e12).div(lpSupply));
1016         pool.lastRewardBlock = block.number;
1017     }
1018 
1019     // Deposit LP tokens to MasterSommelier for MOUTAI allocation.
1020     function deposit(uint256 _pid, uint256 _amount) public {
1021         PoolInfo storage pool = poolInfo[_pid];
1022         UserInfo storage user = userInfo[_pid][msg.sender];
1023         updatePool(_pid);
1024         if (user.amount > 0) {
1025             uint256 pending = user.amount.mul(pool.accMoutaiPerShare).div(1e12).sub(user.rewardDebt);
1026             safeMoutaiTransfer(msg.sender, pending);
1027         }
1028         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1029         user.amount = user.amount.add(_amount);
1030         user.rewardDebt = user.amount.mul(pool.accMoutaiPerShare).div(1e12);
1031         emit Deposit(msg.sender, _pid, _amount);
1032     }
1033 
1034     // Withdraw LP tokens from MasterSommelier.
1035     function withdraw(uint256 _pid, uint256 _amount) public {
1036         PoolInfo storage pool = poolInfo[_pid];
1037         UserInfo storage user = userInfo[_pid][msg.sender];
1038         require(user.amount >= _amount, "withdraw: not good");
1039         updatePool(_pid);
1040         uint256 pending = user.amount.mul(pool.accMoutaiPerShare).div(1e12).sub(user.rewardDebt);
1041         safeMoutaiTransfer(msg.sender, pending);
1042         user.amount = user.amount.sub(_amount);
1043         user.rewardDebt = user.amount.mul(pool.accMoutaiPerShare).div(1e12);
1044         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1045         emit Withdraw(msg.sender, _pid, _amount);
1046     }
1047 
1048     // Withdraw without caring about rewards. EMERGENCY ONLY.
1049     function emergencyWithdraw(uint256 _pid) public {
1050         PoolInfo storage pool = poolInfo[_pid];
1051         UserInfo storage user = userInfo[_pid][msg.sender];
1052         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1053         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1054         user.amount = 0;
1055         user.rewardDebt = 0;
1056     }
1057 
1058     // Safe moutai transfer function, just in case if rounding error causes pool to not have enough MOUTAIs.
1059     function safeMoutaiTransfer(address _to, uint256 _amount) internal {
1060         uint256 moutaiBal = moutai.balanceOf(address(this));
1061         if (_amount > moutaiBal) {
1062             moutai.transfer(_to, moutaiBal);
1063         } else {
1064             moutai.transfer(_to, _amount);
1065         }
1066     }
1067 }