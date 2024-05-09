1 /* website: padthai.finance
2 **
3 **    ▄███████▄    ▄████████ ████████▄      ███        ▄█    █▄       ▄████████  ▄█
4 **   ███    ███   ███    ███ ███   ▀███ ▀█████████▄   ███    ███     ███    ███ ███
5 **   ███    ███   ███    ███ ███    ███    ▀███▀▀██   ███    ███     ███    ███ ███▌
6 **   ███    ███   ███    ███ ███    ███     ███   ▀  ▄███▄▄▄▄███▄▄   ███    ███ ███▌
7 ** ▀█████████▀  ▀███████████ ███    ███     ███     ▀▀███▀▀▀▀███▀  ▀███████████ ███▌
8 **   ███          ███    ███ ███    ███     ███       ███    ███     ███    ███ ███
9 **   ███          ███    ███ ███   ▄███     ███       ███    ███     ███    ███ ███
10 **  ▄████▀        ███    █▀  ████████▀     ▄████▀     ███    █▀      ███    █▀  █▀
11 **
12  */
13 
14 // File: @openzeppelin/contracts/GSN/Context.sol
15 
16 
17 pragma solidity ^0.6.0;
18 
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
40 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
41 
42 
43 pragma solidity ^0.6.0;
44 
45 /**
46  * @dev Interface of the ERC20 standard as defined in the EIP.
47  */
48 interface IERC20 {
49     /**
50      * @dev Returns the amount of tokens in existence.
51      */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55      * @dev Returns the amount of tokens owned by `account`.
56      */
57     function balanceOf(address account) external view returns (uint256);
58 
59     /**
60      * @dev Moves `amount` tokens from the caller's account to `recipient`.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Returns the remaining number of tokens that `spender` will be
70      * allowed to spend on behalf of `owner` through {transferFrom}. This is
71      * zero by default.
72      *
73      * This value changes when {approve} or {transferFrom} are called.
74      */
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     /**
78      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * IMPORTANT: Beware that changing an allowance with this method brings the risk
83      * that someone may use both the old and the new allowance by unfortunate
84      * transaction ordering. One possible solution to mitigate this race
85      * condition is to first reduce the spender's allowance to 0 and set the
86      * desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      *
89      * Emits an {Approval} event.
90      */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Moves `amount` tokens from `sender` to `recipient` using the
95      * allowance mechanism. `amount` is then deducted from the caller's
96      * allowance.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Emitted when `value` tokens are moved from one account (`from`) to
106      * another (`to`).
107      *
108      * Note that `value` may be zero.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114      * a call to {approve}. `value` is the new allowance.
115      */
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 // File: @openzeppelin/contracts/math/SafeMath.sol
120 
121 
122 pragma solidity ^0.6.0;
123 
124 /**
125  * @dev Wrappers over Solidity's arithmetic operations with added overflow
126  * checks.
127  *
128  * Arithmetic operations in Solidity wrap on overflow. This can easily result
129  * in bugs, because programmers usually assume that an overflow raises an
130  * error, which is the standard behavior in high level programming languages.
131  * `SafeMath` restores this intuition by reverting the transaction when an
132  * operation overflows.
133  *
134  * Using this library instead of the unchecked operations eliminates an entire
135  * class of bugs, so it's recommended to use it always.
136  */
137 library SafeMath {
138     /**
139      * @dev Returns the addition of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `+` operator.
143      *
144      * Requirements:
145      *
146      * - Addition cannot overflow.
147      */
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149         uint256 c = a + b;
150         require(c >= a, "SafeMath: addition overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180         require(b <= a, errorMessage);
181         uint256 c = a - b;
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the multiplication of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `*` operator.
191      *
192      * Requirements:
193      *
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
198         // benefit is lost if 'b' is also tested.
199         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
200         if (a == 0) {
201             return 0;
202         }
203 
204         uint256 c = a * b;
205         require(c / a == b, "SafeMath: multiplication overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         return div(a, b, "SafeMath: division by zero");
224     }
225 
226     /**
227      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
228      * division by zero. The result is rounded towards zero.
229      *
230      * Counterpart to Solidity's `/` operator. Note: this function uses a
231      * `revert` opcode (which leaves remaining gas untouched) while Solidity
232      * uses an invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b > 0, errorMessage);
240         uint256 c = a / b;
241         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return mod(a, b, "SafeMath: modulo by zero");
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts with custom message when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
275         require(b != 0, errorMessage);
276         return a % b;
277     }
278 }
279 
280 // File: @openzeppelin/contracts/utils/Address.sol
281 
282 
283 pragma solidity ^0.6.2;
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * [IMPORTANT]
293      * ====
294      * It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      *
297      * Among others, `isContract` will return false for the following
298      * types of addresses:
299      *
300      *  - an externally-owned account
301      *  - a contract in construction
302      *  - an address where a contract will be created
303      *  - an address where a contract lived, but was destroyed
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
308         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
309         // for accounts without code, i.e. `keccak256('')`
310         bytes32 codehash;
311         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
312         // solhint-disable-next-line no-inline-assembly
313         assembly { codehash := extcodehash(account) }
314         return (codehash != accountHash && codehash != 0x0);
315     }
316 
317     /**
318      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
319      * `recipient`, forwarding all available gas and reverting on errors.
320      *
321      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
322      * of certain opcodes, possibly making contracts go over the 2300 gas limit
323      * imposed by `transfer`, making them unable to receive funds via
324      * `transfer`. {sendValue} removes this limitation.
325      *
326      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
327      *
328      * IMPORTANT: because control is transferred to `recipient`, care must be
329      * taken to not create reentrancy vulnerabilities. Consider using
330      * {ReentrancyGuard} or the
331      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(address(this).balance >= amount, "Address: insufficient balance");
335 
336         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
337         (bool success, ) = recipient.call{ value: amount }("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain`call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
360       return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
370         return _functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
390      * with `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
395         require(address(this).balance >= value, "Address: insufficient balance for call");
396         return _functionCallWithValue(target, data, value, errorMessage);
397     }
398 
399     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
400         require(isContract(target), "Address: call to non-contract");
401 
402         // solhint-disable-next-line avoid-low-level-calls
403         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 // solhint-disable-next-line no-inline-assembly
412                 assembly {
413                     let returndata_size := mload(returndata)
414                     revert(add(32, returndata), returndata_size)
415                 }
416             } else {
417                 revert(errorMessage);
418             }
419         }
420     }
421 }
422 
423 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
424 
425 
426 pragma solidity ^0.6.0;
427 
428 
429 
430 
431 
432 /**
433  * @dev Implementation of the {IERC20} interface.
434  *
435  * This implementation is agnostic to the way tokens are created. This means
436  * that a supply mechanism has to be added in a derived contract using {_mint}.
437  * For a generic mechanism see {ERC20PresetMinterPauser}.
438  *
439  * TIP: For a detailed writeup see our guide
440  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
441  * to implement supply mechanisms].
442  *
443  * We have followed general OpenZeppelin guidelines: functions revert instead
444  * of returning `false` on failure. This behavior is nonetheless conventional
445  * and does not conflict with the expectations of ERC20 applications.
446  *
447  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
448  * This allows applications to reconstruct the allowance for all accounts just
449  * by listening to said events. Other implementations of the EIP may not emit
450  * these events, as it isn't required by the specification.
451  *
452  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
453  * functions have been added to mitigate the well-known issues around setting
454  * allowances. See {IERC20-approve}.
455  */
456 contract ERC20 is Context, IERC20 {
457     using SafeMath for uint256;
458     using Address for address;
459 
460     mapping (address => uint256) private _balances;
461 
462     mapping (address => mapping (address => uint256)) private _allowances;
463 
464     uint256 private _totalSupply;
465 
466     string private _name;
467     string private _symbol;
468     uint8 private _decimals;
469 
470     /**
471      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
472      * a default value of 18.
473      *
474      * To select a different value for {decimals}, use {_setupDecimals}.
475      *
476      * All three of these values are immutable: they can only be set once during
477      * construction.
478      */
479     constructor (string memory name, string memory symbol) public {
480         _name = name;
481         _symbol = symbol;
482         _decimals = 18;
483     }
484 
485     /**
486      * @dev Returns the name of the token.
487      */
488     function name() public view returns (string memory) {
489         return _name;
490     }
491 
492     /**
493      * @dev Returns the symbol of the token, usually a shorter version of the
494      * name.
495      */
496     function symbol() public view returns (string memory) {
497         return _symbol;
498     }
499 
500     /**
501      * @dev Returns the number of decimals used to get its user representation.
502      * For example, if `decimals` equals `2`, a balance of `505` tokens should
503      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
504      *
505      * Tokens usually opt for a value of 18, imitating the relationship between
506      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
507      * called.
508      *
509      * NOTE: This information is only used for _display_ purposes: it in
510      * no way affects any of the arithmetic of the contract, including
511      * {IERC20-balanceOf} and {IERC20-transfer}.
512      */
513     function decimals() public view returns (uint8) {
514         return _decimals;
515     }
516 
517     /**
518      * @dev See {IERC20-totalSupply}.
519      */
520     function totalSupply() public view override returns (uint256) {
521         return _totalSupply;
522     }
523 
524     /**
525      * @dev See {IERC20-balanceOf}.
526      */
527     function balanceOf(address account) public view override returns (uint256) {
528         return _balances[account];
529     }
530 
531     /**
532      * @dev See {IERC20-transfer}.
533      *
534      * Requirements:
535      *
536      * - `recipient` cannot be the zero address.
537      * - the caller must have a balance of at least `amount`.
538      */
539     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
540         _transfer(_msgSender(), recipient, amount);
541         return true;
542     }
543 
544     /**
545      * @dev See {IERC20-allowance}.
546      */
547     function allowance(address owner, address spender) public view virtual override returns (uint256) {
548         return _allowances[owner][spender];
549     }
550 
551     /**
552      * @dev See {IERC20-approve}.
553      *
554      * Requirements:
555      *
556      * - `spender` cannot be the zero address.
557      */
558     function approve(address spender, uint256 amount) public virtual override returns (bool) {
559         _approve(_msgSender(), spender, amount);
560         return true;
561     }
562 
563     /**
564      * @dev See {IERC20-transferFrom}.
565      *
566      * Emits an {Approval} event indicating the updated allowance. This is not
567      * required by the EIP. See the note at the beginning of {ERC20};
568      *
569      * Requirements:
570      * - `sender` and `recipient` cannot be the zero address.
571      * - `sender` must have a balance of at least `amount`.
572      * - the caller must have allowance for ``sender``'s tokens of at least
573      * `amount`.
574      */
575     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
576         _transfer(sender, recipient, amount);
577         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
578         return true;
579     }
580 
581     /**
582      * @dev Atomically increases the allowance granted to `spender` by the caller.
583      *
584      * This is an alternative to {approve} that can be used as a mitigation for
585      * problems described in {IERC20-approve}.
586      *
587      * Emits an {Approval} event indicating the updated allowance.
588      *
589      * Requirements:
590      *
591      * - `spender` cannot be the zero address.
592      */
593     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
594         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
595         return true;
596     }
597 
598     /**
599      * @dev Atomically decreases the allowance granted to `spender` by the caller.
600      *
601      * This is an alternative to {approve} that can be used as a mitigation for
602      * problems described in {IERC20-approve}.
603      *
604      * Emits an {Approval} event indicating the updated allowance.
605      *
606      * Requirements:
607      *
608      * - `spender` cannot be the zero address.
609      * - `spender` must have allowance for the caller of at least
610      * `subtractedValue`.
611      */
612     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
613         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
614         return true;
615     }
616 
617     /**
618      * @dev Moves tokens `amount` from `sender` to `recipient`.
619      *
620      * This is internal function is equivalent to {transfer}, and can be used to
621      * e.g. implement automatic token fees, slashing mechanisms, etc.
622      *
623      * Emits a {Transfer} event.
624      *
625      * Requirements:
626      *
627      * - `sender` cannot be the zero address.
628      * - `recipient` cannot be the zero address.
629      * - `sender` must have a balance of at least `amount`.
630      */
631     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
632         require(sender != address(0), "ERC20: transfer from the zero address");
633         require(recipient != address(0), "ERC20: transfer to the zero address");
634 
635         _beforeTokenTransfer(sender, recipient, amount);
636 
637         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
638         _balances[recipient] = _balances[recipient].add(amount);
639         emit Transfer(sender, recipient, amount);
640     }
641 
642     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
643      * the total supply.
644      *
645      * Emits a {Transfer} event with `from` set to the zero address.
646      *
647      * Requirements
648      *
649      * - `to` cannot be the zero address.
650      */
651     function _mint(address account, uint256 amount) internal virtual {
652         require(account != address(0), "ERC20: mint to the zero address");
653 
654         _beforeTokenTransfer(address(0), account, amount);
655 
656         _totalSupply = _totalSupply.add(amount);
657         _balances[account] = _balances[account].add(amount);
658         emit Transfer(address(0), account, amount);
659     }
660 
661     /**
662      * @dev Destroys `amount` tokens from `account`, reducing the
663      * total supply.
664      *
665      * Emits a {Transfer} event with `to` set to the zero address.
666      *
667      * Requirements
668      *
669      * - `account` cannot be the zero address.
670      * - `account` must have at least `amount` tokens.
671      */
672     function _burn(address account, uint256 amount) internal virtual {
673         require(account != address(0), "ERC20: burn from the zero address");
674 
675         _beforeTokenTransfer(account, address(0), amount);
676 
677         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
678         _totalSupply = _totalSupply.sub(amount);
679         emit Transfer(account, address(0), amount);
680     }
681 
682     /**
683      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
684      *
685      * This is internal function is equivalent to `approve`, and can be used to
686      * e.g. set automatic allowances for certain subsystems, etc.
687      *
688      * Emits an {Approval} event.
689      *
690      * Requirements:
691      *
692      * - `owner` cannot be the zero address.
693      * - `spender` cannot be the zero address.
694      */
695     function _approve(address owner, address spender, uint256 amount) internal virtual {
696         require(owner != address(0), "ERC20: approve from the zero address");
697         require(spender != address(0), "ERC20: approve to the zero address");
698 
699         _allowances[owner][spender] = amount;
700         emit Approval(owner, spender, amount);
701     }
702 
703     /**
704      * @dev Sets {decimals} to a value other than the default one of 18.
705      *
706      * WARNING: This function should only be called from the constructor. Most
707      * applications that interact with token contracts will not expect
708      * {decimals} to ever change, and may work incorrectly if it does.
709      */
710     function _setupDecimals(uint8 decimals_) internal {
711         _decimals = decimals_;
712     }
713 
714     /**
715      * @dev Hook that is called before any transfer of tokens. This includes
716      * minting and burning.
717      *
718      * Calling conditions:
719      *
720      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
721      * will be to transferred to `to`.
722      * - when `from` is zero, `amount` tokens will be minted for `to`.
723      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
724      * - `from` and `to` are never both zero.
725      *
726      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
727      */
728     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
729 }
730 
731 // File: @openzeppelin/contracts/access/Ownable.sol
732 
733 
734 pragma solidity ^0.6.0;
735 
736 /**
737  * @dev Contract module which provides a basic access control mechanism, where
738  * there is an account (an owner) that can be granted exclusive access to
739  * specific functions.
740  *
741  * By default, the owner account will be the one that deploys the contract. This
742  * can later be changed with {transferOwnership}.
743  *
744  * This module is used through inheritance. It will make available the modifier
745  * `onlyOwner`, which can be applied to your functions to restrict their use to
746  * the owner.
747  */
748 contract Ownable is Context {
749     address private _owner;
750 
751     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
752 
753     /**
754      * @dev Initializes the contract setting the deployer as the initial owner.
755      */
756     constructor () internal {
757         address msgSender = _msgSender();
758         _owner = msgSender;
759         emit OwnershipTransferred(address(0), msgSender);
760     }
761 
762     /**
763      * @dev Returns the address of the current owner.
764      */
765     function owner() public view returns (address) {
766         return _owner;
767     }
768 
769     /**
770      * @dev Throws if called by any account other than the owner.
771      */
772     modifier onlyOwner() {
773         require(_owner == _msgSender(), "Ownable: caller is not the owner");
774         _;
775     }
776 
777     /**
778      * @dev Leaves the contract without owner. It will not be possible to call
779      * `onlyOwner` functions anymore. Can only be called by the current owner.
780      *
781      * NOTE: Renouncing ownership will leave the contract without an owner,
782      * thereby removing any functionality that is only available to the owner.
783      */
784     function renounceOwnership() public virtual onlyOwner {
785         emit OwnershipTransferred(_owner, address(0));
786         _owner = address(0);
787     }
788 
789     /**
790      * @dev Transfers ownership of the contract to a new account (`newOwner`).
791      * Can only be called by the current owner.
792      */
793     function transferOwnership(address newOwner) public virtual onlyOwner {
794         require(newOwner != address(0), "Ownable: new owner is the zero address");
795         emit OwnershipTransferred(_owner, newOwner);
796         _owner = newOwner;
797     }
798 }
799 
800 // File: contracts/PadThaiToken.sol
801 
802 pragma solidity 0.6.12;
803 
804 
805 
806 contract PadThaiToken is ERC20("padthai.finance", "PADTHAI"), Ownable {
807     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (PadThaiChef).
808     function mint(address _to, uint256 _amount) public onlyOwner {
809         _mint(_to, _amount);
810     }
811 }