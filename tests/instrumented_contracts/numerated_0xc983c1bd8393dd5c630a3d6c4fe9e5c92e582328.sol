1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-29
3 */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/access/Ownable.sol
33 
34 
35 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         _checkOwner();
69         _;
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if the sender is not the owner.
81      */
82     function _checkOwner() internal view virtual {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
118 
119 
120 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Interface of the ERC20 standard as defined in the EIP.
126  */
127 interface IERC20 {
128     /**
129      * @dev Emitted when `value` tokens are moved from one account (`from`) to
130      * another (`to`).
131      *
132      * Note that `value` may be zero.
133      */
134     event Transfer(address indexed from, address indexed to, uint256 value);
135 
136     /**
137      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
138      * a call to {approve}. `value` is the new allowance.
139      */
140     event Approval(address indexed owner, address indexed spender, uint256 value);
141 
142     /**
143      * @dev Returns the amount of tokens in existence.
144      */
145     function totalSupply() external view returns (uint256);
146 
147     /**
148      * @dev Returns the amount of tokens owned by `account`.
149      */
150     function balanceOf(address account) external view returns (uint256);
151 
152     /**
153      * @dev Moves `amount` tokens from the caller's account to `to`.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transfer(address to, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Returns the remaining number of tokens that `spender` will be
163      * allowed to spend on behalf of `owner` through {transferFrom}. This is
164      * zero by default.
165      *
166      * This value changes when {approve} or {transferFrom} are called.
167      */
168     function allowance(address owner, address spender) external view returns (uint256);
169 
170     /**
171      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * IMPORTANT: Beware that changing an allowance with this method brings the risk
176      * that someone may use both the old and the new allowance by unfortunate
177      * transaction ordering. One possible solution to mitigate this race
178      * condition is to first reduce the spender's allowance to 0 and set the
179      * desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      *
182      * Emits an {Approval} event.
183      */
184     function approve(address spender, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Moves `amount` tokens from `from` to `to` using the
188      * allowance mechanism. `amount` is then deducted from the caller's
189      * allowance.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(
196         address from,
197         address to,
198         uint256 amount
199     ) external returns (bool);
200 }
201 
202 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
203 
204 
205 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
206 
207 pragma solidity ^0.8.0;
208 
209 
210 /**
211  * @dev Interface for the optional metadata functions from the ERC20 standard.
212  *
213  * _Available since v4.1._
214  */
215 interface IERC20Metadata is IERC20 {
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the symbol of the token.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the decimals places of the token.
228      */
229     function decimals() external view returns (uint8);
230 }
231 
232 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
233 
234 
235 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 
240 
241 
242 /**
243  * @dev Implementation of the {IERC20} interface.
244  *
245  * This implementation is agnostic to the way tokens are created. This means
246  * that a supply mechanism has to be added in a derived contract using {_mint}.
247  * For a generic mechanism see {ERC20PresetMinterPauser}.
248  *
249  * TIP: For a detailed writeup see our guide
250  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
251  * to implement supply mechanisms].
252  *
253  * We have followed general OpenZeppelin Contracts guidelines: functions revert
254  * instead returning `false` on failure. This behavior is nonetheless
255  * conventional and does not conflict with the expectations of ERC20
256  * applications.
257  *
258  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
259  * This allows applications to reconstruct the allowance for all accounts just
260  * by listening to said events. Other implementations of the EIP may not emit
261  * these events, as it isn't required by the specification.
262  *
263  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
264  * functions have been added to mitigate the well-known issues around setting
265  * allowances. See {IERC20-approve}.
266  */
267 contract ERC20 is Context, IERC20, IERC20Metadata {
268     mapping(address => uint256) private _balances;
269 
270     mapping(address => mapping(address => uint256)) private _allowances;
271 
272     uint256 private _totalSupply;
273 
274     string private _name;
275     string private _symbol;
276 
277     /**
278      * @dev Sets the values for {name} and {symbol}.
279      *
280      * The default value of {decimals} is 18. To select a different value for
281      * {decimals} you should overload it.
282      *
283      * All two of these values are immutable: they can only be set once during
284      * construction.
285      */
286     constructor(string memory name_, string memory symbol_) {
287         _name = name_;
288         _symbol = symbol_;
289     }
290 
291     /**
292      * @dev Returns the name of the token.
293      */
294     function name() public view virtual override returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @dev Returns the symbol of the token, usually a shorter version of the
300      * name.
301      */
302     function symbol() public view virtual override returns (string memory) {
303         return _symbol;
304     }
305 
306     /**
307      * @dev Returns the number of decimals used to get its user representation.
308      * For example, if `decimals` equals `2`, a balance of `505` tokens should
309      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
310      *
311      * Tokens usually opt for a value of 18, imitating the relationship between
312      * Ether and Wei. This is the value {ERC20} uses, unless this function is
313      * overridden;
314      *
315      * NOTE: This information is only used for _display_ purposes: it in
316      * no way affects any of the arithmetic of the contract, including
317      * {IERC20-balanceOf} and {IERC20-transfer}.
318      */
319     function decimals() public view virtual override returns (uint8) {
320         return 18;
321     }
322 
323     /**
324      * @dev See {IERC20-totalSupply}.
325      */
326     function totalSupply() public view virtual override returns (uint256) {
327         return _totalSupply;
328     }
329 
330     /**
331      * @dev See {IERC20-balanceOf}.
332      */
333     function balanceOf(address account) public view virtual override returns (uint256) {
334         return _balances[account];
335     }
336 
337     /**
338      * @dev See {IERC20-transfer}.
339      *
340      * Requirements:
341      *
342      * - `to` cannot be the zero address.
343      * - the caller must have a balance of at least `amount`.
344      */
345     function transfer(address to, uint256 amount) public virtual override returns (bool) {
346         address owner = _msgSender();
347         _transfer(owner, to, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-allowance}.
353      */
354     function allowance(address owner, address spender) public view virtual override returns (uint256) {
355         return _allowances[owner][spender];
356     }
357 
358     /**
359      * @dev See {IERC20-approve}.
360      *
361      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
362      * `transferFrom`. This is semantically equivalent to an infinite approval.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function approve(address spender, uint256 amount) public virtual override returns (bool) {
369         address owner = _msgSender();
370         _approve(owner, spender, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-transferFrom}.
376      *
377      * Emits an {Approval} event indicating the updated allowance. This is not
378      * required by the EIP. See the note at the beginning of {ERC20}.
379      *
380      * NOTE: Does not update the allowance if the current allowance
381      * is the maximum `uint256`.
382      *
383      * Requirements:
384      *
385      * - `from` and `to` cannot be the zero address.
386      * - `from` must have a balance of at least `amount`.
387      * - the caller must have allowance for ``from``'s tokens of at least
388      * `amount`.
389      */
390     function transferFrom(
391         address from,
392         address to,
393         uint256 amount
394     ) public virtual override returns (bool) {
395         address spender = _msgSender();
396         _spendAllowance(from, spender, amount);
397         _transfer(from, to, amount);
398         return true;
399     }
400 
401     /**
402      * @dev Atomically increases the allowance granted to `spender` by the caller.
403      *
404      * This is an alternative to {approve} that can be used as a mitigation for
405      * problems described in {IERC20-approve}.
406      *
407      * Emits an {Approval} event indicating the updated allowance.
408      *
409      * Requirements:
410      *
411      * - `spender` cannot be the zero address.
412      */
413     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
414         address owner = _msgSender();
415         _approve(owner, spender, allowance(owner, spender) + addedValue);
416         return true;
417     }
418 
419     /**
420      * @dev Atomically decreases the allowance granted to `spender` by the caller.
421      *
422      * This is an alternative to {approve} that can be used as a mitigation for
423      * problems described in {IERC20-approve}.
424      *
425      * Emits an {Approval} event indicating the updated allowance.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      * - `spender` must have allowance for the caller of at least
431      * `subtractedValue`.
432      */
433     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
434         address owner = _msgSender();
435         uint256 currentAllowance = allowance(owner, spender);
436         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
437         unchecked {
438             _approve(owner, spender, currentAllowance - subtractedValue);
439         }
440 
441         return true;
442     }
443 
444     /**
445      * @dev Moves `amount` of tokens from `from` to `to`.
446      *
447      * This internal function is equivalent to {transfer}, and can be used to
448      * e.g. implement automatic token fees, slashing mechanisms, etc.
449      *
450      * Emits a {Transfer} event.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `from` must have a balance of at least `amount`.
457      */
458     function _transfer(
459         address from,
460         address to,
461         uint256 amount
462     ) internal virtual {
463         require(from != address(0), "ERC20: transfer from the zero address");
464         require(to != address(0), "ERC20: transfer to the zero address");
465 
466         _beforeTokenTransfer(from, to, amount);
467 
468         uint256 fromBalance = _balances[from];
469         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
470         unchecked {
471             _balances[from] = fromBalance - amount;
472             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
473             // decrementing then incrementing.
474             _balances[to] += amount;
475         }
476 
477         emit Transfer(from, to, amount);
478 
479         _afterTokenTransfer(from, to, amount);
480     }
481 
482     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
483      * the total supply.
484      *
485      * Emits a {Transfer} event with `from` set to the zero address.
486      *
487      * Requirements:
488      *
489      * - `account` cannot be the zero address.
490      */
491     function _mint(address account, uint256 amount) internal virtual {
492         require(account != address(0), "ERC20: mint to the zero address");
493 
494         _beforeTokenTransfer(address(0), account, amount);
495 
496         _totalSupply += amount;
497         unchecked {
498             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
499             _balances[account] += amount;
500         }
501         emit Transfer(address(0), account, amount);
502 
503         _afterTokenTransfer(address(0), account, amount);
504     }
505 
506     /**
507      * @dev Destroys `amount` tokens from `account`, reducing the
508      * total supply.
509      *
510      * Emits a {Transfer} event with `to` set to the zero address.
511      *
512      * Requirements:
513      *
514      * - `account` cannot be the zero address.
515      * - `account` must have at least `amount` tokens.
516      */
517     function _burn(address account, uint256 amount) internal virtual {
518         require(account != address(0), "ERC20: burn from the zero address");
519 
520         _beforeTokenTransfer(account, address(0), amount);
521 
522         uint256 accountBalance = _balances[account];
523         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
524         unchecked {
525             _balances[account] = accountBalance - amount;
526             // Overflow not possible: amount <= accountBalance <= totalSupply.
527             _totalSupply -= amount;
528         }
529 
530         emit Transfer(account, address(0), amount);
531 
532         _afterTokenTransfer(account, address(0), amount);
533     }
534 
535     /**
536      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
537      *
538      * This internal function is equivalent to `approve`, and can be used to
539      * e.g. set automatic allowances for certain subsystems, etc.
540      *
541      * Emits an {Approval} event.
542      *
543      * Requirements:
544      *
545      * - `owner` cannot be the zero address.
546      * - `spender` cannot be the zero address.
547      */
548     function _approve(
549         address owner,
550         address spender,
551         uint256 amount
552     ) internal virtual {
553         require(owner != address(0), "ERC20: approve from the zero address");
554         require(spender != address(0), "ERC20: approve to the zero address");
555 
556         _allowances[owner][spender] = amount;
557         emit Approval(owner, spender, amount);
558     }
559 
560     /**
561      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
562      *
563      * Does not update the allowance amount in case of infinite allowance.
564      * Revert if not enough allowance is available.
565      *
566      * Might emit an {Approval} event.
567      */
568     function _spendAllowance(
569         address owner,
570         address spender,
571         uint256 amount
572     ) internal virtual {
573         uint256 currentAllowance = allowance(owner, spender);
574         if (currentAllowance != type(uint256).max) {
575             require(currentAllowance >= amount, "ERC20: insufficient allowance");
576             unchecked {
577                 _approve(owner, spender, currentAllowance - amount);
578             }
579         }
580     }
581 
582     /**
583      * @dev Hook that is called before any transfer of tokens. This includes
584      * minting and burning.
585      *
586      * Calling conditions:
587      *
588      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
589      * will be transferred to `to`.
590      * - when `from` is zero, `amount` tokens will be minted for `to`.
591      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
592      * - `from` and `to` are never both zero.
593      *
594      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
595      */
596     function _beforeTokenTransfer(
597         address from,
598         address to,
599         uint256 amount
600     ) internal virtual {}
601 
602     /**
603      * @dev Hook that is called after any transfer of tokens. This includes
604      * minting and burning.
605      *
606      * Calling conditions:
607      *
608      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
609      * has been transferred to `to`.
610      * - when `from` is zero, `amount` tokens have been minted for `to`.
611      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
612      * - `from` and `to` are never both zero.
613      *
614      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
615      */
616     function _afterTokenTransfer(
617         address from,
618         address to,
619         uint256 amount
620     ) internal virtual {}
621 }
622 
623 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
624 
625 
626 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 
631 
632 /**
633  * @dev Extension of {ERC20} that allows token holders to destroy both their own
634  * tokens and those that they have an allowance for, in a way that can be
635  * recognized off-chain (via event analysis).
636  */
637 abstract contract ERC20Burnable is Context, ERC20 {
638     /**
639      * @dev Destroys `amount` tokens from the caller.
640      *
641      * See {ERC20-_burn}.
642      */
643     function burn(uint256 amount) public virtual {
644         _burn(_msgSender(), amount);
645     }
646 
647     /**
648      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
649      * allowance.
650      *
651      * See {ERC20-_burn} and {ERC20-allowance}.
652      *
653      * Requirements:
654      *
655      * - the caller must have allowance for ``accounts``'s tokens of at least
656      * `amount`.
657      */
658     function burnFrom(address account, uint256 amount) public virtual {
659         _spendAllowance(account, _msgSender(), amount);
660         _burn(account, amount);
661     }
662 }
663 
664 // File: contracts/KekyaToken.sol
665 
666 
667 pragma solidity ^0.8.0;
668 
669 
670 
671 
672 contract Kekya is ERC20, ERC20Burnable, Ownable {
673     uint256 private constant INITIAL_SUPPLY = 10000000000 * 10**18;
674 
675     constructor() ERC20("Kekya", "Kekya") {
676         _mint(msg.sender, INITIAL_SUPPLY);
677     }
678 
679     function distributeTokens(address distributionWallet) external onlyOwner {
680         uint256 supply = balanceOf(msg.sender);
681         require(supply == INITIAL_SUPPLY, "Tokens already distributed");
682 
683         _transfer(msg.sender, distributionWallet, supply);
684     }
685 }