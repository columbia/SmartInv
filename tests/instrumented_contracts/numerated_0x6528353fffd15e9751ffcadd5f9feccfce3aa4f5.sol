1 /*
2 ██████████████████████████████████████████████████████████████████
3 █─▄▄▄─█▄─▄▄▀█▄─█─▄█▄─▄▄─█─▄─▄─█─▄▄─█▄─▀█▀─▄██▀▄─██▄─▄▄─█▄─▄██▀▄─██
4 █─███▀██─▄─▄██▄─▄███─▄▄▄███─███─██─██─█▄█─███─▀─███─▄████─███─▀─██
5 ▀▄▄▄▄▄▀▄▄▀▄▄▀▀▄▄▄▀▀▄▄▄▀▀▀▀▄▄▄▀▀▄▄▄▄▀▄▄▄▀▄▄▄▀▄▄▀▄▄▀▄▄▄▀▀▀▄▄▄▀▄▄▀▄▄▀
6 */
7 // SPDX-License-Identifier: Unlicensed
8 
9 // File: @openzeppelin/contracts/utils/Context.sol
10 
11 
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
36 // File: @openzeppelin/contracts/access/Ownable.sol
37 
38 
39 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
40 
41 pragma solidity ^0.8.0;
42 
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
87         require(_owner == msg.sender, "Ownable: caller is not the owner");
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions anymore. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby removing any functionality that is only available to the owner.
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
121 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
122 
123 
124 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 /**
129  * @dev Interface of the ERC20 standard as defined in the EIP.
130  */
131 interface IERC20 {
132     /**
133      * @dev Emitted when `value` tokens are moved from one account (`from`) to
134      * another (`to`).
135      *
136      * Note that `value` may be zero.
137      */
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 
140     /**
141      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
142      * a call to {approve}. `value` is the new allowance.
143      */
144     event Approval(address indexed owner, address indexed spender, uint256 value);
145 
146     /**
147      * @dev Returns the amount of tokens in existence.
148      */
149     function totalSupply() external view returns (uint256);
150 
151     /**
152      * @dev Returns the amount of tokens owned by `account`.
153      */
154     function balanceOf(address account) external view returns (uint256);
155 
156     /**
157      * @dev Moves `amount` tokens from the caller's account to `to`.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transfer(address to, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Returns the remaining number of tokens that `spender` will be
167      * allowed to spend on behalf of `owner` through {transferFrom}. This is
168      * zero by default.
169      *
170      * This value changes when {approve} or {transferFrom} are called.
171      */
172     function allowance(address owner, address spender) external view returns (uint256);
173 
174     /**
175      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * IMPORTANT: Beware that changing an allowance with this method brings the risk
180      * that someone may use both the old and the new allowance by unfortunate
181      * transaction ordering. One possible solution to mitigate this race
182      * condition is to first reduce the spender's allowance to 0 and set the
183      * desired value afterwards:
184      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185      *
186      * Emits an {Approval} event.
187      */
188     function approve(address spender, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Moves `amount` tokens from `from` to `to` using the
192      * allowance mechanism. `amount` is then deducted from the caller's
193      * allowance.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transferFrom(
200         address from,
201         address to,
202         uint256 amount
203     ) external returns (bool);
204 }
205 
206 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
207 
208 
209 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
210 
211 pragma solidity ^0.8.0;
212 
213 
214 /**
215  * @dev Interface for the optional metadata functions from the ERC20 standard.
216  *
217  * _Available since v4.1._
218  */
219 interface IERC20Metadata is IERC20 {
220     /**
221      * @dev Returns the name of the token.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the symbol of the token.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the decimals places of the token.
232      */
233     function decimals() external view returns (uint8);
234 }
235 
236 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
237 
238 
239 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 
244 
245 
246 /**
247  * @dev Implementation of the {IERC20} interface.
248  *
249  * This implementation is agnostic to the way tokens are created. This means
250  * that a supply mechanism has to be added in a derived contract using {_mint}.
251  * For a generic mechanism see {ERC20PresetMinterPauser}.
252  *
253  * TIP: For a detailed writeup see our guide
254  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
255  * to implement supply mechanisms].
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
284      * The default value of {decimals} is 18. To select a different value for
285      * {decimals} you should overload it.
286      *
287      * All two of these values are immutable: they can only be set once during
288      * construction.
289      */
290     constructor(string memory name_, string memory symbol_) {
291         _name = name_;
292         _symbol = symbol_;
293     }
294 
295     /**
296      * @dev Returns the name of the token.
297      */
298     function name() public view virtual override returns (string memory) {
299         return _name;
300     }
301 
302     /**
303      * @dev Returns the symbol of the token, usually a shorter version of the
304      * name.
305      */
306     function symbol() public view virtual override returns (string memory) {
307         return _symbol;
308     }
309 
310     /**
311      * @dev Returns the number of decimals used to get its user representation.
312      * For example, if `decimals` equals `2`, a balance of `505` tokens should
313      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
314      *
315      * Tokens usually opt for a value of 18, imitating the relationship between
316      * Ether and Wei. This is the value {ERC20} uses, unless this function is
317      * overridden;
318      *
319      * NOTE: This information is only used for _display_ purposes: it in
320      * no way affects any of the arithmetic of the contract, including
321      * {IERC20-balanceOf} and {IERC20-transfer}.
322      */
323     function decimals() public view virtual override returns (uint8) {
324         return 7;
325     }
326 
327     /**
328      * @dev See {IERC20-totalSupply}.
329      */
330     function totalSupply() public view virtual override returns (uint256) {
331         return _totalSupply;
332     }
333 
334     /**
335      * @dev See {IERC20-balanceOf}.
336      */
337     function balanceOf(address account) public view virtual override returns (uint256) {
338         return _balances[account];
339     }
340 
341     /**
342      * @dev See {IERC20-transfer}.
343      *
344      * Requirements:
345      *
346      * - `to` cannot be the zero address.
347      * - the caller must have a balance of at least `amount`.
348      */
349     function transfer(address to, uint256 amount) public virtual override returns (bool) {
350         address owner = _msgSender();
351         _transfer(owner, to, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-allowance}.
357      */
358     function allowance(address owner, address spender) public view virtual override returns (uint256) {
359         return _allowances[owner][spender];
360     }
361 
362     /**
363      * @dev See {IERC20-approve}.
364      *
365      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
366      * `transferFrom`. This is semantically equivalent to an infinite approval.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      */
372     function approve(address spender, uint256 amount) public virtual override returns (bool) {
373         address owner = _msgSender();
374         _approve(owner, spender, amount);
375         return true;
376     }
377 
378     /**
379      * @dev See {IERC20-transferFrom}.
380      *
381      * Emits an {Approval} event indicating the updated allowance. This is not
382      * required by the EIP. See the note at the beginning of {ERC20}.
383      *
384      * NOTE: Does not update the allowance if the current allowance
385      * is the maximum `uint256`.
386      *
387      * Requirements:
388      *
389      * - `from` and `to` cannot be the zero address.
390      * - `from` must have a balance of at least `amount`.
391      * - the caller must have allowance for ``from``'s tokens of at least
392      * `amount`.
393      */
394     function transferFrom(
395         address from,
396         address to,
397         uint256 amount
398     ) public virtual override returns (bool) {
399         address spender = _msgSender();
400         _spendAllowance(from, spender, amount);
401         _transfer(from, to, amount);
402         return true;
403     }
404 
405     /**
406      * @dev Atomically increases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      */
417     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
418         address owner = _msgSender();
419         _approve(owner, spender, allowance(owner, spender) + addedValue);
420         return true;
421     }
422 
423     /**
424      * @dev Atomically decreases the allowance granted to `spender` by the caller.
425      *
426      * This is an alternative to {approve} that can be used as a mitigation for
427      * problems described in {IERC20-approve}.
428      *
429      * Emits an {Approval} event indicating the updated allowance.
430      *
431      * Requirements:
432      *
433      * - `spender` cannot be the zero address.
434      * - `spender` must have allowance for the caller of at least
435      * `subtractedValue`.
436      */
437     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
438         address owner = _msgSender();
439         uint256 currentAllowance = allowance(owner, spender);
440         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
441         unchecked {
442             _approve(owner, spender, currentAllowance - subtractedValue);
443         }
444 
445         return true;
446     }
447 
448     /**
449      * @dev Moves `amount` of tokens from `from` to `to`.
450      *
451      * This internal function is equivalent to {transfer}, and can be used to
452      * e.g. implement automatic token fees, slashing mechanisms, etc.
453      *
454      * Emits a {Transfer} event.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `from` must have a balance of at least `amount`.
461      */
462     function _transfer(
463         address from,
464         address to,
465         uint256 amount
466     ) internal virtual {
467         require(from != address(0), "ERC20: transfer from the zero address");
468         require(to != address(0), "ERC20: transfer to the zero address");
469 
470 
471         _beforeTokenTransfer(from, to, amount);
472 
473         uint256 fromBalance = _balances[from];
474         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
475         unchecked {
476             _balances[from] = fromBalance - amount;
477             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
478             // decrementing then incrementing.
479             _balances[to] += amount;
480         }
481 
482         emit Transfer(from, to, amount);
483 
484         _afterTokenTransfer(from, to, amount);
485     }
486 
487     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
488      * the total supply.
489      *
490      * Emits a {Transfer} event with `from` set to the zero address.
491      *
492      * Requirements:
493      *
494      * - `account` cannot be the zero address.
495      */
496     function _mint(address account, uint256 amount) internal virtual {
497         require(account != address(0), "ERC20: mint to the zero address");
498 
499         _beforeTokenTransfer(address(0), account, amount);
500 
501         _totalSupply += amount;
502         unchecked {
503             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
504             _balances[account] += amount;
505         }
506         emit Transfer(address(0), account, amount);
507 
508         _afterTokenTransfer(address(0), account, amount);
509     }
510 
511     /**
512      * @dev Destroys `amount` tokens from `account`, reducing the
513      * total supply.
514      *
515      * Emits a {Transfer} event with `to` set to the zero address.
516      *
517      * Requirements:
518      *
519      * - `account` cannot be the zero address.
520      * - `account` must have at least `amount` tokens.
521      */
522     function _burn(address account, uint256 amount) internal virtual {
523         require(account != address(0), "ERC20: burn from the zero address");
524 
525         _beforeTokenTransfer(account, address(0), amount);
526 
527         uint256 accountBalance = _balances[account];
528         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
529         unchecked {
530             _balances[account] = accountBalance - amount;
531             // Overflow not possible: amount <= accountBalance <= totalSupply.
532             _totalSupply -= amount;
533         }
534 
535         emit Transfer(account, address(0), amount);
536 
537         _afterTokenTransfer(account, address(0), amount);
538     }
539 
540     /**
541      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
542      *
543      * This internal function is equivalent to `approve`, and can be used to
544      * e.g. set automatic allowances for certain subsystems, etc.
545      *
546      * Emits an {Approval} event.
547      *
548      * Requirements:
549      *
550      * - `owner` cannot be the zero address.
551      * - `spender` cannot be the zero address.
552      */
553     function _approve(
554         address owner,
555         address spender,
556         uint256 amount
557     ) internal virtual {
558         require(owner != address(0), "ERC20: approve from the zero address");
559         require(spender != address(0), "ERC20: approve to the zero address");
560 
561         _allowances[owner][spender] = amount;
562         emit Approval(owner, spender, amount);
563     }
564 
565     /**
566      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
567      *
568      * Does not update the allowance amount in case of infinite allowance.
569      * Revert if not enough allowance is available.
570      *
571      * Might emit an {Approval} event.
572      */
573     function _spendAllowance(
574         address owner,
575         address spender,
576         uint256 amount
577     ) internal virtual {
578         uint256 currentAllowance = allowance(owner, spender);
579         if (currentAllowance != type(uint256).max) {
580             require(currentAllowance >= amount, "ERC20: insufficient allowance");
581             unchecked {
582                 _approve(owner, spender, currentAllowance - amount);
583             }
584         }
585     }
586 
587     /**
588      * @dev Hook that is called before any transfer of tokens. This includes
589      * minting and burning.
590      *
591      * Calling conditions:
592      *
593      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
594      * will be transferred to `to`.
595      * - when `from` is zero, `amount` tokens will be minted for `to`.
596      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
597      * - `from` and `to` are never both zero.
598      *
599      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
600      */
601     function _beforeTokenTransfer(
602         address from,
603         address to,
604         uint256 amount
605     ) internal virtual {}
606 
607     /**
608      * @dev Hook that is called after any transfer of tokens. This includes
609      * minting and burning.
610      *
611      * Calling conditions:
612      *
613      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
614      * has been transferred to `to`.
615      * - when `from` is zero, `amount` tokens have been minted for `to`.
616      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
617      * - `from` and `to` are never both zero.
618      *
619      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
620      */
621     function _afterTokenTransfer(
622         address from,
623         address to,
624         uint256 amount
625     ) internal virtual {}
626 }
627 
628 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
629 
630 
631 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 
636 
637 /**
638  * @dev Extension of {ERC20} that allows token holders to destroy both their own
639  * tokens and those that they have an allowance for, in a way that can be
640  * recognized off-chain (via event analysis).
641  */
642 abstract contract ERC20Burnable is Context, ERC20 {
643     /**
644      * @dev Destroys `amount` tokens from the caller.
645      *
646      * See {ERC20-_burn}.
647      */
648     function burn(uint256 amount) public virtual {
649         _burn(_msgSender(), amount);
650     }
651 
652     /**
653      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
654      * allowance.
655      *
656      * See {ERC20-_burn} and {ERC20-allowance}.
657      *
658      * Requirements:
659      *
660      * - the caller must have allowance for ``accounts``'s tokens of at least
661      * `amount`.
662      */
663     function burnFrom(address account, uint256 amount) public virtual {
664         _spendAllowance(account, _msgSender(), amount);
665         _burn(account, amount);
666     }
667 }
668 
669 
670 pragma solidity ^0.8.0;
671 
672 
673 contract CryptoMafia is ERC20, ERC20Burnable, Ownable {
674     uint256 private constant INITIAL_SUPPLY = 187000000000 * 10**7;
675 
676 
677     constructor() ERC20("Crypto Mafia", "MAFIA") {
678         _mint(msg.sender, INITIAL_SUPPLY);
679     }
680 }