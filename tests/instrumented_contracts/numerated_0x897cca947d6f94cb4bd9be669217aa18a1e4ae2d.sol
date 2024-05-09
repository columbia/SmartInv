1 /**
2 
3 It’s that time of the year again.
4 In anticipation of a bull December, the tale of the #moonvember starts!
5 
6 Some say they witnessed it, some say it is just a legend, yet some believe this will be the year when the tale turns out to be true.
7 
8 Are you ready?
9 
10 0/0 tax
11 
12 https://twitter.com/moonvembereth
13 https://t.me/moonvembertoken
14 
15 */
16 
17 // SPDX-License-Identifier: MIT
18 pragma solidity 0.8.17;
19  
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24  
25     function _msgData() internal view virtual returns (bytes calldata) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30  
31 interface IUniswapV2Pair {
32     event Approval(address indexed owner, address indexed spender, uint value);
33     event Transfer(address indexed from, address indexed to, uint value);
34  
35     function name() external pure returns (string memory);
36     function symbol() external pure returns (string memory);
37     function decimals() external pure returns (uint8);
38     function totalSupply() external view returns (uint);
39     function balanceOf(address owner) external view returns (uint);
40     function allowance(address owner, address spender) external view returns (uint);
41  
42     function approve(address spender, uint value) external returns (bool);
43     function transfer(address to, uint value) external returns (bool);
44     function transferFrom(address from, address to, uint value) external returns (bool);
45  
46     function DOMAIN_SEPARATOR() external view returns (bytes32);
47     function PERMIT_TYPEHASH() external pure returns (bytes32);
48     function nonces(address owner) external view returns (uint);
49  
50     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
51  
52     event Mint(address indexed sender, uint amount0, uint amount1);
53     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
54     event Swap(
55         address indexed sender,
56         uint amount0In,
57         uint amount1In,
58         uint amount0Out,
59         uint amount1Out,
60         address indexed to
61     );
62     event Sync(uint112 reserve0, uint112 reserve1);
63  
64     function MINIMUM_LIQUIDITY() external pure returns (uint);
65     function factory() external view returns (address);
66     function token0() external view returns (address);
67     function token1() external view returns (address);
68     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
69     function price0CumulativeLast() external view returns (uint);
70     function price1CumulativeLast() external view returns (uint);
71     function kLast() external view returns (uint);
72  
73     function mint(address to) external returns (uint liquidity);
74     function burn(address to) external returns (uint amount0, uint amount1);
75     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
76     function skim(address to) external;
77     function sync() external;
78  
79     function initialize(address, address) external;
80 }
81  
82 interface IUniswapV2Factory {
83     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
84  
85     function feeTo() external view returns (address);
86     function feeToSetter() external view returns (address);
87  
88     function getPair(address tokenA, address tokenB) external view returns (address pair);
89     function allPairs(uint) external view returns (address pair);
90     function allPairsLength() external view returns (uint);
91  
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93  
94     function setFeeTo(address) external;
95     function setFeeToSetter(address) external;
96 }
97  
98 interface IERC20 {
99     /**
100      * @dev Returns the amount of tokens in existence.
101      */
102     function totalSupply() external view returns (uint256);
103  
104     /**
105      * @dev Returns the amount of tokens owned by `account`.
106      */
107     function balanceOf(address account) external view returns (uint256);
108  
109     /**
110      * @dev Moves `amount` tokens from the caller's account to `recipient`.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transfer(address recipient, uint256 amount) external returns (bool);
117  
118     /**
119      * @dev Returns the remaining number of tokens that `spender` will be
120      * allowed to spend on behalf of `owner` through {transferFrom}. This is
121      * zero by default.
122      *
123      * This value changes when {approve} or {transferFrom} are called.
124      */
125     function allowance(address owner, address spender) external view returns (uint256);
126  
127     /**
128      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * IMPORTANT: Beware that changing an allowance with this method brings the risk
133      * that someone may use both the old and the new allowance by unfortunate
134      * transaction ordering. One possible solution to mitigate this race
135      * condition is to first reduce the spender's allowance to 0 and set the
136      * desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address spender, uint256 amount) external returns (bool);
142  
143     /**
144      * @dev Moves `amount` tokens from `sender` to `recipient` using the
145      * allowance mechanism. `amount` is then deducted from the caller's
146      * allowance.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transferFrom(
153         address sender,
154         address recipient,
155         uint256 amount
156     ) external returns (bool);
157  
158     /**
159      * @dev Emitted when `value` tokens are moved from one account (`from`) to
160      * another (`to`).
161      *
162      * Note that `value` may be zero.
163      */
164     event Transfer(address indexed from, address indexed to, uint256 value);
165  
166     /**
167      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
168      * a call to {approve}. `value` is the new allowance.
169      */
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172  
173 interface IERC20Metadata is IERC20 {
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() external view returns (string memory);
178  
179     /**
180      * @dev Returns the symbol of the token.
181      */
182     function symbol() external view returns (string memory);
183  
184     /**
185      * @dev Returns the decimals places of the token.
186      */
187     function decimals() external view returns (uint8);
188 }
189  
190  
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
212     constructor(string memory name_, string memory symbol_) {
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
469 library SafeMath {
470     function add(uint256 a, uint256 b) internal pure returns (uint256) {
471         uint256 c = a + b;
472         require(c >= a, "SafeMath: addition overflow");
473  
474         return c;
475     }
476 
477     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
478         return sub(a, b, "SafeMath: subtraction overflow");
479     }
480 
481     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
482         require(b <= a, errorMessage);
483         uint256 c = a - b;
484  
485         return c;
486     }
487 
488     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
489         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
490         // benefit is lost if 'b' is also tested.
491         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
492         if (a == 0) {
493             return 0;
494         }
495  
496         uint256 c = a * b;
497         require(c / a == b, "SafeMath: multiplication overflow");
498  
499         return c;
500     }
501 
502     function div(uint256 a, uint256 b) internal pure returns (uint256) {
503         return div(a, b, "SafeMath: division by zero");
504     }
505 
506     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
507         require(b > 0, errorMessage);
508         uint256 c = a / b;
509 
510         return c;
511     }
512 
513     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
514         return mod(a, b, "SafeMath: modulo by zero");
515     }
516 
517     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
518         require(b != 0, errorMessage);
519         return a % b;
520     }
521 }
522  
523 contract Ownable is Context {
524     address private _owner;
525  
526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
527  
528     constructor () {
529         address msgSender = _msgSender();
530         _owner = msgSender;
531         emit OwnershipTransferred(address(0), msgSender);
532     }
533 
534     function owner() public view returns (address) {
535         return _owner;
536     }
537  
538     modifier onlyOwner() {
539         require(_owner == _msgSender(), "Ownable: caller is not the owner");
540         _;
541     }
542  
543     function renounceOwnership() public virtual onlyOwner {
544         emit OwnershipTransferred(_owner, address(0));
545         _owner = address(0);
546     }
547 
548     function transferOwnership(address newOwner) public virtual onlyOwner {
549         require(newOwner != address(0), "Ownable: new owner is the zero address");
550         emit OwnershipTransferred(_owner, newOwner);
551         _owner = newOwner;
552     }
553 }
554  
555  
556 
557 library SafeMathInt {
558     int256 private constant MIN_INT256 = int256(1) << 255;
559     int256 private constant MAX_INT256 = ~(int256(1) << 255);
560  
561     function mul(int256 a, int256 b) internal pure returns (int256) {
562         int256 c = a * b;
563  
564         // Detect overflow when multiplying MIN_INT256 with -1
565         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
566         require((b == 0) || (c / b == a));
567         return c;
568     }
569  
570     function div(int256 a, int256 b) internal pure returns (int256) {
571         // Prevent overflow when dividing MIN_INT256 by -1
572         require(b != -1 || a != MIN_INT256);
573  
574         // Solidity already throws when dividing by 0.
575         return a / b;
576     }
577  
578     function sub(int256 a, int256 b) internal pure returns (int256) {
579         int256 c = a - b;
580         require((b >= 0 && c <= a) || (b < 0 && c > a));
581         return c;
582     }
583  
584     function add(int256 a, int256 b) internal pure returns (int256) {
585         int256 c = a + b;
586         require((b >= 0 && c >= a) || (b < 0 && c < a));
587         return c;
588     }
589  
590     function abs(int256 a) internal pure returns (int256) {
591         require(a != MIN_INT256);
592         return a < 0 ? -a : a;
593     }
594  
595  
596     function toUint256Safe(int256 a) internal pure returns (uint256) {
597         require(a >= 0);
598         return uint256(a);
599     }
600 }
601  
602 library SafeMathUint {
603   function toInt256Safe(uint256 a) internal pure returns (int256) {
604     int256 b = int256(a);
605     require(b >= 0);
606     return b;
607   }
608 }
609  
610  
611 interface IUniswapV2Router01 {
612     function factory() external pure returns (address);
613     function WETH() external pure returns (address);
614  
615     function addLiquidity(
616         address tokenA,
617         address tokenB,
618         uint amountADesired,
619         uint amountBDesired,
620         uint amountAMin,
621         uint amountBMin,
622         address to,
623         uint deadline
624     ) external returns (uint amountA, uint amountB, uint liquidity);
625     function addLiquidityETH(
626         address token,
627         uint amountTokenDesired,
628         uint amountTokenMin,
629         uint amountETHMin,
630         address to,
631         uint deadline
632     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
633     function removeLiquidity(
634         address tokenA,
635         address tokenB,
636         uint liquidity,
637         uint amountAMin,
638         uint amountBMin,
639         address to,
640         uint deadline
641     ) external returns (uint amountA, uint amountB);
642     function removeLiquidityETH(
643         address token,
644         uint liquidity,
645         uint amountTokenMin,
646         uint amountETHMin,
647         address to,
648         uint deadline
649     ) external returns (uint amountToken, uint amountETH);
650     function removeLiquidityWithPermit(
651         address tokenA,
652         address tokenB,
653         uint liquidity,
654         uint amountAMin,
655         uint amountBMin,
656         address to,
657         uint deadline,
658         bool approveMax, uint8 v, bytes32 r, bytes32 s
659     ) external returns (uint amountA, uint amountB);
660     function removeLiquidityETHWithPermit(
661         address token,
662         uint liquidity,
663         uint amountTokenMin,
664         uint amountETHMin,
665         address to,
666         uint deadline,
667         bool approveMax, uint8 v, bytes32 r, bytes32 s
668     ) external returns (uint amountToken, uint amountETH);
669     function swapExactTokensForTokens(
670         uint amountIn,
671         uint amountOutMin,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external returns (uint[] memory amounts);
676     function swapTokensForExactTokens(
677         uint amountOut,
678         uint amountInMax,
679         address[] calldata path,
680         address to,
681         uint deadline
682     ) external returns (uint[] memory amounts);
683     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
684         external
685         payable
686         returns (uint[] memory amounts);
687     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
688         external
689         returns (uint[] memory amounts);
690     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
691         external
692         returns (uint[] memory amounts);
693     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
694         external
695         payable
696         returns (uint[] memory amounts);
697  
698     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
699     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
700     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
701     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
702     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
703 }
704  
705 interface IUniswapV2Router02 is IUniswapV2Router01 {
706     function removeLiquidityETHSupportingFeeOnTransferTokens(
707         address token,
708         uint liquidity,
709         uint amountTokenMin,
710         uint amountETHMin,
711         address to,
712         uint deadline
713     ) external returns (uint amountETH);
714     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
715         address token,
716         uint liquidity,
717         uint amountTokenMin,
718         uint amountETHMin,
719         address to,
720         uint deadline,
721         bool approveMax, uint8 v, bytes32 r, bytes32 s
722     ) external returns (uint amountETH);
723  
724     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
725         uint amountIn,
726         uint amountOutMin,
727         address[] calldata path,
728         address to,
729         uint deadline
730     ) external;
731     function swapExactETHForTokensSupportingFeeOnTransferTokens(
732         uint amountOutMin,
733         address[] calldata path,
734         address to,
735         uint deadline
736     ) external payable;
737     function swapExactTokensForETHSupportingFeeOnTransferTokens(
738         uint amountIn,
739         uint amountOutMin,
740         address[] calldata path,
741         address to,
742         uint deadline
743     ) external;
744 }
745  
746 contract Moonvember is ERC20, Ownable {
747     using SafeMath for uint256;
748  
749     IUniswapV2Router02 public immutable uniswapV2Router;
750     address public immutable uniswapV2Pair;
751     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
752  
753     bool private swapping;
754  
755     address public marketingWallet;
756     address public devWallet;
757  
758     uint256 public maxTransactionAmount;
759     uint256 public swapTokensAtAmount;
760     uint256 public maxWallet;
761  
762     bool public limitsInEffect = true;
763     bool public tradingActive = false;
764     bool public swapEnabled = false;
765  
766      // Anti-bot and anti-whale mappings and variables
767     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
768  
769     // Seller Map
770     mapping (address => uint256) private _holderFirstBuyTimestamp;
771  
772     bool public transferDelayEnabled = true;
773  
774     uint256 public buyTotalFees;
775     uint256 public buyMarketingFee;
776     uint256 public buyLiquidityFee;
777     uint256 public buyDevFee;
778  
779     uint256 public sellTotalFees;
780     uint256 public sellMarketingFee;
781     uint256 public sellLiquidityFee;
782     uint256 public sellDevFee;
783  
784     uint256 public tokensForMarketing;
785     uint256 public tokensForLiquidity;
786     uint256 public tokensForDev;
787  
788     // block number of opened trading
789     uint256 launchedAt;
790  
791     /******************/
792  
793     // exclude from fees and max transaction amount
794     mapping (address => bool) private _isExcludedFromFees;
795     mapping (address => bool) public _isExcludedMaxTransactionAmount;
796  
797     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
798     // could be subject to a maximum transfer amount
799     mapping (address => bool) public automatedMarketMakerPairs;
800  
801     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
802  
803     event ExcludeFromFees(address indexed account, bool isExcluded);
804  
805     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
806  
807     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
808  
809     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
810  
811     event SwapAndLiquify(
812         uint256 tokensSwapped,
813         uint256 ethReceived,
814         uint256 tokensIntoLiquidity
815     );
816  
817     event AutoNukeLP();
818  
819     event ManualNukeLP();
820  
821     constructor() ERC20("Moonvember", "MOONVEMBER") {
822  
823         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
824  
825         excludeFromMaxTransaction(address(_uniswapV2Router), true);
826         uniswapV2Router = _uniswapV2Router;
827  
828         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
829         excludeFromMaxTransaction(address(uniswapV2Pair), true);
830         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
831  
832         uint256 _buyMarketingFee = 10;
833         uint256 _buyLiquidityFee = 0;
834         uint256 _buyDevFee = 0;
835  
836         uint256 _sellMarketingFee = 30;
837         uint256 _sellLiquidityFee = 0;
838         uint256 _sellDevFee = 0;
839  
840         uint256 totalSupply = 111_111_111_111 * 1e18;
841  
842         maxTransactionAmount = totalSupply * 15 / 1000; // 1.5% maxTransactionAmountTxn
843         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
844         swapTokensAtAmount = totalSupply * 4 / 10000; // 0.04% swap wallet
845  
846         buyMarketingFee = _buyMarketingFee;
847         buyLiquidityFee = _buyLiquidityFee;
848         buyDevFee = _buyDevFee;
849         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
850  
851         sellMarketingFee = _sellMarketingFee;
852         sellLiquidityFee = _sellLiquidityFee;
853         sellDevFee = _sellDevFee;
854         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
855  
856         marketingWallet = address(owner()); // set as marketing wallet
857         devWallet = address(owner()); // set as dev wallet
858  
859         // exclude from paying fees or having max transaction amount
860         excludeFromFees(owner(), true);
861         excludeFromFees(devWallet, true);
862         excludeFromFees(address(this), true);
863         excludeFromFees(address(0xdead), true);
864  
865         excludeFromMaxTransaction(owner(), true);
866         excludeFromMaxTransaction(devWallet, true);
867         excludeFromMaxTransaction(address(this), true);
868         excludeFromMaxTransaction(address(0xdead), true);
869  
870         /*
871             _mint is an internal function in ERC20.sol that is only called here,
872             and CANNOT be called ever again
873         */
874         _mint(msg.sender, totalSupply);
875     }
876  
877     receive() external payable {
878  
879   	}
880  
881     // once enabled, can never be turned off
882     function enableTrading() external onlyOwner {
883         tradingActive = true;
884         swapEnabled = true;
885         launchedAt = block.number;
886     }
887  
888     // remove limits after token is stable
889     function removeLimits() external onlyOwner returns (bool){
890         limitsInEffect = false;
891         return true;
892     }
893  
894     // disable Transfer delay - cannot be reenabled
895     function disableTransferDelay() external onlyOwner returns (bool){
896         transferDelayEnabled = false;
897         return true;
898     }
899  
900      // change the minimum amount of tokens to sell from fees
901     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
902   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
903   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
904   	    swapTokensAtAmount = newAmount;
905   	    return true;
906   	}
907  
908     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
909         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
910         maxTransactionAmount = newNum * (10**18);
911     }
912  
913     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
914         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
915         maxWallet = newNum * (10**18);
916     }
917  
918     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
919         _isExcludedMaxTransactionAmount[updAds] = isEx;
920     }
921  
922     // only use to disable contract sales if absolutely necessary (emergency use only)
923     function updateSwapEnabled(bool enabled) external onlyOwner(){
924         swapEnabled = enabled;
925     }
926  
927     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
928         buyMarketingFee = _marketingFee;
929         buyLiquidityFee = _liquidityFee;
930         buyDevFee = _devFee;
931         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
932         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
933     }
934  
935     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
936         sellMarketingFee = _marketingFee;
937         sellLiquidityFee = _liquidityFee;
938         sellDevFee = _devFee;
939         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
940         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
941     }
942  
943     function excludeFromFees(address account, bool excluded) public onlyOwner {
944         _isExcludedFromFees[account] = excluded;
945         emit ExcludeFromFees(account, excluded);
946     }
947  
948     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
949         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
950  
951         _setAutomatedMarketMakerPair(pair, value);
952     }
953  
954     function _setAutomatedMarketMakerPair(address pair, bool value) private {
955         automatedMarketMakerPairs[pair] = value;
956  
957         emit SetAutomatedMarketMakerPair(pair, value);
958     }
959  
960     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
961         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
962         marketingWallet = newMarketingWallet;
963     }
964  
965     function updateDevWallet(address newWallet) external onlyOwner {
966         emit devWalletUpdated(newWallet, devWallet);
967         devWallet = newWallet;
968     }
969 
970     function isExcludedFromFees(address account) public view returns(bool) {
971         return _isExcludedFromFees[account];
972     }
973  
974     function _transfer(
975         address from,
976         address to,
977         uint256 amount
978     ) internal override {
979         require(from != address(0), "ERC20: transfer from the zero address");
980         require(to != address(0), "ERC20: transfer to the zero address");
981          if(amount == 0) {
982             super._transfer(from, to, 0);
983             return;
984         }
985  
986         if(limitsInEffect){
987             if (
988                 from != owner() &&
989                 to != owner() &&
990                 to != address(0) &&
991                 to != address(0xdead) &&
992                 !swapping
993             ){
994                 if(!tradingActive){
995                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
996                 }
997  
998                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
999                 if (transferDelayEnabled){
1000                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1001                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled. Only one purchase per block allowed.");
1002                         _holderLastTransferTimestamp[tx.origin] = block.number;
1003                     }
1004                 }
1005  
1006                 //when buy
1007                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1008                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1009                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1010                 }
1011  
1012                 //when sell
1013                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1014                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1015                 }
1016                 else if(!_isExcludedMaxTransactionAmount[to]){
1017                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1018                 }
1019             }
1020         }
1021  
1022 		uint256 contractTokenBalance = balanceOf(address(this));
1023  
1024         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1025  
1026         if( 
1027             canSwap &&
1028             swapEnabled &&
1029             !swapping &&
1030             !automatedMarketMakerPairs[from] &&
1031             !_isExcludedFromFees[from] &&
1032             !_isExcludedFromFees[to]
1033         ) {
1034             swapping = true;
1035  
1036             swapBack();
1037  
1038             swapping = false;
1039         }
1040  
1041         bool takeFee = !swapping;
1042  
1043         // if any account belongs to _isExcludedFromFee account then remove the fee
1044         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1045             takeFee = false;
1046         }
1047  
1048         uint256 fees = 0;
1049         // only take fees on buys/sells, do not take on wallet transfers
1050         if(takeFee){
1051             // on sell
1052             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1053                 fees = amount.mul(sellTotalFees).div(100);
1054                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1055                 tokensForDev += fees * sellDevFee / sellTotalFees;
1056                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1057             }
1058             // on buy
1059             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1060         	    fees = amount.mul(buyTotalFees).div(100);
1061         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1062                 tokensForDev += fees * buyDevFee / buyTotalFees;
1063                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1064             }
1065  
1066             if(fees > 0){    
1067                 super._transfer(from, address(this), fees);
1068             }
1069  
1070         	amount -= fees;
1071         }
1072  
1073         super._transfer(from, to, amount);
1074     }
1075  
1076     function swapTokensForEth(uint256 tokenAmount) private {
1077  
1078         // generate the uniswap pair path of token -> weth
1079         address[] memory path = new address[](2);
1080         path[0] = address(this);
1081         path[1] = uniswapV2Router.WETH();
1082  
1083         _approve(address(this), address(uniswapV2Router), tokenAmount);
1084  
1085         // make the swap
1086         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1087             tokenAmount,
1088             0, // accept any amount of ETH
1089             path,
1090             address(this),
1091             block.timestamp
1092         );
1093  
1094     }
1095  
1096     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1097         // approve token transfer to cover all possible scenarios
1098         _approve(address(this), address(uniswapV2Router), tokenAmount);
1099  
1100         // add the liquidity
1101         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1102             address(this),
1103             tokenAmount,
1104             0, // slippage is unavoidable
1105             0, // slippage is unavoidable
1106             deadAddress,
1107             block.timestamp
1108         );
1109     }
1110  
1111     function swapBack() private {
1112         uint256 contractBalance = balanceOf(address(this));
1113         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1114         bool success;
1115  
1116         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1117  
1118         if(contractBalance > swapTokensAtAmount * 20){
1119           contractBalance = swapTokensAtAmount * 20;
1120         }
1121  
1122         // Halve the amount of liquidity tokens
1123         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1124         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1125  
1126         uint256 initialETHBalance = address(this).balance;
1127  
1128         swapTokensForEth(amountToSwapForETH); 
1129  
1130         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1131  
1132         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1133         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1134  
1135  
1136         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1137  
1138  
1139         tokensForLiquidity = 0;
1140         tokensForMarketing = 0;
1141         tokensForDev = 0;
1142  
1143         (success,) = address(devWallet).call{value: ethForDev}("");
1144  
1145         if(liquidityTokens > 0 && ethForLiquidity > 0){
1146             addLiquidity(liquidityTokens, ethForLiquidity);
1147             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1148         }
1149  
1150         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1151     }
1152 }