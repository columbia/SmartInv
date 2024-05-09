1 /**
2 (w) : https://aerielab.io/ | (tg) : https://t.me/aerieofficial
3  */
4 // SPDX-License-Identifier: MIT
5 pragma solidity ^0.8.14;
6 
7 
8 abstract contract Context {
9     function _msgSender() internal view returns (address payable) {
10         return payable(msg.sender);
11     }
12 
13     function _msgData() internal view returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IDEXRouter {
20     function factory() external pure returns (address);
21     function WETH() external pure returns (address);
22 
23     function addLiquidity(
24         address tokenA,
25         address tokenB,
26         uint amountADesired,
27         uint amountBDesired,
28         uint amountAMin,
29         uint amountBMin,
30         address to,
31         uint deadline
32     ) external returns (uint amountA, uint amountB, uint liquidity);
33 
34     function addLiquidityETH(
35         address token,
36         uint amountTokenDesired,
37         uint amountTokenMin,
38         uint amountETHMin,
39         address to,
40         uint deadline
41     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
42 
43     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
44         uint amountIn,
45         uint amountOutMin,
46         address[] calldata path,
47         address to,
48         uint deadline
49     ) external;
50 
51     function swapExactETHForTokensSupportingFeeOnTransferTokens(
52         uint amountOutMin,
53         address[] calldata path,
54         address to,
55         uint deadline
56     ) external payable;
57 
58     function swapExactTokensForETHSupportingFeeOnTransferTokens(
59         uint amountIn,
60         uint amountOutMin,
61         address[] calldata path,
62         address to,
63         uint deadline
64     ) external;
65 }
66 
67 library SafeMath {
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71 
72         return c;
73     }
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         return sub(a, b, "SafeMath: subtraction overflow");
76     }
77     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b <= a, errorMessage);
79         uint256 c = a - b;
80 
81         return c;
82     }
83     
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97     
98     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         // Solidity only automatically asserts when dividing by 0
100         require(b > 0, errorMessage);
101         uint256 c = a / b;
102         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103 
104         return c;
105     }
106 }
107 
108 interface IERC20 {
109 
110     function totalSupply() external view returns (uint256);
111 
112     /**
113      * @dev Returns the amount of tokens owned by `account`.
114      */
115     function balanceOf(address account) external view returns (uint256);
116 
117     /**
118      * @dev Moves `amount` tokens from the caller's account to `recipient`.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transfer(address recipient, uint256 amount) external returns (bool);
125 
126     /**
127      * @dev Returns the remaining number of tokens that `spender` will be
128      * allowed to spend on behalf of `owner` through {transferFrom}. This is
129      * zero by default.
130      *
131      * This value changes when {approve} or {transferFrom} are called.
132      */
133     // K8u#El(o)nG3a#t!e c&oP0Y
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     /**
137      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * IMPORTANT: Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient` using the
154      * allowance mechanism. `amount` is then deducted from the caller's
155      * allowance.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Emitted when `value` tokens are moved from one account (`from`) to
165      * another (`to`).
166      *
167      * Note that `value` may be zero.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     /**
172      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
173      * a call to {approve}. `value` is the new allowance.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 contract Ownable is Context {
179     address private _owner;
180 
181     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
182 
183     /**
184      * @dev Initializes the contract setting the deployer as the initial owner.
185      */
186     constructor () {
187         address msgSender = _msgSender();
188         _owner = msgSender;
189         emit OwnershipTransferred(address(0), msgSender);
190     }
191 
192     /**
193      * @dev Returns the address of the current owner.
194      */
195     function owner() public view returns (address) {
196         return _owner;
197     }
198 
199     /**
200      * @dev Throws if called by any account other than the owner.
201      */
202     modifier onlyOwner() {
203         require(_owner == _msgSender(), "Ownable: caller is not the owner");
204         _;
205     }
206      /**
207      * @dev Leaves the contract without owner. It will not be possible to call
208      * `onlyOwner` functions anymore. Can only be called by the current owner.
209      *
210      * NOTE: Renouncing ownership will leave the contract without an owner,
211      * thereby removing any functionality that is only available to the owner.
212      */
213     function renounceOwnership() public virtual onlyOwner {
214         emit OwnershipTransferred(_owner, address(0));
215         _owner = address(0);
216     }
217 
218     /**
219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
220      * Can only be called by the current owner.
221      */
222     function transferOwnership(address newOwner) public virtual onlyOwner {
223         require(newOwner != address(0), "Ownable: new owner is the zero address");
224         emit OwnershipTransferred(_owner, newOwner);
225         _owner = newOwner;
226     }
227 }
228 
229 interface IDEXFactory {
230     function createPair(address tokenA, address tokenB) external returns (address pair);
231 }
232 
233 /**
234  * Main Contract Starts Here 
235  */
236 
237 contract AERIE is IERC20, Ownable {
238     using SafeMath for uint256;
239     
240     // About Amnesty
241     struct AmnestyTier {
242         string name;
243         bool active;
244         uint256 cost;
245         uint256 discount;
246         uint256 blocks;
247         uint index;
248     }
249     // these two variables will later store about all package available
250     uint public lastTierIndex = 0;
251     AmnestyTier[] public tiers;
252     
253     // these variables will later store about user active tier
254     struct UserTier {
255         bool usingTier;
256         uint256 lastBlock;
257         uint256 discount;
258         uint activeIndex;
259     }
260     mapping (address => UserTier) _userTier;
261     mapping (address => uint256) _amnestyGivenToUser;
262     uint256 public _totalBurnFromTier;
263     uint256 public _totalAmnesty;
264     uint public _totalSubscriber;
265 
266     // Name, Symbol, and Decimals Initialization
267     string constant _name = "AERIE";
268     string constant _symbol = "AER";
269     uint8 constant _decimals = 18;
270     
271     // Important Addresses
272     address ZERO = 0x0000000000000000000000000000000000000000;
273     address DEAD = 0x000000000000000000000000000000000000dEaD;
274     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
275     IDEXRouter public router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
276     // Supply
277     uint256 _totalSupply = 1000000000 * (10 ** _decimals); // 1,000,000,000 AER
278     
279     // Max Buy & Sell on each transaction
280     uint256 public _maxBuyTxAmount = (_totalSupply * 10) / 1000; // 1% are default
281     uint256 public _maxSellTxAmount = (_totalSupply * 10) / 1000; // 1% are default
282     uint256 public _maxWalletSize = (_totalSupply * 10) / 1000; // 1% are default
283 
284     mapping (address => uint256) _balances;
285     mapping (address => mapping (address => uint256)) _allowances;
286 
287     mapping (address => bool) isFeeExempt;
288     mapping (address => bool) isTxLimitExempt;
289     
290     // Fees Variables
291     uint256 liqFee; 
292     uint256 buybackFee; 
293     uint256 mktFee; 
294     uint256[3] devFee;
295 
296     // Total Fee
297     uint256 totalFee;
298     uint256 feeDenominator = 10000;
299     
300 
301     address autoLiquidityReceiver;
302     address secDevFeeReceiver;
303     address primDevFeeReceiver;
304     address thirdDevFeeReceiver;
305     address mktFeeReceiver;
306     address buybackFeeReceiver; 
307     
308     uint256 targetLiquidity = 25;
309     uint256 targetLiquidityDenominator = 100;
310 
311     // Router & Pair
312     address public pair;
313 
314     // Treshold & etc
315     bool public swapEnabled = true;
316 
317     uint256 public swapThreshold = _totalSupply / 1000; // 0.1%
318     bool inSwap;
319     modifier swapping() { inSwap = true; _; inSwap = false; }
320 
321     constructor (
322         address[] memory _receivers,
323         uint256[] memory _fees
324     ) {
325         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
326 
327         // Set Fee Receivers
328         primDevFeeReceiver = address(_receivers[0]);
329         secDevFeeReceiver = address(_receivers[1]);
330         thirdDevFeeReceiver = address(_receivers[2]);
331         mktFeeReceiver = address(_receivers[3]);
332         buybackFeeReceiver = address(_receivers[4]);
333         
334         // Set Default Taxes
335         liqFee = _fees[0]; 
336         buybackFee = _fees[1]; 
337         mktFee = _fees[2]; 
338         devFee = [_fees[3],_fees[4],_fees[5]];
339         totalFee = liqFee.add(buybackFee).add(mktFee).add(devFee[0]).add(devFee[1]).add(devFee[2]);
340         
341         // Another Initialization
342         _allowances[address(this)][address(router)] = type(uint256).max;
343         isFeeExempt[msg.sender] = true;
344         isFeeExempt[primDevFeeReceiver] = true;
345         isFeeExempt[secDevFeeReceiver] = true;
346         isFeeExempt[thirdDevFeeReceiver] = true;
347         isFeeExempt[mktFeeReceiver] = true;
348         
349         isTxLimitExempt[msg.sender] = true;
350         isTxLimitExempt[primDevFeeReceiver] = true;
351         isTxLimitExempt[secDevFeeReceiver] = true;
352         isTxLimitExempt[thirdDevFeeReceiver] = true;
353         isTxLimitExempt[mktFeeReceiver] = true;
354         isTxLimitExempt[DEAD] = true;
355         isTxLimitExempt[ZERO] = true;
356         isTxLimitExempt[address(this)] = true;
357         
358         autoLiquidityReceiver = owner();
359         
360         _balances[msg.sender] = _totalSupply;
361         emit Transfer(address(0), msg.sender, _totalSupply);
362     }
363 
364     receive() external payable { }
365 
366     function approve(address spender, uint256 amount) public override returns (bool) {
367         _allowances[msg.sender][spender] = amount;
368         emit Approval(msg.sender, spender, amount);
369         return true;
370     }
371 
372     function approveMax(address spender) external returns (bool) {
373         return approve(spender, type(uint256).max);
374     }
375 
376     function transfer(address recipient, uint256 amount) external override returns (bool) {
377         return _transferFrom(msg.sender, recipient, amount);
378     }
379 
380     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
381         if(_allowances[sender][msg.sender] != type(uint256).max){
382             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
383         }
384 
385         return _transferFrom(sender, recipient, amount);
386     }
387 
388     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
389         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
390         
391         // coniditional Boolean
392         bool isTxExempted = (isTxLimitExempt[sender] || isTxLimitExempt[recipient]);
393         bool isContractTransfer = (sender==address(this) || recipient==address(this));
394         bool isLiquidityTransfer = ((sender == pair && recipient == address(router)) || (recipient == pair && sender == address(router) ));
395         
396         if(!isTxExempted && !isContractTransfer && !isLiquidityTransfer ){
397             txLimitter(sender,recipient, amount);
398         }
399         if (recipient != pair && recipient != DEAD) {
400             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletSize, "Transfer amount exceeds the wallet size.");
401         }
402         if(shouldSwapBack()){ swapBack(); }
403     
404         uint256 amountReceived = shouldTakeFee(sender,recipient) ? takeFee(sender, recipient, amount) : amount;
405         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
406         _balances[recipient] = _balances[recipient].add(amountReceived);
407         
408 
409         emit Transfer(sender, recipient, amountReceived);
410         return true;
411     }
412 
413     
414 
415     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
416         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
417         _balances[recipient] = _balances[recipient].add(amount);
418         emit Transfer(sender, recipient, amount);
419         return true;
420     }
421 
422     function txLimitter(address sender, address recipient, uint256 amount) internal view {
423         
424         bool isBuy = sender == pair || sender == address(router);
425         bool isSell = recipient== pair || recipient == address(router);
426         
427         if(isBuy){
428             require(amount <= _maxBuyTxAmount, "TX Limit Exceeded");
429         }else if(isSell){
430             require(amount <= _maxSellTxAmount, "TX Limit Exceeded");
431         }
432         
433     }
434     
435     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
436         return !isFeeExempt[sender] && !isFeeExempt[recipient];
437     }
438 
439     function getTotalFee() public view returns (uint256) {
440         return totalFee;
441     }
442 
443     function takeFee(address sender, address receiver, uint256 amount) internal returns (uint256) {
444         uint256 feeAmount = amount.mul(getTotalFee()).div(feeDenominator);
445         uint256 amnestyAmount;
446         uint256 finalFeeAmount;
447         UserTier memory _userFee;
448         bool isBuy = sender == pair || sender == address(router);
449         bool isSell = receiver== pair || receiver == address(router);
450         bool isNormalTransfer = sender != pair && sender != address(router) && receiver != pair && receiver != address(router);
451 
452         // check wether the sender are subscribe for amnesty or not
453         if(isBuy){
454             // when buy, then the user are receiver
455             _userFee = _userTier[receiver];        
456         }else if(isSell){
457             // when sell, then the user are sender
458             _userFee = _userTier[sender];
459         }else if(isNormalTransfer){
460             // if its normal transfer, we take consideration from sender perspective
461             _userFee = _userTier[sender];
462         }
463 
464         if(_userFee.usingTier && block.number <= _userFee.lastBlock){
465             amnestyAmount = feeAmount.mul(_userFee.discount).div(feeDenominator);
466         }
467 
468         if(amnestyAmount >= 0){
469              _totalAmnesty = _totalAmnesty.add(amnestyAmount); // record total token saved from amnesty
470              // set to specific user
471              if(isBuy){
472                  _amnestyGivenToUser[receiver] = _amnestyGivenToUser[receiver].add(amnestyAmount);
473              }else if(isSell || isNormalTransfer){
474                  _amnestyGivenToUser[sender] = _amnestyGivenToUser[sender].add(amnestyAmount);
475              }
476         }
477         finalFeeAmount = feeAmount.sub(amnestyAmount); // apply the amnesty into the fee
478         
479         _balances[address(this)] = _balances[address(this)].add(finalFeeAmount);
480         emit Transfer(sender, address(this), finalFeeAmount);
481 
482         return amount.sub(finalFeeAmount);
483     }
484     
485     function shouldSwapBack() internal view returns (bool) {
486         return msg.sender != pair
487         && !inSwap
488         && swapEnabled
489         && _balances[address(this)] >= swapThreshold;
490     }
491     
492     function swapBack() internal swapping {
493         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liqFee;
494         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
495         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
496 
497         address[] memory path = new address[](2);
498         path[0] = address(this);
499         path[1] = WETH;
500 
501         uint256 balanceBefore = address(this).balance;
502 
503         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
504             amountToSwap,
505             0,
506             path,
507             address(this),
508             block.timestamp
509         );
510 
511         uint256 amountETH = address(this).balance.sub(balanceBefore);
512 
513         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
514 
515         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
516         uint256 amountETHDev = amountETH.mul(devFee[0]).div(totalETHFee);
517         uint256 amountETHTeam = amountETH.mul(devFee[1]).div(totalETHFee);
518         uint256 amountETHTeamOther = amountETH.mul(devFee[2]).div(totalETHFee);
519         uint256 amountETHMkt = amountETH.mul(mktFee).div(totalETHFee);
520         uint256 amountETHBuyBack = amountETH.mul(buybackFee).div(totalETHFee);
521         
522         sendPayable(amountETHDev, amountETHMkt, amountETHTeam, amountETHTeamOther, amountETHBuyBack);
523 
524         if(amountToLiquify > 0){
525             router.addLiquidityETH{value: amountETHLiquidity}(
526                 address(this),
527                 amountToLiquify,
528                 0,
529                 0,
530                 autoLiquidityReceiver,
531                 block.timestamp
532             );
533             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
534         }
535     }
536 
537     function sendPayable(uint256 amtDev, uint256 amtMkt, uint256 amtTeam, uint256 amtTeamOther, uint256 amtBuyback) internal {
538         (bool successone,) = payable(primDevFeeReceiver).call{value: amtDev, gas: 30000}("");
539         (bool successtwo,) = payable(mktFeeReceiver).call{value: amtMkt, gas: 30000}("");
540         (bool successthree,) = payable(secDevFeeReceiver).call{value: amtTeam, gas: 30000}("");
541         (bool successfour,) = payable(buybackFeeReceiver).call{value: amtBuyback, gas: 30000}("");
542         (bool successfive,) = payable(buybackFeeReceiver).call{value: amtTeamOther, gas: 30000}("");
543         require(successone && successtwo && successthree && successfour && successfive, "receiver rejected ETH transfer");
544     }
545 
546     // used for flushing stuck Native token on Contract
547     function flushStuckBalance() external onlyOwner {
548         uint256 bal = address(this).balance; // return the native token ( ETH )
549         (bool success,) = payable(primDevFeeReceiver).call{value: bal, gas: 30000}("");
550         require(success, "receiver rejected ETH transfer");
551     }
552     
553     /**
554      * 
555      * CONFIGURATIONS
556      * 
557      */
558 
559     function addNewTier(
560         string memory _tierName,
561         uint256 cost,
562         uint256 discount,
563         uint256 blocks
564     ) external onlyOwner {
565         AmnestyTier memory _newTier = AmnestyTier(
566             _tierName,
567             true,
568             (cost * (10 ** _decimals)),
569             discount,
570             blocks,
571             lastTierIndex
572         );
573         tiers.push(_newTier);
574         lastTierIndex = lastTierIndex.add(1);
575     }
576 
577     function modifyTier(
578         uint index,
579         bool _active,
580         string memory _tierName,
581         uint256 cost,
582         uint256 discount,
583         uint256 blocks
584     ) external onlyOwner {
585         tiers[index].active = _active;
586         tiers[index].name = _tierName;
587         tiers[index].cost = (cost * (10 ** _decimals));
588         tiers[index].discount = discount;
589         tiers[index].blocks = blocks;
590     }
591 
592     function getAllTiers() public view returns (AmnestyTier[] memory){
593         return tiers;
594     }
595 
596     function getTierDetail(uint index) public view returns (AmnestyTier memory){
597         return tiers[index];
598     }
599     function getTierDetailByUser(address user) public view returns (AmnestyTier memory){
600         return tiers[_userTier[user].activeIndex];
601     }
602 
603     function getUserTier(address user) public view returns (UserTier memory){
604         return _userTier[user];
605     }
606     function getAmnestyGivenToUser(address user) public view returns (uint256){
607         return _amnestyGivenToUser[user];
608     }
609     function subscribeForAmnesty(uint index) public{
610         // obtain the tier package
611         AmnestyTier memory _selectedTier = tiers[index];
612         // now we get the cost
613         uint256 _costToSubscribe = _selectedTier.cost;
614         uint256 balance = balanceOf(_msgSender());
615         require(balance >= _costToSubscribe, "INS: Insufficient Balance");
616         require(_selectedTier.active,"INACTIVE: The Tier is not active");
617         
618         _transferFrom(_msgSender(), DEAD, _costToSubscribe); // the cost are burn to dead wallet
619         
620         // then, we increment
621         _totalBurnFromTier = _totalBurnFromTier.add(_costToSubscribe);
622         // now check wether the user has been subscribed before or not
623         if(!_userTier[_msgSender()].usingTier){
624             // means that the user never pay for subscription before
625             _totalSubscriber = _totalSubscriber.add(1);
626         }
627         _userTier[_msgSender()] = UserTier(
628             true,
629             (block.number).add(_selectedTier.blocks),
630             _selectedTier.discount,
631             index
632         );
633     }
634     
635     function setDevFee(uint256[] memory fee) external onlyOwner {
636         // total fee should not be more than 10%;
637         uint256 simulatedFee = fee[0].add(fee[1]).add(fee[2]).add(liqFee).add(buybackFee).add(mktFee);
638         require(simulatedFee <= 1000, "Fees too high !!");
639         devFee[0] = fee[0];
640         devFee[1] = fee[1];
641         devFee[2] = fee[2];
642         totalFee = simulatedFee;
643     }
644     function setBuybackFee(uint256 fee) external onlyOwner {
645         // total fee should not be more than 10%;
646         uint256 simulatedFee = fee.add(liqFee).add(devFee[0]).add(devFee[1]).add(devFee[2]).add(mktFee);
647         require(simulatedFee <= 1000, "Fees too high !!");
648         buybackFee = fee;
649         totalFee = simulatedFee;
650     }
651     function setLpFee(uint256 fee) external onlyOwner {
652         // total fee should not be more than 10%;
653         uint256 simulatedFee = fee.add(devFee[0]).add(buybackFee).add(devFee[1]).add(devFee[2]).add(mktFee);
654         require(simulatedFee <= 1000, "Fees too high !!");
655         liqFee = fee;
656         totalFee = simulatedFee;
657     }
658     
659     function setMarketingFee(uint256 fee) external onlyOwner {
660         // total fee should not be more than 10%;
661         uint256 simulatedFee = fee.add(devFee[0]).add(buybackFee).add(liqFee).add(devFee[1]).add(devFee[2]);
662         require(simulatedFee < 1000, "Fees too high !!");
663         mktFee = fee;
664         totalFee = simulatedFee;
665     }
666     
667     function setBuyTxMaximum(uint256 max) external onlyOwner{
668         uint256 minimumTreshold = (_totalSupply * 7) / 1000; // 0.7% is the minimum tx limit, we cant set below this
669         uint256 simulatedMaxTx = (_totalSupply * max) / 1000;
670         require(simulatedMaxTx >= minimumTreshold, "Tx Limit is too low");
671         _maxBuyTxAmount = simulatedMaxTx;
672     }
673     
674     function setSellTxMaximum(uint256 max) external onlyOwner {
675         uint256 minimumTreshold = (_totalSupply * 7) / 1000; // 0.7% is the minimum tx limit, we cant set below this
676         uint256 simulatedMaxTx = (_totalSupply * max) / 1000;
677         require(simulatedMaxTx >= minimumTreshold, "Tx Limit is too low");
678         _maxSellTxAmount = simulatedMaxTx;
679     }
680 
681     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner{
682         require(numerator > 0 && divisor > 0 && divisor <= 10000);
683         _maxWalletSize = _totalSupply.mul(numerator).div(divisor);
684     }
685     
686     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
687         isFeeExempt[holder] = exempt;
688     }
689 
690     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
691         isTxLimitExempt[holder] = exempt;
692     }
693     
694     function setFeeReceivers(address _autoLiquidityReceiver, address _primDevFeeReceiver, address _mktFeeReceiver, address _secDevFeeReceiver,address _thirdDevFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
695         autoLiquidityReceiver = _autoLiquidityReceiver;
696         primDevFeeReceiver = _primDevFeeReceiver;
697         mktFeeReceiver = _mktFeeReceiver;
698         secDevFeeReceiver = _secDevFeeReceiver;
699         buybackFeeReceiver = _buybackFeeReceiver;
700         thirdDevFeeReceiver = _thirdDevFeeReceiver;
701     }
702 
703     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
704         swapEnabled = _enabled;
705         swapThreshold = _amount.div(100);
706     }
707 
708     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
709         targetLiquidity = _target;
710         targetLiquidityDenominator = _denominator;
711     }
712 
713     
714     
715     function getCirculatingSupply() public view returns (uint256) {
716         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
717     }
718 
719     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
720         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
721     }
722 
723     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
724         return getLiquidityBacking(accuracy) > target;
725     }
726     
727     
728     
729 
730     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
731     
732     function totalSupply() external view override returns (uint256) { return _totalSupply; }
733     function decimals() external pure returns (uint8) { return _decimals; }
734     function symbol() external pure returns (string memory) { return _symbol; }
735     function name() external pure returns (string memory) { return _name; }
736     function getOwner() external view returns (address) { return owner(); }
737     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
738     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
739     
740 }