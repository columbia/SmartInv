1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.19;
4 
5 interface IERC20 {
6     function decimals() external view returns (uint8);
7 
8     function symbol() external view returns (string memory);
9 
10     function name() external view returns (string memory);
11 
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount) external returns (bool);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     function approve(address spender, uint256 amount) external returns (bool);
21 
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 abstract contract Ownable {
29     address private _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     constructor () {
34         address msgSender = msg.sender;
35         _owner = msgSender;
36         emit OwnershipTransferred(address(0), msgSender);
37     }
38 
39     function owner() public view returns (address) {
40         return _owner;
41     }
42 
43     modifier onlyOwner() {
44         require(_owner == msg.sender, "!o");
45         _;
46     }
47 
48     function renounceOwnership() public virtual onlyOwner {
49         emit OwnershipTransferred(_owner, address(0));
50         _owner = address(0);
51     }
52 
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(newOwner != address(0), "n0");
55         emit OwnershipTransferred(_owner, newOwner);
56         _owner = newOwner;
57     }
58 }
59 
60 interface ISwapPair {
61     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
62 }
63 
64 interface INFT {
65     function balanceOf(address owner) external view returns (uint256 balance);
66 
67     function mint(address to) external;
68 }
69 
70 abstract contract AbsPool is Ownable {
71     struct UserInfo {
72         bool isActive;
73         uint256 amount;
74         uint256 rewardMintDebt;
75         uint256 calMintReward;
76         uint256 teamNum;
77         bool claimNFT;
78         uint256 inviteReward;
79     }
80 
81     struct PoolInfo {
82         uint256 totalAmount;
83         uint256 accMintPerShare;
84         uint256 accMintReward;
85         uint256 mintPerBlock;
86         uint256 lastMintBlock;
87         uint256 totalMintReward;
88     }
89 
90     PoolInfo private poolInfo;
91     mapping(address => UserInfo) private userInfo;
92 
93     address private _lpToken;
94     string private _lpTokenSymbol;
95     address private _mintRewardToken;
96 
97     mapping(address => address) public _invitor;
98     mapping(address => address[]) public _binder;
99     uint256 public _inviteFee = 1000;
100     address public _defaultInvitor;
101 
102     address public immutable _weth;
103     address public immutable _usdt;
104     ISwapPair public immutable _wethUsdtPair;
105     INFT public _nft;
106 
107     constructor(
108         address LPToken, string memory LPTokenSymbol,
109         address MintRewardToken, address DefaultInvitor,
110         address MinterToken, address NFTAddress,
111         address WETH, address USDT, address WETHUSDTPair
112     ){
113         _lpToken = LPToken;
114         _lpTokenSymbol = LPTokenSymbol;
115         _mintRewardToken = MintRewardToken;
116         poolInfo.lastMintBlock = block.number;
117         _defaultInvitor = DefaultInvitor;
118         userInfo[DefaultInvitor].isActive = true;
119 
120         _minterToken = MinterToken;
121         _minterTokenUnit = 10 ** IERC20(MinterToken).decimals();
122         _minterRewardPerAmountPerDay = 42 * 10 ** IERC20(MintRewardToken).decimals() / 100;
123         _nft = INFT(NFTAddress);
124 
125         _weth = WETH;
126         _usdt = USDT;
127         _wethUsdtPair = ISwapPair(WETHUSDTPair);
128         require(IERC20(WETH).balanceOf(WETHUSDTPair) > 0 && IERC20(USDT).balanceOf(WETHUSDTPair) > 0, "weth-usdt");
129         _claimNFTLPUCondition = 20000 * 10 ** IERC20(USDT).decimals();
130 
131         poolInfo.totalMintReward = 210000000000000000000000;
132     }
133 
134     receive() external payable {}
135 
136     function deposit(uint256 amount, address invitor) external {
137         require(amount > 0, "=0");
138         address account = msg.sender;
139         _checkInvitor(account, invitor);
140 
141         UserInfo storage user = userInfo[account];
142         _calReward(user);
143 
144         _takeToken(_lpToken, account, address(this), amount);
145 
146         user.amount += amount;
147         poolInfo.totalAmount += amount;
148 
149         user.rewardMintDebt = user.amount * poolInfo.accMintPerShare / 1e18;
150     }
151 
152     function _checkInvitor(address account, address invitor) private {
153         UserInfo storage user = userInfo[account];
154         uint256 inviteLen = _teamLength;
155         address current = account;
156         if (!user.isActive) {
157             require(userInfo[invitor].isActive, "!Active");
158             _invitor[account] = invitor;
159             _binder[invitor].push(account);
160             for (uint256 i; i < inviteLen;) {
161                 invitor = _invitor[current];
162                 if (address(0) == invitor) {
163                     break;
164                 }
165                 userInfo[invitor].teamNum += 1;
166                 current = invitor;
167             unchecked{
168                 ++i;
169             }
170             }
171             user.isActive = true;
172         }
173     }
174 
175     function withdraw() public {
176         address account = msg.sender;
177         UserInfo storage user = userInfo[account];
178         _calReward(user);
179 
180         uint256 amount = user.amount;
181         _giveToken(_lpToken, account, amount);
182 
183         user.amount -= amount;
184         poolInfo.totalAmount -= amount;
185 
186         user.rewardMintDebt = user.amount * poolInfo.accMintPerShare / 1e18;
187     }
188 
189     function claim() public {
190         address account = msg.sender;
191         UserInfo storage user = userInfo[account];
192         _calReward(user);
193         uint256 pendingMint = user.calMintReward;
194         if (pendingMint > 0) {
195             address mintRewardToken = _mintRewardToken;
196             address invitor = _invitor[account];
197             if (address(0) != invitor) {
198                 uint256 inviteAmount = pendingMint * _inviteFee / 10000;
199                 if (inviteAmount > 0) {
200                     pendingMint -= inviteAmount;
201                     _giveToken(mintRewardToken, invitor, inviteAmount);
202                     userInfo[invitor].inviteReward += inviteAmount;
203                 }
204             }
205             _giveToken(mintRewardToken, account, pendingMint);
206             user.calMintReward = 0;
207         }
208     }
209 
210     function _updatePool() private {
211         PoolInfo storage pool = poolInfo;
212         uint256 blockNum = block.number;
213         uint256 lastRewardBlock = pool.lastMintBlock;
214         if (blockNum <= lastRewardBlock) {
215             return;
216         }
217         pool.lastMintBlock = blockNum;
218 
219         uint256 accReward = pool.accMintReward;
220         uint256 totalReward = pool.totalMintReward;
221         if (accReward >= totalReward) {
222             return;
223         }
224 
225         uint256 totalAmount = pool.totalAmount;
226         uint256 rewardPerBlock = pool.mintPerBlock;
227         if (0 < totalAmount && 0 < rewardPerBlock) {
228             uint256 reward = rewardPerBlock * (blockNum - lastRewardBlock);
229             uint256 remainReward = totalReward - accReward;
230             if (reward > remainReward) {
231                 reward = remainReward;
232             }
233             pool.accMintPerShare += reward * 1e18 / totalAmount;
234             pool.accMintReward += reward;
235         }
236     }
237 
238     function _calReward(UserInfo storage user) private {
239         _updatePool();
240         if (user.amount > 0) {
241             uint256 accMintReward = user.amount * poolInfo.accMintPerShare / 1e18;
242             uint256 pendingMintAmount = accMintReward - user.rewardMintDebt;
243             if (pendingMintAmount > 0) {
244                 user.rewardMintDebt = accMintReward;
245                 user.calMintReward += pendingMintAmount;
246             }
247         }
248     }
249 
250     function _calPendingMintReward(address account) private view returns (uint256 reward) {
251         reward = 0;
252         PoolInfo storage pool = poolInfo;
253         UserInfo storage user = userInfo[account];
254         if (user.amount > 0) {
255             uint256 poolPendingReward;
256             uint256 blockNum = block.number;
257             uint256 lastRewardBlock = pool.lastMintBlock;
258             if (blockNum > lastRewardBlock) {
259                 poolPendingReward = pool.mintPerBlock * (blockNum - lastRewardBlock);
260                 uint256 totalReward = pool.totalMintReward;
261                 uint256 accReward = pool.accMintReward;
262                 uint256 remainReward;
263                 if (totalReward > accReward) {
264                     remainReward = totalReward - accReward;
265                 }
266                 if (poolPendingReward > remainReward) {
267                     poolPendingReward = remainReward;
268                 }
269             }
270             reward = user.amount * (pool.accMintPerShare + poolPendingReward * 1e18 / pool.totalAmount) / 1e18 - user.rewardMintDebt;
271         }
272     }
273 
274     function getLPPoolInfo() public view returns (
275         uint256 totalAmount,
276         uint256 accMintPerShare, uint256 accMintReward,
277         uint256 mintPerBlock, uint256 lastMintBlock, uint256 totalMintReward
278     ) {
279         totalAmount = poolInfo.totalAmount;
280         accMintPerShare = poolInfo.accMintPerShare;
281         accMintReward = poolInfo.accMintReward;
282         mintPerBlock = poolInfo.mintPerBlock;
283         lastMintBlock = poolInfo.lastMintBlock;
284         totalMintReward = poolInfo.totalMintReward;
285     }
286 
287     function getPoolInfo() public view returns (
288         uint256 totalLPAmount,
289         uint256 totalLP,
290         uint256 totalLPUValue,
291         uint256 minterRewardPerAmountPerDay,
292         uint256 minterTotalAmount,
293         uint256 minterActiveAmount,
294         uint256 claimNFTMinterTeamCondition,
295         uint256 claimNFTLPUCondition,
296         uint256 totalMinterReward,
297         uint256 totalMinterInviteReward
298     ){
299         totalLPAmount = poolInfo.totalAmount;
300         (totalLP, totalLPUValue) = getLPInfo();
301         minterRewardPerAmountPerDay = _minterRewardPerAmountPerDay;
302         minterTotalAmount = _minterTotalAmount;
303         minterActiveAmount = _minterActiveAmount;
304         claimNFTMinterTeamCondition = _claimNFTMinterTeamCondition;
305         claimNFTLPUCondition = _claimNFTLPUCondition;
306         totalMinterReward = _totalMinterReward;
307         totalMinterInviteReward = _totalMinterInviteReward;
308     }
309 
310     function getUserInfo(address account) public view returns (
311         bool isActive,
312         uint256 amount, uint256 lpBalance, uint256 lpAllowance,
313         uint256 pendingMintReward, uint256 inviteReward,
314         uint256 teamNum, bool claimedNFT
315     ) {
316         UserInfo storage user = userInfo[account];
317         isActive = user.isActive;
318         amount = user.amount;
319         lpBalance = IERC20(_lpToken).balanceOf(account);
320         lpAllowance = IERC20(_lpToken).allowance(account, address(this));
321         pendingMintReward = _calPendingMintReward(account) + user.calMintReward;
322         inviteReward = user.inviteReward;
323         teamNum = user.teamNum;
324         claimedNFT = user.claimNFT;
325     }
326 
327     function getUserExtInfo(address account) public view returns (
328         uint256 calMintReward, uint256 rewardMintDebt
329     ) {
330         UserInfo storage user = userInfo[account];
331         calMintReward = user.calMintReward;
332         rewardMintDebt = user.rewardMintDebt;
333     }
334 
335     function getUserTeamInfo(address account) public view returns (
336         uint256 amount, uint256 teamAmount
337     ) {
338         amount = userInfo[account].amount;
339         teamAmount = _minterInfos[account].minterTeamAmount;
340     }
341 
342     function getBaseInfo() external view returns (
343         address lpToken,
344         uint256 lpTokenDecimals,
345         string memory lpTokenSymbol,
346         address mintRewardToken,
347         uint256 mintRewardTokenDecimals,
348         string memory mintRewardTokenSymbol,
349         address minterToken,
350         uint256 minterTokenDecimals,
351         string memory minterTokenSymbol
352     ){
353         lpToken = _lpToken;
354         lpTokenDecimals = IERC20(lpToken).decimals();
355         lpTokenSymbol = _lpTokenSymbol;
356         mintRewardToken = _mintRewardToken;
357         mintRewardTokenDecimals = IERC20(mintRewardToken).decimals();
358         mintRewardTokenSymbol = IERC20(mintRewardToken).symbol();
359         minterToken = _minterToken;
360         minterTokenDecimals = IERC20(minterToken).decimals();
361         minterTokenSymbol = IERC20(minterToken).symbol();
362     }
363 
364     function getBinderLength(address account) public view returns (uint256){
365         return _binder[account].length;
366     }
367 
368     function setLPToken(address lpToken, string memory lpSymbol) external onlyOwner {
369         require(poolInfo.totalAmount == 0, "started");
370         _lpToken = lpToken;
371         _lpTokenSymbol = lpSymbol;
372     }
373 
374     function setMintRewardToken(address rewardToken) external onlyOwner {
375         _mintRewardToken = rewardToken;
376     }
377 
378     function setMintPerBlock(uint256 mintPerBlock) external onlyOwner {
379         _updatePool();
380         poolInfo.mintPerBlock = mintPerBlock;
381     }
382 
383     function setTotalMintReward(uint256 totalReward) external onlyOwner {
384         _updatePool();
385         poolInfo.totalMintReward = totalReward;
386     }
387 
388     function setInviteFee(uint256 fee) external onlyOwner {
389         _inviteFee = fee;
390     }
391 
392     function claimBalance(address to, uint256 amount) external onlyOwner {
393         safeTransferETH(to, amount);
394     }
395 
396     function claimToken(address token, address to, uint256 amount) external onlyOwner {
397         if (token == _lpToken) {
398             return;
399         }
400         safeTransfer(token, to, amount);
401     }
402 
403     function safeTransfer(address token, address to, uint value) internal {
404         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
405         if (success && data.length > 0) {
406 
407         }
408     }
409 
410     function safeTransferETH(address to, uint value) internal {
411         (bool success,bytes memory data) = to.call{value : value}(new bytes(0));
412         if (success && data.length > 0) {
413 
414         }
415     }
416 
417     function safeTransferFrom(address token, address from, address to, uint value) internal {
418         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
419         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
420         if (success && data.length > 0) {
421 
422         }
423     }
424 
425     function setDefaultInvitor(address adr) external onlyOwner {
426         _defaultInvitor = adr;
427         userInfo[adr].isActive = true;
428     }
429 
430     struct UserMinterInfo {
431         uint256 minterAmount;
432         uint256 activeRecordIndex;
433         uint256 minterClaimedReward;
434         uint256 minterInviteAmount;
435         uint256 minterTeamAmount;
436     }
437 
438     struct MinterRecord {
439         uint256 minterAmount;
440         uint256 minterStart;
441         uint256 minterEnd;
442         uint256 lastMinterRewardTime;
443         uint256 claimedMinterReward;
444     }
445 
446     mapping(address => UserMinterInfo) private _minterInfos;
447     
448     uint256 public _maxActiveRecordLen = 10;
449 
450     mapping(address => MinterRecord[]) private _minterRecords;
451 
452     uint256 private constant _teamLength = 2;
453     uint256 public _minterInviteFee = 1000;
454     uint256 private constant _feeDivFactor = 10000;
455     address public _minterReceiveAddress = address(0x000000000000000000000000000000000000dEaD);
456 
457     address private _minterToken;
458     uint256 public _minterTokenUnit;
459     uint256 public _minterDuration = 30 days;
460     uint256 private _minterRewardPerAmountPerDay;
461 
462     uint256 private _minterTotalAmount;
463     uint256 private _minterActiveAmount;
464     uint256 private _claimNFTMinterTeamCondition = 5000;
465     uint256 private _claimNFTLPUCondition;
466 
467     uint256 private _totalMinterReward;
468     uint256 private _totalMinterInviteReward;
469     bool public _pauseNFT;
470 
471     //invitor,joiner,index,bool
472     mapping(address => mapping(address => mapping(uint256 => bool))) public _hasCalTeamAmount;
473 
474     function _giveToken(address tokenAddress, address account, uint256 amount) private {
475         if (0 == amount) {
476             return;
477         }
478         IERC20 token = IERC20(tokenAddress);
479         require(token.balanceOf(address(this)) >= amount, "PTNE");
480         safeTransfer(tokenAddress, account, amount);
481     }
482 
483     function _takeToken(address tokenAddress, address from, address to, uint256 tokenNum) private {
484         IERC20 token = IERC20(tokenAddress);
485         require(token.balanceOf(address(from)) >= tokenNum, "TNE");
486         safeTransferFrom(tokenAddress, from, to, tokenNum);
487     }
488 
489     function mint(uint256 amount, address invitor) external {
490         require(amount > 0, "0");
491 
492         address account = msg.sender;
493         _checkInvitor(account, invitor);
494 
495         _claimMinterReward(account);
496 
497         UserMinterInfo storage minterInfo = _minterInfos[account];
498         uint256 userRecordLen = _minterRecords[account].length;
499         require(minterInfo.activeRecordIndex + _maxActiveRecordLen > userRecordLen, "ML");
500         _takeToken(_minterToken, account, _minterReceiveAddress, amount * _minterTokenUnit);
501 
502         uint256 blockTime = block.timestamp;
503         uint256 endTime = blockTime + _minterDuration;
504         _addRecord(account, amount, blockTime, endTime);
505         minterInfo.minterAmount += amount;
506 
507         _minterTotalAmount += amount;
508         _minterActiveAmount += amount;
509 
510         uint256 len = _teamLength;
511         address current = account;
512         UserMinterInfo storage invitorInfo;
513         uint256 claimNFTTeamCondition = _claimNFTMinterTeamCondition;
514         for (uint256 i; i < len;) {
515             if (_minterInfos[current].minterTeamAmount >= claimNFTTeamCondition) {
516                 break;
517             }
518             invitor = _invitor[current];
519             if (address(0) == invitor) {
520                 break;
521             }
522             invitorInfo = _minterInfos[invitor];
523             invitorInfo.minterTeamAmount += amount;
524             _hasCalTeamAmount[invitor][account][userRecordLen] = true;
525             current = invitor;
526         unchecked{
527             ++i;
528         }
529         }
530     }
531 
532     function _addRecord(address account, uint256 amount, uint256 blockTime, uint256 endTime) private {
533         _minterRecords[account].push(
534             MinterRecord(amount, blockTime, endTime, blockTime, 0)
535         );
536     }
537 
538     function claimMinterReward() external {
539         address account = msg.sender;
540         _claimMinterReward(account);
541     }
542     
543     function _claimMinterReward(address account) private {
544         UserMinterInfo storage minterInfo = _minterInfos[account];
545         uint256 recordLen = _minterRecords[account].length;
546         uint256 blockTime = block.timestamp;
547         uint256 activeRecordIndex = minterInfo.activeRecordIndex;
548         MinterRecord storage record;
549         uint256 rewardPerAmountPerDay = _minterRewardPerAmountPerDay;
550         uint256 pendingReward;
551         for (uint256 i = activeRecordIndex; i < recordLen;) {
552             record = _minterRecords[account][i];
553             uint256 lastRewardTime = record.lastMinterRewardTime;
554             uint256 endTime = record.minterEnd;
555             uint256 amount = record.minterAmount;
556             if (lastRewardTime < endTime && lastRewardTime < blockTime) {
557                 if (endTime > blockTime) {
558                     endTime = blockTime;
559                 } else {
560                     activeRecordIndex = i + 1;
561                     _expire(account, i, amount);
562                     minterInfo.minterAmount -= amount;
563                 }
564                 record.lastMinterRewardTime = endTime;
565                 uint256 reward = amount * rewardPerAmountPerDay * (endTime - lastRewardTime) / 1 days;
566                 record.claimedMinterReward += reward;
567                 pendingReward += reward;
568             }
569         unchecked{
570             ++i;
571         }
572         }
573         minterInfo.activeRecordIndex = activeRecordIndex;
574         _giveToken(_mintRewardToken, account, pendingReward);
575         minterInfo.minterClaimedReward += pendingReward;
576         _totalMinterReward += pendingReward;
577         address invitor = _invitor[account];
578         if (address(0) != invitor) {
579             uint256 inviteReward = pendingReward * _minterInviteFee / _feeDivFactor;
580             _giveToken(_mintRewardToken, invitor, inviteReward);
581             _totalMinterInviteReward += inviteReward;
582             _minterInfos[invitor].minterInviteAmount += inviteReward;
583         }
584     }
585 
586     function _expire(address account, uint256 currentRecordIndex, uint256 amount) private {
587         _minterActiveAmount -= amount;
588         uint256 len = _teamLength;
589         address current = account;
590         address invitor;
591         UserMinterInfo storage invitorInfo;
592         for (uint256 i; i < len;) {
593             invitor = _invitor[current];
594             if (address(0) == invitor) {
595                 break;
596             }
597             if (!_hasCalTeamAmount[invitor][account][currentRecordIndex]) {
598                 break;
599             }
600             invitorInfo = _minterInfos[invitor];
601             invitorInfo.minterTeamAmount -= amount;
602             current = invitor;
603         unchecked{
604             ++i;
605         }
606         }
607     }
608 
609     function getRecordLength(address account) public view returns (uint256){
610         return _minterRecords[account].length;
611     }
612 
613     function getRecords(
614         address account,
615         uint256 start,
616         uint256 length
617     ) external view returns (
618         uint256 returnCount,
619         uint256[] memory amount,
620         uint256[] memory startTime,
621         uint256[] memory endTime,
622         uint256[] memory lastRewardTime,
623         uint256[] memory claimedRewards,
624         uint256[] memory totalRewards
625     ){
626         uint256 recordLen = _minterRecords[account].length;
627         if (0 == length) {
628             length = recordLen;
629         }
630         returnCount = length;
631 
632         amount = new uint256[](length);
633         startTime = new uint256[](length);
634         endTime = new uint256[](length);
635         lastRewardTime = new uint256[](length);
636         claimedRewards = new uint256[](length);
637         totalRewards = new uint256[](length);
638         uint256 index = 0;
639         for (uint256 i = start; i < start + length; i++) {
640             if (i >= recordLen) {
641                 return (index, amount, startTime, endTime, lastRewardTime, claimedRewards, totalRewards);
642             }
643             (amount[index], startTime[index], endTime[index], lastRewardTime[index], claimedRewards[index]) = getRecord(account, i);
644             totalRewards[index] = getPendingMinterRecordReward(account, i);
645             index++;
646         }
647     }
648 
649     function getUserMinterInfo(address account) public view returns (
650         uint256 minterAmount,
651         uint256 activeRecordIndex,
652         uint256 minterClaimedReward,
653         uint256 minterInviteAmount,
654         uint256 minterTeamAmount,
655         uint256 minterPendingReward,
656         uint256 minterTokenBalance,
657         uint256 minterTokenAllowance
658     ){
659         UserMinterInfo storage minterInfo = _minterInfos[account];
660         minterAmount = minterInfo.minterAmount;
661         activeRecordIndex = minterInfo.activeRecordIndex;
662         minterClaimedReward = minterInfo.minterClaimedReward;
663         minterInviteAmount = minterInfo.minterInviteAmount;
664         minterTeamAmount = minterInfo.minterTeamAmount;
665         minterPendingReward = getPendingMinterReward(account);
666         minterTokenBalance = IERC20(_minterToken).balanceOf(account);
667         minterTokenAllowance = IERC20(_minterToken).allowance(account, address(this));
668     }
669 
670     function getPendingMinterRecordReward(address account, uint256 i) public view returns (uint256 pendingReward){
671         uint256 blockTime = block.timestamp;
672         MinterRecord storage record = _minterRecords[account][i];
673         uint256 rewardPerAmountPerDay = _minterRewardPerAmountPerDay;
674         uint256 lastRewardTime = record.lastMinterRewardTime;
675         uint256 endTime = record.minterEnd;
676         if (lastRewardTime < endTime && lastRewardTime < blockTime) {
677             if (endTime > blockTime) {
678                 endTime = blockTime;
679             }
680             pendingReward += record.minterAmount * rewardPerAmountPerDay * (endTime - lastRewardTime) / 1 days;
681         }
682     }
683 
684     function getRecord(address account, uint256 i) public view returns (
685         uint256 amount,
686         uint256 startTime,
687         uint256 endTime,
688         uint256 lastRewardTime,
689         uint256 claimedReward
690     ){
691         MinterRecord storage record = _minterRecords[account][i];
692         amount = record.minterAmount;
693         startTime = record.minterStart;
694         endTime = record.minterEnd;
695         lastRewardTime = record.lastMinterRewardTime;
696         claimedReward = record.claimedMinterReward;
697     }
698 
699     function getPendingMinterReward(address account) public view returns (uint256 pendingReward){
700         UserMinterInfo storage minterInfo = _minterInfos[account];
701         uint256 recordLen = _minterRecords[account].length;
702         uint256 blockTime = block.timestamp;
703         uint256 activeRecordIndex = minterInfo.activeRecordIndex;
704         MinterRecord storage record;
705         uint256 rewardPerAmountPerDay = _minterRewardPerAmountPerDay;
706         for (uint256 i = activeRecordIndex; i < recordLen;) {
707             record = _minterRecords[account][i];
708             uint256 lastRewardTime = record.lastMinterRewardTime;
709             uint256 endTime = record.minterEnd;
710             if (lastRewardTime < endTime && lastRewardTime < blockTime) {
711                 if (endTime > blockTime) {
712                     endTime = blockTime;
713                 }
714                 pendingReward += record.minterAmount * rewardPerAmountPerDay * (endTime - lastRewardTime) / 1 days;
715             }
716         unchecked{
717             ++i;
718         }
719         }
720     }
721 
722     function setMinterRewardPerAmountPerDay(uint256 a) public onlyOwner {
723         _minterRewardPerAmountPerDay = a;
724     }
725 
726     function setMinterDuration(uint256 d) public onlyOwner {
727         if (_minterActiveAmount > 0) {
728             require(d > _minterDuration, "longer");
729         }
730         _minterDuration = d;
731     }
732 
733     function setMinterToken(address t) public onlyOwner {
734         _minterToken = t;
735         _minterTokenUnit = 10 ** IERC20(t).decimals();
736     }
737 
738     function setMaxActiveRecordLen(uint256 l) public onlyOwner {
739         _maxActiveRecordLen = l;
740     }
741 
742     function setMinterInviteFee(uint256 f) public onlyOwner {
743         _minterInviteFee = f;
744     }
745 
746     function setMinterReceiveAddress(address r) public onlyOwner {
747         _minterReceiveAddress = r;
748     }
749 
750     function setClaimNFTMinterTeamCondition(uint256 c) public onlyOwner {
751         _claimNFTMinterTeamCondition = c;
752     }
753 
754     function setClaimNFTLPUCondition(uint256 c) public onlyOwner {
755         _claimNFTLPUCondition = c;
756     }
757 
758     function setNFT(address nft) public onlyOwner {
759         _nft = INFT(nft);
760     }
761 
762     function setPauseNFT(bool pause) public onlyOwner {
763         _pauseNFT = pause;
764     }
765 
766     function claimNFT() external {
767         require(!_pauseNFT, "pause");
768         address account = msg.sender;
769         UserInfo storage user = userInfo[account];
770         require(!user.claimNFT, "claimed");
771         require(_minterInfos[account].minterTeamAmount >= _claimNFTMinterTeamCondition && user.amount >= getNFTRewardLPCondition(), "NAC");
772         user.claimNFT = true;
773         _nft.mint(account);
774     }
775 
776     function getNFTRewardLPCondition() public view returns (uint256 lpCondition){
777         (uint256 totalLP,uint256 totalLPValue) = getLPInfo();
778         lpCondition = _claimNFTLPUCondition * totalLP / totalLPValue;
779     }
780 
781     function getLPInfo() public view returns (uint256 totalLP, uint256 totalLPValue){
782         (uint256 rOther,) = __getReserves();
783         (uint256 rEth,uint256 rUsdt) = getETHUSDTReserves();
784         totalLPValue = 2 * rOther * rUsdt / rEth;
785         totalLP = IERC20(_lpToken).totalSupply();
786     }
787 
788     function __getReserves() public view returns (uint256 rOther, uint256 rThis){
789         ISwapPair mainPair = ISwapPair(_lpToken);
790         (uint r0, uint256 r1,) = mainPair.getReserves();
791 
792         if (_weth < _minterToken) {
793             rOther = r0;
794             rThis = r1;
795         } else {
796             rOther = r1;
797             rThis = r0;
798         }
799     }
800 
801     function getETHUSDTReserves() public view returns (uint256 rEth, uint256 rUsdt){
802         (uint r0, uint256 r1,) = _wethUsdtPair.getReserves();
803         if (_weth < _usdt) {
804             rEth = r0;
805             rUsdt = r1;
806         } else {
807             rEth = r1;
808             rUsdt = r0;
809         }
810     }
811 
812     function claimMinter(address account) external {
813         _claimMinterReward(account);
814     }
815 
816     function claimMinters(address[] memory accounts) external {
817         uint256 len = accounts.length;
818         for (uint256 i; i < len;) {
819             _claimMinterReward(accounts[i]);
820         unchecked{
821             ++i;
822         }
823         }
824     }
825 }
826 
827 contract MintPool is AbsPool {
828     constructor() AbsPool(
829     //ZM-ETH-LP
830         address(0x86E6c6Fd93eA7Bb809026dbe7CcaA9f571a6026C),
831         "ZM-ETH-LP",
832     //ETX
833         address(0x469fc807543A766199C07d3a76A3e7A6EC1A2004),
834     //DefaultInvitor
835         address(0x68DAc8c072e3BF0407933984E6DBaD605D3b7874),
836     //ZM
837         address(0xf315EC7B1063E21d5AbaF12cA3470F57AbF47ea5),
838     //NFT
839         address(0x22D21831fA435B9f38E2a67Fe0a4A8CBfEAa1327),
840     //WETH
841         address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2),
842     //USDT
843         address(0xdAC17F958D2ee523a2206206994597C13D831ec7),
844     //eth-usdt-pair
845         address(0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852)
846     ){
847 
848     }
849 }