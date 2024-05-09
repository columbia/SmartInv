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
487 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
488 
489 
490 
491 pragma solidity ^0.8.0;
492 
493 
494 /**
495  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
496  */
497 abstract contract ERC20Capped is ERC20 {
498     uint256 immutable private _cap;
499 
500     /**
501      * @dev Sets the value of the `cap`. This value is immutable, it can only be
502      * set once during construction.
503      */
504     constructor (uint256 cap_) {
505         require(cap_ > 0, "ERC20Capped: cap is 0");
506         _cap = cap_;
507     }
508 
509     /**
510      * @dev Returns the cap on the token's total supply.
511      */
512     function cap() public view virtual returns (uint256) {
513         return _cap;
514     }
515 
516     /**
517      * @dev See {ERC20-_mint}.
518      */
519     function _mint(address account, uint256 amount) internal virtual override {
520         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
521         super._mint(account, amount);
522     }
523 }
524 
525 // File: @openzeppelin/contracts/utils/Address.sol
526 
527 
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Collection of functions related to the address type
533  */
534 library Address {
535     /**
536      * @dev Returns true if `account` is a contract.
537      *
538      * [IMPORTANT]
539      * ====
540      * It is unsafe to assume that an address for which this function returns
541      * false is an externally-owned account (EOA) and not a contract.
542      *
543      * Among others, `isContract` will return false for the following
544      * types of addresses:
545      *
546      *  - an externally-owned account
547      *  - a contract in construction
548      *  - an address where a contract will be created
549      *  - an address where a contract lived, but was destroyed
550      * ====
551      */
552     function isContract(address account) internal view returns (bool) {
553         // This method relies on extcodesize, which returns 0 for contracts in
554         // construction, since the code is only stored at the end of the
555         // constructor execution.
556 
557         uint256 size;
558         // solhint-disable-next-line no-inline-assembly
559         assembly { size := extcodesize(account) }
560         return size > 0;
561     }
562 
563     /**
564      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
565      * `recipient`, forwarding all available gas and reverting on errors.
566      *
567      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
568      * of certain opcodes, possibly making contracts go over the 2300 gas limit
569      * imposed by `transfer`, making them unable to receive funds via
570      * `transfer`. {sendValue} removes this limitation.
571      *
572      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
573      *
574      * IMPORTANT: because control is transferred to `recipient`, care must be
575      * taken to not create reentrancy vulnerabilities. Consider using
576      * {ReentrancyGuard} or the
577      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
578      */
579     function sendValue(address payable recipient, uint256 amount) internal {
580         require(address(this).balance >= amount, "Address: insufficient balance");
581 
582         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
583         (bool success, ) = recipient.call{ value: amount }("");
584         require(success, "Address: unable to send value, recipient may have reverted");
585     }
586 
587     /**
588      * @dev Performs a Solidity function call using a low level `call`. A
589      * plain`call` is an unsafe replacement for a function call: use this
590      * function instead.
591      *
592      * If `target` reverts with a revert reason, it is bubbled up by this
593      * function (like regular Solidity function calls).
594      *
595      * Returns the raw returned data. To convert to the expected return value,
596      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
597      *
598      * Requirements:
599      *
600      * - `target` must be a contract.
601      * - calling `target` with `data` must not revert.
602      *
603      * _Available since v3.1._
604      */
605     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
606       return functionCall(target, data, "Address: low-level call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
611      * `errorMessage` as a fallback revert reason when `target` reverts.
612      *
613      * _Available since v3.1._
614      */
615     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
616         return functionCallWithValue(target, data, 0, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but also transferring `value` wei to `target`.
622      *
623      * Requirements:
624      *
625      * - the calling contract must have an ETH balance of at least `value`.
626      * - the called Solidity function must be `payable`.
627      *
628      * _Available since v3.1._
629      */
630     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
631         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
636      * with `errorMessage` as a fallback revert reason when `target` reverts.
637      *
638      * _Available since v3.1._
639      */
640     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
641         require(address(this).balance >= value, "Address: insufficient balance for call");
642         require(isContract(target), "Address: call to non-contract");
643 
644         // solhint-disable-next-line avoid-low-level-calls
645         (bool success, bytes memory returndata) = target.call{ value: value }(data);
646         return _verifyCallResult(success, returndata, errorMessage);
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
651      * but performing a static call.
652      *
653      * _Available since v3.3._
654      */
655     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
656         return functionStaticCall(target, data, "Address: low-level static call failed");
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
661      * but performing a static call.
662      *
663      * _Available since v3.3._
664      */
665     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
666         require(isContract(target), "Address: static call to non-contract");
667 
668         // solhint-disable-next-line avoid-low-level-calls
669         (bool success, bytes memory returndata) = target.staticcall(data);
670         return _verifyCallResult(success, returndata, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but performing a delegate call.
676      *
677      * _Available since v3.4._
678      */
679     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
680         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
685      * but performing a delegate call.
686      *
687      * _Available since v3.4._
688      */
689     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
690         require(isContract(target), "Address: delegate call to non-contract");
691 
692         // solhint-disable-next-line avoid-low-level-calls
693         (bool success, bytes memory returndata) = target.delegatecall(data);
694         return _verifyCallResult(success, returndata, errorMessage);
695     }
696 
697     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
698         if (success) {
699             return returndata;
700         } else {
701             // Look for revert reason and bubble it up if present
702             if (returndata.length > 0) {
703                 // The easiest way to bubble the revert reason is using memory via assembly
704 
705                 // solhint-disable-next-line no-inline-assembly
706                 assembly {
707                     let returndata_size := mload(returndata)
708                     revert(add(32, returndata), returndata_size)
709                 }
710             } else {
711                 revert(errorMessage);
712             }
713         }
714     }
715 }
716 
717 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
718 
719 
720 
721 pragma solidity ^0.8.0;
722 
723 /**
724  * @dev Interface of the ERC165 standard, as defined in the
725  * https://eips.ethereum.org/EIPS/eip-165[EIP].
726  *
727  * Implementers can declare support of contract interfaces, which can then be
728  * queried by others ({ERC165Checker}).
729  *
730  * For an implementation, see {ERC165}.
731  */
732 interface IERC165 {
733     /**
734      * @dev Returns true if this contract implements the interface defined by
735      * `interfaceId`. See the corresponding
736      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
737      * to learn more about how these ids are created.
738      *
739      * This function call must use less than 30 000 gas.
740      */
741     function supportsInterface(bytes4 interfaceId) external view returns (bool);
742 }
743 
744 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
745 
746 
747 
748 pragma solidity ^0.8.0;
749 
750 
751 /**
752  * @dev Implementation of the {IERC165} interface.
753  *
754  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
755  * for the additional interface id that will be supported. For example:
756  *
757  * ```solidity
758  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
759  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
760  * }
761  * ```
762  *
763  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
764  */
765 abstract contract ERC165 is IERC165 {
766     /**
767      * @dev See {IERC165-supportsInterface}.
768      */
769     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
770         return interfaceId == type(IERC165).interfaceId;
771     }
772 }
773 
774 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
775 
776 
777 
778 pragma solidity ^0.8.0;
779 
780 
781 
782 /**
783  * @title IERC1363 Interface
784  * @dev Interface for a Payable Token contract as defined in
785  *  https://eips.ethereum.org/EIPS/eip-1363
786  */
787 interface IERC1363 is IERC20, IERC165 {
788 
789     /**
790      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
791      * @param recipient address The address which you want to transfer to
792      * @param amount uint256 The amount of tokens to be transferred
793      * @return true unless throwing
794      */
795     function transferAndCall(address recipient, uint256 amount) external returns (bool);
796 
797     /**
798      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
799      * @param recipient address The address which you want to transfer to
800      * @param amount uint256 The amount of tokens to be transferred
801      * @param data bytes Additional data with no specified format, sent in call to `recipient`
802      * @return true unless throwing
803      */
804     function transferAndCall(address recipient, uint256 amount, bytes calldata data) external returns (bool);
805 
806     /**
807      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
808      * @param sender address The address which you want to send tokens from
809      * @param recipient address The address which you want to transfer to
810      * @param amount uint256 The amount of tokens to be transferred
811      * @return true unless throwing
812      */
813     function transferFromAndCall(address sender, address recipient, uint256 amount) external returns (bool);
814 
815     /**
816      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
817      * @param sender address The address which you want to send tokens from
818      * @param recipient address The address which you want to transfer to
819      * @param amount uint256 The amount of tokens to be transferred
820      * @param data bytes Additional data with no specified format, sent in call to `recipient`
821      * @return true unless throwing
822      */
823     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes calldata data) external returns (bool);
824 
825     /**
826      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
827      * and then call `onApprovalReceived` on spender.
828      * Beware that changing an allowance with this method brings the risk that someone may use both the old
829      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
830      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
831      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
832      * @param spender address The address which will spend the funds
833      * @param amount uint256 The amount of tokens to be spent
834      */
835     function approveAndCall(address spender, uint256 amount) external returns (bool);
836 
837     /**
838      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
839      * and then call `onApprovalReceived` on spender.
840      * Beware that changing an allowance with this method brings the risk that someone may use both the old
841      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
842      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
843      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
844      * @param spender address The address which will spend the funds
845      * @param amount uint256 The amount of tokens to be spent
846      * @param data bytes Additional data with no specified format, sent in call to `spender`
847      */
848     function approveAndCall(address spender, uint256 amount, bytes calldata data) external returns (bool);
849 }
850 
851 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
852 
853 
854 
855 pragma solidity ^0.8.0;
856 
857 /**
858  * @title IERC1363Receiver Interface
859  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
860  *  from ERC1363 token contracts as defined in
861  *  https://eips.ethereum.org/EIPS/eip-1363
862  */
863 interface IERC1363Receiver {
864 
865     /**
866      * @notice Handle the receipt of ERC1363 tokens
867      * @dev Any ERC1363 smart contract calls this function on the recipient
868      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
869      * transfer. Return of other than the magic value MUST result in the
870      * transaction being reverted.
871      * Note: the token contract address is always the message sender.
872      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
873      * @param sender address The address which are token transferred from
874      * @param amount uint256 The amount of tokens transferred
875      * @param data bytes Additional data with no specified format
876      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
877      */
878     function onTransferReceived(address operator, address sender, uint256 amount, bytes calldata data) external returns (bytes4);
879 }
880 
881 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
882 
883 
884 
885 pragma solidity ^0.8.0;
886 
887 /**
888  * @title IERC1363Spender Interface
889  * @dev Interface for any contract that wants to support approveAndCall
890  *  from ERC1363 token contracts as defined in
891  *  https://eips.ethereum.org/EIPS/eip-1363
892  */
893 interface IERC1363Spender {
894 
895     /**
896      * @notice Handle the approval of ERC1363 tokens
897      * @dev Any ERC1363 smart contract calls this function on the recipient
898      * after an `approve`. This function MAY throw to revert and reject the
899      * approval. Return of other than the magic value MUST result in the
900      * transaction being reverted.
901      * Note: the token contract address is always the message sender.
902      * @param sender address The address which called `approveAndCall` function
903      * @param amount uint256 The amount of tokens to be spent
904      * @param data bytes Additional data with no specified format
905      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
906      */
907     function onApprovalReceived(address sender, uint256 amount, bytes calldata data) external returns (bytes4);
908 }
909 
910 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
911 
912 
913 
914 pragma solidity ^0.8.0;
915 
916 
917 
918 
919 
920 
921 
922 /**
923  * @title ERC1363
924  * @dev Implementation of an ERC1363 interface
925  */
926 abstract contract ERC1363 is ERC20, IERC1363, ERC165 {
927     using Address for address;
928 
929     /**
930      * @dev See {IERC165-supportsInterface}.
931      */
932     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
933         return interfaceId == type(IERC1363).interfaceId || super.supportsInterface(interfaceId);
934     }
935 
936     /**
937      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
938      * @param recipient The address to transfer to.
939      * @param amount The amount to be transferred.
940      * @return A boolean that indicates if the operation was successful.
941      */
942     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
943         return transferAndCall(recipient, amount, "");
944     }
945 
946     /**
947      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
948      * @param recipient The address to transfer to
949      * @param amount The amount to be transferred
950      * @param data Additional data with no specified format
951      * @return A boolean that indicates if the operation was successful.
952      */
953     function transferAndCall(address recipient, uint256 amount, bytes memory data) public virtual override returns (bool) {
954         transfer(recipient, amount);
955         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
956         return true;
957     }
958 
959     /**
960      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
961      * @param sender The address which you want to send tokens from
962      * @param recipient The address which you want to transfer to
963      * @param amount The amount of tokens to be transferred
964      * @return A boolean that indicates if the operation was successful.
965      */
966     function transferFromAndCall(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
967         return transferFromAndCall(sender, recipient, amount, "");
968     }
969 
970     /**
971      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
972      * @param sender The address which you want to send tokens from
973      * @param recipient The address which you want to transfer to
974      * @param amount The amount of tokens to be transferred
975      * @param data Additional data with no specified format
976      * @return A boolean that indicates if the operation was successful.
977      */
978     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes memory data) public virtual override returns (bool) {
979         transferFrom(sender, recipient, amount);
980         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
981         return true;
982     }
983 
984     /**
985      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
986      * @param spender The address allowed to transfer to
987      * @param amount The amount allowed to be transferred
988      * @return A boolean that indicates if the operation was successful.
989      */
990     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
991         return approveAndCall(spender, amount, "");
992     }
993 
994     /**
995      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
996      * @param spender The address allowed to transfer to.
997      * @param amount The amount allowed to be transferred.
998      * @param data Additional data with no specified format.
999      * @return A boolean that indicates if the operation was successful.
1000      */
1001     function approveAndCall(address spender, uint256 amount, bytes memory data) public virtual override returns (bool) {
1002         approve(spender, amount);
1003         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
1004         return true;
1005     }
1006 
1007     /**
1008      * @dev Internal function to invoke `onTransferReceived` on a target address
1009      *  The call is not executed if the target address is not a contract
1010      * @param sender address Representing the previous owner of the given token value
1011      * @param recipient address Target address that will receive the tokens
1012      * @param amount uint256 The amount mount of tokens to be transferred
1013      * @param data bytes Optional data to send along with the call
1014      * @return whether the call correctly returned the expected magic value
1015      */
1016     function _checkAndCallTransfer(address sender, address recipient, uint256 amount, bytes memory data) internal virtual returns (bool) {
1017         if (!recipient.isContract()) {
1018             return false;
1019         }
1020         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(
1021             _msgSender(), sender, amount, data
1022         );
1023         return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
1024     }
1025 
1026     /**
1027      * @dev Internal function to invoke `onApprovalReceived` on a target address
1028      *  The call is not executed if the target address is not a contract
1029      * @param spender address The address which will spend the funds
1030      * @param amount uint256 The amount of tokens to be spent
1031      * @param data bytes Optional data to send along with the call
1032      * @return whether the call correctly returned the expected magic value
1033      */
1034     function _checkAndCallApprove(address spender, uint256 amount, bytes memory data) internal virtual returns (bool) {
1035         if (!spender.isContract()) {
1036             return false;
1037         }
1038         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1039             _msgSender(), amount, data
1040         );
1041         return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
1042     }
1043 }
1044 
1045 // File: @openzeppelin/contracts/access/Ownable.sol
1046 
1047 
1048 
1049 pragma solidity ^0.8.0;
1050 
1051 /**
1052  * @dev Contract module which provides a basic access control mechanism, where
1053  * there is an account (an owner) that can be granted exclusive access to
1054  * specific functions.
1055  *
1056  * By default, the owner account will be the one that deploys the contract. This
1057  * can later be changed with {transferOwnership}.
1058  *
1059  * This module is used through inheritance. It will make available the modifier
1060  * `onlyOwner`, which can be applied to your functions to restrict their use to
1061  * the owner.
1062  */
1063 abstract contract Ownable is Context {
1064     address private _owner;
1065 
1066     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1067 
1068     /**
1069      * @dev Initializes the contract setting the deployer as the initial owner.
1070      */
1071     constructor () {
1072         address msgSender = _msgSender();
1073         _owner = msgSender;
1074         emit OwnershipTransferred(address(0), msgSender);
1075     }
1076 
1077     /**
1078      * @dev Returns the address of the current owner.
1079      */
1080     function owner() public view virtual returns (address) {
1081         return _owner;
1082     }
1083 
1084     /**
1085      * @dev Throws if called by any account other than the owner.
1086      */
1087     modifier onlyOwner() {
1088         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1089         _;
1090     }
1091 
1092     /**
1093      * @dev Leaves the contract without owner. It will not be possible to call
1094      * `onlyOwner` functions anymore. Can only be called by the current owner.
1095      *
1096      * NOTE: Renouncing ownership will leave the contract without an owner,
1097      * thereby removing any functionality that is only available to the owner.
1098      */
1099     function renounceOwnership() public virtual onlyOwner {
1100         emit OwnershipTransferred(_owner, address(0));
1101         _owner = address(0);
1102     }
1103 
1104     /**
1105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1106      * Can only be called by the current owner.
1107      */
1108     function transferOwnership(address newOwner) public virtual onlyOwner {
1109         require(newOwner != address(0), "Ownable: new owner is the zero address");
1110         emit OwnershipTransferred(_owner, newOwner);
1111         _owner = newOwner;
1112     }
1113 }
1114 
1115 // File: eth-token-recover/contracts/TokenRecover.sol
1116 
1117 
1118 
1119 pragma solidity ^0.8.0;
1120 
1121 
1122 
1123 /**
1124  * @title TokenRecover
1125  * @dev Allows owner to recover any ERC20 sent into the contract
1126  */
1127 contract TokenRecover is Ownable {
1128 
1129     /**
1130      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1131      * @param tokenAddress The token contract address
1132      * @param tokenAmount Number of tokens to be sent
1133      */
1134     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
1135         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1136     }
1137 }
1138 
1139 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
1140 
1141 
1142 
1143 pragma solidity ^0.8.0;
1144 
1145 
1146 /**
1147  * @title ERC20Decimals
1148  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
1149  */
1150 abstract contract ERC20Decimals is ERC20 {
1151     uint8 immutable private _decimals;
1152 
1153     /**
1154      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
1155      * set once during construction.
1156      */
1157     constructor (uint8 decimals_) {
1158         _decimals = decimals_;
1159     }
1160 
1161     function decimals() public view virtual override returns (uint8) {
1162         return _decimals;
1163     }
1164 }
1165 
1166 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
1167 
1168 
1169 
1170 pragma solidity ^0.8.0;
1171 
1172 
1173 /**
1174  * @title ERC20Mintable
1175  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
1176  */
1177 abstract contract ERC20Mintable is ERC20 {
1178 
1179     // indicates if minting is finished
1180     bool private _mintingFinished = false;
1181 
1182     /**
1183      * @dev Emitted during finish minting
1184      */
1185     event MintFinished();
1186 
1187     /**
1188      * @dev Tokens can be minted only before minting finished.
1189      */
1190     modifier canMint() {
1191         require(!_mintingFinished, "ERC20Mintable: minting is finished");
1192         _;
1193     }
1194 
1195     /**
1196      * @return if minting is finished or not.
1197      */
1198     function mintingFinished() external view returns (bool) {
1199         return _mintingFinished;
1200     }
1201 
1202     /**
1203      * @dev Function to mint tokens.
1204      *
1205      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
1206      *
1207      * @param account The address that will receive the minted tokens
1208      * @param amount The amount of tokens to mint
1209      */
1210     function mint(address account, uint256 amount) external canMint {
1211         _mint(account, amount);
1212     }
1213 
1214     /**
1215      * @dev Function to stop minting new tokens.
1216      *
1217      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
1218      */
1219     function finishMinting() external canMint {
1220         _finishMinting();
1221     }
1222 
1223     /**
1224      * @dev Function to stop minting new tokens.
1225      */
1226     function _finishMinting() internal virtual {
1227         _mintingFinished = true;
1228 
1229         emit MintFinished();
1230     }
1231 }
1232 
1233 // File: @openzeppelin/contracts/utils/Strings.sol
1234 
1235 
1236 
1237 pragma solidity ^0.8.0;
1238 
1239 /**
1240  * @dev String operations.
1241  */
1242 library Strings {
1243     bytes16 private constant alphabet = "0123456789abcdef";
1244 
1245     /**
1246      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1247      */
1248     function toString(uint256 value) internal pure returns (string memory) {
1249         // Inspired by OraclizeAPI's implementation - MIT licence
1250         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1251 
1252         if (value == 0) {
1253             return "0";
1254         }
1255         uint256 temp = value;
1256         uint256 digits;
1257         while (temp != 0) {
1258             digits++;
1259             temp /= 10;
1260         }
1261         bytes memory buffer = new bytes(digits);
1262         while (value != 0) {
1263             digits -= 1;
1264             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1265             value /= 10;
1266         }
1267         return string(buffer);
1268     }
1269 
1270     /**
1271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1272      */
1273     function toHexString(uint256 value) internal pure returns (string memory) {
1274         if (value == 0) {
1275             return "0x00";
1276         }
1277         uint256 temp = value;
1278         uint256 length = 0;
1279         while (temp != 0) {
1280             length++;
1281             temp >>= 8;
1282         }
1283         return toHexString(value, length);
1284     }
1285 
1286     /**
1287      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1288      */
1289     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1290         bytes memory buffer = new bytes(2 * length + 2);
1291         buffer[0] = "0";
1292         buffer[1] = "x";
1293         for (uint256 i = 2 * length + 1; i > 1; --i) {
1294             buffer[i] = alphabet[value & 0xf];
1295             value >>= 4;
1296         }
1297         require(value == 0, "Strings: hex length insufficient");
1298         return string(buffer);
1299     }
1300 
1301 }
1302 
1303 // File: @openzeppelin/contracts/access/AccessControl.sol
1304 
1305 
1306 
1307 pragma solidity ^0.8.0;
1308 
1309 
1310 
1311 
1312 /**
1313  * @dev External interface of AccessControl declared to support ERC165 detection.
1314  */
1315 interface IAccessControl {
1316     function hasRole(bytes32 role, address account) external view returns (bool);
1317     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1318     function grantRole(bytes32 role, address account) external;
1319     function revokeRole(bytes32 role, address account) external;
1320     function renounceRole(bytes32 role, address account) external;
1321 }
1322 
1323 /**
1324  * @dev Contract module that allows children to implement role-based access
1325  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1326  * members except through off-chain means by accessing the contract event logs. Some
1327  * applications may benefit from on-chain enumerability, for those cases see
1328  * {AccessControlEnumerable}.
1329  *
1330  * Roles are referred to by their `bytes32` identifier. These should be exposed
1331  * in the external API and be unique. The best way to achieve this is by
1332  * using `public constant` hash digests:
1333  *
1334  * ```
1335  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1336  * ```
1337  *
1338  * Roles can be used to represent a set of permissions. To restrict access to a
1339  * function call, use {hasRole}:
1340  *
1341  * ```
1342  * function foo() public {
1343  *     require(hasRole(MY_ROLE, msg.sender));
1344  *     ...
1345  * }
1346  * ```
1347  *
1348  * Roles can be granted and revoked dynamically via the {grantRole} and
1349  * {revokeRole} functions. Each role has an associated admin role, and only
1350  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1351  *
1352  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1353  * that only accounts with this role will be able to grant or revoke other
1354  * roles. More complex role relationships can be created by using
1355  * {_setRoleAdmin}.
1356  *
1357  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1358  * grant and revoke this role. Extra precautions should be taken to secure
1359  * accounts that have been granted it.
1360  */
1361 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1362     struct RoleData {
1363         mapping (address => bool) members;
1364         bytes32 adminRole;
1365     }
1366 
1367     mapping (bytes32 => RoleData) private _roles;
1368 
1369     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1370 
1371     /**
1372      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1373      *
1374      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1375      * {RoleAdminChanged} not being emitted signaling this.
1376      *
1377      * _Available since v3.1._
1378      */
1379     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1380 
1381     /**
1382      * @dev Emitted when `account` is granted `role`.
1383      *
1384      * `sender` is the account that originated the contract call, an admin role
1385      * bearer except when using {_setupRole}.
1386      */
1387     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1388 
1389     /**
1390      * @dev Emitted when `account` is revoked `role`.
1391      *
1392      * `sender` is the account that originated the contract call:
1393      *   - if using `revokeRole`, it is the admin role bearer
1394      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1395      */
1396     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1397 
1398     /**
1399      * @dev Modifier that checks that an account has a specific role. Reverts
1400      * with a standardized message including the required role.
1401      *
1402      * The format of the revert reason is given by the following regular expression:
1403      *
1404      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1405      *
1406      * _Available since v4.1._
1407      */
1408     modifier onlyRole(bytes32 role) {
1409         _checkRole(role, _msgSender());
1410         _;
1411     }
1412 
1413     /**
1414      * @dev See {IERC165-supportsInterface}.
1415      */
1416     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1417         return interfaceId == type(IAccessControl).interfaceId
1418             || super.supportsInterface(interfaceId);
1419     }
1420 
1421     /**
1422      * @dev Returns `true` if `account` has been granted `role`.
1423      */
1424     function hasRole(bytes32 role, address account) public view override returns (bool) {
1425         return _roles[role].members[account];
1426     }
1427 
1428     /**
1429      * @dev Revert with a standard message if `account` is missing `role`.
1430      *
1431      * The format of the revert reason is given by the following regular expression:
1432      *
1433      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1434      */
1435     function _checkRole(bytes32 role, address account) internal view {
1436         if(!hasRole(role, account)) {
1437             revert(string(abi.encodePacked(
1438                 "AccessControl: account ",
1439                 Strings.toHexString(uint160(account), 20),
1440                 " is missing role ",
1441                 Strings.toHexString(uint256(role), 32)
1442             )));
1443         }
1444     }
1445 
1446     /**
1447      * @dev Returns the admin role that controls `role`. See {grantRole} and
1448      * {revokeRole}.
1449      *
1450      * To change a role's admin, use {_setRoleAdmin}.
1451      */
1452     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1453         return _roles[role].adminRole;
1454     }
1455 
1456     /**
1457      * @dev Grants `role` to `account`.
1458      *
1459      * If `account` had not been already granted `role`, emits a {RoleGranted}
1460      * event.
1461      *
1462      * Requirements:
1463      *
1464      * - the caller must have ``role``'s admin role.
1465      */
1466     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1467         _grantRole(role, account);
1468     }
1469 
1470     /**
1471      * @dev Revokes `role` from `account`.
1472      *
1473      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1474      *
1475      * Requirements:
1476      *
1477      * - the caller must have ``role``'s admin role.
1478      */
1479     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1480         _revokeRole(role, account);
1481     }
1482 
1483     /**
1484      * @dev Revokes `role` from the calling account.
1485      *
1486      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1487      * purpose is to provide a mechanism for accounts to lose their privileges
1488      * if they are compromised (such as when a trusted device is misplaced).
1489      *
1490      * If the calling account had been granted `role`, emits a {RoleRevoked}
1491      * event.
1492      *
1493      * Requirements:
1494      *
1495      * - the caller must be `account`.
1496      */
1497     function renounceRole(bytes32 role, address account) public virtual override {
1498         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1499 
1500         _revokeRole(role, account);
1501     }
1502 
1503     /**
1504      * @dev Grants `role` to `account`.
1505      *
1506      * If `account` had not been already granted `role`, emits a {RoleGranted}
1507      * event. Note that unlike {grantRole}, this function doesn't perform any
1508      * checks on the calling account.
1509      *
1510      * [WARNING]
1511      * ====
1512      * This function should only be called from the constructor when setting
1513      * up the initial roles for the system.
1514      *
1515      * Using this function in any other way is effectively circumventing the admin
1516      * system imposed by {AccessControl}.
1517      * ====
1518      */
1519     function _setupRole(bytes32 role, address account) internal virtual {
1520         _grantRole(role, account);
1521     }
1522 
1523     /**
1524      * @dev Sets `adminRole` as ``role``'s admin role.
1525      *
1526      * Emits a {RoleAdminChanged} event.
1527      */
1528     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1529         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1530         _roles[role].adminRole = adminRole;
1531     }
1532 
1533     function _grantRole(bytes32 role, address account) private {
1534         if (!hasRole(role, account)) {
1535             _roles[role].members[account] = true;
1536             emit RoleGranted(role, account, _msgSender());
1537         }
1538     }
1539 
1540     function _revokeRole(bytes32 role, address account) private {
1541         if (hasRole(role, account)) {
1542             _roles[role].members[account] = false;
1543             emit RoleRevoked(role, account, _msgSender());
1544         }
1545     }
1546 }
1547 
1548 // File: contracts/access/Roles.sol
1549 
1550 
1551 
1552 pragma solidity ^0.8.0;
1553 
1554 
1555 contract Roles is AccessControl {
1556 
1557     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1558 
1559     constructor () {
1560         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1561         _setupRole(MINTER_ROLE, _msgSender());
1562     }
1563 
1564     modifier onlyMinter() {
1565         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1566         _;
1567     }
1568 }
1569 
1570 // File: contracts/service/ServicePayer.sol
1571 
1572 
1573 
1574 pragma solidity ^0.8.0;
1575 
1576 interface IPayable {
1577     function pay(string memory serviceName) external payable;
1578 }
1579 
1580 /**
1581  * @title ServicePayer
1582  * @dev Implementation of the ServicePayer
1583  */
1584 abstract contract ServicePayer {
1585 
1586     constructor (address payable receiver, string memory serviceName) payable {
1587         IPayable(receiver).pay{value: msg.value}(serviceName);
1588     }
1589 }
1590 
1591 // File: contracts/token/ERC20/PowerfulERC20.sol
1592 
1593 
1594 
1595 pragma solidity ^0.8.0;
1596 
1597 
1598 
1599 
1600 
1601 
1602 
1603 
1604 
1605 /**
1606  * @title PowerfulERC20
1607  * @dev Implementation of the PowerfulERC20
1608  */
1609 contract PowerfulERC20 is ERC20Decimals, ERC20Capped, ERC20Mintable, ERC20Burnable, ERC1363, TokenRecover, Roles, ServicePayer {
1610 
1611     constructor (
1612         string memory name_,
1613         string memory symbol_,
1614         uint8 decimals_,
1615         uint256 cap_,
1616         uint256 initialBalance_,
1617         address payable feeReceiver_
1618     )
1619         ERC20(name_, symbol_)
1620         ERC20Decimals(decimals_)
1621         ERC20Capped(cap_)
1622         ServicePayer(feeReceiver_, "PowerfulERC20")
1623         payable
1624     {
1625         // Immutable variables cannot be read during contract creation time
1626         // https://github.com/ethereum/solidity/issues/10463
1627         require(initialBalance_ <= cap_, "ERC20Capped: cap exceeded");
1628         ERC20._mint(_msgSender(), initialBalance_);
1629     }
1630 
1631     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
1632         return super.decimals();
1633     }
1634 
1635     function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC1363) returns (bool) {
1636         return super.supportsInterface(interfaceId);
1637     }
1638 
1639     /**
1640      * @dev Function to mint tokens.
1641      *
1642      * NOTE: restricting access to addresses with MINTER role. See {ERC20Mintable-mint}.
1643      *
1644      * @param account The address that will receive the minted tokens
1645      * @param amount The amount of tokens to mint
1646      */
1647     function _mint(address account, uint256 amount) internal override(ERC20, ERC20Capped) onlyMinter {
1648         super._mint(account, amount);
1649     }
1650 
1651     /**
1652      * @dev Function to stop minting new tokens.
1653      *
1654      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
1655      */
1656     function _finishMinting() internal override onlyOwner {
1657         super._finishMinting();
1658     }
1659 }