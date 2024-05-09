1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.4.21;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     if (a == 0) {
17       return 0;
18     }
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
53 
54 pragma solidity ^0.4.21;
55 
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   function Ownable() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     emit OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95 }
96 
97 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
98 
99 pragma solidity ^0.4.21;
100 
101 
102 /**
103  * @title ERC20Basic
104  * @dev Simpler version of ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/179
106  */
107 contract ERC20Basic {
108   function totalSupply() public view returns (uint256);
109   function balanceOf(address who) public view returns (uint256);
110   function transfer(address to, uint256 value) public returns (bool);
111   event Transfer(address indexed from, address indexed to, uint256 value);
112 }
113 
114 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
115 
116 pragma solidity ^0.4.21;
117 
118 
119 
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances.
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   uint256 totalSupply_;
131 
132   /**
133   * @dev total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return totalSupply_;
137   }
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     emit Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public view returns (uint256) {
160     return balances[_owner];
161   }
162 
163 }
164 
165 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
166 
167 pragma solidity ^0.4.21;
168 
169 
170 
171 /**
172  * @title ERC20 interface
173  * @dev see https://github.com/ethereum/EIPs/issues/20
174  */
175 contract ERC20 is ERC20Basic {
176   function allowance(address owner, address spender) public view returns (uint256);
177   function transferFrom(address from, address to, uint256 value) public returns (bool);
178   function approve(address spender, uint256 value) public returns (bool);
179   event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
183 
184 pragma solidity ^0.4.21;
185 
186 
187 
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * @dev https://github.com/ethereum/EIPs/issues/20
194  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20, BasicToken {
197 
198   mapping (address => mapping (address => uint256)) internal allowed;
199 
200 
201   /**
202    * @dev Transfer tokens from one address to another
203    * @param _from address The address which you want to send tokens from
204    * @param _to address The address which you want to transfer to
205    * @param _value uint256 the amount of tokens to be transferred
206    */
207   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
208     require(_to != address(0));
209     require(_value <= balances[_from]);
210     require(_value <= allowed[_from][msg.sender]);
211 
212     balances[_from] = balances[_from].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
215     emit Transfer(_from, _to, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221    *
222    * Beware that changing an allowance with this method brings the risk that someone may use both the old
223    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226    * @param _spender The address which will spend the funds.
227    * @param _value The amount of tokens to be spent.
228    */
229   function approve(address _spender, uint256 _value) public returns (bool) {
230     allowed[msg.sender][_spender] = _value;
231     emit Approval(msg.sender, _spender, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Function to check the amount of tokens that an owner allowed to a spender.
237    * @param _owner address The address which owns the funds.
238    * @param _spender address The address which will spend the funds.
239    * @return A uint256 specifying the amount of tokens still available for the spender.
240    */
241   function allowance(address _owner, address _spender) public view returns (uint256) {
242     return allowed[_owner][_spender];
243   }
244 
245   /**
246    * @dev Increase the amount of tokens that an owner allowed to a spender.
247    *
248    * approve should be called when allowed[_spender] == 0. To increment
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param _spender The address which will spend the funds.
253    * @param _addedValue The amount of tokens to increase the allowance by.
254    */
255   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
256     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261   /**
262    * @dev Decrease the amount of tokens that an owner allowed to a spender.
263    *
264    * approve should be called when allowed[_spender] == 0. To decrement
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _subtractedValue The amount of tokens to decrease the allowance by.
270    */
271   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
272     uint oldValue = allowed[msg.sender][_spender];
273     if (_subtractedValue > oldValue) {
274       allowed[msg.sender][_spender] = 0;
275     } else {
276       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
277     }
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282 }
283 
284 // File: contracts/Token.sol
285 
286 pragma solidity 0.4.23;
287 
288 
289 
290 
291 /// @title   Token
292 /// @author  Jose Perez - <jose.perez@diginex.com>
293 /// @notice  ERC20 token
294 /// @dev     The contract allows to perform a number of token sales in different periods in time.
295 ///          allowing participants in previous token sales to transfer tokens to other accounts.
296 ///          Additionally, token locking logic for KYC/AML compliance checking is supported.
297 
298 contract Token is StandardToken, Ownable {
299     using SafeMath for uint256;
300 
301     string public constant name = "Nynja";
302     string public constant symbol = "NYN";
303     uint256 public constant decimals = 18;
304 
305     // Using same number of decimal figures as ETH (i.e. 18).
306     uint256 public constant TOKEN_UNIT = 10 ** uint256(decimals);
307 
308     // Maximum number of tokens in circulation
309     uint256 public constant MAX_TOKEN_SUPPLY = 3000000000 * TOKEN_UNIT;
310 
311     // Maximum number of tokens sales to be performed.
312     uint256 public constant MAX_TOKEN_SALES = 2;
313 
314     // Maximum size of the batch functions input arrays.
315     uint256 public constant MAX_BATCH_SIZE = 400;
316 
317     address public assigner;    // The address allowed to assign or mint tokens during token sale.
318     address public locker;      // The address allowed to lock/unlock addresses.
319 
320     mapping(address => bool) public locked;        // If true, address' tokens cannot be transferred.
321 
322     uint256 public currentTokenSaleId = 0;           // The id of the current token sale.
323     mapping(address => uint256) public tokenSaleId;  // In which token sale the address participated.
324 
325     bool public tokenSaleOngoing = false;
326 
327     event TokenSaleStarting(uint indexed tokenSaleId);
328     event TokenSaleEnding(uint indexed tokenSaleId);
329     event Lock(address indexed addr);
330     event Unlock(address indexed addr);
331     event Assign(address indexed to, uint256 amount);
332     event Mint(address indexed to, uint256 amount);
333     event LockerTransferred(address indexed previousLocker, address indexed newLocker);
334     event AssignerTransferred(address indexed previousAssigner, address indexed newAssigner);
335 
336     /// @dev Constructor that initializes the contract.
337     /// @param _assigner The assigner account.
338     /// @param _locker The locker account.
339     constructor(address _assigner, address _locker) public {
340         require(_assigner != address(0));
341         require(_locker != address(0));
342 
343         assigner = _assigner;
344         locker = _locker;
345     }
346 
347     /// @dev True if a token sale is ongoing.
348     modifier tokenSaleIsOngoing() {
349         require(tokenSaleOngoing);
350         _;
351     }
352 
353     /// @dev True if a token sale is not ongoing.
354     modifier tokenSaleIsNotOngoing() {
355         require(!tokenSaleOngoing);
356         _;
357     }
358 
359     /// @dev Throws if called by any account other than the assigner.
360     modifier onlyAssigner() {
361         require(msg.sender == assigner);
362         _;
363     }
364 
365     /// @dev Throws if called by any account other than the locker.
366     modifier onlyLocker() {
367         require(msg.sender == locker);
368         _;
369     }
370 
371     /// @dev Starts a new token sale. Only the owner can start a new token sale. If a token sale
372     ///      is ongoing, it has to be ended before a new token sale can be started.
373     ///      No more than `MAX_TOKEN_SALES` sales can be carried out.
374     /// @return True if the operation was successful.
375     function tokenSaleStart() external onlyOwner tokenSaleIsNotOngoing returns(bool) {
376         require(currentTokenSaleId < MAX_TOKEN_SALES);
377         currentTokenSaleId++;
378         tokenSaleOngoing = true;
379         emit TokenSaleStarting(currentTokenSaleId);
380         return true;
381     }
382 
383     /// @dev Ends the current token sale. Only the owner can end a token sale.
384     /// @return True if the operation was successful.
385     function tokenSaleEnd() external onlyOwner tokenSaleIsOngoing returns(bool) {
386         emit TokenSaleEnding(currentTokenSaleId);
387         tokenSaleOngoing = false;
388         return true;
389     }
390 
391     /// @dev Returns whether or not a token sale is ongoing.
392     /// @return True if a token sale is ongoing.
393     function isTokenSaleOngoing() external view returns(bool) {
394         return tokenSaleOngoing;
395     }
396 
397     /// @dev Getter of the variable `currentTokenSaleId`.
398     /// @return Returns the current token sale id.
399     function getCurrentTokenSaleId() external view returns(uint256) {
400         return currentTokenSaleId;
401     }
402 
403     /// @dev Getter of the variable `tokenSaleId[]`.
404     /// @param _address The address of the participant.
405     /// @return Returns the id of the token sale the address participated in.
406     function getAddressTokenSaleId(address _address) external view returns(uint256) {
407         return tokenSaleId[_address];
408     }
409 
410     /// @dev Allows the current owner to change the assigner.
411     /// @param _newAssigner The address of the new assigner.
412     /// @return True if the operation was successful.
413     function transferAssigner(address _newAssigner) external onlyOwner returns(bool) {
414         require(_newAssigner != address(0));
415 
416         emit AssignerTransferred(assigner, _newAssigner);
417         assigner = _newAssigner;
418         return true;
419     }
420 
421     /// @dev Function to mint tokens. It can only be called by the assigner during an ongoing token sale.
422     /// @param _to The address that will receive the minted tokens.
423     /// @param _amount The amount of tokens to mint.
424     /// @return A boolean that indicates if the operation was successful.
425     function mint(address _to, uint256 _amount) public onlyAssigner tokenSaleIsOngoing returns(bool) {
426         totalSupply_ = totalSupply_.add(_amount);
427         require(totalSupply_ <= MAX_TOKEN_SUPPLY);
428 
429         if (tokenSaleId[_to] == 0) {
430             tokenSaleId[_to] = currentTokenSaleId;
431         }
432         require(tokenSaleId[_to] == currentTokenSaleId);
433 
434         balances[_to] = balances[_to].add(_amount);
435 
436         emit Mint(_to, _amount);
437         emit Transfer(address(0), _to, _amount);
438         return true;
439     }
440 
441     /// @dev Mints tokens for several addresses in one single call.
442     /// @param _to address[] The addresses that get the tokens.
443     /// @param _amount address[] The number of tokens to be minted.
444     /// @return A boolean that indicates if the operation was successful.
445     function mintInBatches(address[] _to, uint256[] _amount) external onlyAssigner tokenSaleIsOngoing returns(bool) {
446         require(_to.length > 0);
447         require(_to.length == _amount.length);
448         require(_to.length <= MAX_BATCH_SIZE);
449 
450         for (uint i = 0; i < _to.length; i++) {
451             mint(_to[i], _amount[i]);
452         }
453         return true;
454     }
455 
456     /// @dev Function to assign any number of tokens to a given address.
457     ///      Compared to the `mint` function, the `assign` function allows not just to increase but also to decrease
458     ///      the number of tokens of an address by assigning a lower value than the address current balance.
459     ///      This function can only be executed during initial token sale.
460     /// @param _to The address that will receive the assigned tokens.
461     /// @param _amount The amount of tokens to assign.
462     /// @return True if the operation was successful.
463     function assign(address _to, uint256 _amount) public onlyAssigner tokenSaleIsOngoing returns(bool) {
464         require(currentTokenSaleId == 1);
465 
466         // The desired value to assign (`_amount`) can be either higher or lower than the current number of tokens
467         // of the address (`balances[_to]`). To calculate the new `totalSupply_` value, the difference between `_amount`
468         // and `balances[_to]` (`delta`) is calculated first, and then added or substracted to `totalSupply_` accordingly.
469         uint256 delta = 0;
470         if (balances[_to] < _amount) {
471             // balances[_to] will be increased, so totalSupply_ should be increased
472             delta = _amount.sub(balances[_to]);
473             totalSupply_ = totalSupply_.add(delta);
474         } else {
475             // balances[_to] will be decreased, so totalSupply_ should be decreased
476             delta = balances[_to].sub(_amount);
477             totalSupply_ = totalSupply_.sub(delta);
478         }
479         require(totalSupply_ <= MAX_TOKEN_SUPPLY);
480 
481         balances[_to] = _amount;
482         tokenSaleId[_to] = currentTokenSaleId;
483 
484         emit Assign(_to, _amount);
485         emit Transfer(address(0), _to, _amount);
486         return true;
487     }
488 
489     /// @dev Assigns tokens to several addresses in one call.
490     /// @param _to address[] The addresses that get the tokens.
491     /// @param _amount address[] The number of tokens to be assigned.
492     /// @return True if the operation was successful.
493     function assignInBatches(address[] _to, uint256[] _amount) external onlyAssigner tokenSaleIsOngoing returns(bool) {
494         require(_to.length > 0);
495         require(_to.length == _amount.length);
496         require(_to.length <= MAX_BATCH_SIZE);
497 
498         for (uint i = 0; i < _to.length; i++) {
499             assign(_to[i], _amount[i]);
500         }
501         return true;
502     }
503 
504     /// @dev Allows the current owner to change the locker.
505     /// @param _newLocker The address of the new locker.
506     /// @return True if the operation was successful.
507     function transferLocker(address _newLocker) external onlyOwner returns(bool) {
508         require(_newLocker != address(0));
509 
510         emit LockerTransferred(locker, _newLocker);
511         locker = _newLocker;
512         return true;
513     }
514 
515     /// @dev Locks an address. A locked address cannot transfer its tokens or other addresses' tokens out.
516     ///      Only addresses participating in the current token sale can be locked.
517     ///      Only the locker account can lock addresses and only during the token sale.
518     /// @param _address address The address to lock.
519     /// @return True if the operation was successful.
520     function lockAddress(address _address) public onlyLocker tokenSaleIsOngoing returns(bool) {
521         require(tokenSaleId[_address] == currentTokenSaleId);
522         require(!locked[_address]);
523 
524         locked[_address] = true;
525         emit Lock(_address);
526         return true;
527     }
528 
529     /// @dev Unlocks an address so that its owner can transfer tokens out again.
530     ///      Addresses can be unlocked any time. Only the locker account can unlock addresses
531     /// @param _address address The address to unlock.
532     /// @return True if the operation was successful.
533     function unlockAddress(address _address) public onlyLocker returns(bool) {
534         require(locked[_address]);
535 
536         locked[_address] = false;
537         emit Unlock(_address);
538         return true;
539     }
540 
541     /// @dev Locks several addresses in one single call.
542     /// @param _addresses address[] The addresses to lock.
543     /// @return True if the operation was successful.
544     function lockInBatches(address[] _addresses) external onlyLocker returns(bool) {
545         require(_addresses.length > 0);
546         require(_addresses.length <= MAX_BATCH_SIZE);
547 
548         for (uint i = 0; i < _addresses.length; i++) {
549             lockAddress(_addresses[i]);
550         }
551         return true;
552     }
553 
554     /// @dev Unlocks several addresses in one single call.
555     /// @param _addresses address[] The addresses to unlock.
556     /// @return True if the operation was successful.
557     function unlockInBatches(address[] _addresses) external onlyLocker returns(bool) {
558         require(_addresses.length > 0);
559         require(_addresses.length <= MAX_BATCH_SIZE);
560 
561         for (uint i = 0; i < _addresses.length; i++) {
562             unlockAddress(_addresses[i]);
563         }
564         return true;
565     }
566 
567     /// @dev Checks whether or not the given address is locked.
568     /// @param _address address The address to be checked.
569     /// @return Boolean indicating whether or not the address is locked.
570     function isLocked(address _address) external view returns(bool) {
571         return locked[_address];
572     }
573 
574     /// @dev Transfers tokens to the specified address. It prevents transferring tokens from a locked address.
575     ///      Locked addresses can receive tokens.
576     ///      Current token sale's addresses cannot receive or send tokens until the token sale ends.
577     /// @param _to The address to transfer tokens to.
578     /// @param _value The number of tokens to be transferred.
579     function transfer(address _to, uint256 _value) public returns(bool) {
580         require(!locked[msg.sender]);
581 
582         if (tokenSaleOngoing) {
583             require(tokenSaleId[msg.sender] < currentTokenSaleId);
584             require(tokenSaleId[_to] < currentTokenSaleId);
585         }
586 
587         return super.transfer(_to, _value);
588     }
589 
590     /// @dev Transfers tokens from one address to another. It prevents transferring tokens if the caller is locked or
591     ///      if the allowed address is locked.
592     ///      Locked addresses can receive tokens.
593     ///      Current token sale's addresses cannot receive or send tokens until the token sale ends.
594     /// @param _from address The address to transfer tokens from.
595     /// @param _to address The address to transfer tokens to.
596     /// @param _value The number of tokens to be transferred.
597     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
598         require(!locked[msg.sender]);
599         require(!locked[_from]);
600 
601         if (tokenSaleOngoing) {
602             require(tokenSaleId[msg.sender] < currentTokenSaleId);
603             require(tokenSaleId[_from] < currentTokenSaleId);
604             require(tokenSaleId[_to] < currentTokenSaleId);
605         }
606 
607         return super.transferFrom(_from, _to, _value);
608     }
609 }