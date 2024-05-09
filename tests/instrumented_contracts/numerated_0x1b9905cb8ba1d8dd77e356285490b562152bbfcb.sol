1 /**
2  *Submitted for verification at Etherscan.io on 2023-05-10
3  */
4 
5 // Sources flattened with hardhat v2.7.0 https://hardhat.org
6 
7 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
35 
36 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
37 
38 pragma solidity ^0.8.0;
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
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(
99             newOwner != address(0),
100             "Ownable: new owner is the zero address"
101         );
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
117 
118 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Interface of the ERC20 standard as defined in the EIP.
124  */
125 interface IERC20 {
126     /**
127      * @dev Returns the amount of tokens in existence.
128      */
129     function totalSupply() external view returns (uint256);
130 
131     /**
132      * @dev Returns the amount of tokens owned by `account`.
133      */
134     function balanceOf(address account) external view returns (uint256);
135 
136     /**
137      * @dev Moves `amount` tokens from the caller's account to `recipient`.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transfer(
144         address recipient,
145         uint256 amount
146     ) external returns (bool);
147 
148     /**
149      * @dev Returns the remaining number of tokens that `spender` will be
150      * allowed to spend on behalf of `owner` through {transferFrom}. This is
151      * zero by default.
152      *
153      * This value changes when {approve} or {transferFrom} are called.
154      */
155     function allowance(
156         address owner,
157         address spender
158     ) external view returns (uint256);
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
177      * @dev Moves `amount` tokens from `sender` to `recipient` using the
178      * allowance mechanism. `amount` is then deducted from the caller's
179      * allowance.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transferFrom(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) external returns (bool);
190 
191     /**
192      * @dev Emitted when `value` tokens are moved from one account (`from`) to
193      * another (`to`).
194      *
195      * Note that `value` may be zero.
196      */
197     event Transfer(address indexed from, address indexed to, uint256 value);
198 
199     /**
200      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
201      * a call to {approve}. `value` is the new allowance.
202      */
203     event Approval(
204         address indexed owner,
205         address indexed spender,
206         uint256 value
207     );
208 }
209 
210 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
211 
212 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @dev Interface for the optional metadata functions from the ERC20 standard.
218  *
219  * _Available since v4.1._
220  */
221 interface IERC20Metadata is IERC20 {
222     /**
223      * @dev Returns the name of the token.
224      */
225     function name() external view returns (string memory);
226 
227     /**
228      * @dev Returns the symbol of the token.
229      */
230     function symbol() external view returns (string memory);
231 
232     /**
233      * @dev Returns the decimals places of the token.
234      */
235     function decimals() external view returns (uint8);
236 }
237 
238 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
239 
240 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @dev Implementation of the {IERC20} interface.
246  *
247  * This implementation is agnostic to the way tokens are created. This means
248  * that a supply mechanism has to be added in a derived contract using {_mint}.
249  * For a generic mechanism see {ERC20PresetMinterPauser}.
250  *
251  * TIP: For a detailed writeup see our guide
252  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
253  * to implement supply mechanisms].
254  *
255  * We have followed general OpenZeppelin Contracts guidelines: functions revert
256  * instead returning `false` on failure. This behavior is nonetheless
257  * conventional and does not conflict with the expectations of ERC20
258  * applications.
259  *
260  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
261  * This allows applications to reconstruct the allowance for all accounts just
262  * by listening to said events. Other implementations of the EIP may not emit
263  * these events, as it isn't required by the specification.
264  *
265  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
266  * functions have been added to mitigate the well-known issues around setting
267  * allowances. See {IERC20-approve}.
268  */
269 contract ERC20 is Context, IERC20, IERC20Metadata {
270     mapping(address => uint256) private _balances;
271 
272     mapping(address => mapping(address => uint256)) private _allowances;
273 
274     uint256 private _totalSupply;
275 
276     string private _name;
277     string private _symbol;
278 
279     /**
280      * @dev Sets the values for {name} and {symbol}.
281      *
282      * The default value of {decimals} is 18. To select a different value for
283      * {decimals} you should overload it.
284      *
285      * All two of these values are immutable: they can only be set once during
286      * construction.
287      */
288     constructor(string memory name_, string memory symbol_) {
289         _name = name_;
290         _symbol = symbol_;
291     }
292 
293     /**
294      * @dev Returns the name of the token.
295      */
296     function name() public view virtual override returns (string memory) {
297         return _name;
298     }
299 
300     /**
301      * @dev Returns the symbol of the token, usually a shorter version of the
302      * name.
303      */
304     function symbol() public view virtual override returns (string memory) {
305         return _symbol;
306     }
307 
308     /**
309      * @dev Returns the number of decimals used to get its user representation.
310      * For example, if `decimals` equals `2`, a balance of `505` tokens should
311      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
312      *
313      * Tokens usually opt for a value of 18, imitating the relationship between
314      * Ether and Wei. This is the value {ERC20} uses, unless this function is
315      * overridden;
316      *
317      * NOTE: This information is only used for _display_ purposes: it in
318      * no way affects any of the arithmetic of the contract, including
319      * {IERC20-balanceOf} and {IERC20-transfer}.
320      */
321     function decimals() public view virtual override returns (uint8) {
322         return 18;
323     }
324 
325     /**
326      * @dev See {IERC20-totalSupply}.
327      */
328     function totalSupply() public view virtual override returns (uint256) {
329         return _totalSupply;
330     }
331 
332     /**
333      * @dev See {IERC20-balanceOf}.
334      */
335     function balanceOf(
336         address account
337     ) public view virtual override returns (uint256) {
338         return _balances[account];
339     }
340 
341     /**
342      * @dev See {IERC20-transfer}.
343      *
344      * Requirements:
345      *
346      * - `recipient` cannot be the zero address.
347      * - the caller must have a balance of at least `amount`.
348      */
349     function transfer(
350         address recipient,
351         uint256 amount
352     ) public virtual override returns (bool) {
353         _transfer(_msgSender(), recipient, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-allowance}.
359      */
360     function allowance(
361         address owner,
362         address spender
363     ) public view virtual override returns (uint256) {
364         return _allowances[owner][spender];
365     }
366 
367     /**
368      * @dev See {IERC20-approve}.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function approve(
375         address spender,
376         uint256 amount
377     ) public virtual override returns (bool) {
378         _approve(_msgSender(), spender, amount);
379         return true;
380     }
381 
382     /**
383      * @dev See {IERC20-transferFrom}.
384      *
385      * Emits an {Approval} event indicating the updated allowance. This is not
386      * required by the EIP. See the note at the beginning of {ERC20}.
387      *
388      * Requirements:
389      *
390      * - `sender` and `recipient` cannot be the zero address.
391      * - `sender` must have a balance of at least `amount`.
392      * - the caller must have allowance for ``sender``'s tokens of at least
393      * `amount`.
394      */
395     function transferFrom(
396         address sender,
397         address recipient,
398         uint256 amount
399     ) public virtual override returns (bool) {
400         _transfer(sender, recipient, amount);
401 
402         uint256 currentAllowance = _allowances[sender][_msgSender()];
403         require(
404             currentAllowance >= amount,
405             "ERC20: transfer amount exceeds allowance"
406         );
407         unchecked {
408             _approve(sender, _msgSender(), currentAllowance - amount);
409         }
410 
411         return true;
412     }
413 
414     /**
415      * @dev Atomically increases the allowance granted to `spender` by the caller.
416      *
417      * This is an alternative to {approve} that can be used as a mitigation for
418      * problems described in {IERC20-approve}.
419      *
420      * Emits an {Approval} event indicating the updated allowance.
421      *
422      * Requirements:
423      *
424      * - `spender` cannot be the zero address.
425      */
426     function increaseAllowance(
427         address spender,
428         uint256 addedValue
429     ) public virtual returns (bool) {
430         _approve(
431             _msgSender(),
432             spender,
433             _allowances[_msgSender()][spender] + addedValue
434         );
435         return true;
436     }
437 
438     /**
439      * @dev Atomically decreases the allowance granted to `spender` by the caller.
440      *
441      * This is an alternative to {approve} that can be used as a mitigation for
442      * problems described in {IERC20-approve}.
443      *
444      * Emits an {Approval} event indicating the updated allowance.
445      *
446      * Requirements:
447      *
448      * - `spender` cannot be the zero address.
449      * - `spender` must have allowance for the caller of at least
450      * `subtractedValue`.
451      */
452     function decreaseAllowance(
453         address spender,
454         uint256 subtractedValue
455     ) public virtual returns (bool) {
456         uint256 currentAllowance = _allowances[_msgSender()][spender];
457         require(
458             currentAllowance >= subtractedValue,
459             "ERC20: decreased allowance below zero"
460         );
461         unchecked {
462             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
463         }
464 
465         return true;
466     }
467 
468     /**
469      * @dev Moves `amount` of tokens from `sender` to `recipient`.
470      *
471      * This internal function is equivalent to {transfer}, and can be used to
472      * e.g. implement automatic token fees, slashing mechanisms, etc.
473      *
474      * Emits a {Transfer} event.
475      *
476      * Requirements:
477      *
478      * - `sender` cannot be the zero address.
479      * - `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      */
482     function _transfer(
483         address sender,
484         address recipient,
485         uint256 amount
486     ) internal virtual {
487         require(sender != address(0), "ERC20: transfer from the zero address");
488         require(recipient != address(0), "ERC20: transfer to the zero address");
489 
490         _beforeTokenTransfer(sender, recipient, amount);
491 
492         uint256 senderBalance = _balances[sender];
493         require(
494             senderBalance >= amount,
495             "ERC20: transfer amount exceeds balance"
496         );
497         unchecked {
498             _balances[sender] = senderBalance - amount;
499         }
500         _balances[recipient] += amount;
501 
502         emit Transfer(sender, recipient, amount);
503 
504         _afterTokenTransfer(sender, recipient, amount);
505     }
506 
507     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
508      * the total supply.
509      *
510      * Emits a {Transfer} event with `from` set to the zero address.
511      *
512      * Requirements:
513      *
514      * - `account` cannot be the zero address.
515      */
516     function _mint(address account, uint256 amount) internal virtual {
517         require(account != address(0), "ERC20: mint to the zero address");
518 
519         _beforeTokenTransfer(address(0), account, amount);
520 
521         _totalSupply += amount;
522         _balances[account] += amount;
523         emit Transfer(address(0), account, amount);
524 
525         _afterTokenTransfer(address(0), account, amount);
526     }
527 
528     /**
529      * @dev Destroys `amount` tokens from `account`, reducing the
530      * total supply.
531      *
532      * Emits a {Transfer} event with `to` set to the zero address.
533      *
534      * Requirements:
535      *
536      * - `account` cannot be the zero address.
537      * - `account` must have at least `amount` tokens.
538      */
539     function _burn(address account, uint256 amount) internal virtual {
540         require(account != address(0), "ERC20: burn from the zero address");
541 
542         _beforeTokenTransfer(account, address(0), amount);
543 
544         uint256 accountBalance = _balances[account];
545         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
546         unchecked {
547             _balances[account] = accountBalance - amount;
548         }
549         _totalSupply -= amount;
550 
551         emit Transfer(account, address(0), amount);
552 
553         _afterTokenTransfer(account, address(0), amount);
554     }
555 
556     /**
557      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
558      *
559      * This internal function is equivalent to `approve`, and can be used to
560      * e.g. set automatic allowances for certain subsystems, etc.
561      *
562      * Emits an {Approval} event.
563      *
564      * Requirements:
565      *
566      * - `owner` cannot be the zero address.
567      * - `spender` cannot be the zero address.
568      */
569     function _approve(
570         address owner,
571         address spender,
572         uint256 amount
573     ) internal virtual {
574         require(owner != address(0), "ERC20: approve from the zero address");
575         require(spender != address(0), "ERC20: approve to the zero address");
576 
577         _allowances[owner][spender] = amount;
578         emit Approval(owner, spender, amount);
579     }
580 
581     /**
582      * @dev Hook that is called before any transfer of tokens. This includes
583      * minting and burning.
584      *
585      * Calling conditions:
586      *
587      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
588      * will be transferred to `to`.
589      * - when `from` is zero, `amount` tokens will be minted for `to`.
590      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
591      * - `from` and `to` are never both zero.
592      *
593      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
594      */
595     function _beforeTokenTransfer(
596         address from,
597         address to,
598         uint256 amount
599     ) internal virtual {}
600 
601     /**
602      * @dev Hook that is called after any transfer of tokens. This includes
603      * minting and burning.
604      *
605      * Calling conditions:
606      *
607      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
608      * has been transferred to `to`.
609      * - when `from` is zero, `amount` tokens have been minted for `to`.
610      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
611      * - `from` and `to` are never both zero.
612      *
613      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
614      */
615     function _afterTokenTransfer(
616         address from,
617         address to,
618         uint256 amount
619     ) internal virtual {}
620 }
621 
622 pragma solidity ^0.8.0;
623 
624 contract kekwToken is Ownable, ERC20 {
625     bool public limited;
626     uint256 public maxHoldingAmount;
627     uint256 public minHoldingAmount;
628     address public uniswapV2Pair;
629     mapping(address => bool) public blacklists;
630 
631     constructor(uint256 _totalSupply) ERC20("kekw", "KEKW") {
632         _mint(msg.sender, _totalSupply);
633     }
634 
635     function blacklist(
636         address _address,
637         bool _isBlacklisting
638     ) external onlyOwner {
639         blacklists[_address] = _isBlacklisting;
640     }
641 
642     function setRule(
643         bool _limited,
644         address _uniswapV2Pair,
645         uint256 _maxHoldingAmount,
646         uint256 _minHoldingAmount
647     ) external onlyOwner {
648         limited = _limited;
649         uniswapV2Pair = _uniswapV2Pair;
650         maxHoldingAmount = _maxHoldingAmount;
651         minHoldingAmount = _minHoldingAmount;
652     }
653 
654     function _beforeTokenTransfer(
655         address from,
656         address to,
657         uint256 amount
658     ) internal virtual override {
659         require(!blacklists[to] && !blacklists[from], "Blacklisted");
660 
661         if (uniswapV2Pair == address(0)) {
662             require(from == owner() || to == owner(), "trading is not started");
663             return;
664         }
665 
666         if (limited && from == uniswapV2Pair) {
667             require(
668                 super.balanceOf(to) + amount <= maxHoldingAmount &&
669                     super.balanceOf(to) + amount >= minHoldingAmount,
670                 "Forbid"
671             );
672         }
673     }
674 
675     function burn(uint256 value) external {
676         _burn(msg.sender, value);
677     }
678 }