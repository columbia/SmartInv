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
16     //************
17     //Game Data
18     //************
19     uint256 private roundNumber;
20     uint256 private dayNumber;
21     uint256 private totalPlayerNumber;
22     uint256 private platformBalance;
23     //*************
24     //Game DataBase
25     //*************
26     mapping(uint256=>DataModal.RoundInfo) private rInfoXrID;
27     mapping(address=>DataModal.PlayerInfo) private pInfoXpAdd;
28     mapping(address=>uint256) private pIDXpAdd;
29     mapping(uint256=>address) private pAddXpID;
30     
31     //*************
32     // P3D Data
33     //*************
34     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
35     mapping(uint256=>uint256) private p3dDividesXroundID;
36 
37     //*************
38     //Game Events
39     //*************
40     event newPlayerJoinGameEvent(address indexed _address,uint256 indexed _amount,bool indexed _JoinWithEth,uint256 _timestamp);
41     event calculateTargetEvent(uint256 indexed _roundID);
42     
43     constructor() public {
44         dayNumber = 1;
45     }
46     
47     function() external payable {}
48     
49     //************
50     //Game payable
51     //************
52     function joinGameWithInviterID(uint256 _inviterID) public payable {
53         require(msg.value >= 0.01 ether,"You need to pay 0.01 eth at least");
54         require(now.sub(rInfoXrID[roundNumber].lastCalculateTime) < cycleTime,"Waiting for settlement");
55         if(pIDXpAdd[msg.sender] < 1) {
56             registerWithInviterID(_inviterID);
57         }
58         buyCore(pInfoXpAdd[msg.sender].inviterAddress,msg.value);
59         emit newPlayerJoinGameEvent(msg.sender,msg.value,true,now);
60     }
61     
62     //********************
63     // Method need Gas
64     //********************
65     function joinGameWithBalance(uint256 _amount) public payable {
66         require(_amount >= 0.01 ether,"You need to pay 0.01 eth at least");
67         require(now.sub(rInfoXrID[roundNumber].lastCalculateTime) < cycleTime,"Waiting for settlement");
68         uint256 balance = getUserBalance(msg.sender);
69         require(balance >= _amount.mul(11).div(10),"balance is not enough");
70         platformBalance = platformBalance.add(_amount.div(10));
71         buyCore(pInfoXpAdd[msg.sender].inviterAddress,_amount);
72         pInfoXpAdd[msg.sender].withDrawNumber = pInfoXpAdd[msg.sender].withDrawNumber.sub(_amount.mul(11).div(10));
73         emit newPlayerJoinGameEvent(msg.sender,_amount,false,now);
74     }
75     
76     function calculateTarget() public {
77         require(now.sub(rInfoXrID[roundNumber].lastCalculateTime) >= cycleTime,"Less than cycle Time from last operation");
78         //allocate p3d dividends to contract 
79         uint256 dividends = p3dContract.myDividends(true);
80         if(dividends > 0) {
81             if(rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber > 0) {
82                 p3dDividesXroundID[roundNumber] = p3dDividesXroundID[roundNumber].add(dividends);
83                 p3dContract.withdraw();    
84             } else {
85                 platformBalance = platformBalance.add(dividends);
86                 p3dContract.withdraw();    
87             }
88         }
89         uint256 increaseBalance = getIncreaseBalance(dayNumber,roundNumber);
90         uint256 targetBalance = getDailyTarget(roundNumber,dayNumber);
91         if(increaseBalance >= targetBalance) {
92             //buy p3d
93             if(getIncreaseBalance(dayNumber,roundNumber) > 0) {
94                 p3dContract.buy.value(getIncreaseBalance(dayNumber,roundNumber).div(100))(p3dInviterAddress);
95             }
96             //continue
97             dayNumber = dayNumber.add(1);
98             rInfoXrID[roundNumber].totalDay = dayNumber;
99             if(rInfoXrID[roundNumber].startTime == 0) {
100                 rInfoXrID[roundNumber].startTime = now;
101                 rInfoXrID[roundNumber].lastCalculateTime = now;
102             } else {
103                 rInfoXrID[roundNumber].lastCalculateTime = rInfoXrID[roundNumber].startTime.add((cycleTime).mul(dayNumber.sub(1)));   
104             }
105             emit calculateTargetEvent(0);
106         } else {
107             //Game over, start new round
108             bool haveWinner = false;
109             if(dayNumber > 1) {
110                 sendBalanceForDevelop(roundNumber);
111                 haveWinner = true;
112             }
113             rInfoXrID[roundNumber].winnerDay = dayNumber.sub(1);
114             roundNumber = roundNumber.add(1);
115             dayNumber = 1;
116             if(haveWinner) {
117                 rInfoXrID[roundNumber].bounsInitNumber = getBounsWithRoundID(roundNumber.sub(1)).div(10);
118             } else {
119                 rInfoXrID[roundNumber].bounsInitNumber = getBounsWithRoundID(roundNumber.sub(1));
120             }
121             rInfoXrID[roundNumber].totalDay = 1;
122             rInfoXrID[roundNumber].startTime = now;
123             rInfoXrID[roundNumber].lastCalculateTime = now;
124             emit calculateTargetEvent(roundNumber);
125         }
126     }
127 
128     function registerWithInviterID(uint256 _inviterID) private {
129         totalPlayerNumber = totalPlayerNumber.add(1);
130         pIDXpAdd[msg.sender] = totalPlayerNumber;
131         pAddXpID[totalPlayerNumber] = msg.sender;
132         pInfoXpAdd[msg.sender].inviterAddress = pAddXpID[_inviterID];
133     }
134     
135     function buyCore(address _inviterAddress,uint256 _amount) private {
136         //for inviter
137         if(_inviterAddress == 0x0 || _inviterAddress == msg.sender) {
138             platformBalance = platformBalance.add(_amount/10);
139         } else {
140             pInfoXpAdd[_inviterAddress].inviteEarnings = pInfoXpAdd[_inviterAddress].inviteEarnings.add(_amount/10);
141         }
142         uint256 playerIndex = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber.add(1);
143         if(rInfoXrID[roundNumber].numberXaddress[msg.sender] == 0) {
144             rInfoXrID[roundNumber].number = rInfoXrID[roundNumber].number.add(1);
145             rInfoXrID[roundNumber].numberXaddress[msg.sender] = rInfoXrID[roundNumber].number;
146             rInfoXrID[roundNumber].addressXnumber[rInfoXrID[roundNumber].number] = msg.sender;
147         }
148         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber = playerIndex;
149         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].addXIndex[playerIndex] = msg.sender;
150         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].indexXAddress[msg.sender] = playerIndex;
151         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].amountXIndex[playerIndex] = _amount;
152     }
153     
154     function playerWithdraw(uint256 _amount) public {
155         uint256 balance = getUserBalance(msg.sender);
156         require(balance>=_amount,"amount out of limit");
157         msg.sender.transfer(_amount);
158         pInfoXpAdd[msg.sender].withDrawNumber = pInfoXpAdd[msg.sender].withDrawNumber.add(_amount);
159     }
160     
161     function sendBalanceForDevelop(uint256 _roundID) private {
162         uint256 bouns = getBounsWithRoundID(_roundID).div(5);
163         sysDevelopAddress.transfer(bouns.div(2));
164         sysInviterAddress.transfer(bouns.div(2));
165     }
166     
167     //********************
168     // Calculate Data
169     //********************
170     function getBounsWithRoundID(uint256 _roundID) private view returns(uint256 _bouns) {
171         _bouns = _bouns.add(rInfoXrID[_roundID].bounsInitNumber);
172         for(uint256 d=1;d<=rInfoXrID[_roundID].totalDay;d++){
173             for(uint256 i=1;i<=rInfoXrID[_roundID].dayInfoXDay[d].playerNumber;i++) {
174                 uint256 amount = rInfoXrID[_roundID].dayInfoXDay[d].amountXIndex[i];
175                 _bouns = _bouns.add(amount.mul(891).div(1000));  
176             }
177             for(uint256 j=1;j<=rInfoXrID[_roundID].number;j++) {
178                 address address2 = rInfoXrID[_roundID].addressXnumber[j];
179                 if(d>=2) {
180                     _bouns = _bouns.sub(getTransformMineInDay(address2,_roundID,d.sub(1)));
181                 } else {
182                     _bouns = _bouns.sub(getTransformMineInDay(address2,_roundID,d));
183                 }
184             }
185         }
186         return(_bouns);
187     }
188     
189     function getIncreaseBalance(uint256 _dayID,uint256 _roundID) private view returns(uint256 _balance) {
190         for(uint256 i=1;i<=rInfoXrID[_roundID].dayInfoXDay[_dayID].playerNumber;i++) {
191             uint256 amount = rInfoXrID[_roundID].dayInfoXDay[_dayID].amountXIndex[i];
192             _balance = _balance.add(amount);   
193         }
194         _balance = _balance.mul(9).div(10);
195         return(_balance);
196     }
197     
198     function getMineInfoInDay(address _userAddress,uint256 _roundID, uint256 _dayID) private view returns(uint256 _totalMine,uint256 _myMine,uint256 _additional) {
199         for(uint256 i=1;i<=_dayID;i++) {
200             for(uint256 j=1;j<=rInfoXrID[_roundID].dayInfoXDay[i].playerNumber;j++) {
201                 address userAddress = rInfoXrID[_roundID].dayInfoXDay[i].addXIndex[j];
202                 uint256 amount = rInfoXrID[_roundID].dayInfoXDay[i].amountXIndex[j];
203                 if(_totalMine == 0) {
204                     _totalMine = _totalMine.add(amount.mul(5));
205                     if(userAddress == _userAddress){
206                         _myMine = _myMine.add(amount.mul(5));
207                     }
208                 } else {
209                     uint256 addPart = (amount.mul(5)/2).mul(_myMine)/_totalMine;
210                     _totalMine = _totalMine.add(amount.mul(15).div(2));
211                     if(userAddress == _userAddress){
212                         _myMine = _myMine.add(amount.mul(5)).add(addPart);    
213                     }else {
214                         _myMine = _myMine.add(addPart);
215                     }
216                     _additional = _additional.add(addPart);
217                 }
218             }
219         }
220         return(_totalMine,_myMine,_additional);
221     }
222     
223     function getTransformRate(address _userAddress,uint256 _roundID,uint256 _dayID) private view returns(uint256 _rate) {
224         (,uint256 userMine,) = getMineInfoInDay(_userAddress,_roundID,_dayID);
225         if(userMine > 0) {
226             uint256 rate = userMine.mul(4).div(1000000000000000000).add(40);
227             if(rate >80)                              
228                 return(80);
229             else
230                 return(rate);        
231         } else {
232             return(40);
233         }
234     }
235     
236     function getTransformMineInDay(address _userAddress,uint256 _roundID,uint256 _dayID) private view returns(uint256 _transformedMine) {
237         (,uint256 userMine,) = getMineInfoInDay(_userAddress,_roundID,_dayID.sub(1));
238         uint256 rate = getTransformRate(_userAddress,_roundID,_dayID.sub(1));
239         _transformedMine = userMine.mul(rate).div(10000);
240         return(_transformedMine);
241     }
242     
243     function calculateTotalMinePay(uint256 _roundID,uint256 _dayID) private view returns(uint256 _needToPay) {
244         (uint256 mine,,) = getMineInfoInDay(msg.sender,_roundID,_dayID.sub(1));
245         _needToPay = mine.mul(8).div(1000);
246         return(_needToPay);
247     }
248     
249     function getDailyTarget(uint256 _roundID,uint256 _dayID) private view returns(uint256) {
250         uint256 needToPay = calculateTotalMinePay(_roundID,_dayID);
251         uint256 target = 0;
252         if (_dayID > 20) {
253             target = (SafeMath.pwr(((5).mul(_dayID).sub(100)),3).add(1000000)).mul(needToPay).div(1000000);
254             return(target);
255         } else {
256             target = ((1000000).sub(SafeMath.pwr((100).sub((5).mul(_dayID)),3))).mul(needToPay).div(1000000);
257             if(target == 0) target = 0.0063 ether;
258             return(target);            
259         }
260     }
261     
262     function getUserBalance(address _userAddress) private view returns(uint256 _balance) {
263         if(pIDXpAdd[_userAddress] == 0) {
264             return(0);
265         }
266         uint256 withDrawNumber = pInfoXpAdd[_userAddress].withDrawNumber;
267         uint256 totalTransformed = 0;
268         for(uint256 i=1;i<=roundNumber;i++) {
269             for(uint256 j=1;j<rInfoXrID[i].totalDay;j++) {
270                 totalTransformed = totalTransformed.add(getTransformMineInDay(_userAddress,i,j));
271             }
272         }
273         uint256 inviteEarnings = pInfoXpAdd[_userAddress].inviteEarnings;
274         _balance = totalTransformed.add(inviteEarnings).add(getBounsEarnings(_userAddress)).add(getHoldEarnings(_userAddress)).add(getUserP3DDivEarnings(_userAddress)).sub(withDrawNumber);
275         return(_balance);
276     }
277     
278     function getBounsEarnings(address _userAddress) private view returns(uint256 _bounsEarnings) {
279         for(uint256 i=1;i<roundNumber;i++) {
280             uint256 winnerDay = rInfoXrID[i].winnerDay;
281             uint256 myAmountInWinnerDay=0;
282             uint256 totalAmountInWinnerDay=0;
283             if(winnerDay == 0) {
284                 _bounsEarnings = _bounsEarnings;
285             } else {
286                 for(uint256 player=1;player<=rInfoXrID[i].dayInfoXDay[winnerDay].playerNumber;player++) {
287                     address useraddress = rInfoXrID[i].dayInfoXDay[winnerDay].addXIndex[player];
288                     uint256 amount = rInfoXrID[i].dayInfoXDay[winnerDay].amountXIndex[player];
289                     if(useraddress == _userAddress) {
290                         myAmountInWinnerDay = myAmountInWinnerDay.add(amount);
291                     }
292                     totalAmountInWinnerDay = totalAmountInWinnerDay.add(amount);
293                 }
294                 uint256 bouns = getBounsWithRoundID(i).mul(14).div(25);
295                 _bounsEarnings = _bounsEarnings.add(bouns.mul(myAmountInWinnerDay).div(totalAmountInWinnerDay));
296             }
297         }
298         return(_bounsEarnings);
299     }
300 
301     function getHoldEarnings(address _userAddress) private view returns(uint256 _holdEarnings) {
302         for(uint256 i=1;i<roundNumber;i++) {
303             uint256 winnerDay = rInfoXrID[i].winnerDay;
304             if(winnerDay == 0) {
305                 _holdEarnings = _holdEarnings;
306             } else {  
307                 (uint256 totalMine,uint256 myMine,) = getMineInfoInDay(_userAddress,i,rInfoXrID[i].totalDay);
308                 uint256 bouns = getBounsWithRoundID(i).mul(7).div(50);
309                 _holdEarnings = _holdEarnings.add(bouns.mul(myMine).div(totalMine));    
310             }
311         }
312         return(_holdEarnings);
313     }
314     
315     function getUserP3DDivEarnings(address _userAddress) private view returns(uint256 _myP3DDivide) {
316         if(rInfoXrID[roundNumber].totalDay <= 1) {
317             return(0);
318         }
319         for(uint256 i=1;i<roundNumber;i++) {
320             uint256 p3dDay = rInfoXrID[i].totalDay;
321             uint256 myAmountInp3dDay=0;
322             uint256 totalAmountInP3dDay=0;
323             if(p3dDay == 0) {
324                 _myP3DDivide = _myP3DDivide;
325             } else {
326                 for(uint256 player=1;player<=rInfoXrID[i].dayInfoXDay[p3dDay].playerNumber;player++) {
327                     address useraddress = rInfoXrID[i].dayInfoXDay[p3dDay].addXIndex[player];
328                     uint256 amount = rInfoXrID[i].dayInfoXDay[p3dDay].amountXIndex[player];
329                     if(useraddress == _userAddress) {
330                         myAmountInp3dDay = myAmountInp3dDay.add(amount);
331                     }
332                     totalAmountInP3dDay = totalAmountInP3dDay.add(amount);
333                 }
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
349         address[] memory playerList = new address[](rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber);
350         for(uint256 i=0;i<rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber;i++) {
351             playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].addXIndex[i+1];
352         }
353         return(playerList);
354     }
355     
356     function getAttackPlayerList() public view returns(address[]) {
357         address[] memory playerList = new address[](rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber);
358         for(uint256 i=0;i<rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber;i++) {
359             playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].addXIndex[i+1];
360         }
361         return(playerList);
362     }
363     
364     function getCurrentFieldBalanceAndTarget() public view returns(uint256 day,uint256 bouns,uint256 todayBouns,uint256 dailyTarget) {
365         uint256 fieldBalance = getBounsWithRoundID(roundNumber).mul(7).div(10);
366         uint256 todayBalance = getIncreaseBalance(dayNumber,roundNumber) ;
367         dailyTarget = getDailyTarget(roundNumber,dayNumber);
368         return(dayNumber,fieldBalance,todayBalance,dailyTarget);
369     }
370     
371     function getUserIDAndInviterEarnings() public view returns(uint256 userID,uint256 inviteEarning) {
372         return(pIDXpAdd[msg.sender],pInfoXpAdd[msg.sender].inviteEarnings);
373     }
374     
375     function getCurrentRoundInfo() public view returns(uint256 _roundID,uint256 _dayNumber,uint256 _ethMineNumber,uint256 _startTime,uint256 _lastCalculateTime) {
376         DataModal.RoundInfo memory roundInfo = rInfoXrID[roundNumber];
377         (uint256 totalMine,,) = getMineInfoInDay(msg.sender,roundNumber,dayNumber);
378         return(roundNumber,dayNumber,totalMine,roundInfo.startTime,roundInfo.lastCalculateTime);
379     }
380     
381     function getUserProperty() public view returns(uint256 ethMineNumber,uint256 holdEarning,uint256 transformRate,uint256 ethBalance,uint256 ethTranslated,uint256 ethMineCouldTranslateToday,uint256 ethCouldGetToday) {
382         if(pIDXpAdd[msg.sender] <1) {
383             return(0,0,0,0,0,0,0);        
384         }
385         (,uint256 myMine,uint256 additional) = getMineInfoInDay(msg.sender,roundNumber,dayNumber);
386         ethMineNumber = myMine;
387         holdEarning = additional;
388         transformRate = getTransformRate(msg.sender,roundNumber,dayNumber);      
389         ethBalance = getUserBalance(msg.sender);
390         uint256 totalTransformed = 0;
391         for(uint256 i=1;i<rInfoXrID[roundNumber].totalDay;i++) {
392             totalTransformed = totalTransformed.add(getTransformMineInDay(msg.sender,roundNumber,i));
393         }
394         ethTranslated = totalTransformed;
395         ethCouldGetToday = getTransformMineInDay(msg.sender,roundNumber,dayNumber);
396         ethMineCouldTranslateToday = myMine.mul(transformRate).div(10000);
397         return(
398             ethMineNumber,
399             holdEarning,
400             transformRate,
401             ethBalance,
402             ethTranslated,
403             ethMineCouldTranslateToday,
404             ethCouldGetToday
405             );
406     }
407     
408     function getPlatformBalance() public view returns(uint256 _platformBalance) {
409         require(msg.sender == sysAdminAddress,"Ummmmm......Only admin could do this");
410         return(platformBalance);
411     }
412     
413     function withdrawForAdmin(address _toAddress,uint256 _amount) public {
414         require(msg.sender==sysAdminAddress,"You are not the admin");
415         require(platformBalance>=_amount,"Lack of balance");
416         _toAddress.transfer(_amount);
417         platformBalance = platformBalance.sub(_amount);
418     }
419     
420     function p3dWithdrawForAdmin(address _toAddress,uint256 _amount) public {
421         require(msg.sender==sysAdminAddress,"You are not the admin");
422         uint256 p3dToken = p3dContract.balanceOf(address(this));
423         require(_amount<=p3dToken,"You don't have so much P3DToken");
424         p3dContract.transfer(_toAddress,_amount);
425     }
426     
427     //************
428     //
429     //************
430     function getDataOfGame() public view returns(uint256 _playerNumber,uint256 _dailyIncreased,uint256 _dailyTransform,uint256 _contractBalance,uint256 _userBalanceLeft,uint256 _platformBalance,uint256 _mineBalance,uint256 _balanceOfMine) {
431         for(uint256 i=1;i<=totalPlayerNumber;i++) {
432             address userAddress = pAddXpID[i];
433             _userBalanceLeft = _userBalanceLeft.add(getUserBalance(userAddress));
434         }
435         return(
436             totalPlayerNumber,
437             getIncreaseBalance(dayNumber,roundNumber),
438             calculateTotalMinePay(roundNumber,dayNumber),
439             address(this).balance,
440             _userBalanceLeft,
441             platformBalance,
442             getBounsWithRoundID(roundNumber),
443             getBounsWithRoundID(roundNumber).mul(7).div(10)
444             );
445     }
446     
447     function getUserAddressList() public view returns(address[]) {
448         address[] memory addressList = new address[](totalPlayerNumber);
449         for(uint256 i=0;i<totalPlayerNumber;i++) {
450             addressList[i] = pAddXpID[i+1];
451         }
452         return(addressList);
453     }
454     
455     function getUsersInfo() public view returns(uint256[7][]){
456         uint256[7][] memory infoList = new uint256[7][](totalPlayerNumber);
457         for(uint256 i=0;i<totalPlayerNumber;i++) {
458             address userAddress = pAddXpID[i+1];
459             (,uint256 myMine,uint256 additional) = getMineInfoInDay(userAddress,roundNumber,dayNumber);
460             uint256 totalTransformed = 0;
461             for(uint256 j=1;j<=roundNumber;j++) {
462                 for(uint256 k=1;k<=rInfoXrID[j].totalDay;k++) {
463                     totalTransformed = totalTransformed.add(getTransformMineInDay(userAddress,j,k));
464                 }
465             }
466             infoList[i][0] = myMine ;
467             infoList[i][1] = getTransformRate(userAddress,roundNumber,dayNumber);
468             infoList[i][2] = additional;
469             infoList[i][3] = getUserBalance(userAddress);
470             infoList[i][4] = getUserBalance(userAddress).add(pInfoXpAdd[userAddress].withDrawNumber);
471             infoList[i][5] = pInfoXpAdd[userAddress].inviteEarnings;
472             infoList[i][6] = totalTransformed;
473         }        
474         return(infoList);
475     }
476     
477     function getP3DInfo() public view returns(uint256 _p3dTokenInContract,uint256 _p3dDivInRound) {
478         _p3dTokenInContract = p3dContract.balanceOf(address(this));
479         _p3dDivInRound = p3dDividesXroundID[roundNumber];
480         return(_p3dTokenInContract,_p3dDivInRound);
481     }
482     
483 }
484 
485 //P3D Interface
486 interface HourglassInterface {
487     function buy(address _playerAddress) payable external returns(uint256);
488     function withdraw() external;
489     function myDividends(bool _includeReferralBonus) external view returns(uint256);
490     function balanceOf(address _customerAddress) external view returns(uint256);
491     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
492 }
493 
494 library DataModal {
495     struct PlayerInfo {
496         uint256 inviteEarnings;
497         address inviterAddress;
498         uint256 withDrawNumber;
499     }
500     
501     struct DayInfo {
502         uint256 playerNumber;
503         mapping(uint256=>address) addXIndex;
504         mapping(uint256=>uint256) amountXIndex;
505         mapping(address=>uint256) indexXAddress;
506     }
507     
508     struct RoundInfo {
509         uint256 startTime;
510         uint256 lastCalculateTime;
511         uint256 bounsInitNumber;
512         uint256 totalDay;
513         uint256 winnerDay;
514         mapping(uint256=>DayInfo) dayInfoXDay;
515         mapping(uint256=>address) addressXnumber;
516         mapping(address=>uint256) numberXaddress;
517         uint256 number;
518     }
519 }
520 
521 library SafeMath {
522     /**
523     * @dev Multiplies two numbers, throws on overflow.
524     */
525     function mul(uint256 a, uint256 b) 
526         internal 
527         pure 
528         returns (uint256 c) 
529     {
530         if (a == 0) {
531             return 0;
532         }
533         c = a * b;
534         require(c / a == b, "SafeMath mul failed");
535         return c;
536     }
537     
538     function div(uint256 a, uint256 b) internal pure returns (uint256) {
539         require(b != 0, "SafeMath div failed");
540         uint256 c = a / b;
541         return c;
542     } 
543 
544     /**
545     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
546     */
547     function sub(uint256 a, uint256 b)
548         internal
549         pure
550         returns (uint256) 
551     {
552         require(b <= a, "SafeMath sub failed");
553         return a - b;
554     }
555 
556     /**
557     * @dev Adds two numbers, throws on overflow.
558     */
559     function add(uint256 a, uint256 b)
560         internal
561         pure
562         returns (uint256 c) 
563     {
564         c = a + b;
565         require(c >= a, "SafeMath add failed");
566         return c;
567     }
568     
569     /**
570      * @dev gives square root of given x.
571      */
572     function sqrt(uint256 x)
573         internal
574         pure
575         returns (uint256 y) 
576     {
577         uint256 z = ((add(x,1)) / 2);
578         y = x;
579         while (z < y) 
580         {
581             y = z;
582             z = ((add((x / z),z)) / 2);
583         }
584     }
585     
586     /**
587      * @dev gives square. multiplies x by x
588      */
589     function sq(uint256 x)
590         internal
591         pure
592         returns (uint256)
593     {
594         return (mul(x,x));
595     }
596     
597     /**
598      * @dev x to the power of y 
599      */
600     function pwr(uint256 x, uint256 y)
601         internal 
602         pure 
603         returns (uint256)
604     {
605         if (x==0)
606             return (0);
607         else if (y==0)
608             return (1);
609         else 
610         {
611             uint256 z = x;
612             for (uint256 i=1; i < y; i++)
613                 z = mul(z,x);
614             return (z);
615         }
616     }
617 }