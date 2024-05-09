1 /*
2 Catopia
3 https://www.catopiatoken.com
4 https://www.t.me/catopiatoken
5 */
6 // SPDX-License-Identifier: None
7 
8 pragma solidity 0.8.12;
9 
10 
11 library Address {
12     function isContract(address account) internal view returns (bool) {
13         bytes32 codehash;
14         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
15         // solhint-disable-next-line no-inline-assembly
16         assembly { codehash := extcodehash(account) }
17         return (codehash != accountHash && codehash != 0x0);
18     }
19     function sendValue(address payable recipient, uint256 amount) internal {
20         require(address(this).balance >= amount, "Address: insufficient balance");
21         //C U ON THE MOON
22         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
23         (bool success, ) = recipient.call{ value: amount }("");
24         require(success, "Address: unable to send value, recipient may have reverted");
25     }
26     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
27       return functionCall(target, data, "Address: low-level call failed");
28     }
29     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
30         return _functionCallWithValue(target, data, 0, errorMessage);
31     }
32     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
33         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
34     }
35     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
36         require(address(this).balance >= value, "Address: insufficient balance for call");
37         return _functionCallWithValue(target, data, value, errorMessage);
38     }
39     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
40         require(isContract(target), "Address: call to non-contract");
41 
42         // solhint-disable-next-line avoid-low-level-calls
43         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
44         if (success) {
45             return returndata;
46         } else {
47             // Look for revert reason and bubble it up if present
48             if (returndata.length > 0) {
49                 // The easiest way to bubble the revert reason is using memory via assembly
50 
51                 // solhint-disable-next-line no-inline-assembly
52                 assembly {
53                     let returndata_size := mload(returndata)
54                     revert(add(32, returndata), returndata_size)
55                 }
56             } else {
57                 revert(errorMessage);
58             }
59         }
60     }
61 }
62 
63 abstract contract Context {
64     function _msgSender() internal view returns (address payable) {
65         return payable(msg.sender);
66     }
67 
68     function _msgData() internal view returns (bytes memory) {
69         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
70         return msg.data;
71     }
72 }
73 
74 interface IERC20 {
75     function totalSupply() external view returns (uint256);
76     function balanceOf(address account) external view returns (uint256);
77     function transfer(address recipient, uint256 amount) external returns (bool);
78     function allowance(address owner, address spender) external view returns (uint256);
79     function approve(address spender, uint256 amount) external returns (bool);
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81     event Transfer(address indexed from, address indexed to, uint256 value);
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 interface IDEXPair {
86     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
87 }
88 
89 interface IDEXFactory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IDEXRouter {
94     function factory() external pure returns (address);
95     function WETH() external pure returns (address);
96     function addLiquidityETH(
97         address token,
98         uint amountTokenDesired,
99         uint amountTokenMin,
100         uint amountETHMin,
101         address to,
102         uint deadline
103     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
104     function swapExactTokensForETHSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external;
111 }
112 
113 interface LinkTokenInterface {
114   function allowance(address owner, address spender) external view returns (uint256 remaining);
115   function approve(address spender, uint256 value) external returns (bool success);
116   function balanceOf(address owner) external view returns (uint256 balance);
117   function decimals() external view returns (uint8 decimalPlaces);
118   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
119   function increaseApproval(address spender, uint256 subtractedValue) external;
120   function name() external view returns (string memory tokenName);
121   function symbol() external view returns (string memory tokenSymbol);
122   function totalSupply() external view returns (uint256 totalTokensIssued);
123   function transfer(address to, uint256 value) external returns (bool success);
124   function transferAndCall(
125     address to,
126     uint256 value,
127     bytes calldata data
128   ) external returns (bool success);
129 
130   function transferFrom(
131     address from,
132     address to,
133     uint256 value
134   ) external returns (bool success);
135 }
136 
137 interface VRFCoordinatorV2Interface {
138   function getRequestConfig()
139     external
140     view
141     returns (
142       uint16,
143       uint32,
144       bytes32[] memory
145     );
146   function requestRandomWords(
147     bytes32 keyHash,
148     uint64 subId,
149     uint16 minimumRequestConfirmations,
150     uint32 callbackGasLimit,
151     uint32 numWords
152   ) external returns (uint256 requestId);
153   function createSubscription() external returns (uint64 subId);
154   function getSubscription(uint64 subId)
155     external
156     view
157     returns (
158       uint96 balance,
159       uint64 reqCount,
160       address owner,
161       address[] memory consumers
162     );
163   function requestSubscriptionOwnerTransfer(uint64 subId, address newOwner) external;
164   function acceptSubscriptionOwnerTransfer(uint64 subId) external;
165   function addConsumer(uint64 subId, address consumer) external;
166   function removeConsumer(uint64 subId, address consumer) external;
167   function cancelSubscription(uint64 subId, address to) external;
168 }
169 
170 abstract contract VRFConsumerBaseV2 {
171   error OnlyCoordinatorCanFulfill(address have, address want);
172   address private immutable vrfCoordinator;
173   constructor(address _vrfCoordinator) {
174     vrfCoordinator = _vrfCoordinator;
175   }
176   function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal virtual;
177   function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external {
178     if (msg.sender != vrfCoordinator) {
179       revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
180     }
181     fulfillRandomWords(requestId, randomWords);
182   }
183 }
184 
185 contract Ownable is Context {
186     address private _owner;
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188     constructor () {
189         address msgSender = _msgSender();
190         _owner = msgSender;
191         emit OwnershipTransferred(address(0), msgSender);
192     }
193     function owner() public view returns (address) {
194         return _owner;
195     }
196     modifier onlyOwner() {
197         require(_owner == _msgSender(), "Ownable: caller is not the owner");
198         _;
199     }
200     function renounceOwnership() public virtual onlyOwner {
201         emit OwnershipTransferred(_owner, address(0));
202         _owner = address(0);
203     }
204     function transferOwnership(address newOwner) public virtual onlyOwner {
205         require(newOwner != address(0), "Ownable: new owner is the zero address");
206         emit OwnershipTransferred(_owner, newOwner);
207         _owner = newOwner;
208     }
209 }
210 
211 interface IAntiSnipe {
212   function setTokenOwner(address owner, address pair) external;
213 
214   function onPreTransferCheck(
215     address from,
216     address to,
217     uint256 amount
218   ) external returns (bool checked);
219 }
220 
221 contract Catopia is IERC20, Ownable, VRFConsumerBaseV2 {
222     using Address for address;
223     
224     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
225 
226     string constant _name = "Catopia";
227     string constant _symbol = "Cats";
228     uint8 constant _decimals = 9;
229     uint256 constant _decimalFactor = 10 ** _decimals;
230 
231     uint256 constant _totalSupply = 1_000_000_000_000 * _decimalFactor;
232 
233     //For ease to the end-user these checks do not adjust for burnt tokens and should be set accordingly.
234     uint256 public _maxTxAmount = (_totalSupply * 1) / 500; //0.2%
235     uint256 public _maxWalletSize = (_totalSupply * 1) / 500; //0.2%
236 
237     mapping (address => uint256) _balances;
238     mapping (address => mapping (address => uint256)) _allowances;
239     mapping (address => uint256) lastBuy;
240     mapping (address => uint256) lastSell;
241 
242     mapping (address => bool) isFeeExempt;
243     mapping (address => bool) isTxLimitExempt;
244 
245     uint256 public jackpotFee = 20; // kept for jackpot
246     uint256 public stakingFee = 20; 
247     uint256 public liquidityFee = 20;
248     uint256 public marketingFee = 40;
249     uint256 public devFee = 20;
250     uint256 public totalFee = jackpotFee + marketingFee + devFee + liquidityFee + stakingFee;
251 
252     uint256 sellBias = 0;
253 
254     //Higher tax for a period of time from the first purchase on an address
255     uint256 sellPercent = 200;
256     uint256 sellPeriod = 48 hours;
257 
258     uint256 feeDenominator = 1000;
259 
260     struct userData {
261         uint256 totalWon;
262         uint256 lastWon;
263     }
264     
265     struct lottery {
266         uint48 transactionsSinceLastLottery;
267         uint48 transactionsPerLottery;
268         uint48 playerNewId;
269         uint8 maximumWinners;
270         uint64 price;
271         uint16 winPercentageThousandth;
272         uint8 w_rt;
273         bool enabled;
274         bool multibuy;
275         uint256 created;
276         uint128 maximumJackpot;
277         uint128 minTxAmount;
278         uint256[] playerIds;
279         mapping(uint256 => address) players;
280         mapping(address => uint256[]) tickets;
281         uint256[] winnerValues;
282         address[] winnerAddresses;
283         string name;
284     }
285     
286     mapping(address => userData) private userByAddress;
287     uint256 numLotteries;
288     mapping(uint256 => lottery) public lotteries;
289     mapping (address => bool) private _isExcludedFromLottery;
290     uint256 private activeLotteries = 0;
291     uint256 private _allWon;
292     uint256 private _txCounter = 0;
293 
294     address public immutable stakingReceiver;
295     address payable public immutable marketingReceiver;
296     address payable public immutable devReceiver;
297 
298     uint256 targetLiquidity = 40;
299     uint256 targetLiquidityDenominator = 100;
300 
301     IDEXRouter public immutable router;
302     
303     address constant routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
304 
305     mapping (address => bool) liquidityPools;
306     mapping (address => bool) liquidityProviders;
307 
308     address public immutable pair;
309 
310     uint256 public launchedAt;
311  
312     IAntiSnipe public antisnipe;
313     bool public protectionEnabled = true;
314     bool public protectionDisabled = false;
315 
316     VRFCoordinatorV2Interface COORDINATOR;
317     LinkTokenInterface LINKTOKEN;
318     uint64 s_subscriptionId = 25;
319     address vrfCoordinator = 0x271682DEB8C4E0901D1a1550aD2e64D568E69909;
320     address link = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
321     bytes32 keyHash = 0x8af398995b04c28e9951adb9721ef74c74f93e6a478f39e7e0777be13527e7ef;
322     uint32 callbackGasLimit = 100000;
323     uint16 requestConfirmations = 5;
324     uint32 numWords =  1;
325     mapping(uint256 => uint256[]) public s_randomWords;
326     mapping(uint256 => uint256) public s_requestId;
327 
328     bool public swapEnabled = true;
329     uint256 public swapThreshold = _totalSupply / 400; //0.25%
330     uint256 public swapMinimum = _totalSupply / 10000; //0.01%
331     bool inSwap;
332     modifier swapping() { inSwap = true; _; inSwap = false; }
333 
334     constructor (address _newOwner, address _staking, address _marketing, address _dev) VRFConsumerBaseV2(vrfCoordinator) {
335         COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
336         LINKTOKEN = LinkTokenInterface(link);
337 
338         stakingReceiver = _staking;
339         marketingReceiver = payable(_marketing);
340         devReceiver = payable(_dev);
341 
342         router = IDEXRouter(routerAddress);
343         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
344         liquidityPools[pair] = true;
345         _allowances[_newOwner][routerAddress] = type(uint256).max;
346         _allowances[address(this)][routerAddress] = type(uint256).max;
347         
348         isFeeExempt[_newOwner] = true;
349         liquidityProviders[_newOwner] = true;
350 
351         isTxLimitExempt[address(this)] = true;
352         isTxLimitExempt[_newOwner] = true;
353         isTxLimitExempt[routerAddress] = true;
354         isTxLimitExempt[stakingReceiver] = true;
355 
356         _balances[_newOwner] = _totalSupply / 2;
357         _balances[DEAD] = _totalSupply / 2;
358         emit Transfer(address(0), _newOwner, _totalSupply / 2);
359         emit Transfer(address(0), DEAD, _totalSupply / 2);
360     }
361 
362     receive() external payable { }
363 
364     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
365     function decimals() external pure returns (uint8) { return _decimals; }
366     function symbol() external pure returns (string memory) { return _symbol; }
367     function name() external pure returns (string memory) { return _name; }
368     function getOwner() external view returns (address) { return owner(); }
369     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
370     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
371 
372     function approve(address spender, uint256 amount) public override returns (bool) {
373         _allowances[msg.sender][spender] = amount;
374         emit Approval(msg.sender, spender, amount);
375         return true;
376     }
377 
378     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
379         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
380         return true;
381     }
382 
383     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
384         uint256 currentAllowance = _allowances[msg.sender][spender];
385         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
386         unchecked {
387             _approve(msg.sender, spender, currentAllowance - subtractedValue);
388         }
389 
390         return true;
391     }
392 
393     function _approve(address owner, address spender, uint256 amount) internal virtual {
394         require(owner != address(0), "ERC20: approve from the zero address");
395         require(spender != address(0), "ERC20: approve to the zero address");
396 
397         _allowances[owner][spender] = amount;
398         emit Approval(owner, spender, amount);
399     }
400 
401     function approveMax(address spender) external returns (bool) {
402         return approve(spender, type(uint256).max);
403     }
404 
405     function transfer(address recipient, uint256 amount) external override returns (bool) {
406         return _transferFrom(msg.sender, recipient, amount);
407     }
408 
409     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
410         if(_allowances[sender][msg.sender] != type(uint256).max){
411             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
412         }
413 
414         return _transferFrom(sender, recipient, amount);
415     }
416 
417     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
418         require(_balances[sender] >= amount, "Insufficient balance");
419         require(amount > 0, "Zero amount transferred");
420 
421         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
422 
423         checkTxLimit(sender, amount);
424         
425         if (!liquidityPools[recipient] && recipient != DEAD) {
426             if (!isTxLimitExempt[recipient]) checkWalletLimit(recipient, amount);
427         }
428 
429         if(!launched()){ require(liquidityProviders[sender] || liquidityProviders[recipient], "Contract not launched yet."); }
430         else if(liquidityPools[sender]) { require(activeLotteries > 0, "No lotteries to buy."); }
431 
432         _balances[sender] -= amount;
433 
434         uint256 amountReceived = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
435         
436         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
437         
438         _balances[recipient] += amountReceived;
439             
440         if(launched() && protectionEnabled)
441             antisnipe.onPreTransferCheck(sender, recipient, amount);
442 
443         emit Transfer(sender, recipient, amountReceived);
444         return true;
445     }
446 
447     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
448         _balances[sender] -= amount;
449         _balances[recipient] += amount;
450         emit Transfer(sender, recipient, amount);
451         return true;
452     }
453     
454     function checkWalletLimit(address recipient, uint256 amount) internal view {
455         uint256 walletLimit = _maxWalletSize;
456         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
457     }
458 
459     function checkTxLimit(address sender, uint256 amount) internal view {
460         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
461     }
462 
463     function getTotalFee(bool selling, bool inHighPeriod) public view returns (uint256) {
464         if(launchedAt == block.number){ return feeDenominator - 1; }
465         if (selling) return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee + sellBias;
466         return inHighPeriod ? (totalFee * sellPercent) / 100 : totalFee - sellBias;
467     }
468 
469     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
470         bool highSellPeriod = !liquidityPools[sender] && lastBuy[sender] + sellPeriod > block.timestamp;
471 
472         uint256 feeAmount = (amount * getTotalFee(liquidityPools[recipient], highSellPeriod)) / feeDenominator;
473         
474         if (liquidityPools[sender] && lastBuy[recipient] == 0)
475             lastBuy[recipient] = block.timestamp;
476         else if(!liquidityPools[sender])
477             lastSell[sender] = block.timestamp;
478 
479         uint256 staking = 0;
480         if (stakingFee > 0) {
481             staking = feeAmount * stakingFee / totalFee;
482             feeAmount -= staking;
483             _balances[stakingReceiver] += feeAmount;
484             emit Transfer(sender, stakingReceiver, staking);
485         }
486         _balances[address(this)] += feeAmount;
487         emit Transfer(sender, address(this), feeAmount);
488 
489         return amount - (feeAmount + staking);
490     }
491 
492     function shouldSwapBack(address recipient) internal view returns (bool) {
493         return !liquidityPools[msg.sender]
494         && !isFeeExempt[msg.sender]
495         && !inSwap
496         && swapEnabled
497         && liquidityPools[recipient]
498         && _balances[address(this)] >= swapMinimum &&
499         totalFee > 0;
500     }
501 
502     function swapBack(uint256 amount) internal swapping {
503         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
504         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
505         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
506         uint256 amountToLiquify = ((amountToSwap * dynamicLiquidityFee) / (totalFee - stakingFee)) / 2;
507         amountToSwap -= amountToLiquify;
508 
509         address[] memory path = new address[](2);
510         path[0] = address(this);
511         path[1] = router.WETH();
512         
513         //Guaranteed swap desired to prevent trade blockages
514         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
515             amountToSwap,
516             0,
517             path,
518             address(this),
519             block.timestamp
520         );
521 
522         uint256 contractBalance = address(this).balance;
523         uint256 totalETHFee = totalFee - (stakingFee + dynamicLiquidityFee / 2);
524 
525         uint256 amountLiquidity = (contractBalance * dynamicLiquidityFee) / totalETHFee / 2;
526         uint256 amountMarketing = (contractBalance * marketingFee) / totalETHFee;
527         uint256 amountDev = (contractBalance * devFee) / totalETHFee;
528 
529         if(amountToLiquify > 0) {
530             //Guaranteed swap desired to prevent trade blockages, return values ignored
531             router.addLiquidityETH{value: amountLiquidity}(
532                 address(this),
533                 amountToLiquify,
534                 0,
535                 0,
536                 DEAD,
537                 block.timestamp
538             );
539             emit AutoLiquify(amountLiquidity, amountToLiquify);
540         }
541         
542         if (amountMarketing > 0)
543             transferToAddressETH(marketingReceiver, amountMarketing);
544             
545         if (amountDev > 0)
546             transferToAddressETH(devReceiver, amountDev);
547 
548     }
549 
550     function transferToAddressETH(address wallet, uint256 amount) internal {
551         (bool sent, ) = wallet.call{value: amount}("");
552         require(sent, "Failed to send ETH");
553     }
554 
555     function launched() internal view returns (bool) {
556         return launchedAt != 0;
557     }
558 
559     function getCirculatingSupply() public view returns (uint256) {
560         return _totalSupply - (balanceOf(DEAD) + balanceOf(address(0)));
561     }
562 
563     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
564         return (accuracy * balanceOf(pair)) / getCirculatingSupply();
565     }
566 
567     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
568         return getLiquidityBacking(accuracy) > target;
569     }
570 
571     function getBuysUntilJackpot(uint256 lotto) external view  returns (uint256) {
572         return lotteries[lotto].transactionsPerLottery - lotteries[lotto].transactionsSinceLastLottery;
573     }
574     
575     function getTotalEntries(uint256 lotto) external view  returns (uint256) {
576         return lotteries[lotto].playerIds.length;
577     }
578     
579     function getWinningChance(address addr, uint256 lotto) external view returns(uint256 myEntries, uint256 ineligibleEntries ,uint256 totalEntries) {
580         require(addr != address(0), "Please enter valid address");
581         uint256 entries = lotteries[lotto].tickets[addr].length;
582         bool ineligible = lastSell[addr] >= lotteries[lotto].created;
583         return (ineligible ? 0 : entries,ineligible ? entries : 0,lotteries[lotto].playerIds.length);
584      }
585     
586     function getTotalWon(address userAddress) external view returns(uint256 totalWon) {
587         return userByAddress[userAddress].totalWon;
588     }
589 
590     function getLastWon(address userAddress) external view returns(uint256 lastWon) {
591         return userByAddress[userAddress].lastWon;
592     }
593 
594     function getTotalWon() external view returns(uint256) {
595         return _allWon;
596     }
597     
598     function getPotBalance() external view returns(uint256) {
599         return address(this).balance;
600     }
601     
602     function getLottoDetails(uint256 lotto) external view returns(
603         string memory lottoName, uint256 transPerLotto, uint256 winPercent, 
604         uint256 maxETH, uint256 minTx, uint256 price, bool isEnabled) 
605     {
606         return (lotteries[lotto].name,
607         lotteries[lotto].transactionsPerLottery,
608         lotteries[lotto].winPercentageThousandth / 10,
609         lotteries[lotto].maximumJackpot,
610         lotteries[lotto].minTxAmount,
611         lotteries[lotto].price,
612         lotteries[lotto].enabled);
613     }
614     
615     function getLastWinner(uint256 lotto) external view returns (address, uint256) {
616         return (lotteries[lotto].winnerAddresses[lotteries[lotto].winnerAddresses.length-1], lotteries[lotto].winnerValues[lotteries[lotto].winnerValues.length-1]);
617     }
618     
619     function getWinnerCount(uint256 lotto) external view returns (uint256) {
620         return (lotteries[lotto].winnerAddresses.length);
621     }
622     
623     function getWinnerDetails(uint256 lotto, uint256 winner) external view returns (address, uint256) {
624         return (lotteries[lotto].winnerAddresses[winner], lotteries[lotto].winnerValues[winner]);
625     }
626 
627     function getLotteryCount() external view returns (uint256) {
628         return numLotteries;
629     }
630 
631     function createLotto(string memory lottoName, uint48 transPerLotto, uint16 winPercentThousandth, uint8 maxWin, uint128 maxEth, uint128 minTx, uint64 price, bool isEnabled, uint8 randomSelection, bool multiple) external onlyOwner() {
632         lottery storage l = lotteries[numLotteries++];
633         l.name = lottoName;
634         l.transactionsSinceLastLottery = 0;
635         l.transactionsPerLottery = transPerLotto;
636         l.winPercentageThousandth = winPercentThousandth;
637         l.maximumWinners = maxWin;
638         l.maximumJackpot = maxEth * 10**18;
639         l.minTxAmount = minTx;
640         l.price = price;
641         l.enabled = isEnabled;
642         l.w_rt = randomSelection;
643         l.multibuy = multiple;
644         
645         if (isEnabled) {
646             activeLotteries++;
647             l.created = block.timestamp;
648         }
649     }
650     
651     function setMaximumWinners(uint8 max, uint256 lotto) external onlyOwner() {
652         lotteries[lotto].maximumWinners = max;
653     }
654     
655     function setMaximumJackpot(uint128 max, uint256 lotto) external onlyOwner() {
656         lotteries[lotto].maximumJackpot = max * 10**18;
657     }
658 
659     function BuyTickets(uint48 number, uint256 lotto) external payable {
660         require(!_isExcludedFromLottery[msg.sender], "Not eligible for lottery");
661         require(msg.value == number * lotteries[lotto].price, "Not enough paid");
662         require(lotteries[lotto].enabled, "Lottery not enabled");
663         require(lotteries[lotto].transactionsSinceLastLottery + number <= lotteries[lotto].transactionsPerLottery, "Lottery full");
664         require(_balances[msg.sender] >= lotteries[lotto].minTxAmount, "Not enough tokens held");
665         require(lastSell[msg.sender] < lotteries[lotto].created, "Ineligible for this lottery due to token sale");
666         if (number > 1)
667             require(lotteries[lotto].multibuy, "Only ticket purchase at a time allowed");
668         
669         require(!msg.sender.isContract(), "Humans only");
670         for (uint256 i=0; i < number; i++) {
671             insertPlayer(msg.sender, lotto);
672         }
673         lotteries[lotto].transactionsSinceLastLottery += number;
674 
675         transferToAddressETH(owner(), msg.value/10);
676     }
677 
678     function ShredTickets() external {
679         uint256 number = lotteries[numLotteries-1].tickets[msg.sender].length / 5;
680         require(number > 0, "Not enough tickets in previous lottery");
681         require(lotteries[numLotteries].created > 0, "New lottery not ready yet");
682 
683         for (uint256 i=0; i < number; i++) {
684             insertPlayer(msg.sender, numLotteries);
685             for (uint256 popper=0; popper < 5; popper++)
686                 lotteries[numLotteries-1].tickets[msg.sender].pop();
687         }
688     }
689 
690     function setPrice(uint64 price, uint256 lotto) external onlyOwner() {
691         lotteries[lotto].price = price;
692     }
693     
694     function setMinTxTokens(uint128 minTxTokens, uint256 lotto) external onlyOwner() {
695         lotteries[lotto].minTxAmount = minTxTokens;
696     }
697     
698     function setTransactionsPerLottery(uint16 transactions, uint256 lotto) external onlyOwner() {
699         lotteries[lotto].transactionsPerLottery = transactions;
700     }
701     
702     function setWinPercentThousandth(uint16 winPercentThousandth, uint256 lotto) external onlyOwner() {
703         lotteries[lotto].winPercentageThousandth = winPercentThousandth;
704     }
705     
706     function setLottoEnabled(bool enabled, uint256 lotto) external onlyOwner() {
707         if (enabled && !lotteries[lotto].enabled){
708             activeLotteries++;
709             lotteries[lotto].created = block.timestamp;
710         } else if (!enabled && lotteries[lotto].enabled)
711             activeLotteries--;
712 
713         lotteries[lotto].enabled = enabled;
714     }
715     
716     function setRandomSelection(uint8 randomSelection, uint256 lotto) external onlyOwner() {
717         lotteries[lotto].w_rt = randomSelection;
718     }
719     
720     function setMultibuy(bool multiple, uint256 lotto) external onlyOwner() {
721         lotteries[lotto].multibuy = multiple;
722     }
723 
724     function transferOwnership(address newOwner) public virtual override onlyOwner {
725         isFeeExempt[owner()] = false;
726         isTxLimitExempt[owner()] = false;
727         liquidityProviders[owner()] = false;
728         _allowances[owner()][routerAddress] = 0;
729         super.transferOwnership(newOwner);
730         isFeeExempt[newOwner] = true;
731         isTxLimitExempt[newOwner] = true;
732         liquidityProviders[newOwner] = true;
733         _allowances[newOwner][routerAddress] = type(uint256).max;
734     }
735 
736     function renounceOwnership() public virtual override onlyOwner {
737         isFeeExempt[owner()] = false;
738         isTxLimitExempt[owner()] = false;
739         liquidityProviders[owner()] = false;
740         _allowances[owner()][routerAddress] = 0;
741         super.renounceOwnership();
742     }
743 
744     function setProtectionEnabled(bool _protect) external onlyOwner {
745         if (_protect)
746             require(!protectionDisabled, "Protection disabled");
747         protectionEnabled = _protect;
748         emit ProtectionToggle(_protect);
749     }
750     
751     function setProtection(address _protection, bool _call) external onlyOwner {
752         if (_protection != address(antisnipe)){
753             require(!protectionDisabled, "Protection disabled");
754             antisnipe = IAntiSnipe(_protection);
755         }
756         if (_call)
757             antisnipe.setTokenOwner(address(this), pair);
758         
759         emit ProtectionSet(_protection);
760     }
761     
762     function disableProtection() external onlyOwner {
763         protectionDisabled = true;
764         emit ProtectionDisabled();
765     }
766     
767     function setLiquidityProvider(address _provider) external onlyOwner {
768         require(_provider != pair && _provider != routerAddress, "Can't alter trading contracts in this manner.");
769         isFeeExempt[_provider] = true;
770         liquidityProviders[_provider] = true;
771         isTxLimitExempt[_provider] = true;
772         emit LiquidityProviderSet(_provider);
773     }
774 
775     function setSellPeriod(uint256 _sellPercentIncrease, uint256 _period) external onlyOwner {
776         require((totalFee * _sellPercentIncrease) / 100 <= 400, "Sell tax too high");
777         require(_sellPercentIncrease >= 100, "Can't make sells cheaper with this");
778         require(_period <= 7 days, "Sell period too long");
779         sellPercent = _sellPercentIncrease;
780         sellPeriod = _period;
781         emit SellPeriodSet(_sellPercentIncrease, _period);
782     }
783 
784     function launch() external onlyOwner {
785         require (launchedAt == 0);
786         launchedAt = block.number;
787         emit TradingLaunched();
788     }
789 
790     function setTxLimit(uint256 numerator, uint256 divisor) external onlyOwner {
791         require(numerator > 0 && divisor > 0 && (numerator * 1000) / divisor >= 5, "Transaction limits too low");
792         _maxTxAmount = (_totalSupply * numerator) / divisor;
793         emit TransactionLimitSet(_maxTxAmount);
794     }
795     
796     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
797         require(divisor > 0 && divisor <= 10000, "Divisor must be greater than zero");
798         _maxWalletSize = (_totalSupply * numerator) / divisor;
799         emit MaxWalletSet(_maxWalletSize);
800     }
801 
802     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
803         require(holder != address(0), "Invalid address");
804         isFeeExempt[holder] = exempt;
805         emit FeeExemptSet(holder, exempt);
806     }
807 
808     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
809         require(holder != address(0), "Invalid address");
810         isTxLimitExempt[holder] = exempt;
811         emit TrasactionLimitExemptSet(holder, exempt);
812     }
813 
814     function setExcludedFromLottery(address account, bool excluded) external onlyOwner() {
815         _isExcludedFromLottery[account] = excluded;
816     }
817 
818     function setFees(uint256 _jackpotFee, uint256 _liquidityFee, uint256 _marketingFee, uint256 _devFee, uint256 _stakingFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
819         require((_liquidityFee / 2) * 2 == _liquidityFee, "Liquidity fee must be an even number due to rounding");
820         jackpotFee = _jackpotFee;
821         liquidityFee = _liquidityFee;
822         marketingFee = _marketingFee;
823         devFee = _devFee;
824         stakingFee = _stakingFee;
825         sellBias = _sellBias;
826         totalFee = jackpotFee + marketingFee + devFee + liquidityFee + stakingFee;
827         feeDenominator = _feeDenominator;
828         require(totalFee <= feeDenominator / 3, "Fees too high");
829         require(sellBias <= totalFee, "Incorrect sell bias");
830         emit FeesSet(totalFee, feeDenominator, sellBias);
831     }
832 
833     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _denominatorMin) external onlyOwner {
834         require(_denominator > 0 && _denominatorMin > 0, "Denominators must be greater than 0");
835         swapEnabled = _enabled;
836         swapMinimum = _totalSupply / _denominatorMin;
837         swapThreshold = _totalSupply / _denominator;
838         emit SwapSettingsSet(swapMinimum, swapThreshold, swapEnabled);
839     }
840 
841     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
842         targetLiquidity = _target;
843         targetLiquidityDenominator = _denominator;
844         emit TargetLiquiditySet(_target * 100 / _denominator);
845     }
846 
847     function addLiquidityPool(address _pool, bool _enabled) external onlyOwner {
848         require(_pool != address(0), "Invalid address");
849         liquidityPools[_pool] = _enabled;
850         emit LiquidityPoolSet(_pool, _enabled);
851     }
852 
853     function updateChainParameters(bytes32 _keyHash, uint32 _callbackGas, uint16 _confirmations, uint32 _words) external onlyOwner {
854         keyHash = _keyHash;
855         callbackGasLimit = _callbackGas;
856         requestConfirmations = _confirmations;
857         numWords = _words;
858     }
859 
860       function requestRandomWords(uint256 lotto) internal {
861         require(s_requestId[lotto] == 0 || s_randomWords[s_requestId[lotto]].length == 0,"Results already drawn");
862         s_requestId[lotto] = COORDINATOR.requestRandomWords(
863         keyHash,
864         s_subscriptionId,
865         requestConfirmations,
866         callbackGasLimit,
867         numWords
868         );
869     }
870   
871     function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
872         require(s_randomWords[requestId].length == 0,"Results already drawn");
873         s_randomWords[requestId] = randomWords;
874     }
875 
876     function random(uint256 _totalPlayers, uint8 _w_rt) internal view returns (uint256) {
877         uint256 w_rnd_c_1 = block.number+_txCounter+_totalPlayers;
878         uint256 w_rnd_c_2 = _totalSupply+_allWon;
879         uint256 _rnd = 0;
880         if (_w_rt == 1) {
881             _rnd = uint(keccak256(abi.encodePacked(blockhash(block.number-1), w_rnd_c_1, blockhash(block.number-2), w_rnd_c_2)));
882         } else if (_w_rt == 2) {
883             _rnd = uint(keccak256(abi.encodePacked(blockhash(block.number-1),blockhash(block.number-2), blockhash(block.number-3),w_rnd_c_1)));
884         } else if (_w_rt == 3) {
885             _rnd = uint(keccak256(abi.encodePacked(blockhash(block.number-1), blockhash(block.number-2), w_rnd_c_1, blockhash(block.number-3))));
886         } else {
887             _rnd = uint(keccak256(abi.encodePacked(blockhash(block.number-1), w_rnd_c_2, blockhash(block.number-2), w_rnd_c_1, blockhash(block.number-2))));
888         }
889         _rnd = _rnd % _totalPlayers;
890         return _rnd;
891     }
892 
893     function _handleLottery(uint256 lotto) external onlyOwner returns (bool) {
894         require(lotteries[lotto].transactionsPerLottery - lotteries[lotto].transactionsSinceLastLottery == 0, "Not enough tickets sold");
895         require(lotteries[lotto].winnerAddresses.length < lotteries[lotto].maximumWinners, "Winners already picked");
896 
897         uint256 _randomWinner; //50% win chance
898         if (lotteries[lotto].w_rt == 0) {
899             if(s_randomWords[s_requestId[lotto]].length > 0) {
900                 _randomWinner = s_randomWords[s_requestId[lotto]][lotteries[lotto].winnerAddresses.length] % (lotteries[lotto].playerIds.length*2);
901             }
902             else {
903                 require(s_requestId[lotto] == 0 || s_randomWords[s_requestId[lotto]].length == 0, "Request already made");
904                 requestRandomWords(lotto);
905                 return false;
906             }
907         }
908         else {
909             _randomWinner = random(lotteries[lotto].playerIds.length*2, lotteries[lotto].w_rt);
910         }
911         address _winnerAddress = _randomWinner >= lotteries[lotto].playerIds.length ? address(0) : lotteries[lotto].players[lotteries[lotto].playerIds[_randomWinner]];
912         uint256 _pot = address(this).balance;
913         
914         if (lotteries[lotto].tickets[_winnerAddress].length > 0 && _balances[_winnerAddress] > 0 && lastSell[_winnerAddress] < lotteries[lotto].created && !_isExcludedFromLottery[_winnerAddress] ) {
915             
916             if (_pot > lotteries[lotto].maximumJackpot)
917                 _pot = lotteries[lotto].maximumJackpot;
918                 
919             uint256 _winnings = _pot*lotteries[lotto].winPercentageThousandth/1000;
920         
921             transferToAddressETH(payable(_winnerAddress), _winnings);
922             emit LotteryWon(lotto, _winnerAddress, _winnings);
923             
924             uint256 winnings = userByAddress[_winnerAddress].totalWon;
925 
926             // Update user stats
927             userByAddress[_winnerAddress].lastWon = _winnings;
928             userByAddress[_winnerAddress].totalWon = winnings+_winnings;
929 
930             // Update global stats
931             lotteries[lotto].winnerValues.push(_winnings);
932             lotteries[lotto].winnerAddresses.push(_winnerAddress);
933             _allWon += _winnings;
934 
935         }
936         else {
937             // Player had no tickets/were excluded/had no tokens or has already been won..
938             emit LotteryNotWon(lotto, _winnerAddress, _pot);
939         }
940 
941         return true;
942     }
943 
944     //Catopia copy pasta inserts players in the right place  
945     function insertPlayer(address playerAddress, uint256 lotto) internal {
946         lotteries[lotto].players[lotteries[lotto].playerNewId] = playerAddress;
947         lotteries[lotto].tickets[playerAddress].push(lotteries[lotto].playerNewId);
948         lotteries[lotto].playerIds.push(lotteries[lotto].playerNewId);
949         lotteries[lotto].playerNewId += 1;
950     }
951     
952     function popPlayer(address playerAddress, uint256 ticketIndex, uint256 lotto) internal {
953         uint256 playerId = lotteries[lotto].tickets[playerAddress][ticketIndex];
954         lotteries[lotto].tickets[playerAddress][ticketIndex] = lotteries[lotto].tickets[playerAddress][lotteries[lotto].tickets[playerAddress].length - 1];
955         lotteries[lotto].tickets[playerAddress].pop();
956         delete lotteries[lotto].players[playerId];
957     }
958 
959 	function airdrop(address[] calldata _addresses, uint256[] calldata _amount) external onlyOwner
960     {
961         require(_addresses.length == _amount.length, "Array lengths don't match");
962         bool previousSwap = swapEnabled;
963         swapEnabled = false;
964         //This function may run out of gas intentionally to prevent partial airdrops
965         for (uint256 i = 0; i < _addresses.length; i++) {
966             require(!liquidityPools[_addresses[i]] && _addresses[i] != address(0), "Can't airdrop the liquidity pool or address 0");
967             _transferFrom(msg.sender, _addresses[i], _amount[i] * _decimalFactor);
968             lastBuy[_addresses[i]] = block.timestamp;
969         }
970         swapEnabled = previousSwap;
971         emit AirdropSent(msg.sender);
972     }
973 
974     event AutoLiquify(uint256 amount, uint256 amountToken);
975     event ProtectionSet(address indexed protection);
976     event ProtectionDisabled();
977     event LiquidityProviderSet(address indexed provider);
978     event SellPeriodSet(uint256 percent, uint256 period);
979     event TradingLaunched();
980     event TransactionLimitSet(uint256 limit);
981     event MaxWalletSet(uint256 limit);
982     event FeeExemptSet(address indexed wallet, bool isExempt);
983     event TrasactionLimitExemptSet(address indexed wallet, bool isExempt);
984     event FeesSet(uint256 totalFees, uint256 denominator, uint256 sellBias);
985     event SwapSettingsSet(uint256 minimum, uint256 maximum, bool enabled);
986     event LiquidityPoolSet(address indexed pool, bool enabled);
987     event AirdropSent(address indexed from);
988     event AntiDumpTaxSet(uint256 rate, uint256 period, uint256 threshold);
989     event TargetLiquiditySet(uint256 percent);
990     event ProtectionToggle(bool isEnabled);
991     event LotteryWon(uint256 lotto, address winner, uint256 amount);
992     event LotteryNotWon(uint256 lotto, address skippedAddress, uint256 pot);
993 }