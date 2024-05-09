1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
107 
108 pragma solidity >=0.6.0 <0.8.0;
109 
110 
111 
112 
113 /**
114  * @dev Implementation of the {IERC20} interface.
115  *
116  * This implementation is agnostic to the way tokens are created. This means
117  * that a supply mechanism has to be added in a derived contract using {_mint}.
118  * For a generic mechanism see {ERC20PresetMinterPauser}.
119  *
120  * TIP: For a detailed writeup see our guide
121  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
122  * to implement supply mechanisms].
123  *
124  * We have followed general OpenZeppelin guidelines: functions revert instead
125  * of returning `false` on failure. This behavior is nonetheless conventional
126  * and does not conflict with the expectations of ERC20 applications.
127  *
128  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
129  * This allows applications to reconstruct the allowance for all accounts just
130  * by listening to said events. Other implementations of the EIP may not emit
131  * these events, as it isn't required by the specification.
132  *
133  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
134  * functions have been added to mitigate the well-known issues around setting
135  * allowances. See {IERC20-approve}.
136  */
137 contract ERC20 is Context, IERC20 {
138     using SafeMath for uint256;
139 
140     mapping (address => uint256) private _balances;
141 
142     mapping (address => mapping (address => uint256)) private _allowances;
143 
144     uint256 private _totalSupply;
145 
146     string private _name;
147     string private _symbol;
148     uint8 private _decimals;
149 
150     /**
151      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
152      * a default value of 18.
153      *
154      * To select a different value for {decimals}, use {_setupDecimals}.
155      *
156      * All three of these values are immutable: they can only be set once during
157      * construction.
158      */
159     constructor (string memory name_, string memory symbol_) public {
160         _name = name_;
161         _symbol = symbol_;
162         _decimals = 18;
163     }
164 
165     /**
166      * @dev Returns the name of the token.
167      */
168     function name() public view returns (string memory) {
169         return _name;
170     }
171 
172     /**
173      * @dev Returns the symbol of the token, usually a shorter version of the
174      * name.
175      */
176     function symbol() public view returns (string memory) {
177         return _symbol;
178     }
179 
180     /**
181      * @dev Returns the number of decimals used to get its user representation.
182      * For example, if `decimals` equals `2`, a balance of `505` tokens should
183      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
184      *
185      * Tokens usually opt for a value of 18, imitating the relationship between
186      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
187      * called.
188      *
189      * NOTE: This information is only used for _display_ purposes: it in
190      * no way affects any of the arithmetic of the contract, including
191      * {IERC20-balanceOf} and {IERC20-transfer}.
192      */
193     function decimals() public view returns (uint8) {
194         return _decimals;
195     }
196 
197     /**
198      * @dev See {IERC20-totalSupply}.
199      */
200     function totalSupply() public view override returns (uint256) {
201         return _totalSupply;
202     }
203 
204     /**
205      * @dev See {IERC20-balanceOf}.
206      */
207     function balanceOf(address account) public view override returns (uint256) {
208         return _balances[account];
209     }
210 
211     /**
212      * @dev See {IERC20-transfer}.
213      *
214      * Requirements:
215      *
216      * - `recipient` cannot be the zero address.
217      * - the caller must have a balance of at least `amount`.
218      */
219     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     /**
225      * @dev See {IERC20-allowance}.
226      */
227     function allowance(address owner, address spender) public view virtual override returns (uint256) {
228         return _allowances[owner][spender];
229     }
230 
231     /**
232      * @dev See {IERC20-approve}.
233      *
234      * Requirements:
235      *
236      * - `spender` cannot be the zero address.
237      */
238     function approve(address spender, uint256 amount) public virtual override returns (bool) {
239         _approve(_msgSender(), spender, amount);
240         return true;
241     }
242 
243     /**
244      * @dev See {IERC20-transferFrom}.
245      *
246      * Emits an {Approval} event indicating the updated allowance. This is not
247      * required by the EIP. See the note at the beginning of {ERC20}.
248      *
249      * Requirements:
250      *
251      * - `sender` and `recipient` cannot be the zero address.
252      * - `sender` must have a balance of at least `amount`.
253      * - the caller must have allowance for ``sender``'s tokens of at least
254      * `amount`.
255      */
256     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
257         _transfer(sender, recipient, amount);
258         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
259         return true;
260     }
261 
262     /**
263      * @dev Atomically increases the allowance granted to `spender` by the caller.
264      *
265      * This is an alternative to {approve} that can be used as a mitigation for
266      * problems described in {IERC20-approve}.
267      *
268      * Emits an {Approval} event indicating the updated allowance.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
275         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
276         return true;
277     }
278 
279     /**
280      * @dev Atomically decreases the allowance granted to `spender` by the caller.
281      *
282      * This is an alternative to {approve} that can be used as a mitigation for
283      * problems described in {IERC20-approve}.
284      *
285      * Emits an {Approval} event indicating the updated allowance.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      * - `spender` must have allowance for the caller of at least
291      * `subtractedValue`.
292      */
293     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
294         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
295         return true;
296     }
297 
298     /**
299      * @dev Moves tokens `amount` from `sender` to `recipient`.
300      *
301      * This is internal function is equivalent to {transfer}, and can be used to
302      * e.g. implement automatic token fees, slashing mechanisms, etc.
303      *
304      * Emits a {Transfer} event.
305      *
306      * Requirements:
307      *
308      * - `sender` cannot be the zero address.
309      * - `recipient` cannot be the zero address.
310      * - `sender` must have a balance of at least `amount`.
311      */
312     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
313         require(sender != address(0), "ERC20: transfer from the zero address");
314         require(recipient != address(0), "ERC20: transfer to the zero address");
315 
316         _beforeTokenTransfer(sender, recipient, amount);
317 
318         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
319         _balances[recipient] = _balances[recipient].add(amount);
320         emit Transfer(sender, recipient, amount);
321     }
322 
323     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
324      * the total supply.
325      *
326      * Emits a {Transfer} event with `from` set to the zero address.
327      *
328      * Requirements:
329      *
330      * - `to` cannot be the zero address.
331      */
332     function _mint(address account, uint256 amount) internal virtual {
333         require(account != address(0), "ERC20: mint to the zero address");
334 
335         _beforeTokenTransfer(address(0), account, amount);
336 
337         _totalSupply = _totalSupply.add(amount);
338         _balances[account] = _balances[account].add(amount);
339         emit Transfer(address(0), account, amount);
340     }
341 
342     /**
343      * @dev Destroys `amount` tokens from `account`, reducing the
344      * total supply.
345      *
346      * Emits a {Transfer} event with `to` set to the zero address.
347      *
348      * Requirements:
349      *
350      * - `account` cannot be the zero address.
351      * - `account` must have at least `amount` tokens.
352      */
353     function _burn(address account, uint256 amount) internal virtual {
354         require(account != address(0), "ERC20: burn from the zero address");
355 
356         _beforeTokenTransfer(account, address(0), amount);
357 
358         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
359         _totalSupply = _totalSupply.sub(amount);
360         emit Transfer(account, address(0), amount);
361     }
362 
363     /**
364      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
365      *
366      * This internal function is equivalent to `approve`, and can be used to
367      * e.g. set automatic allowances for certain subsystems, etc.
368      *
369      * Emits an {Approval} event.
370      *
371      * Requirements:
372      *
373      * - `owner` cannot be the zero address.
374      * - `spender` cannot be the zero address.
375      */
376     function _approve(address owner, address spender, uint256 amount) internal virtual {
377         require(owner != address(0), "ERC20: approve from the zero address");
378         require(spender != address(0), "ERC20: approve to the zero address");
379 
380         _allowances[owner][spender] = amount;
381         emit Approval(owner, spender, amount);
382     }
383 
384     /**
385      * @dev Sets {decimals} to a value other than the default one of 18.
386      *
387      * WARNING: This function should only be called from the constructor. Most
388      * applications that interact with token contracts will not expect
389      * {decimals} to ever change, and may work incorrectly if it does.
390      */
391     function _setupDecimals(uint8 decimals_) internal {
392         _decimals = decimals_;
393     }
394 
395     /**
396      * @dev Hook that is called before any transfer of tokens. This includes
397      * minting and burning.
398      *
399      * Calling conditions:
400      *
401      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
402      * will be to transferred to `to`.
403      * - when `from` is zero, `amount` tokens will be minted for `to`.
404      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
405      * - `from` and `to` are never both zero.
406      *
407      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
408      */
409     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
410 }
411 
412 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
413 
414 pragma solidity >=0.6.2 <0.8.0;
415 
416 /**
417  * @dev Collection of functions related to the address type
418  */
419 library Address {
420     /**
421      * @dev Returns true if `account` is a contract.
422      *
423      * [IMPORTANT]
424      * ====
425      * It is unsafe to assume that an address for which this function returns
426      * false is an externally-owned account (EOA) and not a contract.
427      *
428      * Among others, `isContract` will return false for the following
429      * types of addresses:
430      *
431      *  - an externally-owned account
432      *  - a contract in construction
433      *  - an address where a contract will be created
434      *  - an address where a contract lived, but was destroyed
435      * ====
436      */
437     function isContract(address account) internal view returns (bool) {
438         // This method relies on extcodesize, which returns 0 for contracts in
439         // construction, since the code is only stored at the end of the
440         // constructor execution.
441 
442         uint256 size;
443         // solhint-disable-next-line no-inline-assembly
444         assembly { size := extcodesize(account) }
445         return size > 0;
446     }
447 
448     /**
449      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
450      * `recipient`, forwarding all available gas and reverting on errors.
451      *
452      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
453      * of certain opcodes, possibly making contracts go over the 2300 gas limit
454      * imposed by `transfer`, making them unable to receive funds via
455      * `transfer`. {sendValue} removes this limitation.
456      *
457      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
458      *
459      * IMPORTANT: because control is transferred to `recipient`, care must be
460      * taken to not create reentrancy vulnerabilities. Consider using
461      * {ReentrancyGuard} or the
462      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
463      */
464     function sendValue(address payable recipient, uint256 amount) internal {
465         require(address(this).balance >= amount, "Address: insufficient balance");
466 
467         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
468         (bool success, ) = recipient.call{ value: amount }("");
469         require(success, "Address: unable to send value, recipient may have reverted");
470     }
471 
472     /**
473      * @dev Performs a Solidity function call using a low level `call`. A
474      * plain`call` is an unsafe replacement for a function call: use this
475      * function instead.
476      *
477      * If `target` reverts with a revert reason, it is bubbled up by this
478      * function (like regular Solidity function calls).
479      *
480      * Returns the raw returned data. To convert to the expected return value,
481      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
482      *
483      * Requirements:
484      *
485      * - `target` must be a contract.
486      * - calling `target` with `data` must not revert.
487      *
488      * _Available since v3.1._
489      */
490     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
491       return functionCall(target, data, "Address: low-level call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
496      * `errorMessage` as a fallback revert reason when `target` reverts.
497      *
498      * _Available since v3.1._
499      */
500     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
501         return functionCallWithValue(target, data, 0, errorMessage);
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
506      * but also transferring `value` wei to `target`.
507      *
508      * Requirements:
509      *
510      * - the calling contract must have an ETH balance of at least `value`.
511      * - the called Solidity function must be `payable`.
512      *
513      * _Available since v3.1._
514      */
515     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
516         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
521      * with `errorMessage` as a fallback revert reason when `target` reverts.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
526         require(address(this).balance >= value, "Address: insufficient balance for call");
527         require(isContract(target), "Address: call to non-contract");
528 
529         // solhint-disable-next-line avoid-low-level-calls
530         (bool success, bytes memory returndata) = target.call{ value: value }(data);
531         return _verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a static call.
537      *
538      * _Available since v3.3._
539      */
540     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
541         return functionStaticCall(target, data, "Address: low-level static call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
551         require(isContract(target), "Address: static call to non-contract");
552 
553         // solhint-disable-next-line avoid-low-level-calls
554         (bool success, bytes memory returndata) = target.staticcall(data);
555         return _verifyCallResult(success, returndata, errorMessage);
556     }
557 
558     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
559         if (success) {
560             return returndata;
561         } else {
562             // Look for revert reason and bubble it up if present
563             if (returndata.length > 0) {
564                 // The easiest way to bubble the revert reason is using memory via assembly
565 
566                 // solhint-disable-next-line no-inline-assembly
567                 assembly {
568                     let returndata_size := mload(returndata)
569                     revert(add(32, returndata), returndata_size)
570                 }
571             } else {
572                 revert(errorMessage);
573             }
574         }
575     }
576 }
577 
578 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
579 
580 pragma solidity >=0.6.0 <0.8.0;
581 
582 
583 
584 
585 /**
586  * @title SafeERC20
587  * @dev Wrappers around ERC20 operations that throw on failure (when the token
588  * contract returns false). Tokens that return no value (and instead revert or
589  * throw on failure) are also supported, non-reverting calls are assumed to be
590  * successful.
591  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
592  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
593  */
594 library SafeERC20 {
595     using SafeMath for uint256;
596     using Address for address;
597 
598     function safeTransfer(IERC20 token, address to, uint256 value) internal {
599         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
600     }
601 
602     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
603         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
604     }
605 
606     /**
607      * @dev Deprecated. This function has issues similar to the ones found in
608      * {IERC20-approve}, and its usage is discouraged.
609      *
610      * Whenever possible, use {safeIncreaseAllowance} and
611      * {safeDecreaseAllowance} instead.
612      */
613     function safeApprove(IERC20 token, address spender, uint256 value) internal {
614         // safeApprove should only be called when setting an initial allowance,
615         // or when resetting it to zero. To increase and decrease it, use
616         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
617         // solhint-disable-next-line max-line-length
618         require((value == 0) || (token.allowance(address(this), spender) == 0),
619             "SafeERC20: approve from non-zero to non-zero allowance"
620         );
621         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
622     }
623 
624     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
625         uint256 newAllowance = token.allowance(address(this), spender).add(value);
626         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
627     }
628 
629     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
630         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
631         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
632     }
633 
634     /**
635      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
636      * on the return value: the return value is optional (but if data is returned, it must not be false).
637      * @param token The token targeted by the call.
638      * @param data The call data (encoded using abi.encode or one of its variants).
639      */
640     function _callOptionalReturn(IERC20 token, bytes memory data) private {
641         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
642         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
643         // the target address contains contract code and also asserts for success in the low-level call.
644 
645         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
646         if (returndata.length > 0) { // Return data is optional
647             // solhint-disable-next-line max-line-length
648             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
649         }
650     }
651 }
652 
653 // File: @openzeppelin\contracts\math\SafeMath.sol
654 
655 pragma solidity >=0.6.0 <0.8.0;
656 
657 /**
658  * @dev Wrappers over Solidity's arithmetic operations with added overflow
659  * checks.
660  *
661  * Arithmetic operations in Solidity wrap on overflow. This can easily result
662  * in bugs, because programmers usually assume that an overflow raises an
663  * error, which is the standard behavior in high level programming languages.
664  * `SafeMath` restores this intuition by reverting the transaction when an
665  * operation overflows.
666  *
667  * Using this library instead of the unchecked operations eliminates an entire
668  * class of bugs, so it's recommended to use it always.
669  */
670 library SafeMath {
671     /**
672      * @dev Returns the addition of two unsigned integers, reverting on
673      * overflow.
674      *
675      * Counterpart to Solidity's `+` operator.
676      *
677      * Requirements:
678      *
679      * - Addition cannot overflow.
680      */
681     function add(uint256 a, uint256 b) internal pure returns (uint256) {
682         uint256 c = a + b;
683         require(c >= a, "SafeMath: addition overflow");
684 
685         return c;
686     }
687 
688     /**
689      * @dev Returns the subtraction of two unsigned integers, reverting on
690      * overflow (when the result is negative).
691      *
692      * Counterpart to Solidity's `-` operator.
693      *
694      * Requirements:
695      *
696      * - Subtraction cannot overflow.
697      */
698     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
699         return sub(a, b, "SafeMath: subtraction overflow");
700     }
701 
702     /**
703      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
704      * overflow (when the result is negative).
705      *
706      * Counterpart to Solidity's `-` operator.
707      *
708      * Requirements:
709      *
710      * - Subtraction cannot overflow.
711      */
712     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
713         require(b <= a, errorMessage);
714         uint256 c = a - b;
715 
716         return c;
717     }
718 
719     /**
720      * @dev Returns the multiplication of two unsigned integers, reverting on
721      * overflow.
722      *
723      * Counterpart to Solidity's `*` operator.
724      *
725      * Requirements:
726      *
727      * - Multiplication cannot overflow.
728      */
729     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
730         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
731         // benefit is lost if 'b' is also tested.
732         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
733         if (a == 0) {
734             return 0;
735         }
736 
737         uint256 c = a * b;
738         require(c / a == b, "SafeMath: multiplication overflow");
739 
740         return c;
741     }
742 
743     /**
744      * @dev Returns the integer division of two unsigned integers. Reverts on
745      * division by zero. The result is rounded towards zero.
746      *
747      * Counterpart to Solidity's `/` operator. Note: this function uses a
748      * `revert` opcode (which leaves remaining gas untouched) while Solidity
749      * uses an invalid opcode to revert (consuming all remaining gas).
750      *
751      * Requirements:
752      *
753      * - The divisor cannot be zero.
754      */
755     function div(uint256 a, uint256 b) internal pure returns (uint256) {
756         return div(a, b, "SafeMath: division by zero");
757     }
758 
759     /**
760      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
761      * division by zero. The result is rounded towards zero.
762      *
763      * Counterpart to Solidity's `/` operator. Note: this function uses a
764      * `revert` opcode (which leaves remaining gas untouched) while Solidity
765      * uses an invalid opcode to revert (consuming all remaining gas).
766      *
767      * Requirements:
768      *
769      * - The divisor cannot be zero.
770      */
771     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
772         require(b > 0, errorMessage);
773         uint256 c = a / b;
774         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
775 
776         return c;
777     }
778 
779     /**
780      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
781      * Reverts when dividing by zero.
782      *
783      * Counterpart to Solidity's `%` operator. This function uses a `revert`
784      * opcode (which leaves remaining gas untouched) while Solidity uses an
785      * invalid opcode to revert (consuming all remaining gas).
786      *
787      * Requirements:
788      *
789      * - The divisor cannot be zero.
790      */
791     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
792         return mod(a, b, "SafeMath: modulo by zero");
793     }
794 
795     /**
796      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
797      * Reverts with custom message when dividing by zero.
798      *
799      * Counterpart to Solidity's `%` operator. This function uses a `revert`
800      * opcode (which leaves remaining gas untouched) while Solidity uses an
801      * invalid opcode to revert (consuming all remaining gas).
802      *
803      * Requirements:
804      *
805      * - The divisor cannot be zero.
806      */
807     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
808         require(b != 0, errorMessage);
809         return a % b;
810     }
811 }
812 
813 // File: contracts\Token.sol
814 
815 pragma solidity 0.6.11;
816 
817 
818 
819 
820 contract GamyFi is ERC20 {
821     using SafeERC20 for IERC20;
822     using Address for address;
823     using SafeMath for uint256;
824     uint256 public _maxSupply = 0;
825 
826     address public governance;
827     mapping(address => bool) public minters;
828 
829     constructor() public ERC20("GamyFi", "GFX") {
830         governance = msg.sender;
831         _maxSupply = 10000000 * (10**18);
832     }
833 
834     function mint(address account, uint256 amount) public {
835         require(minters[msg.sender], "!minter");
836 
837         uint256 totalSupply = totalSupply();
838         totalSupply = totalSupply.add(amount);
839 
840         require(totalSupply <= _maxSupply, "supply is max!");
841 
842         _mint(account, amount);
843     }
844 
845     function burn(uint256 amount) public {
846         _burn(msg.sender, amount);
847     }
848 
849     function setGovernance(address _governance) public {
850         require(msg.sender == governance, "!governance");
851         governance = _governance;
852     }
853 
854     function addMinter(address _minter) public {
855         require(msg.sender == governance, "!governance");
856         minters[_minter] = true;
857     }
858 
859     function removeMinter(address _minter) public {
860         require(msg.sender == governance, "!governance");
861         minters[_minter] = false;
862     }
863 }