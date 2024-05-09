1 /**
2 
3 Freemasonry  ($FREE) is JABULUM 'Eye of Providence'
4 
5 1 9 11 20 101 250 911 1390 1717 1751 1813 1725 1736
6 
7 Telegram: https://t.me/freemasonryportal
8 Website: https://freemasonryerc20.com/
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity ^0.8.9;
14  
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19  
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25  
26 interface IUniswapV2Pair {
27     event Approval(address indexed owner, address indexed spender, uint value);
28     event Transfer(address indexed from, address indexed to, uint value);
29  
30     function name() external pure returns (string memory);
31     function symbol() external pure returns (string memory);
32     function decimals() external pure returns (uint8);
33     function totalSupply() external view returns (uint);
34     function balanceOf(address owner) external view returns (uint);
35     function allowance(address owner, address spender) external view returns (uint);
36  
37     function approve(address spender, uint value) external returns (bool);
38     function transfer(address to, uint value) external returns (bool);
39     function transferFrom(address from, address to, uint value) external returns (bool);
40  
41     function DOMAIN_SEPARATOR() external view returns (bytes32);
42     function PERMIT_TYPEHASH() external pure returns (bytes32);
43     function nonces(address owner) external view returns (uint);
44  
45     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
46  
47     event Mint(address indexed sender, uint amount0, uint amount1);
48     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
49     event Swap(
50         address indexed sender,
51         uint amount0In,
52         uint amount1In,
53         uint amount0Out,
54         uint amount1Out,
55         address indexed to
56     );
57     event Sync(uint112 reserve0, uint112 reserve1);
58  
59     function MINIMUM_LIQUIDITY() external pure returns (uint);
60     function factory() external view returns (address);
61     function token0() external view returns (address);
62     function token1() external view returns (address);
63     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
64     function price0CumulativeLast() external view returns (uint);
65     function price1CumulativeLast() external view returns (uint);
66     function kLast() external view returns (uint);
67  
68     function mint(address to) external returns (uint liquidity);
69     function burn(address to) external returns (uint amount0, uint amount1);
70     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
71     function skim(address to) external;
72     function sync() external;
73  
74     function initialize(address, address) external;
75 }
76  
77 interface IUniswapV2Factory {
78     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
79  
80     function feeTo() external view returns (address);
81     function feeToSetter() external view returns (address);
82  
83     function getPair(address tokenA, address tokenB) external view returns (address pair);
84     function allPairs(uint) external view returns (address pair);
85     function allPairsLength() external view returns (uint);
86  
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88  
89     function setFeeTo(address) external;
90     function setFeeToSetter(address) external;
91 }
92  
93 interface IERC20 {
94     /**
95      * @dev Returns the amount of tokens in existence.
96      */
97     function totalSupply() external view returns (uint256);
98  
99     /**
100      * @dev Returns the amount of tokens owned by `account`.
101      */
102     function balanceOf(address account) external view returns (uint256);
103  
104     /**
105      * @dev Moves `amount` tokens from the caller's account to `recipient`.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transfer(address recipient, uint256 amount) external returns (bool);
112  
113     /**
114      * @dev Returns the remaining number of tokens that `spender` will be
115      * allowed to spend on behalf of `owner` through {transferFrom}. This is
116      * zero by default.
117      *
118      * This value changes when {approve} or {transferFrom} are called.
119      */
120     function allowance(address owner, address spender) external view returns (uint256);
121  
122     /**
123      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * IMPORTANT: Beware that changing an allowance with this method brings the risk
128      * that someone may use both the old and the new allowance by unfortunate
129      * transaction ordering. One possible solution to mitigate this race
130      * condition is to first reduce the spender's allowance to 0 and set the
131      * desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address spender, uint256 amount) external returns (bool);
137  
138     /**
139      * @dev Moves `amount` tokens from `sender` to `recipient` using the
140      * allowance mechanism. `amount` is then deducted from the caller's
141      * allowance.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transferFrom(
148         address sender,
149         address recipient,
150         uint256 amount
151     ) external returns (bool);
152  
153     /**
154      * @dev Emitted when `value` tokens are moved from one account (`from`) to
155      * another (`to`).
156      *
157      * Note that `value` may be zero.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 value);
160  
161     /**
162      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
163      * a call to {approve}. `value` is the new allowance.
164      */
165     event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167  
168 interface IERC20Metadata is IERC20 {
169     /**
170      * @dev Returns the name of the token.
171      */
172     function name() external view returns (string memory);
173  
174     /**
175      * @dev Returns the symbol of the token.
176      */
177     function symbol() external view returns (string memory);
178  
179     /**
180      * @dev Returns the decimals places of the token.
181      */
182     function decimals() external view returns (uint8);
183 }
184  
185  
186 contract ERC20 is Context, IERC20, IERC20Metadata {
187     using SafeMath for uint256;
188  
189     mapping(address => uint256) private _balances;
190  
191     mapping(address => mapping(address => uint256)) private _allowances;
192  
193     uint256 private _totalSupply;
194  
195     string private _name;
196     string private _symbol;
197  
198     /**
199      * @dev Sets the values for {name} and {symbol}.
200      *
201      * The default value of {decimals} is 18. To select a different value for
202      * {decimals} you should overload it.
203      *
204      * All two of these values are immutable: they can only be set once during
205      * construction.
206      */
207     constructor(string memory name_, string memory symbol_) {
208         _name = name_;
209         _symbol = symbol_;
210     }
211  
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() public view virtual override returns (string memory) {
216         return _name;
217     }
218  
219     /**
220      * @dev Returns the symbol of the token, usually a shorter version of the
221      * name.
222      */
223     function symbol() public view virtual override returns (string memory) {
224         return _symbol;
225     }
226  
227     /**
228      * @dev Returns the number of decimals used to get its user representation.
229      * For example, if `decimals` equals `2`, a balance of `505` tokens should
230      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
231      *
232      * Tokens usually opt for a value of 18, imitating the relationship between
233      * Ether and Wei. This is the value {ERC20} uses, unless this function is
234      * overridden;
235      *
236      * NOTE: This information is only used for _display_ purposes: it in
237      * no way affects any of the arithmetic of the contract, including
238      * {IERC20-balanceOf} and {IERC20-transfer}.
239      */
240     function decimals() public view virtual override returns (uint8) {
241         return 18;
242     }
243  
244     /**
245      * @dev See {IERC20-totalSupply}.
246      */
247     function totalSupply() public view virtual override returns (uint256) {
248         return _totalSupply;
249     }
250  
251     /**
252      * @dev See {IERC20-balanceOf}.
253      */
254     function balanceOf(address account) public view virtual override returns (uint256) {
255         return _balances[account];
256     }
257  
258     /**
259      * @dev See {IERC20-transfer}.
260      *
261      * Requirements:
262      *
263      * - `recipient` cannot be the zero address.
264      * - the caller must have a balance of at least `amount`.
265      */
266     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270  
271     /**
272      * @dev See {IERC20-allowance}.
273      */
274     function allowance(address owner, address spender) public view virtual override returns (uint256) {
275         return _allowances[owner][spender];
276     }
277  
278     /**
279      * @dev See {IERC20-approve}.
280      *
281      * Requirements:
282      *
283      * - `spender` cannot be the zero address.
284      */
285     function approve(address spender, uint256 amount) public virtual override returns (bool) {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289  
290     /**
291      * @dev See {IERC20-transferFrom}.
292      *
293      * Emits an {Approval} event indicating the updated allowance. This is not
294      * required by the EIP. See the note at the beginning of {ERC20}.
295      *
296      * Requirements:
297      *
298      * - `sender` and `recipient` cannot be the zero address.
299      * - `sender` must have a balance of at least `amount`.
300      * - the caller must have allowance for ``sender``'s tokens of at least
301      * `amount`.
302      */
303     function transferFrom(
304         address sender,
305         address recipient,
306         uint256 amount
307     ) public virtual override returns (bool) {
308         _transfer(sender, recipient, amount);
309         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
310         return true;
311     }
312  
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
327         return true;
328     }
329  
330     /**
331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to {approve} that can be used as a mitigation for
334      * problems described in {IERC20-approve}.
335      *
336      * Emits an {Approval} event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      * - `spender` must have allowance for the caller of at least
342      * `subtractedValue`.
343      */
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
346         return true;
347     }
348  
349     /**
350      * @dev Moves tokens `amount` from `sender` to `recipient`.
351      *
352      * This is internal function is equivalent to {transfer}, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a {Transfer} event.
356      *
357      * Requirements:
358      *
359      * - `sender` cannot be the zero address.
360      * - `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      */
363     function _transfer(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) internal virtual {
368         require(sender != address(0), "ERC20: transfer from the zero address");
369         require(recipient != address(0), "ERC20: transfer to the zero address");
370  
371         _beforeTokenTransfer(sender, recipient, amount);
372  
373         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
374         _balances[recipient] = _balances[recipient].add(amount);
375         emit Transfer(sender, recipient, amount);
376     }
377  
378     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
379      * the total supply.
380      *
381      * Emits a {Transfer} event with `from` set to the zero address.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      */
387     function _mint(address account, uint256 amount) internal virtual {
388         require(account != address(0), "ERC20: mint to the zero address");
389  
390         _beforeTokenTransfer(address(0), account, amount);
391  
392         _totalSupply = _totalSupply.add(amount);
393         _balances[account] = _balances[account].add(amount);
394         emit Transfer(address(0), account, amount);
395     }
396  
397     /**
398      * @dev Destroys `amount` tokens from `account`, reducing the
399      * total supply.
400      *
401      * Emits a {Transfer} event with `to` set to the zero address.
402      *
403      * Requirements:
404      *
405      * - `account` cannot be the zero address.
406      * - `account` must have at least `amount` tokens.
407      */
408     function _burn(address account, uint256 amount) internal virtual {
409         require(account != address(0), "ERC20: burn from the zero address");
410  
411         _beforeTokenTransfer(account, address(0), amount);
412  
413         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
414         _totalSupply = _totalSupply.sub(amount);
415         emit Transfer(account, address(0), amount);
416     }
417  
418     /**
419      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
420      *
421      * This internal function is equivalent to `approve`, and can be used to
422      * e.g. set automatic allowances for certain subsystems, etc.
423      *
424      * Emits an {Approval} event.
425      *
426      * Requirements:
427      *
428      * - `owner` cannot be the zero address.
429      * - `spender` cannot be the zero address.
430      */
431     function _approve(
432         address owner,
433         address spender,
434         uint256 amount
435     ) internal virtual {
436         require(owner != address(0), "ERC20: approve from the zero address");
437         require(spender != address(0), "ERC20: approve to the zero address");
438  
439         _allowances[owner][spender] = amount;
440         emit Approval(owner, spender, amount);
441     }
442  
443     /**
444      * @dev Hook that is called before any transfer of tokens. This includes
445      * minting and burning.
446      *
447      * Calling conditions:
448      *
449      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
450      * will be to transferred to `to`.
451      * - when `from` is zero, `amount` tokens will be minted for `to`.
452      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
453      * - `from` and `to` are never both zero.
454      *
455      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
456      */
457     function _beforeTokenTransfer(
458         address from,
459         address to,
460         uint256 amount
461     ) internal virtual {}
462 }
463  
464 library SafeMath {
465     function add(uint256 a, uint256 b) internal pure returns (uint256) {
466         uint256 c = a + b;
467         require(c >= a, "SafeMath: addition overflow");
468  
469         return c;
470     }
471 
472     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
473         return sub(a, b, "SafeMath: subtraction overflow");
474     }
475 
476     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
477         require(b <= a, errorMessage);
478         uint256 c = a - b;
479  
480         return c;
481     }
482 
483     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
484         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
485         // benefit is lost if 'b' is also tested.
486         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
487         if (a == 0) {
488             return 0;
489         }
490  
491         uint256 c = a * b;
492         require(c / a == b, "SafeMath: multiplication overflow");
493  
494         return c;
495     }
496 
497     function div(uint256 a, uint256 b) internal pure returns (uint256) {
498         return div(a, b, "SafeMath: division by zero");
499     }
500 
501     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
502         require(b > 0, errorMessage);
503         uint256 c = a / b;
504 
505         return c;
506     }
507 
508     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
509         return mod(a, b, "SafeMath: modulo by zero");
510     }
511 
512     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
513         require(b != 0, errorMessage);
514         return a % b;
515     }
516 }
517  
518 contract Ownable is Context {
519     address private _owner;
520  
521     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
522  
523     constructor () {
524         address msgSender = _msgSender();
525         _owner = msgSender;
526         emit OwnershipTransferred(address(0), msgSender);
527     }
528 
529     function owner() public view returns (address) {
530         return _owner;
531     }
532  
533     modifier onlyOwner() {
534         require(_owner == _msgSender(), "Ownable: caller is not the owner");
535         _;
536     }
537  
538     function renounceOwnership() public virtual onlyOwner {
539         emit OwnershipTransferred(_owner, address(0));
540         _owner = address(0);
541     }
542 
543     function transferOwnership(address newOwner) public virtual onlyOwner {
544         require(newOwner != address(0), "Ownable: new owner is the zero address");
545         emit OwnershipTransferred(_owner, newOwner);
546         _owner = newOwner;
547     }
548 }
549  
550  
551 
552 library SafeMathInt {
553     int256 private constant MIN_INT256 = int256(1) << 255;
554     int256 private constant MAX_INT256 = ~(int256(1) << 255);
555  
556     function mul(int256 a, int256 b) internal pure returns (int256) {
557         int256 c = a * b;
558  
559         // Detect overflow when multiplying MIN_INT256 with -1
560         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
561         require((b == 0) || (c / b == a));
562         return c;
563     }
564  
565     function div(int256 a, int256 b) internal pure returns (int256) {
566         // Prevent overflow when dividing MIN_INT256 by -1
567         require(b != -1 || a != MIN_INT256);
568  
569         // Solidity already throws when dividing by 0.
570         return a / b;
571     }
572  
573     function sub(int256 a, int256 b) internal pure returns (int256) {
574         int256 c = a - b;
575         require((b >= 0 && c <= a) || (b < 0 && c > a));
576         return c;
577     }
578  
579     function add(int256 a, int256 b) internal pure returns (int256) {
580         int256 c = a + b;
581         require((b >= 0 && c >= a) || (b < 0 && c < a));
582         return c;
583     }
584  
585     function abs(int256 a) internal pure returns (int256) {
586         require(a != MIN_INT256);
587         return a < 0 ? -a : a;
588     }
589  
590  
591     function toUint256Safe(int256 a) internal pure returns (uint256) {
592         require(a >= 0);
593         return uint256(a);
594     }
595 }
596  
597 library SafeMathUint {
598   function toInt256Safe(uint256 a) internal pure returns (int256) {
599     int256 b = int256(a);
600     require(b >= 0);
601     return b;
602   }
603 }
604  
605  
606 interface IUniswapV2Router01 {
607     function factory() external pure returns (address);
608     function WETH() external pure returns (address);
609  
610     function addLiquidity(
611         address tokenA,
612         address tokenB,
613         uint amountADesired,
614         uint amountBDesired,
615         uint amountAMin,
616         uint amountBMin,
617         address to,
618         uint deadline
619     ) external returns (uint amountA, uint amountB, uint liquidity);
620     function addLiquidityETH(
621         address token,
622         uint amountTokenDesired,
623         uint amountTokenMin,
624         uint amountETHMin,
625         address to,
626         uint deadline
627     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
628     function removeLiquidity(
629         address tokenA,
630         address tokenB,
631         uint liquidity,
632         uint amountAMin,
633         uint amountBMin,
634         address to,
635         uint deadline
636     ) external returns (uint amountA, uint amountB);
637     function removeLiquidityETH(
638         address token,
639         uint liquidity,
640         uint amountTokenMin,
641         uint amountETHMin,
642         address to,
643         uint deadline
644     ) external returns (uint amountToken, uint amountETH);
645     function removeLiquidityWithPermit(
646         address tokenA,
647         address tokenB,
648         uint liquidity,
649         uint amountAMin,
650         uint amountBMin,
651         address to,
652         uint deadline,
653         bool approveMax, uint8 v, bytes32 r, bytes32 s
654     ) external returns (uint amountA, uint amountB);
655     function removeLiquidityETHWithPermit(
656         address token,
657         uint liquidity,
658         uint amountTokenMin,
659         uint amountETHMin,
660         address to,
661         uint deadline,
662         bool approveMax, uint8 v, bytes32 r, bytes32 s
663     ) external returns (uint amountToken, uint amountETH);
664     function swapExactTokensForTokens(
665         uint amountIn,
666         uint amountOutMin,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external returns (uint[] memory amounts);
671     function swapTokensForExactTokens(
672         uint amountOut,
673         uint amountInMax,
674         address[] calldata path,
675         address to,
676         uint deadline
677     ) external returns (uint[] memory amounts);
678     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
679         external
680         payable
681         returns (uint[] memory amounts);
682     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
683         external
684         returns (uint[] memory amounts);
685     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
686         external
687         returns (uint[] memory amounts);
688     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
689         external
690         payable
691         returns (uint[] memory amounts);
692  
693     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
694     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
695     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
696     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
697     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
698 }
699  
700 interface IUniswapV2Router02 is IUniswapV2Router01 {
701     function removeLiquidityETHSupportingFeeOnTransferTokens(
702         address token,
703         uint liquidity,
704         uint amountTokenMin,
705         uint amountETHMin,
706         address to,
707         uint deadline
708     ) external returns (uint amountETH);
709     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
710         address token,
711         uint liquidity,
712         uint amountTokenMin,
713         uint amountETHMin,
714         address to,
715         uint deadline,
716         bool approveMax, uint8 v, bytes32 r, bytes32 s
717     ) external returns (uint amountETH);
718  
719     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
720         uint amountIn,
721         uint amountOutMin,
722         address[] calldata path,
723         address to,
724         uint deadline
725     ) external;
726     function swapExactETHForTokensSupportingFeeOnTransferTokens(
727         uint amountOutMin,
728         address[] calldata path,
729         address to,
730         uint deadline
731     ) external payable;
732     function swapExactTokensForETHSupportingFeeOnTransferTokens(
733         uint amountIn,
734         uint amountOutMin,
735         address[] calldata path,
736         address to,
737         uint deadline
738     ) external;
739 }
740  
741 contract FREEMASONRY is ERC20, Ownable {
742     using SafeMath for uint256;
743  
744     IUniswapV2Router02 public immutable uniswapV2Router;
745     address public immutable uniswapV2Pair;
746     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
747  
748     bool private swapping;
749  
750     address public marketingWallet;
751     address public devWallet;
752  
753     uint256 public maxTransactionAmount;
754     uint256 public swapTokensAtAmount;
755     uint256 public maxWallet;
756  
757     bool public limitsInEffect = true;
758     bool public tradingActive = false;
759     bool public swapEnabled = false;
760  
761      // Anti-bot and anti-whale mappings and variables
762     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
763  
764     // Seller Map
765     mapping (address => uint256) private _holderFirstBuyTimestamp;
766  
767     bool public transferDelayEnabled = true;
768  
769     uint256 public buyTotalFees;
770     uint256 public buyMarketingFee;
771     uint256 public buyLiquidityFee;
772     uint256 public buyDevFee;
773  
774     uint256 public sellTotalFees;
775     uint256 public sellMarketingFee;
776     uint256 public sellLiquidityFee;
777     uint256 public sellDevFee;
778 
779     uint256 public feeDenominator;
780  
781     uint256 public tokensForMarketing;
782     uint256 public tokensForLiquidity;
783     uint256 public tokensForDev;
784  
785     // block number of opened trading
786     uint256 launchedAt;
787  
788     /******************/
789  
790     // exclude from fees and max transaction amount
791     mapping (address => bool) private _isExcludedFromFees;
792     mapping (address => bool) public _isExcludedMaxTransactionAmount;
793  
794     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
795     // could be subject to a maximum transfer amount
796     mapping (address => bool) public automatedMarketMakerPairs;
797  
798     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
799  
800     event ExcludeFromFees(address indexed account, bool isExcluded);
801  
802     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
803  
804     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
805  
806     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
807  
808     event SwapAndLiquify(
809         uint256 tokensSwapped,
810         uint256 ethReceived,
811         uint256 tokensIntoLiquidity
812     );
813  
814     event AutoNukeLP();
815  
816     event ManualNukeLP();
817  
818     constructor() ERC20("freemasonry", "FREE") {
819  
820         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
821  
822         excludeFromMaxTransaction(address(_uniswapV2Router), true);
823         uniswapV2Router = _uniswapV2Router;
824  
825         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
826         excludeFromMaxTransaction(address(uniswapV2Pair), true);
827         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
828  
829         // tax is higher at launch to prevent from bot attack, final tax will be 4/4
830         uint256 _buyMarketingFee = 10;
831         uint256 _buyLiquidityFee = 0;
832         uint256 _buyDevFee = 5;
833         
834         uint256 _sellMarketingFee = 10;
835         uint256 _sellLiquidityFee = 0;
836         uint256 _sellDevFee = 15;
837 
838         uint256 _feeDenominator = 100;
839  
840         uint256 totalSupply = 100_000_000 * 1e18;
841  
842         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
843         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
844         swapTokensAtAmount = totalSupply * 3 / 10000; // 0.03% swap wallet
845 
846         feeDenominator = _feeDenominator;
847  
848         buyMarketingFee = _buyMarketingFee;
849         buyLiquidityFee = _buyLiquidityFee;
850         buyDevFee = _buyDevFee;
851         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
852  
853         sellMarketingFee = _sellMarketingFee;
854         sellLiquidityFee = _sellLiquidityFee;
855         sellDevFee = _sellDevFee;
856         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
857  
858         marketingWallet = address(0xcf72567f73188fbD0458591683a9e025EA394f4d); // set as marketing wallet
859         devWallet = address(0xcf72567f73188fbD0458591683a9e025EA394f4d); // set as dev wallet
860  
861         // exclude from paying fees or having max transaction amount
862         excludeFromFees(owner(), true);
863         excludeFromFees(devWallet, true);
864         excludeFromFees(address(this), true);
865         excludeFromFees(address(0xdead), true);
866  
867         excludeFromMaxTransaction(owner(), true);
868         excludeFromMaxTransaction(devWallet, true);
869         excludeFromMaxTransaction(address(this), true);
870         excludeFromMaxTransaction(address(0xdead), true);
871  
872         /*
873             _mint is an internal function in ERC20.sol that is only called here,
874             and CANNOT be called ever again
875         */
876         _mint(msg.sender, totalSupply);
877     }
878  
879     receive() external payable {
880  
881   	}
882  
883     // once enabled, can never be turned off
884     function enableTrading() external onlyOwner {
885         tradingActive = true;
886         swapEnabled = true;
887         launchedAt = block.number;
888     }
889  
890     // remove limits after token is stable
891     function removeLimits() external onlyOwner returns (bool){
892         limitsInEffect = false;
893         return true;
894     }
895  
896     // disable Transfer delay - cannot be reenabled
897     function disableTransferDelay() external onlyOwner returns (bool){
898         transferDelayEnabled = false;
899         return true;
900     }
901  
902      // change the minimum amount of tokens to sell from fees
903     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
904   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
905   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
906   	    swapTokensAtAmount = newAmount;
907   	    return true;
908   	}
909  
910     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
911         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
912         maxTransactionAmount = newNum * (10**18);
913     }
914  
915     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
916         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
917         maxWallet = newNum * (10**18);
918     }
919  
920     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
921         _isExcludedMaxTransactionAmount[updAds] = isEx;
922     }
923  
924     // only use to disable contract sales if absolutely necessary (emergency use only)
925     function updateSwapEnabled(bool enabled) external onlyOwner(){
926         swapEnabled = enabled;
927     }
928  
929     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
930         buyMarketingFee = _marketingFee;
931         buyLiquidityFee = _liquidityFee;
932         buyDevFee = _devFee;
933         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
934         require(buyTotalFees.div(feeDenominator) <= 10, "Must keep fees at 10% or less");
935     }
936  
937     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
938         sellMarketingFee = _marketingFee;
939         sellLiquidityFee = _liquidityFee;
940         sellDevFee = _devFee;
941         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
942         require(sellTotalFees.div(feeDenominator) <= 20, "Must keep fees at 20% or less");
943     }
944  
945     function excludeFromFees(address account, bool excluded) public onlyOwner {
946         _isExcludedFromFees[account] = excluded;
947         emit ExcludeFromFees(account, excluded);
948     }
949  
950     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
951         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
952  
953         _setAutomatedMarketMakerPair(pair, value);
954     }
955  
956     function _setAutomatedMarketMakerPair(address pair, bool value) private {
957         automatedMarketMakerPairs[pair] = value;
958  
959         emit SetAutomatedMarketMakerPair(pair, value);
960     }
961  
962     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
963         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
964         marketingWallet = newMarketingWallet;
965     }
966  
967     function updateDevWallet(address newWallet) external onlyOwner {
968         emit devWalletUpdated(newWallet, devWallet);
969         devWallet = newWallet;
970     }
971 
972     function isExcludedFromFees(address account) public view returns(bool) {
973         return _isExcludedFromFees[account];
974     }
975  
976     function _transfer(
977         address from,
978         address to,
979         uint256 amount
980     ) internal override {
981         require(from != address(0), "ERC20: transfer from the zero address");
982         require(to != address(0), "ERC20: transfer to the zero address");
983         if(amount == 0) {
984             super._transfer(from, to, 0);
985             return;
986         }
987  
988         if(limitsInEffect){
989             if (
990                 from != owner() &&
991                 to != owner() &&
992                 to != address(0) &&
993                 to != address(0xdead) &&
994                 !swapping
995             ){
996                 if(!tradingActive){
997                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
998                 }
999  
1000                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1001                 if (transferDelayEnabled) {
1002                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1003                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled. Only one purchase per block allowed.");
1004                         _holderLastTransferTimestamp[tx.origin] = block.number;
1005                     }
1006                 }
1007  
1008                 //when buy
1009                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1010                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1011                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1012                 }
1013  
1014                 //when sell
1015                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1016                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1017                 }
1018                 else if(!_isExcludedMaxTransactionAmount[to]){
1019                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1020                 }
1021             }
1022         }
1023  
1024 		uint256 contractTokenBalance = balanceOf(address(this));
1025  
1026         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1027  
1028         if( 
1029             canSwap &&
1030             swapEnabled &&
1031             !swapping &&
1032             !automatedMarketMakerPairs[from] &&
1033             !_isExcludedFromFees[from] &&
1034             !_isExcludedFromFees[to]
1035         ) {
1036             swapping = true;
1037  
1038             swapBack();
1039  
1040             swapping = false;
1041         }
1042  
1043         bool takeFee = !swapping;
1044  
1045         // if any account belongs to _isExcludedFromFee account then remove the fee
1046         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1047             takeFee = false;
1048         }
1049  
1050         uint256 fees = 0;
1051         // only take fees on buys/sells, do not take on wallet transfers
1052         if(takeFee){
1053             // on sell
1054             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1055                 fees = amount.mul(sellTotalFees).div(feeDenominator);
1056                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1057                 tokensForDev += fees * sellDevFee / sellTotalFees;
1058                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1059             }
1060             // on buy
1061             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1062         	    fees = amount.mul(buyTotalFees).div(feeDenominator);
1063         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1064                 tokensForDev += fees * buyDevFee / buyTotalFees;
1065                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1066             }
1067  
1068             if(fees > 0){    
1069                 super._transfer(from, address(this), fees);
1070             }
1071  
1072         	amount -= fees;
1073         }
1074  
1075         super._transfer(from, to, amount);
1076     }
1077  
1078     function swapTokensForEth(uint256 tokenAmount) private {
1079         // generate the uniswap pair path of token -> weth
1080         address[] memory path = new address[](2);
1081         path[0] = address(this);
1082         path[1] = uniswapV2Router.WETH();
1083  
1084         _approve(address(this), address(uniswapV2Router), tokenAmount);
1085  
1086         // make the swap
1087         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1088             tokenAmount,
1089             0, // accept any amount of ETH
1090             path,
1091             address(this),
1092             block.timestamp
1093         );
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
1135         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1136  
1137         tokensForLiquidity = 0;
1138         tokensForMarketing = 0;
1139         tokensForDev = 0;
1140  
1141         (success,) = address(devWallet).call{value: ethForDev}("");
1142  
1143         if(liquidityTokens > 0 && ethForLiquidity > 0){
1144             addLiquidity(liquidityTokens, ethForLiquidity);
1145             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1146         }
1147  
1148         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1149     }
1150 }