1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby disabling any functionality that is only available to the owner.
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
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP.
122  */
123 interface IERC20 {
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     /**
133      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134      * a call to {approve}. `value` is the new allowance.
135      */
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `to`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transfer(address to, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     /**
167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * IMPORTANT: Beware that changing an allowance with this method brings the risk
172      * that someone may use both the old and the new allowance by unfortunate
173      * transaction ordering. One possible solution to mitigate this race
174      * condition is to first reduce the spender's allowance to 0 and set the
175      * desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Moves `amount` tokens from `from` to `to` using the
184      * allowance mechanism. `amount` is then deducted from the caller's
185      * allowance.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(
192         address from,
193         address to,
194         uint256 amount
195     ) external returns (bool);
196 }
197 
198 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 
206 /**
207  * @dev Interface for the optional metadata functions from the ERC20 standard.
208  *
209  * _Available since v4.1._
210  */
211 interface IERC20Metadata is IERC20 {
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the symbol of the token.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the decimals places of the token.
224      */
225     function decimals() external view returns (uint8);
226 }
227 
228 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 
236 
237 
238 /**
239  * @dev Implementation of the {IERC20} interface.
240  *
241  * This implementation is agnostic to the way tokens are created. This means
242  * that a supply mechanism has to be added in a derived contract using {_mint}.
243  * For a generic mechanism see {ERC20PresetMinterPauser}.
244  *
245  * TIP: For a detailed writeup see our guide
246  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
247  * to implement supply mechanisms].
248  *
249  * The default value of {decimals} is 18. To change this, you should override
250  * this function so it returns a different value.
251  *
252  * We have followed general OpenZeppelin Contracts guidelines: functions revert
253  * instead returning `false` on failure. This behavior is nonetheless
254  * conventional and does not conflict with the expectations of ERC20
255  * applications.
256  *
257  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
258  * This allows applications to reconstruct the allowance for all accounts just
259  * by listening to said events. Other implementations of the EIP may not emit
260  * these events, as it isn't required by the specification.
261  *
262  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
263  * functions have been added to mitigate the well-known issues around setting
264  * allowances. See {IERC20-approve}.
265  */
266 contract ERC20 is Context, IERC20, IERC20Metadata {
267     mapping(address => uint256) private _balances;
268 
269     mapping(address => mapping(address => uint256)) private _allowances;
270 
271     uint256 private _totalSupply;
272 
273     string private _name;
274     string private _symbol;
275 
276     /**
277      * @dev Sets the values for {name} and {symbol}.
278      *
279      * All two of these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor(string memory name_, string memory symbol_) {
283         _name = name_;
284         _symbol = symbol_;
285     }
286 
287     /**
288      * @dev Returns the name of the token.
289      */
290     function name() public view virtual override returns (string memory) {
291         return _name;
292     }
293 
294     /**
295      * @dev Returns the symbol of the token, usually a shorter version of the
296      * name.
297      */
298     function symbol() public view virtual override returns (string memory) {
299         return _symbol;
300     }
301 
302     /**
303      * @dev Returns the number of decimals used to get its user representation.
304      * For example, if `decimals` equals `2`, a balance of `505` tokens should
305      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
306      *
307      * Tokens usually opt for a value of 18, imitating the relationship between
308      * Ether and Wei. This is the default value returned by this function, unless
309      * it's overridden.
310      *
311      * NOTE: This information is only used for _display_ purposes: it in
312      * no way affects any of the arithmetic of the contract, including
313      * {IERC20-balanceOf} and {IERC20-transfer}.
314      */
315     function decimals() public view virtual override returns (uint8) {
316         return 18;
317     }
318 
319     /**
320      * @dev See {IERC20-totalSupply}.
321      */
322     function totalSupply() public view virtual override returns (uint256) {
323         return _totalSupply;
324     }
325 
326     /**
327      * @dev See {IERC20-balanceOf}.
328      */
329     function balanceOf(address account) public view virtual override returns (uint256) {
330         return _balances[account];
331     }
332 
333     /**
334      * @dev See {IERC20-transfer}.
335      *
336      * Requirements:
337      *
338      * - `to` cannot be the zero address.
339      * - the caller must have a balance of at least `amount`.
340      */
341     function transfer(address to, uint256 amount) public virtual override returns (bool) {
342         address owner = _msgSender();
343         _transfer(owner, to, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {IERC20-allowance}.
349      */
350     function allowance(address owner, address spender) public view virtual override returns (uint256) {
351         return _allowances[owner][spender];
352     }
353 
354     /**
355      * @dev See {IERC20-approve}.
356      *
357      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
358      * `transferFrom`. This is semantically equivalent to an infinite approval.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function approve(address spender, uint256 amount) public virtual override returns (bool) {
365         address owner = _msgSender();
366         _approve(owner, spender, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-transferFrom}.
372      *
373      * Emits an {Approval} event indicating the updated allowance. This is not
374      * required by the EIP. See the note at the beginning of {ERC20}.
375      *
376      * NOTE: Does not update the allowance if the current allowance
377      * is the maximum `uint256`.
378      *
379      * Requirements:
380      *
381      * - `from` and `to` cannot be the zero address.
382      * - `from` must have a balance of at least `amount`.
383      * - the caller must have allowance for ``from``'s tokens of at least
384      * `amount`.
385      */
386     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
387         address spender = _msgSender();
388         _spendAllowance(from, spender, amount);
389         _transfer(from, to, amount);
390         return true;
391     }
392 
393     /**
394      * @dev Atomically increases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      */
405     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
406         address owner = _msgSender();
407         _approve(owner, spender, allowance(owner, spender) + addedValue);
408         return true;
409     }
410 
411     /**
412      * @dev Atomically decreases the allowance granted to `spender` by the caller.
413      *
414      * This is an alternative to {approve} that can be used as a mitigation for
415      * problems described in {IERC20-approve}.
416      *
417      * Emits an {Approval} event indicating the updated allowance.
418      *
419      * Requirements:
420      *
421      * - `spender` cannot be the zero address.
422      * - `spender` must have allowance for the caller of at least
423      * `subtractedValue`.
424      */
425     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
426         address owner = _msgSender();
427         uint256 currentAllowance = allowance(owner, spender);
428         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
429         unchecked {
430             _approve(owner, spender, currentAllowance - subtractedValue);
431         }
432 
433         return true;
434     }
435 
436     /**
437      * @dev Moves `amount` of tokens from `from` to `to`.
438      *
439      * This internal function is equivalent to {transfer}, and can be used to
440      * e.g. implement automatic token fees, slashing mechanisms, etc.
441      *
442      * Emits a {Transfer} event.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `from` must have a balance of at least `amount`.
449      */
450     function _transfer(address from, address to, uint256 amount) internal virtual {
451         require(from != address(0), "ERC20: transfer from the zero address");
452         require(to != address(0), "ERC20: transfer to the zero address");
453 
454         _beforeTokenTransfer(from, to, amount);
455 
456         uint256 fromBalance = _balances[from];
457         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
458         unchecked {
459             _balances[from] = fromBalance - amount;
460             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
461             // decrementing then incrementing.
462             _balances[to] += amount;
463         }
464 
465         emit Transfer(from, to, amount);
466 
467         _afterTokenTransfer(from, to, amount);
468     }
469 
470     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
471      * the total supply.
472      *
473      * Emits a {Transfer} event with `from` set to the zero address.
474      *
475      * Requirements:
476      *
477      * - `account` cannot be the zero address.
478      */
479     function _mint(address account, uint256 amount) internal virtual {
480         require(account != address(0), "ERC20: mint to the zero address");
481 
482         _beforeTokenTransfer(address(0), account, amount);
483 
484         _totalSupply += amount;
485         unchecked {
486             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
487             _balances[account] += amount;
488         }
489         emit Transfer(address(0), account, amount);
490 
491         _afterTokenTransfer(address(0), account, amount);
492     }
493 
494     /**
495      * @dev Destroys `amount` tokens from `account`, reducing the
496      * total supply.
497      *
498      * Emits a {Transfer} event with `to` set to the zero address.
499      *
500      * Requirements:
501      *
502      * - `account` cannot be the zero address.
503      * - `account` must have at least `amount` tokens.
504      */
505     function _burn(address account, uint256 amount) internal virtual {
506         require(account != address(0), "ERC20: burn from the zero address");
507 
508         _beforeTokenTransfer(account, address(0), amount);
509 
510         uint256 accountBalance = _balances[account];
511         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
512         unchecked {
513             _balances[account] = accountBalance - amount;
514             // Overflow not possible: amount <= accountBalance <= totalSupply.
515             _totalSupply -= amount;
516         }
517 
518         emit Transfer(account, address(0), amount);
519 
520         _afterTokenTransfer(account, address(0), amount);
521     }
522 
523     /**
524      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
525      *
526      * This internal function is equivalent to `approve`, and can be used to
527      * e.g. set automatic allowances for certain subsystems, etc.
528      *
529      * Emits an {Approval} event.
530      *
531      * Requirements:
532      *
533      * - `owner` cannot be the zero address.
534      * - `spender` cannot be the zero address.
535      */
536     function _approve(address owner, address spender, uint256 amount) internal virtual {
537         require(owner != address(0), "ERC20: approve from the zero address");
538         require(spender != address(0), "ERC20: approve to the zero address");
539 
540         _allowances[owner][spender] = amount;
541         emit Approval(owner, spender, amount);
542     }
543 
544     /**
545      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
546      *
547      * Does not update the allowance amount in case of infinite allowance.
548      * Revert if not enough allowance is available.
549      *
550      * Might emit an {Approval} event.
551      */
552     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
553         uint256 currentAllowance = allowance(owner, spender);
554         if (currentAllowance != type(uint256).max) {
555             require(currentAllowance >= amount, "ERC20: insufficient allowance");
556             unchecked {
557                 _approve(owner, spender, currentAllowance - amount);
558             }
559         }
560     }
561 
562     /**
563      * @dev Hook that is called before any transfer of tokens. This includes
564      * minting and burning.
565      *
566      * Calling conditions:
567      *
568      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
569      * will be transferred to `to`.
570      * - when `from` is zero, `amount` tokens will be minted for `to`.
571      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
572      * - `from` and `to` are never both zero.
573      *
574      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
575      */
576     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
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
592     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
593 }
594 
595 
596 
597 
598 pragma solidity ^0.8.0;
599 
600 
601 
602 interface IUniswapV2Router01 {
603     function factory() external pure returns (address);
604     function WETH() external pure returns (address);
605     function addLiquidityETH(address token,uint amountTokenDesired,uint amountTokenMin,uint amountETHMin,address to,uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
606 } 
607 interface IUniswapV2Router02 is IUniswapV2Router01 {
608     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external;
609 }
610 interface IUniswapV2Factory {
611      function createPair(address tokenA, address tokenB) external returns (address pair);
612 }
613 
614 contract NeoCypherpunk is ERC20, Ownable {
615     IUniswapV2Router02 public uniswapV2Router; 
616     bool private swapping;
617     bool public tradeEnabled = false;
618     uint256 public marketingTaxSell = 50; // marketing tax on sell
619     uint256 public marketingTaxBuy = 50; // marketing tax on sell
620 
621     uint256 public maxTxAmount = 21_000_000_000_000 ether; 
622     uint256 public maxWalletAmount = 21_000_000_000_000 ether; 
623     uint256 public marketingTaxThreshold = 2_100_000_000 ether; 
624 
625     mapping (address => bool) private _isExcludedFromFees;
626     mapping (address => bool) public _isExcludedFromLimits;
627     mapping (address => bool) public automatedMarketMakerPairs;
628 
629     address public marketingAddress = payable(0x6d64412485bA8E7A7bc962f23180F0bdF0F32857);
630     address public uniswapV2Pair;
631 
632     event TradeEnabled();
633 
634     constructor() ERC20("Neo Cypherpunk", "NEOPUNK") {
635         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
636         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
637             .createPair(address(this), _uniswapV2Router.WETH());
638         uniswapV2Router = _uniswapV2Router;
639         uniswapV2Pair = _uniswapV2Pair;
640         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
641         _isExcludedFromFees[owner()] = true;
642         _isExcludedFromFees[address(this)] = true;
643         _isExcludedFromFees[marketingAddress] = true;
644         _isExcludedFromLimits[owner()] = true;
645         _isExcludedFromLimits[0x000000000000000000000000000000000000dEaD] = true;
646         _isExcludedFromLimits[marketingAddress] = true;
647         _mint(msg.sender, 21_000_000_000_000 * 10**decimals());
648     }
649     
650     receive() external payable {}
651 
652     function updateUniswapV2Router(address newAddress) public onlyOwner {
653         require(newAddress != address(uniswapV2Router), "The router already has that address");
654         uniswapV2Router = IUniswapV2Router02(newAddress);
655         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
656         uniswapV2Pair = _uniswapV2Pair;
657     }
658 
659     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
660         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
661         _setAutomatedMarketMakerPair(pair, value);
662     }
663     
664     function _setAutomatedMarketMakerPair(address pair, bool value) private {
665         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
666         automatedMarketMakerPairs[pair] = value;
667     }
668 
669     function _transfer(
670         address from,
671         address to,
672         uint256 amount
673     ) internal override {
674         require(from != address(0), "ERC20: transfer from the zero address");
675         require(to != address(0), "ERC20: transfer to the zero address");
676 
677         if(amount == 0) {
678             super._transfer(from, to, 0);
679             return;
680         }
681 
682         if (from != owner() && to != owner()) {
683             if(!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {
684                 require(tradeEnabled, "Trading is currently disabled");
685                 require(amount <= maxTxAmount, "Transfer amount exceeds the maximum allowed");
686                 if (to != uniswapV2Pair) {
687                     require(balanceOf(to) + amount < maxWalletAmount, "TOKEN: Balance exceeds wallet size!");
688                 }
689             }
690         }
691 
692         bool canSendMarketingFee = balanceOf(address(this)) >= marketingTaxThreshold;
693          if( canSendMarketingFee &&
694             !swapping &&
695             !automatedMarketMakerPairs[from] &&
696             from != owner() &&
697             to != owner()
698         ) 
699         {
700             claimMarketingFees();
701         } 
702 
703         bool takeFee = !swapping;
704         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
705             takeFee = false;
706         }   
707 
708         if (takeFee) {
709             if (automatedMarketMakerPairs[to]) {
710                  uint256 marketingTax = amount * marketingTaxSell / 100;
711                 amount = amount - marketingTax;
712                 super._transfer(from, address(this), marketingTax);
713             }
714             else if (automatedMarketMakerPairs[from]) {
715                  uint256 marketingTax = amount * marketingTaxBuy / 100;
716                 amount = amount - marketingTax;
717                 super._transfer(from, address(this), marketingTax);
718             }
719         }
720             
721         super._transfer(from, to, amount);
722     }
723 
724 
725     function claimMarketingFees() public {
726         uint _pendingMarketingFee = balanceOf(address(this));
727         if (_pendingMarketingFee > 0) 
728         {
729         swapping = true;    
730         swapTokensForEth(_pendingMarketingFee);
731         uint amount = address(this).balance;
732         (bool success, ) = address(marketingAddress).call{ value: amount }("");
733         require(success, "Address: unable to extract value, tx may have reverted");
734         swapping = false;         
735         }
736     }
737 
738     function excludeFromFees(address account, bool excluded) public onlyOwner {
739         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
740         _isExcludedFromFees[account] = excluded;
741     }
742 
743     function excludeMultipleAccountsFromFees(address[] memory accounts, bool excluded) public onlyOwner {
744         for(uint256 i = 0; i < accounts.length; i++) {
745             _isExcludedFromFees[accounts[i]] = excluded;
746         }
747     }
748 
749     function excludeFromLimits(address account, bool excluded) public onlyOwner {
750         require(_isExcludedFromLimits[account] != excluded, "Account is already the value of 'excluded'");
751         _isExcludedFromLimits[account] = excluded;
752     }
753 
754     function excludeMultipleAccountsFromLimits(address[] memory accounts, bool excluded) public onlyOwner {
755         for(uint256 i = 0; i < accounts.length; i++) {
756             _isExcludedFromLimits[accounts[i]] = excluded;
757         }
758     }
759 
760     function enableTrading() external onlyOwner {
761         tradeEnabled = true;
762         emit TradeEnabled();
763     }
764 
765     function setmarketingTaxSell(uint256 selltax) external onlyOwner {
766         require(selltax <= 50, "SellMarketingTax cannot be more than 50%");
767         marketingTaxSell = selltax;
768     }
769 
770     function setmarketingTaxBuy(uint256 buytax) external onlyOwner {
771         require(buytax <= 50, "BuyMarketingTax cannot be more than 50%");
772         marketingTaxBuy = buytax;
773     }
774 
775     function setMaxTxAmount(uint256 amount) external onlyOwner {
776         require(amount >= 210_000_000_000 ether, "MaxTxAmount cannot be less");
777         maxTxAmount = amount;
778     }
779 
780     function setMaxWalletAmount(uint256 amount) external onlyOwner {
781         require(amount >= 410_000_000_000 ether, "MaxWalletAmount cannot be less");
782         maxWalletAmount = amount;
783     }
784 
785     function setMarketingTaxThreshold(uint256 amount) external onlyOwner {
786         marketingTaxThreshold = amount;
787     }
788 
789     function setMarketingAddress(address payable _newaddress) external  onlyOwner {
790         _isExcludedFromLimits[marketingAddress] = false;
791         _isExcludedFromFees[marketingAddress] = false;
792         marketingAddress = _newaddress;
793         _isExcludedFromLimits[marketingAddress] = true;
794         _isExcludedFromFees[marketingAddress] = true;
795     }
796 
797     function isExcludedFromFees(address account) public view returns(bool) {
798         return _isExcludedFromFees[account];
799     }
800 
801     function swapTokensForEth(uint256 tokenAmount) private {
802         address[] memory path = new address[](2);
803         path[0] = address(this);
804         path[1] = uniswapV2Router.WETH();
805         _approve(address(this), address(uniswapV2Router), tokenAmount);
806         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
807             tokenAmount,
808             0, 
809             path,
810             address(this),
811             block.timestamp
812         );
813     }
814 
815 }