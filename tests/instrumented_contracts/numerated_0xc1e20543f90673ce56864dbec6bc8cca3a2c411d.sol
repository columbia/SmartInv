1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    */
39   function renounceOwnership() public onlyOwner {
40     emit OwnershipRenounced(owner);
41     owner = address(0);
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param _newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address _newOwner) public onlyOwner {
49     _transferOwnership(_newOwner);
50   }
51 
52   /**
53    * @dev Transfers control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function _transferOwnership(address _newOwner) internal {
57     require(_newOwner != address(0));
58     emit OwnershipTransferred(owner, _newOwner);
59     owner = _newOwner;
60   }
61 }
62 
63 /**
64  * @title SafeMath
65  * @dev Math operations with safety checks that throw on error
66  */
67 library SafeMath {
68 
69   /**
70   * @dev Multiplies two numbers, throws on overflow.
71   */
72   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
74     // benefit is lost if 'b' is also tested.
75     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
76     if (a == 0) {
77       return 0;
78     }
79 
80     c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     // uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return a / b;
93   }
94 
95   /**
96   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
107     c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 
113 
114 /**
115  * @title ERC20Basic
116  * @dev Simpler version of ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/179
118  */
119 contract ERC20Basic {
120   function totalSupply() public view returns (uint256);
121   function balanceOf(address who) public view returns (uint256);
122   function transfer(address to, uint256 value) public returns (bool);
123   event Transfer(address indexed from, address indexed to, uint256 value);
124 }
125 
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender)
133     public view returns (uint256);
134 
135   function transferFrom(address from, address to, uint256 value)
136     public returns (bool);
137 
138   function approve(address spender, uint256 value) public returns (bool);
139   event Approval(
140     address indexed owner,
141     address indexed spender,
142     uint256 value
143   );
144 }
145 
146 
147 /**
148  * @title Basic token
149  * @dev Basic version of StandardToken, with no allowances.
150  */
151 contract BasicToken is ERC20Basic {
152   using SafeMath for uint256;
153 
154   mapping(address => uint256) balances;
155 
156   uint256 totalSupply_;
157 
158   /**
159   * @dev total number of tokens in existence
160   */
161   function totalSupply() public view returns (uint256) {
162     return totalSupply_;
163   }
164 
165   /**
166   * @dev transfer token for a specified address
167   * @param _to The address to transfer to.
168   * @param _value The amount to be transferred.
169   */
170   function transfer(address _to, uint256 _value) public returns (bool) {
171     //require(_to != address(0));
172     require(_value <= balances[msg.sender]);
173 
174     balances[msg.sender] = balances[msg.sender].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     emit Transfer(msg.sender, _to, _value);
177     return true;
178   }
179 
180   /**
181   * @dev Gets the balance of the specified address.
182   * @param _owner The address to query the the balance of.
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address _owner) public view returns (uint256) {
186     return balances[_owner];
187   }
188 
189 }
190 
191 
192 /**
193  * @title Standard ERC20 token
194  *
195  * @dev Implementation of the basic standard token.
196  * @dev https://github.com/ethereum/EIPs/issues/20
197  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
198  */
199 contract StandardToken is ERC20, BasicToken {
200 
201   mapping (address => mapping (address => uint256)) internal allowed;
202 
203 
204   /**
205    * @dev Transfer tokens from one address to another
206    * @param _from address The address which you want to send tokens from
207    * @param _to address The address which you want to transfer to
208    * @param _value uint256 the amount of tokens to be transferred
209    */
210   function transferFrom(
211     address _from,
212     address _to,
213     uint256 _value
214   )
215     public
216     returns (bool)
217   {
218     require(_to != address(0));
219     require(_value <= balances[_from]);
220     require(_value <= allowed[_from][msg.sender]);
221 
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     emit Transfer(_from, _to, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231    *
232    * Beware that changing an allowance with this method brings the risk that someone may use both the old
233    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    * @param _spender The address which will spend the funds.
237    * @param _value The amount of tokens to be spent.
238    */
239   function approve(address _spender, uint256 _value) public returns (bool) {
240     allowed[msg.sender][_spender] = _value;
241     emit Approval(msg.sender, _spender, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(
252     address _owner,
253     address _spender
254    )
255     public
256     view
257     returns (uint256)
258   {
259     return allowed[_owner][_spender];
260   }
261 
262   /**
263    * @dev Increase the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To increment
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _addedValue The amount of tokens to increase the allowance by.
271    */
272   function increaseApproval(
273     address _spender,
274     uint _addedValue
275   )
276     public
277     returns (bool)
278   {
279     allowed[msg.sender][_spender] = (
280       allowed[msg.sender][_spender].add(_addedValue));
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285   /**
286    * @dev Decrease the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To decrement
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _subtractedValue The amount of tokens to decrease the allowance by.
294    */
295   function decreaseApproval(
296     address _spender,
297     uint _subtractedValue
298   )
299     public
300     returns (bool)
301   {
302     uint oldValue = allowed[msg.sender][_spender];
303     if (_subtractedValue > oldValue) {
304       allowed[msg.sender][_spender] = 0;
305     } else {
306       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
307     }
308     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312 }
313 
314 
315 /**
316  * @title Burnable Token
317  * @dev Token that can be irreversibly burned (destroyed).
318  */
319 contract BurnableToken is BasicToken {
320 
321   event Burn(address indexed burner, uint256 value);
322 
323   /**
324    * @dev Burns a specific amount of tokens.
325    * @param _value The amount of token to be burned.
326    */
327   function burn(uint256 _value) public {
328     _burn(msg.sender, _value);
329   }
330 
331   function _burn(address _who, uint256 _value) internal {
332     require(_value <= balances[_who]);
333     // no need to require value <= totalSupply, since that would imply the
334     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
335 
336     balances[_who] = balances[_who].sub(_value);
337     totalSupply_ = totalSupply_.sub(_value);
338     emit Burn(_who, _value);
339     emit Transfer(_who, address(0), _value);
340   }
341 }
342 /**
343  * @title Pausable
344  * @dev Base contract which allows children to implement an emergency stop mechanism.
345  */
346 contract Pausable is Ownable {
347   event Pause();
348   event Unpause();
349 
350   bool public paused = false;
351 
352 
353   /**
354    * @dev Modifier to make a function callable only when the contract is not paused.
355    */
356   modifier whenNotPaused() {
357     require(!paused);
358     _;
359   }
360 
361   /**
362    * @dev Modifier to make a function callable only when the contract is paused.
363    */
364   modifier whenPaused() {
365     require(paused);
366     _;
367   }
368 
369   /**
370    * @dev called by the owner to pause, triggers stopped state
371    */
372   function pause() public onlyOwner whenNotPaused {
373     paused = true;
374     emit Pause();
375   }
376 
377   /**
378    * @dev called by the owner to unpause, returns to normal state
379    */
380   function unpause() public onlyOwner whenPaused {
381     paused = false;
382     emit Unpause();
383   }
384 }
385 
386 /**
387  * @title Pausable token
388  * @dev StandardToken modified with pausable transfers.
389  **/
390 contract PausableToken is StandardToken, Pausable {
391 
392   function transfer(
393     address _to,
394     uint256 _value
395   )
396     public
397     whenNotPaused
398     returns (bool)
399   {
400     return super.transfer(_to, _value);
401   }
402 
403   function transferFrom(
404     address _from,
405     address _to,
406     uint256 _value
407   )
408     public
409     whenNotPaused
410     returns (bool)
411   {
412     return super.transferFrom(_from, _to, _value);
413   }
414 
415   function approve(
416     address _spender,
417     uint256 _value
418   )
419     public
420     whenNotPaused
421     returns (bool)
422   {
423     return super.approve(_spender, _value);
424   }
425 
426   function increaseApproval(
427     address _spender,
428     uint _addedValue
429   )
430     public
431     whenNotPaused
432     returns (bool success)
433   {
434     return super.increaseApproval(_spender, _addedValue);
435   }
436 
437   function decreaseApproval(
438     address _spender,
439     uint _subtractedValue
440   )
441     public
442     whenNotPaused
443     returns (bool success)
444   {
445     return super.decreaseApproval(_spender, _subtractedValue);
446   }
447 }
448 
449 
450 
451 /**
452  * @title Mintable token
453  * @dev Simple ERC20 Token example, with mintable token creation
454  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
455  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
456  */
457 contract MintableToken is StandardToken, Ownable {
458   event Mint(address indexed to, uint256 amount);
459   event MintFinished();
460 
461   bool public mintingFinished = false;
462 
463 
464   modifier canMint() {
465     require(!mintingFinished);
466     _;
467   }
468 
469   modifier hasMintPermission() {
470     require(msg.sender == owner);
471     _;
472   }
473 
474   /**
475    * @dev Function to mint tokens
476    * @param _to The address that will receive the minted tokens.
477    * @param _amount The amount of tokens to mint.
478    * @return A boolean that indicates if the operation was successful.
479    */
480   function mint(
481     address _to,
482     uint256 _amount
483   )
484     hasMintPermission
485     canMint
486     public
487     returns (bool)
488   {
489     totalSupply_ = totalSupply_.add(_amount);
490     balances[_to] = balances[_to].add(_amount);
491     emit Mint(_to, _amount);
492     emit Transfer(address(0), _to, _amount);
493     return true;
494   }
495 
496   /**
497    * @dev Function to stop minting new tokens.
498    * @return True if the operation was successful.
499    */
500   function finishMinting() onlyOwner canMint public returns (bool) {
501     mintingFinished = true;
502     emit MintFinished();
503     return true;
504   }
505 }
506 
507 
508 
509 
510 
511 
512 
513 
514 contract Token  is StandardToken, PausableToken , BurnableToken, MintableToken {
515   mapping(address => bool) blacklist;
516   uint256 public dayTimeStamp = 89280;
517 
518   event RefreshLockUp(address addr, uint256 date, uint256 amount);
519   event AddLock(address indexed to, uint256 time, uint256 amount);
520 
521 
522 	struct LockAccount {
523 	  uint256 unlockDate;
524 		uint256 amount;
525     bool div;
526     uint day;
527     uint256 unlockAmount;
528 	}
529   
530 
531  struct LockState {
532     uint256 latestReleaseTime;
533     LockAccount[] locks; 
534   }
535 
536 	mapping (address => LockAccount) public lockAccounts;
537   mapping (address => LockState) public multiLockAccounts;
538 
539 
540 
541   bool public noLocked = false;
542   string public  name; 
543   string public  symbol; 
544   uint8 public decimals;
545 
546 
547     constructor( uint256 _initialSupply, string _name, string _symbol, uint8 _decimals,address admin) public {
548         owner = msg.sender;
549         totalSupply_ = _initialSupply;
550         balances[admin] = _initialSupply;
551         name = _name;
552         symbol = _symbol;
553         decimals = _decimals;
554     }
555 
556     function transfer(address _to, uint256 _value) public whenNotPaused canTransfer(msg.sender, _value) returns (bool) {
557       refreshLockUp(msg.sender);
558       require(noLocked || (balanceOf(msg.sender).sub(lockAccounts[msg.sender].amount)) >= _value);
559       if (_to == address(0)) {
560         require(msg.sender == owner);
561         totalSupply_ = totalSupply_.sub(_value);
562       }
563 
564       super.transfer(_to, _value);
565     }
566 
567   function addLock(address _addr, uint256 _value, uint256 _release_time) onlyOwner public {
568     require(_value > 0);
569     require(_release_time > now);
570 
571     LockState storage lockState = multiLockAccounts[_addr];
572     if (_release_time > lockState.latestReleaseTime) {
573       lockState.latestReleaseTime = _release_time;
574     }
575     lockState.locks.push(LockAccount(_release_time, _value,false,0,0));
576 
577     emit AddLock(_addr, _release_time, _value);
578   }
579 
580   function clearLock(address _addr) onlyOwner {
581     uint256 i;
582     LockState storage lockState = multiLockAccounts[_addr];
583     for (i=0; i<lockState.locks.length; i++) {
584       lockState.locks[i].amount = 0;
585       lockState.locks[i].unlockDate = 0;
586     }
587   }
588 
589   function getLockAmount(address _addr) view public returns (uint256 locked) {
590     uint256 i;
591     uint256 amt;
592     uint256 time;
593     uint256 lock = 0;
594 
595     LockState storage lockState = multiLockAccounts[_addr];
596     if (lockState.latestReleaseTime < now) {
597       return 0;
598     }
599 
600     for (i=0; i<lockState.locks.length; i++) {
601       amt = lockState.locks[i].amount;
602       time = lockState.locks[i].unlockDate;
603 
604       if (time > now) {
605         lock = lock.add(amt);
606       }
607     }
608 
609     return lock;
610   }
611 
612 
613 
614   function lock(address addr) public onlyOwner returns (bool) {
615     require(blacklist[addr] == false);
616     blacklist[addr] = true;  
617     return true;
618   }
619 
620   function unlock(address addr) public onlyOwner returns (bool) {
621     require(blacklist[addr] == true);
622     blacklist[addr] = false; 
623     return true;
624   }
625 
626   function showlock(address addr) public view returns (bool) {
627     return blacklist[addr];
628   }
629 
630   
631   function Now() public view returns (uint256){
632     return now;
633   }
634 
635   function () public payable {
636     revert();
637   }
638 
639   function unlockAllTokens() public onlyOwner {
640     noLocked = true;
641   }
642 
643     function relockAllTokens() public onlyOwner {
644     noLocked = false;
645   }
646 
647   function showTimeLockValue(address _user)
648   public view returns (uint256 ,uint256, bool, uint256, uint256)
649   {
650     return (lockAccounts[_user].amount, lockAccounts[_user].unlockDate, lockAccounts[_user].div, lockAccounts[_user].day, lockAccounts[_user].unlockAmount);
651   }
652 
653 
654 
655   function addTimeLockAddress(address _owner, uint256 _amount, uint256 _unlockDate, bool _div,
656   uint _day, uint256 _unlockAmount)
657         public
658         onlyOwner
659         returns(bool)
660     {
661         require(balanceOf(_owner) >= _amount);
662         require(_unlockDate >= now);
663 
664         lockAccounts[_owner].amount = _amount;
665         lockAccounts[_owner].unlockDate = _unlockDate;
666         lockAccounts[_owner].div = _div;
667         lockAccounts[_owner].day = _day;
668         lockAccounts[_owner].unlockAmount = _unlockAmount;
669 
670         return true;
671     }
672 
673   modifier canTransfer(address _sender, uint256 _value) {
674     require(blacklist[_sender] == false);
675     require(noLocked || lockAccounts[_sender].unlockDate < now || (balanceOf(msg.sender).sub(lockAccounts[msg.sender].amount)) >= _value);
676     require(balanceOf(msg.sender).sub(getLockAmount(msg.sender)) >= _value);
677     _;
678   }
679 
680   function refreshLockUp(address _sender) {
681     if (lockAccounts[_sender].div && lockAccounts[_sender].amount > 0) {
682       uint current = now;
683       if ( current >= lockAccounts[_sender].unlockDate) {
684           uint date = current.sub(lockAccounts[_sender].unlockDate);
685           lockAccounts[_sender].amount = lockAccounts[_sender].amount.sub(lockAccounts[_sender].unlockAmount);
686           if ( date.div(lockAccounts[_sender].day.mul(dayTimeStamp)) >= 1 && lockAccounts[_sender].amount > 0 ) {
687             if (lockAccounts[_sender].unlockAmount.mul(date.div(lockAccounts[_sender].day.mul(dayTimeStamp))) <= lockAccounts[_sender].amount) {
688             lockAccounts[_sender].amount = lockAccounts[_sender].amount.sub(lockAccounts[_sender].unlockAmount.mul(date.div(lockAccounts[_sender].day.mul(dayTimeStamp))));
689             } else {
690               lockAccounts[_sender].amount = 0;
691             }
692           }
693           if ( lockAccounts[_sender].amount > 0 ) {
694             lockAccounts[_sender].unlockDate = current.add(dayTimeStamp.mul(lockAccounts[_sender].day)).sub(date % dayTimeStamp.mul(lockAccounts[_sender].day));
695           } else {
696             lockAccounts[_sender].div = false;
697             lockAccounts[_sender].unlockDate = 0;
698           }    
699       }
700       emit RefreshLockUp(_sender, lockAccounts[_sender].unlockDate, lockAccounts[_sender].amount);
701 
702     }
703   }
704   
705   
706 
707 
708   function totalBurn() public view returns(uint256) {
709 		return balanceOf(address(0));
710 	}
711 
712 
713 
714 }