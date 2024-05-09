1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9 
10  * This contract is only required for intermediate, library-like contracts.
11  */
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 // File: @openzeppelin/contracts/access/Ownable.sol
23 
24 
25 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor() {
51         _transferOwnership(_msgSender());
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         _checkOwner();
59         _;
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if the sender is not the owner.
71      */
72     function _checkOwner() internal view virtual {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
108 
109 
110 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP.
116  */
117 interface IERC20 {
118     /**
119      * @dev Emitted when `value` tokens are moved from one account (`from`) to
120      * another (`to`).
121      *
122      * Note that `value` may be zero.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 
126     /**
127      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
128      * a call to {approve}. `value` is the new allowance.
129      */
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 
132     /**
133      * @dev Returns the amount of tokens in existence.
134      */
135     function totalSupply() external view returns (uint256);
136 
137     /**
138      * @dev Returns the amount of tokens owned by `account`.
139      */
140     function balanceOf(address account) external view returns (uint256);
141 
142     /**
143      * @dev Moves `amount` tokens from the caller's account to `to`.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transfer(address to, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Returns the remaining number of tokens that `spender` will be
153      * allowed to spend on behalf of `owner` through {transferFrom}. This is
154      * zero by default.
155      *
156      * This value changes when {approve} or {transferFrom} are called.
157      */
158     function allowance(address owner, address spender) external view returns (uint256);
159 
160     /**
161      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * IMPORTANT: Beware that changing an allowance with this method brings the risk
166      * that someone may use both the old and the new allowance by unfortunate
167      * transaction ordering. One possible solution to mitigate this race
168      * condition is to first reduce the spender's allowance to 0 and set the
169      * desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      *
172      * Emits an {Approval} event.
173      */
174     function approve(address spender, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Moves `amount` tokens from `from` to `to` using the
178      * allowance mechanism. `amount` is then deducted from the caller's
179      * allowance.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transferFrom(
186         address from,
187         address to,
188         uint256 amount
189     ) external returns (bool);
190 }
191 
192 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 
200 /**
201  * @dev Interface for the optional metadata functions from the ERC20 standard.
202  *
203  * _Available since v4.1._
204  */
205 interface IERC20Metadata is IERC20 {
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the symbol of the token.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the decimals places of the token.
218      */
219     function decimals() external view returns (uint8);
220 }
221 
222 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
223 
224 
225 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 
230 
231 
232 /**
233  * @dev Implementation of the {IERC20} interface.
234  *
235  * This implementation is agnostic to the way tokens are created. This means
236  * that a supply mechanism has to be added in a derived contract using {_mint}.
237  * For a generic mechanism see {ERC20PresetMinterPauser}.
238  *
239  * TIP: For a detailed writeup see our guide
240  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
241  * to implement supply mechanisms].
242  *
243  * We have followed general OpenZeppelin Contracts guidelines: functions revert
244  * instead returning `false` on failure. This behavior is nonetheless
245  * conventional and does not conflict with the expectations of ERC20
246  * applications.
247  *
248  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
249  * This allows applications to reconstruct the allowance for all accounts just
250  * by listening to said events. Other implementations of the EIP may not emit
251  * these events, as it isn't required by the specification.
252  *
253  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
254  * functions have been added to mitigate the well-known issues around setting
255  * allowances. See {IERC20-approve}.
256  */
257 contract ERC20 is Context, IERC20, IERC20Metadata {
258     mapping(address => uint256) private _balances;
259 
260     mapping(address => mapping(address => uint256)) private _allowances;
261 
262     uint256 private _totalSupply;
263 
264     string private _name;
265     string private _symbol;
266 
267     /**
268      * @dev Sets the values for {name} and {symbol}.
269      *
270      * The default value of {decimals} is 18. To select a different value for
271      * {decimals} you should overload it.
272      *
273      * All two of these values are immutable: they can only be set once during
274      * construction.
275      */
276     constructor(string memory name_, string memory symbol_) {
277         _name = name_;
278         _symbol = symbol_;
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view virtual override returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view virtual override returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      * For example, if `decimals` equals `2`, a balance of `505` tokens should
299      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
300      *
301      * Tokens usually opt for a value of 18, imitating the relationship between
302      * Ether and Wei. This is the value {ERC20} uses, unless this function is
303      * overridden;
304      *
305      * NOTE: This information is only used for _display_ purposes: it in
306      * no way affects any of the arithmetic of the contract, including
307      * {IERC20-balanceOf} and {IERC20-transfer}.
308      */
309     function decimals() public view virtual override returns (uint8) {
310         return 18;
311     }
312 
313     /**
314      * @dev See {IERC20-totalSupply}.
315      */
316     function totalSupply() public view virtual override returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {IERC20-balanceOf}.
322      */
323     function balanceOf(address account) public view virtual override returns (uint256) {
324         return _balances[account];
325     }
326 
327     /**
328      * @dev See {IERC20-transfer}.
329      *
330      * Requirements:
331      *
332      * - `to` cannot be the zero address.
333      * - the caller must have a balance of at least `amount`.
334      */
335     function transfer(address to, uint256 amount) public virtual override returns (bool) {
336         address owner = _msgSender();
337         _transfer(owner, to, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-allowance}.
343      */
344     function allowance(address owner, address spender) public view virtual override returns (uint256) {
345         return _allowances[owner][spender];
346     }
347 
348     /**
349      * @dev See {IERC20-approve}.
350      *
351      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
352      * `transferFrom`. This is semantically equivalent to an infinite approval.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      */
358     function approve(address spender, uint256 amount) public virtual override returns (bool) {
359         address owner = _msgSender();
360         _approve(owner, spender, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-transferFrom}.
366      *
367      * Emits an {Approval} event indicating the updated allowance. This is not
368      * required by the EIP. See the note at the beginning of {ERC20}.
369      *
370      * NOTE: Does not update the allowance if the current allowance
371      * is the maximum `uint256`.
372      *
373      * Requirements:
374      *
375      * - `from` and `to` cannot be the zero address.
376      * - `from` must have a balance of at least `amount`.
377      * - the caller must have allowance for ``from``'s tokens of at least
378      * `amount`.
379      */
380     function transferFrom(
381         address from,
382         address to,
383         uint256 amount
384     ) public virtual override returns (bool) {
385         address spender = _msgSender();
386         _spendAllowance(from, spender, amount);
387         _transfer(from, to, amount);
388         return true;
389     }
390 
391     /**
392      * @dev Atomically increases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to {approve} that can be used as a mitigation for
395      * problems described in {IERC20-approve}.
396      *
397      * Emits an {Approval} event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      */
403     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
404         address owner = _msgSender();
405         _approve(owner, spender, allowance(owner, spender) + addedValue);
406         return true;
407     }
408 
409     /**
410      * @dev Atomically decreases the allowance granted to `spender` by the caller.
411      *
412      * This is an alternative to {approve} that can be used as a mitigation for
413      * problems described in {IERC20-approve}.
414      *
415      * Emits an {Approval} event indicating the updated allowance.
416      *
417      * Requirements:
418      *
419      * - `spender` cannot be the zero address.
420      * - `spender` must have allowance for the caller of at least
421      * `subtractedValue`.
422      */
423     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
424         address owner = _msgSender();
425         uint256 currentAllowance = allowance(owner, spender);
426         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
427         unchecked {
428             _approve(owner, spender, currentAllowance - subtractedValue);
429         }
430 
431         return true;
432     }
433 
434     /**
435      * @dev Moves `amount` of tokens from `from` to `to`.
436      *
437      * This internal function is equivalent to {transfer}, and can be used to
438      * e.g. implement automatic token fees, slashing mechanisms, etc.
439      *
440      * Emits a {Transfer} event.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `from` must have a balance of at least `amount`.
447      */
448     function _transfer(
449         address from,
450         address to,
451         uint256 amount
452     ) internal virtual {
453         require(from != address(0), "ERC20: transfer from the zero address");
454         require(to != address(0), "ERC20: transfer to the zero address");
455 
456         _beforeTokenTransfer(from, to, amount);
457 
458         uint256 fromBalance = _balances[from];
459         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
460         unchecked {
461             _balances[from] = fromBalance - amount;
462             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
463             // decrementing then incrementing.
464             _balances[to] += amount;
465         }
466 
467         emit Transfer(from, to, amount);
468 
469         _afterTokenTransfer(from, to, amount);
470     }
471 
472     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
473      * the total supply.
474      *
475      * Emits a {Transfer} event with `from` set to the zero address.
476      *
477      * Requirements:
478      *
479      * - `account` cannot be the zero address.
480      */
481     function _mint(address account, uint256 amount) internal virtual {
482         require(account != address(0), "ERC20: mint to the zero address");
483 
484         _beforeTokenTransfer(address(0), account, amount);
485 
486         _totalSupply += amount;
487         unchecked {
488             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
489             _balances[account] += amount;
490         }
491         emit Transfer(address(0), account, amount);
492 
493         _afterTokenTransfer(address(0), account, amount);
494     }
495 
496     /**
497      * @dev Destroys `amount` tokens from `account`, reducing the
498      * total supply.
499      *
500      * Emits a {Transfer} event with `to` set to the zero address.
501      *
502      * Requirements:
503      *
504      * - `account` cannot be the zero address.
505      * - `account` must have at least `amount` tokens.
506      */
507     function _burn(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: burn from the zero address");
509 
510         _beforeTokenTransfer(account, address(0), amount);
511 
512         uint256 accountBalance = _balances[account];
513         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
514         unchecked {
515             _balances[account] = accountBalance - amount;
516             // Overflow not possible: amount <= accountBalance <= totalSupply.
517             _totalSupply -= amount;
518         }
519 
520         emit Transfer(account, address(0), amount);
521 
522         _afterTokenTransfer(account, address(0), amount);
523     }
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
527      *
528      * This internal function is equivalent to `approve`, and can be used to
529      * e.g. set automatic allowances for certain subsystems, etc.
530      *
531      * Emits an {Approval} event.
532      *
533      * Requirements:
534      *
535      * - `owner` cannot be the zero address.
536      * - `spender` cannot be the zero address.
537      */
538     function _approve(
539         address owner,
540         address spender,
541         uint256 amount
542     ) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 
550     /**
551      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
552      *
553      * Does not update the allowance amount in case of infinite allowance.
554      * Revert if not enough allowance is available.
555      *
556      * Might emit an {Approval} event.
557      */
558     function _spendAllowance(
559         address owner,
560         address spender,
561         uint256 amount
562     ) internal virtual {
563         uint256 currentAllowance = allowance(owner, spender);
564         if (currentAllowance != type(uint256).max) {
565             require(currentAllowance >= amount, "ERC20: insufficient allowance");
566             unchecked {
567                 _approve(owner, spender, currentAllowance - amount);
568             }
569         }
570     }
571 
572     /**
573      * @dev Hook that is called before any transfer of tokens. This includes
574      * minting and burning.
575      *
576      * Calling conditions:
577      *
578      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
579      * will be transferred to `to`.
580      * - when `from` is zero, `amount` tokens will be minted for `to`.
581      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
582      * - `from` and `to` are never both zero.
583      *
584      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
585      */
586     function _beforeTokenTransfer(
587         address from,
588         address to,
589         uint256 amount
590     ) internal virtual {}
591 
592     /**
593      * @dev Hook that is called after any transfer of tokens. This includes
594      * minting and burning.
595      *
596      * Calling conditions:
597      *
598      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
599      * has been transferred to `to`.
600      * - when `from` is zero, `amount` tokens have been minted for `to`.
601      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
602      * - `from` and `to` are never both zero.
603      *
604      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
605      */
606     function _afterTokenTransfer(
607         address from,
608         address to,
609         uint256 amount
610     ) internal virtual {}
611 }
612 
613 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
614 
615 
616 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 
621 
622 /**
623  * @dev Extension of {ERC20} that allows token holders to destroy both their own
624  * tokens and those that they have an allowance for, in a way that can be
625  * recognized off-chain (via event analysis).
626  */
627 abstract contract ERC20Burnable is Context, ERC20 {
628     /**
629      * @dev Destroys `amount` tokens from the caller.
630      *
631      * See {ERC20-_burn}.
632      */
633     function burn(uint256 amount) public virtual {
634         _burn(_msgSender(), amount);
635     }
636 
637     /**
638      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
639      * allowance.
640      *
641      * See {ERC20-_burn} and {ERC20-allowance}.
642      *
643      * Requirements:
644      *
645      * - the caller must have allowance for ``accounts``'s tokens of at least
646      * `amount`.
647      */
648     function burnFrom(address account, uint256 amount) public virtual {
649         _spendAllowance(account, _msgSender(), amount);
650         _burn(account, amount);
651     }
652 }
653 
654 // File: contracts/Testllt.sol
655 
656 
657 pragma solidity ^0.8.0;
658 
659 
660 // SPDX-License-Identifier: MIT
661 
662 contract mate is ERC20, ERC20Burnable, Ownable {
663     uint256 private constant INITIAL_SUPPLY = 1000000000 * 10**18;
664 
665     constructor() ERC20("mate.tech", "MATE") {
666         _mint(msg.sender, INITIAL_SUPPLY);
667     }
668 
669     function distributeTokens(address distributionWallet) external onlyOwner {
670         uint256 supply = balanceOf(msg.sender);
671         require(supply == INITIAL_SUPPLY, "Tokens already distributed");
672 
673         _transfer(msg.sender, distributionWallet, supply);
674     }
675 }