1 // https://tornado.cash
2 /*
3 * d888888P                                           dP              a88888b.                   dP
4 *    88                                              88             d8'   `88                   88
5 *    88    .d8888b. 88d888b. 88d888b. .d8888b. .d888b88 .d8888b.    88        .d8888b. .d8888b. 88d888b.
6 *    88    88'  `88 88'  `88 88'  `88 88'  `88 88'  `88 88'  `88    88        88'  `88 Y8ooooo. 88'  `88
7 *    88    88.  .88 88       88    88 88.  .88 88.  .88 88.  .88 dP Y8.   .88 88.  .88       88 88    88
8 *    dP    `88888P' dP       dP    dP `88888P8 `88888P8 `88888P' 88  Y88888P' `88888P8 `88888P' dP    dP
9 * ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
10 */
11 
12 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity ^0.6.0;
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 // File: @openzeppelin/contracts/GSN/Context.sol
93 
94 
95 
96 pragma solidity ^0.6.0;
97 
98 /*
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with GSN meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 abstract contract Context {
109     function _msgSender() internal view virtual returns (address payable) {
110         return msg.sender;
111     }
112 
113     function _msgData() internal view virtual returns (bytes memory) {
114         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
115         return msg.data;
116     }
117 }
118 
119 // File: @openzeppelin/contracts/math/SafeMath.sol
120 
121 
122 
123 pragma solidity ^0.6.0;
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      *
147      * - Addition cannot overflow.
148      */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, "SafeMath: addition overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         return sub(a, b, "SafeMath: subtraction overflow");
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b <= a, errorMessage);
182         uint256 c = a - b;
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      *
195      * - Multiplication cannot overflow.
196      */
197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
199         // benefit is lost if 'b' is also tested.
200         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
201         if (a == 0) {
202             return 0;
203         }
204 
205         uint256 c = a * b;
206         require(c / a == b, "SafeMath: multiplication overflow");
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b) internal pure returns (uint256) {
224         return div(a, b, "SafeMath: division by zero");
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator. Note: this function uses a
232      * `revert` opcode (which leaves remaining gas untouched) while Solidity
233      * uses an invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b > 0, errorMessage);
241         uint256 c = a / b;
242         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         return mod(a, b, "SafeMath: modulo by zero");
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * Reverts with custom message when dividing by zero.
266      *
267      * Counterpart to Solidity's `%` operator. This function uses a `revert`
268      * opcode (which leaves remaining gas untouched) while Solidity uses an
269      * invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b != 0, errorMessage);
277         return a % b;
278     }
279 }
280 
281 // File: @openzeppelin/contracts/utils/Address.sol
282 
283 
284 
285 pragma solidity ^0.6.2;
286 
287 /**
288  * @dev Collection of functions related to the address type
289  */
290 library Address {
291     /**
292      * @dev Returns true if `account` is a contract.
293      *
294      * [IMPORTANT]
295      * ====
296      * It is unsafe to assume that an address for which this function returns
297      * false is an externally-owned account (EOA) and not a contract.
298      *
299      * Among others, `isContract` will return false for the following
300      * types of addresses:
301      *
302      *  - an externally-owned account
303      *  - a contract in construction
304      *  - an address where a contract will be created
305      *  - an address where a contract lived, but was destroyed
306      * ====
307      */
308     function isContract(address account) internal view returns (bool) {
309         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
310         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
311         // for accounts without code, i.e. `keccak256('')`
312         bytes32 codehash;
313         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
314         // solhint-disable-next-line no-inline-assembly
315         assembly { codehash := extcodehash(account) }
316         return (codehash != accountHash && codehash != 0x0);
317     }
318 
319     /**
320      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
321      * `recipient`, forwarding all available gas and reverting on errors.
322      *
323      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
324      * of certain opcodes, possibly making contracts go over the 2300 gas limit
325      * imposed by `transfer`, making them unable to receive funds via
326      * `transfer`. {sendValue} removes this limitation.
327      *
328      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
329      *
330      * IMPORTANT: because control is transferred to `recipient`, care must be
331      * taken to not create reentrancy vulnerabilities. Consider using
332      * {ReentrancyGuard} or the
333      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
334      */
335     function sendValue(address payable recipient, uint256 amount) internal {
336         require(address(this).balance >= amount, "Address: insufficient balance");
337 
338         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
339         (bool success, ) = recipient.call{ value: amount }("");
340         require(success, "Address: unable to send value, recipient may have reverted");
341     }
342 
343     /**
344      * @dev Performs a Solidity function call using a low level `call`. A
345      * plain`call` is an unsafe replacement for a function call: use this
346      * function instead.
347      *
348      * If `target` reverts with a revert reason, it is bubbled up by this
349      * function (like regular Solidity function calls).
350      *
351      * Returns the raw returned data. To convert to the expected return value,
352      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
353      *
354      * Requirements:
355      *
356      * - `target` must be a contract.
357      * - calling `target` with `data` must not revert.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
362       return functionCall(target, data, "Address: low-level call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
367      * `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
372         return _functionCallWithValue(target, data, 0, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but also transferring `value` wei to `target`.
378      *
379      * Requirements:
380      *
381      * - the calling contract must have an ETH balance of at least `value`.
382      * - the called Solidity function must be `payable`.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
392      * with `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
397         require(address(this).balance >= value, "Address: insufficient balance for call");
398         return _functionCallWithValue(target, data, value, errorMessage);
399     }
400 
401     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
402         require(isContract(target), "Address: call to non-contract");
403 
404         // solhint-disable-next-line avoid-low-level-calls
405         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
406         if (success) {
407             return returndata;
408         } else {
409             // Look for revert reason and bubble it up if present
410             if (returndata.length > 0) {
411                 // The easiest way to bubble the revert reason is using memory via assembly
412 
413                 // solhint-disable-next-line no-inline-assembly
414                 assembly {
415                     let returndata_size := mload(returndata)
416                     revert(add(32, returndata), returndata_size)
417                 }
418             } else {
419                 revert(errorMessage);
420             }
421         }
422     }
423 }
424 
425 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
426 
427 
428 
429 pragma solidity ^0.6.0;
430 
431 
432 
433 
434 
435 /**
436  * @dev Implementation of the {IERC20} interface.
437  *
438  * This implementation is agnostic to the way tokens are created. This means
439  * that a supply mechanism has to be added in a derived contract using {_mint}.
440  * For a generic mechanism see {ERC20PresetMinterPauser}.
441  *
442  * TIP: For a detailed writeup see our guide
443  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
444  * to implement supply mechanisms].
445  *
446  * We have followed general OpenZeppelin guidelines: functions revert instead
447  * of returning `false` on failure. This behavior is nonetheless conventional
448  * and does not conflict with the expectations of ERC20 applications.
449  *
450  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
451  * This allows applications to reconstruct the allowance for all accounts just
452  * by listening to said events. Other implementations of the EIP may not emit
453  * these events, as it isn't required by the specification.
454  *
455  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
456  * functions have been added to mitigate the well-known issues around setting
457  * allowances. See {IERC20-approve}.
458  */
459 contract ERC20 is Context, IERC20 {
460     using SafeMath for uint256;
461     using Address for address;
462 
463     mapping (address => uint256) private _balances;
464 
465     mapping (address => mapping (address => uint256)) private _allowances;
466 
467     uint256 private _totalSupply;
468 
469     string private _name;
470     string private _symbol;
471     uint8 private _decimals;
472 
473     /**
474      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
475      * a default value of 18.
476      *
477      * To select a different value for {decimals}, use {_setupDecimals}.
478      *
479      * All three of these values are immutable: they can only be set once during
480      * construction.
481      */
482     constructor (string memory name, string memory symbol) public {
483         _name = name;
484         _symbol = symbol;
485         _decimals = 18;
486     }
487 
488     /**
489      * @dev Returns the name of the token.
490      */
491     function name() public view returns (string memory) {
492         return _name;
493     }
494 
495     /**
496      * @dev Returns the symbol of the token, usually a shorter version of the
497      * name.
498      */
499     function symbol() public view returns (string memory) {
500         return _symbol;
501     }
502 
503     /**
504      * @dev Returns the number of decimals used to get its user representation.
505      * For example, if `decimals` equals `2`, a balance of `505` tokens should
506      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
507      *
508      * Tokens usually opt for a value of 18, imitating the relationship between
509      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
510      * called.
511      *
512      * NOTE: This information is only used for _display_ purposes: it in
513      * no way affects any of the arithmetic of the contract, including
514      * {IERC20-balanceOf} and {IERC20-transfer}.
515      */
516     function decimals() public view returns (uint8) {
517         return _decimals;
518     }
519 
520     /**
521      * @dev See {IERC20-totalSupply}.
522      */
523     function totalSupply() public view override returns (uint256) {
524         return _totalSupply;
525     }
526 
527     /**
528      * @dev See {IERC20-balanceOf}.
529      */
530     function balanceOf(address account) public view override returns (uint256) {
531         return _balances[account];
532     }
533 
534     /**
535      * @dev See {IERC20-transfer}.
536      *
537      * Requirements:
538      *
539      * - `recipient` cannot be the zero address.
540      * - the caller must have a balance of at least `amount`.
541      */
542     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
543         _transfer(_msgSender(), recipient, amount);
544         return true;
545     }
546 
547     /**
548      * @dev See {IERC20-allowance}.
549      */
550     function allowance(address owner, address spender) public view virtual override returns (uint256) {
551         return _allowances[owner][spender];
552     }
553 
554     /**
555      * @dev See {IERC20-approve}.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      */
561     function approve(address spender, uint256 amount) public virtual override returns (bool) {
562         _approve(_msgSender(), spender, amount);
563         return true;
564     }
565 
566     /**
567      * @dev See {IERC20-transferFrom}.
568      *
569      * Emits an {Approval} event indicating the updated allowance. This is not
570      * required by the EIP. See the note at the beginning of {ERC20};
571      *
572      * Requirements:
573      * - `sender` and `recipient` cannot be the zero address.
574      * - `sender` must have a balance of at least `amount`.
575      * - the caller must have allowance for ``sender``'s tokens of at least
576      * `amount`.
577      */
578     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
579         _transfer(sender, recipient, amount);
580         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
581         return true;
582     }
583 
584     /**
585      * @dev Atomically increases the allowance granted to `spender` by the caller.
586      *
587      * This is an alternative to {approve} that can be used as a mitigation for
588      * problems described in {IERC20-approve}.
589      *
590      * Emits an {Approval} event indicating the updated allowance.
591      *
592      * Requirements:
593      *
594      * - `spender` cannot be the zero address.
595      */
596     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
597         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
598         return true;
599     }
600 
601     /**
602      * @dev Atomically decreases the allowance granted to `spender` by the caller.
603      *
604      * This is an alternative to {approve} that can be used as a mitigation for
605      * problems described in {IERC20-approve}.
606      *
607      * Emits an {Approval} event indicating the updated allowance.
608      *
609      * Requirements:
610      *
611      * - `spender` cannot be the zero address.
612      * - `spender` must have allowance for the caller of at least
613      * `subtractedValue`.
614      */
615     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
616         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
617         return true;
618     }
619 
620     /**
621      * @dev Moves tokens `amount` from `sender` to `recipient`.
622      *
623      * This is internal function is equivalent to {transfer}, and can be used to
624      * e.g. implement automatic token fees, slashing mechanisms, etc.
625      *
626      * Emits a {Transfer} event.
627      *
628      * Requirements:
629      *
630      * - `sender` cannot be the zero address.
631      * - `recipient` cannot be the zero address.
632      * - `sender` must have a balance of at least `amount`.
633      */
634     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
635         require(sender != address(0), "ERC20: transfer from the zero address");
636         require(recipient != address(0), "ERC20: transfer to the zero address");
637 
638         _beforeTokenTransfer(sender, recipient, amount);
639 
640         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
641         _balances[recipient] = _balances[recipient].add(amount);
642         emit Transfer(sender, recipient, amount);
643     }
644 
645     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
646      * the total supply.
647      *
648      * Emits a {Transfer} event with `from` set to the zero address.
649      *
650      * Requirements
651      *
652      * - `to` cannot be the zero address.
653      */
654     function _mint(address account, uint256 amount) internal virtual {
655         require(account != address(0), "ERC20: mint to the zero address");
656 
657         _beforeTokenTransfer(address(0), account, amount);
658 
659         _totalSupply = _totalSupply.add(amount);
660         _balances[account] = _balances[account].add(amount);
661         emit Transfer(address(0), account, amount);
662     }
663 
664     /**
665      * @dev Destroys `amount` tokens from `account`, reducing the
666      * total supply.
667      *
668      * Emits a {Transfer} event with `to` set to the zero address.
669      *
670      * Requirements
671      *
672      * - `account` cannot be the zero address.
673      * - `account` must have at least `amount` tokens.
674      */
675     function _burn(address account, uint256 amount) internal virtual {
676         require(account != address(0), "ERC20: burn from the zero address");
677 
678         _beforeTokenTransfer(account, address(0), amount);
679 
680         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
681         _totalSupply = _totalSupply.sub(amount);
682         emit Transfer(account, address(0), amount);
683     }
684 
685     /**
686      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
687      *
688      * This is internal function is equivalent to `approve`, and can be used to
689      * e.g. set automatic allowances for certain subsystems, etc.
690      *
691      * Emits an {Approval} event.
692      *
693      * Requirements:
694      *
695      * - `owner` cannot be the zero address.
696      * - `spender` cannot be the zero address.
697      */
698     function _approve(address owner, address spender, uint256 amount) internal virtual {
699         require(owner != address(0), "ERC20: approve from the zero address");
700         require(spender != address(0), "ERC20: approve to the zero address");
701 
702         _allowances[owner][spender] = amount;
703         emit Approval(owner, spender, amount);
704     }
705 
706     /**
707      * @dev Sets {decimals} to a value other than the default one of 18.
708      *
709      * WARNING: This function should only be called from the constructor. Most
710      * applications that interact with token contracts will not expect
711      * {decimals} to ever change, and may work incorrectly if it does.
712      */
713     function _setupDecimals(uint8 decimals_) internal {
714         _decimals = decimals_;
715     }
716 
717     /**
718      * @dev Hook that is called before any transfer of tokens. This includes
719      * minting and burning.
720      *
721      * Calling conditions:
722      *
723      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
724      * will be to transferred to `to`.
725      * - when `from` is zero, `amount` tokens will be minted for `to`.
726      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
727      * - `from` and `to` are never both zero.
728      *
729      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
730      */
731     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
732 }
733 
734 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
735 
736 
737 
738 pragma solidity ^0.6.0;
739 
740 
741 
742 /**
743  * @dev Extension of {ERC20} that allows token holders to destroy both their own
744  * tokens and those that they have an allowance for, in a way that can be
745  * recognized off-chain (via event analysis).
746  */
747 abstract contract ERC20Burnable is Context, ERC20 {
748     /**
749      * @dev Destroys `amount` tokens from the caller.
750      *
751      * See {ERC20-_burn}.
752      */
753     function burn(uint256 amount) public virtual {
754         _burn(_msgSender(), amount);
755     }
756 
757     /**
758      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
759      * allowance.
760      *
761      * See {ERC20-_burn} and {ERC20-allowance}.
762      *
763      * Requirements:
764      *
765      * - the caller must have allowance for ``accounts``'s tokens of at least
766      * `amount`.
767      */
768     function burnFrom(address account, uint256 amount) public virtual {
769         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
770 
771         _approve(account, _msgSender(), decreasedAllowance);
772         _burn(account, amount);
773     }
774 }
775 
776 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
777 
778 
779 
780 pragma solidity ^0.6.0;
781 
782 
783 
784 
785 /**
786  * @title SafeERC20
787  * @dev Wrappers around ERC20 operations that throw on failure (when the token
788  * contract returns false). Tokens that return no value (and instead revert or
789  * throw on failure) are also supported, non-reverting calls are assumed to be
790  * successful.
791  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
792  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
793  */
794 library SafeERC20 {
795     using SafeMath for uint256;
796     using Address for address;
797 
798     function safeTransfer(IERC20 token, address to, uint256 value) internal {
799         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
800     }
801 
802     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
803         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
804     }
805 
806     /**
807      * @dev Deprecated. This function has issues similar to the ones found in
808      * {IERC20-approve}, and its usage is discouraged.
809      *
810      * Whenever possible, use {safeIncreaseAllowance} and
811      * {safeDecreaseAllowance} instead.
812      */
813     function safeApprove(IERC20 token, address spender, uint256 value) internal {
814         // safeApprove should only be called when setting an initial allowance,
815         // or when resetting it to zero. To increase and decrease it, use
816         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
817         // solhint-disable-next-line max-line-length
818         require((value == 0) || (token.allowance(address(this), spender) == 0),
819             "SafeERC20: approve from non-zero to non-zero allowance"
820         );
821         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
822     }
823 
824     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
825         uint256 newAllowance = token.allowance(address(this), spender).add(value);
826         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
827     }
828 
829     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
830         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
831         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
832     }
833 
834     /**
835      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
836      * on the return value: the return value is optional (but if data is returned, it must not be false).
837      * @param token The token targeted by the call.
838      * @param data The call data (encoded using abi.encode or one of its variants).
839      */
840     function _callOptionalReturn(IERC20 token, bytes memory data) private {
841         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
842         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
843         // the target address contains contract code and also asserts for success in the low-level call.
844 
845         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
846         if (returndata.length > 0) { // Return data is optional
847             // solhint-disable-next-line max-line-length
848             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
849         }
850     }
851 }
852 
853 // File: @openzeppelin/contracts/access/Ownable.sol
854 
855 
856 
857 pragma solidity ^0.6.0;
858 
859 /**
860  * @dev Contract module which provides a basic access control mechanism, where
861  * there is an account (an owner) that can be granted exclusive access to
862  * specific functions.
863  *
864  * By default, the owner account will be the one that deploys the contract. This
865  * can later be changed with {transferOwnership}.
866  *
867  * This module is used through inheritance. It will make available the modifier
868  * `onlyOwner`, which can be applied to your functions to restrict their use to
869  * the owner.
870  */
871 contract Ownable is Context {
872     address private _owner;
873 
874     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
875 
876     /**
877      * @dev Initializes the contract setting the deployer as the initial owner.
878      */
879     constructor () internal {
880         address msgSender = _msgSender();
881         _owner = msgSender;
882         emit OwnershipTransferred(address(0), msgSender);
883     }
884 
885     /**
886      * @dev Returns the address of the current owner.
887      */
888     function owner() public view returns (address) {
889         return _owner;
890     }
891 
892     /**
893      * @dev Throws if called by any account other than the owner.
894      */
895     modifier onlyOwner() {
896         require(_owner == _msgSender(), "Ownable: caller is not the owner");
897         _;
898     }
899 
900     /**
901      * @dev Leaves the contract without owner. It will not be possible to call
902      * `onlyOwner` functions anymore. Can only be called by the current owner.
903      *
904      * NOTE: Renouncing ownership will leave the contract without an owner,
905      * thereby removing any functionality that is only available to the owner.
906      */
907     function renounceOwnership() public virtual onlyOwner {
908         emit OwnershipTransferred(_owner, address(0));
909         _owner = address(0);
910     }
911 
912     /**
913      * @dev Transfers ownership of the contract to a new account (`newOwner`).
914      * Can only be called by the current owner.
915      */
916     function transferOwnership(address newOwner) public virtual onlyOwner {
917         require(newOwner != address(0), "Ownable: new owner is the zero address");
918         emit OwnershipTransferred(_owner, newOwner);
919         _owner = newOwner;
920     }
921 }
922 
923 // File: @openzeppelin/contracts/utils/Pausable.sol
924 
925 
926 
927 pragma solidity ^0.6.0;
928 
929 
930 /**
931  * @dev Contract module which allows children to implement an emergency stop
932  * mechanism that can be triggered by an authorized account.
933  *
934  * This module is used through inheritance. It will make available the
935  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
936  * the functions of your contract. Note that they will not be pausable by
937  * simply including this module, only once the modifiers are put in place.
938  */
939 contract Pausable is Context {
940     /**
941      * @dev Emitted when the pause is triggered by `account`.
942      */
943     event Paused(address account);
944 
945     /**
946      * @dev Emitted when the pause is lifted by `account`.
947      */
948     event Unpaused(address account);
949 
950     bool private _paused;
951 
952     /**
953      * @dev Initializes the contract in unpaused state.
954      */
955     constructor () internal {
956         _paused = false;
957     }
958 
959     /**
960      * @dev Returns true if the contract is paused, and false otherwise.
961      */
962     function paused() public view returns (bool) {
963         return _paused;
964     }
965 
966     /**
967      * @dev Modifier to make a function callable only when the contract is not paused.
968      *
969      * Requirements:
970      *
971      * - The contract must not be paused.
972      */
973     modifier whenNotPaused() {
974         require(!_paused, "Pausable: paused");
975         _;
976     }
977 
978     /**
979      * @dev Modifier to make a function callable only when the contract is paused.
980      *
981      * Requirements:
982      *
983      * - The contract must be paused.
984      */
985     modifier whenPaused() {
986         require(_paused, "Pausable: not paused");
987         _;
988     }
989 
990     /**
991      * @dev Triggers stopped state.
992      *
993      * Requirements:
994      *
995      * - The contract must not be paused.
996      */
997     function _pause() internal virtual whenNotPaused {
998         _paused = true;
999         emit Paused(_msgSender());
1000     }
1001 
1002     /**
1003      * @dev Returns to normal state.
1004      *
1005      * Requirements:
1006      *
1007      * - The contract must be paused.
1008      */
1009     function _unpause() internal virtual whenPaused {
1010         _paused = false;
1011         emit Unpaused(_msgSender());
1012     }
1013 }
1014 
1015 // File: @openzeppelin/contracts/math/Math.sol
1016 
1017 
1018 
1019 pragma solidity ^0.6.0;
1020 
1021 /**
1022  * @dev Standard math utilities missing in the Solidity language.
1023  */
1024 library Math {
1025     /**
1026      * @dev Returns the largest of two numbers.
1027      */
1028     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1029         return a >= b ? a : b;
1030     }
1031 
1032     /**
1033      * @dev Returns the smallest of two numbers.
1034      */
1035     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1036         return a < b ? a : b;
1037     }
1038 
1039     /**
1040      * @dev Returns the average of two numbers. The result is rounded towards
1041      * zero.
1042      */
1043     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1044         // (a + b) / 2 can overflow, so we distribute
1045         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1046     }
1047 }
1048 
1049 // File: contracts/ECDSA.sol
1050 
1051 
1052 
1053 pragma solidity ^0.6.0;
1054 
1055 // A copy from https://github.com/OpenZeppelin/openzeppelin-contracts/pull/2237/files
1056 
1057 /**
1058  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1059  *
1060  * These functions can be used to verify that a message was signed by the holder
1061  * of the private keys of a given address.
1062  */
1063 library ECDSA {
1064   /**
1065    * @dev Returns the address that signed a hashed message (`hash`) with
1066    * `signature`. This address can then be used for verification purposes.
1067    *
1068    * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1069    * this function rejects them by requiring the `s` value to be in the lower
1070    * half order, and the `v` value to be either 27 or 28.
1071    *
1072    * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1073    * verification to be secure: it is possible to craft signatures that
1074    * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1075    * this is by receiving a hash of the original message (which may otherwise
1076    * be too long), and then calling {toEthSignedMessageHash} on it.
1077    */
1078   function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1079     // Check the signature length
1080     if (signature.length != 65) {
1081       revert("ECDSA: invalid signature length");
1082     }
1083 
1084     // Divide the signature in r, s and v variables
1085     bytes32 r;
1086     bytes32 s;
1087     uint8 v;
1088 
1089     // ecrecover takes the signature parameters, and the only way to get them
1090     // currently is to use assembly.
1091     // solhint-disable-next-line no-inline-assembly
1092     assembly {
1093       r := mload(add(signature, 0x20))
1094       s := mload(add(signature, 0x40))
1095       v := mload(add(signature, 0x41))
1096     }
1097 
1098     return recover(hash, v, r, s);
1099   }
1100 
1101   /**
1102    * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
1103    * `r` and `s` signature fields separately.
1104    */
1105   function recover(
1106     bytes32 hash,
1107     uint8 v,
1108     bytes32 r,
1109     bytes32 s
1110   ) internal pure returns (address) {
1111     // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1112     // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1113     // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1114     // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1115     //
1116     // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1117     // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1118     // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1119     // these malleable signatures as well.
1120     require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
1121     require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
1122 
1123     // If the signature is valid (and not malleable), return the signer address
1124     address signer = ecrecover(hash, v, r, s);
1125     require(signer != address(0), "ECDSA: invalid signature");
1126 
1127     return signer;
1128   }
1129 
1130   /**
1131    * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1132    * replicates the behavior of the
1133    * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
1134    * JSON-RPC method.
1135    *
1136    * See {recover}.
1137    */
1138   function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1139     // 32 is the length in bytes of hash,
1140     // enforced by the type signature above
1141     return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1142   }
1143 }
1144 
1145 // File: contracts/ERC20Permit.sol
1146 
1147 
1148 
1149 pragma solidity ^0.6.0;
1150 
1151 // Adapted copy from https://github.com/OpenZeppelin/openzeppelin-contracts/pull/2237/files
1152 
1153 
1154 
1155 /**
1156  * @dev Extension of {ERC20} that allows token holders to use their tokens
1157  * without sending any transactions by setting {IERC20-allowance} with a
1158  * signature using the {permit} method, and then spend them via
1159  * {IERC20-transferFrom}.
1160  *
1161  * The {permit} signature mechanism conforms to the {IERC2612Permit} interface.
1162  */
1163 abstract contract ERC20Permit is ERC20 {
1164   mapping(address => uint256) private _nonces;
1165 
1166   bytes32 private constant _PERMIT_TYPEHASH = keccak256(
1167     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
1168   );
1169 
1170   // Mapping of ChainID to domain separators. This is a very gas efficient way
1171   // to not recalculate the domain separator on every call, while still
1172   // automatically detecting ChainID changes.
1173   mapping(uint256 => bytes32) private _domainSeparators;
1174 
1175   constructor() internal {
1176     _updateDomainSeparator();
1177   }
1178 
1179   /**
1180    * @dev See {IERC2612Permit-permit}.
1181    *
1182    * If https://eips.ethereum.org/EIPS/eip-1344[ChainID] ever changes, the
1183    * EIP712 Domain Separator is automatically recalculated.
1184    */
1185   function permit(
1186     address owner,
1187     address spender,
1188     uint256 amount,
1189     uint256 deadline,
1190     uint8 v,
1191     bytes32 r,
1192     bytes32 s
1193   ) public {
1194     require(blockTimestamp() <= deadline, "ERC20Permit: expired deadline");
1195 
1196     bytes32 hashStruct = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner], deadline));
1197 
1198     bytes32 hash = keccak256(abi.encodePacked(uint16(0x1901), _domainSeparator(), hashStruct));
1199 
1200     address signer = ECDSA.recover(hash, v, r, s);
1201     require(signer == owner, "ERC20Permit: invalid signature");
1202 
1203     _nonces[owner]++;
1204     _approve(owner, spender, amount);
1205   }
1206 
1207   /**
1208    * @dev See {IERC2612Permit-nonces}.
1209    */
1210   function nonces(address owner) public view returns (uint256) {
1211     return _nonces[owner];
1212   }
1213 
1214   function _updateDomainSeparator() private returns (bytes32) {
1215     uint256 _chainID = chainID();
1216 
1217     bytes32 newDomainSeparator = keccak256(
1218       abi.encode(
1219         keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
1220         keccak256(bytes(name())),
1221         keccak256(bytes("1")), // Version
1222         _chainID,
1223         address(this)
1224       )
1225     );
1226 
1227     _domainSeparators[_chainID] = newDomainSeparator;
1228 
1229     return newDomainSeparator;
1230   }
1231 
1232   // Returns the domain separator, updating it if chainID changes
1233   function _domainSeparator() private returns (bytes32) {
1234     bytes32 domainSeparator = _domainSeparators[chainID()];
1235     if (domainSeparator != 0x00) {
1236       return domainSeparator;
1237     } else {
1238       return _updateDomainSeparator();
1239     }
1240   }
1241 
1242   function chainID() public view virtual returns (uint256 _chainID) {
1243     assembly {
1244       _chainID := chainid()
1245     }
1246   }
1247 
1248   function blockTimestamp() public view virtual returns (uint256) {
1249     return block.timestamp;
1250   }
1251 }
1252 
1253 // File: contracts/ENS.sol
1254 
1255 
1256 
1257 pragma solidity ^0.6.0;
1258 
1259 interface ENS {
1260   function resolver(bytes32 node) external view returns (Resolver);
1261 }
1262 
1263 interface Resolver {
1264   function addr(bytes32 node) external view returns (address);
1265 }
1266 
1267 contract EnsResolve {
1268   function resolve(bytes32 node) public view virtual returns (address) {
1269     ENS Registry = ENS(
1270       getChainId() == 1 ? 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e : 0x8595bFb0D940DfEDC98943FA8a907091203f25EE
1271     );
1272     return Registry.resolver(node).addr(node);
1273   }
1274 
1275   function bulkResolve(bytes32[] memory domains) public view returns (address[] memory result) {
1276     result = new address[](domains.length);
1277     for (uint256 i = 0; i < domains.length; i++) {
1278       result[i] = resolve(domains[i]);
1279     }
1280   }
1281 
1282   function getChainId() internal pure returns (uint256) {
1283     uint256 chainId;
1284     assembly {
1285       chainId := chainid()
1286     }
1287     return chainId;
1288   }
1289 }
1290 
1291 // File: contracts/TORN.sol
1292 
1293 
1294 
1295 pragma solidity ^0.6.0;
1296 pragma experimental ABIEncoderV2;
1297 
1298 
1299 
1300 
1301 
1302 
1303 
1304 
1305 
1306 
1307 contract TORN is ERC20("TornadoCash", "TORN"), ERC20Burnable, ERC20Permit, Pausable, EnsResolve {
1308   using SafeERC20 for IERC20;
1309 
1310   uint256 public immutable canUnpauseAfter;
1311   address public immutable governance;
1312   mapping(address => bool) public allowedTransferee;
1313 
1314   event Allowed(address target);
1315   event Disallowed(address target);
1316 
1317   struct Recipient {
1318     bytes32 to;
1319     uint256 amount;
1320   }
1321 
1322   constructor(
1323     bytes32 _governance,
1324     uint256 _pausePeriod,
1325     Recipient[] memory _vestings
1326   ) public {
1327     address _resolvedGovernance = resolve(_governance);
1328     governance = _resolvedGovernance;
1329     allowedTransferee[_resolvedGovernance] = true;
1330 
1331     for (uint256 i = 0; i < _vestings.length; i++) {
1332       address to = resolve(_vestings[i].to);
1333       _mint(to, _vestings[i].amount);
1334       allowedTransferee[to] = true;
1335     }
1336 
1337     canUnpauseAfter = blockTimestamp().add(_pausePeriod);
1338     _pause();
1339     require(totalSupply() == 10000000 ether, "TORN: incorrect distribution");
1340   }
1341 
1342   modifier onlyGovernance() {
1343     require(_msgSender() == governance, "TORN: only governance can perform this action");
1344     _;
1345   }
1346 
1347   function changeTransferability(bool decision) public onlyGovernance {
1348     require(blockTimestamp() > canUnpauseAfter, "TORN: cannot change transferability yet");
1349     if (decision) {
1350       _unpause();
1351     } else {
1352       _pause();
1353     }
1354   }
1355 
1356   function addToAllowedList(address[] memory target) public onlyGovernance {
1357     for (uint256 i = 0; i < target.length; i++) {
1358       allowedTransferee[target[i]] = true;
1359       emit Allowed(target[i]);
1360     }
1361   }
1362 
1363   function removeFromAllowedList(address[] memory target) public onlyGovernance {
1364     for (uint256 i = 0; i < target.length; i++) {
1365       allowedTransferee[target[i]] = false;
1366       emit Disallowed(target[i]);
1367     }
1368   }
1369 
1370   function _beforeTokenTransfer(
1371     address from,
1372     address to,
1373     uint256 amount
1374   ) internal override {
1375     super._beforeTokenTransfer(from, to, amount);
1376     require(!paused() || allowedTransferee[from] || allowedTransferee[to], "TORN: paused");
1377     require(to != address(this), "TORN: invalid recipient");
1378   }
1379 
1380   /// @dev Method to claim junk and accidentally sent tokens
1381   function rescueTokens(
1382     IERC20 _token,
1383     address payable _to,
1384     uint256 _balance
1385   ) external onlyGovernance {
1386     require(_to != address(0), "TORN: can not send to zero address");
1387 
1388     if (_token == IERC20(0)) {
1389       // for Ether
1390       uint256 totalBalance = address(this).balance;
1391       uint256 balance = _balance == 0 ? totalBalance : Math.min(totalBalance, _balance);
1392       _to.transfer(balance);
1393     } else {
1394       // any other erc20
1395       uint256 totalBalance = _token.balanceOf(address(this));
1396       uint256 balance = _balance == 0 ? totalBalance : Math.min(totalBalance, _balance);
1397       require(balance > 0, "TORN: trying to send 0 balance");
1398       _token.safeTransfer(_to, balance);
1399     }
1400   }
1401 }