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
13     return a / b;
14   }
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
20     c = a + b;
21     assert(c >= a);
22     return c;
23   }
24 }
25 
26 interface IDonQuixoteToken{                          
27     function withhold(address _user,  uint256 _amount) external returns (bool _result);  
28     function transfer(address _to, uint256 _value) external;                             
29     function sendGameGift(address _player) external returns (bool _result);              
30     function logPlaying(address _player) external returns (bool _result);               
31     function balanceOf(address _user) constant  external returns (uint256 _balance);
32 } 
33 
34 contract BaseGame {             
35     string public gameName="BigOrSmall";         
36      uint public constant gameType = 2001;   
37     string public officialGameUrl;  
38     mapping (address => uint256) public userTokenOf;     
39     uint public bankerBeginTime;     
40     uint public bankerEndTime;       
41     address public currentBanker;      
42     	
43     function depositToken(uint256 _amount) public;
44     function withdrawToken(uint256 _amount) public;
45 	function withdrawAllToken() public;
46     function setBanker(address _banker, uint256 _beginTime, uint256 _endTime) public returns(bool _result);     
47     function canSetBanker() view public returns (bool _result);         
48 }
49 contract Base is BaseGame { 
50     using SafeMath for uint256;     
51     uint public createTime = now;
52     address public owner;
53 	
54     IDonQuixoteToken public DonQuixoteToken;
55       function Base() public {
56     }
57 	
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 	
63     function setOwner(address _newOwner)  public  onlyOwner {
64          require(_newOwner!= 0x0);
65         owner = _newOwner;
66     }
67         
68     bool public globalLocked = false;     
69 
70     function lock() internal {             
71         require(!globalLocked);
72         globalLocked = true;
73     }
74 
75     function unLock() internal {
76         require(globalLocked);
77         globalLocked = false;
78     }    
79   
80     function setLock()  public onlyOwner{
81         globalLocked = false;     
82     }
83     function tokenOf(address _user) view public returns(uint256 _result){
84         _result = DonQuixoteToken.balanceOf(_user);
85     }
86 	
87     function depositToken(uint256 _amount) public {
88         lock();
89         _depositToken(msg.sender, _amount);
90         unLock();
91     }
92 
93     function _depositToken(address _to, uint256 _amount) internal {         
94         require(_to != 0x0);
95         DonQuixoteToken.withhold(_to, _amount);
96         userTokenOf[_to] = userTokenOf[_to].add(_amount);
97     }
98 
99     function withdrawAllToken() public{    
100         uint256 _amount = userTokenOf[msg.sender];
101         withdrawToken(_amount);
102     }
103 	
104 	function withdrawToken(uint256 _amount) public {    
105         lock();  
106         _withdrawToken(msg.sender, _amount);
107         unLock();
108     }
109 
110     function _withdrawToken(address _to, uint256 _amount) internal {      
111         require(_to != 0x0);
112         userTokenOf[_to] = userTokenOf[_to].sub(_amount);
113         DonQuixoteToken.transfer(_to, _amount);
114     }
115 
116     uint public currentEventId = 1;            
117 
118     function getEventId() internal returns(uint _result) {  
119         _result = currentEventId;
120         currentEventId ++;
121     }
122 
123     function setOfficialGameUrl(string _newOfficialGameUrl) public onlyOwner{
124         officialGameUrl = _newOfficialGameUrl;
125     }
126         
127 }
128 
129 contract SelectOne is Base
130 {    
131     uint public constant minNum = 1;        
132     uint public maxNum = 22;               
133     uint  public winMultiplePer = 90;     
134     
135     uint  public constant maxPlayerNum = 100;      
136     uint public gameTime; 
137     uint256 public gameMaxBetAmount;    
138     uint256 public gameMinBetAmount;    
139 	
140 	function SelectOne(uint _maxNum, uint  _gameTime, uint256 _gameMinBetAmount, uint256 _gameMaxBetAmount,uint _winMultiplePer, string _gameName,address _DonQuixoteToken)  public {
141         require(_gameMinBetAmount >= 0);
142         require(_gameMaxBetAmount > 0);
143         require(_gameMaxBetAmount >= _gameMinBetAmount);
144 		require(_maxNum < 10000);              
145         require(1 < _maxNum);                   
146         require(_winMultiplePer < _maxNum.mul(100));      
147         
148 		gameMinBetAmount = _gameMinBetAmount;
149         gameMaxBetAmount = _gameMaxBetAmount;
150         gameTime = _gameTime;
151         maxNum = _maxNum;                      
152         winMultiplePer = _winMultiplePer;       
153         owner = msg.sender;             
154         gameName = _gameName;           
155 
156         require(_DonQuixoteToken != 0x0);
157         DonQuixoteToken = IDonQuixoteToken(_DonQuixoteToken);
158     }
159 
160     uint public lastBlockNumber = 0;            
161     bool public betInfoIsLocked = false;       
162     address public auction;             
163     
164 
165     function setAuction(address _newAuction) public onlyOwner{
166         require(_newAuction != 0x0);
167         auction = _newAuction;
168     }
169     modifier onlyAuction {             
170         require(msg.sender == auction);
171         _;
172     }
173 
174     function canSetBanker() public view returns (bool _result){
175         _result =  bankerEndTime <= now && gameOver;
176     }
177 	
178     modifier onlyBanker {               
179         require(msg.sender == currentBanker);
180         require(bankerBeginTime <= now);
181         require(now < bankerEndTime);     
182         _;
183     }
184 
185     event OnSetNewBanker(address _caller, address _banker, uint _beginTime, uint _endTime, uint _code, uint _eventTime, uint eventId);
186 
187     function setBanker(address _banker, uint _beginTime, uint _endTime) public onlyAuction returns(bool _result)
188 	{
189         _result = false;
190         require(_banker != 0x0);
191         if(now < bankerEndTime){        
192             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 1, now, getEventId());
193             return;
194         }
195         if(!gameOver){                  
196             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 2, now, getEventId());
197             return;
198         }
199         if(_beginTime > now){               
200             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 3, now, getEventId()); 
201             return;
202         }
203         if(_endTime <= now){
204             emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 4, now, getEventId());
205             return;
206         }
207 	    if(now < donGameGiftLineTime){
208             DonQuixoteToken.logPlaying(_banker);
209         }
210         currentBanker = _banker;
211         bankerBeginTime = _beginTime;
212         bankerEndTime = _endTime;
213         emit OnSetNewBanker(msg.sender, _banker,  _beginTime,  _endTime, 0 , now, getEventId());
214         _result = true;
215     }
216  
217     uint public playNo = 1;             
218     uint public gameID = 0;             
219     uint public gameBeginPlayNo;        
220     uint public gameEndPlayNo;          
221     bytes32 public gameEncryptedText;  
222     uint public gameResult;            
223     string public gameRandon1;          
224     string public constant gameRandon2 = 'ChinasNewGovernmentBracesforTrump';   
225     uint  public gameBeginTime;        
226     uint  public gameEndTime;           
227     bool public gameOver = true;       
228     uint public donGameGiftLineTime = now.add(90 days);  
229     
230 	
231     event OnNewGame(uint _gameID, address _banker, bytes32 _gameEncryptedText, uint  _gameBeginTime,  uint  _gameEndTime, uint _eventTime, uint _eventId);
232 
233     function newGame(bytes32 _gameEncryptedText) public onlyBanker returns(bool _result)               
234     {
235         _result = _newGame( _gameEncryptedText);
236     }
237 
238     function _newGame(bytes32 _gameEncryptedText) private  returns(bool _result)       
239     {
240         _result = false;
241         require(gameOver); 
242         require(bankerBeginTime < now);       
243         require(now.add(gameTime) <= bankerEndTime);    
244         gameID++;                           
245         currentBanker = msg.sender;
246         gameEncryptedText = _gameEncryptedText;
247         gameRandon1 = '';          
248         gameBeginTime = now;                
249         gameEndTime = now.add(gameTime);
250         gameBeginPlayNo = playNo;          
251         gameEndPlayNo = 0;                 
252         gameResult = 0;  
253         gameOver = false;
254         
255         emit OnNewGame(gameID, msg.sender, _gameEncryptedText, now, now.add(gameTime), now, getEventId());
256         _result = true;
257     }
258     
259     struct betInfo              
260     {
261         address Player;
262         uint BetNum;            
263         uint256 BetAmount;      
264         bool IsReturnAward;     
265     }
266 
267     mapping (uint => betInfo) public playerBetInfoOf;              
268     event OnPlay(uint indexed _gameID, address indexed _player, uint _betNum, uint256 _betAmount, uint _playNo, uint _eventTime, uint _eventId);
269 
270     function play(uint _betNum, uint256 _betAmount) public  returns(bool _result){      
271         _result = _play(_betNum, _betAmount);
272     }
273 
274     function _play(uint _betNum, uint256 _betAmount) private  returns(bool _result){            
275         _result = false;
276         require(!gameOver);
277         require(!betInfoIsLocked);                         
278         require(now < gameEndTime);
279         require(playNo.sub(gameBeginPlayNo) <= maxPlayerNum); 
280         require(minNum <= _betNum && _betNum <= maxNum);    
281         require(msg.sender != currentBanker);                
282                    
283         uint256 ba = _betAmount;
284         if (ba > gameMaxBetAmount){                       
285             ba = gameMaxBetAmount;
286         }
287         require(ba >= gameMinBetAmount);                   
288 
289         if(userTokenOf[msg.sender] < ba){                                       
290             depositToken(ba.sub(userTokenOf[msg.sender]));                    
291         }
292         require(userTokenOf[msg.sender] >= ba);             
293        
294         uint256 BankerAmount = ba.mul(winMultiplePer).div(100);                  
295       
296         require(userTokenOf[currentBanker] >= BankerAmount);
297 
298         betInfo memory bi = betInfo({
299                 Player :  msg.sender,
300                 BetNum : _betNum,
301                 BetAmount : ba,
302                 IsReturnAward: false                 
303         });
304 
305         playerBetInfoOf[playNo] = bi;
306         userTokenOf[msg.sender] = userTokenOf[msg.sender].sub(ba);                     
307         userTokenOf[currentBanker] = userTokenOf[currentBanker].sub(BankerAmount);      
308         userTokenOf[this] = userTokenOf[this].add(ba.add(BankerAmount));                
309 
310         emit OnPlay(gameID,  msg.sender,  _betNum,  ba, playNo, now, getEventId());
311 
312         lastBlockNumber = block.number;    
313         playNo++;                          
314 
315         if(now < donGameGiftLineTime){     
316             DonQuixoteToken.logPlaying(msg.sender);           
317         }
318         _result = true;
319     }
320 
321    
322     
323     function lockBetInfo() public onlyBanker returns (bool _result) {                  
324         require(!gameOver);
325         require(now < gameEndTime);
326         require(!betInfoIsLocked);
327         betInfoIsLocked = true;
328         _result = true;
329     }
330 
331     function uint8ToString(uint v) private pure returns (string)    
332     {
333         uint maxlength = 8;                    
334         bytes memory reversed = new bytes(maxlength);
335         uint i = 0;
336         while (v != 0) {
337             uint remainder = v % 10;
338             v = v.div(10);
339             reversed[i++] = byte(remainder.add(48));
340         }
341         bytes memory s = new bytes(i);         
342         for (uint j = 0; j < i; j++) {
343             s[j] = reversed[(i.sub(j)).sub(1)];         
344         }
345         string memory str = string(s);          
346         return str;                             
347     }
348 
349     event OnOpenGameResult(uint indexed _gameID, address _banker, uint _gameResult, string _r1, bool  _result, uint  _code, uint _eventTime, uint eventId);
350 
351     function openGameResult(uint _gameResult, string _r1) public onlyBanker  returns(bool _result){
352         _result =  _openGameResult( _gameResult,  _r1);
353     }
354     
355     function _openGameResult(uint _gameResult, string _r1) private  returns(bool _result){            
356        
357 	   _result = false;
358         require(betInfoIsLocked);          
359         require(!gameOver);
360         require(now <= gameEndTime);       
361 
362         if(lastBlockNumber == block.number){                        
363             emit OnOpenGameResult(gameID, msg.sender, _gameResult, _r1,  false, 2, now, getEventId());         
364             return;
365         }
366 
367         string memory gr = uint8ToString(_gameResult); 
368         if(keccak256(gr, gameRandon2,  _r1) ==  gameEncryptedText){
369             if(_gameResult >= minNum && _gameResult <= maxNum){     
370                 gameResult = _gameResult;
371                 gameRandon1 = _r1;
372                 gameEndPlayNo = playNo.sub(1); 
373                 for(uint i = gameBeginPlayNo; i < playNo; i++){     
374                     betInfo storage p = playerBetInfoOf[i];
375                     if(!p.IsReturnAward){   
376                         p.IsReturnAward = true;
377                         uint256 AllAmount = p.BetAmount.mul(winMultiplePer.add(100)).div(100);    
378                         if(p.BetNum == _gameResult){                                           
379                             userTokenOf[p.Player] = userTokenOf[p.Player].add(AllAmount);     
380                             userTokenOf[this] = userTokenOf[this].sub(AllAmount);               
381                         }else{                                                                  
382                             userTokenOf[currentBanker] = userTokenOf[currentBanker].add(AllAmount);
383                             userTokenOf[this] = userTokenOf[this].sub(AllAmount);               
384                             if(now < donGameGiftLineTime){  
385                                 DonQuixoteToken.sendGameGift(p.Player);                                
386                             } 
387                         }
388                     }
389                 }
390                 gameOver = true;
391                 betInfoIsLocked = false;    
392                 emit OnOpenGameResult(gameID, msg.sender,  _gameResult,  _r1, true, 0, now, getEventId());      
393                 _result = true;
394                 return;
395             }else{       
396                 emit OnOpenGameResult(gameID, msg.sender,  _gameResult,  _r1,  false, 3, now, getEventId()); 
397                 return;                  
398             }
399         }else{           
400             emit OnOpenGameResult(gameID, msg.sender,  _gameResult,  _r1,  false,4, now, getEventId());
401             return;
402         }        
403     }
404 
405     function openGameResultAndNewGame(uint _gameResult, string _r1, bytes32 _gameEncryptedText) public onlyBanker returns(bool _result){
406 		if(gameOver){
407             _result = true ;
408         }else{
409             _result = _openGameResult( _gameResult,  _r1);
410         }
411         if (_result){      
412             _result = _newGame( _gameEncryptedText);
413         }
414     }
415 
416     function noOpenGameResult() public  returns(bool _result){         
417         _result = false;
418         require(!gameOver);       
419         require(gameEndTime < now); 
420         if(lastBlockNumber == block.number){                           
421             emit OnOpenGameResult(gameID, msg.sender,0, '',false, 2, now, getEventId());
422             return;
423         }
424 
425         lock(); 
426 		
427         gameEndPlayNo = playNo - 1;         
428         for(uint i = gameBeginPlayNo; i < playNo; i++){                                
429             betInfo storage p = playerBetInfoOf[i];
430             if(!p.IsReturnAward){           
431                 p.IsReturnAward = true;
432                 uint256 AllAmount = p.BetAmount.mul(winMultiplePer.add(100)).div(100);     
433                 userTokenOf[p.Player] = userTokenOf[p.Player].add(AllAmount);          
434                 userTokenOf[this] = userTokenOf[this].sub(AllAmount);                  
435             }
436         }
437 
438         gameOver = true;
439         if(betInfoIsLocked){
440             betInfoIsLocked = false;    
441         }
442         emit OnOpenGameResult(gameID, msg.sender,   0,  '',  true, 1, now, getEventId());
443         _result = true;
444 
445         unLock();  
446     }
447 
448     function  failUserRefund(uint _playNo) public returns (bool _result) {      
449         _result = false;
450         require(!gameOver);
451         require(gameEndTime.add(30 days) < now);          
452 
453         betInfo storage p = playerBetInfoOf[_playNo];   
454         require(p.Player == msg.sender);               
455         
456         if(!p.IsReturnAward && p.BetNum > 0){            
457             p.IsReturnAward = true;
458             uint256 ToUser = p.BetAmount;   
459             uint256 ToBanker = p.BetAmount.mul(winMultiplePer).div(100);  
460             userTokenOf[this] = userTokenOf[this].sub(ToUser.add(ToBanker));              
461             userTokenOf[p.Player] = userTokenOf[p.Player].add(ToUser);         
462             userTokenOf[currentBanker] = userTokenOf[currentBanker].add(ToBanker);
463             _result = true;                                  
464         }
465     }
466 
467     function transEther() public onlyOwner()    
468     {
469         msg.sender.transfer(address(this).balance);
470     }
471     
472     function () public payable {        
473       
474     }
475 
476 
477 }