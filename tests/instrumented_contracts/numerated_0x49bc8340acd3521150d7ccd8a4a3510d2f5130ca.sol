1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
89 
90 
91 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 
96 /**
97  * @dev Interface for the optional metadata functions from the ERC20 standard.
98  *
99  * _Available since v4.1._
100  */
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 // File: @openzeppelin/contracts/utils/Context.sol
119 
120 
121 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 
154 
155 /**
156  * @dev Implementation of the {IERC20} interface.
157  *
158  * This implementation is agnostic to the way tokens are created. This means
159  * that a supply mechanism has to be added in a derived contract using {_mint}.
160  * For a generic mechanism see {ERC20PresetMinterPauser}.
161  *
162  * TIP: For a detailed writeup see our guide
163  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
164  * to implement supply mechanisms].
165  *
166  * We have followed general OpenZeppelin Contracts guidelines: functions revert
167  * instead returning `false` on failure. This behavior is nonetheless
168  * conventional and does not conflict with the expectations of ERC20
169  * applications.
170  *
171  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
172  * This allows applications to reconstruct the allowance for all accounts just
173  * by listening to said events. Other implementations of the EIP may not emit
174  * these events, as it isn't required by the specification.
175  *
176  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
177  * functions have been added to mitigate the well-known issues around setting
178  * allowances. See {IERC20-approve}.
179  */
180 contract ERC20 is Context, IERC20, IERC20Metadata {
181     mapping(address => uint256) private _balances;
182 
183     mapping(address => mapping(address => uint256)) private _allowances;
184 
185     uint256 private _totalSupply;
186 
187     string private _name;
188     string private _symbol;
189 
190     /**
191      * @dev Sets the values for {name} and {symbol}.
192      *
193      * The default value of {decimals} is 18. To select a different value for
194      * {decimals} you should overload it.
195      *
196      * All two of these values are immutable: they can only be set once during
197      * construction.
198      */
199     constructor(string memory name_, string memory symbol_) {
200         _name = name_;
201         _symbol = symbol_;
202     }
203 
204     /**
205      * @dev Returns the name of the token.
206      */
207     function name() public view virtual override returns (string memory) {
208         return _name;
209     }
210 
211     /**
212      * @dev Returns the symbol of the token, usually a shorter version of the
213      * name.
214      */
215     function symbol() public view virtual override returns (string memory) {
216         return _symbol;
217     }
218 
219     /**
220      * @dev Returns the number of decimals used to get its user representation.
221      * For example, if `decimals` equals `2`, a balance of `505` tokens should
222      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
223      *
224      * Tokens usually opt for a value of 18, imitating the relationship between
225      * Ether and Wei. This is the value {ERC20} uses, unless this function is
226      * overridden;
227      *
228      * NOTE: This information is only used for _display_ purposes: it in
229      * no way affects any of the arithmetic of the contract, including
230      * {IERC20-balanceOf} and {IERC20-transfer}.
231      */
232     function decimals() public view virtual override returns (uint8) {
233         return 18;
234     }
235 
236     /**
237      * @dev See {IERC20-totalSupply}.
238      */
239     function totalSupply() public view virtual override returns (uint256) {
240         return _totalSupply;
241     }
242 
243     /**
244      * @dev See {IERC20-balanceOf}.
245      */
246     function balanceOf(address account) public view virtual override returns (uint256) {
247         return _balances[account];
248     }
249 
250     /**
251      * @dev See {IERC20-transfer}.
252      *
253      * Requirements:
254      *
255      * - `recipient` cannot be the zero address.
256      * - the caller must have a balance of at least `amount`.
257      */
258     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
259         _transfer(_msgSender(), recipient, amount);
260         return true;
261     }
262 
263     /**
264      * @dev See {IERC20-allowance}.
265      */
266     function allowance(address owner, address spender) public view virtual override returns (uint256) {
267         return _allowances[owner][spender];
268     }
269 
270     /**
271      * @dev See {IERC20-approve}.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 amount) public virtual override returns (bool) {
278         _approve(_msgSender(), spender, amount);
279         return true;
280     }
281 
282     /**
283      * @dev See {IERC20-transferFrom}.
284      *
285      * Emits an {Approval} event indicating the updated allowance. This is not
286      * required by the EIP. See the note at the beginning of {ERC20}.
287      *
288      * Requirements:
289      *
290      * - `sender` and `recipient` cannot be the zero address.
291      * - `sender` must have a balance of at least `amount`.
292      * - the caller must have allowance for ``sender``'s tokens of at least
293      * `amount`.
294      */
295     function transferFrom(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) public virtual override returns (bool) {
300         _transfer(sender, recipient, amount);
301 
302         uint256 currentAllowance = _allowances[sender][_msgSender()];
303         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
304         unchecked {
305             _approve(sender, _msgSender(), currentAllowance - amount);
306         }
307 
308         return true;
309     }
310 
311     /**
312      * @dev Atomically increases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to {approve} that can be used as a mitigation for
315      * problems described in {IERC20-approve}.
316      *
317      * Emits an {Approval} event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
324         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
325         return true;
326     }
327 
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         uint256 currentAllowance = _allowances[_msgSender()][spender];
344         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
345         unchecked {
346             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
347         }
348 
349         return true;
350     }
351 
352     /**
353      * @dev Moves `amount` of tokens from `sender` to `recipient`.
354      *
355      * This internal function is equivalent to {transfer}, and can be used to
356      * e.g. implement automatic token fees, slashing mechanisms, etc.
357      *
358      * Emits a {Transfer} event.
359      *
360      * Requirements:
361      *
362      * - `sender` cannot be the zero address.
363      * - `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      */
366     function _transfer(
367         address sender,
368         address recipient,
369         uint256 amount
370     ) internal virtual {
371         require(sender != address(0), "ERC20: transfer from the zero address");
372         require(recipient != address(0), "ERC20: transfer to the zero address");
373 
374         _beforeTokenTransfer(sender, recipient, amount);
375 
376         uint256 senderBalance = _balances[sender];
377         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
378         unchecked {
379             _balances[sender] = senderBalance - amount;
380         }
381         _balances[recipient] += amount;
382 
383         emit Transfer(sender, recipient, amount);
384 
385         _afterTokenTransfer(sender, recipient, amount);
386     }
387 
388     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
389      * the total supply.
390      *
391      * Emits a {Transfer} event with `from` set to the zero address.
392      *
393      * Requirements:
394      *
395      * - `account` cannot be the zero address.
396      */
397     function _mint(address account, uint256 amount) internal virtual {
398         require(account != address(0), "ERC20: mint to the zero address");
399 
400         _beforeTokenTransfer(address(0), account, amount);
401 
402         _totalSupply += amount;
403         _balances[account] += amount;
404         emit Transfer(address(0), account, amount);
405 
406         _afterTokenTransfer(address(0), account, amount);
407     }
408 
409     /**
410      * @dev Destroys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a {Transfer} event with `to` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 amount) internal virtual {
421         require(account != address(0), "ERC20: burn from the zero address");
422 
423         _beforeTokenTransfer(account, address(0), amount);
424 
425         uint256 accountBalance = _balances[account];
426         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
427         unchecked {
428             _balances[account] = accountBalance - amount;
429         }
430         _totalSupply -= amount;
431 
432         emit Transfer(account, address(0), amount);
433 
434         _afterTokenTransfer(account, address(0), amount);
435     }
436 
437     /**
438      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
439      *
440      * This internal function is equivalent to `approve`, and can be used to
441      * e.g. set automatic allowances for certain subsystems, etc.
442      *
443      * Emits an {Approval} event.
444      *
445      * Requirements:
446      *
447      * - `owner` cannot be the zero address.
448      * - `spender` cannot be the zero address.
449      */
450     function _approve(
451         address owner,
452         address spender,
453         uint256 amount
454     ) internal virtual {
455         require(owner != address(0), "ERC20: approve from the zero address");
456         require(spender != address(0), "ERC20: approve to the zero address");
457 
458         _allowances[owner][spender] = amount;
459         emit Approval(owner, spender, amount);
460     }
461 
462     /**
463      * @dev Hook that is called before any transfer of tokens. This includes
464      * minting and burning.
465      *
466      * Calling conditions:
467      *
468      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
469      * will be transferred to `to`.
470      * - when `from` is zero, `amount` tokens will be minted for `to`.
471      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
472      * - `from` and `to` are never both zero.
473      *
474      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
475      */
476     function _beforeTokenTransfer(
477         address from,
478         address to,
479         uint256 amount
480     ) internal virtual {}
481 
482     /**
483      * @dev Hook that is called after any transfer of tokens. This includes
484      * minting and burning.
485      *
486      * Calling conditions:
487      *
488      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
489      * has been transferred to `to`.
490      * - when `from` is zero, `amount` tokens have been minted for `to`.
491      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
492      * - `from` and `to` are never both zero.
493      *
494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
495      */
496     function _afterTokenTransfer(
497         address from,
498         address to,
499         uint256 amount
500     ) internal virtual {}
501 }
502 
503 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
504 
505 
506 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/ERC20Burnable.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 
511 
512 /**
513  * @dev Extension of {ERC20} that allows token holders to destroy both their own
514  * tokens and those that they have an allowance for, in a way that can be
515  * recognized off-chain (via event analysis).
516  */
517 abstract contract ERC20Burnable is Context, ERC20 {
518     /**
519      * @dev Destroys `amount` tokens from the caller.
520      *
521      * See {ERC20-_burn}.
522      */
523     function burn(uint256 amount) public virtual {
524         _burn(_msgSender(), amount);
525     }
526 
527     /**
528      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
529      * allowance.
530      *
531      * See {ERC20-_burn} and {ERC20-allowance}.
532      *
533      * Requirements:
534      *
535      * - the caller must have allowance for ``accounts``'s tokens of at least
536      * `amount`.
537      */
538     function burnFrom(address account, uint256 amount) public virtual {
539         uint256 currentAllowance = allowance(account, _msgSender());
540         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
541         unchecked {
542             _approve(account, _msgSender(), currentAllowance - amount);
543         }
544         _burn(account, amount);
545     }
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/ERC20Capped.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
558  */
559 abstract contract ERC20Capped is ERC20 {
560     uint256 private immutable _cap;
561 
562     /**
563      * @dev Sets the value of the `cap`. This value is immutable, it can only be
564      * set once during construction.
565      */
566     constructor(uint256 cap_) {
567         require(cap_ > 0, "ERC20Capped: cap is 0");
568         _cap = cap_;
569     }
570 
571     /**
572      * @dev Returns the cap on the token's total supply.
573      */
574     function cap() public view virtual returns (uint256) {
575         return _cap;
576     }
577 
578     /**
579      * @dev See {ERC20-_mint}.
580      */
581     function _mint(address account, uint256 amount) internal virtual override {
582         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
583         super._mint(account, amount);
584     }
585 }
586 
587 // File: @openzeppelin/contracts/utils/Address.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 /**
595  * @dev Collection of functions related to the address type
596  */
597 library Address {
598     /**
599      * @dev Returns true if `account` is a contract.
600      *
601      * [IMPORTANT]
602      * ====
603      * It is unsafe to assume that an address for which this function returns
604      * false is an externally-owned account (EOA) and not a contract.
605      *
606      * Among others, `isContract` will return false for the following
607      * types of addresses:
608      *
609      *  - an externally-owned account
610      *  - a contract in construction
611      *  - an address where a contract will be created
612      *  - an address where a contract lived, but was destroyed
613      * ====
614      */
615     function isContract(address account) internal view returns (bool) {
616         // This method relies on extcodesize, which returns 0 for contracts in
617         // construction, since the code is only stored at the end of the
618         // constructor execution.
619 
620         uint256 size;
621         assembly {
622             size := extcodesize(account)
623         }
624         return size > 0;
625     }
626 
627     /**
628      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
629      * `recipient`, forwarding all available gas and reverting on errors.
630      *
631      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
632      * of certain opcodes, possibly making contracts go over the 2300 gas limit
633      * imposed by `transfer`, making them unable to receive funds via
634      * `transfer`. {sendValue} removes this limitation.
635      *
636      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
637      *
638      * IMPORTANT: because control is transferred to `recipient`, care must be
639      * taken to not create reentrancy vulnerabilities. Consider using
640      * {ReentrancyGuard} or the
641      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
642      */
643     function sendValue(address payable recipient, uint256 amount) internal {
644         require(address(this).balance >= amount, "Address: insufficient balance");
645 
646         (bool success, ) = recipient.call{value: amount}("");
647         require(success, "Address: unable to send value, recipient may have reverted");
648     }
649 
650     /**
651      * @dev Performs a Solidity function call using a low level `call`. A
652      * plain `call` is an unsafe replacement for a function call: use this
653      * function instead.
654      *
655      * If `target` reverts with a revert reason, it is bubbled up by this
656      * function (like regular Solidity function calls).
657      *
658      * Returns the raw returned data. To convert to the expected return value,
659      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
660      *
661      * Requirements:
662      *
663      * - `target` must be a contract.
664      * - calling `target` with `data` must not revert.
665      *
666      * _Available since v3.1._
667      */
668     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
669         return functionCall(target, data, "Address: low-level call failed");
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
674      * `errorMessage` as a fallback revert reason when `target` reverts.
675      *
676      * _Available since v3.1._
677      */
678     function functionCall(
679         address target,
680         bytes memory data,
681         string memory errorMessage
682     ) internal returns (bytes memory) {
683         return functionCallWithValue(target, data, 0, errorMessage);
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
688      * but also transferring `value` wei to `target`.
689      *
690      * Requirements:
691      *
692      * - the calling contract must have an ETH balance of at least `value`.
693      * - the called Solidity function must be `payable`.
694      *
695      * _Available since v3.1._
696      */
697     function functionCallWithValue(
698         address target,
699         bytes memory data,
700         uint256 value
701     ) internal returns (bytes memory) {
702         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
707      * with `errorMessage` as a fallback revert reason when `target` reverts.
708      *
709      * _Available since v3.1._
710      */
711     function functionCallWithValue(
712         address target,
713         bytes memory data,
714         uint256 value,
715         string memory errorMessage
716     ) internal returns (bytes memory) {
717         require(address(this).balance >= value, "Address: insufficient balance for call");
718         require(isContract(target), "Address: call to non-contract");
719 
720         (bool success, bytes memory returndata) = target.call{value: value}(data);
721         return verifyCallResult(success, returndata, errorMessage);
722     }
723 
724     /**
725      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
726      * but performing a static call.
727      *
728      * _Available since v3.3._
729      */
730     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
731         return functionStaticCall(target, data, "Address: low-level static call failed");
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
736      * but performing a static call.
737      *
738      * _Available since v3.3._
739      */
740     function functionStaticCall(
741         address target,
742         bytes memory data,
743         string memory errorMessage
744     ) internal view returns (bytes memory) {
745         require(isContract(target), "Address: static call to non-contract");
746 
747         (bool success, bytes memory returndata) = target.staticcall(data);
748         return verifyCallResult(success, returndata, errorMessage);
749     }
750 
751     /**
752      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
753      * but performing a delegate call.
754      *
755      * _Available since v3.4._
756      */
757     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
758         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
759     }
760 
761     /**
762      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
763      * but performing a delegate call.
764      *
765      * _Available since v3.4._
766      */
767     function functionDelegateCall(
768         address target,
769         bytes memory data,
770         string memory errorMessage
771     ) internal returns (bytes memory) {
772         require(isContract(target), "Address: delegate call to non-contract");
773 
774         (bool success, bytes memory returndata) = target.delegatecall(data);
775         return verifyCallResult(success, returndata, errorMessage);
776     }
777 
778     /**
779      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
780      * revert reason using the provided one.
781      *
782      * _Available since v4.3._
783      */
784     function verifyCallResult(
785         bool success,
786         bytes memory returndata,
787         string memory errorMessage
788     ) internal pure returns (bytes memory) {
789         if (success) {
790             return returndata;
791         } else {
792             // Look for revert reason and bubble it up if present
793             if (returndata.length > 0) {
794                 // The easiest way to bubble the revert reason is using memory via assembly
795 
796                 assembly {
797                     let returndata_size := mload(returndata)
798                     revert(add(32, returndata), returndata_size)
799                 }
800             } else {
801                 revert(errorMessage);
802             }
803         }
804     }
805 }
806 
807 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
808 
809 
810 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
811 
812 pragma solidity ^0.8.0;
813 
814 /**
815  * @dev Interface of the ERC165 standard, as defined in the
816  * https://eips.ethereum.org/EIPS/eip-165[EIP].
817  *
818  * Implementers can declare support of contract interfaces, which can then be
819  * queried by others ({ERC165Checker}).
820  *
821  * For an implementation, see {ERC165}.
822  */
823 interface IERC165 {
824     /**
825      * @dev Returns true if this contract implements the interface defined by
826      * `interfaceId`. See the corresponding
827      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
828      * to learn more about how these ids are created.
829      *
830      * This function call must use less than 30 000 gas.
831      */
832     function supportsInterface(bytes4 interfaceId) external view returns (bool);
833 }
834 
835 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
836 
837 
838 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
839 
840 pragma solidity ^0.8.0;
841 
842 
843 /**
844  * @dev Implementation of the {IERC165} interface.
845  *
846  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
847  * for the additional interface id that will be supported. For example:
848  *
849  * ```solidity
850  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
851  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
852  * }
853  * ```
854  *
855  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
856  */
857 abstract contract ERC165 is IERC165 {
858     /**
859      * @dev See {IERC165-supportsInterface}.
860      */
861     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
862         return interfaceId == type(IERC165).interfaceId;
863     }
864 }
865 
866 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
867 
868 
869 
870 pragma solidity ^0.8.0;
871 
872 
873 
874 /**
875  * @title IERC1363 Interface
876  * @dev Interface for a Payable Token contract as defined in
877  *  https://eips.ethereum.org/EIPS/eip-1363
878  */
879 interface IERC1363 is IERC20, IERC165 {
880     /**
881      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
882      * @param recipient address The address which you want to transfer to
883      * @param amount uint256 The amount of tokens to be transferred
884      * @return true unless throwing
885      */
886     function transferAndCall(address recipient, uint256 amount) external returns (bool);
887 
888     /**
889      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
890      * @param recipient address The address which you want to transfer to
891      * @param amount uint256 The amount of tokens to be transferred
892      * @param data bytes Additional data with no specified format, sent in call to `recipient`
893      * @return true unless throwing
894      */
895     function transferAndCall(
896         address recipient,
897         uint256 amount,
898         bytes calldata data
899     ) external returns (bool);
900 
901     /**
902      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
903      * @param sender address The address which you want to send tokens from
904      * @param recipient address The address which you want to transfer to
905      * @param amount uint256 The amount of tokens to be transferred
906      * @return true unless throwing
907      */
908     function transferFromAndCall(
909         address sender,
910         address recipient,
911         uint256 amount
912     ) external returns (bool);
913 
914     /**
915      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
916      * @param sender address The address which you want to send tokens from
917      * @param recipient address The address which you want to transfer to
918      * @param amount uint256 The amount of tokens to be transferred
919      * @param data bytes Additional data with no specified format, sent in call to `recipient`
920      * @return true unless throwing
921      */
922     function transferFromAndCall(
923         address sender,
924         address recipient,
925         uint256 amount,
926         bytes calldata data
927     ) external returns (bool);
928 
929     /**
930      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
931      * and then call `onApprovalReceived` on spender.
932      * Beware that changing an allowance with this method brings the risk that someone may use both the old
933      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
934      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
935      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
936      * @param spender address The address which will spend the funds
937      * @param amount uint256 The amount of tokens to be spent
938      */
939     function approveAndCall(address spender, uint256 amount) external returns (bool);
940 
941     /**
942      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
943      * and then call `onApprovalReceived` on spender.
944      * Beware that changing an allowance with this method brings the risk that someone may use both the old
945      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
946      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
947      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
948      * @param spender address The address which will spend the funds
949      * @param amount uint256 The amount of tokens to be spent
950      * @param data bytes Additional data with no specified format, sent in call to `spender`
951      */
952     function approveAndCall(
953         address spender,
954         uint256 amount,
955         bytes calldata data
956     ) external returns (bool);
957 }
958 
959 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
960 
961 
962 
963 pragma solidity ^0.8.0;
964 
965 /**
966  * @title IERC1363Receiver Interface
967  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
968  *  from ERC1363 token contracts as defined in
969  *  https://eips.ethereum.org/EIPS/eip-1363
970  */
971 interface IERC1363Receiver {
972     /**
973      * @notice Handle the receipt of ERC1363 tokens
974      * @dev Any ERC1363 smart contract calls this function on the recipient
975      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
976      * transfer. Return of other than the magic value MUST result in the
977      * transaction being reverted.
978      * Note: the token contract address is always the message sender.
979      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
980      * @param sender address The address which are token transferred from
981      * @param amount uint256 The amount of tokens transferred
982      * @param data bytes Additional data with no specified format
983      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
984      */
985     function onTransferReceived(
986         address operator,
987         address sender,
988         uint256 amount,
989         bytes calldata data
990     ) external returns (bytes4);
991 }
992 
993 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
994 
995 
996 
997 pragma solidity ^0.8.0;
998 
999 /**
1000  * @title IERC1363Spender Interface
1001  * @dev Interface for any contract that wants to support approveAndCall
1002  *  from ERC1363 token contracts as defined in
1003  *  https://eips.ethereum.org/EIPS/eip-1363
1004  */
1005 interface IERC1363Spender {
1006     /**
1007      * @notice Handle the approval of ERC1363 tokens
1008      * @dev Any ERC1363 smart contract calls this function on the recipient
1009      * after an `approve`. This function MAY throw to revert and reject the
1010      * approval. Return of other than the magic value MUST result in the
1011      * transaction being reverted.
1012      * Note: the token contract address is always the message sender.
1013      * @param sender address The address which called `approveAndCall` function
1014      * @param amount uint256 The amount of tokens to be spent
1015      * @param data bytes Additional data with no specified format
1016      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
1017      */
1018     function onApprovalReceived(
1019         address sender,
1020         uint256 amount,
1021         bytes calldata data
1022     ) external returns (bytes4);
1023 }
1024 
1025 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1026 
1027 
1028 
1029 pragma solidity ^0.8.0;
1030 
1031 
1032 
1033 
1034 
1035 
1036 
1037 /**
1038  * @title ERC1363
1039  * @dev Implementation of an ERC1363 interface
1040  */
1041 abstract contract ERC1363 is ERC20, IERC1363, ERC165 {
1042     using Address for address;
1043 
1044     /**
1045      * @dev See {IERC165-supportsInterface}.
1046      */
1047     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1048         return interfaceId == type(IERC1363).interfaceId || super.supportsInterface(interfaceId);
1049     }
1050 
1051     /**
1052      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1053      * @param recipient The address to transfer to.
1054      * @param amount The amount to be transferred.
1055      * @return A boolean that indicates if the operation was successful.
1056      */
1057     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
1058         return transferAndCall(recipient, amount, "");
1059     }
1060 
1061     /**
1062      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1063      * @param recipient The address to transfer to
1064      * @param amount The amount to be transferred
1065      * @param data Additional data with no specified format
1066      * @return A boolean that indicates if the operation was successful.
1067      */
1068     function transferAndCall(
1069         address recipient,
1070         uint256 amount,
1071         bytes memory data
1072     ) public virtual override returns (bool) {
1073         transfer(recipient, amount);
1074         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1075         return true;
1076     }
1077 
1078     /**
1079      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1080      * @param sender The address which you want to send tokens from
1081      * @param recipient The address which you want to transfer to
1082      * @param amount The amount of tokens to be transferred
1083      * @return A boolean that indicates if the operation was successful.
1084      */
1085     function transferFromAndCall(
1086         address sender,
1087         address recipient,
1088         uint256 amount
1089     ) public virtual override returns (bool) {
1090         return transferFromAndCall(sender, recipient, amount, "");
1091     }
1092 
1093     /**
1094      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1095      * @param sender The address which you want to send tokens from
1096      * @param recipient The address which you want to transfer to
1097      * @param amount The amount of tokens to be transferred
1098      * @param data Additional data with no specified format
1099      * @return A boolean that indicates if the operation was successful.
1100      */
1101     function transferFromAndCall(
1102         address sender,
1103         address recipient,
1104         uint256 amount,
1105         bytes memory data
1106     ) public virtual override returns (bool) {
1107         transferFrom(sender, recipient, amount);
1108         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1109         return true;
1110     }
1111 
1112     /**
1113      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1114      * @param spender The address allowed to transfer to
1115      * @param amount The amount allowed to be transferred
1116      * @return A boolean that indicates if the operation was successful.
1117      */
1118     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
1119         return approveAndCall(spender, amount, "");
1120     }
1121 
1122     /**
1123      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1124      * @param spender The address allowed to transfer to.
1125      * @param amount The amount allowed to be transferred.
1126      * @param data Additional data with no specified format.
1127      * @return A boolean that indicates if the operation was successful.
1128      */
1129     function approveAndCall(
1130         address spender,
1131         uint256 amount,
1132         bytes memory data
1133     ) public virtual override returns (bool) {
1134         approve(spender, amount);
1135         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
1136         return true;
1137     }
1138 
1139     /**
1140      * @dev Internal function to invoke `onTransferReceived` on a target address
1141      *  The call is not executed if the target address is not a contract
1142      * @param sender address Representing the previous owner of the given token value
1143      * @param recipient address Target address that will receive the tokens
1144      * @param amount uint256 The amount mount of tokens to be transferred
1145      * @param data bytes Optional data to send along with the call
1146      * @return whether the call correctly returned the expected magic value
1147      */
1148     function _checkAndCallTransfer(
1149         address sender,
1150         address recipient,
1151         uint256 amount,
1152         bytes memory data
1153     ) internal virtual returns (bool) {
1154         if (!recipient.isContract()) {
1155             return false;
1156         }
1157         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(_msgSender(), sender, amount, data);
1158         return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
1159     }
1160 
1161     /**
1162      * @dev Internal function to invoke `onApprovalReceived` on a target address
1163      *  The call is not executed if the target address is not a contract
1164      * @param spender address The address which will spend the funds
1165      * @param amount uint256 The amount of tokens to be spent
1166      * @param data bytes Optional data to send along with the call
1167      * @return whether the call correctly returned the expected magic value
1168      */
1169     function _checkAndCallApprove(
1170         address spender,
1171         uint256 amount,
1172         bytes memory data
1173     ) internal virtual returns (bool) {
1174         if (!spender.isContract()) {
1175             return false;
1176         }
1177         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(_msgSender(), amount, data);
1178         return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
1179     }
1180 }
1181 
1182 // File: @openzeppelin/contracts/access/Ownable.sol
1183 
1184 
1185 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 /**
1191  * @dev Contract module which provides a basic access control mechanism, where
1192  * there is an account (an owner) that can be granted exclusive access to
1193  * specific functions.
1194  *
1195  * By default, the owner account will be the one that deploys the contract. This
1196  * can later be changed with {transferOwnership}.
1197  *
1198  * This module is used through inheritance. It will make available the modifier
1199  * `onlyOwner`, which can be applied to your functions to restrict their use to
1200  * the owner.
1201  */
1202 abstract contract Ownable is Context {
1203     address private _owner;
1204 
1205     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1206 
1207     /**
1208      * @dev Initializes the contract setting the deployer as the initial owner.
1209      */
1210     constructor() {
1211         _transferOwnership(_msgSender());
1212     }
1213 
1214     /**
1215      * @dev Returns the address of the current owner.
1216      */
1217     function owner() public view virtual returns (address) {
1218         return _owner;
1219     }
1220 
1221     /**
1222      * @dev Throws if called by any account other than the owner.
1223      */
1224     modifier onlyOwner() {
1225         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1226         _;
1227     }
1228 
1229     /**
1230      * @dev Leaves the contract without owner. It will not be possible to call
1231      * `onlyOwner` functions anymore. Can only be called by the current owner.
1232      *
1233      * NOTE: Renouncing ownership will leave the contract without an owner,
1234      * thereby removing any functionality that is only available to the owner.
1235      */
1236     function renounceOwnership() public virtual onlyOwner {
1237         _transferOwnership(address(0));
1238     }
1239 
1240     /**
1241      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1242      * Can only be called by the current owner.
1243      */
1244     function transferOwnership(address newOwner) public virtual onlyOwner {
1245         require(newOwner != address(0), "Ownable: new owner is the zero address");
1246         _transferOwnership(newOwner);
1247     }
1248 
1249     /**
1250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1251      * Internal function without access restriction.
1252      */
1253     function _transferOwnership(address newOwner) internal virtual {
1254         address oldOwner = _owner;
1255         _owner = newOwner;
1256         emit OwnershipTransferred(oldOwner, newOwner);
1257     }
1258 }
1259 
1260 // File: eth-token-recover/contracts/TokenRecover.sol
1261 
1262 
1263 
1264 pragma solidity ^0.8.0;
1265 
1266 
1267 
1268 /**
1269  * @title TokenRecover
1270  * @dev Allows owner to recover any ERC20 sent into the contract
1271  */
1272 contract TokenRecover is Ownable {
1273     /**
1274      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1275      * @param tokenAddress The token contract address
1276      * @param tokenAmount Number of tokens to be sent
1277      */
1278     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
1279         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1280     }
1281 }
1282 
1283 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
1284 
1285 
1286 
1287 pragma solidity ^0.8.0;
1288 
1289 
1290 /**
1291  * @title ERC20Decimals
1292  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
1293  */
1294 abstract contract ERC20Decimals is ERC20 {
1295     uint8 private immutable _decimals;
1296 
1297     /**
1298      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
1299      * set once during construction.
1300      */
1301     constructor(uint8 decimals_) {
1302         _decimals = decimals_;
1303     }
1304 
1305     function decimals() public view virtual override returns (uint8) {
1306         return _decimals;
1307     }
1308 }
1309 
1310 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
1311 
1312 
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 
1317 /**
1318  * @title ERC20Mintable
1319  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
1320  */
1321 abstract contract ERC20Mintable is ERC20 {
1322     // indicates if minting is finished
1323     bool private _mintingFinished = false;
1324 
1325     /**
1326      * @dev Emitted during finish minting
1327      */
1328     event MintFinished();
1329 
1330     /**
1331      * @dev Tokens can be minted only before minting finished.
1332      */
1333     modifier canMint() {
1334         require(!_mintingFinished, "ERC20Mintable: minting is finished");
1335         _;
1336     }
1337 
1338     /**
1339      * @return if minting is finished or not.
1340      */
1341     function mintingFinished() external view returns (bool) {
1342         return _mintingFinished;
1343     }
1344 
1345     /**
1346      * @dev Function to mint tokens.
1347      *
1348      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
1349      *
1350      * @param account The address that will receive the minted tokens
1351      * @param amount The amount of tokens to mint
1352      */
1353     function mint(address account, uint256 amount) external canMint {
1354         _mint(account, amount);
1355     }
1356 
1357     /**
1358      * @dev Function to stop minting new tokens.
1359      *
1360      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
1361      */
1362     function finishMinting() external canMint {
1363         _finishMinting();
1364     }
1365 
1366     /**
1367      * @dev Function to stop minting new tokens.
1368      */
1369     function _finishMinting() internal virtual {
1370         _mintingFinished = true;
1371 
1372         emit MintFinished();
1373     }
1374 }
1375 
1376 // File: @openzeppelin/contracts/access/IAccessControl.sol
1377 
1378 
1379 // OpenZeppelin Contracts v4.4.0 (access/IAccessControl.sol)
1380 
1381 pragma solidity ^0.8.0;
1382 
1383 /**
1384  * @dev External interface of AccessControl declared to support ERC165 detection.
1385  */
1386 interface IAccessControl {
1387     /**
1388      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1389      *
1390      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1391      * {RoleAdminChanged} not being emitted signaling this.
1392      *
1393      * _Available since v3.1._
1394      */
1395     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1396 
1397     /**
1398      * @dev Emitted when `account` is granted `role`.
1399      *
1400      * `sender` is the account that originated the contract call, an admin role
1401      * bearer except when using {AccessControl-_setupRole}.
1402      */
1403     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1404 
1405     /**
1406      * @dev Emitted when `account` is revoked `role`.
1407      *
1408      * `sender` is the account that originated the contract call:
1409      *   - if using `revokeRole`, it is the admin role bearer
1410      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1411      */
1412     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1413 
1414     /**
1415      * @dev Returns `true` if `account` has been granted `role`.
1416      */
1417     function hasRole(bytes32 role, address account) external view returns (bool);
1418 
1419     /**
1420      * @dev Returns the admin role that controls `role`. See {grantRole} and
1421      * {revokeRole}.
1422      *
1423      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1424      */
1425     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1426 
1427     /**
1428      * @dev Grants `role` to `account`.
1429      *
1430      * If `account` had not been already granted `role`, emits a {RoleGranted}
1431      * event.
1432      *
1433      * Requirements:
1434      *
1435      * - the caller must have ``role``'s admin role.
1436      */
1437     function grantRole(bytes32 role, address account) external;
1438 
1439     /**
1440      * @dev Revokes `role` from `account`.
1441      *
1442      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1443      *
1444      * Requirements:
1445      *
1446      * - the caller must have ``role``'s admin role.
1447      */
1448     function revokeRole(bytes32 role, address account) external;
1449 
1450     /**
1451      * @dev Revokes `role` from the calling account.
1452      *
1453      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1454      * purpose is to provide a mechanism for accounts to lose their privileges
1455      * if they are compromised (such as when a trusted device is misplaced).
1456      *
1457      * If the calling account had been granted `role`, emits a {RoleRevoked}
1458      * event.
1459      *
1460      * Requirements:
1461      *
1462      * - the caller must be `account`.
1463      */
1464     function renounceRole(bytes32 role, address account) external;
1465 }
1466 
1467 // File: @openzeppelin/contracts/utils/Strings.sol
1468 
1469 
1470 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
1471 
1472 pragma solidity ^0.8.0;
1473 
1474 /**
1475  * @dev String operations.
1476  */
1477 library Strings {
1478     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1479 
1480     /**
1481      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1482      */
1483     function toString(uint256 value) internal pure returns (string memory) {
1484         // Inspired by OraclizeAPI's implementation - MIT licence
1485         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1486 
1487         if (value == 0) {
1488             return "0";
1489         }
1490         uint256 temp = value;
1491         uint256 digits;
1492         while (temp != 0) {
1493             digits++;
1494             temp /= 10;
1495         }
1496         bytes memory buffer = new bytes(digits);
1497         while (value != 0) {
1498             digits -= 1;
1499             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1500             value /= 10;
1501         }
1502         return string(buffer);
1503     }
1504 
1505     /**
1506      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1507      */
1508     function toHexString(uint256 value) internal pure returns (string memory) {
1509         if (value == 0) {
1510             return "0x00";
1511         }
1512         uint256 temp = value;
1513         uint256 length = 0;
1514         while (temp != 0) {
1515             length++;
1516             temp >>= 8;
1517         }
1518         return toHexString(value, length);
1519     }
1520 
1521     /**
1522      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1523      */
1524     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1525         bytes memory buffer = new bytes(2 * length + 2);
1526         buffer[0] = "0";
1527         buffer[1] = "x";
1528         for (uint256 i = 2 * length + 1; i > 1; --i) {
1529             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1530             value >>= 4;
1531         }
1532         require(value == 0, "Strings: hex length insufficient");
1533         return string(buffer);
1534     }
1535 }
1536 
1537 // File: @openzeppelin/contracts/access/AccessControl.sol
1538 
1539 
1540 // OpenZeppelin Contracts v4.4.0 (access/AccessControl.sol)
1541 
1542 pragma solidity ^0.8.0;
1543 
1544 
1545 
1546 
1547 
1548 /**
1549  * @dev Contract module that allows children to implement role-based access
1550  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1551  * members except through off-chain means by accessing the contract event logs. Some
1552  * applications may benefit from on-chain enumerability, for those cases see
1553  * {AccessControlEnumerable}.
1554  *
1555  * Roles are referred to by their `bytes32` identifier. These should be exposed
1556  * in the external API and be unique. The best way to achieve this is by
1557  * using `public constant` hash digests:
1558  *
1559  * ```
1560  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1561  * ```
1562  *
1563  * Roles can be used to represent a set of permissions. To restrict access to a
1564  * function call, use {hasRole}:
1565  *
1566  * ```
1567  * function foo() public {
1568  *     require(hasRole(MY_ROLE, msg.sender));
1569  *     ...
1570  * }
1571  * ```
1572  *
1573  * Roles can be granted and revoked dynamically via the {grantRole} and
1574  * {revokeRole} functions. Each role has an associated admin role, and only
1575  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1576  *
1577  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1578  * that only accounts with this role will be able to grant or revoke other
1579  * roles. More complex role relationships can be created by using
1580  * {_setRoleAdmin}.
1581  *
1582  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1583  * grant and revoke this role. Extra precautions should be taken to secure
1584  * accounts that have been granted it.
1585  */
1586 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1587     struct RoleData {
1588         mapping(address => bool) members;
1589         bytes32 adminRole;
1590     }
1591 
1592     mapping(bytes32 => RoleData) private _roles;
1593 
1594     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1595 
1596     /**
1597      * @dev Modifier that checks that an account has a specific role. Reverts
1598      * with a standardized message including the required role.
1599      *
1600      * The format of the revert reason is given by the following regular expression:
1601      *
1602      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1603      *
1604      * _Available since v4.1._
1605      */
1606     modifier onlyRole(bytes32 role) {
1607         _checkRole(role, _msgSender());
1608         _;
1609     }
1610 
1611     /**
1612      * @dev See {IERC165-supportsInterface}.
1613      */
1614     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1615         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1616     }
1617 
1618     /**
1619      * @dev Returns `true` if `account` has been granted `role`.
1620      */
1621     function hasRole(bytes32 role, address account) public view override returns (bool) {
1622         return _roles[role].members[account];
1623     }
1624 
1625     /**
1626      * @dev Revert with a standard message if `account` is missing `role`.
1627      *
1628      * The format of the revert reason is given by the following regular expression:
1629      *
1630      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1631      */
1632     function _checkRole(bytes32 role, address account) internal view {
1633         if (!hasRole(role, account)) {
1634             revert(
1635                 string(
1636                     abi.encodePacked(
1637                         "AccessControl: account ",
1638                         Strings.toHexString(uint160(account), 20),
1639                         " is missing role ",
1640                         Strings.toHexString(uint256(role), 32)
1641                     )
1642                 )
1643             );
1644         }
1645     }
1646 
1647     /**
1648      * @dev Returns the admin role that controls `role`. See {grantRole} and
1649      * {revokeRole}.
1650      *
1651      * To change a role's admin, use {_setRoleAdmin}.
1652      */
1653     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1654         return _roles[role].adminRole;
1655     }
1656 
1657     /**
1658      * @dev Grants `role` to `account`.
1659      *
1660      * If `account` had not been already granted `role`, emits a {RoleGranted}
1661      * event.
1662      *
1663      * Requirements:
1664      *
1665      * - the caller must have ``role``'s admin role.
1666      */
1667     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1668         _grantRole(role, account);
1669     }
1670 
1671     /**
1672      * @dev Revokes `role` from `account`.
1673      *
1674      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1675      *
1676      * Requirements:
1677      *
1678      * - the caller must have ``role``'s admin role.
1679      */
1680     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1681         _revokeRole(role, account);
1682     }
1683 
1684     /**
1685      * @dev Revokes `role` from the calling account.
1686      *
1687      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1688      * purpose is to provide a mechanism for accounts to lose their privileges
1689      * if they are compromised (such as when a trusted device is misplaced).
1690      *
1691      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1692      * event.
1693      *
1694      * Requirements:
1695      *
1696      * - the caller must be `account`.
1697      */
1698     function renounceRole(bytes32 role, address account) public virtual override {
1699         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1700 
1701         _revokeRole(role, account);
1702     }
1703 
1704     /**
1705      * @dev Grants `role` to `account`.
1706      *
1707      * If `account` had not been already granted `role`, emits a {RoleGranted}
1708      * event. Note that unlike {grantRole}, this function doesn't perform any
1709      * checks on the calling account.
1710      *
1711      * [WARNING]
1712      * ====
1713      * This function should only be called from the constructor when setting
1714      * up the initial roles for the system.
1715      *
1716      * Using this function in any other way is effectively circumventing the admin
1717      * system imposed by {AccessControl}.
1718      * ====
1719      *
1720      * NOTE: This function is deprecated in favor of {_grantRole}.
1721      */
1722     function _setupRole(bytes32 role, address account) internal virtual {
1723         _grantRole(role, account);
1724     }
1725 
1726     /**
1727      * @dev Sets `adminRole` as ``role``'s admin role.
1728      *
1729      * Emits a {RoleAdminChanged} event.
1730      */
1731     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1732         bytes32 previousAdminRole = getRoleAdmin(role);
1733         _roles[role].adminRole = adminRole;
1734         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1735     }
1736 
1737     /**
1738      * @dev Grants `role` to `account`.
1739      *
1740      * Internal function without access restriction.
1741      */
1742     function _grantRole(bytes32 role, address account) internal virtual {
1743         if (!hasRole(role, account)) {
1744             _roles[role].members[account] = true;
1745             emit RoleGranted(role, account, _msgSender());
1746         }
1747     }
1748 
1749     /**
1750      * @dev Revokes `role` from `account`.
1751      *
1752      * Internal function without access restriction.
1753      */
1754     function _revokeRole(bytes32 role, address account) internal virtual {
1755         if (hasRole(role, account)) {
1756             _roles[role].members[account] = false;
1757             emit RoleRevoked(role, account, _msgSender());
1758         }
1759     }
1760 }
1761 
1762 // File: contracts/access/Roles.sol
1763 
1764 
1765 
1766 pragma solidity ^0.8.0;
1767 
1768 
1769 contract Roles is AccessControl {
1770     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1771 
1772     constructor() {
1773         _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
1774         _grantRole(MINTER_ROLE, _msgSender());
1775     }
1776 
1777     modifier onlyMinter() {
1778         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1779         _;
1780     }
1781 }
1782 
1783 // File: contracts/service/ServicePayer.sol
1784 
1785 
1786 
1787 pragma solidity ^0.8.0;
1788 
1789 interface IPayable {
1790     function pay(string memory serviceName) external payable;
1791 }
1792 
1793 /**
1794  * @title ServicePayer
1795  * @dev Implementation of the ServicePayer
1796  */
1797 abstract contract ServicePayer {
1798     constructor(address payable receiver, string memory serviceName) payable {
1799         IPayable(receiver).pay{value: msg.value}(serviceName);
1800     }
1801 }
1802 
1803 // File: contracts/token/ERC20/PowerfulERC20.sol
1804 
1805 
1806 
1807 pragma solidity ^0.8.0;
1808 
1809 
1810 
1811 
1812 
1813 
1814 
1815 
1816 
1817 /**
1818  * @title PowerfulERC20
1819  * @dev Implementation of the PowerfulERC20
1820  */
1821 contract PowerfulERC20 is
1822     ERC20Decimals,
1823     ERC20Capped,
1824     ERC20Mintable,
1825     ERC20Burnable,
1826     ERC1363,
1827     TokenRecover,
1828     Roles,
1829     ServicePayer
1830 {
1831     constructor(
1832         string memory name_,
1833         string memory symbol_,
1834         uint8 decimals_,
1835         uint256 cap_,
1836         uint256 initialBalance_,
1837         address payable feeReceiver_
1838     )
1839         payable
1840         ERC20(name_, symbol_)
1841         ERC20Decimals(decimals_)
1842         ERC20Capped(cap_)
1843         ServicePayer(feeReceiver_, "PowerfulERC20")
1844     {
1845         _mint(_msgSender(), initialBalance_);
1846     }
1847 
1848     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
1849         return super.decimals();
1850     }
1851 
1852     function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC1363) returns (bool) {
1853         return super.supportsInterface(interfaceId);
1854     }
1855 
1856     /**
1857      * @dev Function to mint tokens.
1858      *
1859      * NOTE: restricting access to addresses with MINTER role. See {ERC20Mintable-mint}.
1860      *
1861      * @param account The address that will receive the minted tokens
1862      * @param amount The amount of tokens to mint
1863      */
1864     function _mint(address account, uint256 amount) internal override(ERC20, ERC20Capped) onlyMinter {
1865         super._mint(account, amount);
1866     }
1867 
1868     /**
1869      * @dev Function to stop minting new tokens.
1870      *
1871      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
1872      */
1873     function _finishMinting() internal override onlyOwner {
1874         super._finishMinting();
1875     }
1876 }
