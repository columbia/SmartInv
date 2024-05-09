1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
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
81     function transferFrom(address from, address to, uint256 amount) external returns (bool);
82 }
83 
84 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Interface for the optional metadata functions from the ERC20 standard.
93  *
94  * _Available since v4.1._
95  */
96 interface IERC20Metadata is IERC20 {
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() external view returns (string memory);
101 
102     /**
103      * @dev Returns the symbol of the token.
104      */
105     function symbol() external view returns (string memory);
106 
107     /**
108      * @dev Returns the decimals places of the token.
109      */
110     function decimals() external view returns (uint8);
111 }
112 
113 // File: @openzeppelin/contracts/utils/Context.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Provides information about the current execution context, including the
122  * sender of the transaction and its data. While these are generally available
123  * via msg.sender and msg.data, they should not be accessed in such a direct
124  * manner, since when dealing with meta-transactions the account sending and
125  * paying for execution may not be the actual sender (as far as an application
126  * is concerned).
127  *
128  * This contract is only required for intermediate, library-like contracts.
129  */
130 abstract contract Context {
131     function _msgSender() internal view virtual returns (address) {
132         return msg.sender;
133     }
134 
135     function _msgData() internal view virtual returns (bytes calldata) {
136         return msg.data;
137     }
138 }
139 
140 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
141 
142 
143 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 
148 
149 /**
150  * @dev Implementation of the {IERC20} interface.
151  *
152  * This implementation is agnostic to the way tokens are created. This means
153  * that a supply mechanism has to be added in a derived contract using {_mint}.
154  * For a generic mechanism see {ERC20PresetMinterPauser}.
155  *
156  * TIP: For a detailed writeup see our guide
157  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
158  * to implement supply mechanisms].
159  *
160  * The default value of {decimals} is 18. To change this, you should override
161  * this function so it returns a different value.
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
190      * All two of these values are immutable: they can only be set once during
191      * construction.
192      */
193     constructor(string memory name_, string memory symbol_) {
194         _name = name_;
195         _symbol = symbol_;
196     }
197 
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() public view virtual override returns (string memory) {
202         return _name;
203     }
204 
205     /**
206      * @dev Returns the symbol of the token, usually a shorter version of the
207      * name.
208      */
209     function symbol() public view virtual override returns (string memory) {
210         return _symbol;
211     }
212 
213     /**
214      * @dev Returns the number of decimals used to get its user representation.
215      * For example, if `decimals` equals `2`, a balance of `505` tokens should
216      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
217      *
218      * Tokens usually opt for a value of 18, imitating the relationship between
219      * Ether and Wei. This is the default value returned by this function, unless
220      * it's overridden.
221      *
222      * NOTE: This information is only used for _display_ purposes: it in
223      * no way affects any of the arithmetic of the contract, including
224      * {IERC20-balanceOf} and {IERC20-transfer}.
225      */
226     function decimals() public view virtual override returns (uint8) {
227         return 18;
228     }
229 
230     /**
231      * @dev See {IERC20-totalSupply}.
232      */
233     function totalSupply() public view virtual override returns (uint256) {
234         return _totalSupply;
235     }
236 
237     /**
238      * @dev See {IERC20-balanceOf}.
239      */
240     function balanceOf(address account) public view virtual override returns (uint256) {
241         return _balances[account];
242     }
243 
244     /**
245      * @dev See {IERC20-transfer}.
246      *
247      * Requirements:
248      *
249      * - `to` cannot be the zero address.
250      * - the caller must have a balance of at least `amount`.
251      */
252     function transfer(address to, uint256 amount) public virtual override returns (bool) {
253         address owner = _msgSender();
254         _transfer(owner, to, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-allowance}.
260      */
261     function allowance(address owner, address spender) public view virtual override returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     /**
266      * @dev See {IERC20-approve}.
267      *
268      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
269      * `transferFrom`. This is semantically equivalent to an infinite approval.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function approve(address spender, uint256 amount) public virtual override returns (bool) {
276         address owner = _msgSender();
277         _approve(owner, spender, amount);
278         return true;
279     }
280 
281     /**
282      * @dev See {IERC20-transferFrom}.
283      *
284      * Emits an {Approval} event indicating the updated allowance. This is not
285      * required by the EIP. See the note at the beginning of {ERC20}.
286      *
287      * NOTE: Does not update the allowance if the current allowance
288      * is the maximum `uint256`.
289      *
290      * Requirements:
291      *
292      * - `from` and `to` cannot be the zero address.
293      * - `from` must have a balance of at least `amount`.
294      * - the caller must have allowance for ``from``'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
298         address spender = _msgSender();
299         _spendAllowance(from, spender, amount);
300         _transfer(from, to, amount);
301         return true;
302     }
303 
304     /**
305      * @dev Atomically increases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
317         address owner = _msgSender();
318         _approve(owner, spender, allowance(owner, spender) + addedValue);
319         return true;
320     }
321 
322     /**
323      * @dev Atomically decreases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      * - `spender` must have allowance for the caller of at least
334      * `subtractedValue`.
335      */
336     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
337         address owner = _msgSender();
338         uint256 currentAllowance = allowance(owner, spender);
339         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
340         unchecked {
341             _approve(owner, spender, currentAllowance - subtractedValue);
342         }
343 
344         return true;
345     }
346 
347     /**
348      * @dev Moves `amount` of tokens from `from` to `to`.
349      *
350      * This internal function is equivalent to {transfer}, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a {Transfer} event.
354      *
355      * Requirements:
356      *
357      * - `from` cannot be the zero address.
358      * - `to` cannot be the zero address.
359      * - `from` must have a balance of at least `amount`.
360      */
361     function _transfer(address from, address to, uint256 amount) internal virtual {
362         require(from != address(0), "ERC20: transfer from the zero address");
363         require(to != address(0), "ERC20: transfer to the zero address");
364 
365         _beforeTokenTransfer(from, to, amount);
366 
367         uint256 fromBalance = _balances[from];
368         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
369         unchecked {
370             _balances[from] = fromBalance - amount;
371             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
372             // decrementing then incrementing.
373             _balances[to] += amount;
374         }
375 
376         emit Transfer(from, to, amount);
377 
378         _afterTokenTransfer(from, to, amount);
379     }
380 
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a {Transfer} event with `from` set to the zero address.
385      *
386      * Requirements:
387      *
388      * - `account` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: mint to the zero address");
392 
393         _beforeTokenTransfer(address(0), account, amount);
394 
395         _totalSupply += amount;
396         unchecked {
397             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
398             _balances[account] += amount;
399         }
400         emit Transfer(address(0), account, amount);
401 
402         _afterTokenTransfer(address(0), account, amount);
403     }
404 
405     /**
406      * @dev Destroys `amount` tokens from `account`, reducing the
407      * total supply.
408      *
409      * Emits a {Transfer} event with `to` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      * - `account` must have at least `amount` tokens.
415      */
416     function _burn(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: burn from the zero address");
418 
419         _beforeTokenTransfer(account, address(0), amount);
420 
421         uint256 accountBalance = _balances[account];
422         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
423         unchecked {
424             _balances[account] = accountBalance - amount;
425             // Overflow not possible: amount <= accountBalance <= totalSupply.
426             _totalSupply -= amount;
427         }
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
447     function _approve(address owner, address spender, uint256 amount) internal virtual {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450 
451         _allowances[owner][spender] = amount;
452         emit Approval(owner, spender, amount);
453     }
454 
455     /**
456      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
457      *
458      * Does not update the allowance amount in case of infinite allowance.
459      * Revert if not enough allowance is available.
460      *
461      * Might emit an {Approval} event.
462      */
463     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
464         uint256 currentAllowance = allowance(owner, spender);
465         if (currentAllowance != type(uint256).max) {
466             require(currentAllowance >= amount, "ERC20: insufficient allowance");
467             unchecked {
468                 _approve(owner, spender, currentAllowance - amount);
469             }
470         }
471     }
472 
473     /**
474      * @dev Hook that is called before any transfer of tokens. This includes
475      * minting and burning.
476      *
477      * Calling conditions:
478      *
479      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
480      * will be transferred to `to`.
481      * - when `from` is zero, `amount` tokens will be minted for `to`.
482      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
483      * - `from` and `to` are never both zero.
484      *
485      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
486      */
487     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
488 
489     /**
490      * @dev Hook that is called after any transfer of tokens. This includes
491      * minting and burning.
492      *
493      * Calling conditions:
494      *
495      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
496      * has been transferred to `to`.
497      * - when `from` is zero, `amount` tokens have been minted for `to`.
498      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
499      * - `from` and `to` are never both zero.
500      *
501      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
502      */
503     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
504 }
505 
506 // File: contracts/token/ERC20/extensions/ERC20Decimals.sol
507 
508 
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @title ERC20Decimals
514  * @dev Extension of {ERC20} that adds decimals storage slot.
515  */
516 abstract contract ERC20Decimals is ERC20 {
517     uint8 private immutable _decimals;
518 
519     /**
520      * @dev Sets the value of the `_decimals`.
521      * This value is immutable, it can only be set once during construction.
522      */
523     constructor(uint8 decimals_) {
524         _decimals = decimals_;
525     }
526 
527     function decimals() public view virtual override returns (uint8) {
528         return _decimals;
529     }
530 }
531 
532 // File: contracts/token/ERC20/extensions/ERC20Detailed.sol
533 
534 
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @title ERC20Detailed
540  * @dev Extension of {ERC20} and {ERC20Decimals}.
541  */
542 abstract contract ERC20Detailed is ERC20Decimals {
543     constructor(
544         string memory name_,
545         string memory symbol_,
546         uint8 decimals_
547     ) ERC20(name_, symbol_) ERC20Decimals(decimals_) {}
548 }
549 
550 // File: contracts/token/ERC20/extensions/ERC20AntiWhale.sol
551 
552 
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @title ERC20AntiWhale
558  * @dev Extension of {ERC20} that adds limit at users balance.
559  */
560 abstract contract ERC20AntiWhale is ERC20 {
561     // the percent rate for balance limit
562     uint8 private _balanceLimitRate;
563 
564     mapping(address => bool) private _isExcludedFromBalanceLimit;
565 
566     /**
567      * @dev Sets the value of the `_balanceLimitRate`.
568      */
569     constructor(uint8 balanceLimitRate_) {
570         _setBalanceLimit(balanceLimitRate_);
571         _setExclusionFromBalanceLimit(_msgSender(), true);
572     }
573 
574     /**
575      * @dev Returns the percent rate of the balance limit.
576      */
577     function balanceLimitPercent() external view returns (uint8) {
578         return _balanceLimitRate;
579     }
580 
581     /**
582      * @dev Returns the status of exclusion from balance limit for a given account.
583      */
584     function isExcludedFromBalanceLimit(address account) external view returns (bool) {
585         return _isExcludedFromBalanceLimit[account];
586     }
587 
588     /**
589      * @dev Sets the amount of balance limit percent.
590      *
591      * WARNING: it allows everyone to set the limit. Access controls MUST be defined in derived contracts.
592      *
593      * @param balanceLimitPercent_ The amount of balance limit percent
594      */
595     function _setBalanceLimit(uint8 balanceLimitPercent_) internal virtual {
596         require(
597             balanceLimitPercent_ > 0 && balanceLimitPercent_ <= 100,
598             "ERC20AntiWhale: balanceLimitPercent_ must be between 1 and 100"
599         );
600 
601         _balanceLimitRate = balanceLimitPercent_;
602     }
603 
604     /**
605      * @dev Sets the exclusion status from balance limit (receiving only).
606      *
607      * WARNING: it allows everyone to set the status. Access controls MUST be defined in derived contracts.
608      *
609      * @param account_ The address that will be excluded or not
610      * @param status_ The status of exclusion
611      */
612     function _setExclusionFromBalanceLimit(address account_, bool status_) internal virtual {
613         _isExcludedFromBalanceLimit[account_] = status_;
614     }
615 
616     /**
617      * @dev Requires that recipient's token balance do not exceeded the limit or that recipient is excluded from that control.
618      * Otherwise revert a transfer.
619      */
620     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
621         super._beforeTokenTransfer(from, to, amount);
622 
623         require(
624             _balanceLimitRate == 100 ||
625                 _isExcludedFromBalanceLimit[to] ||
626                 ((balanceOf(to) + amount) <= (totalSupply() * _balanceLimitRate) / 100),
627             "ERC20AntiWhale: receiver has exceeded the balance limit"
628         );
629     }
630 }
631 
632 // File: @openzeppelin/contracts/access/Ownable.sol
633 
634 
635 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @dev Contract module which provides a basic access control mechanism, where
641  * there is an account (an owner) that can be granted exclusive access to
642  * specific functions.
643  *
644  * By default, the owner account will be the one that deploys the contract. This
645  * can later be changed with {transferOwnership}.
646  *
647  * This module is used through inheritance. It will make available the modifier
648  * `onlyOwner`, which can be applied to your functions to restrict their use to
649  * the owner.
650  */
651 abstract contract Ownable is Context {
652     address private _owner;
653 
654     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
655 
656     /**
657      * @dev Initializes the contract setting the deployer as the initial owner.
658      */
659     constructor() {
660         _transferOwnership(_msgSender());
661     }
662 
663     /**
664      * @dev Throws if called by any account other than the owner.
665      */
666     modifier onlyOwner() {
667         _checkOwner();
668         _;
669     }
670 
671     /**
672      * @dev Returns the address of the current owner.
673      */
674     function owner() public view virtual returns (address) {
675         return _owner;
676     }
677 
678     /**
679      * @dev Throws if the sender is not the owner.
680      */
681     function _checkOwner() internal view virtual {
682         require(owner() == _msgSender(), "Ownable: caller is not the owner");
683     }
684 
685     /**
686      * @dev Leaves the contract without owner. It will not be possible to call
687      * `onlyOwner` functions. Can only be called by the current owner.
688      *
689      * NOTE: Renouncing ownership will leave the contract without an owner,
690      * thereby disabling any functionality that is only available to the owner.
691      */
692     function renounceOwnership() public virtual onlyOwner {
693         _transferOwnership(address(0));
694     }
695 
696     /**
697      * @dev Transfers ownership of the contract to a new account (`newOwner`).
698      * Can only be called by the current owner.
699      */
700     function transferOwnership(address newOwner) public virtual onlyOwner {
701         require(newOwner != address(0), "Ownable: new owner is the zero address");
702         _transferOwnership(newOwner);
703     }
704 
705     /**
706      * @dev Transfers ownership of the contract to a new account (`newOwner`).
707      * Internal function without access restriction.
708      */
709     function _transferOwnership(address newOwner) internal virtual {
710         address oldOwner = _owner;
711         _owner = newOwner;
712         emit OwnershipTransferred(oldOwner, newOwner);
713     }
714 }
715 
716 // File: contracts/service/ServicePayer.sol
717 
718 
719 
720 pragma solidity ^0.8.0;
721 
722 interface IPayable {
723     function pay(string memory serviceName, bytes memory signature, address wallet) external payable;
724 }
725 
726 /**
727  * @title ServicePayer
728  * @dev Implementation of the ServicePayer
729  */
730 abstract contract ServicePayer {
731     constructor(address payable receiver, string memory serviceName, bytes memory signature, address wallet) payable {
732         IPayable(receiver).pay{value: msg.value}(serviceName, signature, wallet);
733     }
734 }
735 
736 // File: contracts/token/ERC20/AntiWhaleERC20.sol
737 
738 
739 
740 pragma solidity ^0.8.0;
741 
742 /**
743  * @title AntiWhaleERC20
744  * @dev Implementation of the AntiWhaleERC20
745  */
746 contract AntiWhaleERC20 is ERC20Detailed, ERC20AntiWhale, Ownable, ServicePayer {
747     constructor(
748         string memory name_,
749         string memory symbol_,
750         uint8 decimals_,
751         uint256 initialBalance_,
752         uint8 balanceLimitRate_,
753         bytes memory signature_,
754         address payable feeReceiver_
755     )
756         payable
757         ERC20Detailed(name_, symbol_, decimals_)
758         ERC20AntiWhale(balanceLimitRate_)
759         ServicePayer(feeReceiver_, "AntiWhaleERC20", signature_, _msgSender())
760     {
761         require(initialBalance_ > 0, "AntiWhaleERC20: supply cannot be zero");
762 
763         _mint(_msgSender(), initialBalance_);
764     }
765 
766     /**
767      * @dev Sets the amount of balance limit percent.
768      *
769      * NOTE: restricting access to owner only. See {ERC20AntiWhale-_setBalanceLimit}.
770      *
771      * @param balanceLimitPercent The amount of balance limit percent
772      */
773     function setBalanceLimitPercent(uint8 balanceLimitPercent) external onlyOwner {
774         _setBalanceLimit(balanceLimitPercent);
775     }
776 
777     /**
778      * @dev Sets the exclusion status from balance limit (receiving only).
779      *
780      * NOTE: restricting access to owner only. See {ERC20AntiWhale-_setExclusionFromBalanceLimit}.
781      *
782      * @param account The address that will be excluded or not
783      * @param status The status of exclusion
784      */
785     function setExclusionFromBalanceLimit(address account, bool status) external onlyOwner {
786         _setExclusionFromBalanceLimit(account, status);
787     }
788 
789     function decimals() public view virtual override(ERC20, ERC20Decimals) returns (uint8) {
790         return super.decimals();
791     }
792 
793     /**
794      * @dev Requires that recipient's token balance do not exceeded the limit or that recipient is excluded from that control.
795      * Otherwise revert a transfer.
796      */
797     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20AntiWhale) {
798         super._beforeTokenTransfer(from, to, amount);
799     }
800 }
