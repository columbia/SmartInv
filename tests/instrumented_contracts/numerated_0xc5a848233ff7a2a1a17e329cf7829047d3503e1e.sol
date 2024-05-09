1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `to`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address to, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `from` to `to` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address from,
69         address to,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.5.0
90 
91 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
92 
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 
117 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
120 
121 
122 /**
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 
143 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.5.0
144 
145 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
146 
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
323         _approve(owner, spender, _allowances[owner][spender] + addedValue);
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
343         uint256 currentAllowance = _allowances[owner][spender];
344         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
345         unchecked {
346             _approve(owner, spender, currentAllowance - subtractedValue);
347         }
348 
349         return true;
350     }
351 
352     /**
353      * @dev Moves `amount` of tokens from `sender` to `recipient`.
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
463      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
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
525 
526 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.5.0
527 
528 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
529 
530 
531 
532 /**
533  * @dev Extension of {ERC20} that allows token holders to destroy both their own
534  * tokens and those that they have an allowance for, in a way that can be
535  * recognized off-chain (via event analysis).
536  */
537 abstract contract ERC20Burnable is Context, ERC20 {
538     /**
539      * @dev Destroys `amount` tokens from the caller.
540      *
541      * See {ERC20-_burn}.
542      */
543     function burn(uint256 amount) public virtual {
544         _burn(_msgSender(), amount);
545     }
546 
547     /**
548      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
549      * allowance.
550      *
551      * See {ERC20-_burn} and {ERC20-allowance}.
552      *
553      * Requirements:
554      *
555      * - the caller must have allowance for ``accounts``'s tokens of at least
556      * `amount`.
557      */
558     function burnFrom(address account, uint256 amount) public virtual {
559         _spendAllowance(account, _msgSender(), amount);
560         _burn(account, amount);
561     }
562 }
563 
564 
565 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
566 
567 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
568 
569 
570 /**
571  * @dev Contract module which provides a basic access control mechanism, where
572  * there is an account (an owner) that can be granted exclusive access to
573  * specific functions.
574  *
575  * By default, the owner account will be the one that deploys the contract. This
576  * can later be changed with {transferOwnership}.
577  *
578  * This module is used through inheritance. It will make available the modifier
579  * `onlyOwner`, which can be applied to your functions to restrict their use to
580  * the owner.
581  */
582 abstract contract Ownable is Context {
583     address private _owner;
584 
585     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
586 
587     /**
588      * @dev Initializes the contract setting the deployer as the initial owner.
589      */
590     constructor() {
591         _transferOwnership(_msgSender());
592     }
593 
594     /**
595      * @dev Returns the address of the current owner.
596      */
597     function owner() public view virtual returns (address) {
598         return _owner;
599     }
600 
601     /**
602      * @dev Throws if called by any account other than the owner.
603      */
604     modifier onlyOwner() {
605         require(owner() == _msgSender(), "Ownable: caller is not the owner");
606         _;
607     }
608 
609     /**
610      * @dev Leaves the contract without owner. It will not be possible to call
611      * `onlyOwner` functions anymore. Can only be called by the current owner.
612      *
613      * NOTE: Renouncing ownership will leave the contract without an owner,
614      * thereby removing any functionality that is only available to the owner.
615      */
616     function renounceOwnership() public virtual onlyOwner {
617         _transferOwnership(address(0));
618     }
619 
620     /**
621      * @dev Transfers ownership of the contract to a new account (`newOwner`).
622      * Can only be called by the current owner.
623      */
624     function transferOwnership(address newOwner) public virtual onlyOwner {
625         require(newOwner != address(0), "Ownable: new owner is the zero address");
626         _transferOwnership(newOwner);
627     }
628 
629     /**
630      * @dev Transfers ownership of the contract to a new account (`newOwner`).
631      * Internal function without access restriction.
632      */
633     function _transferOwnership(address newOwner) internal virtual {
634         address oldOwner = _owner;
635         _owner = newOwner;
636         emit OwnershipTransferred(oldOwner, newOwner);
637     }
638 }
639 
640 
641 // File contracts/JungleCoin.sol
642 
643 
644 
645 contract JungleCoin is ERC20Burnable, Ownable {
646 
647     uint public maxSupply;
648     bool public maxSupplyLocked;
649 
650     mapping (address => bool) public isMinter;
651 
652     event SetMinter(address account, bool isMinter);
653     event SetMaxSupply(uint amount);
654     event MaxSupplyLocked();
655 
656     constructor() ERC20("JUNGLECOIN", "JLC") {}
657 
658     function setMaxSupply(uint _maxSupply) external onlyOwner {
659         require(!maxSupplyLocked, "Already locked");
660         require(totalSupply() <= _maxSupply, "Too small");
661         maxSupply = _maxSupply;
662         emit SetMaxSupply(_maxSupply);
663     }
664 
665     function lockMaxSupply() external onlyOwner {
666         require(!maxSupplyLocked, "Already locked");
667         maxSupplyLocked = true;
668         emit MaxSupplyLocked();
669     }
670 
671     function setMinter(address _account) external onlyOwner {
672         isMinter[_account] = true;
673         emit SetMinter(_account, true);
674     }
675 
676     function removeMinter(address _account) external onlyOwner {
677         isMinter[_account] = false;
678         emit SetMinter(_account, false);
679     }
680 
681     function mint(address _account, uint _amount) external {
682         require(isMinter[msg.sender], "NOT AUTHORIZED");
683         require(totalSupply() + _amount <= maxSupply, "Max supply");
684         _mint(_account, _amount);
685     }
686 
687 }