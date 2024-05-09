1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
88 
89 
90 
91 pragma solidity ^0.8.0;
92 
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 // File: @openzeppelin/contracts/utils/Context.sol
117 
118 
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
143 
144 
145 
146 pragma solidity ^0.8.0;
147 
148 
149 
150 
151 /**
152  * @dev Implementation of the {IERC20} interface.
153  *
154  * This implementation is agnostic to the way tokens are created. This means
155  * that a supply mechanism has to be added in a derived contract using {_mint}.
156  * For a generic mechanism see {ERC20PresetMinterPauser}.
157  *
158  * TIP: For a detailed writeup see our guide
159  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
160  * to implement supply mechanisms].
161  *
162  * We have followed general OpenZeppelin Contracts guidelines: functions revert
163  * instead returning `false` on failure. This behavior is nonetheless
164  * conventional and does not conflict with the expectations of ERC20
165  * applications.
166  *
167  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
168  * This allows applications to reconstruct the allowance for all accounts just
169  * by listening to said events. Other implementations of the EIP may not emit
170  * these events, as it isn't required by the specification.
171  *
172  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
173  * functions have been added to mitigate the well-known issues around setting
174  * allowances. See {IERC20-approve}.
175  */
176 contract ERC20 is Context, IERC20, IERC20Metadata {
177     mapping(address => uint256) private _balances;
178 
179     mapping(address => mapping(address => uint256)) private _allowances;
180 
181     uint256 private _totalSupply;
182 
183     string private _name;
184     string private _symbol;
185 
186     /**
187      * @dev Sets the values for {name} and {symbol}.
188      *
189      * The default value of {decimals} is 18. To select a different value for
190      * {decimals} you should overload it.
191      *
192      * All two of these values are immutable: they can only be set once during
193      * construction.
194      */
195     constructor(string memory name_, string memory symbol_) {
196         _name = name_;
197         _symbol = symbol_;
198     }
199 
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view virtual override returns (string memory) {
204         return _name;
205     }
206 
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214 
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if `decimals` equals `2`, a balance of `505` tokens should
218      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei. This is the value {ERC20} uses, unless this function is
222      * overridden;
223      *
224      * NOTE: This information is only used for _display_ purposes: it in
225      * no way affects any of the arithmetic of the contract, including
226      * {IERC20-balanceOf} and {IERC20-transfer}.
227      */
228     function decimals() public view virtual override returns (uint8) {
229         return 18;
230     }
231 
232     /**
233      * @dev See {IERC20-totalSupply}.
234      */
235     function totalSupply() public view virtual override returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(address account) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See {IERC20-transfer}.
248      *
249      * Requirements:
250      *
251      * - `recipient` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
255         _transfer(_msgSender(), recipient, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See {IERC20-allowance}.
261      */
262     function allowance(address owner, address spender) public view virtual override returns (uint256) {
263         return _allowances[owner][spender];
264     }
265 
266     /**
267      * @dev See {IERC20-approve}.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 amount) public virtual override returns (bool) {
274         _approve(_msgSender(), spender, amount);
275         return true;
276     }
277 
278     /**
279      * @dev See {IERC20-transferFrom}.
280      *
281      * Emits an {Approval} event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of {ERC20}.
283      *
284      * Requirements:
285      *
286      * - `sender` and `recipient` cannot be the zero address.
287      * - `sender` must have a balance of at least `amount`.
288      * - the caller must have allowance for ``sender``'s tokens of at least
289      * `amount`.
290      */
291     function transferFrom(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) public virtual override returns (bool) {
296         _transfer(sender, recipient, amount);
297 
298         uint256 currentAllowance = _allowances[sender][_msgSender()];
299         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
300         unchecked {
301             _approve(sender, _msgSender(), currentAllowance - amount);
302         }
303 
304         return true;
305     }
306 
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
321         return true;
322     }
323 
324     /**
325      * @dev Atomically decreases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      * - `spender` must have allowance for the caller of at least
336      * `subtractedValue`.
337      */
338     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
339         uint256 currentAllowance = _allowances[_msgSender()][spender];
340         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
341         unchecked {
342             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
343         }
344 
345         return true;
346     }
347 
348     /**
349      * @dev Moves `amount` of tokens from `sender` to `recipient`.
350      *
351      * This internal function is equivalent to {transfer}, and can be used to
352      * e.g. implement automatic token fees, slashing mechanisms, etc.
353      *
354      * Emits a {Transfer} event.
355      *
356      * Requirements:
357      *
358      * - `sender` cannot be the zero address.
359      * - `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `amount`.
361      */
362     function _transfer(
363         address sender,
364         address recipient,
365         uint256 amount
366     ) internal virtual {
367         require(sender != address(0), "ERC20: transfer from the zero address");
368         require(recipient != address(0), "ERC20: transfer to the zero address");
369 
370         _beforeTokenTransfer(sender, recipient, amount);
371 
372         uint256 senderBalance = _balances[sender];
373         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
374         unchecked {
375             _balances[sender] = senderBalance - amount;
376         }
377         _balances[recipient] += amount;
378 
379         emit Transfer(sender, recipient, amount);
380 
381         _afterTokenTransfer(sender, recipient, amount);
382     }
383 
384     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
385      * the total supply.
386      *
387      * Emits a {Transfer} event with `from` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      */
393     function _mint(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: mint to the zero address");
395 
396         _beforeTokenTransfer(address(0), account, amount);
397 
398         _totalSupply += amount;
399         _balances[account] += amount;
400         emit Transfer(address(0), account, amount);
401 
402         _afterTokenTransfer(address(0), account, amount);
403     }
404 
405     /**
406      * @dev Destroys `amount` tokens from `account`, reducing the
407      * total supply.
408      *
409      * Emits a {Transfer} event with `to` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      * - `account` must have at least `amount` tokens.
415      */
416     function _burn(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: burn from the zero address");
418 
419         _beforeTokenTransfer(account, address(0), amount);
420 
421         uint256 accountBalance = _balances[account];
422         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
423         unchecked {
424             _balances[account] = accountBalance - amount;
425         }
426         _totalSupply -= amount;
427 
428         emit Transfer(account, address(0), amount);
429 
430         _afterTokenTransfer(account, address(0), amount);
431     }
432 
433     /**
434      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
435      *
436      * This internal function is equivalent to `approve`, and can be used to
437      * e.g. set automatic allowances for certain subsystems, etc.
438      *
439      * Emits an {Approval} event.
440      *
441      * Requirements:
442      *
443      * - `owner` cannot be the zero address.
444      * - `spender` cannot be the zero address.
445      */
446     function _approve(
447         address owner,
448         address spender,
449         uint256 amount
450     ) internal virtual {
451         require(owner != address(0), "ERC20: approve from the zero address");
452         require(spender != address(0), "ERC20: approve to the zero address");
453 
454         _allowances[owner][spender] = amount;
455         emit Approval(owner, spender, amount);
456     }
457 
458     /**
459      * @dev Hook that is called before any transfer of tokens. This includes
460      * minting and burning.
461      *
462      * Calling conditions:
463      *
464      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
465      * will be transferred to `to`.
466      * - when `from` is zero, `amount` tokens will be minted for `to`.
467      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
468      * - `from` and `to` are never both zero.
469      *
470      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
471      */
472     function _beforeTokenTransfer(
473         address from,
474         address to,
475         uint256 amount
476     ) internal virtual {}
477 
478     /**
479      * @dev Hook that is called after any transfer of tokens. This includes
480      * minting and burning.
481      *
482      * Calling conditions:
483      *
484      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
485      * has been transferred to `to`.
486      * - when `from` is zero, `amount` tokens have been minted for `to`.
487      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
488      * - `from` and `to` are never both zero.
489      *
490      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
491      */
492     function _afterTokenTransfer(
493         address from,
494         address to,
495         uint256 amount
496     ) internal virtual {}
497 }
498 
499 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
500 
501 
502 
503 pragma solidity ^0.8.0;
504 
505 
506 
507 /**
508  * @dev Extension of {ERC20} that allows token holders to destroy both their own
509  * tokens and those that they have an allowance for, in a way that can be
510  * recognized off-chain (via event analysis).
511  */
512 abstract contract ERC20Burnable is Context, ERC20 {
513     /**
514      * @dev Destroys `amount` tokens from the caller.
515      *
516      * See {ERC20-_burn}.
517      */
518     function burn(uint256 amount) public virtual {
519         _burn(_msgSender(), amount);
520     }
521 
522     /**
523      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
524      * allowance.
525      *
526      * See {ERC20-_burn} and {ERC20-allowance}.
527      *
528      * Requirements:
529      *
530      * - the caller must have allowance for ``accounts``'s tokens of at least
531      * `amount`.
532      */
533     function burnFrom(address account, uint256 amount) public virtual {
534         uint256 currentAllowance = allowance(account, _msgSender());
535         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
536         unchecked {
537             _approve(account, _msgSender(), currentAllowance - amount);
538         }
539         _burn(account, amount);
540     }
541 }
542 
543 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
544 
545 
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
552  */
553 abstract contract ERC20Capped is ERC20 {
554     uint256 private immutable _cap;
555 
556     /**
557      * @dev Sets the value of the `cap`. This value is immutable, it can only be
558      * set once during construction.
559      */
560     constructor(uint256 cap_) {
561         require(cap_ > 0, "ERC20Capped: cap is 0");
562         _cap = cap_;
563     }
564 
565     /**
566      * @dev Returns the cap on the token's total supply.
567      */
568     function cap() public view virtual returns (uint256) {
569         return _cap;
570     }
571 
572     /**
573      * @dev See {ERC20-_mint}.
574      */
575     function _mint(address account, uint256 amount) internal virtual override {
576         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
577         super._mint(account, amount);
578     }
579 }
580 
581 // File: @openzeppelin/contracts/utils/Address.sol
582 
583 
584 
585 pragma solidity ^0.8.0;
586 
587 /**
588  * @dev Collection of functions related to the address type
589  */
590 library Address {
591     /**
592      * @dev Returns true if `account` is a contract.
593      *
594      * [IMPORTANT]
595      * ====
596      * It is unsafe to assume that an address for which this function returns
597      * false is an externally-owned account (EOA) and not a contract.
598      *
599      * Among others, `isContract` will return false for the following
600      * types of addresses:
601      *
602      *  - an externally-owned account
603      *  - a contract in construction
604      *  - an address where a contract will be created
605      *  - an address where a contract lived, but was destroyed
606      * ====
607      */
608     function isContract(address account) internal view returns (bool) {
609         // This method relies on extcodesize, which returns 0 for contracts in
610         // construction, since the code is only stored at the end of the
611         // constructor execution.
612 
613         uint256 size;
614         assembly {
615             size := extcodesize(account)
616         }
617         return size > 0;
618     }
619 
620     /**
621      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
622      * `recipient`, forwarding all available gas and reverting on errors.
623      *
624      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
625      * of certain opcodes, possibly making contracts go over the 2300 gas limit
626      * imposed by `transfer`, making them unable to receive funds via
627      * `transfer`. {sendValue} removes this limitation.
628      *
629      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
630      *
631      * IMPORTANT: because control is transferred to `recipient`, care must be
632      * taken to not create reentrancy vulnerabilities. Consider using
633      * {ReentrancyGuard} or the
634      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
635      */
636     function sendValue(address payable recipient, uint256 amount) internal {
637         require(address(this).balance >= amount, "Address: insufficient balance");
638 
639         (bool success, ) = recipient.call{value: amount}("");
640         require(success, "Address: unable to send value, recipient may have reverted");
641     }
642 
643     /**
644      * @dev Performs a Solidity function call using a low level `call`. A
645      * plain `call` is an unsafe replacement for a function call: use this
646      * function instead.
647      *
648      * If `target` reverts with a revert reason, it is bubbled up by this
649      * function (like regular Solidity function calls).
650      *
651      * Returns the raw returned data. To convert to the expected return value,
652      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
653      *
654      * Requirements:
655      *
656      * - `target` must be a contract.
657      * - calling `target` with `data` must not revert.
658      *
659      * _Available since v3.1._
660      */
661     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
662         return functionCall(target, data, "Address: low-level call failed");
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
667      * `errorMessage` as a fallback revert reason when `target` reverts.
668      *
669      * _Available since v3.1._
670      */
671     function functionCall(
672         address target,
673         bytes memory data,
674         string memory errorMessage
675     ) internal returns (bytes memory) {
676         return functionCallWithValue(target, data, 0, errorMessage);
677     }
678 
679     /**
680      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
681      * but also transferring `value` wei to `target`.
682      *
683      * Requirements:
684      *
685      * - the calling contract must have an ETH balance of at least `value`.
686      * - the called Solidity function must be `payable`.
687      *
688      * _Available since v3.1._
689      */
690     function functionCallWithValue(
691         address target,
692         bytes memory data,
693         uint256 value
694     ) internal returns (bytes memory) {
695         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
700      * with `errorMessage` as a fallback revert reason when `target` reverts.
701      *
702      * _Available since v3.1._
703      */
704     function functionCallWithValue(
705         address target,
706         bytes memory data,
707         uint256 value,
708         string memory errorMessage
709     ) internal returns (bytes memory) {
710         require(address(this).balance >= value, "Address: insufficient balance for call");
711         require(isContract(target), "Address: call to non-contract");
712 
713         (bool success, bytes memory returndata) = target.call{value: value}(data);
714         return verifyCallResult(success, returndata, errorMessage);
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
719      * but performing a static call.
720      *
721      * _Available since v3.3._
722      */
723     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
724         return functionStaticCall(target, data, "Address: low-level static call failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
729      * but performing a static call.
730      *
731      * _Available since v3.3._
732      */
733     function functionStaticCall(
734         address target,
735         bytes memory data,
736         string memory errorMessage
737     ) internal view returns (bytes memory) {
738         require(isContract(target), "Address: static call to non-contract");
739 
740         (bool success, bytes memory returndata) = target.staticcall(data);
741         return verifyCallResult(success, returndata, errorMessage);
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
746      * but performing a delegate call.
747      *
748      * _Available since v3.4._
749      */
750     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
751         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
756      * but performing a delegate call.
757      *
758      * _Available since v3.4._
759      */
760     function functionDelegateCall(
761         address target,
762         bytes memory data,
763         string memory errorMessage
764     ) internal returns (bytes memory) {
765         require(isContract(target), "Address: delegate call to non-contract");
766 
767         (bool success, bytes memory returndata) = target.delegatecall(data);
768         return verifyCallResult(success, returndata, errorMessage);
769     }
770 
771     /**
772      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
773      * revert reason using the provided one.
774      *
775      * _Available since v4.3._
776      */
777     function verifyCallResult(
778         bool success,
779         bytes memory returndata,
780         string memory errorMessage
781     ) internal pure returns (bytes memory) {
782         if (success) {
783             return returndata;
784         } else {
785             // Look for revert reason and bubble it up if present
786             if (returndata.length > 0) {
787                 // The easiest way to bubble the revert reason is using memory via assembly
788 
789                 assembly {
790                     let returndata_size := mload(returndata)
791                     revert(add(32, returndata), returndata_size)
792                 }
793             } else {
794                 revert(errorMessage);
795             }
796         }
797     }
798 }
799 
800 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
801 
802 
803 
804 pragma solidity ^0.8.0;
805 
806 /**
807  * @dev Interface of the ERC165 standard, as defined in the
808  * https://eips.ethereum.org/EIPS/eip-165[EIP].
809  *
810  * Implementers can declare support of contract interfaces, which can then be
811  * queried by others ({ERC165Checker}).
812  *
813  * For an implementation, see {ERC165}.
814  */
815 interface IERC165 {
816     /**
817      * @dev Returns true if this contract implements the interface defined by
818      * `interfaceId`. See the corresponding
819      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
820      * to learn more about how these ids are created.
821      *
822      * This function call must use less than 30 000 gas.
823      */
824     function supportsInterface(bytes4 interfaceId) external view returns (bool);
825 }
826 
827 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
828 
829 
830 
831 pragma solidity ^0.8.0;
832 
833 
834 /**
835  * @dev Implementation of the {IERC165} interface.
836  *
837  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
838  * for the additional interface id that will be supported. For example:
839  *
840  * ```solidity
841  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
842  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
843  * }
844  * ```
845  *
846  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
847  */
848 abstract contract ERC165 is IERC165 {
849     /**
850      * @dev See {IERC165-supportsInterface}.
851      */
852     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
853         return interfaceId == type(IERC165).interfaceId;
854     }
855 }
856 
857 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
858 
859 
860 
861 pragma solidity ^0.8.0;
862 
863 
864 
865 /**
866  * @title IERC1363 Interface
867  * @dev Interface for a Payable Token contract as defined in
868  *  https://eips.ethereum.org/EIPS/eip-1363
869  */
870 interface IERC1363 is IERC20, IERC165 {
871     /**
872      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
873      * @param recipient address The address which you want to transfer to
874      * @param amount uint256 The amount of tokens to be transferred
875      * @return true unless throwing
876      */
877     function transferAndCall(address recipient, uint256 amount) external returns (bool);
878 
879     /**
880      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
881      * @param recipient address The address which you want to transfer to
882      * @param amount uint256 The amount of tokens to be transferred
883      * @param data bytes Additional data with no specified format, sent in call to `recipient`
884      * @return true unless throwing
885      */
886     function transferAndCall(
887         address recipient,
888         uint256 amount,
889         bytes calldata data
890     ) external returns (bool);
891 
892     /**
893      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
894      * @param sender address The address which you want to send tokens from
895      * @param recipient address The address which you want to transfer to
896      * @param amount uint256 The amount of tokens to be transferred
897      * @return true unless throwing
898      */
899     function transferFromAndCall(
900         address sender,
901         address recipient,
902         uint256 amount
903     ) external returns (bool);
904 
905     /**
906      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
907      * @param sender address The address which you want to send tokens from
908      * @param recipient address The address which you want to transfer to
909      * @param amount uint256 The amount of tokens to be transferred
910      * @param data bytes Additional data with no specified format, sent in call to `recipient`
911      * @return true unless throwing
912      */
913     function transferFromAndCall(
914         address sender,
915         address recipient,
916         uint256 amount,
917         bytes calldata data
918     ) external returns (bool);
919 
920     /**
921      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
922      * and then call `onApprovalReceived` on spender.
923      * Beware that changing an allowance with this method brings the risk that someone may use both the old
924      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
925      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
926      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
927      * @param spender address The address which will spend the funds
928      * @param amount uint256 The amount of tokens to be spent
929      */
930     function approveAndCall(address spender, uint256 amount) external returns (bool);
931 
932     /**
933      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
934      * and then call `onApprovalReceived` on spender.
935      * Beware that changing an allowance with this method brings the risk that someone may use both the old
936      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
937      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
938      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
939      * @param spender address The address which will spend the funds
940      * @param amount uint256 The amount of tokens to be spent
941      * @param data bytes Additional data with no specified format, sent in call to `spender`
942      */
943     function approveAndCall(
944         address spender,
945         uint256 amount,
946         bytes calldata data
947     ) external returns (bool);
948 }
949 
950 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
951 
952 
953 
954 pragma solidity ^0.8.0;
955 
956 /**
957  * @title IERC1363Receiver Interface
958  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
959  *  from ERC1363 token contracts as defined in
960  *  https://eips.ethereum.org/EIPS/eip-1363
961  */
962 interface IERC1363Receiver {
963     /**
964      * @notice Handle the receipt of ERC1363 tokens
965      * @dev Any ERC1363 smart contract calls this function on the recipient
966      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
967      * transfer. Return of other than the magic value MUST result in the
968      * transaction being reverted.
969      * Note: the token contract address is always the message sender.
970      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
971      * @param sender address The address which are token transferred from
972      * @param amount uint256 The amount of tokens transferred
973      * @param data bytes Additional data with no specified format
974      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
975      */
976     function onTransferReceived(
977         address operator,
978         address sender,
979         uint256 amount,
980         bytes calldata data
981     ) external returns (bytes4);
982 }
983 
984 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
985 
986 
987 
988 pragma solidity ^0.8.0;
989 
990 /**
991  * @title IERC1363Spender Interface
992  * @dev Interface for any contract that wants to support approveAndCall
993  *  from ERC1363 token contracts as defined in
994  *  https://eips.ethereum.org/EIPS/eip-1363
995  */
996 interface IERC1363Spender {
997     /**
998      * @notice Handle the approval of ERC1363 tokens
999      * @dev Any ERC1363 smart contract calls this function on the recipient
1000      * after an `approve`. This function MAY throw to revert and reject the
1001      * approval. Return of other than the magic value MUST result in the
1002      * transaction being reverted.
1003      * Note: the token contract address is always the message sender.
1004      * @param sender address The address which called `approveAndCall` function
1005      * @param amount uint256 The amount of tokens to be spent
1006      * @param data bytes Additional data with no specified format
1007      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
1008      */
1009     function onApprovalReceived(
1010         address sender,
1011         uint256 amount,
1012         bytes calldata data
1013     ) external returns (bytes4);
1014 }
1015 
1016 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1017 
1018 
1019 
1020 pragma solidity ^0.8.0;
1021 
1022 
1023 
1024 
1025 
1026 
1027 
1028 /**
1029  * @title ERC1363
1030  * @dev Implementation of an ERC1363 interface
1031  */
1032 abstract contract ERC1363 is ERC20, IERC1363, ERC165 {
1033     using Address for address;
1034 
1035     /**
1036      * @dev See {IERC165-supportsInterface}.
1037      */
1038     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1039         return interfaceId == type(IERC1363).interfaceId || super.supportsInterface(interfaceId);
1040     }
1041 
1042     /**
1043      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1044      * @param recipient The address to transfer to.
1045      * @param amount The amount to be transferred.
1046      * @return A boolean that indicates if the operation was successful.
1047      */
1048     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
1049         return transferAndCall(recipient, amount, "");
1050     }
1051 
1052     /**
1053      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1054      * @param recipient The address to transfer to
1055      * @param amount The amount to be transferred
1056      * @param data Additional data with no specified format
1057      * @return A boolean that indicates if the operation was successful.
1058      */
1059     function transferAndCall(
1060         address recipient,
1061         uint256 amount,
1062         bytes memory data
1063     ) public virtual override returns (bool) {
1064         transfer(recipient, amount);
1065         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1066         return true;
1067     }
1068 
1069     /**
1070      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1071      * @param sender The address which you want to send tokens from
1072      * @param recipient The address which you want to transfer to
1073      * @param amount The amount of tokens to be transferred
1074      * @return A boolean that indicates if the operation was successful.
1075      */
1076     function transferFromAndCall(
1077         address sender,
1078         address recipient,
1079         uint256 amount
1080     ) public virtual override returns (bool) {
1081         return transferFromAndCall(sender, recipient, amount, "");
1082     }
1083 
1084     /**
1085      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1086      * @param sender The address which you want to send tokens from
1087      * @param recipient The address which you want to transfer to
1088      * @param amount The amount of tokens to be transferred
1089      * @param data Additional data with no specified format
1090      * @return A boolean that indicates if the operation was successful.
1091      */
1092     function transferFromAndCall(
1093         address sender,
1094         address recipient,
1095         uint256 amount,
1096         bytes memory data
1097     ) public virtual override returns (bool) {
1098         transferFrom(sender, recipient, amount);
1099         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1100         return true;
1101     }
1102 
1103     /**
1104      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1105      * @param spender The address allowed to transfer to
1106      * @param amount The amount allowed to be transferred
1107      * @return A boolean that indicates if the operation was successful.
1108      */
1109     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
1110         return approveAndCall(spender, amount, "");
1111     }
1112 
1113     /**
1114      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1115      * @param spender The address allowed to transfer to.
1116      * @param amount The amount allowed to be transferred.
1117      * @param data Additional data with no specified format.
1118      * @return A boolean that indicates if the operation was successful.
1119      */
1120     function approveAndCall(
1121         address spender,
1122         uint256 amount,
1123         bytes memory data
1124     ) public virtual override returns (bool) {
1125         approve(spender, amount);
1126         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
1127         return true;
1128     }
1129 
1130     /**
1131      * @dev Internal function to invoke `onTransferReceived` on a target address
1132      *  The call is not executed if the target address is not a contract
1133      * @param sender address Representing the previous owner of the given token value
1134      * @param recipient address Target address that will receive the tokens
1135      * @param amount uint256 The amount mount of tokens to be transferred
1136      * @param data bytes Optional data to send along with the call
1137      * @return whether the call correctly returned the expected magic value
1138      */
1139     function _checkAndCallTransfer(
1140         address sender,
1141         address recipient,
1142         uint256 amount,
1143         bytes memory data
1144     ) internal virtual returns (bool) {
1145         if (!recipient.isContract()) {
1146             return false;
1147         }
1148         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(_msgSender(), sender, amount, data);
1149         return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
1150     }
1151 
1152     /**
1153      * @dev Internal function to invoke `onApprovalReceived` on a target address
1154      *  The call is not executed if the target address is not a contract
1155      * @param spender address The address which will spend the funds
1156      * @param amount uint256 The amount of tokens to be spent
1157      * @param data bytes Optional data to send along with the call
1158      * @return whether the call correctly returned the expected magic value
1159      */
1160     function _checkAndCallApprove(
1161         address spender,
1162         uint256 amount,
1163         bytes memory data
1164     ) internal virtual returns (bool) {
1165         if (!spender.isContract()) {
1166             return false;
1167         }
1168         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(_msgSender(), amount, data);
1169         return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
1170     }
1171 }
1172 
1173 // File: @openzeppelin/contracts/access/Ownable.sol
1174 
1175 
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 
1180 /**
1181  * @dev Contract module which provides a basic access control mechanism, where
1182  * there is an account (an owner) that can be granted exclusive access to
1183  * specific functions.
1184  *
1185  * By default, the owner account will be the one that deploys the contract. This
1186  * can later be changed with {transferOwnership}.
1187  *
1188  * This module is used through inheritance. It will make available the modifier
1189  * `onlyOwner`, which can be applied to your functions to restrict their use to
1190  * the owner.
1191  */
1192 abstract contract Ownable is Context {
1193     address private _owner;
1194 
1195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1196 
1197     /**
1198      * @dev Initializes the contract setting the deployer as the initial owner.
1199      */
1200     constructor() {
1201         _setOwner(_msgSender());
1202     }
1203 
1204     /**
1205      * @dev Returns the address of the current owner.
1206      */
1207     function owner() public view virtual returns (address) {
1208         return _owner;
1209     }
1210 
1211     /**
1212      * @dev Throws if called by any account other than the owner.
1213      */
1214     modifier onlyOwner() {
1215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1216         _;
1217     }
1218 
1219     /**
1220      * @dev Leaves the contract without owner. It will not be possible to call
1221      * `onlyOwner` functions anymore. Can only be called by the current owner.
1222      *
1223      * NOTE: Renouncing ownership will leave the contract without an owner,
1224      * thereby removing any functionality that is only available to the owner.
1225      */
1226     function renounceOwnership() public virtual onlyOwner {
1227         _setOwner(address(0));
1228     }
1229 
1230     /**
1231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1232      * Can only be called by the current owner.
1233      */
1234     function transferOwnership(address newOwner) public virtual onlyOwner {
1235         require(newOwner != address(0), "Ownable: new owner is the zero address");
1236         _setOwner(newOwner);
1237     }
1238 
1239     function _setOwner(address newOwner) private {
1240         address oldOwner = _owner;
1241         _owner = newOwner;
1242         emit OwnershipTransferred(oldOwner, newOwner);
1243     }
1244 }
1245 
1246 // File: eth-token-recover/contracts/TokenRecover.sol
1247 
1248 
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 
1253 
1254 /**
1255  * @title TokenRecover
1256  * @dev Allows owner to recover any ERC20 sent into the contract
1257  */
1258 contract TokenRecover is Ownable {
1259     /**
1260      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1261      * @param tokenAddress The token contract address
1262      * @param tokenAmount Number of tokens to be sent
1263      */
1264     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
1265         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1266     }
1267 }
1268 
1269 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
1270 
1271 
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 
1276 /**
1277  * @title ERC20Decimals
1278  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
1279  */
1280 abstract contract ERC20Decimals is ERC20 {
1281     uint8 private immutable _decimals;
1282 
1283     /**
1284      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
1285      * set once during construction.
1286      */
1287     constructor(uint8 decimals_) {
1288         _decimals = decimals_;
1289     }
1290 
1291     function decimals() public view virtual override returns (uint8) {
1292         return _decimals;
1293     }
1294 }
1295 
1296 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
1297 
1298 
1299 
1300 pragma solidity ^0.8.0;
1301 
1302 
1303 /**
1304  * @title ERC20Mintable
1305  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
1306  */
1307 abstract contract ERC20Mintable is ERC20 {
1308     // indicates if minting is finished
1309     bool private _mintingFinished = false;
1310 
1311     /**
1312      * @dev Emitted during finish minting
1313      */
1314     event MintFinished();
1315 
1316     /**
1317      * @dev Tokens can be minted only before minting finished.
1318      */
1319     modifier canMint() {
1320         require(!_mintingFinished, "ERC20Mintable: minting is finished");
1321         _;
1322     }
1323 
1324     /**
1325      * @return if minting is finished or not.
1326      */
1327     function mintingFinished() external view returns (bool) {
1328         return _mintingFinished;
1329     }
1330 
1331     /**
1332      * @dev Function to mint tokens.
1333      *
1334      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
1335      *
1336      * @param account The address that will receive the minted tokens
1337      * @param amount The amount of tokens to mint
1338      */
1339     function mint(address account, uint256 amount) external canMint {
1340         _mint(account, amount);
1341     }
1342 
1343     /**
1344      * @dev Function to stop minting new tokens.
1345      *
1346      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
1347      */
1348     function finishMinting() external canMint {
1349         _finishMinting();
1350     }
1351 
1352     /**
1353      * @dev Function to stop minting new tokens.
1354      */
1355     function _finishMinting() internal virtual {
1356         _mintingFinished = true;
1357 
1358         emit MintFinished();
1359     }
1360 }
1361 
1362 // File: @openzeppelin/contracts/access/IAccessControl.sol
1363 
1364 
1365 
1366 pragma solidity ^0.8.0;
1367 
1368 /**
1369  * @dev External interface of AccessControl declared to support ERC165 detection.
1370  */
1371 interface IAccessControl {
1372     /**
1373      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1374      *
1375      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1376      * {RoleAdminChanged} not being emitted signaling this.
1377      *
1378      * _Available since v3.1._
1379      */
1380     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1381 
1382     /**
1383      * @dev Emitted when `account` is granted `role`.
1384      *
1385      * `sender` is the account that originated the contract call, an admin role
1386      * bearer except when using {AccessControl-_setupRole}.
1387      */
1388     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1389 
1390     /**
1391      * @dev Emitted when `account` is revoked `role`.
1392      *
1393      * `sender` is the account that originated the contract call:
1394      *   - if using `revokeRole`, it is the admin role bearer
1395      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1396      */
1397     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1398 
1399     /**
1400      * @dev Returns `true` if `account` has been granted `role`.
1401      */
1402     function hasRole(bytes32 role, address account) external view returns (bool);
1403 
1404     /**
1405      * @dev Returns the admin role that controls `role`. See {grantRole} and
1406      * {revokeRole}.
1407      *
1408      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1409      */
1410     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1411 
1412     /**
1413      * @dev Grants `role` to `account`.
1414      *
1415      * If `account` had not been already granted `role`, emits a {RoleGranted}
1416      * event.
1417      *
1418      * Requirements:
1419      *
1420      * - the caller must have ``role``'s admin role.
1421      */
1422     function grantRole(bytes32 role, address account) external;
1423 
1424     /**
1425      * @dev Revokes `role` from `account`.
1426      *
1427      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1428      *
1429      * Requirements:
1430      *
1431      * - the caller must have ``role``'s admin role.
1432      */
1433     function revokeRole(bytes32 role, address account) external;
1434 
1435     /**
1436      * @dev Revokes `role` from the calling account.
1437      *
1438      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1439      * purpose is to provide a mechanism for accounts to lose their privileges
1440      * if they are compromised (such as when a trusted device is misplaced).
1441      *
1442      * If the calling account had been granted `role`, emits a {RoleRevoked}
1443      * event.
1444      *
1445      * Requirements:
1446      *
1447      * - the caller must be `account`.
1448      */
1449     function renounceRole(bytes32 role, address account) external;
1450 }
1451 
1452 // File: @openzeppelin/contracts/utils/Strings.sol
1453 
1454 
1455 
1456 pragma solidity ^0.8.0;
1457 
1458 /**
1459  * @dev String operations.
1460  */
1461 library Strings {
1462     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1463 
1464     /**
1465      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1466      */
1467     function toString(uint256 value) internal pure returns (string memory) {
1468         // Inspired by OraclizeAPI's implementation - MIT licence
1469         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1470 
1471         if (value == 0) {
1472             return "0";
1473         }
1474         uint256 temp = value;
1475         uint256 digits;
1476         while (temp != 0) {
1477             digits++;
1478             temp /= 10;
1479         }
1480         bytes memory buffer = new bytes(digits);
1481         while (value != 0) {
1482             digits -= 1;
1483             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1484             value /= 10;
1485         }
1486         return string(buffer);
1487     }
1488 
1489     /**
1490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1491      */
1492     function toHexString(uint256 value) internal pure returns (string memory) {
1493         if (value == 0) {
1494             return "0x00";
1495         }
1496         uint256 temp = value;
1497         uint256 length = 0;
1498         while (temp != 0) {
1499             length++;
1500             temp >>= 8;
1501         }
1502         return toHexString(value, length);
1503     }
1504 
1505     /**
1506      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1507      */
1508     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1509         bytes memory buffer = new bytes(2 * length + 2);
1510         buffer[0] = "0";
1511         buffer[1] = "x";
1512         for (uint256 i = 2 * length + 1; i > 1; --i) {
1513             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1514             value >>= 4;
1515         }
1516         require(value == 0, "Strings: hex length insufficient");
1517         return string(buffer);
1518     }
1519 }
1520 
1521 // File: @openzeppelin/contracts/access/AccessControl.sol
1522 
1523 
1524 
1525 pragma solidity ^0.8.0;
1526 
1527 
1528 
1529 
1530 
1531 /**
1532  * @dev Contract module that allows children to implement role-based access
1533  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1534  * members except through off-chain means by accessing the contract event logs. Some
1535  * applications may benefit from on-chain enumerability, for those cases see
1536  * {AccessControlEnumerable}.
1537  *
1538  * Roles are referred to by their `bytes32` identifier. These should be exposed
1539  * in the external API and be unique. The best way to achieve this is by
1540  * using `public constant` hash digests:
1541  *
1542  * ```
1543  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1544  * ```
1545  *
1546  * Roles can be used to represent a set of permissions. To restrict access to a
1547  * function call, use {hasRole}:
1548  *
1549  * ```
1550  * function foo() public {
1551  *     require(hasRole(MY_ROLE, msg.sender));
1552  *     ...
1553  * }
1554  * ```
1555  *
1556  * Roles can be granted and revoked dynamically via the {grantRole} and
1557  * {revokeRole} functions. Each role has an associated admin role, and only
1558  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1559  *
1560  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1561  * that only accounts with this role will be able to grant or revoke other
1562  * roles. More complex role relationships can be created by using
1563  * {_setRoleAdmin}.
1564  *
1565  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1566  * grant and revoke this role. Extra precautions should be taken to secure
1567  * accounts that have been granted it.
1568  */
1569 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1570     struct RoleData {
1571         mapping(address => bool) members;
1572         bytes32 adminRole;
1573     }
1574 
1575     mapping(bytes32 => RoleData) private _roles;
1576 
1577     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1578 
1579     /**
1580      * @dev Modifier that checks that an account has a specific role. Reverts
1581      * with a standardized message including the required role.
1582      *
1583      * The format of the revert reason is given by the following regular expression:
1584      *
1585      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1586      *
1587      * _Available since v4.1._
1588      */
1589     modifier onlyRole(bytes32 role) {
1590         _checkRole(role, _msgSender());
1591         _;
1592     }
1593 
1594     /**
1595      * @dev See {IERC165-supportsInterface}.
1596      */
1597     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1598         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1599     }
1600 
1601     /**
1602      * @dev Returns `true` if `account` has been granted `role`.
1603      */
1604     function hasRole(bytes32 role, address account) public view override returns (bool) {
1605         return _roles[role].members[account];
1606     }
1607 
1608     /**
1609      * @dev Revert with a standard message if `account` is missing `role`.
1610      *
1611      * The format of the revert reason is given by the following regular expression:
1612      *
1613      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1614      */
1615     function _checkRole(bytes32 role, address account) internal view {
1616         if (!hasRole(role, account)) {
1617             revert(
1618                 string(
1619                     abi.encodePacked(
1620                         "AccessControl: account ",
1621                         Strings.toHexString(uint160(account), 20),
1622                         " is missing role ",
1623                         Strings.toHexString(uint256(role), 32)
1624                     )
1625                 )
1626             );
1627         }
1628     }
1629 
1630     /**
1631      * @dev Returns the admin role that controls `role`. See {grantRole} and
1632      * {revokeRole}.
1633      *
1634      * To change a role's admin, use {_setRoleAdmin}.
1635      */
1636     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1637         return _roles[role].adminRole;
1638     }
1639 
1640     /**
1641      * @dev Grants `role` to `account`.
1642      *
1643      * If `account` had not been already granted `role`, emits a {RoleGranted}
1644      * event.
1645      *
1646      * Requirements:
1647      *
1648      * - the caller must have ``role``'s admin role.
1649      */
1650     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1651         _grantRole(role, account);
1652     }
1653 
1654     /**
1655      * @dev Revokes `role` from `account`.
1656      *
1657      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1658      *
1659      * Requirements:
1660      *
1661      * - the caller must have ``role``'s admin role.
1662      */
1663     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1664         _revokeRole(role, account);
1665     }
1666 
1667     /**
1668      * @dev Revokes `role` from the calling account.
1669      *
1670      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1671      * purpose is to provide a mechanism for accounts to lose their privileges
1672      * if they are compromised (such as when a trusted device is misplaced).
1673      *
1674      * If the calling account had been granted `role`, emits a {RoleRevoked}
1675      * event.
1676      *
1677      * Requirements:
1678      *
1679      * - the caller must be `account`.
1680      */
1681     function renounceRole(bytes32 role, address account) public virtual override {
1682         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1683 
1684         _revokeRole(role, account);
1685     }
1686 
1687     /**
1688      * @dev Grants `role` to `account`.
1689      *
1690      * If `account` had not been already granted `role`, emits a {RoleGranted}
1691      * event. Note that unlike {grantRole}, this function doesn't perform any
1692      * checks on the calling account.
1693      *
1694      * [WARNING]
1695      * ====
1696      * This function should only be called from the constructor when setting
1697      * up the initial roles for the system.
1698      *
1699      * Using this function in any other way is effectively circumventing the admin
1700      * system imposed by {AccessControl}.
1701      * ====
1702      */
1703     function _setupRole(bytes32 role, address account) internal virtual {
1704         _grantRole(role, account);
1705     }
1706 
1707     /**
1708      * @dev Sets `adminRole` as ``role``'s admin role.
1709      *
1710      * Emits a {RoleAdminChanged} event.
1711      */
1712     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1713         bytes32 previousAdminRole = getRoleAdmin(role);
1714         _roles[role].adminRole = adminRole;
1715         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1716     }
1717 
1718     function _grantRole(bytes32 role, address account) private {
1719         if (!hasRole(role, account)) {
1720             _roles[role].members[account] = true;
1721             emit RoleGranted(role, account, _msgSender());
1722         }
1723     }
1724 
1725     function _revokeRole(bytes32 role, address account) private {
1726         if (hasRole(role, account)) {
1727             _roles[role].members[account] = false;
1728             emit RoleRevoked(role, account, _msgSender());
1729         }
1730     }
1731 }
1732 
1733 // File: contracts/access/Roles.sol
1734 
1735 
1736 
1737 pragma solidity ^0.8.0;
1738 
1739 
1740 contract Roles is AccessControl {
1741     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1742 
1743     constructor() {
1744         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1745         _setupRole(MINTER_ROLE, _msgSender());
1746     }
1747 
1748     modifier onlyMinter() {
1749         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1750         _;
1751     }
1752 }
1753 
1754 // File: contracts/service/ServicePayer.sol
1755 
1756 
1757 
1758 pragma solidity ^0.8.0;
1759 
1760 interface IPayable {
1761     function pay(string memory serviceName) external payable;
1762 }
1763 
1764 /**
1765  * @title ServicePayer
1766  * @dev Implementation of the ServicePayer
1767  */
1768 abstract contract ServicePayer {
1769     constructor(address payable receiver, string memory serviceName) payable {
1770         IPayable(receiver).pay{value: msg.value}(serviceName);
1771     }
1772 }
1773 
1774 // File: contracts/token/ERC20/PowerfulERC20.sol
1775 
1776 
1777 
1778 pragma solidity ^0.8.0;
1779 
1780 
1781 
1782 
1783 
1784 
1785 
1786 
1787 
1788 /**
1789  * @title PowerfulERC20
1790  * @dev Implementation of the PowerfulERC20
1791  */
1792 contract PowerfulERC20 is
1793     ERC20Decimals,
1794     ERC20Capped,
1795     ERC20Mintable,
1796     ERC20Burnable,
1797     ERC1363,
1798     TokenRecover,
1799     Roles,
1800     ServicePayer
1801 {
1802     constructor(
1803         string memory name_,
1804         string memory symbol_,
1805         uint8 decimals_,
1806         uint256 cap_,
1807         uint256 initialBalance_,
1808         address payable feeReceiver_
1809     )
1810         payable
1811         ERC20(name_, symbol_)
1812         ERC20Decimals(decimals_)
1813         ERC20Capped(cap_)
1814         ServicePayer(feeReceiver_, "PowerfulERC20")
1815     {
1816         // Immutable variables cannot be read during contract creation time
1817         // https://github.com/ethereum/solidity/issues/10463
1818         require(initialBalance_ <= cap_, "ERC20Capped: cap exceeded");
1819         ERC20._mint(_msgSender(), initialBalance_);
1820     }
1821 
1822     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
1823         return super.decimals();
1824     }
1825 
1826     function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC1363) returns (bool) {
1827         return super.supportsInterface(interfaceId);
1828     }
1829 
1830     /**
1831      * @dev Function to mint tokens.
1832      *
1833      * NOTE: restricting access to addresses with MINTER role. See {ERC20Mintable-mint}.
1834      *
1835      * @param account The address that will receive the minted tokens
1836      * @param amount The amount of tokens to mint
1837      */
1838     function _mint(address account, uint256 amount) internal override(ERC20, ERC20Capped) onlyMinter {
1839         super._mint(account, amount);
1840     }
1841 
1842     /**
1843      * @dev Function to stop minting new tokens.
1844      *
1845      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
1846      */
1847     function _finishMinting() internal override onlyOwner {
1848         super._finishMinting();
1849     }
1850 }
