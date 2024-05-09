1 // https://t.me/PepeErc20Portal
2 
3 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Emitted when `value` tokens are moved from one account (`from`) to
13      * another (`to`).
14      *
15      * Note that `value` may be zero.
16      */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /**
20      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
21      * a call to {approve}. `value` is the new allowance.
22      */
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `to`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address to, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `from` to `to` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address from,
80         address to,
81         uint256 amount
82     ) external returns (bool);
83 }
84 
85 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 // File: @openzeppelin/contracts/utils/Context.sol
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
119 
120 pragma solidity ^0.8.0;
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
142 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
143 
144 
145 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 
150 
151 
152 /**
153  * @dev Implementation of the {IERC20} interface.
154  *
155  * This implementation is agnostic to the way tokens are created. This means
156  * that a supply mechanism has to be added in a derived contract using {_mint}.
157  * For a generic mechanism see {ERC20PresetMinterPauser}.
158  *
159  * TIP: For a detailed writeup see our guide
160  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
161  * to implement supply mechanisms].
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
190      * The default value of {decimals} is 18. To select a different value for
191      * {decimals} you should overload it.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200 
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207 
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215 
216     /**
217      * @dev Returns the number of decimals used to get its user representation.
218      * For example, if `decimals` equals `2`, a balance of `505` tokens should
219      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
220      *
221      * Tokens usually opt for a value of 18, imitating the relationship between
222      * Ether and Wei. This is the value {ERC20} uses, unless this function is
223      * overridden;
224      *
225      * NOTE: This information is only used for _display_ purposes: it in
226      * no way affects any of the arithmetic of the contract, including
227      * {IERC20-balanceOf} and {IERC20-transfer}.
228      */
229     function decimals() public view virtual override returns (uint8) {
230         return 18;
231     }
232 
233     /**
234      * @dev See {IERC20-totalSupply}.
235      */
236     function totalSupply() public view virtual override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241      * @dev See {IERC20-balanceOf}.
242      */
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     /**
248      * @dev See {IERC20-transfer}.
249      *
250      * Requirements:
251      *
252      * - `to` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address to, uint256 amount) public virtual override returns (bool) {
256         address owner = _msgSender();
257         _transfer(owner, to, amount);
258         return true;
259     }
260 
261     /**
262      * @dev See {IERC20-allowance}.
263      */
264     function allowance(address owner, address spender) public view virtual override returns (uint256) {
265         return _allowances[owner][spender];
266     }
267 
268     /**
269      * @dev See {IERC20-approve}.
270      *
271      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
272      * `transferFrom`. This is semantically equivalent to an infinite approval.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      */
278     function approve(address spender, uint256 amount) public virtual override returns (bool) {
279         address owner = _msgSender();
280         _approve(owner, spender, amount);
281         return true;
282     }
283 
284     /**
285      * @dev See {IERC20-transferFrom}.
286      *
287      * Emits an {Approval} event indicating the updated allowance. This is not
288      * required by the EIP. See the note at the beginning of {ERC20}.
289      *
290      * NOTE: Does not update the allowance if the current allowance
291      * is the maximum `uint256`.
292      *
293      * Requirements:
294      *
295      * - `from` and `to` cannot be the zero address.
296      * - `from` must have a balance of at least `amount`.
297      * - the caller must have allowance for ``from``'s tokens of at least
298      * `amount`.
299      */
300     function transferFrom(
301         address from,
302         address to,
303         uint256 amount
304     ) public virtual override returns (bool) {
305         address spender = _msgSender();
306         _spendAllowance(from, spender, amount);
307         _transfer(from, to, amount);
308         return true;
309     }
310 
311     /**
312      * @dev Atomically increases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to {approve} that can be used as a mitigation for
315      * problems described in {IERC20-approve}.
316      *
317      * Emits an {Approval} event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
324         address owner = _msgSender();
325         _approve(owner, spender, allowance(owner, spender) + addedValue);
326         return true;
327     }
328 
329     /**
330      * @dev Atomically decreases the allowance granted to `spender` by the caller.
331      *
332      * This is an alternative to {approve} that can be used as a mitigation for
333      * problems described in {IERC20-approve}.
334      *
335      * Emits an {Approval} event indicating the updated allowance.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      * - `spender` must have allowance for the caller of at least
341      * `subtractedValue`.
342      */
343     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
344         address owner = _msgSender();
345         uint256 currentAllowance = allowance(owner, spender);
346         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
347         unchecked {
348             _approve(owner, spender, currentAllowance - subtractedValue);
349         }
350 
351         return true;
352     }
353 
354     /**
355      * @dev Moves `amount` of tokens from `from` to `to`.
356      *
357      * This internal function is equivalent to {transfer}, and can be used to
358      * e.g. implement automatic token fees, slashing mechanisms, etc.
359      *
360      * Emits a {Transfer} event.
361      *
362      * Requirements:
363      *
364      * - `from` cannot be the zero address.
365      * - `to` cannot be the zero address.
366      * - `from` must have a balance of at least `amount`.
367      */
368     function _transfer(
369         address from,
370         address to,
371         uint256 amount
372     ) internal virtual {
373         require(from != address(0), "ERC20: transfer from the zero address");
374         require(to != address(0), "ERC20: transfer to the zero address");
375 
376         _beforeTokenTransfer(from, to, amount);
377 
378         uint256 fromBalance = _balances[from];
379         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
380         unchecked {
381             _balances[from] = fromBalance - amount;
382             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
383             // decrementing then incrementing.
384             _balances[to] += amount;
385         }
386 
387         emit Transfer(from, to, amount);
388 
389         _afterTokenTransfer(from, to, amount);
390     }
391 
392     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
393      * the total supply.
394      *
395      * Emits a {Transfer} event with `from` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      */
401     function _mint(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: mint to the zero address");
403 
404         _beforeTokenTransfer(address(0), account, amount);
405 
406         _totalSupply += amount;
407         unchecked {
408             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
409             _balances[account] += amount;
410         }
411         emit Transfer(address(0), account, amount);
412 
413         _afterTokenTransfer(address(0), account, amount);
414     }
415 
416     /**
417      * @dev Destroys `amount` tokens from `account`, reducing the
418      * total supply.
419      *
420      * Emits a {Transfer} event with `to` set to the zero address.
421      *
422      * Requirements:
423      *
424      * - `account` cannot be the zero address.
425      * - `account` must have at least `amount` tokens.
426      */
427     function _burn(address account, uint256 amount) internal virtual {
428         require(account != address(0), "ERC20: burn from the zero address");
429 
430         _beforeTokenTransfer(account, address(0), amount);
431 
432         uint256 accountBalance = _balances[account];
433         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
434         unchecked {
435             _balances[account] = accountBalance - amount;
436             // Overflow not possible: amount <= accountBalance <= totalSupply.
437             _totalSupply -= amount;
438         }
439 
440         emit Transfer(account, address(0), amount);
441 
442         _afterTokenTransfer(account, address(0), amount);
443     }
444 
445     /**
446      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
447      *
448      * This internal function is equivalent to `approve`, and can be used to
449      * e.g. set automatic allowances for certain subsystems, etc.
450      *
451      * Emits an {Approval} event.
452      *
453      * Requirements:
454      *
455      * - `owner` cannot be the zero address.
456      * - `spender` cannot be the zero address.
457      */
458     function _approve(
459         address owner,
460         address spender,
461         uint256 amount
462     ) internal virtual {
463         require(owner != address(0), "ERC20: approve from the zero address");
464         require(spender != address(0), "ERC20: approve to the zero address");
465 
466         _allowances[owner][spender] = amount;
467         emit Approval(owner, spender, amount);
468     }
469 
470     /**
471      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
472      *
473      * Does not update the allowance amount in case of infinite allowance.
474      * Revert if not enough allowance is available.
475      *
476      * Might emit an {Approval} event.
477      */
478     function _spendAllowance(
479         address owner,
480         address spender,
481         uint256 amount
482     ) internal virtual {
483         uint256 currentAllowance = allowance(owner, spender);
484         if (currentAllowance != type(uint256).max) {
485             require(currentAllowance >= amount, "ERC20: insufficient allowance");
486             unchecked {
487                 _approve(owner, spender, currentAllowance - amount);
488             }
489         }
490     }
491 
492     /**
493      * @dev Hook that is called before any transfer of tokens. This includes
494      * minting and burning.
495      *
496      * Calling conditions:
497      *
498      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
499      * will be transferred to `to`.
500      * - when `from` is zero, `amount` tokens will be minted for `to`.
501      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
502      * - `from` and `to` are never both zero.
503      *
504      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
505      */
506     function _beforeTokenTransfer(
507         address from,
508         address to,
509         uint256 amount
510     ) internal virtual {}
511 
512     /**
513      * @dev Hook that is called after any transfer of tokens. This includes
514      * minting and burning.
515      *
516      * Calling conditions:
517      *
518      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
519      * has been transferred to `to`.
520      * - when `from` is zero, `amount` tokens have been minted for `to`.
521      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
522      * - `from` and `to` are never both zero.
523      *
524      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
525      */
526     function _afterTokenTransfer(
527         address from,
528         address to,
529         uint256 amount
530     ) internal virtual {}
531 }
532 
533 // File: @openzeppelin/contracts/access/Ownable.sol
534 
535 
536 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Contract module which provides a basic access control mechanism, where
543  * there is an account (an owner) that can be granted exclusive access to
544  * specific functions.
545  *
546  * By default, the owner account will be the one that deploys the contract. This
547  * can later be changed with {transferOwnership}.
548  *
549  * This module is used through inheritance. It will make available the modifier
550  * `onlyOwner`, which can be applied to your functions to restrict their use to
551  * the owner.
552  */
553 abstract contract Ownable is Context {
554     address private _owner;
555 
556     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
557 
558     /**
559      * @dev Initializes the contract setting the deployer as the initial owner.
560      */
561     constructor() {
562         _transferOwnership(_msgSender());
563     }
564 
565     /**
566      * @dev Throws if called by any account other than the owner.
567      */
568     modifier onlyOwner() {
569         _checkOwner();
570         _;
571     }
572 
573     /**
574      * @dev Returns the address of the current owner.
575      */
576     function owner() public view virtual returns (address) {
577         return _owner;
578     }
579 
580     /**
581      * @dev Throws if the sender is not the owner.
582      */
583     function _checkOwner() internal view virtual {
584         require(owner() == _msgSender(), "Ownable: caller is not the owner");
585     }
586 
587     /**
588      * @dev Leaves the contract without owner. It will not be possible to call
589      * `onlyOwner` functions anymore. Can only be called by the current owner.
590      *
591      * NOTE: Renouncing ownership will leave the contract without an owner,
592      * thereby removing any functionality that is only available to the owner.
593      */
594     function renounceOwnership() public virtual onlyOwner {
595         _transferOwnership(address(0));
596     }
597 
598     /**
599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
600      * Can only be called by the current owner.
601      */
602     function transferOwnership(address newOwner) public virtual onlyOwner {
603         require(newOwner != address(0), "Ownable: new owner is the zero address");
604         _transferOwnership(newOwner);
605     }
606 
607     /**
608      * @dev Transfers ownership of the contract to a new account (`newOwner`).
609      * Internal function without access restriction.
610      */
611     function _transferOwnership(address newOwner) internal virtual {
612         address oldOwner = _owner;
613         _owner = newOwner;
614         emit OwnershipTransferred(oldOwner, newOwner);
615     }
616 }
617 
618 // File: contracts/pepe.sol
619 
620 // https://t.me/PepeErc20Portal
621 pragma solidity ^0.8.17;
622 
623 
624 
625 contract PepeCoin is Ownable, ERC20 {
626     bool public limited;
627     uint256 public maxHoldingAmount;
628     uint256 public minHoldingAmount;
629     address public uniswapV2Pair;
630     mapping(address => bool) public blacklists;
631 
632     constructor(uint256 _totalSupply) ERC20("Pepe Coin", "PEPE") {
633         _mint(msg.sender, _totalSupply);
634     }
635 
636     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
637         blacklists[_address] = _isBlacklisting;
638     }
639 
640     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
641         limited = _limited;
642         uniswapV2Pair = _uniswapV2Pair;
643         maxHoldingAmount = _maxHoldingAmount;
644         minHoldingAmount = _minHoldingAmount;
645     }
646 
647     function _beforeTokenTransfer(
648         address from,
649         address to,
650         uint256 amount
651     ) override internal virtual {
652         require(!blacklists[to] && !blacklists[from], "Blacklisted");
653 
654         if (uniswapV2Pair == address(0)) {
655             require(from == owner() || to == owner(), "trading is not started");
656             return;
657         }
658 
659         if (limited && from == uniswapV2Pair) {
660             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
661         }
662     }
663 
664     function burn(uint256 value) external {
665         _burn(msg.sender, value);
666     }
667 }