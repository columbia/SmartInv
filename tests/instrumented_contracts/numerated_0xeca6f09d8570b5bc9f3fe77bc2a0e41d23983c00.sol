1 pragma solidity ^0.4.23;
2 
3 
4 /*
5  *             ╔═╗┌─┐┌─┐┬┌─┐┬┌─┐┬   ┌─────────────────────────┐ ╦ ╦┌─┐┌┐ ╔═╗┬┌┬┐┌─┐ 
6  *             ║ ║├┤ ├┤ ││  │├─┤│   │          MSCE.vip       │ ║║║├┤ ├┴┐╚═╗│ │ ├┤  
7  *             ╚═╝└  └  ┴└─┘┴┴ ┴┴─┘ └─┬─────────────────────┬─┘ ╚╩╝└─┘└─┘╚═╝┴ ┴ └─┘ 
8  *   ┌────────────────────────────────┘                     └──────────────────────────────┐
9  *   │    ┌─────────────────────────────────────────────────────────────────────────────┐  │
10  *   └────┤ Dev:John ├──────────────────────┤ Boss:Jack ├──────────────────┤ Sup:Kilmas ├──┘
11  *        └─────────────────────────────────────────────────────────────────────────────┘
12  */
13 
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
20     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
21     // benefit is lost if 'b' is also tested.
22     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23     if (_a == 0) {
24       return 0;
25     }
26 
27     c = _a * _b;
28     assert(c / _a == _b);
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers, truncating the quotient.
34   */
35   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
36     // assert(_b > 0); // Solidity automatically throws when dividing by 0
37     // uint256 c = _a / _b;
38     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
39     return _a / _b;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     assert(_b <= _a);
47     return _a - _b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
54     c = _a + _b;
55     assert(c >= _a);
56     return c;
57   }
58 }
59 
60 
61 contract Ownable {
62   address public owner;
63 
64 
65   event OwnershipRenounced(address indexed previousOwner);
66   event OwnershipTransferred(
67     address indexed previousOwner,
68     address indexed newOwner
69   );
70 
71 
72   /**
73    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74    * account.
75    */
76   constructor() public {
77     owner = msg.sender;
78   }
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88   /**
89    * @dev Allows the current owner to relinquish control of the contract.
90    * @notice Renouncing to ownership will leave the contract without an owner.
91    * It will not be possible to call the functions with the `onlyOwner`
92    * modifier anymore.
93    */
94   function renounceOwnership() public onlyOwner {
95     emit OwnershipRenounced(owner);
96     owner = address(0);
97   }
98 
99   /**
100    * @dev Allows the current owner to transfer control of the contract to a newOwner.
101    * @param _newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address _newOwner) public onlyOwner {
104     _transferOwnership(_newOwner);
105   }
106 
107   /**
108    * @dev Transfers control of the contract to a newOwner.
109    * @param _newOwner The address to transfer ownership to.
110    */
111   function _transferOwnership(address _newOwner) internal {
112     require(_newOwner != address(0));
113     emit OwnershipTransferred(owner, _newOwner);
114     owner = _newOwner;
115   }
116 }
117 
118 contract ERC20Basic {
119   function totalSupply() public view returns (uint256);
120   function balanceOf(address _who) public view returns (uint256);
121   function transfer(address _to, uint256 _value) public returns (bool);
122   event Transfer(address indexed from, address indexed to, uint256 value);
123 }
124 
125 contract ERC20 is ERC20Basic {
126   function allowance(address _owner, address _spender)
127     public view returns (uint256);
128 
129   function transferFrom(address _from, address _to, uint256 _value)
130     public returns (bool);
131 
132   function approve(address _spender, uint256 _value) public returns (bool);
133   event Approval(
134     address indexed owner,
135     address indexed spender,
136     uint256 value
137   );
138 }
139 
140 contract BasicToken is ERC20Basic {
141   using SafeMath for uint256;
142 
143   mapping(address => uint256) internal balances;
144 
145   uint256 internal totalSupply_;
146 
147   /**
148   * @dev Total number of tokens in existence
149   */
150   function totalSupply() public view returns (uint256) {
151     return totalSupply_;
152   }
153 
154   /**
155   * @dev Transfer token for a specified address
156   * @param _to The address to transfer to.
157   * @param _value The amount to be transferred.
158   */
159   function transfer(address _to, uint256 _value) public returns (bool) {
160     require(_value <= balances[msg.sender]);
161     require(_to != address(0));
162 
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     emit Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public view returns (uint256) {
175     return balances[_owner];
176   }
177 }
178 
179 contract BurnableToken is BasicToken {
180 
181   event Burn(address indexed burner, uint256 value);
182 
183   /**
184    * @dev Burns a specific amount of tokens.
185    * @param _value The amount of token to be burned.
186    */
187   function burn(uint256 _value) public {
188     _burn(msg.sender, _value);
189   }
190 
191   function _burn(address _who, uint256 _value) internal {
192     require(_value <= balances[_who]);
193     // no need to require value <= totalSupply, since that would imply the
194     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
195 
196     balances[_who] = balances[_who].sub(_value);
197     totalSupply_ = totalSupply_.sub(_value);
198     emit Burn(_who, _value);
199     emit Transfer(_who, address(0), _value);
200   }
201 }
202 
203 
204 
205 
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(
218     address _from,
219     address _to,
220     uint256 _value
221   )
222     public
223     returns (bool)
224   {
225     require(_value <= balances[_from]);
226     require(_value <= allowed[_from][msg.sender]);
227     require(_to != address(0));
228 
229     balances[_from] = balances[_from].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232     emit Transfer(_from, _to, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238    * Beware that changing an allowance with this method brings the risk that someone may use both the old
239    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) public returns (bool) {
246     allowed[msg.sender][_spender] = _value;
247     emit Approval(msg.sender, _spender, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Function to check the amount of tokens that an owner allowed to a spender.
253    * @param _owner address The address which owns the funds.
254    * @param _spender address The address which will spend the funds.
255    * @return A uint256 specifying the amount of tokens still available for the spender.
256    */
257   function allowance(
258     address _owner,
259     address _spender
260    )
261     public
262     view
263     returns (uint256)
264   {
265     return allowed[_owner][_spender];
266   }
267 
268   /**
269    * @dev Increase the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed[_spender] == 0. To increment
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _addedValue The amount of tokens to increase the allowance by.
276    */
277   function increaseApproval(
278     address _spender,
279     uint256 _addedValue
280   )
281     public
282     returns (bool)
283   {
284     allowed[msg.sender][_spender] = (
285       allowed[msg.sender][_spender].add(_addedValue));
286     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290   /**
291    * @dev Decrease the amount of tokens that an owner allowed to a spender.
292    * approve should be called when allowed[_spender] == 0. To decrement
293    * allowed value is better to use this function to avoid 2 calls (and wait until
294    * the first transaction is mined)
295    * From MonolithDAO Token.sol
296    * @param _spender The address which will spend the funds.
297    * @param _subtractedValue The amount of tokens to decrease the allowance by.
298    */
299   function decreaseApproval(
300     address _spender,
301     uint256 _subtractedValue
302   )
303     public
304     returns (bool)
305   {
306     uint256 oldValue = allowed[msg.sender][_spender];
307     if (_subtractedValue >= oldValue) {
308       allowed[msg.sender][_spender] = 0;
309     } else {
310       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
311     }
312     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313     return true;
314   }
315 
316 
317 
318 }
319 
320 contract MSCE is Ownable, StandardToken, BurnableToken{
321     using SafeMath for uint256;
322 
323     uint8 public constant TOKEN_DECIMALS = 18;
324 
325     string public name = "Mobile Ecosystem"; 
326     string public symbol = "MSCE";
327     uint8 public decimals = TOKEN_DECIMALS;
328 
329 
330     uint256 public totalSupply = 500000000 *(10**uint256(TOKEN_DECIMALS)); 
331     uint256 public soldSupply = 0; 
332     uint256 public sellSupply = 0; 
333     uint256 public buySupply = 0; 
334     bool public stopSell = true;
335     bool public stopBuy = false;
336 
337     uint256 public crowdsaleStartTime = block.timestamp;
338     uint256 public crowdsaleEndTime = 1526831999;
339 
340     uint256 public crowdsaleTotal = 2000*40000*(10**18);
341 
342 
343     uint256 public buyExchangeRate = 40000;   
344     uint256 public sellExchangeRate = 100000;  
345     address public ethFundDeposit;  
346 
347 
348     bool public allowTransfers = true; 
349 
350 
351     mapping (address => bool) public frozenAccount;
352 
353     bool public enableInternalLock = true;
354     uint256 unitCount = 100; 
355     uint256 unitTime = 1 days;
356     uint256 lockTime = unitCount * unitTime;
357 
358     mapping (address => bool) public internalLockAccount;
359     mapping (address => uint256) public releaseLockAccount;
360     mapping (address => uint256) public lockAmount;
361     mapping (address => uint256) public lockStartTime;
362     mapping (address => uint256) public lockReleaseTime;
363 
364     event LockAmount(address _from, address _to, uint256 amount, uint256 releaseTime);
365     event FrozenFunds(address target, bool frozen);
366     event IncreaseSoldSaleSupply(uint256 _value);
367     event DecreaseSoldSaleSupply(uint256 _value);
368 
369     function MSCE() public {
370         balances[msg.sender] = totalSupply;
371         ethFundDeposit = msg.sender;                      
372         allowTransfers = true;
373     }
374 
375     function _isUserInternalLock() internal view returns (bool) {
376 
377         return getAccountLockState(msg.sender);
378 
379     }
380 
381     function increaseSoldSaleSupply (uint256 _value) onlyOwner public {
382         require (_value + soldSupply < totalSupply);
383         soldSupply = soldSupply.add(_value);
384         emit IncreaseSoldSaleSupply(_value);
385     }
386 
387     function decreaseSoldSaleSupply (uint256 _value) onlyOwner public {
388         require (soldSupply - _value > 0);
389         soldSupply = soldSupply.sub(_value);
390         emit DecreaseSoldSaleSupply(_value);
391     }
392 
393 
394     function setEthFundDeposit(address _ethFundDeposit) onlyOwner public {
395         require(_ethFundDeposit != address(0));
396         ethFundDeposit = _ethFundDeposit;
397     }
398 
399     function transferETH() onlyOwner public {
400         require(ethFundDeposit != address(0));
401         require(this.balance != 0);
402         require(ethFundDeposit.send(this.balance));
403     }
404 
405 
406     function setExchangeRate(uint256 _sellExchangeRate, uint256 _buyExchangeRate) onlyOwner public {
407         sellExchangeRate = _sellExchangeRate;
408         buyExchangeRate = _buyExchangeRate;
409     }
410 
411     function setExchangeStatus(bool _stopSell, bool _stopBuy) onlyOwner public {
412         stopSell = _stopSell;
413         stopBuy = _stopBuy;
414     }
415 
416     function setAllowTransfers(bool _allowTransfers) onlyOwner public {
417         allowTransfers = _allowTransfers;
418     }
419 
420     function setEnableInternalLock(bool _isEnable) onlyOwner public {
421         enableInternalLock = _isEnable;
422     }
423 
424 
425 
426     function getAccountUnlockTime(address _target) public view returns(uint256) {
427 
428         return releaseLockAccount[_target];
429 
430     }
431     function getAccountLockState(address _target) public view returns(bool) {
432         if(enableInternalLock && internalLockAccount[_target]){
433             if((releaseLockAccount[_target] > 0)&&(releaseLockAccount[_target]<block.timestamp)){       
434                 return false;
435             }          
436             return true;
437         }
438         return false;
439 
440     }
441 
442     function setUnitTime(uint256 unit) external onlyOwner{
443         unitTime = unit;
444     }
445     
446     function isOwner() internal view returns(bool success) {
447         if (msg.sender == owner) return true;
448         return false;
449     }
450     /***************************************************/
451     /*              BASE Functions                     */
452     /***************************************************/
453 
454     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
455         if (!isOwner()) {
456             require (allowTransfers);
457             require(!frozenAccount[_from]);                                         
458             require(!frozenAccount[_to]);                                        
459             require(!_isUserInternalLock());
460         }
461         return super.transferFrom(_from, _to, _value);
462     }
463 
464     function transfer(address _to, uint256 _value) public returns (bool) {
465         if (!isOwner()) {
466             require (allowTransfers);
467             require(!frozenAccount[msg.sender]);                                       
468             require(!frozenAccount[_to]);                                             
469             require(!_isUserInternalLock());
470             require(_value <= balances[msg.sender] - lockAmount[msg.sender] + releasedAmount(msg.sender));
471         }
472         if(_value >= releasedAmount(msg.sender)){
473             lockAmount[msg.sender] = lockAmount[msg.sender].sub(releasedAmount(msg.sender));
474         }else{
475             lockAmount[msg.sender] = lockAmount[msg.sender].sub(_value);
476         }
477         
478         return super.transfer(_to, _value);
479     }
480 
481     function approve(address _spender, uint256 _value) public returns (bool) {
482         if (!isOwner()) {
483             require (allowTransfers);
484             require(!frozenAccount[msg.sender]);                                         
485             require(!frozenAccount[_spender]);                                        
486             require(!_isUserInternalLock());
487             require(_value <= balances[msg.sender] - lockAmount[msg.sender] + releasedAmount(msg.sender));
488         }
489         if(_value >= releasedAmount(msg.sender)){
490             lockAmount[msg.sender] = lockAmount[msg.sender].sub(releasedAmount(msg.sender));
491         }else{
492             lockAmount[msg.sender] = lockAmount[msg.sender].sub(_value);
493         }
494         return super.approve(_spender, _value);
495     }
496 
497     function transferFromAdmin(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
498         require(_to != address(0));
499         require(_value <= balances[_from]);
500 
501         balances[_from] = balances[_from].sub(_value);
502         balances[_to] = balances[_to].add(_value);
503         Transfer(_from, _to, _value);
504         return true;
505     }
506 
507     function () internal payable{
508 
509         uint256 currentTime = block.timestamp;
510         require((currentTime>crowdsaleStartTime)&&(currentTime<crowdsaleEndTime));
511         require(crowdsaleTotal>0);
512 
513         require(buy());
514 
515         crowdsaleTotal = crowdsaleTotal.sub(msg.value.mul(buyExchangeRate));
516 
517     }
518 
519     function buy() payable public returns (bool){
520 
521 
522         uint256 amount = msg.value.mul(buyExchangeRate);
523 
524         require(!stopBuy);
525         require(amount <= balances[owner]);
526 
527         balances[owner] = balances[owner].sub(amount);
528         balances[msg.sender] = balances[msg.sender].add(amount);
529 
530         soldSupply = soldSupply.add(amount);
531         buySupply = buySupply.add(amount);
532 
533         Transfer(owner, msg.sender, amount);
534         return true;
535     }
536 
537     function sell(uint256 amount) public {
538         uint256 ethAmount = amount.div(sellExchangeRate);
539         require(!stopSell);
540         require(this.balance >= ethAmount);      
541         require(ethAmount >= 1);      
542 
543         require(balances[msg.sender] >= amount);                 
544         require(balances[owner] + amount > balances[owner]);       
545         require(!frozenAccount[msg.sender]);                       
546         require(!_isUserInternalLock());                                          
547 
548         balances[owner] = balances[owner].add(amount);
549         balances[msg.sender] = balances[msg.sender].sub(amount);
550 
551         soldSupply = soldSupply.sub(amount);
552         sellSupply = sellSupply.add(amount);
553 
554         Transfer(msg.sender, owner, amount);
555 
556         msg.sender.transfer(ethAmount); 
557     }
558 
559     function setCrowdsaleStartTime(uint256 _crowdsaleStartTime) onlyOwner public {
560         crowdsaleStartTime = _crowdsaleStartTime;
561     }
562 
563     function setCrowdsaleEndTime(uint256 _crowdsaleEndTime) onlyOwner public {
564         crowdsaleEndTime = _crowdsaleEndTime;
565     }
566    
567 
568     function setCrowdsaleTotal(uint256 _crowdsaleTotal) onlyOwner public {
569         crowdsaleTotal = _crowdsaleTotal;
570     }
571 
572     /***************************************************/
573     /*              Lock Functions                     */
574     /***************************************************/
575     function transferLockAmount(address _to, uint256 _value) public{
576         // require(_value >= _value, "Not enough MSCE");
577         require(balances[msg.sender] >= _value, "Not enough MSCE");
578         balances[msg.sender] = balances[msg.sender].sub(_value);
579         balances[_to] = balances[_to].add(_value);
580         lockAmount[_to] = lockAmount[_to].add(_value);
581         _resetReleaseTime(_to);
582         emit Transfer(msg.sender, _to, _value);
583         emit LockAmount(msg.sender, _to, _value, uint256(now + lockTime));
584     }
585 
586     function _resetReleaseTime(address _target) internal {
587         lockStartTime[_target] = uint256(now);
588         lockReleaseTime[_target] = uint256(now + lockTime);
589     }
590 
591     function releasedAmount(address _target) public view returns (uint256) {
592         if(now >= lockReleaseTime[_target]){
593             return lockAmount[_target];
594         }
595         else{
596             return (now - lockStartTime[_target]).div(unitTime).mul(lockAmount[_target]).div(100);
597         }
598     }
599     
600 }
601 
602 
603 contract MSCEVote is MSCE {
604     //Vote Setting
605     uint256 votingRight = 10000;
606     uint256 dealTime = 3 days;
607     
608      
609     struct Vote{
610         bool isActivated;
611         bytes32 name;
612         address target;
613         address spender;
614         uint256 targetAmount;
615         bool freeze;
616         string newName;
617         string newSymbol;
618         uint256 agreeSupply;
619         uint256 disagreeSupply;
620         uint256 startTime;
621         uint256 endTime;
622         uint256 releaseTime;
623     }
624  
625     Vote[] public votes;
626 
627     mapping (uint256 => address) public voteToOwner;
628     mapping (address => bool) public frozenAccount;
629 
630     event NewVote(address _initiator, bytes32 name, address target, uint256 targetAmount);
631 
632     modifier onlySuperNode() {
633         require(balances[msg.sender] >= 5000000*(10**18), "Just for SuperNodes");
634         _;
635     }
636 
637     modifier onlyVotingRight() {
638         require(balances[msg.sender] >= votingRight*(10**18), "You haven't voting right.");
639         _;
640     }    
641 
642     function createVote(bytes32 _name, address _target, address _spender,uint256 _targetAmount, bool _freeze, string _newName, string _newSymbol, uint256 _releaseTime) onlySuperNode public {
643         uint256 id = votes.push(Vote(true, _name,  _target, _spender,_targetAmount, _freeze, _newName, _newSymbol, 0, 0, uint256(now), uint256(now + dealTime), _releaseTime)) - 1;
644         voteToOwner[id] = msg.sender;
645         emit NewVote(msg.sender, _name, _target, _targetAmount);
646     }
647 
648     function mintToken(address target, uint256 mintedAmount) onlySuperNode public {
649         createVote("MINT", target, target, mintedAmount, false, "", "", 0);
650     }
651 
652     function destroyToken(address target, uint256 amount) onlySuperNode public {
653         createVote("DESTROY", target, target, amount, false, "", "", 0);
654     }
655 
656     function freezeAccount(address _target, bool freeze) onlySuperNode public {
657         createVote("FREEZE", _target, _target, 0, freeze, "", "", 0);
658     }
659 
660     function lockInternalAccount(address _target, bool _lock, uint256 _releaseTime) onlySuperNode public {
661         require(_target != address(0));
662         createVote("LOCK", _target, _target, 0, _lock, "", "", _releaseTime);
663     }
664 
665     function setName(string _name) onlySuperNode public {
666         createVote("CHANGENAME", msg.sender, msg.sender, 0, false, _name, "", 0);
667         
668     }
669 
670     function setSymbol(string _symbol) onlySuperNode public {
671         createVote("CHANGESYMBOL", msg.sender, msg.sender, 0, false, "", _symbol, 0);
672     }
673 
674     function transferFromAdmin(address _from, address _to, uint256 _value) onlySuperNode public returns (bool) {
675         require(_to != address(0));
676         require(_value <= balances[_from]);
677         createVote("TRANS",_from, _to, _value, false, "", "", 0);
678         return true;
679     }
680 
681     /***************************************************/
682     /*              Vote Functions                     */
683     /***************************************************/
684     function getVote(uint _id) 
685         public 
686         view 
687         returns (bool, bytes32, address, address, uint256, bool, string, string, uint256, uint256, uint256, uint256){
688         Vote storage _vote = votes[_id];
689         return(
690             _vote.isActivated,
691             _vote.name,
692             _vote.target,
693             _vote.spender,
694             _vote.targetAmount,
695             _vote.freeze,
696             _vote.newName,
697             _vote.newSymbol,
698             _vote.agreeSupply,
699             _vote.disagreeSupply,
700             _vote.startTime,
701             _vote.endTime
702         );
703     }
704 
705     function voteXId(uint256 _id, bool _agree) onlyVotingRight public{
706         Vote storage vote = votes[_id];
707         uint256 rate = 100;
708         if(vote.name == "FREEZE")
709         {
710             rate = 30;
711         }else if(vote.name == "DESTROY")
712         {
713             rate = 51;
714         }
715         else{
716             rate = 80;
717         }
718         if(now > vote.endTime){
719             vote.isActivated = false;
720             votes[_id] = vote;
721         }
722         require(vote.isActivated == true, "The vote ended");
723         if(_agree == true){
724             vote.agreeSupply = vote.agreeSupply.add(balances[msg.sender]);
725         }
726         else{
727             vote.disagreeSupply = vote.disagreeSupply.add(balances[msg.sender]);
728         }
729 
730         if (vote.agreeSupply >= soldSupply * (rate/100)){
731             executeVote(_id);
732         }else if (vote.disagreeSupply >= soldSupply * ((100-rate)/100)) {
733             vote.isActivated = false;
734             votes[_id] = vote;
735         }
736 
737     }
738 
739     function executeVote(uint256 _id)private{
740         Vote storage vote = votes[_id];
741         vote.isActivated = false;
742 
743         if(vote.name == "MINT"){
744             balances[vote.target] = balances[vote.target].add(vote.targetAmount);
745             totalSupply = totalSupply.add(vote.targetAmount);
746             emit Transfer(0, this, vote.targetAmount);
747             emit Transfer(this, vote.target, vote.targetAmount);
748         }else if(vote.name == "DESTROY"){
749             balances[vote.target] = balances[vote.target].sub(vote.targetAmount);
750             totalSupply = totalSupply.sub(vote.targetAmount);
751             emit Transfer(vote.target, this, vote.targetAmount);
752             emit Transfer(this, 0, vote.targetAmount);
753         }else if(vote.name == "CHANGENAME"){
754             name = vote.newName;
755         }else if(vote.name == "CHANGESYMBOL"){
756             symbol = vote.newSymbol;
757         }else if(vote.name == "FREEZE"){
758             frozenAccount[vote.target] = vote.freeze;
759             emit FrozenFunds(vote.target, vote.freeze);
760         }else if(vote.name == "LOCK"){
761             internalLockAccount[vote.target] = vote.freeze;
762             releaseLockAccount[vote.target] = vote.endTime;
763         }
764         else if(vote.name == "TRANS"){
765             balances[vote.target] = balances[vote.target].sub(vote.targetAmount);
766             balances[vote.spender] = balances[vote.spender].add(vote.targetAmount);
767             emit Transfer(vote.target, vote.spender, vote.targetAmount);
768         }
769         votes[_id] = vote;
770     }
771 
772     
773 }