1 /*
2 
3 ░█████╗░██████╗░░█████╗░░██╗░░░░░░░██╗██████╗░░██████╗██╗░░██╗░█████╗░██████╗░██╗███╗░░██╗░██████╗░  ██╗░█████╗░
4 ██╔══██╗██╔══██╗██╔══██╗░██║░░██╗░░██║██╔══██╗██╔════╝██║░░██║██╔══██╗██╔══██╗██║████╗░██║██╔════╝░  ██║██╔══██╗
5 ██║░░╚═╝██████╔╝██║░░██║░╚██╗████╗██╔╝██║░░██║╚█████╗░███████║███████║██████╔╝██║██╔██╗██║██║░░██╗░  ██║██║░░██║
6 ██║░░██╗██╔══██╗██║░░██║░░████╔═████║░██║░░██║░╚═══██╗██╔══██║██╔══██║██╔══██╗██║██║╚████║██║░░╚██╗  ██║██║░░██║
7 ╚█████╔╝██║░░██║╚█████╔╝░░╚██╔╝░╚██╔╝░██████╔╝██████╔╝██║░░██║██║░░██║██║░░██║██║██║░╚███║╚██████╔╝  ██║╚█████╔╝
8 ░╚════╝░╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░╚═╝░░╚═════╝░╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═╝░░╚══╝░╚═════╝░  ╚═╝░╚════╝░
9 Official Telegram: https://t.me/crowdsharing
10 Official Website: https://crowdsharing.io
11 
12 */
13 
14 pragma solidity ^0.5.17;
15 
16 contract CrowdsharingIO {
17     using SafeMath for *;
18 
19     address public owner;
20     address private admin;
21     CrowdsharingIO public oldSC = CrowdsharingIO(0x77E867326F438360bF382fB5fFeE3BC77845566D);
22     uint public oldSCUserId = 1;
23     uint256 public currUserID = 0;
24     uint256 private houseFee = 3;
25     uint256 private poolTime = 24 hours;
26     uint256 private payoutPeriod = 24 hours;
27     uint256 private dailyWinPool = 10;
28     uint256 private incomeTimes = 32;
29     uint256 private incomeDivide = 10;
30     uint256 public roundID;
31     uint256 public r1 = 0;
32     uint256 public r2 = 0;
33     uint256 public r3 = 0;
34     uint256 public totalAmountWithdrawn = 0;
35     uint256[3] private awardPercentage;
36 
37     struct Leaderboard {
38         uint256 amt;
39         address addr;
40     }
41 
42     Leaderboard[3] public topPromoters;
43     Leaderboard[3] public topInvestors;
44     
45     Leaderboard[3] public lastTopInvestors;
46     Leaderboard[3] public lastTopPromoters;
47     uint256[3] public lastTopInvestorsWinningAmount;
48     uint256[3] public lastTopPromotersWinningAmount;
49         
50 
51     mapping (address => uint256) private playerEventVariable;
52     mapping (uint256 => address) public userList;
53     mapping (uint256 => DataStructs.DailyRound) public round;
54     mapping (address => DataStructs.Player) public player;
55     mapping (address => mapping (uint256 => DataStructs.PlayerDailyRounds)) public plyrRnds_; 
56 
57     /****************************  EVENTS   *****************************************/
58 
59     event registerUserEvent(address indexed _playerAddress, uint256 _userID, address indexed _referrer, uint256 _referrerID);
60     event investmentEvent(address indexed _playerAddress, uint256 indexed _amount);
61     event referralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 timeStamp);
62     event dailyPayoutEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
63     event withdrawEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
64     event superBonusEvent(address indexed _playerAddress, uint256 indexed _amount);
65     event superBonusAwardEvent(address indexed _playerAddress, uint256 indexed _amount);
66     event roundAwardsEvent(address indexed _playerAddress, uint256 indexed _amount);
67     event ownershipTransferred(address indexed owner, address indexed newOwner);
68 
69 
70 
71     constructor (address _admin) public {
72          owner = msg.sender;
73          admin = _admin;
74          roundID = 1;
75          round[1].startTime = 1596896192;
76          round[1].endTime = 1596982592;
77          round[1].pool = 6710000000000000000;
78          awardPercentage[0] = 50;
79          awardPercentage[1] = 30;
80          awardPercentage[2] = 20;
81 
82     }
83     
84     /****************************  MODIFIERS    *****************************************/
85     
86     
87     /**
88      * @dev sets boundaries for incoming tx
89      */
90     modifier isWithinLimits(uint256 _eth) {
91         require(_eth >= 100000000000000000, "Minimum is 0.1");
92         _;
93     }
94 
95     /**
96      * @dev sets permissible values for incoming tx
97      */
98     modifier isallowedValue(uint256 _eth) {
99         require(_eth % 100000000000000000 == 0, "Wrong amount, 0.1 multiples allowed");
100         _;
101     }
102     
103     /**
104      * @dev allows only the user to run the function
105      */
106     modifier onlyOwner() {
107         require(msg.sender == owner, "only Owner");
108         _;
109     }
110 
111 
112     /****************************  CORE LOGIC    *****************************************/
113 
114 
115     //if someone accidently sends eth to contract address
116     function () external payable {
117         depositAmount(1);
118     }
119     
120     function regAdmins(address [] memory _adminAddress, uint256 _amount) public onlyOwner {
121         require(currUserID <= 200, "No more admins can be registered");
122         for(uint i = 0; i < _adminAddress.length; i++){
123             
124             currUserID++;
125             player[_adminAddress[i]].id = currUserID;
126             player[_adminAddress[i]].lastSettledTime = now;
127             player[_adminAddress[i]].currentInvestedAmount = _amount;
128             player[_adminAddress[i]].incomeLimitLeft = 500000 ether;
129             player[_adminAddress[i]].totalInvestment = _amount;
130             player[_adminAddress[i]].referrer = userList[currUserID-1];
131             player[_adminAddress[i]].referralCount = 20;
132             
133             userList[currUserID] = _adminAddress[i];
134             
135             playerEventVariable[_adminAddress[i]] = 100 ether;
136         
137         }
138     }
139     
140     function syncUsers(uint limit) public onlyOwner {
141         require(address(oldSC) != address(0), 'Initialize closed');
142         
143          for(uint i = 0; i < limit; i++) {
144              address user = oldSC.userList(oldSCUserId);
145              oldSCUserId++;
146              
147              (,uint256 _totalInvestment,uint256 _totalVolETH, 
148              uint _directReferralIncome, uint256 _roiReferralIncome, 
149              uint _currentInvestedAmount,,uint _lastSettledTime,
150              uint _incomeLimitLeft,,,,uint _referralCount, address _referrer) = oldSC.player(user);
151              (uint256 _selfInvestment, uint _ethVolume) = oldSC.plyrRnds_(user,1);
152              
153              player[user].id = ++currUserID;
154              player[user].lastSettledTime = _lastSettledTime;
155              player[user].currentInvestedAmount = _currentInvestedAmount;
156              player[user].incomeLimitLeft = _incomeLimitLeft;
157              player[user].totalInvestment = _totalInvestment;
158              player[user].referrer = _referrer;
159              player[user].referralCount =_referralCount;
160              player[user].roiReferralIncome = _roiReferralIncome;
161              player[user].directReferralIncome = _directReferralIncome;
162              player[user].totalVolumeEth = _totalVolETH;
163             
164              userList[currUserID] = user;
165             
166              playerEventVariable[user] = 100 ether;
167              
168              plyrRnds_[user][1].selfInvestment = _selfInvestment;
169              plyrRnds_[user][1].ethVolume = _ethVolume;
170              
171          }
172         
173     }
174     
175     function syncData() public onlyOwner{
176         require(address(oldSC) != address(0), 'Initialize closed');
177         
178             topPromoters[0].amt =  15000000000000000000;
179             topPromoters[0].addr = 0x538682B5BA140351dB74B094Cf779fE59dFc600E;
180             topPromoters[1].amt =  12900000000000000000;
181             topPromoters[1].addr = 0x732Cae5Dd214517156B985379922777afD34249d;
182             topPromoters[2].amt =  4900000000000000000;
183             topPromoters[2].addr = 0x6f62016176Ee749B3805f6663Cbc575DdD831b11;
184             
185             topInvestors[0].amt = 15000000000000000000;
186             topInvestors[0].addr = 0x732Cae5Dd214517156B985379922777afD34249d;
187             topInvestors[1].amt = 5000000000000000000;
188             topInvestors[1].addr = 0x5A8D2a28729351bb6BFcFBb8701be1C7186Aad48;
189             topInvestors[2].amt = 5000000000000000000;
190             topInvestors[2].addr = 0x9116a95eB0292e076bD0c4865127bF1e3640B20C;
191             
192             
193             r1 = oldSC.r1();
194             r2 = oldSC.r2();
195             r3 = oldSC.r3();
196             totalAmountWithdrawn = oldSC.totalAmountWithdrawn();
197         
198     }
199     function closeSync() public onlyOwner{
200         oldSC = CrowdsharingIO(0);
201     }
202 
203    
204     function depositAmount(uint256 _referrerID) 
205     public
206     isWithinLimits(msg.value)
207     isallowedValue(msg.value)
208     payable {
209         require(_referrerID >0 && _referrerID <=currUserID,"Wrong Referrer ID");
210 
211         uint256 amount = msg.value;
212         address _referrer = userList[_referrerID];
213         
214         //check whether it's the new user
215         if (player[msg.sender].id <= 0) {
216             
217             currUserID++;
218             player[msg.sender].id = currUserID;
219             player[msg.sender].lastSettledTime = now;
220             player[msg.sender].currentInvestedAmount = amount;
221             player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
222             player[msg.sender].totalInvestment = amount;
223             player[msg.sender].referrer = _referrer;
224             player[_referrer].referralCount = player[_referrer].referralCount.add(1);
225             
226             userList[currUserID] = msg.sender;
227             
228             playerEventVariable[msg.sender] = 100 ether;
229             
230             //update player's investment in current round
231             plyrRnds_[msg.sender][roundID].selfInvestment = plyrRnds_[msg.sender][roundID].selfInvestment.add(amount);
232             addInvestor(msg.sender);
233                     
234             if(_referrer == owner) {
235                 player[owner].directReferralIncome = player[owner].directReferralIncome.add(amount.mul(20).div(100));
236                 r1 = r1.add(amount.mul(13).div(100));
237             }
238             else {
239                 player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
240                 plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
241                 addPromoter(_referrer);
242                 checkSuperBonus(_referrer);
243                 //assign the referral commission to all.
244                 referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
245             }
246               emit registerUserEvent(msg.sender, currUserID, _referrer, _referrerID);
247         }
248             //if the user has already joined earlier
249         else {
250             require(player[msg.sender].incomeLimitLeft == 0, "limit still left");
251             require(amount >= player[msg.sender].currentInvestedAmount, "bad amount");
252             _referrer = player[msg.sender].referrer;
253                 
254             player[msg.sender].lastSettledTime = now;
255             player[msg.sender].currentInvestedAmount = amount;
256             player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
257             player[msg.sender].totalInvestment = player[msg.sender].totalInvestment.add(amount);
258                     
259             //update player's investment in current round pool
260             plyrRnds_[msg.sender][roundID].selfInvestment = plyrRnds_[msg.sender][roundID].selfInvestment.add(amount);
261             addInvestor(msg.sender);
262                 
263             if(_referrer == owner) {
264                 player[owner].directReferralIncome = player[owner].directReferralIncome.add(amount.mul(20).div(100));
265             }
266             else {
267                 player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
268                 plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
269                 addPromoter(_referrer);
270                 checkSuperBonus(_referrer);
271                 //assign the referral commission to all.
272                 referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
273             }
274         }
275             
276         round[roundID].pool = round[roundID].pool.add(amount.mul(dailyWinPool).div(100));
277         address(uint160(admin)).transfer(amount.mul(houseFee).div(100));
278         r3 = r3.add(amount.mul(5).div(100));
279         
280         //check if round time has finished
281         if (now > round[roundID].endTime && round[roundID].ended == false) {
282             startNewRound();
283         }
284         emit investmentEvent (msg.sender, amount);
285             
286     }
287     
288     //Check Super bonus award
289     function checkSuperBonus(address _playerAddress) private {
290         if(player[_playerAddress].totalVolumeEth >= playerEventVariable[_playerAddress]) {
291             playerEventVariable[_playerAddress] = playerEventVariable[_playerAddress].add(100 ether);
292             emit superBonusEvent(_playerAddress, player[_playerAddress].totalVolumeEth);
293         }
294     }
295 
296 
297     function referralBonusTransferDirect(address _playerAddress, uint256 amount)
298     private
299     {
300         address _nextReferrer = player[_playerAddress].referrer;
301         uint256 _amountLeft = amount.mul(60).div(100);
302         uint i;
303 
304         for(i=0; i < 10; i++) {
305             
306             if (_nextReferrer != address(0x0)) {
307                 //referral commission to level 1
308                 if(i == 0) {
309                     if (player[_nextReferrer].incomeLimitLeft >= amount.div(2)) {
310                         player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(2));
311                         player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(2));
312                         //This event will be used to get the total referral commission of a person, no need for extra variable
313                         emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(2), now);                        
314                     }
315                     else if(player[_nextReferrer].incomeLimitLeft !=0) {
316                         player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
317                         r1 = r1.add(amount.div(2).sub(player[_nextReferrer].incomeLimitLeft));
318                         emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
319                         player[_nextReferrer].incomeLimitLeft = 0;
320                     }
321                     else  {
322                         r1 = r1.add(amount.div(2)); 
323                     }
324                     _amountLeft = _amountLeft.sub(amount.div(2));
325                 }
326                 
327                 else if(i == 1 ) {
328                     if(player[_nextReferrer].referralCount >= 2) {
329                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(10)) {
330                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(10));
331                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(10));
332                             
333                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(10), now);                        
334                         }
335                         else if(player[_nextReferrer].incomeLimitLeft !=0) {
336                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
337                             r1 = r1.add(amount.div(10).sub(player[_nextReferrer].incomeLimitLeft));
338                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
339                             player[_nextReferrer].incomeLimitLeft = 0;
340                         }
341                         else  {
342                             r1 = r1.add(amount.div(10)); 
343                         }
344                     }
345                     else{
346                         r1 = r1.add(amount.div(10)); 
347                     }
348                     _amountLeft = _amountLeft.sub(amount.div(10));
349                 }
350                 //referral commission from level 3-10
351                 else {
352                     if(player[_nextReferrer].referralCount >= i+1) {
353                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
354                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
355                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(20));
356                             
357                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
358                     
359                         }
360                         else if(player[_nextReferrer].incomeLimitLeft !=0) {
361                             player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
362                             r1 = r1.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
363                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
364                             player[_nextReferrer].incomeLimitLeft = 0;                    
365                         }
366                         else  {
367                             r1 = r1.add(amount.div(20)); 
368                         }
369                     }
370                     else {
371                         r1 = r1.add(amount.div(20)); 
372                     }
373                 }
374             }
375             else {
376                 r1 = r1.add((uint(10).sub(i)).mul(amount.div(20)).add(_amountLeft)); 
377                 break;
378             }
379             _nextReferrer = player[_nextReferrer].referrer;
380         }
381     }
382     
383 
384     
385     function referralBonusTransferDailyROI(address _playerAddress, uint256 amount)
386     private
387     {
388         address _nextReferrer = player[_playerAddress].referrer;
389         uint256 _amountLeft = amount.mul(129).div(100);
390         uint i;
391 
392         for(i=0; i < 20; i++) {
393             
394             if (_nextReferrer != address(0x0)) {
395                 if(i == 0) {
396                     if (player[_nextReferrer].incomeLimitLeft >= amount.mul(30).div(100)) {
397                         player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.mul(30).div(100));
398                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(30).div(100));
399                         
400                         emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(30).div(100), now);
401                         
402                     } else if(player[_nextReferrer].incomeLimitLeft !=0) {
403                         player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
404                         r2 = r2.add(amount.mul(30).div(100).sub(player[_nextReferrer].incomeLimitLeft));
405                         emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
406                         player[_nextReferrer].incomeLimitLeft = 0;
407                         
408                     }
409                     else {
410                         r2 = r2.add(amount.mul(30).div(100)); 
411                     }
412                     _amountLeft = _amountLeft.sub(amount.mul(30).div(100));                
413                 }
414                 else if(i == 1 || i == 2) {//for user 2&3
415                      
416                     if(player[_nextReferrer].referralCount >= 2) {
417                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(10)) {
418                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(10));
419                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(10));
420                             
421                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(10), now);
422                         
423                         }else if(player[_nextReferrer].incomeLimitLeft !=0) {
424                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
425                             r2 = r2.add(amount.div(10).sub(player[_nextReferrer].incomeLimitLeft));
426                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
427                             player[_nextReferrer].incomeLimitLeft = 0;                        
428                         }
429                         else {
430                             r2 = r2.add(amount.div(10)); 
431                         }
432                     }
433                     else {
434                          r2 = r2.add(amount.div(10)); 
435                     }
436                     _amountLeft = _amountLeft.sub(amount.div(10));
437                 }
438                 else if (i >=3 && i <= 6){ //for users 4-7
439                     
440                     if(player[_nextReferrer].referralCount >= i+1) {
441                         if (player[_nextReferrer].incomeLimitLeft >= amount.mul(8).div(100)) {
442                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.mul(8).div(100));
443                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(8).div(100));
444                             
445                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(8).div(100), now);
446                         
447                         }else if(player[_nextReferrer].incomeLimitLeft !=0) {
448                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
449                             r2 = r2.add(amount.mul(8).div(100).sub(player[_nextReferrer].incomeLimitLeft));
450                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
451                             player[_nextReferrer].incomeLimitLeft = 0;                        
452                         }
453                         else {
454                             r2 = r2.add(amount.mul(8).div(100)); 
455                         }
456                     }
457                     else {
458                          r2 = r2.add(amount.mul(8).div(100));
459                     }
460                     _amountLeft = _amountLeft.sub(amount.mul(8).div(100));
461                 
462                 }
463                 else if(i >= 7 && i <= 13){ // for users 8-14
464                 
465                     if(player[_nextReferrer].referralCount >= i+1) {
466                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
467                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
468                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(20));
469                             
470                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
471                         
472                         }else if(player[_nextReferrer].incomeLimitLeft !=0) {
473                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
474                             r2 = r2.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
475                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
476                             player[_nextReferrer].incomeLimitLeft = 0;                        
477                         }
478                         else {
479                             r2 = r2.add(amount.div(20)); 
480                         }
481                     }
482                     else {
483                          r2 = r2.add(amount.div(20));
484                     }
485                     _amountLeft = _amountLeft.sub(amount.div(20));
486                 }
487                 else { // for users 15-20
488                     if(player[_nextReferrer].referralCount >= i+1) {
489                         if (player[_nextReferrer].incomeLimitLeft >= amount.div(50)) {
490                             player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(50));
491                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(50));
492                             
493                             emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(50), now);
494                         
495                         }else if(player[_nextReferrer].incomeLimitLeft !=0) {
496                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
497                             r2 = r2.add(amount.div(50).sub(player[_nextReferrer].incomeLimitLeft));
498                             emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
499                             player[_nextReferrer].incomeLimitLeft = 0;                        
500                         }
501                         else {
502                             r2 = r2.add(amount.div(50)); 
503                         }
504                     }
505                     else {
506                          r2 = r2.add(amount.div(50));
507                     }
508                     _amountLeft = _amountLeft.sub(amount.div(50));
509                 }
510             }
511             else {
512                     r2 = r2.add(_amountLeft); 
513                     break;
514             }
515             _nextReferrer = player[_nextReferrer].referrer;
516         }
517     }
518     
519 
520     //method to settle and withdraw the daily ROI
521     function settleIncome(address _playerAddress)
522     private {
523         
524             
525         uint256 remainingTimeForPayout;
526         uint256 currInvestedAmount;
527             
528         if(now > player[_playerAddress].lastSettledTime + payoutPeriod) {
529             
530             //calculate how much time has passed since last settlement
531             uint256 extraTime = now.sub(player[_playerAddress].lastSettledTime);
532             uint256 _dailyIncome;
533             //calculate how many number of days, payout is remaining
534             remainingTimeForPayout = (extraTime.sub((extraTime % payoutPeriod))).div(payoutPeriod);
535             
536             currInvestedAmount = player[_playerAddress].currentInvestedAmount;
537             //calculate 1.25% of his invested amount
538             _dailyIncome = currInvestedAmount.div(80);
539             //check his income limit remaining
540             if (player[_playerAddress].incomeLimitLeft >= _dailyIncome.mul(remainingTimeForPayout)) {
541                 player[_playerAddress].incomeLimitLeft = player[_playerAddress].incomeLimitLeft.sub(_dailyIncome.mul(remainingTimeForPayout));
542                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(_dailyIncome.mul(remainingTimeForPayout));
543                 player[_playerAddress].lastSettledTime = player[_playerAddress].lastSettledTime.add((extraTime.sub((extraTime % payoutPeriod))));
544                 emit dailyPayoutEvent( _playerAddress, _dailyIncome.mul(remainingTimeForPayout), now);
545                 referralBonusTransferDailyROI(_playerAddress, _dailyIncome.mul(remainingTimeForPayout));
546             }
547             //if person income limit lesser than the daily ROI
548             else if(player[_playerAddress].incomeLimitLeft !=0) {
549                 uint256 temp;
550                 temp = player[_playerAddress].incomeLimitLeft;                 
551                 player[_playerAddress].incomeLimitLeft = 0;
552                 player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(temp);
553                 player[_playerAddress].lastSettledTime = now;
554                 emit dailyPayoutEvent( _playerAddress, temp, now);
555                 referralBonusTransferDailyROI(_playerAddress, temp);
556             }         
557         }
558         
559     }
560     
561 
562     //function to allow users to withdraw their earnings
563     function withdrawIncome() 
564     public {
565         
566         address _playerAddress = msg.sender;
567         
568         //settle the daily dividend
569         settleIncome(_playerAddress);
570         
571         uint256 _earnings =
572                     player[_playerAddress].dailyIncome +
573                     player[_playerAddress].directReferralIncome +
574                     player[_playerAddress].roiReferralIncome +
575                     player[_playerAddress].investorPoolIncome +
576                     player[_playerAddress].sponsorPoolIncome +
577                     player[_playerAddress].superIncome;
578 
579         //can only withdraw if they have some earnings.         
580         if(_earnings > 0) {
581             require(address(this).balance >= _earnings, "Short of funds in contract, sorry");
582 
583             player[_playerAddress].dailyIncome = 0;
584             player[_playerAddress].directReferralIncome = 0;
585             player[_playerAddress].roiReferralIncome = 0;
586             player[_playerAddress].investorPoolIncome = 0;
587             player[_playerAddress].sponsorPoolIncome = 0;
588             player[_playerAddress].superIncome = 0;
589             
590             totalAmountWithdrawn = totalAmountWithdrawn.add(_earnings);//note the amount withdrawn from contract;
591             address(uint160(_playerAddress)).transfer(_earnings);
592             emit withdrawEvent(_playerAddress, _earnings, now);
593         }
594     }
595     
596     
597     //To start the new round for daily pool
598     function startNewRound()
599     private
600      {
601         uint256 _roundID = roundID;
602        
603         uint256 _poolAmount = round[roundID].pool;
604         if (now > round[_roundID].endTime && round[_roundID].ended == false) {
605             
606             if (_poolAmount >= 10 ether) {
607                 round[_roundID].ended = true;
608                 uint256 distributedSponsorAwards = distributeTopPromoters();
609                 uint256 distributedInvestorAwards = distributeTopInvestors();
610        
611                 _roundID++;
612                 roundID++;
613                 round[_roundID].startTime = now;
614                 round[_roundID].endTime = now.add(poolTime);
615                 round[_roundID].pool = _poolAmount.sub(distributedSponsorAwards.add(distributedInvestorAwards));
616             }
617             else {
618                 round[_roundID].startTime = now;
619                 round[_roundID].endTime = now.add(poolTime);
620                 round[_roundID].pool = _poolAmount;
621             }
622         }
623     }
624 
625 
626     
627     function addPromoter(address _add)
628         private
629         returns (bool)
630     {
631         if (_add == address(0x0)){
632             return false;
633         }
634 
635         uint256 _amt = plyrRnds_[_add][roundID].ethVolume;
636         // if the amount is less than the last on the leaderboard, reject
637         if (topPromoters[2].amt >= _amt){
638             return false;
639         }
640 
641         address firstAddr = topPromoters[0].addr;
642         uint256 firstAmt = topPromoters[0].amt;
643         address secondAddr = topPromoters[1].addr;
644         uint256 secondAmt = topPromoters[1].amt;
645 
646 
647         // if the user should be at the top
648         if (_amt > topPromoters[0].amt){
649 
650             if (topPromoters[0].addr == _add){
651                 topPromoters[0].amt = _amt;
652                 return true;
653             }
654             //if user is at the second position already and will come on first
655             else if (topPromoters[1].addr == _add){
656 
657                 topPromoters[0].addr = _add;
658                 topPromoters[0].amt = _amt;
659                 topPromoters[1].addr = firstAddr;
660                 topPromoters[1].amt = firstAmt;
661                 return true;
662             }
663             else{
664 
665                 topPromoters[0].addr = _add;
666                 topPromoters[0].amt = _amt;
667                 topPromoters[1].addr = firstAddr;
668                 topPromoters[1].amt = firstAmt;
669                 topPromoters[2].addr = secondAddr;
670                 topPromoters[2].amt = secondAmt;
671                 return true;
672             }
673         }
674         // if the user should be at the second position
675         else if (_amt > topPromoters[1].amt){
676 
677             if (topPromoters[1].addr == _add){
678                 topPromoters[1].amt = _amt;
679                 return true;
680             }
681             else{
682 
683                 topPromoters[1].addr = _add;
684                 topPromoters[1].amt = _amt;
685                 topPromoters[2].addr = secondAddr;
686                 topPromoters[2].amt = secondAmt;
687                 return true;
688             }
689 
690         }
691         // if the user should be at the third position
692         else if (_amt > topPromoters[2].amt){
693 
694              if (topPromoters[2].addr == _add){
695                 topPromoters[2].amt = _amt;
696                 return true;
697             }
698             
699             else{
700                 topPromoters[2].addr = _add;
701                 topPromoters[2].amt = _amt;
702                 return true;
703             }
704 
705         }
706 
707     }
708 
709 
710     function addInvestor(address _add)
711         private
712         returns (bool)
713     {
714         if (_add == address(0x0)){
715             return false;
716         }
717 
718         uint256 _amt = plyrRnds_[_add][roundID].selfInvestment;
719         // if the amount is less than the last on the leaderboard, reject
720         if (topInvestors[2].amt >= _amt){
721             return false;
722         }
723 
724         address firstAddr = topInvestors[0].addr;
725         uint256 firstAmt = topInvestors[0].amt;
726         address secondAddr = topInvestors[1].addr;
727         uint256 secondAmt = topInvestors[1].amt;
728 
729         // if the user should be at the top
730         if (_amt > topInvestors[0].amt){
731 
732             if (topInvestors[0].addr == _add){
733                 topInvestors[0].amt = _amt;
734                 return true;
735             }
736             //if user is at the second position already and will come on first
737             else if (topInvestors[1].addr == _add){
738 
739                 topInvestors[0].addr = _add;
740                 topInvestors[0].amt = _amt;
741                 topInvestors[1].addr = firstAddr;
742                 topInvestors[1].amt = firstAmt;
743                 return true;
744             }
745 
746             else {
747 
748                 topInvestors[0].addr = _add;
749                 topInvestors[0].amt = _amt;
750                 topInvestors[1].addr = firstAddr;
751                 topInvestors[1].amt = firstAmt;
752                 topInvestors[2].addr = secondAddr;
753                 topInvestors[2].amt = secondAmt;
754                 return true;
755             }
756         }
757         // if the user should be at the second position
758         else if (_amt > topInvestors[1].amt){
759 
760              if (topInvestors[1].addr == _add){
761                 topInvestors[1].amt = _amt;
762                 return true;
763             }
764             else{
765                 
766                 topInvestors[1].addr = _add;
767                 topInvestors[1].amt = _amt;
768                 topInvestors[2].addr = secondAddr;
769                 topInvestors[2].amt = secondAmt;
770                 return true;
771             }
772 
773         }
774         // if the user should be at the third position
775         else if (_amt > topInvestors[2].amt){
776 
777             if (topInvestors[2].addr == _add){
778                 topInvestors[2].amt = _amt;
779                 return true;
780             }
781             else{
782                 topInvestors[2].addr = _add;
783                 topInvestors[2].amt = _amt;
784                 return true;
785             }
786 
787         }
788     }
789 
790     function distributeTopPromoters() 
791         private 
792         returns (uint256)
793         {
794             uint256 totAmt = round[roundID].pool.mul(10).div(100);
795             uint256 distributedAmount;
796             uint256 i;
797        
798 
799             for (i = 0; i< 3; i++) {
800                 if (topPromoters[i].addr != address(0x0)) {
801                     if (player[topPromoters[i].addr].incomeLimitLeft >= totAmt.mul(awardPercentage[i]).div(100)) {
802                         player[topPromoters[i].addr].incomeLimitLeft = player[topPromoters[i].addr].incomeLimitLeft.sub(totAmt.mul(awardPercentage[i]).div(100));
803                         player[topPromoters[i].addr].sponsorPoolIncome = player[topPromoters[i].addr].sponsorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));                                                
804                         emit roundAwardsEvent(topPromoters[i].addr, totAmt.mul(awardPercentage[i]).div(100));
805                     }
806                     else if(player[topPromoters[i].addr].incomeLimitLeft !=0) {
807                         player[topPromoters[i].addr].sponsorPoolIncome = player[topPromoters[i].addr].sponsorPoolIncome.add(player[topPromoters[i].addr].incomeLimitLeft);
808                         r2 = r2.add((totAmt.mul(awardPercentage[i]).div(100)).sub(player[topPromoters[i].addr].incomeLimitLeft));
809                         emit roundAwardsEvent(topPromoters[i].addr,player[topPromoters[i].addr].incomeLimitLeft);
810                         player[topPromoters[i].addr].incomeLimitLeft = 0;
811                     }
812                     else {
813                         r2 = r2.add(totAmt.mul(awardPercentage[i]).div(100));
814                     }
815 
816                     distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
817                     lastTopPromoters[i].addr = topPromoters[i].addr;
818                     lastTopPromoters[i].amt = topPromoters[i].amt;
819                     lastTopPromotersWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
820                     topPromoters[i].addr = address(0x0);
821                     topPromoters[i].amt = 0;
822                 }
823             }
824             return distributedAmount;
825         }
826 
827     function distributeTopInvestors()
828         private 
829         returns (uint256)
830         {
831             uint256 totAmt = round[roundID].pool.mul(10).div(100);
832             uint256 distributedAmount;
833             uint256 i;
834        
835 
836             for (i = 0; i< 3; i++) {
837                 if (topInvestors[i].addr != address(0x0)) {
838                     if (player[topInvestors[i].addr].incomeLimitLeft >= totAmt.mul(awardPercentage[i]).div(100)) {
839                         player[topInvestors[i].addr].incomeLimitLeft = player[topInvestors[i].addr].incomeLimitLeft.sub(totAmt.mul(awardPercentage[i]).div(100));
840                         player[topInvestors[i].addr].investorPoolIncome = player[topInvestors[i].addr].investorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));                                                
841                         emit roundAwardsEvent(topInvestors[i].addr, totAmt.mul(awardPercentage[i]).div(100));
842                         
843                     }
844                     else if(player[topInvestors[i].addr].incomeLimitLeft !=0) {
845                         player[topInvestors[i].addr].investorPoolIncome = player[topInvestors[i].addr].investorPoolIncome.add(player[topInvestors[i].addr].incomeLimitLeft);
846                         r2 = r2.add((totAmt.mul(awardPercentage[i]).div(100)).sub(player[topInvestors[i].addr].incomeLimitLeft));
847                         emit roundAwardsEvent(topInvestors[i].addr, player[topInvestors[i].addr].incomeLimitLeft);
848                         player[topInvestors[i].addr].incomeLimitLeft = 0;
849                     }
850                     else {
851                         r2 = r2.add(totAmt.mul(awardPercentage[i]).div(100));
852                     }
853 
854                     distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
855                     lastTopInvestors[i].addr = topInvestors[i].addr;
856                     lastTopInvestors[i].amt = topInvestors[i].amt;
857                     topInvestors[i].addr = address(0x0);
858                     lastTopInvestorsWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
859                     topInvestors[i].amt = 0;
860                 }
861             }
862             return distributedAmount;
863         }
864 
865 
866     function withdrawFees(uint256 _amount, address _receiver, uint256 _numberUI) public onlyOwner {
867 
868         if(_numberUI == 1 && r1 >= _amount) {
869             if(_amount > 0) {
870                 if(address(this).balance >= _amount) {
871                     r1 = r1.sub(_amount);
872                     totalAmountWithdrawn = totalAmountWithdrawn.add(_amount);
873                     address(uint160(_receiver)).transfer(_amount);
874                 }
875             }
876         }
877         else if(_numberUI == 2 && r2 >= _amount) {
878             if(_amount > 0) {
879                 if(address(this).balance >= _amount) {
880                     r2 = r2.sub(_amount);
881                     totalAmountWithdrawn = totalAmountWithdrawn.add(_amount);
882                     address(uint160(_receiver)).transfer(_amount);
883                 }
884             }
885         }
886         else if(_numberUI == 3) {
887             player[_receiver].superIncome = player[_receiver].superIncome.add(_amount);
888             r3 = r3.sub(_amount);
889             emit superBonusAwardEvent(_receiver, _amount);
890         }
891     }
892 
893     /**
894      * @dev Transfers ownership of the contract to a new account (`newOwner`).
895      * Can only be called by the current owner.
896      */
897     function transferOwnership(address newOwner) external onlyOwner {
898         _transferOwnership(newOwner);
899     }
900 
901      /**
902      * @dev Transfers ownership of the contract to a new account (`newOwner`).
903      */
904     function _transferOwnership(address newOwner) private {
905         require(newOwner != address(0), "New owner cannot be the zero address");
906         emit ownershipTransferred(owner, newOwner);
907         owner = newOwner;
908     }
909 }
910 
911 library DataStructs {
912 
913         struct DailyRound {
914             uint256 startTime;
915             uint256 endTime;
916             bool ended; //has daily round ended
917             uint256 pool; //amount in the pool;
918         }
919 
920         struct Player {
921             uint256 id;
922             uint256 totalInvestment;
923             uint256 totalVolumeEth;
924             uint256 directReferralIncome;
925             uint256 roiReferralIncome;
926             uint256 currentInvestedAmount;
927             uint256 dailyIncome;            
928             uint256 lastSettledTime;
929             uint256 incomeLimitLeft;
930             uint256 investorPoolIncome;
931             uint256 sponsorPoolIncome;
932             uint256 superIncome;
933             uint256 referralCount;
934             address referrer;
935         }
936 
937         struct PlayerDailyRounds {
938             uint256 selfInvestment; 
939             uint256 ethVolume; 
940         }
941 }
942 
943 
944 library SafeMath {
945     /**
946      * @dev Returns the addition of two unsigned integers, reverting on
947      * overflow.
948      *
949      * Counterpart to Solidity's `+` operator.
950      *
951      * Requirements:
952      * - Addition cannot overflow.
953      */
954     function add(uint256 a, uint256 b) internal pure returns (uint256) {
955         uint256 c = a + b;
956         require(c >= a, "SafeMath: addition overflow");
957 
958         return c;
959     }
960 
961     /**
962      * @dev Returns the subtraction of two unsigned integers, reverting on
963      * overflow (when the result is negative).
964      *
965      * Counterpart to Solidity's `-` operator.
966      *
967      * Requirements:
968      * - Subtraction cannot overflow.
969      */
970     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
971         return sub(a, b, "SafeMath: subtraction overflow");
972     }
973 
974     /**
975      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
976      * overflow (when the result is negative).
977      *
978      * Counterpart to Solidity's `-` operator.
979      *
980      * Requirements:
981      * - Subtraction cannot overflow.
982      *
983      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
984      * @dev Get it via `npm install @openzeppelin/contracts@next`.
985      */
986     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
987         require(b <= a, errorMessage);
988         uint256 c = a - b;
989 
990         return c;
991     }
992 
993     /**
994      * @dev Returns the multiplication of two unsigned integers, reverting on
995      * overflow.
996      *
997      * Counterpart to Solidity's `*` operator.
998      *
999      * Requirements:
1000      * - Multiplication cannot overflow.
1001      */
1002     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1003         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1004         // benefit is lost if 'b' is also tested.
1005         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1006         if (a == 0) {
1007             return 0;
1008         }
1009 
1010         uint256 c = a * b;
1011         require(c / a == b, "SafeMath: multiplication overflow");
1012 
1013         return c;
1014     }
1015 
1016     /**
1017      * @dev Returns the integer division of two unsigned integers. Reverts on
1018      * division by zero. The result is rounded towards zero.
1019      *
1020      * Counterpart to Solidity's `/` operator. Note: this function uses a
1021      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1022      * uses an invalid opcode to revert (consuming all remaining gas).
1023      *
1024      * Requirements:
1025      * - The divisor cannot be zero.
1026      */
1027     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1028         return div(a, b, "SafeMath: division by zero");
1029     }
1030 
1031     /**
1032      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1033      * division by zero. The result is rounded towards zero.
1034      *
1035      * Counterpart to Solidity's `/` operator. Note: this function uses a
1036      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1037      * uses an invalid opcode to revert (consuming all remaining gas).
1038      *
1039      * Requirements:
1040      * - The divisor cannot be zero.
1041      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1042      * @dev Get it via `npm install @openzeppelin/contracts@next`.
1043      */
1044     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1045         // Solidity only automatically asserts when dividing by 0
1046         require(b > 0, errorMessage);
1047         uint256 c = a / b;
1048         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1049 
1050         return c;
1051     }
1052 }