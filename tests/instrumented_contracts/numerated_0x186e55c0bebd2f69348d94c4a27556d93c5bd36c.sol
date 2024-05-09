1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      *
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
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
373 /**
374  * @dev Implementation of the {IERC20} interface.
375  *
376  * This implementation is agnostic to the way tokens are created. This means
377  * that a supply mechanism has to be added in a derived contract using {_mint}.
378  * For a generic mechanism see {ERC20PresetMinterPauser}.
379  *
380  * TIP: For a detailed writeup see our guide
381  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
382  * to implement supply mechanisms].
383  *
384  * We have followed general OpenZeppelin guidelines: functions revert instead
385  * of returning `false` on failure. This behavior is nonetheless conventional
386  * and does not conflict with the expectations of ERC20 applications.
387  *
388  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
389  * This allows applications to reconstruct the allowance for all accounts just
390  * by listening to said events. Other implementations of the EIP may not emit
391  * these events, as it isn't required by the specification.
392  *
393  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
394  * functions have been added to mitigate the well-known issues around setting
395  * allowances. See {IERC20-approve}.
396  */
397 contract ERC20 is IERC20 {
398     using SafeMath for uint256;
399     using Address for address;
400 
401     mapping (address => uint256) private _balances;
402 
403     mapping (address => mapping (address => uint256)) private _allowances;
404 
405     uint256 private _totalSupply;
406 
407     string private _name;
408     string private _symbol;
409     uint8 private _decimals;
410 
411     /**
412      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
413      * a default value of 18.
414      *
415      * To select a different value for {decimals}, use {_setupDecimals}.
416      *
417      * All three of these values are immutable: they can only be set once during
418      * construction.
419      */
420     constructor (string memory name, string memory symbol) {
421         _name = name;
422         _symbol = symbol;
423         _decimals = 18;
424     }
425 
426     /**
427      * @dev Returns the name of the token.
428      */
429     function name() public view returns (string memory) {
430         return _name;
431     }
432 
433     /**
434      * @dev Returns the symbol of the token, usually a shorter version of the
435      * name.
436      */
437     function symbol() public view returns (string memory) {
438         return _symbol;
439     }
440 
441     /**
442      * @dev Returns the number of decimals used to get its user representation.
443      * For example, if `decimals` equals `2`, a balance of `505` tokens should
444      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
445      *
446      * Tokens usually opt for a value of 18, imitating the relationship between
447      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
448      * called.
449      *
450      * NOTE: This information is only used for _display_ purposes: it in
451      * no way affects any of the arithmetic of the contract, including
452      * {IERC20-balanceOf} and {IERC20-transfer}.
453      */
454     function decimals() public view returns (uint8) {
455         return _decimals;
456     }
457 
458     /**
459      * @dev See {IERC20-totalSupply}.
460      */
461     function totalSupply() public view override returns (uint256) {
462         return _totalSupply;
463     }
464 
465     /**
466      * @dev See {IERC20-balanceOf}.
467      */
468     function balanceOf(address account) public view override returns (uint256) {
469         return _balances[account];
470     }
471 
472     /**
473      * @dev See {IERC20-transfer}.
474      *
475      * Requirements:
476      *
477      * - `recipient` cannot be the zero address.
478      * - the caller must have a balance of at least `amount`.
479      */
480     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
481         _transfer(msg.sender, recipient, amount);
482         return true;
483     }
484 
485     /**
486      * @dev See {IERC20-allowance}.
487      */
488     function allowance(address owner, address spender) public view virtual override returns (uint256) {
489         return _allowances[owner][spender];
490     }
491 
492     /**
493      * @dev See {IERC20-approve}.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      */
499     function approve(address spender, uint256 amount) public virtual override returns (bool) {
500         _approve(msg.sender, spender, amount);
501         return true;
502     }
503 
504     /**
505      * @dev See {IERC20-transferFrom}.
506      *
507      * Emits an {Approval} event indicating the updated allowance. This is not
508      * required by the EIP. See the note at the beginning of {ERC20};
509      *
510      * Requirements:
511      * - `sender` and `recipient` cannot be the zero address.
512      * - `sender` must have a balance of at least `amount`.
513      * - the caller must have allowance for ``sender``'s tokens of at least
514      * `amount`.
515      */
516     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
517         _transfer(sender, recipient, amount);
518         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
519         return true;
520     }
521 
522     /**
523      * @dev Atomically increases the allowance granted to `spender` by the caller.
524      *
525      * This is an alternative to {approve} that can be used as a mitigation for
526      * problems described in {IERC20-approve}.
527      *
528      * Emits an {Approval} event indicating the updated allowance.
529      *
530      * Requirements:
531      *
532      * - `spender` cannot be the zero address.
533      */
534     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
535         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
536         return true;
537     }
538 
539     /**
540      * @dev Atomically decreases the allowance granted to `spender` by the caller.
541      *
542      * This is an alternative to {approve} that can be used as a mitigation for
543      * problems described in {IERC20-approve}.
544      *
545      * Emits an {Approval} event indicating the updated allowance.
546      *
547      * Requirements:
548      *
549      * - `spender` cannot be the zero address.
550      * - `spender` must have allowance for the caller of at least
551      * `subtractedValue`.
552      */
553     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
554         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
555         return true;
556     }
557 
558     /**
559      * @dev Moves tokens `amount` from `sender` to `recipient`.
560      *
561      * This is internal function is equivalent to {transfer}, and can be used to
562      * e.g. implement automatic token fees, slashing mechanisms, etc.
563      *
564      * Emits a {Transfer} event.
565      *
566      * Requirements:
567      *
568      * - `sender` cannot be the zero address.
569      * - `recipient` cannot be the zero address.
570      * - `sender` must have a balance of at least `amount`.
571      */
572     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
573         require(sender != address(0), "ERC20: transfer from the zero address");
574         require(recipient != address(0), "ERC20: transfer to the zero address");
575 
576         _beforeTokenTransfer(sender, recipient, amount);
577 
578         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
579         _balances[recipient] = _balances[recipient].add(amount);
580         emit Transfer(sender, recipient, amount);
581     }
582 
583     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
584      * the total supply.
585      *
586      * Emits a {Transfer} event with `from` set to the zero address.
587      *
588      * Requirements
589      *
590      * - `to` cannot be the zero address.
591      */
592     function _mint(address account, uint256 amount) internal virtual {
593         require(account != address(0), "ERC20: mint to the zero address");
594 
595         _beforeTokenTransfer(address(0), account, amount);
596 
597         _totalSupply = _totalSupply.add(amount);
598         _balances[account] = _balances[account].add(amount);
599         emit Transfer(address(0), account, amount);
600     }
601 
602     /**
603      * @dev Destroys `amount` tokens from `account`, reducing the
604      * total supply.
605      *
606      * Emits a {Transfer} event with `to` set to the zero address.
607      *
608      * Requirements
609      *
610      * - `account` cannot be the zero address.
611      * - `account` must have at least `amount` tokens.
612      */
613     function _burn(address account, uint256 amount) internal virtual {
614         require(account != address(0), "ERC20: burn from the zero address");
615 
616         _beforeTokenTransfer(account, address(0), amount);
617 
618         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
619         _totalSupply = _totalSupply.sub(amount);
620         emit Transfer(account, address(0), amount);
621     }
622 
623     /**
624      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
625      *
626      * This internal function is equivalent to `approve`, and can be used to
627      * e.g. set automatic allowances for certain subsystems, etc.
628      *
629      * Emits an {Approval} event.
630      *
631      * Requirements:
632      *
633      * - `owner` cannot be the zero address.
634      * - `spender` cannot be the zero address.
635      */
636     function _approve(address owner, address spender, uint256 amount) internal virtual {
637         require(owner != address(0), "ERC20: approve from the zero address");
638         require(spender != address(0), "ERC20: approve to the zero address");
639 
640         _allowances[owner][spender] = amount;
641         emit Approval(owner, spender, amount);
642     }
643 
644     /**
645      * @dev Sets {decimals} to a value other than the default one of 18.
646      *
647      * WARNING: This function should only be called from the constructor. Most
648      * applications that interact with token contracts will not expect
649      * {decimals} to ever change, and may work incorrectly if it does.
650      */
651     function _setupDecimals(uint8 decimals_) internal {
652         _decimals = decimals_;
653     }
654 
655     /**
656      * @dev Hook that is called before any transfer of tokens. This includes
657      * minting and burning.
658      *
659      * Calling conditions:
660      *
661      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
662      * will be to transferred to `to`.
663      * - when `from` is zero, `amount` tokens will be minted for `to`.
664      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
665      * - `from` and `to` are never both zero.
666      *
667      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
668      */
669     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
670 }
671 
672 /**
673  * @title SafeERC20
674  * @dev Wrappers around ERC20 operations that throw on failure (when the token
675  * contract returns false). Tokens that return no value (and instead revert or
676  * throw on failure) are also supported, non-reverting calls are assumed to be
677  * successful.
678  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
679  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
680  */
681 library SafeERC20 {
682     using SafeMath for uint256;
683     using Address for address;
684 
685     function safeTransfer(IERC20 token, address to, uint256 value) internal {
686         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
687     }
688 
689     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
690         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
691     }
692 
693     /**
694      * @dev Deprecated. This function has issues similar to the ones found in
695      * {IERC20-approve}, and its usage is discouraged.
696      *
697      * Whenever possible, use {safeIncreaseAllowance} and
698      * {safeDecreaseAllowance} instead.
699      */
700     function safeApprove(IERC20 token, address spender, uint256 value) internal {
701         // safeApprove should only be called when setting an initial allowance,
702         // or when resetting it to zero. To increase and decrease it, use
703         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
704         // solhint-disable-next-line max-line-length
705         require((value == 0) || (token.allowance(address(this), spender) == 0),
706             "SafeERC20: approve from non-zero to non-zero allowance"
707         );
708         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
709     }
710 
711     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
712         uint256 newAllowance = token.allowance(address(this), spender).add(value);
713         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
714     }
715 
716     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
717         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
718         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
719     }
720 
721     /**
722      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
723      * on the return value: the return value is optional (but if data is returned, it must not be false).
724      * @param token The token targeted by the call.
725      * @param data The call data (encoded using abi.encode or one of its variants).
726      */
727     function _callOptionalReturn(IERC20 token, bytes memory data) private {
728         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
729         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
730         // the target address contains contract code and also asserts for success in the low-level call.
731 
732         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
733         if (returndata.length > 0) { // Return data is optional
734             // solhint-disable-next-line max-line-length
735             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
736         }
737     }
738 }
739 
740 interface IStaking {
741     function stake( uint _amount, address _recipient ) external returns ( bool );
742 
743     function claim( address recipient ) external;
744 
745     function unstake( uint _amount, bool _trigger ) external;
746 
747     function index() external view returns ( uint );
748 }
749 
750 interface IxBTRFLY {
751     function balanceForGons( uint gons ) external view returns ( uint );
752 
753     function gonsForBalance( uint amount ) external view returns ( uint );
754 }
755 
756 interface IOwnable {
757   function owner() external view returns (address);
758 
759   function renounceOwnership() external;
760   
761   function transferOwnership( address newOwner_ ) external;
762 }
763 
764 contract Ownable is IOwnable {
765     
766   address internal _owner;
767 
768   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
769 
770   constructor () {
771     _owner = msg.sender;
772     emit OwnershipTransferred( address(0), _owner );
773   }
774 
775   function owner() public view override returns (address) {
776     return _owner;
777   }
778 
779   modifier onlyOwner() {
780     require( _owner == msg.sender, "Ownable: caller is not the owner" );
781     _;
782   }
783 
784   function renounceOwnership() public virtual override onlyOwner() {
785     emit OwnershipTransferred( _owner, address(0) );
786     _owner = address(0);
787   }
788 
789   function transferOwnership( address newOwner_ ) public virtual override onlyOwner() {
790     require( newOwner_ != address(0), "Ownable: new owner is the zero address");
791     emit OwnershipTransferred( _owner, newOwner_ );
792     _owner = newOwner_;
793   }
794 }
795 
796 abstract contract FrozenToken is ERC20, Ownable {
797   using SafeERC20 for ERC20;  
798   using SafeMath for uint256;
799 
800   bool public isTokenFrozen = true;
801   mapping (address => bool ) public isAuthorisedOperators;
802 
803 
804   modifier onlyAuthorisedOperators () {
805     require(!isTokenFrozen || isAuthorisedOperators[msg.sender], 'Frozen: token frozen or msg.sender not authorised');
806     _;
807   }
808 
809 
810   function unFreezeToken () external onlyOwner () {
811     isTokenFrozen = false;
812   }
813 
814   function changeAuthorisation (address operator, bool status) public onlyOwner {
815     require(operator != address(0), "Frozen: new operator cant be zero address");
816     isAuthorisedOperators[operator] = status; 
817   }
818 
819 
820   function addBatchAuthorisedOperators(address[] memory authorisedOperatorsArray) external onlyOwner {
821     for (uint i = 0; i < authorisedOperatorsArray.length; i++) {
822     changeAuthorisation(authorisedOperatorsArray[i],true);
823     }
824   }
825 
826 
827   function transfer(address recipient, uint256 amount) public virtual override onlyAuthorisedOperators returns (bool){
828   _transfer(msg.sender, recipient, amount);
829     return true;
830   }
831 
832   function transferFrom(address sender, address recipient, uint256 amount) public virtual override onlyAuthorisedOperators returns (bool) {
833     _transfer(sender, recipient, amount);
834     _approve(sender, msg.sender, allowance(sender, recipient ).sub(amount, "ERC20: transfer amount exceeds allowance"));
835     return true;
836   }
837 
838 }
839 
840 contract wxBTRFLY is FrozenToken {
841     using Address for address;
842     using SafeMath for uint;
843 
844     address public immutable staking;
845     address public immutable BTRFLY;
846     address public immutable xBTRFLY;
847 
848     //DON'T EVER F***ING CHANGE PLS - thank you :) | DOUBLE CHECK on Etherscan to verify number is correct
849     uint public immutable realINDEX = 23158417847463239084714197001737581570653996933128112807891516 * 1e9; 
850 
851     constructor( address _staking, address _BTRFLY, address _xBTRFLY ) ERC20( 'wxBTRFLY', 'wxBTRFLY' ) {
852         require( _staking != address(0) );
853         staking = _staking;
854         require( _BTRFLY != address(0) );
855         BTRFLY = _BTRFLY;
856         require( _xBTRFLY != address(0) );
857         xBTRFLY = _xBTRFLY;
858     }
859 
860         /**
861         @notice stakes BTRFLY and wraps sBTRFLY
862         @param _amount uint
863         @return uint
864      */
865     function wrapFromBTRFLY( uint _amount ) external returns ( uint ) {
866         IERC20( BTRFLY ).transferFrom( msg.sender, address(this), _amount );
867         IERC20( BTRFLY ).approve( staking, _amount ); // stake BTRFLY for sBTRFLY
868         IStaking( staking ).stake( _amount, address(this) );
869         IStaking( staking ).claim(address(this));
870 
871         uint value = wBTRFLYValue( _amount );
872         _mint( msg.sender, value );
873         return value;
874     }
875 
876     /**
877         @notice unwrap sBTRFLY and unstake BTRFLY
878         @param _amount uint
879         @return uint
880      */
881     function unwrapToBTRFLY( uint _amount ) external returns ( uint ) {
882         _burn( msg.sender, _amount );
883         
884         uint value = xBTRFLYValue( _amount );
885         IERC20( xBTRFLY ).approve( staking, value ); // unstake sBTRFLY for BTRFLY
886         IStaking( staking ).unstake( value, false);
887 
888         IERC20( BTRFLY ).transfer( msg.sender, value );
889         return value;
890     }
891 
892     /**
893         @notice wrap sBTRFLY
894         @param _amount uint
895         @return uint
896      */
897     function wrapFromxBTRFLY( uint _amount ) external returns ( uint ) {
898         IERC20( xBTRFLY ).transferFrom( msg.sender, address(this), _amount );
899         
900         uint value = wBTRFLYValue( _amount );
901         _mint( msg.sender, value );
902         return value;
903     }
904 
905     /**
906         @notice unwrap sBTRFLY
907         @param _amount uint
908         @return uint
909      */
910     function unwrapToxBTRFLY( uint _amount ) external returns ( uint ) {
911         _burn( msg.sender, _amount );
912 
913         uint value = xBTRFLYValue( _amount );
914         IERC20( xBTRFLY ).transfer( msg.sender, value );
915         return value;
916     }
917 
918     /**
919         @notice converts wBTRFLY amount to sBTRFLY
920         @param _amount uint
921         @return uint
922      */
923     function xBTRFLYValue( uint _amount ) public view returns ( uint ) {
924         return _amount.mul( realIndex() ).div( 10 ** decimals() );
925     }
926 
927     /**
928         @notice converts sBTRFLY amount to wBTRFLY
929         @param _amount uint
930         @return uint
931      */
932     function wBTRFLYValue( uint _amount ) public view returns ( uint ) {
933         return _amount.mul( 10 ** decimals() ).div( realIndex() );
934     }
935 
936     function realIndex() public view returns ( uint ) {
937         return IxBTRFLY(xBTRFLY).balanceForGons(realINDEX);
938     }
939 
940 }