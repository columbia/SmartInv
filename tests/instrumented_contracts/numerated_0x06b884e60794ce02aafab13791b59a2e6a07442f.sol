1 // Sources flattened with hardhat v2.6.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.2.0
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.2.0
88 
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 
115 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
116 
117 
118 pragma solidity ^0.8.0;
119 
120 /*
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
140 
141 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.2.0
142 
143 
144 pragma solidity ^0.8.0;
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
287     function transferFrom(
288         address sender,
289         address recipient,
290         uint256 amount
291     ) public virtual override returns (bool) {
292         _transfer(sender, recipient, amount);
293 
294         uint256 currentAllowance = _allowances[sender][_msgSender()];
295         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
296         unchecked {
297             _approve(sender, _msgSender(), currentAllowance - amount);
298         }
299 
300         return true;
301     }
302 
303     /**
304      * @dev Atomically increases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to {approve} that can be used as a mitigation for
307      * problems described in {IERC20-approve}.
308      *
309      * Emits an {Approval} event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
316         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
317         return true;
318     }
319 
320     /**
321      * @dev Atomically decreases the allowance granted to `spender` by the caller.
322      *
323      * This is an alternative to {approve} that can be used as a mitigation for
324      * problems described in {IERC20-approve}.
325      *
326      * Emits an {Approval} event indicating the updated allowance.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      * - `spender` must have allowance for the caller of at least
332      * `subtractedValue`.
333      */
334     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
335         uint256 currentAllowance = _allowances[_msgSender()][spender];
336         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
337         unchecked {
338             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
339         }
340 
341         return true;
342     }
343 
344     /**
345      * @dev Moves `amount` of tokens from `sender` to `recipient`.
346      *
347      * This internal function is equivalent to {transfer}, and can be used to
348      * e.g. implement automatic token fees, slashing mechanisms, etc.
349      *
350      * Emits a {Transfer} event.
351      *
352      * Requirements:
353      *
354      * - `sender` cannot be the zero address.
355      * - `recipient` cannot be the zero address.
356      * - `sender` must have a balance of at least `amount`.
357      */
358     function _transfer(
359         address sender,
360         address recipient,
361         uint256 amount
362     ) internal virtual {
363         require(sender != address(0), "ERC20: transfer from the zero address");
364         require(recipient != address(0), "ERC20: transfer to the zero address");
365 
366         _beforeTokenTransfer(sender, recipient, amount);
367 
368         uint256 senderBalance = _balances[sender];
369         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
370         unchecked {
371             _balances[sender] = senderBalance - amount;
372         }
373         _balances[recipient] += amount;
374 
375         emit Transfer(sender, recipient, amount);
376 
377         _afterTokenTransfer(sender, recipient, amount);
378     }
379 
380     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
381      * the total supply.
382      *
383      * Emits a {Transfer} event with `from` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      */
389     function _mint(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: mint to the zero address");
391 
392         _beforeTokenTransfer(address(0), account, amount);
393 
394         _totalSupply += amount;
395         _balances[account] += amount;
396         emit Transfer(address(0), account, amount);
397 
398         _afterTokenTransfer(address(0), account, amount);
399     }
400 
401     /**
402      * @dev Destroys `amount` tokens from `account`, reducing the
403      * total supply.
404      *
405      * Emits a {Transfer} event with `to` set to the zero address.
406      *
407      * Requirements:
408      *
409      * - `account` cannot be the zero address.
410      * - `account` must have at least `amount` tokens.
411      */
412     function _burn(address account, uint256 amount) internal virtual {
413         require(account != address(0), "ERC20: burn from the zero address");
414 
415         _beforeTokenTransfer(account, address(0), amount);
416 
417         uint256 accountBalance = _balances[account];
418         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
419         unchecked {
420             _balances[account] = accountBalance - amount;
421         }
422         _totalSupply -= amount;
423 
424         emit Transfer(account, address(0), amount);
425 
426         _afterTokenTransfer(account, address(0), amount);
427     }
428 
429     /**
430      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
431      *
432      * This internal function is equivalent to `approve`, and can be used to
433      * e.g. set automatic allowances for certain subsystems, etc.
434      *
435      * Emits an {Approval} event.
436      *
437      * Requirements:
438      *
439      * - `owner` cannot be the zero address.
440      * - `spender` cannot be the zero address.
441      */
442     function _approve(
443         address owner,
444         address spender,
445         uint256 amount
446     ) internal virtual {
447         require(owner != address(0), "ERC20: approve from the zero address");
448         require(spender != address(0), "ERC20: approve to the zero address");
449 
450         _allowances[owner][spender] = amount;
451         emit Approval(owner, spender, amount);
452     }
453 
454     /**
455      * @dev Hook that is called before any transfer of tokens. This includes
456      * minting and burning.
457      *
458      * Calling conditions:
459      *
460      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
461      * will be transferred to `to`.
462      * - when `from` is zero, `amount` tokens will be minted for `to`.
463      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
464      * - `from` and `to` are never both zero.
465      *
466      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
467      */
468     function _beforeTokenTransfer(
469         address from,
470         address to,
471         uint256 amount
472     ) internal virtual {}
473 
474     /**
475      * @dev Hook that is called after any transfer of tokens. This includes
476      * minting and burning.
477      *
478      * Calling conditions:
479      *
480      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
481      * has been transferred to `to`.
482      * - when `from` is zero, `amount` tokens have been minted for `to`.
483      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
484      * - `from` and `to` are never both zero.
485      *
486      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
487      */
488     function _afterTokenTransfer(
489         address from,
490         address to,
491         uint256 amount
492     ) internal virtual {}
493 }
494 
495 
496 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.2.0
497 
498 
499 pragma solidity ^0.8.0;
500 
501 
502 /**
503  * @dev Extension of {ERC20} that allows token holders to destroy both their own
504  * tokens and those that they have an allowance for, in a way that can be
505  * recognized off-chain (via event analysis).
506  */
507 abstract contract ERC20Burnable is Context, ERC20 {
508     /**
509      * @dev Destroys `amount` tokens from the caller.
510      *
511      * See {ERC20-_burn}.
512      */
513     function burn(uint256 amount) public virtual {
514         _burn(_msgSender(), amount);
515     }
516 
517     /**
518      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
519      * allowance.
520      *
521      * See {ERC20-_burn} and {ERC20-allowance}.
522      *
523      * Requirements:
524      *
525      * - the caller must have allowance for ``accounts``'s tokens of at least
526      * `amount`.
527      */
528     function burnFrom(address account, uint256 amount) public virtual {
529         uint256 currentAllowance = allowance(account, _msgSender());
530         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
531         unchecked {
532             _approve(account, _msgSender(), currentAllowance - amount);
533         }
534         _burn(account, amount);
535     }
536 }
537 
538 
539 // File @openzeppelin/contracts/security/Pausable.sol@v4.2.0
540 
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @dev Contract module which allows children to implement an emergency stop
546  * mechanism that can be triggered by an authorized account.
547  *
548  * This module is used through inheritance. It will make available the
549  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
550  * the functions of your contract. Note that they will not be pausable by
551  * simply including this module, only once the modifiers are put in place.
552  */
553 abstract contract Pausable is Context {
554     /**
555      * @dev Emitted when the pause is triggered by `account`.
556      */
557     event Paused(address account);
558 
559     /**
560      * @dev Emitted when the pause is lifted by `account`.
561      */
562     event Unpaused(address account);
563 
564     bool private _paused;
565 
566     /**
567      * @dev Initializes the contract in unpaused state.
568      */
569     constructor() {
570         _paused = false;
571     }
572 
573     /**
574      * @dev Returns true if the contract is paused, and false otherwise.
575      */
576     function paused() public view virtual returns (bool) {
577         return _paused;
578     }
579 
580     /**
581      * @dev Modifier to make a function callable only when the contract is not paused.
582      *
583      * Requirements:
584      *
585      * - The contract must not be paused.
586      */
587     modifier whenNotPaused() {
588         require(!paused(), "Pausable: paused");
589         _;
590     }
591 
592     /**
593      * @dev Modifier to make a function callable only when the contract is paused.
594      *
595      * Requirements:
596      *
597      * - The contract must be paused.
598      */
599     modifier whenPaused() {
600         require(paused(), "Pausable: not paused");
601         _;
602     }
603 
604     /**
605      * @dev Triggers stopped state.
606      *
607      * Requirements:
608      *
609      * - The contract must not be paused.
610      */
611     function _pause() internal virtual whenNotPaused {
612         _paused = true;
613         emit Paused(_msgSender());
614     }
615 
616     /**
617      * @dev Returns to normal state.
618      *
619      * Requirements:
620      *
621      * - The contract must be paused.
622      */
623     function _unpause() internal virtual whenPaused {
624         _paused = false;
625         emit Unpaused(_msgSender());
626     }
627 }
628 
629 
630 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
631 
632 
633 pragma solidity ^0.8.0;
634 
635 /**
636  * @dev Contract module which provides a basic access control mechanism, where
637  * there is an account (an owner) that can be granted exclusive access to
638  * specific functions.
639  *
640  * By default, the owner account will be the one that deploys the contract. This
641  * can later be changed with {transferOwnership}.
642  *
643  * This module is used through inheritance. It will make available the modifier
644  * `onlyOwner`, which can be applied to your functions to restrict their use to
645  * the owner.
646  */
647 abstract contract Ownable is Context {
648     address private _owner;
649 
650     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
651 
652     /**
653      * @dev Initializes the contract setting the deployer as the initial owner.
654      */
655     constructor() {
656         _setOwner(_msgSender());
657     }
658 
659     /**
660      * @dev Returns the address of the current owner.
661      */
662     function owner() public view virtual returns (address) {
663         return _owner;
664     }
665 
666     /**
667      * @dev Throws if called by any account other than the owner.
668      */
669     modifier onlyOwner() {
670         require(owner() == _msgSender(), "Ownable: caller is not the owner");
671         _;
672     }
673 
674     /**
675      * @dev Leaves the contract without owner. It will not be possible to call
676      * `onlyOwner` functions anymore. Can only be called by the current owner.
677      *
678      * NOTE: Renouncing ownership will leave the contract without an owner,
679      * thereby removing any functionality that is only available to the owner.
680      */
681     function renounceOwnership() public virtual onlyOwner {
682         _setOwner(address(0));
683     }
684 
685     /**
686      * @dev Transfers ownership of the contract to a new account (`newOwner`).
687      * Can only be called by the current owner.
688      */
689     function transferOwnership(address newOwner) public virtual onlyOwner {
690         require(newOwner != address(0), "Ownable: new owner is the zero address");
691         _setOwner(newOwner);
692     }
693 
694     function _setOwner(address newOwner) private {
695         address oldOwner = _owner;
696         _owner = newOwner;
697         emit OwnershipTransferred(oldOwner, newOwner);
698     }
699 }
700 
701 
702 // File contracts/UnbankedToken.sol
703 
704 /*
705   _   _       _                 _            _ 
706  | | | |_ __ | |__   __ _ _ __ | | _____  __| |
707  | | | | '_ \| '_ \ / _` | '_ \| |/ / _ \/ _` |
708  | |_| | | | | |_) | (_| | | | |   <  __/ (_| |
709   \___/|_| |_|_.__/ \__,_|_| |_|_|\_\___|\__,_|
710 
711  01100010 01111001 00100000 01000001 01110011 01110011 
712  01110101 01101110 01100101 00100000 01000011 01101111 
713  01110100 01101100 01100001 01100111 01100101
714  
715  */
716 
717 
718 
719 // SPDX-License-Identifier: MIT
720 pragma solidity ^0.8.2;
721 
722 
723 
724 
725 contract Unbanked is ERC20, ERC20Burnable, Pausable, Ownable {
726     constructor() ERC20("Unbanked", "UNBNK") {
727         _mint(msg.sender, 500000000 * 10 ** decimals());
728     }
729 
730     function pause() public onlyOwner {
731         _pause();
732     }
733 
734     function unpause() public onlyOwner {
735         _unpause();
736     }
737 
738     function mint(address to, uint256 amount) public onlyOwner {
739         _mint(to, amount);
740     }
741     
742     function _beforeTokenTransfer(address from, address to, uint256 amount)
743         internal
744         whenNotPaused
745         override
746     {
747         super._beforeTokenTransfer(from, to, amount);
748     }
749 }