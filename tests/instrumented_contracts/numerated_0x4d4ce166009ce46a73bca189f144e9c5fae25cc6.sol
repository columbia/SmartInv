1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   function totalSupply() public view returns (uint256);
9 
10   function balanceOf(address _who) public view returns (uint256);
11 
12   function allowance(address _owner, address _spender)
13     public view returns (uint256);
14 
15   function transfer(address _to, uint256 _value) public returns (bool);
16 
17   function approve(address _spender, uint256 _value)
18     public returns (bool);
19 
20   function transferFrom(address _from, address _to, uint256 _value)
21     public returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     uint256 c = a * b;
54     require(c / a == b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) private balances;
111 
112   mapping (address => mapping (address => uint256)) private allowed;
113 
114   uint256 private totalSupply_;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return totalSupply_;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256) {
129     return balances[_owner];
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param _owner address The address which owns the funds.
135    * @param _spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address _owner,
140     address _spender
141    )
142     public
143     view
144     returns (uint256)
145   {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_value <= balances[msg.sender]);
156     require(_to != address(0));
157 
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     emit Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     allowed[msg.sender][_spender] = _value;
175     emit Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(
186     address _from,
187     address _to,
188     uint256 _value
189   )
190     public
191     returns (bool)
192   {
193     require(_value <= balances[_from]);
194     require(_value <= allowed[_from][msg.sender]);
195     require(_to != address(0));
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200     emit Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Increase the amount of tokens that an owner allowed to a spender.
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseApproval(
214     address _spender,
215     uint256 _addedValue
216   )
217     public
218     returns (bool)
219   {
220     allowed[msg.sender][_spender] = (
221       allowed[msg.sender][_spender].add(_addedValue));
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   /**
227    * @dev Decrease the amount of tokens that an owner allowed to a spender.
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(
236     address _spender,
237     uint256 _subtractedValue
238   )
239     public
240     returns (bool)
241   {
242     uint256 oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue >= oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   /**
253    * @dev Internal function that mints an amount of the token and assigns it to
254    * an account. This encapsulates the modification of balances such that the
255    * proper events are emitted.
256    * @param _account The account that will receive the created tokens.
257    * @param _amount The amount that will be created.
258    */
259   function _mint(address _account, uint256 _amount) internal {
260     require(_account != 0);
261     totalSupply_ = totalSupply_.add(_amount);
262     balances[_account] = balances[_account].add(_amount);
263     emit Transfer(address(0), _account, _amount);
264   }
265 
266   /**
267     * @dev Internal function that burns an amount of the token of a given
268     * account.
269     * @param account The account whose tokens will be burnt.
270     * @param value The amount that will be burnt.
271     */
272   function _burn(address account, uint256 value) internal {
273       require(account != address(0));
274 
275       totalSupply_ = totalSupply_.sub(value);
276       balances[account] = balances[account].sub(value);
277       emit Transfer(account, address(0), value);
278   }
279 }
280 
281 /**
282  * @title Ownable
283  * @dev The Ownable contract has an owner address, and provides basic authorization control
284  * functions, this simplifies the implementation of "user permissions".
285  */
286 contract Ownable {
287   address public owner;
288 
289   event OwnershipRenounced(address indexed previousOwner);
290   event OwnershipTransferred(
291     address indexed previousOwner,
292     address indexed newOwner
293   );
294 
295   /**
296    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
297    * account.
298    */
299   constructor() public {
300     owner = msg.sender;
301   }
302 
303   /**
304    * @dev Throws if called by any account other than the owner.
305    */
306   modifier onlyOwner() {
307     require(msg.sender == owner);
308     _;
309   }
310 
311   /**
312    * @dev Allows the current owner to relinquish control of the contract.
313    * @notice Renouncing to ownership will leave the contract without an owner.
314    * It will not be possible to call the functions with the `onlyOwner`
315    * modifier anymore.
316    */
317   function renounceOwnership() public onlyOwner {
318     emit OwnershipRenounced(owner);
319     owner = address(0);
320   }
321 
322   /**
323    * @dev Allows the current owner to transfer control of the contract to a newOwner.
324    * @param _newOwner The address to transfer ownership to.
325    */
326   function transferOwnership(address _newOwner) public onlyOwner {
327     _transferOwnership(_newOwner);
328   }
329 
330   /**
331    * @dev Transfers control of the contract to a newOwner.
332    * @param _newOwner The address to transfer ownership to.
333    */
334   function _transferOwnership(address _newOwner) internal {
335     require(_newOwner != address(0));
336     emit OwnershipTransferred(owner, _newOwner);
337     owner = _newOwner;
338   }
339 }
340 
341 /**
342  * @title ERC20Mintable
343  * @dev ERC20 minting logic
344  */
345 contract ERC20Mintable is StandardToken, Ownable {
346   /**
347    * @dev Function to mint tokens
348    * @param to The address that will receive the minted tokens.
349    * @param value The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(address to, uint256 value) public onlyOwner returns (bool) {
353     _mint(to, value);
354     return true;
355   }
356 }
357 
358 /**
359  * @title Burnable Token
360  * @dev Token that can be irreversibly burned (destroyed).
361  */
362 contract ERC20Burnable is StandardToken, Ownable {
363 
364   /**
365    * @dev Burns a specific amount of tokens.
366    * @param value The amount of token to be burned.
367    */
368   function burn(uint256 value) public onlyOwner {
369     _burn(msg.sender, value);
370   }
371 
372   /**
373    * @dev Burns a specific amount of tokens from the target address and decrements allowance
374    * @param from address The address which you want to send tokens from
375    * @param value uint256 The amount of token to be burned
376    */
377   function burnFrom(address from, uint256 value) public onlyOwner {
378     _burn(from, value);
379   }
380   
381 }
382 
383 /**
384  * @title Pausable
385  * @dev Base contract which allows children to implement an emergency stop mechanism.
386  */
387 contract Pausable is Ownable {
388   event Paused();
389   event Unpaused();
390 
391   bool public paused = true;
392 
393   /**
394    * @dev Modifier to make a function callable only when the contract is not paused.
395    */
396   modifier whenNotPaused() {
397     require(!paused);
398     _;
399   }
400 
401   /**
402    * @dev Modifier to make a function callable only when the contract is paused.
403    */
404   modifier whenPaused() {
405     require(paused);
406     _;
407   }
408 
409   /**
410    * @dev called by the owner to pause, triggers stopped state
411    */
412   function pause() public onlyOwner whenNotPaused {
413     paused = true;
414     emit Paused();
415   }
416 
417   /**
418    * @dev called by the owner to unpause, returns to normal state
419    */
420   function unpause() public onlyOwner whenPaused {
421     paused = false;
422     emit Unpaused();
423   }
424 }
425 
426 /**
427  * @title Freezable
428  * @dev Base contract which allows to freeze an Account from making any trabsaction
429  */
430 contract Freezable is Ownable {
431 
432     mapping(address => bool) public frozenAccount;
433 
434     /**
435      * @dev Throws if sender account is not freezed
436      */
437     modifier isFreezenAccount(){
438         require(frozenAccount[msg.sender]);
439         _;
440     }
441 
442     /**
443      * @dev Throws if sender account is freezed
444      */
445     modifier isNonFreezenAccount(){
446         require(!frozenAccount[msg.sender]);
447         _;
448     }
449 
450     /**
451      * @dev Freeze / UnFreeze account from making any transfers
452      * @param _address The address to Freeze.
453      * @param _freeze freeze status.
454      */
455     function freezeAccount(address _address, bool _freeze) onlyOwner public {
456         frozenAccount[_address] = _freeze;
457     }
458 
459     /**
460      * @dev Freeze multiple accounts from making any transfers
461      * @param _addresses Multiple addresses to Freeze.
462      */
463     function freezeAccounts(address[] _addresses) public onlyOwner {
464         for (uint i = 0; i < _addresses.length; i++) {
465             frozenAccount[_addresses[i]] = true;
466         }
467     }
468 
469     /**
470      * @dev UnFreeze multiple accounts from making any transfers
471      * @param _addresses Multiple addresses to UnFreeze.
472      */
473     function unFreezeAccounts(address[] _addresses) public onlyOwner {
474         for (uint i = 0; i < _addresses.length; i++) {
475             frozenAccount[_addresses[i]] = false;
476         }
477     }
478 
479 }
480 
481 /**
482  * @title Whitelist
483  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
484  * This simplifies the implementation of "user permissions".
485  */
486 contract Whitelist is Ownable {
487 
488   mapping(address => bool) public whitelistedAddress;
489 
490   /**
491    * @dev Throws if operator is not whitelisted.
492    * @param _address address
493    */
494   modifier onlyIfWhitelisted(address _address) {
495     require(whitelistedAddress[_address]);
496      _;
497   }
498 
499   /**
500    * @dev add an address to the whitelist
501    * @param _address address
502    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
503    */
504   function addAddressToWhitelist(address _address)
505     public
506     onlyOwner
507   {
508       whitelistedAddress[_address] = true;
509   }
510 
511   /**
512    * @dev add addresses to the whitelist
513    * @param _addresses addresses
514    * @return true if at least one address was added to the whitelist,
515    * false if all addresses were already in the whitelist
516    */
517   function addAddressesToWhitelist(address[] _addresses)
518     public
519     onlyOwner
520   {
521     for (uint256 i = 0; i < _addresses.length; i++) {
522       addAddressToWhitelist(_addresses[i]);
523     }
524   }
525 
526   /**
527    * @dev remove an address from the whitelist
528    * @param _address address
529    * @return true if the address was removed from the whitelist,
530    * false if the address wasn't in the whitelist in the first place
531    */
532   function removeAddressFromWhitelist(address _address)
533     public
534     onlyOwner
535   {
536       whitelistedAddress[_address] = false;
537   }
538 
539   /**
540    * @dev remove addresses from the whitelist
541    * @param _addresses addresses
542    * @return true if at least one address was removed from the whitelist,
543    * false if all addresses weren't in the whitelist in the first place
544    */
545   function removeAddressesFromWhitelist(address[] _addresses)
546     public
547     onlyOwner
548   {
549     for (uint256 i = 0; i < _addresses.length; i++) {
550       removeAddressFromWhitelist(_addresses[i]);
551     }
552   }
553 
554 }
555 
556 contract CustomERC20 is StandardToken, Ownable, Pausable, Freezable, Whitelist, ERC20Burnable , ERC20Mintable {
557 
558 	/**
559 	* @dev Modifier to make a transfer 
560 	* 1) only for owners & Whitelisted addresses
561 	* 2) when the contract is not paused & account is not freezed
562 	*/
563 	modifier onlyIfTransferable() {
564 		require(!paused || whitelistedAddress[msg.sender] || msg.sender == owner);
565 		require(!frozenAccount[msg.sender]);
566 		_;
567 	}
568 
569 	/**
570 	* @dev Transfer tokens from one address to another
571 	* @param _from address The address which you want to send tokens from
572 	* @param _to address The address which you want to transfer to
573 	* @param _value uint256 the amount of tokens to be transferred
574 	*/
575 	function transferFrom(address _from, address _to, uint256 _value) onlyIfTransferable public returns (bool) {
576 		return super.transferFrom(_from, _to, _value);
577 	}
578 
579 	/**
580 	* @dev Transfer token for a specified address
581 	* @param _to The address to transfer to.
582 	* @param _value The amount to be transferred.
583 	*/
584 	function transfer(address _to, uint256 _value) onlyIfTransferable public returns (bool) {
585 		return super.transfer(_to, _value);
586 	}
587 
588 	/**
589 	* @dev Send Airdrops to list of addresses
590 	*/
591 	function sendAirdrops(address[] _addresses, uint256[] _amounts) public {
592 		require(_addresses.length == _amounts.length);
593 		for (uint i = 0; i < _addresses.length; i++) { 
594 			transfer(_addresses[i], _amounts[i]);
595 		}
596 	}
597 	
598 }
599 
600 contract SUNToken is CustomERC20 {
601   string public constant version = "1.0";
602   string public constant name = "SUN PRO SAVERS";
603   string public constant symbol = "SUN";
604   uint8 public constant decimals = 18;
605 
606   uint256 private constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
607 
608   /**
609    * @dev Constructor that gives msg.sender all of existing tokens.
610    */
611   constructor() public {
612     _mint(msg.sender, INITIAL_SUPPLY);
613   }
614 
615 }