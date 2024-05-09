1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 
104 /**
105  * @dev Interface for the optional metadata functions from the ERC20 standard.
106  *
107  * _Available since v4.1._
108  */
109 interface IERC20Metadata is IERC20 {
110     /**
111      * @dev Returns the name of the token.
112      */
113     function name() external view returns (string memory);
114 
115     /**
116      * @dev Returns the symbol of the token.
117      */
118     function symbol() external view returns (string memory);
119 
120     /**
121      * @dev Returns the decimals places of the token.
122      */
123     function decimals() external view returns (uint8);
124 }
125 
126 
127 
128 /**
129  * @dev Implementation of the {IERC20} interface.
130  *
131  * This implementation is agnostic to the way tokens are created. This means
132  * that a supply mechanism has to be added in a derived contract using {_mint}.
133  * For a generic mechanism see {ERC20PresetMinterPauser}.
134  *
135  * TIP: For a detailed writeup see our guide
136  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
137  * to implement supply mechanisms].
138  *
139  * We have followed general OpenZeppelin guidelines: functions revert instead
140  * of returning `false` on failure. This behavior is nonetheless conventional
141  * and does not conflict with the expectations of ERC20 applications.
142  *
143  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
144  * This allows applications to reconstruct the allowance for all accounts just
145  * by listening to said events. Other implementations of the EIP may not emit
146  * these events, as it isn't required by the specification.
147  *
148  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
149  * functions have been added to mitigate the well-known issues around setting
150  * allowances. See {IERC20-approve}.
151  */
152 contract ERC20 is Context, IERC20, IERC20Metadata {
153     mapping (address => uint256) private _balances;
154 
155     mapping (address => mapping (address => uint256)) private _allowances;
156 
157     uint256 private _totalSupply;
158 
159     string private _name;
160     string private _symbol;
161 
162     /**
163      * @dev Sets the values for {name} and {symbol}.
164      *
165      * The default value of {decimals} is 18. To select a different value for
166      * {decimals} you should overload it.
167      *
168      * All two of these values are immutable: they can only be set once during
169      * construction.
170      */
171     constructor (string memory name_, string memory symbol_) {
172         _name = name_;
173         _symbol = symbol_;
174     }
175 
176     /**
177      * @dev Returns the name of the token.
178      */
179     function name() public view virtual override returns (string memory) {
180         return _name;
181     }
182 
183     /**
184      * @dev Returns the symbol of the token, usually a shorter version of the
185      * name.
186      */
187     function symbol() public view virtual override returns (string memory) {
188         return _symbol;
189     }
190 
191     /**
192      * @dev Returns the number of decimals used to get its user representation.
193      * For example, if `decimals` equals `2`, a balance of `505` tokens should
194      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
195      *
196      * Tokens usually opt for a value of 18, imitating the relationship between
197      * Ether and Wei. This is the value {ERC20} uses, unless this function is
198      * overridden;
199      *
200      * NOTE: This information is only used for _display_ purposes: it in
201      * no way affects any of the arithmetic of the contract, including
202      * {IERC20-balanceOf} and {IERC20-transfer}.
203      */
204     function decimals() public view virtual override returns (uint8) {
205         return 18;
206     }
207 
208     /**
209      * @dev See {IERC20-totalSupply}.
210      */
211     function totalSupply() public view virtual override returns (uint256) {
212         return _totalSupply;
213     }
214 
215     /**
216      * @dev See {IERC20-balanceOf}.
217      */
218     function balanceOf(address account) public view virtual override returns (uint256) {
219         return _balances[account];
220     }
221 
222     /**
223      * @dev See {IERC20-transfer}.
224      *
225      * Requirements:
226      *
227      * - `recipient` cannot be the zero address.
228      * - the caller must have a balance of at least `amount`.
229      */
230     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
231         _transfer(_msgSender(), recipient, amount);
232         return true;
233     }
234 
235     /**
236      * @dev See {IERC20-allowance}.
237      */
238     function allowance(address owner, address spender) public view virtual override returns (uint256) {
239         return _allowances[owner][spender];
240     }
241 
242     /**
243      * @dev See {IERC20-approve}.
244      *
245      * Requirements:
246      *
247      * - `spender` cannot be the zero address.
248      */
249     function approve(address spender, uint256 amount) public virtual override returns (bool) {
250         _approve(_msgSender(), spender, amount);
251         return true;
252     }
253 
254     /**
255      * @dev See {IERC20-transferFrom}.
256      *
257      * Emits an {Approval} event indicating the updated allowance. This is not
258      * required by the EIP. See the note at the beginning of {ERC20}.
259      *
260      * Requirements:
261      *
262      * - `sender` and `recipient` cannot be the zero address.
263      * - `sender` must have a balance of at least `amount`.
264      * - the caller must have allowance for ``sender``'s tokens of at least
265      * `amount`.
266      */
267     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
268         _transfer(sender, recipient, amount);
269 
270         uint256 currentAllowance = _allowances[sender][_msgSender()];
271         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
272         _approve(sender, _msgSender(), currentAllowance - amount);
273 
274         return true;
275     }
276 
277     /**
278      * @dev Atomically increases the allowance granted to `spender` by the caller.
279      *
280      * This is an alternative to {approve} that can be used as a mitigation for
281      * problems described in {IERC20-approve}.
282      *
283      * Emits an {Approval} event indicating the updated allowance.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
290         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
291         return true;
292     }
293 
294     /**
295      * @dev Atomically decreases the allowance granted to `spender` by the caller.
296      *
297      * This is an alternative to {approve} that can be used as a mitigation for
298      * problems described in {IERC20-approve}.
299      *
300      * Emits an {Approval} event indicating the updated allowance.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      * - `spender` must have allowance for the caller of at least
306      * `subtractedValue`.
307      */
308     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
309         uint256 currentAllowance = _allowances[_msgSender()][spender];
310         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
311         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
312 
313         return true;
314     }
315 
316     /**
317      * @dev Moves tokens `amount` from `sender` to `recipient`.
318      *
319      * This is internal function is equivalent to {transfer}, and can be used to
320      * e.g. implement automatic token fees, slashing mechanisms, etc.
321      *
322      * Emits a {Transfer} event.
323      *
324      * Requirements:
325      *
326      * - `sender` cannot be the zero address.
327      * - `recipient` cannot be the zero address.
328      * - `sender` must have a balance of at least `amount`.
329      */
330     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
331         require(sender != address(0), "ERC20: transfer from the zero address");
332         require(recipient != address(0), "ERC20: transfer to the zero address");
333 
334         _beforeTokenTransfer(sender, recipient, amount);
335 
336         uint256 senderBalance = _balances[sender];
337         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
338         _balances[sender] = senderBalance - amount;
339         _balances[recipient] += amount;
340 
341         emit Transfer(sender, recipient, amount);
342     }
343 
344     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
345      * the total supply.
346      *
347      * Emits a {Transfer} event with `from` set to the zero address.
348      *
349      * Requirements:
350      *
351      * - `account` cannot be the zero address.
352      */
353     function _mint(address account, uint256 amount) internal virtual {
354         require(account != address(0), "ERC20: mint to the zero address");
355 
356         _beforeTokenTransfer(address(0), account, amount);
357 
358         _totalSupply += amount;
359         _balances[account] += amount;
360         emit Transfer(address(0), account, amount);
361     }
362 
363     /**
364      * @dev Destroys `amount` tokens from `account`, reducing the
365      * total supply.
366      *
367      * Emits a {Transfer} event with `to` set to the zero address.
368      *
369      * Requirements:
370      *
371      * - `account` cannot be the zero address.
372      * - `account` must have at least `amount` tokens.
373      */
374     function _burn(address account, uint256 amount) internal virtual {
375         require(account != address(0), "ERC20: burn from the zero address");
376 
377         _beforeTokenTransfer(account, address(0), amount);
378 
379         uint256 accountBalance = _balances[account];
380         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
381         _balances[account] = accountBalance - amount;
382         _totalSupply -= amount;
383 
384         emit Transfer(account, address(0), amount);
385     }
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
389      *
390      * This internal function is equivalent to `approve`, and can be used to
391      * e.g. set automatic allowances for certain subsystems, etc.
392      *
393      * Emits an {Approval} event.
394      *
395      * Requirements:
396      *
397      * - `owner` cannot be the zero address.
398      * - `spender` cannot be the zero address.
399      */
400     function _approve(address owner, address spender, uint256 amount) internal virtual {
401         require(owner != address(0), "ERC20: approve from the zero address");
402         require(spender != address(0), "ERC20: approve to the zero address");
403 
404         _allowances[owner][spender] = amount;
405         emit Approval(owner, spender, amount);
406     }
407 
408     /**
409      * @dev Hook that is called before any transfer of tokens. This includes
410      * minting and burning.
411      *
412      * Calling conditions:
413      *
414      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
415      * will be to transferred to `to`.
416      * - when `from` is zero, `amount` tokens will be minted for `to`.
417      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
418      * - `from` and `to` are never both zero.
419      *
420      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
421      */
422     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
423 }
424 
425 /**
426  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
427  */
428 abstract contract ERC20Capped is ERC20 {
429     uint256 immutable private _cap;
430 
431     /**
432      * @dev Sets the value of the `cap`. This value is immutable, it can only be
433      * set once during construction.
434      */
435     constructor (uint256 cap_) {
436         require(cap_ > 0, "ERC20Capped: cap is 0");
437         _cap = cap_;
438     }
439 
440     /**
441      * @dev Returns the cap on the token's total supply.
442      */
443     function cap() public view virtual returns (uint256) {
444         return _cap;
445     }
446 
447     /**
448      * @dev See {ERC20-_mint}.
449      */
450     function _mint(address account, uint256 amount) internal virtual override {
451         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
452         super._mint(account, amount);
453     }
454 }
455 
456 
457 
458 
459 /**
460  * @dev Collection of functions related to the address type
461  */
462 library Address {
463     /**
464      * @dev Returns true if `account` is a contract.
465      *
466      * [IMPORTANT]
467      * ====
468      * It is unsafe to assume that an address for which this function returns
469      * false is an externally-owned account (EOA) and not a contract.
470      *
471      * Among others, `isContract` will return false for the following
472      * types of addresses:
473      *
474      *  - an externally-owned account
475      *  - a contract in construction
476      *  - an address where a contract will be created
477      *  - an address where a contract lived, but was destroyed
478      * ====
479      */
480     function isContract(address account) internal view returns (bool) {
481         // This method relies on extcodesize, which returns 0 for contracts in
482         // construction, since the code is only stored at the end of the
483         // constructor execution.
484 
485         uint256 size;
486         // solhint-disable-next-line no-inline-assembly
487         assembly { size := extcodesize(account) }
488         return size > 0;
489     }
490 
491     /**
492      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
493      * `recipient`, forwarding all available gas and reverting on errors.
494      *
495      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
496      * of certain opcodes, possibly making contracts go over the 2300 gas limit
497      * imposed by `transfer`, making them unable to receive funds via
498      * `transfer`. {sendValue} removes this limitation.
499      *
500      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
501      *
502      * IMPORTANT: because control is transferred to `recipient`, care must be
503      * taken to not create reentrancy vulnerabilities. Consider using
504      * {ReentrancyGuard} or the
505      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
506      */
507     function sendValue(address payable recipient, uint256 amount) internal {
508         require(address(this).balance >= amount, "Address: insufficient balance");
509 
510         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
511         (bool success, ) = recipient.call{ value: amount }("");
512         require(success, "Address: unable to send value, recipient may have reverted");
513     }
514 
515     /**
516      * @dev Performs a Solidity function call using a low level `call`. A
517      * plain`call` is an unsafe replacement for a function call: use this
518      * function instead.
519      *
520      * If `target` reverts with a revert reason, it is bubbled up by this
521      * function (like regular Solidity function calls).
522      *
523      * Returns the raw returned data. To convert to the expected return value,
524      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
525      *
526      * Requirements:
527      *
528      * - `target` must be a contract.
529      * - calling `target` with `data` must not revert.
530      *
531      * _Available since v3.1._
532      */
533     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
534       return functionCall(target, data, "Address: low-level call failed");
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
539      * `errorMessage` as a fallback revert reason when `target` reverts.
540      *
541      * _Available since v3.1._
542      */
543     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
544         return functionCallWithValue(target, data, 0, errorMessage);
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
549      * but also transferring `value` wei to `target`.
550      *
551      * Requirements:
552      *
553      * - the calling contract must have an ETH balance of at least `value`.
554      * - the called Solidity function must be `payable`.
555      *
556      * _Available since v3.1._
557      */
558     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
559         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
564      * with `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
569         require(address(this).balance >= value, "Address: insufficient balance for call");
570         require(isContract(target), "Address: call to non-contract");
571 
572         // solhint-disable-next-line avoid-low-level-calls
573         (bool success, bytes memory returndata) = target.call{ value: value }(data);
574         return _verifyCallResult(success, returndata, errorMessage);
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
579      * but performing a static call.
580      *
581      * _Available since v3.3._
582      */
583     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
584         return functionStaticCall(target, data, "Address: low-level static call failed");
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
589      * but performing a static call.
590      *
591      * _Available since v3.3._
592      */
593     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
594         require(isContract(target), "Address: static call to non-contract");
595 
596         // solhint-disable-next-line avoid-low-level-calls
597         (bool success, bytes memory returndata) = target.staticcall(data);
598         return _verifyCallResult(success, returndata, errorMessage);
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
603      * but performing a delegate call.
604      *
605      * _Available since v3.4._
606      */
607     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
608         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
613      * but performing a delegate call.
614      *
615      * _Available since v3.4._
616      */
617     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
618         require(isContract(target), "Address: delegate call to non-contract");
619 
620         // solhint-disable-next-line avoid-low-level-calls
621         (bool success, bytes memory returndata) = target.delegatecall(data);
622         return _verifyCallResult(success, returndata, errorMessage);
623     }
624 
625     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
626         if (success) {
627             return returndata;
628         } else {
629             // Look for revert reason and bubble it up if present
630             if (returndata.length > 0) {
631                 // The easiest way to bubble the revert reason is using memory via assembly
632 
633                 // solhint-disable-next-line no-inline-assembly
634                 assembly {
635                     let returndata_size := mload(returndata)
636                     revert(add(32, returndata), returndata_size)
637                 }
638             } else {
639                 revert(errorMessage);
640             }
641         }
642     }
643 }
644 
645 /**
646  * @title SafeERC20
647  * @dev Wrappers around ERC20 operations that throw on failure (when the token
648  * contract returns false). Tokens that return no value (and instead revert or
649  * throw on failure) are also supported, non-reverting calls are assumed to be
650  * successful.
651  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
652  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
653  */
654 library SafeERC20 {
655     using Address for address;
656 
657     function safeTransfer(IERC20 token, address to, uint256 value) internal {
658         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
659     }
660 
661     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
662         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
663     }
664 
665     /**
666      * @dev Deprecated. This function has issues similar to the ones found in
667      * {IERC20-approve}, and its usage is discouraged.
668      *
669      * Whenever possible, use {safeIncreaseAllowance} and
670      * {safeDecreaseAllowance} instead.
671      */
672     function safeApprove(IERC20 token, address spender, uint256 value) internal {
673         // safeApprove should only be called when setting an initial allowance,
674         // or when resetting it to zero. To increase and decrease it, use
675         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
676         // solhint-disable-next-line max-line-length
677         require((value == 0) || (token.allowance(address(this), spender) == 0),
678             "SafeERC20: approve from non-zero to non-zero allowance"
679         );
680         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
681     }
682 
683     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
684         uint256 newAllowance = token.allowance(address(this), spender) + value;
685         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
686     }
687 
688     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
689         unchecked {
690             uint256 oldAllowance = token.allowance(address(this), spender);
691             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
692             uint256 newAllowance = oldAllowance - value;
693             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
694         }
695     }
696 
697     /**
698      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
699      * on the return value: the return value is optional (but if data is returned, it must not be false).
700      * @param token The token targeted by the call.
701      * @param data The call data (encoded using abi.encode or one of its variants).
702      */
703     function _callOptionalReturn(IERC20 token, bytes memory data) private {
704         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
705         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
706         // the target address contains contract code and also asserts for success in the low-level call.
707 
708         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
709         if (returndata.length > 0) { // Return data is optional
710             // solhint-disable-next-line max-line-length
711             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
712         }
713     }
714 }
715 
716 
717 
718 
719 
720 
721  // I don't think we need SafeERC20, haven't seen it yet
722 
723 
724 // we know it has the following
725  // IERC20
726  // ERC20
727  // ERC20Capped
728  
729 contract EPSTEINToken is Context, ERC20Capped{
730 
731     // using Address for address;
732     using SafeERC20 for IERC20;         
733     
734     constructor(uint256 initialSupply) public ERC20Capped(initialSupply * 10 ** 18) ERC20("Epstein Token", "EPSTEIN"){
735         //There can never be more EPSTEIN minted, the reason we do the ERC20 version of _mint is to get around a compiler issue, but the cap remains in place.
736         ERC20._mint(msg.sender, initialSupply * 10 ** 18);
737     }
738 }