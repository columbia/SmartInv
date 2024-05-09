1 // Sources flattened with hardhat v2.11.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
4 
5 // SPDX-License-Identifier: MIT
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
88 
89 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
90 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 
115 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.7.3
116 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface for the optional metadata functions from the ERC20 standard.
122  *
123  * _Available since v4.1._
124  */
125 interface IERC20Metadata is IERC20 {
126     /**
127      * @dev Returns the name of the token.
128      */
129     function name() external view returns (string memory);
130 
131     /**
132      * @dev Returns the symbol of the token.
133      */
134     function symbol() external view returns (string memory);
135 
136     /**
137      * @dev Returns the decimals places of the token.
138      */
139     function decimals() external view returns (uint8);
140 }
141 
142 
143 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.7.3
144 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 
149 
150 /**
151  * @dev Implementation of the {IERC20} interface.
152  *
153  * This implementation is agnostic to the way tokens are created. This means
154  * that a supply mechanism has to be added in a derived contract using {_mint}.
155  * For a generic mechanism see {ERC20PresetMinterPauser}.
156  *
157  * TIP: For a detailed writeup see our guide
158  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
159  * to implement supply mechanisms].
160  *
161  * We have followed general OpenZeppelin Contracts guidelines: functions revert
162  * instead returning `false` on failure. This behavior is nonetheless
163  * conventional and does not conflict with the expectations of ERC20
164  * applications.
165  *
166  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
167  * This allows applications to reconstruct the allowance for all accounts just
168  * by listening to said events. Other implementations of the EIP may not emit
169  * these events, as it isn't required by the specification.
170  *
171  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
172  * functions have been added to mitigate the well-known issues around setting
173  * allowances. See {IERC20-approve}.
174  */
175 contract ERC20 is Context, IERC20, IERC20Metadata {
176     mapping(address => uint256) private _balances;
177 
178     mapping(address => mapping(address => uint256)) private _allowances;
179 
180     uint256 private _totalSupply;
181 
182     string private _name;
183     string private _symbol;
184 
185     /**
186      * @dev Sets the values for {name} and {symbol}.
187      *
188      * The default value of {decimals} is 18. To select a different value for
189      * {decimals} you should overload it.
190      *
191      * All two of these values are immutable: they can only be set once during
192      * construction.
193      */
194     constructor(string memory name_, string memory symbol_) {
195         _name = name_;
196         _symbol = symbol_;
197     }
198 
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() public view virtual override returns (string memory) {
203         return _name;
204     }
205 
206     /**
207      * @dev Returns the symbol of the token, usually a shorter version of the
208      * name.
209      */
210     function symbol() public view virtual override returns (string memory) {
211         return _symbol;
212     }
213 
214     /**
215      * @dev Returns the number of decimals used to get its user representation.
216      * For example, if `decimals` equals `2`, a balance of `505` tokens should
217      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
218      *
219      * Tokens usually opt for a value of 18, imitating the relationship between
220      * Ether and Wei. This is the value {ERC20} uses, unless this function is
221      * overridden;
222      *
223      * NOTE: This information is only used for _display_ purposes: it in
224      * no way affects any of the arithmetic of the contract, including
225      * {IERC20-balanceOf} and {IERC20-transfer}.
226      */
227     function decimals() public view virtual override returns (uint8) {
228         return 18;
229     }
230 
231     /**
232      * @dev See {IERC20-totalSupply}.
233      */
234     function totalSupply() public view virtual override returns (uint256) {
235         return _totalSupply;
236     }
237 
238     /**
239      * @dev See {IERC20-balanceOf}.
240      */
241     function balanceOf(address account) public view virtual override returns (uint256) {
242         return _balances[account];
243     }
244 
245     /**
246      * @dev See {IERC20-transfer}.
247      *
248      * Requirements:
249      *
250      * - `to` cannot be the zero address.
251      * - the caller must have a balance of at least `amount`.
252      */
253     function transfer(address to, uint256 amount) public virtual override returns (bool) {
254         address owner = _msgSender();
255         _transfer(owner, to, amount);
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
269      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
270      * `transferFrom`. This is semantically equivalent to an infinite approval.
271      *
272      * Requirements:
273      *
274      * - `spender` cannot be the zero address.
275      */
276     function approve(address spender, uint256 amount) public virtual override returns (bool) {
277         address owner = _msgSender();
278         _approve(owner, spender, amount);
279         return true;
280     }
281 
282     /**
283      * @dev See {IERC20-transferFrom}.
284      *
285      * Emits an {Approval} event indicating the updated allowance. This is not
286      * required by the EIP. See the note at the beginning of {ERC20}.
287      *
288      * NOTE: Does not update the allowance if the current allowance
289      * is the maximum `uint256`.
290      *
291      * Requirements:
292      *
293      * - `from` and `to` cannot be the zero address.
294      * - `from` must have a balance of at least `amount`.
295      * - the caller must have allowance for ``from``'s tokens of at least
296      * `amount`.
297      */
298     function transferFrom(
299         address from,
300         address to,
301         uint256 amount
302     ) public virtual override returns (bool) {
303         address spender = _msgSender();
304         _spendAllowance(from, spender, amount);
305         _transfer(from, to, amount);
306         return true;
307     }
308 
309     /**
310      * @dev Atomically increases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
322         address owner = _msgSender();
323         _approve(owner, spender, allowance(owner, spender) + addedValue);
324         return true;
325     }
326 
327     /**
328      * @dev Atomically decreases the allowance granted to `spender` by the caller.
329      *
330      * This is an alternative to {approve} that can be used as a mitigation for
331      * problems described in {IERC20-approve}.
332      *
333      * Emits an {Approval} event indicating the updated allowance.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      * - `spender` must have allowance for the caller of at least
339      * `subtractedValue`.
340      */
341     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
342         address owner = _msgSender();
343         uint256 currentAllowance = allowance(owner, spender);
344         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
345         unchecked {
346             _approve(owner, spender, currentAllowance - subtractedValue);
347         }
348 
349         return true;
350     }
351 
352     /**
353      * @dev Moves `amount` of tokens from `from` to `to`.
354      *
355      * This internal function is equivalent to {transfer}, and can be used to
356      * e.g. implement automatic token fees, slashing mechanisms, etc.
357      *
358      * Emits a {Transfer} event.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `from` must have a balance of at least `amount`.
365      */
366     function _transfer(
367         address from,
368         address to,
369         uint256 amount
370     ) internal virtual {
371         require(from != address(0), "ERC20: transfer from the zero address");
372         require(to != address(0), "ERC20: transfer to the zero address");
373 
374         _beforeTokenTransfer(from, to, amount);
375 
376         uint256 fromBalance = _balances[from];
377         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
378         unchecked {
379             _balances[from] = fromBalance - amount;
380         }
381         _balances[to] += amount;
382 
383         emit Transfer(from, to, amount);
384 
385         _afterTokenTransfer(from, to, amount);
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
463      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
464      *
465      * Does not update the allowance amount in case of infinite allowance.
466      * Revert if not enough allowance is available.
467      *
468      * Might emit an {Approval} event.
469      */
470     function _spendAllowance(
471         address owner,
472         address spender,
473         uint256 amount
474     ) internal virtual {
475         uint256 currentAllowance = allowance(owner, spender);
476         if (currentAllowance != type(uint256).max) {
477             require(currentAllowance >= amount, "ERC20: insufficient allowance");
478             unchecked {
479                 _approve(owner, spender, currentAllowance - amount);
480             }
481         }
482     }
483 
484     /**
485      * @dev Hook that is called before any transfer of tokens. This includes
486      * minting and burning.
487      *
488      * Calling conditions:
489      *
490      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
491      * will be transferred to `to`.
492      * - when `from` is zero, `amount` tokens will be minted for `to`.
493      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
494      * - `from` and `to` are never both zero.
495      *
496      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
497      */
498     function _beforeTokenTransfer(
499         address from,
500         address to,
501         uint256 amount
502     ) internal virtual {}
503 
504     /**
505      * @dev Hook that is called after any transfer of tokens. This includes
506      * minting and burning.
507      *
508      * Calling conditions:
509      *
510      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
511      * has been transferred to `to`.
512      * - when `from` is zero, `amount` tokens have been minted for `to`.
513      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
514      * - `from` and `to` are never both zero.
515      *
516      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
517      */
518     function _afterTokenTransfer(
519         address from,
520         address to,
521         uint256 amount
522     ) internal virtual {}
523 }
524 
525 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.3
526 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev Contract module that helps prevent reentrant calls to a function.
532  *
533  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
534  * available, which can be applied to functions to make sure there are no nested
535  * (reentrant) calls to them.
536  *
537  * Note that because there is a single `nonReentrant` guard, functions marked as
538  * `nonReentrant` may not call one another. This can be worked around by making
539  * those functions `private`, and then adding `external` `nonReentrant` entry
540  * points to them.
541  *
542  * TIP: If you would like to learn more about reentrancy and alternative ways
543  * to protect against it, check out our blog post
544  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
545  */
546 abstract contract ReentrancyGuard {
547     // Booleans are more expensive than uint256 or any type that takes up a full
548     // word because each write operation emits an extra SLOAD to first read the
549     // slot's contents, replace the bits taken up by the boolean, and then write
550     // back. This is the compiler's defense against contract upgrades and
551     // pointer aliasing, and it cannot be disabled.
552 
553     // The values being non-zero value makes deployment a bit more expensive,
554     // but in exchange the refund on every call to nonReentrant will be lower in
555     // amount. Since refunds are capped to a percentage of the total
556     // transaction's gas, it is best to keep them low in cases like this one, to
557     // increase the likelihood of the full refund coming into effect.
558     uint256 private constant _NOT_ENTERED = 1;
559     uint256 private constant _ENTERED = 2;
560 
561     uint256 private _status;
562 
563     constructor() {
564         _status = _NOT_ENTERED;
565     }
566 
567     /**
568      * @dev Prevents a contract from calling itself, directly or indirectly.
569      * Calling a `nonReentrant` function from another `nonReentrant`
570      * function is not supported. It is possible to prevent this from happening
571      * by making the `nonReentrant` function external, and making it call a
572      * `private` function that does the actual work.
573      */
574     modifier nonReentrant() {
575         // On the first call to nonReentrant, _notEntered will be true
576         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
577 
578         // Any calls to nonReentrant after this point will fail
579         _status = _ENTERED;
580 
581         _;
582 
583         // By storing the original value once again, a refund is triggered (see
584         // https://eips.ethereum.org/EIPS/eip-2200)
585         _status = _NOT_ENTERED;
586     }
587 }
588 
589 
590 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
591 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
592 
593 pragma solidity ^0.8.1;
594 
595 /**
596  * @dev Collection of functions related to the address type
597  */
598 library Address {
599     /**
600      * @dev Returns true if `account` is a contract.
601      *
602      * [IMPORTANT]
603      * ====
604      * It is unsafe to assume that an address for which this function returns
605      * false is an externally-owned account (EOA) and not a contract.
606      *
607      * Among others, `isContract` will return false for the following
608      * types of addresses:
609      *
610      *  - an externally-owned account
611      *  - a contract in construction
612      *  - an address where a contract will be created
613      *  - an address where a contract lived, but was destroyed
614      * ====
615      *
616      * [IMPORTANT]
617      * ====
618      * You shouldn't rely on `isContract` to protect against flash loan attacks!
619      *
620      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
621      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
622      * constructor.
623      * ====
624      */
625     function isContract(address account) internal view returns (bool) {
626         // This method relies on extcodesize/address.code.length, which returns 0
627         // for contracts in construction, since the code is only stored at the end
628         // of the constructor execution.
629 
630         return account.code.length > 0;
631     }
632 
633     /**
634      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
635      * `recipient`, forwarding all available gas and reverting on errors.
636      *
637      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
638      * of certain opcodes, possibly making contracts go over the 2300 gas limit
639      * imposed by `transfer`, making them unable to receive funds via
640      * `transfer`. {sendValue} removes this limitation.
641      *
642      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
643      *
644      * IMPORTANT: because control is transferred to `recipient`, care must be
645      * taken to not create reentrancy vulnerabilities. Consider using
646      * {ReentrancyGuard} or the
647      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
648      */
649     function sendValue(address payable recipient, uint256 amount) internal {
650         require(address(this).balance >= amount, "Address: insufficient balance");
651 
652         (bool success, ) = recipient.call{value: amount}("");
653         require(success, "Address: unable to send value, recipient may have reverted");
654     }
655 
656     /**
657      * @dev Performs a Solidity function call using a low level `call`. A
658      * plain `call` is an unsafe replacement for a function call: use this
659      * function instead.
660      *
661      * If `target` reverts with a revert reason, it is bubbled up by this
662      * function (like regular Solidity function calls).
663      *
664      * Returns the raw returned data. To convert to the expected return value,
665      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
666      *
667      * Requirements:
668      *
669      * - `target` must be a contract.
670      * - calling `target` with `data` must not revert.
671      *
672      * _Available since v3.1._
673      */
674     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
675         return functionCall(target, data, "Address: low-level call failed");
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
680      * `errorMessage` as a fallback revert reason when `target` reverts.
681      *
682      * _Available since v3.1._
683      */
684     function functionCall(
685         address target,
686         bytes memory data,
687         string memory errorMessage
688     ) internal returns (bytes memory) {
689         return functionCallWithValue(target, data, 0, errorMessage);
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
694      * but also transferring `value` wei to `target`.
695      *
696      * Requirements:
697      *
698      * - the calling contract must have an ETH balance of at least `value`.
699      * - the called Solidity function must be `payable`.
700      *
701      * _Available since v3.1._
702      */
703     function functionCallWithValue(
704         address target,
705         bytes memory data,
706         uint256 value
707     ) internal returns (bytes memory) {
708         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
713      * with `errorMessage` as a fallback revert reason when `target` reverts.
714      *
715      * _Available since v3.1._
716      */
717     function functionCallWithValue(
718         address target,
719         bytes memory data,
720         uint256 value,
721         string memory errorMessage
722     ) internal returns (bytes memory) {
723         require(address(this).balance >= value, "Address: insufficient balance for call");
724         require(isContract(target), "Address: call to non-contract");
725 
726         (bool success, bytes memory returndata) = target.call{value: value}(data);
727         return verifyCallResult(success, returndata, errorMessage);
728     }
729 
730     /**
731      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
732      * but performing a static call.
733      *
734      * _Available since v3.3._
735      */
736     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
737         return functionStaticCall(target, data, "Address: low-level static call failed");
738     }
739 
740     /**
741      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
742      * but performing a static call.
743      *
744      * _Available since v3.3._
745      */
746     function functionStaticCall(
747         address target,
748         bytes memory data,
749         string memory errorMessage
750     ) internal view returns (bytes memory) {
751         require(isContract(target), "Address: static call to non-contract");
752 
753         (bool success, bytes memory returndata) = target.staticcall(data);
754         return verifyCallResult(success, returndata, errorMessage);
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
759      * but performing a delegate call.
760      *
761      * _Available since v3.4._
762      */
763     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
764         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
769      * but performing a delegate call.
770      *
771      * _Available since v3.4._
772      */
773     function functionDelegateCall(
774         address target,
775         bytes memory data,
776         string memory errorMessage
777     ) internal returns (bytes memory) {
778         require(isContract(target), "Address: delegate call to non-contract");
779 
780         (bool success, bytes memory returndata) = target.delegatecall(data);
781         return verifyCallResult(success, returndata, errorMessage);
782     }
783 
784     /**
785      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
786      * revert reason using the provided one.
787      *
788      * _Available since v4.3._
789      */
790     function verifyCallResult(
791         bool success,
792         bytes memory returndata,
793         string memory errorMessage
794     ) internal pure returns (bytes memory) {
795         if (success) {
796             return returndata;
797         } else {
798             // Look for revert reason and bubble it up if present
799             if (returndata.length > 0) {
800                 // The easiest way to bubble the revert reason is using memory via assembly
801                 /// @solidity memory-safe-assembly
802                 assembly {
803                     let returndata_size := mload(returndata)
804                     revert(add(32, returndata), returndata_size)
805                 }
806             } else {
807                 revert(errorMessage);
808             }
809         }
810     }
811 }
812 
813 
814 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
815 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
816 pragma solidity ^0.8.0;
817 
818 /**
819  * @dev Contract module which provides a basic access control mechanism, where
820  * there is an account (an owner) that can be granted exclusive access to
821  * specific functions.
822  *
823  * By default, the owner account will be the one that deploys the contract. This
824  * can later be changed with {transferOwnership}.
825  *
826  * This module is used through inheritance. It will make available the modifier
827  * `onlyOwner`, which can be applied to your functions to restrict their use to
828  * the owner.
829  */
830 abstract contract Ownable is Context {
831     address private _owner;
832 
833     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
834 
835     /**
836      * @dev Initializes the contract setting the deployer as the initial owner.
837      */
838     constructor() {
839         _transferOwnership(_msgSender());
840     }
841 
842     /**
843      * @dev Throws if called by any account other than the owner.
844      */
845     modifier onlyOwner() {
846         _checkOwner();
847         _;
848     }
849 
850     /**
851      * @dev Returns the address of the current owner.
852      */
853     function owner() public view virtual returns (address) {
854         return _owner;
855     }
856 
857     /**
858      * @dev Throws if the sender is not the owner.
859      */
860     function _checkOwner() internal view virtual {
861         require(owner() == _msgSender(), "Ownable: caller is not the owner");
862     }
863 
864     /**
865      * @dev Leaves the contract without owner. It will not be possible to call
866      * `onlyOwner` functions anymore. Can only be called by the current owner.
867      *
868      * NOTE: Renouncing ownership will leave the contract without an owner,
869      * thereby removing any functionality that is only available to the owner.
870      */
871     function renounceOwnership() public virtual onlyOwner {
872         _transferOwnership(address(0));
873     }
874 
875     /**
876      * @dev Transfers ownership of the contract to a new account (`newOwner`).
877      * Can only be called by the current owner.
878      */
879     function transferOwnership(address newOwner) public virtual onlyOwner {
880         require(newOwner != address(0), "Ownable: new owner is the zero address");
881         _transferOwnership(newOwner);
882     }
883 
884     /**
885      * @dev Transfers ownership of the contract to a new account (`newOwner`).
886      * Internal function without access restriction.
887      */
888     function _transferOwnership(address newOwner) internal virtual {
889         address oldOwner = _owner;
890         _owner = newOwner;
891         emit OwnershipTransferred(oldOwner, newOwner);
892     }
893 }
894 
895 // File contracts/EthericeToken.sol
896 pragma solidity 0.8.16;
897 
898 interface BiggestBuyInterface {
899     function checkForWinner() external;
900     function newBuy(uint256 _amount, address _address) external;
901 }
902 
903 contract EthericeToken is ERC20, ReentrancyGuard, Ownable {
904     event UserEnterAuction(
905         address indexed addr,
906         uint256 timestamp,
907         uint256 entryAmountEth,
908         uint256 day
909     );
910     event UserCollectAuctionTokens(
911         address indexed addr,
912         uint256 timestamp,
913         uint256 day,
914         uint256 tokenAmount,
915         uint256 referreeBonus
916     );
917     event RefferrerBonusPaid(
918         address indexed referrerAddress,
919         address indexed reffereeAddress,
920         uint256 timestamp,
921         uint256 referrerBonus,
922         uint256 referreeBonus
923     );
924     event DailyAuctionEnd(
925         uint256 timestamp,
926         uint256 day,
927         uint256 ethTotal,
928         uint256 tokenTotal
929     );
930     event AuctionStarted(
931         uint256 timestamp
932     );
933 
934     uint256 constant public FEE_DENOMINATOR = 1000;
935 
936     /** Taxes */
937     address public dev_addr = 0xCBb49F57A8D21465EA84D27F3BFea21c76760E6f;
938     address public marketing_addr = 0x2EC3524dba30771504fb52F45BECA077eA164deC;
939     address public buyback_addr = 0xdf1111dcD45074e8BC69e53e653bac2560089261;
940     address public rewards_addr = 0xea555834168448b89EEFa16c58034562979587E1;
941     uint256 public dev_percentage = 4;
942     uint256 public marketing_percentage = 1;
943     uint256 public buyback_percentage = 1;
944     uint256 public rewards_percentage = 1;
945     uint256 public biggestBuy_percent = 1;
946 
947     /* last amount of auction pool that are minted daily to be distributed between lobby participants which starts from 3 mil */
948     uint256 public lastAuctionTokens = 3000000 * 1e18;
949 
950     /* Ref bonuses, referrer is the person who refered referre is person who got referred, includes 1 decimal so 25 = 2.5%  */
951     uint256 public referrer_bonus = 50;
952     uint256 public referree_bonus = 10;
953 
954     /* Record the current day of the programme */
955     uint256 public currentDay;
956 
957     /* lobby memebrs data */
958     struct userAuctionEntry {
959         uint256 totalDeposits;
960         uint256 day;
961         bool hasCollected;
962         address referrer;
963     }
964 
965     /* new map for every entry (users are allowed to enter multiple times a day) */
966     mapping(address => mapping(uint256 => userAuctionEntry))
967     public mapUserAuctionEntry;
968 
969     /** Total ETH deposited for the day */
970     mapping(uint256 => uint256) public auctionDeposits;
971 
972     /** Total tokens minted for the day */
973     mapping(uint256 => uint256) public auctionTokens;
974 
975     /** The percent to reduce the total tokens by each day 30 = 3% */
976     uint256 public dailyTokenReductionPercent = 30;
977 
978     // Record the contract launch time & current day
979     uint256 public launchTime;
980 
981     /** External Contracts */
982     BiggestBuyInterface private _biggestBuyContract;
983     address public _stakingContract;
984 
985     address public deployer;
986 
987     constructor() ERC20("Etherice", "ETR") {
988         deployer = msg.sender;
989     }
990 
991     receive() external payable {}
992 
993     /** 
994         @dev is called when we're ready to start the auction
995         @param _biggestBuyAddr address of the lottery contract
996         @param _stakingCa address of the staking contract
997 
998     */
999     function startAuction(address _biggestBuyAddr, address _stakingCa)
1000         external {
1001         require(launchTime == 0, "Launch already started");
1002         require(_biggestBuyAddr != address(0), "Biggest buy address cannot be zero");
1003         require(_stakingCa != address(0), "Staking contract address cannot be zero");
1004         require(msg.sender == deployer, "Only deployer can start the auction");
1005         require(owner() != deployer, "Ownership must be transferred to timelock before you can start auction");
1006 
1007         _mint(deployer, lastAuctionTokens);
1008         launchTime = block.timestamp;
1009         _biggestBuyContract = BiggestBuyInterface(_biggestBuyAddr);
1010         _stakingContract = _stakingCa;
1011         currentDay = calcDay();
1012         emit AuctionStarted(block.timestamp);
1013     }
1014 
1015     /**
1016         @dev update the bonus paid out to affiliates. 20 = 2%
1017         @param _referrer the percent going to the referrer
1018         @param _referree the percentage going to the referee
1019     */
1020     function updateReferrerBonus(uint256 _referrer, uint256 _referree)
1021         external
1022         onlyOwner
1023     {
1024         require((_referrer <= 50 && _referree <= 50), "Over max values");
1025         require((_referrer != 0 && _referree != 0), "Cant be zero");
1026         referrer_bonus = _referrer;
1027         referree_bonus = _referree;
1028     }
1029 
1030     /**
1031         @dev Calculate the current day based off the auction start time 
1032     */
1033     function calcDay() public view returns (uint256) {
1034         if(launchTime == 0) return 0; 
1035         return (block.timestamp - launchTime) / 1 days;
1036     }
1037 
1038     /**
1039         @dev Called daily, can be done manually in etherscan but will be automated with a script
1040         this prevent the first user transaction of the day having to pay all the gas to run this 
1041         function. For security all tokens are kept in the token contract, divs are sent to the 
1042         div contract for div rewards and taxs are sent to the tax contract.
1043     */
1044     function doDailyUpdate() public nonReentrant {
1045         uint256 _nextDay = calcDay();
1046         uint256 _currentDay = currentDay;
1047 
1048         // this is true once a day
1049         if (_currentDay != _nextDay) {
1050             uint256 _taxShare;
1051             uint256 _divsShare;
1052 
1053             if(_nextDay > 1) {
1054                 _taxShare = (address(this).balance * tax()) / 100;
1055                 _divsShare = address(this).balance - _taxShare;
1056                 (bool success, ) = _stakingContract.call{value: _divsShare}(
1057                     abi.encodeWithSignature("receiveDivs()")
1058                 );
1059                 require(success, "Div transfer failed");
1060             }
1061 
1062             if (_taxShare > 0) {
1063                 _flushTaxes(_taxShare);
1064             }
1065 
1066              (bool success2, ) = _stakingContract.call(
1067                     abi.encodeWithSignature("flushDevTaxes()")
1068                 );
1069                 require(success2, "Flush dev taxs failed");
1070 
1071             // Only mint new tokens when we have deposits for that day
1072             if(auctionDeposits[currentDay] > 0){
1073                 _mintDailyAuctionTokens(_currentDay);
1074             }
1075         
1076             if(biggestBuy_percent > 0) {
1077                 _biggestBuyContract.checkForWinner();
1078             }
1079 
1080             emit DailyAuctionEnd(
1081                 block.timestamp,
1082                 currentDay,
1083                 auctionDeposits[currentDay],
1084                 auctionTokens[currentDay]
1085             );
1086 
1087             currentDay = _nextDay;
1088 
1089             delete _nextDay;
1090             delete _currentDay;
1091             delete _taxShare;
1092             delete _divsShare;
1093         }
1094     }
1095 
1096     /**
1097         @dev The total of all the taxs
1098     */
1099     function tax() public view returns (uint256) {
1100         return
1101             biggestBuy_percent +
1102             dev_percentage +
1103             marketing_percentage +
1104             buyback_percentage +
1105             rewards_percentage;
1106     }
1107 
1108     /**
1109         @dev Send all the taxs to the correct wallets
1110         @param _amount total eth to distro
1111     */
1112     function _flushTaxes(uint256 _amount) internal {
1113         uint256 _totalTax = tax();
1114         uint256 _marketingTax = _amount * marketing_percentage / _totalTax;
1115         uint256 _rewardsTax = _amount * rewards_percentage / _totalTax;
1116         uint256 _buybackTax = _amount * buyback_percentage / _totalTax;
1117         uint256 _buyCompTax = (biggestBuy_percent > 0) ?  _amount * biggestBuy_percent / _totalTax : 0;
1118         uint256 _devTax = _amount -
1119             (_marketingTax + _rewardsTax + _buybackTax + _buyCompTax);
1120                 
1121         Address.sendValue(payable(dev_addr), _devTax);
1122         Address.sendValue(payable(marketing_addr), _marketingTax);
1123         Address.sendValue(payable(rewards_addr), _rewardsTax);
1124         Address.sendValue(payable(buyback_addr), _buybackTax);
1125 
1126         if (_buyCompTax > 0) {
1127             Address.sendValue(payable(address(_biggestBuyContract)), _buyCompTax);
1128         }
1129 
1130 
1131         delete _totalTax;
1132         delete _buyCompTax;
1133         delete _marketingTax;
1134         delete _rewardsTax;
1135         delete _buybackTax;
1136         delete _devTax;
1137     }
1138 
1139     /**
1140         @dev UPdate  the taxs, can't be greater than current taxs
1141         @param _dev the dev tax
1142         @param _marketing the marketing tax
1143         @param _buyback the buyback tax
1144         @param _rewards the rewards tax
1145         @param _biggestBuy biggest buy comp tax
1146     */
1147     function updateTaxes(
1148         uint256 _dev,
1149         uint256 _marketing,
1150         uint256 _buyback,
1151         uint256 _rewards,
1152         uint256 _biggestBuy
1153     ) external onlyOwner {
1154         uint256 _newTotal = _dev + _marketing + _buyback + _rewards + _biggestBuy;
1155         require(_newTotal <= 10, "Max tax is 10%");
1156         dev_percentage = _dev;
1157         marketing_percentage = _marketing;
1158         buyback_percentage = _buyback;
1159         rewards_percentage = _rewards;
1160         biggestBuy_percent = _biggestBuy;
1161     }
1162 
1163     /**
1164         @dev Update the marketing wallet address
1165     */
1166     function updateMarketingAddress(address adr) external onlyOwner {
1167         require(adr != address(0), "Can't set to 0 address");
1168         marketing_addr = adr;
1169     }
1170 
1171     /**
1172         @dev Update the dev wallet address
1173     */
1174     function updateDevAddress(address adr) external onlyOwner {
1175         require(adr != address(0), "Can't set to 0 address");
1176         dev_addr = adr;
1177     }
1178 
1179     /**
1180         @dev update the buyback wallet address
1181     */
1182     function updateBuybackAddress(address adr) external onlyOwner {
1183         require(adr != address(0), "Can't set to 0 address");
1184         buyback_addr = adr;
1185     }
1186 
1187     /**
1188         @dev update the rewards wallet address
1189     */
1190     function updateRewardsAddress(address adr) external onlyOwner {
1191         require(adr != address(0), "Can't set to 0 address");
1192         rewards_addr = adr;
1193     }
1194 
1195     /**
1196         @dev Mint the auction tokens for the day 
1197         @param _day the day to mint the tokens for
1198     */
1199     function _mintDailyAuctionTokens(uint256 _day) internal {
1200         uint256 _nextAuctionTokens = todayAuctionTokens(); // decrease by 3%
1201 
1202         // Mint the tokens for the day so they're ready for the users to withdraw when they remove stakes.
1203         // This saves gas for the users as we cover the mint costs on our end and the user can do a cheaper
1204         // transfer function
1205         _mint(address(this), _nextAuctionTokens);
1206 
1207         auctionTokens[_day] = _nextAuctionTokens;
1208         lastAuctionTokens = _nextAuctionTokens;
1209 
1210         delete _nextAuctionTokens;
1211     }
1212 
1213     function todayAuctionTokens() public view returns (uint256){
1214         return lastAuctionTokens -
1215             ((lastAuctionTokens * dailyTokenReductionPercent) / FEE_DENOMINATOR); 
1216     }
1217 
1218     /**
1219      * @dev entering the auction lobby for the current day
1220      * @param referrerAddr address of referring user (optional; 0x0 for no referrer)
1221      */
1222     function enterAuction(address referrerAddr) external payable {
1223         require((launchTime > 0), "Project not launched");
1224         require( msg.value > 0, "msg value is 0 ");
1225         doDailyUpdate();
1226 
1227         uint256 _currentDay = currentDay;
1228         _biggestBuyContract.newBuy(msg.value, msg.sender);
1229 
1230         auctionDeposits[_currentDay] += msg.value;
1231 
1232         mapUserAuctionEntry[msg.sender][_currentDay] = userAuctionEntry({
1233             totalDeposits: mapUserAuctionEntry[msg.sender][_currentDay]
1234                 .totalDeposits + msg.value,
1235             day: _currentDay,
1236             hasCollected: false,
1237             referrer: (referrerAddr != msg.sender) ? referrerAddr : address(0)
1238         });
1239 
1240         emit UserEnterAuction(msg.sender, block.timestamp, msg.value, _currentDay );
1241      
1242         if (_currentDay == 0) {
1243             // Move this staight out on day 0 so we have
1244             // the marketing funds availabe instantly
1245             // to promote the project
1246             Address.sendValue(payable(dev_addr), msg.value);
1247         }
1248 
1249         delete _currentDay;
1250     }
1251 
1252     /**
1253      * @dev External function for leaving the lobby / collecting the tokens
1254      * @param targetDay Target day of lobby to collect
1255      */
1256     function collectAuctionTokens(uint256 targetDay) external nonReentrant {
1257         require(
1258             mapUserAuctionEntry[msg.sender][targetDay].hasCollected == false,
1259             "Tokens already collected for day"
1260         );
1261         require(targetDay < currentDay, "cant collect tokens for current active day");
1262 
1263         uint256 _tokensToPay = calcTokenValue(msg.sender, targetDay);
1264 
1265         mapUserAuctionEntry[msg.sender][targetDay].hasCollected = true;
1266         _transfer(address(this), msg.sender, _tokensToPay);
1267 
1268         address _referrerAddress = mapUserAuctionEntry[msg.sender][targetDay]
1269             .referrer;
1270         uint256 _referreeBonus;
1271 
1272         if (_referrerAddress != address(0)) {
1273             /* there is a referrer, pay their % ref bonus of tokens */
1274             uint256 _reffererBonus = (_tokensToPay * referrer_bonus) / FEE_DENOMINATOR;
1275             _referreeBonus = (_tokensToPay * referree_bonus) / FEE_DENOMINATOR;
1276 
1277             _mint(_referrerAddress, _reffererBonus);
1278             _mint(msg.sender, _referreeBonus);
1279 
1280             emit RefferrerBonusPaid(
1281                 _referrerAddress,
1282                 msg.sender,
1283                 block.timestamp,
1284                 _reffererBonus,
1285                 _referreeBonus
1286             );
1287 
1288             delete _referrerAddress;
1289             delete _reffererBonus;
1290         }
1291 
1292         emit UserCollectAuctionTokens(
1293             msg.sender,
1294             block.timestamp,
1295             targetDay,
1296             _tokensToPay,
1297             _referreeBonus
1298         );
1299 
1300         delete _referreeBonus;
1301     }
1302 
1303     /**
1304      * @dev Calculating user's share from lobby based on their & of deposits for the day
1305      * @param _Day The lobby day
1306      */
1307     function calcTokenValue(address _address, uint256 _Day)
1308         public
1309         view
1310         returns (uint256)
1311     {
1312         require(_Day < calcDay(), "day must have ended");
1313         uint256 _tokenValue;
1314         uint256 _entryDay = mapUserAuctionEntry[_address][_Day].day;
1315 
1316         if(auctionTokens[_entryDay] == 0){
1317             // No token minted for that day ( this happens when no deposits for the day)
1318             return 0;
1319         }
1320 
1321         if (_entryDay < currentDay) {
1322             _tokenValue =
1323                 (auctionTokens[_entryDay] *
1324                     mapUserAuctionEntry[_address][_Day].totalDeposits) / auctionDeposits[_entryDay];
1325         } else {
1326             _tokenValue = 0;
1327         }
1328 
1329         return _tokenValue;
1330     }
1331 
1332     /**
1333         @dev change the % reduction of the daily tokens minted
1334         @param _newPercent the new percent val 3% = 30
1335     */
1336     function updateDailyReductionPercent(uint256 _newPercent) external onlyOwner {
1337         // must be >= 1% and <= 6%
1338         require((_newPercent >= 10 && _newPercent <= 60));
1339         dailyTokenReductionPercent = _newPercent;
1340     }
1341 }