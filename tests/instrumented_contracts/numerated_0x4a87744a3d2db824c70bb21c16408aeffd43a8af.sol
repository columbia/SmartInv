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
50 
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
68     function joinGameWithInviterIDForAddress(uint256 _inviterID,address _address) public payable {
69         uint256 _timestamp = now;
70         address _senderAddress = _address;
71         uint256 _eth = msg.value;
72         require(_timestamp.sub(rInfoXrID[roundNumber].lastCalculateTime) < cycleTime,"Waiting for settlement");
73         if(pIDXpAdd[_senderAddress] < 1) {
74             registerWithInviterID(_inviterID);
75         }
76         buyCore(_senderAddress,pInfoXpAdd[_senderAddress].inviterAddress,_eth);
77         emit newPlayerJoinGameEvent(msg.sender,msg.value,true,_timestamp);
78     }
79     
80     //********************
81     // Method need Gas
82     //********************
83     function joinGameWithBalance(uint256 _amount) public {
84         uint256 _timestamp = now;
85         address _senderAddress = msg.sender;
86         require(_timestamp.sub(rInfoXrID[roundNumber].lastCalculateTime) < cycleTime,"Waiting for settlement");
87         uint256 balance = getUserBalance(_senderAddress);
88         require(balance >= _amount,"balance is not enough");
89         buyCore(_senderAddress,pInfoXpAdd[_senderAddress].inviterAddress,_amount);
90         pInfoXpAdd[_senderAddress].withDrawNumber = pInfoXpAdd[_senderAddress].withDrawNumber.sub(_amount);
91         emit newPlayerJoinGameEvent(_senderAddress,_amount,false,_timestamp);
92     }
93     
94     function calculateTarget() public {
95         require(calculating_target == false,"Waiting....");
96         calculating_target = true;
97         uint256 _timestamp = now;
98         require(_timestamp.sub(rInfoXrID[roundNumber].lastCalculateTime) >= cycleTime,"Less than cycle Time from last operation");
99         //allocate p3d dividends to contract 
100         uint256 dividends = p3dContract.myDividends(true);
101         if(dividends > 0) {
102             if(rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber > 0) {
103                 p3dDividesXroundID[roundNumber] = p3dDividesXroundID[roundNumber].add(dividends);
104                 p3dContract.withdraw();    
105             } else {
106                 platformBalance = platformBalance.add(dividends).add(p3dDividesXroundID[roundNumber]);
107                 p3dContract.withdraw();    
108             }
109         }
110         uint256 increaseBalance = getIncreaseBalance(dayNumber,roundNumber);
111         uint256 targetBalance = getDailyTarget(roundNumber,dayNumber);
112         uint256 ethForP3D = increaseBalance.div(100);
113         if(increaseBalance >= targetBalance) {
114             //buy p3d
115             if(increaseBalance > 0) {
116                 p3dContract.buy.value(ethForP3D)(p3dInviterAddress);
117             }
118             //continue
119             dayNumber++;
120             rInfoXrID[roundNumber].totalDay = dayNumber;
121             if(rInfoXrID[roundNumber].startTime == 0) {
122                 rInfoXrID[roundNumber].startTime = _timestamp;
123                 rInfoXrID[roundNumber].lastCalculateTime = _timestamp;
124             } else {
125                 rInfoXrID[roundNumber].lastCalculateTime = _timestamp;   
126             }
127              //dividends for mine holder
128             rInfoXrID[roundNumber].increaseETH = rInfoXrID[roundNumber].increaseETH.sub(getETHNeedPay(roundNumber,dayNumber.sub(1))).sub(ethForP3D);
129             emit calculateTargetEvent(0);
130         } else {
131             //Game over, start new round
132             bool haveWinner = false;
133             if(dayNumber > 1) {
134                 sendBalanceForDevelop(roundNumber);
135                 if(platformBalance > 0) {
136                     uint256 platformBalanceAmount = platformBalance;
137                     platformBalance = 0;
138                     sysAdminAddress.transfer(platformBalanceAmount);
139                 } 
140                 haveWinner = true;
141             }
142             rInfoXrID[roundNumber].winnerDay = dayNumber.sub(1);
143             roundNumber++;
144             dayNumber = 1;
145             if(haveWinner) {
146                 rInfoXrID[roundNumber].bounsInitNumber = getBounsWithRoundID(roundNumber.sub(1)).div(10);
147             } else {
148                 rInfoXrID[roundNumber].bounsInitNumber = getBounsWithRoundID(roundNumber.sub(1));
149             }
150             rInfoXrID[roundNumber].totalDay = 1;
151             rInfoXrID[roundNumber].startTime = _timestamp;
152             rInfoXrID[roundNumber].lastCalculateTime = _timestamp;
153             emit calculateTargetEvent(roundNumber);
154         }
155         calculating_target = false;
156     }
157 
158     function registerWithInviterID(uint256 _inviterID) private {
159         address _senderAddress = msg.sender;
160         totalPlayerNumber++;
161         pIDXpAdd[_senderAddress] = totalPlayerNumber;
162         pAddXpID[totalPlayerNumber] = _senderAddress;
163         pInfoXpAdd[_senderAddress].inviterAddress = pAddXpID[_inviterID];
164     }
165     
166     function buyCore(address _playerAddress,address _inviterAddress,uint256 _amount) private {
167         require(_amount >= 0.01 ether,"You need to pay 0.01 ether at lesat");
168         //10 percent of the investment amount belongs to the inviter
169         address _senderAddress = _playerAddress;
170         if(_inviterAddress == address(0) || _inviterAddress == _senderAddress) {
171             platformBalance = platformBalance.add(_amount/10);
172         } else {
173             pInfoXpAdd[_inviterAddress].inviteEarnings = pInfoXpAdd[_inviterAddress].inviteEarnings.add(_amount/10);
174         }
175         //Record the order of purchase for each user
176         uint256 playerIndex = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber.add(1);
177         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber = playerIndex;
178         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].addXIndex[playerIndex] = _senderAddress;
179         //After the user purchases, they can add 50% more, except for the first user
180         if(rInfoXrID[roundNumber].increaseETH > 0) {
181             rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseMine = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseMine.add(_amount*5/2);
182             rInfoXrID[roundNumber].totalMine = rInfoXrID[roundNumber].totalMine.add(_amount*15/2);
183         } else {
184             rInfoXrID[roundNumber].totalMine = rInfoXrID[roundNumber].totalMine.add(_amount*5);
185         }
186         //Record the accumulated ETH in the prize pool, the newly added ETH each day, the ore and the ore actually purchased by each user
187         rInfoXrID[roundNumber].increaseETH = rInfoXrID[roundNumber].increaseETH.add(_amount).sub(_amount/10);
188         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseETH = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseETH.add(_amount).sub(_amount/10);
189         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].actualMine = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].actualMine.add(_amount*5);
190         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].mineAmountXAddress[_senderAddress] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].mineAmountXAddress[_senderAddress].add(_amount*5);
191         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].ethPayAmountXAddress[_senderAddress] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].ethPayAmountXAddress[_senderAddress].add(_amount);
192     }
193     
194     function playerWithdraw(uint256 _amount) public {
195         address _senderAddress = msg.sender;
196         uint256 balance = getUserBalance(_senderAddress);
197         require(balance>=_amount,"Lack of balance");
198         //The platform charges users 1% of the commission fee, and the rest is withdrawn to the user account
199         platformBalance = platformBalance.add(_amount.div(100));
200         pInfoXpAdd[_senderAddress].withDrawNumber = pInfoXpAdd[_senderAddress].withDrawNumber.add(_amount);
201         _senderAddress.transfer(_amount.sub(_amount.div(100)));
202     }
203     
204     function sendBalanceForDevelop(uint256 _roundID) private {
205         uint256 bouns = getBounsWithRoundID(_roundID).div(5);
206         sysDevelopAddress.transfer(bouns.div(2));
207         sysInviterAddress.transfer(bouns.sub(bouns.div(2)));
208     }
209     
210     //If no users participate in the game for 10 consecutive rounds, the administrator can destroy the contract
211     function kill() public {
212         require(msg.sender == sysAdminAddress,"You can't do this");
213         require(roundNumber>=10,"Wait patiently");
214         bool noPlayer;
215         //Check if users have participated in the last 10 rounds
216         for(uint256 i=0;i<10;i++) {
217             uint256 eth = rInfoXrID[roundNumber-i].increaseETH;
218             if(eth == 0) {
219                 noPlayer = true;
220             } else {
221                 noPlayer = false;
222             }
223         }
224         require(noPlayer,"This cannot be done because the user is still present");
225         uint256 p3dBalance = p3dContract.balanceOf(address(this));
226         p3dContract.transfer(sysAdminAddress,p3dBalance);
227         sysAdminAddress.transfer(address(this).balance);
228         selfdestruct(sysAdminAddress);
229     }
230 
231     //********************
232     // Calculate Data
233     //********************
234     function getBounsWithRoundID(uint256 _roundID) private view returns(uint256 _bouns) {
235         _bouns = _bouns.add(rInfoXrID[_roundID].bounsInitNumber).add(rInfoXrID[_roundID].increaseETH);
236         return(_bouns);
237     }
238     
239     function getETHNeedPay(uint256 _roundID,uint256 _dayID) private view returns(uint256 _amount) {
240         if(_dayID >=2) {
241             uint256 mineTotal = rInfoXrID[_roundID].totalMine.sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].actualMine).sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseMine);
242             _amount = mineTotal.mul(getTransformRate()).div(10000);
243         } else {
244             _amount = 0;
245         }
246         return(_amount);
247     }
248     
249     function getIncreaseBalance(uint256 _dayID,uint256 _roundID) private view returns(uint256 _balance) {
250         _balance = rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseETH;
251         return(_balance);
252     }
253     
254     function getMineInfoInDay(address _userAddress,uint256 _roundID, uint256 _dayID) private view returns(uint256 _totalMine,uint256 _myMine,uint256 _additional) {
255         //Through traversal, the total amount of ore by the end of the day, the amount of ore held by users, and the amount of additional additional secondary ore
256         for(uint256 i=1;i<=_dayID;i++) {
257             if(rInfoXrID[_roundID].increaseETH == 0) return(0,0,0);
258             uint256 userActualMine = rInfoXrID[_roundID].dayInfoXDay[i].mineAmountXAddress[_userAddress];
259             uint256 increaseMineInDay = rInfoXrID[_roundID].dayInfoXDay[i].increaseMine;
260             _myMine = _myMine.add(userActualMine);
261             _totalMine = _totalMine.add(rInfoXrID[_roundID].dayInfoXDay[i].increaseETH*50/9);
262             uint256 dividendsMine = _myMine.mul(increaseMineInDay).div(_totalMine);
263             _totalMine = _totalMine.add(increaseMineInDay);
264             _myMine = _myMine.add(dividendsMine);
265             _additional = dividendsMine;
266         }
267         return(_totalMine,_myMine,_additional);
268     }
269     
270     //Ore ->eth conversion rate
271     function getTransformRate() private pure returns(uint256 _rate) {
272         return(60);
273     }
274     
275     //Calculate the amount of eth to be paid in x day for user
276     function getTransformMineInDay(address _userAddress,uint256 _roundID,uint256 _dayID) private view returns(uint256 _transformedMine) {
277         (,uint256 userMine,) = getMineInfoInDay(_userAddress,_roundID,_dayID.sub(1));
278         uint256 rate = getTransformRate();
279         _transformedMine = userMine.mul(rate).div(10000);
280         return(_transformedMine);
281     }
282     
283     //Calculate the amount of eth to be paid in x day for all people
284     function calculateTotalMinePay(uint256 _roundID,uint256 _dayID) private view returns(uint256 _needToPay) {
285         uint256 mine = rInfoXrID[_roundID].totalMine.sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].actualMine).sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseMine);
286         _needToPay = mine.mul(getTransformRate()).div(10000);
287         return(_needToPay);
288     }
289 
290     //Calculate daily target values
291     function getDailyTarget(uint256 _roundID,uint256 _dayID) private view returns(uint256) {
292         uint256 needToPay = calculateTotalMinePay(_roundID,_dayID);
293         uint256 target = 0;
294         if (_dayID > 33) {
295             target = (SafeMath.pwr(((3).mul(_dayID).sub(100)),3).mul(50).add(1000000)).mul(needToPay).div(1000000);
296             return(target);
297         } else {
298             target = ((1000000).sub(SafeMath.pwr((100).sub((3).mul(_dayID)),3))).mul(needToPay).div(1000000);
299             if(target == 0) target = 0.0063 ether;
300             return(target);            
301         }
302     }
303     
304     //Query user income balance
305     function getUserBalance(address _userAddress) private view returns(uint256 _balance) {
306         if(pIDXpAdd[_userAddress] == 0) {
307             return(0);
308         }
309         //Amount of user withdrawal
310         uint256 withDrawNumber = pInfoXpAdd[_userAddress].withDrawNumber;
311         uint256 totalTransformed = 0;
312         //Calculate the number of ETH users get through the daily conversion
313         bool islocked = checkContructIsLocked();
314         for(uint256 i=1;i<=roundNumber;i++) {
315             if(islocked && i == roundNumber) {
316                 return;
317             }
318             for(uint256 j=1;j<rInfoXrID[i].totalDay;j++) {
319                 totalTransformed = totalTransformed.add(getTransformMineInDay(_userAddress,i,j));
320             }
321         }
322         //Get the ETH obtained by user invitation
323         uint256 inviteEarnings = pInfoXpAdd[_userAddress].inviteEarnings;
324         _balance = totalTransformed.add(inviteEarnings).add(getBounsEarnings(_userAddress)).add(getHoldEarnings(_userAddress)).add(getUserP3DDivEarnings(_userAddress)).sub(withDrawNumber);
325         return(_balance);
326     }
327     
328     //calculate how much eth user have paid
329     function getUserPayedInCurrentRound(address _userAddress) public view returns(uint256 _payAmount) {
330         if(pInfoXpAdd[_userAddress].getPaidETHBackXRoundID[roundNumber]) {
331             return(0);
332         }
333         for(uint256 i=1;i<=rInfoXrID[roundNumber].totalDay;i++) {
334              _payAmount = _payAmount.add(rInfoXrID[roundNumber].dayInfoXDay[i].ethPayAmountXAddress[_userAddress]);
335         }
336         return(_payAmount);
337     }
338     
339     //user can get eth back if the contract is locked
340     function getPaidETHBack() public {
341         require(checkContructIsLocked(),"The contract is in normal operation");
342         address _sender = msg.sender;
343         uint256 paidAmount = getUserPayedInCurrentRound(_sender);
344         pInfoXpAdd[_sender].getPaidETHBackXRoundID[roundNumber] = true;
345         _sender.transfer(paidAmount);
346     }
347     
348     //Calculated the number of ETH users won in the prize pool
349     function getBounsEarnings(address _userAddress) private view returns(uint256 _bounsEarnings) {
350         for(uint256 i=1;i<roundNumber;i++) {
351             uint256 winnerDay = rInfoXrID[i].winnerDay;
352             uint256 myAmountInWinnerDay=rInfoXrID[i].dayInfoXDay[winnerDay].ethPayAmountXAddress[_userAddress];
353             uint256 totalAmountInWinnerDay=rInfoXrID[i].dayInfoXDay[winnerDay].increaseETH*10/9;
354             if(winnerDay == 0) {
355                 _bounsEarnings = _bounsEarnings;
356             } else {
357                 uint256 bouns = getBounsWithRoundID(i).mul(14).div(25);
358                 _bounsEarnings = _bounsEarnings.add(bouns.mul(myAmountInWinnerDay).div(totalAmountInWinnerDay));
359             }
360         }
361         return(_bounsEarnings);
362     }
363 
364     //Compute the ETH that the user acquires by holding the ore
365     function getHoldEarnings(address _userAddress) private view returns(uint256 _holdEarnings) {
366         for(uint256 i=1;i<roundNumber;i++) {
367             uint256 winnerDay = rInfoXrID[i].winnerDay;
368             if(winnerDay == 0) {
369                 _holdEarnings = _holdEarnings;
370             } else {  
371                 (uint256 totalMine,uint256 myMine,) = getMineInfoInDay(_userAddress,i,rInfoXrID[i].totalDay);
372                 uint256 bouns = getBounsWithRoundID(i).mul(7).div(50);
373                 _holdEarnings = _holdEarnings.add(bouns.mul(myMine).div(totalMine));    
374             }
375         }
376         return(_holdEarnings);
377     }
378     
379     //Calculate user's P3D bonus
380     function getUserP3DDivEarnings(address _userAddress) private view returns(uint256 _myP3DDivide) {
381         if(rInfoXrID[roundNumber].totalDay <= 1) {
382             return(0);
383         }
384         for(uint256 i=1;i<roundNumber;i++) {
385             uint256 p3dDay = rInfoXrID[i].totalDay;
386             uint256 myAmountInp3dDay=rInfoXrID[i].dayInfoXDay[p3dDay].ethPayAmountXAddress[_userAddress];
387             uint256 totalAmountInP3dDay=rInfoXrID[i].dayInfoXDay[p3dDay].increaseETH*10/9;
388             if(p3dDay == 0) {
389                 _myP3DDivide = _myP3DDivide;
390             } else {
391                 uint256 p3dDividesInRound = p3dDividesXroundID[i];
392                 _myP3DDivide = _myP3DDivide.add(p3dDividesInRound.mul(myAmountInp3dDay).div(totalAmountInP3dDay));
393             }
394         }
395         return(_myP3DDivide);
396     }
397     
398     //*******************
399     // Check contract lock
400     //*******************
401     function checkContructIsLocked() public view returns(bool) {
402         uint256 time = now.sub(rInfoXrID[roundNumber].lastCalculateTime);
403         if(time >= 2*cycleTime) {
404             return(true);
405         } else {
406             return(false);
407         }
408     }
409 
410     //*******************
411     // UI 
412     //*******************
413     function getDefendPlayerList() public view returns(address[]) {
414         if (rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber == 0) {
415             address[] memory playerListEmpty = new address[](0);
416             return(playerListEmpty);
417         }
418         uint256 number = rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber;
419         if(number > 100) {
420             number == 100;
421         }
422         address[] memory playerList = new address[](number);
423         for(uint256 i=0;i<number;i++) {
424             playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].addXIndex[i+1];
425         }
426         return(playerList);
427     }
428     
429     function getAttackPlayerList() public view returns(address[]) {
430         uint256 number = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber;
431         if(number > 100) {
432             number == 100;
433         }
434         address[] memory playerList = new address[](number);
435         for(uint256 i=0;i<number;i++) {
436             playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].addXIndex[i+1];
437         }
438         return(playerList);
439     }
440     
441     function getCurrentFieldBalanceAndTarget() public view returns(uint256 day,uint256 bouns,uint256 todayBouns,uint256 dailyTarget) {
442         uint256 fieldBalance = getBounsWithRoundID(roundNumber).mul(7).div(10);
443         uint256 todayBalance = getIncreaseBalance(dayNumber,roundNumber) ;
444         dailyTarget = getDailyTarget(roundNumber,dayNumber);
445         return(dayNumber,fieldBalance,todayBalance,dailyTarget);
446     }
447     
448     function getUserIDAndInviterEarnings() public view returns(uint256 userID,uint256 inviteEarning) {
449         return(pIDXpAdd[msg.sender],pInfoXpAdd[msg.sender].inviteEarnings);
450     }
451     
452     function getCurrentRoundInfo() public view returns(uint256 _roundID,uint256 _dayNumber,uint256 _ethMineNumber,uint256 _startTime,uint256 _lastCalculateTime) {
453         DataModal.RoundInfo memory roundInfo = rInfoXrID[roundNumber];
454         (uint256 totalMine,,) = getMineInfoInDay(msg.sender,roundNumber,dayNumber);
455         return(roundNumber,dayNumber,totalMine,roundInfo.startTime,roundInfo.lastCalculateTime);
456     }
457     
458     function getUserProperty() public view returns(uint256 ethMineNumber,uint256 holdEarning,uint256 transformRate,uint256 ethBalance,uint256 ethTranslated,uint256 ethMineCouldTranslateToday,uint256 ethCouldGetToday) {
459         if(pIDXpAdd[msg.sender] <1) {
460             return(0,0,0,0,0,0,0);        
461         }
462         (,uint256 myMine,uint256 additional) = getMineInfoInDay(msg.sender,roundNumber,dayNumber);
463         ethMineNumber = myMine;
464         holdEarning = additional;
465         transformRate = getTransformRate();      
466         ethBalance = getUserBalance(msg.sender);
467         uint256 totalTransformed = 0;
468         for(uint256 i=1;i<rInfoXrID[roundNumber].totalDay;i++) {
469             totalTransformed = totalTransformed.add(getTransformMineInDay(msg.sender,roundNumber,i));
470         }
471         ethTranslated = totalTransformed;
472         ethCouldGetToday = getTransformMineInDay(msg.sender,roundNumber,dayNumber);
473         ethMineCouldTranslateToday = myMine.mul(transformRate).div(10000);
474         return(
475             ethMineNumber,
476             holdEarning,
477             transformRate,
478             ethBalance,
479             ethTranslated,
480             ethMineCouldTranslateToday,
481             ethCouldGetToday
482             );
483     }
484     
485     function getPlatformBalance() public view returns(uint256 _platformBalance) {
486         require(msg.sender == sysAdminAddress,"Ummmmm......Only admin could do this");
487         return(platformBalance);
488     }
489 
490     //************
491     // for statistics
492     //************
493     function getDataOfGame() public view returns(uint256 _playerNumber,uint256 _dailyIncreased,uint256 _dailyTransform,uint256 _contractBalance,uint256 _userBalanceLeft,uint256 _platformBalance,uint256 _mineBalance,uint256 _balanceOfMine) {
494         for(uint256 i=1;i<=totalPlayerNumber;i++) {
495             address userAddress = pAddXpID[i];
496             _userBalanceLeft = _userBalanceLeft.add(getUserBalance(userAddress));
497         }
498         return(
499             totalPlayerNumber,
500             getIncreaseBalance(dayNumber,roundNumber),
501             calculateTotalMinePay(roundNumber,dayNumber),
502             address(this).balance,
503             _userBalanceLeft,
504             platformBalance,
505             getBounsWithRoundID(roundNumber),
506             getBounsWithRoundID(roundNumber).mul(7).div(10)
507             );
508     }
509     
510     function getUserAddressList() public view returns(address[]) {
511         address[] memory addressList = new address[](totalPlayerNumber);
512         for(uint256 i=0;i<totalPlayerNumber;i++) {
513             addressList[i] = pAddXpID[i+1];
514         }
515         return(addressList);
516     }
517     
518     function getUsersInfo() public view returns(uint256[7][]){
519         uint256[7][] memory infoList = new uint256[7][](totalPlayerNumber);
520         for(uint256 i=0;i<totalPlayerNumber;i++) {
521             address userAddress = pAddXpID[i+1];
522             (,uint256 myMine,uint256 additional) = getMineInfoInDay(userAddress,roundNumber,dayNumber);
523             uint256 totalTransformed = 0;
524             for(uint256 j=1;j<=roundNumber;j++) {
525                 for(uint256 k=1;k<=rInfoXrID[j].totalDay;k++) {
526                     totalTransformed = totalTransformed.add(getTransformMineInDay(userAddress,j,k));
527                 }
528             }
529             infoList[i][0] = myMine ;
530             infoList[i][1] = getTransformRate();
531             infoList[i][2] = additional;
532             infoList[i][3] = getUserBalance(userAddress);
533             infoList[i][4] = getUserBalance(userAddress).add(pInfoXpAdd[userAddress].withDrawNumber);
534             infoList[i][5] = pInfoXpAdd[userAddress].inviteEarnings;
535             infoList[i][6] = totalTransformed;
536         }        
537         return(infoList);
538     }
539     
540     function getP3DInfo() public view returns(uint256 _p3dTokenInContract,uint256 _p3dDivInRound) {
541         _p3dTokenInContract = p3dContract.balanceOf(address(this));
542         _p3dDivInRound = p3dDividesXroundID[roundNumber];
543         return(_p3dTokenInContract,_p3dDivInRound);
544     }
545     
546 }
547 
548 //P3D Interface
549 interface HourglassInterface {
550     function buy(address _playerAddress) payable external returns(uint256);
551     function withdraw() external;
552     function myDividends(bool _includeReferralBonus) external view returns(uint256);
553     function balanceOf(address _customerAddress) external view returns(uint256);
554     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
555 }
556 
557 library DataModal {
558     struct PlayerInfo {
559         uint256 inviteEarnings;
560         address inviterAddress;
561         uint256 withDrawNumber;
562         mapping(uint256=>bool) getPaidETHBackXRoundID;
563     }
564     
565     struct DayInfo {
566         uint256 playerNumber;
567         uint256 actualMine;
568         uint256 increaseETH;
569         uint256 increaseMine;
570         mapping(uint256=>address) addXIndex;
571         mapping(address=>uint256) ethPayAmountXAddress;
572         mapping(address=>uint256) mineAmountXAddress;
573     }
574     
575     struct RoundInfo {
576         uint256 startTime;
577         uint256 lastCalculateTime;
578         uint256 bounsInitNumber;
579         uint256 increaseETH;
580         uint256 totalDay;
581         uint256 winnerDay;
582         uint256 totalMine;
583         mapping(uint256=>DayInfo) dayInfoXDay;
584     }
585 }
586 
587 library SafeMath {
588     /**
589     * @dev Multiplies two numbers, throws on overflow.
590     */
591     function mul(uint256 a, uint256 b) 
592         internal 
593         pure 
594         returns (uint256 c) 
595     {
596         if (a == 0) {
597             return 0;
598         }
599         c = a * b;
600         require(c / a == b, "SafeMath mul failed");
601         return c;
602     }
603     
604     function div(uint256 a, uint256 b) internal pure returns (uint256) {
605         require(b != 0, "SafeMath div failed");
606         uint256 c = a / b;
607         return c;
608     } 
609 
610     /**
611     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
612     */
613     function sub(uint256 a, uint256 b)
614         internal
615         pure
616         returns (uint256) 
617     {
618         require(b <= a, "SafeMath sub failed");
619         return a - b;
620     }
621 
622     /**
623     * @dev Adds two numbers, throws on overflow.
624     */
625     function add(uint256 a, uint256 b)
626         internal
627         pure
628         returns (uint256 c) 
629     {
630         c = a + b;
631         require(c >= a, "SafeMath add failed");
632         return c;
633     }
634     
635     /**
636      * @dev gives square root of given x.
637      */
638     function sqrt(uint256 x)
639         internal
640         pure
641         returns (uint256 y) 
642     {
643         uint256 z = ((add(x,1)) / 2);
644         y = x;
645         while (z < y) 
646         {
647             y = z;
648             z = ((add((x / z),z)) / 2);
649         }
650     }
651     
652     /**
653      * @dev gives square. multiplies x by x
654      */
655     function sq(uint256 x)
656         internal
657         pure
658         returns (uint256)
659     {
660         return (mul(x,x));
661     }
662     
663     /**
664      * @dev x to the power of y 
665      */
666     function pwr(uint256 x, uint256 y)
667         internal 
668         pure 
669         returns (uint256)
670     {
671         if (x==0)
672             return (0);
673         else if (y==0)
674             return (1);
675         else 
676         {
677             uint256 z = x;
678             for (uint256 i=1; i < y; i++)
679                 z = mul(z,x);
680             return (z);
681         }
682     }
683 }