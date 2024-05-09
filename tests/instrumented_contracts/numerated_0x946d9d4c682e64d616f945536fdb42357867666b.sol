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
62             registerWithInviterID(_senderAddress,_inviterID);
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
74             registerWithInviterID(_senderAddress,_inviterID);
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
158     function registerWithInviterID(address _senderAddress, uint256 _inviterID) private {
159         totalPlayerNumber++;
160         pIDXpAdd[_senderAddress] = totalPlayerNumber;
161         pAddXpID[totalPlayerNumber] = _senderAddress;
162         pInfoXpAdd[_senderAddress].inviterAddress = pAddXpID[_inviterID];
163     }
164     
165     function buyCore(address _playerAddress,address _inviterAddress,uint256 _amount) private {
166         require(_amount >= 0.01 ether,"You need to pay 0.01 ether at lesat");
167         //10 percent of the investment amount belongs to the inviter
168         address _senderAddress = _playerAddress;
169         if(_inviterAddress == address(0) || _inviterAddress == _senderAddress) {
170             platformBalance = platformBalance.add(_amount/10);
171         } else {
172             pInfoXpAdd[_inviterAddress].inviteEarnings = pInfoXpAdd[_inviterAddress].inviteEarnings.add(_amount/10);
173         }
174         //Record the order of purchase for each user
175         uint256 playerIndex = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber.add(1);
176         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber = playerIndex;
177         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].addXIndex[playerIndex] = _senderAddress;
178         //After the user purchases, they can add 50% more, except for the first user
179         if(rInfoXrID[roundNumber].increaseETH > 0) {
180             rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseMine = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseMine.add(_amount*5/2);
181             rInfoXrID[roundNumber].totalMine = rInfoXrID[roundNumber].totalMine.add(_amount*15/2);
182         } else {
183             rInfoXrID[roundNumber].totalMine = rInfoXrID[roundNumber].totalMine.add(_amount*5);
184         }
185         //Record the accumulated ETH in the prize pool, the newly added ETH each day, the ore and the ore actually purchased by each user
186         rInfoXrID[roundNumber].increaseETH = rInfoXrID[roundNumber].increaseETH.add(_amount).sub(_amount/10);
187         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseETH = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].increaseETH.add(_amount).sub(_amount/10);
188         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].actualMine = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].actualMine.add(_amount*5);
189         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].mineAmountXAddress[_senderAddress] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].mineAmountXAddress[_senderAddress].add(_amount*5);
190         rInfoXrID[roundNumber].dayInfoXDay[dayNumber].ethPayAmountXAddress[_senderAddress] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].ethPayAmountXAddress[_senderAddress].add(_amount);
191     }
192     
193     function playerWithdraw(uint256 _amount) public {
194         address _senderAddress = msg.sender;
195         uint256 balance = getUserBalance(_senderAddress);
196         require(balance>=_amount,"Lack of balance");
197         //The platform charges users 1% of the commission fee, and the rest is withdrawn to the user account
198         platformBalance = platformBalance.add(_amount.div(100));
199         pInfoXpAdd[_senderAddress].withDrawNumber = pInfoXpAdd[_senderAddress].withDrawNumber.add(_amount);
200         _senderAddress.transfer(_amount.sub(_amount.div(100)));
201     }
202     
203     function sendBalanceForDevelop(uint256 _roundID) private {
204         uint256 bouns = getBounsWithRoundID(_roundID).div(5);
205         sysDevelopAddress.transfer(bouns.div(2));
206         sysInviterAddress.transfer(bouns.sub(bouns.div(2)));
207     }
208     
209     //If no users participate in the game for 10 consecutive rounds, the administrator can destroy the contract
210     function kill() public {
211         require(msg.sender == sysAdminAddress,"You can't do this");
212         require(roundNumber>=10,"Wait patiently");
213         bool noPlayer;
214         //Check if users have participated in the last 10 rounds
215         for(uint256 i=0;i<10;i++) {
216             uint256 eth = rInfoXrID[roundNumber-i].increaseETH;
217             if(eth == 0) {
218                 noPlayer = true;
219             } else {
220                 noPlayer = false;
221             }
222         }
223         require(noPlayer,"This cannot be done because the user is still present");
224         uint256 p3dBalance = p3dContract.balanceOf(address(this));
225         p3dContract.transfer(sysAdminAddress,p3dBalance);
226         selfdestruct(sysAdminAddress);
227     }
228 
229     //********************
230     // Calculate Data
231     //********************
232     function getBounsWithRoundID(uint256 _roundID) private view returns(uint256 _bouns) {
233         _bouns = _bouns.add(rInfoXrID[_roundID].bounsInitNumber).add(rInfoXrID[_roundID].increaseETH);
234         return(_bouns);
235     }
236     
237     function getETHNeedPay(uint256 _roundID,uint256 _dayID) private view returns(uint256 _amount) {
238         if(_dayID >=2) {
239             uint256 mineTotal = rInfoXrID[_roundID].totalMine.sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].actualMine).sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseMine);
240             _amount = mineTotal.mul(getTransformRate()).div(10000);
241         } else {
242             _amount = 0;
243         }
244         return(_amount);
245     }
246     
247     function getIncreaseBalance(uint256 _dayID,uint256 _roundID) private view returns(uint256 _balance) {
248         _balance = rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseETH;
249         return(_balance);
250     }
251     
252     function getMineInfoInDay(address _userAddress,uint256 _roundID, uint256 _dayID) private view returns(uint256 _totalMine,uint256 _myMine,uint256 _additional) {
253         //Through traversal, the total amount of ore by the end of the day, the amount of ore held by users, and the amount of additional additional secondary ore
254         for(uint256 i=1;i<=_dayID;i++) {
255             if(rInfoXrID[_roundID].increaseETH == 0) return(0,0,0);
256             uint256 userActualMine = rInfoXrID[_roundID].dayInfoXDay[i].mineAmountXAddress[_userAddress];
257             uint256 increaseMineInDay = rInfoXrID[_roundID].dayInfoXDay[i].increaseMine;
258             _myMine = _myMine.add(userActualMine);
259             _totalMine = _totalMine.add(rInfoXrID[_roundID].dayInfoXDay[i].increaseETH*50/9);
260             uint256 dividendsMine = _myMine.mul(increaseMineInDay).div(_totalMine);
261             _totalMine = _totalMine.add(increaseMineInDay);
262             _myMine = _myMine.add(dividendsMine);
263             _additional = dividendsMine;
264         }
265         return(_totalMine,_myMine,_additional);
266     }
267     
268     //Ore ->eth conversion rate
269     function getTransformRate() private pure returns(uint256 _rate) {
270         return(60);
271     }
272     
273     //Calculate the amount of eth to be paid in x day for user
274     function getTransformMineInDay(address _userAddress,uint256 _roundID,uint256 _dayID) private view returns(uint256 _transformedMine) {
275         (,uint256 userMine,) = getMineInfoInDay(_userAddress,_roundID,_dayID.sub(1));
276         uint256 rate = getTransformRate();
277         _transformedMine = userMine.mul(rate).div(10000);
278         return(_transformedMine);
279     }
280     
281     //Calculate the amount of eth to be paid in x day for all people
282     function calculateTotalMinePay(uint256 _roundID,uint256 _dayID) private view returns(uint256 _needToPay) {
283         uint256 mine = rInfoXrID[_roundID].totalMine.sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].actualMine).sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseMine);
284         _needToPay = mine.mul(getTransformRate()).div(10000);
285         return(_needToPay);
286     }
287 
288     //Calculate daily target values
289     function getDailyTarget(uint256 _roundID,uint256 _dayID) private view returns(uint256) {
290         uint256 needToPay = calculateTotalMinePay(_roundID,_dayID);
291         uint256 target = 0;
292         if (_dayID > 33) {
293             target = (SafeMath.pwr(((3).mul(_dayID).sub(100)),3).mul(50).add(1000000)).mul(needToPay).div(1000000);
294             return(target);
295         } else {
296             target = ((1000000).sub(SafeMath.pwr((100).sub((3).mul(_dayID)),3))).mul(needToPay).div(1000000);
297             if(target == 0) target = 0.0063 ether;
298             return(target);            
299         }
300     }
301     
302     //Query user income balance
303     function getUserBalance(address _userAddress) private view returns(uint256 _balance) {
304         if(pIDXpAdd[_userAddress] == 0) {
305             return(0);
306         }
307         //Amount of user withdrawal
308         uint256 withDrawNumber = pInfoXpAdd[_userAddress].withDrawNumber;
309         uint256 totalTransformed = 0;
310         //Calculate the number of ETH users get through the daily conversion
311         bool islocked = checkContructIsLocked();
312         for(uint256 i=1;i<=roundNumber;i++) {
313             if(islocked && i == roundNumber) {
314                 return;
315             }
316             for(uint256 j=1;j<rInfoXrID[i].totalDay;j++) {
317                 totalTransformed = totalTransformed.add(getTransformMineInDay(_userAddress,i,j));
318             }
319         }
320         //Get the ETH obtained by user invitation
321         uint256 inviteEarnings = pInfoXpAdd[_userAddress].inviteEarnings;
322         _balance = totalTransformed.add(inviteEarnings).add(getBounsEarnings(_userAddress)).add(getHoldEarnings(_userAddress)).add(getUserP3DDivEarnings(_userAddress)).sub(withDrawNumber);
323         return(_balance);
324     }
325     
326     //calculate how much eth user have paid
327     function getUserPaidInCurrentRound(address _userAddress) public view returns(uint256 _payAmount) {
328         if(pInfoXpAdd[_userAddress].getPaidETHBackXRoundID[roundNumber]) {
329             return(0);
330         }
331         for(uint256 i=1;i<=rInfoXrID[roundNumber].totalDay;i++) {
332              _payAmount = _payAmount.add(rInfoXrID[roundNumber].dayInfoXDay[i].ethPayAmountXAddress[_userAddress]);
333         }
334         return(_payAmount);
335     }
336     
337     //user can get eth back if the contract is locked
338     function getPaidETHBack() public {
339         require(checkContructIsLocked(),"The contract is in normal operation");
340         address _sender = msg.sender;
341         uint256 paidAmount = getUserPaidInCurrentRound(_sender);
342         pInfoXpAdd[_sender].getPaidETHBackXRoundID[roundNumber] = true;
343         _sender.transfer(paidAmount);
344     }
345     
346     //Calculated the number of ETH users won in the prize pool
347     function getBounsEarnings(address _userAddress) private view returns(uint256 _bounsEarnings) {
348         for(uint256 i=1;i<roundNumber;i++) {
349             uint256 winnerDay = rInfoXrID[i].winnerDay;
350             uint256 myAmountInWinnerDay=rInfoXrID[i].dayInfoXDay[winnerDay].ethPayAmountXAddress[_userAddress];
351             uint256 totalAmountInWinnerDay=rInfoXrID[i].dayInfoXDay[winnerDay].increaseETH*10/9;
352             if(winnerDay == 0 || totalAmountInWinnerDay == 0) {
353                 _bounsEarnings = _bounsEarnings;
354             } else {
355                 uint256 bouns = getBounsWithRoundID(i).mul(14).div(25);
356                 _bounsEarnings = _bounsEarnings.add(bouns.mul(myAmountInWinnerDay).div(totalAmountInWinnerDay));
357             }
358         }
359         return(_bounsEarnings);
360     }
361 
362     //Compute the ETH that the user acquires by holding the ore
363     function getHoldEarnings(address _userAddress) private view returns(uint256 _holdEarnings) {
364         for(uint256 i=1;i<roundNumber;i++) {
365             uint256 winnerDay = rInfoXrID[i].winnerDay;
366             if(winnerDay == 0) {
367                 _holdEarnings = _holdEarnings;
368             } else {  
369                 (uint256 totalMine,uint256 myMine,) = getMineInfoInDay(_userAddress,i,rInfoXrID[i].totalDay);
370                 uint256 bouns = getBounsWithRoundID(i).mul(7).div(50);
371                 _holdEarnings = _holdEarnings.add(bouns.mul(myMine).div(totalMine));    
372             }
373         }
374         return(_holdEarnings);
375     }
376     
377     //Calculate user's P3D bonus
378     function getUserP3DDivEarnings(address _userAddress) private view returns(uint256 _myP3DDivide) {
379         if(rInfoXrID[roundNumber].totalDay <= 1) {
380             return(0);
381         }
382         for(uint256 i=1;i<roundNumber;i++) {
383             uint256 p3dDay = rInfoXrID[i].totalDay;
384             uint256 myAmountInp3dDay=rInfoXrID[i].dayInfoXDay[p3dDay].ethPayAmountXAddress[_userAddress];
385             uint256 totalAmountInP3dDay=rInfoXrID[i].dayInfoXDay[p3dDay].increaseETH*10/9;
386             if(p3dDay == 0 || totalAmountInP3dDay == 0) {
387                 _myP3DDivide = _myP3DDivide;
388             } else {
389                 uint256 p3dDividesInRound = p3dDividesXroundID[i];
390                 _myP3DDivide = _myP3DDivide.add(p3dDividesInRound.mul(myAmountInp3dDay).div(totalAmountInP3dDay));
391             }
392         }
393         return(_myP3DDivide);
394     }
395     
396     //*******************
397     // Check contract lock
398     //*******************
399     function checkContructIsLocked() public view returns(bool) {
400         uint256 time = now.sub(rInfoXrID[roundNumber].lastCalculateTime);
401         if(time >= 2*cycleTime) {
402             return(true);
403         } else {
404             return(false);
405         }
406     }
407 
408     //*******************
409     // UI 
410     //*******************
411     function getDefendPlayerList() public view returns(address[]) {
412         if (rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber == 0) {
413             address[] memory playerListEmpty = new address[](0);
414             return(playerListEmpty);
415         }
416         uint256 number = rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber;
417         if(number > 100) {
418             number == 100;
419         }
420         address[] memory playerList = new address[](number);
421         for(uint256 i=0;i<number;i++) {
422             playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].addXIndex[i+1];
423         }
424         return(playerList);
425     }
426     
427     function getAttackPlayerList() public view returns(address[]) {
428         uint256 number = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber;
429         if(number > 100) {
430             number == 100;
431         }
432         address[] memory playerList = new address[](number);
433         for(uint256 i=0;i<number;i++) {
434             playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].addXIndex[i+1];
435         }
436         return(playerList);
437     }
438     
439     function getCurrentFieldBalanceAndTarget() public view returns(uint256 day,uint256 bouns,uint256 todayBouns,uint256 dailyTarget) {
440         uint256 fieldBalance = getBounsWithRoundID(roundNumber).mul(7).div(10);
441         uint256 todayBalance = getIncreaseBalance(dayNumber,roundNumber) ;
442         dailyTarget = getDailyTarget(roundNumber,dayNumber);
443         return(dayNumber,fieldBalance,todayBalance,dailyTarget);
444     }
445     
446     function getUserIDAndInviterEarnings() public view returns(uint256 userID,uint256 inviteEarning) {
447         return(pIDXpAdd[msg.sender],pInfoXpAdd[msg.sender].inviteEarnings);
448     }
449     
450     function getCurrentRoundInfo() public view returns(uint256 _roundID,uint256 _dayNumber,uint256 _ethMineNumber,uint256 _startTime,uint256 _lastCalculateTime) {
451         DataModal.RoundInfo memory roundInfo = rInfoXrID[roundNumber];
452         (uint256 totalMine,,) = getMineInfoInDay(msg.sender,roundNumber,dayNumber);
453         return(roundNumber,dayNumber,totalMine,roundInfo.startTime,roundInfo.lastCalculateTime);
454     }
455     
456     function getUserProperty() public view returns(uint256 ethMineNumber,uint256 holdEarning,uint256 transformRate,uint256 ethBalance,uint256 ethTranslated,uint256 ethMineCouldTranslateToday,uint256 ethCouldGetToday) {
457         address _userAddress = msg.sender;
458         if(pIDXpAdd[_userAddress] <1) {
459             return(0,0,0,0,0,0,0);        
460         }
461         (,uint256 myMine,uint256 additional) = getMineInfoInDay(_userAddress,roundNumber,dayNumber);
462         ethMineNumber = myMine;
463         holdEarning = additional;
464         transformRate = getTransformRate();      
465         ethBalance = getUserBalance(_userAddress);
466         uint256 totalTransformed = 0;
467         for(uint256 i=1;i<rInfoXrID[roundNumber].totalDay;i++) {
468             totalTransformed = totalTransformed.add(getTransformMineInDay(_userAddress,roundNumber,i));
469         }
470         ethTranslated = totalTransformed;
471         ethCouldGetToday = getTransformMineInDay(_userAddress,roundNumber,dayNumber);
472         (,uint256 userMine,) = getMineInfoInDay(_userAddress,roundNumber,dayNumber.sub(1));
473         if(userMine == 0) {
474             ethCouldGetToday = 0;
475         }else{
476             ethMineCouldTranslateToday = myMine.mul(transformRate).div(10000);
477         }
478         return(
479             ethMineNumber,
480             holdEarning,
481             transformRate,
482             ethBalance,
483             ethTranslated,
484             ethMineCouldTranslateToday,
485             ethCouldGetToday
486             );
487     }
488     
489     function getPlatformBalance() public view returns(uint256 _platformBalance) {
490         require(msg.sender == sysAdminAddress,"Ummmmm......Only admin could do this");
491         return(platformBalance);
492     }
493 
494     //************
495     // for statistics
496     //************
497     function getDataOfGame() public view returns(uint256 _playerNumber,uint256 _dailyIncreased,uint256 _dailyTransform,uint256 _contractBalance,uint256 _userBalanceLeft,uint256 _platformBalance,uint256 _mineBalance,uint256 _balanceOfMine) {
498         for(uint256 i=1;i<=totalPlayerNumber;i++) {
499             address userAddress = pAddXpID[i];
500             _userBalanceLeft = _userBalanceLeft.add(getUserBalance(userAddress));
501         }
502         return(
503             totalPlayerNumber,
504             getIncreaseBalance(dayNumber,roundNumber),
505             calculateTotalMinePay(roundNumber,dayNumber),
506             address(this).balance,
507             _userBalanceLeft,
508             platformBalance,
509             getBounsWithRoundID(roundNumber),
510             getBounsWithRoundID(roundNumber).mul(7).div(10)
511             );
512     }
513     
514     function getUserAddressList() public view returns(address[]) {
515         address[] memory addressList = new address[](totalPlayerNumber);
516         for(uint256 i=0;i<totalPlayerNumber;i++) {
517             addressList[i] = pAddXpID[i+1];
518         }
519         return(addressList);
520     }
521     
522     function getUsersInfo() public view returns(uint256[7][]){
523         uint256[7][] memory infoList = new uint256[7][](totalPlayerNumber);
524         for(uint256 i=0;i<totalPlayerNumber;i++) {
525             address userAddress = pAddXpID[i+1];
526             (,uint256 myMine,uint256 additional) = getMineInfoInDay(userAddress,roundNumber,dayNumber);
527             uint256 totalTransformed = 0;
528             for(uint256 j=1;j<=roundNumber;j++) {
529                 for(uint256 k=1;k<=rInfoXrID[j].totalDay;k++) {
530                     totalTransformed = totalTransformed.add(getTransformMineInDay(userAddress,j,k));
531                 }
532             }
533             infoList[i][0] = myMine ;
534             infoList[i][1] = getTransformRate();
535             infoList[i][2] = additional;
536             infoList[i][3] = getUserBalance(userAddress);
537             infoList[i][4] = getUserBalance(userAddress).add(pInfoXpAdd[userAddress].withDrawNumber);
538             infoList[i][5] = pInfoXpAdd[userAddress].inviteEarnings;
539             infoList[i][6] = totalTransformed;
540         }        
541         return(infoList);
542     }
543     
544     function getP3DInfo() public view returns(uint256 _p3dTokenInContract,uint256 _p3dDivInRound) {
545         _p3dTokenInContract = p3dContract.balanceOf(address(this));
546         _p3dDivInRound = p3dDividesXroundID[roundNumber];
547         return(_p3dTokenInContract,_p3dDivInRound);
548     }
549     
550 }
551 
552 //P3D Interface
553 interface HourglassInterface {
554     function buy(address _playerAddress) payable external returns(uint256);
555     function withdraw() external;
556     function myDividends(bool _includeReferralBonus) external view returns(uint256);
557     function balanceOf(address _customerAddress) external view returns(uint256);
558     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
559 }
560 
561 library DataModal {
562     struct PlayerInfo {
563         uint256 inviteEarnings;
564         address inviterAddress;
565         uint256 withDrawNumber;
566         mapping(uint256=>bool) getPaidETHBackXRoundID;
567     }
568     
569     struct DayInfo {
570         uint256 playerNumber;
571         uint256 actualMine;
572         uint256 increaseETH;
573         uint256 increaseMine;
574         mapping(uint256=>address) addXIndex;
575         mapping(address=>uint256) ethPayAmountXAddress;
576         mapping(address=>uint256) mineAmountXAddress;
577     }
578     
579     struct RoundInfo {
580         uint256 startTime;
581         uint256 lastCalculateTime;
582         uint256 bounsInitNumber;
583         uint256 increaseETH;
584         uint256 totalDay;
585         uint256 winnerDay;
586         uint256 totalMine;
587         mapping(uint256=>DayInfo) dayInfoXDay;
588     }
589 }
590 
591 library SafeMath {
592     /**
593     * @dev Multiplies two numbers, throws on overflow.
594     */
595     function mul(uint256 a, uint256 b) 
596         internal 
597         pure 
598         returns (uint256 c) 
599     {
600         if (a == 0) {
601             return 0;
602         }
603         c = a * b;
604         require(c / a == b, "SafeMath mul failed");
605         return c;
606     }
607     
608     function div(uint256 a, uint256 b) internal pure returns (uint256) {
609         require(b != 0, "SafeMath div failed");
610         uint256 c = a / b;
611         return c;
612     } 
613 
614     /**
615     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
616     */
617     function sub(uint256 a, uint256 b)
618         internal
619         pure
620         returns (uint256) 
621     {
622         require(b <= a, "SafeMath sub failed");
623         return a - b;
624     }
625 
626     /**
627     * @dev Adds two numbers, throws on overflow.
628     */
629     function add(uint256 a, uint256 b)
630         internal
631         pure
632         returns (uint256 c) 
633     {
634         c = a + b;
635         require(c >= a, "SafeMath add failed");
636         return c;
637     }
638     
639     /**
640      * @dev gives square root of given x.
641      */
642     function sqrt(uint256 x)
643         internal
644         pure
645         returns (uint256 y) 
646     {
647         uint256 z = ((add(x,1)) / 2);
648         y = x;
649         while (z < y) 
650         {
651             y = z;
652             z = ((add((x / z),z)) / 2);
653         }
654     }
655     
656     /**
657      * @dev gives square. multiplies x by x
658      */
659     function sq(uint256 x)
660         internal
661         pure
662         returns (uint256)
663     {
664         return (mul(x,x));
665     }
666     
667     /**
668      * @dev x to the power of y 
669      */
670     function pwr(uint256 x, uint256 y)
671         internal 
672         pure 
673         returns (uint256)
674     {
675         if (x==0)
676             return (0);
677         else if (y==0)
678             return (1);
679         else 
680         {
681             uint256 z = x;
682             for (uint256 i=1; i < y; i++)
683                 z = mul(z,x);
684             return (z);
685         }
686     }
687 }