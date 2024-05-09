1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/security/Pausable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which allows children to implement an emergency stop
38  * mechanism that can be triggered by an authorized account.
39  *
40  * This module is used through inheritance. It will make available the
41  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
42  * the functions of your contract. Note that they will not be pausable by
43  * simply including this module, only once the modifiers are put in place.
44  */
45 abstract contract Pausable is Context {
46     /**
47      * @dev Emitted when the pause is triggered by `account`.
48      */
49     event Paused(address account);
50 
51     /**
52      * @dev Emitted when the pause is lifted by `account`.
53      */
54     event Unpaused(address account);
55 
56     bool private _paused;
57 
58     /**
59      * @dev Initializes the contract in unpaused state.
60      */
61     constructor() {
62         _paused = false;
63     }
64 
65     /**
66      * @dev Modifier to make a function callable only when the contract is not paused.
67      *
68      * Requirements:
69      *
70      * - The contract must not be paused.
71      */
72     modifier whenNotPaused() {
73         _requireNotPaused();
74         _;
75     }
76 
77     /**
78      * @dev Modifier to make a function callable only when the contract is paused.
79      *
80      * Requirements:
81      *
82      * - The contract must be paused.
83      */
84     modifier whenPaused() {
85         _requirePaused();
86         _;
87     }
88 
89     /**
90      * @dev Returns true if the contract is paused, and false otherwise.
91      */
92     function paused() public view virtual returns (bool) {
93         return _paused;
94     }
95 
96     /**
97      * @dev Throws if the contract is paused.
98      */
99     function _requireNotPaused() internal view virtual {
100         require(!paused(), "Pausable: paused");
101     }
102 
103     /**
104      * @dev Throws if the contract is not paused.
105      */
106     function _requirePaused() internal view virtual {
107         require(paused(), "Pausable: not paused");
108     }
109 
110     /**
111      * @dev Triggers stopped state.
112      *
113      * Requirements:
114      *
115      * - The contract must not be paused.
116      */
117     function _pause() internal virtual whenNotPaused {
118         _paused = true;
119         emit Paused(_msgSender());
120     }
121 
122     /**
123      * @dev Returns to normal state.
124      *
125      * Requirements:
126      *
127      * - The contract must be paused.
128      */
129     function _unpause() internal virtual whenPaused {
130         _paused = false;
131         emit Unpaused(_msgSender());
132     }
133 }
134 
135 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
136 
137 
138 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev Interface of the ERC20 standard as defined in the EIP.
144  */
145 interface IERC20 {
146     /**
147      * @dev Emitted when `value` tokens are moved from one account (`from`) to
148      * another (`to`).
149      *
150      * Note that `value` may be zero.
151      */
152     event Transfer(address indexed from, address indexed to, uint256 value);
153 
154     /**
155      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
156      * a call to {approve}. `value` is the new allowance.
157      */
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 
160     /**
161      * @dev Returns the amount of tokens in existence.
162      */
163     function totalSupply() external view returns (uint256);
164 
165     /**
166      * @dev Returns the amount of tokens owned by `account`.
167      */
168     function balanceOf(address account) external view returns (uint256);
169 
170     /**
171      * @dev Moves `amount` tokens from the caller's account to `to`.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transfer(address to, uint256 amount) external returns (bool);
178 
179     /**
180      * @dev Returns the remaining number of tokens that `spender` will be
181      * allowed to spend on behalf of `owner` through {transferFrom}. This is
182      * zero by default.
183      *
184      * This value changes when {approve} or {transferFrom} are called.
185      */
186     function allowance(address owner, address spender) external view returns (uint256);
187 
188     /**
189      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * IMPORTANT: Beware that changing an allowance with this method brings the risk
194      * that someone may use both the old and the new allowance by unfortunate
195      * transaction ordering. One possible solution to mitigate this race
196      * condition is to first reduce the spender's allowance to 0 and set the
197      * desired value afterwards:
198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199      *
200      * Emits an {Approval} event.
201      */
202     function approve(address spender, uint256 amount) external returns (bool);
203 
204     /**
205      * @dev Moves `amount` tokens from `from` to `to` using the
206      * allowance mechanism. `amount` is then deducted from the caller's
207      * allowance.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transferFrom(
214         address from,
215         address to,
216         uint256 amount
217     ) external returns (bool);
218 }
219 
220 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 
228 /**
229  * @dev Interface for the optional metadata functions from the ERC20 standard.
230  *
231  * _Available since v4.1._
232  */
233 interface IERC20Metadata is IERC20 {
234     /**
235      * @dev Returns the name of the token.
236      */
237     function name() external view returns (string memory);
238 
239     /**
240      * @dev Returns the symbol of the token.
241      */
242     function symbol() external view returns (string memory);
243 
244     /**
245      * @dev Returns the decimals places of the token.
246      */
247     function decimals() external view returns (uint8);
248 }
249 
250 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
251 
252 
253 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 
258 
259 
260 /**
261  * @dev Implementation of the {IERC20} interface.
262  *
263  * This implementation is agnostic to the way tokens are created. This means
264  * that a supply mechanism has to be added in a derived contract using {_mint}.
265  * For a generic mechanism see {ERC20PresetMinterPauser}.
266  *
267  * TIP: For a detailed writeup see our guide
268  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
269  * to implement supply mechanisms].
270  *
271  * We have followed general OpenZeppelin Contracts guidelines: functions revert
272  * instead returning `false` on failure. This behavior is nonetheless
273  * conventional and does not conflict with the expectations of ERC20
274  * applications.
275  *
276  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
277  * This allows applications to reconstruct the allowance for all accounts just
278  * by listening to said events. Other implementations of the EIP may not emit
279  * these events, as it isn't required by the specification.
280  *
281  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
282  * functions have been added to mitigate the well-known issues around setting
283  * allowances. See {IERC20-approve}.
284  */
285 contract ERC20 is Context, IERC20, IERC20Metadata {
286     mapping(address => uint256) private _balances;
287 
288     mapping(address => mapping(address => uint256)) private _allowances;
289 
290     uint256 private _totalSupply;
291 
292     string private _name;
293     string private _symbol;
294 
295     /**
296      * @dev Sets the values for {name} and {symbol}.
297      *
298      * The default value of {decimals} is 18. To select a different value for
299      * {decimals} you should overload it.
300      *
301      * All two of these values are immutable: they can only be set once during
302      * construction.
303      */
304     constructor(string memory name_, string memory symbol_) {
305         _name = name_;
306         _symbol = symbol_;
307     }
308 
309     /**
310      * @dev Returns the name of the token.
311      */
312     function name() public view virtual override returns (string memory) {
313         return _name;
314     }
315 
316     /**
317      * @dev Returns the symbol of the token, usually a shorter version of the
318      * name.
319      */
320     function symbol() public view virtual override returns (string memory) {
321         return _symbol;
322     }
323 
324     /**
325      * @dev Returns the number of decimals used to get its user representation.
326      * For example, if `decimals` equals `2`, a balance of `505` tokens should
327      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
328      *
329      * Tokens usually opt for a value of 18, imitating the relationship between
330      * Ether and Wei. This is the value {ERC20} uses, unless this function is
331      * overridden;
332      *
333      * NOTE: This information is only used for _display_ purposes: it in
334      * no way affects any of the arithmetic of the contract, including
335      * {IERC20-balanceOf} and {IERC20-transfer}.
336      */
337     function decimals() public view virtual override returns (uint8) {
338         return 18;
339     }
340 
341     /**
342      * @dev See {IERC20-totalSupply}.
343      */
344     function totalSupply() public view virtual override returns (uint256) {
345         return _totalSupply;
346     }
347 
348     /**
349      * @dev See {IERC20-balanceOf}.
350      */
351     function balanceOf(address account) public view virtual override returns (uint256) {
352         return _balances[account];
353     }
354 
355     /**
356      * @dev See {IERC20-transfer}.
357      *
358      * Requirements:
359      *
360      * - `to` cannot be the zero address.
361      * - the caller must have a balance of at least `amount`.
362      */
363     function transfer(address to, uint256 amount) public virtual override returns (bool) {
364         address owner = _msgSender();
365         _transfer(owner, to, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-allowance}.
371      */
372     function allowance(address owner, address spender) public view virtual override returns (uint256) {
373         return _allowances[owner][spender];
374     }
375 
376     /**
377      * @dev See {IERC20-approve}.
378      *
379      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
380      * `transferFrom`. This is semantically equivalent to an infinite approval.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      */
386     function approve(address spender, uint256 amount) public virtual override returns (bool) {
387         address owner = _msgSender();
388         _approve(owner, spender, amount);
389         return true;
390     }
391 
392     /**
393      * @dev See {IERC20-transferFrom}.
394      *
395      * Emits an {Approval} event indicating the updated allowance. This is not
396      * required by the EIP. See the note at the beginning of {ERC20}.
397      *
398      * NOTE: Does not update the allowance if the current allowance
399      * is the maximum `uint256`.
400      *
401      * Requirements:
402      *
403      * - `from` and `to` cannot be the zero address.
404      * - `from` must have a balance of at least `amount`.
405      * - the caller must have allowance for ``from``'s tokens of at least
406      * `amount`.
407      */
408     function transferFrom(
409         address from,
410         address to,
411         uint256 amount
412     ) public virtual override returns (bool) {
413         address spender = _msgSender();
414         _spendAllowance(from, spender, amount);
415         _transfer(from, to, amount);
416         return true;
417     }
418 
419     /**
420      * @dev Atomically increases the allowance granted to `spender` by the caller.
421      *
422      * This is an alternative to {approve} that can be used as a mitigation for
423      * problems described in {IERC20-approve}.
424      *
425      * Emits an {Approval} event indicating the updated allowance.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      */
431     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
432         address owner = _msgSender();
433         _approve(owner, spender, allowance(owner, spender) + addedValue);
434         return true;
435     }
436 
437     /**
438      * @dev Atomically decreases the allowance granted to `spender` by the caller.
439      *
440      * This is an alternative to {approve} that can be used as a mitigation for
441      * problems described in {IERC20-approve}.
442      *
443      * Emits an {Approval} event indicating the updated allowance.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      * - `spender` must have allowance for the caller of at least
449      * `subtractedValue`.
450      */
451     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
452         address owner = _msgSender();
453         uint256 currentAllowance = allowance(owner, spender);
454         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
455         unchecked {
456             _approve(owner, spender, currentAllowance - subtractedValue);
457         }
458 
459         return true;
460     }
461 
462     /**
463      * @dev Moves `amount` of tokens from `from` to `to`.
464      *
465      * This internal function is equivalent to {transfer}, and can be used to
466      * e.g. implement automatic token fees, slashing mechanisms, etc.
467      *
468      * Emits a {Transfer} event.
469      *
470      * Requirements:
471      *
472      * - `from` cannot be the zero address.
473      * - `to` cannot be the zero address.
474      * - `from` must have a balance of at least `amount`.
475      */
476     function _transfer(
477         address from,
478         address to,
479         uint256 amount
480     ) internal virtual {
481         require(from != address(0), "ERC20: transfer from the zero address");
482         require(to != address(0), "ERC20: transfer to the zero address");
483 
484         _beforeTokenTransfer(from, to, amount);
485 
486         uint256 fromBalance = _balances[from];
487         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
488         unchecked {
489             _balances[from] = fromBalance - amount;
490         }
491         _balances[to] += amount;
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
513         _balances[account] += amount;
514         emit Transfer(address(0), account, amount);
515 
516         _afterTokenTransfer(address(0), account, amount);
517     }
518 
519     /**
520      * @dev Destroys `amount` tokens from `account`, reducing the
521      * total supply.
522      *
523      * Emits a {Transfer} event with `to` set to the zero address.
524      *
525      * Requirements:
526      *
527      * - `account` cannot be the zero address.
528      * - `account` must have at least `amount` tokens.
529      */
530     function _burn(address account, uint256 amount) internal virtual {
531         require(account != address(0), "ERC20: burn from the zero address");
532 
533         _beforeTokenTransfer(account, address(0), amount);
534 
535         uint256 accountBalance = _balances[account];
536         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
537         unchecked {
538             _balances[account] = accountBalance - amount;
539         }
540         _totalSupply -= amount;
541 
542         emit Transfer(account, address(0), amount);
543 
544         _afterTokenTransfer(account, address(0), amount);
545     }
546 
547     /**
548      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
549      *
550      * This internal function is equivalent to `approve`, and can be used to
551      * e.g. set automatic allowances for certain subsystems, etc.
552      *
553      * Emits an {Approval} event.
554      *
555      * Requirements:
556      *
557      * - `owner` cannot be the zero address.
558      * - `spender` cannot be the zero address.
559      */
560     function _approve(
561         address owner,
562         address spender,
563         uint256 amount
564     ) internal virtual {
565         require(owner != address(0), "ERC20: approve from the zero address");
566         require(spender != address(0), "ERC20: approve to the zero address");
567 
568         _allowances[owner][spender] = amount;
569         emit Approval(owner, spender, amount);
570     }
571 
572     /**
573      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
574      *
575      * Does not update the allowance amount in case of infinite allowance.
576      * Revert if not enough allowance is available.
577      *
578      * Might emit an {Approval} event.
579      */
580     function _spendAllowance(
581         address owner,
582         address spender,
583         uint256 amount
584     ) internal virtual {
585         uint256 currentAllowance = allowance(owner, spender);
586         if (currentAllowance != type(uint256).max) {
587             require(currentAllowance >= amount, "ERC20: insufficient allowance");
588             unchecked {
589                 _approve(owner, spender, currentAllowance - amount);
590             }
591         }
592     }
593 
594     /**
595      * @dev Hook that is called before any transfer of tokens. This includes
596      * minting and burning.
597      *
598      * Calling conditions:
599      *
600      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
601      * will be transferred to `to`.
602      * - when `from` is zero, `amount` tokens will be minted for `to`.
603      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
604      * - `from` and `to` are never both zero.
605      *
606      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
607      */
608     function _beforeTokenTransfer(
609         address from,
610         address to,
611         uint256 amount
612     ) internal virtual {}
613 
614     /**
615      * @dev Hook that is called after any transfer of tokens. This includes
616      * minting and burning.
617      *
618      * Calling conditions:
619      *
620      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
621      * has been transferred to `to`.
622      * - when `from` is zero, `amount` tokens have been minted for `to`.
623      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
624      * - `from` and `to` are never both zero.
625      *
626      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
627      */
628     function _afterTokenTransfer(
629         address from,
630         address to,
631         uint256 amount
632     ) internal virtual {}
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
636 
637 
638 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 
644 /**
645  * @dev Extension of {ERC20} that allows token holders to destroy both their own
646  * tokens and those that they have an allowance for, in a way that can be
647  * recognized off-chain (via event analysis).
648  */
649 abstract contract ERC20Burnable is Context, ERC20 {
650     /**
651      * @dev Destroys `amount` tokens from the caller.
652      *
653      * See {ERC20-_burn}.
654      */
655     function burn(uint256 amount) public virtual {
656         _burn(_msgSender(), amount);
657     }
658 
659     /**
660      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
661      * allowance.
662      *
663      * See {ERC20-_burn} and {ERC20-allowance}.
664      *
665      * Requirements:
666      *
667      * - the caller must have allowance for ``accounts``'s tokens of at least
668      * `amount`.
669      */
670     function burnFrom(address account, uint256 amount) public virtual {
671         _spendAllowance(account, _msgSender(), amount);
672         _burn(account, amount);
673     }
674 }
675 
676 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Capped.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 
684 /**
685  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
686  */
687 abstract contract ERC20Capped is ERC20 {
688     uint256 private immutable _cap;
689 
690     /**
691      * @dev Sets the value of the `cap`. This value is immutable, it can only be
692      * set once during construction.
693      */
694     constructor(uint256 cap_) {
695         require(cap_ > 0, "ERC20Capped: cap is 0");
696         _cap = cap_;
697     }
698 
699     /**
700      * @dev Returns the cap on the token's total supply.
701      */
702     function cap() public view virtual returns (uint256) {
703         return _cap;
704     }
705 
706     /**
707      * @dev See {ERC20-_mint}.
708      */
709     function _mint(address account, uint256 amount) internal virtual override {
710         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
711         super._mint(account, amount);
712     }
713 }
714 
715 // File: contracts/KeyToken.sol
716 
717 // contracts/KeyToken.sol
718 
719 
720 pragma solidity ^0.8.17;
721 
722 
723 
724 
725 
726 contract KeyToken is ERC20Capped, ERC20Burnable, Pausable {
727     address payable public owner;  
728 
729      constructor(uint256 cap) ERC20("KeyToken", "KTK") ERC20Capped(cap * (10 ** decimals())) {
730         owner = payable(msg.sender);
731        _mint(owner, 99800000 * (10 ** decimals()));  
732     }
733 
734     function _mint(address account, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
735         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
736         super._mint(account, amount);
737     }
738   
739 
740     function publishToken(uint256 amount) public{
741         require(msg.sender == owner, "only the owner can call this function");        
742          owner = payable(msg.sender);
743         _mint(owner, amount * (10 ** decimals())); 
744     }
745 
746     modifier onlyOwner {
747         require(msg.sender == owner, "Only the owner can call this function");
748         _;
749     }
750     function pause() public onlyOwner{
751         _pause();
752     }
753     function unpause() public onlyOwner{
754         _unpause();
755     }
756     function _beforeTokenTransfer(address from,address to,uint256 amount) internal whenNotPaused override{
757         super._beforeTokenTransfer(from, to, amount);
758     }
759     
760 }