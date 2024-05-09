1 pragma solidity ^0.4.23;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
94 
95 /**
96  * @title Pausable
97  * @dev Base contract which allows children to implement an emergency stop mechanism.
98  */
99 contract Pausable is Ownable {
100   event Pause();
101   event Unpause();
102 
103   bool public paused = false;
104 
105 
106   /**
107    * @dev Modifier to make a function callable only when the contract is not paused.
108    */
109   modifier whenNotPaused() {
110     require(!paused);
111     _;
112   }
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is paused.
116    */
117   modifier whenPaused() {
118     require(paused);
119     _;
120   }
121 
122   /**
123    * @dev called by the owner to pause, triggers stopped state
124    */
125   function pause() onlyOwner whenNotPaused public {
126     paused = true;
127     emit Pause();
128   }
129 
130   /**
131    * @dev called by the owner to unpause, returns to normal state
132    */
133   function unpause() onlyOwner whenPaused public {
134     paused = false;
135     emit Unpause();
136   }
137 }
138 
139 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
140 
141 /**
142  * @title ERC20Basic
143  * @dev Simpler version of ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/179
145  */
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address who) public view returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic {
160   using SafeMath for uint256;
161 
162   mapping(address => uint256) balances;
163 
164   uint256 totalSupply_;
165 
166   /**
167   * @dev total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181 
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     emit Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256) {
194     return balances[_owner];
195   }
196 
197 }
198 
199 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
200 
201 /**
202  * @title ERC20 interface
203  * @dev see https://github.com/ethereum/EIPs/issues/20
204  */
205 contract ERC20 is ERC20Basic {
206   function allowance(address owner, address spender) public view returns (uint256);
207   function transferFrom(address from, address to, uint256 value) public returns (bool);
208   function approve(address spender, uint256 value) public returns (bool);
209   event Approval(address indexed owner, address indexed spender, uint256 value);
210 }
211 
212 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * @dev https://github.com/ethereum/EIPs/issues/20
219  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param _from address The address which you want to send tokens from
229    * @param _to address The address which you want to transfer to
230    * @param _value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
233     require(_to != address(0));
234     require(_value <= balances[_from]);
235     require(_value <= allowed[_from][msg.sender]);
236 
237     balances[_from] = balances[_from].sub(_value);
238     balances[_to] = balances[_to].add(_value);
239     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
240     emit Transfer(_from, _to, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
246    *
247    * Beware that changing an allowance with this method brings the risk that someone may use both the old
248    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
249    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
250    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251    * @param _spender The address which will spend the funds.
252    * @param _value The amount of tokens to be spent.
253    */
254   function approve(address _spender, uint256 _value) public returns (bool) {
255     allowed[msg.sender][_spender] = _value;
256     emit Approval(msg.sender, _spender, _value);
257     return true;
258   }
259 
260   /**
261    * @dev Function to check the amount of tokens that an owner allowed to a spender.
262    * @param _owner address The address which owns the funds.
263    * @param _spender address The address which will spend the funds.
264    * @return A uint256 specifying the amount of tokens still available for the spender.
265    */
266   function allowance(address _owner, address _spender) public view returns (uint256) {
267     return allowed[_owner][_spender];
268   }
269 
270   /**
271    * @dev Increase the amount of tokens that an owner allowed to a spender.
272    *
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
281     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
282     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286   /**
287    * @dev Decrease the amount of tokens that an owner allowed to a spender.
288    *
289    * approve should be called when allowed[_spender] == 0. To decrement
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _subtractedValue The amount of tokens to decrease the allowance by.
295    */
296   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
310 
311 /**
312  * @title Pausable token
313  * @dev StandardToken modified with pausable transfers.
314  **/
315 contract PausableToken is StandardToken, Pausable {
316 
317   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
318     return super.transfer(_to, _value);
319   }
320 
321   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
322     return super.transferFrom(_from, _to, _value);
323   }
324 
325   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
326     return super.approve(_spender, _value);
327   }
328 
329   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
330     return super.increaseApproval(_spender, _addedValue);
331   }
332 
333   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
334     return super.decreaseApproval(_spender, _subtractedValue);
335   }
336 }
337 
338 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
339 
340 /**
341  * @title SafeERC20
342  * @dev Wrappers around ERC20 operations that throw on failure.
343  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
344  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
345  */
346 library SafeERC20 {
347   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
348     assert(token.transfer(to, value));
349   }
350 
351   function safeTransferFrom(
352     ERC20 token,
353     address from,
354     address to,
355     uint256 value
356   )
357     internal
358   {
359     assert(token.transferFrom(from, to, value));
360   }
361 
362   function safeApprove(ERC20 token, address spender, uint256 value) internal {
363     assert(token.approve(spender, value));
364   }
365 }
366 
367 // File: contracts/EubChainIco.sol
368 
369 contract EubChainIco is PausableToken {
370 
371   using SafeMath for uint;
372   using SafeMath for uint256;
373   using SafeERC20 for StandardToken;
374 
375   string public name = 'EUB Chain';
376   string public symbol = 'EUBC';
377   uint8 public decimals = 8;
378 
379   uint256 public totalSupply = 1000000000 * (uint256(10) ** decimals);  // 1 billion tokens
380 
381   uint public startTime;  // contract deployed timestamp
382 
383   uint256 public tokenSold = 0; // total token sold
384 
385   uint8 private teamShare = 10; // 10 percent
386   uint8 private teamExtraShare = 2; // 2 percent
387   uint8 private communityShare = 10; // 10 percent
388   uint8 private foundationShare = 10; // 10 percent
389   uint8 private operationShare = 40; // 40 percent
390 
391   uint8 private icoShare = 30; // 30 percent
392   uint256 private icoCap = totalSupply.mul(icoShare).div(100);
393 
394   uint256 private teamLockPeriod = 365 days;
395   uint256 private minVestLockMonths = 3;
396 
397   address private fundsWallet;
398   address private teamWallet; // for team, lock for 1 year (can not transfer)
399   address private communityWallet; // for community group
400   address private foundationWallet; // for the foundation group
401 
402   struct Locking {
403     uint256 amount;
404     uint endTime;
405   }
406   struct Vesting {
407     uint256 amount;
408     uint startTime;
409     uint lockMonths;
410     uint256 released;
411   }
412 
413   mapping (address => Locking) private lockingMap;
414   mapping (address => Vesting) private vestingMap;
415 
416   event VestTransfer(
417     address indexed from,
418     address indexed to,
419     uint256 amount, 
420     uint startTime, 
421     uint lockMonths
422   );
423   event Release(address indexed to, uint256 amount);
424 
425   /*
426     Contract constructor
427 
428     @param _fundsWallet - funding wallet address
429     @param _teamWallet - team wallet address
430 
431     @return address of created contract
432   */
433   constructor () public {
434 
435     startTime = now;
436     uint teamLockEndTime = startTime.add(teamLockPeriod);
437 
438     // save wallet addresses
439     fundsWallet = 0x1D64D9957e54711bf681985dB11Ac4De6508d2d8;
440     teamWallet = 0xe0f58e3b40d5B97aa1C72DD4853cb462E8628386;
441     communityWallet = 0x12bEfdd7D64312353eA0Cb0803b14097ee4cE28F;
442     foundationWallet = 0x8e037d80dD9FF654a17A4a009B49BfB71a992Cab;
443 
444     // calculate token/allocation for each wallet type
445     uint256 teamTokens = totalSupply.mul(teamShare).div(100);
446     uint256 teamExtraTokens = totalSupply.mul(teamExtraShare).div(100);
447     uint256 communityTokens = totalSupply.mul(communityShare).div(100);
448     uint256 foundationTokens = totalSupply.mul(foundationShare).div(100);
449     uint256 operationTokens = totalSupply.mul(operationShare).div(100);
450 
451     // team wallet enter vesting period after lock period
452     Vesting storage teamVesting = vestingMap[teamWallet];
453     teamVesting.amount = teamTokens;
454     teamVesting.startTime = teamLockEndTime;
455     teamVesting.lockMonths = 6;
456     emit VestTransfer(0x0, teamWallet, teamTokens, teamLockEndTime, teamVesting.lockMonths);
457 
458     // transfer tokens to wallets
459     balances[communityWallet] = communityTokens;
460     emit Transfer(0x0, communityWallet, communityTokens);
461     balances[foundationWallet] = foundationTokens;
462     emit Transfer(0x0, foundationWallet, foundationTokens);
463 
464     // transfer extra tokens from community wallet to team wallet
465     balances[communityWallet] = balances[communityWallet].sub(teamExtraTokens);
466     balances[teamWallet] = balances[teamWallet].add(teamExtraTokens);
467     emit Transfer(communityWallet, teamWallet, teamExtraTokens);
468   
469     // assign the rest to the funds wallet
470     uint256 restOfTokens = (
471       totalSupply
472         .sub(teamTokens)
473         .sub(communityTokens)
474         .sub(foundationTokens)
475         .sub(operationTokens)
476     );
477     balances[fundsWallet] = restOfTokens;
478     emit Transfer(0x0, fundsWallet, restOfTokens);
479     
480   }
481 
482   /*
483     transfer vested tokens to receiver with lock period in months
484 
485     @param _to - address of token receiver 
486     @param _amount - amount of token allocate 
487     @param _lockMonths - number of months to vest
488 
489     @return true if the transfer is done
490   */
491   function vestedTransfer(address _to, uint256 _amount, uint _lockMonths) public whenNotPaused onlyPayloadSize(3 * 32) returns (bool) {
492     require(
493       msg.sender == fundsWallet ||
494       msg.sender == teamWallet
495     );
496   
497     // minimum vesting 3 months
498     require(_lockMonths >= minVestLockMonths);
499 
500     // make sure it is a brand new vesting on the address
501     Vesting storage vesting = vestingMap[_to];
502     require(vesting.amount == 0);
503 
504     if (msg.sender == fundsWallet) {
505       // check if token amount exceeds ico token cap
506       require(allowPurchase(_amount));
507       require(isPurchaseWithinCap(tokenSold, _amount));
508     
509       // check if msg.sender allow to send the amount
510       require(allowTransfer(msg.sender, _amount));
511 
512       uint256 transferAmount = _amount.mul(15).div(100);
513       uint256 vestingAmount = _amount.sub(transferAmount);
514 
515       vesting.amount = vestingAmount;
516       vesting.startTime = now;
517       vesting.lockMonths = _lockMonths;
518 
519       emit VestTransfer(msg.sender, _to, vesting.amount, vesting.startTime, _lockMonths);
520 
521       balances[msg.sender] = balances[msg.sender].sub(_amount);
522       tokenSold = tokenSold.add(_amount);
523 
524       balances[_to] = balances[_to].add(transferAmount);
525       emit Transfer(msg.sender, _to, transferAmount);
526     } else if (msg.sender == teamWallet) {
527       Vesting storage teamVesting = vestingMap[teamWallet];
528 
529       require(now < teamVesting.startTime);
530       require(
531         teamVesting.amount.sub(teamVesting.released) > _amount
532       );
533 
534       teamVesting.amount = teamVesting.amount.sub(_amount);
535 
536       vesting.amount = _amount;
537       vesting.startTime = teamVesting.startTime;
538       vesting.lockMonths = _lockMonths;
539 
540       emit VestTransfer(msg.sender, _to, vesting.amount, vesting.startTime, _lockMonths);
541     }
542 
543     return true;
544   }
545 
546   // @return true if ico is open
547   function isIcoOpen() public view returns (bool) {
548     bool capReached = tokenSold >= icoCap;
549     return !capReached;
550   }
551 
552   /*
553     check if purchase amount exists ico cap
554 
555     @param _tokenSold - amount of token sold 
556     @param _purchaseAmount - amount of token want to purchase
557 
558     @return true if _purchaseAmount is allowed
559   */
560   function isPurchaseWithinCap(uint256 _tokenSold, uint256 _purchaseAmount) internal view returns(bool) {
561     bool isLessThanCap = _tokenSold.add(_purchaseAmount) <= icoCap;
562     return isLessThanCap;
563   }
564 
565   /*
566     @param _amount - amount of token
567     @return true if the purchase is valid
568   */
569   function allowPurchase(uint256 _amount) internal view returns (bool) {
570     bool nonZeroPurchase = _amount != 0;
571     return nonZeroPurchase && isIcoOpen();
572   }
573 
574   /*
575     @param _wallet - wallet address of the token sender
576     @param _amount - amount of token
577     @return true if the transfer is valid
578   */
579   function allowTransfer(address _wallet, uint256 _amount) internal view returns (bool) {
580     Locking memory locking = lockingMap[_wallet];
581     if (locking.endTime > now) {
582       return balances[_wallet].sub(_amount) >= locking.amount;
583     } else {
584       return balances[_wallet] >= _amount;
585     }
586   }
587 
588   /*
589     transfer token from caller to receiver
590 
591     @param _to - wallet address of the token receiver
592     @param _value - amount of token to be transferred
593 
594     @return true if the transfer is done
595   */
596   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
597     require(allowTransfer(msg.sender, _value));
598     return super.transfer(_to, _value);
599   }
600 
601   /*
602     transfer token from sender to receiver 
603 
604     @param _from - wallet address of the token sender
605     @param _to - wallet address of the token receiver
606     @param _value - amount of token to be transferred
607 
608     @return true if the transfer is done
609   */
610   function transferFrom(address _from, address _to, uint256 _value)  onlyPayloadSize(3 * 32) public returns (bool) {
611     require(allowTransfer(_from, _value));
612     return super.transferFrom(_from, _to, _value);
613   }
614 
615   /*
616     @param _wallet - wallet address wanted to check
617     @return amount of token allocated
618   */
619   function allocationOf(address _wallet) public view returns (uint256) {
620     Vesting memory vesting = vestingMap[_wallet];
621     return vesting.amount;
622   }
623 
624   /*
625     get the releasable tokens
626     @return amount of released tokens
627   */
628   function release() public onlyPayloadSize(0 * 32) returns (uint256) {
629     uint256 unreleased = releasableAmount(msg.sender);
630     Vesting storage vesting = vestingMap[msg.sender];
631 
632     if (unreleased > 0) {
633       vesting.released = vesting.released.add(unreleased);
634       emit Release(msg.sender, unreleased);
635 
636       balances[msg.sender] = balances[msg.sender].add(unreleased);
637       emit Transfer(0x0, msg.sender, unreleased);
638     }
639 
640     return unreleased;
641   }
642 
643   /*
644     @param _wallet - wallet address wanted to check
645     @return amount of releasable token
646   */
647   function releasableAmount(address _wallet) public view returns (uint256) {
648     Vesting memory vesting = vestingMap[_wallet];
649     return vestedAmount(_wallet).sub(vesting.released);
650   }
651 
652   /*
653     @param _wallet - wallet address wanted to check
654     @return amount of vested token
655   */
656   function vestedAmount(address _wallet) public view returns (uint256) {
657     uint amonth = 30 days;
658     Vesting memory vesting = vestingMap[_wallet];
659     uint lockPeriod = vesting.lockMonths.mul(amonth);
660     uint lockEndTime = vesting.startTime.add(lockPeriod);
661 
662     if (now >= lockEndTime) {
663       return vesting.amount;
664     } else if (now > vesting.startTime) {
665       // vest a portion of token each month
666       
667       uint roundedPeriod = now
668         .sub(vesting.startTime)
669         .div(amonth)
670         .mul(amonth);
671 
672       return vesting.amount
673         .mul(roundedPeriod)
674         .div(lockPeriod);
675     } else {
676       return 0;
677     }
678   }
679 
680   /*
681     modifiers to avoid short address attack
682   */
683   modifier onlyPayloadSize(uint size) {
684     assert(msg.data.length == size + 4);
685     _;
686   } 
687   
688 }