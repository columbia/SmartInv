1 /*
2 
3 website: takeout.finance
4 forked from KIMCHI, SUSHI and YUNO
5 
6 */
7 
8 pragma solidity ^0.6.12;
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
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
467 
468 
469 /**
470  * @dev Contract module which provides a basic access control mechanism, where
471  * there is an account (an owner) that can be granted exclusive access to
472  * specific functions.
473  *
474  * By default, the owner account will be the one that deploys the contract. This
475  * can later be changed with {transferOwnership}.
476  *
477  * This module is used through inheritance. It will make available the modifier
478  * `onlyOwner`, which can be applied to your functions to restrict their use to
479  * the owner.
480  */
481 contract Ownable is Context {
482     address private _owner;
483 
484     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
485 
486     /**
487      * @dev Initializes the contract setting the deployer as the initial owner.
488      */
489     constructor () internal {
490         address msgSender = _msgSender();
491         _owner = msgSender;
492         emit OwnershipTransferred(address(0), msgSender);
493     }
494 
495     /**
496      * @dev Returns the address of the current owner.
497      */
498     function owner() public view returns (address) {
499         return _owner;
500     }
501 
502     /**
503      * @dev Throws if called by any account other than the owner.
504      */
505     modifier onlyOwner() {
506         require(_owner == _msgSender(), "Ownable: caller is not the owner");
507         _;
508     }
509 
510     /**
511      * @dev Leaves the contract without owner. It will not be possible to call
512      * `onlyOwner` functions anymore. Can only be called by the current owner.
513      *
514      * NOTE: Renouncing ownership will leave the contract without an owner,
515      * thereby removing any functionality that is only available to the owner.
516      */
517     function renounceOwnership() public virtual onlyOwner {
518         emit OwnershipTransferred(_owner, address(0));
519         _owner = address(0);
520     }
521 
522     /**
523      * @dev Transfers ownership of the contract to a new account (`newOwner`).
524      * Can only be called by the current owner.
525      */
526     function transferOwnership(address newOwner) public virtual onlyOwner {
527         require(newOwner != address(0), "Ownable: new owner is the zero address");
528         emit OwnershipTransferred(_owner, newOwner);
529         _owner = newOwner;
530     }
531 }
532 
533 
534 /**
535  * @dev Implementation of the {IERC20} interface.
536  *
537  * This implementation is agnostic to the way tokens are created. This means
538  * that a supply mechanism has to be added in a derived contract using {_mint}.
539  * For a generic mechanism see {ERC20PresetMinterPauser}.
540  *
541  * TIP: For a detailed writeup see our guide
542  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
543  * to implement supply mechanisms].
544  *
545  * We have followed general OpenZeppelin guidelines: functions revert instead
546  * of returning `false` on failure. This behavior is nonetheless conventional
547  * and does not conflict with the expectations of ERC20 applications.
548  *
549  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
550  * This allows applications to reconstruct the allowance for all accounts just
551  * by listening to said events. Other implementations of the EIP may not emit
552  * these events, as it isn't required by the specification.
553  *
554  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
555  * functions have been added to mitigate the well-known issues around setting
556  * allowances. See {IERC20-approve}.
557  */
558 contract ERC20 is Context, IERC20 {
559     using SafeMath for uint256;
560     using Address for address;
561 
562     mapping (address => uint256) private _balances;
563 
564     mapping (address => mapping (address => uint256)) private _allowances;
565 
566     uint256 private _totalSupply;
567 
568     string private _name;
569     string private _symbol;
570     uint8 private _decimals;
571 
572     /**
573      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
574      * a default value of 18.
575      *
576      * To select a different value for {decimals}, use {_setupDecimals}.
577      *
578      * All three of these values are immutable: they can only be set once during
579      * construction.
580      */
581     constructor (string memory name, string memory symbol) public {
582         _name = name;
583         _symbol = symbol;
584         _decimals = 18;
585     }
586 
587     /**
588      * @dev Returns the name of the token.
589      */
590     function name() public view returns (string memory) {
591         return _name;
592     }
593 
594     /**
595      * @dev Returns the symbol of the token, usually a shorter version of the
596      * name.
597      */
598     function symbol() public view returns (string memory) {
599         return _symbol;
600     }
601 
602     /**
603      * @dev Returns the number of decimals used to get its user representation.
604      * For example, if `decimals` equals `2`, a balance of `505` tokens should
605      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
606      *
607      * Tokens usually opt for a value of 18, imitating the relationship between
608      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
609      * called.
610      *
611      * NOTE: This information is only used for _display_ purposes: it in
612      * no way affects any of the arithmetic of the contract, including
613      * {IERC20-balanceOf} and {IERC20-transfer}.
614      */
615     function decimals() public view returns (uint8) {
616         return _decimals;
617     }
618 
619     /**
620      * @dev See {IERC20-totalSupply}.
621      */
622     function totalSupply() public view override returns (uint256) {
623         return _totalSupply;
624     }
625 
626     /**
627      * @dev See {IERC20-balanceOf}.
628      */
629     function balanceOf(address account) public view override returns (uint256) {
630         return _balances[account];
631     }
632 
633     /**
634      * @dev See {IERC20-transfer}.
635      *
636      * Requirements:
637      *
638      * - `recipient` cannot be the zero address.
639      * - the caller must have a balance of at least `amount`.
640      */
641     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
642         _transfer(_msgSender(), recipient, amount);
643         return true;
644     }
645 
646     /**
647      * @dev See {IERC20-allowance}.
648      */
649     function allowance(address owner, address spender) public view virtual override returns (uint256) {
650         return _allowances[owner][spender];
651     }
652 
653     /**
654      * @dev See {IERC20-approve}.
655      *
656      * Requirements:
657      *
658      * - `spender` cannot be the zero address.
659      */
660     function approve(address spender, uint256 amount) public virtual override returns (bool) {
661         _approve(_msgSender(), spender, amount);
662         return true;
663     }
664 
665     /**
666      * @dev See {IERC20-transferFrom}.
667      *
668      * Emits an {Approval} event indicating the updated allowance. This is not
669      * required by the EIP. See the note at the beginning of {ERC20};
670      *
671      * Requirements:
672      * - `sender` and `recipient` cannot be the zero address.
673      * - `sender` must have a balance of at least `amount`.
674      * - the caller must have allowance for ``sender``'s tokens of at least
675      * `amount`.
676      */
677     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
678         _transfer(sender, recipient, amount);
679         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
680         return true;
681     }
682 
683     /**
684      * @dev Atomically increases the allowance granted to `spender` by the caller.
685      *
686      * This is an alternative to {approve} that can be used as a mitigation for
687      * problems described in {IERC20-approve}.
688      *
689      * Emits an {Approval} event indicating the updated allowance.
690      *
691      * Requirements:
692      *
693      * - `spender` cannot be the zero address.
694      */
695     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
696         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
697         return true;
698     }
699 
700     /**
701      * @dev Atomically decreases the allowance granted to `spender` by the caller.
702      *
703      * This is an alternative to {approve} that can be used as a mitigation for
704      * problems described in {IERC20-approve}.
705      *
706      * Emits an {Approval} event indicating the updated allowance.
707      *
708      * Requirements:
709      *
710      * - `spender` cannot be the zero address.
711      * - `spender` must have allowance for the caller of at least
712      * `subtractedValue`.
713      */
714     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
715         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
716         return true;
717     }
718 
719     /**
720      * @dev Moves tokens `amount` from `sender` to `recipient`.
721      *
722      * This is internal function is equivalent to {transfer}, and can be used to
723      * e.g. implement automatic token fees, slashing mechanisms, etc.
724      *
725      * Emits a {Transfer} event.
726      *
727      * Requirements:
728      *
729      * - `sender` cannot be the zero address.
730      * - `recipient` cannot be the zero address.
731      * - `sender` must have a balance of at least `amount`.
732      */
733     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
734         require(sender != address(0), "ERC20: transfer from the zero address");
735         require(recipient != address(0), "ERC20: transfer to the zero address");
736 
737         _beforeTokenTransfer(sender, recipient, amount);
738 
739         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
740         _balances[recipient] = _balances[recipient].add(amount);
741         emit Transfer(sender, recipient, amount);
742     }
743 
744     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
745      * the total supply.
746      *
747      * Emits a {Transfer} event with `from` set to the zero address.
748      *
749      * Requirements
750      *
751      * - `to` cannot be the zero address.
752      */
753     function _mint(address account, uint256 amount) internal virtual {
754         require(account != address(0), "ERC20: mint to the zero address");
755 
756         _beforeTokenTransfer(address(0), account, amount);
757 
758         _totalSupply = _totalSupply.add(amount);
759         _balances[account] = _balances[account].add(amount);
760         emit Transfer(address(0), account, amount);
761     }
762 
763     /**
764      * @dev Destroys `amount` tokens from `account`, reducing the
765      * total supply.
766      *
767      * Emits a {Transfer} event with `to` set to the zero address.
768      *
769      * Requirements
770      *
771      * - `account` cannot be the zero address.
772      * - `account` must have at least `amount` tokens.
773      */
774     function _burn(address account, uint256 amount) internal virtual {
775         require(account != address(0), "ERC20: burn from the zero address");
776 
777         _beforeTokenTransfer(account, address(0), amount);
778 
779         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
780         _totalSupply = _totalSupply.sub(amount);
781         emit Transfer(account, address(0), amount);
782     }
783 
784     /**
785      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
786      *
787      * This is internal function is equivalent to `approve`, and can be used to
788      * e.g. set automatic allowances for certain subsystems, etc.
789      *
790      * Emits an {Approval} event.
791      *
792      * Requirements:
793      *
794      * - `owner` cannot be the zero address.
795      * - `spender` cannot be the zero address.
796      */
797     function _approve(address owner, address spender, uint256 amount) internal virtual {
798         require(owner != address(0), "ERC20: approve from the zero address");
799         require(spender != address(0), "ERC20: approve to the zero address");
800 
801         _allowances[owner][spender] = amount;
802         emit Approval(owner, spender, amount);
803     }
804 
805     /**
806      * @dev Sets {decimals} to a value other than the default one of 18.
807      *
808      * WARNING: This function should only be called from the constructor. Most
809      * applications that interact with token contracts will not expect
810      * {decimals} to ever change, and may work incorrectly if it does.
811      */
812     function _setupDecimals(uint8 decimals_) internal {
813         _decimals = decimals_;
814     }
815 
816     /**
817      * @dev Hook that is called before any transfer of tokens. This includes
818      * minting and burning.
819      *
820      * Calling conditions:
821      *
822      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
823      * will be to transferred to `to`.
824      * - when `from` is zero, `amount` tokens will be minted for `to`.
825      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
826      * - `from` and `to` are never both zero.
827      *
828      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
829      */
830     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
831 }
832 
833 // TakeoutToken with Governance.
834 contract TakeoutToken is ERC20("TAKEOUT.finance", "TAKE"), Ownable {
835     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
836     function mint(address _to, uint256 _amount) public onlyOwner {
837         _mint(_to, _amount);
838     }
839 }