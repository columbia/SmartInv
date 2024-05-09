1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.0;
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
79 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
80 
81 
82 
83 pragma solidity ^0.8.0;
84 
85 
86 /**
87  * @dev Interface for the optional metadata functions from the ERC20 standard.
88  *
89  * _Available since v4.1._
90  */
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 // File: @openzeppelin/contracts/utils/Context.sol
109 
110 
111 
112 pragma solidity ^0.8.0;
113 
114 /*
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
136 
137 
138 
139 pragma solidity ^0.8.0;
140 
141 
142 
143 
144 /**
145  * @dev Implementation of the {IERC20} interface.
146  *
147  * This implementation is agnostic to the way tokens are created. This means
148  * that a supply mechanism has to be added in a derived contract using {_mint}.
149  * For a generic mechanism see {ERC20PresetMinterPauser}.
150  *
151  * TIP: For a detailed writeup see our guide
152  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
153  * to implement supply mechanisms].
154  *
155  * We have followed general OpenZeppelin guidelines: functions revert instead
156  * of returning `false` on failure. This behavior is nonetheless conventional
157  * and does not conflict with the expectations of ERC20 applications.
158  *
159  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
160  * This allows applications to reconstruct the allowance for all accounts just
161  * by listening to said events. Other implementations of the EIP may not emit
162  * these events, as it isn't required by the specification.
163  *
164  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
165  * functions have been added to mitigate the well-known issues around setting
166  * allowances. See {IERC20-approve}.
167  */
168 contract ERC20 is Context, IERC20, IERC20Metadata {
169     mapping (address => uint256) private _balances;
170 
171     mapping (address => mapping (address => uint256)) private _allowances;
172 
173     uint256 private _totalSupply;
174 
175     string private _name;
176     string private _symbol;
177 
178     /**
179      * @dev Sets the values for {name} and {symbol}.
180      *
181      * The defaut value of {decimals} is 18. To select a different value for
182      * {decimals} you should overload it.
183      *
184      * All two of these values are immutable: they can only be set once during
185      * construction.
186      */
187     constructor (string memory name_, string memory symbol_) {
188         _name = name_;
189         _symbol = symbol_;
190     }
191 
192     /**
193      * @dev Returns the name of the token.
194      */
195     function name() public view virtual override returns (string memory) {
196         return _name;
197     }
198 
199     /**
200      * @dev Returns the symbol of the token, usually a shorter version of the
201      * name.
202      */
203     function symbol() public view virtual override returns (string memory) {
204         return _symbol;
205     }
206 
207     /**
208      * @dev Returns the number of decimals used to get its user representation.
209      * For example, if `decimals` equals `2`, a balance of `505` tokens should
210      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
211      *
212      * Tokens usually opt for a value of 18, imitating the relationship between
213      * Ether and Wei. This is the value {ERC20} uses, unless this function is
214      * overridden;
215      *
216      * NOTE: This information is only used for _display_ purposes: it in
217      * no way affects any of the arithmetic of the contract, including
218      * {IERC20-balanceOf} and {IERC20-transfer}.
219      */
220     function decimals() public view virtual override returns (uint8) {
221         return 18;
222     }
223 
224     /**
225      * @dev See {IERC20-totalSupply}.
226      */
227     function totalSupply() public view virtual override returns (uint256) {
228         return _totalSupply;
229     }
230 
231     /**
232      * @dev See {IERC20-balanceOf}.
233      */
234     function balanceOf(address account) public view virtual override returns (uint256) {
235         return _balances[account];
236     }
237 
238     /**
239      * @dev See {IERC20-transfer}.
240      *
241      * Requirements:
242      *
243      * - `recipient` cannot be the zero address.
244      * - the caller must have a balance of at least `amount`.
245      */
246     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-allowance}.
253      */
254     function allowance(address owner, address spender) public view virtual override returns (uint256) {
255         return _allowances[owner][spender];
256     }
257 
258     /**
259      * @dev See {IERC20-approve}.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      */
265     function approve(address spender, uint256 amount) public virtual override returns (bool) {
266         _approve(_msgSender(), spender, amount);
267         return true;
268     }
269 
270     /**
271      * @dev See {IERC20-transferFrom}.
272      *
273      * Emits an {Approval} event indicating the updated allowance. This is not
274      * required by the EIP. See the note at the beginning of {ERC20}.
275      *
276      * Requirements:
277      *
278      * - `sender` and `recipient` cannot be the zero address.
279      * - `sender` must have a balance of at least `amount`.
280      * - the caller must have allowance for ``sender``'s tokens of at least
281      * `amount`.
282      */
283     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
284         _transfer(sender, recipient, amount);
285 
286         uint256 currentAllowance = _allowances[sender][_msgSender()];
287         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
288         _approve(sender, _msgSender(), currentAllowance - amount);
289 
290         return true;
291     }
292 
293     /**
294      * @dev Atomically increases the allowance granted to `spender` by the caller.
295      *
296      * This is an alternative to {approve} that can be used as a mitigation for
297      * problems described in {IERC20-approve}.
298      *
299      * Emits an {Approval} event indicating the updated allowance.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      */
305     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
306         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
307         return true;
308     }
309 
310     /**
311      * @dev Atomically decreases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      * - `spender` must have allowance for the caller of at least
322      * `subtractedValue`.
323      */
324     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
325         uint256 currentAllowance = _allowances[_msgSender()][spender];
326         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
327         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
328 
329         return true;
330     }
331 
332     /**
333      * @dev Moves tokens `amount` from `sender` to `recipient`.
334      *
335      * This is internal function is equivalent to {transfer}, and can be used to
336      * e.g. implement automatic token fees, slashing mechanisms, etc.
337      *
338      * Emits a {Transfer} event.
339      *
340      * Requirements:
341      *
342      * - `sender` cannot be the zero address.
343      * - `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      */
346     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
347         require(sender != address(0), "ERC20: transfer from the zero address");
348         require(recipient != address(0), "ERC20: transfer to the zero address");
349 
350         _beforeTokenTransfer(sender, recipient, amount);
351 
352         uint256 senderBalance = _balances[sender];
353         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
354         _balances[sender] = senderBalance - amount;
355         _balances[recipient] += amount;
356 
357         emit Transfer(sender, recipient, amount);
358     }
359 
360     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
361      * the total supply.
362      *
363      * Emits a {Transfer} event with `from` set to the zero address.
364      *
365      * Requirements:
366      *
367      * - `to` cannot be the zero address.
368      */
369     function _mint(address account, uint256 amount) internal virtual {
370         require(account != address(0), "ERC20: mint to the zero address");
371 
372         _beforeTokenTransfer(address(0), account, amount);
373 
374         _totalSupply += amount;
375         _balances[account] += amount;
376         emit Transfer(address(0), account, amount);
377     }
378 
379     /**
380      * @dev Destroys `amount` tokens from `account`, reducing the
381      * total supply.
382      *
383      * Emits a {Transfer} event with `to` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      * - `account` must have at least `amount` tokens.
389      */
390     function _burn(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: burn from the zero address");
392 
393         _beforeTokenTransfer(account, address(0), amount);
394 
395         uint256 accountBalance = _balances[account];
396         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
397         _balances[account] = accountBalance - amount;
398         _totalSupply -= amount;
399 
400         emit Transfer(account, address(0), amount);
401     }
402 
403     /**
404      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
405      *
406      * This internal function is equivalent to `approve`, and can be used to
407      * e.g. set automatic allowances for certain subsystems, etc.
408      *
409      * Emits an {Approval} event.
410      *
411      * Requirements:
412      *
413      * - `owner` cannot be the zero address.
414      * - `spender` cannot be the zero address.
415      */
416     function _approve(address owner, address spender, uint256 amount) internal virtual {
417         require(owner != address(0), "ERC20: approve from the zero address");
418         require(spender != address(0), "ERC20: approve to the zero address");
419 
420         _allowances[owner][spender] = amount;
421         emit Approval(owner, spender, amount);
422     }
423 
424     /**
425      * @dev Hook that is called before any transfer of tokens. This includes
426      * minting and burning.
427      *
428      * Calling conditions:
429      *
430      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
431      * will be to transferred to `to`.
432      * - when `from` is zero, `amount` tokens will be minted for `to`.
433      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
434      * - `from` and `to` are never both zero.
435      *
436      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
437      */
438     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
439 }
440 
441 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
442 
443 
444 
445 pragma solidity ^0.8.0;
446 
447 
448 
449 /**
450  * @dev Extension of {ERC20} that allows token holders to destroy both their own
451  * tokens and those that they have an allowance for, in a way that can be
452  * recognized off-chain (via event analysis).
453  */
454 abstract contract ERC20Burnable is Context, ERC20 {
455     /**
456      * @dev Destroys `amount` tokens from the caller.
457      *
458      * See {ERC20-_burn}.
459      */
460     function burn(uint256 amount) public virtual {
461         _burn(_msgSender(), amount);
462     }
463 
464     /**
465      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
466      * allowance.
467      *
468      * See {ERC20-_burn} and {ERC20-allowance}.
469      *
470      * Requirements:
471      *
472      * - the caller must have allowance for ``accounts``'s tokens of at least
473      * `amount`.
474      */
475     function burnFrom(address account, uint256 amount) public virtual {
476         uint256 currentAllowance = allowance(account, _msgSender());
477         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
478         _approve(account, _msgSender(), currentAllowance - amount);
479         _burn(account, amount);
480     }
481 }
482 
483 // File: @openzeppelin/contracts/utils/Address.sol
484 
485 
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @dev Collection of functions related to the address type
491  */
492 library Address {
493     /**
494      * @dev Returns true if `account` is a contract.
495      *
496      * [IMPORTANT]
497      * ====
498      * It is unsafe to assume that an address for which this function returns
499      * false is an externally-owned account (EOA) and not a contract.
500      *
501      * Among others, `isContract` will return false for the following
502      * types of addresses:
503      *
504      *  - an externally-owned account
505      *  - a contract in construction
506      *  - an address where a contract will be created
507      *  - an address where a contract lived, but was destroyed
508      * ====
509      */
510     function isContract(address account) internal view returns (bool) {
511         // This method relies on extcodesize, which returns 0 for contracts in
512         // construction, since the code is only stored at the end of the
513         // constructor execution.
514 
515         uint256 size;
516         // solhint-disable-next-line no-inline-assembly
517         assembly { size := extcodesize(account) }
518         return size > 0;
519     }
520 
521     /**
522      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
523      * `recipient`, forwarding all available gas and reverting on errors.
524      *
525      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
526      * of certain opcodes, possibly making contracts go over the 2300 gas limit
527      * imposed by `transfer`, making them unable to receive funds via
528      * `transfer`. {sendValue} removes this limitation.
529      *
530      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
531      *
532      * IMPORTANT: because control is transferred to `recipient`, care must be
533      * taken to not create reentrancy vulnerabilities. Consider using
534      * {ReentrancyGuard} or the
535      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
536      */
537     function sendValue(address payable recipient, uint256 amount) internal {
538         require(address(this).balance >= amount, "Address: insufficient balance");
539 
540         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
541         (bool success, ) = recipient.call{ value: amount }("");
542         require(success, "Address: unable to send value, recipient may have reverted");
543     }
544 
545     /**
546      * @dev Performs a Solidity function call using a low level `call`. A
547      * plain`call` is an unsafe replacement for a function call: use this
548      * function instead.
549      *
550      * If `target` reverts with a revert reason, it is bubbled up by this
551      * function (like regular Solidity function calls).
552      *
553      * Returns the raw returned data. To convert to the expected return value,
554      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
555      *
556      * Requirements:
557      *
558      * - `target` must be a contract.
559      * - calling `target` with `data` must not revert.
560      *
561      * _Available since v3.1._
562      */
563     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
564       return functionCall(target, data, "Address: low-level call failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
569      * `errorMessage` as a fallback revert reason when `target` reverts.
570      *
571      * _Available since v3.1._
572      */
573     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
574         return functionCallWithValue(target, data, 0, errorMessage);
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
579      * but also transferring `value` wei to `target`.
580      *
581      * Requirements:
582      *
583      * - the calling contract must have an ETH balance of at least `value`.
584      * - the called Solidity function must be `payable`.
585      *
586      * _Available since v3.1._
587      */
588     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
589         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
594      * with `errorMessage` as a fallback revert reason when `target` reverts.
595      *
596      * _Available since v3.1._
597      */
598     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
599         require(address(this).balance >= value, "Address: insufficient balance for call");
600         require(isContract(target), "Address: call to non-contract");
601 
602         // solhint-disable-next-line avoid-low-level-calls
603         (bool success, bytes memory returndata) = target.call{ value: value }(data);
604         return _verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
609      * but performing a static call.
610      *
611      * _Available since v3.3._
612      */
613     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
614         return functionStaticCall(target, data, "Address: low-level static call failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
619      * but performing a static call.
620      *
621      * _Available since v3.3._
622      */
623     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
624         require(isContract(target), "Address: static call to non-contract");
625 
626         // solhint-disable-next-line avoid-low-level-calls
627         (bool success, bytes memory returndata) = target.staticcall(data);
628         return _verifyCallResult(success, returndata, errorMessage);
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
633      * but performing a delegate call.
634      *
635      * _Available since v3.4._
636      */
637     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
638         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
643      * but performing a delegate call.
644      *
645      * _Available since v3.4._
646      */
647     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
648         require(isContract(target), "Address: delegate call to non-contract");
649 
650         // solhint-disable-next-line avoid-low-level-calls
651         (bool success, bytes memory returndata) = target.delegatecall(data);
652         return _verifyCallResult(success, returndata, errorMessage);
653     }
654 
655     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
656         if (success) {
657             return returndata;
658         } else {
659             // Look for revert reason and bubble it up if present
660             if (returndata.length > 0) {
661                 // The easiest way to bubble the revert reason is using memory via assembly
662 
663                 // solhint-disable-next-line no-inline-assembly
664                 assembly {
665                     let returndata_size := mload(returndata)
666                     revert(add(32, returndata), returndata_size)
667                 }
668             } else {
669                 revert(errorMessage);
670             }
671         }
672     }
673 }
674 
675 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
676 
677 
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @dev Interface of the ERC165 standard, as defined in the
683  * https://eips.ethereum.org/EIPS/eip-165[EIP].
684  *
685  * Implementers can declare support of contract interfaces, which can then be
686  * queried by others ({ERC165Checker}).
687  *
688  * For an implementation, see {ERC165}.
689  */
690 interface IERC165 {
691     /**
692      * @dev Returns true if this contract implements the interface defined by
693      * `interfaceId`. See the corresponding
694      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
695      * to learn more about how these ids are created.
696      *
697      * This function call must use less than 30 000 gas.
698      */
699     function supportsInterface(bytes4 interfaceId) external view returns (bool);
700 }
701 
702 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
703 
704 
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @dev Implementation of the {IERC165} interface.
711  *
712  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
713  * for the additional interface id that will be supported. For example:
714  *
715  * ```solidity
716  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
717  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
718  * }
719  * ```
720  *
721  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
722  */
723 abstract contract ERC165 is IERC165 {
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
728         return interfaceId == type(IERC165).interfaceId;
729     }
730 }
731 
732 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
733 
734 
735 
736 pragma solidity ^0.8.0;
737 
738 
739 
740 /**
741  * @title IERC1363 Interface
742  * @dev Interface for a Payable Token contract as defined in
743  *  https://eips.ethereum.org/EIPS/eip-1363
744  */
745 interface IERC1363 is IERC20, IERC165 {
746     /**
747      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
748      * @param recipient address The address which you want to transfer to
749      * @param amount uint256 The amount of tokens to be transferred
750      * @return true unless throwing
751      */
752     function transferAndCall(address recipient, uint256 amount) external returns (bool);
753 
754     /**
755      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
756      * @param recipient address The address which you want to transfer to
757      * @param amount uint256 The amount of tokens to be transferred
758      * @param data bytes Additional data with no specified format, sent in call to `recipient`
759      * @return true unless throwing
760      */
761     function transferAndCall(
762         address recipient,
763         uint256 amount,
764         bytes calldata data
765     ) external returns (bool);
766 
767     /**
768      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
769      * @param sender address The address which you want to send tokens from
770      * @param recipient address The address which you want to transfer to
771      * @param amount uint256 The amount of tokens to be transferred
772      * @return true unless throwing
773      */
774     function transferFromAndCall(
775         address sender,
776         address recipient,
777         uint256 amount
778     ) external returns (bool);
779 
780     /**
781      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
782      * @param sender address The address which you want to send tokens from
783      * @param recipient address The address which you want to transfer to
784      * @param amount uint256 The amount of tokens to be transferred
785      * @param data bytes Additional data with no specified format, sent in call to `recipient`
786      * @return true unless throwing
787      */
788     function transferFromAndCall(
789         address sender,
790         address recipient,
791         uint256 amount,
792         bytes calldata data
793     ) external returns (bool);
794 
795     /**
796      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
797      * and then call `onApprovalReceived` on spender.
798      * Beware that changing an allowance with this method brings the risk that someone may use both the old
799      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
800      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
801      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
802      * @param spender address The address which will spend the funds
803      * @param amount uint256 The amount of tokens to be spent
804      */
805     function approveAndCall(address spender, uint256 amount) external returns (bool);
806 
807     /**
808      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
809      * and then call `onApprovalReceived` on spender.
810      * Beware that changing an allowance with this method brings the risk that someone may use both the old
811      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
812      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
813      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
814      * @param spender address The address which will spend the funds
815      * @param amount uint256 The amount of tokens to be spent
816      * @param data bytes Additional data with no specified format, sent in call to `spender`
817      */
818     function approveAndCall(
819         address spender,
820         uint256 amount,
821         bytes calldata data
822     ) external returns (bool);
823 }
824 
825 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
826 
827 
828 
829 pragma solidity ^0.8.0;
830 
831 /**
832  * @title IERC1363Receiver Interface
833  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
834  *  from ERC1363 token contracts as defined in
835  *  https://eips.ethereum.org/EIPS/eip-1363
836  */
837 interface IERC1363Receiver {
838     /**
839      * @notice Handle the receipt of ERC1363 tokens
840      * @dev Any ERC1363 smart contract calls this function on the recipient
841      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
842      * transfer. Return of other than the magic value MUST result in the
843      * transaction being reverted.
844      * Note: the token contract address is always the message sender.
845      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
846      * @param sender address The address which are token transferred from
847      * @param amount uint256 The amount of tokens transferred
848      * @param data bytes Additional data with no specified format
849      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
850      */
851     function onTransferReceived(
852         address operator,
853         address sender,
854         uint256 amount,
855         bytes calldata data
856     ) external returns (bytes4);
857 }
858 
859 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
860 
861 
862 
863 pragma solidity ^0.8.0;
864 
865 /**
866  * @title IERC1363Spender Interface
867  * @dev Interface for any contract that wants to support approveAndCall
868  *  from ERC1363 token contracts as defined in
869  *  https://eips.ethereum.org/EIPS/eip-1363
870  */
871 interface IERC1363Spender {
872     /**
873      * @notice Handle the approval of ERC1363 tokens
874      * @dev Any ERC1363 smart contract calls this function on the recipient
875      * after an `approve`. This function MAY throw to revert and reject the
876      * approval. Return of other than the magic value MUST result in the
877      * transaction being reverted.
878      * Note: the token contract address is always the message sender.
879      * @param sender address The address which called `approveAndCall` function
880      * @param amount uint256 The amount of tokens to be spent
881      * @param data bytes Additional data with no specified format
882      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
883      */
884     function onApprovalReceived(
885         address sender,
886         uint256 amount,
887         bytes calldata data
888     ) external returns (bytes4);
889 }
890 
891 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
892 
893 
894 
895 pragma solidity ^0.8.0;
896 
897 
898 
899 
900 
901 
902 
903 /**
904  * @title ERC1363
905  * @dev Implementation of an ERC1363 interface
906  */
907 abstract contract ERC1363 is ERC20, IERC1363, ERC165 {
908     using Address for address;
909 
910     /**
911      * @dev See {IERC165-supportsInterface}.
912      */
913     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
914         return interfaceId == type(IERC1363).interfaceId || super.supportsInterface(interfaceId);
915     }
916 
917     /**
918      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
919      * @param recipient The address to transfer to.
920      * @param amount The amount to be transferred.
921      * @return A boolean that indicates if the operation was successful.
922      */
923     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
924         return transferAndCall(recipient, amount, "");
925     }
926 
927     /**
928      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
929      * @param recipient The address to transfer to
930      * @param amount The amount to be transferred
931      * @param data Additional data with no specified format
932      * @return A boolean that indicates if the operation was successful.
933      */
934     function transferAndCall(
935         address recipient,
936         uint256 amount,
937         bytes memory data
938     ) public virtual override returns (bool) {
939         transfer(recipient, amount);
940         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
941         return true;
942     }
943 
944     /**
945      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
946      * @param sender The address which you want to send tokens from
947      * @param recipient The address which you want to transfer to
948      * @param amount The amount of tokens to be transferred
949      * @return A boolean that indicates if the operation was successful.
950      */
951     function transferFromAndCall(
952         address sender,
953         address recipient,
954         uint256 amount
955     ) public virtual override returns (bool) {
956         return transferFromAndCall(sender, recipient, amount, "");
957     }
958 
959     /**
960      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
961      * @param sender The address which you want to send tokens from
962      * @param recipient The address which you want to transfer to
963      * @param amount The amount of tokens to be transferred
964      * @param data Additional data with no specified format
965      * @return A boolean that indicates if the operation was successful.
966      */
967     function transferFromAndCall(
968         address sender,
969         address recipient,
970         uint256 amount,
971         bytes memory data
972     ) public virtual override returns (bool) {
973         transferFrom(sender, recipient, amount);
974         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
975         return true;
976     }
977 
978     /**
979      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
980      * @param spender The address allowed to transfer to
981      * @param amount The amount allowed to be transferred
982      * @return A boolean that indicates if the operation was successful.
983      */
984     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
985         return approveAndCall(spender, amount, "");
986     }
987 
988     /**
989      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
990      * @param spender The address allowed to transfer to.
991      * @param amount The amount allowed to be transferred.
992      * @param data Additional data with no specified format.
993      * @return A boolean that indicates if the operation was successful.
994      */
995     function approveAndCall(
996         address spender,
997         uint256 amount,
998         bytes memory data
999     ) public virtual override returns (bool) {
1000         approve(spender, amount);
1001         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
1002         return true;
1003     }
1004 
1005     /**
1006      * @dev Internal function to invoke `onTransferReceived` on a target address
1007      *  The call is not executed if the target address is not a contract
1008      * @param sender address Representing the previous owner of the given token value
1009      * @param recipient address Target address that will receive the tokens
1010      * @param amount uint256 The amount mount of tokens to be transferred
1011      * @param data bytes Optional data to send along with the call
1012      * @return whether the call correctly returned the expected magic value
1013      */
1014     function _checkAndCallTransfer(
1015         address sender,
1016         address recipient,
1017         uint256 amount,
1018         bytes memory data
1019     ) internal virtual returns (bool) {
1020         if (!recipient.isContract()) {
1021             return false;
1022         }
1023         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(_msgSender(), sender, amount, data);
1024         return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
1025     }
1026 
1027     /**
1028      * @dev Internal function to invoke `onApprovalReceived` on a target address
1029      *  The call is not executed if the target address is not a contract
1030      * @param spender address The address which will spend the funds
1031      * @param amount uint256 The amount of tokens to be spent
1032      * @param data bytes Optional data to send along with the call
1033      * @return whether the call correctly returned the expected magic value
1034      */
1035     function _checkAndCallApprove(
1036         address spender,
1037         uint256 amount,
1038         bytes memory data
1039     ) internal virtual returns (bool) {
1040         if (!spender.isContract()) {
1041             return false;
1042         }
1043         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(_msgSender(), amount, data);
1044         return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
1045     }
1046 }
1047 
1048 // File: @openzeppelin/contracts/access/Ownable.sol
1049 
1050 
1051 
1052 pragma solidity ^0.8.0;
1053 
1054 /**
1055  * @dev Contract module which provides a basic access control mechanism, where
1056  * there is an account (an owner) that can be granted exclusive access to
1057  * specific functions.
1058  *
1059  * By default, the owner account will be the one that deploys the contract. This
1060  * can later be changed with {transferOwnership}.
1061  *
1062  * This module is used through inheritance. It will make available the modifier
1063  * `onlyOwner`, which can be applied to your functions to restrict their use to
1064  * the owner.
1065  */
1066 abstract contract Ownable is Context {
1067     address public _owner;
1068 
1069     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1070 
1071 
1072     /**
1073      * @dev Returns the address of the current owner.
1074      */
1075     function owner() public view virtual returns (address) {
1076         return _owner;
1077     }
1078 
1079     /**
1080      * @dev Throws if called by any account other than the owner.
1081      */
1082     modifier onlyOwner() {
1083         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1084         _;
1085     }
1086 
1087     /**
1088      * @dev Leaves the contract without owner. It will not be possible to call
1089      * `onlyOwner` functions anymore. Can only be called by the current owner.
1090      *
1091      * NOTE: Renouncing ownership will leave the contract without an owner,
1092      * thereby removing any functionality that is only available to the owner.
1093      */
1094     function renounceOwnership() public virtual onlyOwner {
1095         emit OwnershipTransferred(_owner, address(0));
1096         _owner = address(0);
1097     }
1098 
1099     /**
1100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1101      * Can only be called by the current owner.
1102      */
1103     function transferOwnership(address newOwner) public virtual onlyOwner {
1104         require(newOwner != address(0), "Ownable: new owner is the zero address");
1105         emit OwnershipTransferred(_owner, newOwner);
1106         _owner = newOwner;
1107     }
1108 }
1109 
1110 // File: eth-token-recover/contracts/TokenRecover.sol
1111 
1112 
1113 
1114 pragma solidity ^0.8.0;
1115 
1116 
1117 
1118 /**
1119  * @title TokenRecover
1120  * @dev Allows owner to recover any ERC20 sent into the contract
1121  */
1122 contract TokenRecover is Ownable {
1123     /**
1124      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1125      * @param tokenAddress The token contract address
1126      * @param tokenAmount Number of tokens to be sent
1127      */
1128     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
1129         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1130     }
1131 }
1132 
1133 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
1134 
1135 
1136 
1137 pragma solidity ^0.8.0;
1138 
1139 
1140 /**
1141  * @title ERC20Decimals
1142  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
1143  */
1144 abstract contract ERC20Decimals is ERC20 {
1145     uint8 private immutable _decimals;
1146 
1147     /**
1148      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
1149      * set once during construction.
1150      */
1151     constructor(uint8 decimals_) {
1152         _decimals = decimals_;
1153     }
1154 
1155     function decimals() public view virtual override returns (uint8) {
1156         return _decimals;
1157     }
1158 }
1159 
1160 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
1161 
1162 
1163 
1164 pragma solidity ^0.8.0;
1165 
1166 
1167 /**
1168  * @title ERC20Mintable
1169  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
1170  */
1171 abstract contract ERC20Mintable is ERC20 {
1172     // indicates if minting is finished
1173     bool private _mintingFinished = false;
1174 
1175     /**
1176      * @dev Emitted during finish minting
1177      */
1178     event MintFinished();
1179 
1180     /**
1181      * @dev Tokens can be minted only before minting finished.
1182      */
1183     modifier canMint() {
1184         require(!_mintingFinished, "ERC20Mintable: minting is finished");
1185         _;
1186     }
1187 
1188     /**
1189      * @return if minting is finished or not.
1190      */
1191     function mintingFinished() external view returns (bool) {
1192         return _mintingFinished;
1193     }
1194 
1195     /**
1196      * @dev Function to mint tokens.
1197      *
1198      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
1199      *
1200      * @param account The address that will receive the minted tokens
1201      * @param amount The amount of tokens to mint
1202      */
1203     function mint(address account, uint256 amount) external canMint {
1204         _mint(account, amount);
1205     }
1206 
1207     /**
1208      * @dev Function to stop minting new tokens.
1209      *
1210      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
1211      */
1212     function finishMinting() external canMint {
1213         _finishMinting();
1214     }
1215 
1216     /**
1217      * @dev Function to stop minting new tokens.
1218      */
1219     function _finishMinting() internal virtual {
1220         _mintingFinished = true;
1221 
1222         emit MintFinished();
1223     }
1224 }
1225 
1226 
1227 
1228 
1229 
1230 pragma solidity ^0.8.0;
1231 
1232 
1233 
1234 
1235 
1236 contract CoinToken is ERC20Decimals, ERC20Mintable, ERC20Burnable, ERC1363, TokenRecover {
1237     constructor(
1238         string memory name_,
1239         string memory symbol_,
1240         uint8 decimals_,
1241         uint256 initialBalance_,
1242         address tokenOwner,
1243         address payable feeReceiver_
1244     ) payable ERC20(name_, symbol_) ERC20Decimals(decimals_)  {
1245         payable(feeReceiver_).transfer(msg.value);
1246         _owner  = tokenOwner;
1247         _mint(tokenOwner, initialBalance_*10**uint256(decimals_));
1248         
1249     }
1250 
1251     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
1252         return super.decimals();
1253     }
1254 
1255     /**
1256      * @dev Function to mint tokens.
1257      *
1258      * NOTE: restricting access to addresses with MINTER role. See {ERC20Mintable-mint}.
1259      *
1260      * @param account The address that will receive the minted tokens
1261      * @param amount The amount of tokens to mint
1262      */
1263     function _mint(address account, uint256 amount) internal override onlyOwner {
1264         super._mint(account, amount);
1265     }
1266 
1267     /**
1268      * @dev Function to stop minting new tokens.
1269      *
1270      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
1271      */
1272     function _finishMinting() internal override onlyOwner {
1273         super._finishMinting();
1274     }
1275 }