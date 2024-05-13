1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.4;
4 pragma experimental ABIEncoderV2;
5 
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 import "@openzeppelin/contracts/math/SafeMath.sol";
8 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
9 import "@openzeppelin/contracts/access/Ownable.sol";
10 import "../libraries/DecimalMath.sol";
11 
12 contract vBABYToken is Ownable {
13     using SafeMath for uint256;
14     using SafeERC20 for IERC20;
15 
16     // ============ Storage(ERC20) ============
17 
18     string public name = "vBABY Membership Token";
19     string public symbol = "vBABY";
20     uint8 public decimals = 18;
21 
22     mapping(address => mapping(address => uint256)) internal _allowed;
23 
24     // ============ Storage ============
25 
26     address public _babyToken;
27     address public _babyTeam;
28     address public _babyReserve;
29     address public _babyTreasury;
30     bool public _canTransfer;
31     address public constant hole = 0x000000000000000000000000000000000000dEaD;
32 
33     // staking reward parameters
34     uint256 public _babyPerBlock;
35     uint256 public constant _superiorRatio = 10**17; // 0.1
36     uint256 public constant _babyRatio = 100; // 100
37     uint256 public _babyFeeBurnRatio = 30 * 10**16; //30%
38     uint256 public _babyFeeReserveRatio = 20 * 10**16; //20%
39     uint256 public _feeRatio = 10 * 10**16; //10%;
40     // accounting
41     uint112 public alpha = 10**18; // 1
42     uint112 public _totalBlockDistribution;
43     uint32 public _lastRewardBlock;
44 
45     uint256 public _totalBlockReward;
46     uint256 public _totalStakingPower;
47     mapping(address => UserInfo) public userInfo;
48 
49     uint256 public _superiorMinBABY = 1000e18; //The superior must obtain the min BABY that should be pledged for invitation rewards
50 
51     struct UserInfo {
52         uint128 stakingPower;
53         uint128 superiorSP;
54         address superior;
55         uint256 credit;
56         uint256 creditDebt;
57     }
58 
59     // ============ Events ============
60 
61     event MintVBABY(
62         address user,
63         address superior,
64         uint256 mintBABY,
65         uint256 totalStakingPower
66     );
67     event RedeemVBABY(
68         address user,
69         uint256 receiveBABY,
70         uint256 burnBABY,
71         uint256 feeBABY,
72         uint256 reserveBABY,
73         uint256 totalStakingPower
74     );
75     event DonateBABY(address user, uint256 donateBABY);
76     event SetCanTransfer(bool allowed);
77 
78     event PreDeposit(uint256 babyAmount);
79     event ChangePerReward(uint256 babyPerBlock);
80     event UpdateBABYFeeBurnRatio(uint256 babyFeeBurnRatio);
81 
82     event Transfer(address indexed from, address indexed to, uint256 amount);
83     event Approval(
84         address indexed owner,
85         address indexed spender,
86         uint256 amount
87     );
88 
89     // ============ Modifiers ============
90 
91     modifier canTransfer() {
92         require(_canTransfer, "vBABYToken: not allowed transfer");
93         _;
94     }
95 
96     modifier balanceEnough(address account, uint256 amount) {
97         require(
98             availableBalanceOf(account) >= amount,
99             "vBABYToken: available amount not enough"
100         );
101         _;
102     }
103 
104     event TokenInfo(uint256 babyTokenSupply, uint256 babyBalanceInVBaby);
105     event CurrentUserInfo(
106         address user,
107         uint128 stakingPower,
108         uint128 superiorSP,
109         address superior,
110         uint256 credit,
111         uint256 creditDebt
112     );
113 
114     function logTokenInfo(IERC20 token) internal {
115         emit TokenInfo(token.totalSupply(), token.balanceOf(address(this)));
116     }
117 
118     function logCurrentUserInfo(address user) internal {
119         UserInfo storage currentUser = userInfo[user];
120         emit CurrentUserInfo(
121             user,
122             currentUser.stakingPower,
123             currentUser.superiorSP,
124             currentUser.superior,
125             currentUser.credit,
126             currentUser.creditDebt
127         );
128     }
129 
130     // ============ Constructor ============
131 
132     constructor(
133         address babyToken,
134         address babyTeam,
135         address babyReserve,
136         address babyTreasury
137     ) {
138         _babyToken = babyToken;
139         _babyTeam = babyTeam;
140         _babyReserve = babyReserve;
141         _babyTreasury = babyTreasury;
142         changePerReward(2 * 10**18);
143     }
144 
145     // ============ Ownable Functions ============`
146 
147     function setCanTransfer(bool allowed) public onlyOwner {
148         _canTransfer = allowed;
149         emit SetCanTransfer(allowed);
150     }
151 
152     function changePerReward(uint256 babyPerBlock) public onlyOwner {
153         _updateAlpha();
154         _babyPerBlock = babyPerBlock;
155         logTokenInfo(IERC20(_babyToken));
156         emit ChangePerReward(babyPerBlock);
157     }
158 
159     function updateBABYFeeBurnRatio(uint256 babyFeeBurnRatio) public onlyOwner {
160         _babyFeeBurnRatio = babyFeeBurnRatio;
161         emit UpdateBABYFeeBurnRatio(_babyFeeBurnRatio);
162     }
163 
164     function updateBABYFeeReserveRatio(uint256 babyFeeReserve)
165         public
166         onlyOwner
167     {
168         _babyFeeReserveRatio = babyFeeReserve;
169     }
170 
171     function updateTeamAddress(address team) public onlyOwner {
172         _babyTeam = team;
173     }
174 
175     function updateTreasuryAddress(address treasury) public onlyOwner {
176         _babyTreasury = treasury;
177     }
178 
179     function updateReserveAddress(address newAddress) public onlyOwner {
180         _babyReserve = newAddress;
181     }
182 
183     function setSuperiorMinBABY(uint256 val) public onlyOwner {
184         _superiorMinBABY = val;
185     }
186 
187     function emergencyWithdraw() public onlyOwner {
188         uint256 babyBalance = IERC20(_babyToken).balanceOf(address(this));
189         IERC20(_babyToken).safeTransfer(owner(), babyBalance);
190     }
191 
192     // ============ Mint & Redeem & Donate ============
193 
194     function mint(uint256 babyAmount, address superiorAddress) public {
195         require(
196             superiorAddress != address(0) && superiorAddress != msg.sender,
197             "vBABYToken: Superior INVALID"
198         );
199         require(babyAmount >= 1e18, "vBABYToken: must mint greater than 1");
200 
201         UserInfo storage user = userInfo[msg.sender];
202 
203         if (user.superior == address(0)) {
204             require(
205                 superiorAddress == _babyTeam ||
206                     userInfo[superiorAddress].superior != address(0),
207                 "vBABYToken: INVALID_SUPERIOR_ADDRESS"
208             );
209             user.superior = superiorAddress;
210         }
211 
212         if (_superiorMinBABY > 0) {
213             uint256 curBABY = babyBalanceOf(user.superior);
214             if (curBABY < _superiorMinBABY) {
215                 user.superior = _babyTeam;
216             }
217         }
218 
219         _updateAlpha();
220 
221         IERC20(_babyToken).safeTransferFrom(
222             msg.sender,
223             address(this),
224             babyAmount
225         );
226 
227         uint256 newStakingPower = DecimalMath.divFloor(babyAmount, alpha);
228 
229         _mint(user, newStakingPower);
230 
231         logTokenInfo(IERC20(_babyToken));
232         logCurrentUserInfo(msg.sender);
233         logCurrentUserInfo(user.superior);
234         emit MintVBABY(
235             msg.sender,
236             superiorAddress,
237             babyAmount,
238             _totalStakingPower
239         );
240     }
241 
242     function redeem(uint256 vBabyAmount, bool all)
243         public
244         balanceEnough(msg.sender, vBabyAmount)
245     {
246         _updateAlpha();
247         UserInfo storage user = userInfo[msg.sender];
248 
249         uint256 babyAmount;
250         uint256 stakingPower;
251 
252         if (all) {
253             stakingPower = uint256(user.stakingPower).sub(
254                 DecimalMath.divFloor(user.credit, alpha)
255             );
256             babyAmount = DecimalMath.mulFloor(stakingPower, alpha);
257         } else {
258             babyAmount = vBabyAmount.mul(_babyRatio);
259             stakingPower = DecimalMath.divFloor(babyAmount, alpha);
260         }
261 
262         _redeem(user, stakingPower);
263 
264         (
265             uint256 babyReceive,
266             uint256 burnBabyAmount,
267             uint256 withdrawFeeAmount,
268             uint256 reserveAmount
269         ) = getWithdrawResult(babyAmount);
270 
271         IERC20(_babyToken).safeTransfer(msg.sender, babyReceive);
272 
273         if (burnBabyAmount > 0) {
274             IERC20(_babyToken).safeTransfer(hole, burnBabyAmount);
275         }
276         if (reserveAmount > 0) {
277             IERC20(_babyToken).safeTransfer(_babyReserve, reserveAmount);
278         }
279 
280         if (withdrawFeeAmount > 0) {
281             alpha = uint112(
282                 uint256(alpha).add(
283                     DecimalMath.divFloor(withdrawFeeAmount, _totalStakingPower)
284                 )
285             );
286         }
287 
288         logTokenInfo(IERC20(_babyToken));
289         logCurrentUserInfo(msg.sender);
290         logCurrentUserInfo(user.superior);
291         emit RedeemVBABY(
292             msg.sender,
293             babyReceive,
294             burnBabyAmount,
295             withdrawFeeAmount,
296             reserveAmount,
297             _totalStakingPower
298         );
299     }
300 
301     function donate(uint256 babyAmount) public {
302         IERC20(_babyToken).safeTransferFrom(
303             msg.sender,
304             address(this),
305             babyAmount
306         );
307 
308         alpha = uint112(
309             uint256(alpha).add(
310                 DecimalMath.divFloor(babyAmount, _totalStakingPower)
311             )
312         );
313         logTokenInfo(IERC20(_babyToken));
314         emit DonateBABY(msg.sender, babyAmount);
315     }
316 
317     function totalSupply() public view returns (uint256 vBabySupply) {
318         uint256 totalBaby = IERC20(_babyToken).balanceOf(address(this));
319         (, uint256 curDistribution) = getLatestAlpha();
320 
321         uint256 actualBaby = totalBaby.add(curDistribution);
322         vBabySupply = actualBaby / _babyRatio;
323     }
324 
325     function balanceOf(address account)
326         public
327         view
328         returns (uint256 vBabyAmount)
329     {
330         vBabyAmount = babyBalanceOf(account) / _babyRatio;
331     }
332 
333     function transfer(address to, uint256 vBabyAmount) public returns (bool) {
334         _updateAlpha();
335         _transfer(msg.sender, to, vBabyAmount);
336         return true;
337     }
338 
339     function approve(address spender, uint256 vBabyAmount)
340         public
341         canTransfer
342         returns (bool)
343     {
344         _allowed[msg.sender][spender] = vBabyAmount;
345         emit Approval(msg.sender, spender, vBabyAmount);
346         return true;
347     }
348 
349     function transferFrom(
350         address from,
351         address to,
352         uint256 vBabyAmount
353     ) public returns (bool) {
354         require(
355             vBabyAmount <= _allowed[from][msg.sender],
356             "ALLOWANCE_NOT_ENOUGH"
357         );
358         _updateAlpha();
359         _transfer(from, to, vBabyAmount);
360         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(
361             vBabyAmount
362         );
363         return true;
364     }
365 
366     function allowance(address owner, address spender)
367         public
368         view
369         returns (uint256)
370     {
371         return _allowed[owner][spender];
372     }
373 
374     // ============ Helper Functions ============
375 
376     function getLatestAlpha()
377         public
378         view
379         returns (uint256 newAlpha, uint256 curDistribution)
380     {
381         if (_lastRewardBlock == 0) {
382             curDistribution = 0;
383         } else {
384             curDistribution = _babyPerBlock * (block.number - _lastRewardBlock);
385         }
386         if (_totalStakingPower > 0) {
387             newAlpha = uint256(alpha).add(
388                 DecimalMath.divFloor(curDistribution, _totalStakingPower)
389             );
390         } else {
391             newAlpha = alpha;
392         }
393     }
394 
395     function availableBalanceOf(address account)
396         public
397         view
398         returns (uint256 vBabyAmount)
399     {
400         vBabyAmount = balanceOf(account);
401     }
402 
403     function babyBalanceOf(address account)
404         public
405         view
406         returns (uint256 babyAmount)
407     {
408         UserInfo memory user = userInfo[account];
409         (uint256 newAlpha, ) = getLatestAlpha();
410         uint256 nominalBaby = DecimalMath.mulFloor(
411             uint256(user.stakingPower),
412             newAlpha
413         );
414         if (nominalBaby > user.credit) {
415             babyAmount = nominalBaby - user.credit;
416         } else {
417             babyAmount = 0;
418         }
419     }
420 
421     function getWithdrawResult(uint256 babyAmount)
422         public
423         view
424         returns (
425             uint256 babyReceive,
426             uint256 burnBabyAmount,
427             uint256 withdrawFeeBabyAmount,
428             uint256 reserveBabyAmount
429         )
430     {
431         uint256 feeRatio = _feeRatio;
432 
433         withdrawFeeBabyAmount = DecimalMath.mulFloor(babyAmount, feeRatio);
434         babyReceive = babyAmount.sub(withdrawFeeBabyAmount);
435 
436         burnBabyAmount = DecimalMath.mulFloor(
437             withdrawFeeBabyAmount,
438             _babyFeeBurnRatio
439         );
440         reserveBabyAmount = DecimalMath.mulFloor(
441             withdrawFeeBabyAmount,
442             _babyFeeReserveRatio
443         );
444 
445         withdrawFeeBabyAmount = withdrawFeeBabyAmount.sub(burnBabyAmount);
446         withdrawFeeBabyAmount = withdrawFeeBabyAmount.sub(reserveBabyAmount);
447     }
448 
449     function setRatioValue(uint256 ratioFee) public onlyOwner {
450         _feeRatio = ratioFee;
451     }
452 
453     function getSuperior(address account)
454         public
455         view
456         returns (address superior)
457     {
458         return userInfo[account].superior;
459     }
460 
461     // ============ Internal Functions ============
462 
463     function _updateAlpha() internal {
464         (uint256 newAlpha, uint256 curDistribution) = getLatestAlpha();
465         uint256 newTotalDistribution = curDistribution.add(
466             _totalBlockDistribution
467         );
468         require(
469             newAlpha <= uint112(-1) && newTotalDistribution <= uint112(-1),
470             "OVERFLOW"
471         );
472         alpha = uint112(newAlpha);
473         _totalBlockDistribution = uint112(newTotalDistribution);
474         _lastRewardBlock = uint32(block.number);
475 
476         if (curDistribution > 0) {
477             IERC20(_babyToken).safeTransferFrom(
478                 _babyTreasury,
479                 address(this),
480                 curDistribution
481             );
482 
483             _totalBlockReward = _totalBlockReward.add(curDistribution);
484             logTokenInfo(IERC20(_babyToken));
485             emit PreDeposit(curDistribution);
486         }
487     }
488 
489     function _mint(UserInfo storage to, uint256 stakingPower) internal {
490         require(stakingPower <= uint128(-1), "OVERFLOW");
491         UserInfo storage superior = userInfo[to.superior];
492         uint256 superiorIncreSP = DecimalMath.mulFloor(
493             stakingPower,
494             _superiorRatio
495         );
496         uint256 superiorIncreCredit = DecimalMath.mulFloor(
497             superiorIncreSP,
498             alpha
499         );
500 
501         to.stakingPower = uint128(uint256(to.stakingPower).add(stakingPower));
502         to.superiorSP = uint128(uint256(to.superiorSP).add(superiorIncreSP));
503 
504         superior.stakingPower = uint128(
505             uint256(superior.stakingPower).add(superiorIncreSP)
506         );
507         superior.credit = uint128(
508             uint256(superior.credit).add(superiorIncreCredit)
509         );
510 
511         _totalStakingPower = _totalStakingPower.add(stakingPower).add(
512             superiorIncreSP
513         );
514     }
515 
516     function _redeem(UserInfo storage from, uint256 stakingPower) internal {
517         from.stakingPower = uint128(
518             uint256(from.stakingPower).sub(stakingPower)
519         );
520 
521         uint256 userCreditSP = DecimalMath.divFloor(from.credit, alpha);
522         if (from.stakingPower > userCreditSP) {
523             from.stakingPower = uint128(
524                 uint256(from.stakingPower).sub(userCreditSP)
525             );
526         } else {
527             userCreditSP = from.stakingPower;
528             from.stakingPower = 0;
529         }
530         from.creditDebt = from.creditDebt.add(from.credit);
531         from.credit = 0;
532 
533         // superior decrease sp = min(stakingPower*0.1, from.superiorSP)
534         uint256 superiorDecreSP = DecimalMath.mulFloor(
535             stakingPower,
536             _superiorRatio
537         );
538         superiorDecreSP = from.superiorSP <= superiorDecreSP
539             ? from.superiorSP
540             : superiorDecreSP;
541         from.superiorSP = uint128(
542             uint256(from.superiorSP).sub(superiorDecreSP)
543         );
544         uint256 superiorDecreCredit = DecimalMath.mulFloor(
545             superiorDecreSP,
546             alpha
547         );
548 
549         UserInfo storage superior = userInfo[from.superior];
550         if (superiorDecreCredit > superior.creditDebt) {
551             uint256 dec = DecimalMath.divFloor(superior.creditDebt, alpha);
552             superiorDecreSP = dec >= superiorDecreSP
553                 ? 0
554                 : superiorDecreSP.sub(dec);
555             superiorDecreCredit = superiorDecreCredit.sub(superior.creditDebt);
556             superior.creditDebt = 0;
557         } else {
558             superior.creditDebt = superior.creditDebt.sub(superiorDecreCredit);
559             superiorDecreCredit = 0;
560             superiorDecreSP = 0;
561         }
562         uint256 creditSP = DecimalMath.divFloor(superior.credit, alpha);
563 
564         if (superiorDecreSP >= creditSP) {
565             superior.credit = 0;
566             superior.stakingPower = uint128(
567                 uint256(superior.stakingPower).sub(creditSP)
568             );
569         } else {
570             superior.credit = uint128(
571                 uint256(superior.credit).sub(superiorDecreCredit)
572             );
573             superior.stakingPower = uint128(
574                 uint256(superior.stakingPower).sub(superiorDecreSP)
575             );
576         }
577 
578         _totalStakingPower = _totalStakingPower
579             .sub(stakingPower)
580             .sub(superiorDecreSP)
581             .sub(userCreditSP);
582     }
583 
584     function _transfer(
585         address from,
586         address to,
587         uint256 vBabyAmount
588     ) internal canTransfer balanceEnough(from, vBabyAmount) {
589         require(from != address(0), "transfer from the zero address");
590         require(to != address(0), "transfer to the zero address");
591         require(from != to, "transfer from same with to");
592 
593         uint256 stakingPower = DecimalMath.divFloor(
594             vBabyAmount * _babyRatio,
595             alpha
596         );
597 
598         UserInfo storage fromUser = userInfo[from];
599         UserInfo storage toUser = userInfo[to];
600 
601         _redeem(fromUser, stakingPower);
602         _mint(toUser, stakingPower);
603 
604         logTokenInfo(IERC20(_babyToken));
605         logCurrentUserInfo(from);
606         logCurrentUserInfo(fromUser.superior);
607         logCurrentUserInfo(to);
608         logCurrentUserInfo(toUser.superior);
609         emit Transfer(from, to, vBabyAmount);
610     }
611 }
