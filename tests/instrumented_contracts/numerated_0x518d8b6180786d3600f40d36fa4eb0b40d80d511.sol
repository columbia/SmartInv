1 pragma solidity 0.4.24;
2 
3 // File: node_modules/zeppelin-solidity/contracts/ReentrancyGuard.sol
4 
5 /**
6  * @title Helps contracts guard agains reentrancy attacks.
7  * @author Remco Bloemen <remco@2π.com>
8  * @notice If you mark a function `nonReentrant`, you should also
9  * mark it `external`.
10  */
11 contract ReentrancyGuard {
12 
13   /**
14    * @dev We use a single lock for the whole contract.
15    */
16   bool private reentrancyLock = false;
17 
18   /**
19    * @dev Prevents a contract from calling itself, directly or indirectly.
20    * @notice If you mark a function `nonReentrant`, you should also
21    * mark it `external`. Calling one nonReentrant function from
22    * another is not supported. Instead, you can implement a
23    * `private` function doing the actual work, and a `external`
24    * wrapper marked as `nonReentrant`.
25    */
26   modifier nonReentrant() {
27     require(!reentrancyLock);
28     reentrancyLock = true;
29     _;
30     reentrancyLock = false;
31   }
32 
33 }
34 
35 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that throw on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, throws on overflow.
45   */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
48     // benefit is lost if 'b' is also tested.
49     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50     if (a == 0) {
51       return 0;
52     }
53 
54     c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers, truncating the quotient.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     // uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return a / b;
67   }
68 
69   /**
70   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71   */
72   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   /**
78   * @dev Adds two numbers, throws on overflow.
79   */
80   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
81     c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
88 
89 /**
90  * @title Ownable
91  * @dev The Ownable contract has an owner address, and provides basic authorization control
92  * functions, this simplifies the implementation of "user permissions".
93  */
94 contract Ownable {
95   address public owner;
96 
97 
98   event OwnershipRenounced(address indexed previousOwner);
99   event OwnershipTransferred(
100     address indexed previousOwner,
101     address indexed newOwner
102   );
103 
104 
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109   constructor() public {
110     owner = msg.sender;
111   }
112 
113   /**
114    * @dev Throws if called by any account other than the owner.
115    */
116   modifier onlyOwner() {
117     require(msg.sender == owner);
118     _;
119   }
120 
121   /**
122    * @dev Allows the current owner to relinquish control of the contract.
123    * @notice Renouncing to ownership will leave the contract without an owner.
124    * It will not be possible to call the functions with the `onlyOwner`
125    * modifier anymore.
126    */
127   function renounceOwnership() public onlyOwner {
128     emit OwnershipRenounced(owner);
129     owner = address(0);
130   }
131 
132   /**
133    * @dev Allows the current owner to transfer control of the contract to a newOwner.
134    * @param _newOwner The address to transfer ownership to.
135    */
136   function transferOwnership(address _newOwner) public onlyOwner {
137     _transferOwnership(_newOwner);
138   }
139 
140   /**
141    * @dev Transfers control of the contract to a newOwner.
142    * @param _newOwner The address to transfer ownership to.
143    */
144   function _transferOwnership(address _newOwner) internal {
145     require(_newOwner != address(0));
146     emit OwnershipTransferred(owner, _newOwner);
147     owner = _newOwner;
148   }
149 }
150 
151 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
152 
153 /**
154  * @title ERC20Basic
155  * @dev Simpler version of ERC20 interface
156  * See https://github.com/ethereum/EIPs/issues/179
157  */
158 contract ERC20Basic {
159   function totalSupply() public view returns (uint256);
160   function balanceOf(address who) public view returns (uint256);
161   function transfer(address to, uint256 value) public returns (bool);
162   event Transfer(address indexed from, address indexed to, uint256 value);
163 }
164 
165 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
166 
167 /**
168  * @title Basic token
169  * @dev Basic version of StandardToken, with no allowances.
170  */
171 contract BasicToken is ERC20Basic {
172   using SafeMath for uint256;
173 
174   mapping(address => uint256) balances;
175 
176   uint256 totalSupply_;
177 
178   /**
179   * @dev Total number of tokens in existence
180   */
181   function totalSupply() public view returns (uint256) {
182     return totalSupply_;
183   }
184 
185   /**
186   * @dev Transfer token for a specified address
187   * @param _to The address to transfer to.
188   * @param _value The amount to be transferred.
189   */
190   function transfer(address _to, uint256 _value) public returns (bool) {
191     require(_to != address(0));
192     require(_value <= balances[msg.sender]);
193 
194     balances[msg.sender] = balances[msg.sender].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     emit Transfer(msg.sender, _to, _value);
197     return true;
198   }
199 
200   /**
201   * @dev Gets the balance of the specified address.
202   * @param _owner The address to query the the balance of.
203   * @return An uint256 representing the amount owned by the passed address.
204   */
205   function balanceOf(address _owner) public view returns (uint256) {
206     return balances[_owner];
207   }
208 
209 }
210 
211 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
212 
213 /**
214  * @title ERC20 interface
215  * @dev see https://github.com/ethereum/EIPs/issues/20
216  */
217 contract ERC20 is ERC20Basic {
218   function allowance(address owner, address spender)
219     public view returns (uint256);
220 
221   function transferFrom(address from, address to, uint256 value)
222     public returns (bool);
223 
224   function approve(address spender, uint256 value) public returns (bool);
225   event Approval(
226     address indexed owner,
227     address indexed spender,
228     uint256 value
229   );
230 }
231 
232 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
233 
234 /**
235  * @title Standard ERC20 token
236  *
237  * @dev Implementation of the basic standard token.
238  * https://github.com/ethereum/EIPs/issues/20
239  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
240  */
241 contract StandardToken is ERC20, BasicToken {
242 
243   mapping (address => mapping (address => uint256)) internal allowed;
244 
245 
246   /**
247    * @dev Transfer tokens from one address to another
248    * @param _from address The address which you want to send tokens from
249    * @param _to address The address which you want to transfer to
250    * @param _value uint256 the amount of tokens to be transferred
251    */
252   function transferFrom(
253     address _from,
254     address _to,
255     uint256 _value
256   )
257     public
258     returns (bool)
259   {
260     require(_to != address(0));
261     require(_value <= balances[_from]);
262     require(_value <= allowed[_from][msg.sender]);
263 
264     balances[_from] = balances[_from].sub(_value);
265     balances[_to] = balances[_to].add(_value);
266     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
267     emit Transfer(_from, _to, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
273    * Beware that changing an allowance with this method brings the risk that someone may use both the old
274    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277    * @param _spender The address which will spend the funds.
278    * @param _value The amount of tokens to be spent.
279    */
280   function approve(address _spender, uint256 _value) public returns (bool) {
281     allowed[msg.sender][_spender] = _value;
282     emit Approval(msg.sender, _spender, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Function to check the amount of tokens that an owner allowed to a spender.
288    * @param _owner address The address which owns the funds.
289    * @param _spender address The address which will spend the funds.
290    * @return A uint256 specifying the amount of tokens still available for the spender.
291    */
292   function allowance(
293     address _owner,
294     address _spender
295    )
296     public
297     view
298     returns (uint256)
299   {
300     return allowed[_owner][_spender];
301   }
302 
303   /**
304    * @dev Increase the amount of tokens that an owner allowed to a spender.
305    * approve should be called when allowed[_spender] == 0. To increment
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param _spender The address which will spend the funds.
310    * @param _addedValue The amount of tokens to increase the allowance by.
311    */
312   function increaseApproval(
313     address _spender,
314     uint256 _addedValue
315   )
316     public
317     returns (bool)
318   {
319     allowed[msg.sender][_spender] = (
320       allowed[msg.sender][_spender].add(_addedValue));
321     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322     return true;
323   }
324 
325   /**
326    * @dev Decrease the amount of tokens that an owner allowed to a spender.
327    * approve should be called when allowed[_spender] == 0. To decrement
328    * allowed value is better to use this function to avoid 2 calls (and wait until
329    * the first transaction is mined)
330    * From MonolithDAO Token.sol
331    * @param _spender The address which will spend the funds.
332    * @param _subtractedValue The amount of tokens to decrease the allowance by.
333    */
334   function decreaseApproval(
335     address _spender,
336     uint256 _subtractedValue
337   )
338     public
339     returns (bool)
340   {
341     uint256 oldValue = allowed[msg.sender][_spender];
342     if (_subtractedValue > oldValue) {
343       allowed[msg.sender][_spender] = 0;
344     } else {
345       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
346     }
347     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
348     return true;
349   }
350 
351 }
352 
353 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
354 
355 /**
356  * @title Mintable token
357  * @dev Simple ERC20 Token example, with mintable token creation
358  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
359  */
360 contract MintableToken is StandardToken, Ownable {
361   event Mint(address indexed to, uint256 amount);
362   event MintFinished();
363 
364   bool public mintingFinished = false;
365 
366 
367   modifier canMint() {
368     require(!mintingFinished);
369     _;
370   }
371 
372   modifier hasMintPermission() {
373     require(msg.sender == owner);
374     _;
375   }
376 
377   /**
378    * @dev Function to mint tokens
379    * @param _to The address that will receive the minted tokens.
380    * @param _amount The amount of tokens to mint.
381    * @return A boolean that indicates if the operation was successful.
382    */
383   function mint(
384     address _to,
385     uint256 _amount
386   )
387     hasMintPermission
388     canMint
389     public
390     returns (bool)
391   {
392     totalSupply_ = totalSupply_.add(_amount);
393     balances[_to] = balances[_to].add(_amount);
394     emit Mint(_to, _amount);
395     emit Transfer(address(0), _to, _amount);
396     return true;
397   }
398 
399   /**
400    * @dev Function to stop minting new tokens.
401    * @return True if the operation was successful.
402    */
403   function finishMinting() onlyOwner canMint public returns (bool) {
404     mintingFinished = true;
405     emit MintFinished();
406     return true;
407   }
408 }
409 
410 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
411 
412 /**
413  * @title Capped token
414  * @dev Mintable token with a token cap.
415  */
416 contract CappedToken is MintableToken {
417 
418   uint256 public cap;
419 
420   constructor(uint256 _cap) public {
421     require(_cap > 0);
422     cap = _cap;
423   }
424 
425   /**
426    * @dev Function to mint tokens
427    * @param _to The address that will receive the minted tokens.
428    * @param _amount The amount of tokens to mint.
429    * @return A boolean that indicates if the operation was successful.
430    */
431   function mint(
432     address _to,
433     uint256 _amount
434   )
435     public
436     returns (bool)
437   {
438     require(totalSupply_.add(_amount) <= cap);
439 
440     return super.mint(_to, _amount);
441   }
442 
443 }
444 
445 // File: contracts/FlameToken.sol
446 
447 contract FlameToken is CappedToken {
448 
449     string public constant name = "Flame";
450     string public constant symbol = "XFL";
451     uint8 public constant decimals = 18;
452 
453     constructor(uint _cap) public CappedToken(_cap) {
454         
455     }
456 
457     /// @notice Makes sure a spending racing approve attack will not occur.
458     /// @notice Call this only after you decreased the approve to zero using decreaseApproval.
459     function safeApprove(address _spender, uint256 _value) public returns (bool) {
460         require(allowed[msg.sender][_spender] == 0 || _value == 0);
461         require(approve(_spender, _value));
462     }
463 
464 }
465 
466 // File: contracts/MasterVest.sol
467 
468 /**
469  * @title MasterVest
470  * @dev A token holder contract that can release its token balance linear.
471  * @dev A sum equal to amount/months will be released every month.
472  */
473 
474 contract MasterVest is ReentrancyGuard, Ownable {
475 
476     using SafeMath for uint256;
477 
478     /// @dev Deployed token reference.
479     FlameToken public token;
480     /// @dev Beneficiary of tokens after they are released.
481     address public beneficiary;
482     /// @dev Start time of vesting.
483     uint256 public start;
484     /// @dev Constructor parameter
485     uint256 public months;
486     /// @dev Holds release amount
487     uint256 public released;
488 
489     event Released(uint256 amount);
490 
491     /// @dev Creates a vesting contract that vests its balance of FlameToken token to the
492     /// _multiSigAddress, tokens are released in an linear fashion after a moth 
493     /// has passed until _start +  nrOfMonths * months. 
494     /// By then all of the balance will have vested.
495     /// @param _cap total amount of tokens to be minted 50-50
496     /// @param _months vesting period in months
497     /// @param _multiSigAddress address of multisig account (the holder of tokens)
498     constructor (uint256 _cap, uint _months, address _multiSigAddress) public {
499 
500         require(_multiSigAddress != address(0) && _cap != 0 && _months != 0);
501         
502         beneficiary = _multiSigAddress;
503         months = _months;
504         token = new FlameToken(_cap);
505         start = now;
506 
507         initialMint(_cap);
508         token.finishMinting();
509 
510     }
511 
512     /// @dev Callable only by owner to set a new beneficiary for the vesting amount.
513     function setBeneficiary(address _newBeneficiary) external onlyOwner {
514         beneficiary = _newBeneficiary;
515     }
516 
517     /// @notice Transfers vested tokens to beneficiary.
518     /// @dev Can only be called by beneficiary wich is the multi-sig wallet.
519     function release() external nonReentrant onlyBeneficiary {
520         uint256 unreleased = releasableAmount(); 
521         require(unreleased > 0); 
522         released = released.add(unreleased);
523         token.transfer(beneficiary, unreleased);
524         emit Released(unreleased);
525     }
526 
527     /// @dev Calculates the amount that has already vested but hasn't been released yet.    
528     function releasableAmount() public view returns(uint256) {
529         return vestedAmount().sub(released); 
530     }
531 
532     /// @dev Calculates the amount that has already vested.
533     function vestedAmount() public view returns(uint256) {
534 
535         uint256 currentBalance = token.balanceOf(this); 
536         uint256 totalBalance = currentBalance.add(released); 
537 
538         if (now < start) {
539             return 0;
540         }
541         uint256 dT = now.sub(start); // time passed since start
542         uint256 dMonths = dT.div(30 days); // months passed 
543 
544         if (dMonths >= months) {
545             return totalBalance; // return everything if vesting period ended
546         } else {
547             return totalBalance.mul(dMonths).div(months); // ammount = total * (months passed / total months)
548         }
549 
550     }
551 
552     /// @notice Directly mints half of value and vests the other healf for the same beneficiary.
553     function initialMint(uint256 _cap) internal {
554         uint256 halfCap = _cap.div(2);
555         // 50% of vested amount minted in contract
556         token.mint(this, halfCap);
557         // 50% of vested amount minted directly for multisig wallet
558         token.mint(beneficiary, _cap.sub(halfCap));
559     }
560 
561     /// @dev Modifier that makes sure that only beneficiary, in our case multisig wallet can call this.
562     modifier onlyBeneficiary() {
563         require(msg.sender == beneficiary);
564         _;
565     }
566 
567 }