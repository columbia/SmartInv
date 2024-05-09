1 /*
2  
3           _       _________ _______           _______ 
4 |\     /|( (    /|\__   __/(  ___  )|\     /|(  ____ \
5 | )   ( ||  \  ( |   ) (   | (   ) || )   ( || (    \/
6 | |   | ||   \ | |   | |   | |   | || |   | || (__    
7 | |   | || (\ \) |   | |   | |   | || |   | ||  __)   
8 | |   | || | \   |   | |   | | /\| || |   | || (      
9 | (___) || )  \  |___) (___| (_\ \ || (___) || (____/\
10 (_______)|/    )_)\_______/(____\/_)(_______)(_______/
11                                                       
12  _______           _______ _________ _______ 
13 (  ____ )|\     /|(  ___  )\__   __/(  ___  )
14 | (    )|| )   ( || (   ) |   ) (   | (   ) |
15 | (____)|| (___) || |   | |   | |   | |   | |
16 |  _____)|  ___  || |   | |   | |   | |   | |
17 | (      | (   ) || |   | |   | |   | |   | |
18 | )      | )   ( || (___) |   | |   | (___) |
19 |/       |/     \|(_______)   )_(   (_______)
20                                              
21 
22  https://unique.photo
23  
24 */
25 
26 // File: @openzeppelin/contracts/GSN/Context.sol
27 
28 pragma solidity ^0.6.0;
29 
30 /*
31  * @dev Provides information about the current execution context, including the
32  * sender of the transaction and its data. While these are generally available
33  * via msg.sender and msg.data, they should not be accessed in such a direct
34  * manner, since when dealing with GSN meta-transactions the account sending and
35  * paying for execution may not be the actual sender (as far as an application
36  * is concerned).
37  *
38  * This contract is only required for intermediate, library-like contracts.
39  */
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address payable) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50 
51 
52 // File: @openzeppelin/contracts/math/SafeMath.sol
53 
54 pragma solidity ^0.6.0;
55 
56 /**
57  * @dev Wrappers over Solidity's arithmetic operations with added overflow
58  * checks.
59  *
60  * Arithmetic operations in Solidity wrap on overflow. This can easily result
61  * in bugs, because programmers usually assume that an overflow raises an
62  * error, which is the standard behavior in high level programming languages.
63  * `SafeMath` restores this intuition by reverting the transaction when an
64  * operation overflows.
65  *
66  * Using this library instead of the unchecked operations eliminates an entire
67  * class of bugs, so it's recommended to use it always.
68  */
69 library SafeMath {
70     /**
71      * @dev Returns the addition of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `+` operator.
75      *
76      * Requirements:
77      *
78      * - Addition cannot overflow.
79      */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the subtraction of two unsigned integers, reverting on
89      * overflow (when the result is negative).
90      *
91      * Counterpart to Solidity's `-` operator.
92      *
93      * Requirements:
94      *
95      * - Subtraction cannot overflow.
96      */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return sub(a, b, "SafeMath: subtraction overflow");
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b <= a, errorMessage);
113         uint256 c = a - b;
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the multiplication of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `*` operator.
123      *
124      * Requirements:
125      *
126      * - Multiplication cannot overflow.
127      */
128     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130         // benefit is lost if 'b' is also tested.
131         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
132         if (a == 0) {
133             return 0;
134         }
135 
136         uint256 c = a * b;
137         require(c / a == b, "SafeMath: multiplication overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the integer division of two unsigned integers. Reverts on
144      * division by zero. The result is rounded towards zero.
145      *
146      * Counterpart to Solidity's `/` operator. Note: this function uses a
147      * `revert` opcode (which leaves remaining gas untouched) while Solidity
148      * uses an invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         return div(a, b, "SafeMath: division by zero");
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b > 0, errorMessage);
172         uint256 c = a / b;
173         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
191         return mod(a, b, "SafeMath: modulo by zero");
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * Reverts with custom message when dividing by zero.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b != 0, errorMessage);
208         return a % b;
209     }
210 }
211 
212 
213 // File: @openzeppelin/contracts/utils/Address.sol
214 
215 pragma solidity ^0.6.2;
216 
217 /**
218  * @dev Collection of functions related to the address type
219  */
220 library Address {
221     /**
222      * @dev Returns true if `account` is a contract.
223      *
224      * [IMPORTANT]
225      * ====
226      * It is unsafe to assume that an address for which this function returns
227      * false is an externally-owned account (EOA) and not a contract.
228      *
229      * Among others, `isContract` will return false for the following
230      * types of addresses:
231      *
232      *  - an externally-owned account
233      *  - a contract in construction
234      *  - an address where a contract will be created
235      *  - an address where a contract lived, but was destroyed
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies in extcodesize, which returns 0 for contracts in
240         // construction, since the code is only stored at the end of the
241         // constructor execution.
242 
243         uint256 size;
244         // solhint-disable-next-line no-inline-assembly
245         assembly { size := extcodesize(account) }
246         return size > 0;
247     }
248 
249     /**
250      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
251      * `recipient`, forwarding all available gas and reverting on errors.
252      *
253      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
254      * of certain opcodes, possibly making contracts go over the 2300 gas limit
255      * imposed by `transfer`, making them unable to receive funds via
256      * `transfer`. {sendValue} removes this limitation.
257      *
258      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
259      *
260      * IMPORTANT: because control is transferred to `recipient`, care must be
261      * taken to not create reentrancy vulnerabilities. Consider using
262      * {ReentrancyGuard} or the
263      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
264      */
265     function sendValue(address payable recipient, uint256 amount) internal {
266         require(address(this).balance >= amount, "Address: insufficient balance");
267 
268         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
269         (bool success, ) = recipient.call{ value: amount }("");
270         require(success, "Address: unable to send value, recipient may have reverted");
271     }
272 
273     /**
274      * @dev Performs a Solidity function call using a low level `call`. A
275      * plain`call` is an unsafe replacement for a function call: use this
276      * function instead.
277      *
278      * If `target` reverts with a revert reason, it is bubbled up by this
279      * function (like regular Solidity function calls).
280      *
281      * Returns the raw returned data. To convert to the expected return value,
282      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
283      *
284      * Requirements:
285      *
286      * - `target` must be a contract.
287      * - calling `target` with `data` must not revert.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
292       return functionCall(target, data, "Address: low-level call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
297      * `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
302         return _functionCallWithValue(target, data, 0, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but also transferring `value` wei to `target`.
308      *
309      * Requirements:
310      *
311      * - the calling contract must have an ETH balance of at least `value`.
312      * - the called Solidity function must be `payable`.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
322      * with `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
327         require(address(this).balance >= value, "Address: insufficient balance for call");
328         return _functionCallWithValue(target, data, value, errorMessage);
329     }
330 
331     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
332         require(isContract(target), "Address: call to non-contract");
333 
334         // solhint-disable-next-line avoid-low-level-calls
335         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
336         if (success) {
337             return returndata;
338         } else {
339             // Look for revert reason and bubble it up if present
340             if (returndata.length > 0) {
341                 // The easiest way to bubble the revert reason is using memory via assembly
342 
343                 // solhint-disable-next-line no-inline-assembly
344                 assembly {
345                     let returndata_size := mload(returndata)
346                     revert(add(32, returndata), returndata_size)
347                 }
348             } else {
349                 revert(errorMessage);
350             }
351         }
352     }
353 }
354 
355 
356 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
357 
358 pragma solidity ^0.6.0;
359 
360 /**
361  * @dev Interface of the ERC20 standard as defined in the EIP.
362  */
363 interface IERC20 {
364     /**
365      * @dev Returns the amount of tokens in existence.
366      */
367     function totalSupply() external view returns (uint256);
368 
369     /**
370      * @dev Returns the amount of tokens owned by `account`.
371      */
372     function balanceOf(address account) external view returns (uint256);
373 
374     /**
375      * @dev Moves `amount` tokens from the caller's account to `recipient`.
376      *
377      * Returns a boolean value indicating whether the operation succeeded.
378      *
379      * Emits a {Transfer} event.
380      */
381     function transfer(address recipient, uint256 amount) external returns (bool);
382 
383     /**
384      * @dev Returns the remaining number of tokens that `spender` will be
385      * allowed to spend on behalf of `owner` through {transferFrom}. This is
386      * zero by default.
387      *
388      * This value changes when {approve} or {transferFrom} are called.
389      */
390     function allowance(address owner, address spender) external view returns (uint256);
391 
392     /**
393      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
394      *
395      * Returns a boolean value indicating whether the operation succeeded.
396      *
397      * IMPORTANT: Beware that changing an allowance with this method brings the risk
398      * that someone may use both the old and the new allowance by unfortunate
399      * transaction ordering. One possible solution to mitigate this race
400      * condition is to first reduce the spender's allowance to 0 and set the
401      * desired value afterwards:
402      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
403      *
404      * Emits an {Approval} event.
405      */
406     function approve(address spender, uint256 amount) external returns (bool);
407 
408     /**
409      * @dev Moves `amount` tokens from `sender` to `recipient` using the
410      * allowance mechanism. `amount` is then deducted from the caller's
411      * allowance.
412      *
413      * Returns a boolean value indicating whether the operation succeeded.
414      *
415      * Emits a {Transfer} event.
416      */
417     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
418 
419     /**
420      * @dev Emitted when `value` tokens are moved from one account (`from`) to
421      * another (`to`).
422      *
423      * Note that `value` may be zero.
424      */
425     event Transfer(address indexed from, address indexed to, uint256 value);
426 
427     /**
428      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
429      * a call to {approve}. `value` is the new allowance.
430      */
431     event Approval(address indexed owner, address indexed spender, uint256 value);
432 }
433 
434 
435 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
436 
437 pragma solidity ^0.6.0;
438 
439 /**
440  * @title SafeERC20
441  * @dev Wrappers around ERC20 operations that throw on failure (when the token
442  * contract returns false). Tokens that return no value (and instead revert or
443  * throw on failure) are also supported, non-reverting calls are assumed to be
444  * successful.
445  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
446  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
447  */
448 library SafeERC20 {
449     using SafeMath for uint256;
450     using Address for address;
451 
452     function safeTransfer(IERC20 token, address to, uint256 value) internal {
453         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
454     }
455 
456     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
457         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
458     }
459 
460     /**
461      * @dev Deprecated. This function has issues similar to the ones found in
462      * {IERC20-approve}, and its usage is discouraged.
463      *
464      * Whenever possible, use {safeIncreaseAllowance} and
465      * {safeDecreaseAllowance} instead.
466      */
467     function safeApprove(IERC20 token, address spender, uint256 value) internal {
468         // safeApprove should only be called when setting an initial allowance,
469         // or when resetting it to zero. To increase and decrease it, use
470         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
471         // solhint-disable-next-line max-line-length
472         require((value == 0) || (token.allowance(address(this), spender) == 0),
473             "SafeERC20: approve from non-zero to non-zero allowance"
474         );
475         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
476     }
477 
478     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
479         uint256 newAllowance = token.allowance(address(this), spender).add(value);
480         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
481     }
482 
483     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
484         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
485         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
486     }
487 
488     /**
489      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
490      * on the return value: the return value is optional (but if data is returned, it must not be false).
491      * @param token The token targeted by the call.
492      * @param data The call data (encoded using abi.encode or one of its variants).
493      */
494     function _callOptionalReturn(IERC20 token, bytes memory data) private {
495         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
496         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
497         // the target address contains contract code and also asserts for success in the low-level call.
498 
499         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
500         if (returndata.length > 0) { // Return data is optional
501             // solhint-disable-next-line max-line-length
502             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
503         }
504     }
505 }
506 
507 
508 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
509 
510 pragma solidity ^0.6.0;
511 
512 /**
513  * @dev Implementation of the {IERC20} interface.
514  *
515  * This implementation is agnostic to the way tokens are created. This means
516  * that a supply mechanism has to be added in a derived contract using {_mint}.
517  * For a generic mechanism see {ERC20PresetMinterPauser}.
518  *
519  * TIP: For a detailed writeup see our guide
520  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
521  * to implement supply mechanisms].
522  *
523  * We have followed general OpenZeppelin guidelines: functions revert instead
524  * of returning `false` on failure. This behavior is nonetheless conventional
525  * and does not conflict with the expectations of ERC20 applications.
526  *
527  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
528  * This allows applications to reconstruct the allowance for all accounts just
529  * by listening to said events. Other implementations of the EIP may not emit
530  * these events, as it isn't required by the specification.
531  *
532  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
533  * functions have been added to mitigate the well-known issues around setting
534  * allowances. See {IERC20-approve}.
535  */
536 contract ERC20 is Context, IERC20 {
537     using SafeMath for uint256;
538     using Address for address;
539 
540     mapping (address => uint256) private _balances;
541 
542     mapping (address => mapping (address => uint256)) private _allowances;
543 
544     uint256 private _totalSupply;
545 
546     string private _name;
547     string private _symbol;
548     uint8 private _decimals;
549 
550     /**
551      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
552      * a default value of 18.
553      *
554      * To select a different value for {decimals}, use {_setupDecimals}.
555      *
556      * All three of these values are immutable: they can only be set once during
557      * construction.
558      */
559     constructor (string memory name, string memory symbol) public {
560         _name = name;
561         _symbol = symbol;
562         _decimals = 18;
563     }
564 
565     /**
566      * @dev Returns the name of the token.
567      */
568     function name() public view returns (string memory) {
569         return _name;
570     }
571 
572     /**
573      * @dev Returns the symbol of the token, usually a shorter version of the
574      * name.
575      */
576     function symbol() public view returns (string memory) {
577         return _symbol;
578     }
579 
580     /**
581      * @dev Returns the number of decimals used to get its user representation.
582      * For example, if `decimals` equals `2`, a balance of `505` tokens should
583      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
584      *
585      * Tokens usually opt for a value of 18, imitating the relationship between
586      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
587      * called.
588      *
589      * NOTE: This information is only used for _display_ purposes: it in
590      * no way affects any of the arithmetic of the contract, including
591      * {IERC20-balanceOf} and {IERC20-transfer}.
592      */
593     function decimals() public view returns (uint8) {
594         return _decimals;
595     }
596 
597     /**
598      * @dev See {IERC20-totalSupply}.
599      */
600     function totalSupply() public view override returns (uint256) {
601         return _totalSupply;
602     }
603 
604     /**
605      * @dev See {IERC20-balanceOf}.
606      */
607     function balanceOf(address account) public view override returns (uint256) {
608         return _balances[account];
609     }
610 
611     /**
612      * @dev See {IERC20-transfer}.
613      *
614      * Requirements:
615      *
616      * - `recipient` cannot be the zero address.
617      * - the caller must have a balance of at least `amount`.
618      */
619     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
620         _transfer(_msgSender(), recipient, amount);
621         return true;
622     }
623 
624     /**
625      * @dev See {IERC20-allowance}.
626      */
627     function allowance(address owner, address spender) public view virtual override returns (uint256) {
628         return _allowances[owner][spender];
629     }
630 
631     /**
632      * @dev See {IERC20-approve}.
633      *
634      * Requirements:
635      *
636      * - `spender` cannot be the zero address.
637      */
638     function approve(address spender, uint256 amount) public virtual override returns (bool) {
639         _approve(_msgSender(), spender, amount);
640         return true;
641     }
642 
643     /**
644      * @dev See {IERC20-transferFrom}.
645      *
646      * Emits an {Approval} event indicating the updated allowance. This is not
647      * required by the EIP. See the note at the beginning of {ERC20};
648      *
649      * Requirements:
650      * - `sender` and `recipient` cannot be the zero address.
651      * - `sender` must have a balance of at least `amount`.
652      * - the caller must have allowance for ``sender``'s tokens of at least
653      * `amount`.
654      */
655     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
656         _transfer(sender, recipient, amount);
657         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
658         return true;
659     }
660 
661     /**
662      * @dev Atomically increases the allowance granted to `spender` by the caller.
663      *
664      * This is an alternative to {approve} that can be used as a mitigation for
665      * problems described in {IERC20-approve}.
666      *
667      * Emits an {Approval} event indicating the updated allowance.
668      *
669      * Requirements:
670      *
671      * - `spender` cannot be the zero address.
672      */
673     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
674         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
675         return true;
676     }
677 
678     /**
679      * @dev Atomically decreases the allowance granted to `spender` by the caller.
680      *
681      * This is an alternative to {approve} that can be used as a mitigation for
682      * problems described in {IERC20-approve}.
683      *
684      * Emits an {Approval} event indicating the updated allowance.
685      *
686      * Requirements:
687      *
688      * - `spender` cannot be the zero address.
689      * - `spender` must have allowance for the caller of at least
690      * `subtractedValue`.
691      */
692     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
693         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
694         return true;
695     }
696 
697     /**
698      * @dev Moves tokens `amount` from `sender` to `recipient`.
699      *
700      * This is internal function is equivalent to {transfer}, and can be used to
701      * e.g. implement automatic token fees, slashing mechanisms, etc.
702      *
703      * Emits a {Transfer} event.
704      *
705      * Requirements:
706      *
707      * - `sender` cannot be the zero address.
708      * - `recipient` cannot be the zero address.
709      * - `sender` must have a balance of at least `amount`.
710      */
711     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
712         require(sender != address(0), "ERC20: transfer from the zero address");
713         require(recipient != address(0), "ERC20: transfer to the zero address");
714 
715         _beforeTokenTransfer(sender, recipient, amount);
716 
717         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
718         _balances[recipient] = _balances[recipient].add(amount);
719         emit Transfer(sender, recipient, amount);
720     }
721 
722     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
723      * the total supply.
724      *
725      * Emits a {Transfer} event with `from` set to the zero address.
726      *
727      * Requirements
728      *
729      * - `to` cannot be the zero address.
730      */
731     function _mint(address account, uint256 amount) internal virtual {
732         require(account != address(0), "ERC20: mint to the zero address");
733 
734         _beforeTokenTransfer(address(0), account, amount);
735 
736         _totalSupply = _totalSupply.add(amount);
737         _balances[account] = _balances[account].add(amount);
738         emit Transfer(address(0), account, amount);
739     }
740 
741     /**
742      * @dev Destroys `amount` tokens from `account`, reducing the
743      * total supply.
744      *
745      * Emits a {Transfer} event with `to` set to the zero address.
746      *
747      * Requirements
748      *
749      * - `account` cannot be the zero address.
750      * - `account` must have at least `amount` tokens.
751      */
752     function _burn(address account, uint256 amount) internal virtual {
753         require(account != address(0), "ERC20: burn from the zero address");
754 
755         _beforeTokenTransfer(account, address(0), amount);
756 
757         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
758         _totalSupply = _totalSupply.sub(amount);
759         emit Transfer(account, address(0), amount);
760     }
761 
762     /**
763      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
764      *
765      * This internal function is equivalent to `approve`, and can be used to
766      * e.g. set automatic allowances for certain subsystems, etc.
767      *
768      * Emits an {Approval} event.
769      *
770      * Requirements:
771      *
772      * - `owner` cannot be the zero address.
773      * - `spender` cannot be the zero address.
774      */
775     function _approve(address owner, address spender, uint256 amount) internal virtual {
776         require(owner != address(0), "ERC20: approve from the zero address");
777         require(spender != address(0), "ERC20: approve to the zero address");
778 
779         _allowances[owner][spender] = amount;
780         emit Approval(owner, spender, amount);
781     }
782 
783     /**
784      * @dev Sets {decimals} to a value other than the default one of 18.
785      *
786      * WARNING: This function should only be called from the constructor. Most
787      * applications that interact with token contracts will not expect
788      * {decimals} to ever change, and may work incorrectly if it does.
789      */
790     function _setupDecimals(uint8 decimals_) internal {
791         _decimals = decimals_;
792     }
793 
794     /**
795      * @dev Hook that is called before any transfer of tokens. This includes
796      * minting and burning.
797      *
798      * Calling conditions:
799      *
800      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
801      * will be to transferred to `to`.
802      * - when `from` is zero, `amount` tokens will be minted for `to`.
803      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
804      * - `from` and `to` are never both zero.
805      *
806      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
807      */
808     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
809 }
810 
811 
812 
813 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
814 
815 pragma solidity ^0.6.0;
816 
817 /**
818  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
819  */
820 abstract contract ERC20Capped is ERC20 {
821     uint256 private _cap;
822 
823     /**
824      * @dev Sets the value of the `cap`. This value is immutable, it can only be
825      * set once during construction.
826      */
827     constructor (uint256 cap) public {
828         require(cap > 0, "ERC20Capped: cap is 0");
829         _cap = cap;
830     }
831 
832     /**
833      * @dev Returns the cap on the token's total supply.
834      */
835     function cap() public view returns (uint256) {
836         return _cap;
837     }
838 
839     /**
840      * @dev See {ERC20-_beforeTokenTransfer}.
841      *
842      * Requirements:
843      *
844      * - minted tokens must not cause the total supply to go over the cap.
845      */
846     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
847         super._beforeTokenTransfer(from, to, amount);
848 
849         if (from == address(0)) { // When minting tokens
850             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
851         }
852     }
853 }
854 
855 
856 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
857 
858 pragma solidity ^0.6.0;
859 
860 /**
861  * @dev Extension of {ERC20} that allows token holders to destroy both their own
862  * tokens and those that they have an allowance for, in a way that can be
863  * recognized off-chain (via event analysis).
864  */
865 abstract contract ERC20Burnable is Context, ERC20 {
866     /**
867      * @dev Destroys `amount` tokens from the caller.
868      *
869      * See {ERC20-_burn}.
870      */
871     function burn(uint256 amount) public virtual {
872         _burn(_msgSender(), amount);
873     }
874 
875     /**
876      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
877      * allowance.
878      *
879      * See {ERC20-_burn} and {ERC20-allowance}.
880      *
881      * Requirements:
882      *
883      * - the caller must have allowance for ``accounts``'s tokens of at least
884      * `amount`.
885      */
886     function burnFrom(address account, uint256 amount) public virtual {
887         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
888 
889         _approve(account, _msgSender(), decreasedAllowance);
890         _burn(account, amount);
891     }
892 }
893 
894 
895 
896 // File: FotoToken.sol
897 
898 pragma solidity ^0.6.2;
899 
900 contract FotoToken is ERC20Capped, ERC20Burnable {
901     using SafeERC20 for IERC20;
902     using Address for address;
903     using SafeMath for uint;
904 
905     address public governance;
906     mapping (address => bool) public minters;
907 
908     constructor()
909         public
910         ERC20('FOTO', 'FOTO')
911         ERC20Capped(100000000000000000000000000)   // Cap at 100 mil token
912         { 
913             governance = msg.sender;
914         }
915 
916     function mint(address account, uint256 amount) public {
917         require(minters[msg.sender], "!minter");
918         _mint(account, amount);
919     }
920 
921     function setGovernance(address _governance) public {
922         require(msg.sender == governance, "!governance");
923         governance = _governance;
924     }
925 
926     function addMinter(address _minter) public {
927         require(msg.sender == governance, "!governance");
928         minters[_minter] = true;
929     }
930 
931     function removeMinter(address _minter) public {
932         require(msg.sender == governance, "!governance");
933         minters[_minter] = false;
934     }
935     
936     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override (ERC20, ERC20Capped) {
937         ERC20Capped._beforeTokenTransfer(from, to, amount);
938 
939     }    
940 
941 }