1 /**
2 
3 Chupacabra $CHUPA unleash the beast!
4 
5 Telegram: https://t.me/chupacabraportal
6 Website: https://chupacabracommunity.com
7 
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity ^0.8.9;
13  
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18  
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24  
25 interface IUniswapV2Pair {
26     event Approval(address indexed owner, address indexed spender, uint value);
27     event Transfer(address indexed from, address indexed to, uint value);
28  
29     function name() external pure returns (string memory);
30     function symbol() external pure returns (string memory);
31     function decimals() external pure returns (uint8);
32     function totalSupply() external view returns (uint);
33     function balanceOf(address owner) external view returns (uint);
34     function allowance(address owner, address spender) external view returns (uint);
35  
36     function approve(address spender, uint value) external returns (bool);
37     function transfer(address to, uint value) external returns (bool);
38     function transferFrom(address from, address to, uint value) external returns (bool);
39  
40     function DOMAIN_SEPARATOR() external view returns (bytes32);
41     function PERMIT_TYPEHASH() external pure returns (bytes32);
42     function nonces(address owner) external view returns (uint);
43  
44     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
45  
46     event Mint(address indexed sender, uint amount0, uint amount1);
47     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
48     event Swap(
49         address indexed sender,
50         uint amount0In,
51         uint amount1In,
52         uint amount0Out,
53         uint amount1Out,
54         address indexed to
55     );
56     event Sync(uint112 reserve0, uint112 reserve1);
57  
58     function MINIMUM_LIQUIDITY() external pure returns (uint);
59     function factory() external view returns (address);
60     function token0() external view returns (address);
61     function token1() external view returns (address);
62     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
63     function price0CumulativeLast() external view returns (uint);
64     function price1CumulativeLast() external view returns (uint);
65     function kLast() external view returns (uint);
66  
67     function mint(address to) external returns (uint liquidity);
68     function burn(address to) external returns (uint amount0, uint amount1);
69     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
70     function skim(address to) external;
71     function sync() external;
72  
73     function initialize(address, address) external;
74 }
75  
76 interface IUniswapV2Factory {
77     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
78  
79     function feeTo() external view returns (address);
80     function feeToSetter() external view returns (address);
81  
82     function getPair(address tokenA, address tokenB) external view returns (address pair);
83     function allPairs(uint) external view returns (address pair);
84     function allPairsLength() external view returns (uint);
85  
86     function createPair(address tokenA, address tokenB) external returns (address pair);
87  
88     function setFeeTo(address) external;
89     function setFeeToSetter(address) external;
90 }
91  
92 interface IERC20 {
93     /**
94      * @dev Returns the amount of tokens in existence.
95      */
96     function totalSupply() external view returns (uint256);
97  
98     /**
99      * @dev Returns the amount of tokens owned by `account`.
100      */
101     function balanceOf(address account) external view returns (uint256);
102  
103     /**
104      * @dev Moves `amount` tokens from the caller's account to `recipient`.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transfer(address recipient, uint256 amount) external returns (bool);
111  
112     /**
113      * @dev Returns the remaining number of tokens that `spender` will be
114      * allowed to spend on behalf of `owner` through {transferFrom}. This is
115      * zero by default.
116      *
117      * This value changes when {approve} or {transferFrom} are called.
118      */
119     function allowance(address owner, address spender) external view returns (uint256);
120  
121     /**
122      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * IMPORTANT: Beware that changing an allowance with this method brings the risk
127      * that someone may use both the old and the new allowance by unfortunate
128      * transaction ordering. One possible solution to mitigate this race
129      * condition is to first reduce the spender's allowance to 0 and set the
130      * desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address spender, uint256 amount) external returns (bool);
136  
137     /**
138      * @dev Moves `amount` tokens from `sender` to `recipient` using the
139      * allowance mechanism. `amount` is then deducted from the caller's
140      * allowance.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transferFrom(
147         address sender,
148         address recipient,
149         uint256 amount
150     ) external returns (bool);
151  
152     /**
153      * @dev Emitted when `value` tokens are moved from one account (`from`) to
154      * another (`to`).
155      *
156      * Note that `value` may be zero.
157      */
158     event Transfer(address indexed from, address indexed to, uint256 value);
159  
160     /**
161      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
162      * a call to {approve}. `value` is the new allowance.
163      */
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166  
167 interface IERC20Metadata is IERC20 {
168     /**
169      * @dev Returns the name of the token.
170      */
171     function name() external view returns (string memory);
172  
173     /**
174      * @dev Returns the symbol of the token.
175      */
176     function symbol() external view returns (string memory);
177  
178     /**
179      * @dev Returns the decimals places of the token.
180      */
181     function decimals() external view returns (uint8);
182 }
183  
184  
185 contract ERC20 is Context, IERC20, IERC20Metadata {
186     using SafeMath for uint256;
187  
188     mapping(address => uint256) private _balances;
189  
190     mapping(address => mapping(address => uint256)) private _allowances;
191  
192     uint256 private _totalSupply;
193  
194     string private _name;
195     string private _symbol;
196  
197     /**
198      * @dev Sets the values for {name} and {symbol}.
199      *
200      * The default value of {decimals} is 18. To select a different value for
201      * {decimals} you should overload it.
202      *
203      * All two of these values are immutable: they can only be set once during
204      * construction.
205      */
206     constructor(string memory name_, string memory symbol_) {
207         _name = name_;
208         _symbol = symbol_;
209     }
210  
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() public view virtual override returns (string memory) {
215         return _name;
216     }
217  
218     /**
219      * @dev Returns the symbol of the token, usually a shorter version of the
220      * name.
221      */
222     function symbol() public view virtual override returns (string memory) {
223         return _symbol;
224     }
225  
226     /**
227      * @dev Returns the number of decimals used to get its user representation.
228      * For example, if `decimals` equals `2`, a balance of `505` tokens should
229      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
230      *
231      * Tokens usually opt for a value of 18, imitating the relationship between
232      * Ether and Wei. This is the value {ERC20} uses, unless this function is
233      * overridden;
234      *
235      * NOTE: This information is only used for _display_ purposes: it in
236      * no way affects any of the arithmetic of the contract, including
237      * {IERC20-balanceOf} and {IERC20-transfer}.
238      */
239     function decimals() public view virtual override returns (uint8) {
240         return 18;
241     }
242  
243     /**
244      * @dev See {IERC20-totalSupply}.
245      */
246     function totalSupply() public view virtual override returns (uint256) {
247         return _totalSupply;
248     }
249  
250     /**
251      * @dev See {IERC20-balanceOf}.
252      */
253     function balanceOf(address account) public view virtual override returns (uint256) {
254         return _balances[account];
255     }
256  
257     /**
258      * @dev See {IERC20-transfer}.
259      *
260      * Requirements:
261      *
262      * - `recipient` cannot be the zero address.
263      * - the caller must have a balance of at least `amount`.
264      */
265     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269  
270     /**
271      * @dev See {IERC20-allowance}.
272      */
273     function allowance(address owner, address spender) public view virtual override returns (uint256) {
274         return _allowances[owner][spender];
275     }
276  
277     /**
278      * @dev See {IERC20-approve}.
279      *
280      * Requirements:
281      *
282      * - `spender` cannot be the zero address.
283      */
284     function approve(address spender, uint256 amount) public virtual override returns (bool) {
285         _approve(_msgSender(), spender, amount);
286         return true;
287     }
288  
289     /**
290      * @dev See {IERC20-transferFrom}.
291      *
292      * Emits an {Approval} event indicating the updated allowance. This is not
293      * required by the EIP. See the note at the beginning of {ERC20}.
294      *
295      * Requirements:
296      *
297      * - `sender` and `recipient` cannot be the zero address.
298      * - `sender` must have a balance of at least `amount`.
299      * - the caller must have allowance for ``sender``'s tokens of at least
300      * `amount`.
301      */
302     function transferFrom(
303         address sender,
304         address recipient,
305         uint256 amount
306     ) public virtual override returns (bool) {
307         _transfer(sender, recipient, amount);
308         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
309         return true;
310     }
311  
312     /**
313      * @dev Atomically increases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
325         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
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
344         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
345         return true;
346     }
347  
348     /**
349      * @dev Moves tokens `amount` from `sender` to `recipient`.
350      *
351      * This is internal function is equivalent to {transfer}, and can be used to
352      * e.g. implement automatic token fees, slashing mechanisms, etc.
353      *
354      * Emits a {Transfer} event.
355      *
356      * Requirements:
357      *
358      * - `sender` cannot be the zero address.
359      * - `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `amount`.
361      */
362     function _transfer(
363         address sender,
364         address recipient,
365         uint256 amount
366     ) internal virtual {
367         require(sender != address(0), "ERC20: transfer from the zero address");
368         require(recipient != address(0), "ERC20: transfer to the zero address");
369  
370         _beforeTokenTransfer(sender, recipient, amount);
371  
372         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
373         _balances[recipient] = _balances[recipient].add(amount);
374         emit Transfer(sender, recipient, amount);
375     }
376  
377     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
378      * the total supply.
379      *
380      * Emits a {Transfer} event with `from` set to the zero address.
381      *
382      * Requirements:
383      *
384      * - `account` cannot be the zero address.
385      */
386     function _mint(address account, uint256 amount) internal virtual {
387         require(account != address(0), "ERC20: mint to the zero address");
388  
389         _beforeTokenTransfer(address(0), account, amount);
390  
391         _totalSupply = _totalSupply.add(amount);
392         _balances[account] = _balances[account].add(amount);
393         emit Transfer(address(0), account, amount);
394     }
395  
396     /**
397      * @dev Destroys `amount` tokens from `account`, reducing the
398      * total supply.
399      *
400      * Emits a {Transfer} event with `to` set to the zero address.
401      *
402      * Requirements:
403      *
404      * - `account` cannot be the zero address.
405      * - `account` must have at least `amount` tokens.
406      */
407     function _burn(address account, uint256 amount) internal virtual {
408         require(account != address(0), "ERC20: burn from the zero address");
409  
410         _beforeTokenTransfer(account, address(0), amount);
411  
412         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
413         _totalSupply = _totalSupply.sub(amount);
414         emit Transfer(account, address(0), amount);
415     }
416  
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
419      *
420      * This internal function is equivalent to `approve`, and can be used to
421      * e.g. set automatic allowances for certain subsystems, etc.
422      *
423      * Emits an {Approval} event.
424      *
425      * Requirements:
426      *
427      * - `owner` cannot be the zero address.
428      * - `spender` cannot be the zero address.
429      */
430     function _approve(
431         address owner,
432         address spender,
433         uint256 amount
434     ) internal virtual {
435         require(owner != address(0), "ERC20: approve from the zero address");
436         require(spender != address(0), "ERC20: approve to the zero address");
437  
438         _allowances[owner][spender] = amount;
439         emit Approval(owner, spender, amount);
440     }
441  
442     /**
443      * @dev Hook that is called before any transfer of tokens. This includes
444      * minting and burning.
445      *
446      * Calling conditions:
447      *
448      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
449      * will be to transferred to `to`.
450      * - when `from` is zero, `amount` tokens will be minted for `to`.
451      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
452      * - `from` and `to` are never both zero.
453      *
454      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
455      */
456     function _beforeTokenTransfer(
457         address from,
458         address to,
459         uint256 amount
460     ) internal virtual {}
461 }
462  
463 library SafeMath {
464     function add(uint256 a, uint256 b) internal pure returns (uint256) {
465         uint256 c = a + b;
466         require(c >= a, "SafeMath: addition overflow");
467  
468         return c;
469     }
470 
471     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
472         return sub(a, b, "SafeMath: subtraction overflow");
473     }
474 
475     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
476         require(b <= a, errorMessage);
477         uint256 c = a - b;
478  
479         return c;
480     }
481 
482     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
483         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
484         // benefit is lost if 'b' is also tested.
485         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
486         if (a == 0) {
487             return 0;
488         }
489  
490         uint256 c = a * b;
491         require(c / a == b, "SafeMath: multiplication overflow");
492  
493         return c;
494     }
495 
496     function div(uint256 a, uint256 b) internal pure returns (uint256) {
497         return div(a, b, "SafeMath: division by zero");
498     }
499 
500     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
501         require(b > 0, errorMessage);
502         uint256 c = a / b;
503 
504         return c;
505     }
506 
507     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
508         return mod(a, b, "SafeMath: modulo by zero");
509     }
510 
511     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
512         require(b != 0, errorMessage);
513         return a % b;
514     }
515 }
516  
517 contract Ownable is Context {
518     address private _owner;
519  
520     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
521  
522     constructor () {
523         address msgSender = _msgSender();
524         _owner = msgSender;
525         emit OwnershipTransferred(address(0), msgSender);
526     }
527 
528     function owner() public view returns (address) {
529         return _owner;
530     }
531  
532     modifier onlyOwner() {
533         require(_owner == _msgSender(), "Ownable: caller is not the owner");
534         _;
535     }
536  
537     function renounceOwnership() public virtual onlyOwner {
538         emit OwnershipTransferred(_owner, address(0));
539         _owner = address(0);
540     }
541 
542     function transferOwnership(address newOwner) public virtual onlyOwner {
543         require(newOwner != address(0), "Ownable: new owner is the zero address");
544         emit OwnershipTransferred(_owner, newOwner);
545         _owner = newOwner;
546     }
547 }
548  
549  
550 
551 library SafeMathInt {
552     int256 private constant MIN_INT256 = int256(1) << 255;
553     int256 private constant MAX_INT256 = ~(int256(1) << 255);
554  
555     function mul(int256 a, int256 b) internal pure returns (int256) {
556         int256 c = a * b;
557  
558         // Detect overflow when multiplying MIN_INT256 with -1
559         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
560         require((b == 0) || (c / b == a));
561         return c;
562     }
563  
564     function div(int256 a, int256 b) internal pure returns (int256) {
565         // Prevent overflow when dividing MIN_INT256 by -1
566         require(b != -1 || a != MIN_INT256);
567  
568         // Solidity already throws when dividing by 0.
569         return a / b;
570     }
571  
572     function sub(int256 a, int256 b) internal pure returns (int256) {
573         int256 c = a - b;
574         require((b >= 0 && c <= a) || (b < 0 && c > a));
575         return c;
576     }
577  
578     function add(int256 a, int256 b) internal pure returns (int256) {
579         int256 c = a + b;
580         require((b >= 0 && c >= a) || (b < 0 && c < a));
581         return c;
582     }
583  
584     function abs(int256 a) internal pure returns (int256) {
585         require(a != MIN_INT256);
586         return a < 0 ? -a : a;
587     }
588  
589  
590     function toUint256Safe(int256 a) internal pure returns (uint256) {
591         require(a >= 0);
592         return uint256(a);
593     }
594 }
595  
596 library SafeMathUint {
597   function toInt256Safe(uint256 a) internal pure returns (int256) {
598     int256 b = int256(a);
599     require(b >= 0);
600     return b;
601   }
602 }
603  
604  
605 interface IUniswapV2Router01 {
606     function factory() external pure returns (address);
607     function WETH() external pure returns (address);
608  
609     function addLiquidity(
610         address tokenA,
611         address tokenB,
612         uint amountADesired,
613         uint amountBDesired,
614         uint amountAMin,
615         uint amountBMin,
616         address to,
617         uint deadline
618     ) external returns (uint amountA, uint amountB, uint liquidity);
619     function addLiquidityETH(
620         address token,
621         uint amountTokenDesired,
622         uint amountTokenMin,
623         uint amountETHMin,
624         address to,
625         uint deadline
626     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
627     function removeLiquidity(
628         address tokenA,
629         address tokenB,
630         uint liquidity,
631         uint amountAMin,
632         uint amountBMin,
633         address to,
634         uint deadline
635     ) external returns (uint amountA, uint amountB);
636     function removeLiquidityETH(
637         address token,
638         uint liquidity,
639         uint amountTokenMin,
640         uint amountETHMin,
641         address to,
642         uint deadline
643     ) external returns (uint amountToken, uint amountETH);
644     function removeLiquidityWithPermit(
645         address tokenA,
646         address tokenB,
647         uint liquidity,
648         uint amountAMin,
649         uint amountBMin,
650         address to,
651         uint deadline,
652         bool approveMax, uint8 v, bytes32 r, bytes32 s
653     ) external returns (uint amountA, uint amountB);
654     function removeLiquidityETHWithPermit(
655         address token,
656         uint liquidity,
657         uint amountTokenMin,
658         uint amountETHMin,
659         address to,
660         uint deadline,
661         bool approveMax, uint8 v, bytes32 r, bytes32 s
662     ) external returns (uint amountToken, uint amountETH);
663     function swapExactTokensForTokens(
664         uint amountIn,
665         uint amountOutMin,
666         address[] calldata path,
667         address to,
668         uint deadline
669     ) external returns (uint[] memory amounts);
670     function swapTokensForExactTokens(
671         uint amountOut,
672         uint amountInMax,
673         address[] calldata path,
674         address to,
675         uint deadline
676     ) external returns (uint[] memory amounts);
677     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
678         external
679         payable
680         returns (uint[] memory amounts);
681     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
682         external
683         returns (uint[] memory amounts);
684     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
685         external
686         returns (uint[] memory amounts);
687     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
688         external
689         payable
690         returns (uint[] memory amounts);
691  
692     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
693     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
694     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
695     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
696     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
697 }
698  
699 interface IUniswapV2Router02 is IUniswapV2Router01 {
700     function removeLiquidityETHSupportingFeeOnTransferTokens(
701         address token,
702         uint liquidity,
703         uint amountTokenMin,
704         uint amountETHMin,
705         address to,
706         uint deadline
707     ) external returns (uint amountETH);
708     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
709         address token,
710         uint liquidity,
711         uint amountTokenMin,
712         uint amountETHMin,
713         address to,
714         uint deadline,
715         bool approveMax, uint8 v, bytes32 r, bytes32 s
716     ) external returns (uint amountETH);
717  
718     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
719         uint amountIn,
720         uint amountOutMin,
721         address[] calldata path,
722         address to,
723         uint deadline
724     ) external;
725     function swapExactETHForTokensSupportingFeeOnTransferTokens(
726         uint amountOutMin,
727         address[] calldata path,
728         address to,
729         uint deadline
730     ) external payable;
731     function swapExactTokensForETHSupportingFeeOnTransferTokens(
732         uint amountIn,
733         uint amountOutMin,
734         address[] calldata path,
735         address to,
736         uint deadline
737     ) external;
738 }
739  
740 contract CHUPACABRA is ERC20, Ownable {
741     using SafeMath for uint256;
742  
743     IUniswapV2Router02 public immutable uniswapV2Router;
744     address public immutable uniswapV2Pair;
745     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
746  
747     bool private swapping;
748  
749     address public marketingWallet;
750     address public devWallet;
751  
752     uint256 public maxTransactionAmount;
753     uint256 public swapTokensAtAmount;
754     uint256 public maxWallet;
755  
756     bool public limitsInEffect = true;
757     bool public tradingActive = false;
758     bool public swapEnabled = false;
759  
760      // Anti-bot and anti-whale mappings and variables
761     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
762  
763     // Seller Map
764     mapping (address => uint256) private _holderFirstBuyTimestamp;
765  
766     bool public transferDelayEnabled = true;
767  
768     uint256 public buyTotalFees;
769     uint256 public buyMarketingFee;
770     uint256 public buyLiquidityFee;
771     uint256 public buyDevFee;
772  
773     uint256 public sellTotalFees;
774     uint256 public sellMarketingFee;
775     uint256 public sellLiquidityFee;
776     uint256 public sellDevFee;
777 
778     uint256 public feeDenominator;
779  
780     uint256 public tokensForMarketing;
781     uint256 public tokensForLiquidity;
782     uint256 public tokensForDev;
783  
784     // block number of opened trading
785     uint256 launchedAt;
786  
787     /******************/
788  
789     // exclude from fees and max transaction amount
790     mapping (address => bool) private _isExcludedFromFees;
791     mapping (address => bool) public _isExcludedMaxTransactionAmount;
792  
793     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
794     // could be subject to a maximum transfer amount
795     mapping (address => bool) public automatedMarketMakerPairs;
796  
797     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
798  
799     event ExcludeFromFees(address indexed account, bool isExcluded);
800  
801     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
802  
803     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
804  
805     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
806  
807     event SwapAndLiquify(
808         uint256 tokensSwapped,
809         uint256 ethReceived,
810         uint256 tokensIntoLiquidity
811     );
812  
813     event AutoNukeLP();
814  
815     event ManualNukeLP();
816  
817     constructor() ERC20("Chupacabra", "CHUPA") {
818  
819         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
820  
821         excludeFromMaxTransaction(address(_uniswapV2Router), true);
822         uniswapV2Router = _uniswapV2Router;
823  
824         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
825         excludeFromMaxTransaction(address(uniswapV2Pair), true);
826         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
827  
828         // tax is higher at launch to prevent from bot attack, final tax will be 1/2
829         uint256 _buyMarketingFee = 10;
830         uint256 _buyLiquidityFee = 0;
831         uint256 _buyDevFee = 5;
832         
833         uint256 _sellMarketingFee = 15;
834         uint256 _sellLiquidityFee = 0;
835         uint256 _sellDevFee = 15;
836 
837         uint256 _feeDenominator = 100;
838  
839         uint256 totalSupply = 100_000_00 * 1e18;
840  
841         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
842         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
843         swapTokensAtAmount = totalSupply * 3 / 10000; // 0.03% swap wallet
844 
845         feeDenominator = _feeDenominator;
846  
847         buyMarketingFee = _buyMarketingFee;
848         buyLiquidityFee = _buyLiquidityFee;
849         buyDevFee = _buyDevFee;
850         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
851  
852         sellMarketingFee = _sellMarketingFee;
853         sellLiquidityFee = _sellLiquidityFee;
854         sellDevFee = _sellDevFee;
855         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
856  
857         marketingWallet = address(0x34d3094F543d597Cb06c2445771e0589CFf4f03F); // set as marketing wallet
858         devWallet = address(0x34d3094F543d597Cb06c2445771e0589CFf4f03F); // set as dev wallet
859  
860         // exclude from paying fees or having max transaction amount
861         excludeFromFees(owner(), true);
862         excludeFromFees(devWallet, true);
863         excludeFromFees(address(this), true);
864         excludeFromFees(address(0xdead), true);
865  
866         excludeFromMaxTransaction(owner(), true);
867         excludeFromMaxTransaction(devWallet, true);
868         excludeFromMaxTransaction(address(this), true);
869         excludeFromMaxTransaction(address(0xdead), true);
870  
871         /*
872             _mint is an internal function in ERC20.sol that is only called here,
873             and CANNOT be called ever again
874         */
875         _mint(msg.sender, totalSupply);
876     }
877  
878     receive() external payable {
879  
880   	}
881  
882     // once enabled, can never be turned off
883     function enableTrading() external onlyOwner {
884         tradingActive = true;
885         swapEnabled = true;
886         launchedAt = block.number;
887     }
888  
889     // remove limits after token is stable
890     function removeLimits() external onlyOwner returns (bool){
891         limitsInEffect = false;
892         return true;
893     }
894  
895     // disable Transfer delay - cannot be reenabled
896     function disableTransferDelay() external onlyOwner returns (bool){
897         transferDelayEnabled = false;
898         return true;
899     }
900  
901      // change the minimum amount of tokens to sell from fees
902     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
903   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
904   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
905   	    swapTokensAtAmount = newAmount;
906   	    return true;
907   	}
908  
909     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
910         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
911         maxTransactionAmount = newNum * (10**18);
912     }
913  
914     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
915         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
916         maxWallet = newNum * (10**18);
917     }
918  
919     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
920         _isExcludedMaxTransactionAmount[updAds] = isEx;
921     }
922  
923     // only use to disable contract sales if absolutely necessary (emergency use only)
924     function updateSwapEnabled(bool enabled) external onlyOwner(){
925         swapEnabled = enabled;
926     }
927  
928     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
929         buyMarketingFee = _marketingFee;
930         buyLiquidityFee = _liquidityFee;
931         buyDevFee = _devFee;
932         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
933         require(buyTotalFees.div(feeDenominator) <= 10, "Must keep fees at 10% or less");
934     }
935  
936     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
937         sellMarketingFee = _marketingFee;
938         sellLiquidityFee = _liquidityFee;
939         sellDevFee = _devFee;
940         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
941         require(sellTotalFees.div(feeDenominator) <= 20, "Must keep fees at 20% or less");
942     }
943  
944     function excludeFromFees(address account, bool excluded) public onlyOwner {
945         _isExcludedFromFees[account] = excluded;
946         emit ExcludeFromFees(account, excluded);
947     }
948  
949     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
950         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
951  
952         _setAutomatedMarketMakerPair(pair, value);
953     }
954  
955     function _setAutomatedMarketMakerPair(address pair, bool value) private {
956         automatedMarketMakerPairs[pair] = value;
957  
958         emit SetAutomatedMarketMakerPair(pair, value);
959     }
960  
961     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
962         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
963         marketingWallet = newMarketingWallet;
964     }
965  
966     function updateDevWallet(address newWallet) external onlyOwner {
967         emit devWalletUpdated(newWallet, devWallet);
968         devWallet = newWallet;
969     }
970 
971     function isExcludedFromFees(address account) public view returns(bool) {
972         return _isExcludedFromFees[account];
973     }
974  
975     function _transfer(
976         address from,
977         address to,
978         uint256 amount
979     ) internal override {
980         require(from != address(0), "ERC20: transfer from the zero address");
981         require(to != address(0), "ERC20: transfer to the zero address");
982         if(amount == 0) {
983             super._transfer(from, to, 0);
984             return;
985         }
986  
987         if(limitsInEffect){
988             if (
989                 from != owner() &&
990                 to != owner() &&
991                 to != address(0) &&
992                 to != address(0xdead) &&
993                 !swapping
994             ){
995                 if(!tradingActive){
996                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
997                 }
998  
999                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1000                 if (transferDelayEnabled) {
1001                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1002                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled. Only one purchase per block allowed.");
1003                         _holderLastTransferTimestamp[tx.origin] = block.number;
1004                     }
1005                 }
1006  
1007                 //when buy
1008                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1009                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1010                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1011                 }
1012  
1013                 //when sell
1014                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1015                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1016                 }
1017                 else if(!_isExcludedMaxTransactionAmount[to]){
1018                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1019                 }
1020             }
1021         }
1022  
1023 		uint256 contractTokenBalance = balanceOf(address(this));
1024  
1025         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1026  
1027         if( 
1028             canSwap &&
1029             swapEnabled &&
1030             !swapping &&
1031             !automatedMarketMakerPairs[from] &&
1032             !_isExcludedFromFees[from] &&
1033             !_isExcludedFromFees[to]
1034         ) {
1035             swapping = true;
1036  
1037             swapBack();
1038  
1039             swapping = false;
1040         }
1041  
1042         bool takeFee = !swapping;
1043  
1044         // if any account belongs to _isExcludedFromFee account then remove the fee
1045         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1046             takeFee = false;
1047         }
1048  
1049         uint256 fees = 0;
1050         // only take fees on buys/sells, do not take on wallet transfers
1051         if(takeFee){
1052             // on sell
1053             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1054                 fees = amount.mul(sellTotalFees).div(feeDenominator);
1055                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1056                 tokensForDev += fees * sellDevFee / sellTotalFees;
1057                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1058             }
1059             // on buy
1060             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1061         	    fees = amount.mul(buyTotalFees).div(feeDenominator);
1062         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1063                 tokensForDev += fees * buyDevFee / buyTotalFees;
1064                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1065             }
1066  
1067             if(fees > 0){    
1068                 super._transfer(from, address(this), fees);
1069             }
1070  
1071         	amount -= fees;
1072         }
1073  
1074         super._transfer(from, to, amount);
1075     }
1076  
1077     function swapTokensForEth(uint256 tokenAmount) private {
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
1093     }
1094  
1095     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1096         // approve token transfer to cover all possible scenarios
1097         _approve(address(this), address(uniswapV2Router), tokenAmount);
1098  
1099         // add the liquidity
1100         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1101             address(this),
1102             tokenAmount,
1103             0, // slippage is unavoidable
1104             0, // slippage is unavoidable
1105             deadAddress,
1106             block.timestamp
1107         );
1108     }
1109  
1110     function swapBack() private {
1111         uint256 contractBalance = balanceOf(address(this));
1112         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1113         bool success;
1114  
1115         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1116  
1117         if(contractBalance > swapTokensAtAmount * 20){
1118           contractBalance = swapTokensAtAmount * 20;
1119         }
1120  
1121         // Halve the amount of liquidity tokens
1122         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1123         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1124  
1125         uint256 initialETHBalance = address(this).balance;
1126  
1127         swapTokensForEth(amountToSwapForETH); 
1128  
1129         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1130  
1131         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1132         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1133  
1134         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1135  
1136         tokensForLiquidity = 0;
1137         tokensForMarketing = 0;
1138         tokensForDev = 0;
1139  
1140         (success,) = address(devWallet).call{value: ethForDev}("");
1141  
1142         if(liquidityTokens > 0 && ethForLiquidity > 0){
1143             addLiquidity(liquidityTokens, ethForLiquidity);
1144             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1145         }
1146  
1147         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1148     }
1149 }