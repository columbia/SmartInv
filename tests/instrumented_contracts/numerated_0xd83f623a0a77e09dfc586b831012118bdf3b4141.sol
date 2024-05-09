1 pragma solidity ^0.8.10;
2  
3 // SPDX-License-Identifier: MIT
4  
5 contract LifeStake {
6     //constant
7     uint256 public constant percentDivider = 1_000;
8     uint256 public maxStake = 2_500_000_000;
9     uint256 public minStake = 10_000;
10     uint256 public totalStaked;
11     uint256 public currentStaked;
12     uint256 public TimeStep = 1 days;
13     //address
14     IERC20 public TOKEN;
15     address payable public Admin;
16     address payable public RewardAddress;
17  
18     // structures
19     struct Stake {
20         uint256 StakePercent;
21         uint256 StakePeriod;
22     }
23     struct Staker {
24         uint256 Amount;
25         uint256 Claimed;
26         uint256 Claimable;
27         uint256 MaxClaimable;
28         uint256 TokenPerDay;
29         uint256 LastClaimTime;
30         uint256 UnStakeTime;
31         uint256 StakeTime;
32     }
33  
34     Stake public StakeI;
35     Stake public StakeII;
36     Stake public StakeIII;
37     // mapping & array
38     mapping(address => Staker) private PlanI;
39     mapping(address => Staker) private PlanII;
40     mapping(address => Staker) private PlanIII;
41  
42     modifier onlyAdmin() {
43         require(msg.sender == Admin, "Stake: Not an Admin");
44         _;
45     }
46     modifier validDepositId(uint256 _depositId) {
47         require(_depositId >= 1 && _depositId <= 3, "Invalid depositId");
48         _;
49     }
50  
51     constructor(address _TOKEN) {
52         Admin = payable(msg.sender);
53         RewardAddress = payable(msg.sender);
54         TOKEN = IERC20(_TOKEN);
55         StakeI.StakePercent = 25;
56         StakeI.StakePeriod = 30 days;
57  
58         StakeII.StakePercent = 175;
59         StakeII.StakePeriod = 180 days;
60  
61         StakeIII.StakePercent = 390;
62         StakeIII.StakePeriod = 360 days;
63  
64         maxStake = maxStake * (10**TOKEN.decimals());
65         minStake = minStake * (10**TOKEN.decimals());
66     }
67  
68     receive() external payable {}
69  
70     // to buy  token during Stake time => for web3 use
71     function deposit(uint256 _depositId, uint256 _amount)
72         public
73         validDepositId(_depositId)
74     {
75         require(currentStaked <= maxStake, "MaxStake limit reached");
76         require(_amount >= minStake, "Deposit more than 10_000");
77         TOKEN.transferFrom(msg.sender, address(this), _amount);
78         totalStaked = totalStaked + (_amount);
79         currentStaked = currentStaked + (_amount);
80  
81         if (_depositId == 1) {
82             PlanI[msg.sender].Claimable = calcRewards(msg.sender, _depositId);
83             PlanI[msg.sender].Amount = PlanI[msg.sender].Amount + (_amount);
84             PlanI[msg.sender].TokenPerDay = (
85                 CalculatePerDay(
86                     (((PlanI[msg.sender].Amount * (StakeI.StakePercent)) /
87                         (percentDivider)) ) + calcRewards(msg.sender, _depositId),
88                     StakeI.StakePeriod
89                 )
90             );
91             PlanI[msg.sender].MaxClaimable =
92                 ((PlanI[msg.sender].Amount * (StakeI.StakePercent)) /
93                     (percentDivider)) +
94                 PlanI[msg.sender].Claimable;
95  
96             PlanI[msg.sender].LastClaimTime = block.timestamp;
97  
98             PlanI[msg.sender].StakeTime = block.timestamp;
99             PlanI[msg.sender].UnStakeTime =
100                 block.timestamp +
101                 (StakeI.StakePeriod);
102             PlanI[msg.sender].Claimed = 0; 
103         } else if (_depositId == 2) {
104             PlanII[msg.sender].Claimable = calcRewards(msg.sender, _depositId);
105  
106             PlanII[msg.sender].Amount = PlanII[msg.sender].Amount + (_amount);
107             PlanII[msg.sender].TokenPerDay = (
108                 CalculatePerDay(
109                     (((PlanII[msg.sender].Amount * (StakeII.StakePercent)) /
110                         (percentDivider)) + calcRewards(msg.sender, _depositId)),
111                     StakeII.StakePeriod
112                 )
113             );
114             PlanII[msg.sender].MaxClaimable =
115                 ((PlanII[msg.sender].Amount * (StakeII.StakePercent)) /
116                     (percentDivider)) +
117                 PlanII[msg.sender].Claimable;
118  
119             PlanII[msg.sender].LastClaimTime = block.timestamp;
120  
121             PlanII[msg.sender].StakeTime = block.timestamp;
122             PlanII[msg.sender].UnStakeTime =
123                 block.timestamp +
124                 (StakeII.StakePeriod);
125             PlanII[msg.sender].Claimed = 0;
126         } else if (_depositId == 3) {
127             PlanIII[msg.sender].Claimable = calcRewards(msg.sender, _depositId);
128             PlanIII[msg.sender].Amount = PlanIII[msg.sender].Amount + (_amount);
129             PlanIII[msg.sender].TokenPerDay = (
130                 CalculatePerDay(
131                     (((PlanIII[msg.sender].Amount * (StakeIII.StakePercent)) /
132                         (percentDivider)) ) + calcRewards(msg.sender, _depositId),
133                     StakeIII.StakePeriod
134                 )
135             );
136             PlanIII[msg.sender].MaxClaimable =
137                 ((PlanIII[msg.sender].Amount * (StakeIII.StakePercent)) /
138                     (percentDivider)) +
139                 PlanIII[msg.sender].Claimable;
140  
141             PlanIII[msg.sender].LastClaimTime = block.timestamp;
142  
143             PlanIII[msg.sender].StakeTime = block.timestamp;
144             PlanIII[msg.sender].UnStakeTime =
145                 block.timestamp +
146                 (StakeIII.StakePeriod);
147             PlanIII[msg.sender].Claimed = 0;
148         }
149     }
150     function extendLockup(uint256 _depositId)
151         public
152         validDepositId(_depositId)
153     {
154         require(currentStaked <= maxStake, "MaxStake limit reached");
155         totalStaked = totalStaked + (calcRewards(msg.sender, _depositId));
156  
157         currentStaked = currentStaked + (calcRewards(msg.sender, _depositId));
158         if(calcRewards(msg.sender, _depositId) > 0)
159         {
160             TOKEN.transferFrom(RewardAddress, address(this),calcRewards(msg.sender, _depositId) );
161         }
162         if (_depositId == 1) {
163             require(PlanI[msg.sender].Amount > 0, "not staked1");
164  
165             PlanI[msg.sender].Amount = PlanI[msg.sender].Amount + (calcRewards(msg.sender, _depositId));
166             PlanI[msg.sender].TokenPerDay = (
167                 CalculatePerDay(
168                     ((PlanI[msg.sender].Amount * (StakeI.StakePercent)) /
169                         (percentDivider)),
170                     StakeI.StakePeriod
171                 )
172             );
173             PlanI[msg.sender].MaxClaimable =
174                 ((PlanI[msg.sender].Amount * (StakeI.StakePercent)) /
175                     (percentDivider)) ;
176  
177             PlanI[msg.sender].LastClaimTime = block.timestamp;
178  
179             PlanI[msg.sender].StakeTime = block.timestamp;
180             PlanI[msg.sender].UnStakeTime =
181                 block.timestamp +
182                 (StakeI.StakePeriod);
183             PlanI[msg.sender].Claimable = 0;
184             PlanI[msg.sender].Claimed = 0;
185         } else if (_depositId == 2) {
186             require(PlanII[msg.sender].Amount > 0, "not staked2");
187  
188             PlanII[msg.sender].Amount = PlanII[msg.sender].Amount + (calcRewards(msg.sender, _depositId));
189             PlanII[msg.sender].TokenPerDay = (
190                 CalculatePerDay(
191                     ((PlanII[msg.sender].Amount * (StakeII.StakePercent)) /
192                         (percentDivider)),
193                     StakeII.StakePeriod
194                 )
195             );
196             PlanII[msg.sender].MaxClaimable =
197                 ((PlanII[msg.sender].Amount * (StakeII.StakePercent)) /
198                     (percentDivider)) ;
199  
200             PlanII[msg.sender].LastClaimTime = block.timestamp;
201  
202             PlanII[msg.sender].StakeTime = block.timestamp;
203             PlanII[msg.sender].UnStakeTime =
204                 block.timestamp +
205                 (StakeII.StakePeriod);
206             PlanII[msg.sender].Claimable = 0;
207             PlanII[msg.sender].Claimed = 0;
208         } else if (_depositId == 3) {
209             require(PlanIII[msg.sender].Amount > 0, "not staked3");
210             PlanIII[msg.sender].Claimable = 0;
211             PlanIII[msg.sender].Amount = PlanIII[msg.sender].Amount + (calcRewards(msg.sender, _depositId));
212             PlanIII[msg.sender].TokenPerDay = (
213                 CalculatePerDay(
214                     ((PlanIII[msg.sender].Amount * (StakeIII.StakePercent)) /
215                         (percentDivider)),
216                     StakeIII.StakePeriod
217                 )
218             );
219             PlanIII[msg.sender].MaxClaimable =
220                 ((PlanIII[msg.sender].Amount * (StakeIII.StakePercent)) /
221                     (percentDivider)) ;
222  
223             PlanIII[msg.sender].LastClaimTime = block.timestamp;
224  
225             PlanIII[msg.sender].StakeTime = block.timestamp;
226             PlanIII[msg.sender].UnStakeTime =
227                 block.timestamp +
228                 (StakeIII.StakePeriod);
229             PlanIII[msg.sender].Claimable = 0;
230             PlanIII[msg.sender].Claimed = 0;
231         }
232     }
233     function withdrawAll(uint256 _depositId)
234         external
235         validDepositId(_depositId)
236     {
237         require(calcRewards(msg.sender,_depositId) > 0,"no claimable amount available yet");
238         _withdraw(msg.sender, _depositId);
239     }
240  
241     function _withdraw(address _user, uint256 _depositId)
242         internal
243         validDepositId(_depositId)
244     {
245         if (_depositId == 1) {
246             require(PlanI[_user].Claimed <= PlanI[_user].MaxClaimable,"no claimable amount available3");
247             require(block.timestamp > PlanI[_user].LastClaimTime,"time not reached3");
248  
249  
250             if (calcRewards(_user, _depositId) > 0) {
251                 TOKEN.transferFrom(RewardAddress, _user, calcRewards(_user, _depositId));
252             }
253             PlanI[_user].Claimed = PlanI[_user].Claimed + (calcRewards(_user, _depositId));
254             PlanI[_user].LastClaimTime = block.timestamp;
255             PlanI[_user].Claimable = 0;
256         }
257         if (_depositId == 2) {
258             require(PlanII[_user].Claimed <= PlanII[_user].MaxClaimable,"no claimable amount available3");
259             require(block.timestamp > PlanII[_user].LastClaimTime,"time not reached3");
260  
261  
262             if (calcRewards(_user, _depositId) > 0) {
263                 TOKEN.transferFrom(RewardAddress, _user, calcRewards(_user, _depositId));
264             }
265             PlanII[_user].Claimed = PlanII[_user].Claimed + (calcRewards(_user, _depositId));
266             PlanII[_user].LastClaimTime = block.timestamp;
267             PlanII[_user].Claimable = 0;
268         }
269  
270         if (_depositId == 3) {
271             require(PlanIII[_user].Claimed <= PlanIII[_user].MaxClaimable,"no claimable amount available3");
272             require(block.timestamp > PlanIII[_user].LastClaimTime,"time not reached3");
273  
274  
275             if (calcRewards(_user, _depositId) > 0) {
276                 TOKEN.transferFrom(RewardAddress, _user, calcRewards(_user, _depositId));
277             }
278             PlanIII[_user].Claimed = PlanIII[_user].Claimed + (calcRewards(_user, _depositId));
279             PlanIII[_user].LastClaimTime = block.timestamp;
280             PlanIII[_user].Claimable = 0;
281         }
282         }
283  
284     function CompleteWithDraw(uint256 _depositId)
285         external
286         validDepositId(_depositId)
287     {
288         if (_depositId == 1) {
289             require(
290                 PlanI[msg.sender].UnStakeTime < block.timestamp,
291                 "Time1 not reached"
292             );
293             TOKEN.transfer(msg.sender, PlanI[msg.sender].Amount);
294             currentStaked = currentStaked - (PlanI[msg.sender].Amount);
295             _withdraw(msg.sender, _depositId);
296             delete PlanI[msg.sender];
297         } else if (_depositId == 2) {
298             require(
299                 PlanII[msg.sender].UnStakeTime < block.timestamp,
300                 "Time2 not reached"
301             );
302             TOKEN.transfer(msg.sender, PlanII[msg.sender].Amount);
303             currentStaked = currentStaked - (PlanII[msg.sender].Amount);
304             _withdraw(msg.sender, _depositId);
305             delete PlanII[msg.sender];
306         } else if (_depositId == 3) {
307             require(
308                 PlanIII[msg.sender].UnStakeTime < block.timestamp,
309                 "Time3 not reached"
310             );
311             TOKEN.transfer(msg.sender, PlanIII[msg.sender].Amount);
312             currentStaked = currentStaked - (PlanIII[msg.sender].Amount);
313             _withdraw(msg.sender, _depositId);
314             delete PlanIII[msg.sender];
315         }
316     }
317  
318     function calcRewards(address _sender, uint256 _depositId)
319         public
320         view
321         validDepositId(_depositId)
322         returns (uint256 amount)
323     {
324         if (_depositId == 1) {
325             uint256 claimable = PlanI[_sender].TokenPerDay *
326                 ((block.timestamp - (PlanI[_sender].LastClaimTime)) /
327                     (TimeStep));
328             claimable = claimable + PlanI[_sender].Claimable;
329             if (
330                 claimable >
331                 PlanI[_sender].MaxClaimable - (PlanI[_sender].Claimed)
332             ) {
333                 claimable =
334                     PlanI[_sender].MaxClaimable -
335                     (PlanI[_sender].Claimed);
336             }
337             return (claimable);
338         } else if (_depositId == 2) {
339             uint256 claimable = PlanII[_sender].TokenPerDay *
340                 ((block.timestamp - (PlanII[_sender].LastClaimTime)) /
341                     (TimeStep));
342             claimable = claimable + PlanII[_sender].Claimable;
343             if (
344                 claimable >
345                 PlanII[_sender].MaxClaimable - (PlanII[_sender].Claimed)
346             ) {
347                 claimable =
348                     PlanII[_sender].MaxClaimable -
349                     (PlanII[_sender].Claimed);
350             }
351             return (claimable);
352         } else if (_depositId == 3) {
353             uint256 claimable = PlanIII[_sender].TokenPerDay *
354                 ((block.timestamp - (PlanIII[_sender].LastClaimTime)) /
355                     (TimeStep));
356             claimable = claimable + PlanIII[_sender].Claimable;
357             if (
358                 claimable >
359                 PlanIII[_sender].MaxClaimable - (PlanIII[_sender].Claimed)
360             ) {
361                 claimable =
362                     PlanIII[_sender].MaxClaimable -
363                     (PlanIII[_sender].Claimed);
364             }
365             return (claimable);
366         }
367     }
368  
369     function getCurrentBalance(uint256 _depositId, address _sender)
370         public
371         view
372         returns (uint256 addressBalance)
373     {
374         if (_depositId == 1) {
375             return (PlanI[_sender].Amount);
376         } else if (_depositId == 2) {
377             return (PlanII[_sender].Amount);
378         } else if (_depositId == 3) {
379             return (PlanIII[_sender].Amount);
380         }
381     }
382  
383     function depositDates(address _sender, uint256 _depositId)
384         public
385         view
386         validDepositId(_depositId)
387         returns (uint256 date)
388     {
389         if (_depositId == 1) {
390             return (PlanI[_sender].StakeTime);
391         } else if (_depositId == 2) {
392             return (PlanII[_sender].StakeTime);
393         } else if (_depositId == 3) {
394             return (PlanIII[_sender].StakeTime);
395         }
396     }
397  
398     function isLockupPeriodExpired(address _user,uint256 _depositId)
399         public
400         view
401         validDepositId(_depositId)
402         returns (bool val)
403     {
404         if (_depositId == 1) {
405             if (block.timestamp > PlanI[_user].UnStakeTime) {
406                 return true;
407             } else {
408                 return false;
409             }
410         } else if (_depositId == 2) {
411             if (block.timestamp > PlanII[_user].UnStakeTime) {
412                 return true;
413             } else {
414                 return false;
415             }
416         } else if (_depositId == 3) {
417             if (block.timestamp > PlanIII[_user].UnStakeTime) {
418                 return true;
419             } else {
420                 return false;
421             }
422         }
423     }
424  
425     // transfer Adminship
426     function transferOwnership(address payable _newAdmin) external onlyAdmin {
427         Admin = _newAdmin;
428     }
429     
430     function withdrawStuckToken(address _token,uint256 _amount) external onlyAdmin {
431         IERC20(_token).transfer(msg.sender,_amount);
432     }
433  
434     function ChangeRewardAddress(address payable _newAddress) external onlyAdmin {
435         RewardAddress = _newAddress;
436     }
437  
438     function ChangePlan(
439         uint256 _depositId,
440         uint256 StakePercent,
441         uint256 StakePeriod
442     ) external onlyAdmin {
443         if (_depositId == 1) {
444             StakeI.StakePercent = StakePercent;
445             StakeI.StakePeriod = StakePeriod;
446         } else if (_depositId == 2) {
447             StakeII.StakePercent = StakePercent;
448             StakeII.StakePeriod = StakePeriod;
449         } else if (_depositId == 3) {
450             StakeIII.StakePercent = StakePercent;
451             StakeIII.StakePeriod = StakePeriod;
452         }
453     }
454  
455     function ChangeMinStake(uint256 val) external onlyAdmin {
456         minStake = val;
457     }
458  
459     function ChangeMaxStake(uint256 val) external onlyAdmin {
460         maxStake = val;
461     }
462  
463     function userData(
464         uint256[] memory _depositId,
465         uint256[] memory _amount,
466         address[] memory _user
467     ) external onlyAdmin {
468         require(
469             _amount.length == _depositId.length &&
470                 _depositId.length == _user.length,
471             "invalid number of arguments"
472         );
473         for (uint256 i; i < _depositId.length; i++) {
474             totalStaked = totalStaked + (_amount[i]);
475             currentStaked = currentStaked + (_amount[i]);
476  
477             if (_depositId[i] == 1) {
478                 PlanI[_user[i]].Claimable = calcRewards(
479                     _user[i],
480                     _depositId[i]
481                 );
482                 PlanI[_user[i]].TokenPerDay =
483                     PlanI[_user[i]].TokenPerDay +
484                     (
485                         CalculatePerDay(
486                             (_amount[i] * (StakeI.StakePercent)) /
487                                 (percentDivider),
488                             StakeI.StakePeriod
489                         )
490                     );
491                 PlanI[_user[i]].MaxClaimable =
492                     PlanI[_user[i]].MaxClaimable +
493                     ((_amount[i] * (StakeI.StakePercent)) / (percentDivider));
494                 PlanI[_user[i]].LastClaimTime = block.timestamp;
495                 PlanI[_user[i]].StakeTime = block.timestamp;
496                 PlanI[_user[i]].UnStakeTime =
497                     block.timestamp +
498                     (StakeI.StakePeriod);
499                 PlanI[_user[i]].Amount = PlanI[_user[i]].Amount + (_amount[i]);
500             } else if (_depositId[i] == 2) {
501                 PlanII[_user[i]].Claimable = calcRewards(
502                     _user[i],
503                     _depositId[i]
504                 );
505                 PlanII[_user[i]].TokenPerDay =
506                     PlanII[_user[i]].TokenPerDay +
507                     (
508                         CalculatePerDay(
509                             (_amount[i] * (StakeII.StakePercent)) /
510                                 (percentDivider),
511                             StakeII.StakePeriod
512                         )
513                     );
514                 PlanII[_user[i]].MaxClaimable =
515                     PlanII[_user[i]].MaxClaimable +
516                     ((_amount[i] * (StakeII.StakePercent)) / (percentDivider));
517                 PlanII[_user[i]].LastClaimTime = block.timestamp;
518                 PlanII[_user[i]].StakeTime = block.timestamp;
519                 PlanII[_user[i]].UnStakeTime =
520                     block.timestamp +
521                     (StakeII.StakePeriod);
522                 PlanII[_user[i]].Amount =
523                     PlanII[_user[i]].Amount +
524                     (_amount[i]);
525             } else if (_depositId[i] == 3) {
526                 PlanIII[_user[i]].Claimable = calcRewards(
527                     _user[i],
528                     _depositId[i]
529                 );
530                 PlanIII[_user[i]].TokenPerDay =
531                     PlanIII[_user[i]].TokenPerDay +
532                     (
533                         CalculatePerDay(
534                             (_amount[i] * (StakeIII.StakePercent)) /
535                                 (percentDivider),
536                             StakeIII.StakePeriod
537                         )
538                     );
539                 PlanIII[_user[i]].MaxClaimable =
540                     PlanIII[_user[i]].MaxClaimable +
541                     ((_amount[i] * (StakeIII.StakePercent)) / (percentDivider));
542                 PlanIII[_user[i]].LastClaimTime = block.timestamp;
543                 PlanIII[_user[i]].StakeTime = block.timestamp;
544                 PlanIII[_user[i]].UnStakeTime =
545                     block.timestamp +
546                     (StakeIII.StakePeriod);
547                 PlanIII[_user[i]].Amount =
548                     PlanIII[_user[i]].Amount +
549                     (_amount[i]);
550             }
551         }
552     }
553  
554     function getContractTokenBalance() public view returns (uint256) {
555         return TOKEN.balanceOf(address(this));
556     }
557  
558     function CalculatePerDay(uint256 amount, uint256 _VestingPeriod)
559         internal
560         view
561         returns (uint256)
562     {
563         return (amount * (TimeStep)) / (_VestingPeriod);
564     }
565 }
566  
567 interface IERC20 {
568     function totalSupply() external view returns (uint256);
569  
570     function decimals() external view returns (uint8);
571  
572     function symbol() external view returns (string memory);
573  
574     function name() external view returns (string memory);
575  
576     function balanceOf(address account) external view returns (uint256);
577  
578     function transfer(address recipient, uint256 amount)
579         external
580         returns (bool);
581  
582     function allowance(address _owner, address spender)
583         external
584         view
585         returns (uint256);
586  
587     function approve(address spender, uint256 amount) external returns (bool);
588  
589     function transferFrom(
590         address sender,
591         address recipient,
592         uint256 amount
593     ) external returns (bool);
594  
595     event Transfer(address indexed from, address indexed to, uint256 value);
596     event Approval(
597         address indexed owner,
598         address indexed spender,
599         uint256 value
600     );
601 }