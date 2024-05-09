1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // This method relies in extcodesize, which returns 0 for contracts in
258         // construction, since the code is only stored at the end of the
259         // constructor execution.
260 
261         uint256 size;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { size := extcodesize(account) }
264         return size > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
287         (bool success, ) = recipient.call{ value: amount }("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain`call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310       return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
320         return _functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         return _functionCallWithValue(target, data, value, errorMessage);
347     }
348 
349     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
350         require(isContract(target), "Address: call to non-contract");
351 
352         // solhint-disable-next-line avoid-low-level-calls
353         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 // solhint-disable-next-line no-inline-assembly
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
371 }
372 
373 /*
374  * @dev Provides information about the current execution context, including the
375  * sender of the transaction and its data. While these are generally available
376  * via msg.sender and msg.data, they should not be accessed in such a direct
377  * manner, since when dealing with GSN meta-transactions the account sending and
378  * paying for execution may not be the actual sender (as far as an application
379  * is concerned).
380  *
381  * This contract is only required for intermediate, library-like contracts.
382  */
383 abstract contract Context {
384     function _msgSender() internal view virtual returns (address payable) {
385         return msg.sender;
386     }
387 
388     function _msgData() internal view virtual returns (bytes memory) {
389         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
390         return msg.data;
391     }
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
645      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
646      *
647      * This internal function is equivalent to `approve`, and can be used to
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
694  * @title SafeERC20
695  * @dev Wrappers around ERC20 operations that throw on failure (when the token
696  * contract returns false). Tokens that return no value (and instead revert or
697  * throw on failure) are also supported, non-reverting calls are assumed to be
698  * successful.
699  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
700  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
701  */
702 library SafeERC20 {
703     using SafeMath for uint256;
704     using Address for address;
705 
706     function safeTransfer(IERC20 token, address to, uint256 value) internal {
707         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
708     }
709 
710     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
711         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
712     }
713 
714     /**
715      * @dev Deprecated. This function has issues similar to the ones found in
716      * {IERC20-approve}, and its usage is discouraged.
717      *
718      * Whenever possible, use {safeIncreaseAllowance} and
719      * {safeDecreaseAllowance} instead.
720      */
721     function safeApprove(IERC20 token, address spender, uint256 value) internal {
722         // safeApprove should only be called when setting an initial allowance,
723         // or when resetting it to zero. To increase and decrease it, use
724         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
725         // solhint-disable-next-line max-line-length
726         require((value == 0) || (token.allowance(address(this), spender) == 0),
727             "SafeERC20: approve from non-zero to non-zero allowance"
728         );
729         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
730     }
731 
732     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
733         uint256 newAllowance = token.allowance(address(this), spender).add(value);
734         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
735     }
736 
737     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
738         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
739         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
740     }
741 
742     /**
743      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
744      * on the return value: the return value is optional (but if data is returned, it must not be false).
745      * @param token The token targeted by the call.
746      * @param data The call data (encoded using abi.encode or one of its variants).
747      */
748     function _callOptionalReturn(IERC20 token, bytes memory data) private {
749         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
750         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
751         // the target address contains contract code and also asserts for success in the low-level call.
752 
753         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
754         if (returndata.length > 0) { // Return data is optional
755             // solhint-disable-next-line max-line-length
756             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
757         }
758     }
759 }
760 
761 interface IVaultManager {
762     function yax() external view returns (address);
763     function vaults(address) external view returns (bool);
764     function controllers(address) external view returns (bool);
765     function strategies(address) external view returns (bool);
766     function stakingPool() external view returns (address);
767     function profitSharer() external view returns (address);
768     function treasuryWallet() external view returns (address);
769     function performanceReward() external view returns (address);
770     function stakingPoolShareFee() external view returns (uint);
771     function gasFee() external view returns (uint);
772     function insuranceFee() external view returns (uint);
773     function withdrawalProtectionFee() external view returns (uint);
774 }
775 
776 interface IController {
777     function vaults(address) external view returns (address);
778     function want(address) external view returns (address);
779     function balanceOf(address) external view returns (uint);
780     function withdraw(address, uint) external;
781     function earn(address, uint) external;
782     function withdrawFee(address, uint) external view returns (uint); // pJar: 0.5% (50/10000)
783     function investEnabled() external view returns (bool);
784 }
785 
786 interface IConverter {
787     function token() external returns (address _share);
788     function convert(address _input, address _output, uint _inputAmount) external returns (uint _outputAmount);
789     function convert_rate(address _input, address _output, uint _inputAmount) external view returns (uint _outputAmount);
790     function convert_stables(uint[3] calldata amounts) external returns (uint _shareAmount); // 0: DAI, 1: USDC, 2: USDT
791     function get_dy(int128 i, int128 j, uint dx) external view returns (uint);
792     function exchange(int128 i, int128 j, uint dx, uint min_dy) external returns (uint dy);
793     function calc_token_amount(uint[3] calldata amounts, bool deposit) external view returns (uint _shareAmount);
794     function calc_token_amount_withdraw(uint _shares, address _output) external view returns (uint _outputAmount);
795 }
796 
797 interface IMetaVault {
798     function balance() external view returns (uint);
799     function setController(address _controller) external;
800     function claimInsurance() external;
801     function token() external view returns (address);
802     function available() external view returns (uint);
803     function withdrawFee(uint _amount) external view returns (uint);
804     function earn() external;
805     function calc_token_amount_deposit(uint[3] calldata amounts) external view returns (uint);
806     function calc_token_amount_withdraw(uint _shares, address _output) external view returns (uint);
807     function convert_rate(address _input, uint _amount) external view returns (uint);
808     function deposit(uint _amount, address _input, uint _min_mint_amount, bool _isStake) external;
809     function harvest(address reserve, uint amount) external;
810     function withdraw(uint _shares, address _output) external;
811     function want() external view returns (address);
812     function getPricePerFullShare() external view returns (uint);
813 }
814 
815 // @dev This metavault will pay YAX incentive for depositors and stakers
816 // It does not need minter key of YAX. Governance multisig will mint total of 34000 YAX and send into the vault in the beginning
817 contract yAxisMetaVault is ERC20, IMetaVault {
818     using Address for address;
819     using SafeMath for uint;
820     using SafeERC20 for IERC20;
821 
822     IERC20[4] public inputTokens; // DAI, USDC, USDT, 3Crv
823 
824     IERC20 public token3CRV;
825     IERC20 public tokenYAX;
826 
827     uint public min = 9500;
828     uint public constant max = 10000;
829 
830     uint public earnLowerlimit = 5 ether; // minimum to invest is 5 3CRV
831     uint public totalDepositCap = 10000000 ether; // initial cap set at 10 million dollar
832 
833     address public governance;
834     address public controller;
835     uint public insurance;
836     IVaultManager public vaultManager;
837     IConverter public converter;
838 
839     bool public acceptContractDepositor = false; // dont accept contract at beginning
840 
841     struct UserInfo {
842         uint amount;
843         uint yaxRewardDebt;
844         uint accEarned;
845     }
846 
847     uint public lastRewardBlock;
848     uint public accYaxPerShare;
849 
850     uint public yaxPerBlock;
851 
852     mapping(address => UserInfo) public userInfo;
853 
854     address public treasuryWallet = 0x362Db1c17db4C79B51Fe6aD2d73165b1fe9BaB4a;
855 
856     uint public constant BLOCKS_PER_WEEK = 46500;
857 
858     // Block number when each epoch ends.
859     uint[5] public epochEndBlocks;
860 
861     // Reward multipler for each of 5 epoches (epochIndex: reward multipler)
862     uint[6] public epochRewardMultiplers = [86000, 64000, 43000, 21000, 10000, 1];
863 
864     event Deposit(address indexed user, uint amount);
865     event Withdraw(address indexed user, uint amount);
866     event RewardPaid(address indexed user, uint reward);
867 
868     constructor (IERC20 _tokenDAI, IERC20 _tokenUSDC, IERC20 _tokenUSDT, IERC20 _token3CRV, IERC20 _tokenYAX,
869         uint _yaxPerBlock, uint _startBlock) public ERC20("yAxis.io:MetaVault:3CRV", "MVLT") {
870         inputTokens[0] = _tokenDAI;
871         inputTokens[1] = _tokenUSDC;
872         inputTokens[2] = _tokenUSDT;
873         inputTokens[3] = _token3CRV;
874         token3CRV = _token3CRV;
875         tokenYAX = _tokenYAX;
876         yaxPerBlock = _yaxPerBlock; // supposed to be 0.000001 YAX (1000000000000 = 1e12 wei)
877         lastRewardBlock = (_startBlock > block.number) ? _startBlock : block.number; // supposed to be 11,163,000 (Sat Oct 31 2020 06:30:00 GMT+0)
878         epochEndBlocks[0] = lastRewardBlock + BLOCKS_PER_WEEK * 2; // weeks 1-2
879         epochEndBlocks[1] = epochEndBlocks[0] + BLOCKS_PER_WEEK * 2; // weeks 3-4
880         epochEndBlocks[2] = epochEndBlocks[1] + BLOCKS_PER_WEEK * 4; // month 2
881         epochEndBlocks[3] = epochEndBlocks[2] + BLOCKS_PER_WEEK * 8; // month 3-4
882         epochEndBlocks[4] = epochEndBlocks[3] + BLOCKS_PER_WEEK * 8; // month 5-6
883         governance = msg.sender;
884     }
885 
886     /**
887      * @dev Throws if called by a contract and we are not allowing.
888      */
889     modifier checkContract() {
890         if (!acceptContractDepositor) {
891             require(!address(msg.sender).isContract() && msg.sender == tx.origin, "Sorry we do not accept contract!");
892         }
893         _;
894     }
895 
896     // Ignore insurance fund for balance calculations
897     function balance() public override view returns (uint) {
898         uint bal = token3CRV.balanceOf(address(this));
899         if (controller != address(0)) bal = bal.add(IController(controller).balanceOf(address(token3CRV)));
900         return bal.sub(insurance);
901     }
902 
903     function setMin(uint _min) external {
904         require(msg.sender == governance, "!governance");
905         min = _min;
906     }
907 
908     function setGovernance(address _governance) public {
909         require(msg.sender == governance, "!governance");
910         governance = _governance;
911     }
912 
913     function setController(address _controller) public override {
914         require(msg.sender == governance, "!governance");
915         controller = _controller;
916     }
917 
918     function setConverter(IConverter _converter) public {
919         require(msg.sender == governance, "!governance");
920         require(_converter.token() == address(token3CRV), "!token3CRV");
921         converter = _converter;
922     }
923 
924     function setVaultManager(IVaultManager _vaultManager) public {
925         require(msg.sender == governance, "!governance");
926         vaultManager = _vaultManager;
927     }
928 
929     function setEarnLowerlimit(uint _earnLowerlimit) public {
930         require(msg.sender == governance, "!governance");
931         earnLowerlimit = _earnLowerlimit;
932     }
933 
934     function setTotalDepositCap(uint _totalDepositCap) public {
935         require(msg.sender == governance, "!governance");
936         totalDepositCap = _totalDepositCap;
937     }
938 
939     function setAcceptContractDepositor(bool _acceptContractDepositor) public {
940         require(msg.sender == governance, "!governance");
941         acceptContractDepositor = _acceptContractDepositor;
942     }
943 
944     function setYaxPerBlock(uint _yaxPerBlock) public {
945         require(msg.sender == governance, "!governance");
946         updateReward();
947         yaxPerBlock = _yaxPerBlock;
948     }
949 
950     function setEpochEndBlock(uint8 _index, uint256 _epochEndBlock) public {
951         require(msg.sender == governance, "!governance");
952         require(_index < 5, "_index out of range");
953         require(_epochEndBlock > block.number, "Too late to update");
954         require(epochEndBlocks[_index] > block.number, "Too late to update");
955         epochEndBlocks[_index] = _epochEndBlock;
956     }
957 
958     function setEpochRewardMultipler(uint8 _index, uint256 _epochRewardMultipler) public {
959         require(msg.sender == governance, "!governance");
960         require(_index > 0 && _index < 6, "Index out of range");
961         require(epochEndBlocks[_index - 1] > block.number, "Too late to update");
962         epochRewardMultiplers[_index] = _epochRewardMultipler;
963     }
964 
965     // Return reward multiplier over the given _from to _to block.
966     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
967         for (uint8 epochId = 5; epochId >= 1; --epochId) {
968             if (_to >= epochEndBlocks[epochId - 1]) {
969                 if (_from >= epochEndBlocks[epochId - 1]) return _to.sub(_from).mul(epochRewardMultiplers[epochId]);
970                 uint256 multiplier = _to.sub(epochEndBlocks[epochId - 1]).mul(epochRewardMultiplers[epochId]);
971                 if (epochId == 1) return multiplier.add(epochEndBlocks[0].sub(_from).mul(epochRewardMultiplers[0]));
972                 for (epochId = epochId - 1; epochId >= 1; --epochId) {
973                     if (_from >= epochEndBlocks[epochId - 1]) return multiplier.add(epochEndBlocks[epochId].sub(_from).mul(epochRewardMultiplers[epochId]));
974                     multiplier = multiplier.add(epochEndBlocks[epochId].sub(epochEndBlocks[epochId - 1]).mul(epochRewardMultiplers[epochId]));
975                 }
976                 return multiplier.add(epochEndBlocks[0].sub(_from).mul(epochRewardMultiplers[0]));
977             }
978         }
979         return _to.sub(_from).mul(epochRewardMultiplers[0]);
980     }
981 
982     function setTreasuryWallet(address _treasuryWallet) public {
983         require(msg.sender == governance, "!governance");
984         treasuryWallet = _treasuryWallet;
985     }
986 
987     function claimInsurance() external override {
988         // if claim by controller for auto-compounding (current insurance will stay to increase sharePrice)
989         // otherwise send the fund to treasuryWallet
990         if (msg.sender != controller) {
991             // claim by governance for insurance
992             require(msg.sender == governance, "!governance");
993             token3CRV.safeTransfer(treasuryWallet, insurance);
994         }
995         insurance = 0;
996     }
997 
998     function token() public override view returns (address) {
999         return address(token3CRV);
1000     }
1001 
1002     // Custom logic in here for how much the vault allows to be borrowed
1003     // Sets minimum required on-hand to keep small withdrawals cheap
1004     function available() public override view returns (uint) {
1005         return token3CRV.balanceOf(address(this)).mul(min).div(max);
1006     }
1007 
1008     function withdrawFee(uint _amount) public override view returns (uint) {
1009         return (controller == address(0)) ? 0 : IController(controller).withdrawFee(address(token3CRV), _amount);
1010     }
1011 
1012     function earn() public override {
1013         if (controller != address(0)) {
1014             IController _contrl = IController(controller);
1015             if (_contrl.investEnabled()) {
1016                 uint _bal = available();
1017                 token3CRV.safeTransfer(controller, _bal);
1018                 _contrl.earn(address(token3CRV), _bal);
1019             }
1020         }
1021     }
1022 
1023     function calc_token_amount_deposit(uint[3] calldata amounts) external override view returns (uint) {
1024         return converter.calc_token_amount(amounts, true);
1025     }
1026 
1027     function calc_token_amount_withdraw(uint _shares, address _output) external override view returns (uint) {
1028         uint _withdrawFee = withdrawFee(_shares);
1029         if (_withdrawFee > 0) {
1030             _shares = _shares.mul(10000 - _withdrawFee).div(10000);
1031         }
1032         uint r = (balance().mul(_shares)).div(totalSupply());
1033         if (_output == address(token3CRV)) {
1034             return r;
1035         }
1036         return converter.calc_token_amount_withdraw(r, _output);
1037     }
1038 
1039     function convert_rate(address _input, uint _amount) external override view returns (uint) {
1040         return converter.convert_rate(_input, address(token3CRV), _amount);
1041     }
1042 
1043     function deposit(uint _amount, address _input, uint _min_mint_amount, bool _isStake) external override checkContract {
1044         require(_amount > 0, "!_amount");
1045         uint _pool = balance();
1046         uint _before = token3CRV.balanceOf(address(this));
1047         if (_input == address(token3CRV)) {
1048             token3CRV.safeTransferFrom(msg.sender, address(this), _amount);
1049         } else if (converter.convert_rate(_input, address(token3CRV), _amount) > 0) {
1050             IERC20(_input).safeTransferFrom(msg.sender, address(converter), _amount);
1051             converter.convert(_input, address(token3CRV), _amount);
1052         }
1053         uint _after = token3CRV.balanceOf(address(this));
1054         require(totalDepositCap == 0 || _after <= totalDepositCap, ">totalDepositCap");
1055         _amount = _after.sub(_before); // Additional check for deflationary tokens
1056         require(_amount >= _min_mint_amount, "slippage");
1057         if (_amount > 0) {
1058             if (!_isStake) {
1059                 _deposit(msg.sender, _pool, _amount);
1060             } else {
1061                 uint _shares = _deposit(address(this), _pool, _amount);
1062                 _stakeShares(_shares);
1063             }
1064         }
1065     }
1066 
1067     // Transfers tokens of all kinds
1068     // 0: DAI, 1: USDT, 2: USDC, 3: 3CRV
1069     function depositAll(uint[4] calldata _amounts, uint _min_mint_amount, bool _isStake) external checkContract {
1070         uint _pool = balance();
1071         uint _before = token3CRV.balanceOf(address(this));
1072         bool hasStables = false;
1073         for (uint8 i = 0; i < 4; i++) {
1074             uint _inputAmount = _amounts[i];
1075             if (_inputAmount > 0) {
1076                 if (i == 3) {
1077                     inputTokens[i].safeTransferFrom(msg.sender, address(this), _inputAmount);
1078                 } else if (converter.convert_rate(address(inputTokens[i]), address(token3CRV), _inputAmount) > 0) {
1079                     inputTokens[i].safeTransferFrom(msg.sender, address(converter), _inputAmount);
1080                     hasStables = true;
1081                 }
1082             }
1083         }
1084         if (hasStables) {
1085             uint[3] memory _stablesAmounts;
1086             _stablesAmounts[0] = _amounts[0];
1087             _stablesAmounts[1] = _amounts[1];
1088             _stablesAmounts[2] = _amounts[2];
1089             converter.convert_stables(_stablesAmounts);
1090         }
1091         uint _after = token3CRV.balanceOf(address(this));
1092         require(totalDepositCap == 0 || _after <= totalDepositCap, ">totalDepositCap");
1093         uint _totalDepositAmount = _after.sub(_before); // Additional check for deflationary tokens
1094         require(_totalDepositAmount >= _min_mint_amount, "slippage");
1095         if (_totalDepositAmount > 0) {
1096             if (!_isStake) {
1097                 _deposit(msg.sender, _pool, _totalDepositAmount);
1098             } else {
1099                 uint _shares = _deposit(address(this), _pool, _totalDepositAmount);
1100                 _stakeShares(_shares);
1101             }
1102         }
1103     }
1104 
1105     function stakeShares(uint _shares) external {
1106         uint _before = balanceOf(address(this));
1107         IERC20(address(this)).transferFrom(msg.sender, address(this), _shares);
1108         uint _after = balanceOf(address(this));
1109         _shares = _after.sub(_before);
1110         // Additional check for deflationary tokens
1111         _stakeShares(_shares);
1112     }
1113 
1114     function _deposit(address _mintTo, uint _pool, uint _amount) internal returns (uint _shares) {
1115         if (address(vaultManager) != address(0)) {
1116             // expected 0.1% of deposits go into an insurance fund (or auto-compounding if called by controller) in-case of negative profits to protect withdrawals
1117             // it is updated by governance (community vote)
1118             uint _insuranceFee = vaultManager.insuranceFee();
1119             if (_insuranceFee > 0) {
1120                 uint _insurance = _amount.mul(_insuranceFee).div(10000);
1121                 _amount = _amount.sub(_insurance);
1122                 insurance = insurance.add(_insurance);
1123             }
1124         }
1125 
1126         if (totalSupply() == 0) {
1127             _shares = _amount;
1128         } else {
1129             _shares = (_amount.mul(totalSupply())).div(_pool);
1130         }
1131         if (_shares > 0) {
1132             if (token3CRV.balanceOf(address(this)) > earnLowerlimit) {
1133                 earn();
1134             }
1135             _mint(_mintTo, _shares);
1136         }
1137     }
1138 
1139     function _stakeShares(uint _shares) internal {
1140         UserInfo storage user = userInfo[msg.sender];
1141         updateReward();
1142         _getReward();
1143         user.amount = user.amount.add(_shares);
1144         user.yaxRewardDebt = user.amount.mul(accYaxPerShare).div(1e12);
1145         emit Deposit(msg.sender, _shares);
1146     }
1147 
1148     // View function to see pending YAXs on frontend.
1149     function pendingYax(address _account) public view returns (uint _pending) {
1150         UserInfo storage user = userInfo[_account];
1151         uint _accYaxPerShare = accYaxPerShare;
1152         uint lpSupply = balanceOf(address(this));
1153         if (block.number > lastRewardBlock && lpSupply != 0) {
1154             uint256 _multiplier = getMultiplier(lastRewardBlock, block.number);
1155             _accYaxPerShare = accYaxPerShare.add(_multiplier.mul(yaxPerBlock).mul(1e12).div(lpSupply));
1156         }
1157         _pending = user.amount.mul(_accYaxPerShare).div(1e12).sub(user.yaxRewardDebt);
1158     }
1159 
1160     function updateReward() public {
1161         if (block.number <= lastRewardBlock) {
1162             return;
1163         }
1164         uint lpSupply = balanceOf(address(this));
1165         if (lpSupply == 0) {
1166             lastRewardBlock = block.number;
1167             return;
1168         }
1169         uint256 _multiplier = getMultiplier(lastRewardBlock, block.number);
1170         accYaxPerShare = accYaxPerShare.add(_multiplier.mul(yaxPerBlock).mul(1e12).div(lpSupply));
1171         lastRewardBlock = block.number;
1172     }
1173 
1174     function _getReward() internal {
1175         UserInfo storage user = userInfo[msg.sender];
1176         uint _pendingYax = user.amount.mul(accYaxPerShare).div(1e12).sub(user.yaxRewardDebt);
1177         if (_pendingYax > 0) {
1178             user.accEarned = user.accEarned.add(_pendingYax);
1179             safeYaxTransfer(msg.sender, _pendingYax);
1180             emit RewardPaid(msg.sender, _pendingYax);
1181         }
1182     }
1183 
1184     function withdrawAll(address _output) external {
1185         unstake(userInfo[msg.sender].amount);
1186         withdraw(balanceOf(msg.sender), _output);
1187     }
1188 
1189     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
1190     function harvest(address reserve, uint amount) external override {
1191         require(msg.sender == controller, "!controller");
1192         require(reserve != address(token3CRV), "token3CRV");
1193         IERC20(reserve).safeTransfer(controller, amount);
1194     }
1195 
1196     // call unstake(0) for getting reward
1197     function unstake(uint _amount) public {
1198         updateReward();
1199         _getReward();
1200         UserInfo storage user = userInfo[msg.sender];
1201         if (_amount > 0) {
1202             require(user.amount >= _amount, "stakedBal < _amount");
1203             user.amount = user.amount.sub(_amount);
1204             IERC20(address(this)).transfer(msg.sender, _amount);
1205         }
1206         user.yaxRewardDebt = user.amount.mul(accYaxPerShare).div(1e12);
1207         emit Withdraw(msg.sender, _amount);
1208     }
1209 
1210     // No rebalance implementation for lower fees and faster swaps
1211     function withdraw(uint _shares, address _output) public override {
1212         uint _userBal = balanceOf(msg.sender);
1213         if (_shares > _userBal) {
1214             uint _need = _shares.sub(_userBal);
1215             require(_need <= userInfo[msg.sender].amount, "_userBal+staked < _shares");
1216             unstake(_need);
1217         }
1218         uint r = (balance().mul(_shares)).div(totalSupply());
1219         _burn(msg.sender, _shares);
1220 
1221         if (address(vaultManager) != address(0)) {
1222             // expected 0.1% of withdrawal go back to vault (for auto-compounding) to protect withdrawals
1223             // it is updated by governance (community vote)
1224             uint _withdrawalProtectionFee = vaultManager.withdrawalProtectionFee();
1225             if (_withdrawalProtectionFee > 0) {
1226                 uint _withdrawalProtection = r.mul(_withdrawalProtectionFee).div(10000);
1227                 r = r.sub(_withdrawalProtection);
1228             }
1229         }
1230 
1231         // Check balance
1232         uint b = token3CRV.balanceOf(address(this));
1233         if (b < r) {
1234             uint _toWithdraw = r.sub(b);
1235             if (controller != address(0)) {
1236                 IController(controller).withdraw(address(token3CRV), _toWithdraw);
1237             }
1238             uint _after = token3CRV.balanceOf(address(this));
1239             uint _diff = _after.sub(b);
1240             if (_diff < _toWithdraw) {
1241                 r = b.add(_diff);
1242             }
1243         }
1244 
1245         if (_output == address(token3CRV)) {
1246             token3CRV.safeTransfer(msg.sender, r);
1247         } else {
1248             require(converter.convert_rate(address(token3CRV), _output, r) > 0, "rate=0");
1249             token3CRV.safeTransfer(address(converter), r);
1250             uint _outputAmount = converter.convert(address(token3CRV), _output, r);
1251             IERC20(_output).safeTransfer(msg.sender, _outputAmount);
1252         }
1253     }
1254 
1255     function want() external override view returns (address) {
1256         return address(token3CRV);
1257     }
1258 
1259     function getPricePerFullShare() external override view returns (uint) {
1260         return balance().mul(1e18).div(totalSupply());
1261     }
1262 
1263     // Safe YAX transfer, ensure we have enough balance.
1264     function safeYaxTransfer(address _to, uint _amount) internal {
1265         uint _tokenBal = tokenYAX.balanceOf(address(this));
1266         tokenYAX.safeTransfer(_to, (_tokenBal < _amount) ? _tokenBal : _amount);
1267     }
1268 
1269     // Only allows to earn some extra yield from non-core tokens - and auto-compounding the bought 3CRV
1270     function earnExtra(address _token) public {
1271         require(msg.sender == governance, "!governance");
1272         require(address(_token) != address(token3CRV), "3crv");
1273         require(address(_token) != address(this), "mlvt");
1274         uint _amount = IERC20(_token).balanceOf(address(this));
1275         require(converter.convert_rate(_token, address(token3CRV), _amount) > 0, "rate=0");
1276         IERC20(_token).safeTransfer(address(converter), _amount);
1277         converter.convert(_token, address(token3CRV), _amount);
1278     }
1279 }