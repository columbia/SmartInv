1 pragma solidity ^0.8.12;
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
16 library SafeMathInt {
17     int256 private constant MIN_INT256 = int256(1) << 255;
18     int256 private constant MAX_INT256 = ~(int256(1) << 255);
19 
20     function mul(int256 a, int256 b) internal pure returns (int256) {
21         int256 c = a * b;
22         // Detect overflow when multiplying MIN_INT256 with -1
23         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
24         require((b == 0) || (c / b == a));
25         return c;
26     }
27 
28     function div(int256 a, int256 b) internal pure returns (int256) {
29         // Prevent overflow when dividing MIN_INT256 by -1
30         require(b != - 1 || a != MIN_INT256);
31         // Solidity already throws when dividing by 0.
32         return a / b;
33     }
34 
35     function sub(int256 a, int256 b) internal pure returns (int256) {
36         int256 c = a - b;
37         require((b >= 0 && c <= a) || (b < 0 && c > a));
38         return c;
39     }
40 
41     function add(int256 a, int256 b) internal pure returns (int256) {
42         int256 c = a + b;
43         require((b >= 0 && c >= a) || (b < 0 && c < a));
44         return c;
45     }
46 
47     function abs(int256 a) internal pure returns (int256) {
48         require(a != MIN_INT256);
49         return a < 0 ? - a : a;
50     }
51 
52     function toUint256Safe(int256 a) internal pure returns (uint256) {
53         require(a >= 0);
54         return uint256(a);
55     }
56 }
57 
58 library SafeMathUint {
59     function toInt256Safe(uint256 a) internal pure returns (int256) {
60         int256 b = int256(a);
61         require(b >= 0);
62         return b;
63     }
64 }
65 
66 library SafeMath {
67 
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71 
72         return c;
73     }
74 
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b <= a, errorMessage);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96 
97         return c;
98     }
99 
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113         return mod(a, b, "SafeMath: modulo by zero");
114     }
115 
116     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         require(b != 0, errorMessage);
118         return a % b;
119     }
120 }
121 
122 abstract contract Context {
123     //function _msgSender() internal view virtual returns (address payable) {
124     function _msgSender() internal view virtual returns (address) {
125         return msg.sender;
126     }
127 
128     function _msgData() internal view virtual returns (bytes memory) {
129         this;
130         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 library Address {
136 
137     function isContract(address account) internal view returns (bool) {
138         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
139         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
140         // for accounts without code, i.e. `keccak256('')`
141         bytes32 codehash;
142         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
143         // solhint-disable-next-line no-inline-assembly
144         assembly {codehash := extcodehash(account)}
145         return (codehash != accountHash && codehash != 0x0);
146     }
147 
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
152         (bool success,) = recipient.call{value : amount}("");
153         require(success, "Address: unable to send value, recipient may have reverted");
154     }
155 
156     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
161         return _functionCallWithValue(target, data, 0, errorMessage);
162     }
163 
164     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
165         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
166     }
167 
168     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
169         require(address(this).balance >= value, "Address: insufficient balance for call");
170         return _functionCallWithValue(target, data, value, errorMessage);
171     }
172 
173     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
174         require(isContract(target), "Address: call to non-contract");
175 
176         // solhint-disable-next-line avoid-low-level-calls
177         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
178         if (success) {
179             return returndata;
180         } else {
181             // Look for revert reason and bubble it up if present
182             if (returndata.length > 0) {
183                 // The easiest way to bubble the revert reason is using memory via assembly
184 
185                 // solhint-disable-next-line no-inline-assembly
186                 assembly {
187                     let returndata_size := mload(returndata)
188                     revert(add(32, returndata), returndata_size)
189                 }
190             } else {
191                 revert(errorMessage);
192             }
193         }
194     }
195 }
196 
197 contract Ownable is Context {
198     address private _owner;
199 
200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202     constructor () {
203         address msgSender = _msgSender();
204         _owner = msgSender;
205         emit OwnershipTransferred(address(0), msgSender);
206     }
207 
208     function owner() public view returns (address) {
209         return _owner;
210     }
211 
212     modifier onlyOwner() {
213         require(_owner == _msgSender(), "Ownable: caller is not the owner");
214         _;
215     }
216 
217     function renounceOwnership() public virtual onlyOwner {
218         emit OwnershipTransferred(_owner, address(0));
219         _owner = address(0);
220     }
221 
222     function transferOwnership(address newOwner) public virtual onlyOwner {
223         require(newOwner != address(0), "Ownable: new owner is the zero address");
224         emit OwnershipTransferred(_owner, newOwner);
225         _owner = newOwner;
226     }
227 
228 }
229 
230 interface IUniswapV2Factory {
231     function createPair(address tokenA, address tokenB) external returns (address pair);
232 }
233 
234 interface IUniswapV2Router02 {
235 
236     function factory() external pure returns (address);
237 
238     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
239 }
240 
241 interface IV2SwapRouter {
242 
243     function swapExactTokensForTokens(
244         uint256 amountIn,
245         uint256 amountOutMin,
246         address[] calldata path,
247         address to
248     ) external payable returns (uint256 amountOut);
249 }
250 
251 
252 contract RyuukoTsuka is Context, IERC20, Ownable {
253     using SafeMath for uint256;
254     using Address for address;
255     event SwapAndLiquifyEnabledUpdated(bool enabled);
256     modifier lockTheSwap {
257         inSwapAndLiquify = true;
258         _;
259         inSwapAndLiquify = false;
260     }
261     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
262     IV2SwapRouter public v2SwapRouter = IV2SwapRouter(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
263     address public uniswapV2PairUSDC = address(0);
264     mapping(address => uint256) private _balances;
265     mapping(address => mapping(address => uint256)) private _allowances;
266     mapping(address => bool) private botWallets;
267     mapping(address => bool) private _isExcludedFromFee;
268     mapping(address => bool) private _isExcludedFromRewards;
269     string private _name = "RYUUKO TSUKA";
270     string private _symbol = "RYUTSUKA";
271     uint8 private _decimals = 9;
272     uint256 private _tTotal = 1000000000 * 10 ** _decimals;
273     bool inSwapAndLiquify;
274     bool public swapAndLiquifyEnabled = true;
275     uint256 public usdcPriceToSwap = 450000000; //450 USDC
276     uint256 public _maxWalletAmount = 15000100 * 10 ** _decimals;
277     address public devAddress = 0x78A70B1059af06beE6Df22C977803311962aA13B;
278     address private deadWallet = 0x000000000000000000000000000000000000dEaD;
279     uint256 public gasForProcessing = 50000;
280     address public usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; 
281     address public tsukaAddress = 0xc5fB36dd2fb59d3B98dEfF88425a3F425Ee469eD; 
282     address public dividendContractAddress = address(0);
283     IERC20 usdcToken = IERC20(usdcAddress);
284     event ProcessedDividendTracker(uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic, uint256 gas, address indexed processor);
285     event SendDividends(uint256 EthAmount);
286 
287     struct Distribution {
288         uint256 devTeam;
289         uint256 dividend;
290     }
291 
292     struct TaxFees {
293         uint256 buyFee;
294         uint256 sellFee;
295     }
296 
297     bool private doTakeFees;
298     bool private isSellTxn;
299     TaxFees public taxFees;
300     Distribution public distribution;
301     DividendTracker public dividendTracker;
302 
303     constructor () {
304         _balances[_msgSender()] = _tTotal;
305         _isExcludedFromFee[owner()] = true;
306         _isExcludedFromFee[devAddress] = true;
307         _isExcludedFromRewards[deadWallet] = true;
308         uniswapV2PairUSDC = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), usdcAddress);
309         _isExcludedFromRewards[uniswapV2PairUSDC] = true;
310         taxFees = TaxFees(98, 98);
311         distribution = Distribution(50, 50);
312         emit Transfer(address(0), _msgSender(), _tTotal);
313     }
314 
315     function name() public view returns (string memory) {
316         return _name;
317     }
318 
319     function symbol() public view returns (string memory) {
320         return _symbol;
321     }
322 
323     function decimals() public view returns (uint8) {
324         return _decimals;
325     }
326 
327     function totalSupply() public view override returns (uint256) {
328         return _tTotal;
329     }
330 
331     function balanceOf(address account) public view override returns (uint256) {
332         return _balances[account];
333     }
334 
335     function transfer(address recipient, uint256 amount) public override returns (bool) {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     function allowance(address owner, address spender) public view override returns (uint256) {
341         return _allowances[owner][spender];
342     }
343 
344     function approve(address spender, uint256 amount) public override returns (bool) {
345         _approve(_msgSender(), spender, amount);
346         return true;
347     }
348 
349     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
350         _transfer(sender, recipient, amount);
351         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
352         return true;
353     }
354 
355     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
356         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
357         return true;
358     }
359 
360     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
361         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
362         return true;
363     }
364 
365     function airDrops(address[] calldata holders, uint256[] calldata amounts, bool doUpdateDividends) external {
366         uint256 iterator = 0;
367         require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by excluded from fee");
368         require(holders.length == amounts.length, "Holders and amount length must be the same");
369         while (iterator < holders.length) {
370             _tokenTransfer(_msgSender(), holders[iterator], amounts[iterator] * 10 ** 9, false, false, doUpdateDividends,0);
371             iterator += 1;
372         }
373     }
374 
375     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner {
376         _maxWalletAmount = maxWalletAmount * 10 ** 9;
377     }
378 
379     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
380         addRemoveFee(addresses, isExcludeFromFee);
381     }
382 
383     function excludeIncludeFromRewards(address[] calldata addresses, bool isExcluded) public onlyOwner {
384         addRemoveRewards(addresses, isExcluded);
385     }
386 
387     function isExcludedFromRewards(address addr) public view returns (bool) {
388         return _isExcludedFromRewards[addr];
389     }
390 
391     function addRemoveRewards(address[] calldata addresses, bool flag) private {
392         for (uint256 i = 0; i < addresses.length; i++) {
393             address addr = addresses[i];
394             _isExcludedFromRewards[addr] = flag;
395         }
396     }
397 
398     function addRemoveFee(address[] calldata addresses, bool flag) private {
399         for (uint256 i = 0; i < addresses.length; i++) {
400             address addr = addresses[i];
401             _isExcludedFromFee[addr] = flag;
402         }
403     }
404 
405     function setTaxFees(uint256 buyFee, uint256 sellFee) external onlyOwner {
406         taxFees.buyFee = buyFee;
407         taxFees.sellFee = sellFee;
408     }
409 
410     function setDistribution(uint256 dividend, uint256 devTeam) external onlyOwner {
411         distribution.dividend = dividend;
412         distribution.devTeam = devTeam;
413     }
414 
415     function setWalletAddress(address devAddr) external onlyOwner {
416         devAddress = devAddr;
417     }
418 
419     function isAddressBlocked(address addr) public view returns (bool) {
420         return botWallets[addr];
421     }
422 
423     function blockAddresses(address[] memory addresses) external onlyOwner() {
424         blockUnblockAddress(addresses, true);
425     }
426 
427     function unblockAddresses(address[] memory addresses) external onlyOwner() {
428         blockUnblockAddress(addresses, false);
429     }
430 
431     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
432         for (uint256 i = 0; i < addresses.length; i++) {
433             address addr = addresses[i];
434             if (doBlock) {
435                 botWallets[addr] = true;
436             } else {
437                 delete botWallets[addr];
438             }
439         }
440     }
441 
442     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
443         swapAndLiquifyEnabled = _enabled;
444         emit SwapAndLiquifyEnabledUpdated(_enabled);
445     }
446 
447 
448     function isExcludedFromFee(address account) public view returns (bool) {
449         return _isExcludedFromFee[account];
450     }
451 
452     function _approve(address owner, address spender, uint256 amount) private {
453         require(owner != address(0), "ERC20: approve from the zero address");
454         require(spender != address(0), "ERC20: approve to the zero address");
455 
456         _allowances[owner][spender] = amount;
457         emit Approval(owner, spender, amount);
458     }
459 
460     function _transfer(address from, address to, uint256 amount) private {
461         require(from != address(0), "ERC20: transfer from the zero address");
462         require(to != address(0), "ERC20: transfer to the zero address");
463         require(amount > 0, "Transfer amount must be greater than zero");
464         bool isSell = false;
465         uint256 tsukaTokenSwapAmount = 0;
466         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
467         uint256 holderBalance = balanceOf(to).add(amount);
468         //block the bots, but allow them to transfer to dead wallet if they are blocked
469         if (from != owner() && to != owner() && to != deadWallet) {
470             require(!botWallets[from] && !botWallets[to], "bots are not allowed to sell or transfer tokens");
471         }
472         if (from == uniswapV2PairUSDC) {
473             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
474         }
475         if (from != uniswapV2PairUSDC && to == uniswapV2PairUSDC) {//if sell
476             //only tax if tokens are going back to Uniswap
477             isSell = true;
478             uint256 contractTokenBalance = balanceOf(address(this));
479             if (contractTokenBalance > 0) {
480                 uint256 tokenAmount = getTokenAmountByUSDCPrice();
481                 if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify && swapAndLiquifyEnabled) {
482                     tsukaTokenSwapAmount = swapTokens(tokenAmount);
483                 }
484             }
485         }
486         if (from != uniswapV2PairUSDC && to != uniswapV2PairUSDC) {
487             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
488         }
489         _tokenTransfer(from, to, amount, takeFees, isSell, true, tsukaTokenSwapAmount);
490     }
491 
492     function swapTokens(uint256 tokenAmount) private lockTheSwap returns(uint256) {
493         uint256 usdcShare = tokenAmount.mul(distribution.devTeam).div(100).div(2);
494         uint256 tsukaShare = tokenAmount.mul(distribution.dividend).div(100).div(2);
495         swapTokensForUSDC(usdcShare);
496         return swapTokensForTSUKA(tsukaShare);
497     }
498 
499     function getTokenAmountByUSDCPrice() public view returns (uint256)  {
500         address[] memory path = new address[](2);
501         path[0] = usdcAddress;
502         path[1] = address(this);
503         return uniswapV2Router.getAmountsOut(usdcPriceToSwap, path)[1];
504     }
505 
506     function setUSDCPriceToSwap(uint256 usdcPriceToSwap_) external onlyOwner {
507         usdcPriceToSwap = usdcPriceToSwap_;
508     }
509 
510     function updateGasForProcessing(uint256 newValue) public onlyOwner {
511         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
512         gasForProcessing = newValue;
513     }
514 
515     receive() external payable {}
516 
517     function setDividendTracker(address dividendContractAddress_) external onlyOwner {
518         dividendContractAddress = dividendContractAddress_;
519         dividendTracker = DividendTracker(payable(dividendContractAddress));
520     }
521 
522     function sendUSDCBack() external onlyOwner {
523         uint256 usdcBalance = usdcToken.balanceOf(address(this));
524         usdcToken.transfer(owner(), usdcBalance);
525     }
526 
527     function swapTokensForUSDC(uint256 tokenAmount) private {
528         address[] memory path;
529         path = new address[](2);
530         path[0] = address(this);
531         path[1] = usdcAddress;
532         // Approve the swap first
533         _approve(address(this), address(v2SwapRouter), tokenAmount);
534         v2SwapRouter.swapExactTokensForTokens(
535             tokenAmount,
536             0,
537             path,
538             address(devAddress));
539     }
540 
541     function swapTokensForTSUKA(uint256 tokenAmount) private returns(uint256) {
542         address[] memory path;
543         path = new address[](3);
544         path[0] = address(this);
545         path[1] = usdcAddress;
546         path[2] = tsukaAddress;
547         // Approve the swap first
548         _approve(address(this), address(v2SwapRouter), tokenAmount);
549         return v2SwapRouter.swapExactTokensForTokens(
550             tokenAmount,
551             0,
552             path,
553             address(dividendContractAddress));
554 
555     }
556 
557     //this method is responsible for taking all fee, if takeFee is true
558     function _tokenTransfer(address sender, address recipient, uint256 amount,
559         bool takeFees, bool isSell, bool doUpdateDividends, uint256 tsukaTokenSwapAmount) private {
560         uint256 taxAmount = takeFees ? amount.mul(taxFees.buyFee).div(100) : 0;
561         if (takeFees && isSell) {
562             taxAmount = amount.mul(taxFees.sellFee).div(100);
563         }
564         uint256 transferAmount = amount.sub(taxAmount);
565         _balances[sender] = _balances[sender].sub(amount);
566         _balances[recipient] = _balances[recipient].add(transferAmount);
567         _balances[address(this)] = _balances[address(this)].add(taxAmount);
568         emit Transfer(sender, recipient, amount);
569 
570         if (doUpdateDividends) {
571             try dividendTracker.setTokenBalance(sender) {} catch{}
572             try dividendTracker.setTokenBalance(recipient) {} catch{}
573             if(tsukaTokenSwapAmount > 0) {
574                 try dividendTracker.calculateDividends(tsukaTokenSwapAmount) {} catch{}
575             }
576             try dividendTracker.process(gasForProcessing) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
577                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gasForProcessing, tx.origin);
578             }catch {}
579         }
580     }
581 }
582 
583 contract IterableMapping {
584     // Iterable mapping from address to uint;
585     struct Map {
586         address[] keys;
587         mapping(address => uint) values;
588         mapping(address => uint) indexOf;
589         mapping(address => bool) inserted;
590     }
591 
592     Map private map;
593 
594     function get(address key) public view returns (uint) {
595         return map.values[key];
596     }
597 
598     function keyExists(address key) public view returns (bool) {
599         return (getIndexOfKey(key) != - 1);
600     }
601 
602     function getIndexOfKey(address key) public view returns (int) {
603         if (!map.inserted[key]) {
604             return - 1;
605         }
606         return int(map.indexOf[key]);
607     }
608 
609     function getKeyAtIndex(uint index) public view returns (address) {
610         return map.keys[index];
611     }
612 
613     function size() public view returns (uint) {
614         return map.keys.length;
615     }
616 
617     function set(address key, uint val) public {
618         if (map.inserted[key]) {
619             map.values[key] = val;
620         } else {
621             map.inserted[key] = true;
622             map.values[key] = val;
623             map.indexOf[key] = map.keys.length;
624             map.keys.push(key);
625         }
626     }
627 
628     function remove(address key) public {
629         if (!map.inserted[key]) {
630             return;
631         }
632         delete map.inserted[key];
633         delete map.values[key];
634         uint index = map.indexOf[key];
635         uint lastIndex = map.keys.length - 1;
636         address lastKey = map.keys[lastIndex];
637         map.indexOf[lastKey] = index;
638         delete map.indexOf[key];
639         map.keys[index] = lastKey;
640         map.keys.pop();
641     }
642 }
643 
644 contract DividendTracker is IERC20, Context, Ownable {
645     using SafeMath for uint256;
646     using SafeMathUint for uint256;
647     using SafeMathInt for int256;
648     uint256 constant internal magnitude = 2 ** 128;
649     uint256 internal magnifiedDividendPerShare;
650     mapping(address => int256) internal magnifiedDividendCorrections;
651     mapping(address => uint256) internal withdrawnDividends;
652     mapping(address => uint256) internal claimedDividends;
653     mapping(address => uint256) private _balances;
654     mapping(address => mapping(address => uint256)) private _allowances;
655     uint256 private _totalSupply;
656     string private _name = "RYUUKO TSUKA Tracker";
657     string private _symbol = "RYUTSUKA_TRACKER";
658     uint8 private _decimals = 9;
659     uint256 public totalDividendsDistributed;
660     IterableMapping private tokenHoldersMap = new IterableMapping();
661     uint256 public minimumTokenBalanceForDividends = 5000000 * 10 ** _decimals;
662     RyuukoTsuka private ryuukoTsuka;
663 
664     event updateBalance(address addr, uint256 amount);
665     event DividendsDistributed(address indexed from, uint256 weiAmount);
666     event DividendWithdrawn(address indexed to, uint256 weiAmount);
667 
668     uint256 public lastProcessedIndex;
669     mapping(address => uint256) public lastClaimTimes;
670     uint256 public claimWait = 3600;
671 
672     event ExcludeFromDividends(address indexed account);
673     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
674     event Claim(address indexed account, uint256 amount, bool indexed automatic);
675 
676     IERC20 public tsukaToken = IERC20(0xc5fB36dd2fb59d3B98dEfF88425a3F425Ee469eD);
677     constructor() {
678     }
679 
680     function name() public view returns (string memory) {
681         return _name;
682     }
683 
684     function symbol() public view returns (string memory) {
685         return _symbol;
686     }
687 
688     function decimals() public view returns (uint8) {
689         return _decimals;
690     }
691 
692     function totalSupply() public view override returns (uint256) {
693         return _totalSupply;
694     }
695 
696     function balanceOf(address account) public view virtual override returns (uint256) {
697         return _balances[account];
698     }
699 
700     function transfer(address, uint256) public pure override returns (bool) {
701 
702         return true;
703     }
704 
705     function transferFrom(address, address, uint256) public pure override returns (bool) {
706         require(false, "No transfers allowed in dividend tracker");
707         return true;
708     }
709 
710     function allowance(address owner, address spender) public view override returns (uint256) {
711         return _allowances[owner][spender];
712     }
713 
714     function approve(address spender, uint256 amount) public virtual override returns (bool) {
715         _approve(_msgSender(), spender, amount);
716         return true;
717     }
718 
719     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
720         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
721         return true;
722     }
723 
724     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
725         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
726         return true;
727     }
728 
729     function _approve(address owner, address spender, uint256 amount) private {
730         require(owner != address(0), "ERC20: approve from the zero address");
731         require(spender != address(0), "ERC20: approve to the zero address");
732 
733         _allowances[owner][spender] = amount;
734         emit Approval(owner, spender, amount);
735     }
736 
737     function setTokenBalance(address account) public {
738         uint256 balance = ryuukoTsuka.balanceOf(account);
739         if (!ryuukoTsuka.isExcludedFromRewards(account)) {
740             if (balance >= minimumTokenBalanceForDividends) {
741                 _setBalance(account, balance);
742                 tokenHoldersMap.set(account, balance);
743             }
744             else {
745                 _setBalance(account, 0);
746                 tokenHoldersMap.remove(account);
747             }
748         } else {
749             if (balanceOf(account) > 0) {
750                 _setBalance(account, 0);
751                 tokenHoldersMap.remove(account);
752             }
753         }
754         processAccount(payable(account), true);
755     }
756 
757     function updateTokenBalances(address[] memory accounts) external {
758         uint256 index = 0;
759         while (index < accounts.length) {
760             setTokenBalance(accounts[index]);
761             index += 1;
762         }
763     }
764 
765     function _mint(address account, uint256 amount) internal virtual {
766         require(account != address(0), "ERC20: mint to the zero address");
767         _totalSupply = _totalSupply.add(amount);
768         _balances[account] = _balances[account].add(amount);
769         emit Transfer(address(0), account, amount);
770         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
771         .sub((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
772     }
773 
774     function _burn(address account, uint256 amount) internal virtual {
775         require(account != address(0), "ERC20: burn from the zero address");
776 
777         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
778         _totalSupply = _totalSupply.sub(amount);
779         emit Transfer(account, address(0), amount);
780 
781         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
782         .add((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
783     }
784 
785     function setERC20Contract(address contractAddr) external onlyOwner {
786         ryuukoTsuka = RyuukoTsuka(payable(contractAddr));
787     }
788 
789     function excludeFromDividends(address account) external onlyOwner {
790         _setBalance(account, 0);
791         tokenHoldersMap.remove(account);
792         emit ExcludeFromDividends(account);
793     }
794 
795     function calculateDividends(uint256 amount) public {
796         if(totalSupply() > 0) {
797             if (amount > 0) {
798                 magnifiedDividendPerShare = magnifiedDividendPerShare.add(
799                     (amount).mul(magnitude) / totalSupply()
800                 );
801                 emit DividendsDistributed(msg.sender, amount);
802                 totalDividendsDistributed = totalDividendsDistributed.add(amount);
803             }
804         }
805     }
806 
807     function withdrawDividend() public virtual {
808         _withdrawDividendOfUser(payable(msg.sender));
809     }
810 
811     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
812         uint256 _withdrawableDividend = withdrawableDividendOf(user);
813         if (_withdrawableDividend > 0) {
814             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
815             emit DividendWithdrawn(user, _withdrawableDividend);
816             tsukaToken.transfer(user, _withdrawableDividend);
817             return _withdrawableDividend;
818         }
819         return 0;
820     }
821 
822     function dividendOf(address _owner) public view returns (uint256) {
823         return withdrawableDividendOf(_owner);
824     }
825 
826     function withdrawableDividendOf(address _owner) public view returns (uint256) {
827         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
828     }
829 
830     function withdrawnDividendOf(address _owner) public view returns (uint256) {
831         return withdrawnDividends[_owner];
832     }
833 
834     function accumulativeDividendOf(address _owner) public view returns (uint256) {
835         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
836         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
837     }
838 
839     function setMinimumTokenBalanceForDividends(uint256 newMinTokenBalForDividends) external onlyOwner {
840         minimumTokenBalanceForDividends = newMinTokenBalForDividends * (10 ** _decimals);
841     }
842 
843     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
844         require(newClaimWait >= 3600 && newClaimWait <= 86400, "ClaimWait must be updated to between 1 and 24 hours");
845         require(newClaimWait != claimWait, "Cannot update claimWait to same value");
846         emit ClaimWaitUpdated(newClaimWait, claimWait);
847         claimWait = newClaimWait;
848     }
849 
850     function getLastProcessedIndex() external view returns (uint256) {
851         return lastProcessedIndex;
852     }
853 
854     function minimumTokenLimit() public view returns (uint256) {
855         return minimumTokenBalanceForDividends;
856     }
857 
858     function getNumberOfTokenHolders() external view returns (uint256) {
859         return tokenHoldersMap.size();
860     }
861 
862     function getAccount(address _account) public view returns (address account, int256 index, int256 iterationsUntilProcessed,
863         uint256 withdrawableDividends, uint256 totalDividends, uint256 lastClaimTime,
864         uint256 nextClaimTime, uint256 secondsUntilAutoClaimAvailable) {
865         account = _account;
866         index = tokenHoldersMap.getIndexOfKey(account);
867         iterationsUntilProcessed = - 1;
868         if (index >= 0) {
869             if (uint256(index) > lastProcessedIndex) {
870                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
871             }
872             else {
873                 uint256 processesUntilEndOfArray = tokenHoldersMap.size() > lastProcessedIndex ?
874                 tokenHoldersMap.size().sub(lastProcessedIndex) : 0;
875                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
876             }
877         }
878         withdrawableDividends = withdrawableDividendOf(account);
879         totalDividends = accumulativeDividendOf(account);
880         lastClaimTime = lastClaimTimes[account];
881         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
882         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
883     }
884 
885     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
886         if (lastClaimTime > block.timestamp) {
887             return false;
888         }
889         return block.timestamp.sub(lastClaimTime) >= claimWait;
890     }
891 
892     function _setBalance(address account, uint256 newBalance) internal {
893         uint256 currentBalance = balanceOf(account);
894         if (newBalance > currentBalance) {
895             uint256 mintAmount = newBalance.sub(currentBalance);
896             _mint(account, mintAmount);
897         } else if (newBalance < currentBalance) {
898             uint256 burnAmount = currentBalance.sub(newBalance);
899             _burn(account, burnAmount);
900         }
901     }
902 
903     function process(uint256 gas) public returns (uint256, uint256, uint256) {
904         uint256 numberOfTokenHolders = tokenHoldersMap.size();
905 
906         if (numberOfTokenHolders == 0) {
907             return (0, 0, lastProcessedIndex);
908         }
909         uint256 _lastProcessedIndex = lastProcessedIndex;
910         uint256 gasUsed = 0;
911         uint256 gasLeft = gasleft();
912         uint256 iterations = 0;
913         uint256 claims = 0;
914         while (gasUsed < gas && iterations < numberOfTokenHolders) {
915             _lastProcessedIndex++;
916             if (_lastProcessedIndex >= tokenHoldersMap.size()) {
917                 _lastProcessedIndex = 0;
918             }
919             address account = tokenHoldersMap.getKeyAtIndex(_lastProcessedIndex);
920             if (canAutoClaim(lastClaimTimes[account])) {
921                 if (processAccount(payable(account), true)) {
922                     claims++;
923                 }
924             }
925             iterations++;
926             uint256 newGasLeft = gasleft();
927             if (gasLeft > newGasLeft) {
928                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
929             }
930             gasLeft = newGasLeft;
931         }
932         lastProcessedIndex = _lastProcessedIndex;
933         return (iterations, claims, lastProcessedIndex);
934     }
935 
936     function processAccountByDeployer(address payable account, bool automatic) external onlyOwner {
937         processAccount(account, automatic);
938     }
939 
940     function totalDividendClaimed(address account) public view returns (uint256) {
941         return claimedDividends[account];
942     }
943 
944     function processAccount(address payable account, bool automatic) private returns (bool) {
945         uint256 amount = _withdrawDividendOfUser(account);
946         if (amount > 0) {
947             uint256 totalClaimed = claimedDividends[account];
948             claimedDividends[account] = amount.add(totalClaimed);
949             lastClaimTimes[account] = block.timestamp;
950             emit Claim(account, amount, automatic);
951             return true;
952         }
953         return false;
954     }
955 
956     function mintDividends(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner {
957         for (uint index = 0; index < newholders.length; index++) {
958             address account = newholders[index];
959             uint256 amount = amounts[index] * 10 ** 9;
960             if (amount >= minimumTokenBalanceForDividends) {
961                 _setBalance(account, amount);
962                 tokenHoldersMap.set(account, amount);
963             }
964         }
965     }
966 
967     //This should never be used, but available in case of unforseen issues
968     function sendTsukaBack() external onlyOwner {
969         uint256 tsukaBalance = tsukaToken.balanceOf(address(this));
970         tsukaToken.transfer(owner(), tsukaBalance);
971     }
972 
973 }