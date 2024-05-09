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
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     // uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return a / b;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Base { 
33     using SafeMath for uint256; 
34     uint public createTime = now;
35     address public owner;
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function setOwner(address _newOwner)  public  onlyOwner {
43         owner = _newOwner;
44     }    
45             
46     bool public globalLocked = false;     
47 
48     function lock() internal {         
49         require(!globalLocked);
50         globalLocked = true;
51     }
52 
53     function unLock() internal {
54         require(globalLocked);
55         globalLocked = false;
56     }    
57 
58     function setLock()  public onlyOwner{      
59         globalLocked = false;     
60     }
61 
62     mapping (address => uint256) public userEtherOf;    
63     
64     function userRefund() public  returns(bool _result) {             
65         return _userRefund(msg.sender);
66     }
67 
68     function _userRefund(address _to) internal returns(bool _result){  
69         require (_to != 0x0);  
70         lock();
71         uint256 amount = userEtherOf[msg.sender];   
72         if(amount > 0){
73             userEtherOf[msg.sender] = 0;
74             _to.transfer(amount); 
75             _result = true;
76         }
77         else{
78             _result = false;
79         }
80         unLock();
81     }
82 
83     uint public currentEventId = 1;                         
84 
85     function getEventId() internal returns(uint _result) {    
86         _result = currentEventId;
87         currentEventId ++;
88     }
89    
90 }
91 
92 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
93 
94 contract TokenERC20 is Base {                                             
95     string public name = 'Don Quixote Token';                           
96     string public symbol = 'DON';
97     uint8 public decimals = 9;
98     uint256 public totalSupply = (10 ** 9) * (10 ** uint256(decimals));    
99     mapping (address => uint256) public balanceOf;
100     mapping (address => mapping (address => uint256)) public allowance;
101     event Transfer(address indexed from, address indexed to, uint256 value);
102     event Burn(address indexed from, uint256 value);
103 
104  
105     function webGiftUnTransfer(address _from, address _to) public view returns(bool _result);   
106 
107     function _transfer(address _from, address _to, uint256 _value) internal {
108         require(_from != 0x0);
109         require(_to != 0x0);
110         require(_value > 0);
111         require(balanceOf[_from] >= _value);
112         require(balanceOf[_to].add(_value) >= balanceOf[_to]);
113 
114         require(_from != _to);
115         require(!webGiftUnTransfer(_from, _to));                                         
116 
117         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
118         balanceOf[_from] = balanceOf[_from].sub(_value);
119         balanceOf[_to] = balanceOf[_to].add(_value);
120         emit Transfer(_from, _to, _value);
121         assert(balanceOf[_from].add( balanceOf[_to]) == previousBalances);
122     }
123 
124     function transfer(address _to, uint256 _value) public {
125         _transfer(msg.sender, _to, _value);
126     }
127 
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
129         require(_from != 0x0);
130         require(_to != 0x0);
131         require(_value > 0);
132         require(_value <= allowance[_from][msg.sender]);    
133         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
134         _transfer(_from, _to, _value);
135         return true;
136     }
137 
138     function approve(address _spender, uint256 _value) public returns (bool success) {  
139         require(_spender != 0x0);
140         require(_value > 0);
141         //require(_value <= balanceOf[msg.sender]);         
142         allowance[msg.sender][_spender] = _value;
143         return true;
144     }
145 
146     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
147         require(_spender != 0x0);
148         require(_value > 0);
149         tokenRecipient spender = tokenRecipient(_spender);
150         if (approve(_spender, _value)) {
151             spender.receiveApproval(msg.sender, _value, this, _extraData);
152             return true;
153         }
154     }
155 
156     function burn(uint256 _value) public returns (bool success) {           
157         require(_value > 0);
158         require(balanceOf[msg.sender] >= _value);  
159         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); 
160         totalSupply = totalSupply.sub(_value);   
161         emit Burn(msg.sender, _value);
162         return true;
163     }
164 
165     function burnFrom(address _from, uint256 _value) public returns (bool success) {
166         require(_from != 0x0);
167         require(_value > 0);
168         assert(1 >= 2);
169         symbol = 'DON';
170         return false;
171     }
172 }
173 
174 contract DonQuixoteToken is TokenERC20{          
175     address public iniOwner;                      
176 
177     function DonQuixoteToken(address _santaClaus)  public {
178         require(_santaClaus != 0x0 && _santaClaus != msg.sender);
179         owner = msg.sender;
180         iniOwner = msg.sender;
181         balanceOf[msg.sender] = totalSupply; 
182         santaClaus = _santaClaus;
183     }
184 
185     uint public lastAddYear = now;
186 
187     event OnAddYearToken(uint256 _lastTotalSupply, uint256 _currentTotalSupply, uint _years, uint _eventTime, uint _eventId);
188 
189     function addYearToken() public returns(bool _result) {   
190         _result = false;
191         if(now - lastAddYear > 1 years){
192             uint256 _lastTotalSupply = totalSupply;
193             uint y = (now - lastAddYear).div(1 years);  
194             if(y > 0){
195                 for(uint i = 1; i <= y; i++){
196                     totalSupply = totalSupply.mul(102).div(100);       
197                 }
198                 uint256 _add = totalSupply.sub(_lastTotalSupply);
199                 balanceOf[iniOwner] = balanceOf[iniOwner].add(_add);
200                 lastAddYear = lastAddYear.add(y.mul(1 years));
201                 emit OnAddYearToken(_lastTotalSupply, totalSupply, y, now, getEventId());
202                 _result = true;
203             }
204         }
205     }
206 
207     address public santaClaus;                         
208 
209     function setSantaClaus(address _newSantaClaus)  public  onlyOwner {  
210         require(_newSantaClaus != 0x0);
211         santaClaus = _newSantaClaus;
212     }
213 
214     modifier onlySantaClaus {
215         require(msg.sender == santaClaus);
216         _;
217     }
218 
219     uint    public webGiftLineTime = now + 60 days;
220     uint256 public webGiftTotalAmount = totalSupply * 5 / 100;  
221     uint256 public webGiftSentAmount  = 0;                       
222     uint256 public webGiftOnceMaxAmount = 600 * (10 ** uint256(decimals));  
223     uint256 public webGiftEtherAmount = 0.005 ether;                      
224     bool    public stopSendWebGift  = false;
225 
226     function setWebGiftEtherAmount(uint256 _value) public onlyOwner{
227         require(_value <= 0.1 ether);
228         webGiftEtherAmount = _value;
229     }
230 
231     function setStopSendWebGift(bool _value) public onlyOwner{
232         stopSendWebGift = _value;
233     }
234 
235     function canSendWebGift() public view returns (bool _result){
236         _result = (now < webGiftLineTime) && (!stopSendWebGift) && (webGiftSentAmount <= webGiftTotalAmount) && (balanceOf[iniOwner] >= webGiftOnceMaxAmount);
237     }
238 
239     function canSendWebGifAmount() public view returns(uint256 _result) {     
240         _result = 0;
241         if(canSendWebGift()){
242             _result = webGiftTotalAmount.sub(webGiftSentAmount);  
243         }
244     }
245 
246     function setWebGiftOnceMaxAmount(uint256 _value) public onlyOwner{
247         require(_value < 1000 * (10 ** uint256(decimals)) && _value > 0);   
248         webGiftOnceMaxAmount = _value;
249     }    
250 
251     event OnSendWebGiftToken(address _user, uint256 _gifTokenAmount, bool _result, uint _eventTime, uint _eventId);
252 
253     function sendWebGiftToken(address _user, uint256 _gifAmount) public onlySantaClaus returns(bool _result)  {
254         lock();   
255         _result = _sendWebGiftToken( _user,  _gifAmount);
256         unLock();
257     }
258 
259     function _sendWebGiftToken(address _user, uint256 _gifAmount) private returns(bool _result)  { 
260         _result = false;
261         require(_user != 0x0);
262         require(_gifAmount > 0);
263         require(_user != iniOwner);                              
264         require(_gifAmount <= webGiftOnceMaxAmount);
265         require(canSendWebGifAmount() >= _gifAmount);    
266         _transfer(iniOwner, _user, _gifAmount);
267         webGiftSentAmount = webGiftSentAmount.add(_gifAmount);
268         
269         _logSendWebGiftAndSendEther(_user, _gifAmount);
270 
271         _result = true;
272         emit OnSendWebGiftToken(_user, _gifAmount, _result, now,  getEventId());
273     }
274 
275     function batchSendWebGiftToken(address[] _users, uint256 _gifAmount) public  onlySantaClaus returns(uint _result)  {
276         lock();   
277         _result = 0;
278         for (uint index = 0; index < _users.length; index++) {
279             address _user =  _users[index];
280             if(_sendWebGiftToken(_user, _gifAmount)){
281                 _result = _result.add(1);
282             } 
283         }
284         unLock();
285     }
286 
287     mapping (address=>mapping(address=>bool)) public gameTransferFlagOf;   
288 
289     function setGameTransferFlag(address _gameAddress, bool _gameCanTransfer) public { 
290         require(_gameAddress != 0x0);
291         gameTransferFlagOf[msg.sender][_gameAddress] = !_gameCanTransfer;
292     }
293 
294     mapping(address => bool) public gameWhiteListOf;                           
295 
296     event OnWhiteListChange(address indexed _gameAddr, address _operator, bool _result,  uint _eventTime, uint _eventId);
297 
298     function addWhiteList(address _gameAddr) public onlyOwner {
299         require (_gameAddr != 0x0);  
300         gameWhiteListOf[_gameAddr] = true;
301         emit OnWhiteListChange(_gameAddr, msg.sender, true, now, getEventId());
302     }  
303 
304     function delWhiteList(address _gameAddr) public onlyOwner {
305         require (_gameAddr != 0x0);  
306         gameWhiteListOf[_gameAddr] = false;   
307         emit OnWhiteListChange(_gameAddr, msg.sender, false, now, getEventId()); 
308     }
309     
310     function isWhiteList(address _gameAddr) private view returns(bool _result) {
311         require (_gameAddr != 0x0);  
312         _result = gameWhiteListOf[_gameAddr];
313     }
314 
315     function withhold(address _user,  uint256 _amount) public returns (bool _result) {    
316         require(_user != 0x0);
317         require(_amount > 0);
318         require(msg.sender != tx.origin);
319         require(!gameTransferFlagOf[_user][msg.sender]);
320         require(isWhiteList(msg.sender));
321         require(balanceOf[_user] >= _amount);
322         
323         //lock();     
324         _transfer(_user, msg.sender, _amount);
325         //unLock();
326         return true;
327     }
328 
329 
330     uint    public gameGiftLineTime = now + 90 days;  
331     uint256 public gameGiftMaxAmount  = totalSupply * 5 / 100; 
332     uint256 public gameGiftSentAmount  = 0;                      
333     uint256 public gameGiftOnceAmount  = 60 * (10 ** uint256(decimals));   
334     uint    public gameGiftUserTotalTimes = 100;            
335     uint    public gameGiftUserDayTimes = 20;                         
336     
337     struct gameGiftInfo     
338     {
339         uint ThisDay;       
340         uint DayTimes;     
341         uint TotalTimes;  
342     }
343 
344     mapping(address => gameGiftInfo) public gameGiftInfoList;   
345 
346     function _logGameGiftInfo(address _player) private {
347         gameGiftInfo storage ggi = gameGiftInfoList[_player];
348         uint thisDay = now / (1 days);
349         if (ggi.ThisDay == thisDay){
350             ggi.DayTimes = ggi.DayTimes.add(1);
351         }
352         else
353         {
354             ggi.ThisDay = thisDay;
355             ggi.DayTimes = 1;
356         }
357         ggi.TotalTimes = ggi.TotalTimes.add(1);
358     }
359 
360     function timesIsOver(address _player) public view returns(bool _result){ 
361         gameGiftInfo storage ggi = gameGiftInfoList[_player];
362         uint thisDay = now / (1 days);
363         if (ggi.ThisDay == thisDay){
364             _result = (ggi.DayTimes >= gameGiftUserDayTimes) || (ggi.TotalTimes >= gameGiftUserTotalTimes);
365         }
366         else{
367             _result = ggi.TotalTimes >= gameGiftUserTotalTimes;
368         }
369     }
370 
371     function setGameGiftOnceAmount(uint256 _value) public onlyOwner{
372         require(_value > 0 && _value < 100 * (10 ** uint256(decimals)));
373         gameGiftOnceAmount = _value;
374     }
375 
376     function gameGifIsOver() view public returns(bool _result){
377         _result = (gameGiftLineTime <= now) || (balanceOf[iniOwner] < gameGiftOnceAmount) || (gameGiftMaxAmount < gameGiftSentAmount.add(gameGiftOnceAmount));    
378     }  
379 
380     event OnSendGameGift(address _game, address _player, uint256 _gameGiftOnceAmount, uint _eventTime, uint _eventId);
381     
382     function _canSendGameGift() view private returns(bool _result){
383         _result = (isWhiteList(msg.sender)) && (!gameGifIsOver());
384     }
385 
386     function sendGameGift(address _player) public returns (bool _result) {
387         uint256 _tokenAmount = gameGiftOnceAmount;
388         _result = _sendGameGift(_player, _tokenAmount);
389     }
390 
391     function sendGameGift2(address _player, uint256 _tokenAmount) public returns (bool _result) {
392         require(gameGiftOnceAmount >= _tokenAmount);
393         _result = _sendGameGift(_player, _tokenAmount);
394     }
395 
396     function _sendGameGift(address _player, uint256 _tokenAmount) private returns (bool _result) {
397         require(_player != 0x0);
398         require(_tokenAmount > 0 && _tokenAmount <= gameGiftOnceAmount);
399         
400         if(_player == iniOwner){ 
401             return;
402         }                                 
403 
404         require(msg.sender != tx.origin);
405         if(!_canSendGameGift()){   
406             return;
407         }
408         if(timesIsOver(_player)){ 
409             return;
410         }
411 
412         lock();         
413         _transfer(iniOwner, _player, _tokenAmount);
414         gameGiftSentAmount = gameGiftSentAmount.add(_tokenAmount);
415         emit OnSendGameGift(msg.sender,  _player,   _tokenAmount, now, getEventId());
416         _logGameGiftInfo(_player);    
417         unLock();
418         _result = true;
419     }
420 
421 
422     uint256  public baseIcoPrice =  (0.0002 ether) / (10 ** uint256(decimals)); 
423   
424     function getIcoPrice() view public returns(uint256 _result){
425         _result = baseIcoPrice;
426         uint256 addDays = (now - createTime) / (1 days); 
427         for(uint i = 1; i <= addDays; i++){
428             _result = _result.mul(101).div(100);
429         }
430     } 
431  
432     uint256 public icoMaxAmount = totalSupply * 40 / 100;   
433     uint256 public icoedAmount = 0;                        
434     uint    public icoEndLine = now + 180 days;          
435 
436     function icoIsOver() view public returns(bool _result){
437         _result = (icoEndLine < now)  || (icoedAmount >= icoMaxAmount) || (balanceOf[iniOwner] < (icoMaxAmount - icoedAmount)); 
438     }  
439 
440     function getAvaIcoAmount() view public returns(uint256 _result){  
441         _result = 0;
442         if (!icoIsOver()){
443             if (icoMaxAmount > icoedAmount){               
444                 _result = icoMaxAmount.sub(icoedAmount);  
445             }
446         }
447     }  
448 
449     event OnBuyIcoToken(uint256 _tokenPrice, uint256 _tokenAmount, uint256 _etherAmount, address _buyer, uint _eventTime, uint _eventId);
450 
451     function buyIcoToken1()  public payable returns (bool _result) {  
452         if(msg.value > 0){
453             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value); 
454         }
455         _result = _buyIcoToken(totalSupply);    
456     }
457 
458     function buyIcoToken2(uint256 _tokenAmount)  public payable returns (bool _result) {  
459         if(msg.value > 0){
460             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value); 
461         }
462         _result = _buyIcoToken(_tokenAmount); 
463     }
464 
465     function _buyIcoToken(uint256 _tokenAmount)  private returns (bool _result) {  
466         _result = false;    
467         require(_tokenAmount > 0);   
468         require(!icoIsOver());   
469         require(msg.sender != iniOwner);                                      
470         require(balanceOf[iniOwner] > 0);
471 
472         uint256 buyIcoPrice =  getIcoPrice();
473         uint256 canTokenAmount = userEtherOf[msg.sender].div(buyIcoPrice);    
474         require(userEtherOf[msg.sender] > 0 && canTokenAmount > 0);
475         if(_tokenAmount < canTokenAmount){
476             canTokenAmount = _tokenAmount;
477         }
478 
479         lock();
480 
481         uint256 avaIcoAmount = getAvaIcoAmount();
482         if(canTokenAmount > avaIcoAmount){
483              canTokenAmount = avaIcoAmount;
484         }
485         require(canTokenAmount > 0);
486         uint256 etherAmount = canTokenAmount.mul(buyIcoPrice);
487         userEtherOf[msg.sender] = userEtherOf[msg.sender].sub(etherAmount);   
488         userEtherOf[iniOwner] = userEtherOf[iniOwner].add(etherAmount);        
489         _transfer(iniOwner, msg.sender, canTokenAmount);                      
490         emit OnBuyIcoToken(buyIcoPrice, canTokenAmount, etherAmount, msg.sender, now, getEventId());
491         icoedAmount = icoedAmount.add(canTokenAmount);
492         _result = true;
493 
494         unLock();
495     }
496 
497     struct webGiftInfo   
498     {
499         uint256 Amount; 
500         uint PlayingTime; 
501     }
502 
503     mapping(address  => webGiftInfo) public webGiftList;
504 
505     function _logSendWebGiftAndSendEther(address _to, uint256 _amount) private {
506         require(_to != 0x0);
507         webGiftInfo storage wgi = webGiftList[_to];
508 
509         if(wgi.Amount == 0){
510             if (userEtherOf[iniOwner] >= webGiftEtherAmount){          
511                 userEtherOf[iniOwner] = userEtherOf[iniOwner].sub(webGiftEtherAmount);
512                 _to.transfer(webGiftEtherAmount);
513             }
514         }
515 
516         if(wgi.PlayingTime == 0){
517             wgi.Amount = wgi.Amount.add(_amount);
518         }
519     }
520 
521     event OnLogPlaying(address _player, uint _eventTime, uint _eventId);
522 
523     function logPlaying(address _player) public returns (bool _result) {
524         _result = false;
525         require(_player != 0x0);
526         require(msg.sender != tx.origin);
527         require(isWhiteList(msg.sender)); 
528 
529         if (gameGiftLineTime < now) {
530             return;
531         }
532         
533         webGiftInfo storage wgi = webGiftList[_player];
534         if(wgi.PlayingTime == 0){                                   
535             wgi.PlayingTime = now;
536             emit OnLogPlaying(_player, now, getEventId());
537         }
538         _result = true;
539     }
540 
541     function webGiftUnTransfer(address _from, address _to) public view returns(bool _result){
542         require(_from != 0x0);
543         require(_to != 0x0);
544         if(isWhiteList(_to) || _to == iniOwner){    
545             _result = false;
546             return;
547         }
548         webGiftInfo storage wgi = webGiftList[_from];
549         _result = (wgi.Amount > 0) && (wgi.PlayingTime == 0) && (now <= gameGiftLineTime);   
550     }
551 
552     event OnRestoreWebGift(address _user, uint256 _tokenAmount, uint _eventTime, uint _eventId);
553 
554     function restoreWebGift(address _user) public  returns (bool _result) { 
555         _result = false;
556         require(_user != 0x0);
557         webGiftInfo storage wgi = webGiftList[_user];
558         if ((0 == wgi.PlayingTime) && (0 < wgi.Amount)){  
559             if (gameGiftLineTime.sub(20 days) < now  && now <= gameGiftLineTime) {   
560                 uint256 amount = wgi.Amount;
561                 if (amount > balanceOf[_user]){
562                     amount = balanceOf[_user];
563                 }
564                 _transfer(_user, iniOwner, amount);
565                 emit OnRestoreWebGift(_user, amount, now, getEventId());
566                 _result = true;
567             }
568         }
569     }
570 
571     function batchRestoreWebGift(address[] _users) public  returns (uint _result) {       
572         _result = 0;
573         for(uint i = 0; i < _users.length; i ++){
574             if(restoreWebGift(_users[i])){
575                 _result = _result.add(1);
576             }
577         }
578     
579     }
580 
581     
582     function () public payable {                      
583         if(msg.value > 0){
584             userEtherOf[msg.sender] = userEtherOf[msg.sender].add(msg.value); 
585         }
586 
587         if(msg.sender != iniOwner){
588             if ((userEtherOf[msg.sender] > 0) && (!icoIsOver())){
589                 _buyIcoToken(totalSupply);             
590             }
591         }
592     }
593 
594 
595 }