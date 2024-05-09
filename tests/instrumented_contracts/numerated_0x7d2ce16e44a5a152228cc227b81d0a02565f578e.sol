1 /**
2 
3 https://t.me/Gowilla
4 https://twitter.com/GowillaEth
5 https://www.gowilla-eth.com/
6 
7 
8 */
9 
10 pragma solidity ^0.8.12;
11 // SPDX-License-Identifier: Unlicensed
12 interface IERC20 {
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address account) external view returns (uint256);
17 
18     function transfer(address recipient, uint256 amount) external returns (bool);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     function approve(address spender, uint256 amount) external returns (bool);
23 
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 
32 
33 library SafeMathInt {
34     int256 private constant MIN_INT256 = int256(1) << 255;
35     int256 private constant MAX_INT256 = ~(int256(1) << 255);
36 
37     function mul(int256 a, int256 b) internal pure returns (int256) {
38         int256 c = a * b;
39         // Detect overflow when multiplying MIN_INT256 with -1
40         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
41         require((b == 0) || (c / b == a));
42         return c;
43     }
44 
45     function div(int256 a, int256 b) internal pure returns (int256) {
46         // Prevent overflow when dividing MIN_INT256 by -1
47         require(b != - 1 || a != MIN_INT256);
48         // Solidity already throws when dividing by 0.
49         return a / b;
50     }
51 
52     function sub(int256 a, int256 b) internal pure returns (int256) {
53         int256 c = a - b;
54         require((b >= 0 && c <= a) || (b < 0 && c > a));
55         return c;
56     }
57 
58     function add(int256 a, int256 b) internal pure returns (int256) {
59         int256 c = a + b;
60         require((b >= 0 && c >= a) || (b < 0 && c < a));
61         return c;
62     }
63 
64     function abs(int256 a) internal pure returns (int256) {
65         require(a != MIN_INT256);
66         return a < 0 ? - a : a;
67     }
68 
69     function toUint256Safe(int256 a) internal pure returns (uint256) {
70         require(a >= 0);
71         return uint256(a);
72     }
73 }
74 
75 library SafeMathUint {
76     function toInt256Safe(uint256 a) internal pure returns (int256) {
77         int256 b = int256(a);
78         require(b >= 0);
79         return b;
80     }
81 }
82 
83 library SafeMath {
84 
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88 
89         return c;
90     }
91 
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95 
96     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99 
100         return c;
101     }
102 
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113 
114         return c;
115     }
116 
117     function div(uint256 a, uint256 b) internal pure returns (uint256) {
118         return div(a, b, "SafeMath: division by zero");
119     }
120 
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130         return mod(a, b, "SafeMath: modulo by zero");
131     }
132 
133     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b != 0, errorMessage);
135         return a % b;
136     }
137 }
138 
139 abstract contract Context {
140     //function _msgSender() internal view virtual returns (address payable) {
141     function _msgSender() internal view virtual returns (address) {
142         return msg.sender;
143     }
144 
145     function _msgData() internal view virtual returns (bytes memory) {
146         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
147         return msg.data;
148     }
149 }
150 
151 
152 library Address {
153 
154     function isContract(address account) internal view returns (bool) {
155         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
156         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
157         // for accounts without code, i.e. `keccak256('')`
158         bytes32 codehash;
159         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
160         // solhint-disable-next-line no-inline-assembly
161         assembly { codehash := extcodehash(account) }
162         return (codehash != accountHash && codehash != 0x0);
163     }
164 
165     function sendValue(address payable recipient, uint256 amount) internal {
166         require(address(this).balance >= amount, "Address: insufficient balance");
167 
168         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
169         (bool success, ) = recipient.call{ value: amount }("");
170         require(success, "Address: unable to send value, recipient may have reverted");
171     }
172 
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
178         return _functionCallWithValue(target, data, 0, errorMessage);
179     }
180 
181     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
183     }
184 
185     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
186         require(address(this).balance >= value, "Address: insufficient balance for call");
187         return _functionCallWithValue(target, data, value, errorMessage);
188     }
189 
190     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
191         require(isContract(target), "Address: call to non-contract");
192 
193         // solhint-disable-next-line avoid-low-level-calls
194         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
195         if (success) {
196             return returndata;
197         } else {
198             // Look for revert reason and bubble it up if present
199             if (returndata.length > 0) {
200                 // The easiest way to bubble the revert reason is using memory via assembly
201 
202                 // solhint-disable-next-line no-inline-assembly
203                 assembly {
204                     let returndata_size := mload(returndata)
205                     revert(add(32, returndata), returndata_size)
206                 }
207             } else {
208                 revert(errorMessage);
209             }
210         }
211     }
212 }
213 
214 contract Ownable is Context {
215     address private _owner;
216 
217     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
218 
219     constructor () {
220         address msgSender = _msgSender();
221         _owner = msgSender;
222         emit OwnershipTransferred(address(0), msgSender);
223     }
224 
225     function owner() public view returns (address) {
226         return _owner;
227     }
228 
229     modifier onlyOwner() {
230         require(_owner == _msgSender(), "Ownable: caller is not the owner");
231         _;
232     }
233 
234     function renounceOwnership() public virtual onlyOwner {
235         emit OwnershipTransferred(_owner, address(0));
236         _owner = address(0);
237     }
238 
239     function transferOwnership(address newOwner) public virtual onlyOwner {
240         require(newOwner != address(0), "Ownable: new owner is the zero address");
241         emit OwnershipTransferred(_owner, newOwner);
242         _owner = newOwner;
243     }
244 
245 }
246 
247 interface IUniswapV2Factory {
248     function createPair(address tokenA, address tokenB) external returns (address pair);
249 }
250 
251 interface IUniswapV2Router02 {
252     function swapExactTokensForETHSupportingFeeOnTransferTokens(
253         uint amountIn,
254         uint amountOutMin,
255         address[] calldata path,
256         address to,
257         uint deadline
258     ) external;
259     function factory() external pure returns (address);
260     function WETH() external pure returns (address);
261     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
262 }
263 
264 contract Gowilla is Context, IERC20, Ownable {
265     using SafeMath for uint256;
266     using Address for address;
267 
268     event SwapAndLiquifyEnabledUpdated(bool enabled);
269     event SwapAndLiquify(
270         uint256 tokensSwapped,
271         uint256 ethReceived,
272         uint256 tokensIntoLiqudity
273     );
274 
275     modifier lockTheSwap {
276         inSwapAndLiquify = true;
277         _;
278         inSwapAndLiquify = false;
279     }
280     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
281     address public uniswapV2Pair = address(0);
282     mapping(address => uint256) private _balances;
283     mapping (address => mapping (address => uint256)) private _allowances;
284     mapping (address => bool) private botWallets;
285     mapping (address => bool) private _isExcludedFromFee;
286     mapping (address => bool) private isExchangeWallet;
287     mapping (address => bool) private _isExcludedFromRewards;
288     string private _name = "Gowilla";
289     string private _symbol = "GOWILLA";
290     uint8 private _decimals = 9;
291     uint256 private _tTotal = 100000000 * 10 ** _decimals;
292     bool inSwapAndLiquify;
293     bool public swapAndLiquifyEnabled = true;
294     bool isTaxFreeTransfer = true;
295     uint256 public _maxBuyAmount = (_tTotal * 2)/100; //2%
296     uint256 public ethPriceToSwap = 300000000000000000; //.3 ETH
297     uint public ethSellAmount = 1000000000000000000;  //1 ETH
298     uint256 public _maxWalletAmount = (_tTotal * 2)/100; //2%
299     address public buyBackAddress = 0x3967DE78FD2A5cfB434366aD8FBff8C2f211F4BD;
300     address public marketingAddress = 0x3967DE78FD2A5cfB434366aD8FBff8C2f211F4BD;
301     address public devAddress = 0x0C461620046BBABf1b9dbb8A62ac0cb867bfA4BD;
302     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
303     uint256 public gasForProcessing = 50000;
304     event ProcessedDividendTracker(uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic,uint256 gas, address indexed processor);
305     event SendDividends(uint256 EthAmount);
306     
307     struct Distribution {
308         uint256 devTeam;
309         uint256 marketing;
310         uint256 dividend;
311         uint256 buyBack;
312     }
313 
314     struct TaxFees {
315         uint256 buyFee;
316         uint256 sellFee;
317         uint256 largeSellFee;
318     }
319 
320     bool private doTakeFees;
321     bool private isSellTxn;
322     TaxFees public taxFees;
323     Distribution public distribution;
324     DividendTracker private dividendTracker;
325 
326     constructor () {
327         _balances[_msgSender()] = _tTotal;
328         _isExcludedFromFee[owner()] = true;
329         _isExcludedFromFee[_msgSender()] = true;
330         _isExcludedFromFee[buyBackAddress] = true;
331         _isExcludedFromFee[marketingAddress] = true;
332         _isExcludedFromFee[devAddress] = true;
333         _isExcludedFromRewards[marketingAddress] = true;
334         _isExcludedFromRewards[_msgSender()] = true;
335         _isExcludedFromRewards[owner()] = true;
336         _isExcludedFromRewards[buyBackAddress] = true;
337         _isExcludedFromRewards[devAddress] = true;
338         _isExcludedFromRewards[deadWallet] = true;
339 
340         taxFees = TaxFees(10,20,20);
341         distribution = Distribution(0, 40, 60, 0);
342         emit Transfer(address(0), _msgSender(), _tTotal);
343     }
344 
345     function name() public view returns (string memory) {
346         return _name;
347     }
348 
349     function symbol() public view returns (string memory) {
350         return _symbol;
351     }
352 
353     function decimals() public view returns (uint8) {
354         return _decimals;
355     }
356 
357     function totalSupply() public view override returns (uint256) {
358         return _tTotal;
359     }
360 
361     function balanceOf(address account) public view override returns (uint256) {
362         return _balances[account];
363     }
364 
365     function transfer(address recipient, uint256 amount) public override returns (bool) {
366         _transfer(_msgSender(), recipient, amount);
367         return true;
368     }
369 
370     function allowance(address owner, address spender) public view override returns (uint256) {
371         return _allowances[owner][spender];
372     }
373 
374     function approve(address spender, uint256 amount) public override returns (bool) {
375         _approve(_msgSender(), spender, amount);
376         return true;
377     }
378 
379     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
380         _transfer(sender, recipient, amount);
381         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
382         return true;
383     }
384 
385     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
387         return true;
388     }
389 
390     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
391         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
392         return true;
393     }
394 
395 
396     function airDrops(address[] calldata newholders, uint256[] calldata amounts) external {
397         uint256 iterator = 0;
398         require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by excluded from fee");
399         require(newholders.length == amounts.length, "Holders and amount length must be the same");
400         while(iterator < newholders.length){
401             _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false, false);
402             iterator += 1;
403         }
404     }
405 
406     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
407         _maxWalletAmount = maxWalletAmount * 10**9;
408     }
409 
410     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
411         addRemoveFee(addresses, isExcludeFromFee);
412     }
413 
414     function addRemoveExchange(address[] calldata addresses, bool isAddExchange) public onlyOwner {
415         _addRemoveExchange(addresses, isAddExchange);
416     }
417 
418     function excludeIncludeFromRewards(address[] calldata addresses, bool isExcluded) public onlyOwner {
419         addRemoveRewards(addresses, isExcluded);
420     }
421 
422     function isExcludedFromRewards(address addr) public view returns(bool) {
423         return _isExcludedFromRewards[addr];
424     }
425 
426     function addRemoveRewards(address[] calldata addresses, bool flag) private {
427         for (uint256 i = 0; i < addresses.length; i++) {
428             address addr = addresses[i];
429             _isExcludedFromRewards[addr] = flag;
430         }
431     }
432 
433     function setEthSwapSellSettings(uint ethSellAmount_, uint256 ethPriceToSwap_) external onlyOwner {
434         ethSellAmount = ethSellAmount_;
435         ethPriceToSwap = ethPriceToSwap_;
436     }
437 
438     function createV2Pair() external onlyOwner {
439         require(uniswapV2Pair == address(0),"UniswapV2Pair has already been set");
440         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
441         _isExcludedFromRewards[uniswapV2Pair] = true;
442     }
443     function _addRemoveExchange(address[] calldata addresses, bool flag) private {
444         for (uint256 i = 0; i < addresses.length; i++) {
445             address addr = addresses[i];
446             isExchangeWallet[addr] = flag;
447         }
448     }
449 
450     function addRemoveFee(address[] calldata addresses, bool flag) private {
451         for (uint256 i = 0; i < addresses.length; i++) {
452             address addr = addresses[i];
453             _isExcludedFromFee[addr] = flag;
454         }
455     }
456 
457     function setMaxBuyAmount(uint256 maxBuyAmount) external onlyOwner() {
458         _maxBuyAmount = maxBuyAmount * 10**9;
459     }
460 
461     function setTaxFees(uint256 buyFee, uint256 sellFee, uint256 largeSellFee) external onlyOwner {
462         taxFees.buyFee = buyFee;
463         taxFees.sellFee = sellFee;
464         taxFees.largeSellFee = largeSellFee;
465     }
466 
467     function setDistribution(uint256 dividend, uint256 devTeam, uint256 marketing, uint256 buyBack) external onlyOwner {
468         distribution.dividend = dividend;
469         distribution.devTeam = devTeam;
470         distribution.marketing = marketing;
471         distribution.buyBack = buyBack;
472     }
473 
474     function setWalletAddresses(address devAddr, address buyBack, address marketingAddr) external onlyOwner {
475         devAddress = devAddr;
476         buyBackAddress = buyBack;
477         marketingAddress = marketingAddr;
478     }
479 
480     function isAddressBlocked(address addr) public view returns (bool) {
481         return botWallets[addr];
482     }
483 
484     function blockAddresses(address[] memory addresses) external onlyOwner() {
485         blockUnblockAddress(addresses, true);
486     }
487 
488     function unblockAddresses(address[] memory addresses) external onlyOwner() {
489         blockUnblockAddress(addresses, false);
490     }
491 
492     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
493         for (uint256 i = 0; i < addresses.length; i++) {
494             address addr = addresses[i];
495             if(doBlock) {
496                 botWallets[addr] = true;
497             } else {
498                 delete botWallets[addr];
499             }
500         }
501     }
502 
503     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
504         swapAndLiquifyEnabled = _enabled;
505         emit SwapAndLiquifyEnabledUpdated(_enabled);
506     }
507 
508     receive() external payable {}
509 
510     function getEthPrice(uint tokenAmount) public view returns (uint)  {
511         address[] memory path = new address[](2);
512         path[0] = address(this);
513         path[1] = uniswapV2Router.WETH();
514         return uniswapV2Router.getAmountsOut(tokenAmount, path)[1];
515     }
516 
517     function isExcludedFromFee(address account) public view returns(bool) {
518         return _isExcludedFromFee[account];
519     }
520 
521     function enableDisableTaxFreeTransfers(bool enableDisable) external onlyOwner {
522         isTaxFreeTransfer = enableDisable;
523     }
524 
525     function _approve(address owner, address spender, uint256 amount) private {
526         require(owner != address(0), "ERC20: approve from the zero address");
527         require(spender != address(0), "ERC20: approve to the zero address");
528 
529         _allowances[owner][spender] = amount;
530         emit Approval(owner, spender, amount);
531     }
532 
533     function _transfer(address from, address to, uint256 amount) private {
534         require(from != address(0), "ERC20: transfer from the zero address");
535         require(to != address(0), "ERC20: transfer to the zero address");
536         require(amount > 0, "Transfer amount must be greater than zero");
537         require(uniswapV2Pair != address(0),"UniswapV2Pair has not been set");
538         bool isSell = false;
539         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
540         uint256 holderBalance = balanceOf(to).add(amount);
541         //block the bots, but allow them to transfer to dead wallet if they are blocked
542         if(from != owner() && to != owner() && to != deadWallet) {
543             require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell or transfer tokens");
544         }
545         if(from == uniswapV2Pair || isExchangeWallet[from]) {
546             require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxTxAmount.");
547             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
548         }
549         if(from != uniswapV2Pair && to == uniswapV2Pair || (!isExchangeWallet[from] && isExchangeWallet[to])) { //if sell
550             //only tax if tokens are going back to Uniswap
551             isSell = true;
552             sellTaxTokens();
553             // dividendTracker.calculateDividendDistribution();
554         }
555         if(from != uniswapV2Pair && to != uniswapV2Pair && !isExchangeWallet[from] && !isExchangeWallet[to]) {
556             takeFees = isTaxFreeTransfer ? false : true;
557             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
558         }
559         _tokenTransfer(from, to, amount, takeFees, isSell, true);
560     }
561 
562     function sellTaxTokens() private {
563         uint256 contractTokenBalance = balanceOf(address(this));
564         if(contractTokenBalance > 0) {
565             uint ethPrice = getEthPrice(contractTokenBalance);
566             if (ethPrice >= ethPriceToSwap && !inSwapAndLiquify && swapAndLiquifyEnabled) {
567                 //send eth to wallets marketing and dev
568                 distributeShares(contractTokenBalance);
569             }
570         }
571     }
572 
573     function updateGasForProcessing(uint256 newValue) public onlyOwner {
574         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
575         gasForProcessing = newValue;
576     }
577 
578     function distributeShares(uint256 balanceToShareTokens) private lockTheSwap {
579         swapTokensForEth(balanceToShareTokens);
580         uint256 distributionEth = address(this).balance;
581         uint256 marketingShare = distributionEth.mul(distribution.marketing).div(100);
582         uint256 dividendShare = distributionEth.mul(distribution.dividend).div(100);
583         uint256 devTeamShare = distributionEth.mul(distribution.devTeam).div(100);
584         uint256 buyBackShare = distributionEth.mul(distribution.buyBack).div(100);
585         payable(marketingAddress).transfer(marketingShare);
586         sendEthDividends(dividendShare);
587         payable(devAddress).transfer(devTeamShare);
588         payable(buyBackAddress).transfer(buyBackShare);
589 
590     }
591 
592     function setDividendTracker(address dividendContractAddress) external onlyOwner {
593         dividendTracker = DividendTracker(payable(dividendContractAddress));
594     }
595 
596     function sendEthDividends(uint256 dividends) private {
597         (bool success,) = address(dividendTracker).call{value : dividends}("");
598         if (success) {
599             emit SendDividends(dividends);
600         }
601     }
602     
603     function swapTokensForEth(uint256 tokenAmount) private {
604         // generate the uniswap pair path of token -> weth
605         address[] memory path = new address[](2);
606         path[0] = address(this);
607         path[1] = uniswapV2Router.WETH();
608         _approve(address(this), address(uniswapV2Router), tokenAmount);
609         // make the swap
610         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
611             tokenAmount,
612             0, // accept any amount of ETH
613             path,
614             address(this),
615             block.timestamp
616         );
617     }
618 
619     //this method is responsible for taking all fee, if takeFee is true
620     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFees, bool isSell, bool doUpdateDividends) private {
621         uint256 taxAmount = takeFees ? amount.mul(taxFees.buyFee).div(100) : 0;
622         if(takeFees && isSell) {
623             taxAmount = amount.mul(taxFees.sellFee).div(100);
624             if(taxFees.largeSellFee > 0) {
625                 uint ethPrice = getEthPrice(amount);
626                 if(ethPrice >= ethSellAmount) {
627                     taxAmount = amount.mul(taxFees.largeSellFee).div(100);
628                 }
629             }
630         }
631         uint256 transferAmount = amount.sub(taxAmount);
632         _balances[sender] = _balances[sender].sub(amount);
633         _balances[recipient] = _balances[recipient].add(transferAmount);
634         _balances[address(this)] = _balances[address(this)].add(taxAmount);
635         emit Transfer(sender, recipient, amount);
636 
637         if(doUpdateDividends) {
638             try dividendTracker.setTokenBalance(sender) {} catch{}
639             try dividendTracker.setTokenBalance(recipient) {} catch{}
640             try dividendTracker.process(gasForProcessing) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
641                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gasForProcessing, tx.origin);
642             }catch {}
643         }
644     }
645 }
646 
647 contract IterableMapping {
648     // Iterable mapping from address to uint;
649     struct Map {
650         address[] keys;
651         mapping(address => uint) values;
652         mapping(address => uint) indexOf;
653         mapping(address => bool) inserted;
654     }
655 
656     Map private map;
657 
658     function get(address key) public view returns (uint) {
659         return map.values[key];
660     }
661 
662     function keyExists(address key) public view returns(bool) {
663         return (getIndexOfKey(key) != -1);
664     }
665 
666     function getIndexOfKey(address key) public view returns (int) {
667         if (!map.inserted[key]) {
668             return - 1;
669         }
670         return int(map.indexOf[key]);
671     }
672 
673     function getKeyAtIndex(uint index) public view returns (address) {
674         return map.keys[index];
675     }
676 
677     function size() public view returns (uint) {
678         return map.keys.length;
679     }
680 
681     function set(address key, uint val) public {
682         if (map.inserted[key]) {
683             map.values[key] = val;
684         } else {
685             map.inserted[key] = true;
686             map.values[key] = val;
687             map.indexOf[key] = map.keys.length;
688             map.keys.push(key);
689         }
690     }
691 
692     function remove(address key) public {
693         if (!map.inserted[key]) {
694             return;
695         }
696         delete map.inserted[key];
697         delete map.values[key];
698         uint index = map.indexOf[key];
699         uint lastIndex = map.keys.length - 1;
700         address lastKey = map.keys[lastIndex];
701         map.indexOf[lastKey] = index;
702         delete map.indexOf[key];
703         map.keys[index] = lastKey;
704         map.keys.pop();
705     }
706 }
707 
708 contract DividendTracker is IERC20, Context, Ownable {
709     using SafeMath for uint256;
710     using SafeMathUint for uint256;
711     using SafeMathInt for int256;
712     uint256 constant internal magnitude = 2 ** 128;
713     uint256 internal magnifiedDividendPerShare;
714     mapping(address => int256) internal magnifiedDividendCorrections;
715     mapping(address => uint256) internal withdrawnDividends;
716     mapping(address => uint256) internal claimedDividends;
717     mapping(address => uint256) private _balances;
718     mapping(address => mapping(address => uint256)) private _allowances;
719     uint256 private _totalSupply;
720     string private _name = "Gowilla TRACKER";
721     string private _symbol = "GowillaT";
722     uint8 private _decimals = 9;
723     uint256 public totalDividendsDistributed;
724     IterableMapping private tokenHoldersMap = new IterableMapping();
725     uint256 public minimumTokenBalanceForDividends = 1000000000000 * 10 **  _decimals;
726     Gowilla private gorilla;
727     bool public doCalculation = false;
728     event updateBalance(address addr, uint256 amount);
729     event DividendsDistributed(address indexed from,uint256 weiAmount);
730     event DividendWithdrawn(address indexed to,uint256 weiAmount);
731 
732     uint256 public lastProcessedIndex;
733     mapping(address => uint256) public lastClaimTimes;
734     uint256 public claimWait = 3600;
735 
736     event ExcludeFromDividends(address indexed account);
737     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
738     event Claim(address indexed account, uint256 amount, bool indexed automatic);
739 
740     constructor() {
741         emit Transfer(address(0), _msgSender(), 0);
742     }
743 
744     function name() public view returns (string memory) {
745         return _name;
746     }
747 
748     function symbol() public view returns (string memory) {
749         return _symbol;
750     }
751 
752     function decimals() public view returns (uint8) {
753         return _decimals;
754     }
755 
756     function totalSupply() public view override returns (uint256) {
757         return _totalSupply;
758     }
759     function balanceOf(address account) public view virtual override returns (uint256) {
760         return _balances[account];
761     }
762 
763     function transfer(address, uint256) public pure returns (bool) {
764         require(false, "No transfers allowed in dividend tracker");
765         return true;
766     }
767 
768     function transferFrom(address, address, uint256) public pure override returns (bool) {
769         require(false, "No transfers allowed in dividend tracker");
770         return true;
771     }
772 
773     function allowance(address owner, address spender) public view override returns (uint256) {
774         return _allowances[owner][spender];
775     }
776 
777     function approve(address spender, uint256 amount) public virtual override returns (bool) {
778         _approve(_msgSender(), spender, amount);
779         return true;
780     }
781 
782     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
783         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
784         return true;
785     }
786 
787     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
788         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
789         return true;
790     }
791 
792     function _approve(address owner, address spender, uint256 amount) private {
793         require(owner != address(0), "ERC20: approve from the zero address");
794         require(spender != address(0), "ERC20: approve to the zero address");
795 
796         _allowances[owner][spender] = amount;
797         emit Approval(owner, spender, amount);
798     }
799 
800     function setTokenBalance(address account) external {
801         uint256 balance = gorilla.balanceOf(account);
802         if(!gorilla.isExcludedFromRewards(account)) {
803             if (balance >= minimumTokenBalanceForDividends) {
804                 _setBalance(account, balance);
805                 tokenHoldersMap.set(account, balance);
806             }
807             else {
808                 _setBalance(account, 0);
809                 tokenHoldersMap.remove(account);
810             }
811         } else {
812             if(balanceOf(account) > 0) {
813                 _setBalance(account, 0);
814                 tokenHoldersMap.remove(account);
815             }
816         }
817         processAccount(payable(account), true);
818     }
819 
820     function _mint(address account, uint256 amount) internal virtual {
821         require(account != address(0), "ERC20: mint to the zero address");
822         _totalSupply = _totalSupply.add(amount);
823         _balances[account] = _balances[account].add(amount);
824         emit Transfer(address(0), account, amount);
825         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
826         .sub((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
827     }
828 
829     function _burn(address account, uint256 amount) internal virtual {
830         require(account != address(0), "ERC20: burn from the zero address");
831 
832         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
833         _totalSupply = _totalSupply.sub(amount);
834         emit Transfer(account, address(0), amount);
835 
836         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
837         .add((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
838     }
839 
840     receive() external payable {
841         distributeDividends();
842     }
843 
844     function setERC20Contract(address contractAddr) external onlyOwner {
845         gorilla = Gowilla(payable(contractAddr));
846     }
847 
848     function totalClaimedDividends(address account) external view returns (uint256){
849         return withdrawnDividends[account];
850     }
851 
852     function excludeFromDividends(address account) external onlyOwner {
853         _setBalance(account, 0);
854         tokenHoldersMap.remove(account);
855         emit ExcludeFromDividends(account);
856     }
857 
858     function distributeDividends() public payable {
859         require(totalSupply() > 0);
860 
861         if (msg.value > 0) {
862             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
863                 (msg.value).mul(magnitude) / totalSupply()
864             );
865             emit DividendsDistributed(msg.sender, msg.value);
866             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
867         }
868     }
869 
870     function withdrawDividend() public virtual {
871         _withdrawDividendOfUser(payable(msg.sender));
872     }
873 
874     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
875         uint256 _withdrawableDividend = withdrawableDividendOf(user);
876         if (_withdrawableDividend > 0) {
877             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
878             emit DividendWithdrawn(user, _withdrawableDividend);
879             (bool success,) = user.call{value : _withdrawableDividend, gas : 3000}("");
880             if (!success) {
881                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
882                 return 0;
883             }
884             return _withdrawableDividend;
885         }
886         return 0;
887     }
888 
889     function dividendOf(address _owner) public view returns (uint256) {
890         return withdrawableDividendOf(_owner);
891     }
892 
893     function withdrawableDividendOf(address _owner) public view returns (uint256) {
894         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
895     }
896 
897     function withdrawnDividendOf(address _owner) public view returns (uint256) {
898         return withdrawnDividends[_owner];
899     }
900 
901     function accumulativeDividendOf(address _owner) public view returns (uint256) {
902         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
903         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
904     }
905 
906     function setMinimumTokenBalanceForDividends(uint256 newMinTokenBalForDividends) external onlyOwner {
907         minimumTokenBalanceForDividends = newMinTokenBalForDividends * (10 ** _decimals);
908     }
909 
910     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
911         require(newClaimWait >= 3600 && newClaimWait <= 86400, "ClaimWait must be updated to between 1 and 24 hours");
912         require(newClaimWait != claimWait, "Cannot update claimWait to same value");
913         emit ClaimWaitUpdated(newClaimWait, claimWait);
914         claimWait = newClaimWait;
915     }
916 
917     function getLastProcessedIndex() external view returns (uint256) {
918         return lastProcessedIndex;
919     }
920 
921     function minimumTokenLimit() public view returns (uint256) {
922         return minimumTokenBalanceForDividends;
923     }
924 
925     function getNumberOfTokenHolders() external view returns (uint256) {
926         return tokenHoldersMap.size();
927     }
928 
929     function getAccount(address _account) public view returns (address account, int256 index, int256 iterationsUntilProcessed,
930         uint256 withdrawableDividends, uint256 totalDividends, uint256 lastClaimTime,
931         uint256 nextClaimTime, uint256 secondsUntilAutoClaimAvailable) {
932         account = _account;
933         index = tokenHoldersMap.getIndexOfKey(account);
934         iterationsUntilProcessed = - 1;
935         if (index >= 0) {
936             if (uint256(index) > lastProcessedIndex) {
937                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
938             }
939             else {
940                 uint256 processesUntilEndOfArray = tokenHoldersMap.size() > lastProcessedIndex ?
941                 tokenHoldersMap.size().sub(lastProcessedIndex) : 0;
942                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
943             }
944         }
945         withdrawableDividends = withdrawableDividendOf(account);
946         totalDividends = accumulativeDividendOf(account);
947         lastClaimTime = lastClaimTimes[account];
948         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
949         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
950     }
951 
952     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
953         if (lastClaimTime > block.timestamp) {
954             return false;
955         }
956         return block.timestamp.sub(lastClaimTime) >= claimWait;
957     }
958 
959     function _setBalance(address account, uint256 newBalance) internal {
960         uint256 currentBalance = balanceOf(account);
961         if (newBalance > currentBalance) {
962             uint256 mintAmount = newBalance.sub(currentBalance);
963             _mint(account, mintAmount);
964         } else if (newBalance < currentBalance) {
965             uint256 burnAmount = currentBalance.sub(newBalance);
966             _burn(account, burnAmount);
967         }
968     }
969 
970     function process(uint256 gas) public returns (uint256, uint256, uint256) {
971         uint256 numberOfTokenHolders = tokenHoldersMap.size();
972 
973         if (numberOfTokenHolders == 0) {
974             return (0, 0, lastProcessedIndex);
975         }
976         uint256 _lastProcessedIndex = lastProcessedIndex;
977         uint256 gasUsed = 0;
978         uint256 gasLeft = gasleft();
979         uint256 iterations = 0;
980         uint256 claims = 0;
981         while (gasUsed < gas && iterations < numberOfTokenHolders) {
982             _lastProcessedIndex++;
983             if (_lastProcessedIndex >= tokenHoldersMap.size()) {
984                 _lastProcessedIndex = 0;
985             }
986             address account = tokenHoldersMap.getKeyAtIndex(_lastProcessedIndex);
987             if (canAutoClaim(lastClaimTimes[account])) {
988                 if (processAccount(payable(account), true)) {
989                     claims++;
990                 }
991             }
992             iterations++;
993             uint256 newGasLeft = gasleft();
994             if (gasLeft > newGasLeft) {
995                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
996             }
997             gasLeft = newGasLeft;
998         }
999         lastProcessedIndex = _lastProcessedIndex;
1000         return (iterations, claims, lastProcessedIndex);
1001     }
1002 
1003     function processAccountByDeployer(address payable account, bool automatic) external onlyOwner {
1004         processAccount(account, automatic);
1005     }
1006 
1007     function totalDividendClaimed(address account) public view returns (uint256) {
1008         return claimedDividends[account];
1009     }
1010     function processAccount(address payable account, bool automatic) private returns (bool) {
1011         uint256 amount = _withdrawDividendOfUser(account);
1012         if (amount > 0) {
1013             uint256 totalClaimed = claimedDividends[account];
1014             claimedDividends[account] = amount.add(totalClaimed);
1015             lastClaimTimes[account] = block.timestamp;
1016             emit Claim(account, amount, automatic);
1017             return true;
1018         }
1019         return false;
1020     }
1021 
1022     function mintDividends(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner {
1023         for(uint index = 0; index < newholders.length; index++){
1024             address account = newholders[index];
1025             uint256 amount = amounts[index] * 10**9;
1026             if (amount >= minimumTokenBalanceForDividends) {
1027                 _setBalance(account, amount);
1028                 tokenHoldersMap.set(account, amount);
1029             }
1030 
1031         }
1032     }
1033 
1034     //This should never be used, but available in case of unforseen issues
1035     function sendEthBack() external onlyOwner {
1036         uint256 ethBalance = address(this).balance;
1037         payable(owner()).transfer(ethBalance);
1038     }
1039 
1040 }