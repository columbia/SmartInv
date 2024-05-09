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
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
84 
85 
86 
87 pragma solidity ^0.8.0;
88 
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  *
93  * _Available since v4.1._
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 // File: @openzeppelin/contracts/utils/Context.sol
113 
114 
115 
116 pragma solidity ^0.8.0;
117 
118 /*
119  * @dev Provides information about the current execution context, including the
120  * sender of the transaction and its data. While these are generally available
121  * via msg.sender and msg.data, they should not be accessed in such a direct
122  * manner, since when dealing with meta-transactions the account sending and
123  * paying for execution may not be the actual sender (as far as an application
124  * is concerned).
125  *
126  * This contract is only required for intermediate, library-like contracts.
127  */
128 abstract contract Context {
129     function _msgSender() internal view virtual returns (address) {
130         return msg.sender;
131     }
132 
133     function _msgData() internal view virtual returns (bytes calldata) {
134         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
135         return msg.data;
136     }
137 }
138 
139 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
140 
141 
142 
143 pragma solidity ^0.8.0;
144 
145 
146 
147 
148 /**
149  * @dev Implementation of the {IERC20} interface.
150  *
151  * This implementation is agnostic to the way tokens are created. This means
152  * that a supply mechanism has to be added in a derived contract using {_mint}.
153  * For a generic mechanism see {ERC20PresetMinterPauser}.
154  *
155  * TIP: For a detailed writeup see our guide
156  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
157  * to implement supply mechanisms].
158  *
159  * We have followed general OpenZeppelin guidelines: functions revert instead
160  * of returning `false` on failure. This behavior is nonetheless conventional
161  * and does not conflict with the expectations of ERC20 applications.
162  *
163  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
164  * This allows applications to reconstruct the allowance for all accounts just
165  * by listening to said events. Other implementations of the EIP may not emit
166  * these events, as it isn't required by the specification.
167  *
168  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
169  * functions have been added to mitigate the well-known issues around setting
170  * allowances. See {IERC20-approve}.
171  */
172 contract ERC20 is Context, IERC20, IERC20Metadata {
173     mapping (address => uint256) private _balances;
174 
175     mapping (address => mapping (address => uint256)) private _allowances;
176 
177     uint256 private _totalSupply;
178 
179     string private _name;
180     string private _symbol;
181 
182     /**
183      * @dev Sets the values for {name} and {symbol}.
184      *
185      * The defaut value of {decimals} is 18. To select a different value for
186      * {decimals} you should overload it.
187      *
188      * All two of these values are immutable: they can only be set once during
189      * construction.
190      */
191     constructor (string memory name_, string memory symbol_) {
192         _name = name_;
193         _symbol = symbol_;
194     }
195 
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() public view virtual override returns (string memory) {
200         return _name;
201     }
202 
203     /**
204      * @dev Returns the symbol of the token, usually a shorter version of the
205      * name.
206      */
207     function symbol() public view virtual override returns (string memory) {
208         return _symbol;
209     }
210 
211     /**
212      * @dev Returns the number of decimals used to get its user representation.
213      * For example, if `decimals` equals `2`, a balance of `505` tokens should
214      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
215      *
216      * Tokens usually opt for a value of 18, imitating the relationship between
217      * Ether and Wei. This is the value {ERC20} uses, unless this function is
218      * overridden;
219      *
220      * NOTE: This information is only used for _display_ purposes: it in
221      * no way affects any of the arithmetic of the contract, including
222      * {IERC20-balanceOf} and {IERC20-transfer}.
223      */
224     function decimals() public view virtual override returns (uint8) {
225         return 18;
226     }
227 
228     /**
229      * @dev See {IERC20-totalSupply}.
230      */
231     function totalSupply() public view virtual override returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See {IERC20-balanceOf}.
237      */
238     function balanceOf(address account) public view virtual override returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See {IERC20-transfer}.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See {IERC20-allowance}.
257      */
258     function allowance(address owner, address spender) public view virtual override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See {IERC20-approve}.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 amount) public virtual override returns (bool) {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273 
274     /**
275      * @dev See {IERC20-transferFrom}.
276      *
277      * Emits an {Approval} event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of {ERC20}.
279      *
280      * Requirements:
281      *
282      * - `sender` and `recipient` cannot be the zero address.
283      * - `sender` must have a balance of at least `amount`.
284      * - the caller must have allowance for ``sender``'s tokens of at least
285      * `amount`.
286      */
287     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
288         _transfer(sender, recipient, amount);
289 
290         uint256 currentAllowance = _allowances[sender][_msgSender()];
291         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
292         _approve(sender, _msgSender(), currentAllowance - amount);
293 
294         return true;
295     }
296 
297     /**
298      * @dev Atomically increases the allowance granted to `spender` by the caller.
299      *
300      * This is an alternative to {approve} that can be used as a mitigation for
301      * problems described in {IERC20-approve}.
302      *
303      * Emits an {Approval} event indicating the updated allowance.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      */
309     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
310         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
311         return true;
312     }
313 
314     /**
315      * @dev Atomically decreases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to {approve} that can be used as a mitigation for
318      * problems described in {IERC20-approve}.
319      *
320      * Emits an {Approval} event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      * - `spender` must have allowance for the caller of at least
326      * `subtractedValue`.
327      */
328     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
329         uint256 currentAllowance = _allowances[_msgSender()][spender];
330         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
331         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
332 
333         return true;
334     }
335 
336     /**
337      * @dev Moves tokens `amount` from `sender` to `recipient`.
338      *
339      * This is internal function is equivalent to {transfer}, and can be used to
340      * e.g. implement automatic token fees, slashing mechanisms, etc.
341      *
342      * Emits a {Transfer} event.
343      *
344      * Requirements:
345      *
346      * - `sender` cannot be the zero address.
347      * - `recipient` cannot be the zero address.
348      * - `sender` must have a balance of at least `amount`.
349      */
350     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
351         require(sender != address(0), "ERC20: transfer from the zero address");
352         require(recipient != address(0), "ERC20: transfer to the zero address");
353 
354         _beforeTokenTransfer(sender, recipient, amount);
355 
356         uint256 senderBalance = _balances[sender];
357         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
358         _balances[sender] = senderBalance - amount;
359         _balances[recipient] += amount;
360 
361         emit Transfer(sender, recipient, amount);
362     }
363 
364     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
365      * the total supply.
366      *
367      * Emits a {Transfer} event with `from` set to the zero address.
368      *
369      * Requirements:
370      *
371      * - `to` cannot be the zero address.
372      */
373     function _mint(address account, uint256 amount) internal virtual {
374         require(account != address(0), "ERC20: mint to the zero address");
375 
376         _beforeTokenTransfer(address(0), account, amount);
377 
378         _totalSupply += amount;
379         _balances[account] += amount;
380         emit Transfer(address(0), account, amount);
381     }
382 
383     /**
384      * @dev Destroys `amount` tokens from `account`, reducing the
385      * total supply.
386      *
387      * Emits a {Transfer} event with `to` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      * - `account` must have at least `amount` tokens.
393      */
394     function _burn(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: burn from the zero address");
396 
397         _beforeTokenTransfer(account, address(0), amount);
398 
399         uint256 accountBalance = _balances[account];
400         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
401         _balances[account] = accountBalance - amount;
402         _totalSupply -= amount;
403 
404         emit Transfer(account, address(0), amount);
405     }
406 
407     /**
408      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
409      *
410      * This internal function is equivalent to `approve`, and can be used to
411      * e.g. set automatic allowances for certain subsystems, etc.
412      *
413      * Emits an {Approval} event.
414      *
415      * Requirements:
416      *
417      * - `owner` cannot be the zero address.
418      * - `spender` cannot be the zero address.
419      */
420     function _approve(address owner, address spender, uint256 amount) internal virtual {
421         require(owner != address(0), "ERC20: approve from the zero address");
422         require(spender != address(0), "ERC20: approve to the zero address");
423 
424         _allowances[owner][spender] = amount;
425         emit Approval(owner, spender, amount);
426     }
427 
428     /**
429      * @dev Hook that is called before any transfer of tokens. This includes
430      * minting and burning.
431      *
432      * Calling conditions:
433      *
434      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
435      * will be to transferred to `to`.
436      * - when `from` is zero, `amount` tokens will be minted for `to`.
437      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
438      * - `from` and `to` are never both zero.
439      *
440      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
441      */
442     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
443 }
444 
445 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
446 
447 
448 
449 pragma solidity ^0.8.0;
450 
451 
452 
453 /**
454  * @dev Extension of {ERC20} that allows token holders to destroy both their own
455  * tokens and those that they have an allowance for, in a way that can be
456  * recognized off-chain (via event analysis).
457  */
458 abstract contract ERC20Burnable is Context, ERC20 {
459     /**
460      * @dev Destroys `amount` tokens from the caller.
461      *
462      * See {ERC20-_burn}.
463      */
464     function burn(uint256 amount) public virtual {
465         _burn(_msgSender(), amount);
466     }
467 
468     /**
469      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
470      * allowance.
471      *
472      * See {ERC20-_burn} and {ERC20-allowance}.
473      *
474      * Requirements:
475      *
476      * - the caller must have allowance for ``accounts``'s tokens of at least
477      * `amount`.
478      */
479     function burnFrom(address account, uint256 amount) public virtual {
480         uint256 currentAllowance = allowance(account, _msgSender());
481         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
482         _approve(account, _msgSender(), currentAllowance - amount);
483         _burn(account, amount);
484     }
485 }
486 
487 // File: @openzeppelin/contracts/utils/Address.sol
488 
489 
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Collection of functions related to the address type
495  */
496 library Address {
497     /**
498      * @dev Returns true if `account` is a contract.
499      *
500      * [IMPORTANT]
501      * ====
502      * It is unsafe to assume that an address for which this function returns
503      * false is an externally-owned account (EOA) and not a contract.
504      *
505      * Among others, `isContract` will return false for the following
506      * types of addresses:
507      *
508      *  - an externally-owned account
509      *  - a contract in construction
510      *  - an address where a contract will be created
511      *  - an address where a contract lived, but was destroyed
512      * ====
513      */
514     function isContract(address account) internal view returns (bool) {
515         // This method relies on extcodesize, which returns 0 for contracts in
516         // construction, since the code is only stored at the end of the
517         // constructor execution.
518 
519         uint256 size;
520         // solhint-disable-next-line no-inline-assembly
521         assembly { size := extcodesize(account) }
522         return size > 0;
523     }
524 
525     /**
526      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
527      * `recipient`, forwarding all available gas and reverting on errors.
528      *
529      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
530      * of certain opcodes, possibly making contracts go over the 2300 gas limit
531      * imposed by `transfer`, making them unable to receive funds via
532      * `transfer`. {sendValue} removes this limitation.
533      *
534      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
535      *
536      * IMPORTANT: because control is transferred to `recipient`, care must be
537      * taken to not create reentrancy vulnerabilities. Consider using
538      * {ReentrancyGuard} or the
539      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
540      */
541     function sendValue(address payable recipient, uint256 amount) internal {
542         require(address(this).balance >= amount, "Address: insufficient balance");
543 
544         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
545         (bool success, ) = recipient.call{ value: amount }("");
546         require(success, "Address: unable to send value, recipient may have reverted");
547     }
548 
549     /**
550      * @dev Performs a Solidity function call using a low level `call`. A
551      * plain`call` is an unsafe replacement for a function call: use this
552      * function instead.
553      *
554      * If `target` reverts with a revert reason, it is bubbled up by this
555      * function (like regular Solidity function calls).
556      *
557      * Returns the raw returned data. To convert to the expected return value,
558      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
559      *
560      * Requirements:
561      *
562      * - `target` must be a contract.
563      * - calling `target` with `data` must not revert.
564      *
565      * _Available since v3.1._
566      */
567     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
568       return functionCall(target, data, "Address: low-level call failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
573      * `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
578         return functionCallWithValue(target, data, 0, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but also transferring `value` wei to `target`.
584      *
585      * Requirements:
586      *
587      * - the calling contract must have an ETH balance of at least `value`.
588      * - the called Solidity function must be `payable`.
589      *
590      * _Available since v3.1._
591      */
592     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
593         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
598      * with `errorMessage` as a fallback revert reason when `target` reverts.
599      *
600      * _Available since v3.1._
601      */
602     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
603         require(address(this).balance >= value, "Address: insufficient balance for call");
604         require(isContract(target), "Address: call to non-contract");
605 
606         // solhint-disable-next-line avoid-low-level-calls
607         (bool success, bytes memory returndata) = target.call{ value: value }(data);
608         return _verifyCallResult(success, returndata, errorMessage);
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
613      * but performing a static call.
614      *
615      * _Available since v3.3._
616      */
617     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
618         return functionStaticCall(target, data, "Address: low-level static call failed");
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
623      * but performing a static call.
624      *
625      * _Available since v3.3._
626      */
627     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
628         require(isContract(target), "Address: static call to non-contract");
629 
630         // solhint-disable-next-line avoid-low-level-calls
631         (bool success, bytes memory returndata) = target.staticcall(data);
632         return _verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
637      * but performing a delegate call.
638      *
639      * _Available since v3.4._
640      */
641     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
642         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
647      * but performing a delegate call.
648      *
649      * _Available since v3.4._
650      */
651     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
652         require(isContract(target), "Address: delegate call to non-contract");
653 
654         // solhint-disable-next-line avoid-low-level-calls
655         (bool success, bytes memory returndata) = target.delegatecall(data);
656         return _verifyCallResult(success, returndata, errorMessage);
657     }
658 
659     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
660         if (success) {
661             return returndata;
662         } else {
663             // Look for revert reason and bubble it up if present
664             if (returndata.length > 0) {
665                 // The easiest way to bubble the revert reason is using memory via assembly
666 
667                 // solhint-disable-next-line no-inline-assembly
668                 assembly {
669                     let returndata_size := mload(returndata)
670                     revert(add(32, returndata), returndata_size)
671                 }
672             } else {
673                 revert(errorMessage);
674             }
675         }
676     }
677 }
678 
679 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
680 
681 
682 
683 pragma solidity ^0.8.0;
684 
685 /**
686  * @dev Interface of the ERC165 standard, as defined in the
687  * https://eips.ethereum.org/EIPS/eip-165[EIP].
688  *
689  * Implementers can declare support of contract interfaces, which can then be
690  * queried by others ({ERC165Checker}).
691  *
692  * For an implementation, see {ERC165}.
693  */
694 interface IERC165 {
695     /**
696      * @dev Returns true if this contract implements the interface defined by
697      * `interfaceId`. See the corresponding
698      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
699      * to learn more about how these ids are created.
700      *
701      * This function call must use less than 30 000 gas.
702      */
703     function supportsInterface(bytes4 interfaceId) external view returns (bool);
704 }
705 
706 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
707 
708 
709 
710 pragma solidity ^0.8.0;
711 
712 
713 /**
714  * @dev Implementation of the {IERC165} interface.
715  *
716  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
717  * for the additional interface id that will be supported. For example:
718  *
719  * ```solidity
720  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
721  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
722  * }
723  * ```
724  *
725  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
726  */
727 abstract contract ERC165 is IERC165 {
728     /**
729      * @dev See {IERC165-supportsInterface}.
730      */
731     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
732         return interfaceId == type(IERC165).interfaceId;
733     }
734 }
735 
736 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
737 
738 
739 
740 pragma solidity ^0.8.0;
741 
742 
743 
744 /**
745  * @title IERC1363 Interface
746  * @dev Interface for a Payable Token contract as defined in
747  *  https://eips.ethereum.org/EIPS/eip-1363
748  */
749 interface IERC1363 is IERC20, IERC165 {
750 
751     /**
752      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
753      * @param recipient address The address which you want to transfer to
754      * @param amount uint256 The amount of tokens to be transferred
755      * @return true unless throwing
756      */
757     function transferAndCall(address recipient, uint256 amount) external returns (bool);
758 
759     /**
760      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
761      * @param recipient address The address which you want to transfer to
762      * @param amount uint256 The amount of tokens to be transferred
763      * @param data bytes Additional data with no specified format, sent in call to `recipient`
764      * @return true unless throwing
765      */
766     function transferAndCall(address recipient, uint256 amount, bytes calldata data) external returns (bool);
767 
768     /**
769      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
770      * @param sender address The address which you want to send tokens from
771      * @param recipient address The address which you want to transfer to
772      * @param amount uint256 The amount of tokens to be transferred
773      * @return true unless throwing
774      */
775     function transferFromAndCall(address sender, address recipient, uint256 amount) external returns (bool);
776 
777     /**
778      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
779      * @param sender address The address which you want to send tokens from
780      * @param recipient address The address which you want to transfer to
781      * @param amount uint256 The amount of tokens to be transferred
782      * @param data bytes Additional data with no specified format, sent in call to `recipient`
783      * @return true unless throwing
784      */
785     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes calldata data) external returns (bool);
786 
787     /**
788      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
789      * and then call `onApprovalReceived` on spender.
790      * Beware that changing an allowance with this method brings the risk that someone may use both the old
791      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
792      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
793      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
794      * @param spender address The address which will spend the funds
795      * @param amount uint256 The amount of tokens to be spent
796      */
797     function approveAndCall(address spender, uint256 amount) external returns (bool);
798 
799     /**
800      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
801      * and then call `onApprovalReceived` on spender.
802      * Beware that changing an allowance with this method brings the risk that someone may use both the old
803      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
804      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
805      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
806      * @param spender address The address which will spend the funds
807      * @param amount uint256 The amount of tokens to be spent
808      * @param data bytes Additional data with no specified format, sent in call to `spender`
809      */
810     function approveAndCall(address spender, uint256 amount, bytes calldata data) external returns (bool);
811 }
812 
813 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
814 
815 
816 
817 pragma solidity ^0.8.0;
818 
819 /**
820  * @title IERC1363Receiver Interface
821  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
822  *  from ERC1363 token contracts as defined in
823  *  https://eips.ethereum.org/EIPS/eip-1363
824  */
825 interface IERC1363Receiver {
826 
827     /**
828      * @notice Handle the receipt of ERC1363 tokens
829      * @dev Any ERC1363 smart contract calls this function on the recipient
830      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
831      * transfer. Return of other than the magic value MUST result in the
832      * transaction being reverted.
833      * Note: the token contract address is always the message sender.
834      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
835      * @param sender address The address which are token transferred from
836      * @param amount uint256 The amount of tokens transferred
837      * @param data bytes Additional data with no specified format
838      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
839      */
840     function onTransferReceived(address operator, address sender, uint256 amount, bytes calldata data) external returns (bytes4);
841 }
842 
843 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
844 
845 
846 
847 pragma solidity ^0.8.0;
848 
849 /**
850  * @title IERC1363Spender Interface
851  * @dev Interface for any contract that wants to support approveAndCall
852  *  from ERC1363 token contracts as defined in
853  *  https://eips.ethereum.org/EIPS/eip-1363
854  */
855 interface IERC1363Spender {
856 
857     /**
858      * @notice Handle the approval of ERC1363 tokens
859      * @dev Any ERC1363 smart contract calls this function on the recipient
860      * after an `approve`. This function MAY throw to revert and reject the
861      * approval. Return of other than the magic value MUST result in the
862      * transaction being reverted.
863      * Note: the token contract address is always the message sender.
864      * @param sender address The address which called `approveAndCall` function
865      * @param amount uint256 The amount of tokens to be spent
866      * @param data bytes Additional data with no specified format
867      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
868      */
869     function onApprovalReceived(address sender, uint256 amount, bytes calldata data) external returns (bytes4);
870 }
871 
872 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
873 
874 
875 
876 pragma solidity ^0.8.0;
877 
878 
879 
880 
881 
882 
883 
884 /**
885  * @title ERC1363
886  * @dev Implementation of an ERC1363 interface
887  */
888 abstract contract ERC1363 is ERC20, IERC1363, ERC165 {
889     using Address for address;
890 
891     /**
892      * @dev See {IERC165-supportsInterface}.
893      */
894     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
895         return interfaceId == type(IERC1363).interfaceId || super.supportsInterface(interfaceId);
896     }
897 
898     /**
899      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
900      * @param recipient The address to transfer to.
901      * @param amount The amount to be transferred.
902      * @return A boolean that indicates if the operation was successful.
903      */
904     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
905         return transferAndCall(recipient, amount, "");
906     }
907 
908     /**
909      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
910      * @param recipient The address to transfer to
911      * @param amount The amount to be transferred
912      * @param data Additional data with no specified format
913      * @return A boolean that indicates if the operation was successful.
914      */
915     function transferAndCall(address recipient, uint256 amount, bytes memory data) public virtual override returns (bool) {
916         transfer(recipient, amount);
917         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
918         return true;
919     }
920 
921     /**
922      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
923      * @param sender The address which you want to send tokens from
924      * @param recipient The address which you want to transfer to
925      * @param amount The amount of tokens to be transferred
926      * @return A boolean that indicates if the operation was successful.
927      */
928     function transferFromAndCall(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
929         return transferFromAndCall(sender, recipient, amount, "");
930     }
931 
932     /**
933      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
934      * @param sender The address which you want to send tokens from
935      * @param recipient The address which you want to transfer to
936      * @param amount The amount of tokens to be transferred
937      * @param data Additional data with no specified format
938      * @return A boolean that indicates if the operation was successful.
939      */
940     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes memory data) public virtual override returns (bool) {
941         transferFrom(sender, recipient, amount);
942         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
943         return true;
944     }
945 
946     /**
947      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
948      * @param spender The address allowed to transfer to
949      * @param amount The amount allowed to be transferred
950      * @return A boolean that indicates if the operation was successful.
951      */
952     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
953         return approveAndCall(spender, amount, "");
954     }
955 
956     /**
957      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
958      * @param spender The address allowed to transfer to.
959      * @param amount The amount allowed to be transferred.
960      * @param data Additional data with no specified format.
961      * @return A boolean that indicates if the operation was successful.
962      */
963     function approveAndCall(address spender, uint256 amount, bytes memory data) public virtual override returns (bool) {
964         approve(spender, amount);
965         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
966         return true;
967     }
968 
969     /**
970      * @dev Internal function to invoke `onTransferReceived` on a target address
971      *  The call is not executed if the target address is not a contract
972      * @param sender address Representing the previous owner of the given token value
973      * @param recipient address Target address that will receive the tokens
974      * @param amount uint256 The amount mount of tokens to be transferred
975      * @param data bytes Optional data to send along with the call
976      * @return whether the call correctly returned the expected magic value
977      */
978     function _checkAndCallTransfer(address sender, address recipient, uint256 amount, bytes memory data) internal virtual returns (bool) {
979         if (!recipient.isContract()) {
980             return false;
981         }
982         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(
983             _msgSender(), sender, amount, data
984         );
985         return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
986     }
987 
988     /**
989      * @dev Internal function to invoke `onApprovalReceived` on a target address
990      *  The call is not executed if the target address is not a contract
991      * @param spender address The address which will spend the funds
992      * @param amount uint256 The amount of tokens to be spent
993      * @param data bytes Optional data to send along with the call
994      * @return whether the call correctly returned the expected magic value
995      */
996     function _checkAndCallApprove(address spender, uint256 amount, bytes memory data) internal virtual returns (bool) {
997         if (!spender.isContract()) {
998             return false;
999         }
1000         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1001             _msgSender(), amount, data
1002         );
1003         return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
1004     }
1005 }
1006 
1007 // File: @openzeppelin/contracts/access/Ownable.sol
1008 
1009 
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 /**
1014  * @dev Contract module which provides a basic access control mechanism, where
1015  * there is an account (an owner) that can be granted exclusive access to
1016  * specific functions.
1017  *
1018  * By default, the owner account will be the one that deploys the contract. This
1019  * can later be changed with {transferOwnership}.
1020  *
1021  * This module is used through inheritance. It will make available the modifier
1022  * `onlyOwner`, which can be applied to your functions to restrict their use to
1023  * the owner.
1024  */
1025 abstract contract Ownable is Context {
1026     address private _owner;
1027 
1028     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1029 
1030     /**
1031      * @dev Initializes the contract setting the deployer as the initial owner.
1032      */
1033     constructor () {
1034         address msgSender = _msgSender();
1035         _owner = msgSender;
1036         emit OwnershipTransferred(address(0), msgSender);
1037     }
1038 
1039     /**
1040      * @dev Returns the address of the current owner.
1041      */
1042     function owner() public view virtual returns (address) {
1043         return _owner;
1044     }
1045 
1046     /**
1047      * @dev Throws if called by any account other than the owner.
1048      */
1049     modifier onlyOwner() {
1050         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1051         _;
1052     }
1053 
1054     /**
1055      * @dev Leaves the contract without owner. It will not be possible to call
1056      * `onlyOwner` functions anymore. Can only be called by the current owner.
1057      *
1058      * NOTE: Renouncing ownership will leave the contract without an owner,
1059      * thereby removing any functionality that is only available to the owner.
1060      */
1061     function renounceOwnership() public virtual onlyOwner {
1062         emit OwnershipTransferred(_owner, address(0));
1063         _owner = address(0);
1064     }
1065 
1066     /**
1067      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1068      * Can only be called by the current owner.
1069      */
1070     function transferOwnership(address newOwner) public virtual onlyOwner {
1071         require(newOwner != address(0), "Ownable: new owner is the zero address");
1072         emit OwnershipTransferred(_owner, newOwner);
1073         _owner = newOwner;
1074     }
1075 }
1076 
1077 // File: eth-token-recover/contracts/TokenRecover.sol
1078 
1079 
1080 
1081 pragma solidity ^0.8.0;
1082 
1083 
1084 
1085 /**
1086  * @title TokenRecover
1087  * @dev Allows owner to recover any ERC20 sent into the contract
1088  */
1089 contract TokenRecover is Ownable {
1090 
1091     /**
1092      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1093      * @param tokenAddress The token contract address
1094      * @param tokenAmount Number of tokens to be sent
1095      */
1096     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
1097         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1098     }
1099 }
1100 
1101 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
1102 
1103 
1104 
1105 pragma solidity ^0.8.0;
1106 
1107 
1108 /**
1109  * @title ERC20Decimals
1110  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
1111  */
1112 abstract contract ERC20Decimals is ERC20 {
1113     uint8 immutable private _decimals;
1114 
1115     /**
1116      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
1117      * set once during construction.
1118      */
1119     constructor (uint8 decimals_) {
1120         _decimals = decimals_;
1121     }
1122 
1123     function decimals() public view virtual override returns (uint8) {
1124         return _decimals;
1125     }
1126 }
1127 
1128 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
1129 
1130 
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 
1135 /**
1136  * @title ERC20Mintable
1137  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
1138  */
1139 abstract contract ERC20Mintable is ERC20 {
1140 
1141     // indicates if minting is finished
1142     bool private _mintingFinished = false;
1143 
1144     /**
1145      * @dev Emitted during finish minting
1146      */
1147     event MintFinished();
1148 
1149     /**
1150      * @dev Tokens can be minted only before minting finished.
1151      */
1152     modifier canMint() {
1153         require(!_mintingFinished, "ERC20Mintable: minting is finished");
1154         _;
1155     }
1156 
1157     /**
1158      * @return if minting is finished or not.
1159      */
1160     function mintingFinished() external view returns (bool) {
1161         return _mintingFinished;
1162     }
1163 
1164     /**
1165      * @dev Function to mint tokens.
1166      *
1167      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
1168      *
1169      * @param account The address that will receive the minted tokens
1170      * @param amount The amount of tokens to mint
1171      */
1172     function mint(address account, uint256 amount) external canMint {
1173         _mint(account, amount);
1174     }
1175 
1176     /**
1177      * @dev Function to stop minting new tokens.
1178      *
1179      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
1180      */
1181     function finishMinting() external canMint {
1182         _finishMinting();
1183     }
1184 
1185     /**
1186      * @dev Function to stop minting new tokens.
1187      */
1188     function _finishMinting() internal virtual {
1189         _mintingFinished = true;
1190 
1191         emit MintFinished();
1192     }
1193 }
1194 
1195 // File: contracts/service/ServicePayer.sol
1196 
1197 
1198 
1199 pragma solidity ^0.8.0;
1200 
1201 interface IPayable {
1202     function pay(string memory serviceName) external payable;
1203 }
1204 
1205 /**
1206  * @title ServicePayer
1207  * @dev Implementation of the ServicePayer
1208  */
1209 abstract contract ServicePayer {
1210 
1211     constructor (address payable receiver, string memory serviceName) payable {
1212         IPayable(receiver).pay{value: msg.value}(serviceName);
1213     }
1214 }
1215 
1216 // File: contracts/token/ERC20/AmazingERC20.sol
1217 
1218 
1219 
1220 pragma solidity ^0.8.0;
1221 
1222 
1223 
1224 
1225 
1226 
1227 
1228 /**
1229  * @title AmazingERC20
1230  * @dev Implementation of the AmazingERC20
1231  */
1232 contract AmazingERC20 is ERC20Decimals, ERC20Mintable, ERC20Burnable, ERC1363, TokenRecover, ServicePayer {
1233 
1234     constructor (
1235         string memory name_,
1236         string memory symbol_,
1237         uint8 decimals_,
1238         uint256 initialBalance_,
1239         address payable feeReceiver_
1240     )
1241         ERC20(name_, symbol_)
1242         ERC20Decimals(decimals_)
1243         ServicePayer(feeReceiver_, "AmazingERC20")
1244         payable
1245     {
1246         _mint(_msgSender(), initialBalance_);
1247     }
1248 
1249     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
1250         return super.decimals();
1251     }
1252 
1253     /**
1254      * @dev Function to mint tokens.
1255      *
1256      * NOTE: restricting access to addresses with MINTER role. See {ERC20Mintable-mint}.
1257      *
1258      * @param account The address that will receive the minted tokens
1259      * @param amount The amount of tokens to mint
1260      */
1261     function _mint(address account, uint256 amount) internal override onlyOwner {
1262         super._mint(account, amount);
1263     }
1264 
1265     /**
1266      * @dev Function to stop minting new tokens.
1267      *
1268      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
1269      */
1270     function _finishMinting() internal override onlyOwner {
1271         super._finishMinting();
1272     }
1273 }
