1 pragma solidity ^0.4.21;
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
30 interface IGameToken{                                             
31     function mineToken(address _player, uint256 _etherAmount) external returns (uint _toPlayerToken);
32     function balanceOf(address _owner) constant  external returns (uint256 _balance);
33 }
34 
35 contract BaseGame {
36     using SafeMath for uint256;
37     
38     string public officialGameUrl;  
39     string public gameName = "GameSicBo";    
40     uint public gameType = 3003;               
41 
42     mapping (address => uint256) public userEtherOf;
43     
44     function userRefund() public  returns(bool _result);
45    
46     address public currentBanker;    
47     uint public bankerBeginTime;     
48     uint public bankerEndTime;       
49     IGameToken public GameToken;  
50     
51     function canSetBanker() view public returns (bool _result);
52     function setBanker(address _banker, uint256 _beginTime, uint256 _endTime) public returns(bool _result);
53 }
54 
55 contract Base is  BaseGame{
56     uint public createTime = now;
57     address public owner;
58     bool public globalLocked = false;      
59     uint public currentEventId = 1;            
60 
61     //function Base() public {
62     //}
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function setOwner(address _newOwner)  public  onlyOwner {
70         owner = _newOwner;
71     }
72 
73     function lock() internal {            
74         require(!globalLocked);
75         globalLocked = true;
76     }
77 
78     function unLock() internal {
79         require(globalLocked);
80         globalLocked = false;
81     }
82 
83     function setLock()  public onlyOwner{
84         globalLocked = false;
85     }
86 
87 
88     function getEventId() internal returns(uint _result) {  
89         _result = currentEventId;
90         currentEventId ++;
91     }
92 
93     function setOfficialGameUrl(string _newOfficialGameUrl) public onlyOwner{
94         officialGameUrl = _newOfficialGameUrl;
95     }
96 }
97 
98 contract GameSicBo is Base
99 {
100     uint public maxPlayableGameId = 0;      
101     uint public gameTime;              
102     uint256 public gameMaxBetAmount;    
103     uint256 public gameMinBetAmount;    
104     uint256 public minBankerEther = gameMaxBetAmount * 20;
105 
106     function setMinBankerEther(uint256 _value) public onlyBanker {          
107         require(_value >= gameMinBetAmount *  150);
108         minBankerEther = _value;
109     }
110 
111     uint public gameExpirationTime = 5 days;  
112     string public constant gameRandon2 = 'ChinasNewGovernmentBracesforTrump';    
113     bool public isStopPlay = false;
114     uint public playNo = 1;      
115     bool public isNeedLoan = true; 
116     uint256 public currentDayRate10000 = 0;      
117     address public currentLoanPerson;       
118     uint256 public currentLoanAmount;       
119     uint public currentLoanDayTime;       
120 
121     function GameSicBo(string _gameName,uint  _gameTime, uint256 _gameMinBetAmount, uint256 _gameMaxBetAmount,address _auction,address _gameToken)  public {
122         require(_gameTime > 0);
123         require(_gameMinBetAmount > 0);
124         require(_gameMaxBetAmount > 0);
125         require(_gameMaxBetAmount >= _gameMinBetAmount);
126         require(_gameToken != 0x0);
127 
128         gameMinBetAmount = _gameMinBetAmount;
129         gameMaxBetAmount = _gameMaxBetAmount;
130         
131         minBankerEther = gameMaxBetAmount * 20;
132         gameTime = _gameTime;
133         GameToken = IGameToken(_gameToken);
134 
135         gameName = _gameName;
136         owner = msg.sender;
137         auction = _auction;
138         officialGameUrl='http://sicbo.donquixote.games/';
139     }
140 
141     function tokenOf(address _user) view public returns(uint _result){
142        _result = GameToken.balanceOf(_user);
143     }
144 
145     address public auction;     
146     function setAuction(address _newAuction) public onlyOwner{
147         auction = _newAuction;
148     }
149 
150     modifier onlyAuction {              
151         require(msg.sender == auction);
152         _;
153     }
154 
155     modifier onlyBanker {              
156         require(msg.sender == currentBanker);
157         require(bankerBeginTime <= now);
158         require(now < bankerEndTime);
159         _;
160     }
161 
162     modifier playable(uint betAmount) {
163         require (!isStopPlay); 
164         require(msg.sender != currentBanker);               
165         require(betAmount >= gameMinBetAmount);        
166         _;
167     }
168 
169    function canSetBanker() public view returns (bool _result){
170         _result =  bankerEndTime <= now;
171     }
172 
173     event OnSetNewBanker(address _caller, address _banker, uint _beginTime, uint _endTime, uint _code,uint _eventId,uint _eventTime);
174     function setBanker(address _banker, uint _beginTime, uint _endTime) public onlyAuction returns(bool _result)        
175     {
176         _result = false;
177         require(_banker != 0x0);
178              
179         if(now < bankerEndTime){
180             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 1 ,getEventId(),now);
181             return;
182         }
183        
184         if(_beginTime > now){
185             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 3 ,getEventId(),now);
186             return;
187         }
188      
189         if(_endTime <= now){
190             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 4 ,getEventId(),now);
191             return;
192         }
193        
194         uint256 toLoan = calLoanAmount();
195         uint256 _bankerAmount = userEtherOf[currentBanker];
196         if(_bankerAmount < toLoan){
197              toLoan = _bankerAmount;
198         }
199         userEtherOf[currentLoanPerson] = userEtherOf[currentLoanPerson].add(toLoan);
200         userEtherOf[currentBanker] = userEtherOf[currentBanker].sub(toLoan);
201         currentLoanPerson = 0x0;
202         currentDayRate10000 = 0;
203         currentLoanAmount = 0;
204         currentLoanDayTime = now;
205         emit OnPayLoan(currentBanker,now,toLoan);
206 
207         currentBanker = _banker;
208         bankerBeginTime = _beginTime;
209         bankerEndTime = _endTime;
210         isStopPlay = false;
211         
212         emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 0, getEventId(),now);
213         _result = true;
214     }
215    
216     struct gameInfo             
217     {
218         address Banker;
219         bytes32 EncryptedText;  
220         bytes32 GameRandon;        
221         uint GameResult ; 
222         mapping(uint8 => uint) TotalBetInfoOf;
223     }
224 
225     function hasBetting(uint _gameId) public view returns (bool _result){       
226         gameInfo storage gi = gameInfoOf[_gameId];
227         require(gi.Banker != 0x0);
228         _result = false;
229         for(uint8 i = 1; i <= 50; i++){
230             if (gi.TotalBetInfoOf[i] > 0){
231                 _result = true;
232                 return;
233             }
234         }
235     }
236     struct betInfo             
237     {
238         uint256 GameId;
239         address Player;
240         uint256 BetAmount;      
241         uint8 Odds;            
242         uint8 BetNum;           
243         bool IsReturnAward;     
244         bool IsWin ;         
245         uint BetTime;
246     }
247 
248     mapping (uint => betInfo) public playerBetInfoOf;             
249     mapping (uint => gameInfo) public gameInfoOf;               
250 
251     function getCurrentGameId()  public  view returns (uint _result){       
252         _result = now.sub(createTime).div(gameTime);
253         if(now.sub(createTime) % gameTime >0 ){
254            _result = _result.add(1);
255         }
256     }
257 
258     function getCountCanAdd() view public returns (uint _result){         
259         _result = 0;
260         uint currentGameId = getCurrentGameId();
261         if(currentGameId < maxPlayableGameId){
262           _result = (bankerEndTime.sub(gameTime.mul(maxPlayableGameId).add(createTime))).div(gameTime);
263         }else{
264           _result = bankerEndTime.sub(now).div(gameTime);
265         }
266     }
267 
268     function getGameBeginTime(uint _gameId) view public returns (uint _result){
269         _result = 0;
270         if(_gameId <= maxPlayableGameId && _gameId != 0){
271           _result = _gameId.mul(gameTime).add(createTime).sub(gameTime);
272         }
273     }
274 
275     function getGameEndTime(uint _gameId) view public returns (uint _result){
276         _result = 0;
277         if(_gameId <= maxPlayableGameId  && _gameId != 0){
278           _result = _gameId.mul(gameTime).add(createTime);
279         }
280     }
281 
282     function isGameExpiration(uint _gameId) view public returns(bool _result){        
283         _result = false;
284         if(_gameId.mul(gameTime).add(createTime).add(gameExpirationTime) < now && gameInfoOf[_gameId].GameResult ==0 ){
285           _result = true;
286         }
287     }
288 
289     function userRefund() public  returns(bool _result) {
290         return _userRefund(msg.sender);
291     }
292     
293     function _userRefund(address _to) internal returns(bool _result) {
294         require (_to != 0x0);
295         lock();
296         uint256 amount = userEtherOf[msg.sender];
297         if(amount > 0){ 
298             if(msg.sender == currentBanker){
299                 if(currentLoanPerson == 0x0 || checkPayLoan() ){   
300                     if(amount >= minBankerEther){    
301                       uint256 toBanker = amount - minBankerEther;
302                       _to.transfer(toBanker);
303                       userEtherOf[msg.sender] = minBankerEther;
304                     }
305                 }
306             }else{
307                 _to.transfer(amount);
308                 userEtherOf[msg.sender] = 0;    
309             }
310             _result = true;
311         }else{
312             _result = false;
313         }
314         unLock();
315     }
316 
317     function setIsNeedLoan(bool _isNeedLoan) public onlyBanker returns(bool _result) {  
318         _result = false;
319         if(!isNeedLoan){
320             
321             require(currentLoanAmount == 0);
322         }
323         isNeedLoan = _isNeedLoan;
324         _result = true;
325     }
326 
327     event OnBidLoan(bool indexed _success, address indexed _user, uint256 indexed _dayRate10000,  uint256 _etherAmount);
328     event OnPayLoan(address _sender,uint _eventTime,uint256 _toLoan);
329 
330     function bidLoan(uint256 _dayRate10000) public payable returns(bool _result) {      
331         _result = false;
332         require(isNeedLoan); 
333         require(!isStopPlay);
334         require(msg.sender != currentBanker);
335         
336         require(_dayRate10000 < 1000);           
337         depositEther();
338         
339         if(checkPayLoan()){
340            
341             emit OnBidLoan(false, msg.sender, _dayRate10000,  0);
342             return;
343         }
344         
345         uint256 toLoan = calLoanAmount();
346         uint256 toGame = 0;
347         if (userEtherOf[currentBanker] < minBankerEther){      
348             toGame = minBankerEther.sub(userEtherOf[currentBanker]);
349         }
350 
351         if(toLoan > 0 && toGame == 0 && currentLoanPerson != 0x0){                    
352             require(_dayRate10000 < currentDayRate10000);
353         }
354 
355         require(toLoan + toGame > 0);                                                
356         require(userEtherOf[msg.sender] >= toLoan + toGame);
357 
358         userEtherOf[msg.sender] = userEtherOf[msg.sender].sub(toLoan + toGame);
359         userEtherOf[currentLoanPerson] = userEtherOf[currentLoanPerson].add(toLoan);
360         userEtherOf[currentBanker] = userEtherOf[currentBanker].add(toGame);
361 
362         currentLoanPerson = msg.sender;
363         currentDayRate10000 = _dayRate10000;
364         currentLoanAmount = toLoan + toGame;
365         currentLoanDayTime = now;
366 
367         emit OnBidLoan(false, msg.sender, _dayRate10000,  currentLoanAmount);
368 
369         _result = true;
370         return;
371     }
372 
373     function getCanLoanAmount() public view returns(uint256  _result){                 
374         uint256 toLoan = calLoanAmount();
375 
376         uint256 toGame = 0;
377         if (userEtherOf[currentBanker] <= minBankerEther){
378             toGame = minBankerEther - userEtherOf[currentBanker];
379             _result =  toLoan + toGame;
380             return;
381         }
382         else if (userEtherOf[currentBanker] > minBankerEther){
383             uint256 c = userEtherOf[currentBanker] - minBankerEther;
384             if(toLoan > c){
385                 _result =  toLoan - c;
386                 return;
387             }
388             else{
389                 _result =  0;
390                 return;
391             }
392         }
393     }
394 
395     function calLoanAmount() public view returns (uint256 _result){
396       _result = 0;
397       if(currentLoanPerson != 0x0 && currentLoanAmount > 0){
398           _result = currentLoanAmount;
399           uint d = (now - currentLoanDayTime) / (1 days);
400           for(uint i = 0; i < d; i++){
401               _result = _result * (10000 + currentDayRate10000) / 10000;
402           }
403         }
404     }
405 
406     function checkPayLoan() public returns (bool _result) {                        
407         _result = false;
408         uint256 toLoan = calLoanAmount();
409         if(toLoan > 0){      
410             bool isStop =  isStopPlay && now  > getGameEndTime(maxPlayableGameId).add(1 hours);                      
411             if (isStop || userEtherOf[currentBanker] >= minBankerEther.add(toLoan)){            
412                 userEtherOf[currentLoanPerson] = userEtherOf[currentLoanPerson].add(toLoan);
413                 userEtherOf[currentBanker] = userEtherOf[currentBanker].sub(toLoan);
414                 currentLoanPerson = 0x0;
415                 currentDayRate10000 = 0;
416                 currentLoanAmount = 0;
417                 currentLoanDayTime = now;
418                 _result = true;
419                 emit OnPayLoan(msg.sender,now,toLoan);
420                 return;
421             }
422         }
423     }
424 
425     event OnNewGame(uint indexed _gameId, address indexed _bankerAddress, bytes32 indexed _gameEncryptedTexts, uint _gameBeginTime, uint _gameEndTime, uint _eventTime, uint _eventId);
426     function newGame(bytes32[] _gameEncryptedTexts) public onlyBanker payable returns(bool _result)       
427     {
428         if (msg.value > 0){
429             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);       
430         }
431 
432         _result = _newGame( _gameEncryptedTexts);
433     }
434 
435     function setStopPlay(bool _isStopPlay) public onlyBanker
436     {   
437         isStopPlay = _isStopPlay;
438     }
439 
440     function _newGame(bytes32[] _gameEncryptedTexts)   private  returns(bool _result)       
441     {   
442         _result = false;
443 
444         uint countCanAdd = getCountCanAdd();   
445         require(countCanAdd > 0); 
446         if(countCanAdd > _gameEncryptedTexts.length){
447           countCanAdd = _gameEncryptedTexts.length;
448         }
449         uint currentGameId = getCurrentGameId();
450         if(maxPlayableGameId < currentGameId){
451           maxPlayableGameId = currentGameId.sub(1);
452         }
453 
454         for(uint i=0;i<countCanAdd;i++){
455             if(_gameEncryptedTexts[i] == 0x0){
456                 continue;
457             }
458             maxPlayableGameId++;
459             gameInfo memory info = gameInfo({
460                 Banker :currentBanker,
461                 EncryptedText:  _gameEncryptedTexts[i],
462                 GameRandon:  0x0,       
463                 GameResult:0  
464             });
465             gameInfoOf[maxPlayableGameId] = info;
466             emit OnNewGame(maxPlayableGameId, msg.sender, _gameEncryptedTexts[i], getGameBeginTime(maxPlayableGameId), getGameEndTime(maxPlayableGameId), now, getEventId());
467         }
468         _result = true;
469     }
470 
471     event OnPlay(address indexed _player,uint indexed _gameId, uint indexed _playNo, uint8 _betNum, uint256 _betAmount,uint _giftToken, uint _eventId,uint _eventTime);
472 
473     function depositEther() public payable
474     {  
475         if (msg.value > 0){
476             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
477         }
478     }
479 
480     function playBigOrSmall(uint8 _betNum, uint256 _betAmount) public payable playable(_betAmount) returns(bool _result){       
481         lock();
482         depositEther();
483         require(_betNum ==1 || _betNum == 2); 
484         if (_betAmount > gameMaxBetAmount){             
485             _betAmount = gameMaxBetAmount;
486         }
487         _result = _play(_betNum, _betAmount,false);
488         unLock();
489     }
490 
491     function playAnyTriples(uint256 _betAmount) public payable  playable(_betAmount)  returns(bool _result){       
492         lock();
493         depositEther();
494         if (_betAmount > gameMaxBetAmount){             
495             _betAmount = gameMaxBetAmount;
496         }
497         _result = _play(3, _betAmount,false);
498         unLock();
499     }
500 
501     function playSpecificTriples(uint8 _betNum, uint256 _betAmount) public payable playable(_betAmount)  returns(bool _result){       
502         lock();
503         depositEther();
504         require(_betNum >= 1 && _betNum <=6); 
505         if (_betAmount > gameMaxBetAmount){             
506             _betAmount = gameMaxBetAmount;
507         }
508         _result = _play(_betNum + 3, _betAmount,false);
509         unLock();
510     }
511 
512     function playSpecificDoubles(uint8 _betNum, uint256 _betAmount) public payable playable(_betAmount)  returns(bool _result){       
513         lock();
514         depositEther();
515         require(_betNum >= 1 && _betNum <=6);
516         if (_betAmount > gameMaxBetAmount){             
517             _betAmount = gameMaxBetAmount;
518         }
519         _result = _play(_betNum + 9 , _betAmount,false);
520         unLock();
521     }
522 
523     function playThreeDiceTotal(uint8 _betNum,uint256 _betAmount) public payable  playable(_betAmount)  returns(bool _result){      
524         lock();
525         depositEther();
526         require(_betNum >= 4 && _betNum <=17); 
527         if (_betAmount > gameMaxBetAmount){             
528             _betAmount = gameMaxBetAmount;
529         }
530         _result = _play(_betNum + 12, _betAmount,false);
531         unLock();
532     }
533 
534     function playDiceCombinations(uint8 _smallNum,uint8 _bigNum,uint256 _betAmount) public payable playable(_betAmount)  returns(bool _result){       
535         lock();
536         depositEther();
537         require(_smallNum < _bigNum);
538         require(_smallNum >= 1 && _smallNum <=5); 
539         require(_bigNum >= 2 && _bigNum <=6);
540         if (_betAmount > gameMaxBetAmount){             
541             _betAmount = gameMaxBetAmount;
542         }
543         uint8 _betNum = 0 ;
544         if(_smallNum == 1){
545             _betNum = 28+_bigNum;
546         }else if(_smallNum ==2){
547              _betNum = 32+_bigNum;
548         }else if(_smallNum == 3){
549              _betNum = 35+_bigNum;
550         }else if(_smallNum == 4){
551              _betNum = 37+_bigNum;
552         }else if(_smallNum == 5){
553             _betNum = 44;
554         }
555         _result = _play(_betNum,_betAmount,false);
556         unLock();
557     }
558 
559     function playSingleDiceBet(uint8 _betNum,uint256 _betAmount) public payable playable(_betAmount)  returns(bool _result){       
560         lock();
561         depositEther();
562         require(_betNum >= 1 && _betNum <=6);
563         if (_betAmount > gameMaxBetAmount){            
564             _betAmount = gameMaxBetAmount;
565         }
566         _result = _play(_betNum + 44,_betAmount,false);
567         unLock();
568     }
569 
570     function _calOdds(uint8 _betNum) internal pure returns(uint8 _odds){
571         if(_betNum > 0 && _betNum <= 2){
572             return 1;
573         }else if(_betNum == 3){
574             return 24;
575         }else if(_betNum <= 9){
576             return 150;
577         }else if(_betNum <= 15){
578             return 8;
579         }else if(_betNum <= 29){
580             if(_betNum == 16 || _betNum == 29){ 
581                 return 50;
582             }else if(_betNum == 17 || _betNum == 28){ 
583                 return 18;
584             }else if(_betNum == 18 || _betNum == 27){
585                return 14;
586             }else if(_betNum == 19 || _betNum == 26){  
587                 return 12;
588             }else if(_betNum == 20 || _betNum == 25){ 
589                 return 8;
590             }else{
591                 return 6;
592             }
593         }else if(_betNum <= 44){
594             return 5;
595         }else if(_betNum <= 50){
596             return 3;
597         }
598         return 0;
599     }
600 
601     function playBatch(uint8[] _betNums,uint256[] _betAmounts) public payable returns(bool _result)
602     {   
603         lock();
604         _result = false;
605       
606         require(msg.sender != currentBanker);               
607         
608         uint currentGameId = getCurrentGameId();
609         
610         gameInfo  storage gi = gameInfoOf[currentGameId];
611         require (gi.GameResult == 0 && gi.Banker == currentBanker);
612         depositEther();
613         require(_betNums.length == _betAmounts.length);
614         require (_betNums.length <= 10);
615         _result = true ;
616         for(uint i = 0; i < _betNums.length && _result ; i++ ){
617             uint8 _betNum = _betNums[i];
618             uint256 _betAmount = _betAmounts[i];
619             if(_betAmount < gameMinBetAmount || _betNum > 50){
620                
621                 continue ;
622             }
623             if (_betAmount > gameMaxBetAmount){             
624                 _betAmount = gameMaxBetAmount;
625             }
626             _result =_play(_betNum,_betAmount,true);
627         }
628         unLock();
629     }
630 
631     function _play(uint8 _betNum,  uint256 _betAmount,bool isBatch) private  returns(bool _result)
632     {            
633         _result = false;
634         uint8 _odds = _calOdds(_betNum);
635         uint bankerAmount = _betAmount.mul(_odds);   
636         if(!isBatch){
637             require(userEtherOf[msg.sender] >= _betAmount);
638             require(userEtherOf[currentBanker] >= bankerAmount); 
639         }else{
640             if(userEtherOf[msg.sender] < _betAmount  || userEtherOf[currentBanker] < bankerAmount){
641                 return false;
642             }
643         }
644         uint currentGameId = getCurrentGameId();
645         gameInfo  storage gi = gameInfoOf[currentGameId];
646         require (gi.GameResult == 0 && gi.Banker == currentBanker);
647 
648         betInfo memory bi = betInfo({
649             GameId : currentGameId ,
650             Player :  msg.sender,
651             BetNum : _betNum,
652             BetAmount : _betAmount,
653             Odds : _odds,
654             IsReturnAward: false,
655             IsWin :  false,
656             BetTime : now
657         });
658         playerBetInfoOf[playNo] = bi;
659         userEtherOf[msg.sender] = userEtherOf[msg.sender].sub(_betAmount);                  
660         userEtherOf[currentBanker] = userEtherOf[currentBanker].sub(bankerAmount);     
661         userEtherOf[this] = userEtherOf[this].add(_betAmount.add(bankerAmount));
662 
663         gi.TotalBetInfoOf[_betNum] = gi.TotalBetInfoOf[_betNum].add(_betAmount.add(bankerAmount));
664 
665         uint _giftToken = GameToken.mineToken(msg.sender,_betAmount);
666 
667         emit OnPlay(msg.sender, currentGameId, playNo , _betNum,  _betAmount,_giftToken,getEventId(), now);
668 
669         playNo++;
670         _result = true;
671     }
672     
673     function _getPlayDiceCombinationsIndex(uint8 _smallNum,uint8 _bigNum) internal pure returns(uint8 index)
674     {
675         if(_smallNum == 1){
676             return 28+_bigNum;
677         }else if(_smallNum ==2){
678              return 32+_bigNum;
679         }else if(_smallNum == 3){
680              return 35+_bigNum;
681         }else if(_smallNum == 4){
682              return 37+_bigNum;
683         }else if(_smallNum == 5){
684             return 44;
685         }
686     }
687 
688     function uintToString(uint v) private pure returns (string)
689     {
690         uint maxlength = 3;
691         bytes memory reversed = new bytes(maxlength);
692         uint i = 0;
693         while (v != 0) {
694             uint remainder = v % 10;
695             v = v / 10;
696             reversed[i++] = byte(48 + remainder);
697         }
698         bytes memory s = new bytes(i); 
699         for (uint j = 0; j < i; j++) {
700             s[j] = reversed[i - j - 1]; 
701         }
702         string memory str = string(s); 
703         return str; 
704     }
705 
706     event OnOpenGameResult(uint indexed _gameId,  address indexed _banker,bytes32 indexed _randon1,uint _gameResult, uint _eventId,uint _eventTime);
707 
708     function openGameResult(uint _gameId,uint8 _minGameResult,uint8 _midGameResult,uint8 _maxGameResult, bytes32 _randon1) public  returns(bool _result)
709     {
710         _result =  _openGameResult(_gameId, _minGameResult,_midGameResult,_maxGameResult,_randon1);
711     }
712 
713     function _openGameResult(uint _gameId,uint8 _minGameResult,uint8 _midGameResult, uint8 _maxGameResult, bytes32 _randon1) private  returns(bool _result)
714     {            
715         _result = false;
716         require(_minGameResult <= _midGameResult);
717         require(_midGameResult <= _maxGameResult);
718         require (_minGameResult >= 1 && _maxGameResult <= 6);
719         uint _gameEndTime = getGameEndTime(_gameId);
720         require (_gameEndTime < now);  
721         require (_gameEndTime + gameExpirationTime > now);  
722 
723         gameInfo  storage gi = gameInfoOf[_gameId];
724         require(gi.Banker == msg.sender);
725         require(gi.GameResult == 0);
726         uint _gameResult = uint(_minGameResult)*100 + _midGameResult*10 + _maxGameResult;
727 
728       require (keccak256(uintToString(_gameResult) ,gameRandon2, _randon1) ==  gi.EncryptedText);
729 
730         gi.GameResult = _gameResult;
731         gi.GameRandon = _randon1;
732 
733         emit OnOpenGameResult(_gameId, msg.sender,_randon1,  _gameResult, getEventId(),now);
734         lock();
735         _bankerCal(gi,_minGameResult,_midGameResult,_maxGameResult);
736         unLock();
737         _result = true;
738     }
739 
740     function _bankerCal(gameInfo storage _gi,uint8 _minGameResult,uint8 _midGameResult, uint8 _maxGameResult) internal
741     {
742         uint _bankerAmount = 0;
743 
744         mapping(uint8 => uint) _totalBetInfoOf = _gi.TotalBetInfoOf;
745 
746         uint8 _threeDiceTotal = _minGameResult + _midGameResult + _maxGameResult;  
747         bool _isAnyTriple = (_minGameResult == _maxGameResult);
748         uint8 _doubleTriple = (_minGameResult == _midGameResult) ? _minGameResult : ((_midGameResult == _maxGameResult)? _maxGameResult: 0);
749 
750         _bankerAmount = _bankerAmount.add(_sumAmount(_gi,16,29,_threeDiceTotal + 12));
751         _bankerAmount = _bankerAmount.add(_sumAmount(_gi,10,15,_doubleTriple +9));
752 
753         if(_isAnyTriple){ 
754           
755             _bankerAmount = _bankerAmount.add(_totalBetInfoOf[1]);
756             _bankerAmount = _bankerAmount.add(_totalBetInfoOf[2]);
757             _bankerAmount = _bankerAmount.add(_sumAmount(_gi,4,9,3+_minGameResult));
758             _bankerAmount = _bankerAmount.add(_sumAmount(_gi,30,44,0));  
759             _bankerAmount = _bankerAmount.add(_sumAmount(_gi,45,50,_minGameResult + 44));  
760         }else{
761             
762             _bankerAmount = _bankerAmount.add(_sumAmount(_gi,3,9,0));
763             if(_threeDiceTotal >= 11){ 
764                 _bankerAmount = _bankerAmount.add(_totalBetInfoOf[1]);
765             }else{
766                 _bankerAmount = _bankerAmount.add(_totalBetInfoOf[2]);
767             }
768             _bankerAmount = _bankerAmount.add(_bankerCalOther(_gi,_minGameResult,_midGameResult,_maxGameResult,_doubleTriple));
769         }
770          
771         userEtherOf[_gi.Banker] =userEtherOf[_gi.Banker].add(_bankerAmount);
772         userEtherOf[this] =userEtherOf[this].sub(_bankerAmount);
773     }
774 
775     function _bankerCalOther(gameInfo storage _gi,uint8 _minGameResult,uint8 _midGameResult, uint8 _maxGameResult,uint8 _doubleTriple) private view returns(uint _bankerAmount) {
776         
777         mapping(uint8 => uint) _totalBetInfoOf = _gi.TotalBetInfoOf;
778         if(_doubleTriple != 0){
779             
780             if(_maxGameResult == _doubleTriple){
781                
782                 uint8 _index1 = _getPlayDiceCombinationsIndex(_minGameResult,_midGameResult);
783                 uint8 _index2 = _minGameResult + 44; 
784             }else if(_minGameResult == _doubleTriple){
785                 
786                 _index1 =_getPlayDiceCombinationsIndex(_midGameResult,_maxGameResult);
787                 _index2 = _maxGameResult + 44; 
788             }
789             _bankerAmount = _bankerAmount.add(_sumAmount(_gi,30,44,_index1));  
790 
791             uint8 _index3= _midGameResult + 44; 
792             for(uint8 i=45;i<=50;i++){
793                 if(i == _index3){
794                     
795                     _betAmount = _totalBetInfoOf[i];
796                     _bankerAmount = _bankerAmount.add(_betAmount.div(4));
797                 }else if(i == _index2){
798                     
799                     _betAmount = _totalBetInfoOf[i];
800                     _bankerAmount = _bankerAmount.add(_betAmount.div(2));
801                 }else{
802                     
803                     _bankerAmount = _bankerAmount.add(_totalBetInfoOf[i]);
804                 }
805             }
806         }else{
807               
808             _index1 = _getPlayDiceCombinationsIndex(_minGameResult,_midGameResult);
809             _index2 = _getPlayDiceCombinationsIndex(_minGameResult,_maxGameResult);
810             _index3 = _getPlayDiceCombinationsIndex(_midGameResult,_maxGameResult);
811 
812             for(i=30;i<=44;i++){
813                 if(i != _index1 && i != _index2 && i != _index3){
814                     _bankerAmount = _bankerAmount.add(_totalBetInfoOf[i]);
815                 }
816             }
817            
818             _index1 = _minGameResult+44;
819             _index2 = _midGameResult+44;
820             _index3 = _maxGameResult+44;
821             uint _betAmount = 0 ;
822             for(i=45;i<=50;i++){
823                 if(i != _index1 && i != _index2 && i != _index3){
824                    
825                      _bankerAmount = _bankerAmount.add(_totalBetInfoOf[i]);
826                 }else{
827                     
828                     _betAmount = _totalBetInfoOf[i];
829                     _bankerAmount = _bankerAmount.add(_betAmount.div(2)); 
830                 }
831             }
832 
833         }
834     }
835 
836     function _sumAmount(gameInfo storage _gi,uint8 _startIndex,uint8 _endIndex,uint8 _excludeIndex) internal view returns(uint _totalAmount)
837     {   
838         _totalAmount = 0 ;
839         for(uint8 i=_startIndex;i<=_endIndex;i++){
840             if(i != _excludeIndex){
841                 _totalAmount = _totalAmount.add(_gi.TotalBetInfoOf[i]);
842             }
843         }
844         return _totalAmount;
845     }
846 
847     event OnGetAward(uint indexed _playNo,uint indexed _gameId, address indexed _player, uint _betNum, uint _betAmount,uint _awardAmount, uint _gameResult,uint _eventTime, uint _eventId);
848     
849     function getAwards(uint[] playNos) public
850     {   
851         lock();
852 
853         for(uint i=0;i<playNos.length;i++){
854             if(playNos[i] > playNo){
855                 continue; 
856             }
857             betInfo storage p = playerBetInfoOf[playNos[i]];
858             if(p.IsReturnAward){
859                 continue;
860             }
861 
862             gameInfo storage _gi = gameInfoOf[p.GameId];
863             uint _gameEndTime = getGameEndTime(p.GameId);
864             uint _awardAmount = 0; 
865             if(isGameExpiration(p.GameId)){
866                 uint AllAmount = p.BetAmount.mul(1 + p.Odds); 
867                 userEtherOf[this] =userEtherOf[this].sub(AllAmount);
868                 p.IsReturnAward = true;
869                 if(now > _gameEndTime+ 30 days){
870                     userEtherOf[_gi.Banker] =userEtherOf[_gi.Banker].add(AllAmount);                   
871                 }else{
872                     p.IsWin = true ; 
873                     userEtherOf[p.Player] =userEtherOf[p.Player].add(AllAmount);
874                     _awardAmount = AllAmount;                
875                 }                   
876             }else if(_gi.GameResult != 0){ 
877                 p.IsReturnAward = true;
878                 uint8 _realOdd = _playRealOdds(p.BetNum,p.Odds,_gi.GameResult);
879                 if(_realOdd > 0){ 
880                     uint256 winAmount = p.BetAmount.mul(1 + _realOdd); 
881                     p.Odds = _realOdd;
882                     userEtherOf[this] = userEtherOf[this].sub(winAmount);
883                     if(now > _gameEndTime + 30 days){
884                         
885                         userEtherOf[_gi.Banker] = userEtherOf[_gi.Banker].add(winAmount);
886                     }else{
887                         p.IsWin = true ;
888                         userEtherOf[p.Player] =  userEtherOf[p.Player].add(winAmount);
889                         _awardAmount = winAmount;
890                     }
891                 }
892                
893             }
894             emit OnGetAward(playNos[i], p.GameId, p.Player,  p.BetNum, p.BetAmount, _awardAmount, _gi.GameResult, now, getEventId());
895         }
896         unLock();
897     }
898 
899     function _playRealOdds(uint8 _betNum,uint8 _odds,uint _gameResult) private  pure returns(uint8 _realOdds)
900     {
901         uint8 _minGameResult = uint8(_gameResult/100);
902         uint8 _midGameResult = uint8(_gameResult/10%10);
903         uint8 _maxGameResult = uint8(_gameResult%10);
904 
905         _realOdds = 0;
906         uint8 _smallNum = 0;
907         uint8 _bigNum = 0;
908         if(_betNum <=2){
909             
910             if(_minGameResult == _maxGameResult){
911                 return 0;
912             }
913             uint8 _threeDiceTotal = _minGameResult + _midGameResult +_maxGameResult ; 
914             uint _bigOrSmall = _threeDiceTotal >= 11 ? 2 : 1 ; 
915             _smallNum = _betNum;
916             if(_bigOrSmall == _smallNum){
917                 _realOdds = _odds;
918             }
919         }else if(_betNum == 3){
920             if(_minGameResult == _maxGameResult){
921                 _realOdds = _odds;
922             }
923         }else if(_betNum <= 9){
924             uint _specificTriple  = (_minGameResult == _maxGameResult) ? _minGameResult : 0 ; 
925             _smallNum = _betNum - 3 ;
926             if( _specificTriple == _smallNum){
927                 _realOdds = _odds;
928             }
929         }else if(_betNum <= 15){
930             uint _doubleTriple = (_minGameResult == _midGameResult) ? _minGameResult : ((_midGameResult == _maxGameResult)? _maxGameResult: 0);
931             _smallNum = _betNum - 9 ;
932             if(_doubleTriple == _smallNum){
933                 _realOdds = _odds;
934             }
935         }else if(_betNum <= 29){
936             _threeDiceTotal = _minGameResult + _midGameResult + _maxGameResult ;  
937             _smallNum = _betNum - 12 ;
938             if(_threeDiceTotal == _smallNum){
939                 _realOdds = _odds;
940             }
941         }else  if(_betNum <= 44){
942             
943             if(_betNum <= 34){
944                 _smallNum = 1;
945                 _bigNum = _betNum - 28;
946             }else if(_betNum <= 38){
947                 _smallNum = 2;
948                 _bigNum = _betNum - 32;
949             }else if(_betNum <=41){
950                  _smallNum = 3;
951                 _bigNum = _betNum - 35;
952             }else if(_betNum <=43){
953                  _smallNum = 4;
954                 _bigNum = _betNum - 37;
955             }else{
956                 _smallNum = 5;
957                 _bigNum = 6;
958             }
959             if(_smallNum == _minGameResult || _smallNum == _midGameResult){
960                 if(_bigNum == _midGameResult || _bigNum == _maxGameResult){
961                     _realOdds = _odds;
962                 }
963             }
964         }else if(_betNum <= 50){
965             
966             _smallNum = _betNum - 44;
967             if(_smallNum == _minGameResult){
968                 _realOdds++;
969             }
970             if(_smallNum == _midGameResult){
971                 _realOdds++;
972             }
973             if(_smallNum == _maxGameResult){
974                 _realOdds++;
975             }
976         }
977         return _realOdds;
978     }
979 
980     function () public payable {       
981         if(msg.value > 0){              
982             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);   
983         }
984     }
985 }