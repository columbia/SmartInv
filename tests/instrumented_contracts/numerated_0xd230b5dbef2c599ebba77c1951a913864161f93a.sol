1 /*
2 
3 website: kimbap.finance
4 
5 $$\   $$\ $$$$$$\ $$\      $$\ $$$$$$$\   $$$$$$\  $$$$$$$\  
6 $$ | $$  |\_$$  _|$$$\    $$$ |$$  __$$\ $$  __$$\ $$  __$$\ 
7 $$ |$$  /   $$ |  $$$$\  $$$$ |$$ |  $$ |$$ /  $$ |$$ |  $$ |
8 $$$$$  /    $$ |  $$\$$\$$ $$ |$$$$$$$\ |$$$$$$$$ |$$$$$$$  |
9 $$  $$<     $$ |  $$ \$$$  $$ |$$  __$$\ $$  __$$ |$$  ____/ 
10 $$ |\$$\    $$ |  $$ |\$  /$$ |$$ |  $$ |$$ |  $$ |$$ |      
11 $$ | \$$\ $$$$$$\ $$ | \_/ $$ |$$$$$$$  |$$ |  $$ |$$ |      
12 \__|  \__|\______|\__|     \__|\_______/ \__|  \__|\__|      
13 
14 forked from KIMCHI, SUSHI and YUNO
15 
16 */
17 
18 pragma solidity ^0.6.12;
19 /*
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with GSN meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address payable) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes memory) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 /**
41  * @dev Interface of the ERC20 standard as defined in the EIP.
42  */
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
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
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * @dev Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      */
292     function isContract(address account) internal view returns (bool) {
293         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
294         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
295         // for accounts without code, i.e. `keccak256('')`
296         bytes32 codehash;
297         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
298         // solhint-disable-next-line no-inline-assembly
299         assembly { codehash := extcodehash(account) }
300         return (codehash != accountHash && codehash != 0x0);
301     }
302 
303     /**
304      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
323         (bool success, ) = recipient.call{ value: amount }("");
324         require(success, "Address: unable to send value, recipient may have reverted");
325     }
326 
327     /**
328      * @dev Performs a Solidity function call using a low level `call`. A
329      * plain`call` is an unsafe replacement for a function call: use this
330      * function instead.
331      *
332      * If `target` reverts with a revert reason, it is bubbled up by this
333      * function (like regular Solidity function calls).
334      *
335      * Returns the raw returned data. To convert to the expected return value,
336      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
337      *
338      * Requirements:
339      *
340      * - `target` must be a contract.
341      * - calling `target` with `data` must not revert.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
346       return functionCall(target, data, "Address: low-level call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
351      * `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
356         return _functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
376      * with `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         return _functionCallWithValue(target, data, value, errorMessage);
383     }
384 
385     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
386         require(isContract(target), "Address: call to non-contract");
387 
388         // solhint-disable-next-line avoid-low-level-calls
389         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 // solhint-disable-next-line no-inline-assembly
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 /**
410  * @title SafeERC20
411  * @dev Wrappers around ERC20 operations that throw on failure (when the token
412  * contract returns false). Tokens that return no value (and instead revert or
413  * throw on failure) are also supported, non-reverting calls are assumed to be
414  * successful.
415  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
416  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
417  */
418 library SafeERC20 {
419     using SafeMath for uint256;
420     using Address for address;
421 
422     function safeTransfer(IERC20 token, address to, uint256 value) internal {
423         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
424     }
425 
426     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
427         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
428     }
429 
430     /**
431      * @dev Deprecated. This function has issues similar to the ones found in
432      * {IERC20-approve}, and its usage is discouraged.
433      *
434      * Whenever possible, use {safeIncreaseAllowance} and
435      * {safeDecreaseAllowance} instead.
436      */
437     function safeApprove(IERC20 token, address spender, uint256 value) internal {
438         // safeApprove should only be called when setting an initial allowance,
439         // or when resetting it to zero. To increase and decrease it, use
440         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
441         // solhint-disable-next-line max-line-length
442         require((value == 0) || (token.allowance(address(this), spender) == 0),
443             "SafeERC20: approve from non-zero to non-zero allowance"
444         );
445         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
446     }
447 
448     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
449         uint256 newAllowance = token.allowance(address(this), spender).add(value);
450         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
451     }
452 
453     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
454         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
456     }
457 
458     /**
459      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
460      * on the return value: the return value is optional (but if data is returned, it must not be false).
461      * @param token The token targeted by the call.
462      * @param data The call data (encoded using abi.encode or one of its variants).
463      */
464     function _callOptionalReturn(IERC20 token, bytes memory data) private {
465         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
466         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
467         // the target address contains contract code and also asserts for success in the low-level call.
468 
469         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
470         if (returndata.length > 0) { // Return data is optional
471             // solhint-disable-next-line max-line-length
472             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
473         }
474     }
475 }
476 
477 
478 
479 /**
480  * @dev Contract module which provides a basic access control mechanism, where
481  * there is an account (an owner) that can be granted exclusive access to
482  * specific functions.
483  *
484  * By default, the owner account will be the one that deploys the contract. This
485  * can later be changed with {transferOwnership}.
486  *
487  * This module is used through inheritance. It will make available the modifier
488  * `onlyOwner`, which can be applied to your functions to restrict their use to
489  * the owner.
490  */
491 contract Ownable is Context {
492     address private _owner;
493 
494     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
495 
496     /**
497      * @dev Initializes the contract setting the deployer as the initial owner.
498      */
499     constructor () internal {
500         address msgSender = _msgSender();
501         _owner = msgSender;
502         emit OwnershipTransferred(address(0), msgSender);
503     }
504 
505     /**
506      * @dev Returns the address of the current owner.
507      */
508     function owner() public view returns (address) {
509         return _owner;
510     }
511 
512     /**
513      * @dev Throws if called by any account other than the owner.
514      */
515     modifier onlyOwner() {
516         require(_owner == _msgSender(), "Ownable: caller is not the owner");
517         _;
518     }
519 
520     /**
521      * @dev Leaves the contract without owner. It will not be possible to call
522      * `onlyOwner` functions anymore. Can only be called by the current owner.
523      *
524      * NOTE: Renouncing ownership will leave the contract without an owner,
525      * thereby removing any functionality that is only available to the owner.
526      */
527     function renounceOwnership() public virtual onlyOwner {
528         emit OwnershipTransferred(_owner, address(0));
529         _owner = address(0);
530     }
531 
532     /**
533      * @dev Transfers ownership of the contract to a new account (`newOwner`).
534      * Can only be called by the current owner.
535      */
536     function transferOwnership(address newOwner) public virtual onlyOwner {
537         require(newOwner != address(0), "Ownable: new owner is the zero address");
538         emit OwnershipTransferred(_owner, newOwner);
539         _owner = newOwner;
540     }
541 }
542 
543 
544 /**
545  * @dev Implementation of the {IERC20} interface.
546  *
547  * This implementation is agnostic to the way tokens are created. This means
548  * that a supply mechanism has to be added in a derived contract using {_mint}.
549  * For a generic mechanism see {ERC20PresetMinterPauser}.
550  *
551  * TIP: For a detailed writeup see our guide
552  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
553  * to implement supply mechanisms].
554  *
555  * We have followed general OpenZeppelin guidelines: functions revert instead
556  * of returning `false` on failure. This behavior is nonetheless conventional
557  * and does not conflict with the expectations of ERC20 applications.
558  *
559  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
560  * This allows applications to reconstruct the allowance for all accounts just
561  * by listening to said events. Other implementations of the EIP may not emit
562  * these events, as it isn't required by the specification.
563  *
564  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
565  * functions have been added to mitigate the well-known issues around setting
566  * allowances. See {IERC20-approve}.
567  */
568 contract ERC20 is Context, IERC20 {
569     using SafeMath for uint256;
570     using Address for address;
571 
572     mapping (address => uint256) private _balances;
573 
574     mapping (address => mapping (address => uint256)) private _allowances;
575 
576     uint256 private _totalSupply;
577 
578     string private _name;
579     string private _symbol;
580     uint8 private _decimals;
581 
582     /**
583      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
584      * a default value of 18.
585      *
586      * To select a different value for {decimals}, use {_setupDecimals}.
587      *
588      * All three of these values are immutable: they can only be set once during
589      * construction.
590      */
591     constructor (string memory name, string memory symbol) public {
592         _name = name;
593         _symbol = symbol;
594         _decimals = 18;
595     }
596 
597     /**
598      * @dev Returns the name of the token.
599      */
600     function name() public view returns (string memory) {
601         return _name;
602     }
603 
604     /**
605      * @dev Returns the symbol of the token, usually a shorter version of the
606      * name.
607      */
608     function symbol() public view returns (string memory) {
609         return _symbol;
610     }
611 
612     /**
613      * @dev Returns the number of decimals used to get its user representation.
614      * For example, if `decimals` equals `2`, a balance of `505` tokens should
615      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
616      *
617      * Tokens usually opt for a value of 18, imitating the relationship between
618      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
619      * called.
620      *
621      * NOTE: This information is only used for _display_ purposes: it in
622      * no way affects any of the arithmetic of the contract, including
623      * {IERC20-balanceOf} and {IERC20-transfer}.
624      */
625     function decimals() public view returns (uint8) {
626         return _decimals;
627     }
628 
629     /**
630      * @dev See {IERC20-totalSupply}.
631      */
632     function totalSupply() public view override returns (uint256) {
633         return _totalSupply;
634     }
635 
636     /**
637      * @dev See {IERC20-balanceOf}.
638      */
639     function balanceOf(address account) public view override returns (uint256) {
640         return _balances[account];
641     }
642 
643     /**
644      * @dev See {IERC20-transfer}.
645      *
646      * Requirements:
647      *
648      * - `recipient` cannot be the zero address.
649      * - the caller must have a balance of at least `amount`.
650      */
651     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
652         _transfer(_msgSender(), recipient, amount);
653         return true;
654     }
655 
656     /**
657      * @dev See {IERC20-allowance}.
658      */
659     function allowance(address owner, address spender) public view virtual override returns (uint256) {
660         return _allowances[owner][spender];
661     }
662 
663     /**
664      * @dev See {IERC20-approve}.
665      *
666      * Requirements:
667      *
668      * - `spender` cannot be the zero address.
669      */
670     function approve(address spender, uint256 amount) public virtual override returns (bool) {
671         _approve(_msgSender(), spender, amount);
672         return true;
673     }
674 
675     /**
676      * @dev See {IERC20-transferFrom}.
677      *
678      * Emits an {Approval} event indicating the updated allowance. This is not
679      * required by the EIP. See the note at the beginning of {ERC20};
680      *
681      * Requirements:
682      * - `sender` and `recipient` cannot be the zero address.
683      * - `sender` must have a balance of at least `amount`.
684      * - the caller must have allowance for ``sender``'s tokens of at least
685      * `amount`.
686      */
687     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
688         _transfer(sender, recipient, amount);
689         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
690         return true;
691     }
692 
693     /**
694      * @dev Atomically increases the allowance granted to `spender` by the caller.
695      *
696      * This is an alternative to {approve} that can be used as a mitigation for
697      * problems described in {IERC20-approve}.
698      *
699      * Emits an {Approval} event indicating the updated allowance.
700      *
701      * Requirements:
702      *
703      * - `spender` cannot be the zero address.
704      */
705     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
706         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
707         return true;
708     }
709 
710     /**
711      * @dev Atomically decreases the allowance granted to `spender` by the caller.
712      *
713      * This is an alternative to {approve} that can be used as a mitigation for
714      * problems described in {IERC20-approve}.
715      *
716      * Emits an {Approval} event indicating the updated allowance.
717      *
718      * Requirements:
719      *
720      * - `spender` cannot be the zero address.
721      * - `spender` must have allowance for the caller of at least
722      * `subtractedValue`.
723      */
724     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
725         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
726         return true;
727     }
728 
729     /**
730      * @dev Moves tokens `amount` from `sender` to `recipient`.
731      *
732      * This is internal function is equivalent to {transfer}, and can be used to
733      * e.g. implement automatic token fees, slashing mechanisms, etc.
734      *
735      * Emits a {Transfer} event.
736      *
737      * Requirements:
738      *
739      * - `sender` cannot be the zero address.
740      * - `recipient` cannot be the zero address.
741      * - `sender` must have a balance of at least `amount`.
742      */
743     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
744         require(sender != address(0), "ERC20: transfer from the zero address");
745         require(recipient != address(0), "ERC20: transfer to the zero address");
746 
747         _beforeTokenTransfer(sender, recipient, amount);
748 
749         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
750         _balances[recipient] = _balances[recipient].add(amount);
751         emit Transfer(sender, recipient, amount);
752     }
753 
754     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
755      * the total supply.
756      *
757      * Emits a {Transfer} event with `from` set to the zero address.
758      *
759      * Requirements
760      *
761      * - `to` cannot be the zero address.
762      */
763     function _mint(address account, uint256 amount) internal virtual {
764         require(account != address(0), "ERC20: mint to the zero address");
765 
766         _beforeTokenTransfer(address(0), account, amount);
767 
768         _totalSupply = _totalSupply.add(amount);
769         _balances[account] = _balances[account].add(amount);
770         emit Transfer(address(0), account, amount);
771     }
772 
773     /**
774      * @dev Destroys `amount` tokens from `account`, reducing the
775      * total supply.
776      *
777      * Emits a {Transfer} event with `to` set to the zero address.
778      *
779      * Requirements
780      *
781      * - `account` cannot be the zero address.
782      * - `account` must have at least `amount` tokens.
783      */
784     function _burn(address account, uint256 amount) internal virtual {
785         require(account != address(0), "ERC20: burn from the zero address");
786 
787         _beforeTokenTransfer(account, address(0), amount);
788 
789         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
790         _totalSupply = _totalSupply.sub(amount);
791         emit Transfer(account, address(0), amount);
792     }
793 
794     /**
795      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
796      *
797      * This is internal function is equivalent to `approve`, and can be used to
798      * e.g. set automatic allowances for certain subsystems, etc.
799      *
800      * Emits an {Approval} event.
801      *
802      * Requirements:
803      *
804      * - `owner` cannot be the zero address.
805      * - `spender` cannot be the zero address.
806      */
807     function _approve(address owner, address spender, uint256 amount) internal virtual {
808         require(owner != address(0), "ERC20: approve from the zero address");
809         require(spender != address(0), "ERC20: approve to the zero address");
810 
811         _allowances[owner][spender] = amount;
812         emit Approval(owner, spender, amount);
813     }
814 
815     /**
816      * @dev Sets {decimals} to a value other than the default one of 18.
817      *
818      * WARNING: This function should only be called from the constructor. Most
819      * applications that interact with token contracts will not expect
820      * {decimals} to ever change, and may work incorrectly if it does.
821      */
822     function _setupDecimals(uint8 decimals_) internal {
823         _decimals = decimals_;
824     }
825 
826     /**
827      * @dev Hook that is called before any transfer of tokens. This includes
828      * minting and burning.
829      *
830      * Calling conditions:
831      *
832      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
833      * will be to transferred to `to`.
834      * - when `from` is zero, `amount` tokens will be minted for `to`.
835      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
836      * - `from` and `to` are never both zero.
837      *
838      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
839      */
840     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
841 }
842 
843 // KimbapToken
844 contract KimbapToken is ERC20("kimbap.finance", "KIMBAP"), Ownable {
845     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
846     function mint(address _to, uint256 _amount) public onlyOwner {
847         _mint(_to, _amount);
848     }
849 }
850 
851 contract KimbapMasterChef is Ownable {
852     using SafeMath for uint256;
853     using SafeERC20 for IERC20;
854 
855     // Info of each user.
856     struct UserInfo {
857         uint256 amount;     // How many LP tokens the user has provided.
858         uint256 rewardDebt; // Reward debt. See explanation below.
859         //
860         // We do some fancy math here. Basically, any point in time, the amount of KIMBAPs
861         // entitled to a user but is pending to be distributed is:
862         //
863         //   pending reward = (user.amount * pool.accKimbapPerShare) - user.rewardDebt
864         //
865         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
866         //   1. The pool's `accKimbapPerShare` (and `lastRewardBlock`) gets updated.
867         //   2. User receives the pending reward sent to his/her address.
868         //   3. User's `amount` gets updated.
869         //   4. User's `rewardDebt` gets updated.
870     }
871 
872     // Info of each pool.
873     struct PoolInfo {
874         IERC20 lpToken;           // Address of LP token contract.
875         uint256 allocPoint;       // How many allocation points assigned to this pool. KIMBAPs to distribute per block.
876         uint256 lastRewardBlock;  // Last block number that KIMBAPs distribution occurs.
877         uint256 accKimbapPerShare; // Accumulated KIMBAPs per share, times 1e12. See below.
878     }
879 
880     // The KIMBAP TOKEN!
881     KimbapToken public kimbap;
882     // Dev address.
883     address public devaddr;
884     // Block number when bonus KIMBAP period ends.
885     uint256 public bonusEndBlock;
886     // KIMBAP tokens created per block.
887     uint256 public kimbapPerBlock;
888     // Bonus muliplier for early kimbap makers.
889     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
890 
891     // Info of each pool.
892     PoolInfo[] public poolInfo;
893     // Info of each user that stakes LP tokens.
894     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
895     // Total allocation poitns. Must be the sum of all allocation points in all pools.
896     uint256 public totalAllocPoint = 0;
897     // The block number when KIMBAP mining starts.
898     uint256 public startBlock;
899 
900     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
901     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
902     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
903 
904     constructor(
905         KimbapToken _kimbap,
906         address _devaddr,
907         uint256 _kimbapPerBlock,
908         uint256 _startBlock,
909         uint256 _bonusEndBlock
910     ) public {
911         kimbap = _kimbap;
912         devaddr = _devaddr;
913         kimbapPerBlock = _kimbapPerBlock;
914         bonusEndBlock = _bonusEndBlock;
915         startBlock = _startBlock;
916     }
917     
918     function poolLength() external view returns (uint256) {
919         return poolInfo.length;
920     }
921 
922     // Add a new lp to the pool. Can only be called by the owner.
923     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
924     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
925         if (_withUpdate) {
926             massUpdatePools();
927         }
928         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
929         totalAllocPoint = totalAllocPoint.add(_allocPoint);
930         poolInfo.push(PoolInfo({
931             lpToken: _lpToken,
932             allocPoint: _allocPoint,
933             lastRewardBlock: lastRewardBlock,
934             accKimbapPerShare: 0
935         }));
936     }
937 
938     // Update the given pool's KIMBAP allocation point. Can only be called by the owner.
939     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
940         if (_withUpdate) {
941             massUpdatePools();
942         }
943         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
944         poolInfo[_pid].allocPoint = _allocPoint;
945     }
946 
947     // Return reward multiplier over the given _from to _to block.
948     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
949         if (_to <= bonusEndBlock) {
950             return _to.sub(_from).mul(BONUS_MULTIPLIER);
951         } else if (_from >= bonusEndBlock) {
952             return _to.sub(_from);
953         } else {
954             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
955                 _to.sub(bonusEndBlock)
956             );
957         }
958     }
959 
960     // View function to see pending KIMBAPs on frontend.
961     function pendingKimbap(uint256 _pid, address _user) external view returns (uint256) {
962         PoolInfo storage pool = poolInfo[_pid];
963         UserInfo storage user = userInfo[_pid][_user];
964         uint256 accKimbapPerShare = pool.accKimbapPerShare;
965         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
966         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
967             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
968             uint256 kimbapReward = multiplier.mul(kimbapPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
969             accKimbapPerShare = accKimbapPerShare.add(kimbapReward.mul(1e12).div(lpSupply));
970         }
971         return user.amount.mul(accKimbapPerShare).div(1e12).sub(user.rewardDebt);
972     }
973 
974     // Update reward vairables for all pools. Be careful of gas spending!
975     function massUpdatePools() public {
976         uint256 length = poolInfo.length;
977         for (uint256 pid = 0; pid < length; ++pid) {
978             updatePool(pid);
979         }
980     }
981 
982     // Update reward variables of the given pool to be up-to-date.
983     function updatePool(uint256 _pid) public {
984         PoolInfo storage pool = poolInfo[_pid];
985         if (block.number <= pool.lastRewardBlock) {
986             return;
987         }
988         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
989         if (lpSupply == 0) {
990             pool.lastRewardBlock = block.number;
991             return;
992         }
993         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
994         uint256 kimbapReward = multiplier.mul(kimbapPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
995         kimbap.mint(devaddr, kimbapReward.div(20)); // 5%
996         kimbap.mint(address(this), kimbapReward);
997         pool.accKimbapPerShare = pool.accKimbapPerShare.add(kimbapReward.mul(1e12).div(lpSupply));
998         pool.lastRewardBlock = block.number;
999     }
1000 
1001     // Deposit LP tokens to MasterChef for KIMBAP allocation.
1002     function deposit(uint256 _pid, uint256 _amount) public {
1003         PoolInfo storage pool = poolInfo[_pid];
1004         UserInfo storage user = userInfo[_pid][msg.sender];
1005         updatePool(_pid);
1006         if (user.amount > 0) {
1007             uint256 pending = user.amount.mul(pool.accKimbapPerShare).div(1e12).sub(user.rewardDebt);
1008             safeKimbapTransfer(msg.sender, pending);
1009         }
1010         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1011         user.amount = user.amount.add(_amount);
1012         user.rewardDebt = user.amount.mul(pool.accKimbapPerShare).div(1e12);
1013         emit Deposit(msg.sender, _pid, _amount);
1014     }
1015 
1016     // Withdraw LP tokens from MasterChef.
1017     function withdraw(uint256 _pid, uint256 _amount) public {
1018         PoolInfo storage pool = poolInfo[_pid];
1019         UserInfo storage user = userInfo[_pid][msg.sender];
1020         require(user.amount >= _amount, "withdraw: not good");
1021         updatePool(_pid);
1022         uint256 pending = user.amount.mul(pool.accKimbapPerShare).div(1e12).sub(user.rewardDebt);
1023         safeKimbapTransfer(msg.sender, pending);
1024         user.amount = user.amount.sub(_amount);
1025         user.rewardDebt = user.amount.mul(pool.accKimbapPerShare).div(1e12);
1026         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1027         emit Withdraw(msg.sender, _pid, _amount);
1028     }
1029 
1030     // Withdraw without caring about rewards. EMERGENCY ONLY.
1031     function emergencyWithdraw(uint256 _pid) public {
1032         PoolInfo storage pool = poolInfo[_pid];
1033         UserInfo storage user = userInfo[_pid][msg.sender];
1034         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1035         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1036         user.amount = 0;
1037         user.rewardDebt = 0;
1038     }
1039 
1040     // Safe kimbap transfer function, just in case if rounding error causes pool to not have enough KIMBAPs.
1041     function safeKimbapTransfer(address _to, uint256 _amount) internal {
1042         uint256 kimbapBal = kimbap.balanceOf(address(this));
1043         if (_amount > kimbapBal) {
1044             kimbap.transfer(_to, kimbapBal);
1045         } else {
1046             kimbap.transfer(_to, _amount);
1047         }
1048     }
1049 
1050     // Update dev address by the previous dev.
1051     function dev(address _devaddr) public {
1052         require(msg.sender == devaddr, "dev: wut?");
1053         devaddr = _devaddr;
1054     }
1055 }