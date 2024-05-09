1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address to, uint256 amount) external returns (bool);
26 
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address from,
33         address to,
34         uint256 amount
35     ) external returns (bool);
36 }
37 
38 interface IERC20Metadata is IERC20 {
39 
40     function name() external view returns (string memory);
41 
42     function symbol() external view returns (string memory);
43 
44     function decimals() external view returns (uint8);
45 }
46 
47 
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     modifier onlyOwner() {
58         _checkOwner();
59         _;
60     }
61 
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     function _checkOwner() internal view virtual {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68     }
69 
70     function renounceOwnership() public virtual onlyOwner {
71         _transferOwnership(address(0));
72     }
73 
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         _transferOwnership(newOwner);
77     }
78 
79     function _transferOwnership(address newOwner) internal virtual {
80         address oldOwner = _owner;
81         _owner = newOwner;
82         emit OwnershipTransferred(oldOwner, newOwner);
83     }
84 }
85 
86 contract ERC20 is Context, IERC20, IERC20Metadata {
87     mapping(address => uint256) private _balances;
88 
89     mapping(address => mapping(address => uint256)) private _allowances;
90 
91     uint256 private _totalSupply;
92 
93     string private _name;
94     string private _symbol;
95 
96     constructor(string memory name_, string memory symbol_) {
97         _name = name_;
98         _symbol = symbol_;
99     }
100 
101     function name() public view virtual override returns (string memory) {
102         return _name;
103     }
104 
105     function symbol() public view virtual override returns (string memory) {
106         return _symbol;
107     }
108 
109     function decimals() public view virtual override returns (uint8) {
110         return 18;
111     }
112 
113     function totalSupply() public view virtual override returns (uint256) {
114         return _totalSupply;
115     }
116 
117     function balanceOf(address account) public view virtual override returns (uint256) {
118         return _balances[account];
119     }
120 
121     function transfer(address to, uint256 amount) public virtual override returns (bool) {
122         address owner = _msgSender();
123         _transfer(owner, to, amount);
124         return true;
125     }
126 
127 
128     function allowance(address owner, address spender) public view virtual override returns (uint256) {
129         return _allowances[owner][spender];
130     }
131 
132     function approve(address spender, uint256 amount) public virtual override returns (bool) {
133         address owner = _msgSender();
134         _approve(owner, spender, amount);
135         return true;
136     }
137 
138     function transferFrom(
139         address from,
140         address to,
141         uint256 amount
142     ) public virtual override returns (bool) {
143         address spender = _msgSender();
144         _spendAllowance(from, spender, amount);
145         _transfer(from, to, amount);
146         return true;
147     }
148 
149 
150     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
151         address owner = _msgSender();
152         _approve(owner, spender, allowance(owner, spender) + addedValue);
153         return true;
154     }
155 
156     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
157         address owner = _msgSender();
158         uint256 currentAllowance = allowance(owner, spender);
159         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
160         unchecked {
161             _approve(owner, spender, currentAllowance - subtractedValue);
162         }
163 
164         return true;
165     }
166 
167     function _transfer(
168         address from,
169         address to,
170         uint256 amount
171     ) internal virtual {
172         require(from != address(0), "ERC20: transfer from the zero address");
173         require(to != address(0), "ERC20: transfer to the zero address");
174 
175         _beforeTokenTransfer(from, to, amount);
176 
177         uint256 fromBalance = _balances[from];
178         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
179         unchecked {
180             _balances[from] = fromBalance - amount;
181             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
182             // decrementing then incrementing.
183             _balances[to] += amount;
184         }
185 
186         emit Transfer(from, to, amount);
187 
188         _afterTokenTransfer(from, to, amount);
189     }
190 
191     function _mint(address account, uint256 amount) internal virtual {
192         require(account != address(0), "ERC20: mint to the zero address");
193 
194         _beforeTokenTransfer(address(0), account, amount);
195 
196         _totalSupply += amount;
197         unchecked {
198             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
199             _balances[account] += amount;
200         }
201         emit Transfer(address(0), account, amount);
202 
203         _afterTokenTransfer(address(0), account, amount);
204     }
205 
206     function _burn(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: burn from the zero address");
208 
209         _beforeTokenTransfer(account, address(0), amount);
210 
211         uint256 accountBalance = _balances[account];
212         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
213         unchecked {
214             _balances[account] = accountBalance - amount;
215             // Overflow not possible: amount <= accountBalance <= totalSupply.
216             _totalSupply -= amount;
217         }
218 
219         emit Transfer(account, address(0), amount);
220 
221         _afterTokenTransfer(account, address(0), amount);
222     }
223 
224     function _approve(
225         address owner,
226         address spender,
227         uint256 amount
228     ) internal virtual {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231 
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _spendAllowance(
237         address owner,
238         address spender,
239         uint256 amount
240     ) internal virtual {
241         uint256 currentAllowance = allowance(owner, spender);
242         if (currentAllowance != type(uint256).max) {
243             require(currentAllowance >= amount, "ERC20: insufficient allowance");
244             unchecked {
245                 _approve(owner, spender, currentAllowance - amount);
246             }
247         }
248     }
249 
250     function _beforeTokenTransfer(
251         address from,
252         address to,
253         uint256 amount
254     ) internal virtual {}
255 
256     function _afterTokenTransfer(
257         address from,
258         address to,
259         uint256 amount
260     ) internal virtual {}
261 }
262 
263 library Counters {
264     struct Counter {
265         // This variable should never be directly accessed by users of the library: interactions must be restricted to
266         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
267         // this feature: see https://github.com/ethereum/solidity/issues/4637
268         uint256 _value; // default: 0
269     }
270 
271     function current(Counter storage counter) internal view returns (uint256) {
272         return counter._value;
273     }
274 
275     function increment(Counter storage counter) internal {
276         unchecked {
277             counter._value += 1;
278         }
279     }
280 
281     function decrement(Counter storage counter) internal {
282         uint256 value = counter._value;
283         require(value > 0, "Counter: decrement overflow");
284         unchecked {
285             counter._value = value - 1;
286         }
287     }
288 
289     function reset(Counter storage counter) internal {
290         counter._value = 0;
291     }
292 }
293 
294 
295 interface IUniswapV2Router01 {
296     function factory() external pure returns (address);
297     function WETH() external pure returns (address);
298 
299     function addLiquidity(
300         address tokenA,
301         address tokenB,
302         uint amountADesired,
303         uint amountBDesired,
304         uint amountAMin,
305         uint amountBMin,
306         address to,
307         uint deadline
308     ) external returns (uint amountA, uint amountB, uint liquidity);
309     function addLiquidityETH(
310         address token,
311         uint amountTokenDesired,
312         uint amountTokenMin,
313         uint amountETHMin,
314         address to,
315         uint deadline
316     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
317     function removeLiquidity(
318         address tokenA,
319         address tokenB,
320         uint liquidity,
321         uint amountAMin,
322         uint amountBMin,
323         address to,
324         uint deadline
325     ) external returns (uint amountA, uint amountB);
326     function removeLiquidityETH(
327         address token,
328         uint liquidity,
329         uint amountTokenMin,
330         uint amountETHMin,
331         address to,
332         uint deadline
333     ) external returns (uint amountToken, uint amountETH);
334     function removeLiquidityWithPermit(
335         address tokenA,
336         address tokenB,
337         uint liquidity,
338         uint amountAMin,
339         uint amountBMin,
340         address to,
341         uint deadline,
342         bool approveMax, uint8 v, bytes32 r, bytes32 s
343     ) external returns (uint amountA, uint amountB);
344     function removeLiquidityETHWithPermit(
345         address token,
346         uint liquidity,
347         uint amountTokenMin,
348         uint amountETHMin,
349         address to,
350         uint deadline,
351         bool approveMax, uint8 v, bytes32 r, bytes32 s
352     ) external returns (uint amountToken, uint amountETH);
353     function swapExactTokensForTokens(
354         uint amountIn,
355         uint amountOutMin,
356         address[] calldata path,
357         address to,
358         uint deadline
359     ) external returns (uint[] memory amounts);
360     function swapTokensForExactTokens(
361         uint amountOut,
362         uint amountInMax,
363         address[] calldata path,
364         address to,
365         uint deadline
366     ) external returns (uint[] memory amounts);
367     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
368         external
369         payable
370         returns (uint[] memory amounts);
371     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
372         external
373         returns (uint[] memory amounts);
374     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
375         external
376         returns (uint[] memory amounts);
377     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
378         external
379         payable
380         returns (uint[] memory amounts);
381 
382     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
383     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
384     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
385     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
386     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
387 }
388 
389 
390 interface IUniswapV2Router02 is IUniswapV2Router01 {
391     function removeLiquidityETHSupportingFeeOnTransferTokens(
392         address token,
393         uint liquidity,
394         uint amountTokenMin,
395         uint amountETHMin,
396         address to,
397         uint deadline
398     ) external returns (uint amountETH);
399     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
400         address token,
401         uint liquidity,
402         uint amountTokenMin,
403         uint amountETHMin,
404         address to,
405         uint deadline,
406         bool approveMax, uint8 v, bytes32 r, bytes32 s
407     ) external returns (uint amountETH);
408 
409     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
410         uint amountIn,
411         uint amountOutMin,
412         address[] calldata path,
413         address to,
414         uint deadline
415     ) external;
416     function swapExactETHForTokensSupportingFeeOnTransferTokens(
417         uint amountOutMin,
418         address[] calldata path,
419         address to,
420         uint deadline
421     ) external payable;
422     function swapExactTokensForETHSupportingFeeOnTransferTokens(
423         uint amountIn,
424         uint amountOutMin,
425         address[] calldata path,
426         address to,
427         uint deadline
428     ) external;
429 }
430 
431 
432 interface IUniswapV2Pair {
433     event Approval(address indexed owner, address indexed spender, uint value);
434     event Transfer(address indexed from, address indexed to, uint value);
435 
436     function name() external pure returns (string memory);
437     function symbol() external pure returns (string memory);
438     function decimals() external pure returns (uint8);
439     function totalSupply() external view returns (uint);
440     function balanceOf(address owner) external view returns (uint);
441     function allowance(address owner, address spender) external view returns (uint);
442 
443     function approve(address spender, uint value) external returns (bool);
444     function transfer(address to, uint value) external returns (bool);
445     function transferFrom(address from, address to, uint value) external returns (bool);
446 
447     function DOMAIN_SEPARATOR() external view returns (bytes32);
448     function PERMIT_TYPEHASH() external pure returns (bytes32);
449     function nonces(address owner) external view returns (uint);
450 
451     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
452 
453     event Mint(address indexed sender, uint amount0, uint amount1);
454     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
455     event Swap(
456         address indexed sender,
457         uint amount0In,
458         uint amount1In,
459         uint amount0Out,
460         uint amount1Out,
461         address indexed to
462     );
463     event Sync(uint112 reserve0, uint112 reserve1);
464 
465     function MINIMUM_LIQUIDITY() external pure returns (uint);
466     function factory() external view returns (address);
467     function token0() external view returns (address);
468     function token1() external view returns (address);
469     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
470     function price0CumulativeLast() external view returns (uint);
471     function price1CumulativeLast() external view returns (uint);
472     function kLast() external view returns (uint);
473 
474     function mint(address to) external returns (uint liquidity);
475     function burn(address to) external returns (uint amount0, uint amount1);
476     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
477     function skim(address to) external;
478     function sync() external;
479 
480     function initialize(address, address) external;
481 }
482 
483 
484 interface IUniswapV2Factory {
485     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
486 
487     function feeTo() external view returns (address);
488     function feeToSetter() external view returns (address);
489 
490     function getPair(address tokenA, address tokenB) external view returns (address pair);
491     function allPairs(uint) external view returns (address pair);
492     function allPairsLength() external view returns (uint);
493 
494     function createPair(address tokenA, address tokenB) external returns (address pair);
495 
496     function setFeeTo(address) external;
497     function setFeeToSetter(address) external;
498 }
499 
500 interface IWETH {
501     function deposit() external payable;
502     function withdraw(uint256 amount) external;
503     function transfer(address to, uint256 value) external returns (bool);
504     function approve(address spender, uint256 value) external returns (bool);
505     function transferFrom(address from, address to, uint256 value) external returns (bool);
506     function balanceOf(address account) external view returns (uint256);
507 }
508 
509 contract GooseToken is ERC20, Ownable {
510     uint256 private constant TOTAL_MINT_PERCENTAGE = 95999; 
511     uint256 private constant INIT_LP_PERCENTAGE = 1; 
512     uint256 private constant TOTAL_SUPPLY = 21000000 * 1e18;
513 
514     uint256 public _maxMintCount;
515     uint256 public _mintPrice;
516     uint256 public _maxMintPerAddress;
517 
518     mapping(address => uint256) public _mintCounts;
519     uint256 public _mintedCounts;
520 
521     IUniswapV2Factory private immutable uniswapFactory;
522     IUniswapV2Router02 private immutable uniswapRouter;
523     IWETH private immutable WETH;
524     address private immutable blackHole = 0x000000000000000000000000000000000000dEaD;
525     address public immutable _vitalikAddress = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
526     
527     IUniswapV2Pair public lpPair;
528     uint256 public _mintStart;
529     bool public _launched = false;
530 
531     constructor(
532         address factory,
533         address swapRouter,
534         address weth,
535         address devAddress,
536         uint256 maxMintCount,
537         uint256 maxMintPerAddress,
538         uint256 mintPrice
539     ) ERC20("GooseTown Token", "GOOSE") {
540         uniswapFactory = IUniswapV2Factory(factory);
541         uniswapRouter = IUniswapV2Router02(swapRouter);
542         WETH = IWETH(weth);
543 
544         _maxMintCount = maxMintCount;
545         _maxMintPerAddress = maxMintPerAddress;
546         _mintPrice = mintPrice;
547         _mintStart = 0;
548         
549         _mint(devAddress, TOTAL_SUPPLY * 2000/100000);
550         _mint(_vitalikAddress, TOTAL_SUPPLY * 2000/100000);
551         _mint(address(this), TOTAL_SUPPLY * 96000/100000);
552     }
553 
554     function launch(uint256 mintStart) external payable onlyOwner {
555         require(!_launched, "Already launched");
556         require(msg.value == 0.0001 ether, "Incorrect payment amount");
557         require(mintStart > block.timestamp, "Invalid mint start time");
558 
559         // add initial liquidity and send lp tokens to black hole
560         lpPair = IUniswapV2Pair(uniswapFactory.createPair(address(this), address(WETH)));
561         uint256 ethAmount = msg.value;
562         uint256 tokenAmount = TOTAL_SUPPLY * INIT_LP_PERCENTAGE / 100000;
563         _approve(address(this), address(uniswapRouter), tokenAmount);
564         uniswapRouter.addLiquidityETH{value: ethAmount}(
565             address(this),
566             tokenAmount,
567             0,
568             0,
569             blackHole,
570             block.timestamp
571         );
572 
573         _mintStart = mintStart;
574         _launched = true;
575     }
576 
577     function mint(uint256 mintCount) external payable {
578         require(msg.sender == tx.origin, "Only EOA");
579 
580         require(_launched, "Not launched");
581         require(block.timestamp >= _mintStart && _mintStart > 0, "Not started");
582         require(mintCount > 0, "Invalid mint count");
583         require(mintCount <= _maxMintPerAddress, "Exceeded maximum mint count per address");
584         require(msg.value >= mintCount*_mintPrice, "Insufficient ETH");
585         require(_mintCounts[msg.sender] + mintCount <= _maxMintPerAddress, "Exceeded maximum mint count per address");
586 
587         // mint
588         uint256 mintAmount = (totalSupply() * TOTAL_MINT_PERCENTAGE * mintCount) / (_maxMintCount * 100000);
589         _transfer(address(this), msg.sender, mintAmount);
590 
591         // add liquidity send lp tokens to black hole
592         _transfer(address(this), address(lpPair), mintAmount);
593         uint256 wethAmount = msg.value;
594         WETH.deposit{value: wethAmount}();
595         WETH.approve(address(lpPair), wethAmount);
596         WETH.transfer(address(lpPair), wethAmount); 
597         lpPair.sync();
598 
599         _mintCounts[msg.sender] += mintCount;
600         _mintedCounts += mintCount;
601     }
602 }