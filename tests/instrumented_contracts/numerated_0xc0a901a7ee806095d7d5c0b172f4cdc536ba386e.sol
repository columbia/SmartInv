1 /**
2 
3 Safe Hunters Dream - $SCAW
4 
5 A True Manifesto on a Safe Decentralized Social Clearing House.... ( AKA ) SCAW
6 
7 TG: https://t.me/safecaw
8 Twitter: https://twitter.com/safecaw
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13  
14 pragma solidity 0.8.17;
15  
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20  
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26  
27 interface IUniswapV2Pair {
28     event Approval(address indexed owner, address indexed spender, uint value);
29     event Transfer(address indexed from, address indexed to, uint value);
30  
31     function name() external pure returns (string memory);
32     function symbol() external pure returns (string memory);
33     function decimals() external pure returns (uint8);
34     function totalSupply() external view returns (uint);
35     function balanceOf(address owner) external view returns (uint);
36     function allowance(address owner, address spender) external view returns (uint);
37  
38     function approve(address spender, uint value) external returns (bool);
39     function transfer(address to, uint value) external returns (bool);
40     function transferFrom(address from, address to, uint value) external returns (bool);
41  
42     function DOMAIN_SEPARATOR() external view returns (bytes32);
43     function PERMIT_TYPEHASH() external pure returns (bytes32);
44     function nonces(address owner) external view returns (uint);
45  
46     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
47  
48     event Mint(address indexed sender, uint amount0, uint amount1);
49     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
50     event Swap(
51         address indexed sender,
52         uint amount0In,
53         uint amount1In,
54         uint amount0Out,
55         uint amount1Out,
56         address indexed to
57     );
58     event Sync(uint112 reserve0, uint112 reserve1);
59  
60     function MINIMUM_LIQUIDITY() external pure returns (uint);
61     function factory() external view returns (address);
62     function token0() external view returns (address);
63     function token1() external view returns (address);
64     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
65     function price0CumulativeLast() external view returns (uint);
66     function price1CumulativeLast() external view returns (uint);
67     function kLast() external view returns (uint);
68  
69     function mint(address to) external returns (uint liquidity);
70     function burn(address to) external returns (uint amount0, uint amount1);
71     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
72     function skim(address to) external;
73     function sync() external;
74  
75     function initialize(address, address) external;
76 }
77  
78 interface IUniswapV2Factory {
79     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
80  
81     function feeTo() external view returns (address);
82     function feeToSetter() external view returns (address);
83  
84     function getPair(address tokenA, address tokenB) external view returns (address pair);
85     function allPairs(uint) external view returns (address pair);
86     function allPairsLength() external view returns (uint);
87  
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89  
90     function setFeeTo(address) external;
91     function setFeeToSetter(address) external;
92 }
93  
94 interface IERC20 {
95     /**
96      * @dev Returns the amount of tokens in existence.
97      */
98     function totalSupply() external view returns (uint256);
99  
100     /**
101      * @dev Returns the amount of tokens owned by `account`.
102      */
103     function balanceOf(address account) external view returns (uint256);
104  
105     /**
106      * @dev Moves `amount` tokens from the caller's account to `recipient`.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transfer(address recipient, uint256 amount) external returns (bool);
113  
114     /**
115      * @dev Returns the remaining number of tokens that `spender` will be
116      * allowed to spend on behalf of `owner` through {transferFrom}. This is
117      * zero by default.
118      *
119      * This value changes when {approve} or {transferFrom} are called.
120      */
121     function allowance(address owner, address spender) external view returns (uint256);
122  
123     /**
124      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * IMPORTANT: Beware that changing an allowance with this method brings the risk
129      * that someone may use both the old and the new allowance by unfortunate
130      * transaction ordering. One possible solution to mitigate this race
131      * condition is to first reduce the spender's allowance to 0 and set the
132      * desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address spender, uint256 amount) external returns (bool);
138  
139     /**
140      * @dev Moves `amount` tokens from `sender` to `recipient` using the
141      * allowance mechanism. `amount` is then deducted from the caller's
142      * allowance.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transferFrom(
149         address sender,
150         address recipient,
151         uint256 amount
152     ) external returns (bool);
153  
154     /**
155      * @dev Emitted when `value` tokens are moved from one account (`from`) to
156      * another (`to`).
157      *
158      * Note that `value` may be zero.
159      */
160     event Transfer(address indexed from, address indexed to, uint256 value);
161  
162     /**
163      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
164      * a call to {approve}. `value` is the new allowance.
165      */
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168  
169 interface IERC20Metadata is IERC20 {
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() external view returns (string memory);
174  
175     /**
176      * @dev Returns the symbol of the token.
177      */
178     function symbol() external view returns (string memory);
179  
180     /**
181      * @dev Returns the decimals places of the token.
182      */
183     function decimals() external view returns (uint8);
184 }
185  
186  
187 contract ERC20 is Context, IERC20, IERC20Metadata {
188     using SafeMath for uint256;
189  
190     mapping(address => uint256) private _balances;
191  
192     mapping(address => mapping(address => uint256)) private _allowances;
193  
194     uint256 private _totalSupply;
195  
196     string private _name;
197     string private _symbol;
198  
199     /**
200      * @dev Sets the values for {name} and {symbol}.
201      *
202      * The default value of {decimals} is 18. To select a different value for
203      * {decimals} you should overload it.
204      *
205      * All two of these values are immutable: they can only be set once during
206      * construction.
207      */
208     constructor(string memory name_, string memory symbol_) {
209         _name = name_;
210         _symbol = symbol_;
211     }
212  
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() public view virtual override returns (string memory) {
217         return _name;
218     }
219  
220     /**
221      * @dev Returns the symbol of the token, usually a shorter version of the
222      * name.
223      */
224     function symbol() public view virtual override returns (string memory) {
225         return _symbol;
226     }
227  
228     /**
229      * @dev Returns the number of decimals used to get its user representation.
230      * For example, if `decimals` equals `2`, a balance of `505` tokens should
231      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
232      *
233      * Tokens usually opt for a value of 18, imitating the relationship between
234      * Ether and Wei. This is the value {ERC20} uses, unless this function is
235      * overridden;
236      *
237      * NOTE: This information is only used for _display_ purposes: it in
238      * no way affects any of the arithmetic of the contract, including
239      * {IERC20-balanceOf} and {IERC20-transfer}.
240      */
241     function decimals() public view virtual override returns (uint8) {
242         return 18;
243     }
244  
245     /**
246      * @dev See {IERC20-totalSupply}.
247      */
248     function totalSupply() public view virtual override returns (uint256) {
249         return _totalSupply;
250     }
251  
252     /**
253      * @dev See {IERC20-balanceOf}.
254      */
255     function balanceOf(address account) public view virtual override returns (uint256) {
256         return _balances[account];
257     }
258  
259     /**
260      * @dev See {IERC20-transfer}.
261      *
262      * Requirements:
263      *
264      * - `recipient` cannot be the zero address.
265      * - the caller must have a balance of at least `amount`.
266      */
267     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
268         _transfer(_msgSender(), recipient, amount);
269         return true;
270     }
271  
272     /**
273      * @dev See {IERC20-allowance}.
274      */
275     function allowance(address owner, address spender) public view virtual override returns (uint256) {
276         return _allowances[owner][spender];
277     }
278  
279     /**
280      * @dev See {IERC20-approve}.
281      *
282      * Requirements:
283      *
284      * - `spender` cannot be the zero address.
285      */
286     function approve(address spender, uint256 amount) public virtual override returns (bool) {
287         _approve(_msgSender(), spender, amount);
288         return true;
289     }
290  
291     /**
292      * @dev See {IERC20-transferFrom}.
293      *
294      * Emits an {Approval} event indicating the updated allowance. This is not
295      * required by the EIP. See the note at the beginning of {ERC20}.
296      *
297      * Requirements:
298      *
299      * - `sender` and `recipient` cannot be the zero address.
300      * - `sender` must have a balance of at least `amount`.
301      * - the caller must have allowance for ``sender``'s tokens of at least
302      * `amount`.
303      */
304     function transferFrom(
305         address sender,
306         address recipient,
307         uint256 amount
308     ) public virtual override returns (bool) {
309         _transfer(sender, recipient, amount);
310         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
311         return true;
312     }
313  
314     /**
315      * @dev Atomically increases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to {approve} that can be used as a mitigation for
318      * problems described in {IERC20-approve}.
319      *
320      * Emits an {Approval} event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      */
326     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
327         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
328         return true;
329     }
330  
331     /**
332      * @dev Atomically decreases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      * - `spender` must have allowance for the caller of at least
343      * `subtractedValue`.
344      */
345     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
347         return true;
348     }
349  
350     /**
351      * @dev Moves tokens `amount` from `sender` to `recipient`.
352      *
353      * This is internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `sender` cannot be the zero address.
361      * - `recipient` cannot be the zero address.
362      * - `sender` must have a balance of at least `amount`.
363      */
364     function _transfer(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) internal virtual {
369         require(sender != address(0), "ERC20: transfer from the zero address");
370         require(recipient != address(0), "ERC20: transfer to the zero address");
371  
372         _beforeTokenTransfer(sender, recipient, amount);
373  
374         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
375         _balances[recipient] = _balances[recipient].add(amount);
376         emit Transfer(sender, recipient, amount);
377     }
378  
379     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
380      * the total supply.
381      *
382      * Emits a {Transfer} event with `from` set to the zero address.
383      *
384      * Requirements:
385      *
386      * - `account` cannot be the zero address.
387      */
388     function _mint(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: mint to the zero address");
390  
391         _beforeTokenTransfer(address(0), account, amount);
392  
393         _totalSupply = _totalSupply.add(amount);
394         _balances[account] = _balances[account].add(amount);
395         emit Transfer(address(0), account, amount);
396     }
397  
398     /**
399      * @dev Destroys `amount` tokens from `account`, reducing the
400      * total supply.
401      *
402      * Emits a {Transfer} event with `to` set to the zero address.
403      *
404      * Requirements:
405      *
406      * - `account` cannot be the zero address.
407      * - `account` must have at least `amount` tokens.
408      */
409     function _burn(address account, uint256 amount) internal virtual {
410         require(account != address(0), "ERC20: burn from the zero address");
411  
412         _beforeTokenTransfer(account, address(0), amount);
413  
414         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
415         _totalSupply = _totalSupply.sub(amount);
416         emit Transfer(account, address(0), amount);
417     }
418  
419     /**
420      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
421      *
422      * This internal function is equivalent to `approve`, and can be used to
423      * e.g. set automatic allowances for certain subsystems, etc.
424      *
425      * Emits an {Approval} event.
426      *
427      * Requirements:
428      *
429      * - `owner` cannot be the zero address.
430      * - `spender` cannot be the zero address.
431      */
432     function _approve(
433         address owner,
434         address spender,
435         uint256 amount
436     ) internal virtual {
437         require(owner != address(0), "ERC20: approve from the zero address");
438         require(spender != address(0), "ERC20: approve to the zero address");
439  
440         _allowances[owner][spender] = amount;
441         emit Approval(owner, spender, amount);
442     }
443  
444     /**
445      * @dev Hook that is called before any transfer of tokens. This includes
446      * minting and burning.
447      *
448      * Calling conditions:
449      *
450      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
451      * will be to transferred to `to`.
452      * - when `from` is zero, `amount` tokens will be minted for `to`.
453      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
454      * - `from` and `to` are never both zero.
455      *
456      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
457      */
458     function _beforeTokenTransfer(
459         address from,
460         address to,
461         uint256 amount
462     ) internal virtual {}
463 }
464  
465 library SafeMath {
466     function add(uint256 a, uint256 b) internal pure returns (uint256) {
467         uint256 c = a + b;
468         require(c >= a, "SafeMath: addition overflow");
469  
470         return c;
471     }
472 
473     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
474         return sub(a, b, "SafeMath: subtraction overflow");
475     }
476 
477     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
478         require(b <= a, errorMessage);
479         uint256 c = a - b;
480  
481         return c;
482     }
483 
484     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
485         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
486         // benefit is lost if 'b' is also tested.
487         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
488         if (a == 0) {
489             return 0;
490         }
491  
492         uint256 c = a * b;
493         require(c / a == b, "SafeMath: multiplication overflow");
494  
495         return c;
496     }
497 
498     function div(uint256 a, uint256 b) internal pure returns (uint256) {
499         return div(a, b, "SafeMath: division by zero");
500     }
501 
502     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b > 0, errorMessage);
504         uint256 c = a / b;
505 
506         return c;
507     }
508 
509     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
510         return mod(a, b, "SafeMath: modulo by zero");
511     }
512 
513     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
514         require(b != 0, errorMessage);
515         return a % b;
516     }
517 }
518  
519 contract Ownable is Context {
520     address private _owner;
521  
522     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
523  
524     constructor () {
525         address msgSender = _msgSender();
526         _owner = msgSender;
527         emit OwnershipTransferred(address(0), msgSender);
528     }
529 
530     function owner() public view returns (address) {
531         return _owner;
532     }
533  
534     modifier onlyOwner() {
535         require(_owner == _msgSender(), "Ownable: caller is not the owner");
536         _;
537     }
538  
539     function renounceOwnership() public virtual onlyOwner {
540         emit OwnershipTransferred(_owner, address(0));
541         _owner = address(0);
542     }
543 
544     function transferOwnership(address newOwner) public virtual onlyOwner {
545         require(newOwner != address(0), "Ownable: new owner is the zero address");
546         emit OwnershipTransferred(_owner, newOwner);
547         _owner = newOwner;
548     }
549 }
550  
551  
552 
553 library SafeMathInt {
554     int256 private constant MIN_INT256 = int256(1) << 255;
555     int256 private constant MAX_INT256 = ~(int256(1) << 255);
556  
557     function mul(int256 a, int256 b) internal pure returns (int256) {
558         int256 c = a * b;
559  
560         // Detect overflow when multiplying MIN_INT256 with -1
561         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
562         require((b == 0) || (c / b == a));
563         return c;
564     }
565  
566     function div(int256 a, int256 b) internal pure returns (int256) {
567         // Prevent overflow when dividing MIN_INT256 by -1
568         require(b != -1 || a != MIN_INT256);
569  
570         // Solidity already throws when dividing by 0.
571         return a / b;
572     }
573  
574     function sub(int256 a, int256 b) internal pure returns (int256) {
575         int256 c = a - b;
576         require((b >= 0 && c <= a) || (b < 0 && c > a));
577         return c;
578     }
579  
580     function add(int256 a, int256 b) internal pure returns (int256) {
581         int256 c = a + b;
582         require((b >= 0 && c >= a) || (b < 0 && c < a));
583         return c;
584     }
585  
586     function abs(int256 a) internal pure returns (int256) {
587         require(a != MIN_INT256);
588         return a < 0 ? -a : a;
589     }
590  
591  
592     function toUint256Safe(int256 a) internal pure returns (uint256) {
593         require(a >= 0);
594         return uint256(a);
595     }
596 }
597  
598 library SafeMathUint {
599   function toInt256Safe(uint256 a) internal pure returns (int256) {
600     int256 b = int256(a);
601     require(b >= 0);
602     return b;
603   }
604 }
605  
606  
607 interface IUniswapV2Router01 {
608     function factory() external pure returns (address);
609     function WETH() external pure returns (address);
610  
611     function addLiquidity(
612         address tokenA,
613         address tokenB,
614         uint amountADesired,
615         uint amountBDesired,
616         uint amountAMin,
617         uint amountBMin,
618         address to,
619         uint deadline
620     ) external returns (uint amountA, uint amountB, uint liquidity);
621     function addLiquidityETH(
622         address token,
623         uint amountTokenDesired,
624         uint amountTokenMin,
625         uint amountETHMin,
626         address to,
627         uint deadline
628     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
629     function removeLiquidity(
630         address tokenA,
631         address tokenB,
632         uint liquidity,
633         uint amountAMin,
634         uint amountBMin,
635         address to,
636         uint deadline
637     ) external returns (uint amountA, uint amountB);
638     function removeLiquidityETH(
639         address token,
640         uint liquidity,
641         uint amountTokenMin,
642         uint amountETHMin,
643         address to,
644         uint deadline
645     ) external returns (uint amountToken, uint amountETH);
646     function removeLiquidityWithPermit(
647         address tokenA,
648         address tokenB,
649         uint liquidity,
650         uint amountAMin,
651         uint amountBMin,
652         address to,
653         uint deadline,
654         bool approveMax, uint8 v, bytes32 r, bytes32 s
655     ) external returns (uint amountA, uint amountB);
656     function removeLiquidityETHWithPermit(
657         address token,
658         uint liquidity,
659         uint amountTokenMin,
660         uint amountETHMin,
661         address to,
662         uint deadline,
663         bool approveMax, uint8 v, bytes32 r, bytes32 s
664     ) external returns (uint amountToken, uint amountETH);
665     function swapExactTokensForTokens(
666         uint amountIn,
667         uint amountOutMin,
668         address[] calldata path,
669         address to,
670         uint deadline
671     ) external returns (uint[] memory amounts);
672     function swapTokensForExactTokens(
673         uint amountOut,
674         uint amountInMax,
675         address[] calldata path,
676         address to,
677         uint deadline
678     ) external returns (uint[] memory amounts);
679     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
680         external
681         payable
682         returns (uint[] memory amounts);
683     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
684         external
685         returns (uint[] memory amounts);
686     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
687         external
688         returns (uint[] memory amounts);
689     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
690         external
691         payable
692         returns (uint[] memory amounts);
693  
694     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
695     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
696     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
697     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
698     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
699 }
700  
701 interface IUniswapV2Router02 is IUniswapV2Router01 {
702     function removeLiquidityETHSupportingFeeOnTransferTokens(
703         address token,
704         uint liquidity,
705         uint amountTokenMin,
706         uint amountETHMin,
707         address to,
708         uint deadline
709     ) external returns (uint amountETH);
710     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
711         address token,
712         uint liquidity,
713         uint amountTokenMin,
714         uint amountETHMin,
715         address to,
716         uint deadline,
717         bool approveMax, uint8 v, bytes32 r, bytes32 s
718     ) external returns (uint amountETH);
719  
720     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
721         uint amountIn,
722         uint amountOutMin,
723         address[] calldata path,
724         address to,
725         uint deadline
726     ) external;
727     function swapExactETHForTokensSupportingFeeOnTransferTokens(
728         uint amountOutMin,
729         address[] calldata path,
730         address to,
731         uint deadline
732     ) external payable;
733     function swapExactTokensForETHSupportingFeeOnTransferTokens(
734         uint amountIn,
735         uint amountOutMin,
736         address[] calldata path,
737         address to,
738         uint deadline
739     ) external;
740 }
741  
742 contract SafeHuntersDream is ERC20, Ownable {
743     using SafeMath for uint256;
744  
745     IUniswapV2Router02 public immutable uniswapV2Router;
746     address public immutable uniswapV2Pair;
747     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
748  
749     bool private swapping;
750  
751     address public marketingWallet;
752     address public devWallet;
753  
754     uint256 public maxTransactionAmount;
755     uint256 public swapTokensAtAmount;
756     uint256 public maxWallet;
757  
758     bool public limitsInEffect = true;
759     bool public tradingActive = false;
760     bool public swapEnabled = false;
761  
762      // Anti-bot and anti-whale mappings and variables
763     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
764  
765     // Seller Map
766     mapping (address => uint256) private _holderFirstBuyTimestamp;
767  
768     bool public transferDelayEnabled = true;
769  
770     uint256 public buyTotalFees;
771     uint256 public buyMarketingFee;
772     uint256 public buyLiquidityFee;
773     uint256 public buyDevFee;
774  
775     uint256 public sellTotalFees;
776     uint256 public sellMarketingFee;
777     uint256 public sellLiquidityFee;
778     uint256 public sellDevFee;
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
817     constructor() ERC20("Safe Hunters Dream", "SCAW") {
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
828         uint256 _buyMarketingFee = 0;
829         uint256 _buyLiquidityFee = 0;
830         uint256 _buyDevFee = 0;
831  
832         uint256 _sellMarketingFee = 0;
833         uint256 _sellLiquidityFee = 0;
834         uint256 _sellDevFee = 0;
835  
836         uint256 totalSupply = 666_666_666_666_666 * 1e18;
837  
838         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
839         maxWallet = totalSupply * 30 / 1000; // 3% maxWallet
840         swapTokensAtAmount = totalSupply * 1 / 1000; // 0.1% swap wallet
841  
842         buyMarketingFee = _buyMarketingFee;
843         buyLiquidityFee = _buyLiquidityFee;
844         buyDevFee = _buyDevFee;
845         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
846  
847         sellMarketingFee = _sellMarketingFee;
848         sellLiquidityFee = _sellLiquidityFee;
849         sellDevFee = _sellDevFee;
850         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
851  
852         marketingWallet = address(owner()); // set as marketing wallet
853         devWallet = address(owner()); // set as dev wallet
854  
855         // exclude from paying fees or having max transaction amount
856         excludeFromFees(owner(), true);
857         excludeFromFees(devWallet, true);
858         excludeFromFees(address(this), true);
859         excludeFromFees(address(0xdead), true);
860  
861         excludeFromMaxTransaction(owner(), true);
862         excludeFromMaxTransaction(devWallet, true);
863         excludeFromMaxTransaction(address(this), true);
864         excludeFromMaxTransaction(address(0xdead), true);
865  
866         /*
867             _mint is an internal function in ERC20.sol that is only called here,
868             and CANNOT be called ever again
869         */
870         _mint(msg.sender, totalSupply);
871     }
872  
873     receive() external payable {
874  
875   	}
876  
877     // once enabled, can never be turned off
878     function enableTrading() external onlyOwner {
879         tradingActive = true;
880         swapEnabled = true;
881         launchedAt = block.number;
882     }
883  
884     // remove limits after token is stable
885     function removeLimits() external onlyOwner returns (bool){
886         limitsInEffect = false;
887         return true;
888     }
889  
890     // disable Transfer delay - cannot be reenabled
891     function disableTransferDelay() external onlyOwner returns (bool){
892         transferDelayEnabled = false;
893         return true;
894     }
895  
896      // change the minimum amount of tokens to sell from fees
897     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
898   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
899   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
900   	    swapTokensAtAmount = newAmount;
901   	    return true;
902   	}
903  
904     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
905         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
906         maxTransactionAmount = newNum * (10**18);
907     }
908  
909     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
910         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
911         maxWallet = newNum * (10**18);
912     }
913  
914     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
915         _isExcludedMaxTransactionAmount[updAds] = isEx;
916     }
917  
918     // only use to disable contract sales if absolutely necessary (emergency use only)
919     function updateSwapEnabled(bool enabled) external onlyOwner(){
920         swapEnabled = enabled;
921     }
922  
923     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
924         buyMarketingFee = _marketingFee;
925         buyLiquidityFee = _liquidityFee;
926         buyDevFee = _devFee;
927         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
928         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
929     }
930  
931     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
932         sellMarketingFee = _marketingFee;
933         sellLiquidityFee = _liquidityFee;
934         sellDevFee = _devFee;
935         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
936         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
937     }
938  
939     function excludeFromFees(address account, bool excluded) public onlyOwner {
940         _isExcludedFromFees[account] = excluded;
941         emit ExcludeFromFees(account, excluded);
942     }
943  
944     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
945         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
946  
947         _setAutomatedMarketMakerPair(pair, value);
948     }
949  
950     function _setAutomatedMarketMakerPair(address pair, bool value) private {
951         automatedMarketMakerPairs[pair] = value;
952  
953         emit SetAutomatedMarketMakerPair(pair, value);
954     }
955  
956     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
957         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
958         marketingWallet = newMarketingWallet;
959     }
960  
961     function updateDevWallet(address newWallet) external onlyOwner {
962         emit devWalletUpdated(newWallet, devWallet);
963         devWallet = newWallet;
964     }
965 
966     function isExcludedFromFees(address account) public view returns(bool) {
967         return _isExcludedFromFees[account];
968     }
969  
970     function _transfer(
971         address from,
972         address to,
973         uint256 amount
974     ) internal override {
975         require(from != address(0), "ERC20: transfer from the zero address");
976         require(to != address(0), "ERC20: transfer to the zero address");
977          if(amount == 0) {
978             super._transfer(from, to, 0);
979             return;
980         }
981  
982         if(limitsInEffect){
983             if (
984                 from != owner() &&
985                 to != owner() &&
986                 to != address(0) &&
987                 to != address(0xdead) &&
988                 !swapping
989             ){
990                 if(!tradingActive){
991                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
992                 }
993  
994                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
995                 if (transferDelayEnabled){
996                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
997                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled. Only one purchase per block allowed.");
998                         _holderLastTransferTimestamp[tx.origin] = block.number;
999                     }
1000                 }
1001  
1002                 //when buy
1003                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1004                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1005                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1006                 }
1007  
1008                 //when sell
1009                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1010                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1011                 }
1012                 else if(!_isExcludedMaxTransactionAmount[to]){
1013                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1014                 }
1015             }
1016         }
1017  
1018 		uint256 contractTokenBalance = balanceOf(address(this));
1019  
1020         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1021  
1022         if( 
1023             canSwap &&
1024             swapEnabled &&
1025             !swapping &&
1026             !automatedMarketMakerPairs[from] &&
1027             !_isExcludedFromFees[from] &&
1028             !_isExcludedFromFees[to]
1029         ) {
1030             swapping = true;
1031  
1032             swapBack();
1033  
1034             swapping = false;
1035         }
1036  
1037         bool takeFee = !swapping;
1038  
1039         // if any account belongs to _isExcludedFromFee account then remove the fee
1040         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1041             takeFee = false;
1042         }
1043  
1044         uint256 fees = 0;
1045         // only take fees on buys/sells, do not take on wallet transfers
1046         if(takeFee){
1047             // on sell
1048             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1049                 fees = amount.mul(sellTotalFees).div(100);
1050                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1051                 tokensForDev += fees * sellDevFee / sellTotalFees;
1052                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1053             }
1054             // on buy
1055             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1056         	    fees = amount.mul(buyTotalFees).div(100);
1057         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1058                 tokensForDev += fees * buyDevFee / buyTotalFees;
1059                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1060             }
1061  
1062             if(fees > 0){    
1063                 super._transfer(from, address(this), fees);
1064             }
1065  
1066         	amount -= fees;
1067         }
1068  
1069         super._transfer(from, to, amount);
1070     }
1071  
1072     function swapTokensForEth(uint256 tokenAmount) private {
1073  
1074         // generate the uniswap pair path of token -> weth
1075         address[] memory path = new address[](2);
1076         path[0] = address(this);
1077         path[1] = uniswapV2Router.WETH();
1078  
1079         _approve(address(this), address(uniswapV2Router), tokenAmount);
1080  
1081         // make the swap
1082         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1083             tokenAmount,
1084             0, // accept any amount of ETH
1085             path,
1086             address(this),
1087             block.timestamp
1088         );
1089  
1090     }
1091  
1092     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1093         // approve token transfer to cover all possible scenarios
1094         _approve(address(this), address(uniswapV2Router), tokenAmount);
1095  
1096         // add the liquidity
1097         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1098             address(this),
1099             tokenAmount,
1100             0, // slippage is unavoidable
1101             0, // slippage is unavoidable
1102             deadAddress,
1103             block.timestamp
1104         );
1105     }
1106  
1107     function swapBack() private {
1108         uint256 contractBalance = balanceOf(address(this));
1109         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1110         bool success;
1111  
1112         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1113  
1114         if(contractBalance > swapTokensAtAmount * 20){
1115           contractBalance = swapTokensAtAmount * 20;
1116         }
1117  
1118         // Halve the amount of liquidity tokens
1119         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1120         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1121  
1122         uint256 initialETHBalance = address(this).balance;
1123  
1124         swapTokensForEth(amountToSwapForETH); 
1125  
1126         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1127  
1128         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1129         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1130  
1131  
1132         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1133  
1134  
1135         tokensForLiquidity = 0;
1136         tokensForMarketing = 0;
1137         tokensForDev = 0;
1138  
1139         (success,) = address(devWallet).call{value: ethForDev}("");
1140  
1141         if(liquidityTokens > 0 && ethForLiquidity > 0){
1142             addLiquidity(liquidityTokens, ethForLiquidity);
1143             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1144         }
1145  
1146         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1147     }
1148 }