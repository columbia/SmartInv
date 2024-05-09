1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipRenounced(address indexed previousOwner);
25   event OwnershipTransferred(
26     address indexed previousOwner,
27     address indexed newOwner
28   );
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   constructor() public {
36     owner = msg.sender;
37   }
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     emit OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57   /**
58    * @dev Allows the current owner to relinquish control of the contract.
59    */
60   function renounceOwnership() public onlyOwner {
61     emit OwnershipRenounced(owner);
62     owner = address(0);
63   }
64 }
65 
66 library SafeMath {
67   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68     if (a == 0) {
69       return 0;
70     }
71     uint256 c = a * b;
72     assert(c / a == b);
73     return c;
74   }
75 
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b > 0); // Solidity automatically throws when dividing by 0
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return c;
81   }
82 
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   function add(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a + b;
90     assert(c >= a);
91     return c;
92   }
93 }
94 
95 
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) balances;
105 
106   uint256 totalSupply_;
107 
108   /**
109   * @dev Total number of tokens in existence
110   */
111   function totalSupply() public view returns (uint256) {
112     return totalSupply_;
113   }
114 
115   /**
116   * @dev Transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) public returns (bool) {
121     require(_to != address(0));
122     require(_value <= balances[msg.sender]);
123 
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     emit Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public view returns (uint256) {
136     return balances[_owner];
137   }
138 
139 }
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 contract ERC20 is ERC20Basic {
146   function allowance(address owner, address spender)
147     public view returns (uint256);
148 
149   function transferFrom(address from, address to, uint256 value)
150     public returns (bool);
151 
152   function approve(address spender, uint256 value) public returns (bool);
153   event Approval(
154     address indexed owner,
155     address indexed spender,
156     uint256 value
157   );
158 }
159 
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * https://github.com/ethereum/EIPs/issues/20
166  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(
180     address _from,
181     address _to,
182     uint256 _value
183   )
184     public
185     returns (bool)
186   {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     emit Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     emit Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(
220     address _owner,
221     address _spender
222    )
223     public
224     view
225     returns (uint256)
226   {
227     return allowed[_owner][_spender];
228   }
229 
230   /**
231    * @dev Increase the amount of tokens that an owner allowed to a spender.
232    * approve should be called when allowed[_spender] == 0. To increment
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _addedValue The amount of tokens to increase the allowance by.
238    */
239   function increaseApproval(
240     address _spender,
241     uint256 _addedValue
242   )
243     public
244     returns (bool)
245   {
246     allowed[msg.sender][_spender] = (
247       allowed[msg.sender][_spender].add(_addedValue));
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   /**
253    * @dev Decrease the amount of tokens that an owner allowed to a spender.
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(
262     address _spender,
263     uint256 _subtractedValue
264   )
265     public
266     returns (bool)
267   {
268     uint256 oldValue = allowed[msg.sender][_spender];
269     if (_subtractedValue > oldValue) {
270       allowed[msg.sender][_spender] = 0;
271     } else {
272       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273     }
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278 }
279 
280 /**
281  * @title Burnable Token
282  * @dev Token that can be irreversibly burned (destroyed).
283  */
284 
285 contract BurnableToken is BasicToken {
286 
287   event Burn(address indexed burner, uint256 value);
288 
289   /**
290    * @dev Burns a specific amount of tokens.
291    * @param _value The amount of token to be burned.
292    */
293   function burn(uint256 _value) public {
294     _burn(msg.sender, _value);
295   }
296 
297   function _burn(address _who, uint256 _value) internal {
298     require(_value <= balances[_who]);
299     // no need to require value <= totalSupply, since that would imply the
300     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
301 
302     balances[_who] = balances[_who].sub(_value);
303     totalSupply_ = totalSupply_.sub(_value);
304     emit Burn(_who, _value);
305     emit Transfer(_who, address(0), _value);
306   }
307 }
308 
309 /**
310  * @title Standard Burnable Token
311  * @dev Adds burnFrom method to ERC20 implementations
312  */
313 
314 contract StandardBurnableToken is BurnableToken, StandardToken {
315 
316   /**
317    * @dev Burns a specific amount of tokens from the target address and decrements allowance
318    * @param _from address The address which you want to send tokens from
319    * @param _value uint256 The amount of token to be burned
320    */
321   function burnFrom(address _from, uint256 _value) public {
322     require(_value <= allowed[_from][msg.sender]);
323     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
324     // this function needs to emit an event with the updated approval.
325     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
326     _burn(_from, _value);
327   }
328 }
329 
330 /**
331  * @title Pausable
332  * @dev Base contract which allows children to implement an emergency stop mechanism.
333  */
334 contract Pausable is Ownable {
335   event Pause();
336   event Unpause();
337 
338   bool public paused = false;
339 
340 
341   /**
342    * @dev Modifier to make a function callable only when the contract is not paused.
343    */
344   modifier whenNotPaused() {
345     require(!paused);
346     _;
347   }
348 
349   /**
350    * @dev Modifier to make a function callable only when the contract is paused.
351    */
352   modifier whenPaused() {
353     require(paused);
354     _;
355   }
356 
357   /**
358    * @dev called by the owner to pause, triggers stopped state
359    */
360   function pause() onlyOwner whenNotPaused public {
361     paused = true;
362     emit Pause();
363   }
364 
365   /**
366    * @dev called by the owner to unpause, returns to normal state
367    */
368   function unpause() onlyOwner whenPaused public {
369     paused = false;
370     emit Unpause();
371   }
372 }
373 
374 /**
375  * @title Pausable token
376  * @dev StandardToken modified with pausable transfers.
377  **/
378 contract PausableToken is StandardToken, Pausable {
379 
380   function transfer(
381     address _to,
382     uint256 _value
383   )
384     public
385     whenNotPaused
386     returns (bool)
387   {
388     return super.transfer(_to, _value);
389   }
390 
391   function transferFrom(
392     address _from,
393     address _to,
394     uint256 _value
395   )
396     public
397     whenNotPaused
398     returns (bool)
399   {
400     return super.transferFrom(_from, _to, _value);
401   }
402 
403   function approve(
404     address _spender,
405     uint256 _value
406   )
407     public
408     whenNotPaused
409     returns (bool)
410   {
411     return super.approve(_spender, _value);
412   }
413 
414   function increaseApproval(
415     address _spender,
416     uint _addedValue
417   )
418     public
419     whenNotPaused
420     returns (bool success)
421   {
422     return super.increaseApproval(_spender, _addedValue);
423   }
424 
425   function decreaseApproval(
426     address _spender,
427     uint _subtractedValue
428   )
429     public
430     whenNotPaused
431     returns (bool success)
432   {
433     return super.decreaseApproval(_spender, _subtractedValue);
434   }
435 }
436 
437 /**
438  * @title RflexCoin token
439  **/
440  contract RflexCoin is StandardBurnableToken, PausableToken {
441     using SafeMath for uint256;
442     string public constant name = "Rflexcoin";
443     string public constant symbol = "RFC";
444     uint8 public constant decimals = 8;
445     uint256 public constant INITIAL_SUPPLY = 1e10 * (10 ** uint256(decimals));
446 
447     struct lockedUserInfo{
448         address lockedUserAddress;
449         uint firstUnlockTime;
450         uint secondUnlockTime;
451         uint thirdUnlockTime;
452         uint256 firstUnlockValue;
453         uint256 secondUnlockValue;
454         uint256 thirdUnlockValue;
455     }
456 
457     mapping(address => lockedUserInfo) private lockedUserEntity;
458     mapping(address => bool) private supervisorEntity;
459     mapping(address => bool) private lockedWalletEntity;
460 
461     modifier onlySupervisor() {
462         require(owner == msg.sender || supervisorEntity[msg.sender]);
463         _;
464     }
465 
466     event Unlock(
467         address indexed lockedUser,
468         uint lockPeriod,
469         uint256 firstUnlockValue,
470         uint256 secondUnlockValueUnlockValue,
471         uint256 thirdUnlockValue
472     );
473 
474     event PrintLog(
475         address indexed sender,
476         string _logName,
477         uint256 _value
478     );
479 
480     constructor() public {
481         totalSupply_ = INITIAL_SUPPLY;
482         balances[msg.sender] = INITIAL_SUPPLY;
483         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
484     }
485 
486     function transfer( address _to, uint256 _value ) public whenNotPaused returns (bool) {
487         require(!isLockedWalletEntity(msg.sender));
488         require(msg.sender != _to,"Check your address!!");
489 
490         uint256 availableValue = getAvailableWithdrawableCount(msg.sender, _value);
491         emit PrintLog(_to, "availableResultValue", availableValue);
492         require(availableValue > 0);
493 
494         return super.transfer(_to, availableValue);
495     }
496 
497     function burn(uint256 _value) onlySupervisor public {
498         super._burn(msg.sender, _value);
499     }
500 
501     function transferToLockedBalance(
502         address _to,
503         uint _firstUnlockTime,
504         uint256 _firstUnlockValue,
505         uint _secondUnlockTime,
506         uint256 _secondUnlockValue,
507         uint _thirdUnlockTime,
508         uint256 _thirdUnlockValue
509     ) onlySupervisor whenNotPaused public returns (bool) {
510         require(msg.sender != _to,"Check your address!!");
511         require(_firstUnlockTime > now && _firstUnlockValue > 0, "Check your First input values!!;");
512 
513         uint256 totalLockSendCount = totalLockSendCount.add(_firstUnlockValue);
514 
515         if(_secondUnlockTime > now && _secondUnlockValue > 0){
516             require(_secondUnlockTime > _firstUnlockTime, "Second Unlock time must be greater than First Unlock Time!!");
517 
518             totalLockSendCount = totalLockSendCount.add(_secondUnlockValue);
519         }
520 
521         if(_thirdUnlockTime > now && _thirdUnlockValue > 0){
522             require(_thirdUnlockTime > _secondUnlockTime && _secondUnlockTime > now &&  _secondUnlockValue > 0,
523                     "Check your third Unlock Time or Second input values!!");
524             totalLockSendCount = totalLockSendCount.add(_thirdUnlockValue);
525         }
526 
527         if (transfer(_to, totalLockSendCount)) {
528             lockedUserEntity[_to].lockedUserAddress = _to;
529             lockedUserEntity[_to].firstUnlockTime = _firstUnlockTime;
530             lockedUserEntity[_to].firstUnlockValue = _firstUnlockValue;
531 
532             if(_secondUnlockTime > now && _secondUnlockValue > 0){
533                 lockedUserEntity[_to].secondUnlockTime = _secondUnlockTime;
534                 lockedUserEntity[_to].secondUnlockValue = _secondUnlockValue;
535             }
536 
537             if(_thirdUnlockTime > now && _thirdUnlockValue > 0){
538                 lockedUserEntity[_to].thirdUnlockTime  = _thirdUnlockTime;
539                 lockedUserEntity[_to].thirdUnlockValue = _thirdUnlockValue;
540             }
541 
542             return true;
543         }
544     }
545 
546     function setLockTime(address _to, uint _time, uint256 _lockTime) onlySupervisor public returns(bool){
547         require(_to !=address(0) && _time > 0 && _time < 4 && _lockTime > now);
548 
549         (   uint firstUnlockTime,
550             uint secondUnlockTime,
551             uint thirdUnlockTime
552         ) = getLockedTimeUserInfo(_to);
553 
554         if(_time == 1 && firstUnlockTime !=0){
555             if(secondUnlockTime ==0 || _lockTime < secondUnlockTime){
556                 lockedUserEntity[_to].firstUnlockTime = _lockTime;
557                 return true;
558             }
559         }else if(_time == 2 && secondUnlockTime !=0){
560             if(_lockTime > firstUnlockTime && (thirdUnlockTime ==0 || _lockTime < thirdUnlockTime)){
561                 lockedUserEntity[_to].secondUnlockTime = _lockTime;
562                 return true;
563             }
564         }else if(_time == 3 && thirdUnlockTime !=0 && _lockTime > secondUnlockTime){
565             lockedUserEntity[_to].thirdUnlockTime = _lockTime;
566             return true;
567         }
568         return false;
569     }
570 
571     function getLockedUserInfo(address _address) view public returns (uint,uint256,uint,uint256,uint,uint256){
572         require(msg.sender == _address || msg.sender == owner || supervisorEntity[msg.sender]);
573         return (
574                     lockedUserEntity[_address].firstUnlockTime,
575                     lockedUserEntity[_address].firstUnlockValue,
576                     lockedUserEntity[_address].secondUnlockTime,
577                     lockedUserEntity[_address].secondUnlockValue,
578                     lockedUserEntity[_address].thirdUnlockTime,
579                     lockedUserEntity[_address].thirdUnlockValue
580                 );
581     }
582 
583     function setSupervisor(address _address) onlyOwner public returns (bool){
584         require(_address !=address(0) && !supervisorEntity[_address]);
585         supervisorEntity[_address] = true;
586         emit PrintLog(_address, "isSupervisor",  1);
587         return true;
588     }
589 
590     function removeSupervisor(address _address) onlyOwner public returns (bool){
591         require(_address !=address(0) && supervisorEntity[_address]);
592         delete supervisorEntity[_address];
593         emit PrintLog(_address, "isSupervisor",  0);
594         return true;
595     }
596 
597     function setLockedWalletEntity(address _address) onlySupervisor public returns (bool){
598         require(_address !=address(0) && !lockedWalletEntity[_address]);
599         lockedWalletEntity[_address] = true;
600         emit PrintLog(_address, "isLockedWalletEntity",  1);
601         return true;
602     }
603 
604     function removeLockedWalletEntity(address _address) onlySupervisor public returns (bool){
605         require(_address !=address(0) && lockedWalletEntity[_address]);
606         delete lockedWalletEntity[_address];
607         emit PrintLog(_address, "isLockedWalletEntity",  0);
608         return true;
609     }
610 
611     function getLockedTimeUserInfo(address _address) view private returns (uint,uint,uint){
612         require(msg.sender == _address || msg.sender == owner || supervisorEntity[msg.sender]);
613         return (
614                     lockedUserEntity[_address].firstUnlockTime,
615                     lockedUserEntity[_address].secondUnlockTime,
616                     lockedUserEntity[_address].thirdUnlockTime
617                 );
618     }
619 
620     function isSupervisor() view onlyOwner private returns (bool){
621         return supervisorEntity[msg.sender];
622     }
623 
624     function isLockedWalletEntity(address _from) view private returns (bool){
625         return lockedWalletEntity[_from];
626     }
627 
628     function getAvailableWithdrawableCount( address _from , uint256 _sendOrgValue) private returns (uint256) {
629         uint256 availableValue = 0;
630 
631         if(lockedUserEntity[_from].lockedUserAddress == address(0)){
632             availableValue = _sendOrgValue;
633         }else{
634                 (
635                     uint firstUnlockTime, uint256 firstUnlockValue,
636                     uint secondUnlockTime, uint256 secondUnlockValue,
637                     uint thirdUnlockTime, uint256 thirdUnlockValue
638                 ) = getLockedUserInfo(_from);
639 
640                 if(now < firstUnlockTime) {
641                     availableValue = balances[_from].sub(firstUnlockValue.add(secondUnlockValue).add(thirdUnlockValue));
642                     if(_sendOrgValue > availableValue){
643                         availableValue = 0;
644                     }else{
645                         availableValue = _sendOrgValue;
646                     }
647                 }else if(firstUnlockTime <= now && secondUnlockTime ==0){
648                     availableValue = balances[_from];
649                     if(_sendOrgValue > availableValue){
650                         availableValue = 0;
651                     }else{
652                         availableValue = _sendOrgValue;
653                         delete lockedUserEntity[_from];
654                         emit Unlock(_from, 1, firstUnlockValue, secondUnlockValue, thirdUnlockValue);
655                     }
656                 }else if(firstUnlockTime <= now && secondUnlockTime !=0 && now < secondUnlockTime){
657                     availableValue = balances[_from].sub(secondUnlockValue.add(thirdUnlockValue));
658                     if(_sendOrgValue > availableValue){
659                         availableValue = 0;
660                     }else{
661                         availableValue = _sendOrgValue;
662                         lockedUserEntity[_from].firstUnlockValue = 0;
663                         emit Unlock(_from, 1, firstUnlockValue, secondUnlockValue, thirdUnlockValue);
664                     }
665                 }else if(secondUnlockTime !=0 && secondUnlockTime <= now && thirdUnlockTime ==0){
666                     availableValue = balances[_from];
667                     if(_sendOrgValue > availableValue){
668                         availableValue = 0;
669                     }else{
670                         availableValue =_sendOrgValue;
671                         delete lockedUserEntity[_from];
672                         emit Unlock(_from, 2, firstUnlockValue, secondUnlockValue, thirdUnlockValue);
673                     }
674                 }else if(secondUnlockTime !=0 && secondUnlockTime <= now && thirdUnlockTime !=0 && now < thirdUnlockTime){
675                     availableValue = balances[_from].sub(thirdUnlockValue);
676                     if(_sendOrgValue > availableValue){
677                         availableValue = 0;
678                     }else{
679                         availableValue = _sendOrgValue;
680                         lockedUserEntity[_from].firstUnlockValue = 0;
681                         lockedUserEntity[_from].secondUnlockValue = 0;
682                         emit Unlock(_from, 2, firstUnlockValue, secondUnlockValue, thirdUnlockValue);
683                     }
684                 }else if(thirdUnlockTime !=0 && thirdUnlockTime <= now){
685                     availableValue = balances[_from];
686                     if(_sendOrgValue > availableValue){
687                         availableValue = 0;
688                     }else if(_sendOrgValue <= availableValue){
689                         availableValue = _sendOrgValue;
690                         delete lockedUserEntity[_from];
691                         emit Unlock(_from, 3, firstUnlockValue, secondUnlockValue, thirdUnlockValue);
692                     }
693                 }
694         }
695         return availableValue;
696     }
697 
698 }