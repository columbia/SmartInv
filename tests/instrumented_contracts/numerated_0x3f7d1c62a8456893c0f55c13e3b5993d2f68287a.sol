1 /**
2  *Submitted for verification at Etherscan.io on 2023-05-04
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.19;
7  
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12  
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18  
19 interface IUniswapV2Pair {
20     event Approval(address indexed owner, address indexed spender, uint value);
21     event Transfer(address indexed from, address indexed to, uint value);
22  
23     function name() external pure returns (string memory);
24     function symbol() external pure returns (string memory);
25     function decimals() external pure returns (uint8);
26     function totalSupply() external view returns (uint);
27     function balanceOf(address owner) external view returns (uint);
28     function allowance(address owner, address spender) external view returns (uint);
29  
30     function approve(address spender, uint value) external returns (bool);
31     function transfer(address to, uint value) external returns (bool);
32     function transferFrom(address from, address to, uint value) external returns (bool);
33  
34     function DOMAIN_SEPARATOR() external view returns (bytes32);
35     function PERMIT_TYPEHASH() external pure returns (bytes32);
36     function nonces(address owner) external view returns (uint);
37  
38     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
39  
40     event Mint(address indexed sender, uint amount0, uint amount1);
41     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
42     event Swap(
43         address indexed sender,
44         uint amount0In,
45         uint amount1In,
46         uint amount0Out,
47         uint amount1Out,
48         address indexed to
49     );
50     event Sync(uint112 reserve0, uint112 reserve1);
51  
52     function MINIMUM_LIQUIDITY() external pure returns (uint);
53     function factory() external view returns (address);
54     function token0() external view returns (address);
55     function token1() external view returns (address);
56     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
57     function price0CumulativeLast() external view returns (uint);
58     function price1CumulativeLast() external view returns (uint);
59     function kLast() external view returns (uint);
60  
61     function mint(address to) external returns (uint liquidity);
62     function burn(address to) external returns (uint amount0, uint amount1);
63     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
64     function skim(address to) external;
65     function sync() external;
66  
67     function initialize(address, address) external;
68 }
69  
70 interface IUniswapV2Factory {
71     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
72  
73     function feeTo() external view returns (address);
74     function feeToSetter() external view returns (address);
75  
76     function getPair(address tokenA, address tokenB) external view returns (address pair);
77     function allPairs(uint) external view returns (address pair);
78     function allPairsLength() external view returns (uint);
79  
80     function createPair(address tokenA, address tokenB) external returns (address pair);
81  
82     function setFeeTo(address) external;
83     function setFeeToSetter(address) external;
84 }
85  
86 interface IERC20 {
87     /**
88      * @dev Returns the amount of tokens in existence.
89      */
90     function totalSupply() external view returns (uint256);
91  
92     /**
93      * @dev Returns the amount of tokens owned by `account`.
94      */
95     function balanceOf(address account) external view returns (uint256);
96  
97     /**
98      * @dev Moves `amount` tokens from the caller's account to `recipient`.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transfer(address recipient, uint256 amount) external returns (bool);
105  
106     /**
107      * @dev Returns the remaining number of tokens that `spender` will be
108      * allowed to spend on behalf of `owner` through {transferFrom}. This is
109      * zero by default.
110      *
111      * This value changes when {approve} or {transferFrom} are called.
112      */
113     function allowance(address owner, address spender) external view returns (uint256);
114  
115     /**
116      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * IMPORTANT: Beware that changing an allowance with this method brings the risk
121      * that someone may use both the old and the new allowance by unfortunate
122      * transaction ordering. One possible solution to mitigate this race
123      * condition is to first reduce the spender's allowance to 0 and set the
124      * desired value afterwards:
125      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address spender, uint256 amount) external returns (bool);
130  
131     /**
132      * @dev Moves `amount` tokens from `sender` to `recipient` using the
133      * allowance mechanism. `amount` is then deducted from the caller's
134      * allowance.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * Emits a {Transfer} event.
139      */
140     function transferFrom(
141         address sender,
142         address recipient,
143         uint256 amount
144     ) external returns (bool);
145  
146     /**
147      * @dev Emitted when `value` tokens are moved from one account (`from`) to
148      * another (`to`).
149      *
150      * Note that `value` may be zero.
151      */
152     event Transfer(address indexed from, address indexed to, uint256 value);
153  
154     /**
155      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
156      * a call to {approve}. `value` is the new allowance.
157      */
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160  
161 interface IERC20Metadata is IERC20 {
162     /**
163      * @dev Returns the name of the token.
164      */
165     function name() external view returns (string memory);
166  
167     /**
168      * @dev Returns the symbol of the token.
169      */
170     function symbol() external view returns (string memory);
171  
172     /**
173      * @dev Returns the decimals places of the token.
174      */
175     function decimals() external view returns (uint8);
176 }
177  
178  
179 contract ERC20 is Context, IERC20, IERC20Metadata {
180     using SafeMath for uint256;
181  
182     mapping(address => uint256) private _balances;
183  
184     mapping(address => mapping(address => uint256)) private _allowances;
185  
186     uint256 private _totalSupply;
187  
188     string private _name;
189     string private _symbol;
190  
191     /**
192      * @dev Sets the values for {name} and {symbol}.
193      *
194      * The default value of {decimals} is 18. To select a different value for
195      * {decimals} you should overload it.
196      *
197      * All two of these values are immutable: they can only be set once during
198      * construction.
199      */
200     constructor(string memory name_, string memory symbol_) {
201         _name = name_;
202         _symbol = symbol_;
203     }
204  
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() public view virtual override returns (string memory) {
209         return _name;
210     }
211  
212     /**
213      * @dev Returns the symbol of the token, usually a shorter version of the
214      * name.
215      */
216     function symbol() public view virtual override returns (string memory) {
217         return _symbol;
218     }
219  
220     /**
221      * @dev Returns the number of decimals used to get its user representation.
222      * For example, if `decimals` equals `2`, a balance of `505` tokens should
223      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
224      *
225      * Tokens usually opt for a value of 18, imitating the relationship between
226      * Ether and Wei. This is the value {ERC20} uses, unless this function is
227      * overridden;
228      *
229      * NOTE: This information is only used for _display_ purposes: it in
230      * no way affects any of the arithmetic of the contract, including
231      * {IERC20-balanceOf} and {IERC20-transfer}.
232      */
233     function decimals() public view virtual override returns (uint8) {
234         return 18;
235     }
236  
237     /**
238      * @dev See {IERC20-totalSupply}.
239      */
240     function totalSupply() public view virtual override returns (uint256) {
241         return _totalSupply;
242     }
243  
244     /**
245      * @dev See {IERC20-balanceOf}.
246      */
247     function balanceOf(address account) public view virtual override returns (uint256) {
248         return _balances[account];
249     }
250  
251     /**
252      * @dev See {IERC20-transfer}.
253      *
254      * Requirements:
255      *
256      * - `recipient` cannot be the zero address.
257      * - the caller must have a balance of at least `amount`.
258      */
259     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
260         _transfer(_msgSender(), recipient, amount);
261         return true;
262     }
263  
264     /**
265      * @dev See {IERC20-allowance}.
266      */
267     function allowance(address owner, address spender) public view virtual override returns (uint256) {
268         return _allowances[owner][spender];
269     }
270  
271     /**
272      * @dev See {IERC20-approve}.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      */
278     function approve(address spender, uint256 amount) public virtual override returns (bool) {
279         _approve(_msgSender(), spender, amount);
280         return true;
281     }
282  
283     /**
284      * @dev See {IERC20-transferFrom}.
285      *
286      * Emits an {Approval} event indicating the updated allowance. This is not
287      * required by the EIP. See the note at the beginning of {ERC20}.
288      *
289      * Requirements:
290      *
291      * - `sender` and `recipient` cannot be the zero address.
292      * - `sender` must have a balance of at least `amount`.
293      * - the caller must have allowance for ``sender``'s tokens of at least
294      * `amount`.
295      */
296     function transferFrom(
297         address sender,
298         address recipient,
299         uint256 amount
300     ) public virtual override returns (bool) {
301         _transfer(sender, recipient, amount);
302         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
303         return true;
304     }
305  
306     /**
307      * @dev Atomically increases the allowance granted to `spender` by the caller.
308      *
309      * This is an alternative to {approve} that can be used as a mitigation for
310      * problems described in {IERC20-approve}.
311      *
312      * Emits an {Approval} event indicating the updated allowance.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      */
318     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
319         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
320         return true;
321     }
322  
323     /**
324      * @dev Atomically decreases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      * - `spender` must have allowance for the caller of at least
335      * `subtractedValue`.
336      */
337     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
338         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
339         return true;
340     }
341  
342     /**
343      * @dev Moves tokens `amount` from `sender` to `recipient`.
344      *
345      * This is internal function is equivalent to {transfer}, and can be used to
346      * e.g. implement automatic token fees, slashing mechanisms, etc.
347      *
348      * Emits a {Transfer} event.
349      *
350      * Requirements:
351      *
352      * - `sender` cannot be the zero address.
353      * - `recipient` cannot be the zero address.
354      * - `sender` must have a balance of at least `amount`.
355      */
356     function _transfer(
357         address sender,
358         address recipient,
359         uint256 amount
360     ) internal virtual {
361         require(sender != address(0), "ERC20: transfer from the zero address");
362         require(recipient != address(0), "ERC20: transfer to the zero address");
363  
364         _beforeTokenTransfer(sender, recipient, amount);
365  
366         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
367         _balances[recipient] = _balances[recipient].add(amount);
368         emit Transfer(sender, recipient, amount);
369     }
370  
371     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
372      * the total supply.
373      *
374      * Emits a {Transfer} event with `from` set to the zero address.
375      *
376      * Requirements:
377      *
378      * - `account` cannot be the zero address.
379      */
380     function _mint(address account, uint256 amount) internal virtual {
381         require(account != address(0), "ERC20: mint to the zero address");
382  
383         _beforeTokenTransfer(address(0), account, amount);
384  
385         _totalSupply = _totalSupply.add(amount);
386         _balances[account] = _balances[account].add(amount);
387         emit Transfer(address(0), account, amount);
388     }
389  
390     /**
391      * @dev Destroys `amount` tokens from `account`, reducing the
392      * total supply.
393      *
394      * Emits a {Transfer} event with `to` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      * - `account` must have at least `amount` tokens.
400      */
401     function _burn(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: burn from the zero address");
403  
404         _beforeTokenTransfer(account, address(0), amount);
405  
406         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
407         _totalSupply = _totalSupply.sub(amount);
408         emit Transfer(account, address(0), amount);
409     }
410  
411     /**
412      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
413      *
414      * This internal function is equivalent to `approve`, and can be used to
415      * e.g. set automatic allowances for certain subsystems, etc.
416      *
417      * Emits an {Approval} event.
418      *
419      * Requirements:
420      *
421      * - `owner` cannot be the zero address.
422      * - `spender` cannot be the zero address.
423      */
424     function _approve(
425         address owner,
426         address spender,
427         uint256 amount
428     ) internal virtual {
429         require(owner != address(0), "ERC20: approve from the zero address");
430         require(spender != address(0), "ERC20: approve to the zero address");
431  
432         _allowances[owner][spender] = amount;
433         emit Approval(owner, spender, amount);
434     }
435  
436     /**
437      * @dev Hook that is called before any transfer of tokens. This includes
438      * minting and burning.
439      *
440      * Calling conditions:
441      *
442      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
443      * will be to transferred to `to`.
444      * - when `from` is zero, `amount` tokens will be minted for `to`.
445      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
446      * - `from` and `to` are never both zero.
447      *
448      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
449      */
450     function _beforeTokenTransfer(
451         address from,
452         address to,
453         uint256 amount
454     ) internal virtual {}
455 }
456  
457 library SafeMath {
458     function add(uint256 a, uint256 b) internal pure returns (uint256) {
459         uint256 c = a + b;
460         require(c >= a, "SafeMath: addition overflow");
461  
462         return c;
463     }
464 
465     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
466         return sub(a, b, "SafeMath: subtraction overflow");
467     }
468 
469     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
470         require(b <= a, errorMessage);
471         uint256 c = a - b;
472  
473         return c;
474     }
475 
476     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
477         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
478         // benefit is lost if 'b' is also tested.
479         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
480         if (a == 0) {
481             return 0;
482         }
483  
484         uint256 c = a * b;
485         require(c / a == b, "SafeMath: multiplication overflow");
486  
487         return c;
488     }
489 
490     function div(uint256 a, uint256 b) internal pure returns (uint256) {
491         return div(a, b, "SafeMath: division by zero");
492     }
493 
494     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
495         require(b > 0, errorMessage);
496         uint256 c = a / b;
497 
498         return c;
499     }
500 
501     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
502         return mod(a, b, "SafeMath: modulo by zero");
503     }
504 
505     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
506         require(b != 0, errorMessage);
507         return a % b;
508     }
509 }
510  
511 contract Ownable is Context {
512     address private _owner;
513  
514     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
515  
516     constructor () {
517         address msgSender = _msgSender();
518         _owner = msgSender;
519         emit OwnershipTransferred(address(0), msgSender);
520     }
521 
522     function owner() public view returns (address) {
523         return _owner;
524     }
525  
526     modifier onlyOwner() {
527         require(_owner == _msgSender(), "Ownable: caller is not the owner");
528         _;
529     }
530  
531     function renounceOwnership() public virtual onlyOwner {
532         emit OwnershipTransferred(_owner, address(0));
533         _owner = address(0);
534     }
535 
536     function transferOwnership(address newOwner) public virtual onlyOwner {
537         require(newOwner != address(0), "Ownable: new owner is the zero address");
538         emit OwnershipTransferred(_owner, newOwner);
539         _owner = newOwner;
540     }
541 }
542  
543  
544 
545 library SafeMathInt {
546     int256 private constant MIN_INT256 = int256(1) << 255;
547     int256 private constant MAX_INT256 = ~(int256(1) << 255);
548  
549     function mul(int256 a, int256 b) internal pure returns (int256) {
550         int256 c = a * b;
551  
552         // Detect overflow when multiplying MIN_INT256 with -1
553         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
554         require((b == 0) || (c / b == a));
555         return c;
556     }
557  
558     function div(int256 a, int256 b) internal pure returns (int256) {
559         // Prevent overflow when dividing MIN_INT256 by -1
560         require(b != -1 || a != MIN_INT256);
561  
562         // Solidity already throws when dividing by 0.
563         return a / b;
564     }
565  
566     function sub(int256 a, int256 b) internal pure returns (int256) {
567         int256 c = a - b;
568         require((b >= 0 && c <= a) || (b < 0 && c > a));
569         return c;
570     }
571  
572     function add(int256 a, int256 b) internal pure returns (int256) {
573         int256 c = a + b;
574         require((b >= 0 && c >= a) || (b < 0 && c < a));
575         return c;
576     }
577  
578     function abs(int256 a) internal pure returns (int256) {
579         require(a != MIN_INT256);
580         return a < 0 ? -a : a;
581     }
582  
583  
584     function toUint256Safe(int256 a) internal pure returns (uint256) {
585         require(a >= 0);
586         return uint256(a);
587     }
588 }
589  
590 library SafeMathUint {
591   function toInt256Safe(uint256 a) internal pure returns (int256) {
592     int256 b = int256(a);
593     require(b >= 0);
594     return b;
595   }
596 }
597  
598  
599 interface IUniswapV2Router01 {
600     function factory() external pure returns (address);
601     function WETH() external pure returns (address);
602  
603     function addLiquidity(
604         address tokenA,
605         address tokenB,
606         uint amountADesired,
607         uint amountBDesired,
608         uint amountAMin,
609         uint amountBMin,
610         address to,
611         uint deadline
612     ) external returns (uint amountA, uint amountB, uint liquidity);
613     function addLiquidityETH(
614         address token,
615         uint amountTokenDesired,
616         uint amountTokenMin,
617         uint amountETHMin,
618         address to,
619         uint deadline
620     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
621     function removeLiquidity(
622         address tokenA,
623         address tokenB,
624         uint liquidity,
625         uint amountAMin,
626         uint amountBMin,
627         address to,
628         uint deadline
629     ) external returns (uint amountA, uint amountB);
630     function removeLiquidityETH(
631         address token,
632         uint liquidity,
633         uint amountTokenMin,
634         uint amountETHMin,
635         address to,
636         uint deadline
637     ) external returns (uint amountToken, uint amountETH);
638     function removeLiquidityWithPermit(
639         address tokenA,
640         address tokenB,
641         uint liquidity,
642         uint amountAMin,
643         uint amountBMin,
644         address to,
645         uint deadline,
646         bool approveMax, uint8 v, bytes32 r, bytes32 s
647     ) external returns (uint amountA, uint amountB);
648     function removeLiquidityETHWithPermit(
649         address token,
650         uint liquidity,
651         uint amountTokenMin,
652         uint amountETHMin,
653         address to,
654         uint deadline,
655         bool approveMax, uint8 v, bytes32 r, bytes32 s
656     ) external returns (uint amountToken, uint amountETH);
657     function swapExactTokensForTokens(
658         uint amountIn,
659         uint amountOutMin,
660         address[] calldata path,
661         address to,
662         uint deadline
663     ) external returns (uint[] memory amounts);
664     function swapTokensForExactTokens(
665         uint amountOut,
666         uint amountInMax,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external returns (uint[] memory amounts);
671     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
672         external
673         payable
674         returns (uint[] memory amounts);
675     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
676         external
677         returns (uint[] memory amounts);
678     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
679         external
680         returns (uint[] memory amounts);
681     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
682         external
683         payable
684         returns (uint[] memory amounts);
685  
686     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
687     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
688     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
689     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
690     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
691 }
692  
693 interface IUniswapV2Router02 is IUniswapV2Router01 {
694     function removeLiquidityETHSupportingFeeOnTransferTokens(
695         address token,
696         uint liquidity,
697         uint amountTokenMin,
698         uint amountETHMin,
699         address to,
700         uint deadline
701     ) external returns (uint amountETH);
702     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
703         address token,
704         uint liquidity,
705         uint amountTokenMin,
706         uint amountETHMin,
707         address to,
708         uint deadline,
709         bool approveMax, uint8 v, bytes32 r, bytes32 s
710     ) external returns (uint amountETH);
711  
712     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
713         uint amountIn,
714         uint amountOutMin,
715         address[] calldata path,
716         address to,
717         uint deadline
718     ) external;
719     function swapExactETHForTokensSupportingFeeOnTransferTokens(
720         uint amountOutMin,
721         address[] calldata path,
722         address to,
723         uint deadline
724     ) external payable;
725     function swapExactTokensForETHSupportingFeeOnTransferTokens(
726         uint amountIn,
727         uint amountOutMin,
728         address[] calldata path,
729         address to,
730         uint deadline
731     ) external;
732 }
733  
734 contract FROKI is ERC20, Ownable {
735     using SafeMath for uint256;
736  
737     IUniswapV2Router02 public immutable uniswapV2Router;
738     address public immutable uniswapV2Pair;
739     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
740  
741     bool private swapping;
742  
743     address public marketingWallet;
744     address public devWallet;
745  
746     uint256 public maxTransactionAmount;
747     uint256 public swapTokensAtAmount;
748     uint256 public maxWallet;
749  
750     bool public limitsInEffect = true;
751     bool public tradingActive = false;
752     bool public swapEnabled = false;
753  
754      // Anti-bot and anti-whale mappings and variables
755     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
756  
757     // Seller Map
758     mapping (address => uint256) private _holderFirstBuyTimestamp;
759  
760     bool public transferDelayEnabled = true;
761  
762     uint256 public buyTotalFees;
763     uint256 public buyMarketingFee;
764     uint256 public buyLiquidityFee;
765     uint256 public buyDevFee;
766  
767     uint256 public sellTotalFees;
768     uint256 public sellMarketingFee;
769     uint256 public sellLiquidityFee;
770     uint256 public sellDevFee;
771 
772     uint256 public feeDenominator;
773  
774     uint256 public tokensForMarketing;
775     uint256 public tokensForLiquidity;
776     uint256 public tokensForDev;
777  
778     // block number of opened trading
779     uint256 launchedAt;
780  
781     /******************/
782  
783     // exclude from fees and max transaction amount
784     mapping (address => bool) private _isExcludedFromFees;
785     mapping (address => bool) public _isExcludedMaxTransactionAmount;
786  
787     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
788     // could be subject to a maximum transfer amount
789     mapping (address => bool) public automatedMarketMakerPairs;
790  
791     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
792  
793     event ExcludeFromFees(address indexed account, bool isExcluded);
794  
795     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
796  
797     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
798  
799     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
800  
801     event SwapAndLiquify(
802         uint256 tokensSwapped,
803         uint256 ethReceived,
804         uint256 tokensIntoLiquidity
805     );
806  
807     constructor() ERC20("FROKI", "FROKI") {
808  
809         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
810  
811         excludeFromMaxTransaction(address(_uniswapV2Router), true);
812         uniswapV2Router = _uniswapV2Router;
813  
814         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
815         excludeFromMaxTransaction(address(uniswapV2Pair), true);
816         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
817  
818         uint256 _buyMarketingFee = 15;
819         uint256 _buyLiquidityFee = 0;
820         uint256 _buyDevFee = 15;
821         
822         uint256 _sellMarketingFee = 15;
823         uint256 _sellLiquidityFee = 0;
824         uint256 _sellDevFee = 15;
825 
826         uint256 _feeDenominator = 100;
827  
828         uint256 totalSupply = 1_000_000 * 1e18;
829  
830         maxTransactionAmount = totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
831         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
832         swapTokensAtAmount = totalSupply * 3 / 10000; // 0.03% swap wallet
833 
834         feeDenominator = _feeDenominator;
835  
836         buyMarketingFee = _buyMarketingFee;
837         buyLiquidityFee = _buyLiquidityFee;
838         buyDevFee = _buyDevFee;
839         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
840  
841         sellMarketingFee = _sellMarketingFee;
842         sellLiquidityFee = _sellLiquidityFee;
843         sellDevFee = _sellDevFee;
844         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
845  
846         marketingWallet = address(0x41bFB95B141F09E398c84d07F067E855076c46c1); // set as marketing wallet
847         devWallet = address(0x8f7F9aF884A52847d2624aC2b8BC40f70Fe307b9); // set as dev wallet
848  
849         // exclude from paying fees or having max transaction amount
850         excludeFromFees(owner(), true);
851         excludeFromFees(devWallet, true);
852         excludeFromFees(address(this), true);
853         excludeFromFees(address(0xdead), true);
854  
855         excludeFromMaxTransaction(owner(), true);
856         excludeFromMaxTransaction(devWallet, true);
857         excludeFromMaxTransaction(address(this), true);
858         excludeFromMaxTransaction(address(0xdead), true);
859  
860         /*
861             _mint is an internal function in ERC20.sol that is only called here,
862             and CANNOT be called ever again
863         */
864         _mint(msg.sender, totalSupply);
865     }
866  
867     receive() external payable {
868  
869   	}
870  
871     // once enabled, can never be turned off
872     function enableTrading() external onlyOwner {
873         tradingActive = true;
874         swapEnabled = true;
875         launchedAt = block.number;
876     }
877  
878     // remove limits after token is stable
879     function removeLimits() external onlyOwner returns (bool){
880         limitsInEffect = false;
881         return true;
882     }
883  
884     // disable Transfer delay - cannot be reenabled
885     function disableTransferDelay() external onlyOwner returns (bool){
886         transferDelayEnabled = false;
887         return true;
888     }
889  
890      // change the minimum amount of tokens to sell from fees
891     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
892   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
893   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
894   	    swapTokensAtAmount = newAmount;
895   	    return true;
896   	}
897  
898     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
899         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
900         maxTransactionAmount = newNum * (10**18);
901     }
902  
903     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
904         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
905         maxWallet = newNum * (10**18);
906     }
907  
908     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
909         _isExcludedMaxTransactionAmount[updAds] = isEx;
910     }
911  
912     // only use to disable contract sales if absolutely necessary (emergency use only)
913     function updateSwapEnabled(bool enabled) external onlyOwner(){
914         swapEnabled = enabled;
915     }
916  
917     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
918         buyMarketingFee = _marketingFee;
919         buyLiquidityFee = _liquidityFee;
920         buyDevFee = _devFee;
921         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
922         require(buyTotalFees.div(feeDenominator) <= 10, "Must keep fees at 10% or less");
923     }
924  
925     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
926         sellMarketingFee = _marketingFee;
927         sellLiquidityFee = _liquidityFee;
928         sellDevFee = _devFee;
929         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
930         require(sellTotalFees.div(feeDenominator) <= 10, "Must keep fees at 10% or less");
931     }
932  
933     function excludeFromFees(address account, bool excluded) public onlyOwner {
934         _isExcludedFromFees[account] = excluded;
935         emit ExcludeFromFees(account, excluded);
936     }
937  
938     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
939         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
940  
941         _setAutomatedMarketMakerPair(pair, value);
942     }
943  
944     function _setAutomatedMarketMakerPair(address pair, bool value) private {
945         automatedMarketMakerPairs[pair] = value;
946  
947         emit SetAutomatedMarketMakerPair(pair, value);
948     }
949  
950     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
951         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
952         marketingWallet = newMarketingWallet;
953     }
954  
955     function updateDevWallet(address newWallet) external onlyOwner {
956         emit devWalletUpdated(newWallet, devWallet);
957         devWallet = newWallet;
958     }
959 
960     function isExcludedFromFees(address account) public view returns(bool) {
961         return _isExcludedFromFees[account];
962     }
963  
964     function _transfer(
965         address from,
966         address to,
967         uint256 amount
968     ) internal override {
969         require(from != address(0), "ERC20: transfer from the zero address");
970         require(to != address(0), "ERC20: transfer to the zero address");
971         if(amount == 0) {
972             super._transfer(from, to, 0);
973             return;
974         }
975  
976         if(limitsInEffect){
977             if (
978                 from != owner() &&
979                 to != owner() &&
980                 to != address(0) &&
981                 to != address(0xdead) &&
982                 !swapping
983             ){
984                 if(!tradingActive){
985                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
986                 }
987  
988                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
989                 if (transferDelayEnabled) {
990                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
991                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled. Only one purchase per block allowed.");
992                         _holderLastTransferTimestamp[tx.origin] = block.number;
993                     }
994                 }
995  
996                 //when buy
997                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
998                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
999                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1000                 }
1001  
1002                 //when sell
1003                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1004                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1005                 }
1006                 else if(!_isExcludedMaxTransactionAmount[to]){
1007                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1008                 }
1009             }
1010         }
1011  
1012 		uint256 contractTokenBalance = balanceOf(address(this));
1013  
1014         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1015  
1016         if( 
1017             canSwap &&
1018             swapEnabled &&
1019             !swapping &&
1020             !automatedMarketMakerPairs[from] &&
1021             !_isExcludedFromFees[from] &&
1022             !_isExcludedFromFees[to]
1023         ) {
1024             swapping = true;
1025  
1026             swapBack();
1027  
1028             swapping = false;
1029         }
1030  
1031         bool takeFee = !swapping;
1032  
1033         // if any account belongs to _isExcludedFromFee account then remove the fee
1034         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1035             takeFee = false;
1036         }
1037  
1038         uint256 fees = 0;
1039         // only take fees on buys/sells, do not take on wallet transfers
1040         if(takeFee){
1041             // on sell
1042             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1043                 fees = amount.mul(sellTotalFees).div(feeDenominator);
1044                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1045                 tokensForDev += fees * sellDevFee / sellTotalFees;
1046                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1047             }
1048             // on buy
1049             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1050         	    fees = amount.mul(buyTotalFees).div(feeDenominator);
1051         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1052                 tokensForDev += fees * buyDevFee / buyTotalFees;
1053                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1054             }
1055  
1056             if(fees > 0){    
1057                 super._transfer(from, address(this), fees);
1058             }
1059  
1060         	amount -= fees;
1061         }
1062  
1063         super._transfer(from, to, amount);
1064     }
1065  
1066     function swapTokensForEth(uint256 tokenAmount) private {
1067         // generate the uniswap pair path of token -> weth
1068         address[] memory path = new address[](2);
1069         path[0] = address(this);
1070         path[1] = uniswapV2Router.WETH();
1071  
1072         _approve(address(this), address(uniswapV2Router), tokenAmount);
1073  
1074         // make the swap
1075         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1076             tokenAmount,
1077             0, // accept any amount of ETH
1078             path,
1079             address(this),
1080             block.timestamp
1081         );
1082     }
1083  
1084     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1085         // approve token transfer to cover all possible scenarios
1086         _approve(address(this), address(uniswapV2Router), tokenAmount);
1087  
1088         // add the liquidity
1089         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1090             address(this),
1091             tokenAmount,
1092             0, // slippage is unavoidable
1093             0, // slippage is unavoidable
1094             deadAddress,
1095             block.timestamp
1096         );
1097     }
1098  
1099     function swapBack() private {
1100         uint256 contractBalance = balanceOf(address(this));
1101         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1102         bool success;
1103  
1104         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1105  
1106         if(contractBalance > swapTokensAtAmount * 20){
1107           contractBalance = swapTokensAtAmount * 20;
1108         }
1109  
1110         // Halve the amount of liquidity tokens
1111         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1112         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1113  
1114         uint256 initialETHBalance = address(this).balance;
1115  
1116         swapTokensForEth(amountToSwapForETH); 
1117  
1118         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1119  
1120         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1121         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1122  
1123         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1124  
1125         tokensForLiquidity = 0;
1126         tokensForMarketing = 0;
1127         tokensForDev = 0;
1128  
1129         (success,) = address(devWallet).call{value: ethForDev}("");
1130  
1131         if(liquidityTokens > 0 && ethForLiquidity > 0){
1132             addLiquidity(liquidityTokens, ethForLiquidity);
1133             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1134         }
1135  
1136         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1137     }
1138 }