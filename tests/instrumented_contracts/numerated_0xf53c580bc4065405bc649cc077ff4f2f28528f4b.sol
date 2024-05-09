1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/ownership/Claimable.sol
46 
47 /**
48  * @title Claimable
49  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
50  * This allows the new owner to accept the transfer.
51  */
52 contract Claimable is Ownable {
53   address public pendingOwner;
54 
55   /**
56    * @dev Modifier throws if called by any account other than the pendingOwner.
57    */
58   modifier onlyPendingOwner() {
59     require(msg.sender == pendingOwner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to set the pendingOwner address.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     pendingOwner = newOwner;
69   }
70 
71   /**
72    * @dev Allows the pendingOwner address to finalize the transfer.
73    */
74   function claimOwnership() onlyPendingOwner public {
75     OwnershipTransferred(owner, pendingOwner);
76     owner = pendingOwner;
77     pendingOwner = address(0);
78   }
79 }
80 
81 // File: zeppelin-solidity/contracts/math/SafeMath.sol
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93     if (a == 0) {
94       return 0;
95     }
96     uint256 c = a * b;
97     assert(c / a == b);
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers, truncating the quotient.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   /**
112   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   /**
120   * @dev Adds two numbers, throws on overflow.
121   */
122   function add(uint256 a, uint256 b) internal pure returns (uint256) {
123     uint256 c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 }
128 
129 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
130 
131 /**
132  * @title ERC20Basic
133  * @dev Simpler version of ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/179
135  */
136 contract ERC20Basic {
137   function totalSupply() public view returns (uint256);
138   function availableSupply() public view returns (uint256);
139   function balanceOf(address who) public view returns (uint256);
140   function transfer(address to, uint256 value) public returns (bool);
141   event Transfer(address indexed from, address indexed to, uint256 value);
142 }
143 
144 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
145 
146 /**
147  * @title Basic token
148  * @dev Basic version of StandardToken, with no allowances.
149  */
150 contract BasicToken is ERC20Basic {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155   uint256 totalSupply_;
156   uint256 availableSupply_;
157 
158   /**
159   * @dev total number of tokens in existence
160   */
161   function totalSupply() public view returns (uint256) {
162     return totalSupply_;
163   }
164 
165   function availableSupply() public view returns (uint256) {
166     return availableSupply_;
167   }
168 
169   /**
170   * @dev transfer token for a specified address
171   * @param _to The address to transfer to.
172   * @param _value The amount to be transferred.
173   */
174   function transfer(address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[msg.sender]);
177 
178     // SafeMath.sub will throw if there is not enough balance.
179     balances[msg.sender] = balances[msg.sender].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     Transfer(msg.sender, _to, _value);
182     return true;
183   }
184 
185   /**
186   * @dev Gets the balance of the specified address.
187   * @param _owner The address to query the the balance of.
188   * @return An uint256 representing the amount owned by the passed address.
189   */
190   function balanceOf(address _owner) public view returns (uint256 balance) {
191     return balances[_owner];
192   }
193 
194 }
195 
196 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
197 
198 /**
199  * @title ERC20 interface
200  * @dev see https://github.com/ethereum/EIPs/issues/20
201  */
202 contract ERC20 is ERC20Basic {
203   function allowance(address owner, address spender) public view returns (uint256);
204   function transferFrom(address from, address to, uint256 value) public returns (bool);
205   function approve(address spender, uint256 value) public returns (bool);
206   event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
210 
211 /**
212  * @title Standard ERC20 token
213  *
214  * @dev Implementation of the basic standard token.
215  * @dev https://github.com/ethereum/EIPs/issues/20
216  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
217  */
218 contract StandardToken is ERC20, BasicToken {
219 
220   mapping (address => mapping (address => uint256)) internal allowed;
221 
222 
223   /**
224    * @dev Transfer tokens from one address to another
225    * @param _from address The address which you want to send tokens from
226    * @param _to address The address which you want to transfer to
227    * @param _value uint256 the amount of tokens to be transferred
228    */
229   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
230     require(_to != address(0));
231     require(_value <= balances[_from]);
232     require(_value <= allowed[_from][msg.sender]);
233 
234     balances[_from] = balances[_from].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237     Transfer(_from, _to, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    *
244    * Beware that changing an allowance with this method brings the risk that someone may use both the old
245    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
246    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
247    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248    * @param _spender The address which will spend the funds.
249    * @param _value The amount of tokens to be spent.
250    */
251   function approve(address _spender, uint256 _value) public returns (bool) {
252     allowed[msg.sender][_spender] = _value;
253     Approval(msg.sender, _spender, _value);
254     return true;
255   }
256 
257   /**
258    * @dev Function to check the amount of tokens that an owner allowed to a spender.
259    * @param _owner address The address which owns the funds.
260    * @param _spender address The address which will spend the funds.
261    * @return A uint256 specifying the amount of tokens still available for the spender.
262    */
263   function allowance(address _owner, address _spender) public view returns (uint256) {
264     return allowed[_owner][_spender];
265   }
266 
267   /**
268    * @dev Increase the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To increment
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _addedValue The amount of tokens to increase the allowance by.
276    */
277   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
278     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
279     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283   /**
284    * @dev Decrease the amount of tokens that an owner allowed to a spender.
285    *
286    * approve should be called when allowed[_spender] == 0. To decrement
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _subtractedValue The amount of tokens to decrease the allowance by.
292    */
293   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
294     uint oldValue = allowed[msg.sender][_spender];
295     if (_subtractedValue > oldValue) {
296       allowed[msg.sender][_spender] = 0;
297     } else {
298       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299     }
300     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304 }
305 
306 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
307 
308 /**
309  * @title Mintable token
310  * @dev Simple ERC20 Token example, with mintable token creation
311  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
312  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
313  */
314 contract MintableToken is StandardToken, Ownable {
315   event Mint(address indexed to, uint256 amount);
316   event MintFinished();
317 
318   bool public mintingFinished = false;
319 
320 
321   modifier canMint() {
322     require(!mintingFinished);
323     _;
324   }
325 
326   /**
327    * @dev Function to mint tokens
328    * @param _to The address that will receive the minted tokens.
329    * @param _amount The amount of tokens to mint.
330    * @return A boolean that indicates if the operation was successful.
331    */
332   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
333     balances[_to] = balances[_to].add(_amount);
334     Mint(_to, _amount);
335     Transfer(address(0), _to, _amount);
336     return true;
337   }
338 
339   /**
340    * @dev Function to stop minting new tokens.
341    * @return True if the operation was successful.
342    */
343   function finishMinting() onlyOwner canMint public returns (bool) {
344     mintingFinished = true;
345     MintFinished();
346     return true;
347   }
348 }
349 
350 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
351 
352 /**
353  * @title Capped token
354  * @dev Mintable token with a token cap.
355  */
356 contract Token is MintableToken {
357 
358 
359   function Token() public {
360   }
361 
362   /**
363    * @dev Function to mint tokens
364    * @param _to The address that will receive the minted tokens.
365    * @param _amount The amount of tokens to mint.
366    * @return A boolean that indicates if the operation was successful.
367    */
368   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
369     return super.mint(_to, _amount);
370   }
371 
372 }
373 
374 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
375 
376 /**
377  * @title Pausable
378  * @dev Base contract which allows children to implement an emergency stop mechanism.
379  */
380 contract Pausable is Ownable {
381   event Pause();
382   event Unpause();
383 
384   bool public paused = false;
385 
386 
387   /**
388    * @dev Modifier to make a function callable only when the contract is not paused.
389    */
390   modifier whenNotPaused() {
391     require(!paused);
392     _;
393   }
394 
395   /**
396    * @dev Modifier to make a function callable only when the contract is paused.
397    */
398   modifier whenPaused() {
399     require(paused);
400     _;
401   }
402 
403   /**
404    * @dev called by the owner to pause, triggers stopped state
405    */
406   function pause() onlyOwner whenNotPaused public {
407     paused = true;
408     Pause();
409   }
410 
411   /**
412    * @dev called by the owner to unpause, returns to normal state
413    */
414   function unpause() onlyOwner whenPaused public {
415     paused = false;
416     Unpause();
417   }
418 }
419 
420 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
421 
422 /**
423  * @title Pausable token
424  * @dev StandardToken modified with pausable transfers.
425  **/
426 contract PausableToken is StandardToken, Pausable {
427 
428   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
429     return super.transfer(_to, _value);
430   }
431 
432   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
433     return super.transferFrom(_from, _to, _value);
434   }
435 
436   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
437     return super.approve(_spender, _value);
438   }
439 
440   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
441     return super.increaseApproval(_spender, _addedValue);
442   }
443 
444   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
445     return super.decreaseApproval(_spender, _subtractedValue);
446   }
447 }
448 
449 // File: contracts/Bittwatt.sol
450 
451 contract EscrowContract is BasicToken {
452     address public creator_;
453     address public beneficiary_;
454     uint public date_;
455     address public token_;
456 
457     function EscrowContract (address creator,address beneficiary,uint date, address token) {
458         creator_ = creator;
459         beneficiary_ = beneficiary;
460         date_ = date;
461         token_ = token;
462     }
463 
464     function executeBeneficiary(uint amount_) public onlyBeneficiary onlyMatureEscrow {
465         ERC20(token_).transfer(beneficiary_,amount_);
466     }
467 
468     function executeCreator(uint amount_) public onlyBeneficiary onlyMatureEscrow {
469         ERC20(token_).transfer(creator_,amount_);
470     }
471 
472     modifier onlyBeneficiary() {
473         require (msg.sender == beneficiary_);
474         _;
475     }
476 
477     modifier onlyMatureEscrow() {
478         require (date_ < block.timestamp);
479         _;
480     }
481 
482 }
483 
484 contract Bittwatt is Token,Claimable, PausableToken {
485 
486     string public constant name = "Bittwatt";
487     string public constant symbol = "BWT";
488     uint8 public constant decimals = 18;
489 
490     address public _tokenAllocator;
491 
492     function Bittwatt() public Token() { // For testing purpose
493         pause();
494     }
495 
496     function enableTransfers() public onlyOwner {
497         unpause();
498     }
499 
500     function disableTransfers() public onlyOwner {
501         pause();
502     }
503 
504     function setTokenAllocator(address _tokenAllocator) public onlyOwner {
505         _tokenAllocator = _tokenAllocator;
506     }
507 
508     function allocateTokens(address _beneficiary, uint _amount) public onlyOnwerOrTokenAllocator {
509         balances[_beneficiary] = _amount;
510     }
511 
512     function allocateBulkTokens(address[] _destinations, uint[] _amounts) public onlyOnwerOrTokenAllocator {
513         uint256 addressCount = _destinations.length;
514         for (uint256 i = 0; i < addressCount; i++) {
515             address currentAddress = _destinations[i];
516             uint256 balance = _amounts[i];
517             balances[currentAddress] = balance;
518             Transfer(0x0000000000000000000000000000000000000000, currentAddress, balance);
519         }
520     }
521 
522     function getStatus() public view returns (uint,uint, bool,address) {
523         return(totalSupply_,availableSupply_, paused, owner);
524     }
525 
526     function setTotalSupply(uint totalSupply) onlyOwner {
527         totalSupply_ = totalSupply;
528     }
529 
530     function setAvailableSupply(uint availableSupply) onlyOwner {
531         availableSupply_ = availableSupply;
532     }
533 
534     address[] public escrowContracts;
535     function createEscrow(address _beneficiary, uint _date, address _tokenAddress) public {
536         address escrowContract = new EscrowContract(msg.sender, _beneficiary, _date, _tokenAddress);
537         escrowContracts.push(escrowContract);
538     }
539 
540     function createDate(uint _days, uint _hours, uint _minutes, uint _seconds) public view returns (uint) {
541         uint currentTimestamp = block.timestamp;
542         currentTimestamp += _seconds;
543         currentTimestamp += 60 * _minutes;
544         currentTimestamp += 3600 * _hours;
545         currentTimestamp += 86400 * _days;
546         return currentTimestamp;
547     }
548 
549     modifier onlyOnwerOrTokenAllocator() {
550         require (msg.sender == owner || msg.sender == _tokenAllocator);
551         _;
552     }
553 
554 }