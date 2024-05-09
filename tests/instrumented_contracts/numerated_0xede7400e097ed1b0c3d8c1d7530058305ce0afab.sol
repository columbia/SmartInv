1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Emitted when `value` tokens are moved from one account (`from`) to
16      * another (`to`).
17      *
18      * Note that `value` may be zero.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /**
23      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
24      * a call to {approve}. `value` is the new allowance.
25      */
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `from` to `to` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) external returns (bool);
86 }
87 
88 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
89 
90 
91 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
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
121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
148 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
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
255      * - `to` cannot be the zero address.
256      * - the caller must have a balance of at least `amount`.
257      */
258     function transfer(address to, uint256 amount) public virtual override returns (bool) {
259         address owner = _msgSender();
260         _transfer(owner, to, amount);
261         return true;
262     }
263 
264     /**
265      * @dev See {IERC20-allowance}.
266      */
267     function allowance(address owner, address spender) public view virtual override returns (uint256) {
268         return _allowances[owner][spender];
269     }
270 
271     /**
272      * @dev See {IERC20-approve}.
273      *
274      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
275      * `transferFrom`. This is semantically equivalent to an infinite approval.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function approve(address spender, uint256 amount) public virtual override returns (bool) {
282         address owner = _msgSender();
283         _approve(owner, spender, amount);
284         return true;
285     }
286 
287     /**
288      * @dev See {IERC20-transferFrom}.
289      *
290      * Emits an {Approval} event indicating the updated allowance. This is not
291      * required by the EIP. See the note at the beginning of {ERC20}.
292      *
293      * NOTE: Does not update the allowance if the current allowance
294      * is the maximum `uint256`.
295      *
296      * Requirements:
297      *
298      * - `from` and `to` cannot be the zero address.
299      * - `from` must have a balance of at least `amount`.
300      * - the caller must have allowance for ``from``'s tokens of at least
301      * `amount`.
302      */
303     function transferFrom(
304         address from,
305         address to,
306         uint256 amount
307     ) public virtual override returns (bool) {
308         address spender = _msgSender();
309         _spendAllowance(from, spender, amount);
310         _transfer(from, to, amount);
311         return true;
312     }
313 
314     /**
315      * @dev Atomically increases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to {approve} that can be used as a mitigation for
318      * problems described in {IERC20-approve}.
319      *
320      * Emits an {Approval} event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      */
326     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
327         address owner = _msgSender();
328         _approve(owner, spender, allowance(owner, spender) + addedValue);
329         return true;
330     }
331 
332     /**
333      * @dev Atomically decreases the allowance granted to `spender` by the caller.
334      *
335      * This is an alternative to {approve} that can be used as a mitigation for
336      * problems described in {IERC20-approve}.
337      *
338      * Emits an {Approval} event indicating the updated allowance.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      * - `spender` must have allowance for the caller of at least
344      * `subtractedValue`.
345      */
346     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
347         address owner = _msgSender();
348         uint256 currentAllowance = allowance(owner, spender);
349         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
350         unchecked {
351             _approve(owner, spender, currentAllowance - subtractedValue);
352         }
353 
354         return true;
355     }
356 
357     /**
358      * @dev Moves `amount` of tokens from `sender` to `recipient`.
359      *
360      * This internal function is equivalent to {transfer}, and can be used to
361      * e.g. implement automatic token fees, slashing mechanisms, etc.
362      *
363      * Emits a {Transfer} event.
364      *
365      * Requirements:
366      *
367      * - `from` cannot be the zero address.
368      * - `to` cannot be the zero address.
369      * - `from` must have a balance of at least `amount`.
370      */
371     function _transfer(
372         address from,
373         address to,
374         uint256 amount
375     ) internal virtual {
376         require(from != address(0), "ERC20: transfer from the zero address");
377         require(to != address(0), "ERC20: transfer to the zero address");
378 
379         _beforeTokenTransfer(from, to, amount);
380 
381         uint256 fromBalance = _balances[from];
382         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
383         unchecked {
384             _balances[from] = fromBalance - amount;
385         }
386         _balances[to] += amount;
387 
388         emit Transfer(from, to, amount);
389 
390         _afterTokenTransfer(from, to, amount);
391     }
392 
393     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
394      * the total supply.
395      *
396      * Emits a {Transfer} event with `from` set to the zero address.
397      *
398      * Requirements:
399      *
400      * - `account` cannot be the zero address.
401      */
402     function _mint(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: mint to the zero address");
404 
405         _beforeTokenTransfer(address(0), account, amount);
406 
407         _totalSupply += amount;
408         _balances[account] += amount;
409         emit Transfer(address(0), account, amount);
410 
411         _afterTokenTransfer(address(0), account, amount);
412     }
413 
414     /**
415      * @dev Destroys `amount` tokens from `account`, reducing the
416      * total supply.
417      *
418      * Emits a {Transfer} event with `to` set to the zero address.
419      *
420      * Requirements:
421      *
422      * - `account` cannot be the zero address.
423      * - `account` must have at least `amount` tokens.
424      */
425     function _burn(address account, uint256 amount) internal virtual {
426         require(account != address(0), "ERC20: burn from the zero address");
427 
428         _beforeTokenTransfer(account, address(0), amount);
429 
430         uint256 accountBalance = _balances[account];
431         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
432         unchecked {
433             _balances[account] = accountBalance - amount;
434         }
435         _totalSupply -= amount;
436 
437         emit Transfer(account, address(0), amount);
438 
439         _afterTokenTransfer(account, address(0), amount);
440     }
441 
442     /**
443      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
444      *
445      * This internal function is equivalent to `approve`, and can be used to
446      * e.g. set automatic allowances for certain subsystems, etc.
447      *
448      * Emits an {Approval} event.
449      *
450      * Requirements:
451      *
452      * - `owner` cannot be the zero address.
453      * - `spender` cannot be the zero address.
454      */
455     function _approve(
456         address owner,
457         address spender,
458         uint256 amount
459     ) internal virtual {
460         require(owner != address(0), "ERC20: approve from the zero address");
461         require(spender != address(0), "ERC20: approve to the zero address");
462 
463         _allowances[owner][spender] = amount;
464         emit Approval(owner, spender, amount);
465     }
466 
467     /**
468      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
469      *
470      * Does not update the allowance amount in case of infinite allowance.
471      * Revert if not enough allowance is available.
472      *
473      * Might emit an {Approval} event.
474      */
475     function _spendAllowance(
476         address owner,
477         address spender,
478         uint256 amount
479     ) internal virtual {
480         uint256 currentAllowance = allowance(owner, spender);
481         if (currentAllowance != type(uint256).max) {
482             require(currentAllowance >= amount, "ERC20: insufficient allowance");
483             unchecked {
484                 _approve(owner, spender, currentAllowance - amount);
485             }
486         }
487     }
488 
489     /**
490      * @dev Hook that is called before any transfer of tokens. This includes
491      * minting and burning.
492      *
493      * Calling conditions:
494      *
495      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
496      * will be transferred to `to`.
497      * - when `from` is zero, `amount` tokens will be minted for `to`.
498      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
499      * - `from` and `to` are never both zero.
500      *
501      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
502      */
503     function _beforeTokenTransfer(
504         address from,
505         address to,
506         uint256 amount
507     ) internal virtual {}
508 
509     /**
510      * @dev Hook that is called after any transfer of tokens. This includes
511      * minting and burning.
512      *
513      * Calling conditions:
514      *
515      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
516      * has been transferred to `to`.
517      * - when `from` is zero, `amount` tokens have been minted for `to`.
518      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
519      * - `from` and `to` are never both zero.
520      *
521      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
522      */
523     function _afterTokenTransfer(
524         address from,
525         address to,
526         uint256 amount
527     ) internal virtual {}
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
531 
532 
533 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 
539 /**
540  * @dev Extension of {ERC20} that allows token holders to destroy both their own
541  * tokens and those that they have an allowance for, in a way that can be
542  * recognized off-chain (via event analysis).
543  */
544 abstract contract ERC20Burnable is Context, ERC20 {
545     /**
546      * @dev Destroys `amount` tokens from the caller.
547      *
548      * See {ERC20-_burn}.
549      */
550     function burn(uint256 amount) public virtual {
551         _burn(_msgSender(), amount);
552     }
553 
554     /**
555      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
556      * allowance.
557      *
558      * See {ERC20-_burn} and {ERC20-allowance}.
559      *
560      * Requirements:
561      *
562      * - the caller must have allowance for ``accounts``'s tokens of at least
563      * `amount`.
564      */
565     function burnFrom(address account, uint256 amount) public virtual {
566         _spendAllowance(account, _msgSender(), amount);
567         _burn(account, amount);
568     }
569 }
570 
571 // File: @openzeppelin/contracts/utils/Address.sol
572 
573 
574 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
575 
576 pragma solidity ^0.8.1;
577 
578 /**
579  * @dev Collection of functions related to the address type
580  */
581 library Address {
582     /**
583      * @dev Returns true if `account` is a contract.
584      *
585      * [IMPORTANT]
586      * ====
587      * It is unsafe to assume that an address for which this function returns
588      * false is an externally-owned account (EOA) and not a contract.
589      *
590      * Among others, `isContract` will return false for the following
591      * types of addresses:
592      *
593      *  - an externally-owned account
594      *  - a contract in construction
595      *  - an address where a contract will be created
596      *  - an address where a contract lived, but was destroyed
597      * ====
598      *
599      * [IMPORTANT]
600      * ====
601      * You shouldn't rely on `isContract` to protect against flash loan attacks!
602      *
603      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
604      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
605      * constructor.
606      * ====
607      */
608     function isContract(address account) internal view returns (bool) {
609         // This method relies on extcodesize/address.code.length, which returns 0
610         // for contracts in construction, since the code is only stored at the end
611         // of the constructor execution.
612 
613         return account.code.length > 0;
614     }
615 
616     /**
617      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
618      * `recipient`, forwarding all available gas and reverting on errors.
619      *
620      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
621      * of certain opcodes, possibly making contracts go over the 2300 gas limit
622      * imposed by `transfer`, making them unable to receive funds via
623      * `transfer`. {sendValue} removes this limitation.
624      *
625      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
626      *
627      * IMPORTANT: because control is transferred to `recipient`, care must be
628      * taken to not create reentrancy vulnerabilities. Consider using
629      * {ReentrancyGuard} or the
630      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
631      */
632     function sendValue(address payable recipient, uint256 amount) internal {
633         require(address(this).balance >= amount, "Address: insufficient balance");
634 
635         (bool success, ) = recipient.call{value: amount}("");
636         require(success, "Address: unable to send value, recipient may have reverted");
637     }
638 
639     /**
640      * @dev Performs a Solidity function call using a low level `call`. A
641      * plain `call` is an unsafe replacement for a function call: use this
642      * function instead.
643      *
644      * If `target` reverts with a revert reason, it is bubbled up by this
645      * function (like regular Solidity function calls).
646      *
647      * Returns the raw returned data. To convert to the expected return value,
648      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
649      *
650      * Requirements:
651      *
652      * - `target` must be a contract.
653      * - calling `target` with `data` must not revert.
654      *
655      * _Available since v3.1._
656      */
657     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
658         return functionCall(target, data, "Address: low-level call failed");
659     }
660 
661     /**
662      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
663      * `errorMessage` as a fallback revert reason when `target` reverts.
664      *
665      * _Available since v3.1._
666      */
667     function functionCall(
668         address target,
669         bytes memory data,
670         string memory errorMessage
671     ) internal returns (bytes memory) {
672         return functionCallWithValue(target, data, 0, errorMessage);
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
677      * but also transferring `value` wei to `target`.
678      *
679      * Requirements:
680      *
681      * - the calling contract must have an ETH balance of at least `value`.
682      * - the called Solidity function must be `payable`.
683      *
684      * _Available since v3.1._
685      */
686     function functionCallWithValue(
687         address target,
688         bytes memory data,
689         uint256 value
690     ) internal returns (bytes memory) {
691         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
696      * with `errorMessage` as a fallback revert reason when `target` reverts.
697      *
698      * _Available since v3.1._
699      */
700     function functionCallWithValue(
701         address target,
702         bytes memory data,
703         uint256 value,
704         string memory errorMessage
705     ) internal returns (bytes memory) {
706         require(address(this).balance >= value, "Address: insufficient balance for call");
707         require(isContract(target), "Address: call to non-contract");
708 
709         (bool success, bytes memory returndata) = target.call{value: value}(data);
710         return verifyCallResult(success, returndata, errorMessage);
711     }
712 
713     /**
714      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
715      * but performing a static call.
716      *
717      * _Available since v3.3._
718      */
719     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
720         return functionStaticCall(target, data, "Address: low-level static call failed");
721     }
722 
723     /**
724      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
725      * but performing a static call.
726      *
727      * _Available since v3.3._
728      */
729     function functionStaticCall(
730         address target,
731         bytes memory data,
732         string memory errorMessage
733     ) internal view returns (bytes memory) {
734         require(isContract(target), "Address: static call to non-contract");
735 
736         (bool success, bytes memory returndata) = target.staticcall(data);
737         return verifyCallResult(success, returndata, errorMessage);
738     }
739 
740     /**
741      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
742      * but performing a delegate call.
743      *
744      * _Available since v3.4._
745      */
746     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
747         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
752      * but performing a delegate call.
753      *
754      * _Available since v3.4._
755      */
756     function functionDelegateCall(
757         address target,
758         bytes memory data,
759         string memory errorMessage
760     ) internal returns (bytes memory) {
761         require(isContract(target), "Address: delegate call to non-contract");
762 
763         (bool success, bytes memory returndata) = target.delegatecall(data);
764         return verifyCallResult(success, returndata, errorMessage);
765     }
766 
767     /**
768      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
769      * revert reason using the provided one.
770      *
771      * _Available since v4.3._
772      */
773     function verifyCallResult(
774         bool success,
775         bytes memory returndata,
776         string memory errorMessage
777     ) internal pure returns (bytes memory) {
778         if (success) {
779             return returndata;
780         } else {
781             // Look for revert reason and bubble it up if present
782             if (returndata.length > 0) {
783                 // The easiest way to bubble the revert reason is using memory via assembly
784 
785                 assembly {
786                     let returndata_size := mload(returndata)
787                     revert(add(32, returndata), returndata_size)
788                 }
789             } else {
790                 revert(errorMessage);
791             }
792         }
793     }
794 }
795 
796 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
797 
798 
799 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
800 
801 pragma solidity ^0.8.0;
802 
803 /**
804  * @dev Interface of the ERC165 standard, as defined in the
805  * https://eips.ethereum.org/EIPS/eip-165[EIP].
806  *
807  * Implementers can declare support of contract interfaces, which can then be
808  * queried by others ({ERC165Checker}).
809  *
810  * For an implementation, see {ERC165}.
811  */
812 interface IERC165 {
813     /**
814      * @dev Returns true if this contract implements the interface defined by
815      * `interfaceId`. See the corresponding
816      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
817      * to learn more about how these ids are created.
818      *
819      * This function call must use less than 30 000 gas.
820      */
821     function supportsInterface(bytes4 interfaceId) external view returns (bool);
822 }
823 
824 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
825 
826 
827 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
828 
829 pragma solidity ^0.8.0;
830 
831 
832 /**
833  * @dev Implementation of the {IERC165} interface.
834  *
835  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
836  * for the additional interface id that will be supported. For example:
837  *
838  * ```solidity
839  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
840  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
841  * }
842  * ```
843  *
844  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
845  */
846 abstract contract ERC165 is IERC165 {
847     /**
848      * @dev See {IERC165-supportsInterface}.
849      */
850     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
851         return interfaceId == type(IERC165).interfaceId;
852     }
853 }
854 
855 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
856 
857 
858 
859 pragma solidity ^0.8.0;
860 
861 
862 
863 /**
864  * @title IERC1363 Interface
865  * @dev Interface for a Payable Token contract as defined in
866  *  https://eips.ethereum.org/EIPS/eip-1363
867  */
868 interface IERC1363 is IERC20, IERC165 {
869     /**
870      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
871      * @param to address The address which you want to transfer to
872      * @param amount uint256 The amount of tokens to be transferred
873      * @return true unless throwing
874      */
875     function transferAndCall(address to, uint256 amount) external returns (bool);
876 
877     /**
878      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
879      * @param to address The address which you want to transfer to
880      * @param amount uint256 The amount of tokens to be transferred
881      * @param data bytes Additional data with no specified format, sent in call to `to`
882      * @return true unless throwing
883      */
884     function transferAndCall(
885         address to,
886         uint256 amount,
887         bytes calldata data
888     ) external returns (bool);
889 
890     /**
891      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
892      * @param sender address The address which you want to send tokens from
893      * @param to address The address which you want to transfer to
894      * @param amount uint256 The amount of tokens to be transferred
895      * @return true unless throwing
896      */
897     function transferFromAndCall(
898         address sender,
899         address to,
900         uint256 amount
901     ) external returns (bool);
902 
903     /**
904      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
905      * @param sender address The address which you want to send tokens from
906      * @param to address The address which you want to transfer to
907      * @param amount uint256 The amount of tokens to be transferred
908      * @param data bytes Additional data with no specified format, sent in call to `to`
909      * @return true unless throwing
910      */
911     function transferFromAndCall(
912         address sender,
913         address to,
914         uint256 amount,
915         bytes calldata data
916     ) external returns (bool);
917 
918     /**
919      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
920      * and then call `onApprovalReceived` on spender.
921      * Beware that changing an allowance with this method brings the risk that someone may use both the old
922      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
923      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
924      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
925      * @param spender address The address which will spend the funds
926      * @param amount uint256 The amount of tokens to be spent
927      */
928     function approveAndCall(address spender, uint256 amount) external returns (bool);
929 
930     /**
931      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
932      * and then call `onApprovalReceived` on spender.
933      * Beware that changing an allowance with this method brings the risk that someone may use both the old
934      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
935      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
936      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
937      * @param spender address The address which will spend the funds
938      * @param amount uint256 The amount of tokens to be spent
939      * @param data bytes Additional data with no specified format, sent in call to `spender`
940      */
941     function approveAndCall(
942         address spender,
943         uint256 amount,
944         bytes calldata data
945     ) external returns (bool);
946 }
947 
948 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
949 
950 
951 
952 pragma solidity ^0.8.0;
953 
954 /**
955  * @title IERC1363Receiver Interface
956  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
957  *  from ERC1363 token contracts as defined in
958  *  https://eips.ethereum.org/EIPS/eip-1363
959  */
960 interface IERC1363Receiver {
961     /**
962      * @notice Handle the receipt of ERC1363 tokens
963      * @dev Any ERC1363 smart contract calls this function on the recipient
964      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
965      * transfer. Return of other than the magic value MUST result in the
966      * transaction being reverted.
967      * Note: the token contract address is always the message sender.
968      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
969      * @param sender address The address which are token transferred from
970      * @param amount uint256 The amount of tokens transferred
971      * @param data bytes Additional data with no specified format
972      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
973      */
974     function onTransferReceived(
975         address operator,
976         address sender,
977         uint256 amount,
978         bytes calldata data
979     ) external returns (bytes4);
980 }
981 
982 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
983 
984 
985 
986 pragma solidity ^0.8.0;
987 
988 /**
989  * @title IERC1363Spender Interface
990  * @dev Interface for any contract that wants to support approveAndCall
991  *  from ERC1363 token contracts as defined in
992  *  https://eips.ethereum.org/EIPS/eip-1363
993  */
994 interface IERC1363Spender {
995     /**
996      * @notice Handle the approval of ERC1363 tokens
997      * @dev Any ERC1363 smart contract calls this function on the recipient
998      * after an `approve`. This function MAY throw to revert and reject the
999      * approval. Return of other than the magic value MUST result in the
1000      * transaction being reverted.
1001      * Note: the token contract address is always the message sender.
1002      * @param sender address The address which called `approveAndCall` function
1003      * @param amount uint256 The amount of tokens to be spent
1004      * @param data bytes Additional data with no specified format
1005      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
1006      */
1007     function onApprovalReceived(
1008         address sender,
1009         uint256 amount,
1010         bytes calldata data
1011     ) external returns (bytes4);
1012 }
1013 
1014 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1015 
1016 
1017 
1018 pragma solidity ^0.8.0;
1019 
1020 
1021 
1022 
1023 
1024 
1025 
1026 /**
1027  * @title ERC1363
1028  * @dev Implementation of an ERC1363 interface
1029  */
1030 abstract contract ERC1363 is ERC20, IERC1363, ERC165 {
1031     using Address for address;
1032 
1033     /**
1034      * @dev See {IERC165-supportsInterface}.
1035      */
1036     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1037         return interfaceId == type(IERC1363).interfaceId || super.supportsInterface(interfaceId);
1038     }
1039 
1040     /**
1041      * @dev Transfer tokens to a specified address and then execute a callback on `to`.
1042      * @param to The address to transfer to.
1043      * @param amount The amount to be transferred.
1044      * @return A boolean that indicates if the operation was successful.
1045      */
1046     function transferAndCall(address to, uint256 amount) public virtual override returns (bool) {
1047         return transferAndCall(to, amount, "");
1048     }
1049 
1050     /**
1051      * @dev Transfer tokens to a specified address and then execute a callback on `to`.
1052      * @param to The address to transfer to
1053      * @param amount The amount to be transferred
1054      * @param data Additional data with no specified format
1055      * @return A boolean that indicates if the operation was successful.
1056      */
1057     function transferAndCall(
1058         address to,
1059         uint256 amount,
1060         bytes memory data
1061     ) public virtual override returns (bool) {
1062         transfer(to, amount);
1063         require(_checkAndCallTransfer(_msgSender(), to, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1064         return true;
1065     }
1066 
1067     /**
1068      * @dev Transfer tokens from one address to another and then execute a callback on `to`.
1069      * @param from The address which you want to send tokens from
1070      * @param to The address which you want to transfer to
1071      * @param amount The amount of tokens to be transferred
1072      * @return A boolean that indicates if the operation was successful.
1073      */
1074     function transferFromAndCall(
1075         address from,
1076         address to,
1077         uint256 amount
1078     ) public virtual override returns (bool) {
1079         return transferFromAndCall(from, to, amount, "");
1080     }
1081 
1082     /**
1083      * @dev Transfer tokens from one address to another and then execute a callback on `to`.
1084      * @param from The address which you want to send tokens from
1085      * @param to The address which you want to transfer to
1086      * @param amount The amount of tokens to be transferred
1087      * @param data Additional data with no specified format
1088      * @return A boolean that indicates if the operation was successful.
1089      */
1090     function transferFromAndCall(
1091         address from,
1092         address to,
1093         uint256 amount,
1094         bytes memory data
1095     ) public virtual override returns (bool) {
1096         transferFrom(from, to, amount);
1097         require(_checkAndCallTransfer(from, to, amount, data), "ERC1363: _checkAndCallTransfer reverts");
1098         return true;
1099     }
1100 
1101     /**
1102      * @dev Approve spender to transfer tokens and then execute a callback on `spender`.
1103      * @param spender The address allowed to transfer to
1104      * @param amount The amount allowed to be transferred
1105      * @return A boolean that indicates if the operation was successful.
1106      */
1107     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
1108         return approveAndCall(spender, amount, "");
1109     }
1110 
1111     /**
1112      * @dev Approve spender to transfer tokens and then execute a callback on `spender`.
1113      * @param spender The address allowed to transfer to.
1114      * @param amount The amount allowed to be transferred.
1115      * @param data Additional data with no specified format.
1116      * @return A boolean that indicates if the operation was successful.
1117      */
1118     function approveAndCall(
1119         address spender,
1120         uint256 amount,
1121         bytes memory data
1122     ) public virtual override returns (bool) {
1123         approve(spender, amount);
1124         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
1125         return true;
1126     }
1127 
1128     /**
1129      * @dev Internal function to invoke `onTransferReceived` on a target address
1130      *  The call is not executed if the target address is not a contract
1131      * @param sender address Representing the previous owner of the given token value
1132      * @param recipient address Target address that will receive the tokens
1133      * @param amount uint256 The amount mount of tokens to be transferred
1134      * @param data bytes Optional data to send along with the call
1135      * @return whether the call correctly returned the expected magic value
1136      */
1137     function _checkAndCallTransfer(
1138         address sender,
1139         address recipient,
1140         uint256 amount,
1141         bytes memory data
1142     ) internal virtual returns (bool) {
1143         if (!recipient.isContract()) {
1144             return false;
1145         }
1146         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(_msgSender(), sender, amount, data);
1147         return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
1148     }
1149 
1150     /**
1151      * @dev Internal function to invoke `onApprovalReceived` on a target address
1152      *  The call is not executed if the target address is not a contract
1153      * @param spender address The address which will spend the funds
1154      * @param amount uint256 The amount of tokens to be spent
1155      * @param data bytes Optional data to send along with the call
1156      * @return whether the call correctly returned the expected magic value
1157      */
1158     function _checkAndCallApprove(
1159         address spender,
1160         uint256 amount,
1161         bytes memory data
1162     ) internal virtual returns (bool) {
1163         if (!spender.isContract()) {
1164             return false;
1165         }
1166         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(_msgSender(), amount, data);
1167         return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
1168     }
1169 }
1170 
1171 // File: @openzeppelin/contracts/access/Ownable.sol
1172 
1173 
1174 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1175 
1176 pragma solidity ^0.8.0;
1177 
1178 
1179 /**
1180  * @dev Contract module which provides a basic access control mechanism, where
1181  * there is an account (an owner) that can be granted exclusive access to
1182  * specific functions.
1183  *
1184  * By default, the owner account will be the one that deploys the contract. This
1185  * can later be changed with {transferOwnership}.
1186  *
1187  * This module is used through inheritance. It will make available the modifier
1188  * `onlyOwner`, which can be applied to your functions to restrict their use to
1189  * the owner.
1190  */
1191 abstract contract Ownable is Context {
1192     address private _owner;
1193 
1194     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1195 
1196     /**
1197      * @dev Initializes the contract setting the deployer as the initial owner.
1198      */
1199     constructor() {
1200         _transferOwnership(_msgSender());
1201     }
1202 
1203     /**
1204      * @dev Returns the address of the current owner.
1205      */
1206     function owner() public view virtual returns (address) {
1207         return _owner;
1208     }
1209 
1210     /**
1211      * @dev Throws if called by any account other than the owner.
1212      */
1213     modifier onlyOwner() {
1214         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1215         _;
1216     }
1217 
1218     /**
1219      * @dev Leaves the contract without owner. It will not be possible to call
1220      * `onlyOwner` functions anymore. Can only be called by the current owner.
1221      *
1222      * NOTE: Renouncing ownership will leave the contract without an owner,
1223      * thereby removing any functionality that is only available to the owner.
1224      */
1225     function renounceOwnership() public virtual onlyOwner {
1226         _transferOwnership(address(0));
1227     }
1228 
1229     /**
1230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1231      * Can only be called by the current owner.
1232      */
1233     function transferOwnership(address newOwner) public virtual onlyOwner {
1234         require(newOwner != address(0), "Ownable: new owner is the zero address");
1235         _transferOwnership(newOwner);
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Internal function without access restriction.
1241      */
1242     function _transferOwnership(address newOwner) internal virtual {
1243         address oldOwner = _owner;
1244         _owner = newOwner;
1245         emit OwnershipTransferred(oldOwner, newOwner);
1246     }
1247 }
1248 
1249 // File: eth-token-recover/contracts/TokenRecover.sol
1250 
1251 
1252 
1253 pragma solidity ^0.8.0;
1254 
1255 
1256 
1257 /**
1258  * @title TokenRecover
1259  * @dev Allows owner to recover any ERC20 sent into the contract
1260  */
1261 contract TokenRecover is Ownable {
1262     /**
1263      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1264      * @param tokenAddress The token contract address
1265      * @param tokenAmount Number of tokens to be sent
1266      */
1267     function recoverERC20(address tokenAddress, uint256 tokenAmount) public virtual onlyOwner {
1268         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1269     }
1270 }
1271 
1272 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
1273 
1274 
1275 
1276 pragma solidity ^0.8.0;
1277 
1278 
1279 /**
1280  * @title ERC20Decimals
1281  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
1282  */
1283 abstract contract ERC20Decimals is ERC20 {
1284     uint8 private immutable _decimals;
1285 
1286     /**
1287      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
1288      * set once during construction.
1289      */
1290     constructor(uint8 decimals_) {
1291         _decimals = decimals_;
1292     }
1293 
1294     function decimals() public view virtual override returns (uint8) {
1295         return _decimals;
1296     }
1297 }
1298 
1299 // File: contracts/token/ERC20/behaviours/ERC20Mintable.sol
1300 
1301 
1302 
1303 pragma solidity ^0.8.0;
1304 
1305 
1306 /**
1307  * @title ERC20Mintable
1308  * @dev Implementation of the ERC20Mintable. Extension of {ERC20} that adds a minting behaviour.
1309  */
1310 abstract contract ERC20Mintable is ERC20 {
1311     // indicates if minting is finished
1312     bool private _mintingFinished = false;
1313 
1314     /**
1315      * @dev Emitted during finish minting
1316      */
1317     event MintFinished();
1318 
1319     /**
1320      * @dev Tokens can be minted only before minting finished.
1321      */
1322     modifier canMint() {
1323         require(!_mintingFinished, "ERC20Mintable: minting is finished");
1324         _;
1325     }
1326 
1327     /**
1328      * @return if minting is finished or not.
1329      */
1330     function mintingFinished() external view returns (bool) {
1331         return _mintingFinished;
1332     }
1333 
1334     /**
1335      * @dev Function to mint tokens.
1336      *
1337      * WARNING: it allows everyone to mint new tokens. Access controls MUST be defined in derived contracts.
1338      *
1339      * @param account The address that will receive the minted tokens
1340      * @param amount The amount of tokens to mint
1341      */
1342     function mint(address account, uint256 amount) external canMint {
1343         _mint(account, amount);
1344     }
1345 
1346     /**
1347      * @dev Function to stop minting new tokens.
1348      *
1349      * WARNING: it allows everyone to finish minting. Access controls MUST be defined in derived contracts.
1350      */
1351     function finishMinting() external canMint {
1352         _finishMinting();
1353     }
1354 
1355     /**
1356      * @dev Function to stop minting new tokens.
1357      */
1358     function _finishMinting() internal virtual {
1359         _mintingFinished = true;
1360 
1361         emit MintFinished();
1362     }
1363 }
1364 
1365 // File: contracts/service/ServicePayer.sol
1366 
1367 
1368 
1369 pragma solidity ^0.8.0;
1370 
1371 interface IPayable {
1372     function pay(
1373         string memory serviceName,
1374         bytes memory signature,
1375         address wallet
1376     ) external payable;
1377 }
1378 
1379 /**
1380  * @title ServicePayer
1381  * @dev Implementation of the ServicePayer
1382  */
1383 abstract contract ServicePayer {
1384     constructor(
1385         address payable receiver,
1386         string memory serviceName,
1387         bytes memory signature,
1388         address wallet
1389     ) payable {
1390         IPayable(receiver).pay{value: msg.value}(serviceName, signature, wallet);
1391     }
1392 }
1393 
1394 // File: contracts/token/ERC20/AmazingERC20.sol
1395 
1396 
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 
1401 
1402 
1403 
1404 
1405 
1406 /**
1407  * @title AmazingERC20
1408  * @dev Implementation of the AmazingERC20
1409  */
1410 contract AmazingERC20 is ERC20Decimals, ERC20Mintable, ERC20Burnable, ERC1363, TokenRecover, ServicePayer {
1411     constructor(
1412         string memory name_,
1413         string memory symbol_,
1414         uint8 decimals_,
1415         uint256 initialBalance_,
1416         bytes memory signature_,
1417         address payable feeReceiver_
1418     )
1419         payable
1420         ERC20(name_, symbol_)
1421         ERC20Decimals(decimals_)
1422         ServicePayer(feeReceiver_, "AmazingERC20", signature_, _msgSender())
1423     {
1424         _mint(_msgSender(), initialBalance_);
1425     }
1426 
1427     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
1428         return super.decimals();
1429     }
1430 
1431     /**
1432      * @dev Function to mint tokens.
1433      *
1434      * NOTE: restricting access to owner only. See {ERC20Mintable-mint}.
1435      *
1436      * @param account The address that will receive the minted tokens
1437      * @param amount The amount of tokens to mint
1438      */
1439     function _mint(address account, uint256 amount) internal override onlyOwner {
1440         super._mint(account, amount);
1441     }
1442 
1443     /**
1444      * @dev Function to stop minting new tokens.
1445      *
1446      * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
1447      */
1448     function _finishMinting() internal override onlyOwner {
1449         super._finishMinting();
1450     }
1451 }