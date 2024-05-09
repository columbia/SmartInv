1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 
30 contract BaseGame { 
31 	function canSetBanker() view public returns (bool _result);
32     function setBanker(address _banker, uint256 _beginTime, uint256 _endTime) public returns(bool _result);
33     
34     string public gameName = "NO.1";
35     uint public gameType = 2004;
36     string public officialGameUrl;
37 
38 	uint public bankerBeginTime;
39 	uint public bankerEndTime;
40 	address public currentBanker;
41 	
42 	function depositToken(uint256 _amount) public;
43 	function withdrawAllToken() public;
44     function withdrawToken(uint256 _amount) public;
45     mapping (address => uint256) public userTokenOf;
46 
47 }
48 interface IDonQuixoteToken{
49     function withhold(address _user,  uint256 _amount) external returns (bool _result);
50     function transfer(address _to, uint256 _value) external;
51 	//function canSendGameGift() view external returns(bool _result);
52     function sendGameGift(address _player) external returns (bool _result);
53 	function logPlaying(address _player) external returns (bool _result);
54 	function balanceOf(address _user) constant external returns(uint256 balance);
55 }  
56 
57 
58 contract Base is BaseGame{
59 	using SafeMath for uint256; 
60     uint public createTime = now;
61     address public owner;
62 	IDonQuixoteToken public DonQuixoteToken;
63 
64     function Base() public {
65     }
66 
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     function setOwner(address _newOwner) public onlyOwner {
73         owner = _newOwner;
74     }
75 
76     bool public globalLocked = false;
77 
78     function lock() internal {
79         require(!globalLocked);
80         globalLocked = true;
81     }
82 
83     function unLock() internal {
84         require(globalLocked);
85         globalLocked = false;
86     }
87 
88     function setLock()  public onlyOwner{
89         globalLocked = false;
90     }
91 	
92 	function tokenOf(address _user) view public returns(uint256 _result){
93 		_result = DonQuixoteToken.balanceOf(_user);
94 	}
95     
96     function depositToken(uint256 _amount) public {
97         lock();
98         _depositToken(msg.sender, _amount);
99         unLock();
100     }
101 
102     function _depositToken(address _to, uint256 _amount) internal {
103         require(_to != 0x0);
104         DonQuixoteToken.withhold(_to, _amount);
105         userTokenOf[_to] = userTokenOf[_to].add(_amount);
106     }
107 
108     function withdrawAllToken() public {    
109         lock();  
110 		uint256 _amount = userTokenOf[msg.sender];
111         _withdrawToken(msg.sender,_amount);
112         unLock();
113     }
114 	
115 	function withdrawToken(uint256 _amount) public {   
116         lock();  
117         _withdrawToken(msg.sender, _amount);
118         unLock();
119     }
120 	
121     function _withdrawToken(address _from, uint256 _amount) internal {
122         require(_from != 0x0);
123 		require(_amount > 0 && _amount <= userTokenOf[_from]);
124 		userTokenOf[_from] = userTokenOf[_from].sub(_amount);
125 		DonQuixoteToken.transfer(_from, _amount);
126     }
127 	
128 	uint public currentEventId = 1;
129 
130     function getEventId() internal returns(uint _result) {
131         _result = currentEventId;
132         currentEventId = currentEventId.add(1); //currentEventId++
133     }
134 	
135     function setOfficialGameUrl(string _newOfficialGameUrl) public onlyOwner{
136         officialGameUrl = _newOfficialGameUrl;
137     }
138 }
139 
140 contract SoccerBet is Base
141 {
142 	function SoccerBet(string _gameName,uint _bankerDepositPer, address _DonQuixoteToken) public {
143 		require(_DonQuixoteToken != 0x0);
144 		gameName = _gameName;
145 		bankerDepositPer = _bankerDepositPer;
146         DonQuixoteToken = IDonQuixoteToken(_DonQuixoteToken);
147         owner = msg.sender;
148     }
149 
150 	uint public unpayPooling = 0;
151 	uint public losePooling = 0;
152 	uint public winPooling = 0;
153 	uint public samePooling = 0;
154 	
155 	uint public bankerDepositPer = 20;
156 
157     address public auction;
158 	function setAuction(address _newAuction) public onlyOwner{
159         auction = _newAuction;
160     }
161     modifier onlyAuction {
162 	    require(msg.sender == auction);
163         _;
164     }
165 	
166     modifier onlyBanker {
167         require(msg.sender == currentBanker);
168         require(bankerBeginTime <= now);
169         require(now < bankerEndTime);
170         _;
171     }    
172 	
173 	function canSetBanker() public view returns (bool _result){
174         _result =  false;
175 		if(now < bankerEndTime){
176 			return;
177 		}
178 		if(userTokenOf[this] == 0){
179 			_result = true;
180 		}
181     }
182 	
183 	event OnSetNewBanker(uint indexed _gameID , address _caller, address _banker, uint _beginTime, uint _endTime, uint _errInfo, uint _eventTime, uint eventId);
184     function setBanker(address _banker, uint _beginTime, uint _endTime) public onlyAuction returns(bool _result)
185     {
186         _result = false;
187         require(_banker != 0x0);
188 
189         if(now < bankerEndTime){
190             emit OnSetNewBanker(gameID, msg.sender, _banker,  _beginTime,  _endTime, 1, now, getEventId());//"bankerEndTime > now"
191             return;
192         }
193 		
194 		if(userTokenOf[this] > 0){
195 			emit OnSetNewBanker(gameID, msg.sender, _banker,  _beginTime,  _endTime, 5, now, getEventId());//"userTokenOf[this] > 0"
196 			return;
197 		}
198         
199         if(_beginTime > now){
200 			emit OnSetNewBanker(gameID, msg.sender, _banker,  _beginTime,  _endTime, 3, now, getEventId());//'_beginTime > now'
201             return;
202         }
203 
204         if(_endTime <= now){
205 			emit OnSetNewBanker(gameID, msg.sender, _banker,  _beginTime,  _endTime, 4, now, getEventId());//'_endTime <= now'
206             return;
207         }
208 		
209 		if(now < donGameGiftLineTime){
210             DonQuixoteToken.logPlaying(_banker);
211         }
212         currentBanker = _banker;
213         bankerBeginTime = _beginTime;
214         bankerEndTime =  _endTime;
215 	
216 		unpayPooling = 0;
217 		losePooling = 0;
218 		winPooling = 0;
219 		samePooling = 0;
220 		
221 		gameResult = 9;
222 		
223 		gameOver = true;
224 
225 		emit OnSetNewBanker(gameID, msg.sender, _banker,  _beginTime,  _endTime, 0, now, getEventId());
226         _result = true;
227     }
228 
229 	string public team1;
230     string public team2;
231 	
232     uint public constant loseNum = 1;
233     uint public constant winNum = 3;
234     uint public constant sameNum = 0;
235 
236     uint public loseOdd;
237     uint public winOdd;
238     uint public sameOdd;
239 
240     uint public betLastTime;
241 
242     uint public playNo = 1;
243     uint public gameID = 0;
244 
245     uint public gameBeginPlayNo;
246 
247     uint public gameResult = 9;
248 
249     uint  public gameBeginTime;
250 
251     uint256 public gameMaxBetAmount;
252     uint256 public gameMinBetAmount;
253     bool public gameOver = true;
254 	
255 	uint public nextRewardPlayNo=1;
256     uint public currentRewardNum = 100;
257 	
258 	uint public donGameGiftLineTime =  now + 90 days;
259 	
260 	address public decider;
261     function setDecider(address _decider) public onlyOwner{	
262         decider = _decider;
263     }
264     modifier onlyDecider{
265         require(msg.sender == decider);
266         _;
267     }
268 	function setGameResult(uint _gameResult) public onlyDecider{
269 		require(!gameOver);
270 		require(betLastTime + 90 minutes < now);
271 		require(gameResult == 9);
272 		require( _gameResult == loseNum || _gameResult == winNum || _gameResult == sameNum);
273 		gameResult = _gameResult;
274 		if(gameResult == 3){
275 			unpayPooling = winPooling;
276 		}else if(gameResult == 1){
277 			unpayPooling = losePooling;
278 		}else if(gameResult == 0){
279 			unpayPooling = samePooling;
280 		}
281 	}
282 
283     event OnNewGame(uint indexed _gameID, address _banker , uint _betLastTime, uint _gameBeginTime, uint256 _gameMinBetAmount, uint256 _gameMaxBetAmount, uint _eventTime, uint eventId);
284 	event OnGameInfo(uint indexed _gameID, string _team1, string _team2, uint _loseOdd, uint _winOdd, uint _sameOdd, uint _eventTime, uint eventId);
285     function newGame(string _team1, string _team2, uint _loseOdd, uint _winOdd, uint _sameOdd, uint _betLastTime, uint256 _gameMinBetAmount, uint256 _gameMaxBetAmount) public onlyBanker returns(bool _result){ //开局
286         require(bytes(_team1).length < 100);
287 		require(bytes(_team2).length < 100);
288 		
289 		require(gameOver);
290         require(now > bankerBeginTime);
291 		require(_gameMinBetAmount >= 10000000);
292         require(_gameMaxBetAmount >= _gameMinBetAmount);
293 		require(now < _betLastTime);
294 		require(_betLastTime+ 1 days < bankerEndTime);
295 
296         _result = _newGame(_team1, _team2, _loseOdd, _winOdd, _sameOdd, _betLastTime, _gameMinBetAmount,  _gameMaxBetAmount);
297     }
298 
299     function _newGame(string _team1, string _team2, uint _loseOdd, uint _winOdd, uint _sameOdd, uint _betLastTime, uint256 _gameMinBetAmount, uint256 _gameMaxBetAmount) private  returns(bool _result){
300         _result = false;
301 		gameID = gameID.add(1);
302 		
303 		team1 = _team1;
304         team2 = _team2;
305 		loseOdd = _loseOdd;
306 		winOdd = _winOdd;
307 		sameOdd = _sameOdd;
308 		emit OnGameInfo(gameID, team1, team2, loseOdd, winOdd, sameOdd, now, getEventId());
309 		
310 		betLastTime = _betLastTime;
311         gameBeginTime = now;
312 		gameMinBetAmount = _gameMinBetAmount;
313         gameMaxBetAmount = _gameMaxBetAmount;
314 		emit OnNewGame(gameID, msg.sender, betLastTime,  gameBeginTime, gameMinBetAmount,   gameMaxBetAmount, now, getEventId());
315         
316         gameBeginPlayNo = playNo;
317         gameResult = 9;
318         gameOver = false;
319 		unpayPooling = 0;
320 		losePooling = 0;
321 		winPooling = 0;
322 		samePooling = 0;
323 
324         _result = true;
325     }
326 	
327     event OnSetOdd(uint indexed _gameID, uint _winOdd, uint _loseOdd, uint _sameOdd, uint _eventTime, uint eventId);
328 	function setOdd(uint _winOdd, uint _loseOdd, uint _sameOdd) onlyBanker public{		
329 		winOdd = _winOdd;
330 		loseOdd = _loseOdd;
331 		sameOdd = _sameOdd;	
332 		emit OnSetOdd(gameID, winOdd, loseOdd, sameOdd, now, getEventId());
333 	}
334 
335     struct betInfo
336     {
337         uint Odd;
338         address Player;
339         uint BetNum;
340         uint256 BetAmount;
341 		uint loseToken;
342         bool IsReturnAward;
343     }
344 
345     mapping (uint => betInfo) public playerBetInfoOf;
346 
347     event OnPlay(uint indexed _gameID, string _gameName, address _player, uint odd, string _team1, uint _betNum, uint256 _betAmount, uint _playNo, uint _eventTime, uint eventId);
348     function play(uint _betNum, uint256 _betAmount) public returns(bool _result){ 
349         _result = _play(_betNum, _betAmount);
350     }
351 
352     function _play(uint _betNum, uint256 _betAmount) private  returns(bool _result){
353         _result = false;
354         require(!gameOver);
355 
356         require(_betNum == loseNum || _betNum == winNum || _betNum == sameNum);
357         require(msg.sender != currentBanker);
358 
359         require(now < betLastTime);
360 		
361 		require(_betAmount >= gameMinBetAmount);
362         if (_betAmount > gameMaxBetAmount){
363             _betAmount = gameMaxBetAmount;
364         }
365 
366 		_betAmount = _betAmount / 100 * 100;
367 
368         if(userTokenOf[msg.sender] < _betAmount){
369             depositToken(_betAmount.sub(userTokenOf[msg.sender]));
370         }
371         
372         uint BankerAmount = _betAmount.mul(bankerDepositPer).div(100);
373         require(userTokenOf[msg.sender] >= _betAmount);
374         require(userTokenOf[currentBanker] >= BankerAmount);
375 
376 
377         uint _odd = seekOdd(_betNum,_betAmount);
378 
379         betInfo memory bi= betInfo({
380             Odd :_odd,
381             Player :  msg.sender,
382             BetNum : _betNum,
383             BetAmount : _betAmount,
384             loseToken : 0,
385             IsReturnAward: false
386         });
387 
388         playerBetInfoOf[playNo] = bi;
389         userTokenOf[msg.sender] = userTokenOf[msg.sender].sub(_betAmount);
390 		userTokenOf[this] = userTokenOf[this].add(_betAmount);
391         userTokenOf[currentBanker] = userTokenOf[currentBanker].sub(BankerAmount);
392 		userTokenOf[this] = userTokenOf[this].add(BankerAmount);
393         emit OnPlay(gameID, gameName, msg.sender, _odd, team1, _betNum, _betAmount, playNo, now, getEventId());
394 
395         playNo = playNo.add(1); 
396 		if(now < donGameGiftLineTime){
397             DonQuixoteToken.logPlaying(msg.sender);
398         }
399 		
400         _result = true;
401     }
402 	
403 	function seekOdd(uint _betNum, uint _betAmount) private returns (uint _odd){
404 		uint allAmount = 0;
405 		if(_betNum == 3){
406 			allAmount = _betAmount.mul(winOdd).div(100);//allAmount = _betAmount*winOdd/100
407 			winPooling = winPooling.add(allAmount);
408 			_odd  = winOdd;
409 		}else if(_betNum == 1){
410 			allAmount = _betAmount.mul(loseOdd).div(100);//allAmount = _betAmount*loseOdd/100
411 			losePooling = losePooling.add(allAmount);
412 			_odd = loseOdd;
413 		}else if(_betNum == 0){
414 			allAmount = _betAmount.mul(sameOdd).div(100);//allAmount = _betAmount*sameOdd/100
415 			samePooling = samePooling.add(allAmount);
416 			_odd = sameOdd;
417 		}
418     }
419 	
420     event OnOpenGameResult(uint indexed _gameID,uint indexed _palyNo, address _player, uint _gameResult, uint _eventTime, uint eventId);
421     function openGameLoop() public returns(bool _result){
422 		lock();
423         _result =  _openGameLoop();
424         unLock();
425     }
426 
427     function _openGameLoop() private returns(bool _result){
428         _result = false;
429         _checkOpenGame();
430 		uint256 allAmount = 0;
431 		for(uint i = 0; nextRewardPlayNo < playNo && i < currentRewardNum; i++ ){
432 			betInfo storage p = playerBetInfoOf[nextRewardPlayNo];
433 			if(!p.IsReturnAward){
434 				_cashPrize(p, allAmount,nextRewardPlayNo);
435 			}
436 			nextRewardPlayNo = nextRewardPlayNo.add(1);
437 		}
438 		if(unpayPooling == 0 && _canSetGameOver()){
439 			userTokenOf[currentBanker] = userTokenOf[currentBanker].add(userTokenOf[this]);
440 			userTokenOf[this] = 0;
441 			gameOver = true;
442 		}
443 		_result = true;
444     }
445 	
446 	function openGamePlayNo(uint _playNo) public returns(bool _result){
447 		lock();
448         _result =  _openGamePlayNo(_playNo);
449         unLock();
450     }
451 	
452     function _openGamePlayNo(uint _playNo) private returns(bool _result){
453         _result = false;
454 		require(_playNo >= gameBeginPlayNo && _playNo < playNo);
455 		_checkOpenGame();
456 		
457 		betInfo storage p = playerBetInfoOf[_playNo];
458 		require(!p.IsReturnAward);
459 		
460 		uint256 allAmount = 0;
461 		_cashPrize(p, allAmount,_playNo);
462 		
463 		if(unpayPooling == 0 && _canSetGameOver()){
464 			userTokenOf[currentBanker] = userTokenOf[currentBanker].add(userTokenOf[this]);
465 			userTokenOf[this] = 0;
466 			gameOver = true;
467 		}
468 		_result = true;
469     }
470 	
471 	function openGamePlayNos(uint[] _playNos) public returns(bool _result){
472 		lock();
473         _result =  _openGamePlayNos(_playNos);
474         unLock();
475     }
476 	
477     function _openGamePlayNos(uint[] _playNos) private returns(bool _result){
478         _result = false;
479         _checkOpenGame();
480 		uint256 allAmount = 0;
481 		for (uint _index = 0; _index < _playNos.length; _index++) {
482 			uint _playNo = _playNos[_index];
483 			if(_playNo >= gameBeginPlayNo && _playNo < playNo){
484 				betInfo storage p = playerBetInfoOf[_playNo];
485 				if(!p.IsReturnAward){
486 					_cashPrize(p, allAmount,_playNo);
487 				}
488 			}
489 		}
490 		
491 		if(unpayPooling == 0 && _canSetGameOver()){
492 			userTokenOf[currentBanker] = userTokenOf[currentBanker].add(userTokenOf[this]);
493 			userTokenOf[this] = 0;
494 			gameOver = true;
495 		}
496 		_result = true;
497     }
498 	
499 	function openGameRange(uint _beginPlayNo, uint _endPlayNo) public returns(bool _result){
500 		lock();
501         _result =  _openGameRange(_beginPlayNo, _endPlayNo);
502         unLock();
503     }
504 	
505     function _openGameRange(uint _beginPlayNo, uint _endPlayNo) private returns(bool _result){
506         _result = false;
507 		require(_beginPlayNo < _endPlayNo);
508 		require(_beginPlayNo >= gameBeginPlayNo && _endPlayNo < playNo);
509 		
510 		_checkOpenGame();
511 		uint256 allAmount = 0;
512 		for (uint _indexPlayNo = _beginPlayNo; _indexPlayNo <= _endPlayNo; _indexPlayNo++) {
513 			betInfo storage p = playerBetInfoOf[_indexPlayNo];
514 			if(!p.IsReturnAward){
515 				_cashPrize(p, allAmount,_indexPlayNo);
516 			}
517 		}
518 		if(unpayPooling == 0 && _canSetGameOver()){
519 			userTokenOf[currentBanker] = userTokenOf[currentBanker].add(userTokenOf[this]);
520 			userTokenOf[this] = 0;
521 			gameOver = true;
522 		}
523 		_result = true;
524     }
525 	
526 	function _checkOpenGame() private{
527 		require(!gameOver);
528 		require( gameResult == loseNum || gameResult == winNum || gameResult == sameNum);
529 		require(betLastTime + 90 minutes < now);
530 		
531 		if(unpayPooling > userTokenOf[this]){
532 			uint shortOf = unpayPooling.sub(userTokenOf[this]);
533 			if(shortOf > userTokenOf[currentBanker]){
534 				shortOf = userTokenOf[currentBanker];
535 			}
536 			userTokenOf[currentBanker] = userTokenOf[currentBanker].sub(shortOf);
537 			userTokenOf[this] = userTokenOf[this].add(shortOf);
538 		}
539 	}
540 	
541 	function _cashPrize(betInfo storage _p, uint256 _allAmount,uint _playNo) private{
542 		if(_p.BetNum == gameResult){
543 			_allAmount = _p.BetAmount.mul(_p.Odd).div(100);
544 			_allAmount = _allAmount.sub(_p.loseToken);
545 			if(userTokenOf[this] >= _allAmount){
546 				_p.IsReturnAward = true;
547 				userTokenOf[_p.Player] = userTokenOf[_p.Player].add(_allAmount);
548 				userTokenOf[this] = userTokenOf[this].sub(_allAmount);
549 				unpayPooling = unpayPooling.sub(_allAmount);
550 				emit OnOpenGameResult(gameID,_playNo, msg.sender, gameResult, now, getEventId());
551 				if(_p.BetNum == 3){
552 					winPooling = winPooling.sub(_allAmount);
553 				}else if(_p.BetNum == 1){
554 					losePooling = losePooling.sub(_allAmount);
555 				}else if(_p.BetNum == 0){
556 					samePooling = samePooling.sub(_allAmount);
557 				}
558 			}else{
559 				_p.loseToken = _p.loseToken.add(userTokenOf[this]);
560 				userTokenOf[_p.Player] = userTokenOf[_p.Player].add(userTokenOf[this]);
561 				unpayPooling = unpayPooling.sub(userTokenOf[this]);
562 				if(_p.BetNum == 3){
563 					winPooling = winPooling.sub(userTokenOf[this]);
564 				}else if(_p.BetNum == 1){
565 					losePooling = losePooling.sub(userTokenOf[this]);
566 				}else if(_p.BetNum == 0){
567 					samePooling = samePooling.sub(userTokenOf[this]);
568 				}
569 				
570 				userTokenOf[this] = 0;
571 			}
572 		}else{
573 			_p.IsReturnAward = true;
574 			emit OnOpenGameResult(gameID,_playNo, msg.sender, gameResult, now, getEventId());
575 			_allAmount = _p.BetAmount.mul(_p.Odd).div(100);
576 			//_allAmount = _allAmount.sub(_p.loseToken);
577 			if(_p.BetNum == 3){
578 				winPooling = winPooling.sub(_allAmount);
579 			}else if(_p.BetNum == 1){
580 				losePooling = losePooling.sub(_allAmount);
581 			}else if(_p.BetNum == 0){
582 				samePooling = samePooling.sub(_allAmount);
583 			}
584 			
585 			if(now < donGameGiftLineTime){
586 				DonQuixoteToken.sendGameGift(_p.Player);
587 			}
588 		}
589 	}
590 	
591 
592 	function _canSetGameOver() private view returns(bool){
593 		return winPooling<100 && losePooling<100 && samePooling<100;//todo
594 	}
595 	
596     function _withdrawToken(address _from, uint256 _amount) internal {
597         require(_from != 0x0);
598 		require(_from != currentBanker || gameOver);
599 		if(_amount > 0 && _amount <= userTokenOf[_from]){  
600 			userTokenOf[_from] = userTokenOf[_from].sub(_amount);
601 			DonQuixoteToken.transfer(_from, _amount);
602 		}
603     }
604 	
605 	
606 	function transEther() public onlyOwner()
607     {
608         msg.sender.transfer(address(this).balance);
609     }
610 	
611 	function () public payable {        //fall back function
612     }
613 
614 }