1 pragma solidity ^0.4.24;
2 
3 // File: contracts/token/ERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11 
12   function balanceOf(address _who) public view returns (uint256);
13 
14   function allowance(address _owner, address _spender)
15     public view returns (uint256);
16 
17   function transfer(address _to, uint256 _value) public returns (bool);
18 
19   function approve(address _spender, uint256 _value)
20     public returns (bool);
21 
22   function transferFrom(address _from, address _to, uint256 _value)
23     public returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: contracts/token/StandardToken.sol
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
111  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract StandardToken is ERC20 {
114   using SafeMath for uint256;
115 
116   mapping (address => uint256) private balances;
117 
118   mapping (address => mapping (address => uint256)) private allowed;
119 
120   uint256 private totalSupply_;
121 
122   /**
123   * @dev Total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return totalSupply_;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) public view returns (uint256) {
135     return balances[_owner];
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(
145     address _owner,
146     address _spender
147    )
148     public
149     view
150     returns (uint256)
151   {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156   * @dev Transfer token for a specified address
157   * @param _to The address to transfer to.
158   * @param _value The amount to be transferred.
159   */
160   function transfer(address _to, uint256 _value) public returns (bool) {
161     require(_value <= balances[msg.sender]);
162     require(_to != address(0));
163 
164     balances[msg.sender] = balances[msg.sender].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     emit Transfer(msg.sender, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Transfer tokens from one address to another
187    * @param _from address The address which you want to send tokens from
188    * @param _to address The address which you want to transfer to
189    * @param _value uint256 the amount of tokens to be transferred
190    */
191   function transferFrom(
192     address _from,
193     address _to,
194     uint256 _value
195   )
196     public
197     returns (bool)
198   {
199     require(_value <= balances[_from]);
200     require(_value <= allowed[_from][msg.sender]);
201     require(_to != address(0));
202 
203     balances[_from] = balances[_from].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
206     emit Transfer(_from, _to, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Increase the amount of tokens that an owner allowed to a spender.
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(
220     address _spender,
221     uint256 _addedValue
222   )
223     public
224     returns (bool)
225   {
226     allowed[msg.sender][_spender] = (
227       allowed[msg.sender][_spender].add(_addedValue));
228     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232   /**
233    * @dev Decrease the amount of tokens that an owner allowed to a spender.
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(
242     address _spender,
243     uint256 _subtractedValue
244   )
245     public
246     returns (bool)
247   {
248     uint256 oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue >= oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Internal function that mints an amount of the token and assigns it to
260    * an account. This encapsulates the modification of balances such that the
261    * proper events are emitted.
262    * @param _account The account that will receive the created tokens.
263    * @param _amount The amount that will be created.
264    */
265   function _mint(address _account, uint256 _amount) internal {
266     require(_account != 0);
267     totalSupply_ = totalSupply_.add(_amount);
268     balances[_account] = balances[_account].add(_amount);
269     emit Transfer(address(0), _account, _amount);
270   }
271 }
272 
273 // File: contracts/ownership/Ownable.sol
274 
275 /**
276  * @title Ownable
277  * @dev The Ownable contract has an owner address, and provides basic authorization control
278  * functions, this simplifies the implementation of "user permissions".
279  */
280 contract Ownable {
281   address public owner;
282 
283   event OwnershipRenounced(address indexed previousOwner);
284   event OwnershipTransferred(
285     address indexed previousOwner,
286     address indexed newOwner
287   );
288 
289   /**
290    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
291    * account.
292    */
293   constructor() public {
294     owner = msg.sender;
295   }
296 
297   /**
298    * @dev Throws if called by any account other than the owner.
299    */
300   modifier onlyOwner() {
301     require(msg.sender == owner);
302     _;
303   }
304 
305   /**
306    * @dev Allows the current owner to relinquish control of the contract.
307    * @notice Renouncing to ownership will leave the contract without an owner.
308    * It will not be possible to call the functions with the `onlyOwner`
309    * modifier anymore.
310    */
311   function renounceOwnership() public onlyOwner {
312     emit OwnershipRenounced(owner);
313     owner = address(0);
314   }
315 
316   /**
317    * @dev Allows the current owner to transfer control of the contract to a newOwner.
318    * @param _newOwner The address to transfer ownership to.
319    */
320   function transferOwnership(address _newOwner) public onlyOwner {
321     _transferOwnership(_newOwner);
322   }
323 
324   /**
325    * @dev Transfers control of the contract to a newOwner.
326    * @param _newOwner The address to transfer ownership to.
327    */
328   function _transferOwnership(address _newOwner) internal {
329     require(_newOwner != address(0));
330     emit OwnershipTransferred(owner, _newOwner);
331     owner = _newOwner;
332   }
333 }
334 
335 // File: contracts/lifecycle/Pausable.sol
336 
337 /**
338  * @title Pausable
339  * @dev Base contract which allows children to implement an emergency stop mechanism.
340  */
341 contract Pausable is Ownable {
342   event Paused();
343   event Unpaused();
344 
345   bool public paused = true;
346 
347   /**
348    * @dev Modifier to make a function callable only when the contract is not paused.
349    */
350   modifier whenNotPaused() {
351     require(!paused);
352     _;
353   }
354 
355   /**
356    * @dev Modifier to make a function callable only when the contract is paused.
357    */
358   modifier whenPaused() {
359     require(paused);
360     _;
361   }
362 
363   /**
364    * @dev called by the owner to pause, triggers stopped state
365    */
366   function pause() public onlyOwner whenNotPaused {
367     paused = true;
368     emit Paused();
369   }
370 
371   /**
372    * @dev called by the owner to unpause, returns to normal state
373    */
374   function unpause() public onlyOwner whenPaused {
375     paused = false;
376     emit Unpaused();
377   }
378 }
379 
380 // File: contracts/access/Freezable.sol
381 
382 /**
383  * @title Freezable
384  * @dev Base contract which allows to freeze an Account from making any trabsaction
385  */
386 contract Freezable is Ownable {
387 
388     mapping(address => bool) public frozenAccount;
389 
390     /**
391      * @dev Throws if sender account is not freezed
392      */
393     modifier isFreezenAccount(){
394         require(frozenAccount[msg.sender]);
395         _;
396     }
397 
398     /**
399      * @dev Throws if sender account is freezed
400      */
401     modifier isNonFreezenAccount(){
402         require(!frozenAccount[msg.sender]);
403         _;
404     }
405 
406     /**
407      * @dev Freeze / UnFreeze account from making any transfers
408      * @param _address The address to Freeze.
409      * @param _freeze freeze status.
410      */
411     function freezeAccount(address _address, bool _freeze) onlyOwner public {
412         frozenAccount[_address] = _freeze;
413     }
414 
415     /**
416      * @dev Freeze multiple accounts from making any transfers
417      * @param _addresses Multiple addresses to Freeze.
418      */
419     function freezeAccounts(address[] _addresses) public onlyOwner {
420         for (uint i = 0; i < _addresses.length; i++) {
421             frozenAccount[_addresses[i]] = true;
422         }
423     }
424 
425     /**
426      * @dev UnFreeze multiple accounts from making any transfers
427      * @param _addresses Multiple addresses to UnFreeze.
428      */
429     function unFreezeAccounts(address[] _addresses) public onlyOwner {
430         for (uint i = 0; i < _addresses.length; i++) {
431             frozenAccount[_addresses[i]] = false;
432         }
433     }
434 
435 }
436 
437 // File: contracts/access/Whitelist.sol
438 
439 /**
440  * @title Whitelist
441  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
442  * This simplifies the implementation of "user permissions".
443  */
444 contract Whitelist is Ownable {
445 
446   mapping(address => bool) public whitelistedAddress;
447 
448   /**
449    * @dev Throws if operator is not whitelisted.
450    * @param _address address
451    */
452   modifier onlyIfWhitelisted(address _address) {
453     require(whitelistedAddress[_address]);
454      _;
455   }
456 
457   /**
458    * @dev add an address to the whitelist
459    * @param _address address
460    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
461    */
462   function addAddressToWhitelist(address _address)
463     public
464     onlyOwner
465   {
466       whitelistedAddress[_address] = true;
467   }
468 
469   /**
470    * @dev add addresses to the whitelist
471    * @param _addresses addresses
472    * @return true if at least one address was added to the whitelist,
473    * false if all addresses were already in the whitelist
474    */
475   function addAddressesToWhitelist(address[] _addresses)
476     public
477     onlyOwner
478   {
479     for (uint256 i = 0; i < _addresses.length; i++) {
480       addAddressToWhitelist(_addresses[i]);
481     }
482   }
483 
484   /**
485    * @dev remove an address from the whitelist
486    * @param _address address
487    * @return true if the address was removed from the whitelist,
488    * false if the address wasn't in the whitelist in the first place
489    */
490   function removeAddressFromWhitelist(address _address)
491     public
492     onlyOwner
493   {
494       whitelistedAddress[_address] = false;
495   }
496 
497   /**
498    * @dev remove addresses from the whitelist
499    * @param _addresses addresses
500    * @return true if at least one address was removed from the whitelist,
501    * false if all addresses weren't in the whitelist in the first place
502    */
503   function removeAddressesFromWhitelist(address[] _addresses)
504     public
505     onlyOwner
506   {
507     for (uint256 i = 0; i < _addresses.length; i++) {
508       removeAddressFromWhitelist(_addresses[i]);
509     }
510   }
511 
512 }
513 
514 // File: contracts/token/CustomERC20.sol
515 
516 contract CustomERC20 is StandardToken, Ownable, Pausable, Freezable, Whitelist {
517 
518 	/**
519 	* @dev Modifier to make a transfer 
520 	* 1) only for owners & Whitelisted addresses
521 	* 2) when the contract is not paused & account is not freezed
522 	*/
523 	modifier onlyIfTransferable() {
524 		require(!paused || whitelistedAddress[msg.sender] || msg.sender == owner);
525 		require(!frozenAccount[msg.sender]);
526 		_;
527 	}
528 
529 	/**
530 	* @dev Transfer tokens from one address to another
531 	* @param _from address The address which you want to send tokens from
532 	* @param _to address The address which you want to transfer to
533 	* @param _value uint256 the amount of tokens to be transferred
534 	*/
535 	function transferFrom(address _from, address _to, uint256 _value) onlyIfTransferable public returns (bool) {
536 		return super.transferFrom(_from, _to, _value);
537 	}
538 
539 	/**
540 	* @dev Transfer token for a specified address
541 	* @param _to The address to transfer to.
542 	* @param _value The amount to be transferred.
543 	*/
544 	function transfer(address _to, uint256 _value) onlyIfTransferable public returns (bool) {
545 		return super.transfer(_to, _value);
546 	}
547 
548 	/**
549 	* @dev Send Airdrops to list of addresses
550 	*/
551 	function sendAirdrops(address[] _addresses, uint256[] _amounts) public {
552 		require(_addresses.length == _amounts.length);
553 		for (uint i = 0; i < _addresses.length; i++) { 
554 			transfer(_addresses[i], _amounts[i]);
555 		}
556 	}
557 
558 }
559 
560 // File: contracts/G7Token.sol
561 
562 contract G7Token is CustomERC20 {
563   string public constant version = "1.0";
564   string public constant name = "G7 Token";
565   string public constant symbol = "G7T";
566   uint8 public constant decimals = 18;
567 
568   uint256 private constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
569 
570   /**
571    * @dev Constructor that gives msg.sender all of existing tokens.
572    */
573   constructor() public {
574     _mint(msg.sender, INITIAL_SUPPLY);
575   }
576 
577 }