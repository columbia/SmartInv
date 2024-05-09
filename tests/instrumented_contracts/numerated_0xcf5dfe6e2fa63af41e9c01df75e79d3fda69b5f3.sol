1 // MUSystem is based of the mathematical algorithm created 
2 // by the Mavrodi brothers - Sergey and Vyacheslav. 
3 // The solidity code was written by the enthusiast and devoted MMM participant Andrew from Russia.
4 // According to these rules MMM worked in Russia in the nineties. 
5 // Today you help someone — Tomorrow you will be helped out!
6 // Mutual Uniting System (MUSystem) email: mutualunitingsystem@gmail.com
7 // http:// Musystem.online
8 // Hello from Russia with love! ;) Привет из России! ;)
9 // "MMM IS A FINANCIAL NUCLEAR WEAPON.
10 // They say Baba Vanga predicted, “Pyramid from Russia will travel the world.”
11 // When Sergey Mavrodi passed away, many people thought this prediction 
12 // wasn't going to come true. What if it's just started to materialize?"
13 
14 // Financial apocalypse is inevitable! Together we can do a lot!
15 // Thank you Sergey Mavrodi. You've opened my eyes.
16 
17 pragma solidity ^0.4.21;
18 
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21     if (a == 0) {
22       return 0;
23     }
24     c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28   function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     c = a / b;
30     return c;
31   }
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract MUSystem {
44     
45     using SafeMath for uint;
46     
47     string public constant name = "Mutual Uniting System";
48     string public constant symbol = "MUS";
49     uint public constant decimals = 15;
50     uint public totalSupply;
51     address private creatorOwner;
52     address private userAddr;
53     mapping (address => uint) balances;
54     struct UserWhoBuy {
55         uint UserAmt;
56         uint UserTokenObtain;
57         uint UserBuyDate;
58         uint UserBuyFirstDate;
59         uint UserBuyTokenPackNum;
60         uint UserFirstAmt;
61         uint UserContinued;
62         uint UserTotalAmtDepositCurrentPack;
63     }
64     mapping (address => UserWhoBuy) usersWhoBuy;
65     address[] private userWhoBuyDatas;
66     struct UserWhoSell {
67         uint UserAmtWithdrawal;
68         uint UserTokenSell;
69         uint UserSellDate;
70         uint UserSellTokenPackNum;
71         uint UserTotalAmtWithdrawal;
72         uint UserTotalAmtWithdrawalCurrentPack;
73     }
74     mapping (address => UserWhoSell) usersWhoSell;
75     address[] private userWhoSellDatas;
76 
77 // The basic parameters of MUSystem that determine 
78 // the participant's income per package, 
79 // the initial price of one token, 
80 // the number of tokens in pack, Disparity mode percentage
81 // and another internal constants.
82 
83     uint private CoMargin = 101; 
84     uint private CoOverlap = 110; 
85     uint private Disparity = 70; 
86     bool private DisparityMode;
87     uint private RestartModeDate;
88     bool private RestartMode;
89     uint private PackVolume = 50;  
90     uint private FirstPackTokenPriceSellout = 50;    
91     uint private BigAmt = 250 * 1 ether; 
92     bool private feeTransfered;
93     uint private PrevPrevPackTokenPriceSellout;
94     uint private PrevPackTokenPriceSellout;
95     uint private PrevPackTokenPriceBuyout; 
96     uint private PrevPackDelta; 
97     uint private PrevPackCost;
98     uint private PrevPackTotalAmt;
99     uint private CurrentPackYield;
100     uint private CurrentPackDelta;
101     uint private CurrentPackCost;
102     uint private CurrentPackTotalToPay;
103     uint private CurrentPackTotalAmt;
104     uint private CurrentPackRestAmt;
105     uint private CurrentPackFee;
106     uint private CurrentPackTotalToPayDisparity;
107     uint private CurrentPackNumber; 
108     uint private CurrentPackStartDate; 
109     uint private CurrentPackTokenPriceSellout;  
110     uint private CurrentPackTokenPriceBuyout;
111     uint private CurrentPackTokenAvailablePercent;
112     uint private NextPackTokenPriceBuyout; 
113     uint private NextPackYield; 
114     uint private NextPackDelta;
115     uint private userContinued;
116     uint private userAmt; 
117     uint private userFirstAmt;
118     uint private userTotalAmtDepositCurrentPack;
119     uint private userBuyFirstDate;
120     uint private userTotalAmtWithdrawal;
121     uint private userTotalAmtWithdrawalCurrentPack;
122     uint private UserTokensReturn;
123     bool private returnTokenInCurrentPack;
124     uint private withdrawAmtToCurrentPack;
125     uint private withdrawAmtAboveCurrentPack;
126     uint private UserTokensReturnToCurrentPack;
127     uint private UserTokensReturnAboveCurrentPack;
128     uint private bonus;
129     uint private userAmtOverloadToSend;
130 
131 // MUSystem is launched at the time of the contract deployment. 
132 // It all starts with the first package. 
133 // Settings are applied and the number of tokens is released.
134 
135     constructor () public payable {
136         creatorOwner = msg.sender;
137         PackVolume = (10 ** decimals).mul(PackVolume);
138         DisparityMode = false;
139         RestartMode = false;
140         CurrentPackNumber = 1; 
141         CurrentPackStartDate = now;
142         mint(PackVolume);
143         packSettings(CurrentPackNumber);
144     }
145 
146 // Write down participants who make deposits.
147 
148     function addUserWhoBuy (
149     address _address, 
150     uint _UserAmt, 
151     uint _UserTokenObtain, 
152     uint _UserBuyDate,
153     uint _UserBuyFirstDate,
154     uint _UserBuyTokenPackNum,
155     uint _UserFirstAmt,
156     uint _UserContinued,
157     uint _UserTotalAmtDepositCurrentPack) internal {
158         UserWhoBuy storage userWhoBuy = usersWhoBuy[_address];
159         userWhoBuy.UserAmt = _UserAmt;
160         userWhoBuy.UserTokenObtain = _UserTokenObtain;
161         userWhoBuy.UserBuyDate = _UserBuyDate;
162         userWhoBuy.UserBuyFirstDate = _UserBuyFirstDate;
163         userWhoBuy.UserBuyTokenPackNum = _UserBuyTokenPackNum;
164         userWhoBuy.UserFirstAmt = _UserFirstAmt;
165         userWhoBuy.UserContinued = _UserContinued;
166         userWhoBuy.UserTotalAmtDepositCurrentPack = _UserTotalAmtDepositCurrentPack;
167         userWhoBuyDatas.push(_address) -1;
168     }
169 // Write down also participants who make withdrawals.
170 
171     function addUserWhoSell (
172     address _address, 
173     uint _UserAmtWithdrawal, 
174     uint _UserTokenSell, 
175     uint _UserSellDate,
176     uint _UserSellTokenPackNum,
177     uint _UserTotalAmtWithdrawal,
178     uint _UserTotalAmtWithdrawalCurrentPack) internal {
179         UserWhoSell storage userWhoSell = usersWhoSell[_address];
180         userWhoSell.UserAmtWithdrawal = _UserAmtWithdrawal;
181         userWhoSell.UserTokenSell = _UserTokenSell;
182         userWhoSell.UserSellDate = _UserSellDate;
183         userWhoSell.UserSellTokenPackNum = _UserSellTokenPackNum;
184         userWhoSell.UserTotalAmtWithdrawal = _UserTotalAmtWithdrawal; 
185         userWhoSell.UserTotalAmtWithdrawalCurrentPack = _UserTotalAmtWithdrawalCurrentPack;
186         userWhoSellDatas.push(_address) -1;
187     }
188 
189 // Calculation of pack's parameters "on the fly". 
190 // Course (price) of tokens is growing by a special technique, 
191 // which designed increases with the passage of time the size 
192 // of a possible return donations for the participants, 
193 // subject to a maximum system stability.
194 
195     function packSettings (uint _currentPackNumber) internal {
196         CurrentPackNumber = _currentPackNumber;
197         if(CurrentPackNumber == 1){
198             PrevPackDelta = 0;
199             PrevPackCost = 0;
200             PrevPackTotalAmt = 0;
201             CurrentPackStartDate = now;
202             CurrentPackTokenPriceSellout = FirstPackTokenPriceSellout;
203             CurrentPackTokenPriceBuyout = FirstPackTokenPriceSellout; 
204             CurrentPackCost = PackVolume.mul(CurrentPackTokenPriceSellout);
205             CurrentPackTotalToPay = 0;
206             CurrentPackTotalToPayDisparity = 0;
207             CurrentPackYield = 0;
208             CurrentPackDelta = 0;
209             CurrentPackTotalAmt = CurrentPackCost;
210             CurrentPackFee = 0;
211             CurrentPackRestAmt = CurrentPackCost.sub(CurrentPackTotalToPay);
212             if (FirstPackTokenPriceSellout == 50){NextPackTokenPriceBuyout = 60;}else{NextPackTokenPriceBuyout = FirstPackTokenPriceSellout+5;}
213         }
214         if(CurrentPackNumber == 2){
215             PrevPrevPackTokenPriceSellout = 0;
216             PrevPackTokenPriceSellout = CurrentPackTokenPriceSellout;
217             PrevPackTokenPriceBuyout = CurrentPackTokenPriceBuyout;
218             PrevPackDelta = CurrentPackDelta;
219             PrevPackCost = CurrentPackCost;
220             PrevPackTotalAmt = CurrentPackTotalAmt;
221             CurrentPackYield = 0;
222             CurrentPackDelta = 0;
223             NextPackTokenPriceBuyout = PrevPackTokenPriceSellout.mul(CoOverlap).div(100);
224             NextPackYield = NextPackTokenPriceBuyout.sub(PrevPackTokenPriceSellout);
225             NextPackDelta = NextPackYield;
226             CurrentPackTokenPriceSellout = NextPackTokenPriceBuyout.add(NextPackDelta);
227             CurrentPackTokenPriceBuyout = CurrentPackTokenPriceSellout;
228             CurrentPackCost = PackVolume.mul(CurrentPackTokenPriceSellout);
229             CurrentPackTotalToPay = 0;
230             CurrentPackTotalAmt = CurrentPackCost.add(PrevPackTotalAmt);
231             CurrentPackFee = 0;
232             CurrentPackTotalToPayDisparity = PrevPackCost.mul(Disparity).div(100);
233             CurrentPackRestAmt = CurrentPackCost.sub(CurrentPackTotalToPay);
234         }
235         if(CurrentPackNumber > 2){
236             PrevPackTokenPriceSellout = CurrentPackTokenPriceSellout;
237             PrevPackTokenPriceBuyout = CurrentPackTokenPriceBuyout;
238             PrevPackDelta = CurrentPackDelta;
239             PrevPackCost = CurrentPackCost;
240             PrevPackTotalAmt = CurrentPackTotalAmt;
241             CurrentPackYield = NextPackYield;
242             CurrentPackDelta = NextPackDelta;
243             CurrentPackTokenPriceBuyout = NextPackTokenPriceBuyout;
244             NextPackTokenPriceBuyout = PrevPackTokenPriceSellout.mul(CoOverlap);
245             if(NextPackTokenPriceBuyout<=100){  
246                 NextPackTokenPriceBuyout=PrevPackTokenPriceSellout.mul(CoOverlap).div(100);
247             }
248             if(NextPackTokenPriceBuyout>100){ 
249                 NextPackTokenPriceBuyout=NextPackTokenPriceBuyout*10**3;
250                 NextPackTokenPriceBuyout=((NextPackTokenPriceBuyout/10000)+5)/10;
251             }
252             NextPackYield = NextPackTokenPriceBuyout.sub(PrevPackTokenPriceSellout);
253             NextPackDelta = NextPackYield.mul(CoMargin);
254             if(NextPackDelta <= 100){ 
255                 NextPackDelta = CurrentPackDelta.add(NextPackYield.mul(CoMargin).div(100));
256             }
257             if(NextPackDelta > 100){
258                 NextPackDelta = NextPackDelta*10**3;
259                 NextPackDelta = ((NextPackDelta/10000)+5)/10;
260                 NextPackDelta = CurrentPackDelta.add(NextPackDelta);
261             }
262             CurrentPackTokenPriceSellout = NextPackTokenPriceBuyout.add(NextPackDelta);
263             CurrentPackCost = PackVolume.mul(CurrentPackTokenPriceSellout);
264             CurrentPackTotalToPay = PackVolume.mul(CurrentPackTokenPriceBuyout);
265             CurrentPackTotalToPayDisparity = PrevPackCost.mul(Disparity).div(100);
266             CurrentPackRestAmt = CurrentPackCost.sub(CurrentPackTotalToPay);
267             CurrentPackTotalAmt = CurrentPackRestAmt.add(PrevPackTotalAmt);
268             CurrentPackFee = PrevPackTotalAmt.sub(CurrentPackTotalToPay).sub(CurrentPackTotalToPayDisparity);
269         }
270         CurrentPackTokenAvailablePercent = balances[address(this)].mul(100).div(PackVolume);
271         emit NextPack(CurrentPackTokenPriceSellout, CurrentPackTokenPriceBuyout);
272     }
273 
274 // The data of the current package can be obtained 
275 // by performing this function.
276 // Available tokens - the remaining number of available 
277 // tokens in the current package. 
278 // At onetime you can not buy more than this number of tokens.
279 // Available tokens in percentage - the percentage of 
280 // remaining available tokens in the current package.
281 // Available amount to deposit in wei - the maximum amount 
282 // that can be deposited in the current package.
283 // Attempt to exceed this amount too much 
284 // (i.e., an attempt to buy more tokens than the Available tokens 
285 // in the current package) will be rejected. 
286 // In case of a small excess of the amount, the unused leftover 
287 // will return to your Ethereum account.
288 // Current pack token price sellout -  the price at which 
289 // tokens are bought by a participant.
290 // Current pack token price buyout - the price at which 
291 // tokens are sold by a participant (are bought by the system).
292 
293     function aboutCurrentPack () public constant returns (uint availableTokens, uint availableTokensInPercentage, uint availableAmountToDepositInWei, uint tokenPriceSellout, uint tokenPriceBuyout){
294         uint _availableTokens = balances[address(this)];
295         uint _availableAmountToDepositInWei = _availableTokens.mul(CurrentPackTokenPriceSellout);
296         return (_availableTokens, CurrentPackTokenAvailablePercent, _availableAmountToDepositInWei, CurrentPackTokenPriceSellout, CurrentPackTokenPriceBuyout);
297     }
298 
299 // Move to the next package. Sending a reward to the owner. 
300 // Minting of new tokens.
301 
302     function nextPack (uint _currentPackNumber) internal { 
303         transferFee();
304         feeTransfered = false;
305         CurrentPackNumber=_currentPackNumber.add(1);
306         CurrentPackStartDate = now;
307         mint(PackVolume);
308         packSettings(CurrentPackNumber);
309     }
310 
311 // Restart occurs if the Disparity mode is enabled and 
312 // there were no new donations within 14 days. 
313 // Everything will start with the first package. 
314 // After restart, the system saves the participant's tokens. 
315 // Moreover, by participating from the very beginning 
316 // (starting from the first package of the new cycle), 
317 // the participant can easily compensate for his 
318 // insignificant losses. And quickly achieve a good profit!
319 
320     function restart(bool _dm)internal{
321         if(_dm==true){if(RestartMode==false){RestartMode=true;RestartModeDate=now;}
322             else{if(now>RestartModeDate+14*1 days){RestartMode=false;DisparityMode=false;nextPack(0);}}}
323         else{if(RestartMode==true){RestartMode=false;RestartModeDate=0;}}
324     }
325 
326 // Sending reward to the owner. 
327 // No more and no less - just as much as it does not hurt. 
328 // Exactly as much as provided by the algorithm.
329 
330     function transferFee()internal{
331         if(CurrentPackNumber > 2 && feeTransfered == false){
332             if(address(this).balance>=CurrentPackFee){
333                 creatorOwner.transfer(CurrentPackFee);
334                 feeTransfered = true;
335             }
336         }
337     }
338 
339 // Receiving a donation and calculating the number of participant tokens. 
340 // Bonuses, penalties.
341 
342     function deposit() public payable returns (uint UserTokenObtain){ 
343         require(msg.sender != 0x0 && msg.sender != 0);
344         require(msg.value < BigAmt); 
345         uint availableTokens = balances[address(this)];
346         require(msg.value <= availableTokens.mul(CurrentPackTokenPriceSellout).add(availableTokens.mul(CurrentPackTokenPriceSellout).mul(10).div(100)).add(10*1 finney)); 
347         require(msg.value.div(CurrentPackTokenPriceSellout) > 0);
348         userAddr = msg.sender;
349         userAmt = msg.value;
350         if(usersWhoBuy[userAddr].UserBuyTokenPackNum == CurrentPackNumber){
351             userTotalAmtDepositCurrentPack = usersWhoBuy[userAddr].UserTotalAmtDepositCurrentPack;
352         }
353         else{
354             userTotalAmtDepositCurrentPack = 0;
355         }
356         if(usersWhoBuy[userAddr].UserBuyTokenPackNum == CurrentPackNumber){
357             require(userTotalAmtDepositCurrentPack.add(userAmt) < BigAmt);
358         }
359 
360 // If the participant making a donation in the current package 
361 // has already received a backward donation in the same package, 
362 // the amount of the new donation is reduced by 5% of the amount
363 // of the received donation; a kind of "penalty" is imposed in 
364 // the amount of 5% of the amount received earlier 
365 // by the participant in the same package.
366 
367         if(usersWhoSell[userAddr].UserSellTokenPackNum == CurrentPackNumber){
368             uint penalty = usersWhoSell[userAddr].UserTotalAmtWithdrawalCurrentPack.mul(5).div(100);
369             userAmt = userAmt.sub(penalty);
370             require(userAmt.div(CurrentPackTokenPriceSellout) > 0);
371             penalty=0;
372         }
373         UserTokenObtain = userAmt.div(CurrentPackTokenPriceSellout);
374         bonus = 0;
375 
376 // Participants who made donation amounting to at least  0.1 ether:
377 // In the 1st day of the current package is entitled to receive 
378 // the amount of possible backward donation to 0.75% more than usual.
379 // In the 2nd day of the current package - 0.5% more than usual.
380 // In the 3rd day of the current package - 0.25% more than usual.
381 
382         if(userAmt >= 100*1 finney){
383             if(now <= (CurrentPackStartDate + 1*1 days)){
384                 bonus = UserTokenObtain.mul(75).div(10000);
385             }
386             if(now > (CurrentPackStartDate + 1*1 days) && now <= (CurrentPackStartDate + 2*1 days)){
387                 bonus = UserTokenObtain.mul(50).div(10000);
388             }
389             if(now > (CurrentPackStartDate + 2*1 days) && now <= (CurrentPackStartDate + 3*1 days)){
390                 bonus = UserTokenObtain.mul(25).div(10000);
391             }
392         }
393 
394 // For continuous long-time participation, 
395 // starting from the second week of participation 
396 // (starting from the 4th participation package), 
397 // bonus incentives for the continuous participation 
398 // of 1% of the contributed amount for each subsequent 
399 // "own" package are accrued for the participant.
400 
401         if(userContinued > 4 && now > (userBuyFirstDate + 1 * 1 weeks)){
402             bonus = bonus.add(UserTokenObtain.mul(1).div(100));
403         }
404         UserTokenObtain = UserTokenObtain.add(bonus);  
405         if(UserTokenObtain > availableTokens){
406             userAmtOverloadToSend = CurrentPackTokenPriceSellout.mul(UserTokenObtain.sub(availableTokens)); 
407             transfer(address(this), userAddr, availableTokens);
408             UserTokenObtain = availableTokens;
409             if(address(this).balance>=userAmtOverloadToSend){
410                 userAddr.transfer(userAmtOverloadToSend);
411             }
412         }                
413         else{                 
414             transfer(address(this), userAddr, UserTokenObtain);
415         }
416         if(usersWhoBuy[userAddr].UserBuyTokenPackNum == 0){
417             userFirstAmt = userAmt;
418             userBuyFirstDate = now;
419         }
420         else{
421             userFirstAmt = usersWhoBuy[userAddr].UserFirstAmt;
422             userBuyFirstDate = usersWhoBuy[userAddr].UserBuyFirstDate;
423         }
424         if(usersWhoBuy[userAddr].UserContinued == 0){
425             userContinued = 1;
426         }
427         else{
428             if(usersWhoBuy[userAddr].UserBuyTokenPackNum == CurrentPackNumber.sub(1)){
429                 userContinued = userContinued.add(1);
430             }
431             else{
432                 userContinued = 1;
433             }
434         }
435         userTotalAmtDepositCurrentPack = userTotalAmtDepositCurrentPack.add(userAmt);
436         addUserWhoBuy(userAddr, userAmt, UserTokenObtain, now, userBuyFirstDate, CurrentPackNumber, userFirstAmt, userContinued, userTotalAmtDepositCurrentPack);
437         CurrentPackTokenAvailablePercent = balances[address(this)].mul(100).div(PackVolume);
438         bonus = 0;
439         availableTokens = 0;
440         userAmtOverloadToSend = 0;
441         userAddr = 0;
442         userAmt = 0;
443         restart(false);
444         DisparityMode = false;
445 
446 // Move to the next pack, if all the tokens of the current one are over.
447 
448         if(balances[address(this)] == 0){nextPack(CurrentPackNumber);}
449         return UserTokenObtain;
450     } 
451 
452 // And here the participant decided to sell his tokens (some or all at once) and sends us his withdrawal request.
453 
454     function withdraw(uint WithdrawAmount, uint WithdrawTokens) public returns (uint withdrawAmt){
455         require(msg.sender != 0x0 && msg.sender != 0);
456         require(WithdrawTokens > 0 || WithdrawAmount > 0);
457         require(WithdrawTokens<=balances[msg.sender]); 
458         require(WithdrawAmount.mul(1 finney)<=balances[msg.sender].mul(CurrentPackTokenPriceSellout).add(balances[msg.sender].mul(CurrentPackTokenPriceSellout).mul(5).div(100)));
459 
460 // If the normal work is braked then Disparity mode is turning on.
461 // If Disparity mode is already enabled, then we check whether it's time to restart.
462 
463         if(RestartMode==true){restart(true);}
464         if(address(this).balance<=CurrentPackTotalToPayDisparity){
465             DisparityMode=true;}else{DisparityMode=false;}
466 
467 // The participant can apply at any time for the selling 
468 // his tokens at the buyout price of the last realized (current) package.
469 // Let calculate how much tokens are returned in the current package, 
470 // and how much was purchased earlier.
471 
472         userTotalAmtWithdrawal = usersWhoSell[msg.sender].UserTotalAmtWithdrawal;
473         if(usersWhoSell[msg.sender].UserSellTokenPackNum == CurrentPackNumber){
474             userTotalAmtWithdrawalCurrentPack = usersWhoSell[msg.sender].UserTotalAmtWithdrawalCurrentPack;
475         }
476         else{
477             userTotalAmtWithdrawalCurrentPack = 0;
478         }
479         if(usersWhoBuy[msg.sender].UserBuyTokenPackNum == CurrentPackNumber && userTotalAmtWithdrawalCurrentPack < usersWhoBuy[msg.sender].UserTotalAmtDepositCurrentPack){
480             returnTokenInCurrentPack = true;
481             withdrawAmtToCurrentPack = usersWhoBuy[msg.sender].UserTotalAmtDepositCurrentPack.sub(userTotalAmtWithdrawalCurrentPack);
482         }
483         else{ 
484             returnTokenInCurrentPack = false;
485         }
486         if(WithdrawAmount > 0){
487             withdrawAmt = WithdrawAmount.mul(1 finney);
488             if(returnTokenInCurrentPack == true){
489                 UserTokensReturnToCurrentPack = withdrawAmtToCurrentPack.div(CurrentPackTokenPriceSellout);
490                 if(withdrawAmt>withdrawAmtToCurrentPack){ 
491                     withdrawAmtAboveCurrentPack = withdrawAmt.sub(withdrawAmtToCurrentPack);
492                     UserTokensReturnAboveCurrentPack = withdrawAmtAboveCurrentPack.div(CurrentPackTokenPriceBuyout);
493                 } 
494                 else{
495                     withdrawAmtToCurrentPack = withdrawAmt;
496                     UserTokensReturnToCurrentPack = withdrawAmtToCurrentPack.div(CurrentPackTokenPriceSellout);
497                     withdrawAmtAboveCurrentPack = 0;
498                     UserTokensReturnAboveCurrentPack = 0;
499                 }
500             }
501             else{
502                 withdrawAmtToCurrentPack = 0;
503                 UserTokensReturnToCurrentPack = 0;
504                 withdrawAmtAboveCurrentPack = withdrawAmt;
505                 UserTokensReturnAboveCurrentPack = withdrawAmtAboveCurrentPack.div(CurrentPackTokenPriceBuyout);
506             }
507         }
508         else{
509             UserTokensReturn = WithdrawTokens;
510             if(returnTokenInCurrentPack == true){
511                 UserTokensReturnToCurrentPack = withdrawAmtToCurrentPack.div(CurrentPackTokenPriceSellout);
512                 if(UserTokensReturn>UserTokensReturnToCurrentPack){
513                     UserTokensReturnAboveCurrentPack = UserTokensReturn.sub(UserTokensReturnToCurrentPack);
514                     withdrawAmtAboveCurrentPack = UserTokensReturnAboveCurrentPack.mul(CurrentPackTokenPriceBuyout);
515                 }
516                 else{
517                     withdrawAmtToCurrentPack = UserTokensReturn.mul(CurrentPackTokenPriceSellout);
518                     UserTokensReturnToCurrentPack = UserTokensReturn;
519                     withdrawAmtAboveCurrentPack = 0;
520                     UserTokensReturnAboveCurrentPack = 0;
521                 }
522             }
523             else{
524                 withdrawAmtToCurrentPack = 0;
525                 UserTokensReturnToCurrentPack = 0;
526                 UserTokensReturnAboveCurrentPack = UserTokensReturn;
527                 withdrawAmtAboveCurrentPack = UserTokensReturnAboveCurrentPack.mul(CurrentPackTokenPriceBuyout);
528             }    
529         }
530         withdrawAmt = withdrawAmtToCurrentPack.add(withdrawAmtAboveCurrentPack);
531 
532 // When applying for a donation, if the remaining number 
533 // of available tokens of the current package is less than 10%, 
534 // participants are entitled to withdraw of 1% more than usual.
535 
536         if(balances[address(this)]<=(PackVolume.mul(10).div(100))){
537             withdrawAmtAboveCurrentPack = withdrawAmtAboveCurrentPack.add(withdrawAmt.mul(1).div(100));
538         }
539 
540 // With each withdrawal, the system checks the total balance 
541 // and if the system is on the verge, when it can pay to each participant 
542 // 70% of his initial donation, the protection mode called "Disparity mode" is activated.
543 // In disparity mode: participant who made a donation in the current package 
544 // can withdraw up to 100% of his initial donation amount,
545 // participant who made a donation earlier (in previous packs) 
546 // can withdraw up to 70% of his initial donation amount.
547 
548         if(address(this).balance<CurrentPackTotalToPayDisparity || withdrawAmt > address(this).balance || DisparityMode == true){
549             uint disparityAmt = usersWhoBuy[msg.sender].UserFirstAmt.mul(Disparity).div(100);
550             if(userTotalAmtWithdrawal >= disparityAmt){
551                 withdrawAmtAboveCurrentPack = 0;
552                 UserTokensReturnAboveCurrentPack = 0;
553             }
554             else{
555                 if(withdrawAmtAboveCurrentPack.add(userTotalAmtWithdrawal) >= disparityAmt){
556                     withdrawAmtAboveCurrentPack = disparityAmt.sub(userTotalAmtWithdrawal);
557                     UserTokensReturnAboveCurrentPack = withdrawAmtAboveCurrentPack.div(CurrentPackTokenPriceBuyout);
558                 }
559             }
560             DisparityMode = true;
561             if(CurrentPackNumber>2){restart(true);}
562         }
563         if(withdrawAmt>address(this).balance){
564             withdrawAmt = address(this).balance;
565             withdrawAmtAboveCurrentPack = address(this).balance.sub(withdrawAmtToCurrentPack);
566             UserTokensReturnAboveCurrentPack = withdrawAmtAboveCurrentPack.div(CurrentPackTokenPriceBuyout);
567             if(CurrentPackNumber>2){restart(true);}
568         }
569         withdrawAmt = withdrawAmtToCurrentPack.add(withdrawAmtAboveCurrentPack);
570         UserTokensReturn = UserTokensReturnToCurrentPack.add(UserTokensReturnAboveCurrentPack);
571         require(UserTokensReturn<=balances[msg.sender]); 
572         transfer(msg.sender, address(this), UserTokensReturn);
573         msg.sender.transfer(withdrawAmt);
574         userTotalAmtWithdrawal = userTotalAmtWithdrawal.add(withdrawAmt);
575         userTotalAmtWithdrawalCurrentPack = userTotalAmtWithdrawalCurrentPack.add(withdrawAmt);
576         addUserWhoSell(msg.sender, withdrawAmt, UserTokensReturn, now, CurrentPackNumber, userTotalAmtWithdrawal, userTotalAmtWithdrawalCurrentPack);
577         CurrentPackTokenAvailablePercent = balances[address(this)].mul(100).div(PackVolume);
578         withdrawAmtToCurrentPack = 0;
579         withdrawAmtAboveCurrentPack = 0;
580         UserTokensReturnToCurrentPack = 0;
581         UserTokensReturnAboveCurrentPack = 0;
582         return withdrawAmt;
583     }
584 
585 // If tokens purchased in the current package are returned, 
586 // they are again available for purchase by other participants.
587 // If tokens purchased in previous packages are returned, 
588 // then such tokens are no longer available to anyone.
589 
590     function transfer(address _from, address _to, uint _value) internal returns (bool success) {
591         balances[_from] = balances[_from].sub(_value); 
592         if(_to == address(this)){ 
593             if(returnTokenInCurrentPack == true){
594                 balances[_to] = balances[_to].add(UserTokensReturnToCurrentPack);
595             }
596             else{
597                 balances[_to] = balances[_to];
598             }
599             totalSupply = totalSupply.sub(UserTokensReturnAboveCurrentPack);
600         }
601         else{
602             balances[_to] = balances[_to].add(_value);
603         }
604         emit Transfer(_from, _to, _value); 
605         return true;
606     }  
607 
608 // BalanceOf — get balance of tokens.
609 
610     function balanceOf(address tokenOwner) public constant returns (uint balance) {
611         return balances[tokenOwner];
612     }
613 
614 // Minting new tokens if the moving to a new package occurred.
615 
616     function mint(uint _value) internal returns (bool) {
617         balances[address(this)] = balances[address(this)].add(_value);
618         totalSupply = totalSupply.add(_value);
619         return true;
620     }
621 
622     event Transfer(address indexed _from, address indexed _to, uint _value);
623     event NextPack(uint indexed CurrentPackTokenPriceSellout, uint indexed CurrentPackTokenPriceBuyout);
624 }