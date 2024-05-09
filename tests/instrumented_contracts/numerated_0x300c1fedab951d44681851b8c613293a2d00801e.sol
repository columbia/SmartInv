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
146   
147   function allowance(address owner, address spender)
148     public view returns (uint256);
149 
150   function transferFrom(address from, address to, uint256 value)
151     public returns (bool);
152 
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(
155     address indexed owner,
156     address indexed spender,
157     uint256 value
158   );
159 }
160 
161 
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * https://github.com/ethereum/EIPs/issues/20
167  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
168  */
169 contract StandardToken is ERC20, BasicToken {
170 
171   mapping (address => mapping (address => uint256)) internal allowed;
172 
173 
174   /**
175    * @dev Transfer tokens from one address to another
176    * @param _from address The address which you want to send tokens from
177    * @param _to address The address which you want to transfer to
178    * @param _value uint256 the amount of tokens to be transferred
179    */
180   function transferFrom(
181     address _from,
182     address _to,
183     uint256 _value
184   )
185     public
186     returns (bool)
187   {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     emit Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     emit Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(
221     address _owner,
222     address _spender
223    )
224     public
225     view
226     returns (uint256)
227   {
228     return allowed[_owner][_spender];
229   }
230 
231   /**
232    * @dev Increase the amount of tokens that an owner allowed to a spender.
233    * approve should be called when allowed[_spender] == 0. To increment
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _addedValue The amount of tokens to increase the allowance by.
239    */
240   function increaseApproval(
241     address _spender,
242     uint256 _addedValue
243   )
244     public
245     returns (bool)
246   {
247     allowed[msg.sender][_spender] = (
248       allowed[msg.sender][_spender].add(_addedValue));
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   /**
254    * @dev Decrease the amount of tokens that an owner allowed to a spender.
255    * approve should be called when allowed[_spender] == 0. To decrement
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param _spender The address which will spend the funds.
260    * @param _subtractedValue The amount of tokens to decrease the allowance by.
261    */
262   function decreaseApproval(
263     address _spender,
264     uint256 _subtractedValue
265   )
266     public
267     returns (bool)
268   {
269     uint256 oldValue = allowed[msg.sender][_spender];
270     if (_subtractedValue > oldValue) {
271       allowed[msg.sender][_spender] = 0;
272     } else {
273       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274     }
275     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279 }
280 
281 /**
282  * @title Burnable Token
283  * @dev Token that can be irreversibly burned (destroyed).
284  */
285 
286 contract BurnableToken is BasicToken {
287 
288   event Burn(address indexed burner, uint256 value);
289 
290   /**
291    * @dev Burns a specific amount of tokens.
292    * @param _value The amount of token to be burned.
293    */
294   function burn(uint256 _value) public {
295     _burn(msg.sender, _value);
296   }
297 
298   function _burn(address _who, uint256 _value) internal {
299     require(_value <= balances[_who]);
300     // no need to require value <= totalSupply, since that would imply the
301     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
302 
303     balances[_who] = balances[_who].sub(_value);
304     totalSupply_ = totalSupply_.sub(_value);
305     emit Burn(_who, _value);
306     emit Transfer(_who, address(0), _value);
307   }
308 }
309 
310 /**
311  * @title Standard Burnable Token
312  * @dev Adds burnFrom method to ERC20 implementations
313  */
314 
315 contract StandardBurnableToken is BurnableToken, StandardToken {
316 
317   /**
318    * @dev Burns a specific amount of tokens from the target address and decrements allowance
319    * @param _from address The address which you want to send tokens from
320    * @param _value uint256 The amount of token to be burned
321    */
322   function burnFrom(address _from, uint256 _value) public {
323     require(_value <= allowed[_from][msg.sender]);
324     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
325     // this function needs to emit an event with the updated approval.
326     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
327     _burn(_from, _value);
328   }
329 }
330 
331 /**
332  * @title Pausable
333  * @dev Base contract which allows children to implement an emergency stop mechanism.
334  */
335 contract Pausable is Ownable {
336   event Pause();
337   event Unpause();
338 
339   bool public paused = false;
340 
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is not paused.
344    */
345   modifier whenNotPaused() {
346     require(!paused);
347     _;
348   }
349 
350   /**
351    * @dev Modifier to make a function callable only when the contract is paused.
352    */
353   modifier whenPaused() {
354     require(paused);
355     _;
356   }
357 
358   /**
359    * @dev called by the owner to pause, triggers stopped state
360    */
361   function pause() onlyOwner whenNotPaused public {
362     paused = true;
363     emit Pause();
364   }
365 
366   /**
367    * @dev called by the owner to unpause, returns to normal state
368    */
369   function unpause() onlyOwner whenPaused public {
370     paused = false;
371     emit Unpause();
372   }
373 }
374 
375 /**
376  * @title Pausable token
377  * @dev StandardToken modified with pausable transfers.
378  **/
379 contract PausableToken is StandardToken, Pausable {
380 
381   function transfer(
382     address _to,
383     uint256 _value
384   )
385     public
386     whenNotPaused
387     returns (bool)
388   {
389     return super.transfer(_to, _value);
390   }
391 
392   function transferFrom(
393     address _from,
394     address _to,
395     uint256 _value
396   )
397     public
398     whenNotPaused
399     returns (bool)
400   {
401     return super.transferFrom(_from, _to, _value);
402   }
403 
404   function approve(
405     address _spender,
406     uint256 _value
407   )
408     public
409     whenNotPaused
410     returns (bool)
411   {
412     return super.approve(_spender, _value);
413   }
414 
415   function increaseApproval(
416     address _spender,
417     uint _addedValue
418   )
419     public
420     whenNotPaused
421     returns (bool success)
422   {
423     return super.increaseApproval(_spender, _addedValue);
424   }
425 
426   function decreaseApproval(
427     address _spender,
428     uint _subtractedValue
429   )
430     public
431     whenNotPaused
432     returns (bool success)
433   {
434     return super.decreaseApproval(_spender, _subtractedValue);
435   }
436 }
437 
438 /**
439  * @title Lox token
440  **/
441  contract LOX is StandardBurnableToken, PausableToken {
442      
443     using SafeMath for uint256;
444     string public constant name = "LOX SOCIETY";
445     string public constant symbol = "LOX";
446     uint8 public constant decimals = 10;
447     uint256 public constant INITIAL_SUPPLY = 5e4 * (10 ** uint256(decimals));
448     uint constant LOCK_TOKEN_COUNT = 1000;
449     
450     struct LockedUserInfo{
451         uint256 _releaseTime;
452         uint256 _amount;
453     }
454 
455     mapping(address => LockedUserInfo[]) private lockedUserEntity;
456     mapping(address => bool) private supervisorEntity;
457     mapping(address => bool) private lockedWalletEntity;
458 
459     modifier onlySupervisor() {
460         require(owner == msg.sender || supervisorEntity[msg.sender]);
461         _;
462     }
463 
464     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
465     event Unlock(address indexed holder, uint256 value);
466  
467     event PrintLog(
468         address indexed sender,
469         string _logName,
470         uint256 _value
471     );
472 
473     constructor() public {
474         totalSupply_ = INITIAL_SUPPLY;
475         balances[msg.sender] = INITIAL_SUPPLY;
476         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
477     }
478     
479     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
480         require(!isLockedWalletEntity(msg.sender));
481         require(msg.sender != to,"Check your address!!");
482         
483         if (lockedUserEntity[msg.sender].length > 0 ) {
484             _autoUnlock(msg.sender);            
485         }
486         return super.transfer(to, value);
487     }
488 
489     function transferFrom(address from, address to, uint256 value) public whenNotPaused  returns (bool) {
490         require(!isLockedWalletEntity(from) && !isLockedWalletEntity(msg.sender));
491         if (lockedUserEntity[from].length > 0) {
492             _autoUnlock(from);            
493         }
494         return super.transferFrom(from, to, value);
495     }
496     
497     function transferWithLock(address holder, uint256 value, uint256 releaseTime) public onlySupervisor whenNotPaused returns (bool) {
498         require(releaseTime > now && value > 0, "Check your values!!;");
499         if(lockedUserEntity[holder].length >= LOCK_TOKEN_COUNT){
500             return false;
501         }
502         transfer(holder, value);
503         _lock(holder,value,releaseTime);
504         return true;
505     }
506       
507     function _lock(address holder, uint256 value, uint256 releaseTime) internal returns(bool) {
508         balances[holder] = balances[holder].sub(value);
509         lockedUserEntity[holder].push( LockedUserInfo(releaseTime, value) );
510         
511         emit Lock(holder, value, releaseTime);
512         return true;
513     }
514     
515     function _unlock(address holder, uint256 idx) internal returns(bool) {
516         LockedUserInfo storage lockedUserInfo = lockedUserEntity[holder][idx];
517         uint256 releaseAmount = lockedUserInfo._amount;
518 
519         delete lockedUserEntity[holder][idx];
520         lockedUserEntity[holder][idx] = lockedUserEntity[holder][lockedUserEntity[holder].length.sub(1)];
521         lockedUserEntity[holder].length -=1;
522         
523         emit Unlock(holder, releaseAmount);
524         balances[holder] = balances[holder].add(releaseAmount);
525         
526         return true;
527     }
528     
529     function _autoUnlock(address holder) internal returns(bool) {
530         for(uint256 idx =0; idx < lockedUserEntity[holder].length ; idx++ ) {
531             if (lockedUserEntity[holder][idx]._releaseTime <= now) {
532                 // If lockupinfo was deleted, loop restart at same position.
533                 if( _unlock(holder, idx) ) {
534                     idx -=1;
535                 }
536             }
537         }
538         return true;
539     } 
540     
541     function setLockTime(address holder, uint idx, uint256 releaseTime) onlySupervisor public returns(bool){
542         require(holder !=address(0) && idx >= 0 && releaseTime > now);
543         require(lockedUserEntity[holder].length >= idx);
544          
545         lockedUserEntity[holder][idx]._releaseTime = releaseTime;
546         return true;
547     }
548     
549     function getLockedUserInfo(address _address) view public returns (uint256[], uint256[]){
550         require(msg.sender == _address || msg.sender == owner || supervisorEntity[msg.sender]);
551         uint256[] memory _returnAmount = new uint256[](lockedUserEntity[_address].length);
552         uint256[] memory _returnReleaseTime = new uint256[](lockedUserEntity[_address].length);
553         
554         for(uint i = 0; i < lockedUserEntity[_address].length; i ++){
555             _returnAmount[i] = lockedUserEntity[_address][i]._amount;
556             _returnReleaseTime[i] = lockedUserEntity[_address][i]._releaseTime;
557         }
558         return (_returnAmount, _returnReleaseTime);
559     }
560     
561     function burn(uint256 _value) onlySupervisor public {
562         super._burn(msg.sender, _value);
563     }
564     
565     function burnFrom(address _from, uint256 _value) onlySupervisor public {
566         super.burnFrom(_from, _value);
567     }
568     
569     function balanceOf(address owner) public view returns (uint256) {
570         
571         uint256 totalBalance = super.balanceOf(owner);
572         if( lockedUserEntity[owner].length >0 ){
573             for(uint i=0; i<lockedUserEntity[owner].length;i++){
574                 totalBalance = totalBalance.add(lockedUserEntity[owner][i]._amount);
575             }
576         }
577         
578         return totalBalance;
579     }
580 
581     function setSupervisor(address _address) onlyOwner public returns (bool){
582         require(_address !=address(0) && !supervisorEntity[_address]);
583         supervisorEntity[_address] = true;
584         emit PrintLog(_address, "isSupervisor",  1);
585         return true;
586     }
587 
588     function removeSupervisor(address _address) onlyOwner public returns (bool){
589         require(_address !=address(0) && supervisorEntity[_address]);
590         delete supervisorEntity[_address];
591         emit PrintLog(_address, "isSupervisor",  0);
592         return true;
593     }
594 
595     function setLockedWalletEntity(address _address) onlySupervisor public returns (bool){
596         require(_address !=address(0) && !lockedWalletEntity[_address]);
597         lockedWalletEntity[_address] = true;
598         emit PrintLog(_address, "isLockedWalletEntity",  1);
599         return true;
600     }
601 
602     function removeLockedWalletEntity(address _address) onlySupervisor public returns (bool){
603         require(_address !=address(0) && lockedWalletEntity[_address]);
604         delete lockedWalletEntity[_address];
605         emit PrintLog(_address, "isLockedWalletEntity",  0);
606         return true;
607     }
608 
609     function isSupervisor(address _address) view onlyOwner public returns (bool){
610         return supervisorEntity[_address];
611     }
612 
613     function isLockedWalletEntity(address _from) view private returns (bool){
614         return lockedWalletEntity[_from];
615     }
616 
617 }