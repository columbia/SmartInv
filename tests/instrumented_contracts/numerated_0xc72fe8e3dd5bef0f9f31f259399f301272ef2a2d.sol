1 pragma solidity ^0.4.18;
2 
3 // File: contracts/InsightsNetwork1.sol
4 
5 contract InsightsNetwork1 {
6   address public owner; // Creator
7   address public successor; // May deactivate contract
8   mapping (address => uint) public balances;    // Who has what
9   mapping (address => uint) public unlockTimes; // When balances unlock
10   bool public active;
11   uint256 _totalSupply; // Sum of minted tokens
12 
13   string public constant name = "INS";
14   string public constant symbol = "INS";
15   uint8 public constant decimals = 0;
16 
17   function InsightsNetwork1() {
18     owner = msg.sender;
19     active = true;
20   }
21 
22   function register(address newTokenHolder, uint issueAmount) { // Mint tokens and assign to new owner
23     require(active);
24     require(msg.sender == owner);   // Only creator can register
25     require(balances[newTokenHolder] == 0); // Accounts can only be registered once
26 
27     _totalSupply += issueAmount;
28     Mint(newTokenHolder, issueAmount);  // Trigger event
29 
30     require(balances[newTokenHolder] < (balances[newTokenHolder] + issueAmount));   // Overflow check
31     balances[newTokenHolder] += issueAmount;
32     Transfer(address(0), newTokenHolder, issueAmount);  // Trigger event
33 
34     uint currentTime = block.timestamp; // seconds since the Unix epoch
35     uint unlockTime = currentTime + 365*24*60*60; // one year out from the current time
36     assert(unlockTime > currentTime); // check for overflow
37     unlockTimes[newTokenHolder] = unlockTime;
38   }
39 
40   function totalSupply() constant returns (uint256) {   // ERC20 compliance
41     return _totalSupply;
42   }
43 
44   function transfer(address _to, uint256 _value) returns (bool success) {   // ERC20 compliance
45     return false;
46   }
47 
48   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {    // ERC20 compliance
49     return false;
50   }
51 
52   function approve(address _spender, uint256 _value) returns (bool success) {   // ERC20 compliance
53     return false;
54   }
55 
56   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {   // ERC20 compliance
57     return 0;   // No transfer allowance
58   }
59 
60   function balanceOf(address _owner) constant returns (uint256 balance) {   // ERC20 compliance
61     return balances[_owner];
62   }
63 
64   function getUnlockTime(address _accountHolder) constant returns (uint256) {
65     return unlockTimes[_accountHolder];
66   }
67 
68   event Mint(address indexed _to, uint256 _amount);
69   event Transfer(address indexed _from, address indexed _to, uint256 _value);
70   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71 
72   function makeSuccessor(address successorAddr) {
73     require(active);
74     require(msg.sender == owner);
75     //require(successorAddr == address(0));
76     successor = successorAddr;
77   }
78 
79   function deactivate() {
80     require(active);
81     require(msg.sender == owner || (successor != address(0) && msg.sender == successor));   // Called by creator or successor
82     active = false;
83   }
84 }
85 
86 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
87 
88 /**
89  * @title Ownable
90  * @dev The Ownable contract has an owner address, and provides basic authorization control
91  * functions, this simplifies the implementation of "user permissions".
92  */
93 contract Ownable {
94   address public owner;
95 
96 
97   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99 
100   /**
101    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102    * account.
103    */
104   function Ownable() public {
105     owner = msg.sender;
106   }
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(msg.sender == owner);
113     _;
114   }
115 
116   /**
117    * @dev Allows the current owner to transfer control of the contract to a newOwner.
118    * @param newOwner The address to transfer ownership to.
119    */
120   function transferOwnership(address newOwner) public onlyOwner {
121     require(newOwner != address(0));
122     OwnershipTransferred(owner, newOwner);
123     owner = newOwner;
124   }
125 
126 }
127 
128 // File: zeppelin-solidity/contracts/math/SafeMath.sol
129 
130 /**
131  * @title SafeMath
132  * @dev Math operations with safety checks that throw on error
133  */
134 library SafeMath {
135 
136   /**
137   * @dev Multiplies two numbers, throws on overflow.
138   */
139   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140     if (a == 0) {
141       return 0;
142     }
143     uint256 c = a * b;
144     assert(c / a == b);
145     return c;
146   }
147 
148   /**
149   * @dev Integer division of two numbers, truncating the quotient.
150   */
151   function div(uint256 a, uint256 b) internal pure returns (uint256) {
152     // assert(b > 0); // Solidity automatically throws when dividing by 0
153     uint256 c = a / b;
154     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
155     return c;
156   }
157 
158   /**
159   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
160   */
161   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162     assert(b <= a);
163     return a - b;
164   }
165 
166   /**
167   * @dev Adds two numbers, throws on overflow.
168   */
169   function add(uint256 a, uint256 b) internal pure returns (uint256) {
170     uint256 c = a + b;
171     assert(c >= a);
172     return c;
173   }
174 }
175 
176 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
177 
178 /**
179  * @title ERC20Basic
180  * @dev Simpler version of ERC20 interface
181  * @dev see https://github.com/ethereum/EIPs/issues/179
182  */
183 contract ERC20Basic {
184   function totalSupply() public view returns (uint256);
185   function balanceOf(address who) public view returns (uint256);
186   function transfer(address to, uint256 value) public returns (bool);
187   event Transfer(address indexed from, address indexed to, uint256 value);
188 }
189 
190 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
191 
192 /**
193  * @title Basic token
194  * @dev Basic version of StandardToken, with no allowances.
195  */
196 contract BasicToken is ERC20Basic {
197   using SafeMath for uint256;
198 
199   mapping(address => uint256) balances;
200 
201   uint256 totalSupply_;
202 
203   /**
204   * @dev total number of tokens in existence
205   */
206   function totalSupply() public view returns (uint256) {
207     return totalSupply_;
208   }
209 
210   /**
211   * @dev transfer token for a specified address
212   * @param _to The address to transfer to.
213   * @param _value The amount to be transferred.
214   */
215   function transfer(address _to, uint256 _value) public returns (bool) {
216     require(_to != address(0));
217     require(_value <= balances[msg.sender]);
218 
219     // SafeMath.sub will throw if there is not enough balance.
220     balances[msg.sender] = balances[msg.sender].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     Transfer(msg.sender, _to, _value);
223     return true;
224   }
225 
226   /**
227   * @dev Gets the balance of the specified address.
228   * @param _owner The address to query the the balance of.
229   * @return An uint256 representing the amount owned by the passed address.
230   */
231   function balanceOf(address _owner) public view returns (uint256 balance) {
232     return balances[_owner];
233   }
234 
235 }
236 
237 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
238 
239 /**
240  * @title ERC20 interface
241  * @dev see https://github.com/ethereum/EIPs/issues/20
242  */
243 contract ERC20 is ERC20Basic {
244   function allowance(address owner, address spender) public view returns (uint256);
245   function transferFrom(address from, address to, uint256 value) public returns (bool);
246   function approve(address spender, uint256 value) public returns (bool);
247   event Approval(address indexed owner, address indexed spender, uint256 value);
248 }
249 
250 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
251 
252 /**
253  * @title Standard ERC20 token
254  *
255  * @dev Implementation of the basic standard token.
256  * @dev https://github.com/ethereum/EIPs/issues/20
257  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
258  */
259 contract StandardToken is ERC20, BasicToken {
260 
261   mapping (address => mapping (address => uint256)) internal allowed;
262 
263 
264   /**
265    * @dev Transfer tokens from one address to another
266    * @param _from address The address which you want to send tokens from
267    * @param _to address The address which you want to transfer to
268    * @param _value uint256 the amount of tokens to be transferred
269    */
270   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
271     require(_to != address(0));
272     require(_value <= balances[_from]);
273     require(_value <= allowed[_from][msg.sender]);
274 
275     balances[_from] = balances[_from].sub(_value);
276     balances[_to] = balances[_to].add(_value);
277     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
278     Transfer(_from, _to, _value);
279     return true;
280   }
281 
282   /**
283    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
284    *
285    * Beware that changing an allowance with this method brings the risk that someone may use both the old
286    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
287    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
288    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289    * @param _spender The address which will spend the funds.
290    * @param _value The amount of tokens to be spent.
291    */
292   function approve(address _spender, uint256 _value) public returns (bool) {
293     allowed[msg.sender][_spender] = _value;
294     Approval(msg.sender, _spender, _value);
295     return true;
296   }
297 
298   /**
299    * @dev Function to check the amount of tokens that an owner allowed to a spender.
300    * @param _owner address The address which owns the funds.
301    * @param _spender address The address which will spend the funds.
302    * @return A uint256 specifying the amount of tokens still available for the spender.
303    */
304   function allowance(address _owner, address _spender) public view returns (uint256) {
305     return allowed[_owner][_spender];
306   }
307 
308   /**
309    * @dev Increase the amount of tokens that an owner allowed to a spender.
310    *
311    * approve should be called when allowed[_spender] == 0. To increment
312    * allowed value is better to use this function to avoid 2 calls (and wait until
313    * the first transaction is mined)
314    * From MonolithDAO Token.sol
315    * @param _spender The address which will spend the funds.
316    * @param _addedValue The amount of tokens to increase the allowance by.
317    */
318   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
319     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
320     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
321     return true;
322   }
323 
324   /**
325    * @dev Decrease the amount of tokens that an owner allowed to a spender.
326    *
327    * approve should be called when allowed[_spender] == 0. To decrement
328    * allowed value is better to use this function to avoid 2 calls (and wait until
329    * the first transaction is mined)
330    * From MonolithDAO Token.sol
331    * @param _spender The address which will spend the funds.
332    * @param _subtractedValue The amount of tokens to decrease the allowance by.
333    */
334   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
335     uint oldValue = allowed[msg.sender][_spender];
336     if (_subtractedValue > oldValue) {
337       allowed[msg.sender][_spender] = 0;
338     } else {
339       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
340     }
341     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342     return true;
343   }
344 
345 }
346 
347 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
348 
349 /**
350  * @title Mintable token
351  * @dev Simple ERC20 Token example, with mintable token creation
352  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
353  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
354  */
355 contract MintableToken is StandardToken, Ownable {
356   event Mint(address indexed to, uint256 amount);
357   event MintFinished();
358 
359   bool public mintingFinished = false;
360 
361 
362   modifier canMint() {
363     require(!mintingFinished);
364     _;
365   }
366 
367   /**
368    * @dev Function to mint tokens
369    * @param _to The address that will receive the minted tokens.
370    * @param _amount The amount of tokens to mint.
371    * @return A boolean that indicates if the operation was successful.
372    */
373   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
374     totalSupply_ = totalSupply_.add(_amount);
375     balances[_to] = balances[_to].add(_amount);
376     Mint(_to, _amount);
377     Transfer(address(0), _to, _amount);
378     return true;
379   }
380 
381   /**
382    * @dev Function to stop minting new tokens.
383    * @return True if the operation was successful.
384    */
385   function finishMinting() onlyOwner canMint public returns (bool) {
386     mintingFinished = true;
387     MintFinished();
388     return true;
389   }
390 }
391 
392 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
393 
394 /**
395  * @title Capped token
396  * @dev Mintable token with a token cap.
397  */
398 contract CappedToken is MintableToken {
399 
400   uint256 public cap;
401 
402   function CappedToken(uint256 _cap) public {
403     require(_cap > 0);
404     cap = _cap;
405   }
406 
407   /**
408    * @dev Function to mint tokens
409    * @param _to The address that will receive the minted tokens.
410    * @param _amount The amount of tokens to mint.
411    * @return A boolean that indicates if the operation was successful.
412    */
413   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
414     require(totalSupply_.add(_amount) <= cap);
415 
416     return super.mint(_to, _amount);
417   }
418 
419 }
420 
421 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
422 
423 contract DetailedERC20 is ERC20 {
424   string public name;
425   string public symbol;
426   uint8 public decimals;
427 
428   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
429     name = _name;
430     symbol = _symbol;
431     decimals = _decimals;
432   }
433 }
434 
435 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
436 
437 /**
438  * @title Pausable
439  * @dev Base contract which allows children to implement an emergency stop mechanism.
440  */
441 contract Pausable is Ownable {
442   event Pause();
443   event Unpause();
444 
445   bool public paused = false;
446 
447 
448   /**
449    * @dev Modifier to make a function callable only when the contract is not paused.
450    */
451   modifier whenNotPaused() {
452     require(!paused);
453     _;
454   }
455 
456   /**
457    * @dev Modifier to make a function callable only when the contract is paused.
458    */
459   modifier whenPaused() {
460     require(paused);
461     _;
462   }
463 
464   /**
465    * @dev called by the owner to pause, triggers stopped state
466    */
467   function pause() onlyOwner whenNotPaused public {
468     paused = true;
469     Pause();
470   }
471 
472   /**
473    * @dev called by the owner to unpause, returns to normal state
474    */
475   function unpause() onlyOwner whenPaused public {
476     paused = false;
477     Unpause();
478   }
479 }
480 
481 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
482 
483 /**
484  * @title Pausable token
485  * @dev StandardToken modified with pausable transfers.
486  **/
487 contract PausableToken is StandardToken, Pausable {
488 
489   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
490     return super.transfer(_to, _value);
491   }
492 
493   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
494     return super.transferFrom(_from, _to, _value);
495   }
496 
497   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
498     return super.approve(_spender, _value);
499   }
500 
501   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
502     return super.increaseApproval(_spender, _addedValue);
503   }
504 
505   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
506     return super.decreaseApproval(_spender, _subtractedValue);
507   }
508 }
509 
510 // File: contracts/InsightsNetwork2Base.sol
511 
512 contract InsightsNetwork2Base is DetailedERC20("Insights Network", "INSTAR", 18), PausableToken, CappedToken{
513 
514     uint256 constant ATTOTOKEN_FACTOR = 10**18;
515 
516     address public predecessor;
517     address public successor;
518 
519     uint constant MAX_LENGTH = 1024;
520     uint constant MAX_PURCHASES = 64;
521 
522     mapping (address => uint256[]) public lockedBalances;
523     mapping (address => uint256[]) public unlockTimes;
524     mapping (address => bool) public imported;
525 
526     event Import(address indexed account, uint256 amount, uint256 unlockTime);
527 
528     function InsightsNetwork2Base() public CappedToken(300*1000000*ATTOTOKEN_FACTOR) {
529         paused = true;
530         mintingFinished = true;
531     }
532 
533     function activate(address _predecessor) public onlyOwner {
534         require(predecessor == 0);
535         require(_predecessor != 0);
536         require(predecessorDeactivated(_predecessor));
537         predecessor = _predecessor;
538         unpause();
539         mintingFinished = false;
540     }
541 
542     function lockedBalanceOf(address account) public view returns (uint256 balance) {
543         uint256 amount;
544         for (uint256 index = 0; index < lockedBalances[account].length; index++)
545             if (unlockTimes[account][index] > now)
546                 amount += lockedBalances[account][index];
547         return amount;
548     }
549 
550     function mintBatch(address[] accounts, uint256[] amounts) public onlyOwner canMint returns (bool) {
551         require(accounts.length == amounts.length);
552         require(accounts.length <= MAX_LENGTH);
553         for (uint index = 0; index < accounts.length; index++)
554             require(mint(accounts[index], amounts[index]));
555         return true;
556     }
557 
558     function mintUnlockTime(address account, uint256 amount, uint256 unlockTime) public onlyOwner canMint returns (bool) {
559         require(unlockTime > now);
560         require(lockedBalances[account].length < MAX_PURCHASES);
561         lockedBalances[account].push(amount);
562         unlockTimes[account].push(unlockTime);
563         return super.mint(account, amount);
564     }
565 
566     function mintUnlockTimeBatch(address[] accounts, uint256[] amounts, uint256 unlockTime) public onlyOwner canMint returns (bool) {
567         require(accounts.length == amounts.length);
568         require(accounts.length <= MAX_LENGTH);
569         for (uint index = 0; index < accounts.length; index++)
570             require(mintUnlockTime(accounts[index], amounts[index], unlockTime));
571         return true;
572     }
573 
574     function mintLockPeriod(address account, uint256 amount, uint256 lockPeriod) public onlyOwner canMint returns (bool) {
575         return mintUnlockTime(account, amount, now + lockPeriod);
576     }
577 
578     function mintLockPeriodBatch(address[] accounts, uint256[] amounts, uint256 lockPeriod) public onlyOwner canMint returns (bool) {
579         return mintUnlockTimeBatch(accounts, amounts, now + lockPeriod);
580     }
581 
582     function importBalance(address account) public onlyOwner canMint returns (bool);
583 
584     function importBalanceBatch(address[] accounts) public onlyOwner canMint returns (bool) {
585         require(accounts.length <= MAX_LENGTH);
586         for (uint index = 0; index < accounts.length; index++)
587             require(importBalance(accounts[index]));
588         return true;
589     }
590 
591     function transfer(address to, uint256 value) public returns (bool) {
592         require(value <= balances[msg.sender] - lockedBalanceOf(msg.sender));
593         return super.transfer(to, value);
594     }
595 
596     function transferFrom(address from, address to, uint256 value) public returns (bool) {
597         require(value <= balances[from] - lockedBalanceOf(from));
598         return super.transferFrom(from, to, value);
599     }
600 
601     function selfDestruct(address _successor) public onlyOwner whenPaused {
602         require(mintingFinished);
603         successor = _successor;
604         selfdestruct(owner);
605     }
606 
607     function predecessorDeactivated(address _predecessor) internal view onlyOwner returns (bool);
608 
609 }
610 
611 // File: contracts/InsightsNetwork3.sol
612 
613 contract InsightsNetwork3 is InsightsNetwork2Base {
614 
615     function importBalance(address account) public onlyOwner canMint returns (bool) {
616         require(!imported[account]);
617         InsightsNetwork2Base source = InsightsNetwork2Base(predecessor);
618         uint256 amount = source.balanceOf(account);
619         require(amount > 0);
620         imported[account] = true;
621         uint256 mintAmount = amount - source.lockedBalanceOf(account);
622         Import(account, mintAmount, now);
623         assert(mint(account, mintAmount));
624         amount -= mintAmount;
625         for (uint index = 0; amount > 0; index++) {
626             uint256 unlockTime = source.unlockTimes(account, index);
627             if ( unlockTime > now ) {
628                 mintAmount = source.lockedBalances(account, index);
629                 Import(account, mintAmount, unlockTime);
630                 assert(mintUnlockTime(account, mintAmount, unlockTime));
631                 amount -= mintAmount;
632             }
633         }
634         return true;
635     }
636 
637     function predecessorDeactivated(address _predecessor) internal view onlyOwner returns (bool) {
638         return InsightsNetwork2Base(_predecessor).paused() && InsightsNetwork2Base(_predecessor).mintingFinished();
639     }
640 
641 }