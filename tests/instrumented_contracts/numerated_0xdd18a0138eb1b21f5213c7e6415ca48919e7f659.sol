1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
322 
323 /**
324  * @title Pausable
325  * @dev Base contract which allows children to implement an emergency stop mechanism.
326  */
327 contract Pausable is Ownable {
328   event Pause();
329   event Unpause();
330 
331   bool public paused = false;
332 
333 
334   /**
335    * @dev Modifier to make a function callable only when the contract is not paused.
336    */
337   modifier whenNotPaused() {
338     require(!paused);
339     _;
340   }
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is paused.
344    */
345   modifier whenPaused() {
346     require(paused);
347     _;
348   }
349 
350   /**
351    * @dev called by the owner to pause, triggers stopped state
352    */
353   function pause() public onlyOwner whenNotPaused {
354     paused = true;
355     emit Pause();
356   }
357 
358   /**
359    * @dev called by the owner to unpause, returns to normal state
360    */
361   function unpause() public onlyOwner whenPaused {
362     paused = false;
363     emit Unpause();
364   }
365 }
366 
367 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
368 
369 /**
370  * @title Pausable token
371  * @dev StandardToken modified with pausable transfers.
372  **/
373 contract PausableToken is StandardToken, Pausable {
374 
375   function transfer(
376     address _to,
377     uint256 _value
378   )
379     public
380     whenNotPaused
381     returns (bool)
382   {
383     return super.transfer(_to, _value);
384   }
385 
386   function transferFrom(
387     address _from,
388     address _to,
389     uint256 _value
390   )
391     public
392     whenNotPaused
393     returns (bool)
394   {
395     return super.transferFrom(_from, _to, _value);
396   }
397 
398   function approve(
399     address _spender,
400     uint256 _value
401   )
402     public
403     whenNotPaused
404     returns (bool)
405   {
406     return super.approve(_spender, _value);
407   }
408 
409   function increaseApproval(
410     address _spender,
411     uint _addedValue
412   )
413     public
414     whenNotPaused
415     returns (bool success)
416   {
417     return super.increaseApproval(_spender, _addedValue);
418   }
419 
420   function decreaseApproval(
421     address _spender,
422     uint _subtractedValue
423   )
424     public
425     whenNotPaused
426     returns (bool success)
427   {
428     return super.decreaseApproval(_spender, _subtractedValue);
429   }
430 }
431 
432 // File: contracts\Minebee.sol
433 
434 //solium-disable linebreak-style
435 pragma solidity ^0.4.24;
436 
437 
438 contract Minebee is PausableToken {
439 
440     //token spec
441     string public constant name = "MineBee"; // solium-disable-line uppercase
442     string public constant symbol = "MB"; // solium-disable-line uppercase
443     uint8 public constant decimals = 18; // solium-disable-line uppercase
444 
445     uint256 public constant INITIAL_SUPPLY = 5000000000 * (10 ** uint256(decimals));
446 
447     constructor() public {
448         totalSupply_ = INITIAL_SUPPLY;
449         balances[msg.sender] = INITIAL_SUPPLY;
450         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
451     }
452 
453     //freezable
454     event Frozen(address target);
455     event Unfrozen(address target);
456 
457     mapping(address => bool) internal freezes;
458 
459     modifier whenNotFrozen() {
460         require(!freezes[msg.sender], "Sender account is locked.");
461         _;
462     }
463 
464     function freeze(address _target) public onlyOwner {
465         freezes[_target] = true;
466         emit Frozen(_target);
467     }
468 
469     function unfreeze(address _target) public onlyOwner {
470         freezes[_target] = false;
471         emit Unfrozen(_target);
472     }
473 
474     function isFrozen(address _target) public view returns (bool) {
475         return freezes[_target];
476     }
477 
478     function transfer(
479         address _to,
480         uint256 _value
481     )
482       public
483       whenNotFrozen
484       returns (bool)
485     {
486         releaseLock(msg.sender);
487         return super.transfer(_to, _value);
488     }
489 
490     function transferFrom(
491         address _from,
492         address _to,
493         uint256 _value
494     )
495       public
496       returns (bool)
497     {
498         require(!freezes[_from], "From account is locked.");
499         releaseLock(_from);
500         return super.transferFrom(_from, _to, _value);
501     }
502 
503     //mintable
504     event Mint(address indexed to, uint256 amount);
505 
506     function mint(
507         address _to,
508         uint256 _amount
509     )
510       public
511       onlyOwner
512       returns (bool)
513     {
514         totalSupply_ = totalSupply_.add(_amount);
515         balances[_to] = balances[_to].add(_amount);
516         emit Mint(_to, _amount);
517         emit Transfer(address(0), _to, _amount);
518         return true;
519     }
520 
521     //burnable
522     event Burn(address indexed burner, uint256 value);
523 
524     function burn(address _who, uint256 _value) public onlyOwner {
525         _burn(_who, _value);
526     }
527 
528     function _burn(address _who, uint256 _value) internal {
529         require(_value <= balances[_who], "Balance is too small.");
530 
531         balances[_who] = balances[_who].sub(_value);
532         totalSupply_ = totalSupply_.sub(_value);
533         emit Burn(_who, _value);
534         emit Transfer(_who, address(0), _value);
535     }
536 
537     //lockable
538     struct LockInfo {
539         uint256 releaseTime;
540         uint256 balance;
541     }
542     mapping(address => LockInfo[]) internal lockInfo;
543 
544     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
545     event Unlock(address indexed holder, uint256 value);
546 
547     function balanceOf(address _holder) public view returns (uint256 balance) {
548         uint256 lockedBalance = 0;
549         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
550             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
551         }
552         return balances[_holder].add(lockedBalance);
553     }
554 
555     function releaseLock(address _holder) internal {
556 
557         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
558             if (lockInfo[_holder][i].releaseTime <= now) {
559 
560                 balances[_holder] = balances[_holder].add(lockInfo[_holder][i].balance);
561                 emit Unlock(_holder, lockInfo[_holder][i].balance);
562                 lockInfo[_holder][i].balance = 0;
563 
564                 if (i != lockInfo[_holder].length - 1) {
565                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
566                     i--;
567                 }
568                 lockInfo[_holder].length--;
569 
570             }
571         }
572     }
573     function lockCount(address _holder) public view returns (uint256) {
574         return lockInfo[_holder].length;
575     }
576     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
577         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
578     }
579 
580     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
581         require(balances[_holder] >= _amount, "Balance is too small.");
582         balances[_holder] = balances[_holder].sub(_amount);
583         lockInfo[_holder].push(
584             LockInfo(_releaseTime, _amount)
585         );
586         emit Lock(_holder, _amount, _releaseTime);
587     }
588 
589     function lockAfter(address _holder, uint256 _amount, uint256 _afterTime) public onlyOwner {
590         require(balances[_holder] >= _amount, "Balance is too small.");
591         balances[_holder] = balances[_holder].sub(_amount);
592         lockInfo[_holder].push(
593             LockInfo(now + _afterTime, _amount)
594         );
595         emit Lock(_holder, _amount, now + _afterTime);
596     }
597 
598     function unlock(address _holder, uint256 i) public onlyOwner {
599         require(i < lockInfo[_holder].length, "No lock information.");
600 
601         balances[_holder] = balances[_holder].add(lockInfo[_holder][i].balance);
602         emit Unlock(_holder, lockInfo[_holder][i].balance);
603         lockInfo[_holder][i].balance = 0;
604 
605         if (i != lockInfo[_holder].length - 1) {
606             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
607         }
608         lockInfo[_holder].length--;
609     }
610 
611     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
612         require(_to != address(0), "wrong address");
613         require(_value <= balances[owner], "Not enough balance");
614 
615         balances[owner] = balances[owner].sub(_value);
616         lockInfo[_to].push(
617             LockInfo(_releaseTime, _value)
618         );
619         emit Transfer(owner, _to, _value);
620         emit Lock(_to, _value, _releaseTime);
621 
622         return true;
623     }
624 
625     function transferWithLockAfter(address _to, uint256 _value, uint256 _afterTime) public onlyOwner returns (bool) {
626         require(_to != address(0), "wrong address");
627         require(_value <= balances[owner], "Not enough balance");
628 
629         balances[owner] = balances[owner].sub(_value);
630         lockInfo[_to].push(
631             LockInfo(now + _afterTime, _value)
632         );
633         emit Transfer(owner, _to, _value);
634         emit Lock(_to, _value, now + _afterTime);
635 
636         return true;
637     }
638 
639     function currentTime() public view returns (uint256) {
640         return now;
641     }
642 
643     function afterTime(uint256 _value) public view returns (uint256) {
644         return now + _value;
645     }
646 }