1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 
31 contract BaseGame {
32     using SafeMath for uint256;
33     string public officialGameUrl;
34     string public gameName = "GameSicBo";
35     uint public gameType = 1003;
36 
37     mapping (address => uint256) public userEtherOf;
38     function userRefund() public  returns(bool _result);
39 
40     address public currentBanker;
41     uint public bankerBeginTime;
42     uint public bankerEndTime;
43 
44     function canSetBanker() view public returns (bool _result);
45     function setBanker(address _banker, uint256 _beginTime, uint256 _endTime) public returns(bool _result);
46 }
47 
48 contract Base is  BaseGame{
49     uint public createTime = now;
50     address public owner;
51 
52     function Base() public {
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function setOwner(address _newOwner)  public  onlyOwner {
61         owner = _newOwner;
62     }
63 
64     bool public globalLocked = false;
65 
66     function lock() internal {
67         require(!globalLocked);
68         globalLocked = true;
69     }
70 
71     function unLock() internal {
72         require(globalLocked);
73         globalLocked = false;
74     }
75 
76     function setLock()  public onlyOwner{
77         globalLocked = false;
78     }
79 
80 
81     function userRefund() public  returns(bool _result) {
82         return _userRefund(msg.sender);
83     }
84 
85     function _userRefund(address _to) internal returns(bool _result) {
86         require (_to != 0x0);
87         lock();
88         uint256 amount = userEtherOf[msg.sender];
89         if(amount > 0){
90             userEtherOf[msg.sender] = 0;
91             _to.transfer(amount);
92             _result = true;
93         }
94         else{
95             _result = false;
96         }
97         unLock();
98     }
99 
100     uint public currentEventId = 1;
101 
102     function getEventId() internal returns(uint _result) {
103         _result = currentEventId;
104         currentEventId ++;
105     }
106 
107     function setOfficialGameUrl(string _newOfficialGameUrl) public onlyOwner{
108         officialGameUrl = _newOfficialGameUrl;
109     }
110 }
111 
112 contract GameSicBo is Base
113 {
114     uint public lastBlockNumber = 0;
115 
116     uint public gameID = 0;
117     uint  public gameBeginTime;
118     uint  public gameEndTime;
119     uint public gameTime;
120     uint256 public gameMaxBetAmount;
121     uint256 public gameMinBetAmount;
122     bool public gameOver = true;
123     bytes32 public gameEncryptedText;
124     uint public gameResult;
125     string public gameRandon1;
126     string public constant gameRandon2 = 'ChinasNewGovernmentBracesforTrump';
127     bool public betInfoIsLocked = false;
128 
129     uint public playNo = 1;
130     uint public gameBeginPlayNo;
131     uint public gameEndPlayNo;
132     uint public nextRewardPlayNo;
133     uint public currentRewardNum = 100;
134     
135 
136     function GameSicBo(string _gameName,uint  _gameTime, uint256 _gameMinBetAmount, uint256 _gameMaxBetAmount)  public {
137         require(_gameTime > 0);
138         require(_gameMinBetAmount > 0);
139         require(_gameMaxBetAmount > 0);
140         require(_gameMaxBetAmount >= _gameMinBetAmount);
141 
142         gameMinBetAmount = _gameMinBetAmount;
143         gameMaxBetAmount = _gameMaxBetAmount;
144         gameTime = _gameTime;
145         gameName = _gameName;
146         owner = msg.sender;
147     }
148 
149     address public auction;
150 
151     function setAuction(address _newAuction) public onlyOwner{
152         auction = _newAuction;
153     }
154 
155     modifier onlyAuction {
156         require(msg.sender == auction);
157         _;
158     }
159 
160     modifier onlyBanker {
161         require(msg.sender == currentBanker);
162         require(bankerBeginTime <= now);
163         require(now < bankerEndTime);
164         _;
165     }
166 
167     function canSetBanker() public view returns (bool _result){
168         _result =  bankerEndTime <= now && gameOver;
169     }
170 
171     event OnSetNewBanker(address _caller, address _banker, uint _beginTime, uint _endTime, uint _code,uint _eventId,uint _time);
172     function setBanker(address _banker, uint _beginTime, uint _endTime) public onlyAuction returns(bool _result)        
173     {
174         _result = false;
175         require(_banker != 0x0);
176 
177         if(now < bankerEndTime){
178             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 1 ,getEventId(),now);
179             return;
180         }
181 
182         if(!gameOver){
183             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 2 ,getEventId(),now);
184             return;
185         }
186 
187         if(_beginTime > now){
188             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 3 ,getEventId(),now);
189             return;
190         }
191 
192         if(_endTime <= now){
193             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 4 ,getEventId(),now);
194             return;
195         }
196 
197         currentBanker = _banker;
198         bankerBeginTime = _beginTime;
199         bankerEndTime = _endTime;
200 
201         emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 0, getEventId(),now);
202         _result = true;
203     }
204 
205 
206     function setCurrentRewardNum(uint _currentRewardNum) public onlyBanker{
207         currentRewardNum = _currentRewardNum ;
208     }
209 
210     event OnNewGame(uint _gameID, address _banker, bytes32 _gameEncryptedText, uint  _gameBeginTime,  uint  _gameEndTime, uint _eventId,uint _time);
211 
212     function newGame(bytes32 _gameEncryptedText) public onlyBanker payable returns(bool _result)
213     {
214         if (msg.value > 0){
215             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
216         }
217         _result = _newGame( _gameEncryptedText);
218     }
219 
220     function _newGame(bytes32 _gameEncryptedText)   private  returns(bool _result)
221     {
222         _result = false;
223         require(gameOver);
224         require(now > bankerBeginTime);
225         require(now + gameTime <= bankerEndTime);
226 
227         gameID++;
228         gameEncryptedText = _gameEncryptedText;
229         gameRandon1 = '';
230         gameBeginTime = now;
231         gameEndTime =  now + gameTime;
232         gameBeginPlayNo = playNo;
233         nextRewardPlayNo = playNo;
234         gameEndPlayNo = 0;
235         gameResult = 0;
236         gameOver = false;
237 
238         emit OnNewGame(gameID, msg.sender, _gameEncryptedText, now,gameEndTime,getEventId(),now);
239         _result = true;
240     }
241 
242     struct betInfo
243     {
244         address Player;
245         uint BetType;
246         uint256 BetAmount;
247         uint Odds;
248         uint SmallNum;
249         uint BigNum;
250         bool IsReturnAward;
251         bool IsWin ;
252         uint BetTime;
253     }
254 
255     mapping (uint => betInfo) public playerBetInfoOf;
256 
257     event OnPlay(address indexed _player,uint indexed _gameID, uint indexed _playNo, uint _eventId,uint _time, uint _smallNum,uint _bigNum, uint256 _betAmount, uint _betType);
258 
259     function playEtherOf() public payable {
260         if (msg.value > 0){
261             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
262         }
263     }
264 
265     function _play(uint _smallNum,uint _bigNum,  uint256 _betAmount, uint _odds,uint _betType) private  returns(bool _result){
266         _result = false;
267 
268         require(userEtherOf[msg.sender] >= _betAmount);
269         uint bankerAmount = _betAmount.mul(_odds);
270         require(userEtherOf[currentBanker] >= bankerAmount);
271 
272         if(gameBeginPlayNo == playNo){
273             if(now >= gameEndTime){
274                 require(gameTime.add(now) <= bankerEndTime); 
275                 gameBeginTime = now;
276                 gameEndTime = gameTime.add(now);                
277             }
278         }
279 
280         require(now < gameEndTime);
281 
282         betInfo memory bi = betInfo({
283             Player :  msg.sender,
284             SmallNum : _smallNum,
285             BigNum : _bigNum,
286             BetAmount : _betAmount,
287             BetType : _betType,
288             Odds : _odds,
289             IsReturnAward: false,
290             IsWin :  false ,
291             BetTime : now
292             });
293         playerBetInfoOf[playNo] = bi;
294         userEtherOf[msg.sender] = userEtherOf[msg.sender].sub(_betAmount);
295         userEtherOf[this] = userEtherOf[this].add(_betAmount);
296         userEtherOf[currentBanker] = userEtherOf[currentBanker].sub(bankerAmount);
297         userEtherOf[this] = userEtherOf[this].add(bankerAmount);
298 
299         emit OnPlay(msg.sender, gameID, playNo ,getEventId(), now, _smallNum,_bigNum,  _betAmount, _betType);
300 
301         lastBlockNumber = block.number;
302         playNo++;
303         _result = true;
304     }
305 
306     modifier playable(uint betAmount) {
307         require(!gameOver);
308         require(!betInfoIsLocked);
309         require(msg.sender != currentBanker);
310         require(betAmount >= gameMinBetAmount);
311         _;
312     }   
313 
314     function playBatch(uint[] _betNums,uint256[] _betAmounts) public payable returns(bool _result){
315         _result = false;
316         require(!gameOver);
317         require(!betInfoIsLocked);
318         require(msg.sender != currentBanker);
319 
320         playEtherOf();
321         require(_betNums.length == _betAmounts.length);
322         require (_betNums.length <= 10);
323         _result = true ; 
324         for(uint i = 0; i < _betNums.length && _result ; i++ ){
325             uint _betNum = _betNums[i];
326             uint256 _betAmount = _betAmounts[i];
327             if(_betAmount < gameMinBetAmount){
328                 continue ;
329             }
330             if (_betAmount > gameMaxBetAmount){
331                 _betAmount = gameMaxBetAmount;
332             }
333             if(_betNum > 0 && _betNum <= 2){
334                 _result = _play(_betNum,0, _betAmount,1,1);
335             }else if(_betNum == 3){
336                 _result = _play(0,0, _betAmount,24,2);
337             }else if(_betNum <= 9){
338                 _result = _play(_betNum.sub(3),0, _betAmount,150,3);
339             }else if(_betNum <= 15){
340                 _play(_betNum.sub(9),0, _betAmount,150,3);
341             }else if(_betNum <= 29){
342                     uint _odds = 0;
343                     _betNum = _betNum.sub(12);
344                     if(_betNum == 4 || _betNum == 17){
345                         _odds = 50;
346                     }else if(_betNum == 5 || _betNum == 16){
347                         _odds = 18;
348                     }else if(_betNum == 6 || _betNum == 15){
349                         _odds = 14;
350                     }else if(_betNum == 7 || _betNum == 14){
351                         _odds = 12;
352                     }else if(_betNum == 8 || _betNum == 13){
353                         _odds = 8;
354                     }else{
355                         _odds = 6;
356                     }
357                 _result = _play(_betNum,0, _betAmount,_odds,5);
358             }else if(_betNum <= 44){
359                 if(_betNum <= 34){
360                     uint _betMinNum = 1;
361                     uint _betMaxNum = _betNum.sub(28);
362                 }else if(_betNum <= 38){
363                     _betMinNum = 2;
364                     _betMaxNum = _betNum.sub(32);
365                 }else if(_betNum <= 41){
366                     _betMinNum = 3;
367                     _betMaxNum = _betNum.sub(35);
368                 }else if(_betNum <= 43){
369                     _betMinNum = 4;
370                     _betMaxNum = _betNum.sub(37);
371                 }else{
372                     _betMinNum = 5;
373                     _betMaxNum = 6;
374                 }
375                 _result = _play(_betMinNum,_betMaxNum, _betAmount,5,6);
376             }else if(_betNum <= 50){
377                 _result = _play(_betNum.sub(44),0, _betAmount,3,7);
378             }
379         }
380         _result = true;
381     }
382 
383     function playBigOrSmall(uint _betNum, uint256 _betAmount) public payable playable(_betAmount) returns(bool _result){
384         playEtherOf();
385         require(_betNum ==1 || _betNum == 2);
386         if (_betAmount > gameMaxBetAmount){
387             _betAmount = gameMaxBetAmount;
388         }
389         _result = _play(_betNum,0, _betAmount,1,1);
390     }
391 
392     function playAnyTriples(uint256 _betAmount) public payable  playable(_betAmount)  returns(bool _result){
393         playEtherOf();
394         if (_betAmount > gameMaxBetAmount){
395             _betAmount = gameMaxBetAmount;
396         }
397         _result = _play(0,0, _betAmount,24,2);
398     }
399 
400     function playSpecificTriples(uint _betNum, uint256 _betAmount) public payable playable(_betAmount)  returns(bool _result){
401         playEtherOf();
402         require(_betNum >= 1 && _betNum <=6);
403         if (_betAmount > gameMaxBetAmount){
404             _betAmount = gameMaxBetAmount;
405         }
406         _result = _play(_betNum,0, _betAmount,150,3);
407     }
408 
409     function playSpecificDoubles(uint _betNum, uint256 _betAmount) public payable playable(_betAmount)  returns(bool _result){
410         playEtherOf();
411         require(_betNum >= 1 && _betNum <=6);
412         if (_betAmount > gameMaxBetAmount){
413             _betAmount = gameMaxBetAmount;
414         }
415         _result = _play(_betNum,0, _betAmount,8,4);
416     }
417 
418     function playThreeDiceTotal(uint _betNum,uint256 _betAmount) public payable  playable(_betAmount)  returns(bool _result){
419         playEtherOf();
420         require(_betNum >= 4 && _betNum <=17);
421         if (_betAmount > gameMaxBetAmount){
422             _betAmount = gameMaxBetAmount;
423         }
424         uint _odds = 0;
425         if(_betNum == 4 || _betNum == 17){
426             _odds = 50;
427         }else if(_betNum == 5 || _betNum == 16){
428             _odds = 18;
429         }else if(_betNum == 6 || _betNum == 15){
430             _odds = 14;
431         }else if(_betNum == 7 || _betNum == 14){
432             _odds = 12;
433         }else if(_betNum == 8 || _betNum == 13){
434             _odds = 8;
435         }else{
436             _odds = 6;
437         }
438         _result = _play(_betNum,0, _betAmount,_odds,5);
439     }
440 
441     function playDiceCombinations(uint _smallNum,uint _bigNum,uint256 _betAmount) public payable playable(_betAmount)  returns(bool _result){
442         playEtherOf();
443         require(_smallNum < _bigNum);
444         require(_smallNum >= 1 && _smallNum <=5);
445         require(_bigNum >= 2 && _bigNum <=6);
446         if (_betAmount > gameMaxBetAmount){
447             _betAmount = gameMaxBetAmount;
448         }
449         _result = _play(_smallNum,_bigNum, _betAmount,5,6);
450     }
451 
452     function playSingleDiceBet(uint _betNum,uint256 _betAmount) public payable playable(_betAmount)  returns(bool _result){
453         playEtherOf();
454         require(_betNum >= 1 && _betNum <=6);
455         if (_betAmount > gameMaxBetAmount){
456             _betAmount = gameMaxBetAmount;
457         }
458         _result = _play(_betNum,0, _betAmount,3,7);
459     }
460 
461     function lockBetInfo() public onlyBanker returns (bool _result) {
462         require(!gameOver);
463         require(now < gameEndTime);
464         require(!betInfoIsLocked);
465         betInfoIsLocked = true;
466         _result = true;
467     }
468 
469     function uintToString(uint v) private pure returns (string) {
470         uint maxlength = 3;
471         bytes memory reversed = new bytes(maxlength);
472         uint i = 0;
473         while (v != 0) {
474             uint remainder = v % 10;
475             v = v / 10;
476             reversed[i++] = byte(48 + remainder);
477         }
478         bytes memory s = new bytes(i);
479         for (uint j = 0; j < i; j++) {
480             s[j] = reversed[i - j - 1];
481         }
482         string memory str = string(s);
483         return str;
484     }
485 
486 
487     event OnOpenGameResult(uint indexed _gameID, bool indexed _result, string _remark, address _banker,uint _gameResult, string _r1,uint _eventId,uint _time);
488 
489     function openGameResult(uint _minGameResult,uint _midGameResult,uint _maxGameResult, string _r1) public onlyBanker  returns(bool _result){
490         _result =  _openGameResult( _minGameResult,_midGameResult,_maxGameResult,_r1);
491     }
492 
493     function _playRealOdds(uint _betType,uint _odds,uint _smallNuml,uint _bigNum,uint _minGameResult,uint _midGameResult,uint _maxGameResult) private  pure returns(uint _realOdds){
494         _realOdds = 0;
495         if(_betType == 1){
496             bool _isAnyTriple = (_minGameResult == _midGameResult && _midGameResult == _maxGameResult);
497             if(_isAnyTriple){
498                 return 0;
499             }
500             uint _threeDiceTotal = _minGameResult.add(_midGameResult).add(_maxGameResult);
501             uint _bigOrSmall = _threeDiceTotal >= 11 ? 2 : 1 ;
502             if(_bigOrSmall == _smallNuml){
503                 _realOdds = _odds;
504             }
505         }else if(_betType == 2){
506             _isAnyTriple = (_minGameResult == _midGameResult && _midGameResult == _maxGameResult);
507             if(_isAnyTriple){
508                 _realOdds = _odds;
509             }
510         }else if(_betType == 3){
511             _isAnyTriple = (_minGameResult == _midGameResult && _midGameResult == _maxGameResult);
512             uint _specificTriple  = (_isAnyTriple) ? _minGameResult : 0 ;
513             if( _specificTriple == _smallNuml){
514                 _realOdds = _odds;
515             }
516         }else if(_betType == 4){
517             uint _doubleTriple = (_minGameResult == _midGameResult) ? _minGameResult : ((_midGameResult == _maxGameResult)? _maxGameResult: 0);
518             if(_doubleTriple == _smallNuml){
519                 _realOdds = _odds;
520             }
521         }else if(_betType == 5){
522             _threeDiceTotal = _minGameResult + _midGameResult + _maxGameResult ;
523             if(_threeDiceTotal == _smallNuml){
524                 _realOdds = _odds;
525             }
526         }else  if(_betType == 6){
527             if(_smallNuml == _minGameResult || _smallNuml == _midGameResult){
528                 if(_bigNum == _midGameResult || _bigNum == _maxGameResult){
529                     _realOdds = _odds;
530                 }
531             }
532         }else if(_betType == 7){
533             if(_smallNuml == _minGameResult){
534                 _realOdds++;
535             }
536             if(_smallNuml == _midGameResult){
537                 _realOdds++;
538             }
539             if(_smallNuml == _maxGameResult){
540                 _realOdds++;
541             }
542 
543         }
544     }
545 
546 
547     function _openGameResult(uint _minGameResult,uint _midGameResult, uint _maxGameResult, string _r1) private  returns(bool _result){
548         _result = false;
549         require(betInfoIsLocked);
550         require(!gameOver);
551         require(now <= gameEndTime);
552         require(_minGameResult <= _midGameResult);
553         require(_midGameResult <= _maxGameResult);
554         require (_minGameResult >= 1 && _maxGameResult <= 6);
555 
556         uint _gameResult = _minGameResult*100 + _midGameResult*10 + _maxGameResult;
557         if(lastBlockNumber == block.number){
558             emit OnOpenGameResult(gameID,  false, 'block.number is equal', msg.sender, _gameResult, _r1,getEventId(),now);
559             return;
560         }
561         if(keccak256(uintToString(_gameResult) , gameRandon2 , _r1) ==  gameEncryptedText){
562             if(_minGameResult >= 1 && _minGameResult <= 6 && _midGameResult>=1 && _midGameResult<=6 && _maxGameResult>=1 && _maxGameResult<=6){
563                 gameResult = _gameResult ;
564                 gameRandon1 = _r1;
565                 gameEndPlayNo = playNo - 1;
566 
567                 for(uint i = 0; nextRewardPlayNo < playNo && i < currentRewardNum; i++ ){
568                     betInfo  storage p = playerBetInfoOf[nextRewardPlayNo];
569                     if(!p.IsReturnAward){
570                         p.IsReturnAward = true;
571                         uint realOdd = _playRealOdds(p.BetType,p.Odds,p.SmallNum,p.BigNum,_minGameResult,_midGameResult,_maxGameResult);
572                         p.IsWin =_calResultReturnIsWin(nextRewardPlayNo,realOdd);
573                         if(p.IsWin){
574                             p.Odds = realOdd;
575                         }
576                     }
577                     nextRewardPlayNo++;
578                 }
579                 if(nextRewardPlayNo == playNo){
580                     gameOver = true;
581                     betInfoIsLocked = false;
582                 }
583 
584                 emit OnOpenGameResult(gameID, true, 'Success', msg.sender,  _gameResult,  _r1,getEventId(),now);
585                 _result = true;
586                 return;
587             }else{
588                 emit OnOpenGameResult(gameID,  false, 'The result is illegal', msg.sender, _gameResult, _r1,getEventId(),now);
589                 return;
590             }
591         }else{
592             emit OnOpenGameResult(gameID,  false, 'Hash Value Not Match', msg.sender,  _gameResult,  _r1,getEventId(),now);
593             return;
594         }
595 
596     }
597 
598     function _calResultReturnIsWin(uint  _playerBetInfoOfIndex,uint _realOdd) private returns(bool _isWin){
599         betInfo memory  p = playerBetInfoOf[_playerBetInfoOfIndex];
600         uint256 AllAmount = p.BetAmount.mul(1 + p.Odds);
601         if(_realOdd > 0){
602             if(_realOdd == p.Odds){
603                 userEtherOf[p.Player] = userEtherOf[p.Player].add(AllAmount);
604                 userEtherOf[this] = userEtherOf[this].sub(AllAmount);
605             }else{
606                 uint256 winAmount = p.BetAmount.mul(1 + _realOdd);
607                 userEtherOf[p.Player] =  userEtherOf[p.Player].add(winAmount);
608                 userEtherOf[this] = userEtherOf[this].sub(winAmount);
609                 userEtherOf[currentBanker] = userEtherOf[currentBanker].add(AllAmount.sub(winAmount));
610                 userEtherOf[this] = userEtherOf[this].sub(AllAmount.sub(winAmount));
611             }
612             return true ;
613         }else{
614             userEtherOf[currentBanker] = userEtherOf[currentBanker].add(AllAmount) ;
615             userEtherOf[this] = userEtherOf[this].sub(AllAmount);
616             return false ;
617         }
618     }
619 
620     function openGameResultAndNewGame(uint _minGameResult,uint _midGameResult,uint _maxGameResult, string _r1, bytes32 _gameEncryptedText) public onlyBanker payable returns(bool _result)
621     {
622         if(msg.value > 0){
623             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
624         }
625         if(!gameOver){
626             _result =  _openGameResult( _minGameResult,_midGameResult,_maxGameResult,  _r1);
627         }
628         if (gameOver){
629             _result = _newGame( _gameEncryptedText);
630         }
631     }
632 
633     function noOpenGameResult() public  returns(bool _result){
634         _result = false;
635         require(!gameOver);
636         require(gameEndTime < now);
637         if(lastBlockNumber == block.number){
638             emit OnOpenGameResult(gameID,false, 'block.number', msg.sender,0,'',getEventId(),now);
639             return;
640         }
641 
642         for(uint i = 0; nextRewardPlayNo < playNo && i < currentRewardNum; i++){
643             betInfo  storage p = playerBetInfoOf[nextRewardPlayNo];
644             if(!p.IsReturnAward){
645                 p.IsReturnAward = true;
646                 p.IsWin = true ;
647                 uint AllAmount = p.BetAmount.mul(1 + p.Odds);
648                 userEtherOf[p.Player] =userEtherOf[p.Player].add(AllAmount);
649                 userEtherOf[this] =userEtherOf[this].sub(AllAmount);
650             }
651             nextRewardPlayNo++;
652         }
653         if(nextRewardPlayNo == playNo){
654             gameOver = true;
655             if(betInfoIsLocked){
656                 betInfoIsLocked = false;
657             }
658         }
659 
660         emit OnOpenGameResult(gameID,  true, 'Banker Not Call', msg.sender,   0, '',getEventId(),now);
661         _result = true;
662     }
663 
664 
665     function  failUserRefund(uint _playNo) public returns (bool _result) {
666         _result = true;
667         require(!gameOver);
668         require(gameEndTime + 30 days < now);
669 
670         betInfo storage p = playerBetInfoOf[_playNo];
671         require(p.Player == msg.sender);
672 
673         if(!p.IsReturnAward && p.SmallNum > 0){
674             p.IsReturnAward = true;
675             uint256 ToUser = p.BetAmount;
676             uint256 ToBanker = p.BetAmount.mul(p.Odds);
677             userEtherOf[p.Player] =  userEtherOf[p.Player].add(ToUser);
678             userEtherOf[this] =  userEtherOf[this].sub(ToUser);
679             userEtherOf[currentBanker] =  userEtherOf[p.Player].add(ToBanker);
680             userEtherOf[this] =  userEtherOf[this].sub(ToBanker);
681             p.Odds = 0;
682             _result = true;
683         }
684     }
685 
686     function () public payable {
687         if(msg.value > 0){
688             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
689         }
690     }
691 
692 }