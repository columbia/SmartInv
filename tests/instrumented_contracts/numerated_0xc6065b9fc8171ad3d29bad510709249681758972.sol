1 // Sources flattened with hardhat v2.6.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.1
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
87 
88 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.1
89 
90 
91 
92 pragma solidity ^0.8.0;
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
116 
117 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
118 
119 
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 
144 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.1
145 
146 
147 
148 pragma solidity ^0.8.0;
149 
150 
151 
152 /**
153  * @dev Implementation of the {IERC20} interface.
154  *
155  * This implementation is agnostic to the way tokens are created. This means
156  * that a supply mechanism has to be added in a derived contract using {_mint}.
157  * For a generic mechanism see {ERC20PresetMinterPauser}.
158  *
159  * TIP: For a detailed writeup see our guide
160  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
161  * to implement supply mechanisms].
162  *
163  * We have followed general OpenZeppelin Contracts guidelines: functions revert
164  * instead returning `false` on failure. This behavior is nonetheless
165  * conventional and does not conflict with the expectations of ERC20
166  * applications.
167  *
168  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
169  * This allows applications to reconstruct the allowance for all accounts just
170  * by listening to said events. Other implementations of the EIP may not emit
171  * these events, as it isn't required by the specification.
172  *
173  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
174  * functions have been added to mitigate the well-known issues around setting
175  * allowances. See {IERC20-approve}.
176  */
177 contract ERC20 is Context, IERC20, IERC20Metadata {
178     mapping(address => uint256) private _balances;
179 
180     mapping(address => mapping(address => uint256)) private _allowances;
181 
182     uint256 private _totalSupply;
183 
184     string private _name;
185     string private _symbol;
186 
187     /**
188      * @dev Sets the values for {name} and {symbol}.
189      *
190      * The default value of {decimals} is 18. To select a different value for
191      * {decimals} you should overload it.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200 
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207 
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215 
216     /**
217      * @dev Returns the number of decimals used to get its user representation.
218      * For example, if `decimals` equals `2`, a balance of `505` tokens should
219      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
220      *
221      * Tokens usually opt for a value of 18, imitating the relationship between
222      * Ether and Wei. This is the value {ERC20} uses, unless this function is
223      * overridden;
224      *
225      * NOTE: This information is only used for _display_ purposes: it in
226      * no way affects any of the arithmetic of the contract, including
227      * {IERC20-balanceOf} and {IERC20-transfer}.
228      */
229     function decimals() public view virtual override returns (uint8) {
230         return 18;
231     }
232 
233     /**
234      * @dev See {IERC20-totalSupply}.
235      */
236     function totalSupply() public view virtual override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241      * @dev See {IERC20-balanceOf}.
242      */
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     /**
248      * @dev See {IERC20-transfer}.
249      *
250      * Requirements:
251      *
252      * - `recipient` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     /**
280      * @dev See {IERC20-transferFrom}.
281      *
282      * Emits an {Approval} event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of {ERC20}.
284      *
285      * Requirements:
286      *
287      * - `sender` and `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      * - the caller must have allowance for ``sender``'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public virtual override returns (bool) {
297         _transfer(sender, recipient, amount);
298 
299         uint256 currentAllowance = _allowances[sender][_msgSender()];
300         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
301         unchecked {
302             _approve(sender, _msgSender(), currentAllowance - amount);
303         }
304 
305         return true;
306     }
307 
308     /**
309      * @dev Atomically increases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         uint256 currentAllowance = _allowances[_msgSender()][spender];
341         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
342         unchecked {
343             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
344         }
345 
346         return true;
347     }
348 
349     /**
350      * @dev Moves `amount` of tokens from `sender` to `recipient`.
351      *
352      * This internal function is equivalent to {transfer}, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a {Transfer} event.
356      *
357      * Requirements:
358      *
359      * - `sender` cannot be the zero address.
360      * - `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      */
363     function _transfer(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) internal virtual {
368         require(sender != address(0), "ERC20: transfer from the zero address");
369         require(recipient != address(0), "ERC20: transfer to the zero address");
370 
371         _beforeTokenTransfer(sender, recipient, amount);
372 
373         uint256 senderBalance = _balances[sender];
374         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
375         unchecked {
376             _balances[sender] = senderBalance - amount;
377         }
378         _balances[recipient] += amount;
379 
380         emit Transfer(sender, recipient, amount);
381 
382         _afterTokenTransfer(sender, recipient, amount);
383     }
384 
385     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
386      * the total supply.
387      *
388      * Emits a {Transfer} event with `from` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      */
394     function _mint(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: mint to the zero address");
396 
397         _beforeTokenTransfer(address(0), account, amount);
398 
399         _totalSupply += amount;
400         _balances[account] += amount;
401         emit Transfer(address(0), account, amount);
402 
403         _afterTokenTransfer(address(0), account, amount);
404     }
405 
406     /**
407      * @dev Destroys `amount` tokens from `account`, reducing the
408      * total supply.
409      *
410      * Emits a {Transfer} event with `to` set to the zero address.
411      *
412      * Requirements:
413      *
414      * - `account` cannot be the zero address.
415      * - `account` must have at least `amount` tokens.
416      */
417     function _burn(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: burn from the zero address");
419 
420         _beforeTokenTransfer(account, address(0), amount);
421 
422         uint256 accountBalance = _balances[account];
423         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
424         unchecked {
425             _balances[account] = accountBalance - amount;
426         }
427         _totalSupply -= amount;
428 
429         emit Transfer(account, address(0), amount);
430 
431         _afterTokenTransfer(account, address(0), amount);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(
448         address owner,
449         address spender,
450         uint256 amount
451     ) internal virtual {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454 
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458 
459     /**
460      * @dev Hook that is called before any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * will be transferred to `to`.
467      * - when `from` is zero, `amount` tokens will be minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _beforeTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 
479     /**
480      * @dev Hook that is called after any transfer of tokens. This includes
481      * minting and burning.
482      *
483      * Calling conditions:
484      *
485      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
486      * has been transferred to `to`.
487      * - when `from` is zero, `amount` tokens have been minted for `to`.
488      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
489      * - `from` and `to` are never both zero.
490      *
491      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
492      */
493     function _afterTokenTransfer(
494         address from,
495         address to,
496         uint256 amount
497     ) internal virtual {}
498 }
499 
500 
501 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
502 
503 
504 
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @dev Collection of functions related to the address type
509  */
510 library Address {
511     /**
512      * @dev Returns true if `account` is a contract.
513      *
514      * [IMPORTANT]
515      * ====
516      * It is unsafe to assume that an address for which this function returns
517      * false is an externally-owned account (EOA) and not a contract.
518      *
519      * Among others, `isContract` will return false for the following
520      * types of addresses:
521      *
522      *  - an externally-owned account
523      *  - a contract in construction
524      *  - an address where a contract will be created
525      *  - an address where a contract lived, but was destroyed
526      * ====
527      */
528     function isContract(address account) internal view returns (bool) {
529         // This method relies on extcodesize, which returns 0 for contracts in
530         // construction, since the code is only stored at the end of the
531         // constructor execution.
532 
533         uint256 size;
534         assembly {
535             size := extcodesize(account)
536         }
537         return size > 0;
538     }
539 
540     /**
541      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
542      * `recipient`, forwarding all available gas and reverting on errors.
543      *
544      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
545      * of certain opcodes, possibly making contracts go over the 2300 gas limit
546      * imposed by `transfer`, making them unable to receive funds via
547      * `transfer`. {sendValue} removes this limitation.
548      *
549      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
550      *
551      * IMPORTANT: because control is transferred to `recipient`, care must be
552      * taken to not create reentrancy vulnerabilities. Consider using
553      * {ReentrancyGuard} or the
554      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
555      */
556     function sendValue(address payable recipient, uint256 amount) internal {
557         require(address(this).balance >= amount, "Address: insufficient balance");
558 
559         (bool success, ) = recipient.call{value: amount}("");
560         require(success, "Address: unable to send value, recipient may have reverted");
561     }
562 
563     /**
564      * @dev Performs a Solidity function call using a low level `call`. A
565      * plain `call` is an unsafe replacement for a function call: use this
566      * function instead.
567      *
568      * If `target` reverts with a revert reason, it is bubbled up by this
569      * function (like regular Solidity function calls).
570      *
571      * Returns the raw returned data. To convert to the expected return value,
572      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
573      *
574      * Requirements:
575      *
576      * - `target` must be a contract.
577      * - calling `target` with `data` must not revert.
578      *
579      * _Available since v3.1._
580      */
581     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
582         return functionCall(target, data, "Address: low-level call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
587      * `errorMessage` as a fallback revert reason when `target` reverts.
588      *
589      * _Available since v3.1._
590      */
591     function functionCall(
592         address target,
593         bytes memory data,
594         string memory errorMessage
595     ) internal returns (bytes memory) {
596         return functionCallWithValue(target, data, 0, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but also transferring `value` wei to `target`.
602      *
603      * Requirements:
604      *
605      * - the calling contract must have an ETH balance of at least `value`.
606      * - the called Solidity function must be `payable`.
607      *
608      * _Available since v3.1._
609      */
610     function functionCallWithValue(
611         address target,
612         bytes memory data,
613         uint256 value
614     ) internal returns (bytes memory) {
615         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
620      * with `errorMessage` as a fallback revert reason when `target` reverts.
621      *
622      * _Available since v3.1._
623      */
624     function functionCallWithValue(
625         address target,
626         bytes memory data,
627         uint256 value,
628         string memory errorMessage
629     ) internal returns (bytes memory) {
630         require(address(this).balance >= value, "Address: insufficient balance for call");
631         require(isContract(target), "Address: call to non-contract");
632 
633         (bool success, bytes memory returndata) = target.call{value: value}(data);
634         return verifyCallResult(success, returndata, errorMessage);
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
639      * but performing a static call.
640      *
641      * _Available since v3.3._
642      */
643     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
644         return functionStaticCall(target, data, "Address: low-level static call failed");
645     }
646 
647     /**
648      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
649      * but performing a static call.
650      *
651      * _Available since v3.3._
652      */
653     function functionStaticCall(
654         address target,
655         bytes memory data,
656         string memory errorMessage
657     ) internal view returns (bytes memory) {
658         require(isContract(target), "Address: static call to non-contract");
659 
660         (bool success, bytes memory returndata) = target.staticcall(data);
661         return verifyCallResult(success, returndata, errorMessage);
662     }
663 
664     /**
665      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
666      * but performing a delegate call.
667      *
668      * _Available since v3.4._
669      */
670     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
671         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
676      * but performing a delegate call.
677      *
678      * _Available since v3.4._
679      */
680     function functionDelegateCall(
681         address target,
682         bytes memory data,
683         string memory errorMessage
684     ) internal returns (bytes memory) {
685         require(isContract(target), "Address: delegate call to non-contract");
686 
687         (bool success, bytes memory returndata) = target.delegatecall(data);
688         return verifyCallResult(success, returndata, errorMessage);
689     }
690 
691     /**
692      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
693      * revert reason using the provided one.
694      *
695      * _Available since v4.3._
696      */
697     function verifyCallResult(
698         bool success,
699         bytes memory returndata,
700         string memory errorMessage
701     ) internal pure returns (bytes memory) {
702         if (success) {
703             return returndata;
704         } else {
705             // Look for revert reason and bubble it up if present
706             if (returndata.length > 0) {
707                 // The easiest way to bubble the revert reason is using memory via assembly
708 
709                 assembly {
710                     let returndata_size := mload(returndata)
711                     revert(add(32, returndata), returndata_size)
712                 }
713             } else {
714                 revert(errorMessage);
715             }
716         }
717     }
718 }
719 
720 
721 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
722 
723 
724 
725 pragma solidity ^0.8.0;
726 
727 /**
728  * @dev Interface of the ERC165 standard, as defined in the
729  * https://eips.ethereum.org/EIPS/eip-165[EIP].
730  *
731  * Implementers can declare support of contract interfaces, which can then be
732  * queried by others ({ERC165Checker}).
733  *
734  * For an implementation, see {ERC165}.
735  */
736 interface IERC165 {
737     /**
738      * @dev Returns true if this contract implements the interface defined by
739      * `interfaceId`. See the corresponding
740      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
741      * to learn more about how these ids are created.
742      *
743      * This function call must use less than 30 000 gas.
744      */
745     function supportsInterface(bytes4 interfaceId) external view returns (bool);
746 }
747 
748 
749 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
750 
751 
752 
753 pragma solidity ^0.8.0;
754 
755 /**
756  * @dev Implementation of the {IERC165} interface.
757  *
758  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
759  * for the additional interface id that will be supported. For example:
760  *
761  * ```solidity
762  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
763  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
764  * }
765  * ```
766  *
767  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
768  */
769 abstract contract ERC165 is IERC165 {
770     /**
771      * @dev See {IERC165-supportsInterface}.
772      */
773     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
774         return interfaceId == type(IERC165).interfaceId;
775     }
776 }
777 
778 
779 // File erc-payable-token/contracts/token/ERC1363/IERC1363.sol@v4.3.0
780 
781 
782 
783 pragma solidity ^0.8.0;
784 
785 
786 /**
787  * @title IERC1363 Interface
788  * @author Vittorio Minacori (https://github.com/vittominacori)
789  * @dev Interface for a Payable Token contract as defined in
790  *  https://eips.ethereum.org/EIPS/eip-1363
791  */
792 interface IERC1363 is IERC20, IERC165 {
793     /**
794      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
795      * @param recipient address The address which you want to transfer to
796      * @param amount uint256 The amount of tokens to be transferred
797      * @return true unless throwing
798      */
799     function transferAndCall(address recipient, uint256 amount) external returns (bool);
800 
801     /**
802      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
803      * @param recipient address The address which you want to transfer to
804      * @param amount uint256 The amount of tokens to be transferred
805      * @param data bytes Additional data with no specified format, sent in call to `recipient`
806      * @return true unless throwing
807      */
808     function transferAndCall(
809         address recipient,
810         uint256 amount,
811         bytes calldata data
812     ) external returns (bool);
813 
814     /**
815      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
816      * @param sender address The address which you want to send tokens from
817      * @param recipient address The address which you want to transfer to
818      * @param amount uint256 The amount of tokens to be transferred
819      * @return true unless throwing
820      */
821     function transferFromAndCall(
822         address sender,
823         address recipient,
824         uint256 amount
825     ) external returns (bool);
826 
827     /**
828      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
829      * @param sender address The address which you want to send tokens from
830      * @param recipient address The address which you want to transfer to
831      * @param amount uint256 The amount of tokens to be transferred
832      * @param data bytes Additional data with no specified format, sent in call to `recipient`
833      * @return true unless throwing
834      */
835     function transferFromAndCall(
836         address sender,
837         address recipient,
838         uint256 amount,
839         bytes calldata data
840     ) external returns (bool);
841 
842     /**
843      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
844      * and then call `onApprovalReceived` on spender.
845      * Beware that changing an allowance with this method brings the risk that someone may use both the old
846      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
847      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
848      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
849      * @param spender address The address which will spend the funds
850      * @param amount uint256 The amount of tokens to be spent
851      */
852     function approveAndCall(address spender, uint256 amount) external returns (bool);
853 
854     /**
855      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
856      * and then call `onApprovalReceived` on spender.
857      * Beware that changing an allowance with this method brings the risk that someone may use both the old
858      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
859      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
860      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
861      * @param spender address The address which will spend the funds
862      * @param amount uint256 The amount of tokens to be spent
863      * @param data bytes Additional data with no specified format, sent in call to `spender`
864      */
865     function approveAndCall(
866         address spender,
867         uint256 amount,
868         bytes calldata data
869     ) external returns (bool);
870 }
871 
872 
873 // File erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol@v4.3.0
874 
875 
876 
877 pragma solidity ^0.8.0;
878 
879 /**
880  * @title IERC1363Receiver Interface
881  * @author Vittorio Minacori (https://github.com/vittominacori)
882  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
883  *  from ERC1363 token contracts as defined in
884  *  https://eips.ethereum.org/EIPS/eip-1363
885  */
886 interface IERC1363Receiver {
887     /**
888      * @notice Handle the receipt of ERC1363 tokens
889      * @dev Any ERC1363 smart contract calls this function on the recipient
890      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
891      * transfer. Return of other than the magic value MUST result in the
892      * transaction being reverted.
893      * Note: the token contract address is always the message sender.
894      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
895      * @param sender address The address which are token transferred from
896      * @param amount uint256 The amount of tokens transferred
897      * @param data bytes Additional data with no specified format
898      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
899      */
900     function onTransferReceived(
901         address operator,
902         address sender,
903         uint256 amount,
904         bytes calldata data
905     ) external returns (bytes4);
906 }
907 
908 
909 // File erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol@v4.3.0
910 
911 
912 
913 pragma solidity ^0.8.0;
914 
915 /**
916  * @title IERC1363Spender Interface
917  * @author Vittorio Minacori (https://github.com/vittominacori)
918  * @dev Interface for any contract that wants to support approveAndCall
919  *  from ERC1363 token contracts as defined in
920  *  https://eips.ethereum.org/EIPS/eip-1363
921  */
922 interface IERC1363Spender {
923     /**
924      * @notice Handle the approval of ERC1363 tokens
925      * @dev Any ERC1363 smart contract calls this function on the recipient
926      * after an `approve`. This function MAY throw to revert and reject the
927      * approval. Return of other than the magic value MUST result in the
928      * transaction being reverted.
929      * Note: the token contract address is always the message sender.
930      * @param sender address The address which called `approveAndCall` function
931      * @param amount uint256 The amount of tokens to be spent
932      * @param data bytes Additional data with no specified format
933      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
934      */
935     function onApprovalReceived(
936         address sender,
937         uint256 amount,
938         bytes calldata data
939     ) external returns (bytes4);
940 }
941 
942 
943 // File erc-payable-token/contracts/token/ERC1363/ERC1363.sol@v4.3.0
944 
945 
946 
947 pragma solidity ^0.8.0;
948 
949 
950 
951 
952 
953 /**
954  * @title ERC1363
955  * @author Vittorio Minacori (https://github.com/vittominacori)
956  * @dev Implementation of an ERC1363 interface
957  */
958 abstract contract ERC1363 is ERC20, IERC1363, ERC165 {
959     using Address for address;
960 
961     /**
962      * @dev See {IERC165-supportsInterface}.
963      */
964     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
965         return interfaceId == type(IERC1363).interfaceId || super.supportsInterface(interfaceId);
966     }
967 
968     /**
969      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
970      * @param recipient The address to transfer to.
971      * @param amount The amount to be transferred.
972      * @return A boolean that indicates if the operation was successful.
973      */
974     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
975         return transferAndCall(recipient, amount, "");
976     }
977 
978     /**
979      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
980      * @param recipient The address to transfer to
981      * @param amount The amount to be transferred
982      * @param data Additional data with no specified format
983      * @return A boolean that indicates if the operation was successful.
984      */
985     function transferAndCall(
986         address recipient,
987         uint256 amount,
988         bytes memory data
989     ) public virtual override returns (bool) {
990         transfer(recipient, amount);
991         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
992         return true;
993     }
994 
995     /**
996      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
997      * @param sender The address which you want to send tokens from
998      * @param recipient The address which you want to transfer to
999      * @param amount The amount of tokens to be transferred
1000      * @return A boolean that indicates if the operation was successful.
1001      */
1002     function transferFromAndCall(
1003         address sender,
1004         address recipient,
1005         uint256 amount
1006     ) public virtual override returns (bool) {
1007         return transferFromAndCall(sender, recipient, amount, "");
1008     }
1009 
1010     /**
1011      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1012      * @param sender The address which you want to send tokens from
1013      * @param recipient The address which you want to transfer to
1014      * @param amount The amount of tokens to be transferred
1015      * @param data Additional data with no specified format
1016      * @return A boolean that indicates if the operation was successful.
1017      */
1018     function transferFromAndCall(
1019         address sender,
1020         address recipient,
1021         uint256 amount,
1022         bytes memory data
1023     ) public virtual override returns (bool) {
1024         transferFrom(sender, recipient, amount);
1025         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1026         return true;
1027     }
1028 
1029     /**
1030      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1031      * @param spender The address allowed to transfer to
1032      * @param amount The amount allowed to be transferred
1033      * @return A boolean that indicates if the operation was successful.
1034      */
1035     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
1036         return approveAndCall(spender, amount, "");
1037     }
1038 
1039     /**
1040      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1041      * @param spender The address allowed to transfer to.
1042      * @param amount The amount allowed to be transferred.
1043      * @param data Additional data with no specified format.
1044      * @return A boolean that indicates if the operation was successful.
1045      */
1046     function approveAndCall(
1047         address spender,
1048         uint256 amount,
1049         bytes memory data
1050     ) public virtual override returns (bool) {
1051         approve(spender, amount);
1052         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
1053         return true;
1054     }
1055 
1056     /**
1057      * @dev Internal function to invoke `onTransferReceived` on a target address
1058      *  The call is not executed if the target address is not a contract
1059      * @param sender address Representing the previous owner of the given token value
1060      * @param recipient address Target address that will receive the tokens
1061      * @param amount uint256 The amount mount of tokens to be transferred
1062      * @param data bytes Optional data to send along with the call
1063      * @return whether the call correctly returned the expected magic value
1064      */
1065     function _checkAndCallTransfer(
1066         address sender,
1067         address recipient,
1068         uint256 amount,
1069         bytes memory data
1070     ) internal virtual returns (bool) {
1071         if (!recipient.isContract()) {
1072             return false;
1073         }
1074         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(_msgSender(), sender, amount, data);
1075         return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
1076     }
1077 
1078     /**
1079      * @dev Internal function to invoke `onApprovalReceived` on a target address
1080      *  The call is not executed if the target address is not a contract
1081      * @param spender address The address which will spend the funds
1082      * @param amount uint256 The amount of tokens to be spent
1083      * @param data bytes Optional data to send along with the call
1084      * @return whether the call correctly returned the expected magic value
1085      */
1086     function _checkAndCallApprove(
1087         address spender,
1088         uint256 amount,
1089         bytes memory data
1090     ) internal virtual returns (bool) {
1091         if (!spender.isContract()) {
1092             return false;
1093         }
1094         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(_msgSender(), amount, data);
1095         return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
1096     }
1097 }
1098 
1099 
1100 // File contracts/WFAIRToken.sol
1101 
1102 
1103 
1104 pragma solidity ^0.8.7;
1105 
1106 contract WFAIRToken is ERC1363 {
1107     // create WFAIR token instance and immediately mint all tokens, no further minting will be possible
1108     constructor(uint256 totalSupply_) ERC20("WFAIR Token", "WFAIR") {
1109         _mint(msg.sender, totalSupply_);
1110     }
1111 }