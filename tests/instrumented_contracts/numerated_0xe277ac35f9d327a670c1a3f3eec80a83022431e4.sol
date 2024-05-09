1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 /* Polypux Token Creation Contract.
5  *https://polypux.com/
6 */
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 
31 pragma solidity ^0.6.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 
109 pragma solidity ^0.6.0;
110 
111 /**
112  * @dev Wrappers over Solidity's arithmetic operations with added overflow
113  * checks.
114  *
115  * Arithmetic operations in Solidity wrap on overflow. This can easily result
116  * in bugs, because programmers usually assume that an overflow raises an
117  * error, which is the standard behavior in high level programming languages.
118  * `SafeMath` restores this intuition by reverting the transaction when an
119  * operation overflows.
120  *
121  * Using this library instead of the unchecked operations eliminates an entire
122  * class of bugs, so it's recommended to use it always.
123  */
124 library SafeMath {
125     /**
126      * @dev Returns the addition of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `+` operator.
130      *
131      * Requirements:
132      *
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      *
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return mod(a, b, "SafeMath: modulo by zero");
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts with custom message when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b != 0, errorMessage);
263         return a % b;
264     }
265 }
266 
267 
268 
269 pragma solidity ^0.6.2;
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
409 
410 /**
411  * @dev Implementation of the {IERC20} interface.
412  *
413  * This implementation is agnostic to the way tokens are created. This means
414  * that a supply mechanism has to be added in a derived contract using {_mint}.
415  * For a generic mechanism see {ERC20PresetMinterPauser}.
416  *
417  * TIP: For a detailed writeup see our guide
418  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
419  * to implement supply mechanisms].
420  *
421  * We have followed general OpenZeppelin guidelines: functions revert instead
422  * of returning `false` on failure. This behavior is nonetheless conventional
423  * and does not conflict with the expectations of ERC20 applications.
424  *
425  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
426  * This allows applications to reconstruct the allowance for all accounts just
427  * by listening to said events. Other implementations of the EIP may not emit
428  * these events, as it isn't required by the specification.
429  *
430  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
431  * functions have been added to mitigate the well-known issues around setting
432  * allowances. See {IERC20-approve}.
433  */
434 contract ERC20 is Context, IERC20 {
435     using SafeMath for uint256;
436     using Address for address;
437 
438     mapping (address => uint256) private _balances;
439 
440     mapping (address => mapping (address => uint256)) private _allowances;
441 
442     uint256 private _totalSupply;
443 
444     string private _name;
445     string private _symbol;
446     uint8 private _decimals;
447 
448     address public _owner;
449     /**
450      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
451      * a default value of 18.
452      *
453      * To select a different value for {decimals}, use {_setupDecimals}.
454      *
455      * All three of these values are immutable: they can only be set once during
456      * construction.
457      */
458    constructor (string memory name, string memory symbol, uint256 initialSupply,address payable owner) public {
459         _name = name;
460         _symbol = symbol;
461         _decimals = 8;
462         _owner = owner;
463         _mint(_owner, initialSupply);
464     }
465 
466     /**
467      * @dev Returns the name of the token.
468      */
469     function name() public view returns (string memory) {
470         return _name;
471     }
472 
473     /**
474      * @dev Returns the symbol of the token, usually a shorter version of the
475      * name.
476      */
477     function symbol() public view returns (string memory) {
478         return _symbol;
479     }
480 
481     /**
482      * @dev Returns the number of decimals used to get its user representation.
483      * For example, if `decimals` equals `2`, a balance of `505` tokens should
484      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
485      *
486      * Tokens usually opt for a value of 18, imitating the relationship between
487      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
488      * called.
489      *
490      * NOTE: This information is only used for _display_ purposes: it in
491      * no way affects any of the arithmetic of the contract, including
492      * {IERC20-balanceOf} and {IERC20-transfer}.
493      */
494     function decimals() public view returns (uint8) {
495         return _decimals;
496     }
497 
498     /**
499      * @dev See {IERC20-totalSupply}.
500      */
501     function totalSupply() public view override returns (uint256) {
502         return _totalSupply;
503     }
504 
505     /**
506      * @dev See {IERC20-balanceOf}.
507      */
508     function balanceOf(address account) public view override returns (uint256) {
509         return _balances[account];
510     }
511 
512     /**
513      * @dev See {IERC20-transfer}.
514      *
515      * Requirements:
516      *
517      * - `recipient` cannot be the zero address.
518      * - the caller must have a balance of at least `amount`.
519      */
520     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
521         _transfer(_msgSender(), recipient, amount);
522         return true;
523     }
524 
525     /**
526      * @dev See {IERC20-allowance}.
527      */
528     function allowance(address owner, address spender) public view virtual override returns (uint256) {
529         return _allowances[owner][spender];
530     }
531 
532     /**
533      * @dev See {IERC20-approve}.
534      *
535      * Requirements:
536      *
537      * - `spender` cannot be the zero address.
538      */
539     function approve(address spender, uint256 amount) public virtual override returns (bool) {
540         _approve(_msgSender(), spender, amount);
541         return true;
542     }
543 
544     /**
545      * @dev See {IERC20-transferFrom}.
546      *
547      * Emits an {Approval} event indicating the updated allowance. This is not
548      * required by the EIP. See the note at the beginning of {ERC20};
549      *
550      * Requirements:
551      * - `sender` and `recipient` cannot be the zero address.
552      * - `sender` must have a balance of at least `amount`.
553      * - the caller must have allowance for ``sender``'s tokens of at least
554      * `amount`.
555      */
556     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
557         _transfer(sender, recipient, amount);
558         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
559         return true;
560     }
561 
562     /**
563      * @dev Atomically increases the allowance granted to `spender` by the caller.
564      *
565      * This is an alternative to {approve} that can be used as a mitigation for
566      * problems described in {IERC20-approve}.
567      *
568      * Emits an {Approval} event indicating the updated allowance.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      */
574     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
575         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
576         return true;
577     }
578 
579     /**
580      * @dev Atomically decreases the allowance granted to `spender` by the caller.
581      *
582      * This is an alternative to {approve} that can be used as a mitigation for
583      * problems described in {IERC20-approve}.
584      *
585      * Emits an {Approval} event indicating the updated allowance.
586      *
587      * Requirements:
588      *
589      * - `spender` cannot be the zero address.
590      * - `spender` must have allowance for the caller of at least
591      * `subtractedValue`.
592      */
593     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
594         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
595         return true;
596     }
597 
598     /**
599      * @dev Moves tokens `amount` from `sender` to `recipient`.
600      *
601      * This is internal function is equivalent to {transfer}, and can be used to
602      * e.g. implement automatic token fees, slashing mechanisms, etc.
603      *
604      * Emits a {Transfer} event.
605      *
606      * Requirements:
607      *
608      * - `sender` cannot be the zero address.
609      * - `recipient` cannot be the zero address.
610      * - `sender` must have a balance of at least `amount`.
611      */
612     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
613         require(sender != address(0), "ERC20: transfer from the zero address");
614         require(recipient != address(0), "ERC20: transfer to the zero address");
615 
616         _beforeTokenTransfer(sender, recipient, amount);
617 
618         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
619         _balances[recipient] = _balances[recipient].add(amount);
620         emit Transfer(sender, recipient, amount);
621     }
622 
623     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
624      * the total supply.
625      *
626      * Emits a {Transfer} event with `from` set to the zero address.
627      *
628      * Requirements
629      *
630      * - `to` cannot be the zero address.
631      */
632     function _mint(address account, uint256 amount) internal virtual {
633         require(account != address(0), "ERC20: mint to the zero address");
634 
635         _beforeTokenTransfer(address(0), account, amount);
636 
637         _totalSupply = _totalSupply.add(amount);
638         _balances[account] = _balances[account].add(amount);
639         emit Transfer(address(0), account, amount);
640     }
641 
642     /**
643      * @dev Destroys `amount` tokens from `account`, reducing the
644      * total supply.
645      *
646      * Emits a {Transfer} event with `to` set to the zero address.
647      *
648      * Requirements
649      *
650      * - `account` cannot be the zero address.
651      * - `account` must have at least `amount` tokens.
652      */
653     function _burn(address account, uint256 amount) internal virtual {
654         require(account != address(0), "ERC20: burn from the zero address");
655 
656         _beforeTokenTransfer(account, address(0), amount);
657 
658         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
659         _totalSupply = _totalSupply.sub(amount);
660         emit Transfer(account, address(0), amount);
661     }
662 
663     /**
664      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
665      *
666      * This is internal function is equivalent to `approve`, and can be used to
667      * e.g. set automatic allowances for certain subsystems, etc.
668      *
669      * Emits an {Approval} event.
670      *
671      * Requirements:
672      *
673      * - `owner` cannot be the zero address.
674      * - `spender` cannot be the zero address.
675      */
676     function _approve(address owner, address spender, uint256 amount) internal virtual {
677         require(owner != address(0), "ERC20: approve from the zero address");
678         require(spender != address(0), "ERC20: approve to the zero address");
679 
680         _allowances[owner][spender] = amount;
681         emit Approval(owner, spender, amount);
682     }
683 
684     /**
685      * @dev Sets {decimals} to a value other than the default one of 18.
686      *
687      * WARNING: This function should only be called from the constructor. Most
688      * applications that interact with token contracts will not expect
689      * {decimals} to ever change, and may work incorrectly if it does.
690      */
691     function _setupDecimals(uint8 decimals_) internal {
692         _decimals = decimals_;
693     }
694 
695     /**
696      * @dev Hook that is called before any transfer of tokens. This includes
697      * minting and burning.
698      *
699      * Calling conditions:
700      *
701      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
702      * will be to transferred to `to`.
703      * - when `from` is zero, `amount` tokens will be minted for `to`.
704      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
705      * - `from` and `to` are never both zero.
706      *
707      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
708      */
709     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
710 }