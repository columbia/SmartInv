1 pragma solidity ^0.6.12;
2 library SafeMath {
3     function add(uint256 a, uint256 b) internal pure returns (uint256) {
4         uint256 c = a + b;
5         require(c >= a, "SafeMath: addition overflow");
6 
7         return c;
8     }
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10         return sub(a, b, "SafeMath: subtraction overflow");
11     }
12     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
13         require(b <= a, errorMessage);
14         uint256 c = a - b;
15 
16         return c;
17     }
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         require(c / a == b, "SafeMath: multiplication overflow");
24         return c;
25     }
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         return div(a, b, "SafeMath: division by zero");
28     }
29     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b > 0, errorMessage);
31         uint256 c = a / b;
32         return c;
33     }
34     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
35         return mod(a, b, "SafeMath: modulo by zero");
36     }
37     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b != 0, errorMessage);
39         return a % b;
40     }
41 }
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address) {
44         return msg.sender;
45     }
46 }
47 contract Ownable is Context {
48     address private _owner;
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50     constructor () public {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55     function owner() public view returns (address) {
56         return _owner;
57     }
58     modifier onlyOwner() {
59         require(_owner == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 }
72 
73 interface IUniswapV2Pair {
74     event Approval(address indexed owner, address indexed spender, uint value);
75     event Transfer(address indexed from, address indexed to, uint value);
76 
77     function name() external pure returns (string memory);
78     function symbol() external pure returns (string memory);
79     function decimals() external pure returns (uint8);
80     function totalSupply() external view returns (uint);
81     function balanceOf(address owner) external view returns (uint);
82     function allowance(address owner, address spender) external view returns (uint);
83 
84     function approve(address spender, uint value) external returns (bool);
85     function transfer(address to, uint value) external returns (bool);
86     function transferFrom(address from, address to, uint value) external returns (bool);
87 
88     function DOMAIN_SEPARATOR() external view returns (bytes32);
89     function PERMIT_TYPEHASH() external pure returns (bytes32);
90     function nonces(address owner) external view returns (uint);
91 
92     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
93 
94     event Mint(address indexed sender, uint amount0, uint amount1);
95     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
96     event Swap(
97         address indexed sender,
98         uint amount0In,
99         uint amount1In,
100         uint amount0Out,
101         uint amount1Out,
102         address indexed to
103     );
104     event Sync(uint112 reserve0, uint112 reserve1);
105 
106     function MINIMUM_LIQUIDITY() external pure returns (uint);
107     function factory() external view returns (address);
108     function token0() external view returns (address);
109     function token1() external view returns (address);
110     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
111     function price0CumulativeLast() external view returns (uint);
112     function price1CumulativeLast() external view returns (uint);
113     function kLast() external view returns (uint);
114 
115     function mint(address to) external returns (uint liquidity);
116     function burn(address to) external returns (uint amount0, uint amount1);
117     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
118     function skim(address to) external;
119     function sync() external;
120 
121     function initialize(address, address) external;
122 }
123 
124 interface IUniswapV2Factory {
125     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
126 
127     function feeTo() external view returns (address);
128     function feeToSetter() external view returns (address);
129 
130     function getPair(address tokenA, address tokenB) external view returns (address pair);
131     function allPairs(uint) external view returns (address pair);
132     function allPairsLength() external view returns (uint);
133 
134     function createPair(address tokenA, address tokenB) external returns (address pair);
135 
136     function setFeeTo(address) external;
137     function setFeeToSetter(address) external;
138 }
139 
140 interface IUniswapV2Router01 {
141     function factory() external pure returns (address);
142     function WETH() external pure returns (address);
143 
144     function addLiquidity(
145         address tokenA,
146         address tokenB,
147         uint amountADesired,
148         uint amountBDesired,
149         uint amountAMin,
150         uint amountBMin,
151         address to,
152         uint deadline
153     ) external returns (uint amountA, uint amountB, uint liquidity);
154     function addLiquidityETH(
155         address token,
156         uint amountTokenDesired,
157         uint amountTokenMin,
158         uint amountETHMin,
159         address to,
160         uint deadline
161     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
162     function removeLiquidity(
163         address tokenA,
164         address tokenB,
165         uint liquidity,
166         uint amountAMin,
167         uint amountBMin,
168         address to,
169         uint deadline
170     ) external returns (uint amountA, uint amountB);
171     function removeLiquidityETH(
172         address token,
173         uint liquidity,
174         uint amountTokenMin,
175         uint amountETHMin,
176         address to,
177         uint deadline
178     ) external returns (uint amountToken, uint amountETH);
179     function removeLiquidityWithPermit(
180         address tokenA,
181         address tokenB,
182         uint liquidity,
183         uint amountAMin,
184         uint amountBMin,
185         address to,
186         uint deadline,
187         bool approveMax, uint8 v, bytes32 r, bytes32 s
188     ) external returns (uint amountA, uint amountB);
189     function removeLiquidityETHWithPermit(
190         address token,
191         uint liquidity,
192         uint amountTokenMin,
193         uint amountETHMin,
194         address to,
195         uint deadline,
196         bool approveMax, uint8 v, bytes32 r, bytes32 s
197     ) external returns (uint amountToken, uint amountETH);
198     function swapExactTokensForTokens(
199         uint amountIn,
200         uint amountOutMin,
201         address[] calldata path,
202         address to,
203         uint deadline
204     ) external returns (uint[] memory amounts);
205     function swapTokensForExactTokens(
206         uint amountOut,
207         uint amountInMax,
208         address[] calldata path,
209         address to,
210         uint deadline
211     ) external returns (uint[] memory amounts);
212     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
213         external
214         payable
215         returns (uint[] memory amounts);
216     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
217         external
218         returns (uint[] memory amounts);
219     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
220         external
221         returns (uint[] memory amounts);
222     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
223         external
224         payable
225         returns (uint[] memory amounts);
226 
227     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
228     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
229     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
230     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
231     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
232 }
233 
234 interface IUniswapV2Router02 is IUniswapV2Router01 {
235     function removeLiquidityETHSupportingFeeOnTransferTokens(
236         address token,
237         uint liquidity,
238         uint amountTokenMin,
239         uint amountETHMin,
240         address to,
241         uint deadline
242     ) external returns (uint amountETH);
243     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
244         address token,
245         uint liquidity,
246         uint amountTokenMin,
247         uint amountETHMin,
248         address to,
249         uint deadline,
250         bool approveMax, uint8 v, bytes32 r, bytes32 s
251     ) external returns (uint amountETH);
252 
253     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
254         uint amountIn,
255         uint amountOutMin,
256         address[] calldata path,
257         address to,
258         uint deadline
259     ) external;
260     function swapExactETHForTokensSupportingFeeOnTransferTokens(
261         uint amountOutMin,
262         address[] calldata path,
263         address to,
264         uint deadline
265     ) external payable;
266     function swapExactTokensForETHSupportingFeeOnTransferTokens(
267         uint amountIn,
268         uint amountOutMin,
269         address[] calldata path,
270         address to,
271         uint deadline
272     ) external;
273 }
274 
275 interface IERC20 {
276     /**
277      * @dev Returns the amount of tokens in existence.
278      */
279     function totalSupply() external view returns (uint256);
280 
281     /**
282      * @dev Returns the amount of tokens owned by `account`.
283      */
284     function balanceOf(address account) external view returns (uint256);
285 
286     /**
287      * @dev Moves `amount` tokens from the caller's account to `recipient`.
288      *
289      * Returns a boolean value indicating whether the operation succeeded.
290      *
291      * Emits a {Transfer} event.
292      */
293     function transfer(address recipient, uint256 amount) external returns (bool);
294 
295     /**
296      * @dev Returns the remaining number of tokens that `spender` will be
297      * allowed to spend on behalf of `owner` through {transferFrom}. This is
298      * zero by default.
299      *
300      * This value changes when {approve} or {transferFrom} are called.
301      */
302     function allowance(address owner, address spender) external view returns (uint256);
303 
304     /**
305      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
306      *
307      * Returns a boolean value indicating whether the operation succeeded.
308      *
309      * IMPORTANT: Beware that changing an allowance with this method brings the risk
310      * that someone may use both the old and the new allowance by unfortunate
311      * transaction ordering. One possible solution to mitigate this race
312      * condition is to first reduce the spender's allowance to 0 and set the
313      * desired value afterwards:
314      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
315      *
316      * Emits an {Approval} event.
317      */
318     function approve(address spender, uint256 amount) external returns (bool);
319 
320     /**
321      * @dev Moves `amount` tokens from `sender` to `recipient` using the
322      * allowance mechanism. `amount` is then deducted from the caller's
323      * allowance.
324      *
325      * Returns a boolean value indicating whether the operation succeeded.
326      *
327      * Emits a {Transfer} event.
328      */
329     function transferFrom(
330         address sender,
331         address recipient,
332         uint256 amount
333     ) external returns (bool);
334 
335     /**
336      * @dev Emitted when `value` tokens are moved from one account (`from`) to
337      * another (`to`).
338      *
339      * Note that `value` may be zero.
340      */
341     event Transfer(address indexed from, address indexed to, uint256 value);
342 
343     /**
344      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
345      * a call to {approve}. `value` is the new allowance.
346      */
347     event Approval(address indexed owner, address indexed spender, uint256 value);
348 }
349 
350 interface IERC20Metadata is IERC20 {
351     /**
352      * @dev Returns the name of the token.
353      */
354     function name() external view returns (string memory);
355 
356     /**
357      * @dev Returns the symbol of the token.
358      */
359     function symbol() external view returns (string memory);
360 
361     /**
362      * @dev Returns the decimals places of the token.
363      */
364     function decimals() external view returns (uint8);
365 }
366 
367 contract ERC20 is Context, IERC20, IERC20Metadata {
368     using SafeMath for uint256;
369 
370     mapping(address => uint256) private _balances;
371 
372     mapping(address => mapping(address => uint256)) private _allowances;
373 
374     uint256 private _totalSupply;
375 
376     string private _name;
377     string private _symbol;
378 
379     /**
380      * @dev Sets the values for {name} and {symbol}.
381      *
382      * The default value of {decimals} is 18. To select a different value for
383      * {decimals} you should overload it.
384      *
385      * All two of these values are immutable: they can only be set once during
386      * construction.
387      */
388     constructor(string memory name_, string memory symbol_) public {
389         _name = name_;
390         _symbol = symbol_;
391     }
392 
393     /**
394      * @dev Returns the name of the token.
395      */
396     function name() public view virtual override returns (string memory) {
397         return _name;
398     }
399 
400     /**
401      * @dev Returns the symbol of the token, usually a shorter version of the
402      * name.
403      */
404     function symbol() public view virtual override returns (string memory) {
405         return _symbol;
406     }
407 
408     /**
409      * @dev Returns the number of decimals used to get its user representation.
410      * For example, if `decimals` equals `2`, a balance of `505` tokens should
411      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
412      *
413      * Tokens usually opt for a value of 18, imitating the relationship between
414      * Ether and Wei. This is the value {ERC20} uses, unless this function is
415      * overridden;
416      *
417      * NOTE: This information is only used for _display_ purposes: it in
418      * no way affects any of the arithmetic of the contract, including
419      * {IERC20-balanceOf} and {IERC20-transfer}.
420      */
421     function decimals() public view virtual override returns (uint8) {
422         return 18;
423     }
424 
425     /**
426      * @dev See {IERC20-totalSupply}.
427      */
428     function totalSupply() public view virtual override returns (uint256) {
429         return _totalSupply;
430     }
431 
432     /**
433      * @dev See {IERC20-balanceOf}.
434      */
435     function balanceOf(address account) public view virtual override returns (uint256) {
436         return _balances[account];
437     }
438 
439     /**
440      * @dev See {IERC20-transfer}.
441      *
442      * Requirements:
443      *
444      * - `recipient` cannot be the zero address.
445      * - the caller must have a balance of at least `amount`.
446      */
447     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
448         _transfer(_msgSender(), recipient, amount);
449         return true;
450     }
451 
452     /**
453      * @dev See {IERC20-allowance}.
454      */
455     function allowance(address owner, address spender) public view virtual override returns (uint256) {
456         return _allowances[owner][spender];
457     }
458 
459     /**
460      * @dev See {IERC20-approve}.
461      *
462      * Requirements:
463      *
464      * - `spender` cannot be the zero address.
465      */
466     function approve(address spender, uint256 amount) public virtual override returns (bool) {
467         _approve(_msgSender(), spender, amount);
468         return true;
469     }
470 
471     /**
472      * @dev See {IERC20-transferFrom}.
473      *
474      * Emits an {Approval} event indicating the updated allowance. This is not
475      * required by the EIP. See the note at the beginning of {ERC20}.
476      *
477      * Requirements:
478      *
479      * - `sender` and `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      * - the caller must have allowance for ``sender``'s tokens of at least
482      * `amount`.
483      */
484     function transferFrom(
485         address sender,
486         address recipient,
487         uint256 amount
488     ) public virtual override returns (bool) {
489         _transfer(sender, recipient, amount);
490         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
491         return true;
492     }
493 
494     /**
495      * @dev Atomically increases the allowance granted to `spender` by the caller.
496      *
497      * This is an alternative to {approve} that can be used as a mitigation for
498      * problems described in {IERC20-approve}.
499      *
500      * Emits an {Approval} event indicating the updated allowance.
501      *
502      * Requirements:
503      *
504      * - `spender` cannot be the zero address.
505      */
506     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
507         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
508         return true;
509     }
510 
511     /**
512      * @dev Atomically decreases the allowance granted to `spender` by the caller.
513      *
514      * This is an alternative to {approve} that can be used as a mitigation for
515      * problems described in {IERC20-approve}.
516      *
517      * Emits an {Approval} event indicating the updated allowance.
518      *
519      * Requirements:
520      *
521      * - `spender` cannot be the zero address.
522      * - `spender` must have allowance for the caller of at least
523      * `subtractedValue`.
524      */
525     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
526         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
527         return true;
528     }
529 
530     /**
531      * @dev Moves tokens `amount` from `sender` to `recipient`.
532      *
533      * This is internal function is equivalent to {transfer}, and can be used to
534      * e.g. implement automatic token fees, slashing mechanisms, etc.
535      *
536      * Emits a {Transfer} event.
537      *
538      * Requirements:
539      *
540      * - `sender` cannot be the zero address.
541      * - `recipient` cannot be the zero address.
542      * - `sender` must have a balance of at least `amount`.
543      */
544     function _transfer(
545         address sender,
546         address recipient,
547         uint256 amount
548     ) internal virtual {
549         require(sender != address(0), "ERC20: transfer from the zero address");
550         require(recipient != address(0), "ERC20: transfer to the zero address");
551 
552         _beforeTokenTransfer(sender, recipient, amount);
553 
554         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
555         _balances[recipient] = _balances[recipient].add(amount);
556         emit Transfer(sender, recipient, amount);
557     }
558 
559     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
560      * the total supply.
561      *
562      * Emits a {Transfer} event with `from` set to the zero address.
563      *
564      * Requirements:
565      *
566      * - `account` cannot be the zero address.
567      */
568     function _mint(address account, uint256 amount) internal virtual {
569         require(account != address(0), "ERC20: mint to the zero address");
570 
571         _beforeTokenTransfer(address(0), account, amount);
572 
573         _totalSupply = _totalSupply.add(amount);
574         _balances[account] = _balances[account].add(amount);
575         emit Transfer(address(0), account, amount);
576     }
577 
578     /**
579      * @dev Destroys `amount` tokens from `account`, reducing the
580      * total supply.
581      *
582      * Emits a {Transfer} event with `to` set to the zero address.
583      *
584      * Requirements:
585      *
586      * - `account` cannot be the zero address.
587      * - `account` must have at least `amount` tokens.
588      */
589     function _burn(address account, uint256 amount) internal virtual {
590         require(account != address(0), "ERC20: burn from the zero address");
591 
592         _beforeTokenTransfer(account, address(0), amount);
593 
594         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
595         _totalSupply = _totalSupply.sub(amount);
596         emit Transfer(account, address(0), amount);
597     }
598 
599     /**
600      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
601      *
602      * This internal function is equivalent to `approve`, and can be used to
603      * e.g. set automatic allowances for certain subsystems, etc.
604      *
605      * Emits an {Approval} event.
606      *
607      * Requirements:
608      *
609      * - `owner` cannot be the zero address.
610      * - `spender` cannot be the zero address.
611      */
612     function _approve(
613         address owner,
614         address spender,
615         uint256 amount
616     ) internal virtual {
617         require(owner != address(0), "ERC20: approve from the zero address");
618         require(spender != address(0), "ERC20: approve to the zero address");
619 
620         _allowances[owner][spender] = amount;
621         emit Approval(owner, spender, amount);
622     }
623 
624     /**
625      * @dev Hook that is called before any transfer of tokens. This includes
626      * minting and burning.
627      *
628      * Calling conditions:
629      *
630      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
631      * will be to transferred to `to`.
632      * - when `from` is zero, `amount` tokens will be minted for `to`.
633      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
634      * - `from` and `to` are never both zero.
635      *
636      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
637      */
638     function _beforeTokenTransfer(
639         address from,
640         address to,
641         uint256 amount
642     ) internal virtual {}
643 }
644 
645 contract ElectricArena is ERC20, Ownable {
646     using SafeMath for uint256;
647 
648     IUniswapV2Router02 public uniswapV2Router;
649     address public immutable uniswapV2Pair;
650 
651     bool private swapping;
652 
653     uint256 public swapTokensAtAmount = 10**10 * (10**18);
654 
655     mapping (address => bool) private _isExcluded;
656 
657     constructor() public ERC20("ElectricArena", "eArena") {    	
658     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
659         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
660             .createPair(address(this), _uniswapV2Router.WETH());
661 
662         uniswapV2Router = _uniswapV2Router;
663         uniswapV2Pair = _uniswapV2Pair;
664 
665         _isExcluded[owner()] = true;
666         _isExcluded[address(this)] = true;
667         
668         _mint(owner(),  115 * 10**13 * (10**18));
669     }
670 
671     receive() external payable {
672 
673   	}   
674 
675     function _transfer(
676         address from,
677         address to,
678         uint256 amount
679     ) internal override {
680         require(from != address(0));
681         require(to != address(0));
682 
683         if(amount == 0) {
684             super._transfer(from, to, 0);
685             return;
686         }
687 
688 		uint256 contractTokenBalance = balanceOf(address(this));
689         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
690 
691         if(
692             canSwap &&
693             !swapping &&
694             from != uniswapV2Pair &&
695             from != owner() &&
696             to != owner()
697         ) {
698          
699             swapping = true;
700 
701             uint256 sellTokens = balanceOf(address(this));
702             swapAndSendDividends(sellTokens);
703 
704             swapping = false;
705         }
706 
707         bool takeFee = !swapping;
708 
709         if(_isExcluded[from] || _isExcluded[to]) {
710             takeFee = false;
711         }
712 
713         if(takeFee && (to == uniswapV2Pair || from == uniswapV2Pair)) {
714           uint256 fees = amount.mul(5).div(100);
715         	amount = amount.sub(fees);
716           super._transfer(from, address(this), fees);
717         }
718 
719         super._transfer(from, to, amount);
720 
721     }
722     
723     function swapTokensForEth(uint256 tokenAmount) private {
724         address[] memory path = new address[](2);
725         path[0] = address(this);
726         path[1] = uniswapV2Router.WETH();
727         _approve(address(this), address(uniswapV2Router), tokenAmount);
728         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
729             tokenAmount,
730             0,
731             path,
732             address(this),
733             block.timestamp
734         );
735         
736     }
737 
738     function swapAndSendDividends(uint256 tokens) private {
739         swapTokensForEth(tokens);
740         payable(owner()).transfer(address(this).balance);
741     }
742     
743     function airdrop(address[] memory _user, uint256[] memory _amount) external onlyOwner {
744         uint256 len = _user.length;
745         require(len == _amount.length);
746         for (uint256 i = 0; i < len; i++) {
747             super._transfer(_msgSender(), _user[i], _amount[i]);
748         }
749     }
750     
751     function setSwapAtAmount(uint256 amount) external onlyOwner {
752         swapTokensAtAmount = amount;
753     }
754 
755 }