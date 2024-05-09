1 /**
2  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄ 
3 ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
4 ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌ ▀▀▀▀█░█▀▀▀▀ ▐░▌░▌   ▐░▐░▌ ▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░▌       ▐░▌
5 ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌▐░▌ ▐░▌▐░▌     ▐░▌          ▐░▌     ▐░▌       ▐░▌
6 ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░▌ ▐░▐░▌ ▐░▌     ▐░▌          ▐░▌     ▐░▌       ▐░▌
7 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░▌  ▐░▌  ▐░▌     ▐░▌          ▐░▌     ▐░▌       ▐░▌
8  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░▌   ▀   ▐░▌     ▐░▌          ▐░▌     ▐░▌       ▐░▌
9      ▐░▌     ▐░▌       ▐░▌          ▐░▌▐░▌       ▐░▌     ▐░▌     ▐░▌       ▐░▌     ▐░▌          ▐░▌     ▐░▌       ▐░▌
10      ▐░▌     ▐░▌       ▐░▌ ▄▄▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌ ▄▄▄▄█░█▄▄▄▄ ▐░▌       ▐░▌ ▄▄▄▄█░█▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌
11      ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
12       ▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀ 
13                                                                                                                      
14  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄▄▄▄▄▄▄▄▄▄                                                                   
15 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░▌                                                                  
16 ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░█▀▀▀▀▀▀▀█░▌                                                                 
17 ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌                                                                 
18 ▐░▌ ▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌                                                                 
19 ▐░▌▐░░░░░░░░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌                                                                 
20 ▐░▌ ▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌                                                                 
21 ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌                                                                 
22 ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌                                                                 
23 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌                                                                  
24  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀                                                                   
25                                                                                                                      
26 */
27 
28 // SPDX-License-Identifier: MIT
29 pragma solidity ^0.8.10;
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33 
34     function decimals() external view returns (uint8);
35 
36     function symbol() external view returns (string memory);
37 
38     function name() external view returns (string memory);
39 
40     function balanceOf(address account) external view returns (uint256);
41 
42     function transfer(address recipient, uint256 amount)
43         external
44         returns (bool);
45 
46     function allowance(address _owner, address spender)
47         external
48         view
49         returns (uint256);
50 
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     function transferFrom(
54         address sender,
55         address recipient,
56         uint256 amount
57     ) external returns (bool);
58 
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(
61         address indexed owner,
62         address indexed spender,
63         uint256 value
64     );
65 }
66 
67 interface IDexRouter {
68     function factory() external pure returns (address);
69 
70     function WETH() external pure returns (address);
71 
72     function addLiquidityETH(
73         address token,
74         uint256 amountTokenDesired,
75         uint256 amountTokenMin,
76         uint256 amountETHMin,
77         address to,
78         uint256 deadline
79     )
80         external
81         payable
82         returns (
83             uint256 amountToken,
84             uint256 amountETH,
85             uint256 liquidity
86         );
87 
88     function swapExactETHForTokensSupportingFeeOnTransferTokens(
89         uint256 amountOutMin,
90         address[] calldata path,
91         address to,
92         uint256 deadline
93     ) external payable;
94 
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint256 amountIn,
97         uint256 amountOutMin,
98         address[] calldata path,
99         address to,
100         uint256 deadline
101     ) external;
102 }
103 
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(
118         address indexed previousOwner,
119         address indexed newOwner
120     );
121 
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     function owner() public view virtual returns (address) {
127         return _owner;
128     }
129 
130     modifier onlyOwner() {
131         require(owner() == _msgSender(), "Ownable: caller is not the owner");
132         _;
133     }
134 
135     function renounceOwnership() public virtual onlyOwner {
136         _transferOwnership(address(0));
137     }
138 
139     function transferOwnership(address newOwner) public virtual onlyOwner {
140         require(
141             newOwner != address(0),
142             "Ownable: new owner is the zero address"
143         );
144         _transferOwnership(newOwner);
145     }
146 
147     function _transferOwnership(address newOwner) internal virtual {
148         address oldOwner = _owner;
149         _owner = newOwner;
150         emit OwnershipTransferred(oldOwner, newOwner);
151     }
152 }
153 
154 contract YashimituGold is Ownable {
155     using SafeMath for uint256;
156 
157     address payable public dev;
158     address public token;
159     IDexRouter public router;
160 
161     uint256 public SPOILS_TO_HIRE_WARRIOR = 1728000;
162     uint256 public REFERRAL = 30;
163     uint256 public PERCENTS_DIVIDER = 1000;
164     uint256 public BUYBACK_TAX = 10;
165     uint256 public DEV_TAX_BUY = 40;
166     uint256 public DEV_TAX_SELL = 90;
167     uint256 public MARKET_SPOILS_DIVISOR = 2;
168 
169     uint256 public MIN_DEPOSIT_LIMIT = 0.005 ether;
170     uint256 public MAX_WITHDRAW_LIMIT = 2 ether;
171     uint256[5] public ROI_MAP = [
172         20 ether,
173         40 ether,
174         60 ether,
175         80 ether,
176         100 ether
177     ];
178 
179     uint256 public COMPOUND_BONUS = 5;
180     uint256 public COMPOUND_MAX_TIMES = 10;
181     uint256 public COMPOUND_DURATION = 12 * 60 * 60;
182     uint256 public PROOF_OF_LIFE = 48 * 60 * 60;
183     uint256 public WITHDRAWAL_TAX = 700;
184     uint256 public COMPOUND_FOR_NO_TAX_WITHDRAWAL = 10;
185 
186     uint256 public totalStaked;
187     uint256 public totalSuttles;
188     uint256 public totalDeposits;
189     uint256 public totalCompound;
190     uint256 public totalRefBonus;
191     uint256 public totalWithdrawn;
192     uint256 public whitelisTime = 1672596000;
193     uint256 public publicTime = 1672599600;
194 
195     uint256 public marketSpoils = 144000000000;
196     uint256 PSN = 10000;
197     uint256 PSNH = 5000;
198 
199     bool public whitelistStart;
200     bool public publicStart;
201 
202     struct User {
203         uint256 initialDeposit;
204         uint256 userDeposit;
205         uint256 warriors;
206         uint256 claimedSpoils;
207         uint256 lastHatch;
208         address referrer;
209         uint256 referralsCount;
210         uint256 referralRewards;
211         uint256 totalWithdrawn;
212         uint256 dailyCompoundBonus;
213         uint256 warriorsCompoundCount;
214         uint256 lastWithdrawTime;
215     }
216 
217     mapping(address => User) public users;
218 
219     constructor() {
220         dev = payable(0x5d8BCfEAD5b1d02eeE6129477Df619eAf3939026);
221         router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
222         token = 0xFa548DC8b1ec4De65e36b155F352e33ef6257260;
223     }
224 
225     function isContract(address addr) internal view returns (bool) {
226         uint256 size;
227         assembly {
228             size := extcodesize(addr)
229         }
230         return size > 0;
231     }
232 
233     function startPublicJourney() public onlyOwner {
234         require(!publicStart, "Already started");
235         publicStart = true;
236     }
237 
238     function startWhitelistJourney() public onlyOwner {
239         require(!whitelistStart, "Already started");
240         whitelistStart = true;
241     }
242 
243     function setTimesOfLaunch(uint256 _pub, uint256 _wl) public onlyOwner {
244         publicTime = _pub;
245         whitelisTime = _wl;
246     }
247 
248     function buyMoreWarriors() public {
249         if (whitelistStart) {
250             require(
251                 IERC20(token).balanceOf(msg.sender) > 0,
252                 "Not whitelsited."
253             );
254         } else {
255             require(publicStart, "Contract not yet Started.");
256         }
257         User storage user = users[msg.sender];
258         require(
259             block.timestamp.sub(user.lastHatch) >= COMPOUND_DURATION,
260             "Wait for next compound"
261         );
262         compound(true);
263     }
264 
265     function compound(bool isCompound) internal {
266         User storage user = users[msg.sender];
267 
268         uint256 spoilsUsed = getMySpoils(msg.sender);
269         uint256 spoilsForCompound = spoilsUsed;
270 
271         if (isCompound) {
272             uint256 dailyCompoundBonus = getDailyCompoundBonus(
273                 msg.sender,
274                 spoilsForCompound
275             );
276             spoilsForCompound = spoilsForCompound.add(dailyCompoundBonus);
277             uint256 spoilsUsedValue = calculateSpoilsSell(spoilsForCompound);
278             user.userDeposit = user.userDeposit.add(spoilsUsedValue);
279             totalCompound = totalCompound.add(spoilsUsedValue);
280             if (user.dailyCompoundBonus <= COMPOUND_MAX_TIMES) {
281                 user.dailyCompoundBonus = user.dailyCompoundBonus.add(1);
282             }
283         }
284 
285         //add compoundCount for monitoring purposes.
286         user.warriorsCompoundCount = user.warriorsCompoundCount.add(1);
287         user.warriors = user.warriors.add(
288             spoilsForCompound.div(SPOILS_TO_HIRE_WARRIOR)
289         );
290         totalSuttles = totalSuttles.add(
291             spoilsForCompound.div(SPOILS_TO_HIRE_WARRIOR)
292         );
293         user.claimedSpoils = 0;
294         user.lastHatch = block.timestamp;
295 
296         marketSpoils = marketSpoils.add(spoilsUsed.div(MARKET_SPOILS_DIVISOR));
297     }
298 
299     function sellSpoils() public {
300         if (whitelistStart) {
301             require(
302                 IERC20(token).balanceOf(msg.sender) > 0,
303                 "Not whitelsited."
304             );
305         } else {
306             require(publicStart, "Contract not yet Started.");
307         }
308 
309         User storage user = users[msg.sender];
310         uint256 hasSpoils = getMySpoils(msg.sender);
311         uint256 spoilsValue = calculateSpoilsSell(hasSpoils);
312 
313         /** 
314             if user compound < to mandatory compound days**/
315         if (user.dailyCompoundBonus < COMPOUND_FOR_NO_TAX_WITHDRAWAL) {
316             //daily compound bonus count will not reset and spoilsValue will be deducted with x% feedback tax.
317             spoilsValue = spoilsValue.sub(
318                 spoilsValue.mul(WITHDRAWAL_TAX).div(PERCENTS_DIVIDER)
319             );
320         } else {
321             //set daily compound bonus count to 0 and spoilsValue will remain without deductions
322             user.dailyCompoundBonus = 0;
323             user.warriorsCompoundCount = 0;
324         }
325 
326         user.lastWithdrawTime = block.timestamp;
327         user.claimedSpoils = 0;
328         user.lastHatch = block.timestamp;
329         marketSpoils = marketSpoils.add(hasSpoils.div(MARKET_SPOILS_DIVISOR));
330 
331         // Antiwhale limit
332         if (spoilsValue > MAX_WITHDRAW_LIMIT) {
333             buy(msg.sender, address(0), spoilsValue.sub(MAX_WITHDRAW_LIMIT));
334             spoilsValue = MAX_WITHDRAW_LIMIT;
335         }
336         if (spoilsValue > getBalance()) {
337             buy(msg.sender, address(0), spoilsValue.sub(getBalance()));
338             spoilsValue = getBalance();
339         }
340 
341         uint256 spoilsPayout = spoilsValue.sub(takeFees(spoilsValue, false));
342         payable(msg.sender).transfer(spoilsPayout);
343         user.totalWithdrawn = user.totalWithdrawn.add(spoilsPayout);
344         totalWithdrawn = totalWithdrawn.add(spoilsPayout);
345     }
346 
347     /** Deposit **/
348     function buyWarriors(address ref) public payable {
349         if (whitelistStart) {
350             require(
351                 IERC20(token).balanceOf(msg.sender) > 0,
352                 "Not whitelsited."
353             );
354         } else {
355             require(publicStart, "Contract not yet Started.");
356         }
357         require(msg.value >= MIN_DEPOSIT_LIMIT, "Less than min limit");
358         buy(msg.sender, ref, msg.value);
359     }
360 
361     function buy(
362         address _user,
363         address ref,
364         uint256 amount
365     ) internal {
366         User storage user = users[_user];
367         uint256 spoilsBought = calculateSpoilsBuy(
368             amount,
369             getBalance().sub(amount)
370         );
371         user.userDeposit = user.userDeposit.add(amount);
372         user.initialDeposit = user.initialDeposit.add(amount);
373         user.claimedSpoils = user.claimedSpoils.add(spoilsBought);
374 
375         if (user.referrer == address(0)) {
376             if (ref != _user) {
377                 user.referrer = ref;
378             }
379 
380             address upline1 = user.referrer;
381             if (upline1 != address(0)) {
382                 users[upline1].referralsCount = users[upline1]
383                     .referralsCount
384                     .add(1);
385             }
386         }
387 
388         if (user.referrer != address(0)) {
389             address upline = user.referrer;
390             if (upline != address(0)) {
391                 uint256 refRewards = amount.mul(REFERRAL).div(PERCENTS_DIVIDER);
392                 payable(upline).transfer(refRewards);
393                 users[upline].referralRewards = users[upline]
394                     .referralRewards
395                     .add(refRewards);
396                 totalRefBonus = totalRefBonus.add(refRewards);
397             }
398         }
399 
400         uint256 spoilsPayout = takeFees(amount, true);
401         totalStaked = totalStaked.add(amount.sub(spoilsPayout));
402         totalDeposits = totalDeposits.add(1);
403         compound(false);
404 
405         if (getBalance() < ROI_MAP[0]) {
406             SPOILS_TO_HIRE_WARRIOR = 1728000;
407         } else if (getBalance() >= ROI_MAP[0] && getBalance() < ROI_MAP[1]) {
408             SPOILS_TO_HIRE_WARRIOR = 1584000;
409         } else if (getBalance() >= ROI_MAP[1] && getBalance() < ROI_MAP[2]) {
410             SPOILS_TO_HIRE_WARRIOR = 1440000;
411         } else if (getBalance() >= ROI_MAP[2] && getBalance() < ROI_MAP[3]) {
412             SPOILS_TO_HIRE_WARRIOR = 1320000;
413         } else if (getBalance() >= ROI_MAP[3] && getBalance() < ROI_MAP[4]) {
414             SPOILS_TO_HIRE_WARRIOR = 1200000;
415         } else if (getBalance() >= ROI_MAP[4]) {
416             SPOILS_TO_HIRE_WARRIOR = 1140000;
417         }
418     }
419 
420     function takeFees(uint256 spoilsValue, bool isBuy)
421         internal
422         returns (uint256)
423     {
424         uint256 devTax;
425         if (isBuy) {
426             devTax = spoilsValue.mul(DEV_TAX_BUY).div(PERCENTS_DIVIDER);
427         } else {
428             devTax = spoilsValue.mul(DEV_TAX_SELL).div(PERCENTS_DIVIDER);
429         }
430         payable(dev).transfer(devTax);
431 
432         uint256 buybackTax = spoilsValue.mul(BUYBACK_TAX).div(PERCENTS_DIVIDER);
433         if (buybackTax > 0) {
434             address[] memory path = new address[](2);
435             path[0] = router.WETH();
436             path[1] = token;
437 
438             router.swapExactETHForTokensSupportingFeeOnTransferTokens{
439                 value: buybackTax
440             }(0, path, dev, block.timestamp);
441         }
442 
443         return devTax.add(buybackTax);
444     }
445 
446     function getDailyCompoundBonus(address _adr, uint256 amount)
447         public
448         view
449         returns (uint256)
450     {
451         if (users[_adr].dailyCompoundBonus == 0) {
452             return 0;
453         } else {
454             uint256 totalBonus = users[_adr].dailyCompoundBonus.mul(
455                 COMPOUND_BONUS
456             );
457             uint256 result = amount.mul(totalBonus).div(PERCENTS_DIVIDER);
458             return result;
459         }
460     }
461 
462     function getUserInfo(address _adr)
463         public
464         view
465         returns (
466             uint256 _initialDeposit,
467             uint256 _userDeposit,
468             uint256 _warriors,
469             uint256 _claimedSpoils,
470             uint256 _lastHatch,
471             address _referrer,
472             uint256 _referrals,
473             uint256 _totalWithdrawn,
474             uint256 _referralRewards,
475             uint256 _dailyCompoundBonus,
476             uint256 _warriorsCompoundCount,
477             uint256 _lastWithdrawTime
478         )
479     {
480         _initialDeposit = users[_adr].initialDeposit;
481         _userDeposit = users[_adr].userDeposit;
482         _warriors = users[_adr].warriors;
483         _claimedSpoils = users[_adr].claimedSpoils;
484         _lastHatch = users[_adr].lastHatch;
485         _referrer = users[_adr].referrer;
486         _referrals = users[_adr].referralsCount;
487         _totalWithdrawn = users[_adr].totalWithdrawn;
488         _referralRewards = users[_adr].referralRewards;
489         _dailyCompoundBonus = users[_adr].dailyCompoundBonus;
490         _warriorsCompoundCount = users[_adr].warriorsCompoundCount;
491         _lastWithdrawTime = users[_adr].lastWithdrawTime;
492     }
493 
494     function getBalance() public view returns (uint256) {
495         return (address(this)).balance;
496     }
497 
498     function getAvailableEarnings(address _adr) public view returns (uint256) {
499         uint256 userSpoils = users[_adr].claimedSpoils.add(
500             getSpoilsSinceLastHatch(_adr)
501         );
502         return calculateSpoilsSell(userSpoils);
503     }
504 
505     function calculateTrade(
506         uint256 rt,
507         uint256 rs,
508         uint256 bs
509     ) public view returns (uint256) {
510         return
511             SafeMath.div(
512                 SafeMath.mul(PSN, bs),
513                 SafeMath.add(
514                     PSNH,
515                     SafeMath.div(
516                         SafeMath.add(
517                             SafeMath.mul(PSN, rs),
518                             SafeMath.mul(PSNH, rt)
519                         ),
520                         rt
521                     )
522                 )
523             );
524     }
525 
526     function calculateSpoilsSell(uint256 spoils) public view returns (uint256) {
527         return calculateTrade(spoils, marketSpoils, getBalance());
528     }
529 
530     function calculateSpoilsBuy(uint256 amount, uint256 contractBalance)
531         public
532         view
533         returns (uint256)
534     {
535         return calculateTrade(amount, contractBalance, marketSpoils);
536     }
537 
538     function calculateSpoilsBuySimple(uint256 amount)
539         public
540         view
541         returns (uint256)
542     {
543         return calculateSpoilsBuy(amount, getBalance());
544     }
545 
546     /** How many warriors and Spoils per day user will recieve based on deposit amount **/
547     function getSpoilsYield(uint256 amount)
548         public
549         view
550         returns (uint256, uint256)
551     {
552         uint256 spoilsAmount = calculateSpoilsBuy(
553             amount,
554             getBalance().add(amount).sub(amount)
555         );
556         uint256 warriors = spoilsAmount.div(SPOILS_TO_HIRE_WARRIOR);
557         uint256 day = 1 days;
558         uint256 spoilsPerDay = day.mul(warriors);
559         uint256 earningsPerDay = calculateSpoilsSellForYield(
560             spoilsPerDay,
561             amount
562         );
563         return (warriors, earningsPerDay);
564     }
565 
566     function calculateSpoilsSellForYield(uint256 spoils, uint256 amount)
567         public
568         view
569         returns (uint256)
570     {
571         return calculateTrade(spoils, marketSpoils, getBalance().add(amount));
572     }
573 
574     function getSiteInfo()
575         public
576         view
577         returns (
578             uint256 _totalStaked,
579             uint256 _totalSuttles,
580             uint256 _totalDeposits,
581             uint256 _totalCompound,
582             uint256 _totalRefBonus
583         )
584     {
585         return (
586             totalStaked,
587             totalSuttles,
588             totalDeposits,
589             totalCompound,
590             totalRefBonus
591         );
592     }
593 
594     function getMywarriors(address userAddress) public view returns (uint256) {
595         return users[userAddress].warriors;
596     }
597 
598     function getMySpoils(address userAddress) public view returns (uint256) {
599         return
600             users[userAddress].claimedSpoils.add(
601                 getSpoilsSinceLastHatch(userAddress)
602             );
603     }
604 
605     function getSpoilsSinceLastHatch(address adr)
606         public
607         view
608         returns (uint256)
609     {
610         uint256 secondsSinceLastHatch = block.timestamp.sub(
611             users[adr].lastHatch
612         );
613         uint256 cutoffTime = min(secondsSinceLastHatch, PROOF_OF_LIFE);
614         uint256 secondsPassed = min(SPOILS_TO_HIRE_WARRIOR, cutoffTime);
615         return secondsPassed.mul(users[adr].warriors);
616     }
617 
618     function min(uint256 a, uint256 b) private pure returns (uint256) {
619         return a < b ? a : b;
620     }
621 
622     function SET_WALLETS(address payable _dev) external onlyOwner {
623         require(!isContract(_dev));
624         dev = _dev;
625     }
626 
627     function SET_TAX(
628         uint256 _buyback,
629         uint256 _devBuy,
630         uint256 _devSell
631     ) external onlyOwner {
632         BUYBACK_TAX = _buyback;
633         DEV_TAX_BUY = _devBuy;
634         DEV_TAX_SELL = _devSell;
635         require(_buyback + _devBuy < 100, "Less than 10%");
636         require(_buyback + _devSell < 150, "Less than 15%");
637     }
638 
639     function SET_TOKEN(address _token) external onlyOwner {
640         token = _token;
641     }
642 
643     function SET_ROUTER(address _router) external onlyOwner {
644         router = IDexRouter(_router);
645     }
646 
647     function PRC_MARKET_SPOILS_DIVISOR(uint256 value) external onlyOwner {
648         require(value > 0 && value <= 10);
649         MARKET_SPOILS_DIVISOR = value;
650     }
651 
652     function SET_EARLY_WITHDRAWAL_TAX(uint256 value) external onlyOwner {
653         require(value <= 700);
654         WITHDRAWAL_TAX = value;
655     }
656 
657     function BONUS_DAILY_COMPOUND(uint256 value) external onlyOwner {
658         require(value >= 1 && value <= 100);
659         COMPOUND_BONUS = value;
660     }
661 
662     function BONUS_DAILY_COMPOUND_MAX_TIMES(uint256 value) external onlyOwner {
663         require(value > 5 && value <= 10);
664         COMPOUND_MAX_TIMES = value;
665     }
666 
667     function BONUS_COMPOUND_DURATION(uint256 value) external onlyOwner {
668         require(value <= 24);
669         COMPOUND_DURATION = value * 60 * 60;
670     }
671 
672     function SET_PROOF_OF_LIFE(uint256 value) external onlyOwner {
673         require(value >= 24);
674         PROOF_OF_LIFE = value * 60 * 60;
675     }
676 
677     function SET_MAX_WITHDRAW_LIMIT(uint256 value) external onlyOwner {
678         require(value >= 1 ether);
679         MAX_WITHDRAW_LIMIT = value;
680     }
681 
682     function SET_MIN_DEPOSIT_LIMIT(uint256 value) external onlyOwner {
683         MIN_DEPOSIT_LIMIT = value;
684     }
685 
686     function SET_COMPOUND_FOR_NO_TAX_WITHDRAWAL(uint256 value)
687         external
688         onlyOwner
689     {
690         require(value <= 12);
691         COMPOUND_FOR_NO_TAX_WITHDRAWAL = value;
692     }
693 
694     function UPDATE_ROI_MAP1(uint256 value) external onlyOwner {
695         ROI_MAP[0] = value;
696     }
697 
698     function UPDATE_ROI_MAP2(uint256 value) external onlyOwner {
699         ROI_MAP[1] = value;
700     }
701 
702     function UPDATE_ROI_MAP3(uint256 value) external onlyOwner {
703         ROI_MAP[2] = value;
704     }
705 
706     function UPDATE_ROI_MAP4(uint256 value) external onlyOwner {
707         ROI_MAP[3] = value;
708     }
709 
710     function UPDATE_ROI_MAP5(uint256 value) external onlyOwner {
711         ROI_MAP[4] = value;
712     }
713 }
714 
715 library SafeMath {
716     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
717         if (a == 0) {
718             return 0;
719         }
720         uint256 c = a * b;
721         assert(c / a == b);
722         return c;
723     }
724 
725     function div(uint256 a, uint256 b) internal pure returns (uint256) {
726         uint256 c = a / b;
727         return c;
728     }
729 
730     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
731         assert(b <= a);
732         return a - b;
733     }
734 
735     function add(uint256 a, uint256 b) internal pure returns (uint256) {
736         uint256 c = a + b;
737         assert(c >= a);
738         return c;
739     }
740 
741     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
742         require(b != 0);
743         return a % b;
744     }
745 }