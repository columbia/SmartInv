1 pragma solidity ^0.4.25;
2 
3 contract Richer3D {
4     using SafeMath for *;
5     
6     //************
7     //Game Setting
8     //************
9     string constant public name = "Richer3D";
10     string constant public symbol = "R3D";
11     address constant private sysAdminAddress = 0x4A3913ce9e8882b418a0Be5A43d2C319c3F0a7Bd;
12     address constant private sysInviterAddress = 0xC5E41EC7fa56C0656Bc6d7371a8706Eb9dfcBF61;
13     address constant private sysDevelopAddress = 0xCf3A25b73A493F96C15c8198319F0218aE8cAA4A;
14     address constant private p3dInviterAddress = 0x82Fc4514968b0c5FdDfA97ed005A01843d0E117d;
15     uint256 constant cycleTime = 24 hours;
16     bool calculating_target = false;
17     //************
18     //Game Data
19     //************
20     uint256 private roundNumber;
21     uint256 private dayNumber;
22     uint256 private totalPlayerNumber;
23     uint256 private platformBalance;
24     //*************
25     //Game DataBase
26     //*************
27     mapping(uint256=>DataModal.RoundInfo) private rInfoXrID;
28     mapping(address=>DataModal.PlayerInfo) private pInfoXpAdd;
29     mapping(address=>uint256) private pIDXpAdd;
30     mapping(uint256=>address) private pAddXpID;
31     
32     //*************
33     // P3D Data
34     //*************
35     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
36 
37     mapping(uint256=>uint256) private p3dDividesXroundID;
38 
39     //*************
40     //Game Events
41     //*************
42     event newPlayerJoinGameEvent(address indexed _address,uint256 indexed _amount,bool indexed _JoinWithEth,uint256 _timestamp);
43     event calculateTargetEvent(uint256 indexed _roundID);
44     
45     constructor() public {
46         dayNumber = 1;
47     }
48     
49     function() external payable {
50         joinGameWithInviterID(0);
51     }
52     
53     //************
54     //Game payable
55     //************
56     function joinGameWithInviterID(uint256 _inviterID) public payable {
57         uint256 _timestamp = now;
58         address _senderAddress = msg.sender;
59         uint256 _eth = msg.value;
60         require(_timestamp.sub(rInfoXrID[roundNumber].lastCalculateTime) < cycleTime,"Waiting for settlement");
61         if(pIDXpAdd[_senderAddress] < 1) {
62             registerWithInviterID(_inviterID);
63         }
64         buyCore(_senderAddress,pInfoXpAdd[_senderAddress].inviterAddress,_eth);
65         emit newPlayerJoinGameEvent(msg.sender,msg.value,true,_timestamp);
66     }
67     
68     //********************
69     // Method need Gas
70     //********************
71     function joinGameWithBalance(uint256 _amount) public {
72         uint256 _timestamp = now;
73         address _senderAddress = msg.sender;
74         require(_timestamp.sub(rInfoXrID[roundNumber].lastCalculateTime) < cycleTime,"Waiting for settlement");
75         uint256 balance = getUserBalance(_senderAddress);
76         require(balance >= _amount,"balance is not enough");
77         buyCore(_senderAddress,pInfoXpAdd[_senderAddress].inviterAddress,_amount);
78         pInfoXpAdd[_senderAddress].withDrawNumber = pInfoXpAdd[_senderAddress].withDrawNumber.sub(_amount);
79         emit newPlayerJoinGameEvent(_senderAddress,_amount,false,_timestamp);
80     }
81     
82     function calculateTarget() public {
83         require(calculating_target == false,"Waiting....");
84         calculating_target = true;
85         uint256 _timestamp = now;
86         require(_timestamp.sub(rInfoXrID[roundNumber].lastCalculateTime) >= cycleTime,"Less than cycle Time from last operation");
87         //allocate p3d dividends to contract 
88         uint256 dividends = p3dContract.myDividends(true);
89         if(dividends > 0) {
90             if(rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber > 0) {
91                 p3dDividesXroundID[roundNumber] = p3dDividesXroundID[roundNumber].add(dividends);
92                 p3dContract.withdraw();    
93             } else {
94                 platformBalance = platformBalance.add(dividends);
95                 p3dContract.withdraw();    
96             }
97         }
98         uint256 increaseBalance = getIncreaseBalance(dayNumber,roundNumber);
99         uint256 targetBalance = getDailyTarget(roundNumber,dayNumber);
100         uint256 ethForP3D = increaseBalance.div(100);
101         if(increaseBalance >= targetBalance) {
102             //buy p3d
103             if(getIncreaseBalance(dayNumber,roundNumber) > 0) {
104                 p3dContract.buy.value(getIncreaseBalance(dayNumber,roundNumber).div(100))(p3dInviterAddress);
105             }
106             //continue
107             dayNumber++;
108             rInfoXrID[roundNumber].totalDay = dayNumber;
109             if(rInfoXrID[roundNumber].startTime == 0) {
110                 rInfoXrID[roundNumber].startTime = _timestamp;
111                 rInfoXrID[roundNumber].lastCalculateTime = _timestamp;
112             } else {
113                 rInfoXrID[roundNumber].lastCalculateTime = _timestamp;   
114             }
115              //dividends for mine holder
116             rInfoXrID[roundNumber].increaseETH = rInfoXrID[roundNumber].increaseETH.sub(getETHNeedPay(roundNumber,dayNumber.sub(1))).sub(ethForP3D);
117             emit calculateTargetEvent(0);
118         } else {
119             //Game over, start new round
120             bool haveWinner = false;
121             if(dayNumber > 1) {
122                 sendBalanceForDevelop(roundNumber);
123                 if(platformBalance > 0) {
124                     uint256 platformBalanceAmount = platformBalance;
125                     platformBalance = 0;
126                     sysAdminAddress.transfer(platformBalanceAmount);
127                 } 
128                 haveWinner = true;
129             }
130             rInfoXrID[roundNumber].winnerDay = dayNumber.sub(1);
131             roundNumber++;
132             dayNumber = 1;
133             if(haveWinner) {
134                 rInfoXrID[roundNumber].bounsInitNumber = getBounsWithRoundID(roundNumber.sub(1)).div(10);
135             } else {
136                 rInfoXrID[roundNumber].bounsInitNumber = getBounsWithRoundID(roundNumber.sub(1));
137             }
138             rInfoXrID[roundNumber].totalDay = 1;
139             rInfoXrID[roundNumber].startTime = _timestamp;
140             rInfoXrID[roundNumber].lastCalculateTime = _timestamp;
141             emit calculateTargetEvent(roundNumber);
142         }
143         calculating_target = false;
144     }
145 
146     function registerWithInviterID(uint256 _inviterID) private {
147         address _senderAddress = msg.sender;
148         totalPlayerNumber++;
149         pIDXpAdd[_senderAddress] = totalPlayerNumber;
150         pAddXpID[totalPlayerNumber] = _senderAddress;
151         pInfoXpAdd[_senderAddress].inviterAddress = pAddXpID[_inviterID];
152     }
153     
154     function buyCore(address _playerAddress,address _inviterAddress,uint256 _amount) private {
155         require(_amount >= 0.01 ether,"You need to pay 0.01 ether at lesat");
156         //10 percent of the investment amount belongs to the inviter
157         address _senderAddress = _playerAddress;
158         if(_inviterAddress == address(0) || _inviterAddress == _senderAddress) {
159             platformBalance = platformBalance.add(_amount/10);
160         } else {
161             pInfoXpAdd[_inviterAddress].inviteEarnings = pInfoXpAdd[_inviterAddress].inviteEarnings.add(_amount/10);
162         }
163         //Record the order of purchase for each user
164         uint256 playerIndex = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber.add(1);
165         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber = playerIndex;
166         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].addXIndex[playerIndex] = _senderAddress;
167         //After the user purchases, they can add 50% more, except for the first user
168         if(rInfoXrID[roundNumber].increaseETH > 0) {
169             rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseMine = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseMine.add(_amount*5/2);
170             rInfoXrID[roundNumber].totalMine = rInfoXrID[roundNumber].totalMine.add(_amount*15/2);
171         } else {
172             rInfoXrID[roundNumber].totalMine = rInfoXrID[roundNumber].totalMine.add(_amount*5);
173         }
174         //Record the accumulated ETH in the prize pool, the newly added ETH each day, the ore and the ore actually purchased by each user
175         rInfoXrID[roundNumber].increaseETH = rInfoXrID[roundNumber].increaseETH.add(_amount).sub(_amount/10);
176         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseETH = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseETH.add(_amount).sub(_amount/10);
177         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].actualMine = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].actualMine.add(_amount*5);
178         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].mineAmountXAddress[_senderAddress] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].mineAmountXAddress[_senderAddress].add(_amount*5);
179         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].ethPayAmountXAddress[_senderAddress] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].ethPayAmountXAddress[_senderAddress].add(_amount);
180     }
181     
182     function playerWithdraw(uint256 _amount) public {
183         address _senderAddress = msg.sender;
184         uint256 balance = getUserBalance(_senderAddress);
185         require(balance>=_amount,"Lack of balance");
186         //The platform charges users 1% of the commission fee, and the rest is withdrawn to the user account
187         platformBalance = platformBalance.add(_amount.div(100));
188         pInfoXpAdd[_senderAddress].withDrawNumber = pInfoXpAdd[_senderAddress].withDrawNumber.add(_amount);
189         _senderAddress.transfer(_amount.sub(_amount.div(100)));
190     }
191     
192     function sendBalanceForDevelop(uint256 _roundID) private {
193         uint256 bouns = getBounsWithRoundID(_roundID).div(5);
194         sysDevelopAddress.transfer(bouns.div(2));
195         sysInviterAddress.transfer(bouns.sub(bouns.div(2)));
196     }
197 
198     //********************
199     // Calculate Data
200     //********************
201     function getBounsWithRoundID(uint256 _roundID) private view returns(uint256 _bouns) {
202         _bouns = _bouns.add(rInfoXrID[_roundID].bounsInitNumber).add(rInfoXrID[_roundID].increaseETH);
203         return(_bouns);
204     }
205     
206     function getETHNeedPay(uint256 _roundID,uint256 _dayID) private view returns(uint256 _amount) {
207         if(_dayID >=2) {
208             uint256 mineTotal = rInfoXrID[_roundID].totalMine.sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].actualMine).sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseMine);
209             _amount = mineTotal.mul(getTransformRate()).div(10000);
210         } else {
211             _amount = 0;
212         }
213         return(_amount);
214     }
215     
216     function getIncreaseBalance(uint256 _dayID,uint256 _roundID) private view returns(uint256 _balance) {
217         _balance = rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseETH;
218         return(_balance);
219     }
220     
221     function getMineInfoInDay(address _userAddress,uint256 _roundID, uint256 _dayID) private view returns(uint256 _totalMine,uint256 _myMine,uint256 _additional) {
222         //Through traversal, the total amount of ore by the end of the day, the amount of ore held by users, and the amount of additional additional secondary ore
223         for(uint256 i=1;i<=_dayID;i++) {
224             if(rInfoXrID[_roundID].increaseETH == 0) return(0,0,0);
225             uint256 userActualMine = rInfoXrID[_roundID].dayInfoXDay[i].mineAmountXAddress[_userAddress];
226             uint256 increaseMineInDay = rInfoXrID[_roundID].dayInfoXDay[i].increaseMine;
227             _myMine = _myMine.add(userActualMine);
228             _totalMine = _totalMine.add(rInfoXrID[_roundID].dayInfoXDay[i].increaseETH*50/9);
229             uint256 dividendsMine = _myMine.mul(increaseMineInDay).div(_totalMine);
230             _totalMine = _totalMine.add(increaseMineInDay);
231             _myMine = _myMine.add(dividendsMine);
232             _additional = dividendsMine;
233         }
234         return(_totalMine,_myMine,_additional);
235     }
236     
237     //Ore ->eth conversion rate
238     function getTransformRate() private pure returns(uint256 _rate) {
239         return(60);
240     }
241     
242     //Calculate the amount of eth to be paid in x day for user
243     function getTransformMineInDay(address _userAddress,uint256 _roundID,uint256 _dayID) private view returns(uint256 _transformedMine) {
244         (,uint256 userMine,) = getMineInfoInDay(_userAddress,_roundID,_dayID.sub(1));
245         uint256 rate = getTransformRate();
246         _transformedMine = userMine.mul(rate).div(10000);
247         return(_transformedMine);
248     }
249     
250     //Calculate the amount of eth to be paid in x day for all people
251     function calculateTotalMinePay(uint256 _roundID,uint256 _dayID) private view returns(uint256 _needToPay) {
252         uint256 mine = rInfoXrID[_roundID].totalMine.sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].actualMine).sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseMine);
253         _needToPay = mine.mul(getTransformRate()).div(10000);
254         return(_needToPay);
255     }
256 
257     //Calculate daily target values
258     function getDailyTarget(uint256 _roundID,uint256 _dayID) private view returns(uint256) {
259         uint256 needToPay = calculateTotalMinePay(_roundID,_dayID);
260         uint256 target = 0;
261         if (_dayID > 33) {
262             target = (SafeMath.pwr(((3).mul(_dayID).sub(100)),3).mul(50).add(1000000)).mul(needToPay).div(1000000);
263             return(target);
264         } else {
265             target = ((1000000).sub(SafeMath.pwr((100).sub((3).mul(_dayID)),3))).mul(needToPay).div(1000000);
266             if(target == 0) target = 0.0063 ether;
267             return(target);            
268         }
269     }
270     
271     //Query user income balance
272     function getUserBalance(address _userAddress) private view returns(uint256 _balance) {
273         if(pIDXpAdd[_userAddress] == 0) {
274             return(0);
275         }
276         //Amount of user withdrawal
277         uint256 withDrawNumber = pInfoXpAdd[_userAddress].withDrawNumber;
278         uint256 totalTransformed = 0;
279         //Calculate the number of ETH users get through the daily conversion
280         for(uint256 i=1;i<=roundNumber;i++) {
281             for(uint256 j=1;j<rInfoXrID[i].totalDay;j++) {
282                 totalTransformed = totalTransformed.add(getTransformMineInDay(_userAddress,i,j));
283             }
284         }
285         //Get the ETH obtained by user invitation
286         uint256 inviteEarnings = pInfoXpAdd[_userAddress].inviteEarnings;
287         _balance = totalTransformed.add(inviteEarnings).add(getBounsEarnings(_userAddress)).add(getHoldEarnings(_userAddress)).add(getUserP3DDivEarnings(_userAddress)).sub(withDrawNumber);
288         return(_balance);
289     }
290     
291     //Calculated the number of ETH users won in the prize pool
292     function getBounsEarnings(address _userAddress) private view returns(uint256 _bounsEarnings) {
293         for(uint256 i=1;i<roundNumber;i++) {
294             uint256 winnerDay = rInfoXrID[i].winnerDay;
295             uint256 myAmountInWinnerDay=rInfoXrID[i].dayInfoXDay[winnerDay].ethPayAmountXAddress[_userAddress];
296             uint256 totalAmountInWinnerDay=rInfoXrID[i].dayInfoXDay[winnerDay].increaseETH*10/9;
297             if(winnerDay == 0) {
298                 _bounsEarnings = _bounsEarnings;
299             } else {
300                 uint256 bouns = getBounsWithRoundID(i).mul(14).div(25);
301                 _bounsEarnings = _bounsEarnings.add(bouns.mul(myAmountInWinnerDay).div(totalAmountInWinnerDay));
302             }
303         }
304         return(_bounsEarnings);
305     }
306 
307     //Compute the ETH that the user acquires by holding the ore
308     function getHoldEarnings(address _userAddress) private view returns(uint256 _holdEarnings) {
309         for(uint256 i=1;i<roundNumber;i++) {
310             uint256 winnerDay = rInfoXrID[i].winnerDay;
311             if(winnerDay == 0) {
312                 _holdEarnings = _holdEarnings;
313             } else {  
314                 (uint256 totalMine,uint256 myMine,) = getMineInfoInDay(_userAddress,i,rInfoXrID[i].totalDay);
315                 uint256 bouns = getBounsWithRoundID(i).mul(7).div(50);
316                 _holdEarnings = _holdEarnings.add(bouns.mul(myMine).div(totalMine));    
317             }
318         }
319         return(_holdEarnings);
320     }
321     
322     //Calculate user's P3D bonus
323     function getUserP3DDivEarnings(address _userAddress) private view returns(uint256 _myP3DDivide) {
324         if(rInfoXrID[roundNumber].totalDay <= 1) {
325             return(0);
326         }
327         for(uint256 i=1;i<roundNumber;i++) {
328             uint256 p3dDay = rInfoXrID[i].totalDay;
329             uint256 myAmountInp3dDay=rInfoXrID[i].dayInfoXDay[p3dDay].ethPayAmountXAddress[_userAddress];
330             uint256 totalAmountInP3dDay=rInfoXrID[i].dayInfoXDay[p3dDay].increaseETH*10/9;
331             if(p3dDay == 0) {
332                 _myP3DDivide = _myP3DDivide;
333             } else {
334                 uint256 p3dDividesInRound = p3dDividesXroundID[i];
335                 _myP3DDivide = _myP3DDivide.add(p3dDividesInRound.mul(myAmountInp3dDay).div(totalAmountInP3dDay));
336             }
337         }
338         return(_myP3DDivide);
339     }
340     
341     //*******************
342     // UI 
343     //*******************
344     function getDefendPlayerList() public view returns(address[]) {
345         if (rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber == 0) {
346             address[] memory playerListEmpty = new address[](0);
347             return(playerListEmpty);
348         }
349         uint256 number = rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber;
350         if(number > 100) {
351             number == 100;
352         }
353         address[] memory playerList = new address[](number);
354         for(uint256 i=0;i<number;i++) {
355             playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].addXIndex[i+1];
356         }
357         return(playerList);
358     }
359     
360     function getAttackPlayerList() public view returns(address[]) {
361         uint256 number = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber;
362         if(number > 100) {
363             number == 100;
364         }
365         address[] memory playerList = new address[](number);
366         for(uint256 i=0;i<number;i++) {
367             playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].addXIndex[i+1];
368         }
369         return(playerList);
370     }
371     
372     function getCurrentFieldBalanceAndTarget() public view returns(uint256 day,uint256 bouns,uint256 todayBouns,uint256 dailyTarget) {
373         uint256 fieldBalance = getBounsWithRoundID(roundNumber).mul(7).div(10);
374         uint256 todayBalance = getIncreaseBalance(dayNumber,roundNumber) ;
375         dailyTarget = getDailyTarget(roundNumber,dayNumber);
376         return(dayNumber,fieldBalance,todayBalance,dailyTarget);
377     }
378     
379     function getUserIDAndInviterEarnings() public view returns(uint256 userID,uint256 inviteEarning) {
380         return(pIDXpAdd[msg.sender],pInfoXpAdd[msg.sender].inviteEarnings);
381     }
382     
383     function getCurrentRoundInfo() public view returns(uint256 _roundID,uint256 _dayNumber,uint256 _ethMineNumber,uint256 _startTime,uint256 _lastCalculateTime) {
384         DataModal.RoundInfo memory roundInfo = rInfoXrID[roundNumber];
385         (uint256 totalMine,,) = getMineInfoInDay(msg.sender,roundNumber,dayNumber);
386         return(roundNumber,dayNumber,totalMine,roundInfo.startTime,roundInfo.lastCalculateTime);
387     }
388     
389     function getUserProperty() public view returns(uint256 ethMineNumber,uint256 holdEarning,uint256 transformRate,uint256 ethBalance,uint256 ethTranslated,uint256 ethMineCouldTranslateToday,uint256 ethCouldGetToday) {
390         if(pIDXpAdd[msg.sender] <1) {
391             return(0,0,0,0,0,0,0);        
392         }
393         (,uint256 myMine,uint256 additional) = getMineInfoInDay(msg.sender,roundNumber,dayNumber);
394         ethMineNumber = myMine;
395         holdEarning = additional;
396         transformRate = getTransformRate();      
397         ethBalance = getUserBalance(msg.sender);
398         uint256 totalTransformed = 0;
399         for(uint256 i=1;i<rInfoXrID[roundNumber].totalDay;i++) {
400             totalTransformed = totalTransformed.add(getTransformMineInDay(msg.sender,roundNumber,i));
401         }
402         ethTranslated = totalTransformed;
403         ethCouldGetToday = getTransformMineInDay(msg.sender,roundNumber,dayNumber);
404         ethMineCouldTranslateToday = myMine.mul(transformRate).div(10000);
405         return(
406             ethMineNumber,
407             holdEarning,
408             transformRate,
409             ethBalance,
410             ethTranslated,
411             ethMineCouldTranslateToday,
412             ethCouldGetToday
413             );
414     }
415     
416     function getPlatformBalance() public view returns(uint256 _platformBalance) {
417         require(msg.sender == sysAdminAddress,"Ummmmm......Only admin could do this");
418         return(platformBalance);
419     }
420 
421     //************
422     // for statistics
423     //************
424     function getDataOfGame() public view returns(uint256 _playerNumber,uint256 _dailyIncreased,uint256 _dailyTransform,uint256 _contractBalance,uint256 _userBalanceLeft,uint256 _platformBalance,uint256 _mineBalance,uint256 _balanceOfMine) {
425         for(uint256 i=1;i<=totalPlayerNumber;i++) {
426             address userAddress = pAddXpID[i];
427             _userBalanceLeft = _userBalanceLeft.add(getUserBalance(userAddress));
428         }
429         return(
430             totalPlayerNumber,
431             getIncreaseBalance(dayNumber,roundNumber),
432             calculateTotalMinePay(roundNumber,dayNumber),
433             address(this).balance,
434             _userBalanceLeft,
435             platformBalance,
436             getBounsWithRoundID(roundNumber),
437             getBounsWithRoundID(roundNumber).mul(7).div(10)
438             );
439     }
440     
441     function getUserAddressList() public view returns(address[]) {
442         address[] memory addressList = new address[](totalPlayerNumber);
443         for(uint256 i=0;i<totalPlayerNumber;i++) {
444             addressList[i] = pAddXpID[i+1];
445         }
446         return(addressList);
447     }
448     
449     function getUsersInfo() public view returns(uint256[7][]){
450         uint256[7][] memory infoList = new uint256[7][](totalPlayerNumber);
451         for(uint256 i=0;i<totalPlayerNumber;i++) {
452             address userAddress = pAddXpID[i+1];
453             (,uint256 myMine,uint256 additional) = getMineInfoInDay(userAddress,roundNumber,dayNumber);
454             uint256 totalTransformed = 0;
455             for(uint256 j=1;j<=roundNumber;j++) {
456                 for(uint256 k=1;k<=rInfoXrID[j].totalDay;k++) {
457                     totalTransformed = totalTransformed.add(getTransformMineInDay(userAddress,j,k));
458                 }
459             }
460             infoList[i][0] = myMine ;
461             infoList[i][1] = getTransformRate();
462             infoList[i][2] = additional;
463             infoList[i][3] = getUserBalance(userAddress);
464             infoList[i][4] = getUserBalance(userAddress).add(pInfoXpAdd[userAddress].withDrawNumber);
465             infoList[i][5] = pInfoXpAdd[userAddress].inviteEarnings;
466             infoList[i][6] = totalTransformed;
467         }        
468         return(infoList);
469     }
470     
471     function getP3DInfo() public view returns(uint256 _p3dTokenInContract,uint256 _p3dDivInRound) {
472         _p3dTokenInContract = p3dContract.balanceOf(address(this));
473         _p3dDivInRound = p3dDividesXroundID[roundNumber];
474         return(_p3dTokenInContract,_p3dDivInRound);
475     }
476     
477 }
478 
479 //P3D Interface
480 interface HourglassInterface {
481     function buy(address _playerAddress) payable external returns(uint256);
482     function withdraw() external;
483     function myDividends(bool _includeReferralBonus) external view returns(uint256);
484     function balanceOf(address _customerAddress) external view returns(uint256);
485     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
486 }
487 
488 library DataModal {
489     struct PlayerInfo {
490         uint256 inviteEarnings;
491         address inviterAddress;
492         uint256 withDrawNumber;
493     }
494     
495     struct DayInfo {
496         uint256 playerNumber;
497         uint256 actualMine;
498         uint256 increaseETH;
499         uint256 increaseMine;
500         mapping(uint256=>address) addXIndex;
501         mapping(address=>uint256) ethPayAmountXAddress;
502         mapping(address=>uint256) mineAmountXAddress;
503     }
504     
505     struct RoundInfo {
506         uint256 startTime;
507         uint256 lastCalculateTime;
508         uint256 bounsInitNumber;
509         uint256 increaseETH;
510         uint256 totalDay;
511         uint256 winnerDay;
512         uint256 totalMine;
513         mapping(uint256=>DayInfo) dayInfoXDay;
514     }
515 }
516 
517 library SafeMath {
518     /**
519     * @dev Multiplies two numbers, throws on overflow.
520     */
521     function mul(uint256 a, uint256 b) 
522         internal 
523         pure 
524         returns (uint256 c) 
525     {
526         if (a == 0) {
527             return 0;
528         }
529         c = a * b;
530         require(c / a == b, "SafeMath mul failed");
531         return c;
532     }
533     
534     function div(uint256 a, uint256 b) internal pure returns (uint256) {
535         require(b != 0, "SafeMath div failed");
536         uint256 c = a / b;
537         return c;
538     } 
539 
540     /**
541     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
542     */
543     function sub(uint256 a, uint256 b)
544         internal
545         pure
546         returns (uint256) 
547     {
548         require(b <= a, "SafeMath sub failed");
549         return a - b;
550     }
551 
552     /**
553     * @dev Adds two numbers, throws on overflow.
554     */
555     function add(uint256 a, uint256 b)
556         internal
557         pure
558         returns (uint256 c) 
559     {
560         c = a + b;
561         require(c >= a, "SafeMath add failed");
562         return c;
563     }
564     
565     /**
566      * @dev gives square root of given x.
567      */
568     function sqrt(uint256 x)
569         internal
570         pure
571         returns (uint256 y) 
572     {
573         uint256 z = ((add(x,1)) / 2);
574         y = x;
575         while (z < y) 
576         {
577             y = z;
578             z = ((add((x / z),z)) / 2);
579         }
580     }
581     
582     /**
583      * @dev gives square. multiplies x by x
584      */
585     function sq(uint256 x)
586         internal
587         pure
588         returns (uint256)
589     {
590         return (mul(x,x));
591     }
592     
593     /**
594      * @dev x to the power of y 
595      */
596     function pwr(uint256 x, uint256 y)
597         internal 
598         pure 
599         returns (uint256)
600     {
601         if (x==0)
602             return (0);
603         else if (y==0)
604             return (1);
605         else 
606         {
607             uint256 z = x;
608             for (uint256 i=1; i < y; i++)
609                 z = mul(z,x);
610             return (z);
611         }
612     }
613 }