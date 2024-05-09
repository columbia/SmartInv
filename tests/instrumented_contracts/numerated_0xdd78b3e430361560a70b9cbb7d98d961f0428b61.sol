1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-14
3 */
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
14 
15 interface IRouter {
16     function factory() external pure returns (address);
17 
18     function WETH() external pure returns (address);
19 
20     function addLiquidityETH(
21         address token,
22         uint256 amountTokenDesired,
23         uint256 amountTokenMin,
24         uint256 amountETHMin,
25         address to,
26         uint256 deadline
27     )
28         external
29         payable
30         returns (
31             uint256 amountToken,
32             uint256 amountETH,
33             uint256 liquidity
34         );
35 
36     function swapExactTokensForETHSupportingFeeOnTransferTokens(
37         uint256 amountIn,
38         uint256 amountOutMin,
39         address[] calldata path,
40         address to,
41         uint256 deadline
42     ) external;
43 }
44 
45 interface IFactory {
46     function createPair(address tokenA, address tokenB) external returns (address pair);
47 }
48 
49 
50 /**
51  * @dev Provides information about the current execution context, including the
52  * sender of the transaction and its data. While these are generally available
53  * via msg.sender and msg.data, they should not be accessed in such a direct
54  * manner, since when dealing with meta-transactions the account sending and
55  * paying for execution may not be the actual sender (as far as an application
56  * is concerned).
57  *
58  * This contract is only required for intermediate, library-like contracts.
59  */
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64 
65     function _msgData() internal view virtual returns (bytes calldata) {
66         return msg.data;
67     }
68 }
69 
70 
71 
72 /**
73  * @dev Contract module which provides a basic access control mechanism, where
74  * there is an account (an owner) that can be granted exclusive access to
75  * specific functions.
76  *
77  * By default, the owner account will be the one that deploys the contract. This
78  * can later be changed with {transferOwnership}.
79  *
80  * This module is used through inheritance. It will make available the modifier
81  * `onlyOwner`, which can be applied to your functions to restrict their use to
82  * the owner.
83  */
84 abstract contract Ownable is Context {
85     address private _owner;
86 
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     /**
90      * @dev Initializes the contract setting the deployer as the initial owner.
91      */
92     constructor() {
93         _transferOwnership(_msgSender());
94     }
95 
96     /**
97      * @dev Returns the address of the current owner.
98      */
99     function owner() public view virtual returns (address) {
100         return _owner;
101     }
102 
103     /**
104      * @dev Throws if called by any account other than the owner.
105      */
106     modifier onlyOwner() {
107         require(owner() == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110 
111     /**
112      * @dev Leaves the contract without owner. It will not be possible to call
113      * `onlyOwner` functions anymore. Can only be called by the current owner.
114      *
115      * NOTE: Renouncing ownership will leave the contract without an owner,
116      * thereby removing any functionality that is only available to the owner.
117      */
118     function renounceOwnership() public virtual onlyOwner {
119         _transferOwnership(address(0));
120     }
121 
122     /**
123      * @dev Transfers ownership of the contract to a new account (`newOwner`).
124      * Can only be called by the current owner.
125      */
126     function transferOwnership(address newOwner) public virtual onlyOwner {
127         require(newOwner != address(0), "Ownable: new owner is the zero address");
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
133      * Internal function without access restriction.
134      */
135     function _transferOwnership(address newOwner) internal virtual {
136         address oldOwner = _owner;
137         _owner = newOwner;
138         emit OwnershipTransferred(oldOwner, newOwner);
139     }
140 }
141 
142 
143 
144 
145 /**
146  * @dev Interface of the ERC20 standard as defined in the EIP.
147  */
148 interface IERC20 {
149     /**
150      * @dev Returns the amount of tokens in existence.
151      */
152     function totalSupply() external view returns (uint256);
153 
154     /**
155      * @dev Returns the amount of tokens owned by `account`.
156      */
157     function balanceOf(address account) external view returns (uint256);
158 
159     /**
160      * @dev Moves `amount` tokens from the caller's account to `recipient`.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transfer(address recipient, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Returns the remaining number of tokens that `spender` will be
170      * allowed to spend on behalf of `owner` through {transferFrom}. This is
171      * zero by default.
172      *
173      * This value changes when {approve} or {transferFrom} are called.
174      */
175     function allowance(address owner, address spender) external view returns (uint256);
176 
177     /**
178      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * IMPORTANT: Beware that changing an allowance with this method brings the risk
183      * that someone may use both the old and the new allowance by unfortunate
184      * transaction ordering. One possible solution to mitigate this race
185      * condition is to first reduce the spender's allowance to 0 and set the
186      * desired value afterwards:
187      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      *
189      * Emits an {Approval} event.
190      */
191     function approve(address spender, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Moves `amount` tokens from `sender` to `recipient` using the
195      * allowance mechanism. `amount` is then deducted from the caller's
196      * allowance.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(
203         address sender,
204         address recipient,
205         uint256 amount
206     ) external returns (bool);
207 
208     /**
209      * @dev Emitted when `value` tokens are moved from one account (`from`) to
210      * another (`to`).
211      *
212      * Note that `value` may be zero.
213      */
214     event Transfer(address indexed from, address indexed to, uint256 value);
215 
216     /**
217      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
218      * a call to {approve}. `value` is the new allowance.
219      */
220     event Approval(address indexed owner, address indexed spender, uint256 value);
221 }
222 
223 
224 
225 /**
226  * @dev Interface for the optional metadata functions from the ERC20 standard.
227  *
228  * _Available since v4.1._
229  */
230 interface IERC20Metadata is IERC20 {
231     /**
232      * @dev Returns the name of the token.
233      */
234     function name() external view returns (string memory);
235 
236     /**
237      * @dev Returns the symbol of the token.
238      */
239     function symbol() external view returns (string memory);
240 
241     /**
242      * @dev Returns the decimals places of the token.
243      */
244     function decimals() external view returns (uint8);
245 }
246 
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
259  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
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
351      * - `recipient` cannot be the zero address.
352      * - the caller must have a balance of at least `amount`.
353      */
354     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
355         _transfer(_msgSender(), recipient, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-allowance}.
361      */
362     function allowance(address owner, address spender) public view virtual override returns (uint256) {
363         return _allowances[owner][spender];
364     }
365 
366     /**
367      * @dev See {IERC20-approve}.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      */
373     function approve(address spender, uint256 amount) public virtual override returns (bool) {
374         _approve(_msgSender(), spender, amount);
375         return true;
376     }
377 
378     /**
379      * @dev See {IERC20-transferFrom}.
380      *
381      * Emits an {Approval} event indicating the updated allowance. This is not
382      * required by the EIP. See the note at the beginning of {ERC20}.
383      *
384      * Requirements:
385      *
386      * - `sender` and `recipient` cannot be the zero address.
387      * - `sender` must have a balance of at least `amount`.
388      * - the caller must have allowance for ``sender``'s tokens of at least
389      * `amount`.
390      */
391     function transferFrom(
392         address sender,
393         address recipient,
394         uint256 amount
395     ) public virtual override returns (bool) {
396         _transfer(sender, recipient, amount);
397 
398         uint256 currentAllowance = _allowances[sender][_msgSender()];
399         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
400         unchecked {
401             _approve(sender, _msgSender(), currentAllowance - amount);
402         }
403 
404         return true;
405     }
406 
407     /**
408      * @dev Atomically increases the allowance granted to `spender` by the caller.
409      *
410      * This is an alternative to {approve} that can be used as a mitigation for
411      * problems described in {IERC20-approve}.
412      *
413      * Emits an {Approval} event indicating the updated allowance.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
420         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
421         return true;
422     }
423 
424     /**
425      * @dev Atomically decreases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      * - `spender` must have allowance for the caller of at least
436      * `subtractedValue`.
437      */
438     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
439         uint256 currentAllowance = _allowances[_msgSender()][spender];
440         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
441         unchecked {
442             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
443         }
444 
445         return true;
446     }
447 
448     /**
449      * @dev Moves `amount` of tokens from `sender` to `recipient`.
450      *
451      * This internal function is equivalent to {transfer}, and can be used to
452      * e.g. implement automatic token fees, slashing mechanisms, etc.
453      *
454      * Emits a {Transfer} event.
455      *
456      * Requirements:
457      *
458      * - `sender` cannot be the zero address.
459      * - `recipient` cannot be the zero address.
460      * - `sender` must have a balance of at least `amount`.
461      */
462     function _transfer(
463         address sender,
464         address recipient,
465         uint256 amount
466     ) internal virtual {
467         require(sender != address(0), "ERC20: transfer from the zero address");
468         require(recipient != address(0), "ERC20: transfer to the zero address");
469 
470         _beforeTokenTransfer(sender, recipient, amount);
471 
472         uint256 senderBalance = _balances[sender];
473         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
474         unchecked {
475             _balances[sender] = senderBalance - amount;
476         }
477         _balances[recipient] += amount;
478 
479         emit Transfer(sender, recipient, amount);
480 
481         _afterTokenTransfer(sender, recipient, amount);
482     }
483 
484     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
485      * the total supply.
486      *
487      * Emits a {Transfer} event with `from` set to the zero address.
488      *
489      * Requirements:
490      *
491      * - `account` cannot be the zero address.
492      */
493     function _mint(address account, uint256 amount) internal virtual {
494         require(account != address(0), "ERC20: mint to the zero address");
495 
496         _beforeTokenTransfer(address(0), account, amount);
497 
498         _totalSupply += amount;
499         _balances[account] += amount;
500         emit Transfer(address(0), account, amount);
501 
502         _afterTokenTransfer(address(0), account, amount);
503     }
504 
505     /**
506      * @dev Destroys `amount` tokens from `account`, reducing the
507      * total supply.
508      *
509      * Emits a {Transfer} event with `to` set to the zero address.
510      *
511      * Requirements:
512      *
513      * - `account` cannot be the zero address.
514      * - `account` must have at least `amount` tokens.
515      */
516     function _burn(address account, uint256 amount) internal virtual {
517         require(account != address(0), "ERC20: burn from the zero address");
518 
519         _beforeTokenTransfer(account, address(0), amount);
520 
521         uint256 accountBalance = _balances[account];
522         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
523         unchecked {
524             _balances[account] = accountBalance - amount;
525         }
526         _totalSupply -= amount;
527 
528         emit Transfer(account, address(0), amount);
529 
530         _afterTokenTransfer(account, address(0), amount);
531     }
532 
533     /**
534      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
535      *
536      * This internal function is equivalent to `approve`, and can be used to
537      * e.g. set automatic allowances for certain subsystems, etc.
538      *
539      * Emits an {Approval} event.
540      *
541      * Requirements:
542      *
543      * - `owner` cannot be the zero address.
544      * - `spender` cannot be the zero address.
545      */
546     function _approve(
547         address owner,
548         address spender,
549         uint256 amount
550     ) internal virtual {
551         require(owner != address(0), "ERC20: approve from the zero address");
552         require(spender != address(0), "ERC20: approve to the zero address");
553 
554         _allowances[owner][spender] = amount;
555         emit Approval(owner, spender, amount);
556     }
557 
558     /**
559      * @dev Hook that is called before any transfer of tokens. This includes
560      * minting and burning.
561      *
562      * Calling conditions:
563      *
564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
565      * will be transferred to `to`.
566      * - when `from` is zero, `amount` tokens will be minted for `to`.
567      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
568      * - `from` and `to` are never both zero.
569      *
570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
571      */
572     function _beforeTokenTransfer(
573         address from,
574         address to,
575         uint256 amount
576     ) internal virtual {}
577 
578     /**
579      * @dev Hook that is called after any transfer of tokens. This includes
580      * minting and burning.
581      *
582      * Calling conditions:
583      *
584      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
585      * has been transferred to `to`.
586      * - when `from` is zero, `amount` tokens have been minted for `to`.
587      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
588      * - `from` and `to` are never both zero.
589      *
590      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
591      */
592     function _afterTokenTransfer(
593         address from,
594         address to,
595         uint256 amount
596     ) internal virtual {}
597 }
598 
599 
600 
601 contract Patrick is Ownable, ERC20 {
602     bool public limited;
603     bool public enableWhitel;
604     uint256 public maxHoldingAmount;
605     uint256 public minHoldingAmount;
606     address public uniswapV2Pair;
607     mapping(address => bool) public blacklists;
608     mapping(address => bool) public whitelists;
609 
610     IRouter public router;
611     IFactory public factory;
612 
613 
614     constructor() ERC20("Patrick", "Pat") {
615         uint256 _totalSupply = 500 * 10**8 * 10**18;
616         _mint(msg.sender, _totalSupply);
617 
618         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
619         // Create a pancake pair for this new token
620         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
621 
622         router = _router;
623         uniswapV2Pair = _pair;
624 
625         enableWhitel = true;
626         whitelists[msg.sender] = true;
627         whitelists[address(router)] = true;
628         whitelists[uniswapV2Pair] = true;
629     }
630 
631     function settwhitelist(address[] memory accounts, bool _iswhitelisting) external onlyOwner {
632         for (uint256 i = 0; i < accounts.length; i++) {
633             whitelists[accounts[i]] = _iswhitelisting;
634         }
635     }
636 
637     function whitelist(address _address, bool _iswhitelisting) external onlyOwner {
638         whitelists[_address] = _iswhitelisting;
639     }
640 
641     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
642         blacklists[_address] = _isBlacklisting;
643     }
644 
645     function setEnableWhitel(bool isEnableWhitel)  external onlyOwner {
646         enableWhitel = isEnableWhitel;
647     }
648 
649     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
650         limited = _limited;
651         maxHoldingAmount = _maxHoldingAmount;
652         minHoldingAmount = _minHoldingAmount;
653 
654         if(_uniswapV2Pair != uniswapV2Pair && _uniswapV2Pair != address(0))
655         {
656             uniswapV2Pair = _uniswapV2Pair;
657             whitelists[uniswapV2Pair] = true;
658         }
659     }
660 
661     function _beforeTokenTransfer(
662         address from,
663         address to,
664         uint256 amount
665     ) override internal virtual {
666         require(!blacklists[to] && !blacklists[from], "Blacklisted");
667 
668         if(enableWhitel) {
669             require(whitelists[from]==true && whitelists[to]==true, "whitelist");
670         }
671 
672         if (uniswapV2Pair == address(0)) {
673             require(from == owner() || to == owner(), "trading is not started");
674             return;
675         }
676 
677         if (limited && from == uniswapV2Pair) {
678             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
679         }
680     }
681 }