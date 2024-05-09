1 pragma solidity ^0.4.24;
2 
3 // File: zos-lib/contracts/migrations/Migratable.sol
4 
5 /**
6  * @title Migratable
7  * Helper contract to support intialization and migration schemes between
8  * different implementations of a contract in the context of upgradeability.
9  * To use it, replace the constructor with a function that has the
10  * `isInitializer` modifier starting with `"0"` as `migrationId`.
11  * When you want to apply some migration code during an upgrade, increase
12  * the `migrationId`. Or, if the migration code must be applied only after
13  * another migration has been already applied, use the `isMigration` modifier.
14  * This helper supports multiple inheritance.
15  * WARNING: It is the developer's responsibility to ensure that migrations are
16  * applied in a correct order, or that they are run at all.
17  * See `Initializable` for a simpler version.
18  */
19 contract Migratable {
20   /**
21    * @dev Emitted when the contract applies a migration.
22    * @param contractName Name of the Contract.
23    * @param migrationId Identifier of the migration applied.
24    */
25   event Migrated(string contractName, string migrationId);
26 
27   /**
28    * @dev Mapping of the already applied migrations.
29    * (contractName => (migrationId => bool))
30    */
31   mapping (string => mapping (string => bool)) internal migrated;
32 
33   /**
34    * @dev Internal migration id used to specify that a contract has already been initialized.
35    */
36   string constant private INITIALIZED_ID = "initialized";
37 
38 
39   /**
40    * @dev Modifier to use in the initialization function of a contract.
41    * @param contractName Name of the contract.
42    * @param migrationId Identifier of the migration.
43    */
44   modifier isInitializer(string contractName, string migrationId) {
45     validateMigrationIsPending(contractName, INITIALIZED_ID);
46     validateMigrationIsPending(contractName, migrationId);
47     _;
48     emit Migrated(contractName, migrationId);
49     migrated[contractName][migrationId] = true;
50     migrated[contractName][INITIALIZED_ID] = true;
51   }
52 
53   /**
54    * @dev Modifier to use in the migration of a contract.
55    * @param contractName Name of the contract.
56    * @param requiredMigrationId Identifier of the previous migration, required
57    * to apply new one.
58    * @param newMigrationId Identifier of the new migration to be applied.
59    */
60   modifier isMigration(string contractName, string requiredMigrationId, string newMigrationId) {
61     require(isMigrated(contractName, requiredMigrationId), "Prerequisite migration ID has not been run yet");
62     validateMigrationIsPending(contractName, newMigrationId);
63     _;
64     emit Migrated(contractName, newMigrationId);
65     migrated[contractName][newMigrationId] = true;
66   }
67 
68   /**
69    * @dev Returns true if the contract migration was applied.
70    * @param contractName Name of the contract.
71    * @param migrationId Identifier of the migration.
72    * @return true if the contract migration was applied, false otherwise.
73    */
74   function isMigrated(string contractName, string migrationId) public view returns(bool) {
75     return migrated[contractName][migrationId];
76   }
77 
78   /**
79    * @dev Initializer that marks the contract as initialized.
80    * It is important to run this if you had deployed a previous version of a Migratable contract.
81    * For more information see https://github.com/zeppelinos/zos-lib/issues/158.
82    */
83   function initialize() isInitializer("Migratable", "1.2.1") public {
84   }
85 
86   /**
87    * @dev Reverts if the requested migration was already executed.
88    * @param contractName Name of the contract.
89    * @param migrationId Identifier of the migration.
90    */
91   function validateMigrationIsPending(string contractName, string migrationId) private {
92     require(!isMigrated(contractName, migrationId), "Requested target migration ID has already been run");
93   }
94 }
95 
96 // File: openzeppelin-zos/contracts/token/ERC20/ERC20Basic.sol
97 
98 /**
99  * @title ERC20Basic
100  * @dev Simpler version of ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/179
102  */
103 contract ERC20Basic {
104   function totalSupply() public view returns (uint256);
105   function balanceOf(address who) public view returns (uint256);
106   function transfer(address to, uint256 value) public returns (bool);
107   event Transfer(address indexed from, address indexed to, uint256 value);
108 }
109 
110 // File: openzeppelin-zos/contracts/token/ERC20/ERC20.sol
111 
112 /**
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender) public view returns (uint256);
118   function transferFrom(address from, address to, uint256 value) public returns (bool);
119   function approve(address spender, uint256 value) public returns (bool);
120   event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 // File: openzeppelin-zos/contracts/token/ERC20/DetailedERC20.sol
124 
125 contract DetailedERC20 is Migratable, ERC20 {
126   string public name;
127   string public symbol;
128   uint8 public decimals;
129 
130   function initialize(string _name, string _symbol, uint8 _decimals) public isInitializer("DetailedERC20", "1.9.0") {
131     name = _name;
132     symbol = _symbol;
133     decimals = _decimals;
134   }
135 }
136 
137 // File: openzeppelin-zos/contracts/math/SafeMath.sol
138 
139 /**
140  * @title SafeMath
141  * @dev Math operations with safety checks that throw on error
142  */
143 library SafeMath {
144 
145   /**
146   * @dev Multiplies two numbers, throws on overflow.
147   */
148   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
149     if (a == 0) {
150       return 0;
151     }
152     c = a * b;
153     assert(c / a == b);
154     return c;
155   }
156 
157   /**
158   * @dev Integer division of two numbers, truncating the quotient.
159   */
160   function div(uint256 a, uint256 b) internal pure returns (uint256) {
161     // assert(b > 0); // Solidity automatically throws when dividing by 0
162     // uint256 c = a / b;
163     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164     return a / b;
165   }
166 
167   /**
168   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
169   */
170   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171     assert(b <= a);
172     return a - b;
173   }
174 
175   /**
176   * @dev Adds two numbers, throws on overflow.
177   */
178   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
179     c = a + b;
180     assert(c >= a);
181     return c;
182   }
183 }
184 
185 // File: openzeppelin-zos/contracts/token/ERC20/BasicToken.sol
186 
187 /**
188  * @title Basic token
189  * @dev Basic version of StandardToken, with no allowances.
190  */
191 contract BasicToken is ERC20Basic {
192   using SafeMath for uint256;
193 
194   mapping(address => uint256) balances;
195 
196   uint256 totalSupply_;
197 
198   /**
199   * @dev total number of tokens in existence
200   */
201   function totalSupply() public view returns (uint256) {
202     return totalSupply_;
203   }
204 
205   /**
206   * @dev transfer token for a specified address
207   * @param _to The address to transfer to.
208   * @param _value The amount to be transferred.
209   */
210   function transfer(address _to, uint256 _value) public returns (bool) {
211     require(_to != address(0));
212     require(_value <= balances[msg.sender]);
213 
214     balances[msg.sender] = balances[msg.sender].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     emit Transfer(msg.sender, _to, _value);
217     return true;
218   }
219 
220   /**
221   * @dev Gets the balance of the specified address.
222   * @param _owner The address to query the the balance of.
223   * @return An uint256 representing the amount owned by the passed address.
224   */
225   function balanceOf(address _owner) public view returns (uint256) {
226     return balances[_owner];
227   }
228 
229 }
230 
231 // File: openzeppelin-zos/contracts/token/ERC20/StandardToken.sol
232 
233 /**
234  * @title Standard ERC20 token
235  *
236  * @dev Implementation of the basic standard token.
237  * @dev https://github.com/ethereum/EIPs/issues/20
238  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
239  */
240 contract StandardToken is ERC20, BasicToken {
241 
242   mapping (address => mapping (address => uint256)) internal allowed;
243 
244 
245   /**
246    * @dev Transfer tokens from one address to another
247    * @param _from address The address which you want to send tokens from
248    * @param _to address The address which you want to transfer to
249    * @param _value uint256 the amount of tokens to be transferred
250    */
251   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
252     require(_to != address(0));
253     require(_value <= balances[_from]);
254     require(_value <= allowed[_from][msg.sender]);
255 
256     balances[_from] = balances[_from].sub(_value);
257     balances[_to] = balances[_to].add(_value);
258     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259     emit Transfer(_from, _to, _value);
260     return true;
261   }
262 
263   /**
264    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
265    *
266    * Beware that changing an allowance with this method brings the risk that someone may use both the old
267    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
268    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
269    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270    * @param _spender The address which will spend the funds.
271    * @param _value The amount of tokens to be spent.
272    */
273   function approve(address _spender, uint256 _value) public returns (bool) {
274     allowed[msg.sender][_spender] = _value;
275     emit Approval(msg.sender, _spender, _value);
276     return true;
277   }
278 
279   /**
280    * @dev Function to check the amount of tokens that an owner allowed to a spender.
281    * @param _owner address The address which owns the funds.
282    * @param _spender address The address which will spend the funds.
283    * @return A uint256 specifying the amount of tokens still available for the spender.
284    */
285   function allowance(address _owner, address _spender) public view returns (uint256) {
286     return allowed[_owner][_spender];
287   }
288 
289   /**
290    * @dev Increase the amount of tokens that an owner allowed to a spender.
291    *
292    * approve should be called when allowed[_spender] == 0. To increment
293    * allowed value is better to use this function to avoid 2 calls (and wait until
294    * the first transaction is mined)
295    * From MonolithDAO Token.sol
296    * @param _spender The address which will spend the funds.
297    * @param _addedValue The amount of tokens to increase the allowance by.
298    */
299   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
300     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
301     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305   /**
306    * @dev Decrease the amount of tokens that an owner allowed to a spender.
307    *
308    * approve should be called when allowed[_spender] == 0. To decrement
309    * allowed value is better to use this function to avoid 2 calls (and wait until
310    * the first transaction is mined)
311    * From MonolithDAO Token.sol
312    * @param _spender The address which will spend the funds.
313    * @param _subtractedValue The amount of tokens to decrease the allowance by.
314    */
315   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
316     uint oldValue = allowed[msg.sender][_spender];
317     if (_subtractedValue > oldValue) {
318       allowed[msg.sender][_spender] = 0;
319     } else {
320       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
321     }
322     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
323     return true;
324   }
325 
326 }
327 
328 // File: openzeppelin-zos/contracts/ownership/Ownable.sol
329 
330 /**
331  * @title Ownable
332  * @dev The Ownable contract has an owner address, and provides basic authorization control
333  * functions, this simplifies the implementation of "user permissions".
334  */
335 contract Ownable is Migratable {
336   address public owner;
337 
338 
339   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
340 
341   /**
342    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
343    * account.
344    */
345   function initialize(address _sender) public isInitializer("Ownable", "1.9.0") {
346     owner = _sender;
347   }
348 
349   /**
350    * @dev Throws if called by any account other than the owner.
351    */
352   modifier onlyOwner() {
353     require(msg.sender == owner);
354     _;
355   }
356 
357   /**
358    * @dev Allows the current owner to transfer control of the contract to a newOwner.
359    * @param newOwner The address to transfer ownership to.
360    */
361   function transferOwnership(address newOwner) public onlyOwner {
362     require(newOwner != address(0));
363     emit OwnershipTransferred(owner, newOwner);
364     owner = newOwner;
365   }
366 
367 }
368 
369 // File: openzeppelin-zos/contracts/token/ERC20/MintableToken.sol
370 
371 /**
372  * @title Mintable token
373  * @dev Simple ERC20 Token example, with mintable token creation
374  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
375  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
376  */
377 contract MintableToken is Migratable, Ownable, StandardToken {
378   event Mint(address indexed to, uint256 amount);
379   event MintFinished();
380 
381   bool public mintingFinished = false;
382 
383 
384   modifier canMint() {
385     require(!mintingFinished);
386     _;
387   }
388 
389   function initialize(address _sender) isInitializer("MintableToken", "1.9.0")  public {
390     Ownable.initialize(_sender);
391   }
392 
393   /**
394    * @dev Function to mint tokens
395    * @param _to The address that will receive the minted tokens.
396    * @param _amount The amount of tokens to mint.
397    * @return A boolean that indicates if the operation was successful.
398    */
399   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
400     totalSupply_ = totalSupply_.add(_amount);
401     balances[_to] = balances[_to].add(_amount);
402     emit Mint(_to, _amount);
403     emit Transfer(address(0), _to, _amount);
404     return true;
405   }
406 
407   /**
408    * @dev Function to stop minting new tokens.
409    * @return True if the operation was successful.
410    */
411   function finishMinting() onlyOwner canMint public returns (bool) {
412     mintingFinished = true;
413     emit MintFinished();
414     return true;
415   }
416 }
417 
418 // File: openzeppelin-zos/contracts/token/ERC20/DetailedPremintedToken.sol
419 
420 contract DetailedPremintedToken is Migratable, DetailedERC20, StandardToken {
421   function initialize(
422     address _sender,
423     string _name,
424     string _symbol,
425     uint8 _decimals,
426     uint256 _initialBalance
427   )
428     isInitializer("DetailedPremintedToken", "1.9.0")
429     public
430   {
431     DetailedERC20.initialize(_name, _symbol, _decimals);
432 
433     _premint(_sender, _initialBalance);
434   }
435 
436   function _premint(address _to, uint256 _value) internal {
437     totalSupply_ += _value;
438     balances[_to] += _value;
439     emit Transfer(0, _to, _value);
440   }
441 }
442 
443 // File: contracts/S4FE.sol
444 
445 /**
446  * @title S4FE
447  * @dev ERC20 Token, where all tokens are pre-assigned to the creator.
448  * Note they can later distribute these tokens as they wish using `transfer`
449  */
450 contract S4FE is Ownable, DetailedPremintedToken {
451 	uint256 public INITIAL_SUPPLY;
452 
453 	bool public transferLocked;
454 	mapping (address => bool) public transferWhitelist;
455 
456 	/**
457 	 * @dev Constructor that gives msg.sender all of existing tokens.
458 	 */
459 	constructor() public {
460 
461 	}
462 
463 	/**
464 	 * @dev initialize method to start constructor logic
465 	 * 
466 	 * @param _owner address of owner
467 	 */
468 	function initializeS4FE(address _owner) isInitializer('S4FE', '0') public {
469 		INITIAL_SUPPLY = 1000000000 * (10 ** uint256(18));
470 
471 		Ownable.initialize(_owner);
472 		DetailedPremintedToken.initialize(_owner, "S4FE", "S4F", 18, INITIAL_SUPPLY);
473 	}
474 
475 	/**
476 	* @dev if ether is sent to this address, send it back.
477 	*/
478 	function () public {
479 		revert();
480 	}
481 
482 	/**
483 	 * @dev transfer token for a specified address
484 	 * @param _to The address to transfer to.
485 	 * @param _value The amount to be transferred.
486 	 */
487 	function transfer(address _to, uint256 _value) public returns (bool) {
488 		require(msg.sender == owner || transferLocked == false || transferWhitelist[msg.sender] == true);
489 
490 		bool result = super.transfer(_to , _value);
491 		return result;
492 	}
493 
494 	/**
495 	 * @dev transfer lock status
496 	 * @param _transferLocked Boolean indicating if transfer is locked
497 	 */
498 	function setTransferLocked(bool _transferLocked) onlyOwner public returns (bool) {
499 		transferLocked = _transferLocked;
500 		return transferLocked;
501 	}
502 
503 	/**
504 	 * @dev transfer lock status
505 	 * @param _address Address of account indicating if allowed
506 	 * @param _transferLocked Boolean indicating if transfer is locked
507 	 */
508 	function setTransferWhitelist(address _address, bool _transferLocked) onlyOwner public returns (bool) {
509 		transferWhitelist[_address] = _transferLocked;
510 		return _transferLocked;
511 	}
512 
513 	/**
514 	 * @dev whitelist addresses
515 	 * @param _addresses Array of address of account for whitelist
516 	 */
517 	function whitelist(address[] _addresses) onlyOwner public {
518 		for(uint i = 0; i < _addresses.length ; i ++) {
519 			transferWhitelist[_addresses[i]] = true;
520 		}
521 	}
522 
523 	/**
524 	 * @dev blacklist addresses
525 	 * @param _addresses Array of address of account for whitelist
526 	 */
527 	function blacklist(address[] _addresses) onlyOwner public {
528 		for(uint i = 0; i < _addresses.length ; i ++) {
529 			transferWhitelist[_addresses[i]] = false;
530 		}
531 	}
532 }