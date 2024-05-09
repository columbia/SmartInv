1 pragma solidity ^0.8.0;
2 //SPDX-License-Identifier: MIT
3 
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 /**
79  * @dev Interface for the optional metadata functions from the ERC20 standard.
80  *
81  * _Available since v4.1._
82  */
83 interface IERC20Metadata is IERC20 {
84     /**
85      * @dev Returns the name of the token.
86      */
87     function name() external view returns (string memory);
88 
89     /**
90      * @dev Returns the symbol of the token.
91      */
92     function symbol() external view returns (string memory);
93 
94     /**
95      * @dev Returns the decimals places of the token.
96      */
97     function decimals() external view returns (uint8);
98 }
99 /*
100  * @dev Provides information about the current execution context, including the
101  * sender of the transaction and its data. While these are generally available
102  * via msg.sender and msg.data, they should not be accessed in such a direct
103  * manner, since when dealing with meta-transactions the account sending and
104  * paying for execution may not be the actual sender (as far as an application
105  * is concerned).
106  *
107  * This contract is only required for intermediate, library-like contracts.
108  */
109 abstract contract Context {
110     function _msgSender() internal view virtual returns (address) {
111         return msg.sender;
112     }
113 
114     function _msgData() internal view virtual returns (bytes calldata) {
115         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
116         return msg.data;
117     }
118 }
119 
120 contract Ownable is Context {
121     address private _owner;
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor () {
127         address msgSender = _msgSender();
128         _owner = msgSender;
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(_owner == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Leaves the contract without owner. It will not be possible to call
148      * `onlyOwner` functions anymore. Can only be called by the current owner.
149      *
150      * NOTE: Renouncing ownership will leave the contract without an owner,
151      * thereby removing any functionality that is only available to the owner.
152      */
153     function renounceOwnership() public virtual onlyOwner {
154         _owner = address(0);
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         _owner = newOwner;
164     }
165 }
166 
167 /**
168  * @dev Implementation of the {IERC20} interface.
169  *
170  * This implementation is agnostic to the way tokens are created. This means
171  * that a supply mechanism has to be added in a derived contract using {_mint}.
172  * For a generic mechanism see {ERC20PresetMinterPauser}.
173  *
174  * TIP: For a detailed writeup see our guide
175  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
176  * to implement supply mechanisms].
177  *
178  * We have followed general OpenZeppelin guidelines: functions revert instead
179  * of returning `false` on failure. This behavior is nonetheless conventional
180  * and does not conflict with the expectations of ERC20 applications.
181  *
182  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
183  * This allows applications to reconstruct the allowance for all accounts just
184  * by listening to said events. Other implementations of the EIP may not emit
185  * these events, as it isn't required by the specification.
186  *
187  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
188  * functions have been added to mitigate the well-known issues around setting
189  * allowances. See {IERC20-approve}.
190  */
191 contract ERC20 is Context, IERC20, IERC20Metadata {
192     using SafeMath for uint256;
193 
194     mapping(address => uint256) private _balances;
195 
196     mapping(address => mapping(address => uint256)) private _allowances;
197 
198     uint256 private _totalSupply;
199 
200     string private _name;
201     string private _symbol;
202 
203     /**
204      * @dev Sets the values for {name} and {symbol}.
205      *
206      * The default value of {decimals} is 18. To select a different value for
207      * {decimals} you should overload it.
208      *
209      * All two of these values are immutable: they can only be set once during
210      * construction.
211      */
212     constructor(string memory name_, string memory symbol_)  {
213         _name = name_;
214         _symbol = symbol_;
215     }
216 
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() public view virtual override returns (string memory) {
221         return _name;
222     }
223 
224     /**
225      * @dev Returns the symbol of the token, usually a shorter version of the
226      * name.
227      */
228     function symbol() public view virtual override returns (string memory) {
229         return _symbol;
230     }
231 
232     /**
233      * @dev Returns the number of decimals used to get its user representation.
234      * For example, if `decimals` equals `2`, a balance of `505` tokens should
235      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
236      *
237      * Tokens usually opt for a value of 18, imitating the relationship between
238      * Ether and Wei. This is the value {ERC20} uses, unless this function is
239      * overridden;
240      *
241      * NOTE: This information is only used for _display_ purposes: it in
242      * no way affects any of the arithmetic of the contract, including
243      * {IERC20-balanceOf} and {IERC20-transfer}.
244      */
245     function decimals() public view virtual override returns (uint8) {
246         return 18;
247     }
248 
249     /**
250      * @dev See {IERC20-totalSupply}.
251      */
252     function totalSupply() public view virtual override returns (uint256) {
253         return _totalSupply;
254     }
255 
256     /**
257      * @dev See {IERC20-balanceOf}.
258      */
259     function balanceOf(address account) public view virtual override returns (uint256) {
260         return _balances[account];
261     }
262 
263     /**
264      * @dev See {IERC20-transfer}.
265      *
266      * Requirements:
267      *
268      * - `recipient` cannot be the zero address.
269      * - the caller must have a balance of at least `amount`.
270      */
271     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
272         _transfer(_msgSender(), recipient, amount);
273         return true;
274     }
275 
276     /**
277      * @dev See {IERC20-allowance}.
278      */
279     function allowance(address owner, address spender) public view virtual override returns (uint256) {
280         return _allowances[owner][spender];
281     }
282 
283     /**
284      * @dev See {IERC20-approve}.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      */
290     function approve(address spender, uint256 amount) public virtual override returns (bool) {
291         _approve(_msgSender(), spender, amount);
292         return true;
293     }
294 
295     /**
296      * @dev See {IERC20-transferFrom}.
297      *
298      * Emits an {Approval} event indicating the updated allowance. This is not
299      * required by the EIP. See the note at the beginning of {ERC20}.
300      *
301      * Requirements:
302      *
303      * - `sender` and `recipient` cannot be the zero address.
304      * - `sender` must have a balance of at least `amount`.
305      * - the caller must have allowance for ``sender``'s tokens of at least
306      * `amount`.
307      */
308     function transferFrom(
309         address sender,
310         address recipient,
311         uint256 amount
312     ) public virtual override returns (bool) {
313         _transfer(sender, recipient, amount);
314         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
315         return true;
316     }
317 
318     /**
319      * @dev Atomically increases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      */
330     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
331         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
332         return true;
333     }
334 
335     /**
336      * @dev Atomically decreases the allowance granted to `spender` by the caller.
337      *
338      * This is an alternative to {approve} that can be used as a mitigation for
339      * problems described in {IERC20-approve}.
340      *
341      * Emits an {Approval} event indicating the updated allowance.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      * - `spender` must have allowance for the caller of at least
347      * `subtractedValue`.
348      */
349     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
350         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
351         return true;
352     }
353 
354     /**
355      * @dev Moves tokens `amount` from `sender` to `recipient`.
356      *
357      * This is internal function is equivalent to {transfer}, and can be used to
358      * e.g. implement automatic token fees, slashing mechanisms, etc.
359      *
360      * Emits a {Transfer} event.
361      *
362      * Requirements:
363      *
364      * - `sender` cannot be the zero address.
365      * - `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      */
368     function _transfer(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) internal virtual {
373         require(sender != address(0), "ERC20: transfer from the zero address");
374         require(recipient != address(0), "ERC20: transfer to the zero address");
375 
376         _beforeTokenTransfer(sender, recipient, amount);
377 
378         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
379         _balances[recipient] = _balances[recipient].add(amount);
380         emit Transfer(sender, recipient, amount);
381     }
382 
383     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
384      * the total supply.
385      *
386      * Emits a {Transfer} event with `from` set to the zero address.
387      *
388      * Requirements:
389      *
390      * - `account` cannot be the zero address.
391      */
392     function _mint(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: mint to the zero address");
394 
395         _beforeTokenTransfer(address(0), account, amount);
396 
397         _totalSupply = _totalSupply.add(amount);
398         _balances[account] = _balances[account].add(amount);
399         emit Transfer(address(0), account, amount);
400     }
401 
402     /**
403      * @dev Destroys `amount` tokens from `account`, reducing the
404      * total supply.
405      *
406      * Emits a {Transfer} event with `to` set to the zero address.
407      *
408      * Requirements:
409      *
410      * - `account` cannot be the zero address.
411      * - `account` must have at least `amount` tokens.
412      */
413     function _burn(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: burn from the zero address");
415 
416         _beforeTokenTransfer(account, address(0), amount);
417 
418         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
419         _totalSupply = _totalSupply.sub(amount);
420         emit Transfer(account, address(0), amount);
421     }
422 
423     /**
424      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
425      *
426      * This internal function is equivalent to `approve`, and can be used to
427      * e.g. set automatic allowances for certain subsystems, etc.
428      *
429      * Emits an {Approval} event.
430      *
431      * Requirements:
432      *
433      * - `owner` cannot be the zero address.
434      * - `spender` cannot be the zero address.
435      */
436     function _approve(
437         address owner,
438         address spender,
439         uint256 amount
440     ) internal virtual {
441         require(owner != address(0), "ERC20: approve from the zero address");
442         require(spender != address(0), "ERC20: approve to the zero address");
443 
444         _allowances[owner][spender] = amount;
445         emit Approval(owner, spender, amount);
446     }
447 
448     /**
449      * @dev Hook that is called before any transfer of tokens. This includes
450      * minting and burning.
451      *
452      * Calling conditions:
453      *
454      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
455      * will be to transferred to `to`.
456      * - when `from` is zero, `amount` tokens will be minted for `to`.
457      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
458      * - `from` and `to` are never both zero.
459      *
460      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
461      */
462     function _beforeTokenTransfer(
463         address from,
464         address to,
465         uint256 amount
466     ) internal virtual {}
467 }
468 
469 contract NOVACS is ERC20, Ownable {
470 
471     IUniswapV2Router02 public uniswapV2Router;
472 
473     bool private swapping;
474     bool private enableTrade = true;
475 
476     address public constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
477     address public constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
478     address public marketWallet = 0xA6DB725523cf0e8405225aFCB407F91BdEB3712A;
479     address public tokenOwner = 0xBC92bE92EdD9b61511610C4261E24AC39c54B82c;
480 
481     uint256 public numTokensSellToSwap = 10000000000 * 1e18;
482     
483     uint256 public buyMarketingFee = 2; 
484     
485     uint256 public sellMarketingFee = 2;
486 
487 
488     // exlcude from fees and max transaction amount
489     mapping (address => bool) public isExcludedFromFees;
490     mapping (address => bool) public isPair;
491     mapping (address => bool) public isBlclist;
492 
493     modifier lockTheSwap {
494         swapping = true;
495         _;
496         swapping = false;
497     }
498 
499     constructor() ERC20("novacs", "novacs") {
500         
501         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(ROUTER);
502         address _WETH = _uniswapV2Router.WETH();
503          // Create a uniswap pair for this new token
504         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
505             .createPair(address(this), _WETH);
506         address _uniswapV2PairUSDT = IUniswapV2Factory(_uniswapV2Router.factory())
507             .createPair(address(this), USDT);
508         isPair[_uniswapV2Pair] = true;
509         isPair[_uniswapV2PairUSDT] = true;
510 
511         uniswapV2Router = _uniswapV2Router;
512 
513         // exclude from paying fees or having max transaction amount
514         excludeFromFees(owner(), true);
515         excludeFromFees(marketWallet, true);
516         excludeFromFees(address(this), true);
517 
518         _approve(address(this), ROUTER, type(uint).max);
519 
520         /*
521             _mint is an internal function in ERC20.sol that is only called here,
522             and CANNOT be called ever again
523         */
524         _mint(tokenOwner, 100000000000000 * 1e18);
525     }
526 
527     receive() external payable {}
528 
529     function excludeFromFees(address account, bool excluded) public onlyOwner {
530         isExcludedFromFees[account] = excluded;
531     }
532 
533     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
534         for(uint256 i = 0; i < accounts.length; i++) {
535             isExcludedFromFees[accounts[i]] = excluded;
536         }
537     }
538 
539     function setEnableTrade(bool _enableTrade) external onlyOwner {
540         enableTrade = _enableTrade;
541     }
542 
543     function setBuyMarketingFee(uint256 _buyMarketingFee) external onlyOwner {
544         buyMarketingFee = _buyMarketingFee;
545     }
546 
547     function setMarketWallet(address _marketWallet) external onlyOwner {
548         marketWallet = _marketWallet;
549     }
550 
551     function setSellMarketingFee(uint256 _sellMarketingFee) external onlyOwner {
552         sellMarketingFee = _sellMarketingFee;
553     }
554 
555     function setBlcList(address account, bool flag) external onlyOwner {
556         isBlclist[account] = flag;
557     }
558 
559     function setMultipleBlclist(address[] calldata accounts, bool flag) public onlyOwner {
560         for(uint256 i = 0; i < accounts.length; i++) {
561             isBlclist[accounts[i]] = flag;
562         }
563     }
564 
565     function setNumTokensSellToSwap(uint256 value) external onlyOwner {
566         numTokensSellToSwap = value;
567     }
568 
569     function _transfer(
570         address from,
571         address to,
572         uint256 amount
573     ) internal override {
574         require(from != address(0), "ERC20: transfer from the zero address");
575         require(amount > 0, "ERC20: wrong amount");
576         require(!isBlclist[from], "ERC20: blclist account");
577         require(enableTrade, "ERC20: not time");
578 
579         uint256 contractTokenBalance = balanceOf(address(this));
580         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToSwap;
581         if( overMinTokenBalance &&
582             !swapping &&
583             !isPair[from]
584         ) {
585             swapAndDividend(numTokensSellToSwap);
586         } 
587 
588         bool takeFee = !swapping;
589 
590         // if any account belongs to _isExcludedFromFee account then remove the fee
591         if(isExcludedFromFees[from] || isExcludedFromFees[to]) {
592             takeFee = false;
593         }
594 
595         //transfer amount, it will take tax, burn, liquidity fee
596         _tokenTransfer(from,to,amount,takeFee); 
597     }
598 
599     //this method is responsible for taking all fee, if takeFee is true
600     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
601         if(takeFee) {
602             uint256 totalFee;
603             if(isPair[sender]) { //buy
604                 totalFee = buyMarketingFee;
605             } else if (isPair[recipient]) {
606                 totalFee = sellMarketingFee;
607             } 
608 
609             if(totalFee > 0) {
610                 uint256 feeAmount = amount * totalFee / 100;
611                 super._transfer(sender, address(this), feeAmount);
612                 amount -= feeAmount;
613             }
614         }
615         super._transfer(sender, recipient, amount);
616     }
617 
618     function swapAndDividend(uint256 tokenAmount) private lockTheSwap {
619 
620         // generate the uniswap pair path of token -> weth
621         address[] memory path = new address[](2);
622         path[0] = address(this);
623         path[1] = uniswapV2Router.WETH();
624 
625         // make the swap
626         uniswapV2Router.swapExactTokensForETH(
627             tokenAmount,
628             0, // accept any amount of USDT
629             path,
630             marketWallet,
631             block.timestamp
632         );
633     }
634 }
635 
636 interface IUniswapV2Factory {
637     function createPair(address tokenA, address tokenB) external returns (address pair);
638 }
639 
640 interface IUniswapV2Router02  {
641     function factory() external pure returns (address);
642     function WETH() external pure returns (address);
643     function swapExactTokensForETH(
644         uint amountIn,
645         uint amountOutMin,
646         address[] calldata path,
647         address to,
648         uint deadline
649     ) external;
650 }
651 
652 library SafeMath {
653     /**
654      * @dev Returns the addition of two unsigned integers, reverting on
655      * overflow.
656      *
657      * Counterpart to Solidity's `+` operator.
658      *
659      * Requirements:
660      *
661      * - Addition cannot overflow.
662      */
663     function add(uint256 a, uint256 b) internal pure returns (uint256) {
664         uint256 c = a + b;
665         require(c >= a, "SafeMath: addition overflow");
666 
667         return c;
668     }
669 
670     /**
671      * @dev Returns the subtraction of two unsigned integers, reverting on
672      * overflow (when the result is negative).
673      *
674      * Counterpart to Solidity's `-` operator.
675      *
676      * Requirements:
677      *
678      * - Subtraction cannot overflow.
679      */
680     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
681         return sub(a, b, "SafeMath: subtraction overflow");
682     }
683 
684     /**
685      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
686      * overflow (when the result is negative).
687      *
688      * Counterpart to Solidity's `-` operator.
689      *
690      * Requirements:
691      *
692      * - Subtraction cannot overflow.
693      */
694     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
695         require(b <= a, errorMessage);
696         uint256 c = a - b;
697 
698         return c;
699     }
700 
701     /**
702      * @dev Returns the multiplication of two unsigned integers, reverting on
703      * overflow.
704      *
705      * Counterpart to Solidity's `*` operator.
706      *
707      * Requirements:
708      *
709      * - Multiplication cannot overflow.
710      */
711     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
712         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
713         // benefit is lost if 'b' is also tested.
714         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
715         if (a == 0) {
716             return 0;
717         }
718 
719         uint256 c = a * b;
720         require(c / a == b, "SafeMath: multiplication overflow");
721 
722         return c;
723     }
724 
725     /**
726      * @dev Returns the integer division of two unsigned integers. Reverts on
727      * division by zero. The result is rounded towards zero.
728      *
729      * Counterpart to Solidity's `/` operator. Note: this function uses a
730      * `revert` opcode (which leaves remaining gas untouched) while Solidity
731      * uses an invalid opcode to revert (consuming all remaining gas).
732      *
733      * Requirements:
734      *
735      * - The divisor cannot be zero.
736      */
737     function div(uint256 a, uint256 b) internal pure returns (uint256) {
738         return div(a, b, "SafeMath: division by zero");
739     }
740 
741     /**
742      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
743      * division by zero. The result is rounded towards zero.
744      *
745      * Counterpart to Solidity's `/` operator. Note: this function uses a
746      * `revert` opcode (which leaves remaining gas untouched) while Solidity
747      * uses an invalid opcode to revert (consuming all remaining gas).
748      *
749      * Requirements:
750      *
751      * - The divisor cannot be zero.
752      */
753     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
754         require(b > 0, errorMessage);
755         uint256 c = a / b;
756         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
757 
758         return c;
759     }
760 
761     /**
762      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
763      * Reverts when dividing by zero.
764      *
765      * Counterpart to Solidity's `%` operator. This function uses a `revert`
766      * opcode (which leaves remaining gas untouched) while Solidity uses an
767      * invalid opcode to revert (consuming all remaining gas).
768      *
769      * Requirements:
770      *
771      * - The divisor cannot be zero.
772      */
773     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
774         return mod(a, b, "SafeMath: modulo by zero");
775     }
776 
777     /**
778      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
779      * Reverts with custom message when dividing by zero.
780      *
781      * Counterpart to Solidity's `%` operator. This function uses a `revert`
782      * opcode (which leaves remaining gas untouched) while Solidity uses an
783      * invalid opcode to revert (consuming all remaining gas).
784      *
785      * Requirements:
786      *
787      * - The divisor cannot be zero.
788      */
789     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
790         require(b != 0, errorMessage);
791         return a % b;
792     }
793 }