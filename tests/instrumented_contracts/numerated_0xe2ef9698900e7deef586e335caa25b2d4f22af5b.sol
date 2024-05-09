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
13     uint256 c = a / b;
14     return c;
15   }
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 
28 contract BaseGame {
29 	function canSetBanker() view public returns (bool _result);
30     function setBanker(address _banker, uint256 _beginTime, uint256 _endTime) public returns(bool _result);
31     
32     string public gameName = "NO.1";
33     uint public gameType = 1004;
34     string public officialGameUrl;
35 
36     function userRefund() public  returns(bool _result);
37 	
38 	uint public bankerBeginTime;
39 	uint public bankerEndTime;
40 	address public currentBanker;
41 	
42 	mapping (address => uint256) public userEtherOf;
43 }
44 
45 
46 contract Base is BaseGame{
47 	using SafeMath for uint256;
48     uint public createTime = now;
49     address public owner;
50 	function Base() public {
51     }
52 
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58 
59     function setOwner(address _newOwner)  public  onlyOwner {
60         owner = _newOwner;
61     }
62 
63     bool public globalLocked = false;
64 
65     function lock() internal {
66         require(!globalLocked);
67         globalLocked = true;
68     }
69 
70     function unLock() internal {
71         require(globalLocked);
72         globalLocked = false;
73     }
74 
75     function setLock()  public onlyOwner{
76         globalLocked = false;
77     }
78 
79     function userRefund() public  returns(bool _result) {
80         return _userRefund(msg.sender);
81     }
82 
83     function _userRefund(address _to) internal returns(bool _result) {
84         require (_to != 0x0);
85         lock();
86         uint256 amount = userEtherOf[msg.sender];
87         if(amount > 0){
88             userEtherOf[msg.sender] = 0;
89             _to.transfer(amount);
90             _result = true;
91         }
92         else{
93             _result = false;
94         }
95         unLock();
96     }
97 	
98 	uint public currentEventId = 1;
99 
100     function getEventId() internal returns(uint _result) {
101         _result = currentEventId;
102         currentEventId++;
103     }
104 	
105 	string public officialGameUrl;
106     function setOfficialGameUrl(string _newOfficialGameUrl) public onlyOwner{
107         officialGameUrl = _newOfficialGameUrl;
108     }
109 }
110 
111 contract SoccerBet is Base
112 {
113 	function SoccerBet(string _gameName) public {
114 		gameName = _gameName;
115         owner = msg.sender;
116     }
117 	
118 	uint public unpayPooling = 0;
119 	uint public losePooling = 0;
120 	uint public winPooling = 0;
121 	uint public samePooling = 0;
122 	uint public bankerAllDeposit = 0;
123 	
124 	address public auction;
125 	function setAuction(address _newAuction) public onlyOwner{
126         auction = _newAuction;
127     }
128     modifier onlyAuction {
129 	    require(msg.sender == auction);
130         _;
131     }
132 	
133     modifier onlyBanker {
134         require(msg.sender == currentBanker);
135         require(bankerBeginTime <= now);
136         require(now < bankerEndTime);
137         _;
138     }    
139 	
140 	function canSetBanker() public view returns (bool _result){
141         _result =  false;
142 		if(now < bankerEndTime){
143 			return;
144 		}
145 		if(userEtherOf[this] == 0){
146 			_result = true;
147 		}
148     }
149 	
150 	event OnSetNewBanker(uint indexed _gameID, address _caller, address _banker, uint _beginTime, uint _endTime, uint _errInfo, uint _eventTime, uint eventId);
151 
152     function setBanker(address _banker, uint _beginTime, uint _endTime) public onlyAuction returns(bool _result)
153     {
154         _result = false;
155         require(_banker != 0x0);
156 
157         if(now < bankerEndTime){
158             emit OnSetNewBanker(gameID, msg.sender, _banker,  _beginTime,  _endTime, 1, now, getEventId());
159             return;
160         }
161 		
162 		if(userEtherOf[this] > 0){
163 			emit OnSetNewBanker(gameID, msg.sender, _banker,  _beginTime,  _endTime, 5, now, getEventId());
164 			return;
165 		}
166         
167         if(_beginTime > now){
168 			emit OnSetNewBanker(gameID, msg.sender, _banker,  _beginTime,  _endTime, 3, now, getEventId());
169             return;
170         }
171 
172         if(_endTime <= now){
173 			emit OnSetNewBanker(gameID, msg.sender, _banker,  _beginTime,  _endTime, 4, now, getEventId());
174             return;
175         }
176 
177         currentBanker = _banker;
178         bankerBeginTime = _beginTime;
179         bankerEndTime =  _endTime;
180 		
181 		unpayPooling = 0;
182 		losePooling = 0;
183 		winPooling = 0;
184 		samePooling = 0;
185 		
186 		bankerAllDeposit = 0;
187 		
188 		gameResult = 9;
189 		
190 		gameOver = true;
191 
192 		emit OnSetNewBanker(gameID, msg.sender, _banker,  _beginTime,  _endTime, 0, now, getEventId());
193         _result = true;
194     }
195 	
196 	string public team1;
197     string public team2;
198 	
199 	uint public constant loseNum = 1;
200     uint public constant winNum = 3;
201     uint public constant sameNum = 0;
202 
203     uint public loseOdd;
204     uint public winOdd;
205     uint public sameOdd;
206 	
207 	uint public betLastTime;
208 	
209 	uint public playNo = 1;
210     uint public gameID = 0;
211 	
212 	uint public gameBeginPlayNo;
213 	
214 	uint public gameResult = 9;
215 	
216 	uint  public gameBeginTime;
217 
218     uint256 public gameMaxBetAmount;
219     uint256 public gameMinBetAmount;
220     bool public gameOver = true;
221 	
222 	uint public nextRewardPlayNo=1;
223     uint public currentRewardNum = 100;
224 
225 	address public decider;
226 	function setDecider(address _decider) public onlyOwner{	
227         decider = _decider;
228     }
229     modifier onlyDecider{
230         require(msg.sender == decider);
231         _;
232     }
233 	function setGameResult(uint _gameResult) public onlyDecider{
234 		require(!gameOver);
235 		require(betLastTime + 90 minutes < now);
236 		require(now < betLastTime + 30 days);
237 		require(gameResult == 9);
238 		require( _gameResult == loseNum || _gameResult == winNum || _gameResult == sameNum);
239 		gameResult = _gameResult;
240 		if(gameResult == 3){
241 			unpayPooling = winPooling;
242 		}else if(gameResult == 1){
243 			unpayPooling = losePooling;
244 		}else if(gameResult == 0){
245 			unpayPooling = samePooling;
246 		}
247 	}
248 
249     event OnNewGame(uint indexed _gameID, address _banker , uint _betLastTime, uint _gameBeginTime, uint256 _gameMinBetAmount, uint256 _gameMaxBetAmount, uint _eventTime, uint eventId);
250 	event OnGameInfo(uint indexed _gameID, string _team1, string _team2, uint _loseOdd, uint _winOdd, uint _sameOdd, uint _eventTime, uint eventId);
251 	
252     function newGame(string _team1, string _team2, uint _loseOdd, uint _winOdd, uint _sameOdd,  uint _betLastTime, uint256 _gameMinBetAmount, uint256 _gameMaxBetAmount) public onlyBanker payable returns(bool _result){
253         if (msg.value > 0){
254             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
255         }
256 
257         require(bytes(_team1).length < 100);
258 		require(bytes(_team2).length < 100);
259 		
260 		require(gameOver);
261         require(now > bankerBeginTime);
262         require(_gameMinBetAmount >= 100000000000000);
263         require(_gameMaxBetAmount >= _gameMinBetAmount);
264 		require(now < _betLastTime);
265 		require(_betLastTime+ 1 days < bankerEndTime);
266 			
267 		
268         _result = _newGame(_team1, _team2, _loseOdd, _winOdd, _sameOdd, _betLastTime, _gameMinBetAmount,  _gameMaxBetAmount);
269     }
270 
271     function _newGame(string _team1, string _team2, uint _loseOdd, uint _winOdd, uint _sameOdd, uint _betLastTime, uint256 _gameMinBetAmount, uint256 _gameMaxBetAmount) private  returns(bool _result){
272         _result = false;
273 		gameID = gameID.add(1);
274 		
275 		team1 = _team1;
276         team2 = _team2;
277 		loseOdd = _loseOdd;
278 		winOdd = _winOdd;
279 		sameOdd = _sameOdd;
280 		emit OnGameInfo(gameID, team1, team2, loseOdd, winOdd, sameOdd, now, getEventId());
281 		
282 		betLastTime = _betLastTime;
283         gameBeginTime = now;
284 		gameMinBetAmount = _gameMinBetAmount;
285         gameMaxBetAmount = _gameMaxBetAmount;
286 		emit OnNewGame(gameID, msg.sender, betLastTime,  gameBeginTime, gameMinBetAmount,   gameMaxBetAmount, now, getEventId());
287 		
288         gameBeginPlayNo = playNo;
289         gameResult = 9;
290         gameOver = false;
291 		unpayPooling = 0;
292 		losePooling = 0;
293 		winPooling = 0;
294 		samePooling = 0;
295 		
296 		bankerAllDeposit = 0;
297 		
298         _result = true;
299     }
300 	
301     event OnSetOdd(uint indexed _gameID, uint _winOdd, uint _loseOdd, uint _sameOdd, uint _eventTime, uint eventId);
302 	function setOdd(uint _winOdd, uint _loseOdd, uint _sameOdd) onlyBanker public{		
303 		winOdd = _winOdd;
304 		loseOdd = _loseOdd;
305 		sameOdd = _sameOdd;	
306 		emit OnSetOdd(gameID, winOdd, loseOdd, sameOdd, now, getEventId());
307 	}
308 
309     struct betInfo
310     {
311         uint Odd;
312         address Player;
313         uint BetNum;
314         uint256 BetAmount;
315 		uint BetTime;
316         bool IsReturnAward;
317 		uint ResultNO;
318     }
319 
320     mapping (uint => betInfo) public playerBetInfoOf;
321 
322     event OnPlay( uint indexed _gameID, uint indexed _playNo, address indexed _player, string _gameName, uint odd, string _team1, uint _betNum, uint256 _betAmount,  uint _eventTime, uint eventId);
323     function play(uint _betNum, uint256 _betAmount) public payable  returns(bool _result){
324         if (msg.value > 0){
325             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
326         }
327 		_result = _play(_betNum, _betAmount);
328     }
329 
330     function _play(uint _betNum, uint256 _betAmount) private  returns(bool _result){
331         _result = false;
332         require(!gameOver);
333       
334         require( loseNum == _betNum || _betNum == winNum || _betNum == sameNum);
335         require(msg.sender != currentBanker);
336 
337         require(now < betLastTime);
338 		
339 		require(_betAmount >= gameMinBetAmount);
340         if (_betAmount > gameMaxBetAmount){
341             _betAmount = gameMaxBetAmount;
342         }
343 		
344 		_betAmount = _betAmount / 100 * 100;
345 		
346 		uint _odd = _seekOdd(_betNum, _betAmount);
347 		
348         require(userEtherOf[msg.sender] >= _betAmount);
349 
350         betInfo memory bi= betInfo({
351             Odd :_odd,
352             Player :  msg.sender,
353             BetNum : _betNum,
354             BetAmount : _betAmount,
355 			BetTime : now,
356             IsReturnAward: false,
357 			ResultNO: 9
358         });
359 
360          playerBetInfoOf[playNo] = bi;
361         userEtherOf[msg.sender] = userEtherOf[msg.sender].sub(_betAmount); 
362 		userEtherOf[this] = userEtherOf[this].add(_betAmount);
363 		
364 		uint _maxpooling = _getMaxPooling();
365 		if(userEtherOf[this] < _maxpooling){
366 			uint BankerAmount = _maxpooling.sub(userEtherOf[this]);
367 			require(userEtherOf[currentBanker] >= BankerAmount);
368 			userEtherOf[currentBanker] = userEtherOf[currentBanker].sub(BankerAmount);
369 			userEtherOf[this] = userEtherOf[this].add(BankerAmount);
370 			bankerAllDeposit = bankerAllDeposit.add(BankerAmount);
371 		}
372 		
373         emit OnPlay(gameID, playNo, msg.sender, gameName, _odd, team1, _betNum, _betAmount, now, getEventId());
374 
375         playNo = playNo.add(1);
376         _result = true;
377     }
378 	
379 	function _seekOdd(uint _betNum, uint _betAmount) private returns (uint _odd){
380 		uint allAmount = 0;
381 		if(_betNum == 3){
382 			allAmount = _betAmount.mul(winOdd).div(100);
383 			winPooling = winPooling.add(allAmount);
384 			_odd  = winOdd;
385 		}else if(_betNum == 1){
386 			allAmount = _betAmount.mul(loseOdd).div(100);
387 			losePooling = losePooling.add(allAmount);
388 			_odd = loseOdd;
389 		}else if(_betNum == 0){
390 			allAmount = _betAmount.mul(sameOdd).div(100);
391 			samePooling = samePooling.add(allAmount);
392 			_odd = sameOdd;
393 		}
394     }
395 	
396 	function _getMaxPooling() private view returns(uint maxpooling){
397 		maxpooling = winPooling;
398 		if(maxpooling < losePooling){
399 			maxpooling = losePooling;
400 		}
401 		if(maxpooling < samePooling){
402 			maxpooling = samePooling;
403 		}
404 	}
405 
406 	event OnOpenGameResult(uint indexed _gameID,uint indexed _palyNo, address _player, uint _gameResult, uint _eventTime, uint eventId);
407     function openGameLoop() public returns(bool _result){
408 		lock();
409         _result =  _openGameLoop();
410         unLock();
411     }
412 
413     function _openGameLoop() private returns(bool _result){
414         _result = false;
415         _checkOpenGame();
416 		uint256 allAmount = 0;
417 		for(uint i = 0; nextRewardPlayNo < playNo && i < currentRewardNum; i++ ){
418 			betInfo storage p = playerBetInfoOf[nextRewardPlayNo];
419 			if(!p.IsReturnAward){
420 				_cashPrize(p, allAmount,nextRewardPlayNo);
421 			}
422 			nextRewardPlayNo = nextRewardPlayNo.add(1);
423 		}
424 		
425 		_setGameOver();
426 		
427 		_result = true;
428     }
429 	
430 	function openGamePlayNo(uint _playNo) public returns(bool _result){
431 		lock();
432         _result =  _openGamePlayNo(_playNo);
433         unLock();
434     }
435 
436     function _openGamePlayNo(uint _playNo) private returns(bool _result){
437         _result = false;
438 		require(_playNo >= gameBeginPlayNo && _playNo < playNo);
439 		_checkOpenGame();
440 		
441 		betInfo storage p = playerBetInfoOf[_playNo];
442 		require(!p.IsReturnAward);
443 		
444 		uint256 allAmount = 0;
445 		_cashPrize(p, allAmount,_playNo);
446 		
447 		_setGameOver();
448 		
449 		_result = true;
450     }
451 	
452 	function openGamePlayNos(uint[] _playNos) public returns(bool _result){
453 		lock();
454         _result =  _openGamePlayNos(_playNos);
455         unLock();
456     }
457 	
458     function _openGamePlayNos(uint[] _playNos) private returns(bool _result){
459         _result = false;
460         _checkOpenGame();
461 		
462 		uint256 allAmount = 0;
463 		for (uint _index = 0; _index < _playNos.length; _index++) {
464 			uint _playNo = _playNos[_index];
465 			if(_playNo >= gameBeginPlayNo && _playNo < playNo){
466 				betInfo storage p = playerBetInfoOf[_playNo];
467 				if(!p.IsReturnAward){
468 					_cashPrize(p, allAmount,_playNo);
469 				}
470 			}
471 		}
472 		
473 		_setGameOver();
474 		
475 		_result = true;
476     }
477 	
478 	
479 	function openGameRange(uint _beginPlayNo, uint _endPlayNo) public returns(bool _result){
480 		lock();
481         _result =  _openGameRange(_beginPlayNo, _endPlayNo);
482         unLock();
483     }
484 	
485     function _openGameRange(uint _beginPlayNo, uint _endPlayNo) private returns(bool _result){
486         _result = false;
487 		require(_beginPlayNo < _endPlayNo);
488 		require(_beginPlayNo >= gameBeginPlayNo && _endPlayNo < playNo);
489 		
490 		_checkOpenGame();
491 		
492 		uint256 allAmount = 0;
493 		for (uint _indexPlayNo = _beginPlayNo; _indexPlayNo <= _endPlayNo; _indexPlayNo++) {
494 			betInfo storage p = playerBetInfoOf[_indexPlayNo];
495 			if(!p.IsReturnAward){
496 				_cashPrize(p, allAmount,_indexPlayNo);
497 			}
498 		}
499 		_setGameOver();
500 		_result = true;
501     }
502 	
503 	function _checkOpenGame() private view{
504 		require(!gameOver);
505 		require( gameResult == loseNum || gameResult == winNum || gameResult == sameNum);
506 		require(betLastTime + 90 minutes < now);
507 	}
508 	
509 	function _cashPrize(betInfo storage _p, uint256 _allAmount,uint _playNo) private{
510 		if(_p.BetNum == gameResult){
511 			_allAmount = _p.BetAmount.mul(_p.Odd).div(100);
512 			
513 			_p.IsReturnAward = true;
514 			_p.ResultNO = gameResult;
515 			userEtherOf[this] = userEtherOf[this].sub(_allAmount);
516 			unpayPooling = unpayPooling.sub(_allAmount);
517 			userEtherOf[_p.Player] = userEtherOf[_p.Player].add(_allAmount);
518 			emit OnOpenGameResult(gameID,_playNo, msg.sender, gameResult, now, getEventId());
519 			
520 			if(_p.BetNum == 3){
521 				winPooling = winPooling.sub(_allAmount);
522 			}else if(_p.BetNum == 1){
523 				losePooling = losePooling.sub(_allAmount);
524 			}else if(_p.BetNum == 0){
525 				samePooling = samePooling.sub(_allAmount);
526 			}
527 			
528 		}else{
529 			_p.IsReturnAward = true;
530 			_p.ResultNO = gameResult;
531 			emit OnOpenGameResult(gameID,_playNo, msg.sender, gameResult, now, getEventId());
532 			
533 			_allAmount = _p.BetAmount.mul(_p.Odd).div(100);
534 			if(_p.BetNum == 3){
535 				winPooling = winPooling.sub(_allAmount);
536 			}else if(_p.BetNum == 1){
537 				losePooling = losePooling.sub(_allAmount);
538 			}else if(_p.BetNum == 0){
539 				samePooling = samePooling.sub(_allAmount);
540 			}
541 		}
542 	}
543 	
544 	function _setGameOver() private{
545 		if(unpayPooling == 0 && _canSetGameOver()){
546 			userEtherOf[currentBanker] = userEtherOf[currentBanker].add(userEtherOf[this]);
547 			userEtherOf[this] = 0;
548 			gameOver = true;
549 		}
550 	}
551 	
552 	function _canSetGameOver() private view returns(bool){
553 		return winPooling<100 && losePooling<100 && samePooling<100;
554 	}
555 	
556 	function failUserRefund(uint[] _playNos) public returns (bool _result) {
557         _result = false;
558         require(!gameOver);
559 		require(gameResult == 9);
560         require(betLastTime + 31 days < now);
561 		for (uint _index = 0; _index < _playNos.length; _index++) {
562 			uint _playNo = _playNos[_index];
563 			if(_playNo >= gameBeginPlayNo && _playNo < playNo){
564 				betInfo storage p = playerBetInfoOf[_playNo];
565 				if(!p.IsReturnAward){
566 					p.IsReturnAward = true;
567 					uint256 ToUser = p.BetAmount;
568 					userEtherOf[this] = userEtherOf[this].sub(ToUser);
569 					userEtherOf[p.Player] =  userEtherOf[p.Player].add(ToUser);
570 				}
571 			}
572 		}
573 		if(msg.sender == currentBanker && bankerAllDeposit>0){
574 			userEtherOf[this] = userEtherOf[this].sub(bankerAllDeposit);
575 			userEtherOf[currentBanker] =  userEtherOf[currentBanker].add(bankerAllDeposit);
576 			bankerAllDeposit = 0;
577 		}
578 		if(userEtherOf[this] == 0){
579 			gameOver = true;
580 		}
581 		_result = true;
582     }
583 
584 	
585 	event OnRefund(uint indexed _gameId, address _to, uint _amount, bool _result, uint _eventTime, uint eventId);
586 	function _userRefund(address _to) internal  returns(bool _result){
587 		require (_to != 0x0);
588 		require(_to != currentBanker || gameOver);
589 		lock();
590 		uint256 amount = userEtherOf[_to];
591 		if(amount > 0){
592 			userEtherOf[msg.sender] = 0;
593 			_to.transfer(amount);
594 			_result = true;
595 		}else{
596 			_result = false;
597 		}
598 		
599 		emit OnRefund(gameID, _to, amount, _result, now, getEventId());
600 		unLock();                                                                            
601     }
602 	
603 	function playEtherOf() public payable {
604         if (msg.value > 0){
605             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);                  
606         }
607     }
608 	
609 	function () public payable {
610         if(msg.value > 0){
611             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
612 			
613         }
614     }
615 
616 }