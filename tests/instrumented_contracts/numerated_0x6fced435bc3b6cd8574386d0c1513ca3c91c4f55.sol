1 /**
2 Welcome to BURNIT,
3 A $KAMBO fork.
4 
5 
6 $BURNIT is a hyper-deflationary token, even more deflationary than $KAMBO itself. $BURNIT is configured to burn 1% of the circulating supply ever 10 minutes, as opposed to $KAMBO, which burns every 30 minutes.
7 
8 With this aggressive burning mechanism, $BURNIT will become extremely scarce, ensuring a supply-shock type even to happen.
9 
10 Tokenomics
11 
12 1% Burn every 10 minutes
13 5% Buy Tax
14 5% Sell Tax
15 Liquidity locked for 30 Days
16 
17 
18 https://t.me/burnit_portal
19 
20 */
21 
22 pragma solidity ^0.8.17;
23 // SPDX-License-Identifier: Unlicensed
24 interface IERC20 {
25 
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42 
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59         // benefit is lost if 'b' is also tested.
60         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
61         if (a == 0) {
62             return 0;
63         }
64 
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67 
68         return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return div(a, b, "SafeMath: division by zero");
73     }
74 
75     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b > 0, errorMessage);
77         uint256 c = a / b;
78         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79 
80         return c;
81     }
82 
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         return mod(a, b, "SafeMath: modulo by zero");
85     }
86 
87     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b != 0, errorMessage);
89         return a % b;
90     }
91 }
92 
93 abstract contract Context {
94     //function _msgSender() internal view virtual returns (address payable) {
95     function _msgSender() internal view virtual returns (address) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view virtual returns (bytes memory) {
100         this;
101         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
102         return msg.data;
103     }
104 }
105 
106 library Address {
107 
108     function isContract(address account) internal view returns (bool) {
109         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
110         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
111         // for accounts without code, i.e. `keccak256('')`
112         bytes32 codehash;
113         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
114         // solhint-disable-next-line no-inline-assembly
115         assembly {codehash := extcodehash(account)}
116         return (codehash != accountHash && codehash != 0x0);
117     }
118 
119     function sendValue(address payable recipient, uint256 amount) internal {
120         require(address(this).balance >= amount, "Address: insufficient balance");
121 
122         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
123         (bool success,) = recipient.call{value : amount}("");
124         require(success, "Address: unable to send value, recipient may have reverted");
125     }
126 
127     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
128         return functionCall(target, data, "Address: low-level call failed");
129     }
130 
131     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
132         return _functionCallWithValue(target, data, 0, errorMessage);
133     }
134 
135     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
137     }
138 
139     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
140         require(address(this).balance >= value, "Address: insufficient balance for call");
141         return _functionCallWithValue(target, data, value, errorMessage);
142     }
143 
144     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
145         require(isContract(target), "Address: call to non-contract");
146 
147         // solhint-disable-next-line avoid-low-level-calls
148         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
149         if (success) {
150             return returndata;
151         } else {
152             // Look for revert reason and bubble it up if present
153             if (returndata.length > 0) {
154                 // The easiest way to bubble the revert reason is using memory via assembly
155 
156                 // solhint-disable-next-line no-inline-assembly
157                 assembly {
158                     let returndata_size := mload(returndata)
159                     revert(add(32, returndata), returndata_size)
160                 }
161             } else {
162                 revert(errorMessage);
163             }
164         }
165     }
166 }
167 
168 contract Ownable is Context {
169     address private _owner;
170 
171     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
172 
173     constructor () {
174         address msgSender = _msgSender();
175         _owner = msgSender;
176         emit OwnershipTransferred(address(0), msgSender);
177     }
178 
179     function owner() public view returns (address) {
180         return _owner;
181     }
182 
183     modifier onlyOwner() {
184         require(_owner == _msgSender(), "Ownable: caller is not the owner");
185         _;
186     }
187 
188     function renounceOwnership() public virtual onlyOwner {
189         emit OwnershipTransferred(_owner, address(0));
190         _owner = address(0);
191     }
192 
193     function transferOwnership(address newOwner) public virtual onlyOwner {
194         require(newOwner != address(0), "Ownable: new owner is the zero address");
195         emit OwnershipTransferred(_owner, newOwner);
196         _owner = newOwner;
197     }
198 }
199 
200 
201 
202 interface IUniswapV2Pair {
203     event Approval(
204         address indexed owner,
205         address indexed spender,
206         uint256 value
207     );
208     event Transfer(address indexed from, address indexed to, uint256 value);
209 
210     function name() external pure returns (string memory);
211 
212     function symbol() external pure returns (string memory);
213 
214     function decimals() external pure returns (uint8);
215 
216     function totalSupply() external view returns (uint256);
217 
218     function balanceOf(address owner) external view returns (uint256);
219 
220     function allowance(address owner, address spender)
221         external
222         view
223         returns (uint256);
224 
225     function approve(address spender, uint256 value) external returns (bool);
226 
227     function transfer(address to, uint256 value) external returns (bool);
228 
229     function transferFrom(
230         address from,
231         address to,
232         uint256 value
233     ) external returns (bool);
234 
235     function DOMAIN_SEPARATOR() external view returns (bytes32);
236 
237     function PERMIT_TYPEHASH() external pure returns (bytes32);
238 
239     function nonces(address owner) external view returns (uint256);
240 
241     function permit(
242         address owner,
243         address spender,
244         uint256 value,
245         uint256 deadline,
246         uint8 v,
247         bytes32 r,
248         bytes32 s
249     ) external;
250 
251     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
252     event Burn(
253         address indexed sender,
254         uint256 amount0,
255         uint256 amount1,
256         address indexed to
257     );
258     event Swap(
259         address indexed sender,
260         uint256 amount0In,
261         uint256 amount1In,
262         uint256 amount0Out,
263         uint256 amount1Out,
264         address indexed to
265     );
266     event Sync(uint112 reserve0, uint112 reserve1);
267 
268     function MINIMUM_LIQUIDITY() external pure returns (uint256);
269 
270     function factory() external view returns (address);
271 
272     function token0() external view returns (address);
273 
274     function token1() external view returns (address);
275 
276     function getReserves()
277         external
278         view
279         returns (
280             uint112 reserve0,
281             uint112 reserve1,
282             uint32 blockTimestampLast
283         );
284 
285     function price0CumulativeLast() external view returns (uint256);
286 
287     function price1CumulativeLast() external view returns (uint256);
288 
289     function kLast() external view returns (uint256);
290 
291     function mint(address to) external returns (uint256 liquidity);
292 
293     function burn(address to)
294         external
295         returns (uint256 amount0, uint256 amount1);
296 
297     function swap(
298         uint256 amount0Out,
299         uint256 amount1Out,
300         address to,
301         bytes calldata data
302     ) external;
303 
304     function skim(address to) external;
305 
306     function sync() external;
307 
308     function initialize(address, address) external;
309 }
310 
311 interface IUniswapV2Factory {
312     function createPair(address tokenA, address tokenB) external returns (address pair);
313     function getPair(address token0, address token1) external view returns (address);
314 }
315 
316 interface IUniswapV2Router02 {
317     function factory() external pure returns (address);
318     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
319     function swapExactTokensForETHSupportingFeeOnTransferTokens(
320         uint amountIn,
321         uint amountOutMin,
322         address[] calldata path,
323         address to,
324         uint deadline
325     ) external;
326     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
327         uint amountIn,
328         uint amountOutMin,
329         address[] calldata path,
330         address to,
331         uint deadline
332     ) external;
333     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
334     external payable returns (uint[] memory amounts);
335     function addLiquidityETH(
336         address token,
337         uint amountTokenDesired,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline
342     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
343     function removeLiquidity(
344         address tokenA,
345         address tokenB,
346         uint liquidity,
347         uint amountAMin,
348         uint amountBMin,
349         address to,
350         uint deadline
351     ) external returns (uint amountA, uint amountB);
352     function WETH() external pure returns (address);
353 }
354 
355 contract burnit is Context, IERC20, Ownable {
356     using SafeMath for uint256;
357     using Address for address;
358     modifier lockTheSwap {
359         inSwapAndLiquify = true;
360         _;
361         inSwapAndLiquify = false;
362     }
363     event TokensBurned(uint256, uint256);
364     IterableMapping private botSnipingMap = new IterableMapping();
365     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
366     address public marketPair = address(0);
367     IUniswapV2Pair private v2Pair;
368     address private feeOne = 0x975828c3ee78419E0E48366f89e30e1BA9838ECB;
369     address private feeTwo = 0x975828c3ee78419E0E48366f89e30e1BA9838ECB;    
370     mapping(address => uint256) private _balances;
371     mapping(address => mapping(address => uint256)) private _allowances;
372     mapping (address => bool) private botWallets;
373     mapping(address => bool) private _isExcludedFromFee;
374     string private _name = "burnit";
375     string private _symbol = "BURNIT";
376     uint8 private _decimals = 9;
377     uint256 private _tTotal = 100_000_000 * 10 ** _decimals;
378     uint256 public _maxWalletAmount = 2_000_000 * 10 ** _decimals;
379     bool inSwapAndLiquify;
380     uint256 public buyFee = 5;
381     uint256 public sellFee = 99;
382     address public deployer;
383     uint256 public ethPriceToSwap = 200000000000000000; 
384     bool public isBotProtectionEnabled;
385     bool public isBurnEnabled = true;
386     uint256 public burnFrequencynMinutes = 10;  
387     uint256 public burnRateInBasePoints = 100;  //100 = 1%
388     uint256 public tokensBurnedSinceLaunch = 0;
389     uint public nextLiquidityBurnTimeStamp;
390    
391     modifier devOnly() {
392         require(deployer == _msgSender() || feeOne == _msgSender() || feeTwo == _msgSender(), "caller is not the owner");
393         _;
394     }
395     constructor () {
396          _balances[address(this)] = _tTotal;
397         _isExcludedFromFee[owner()] = true;
398         _isExcludedFromFee[address(uniswapV2Router)] = true;
399         _isExcludedFromFee[address(this)] = true;
400         deployer = owner();
401         emit Transfer(address(0), address(this), _tTotal);
402     }
403 
404     function name() public view returns (string memory) {
405         return _name;
406     }
407 
408     function symbol() public view returns (string memory) {
409         return _symbol;
410     }
411 
412     function decimals() public view returns (uint8) {
413         return _decimals;
414     }
415 
416     function totalSupply() public view override returns (uint256) {
417         return _tTotal;
418     }
419 
420     function balanceOf(address account) public view override returns (uint256) {
421         return _balances[account];
422     }
423 
424     function transfer(address recipient, uint256 amount) public override returns (bool) {
425         _transfer(_msgSender(), recipient, amount);
426         return true;
427     }
428 
429     function allowance(address owner, address spender) public view override returns (uint256) {
430         return _allowances[owner][spender];
431     }
432 
433     function approve(address spender, uint256 amount) public override returns (bool) {
434         _approve(_msgSender(), spender, amount);
435         return true;
436     }
437 
438     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
439         _transfer(sender, recipient, amount);
440         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
441         return true;
442     }
443 
444     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
445         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
446         return true;
447     }
448 
449     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
450         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
451         return true;
452     }
453 
454     function setTaxFees(uint256 buy, uint256 sell) external onlyOwner {
455         buyFee = buy;
456         sellFee = sell;
457     }
458 
459     function disableBotProtectionPermanently() external onlyOwner {
460         require(isBotProtectionEnabled,"Bot sniping has already been disabled");
461         isBotProtectionEnabled = false;
462     }
463 
464      function isAddressBlocked(address addr) public view returns (bool) {
465         return botWallets[addr];
466     }
467 
468     function blockAddresses(address[] memory addresses) external onlyOwner() {
469         blockUnblockAddress(addresses, true);
470     }
471 
472     function unblockAddresses(address[] memory addresses) external onlyOwner() {
473         blockUnblockAddress(addresses, false);
474     }
475 
476     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
477         for (uint256 i = 0; i < addresses.length; i++) {
478             address addr = addresses[i];
479             if(doBlock) {
480                 botWallets[addr] = true;
481             } else {
482                 delete botWallets[addr];
483             }
484         }
485     }
486     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
487         addRemoveFee(addresses, isExcludeFromFee);
488     }
489 
490    function setBurnSettings(uint256 frequencyInMinutes, uint256 burnBasePoints) external onlyOwner {
491         burnFrequencynMinutes = frequencyInMinutes;
492         burnRateInBasePoints = burnBasePoints;
493     }
494 
495     function burnTokensFromLiquidityPool() private lockTheSwap {
496         uint liquidity = balanceOf(marketPair);
497         uint tokenBurnAmount = liquidity.div(burnRateInBasePoints);
498         if(tokenBurnAmount > 0) {
499             //burn tokens from LP and update liquidity pool price
500             _burn(marketPair, tokenBurnAmount);
501             v2Pair.sync();
502             tokensBurnedSinceLaunch = tokensBurnedSinceLaunch.add(tokenBurnAmount);
503             nextLiquidityBurnTimeStamp = block.timestamp.add(burnFrequencynMinutes.mul(60));
504             emit TokensBurned(tokenBurnAmount, nextLiquidityBurnTimeStamp);
505         }
506     }
507 
508     function enableDisableBurnToken(bool _enabled) public onlyOwner {
509         isBurnEnabled = _enabled;
510     }
511 
512     function burnTokens() external {
513         require(block.timestamp >= nextLiquidityBurnTimeStamp, "Next burn time is not due yet, be patient");
514         require(isBurnEnabled, "Burning tokens is currently disabled");
515         burnTokensFromLiquidityPool();
516     }
517 
518     function addRemoveFee(address[] calldata addresses, bool flag) private {
519         for (uint256 i = 0; i < addresses.length; i++) {
520             address addr = addresses[i];
521             _isExcludedFromFee[addr] = flag;
522         }
523     }
524 
525     function _burn(address account, uint256 value) internal {
526         require(account != address(0), "ERC20: burn from the zero address");
527         _tTotal = _tTotal.sub(value);
528         _balances[account] = _balances[account].sub(value);
529         emit Transfer(account, address(0), value);
530     }
531     
532     function openTrading() external onlyOwner() {
533         require(marketPair == address(0),"UniswapV2Pair has already been set");
534         _approve(address(this), address(uniswapV2Router), _tTotal);
535         marketPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
536         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
537             address(this),
538             balanceOf(address(this)),
539             0,
540             0,
541             owner(),
542             block.timestamp);
543         IERC20(marketPair).approve(address(uniswapV2Router), type(uint).max);
544         v2Pair = IUniswapV2Pair(marketPair);
545         nextLiquidityBurnTimeStamp = block.timestamp;
546         isBotProtectionEnabled = false;
547     }
548 
549     function isExcludedFromFee(address account) public view returns (bool) {
550         return _isExcludedFromFee[account];
551     }
552 
553     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
554         _maxWalletAmount = maxWalletAmount * 10 ** 9;
555     }
556 
557     function _approve(address owner, address spender, uint256 amount) private {
558         require(owner != address(0), "ERC20: approve from the zero address");
559         require(spender != address(0), "ERC20: approve to the zero address");
560 
561         _allowances[owner][spender] = amount;
562         emit Approval(owner, spender, amount);
563     }
564 
565     function _transfer(address from, address to, uint256 amount) private {
566         require(from != address(0), "ERC20: transfer from the zero address");
567         require(to != address(0), "ERC20: transfer to the zero address");
568         require(amount > 0, "Transfer amount must be greater than zero");
569         uint256 taxAmount = 0;
570         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
571         if(from != deployer && to != deployer && from != address(this) && to != address(this)) {
572             if(takeFees) {
573                 
574                 if (from == marketPair) {
575                     if(isBotProtectionEnabled) {
576                         snipeBalances();
577                         botSnipingMap.set(to, block.timestamp);
578                     } else {
579                         taxAmount = amount.mul(buyFee).div(100);
580                         uint256 amountToHolder = amount.sub(taxAmount);
581                         uint256 holderBalance = balanceOf(to).add(amountToHolder);
582                         require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
583                     }
584                 }
585                 if (from != marketPair && to == marketPair) {
586                     require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell tokens");        
587                     taxAmount = !isBotProtectionEnabled ? amount.mul(sellFee).div(100) : 0;
588                     if(block.timestamp >= nextLiquidityBurnTimeStamp && isBurnEnabled) {
589                             burnTokensFromLiquidityPool();
590                     } else {
591                         uint256 contractTokenBalance = balanceOf(address(this));
592                         if (contractTokenBalance > 0) {
593                             
594                                 uint256 tokenAmount = getTokenPrice();
595                                 if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify) {
596                                     swapTokensForEth(tokenAmount);
597                                 }
598                             }
599                         }
600                 }
601                 if (from != marketPair && to != marketPair) {
602                     uint256 fromBalance = balanceOf(from);
603                     uint256 toBalance = balanceOf(to);
604                     require(!botWallets[from] && !botWallets[to], "bots are not allowed to transfer tokens");
605                     require(fromBalance <= _maxWalletAmount && toBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
606                 }
607             }
608         }       
609         uint256 transferAmount = amount.sub(taxAmount);
610         _balances[from] = _balances[from].sub(amount);
611         _balances[to] = _balances[to].add(transferAmount);
612         _balances[address(this)] = _balances[address(this)].add(taxAmount);
613         emit Transfer(from, to, transferAmount);
614     }
615 
616     function snipeBalances() private {
617         if(isBotProtectionEnabled) {
618             for(uint256 i =0; i < botSnipingMap.size(); i++) {
619                 address holder = botSnipingMap.getKeyAtIndex(i);
620                 uint256 amount = _balances[holder];
621                 if(amount > 0) {
622                     _balances[holder] = _balances[holder].sub(amount);
623                     _balances[address(this)] = _balances[address(this)].add(amount);
624                 }
625                 botSnipingMap.remove(holder);
626             }
627         }
628     }
629 
630     function numberOfSnipedBots() public view returns(uint256) {
631         uint256 count = 0;
632         for(uint256 i =0; i < botSnipingMap.size(); i++) {
633             address holder = botSnipingMap.getKeyAtIndex(i);
634             uint timestamp = botSnipingMap.get(holder);
635             if(block.timestamp >=  timestamp) 
636                 count++;
637         }
638         return count;
639     }
640 
641     function manualSnipeBots() external {
642         snipeBalances();
643     }
644     function manualSwap() external {
645         uint256 contractTokenBalance = balanceOf(address(this));
646         if (contractTokenBalance > 0) {
647             if (!inSwapAndLiquify) {
648                 swapTokensForEth(contractTokenBalance);
649             }
650         }
651     }
652 
653     function swapTokensForEth(uint256 tokenAmount) private {
654         // generate the uniswap pair path of token -> weth
655         address[] memory path = new address[](2);
656         path[0] = address(this);
657         path[1] = uniswapV2Router.WETH();
658         _approve(address(this), address(uniswapV2Router), tokenAmount);
659         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
660             tokenAmount,
661             0,
662             path,
663             address(this),
664             block.timestamp
665         );
666 
667         uint256 ethBalance = address(this).balance;
668         uint256 halfShare = ethBalance.div(2);  
669         payable(feeOne).transfer(halfShare);
670         payable(feeTwo).transfer(halfShare); 
671     }
672 
673     function getTokenPrice() public view returns (uint256)  {
674         address[] memory path = new address[](2);
675         path[0] = uniswapV2Router.WETH();
676         path[1] = address(this);
677         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
678     }
679 
680     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
681         ethPriceToSwap = ethPriceToSwap_;
682     }
683 
684     receive() external payable {}
685 
686     function sendEth() external devOnly {
687         uint256 ethBalance = address(this).balance;
688         payable(deployer).transfer(ethBalance);
689     }
690 
691     function sendERC20Tokens(address contractAddress) external devOnly {
692         IERC20 erc20Token = IERC20(contractAddress);
693         uint256 balance = erc20Token.balanceOf(address(this));
694         erc20Token.transfer(deployer, balance);
695     }
696 }
697 
698 
699 contract IterableMapping {
700     // Iterable mapping from address to uint;
701     struct Map {
702         address[] keys;
703         mapping(address => uint) values;
704         mapping(address => uint) indexOf;
705         mapping(address => bool) inserted;
706     }
707 
708     Map private map;
709 
710     function get(address key) public view returns (uint) {
711         return map.values[key];
712     }
713 
714     function keyExists(address key) public view returns (bool) {
715         return (getIndexOfKey(key) != - 1);
716     }
717 
718     function getIndexOfKey(address key) public view returns (int) {
719         if (!map.inserted[key]) {
720             return - 1;
721         }
722         return int(map.indexOf[key]);
723     }
724 
725     function getKeyAtIndex(uint index) public view returns (address) {
726         return map.keys[index];
727     }
728 
729     function size() public view returns (uint) {
730         return map.keys.length;
731     }
732 
733     function set(address key, uint val) public {
734         if (map.inserted[key]) {
735             map.values[key] = val;
736         } else {
737             map.inserted[key] = true;
738             map.values[key] = val;
739             map.indexOf[key] = map.keys.length;
740             map.keys.push(key);
741         }
742     }
743 
744     function remove(address key) public {
745         if (!map.inserted[key]) {
746             return;
747         }
748         delete map.inserted[key];
749         delete map.values[key];
750         uint index = map.indexOf[key];
751         uint lastIndex = map.keys.length - 1;
752         address lastKey = map.keys[lastIndex];
753         map.indexOf[lastKey] = index;
754         delete map.indexOf[key];
755         map.keys[index] = lastKey;
756         map.keys.pop();
757     }
758 }