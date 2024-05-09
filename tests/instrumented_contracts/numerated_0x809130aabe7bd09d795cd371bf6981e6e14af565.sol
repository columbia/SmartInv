1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
4 
5 /*
6 James $Bond
7 "Licensed to Thrill the Crypto World"
8 
9 
10 Website:
11 https://jamesbond.vip
12 
13 Staking dApp:
14 https://staking.jamesbond.vip
15 
16 Telegram:
17 http://t.me/JamesBondERC20
18 
19 Twitter:
20 https://twitter.com/jamesbonderc20
21 **/
22 
23 
24 
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes calldata) {
44         return msg.data;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/access/Ownable.sol
49 
50 
51 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 
56 /**
57  * @dev Contract module which provides a basic access control mechanism, where
58  * there is an account (an owner) that can be granted exclusive access to
59  * specific functions.
60  *
61  * By default, the owner account will be the one that deploys the contract. This
62  * can later be changed with {transferOwnership}.
63  *
64  * This module is used through inheritance. It will make available the modifier
65  * `onlyOwner`, which can be applied to your functions to restrict their use to
66  * the owner.
67  */
68 abstract contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     /**
74      * @dev Initializes the contract setting the deployer as the initial owner.
75      */
76     constructor() {
77         _transferOwnership(_msgSender());
78     }
79 
80     /**
81      * @dev Throws if called by any account other than the owner.
82      */
83     modifier onlyOwner() {
84         _checkOwner();
85         _;
86     }
87 
88     /**
89      * @dev Returns the address of the current owner.
90      */
91     function owner() public view virtual returns (address) {
92         return _owner;
93     }
94 
95     /**
96      * @dev Throws if the sender is not the owner.
97      */
98     function _checkOwner() internal view virtual {
99         require(owner() == _msgSender(), "Ownable: caller is not the owner");
100     }
101 
102     /**
103      * @dev Leaves the contract without owner. It will not be possible to call
104      * `onlyOwner` functions anymore. Can only be called by the current owner.
105      *
106      * NOTE: Renouncing ownership will leave the contract without an owner,
107      * thereby removing any functionality that is only available to the owner.
108      */
109     function renounceOwnership() public virtual onlyOwner {
110         _transferOwnership(address(0));
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Can only be called by the current owner.
116      */
117     function transferOwnership(address newOwner) public virtual onlyOwner {
118         require(newOwner != address(0), "Ownable: new owner is the zero address");
119         _transferOwnership(newOwner);
120     }
121 
122     /**
123      * @dev Transfers ownership of the contract to a new account (`newOwner`).
124      * Internal function without access restriction.
125      */
126     function _transferOwnership(address newOwner) internal virtual {
127         address oldOwner = _owner;
128         _owner = newOwner;
129         emit OwnershipTransferred(oldOwner, newOwner);
130     }
131 }
132 
133 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
134 
135 
136 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Interface of the ERC20 standard as defined in the EIP.
142  */
143 interface IERC20 {
144     /**
145      * @dev Emitted when `value` tokens are moved from one account (`from`) to
146      * another (`to`).
147      *
148      * Note that `value` may be zero.
149      */
150     event Transfer(address indexed from, address indexed to, uint256 value);
151 
152     /**
153      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
154      * a call to {approve}. `value` is the new allowance.
155      */
156     event Approval(address indexed owner, address indexed spender, uint256 value);
157 
158     /**
159      * @dev Returns the amount of tokens in existence.
160      */
161     function totalSupply() external view returns (uint256);
162 
163     /**
164      * @dev Returns the amount of tokens owned by `account`.
165      */
166     function balanceOf(address account) external view returns (uint256);
167 
168     /**
169      * @dev Moves `amount` tokens from the caller's account to `to`.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transfer(address to, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Returns the remaining number of tokens that `spender` will be
179      * allowed to spend on behalf of `owner` through {transferFrom}. This is
180      * zero by default.
181      *
182      * This value changes when {approve} or {transferFrom} are called.
183      */
184     function allowance(address owner, address spender) external view returns (uint256);
185 
186     /**
187      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * IMPORTANT: Beware that changing an allowance with this method brings the risk
192      * that someone may use both the old and the new allowance by unfortunate
193      * transaction ordering. One possible solution to mitigate this race
194      * condition is to first reduce the spender's allowance to 0 and set the
195      * desired value afterwards:
196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197      *
198      * Emits an {Approval} event.
199      */
200     function approve(address spender, uint256 amount) external returns (bool);
201 
202     /**
203      * @dev Moves `amount` tokens from `from` to `to` using the
204      * allowance mechanism. `amount` is then deducted from the caller's
205      * allowance.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(
212         address from,
213         address to,
214         uint256 amount
215     ) external returns (bool);
216 }
217 
218 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
219 
220 
221 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
222 
223 pragma solidity ^0.8.0;
224 
225 
226 /**
227  * @dev Interface for the optional metadata functions from the ERC20 standard.
228  *
229  * _Available since v4.1._
230  */
231 interface IERC20Metadata is IERC20 {
232     /**
233      * @dev Returns the name of the token.
234      */
235     function name() external view returns (string memory);
236 
237     /**
238      * @dev Returns the symbol of the token.
239      */
240     function symbol() external view returns (string memory);
241 
242     /**
243      * @dev Returns the decimals places of the token.
244      */
245     function decimals() external view returns (uint8);
246 }
247 
248 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 
256 
257 
258 /**
259  * @dev Implementation of the {IERC20} interface.
260  *
261  * This implementation is agnostic to the way tokens are created. This means
262  * that a supply mechanism has to be added in a derived contract using {_mint}.
263  * For a generic mechanism see {ERC20PresetMinterPauser}.
264  *
265  * TIP: For a detailed writeup see our guide
266  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
267  * to implement supply mechanisms].
268  *
269  * We have followed general OpenZeppelin Contracts guidelines: functions revert
270  * instead returning `false` on failure. This behavior is nonetheless
271  * conventional and does not conflict with the expectations of ERC20
272  * applications.
273  *
274  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See {IERC20-approve}.
282  */
283 contract ERC20 is Context, IERC20, IERC20Metadata {
284     mapping(address => uint256) private _balances;
285 
286     mapping(address => mapping(address => uint256)) private _allowances;
287 
288     uint256 private _totalSupply;
289 
290     string private _name;
291     string private _symbol;
292 
293     /**
294      * @dev Sets the values for {name} and {symbol}.
295      *
296      * The default value of {decimals} is 18. To select a different value for
297      * {decimals} you should overload it.
298      *
299      * All two of these values are immutable: they can only be set once during
300      * construction.
301      */
302     constructor(string memory name_, string memory symbol_) {
303         _name = name_;
304         _symbol = symbol_;
305     }
306 
307     /**
308      * @dev Returns the name of the token.
309      */
310     function name() public view virtual override returns (string memory) {
311         return _name;
312     }
313 
314     /**
315      * @dev Returns the symbol of the token, usually a shorter version of the
316      * name.
317      */
318     function symbol() public view virtual override returns (string memory) {
319         return _symbol;
320     }
321 
322     /**
323      * @dev Returns the number of decimals used to get its user representation.
324      * For example, if `decimals` equals `2`, a balance of `505` tokens should
325      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
326      *
327      * Tokens usually opt for a value of 18, imitating the relationship between
328      * Ether and Wei. This is the value {ERC20} uses, unless this function is
329      * overridden;
330      *
331      * NOTE: This information is only used for _display_ purposes: it in
332      * no way affects any of the arithmetic of the contract, including
333      * {IERC20-balanceOf} and {IERC20-transfer}.
334      */
335     function decimals() public view virtual override returns (uint8) {
336         return 18;
337     }
338 
339     /**
340      * @dev See {IERC20-totalSupply}.
341      */
342     function totalSupply() public view virtual override returns (uint256) {
343         return _totalSupply;
344     }
345 
346     /**
347      * @dev See {IERC20-balanceOf}.
348      */
349     function balanceOf(address account) public view virtual override returns (uint256) {
350         return _balances[account];
351     }
352 
353     /**
354      * @dev See {IERC20-transfer}.
355      *
356      * Requirements:
357      *
358      * - `to` cannot be the zero address.
359      * - the caller must have a balance of at least `amount`.
360      */
361     function transfer(address to, uint256 amount) public virtual override returns (bool) {
362         address owner = _msgSender();
363         _transfer(owner, to, amount);
364         return true;
365     }
366 
367     /**
368      * @dev See {IERC20-allowance}.
369      */
370     function allowance(address owner, address spender) public view virtual override returns (uint256) {
371         return _allowances[owner][spender];
372     }
373 
374     /**
375      * @dev See {IERC20-approve}.
376      *
377      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
378      * `transferFrom`. This is semantically equivalent to an infinite approval.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function approve(address spender, uint256 amount) public virtual override returns (bool) {
385         address owner = _msgSender();
386         _approve(owner, spender, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-transferFrom}.
392      *
393      * Emits an {Approval} event indicating the updated allowance. This is not
394      * required by the EIP. See the note at the beginning of {ERC20}.
395      *
396      * NOTE: Does not update the allowance if the current allowance
397      * is the maximum `uint256`.
398      *
399      * Requirements:
400      *
401      * - `from` and `to` cannot be the zero address.
402      * - `from` must have a balance of at least `amount`.
403      * - the caller must have allowance for ``from``'s tokens of at least
404      * `amount`.
405      */
406     function transferFrom(
407         address from,
408         address to,
409         uint256 amount
410     ) public virtual override returns (bool) {
411         address spender = _msgSender();
412         _spendAllowance(from, spender, amount);
413         _transfer(from, to, amount);
414         return true;
415     }
416 
417     /**
418      * @dev Atomically increases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
430         address owner = _msgSender();
431         _approve(owner, spender, allowance(owner, spender) + addedValue);
432         return true;
433     }
434 
435     /**
436      * @dev Atomically decreases the allowance granted to `spender` by the caller.
437      *
438      * This is an alternative to {approve} that can be used as a mitigation for
439      * problems described in {IERC20-approve}.
440      *
441      * Emits an {Approval} event indicating the updated allowance.
442      *
443      * Requirements:
444      *
445      * - `spender` cannot be the zero address.
446      * - `spender` must have allowance for the caller of at least
447      * `subtractedValue`.
448      */
449     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
450         address owner = _msgSender();
451         uint256 currentAllowance = allowance(owner, spender);
452         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
453         unchecked {
454             _approve(owner, spender, currentAllowance - subtractedValue);
455         }
456 
457         return true;
458     }
459 
460     /**
461      * @dev Moves `amount` of tokens from `from` to `to`.
462      *
463      * This internal function is equivalent to {transfer}, and can be used to
464      * e.g. implement automatic token fees, slashing mechanisms, etc.
465      *
466      * Emits a {Transfer} event.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `from` must have a balance of at least `amount`.
473      */
474     function _transfer(
475         address from,
476         address to,
477         uint256 amount
478     ) internal virtual {
479         require(from != address(0), "ERC20: transfer from the zero address");
480         require(to != address(0), "ERC20: transfer to the zero address");
481 
482         _beforeTokenTransfer(from, to, amount);
483 
484         uint256 fromBalance = _balances[from];
485         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
486         unchecked {
487             _balances[from] = fromBalance - amount;
488             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
489             // decrementing then incrementing.
490             _balances[to] += amount;
491         }
492 
493         emit Transfer(from, to, amount);
494 
495         _afterTokenTransfer(from, to, amount);
496     }
497 
498     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
499      * the total supply.
500      *
501      * Emits a {Transfer} event with `from` set to the zero address.
502      *
503      * Requirements:
504      *
505      * - `account` cannot be the zero address.
506      */
507     function _mint(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: mint to the zero address");
509 
510         _beforeTokenTransfer(address(0), account, amount);
511 
512         _totalSupply += amount;
513         unchecked {
514             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
515             _balances[account] += amount;
516         }
517         emit Transfer(address(0), account, amount);
518 
519         _afterTokenTransfer(address(0), account, amount);
520     }
521 
522     /**
523      * @dev Destroys `amount` tokens from `account`, reducing the
524      * total supply.
525      *
526      * Emits a {Transfer} event with `to` set to the zero address.
527      *
528      * Requirements:
529      *
530      * - `account` cannot be the zero address.
531      * - `account` must have at least `amount` tokens.
532      */
533     function _burn(address account, uint256 amount) internal virtual {
534         require(account != address(0), "ERC20: burn from the zero address");
535 
536         _beforeTokenTransfer(account, address(0), amount);
537 
538         uint256 accountBalance = _balances[account];
539         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
540         unchecked {
541             _balances[account] = accountBalance - amount;
542             // Overflow not possible: amount <= accountBalance <= totalSupply.
543             _totalSupply -= amount;
544         }
545 
546         emit Transfer(account, address(0), amount);
547 
548         _afterTokenTransfer(account, address(0), amount);
549     }
550 
551     /**
552      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
553      *
554      * This internal function is equivalent to `approve`, and can be used to
555      * e.g. set automatic allowances for certain subsystems, etc.
556      *
557      * Emits an {Approval} event.
558      *
559      * Requirements:
560      *
561      * - `owner` cannot be the zero address.
562      * - `spender` cannot be the zero address.
563      */
564     function _approve(
565         address owner,
566         address spender,
567         uint256 amount
568     ) internal virtual {
569         require(owner != address(0), "ERC20: approve from the zero address");
570         require(spender != address(0), "ERC20: approve to the zero address");
571 
572         _allowances[owner][spender] = amount;
573         emit Approval(owner, spender, amount);
574     }
575 
576     /**
577      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
578      *
579      * Does not update the allowance amount in case of infinite allowance.
580      * Revert if not enough allowance is available.
581      *
582      * Might emit an {Approval} event.
583      */
584     function _spendAllowance(
585         address owner,
586         address spender,
587         uint256 amount
588     ) internal virtual {
589         uint256 currentAllowance = allowance(owner, spender);
590         if (currentAllowance != type(uint256).max) {
591             require(currentAllowance >= amount, "ERC20: insufficient allowance");
592             unchecked {
593                 _approve(owner, spender, currentAllowance - amount);
594             }
595         }
596     }
597 
598     /**
599      * @dev Hook that is called before any transfer of tokens. This includes
600      * minting and burning.
601      *
602      * Calling conditions:
603      *
604      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
605      * will be transferred to `to`.
606      * - when `from` is zero, `amount` tokens will be minted for `to`.
607      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
608      * - `from` and `to` are never both zero.
609      *
610      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
611      */
612     function _beforeTokenTransfer(
613         address from,
614         address to,
615         uint256 amount
616     ) internal virtual {}
617 
618     /**
619      * @dev Hook that is called after any transfer of tokens. This includes
620      * minting and burning.
621      *
622      * Calling conditions:
623      *
624      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
625      * has been transferred to `to`.
626      * - when `from` is zero, `amount` tokens have been minted for `to`.
627      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
628      * - `from` and `to` are never both zero.
629      *
630      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
631      */
632     function _afterTokenTransfer(
633         address from,
634         address to,
635         uint256 amount
636     ) internal virtual {}
637 }
638 
639 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
640 
641 
642 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
643 
644 pragma solidity ^0.8.0;
645 
646 
647 
648 /**
649  * @dev Extension of {ERC20} that allows token holders to destroy both their own
650  * tokens and those that they have an allowance for, in a way that can be
651  * recognized off-chain (via event analysis).
652  */
653 abstract contract ERC20Burnable is Context, ERC20 {
654     /**
655      * @dev Destroys `amount` tokens from the caller.
656      *
657      * See {ERC20-_burn}.
658      */
659     function burn(uint256 amount) public virtual {
660         _burn(_msgSender(), amount);
661     }
662 
663     /**
664      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
665      * allowance.
666      *
667      * See {ERC20-_burn} and {ERC20-allowance}.
668      *
669      * Requirements:
670      *
671      * - the caller must have allowance for ``accounts``'s tokens of at least
672      * `amount`.
673      */
674     function burnFrom(address account, uint256 amount) public virtual {
675         _spendAllowance(account, _msgSender(), amount);
676         _burn(account, amount);
677     }
678 }
679 
680 // File: contracts/JamesBond.sol
681 
682 // SPDX-License-Identifier: MIT
683                                                                                                                                                                                                                                                            
684 pragma solidity ^0.8.9;
685 
686 // Import required libraries
687 
688 contract JamesBond is ERC20, ERC20Burnable, Ownable {
689 
690     uint256 public maxLimit;
691 
692     modifier withinLimit(address _address, uint256 _amount) {
693         require(
694             (balanceOf(_address) + _amount) <= (maxLimit),
695             "Exceeds maximum token holding limit of 7 million"
696         );
697         _;
698     }
699 
700     // Name, symbol, and initial supply.
701     constructor(uint256 _maxLimit ) ERC20("James Bond", "BOND") {
702         maxLimit = _maxLimit;
703         _mint(msg.sender, 630000000 * 10 ** decimals()); // Contract
704         _mint(0xC2BB6aE0877b0dfCaD7985fbf70CcD706C0fd4A8, 17500000 * 10 ** decimals()); // Marketing
705         _mint(0x89e514B097468eb14C968EF930C3c8cff3A774Ca, 17500000 * 10 ** decimals()); // CEX
706         /* Everything below are initial mints **/
707         _mint(0x1ecF4806554D91eD02e7DAe30A44CEfA925E1c48, 7000000 * 10 ** decimals()); 
708         _mint(0x9DC953967053554BC8c6E4d7fA652fceA1e2C950, 7000000 * 10 ** decimals()); 
709         _mint(0x52BD4c7a6F9dC6f0E70DB5de9a41f7fEf34Cad20, 3500000 * 10 ** decimals()); 
710         _mint(0x4C4b065EfBa164b5d90e240daf8474261A804CE5, 7000000 * 10 ** decimals()); 
711         _mint(0x1585cF78071fCCe19d5752F996655E0A70fFd19e, 7000000 * 10 ** decimals()); 
712         _mint(0x23A698f73e02dfec704A8bae1179Ce2c986D151B, 3500000 * 10 ** decimals()); 
713     }
714 
715     // Burn Function
716     // Only contract Owner
717     function burnTokens(uint256 amount) public onlyOwner {
718     _burn(msg.sender, amount);
719     }
720 
721     function transfer(address _recipient, uint256 _amount)
722         public
723         override
724         withinLimit(_recipient, _amount)
725         returns (bool)
726     {
727         return super.transfer(_recipient, _amount);
728     }
729 
730 }