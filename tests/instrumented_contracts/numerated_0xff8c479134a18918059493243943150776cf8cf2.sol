1 // ██████╗░███████╗███╗░░██╗░██████╗░
2 // ██╔══██╗██╔════╝████╗░██║██╔═══██╗
3 // ██████╔╝█████╗░░██╔██╗██║██║██╗██║
4 // ██╔══██╗██╔══╝░░██║╚████║╚██████╔╝
5 // ██║░░██║███████╗██║░╚███║░╚═██╔═╝░
6 // ╚═╝░░╚═╝╚══════╝╚═╝░░╚══╝░░░╚═╝░░░
7 
8 // Token: Renq Finance
9 // Website: https://renq.io
10 // Twitter: https://twitter.com/renqfinance
11 // Telegram: https://t.me/renqfinance
12 
13 // SPDX-License-Identifier: MIT
14 // File: @openzeppelin/contracts/utils/Context.sol
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 // File: @openzeppelin/contracts/access/Ownable.sol
42 
43 
44 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
45 
46 pragma solidity ^0.8.0;
47 
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * By default, the owner account will be the one that deploys the contract. This
55  * can later be changed with {transferOwnership}.
56  *
57  * This module is used through inheritance. It will make available the modifier
58  * `onlyOwner`, which can be applied to your functions to restrict their use to
59  * the owner.
60  */
61 abstract contract Ownable is Context {
62     address private _owner;
63 
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     /**
67      * @dev Initializes the contract setting the deployer as the initial owner.
68      */
69     constructor() {
70         _transferOwnership(_msgSender());
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         _checkOwner();
78         _;
79     }
80 
81     /**
82      * @dev Returns the address of the current owner.
83      */
84     function owner() public view virtual returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if the sender is not the owner.
90      */
91     function _checkOwner() internal view virtual {
92         require(owner() == _msgSender(), "Ownable: caller is not the owner");
93     }
94 
95     /**
96      * @dev Leaves the contract without owner. It will not be possible to call
97      * `onlyOwner` functions anymore. Can only be called by the current owner.
98      *
99      * NOTE: Renouncing ownership will leave the contract without an owner,
100      * thereby removing any functionality that is only available to the owner.
101      */
102     function renounceOwnership() public virtual onlyOwner {
103         _transferOwnership(address(0));
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Can only be called by the current owner.
109      */
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         _transferOwnership(newOwner);
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Internal function without access restriction.
118      */
119     function _transferOwnership(address newOwner) internal virtual {
120         address oldOwner = _owner;
121         _owner = newOwner;
122         emit OwnershipTransferred(oldOwner, newOwner);
123     }
124 }
125 
126 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
127 
128 
129 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Interface of the ERC20 standard as defined in the EIP.
135  */
136 interface IERC20 {
137     /**
138      * @dev Emitted when `value` tokens are moved from one account (`from`) to
139      * another (`to`).
140      *
141      * Note that `value` may be zero.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 
145     /**
146      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
147      * a call to {approve}. `value` is the new allowance.
148      */
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 
151     /**
152      * @dev Returns the amount of tokens in existence.
153      */
154     function totalSupply() external view returns (uint256);
155 
156     /**
157      * @dev Returns the amount of tokens owned by `account`.
158      */
159     function balanceOf(address account) external view returns (uint256);
160 
161     /**
162      * @dev Moves `amount` tokens from the caller's account to `to`.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transfer(address to, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Returns the remaining number of tokens that `spender` will be
172      * allowed to spend on behalf of `owner` through {transferFrom}. This is
173      * zero by default.
174      *
175      * This value changes when {approve} or {transferFrom} are called.
176      */
177     function allowance(address owner, address spender) external view returns (uint256);
178 
179     /**
180      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * IMPORTANT: Beware that changing an allowance with this method brings the risk
185      * that someone may use both the old and the new allowance by unfortunate
186      * transaction ordering. One possible solution to mitigate this race
187      * condition is to first reduce the spender's allowance to 0 and set the
188      * desired value afterwards:
189      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190      *
191      * Emits an {Approval} event.
192      */
193     function approve(address spender, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Moves `amount` tokens from `from` to `to` using the
197      * allowance mechanism. `amount` is then deducted from the caller's
198      * allowance.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 amount
208     ) external returns (bool);
209 }
210 
211 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
212 
213 
214 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
215 
216 pragma solidity ^0.8.0;
217 
218 
219 /**
220  * @dev Interface for the optional metadata functions from the ERC20 standard.
221  *
222  * _Available since v4.1._
223  */
224 interface IERC20Metadata is IERC20 {
225     /**
226      * @dev Returns the name of the token.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the symbol of the token.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the decimals places of the token.
237      */
238     function decimals() external view returns (uint8);
239 }
240 
241 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
242 
243 
244 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 
249 
250 
251 /**
252  * @dev Implementation of the {IERC20} interface.
253  *
254  * This implementation is agnostic to the way tokens are created. This means
255  * that a supply mechanism has to be added in a derived contract using {_mint}.
256  * For a generic mechanism see {ERC20PresetMinterPauser}.
257  *
258  * TIP: For a detailed writeup see our guide
259  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
260  * to implement supply mechanisms].
261  *
262  * We have followed general OpenZeppelin Contracts guidelines: functions revert
263  * instead returning `false` on failure. This behavior is nonetheless
264  * conventional and does not conflict with the expectations of ERC20
265  * applications.
266  *
267  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
268  * This allows applications to reconstruct the allowance for all accounts just
269  * by listening to said events. Other implementations of the EIP may not emit
270  * these events, as it isn't required by the specification.
271  *
272  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
273  * functions have been added to mitigate the well-known issues around setting
274  * allowances. See {IERC20-approve}.
275  */
276 contract ERC20 is Context, IERC20, IERC20Metadata {
277     mapping(address => uint256) private _balances;
278 
279     mapping(address => mapping(address => uint256)) private _allowances;
280 
281     uint256 private _totalSupply;
282 
283     string private _name;
284     string private _symbol;
285 
286     /**
287      * @dev Sets the values for {name} and {symbol}.
288      *
289      * The default value of {decimals} is 18. To select a different value for
290      * {decimals} you should overload it.
291      *
292      * All two of these values are immutable: they can only be set once during
293      * construction.
294      */
295     constructor(string memory name_, string memory symbol_) {
296         _name = name_;
297         _symbol = symbol_;
298     }
299 
300     /**
301      * @dev Returns the name of the token.
302      */
303     function name() public view virtual override returns (string memory) {
304         return _name;
305     }
306 
307     /**
308      * @dev Returns the symbol of the token, usually a shorter version of the
309      * name.
310      */
311     function symbol() public view virtual override returns (string memory) {
312         return _symbol;
313     }
314 
315     /**
316      * @dev Returns the number of decimals used to get its user representation.
317      * For example, if `decimals` equals `2`, a balance of `505` tokens should
318      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
319      *
320      * Tokens usually opt for a value of 18, imitating the relationship between
321      * Ether and Wei. This is the value {ERC20} uses, unless this function is
322      * overridden;
323      *
324      * NOTE: This information is only used for _display_ purposes: it in
325      * no way affects any of the arithmetic of the contract, including
326      * {IERC20-balanceOf} and {IERC20-transfer}.
327      */
328     function decimals() public view virtual override returns (uint8) {
329         return 18;
330     }
331 
332     /**
333      * @dev See {IERC20-totalSupply}.
334      */
335     function totalSupply() public view virtual override returns (uint256) {
336         return _totalSupply;
337     }
338 
339     /**
340      * @dev See {IERC20-balanceOf}.
341      */
342     function balanceOf(address account) public view virtual override returns (uint256) {
343         return _balances[account];
344     }
345 
346     /**
347      * @dev See {IERC20-transfer}.
348      *
349      * Requirements:
350      *
351      * - `to` cannot be the zero address.
352      * - the caller must have a balance of at least `amount`.
353      */
354     function transfer(address to, uint256 amount) public virtual override returns (bool) {
355         address owner = _msgSender();
356         _transfer(owner, to, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-allowance}.
362      */
363     function allowance(address owner, address spender) public view virtual override returns (uint256) {
364         return _allowances[owner][spender];
365     }
366 
367     /**
368      * @dev See {IERC20-approve}.
369      *
370      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
371      * `transferFrom`. This is semantically equivalent to an infinite approval.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function approve(address spender, uint256 amount) public virtual override returns (bool) {
378         address owner = _msgSender();
379         _approve(owner, spender, amount);
380         return true;
381     }
382 
383     /**
384      * @dev See {IERC20-transferFrom}.
385      *
386      * Emits an {Approval} event indicating the updated allowance. This is not
387      * required by the EIP. See the note at the beginning of {ERC20}.
388      *
389      * NOTE: Does not update the allowance if the current allowance
390      * is the maximum `uint256`.
391      *
392      * Requirements:
393      *
394      * - `from` and `to` cannot be the zero address.
395      * - `from` must have a balance of at least `amount`.
396      * - the caller must have allowance for ``from``'s tokens of at least
397      * `amount`.
398      */
399     function transferFrom(
400         address from,
401         address to,
402         uint256 amount
403     ) public virtual override returns (bool) {
404         address spender = _msgSender();
405         _spendAllowance(from, spender, amount);
406         _transfer(from, to, amount);
407         return true;
408     }
409 
410     /**
411      * @dev Atomically increases the allowance granted to `spender` by the caller.
412      *
413      * This is an alternative to {approve} that can be used as a mitigation for
414      * problems described in {IERC20-approve}.
415      *
416      * Emits an {Approval} event indicating the updated allowance.
417      *
418      * Requirements:
419      *
420      * - `spender` cannot be the zero address.
421      */
422     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
423         address owner = _msgSender();
424         _approve(owner, spender, allowance(owner, spender) + addedValue);
425         return true;
426     }
427 
428     /**
429      * @dev Atomically decreases the allowance granted to `spender` by the caller.
430      *
431      * This is an alternative to {approve} that can be used as a mitigation for
432      * problems described in {IERC20-approve}.
433      *
434      * Emits an {Approval} event indicating the updated allowance.
435      *
436      * Requirements:
437      *
438      * - `spender` cannot be the zero address.
439      * - `spender` must have allowance for the caller of at least
440      * `subtractedValue`.
441      */
442     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
443         address owner = _msgSender();
444         uint256 currentAllowance = allowance(owner, spender);
445         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
446         unchecked {
447             _approve(owner, spender, currentAllowance - subtractedValue);
448         }
449 
450         return true;
451     }
452 
453     /**
454      * @dev Moves `amount` of tokens from `from` to `to`.
455      *
456      * This internal function is equivalent to {transfer}, and can be used to
457      * e.g. implement automatic token fees, slashing mechanisms, etc.
458      *
459      * Emits a {Transfer} event.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `from` must have a balance of at least `amount`.
466      */
467     function _transfer(
468         address from,
469         address to,
470         uint256 amount
471     ) internal virtual {
472         require(from != address(0), "ERC20: transfer from the zero address");
473         require(to != address(0), "ERC20: transfer to the zero address");
474 
475         _beforeTokenTransfer(from, to, amount);
476 
477         uint256 fromBalance = _balances[from];
478         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
479         unchecked {
480             _balances[from] = fromBalance - amount;
481             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
482             // decrementing then incrementing.
483             _balances[to] += amount;
484         }
485 
486         emit Transfer(from, to, amount);
487 
488         _afterTokenTransfer(from, to, amount);
489     }
490 
491     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
492      * the total supply.
493      *
494      * Emits a {Transfer} event with `from` set to the zero address.
495      *
496      * Requirements:
497      *
498      * - `account` cannot be the zero address.
499      */
500     function _mint(address account, uint256 amount) internal virtual {
501         require(account != address(0), "ERC20: mint to the zero address");
502 
503         _beforeTokenTransfer(address(0), account, amount);
504 
505         _totalSupply += amount;
506         unchecked {
507             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
508             _balances[account] += amount;
509         }
510         emit Transfer(address(0), account, amount);
511 
512         _afterTokenTransfer(address(0), account, amount);
513     }
514 
515     /**
516      * @dev Destroys `amount` tokens from `account`, reducing the
517      * total supply.
518      *
519      * Emits a {Transfer} event with `to` set to the zero address.
520      *
521      * Requirements:
522      *
523      * - `account` cannot be the zero address.
524      * - `account` must have at least `amount` tokens.
525      */
526     function _burn(address account, uint256 amount) internal virtual {
527         require(account != address(0), "ERC20: burn from the zero address");
528 
529         _beforeTokenTransfer(account, address(0), amount);
530 
531         uint256 accountBalance = _balances[account];
532         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
533         unchecked {
534             _balances[account] = accountBalance - amount;
535             // Overflow not possible: amount <= accountBalance <= totalSupply.
536             _totalSupply -= amount;
537         }
538 
539         emit Transfer(account, address(0), amount);
540 
541         _afterTokenTransfer(account, address(0), amount);
542     }
543 
544     /**
545      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
546      *
547      * This internal function is equivalent to `approve`, and can be used to
548      * e.g. set automatic allowances for certain subsystems, etc.
549      *
550      * Emits an {Approval} event.
551      *
552      * Requirements:
553      *
554      * - `owner` cannot be the zero address.
555      * - `spender` cannot be the zero address.
556      */
557     function _approve(
558         address owner,
559         address spender,
560         uint256 amount
561     ) internal virtual {
562         require(owner != address(0), "ERC20: approve from the zero address");
563         require(spender != address(0), "ERC20: approve to the zero address");
564 
565         _allowances[owner][spender] = amount;
566         emit Approval(owner, spender, amount);
567     }
568 
569     /**
570      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
571      *
572      * Does not update the allowance amount in case of infinite allowance.
573      * Revert if not enough allowance is available.
574      *
575      * Might emit an {Approval} event.
576      */
577     function _spendAllowance(
578         address owner,
579         address spender,
580         uint256 amount
581     ) internal virtual {
582         uint256 currentAllowance = allowance(owner, spender);
583         if (currentAllowance != type(uint256).max) {
584             require(currentAllowance >= amount, "ERC20: insufficient allowance");
585             unchecked {
586                 _approve(owner, spender, currentAllowance - amount);
587             }
588         }
589     }
590 
591     /**
592      * @dev Hook that is called before any transfer of tokens. This includes
593      * minting and burning.
594      *
595      * Calling conditions:
596      *
597      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
598      * will be transferred to `to`.
599      * - when `from` is zero, `amount` tokens will be minted for `to`.
600      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
601      * - `from` and `to` are never both zero.
602      *
603      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
604      */
605     function _beforeTokenTransfer(
606         address from,
607         address to,
608         uint256 amount
609     ) internal virtual {}
610 
611     /**
612      * @dev Hook that is called after any transfer of tokens. This includes
613      * minting and burning.
614      *
615      * Calling conditions:
616      *
617      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
618      * has been transferred to `to`.
619      * - when `from` is zero, `amount` tokens have been minted for `to`.
620      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
621      * - `from` and `to` are never both zero.
622      *
623      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
624      */
625     function _afterTokenTransfer(
626         address from,
627         address to,
628         uint256 amount
629     ) internal virtual {}
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
633 
634 
635 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 
640 
641 /**
642  * @dev Extension of {ERC20} that allows token holders to destroy both their own
643  * tokens and those that they have an allowance for, in a way that can be
644  * recognized off-chain (via event analysis).
645  */
646 abstract contract ERC20Burnable is Context, ERC20 {
647     /**
648      * @dev Destroys `amount` tokens from the caller.
649      *
650      * See {ERC20-_burn}.
651      */
652     function burn(uint256 amount) public virtual {
653         _burn(_msgSender(), amount);
654     }
655 
656     /**
657      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
658      * allowance.
659      *
660      * See {ERC20-_burn} and {ERC20-allowance}.
661      *
662      * Requirements:
663      *
664      * - the caller must have allowance for ``accounts``'s tokens of at least
665      * `amount`.
666      */
667     function burnFrom(address account, uint256 amount) public virtual {
668         _spendAllowance(account, _msgSender(), amount);
669         _burn(account, amount);
670     }
671 }
672 
673 // File: RENQ.sol
674 
675 
676 pragma solidity ^0.8.15;
677 
678 
679 
680 
681 contract Renq is ERC20, ERC20Burnable, Ownable {
682     constructor() ERC20("Renq Finance", "RENQ") {
683         _mint(msg.sender, 1_000_000_000 ether);
684     }
685 
686     function _beforeTokenTransfer(
687         address from,
688         address to,
689         uint256 amount
690     ) internal override(ERC20) {
691         super._beforeTokenTransfer(from, to, amount);
692     }
693 
694     function _transfer(
695         address sender,
696         address recipient,
697         uint256 amount
698     ) internal virtual override(ERC20) {
699         super._transfer(sender, recipient, amount);
700     }
701 }