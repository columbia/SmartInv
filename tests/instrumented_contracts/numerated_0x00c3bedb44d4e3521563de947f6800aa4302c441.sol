1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity >=0.6.0;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
28         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
29         // for accounts without code, i.e. `keccak256('')`
30         bytes32 codehash;
31         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { codehash := extcodehash(account) }
34         return (codehash != accountHash && codehash != 0x0);
35     }
36 
37     /**
38      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39      * `recipient`, forwarding all available gas and reverting on errors.
40      *
41      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42      * of certain opcodes, possibly making contracts go over the 2300 gas limit
43      * imposed by `transfer`, making them unable to receive funds via
44      * `transfer`. {sendValue} removes this limitation.
45      *
46      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47      *
48      * IMPORTANT: because control is transferred to `recipient`, care must be
49      * taken to not create reentrancy vulnerabilities. Consider using
50      * {ReentrancyGuard} or the
51      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52      */
53     function sendValue(address payable recipient, uint256 amount) internal {
54         require(address(this).balance >= amount, "Address: insufficient balance");
55 
56         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
57         (bool success, ) = recipient.call{ value: amount }("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain`call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80         return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90         return _functionCallWithValue(target, data, 0, errorMessage);
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95      * but also transferring `value` wei to `target`.
96      *
97      * Requirements:
98      *
99      * - the calling contract must have an ETH balance of at least `value`.
100      * - the called Solidity function must be `payable`.
101      *
102      * _Available since v3.1._
103      */
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
110      * with `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
124         if (success) {
125             return returndata;
126         } else {
127             // Look for revert reason and bubble it up if present
128             if (returndata.length > 0) {
129                 // The easiest way to bubble the revert reason is using memory via assembly
130 
131                 // solhint-disable-next-line no-inline-assembly
132                 assembly {
133                     let returndata_size := mload(returndata)
134                     revert(add(32, returndata), returndata_size)
135                 }
136             } else {
137                 revert(errorMessage);
138             }
139         }
140     }
141 }
142 
143 /**
144  * @dev Wrappers over Solidity's arithmetic operations with added overflow
145  * checks.
146  *
147  * Arithmetic operations in Solidity wrap on overflow. This can easily result
148  * in bugs, because programmers usually assume that an overflow raises an
149  * error, which is the standard behavior in high level programming languages.
150  * `SafeMath` restores this intuition by reverting the transaction when an
151  * operation overflows.
152  *
153  * Using this library instead of the unchecked operations eliminates an entire
154  * class of bugs, so it's recommended to use it always.
155  */
156 library SafeMath {
157     /**
158      * @dev Returns the addition of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `+` operator.
162      *
163      * Requirements:
164      *
165      * - Addition cannot overflow.
166      */
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         uint256 c = a + b;
169         require(c >= a, "SafeMath: addition overflow");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting on
176      * overflow (when the result is negative).
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185         return sub(a, b, "SafeMath: subtraction overflow");
186     }
187 
188     /**
189      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
190      * overflow (when the result is negative).
191      *
192      * Counterpart to Solidity's `-` operator.
193      *
194      * Requirements:
195      *
196      * - Subtraction cannot overflow.
197      */
198     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b <= a, errorMessage);
200         uint256 c = a - b;
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the multiplication of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `*` operator.
210      *
211      * Requirements:
212      *
213      * - Multiplication cannot overflow.
214      */
215     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
217         // benefit is lost if 'b' is also tested.
218         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
219         if (a == 0) {
220             return 0;
221         }
222 
223         uint256 c = a * b;
224         require(c / a == b, "SafeMath: multiplication overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the integer division of two unsigned integers. Reverts on
231      * division by zero. The result is rounded towards zero.
232      *
233      * Counterpart to Solidity's `/` operator. Note: this function uses a
234      * `revert` opcode (which leaves remaining gas untouched) while Solidity
235      * uses an invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function div(uint256 a, uint256 b) internal pure returns (uint256) {
242         return div(a, b, "SafeMath: division by zero");
243     }
244 
245     /**
246      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
247      * division by zero. The result is rounded towards zero.
248      *
249      * Counterpart to Solidity's `/` operator. Note: this function uses a
250      * `revert` opcode (which leaves remaining gas untouched) while Solidity
251      * uses an invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b > 0, errorMessage);
259         uint256 c = a / b;
260         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
261 
262         return c;
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
267      * Reverts when dividing by zero.
268      *
269      * Counterpart to Solidity's `%` operator. This function uses a `revert`
270      * opcode (which leaves remaining gas untouched) while Solidity uses an
271      * invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
278         return mod(a, b, "SafeMath: modulo by zero");
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * Reverts with custom message when dividing by zero.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b != 0, errorMessage);
295         return a % b;
296     }
297 }
298 
299 /*
300  * @dev Provides information about the current execution context, including the
301  * sender of the transaction and its data. While these are generally available
302  * via msg.sender and msg.data, they should not be accessed in such a direct
303  * manner, since when dealing with GSN meta-transactions the account sending and
304  * paying for execution may not be the actual sender (as far as an application
305  * is concerned).
306  *
307  * This contract is only required for intermediate, library-like contracts.
308  */
309 abstract contract Context {
310     function _msgSender() internal view virtual returns (address payable) {
311         return msg.sender;
312     }
313 
314     function _msgData() internal view virtual returns (bytes memory) {
315         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
316         return msg.data;
317     }
318 }
319 
320 /**
321  * @dev Interface of the ERC20 standard as defined in the EIP.
322  */
323 interface IERC20 {
324     /**
325      * @dev Returns the amount of tokens in existence.
326      */
327     function totalSupply() external view returns (uint256);
328 
329     /**
330      * @dev Returns the amount of tokens owned by `account`.
331      */
332     function balanceOf(address account) external view returns (uint256);
333 
334     /**
335      * @dev Moves `amount` tokens from the caller's account to `recipient`.
336      *
337      * Returns a boolean value indicating whether the operation succeeded.
338      *
339      * Emits a {Transfer} event.
340      */
341     function transfer(address recipient, uint256 amount) external returns (bool);
342 
343     /**
344      * @dev Returns the remaining number of tokens that `spender` will be
345      * allowed to spend on behalf of `owner` through {transferFrom}. This is
346      * zero by default.
347      *
348      * This value changes when {approve} or {transferFrom} are called.
349      */
350     function allowance(address owner, address spender) external view returns (uint256);
351 
352     /**
353      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
354      *
355      * Returns a boolean value indicating whether the operation succeeded.
356      *
357      * IMPORTANT: Beware that changing an allowance with this method brings the risk
358      * that someone may use both the old and the new allowance by unfortunate
359      * transaction ordering. One possible solution to mitigate this race
360      * condition is to first reduce the spender's allowance to 0 and set the
361      * desired value afterwards:
362      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
363      *
364      * Emits an {Approval} event.
365      */
366     function approve(address spender, uint256 amount) external returns (bool);
367 
368     /**
369      * @dev Moves `amount` tokens from `sender` to `recipient` using the
370      * allowance mechanism. `amount` is then deducted from the caller's
371      * allowance.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Emitted when `value` tokens are moved from one account (`from`) to
381      * another (`to`).
382      *
383      * Note that `value` may be zero.
384      */
385     event Transfer(address indexed from, address indexed to, uint256 value);
386 
387     /**
388      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
389      * a call to {approve}. `value` is the new allowance.
390      */
391     event Approval(address indexed owner, address indexed spender, uint256 value);
392 }
393 
394 /**
395  * @dev Implementation of the {IERC20} interface.
396  *
397  * This implementation is agnostic to the way tokens are created. This means
398  * that a supply mechanism has to be added in a derived contract using {_mint}.
399  * For a generic mechanism see {ERC20PresetMinterPauser}.
400  *
401  * TIP: For a detailed writeup see our guide
402  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
403  * to implement supply mechanisms].
404  *
405  * We have followed general OpenZeppelin guidelines: functions revert instead
406  * of returning `false` on failure. This behavior is nonetheless conventional
407  * and does not conflict with the expectations of ERC20 applications.
408  *
409  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
410  * This allows applications to reconstruct the allowance for all accounts just
411  * by listening to said events. Other implementations of the EIP may not emit
412  * these events, as it isn't required by the specification.
413  *
414  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
415  * functions have been added to mitigate the well-known issues around setting
416  * allowances. See {IERC20-approve}.
417  */
418 contract ERC20 is Context, IERC20 {
419     using SafeMath for uint256;
420     using Address for address;
421 
422     mapping (address => uint256) private _balances;
423 
424     mapping (address => mapping (address => uint256)) private _allowances;
425 
426     uint256 private _totalSupply;
427 
428     string private _name;
429     string private _symbol;
430     uint8 private _decimals;
431 
432     /**
433      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
434      * a default value of 18.
435      *
436      * To select a different value for {decimals}, use {_setupDecimals}.
437      *
438      * All three of these values are immutable: they can only be set once during
439      * construction.
440      */
441     constructor (string memory name, string memory symbol) public {
442         _name = name;
443         _symbol = symbol;
444         _decimals = 18;
445     }
446 
447     /**
448      * @dev Returns the name of the token.
449      */
450     function name() public view returns (string memory) {
451         return _name;
452     }
453 
454     /**
455      * @dev Returns the symbol of the token, usually a shorter version of the
456      * name.
457      */
458     function symbol() public view returns (string memory) {
459         return _symbol;
460     }
461 
462     /**
463      * @dev Returns the number of decimals used to get its user representation.
464      * For example, if `decimals` equals `2`, a balance of `505` tokens should
465      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
466      *
467      * Tokens usually opt for a value of 18, imitating the relationship between
468      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
469      * called.
470      *
471      * NOTE: This information is only used for _display_ purposes: it in
472      * no way affects any of the arithmetic of the contract, including
473      * {IERC20-balanceOf} and {IERC20-transfer}.
474      */
475     function decimals() public view returns (uint8) {
476         return _decimals;
477     }
478 
479     /**
480      * @dev See {IERC20-totalSupply}.
481      */
482     function totalSupply() public view override returns (uint256) {
483         return _totalSupply;
484     }
485 
486     /**
487      * @dev See {IERC20-balanceOf}.
488      */
489     function balanceOf(address account) public view override returns (uint256) {
490         return _balances[account];
491     }
492 
493     /**
494      * @dev See {IERC20-transfer}.
495      *
496      * Requirements:
497      *
498      * - `recipient` cannot be the zero address.
499      * - the caller must have a balance of at least `amount`.
500      */
501     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
502         _transfer(_msgSender(), recipient, amount);
503         return true;
504     }
505 
506     /**
507      * @dev See {IERC20-allowance}.
508      */
509     function allowance(address owner, address spender) public view virtual override returns (uint256) {
510         return _allowances[owner][spender];
511     }
512 
513     /**
514      * @dev See {IERC20-approve}.
515      *
516      * Requirements:
517      *
518      * - `spender` cannot be the zero address.
519      */
520     function approve(address spender, uint256 amount) public virtual override returns (bool) {
521         _approve(_msgSender(), spender, amount);
522         return true;
523     }
524 
525     /**
526      * @dev See {IERC20-transferFrom}.
527      *
528      * Emits an {Approval} event indicating the updated allowance. This is not
529      * required by the EIP. See the note at the beginning of {ERC20};
530      *
531      * Requirements:
532      * - `sender` and `recipient` cannot be the zero address.
533      * - `sender` must have a balance of at least `amount`.
534      * - the caller must have allowance for ``sender``'s tokens of at least
535      * `amount`.
536      */
537     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
538         _transfer(sender, recipient, amount);
539         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
540         return true;
541     }
542 
543     /**
544      * @dev Atomically increases the allowance granted to `spender` by the caller.
545      *
546      * This is an alternative to {approve} that can be used as a mitigation for
547      * problems described in {IERC20-approve}.
548      *
549      * Emits an {Approval} event indicating the updated allowance.
550      *
551      * Requirements:
552      *
553      * - `spender` cannot be the zero address.
554      */
555     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
556         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
557         return true;
558     }
559 
560     /**
561      * @dev Atomically decreases the allowance granted to `spender` by the caller.
562      *
563      * This is an alternative to {approve} that can be used as a mitigation for
564      * problems described in {IERC20-approve}.
565      *
566      * Emits an {Approval} event indicating the updated allowance.
567      *
568      * Requirements:
569      *
570      * - `spender` cannot be the zero address.
571      * - `spender` must have allowance for the caller of at least
572      * `subtractedValue`.
573      */
574     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
575         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
576         return true;
577     }
578 
579     /**
580      * @dev Moves tokens `amount` from `sender` to `recipient`.
581      *
582      * This is internal function is equivalent to {transfer}, and can be used to
583      * e.g. implement automatic token fees, slashing mechanisms, etc.
584      *
585      * Emits a {Transfer} event.
586      *
587      * Requirements:
588      *
589      * - `sender` cannot be the zero address.
590      * - `recipient` cannot be the zero address.
591      * - `sender` must have a balance of at least `amount`.
592      */
593     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
594         require(sender != address(0), "ERC20: transfer from the zero address");
595         require(recipient != address(0), "ERC20: transfer to the zero address");
596 
597         _beforeTokenTransfer(sender, recipient, amount);
598 
599         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
600         _balances[recipient] = _balances[recipient].add(amount);
601         emit Transfer(sender, recipient, amount);
602     }
603 
604     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
605      * the total supply.
606      *
607      * Emits a {Transfer} event with `from` set to the zero address.
608      *
609      * Requirements
610      *
611      * - `to` cannot be the zero address.
612      */
613     function _mint(address account, uint256 amount) internal virtual {
614         require(account != address(0), "ERC20: mint to the zero address");
615 
616         _beforeTokenTransfer(address(0), account, amount);
617 
618         _totalSupply = _totalSupply.add(amount);
619         _balances[account] = _balances[account].add(amount);
620         emit Transfer(address(0), account, amount);
621     }
622 
623     /**
624      * @dev Destroys `amount` tokens from `account`, reducing the
625      * total supply.
626      *
627      * Emits a {Transfer} event with `to` set to the zero address.
628      *
629      * Requirements
630      *
631      * - `account` cannot be the zero address.
632      * - `account` must have at least `amount` tokens.
633      */
634     function _burn(address account, uint256 amount) internal virtual {
635         require(account != address(0), "ERC20: burn from the zero address");
636 
637         _beforeTokenTransfer(account, address(0), amount);
638 
639         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
640         _totalSupply = _totalSupply.sub(amount);
641         emit Transfer(account, address(0), amount);
642     }
643 
644     /**
645      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
646      *
647      * This is internal function is equivalent to `approve`, and can be used to
648      * e.g. set automatic allowances for certain subsystems, etc.
649      *
650      * Emits an {Approval} event.
651      *
652      * Requirements:
653      *
654      * - `owner` cannot be the zero address.
655      * - `spender` cannot be the zero address.
656      */
657     function _approve(address owner, address spender, uint256 amount) internal virtual {
658         require(owner != address(0), "ERC20: approve from the zero address");
659         require(spender != address(0), "ERC20: approve to the zero address");
660 
661         _allowances[owner][spender] = amount;
662         emit Approval(owner, spender, amount);
663     }
664 
665     /**
666      * @dev Sets {decimals} to a value other than the default one of 18.
667      *
668      * WARNING: This function should only be called from the constructor. Most
669      * applications that interact with token contracts will not expect
670      * {decimals} to ever change, and may work incorrectly if it does.
671      */
672     function _setupDecimals(uint8 decimals_) internal {
673         _decimals = decimals_;
674     }
675 
676     /**
677      * @dev Hook that is called before any transfer of tokens. This includes
678      * minting and burning.
679      *
680      * Calling conditions:
681      *
682      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
683      * will be to transferred to `to`.
684      * - when `from` is zero, `amount` tokens will be minted for `to`.
685      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
686      * - `from` and `to` are never both zero.
687      *
688      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
689      */
690     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
691 }
692 
693 /**
694  * @dev Extension of {ERC20} that allows token holders to destroy both their own
695  * tokens and those that they have an allowance for, in a way that can be
696  * recognized off-chain (via event analysis).
697  */
698 abstract contract ERC20Burnable is Context, ERC20 {
699     /**
700      * @dev Destroys `amount` tokens from the caller.
701      *
702      * See {ERC20-_burn}.
703      */
704     function burn(uint256 amount) public virtual {
705         _burn(_msgSender(), amount);
706     }
707 
708     /**
709      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
710      * allowance.
711      *
712      * See {ERC20-_burn} and {ERC20-allowance}.
713      *
714      * Requirements:
715      *
716      * - the caller must have allowance for ``accounts``'s tokens of at least
717      * `amount`.
718      */
719     function burnFrom(address account, uint256 amount) public virtual {
720         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
721 
722         _approve(account, _msgSender(), decreasedAllowance);
723         _burn(account, amount);
724     }
725 }
726 
727 contract ScalpexToken is ERC20Burnable {
728     constructor() public ERC20("Scalpex Token", "SXE") {
729         _mint(msg.sender, 50_000_000 * (10 ** uint256(decimals())));
730     }
731 }