1 /**
2  
3 */
4 
5 /**
6 SOCIALS: TELEGRAM - https://t.me/thedegentimes TWITTER - https://twitter.com/degentimeseth MEDIUM - https://medium.com/@thedegentimes_76339
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.21;
11  
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16  
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22  
23 interface IUniswapV2Pair {
24     event Approval(address indexed owner, address indexed spender, uint value);
25     event Transfer(address indexed from, address indexed to, uint value);
26  
27     function name() external pure returns (string memory);
28     function symbol() external pure returns (string memory);
29     function decimals() external pure returns (uint8);
30     function totalSupply() external view returns (uint);
31     function balanceOf(address owner) external view returns (uint);
32     function allowance(address owner, address spender) external view returns (uint);
33  
34     function approve(address spender, uint value) external returns (bool);
35     function transfer(address to, uint value) external returns (bool);
36     function transferFrom(address from, address to, uint value) external returns (bool);
37  
38     function DOMAIN_SEPARATOR() external view returns (bytes32);
39     function PERMIT_TYPEHASH() external pure returns (bytes32);
40     function nonces(address owner) external view returns (uint);
41  
42     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
43  
44     event Mint(address indexed sender, uint amount0, uint amount1);
45     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
46     event Swap(
47         address indexed sender,
48         uint amount0In,
49         uint amount1In,
50         uint amount0Out,
51         uint amount1Out,
52         address indexed to
53     );
54     event Sync(uint112 reserve0, uint112 reserve1);
55  
56     function MINIMUM_LIQUIDITY() external pure returns (uint);
57     function factory() external view returns (address);
58     function token0() external view returns (address);
59     function token1() external view returns (address);
60     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
61     function price0CumulativeLast() external view returns (uint);
62     function price1CumulativeLast() external view returns (uint);
63     function kLast() external view returns (uint);
64  
65     function mint(address to) external returns (uint liquidity);
66     function burn(address to) external returns (uint amount0, uint amount1);
67     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
68     function skim(address to) external;
69     function sync() external;
70  
71     function initialize(address, address) external;
72 }
73  
74 interface IUniswapV2Factory {
75     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
76  
77     function feeTo() external view returns (address);
78     function feeToSetter() external view returns (address);
79  
80     function getPair(address tokenA, address tokenB) external view returns (address pair);
81     function allPairs(uint) external view returns (address pair);
82     function allPairsLength() external view returns (uint);
83  
84     function createPair(address tokenA, address tokenB) external returns (address pair);
85  
86     function setFeeTo(address) external;
87     function setFeeToSetter(address) external;
88 }
89  
90 interface IERC20 {
91     /**
92      * @dev Returns the amount of tokens in existence.
93      */
94     function totalSupply() external view returns (uint256);
95  
96     /**
97      * @dev Returns the amount of tokens owned by `account`.
98      */
99     function balanceOf(address account) external view returns (uint256);
100  
101     /**
102      * @dev Moves `amount` tokens from the caller's account to `recipient`.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transfer(address recipient, uint256 amount) external returns (bool);
109  
110     /**
111      * @dev Returns the remaining number of tokens that `spender` will be
112      * allowed to spend on behalf of `owner` through {transferFrom}. This is
113      * zero by default.
114      *
115      * This value changes when {approve} or {transferFrom} are called.
116      */
117     function allowance(address owner, address spender) external view returns (uint256);
118  
119     /**
120      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * IMPORTANT: Beware that changing an allowance with this method brings the risk
125      * that someone may use both the old and the new allowance by unfortunate
126      * transaction ordering. One possible solution to mitigate this race
127      * condition is to first reduce the spender's allowance to 0 and set the
128      * desired value afterwards:
129      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address spender, uint256 amount) external returns (bool);
134  
135     /**
136      * @dev Moves `amount` tokens from `sender` to `recipient` using the
137      * allowance mechanism. `amount` is then deducted from the caller's
138      * allowance.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transferFrom(
145         address sender,
146         address recipient,
147         uint256 amount
148     ) external returns (bool);
149  
150     /**
151      * @dev Emitted when `value` tokens are moved from one account (`from`) to
152      * another (`to`).
153      *
154      * Note that `value` may be zero.
155      */
156     event Transfer(address indexed from, address indexed to, uint256 value);
157  
158     /**
159      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
160      * a call to {approve}. `value` is the new allowance.
161      */
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164  
165 interface IERC20Metadata is IERC20 {
166     /**
167      * @dev Returns the name of the token.
168      */
169     function name() external view returns (string memory);
170  
171     /**
172      * @dev Returns the symbol of the token.
173      */
174     function symbol() external view returns (string memory);
175  
176     /**
177      * @dev Returns the decimals places of the token.
178      */
179     function decimals() external view returns (uint8);
180 }
181  
182  
183 contract ERC20 is Context, IERC20, IERC20Metadata {
184     using SafeMath for uint256;
185  
186     mapping(address => uint256) private _balances;
187  
188     mapping(address => mapping(address => uint256)) private _allowances;
189  
190     uint256 private _totalSupply;
191  
192     string private _name;
193     string private _symbol;
194  
195     /**
196      * @dev Sets the values for {name} and {symbol}.
197      *
198      * The default value of {decimals} is 18. To select a different value for
199      * {decimals} you should overload it.
200      *
201      * All two of these values are immutable: they can only be set once during
202      * construction.
203      */
204     constructor(string memory name_, string memory symbol_) {
205         _name = name_;
206         _symbol = symbol_;
207     }
208  
209     /**
210      * @dev Returns the name of the token.
211      */
212     function name() public view virtual override returns (string memory) {
213         return _name;
214     }
215  
216     /**
217      * @dev Returns the symbol of the token, usually a shorter version of the
218      * name.
219      */
220     function symbol() public view virtual override returns (string memory) {
221         return _symbol;
222     }
223  
224     /**
225      * @dev Returns the number of decimals used to get its user representation.
226      * For example, if `decimals` equals `2`, a balance of `505` tokens should
227      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
228      *
229      * Tokens usually opt for a value of 18, imitating the relationship between
230      * Ether and Wei. This is the value {ERC20} uses, unless this function is
231      * overridden;
232      *
233      * NOTE: This information is only used for _display_ purposes: it in
234      * no way affects any of the arithmetic of the contract, including
235      * {IERC20-balanceOf} and {IERC20-transfer}.
236      */
237     function decimals() public view virtual override returns (uint8) {
238         return 18;
239     }
240  
241     /**
242      * @dev See {IERC20-totalSupply}.
243      */
244     function totalSupply() public view virtual override returns (uint256) {
245         return _totalSupply;
246     }
247  
248     /**
249      * @dev See {IERC20-balanceOf}.
250      */
251     function balanceOf(address account) public view virtual override returns (uint256) {
252         return _balances[account];
253     }
254  
255     /**
256      * @dev See {IERC20-transfer}.
257      *
258      * Requirements:
259      *
260      * - `recipient` cannot be the zero address.
261      * - the caller must have a balance of at least `amount`.
262      */
263     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267  
268     /**
269      * @dev See {IERC20-allowance}.
270      */
271     function allowance(address owner, address spender) public view virtual override returns (uint256) {
272         return _allowances[owner][spender];
273     }
274  
275     /**
276      * @dev See {IERC20-approve}.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function approve(address spender, uint256 amount) public virtual override returns (bool) {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286  
287     /**
288      * @dev See {IERC20-transferFrom}.
289      *
290      * Emits an {Approval} event indicating the updated allowance. This is not
291      * required by the EIP. See the note at the beginning of {ERC20}.
292      *
293      * Requirements:
294      *
295      * - `sender` and `recipient` cannot be the zero address.
296      * - `sender` must have a balance of at least `amount`.
297      * - the caller must have allowance for ``sender``'s tokens of at least
298      * `amount`.
299      */
300     function transferFrom(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) public virtual override returns (bool) {
305         _transfer(sender, recipient, amount);
306         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
307         return true;
308     }
309  
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
323         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
324         return true;
325     }
326  
327     /**
328      * @dev Atomically decreases the allowance granted to `spender` by the caller.
329      *
330      * This is an alternative to {approve} that can be used as a mitigation for
331      * problems described in {IERC20-approve}.
332      *
333      * Emits an {Approval} event indicating the updated allowance.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      * - `spender` must have allowance for the caller of at least
339      * `subtractedValue`.
340      */
341     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
342         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
343         return true;
344     }
345  
346     /**
347      * @dev Moves tokens `amount` from `sender` to `recipient`.
348      *
349      * This is internal function is equivalent to {transfer}, and can be used to
350      * e.g. implement automatic token fees, slashing mechanisms, etc.
351      *
352      * Emits a {Transfer} event.
353      *
354      * Requirements:
355      *
356      * - `sender` cannot be the zero address.
357      * - `recipient` cannot be the zero address.
358      * - `sender` must have a balance of at least `amount`.
359      */
360     function _transfer(
361         address sender,
362         address recipient,
363         uint256 amount
364     ) internal virtual {
365         require(sender != address(0), "ERC20: transfer from the zero address");
366         require(recipient != address(0), "ERC20: transfer to the zero address");
367  
368         _beforeTokenTransfer(sender, recipient, amount);
369  
370         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
371         _balances[recipient] = _balances[recipient].add(amount);
372         emit Transfer(sender, recipient, amount);
373     }
374  
375     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
376      * the total supply.
377      *
378      * Emits a {Transfer} event with `from` set to the zero address.
379      *
380      * Requirements:
381      *
382      * - `account` cannot be the zero address.
383      */
384     function _mint(address account, uint256 amount) internal virtual {
385         require(account != address(0), "ERC20: mint to the zero address");
386  
387         _beforeTokenTransfer(address(0), account, amount);
388  
389         _totalSupply = _totalSupply.add(amount);
390         _balances[account] = _balances[account].add(amount);
391         emit Transfer(address(0), account, amount);
392     }
393  
394     /**
395      * @dev Destroys `amount` tokens from `account`, reducing the
396      * total supply.
397      *
398      * Emits a {Transfer} event with `to` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      * - `account` must have at least `amount` tokens.
404      */
405     function _burn(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: burn from the zero address");
407  
408         _beforeTokenTransfer(account, address(0), amount);
409  
410         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
411         _totalSupply = _totalSupply.sub(amount);
412         emit Transfer(account, address(0), amount);
413     }
414  
415     /**
416      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
417      *
418      * This internal function is equivalent to `approve`, and can be used to
419      * e.g. set automatic allowances for certain subsystems, etc.
420      *
421      * Emits an {Approval} event.
422      *
423      * Requirements:
424      *
425      * - `owner` cannot be the zero address.
426      * - `spender` cannot be the zero address.
427      */
428     function _approve(
429         address owner,
430         address spender,
431         uint256 amount
432     ) internal virtual {
433         require(owner != address(0), "ERC20: approve from the zero address");
434         require(spender != address(0), "ERC20: approve to the zero address");
435  
436         _allowances[owner][spender] = amount;
437         emit Approval(owner, spender, amount);
438     }
439  
440     /**
441      * @dev Hook that is called before any transfer of tokens. This includes
442      * minting and burning.
443      *
444      * Calling conditions:
445      *
446      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
447      * will be to transferred to `to`.
448      * - when `from` is zero, `amount` tokens will be minted for `to`.
449      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
450      * - `from` and `to` are never both zero.
451      *
452      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
453      */
454     function _beforeTokenTransfer(
455         address from,
456         address to,
457         uint256 amount
458     ) internal virtual {}
459 }
460  
461 library SafeMath {
462     function add(uint256 a, uint256 b) internal pure returns (uint256) {
463         uint256 c = a + b;
464         require(c >= a, "SafeMath: addition overflow");
465  
466         return c;
467     }
468 
469     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
470         return sub(a, b, "SafeMath: subtraction overflow");
471     }
472 
473     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
474         require(b <= a, errorMessage);
475         uint256 c = a - b;
476  
477         return c;
478     }
479 
480     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
481         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
482         // benefit is lost if 'b' is also tested.
483         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
484         if (a == 0) {
485             return 0;
486         }
487  
488         uint256 c = a * b;
489         require(c / a == b, "SafeMath: multiplication overflow");
490  
491         return c;
492     }
493 
494     function div(uint256 a, uint256 b) internal pure returns (uint256) {
495         return div(a, b, "SafeMath: division by zero");
496     }
497 
498     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
499         require(b > 0, errorMessage);
500         uint256 c = a / b;
501 
502         return c;
503     }
504 
505     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
506         return mod(a, b, "SafeMath: modulo by zero");
507     }
508 
509     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
510         require(b != 0, errorMessage);
511         return a % b;
512     }
513 }
514  
515 contract Ownable is Context {
516     address private _owner;
517  
518     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
519  
520     constructor () {
521         address msgSender = _msgSender();
522         _owner = msgSender;
523         emit OwnershipTransferred(address(0), msgSender);
524     }
525 
526     function owner() public view returns (address) {
527         return _owner;
528     }
529  
530     modifier onlyOwner() {
531         require(_owner == _msgSender(), "Ownable: caller is not the owner");
532         _;
533     }
534  
535     function renounceOwnership() public virtual onlyOwner {
536         emit OwnershipTransferred(_owner, address(0));
537         _owner = address(0);
538     }
539 
540     function transferOwnership(address newOwner) public virtual onlyOwner {
541         require(newOwner != address(0), "Ownable: new owner is the zero address");
542         emit OwnershipTransferred(_owner, newOwner);
543         _owner = newOwner;
544     }
545 }
546  
547  
548 
549 library SafeMathInt {
550     int256 private constant MIN_INT256 = int256(1) << 255;
551     int256 private constant MAX_INT256 = ~(int256(1) << 255);
552  
553     function mul(int256 a, int256 b) internal pure returns (int256) {
554         int256 c = a * b;
555  
556         // Detect overflow when multiplying MIN_INT256 with -1
557         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
558         require((b == 0) || (c / b == a));
559         return c;
560     }
561  
562     function div(int256 a, int256 b) internal pure returns (int256) {
563         // Prevent overflow when dividing MIN_INT256 by -1
564         require(b != -1 || a != MIN_INT256);
565  
566         // Solidity already throws when dividing by 0.
567         return a / b;
568     }
569  
570     function sub(int256 a, int256 b) internal pure returns (int256) {
571         int256 c = a - b;
572         require((b >= 0 && c <= a) || (b < 0 && c > a));
573         return c;
574     }
575  
576     function add(int256 a, int256 b) internal pure returns (int256) {
577         int256 c = a + b;
578         require((b >= 0 && c >= a) || (b < 0 && c < a));
579         return c;
580     }
581  
582     function abs(int256 a) internal pure returns (int256) {
583         require(a != MIN_INT256);
584         return a < 0 ? -a : a;
585     }
586  
587  
588     function toUint256Safe(int256 a) internal pure returns (uint256) {
589         require(a >= 0);
590         return uint256(a);
591     }
592 }
593  
594 library SafeMathUint {
595   function toInt256Safe(uint256 a) internal pure returns (int256) {
596     int256 b = int256(a);
597     require(b >= 0);
598     return b;
599   }
600 }
601  
602  
603 interface IUniswapV2Router01 {
604     function factory() external pure returns (address);
605     function WETH() external pure returns (address);
606  
607     function addLiquidity(
608         address tokenA,
609         address tokenB,
610         uint amountADesired,
611         uint amountBDesired,
612         uint amountAMin,
613         uint amountBMin,
614         address to,
615         uint deadline
616     ) external returns (uint amountA, uint amountB, uint liquidity);
617     function addLiquidityETH(
618         address token,
619         uint amountTokenDesired,
620         uint amountTokenMin,
621         uint amountETHMin,
622         address to,
623         uint deadline
624     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
625     function removeLiquidity(
626         address tokenA,
627         address tokenB,
628         uint liquidity,
629         uint amountAMin,
630         uint amountBMin,
631         address to,
632         uint deadline
633     ) external returns (uint amountA, uint amountB);
634     function removeLiquidityETH(
635         address token,
636         uint liquidity,
637         uint amountTokenMin,
638         uint amountETHMin,
639         address to,
640         uint deadline
641     ) external returns (uint amountToken, uint amountETH);
642     function removeLiquidityWithPermit(
643         address tokenA,
644         address tokenB,
645         uint liquidity,
646         uint amountAMin,
647         uint amountBMin,
648         address to,
649         uint deadline,
650         bool approveMax, uint8 v, bytes32 r, bytes32 s
651     ) external returns (uint amountA, uint amountB);
652     function removeLiquidityETHWithPermit(
653         address token,
654         uint liquidity,
655         uint amountTokenMin,
656         uint amountETHMin,
657         address to,
658         uint deadline,
659         bool approveMax, uint8 v, bytes32 r, bytes32 s
660     ) external returns (uint amountToken, uint amountETH);
661     function swapExactTokensForTokens(
662         uint amountIn,
663         uint amountOutMin,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external returns (uint[] memory amounts);
668     function swapTokensForExactTokens(
669         uint amountOut,
670         uint amountInMax,
671         address[] calldata path,
672         address to,
673         uint deadline
674     ) external returns (uint[] memory amounts);
675     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
676         external
677         payable
678         returns (uint[] memory amounts);
679     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
680         external
681         returns (uint[] memory amounts);
682     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
683         external
684         returns (uint[] memory amounts);
685     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
686         external
687         payable
688         returns (uint[] memory amounts);
689  
690     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
691     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
692     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
693     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
694     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
695 }
696  
697 interface IUniswapV2Router02 is IUniswapV2Router01 {
698     function removeLiquidityETHSupportingFeeOnTransferTokens(
699         address token,
700         uint liquidity,
701         uint amountTokenMin,
702         uint amountETHMin,
703         address to,
704         uint deadline
705     ) external returns (uint amountETH);
706     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
707         address token,
708         uint liquidity,
709         uint amountTokenMin,
710         uint amountETHMin,
711         address to,
712         uint deadline,
713         bool approveMax, uint8 v, bytes32 r, bytes32 s
714     ) external returns (uint amountETH);
715  
716     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
717         uint amountIn,
718         uint amountOutMin,
719         address[] calldata path,
720         address to,
721         uint deadline
722     ) external;
723     function swapExactETHForTokensSupportingFeeOnTransferTokens(
724         uint amountOutMin,
725         address[] calldata path,
726         address to,
727         uint deadline
728     ) external payable;
729     function swapExactTokensForETHSupportingFeeOnTransferTokens(
730         uint amountIn,
731         uint amountOutMin,
732         address[] calldata path,
733         address to,
734         uint deadline
735     ) external;
736 }
737  
738 contract TDT is ERC20, Ownable {
739     using SafeMath for uint256;
740  
741     IUniswapV2Router02 public immutable uniswapV2Router;
742     address public immutable uniswapV2Pair;
743     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
744  
745     bool private swapping;
746  
747     address public marketingWallet;
748     address public devWallet;
749  
750     uint256 public maxTransactionAmount;
751     uint256 public swapTokensAtAmount;
752     uint256 public maxWallet;
753  
754     bool public limitsInEffect = true;
755     bool public tradingActive = true;
756     bool public swapEnabled = false;
757  
758      // Anti-bot and anti-whale mappings and variables
759     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
760  
761     // Seller Map
762     mapping (address => uint256) private _holderFirstBuyTimestamp;
763  
764     bool public transferDelayEnabled = true;
765  
766     uint256 public buyTotalFees;
767     uint256 public buyMarketingFee;
768     uint256 public buyLiquidityFee;
769     uint256 public buyDevFee;
770  
771     uint256 public sellTotalFees;
772     uint256 public sellMarketingFee;
773     uint256 public sellLiquidityFee;
774     uint256 public sellDevFee;
775 
776     uint256 public feeDenominator;
777  
778     uint256 public tokensForMarketing;
779     uint256 public tokensForLiquidity;
780     uint256 public tokensForDev;
781  
782     // block number of opened trading
783     uint256 launchedAt;
784  
785     /******************/
786  
787     // exclude from fees and max transaction amount
788     mapping (address => bool) private _isExcludedFromFees;
789     mapping (address => bool) public _isExcludedMaxTransactionAmount;
790  
791     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
792     // could be subject to a maximum transfer amount
793     mapping (address => bool) public automatedMarketMakerPairs;
794  
795     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
796  
797     event ExcludeFromFees(address indexed account, bool isExcluded);
798  
799     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
800  
801     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
802  
803     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
804  
805     event SwapAndLiquify(
806         uint256 tokensSwapped,
807         uint256 ethReceived,
808         uint256 tokensIntoLiquidity
809     );
810  
811     constructor() ERC20("DeFi Deciphered - The Degen Times", "TDT") {
812  
813         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
814  
815         excludeFromMaxTransaction(address(_uniswapV2Router), true);
816         uniswapV2Router = _uniswapV2Router;
817  
818         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
819         excludeFromMaxTransaction(address(uniswapV2Pair), true);
820         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
821  
822         uint256 _buyMarketingFee = 5;
823         uint256 _buyLiquidityFee = 0;
824         uint256 _buyDevFee = 25;
825         
826         uint256 _sellMarketingFee = 20;
827         uint256 _sellLiquidityFee = 0;
828         uint256 _sellDevFee = 10;
829 
830         uint256 _feeDenominator = 100;
831  
832         uint256 totalSupply = 1_000_000 * 1e18;
833  
834         maxTransactionAmount = totalSupply * 15 / 1000; // 1.5% maxTransactionAmountTxn
835         maxWallet = totalSupply * 15 / 1000; // 1.5% maxWallet
836         swapTokensAtAmount = totalSupply * 3 / 10000; // 0.03% swap wallet
837 
838         feeDenominator = _feeDenominator;
839  
840         buyMarketingFee = _buyMarketingFee;
841         buyLiquidityFee = _buyLiquidityFee;
842         buyDevFee = _buyDevFee;
843         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
844  
845         sellMarketingFee = _sellMarketingFee;
846         sellLiquidityFee = _sellLiquidityFee;
847         sellDevFee = _sellDevFee;
848         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
849  
850         marketingWallet = address(0x5403DA777f7F470336eF31f13C21EF0b1E00a8f7); // set as marketing wallet
851         devWallet = address(0x5403DA777f7F470336eF31f13C21EF0b1E00a8f7); // set as dev wallet
852  
853         // exclude from paying fees or having max transaction amount
854         excludeFromFees(owner(), true);
855         excludeFromFees(devWallet, true);
856         excludeFromFees(address(this), true);
857         excludeFromFees(address(0xdead), true);
858  
859         excludeFromMaxTransaction(owner(), true);
860         excludeFromMaxTransaction(devWallet, true);
861         excludeFromMaxTransaction(address(this), true);
862         excludeFromMaxTransaction(address(0xdead), true);
863  
864         /*
865             _mint is an internal function in ERC20.sol that is only called here,
866             and CANNOT be called ever again
867         */
868         _mint(msg.sender, totalSupply);
869     }
870  
871     receive() external payable {
872  
873   	}
874  
875     // once enabled, can never be turned off
876     function enableTrading() external onlyOwner {
877         tradingActive = true;
878         swapEnabled = true;
879         launchedAt = block.number;
880     }
881  
882     // remove limits after token is stable
883     function removeLimits() external onlyOwner returns (bool){
884         limitsInEffect = false;
885         return true;
886     }
887  
888     // disable Transfer delay - cannot be reenabled
889     function disableTransferDelay() external onlyOwner returns (bool){
890         transferDelayEnabled = false;
891         return true;
892     }
893  
894      // change the minimum amount of tokens to sell from fees
895     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
896   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
897   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
898   	    swapTokensAtAmount = newAmount;
899   	    return true;
900   	}
901  
902     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
903         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
904         maxTransactionAmount = newNum * (10**18);
905     }
906  
907     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
908         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
909         maxWallet = newNum * (10**18);
910     }
911  
912     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
913         _isExcludedMaxTransactionAmount[updAds] = isEx;
914     }
915  
916     // only use to disable contract sales if absolutely necessary (emergency use only)
917     function updateSwapEnabled(bool enabled) external onlyOwner(){
918         swapEnabled = enabled;
919     }
920  
921     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
922         buyMarketingFee = _marketingFee;
923         buyLiquidityFee = _liquidityFee;
924         buyDevFee = _devFee;
925         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
926         require(buyTotalFees.div(feeDenominator) <= 10, "Must keep fees at 10% or less");
927     }
928  
929     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
930         sellMarketingFee = _marketingFee;
931         sellLiquidityFee = _liquidityFee;
932         sellDevFee = _devFee;
933         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
934         require(sellTotalFees.div(feeDenominator) <= 10, "Must keep fees at 10% or less");
935     }
936  
937     function excludeFromFees(address account, bool excluded) public onlyOwner {
938         _isExcludedFromFees[account] = excluded;
939         emit ExcludeFromFees(account, excluded);
940     }
941  
942     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
943         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
944  
945         _setAutomatedMarketMakerPair(pair, value);
946     }
947  
948     function _setAutomatedMarketMakerPair(address pair, bool value) private {
949         automatedMarketMakerPairs[pair] = value;
950  
951         emit SetAutomatedMarketMakerPair(pair, value);
952     }
953  
954     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
955         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
956         marketingWallet = newMarketingWallet;
957     }
958  
959     function updateDevWallet(address newWallet) external onlyOwner {
960         emit devWalletUpdated(newWallet, devWallet);
961         devWallet = newWallet;
962     }
963 
964     function isExcludedFromFees(address account) public view returns(bool) {
965         return _isExcludedFromFees[account];
966     }
967  
968     function _transfer(
969         address from,
970         address to,
971         uint256 amount
972     ) internal override {
973         require(from != address(0), "ERC20: transfer from the zero address");
974         require(to != address(0), "ERC20: transfer to the zero address");
975         if(amount == 0) {
976             super._transfer(from, to, 0);
977             return;
978         }
979  
980         if(limitsInEffect){
981             if (
982                 from != owner() &&
983                 to != owner() &&
984                 to != address(0) &&
985                 to != address(0xdead) &&
986                 !swapping
987             ){
988                 if(!tradingActive){
989                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
990                 }
991  
992                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
993                 if (transferDelayEnabled) {
994                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
995                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled. Only one purchase per block allowed.");
996                         _holderLastTransferTimestamp[tx.origin] = block.number;
997                     }
998                 }
999  
1000                 //when buy
1001                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1002                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1003                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1004                 }
1005  
1006                 //when sell
1007                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1008                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1009                 }
1010                 else if(!_isExcludedMaxTransactionAmount[to]){
1011                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1012                 }
1013             }
1014         }
1015  
1016 		uint256 contractTokenBalance = balanceOf(address(this));
1017  
1018         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1019  
1020         if( 
1021             canSwap &&
1022             swapEnabled &&
1023             !swapping &&
1024             !automatedMarketMakerPairs[from] &&
1025             !_isExcludedFromFees[from] &&
1026             !_isExcludedFromFees[to]
1027         ) {
1028             swapping = true;
1029  
1030             swapBack();
1031  
1032             swapping = false;
1033         }
1034  
1035         bool takeFee = !swapping;
1036  
1037         // if any account belongs to _isExcludedFromFee account then remove the fee
1038         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1039             takeFee = false;
1040         }
1041  
1042         uint256 fees = 0;
1043         // only take fees on buys/sells, do not take on wallet transfers
1044         if(takeFee){
1045             // on sell
1046             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1047                 fees = amount.mul(sellTotalFees).div(feeDenominator);
1048                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1049                 tokensForDev += fees * sellDevFee / sellTotalFees;
1050                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1051             }
1052             // on buy
1053             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1054         	    fees = amount.mul(buyTotalFees).div(feeDenominator);
1055         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1056                 tokensForDev += fees * buyDevFee / buyTotalFees;
1057                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1058             }
1059  
1060             if(fees > 0){    
1061                 super._transfer(from, address(this), fees);
1062             }
1063  
1064         	amount -= fees;
1065         }
1066  
1067         super._transfer(from, to, amount);
1068     }
1069  
1070     function swapTokensForEth(uint256 tokenAmount) private {
1071         // generate the uniswap pair path of token -> weth
1072         address[] memory path = new address[](2);
1073         path[0] = address(this);
1074         path[1] = uniswapV2Router.WETH();
1075  
1076         _approve(address(this), address(uniswapV2Router), tokenAmount);
1077  
1078         // make the swap
1079         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1080             tokenAmount,
1081             0, // accept any amount of ETH
1082             path,
1083             address(this),
1084             block.timestamp
1085         );
1086     }
1087  
1088     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1089         // approve token transfer to cover all possible scenarios
1090         _approve(address(this), address(uniswapV2Router), tokenAmount);
1091  
1092         // add the liquidity
1093         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1094             address(this),
1095             tokenAmount,
1096             0, // slippage is unavoidable
1097             0, // slippage is unavoidable
1098             deadAddress,
1099             block.timestamp
1100         );
1101     }
1102  
1103     function swapBack() private {
1104         uint256 contractBalance = balanceOf(address(this));
1105         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1106         bool success;
1107  
1108         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1109  
1110         if(contractBalance > swapTokensAtAmount * 20){
1111           contractBalance = swapTokensAtAmount * 20;
1112         }
1113  
1114         // Halve the amount of liquidity tokens
1115         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1116         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1117  
1118         uint256 initialETHBalance = address(this).balance;
1119  
1120         swapTokensForEth(amountToSwapForETH); 
1121  
1122         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1123  
1124         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1125         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1126  
1127         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1128  
1129         tokensForLiquidity = 0;
1130         tokensForMarketing = 0;
1131         tokensForDev = 0;
1132  
1133         (success,) = address(devWallet).call{value: ethForDev}("");
1134  
1135         if(liquidityTokens > 0 && ethForLiquidity > 0){
1136             addLiquidity(liquidityTokens, ethForLiquidity);
1137             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1138         }
1139  
1140         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1141     }
1142 }