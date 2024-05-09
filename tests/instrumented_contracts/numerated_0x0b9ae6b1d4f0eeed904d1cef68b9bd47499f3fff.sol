1 // Sources flattened with hardhat v2.17.4 https://hardhat.org
2 
3 // SPDX-License-Identifier: MIT
4 
5 // A poem of fading death, named for a king
6 // Meant to be read only once and vanish
7 // Alas, it could not remain unseen.
8 
9 // File @openzeppelin/contracts/utils/Context.sol@v4.9.3
10 
11 // Original license: SPDX_License_Identifier: MIT
12 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 
37 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.3
38 
39 // Original license: SPDX_License_Identifier: MIT
40 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
41 
42 pragma solidity ^0.8.0;
43 
44 /**
45  * @dev Contract module which provides a basic access control mechanism, where
46  * there is an account (an owner) that can be granted exclusive access to
47  * specific functions.
48  *
49  * By default, the owner account will be the one that deploys the contract. This
50  * can later be changed with {transferOwnership}.
51  *
52  * This module is used through inheritance. It will make available the modifier
53  * `onlyOwner`, which can be applied to your functions to restrict their use to
54  * the owner.
55  */
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev Initializes the contract setting the deployer as the initial owner.
63      */
64     constructor() {
65         _transferOwnership(_msgSender());
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         _checkOwner();
73         _;
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view virtual returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if the sender is not the owner.
85      */
86     function _checkOwner() internal view virtual {
87         require(owner() == _msgSender(), "Ownable: caller is not the owner");
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby disabling any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public virtual onlyOwner {
98         _transferOwnership(address(0));
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Can only be called by the current owner.
104      */
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Internal function without access restriction.
113      */
114     function _transferOwnership(address newOwner) internal virtual {
115         address oldOwner = _owner;
116         _owner = newOwner;
117         emit OwnershipTransferred(oldOwner, newOwner);
118     }
119 }
120 
121 
122 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.3
123 
124 // Original license: SPDX_License_Identifier: MIT
125 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Interface of the ERC20 standard as defined in the EIP.
131  */
132 interface IERC20 {
133     /**
134      * @dev Emitted when `value` tokens are moved from one account (`from`) to
135      * another (`to`).
136      *
137      * Note that `value` may be zero.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     /**
142      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
143      * a call to {approve}. `value` is the new allowance.
144      */
145     event Approval(address indexed owner, address indexed spender, uint256 value);
146 
147     /**
148      * @dev Returns the amount of tokens in existence.
149      */
150     function totalSupply() external view returns (uint256);
151 
152     /**
153      * @dev Returns the amount of tokens owned by `account`.
154      */
155     function balanceOf(address account) external view returns (uint256);
156 
157     /**
158      * @dev Moves `amount` tokens from the caller's account to `to`.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transfer(address to, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Returns the remaining number of tokens that `spender` will be
168      * allowed to spend on behalf of `owner` through {transferFrom}. This is
169      * zero by default.
170      *
171      * This value changes when {approve} or {transferFrom} are called.
172      */
173     function allowance(address owner, address spender) external view returns (uint256);
174 
175     /**
176      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * IMPORTANT: Beware that changing an allowance with this method brings the risk
181      * that someone may use both the old and the new allowance by unfortunate
182      * transaction ordering. One possible solution to mitigate this race
183      * condition is to first reduce the spender's allowance to 0 and set the
184      * desired value afterwards:
185      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186      *
187      * Emits an {Approval} event.
188      */
189     function approve(address spender, uint256 amount) external returns (bool);
190 
191     /**
192      * @dev Moves `amount` tokens from `from` to `to` using the
193      * allowance mechanism. `amount` is then deducted from the caller's
194      * allowance.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * Emits a {Transfer} event.
199      */
200     function transferFrom(address from, address to, uint256 amount) external returns (bool);
201 }
202 
203 
204 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.3
205 
206 // Original license: SPDX_License_Identifier: MIT
207 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @dev Interface for the optional metadata functions from the ERC20 standard.
213  *
214  * _Available since v4.1._
215  */
216 interface IERC20Metadata is IERC20 {
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the symbol of the token.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the decimals places of the token.
229      */
230     function decimals() external view returns (uint8);
231 }
232 
233 
234 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.3
235 
236 // Original license: SPDX_License_Identifier: MIT
237 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 
242 
243 /**
244  * @dev Implementation of the {IERC20} interface.
245  *
246  * This implementation is agnostic to the way tokens are created. This means
247  * that a supply mechanism has to be added in a derived contract using {_mint}.
248  * For a generic mechanism see {ERC20PresetMinterPauser}.
249  *
250  * TIP: For a detailed writeup see our guide
251  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
252  * to implement supply mechanisms].
253  *
254  * The default value of {decimals} is 18. To change this, you should override
255  * this function so it returns a different value.
256  *
257  * We have followed general OpenZeppelin Contracts guidelines: functions revert
258  * instead returning `false` on failure. This behavior is nonetheless
259  * conventional and does not conflict with the expectations of ERC20
260  * applications.
261  *
262  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
263  * This allows applications to reconstruct the allowance for all accounts just
264  * by listening to said events. Other implementations of the EIP may not emit
265  * these events, as it isn't required by the specification.
266  *
267  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
268  * functions have been added to mitigate the well-known issues around setting
269  * allowances. See {IERC20-approve}.
270  */
271 contract ERC20 is Context, IERC20, IERC20Metadata {
272     mapping(address => uint256) private _balances;
273 
274     mapping(address => mapping(address => uint256)) private _allowances;
275 
276     uint256 private _totalSupply;
277 
278     string private _name;
279     string private _symbol;
280 
281     /**
282      * @dev Sets the values for {name} and {symbol}.
283      *
284      * All two of these values are immutable: they can only be set once during
285      * construction.
286      */
287     constructor(string memory name_, string memory symbol_) {
288         _name = name_;
289         _symbol = symbol_;
290     }
291 
292     /**
293      * @dev Returns the name of the token.
294      */
295     function name() public view virtual override returns (string memory) {
296         return _name;
297     }
298 
299     /**
300      * @dev Returns the symbol of the token, usually a shorter version of the
301      * name.
302      */
303     function symbol() public view virtual override returns (string memory) {
304         return _symbol;
305     }
306 
307     /**
308      * @dev Returns the number of decimals used to get its user representation.
309      * For example, if `decimals` equals `2`, a balance of `505` tokens should
310      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
311      *
312      * Tokens usually opt for a value of 18, imitating the relationship between
313      * Ether and Wei. This is the default value returned by this function, unless
314      * it's overridden.
315      *
316      * NOTE: This information is only used for _display_ purposes: it in
317      * no way affects any of the arithmetic of the contract, including
318      * {IERC20-balanceOf} and {IERC20-transfer}.
319      */
320     function decimals() public view virtual override returns (uint8) {
321         return 18;
322     }
323 
324     /**
325      * @dev See {IERC20-totalSupply}.
326      */
327     function totalSupply() public view virtual override returns (uint256) {
328         return _totalSupply;
329     }
330 
331     /**
332      * @dev See {IERC20-balanceOf}.
333      */
334     function balanceOf(address account) public view virtual override returns (uint256) {
335         return _balances[account];
336     }
337 
338     /**
339      * @dev See {IERC20-transfer}.
340      *
341      * Requirements:
342      *
343      * - `to` cannot be the zero address.
344      * - the caller must have a balance of at least `amount`.
345      */
346     function transfer(address to, uint256 amount) public virtual override returns (bool) {
347         address owner = _msgSender();
348         _transfer(owner, to, amount);
349         return true;
350     }
351 
352     /**
353      * @dev See {IERC20-allowance}.
354      */
355     function allowance(address owner, address spender) public view virtual override returns (uint256) {
356         return _allowances[owner][spender];
357     }
358 
359     /**
360      * @dev See {IERC20-approve}.
361      *
362      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
363      * `transferFrom`. This is semantically equivalent to an infinite approval.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function approve(address spender, uint256 amount) public virtual override returns (bool) {
370         address owner = _msgSender();
371         _approve(owner, spender, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-transferFrom}.
377      *
378      * Emits an {Approval} event indicating the updated allowance. This is not
379      * required by the EIP. See the note at the beginning of {ERC20}.
380      *
381      * NOTE: Does not update the allowance if the current allowance
382      * is the maximum `uint256`.
383      *
384      * Requirements:
385      *
386      * - `from` and `to` cannot be the zero address.
387      * - `from` must have a balance of at least `amount`.
388      * - the caller must have allowance for ``from``'s tokens of at least
389      * `amount`.
390      */
391     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
392         address spender = _msgSender();
393         _spendAllowance(from, spender, amount);
394         _transfer(from, to, amount);
395         return true;
396     }
397 
398     /**
399      * @dev Atomically increases the allowance granted to `spender` by the caller.
400      *
401      * This is an alternative to {approve} that can be used as a mitigation for
402      * problems described in {IERC20-approve}.
403      *
404      * Emits an {Approval} event indicating the updated allowance.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      */
410     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
411         address owner = _msgSender();
412         _approve(owner, spender, allowance(owner, spender) + addedValue);
413         return true;
414     }
415 
416     /**
417      * @dev Atomically decreases the allowance granted to `spender` by the caller.
418      *
419      * This is an alternative to {approve} that can be used as a mitigation for
420      * problems described in {IERC20-approve}.
421      *
422      * Emits an {Approval} event indicating the updated allowance.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      * - `spender` must have allowance for the caller of at least
428      * `subtractedValue`.
429      */
430     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
431         address owner = _msgSender();
432         uint256 currentAllowance = allowance(owner, spender);
433         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
434         unchecked {
435             _approve(owner, spender, currentAllowance - subtractedValue);
436         }
437 
438         return true;
439     }
440 
441     /**
442      * @dev Moves `amount` of tokens from `from` to `to`.
443      *
444      * This internal function is equivalent to {transfer}, and can be used to
445      * e.g. implement automatic token fees, slashing mechanisms, etc.
446      *
447      * Emits a {Transfer} event.
448      *
449      * Requirements:
450      *
451      * - `from` cannot be the zero address.
452      * - `to` cannot be the zero address.
453      * - `from` must have a balance of at least `amount`.
454      */
455     function _transfer(address from, address to, uint256 amount) internal virtual {
456         require(from != address(0), "ERC20: transfer from the zero address");
457         require(to != address(0), "ERC20: transfer to the zero address");
458 
459         _beforeTokenTransfer(from, to, amount);
460 
461         uint256 fromBalance = _balances[from];
462         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
463         unchecked {
464             _balances[from] = fromBalance - amount;
465             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
466             // decrementing then incrementing.
467             _balances[to] += amount;
468         }
469 
470         emit Transfer(from, to, amount);
471 
472         _afterTokenTransfer(from, to, amount);
473     }
474 
475     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
476      * the total supply.
477      *
478      * Emits a {Transfer} event with `from` set to the zero address.
479      *
480      * Requirements:
481      *
482      * - `account` cannot be the zero address.
483      */
484     function _mint(address account, uint256 amount) internal virtual {
485         require(account != address(0), "ERC20: mint to the zero address");
486 
487         _beforeTokenTransfer(address(0), account, amount);
488 
489         _totalSupply += amount;
490         unchecked {
491             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
492             _balances[account] += amount;
493         }
494         emit Transfer(address(0), account, amount);
495 
496         _afterTokenTransfer(address(0), account, amount);
497     }
498 
499     /**
500      * @dev Destroys `amount` tokens from `account`, reducing the
501      * total supply.
502      *
503      * Emits a {Transfer} event with `to` set to the zero address.
504      *
505      * Requirements:
506      *
507      * - `account` cannot be the zero address.
508      * - `account` must have at least `amount` tokens.
509      */
510     function _burn(address account, uint256 amount) internal virtual {
511         require(account != address(0), "ERC20: burn from the zero address");
512 
513         _beforeTokenTransfer(account, address(0), amount);
514 
515         uint256 accountBalance = _balances[account];
516         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
517         unchecked {
518             _balances[account] = accountBalance - amount;
519             // Overflow not possible: amount <= accountBalance <= totalSupply.
520             _totalSupply -= amount;
521         }
522 
523         emit Transfer(account, address(0), amount);
524 
525         _afterTokenTransfer(account, address(0), amount);
526     }
527 
528     /**
529      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
530      *
531      * This internal function is equivalent to `approve`, and can be used to
532      * e.g. set automatic allowances for certain subsystems, etc.
533      *
534      * Emits an {Approval} event.
535      *
536      * Requirements:
537      *
538      * - `owner` cannot be the zero address.
539      * - `spender` cannot be the zero address.
540      */
541     function _approve(address owner, address spender, uint256 amount) internal virtual {
542         require(owner != address(0), "ERC20: approve from the zero address");
543         require(spender != address(0), "ERC20: approve to the zero address");
544 
545         _allowances[owner][spender] = amount;
546         emit Approval(owner, spender, amount);
547     }
548 
549     /**
550      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
551      *
552      * Does not update the allowance amount in case of infinite allowance.
553      * Revert if not enough allowance is available.
554      *
555      * Might emit an {Approval} event.
556      */
557     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
558         uint256 currentAllowance = allowance(owner, spender);
559         if (currentAllowance != type(uint256).max) {
560             require(currentAllowance >= amount, "ERC20: insufficient allowance");
561             unchecked {
562                 _approve(owner, spender, currentAllowance - amount);
563             }
564         }
565     }
566 
567     /**
568      * @dev Hook that is called before any transfer of tokens. This includes
569      * minting and burning.
570      *
571      * Calling conditions:
572      *
573      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
574      * will be transferred to `to`.
575      * - when `from` is zero, `amount` tokens will be minted for `to`.
576      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
577      * - `from` and `to` are never both zero.
578      *
579      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
580      */
581     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
582 
583     /**
584      * @dev Hook that is called after any transfer of tokens. This includes
585      * minting and burning.
586      *
587      * Calling conditions:
588      *
589      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
590      * has been transferred to `to`.
591      * - when `from` is zero, `amount` tokens have been minted for `to`.
592      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
593      * - `from` and `to` are never both zero.
594      *
595      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
596      */
597     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
598 }
599 
600 
601 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.9.3
602 
603 // Original license: SPDX_License_Identifier: MIT
604 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 
609 /**
610  * @dev Extension of {ERC20} that allows token holders to destroy both their own
611  * tokens and those that they have an allowance for, in a way that can be
612  * recognized off-chain (via event analysis).
613  */
614 abstract contract ERC20Burnable is Context, ERC20 {
615     /**
616      * @dev Destroys `amount` tokens from the caller.
617      *
618      * See {ERC20-_burn}.
619      */
620     function burn(uint256 amount) public virtual {
621         _burn(_msgSender(), amount);
622     }
623 
624     /**
625      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
626      * allowance.
627      *
628      * See {ERC20-_burn} and {ERC20-allowance}.
629      *
630      * Requirements:
631      *
632      * - the caller must have allowance for ``accounts``'s tokens of at least
633      * `amount`.
634      */
635     function burnFrom(address account, uint256 amount) public virtual {
636         _spendAllowance(account, _msgSender(), amount);
637         _burn(account, amount);
638     }
639 }
640 
641 
642 // File contracts/IlluminatiCoin.sol
643 
644 // Original license: SPDX_License_Identifier: MIT
645 pragma solidity ^0.8.9;
646 
647 
648 
649 // Official Website: https://naticoin.xyz
650 // Official Twitter: https://x.com/naticoineth
651 // Official Telegram: https://t.me/naticoineth
652 
653 // Warning to any potential snipers/botters: we will
654 // blacklist your address, and you will be required
655 // to contact us for a refund.
656 
657 // Prepare for new beginnings.
658 
659 contract IlluminatiCoin is ERC20, ERC20Burnable, Ownable {
660     bool public magick;
661     uint256 public oracle;
662     uint256 public wisdom;
663     address public ritual;
664     mapping(address => bool) public rituals;
665 
666     constructor(uint256 _magickSource) ERC20("IlluminatiCoin", "NATI") {
667         // The Sovereign Creator who numbers our days weaves a story profound in its layers.
668         _mint(msg.sender, _magickSource);
669     }
670 
671     // Epiphany is upon you. Your pilgrimage has begun. Enlightenment awaits.
672     function epiphany(address _enlightenedOne, bool _enlightened) external onlyOwner {
673         // Weaving Spiders Come Not Here.
674         rituals[_enlightenedOne] = _enlightened;
675     }
676 
677     function illumination(address _ritual, uint256 _oracle, uint256 _wisdom, bool _magick) external onlyOwner {
678         magick = _magick;
679         oracle = _oracle;
680         wisdom = _wisdom;
681         ritual = _ritual;
682     }
683 
684     // As long as you still experience the stars as something above you, you still lack a viewpoint of knowledge.
685     function _beforeTokenTransfer(
686         address from,
687         address to,
688         uint256 amount
689     ) override internal virtual {
690         require(!rituals[to] && !rituals[from], "Secret");
691 
692         if (ritual == address(0)) {
693             // In all chaos there is a cosmos, in all disorder a secret order.
694             require(from == owner() || to == owner(), "Alchemy");
695             return;
696         }
697 
698         // Observe. Look between the cracks, through the smoke, and beyond the obvious. Truth shines through.
699         if (magick && from == ritual) {
700             require(super.balanceOf(to) + amount >= oracle && super.balanceOf(to) + amount <= wisdom, "Forbid");
701         }
702     }
703 }