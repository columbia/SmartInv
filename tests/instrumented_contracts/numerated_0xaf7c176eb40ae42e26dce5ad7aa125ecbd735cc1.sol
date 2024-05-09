1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     
16    
17    
18     return a / b;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Base {
34     using SafeMath for uint256;
35     uint public createTime = now;
36     address public owner;
37     address public ownerAdmin;
38 
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43    
44     function setOwner(address _newOwner)  public {
45         require(msg.sender  == ownerAdmin);
46         owner = _newOwner;
47     }
48 
49     bool public globalLocked = false;       
50 
51     function lock() internal {             
52         require(!globalLocked);
53         globalLocked = true;
54     }
55 
56     function unLock() internal {
57         require(globalLocked);
58         globalLocked = false;
59     }
60 
61     function setLock()  public onlyOwner{
62         globalLocked = false;
63     }
64 
65     mapping (address => uint256) public userEtherOf;
66 
67     function userRefund() public  returns(bool _result) {             
68         return _userRefund(msg.sender);
69     }
70 
71     function _userRefund(address _to) internal returns(bool _result){  
72         require (_to != 0x0);
73         lock();
74         uint256 amount = userEtherOf[msg.sender];
75         if(amount > 0){
76             userEtherOf[msg.sender] = 0;
77             _to.transfer(amount);
78             _result = true;
79         }
80         else{
81             _result = false;
82         }
83         unLock();
84     }
85 
86     uint public currentEventId = 1;                             
87 
88     function getEventId() internal returns(uint _result) {      
89         _result = currentEventId;
90         currentEventId ++;
91     }
92 
93 }
94 
95 
96 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
97 
98 contract TokenERC20 is Base {                                               
99     string public name = 'Don Quixote Token';                              
100     string public symbol = 'DON';
101     uint8 public decimals = 9;
102          
103     uint256 public totalSupply = 0;
104     mapping (address => uint256) public balanceOf;
105     mapping (address => mapping (address => uint256)) public allowance;
106     event Transfer(address indexed from, address indexed to, uint256 value);
107     event Burn(address indexed from, uint256 value);
108 
109     function _callDividend(address _user) internal returns (bool _result);      
110 
111     function _transfer(address _from, address _to, uint256 _value) internal {
112         require(_from != 0x0);
113         require(_to != 0x0);
114         require(_from != _to);
115         require(_value > 0);
116         require(balanceOf[_from] >= _value);
117         require(balanceOf[_to].add(_value) >= balanceOf[_to]);
118 
119         _callDividend(_from);   
120         _callDividend(_to);     
121 
122         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
123         balanceOf[_from] = balanceOf[_from].sub(_value);
124         balanceOf[_to] = balanceOf[_to].add(_value);
125         emit Transfer(_from, _to, _value);
126         assert(balanceOf[_from].add( balanceOf[_to]) == previousBalances);
127     }
128 
129     function transfer(address _to, uint256 _value) public {
130         require(_to != 0x0);
131         require(_value > 0);
132         _transfer(msg.sender, _to, _value);
133     }
134 
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
136         require(_from != 0x0);
137         require(_to != 0x0);
138         require(_value > 0);
139         require(_value <= allowance[_from][msg.sender]);    
140         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
141         _transfer(_from, _to, _value);
142         return true;
143     }
144 
145     function approve(address _spender, uint256 _value) public returns (bool success) {
146         require(_spender != 0x0);
147         require(_value > 0);
148                
149         allowance[msg.sender][_spender] = _value;
150         return true;
151     }
152 
153     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
154         require(_spender != 0x0);
155         require(_value > 0);
156         tokenRecipient spender = tokenRecipient(_spender);
157         if (approve(_spender, _value)) {
158             spender.receiveApproval(msg.sender, _value, this, _extraData);
159             return true;
160         }
161     }
162 
163     function burn(uint256 _value) public returns (bool success) {           
164         require(_value > 0);
165         require(balanceOf[msg.sender] >= _value);
166 
167         _callDividend(msg.sender);                
168 
169         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
170         totalSupply = totalSupply.sub(_value);
171         emit Burn(msg.sender, _value);
172         return true;
173     }
174 
175     function burnFrom(address _from, uint256 _value) public returns (bool success) {       
176         require(_from != 0x0);
177         require(_value > 0);
178         assert(1 >= 2);
179         symbol = 'DON';
180         return false;
181     }
182 }
183 
184 interface IWithholdToken{          
185     function withhold(address _user,  uint256 _amount) external returns (bool _result);
186     function setGameTransferFlag(address _gameAddress, bool _gameCanTransfer) external;
187 }
188 
189 contract WithholdToken is TokenERC20, IWithholdToken{          
190 
191     mapping (address=>mapping(address=>bool)) public gameTransferFlagOf;                    
192 
193     function setGameTransferFlag(address _gameAddress, bool _gameCanTransfer) external {    
194         require(_gameAddress != 0x0);
195         gameTransferFlagOf[msg.sender][_gameAddress] = _gameCanTransfer;
196     }
197 
198     mapping(address => bool) public gameWhiteListOf;                                       
199 
200     event OnWhiteListChange(address indexed _gameAddr, address _operator, bool _result,  uint _eventTime, uint _eventId);
201 
202     function addWhiteList(address _gameAddr) public onlyOwner {
203         require (_gameAddr != 0x0);
204         gameWhiteListOf[_gameAddr] = true;
205         emit OnWhiteListChange(_gameAddr, msg.sender, true, now, getEventId());
206     }
207 
208     function delWhiteList(address _gameAddr) public onlyOwner {
209         require (_gameAddr != 0x0);
210         gameWhiteListOf[_gameAddr] = false;
211         emit OnWhiteListChange(_gameAddr, msg.sender, false, now, getEventId());
212     }
213 
214     function isWhiteList(address _gameAddr) public view returns(bool _result) {    
215         require (_gameAddr != 0x0);
216         _result = gameWhiteListOf[_gameAddr];
217     }
218    
219     function withhold(address _user,  uint256 _amount) external returns (bool _result) {
220         require(_user != 0x0);
221         require(_amount > 0);
222         require(msg.sender != tx.origin);
223        
224         require(gameTransferFlagOf[_user][msg.sender]);        
225         require(isWhiteList(msg.sender));
226         require(balanceOf[_user] >= _amount);
227         
228         _transfer(_user, msg.sender, _amount);
229         
230         return true;
231     }
232    
233 }
234 
235 interface IProfitOrg {                                                   
236     function userRefund() external returns(bool _result);               
237     function shareholder() constant external returns (address);        
238                           
239 }
240 
241 interface IDividendToken{                           
242     function profitOrgPay() payable external;       
243 }
244 
245 contract DividendToken is WithholdToken, IDividendToken{             
246 
247     address public iniOwner;
248 
249     struct DividendPeriod                          
250     {
251         uint StartTime;
252         uint EndTime;
253         uint256 TotalEtherAmount;
254         uint256 ShareEtherAmount;
255     }
256 
257     mapping (uint => DividendPeriod) public dividendPeriodOf;   
258     uint256 public currentDividendPeriodNo = 0;                 
259 
260     uint256 public shareAddEtherValue = 0;      
261     uint256 public addTotalEtherValue = 0;      
262 
263     uint public lastDividendTime = now;         
264 
265     mapping (address => uint) public balanceTimeOf;     
266 
267     uint256 public minDividendEtherAmount = 1 ether;    
268     function setMinDividendEtherAmount(uint256 _newMinDividendEtherAmount) public onlyOwner{
269         minDividendEtherAmount = _newMinDividendEtherAmount;
270     }
271 
272     function callDividend() public returns (uint256 _etherAmount) {             
273         _callDividend(msg.sender);
274         _etherAmount = userEtherOf[msg.sender];
275         return;
276     }
277 
278     event OnCallDividend(address indexed _user, uint256 _tokenAmount, uint _lastCalTime, uint _etherAmount, uint _eventTime, uint _eventId);
279 
280     function _callDividend(address _user) internal returns (bool _result) {    
281         uint _amount = 0;
282         uint lastTime = balanceTimeOf[_user];
283         uint256 tokenNumber = balanceOf[_user];                                 
284         if(tokenNumber <= 0)
285         {
286             balanceTimeOf[_user] = now;
287             _result = false;
288             return;
289         }
290         if(currentDividendPeriodNo == 0){ 
291         	_result = false;
292             return;
293         }
294         for(uint256 i = currentDividendPeriodNo-1; i >= 0; i--){
295             DividendPeriod memory dp = dividendPeriodOf[i];
296             if(lastTime < dp.EndTime){
297                 _amount = _amount.add(dp.ShareEtherAmount.mul(tokenNumber));
298             }else if (lastTime >= dp.EndTime){
299                 break;
300             }
301         }
302         balanceTimeOf[_user] = now;
303         if(_amount > 0){
304             userEtherOf[_user] = userEtherOf[_user].add(_amount);          
305             
306         }
307 
308         emit OnCallDividend(_user, tokenNumber, lastTime, _amount, now, getEventId());
309         _result = true;
310         return;
311     }
312 
313     function saveDividendPeriod(uint256 _ShareEtherAmount, uint256 _TotalEtherAmount) internal {    
314         DividendPeriod storage dp = dividendPeriodOf[currentDividendPeriodNo];
315         dp.ShareEtherAmount = _ShareEtherAmount;
316         dp.TotalEtherAmount = _TotalEtherAmount;
317         dp.EndTime = now;
318         dividendPeriodOf[currentDividendPeriodNo] = dp;
319     }
320 
321     function newDividendPeriod(uint _StartTime) internal {
322         DividendPeriod memory newdp = DividendPeriod({
323                 StartTime :  _StartTime,
324                 EndTime : 0,
325                 TotalEtherAmount : 0,
326                 ShareEtherAmount : 0
327         });
328 
329         currentDividendPeriodNo++;
330         dividendPeriodOf[currentDividendPeriodNo] = newdp;
331     }
332 
333     function callDividendAndUserRefund() public {   
334         callDividend();
335         userRefund();
336     }
337     
338     function getProfit(address _profitOrg) public {     
339         lock();
340         IProfitOrg pt = IProfitOrg(_profitOrg);
341         address sh = pt.shareholder();
342         if(sh == address(this))     
343         {
344             pt.userRefund();       
345         }
346         unLock();
347     }
348 
349     event OnProfitOrgPay(address _profitOrg, uint256 _sendAmount, uint256 _divAmount, uint256 _shareAmount, uint _eventTime, uint _eventId);
350 
351     uint public divIntervalDays = 1 days; 
352 
353     function  setDivIntervalDays(uint _days) public onlyOwner {
354         require(_days >= 1 && _days <= 30);
355         divIntervalDays = _days * (1 days);
356     }
357 
358     function profitOrgPay() payable external {        
359              
360         if (msg.value > 0){
361             userEtherOf[this] += msg.value;         
362             addTotalEtherValue += msg.value;
363             shareAddEtherValue += msg.value /  totalSupply;
364 
365             uint256 canValue = userEtherOf[this];
366             if(canValue < minDividendEtherAmount || now - lastDividendTime < divIntervalDays)   
367             {
368                 emit OnProfitOrgPay(msg.sender, msg.value, 0, 0, now, getEventId());
369                 return;
370             }
371 
372             uint256 sa = canValue .div(totalSupply);        
373             if(sa <= 0){
374                 emit OnProfitOrgPay(msg.sender, msg.value, 0, 0, now, getEventId());
375                 return;                                     
376             }
377 
378             uint256 totalEtherAmount = sa.mul(totalSupply);        
379             saveDividendPeriod(sa, totalEtherAmount);
380             newDividendPeriod(now);
381             userEtherOf[this] = userEtherOf[this].sub(totalEtherAmount);
382             emit OnProfitOrgPay(msg.sender, msg.value, totalEtherAmount, sa, now, getEventId());
383             lastDividendTime = now;
384             return;
385         }
386     }
387 
388     event OnFreeLostToken(address _lostUser, uint256 _tokenNum, uint256 _etherNum, address _to, uint _eventTime, uint _eventId);
389 
390     function freeLostToken(address _user) public onlyOwner {          
391         require(_user != 0x0);
392         uint addTime = 10 * 365 days;   
393             
394         require(balanceOf[_user] > 0 && createTime.add(addTime) < now  && balanceTimeOf[_user].add(addTime) < now);     
395 	    require(_user != msg.sender && _user != iniOwner);
396 
397         uint256 ba = balanceOf[_user];                
398         require(ba > 0);
399         _callDividend(_user);                          
400         _callDividend(msg.sender);                    
401         _callDividend(iniOwner);                        
402 
403         balanceOf[_user] -= ba;
404         balanceOf[msg.sender] = balanceOf[msg.sender].add( ba / 2);
405         balanceOf[iniOwner] = balanceOf[iniOwner].add(ba - (ba / 2));
406 
407         uint256 amount = userEtherOf[_user];       
408         if (amount > 0){
409             userEtherOf[_user] = userEtherOf[_user].sub(amount);
410             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(amount / 2);
411             userEtherOf[iniOwner] = userEtherOf[iniOwner].add(amount - (amount / 2));
412         }
413 
414         emit OnFreeLostToken(_user, ba, amount, msg.sender, now, getEventId());
415     }
416 
417 }
418 
419 contract ReferrerToken is DividendToken{                
420 
421     mapping(address => address) playerReferrerOf;       
422 
423     uint256 public refRewardL1Per100 = 30;             
424    
425     function setRefRewardPer100(uint256 _value1) public onlyOwner{
426         require(_value1 <= 50);
427         refRewardL1Per100 = _value1;
428     }
429 
430     bool public referrerEnable = true;          
431 
432     function setreferrerEnable(bool _enable) public onlyOwner{
433         referrerEnable = _enable;
434     }
435 
436     event OnAddPlayer(address _player, address _referrer, uint _eventTime, uint _eventId);
437 
438     function addPlayer(address _player, address _referrer) public returns (bool _result){
439         _result = false;
440         require(_player != 0x0);
441         require(_referrer != 0x0);
442         require(referrerEnable);
443 
444         if(balanceOf[_player] != 0){
445             return;
446         }
447 
448         if(balanceOf[_referrer] == 0){
449             return;
450         }
451 
452         if(playerReferrerOf[_player] == 0x0){
453             playerReferrerOf[_player] = _referrer;
454             emit OnAddPlayer(_player, _referrer, now, getEventId());
455             _result = true;
456         }
457     }
458 
459     function addPlayer1(address _player) public returns (bool _result){
460         _result = addPlayer(_player, msg.sender);
461     }
462 
463     function addPlayer2(address[] _players) public returns (uint _result){
464         _result = 0;
465         for(uint i = 0; i < _players.length; i++){
466             if(addPlayer(_players[i], msg.sender)){
467                 _result++;
468             }
469         }
470     }
471 
472     function addPlayer3(address[] _players, address _referrer) public returns (uint _result){
473         _result = 0;
474         for(uint i = 0; i < _players.length; i++){
475             if(addPlayer(_players[i], _referrer)){
476                 _result++;
477             }
478         }
479     }
480 
481     function getReferrer1(address _player) public view returns (address _result){           
482         _result = playerReferrerOf[_player];
483     }
484 
485 }
486 
487 interface IGameToken{                                                                      
488    function mineToken(address _player, uint256 _etherAmount) external returns (uint _toPlayerToken);
489 }
490 
491 contract GameToken is ReferrerToken, IGameToken{        
492 
493     address public boss;
494     address public bossAdmin;
495     function setBoss(address _newBoss) public{
496         require(msg.sender == bossAdmin);
497         boss = _newBoss;
498     }
499 
500     function GameToken(address _ownerAdmin, address _boss, address _bossAdmin)  public {
501         require(_ownerAdmin != 0x0);
502         require(_boss != 0x0);
503         require(_bossAdmin != 0x0);
504 
505         owner = msg.sender;
506         iniOwner = msg.sender;
507         ownerAdmin = _ownerAdmin;
508 
509         boss = _boss;
510         bossAdmin = _bossAdmin;
511 
512         totalSupply = 0;                             
513         balanceOf[msg.sender] = totalSupply;           
514     }
515 
516     event OnAddYearToken(uint256 _lastTotalSupply, uint256 _currentTotalSupply, uint _years, uint _eventTime, uint _eventId);
517 
518     mapping(uint => uint256) yearTotalSupplyOf;
519 
520     function addYearToken() public returns(bool _result) {                      
521         _result = false;
522         uint y = (now - createTime) / (365 days);
523         if (y > 0 && yearTotalSupplyOf[y] == 0){
524             _callDividend(iniOwner);    
525 
526             uint256 _lastTotalSupply = totalSupply;
527             totalSupply = totalSupply.mul(102).div(100);                                 
528             uint256 _add = totalSupply.sub(_lastTotalSupply);
529             balanceOf[iniOwner] = balanceOf[iniOwner].add(_add);
530             yearTotalSupplyOf[y] = totalSupply;
531 
532             emit OnAddYearToken(_lastTotalSupply, totalSupply, y, now, getEventId());
533         }
534     }
535 
536     uint256 public baseMineTokenAmount = 1000 * (10 ** uint256(decimals));   
537 
538     uint256 public currentMineTokenAmount   = baseMineTokenAmount;
539     uint    public currentMideTokenTime     = now;
540 
541     function getMineTokenAmount() public returns (uint256 _result){            
542         _result = 0;
543 
544         if (currentMineTokenAmount == 0){
545             _result = currentMineTokenAmount;
546             return;
547         }
548 
549         if(now <= 1 days + currentMideTokenTime){
550             _result = currentMineTokenAmount;
551             return;
552         }
553 
554         currentMineTokenAmount = currentMineTokenAmount * 996 / 1000;
555         if(currentMineTokenAmount <= 10 ** uint256(decimals)){
556             currentMineTokenAmount = 0;
557         }
558         currentMideTokenTime = now;
559 
560         _result = currentMineTokenAmount;
561         return;
562     }
563     
564     event OnMineToken(address indexed _game, address indexed _player, uint256 _toUser, uint256 _toOwner, uint256 _toBosss, uint256 _toSupper, uint _eventTime, uint _eventId);
565 
566     function mineToken(address _player, uint256 _etherAmount) external returns (uint _toPlayerToken) {
567         _toPlayerToken = _mineToken(_player, _etherAmount);
568     }
569 
570     function _mineToken(address _player, uint256 _etherAmount) private returns (uint _toPlayerToken) {
571         require(_player != 0x0);
572         require(isWhiteList(msg.sender));   
573         require(msg.sender != tx.origin);   
574         require(_etherAmount > 0);
575 
576         uint256 te = getMineTokenAmount();
577         if (te == 0){
578             return;
579         }
580 
581         uint256 ToUser = te .mul(_etherAmount).div(1 ether);
582         if (ToUser > 0){
583             _callDividend(_player);
584             _callDividend(owner);
585             _callDividend(boss);
586 
587             balanceOf[_player] = balanceOf[_player].add(ToUser);
588 
589             uint256 ToSupper = 0;
590             if(referrerEnable){
591                 address supper = getReferrer1(_player);
592                 if (supper != 0x0){
593                     _callDividend(supper);
594                     ToSupper = ToUser * refRewardL1Per100 / 100;
595                     balanceOf[supper] = balanceOf[supper].add(ToSupper);
596                 }
597             }
598 
599             uint256 ToUS = ToUser.add(ToSupper);
600             uint256 ToOwner = ToUS.div(8);
601             balanceOf[owner] = balanceOf[owner].add(ToOwner);
602             uint256 ToBoss = ToUS.div(8);
603             balanceOf[boss] = balanceOf[boss].add(ToBoss);
604 
605             totalSupply = totalSupply.add(ToUS.add(ToOwner.add(ToBoss)));
606 
607             emit OnMineToken(msg.sender,  _player, ToUser, ToOwner, ToBoss, ToSupper, now, getEventId());
608         }
609         _toPlayerToken = ToUser;
610     }
611 
612     function () public payable {                            
613         if (msg.value > 0){
614             userEtherOf[msg.sender] += msg.value;
615         }
616     }
617 
618 }