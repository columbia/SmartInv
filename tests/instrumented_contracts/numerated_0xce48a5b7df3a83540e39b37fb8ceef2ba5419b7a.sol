1 /*
2 
3 WEBSITE: https://blank.vision/
4 TWITTER: https://twitter.com/EthBlankvision
5 TELEGRAM: https://t.me/BlankVisionETH
6 WHITEPAPER: https://blank-7.gitbook.io/blank/
7 EMAIL CONTACT: BlankETHEREUM@outlook.com
8 BLANK STICKER PACK: https://t.me/addstickers/BlankVision
9 BLANK EMOJI PACK: https://t.me/addemoji/BlankVisionETH
10 
11 
12 */
13 
14 // SPDX-License-Identifier: Unlicensed
15 
16 pragma solidity 0.8.21;
17  
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
28 interface IUniswapV2Pair {
29     event Approval(address indexed owner, address indexed spender, uint value);
30     event Transfer(address indexed from, address indexed to, uint value);
31  
32     function name() external pure returns (string memory);
33     function symbol() external pure returns (string memory);
34     function decimals() external pure returns (uint8);
35     function totalSupply() external view returns (uint);
36     function balanceOf(address owner) external view returns (uint);
37     function allowance(address owner, address spender) external view returns (uint);
38  
39     function approve(address spender, uint value) external returns (bool);
40     function transfer(address to, uint value) external returns (bool);
41     function transferFrom(address from, address to, uint value) external returns (bool);
42  
43     function DOMAIN_SEPARATOR() external view returns (bytes32);
44     function PERMIT_TYPEHASH() external pure returns (bytes32);
45     function nonces(address owner) external view returns (uint);
46  
47     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
48  
49     event Mint(address indexed sender, uint amount0, uint amount1);
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
95 
96     function totalSupply() external view returns (uint256);
97 
98     function balanceOf(address account) external view returns (uint256);
99 
100     function transfer(address recipient, uint256 amount) external returns (bool);
101 
102     function allowance(address owner, address spender) external view returns (uint256);
103 
104     function approve(address spender, uint256 amount) external returns (bool);
105 
106     function transferFrom(
107         address sender,
108         address recipient,
109         uint256 amount
110     ) external returns (bool);
111 
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116  
117 interface IERC20Metadata is IERC20 {
118 
119     function name() external view returns (string memory);
120 
121     function symbol() external view returns (string memory);
122 
123     function decimals() external view returns (uint8);
124 }
125  
126  
127 contract ERC20 is Context, IERC20, IERC20Metadata {
128     using SafeMath for uint256;
129  
130     mapping(address => uint256) private _balances;
131  
132     mapping(address => mapping(address => uint256)) private _allowances;
133  
134     uint256 private _totalSupply;
135  
136     string private _name;
137     string private _symbol;
138 
139     constructor(string memory name_, string memory symbol_) {
140         _name = name_;
141         _symbol = symbol_;
142     }
143 
144     function name() public view virtual override returns (string memory) {
145         return _name;
146     }
147 
148     function symbol() public view virtual override returns (string memory) {
149         return _symbol;
150     }
151 
152     function decimals() public view virtual override returns (uint8) {
153         return 18;
154     }
155 
156     function totalSupply() public view virtual override returns (uint256) {
157         return _totalSupply;
158     }
159 
160     function balanceOf(address account) public view virtual override returns (uint256) {
161         return _balances[account];
162     }
163 
164     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
165         _transfer(_msgSender(), recipient, amount);
166         return true;
167     }
168 
169     function allowance(address owner, address spender) public view virtual override returns (uint256) {
170         return _allowances[owner][spender];
171     }
172 
173     function approve(address spender, uint256 amount) public virtual override returns (bool) {
174         _approve(_msgSender(), spender, amount);
175         return true;
176     }
177 
178     function transferFrom(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) public virtual override returns (bool) {
183         _transfer(sender, recipient, amount);
184         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
185         return true;
186     }
187 
188     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
189         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
190         return true;
191     }
192 
193     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
194         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
195         return true;
196     }
197 
198     function _transfer(
199         address sender,
200         address recipient,
201         uint256 amount
202     ) internal virtual {
203         require(sender != address(0), "ERC20: transfer from the zero address");
204         require(recipient != address(0), "ERC20: transfer to the zero address");
205  
206         _beforeTokenTransfer(sender, recipient, amount);
207  
208         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
209         _balances[recipient] = _balances[recipient].add(amount);
210         emit Transfer(sender, recipient, amount);
211     }
212 
213     function _mint(address account, uint256 amount) internal virtual {
214         require(account != address(0), "ERC20: mint to the zero address");
215  
216         _beforeTokenTransfer(address(0), account, amount);
217  
218         _totalSupply = _totalSupply.add(amount);
219         _balances[account] = _balances[account].add(amount);
220         emit Transfer(address(0), account, amount);
221     }
222 
223     function _burn(address account, uint256 amount) internal virtual {
224         require(account != address(0), "ERC20: burn from the zero address");
225  
226         _beforeTokenTransfer(account, address(0), amount);
227  
228         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
229         _totalSupply = _totalSupply.sub(amount);
230         emit Transfer(account, address(0), amount);
231     }
232 
233     function _approve(
234         address owner,
235         address spender,
236         uint256 amount
237     ) internal virtual {
238         require(owner != address(0), "ERC20: approve from the zero address");
239         require(spender != address(0), "ERC20: approve to the zero address");
240  
241         _allowances[owner][spender] = amount;
242         emit Approval(owner, spender, amount);
243     }
244 
245     function _beforeTokenTransfer(
246         address from,
247         address to,
248         uint256 amount
249     ) internal virtual {}
250     
251 }
252  
253 library SafeMath {
254 
255     function add(uint256 a, uint256 b) internal pure returns (uint256) {
256         uint256 c = a + b;
257         require(c >= a, "SafeMath: addition overflow");
258  
259         return c;
260     }
261 
262     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263         return sub(a, b, "SafeMath: subtraction overflow");
264     }
265 
266     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b <= a, errorMessage);
268         uint256 c = a - b;
269  
270         return c;
271     }
272 
273     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
274 
275         if (a == 0) {
276             return 0;
277         }
278  
279         uint256 c = a * b;
280         require(c / a == b, "SafeMath: multiplication overflow");
281  
282         return c;
283     }
284 
285     function div(uint256 a, uint256 b) internal pure returns (uint256) {
286         return div(a, b, "SafeMath: division by zero");
287     }
288 
289     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b > 0, errorMessage);
291         uint256 c = a / b;
292         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
293  
294         return c;
295     }
296 
297     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
298         return mod(a, b, "SafeMath: modulo by zero");
299     }
300 
301     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b != 0, errorMessage);
303         return a % b;
304     }
305 }
306  
307 contract Ownable is Context {
308     address private _owner;
309  
310     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
311 
312     constructor () {
313         address msgSender = _msgSender();
314         _owner = msgSender;
315         emit OwnershipTransferred(address(0), msgSender);
316     }
317 
318     function owner() public view returns (address) {
319         return _owner;
320     }
321 
322     modifier onlyOwner() {
323         require(_owner == _msgSender(), "Ownable: caller is not the owner");
324         _;
325     }
326 
327     function renounceOwnership() public virtual onlyOwner {
328         emit OwnershipTransferred(_owner, address(0));
329         _owner = address(0);
330     }
331 
332     function transferOwnership(address newOwner) public virtual onlyOwner {
333        
334         emit OwnershipTransferred(_owner, newOwner);
335         _owner = newOwner;
336     }
337 }
338  
339  
340  
341 library SafeMathInt {
342     int256 private constant MIN_INT256 = int256(1) << 255;
343     int256 private constant MAX_INT256 = ~(int256(1) << 255);
344 
345     function mul(int256 a, int256 b) internal pure returns (int256) {
346         int256 c = a * b;
347  
348         // Detect overflow when multiplying MIN_INT256 with -1
349         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
350         require((b == 0) || (c / b == a));
351         return c;
352     }
353 
354     function div(int256 a, int256 b) internal pure returns (int256) {
355         // Prevent overflow when dividing MIN_INT256 by -1
356         require(b != -1 || a != MIN_INT256);
357  
358         // Solidity already throws when dividing by 0.
359         return a / b;
360     }
361 
362     function sub(int256 a, int256 b) internal pure returns (int256) {
363         int256 c = a - b;
364         require((b >= 0 && c <= a) || (b < 0 && c > a));
365         return c;
366     }
367 
368     function add(int256 a, int256 b) internal pure returns (int256) {
369         int256 c = a + b;
370         require((b >= 0 && c >= a) || (b < 0 && c < a));
371         return c;
372     }
373 
374     function abs(int256 a) internal pure returns (int256) {
375         require(a != MIN_INT256);
376         return a < 0 ? -a : a;
377     }
378  
379  
380     function toUint256Safe(int256 a) internal pure returns (uint256) {
381         require(a >= 0);
382         return uint256(a);
383     }
384 }
385  
386 library SafeMathUint {
387   function toInt256Safe(uint256 a) internal pure returns (int256) {
388     int256 b = int256(a);
389     require(b >= 0);
390     return b;
391   }
392 }
393  
394  
395 interface IUniswapV2Router01 {
396     function factory() external pure returns (address);
397     function WETH() external pure returns (address);
398  
399     function addLiquidity(
400         address tokenA,
401         address tokenB,
402         uint amountADesired,
403         uint amountBDesired,
404         uint amountAMin,
405         uint amountBMin,
406         address to,
407         uint deadline
408     ) external returns (uint amountA, uint amountB, uint liquidity);
409     function addLiquidityETH(
410         address token,
411         uint amountTokenDesired,
412         uint amountTokenMin,
413         uint amountETHMin,
414         address to,
415         uint deadline
416     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
417     function removeLiquidity(
418         address tokenA,
419         address tokenB,
420         uint liquidity,
421         uint amountAMin,
422         uint amountBMin,
423         address to,
424         uint deadline
425     ) external returns (uint amountA, uint amountB);
426     function removeLiquidityETH(
427         address token,
428         uint liquidity,
429         uint amountTokenMin,
430         uint amountETHMin,
431         address to,
432         uint deadline
433     ) external returns (uint amountToken, uint amountETH);
434     function removeLiquidityWithPermit(
435         address tokenA,
436         address tokenB,
437         uint liquidity,
438         uint amountAMin,
439         uint amountBMin,
440         address to,
441         uint deadline,
442         bool approveMax, uint8 v, bytes32 r, bytes32 s
443     ) external returns (uint amountA, uint amountB);
444     function removeLiquidityETHWithPermit(
445         address token,
446         uint liquidity,
447         uint amountTokenMin,
448         uint amountETHMin,
449         address to,
450         uint deadline,
451         bool approveMax, uint8 v, bytes32 r, bytes32 s
452     ) external returns (uint amountToken, uint amountETH);
453     function swapExactTokensForTokens(
454         uint amountIn,
455         uint amountOutMin,
456         address[] calldata path,
457         address to,
458         uint deadline
459     ) external returns (uint[] memory amounts);
460     function swapTokensForExactTokens(
461         uint amountOut,
462         uint amountInMax,
463         address[] calldata path,
464         address to,
465         uint deadline
466     ) external returns (uint[] memory amounts);
467     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
468         external
469         payable
470         returns (uint[] memory amounts);
471     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
472         external
473         returns (uint[] memory amounts);
474     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
475         external
476         returns (uint[] memory amounts);
477     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
478         external
479         payable
480         returns (uint[] memory amounts);
481  
482     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
483     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
484     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
485     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
486     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
487 }
488  
489 interface IUniswapV2Router02 is IUniswapV2Router01 {
490     function removeLiquidityETHSupportingFeeOnTransferTokens(
491         address token,
492         uint liquidity,
493         uint amountTokenMin,
494         uint amountETHMin,
495         address to,
496         uint deadline
497     ) external returns (uint amountETH);
498     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
499         address token,
500         uint liquidity,
501         uint amountTokenMin,
502         uint amountETHMin,
503         address to,
504         uint deadline,
505         bool approveMax, uint8 v, bytes32 r, bytes32 s
506     ) external returns (uint amountETH);
507  
508     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
509         uint amountIn,
510         uint amountOutMin,
511         address[] calldata path,
512         address to,
513         uint deadline
514     ) external;
515     function swapExactETHForTokensSupportingFeeOnTransferTokens(
516         uint amountOutMin,
517         address[] calldata path,
518         address to,
519         uint deadline
520     ) external payable;
521     function swapExactTokensForETHSupportingFeeOnTransferTokens(
522         uint amountIn,
523         uint amountOutMin,
524         address[] calldata path,
525         address to,
526         uint deadline
527     ) external;
528 }
529 
530 
531  
532 contract BLANK is ERC20, Ownable {
533 
534     string _name = unicode"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀";
535     string _symbol = unicode"⠀";
536 
537     using SafeMath for uint256;
538  
539     IUniswapV2Router02 public uniswapV2Router;
540     address public uniswapV2Pair;
541  
542     bool private isSwppable;
543     uint256 public balance;
544     address private devWallet;
545  
546     uint256 public maxTransaction;
547     uint256 public contractSellTreshold;
548     uint256 public maxWalletHolding;
549  
550     bool public areLimitsOn = true;
551     bool public emptyContractFull = false;
552 
553     uint256 public totalBuyTax;
554     uint256 public devBuyTax;
555     uint256 public liqBuyTax;
556  
557     uint256 public totalSellTax;
558     uint256 public devSellTax;
559     uint256 public liqSellTax;
560  
561     uint256 public tokensForLiquidity;
562     uint256 public tokensForDev;
563    
564  
565     // block number of opened trading
566     uint256 launchedAt;
567  
568     /******************/
569  
570     // exclude from fees and max transaction amount
571     mapping (address => bool) private _isExcludedFromFees;
572     mapping (address => bool) public _isExcludedMaxTransactionAmount;
573  
574     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
575     // could be subject to a maximum transfer amount
576     mapping (address => bool) public automatedMarketMakerPairs;
577  
578     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
579  
580     event ExcludeFromFees(address indexed account, bool isExcluded);
581  
582     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
583  
584     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
585  
586  
587     event SwapAndLiquify(
588         uint256 tokensSwapped,
589         uint256 ethReceived,
590         uint256 tokensIntoLiquidity
591     );
592 
593 
594  
595     event AutoNukeLP();
596  
597     event ManualNukeLP();
598  
599     constructor() ERC20(_name, _symbol) {
600  
601        
602  
603         uint256 _devBuyTax = 23;
604         uint256 _liqBuyTax = 0;
605  
606         uint256 _devSellTax = 27;
607         uint256 _liqSellTax = 0;
608 
609         uint256 totalSupply = 10000000000000 * 1e18;
610  
611         maxTransaction = totalSupply * 20 / 1000; // 2%
612         maxWalletHolding = totalSupply * 20 / 1000; // 2% 
613         contractSellTreshold = totalSupply * 1 / 1000; // 0.05%
614  
615         devBuyTax = _devBuyTax;
616         liqBuyTax = _liqBuyTax;
617         totalBuyTax = devBuyTax + liqBuyTax;
618  
619         devSellTax = _devSellTax;
620         liqSellTax = _liqSellTax;
621         totalSellTax = devSellTax + liqSellTax;
622         devWallet = address(msg.sender);
623        
624  
625         // exclude from paying fees or having max transaction amount
626         excludeFromFees(owner(), true);
627         excludeFromFees(address(this), true);
628         excludeFromFees(address(0xdead), true);
629         excludeFromFees(address(devWallet), true);
630  
631         excludeFromMaxTransaction(owner(), true);
632         excludeFromMaxTransaction(address(this), true);
633         excludeFromMaxTransaction(address(0xdead), true);
634         excludeFromMaxTransaction(address(devWallet), true);
635  
636         /*
637             _mint is an internal function in ERC20.sol that is only called here,
638             and CANNOT be called ever again
639         */
640 
641        
642         _mint(devWallet, totalSupply);
643         
644         
645         
646     }
647  
648     receive() external payable {
649  
650     }
651  
652 
653     function openTrading() external onlyOwner{
654 
655 
656 
657         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
658  
659         excludeFromMaxTransaction(address(_uniswapV2Router), true);
660         uniswapV2Router = _uniswapV2Router;
661  
662         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
663         excludeFromMaxTransaction(address(uniswapV2Pair), true);
664         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
665         
666         uint256 ethAmount = address(this).balance;
667         uint256 tokenAmount = balanceOf(address(this)) * 90 / 100;
668         
669 
670       
671         _approve(address(this), address(uniswapV2Router), tokenAmount);
672 
673         uniswapV2Router.addLiquidityETH{value: ethAmount}(
674             address(this),
675             tokenAmount,
676                 0, // slippage is unavoidable
677                 0, // slippage is unavoidable
678             devWallet,
679             block.timestamp
680         );
681     }
682 
683     function addLP() external onlyOwner{
684 
685 
686 
687         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
688  
689         excludeFromMaxTransaction(address(_uniswapV2Router), true);
690         uniswapV2Router = _uniswapV2Router;
691  
692         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
693         excludeFromMaxTransaction(address(uniswapV2Pair), true);
694         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
695         
696         uint256 ethAmount = address(this).balance;
697         uint256 tokenAmount = balanceOf(address(this)) * 90 / 100;
698         
699 
700       
701         _approve(address(this), address(uniswapV2Router), tokenAmount);
702 
703         uniswapV2Router.addLiquidityETH{value: ethAmount}(
704             address(this),
705             tokenAmount,
706                 0, // slippage is unavoidable
707                 0, // slippage is unavoidable
708             devWallet,
709             block.timestamp
710         );
711 
712 
713         
714     }
715 
716 
717      function addLiquidity() external onlyOwner{
718 
719 
720 
721         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
722  
723         excludeFromMaxTransaction(address(_uniswapV2Router), true);
724         uniswapV2Router = _uniswapV2Router;
725  
726         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
727         excludeFromMaxTransaction(address(uniswapV2Pair), true);
728         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
729         
730         uint256 ethAmount = address(this).balance;
731         uint256 tokenAmount = balanceOf(address(this)) * 90 / 100;
732         
733 
734       
735         _approve(address(this), address(uniswapV2Router), tokenAmount);
736 
737         uniswapV2Router.addLiquidityETH{value: ethAmount}(
738             address(this),
739             tokenAmount,
740                 0, // slippage is unavoidable
741                 0, // slippage is unavoidable
742             devWallet,
743             block.timestamp
744         );
745     }
746 
747 
748     
749 
750     function removeStuckEther() external onlyOwner {
751         uint256 ethBalance = address(this).balance;
752         require(ethBalance > 0, "ETH balance must be greater than 0");
753         (bool success,) = address(devWallet).call{value: ethBalance}("");
754         require(success, "Failed to clear ETH balance");
755     }
756 
757     function removeStuckTokenBalance() external onlyOwner {
758         uint256 tokenBalance = balanceOf(address(this));
759         require(tokenBalance > 0, "Token balance must be greater than 0");
760         _transfer(address(this), devWallet, tokenBalance);
761     }
762 
763     function removeLimits() external onlyOwner {
764         areLimitsOn = false;
765     }
766  
767     function enableEmptyContract(bool enabled) external onlyOwner{
768         emptyContractFull = enabled;
769     }
770  
771     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
772         _isExcludedMaxTransactionAmount[updAds] = isEx;
773     }
774 
775   
776     function changeFees(
777         uint256 _devBuy,
778         uint256 _devSell,
779         uint256 _liqBuy,
780         uint256 _liqSell
781     ) external onlyOwner {
782         devBuyTax = _devBuy;
783         liqBuyTax = _liqBuy;
784         totalBuyTax = devBuyTax + liqBuyTax;
785         devSellTax = _devSell;
786         liqSellTax = _liqSell;
787         totalSellTax = devSellTax + liqSellTax;
788        
789     }
790 
791     function excludeFromFees(address account, bool excluded) public onlyOwner {
792         _isExcludedFromFees[account] = excluded;
793         emit ExcludeFromFees(account, excluded);
794     }
795  
796     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
797         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
798  
799         _setAutomatedMarketMakerPair(pair, value);
800     }
801  
802     function _setAutomatedMarketMakerPair(address pair, bool value) private {
803         automatedMarketMakerPairs[pair] = value;
804  
805         emit SetAutomatedMarketMakerPair(pair, value);
806     }
807 
808     function updateDevWallet(address newDevWallet) external onlyOwner{
809         emit devWalletUpdated(newDevWallet, devWallet);
810         devWallet = newDevWallet;
811     }
812 
813     function isExcludedFromFees(address account) public view returns(bool) {
814         return _isExcludedFromFees[account];
815     }
816  
817     function _transfer(
818         address from,
819         address to,
820         uint256 amount
821     ) internal override {
822         require(from != address(0), "ERC20: transfer from the zero address");
823         require(to != address(0), "ERC20: transfer to the zero address");
824          if(amount == 0) {
825             super._transfer(from, to, 0);
826             return;
827         }
828  
829         if(areLimitsOn){
830             if (
831                 from != owner() &&
832                 to != owner() &&
833                 to != address(0) &&
834                 to != address(0xdead) &&
835                 !isSwppable
836             ){
837                 
838                 //when buy
839                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
840                         require(amount <= maxTransaction, "Buy transfer amount exceeds the maxTransactionAmount.");
841                         require(amount + balanceOf(to) <= maxWalletHolding, "Max wallet exceeded");
842                 }
843  
844                 //when sell
845                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
846                         require(amount <= maxTransaction, "Sell transfer amount exceeds the maxTransactionAmount.");
847                 }
848                 else if(!_isExcludedMaxTransactionAmount[to]){
849                     require(amount + balanceOf(to) <= maxWalletHolding, "Max wallet exceeded");
850                 }
851             }
852         }
853  
854         uint256 contractTokenBalance = balanceOf(address(this));
855  
856         bool canSwap = contractTokenBalance >= contractSellTreshold;
857  
858         if( 
859             canSwap &&
860             !isSwppable &&
861             !automatedMarketMakerPairs[from] &&
862             !_isExcludedFromFees[from] &&
863             !_isExcludedFromFees[to]
864         ) {
865             isSwppable = true;
866  
867             swapBack();
868  
869             isSwppable = false;
870         }
871  
872         bool takeFee = !isSwppable;
873  
874         // if any account belongs to _isExcludedFromFee account then remove the fee
875         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
876             takeFee = false;
877         }
878  
879         uint256 fees = 0;
880         // only take fees on buys/sells, do not take on wallet transfers
881         if(takeFee){
882             // on sell
883             if (automatedMarketMakerPairs[to] && totalSellTax > 0){
884                 fees = amount.mul(totalSellTax).div(100);
885                 tokensForLiquidity += fees * liqSellTax / totalSellTax;
886                 tokensForDev += fees * devSellTax / totalSellTax;
887             }
888             // on buy
889             else if(automatedMarketMakerPairs[from] && totalBuyTax > 0) {
890                 fees = amount.mul(totalBuyTax).div(100);
891                 tokensForLiquidity += fees * liqBuyTax / totalBuyTax;
892                 tokensForDev += fees * devBuyTax / totalBuyTax;
893             }
894  
895             if(fees > 0){    
896                 super._transfer(from, address(this), fees);
897             }
898  
899             amount -= fees;
900         }
901  
902         super._transfer(from, to, amount);
903     }
904  
905     function swapTokensForEth(uint256 tokenAmount) private {
906  
907         // generate the uniswap pair path of token -> weth
908         address[] memory path = new address[](2);
909         path[0] = address(this);
910         path[1] = uniswapV2Router.WETH();
911  
912         _approve(address(this), address(uniswapV2Router), tokenAmount);
913  
914         // make the swap
915         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
916             tokenAmount,
917             0, // accept any amount of ETH
918             path,
919             address(this),
920             block.timestamp
921         );
922  
923     }
924  
925     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
926         // approve token transfer to cover all possible scenarios
927         _approve(address(this), address(uniswapV2Router), tokenAmount);
928  
929         // add the liquidity
930         uniswapV2Router.addLiquidityETH{value: ethAmount}(
931             address(this),
932             tokenAmount,
933             0, // slippage is unavoidable
934             0, // slippage is unavoidable
935             address(this),
936             block.timestamp
937         );
938     }
939  
940     function swapBack() private {
941         uint256 contractBalance = balanceOf(address(this));
942         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
943         bool success;
944  
945         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
946  
947         if(emptyContractFull == false){
948             if(contractBalance > contractSellTreshold * 20){
949                 contractBalance = contractSellTreshold * 20;
950             }
951         }else{
952             contractBalance = balanceOf(address(this));
953         }
954         
955  
956         // Halve the amount of liquidity tokens
957         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
958         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
959  
960         uint256 initialETHBalance = address(this).balance;
961  
962         swapTokensForEth(amountToSwapForETH); 
963  
964         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
965  
966         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
967         uint256 ethForLiquidity = ethBalance - ethForDev;
968  
969  
970         tokensForLiquidity = 0;
971         tokensForDev = 0;
972  
973         if(liquidityTokens > 0 && ethForLiquidity > 0){
974             addLiquidity(liquidityTokens, ethForLiquidity);
975             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
976         }
977  
978         (success,) = address(devWallet).call{value: address(this).balance}("");
979     }
980 }