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
548 // File: @openzeppelin/contracts/utils/Address.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @dev Collection of functions related to the address type
557  */
558 library Address {
559     /**
560      * @dev Returns true if `account` is a contract.
561      *
562      * [IMPORTANT]
563      * ====
564      * It is unsafe to assume that an address for which this function returns
565      * false is an externally-owned account (EOA) and not a contract.
566      *
567      * Among others, `isContract` will return false for the following
568      * types of addresses:
569      *
570      *  - an externally-owned account
571      *  - a contract in construction
572      *  - an address where a contract will be created
573      *  - an address where a contract lived, but was destroyed
574      * ====
575      */
576     function isContract(address account) internal view returns (bool) {
577         // This method relies on extcodesize, which returns 0 for contracts in
578         // construction, since the code is only stored at the end of the
579         // constructor execution.
580 
581         uint256 size;
582         assembly {
583             size := extcodesize(account)
584         }
585         return size > 0;
586     }
587 
588     /**
589      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
590      * `recipient`, forwarding all available gas and reverting on errors.
591      *
592      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
593      * of certain opcodes, possibly making contracts go over the 2300 gas limit
594      * imposed by `transfer`, making them unable to receive funds via
595      * `transfer`. {sendValue} removes this limitation.
596      *
597      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
598      *
599      * IMPORTANT: because control is transferred to `recipient`, care must be
600      * taken to not create reentrancy vulnerabilities. Consider using
601      * {ReentrancyGuard} or the
602      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
603      */
604     function sendValue(address payable recipient, uint256 amount) internal {
605         require(address(this).balance >= amount, "Address: insufficient balance");
606 
607         (bool success, ) = recipient.call{value: amount}("");
608         require(success, "Address: unable to send value, recipient may have reverted");
609     }
610 
611     /**
612      * @dev Performs a Solidity function call using a low level `call`. A
613      * plain `call` is an unsafe replacement for a function call: use this
614      * function instead.
615      *
616      * If `target` reverts with a revert reason, it is bubbled up by this
617      * function (like regular Solidity function calls).
618      *
619      * Returns the raw returned data. To convert to the expected return value,
620      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
621      *
622      * Requirements:
623      *
624      * - `target` must be a contract.
625      * - calling `target` with `data` must not revert.
626      *
627      * _Available since v3.1._
628      */
629     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
630         return functionCall(target, data, "Address: low-level call failed");
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
635      * `errorMessage` as a fallback revert reason when `target` reverts.
636      *
637      * _Available since v3.1._
638      */
639     function functionCall(
640         address target,
641         bytes memory data,
642         string memory errorMessage
643     ) internal returns (bytes memory) {
644         return functionCallWithValue(target, data, 0, errorMessage);
645     }
646 
647     /**
648      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
649      * but also transferring `value` wei to `target`.
650      *
651      * Requirements:
652      *
653      * - the calling contract must have an ETH balance of at least `value`.
654      * - the called Solidity function must be `payable`.
655      *
656      * _Available since v3.1._
657      */
658     function functionCallWithValue(
659         address target,
660         bytes memory data,
661         uint256 value
662     ) internal returns (bytes memory) {
663         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
668      * with `errorMessage` as a fallback revert reason when `target` reverts.
669      *
670      * _Available since v3.1._
671      */
672     function functionCallWithValue(
673         address target,
674         bytes memory data,
675         uint256 value,
676         string memory errorMessage
677     ) internal returns (bytes memory) {
678         require(address(this).balance >= value, "Address: insufficient balance for call");
679         require(isContract(target), "Address: call to non-contract");
680 
681         (bool success, bytes memory returndata) = target.call{value: value}(data);
682         return verifyCallResult(success, returndata, errorMessage);
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
687      * but performing a static call.
688      *
689      * _Available since v3.3._
690      */
691     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
692         return functionStaticCall(target, data, "Address: low-level static call failed");
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
697      * but performing a static call.
698      *
699      * _Available since v3.3._
700      */
701     function functionStaticCall(
702         address target,
703         bytes memory data,
704         string memory errorMessage
705     ) internal view returns (bytes memory) {
706         require(isContract(target), "Address: static call to non-contract");
707 
708         (bool success, bytes memory returndata) = target.staticcall(data);
709         return verifyCallResult(success, returndata, errorMessage);
710     }
711 
712     /**
713      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
714      * but performing a delegate call.
715      *
716      * _Available since v3.4._
717      */
718     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
719         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
724      * but performing a delegate call.
725      *
726      * _Available since v3.4._
727      */
728     function functionDelegateCall(
729         address target,
730         bytes memory data,
731         string memory errorMessage
732     ) internal returns (bytes memory) {
733         require(isContract(target), "Address: delegate call to non-contract");
734 
735         (bool success, bytes memory returndata) = target.delegatecall(data);
736         return verifyCallResult(success, returndata, errorMessage);
737     }
738 
739     /**
740      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
741      * revert reason using the provided one.
742      *
743      * _Available since v4.3._
744      */
745     function verifyCallResult(
746         bool success,
747         bytes memory returndata,
748         string memory errorMessage
749     ) internal pure returns (bytes memory) {
750         if (success) {
751             return returndata;
752         } else {
753             // Look for revert reason and bubble it up if present
754             if (returndata.length > 0) {
755                 // The easiest way to bubble the revert reason is using memory via assembly
756 
757                 assembly {
758                     let returndata_size := mload(returndata)
759                     revert(add(32, returndata), returndata_size)
760                 }
761             } else {
762                 revert(errorMessage);
763             }
764         }
765     }
766 }
767 
768 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
769 
770 
771 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
772 
773 pragma solidity ^0.8.0;
774 
775 /**
776  * @dev Interface of the ERC165 standard, as defined in the
777  * https://eips.ethereum.org/EIPS/eip-165[EIP].
778  *
779  * Implementers can declare support of contract interfaces, which can then be
780  * queried by others ({ERC165Checker}).
781  *
782  * For an implementation, see {ERC165}.
783  */
784 interface IERC165 {
785     /**
786      * @dev Returns true if this contract implements the interface defined by
787      * `interfaceId`. See the corresponding
788      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
789      * to learn more about how these ids are created.
790      *
791      * This function call must use less than 30 000 gas.
792      */
793     function supportsInterface(bytes4 interfaceId) external view returns (bool);
794 }
795 
796 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
797 
798 
799 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
800 
801 pragma solidity ^0.8.0;
802 
803 
804 /**
805  * @dev Implementation of the {IERC165} interface.
806  *
807  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
808  * for the additional interface id that will be supported. For example:
809  *
810  * ```solidity
811  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
812  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
813  * }
814  * ```
815  *
816  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
817  */
818 abstract contract ERC165 is IERC165 {
819     /**
820      * @dev See {IERC165-supportsInterface}.
821      */
822     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
823         return interfaceId == type(IERC165).interfaceId;
824     }
825 }
826 
827 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
828 
829 
830 
831 pragma solidity ^0.8.0;
832 
833 
834 
835 /**
836  * @title IERC1363 Interface
837  * @dev Interface for a Payable Token contract as defined in
838  *  https://eips.ethereum.org/EIPS/eip-1363
839  */
840 interface IERC1363 is IERC20, IERC165 {
841     /**
842      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
843      * @param recipient address The address which you want to transfer to
844      * @param amount uint256 The amount of tokens to be transferred
845      * @return true unless throwing
846      */
847     function transferAndCall(address recipient, uint256 amount) external returns (bool);
848 
849     /**
850      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
851      * @param recipient address The address which you want to transfer to
852      * @param amount uint256 The amount of tokens to be transferred
853      * @param data bytes Additional data with no specified format, sent in call to `recipient`
854      * @return true unless throwing
855      */
856     function transferAndCall(
857         address recipient,
858         uint256 amount,
859         bytes calldata data
860     ) external returns (bool);
861 
862     /**
863      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
864      * @param sender address The address which you want to send tokens from
865      * @param recipient address The address which you want to transfer to
866      * @param amount uint256 The amount of tokens to be transferred
867      * @return true unless throwing
868      */
869     function transferFromAndCall(
870         address sender,
871         address recipient,
872         uint256 amount
873     ) external returns (bool);
874 
875     /**
876      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
877      * @param sender address The address which you want to send tokens from
878      * @param recipient address The address which you want to transfer to
879      * @param amount uint256 The amount of tokens to be transferred
880      * @param data bytes Additional data with no specified format, sent in call to `recipient`
881      * @return true unless throwing
882      */
883     function transferFromAndCall(
884         address sender,
885         address recipient,
886         uint256 amount,
887         bytes calldata data
888     ) external returns (bool);
889 
890     /**
891      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
892      * and then call `onApprovalReceived` on spender.
893      * Beware that changing an allowance with this method brings the risk that someone may use both the old
894      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
895      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
896      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
897      * @param spender address The address which will spend the funds
898      * @param amount uint256 The amount of tokens to be spent
899      */
900     function approveAndCall(address spender, uint256 amount) external returns (bool);
901 
902     /**
903      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
904      * and then call `onApprovalReceived` on spender.
905      * Beware that changing an allowance with this method brings the risk that someone may use both the old
906      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
907      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
908      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
909      * @param spender address The address which will spend the funds
910      * @param amount uint256 The amount of tokens to be spent
911      * @param data bytes Additional data with no specified format, sent in call to `spender`
912      */
913     function approveAndCall(
914         address spender,
915         uint256 amount,
916         bytes calldata data
917     ) external returns (bool);
918 }
919 
920 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
921 
922 
923 
924 pragma solidity ^0.8.0;
925 
926 /**
927  * @title IERC1363Receiver Interface
928  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
929  *  from ERC1363 token contracts as defined in
930  *  https://eips.ethereum.org/EIPS/eip-1363
931  */
932 interface IERC1363Receiver {
933     /**
934      * @notice Handle the receipt of ERC1363 tokens
935      * @dev Any ERC1363 smart contract calls this function on the recipient
936      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
937      * transfer. Return of other than the magic value MUST result in the
938      * transaction being reverted.
939      * Note: the token contract address is always the message sender.
940      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
941      * @param sender address The address which are token transferred from
942      * @param amount uint256 The amount of tokens transferred
943      * @param data bytes Additional data with no specified format
944      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
945      */
946     function onTransferReceived(
947         address operator,
948         address sender,
949         uint256 amount,
950         bytes calldata data
951     ) external returns (bytes4);
952 }
953 
954 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
955 
956 
957 
958 pragma solidity ^0.8.0;
959 
960 /**
961  * @title IERC1363Spender Interface
962  * @dev Interface for any contract that wants to support approveAndCall
963  *  from ERC1363 token contracts as defined in
964  *  https://eips.ethereum.org/EIPS/eip-1363
965  */
966 interface IERC1363Spender {
967     /**
968      * @notice Handle the approval of ERC1363 tokens
969      * @dev Any ERC1363 smart contract calls this function on the recipient
970      * after an `approve`. This function MAY throw to revert and reject the
971      * approval. Return of other than the magic value MUST result in the
972      * transaction being reverted.
973      * Note: the token contract address is always the message sender.
974      * @param sender address The address which called `approveAndCall` function
975      * @param amount uint256 The amount of tokens to be spent
976      * @param data bytes Additional data with no specified format
977      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
978      */
979     function onApprovalReceived(
980         address sender,
981         uint256 amount,
982         bytes calldata data
983     ) external returns (bytes4);
984 }
985 
986 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
987 
988 
989 
990 pragma solidity ^0.8.0;
991 
992 
993 
994 
995 
996 
997 
998 /**
999  * @title ERC1363
1000  * @dev Implementation of an ERC1363 interface
1001  */
1002 abstract contract ERC1363 is ERC20, IERC1363, ERC165 {
1003     using Address for address;
1004 
1005     /**
1006      * @dev See {IERC165-supportsInterface}.
1007      */
1008     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1009         return interfaceId == type(IERC1363).interfaceId || super.supportsInterface(interfaceId);
1010     }
1011 
1012     /**
1013      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1014      * @param recipient The address to transfer to.
1015      * @param amount The amount to be transferred.
1016      * @return A boolean that indicates if the operation was successful.
1017      */
1018     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
1019         return transferAndCall(recipient, amount, "");
1020     }
1021 
1022     /**
1023      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1024      * @param recipient The address to transfer to
1025      * @param amount The amount to be transferred
1026      * @param data Additional data with no specified format
1027      * @return A boolean that indicates if the operation was successful.
1028      */
1029     function transferAndCall(
1030         address recipient,
1031         uint256 amount,
1032         bytes memory data
1033     ) public virtual override returns (bool) {
1034         transfer(recipient, amount);
1035         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1036         return true;
1037     }
1038 
1039     /**
1040      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1041      * @param sender The address which you want to send tokens from
1042      * @param recipient The address which you want to transfer to
1043      * @param amount The amount of tokens to be transferred
1044      * @return A boolean that indicates if the operation was successful.
1045      */
1046     function transferFromAndCall(
1047         address sender,
1048         address recipient,
1049         uint256 amount
1050     ) public virtual override returns (bool) {
1051         return transferFromAndCall(sender, recipient, amount, "");
1052     }
1053 
1054     /**
1055      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1056      * @param sender The address which you want to send tokens from
1057      * @param recipient The address which you want to transfer to
1058      * @param amount The amount of tokens to be transferred
1059      * @param data Additional data with no specified format
1060      * @return A boolean that indicates if the operation was successful.
1061      */
1062     function transferFromAndCall(
1063         address sender,
1064         address recipient,
1065         uint256 amount,
1066         bytes memory data
1067     ) public virtual override returns (bool) {
1068         transferFrom(sender, recipient, amount);
1069         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1070         return true;
1071     }
1072 
1073     /**
1074      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1075      * @param spender The address allowed to transfer to
1076      * @param amount The amount allowed to be transferred
1077      * @return A boolean that indicates if the operation was successful.
1078      */
1079     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
1080         return approveAndCall(spender, amount, "");
1081     }
1082 
1083     /**
1084      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1085      * @param spender The address allowed to transfer to.
1086      * @param amount The amount allowed to be transferred.
1087      * @param data Additional data with no specified format.
1088      * @return A boolean that indicates if the operation was successful.
1089      */
1090     function approveAndCall(
1091         address spender,
1092         uint256 amount,
1093         bytes memory data
1094     ) public virtual override returns (bool) {
1095         approve(spender, amount);
1096         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
1097         return true;
1098     }
1099 
1100     /**
1101      * @dev Internal function to invoke `onTransferReceived` on a target address
1102      *  The call is not executed if the target address is not a contract
1103      * @param sender address Representing the previous owner of the given token value
1104      * @param recipient address Target address that will receive the tokens
1105      * @param amount uint256 The amount mount of tokens to be transferred
1106      * @param data bytes Optional data to send along with the call
1107      * @return whether the call correctly returned the expected magic value
1108      */
1109     function _checkAndCallTransfer(
1110         address sender,
1111         address recipient,
1112         uint256 amount,
1113         bytes memory data
1114     ) internal virtual returns (bool) {
1115         if (!recipient.isContract()) {
1116             return false;
1117         }
1118         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(_msgSender(), sender, amount, data);
1119         return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
1120     }
1121 
1122     /**
1123      * @dev Internal function to invoke `onApprovalReceived` on a target address
1124      *  The call is not executed if the target address is not a contract
1125      * @param spender address The address which will spend the funds
1126      * @param amount uint256 The amount of tokens to be spent
1127      * @param data bytes Optional data to send along with the call
1128      * @return whether the call correctly returned the expected magic value
1129      */
1130     function _checkAndCallApprove(
1131         address spender,
1132         uint256 amount,
1133         bytes memory data
1134     ) internal virtual returns (bool) {
1135         if (!spender.isContract()) {
1136             return false;
1137         }
1138         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(_msgSender(), amount, data);
1139         return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
1140     }
1141 }
1142 
1143 // File: @openzeppelin/contracts/access/Ownable.sol
1144 
1145 
1146 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1147 
1148 pragma solidity ^0.8.0;
1149 
1150 
1151 /**
1152  * @dev Contract module which provides a basic access control mechanism, where
1153  * there is an account (an owner) that can be granted exclusive access to
1154  * specific functions.
1155  *
1156  * By default, the owner account will be the one that deploys the contract. This
1157  * can later be changed with {transferOwnership}.
1158  *
1159  * This module is used through inheritance. It will make available the modifier
1160  * `onlyOwner`, which can be applied to your functions to restrict their use to
1161  * the owner.
1162  */
1163 abstract contract Ownable is Context {
1164     address private _owner;
1165 
1166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1167 
1168     /**
1169      * @dev Initializes the contract setting the deployer as the initial owner.
1170      */
1171     constructor() {
1172         _transferOwnership(_msgSender());
1173     }
1174 
1175     /**
1176      * @dev Returns the address of the current owner.
1177      */
1178     function owner() public view virtual returns (address) {
1179         return _owner;
1180     }
1181 
1182     /**
1183      * @dev Throws if called by any account other than the owner.
1184      */
1185     modifier onlyOwner() {
1186         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1187         _;
1188     }
1189 
1190     /**
1191      * @dev Leaves the contract without owner. It will not be possible to call
1192      * `onlyOwner` functions anymore. Can only be called by the current owner.
1193      *
1194      * NOTE: Renouncing ownership will leave the contract without an owner,
1195      * thereby removing any functionality that is only available to the owner.
1196      */
1197     function renounceOwnership() public virtual onlyOwner {
1198         _transferOwnership(address(0));
1199     }
1200 
1201     /**
1202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1203      * Can only be called by the current owner.
1204      */
1205     function transferOwnership(address newOwner) public virtual onlyOwner {
1206         require(newOwner != address(0), "Ownable: new owner is the zero address");
1207         _transferOwnership(newOwner);
1208     }
1209 
1210     /**
1211      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1212      * Internal function without access restriction.
1213      */
1214     function _transferOwnership(address newOwner) internal virtual {
1215         address oldOwner = _owner;
1216         _owner = newOwner;
1217         emit OwnershipTransferred(oldOwner, newOwner);
1218     }
1219 }
1220 
1221 // File: eth-token-recover/contracts/TokenRecover.sol
1222 
1223 
1224 
1225 pragma solidity ^0.8.0;
1226 
1227 
1228 
1229 /**
1230  * @title TokenRecover
1231  * @dev Allows owner to recover any ERC20 sent into the contract
1232  */
1233 contract TokenRecover is Ownable {
1234     /**
1235      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1236      * @param tokenAddress The token contract address
1237      * @param tokenAmount Number of tokens to be sent
1238      */
1239     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
1240         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1241     }
1242 }
1243 
1244 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
1245 
1246 
1247 
1248 pragma solidity ^0.8.0;
1249 
1250 
1251 /**
1252  * @title ERC20Decimals
1253  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
1254  */
1255 abstract contract ERC20Decimals is ERC20 {
1256     uint8 private immutable _decimals;
1257 
1258     /**
1259      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
1260      * set once during construction.
1261      */
1262     constructor(uint8 decimals_) {
1263         _decimals = decimals_;
1264     }
1265 
1266     function decimals() public view virtual override returns (uint8) {
1267         return _decimals;
1268     }
1269 }
1270 
1271 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
1272 
1273 
1274 
1275 pragma solidity ^0.8.0;
1276 
1277 
1278 /**
1279  * @title ERC20Mintable
1280  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
1281  */
1282 abstract contract ERC20Mintable is ERC20 {
1283     // indicates if minting is finished
1284     bool private _mintingFinished = false;
1285 
1286     /**
1287      * @dev Emitted during finish minting
1288      */
1289     event MintFinished();
1290 
1291     /**
1292      * @dev Tokens can be minted only before minting finished.
1293      */
1294     modifier canMint() {
1295         require(!_mintingFinished, "ERC20Mintable: minting is finished");
1296         _;
1297     }
1298 
1299     /**
1300      * @return if minting is finished or not.
1301      */
1302     function mintingFinished() external view returns (bool) {
1303         return _mintingFinished;
1304     }
1305 
1306     /**
1307      * @dev Function to mint tokens.
1308      *
1309      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
1310      *
1311      * @param account The address that will receive the minted tokens
1312      * @param amount The amount of tokens to mint
1313      */
1314     function mint(address account, uint256 amount) external canMint {
1315         _mint(account, amount);
1316     }
1317 
1318     /**
1319      * @dev Function to stop minting new tokens.
1320      *
1321      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
1322      */
1323     function finishMinting() external canMint {
1324         _finishMinting();
1325     }
1326 
1327     /**
1328      * @dev Function to stop minting new tokens.
1329      */
1330     function _finishMinting() internal virtual {
1331         _mintingFinished = true;
1332 
1333         emit MintFinished();
1334     }
1335 }
1336 
1337 // File: contracts/service/ServicePayer.sol
1338 
1339 
1340 
1341 pragma solidity ^0.8.0;
1342 
1343 interface IPayable {
1344     function pay(string memory serviceName) external payable;
1345 }
1346 
1347 /**
1348  * @title ServicePayer
1349  * @dev Implementation of the ServicePayer
1350  */
1351 abstract contract ServicePayer {
1352     constructor(address payable receiver, string memory serviceName) payable {
1353         IPayable(receiver).pay{value: msg.value}(serviceName);
1354     }
1355 }
1356 
1357 // File: contracts/token/ERC20/AmazingERC20.sol
1358 
1359 
1360 
1361 pragma solidity ^0.8.0;
1362 
1363 
1364 
1365 
1366 
1367 
1368 
1369 /**
1370  * @title AmazingERC20
1371  * @dev Implementation of the AmazingERC20
1372  */
1373 contract AmazingERC20 is ERC20Decimals, ERC20Mintable, ERC20Burnable, ERC1363, TokenRecover, ServicePayer {
1374     constructor(
1375         string memory name_,
1376         string memory symbol_,
1377         uint8 decimals_,
1378         uint256 initialBalance_,
1379         address payable feeReceiver_
1380     ) payable ERC20(name_, symbol_) ERC20Decimals(decimals_) ServicePayer(feeReceiver_, "AmazingERC20") {
1381         _mint(_msgSender(), initialBalance_);
1382     }
1383 
1384     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
1385         return super.decimals();
1386     }
1387 
1388     /**
1389      * @dev Function to mint tokens.
1390      *
1391      * NOTE: restricting access to owner only. See {ERC20Mintable-mint}.
1392      *
1393      * @param account The address that will receive the minted tokens
1394      * @param amount The amount of tokens to mint
1395      */
1396     function _mint(address account, uint256 amount) internal override onlyOwner {
1397         super._mint(account, amount);
1398     }
1399 
1400     /**
1401      * @dev Function to stop minting new tokens.
1402      *
1403      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
1404      */
1405     function _finishMinting() internal override onlyOwner {
1406         super._finishMinting();
1407     }
1408 }
