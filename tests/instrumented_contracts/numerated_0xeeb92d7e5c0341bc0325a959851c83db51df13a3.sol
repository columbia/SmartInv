1 /*
2 
3 website: burger.money
4 
5 
6 
7 '########::'##::::'##:'########:::'######:::'########:'########::
8  ##.... ##: ##:::: ##: ##.... ##:'##... ##:: ##.....:: ##.... ##:
9  ##:::: ##: ##:::: ##: ##:::: ##: ##:::..::: ##::::::: ##:::: ##:
10  ########:: ##:::: ##: ########:: ##::'####: ######::: ########::
11  ##.... ##: ##:::: ##: ##.. ##::: ##::: ##:: ##...:::: ##.. ##:::
12  ##:::: ##: ##:::: ##: ##::. ##:: ##::: ##:: ##::::::: ##::. ##::
13  ########::. #######:: ##:::. ##:. ######::: ########: ##:::. ##:
14 ........::::.......:::..:::::..:::......::::........::..:::::..::                                                    
15                                                          
16                                                          
17 
18 forked from SUSHI and YUNO
19 
20 */
21 
22 pragma solidity ^0.6.12;
23 /*
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with GSN meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address payable) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes memory) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 /**
45  * @dev Interface of the ERC20 standard as defined in the EIP.
46  */
47 interface IERC20 {
48     /**
49      * @dev Returns the amount of tokens in existence.
50      */
51     function totalSupply() external view returns (uint256);
52 
53     /**
54      * @dev Returns the amount of tokens owned by `account`.
55      */
56     function balanceOf(address account) external view returns (uint256);
57 
58     /**
59      * @dev Moves `amount` tokens from the caller's account to `recipient`.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transfer(address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Returns the remaining number of tokens that `spender` will be
69      * allowed to spend on behalf of `owner` through {transferFrom}. This is
70      * zero by default.
71      *
72      * This value changes when {approve} or {transferFrom} are called.
73      */
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     /**
77      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * IMPORTANT: Beware that changing an allowance with this method brings the risk
82      * that someone may use both the old and the new allowance by unfortunate
83      * transaction ordering. One possible solution to mitigate this race
84      * condition is to first reduce the spender's allowance to 0 and set the
85      * desired value afterwards:
86      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
87      *
88      * Emits an {Approval} event.
89      */
90     function approve(address spender, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Moves `amount` tokens from `sender` to `recipient` using the
94      * allowance mechanism. `amount` is then deducted from the caller's
95      * allowance.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Emitted when `value` tokens are moved from one account (`from`) to
105      * another (`to`).
106      *
107      * Note that `value` may be zero.
108      */
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     /**
112      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
113      * a call to {approve}. `value` is the new allowance.
114      */
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
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
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return div(a, b, "SafeMath: division by zero");
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b > 0, errorMessage);
234         uint256 c = a / b;
235         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253         return mod(a, b, "SafeMath: modulo by zero");
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * Reverts with custom message when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 }
273 
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
298         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
299         // for accounts without code, i.e. `keccak256('')`
300         bytes32 codehash;
301         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { codehash := extcodehash(account) }
304         return (codehash != accountHash && codehash != 0x0);
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{ value: amount }("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain`call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350       return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
360         return _functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         return _functionCallWithValue(target, data, value, errorMessage);
387     }
388 
389     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
390         require(isContract(target), "Address: call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 // solhint-disable-next-line no-inline-assembly
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 /**
414  * @title SafeERC20
415  * @dev Wrappers around ERC20 operations that throw on failure (when the token
416  * contract returns false). Tokens that return no value (and instead revert or
417  * throw on failure) are also supported, non-reverting calls are assumed to be
418  * successful.
419  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
420  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
421  */
422 library SafeERC20 {
423     using SafeMath for uint256;
424     using Address for address;
425 
426     function safeTransfer(IERC20 token, address to, uint256 value) internal {
427         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
428     }
429 
430     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
431         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
432     }
433 
434     /**
435      * @dev Deprecated. This function has issues similar to the ones found in
436      * {IERC20-approve}, and its usage is discouraged.
437      *
438      * Whenever possible, use {safeIncreaseAllowance} and
439      * {safeDecreaseAllowance} instead.
440      */
441     function safeApprove(IERC20 token, address spender, uint256 value) internal {
442         // safeApprove should only be called when setting an initial allowance,
443         // or when resetting it to zero. To increase and decrease it, use
444         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
445         // solhint-disable-next-line max-line-length
446         require((value == 0) || (token.allowance(address(this), spender) == 0),
447             "SafeERC20: approve from non-zero to non-zero allowance"
448         );
449         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
450     }
451 
452     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
453         uint256 newAllowance = token.allowance(address(this), spender).add(value);
454         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
455     }
456 
457     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
458         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
459         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
460     }
461 
462     /**
463      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
464      * on the return value: the return value is optional (but if data is returned, it must not be false).
465      * @param token The token targeted by the call.
466      * @param data The call data (encoded using abi.encode or one of its variants).
467      */
468     function _callOptionalReturn(IERC20 token, bytes memory data) private {
469         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
470         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
471         // the target address contains contract code and also asserts for success in the low-level call.
472 
473         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
474         if (returndata.length > 0) { // Return data is optional
475             // solhint-disable-next-line max-line-length
476             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
477         }
478     }
479 }
480 
481 
482 
483 /**
484  * @dev Contract module which provides a basic access control mechanism, where
485  * there is an account (an owner) that can be granted exclusive access to
486  * specific functions.
487  *
488  * By default, the owner account will be the one that deploys the contract. This
489  * can later be changed with {transferOwnership}.
490  *
491  * This module is used through inheritance. It will make available the modifier
492  * `onlyOwner`, which can be applied to your functions to restrict their use to
493  * the owner.
494  */
495 contract Ownable is Context {
496     address private _owner;
497 
498     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
499 
500     /**
501      * @dev Initializes the contract setting the deployer as the initial owner.
502      */
503     constructor () internal {
504         address msgSender = _msgSender();
505         _owner = msgSender;
506         emit OwnershipTransferred(address(0), msgSender);
507     }
508 
509     /**
510      * @dev Returns the address of the current owner.
511      */
512     function owner() public view returns (address) {
513         return _owner;
514     }
515 
516     /**
517      * @dev Throws if called by any account other than the owner.
518      */
519     modifier onlyOwner() {
520         require(_owner == _msgSender(), "Ownable: caller is not the owner");
521         _;
522     }
523 
524     /**
525      * @dev Leaves the contract without owner. It will not be possible to call
526      * `onlyOwner` functions anymore. Can only be called by the current owner.
527      *
528      * NOTE: Renouncing ownership will leave the contract without an owner,
529      * thereby removing any functionality that is only available to the owner.
530      */
531     function renounceOwnership() public virtual onlyOwner {
532         emit OwnershipTransferred(_owner, address(0));
533         _owner = address(0);
534     }
535 
536     /**
537      * @dev Transfers ownership of the contract to a new account (`newOwner`).
538      * Can only be called by the current owner.
539      */
540     function transferOwnership(address newOwner) public virtual onlyOwner {
541         require(newOwner != address(0), "Ownable: new owner is the zero address");
542         emit OwnershipTransferred(_owner, newOwner);
543         _owner = newOwner;
544     }
545 }
546 
547 
548 /**
549  * @dev Implementation of the {IERC20} interface.
550  *
551  * This implementation is agnostic to the way tokens are created. This means
552  * that a supply mechanism has to be added in a derived contract using {_mint}.
553  * For a generic mechanism see {ERC20PresetMinterPauser}.
554  *
555  * TIP: For a detailed writeup see our guide
556  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
557  * to implement supply mechanisms].
558  *
559  * We have followed general OpenZeppelin guidelines: functions revert instead
560  * of returning `false` on failure. This behavior is nonetheless conventional
561  * and does not conflict with the expectations of ERC20 applications.
562  *
563  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
564  * This allows applications to reconstruct the allowance for all accounts just
565  * by listening to said events. Other implementations of the EIP may not emit
566  * these events, as it isn't required by the specification.
567  *
568  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
569  * functions have been added to mitigate the well-known issues around setting
570  * allowances. See {IERC20-approve}.
571  */
572 contract ERC20 is Context, IERC20 {
573     using SafeMath for uint256;
574     using Address for address;
575 
576     mapping (address => uint256) private _balances;
577 
578     mapping (address => mapping (address => uint256)) private _allowances;
579 
580     uint256 private _totalSupply;
581 
582     string private _name;
583     string private _symbol;
584     uint8 private _decimals;
585 
586     /**
587      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
588      * a default value of 18.
589      *
590      * To select a different value for {decimals}, use {_setupDecimals}.
591      *
592      * All three of these values are immutable: they can only be set once during
593      * construction.
594      */
595     constructor (string memory name, string memory symbol) public {
596         _name = name;
597         _symbol = symbol;
598         _decimals = 18;
599     }
600 
601     /**
602      * @dev Returns the name of the token.
603      */
604     function name() public view returns (string memory) {
605         return _name;
606     }
607 
608     /**
609      * @dev Returns the symbol of the token, usually a shorter version of the
610      * name.
611      */
612     function symbol() public view returns (string memory) {
613         return _symbol;
614     }
615 
616     /**
617      * @dev Returns the number of decimals used to get its user representation.
618      * For example, if `decimals` equals `2`, a balance of `505` tokens should
619      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
620      *
621      * Tokens usually opt for a value of 18, imitating the relationship between
622      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
623      * called.
624      *
625      * NOTE: This information is only used for _display_ purposes: it in
626      * no way affects any of the arithmetic of the contract, including
627      * {IERC20-balanceOf} and {IERC20-transfer}.
628      */
629     function decimals() public view returns (uint8) {
630         return _decimals;
631     }
632 
633     /**
634      * @dev See {IERC20-totalSupply}.
635      */
636     function totalSupply() public view override returns (uint256) {
637         return _totalSupply;
638     }
639 
640     /**
641      * @dev See {IERC20-balanceOf}.
642      */
643     function balanceOf(address account) public view override returns (uint256) {
644         return _balances[account];
645     }
646 
647     /**
648      * @dev See {IERC20-transfer}.
649      *
650      * Requirements:
651      *
652      * - `recipient` cannot be the zero address.
653      * - the caller must have a balance of at least `amount`.
654      */
655     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
656         _transfer(_msgSender(), recipient, amount);
657         return true;
658     }
659 
660     /**
661      * @dev See {IERC20-allowance}.
662      */
663     function allowance(address owner, address spender) public view virtual override returns (uint256) {
664         return _allowances[owner][spender];
665     }
666 
667     /**
668      * @dev See {IERC20-approve}.
669      *
670      * Requirements:
671      *
672      * - `spender` cannot be the zero address.
673      */
674     function approve(address spender, uint256 amount) public virtual override returns (bool) {
675         _approve(_msgSender(), spender, amount);
676         return true;
677     }
678 
679     /**
680      * @dev See {IERC20-transferFrom}.
681      *
682      * Emits an {Approval} event indicating the updated allowance. This is not
683      * required by the EIP. See the note at the beginning of {ERC20};
684      *
685      * Requirements:
686      * - `sender` and `recipient` cannot be the zero address.
687      * - `sender` must have a balance of at least `amount`.
688      * - the caller must have allowance for ``sender``'s tokens of at least
689      * `amount`.
690      */
691     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
692         _transfer(sender, recipient, amount);
693         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
694         return true;
695     }
696 
697     /**
698      * @dev Atomically increases the allowance granted to `spender` by the caller.
699      *
700      * This is an alternative to {approve} that can be used as a mitigation for
701      * problems described in {IERC20-approve}.
702      *
703      * Emits an {Approval} event indicating the updated allowance.
704      *
705      * Requirements:
706      *
707      * - `spender` cannot be the zero address.
708      */
709     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
710         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
711         return true;
712     }
713 
714     /**
715      * @dev Atomically decreases the allowance granted to `spender` by the caller.
716      *
717      * This is an alternative to {approve} that can be used as a mitigation for
718      * problems described in {IERC20-approve}.
719      *
720      * Emits an {Approval} event indicating the updated allowance.
721      *
722      * Requirements:
723      *
724      * - `spender` cannot be the zero address.
725      * - `spender` must have allowance for the caller of at least
726      * `subtractedValue`.
727      */
728     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
729         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
730         return true;
731     }
732 
733     /**
734      * @dev Moves tokens `amount` from `sender` to `recipient`.
735      *
736      * This is internal function is equivalent to {transfer}, and can be used to
737      * e.g. implement automatic token fees, slashing mechanisms, etc.
738      *
739      * Emits a {Transfer} event.
740      *
741      * Requirements:
742      *
743      * - `sender` cannot be the zero address.
744      * - `recipient` cannot be the zero address.
745      * - `sender` must have a balance of at least `amount`.
746      */
747     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
748         require(sender != address(0), "ERC20: transfer from the zero address");
749         require(recipient != address(0), "ERC20: transfer to the zero address");
750 
751         _beforeTokenTransfer(sender, recipient, amount);
752 
753         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
754         _balances[recipient] = _balances[recipient].add(amount);
755         emit Transfer(sender, recipient, amount);
756     }
757 
758     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
759      * the total supply.
760      *
761      * Emits a {Transfer} event with `from` set to the zero address.
762      *
763      * Requirements
764      *
765      * - `to` cannot be the zero address.
766      */
767     function _mint(address account, uint256 amount) internal virtual {
768         require(account != address(0), "ERC20: mint to the zero address");
769 
770         _beforeTokenTransfer(address(0), account, amount);
771 
772         _totalSupply = _totalSupply.add(amount);
773         _balances[account] = _balances[account].add(amount);
774         emit Transfer(address(0), account, amount);
775     }
776 
777     /**
778      * @dev Destroys `amount` tokens from `account`, reducing the
779      * total supply.
780      *
781      * Emits a {Transfer} event with `to` set to the zero address.
782      *
783      * Requirements
784      *
785      * - `account` cannot be the zero address.
786      * - `account` must have at least `amount` tokens.
787      */
788     function _burn(address account, uint256 amount) internal virtual {
789         require(account != address(0), "ERC20: burn from the zero address");
790 
791         _beforeTokenTransfer(account, address(0), amount);
792 
793         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
794         _totalSupply = _totalSupply.sub(amount);
795         emit Transfer(account, address(0), amount);
796     }
797 
798     /**
799      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
800      *
801      * This is internal function is equivalent to `approve`, and can be used to
802      * e.g. set automatic allowances for certain subsystems, etc.
803      *
804      * Emits an {Approval} event.
805      *
806      * Requirements:
807      *
808      * - `owner` cannot be the zero address.
809      * - `spender` cannot be the zero address.
810      */
811     function _approve(address owner, address spender, uint256 amount) internal virtual {
812         require(owner != address(0), "ERC20: approve from the zero address");
813         require(spender != address(0), "ERC20: approve to the zero address");
814 
815         _allowances[owner][spender] = amount;
816         emit Approval(owner, spender, amount);
817     }
818 
819     /**
820      * @dev Sets {decimals} to a value other than the default one of 18.
821      *
822      * WARNING: This function should only be called from the constructor. Most
823      * applications that interact with token contracts will not expect
824      * {decimals} to ever change, and may work incorrectly if it does.
825      */
826     function _setupDecimals(uint8 decimals_) internal {
827         _decimals = decimals_;
828     }
829 
830     /**
831      * @dev Hook that is called before any transfer of tokens. This includes
832      * minting and burning.
833      *
834      * Calling conditions:
835      *
836      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
837      * will be to transferred to `to`.
838      * - when `from` is zero, `amount` tokens will be minted for `to`.
839      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
840      * - `from` and `to` are never both zero.
841      *
842      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
843      */
844     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
845 }
846 
847 // BurgerToken with Governance.
848 contract BurgerToken is ERC20("burger.money", "BURGER"), Ownable {
849     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
850     function mint(address _to, uint256 _amount) public onlyOwner {
851         _mint(_to, _amount);
852     }
853 }