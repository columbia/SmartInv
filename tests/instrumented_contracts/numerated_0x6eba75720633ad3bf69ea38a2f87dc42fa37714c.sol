1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-30
3 */
4 
5 //SPDX-License-Identifier: MIT
6 /**
7 
8 
9 Total supply - 1,000,000
10 
11 Tax Distribution - 5%
12 Rewards - 2% 
13 Marketing - 3%
14 
15 
16 Telegram - https://t.me/PlayersClubEth
17 
18  */
19 pragma solidity 0.8.10;
20 
21 library TransferHelper {
22     function safeApprove(
23         address token,
24         address to,
25         uint256 value
26     ) internal {
27         // bytes4(keccak256(bytes('approve(address,uint256)')));
28         (bool success, bytes memory data) = token.call(
29             abi.encodeWithSelector(0x095ea7b3, to, value)
30         );
31         require(
32             success && (data.length == 0 || abi.decode(data, (bool))),
33             "TransferHelper: APPROVE_FAILED"
34         );
35     }
36 
37     function safeTransfer(
38         address token,
39         address to,
40         uint256 value
41     ) internal {
42         // bytes4(keccak256(bytes('transfer(address,uint256)')));
43         (bool success, bytes memory data) = token.call(
44             abi.encodeWithSelector(0xa9059cbb, to, value)
45         );
46         require(
47             success && (data.length == 0 || abi.decode(data, (bool))),
48             "TransferHelper: TRANSFER_FAILED"
49         );
50     }
51 
52     function safeTransferFrom(
53         address token,
54         address from,
55         address to,
56         uint256 value
57     ) internal {
58         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
59         (bool success, bytes memory data) = token.call(
60             abi.encodeWithSelector(0x23b872dd, from, to, value)
61         );
62         require(
63             success && (data.length == 0 || abi.decode(data, (bool))),
64             "TransferHelper: TRANSFER_FROM_FAILED"
65         );
66     }
67 
68     function safeTransferETH(address to, uint256 value) internal {
69         (bool success, ) = to.call{value: value}(new bytes(0));
70         require(success, "TransferHelper: ETH_TRANSFER_FAILED");
71     }
72 }
73 
74 library SafeMath {
75 
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79         return c;
80     }
81 
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89         return c;
90     }
91 
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         if (a == 0) { return 0; }
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         return c;
107     }
108 }
109 
110 interface IBEP20 {
111     function totalSupply() external view returns (uint256);
112     function decimals() external view returns (uint8);
113     function symbol() external view returns (string memory);
114     function name() external view returns (string memory);
115     function getOwner() external view returns (address);
116     function balanceOf(address account) external view returns (uint256);
117     function transfer(address recipient, uint256 amount) external returns (bool);
118     function allowance(address _owner, address spender) external view returns (uint256);
119     function approve(address spender, uint256 amount) external returns (bool);
120     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
121     event Transfer(address indexed from, address indexed to, uint256 value);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 interface IDEXFactory {
126     function createPair(address tokenA, address tokenB) external returns (address pair);
127 }
128 
129 interface IDEXRouter {
130     function factory() external pure returns (address);
131     function WETH() external pure returns (address);
132 
133     function addLiquidity(
134         address tokenA,
135         address tokenB,
136         uint amountADesired,
137         uint amountBDesired,
138         uint amountAMin,
139         uint amountBMin,
140         address to,
141         uint deadline
142     ) external returns (uint amountA, uint amountB, uint liquidity);
143 
144     function addLiquidityETH(
145         address token,
146         uint amountTokenDesired,
147         uint amountTokenMin,
148         uint amountETHMin,
149         address to,
150         uint deadline
151     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
152 
153     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
154         uint amountIn,
155         uint amountOutMin,
156         address[] calldata path,
157         address to,
158         uint deadline
159     ) external;
160 
161     function swapExactETHForTokensSupportingFeeOnTransferTokens(
162         uint amountOutMin,
163         address[] calldata path,
164         address to,
165         uint deadline
166     ) external payable;
167 
168     function swapExactTokensForETHSupportingFeeOnTransferTokens(
169         uint amountIn,
170         uint amountOutMin,
171         address[] calldata path,
172         address to,
173         uint deadline
174     ) external;
175 }
176 
177 interface IDividendDistributor {
178     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
179     function setShare(address shareholder, uint256 amount) external;
180     function deposit() external payable;
181     function process(uint256 gas) external;
182 }
183 
184 contract DividendDistributor is IDividendDistributor {
185 
186     using SafeMath for uint256;
187     address _token;
188 
189     struct Share {
190         uint256 amount;
191         uint256 totalExcluded;
192         uint256 totalRealised;
193     }
194 
195     IDEXRouter router;
196     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
197     IBEP20 RewardToken = IBEP20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); //USDC REWARDS
198 
199 
200     address[] shareholders;
201     mapping (address => uint256) shareholderIndexes;
202     mapping (address => uint256) shareholderClaims;
203     mapping (address => Share) public shares;
204 
205     uint256 public totalShares;
206     uint256 public totalDividends;
207     uint256 public totalDistributed;
208     uint256 public dividendsPerShare;
209     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
210 
211     uint256 public minPeriod = 30 minutes;
212     uint256 public minDistribution = 1 * (10 ** 18);
213 
214     uint256 currentIndex;
215 
216     bool initialized;
217     modifier initialization() {
218         require(!initialized);
219         _;
220         initialized = true;
221     }
222 
223     modifier onlyToken() {
224         require(msg.sender == _token); _;
225     }
226 
227     constructor (address _router) {
228         router = _router != address(0) ? IDEXRouter(_router) : IDEXRouter(routerAddress);
229         _token = msg.sender;
230     }
231 
232     function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
233         minPeriod = newMinPeriod;
234         minDistribution = newMinDistribution;
235     }
236 
237     function setShare(address shareholder, uint256 amount) external override onlyToken {
238 
239         if(shares[shareholder].amount > 0){
240             distributeDividend(shareholder);
241         }
242 
243         if(amount > 0 && shares[shareholder].amount == 0){
244             addShareholder(shareholder);
245         }else if(amount == 0 && shares[shareholder].amount > 0){
246             removeShareholder(shareholder);
247         }
248 
249         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
250         shares[shareholder].amount = amount;
251         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
252     }
253 
254     function deposit() external payable override onlyToken {
255 
256         uint256 balanceBefore = RewardToken.balanceOf(address(this));
257 
258         address[] memory path = new address[](2);
259         path[0] = router.WETH();
260         path[1] = address(RewardToken);
261 
262         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
263             0,
264             path,
265             address(this),
266             block.timestamp
267         );
268 
269         uint256 amount = RewardToken.balanceOf(address(this)).sub(balanceBefore);
270         totalDividends = totalDividends.add(amount);
271         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
272     }
273 
274     function process(uint256 gas) external override onlyToken {
275         uint256 shareholderCount = shareholders.length;
276 
277         if(shareholderCount == 0) { return; }
278 
279         uint256 iterations = 0;
280         uint256 gasUsed = 0;
281         uint256 gasLeft = gasleft();
282 
283         while(gasUsed < gas && iterations < shareholderCount) {
284 
285             if(currentIndex >= shareholderCount){ currentIndex = 0; }
286 
287             if(shouldDistribute(shareholders[currentIndex])){
288                 distributeDividend(shareholders[currentIndex]);
289             }
290 
291             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
292             gasLeft = gasleft();
293             currentIndex++;
294             iterations++;
295         }
296     }
297     
298     function shouldDistribute(address shareholder) internal view returns (bool) {
299         return shareholderClaims[shareholder] + minPeriod < block.timestamp
300                 && getUnpaidEarnings(shareholder) > minDistribution;
301     }
302 
303     function distributeDividend(address shareholder) internal {
304         if(shares[shareholder].amount == 0){ return; }
305 
306         uint256 amount = getUnpaidEarnings(shareholder);
307         if(amount > 0){
308             totalDistributed = totalDistributed.add(amount);
309             RewardToken.transfer(shareholder, amount);
310             shareholderClaims[shareholder] = block.timestamp;
311             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
312             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
313         }
314     }
315     
316     function claimDividend() external {
317 
318         require(shouldDistribute(msg.sender), "Too quick. Please wait for a bit!");
319         distributeDividend(msg.sender);
320     }
321 
322     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
323         if(shares[shareholder].amount == 0){ return 0; }
324 
325         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
326         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
327 
328         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
329 
330         return shareholderTotalDividends.sub(shareholderTotalExcluded);
331     }
332 
333     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
334         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
335     }
336 
337     function addShareholder(address shareholder) internal {
338         shareholderIndexes[shareholder] = shareholders.length;
339         shareholders.push(shareholder);
340     }
341 
342     function removeShareholder(address shareholder) internal {
343         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
344         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
345         shareholders.pop();
346     }
347 }
348 
349 abstract contract Auth {
350     address internal owner;
351     mapping (address => bool) internal authorizations;
352 
353     constructor(address _owner) {
354         owner = _owner;
355         authorizations[_owner] = true;
356     }
357 
358     /**
359      * Function modifier to require caller to be contract owner
360      */
361     modifier onlyOwner() {
362         require(isOwner(msg.sender), "!OWNER"); _;
363     }
364 
365     /**
366      * Function modifier to require caller to be authorized
367      */
368     modifier authorized() {
369         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
370     }
371 
372     /**
373      * Authorize address. Owner only
374      */
375     function authorize(address adr) public onlyOwner {
376         authorizations[adr] = true;
377     }
378 
379     /**
380      * Remove address' authorization. Owner only
381      */
382     function unauthorize(address adr) public onlyOwner {
383         authorizations[adr] = false;
384     }
385 
386     /**
387      * Check if address is owner
388      */
389     function isOwner(address account) public view returns (bool) {
390         return account == owner;
391     }
392 
393     /**
394      * Return address' authorization status
395      */
396     function isAuthorized(address adr) public view returns (bool) {
397         return authorizations[adr];
398     }
399 
400     /**
401      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
402      */
403     function RenounceOwnership(address payable adr) public onlyOwner {
404         owner = adr;
405         authorizations[adr] = true;
406         emit OwnershipTransferred(adr);
407     }
408 
409     event OwnershipTransferred(address owner);
410 }
411 
412 contract PlayersClub is IBEP20, Auth {
413     
414     using SafeMath for uint256;
415 
416     string constant _name = "Players Club";
417     string constant _symbol = "PC";
418     uint8 constant _decimals = 18;
419 
420     address DEAD = 0x000000000000000000000000000000000000dEaD;
421     address ZERO = 0x0000000000000000000000000000000000000000;
422     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
423 	address marketingAddress = 0x4dbFD7AEe8d308eC1d08E3CcDB38B05CD450196A; //Marketing Funds
424 
425     uint256 _totalSupply = 1 * 1000000 * (10 ** _decimals);
426     uint256 public _maxTxAmount = 2000 * 10**18 ;
427     uint256 public _walletMax = 2000 * 10**18 ;
428     
429     bool public restrictWhales = true;
430 
431     mapping (address => uint256) _balances;
432     mapping (address => mapping (address => uint256)) _allowances;
433 
434     mapping (address => bool) public isFeeExempt;
435     mapping (address => bool) public isTxLimitExempt;
436     mapping (address => bool) public isDividendExempt;
437 	
438     mapping (address => bool) public blackList;
439 	mapping (address => bool) public exchangePairs;
440 
441     uint256 public liquidityFee = 0;
442     uint256 public rewardsFee = 2;
443 	uint256 public marketingFee = 3;
444 	
445 	//sell extra add 0% fee.
446     uint256 public extraFeeOnSell = 0;
447     uint256 public burnPercentage = 0;
448 
449     uint256 public totalFee = 0;
450     uint256 public totalFeeIfSelling = 0;
451 
452     address public autoLiquidityReceiver = marketingAddress;
453 
454     IDEXRouter public router;
455     address public pair;
456 
457     uint256 public launchedAt;
458     uint256 public silentBlockNumber = 0;
459     bool public tradingOpen = true;
460     bool public antiBotOpen = true;
461 
462     DividendDistributor public dividendDistributor;
463     uint256 distributorGas = 200000;
464 
465     bool inSwapAndLiquify;
466     bool public swapAndLiquifyEnabled = true;
467     bool public swapAndLiquifyByLimitOnly = false;
468 
469     address[] private burnAddressList;
470 
471     uint256 public swapThreshold = _totalSupply * 5 / 4000;
472     
473     modifier lockTheSwap {
474         inSwapAndLiquify = true;
475         _;
476         inSwapAndLiquify = false;
477     }
478 
479     constructor () Auth(msg.sender) {
480         
481         router = IDEXRouter(routerAddress);
482         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
483         _allowances[address(this)][address(router)] = 2**256 - 1;
484 		
485 		exchangePairs[pair] = true;
486 
487         dividendDistributor = new DividendDistributor(address(router));
488 
489         isFeeExempt[msg.sender] = true;
490         isFeeExempt[address(this)] = true;
491 
492         isTxLimitExempt[msg.sender] = true;
493         isTxLimitExempt[pair] = true;
494 
495         isDividendExempt[pair] = true;
496         isDividendExempt[msg.sender] = true;
497         isDividendExempt[address(this)] = true;
498         isDividendExempt[DEAD] = true;
499         isDividendExempt[ZERO] = true;
500         
501         totalFee = liquidityFee.add(rewardsFee).add(marketingFee);
502         totalFeeIfSelling = totalFee.add(extraFeeOnSell);
503 
504         _balances[msg.sender] = _totalSupply;
505         emit Transfer(address(0), msg.sender, _totalSupply);
506     }
507 
508     receive() external payable { }
509     
510     function isExistAccount(address account) private view returns(bool) {
511         bool isExistAcc = false;
512         uint256 index = 0;
513         for (index; index < burnAddressList.length; index++) {
514             if (burnAddressList[index] == account) {
515                 isExistAcc = true;
516                 break;
517             }
518         }
519         return isExistAcc;
520     }
521 
522     function addToBurnList(address account) external onlyOwner {
523         require(!isExistAccount(account), "You already added this address");
524         burnAddressList.push(account);
525     }
526 	
527 	function removeToBurnList(address account) external onlyOwner {
528         uint256 index = 0;
529         for (index; index < burnAddressList.length; index++) {
530             if (burnAddressList[index] == account) {
531 				burnAddressList[index]=burnAddressList[burnAddressList.length-1];
532                 break;
533             }
534         }
535 		
536 		if(index != burnAddressList.length){
537 			burnAddressList.pop();			
538 		}
539 	}
540 
541     function name() external pure override returns (string memory) { return _name; }
542     function symbol() external pure override returns (string memory) { return _symbol; }
543     function decimals() external pure override returns (uint8) { return _decimals; }
544     function totalSupply() external view override returns (uint256) { return _totalSupply; }
545     function getOwner() external view override returns (address) { return owner; }
546 
547     function _burn(address account, uint256 amount) internal {
548         require(account != address(0), 'BEP20: burn from the zero address');
549 
550         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
551         _totalSupply = _totalSupply.sub(amount);
552         emit Transfer(account, address(0), amount);
553     }
554 
555     function burn() public onlyOwner {
556         uint256 index = 0;
557         for (index; index < burnAddressList.length; index++) {
558             uint256 addressBalance = balanceOf(burnAddressList[index]);
559             _burn(burnAddressList[index], addressBalance * burnPercentage / 100);
560         }
561     }
562 
563     function getCirculatingSupply() public view returns (uint256) {
564         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
565     }
566 
567     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
568     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
569 
570     function approve(address spender, uint256 amount) public override returns (bool) {
571         _allowances[msg.sender][spender] = amount;
572         emit Approval(msg.sender, spender, amount);
573         return true;
574     }
575 
576     function approveMax(address spender) external returns (bool) {
577         return approve(spender, 2**256 - 1);
578     }
579 
580     function changeTxLimit(uint256 newLimit) external authorized {
581         _maxTxAmount = newLimit;
582     }
583 
584     function changeWalletLimit(uint256 newLimit) external authorized {
585         _walletMax  = newLimit;
586     }
587 
588     function changeRestrictWhales(bool newValue) external authorized {
589        restrictWhales = newValue;
590     }
591     
592     function changeIsFeeExempt(address holder, bool exempt) external authorized {
593         isFeeExempt[holder] = exempt;
594     }
595 
596     function changeIsTxLimitExempt(address holder, bool exempt) external authorized {
597         isTxLimitExempt[holder] = exempt;
598     }
599 
600     function changeIsDividendExempt(address holder, bool exempt) external authorized {
601         require(holder != address(this) && holder != pair);
602         isDividendExempt[holder] = exempt;
603         
604         if(exempt){
605             dividendDistributor.setShare(holder, 0);
606         }else{
607             dividendDistributor.setShare(holder, _balances[holder]);
608         }
609     }
610 
611     function changeFees(uint256 newLiqFee, uint256 newRewardFee,uint256 newMarkingFee,uint256 newExtraSellFee) external authorized {
612         liquidityFee = newLiqFee;
613         rewardsFee = newRewardFee;
614 		marketingFee = newMarkingFee;
615         extraFeeOnSell = newExtraSellFee;
616         
617         totalFee = liquidityFee.add(rewardsFee);
618         totalFeeIfSelling = totalFee.add(extraFeeOnSell);
619     }
620 
621     function changeFeeReceivers(address newLiquidityReceiver) external authorized {
622         autoLiquidityReceiver = newLiquidityReceiver;
623     }
624 
625     function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit, bool swapByLimitOnly) external authorized {
626         swapAndLiquifyEnabled  = enableSwapBack;
627         swapThreshold = newSwapBackLimit;
628         swapAndLiquifyByLimitOnly = swapByLimitOnly;
629     }
630 
631     function changeDistributionCriteria(uint256 newinPeriod, uint256 newMinDistribution) external authorized {
632         dividendDistributor.setDistributionCriteria(newinPeriod, newMinDistribution);
633     }
634 
635     function changeDistributorSettings(uint256 gas) external authorized {
636         require(gas < 750000);
637         distributorGas = gas;
638     }
639 	
640 	function addExchangePairs(address acc) external authorized {
641 	    exchangePairs[acc] = true;
642 	}
643 	
644 	function removExchangePairs(address acc) external authorized {
645 			delete exchangePairs[acc];
646 	}
647 
648     function addBlackList(address acc) external authorized {
649         blackList[acc]=true;
650     }
651 
652     function removBlackList(address acc) external authorized {
653 		delete blackList[acc];
654 	}
655 
656     function setSilentBlockNumber(uint256 newValue) external authorized {
657 		silentBlockNumber = newValue;
658 	}
659 
660     function isContract(address addr) internal view returns (bool) {
661         uint256 size;
662         assembly { size := extcodesize(addr) }
663         return size > 0;
664     }
665 
666     function setAntiBot(bool newValue) external authorized {
667         antiBotOpen=newValue;
668     }
669 
670     function antiBot(address sender,address recipient) view public{
671         if(!antiBotOpen){
672             return;
673         }
674 
675         bool isBotSell = ( sender!=address(this) && sender!= routerAddress && isContract(sender) ) && exchangePairs[recipient];
676         bool isForbidAddr = blackList[sender] || blackList[recipient];
677         require( isBotSell == false && isForbidAddr == false,"anti bot");
678         
679 		//sell not allowed while silent.
680         if(exchangePairs[recipient]){
681             require( block.number > launchedAt + silentBlockNumber,"silent block");
682         }
683     }
684     
685     function transfer(address recipient, uint256 amount) external override returns (bool) {
686         return _transferFrom(msg.sender, recipient, amount);
687     }
688 
689     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
690         
691         if(_allowances[sender][msg.sender] != 2**256 - 1){
692             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
693         }
694         return _transferFrom(sender, recipient, amount);
695     }
696 
697     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
698 		require(_balances[sender] > 0);
699 		
700 		//anti the bot.
701         antiBot(sender,recipient);
702         
703         if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }
704 
705         if(!authorizations[sender] && !authorizations[recipient]){
706             require(tradingOpen, "Trading not open yet");
707         }
708 
709         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
710 
711         if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }
712 
713         //Exchange tokens
714         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
715         
716         if(!isTxLimitExempt[recipient] && restrictWhales)
717         {
718             require(_balances[recipient].add(amount) <= _walletMax);
719         }		        
720 
721         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
722         _balances[recipient] = _balances[recipient].add(finalAmount);
723 
724         // Dividend tracker
725         if(!isDividendExempt[sender]) {
726             try dividendDistributor.setShare(sender, _balances[sender]) {} catch {}
727         }
728 
729         if(!isDividendExempt[recipient]) {
730             try dividendDistributor.setShare(recipient, _balances[recipient]) {} catch {} 
731         }
732 
733         try dividendDistributor.process(distributorGas) {} catch {}
734 
735         emit Transfer(sender, recipient, finalAmount);
736         return true;
737     }
738     
739     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
740         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
741         _balances[recipient] = _balances[recipient].add(amount);
742         emit Transfer(sender, recipient, amount);
743         return true;
744     }
745 
746     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
747         
748         uint256 feeApplicable = pair == recipient ? totalFeeIfSelling : totalFee;
749         uint256 feeAmount = amount.mul(feeApplicable).div(100);
750 
751         _balances[address(this)] = _balances[address(this)].add(feeAmount);
752         emit Transfer(sender, address(this), feeAmount);
753 
754         return amount.sub(feeAmount);
755     }
756 
757     function tradingStatus(bool newStatus) public onlyOwner {
758         tradingOpen = newStatus;
759 		if(tradingOpen){
760 			launchedAt = block.number;
761 		}
762     }
763 
764     function swapBack() internal lockTheSwap {
765         
766         uint256 tokenToSwap = _balances[address(this)];
767         uint256 amountToLiquify = tokenToSwap.mul(liquidityFee).div(totalFee).div(2);
768         uint256 amountToSwap = tokenToSwap.sub(amountToLiquify);
769 
770         address[] memory path = new address[](2);
771         path[0] = address(this);
772         path[1] = router.WETH();
773 
774         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
775             amountToSwap,
776             0,
777             path,
778             address(this),
779             block.timestamp
780         );
781 
782         uint256 amountETH = address(this).balance;
783 
784         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
785         
786         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
787         uint256 amountETHReflection = amountETH.mul(rewardsFee).div(totalETHFee);
788 		uint256 amountETHMarking = amountETH.sub(amountETHReflection).sub(amountETHLiquidity);
789 
790         try dividendDistributor.deposit{value: amountETHReflection}() {} catch {}
791         
792         if(amountToLiquify > 0){
793             router.addLiquidityETH{value: amountETHLiquidity}(
794                 address(this),
795                 amountToLiquify,
796                 0,
797                 0,
798                 autoLiquidityReceiver,
799                 block.timestamp
800             );
801             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
802         }
803 		
804 		if( amountETHMarking > 0){
805 			TransferHelper.safeTransferETH(marketingAddress, amountETHMarking);
806 		}
807     }
808 
809     event AutoLiquify(uint256 amountETH, uint256 amountMETA);
810 
811 }