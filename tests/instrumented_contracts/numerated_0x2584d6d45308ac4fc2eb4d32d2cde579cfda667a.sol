1 /**
2 
3 $WALT - Waltcoin
4 
5 Step aside, $Simpson and $ESCO, it's time to clear the stage.
6 For the kingpin of memecoins - our beloved chemist, Walter White!
7 
8 Website: https://waltcoin.money/
9 Telegram: https://t.me/waltcoin
10 Twitter: https://twitter.com/walterwhitecoin
11 
12 Enter the realm of meth cooking with $WALT
13 
14 */
15 
16 // Sources flattened with hardhat v2.7.0 https://hardhat.org
17 
18 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
19 
20 // SPDX-License-Identifier: MIT
21 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Provides information about the current execution context, including the
27  * sender of the transaction and its data. While these are generally available
28  * via msg.sender and msg.data, they should not be accessed in such a direct
29  * manner, since when dealing with meta-transactions the account sending and
30  * paying for execution may not be the actual sender (as far as an application
31  * is concerned).
32  *
33  * This contract is only required for intermediate, library-like contracts.
34  */
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes calldata) {
41         return msg.data;
42     }
43 }
44 
45 
46 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
47 
48 
49 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev Contract module which provides a basic access control mechanism, where
55  * there is an account (an owner) that can be granted exclusive access to
56  * specific functions.
57  *
58  * By default, the owner account will be the one that deploys the contract. This
59  * can later be changed with {transferOwnership}.
60  *
61  * This module is used through inheritance. It will make available the modifier
62  * `onlyOwner`, which can be applied to your functions to restrict their use to
63  * the owner.
64  */
65 abstract contract Ownable is Context {
66     address private _owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev Initializes the contract setting the deployer as the initial owner.
72      */
73     constructor() {
74         _transferOwnership(_msgSender());
75     }
76 
77     /**
78      * @dev Returns the address of the current owner.
79      */
80     function owner() public view virtual returns (address) {
81         return _owner;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the owner.
86      */
87     modifier onlyOwner() {
88         require(owner() == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     /**
93      * @dev Leaves the contract without owner. It will not be possible to call
94      * `onlyOwner` functions anymore. Can only be called by the current owner.
95      *
96      * NOTE: Renouncing ownership will leave the contract without an owner,
97      * thereby removing any functionality that is only available to the owner.
98      */
99     function renounceOwnership() public virtual onlyOwner {
100         _transferOwnership(address(0));
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Can only be called by the current owner.
106      */
107     function transferOwnership(address newOwner) public virtual onlyOwner {
108         require(newOwner != address(0), "Ownable: new owner is the zero address");
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Internal function without access restriction.
115      */
116     function _transferOwnership(address newOwner) internal virtual {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 
124 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
125 
126 
127 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 /**
132  * @dev Interface of the ERC20 standard as defined in the EIP.
133  */
134 interface IERC20 {
135     /**
136      * @dev Returns the amount of tokens in existence.
137      */
138     function totalSupply() external view returns (uint256);
139 
140     /**
141      * @dev Returns the amount of tokens owned by `account`.
142      */
143     function balanceOf(address account) external view returns (uint256);
144 
145     /**
146      * @dev Moves `amount` tokens from the caller's account to `recipient`.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transfer(address recipient, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Returns the remaining number of tokens that `spender` will be
156      * allowed to spend on behalf of `owner` through {transferFrom}. This is
157      * zero by default.
158      *
159      * This value changes when {approve} or {transferFrom} are called.
160      */
161     function allowance(address owner, address spender) external view returns (uint256);
162 
163     /**
164      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * IMPORTANT: Beware that changing an allowance with this method brings the risk
169      * that someone may use both the old and the new allowance by unfortunate
170      * transaction ordering. One possible solution to mitigate this race
171      * condition is to first reduce the spender's allowance to 0 and set the
172      * desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      *
175      * Emits an {Approval} event.
176      */
177     function approve(address spender, uint256 amount) external returns (bool);
178 
179     /**
180      * @dev Moves `amount` tokens from `sender` to `recipient` using the
181      * allowance mechanism. `amount` is then deducted from the caller's
182      * allowance.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transferFrom(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) external returns (bool);
193 
194     /**
195      * @dev Emitted when `value` tokens are moved from one account (`from`) to
196      * another (`to`).
197      *
198      * Note that `value` may be zero.
199      */
200     event Transfer(address indexed from, address indexed to, uint256 value);
201 
202     /**
203      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
204      * a call to {approve}. `value` is the new allowance.
205      */
206     event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 
210 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
211 
212 
213 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev Interface for the optional metadata functions from the ERC20 standard.
219  *
220  * _Available since v4.1._
221  */
222 interface IERC20Metadata is IERC20 {
223     /**
224      * @dev Returns the name of the token.
225      */
226     function name() external view returns (string memory);
227 
228     /**
229      * @dev Returns the symbol of the token.
230      */
231     function symbol() external view returns (string memory);
232 
233     /**
234      * @dev Returns the decimals places of the token.
235      */
236     function decimals() external view returns (uint8);
237 }
238 
239 
240 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
241 
242 
243 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 
248 
249 /**
250  * @dev Implementation of the {IERC20} interface.
251  *
252  * This implementation is agnostic to the way tokens are created. This means
253  * that a supply mechanism has to be added in a derived contract using {_mint}.
254  * For a generic mechanism see {ERC20PresetMinterPauser}.
255  *
256  * TIP: For a detailed writeup see our guide
257  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
258  * to implement supply mechanisms].
259  *
260  * We have followed general OpenZeppelin Contracts guidelines: functions revert
261  * instead returning `false` on failure. This behavior is nonetheless
262  * conventional and does not conflict with the expectations of ERC20
263  * applications.
264  *
265  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
266  * This allows applications to reconstruct the allowance for all accounts just
267  * by listening to said events. Other implementations of the EIP may not emit
268  * these events, as it isn't required by the specification.
269  *
270  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
271  * functions have been added to mitigate the well-known issues around setting
272  * allowances. See {IERC20-approve}.
273  */
274 contract ERC20 is Context, IERC20, IERC20Metadata {
275     mapping(address => uint256) private _balances;
276 
277     mapping(address => mapping(address => uint256)) private _allowances;
278 
279     uint256 private _totalSupply;
280 
281     string private _name;
282     string private _symbol;
283 
284     /**
285      * @dev Sets the values for {name} and {symbol}.
286      *
287      * The default value of {decimals} is 18. To select a different value for
288      * {decimals} you should overload it.
289      *
290      * All two of these values are immutable: they can only be set once during
291      * construction.
292      */
293     constructor(string memory name_, string memory symbol_) {
294         _name = name_;
295         _symbol = symbol_;
296     }
297 
298     /**
299      * @dev Returns the name of the token.
300      */
301     function name() public view virtual override returns (string memory) {
302         return _name;
303     }
304 
305     /**
306      * @dev Returns the symbol of the token, usually a shorter version of the
307      * name.
308      */
309     function symbol() public view virtual override returns (string memory) {
310         return _symbol;
311     }
312 
313     /**
314      * @dev Returns the number of decimals used to get its user representation.
315      * For example, if `decimals` equals `2`, a balance of `505` tokens should
316      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
317      *
318      * Tokens usually opt for a value of 18, imitating the relationship between
319      * Ether and Wei. This is the value {ERC20} uses, unless this function is
320      * overridden;
321      *
322      * NOTE: This information is only used for _display_ purposes: it in
323      * no way affects any of the arithmetic of the contract, including
324      * {IERC20-balanceOf} and {IERC20-transfer}.
325      */
326     function decimals() public view virtual override returns (uint8) {
327         return 18;
328     }
329 
330     /**
331      * @dev See {IERC20-totalSupply}.
332      */
333     function totalSupply() public view virtual override returns (uint256) {
334         return _totalSupply;
335     }
336 
337     /**
338      * @dev See {IERC20-balanceOf}.
339      */
340     function balanceOf(address account) public view virtual override returns (uint256) {
341         return _balances[account];
342     }
343 
344     /**
345      * @dev See {IERC20-transfer}.
346      *
347      * Requirements:
348      *
349      * - `recipient` cannot be the zero address.
350      * - the caller must have a balance of at least `amount`.
351      */
352     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
353         _transfer(_msgSender(), recipient, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-allowance}.
359      */
360     function allowance(address owner, address spender) public view virtual override returns (uint256) {
361         return _allowances[owner][spender];
362     }
363 
364     /**
365      * @dev See {IERC20-approve}.
366      *
367      * Requirements:
368      *
369      * - `spender` cannot be the zero address.
370      */
371     function approve(address spender, uint256 amount) public virtual override returns (bool) {
372         _approve(_msgSender(), spender, amount);
373         return true;
374     }
375 
376     /**
377      * @dev See {IERC20-transferFrom}.
378      *
379      * Emits an {Approval} event indicating the updated allowance. This is not
380      * required by the EIP. See the note at the beginning of {ERC20}.
381      *
382      * Requirements:
383      *
384      * - `sender` and `recipient` cannot be the zero address.
385      * - `sender` must have a balance of at least `amount`.
386      * - the caller must have allowance for ``sender``'s tokens of at least
387      * `amount`.
388      */
389     function transferFrom(
390         address sender,
391         address recipient,
392         uint256 amount
393     ) public virtual override returns (bool) {
394         _transfer(sender, recipient, amount);
395 
396         uint256 currentAllowance = _allowances[sender][_msgSender()];
397         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
398         unchecked {
399             _approve(sender, _msgSender(), currentAllowance - amount);
400         }
401 
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
418         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
419         return true;
420     }
421 
422     /**
423      * @dev Atomically decreases the allowance granted to `spender` by the caller.
424      *
425      * This is an alternative to {approve} that can be used as a mitigation for
426      * problems described in {IERC20-approve}.
427      *
428      * Emits an {Approval} event indicating the updated allowance.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      * - `spender` must have allowance for the caller of at least
434      * `subtractedValue`.
435      */
436     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
437         uint256 currentAllowance = _allowances[_msgSender()][spender];
438         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
439         unchecked {
440             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
441         }
442 
443         return true;
444     }
445 
446     /**
447      * @dev Moves `amount` of tokens from `sender` to `recipient`.
448      *
449      * This internal function is equivalent to {transfer}, and can be used to
450      * e.g. implement automatic token fees, slashing mechanisms, etc.
451      *
452      * Emits a {Transfer} event.
453      *
454      * Requirements:
455      *
456      * - `sender` cannot be the zero address.
457      * - `recipient` cannot be the zero address.
458      * - `sender` must have a balance of at least `amount`.
459      */
460     function _transfer(
461         address sender,
462         address recipient,
463         uint256 amount
464     ) internal virtual {
465         require(sender != address(0), "ERC20: transfer from the zero address");
466         require(recipient != address(0), "ERC20: transfer to the zero address");
467 
468         _beforeTokenTransfer(sender, recipient, amount);
469 
470         uint256 senderBalance = _balances[sender];
471         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
472         unchecked {
473             _balances[sender] = senderBalance - amount;
474         }
475         _balances[recipient] += amount;
476 
477         emit Transfer(sender, recipient, amount);
478 
479         _afterTokenTransfer(sender, recipient, amount);
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
497         _balances[account] += amount;
498         emit Transfer(address(0), account, amount);
499 
500         _afterTokenTransfer(address(0), account, amount);
501     }
502 
503     /**
504      * @dev Destroys `amount` tokens from `account`, reducing the
505      * total supply.
506      *
507      * Emits a {Transfer} event with `to` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      * - `account` must have at least `amount` tokens.
513      */
514     function _burn(address account, uint256 amount) internal virtual {
515         require(account != address(0), "ERC20: burn from the zero address");
516 
517         _beforeTokenTransfer(account, address(0), amount);
518 
519         uint256 accountBalance = _balances[account];
520         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
521         unchecked {
522             _balances[account] = accountBalance - amount;
523         }
524         _totalSupply -= amount;
525 
526         emit Transfer(account, address(0), amount);
527 
528         _afterTokenTransfer(account, address(0), amount);
529     }
530 
531     /**
532      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
533      *
534      * This internal function is equivalent to `approve`, and can be used to
535      * e.g. set automatic allowances for certain subsystems, etc.
536      *
537      * Emits an {Approval} event.
538      *
539      * Requirements:
540      *
541      * - `owner` cannot be the zero address.
542      * - `spender` cannot be the zero address.
543      */
544     function _approve(
545         address owner,
546         address spender,
547         uint256 amount
548     ) internal virtual {
549         require(owner != address(0), "ERC20: approve from the zero address");
550         require(spender != address(0), "ERC20: approve to the zero address");
551 
552         _allowances[owner][spender] = amount;
553         emit Approval(owner, spender, amount);
554     }
555 
556     /**
557      * @dev Hook that is called before any transfer of tokens. This includes
558      * minting and burning.
559      *
560      * Calling conditions:
561      *
562      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
563      * will be transferred to `to`.
564      * - when `from` is zero, `amount` tokens will be minted for `to`.
565      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
566      * - `from` and `to` are never both zero.
567      *
568      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
569      */
570     function _beforeTokenTransfer(
571         address from,
572         address to,
573         uint256 amount
574     ) internal virtual {}
575 
576     /**
577      * @dev Hook that is called after any transfer of tokens. This includes
578      * minting and burning.
579      *
580      * Calling conditions:
581      *
582      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
583      * has been transferred to `to`.
584      * - when `from` is zero, `amount` tokens have been minted for `to`.
585      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
586      * - `from` and `to` are never both zero.
587      *
588      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
589      */
590     function _afterTokenTransfer(
591         address from,
592         address to,
593         uint256 amount
594     ) internal virtual {}
595 }
596 
597 
598 // File contracts/Waltcoin.sol
599 
600 
601 
602 pragma solidity ^0.8.0;
603 
604 
605 contract Waltcoin is Ownable, ERC20 {
606     bool public limited;
607     uint256 public maxHoldingAmount;
608     uint256 public minHoldingAmount;
609     address public uniswapV2Pair;
610     mapping(address => bool) public blacklists;
611 
612     constructor(uint256 _totalSupply) ERC20("Walt coin", "WALT") {
613         _mint(msg.sender, _totalSupply);
614     }
615 
616     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
617         blacklists[_address] = _isBlacklisting;
618     }
619 
620     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
621         limited = _limited;
622         uniswapV2Pair = _uniswapV2Pair;
623         maxHoldingAmount = _maxHoldingAmount;
624         minHoldingAmount = _minHoldingAmount;
625     }
626 
627     function _beforeTokenTransfer(
628         address from,
629         address to,
630         uint256 amount
631     ) override internal virtual {
632         require(!blacklists[to] && !blacklists[from], "Blacklisted");
633 
634         if (uniswapV2Pair == address(0)) {
635             require(from == owner() || to == owner(), "trading is not started");
636             return;
637         }
638 
639         if (limited && from == uniswapV2Pair) {
640             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
641         }
642     }
643 
644     function burn(uint256 value) external {
645         _burn(msg.sender, value);
646     }
647 }