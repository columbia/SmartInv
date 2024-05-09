1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 
30 contract BaseGame {
31     using SafeMath for uint256;
32 
33     string public officialGameUrl;
34     string public gameName = "GameSicBo";
35     uint public gameType = 2003;
36 
37     function depositToken(uint256 _amount) public;
38     function withdrawAllToken() public;
39     function withdrawToken(uint256 _amount) public;
40     mapping (address => uint256) public userTokenOf;
41 
42 
43     address public currentBanker;
44     uint public bankerBeginTime;
45     uint public bankerEndTime;
46 
47 
48     function canSetBanker() view public returns (bool _result);
49 
50     function setBanker(address _banker, uint256 _beginTime, uint256 _endTime) public returns(bool _result);
51 }
52 
53 interface IDonQuixoteToken{
54     function withhold(address _player,  uint256 _betAmount) external returns (bool _result);
55     function transfer(address _to, uint256 _value) external;
56 
57     function sendGameGift(address _player) external returns (bool _result);
58     function balanceOf(address _user) constant  external returns (uint256 _balance);
59     function logPlaying(address _player) external returns (bool _result);
60 }
61 
62 contract Base is  BaseGame{
63     uint public createTime = now;
64     address public owner;
65 
66     IDonQuixoteToken public DonQuixoteToken;
67 
68     function Base() public {
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     function setOwner(address _newOwner)  public  onlyOwner {
77         require(_newOwner != 0x0);
78         owner = _newOwner;
79     }
80 
81     bool public globalLocked = false;
82 
83     function lock() internal {
84         require(!globalLocked);
85         globalLocked = true;
86     }
87 
88     function unLock() internal {
89         require(globalLocked);
90         globalLocked = false;
91     }
92 
93     function setLock()  public onlyOwner{
94         globalLocked = false;
95     }
96 
97     function tokenOf(address _user) view public returns(uint256 _result){
98         _result = DonQuixoteToken.balanceOf(_user);
99     }
100 
101     uint public currentEventId = 1;
102 
103     function getEventId() internal returns(uint _result) {
104         _result = currentEventId;
105         currentEventId ++;
106     }
107 
108     function setOfficialGameUrl(string _newOfficialGameUrl) public onlyOwner{
109         officialGameUrl = _newOfficialGameUrl;
110     }
111 
112     function depositToken(uint256 _amount) public {
113         lock();
114         _depositToken(msg.sender, _amount);
115         unLock();
116     }
117 
118     function _depositToken(address _to, uint256 _amount) internal {
119         require(_to != 0x0);
120         DonQuixoteToken.withhold(_to, _amount);
121         userTokenOf[_to] = userTokenOf[_to].add(_amount);
122     }
123 
124     function withdrawAllToken() public {
125         lock();
126         uint256 _amount = userTokenOf[msg.sender];
127         _withdrawToken(msg.sender, _amount);
128         unLock();
129     }
130 
131     function withdrawToken(uint256 _amount) public {
132         lock();
133         _withdrawToken(msg.sender, _amount);
134         unLock();
135     }
136 
137     function _withdrawToken(address _from, uint256 _amount) internal {
138         require(_from != 0x0);
139         require(_amount > 0 && _amount <= userTokenOf[_from]);
140         userTokenOf[_from] = userTokenOf[_from].sub(_amount);
141         DonQuixoteToken.transfer(_from, _amount);
142     }
143 }
144 
145 
146 contract GameSicBo is Base
147 {
148 
149 
150     uint public lastBlockNumber = 0;
151 
152 
153     uint public gameID = 0;
154     uint  public gameBeginTime;
155     uint  public gameEndTime;
156     uint public gameTime;
157     uint256 public gameMaxBetAmount;
158     uint256 public gameMinBetAmount;
159 
160     bool public gameOver = true;
161 
162 
163     bytes32 public gameEncryptedText;
164     uint public gameResult;
165     string public gameRandon1;
166     string public constant gameRandon2 = 'ChinasNewGovernmentBracesforTrump';
167     bool public betInfoIsLocked = false;
168 
169 
170     uint public playNo = 1;
171     uint public gameBeginPlayNo;
172     uint public gameEndPlayNo;
173     uint public nextRewardPlayNo;
174     uint public currentRewardNum = 100;
175 
176 
177 
178     function GameSicBo(string _gameName,uint  _gameTime, uint256 _gameMinBetAmount, uint256 _gameMaxBetAmount,address _DonQuixoteToken) public {
179         require(_gameTime > 0);
180         require(_gameMinBetAmount >= 0);
181         require(_gameMaxBetAmount > 0);
182         require(_gameMaxBetAmount >= _gameMinBetAmount);
183 
184 
185         gameMinBetAmount = _gameMinBetAmount;
186         gameMaxBetAmount = _gameMaxBetAmount;
187         gameTime = _gameTime;
188 
189         require(_DonQuixoteToken != 0x0);
190         DonQuixoteToken = IDonQuixoteToken(_DonQuixoteToken);
191 
192         owner = msg.sender;
193         gameName = _gameName;
194     }
195 
196 
197 
198     address public auction;
199 
200     function setAuction(address _newAuction) public onlyOwner{
201         auction = _newAuction;
202     }
203 
204     modifier onlyAuction {
205         require(msg.sender == auction);
206         _;
207     }
208 
209     modifier onlyBanker {
210         require(msg.sender == currentBanker);
211         require(bankerBeginTime <= now);
212         require(now < bankerEndTime);
213         _;
214     }
215 
216     function canSetBanker() public view returns (bool _result){
217         _result =  bankerEndTime <= now && gameOver;
218     }
219 
220 
221 
222     event OnSetNewBanker(address _caller, address _banker, uint _beginTime, uint _endTime, uint _code,uint _eventId,uint _time);
223 
224     function setBanker(address _banker, uint _beginTime, uint _endTime) public onlyAuction returns(bool _result)
225     {
226         _result = false;
227         require(_banker != 0x0);
228 
229 
230         if(now < bankerEndTime){
231 
232             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 1 ,getEventId(),now);
233             return;
234         }
235 
236 
237         if(!gameOver){
238 
239             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 2 ,getEventId(),now);
240             return;
241         }
242 
243 
244         if(_beginTime > now){
245 
246             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 3 ,getEventId(),now);
247             return;
248         }
249 
250 
251         if(_endTime <= now){
252 
253             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 4 ,getEventId(),now);
254             return;
255         }
256 
257         currentBanker = _banker;
258         bankerBeginTime = _beginTime;
259         bankerEndTime = _endTime;
260 
261         emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 0, getEventId(),now);
262         _result = true;
263 
264         if(now < donGameGiftLineTime){
265             DonQuixoteToken.logPlaying(_banker);
266         }
267     }
268 
269 
270 
271     function setCurrentRewardNum(uint _currentRewardNum) public onlyBanker{
272         currentRewardNum = _currentRewardNum ;
273     }
274 
275     event OnNewGame(uint _gameID, address _banker, bytes32 _gameEncryptedText, uint  _gameBeginTime,  uint  _gameEndTime, uint _eventId,uint _time);
276 
277     function newGame(bytes32 _gameEncryptedText) public onlyBanker returns(bool _result)
278     {
279         _result = _newGame( _gameEncryptedText);
280     }
281 
282     function _newGame(bytes32 _gameEncryptedText) private  returns(bool _result)
283     {
284         _result = false;
285         require(gameOver);
286         require(now > bankerBeginTime);
287         require(now + gameTime <= bankerEndTime);
288 
289         gameID++;
290 
291         gameEncryptedText = _gameEncryptedText;
292         gameRandon1 = '';
293         gameBeginTime = now;
294         gameEndTime = now + gameTime;
295         gameBeginPlayNo = playNo;
296         nextRewardPlayNo = playNo;
297         gameEndPlayNo = 0;
298         gameResult = 0;
299         gameOver = false;
300 
301         emit OnNewGame(gameID, msg.sender, _gameEncryptedText,   now,  now + gameTime, getEventId(),now);
302         _result = true;
303     }
304 
305     struct betInfo
306     {
307 
308         address Player;
309         uint BetType;
310         uint256 BetAmount;
311         uint Odds;
312         uint SmallNum;
313         uint BigNum;
314         bool IsReturnAward;
315         bool IsWin ;
316         uint BetTime;
317     }
318 
319     mapping (uint => betInfo) public playerBetInfoOf;
320 
321     event OnPlay(address indexed _player,uint indexed _gameID, uint indexed _playNo, uint _eventId,uint _time, uint _smallNum,uint _bigNum, uint256 _betAmount, uint _betType);
322 
323     function _play(uint _smallNum,uint _bigNum,  uint256 _betAmount, uint _odds,uint _betType) private  returns(bool _result){
324         _result = false;
325 
326         uint bankerAmount = _betAmount.mul(_odds);
327         require(userTokenOf[currentBanker] >= bankerAmount);
328 
329         if(userTokenOf[msg.sender] < _betAmount){
330             depositToken(_betAmount.sub(userTokenOf[msg.sender]));
331         }
332 
333         betInfo memory bi = betInfo({
334             Player :  msg.sender,
335             SmallNum : _smallNum,
336             BigNum : _bigNum,
337             BetAmount : _betAmount,
338             BetType : _betType,
339             Odds : _odds,
340             IsReturnAward: false,
341             IsWin :  false ,
342             BetTime : now
343             });
344         playerBetInfoOf[playNo] = bi;
345         userTokenOf[msg.sender] = userTokenOf[msg.sender].sub(_betAmount);
346         userTokenOf[this] = userTokenOf[this].add(_betAmount);
347         userTokenOf[currentBanker] = userTokenOf[currentBanker].sub(bankerAmount);
348         userTokenOf[this] = userTokenOf[this].add(bankerAmount);
349 
350         emit OnPlay(msg.sender, gameID, playNo ,getEventId(), now, _smallNum,_bigNum,  _betAmount, _betType);
351 
352         lastBlockNumber = block.number;
353         playNo++;
354 
355         if(now < donGameGiftLineTime){
356             DonQuixoteToken.logPlaying(msg.sender);
357         }
358         _result = true;
359     }
360 
361     uint public donGameGiftLineTime =  now + 90 days;
362 
363 
364 
365 
366     modifier playable(uint betAmount) {
367         require(!gameOver);
368         require(!betInfoIsLocked);
369         require(now < gameEndTime);
370 
371         require(msg.sender != currentBanker);
372         require(betAmount >= gameMinBetAmount);
373         _;
374     }
375 
376     function playBatch(uint[] _betNums,uint256[] _betAmounts) public returns(bool _result){
377         _result = false;
378         require(_betNums.length == _betAmounts.length);
379         require (_betNums.length <= 10);
380         _result = true ;
381         for(uint i = 0; i < _betNums.length && _result; i++ ){
382             uint _betNum = _betNums[i];
383             uint256 _betAmount = _betAmounts[i];
384             if(_betAmount < gameMinBetAmount){
385                 continue ;
386             }
387             if (_betAmount > gameMaxBetAmount){
388                 _betAmount = gameMaxBetAmount;
389             }
390             if(_betNum > 0 && _betNum <= 2){
391                 _result = playBigOrSmall(_betNum, _betAmount);
392             }else if(_betNum == 3){
393                 _result = playAnyTriples(_betAmount);
394             }else if(_betNum <= 9){
395                 _result = playSpecificTriples(_betNum.sub(3), _betAmount);
396             }else if(_betNum <= 15){
397                 _result = playSpecificDoubles(_betNum.sub(9),_betAmount);
398             }else if(_betNum <= 29){
399                 _result = playThreeDiceTotal(_betNum.sub(12), _betAmount);
400             }else if(_betNum <= 44){
401                 if(_betNum <= 34){
402                     uint _betMinNum = 1;
403                     uint _betMaxNum = _betNum.sub(28);
404                 }else if(_betNum <= 38){
405                     _betMinNum = 2;
406                     _betMaxNum = _betNum.sub(32);
407                 }else if(_betNum <= 41){
408                     _betMinNum = 3;
409                     _betMaxNum = _betNum.sub(35);
410                 }else if(_betNum <= 43){
411                     _betMinNum = 4;
412                     _betMaxNum = _betNum.sub(37);
413                 }else{
414                     _betMinNum = 5;
415                     _betMaxNum = 6;
416                 }
417                 _result = playDiceCombinations(_betMinNum,_betMaxNum, _betAmount);
418             }else if(_betNum <= 50){
419                 _result = playSingleDiceBet(_betNum.sub(44), _betAmount);
420             }
421         }
422         _result = true;
423     }
424 
425     function playBigOrSmall(uint _betNum, uint256 _betAmount) public playable(_betAmount)  returns(bool _result){
426         require(_betNum ==1 || _betNum == 2);
427         if (_betAmount > gameMaxBetAmount){
428             _betAmount = gameMaxBetAmount;
429         }
430         _result = _play(_betNum,0, _betAmount,1,1);
431     }
432 
433     function playAnyTriples(uint256 _betAmount) public playable(_betAmount)  returns(bool _result){
434         if (_betAmount > gameMaxBetAmount){
435             _betAmount = gameMaxBetAmount;
436         }
437         _result = _play(0,0, _betAmount,24,2);
438     }
439 
440     function playSpecificTriples(uint _betNum, uint256 _betAmount) public playable(_betAmount)  returns(bool _result){
441         require(_betNum >= 1 && _betNum <=6);
442         if (_betAmount > gameMaxBetAmount){
443             _betAmount = gameMaxBetAmount;
444         }
445         _result = _play(_betNum,0, _betAmount,150,3);
446     }
447 
448     function playSpecificDoubles(uint _betNum, uint256 _betAmount) public playable(_betAmount) returns(bool _result){
449         require(_betNum >= 1 && _betNum <=6);
450         if (_betAmount > gameMaxBetAmount){
451             _betAmount = gameMaxBetAmount;
452         }
453         _result = _play(_betNum,0, _betAmount,8,4);
454     }
455 
456     function playThreeDiceTotal(uint _betNum,uint256 _betAmount) public playable(_betAmount) returns(bool _result){
457         require(_betNum >= 4 && _betNum <=17);
458         if (_betAmount > gameMaxBetAmount){
459             _betAmount = gameMaxBetAmount;
460         }
461         uint _odds = 0;
462         if(_betNum == 4 || _betNum == 17){
463             _odds = 50;
464         }else if(_betNum == 5 || _betNum == 16){
465             _odds = 18;
466         }else if(_betNum == 6 || _betNum == 15){
467             _odds = 14;
468         }else if(_betNum == 7 || _betNum == 14){
469             _odds = 12;
470         }else if(_betNum == 8 || _betNum == 13){
471             _odds = 8;
472         }else{
473             _odds = 6;
474         }
475         _result = _play(_betNum,0, _betAmount,_odds,5);
476     }
477 
478     function playDiceCombinations(uint _smallNum,uint _bigNum,uint256 _betAmount) public playable(_betAmount) returns(bool _result){
479         require(_smallNum < _bigNum);
480         require(_smallNum >= 1 && _smallNum <=5);
481         require(_bigNum >= 2 && _bigNum <=6);
482         if (_betAmount > gameMaxBetAmount){
483             _betAmount = gameMaxBetAmount;
484         }
485         _result = _play(_smallNum,_bigNum, _betAmount,5,6);
486     }
487 
488     function playSingleDiceBet(uint _betNum,uint256 _betAmount) public playable(_betAmount) returns(bool _result){
489         require(_betNum >= 1 && _betNum <=6);
490         if (_betAmount > gameMaxBetAmount){
491             _betAmount = gameMaxBetAmount;
492         }
493         _result = _play(_betNum,0, _betAmount,3,7);
494     }
495 
496     function lockBetInfo() public onlyBanker returns (bool _result) {
497         require(!gameOver);
498         require(now < gameEndTime);
499         require(!betInfoIsLocked);
500         betInfoIsLocked = true;
501         _result = true;
502     }
503 
504     function uintToString(uint v) private pure returns (string) {
505         uint maxlength = 3;
506         bytes memory reversed = new bytes(maxlength);
507         uint i = 0;
508         while (v != 0) {
509             uint remainder = v % 10;
510             v = v / 10;
511             reversed[i++] = byte(48 + remainder);
512         }
513         bytes memory s = new bytes(i);
514         for (uint j = 0; j < i; j++) {
515             s[j] = reversed[i - j - 1];
516         }
517         string memory str = string(s);
518         return str;
519     }
520 
521 
522     event OnOpenGameResult(uint indexed _gameID, bool indexed _result, string _remark, address _banker,uint _gameResult, string _r1,uint _eventId,uint _time);
523 
524     function openGameResult(uint _minGameResult,uint _midGameResult,uint _maxGameResult, string _r1) public onlyBanker  returns(bool _result){
525         _result =  _openGameResult( _minGameResult,_midGameResult,_maxGameResult,_r1);
526     }
527 
528     function _playRealOdds(uint _betType,uint _odds,uint _smallNuml,uint _bigNum,uint _minGameResult,uint _midGameResult,uint _maxGameResult) private  pure returns(uint _realOdds){
529 
530 
531         _realOdds = 0;
532         if(_betType == 1){
533             bool _isAnyTriple = (_minGameResult == _midGameResult && _midGameResult == _maxGameResult);
534 
535             if(_isAnyTriple){
536                 return 0;
537             }
538             uint _threeDiceTotal = _minGameResult.add(_midGameResult).add(_maxGameResult);
539             uint _bigOrSmall = _threeDiceTotal >= 11 ? 2 : 1 ;
540             if(_bigOrSmall == _smallNuml){
541                 _realOdds = _odds;
542             }
543         }else if(_betType == 2){
544             _isAnyTriple = (_minGameResult == _midGameResult && _midGameResult == _maxGameResult);
545             if(_isAnyTriple){
546                 _realOdds = _odds;
547             }
548         }else if(_betType == 3){
549             _isAnyTriple = (_minGameResult == _midGameResult && _midGameResult == _maxGameResult);
550             uint _specificTriple  = (_isAnyTriple) ? _minGameResult : 0 ;
551             if( _specificTriple == _smallNuml){
552                 _realOdds = _odds;
553             }
554         }else if(_betType == 4){
555             uint _doubleTriple = (_minGameResult == _midGameResult) ? _minGameResult : ((_midGameResult == _maxGameResult)? _maxGameResult: 0);
556             if(_doubleTriple == _smallNuml){
557                 _realOdds = _odds;
558             }
559         }else if(_betType == 5){
560             _threeDiceTotal = _minGameResult + _midGameResult + _maxGameResult ;
561             if(_threeDiceTotal == _smallNuml){
562                 _realOdds = _odds;
563             }
564         }else  if(_betType == 6){
565 
566             if(_smallNuml == _minGameResult || _smallNuml == _midGameResult){
567                 if(_bigNum == _midGameResult || _bigNum == _maxGameResult){
568                     _realOdds = _odds;
569                 }
570             }
571         }else if(_betType == 7){
572 
573             if(_smallNuml == _minGameResult){
574                 _realOdds++;
575             }
576             if(_smallNuml == _midGameResult){
577                 _realOdds++;
578             }
579             if(_smallNuml == _maxGameResult){
580                 _realOdds++;
581             }
582 
583         }
584     }
585 
586 
587     function _openGameResult(uint _minGameResult,uint _midGameResult, uint _maxGameResult, string _r1) private  returns(bool _result){
588         _result = false;
589         require(betInfoIsLocked);
590         require(!gameOver);
591         require(now <= gameEndTime);
592         require(_minGameResult <= _midGameResult);
593         require(_midGameResult <= _maxGameResult);
594         require (_minGameResult >= 1 && _maxGameResult <= 6);
595 
596         uint _gameResult = _minGameResult*100 + _midGameResult*10 + _maxGameResult;
597         if(lastBlockNumber == block.number){
598             emit OnOpenGameResult(gameID,  false, 'block.number is equal', msg.sender, _gameResult, _r1,getEventId(),now);
599             return;
600         }
601         if(keccak256(uintToString(_gameResult) , gameRandon2 , _r1) ==  gameEncryptedText){
602             if(_minGameResult >= 1 && _minGameResult <= 6 && _midGameResult>=1 && _midGameResult<=6 && _maxGameResult>=0 && _maxGameResult<=6){
603                 gameResult = _gameResult ;
604                 gameRandon1 = _r1;
605                 gameEndPlayNo = playNo - 1;
606 
607                 for(uint i = 0; nextRewardPlayNo < playNo && i < currentRewardNum; i++ ){
608                     betInfo  storage p = playerBetInfoOf[nextRewardPlayNo];
609                     if(!p.IsReturnAward){
610                         p.IsReturnAward = true;
611                         uint realOdd = _playRealOdds(p.BetType,p.Odds,p.SmallNum,p.BigNum,_minGameResult,_midGameResult,_maxGameResult);
612                         p.IsWin =_calResultReturnIsWin(nextRewardPlayNo,realOdd);
613                         if(p.IsWin){
614 
615                             p.Odds = realOdd;
616                         }
617 
618                     }
619                     nextRewardPlayNo++;
620                 }
621                 if(nextRewardPlayNo == playNo){
622                     gameOver = true;
623                     betInfoIsLocked = false;
624                 }
625 
626                 emit OnOpenGameResult(gameID, true, 'Success', msg.sender,  _gameResult,  _r1,getEventId(),now);
627                 _result = true;
628                 return;
629             }else{
630                 emit OnOpenGameResult(gameID,  false, 'The result is illegal', msg.sender, _gameResult, _r1,getEventId(),now);
631                 return;
632             }
633         }else{
634             emit OnOpenGameResult(gameID,  false, 'Hash Value Not Match', msg.sender,  _gameResult,  _r1,getEventId(),now);
635             return;
636         }
637 
638     }
639 
640     function _calResultReturnIsWin(uint  _playerBetInfoOfIndex,uint _realOdd) private returns(bool _isWin){
641         betInfo memory  p = playerBetInfoOf[_playerBetInfoOfIndex];
642         uint256 AllAmount = p.BetAmount.mul(1 + p.Odds);
643         if(_realOdd > 0){
644             if(_realOdd == p.Odds){
645                 userTokenOf[p.Player] = userTokenOf[p.Player].add(AllAmount);
646                 userTokenOf[this] = userTokenOf[this].sub(AllAmount);
647             }else {
648                 uint256 winAmount = p.BetAmount.mul(1 + _realOdd);
649                 userTokenOf[p.Player] = userTokenOf[p.Player].add(winAmount);
650                 userTokenOf[this] = userTokenOf[this].sub(winAmount);
651                 userTokenOf[currentBanker] = userTokenOf[currentBanker].add(AllAmount.sub(winAmount));
652                 userTokenOf[this] = userTokenOf[this].sub(AllAmount.sub(winAmount));
653             }
654             return true ;
655         }else{
656             userTokenOf[currentBanker] = userTokenOf[currentBanker].add(AllAmount) ;
657             userTokenOf[this] = userTokenOf[this].sub(AllAmount);
658             if(now < donGameGiftLineTime){
659                 DonQuixoteToken.sendGameGift(p.Player);
660             }
661             return false ;
662         }
663     }
664 
665     function openGameResultAndNewGame(uint _minGameResult,uint _midGameResult,uint _maxGameResult, string _r1, bytes32 _gameEncryptedText) public onlyBanker returns(bool _result){
666 
667         if(!gameOver){
668             _result =  _openGameResult( _minGameResult,_midGameResult,_maxGameResult,  _r1);
669         }
670         if (gameOver){
671             _result = _newGame( _gameEncryptedText);
672         }
673     }
674 
675     function noOpenGameResult() public  returns(bool _result){
676         _result = false;
677         require(!gameOver);
678         require(gameEndTime < now);
679         if(lastBlockNumber == block.number){
680             emit OnOpenGameResult(gameID,false, 'block.number', msg.sender,0,'',getEventId(),now);
681             return;
682         }
683 
684         gameEndPlayNo = playNo - 1;
685         for(uint i = 0; nextRewardPlayNo < playNo && i < currentRewardNum; i++){
686             betInfo  storage p = playerBetInfoOf[nextRewardPlayNo];
687             if(!p.IsReturnAward){
688                 p.IsReturnAward = true;
689                 p.IsWin = true ;
690                 uint AllAmount = p.BetAmount.mul(1 + p.Odds);
691                 userTokenOf[p.Player] =userTokenOf[p.Player].add(AllAmount);
692                 userTokenOf[this] = userTokenOf[this].sub(AllAmount);
693             }
694             nextRewardPlayNo++;
695         }
696         if(nextRewardPlayNo == playNo){
697             gameOver = true;
698             if(betInfoIsLocked){
699                 betInfoIsLocked = false;
700             }
701         }
702 
703         emit OnOpenGameResult(gameID,  true, 'Banker Not Call', msg.sender,   0, '',getEventId(),now);
704         _result = true;
705     }
706 
707 
708 
709     function  failUserRefund(uint _playNo) public returns (bool _result) {
710 
711         _result = false;
712         require(!gameOver);
713         require(gameEndTime + 30 days < now);
714 
715         betInfo storage p = playerBetInfoOf[_playNo];
716         require(p.Player == msg.sender);
717 
718 
719         if(!p.IsReturnAward && p.SmallNum > 0){
720             p.IsReturnAward = true;
721             uint256 ToUser = p.BetAmount;
722             uint256 ToBanker = p.BetAmount.mul(p.Odds);
723             userTokenOf[p.Player] =  userTokenOf[p.Player].add(ToUser);
724             userTokenOf[this] = userTokenOf[this].sub(ToUser);
725             userTokenOf[currentBanker] =  userTokenOf[currentBanker].add(ToBanker);
726             userTokenOf[this] = userTokenOf[this].sub(ToBanker);
727 
728             p.Odds = 0;
729             _result = true;
730         }
731     }
732 
733     function () public payable {
734 
735     }
736 
737     function transEther() public onlyOwner()
738     {
739         msg.sender.transfer(address(this).balance);
740     }
741 }