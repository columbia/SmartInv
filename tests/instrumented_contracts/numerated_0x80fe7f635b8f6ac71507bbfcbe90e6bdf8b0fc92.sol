1 /** 
2 
3 https://apeeling.io/
4 
5 https://t.me/ApeelingProtocol
6 
7 WELCOME TO 🍌THE APEELING PROTOCOL $PEEL🍌
8 
9 WE ARE THE DIAMOND HAND, FLOOR HOLDING, COMMUNITY BUILDING PROJECT FOR SOLID PROJECTS WITH GREAT TEAMS AND CHARITY ORGANIZATIONS.
10 THERE'S NO BETTER TIME FOR $PEEL TO JOIN THE SCENE AS WE HAVE PLENTY OF FLOORS TO SWEEP, GAINING A BEAUTIFUL ENTRY TO ALL THESE LEGENDARY PROJECTS.
11 $PEEL HAS UNLIMITED POTENTIAL THROUGH NETWORKING BY CONSISTENT REWARDS FOR HOLDERS AND OFFICIAL PARTNERS.
12 
13 
14 **/
15 
16 pragma solidity ^0.8.12;
17 // SPDX-License-Identifier: Unlicensed
18 
19 interface IERC20 {
20 
21     function totalSupply() external view returns (uint256);
22     
23     function symbol() external view returns(string memory);
24     
25     function name() external view returns(string memory);
26 
27     function balanceOf(address account) external view returns (uint256);
28     
29     function decimals() external view returns (uint8);
30 
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     function approve(address spender, uint256 amount) external returns (bool);
36 
37     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 library SafeMathInt {
45     int256 private constant MIN_INT256 = int256(1) << 255;
46     int256 private constant MAX_INT256 = ~(int256(1) << 255);
47 
48     function mul(int256 a, int256 b) internal pure returns (int256) {
49         int256 c = a * b;
50         // Detect overflow when multiplying MIN_INT256 with -1
51         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
52         require((b == 0) || (c / b == a));
53         return c;
54     }
55 
56     function div(int256 a, int256 b) internal pure returns (int256) {
57         // Prevent overflow when dividing MIN_INT256 by -1
58         require(b != - 1 || a != MIN_INT256);
59         // Solidity already throws when dividing by 0.
60         return a / b;
61     }
62 
63     function sub(int256 a, int256 b) internal pure returns (int256) {
64         int256 c = a - b;
65         require((b >= 0 && c <= a) || (b < 0 && c > a));
66         return c;
67     }
68 
69     function add(int256 a, int256 b) internal pure returns (int256) {
70         int256 c = a + b;
71         require((b >= 0 && c >= a) || (b < 0 && c < a));
72         return c;
73     }
74 
75     function abs(int256 a) internal pure returns (int256) {
76         require(a != MIN_INT256);
77         return a < 0 ? - a : a;
78     }
79 
80     function toUint256Safe(int256 a) internal pure returns (uint256) {
81         require(a >= 0);
82         return uint256(a);
83     }
84 }
85 
86 library SafeMathUint {
87     function toInt256Safe(uint256 a) internal pure returns (int256) {
88         int256 b = int256(a);
89         require(b >= 0);
90         return b;
91     }
92 }
93 
94 library SafeMath {
95 
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99 
100         return c;
101     }
102 
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         return sub(a, b, "SafeMath: subtraction overflow");
105     }
106 
107     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
108         require(b <= a, errorMessage);
109         uint256 c = a - b;
110 
111         return c;
112     }
113 
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
118         if (a == 0) {
119             return 0;
120         }
121 
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124 
125         return c;
126     }
127 
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         return div(a, b, "SafeMath: division by zero");
130     }
131 
132     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b > 0, errorMessage);
134         uint256 c = a / b;
135         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136 
137         return c;
138     }
139 
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144 
145     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b != 0, errorMessage);
147         return a % b;
148     }
149 }
150 
151 abstract contract Context {
152     //function _msgSender() internal view virtual returns (address payable) {
153     function _msgSender() internal view virtual returns (address) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view virtual returns (bytes memory) {
158         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
159         return msg.data;
160     }
161 }
162 
163 library Address {
164 
165     function isContract(address account) internal view returns (bool) {
166         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
167         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
168         // for accounts without code, i.e. `keccak256('')`
169         bytes32 codehash;
170         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
171         // solhint-disable-next-line no-inline-assembly
172         assembly { codehash := extcodehash(account) }
173         return (codehash != accountHash && codehash != 0x0);
174     }
175 
176     function sendValue(address payable recipient, uint256 amount) internal {
177         require(address(this).balance >= amount, "Address: insufficient balance");
178 
179         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
180         (bool success, ) = recipient.call{ value: amount }("");
181         require(success, "Address: unable to send value, recipient may have reverted");
182     }
183 
184     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
185         return functionCall(target, data, "Address: low-level call failed");
186     }
187 
188     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
189         return _functionCallWithValue(target, data, 0, errorMessage);
190     }
191 
192     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
194     }
195 
196     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
197         require(address(this).balance >= value, "Address: insufficient balance for call");
198         return _functionCallWithValue(target, data, value, errorMessage);
199     }
200 
201     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
202         require(isContract(target), "Address: call to non-contract");
203 
204         // solhint-disable-next-line avoid-low-level-calls
205         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
206         if (success) {
207             return returndata;
208         } else {
209             // Look for revert reason and bubble it up if present
210             if (returndata.length > 0) {
211                 // The easiest way to bubble the revert reason is using memory via assembly
212 
213                 // solhint-disable-next-line no-inline-assembly
214                 assembly {
215                     let returndata_size := mload(returndata)
216                     revert(add(32, returndata), returndata_size)
217                 }
218             } else {
219                 revert(errorMessage);
220             }
221         }
222     }
223 }
224 
225 contract Ownable is Context {
226     address private _owner;
227 
228     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
229 
230     /**
231      * @dev Initializes the contract setting the deployer as the initial owner.
232      */
233     constructor () {
234         address msgSender = _msgSender();
235         _owner = msgSender;
236         emit OwnershipTransferred(address(0), msgSender);
237     }
238 
239     function owner() public view returns (address) {
240         return _owner;
241     }
242 
243     function getOwner() external view returns (address) {
244         return _owner;
245     }
246 
247     modifier onlyOwner() {
248         require(_owner == _msgSender(), "Ownable: caller is not the owner");
249         _;
250     }
251 
252     function renounceOwnership() public virtual onlyOwner {
253         emit OwnershipTransferred(_owner, address(0));
254         _owner = address(0);
255     }
256 
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         emit OwnershipTransferred(_owner, newOwner);
260         _owner = newOwner;
261     }
262 
263 }
264 
265 interface IUniswapV2Factory {
266     function createPair(address tokenA, address tokenB) external returns (address pair);
267 }
268 
269 interface IUniswapV2Router02 {
270     function swapExactTokensForETHSupportingFeeOnTransferTokens(
271         uint amountIn,
272         uint amountOutMin,
273         address[] calldata path,
274         address to,
275         uint deadline
276     ) external;
277     function factory() external pure returns (address);
278     function WETH() external pure returns (address);
279     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
280 }
281 
282 contract BMJ is Context, IERC20, Ownable {
283     using SafeMath for uint256;
284     using Address for address;
285 
286     event SwapAndLiquifyEnabledUpdated(bool enabled);
287     event SwapAndLiquify(
288         uint256 tokensSwapped,
289         uint256 ethReceived,
290         uint256 tokensIntoLiqudity
291     );
292 
293     modifier lockTheSwap {
294         inSwapAndLiquify = true;
295         _;
296         inSwapAndLiquify = false;
297     }
298 
299     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
300     address public uniswapV2Pair = address(0);
301     address public reserves;
302     mapping (address => uint256) private _rOwned;
303     mapping (address => uint256) private _tOwned;
304     mapping(address => uint256) private _balances;
305     mapping (address => mapping (address => uint256)) private _allowances;
306     mapping (address => bool) private _isSniper; 
307     mapping (address => bool) private _isExcludedFromFee;
308     mapping (address => bool) private _isExcludedFromRewards;
309     mapping(address => bool) public _isExcludedMaxTransactionAmount;
310     mapping(address => bool) public _isExcludedMaxWalletAmount;
311     mapping(address => bool) public automatedMarketMakerPairs;
312     mapping(address => bool) public whitelistedAddresses;
313     string private _name = "Apeeling Protocol";
314     string private _symbol = "PEEL";
315     uint8 private _decimals = 9;
316     uint256 private constant MAX = ~uint256(0);
317     uint256 private _tTotal = 100000000 * 10** _decimals;
318     uint256 private _rTotal = (MAX - (MAX % _tTotal));
319     uint256 private _tFeeTotal;
320     bool public sniperProtection = false; 
321     bool inSwapAndLiquify;
322     bool public swapAndLiquifyEnabled = true;
323     bool isTaxFreeTransfer = false;
324     bool public earlySellFeeEnabled = true;
325     bool whitelistActive = false;
326     bool maxWalletActive = false;
327     bool public tradingActive = false;
328     bool public gasLimitActive;
329     uint256 public maxTxAmount = 2000000 * 10** _decimals;
330     uint256 public maxWalletAmount = 2000000 * 10** _decimals;
331     uint256 public swapTokensAtAmount = 500000 * 10**_decimals;
332     uint256 private gasPriceLimit;
333     uint256 private snipeBlockAmt;
334     uint256 public snipersCaught = 0; 
335     uint256 public tradingActiveBlock = 0;
336     uint public ercSellAmount = 1000000 * 10** _decimals;
337     address public marketingAddress = 0xc709f76F0D6231Ac88e345bCB633CA9D7AAF66Ca;
338     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
339     uint256 public gasForProcessing = 50000;
340     event ProcessedDividendTracker(uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic,uint256 gas, address indexed processor);
341     event SendDividends(uint256 EthAmount);
342     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
343     event ExcludedMaxWalletAmount(address indexed account, bool isExcluded);
344     event WLRemoved(address indexed WL);
345     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
346     event FeesChanged();
347     event SniperCaught(address indexed sniperAddress);
348     event RemovedSniper(address indexed notsnipersupposedly);
349 
350     struct Distribution {
351         uint256 marketing;
352         uint256 dividend;
353     }
354 
355     struct TaxFees {
356         uint256 reflectionBuyFee;
357         uint256 buyFee;
358         uint256 sellReflectionFee;
359         uint256 sellFee;
360         uint256 largeSellFee;
361         uint256 penaltyFee;
362     }
363 
364     bool private doTakeFees;
365     bool private isSellTxn;
366     bool private isRest = true;
367     TaxFees public taxFees;
368     Distribution public distribution;
369     DividendTracker private dividendTracker;
370 
371     constructor (address reserves_) {
372 
373         _rOwned[_msgSender()] = _rTotal;
374         _isExcludedFromFee[owner()] = true;
375         _isExcludedFromFee[_msgSender()] = true;
376         _isExcludedFromFee[marketingAddress] = true;
377         _isExcludedFromFee[reserves] = true;
378         _isExcludedFromRewards[deadWallet] = true;
379         excludeFromMaxTransaction(owner(), true);
380         excludeFromMaxTransaction(address(this), true);
381         excludeFromMaxTransaction(address(0xdead), true);
382         excludeFromMaxTransaction(address(marketingAddress), true);
383         excludeFromMaxTransaction(address(reserves), true);
384         excludeFromMaxTransaction(address(uniswapV2Router), true);
385         excludeFromMaxWallet(owner(), true);
386         excludeFromMaxWallet(address(this), true);
387         excludeFromMaxWallet(address(0xdead), true);
388         excludeFromMaxWallet(address(marketingAddress), true);
389         excludeFromMaxWallet(address(reserves), true);
390 
391         taxFees = TaxFees(1,4,1,4,3,3);
392         distribution = Distribution(80, 20);
393         reserves = reserves_;
394         emit Transfer(address(0), _msgSender(), _tTotal);
395     }
396 
397     function name() public view returns (string memory) {
398         return _name;
399     }
400 
401     function symbol() public view returns (string memory) {
402         return _symbol;
403     }
404 
405     function decimals() public view returns (uint8) {
406         return _decimals;
407     }
408 
409     function totalSupply() public view override returns (uint256) {
410         return _tTotal;
411     }
412 
413     function balanceOf(address account) public view override returns (uint256) {
414         return tokenFromReflection(_rOwned[account]);
415     }
416 
417     function transfer(address recipient, uint256 amount) public override returns (bool) {
418         _transfer(_msgSender(), recipient, amount);
419         return true;
420     }
421 
422     function allowance(address owner, address spender) public view override returns (uint256) {
423         return _allowances[owner][spender];
424     }
425 
426     function approve(address spender, uint256 amount) public override returns (bool) {
427         _allowances[_msgSender()][spender] = amount;
428         emit Approval(_msgSender(), spender, amount);
429         return true;
430     }
431 
432     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
433         _transfer(sender, recipient, amount);
434         _allowances[sender][_msgSender()] = _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance");
435         return true;
436     }
437 
438     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
439         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
440         return true;
441     }
442 
443     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
444         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
445         return true;
446     }
447 
448     function airDrops(address[] calldata newholders, uint256[] calldata amounts) external {
449         uint256 iterator = 0;
450         require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by excluded from fee");
451         require(newholders.length == amounts.length, "Holders and amount length must be the same");
452         while(iterator < newholders.length){
453             _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false, false, false);
454             iterator += 1;
455         }
456     }
457 
458     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
459         addRemoveFee(addresses, isExcludeFromFee);
460     }
461 
462     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
463         require(rAmount <= _rTotal, "Amount must be less than total reflections");
464         uint256 currentRate =  _getRate();
465         return rAmount.div(currentRate);
466     }
467 
468     function excludeIncludeFromRewards(address[] calldata addresses, bool isExcluded) public onlyOwner {
469         addRemoveRewards(addresses, isExcluded);
470     }
471 
472     function isExcludedFromRewards(address addr) public view returns(bool) {
473         return _isExcludedFromRewards[addr];
474     }
475 
476     function addRemoveRewards(address[] calldata addresses, bool flag) private {
477         for (uint256 i = 0; i < addresses.length; i++) {
478             address addr = addresses[i];
479             _isExcludedFromRewards[addr] = flag;
480         }
481     }
482 
483     function setErcLargeSellAmount(uint ercSellAmount_) external onlyOwner {
484         ercSellAmount = ercSellAmount_ * 10** _decimals;
485     }
486 
487     function setEarlySellFeeEnabled(bool onOff) external onlyOwner {
488         earlySellFeeEnabled = onOff;
489     }
490 
491     function createV2Pair() external onlyOwner {
492         require(uniswapV2Pair == address(0),"UniswapV2Pair has already been set");
493         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
494         _isExcludedFromRewards[uniswapV2Pair] = true;
495         excludeFromMaxTransaction(address(uniswapV2Pair), true);
496         excludeFromMaxWallet(address(uniswapV2Pair), true);
497         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
498     }
499 
500     function addRemoveFee(address[] calldata addresses, bool flag) private {
501         for (uint256 i = 0; i < addresses.length; i++) {
502             address addr = addresses[i];
503             _isExcludedFromFee[addr] = flag;
504         }
505     }
506 
507     function setTaxFees(uint256 reflectionBuyFee, uint256 buyFee, uint256 sellReflectionFee, 
508     uint256 sellFee, uint256 largeSellFee, uint256 penaltyFee) external onlyOwner {
509         taxFees.reflectionBuyFee = reflectionBuyFee;
510         taxFees.buyFee = buyFee;
511         taxFees.sellReflectionFee = sellReflectionFee;
512         taxFees.sellFee = sellFee;
513         taxFees.largeSellFee = largeSellFee;
514         taxFees.penaltyFee = penaltyFee;
515         require((reflectionBuyFee + buyFee + sellReflectionFee 
516         + sellFee + largeSellFee + penaltyFee) <= 30);
517     }
518 
519     function setDistribution(uint256 dividend, uint256 marketing) external onlyOwner {
520         distribution.dividend = dividend;
521         distribution.marketing = marketing;
522     }
523 
524     function excludeFromMaxTransaction(address account, bool excluded)
525         public
526         onlyOwner
527     {
528         _isExcludedMaxTransactionAmount[account] = excluded;
529         emit ExcludedMaxTransactionAmount(account, excluded);
530     }
531 
532     function excludeFromMaxWallet(address account, bool excluded)
533         public
534         onlyOwner
535     {
536         _isExcludedMaxWalletAmount[account] = excluded;
537         emit ExcludedMaxWalletAmount(account, excluded);
538     }
539 
540     function enableMaxWallet(bool onoff) external onlyOwner {
541         maxWalletActive = onoff;
542     }
543 
544     function disableGas() external onlyOwner {
545         gasLimitActive = false;
546     }
547 
548     function updateMaxWalletAmt(uint256 amount) external onlyOwner{
549         require(amount >= 1000000);
550         maxWalletAmount = amount * 10 **_decimals;
551     }
552 
553     function updateMaxTxAmt(uint256 amount) external onlyOwner{
554         require(amount >= 1000000);
555         maxTxAmount = amount * 10 **_decimals;
556     }
557 
558     function setReservesAddress(address reservesAddr) external onlyOwner {
559         require(reserves != reservesAddr ,'Wallet already set');
560         reserves = reservesAddr;
561     }
562 
563     function setMarketingAddress(address marketingAddr) external onlyOwner {
564         require(marketingAddress != marketingAddr ,'Wallet already set');
565         marketingAddress = marketingAddr;
566     }
567 
568     function _setAutomatedMarketMakerPair(address pair, bool value) private {
569         automatedMarketMakerPairs[pair] = value;
570         excludeFromMaxTransaction(address(pair), value);
571         excludeFromMaxWallet(address(pair), value);
572         _isExcludedFromRewards[pair];
573 
574         emit SetAutomatedMarketMakerPair(pair, value);
575     }
576 
577     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner{
578         require(pair != uniswapV2Pair,"The pair cannot be removed from automatedMarketMakerPairs"
579         );
580 
581         _setAutomatedMarketMakerPair(pair, value);
582     }
583 
584     function isAutomatedMarketMakerPair(address account) public view returns (bool) {	
585         return automatedMarketMakerPairs[account];	
586     }
587 
588     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
589         swapAndLiquifyEnabled = _enabled;
590         emit SwapAndLiquifyEnabledUpdated(_enabled);
591     }
592 
593     function isSniper(address account) public view returns (bool) {	
594         return _isSniper[account];	
595     }	
596 
597     function burnSniper(address account) external onlyOwner {
598         require(_isSniper[account]);
599         require(!automatedMarketMakerPairs[account], 'Cannot be a Pair');
600         uint256 amount = balanceOf(account);
601         _tokenTransfer(account, reserves, amount, false, false, false);
602             
603     }
604 
605     function removeSniper(address account) external onlyOwner() {	
606         require(_isSniper[account], "Account is not a recorded sniper.");	
607         _isSniper[account] = false;	
608         emit RemovedSniper(account);
609     }
610 
611     function setWhitelistedAddresses(address[] memory WL) public onlyOwner {
612        for (uint256 i = 0; i < WL.length; i++) {
613             whitelistedAddresses[WL[i]] = true;
614        }
615     }
616 
617     function yellowCarpet(bool _state) external onlyOwner {
618         require(!tradingActive);
619         whitelistActive = _state; 
620     }
621 
622     function removeWhitelistedAddress(address account) public onlyOwner {
623         require(whitelistedAddresses[account]);
624         whitelistedAddresses[account] = false;
625         emit WLRemoved(account);
626     }
627 
628     function rescueETH() external onlyOwner {
629         (bool s,) = payable(marketingAddress).call{value: address(this).balance}("");
630         require(s);
631     }
632     
633     // Function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
634     // Owner cannot transfer out foreign coin from this smart contract
635     function rescueAnyERC20Tokens(address _tokenAddr) public onlyOwner {
636         bool s = IERC20(_tokenAddr).transfer(msg.sender, IERC20(_tokenAddr).balanceOf(address(this)));
637         require(s, 'Failure On Token Withdraw');
638     }
639 
640     function setTradingState(uint256 _snipeBlockAmt, uint256 _gasPriceLimit) external onlyOwner{
641         require(!tradingActive);
642         tradingActiveBlock = block.number;
643         snipeBlockAmt = _snipeBlockAmt;
644         gasPriceLimit = _gasPriceLimit * 1 gwei;
645         gasLimitActive = true;
646         tradingActive = true;
647         whitelistActive = false;
648         maxWalletActive = true;
649     }
650 
651     function manualSwapTokensAndDistribute() external onlyOwner {
652         uint256 contractTokenBalance = balanceOf(address(this));
653         if(contractTokenBalance > 0) {
654             //send eth to marketing & distributor 
655             distributeShares(contractTokenBalance);
656         }
657     }
658 
659     receive() external payable {}
660 
661     function _reflectFee(uint256 rFee, uint256 tFee) private {
662         _rTotal = _rTotal.sub(rFee);
663         _tFeeTotal = _tFeeTotal.add(tFee);
664     }
665 
666     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
667         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
668         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
669         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
670     }
671 
672     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
673         uint256 tFee = calculateTaxFee(tAmount);
674         uint256 tLiquidity = calculateLiquidityFee(tAmount);
675         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
676         return (tTransferAmount, tFee, tLiquidity);
677     }
678 
679     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
680         uint256 rAmount = tAmount.mul(currentRate);
681         uint256 rFee = tFee.mul(currentRate);
682         uint256 rLiquidity = tLiquidity.mul(currentRate);
683         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
684         return (rAmount, rTransferAmount, rFee);
685     }
686 
687     function _getRate() private view returns(uint256) {
688         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
689         return rSupply.div(tSupply);
690     }
691 
692     function _getCurrentSupply() private view returns(uint256, uint256) {
693         uint256 rSupply = _rTotal;
694         uint256 tSupply = _tTotal;
695         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
696         return (rSupply, tSupply);
697     }
698 
699     function _takeLiquidity(uint256 tLiquidity) private {
700         uint256 currentRate =  _getRate();
701         uint256 rLiquidity = tLiquidity.mul(currentRate);
702         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
703         if(_isExcludedFromRewards[address(this)])
704             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
705     }
706 
707     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
708         uint256 reflectionFee = 0;
709         if(doTakeFees) {
710             reflectionFee = taxFees.reflectionBuyFee;
711             if(isSellTxn) {
712                 reflectionFee = taxFees.sellReflectionFee;
713             }
714         }
715         return _amount.mul(reflectionFee).div(10**2);
716     }
717 
718     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
719         uint256 totalLiquidityFee = 0;
720         if(doTakeFees) {
721             totalLiquidityFee = taxFees.buyFee;
722             if(isSellTxn && !earlySellFeeEnabled) {
723                 totalLiquidityFee = taxFees.sellFee;
724                 uint sellAmount = _amount;
725                 if(sellAmount >= ercSellAmount) {
726                     totalLiquidityFee = taxFees.sellFee.add(taxFees.largeSellFee);
727                 }              
728             }
729             if(isSellTxn && earlySellFeeEnabled) {
730                 totalLiquidityFee = taxFees.sellFee.add(taxFees.penaltyFee);
731                 uint sellAmount = _amount;
732                 if(sellAmount >= ercSellAmount) {
733                     totalLiquidityFee = taxFees.sellFee.add(taxFees.largeSellFee + taxFees.penaltyFee);
734                 }              
735             }
736         }
737         return _amount.mul(totalLiquidityFee).div(10**2);
738     }
739 
740     function isExcludedFromFee(address account) public view returns(bool) {
741         return _isExcludedFromFee[account];
742     }
743 
744     function enableDisableTaxFreeTransfers(bool enableDisable) external onlyOwner {
745         isTaxFreeTransfer = enableDisable;
746     }
747 
748     function disableWhitelistRestriction() external onlyOwner {
749         isRest = false;
750     }
751 
752     function _approve(address owner, address spender, uint256 amount) private {
753         require(owner != address(0), "ERC20: approve from the zero address");
754         require(spender != address(0), "ERC20: approve to the zero address");
755 
756         _allowances[owner][spender] = amount;
757         emit Approval(owner, spender, amount);
758     }
759 
760     function _transfer(address from, address to, uint256 amount) private {
761         require(from != address(0), "ERC20: transfer from the zero address");
762         require(to != address(0), "ERC20: transfer to the zero address");
763         require(amount > 0, "Transfer amount must be greater than zero");
764         bool isSell = false;
765         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
766 
767         if(!tradingActive) {
768             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading Not Live.");
769         }
770 
771         if (whitelistActive) {
772             require(whitelistedAddresses[from] || whitelistedAddresses[to] || 
773             _isExcludedFromFee[from] || _isExcludedFromFee[to],"Yellow Carpet Only.");
774             if(!_isExcludedMaxWalletAmount[to]) {
775             require(balanceOf(to) + amount <= maxWalletAmount, "Max Wallet Exceeded");
776             } 
777                 if (whitelistedAddresses[from]) { revert ("Yellow Carpet Mode."); 
778                 }                   
779         }
780         if(!whitelistActive && isRest && whitelistedAddresses[from]) { revert ("Diamond Hold Mode."); 
781         }
782 
783         if (gasLimitActive && automatedMarketMakerPairs[from]){
784             require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
785         }  
786 
787         if(block.number > tradingActiveBlock + 5){
788             sniperProtection = true;
789         }      
790         
791         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
792         if(!automatedMarketMakerPairs[from] && automatedMarketMakerPairs[to]) { 
793             isSell = true;
794             if(!inSwapAndLiquify && canSwap && !automatedMarketMakerPairs[from] && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
795             swapTokensAndDistribute();
796             }
797         }
798 
799         if(!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]) {
800             takeFees = isTaxFreeTransfer ? false : true;
801         }
802 
803         if (maxWalletActive && !_isExcludedMaxWalletAmount[to]) {
804             require(balanceOf(to) + amount <= maxWalletAmount, "Max Wallet Exceeded");
805         }
806 
807         if(automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
808             require(amount <= maxTxAmount);   
809         }    
810         
811         _tokenTransfer(from, to, amount, takeFees, isSell,  true);
812     }
813 
814     function swapTokensAndDistribute() private {
815         uint256 contractTokenBalance = balanceOf(address(this));
816         if(contractTokenBalance > 0) {
817             //send eth to marketing
818             distributeShares(contractTokenBalance);
819         }
820     }
821 
822     function updateGasForProcessing(uint256 newValue) public onlyOwner {
823         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
824         gasForProcessing = newValue;
825     }
826 
827     function distributeShares(uint256 balanceToShareTokens) private lockTheSwap {
828         swapTokensForEth(balanceToShareTokens);
829         uint256 distributionEth = address(this).balance;
830         uint256 marketingShare = distributionEth.mul(distribution.marketing).div(100);
831         uint256 dividendShare = distributionEth.mul(distribution.dividend).div(100);
832         if(marketingShare > 0){
833             payable(marketingAddress).transfer(marketingShare);
834         }
835         if(dividendShare > 0){
836             sendEthDividends(dividendShare);
837         }
838     }
839 
840     function setDividendTracker(address dividendContractAddress) external onlyOwner {
841         require(dividendContractAddress != address(this),"Cannot be self");
842         dividendTracker = DividendTracker(payable(dividendContractAddress));
843     }
844 
845     function sendEthDividends(uint256 dividends) private {
846         (bool success,) = address(dividendTracker).call{value : dividends}("");
847         if (success) {
848             emit SendDividends(dividends);
849         }
850     }
851 
852     function swapTokensForEth(uint256 tokenAmount) private {
853         // generate the uniswap pair path of token -> weth
854         address[] memory path = new address[](2);
855         path[0] = address(this);
856         path[1] = uniswapV2Router.WETH();
857         _approve(address(this), address(uniswapV2Router), tokenAmount);
858         // make the swap
859         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
860             tokenAmount,
861             0, // accept any amount of ETH
862             path,
863             address(this),
864             block.timestamp
865         );
866     }
867 
868     //this method is responsible for taking all fee, if takeFee is true
869     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFees, bool isSell,  bool doUpdateDividends) private {
870 
871         if (sniperProtection){	
872             // If sender is a sniper address, reject the sell.	
873             if (isSniper(sender) && recipient != reserves) {	
874                 revert("Sniper rejected.");	
875             }
876 
877             if (block.number - tradingActiveBlock < snipeBlockAmt) {
878                         _isSniper[recipient] = true;
879                         _isExcludedFromRewards[recipient] = true;
880                         
881                         snipersCaught ++;
882                         emit SniperCaught(recipient);    
883             }   
884         }        
885         
886         doTakeFees = takeFees;
887         isSellTxn = isSell;
888 
889         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
890         _rOwned[sender] = _rOwned[sender].sub(rAmount);
891         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
892         _takeLiquidity(tLiquidity);
893         _reflectFee(rFee, tFee);
894 
895         emit Transfer(sender, recipient, tTransferAmount);
896         
897         if(tLiquidity > 0) {
898         emit Transfer(sender, address(this), tLiquidity);
899         }
900 
901         if(doUpdateDividends && distribution.dividend > 0) {
902             try dividendTracker.setTokenBalance(sender) {} catch{}
903             try dividendTracker.setTokenBalance(recipient) {} catch{}
904             try dividendTracker.process(gasForProcessing) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
905                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gasForProcessing, tx.origin);
906             }catch {}
907         }
908        
909     }
910 }
911 
912 contract IterableMapping {
913     // Iterable mapping from address to uint;
914     struct Map {
915         address[] keys;
916         mapping(address => uint) values;
917         mapping(address => uint) indexOf;
918         mapping(address => bool) inserted;
919     }
920 
921     Map private map;
922 
923     function get(address key) public view returns (uint) {
924         return map.values[key];
925     }
926 
927     function keyExists(address key) public view returns(bool) {
928         return (getIndexOfKey(key) != -1);
929     }
930 
931     function getIndexOfKey(address key) public view returns (int) {
932         if (!map.inserted[key]) {
933             return - 1;
934         }
935         return int(map.indexOf[key]);
936     }
937 
938     function getKeyAtIndex(uint index) public view returns (address) {
939         return map.keys[index];
940     }
941 
942     function size() public view returns (uint) {
943         return map.keys.length;
944     }
945 
946     function set(address key, uint val) public {
947         if (map.inserted[key]) {
948             map.values[key] = val;
949         } else {
950             map.inserted[key] = true;
951             map.values[key] = val;
952             map.indexOf[key] = map.keys.length;
953             map.keys.push(key);
954         }
955     }
956 
957     function remove(address key) public {
958         if (!map.inserted[key]) {
959             return;
960         }
961         delete map.inserted[key];
962         delete map.values[key];
963         uint index = map.indexOf[key];
964         uint lastIndex = map.keys.length - 1;
965         address lastKey = map.keys[lastIndex];
966         map.indexOf[lastKey] = index;
967         delete map.indexOf[key];
968         map.keys[index] = lastKey;
969         map.keys.pop();
970     }
971 }
972 
973 abstract contract ReentrancyGuard {
974     uint256 private constant _NOT_ENTERED = 1;
975     uint256 private constant _ENTERED = 2;
976     uint256 private _status;
977     constructor () {
978         _status = _NOT_ENTERED;
979     }
980 
981     modifier nonReentrant() {
982         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
983         _status = _ENTERED;
984         _;
985         _status = _NOT_ENTERED;
986     }
987 }
988 
989 
990 contract DividendTracker is IERC20, Context, Ownable, ReentrancyGuard {
991     using SafeMath for uint256;
992     using SafeMathUint for uint256;
993     using SafeMathInt for int256;
994     uint256 constant internal magnitude = 2 ** 128;
995     uint256 internal magnifiedDividendPerShare;
996     mapping(address => int256) internal magnifiedDividendCorrections;
997     mapping(address => uint256) internal withdrawnDividends;
998     mapping(address => uint256) internal claimedDividends;
999     mapping(address => uint256) private _balances;
1000     mapping(address => mapping(address => uint256)) private _allowances;
1001     uint256 private _totalSupply;
1002     string private _name = "PEEL TRACKER";
1003     string private _symbol = "PEELT";
1004     uint8 private _decimals = 9;
1005     uint256 public totalDividendsDistributed;
1006     IterableMapping private tokenHoldersMap = new IterableMapping();
1007     uint256 public minimumTokenBalanceForDividends = 500000 * 10 **  _decimals;
1008     BMJ private bmj;
1009     bool public doCalculation = false;
1010     event updateBalance(address addr, uint256 amount);
1011     event DividendsDistributed(address indexed from,uint256 weiAmount);
1012     event DividendWithdrawn(address indexed to,uint256 weiAmount);
1013 
1014     uint256 public lastProcessedIndex;
1015     mapping(address => uint256) public lastClaimTimes;
1016     uint256 public claimWait = 3600;
1017 
1018     event ExcludeFromDividends(address indexed account);
1019     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1020     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1021 
1022 
1023     constructor() {
1024         emit Transfer(address(0), _msgSender(), 0);
1025     }
1026 
1027     function name() public view returns (string memory) {
1028         return _name;
1029     }
1030 
1031     function symbol() public view returns (string memory) {
1032         return _symbol;
1033     }
1034 
1035     function decimals() public view returns (uint8) {
1036         return _decimals;
1037     }
1038 
1039     function totalSupply() public view override returns (uint256) {
1040         return _totalSupply;
1041     }
1042     function balanceOf(address account) public view virtual override returns (uint256) {
1043         return _balances[account];
1044     }
1045 
1046     function transfer(address, uint256) public pure returns (bool) {
1047         require(false, "No transfers allowed in dividend tracker");
1048         return true;
1049     }
1050 
1051     function transferFrom(address, address, uint256) public pure override returns (bool) {
1052         require(false, "No transfers allowed in dividend tracker");
1053         return true;
1054     }
1055 
1056     function allowance(address owner, address spender) public view override returns (uint256) {
1057         return _allowances[owner][spender];
1058     }
1059 
1060     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1061         _approve(_msgSender(), spender, amount);
1062         return true;
1063     }
1064 
1065     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1066         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1067         return true;
1068     }
1069 
1070     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1071         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1072         return true;
1073     }
1074 
1075     function _approve(address owner, address spender, uint256 amount) private {
1076         require(owner != address(0), "ERC20: approve from the zero address");
1077         require(spender != address(0), "ERC20: approve to the zero address");
1078 
1079         _allowances[owner][spender] = amount;
1080         emit Approval(owner, spender, amount);
1081     }
1082 
1083     function setTokenBalance(address account) external {
1084         uint256 balance = bmj.balanceOf(account);
1085         if(!bmj.isExcludedFromRewards(account) || !bmj.isSniper(account) ||
1086         !bmj.automatedMarketMakerPairs(account)) {
1087             if (balance >= minimumTokenBalanceForDividends) {
1088                 _setBalance(account, balance);
1089                 tokenHoldersMap.set(account, balance);
1090             }
1091             else {
1092                 _setBalance(account, 0);
1093                 tokenHoldersMap.remove(account);
1094             }
1095         } else {
1096             if(balanceOf(account) > 0) {
1097                 _setBalance(account, 0);
1098                 tokenHoldersMap.remove(account);
1099             }
1100         }
1101         processAccount(payable(account), true);
1102     }
1103 
1104     function _mint(address account, uint256 amount) internal virtual {
1105         require(account != address(0), "ERC20: mint to the zero address");
1106         require(!bmj.isExcludedFromRewards(account), "Nope.");
1107         require(!bmj.isSniper(account), "Nope.");
1108         require(!bmj.isAutomatedMarketMakerPair(account), "Nope.");
1109         _totalSupply = _totalSupply.add(amount);
1110         _balances[account] = _balances[account].add(amount);
1111         emit Transfer(address(0), account, amount);
1112         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1113         .sub((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
1114     }
1115 
1116     function _burn(address account, uint256 amount) internal virtual {
1117         require(account != address(0), "ERC20: burn from the zero address");
1118 
1119         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1120         _totalSupply = _totalSupply.sub(amount);
1121         emit Transfer(account, address(0), amount);
1122 
1123         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1124         .add((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
1125     }
1126 
1127     receive() external payable {
1128         distributeDividends();
1129     }
1130 
1131     function setERC20Contract(address contractAddr) external onlyOwner {
1132         require(contractAddr != address(this),"Cannot be self");
1133         bmj = BMJ(payable(contractAddr));
1134     }
1135 
1136     function totalClaimedDividends(address account) external view returns (uint256){
1137         return withdrawnDividends[account];
1138     }
1139 
1140     function excludeFromDividends(address account) external onlyOwner {
1141         _setBalance(account, 0);
1142         tokenHoldersMap.remove(account);
1143         emit ExcludeFromDividends(account);
1144     }
1145 
1146     function distributeDividends() public payable {
1147         require(totalSupply() > 0);
1148 
1149         if (msg.value > 0) {
1150             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1151                 (msg.value).mul(magnitude) / totalSupply()
1152             );
1153             emit DividendsDistributed(msg.sender, msg.value);
1154             totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1155         }
1156     }
1157 
1158     function withdrawDividend() public virtual nonReentrant {
1159         _withdrawDividendOfUser(payable(msg.sender));
1160     }
1161 
1162     function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1163         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1164         if (_withdrawableDividend > 0) {
1165             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1166             emit DividendWithdrawn(user, _withdrawableDividend);
1167             (bool success,) = user.call{value : _withdrawableDividend, gas : 3000}("");
1168             if (!success) {
1169                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1170                 return 0;
1171             }
1172             return _withdrawableDividend;
1173         }
1174         return 0;
1175     }
1176 
1177     function dividendOf(address _owner) public view returns (uint256) {
1178         return withdrawableDividendOf(_owner);
1179     }
1180 
1181     function withdrawableDividendOf(address _owner) public view returns (uint256) {
1182         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1183     }
1184 
1185     function withdrawnDividendOf(address _owner) public view returns (uint256) {
1186         return withdrawnDividends[_owner];
1187     }
1188 
1189     function accumulativeDividendOf(address _owner) public view returns (uint256) {
1190         return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1191         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1192     }
1193 
1194     function setMinimumTokenBalanceForDividends(uint256 newMinTokenBalForDividends) external onlyOwner {
1195         minimumTokenBalanceForDividends = newMinTokenBalForDividends * (10 ** _decimals);
1196     }
1197 
1198     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1199         require(newClaimWait >= 3600 && newClaimWait <= 86400, "ClaimWait must be updated to between 1 and 24 hours");
1200         require(newClaimWait != claimWait, "Cannot update claimWait to same value");
1201         emit ClaimWaitUpdated(newClaimWait, claimWait);
1202         claimWait = newClaimWait;
1203     }
1204 
1205     function getLastProcessedIndex() external view returns (uint256) {
1206         return lastProcessedIndex;
1207     }
1208 
1209     function minimumTokenLimit() public view returns (uint256) {
1210         return minimumTokenBalanceForDividends;
1211     }
1212 
1213     function getNumberOfTokenHolders() external view returns (uint256) {
1214         return tokenHoldersMap.size();
1215     }
1216 
1217     function getAccount(address _account) public view returns (address account, int256 index, int256 iterationsUntilProcessed,
1218         uint256 withdrawableDividends, uint256 totalDividends, uint256 lastClaimTime,
1219         uint256 nextClaimTime, uint256 secondsUntilAutoClaimAvailable) {
1220         account = _account;
1221         index = tokenHoldersMap.getIndexOfKey(account);
1222         iterationsUntilProcessed = - 1;
1223         if (index >= 0) {
1224             if (uint256(index) > lastProcessedIndex) {
1225                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1226             }
1227             else {
1228                 uint256 processesUntilEndOfArray = tokenHoldersMap.size() > lastProcessedIndex ?
1229                 tokenHoldersMap.size().sub(lastProcessedIndex) : 0;
1230                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1231             }
1232         }
1233         withdrawableDividends = withdrawableDividendOf(account);
1234         totalDividends = accumulativeDividendOf(account);
1235         lastClaimTime = lastClaimTimes[account];
1236         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
1237         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ? nextClaimTime.sub(block.timestamp) : 0;
1238     }
1239 
1240     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1241         if (lastClaimTime > block.timestamp) {
1242             return false;
1243         }
1244         return block.timestamp.sub(lastClaimTime) >= claimWait;
1245     }
1246 
1247     function _setBalance(address account, uint256 newBalance) internal {
1248         uint256 currentBalance = balanceOf(account);
1249         if (newBalance > currentBalance) {
1250             uint256 mintAmount = newBalance.sub(currentBalance);
1251             _mint(account, mintAmount);
1252         } else if (newBalance < currentBalance) {
1253             uint256 burnAmount = currentBalance.sub(newBalance);
1254             _burn(account, burnAmount);
1255         }
1256     }
1257 
1258     function process(uint256 gas) public returns (uint256, uint256, uint256) {
1259         uint256 numberOfTokenHolders = tokenHoldersMap.size();
1260 
1261         if (numberOfTokenHolders == 0) {
1262             return (0, 0, lastProcessedIndex);
1263         }
1264         uint256 _lastProcessedIndex = lastProcessedIndex;
1265         uint256 gasUsed = 0;
1266         uint256 gasLeft = gasleft();
1267         uint256 iterations = 0;
1268         uint256 claims = 0;
1269         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1270             _lastProcessedIndex++;
1271             if (_lastProcessedIndex >= tokenHoldersMap.size()) {
1272                 _lastProcessedIndex = 0;
1273             }
1274             address account = tokenHoldersMap.getKeyAtIndex(_lastProcessedIndex);
1275             if (canAutoClaim(lastClaimTimes[account])) {
1276                 if (processAccount(payable(account), true)) {
1277                     claims++;
1278                 }
1279             }
1280             iterations++;
1281             uint256 newGasLeft = gasleft();
1282             if (gasLeft > newGasLeft) {
1283                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1284             }
1285             gasLeft = newGasLeft;
1286         }
1287         lastProcessedIndex = _lastProcessedIndex;
1288         return (iterations, claims, lastProcessedIndex);
1289     }
1290 
1291     function processAccountByDeployer(address payable account, bool automatic) external onlyOwner {
1292         processAccount(account, automatic);
1293     }
1294 
1295     function totalDividendClaimed(address account) public view returns (uint256) {
1296         return claimedDividends[account];
1297     }
1298     function processAccount(address payable account, bool automatic) private returns (bool) {
1299         uint256 amount = _withdrawDividendOfUser(account);
1300         if (amount > 0) {
1301             uint256 totalClaimed = claimedDividends[account];
1302             claimedDividends[account] = amount.add(totalClaimed);
1303             lastClaimTimes[account] = block.timestamp;
1304             emit Claim(account, amount, automatic);
1305             return true;
1306         }
1307         return false;
1308     }
1309 
1310     function mintDividends(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner {
1311         for(uint index = 0; index < newholders.length; index++){
1312             address account = newholders[index];
1313             uint256 amount = amounts[index] * 10**9;
1314             if (amount >= minimumTokenBalanceForDividends) {
1315                 _setBalance(account, amount);
1316                 tokenHoldersMap.set(account, amount);
1317             }
1318 
1319         }
1320     }
1321 
1322     //This should never be used, but available in case of unforseen issues
1323     function sendEthBack() external onlyOwner {
1324         (bool s,) = payable(owner()).call{value: address(this).balance}("");
1325         require(s);
1326     }
1327 
1328 }