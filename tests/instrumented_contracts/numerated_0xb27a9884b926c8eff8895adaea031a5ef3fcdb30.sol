1 pragma solidity 0.4.23;
2 
3 // File: /home/chris/Projects/token-sale-crypto-api/smart-contracts/node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
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
51 // File: /home/chris/Projects/token-sale-crypto-api/smart-contracts/node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
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
93 // File: /home/chris/Projects/token-sale-crypto-api/smart-contracts/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: /home/chris/Projects/token-sale-crypto-api/smart-contracts/node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 // File: /home/chris/Projects/token-sale-crypto-api/smart-contracts/node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: /home/chris/Projects/token-sale-crypto-api/smart-contracts/node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
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
200    *
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
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 // File: contracts/Token.sol
264 
265 /// @title   Token
266 /// @author  Jose Perez - <jose.perez@diginex.com>
267 /// @notice  ERC20 token
268 /// @dev     The contract allows to perform a number of token sales in different periods in time.
269 ///          allowing participants in previous token sales to transfer tokens to other accounts.
270 ///          Additionally, token locking logic for KYC/AML compliance checking is supported.
271 
272 contract Token is StandardToken, Ownable {
273     using SafeMath for uint256;
274 
275     string public constant name = "Nynja";
276     string public constant symbol = "NYN";
277     uint256 public constant decimals = 18;
278 
279     // Using same number of decimal figures as ETH (i.e. 18).
280     uint256 public constant TOKEN_UNIT = 10 ** uint256(decimals);
281 
282     // Maximum number of tokens in circulation
283     uint256 public constant MAX_TOKEN_SUPPLY = 50000000 * TOKEN_UNIT;
284 
285     // Maximum number of tokens sales to be performed.
286     uint256 public constant MAX_TOKEN_SALES = 1;
287 
288     // Maximum size of the batch functions input arrays.
289     uint256 public constant MAX_BATCH_SIZE = 400;
290 
291     address public assigner;    // The address allowed to assign or mint tokens during token sale.
292     address public locker;      // The address allowed to lock/unlock addresses.
293 
294     mapping(address => bool) public locked;        // If true, address' tokens cannot be transferred.
295 
296     uint256 public currentTokenSaleId = 0;           // The id of the current token sale.
297     mapping(address => uint256) public tokenSaleId;  // In which token sale the address participated.
298 
299     bool public tokenSaleOngoing = false;
300 
301     event TokenSaleStarting(uint indexed tokenSaleId);
302     event TokenSaleEnding(uint indexed tokenSaleId);
303     event Lock(address indexed addr);
304     event Unlock(address indexed addr);
305     event Assign(address indexed to, uint256 amount);
306     event Mint(address indexed to, uint256 amount);
307     event LockerTransferred(address indexed previousLocker, address indexed newLocker);
308     event AssignerTransferred(address indexed previousAssigner, address indexed newAssigner);
309 
310     /// @dev Constructor that initializes the contract.
311     /// @param _assigner The assigner account.
312     /// @param _locker The locker account.
313     constructor(address _assigner, address _locker) public {
314         require(_assigner != address(0));
315         require(_locker != address(0));
316 
317         assigner = _assigner;
318         locker = _locker;
319     }
320 
321     /// @dev True if a token sale is ongoing.
322     modifier tokenSaleIsOngoing() {
323         require(tokenSaleOngoing);
324         _;
325     }
326 
327     /// @dev True if a token sale is not ongoing.
328     modifier tokenSaleIsNotOngoing() {
329         require(!tokenSaleOngoing);
330         _;
331     }
332 
333     /// @dev Throws if called by any account other than the assigner.
334     modifier onlyAssigner() {
335         require(msg.sender == assigner);
336         _;
337     }
338 
339     /// @dev Throws if called by any account other than the locker.
340     modifier onlyLocker() {
341         require(msg.sender == locker);
342         _;
343     }
344 
345     /// @dev Starts a new token sale. Only the owner can start a new token sale. If a token sale
346     ///      is ongoing, it has to be ended before a new token sale can be started.
347     ///      No more than `MAX_TOKEN_SALES` sales can be carried out.
348     /// @return True if the operation was successful.
349     function tokenSaleStart() external onlyOwner tokenSaleIsNotOngoing returns(bool) {
350         require(currentTokenSaleId < MAX_TOKEN_SALES);
351         currentTokenSaleId++;
352         tokenSaleOngoing = true;
353         emit TokenSaleStarting(currentTokenSaleId);
354         return true;
355     }
356 
357     /// @dev Ends the current token sale. Only the owner can end a token sale.
358     /// @return True if the operation was successful.
359     function tokenSaleEnd() external onlyOwner tokenSaleIsOngoing returns(bool) {
360         emit TokenSaleEnding(currentTokenSaleId);
361         tokenSaleOngoing = false;
362         return true;
363     }
364 
365     /// @dev Returns whether or not a token sale is ongoing.
366     /// @return True if a token sale is ongoing.
367     function isTokenSaleOngoing() external view returns(bool) {
368         return tokenSaleOngoing;
369     }
370 
371     /// @dev Getter of the variable `currentTokenSaleId`.
372     /// @return Returns the current token sale id.
373     function getCurrentTokenSaleId() external view returns(uint256) {
374         return currentTokenSaleId;
375     }
376 
377     /// @dev Getter of the variable `tokenSaleId[]`.
378     /// @param _address The address of the participant.
379     /// @return Returns the id of the token sale the address participated in.
380     function getAddressTokenSaleId(address _address) external view returns(uint256) {
381         return tokenSaleId[_address];
382     }
383 
384     /// @dev Allows the current owner to change the assigner.
385     /// @param _newAssigner The address of the new assigner.
386     /// @return True if the operation was successful.
387     function transferAssigner(address _newAssigner) external onlyOwner returns(bool) {
388         require(_newAssigner != address(0));
389 
390         emit AssignerTransferred(assigner, _newAssigner);
391         assigner = _newAssigner;
392         return true;
393     }
394 
395     /// @dev Function to mint tokens. It can only be called by the assigner during an ongoing token sale.
396     /// @param _to The address that will receive the minted tokens.
397     /// @param _amount The amount of tokens to mint.
398     /// @return A boolean that indicates if the operation was successful.
399     function mint(address _to, uint256 _amount) public onlyAssigner tokenSaleIsOngoing returns(bool) {
400         totalSupply_ = totalSupply_.add(_amount);
401         require(totalSupply_ <= MAX_TOKEN_SUPPLY);
402 
403         if (tokenSaleId[_to] == 0) {
404             tokenSaleId[_to] = currentTokenSaleId;
405         }
406         require(tokenSaleId[_to] == currentTokenSaleId);
407 
408         balances[_to] = balances[_to].add(_amount);
409 
410         emit Mint(_to, _amount);
411         emit Transfer(address(0), _to, _amount);
412         return true;
413     }
414 
415     /// @dev Mints tokens for several addresses in one single call.
416     /// @param _to address[] The addresses that get the tokens.
417     /// @param _amount address[] The number of tokens to be minted.
418     /// @return A boolean that indicates if the operation was successful.
419     function mintInBatches(address[] _to, uint256[] _amount) external onlyAssigner tokenSaleIsOngoing returns(bool) {
420         require(_to.length > 0);
421         require(_to.length == _amount.length);
422         require(_to.length <= MAX_BATCH_SIZE);
423 
424         for (uint i = 0; i < _to.length; i++) {
425             mint(_to[i], _amount[i]);
426         }
427         return true;
428     }
429 
430     /// @dev Function to assign any number of tokens to a given address.
431     ///      Compared to the `mint` function, the `assign` function allows not just to increase but also to decrease
432     ///      the number of tokens of an address by assigning a lower value than the address current balance.
433     ///      This function can only be executed during initial token sale.
434     /// @param _to The address that will receive the assigned tokens.
435     /// @param _amount The amount of tokens to assign.
436     /// @return True if the operation was successful.
437     function assign(address _to, uint256 _amount) public onlyAssigner tokenSaleIsOngoing returns(bool) {
438         require(currentTokenSaleId == 1);
439 
440         // The desired value to assign (`_amount`) can be either higher or lower than the current number of tokens
441         // of the address (`balances[_to]`). To calculate the new `totalSupply_` value, the difference between `_amount`
442         // and `balances[_to]` (`delta`) is calculated first, and then added or substracted to `totalSupply_` accordingly.
443         uint256 delta = 0;
444         if (balances[_to] < _amount) {
445             // balances[_to] will be increased, so totalSupply_ should be increased
446             delta = _amount.sub(balances[_to]);
447             totalSupply_ = totalSupply_.add(delta);
448         } else {
449             // balances[_to] will be decreased, so totalSupply_ should be decreased
450             delta = balances[_to].sub(_amount);
451             totalSupply_ = totalSupply_.sub(delta);
452         }
453         require(totalSupply_ <= MAX_TOKEN_SUPPLY);
454 
455         balances[_to] = _amount;
456         tokenSaleId[_to] = currentTokenSaleId;
457 
458         emit Assign(_to, _amount);
459         emit Transfer(address(0), _to, _amount);
460         return true;
461     }
462 
463     /// @dev Assigns tokens to several addresses in one call.
464     /// @param _to address[] The addresses that get the tokens.
465     /// @param _amount address[] The number of tokens to be assigned.
466     /// @return True if the operation was successful.
467     function assignInBatches(address[] _to, uint256[] _amount) external onlyAssigner tokenSaleIsOngoing returns(bool) {
468         require(_to.length > 0);
469         require(_to.length == _amount.length);
470         require(_to.length <= MAX_BATCH_SIZE);
471 
472         for (uint i = 0; i < _to.length; i++) {
473             assign(_to[i], _amount[i]);
474         }
475         return true;
476     }
477 
478     /// @dev Allows the current owner to change the locker.
479     /// @param _newLocker The address of the new locker.
480     /// @return True if the operation was successful.
481     function transferLocker(address _newLocker) external onlyOwner returns(bool) {
482         require(_newLocker != address(0));
483 
484         emit LockerTransferred(locker, _newLocker);
485         locker = _newLocker;
486         return true;
487     }
488 
489     /// @dev Locks an address. A locked address cannot transfer its tokens or other addresses' tokens out.
490     ///      Only addresses participating in the current token sale can be locked.
491     ///      Only the locker account can lock addresses and only during the token sale.
492     /// @param _address address The address to lock.
493     /// @return True if the operation was successful.
494     function lockAddress(address _address) public onlyLocker tokenSaleIsOngoing returns(bool) {
495         require(tokenSaleId[_address] == currentTokenSaleId);
496         require(!locked[_address]);
497 
498         locked[_address] = true;
499         emit Lock(_address);
500         return true;
501     }
502 
503     /// @dev Unlocks an address so that its owner can transfer tokens out again.
504     ///      Addresses can be unlocked any time. Only the locker account can unlock addresses
505     /// @param _address address The address to unlock.
506     /// @return True if the operation was successful.
507     function unlockAddress(address _address) public onlyLocker returns(bool) {
508         require(locked[_address]);
509 
510         locked[_address] = false;
511         emit Unlock(_address);
512         return true;
513     }
514 
515     /// @dev Locks several addresses in one single call.
516     /// @param _addresses address[] The addresses to lock.
517     /// @return True if the operation was successful.
518     function lockInBatches(address[] _addresses) external onlyLocker returns(bool) {
519         require(_addresses.length > 0);
520         require(_addresses.length <= MAX_BATCH_SIZE);
521 
522         for (uint i = 0; i < _addresses.length; i++) {
523             lockAddress(_addresses[i]);
524         }
525         return true;
526     }
527 
528     /// @dev Unlocks several addresses in one single call.
529     /// @param _addresses address[] The addresses to unlock.
530     /// @return True if the operation was successful.
531     function unlockInBatches(address[] _addresses) external onlyLocker returns(bool) {
532         require(_addresses.length > 0);
533         require(_addresses.length <= MAX_BATCH_SIZE);
534 
535         for (uint i = 0; i < _addresses.length; i++) {
536             unlockAddress(_addresses[i]);
537         }
538         return true;
539     }
540 
541     /// @dev Checks whether or not the given address is locked.
542     /// @param _address address The address to be checked.
543     /// @return Boolean indicating whether or not the address is locked.
544     function isLocked(address _address) external view returns(bool) {
545         return locked[_address];
546     }
547 
548     /// @dev Transfers tokens to the specified address. It prevents transferring tokens from a locked address.
549     ///      Locked addresses can receive tokens.
550     ///      Current token sale's addresses cannot receive or send tokens until the token sale ends.
551     /// @param _to The address to transfer tokens to.
552     /// @param _value The number of tokens to be transferred.
553     function transfer(address _to, uint256 _value) public returns(bool) {
554         require(!locked[msg.sender]);
555 
556         if (tokenSaleOngoing) {
557             require(tokenSaleId[msg.sender] < currentTokenSaleId);
558             require(tokenSaleId[_to] < currentTokenSaleId);
559         }
560 
561         return super.transfer(_to, _value);
562     }
563 
564     /// @dev Transfers tokens from one address to another. It prevents transferring tokens if the caller is locked or
565     ///      if the allowed address is locked.
566     ///      Locked addresses can receive tokens.
567     ///      Current token sale's addresses cannot receive or send tokens until the token sale ends.
568     /// @param _from address The address to transfer tokens from.
569     /// @param _to address The address to transfer tokens to.
570     /// @param _value The number of tokens to be transferred.
571     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
572         require(!locked[msg.sender]);
573         require(!locked[_from]);
574 
575         if (tokenSaleOngoing) {
576             require(tokenSaleId[msg.sender] < currentTokenSaleId);
577             require(tokenSaleId[_from] < currentTokenSaleId);
578             require(tokenSaleId[_to] < currentTokenSaleId);
579         }
580 
581         return super.transferFrom(_from, _to, _value);
582     }
583 }