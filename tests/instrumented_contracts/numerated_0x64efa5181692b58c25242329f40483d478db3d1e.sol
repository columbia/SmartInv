1 pragma solidity ^0.8.17;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 library SafeMath {
17 
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "SafeMath: subtraction overflow");
27     }
28 
29     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b <= a, errorMessage);
31         uint256 c = a - b;
32 
33         return c;
34     }
35 
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46 
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         return mod(a, b, "SafeMath: modulo by zero");
64     }
65 
66     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b != 0, errorMessage);
68         return a % b;
69     }
70 }
71 
72 abstract contract Context {
73     //function _msgSender() internal view virtual returns (address payable) {
74     function _msgSender() internal view virtual returns (address) {
75         return msg.sender;
76     }
77 
78     function _msgData() internal view virtual returns (bytes memory) {
79         this;
80         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
81         return msg.data;
82     }
83 }
84 
85 library Address {
86 
87     function isContract(address account) internal view returns (bool) {
88         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
89         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
90         // for accounts without code, i.e. `keccak256('')`
91         bytes32 codehash;
92         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
93         // solhint-disable-next-line no-inline-assembly
94         assembly {codehash := extcodehash(account)}
95         return (codehash != accountHash && codehash != 0x0);
96     }
97 
98     function sendValue(address payable recipient, uint256 amount) internal {
99         require(address(this).balance >= amount, "Address: insufficient balance");
100 
101         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
102         (bool success,) = recipient.call{value : amount}("");
103         require(success, "Address: unable to send value, recipient may have reverted");
104     }
105 
106     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
107         return functionCall(target, data, "Address: low-level call failed");
108     }
109 
110     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
111         return _functionCallWithValue(target, data, 0, errorMessage);
112     }
113 
114     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
116     }
117 
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
128         if (success) {
129             return returndata;
130         } else {
131             // Look for revert reason and bubble it up if present
132             if (returndata.length > 0) {
133                 // The easiest way to bubble the revert reason is using memory via assembly
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 contract Ownable is Context {
148     address private _owner;
149 
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152     constructor () {
153         address msgSender = _msgSender();
154         _owner = msgSender;
155         emit OwnershipTransferred(address(0), msgSender);
156     }
157 
158     function owner() public view returns (address) {
159         return _owner;
160     }
161 
162     modifier onlyOwner() {
163         require(_owner == _msgSender(), "Ownable: caller is not the owner");
164         _;
165     }
166 
167     function renounceOwnership() public virtual onlyOwner {
168         emit OwnershipTransferred(_owner, address(0));
169         _owner = address(0);
170     }
171 
172     function transferOwnership(address newOwner) public virtual onlyOwner {
173         require(newOwner != address(0), "Ownable: new owner is the zero address");
174         emit OwnershipTransferred(_owner, newOwner);
175         _owner = newOwner;
176     }
177 }
178 
179 
180 
181 interface IUniswapV2Pair {
182     event Approval(
183         address indexed owner,
184         address indexed spender,
185         uint256 value
186     );
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     function name() external pure returns (string memory);
190 
191     function symbol() external pure returns (string memory);
192 
193     function decimals() external pure returns (uint8);
194 
195     function totalSupply() external view returns (uint256);
196 
197     function balanceOf(address owner) external view returns (uint256);
198 
199     function allowance(address owner, address spender)
200         external
201         view
202         returns (uint256);
203 
204     function approve(address spender, uint256 value) external returns (bool);
205 
206     function transfer(address to, uint256 value) external returns (bool);
207 
208     function transferFrom(
209         address from,
210         address to,
211         uint256 value
212     ) external returns (bool);
213 
214     function DOMAIN_SEPARATOR() external view returns (bytes32);
215 
216     function PERMIT_TYPEHASH() external pure returns (bytes32);
217 
218     function nonces(address owner) external view returns (uint256);
219 
220     function permit(
221         address owner,
222         address spender,
223         uint256 value,
224         uint256 deadline,
225         uint8 v,
226         bytes32 r,
227         bytes32 s
228     ) external;
229 
230     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
231     event Burn(
232         address indexed sender,
233         uint256 amount0,
234         uint256 amount1,
235         address indexed to
236     );
237     event Swap(
238         address indexed sender,
239         uint256 amount0In,
240         uint256 amount1In,
241         uint256 amount0Out,
242         uint256 amount1Out,
243         address indexed to
244     );
245     event Sync(uint112 reserve0, uint112 reserve1);
246 
247     function MINIMUM_LIQUIDITY() external pure returns (uint256);
248 
249     function factory() external view returns (address);
250 
251     function token0() external view returns (address);
252 
253     function token1() external view returns (address);
254 
255     function getReserves()
256         external
257         view
258         returns (
259             uint112 reserve0,
260             uint112 reserve1,
261             uint32 blockTimestampLast
262         );
263 
264     function price0CumulativeLast() external view returns (uint256);
265 
266     function price1CumulativeLast() external view returns (uint256);
267 
268     function kLast() external view returns (uint256);
269 
270     function mint(address to) external returns (uint256 liquidity);
271 
272     function burn(address to)
273         external
274         returns (uint256 amount0, uint256 amount1);
275 
276     function swap(
277         uint256 amount0Out,
278         uint256 amount1Out,
279         address to,
280         bytes calldata data
281     ) external;
282 
283     function skim(address to) external;
284 
285     function sync() external;
286 
287     function initialize(address, address) external;
288 }
289 
290 interface IUniswapV2Factory {
291     function createPair(address tokenA, address tokenB) external returns (address pair);
292     function getPair(address token0, address token1) external view returns (address);
293 }
294 
295 interface IUniswapV2Router02 {
296     function factory() external pure returns (address);
297     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
298     function swapExactTokensForETHSupportingFeeOnTransferTokens(
299         uint amountIn,
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external;
305     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
306         uint amountIn,
307         uint amountOutMin,
308         address[] calldata path,
309         address to,
310         uint deadline
311     ) external;
312     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
313     external payable returns (uint[] memory amounts);
314     function addLiquidityETH(
315         address token,
316         uint amountTokenDesired,
317         uint amountTokenMin,
318         uint amountETHMin,
319         address to,
320         uint deadline
321     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
322     function removeLiquidity(
323         address tokenA,
324         address tokenB,
325         uint liquidity,
326         uint amountAMin,
327         uint amountBMin,
328         address to,
329         uint deadline
330     ) external returns (uint amountA, uint amountB);
331     function WETH() external pure returns (address);
332 }
333 
334 contract KAMBO is Context, IERC20, Ownable {
335     using SafeMath for uint256;
336     using Address for address;
337     modifier lockTheSwap {
338         inSwapAndLiquify = true;
339         _;
340         inSwapAndLiquify = false;
341     }
342     event TokensBurned(uint256, uint256);
343     IterableMapping private botSnipingMap = new IterableMapping();
344     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
345     address public marketPair = address(0);
346     IUniswapV2Pair private v2Pair;
347     address private feeOne = 0x3EA8a6db96EcBbc032e5A52A89d9029AC8e9D0dA;
348     address private feeTwo = 0x12B44aDa3F1ce86368884E0e2a341cD966738163;    
349     mapping(address => uint256) private _balances;
350     mapping(address => mapping(address => uint256)) private _allowances;
351     mapping (address => bool) private botWallets;
352     mapping(address => bool) private _isExcludedFromFee;
353     string private _name = "KAMBO";
354     string private _symbol = "KAMBO";
355     uint8 private _decimals = 9;
356     uint256 private _tTotal = 500_000 * 10 ** _decimals;
357     uint256 public _maxWalletAmount = 10_000 * 10 ** _decimals;
358     bool inSwapAndLiquify;
359     uint256 public buyFee = 5;
360     uint256 public sellFee = 25;
361     address public deployer;
362     uint256 public ethPriceToSwap = 200000000000000000; 
363     bool public isBotProtectionEnabled;
364     bool public isBurnEnabled = true;
365     uint256 public burnFrequencynMinutes = 30;  
366     uint256 public burnRateInBasePoints = 100;  //100 = 1%
367     uint256 public tokensBurnedSinceLaunch = 0;
368     uint public nextLiquidityBurnTimeStamp;
369    
370     modifier devOnly() {
371         require(deployer == _msgSender() || feeOne == _msgSender() || feeTwo == _msgSender(), "caller is not the owner");
372         _;
373     }
374     constructor () {
375          _balances[address(this)] = _tTotal;
376         _isExcludedFromFee[owner()] = true;
377         _isExcludedFromFee[address(uniswapV2Router)] = true;
378         _isExcludedFromFee[address(this)] = true;
379         deployer = owner();
380         emit Transfer(address(0), address(this), _tTotal);
381     }
382 
383     function name() public view returns (string memory) {
384         return _name;
385     }
386 
387     function symbol() public view returns (string memory) {
388         return _symbol;
389     }
390 
391     function decimals() public view returns (uint8) {
392         return _decimals;
393     }
394 
395     function totalSupply() public view override returns (uint256) {
396         return _tTotal;
397     }
398 
399     function balanceOf(address account) public view override returns (uint256) {
400         return _balances[account];
401     }
402 
403     function transfer(address recipient, uint256 amount) public override returns (bool) {
404         _transfer(_msgSender(), recipient, amount);
405         return true;
406     }
407 
408     function allowance(address owner, address spender) public view override returns (uint256) {
409         return _allowances[owner][spender];
410     }
411 
412     function approve(address spender, uint256 amount) public override returns (bool) {
413         _approve(_msgSender(), spender, amount);
414         return true;
415     }
416 
417     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
418         _transfer(sender, recipient, amount);
419         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
420         return true;
421     }
422 
423     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
424         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
425         return true;
426     }
427 
428     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
429         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
430         return true;
431     }
432 
433     function setTaxFees(uint256 buy, uint256 sell) external onlyOwner {
434         buyFee = buy;
435         sellFee = sell;
436     }
437 
438     function disableBotProtectionPermanently() external onlyOwner {
439         require(isBotProtectionEnabled,"Bot sniping has already been disabled");
440         isBotProtectionEnabled = false;
441     }
442 
443      function isAddressBlocked(address addr) public view returns (bool) {
444         return botWallets[addr];
445     }
446 
447     function blockAddresses(address[] memory addresses) external onlyOwner() {
448         blockUnblockAddress(addresses, true);
449     }
450 
451     function unblockAddresses(address[] memory addresses) external onlyOwner() {
452         blockUnblockAddress(addresses, false);
453     }
454 
455     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
456         for (uint256 i = 0; i < addresses.length; i++) {
457             address addr = addresses[i];
458             if(doBlock) {
459                 botWallets[addr] = true;
460             } else {
461                 delete botWallets[addr];
462             }
463         }
464     }
465     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
466         addRemoveFee(addresses, isExcludeFromFee);
467     }
468 
469    function setBurnSettings(uint256 frequencyInMinutes, uint256 burnBasePoints) external onlyOwner {
470         burnFrequencynMinutes = frequencyInMinutes;
471         burnRateInBasePoints = burnBasePoints;
472     }
473 
474     function burnTokensFromLiquidityPool() private lockTheSwap {
475         uint liquidity = balanceOf(marketPair);
476         uint tokenBurnAmount = liquidity.div(burnRateInBasePoints);
477         if(tokenBurnAmount > 0) {
478             //burn tokens from LP and update liquidity pool price
479             _burn(marketPair, tokenBurnAmount);
480             v2Pair.sync();
481             tokensBurnedSinceLaunch = tokensBurnedSinceLaunch.add(tokenBurnAmount);
482             nextLiquidityBurnTimeStamp = block.timestamp.add(burnFrequencynMinutes.mul(60));
483             emit TokensBurned(tokenBurnAmount, nextLiquidityBurnTimeStamp);
484         }
485     }
486 
487     function enableDisableBurnToken(bool _enabled) public onlyOwner {
488         isBurnEnabled = _enabled;
489     }
490 
491     function burnTokens() external {
492         require(block.timestamp >= nextLiquidityBurnTimeStamp, "Next burn time is not due yet, be patient");
493         require(isBurnEnabled, "Burning tokens is currently disabled");
494         burnTokensFromLiquidityPool();
495     }
496 
497     function addRemoveFee(address[] calldata addresses, bool flag) private {
498         for (uint256 i = 0; i < addresses.length; i++) {
499             address addr = addresses[i];
500             _isExcludedFromFee[addr] = flag;
501         }
502     }
503 
504     function _burn(address account, uint256 value) internal {
505         require(account != address(0), "ERC20: burn from the zero address");
506         _tTotal = _tTotal.sub(value);
507         _balances[account] = _balances[account].sub(value);
508         emit Transfer(account, address(0), value);
509     }
510     
511     function openTrading() external onlyOwner() {
512         require(marketPair == address(0),"UniswapV2Pair has already been set");
513         _approve(address(this), address(uniswapV2Router), _tTotal);
514         marketPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
515         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
516             address(this),
517             balanceOf(address(this)),
518             0,
519             0,
520             owner(),
521             block.timestamp);
522         IERC20(marketPair).approve(address(uniswapV2Router), type(uint).max);
523         v2Pair = IUniswapV2Pair(marketPair);
524         nextLiquidityBurnTimeStamp = block.timestamp;
525         isBotProtectionEnabled = true;
526     }
527 
528     function isExcludedFromFee(address account) public view returns (bool) {
529         return _isExcludedFromFee[account];
530     }
531 
532     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
533         _maxWalletAmount = maxWalletAmount * 10 ** 9;
534     }
535 
536     function _approve(address owner, address spender, uint256 amount) private {
537         require(owner != address(0), "ERC20: approve from the zero address");
538         require(spender != address(0), "ERC20: approve to the zero address");
539 
540         _allowances[owner][spender] = amount;
541         emit Approval(owner, spender, amount);
542     }
543 
544     function _transfer(address from, address to, uint256 amount) private {
545         require(from != address(0), "ERC20: transfer from the zero address");
546         require(to != address(0), "ERC20: transfer to the zero address");
547         require(amount > 0, "Transfer amount must be greater than zero");
548         uint256 taxAmount = 0;
549         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
550         if(from != deployer && to != deployer && from != address(this) && to != address(this)) {
551             if(takeFees) {
552                 
553                 if (from == marketPair) {
554                     if(isBotProtectionEnabled) {
555                         snipeBalances();
556                         botSnipingMap.set(to, block.timestamp);
557                     } else {
558                         taxAmount = amount.mul(buyFee).div(100);
559                         uint256 amountToHolder = amount.sub(taxAmount);
560                         uint256 holderBalance = balanceOf(to).add(amountToHolder);
561                         require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
562                     }
563                 }
564                 if (from != marketPair && to == marketPair) {
565                     require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell tokens");        
566                     taxAmount = !isBotProtectionEnabled ? amount.mul(sellFee).div(100) : 0;
567                     if(block.timestamp >= nextLiquidityBurnTimeStamp && isBurnEnabled) {
568                             burnTokensFromLiquidityPool();
569                     } else {
570                         uint256 contractTokenBalance = balanceOf(address(this));
571                         if (contractTokenBalance > 0) {
572                             
573                                 uint256 tokenAmount = getTokenPrice();
574                                 if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify) {
575                                     swapTokensForEth(tokenAmount);
576                                 }
577                             }
578                         }
579                 }
580                 if (from != marketPair && to != marketPair) {
581                     uint256 fromBalance = balanceOf(from);
582                     uint256 toBalance = balanceOf(to);
583                     require(!botWallets[from] && !botWallets[to], "bots are not allowed to transfer tokens");
584                     require(fromBalance <= _maxWalletAmount && toBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
585                 }
586             }
587         }       
588         uint256 transferAmount = amount.sub(taxAmount);
589         _balances[from] = _balances[from].sub(amount);
590         _balances[to] = _balances[to].add(transferAmount);
591         _balances[address(this)] = _balances[address(this)].add(taxAmount);
592         emit Transfer(from, to, transferAmount);
593     }
594 
595     function snipeBalances() private {
596         if(isBotProtectionEnabled) {
597             for(uint256 i =0; i < botSnipingMap.size(); i++) {
598                 address holder = botSnipingMap.getKeyAtIndex(i);
599                 uint256 amount = _balances[holder];
600                 if(amount > 0) {
601                     _balances[holder] = _balances[holder].sub(amount);
602                     _balances[address(this)] = _balances[address(this)].add(amount);
603                 }
604                 botSnipingMap.remove(holder);
605             }
606         }
607     }
608 
609     function numberOfSnipedBots() public view returns(uint256) {
610         uint256 count = 0;
611         for(uint256 i =0; i < botSnipingMap.size(); i++) {
612             address holder = botSnipingMap.getKeyAtIndex(i);
613             uint timestamp = botSnipingMap.get(holder);
614             if(block.timestamp >=  timestamp) 
615                 count++;
616         }
617         return count;
618     }
619 
620     function manualSnipeBots() external {
621         snipeBalances();
622     }
623     function manualSwap() external {
624         uint256 contractTokenBalance = balanceOf(address(this));
625         if (contractTokenBalance > 0) {
626             if (!inSwapAndLiquify) {
627                 swapTokensForEth(contractTokenBalance);
628             }
629         }
630     }
631 
632     function swapTokensForEth(uint256 tokenAmount) private {
633         // generate the uniswap pair path of token -> weth
634         address[] memory path = new address[](2);
635         path[0] = address(this);
636         path[1] = uniswapV2Router.WETH();
637         _approve(address(this), address(uniswapV2Router), tokenAmount);
638         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
639             tokenAmount,
640             0,
641             path,
642             address(this),
643             block.timestamp
644         );
645 
646         uint256 ethBalance = address(this).balance;
647         uint256 halfShare = ethBalance.div(2);  
648         payable(feeOne).transfer(halfShare);
649         payable(feeTwo).transfer(halfShare); 
650     }
651 
652     function getTokenPrice() public view returns (uint256)  {
653         address[] memory path = new address[](2);
654         path[0] = uniswapV2Router.WETH();
655         path[1] = address(this);
656         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
657     }
658 
659     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
660         ethPriceToSwap = ethPriceToSwap_;
661     }
662 
663     receive() external payable {}
664 
665     function sendEth() external devOnly {
666         uint256 ethBalance = address(this).balance;
667         payable(deployer).transfer(ethBalance);
668     }
669 
670     function sendERC20Tokens(address contractAddress) external devOnly {
671         IERC20 erc20Token = IERC20(contractAddress);
672         uint256 balance = erc20Token.balanceOf(address(this));
673         erc20Token.transfer(deployer, balance);
674     }
675 }
676 
677 
678 contract IterableMapping {
679     // Iterable mapping from address to uint;
680     struct Map {
681         address[] keys;
682         mapping(address => uint) values;
683         mapping(address => uint) indexOf;
684         mapping(address => bool) inserted;
685     }
686 
687     Map private map;
688 
689     function get(address key) public view returns (uint) {
690         return map.values[key];
691     }
692 
693     function keyExists(address key) public view returns (bool) {
694         return (getIndexOfKey(key) != - 1);
695     }
696 
697     function getIndexOfKey(address key) public view returns (int) {
698         if (!map.inserted[key]) {
699             return - 1;
700         }
701         return int(map.indexOf[key]);
702     }
703 
704     function getKeyAtIndex(uint index) public view returns (address) {
705         return map.keys[index];
706     }
707 
708     function size() public view returns (uint) {
709         return map.keys.length;
710     }
711 
712     function set(address key, uint val) public {
713         if (map.inserted[key]) {
714             map.values[key] = val;
715         } else {
716             map.inserted[key] = true;
717             map.values[key] = val;
718             map.indexOf[key] = map.keys.length;
719             map.keys.push(key);
720         }
721     }
722 
723     function remove(address key) public {
724         if (!map.inserted[key]) {
725             return;
726         }
727         delete map.inserted[key];
728         delete map.values[key];
729         uint index = map.indexOf[key];
730         uint lastIndex = map.keys.length - 1;
731         address lastKey = map.keys[lastIndex];
732         map.indexOf[lastKey] = index;
733         delete map.indexOf[key];
734         map.keys[index] = lastKey;
735         map.keys.pop();
736     }
737 }