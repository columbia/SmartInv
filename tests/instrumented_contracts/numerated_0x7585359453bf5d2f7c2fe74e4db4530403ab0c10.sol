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
128 
129 // File: zeppelin-solidity/contracts/math/SafeMath.sol
130 
131 /**
132  * @title SafeMath
133  * @dev Math operations with safety checks that throw on error
134  */
135 library SafeMath {
136 
137   /**
138   * @dev Multiplies two numbers, throws on overflow.
139   */
140   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141     if (a == 0) {
142       return 0;
143     }
144     uint256 c = a * b;
145     assert(c / a == b);
146     return c;
147   }
148 
149   /**
150   * @dev Integer division of two numbers, truncating the quotient.
151   */
152   function div(uint256 a, uint256 b) internal pure returns (uint256) {
153     // assert(b > 0); // Solidity automatically throws when dividing by 0
154     uint256 c = a / b;
155     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156     return c;
157   }
158 
159   /**
160   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
161   */
162   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163     assert(b <= a);
164     return a - b;
165   }
166 
167   /**
168   * @dev Adds two numbers, throws on overflow.
169   */
170   function add(uint256 a, uint256 b) internal pure returns (uint256) {
171     uint256 c = a + b;
172     assert(c >= a);
173     return c;
174   }
175 }
176 
177 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
178 
179 /**
180  * @title ERC20Basic
181  * @dev Simpler version of ERC20 interface
182  * @dev see https://github.com/ethereum/EIPs/issues/179
183  */
184 contract ERC20Basic {
185   function totalSupply() public view returns (uint256);
186   function balanceOf(address who) public view returns (uint256);
187   function transfer(address to, uint256 value) public returns (bool);
188   event Transfer(address indexed from, address indexed to, uint256 value);
189 }
190 
191 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
192 
193 /**
194  * @title Basic token
195  * @dev Basic version of StandardToken, with no allowances.
196  */
197 contract BasicToken is ERC20Basic {
198   using SafeMath for uint256;
199 
200   mapping(address => uint256) balances;
201 
202   uint256 totalSupply_;
203 
204   /**
205   * @dev total number of tokens in existence
206   */
207   function totalSupply() public view returns (uint256) {
208     return totalSupply_;
209   }
210 
211   /**
212   * @dev transfer token for a specified address
213   * @param _to The address to transfer to.
214   * @param _value The amount to be transferred.
215   */
216   function transfer(address _to, uint256 _value) public returns (bool) {
217     require(_to != address(0));
218     require(_value <= balances[msg.sender]);
219 
220     // SafeMath.sub will throw if there is not enough balance.
221     balances[msg.sender] = balances[msg.sender].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     Transfer(msg.sender, _to, _value);
224     return true;
225   }
226 
227   /**
228   * @dev Gets the balance of the specified address.
229   * @param _owner The address to query the the balance of.
230   * @return An uint256 representing the amount owned by the passed address.
231   */
232   function balanceOf(address _owner) public view returns (uint256 balance) {
233     return balances[_owner];
234   }
235 
236 }
237 
238 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
239 
240 /**
241  * @title ERC20 interface
242  * @dev see https://github.com/ethereum/EIPs/issues/20
243  */
244 contract ERC20 is ERC20Basic {
245   function allowance(address owner, address spender) public view returns (uint256);
246   function transferFrom(address from, address to, uint256 value) public returns (bool);
247   function approve(address spender, uint256 value) public returns (bool);
248   event Approval(address indexed owner, address indexed spender, uint256 value);
249 }
250 
251 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
252 
253 /**
254  * @title Standard ERC20 token
255  *
256  * @dev Implementation of the basic standard token.
257  * @dev https://github.com/ethereum/EIPs/issues/20
258  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
259  */
260 contract StandardToken is ERC20, BasicToken {
261 
262   mapping (address => mapping (address => uint256)) internal allowed;
263 
264 
265   /**
266    * @dev Transfer tokens from one address to another
267    * @param _from address The address which you want to send tokens from
268    * @param _to address The address which you want to transfer to
269    * @param _value uint256 the amount of tokens to be transferred
270    */
271   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
272     require(_to != address(0));
273     require(_value <= balances[_from]);
274     require(_value <= allowed[_from][msg.sender]);
275 
276     balances[_from] = balances[_from].sub(_value);
277     balances[_to] = balances[_to].add(_value);
278     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
279     Transfer(_from, _to, _value);
280     return true;
281   }
282 
283   /**
284    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
285    *
286    * Beware that changing an allowance with this method brings the risk that someone may use both the old
287    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
288    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
289    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290    * @param _spender The address which will spend the funds.
291    * @param _value The amount of tokens to be spent.
292    */
293   function approve(address _spender, uint256 _value) public returns (bool) {
294     allowed[msg.sender][_spender] = _value;
295     Approval(msg.sender, _spender, _value);
296     return true;
297   }
298 
299   /**
300    * @dev Function to check the amount of tokens that an owner allowed to a spender.
301    * @param _owner address The address which owns the funds.
302    * @param _spender address The address which will spend the funds.
303    * @return A uint256 specifying the amount of tokens still available for the spender.
304    */
305   function allowance(address _owner, address _spender) public view returns (uint256) {
306     return allowed[_owner][_spender];
307   }
308 
309   /**
310    * @dev Increase the amount of tokens that an owner allowed to a spender.
311    *
312    * approve should be called when allowed[_spender] == 0. To increment
313    * allowed value is better to use this function to avoid 2 calls (and wait until
314    * the first transaction is mined)
315    * From MonolithDAO Token.sol
316    * @param _spender The address which will spend the funds.
317    * @param _addedValue The amount of tokens to increase the allowance by.
318    */
319   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
320     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
321     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324 
325   /**
326    * @dev Decrease the amount of tokens that an owner allowed to a spender.
327    *
328    * approve should be called when allowed[_spender] == 0. To decrement
329    * allowed value is better to use this function to avoid 2 calls (and wait until
330    * the first transaction is mined)
331    * From MonolithDAO Token.sol
332    * @param _spender The address which will spend the funds.
333    * @param _subtractedValue The amount of tokens to decrease the allowance by.
334    */
335   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
336     uint oldValue = allowed[msg.sender][_spender];
337     if (_subtractedValue > oldValue) {
338       allowed[msg.sender][_spender] = 0;
339     } else {
340       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
341     }
342     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343     return true;
344   }
345 
346 }
347 
348 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
349 
350 /**
351  * @title Mintable token
352  * @dev Simple ERC20 Token example, with mintable token creation
353  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
354  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
355  */
356 contract MintableToken is StandardToken, Ownable {
357   event Mint(address indexed to, uint256 amount);
358   event MintFinished();
359 
360   bool public mintingFinished = false;
361 
362 
363   modifier canMint() {
364     require(!mintingFinished);
365     _;
366   }
367 
368   /**
369    * @dev Function to mint tokens
370    * @param _to The address that will receive the minted tokens.
371    * @param _amount The amount of tokens to mint.
372    * @return A boolean that indicates if the operation was successful.
373    */
374   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
375     totalSupply_ = totalSupply_.add(_amount);
376     balances[_to] = balances[_to].add(_amount);
377     Mint(_to, _amount);
378     Transfer(address(0), _to, _amount);
379     return true;
380   }
381 
382   /**
383    * @dev Function to stop minting new tokens.
384    * @return True if the operation was successful.
385    */
386   function finishMinting() onlyOwner canMint public returns (bool) {
387     mintingFinished = true;
388     MintFinished();
389     return true;
390   }
391 }
392 
393 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
394 
395 /**
396  * @title Capped token
397  * @dev Mintable token with a token cap.
398  */
399 contract CappedToken is MintableToken {
400 
401   uint256 public cap;
402 
403   function CappedToken(uint256 _cap) public {
404     require(_cap > 0);
405     cap = _cap;
406   }
407 
408   /**
409    * @dev Function to mint tokens
410    * @param _to The address that will receive the minted tokens.
411    * @param _amount The amount of tokens to mint.
412    * @return A boolean that indicates if the operation was successful.
413    */
414   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
415     require(totalSupply_.add(_amount) <= cap);
416 
417     return super.mint(_to, _amount);
418   }
419 
420 }
421 
422 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
423 
424 contract DetailedERC20 is ERC20 {
425   string public name;
426   string public symbol;
427   uint8 public decimals;
428 
429   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
430     name = _name;
431     symbol = _symbol;
432     decimals = _decimals;
433   }
434 }
435 
436 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
437 
438 /**
439  * @title Pausable
440  * @dev Base contract which allows children to implement an emergency stop mechanism.
441  */
442 contract Pausable is Ownable {
443   event Pause();
444   event Unpause();
445 
446   bool public paused = false;
447 
448 
449   /**
450    * @dev Modifier to make a function callable only when the contract is not paused.
451    */
452   modifier whenNotPaused() {
453     require(!paused);
454     _;
455   }
456 
457   /**
458    * @dev Modifier to make a function callable only when the contract is paused.
459    */
460   modifier whenPaused() {
461     require(paused);
462     _;
463   }
464 
465   /**
466    * @dev called by the owner to pause, triggers stopped state
467    */
468   function pause() onlyOwner whenNotPaused public {
469     paused = true;
470     Pause();
471   }
472 
473   /**
474    * @dev called by the owner to unpause, returns to normal state
475    */
476   function unpause() onlyOwner whenPaused public {
477     paused = false;
478     Unpause();
479   }
480 }
481 
482 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
483 
484 /**
485  * @title Pausable token
486  * @dev StandardToken modified with pausable transfers.
487  **/
488 contract PausableToken is StandardToken, Pausable {
489 
490   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
491     return super.transfer(_to, _value);
492   }
493 
494   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
495     return super.transferFrom(_from, _to, _value);
496   }
497 
498   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
499     return super.approve(_spender, _value);
500   }
501 
502   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
503     return super.increaseApproval(_spender, _addedValue);
504   }
505 
506   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
507     return super.decreaseApproval(_spender, _subtractedValue);
508   }
509 }
510 
511 // File: contracts/InsightsNetwork2Base.sol
512 
513 contract InsightsNetwork2Base is DetailedERC20("Insights Network", "INSTAR", 18), PausableToken, CappedToken{
514 
515     uint256 constant ATTOTOKEN_FACTOR = 10**18;
516 
517     address public predecessor;
518     address public successor;
519 
520     uint constant MAX_PURCHASES = 64;
521     mapping (address => uint256[]) public lockedBalances;
522     mapping (address => uint256[]) public unlockTimes;
523     mapping (address => bool) public imported;
524 
525     event Import(address indexed account, uint256 amount, uint256 unlockTime);    
526 
527     function InsightsNetwork2Base() public CappedToken(300*1000000*ATTOTOKEN_FACTOR) {
528         paused = true;
529         mintingFinished = true;
530     }
531 
532     function activate(address _predecessor) public onlyOwner {
533         require(predecessor == 0);
534         require(_predecessor != 0);
535         require(predecessorDeactivated(_predecessor));
536         predecessor = _predecessor;
537         unpause();
538         mintingFinished = false;
539     }
540 
541     function lockedBalanceOf(address account) public view returns (uint256 balance) {
542         uint256 amount;
543         for (uint256 index = 0; index < lockedBalances[account].length; index++)
544             if (unlockTimes[account][index] > now)
545                 amount += lockedBalances[account][index];
546         return amount;
547     }
548 
549     function mintUnlockTime(address account, uint256 amount, uint256 unlockTime) public onlyOwner canMint returns (bool) {
550         require(unlockTime > now);
551         require(lockedBalances[account].length < MAX_PURCHASES);
552         lockedBalances[account].push(amount);
553         unlockTimes[account].push(unlockTime);
554         return super.mint(account, amount);
555     }
556 
557     function mintLockPeriod(address account, uint256 amount, uint256 lockPeriod) public onlyOwner canMint returns (bool) {
558         return mintUnlockTime(account, amount, now + lockPeriod);
559     }
560 
561     function mint(address account, uint256 amount) public onlyOwner canMint returns (bool) {
562         return mintLockPeriod(account, amount, 1 years);
563     }
564 
565     function importBalanceOf(address account) public onlyOwner canMint returns (bool);
566 
567     function importBalancesOf(address[] accounts) public onlyOwner canMint returns (bool) {
568         require(accounts.length <= 1024);
569         for (uint index = 0; index < accounts.length; index++)
570             require(importBalanceOf(accounts[index]));
571         return true;
572     }
573 
574     function transfer(address to, uint256 value) public returns (bool) {
575         require(value <= balances[msg.sender] - lockedBalanceOf(msg.sender));
576         return super.transfer(to, value);
577     }
578 
579     function transferFrom(address from, address to, uint256 value) public returns (bool) {
580         require(value <= balances[from] - lockedBalanceOf(from));
581         return super.transferFrom(from, to, value);
582     }
583 
584     function selfDestruct(address _successor) public onlyOwner whenPaused {
585         require(mintingFinished);
586         successor = _successor;
587         selfdestruct(owner);
588     }
589 
590     function predecessorDeactivated(address _predecessor) internal onlyOwner returns (bool);
591 
592 }
593 
594 // File: contracts/InsightsNetwork2.sol
595 
596 contract InsightsNetwork2 is InsightsNetwork2Base {
597 
598     function importBalanceOf(address account) public onlyOwner canMint returns (bool) {
599         require(!imported[account]);
600         uint256 amount = InsightsNetwork1(predecessor).balances(account)*ATTOTOKEN_FACTOR;
601         require(amount > 0);
602         uint256 unlockTime = InsightsNetwork1(predecessor).unlockTimes(account);
603         imported[account] = true;
604         Import(account, amount, unlockTime);
605         return mintUnlockTime(account, amount, unlockTime);
606     }
607 
608     function relock(address account, uint256 amount, uint256 oldUnlockTime, int256 lockPeriod) public onlyOwner canMint returns (bool) {
609         // Relock tokens for given period, defaulting to 1 year
610         if (lockPeriod < 0)
611             lockPeriod = 1 years;
612         for (uint index = 0; index < lockedBalances[account].length; index++)
613             if (lockedBalances[account][index] == amount && unlockTimes[account][index] == oldUnlockTime) {
614                 unlockTimes[account][index] = now + uint256(lockPeriod);
615                 return true;
616             }
617         return false;
618     }
619 
620     function relockPart(address account, uint256 amount, uint256 unlockTime, uint256 partAmount, int256 partLockPeriod) public onlyOwner canMint returns (bool) {
621         // Relock part of matching token balance for given period, defaulting to 1 year
622         require(partAmount > 0);
623         require(partAmount < amount);
624         if (partLockPeriod < 0)
625             partLockPeriod = 1 years;
626         for (uint index = 0; index < lockedBalances[account].length; index++)
627             if (lockedBalances[account][index] == amount && unlockTimes[account][index] == unlockTime) {
628                 lockedBalances[account][index] -= partAmount;
629                 lockedBalances[account].push(partAmount);
630                 unlockTimes[account].push(now + uint256(partLockPeriod));
631                 return true;
632             }
633         return false;
634     }
635 
636     function predecessorDeactivated(address _predecessor) internal onlyOwner returns (bool) {
637         return !InsightsNetwork1(_predecessor).active();
638     }
639 
640 }