1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
3 
4 pragma solidity ^0.8.4;
5 
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
29 
30 
31 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.4;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 
106 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
107 
108 
109 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
110 
111 pragma solidity ^0.8.4;
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP.
115  */
116 interface IERC20 {
117     /**
118      * @dev Returns the amount of tokens in existence.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `recipient`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address recipient, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `sender` to `recipient` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) external returns (bool);
175 
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 
192 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
193 
194 
195 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
196 
197 pragma solidity ^0.8.4;
198 
199 /**
200  * @dev Interface for the optional metadata functions from the ERC20 standard.
201  *
202  * _Available since v4.1._
203  */
204 interface IERC20Metadata is IERC20 {
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the symbol of the token.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the decimals places of the token.
217      */
218     function decimals() external view returns (uint8);
219 }
220 
221 
222 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
223 
224 
225 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
226 
227 pragma solidity ^0.8.4;
228 
229 
230 
231 /**
232  * @dev Implementation of the {IERC20} interface.
233  *
234  * This implementation is agnostic to the way tokens are created. This means
235  * that a supply mechanism has to be added in a derived contract using {_mint}.
236  * For a generic mechanism see {ERC20PresetMinterPauser}.
237  *
238  * TIP: For a detailed writeup see our guide
239  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
240  * to implement supply mechanisms].
241  *
242  * We have followed general OpenZeppelin Contracts guidelines: functions revert
243  * instead returning `false` on failure. This behavior is nonetheless
244  * conventional and does not conflict with the expectations of ERC20
245  * applications.
246  *
247  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
248  * This allows applications to reconstruct the allowance for all accounts just
249  * by listening to said events. Other implementations of the EIP may not emit
250  * these events, as it isn't required by the specification.
251  *
252  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
253  * functions have been added to mitigate the well-known issues around setting
254  * allowances. See {IERC20-approve}.
255  */
256 contract ERC20 is Context, IERC20, IERC20Metadata {
257     mapping(address => uint256) private _balances;
258 
259     mapping(address => mapping(address => uint256)) private _allowances;
260 
261     uint256 private _totalSupply;
262 
263     string private _name;
264     string private _symbol;
265 
266     /**
267      * @dev Sets the values for {name} and {symbol}.
268      *
269      * The default value of {decimals} is 18. To select a different value for
270      * {decimals} you should overload it.
271      *
272      * All two of these values are immutable: they can only be set once during
273      * construction.
274      */
275     constructor(string memory name_, string memory symbol_) {
276         _name = name_;
277         _symbol = symbol_;
278     }
279 
280     /**
281      * @dev Returns the name of the token.
282      */
283     function name() public view virtual override returns (string memory) {
284         return _name;
285     }
286 
287     /**
288      * @dev Returns the symbol of the token, usually a shorter version of the
289      * name.
290      */
291     function symbol() public view virtual override returns (string memory) {
292         return _symbol;
293     }
294 
295     /**
296      * @dev Returns the number of decimals used to get its user representation.
297      * For example, if `decimals` equals `2`, a balance of `505` tokens should
298      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
299      *
300      * Tokens usually opt for a value of 18, imitating the relationship between
301      * Ether and Wei. This is the value {ERC20} uses, unless this function is
302      * overridden;
303      *
304      * NOTE: This information is only used for _display_ purposes: it in
305      * no way affects any of the arithmetic of the contract, including
306      * {IERC20-balanceOf} and {IERC20-transfer}.
307      */
308     function decimals() public view virtual override returns (uint8) {
309         return 18;
310     }
311 
312     /**
313      * @dev See {IERC20-totalSupply}.
314      */
315     function totalSupply() public view virtual override returns (uint256) {
316         return _totalSupply;
317     }
318 
319     /**
320      * @dev See {IERC20-balanceOf}.
321      */
322     function balanceOf(address account) public view virtual override returns (uint256) {
323         return _balances[account];
324     }
325 
326     /**
327      * @dev See {IERC20-transfer}.
328      *
329      * Requirements:
330      *
331      * - `recipient` cannot be the zero address.
332      * - the caller must have a balance of at least `amount`.
333      */
334     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
335         _transfer(_msgSender(), recipient, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-allowance}.
341      */
342     function allowance(address owner, address spender) public view virtual override returns (uint256) {
343         return _allowances[owner][spender];
344     }
345 
346     /**
347      * @dev See {IERC20-approve}.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      */
353     function approve(address spender, uint256 amount) public virtual override returns (bool) {
354         _approve(_msgSender(), spender, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-transferFrom}.
360      *
361      * Emits an {Approval} event indicating the updated allowance. This is not
362      * required by the EIP. See the note at the beginning of {ERC20}.
363      *
364      * Requirements:
365      *
366      * - `sender` and `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      * - the caller must have allowance for ``sender``'s tokens of at least
369      * `amount`.
370      */
371     function transferFrom(
372         address sender,
373         address recipient,
374         uint256 amount
375     ) public virtual override returns (bool) {
376         _transfer(sender, recipient, amount);
377 
378         uint256 currentAllowance = _allowances[sender][_msgSender()];
379         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
380         unchecked {
381             _approve(sender, _msgSender(), currentAllowance - amount);
382         }
383 
384         return true;
385     }
386 
387     /**
388      * @dev Atomically increases the allowance granted to `spender` by the caller.
389      *
390      * This is an alternative to {approve} that can be used as a mitigation for
391      * problems described in {IERC20-approve}.
392      *
393      * Emits an {Approval} event indicating the updated allowance.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      */
399     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
400         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
401         return true;
402     }
403 
404     /**
405      * @dev Atomically decreases the allowance granted to `spender` by the caller.
406      *
407      * This is an alternative to {approve} that can be used as a mitigation for
408      * problems described in {IERC20-approve}.
409      *
410      * Emits an {Approval} event indicating the updated allowance.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      * - `spender` must have allowance for the caller of at least
416      * `subtractedValue`.
417      */
418     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
419         uint256 currentAllowance = _allowances[_msgSender()][spender];
420         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
421         unchecked {
422             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
423         }
424 
425         return true;
426     }
427 
428     /**
429      * @dev Moves `amount` of tokens from `sender` to `recipient`.
430      *
431      * This internal function is equivalent to {transfer}, and can be used to
432      * e.g. implement automatic token fees, slashing mechanisms, etc.
433      *
434      * Emits a {Transfer} event.
435      *
436      * Requirements:
437      *
438      * - `sender` cannot be the zero address.
439      * - `recipient` cannot be the zero address.
440      * - `sender` must have a balance of at least `amount`.
441      */
442     function _transfer(
443         address sender,
444         address recipient,
445         uint256 amount
446     ) internal virtual {
447         require(sender != address(0), "ERC20: transfer from the zero address");
448         require(recipient != address(0), "ERC20: transfer to the zero address");
449 
450         _beforeTokenTransfer(sender, recipient, amount);
451 
452         uint256 senderBalance = _balances[sender];
453         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
454         unchecked {
455             _balances[sender] = senderBalance - amount;
456         }
457         _balances[recipient] += amount;
458 
459         emit Transfer(sender, recipient, amount);
460 
461         _afterTokenTransfer(sender, recipient, amount);
462     }
463 
464     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
465      * the total supply.
466      *
467      * Emits a {Transfer} event with `from` set to the zero address.
468      *
469      * Requirements:
470      *
471      * - `account` cannot be the zero address.
472      */
473     function _mint(address account, uint256 amount) internal virtual {
474         require(account != address(0), "ERC20: mint to the zero address");
475 
476         _beforeTokenTransfer(address(0), account, amount);
477 
478         _totalSupply += amount;
479         _balances[account] += amount;
480         emit Transfer(address(0), account, amount);
481 
482         _afterTokenTransfer(address(0), account, amount);
483     }
484 
485     /**
486      * @dev Destroys `amount` tokens from `account`, reducing the
487      * total supply.
488      *
489      * Emits a {Transfer} event with `to` set to the zero address.
490      *
491      * Requirements:
492      *
493      * - `account` cannot be the zero address.
494      * - `account` must have at least `amount` tokens.
495      */
496     function _burn(address account, uint256 amount) internal virtual {
497         require(account != address(0), "ERC20: burn from the zero address");
498 
499         _beforeTokenTransfer(account, address(0), amount);
500 
501         uint256 accountBalance = _balances[account];
502         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
503         unchecked {
504             _balances[account] = accountBalance - amount;
505         }
506         _totalSupply -= amount;
507 
508         emit Transfer(account, address(0), amount);
509 
510         _afterTokenTransfer(account, address(0), amount);
511     }
512 
513     /**
514      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
515      *
516      * This internal function is equivalent to `approve`, and can be used to
517      * e.g. set automatic allowances for certain subsystems, etc.
518      *
519      * Emits an {Approval} event.
520      *
521      * Requirements:
522      *
523      * - `owner` cannot be the zero address.
524      * - `spender` cannot be the zero address.
525      */
526     function _approve(
527         address owner,
528         address spender,
529         uint256 amount
530     ) internal virtual {
531         require(owner != address(0), "ERC20: approve from the zero address");
532         require(spender != address(0), "ERC20: approve to the zero address");
533 
534         _allowances[owner][spender] = amount;
535         emit Approval(owner, spender, amount);
536     }
537 
538     /**
539      * @dev Hook that is called before any transfer of tokens. This includes
540      * minting and burning.
541      *
542      * Calling conditions:
543      *
544      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
545      * will be transferred to `to`.
546      * - when `from` is zero, `amount` tokens will be minted for `to`.
547      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
548      * - `from` and `to` are never both zero.
549      *
550      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
551      */
552     function _beforeTokenTransfer(
553         address from,
554         address to,
555         uint256 amount
556     ) internal virtual {}
557 
558     /**
559      * @dev Hook that is called after any transfer of tokens. This includes
560      * minting and burning.
561      *
562      * Calling conditions:
563      *
564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
565      * has been transferred to `to`.
566      * - when `from` is zero, `amount` tokens have been minted for `to`.
567      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
568      * - `from` and `to` are never both zero.
569      *
570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
571      */
572     function _afterTokenTransfer(
573         address from,
574         address to,
575         uint256 amount
576     ) internal virtual {}
577 }
578 
579 interface IUniswapV2Factory {
580     function createPair(address tokenA, address tokenB) external returns (address pair);
581 }
582 
583 interface IUniswapV2Router02 {
584     function factory() external pure returns (address);
585     function WETH() external pure returns (address);
586 
587     function addLiquidityETH(
588         address token,
589         uint amountTokenDesired,
590         uint amountTokenMin,
591         uint amountETHMin,
592         address to,
593         uint deadline
594     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
595 
596     function swapExactTokensForETHSupportingFeeOnTransferTokens(
597         uint amountIn,
598         uint amountOutMin,
599         address[] calldata path,
600         address to,
601         uint deadline
602     ) external;
603 }
604 
605 // File contracts/PEEPER.sol
606 
607 pragma solidity ^0.8.4;
608 
609 
610 contract PEEPER is Ownable, ERC20 {
611     uint256 public maxHoldingAmount;
612     address public uniswapV2Pair;
613     IUniswapV2Router02 immutable router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
614 
615 
616 
617     address payable private marketingWallet;
618     uint256 public launchedAt;
619     uint256 SUPPLY = 690000000000 * 10**18;
620     uint256 fee = 25;
621     uint256 public initialTaxBlocks = 2;
622     bool private tradingOpen;    
623     bool private inSwap = false;
624 
625     constructor(
626         address payable _marketingWallet
627     ) ERC20("PEEPER", "PEEPER") payable {
628         _mint(msg.sender, SUPPLY * 5 / 100);
629         _mint(address(this), SUPPLY * 95 / 100);
630         maxHoldingAmount = SUPPLY * 125 / 10000;
631 
632         // Set the marketing wallet address
633         marketingWallet = _marketingWallet;
634     }
635 
636     receive() external payable {}
637 
638     function setFee(uint256 _fee) external onlyOwner {
639         require(_fee >= 0 && _fee <= 25, 'fee should be in 0 - 25');
640         fee = _fee;
641     }
642     
643     function removeFee() external onlyOwner {
644         fee = 0;
645     }
646 
647     function removeMaxHoldingAmount() external onlyOwner {
648         maxHoldingAmount = SUPPLY;
649     }
650     function enableTrading(bool _tradingOpen) external onlyOwner {
651         tradingOpen = _tradingOpen;
652     } 
653     function setLimits() external onlyOwner {
654         address pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
655         _approve(address(this), address(router), balanceOf(address(this)));
656         router.addLiquidityETH{
657             value: address(this).balance
658         } (
659             address(this),
660             balanceOf(address(this)),
661             0,
662             0,
663             owner(),
664             block.timestamp
665         );
666         uniswapV2Pair = pair;
667         launchedAt = block.number;
668     }
669 
670     function _transfer(address from, address to, uint256 amount) internal override {
671         if(uniswapV2Pair == address(0)) {
672             require(from == address(this) || from == address(0) || from == owner() || to == owner(), "Not started");
673             super._transfer(from, to, amount);
674             return;
675         }
676 
677         if(from == uniswapV2Pair && to != address(this) && to != owner() && to != address(router)) {
678             require(super.balanceOf(to) + amount <= maxHoldingAmount, "max wallet reached");
679         }
680 
681         uint256 swapAmount = balanceOf(address(this));
682 
683         if(swapAmount > SUPPLY / 1000) {
684             swapAmount = SUPPLY / 1000;
685         }
686 
687         if (swapAmount >= SUPPLY / 2000 &&
688             !inSwap &&
689             from != uniswapV2Pair) {
690 
691             inSwap = true;
692 
693             swapTokensForEth(swapAmount);
694 
695             uint256 balance = address(this).balance;
696 
697             if(balance > 0) {
698                 withdraw(balance);
699             }
700 
701             inSwap = false;
702         }
703 
704         uint256 currentFee;
705         if (block.number <= launchedAt + initialTaxBlocks) {
706             if (from == uniswapV2Pair) {
707                 currentFee = amount * 20 / 100; 
708             } else if (to == uniswapV2Pair) {
709                 currentFee = amount * 80 / 100; 
710             }
711         } else {
712             currentFee = amount * fee / 100;
713         }
714 
715         if (currentFee > 0 &&
716             from != address(this) &&
717             from != owner() &&
718             from != address(router)) {
719             amount -= currentFee;
720             super._transfer(from, address(this), currentFee);
721         }
722 
723         super._transfer(from, to, amount);
724     }
725 
726     function swapTokensForEth(uint256 tokenAmount) private {
727         address[] memory path = new address[](2);
728         path[0] = address(this);
729         path[1] = router.WETH();
730         _approve(address(this), address(router), tokenAmount);
731 
732         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
733             tokenAmount,
734             0,
735             path,
736             address(this),
737             block.timestamp
738         );
739     }
740 
741     function withdraw(uint256 amount) private {
742         (bool success,) = marketingWallet.call{value: amount}("");
743         success;
744     }
745 }