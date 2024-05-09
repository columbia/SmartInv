1 // Sources flattened with hardhat v2.14.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.3
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
89 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.3
90 
91 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 
116 // File @openzeppelin/contracts/utils/Context.sol@v4.8.3
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
119 
120 
121 /**
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140 
141 
142 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.3
143 
144 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
145 
146 
147 /**
148  * @dev Implementation of the {IERC20} interface.
149  *
150  * This implementation is agnostic to the way tokens are created. This means
151  * that a supply mechanism has to be added in a derived contract using {_mint}.
152  * For a generic mechanism see {ERC20PresetMinterPauser}.
153  *
154  * TIP: For a detailed writeup see our guide
155  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
156  * to implement supply mechanisms].
157  *
158  * We have followed general OpenZeppelin Contracts guidelines: functions revert
159  * instead returning `false` on failure. This behavior is nonetheless
160  * conventional and does not conflict with the expectations of ERC20
161  * applications.
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
173     mapping(address => uint256) private _balances;
174 
175     mapping(address => mapping(address => uint256)) private _allowances;
176 
177     uint256 private _totalSupply;
178 
179     string private _name;
180     string private _symbol;
181 
182     /**
183      * @dev Sets the values for {name} and {symbol}.
184      *
185      * The default value of {decimals} is 18. To select a different value for
186      * {decimals} you should overload it.
187      *
188      * All two of these values are immutable: they can only be set once during
189      * construction.
190      */
191     constructor(string memory name_, string memory symbol_) {
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
214      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
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
247      * - `to` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address to, uint256 amount) public virtual override returns (bool) {
251         address owner = _msgSender();
252         _transfer(owner, to, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See {IERC20-allowance}.
258      */
259     function allowance(address owner, address spender) public view virtual override returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     /**
264      * @dev See {IERC20-approve}.
265      *
266      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
267      * `transferFrom`. This is semantically equivalent to an infinite approval.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 amount) public virtual override returns (bool) {
274         address owner = _msgSender();
275         _approve(owner, spender, amount);
276         return true;
277     }
278 
279     /**
280      * @dev See {IERC20-transferFrom}.
281      *
282      * Emits an {Approval} event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of {ERC20}.
284      *
285      * NOTE: Does not update the allowance if the current allowance
286      * is the maximum `uint256`.
287      *
288      * Requirements:
289      *
290      * - `from` and `to` cannot be the zero address.
291      * - `from` must have a balance of at least `amount`.
292      * - the caller must have allowance for ``from``'s tokens of at least
293      * `amount`.
294      */
295     function transferFrom(
296         address from,
297         address to,
298         uint256 amount
299     ) public virtual override returns (bool) {
300         address spender = _msgSender();
301         _spendAllowance(from, spender, amount);
302         _transfer(from, to, amount);
303         return true;
304     }
305 
306     /**
307      * @dev Atomically increases the allowance granted to `spender` by the caller.
308      *
309      * This is an alternative to {approve} that can be used as a mitigation for
310      * problems described in {IERC20-approve}.
311      *
312      * Emits an {Approval} event indicating the updated allowance.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      */
318     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
319         address owner = _msgSender();
320         _approve(owner, spender, allowance(owner, spender) + addedValue);
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
339         address owner = _msgSender();
340         uint256 currentAllowance = allowance(owner, spender);
341         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
342         unchecked {
343             _approve(owner, spender, currentAllowance - subtractedValue);
344         }
345 
346         return true;
347     }
348 
349     /**
350      * @dev Moves `amount` of tokens from `from` to `to`.
351      *
352      * This internal function is equivalent to {transfer}, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a {Transfer} event.
356      *
357      * Requirements:
358      *
359      * - `from` cannot be the zero address.
360      * - `to` cannot be the zero address.
361      * - `from` must have a balance of at least `amount`.
362      */
363     function _transfer(
364         address from,
365         address to,
366         uint256 amount
367     ) internal virtual {
368         require(from != address(0), "ERC20: transfer from the zero address");
369         require(to != address(0), "ERC20: transfer to the zero address");
370 
371         _beforeTokenTransfer(from, to, amount);
372 
373         uint256 fromBalance = _balances[from];
374         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
375         unchecked {
376             _balances[from] = fromBalance - amount;
377             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
378             // decrementing then incrementing.
379             _balances[to] += amount;
380         }
381 
382         emit Transfer(from, to, amount);
383 
384         _afterTokenTransfer(from, to, amount);
385     }
386 
387     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
388      * the total supply.
389      *
390      * Emits a {Transfer} event with `from` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      */
396     function _mint(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: mint to the zero address");
398 
399         _beforeTokenTransfer(address(0), account, amount);
400 
401         _totalSupply += amount;
402         unchecked {
403             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
404             _balances[account] += amount;
405         }
406         emit Transfer(address(0), account, amount);
407 
408         _afterTokenTransfer(address(0), account, amount);
409     }
410 
411     /**
412      * @dev Destroys `amount` tokens from `account`, reducing the
413      * total supply.
414      *
415      * Emits a {Transfer} event with `to` set to the zero address.
416      *
417      * Requirements:
418      *
419      * - `account` cannot be the zero address.
420      * - `account` must have at least `amount` tokens.
421      */
422     function _burn(address account, uint256 amount) internal virtual {
423         require(account != address(0), "ERC20: burn from the zero address");
424 
425         _beforeTokenTransfer(account, address(0), amount);
426 
427         uint256 accountBalance = _balances[account];
428         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
429         unchecked {
430             _balances[account] = accountBalance - amount;
431             // Overflow not possible: amount <= accountBalance <= totalSupply.
432             _totalSupply -= amount;
433         }
434 
435         emit Transfer(account, address(0), amount);
436 
437         _afterTokenTransfer(account, address(0), amount);
438     }
439 
440     /**
441      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
442      *
443      * This internal function is equivalent to `approve`, and can be used to
444      * e.g. set automatic allowances for certain subsystems, etc.
445      *
446      * Emits an {Approval} event.
447      *
448      * Requirements:
449      *
450      * - `owner` cannot be the zero address.
451      * - `spender` cannot be the zero address.
452      */
453     function _approve(
454         address owner,
455         address spender,
456         uint256 amount
457     ) internal virtual {
458         require(owner != address(0), "ERC20: approve from the zero address");
459         require(spender != address(0), "ERC20: approve to the zero address");
460 
461         _allowances[owner][spender] = amount;
462         emit Approval(owner, spender, amount);
463     }
464 
465     /**
466      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
467      *
468      * Does not update the allowance amount in case of infinite allowance.
469      * Revert if not enough allowance is available.
470      *
471      * Might emit an {Approval} event.
472      */
473     function _spendAllowance(
474         address owner,
475         address spender,
476         uint256 amount
477     ) internal virtual {
478         uint256 currentAllowance = allowance(owner, spender);
479         if (currentAllowance != type(uint256).max) {
480             require(currentAllowance >= amount, "ERC20: insufficient allowance");
481             unchecked {
482                 _approve(owner, spender, currentAllowance - amount);
483             }
484         }
485     }
486 
487     /**
488      * @dev Hook that is called before any transfer of tokens. This includes
489      * minting and burning.
490      *
491      * Calling conditions:
492      *
493      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
494      * will be transferred to `to`.
495      * - when `from` is zero, `amount` tokens will be minted for `to`.
496      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
497      * - `from` and `to` are never both zero.
498      *
499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
500      */
501     function _beforeTokenTransfer(
502         address from,
503         address to,
504         uint256 amount
505     ) internal virtual {}
506 
507     /**
508      * @dev Hook that is called after any transfer of tokens. This includes
509      * minting and burning.
510      *
511      * Calling conditions:
512      *
513      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
514      * has been transferred to `to`.
515      * - when `from` is zero, `amount` tokens have been minted for `to`.
516      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
517      * - `from` and `to` are never both zero.
518      *
519      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
520      */
521     function _afterTokenTransfer(
522         address from,
523         address to,
524         uint256 amount
525     ) internal virtual {}
526 }
527 
528 
529 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.3
530 
531 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
532 
533 /**
534  * @dev Contract module that helps prevent reentrant calls to a function.
535  *
536  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
537  * available, which can be applied to functions to make sure there are no nested
538  * (reentrant) calls to them.
539  *
540  * Note that because there is a single `nonReentrant` guard, functions marked as
541  * `nonReentrant` may not call one another. This can be worked around by making
542  * those functions `private`, and then adding `external` `nonReentrant` entry
543  * points to them.
544  *
545  * TIP: If you would like to learn more about reentrancy and alternative ways
546  * to protect against it, check out our blog post
547  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
548  */
549 abstract contract ReentrancyGuard {
550     // Booleans are more expensive than uint256 or any type that takes up a full
551     // word because each write operation emits an extra SLOAD to first read the
552     // slot's contents, replace the bits taken up by the boolean, and then write
553     // back. This is the compiler's defense against contract upgrades and
554     // pointer aliasing, and it cannot be disabled.
555 
556     // The values being non-zero value makes deployment a bit more expensive,
557     // but in exchange the refund on every call to nonReentrant will be lower in
558     // amount. Since refunds are capped to a percentage of the total
559     // transaction's gas, it is best to keep them low in cases like this one, to
560     // increase the likelihood of the full refund coming into effect.
561     uint256 private constant _NOT_ENTERED = 1;
562     uint256 private constant _ENTERED = 2;
563 
564     uint256 private _status;
565 
566     constructor() {
567         _status = _NOT_ENTERED;
568     }
569 
570     /**
571      * @dev Prevents a contract from calling itself, directly or indirectly.
572      * Calling a `nonReentrant` function from another `nonReentrant`
573      * function is not supported. It is possible to prevent this from happening
574      * by making the `nonReentrant` function external, and making it call a
575      * `private` function that does the actual work.
576      */
577     modifier nonReentrant() {
578         _nonReentrantBefore();
579         _;
580         _nonReentrantAfter();
581     }
582 
583     function _nonReentrantBefore() private {
584         // On the first call to nonReentrant, _status will be _NOT_ENTERED
585         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
586 
587         // Any calls to nonReentrant after this point will fail
588         _status = _ENTERED;
589     }
590 
591     function _nonReentrantAfter() private {
592         // By storing the original value once again, a refund is triggered (see
593         // https://eips.ethereum.org/EIPS/eip-2200)
594         _status = _NOT_ENTERED;
595     }
596 }
597 
598 
599 // File contracts/KYLSwap.sol
600 
601 // contracts/KYLToken.sol
602 
603 
604 contract KYLTokenSwap is Context, ReentrancyGuard {
605 
606     event Swap_KYL(address indexed addr, uint256 amount);
607 
608     address kylV1; 
609     address kylV2;
610     address kylV2Treasure;
611     address kylV1Treasure;
612 
613     constructor(address _kylV1, address _kylV2, address _kylV1Treasure, address _kylV2Treasure) {
614         kylV1 = _kylV1;
615         kylV2 = _kylV2;
616         kylV1Treasure = _kylV1Treasure;
617         kylV2Treasure = _kylV2Treasure;
618     }
619 
620     function Swap_KYLV1_to_KYLV2(uint256 amount) public nonReentrant {
621         address sender = _msgSender();
622 
623         // Lock KYLv1
624         ERC20(kylV1).transferFrom(sender, kylV1Treasure, amount);
625 
626         // Send same amount KYLv2
627         ERC20(kylV2).transferFrom(kylV2Treasure, sender, amount);
628 
629         emit Swap_KYL(sender, amount);
630     }
631 }