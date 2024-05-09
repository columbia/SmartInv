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
226         sysAdminAddress.transfer(address(this).balance);
227         selfdestruct(sysAdminAddress);
228     }
229 
230     //********************
231     // Calculate Data
232     //********************
233     function getBounsWithRoundID(uint256 _roundID) private view returns(uint256 _bouns) {
234         _bouns = _bouns.add(rInfoXrID[_roundID].bounsInitNumber).add(rInfoXrID[_roundID].increaseETH);
235         return(_bouns);
236     }
237     
238     function getETHNeedPay(uint256 _roundID,uint256 _dayID) private view returns(uint256 _amount) {
239         if(_dayID >=2) {
240             uint256 mineTotal = rInfoXrID[_roundID].totalMine.sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].actualMine).sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseMine);
241             _amount = mineTotal.mul(getTransformRate()).div(10000);
242         } else {
243             _amount = 0;
244         }
245         return(_amount);
246     }
247     
248     function getIncreaseBalance(uint256 _dayID,uint256 _roundID) private view returns(uint256 _balance) {
249         _balance = rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseETH;
250         return(_balance);
251     }
252     
253     function getMineInfoInDay(address _userAddress,uint256 _roundID, uint256 _dayID) private view returns(uint256 _totalMine,uint256 _myMine,uint256 _additional) {
254         //Through traversal, the total amount of ore by the end of the day, the amount of ore held by users, and the amount of additional additional secondary ore
255         for(uint256 i=1;i<=_dayID;i++) {
256             if(rInfoXrID[_roundID].increaseETH == 0) return(0,0,0);
257             uint256 userActualMine = rInfoXrID[_roundID].dayInfoXDay[i].mineAmountXAddress[_userAddress];
258             uint256 increaseMineInDay = rInfoXrID[_roundID].dayInfoXDay[i].increaseMine;
259             _myMine = _myMine.add(userActualMine);
260             _totalMine = _totalMine.add(rInfoXrID[_roundID].dayInfoXDay[i].increaseETH*50/9);
261             uint256 dividendsMine = _myMine.mul(increaseMineInDay).div(_totalMine);
262             _totalMine = _totalMine.add(increaseMineInDay);
263             _myMine = _myMine.add(dividendsMine);
264             _additional = dividendsMine;
265         }
266         return(_totalMine,_myMine,_additional);
267     }
268     
269     //Ore ->eth conversion rate
270     function getTransformRate() private pure returns(uint256 _rate) {
271         return(60);
272     }
273     
274     //Calculate the amount of eth to be paid in x day for user
275     function getTransformMineInDay(address _userAddress,uint256 _roundID,uint256 _dayID) private view returns(uint256 _transformedMine) {
276         (,uint256 userMine,) = getMineInfoInDay(_userAddress,_roundID,_dayID.sub(1));
277         uint256 rate = getTransformRate();
278         _transformedMine = userMine.mul(rate).div(10000);
279         return(_transformedMine);
280     }
281     
282     //Calculate the amount of eth to be paid in x day for all people
283     function calculateTotalMinePay(uint256 _roundID,uint256 _dayID) private view returns(uint256 _needToPay) {
284         uint256 mine = rInfoXrID[_roundID].totalMine.sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].actualMine).sub(rInfoXrID[_roundID].dayInfoXDay[_dayID].increaseMine);
285         _needToPay = mine.mul(getTransformRate()).div(10000);
286         return(_needToPay);
287     }
288 
289     //Calculate daily target values
290     function getDailyTarget(uint256 _roundID,uint256 _dayID) private view returns(uint256) {
291         uint256 needToPay = calculateTotalMinePay(_roundID,_dayID);
292         uint256 target = 0;
293         if (_dayID > 33) {
294             target = (SafeMath.pwr(((3).mul(_dayID).sub(100)),3).mul(50).add(1000000)).mul(needToPay).div(1000000);
295             return(target);
296         } else {
297             target = ((1000000).sub(SafeMath.pwr((100).sub((3).mul(_dayID)),3))).mul(needToPay).div(1000000);
298             if(target == 0) target = 0.0063 ether;
299             return(target);            
300         }
301     }
302     
303     //Query user income balance
304     function getUserBalance(address _userAddress) private view returns(uint256 _balance) {
305         if(pIDXpAdd[_userAddress] == 0) {
306             return(0);
307         }
308         //Amount of user withdrawal
309         uint256 withDrawNumber = pInfoXpAdd[_userAddress].withDrawNumber;
310         uint256 totalTransformed = 0;
311         //Calculate the number of ETH users get through the daily conversion
312         bool islocked = checkContructIsLocked();
313         for(uint256 i=1;i<=roundNumber;i++) {
314             if(islocked && i == roundNumber) {
315                 return;
316             }
317             for(uint256 j=1;j<rInfoXrID[i].totalDay;j++) {
318                 totalTransformed = totalTransformed.add(getTransformMineInDay(_userAddress,i,j));
319             }
320         }
321         //Get the ETH obtained by user invitation
322         uint256 inviteEarnings = pInfoXpAdd[_userAddress].inviteEarnings;
323         _balance = totalTransformed.add(inviteEarnings).add(getBounsEarnings(_userAddress)).add(getHoldEarnings(_userAddress)).add(getUserP3DDivEarnings(_userAddress)).sub(withDrawNumber);
324         return(_balance);
325     }
326     
327     //calculate how much eth user have paid
328     function getUserPayedInCurrentRound(address _userAddress) public view returns(uint256 _payAmount) {
329         if(pInfoXpAdd[_userAddress].getPaidETHBackXRoundID[roundNumber]) {
330             return(0);
331         }
332         for(uint256 i=1;i<=rInfoXrID[roundNumber].totalDay;i++) {
333              _payAmount = _payAmount.add(rInfoXrID[roundNumber].dayInfoXDay[i].ethPayAmountXAddress[_userAddress]);
334         }
335         return(_payAmount);
336     }
337     
338     //user can get eth back if the contract is locked
339     function getPaidETHBack() public {
340         require(checkContructIsLocked(),"The contract is in normal operation");
341         address _sender = msg.sender;
342         uint256 paidAmount = getUserPayedInCurrentRound(_sender);
343         pInfoXpAdd[_sender].getPaidETHBackXRoundID[roundNumber] = true;
344         _sender.transfer(paidAmount);
345     }
346     
347     //Calculated the number of ETH users won in the prize pool
348     function getBounsEarnings(address _userAddress) private view returns(uint256 _bounsEarnings) {
349         for(uint256 i=1;i<roundNumber;i++) {
350             uint256 winnerDay = rInfoXrID[i].winnerDay;
351             uint256 myAmountInWinnerDay=rInfoXrID[i].dayInfoXDay[winnerDay].ethPayAmountXAddress[_userAddress];
352             uint256 totalAmountInWinnerDay=rInfoXrID[i].dayInfoXDay[winnerDay].increaseETH*10/9;
353             if(winnerDay == 0) {
354                 _bounsEarnings = _bounsEarnings;
355             } else {
356                 uint256 bouns = getBounsWithRoundID(i).mul(14).div(25);
357                 _bounsEarnings = _bounsEarnings.add(bouns.mul(myAmountInWinnerDay).div(totalAmountInWinnerDay));
358             }
359         }
360         return(_bounsEarnings);
361     }
362 
363     //Compute the ETH that the user acquires by holding the ore
364     function getHoldEarnings(address _userAddress) private view returns(uint256 _holdEarnings) {
365         for(uint256 i=1;i<roundNumber;i++) {
366             uint256 winnerDay = rInfoXrID[i].winnerDay;
367             if(winnerDay == 0) {
368                 _holdEarnings = _holdEarnings;
369             } else {  
370                 (uint256 totalMine,uint256 myMine,) = getMineInfoInDay(_userAddress,i,rInfoXrID[i].totalDay);
371                 uint256 bouns = getBounsWithRoundID(i).mul(7).div(50);
372                 _holdEarnings = _holdEarnings.add(bouns.mul(myMine).div(totalMine));    
373             }
374         }
375         return(_holdEarnings);
376     }
377     
378     //Calculate user's P3D bonus
379     function getUserP3DDivEarnings(address _userAddress) private view returns(uint256 _myP3DDivide) {
380         if(rInfoXrID[roundNumber].totalDay <= 1) {
381             return(0);
382         }
383         for(uint256 i=1;i<roundNumber;i++) {
384             uint256 p3dDay = rInfoXrID[i].totalDay;
385             uint256 myAmountInp3dDay=rInfoXrID[i].dayInfoXDay[p3dDay].ethPayAmountXAddress[_userAddress];
386             uint256 totalAmountInP3dDay=rInfoXrID[i].dayInfoXDay[p3dDay].increaseETH*10/9;
387             if(p3dDay == 0) {
388                 _myP3DDivide = _myP3DDivide;
389             } else {
390                 uint256 p3dDividesInRound = p3dDividesXroundID[i];
391                 _myP3DDivide = _myP3DDivide.add(p3dDividesInRound.mul(myAmountInp3dDay).div(totalAmountInP3dDay));
392             }
393         }
394         return(_myP3DDivide);
395     }
396     
397     //*******************
398     // Check contract lock
399     //*******************
400     function checkContructIsLocked() public view returns(bool) {
401         uint256 time = now.sub(rInfoXrID[roundNumber].lastCalculateTime);
402         if(time >= 2*cycleTime) {
403             return(true);
404         } else {
405             return(false);
406         }
407     }
408 
409     //*******************
410     // UI 
411     //*******************
412     function getDefendPlayerList() public view returns(address[]) {
413         if (rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber == 0) {
414             address[] memory playerListEmpty = new address[](0);
415             return(playerListEmpty);
416         }
417         uint256 number = rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].playerNumber;
418         if(number > 100) {
419             number == 100;
420         }
421         address[] memory playerList = new address[](number);
422         for(uint256 i=0;i<number;i++) {
423             playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber-1].addXIndex[i+1];
424         }
425         return(playerList);
426     }
427     
428     function getAttackPlayerList() public view returns(address[]) {
429         uint256 number = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].playerNumber;
430         if(number > 100) {
431             number == 100;
432         }
433         address[] memory playerList = new address[](number);
434         for(uint256 i=0;i<number;i++) {
435             playerList[i] = rInfoXrID[roundNumber].dayInfoXDay[dayNumber].addXIndex[i+1];
436         }
437         return(playerList);
438     }
439     
440     function getCurrentFieldBalanceAndTarget() public view returns(uint256 day,uint256 bouns,uint256 todayBouns,uint256 dailyTarget) {
441         uint256 fieldBalance = getBounsWithRoundID(roundNumber).mul(7).div(10);
442         uint256 todayBalance = getIncreaseBalance(dayNumber,roundNumber) ;
443         dailyTarget = getDailyTarget(roundNumber,dayNumber);
444         return(dayNumber,fieldBalance,todayBalance,dailyTarget);
445     }
446     
447     function getUserIDAndInviterEarnings() public view returns(uint256 userID,uint256 inviteEarning) {
448         return(pIDXpAdd[msg.sender],pInfoXpAdd[msg.sender].inviteEarnings);
449     }
450     
451     function getCurrentRoundInfo() public view returns(uint256 _roundID,uint256 _dayNumber,uint256 _ethMineNumber,uint256 _startTime,uint256 _lastCalculateTime) {
452         DataModal.RoundInfo memory roundInfo = rInfoXrID[roundNumber];
453         (uint256 totalMine,,) = getMineInfoInDay(msg.sender,roundNumber,dayNumber);
454         return(roundNumber,dayNumber,totalMine,roundInfo.startTime,roundInfo.lastCalculateTime);
455     }
456     
457     function getUserProperty() public view returns(uint256 ethMineNumber,uint256 holdEarning,uint256 transformRate,uint256 ethBalance,uint256 ethTranslated,uint256 ethMineCouldTranslateToday,uint256 ethCouldGetToday) {
458         if(pIDXpAdd[msg.sender] <1) {
459             return(0,0,0,0,0,0,0);        
460         }
461         (,uint256 myMine,uint256 additional) = getMineInfoInDay(msg.sender,roundNumber,dayNumber);
462         ethMineNumber = myMine;
463         holdEarning = additional;
464         transformRate = getTransformRate();      
465         ethBalance = getUserBalance(msg.sender);
466         uint256 totalTransformed = 0;
467         for(uint256 i=1;i<rInfoXrID[roundNumber].totalDay;i++) {
468             totalTransformed = totalTransformed.add(getTransformMineInDay(msg.sender,roundNumber,i));
469         }
470         ethTranslated = totalTransformed;
471         ethCouldGetToday = getTransformMineInDay(msg.sender,roundNumber,dayNumber);
472         ethMineCouldTranslateToday = myMine.mul(transformRate).div(10000);
473         return(
474             ethMineNumber,
475             holdEarning,
476             transformRate,
477             ethBalance,
478             ethTranslated,
479             ethMineCouldTranslateToday,
480             ethCouldGetToday
481             );
482     }
483     
484     function getPlatformBalance() public view returns(uint256 _platformBalance) {
485         require(msg.sender == sysAdminAddress,"Ummmmm......Only admin could do this");
486         return(platformBalance);
487     }
488 
489     //************
490     // for statistics
491     //************
492     function getDataOfGame() public view returns(uint256 _playerNumber,uint256 _dailyIncreased,uint256 _dailyTransform,uint256 _contractBalance,uint256 _userBalanceLeft,uint256 _platformBalance,uint256 _mineBalance,uint256 _balanceOfMine) {
493         for(uint256 i=1;i<=totalPlayerNumber;i++) {
494             address userAddress = pAddXpID[i];
495             _userBalanceLeft = _userBalanceLeft.add(getUserBalance(userAddress));
496         }
497         return(
498             totalPlayerNumber,
499             getIncreaseBalance(dayNumber,roundNumber),
500             calculateTotalMinePay(roundNumber,dayNumber),
501             address(this).balance,
502             _userBalanceLeft,
503             platformBalance,
504             getBounsWithRoundID(roundNumber),
505             getBounsWithRoundID(roundNumber).mul(7).div(10)
506             );
507     }
508     
509     function getUserAddressList() public view returns(address[]) {
510         address[] memory addressList = new address[](totalPlayerNumber);
511         for(uint256 i=0;i<totalPlayerNumber;i++) {
512             addressList[i] = pAddXpID[i+1];
513         }
514         return(addressList);
515     }
516     
517     function getUsersInfo() public view returns(uint256[7][]){
518         uint256[7][] memory infoList = new uint256[7][](totalPlayerNumber);
519         for(uint256 i=0;i<totalPlayerNumber;i++) {
520             address userAddress = pAddXpID[i+1];
521             (,uint256 myMine,uint256 additional) = getMineInfoInDay(userAddress,roundNumber,dayNumber);
522             uint256 totalTransformed = 0;
523             for(uint256 j=1;j<=roundNumber;j++) {
524                 for(uint256 k=1;k<=rInfoXrID[j].totalDay;k++) {
525                     totalTransformed = totalTransformed.add(getTransformMineInDay(userAddress,j,k));
526                 }
527             }
528             infoList[i][0] = myMine ;
529             infoList[i][1] = getTransformRate();
530             infoList[i][2] = additional;
531             infoList[i][3] = getUserBalance(userAddress);
532             infoList[i][4] = getUserBalance(userAddress).add(pInfoXpAdd[userAddress].withDrawNumber);
533             infoList[i][5] = pInfoXpAdd[userAddress].inviteEarnings;
534             infoList[i][6] = totalTransformed;
535         }        
536         return(infoList);
537     }
538     
539     function getP3DInfo() public view returns(uint256 _p3dTokenInContract,uint256 _p3dDivInRound) {
540         _p3dTokenInContract = p3dContract.balanceOf(address(this));
541         _p3dDivInRound = p3dDividesXroundID[roundNumber];
542         return(_p3dTokenInContract,_p3dDivInRound);
543     }
544     
545 }
546 
547 //P3D Interface
548 interface HourglassInterface {
549     function buy(address _playerAddress) payable external returns(uint256);
550     function withdraw() external;
551     function myDividends(bool _includeReferralBonus) external view returns(uint256);
552     function balanceOf(address _customerAddress) external view returns(uint256);
553     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
554 }
555 
556 library DataModal {
557     struct PlayerInfo {
558         uint256 inviteEarnings;
559         address inviterAddress;
560         uint256 withDrawNumber;
561         mapping(uint256=>bool) getPaidETHBackXRoundID;
562     }
563     
564     struct DayInfo {
565         uint256 playerNumber;
566         uint256 actualMine;
567         uint256 increaseETH;
568         uint256 increaseMine;
569         mapping(uint256=>address) addXIndex;
570         mapping(address=>uint256) ethPayAmountXAddress;
571         mapping(address=>uint256) mineAmountXAddress;
572     }
573     
574     struct RoundInfo {
575         uint256 startTime;
576         uint256 lastCalculateTime;
577         uint256 bounsInitNumber;
578         uint256 increaseETH;
579         uint256 totalDay;
580         uint256 winnerDay;
581         uint256 totalMine;
582         mapping(uint256=>DayInfo) dayInfoXDay;
583     }
584 }
585 
586 library SafeMath {
587     /**
588     * @dev Multiplies two numbers, throws on overflow.
589     */
590     function mul(uint256 a, uint256 b) 
591         internal 
592         pure 
593         returns (uint256 c) 
594     {
595         if (a == 0) {
596             return 0;
597         }
598         c = a * b;
599         require(c / a == b, "SafeMath mul failed");
600         return c;
601     }
602     
603     function div(uint256 a, uint256 b) internal pure returns (uint256) {
604         require(b != 0, "SafeMath div failed");
605         uint256 c = a / b;
606         return c;
607     } 
608 
609     /**
610     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
611     */
612     function sub(uint256 a, uint256 b)
613         internal
614         pure
615         returns (uint256) 
616     {
617         require(b <= a, "SafeMath sub failed");
618         return a - b;
619     }
620 
621     /**
622     * @dev Adds two numbers, throws on overflow.
623     */
624     function add(uint256 a, uint256 b)
625         internal
626         pure
627         returns (uint256 c) 
628     {
629         c = a + b;
630         require(c >= a, "SafeMath add failed");
631         return c;
632     }
633     
634     /**
635      * @dev gives square root of given x.
636      */
637     function sqrt(uint256 x)
638         internal
639         pure
640         returns (uint256 y) 
641     {
642         uint256 z = ((add(x,1)) / 2);
643         y = x;
644         while (z < y) 
645         {
646             y = z;
647             z = ((add((x / z),z)) / 2);
648         }
649     }
650     
651     /**
652      * @dev gives square. multiplies x by x
653      */
654     function sq(uint256 x)
655         internal
656         pure
657         returns (uint256)
658     {
659         return (mul(x,x));
660     }
661     
662     /**
663      * @dev x to the power of y 
664      */
665     function pwr(uint256 x, uint256 y)
666         internal 
667         pure 
668         returns (uint256)
669     {
670         if (x==0)
671             return (0);
672         else if (y==0)
673             return (1);
674         else 
675         {
676             uint256 z = x;
677             for (uint256 i=1; i < y; i++)
678                 z = mul(z,x);
679             return (z);
680         }
681     }
682 }