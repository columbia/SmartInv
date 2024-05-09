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
788     /**
789      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
790      * @param recipient address The address which you want to transfer to
791      * @param amount uint256 The amount of tokens to be transferred
792      * @return true unless throwing
793      */
794     function transferAndCall(address recipient, uint256 amount) external returns (bool);
795 
796     /**
797      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
798      * @param recipient address The address which you want to transfer to
799      * @param amount uint256 The amount of tokens to be transferred
800      * @param data bytes Additional data with no specified format, sent in call to `recipient`
801      * @return true unless throwing
802      */
803     function transferAndCall(
804         address recipient,
805         uint256 amount,
806         bytes calldata data
807     ) external returns (bool);
808 
809     /**
810      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
811      * @param sender address The address which you want to send tokens from
812      * @param recipient address The address which you want to transfer to
813      * @param amount uint256 The amount of tokens to be transferred
814      * @return true unless throwing
815      */
816     function transferFromAndCall(
817         address sender,
818         address recipient,
819         uint256 amount
820     ) external returns (bool);
821 
822     /**
823      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
824      * @param sender address The address which you want to send tokens from
825      * @param recipient address The address which you want to transfer to
826      * @param amount uint256 The amount of tokens to be transferred
827      * @param data bytes Additional data with no specified format, sent in call to `recipient`
828      * @return true unless throwing
829      */
830     function transferFromAndCall(
831         address sender,
832         address recipient,
833         uint256 amount,
834         bytes calldata data
835     ) external returns (bool);
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
846      */
847     function approveAndCall(address spender, uint256 amount) external returns (bool);
848 
849     /**
850      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
851      * and then call `onApprovalReceived` on spender.
852      * Beware that changing an allowance with this method brings the risk that someone may use both the old
853      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
854      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
855      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
856      * @param spender address The address which will spend the funds
857      * @param amount uint256 The amount of tokens to be spent
858      * @param data bytes Additional data with no specified format, sent in call to `spender`
859      */
860     function approveAndCall(
861         address spender,
862         uint256 amount,
863         bytes calldata data
864     ) external returns (bool);
865 }
866 
867 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
868 
869 
870 
871 pragma solidity ^0.8.0;
872 
873 /**
874  * @title IERC1363Receiver Interface
875  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
876  *  from ERC1363 token contracts as defined in
877  *  https://eips.ethereum.org/EIPS/eip-1363
878  */
879 interface IERC1363Receiver {
880     /**
881      * @notice Handle the receipt of ERC1363 tokens
882      * @dev Any ERC1363 smart contract calls this function on the recipient
883      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
884      * transfer. Return of other than the magic value MUST result in the
885      * transaction being reverted.
886      * Note: the token contract address is always the message sender.
887      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
888      * @param sender address The address which are token transferred from
889      * @param amount uint256 The amount of tokens transferred
890      * @param data bytes Additional data with no specified format
891      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
892      */
893     function onTransferReceived(
894         address operator,
895         address sender,
896         uint256 amount,
897         bytes calldata data
898     ) external returns (bytes4);
899 }
900 
901 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
902 
903 
904 
905 pragma solidity ^0.8.0;
906 
907 /**
908  * @title IERC1363Spender Interface
909  * @dev Interface for any contract that wants to support approveAndCall
910  *  from ERC1363 token contracts as defined in
911  *  https://eips.ethereum.org/EIPS/eip-1363
912  */
913 interface IERC1363Spender {
914     /**
915      * @notice Handle the approval of ERC1363 tokens
916      * @dev Any ERC1363 smart contract calls this function on the recipient
917      * after an `approve`. This function MAY throw to revert and reject the
918      * approval. Return of other than the magic value MUST result in the
919      * transaction being reverted.
920      * Note: the token contract address is always the message sender.
921      * @param sender address The address which called `approveAndCall` function
922      * @param amount uint256 The amount of tokens to be spent
923      * @param data bytes Additional data with no specified format
924      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
925      */
926     function onApprovalReceived(
927         address sender,
928         uint256 amount,
929         bytes calldata data
930     ) external returns (bytes4);
931 }
932 
933 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
934 
935 
936 
937 pragma solidity ^0.8.0;
938 
939 
940 
941 
942 
943 
944 
945 /**
946  * @title ERC1363
947  * @dev Implementation of an ERC1363 interface
948  */
949 abstract contract ERC1363 is ERC20, IERC1363, ERC165 {
950     using Address for address;
951 
952     /**
953      * @dev See {IERC165-supportsInterface}.
954      */
955     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
956         return interfaceId == type(IERC1363).interfaceId || super.supportsInterface(interfaceId);
957     }
958 
959     /**
960      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
961      * @param recipient The address to transfer to.
962      * @param amount The amount to be transferred.
963      * @return A boolean that indicates if the operation was successful.
964      */
965     function transferAndCall(address recipient, uint256 amount) public virtual override returns (bool) {
966         return transferAndCall(recipient, amount, "");
967     }
968 
969     /**
970      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
971      * @param recipient The address to transfer to
972      * @param amount The amount to be transferred
973      * @param data Additional data with no specified format
974      * @return A boolean that indicates if the operation was successful.
975      */
976     function transferAndCall(
977         address recipient,
978         uint256 amount,
979         bytes memory data
980     ) public virtual override returns (bool) {
981         transfer(recipient, amount);
982         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
983         return true;
984     }
985 
986     /**
987      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
988      * @param sender The address which you want to send tokens from
989      * @param recipient The address which you want to transfer to
990      * @param amount The amount of tokens to be transferred
991      * @return A boolean that indicates if the operation was successful.
992      */
993     function transferFromAndCall(
994         address sender,
995         address recipient,
996         uint256 amount
997     ) public virtual override returns (bool) {
998         return transferFromAndCall(sender, recipient, amount, "");
999     }
1000 
1001     /**
1002      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1003      * @param sender The address which you want to send tokens from
1004      * @param recipient The address which you want to transfer to
1005      * @param amount The amount of tokens to be transferred
1006      * @param data Additional data with no specified format
1007      * @return A boolean that indicates if the operation was successful.
1008      */
1009     function transferFromAndCall(
1010         address sender,
1011         address recipient,
1012         uint256 amount,
1013         bytes memory data
1014     ) public virtual override returns (bool) {
1015         transferFrom(sender, recipient, amount);
1016         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1017         return true;
1018     }
1019 
1020     /**
1021      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1022      * @param spender The address allowed to transfer to
1023      * @param amount The amount allowed to be transferred
1024      * @return A boolean that indicates if the operation was successful.
1025      */
1026     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
1027         return approveAndCall(spender, amount, "");
1028     }
1029 
1030     /**
1031      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1032      * @param spender The address allowed to transfer to.
1033      * @param amount The amount allowed to be transferred.
1034      * @param data Additional data with no specified format.
1035      * @return A boolean that indicates if the operation was successful.
1036      */
1037     function approveAndCall(
1038         address spender,
1039         uint256 amount,
1040         bytes memory data
1041     ) public virtual override returns (bool) {
1042         approve(spender, amount);
1043         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
1044         return true;
1045     }
1046 
1047     /**
1048      * @dev Internal function to invoke `onTransferReceived` on a target address
1049      *  The call is not executed if the target address is not a contract
1050      * @param sender address Representing the previous owner of the given token value
1051      * @param recipient address Target address that will receive the tokens
1052      * @param amount uint256 The amount mount of tokens to be transferred
1053      * @param data bytes Optional data to send along with the call
1054      * @return whether the call correctly returned the expected magic value
1055      */
1056     function _checkAndCallTransfer(
1057         address sender,
1058         address recipient,
1059         uint256 amount,
1060         bytes memory data
1061     ) internal virtual returns (bool) {
1062         if (!recipient.isContract()) {
1063             return false;
1064         }
1065         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(_msgSender(), sender, amount, data);
1066         return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
1067     }
1068 
1069     /**
1070      * @dev Internal function to invoke `onApprovalReceived` on a target address
1071      *  The call is not executed if the target address is not a contract
1072      * @param spender address The address which will spend the funds
1073      * @param amount uint256 The amount of tokens to be spent
1074      * @param data bytes Optional data to send along with the call
1075      * @return whether the call correctly returned the expected magic value
1076      */
1077     function _checkAndCallApprove(
1078         address spender,
1079         uint256 amount,
1080         bytes memory data
1081     ) internal virtual returns (bool) {
1082         if (!spender.isContract()) {
1083             return false;
1084         }
1085         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(_msgSender(), amount, data);
1086         return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
1087     }
1088 }
1089 
1090 // File: @openzeppelin/contracts/access/Ownable.sol
1091 
1092 
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 /**
1097  * @dev Contract module which provides a basic access control mechanism, where
1098  * there is an account (an owner) that can be granted exclusive access to
1099  * specific functions.
1100  *
1101  * By default, the owner account will be the one that deploys the contract. This
1102  * can later be changed with {transferOwnership}.
1103  *
1104  * This module is used through inheritance. It will make available the modifier
1105  * `onlyOwner`, which can be applied to your functions to restrict their use to
1106  * the owner.
1107  */
1108 abstract contract Ownable is Context {
1109     address private _owner;
1110 
1111     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1112 
1113     /**
1114      * @dev Initializes the contract setting the deployer as the initial owner.
1115      */
1116     constructor () {
1117         address msgSender = _msgSender();
1118         _owner = msgSender;
1119         emit OwnershipTransferred(address(0), msgSender);
1120     }
1121 
1122     /**
1123      * @dev Returns the address of the current owner.
1124      */
1125     function owner() public view virtual returns (address) {
1126         return _owner;
1127     }
1128 
1129     /**
1130      * @dev Throws if called by any account other than the owner.
1131      */
1132     modifier onlyOwner() {
1133         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1134         _;
1135     }
1136 
1137     /**
1138      * @dev Leaves the contract without owner. It will not be possible to call
1139      * `onlyOwner` functions anymore. Can only be called by the current owner.
1140      *
1141      * NOTE: Renouncing ownership will leave the contract without an owner,
1142      * thereby removing any functionality that is only available to the owner.
1143      */
1144     function renounceOwnership() public virtual onlyOwner {
1145         emit OwnershipTransferred(_owner, address(0));
1146         _owner = address(0);
1147     }
1148 
1149     /**
1150      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1151      * Can only be called by the current owner.
1152      */
1153     function transferOwnership(address newOwner) public virtual onlyOwner {
1154         require(newOwner != address(0), "Ownable: new owner is the zero address");
1155         emit OwnershipTransferred(_owner, newOwner);
1156         _owner = newOwner;
1157     }
1158 }
1159 
1160 // File: eth-token-recover/contracts/TokenRecover.sol
1161 
1162 
1163 
1164 pragma solidity ^0.8.0;
1165 
1166 
1167 
1168 /**
1169  * @title TokenRecover
1170  * @dev Allows owner to recover any ERC20 sent into the contract
1171  */
1172 contract TokenRecover is Ownable {
1173     /**
1174      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1175      * @param tokenAddress The token contract address
1176      * @param tokenAmount Number of tokens to be sent
1177      */
1178     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
1179         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1180     }
1181 }
1182 
1183 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
1184 
1185 
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 /**
1191  * @title ERC20Decimals
1192  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
1193  */
1194 abstract contract ERC20Decimals is ERC20 {
1195     uint8 private immutable _decimals;
1196 
1197     /**
1198      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
1199      * set once during construction.
1200      */
1201     constructor(uint8 decimals_) {
1202         _decimals = decimals_;
1203     }
1204 
1205     function decimals() public view virtual override returns (uint8) {
1206         return _decimals;
1207     }
1208 }
1209 
1210 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
1211 
1212 
1213 
1214 pragma solidity ^0.8.0;
1215 
1216 
1217 /**
1218  * @title ERC20Mintable
1219  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
1220  */
1221 abstract contract ERC20Mintable is ERC20 {
1222     // indicates if minting is finished
1223     bool private _mintingFinished = false;
1224 
1225     /**
1226      * @dev Emitted during finish minting
1227      */
1228     event MintFinished();
1229 
1230     /**
1231      * @dev Tokens can be minted only before minting finished.
1232      */
1233     modifier canMint() {
1234         require(!_mintingFinished, "ERC20Mintable: minting is finished");
1235         _;
1236     }
1237 
1238     /**
1239      * @return if minting is finished or not.
1240      */
1241     function mintingFinished() external view returns (bool) {
1242         return _mintingFinished;
1243     }
1244 
1245     /**
1246      * @dev Function to mint tokens.
1247      *
1248      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
1249      *
1250      * @param account The address that will receive the minted tokens
1251      * @param amount The amount of tokens to mint
1252      */
1253     function mint(address account, uint256 amount) external canMint {
1254         _mint(account, amount);
1255     }
1256 
1257     /**
1258      * @dev Function to stop minting new tokens.
1259      *
1260      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
1261      */
1262     function finishMinting() external canMint {
1263         _finishMinting();
1264     }
1265 
1266     /**
1267      * @dev Function to stop minting new tokens.
1268      */
1269     function _finishMinting() internal virtual {
1270         _mintingFinished = true;
1271 
1272         emit MintFinished();
1273     }
1274 }
1275 
1276 // File: @openzeppelin/contracts/utils/Strings.sol
1277 
1278 
1279 
1280 pragma solidity ^0.8.0;
1281 
1282 /**
1283  * @dev String operations.
1284  */
1285 library Strings {
1286     bytes16 private constant alphabet = "0123456789abcdef";
1287 
1288     /**
1289      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1290      */
1291     function toString(uint256 value) internal pure returns (string memory) {
1292         // Inspired by OraclizeAPI's implementation - MIT licence
1293         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1294 
1295         if (value == 0) {
1296             return "0";
1297         }
1298         uint256 temp = value;
1299         uint256 digits;
1300         while (temp != 0) {
1301             digits++;
1302             temp /= 10;
1303         }
1304         bytes memory buffer = new bytes(digits);
1305         while (value != 0) {
1306             digits -= 1;
1307             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1308             value /= 10;
1309         }
1310         return string(buffer);
1311     }
1312 
1313     /**
1314      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1315      */
1316     function toHexString(uint256 value) internal pure returns (string memory) {
1317         if (value == 0) {
1318             return "0x00";
1319         }
1320         uint256 temp = value;
1321         uint256 length = 0;
1322         while (temp != 0) {
1323             length++;
1324             temp >>= 8;
1325         }
1326         return toHexString(value, length);
1327     }
1328 
1329     /**
1330      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1331      */
1332     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1333         bytes memory buffer = new bytes(2 * length + 2);
1334         buffer[0] = "0";
1335         buffer[1] = "x";
1336         for (uint256 i = 2 * length + 1; i > 1; --i) {
1337             buffer[i] = alphabet[value & 0xf];
1338             value >>= 4;
1339         }
1340         require(value == 0, "Strings: hex length insufficient");
1341         return string(buffer);
1342     }
1343 
1344 }
1345 
1346 // File: @openzeppelin/contracts/access/AccessControl.sol
1347 
1348 
1349 
1350 pragma solidity ^0.8.0;
1351 
1352 
1353 
1354 
1355 /**
1356  * @dev External interface of AccessControl declared to support ERC165 detection.
1357  */
1358 interface IAccessControl {
1359     function hasRole(bytes32 role, address account) external view returns (bool);
1360     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1361     function grantRole(bytes32 role, address account) external;
1362     function revokeRole(bytes32 role, address account) external;
1363     function renounceRole(bytes32 role, address account) external;
1364 }
1365 
1366 /**
1367  * @dev Contract module that allows children to implement role-based access
1368  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1369  * members except through off-chain means by accessing the contract event logs. Some
1370  * applications may benefit from on-chain enumerability, for those cases see
1371  * {AccessControlEnumerable}.
1372  *
1373  * Roles are referred to by their `bytes32` identifier. These should be exposed
1374  * in the external API and be unique. The best way to achieve this is by
1375  * using `public constant` hash digests:
1376  *
1377  * ```
1378  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1379  * ```
1380  *
1381  * Roles can be used to represent a set of permissions. To restrict access to a
1382  * function call, use {hasRole}:
1383  *
1384  * ```
1385  * function foo() public {
1386  *     require(hasRole(MY_ROLE, msg.sender));
1387  *     ...
1388  * }
1389  * ```
1390  *
1391  * Roles can be granted and revoked dynamically via the {grantRole} and
1392  * {revokeRole} functions. Each role has an associated admin role, and only
1393  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1394  *
1395  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1396  * that only accounts with this role will be able to grant or revoke other
1397  * roles. More complex role relationships can be created by using
1398  * {_setRoleAdmin}.
1399  *
1400  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1401  * grant and revoke this role. Extra precautions should be taken to secure
1402  * accounts that have been granted it.
1403  */
1404 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1405     struct RoleData {
1406         mapping (address => bool) members;
1407         bytes32 adminRole;
1408     }
1409 
1410     mapping (bytes32 => RoleData) private _roles;
1411 
1412     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1413 
1414     /**
1415      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1416      *
1417      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1418      * {RoleAdminChanged} not being emitted signaling this.
1419      *
1420      * _Available since v3.1._
1421      */
1422     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1423 
1424     /**
1425      * @dev Emitted when `account` is granted `role`.
1426      *
1427      * `sender` is the account that originated the contract call, an admin role
1428      * bearer except when using {_setupRole}.
1429      */
1430     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1431 
1432     /**
1433      * @dev Emitted when `account` is revoked `role`.
1434      *
1435      * `sender` is the account that originated the contract call:
1436      *   - if using `revokeRole`, it is the admin role bearer
1437      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1438      */
1439     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1440 
1441     /**
1442      * @dev Modifier that checks that an account has a specific role. Reverts
1443      * with a standardized message including the required role.
1444      *
1445      * The format of the revert reason is given by the following regular expression:
1446      *
1447      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1448      *
1449      * _Available since v4.1._
1450      */
1451     modifier onlyRole(bytes32 role) {
1452         _checkRole(role, _msgSender());
1453         _;
1454     }
1455 
1456     /**
1457      * @dev See {IERC165-supportsInterface}.
1458      */
1459     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1460         return interfaceId == type(IAccessControl).interfaceId
1461             || super.supportsInterface(interfaceId);
1462     }
1463 
1464     /**
1465      * @dev Returns `true` if `account` has been granted `role`.
1466      */
1467     function hasRole(bytes32 role, address account) public view override returns (bool) {
1468         return _roles[role].members[account];
1469     }
1470 
1471     /**
1472      * @dev Revert with a standard message if `account` is missing `role`.
1473      *
1474      * The format of the revert reason is given by the following regular expression:
1475      *
1476      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1477      */
1478     function _checkRole(bytes32 role, address account) internal view {
1479         if(!hasRole(role, account)) {
1480             revert(string(abi.encodePacked(
1481                 "AccessControl: account ",
1482                 Strings.toHexString(uint160(account), 20),
1483                 " is missing role ",
1484                 Strings.toHexString(uint256(role), 32)
1485             )));
1486         }
1487     }
1488 
1489     /**
1490      * @dev Returns the admin role that controls `role`. See {grantRole} and
1491      * {revokeRole}.
1492      *
1493      * To change a role's admin, use {_setRoleAdmin}.
1494      */
1495     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1496         return _roles[role].adminRole;
1497     }
1498 
1499     /**
1500      * @dev Grants `role` to `account`.
1501      *
1502      * If `account` had not been already granted `role`, emits a {RoleGranted}
1503      * event.
1504      *
1505      * Requirements:
1506      *
1507      * - the caller must have ``role``'s admin role.
1508      */
1509     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1510         _grantRole(role, account);
1511     }
1512 
1513     /**
1514      * @dev Revokes `role` from `account`.
1515      *
1516      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1517      *
1518      * Requirements:
1519      *
1520      * - the caller must have ``role``'s admin role.
1521      */
1522     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1523         _revokeRole(role, account);
1524     }
1525 
1526     /**
1527      * @dev Revokes `role` from the calling account.
1528      *
1529      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1530      * purpose is to provide a mechanism for accounts to lose their privileges
1531      * if they are compromised (such as when a trusted device is misplaced).
1532      *
1533      * If the calling account had been granted `role`, emits a {RoleRevoked}
1534      * event.
1535      *
1536      * Requirements:
1537      *
1538      * - the caller must be `account`.
1539      */
1540     function renounceRole(bytes32 role, address account) public virtual override {
1541         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1542 
1543         _revokeRole(role, account);
1544     }
1545 
1546     /**
1547      * @dev Grants `role` to `account`.
1548      *
1549      * If `account` had not been already granted `role`, emits a {RoleGranted}
1550      * event. Note that unlike {grantRole}, this function doesn't perform any
1551      * checks on the calling account.
1552      *
1553      * [WARNING]
1554      * ====
1555      * This function should only be called from the constructor when setting
1556      * up the initial roles for the system.
1557      *
1558      * Using this function in any other way is effectively circumventing the admin
1559      * system imposed by {AccessControl}.
1560      * ====
1561      */
1562     function _setupRole(bytes32 role, address account) internal virtual {
1563         _grantRole(role, account);
1564     }
1565 
1566     /**
1567      * @dev Sets `adminRole` as ``role``'s admin role.
1568      *
1569      * Emits a {RoleAdminChanged} event.
1570      */
1571     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1572         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1573         _roles[role].adminRole = adminRole;
1574     }
1575 
1576     function _grantRole(bytes32 role, address account) private {
1577         if (!hasRole(role, account)) {
1578             _roles[role].members[account] = true;
1579             emit RoleGranted(role, account, _msgSender());
1580         }
1581     }
1582 
1583     function _revokeRole(bytes32 role, address account) private {
1584         if (hasRole(role, account)) {
1585             _roles[role].members[account] = false;
1586             emit RoleRevoked(role, account, _msgSender());
1587         }
1588     }
1589 }
1590 
1591 // File: contracts/access/Roles.sol
1592 
1593 
1594 
1595 pragma solidity ^0.8.0;
1596 
1597 
1598 contract Roles is AccessControl {
1599     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1600 
1601     constructor() {
1602         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1603         _setupRole(MINTER_ROLE, _msgSender());
1604     }
1605 
1606     modifier onlyMinter() {
1607         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1608         _;
1609     }
1610 }
1611 
1612 // File: contracts/service/ServicePayer.sol
1613 
1614 
1615 
1616 pragma solidity ^0.8.0;
1617 
1618 interface IPayable {
1619     function pay(string memory serviceName) external payable;
1620 }
1621 
1622 /**
1623  * @title ServicePayer
1624  * @dev Implementation of the ServicePayer
1625  */
1626 abstract contract ServicePayer {
1627     constructor(address payable receiver, string memory serviceName) payable {
1628         IPayable(receiver).pay{value: msg.value}(serviceName);
1629     }
1630 }
1631 
1632 // File: contracts/token/ERC20/PowerfulERC20.sol
1633 
1634 
1635 
1636 pragma solidity ^0.8.0;
1637 
1638 
1639 
1640 
1641 
1642 
1643 
1644 
1645 
1646 /**
1647  * @title PowerfulERC20
1648  * @dev Implementation of the PowerfulERC20
1649  */
1650 contract PowerfulERC20 is
1651     ERC20Decimals,
1652     ERC20Capped,
1653     ERC20Mintable,
1654     ERC20Burnable,
1655     ERC1363,
1656     TokenRecover,
1657     Roles,
1658     ServicePayer
1659 {
1660     constructor(
1661         string memory name_,
1662         string memory symbol_,
1663         uint8 decimals_,
1664         uint256 cap_,
1665         uint256 initialBalance_,
1666         address payable feeReceiver_
1667     )
1668         payable
1669         ERC20(name_, symbol_)
1670         ERC20Decimals(decimals_)
1671         ERC20Capped(cap_)
1672         ServicePayer(feeReceiver_, "PowerfulERC20")
1673     {
1674         // Immutable variables cannot be read during contract creation time
1675         // https://github.com/ethereum/solidity/issues/10463
1676         require(initialBalance_ <= cap_, "ERC20Capped: cap exceeded");
1677         ERC20._mint(_msgSender(), initialBalance_);
1678     }
1679 
1680     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
1681         return super.decimals();
1682     }
1683 
1684     function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC1363) returns (bool) {
1685         return super.supportsInterface(interfaceId);
1686     }
1687 
1688     /**
1689      * @dev Function to mint tokens.
1690      *
1691      * NOTE: restricting access to addresses with MINTER role. See {ERC20Mintable-mint}.
1692      *
1693      * @param account The address that will receive the minted tokens
1694      * @param amount The amount of tokens to mint
1695      */
1696     function _mint(address account, uint256 amount) internal override(ERC20, ERC20Capped) onlyMinter {
1697         super._mint(account, amount);
1698     }
1699 
1700     /**
1701      * @dev Function to stop minting new tokens.
1702      *
1703      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
1704      */
1705     function _finishMinting() internal override onlyOwner {
1706         super._finishMinting();
1707     }
1708 }
