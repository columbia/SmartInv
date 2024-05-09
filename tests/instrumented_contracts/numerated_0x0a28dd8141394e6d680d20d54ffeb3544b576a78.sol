1 pragma solidity ^0.4.21;
2 
3 
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         if (a == 0) {
8             return 0;
9         }
10         c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         
17         
18         
19         return a / b;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
28         c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 contract BaseGame {
36     using SafeMath for uint256;
37     
38     string public officialGameUrl;  
39     string public gameName = "SelectOne";    
40     uint public gameType = 3002;               
41 
42     mapping (address => uint256) public userEtherOf;
43     
44     function userRefund() public  returns(bool _result);
45 }
46 
47 contract Base is  BaseGame{
48     uint public createTime = now;
49     address public owner;
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function setOwner(address _newOwner)  public  onlyOwner {
57         owner = _newOwner;
58     }
59 
60     bool public globalLocked = false;     
61 
62     function lock() internal {             
63         require(!globalLocked);
64         globalLocked = true;
65     }
66 
67     function unLock() internal {
68         require(globalLocked);
69         globalLocked = false;
70     }
71 
72     function setLock()  public onlyOwner{
73         globalLocked = false;
74     }
75 
76 
77     uint public currentEventId = 1;
78 
79     function getEventId() internal returns(uint _result) { 
80         _result = currentEventId;
81         currentEventId ++;
82     }
83 
84     function setOfficialGameUrl(string _newOfficialGameUrl) public onlyOwner{
85         officialGameUrl = _newOfficialGameUrl;
86     }
87 }
88 
89 
90 
91 interface IDividendToken{                           
92     function profitOrgPay() payable external ;    
93 }
94 
95 interface IGameToken{                                             
96     function mineToken(address _player, uint256 _etherAmount) external returns (uint _toPlayerToken);
97     function balanceOf(address _owner) constant  external returns (uint256 _balance);
98 }
99 
100 contract Loan is Base{     
101 
102     address public shareholder;               
103 
104     bool public shareholderIsToken = false;
105     bool public isStopPlay = false;
106     uint public stopTime = 0;
107     
108     function setStopPlay(bool _isStopPlay) public onlyOwner
109     {
110         isStopPlay = _isStopPlay;
111         stopTime = now;
112     }
113 
114     function userRefund() public  returns(bool _result) {
115         return _userRefund(msg.sender);
116     }
117 
118     function _userRefund(address _to) internal  returns(bool _result){    
119         require (_to != 0x0);
120         _result = false;
121         lock();
122         uint256 amount = userEtherOf[msg.sender];
123         if(amount > 0){
124             if(msg.sender == shareholder){       
125 		checkPayShareholder();
126             }
127             else{       
128                 userEtherOf[msg.sender] = 0;
129                 _to.transfer(amount);
130             }
131             _result = true;
132         }
133         else{   
134             _result = false;
135         }
136         unLock();
137     }
138 
139     uint256 maxShareholderEther = 20 ether;                                
140 
141     function setMaxShareholderEther(uint256 _value) public onlyOwner {     
142         require(_value >= minBankerEther * 2);
143         require(_value <= minBankerEther * 20);
144         maxShareholderEther = _value;
145     }
146 
147     function autoCheckPayShareholder() internal {                             
148         if (userEtherOf[shareholder] > maxShareholderEther){
149             checkPayShareholder();
150          }
151     }
152 
153     function checkPayShareholder() internal {               
154         uint256 amount = userEtherOf[shareholder];
155         if(currentLoanPerson == 0x0 || checkPayLoan()){       
156             uint256 me = minBankerEther;                    
157             if(isStopPlay){
158                 me = 0;
159             }
160             if(amount >= me){     
161                 uint256 toShareHolder = amount - me;
162                 if(shareholderIsToken){     
163                     IDividendToken token = IDividendToken(shareholder);
164                     token.profitOrgPay.value(toShareHolder)();  
165                 }else{
166                     shareholder.transfer(toShareHolder);
167                 }
168                 userEtherOf[shareholder] = me;
169             }
170         }
171     }
172 
173     ///////////////////////////////////////////////////////////////////////////////////////////////////////////
174 
175     uint256 public gameMaxBetAmount = 0.4 ether;        
176     uint256 public gameMinBetAmount = 0.04 ether;      
177     uint256 public minBankerEther = gameMaxBetAmount * 20;
178 
179     function setMinBankerEther(uint256 _value) public onlyOwner {          
180         require(_value >= gameMinBetAmount *  18 * 1);
181         require(_value <= gameMaxBetAmount *  18 * 10);
182         minBankerEther = _value;
183     }
184 
185     uint256 public currentDayRate10000 = 0;
186     address public currentLoanPerson;       
187     uint256 public currentLoanAmount;       
188     uint public currentLoanDayTime;      
189 
190     function depositEther() public payable
191     {  
192         if (msg.value > 0){
193             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
194         }
195     }
196 
197     event OnBidLoan(bool indexed _success, address indexed _user, uint256 indexed _dayRate10000,  uint256 _etherAmount);
198     event OnPayLoan(address _sender,uint _eventTime,uint256 _toLoan);
199 
200     function bidLoan(uint256 _dayRate10000) public payable returns(bool _result) {      
201         _result = false;
202         require(!isStopPlay);
203         require(msg.sender != shareholder);
204 
205         require(_dayRate10000 < 1000);
206         depositEther();
207         
208         if(checkPayLoan()){
209             emit OnBidLoan(false, msg.sender, _dayRate10000,  0);
210             return;
211         }
212         
213         uint256 toLoan = calLoanAmount();
214         uint256 toGame = 0;
215         if (userEtherOf[shareholder] < minBankerEther){       
216             toGame = minBankerEther.sub(userEtherOf[shareholder]);
217         }
218 
219         if(toLoan > 0 && toGame == 0 && currentLoanPerson != 0x0){                   
220             require(_dayRate10000 < currentDayRate10000);
221         }
222 
223         require(toLoan + toGame > 0);
224         require(userEtherOf[msg.sender] >= toLoan + toGame);
225 
226         userEtherOf[msg.sender] = userEtherOf[msg.sender].sub(toLoan + toGame);
227         userEtherOf[currentLoanPerson] = userEtherOf[currentLoanPerson].add(toLoan);
228         userEtherOf[shareholder] = userEtherOf[shareholder].add(toGame);
229 
230         currentLoanPerson = msg.sender;
231         currentDayRate10000 = _dayRate10000;
232         currentLoanAmount = toLoan + toGame;
233         currentLoanDayTime = now;
234 
235         emit OnBidLoan(false, msg.sender, _dayRate10000,  currentLoanAmount);
236 
237         _result = true;
238         return;
239     }
240 
241     function getCanLoanAmount() public view returns(uint256  _result){                 
242         uint256 toLoan = calLoanAmount();
243 
244         uint256 toGame = 0;
245         if (userEtherOf[shareholder] <= minBankerEther){
246             toGame = minBankerEther - userEtherOf[shareholder];
247             _result =  toLoan + toGame;
248             return;
249         }
250         else if (userEtherOf[shareholder] > minBankerEther){
251             uint256 c = userEtherOf[shareholder] - minBankerEther;
252             if(toLoan > c){
253                 _result =  toLoan - c;
254                 return;
255             }
256             else{
257                 _result =  0;
258                 return;
259             }
260         }
261     }
262 
263     function calLoanAmount() public view returns (uint256 _result){
264       _result = 0;
265       if(currentLoanPerson != 0x0 && currentLoanAmount > 0){
266           _result = currentLoanAmount;
267           uint d = now.sub(currentLoanDayTime).div(1 days);
268           for(uint i = 0; i < d; i++){
269               _result = _result.mul(currentDayRate10000.add(10000)).div(10000);
270           }
271         }
272     }
273 
274 
275     function checkPayLoan() public returns (bool _result) {                        
276         _result = false;
277         uint256 toLoan = calLoanAmount();
278         if(toLoan > 0){
279             if(isStopPlay && now  > stopTime.add(1 days)){         
280                 if(toLoan > userEtherOf[shareholder]){
281                     toLoan = userEtherOf[shareholder];
282                     userEtherOf[currentLoanPerson] = userEtherOf[currentLoanPerson].add(toLoan);
283                     userEtherOf[shareholder] = userEtherOf[shareholder].sub(toLoan);
284                 }
285                 else{
286                     userEtherOf[currentLoanPerson] = userEtherOf[currentLoanPerson].add(toLoan);
287                     userEtherOf[shareholder] = userEtherOf[shareholder].sub(toLoan);
288                 }
289 
290                 currentLoanPerson = 0x0;
291                 currentDayRate10000 = 0;
292                 currentLoanAmount = 0;
293                 currentLoanDayTime = now;
294                 _result = true;
295                 emit OnPayLoan(msg.sender, now, toLoan);
296                 return;
297             }                             
298             if (userEtherOf[shareholder] >= minBankerEther.add(toLoan)){            
299                 userEtherOf[currentLoanPerson] = userEtherOf[currentLoanPerson].add(toLoan);
300                 userEtherOf[shareholder] = userEtherOf[shareholder].sub(toLoan);
301                 currentLoanPerson = 0x0;
302                 currentDayRate10000 = 0;
303                 currentLoanAmount = 0;
304                 currentLoanDayTime = now;
305                 _result = true;
306                 emit OnPayLoan(msg.sender,now,toLoan);
307                 return;
308             }
309         }
310     }
311 }
312 
313 
314 contract SelectOne is Loan
315 {
316   uint public playNo = 1;      
317   uint public constant minNum = 1; 
318   uint public constant maxNum = 22;         
319   uint public constant winMultiplePer = 1800;
320 
321   struct betInfo              
322   {
323     address Player;         
324     uint[] BetNums;
325     uint AwardNum;
326     uint256[] BetAmounts;      
327     uint256 BlockNumber;    
328     uint EventId;           
329     bool IsReturnAward;     
330   }
331   mapping (uint => betInfo) public playerBetInfoOf;               
332   IGameToken public GameToken;
333 
334 
335   //function SelectOne(uint _maxNum, uint256 _gameMinBetAmount,uint256 _gameMaxBetAmount,uint _winMultiplePer,string _gameName,address _gameToken,bool _isToken) public{
336   function SelectOne(uint256 _gameMinBetAmount,uint256 _gameMaxBetAmount, string _gameName,address _gameToken) public{
337     //require(1 < _maxNum);
338     //require(_maxNum < 100);
339     require(_gameMinBetAmount > 0); 
340     require(_gameMaxBetAmount >= _gameMinBetAmount);
341     //require(_winMultiplePer < _maxNum.mul(100));
342     owner = msg.sender;             
343     //maxNum = _maxNum;
344     gameMinBetAmount = _gameMinBetAmount;
345     gameMaxBetAmount = _gameMaxBetAmount;
346     minBankerEther = gameMaxBetAmount * 20;
347     //winMultiplePer = _winMultiplePer;
348     gameName = _gameName;   
349     GameToken = IGameToken(_gameToken);
350     shareholder = _gameToken;
351     shareholderIsToken = true;
352     officialGameUrl='http://select.donquixote.games/';
353   }
354   
355 
356   function tokenOf(address _user) view public returns(uint _result){
357     _result = GameToken.balanceOf(_user);
358   }
359 
360   event OnPlay(address indexed _player, uint[] _betNums,uint256[] _betAmounts,uint256 _giftToken, uint _blockNumber,uint _playNo, uint _eventTime, uint eventId);
361   event OnGetAward(address indexed _player, uint256 _playNo, uint[] _betNums,uint _blockNumber,uint256[] _betAmounts ,uint _eventId,uint _awardNum,uint256 _awardAmount);
362 
363 
364   function play(uint[] _betNums,uint256[] _betAmounts) public  payable returns(bool _result){       
365     _result = false;
366     require(_betNums.length > 0);
367     require(_betNums.length == _betAmounts.length);
368     depositEther();
369     _result = _play(_betNums,_betAmounts);
370   }
371 
372   function _play(uint[] _betNums, uint256[] _betAmounts) private  returns(bool _result){            
373     _result = false;
374     require (!isStopPlay);
375 
376     uint maxBetAmount = 0;
377     uint totalBetAmount = 0;
378     uint8[22] memory betNumOf;                      
379 
380     for(uint i=0;i < _betNums.length;i++){
381       require(_betNums[i] > 0 && _betNums[i] <= maxNum );
382       require(betNumOf[_betNums[i] - 1] == 0);       
383 	  betNumOf[_betNums[i] - 1] = 1;      
384       if(_betAmounts[i] > gameMaxBetAmount){
385         _betAmounts[i] = gameMaxBetAmount;
386       }
387       if(_betAmounts[i] > maxBetAmount){
388         maxBetAmount = _betAmounts[i];
389       }
390       totalBetAmount = totalBetAmount.add(_betAmounts[i]);
391     }
392 
393     uint256 needAmount = maxBetAmount.mul(winMultiplePer).div(100);
394     if(totalBetAmount > needAmount){
395       needAmount = 0;
396     }else{
397       needAmount = needAmount.sub(totalBetAmount);
398     }
399     require(userEtherOf[shareholder] >= needAmount);
400     require(userEtherOf[msg.sender] >= totalBetAmount);
401     lock();
402     betInfo memory bi = betInfo({
403       Player :  msg.sender,              
404       BetNums : _betNums,                       
405       AwardNum : 0,
406       BetAmounts : _betAmounts,                     
407       BlockNumber : block.number,         
408       EventId : currentEventId,           
409       IsReturnAward: false               
410     });
411     playerBetInfoOf[playNo] = bi;
412     userEtherOf[msg.sender] = userEtherOf[msg.sender].sub(totalBetAmount);                  
413     userEtherOf[shareholder] = userEtherOf[shareholder].sub(needAmount);             
414     userEtherOf[this] = userEtherOf[this].add(needAmount).add(totalBetAmount);
415     
416     uint256 _giftToken = GameToken.mineToken(msg.sender,totalBetAmount);
417     emit OnPlay(msg.sender,_betNums,_betAmounts,_giftToken,block.number,playNo,now, getEventId());      
418     playNo++;       
419     _result = true;
420     unLock();
421 	  autoCheckPayShareholder();             
422   }
423 
424   function getAward(uint[] _playNos) public returns(bool _result){
425     require(_playNos.length > 0);
426     _result = false;
427     for(uint i = 0;i < _playNos.length;i++){
428       _result = _getAward(_playNos[i]);
429     }
430   }
431 
432   function _getAward(uint _playNo) private  returns(bool _result){
433     require(_playNo < playNo);       
434     _result = false;        
435     betInfo storage bi = playerBetInfoOf[_playNo];        
436     require(block.number > bi.BlockNumber);
437     require(!bi.IsReturnAward);      
438 
439     lock();
440     uint awardNum = 0;
441     uint256 awardAmount = 0;
442     uint256 totalBetAmount = 0;
443     uint256 maxBetAmount = 0;
444     uint256 totalAmount = 0;
445     for(uint i=0;i <bi.BetNums.length;i++){
446       if(bi.BetAmounts[i] > maxBetAmount){
447         maxBetAmount = bi.BetAmounts[i];
448       }
449       totalBetAmount = totalBetAmount.add(bi.BetAmounts[i]);
450     }
451     totalAmount = maxBetAmount.mul(winMultiplePer).div(100);
452     if(totalBetAmount >= totalAmount){
453       totalAmount = totalBetAmount;
454     }
455     if(bi.BlockNumber.add(256) >= block.number){
456       uint256 randomNum = bi.EventId%1000000;
457       bytes32 encrptyHash = keccak256(bi.Player,block.blockhash(bi.BlockNumber),uintToString(randomNum));
458       awardNum = uint(encrptyHash)%22;
459       awardNum = awardNum.add(1);
460       bi.AwardNum = awardNum;
461       for(uint n=0;n <bi.BetNums.length;n++){
462         if(bi.BetNums[n] == awardNum){
463           awardAmount = bi.BetAmounts[n].mul(winMultiplePer).div(100);
464           bi.IsReturnAward = true;  
465           userEtherOf[this] = userEtherOf[this].sub(totalAmount);
466           userEtherOf[bi.Player] = userEtherOf[bi.Player].add(awardAmount);
467           userEtherOf[shareholder] = userEtherOf[shareholder].add(totalAmount.sub(awardAmount));
468           break;
469         }
470       }
471     }
472     if(!bi.IsReturnAward){
473       bi.IsReturnAward = true;
474       userEtherOf[this] = userEtherOf[this].sub(totalAmount);
475       userEtherOf[shareholder] = userEtherOf[shareholder].add(totalAmount);
476     }
477     emit OnGetAward(bi.Player,_playNo,bi.BetNums,bi.BlockNumber,bi.BetAmounts,getEventId(),awardNum,awardAmount);  
478     _result = true; 
479     unLock();
480   }
481   function getAwardNum(uint _playNo) view public returns(uint _awardNum){
482     betInfo memory bi = playerBetInfoOf[_playNo];
483     if(bi.BlockNumber.add(256) >= block.number){
484       uint256 randomNum = bi.EventId%1000000;
485       bytes32 encrptyHash = keccak256(bi.Player,block.blockhash(bi.BlockNumber),uintToString(randomNum));
486       _awardNum = uint(encrptyHash)%22;
487       _awardNum = _awardNum.add(1);
488     }
489   }
490 
491   function uintToString(uint v) private pure returns (string)    
492   {
493     uint maxlength = 10;                     
494     bytes memory reversed = new bytes(maxlength);
495     uint i = 0;
496     while (v != 0) {
497       uint remainder = v % 10;
498       v = v / 10;
499       reversed[i++] = byte(48 + remainder);
500     }
501     bytes memory s = new bytes(i);          
502     for (uint j = 0; j < i; j++) {
503       s[j] = reversed[i - j - 1];         
504     }
505     string memory str = string(s);         
506     return str;                            
507   }
508 
509   function () public payable {        
510     if(msg.value > 0){
511       userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value);
512     }
513   }
514 
515 }