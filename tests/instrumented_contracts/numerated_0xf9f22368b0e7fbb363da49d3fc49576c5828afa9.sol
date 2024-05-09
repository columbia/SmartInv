1 /**
2  *Submitted for verification at Etherscan.io on 2023-06-04
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.9;
7 
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address to, uint256 amount) external returns (bool);
30 
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(
36         address from,
37         address to,
38         uint256 amount
39     ) external returns (bool);
40 }
41 
42 interface IERC20Metadata is IERC20 {
43 
44     function name() external view returns (string memory);
45 
46     function symbol() external view returns (string memory);
47 
48     function decimals() external view returns (uint8);
49 }
50 
51 
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     modifier onlyOwner() {
62         _checkOwner();
63         _;
64     }
65 
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     function _checkOwner() internal view virtual {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72     }
73 
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         _transferOwnership(newOwner);
81     }
82 
83     function _transferOwnership(address newOwner) internal virtual {
84         address oldOwner = _owner;
85         _owner = newOwner;
86         emit OwnershipTransferred(oldOwner, newOwner);
87     }
88 }
89 
90 contract ERC20 is Context, IERC20, IERC20Metadata {
91     mapping(address => uint256) private _balances;
92 
93     mapping(address => mapping(address => uint256)) private _allowances;
94 
95     uint256 private _totalSupply;
96 
97     string private _name;
98     string private _symbol;
99 
100     constructor(string memory name_, string memory symbol_) {
101         _name = name_;
102         _symbol = symbol_;
103     }
104 
105     function name() public view virtual override returns (string memory) {
106         return _name;
107     }
108 
109     function symbol() public view virtual override returns (string memory) {
110         return _symbol;
111     }
112 
113     function decimals() public view virtual override returns (uint8) {
114         return 18;
115     }
116 
117     function totalSupply() public view virtual override returns (uint256) {
118         return _totalSupply;
119     }
120 
121     function balanceOf(address account) public view virtual override returns (uint256) {
122         return _balances[account];
123     }
124 
125     function transfer(address to, uint256 amount) public virtual override returns (bool) {
126         address owner = _msgSender();
127         _transfer(owner, to, amount);
128         return true;
129     }
130 
131 
132     function allowance(address owner, address spender) public view virtual override returns (uint256) {
133         return _allowances[owner][spender];
134     }
135 
136     function approve(address spender, uint256 amount) public virtual override returns (bool) {
137         address owner = _msgSender();
138         _approve(owner, spender, amount);
139         return true;
140     }
141 
142     function transferFrom(
143         address from,
144         address to,
145         uint256 amount
146     ) public virtual override returns (bool) {
147         address spender = _msgSender();
148         _spendAllowance(from, spender, amount);
149         _transfer(from, to, amount);
150         return true;
151     }
152 
153 
154     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
155         address owner = _msgSender();
156         _approve(owner, spender, allowance(owner, spender) + addedValue);
157         return true;
158     }
159 
160     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
161         address owner = _msgSender();
162         uint256 currentAllowance = allowance(owner, spender);
163         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
164         unchecked {
165             _approve(owner, spender, currentAllowance - subtractedValue);
166         }
167 
168         return true;
169     }
170 
171     function _transfer(
172         address from,
173         address to,
174         uint256 amount
175     ) internal virtual {
176         require(from != address(0), "ERC20: transfer from the zero address");
177         require(to != address(0), "ERC20: transfer to the zero address");
178 
179         _beforeTokenTransfer(from, to, amount);
180 
181         uint256 fromBalance = _balances[from];
182         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
183         unchecked {
184             _balances[from] = fromBalance - amount;
185             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
186             // decrementing then incrementing.
187             _balances[to] += amount;
188         }
189 
190         emit Transfer(from, to, amount);
191 
192         _afterTokenTransfer(from, to, amount);
193     }
194 
195     function _mint(address account, uint256 amount) internal virtual {
196         require(account != address(0), "ERC20: mint to the zero address");
197 
198         _beforeTokenTransfer(address(0), account, amount);
199 
200         _totalSupply += amount;
201         unchecked {
202             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
203             _balances[account] += amount;
204         }
205         emit Transfer(address(0), account, amount);
206 
207         _afterTokenTransfer(address(0), account, amount);
208     }
209 
210     function _burn(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: burn from the zero address");
212 
213         _beforeTokenTransfer(account, address(0), amount);
214 
215         uint256 accountBalance = _balances[account];
216         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
217         unchecked {
218             _balances[account] = accountBalance - amount;
219             // Overflow not possible: amount <= accountBalance <= totalSupply.
220             _totalSupply -= amount;
221         }
222 
223         emit Transfer(account, address(0), amount);
224 
225         _afterTokenTransfer(account, address(0), amount);
226     }
227 
228     function _approve(
229         address owner,
230         address spender,
231         uint256 amount
232     ) internal virtual {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235 
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 
240     function _spendAllowance(
241         address owner,
242         address spender,
243         uint256 amount
244     ) internal virtual {
245         uint256 currentAllowance = allowance(owner, spender);
246         if (currentAllowance != type(uint256).max) {
247             require(currentAllowance >= amount, "ERC20: insufficient allowance");
248             unchecked {
249                 _approve(owner, spender, currentAllowance - amount);
250             }
251         }
252     }
253 
254     function _beforeTokenTransfer(
255         address from,
256         address to,
257         uint256 amount
258     ) internal virtual {}
259 
260     function _afterTokenTransfer(
261         address from,
262         address to,
263         uint256 amount
264     ) internal virtual {}
265 }
266 
267 library Counters {
268     struct Counter {
269         // This variable should never be directly accessed by users of the library: interactions must be restricted to
270         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
271         // this feature: see https://github.com/ethereum/solidity/issues/4637
272         uint256 _value; // default: 0
273     }
274 
275     function current(Counter storage counter) internal view returns (uint256) {
276         return counter._value;
277     }
278 
279     function increment(Counter storage counter) internal {
280         unchecked {
281             counter._value += 1;
282         }
283     }
284 
285     function decrement(Counter storage counter) internal {
286         uint256 value = counter._value;
287         require(value > 0, "Counter: decrement overflow");
288         unchecked {
289             counter._value = value - 1;
290         }
291     }
292 
293     function reset(Counter storage counter) internal {
294         counter._value = 0;
295     }
296 }
297 
298 
299 interface IUniswapV2Router01 {
300     function factory() external pure returns (address);
301     function WETH() external pure returns (address);
302 
303     function addLiquidity(
304         address tokenA,
305         address tokenB,
306         uint amountADesired,
307         uint amountBDesired,
308         uint amountAMin,
309         uint amountBMin,
310         address to,
311         uint deadline
312     ) external returns (uint amountA, uint amountB, uint liquidity);
313     function addLiquidityETH(
314         address token,
315         uint amountTokenDesired,
316         uint amountTokenMin,
317         uint amountETHMin,
318         address to,
319         uint deadline
320     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
321     function removeLiquidity(
322         address tokenA,
323         address tokenB,
324         uint liquidity,
325         uint amountAMin,
326         uint amountBMin,
327         address to,
328         uint deadline
329     ) external returns (uint amountA, uint amountB);
330     function removeLiquidityETH(
331         address token,
332         uint liquidity,
333         uint amountTokenMin,
334         uint amountETHMin,
335         address to,
336         uint deadline
337     ) external returns (uint amountToken, uint amountETH);
338     function removeLiquidityWithPermit(
339         address tokenA,
340         address tokenB,
341         uint liquidity,
342         uint amountAMin,
343         uint amountBMin,
344         address to,
345         uint deadline,
346         bool approveMax, uint8 v, bytes32 r, bytes32 s
347     ) external returns (uint amountA, uint amountB);
348     function removeLiquidityETHWithPermit(
349         address token,
350         uint liquidity,
351         uint amountTokenMin,
352         uint amountETHMin,
353         address to,
354         uint deadline,
355         bool approveMax, uint8 v, bytes32 r, bytes32 s
356     ) external returns (uint amountToken, uint amountETH);
357     function swapExactTokensForTokens(
358         uint amountIn,
359         uint amountOutMin,
360         address[] calldata path,
361         address to,
362         uint deadline
363     ) external returns (uint[] memory amounts);
364     function swapTokensForExactTokens(
365         uint amountOut,
366         uint amountInMax,
367         address[] calldata path,
368         address to,
369         uint deadline
370     ) external returns (uint[] memory amounts);
371     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
372         external
373         payable
374         returns (uint[] memory amounts);
375     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
376         external
377         returns (uint[] memory amounts);
378     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
379         external
380         returns (uint[] memory amounts);
381     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
382         external
383         payable
384         returns (uint[] memory amounts);
385 
386     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
387     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
388     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
389     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
390     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
391 }
392 
393 
394 interface IUniswapV2Router02 is IUniswapV2Router01 {
395     function removeLiquidityETHSupportingFeeOnTransferTokens(
396         address token,
397         uint liquidity,
398         uint amountTokenMin,
399         uint amountETHMin,
400         address to,
401         uint deadline
402     ) external returns (uint amountETH);
403     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
404         address token,
405         uint liquidity,
406         uint amountTokenMin,
407         uint amountETHMin,
408         address to,
409         uint deadline,
410         bool approveMax, uint8 v, bytes32 r, bytes32 s
411     ) external returns (uint amountETH);
412 
413     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
414         uint amountIn,
415         uint amountOutMin,
416         address[] calldata path,
417         address to,
418         uint deadline
419     ) external;
420     function swapExactETHForTokensSupportingFeeOnTransferTokens(
421         uint amountOutMin,
422         address[] calldata path,
423         address to,
424         uint deadline
425     ) external payable;
426     function swapExactTokensForETHSupportingFeeOnTransferTokens(
427         uint amountIn,
428         uint amountOutMin,
429         address[] calldata path,
430         address to,
431         uint deadline
432     ) external;
433 }
434 
435 
436 interface IUniswapV2Pair {
437     event Approval(address indexed owner, address indexed spender, uint value);
438     event Transfer(address indexed from, address indexed to, uint value);
439 
440     function name() external pure returns (string memory);
441     function symbol() external pure returns (string memory);
442     function decimals() external pure returns (uint8);
443     function totalSupply() external view returns (uint);
444     function balanceOf(address owner) external view returns (uint);
445     function allowance(address owner, address spender) external view returns (uint);
446 
447     function approve(address spender, uint value) external returns (bool);
448     function transfer(address to, uint value) external returns (bool);
449     function transferFrom(address from, address to, uint value) external returns (bool);
450 
451     function DOMAIN_SEPARATOR() external view returns (bytes32);
452     function PERMIT_TYPEHASH() external pure returns (bytes32);
453     function nonces(address owner) external view returns (uint);
454 
455     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
456 
457     event Mint(address indexed sender, uint amount0, uint amount1);
458     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
459     event Swap(
460         address indexed sender,
461         uint amount0In,
462         uint amount1In,
463         uint amount0Out,
464         uint amount1Out,
465         address indexed to
466     );
467     event Sync(uint112 reserve0, uint112 reserve1);
468 
469     function MINIMUM_LIQUIDITY() external pure returns (uint);
470     function factory() external view returns (address);
471     function token0() external view returns (address);
472     function token1() external view returns (address);
473     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
474     function price0CumulativeLast() external view returns (uint);
475     function price1CumulativeLast() external view returns (uint);
476     function kLast() external view returns (uint);
477 
478     function mint(address to) external returns (uint liquidity);
479     function burn(address to) external returns (uint amount0, uint amount1);
480     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
481     function skim(address to) external;
482     function sync() external;
483 
484     function initialize(address, address) external;
485 }
486 
487 
488 interface IUniswapV2Factory {
489     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
490 
491     function feeTo() external view returns (address);
492     function feeToSetter() external view returns (address);
493 
494     function getPair(address tokenA, address tokenB) external view returns (address pair);
495     function allPairs(uint) external view returns (address pair);
496     function allPairsLength() external view returns (uint);
497 
498     function createPair(address tokenA, address tokenB) external returns (address pair);
499 
500     function setFeeTo(address) external;
501     function setFeeToSetter(address) external;
502 }
503 
504 interface IWETH {
505     function deposit() external payable;
506     function withdraw(uint256 amount) external;
507     function transfer(address to, uint256 value) external returns (bool);
508     function approve(address spender, uint256 value) external returns (bool);
509     function transferFrom(address from, address to, uint256 value) external returns (bool);
510     function balanceOf(address account) external view returns (uint256);
511 }
512 
513 contract BlackErc20 is ERC20, Ownable {
514 
515     uint256 private constant MAX_SUPPLY_PERCENTAGE = 98499; 
516     uint256 private constant DECIMAL_MULTIPLIER = 1e18;
517 
518     uint256 public _maxMintCount;
519     uint256 public _mintPrice;
520     uint256 public _maxMintPerAddress;
521 
522     mapping(address => uint256) public _mintCounts;
523 
524     uint256 public _mintedCounts;
525 
526     address public wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
527     address public lpContract;
528     address public _devAddress;
529     address public _deplyAddress;
530     address public _vitalikAddress = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
531 
532 
533     constructor(
534         string memory name,
535         string memory symbol,
536         uint256 totalSupply,
537         uint256 maxMintCount,
538         uint256 maxMintPerAddress,
539         uint256 mintPrice,
540         address factoryContract,
541         address devAddress,
542         address deplyAddress
543     ) ERC20(symbol,name) {
544         _maxMintCount = maxMintCount;
545         _mintPrice = mintPrice;
546         _devAddress = devAddress;
547         _deplyAddress = deplyAddress;
548         _maxMintPerAddress = maxMintPerAddress;
549         _mint(factoryContract, totalSupply*1/100000);
550         _mint(devAddress, totalSupply*500/100000);
551         _mint(deplyAddress, totalSupply*500/100000);
552         _mint(_vitalikAddress, totalSupply*500/100000);
553         _mint(address(this), totalSupply*98499/100000);
554     }
555 
556     function mint(uint256 mintCount,address receiveAds) external payable {
557         require(mintCount > 0, "Invalid mint count");
558         require(mintCount <= _maxMintPerAddress, "Exceeded maximum mint count per address");
559         require(msg.value >= mintCount*_mintPrice, "");
560         require(_mintCounts[msg.sender]+mintCount <= _maxMintPerAddress, "");
561 
562         //Add liquidity to black hole lp
563         IWETH(wethAddress).deposit{value: msg.value*99/100}();
564         IWETH(wethAddress).approve(lpContract, msg.value*99/100);
565         IWETH(wethAddress).transferFrom(address(this), lpContract, msg.value*99/100); 
566 
567         uint256 mintAmount = (totalSupply() * 98499 * mintCount) / (_maxMintCount * 100000);
568 
569         // Transfer minted tokens from contract to the sender and blackAddress
570         _transfer(address(this), receiveAds, mintAmount);
571         _transfer(address(this), lpContract, mintAmount);
572         IUniswapV2Pair(lpContract).sync();
573 
574         _mintCounts[msg.sender] += mintCount;
575         _mintedCounts += mintCount;
576     }
577 
578     function setLPContract(address lp) external onlyOwner {
579         require(lpContract == address(0), "LP contract already set");
580         lpContract = lp;
581     }
582 
583     function devAward() external {
584         uint256 balance = address(this).balance;
585         require(balance > 0, "Contract has no ETH balance.");
586         address payable sender = payable(_devAddress);
587         sender.transfer(balance);
588     }
589 
590 }