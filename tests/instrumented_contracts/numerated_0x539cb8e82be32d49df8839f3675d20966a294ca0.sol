1 pragma solidity ^0.4.24;
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * See https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address _who) public view returns (uint256);
77   function transfer(address _to, uint256 _value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
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
92   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
93     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
94     // benefit is lost if 'b' is also tested.
95     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
96     if (_a == 0) {
97       return 0;
98     }
99 
100     c = _a * _b;
101     assert(c / _a == _b);
102     return c;
103   }
104 
105   /**
106   * @dev Integer division of two numbers, truncating the quotient.
107   */
108   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
109     // assert(_b > 0); // Solidity automatically throws when dividing by 0
110     // uint256 c = _a / _b;
111     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
112     return _a / _b;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
119     assert(_b <= _a);
120     return _a - _b;
121   }
122 
123   /**
124   * @dev Adds two numbers, throws on overflow.
125   */
126   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
127     c = _a + _b;
128     assert(c >= _a);
129     return c;
130   }
131 }
132 
133 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) internal balances;
143 
144   uint256 internal totalSupply_;
145 
146   /**
147   * @dev Total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_value <= balances[msg.sender]);
160     require(_to != address(0));
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address _owner, address _spender)
187     public view returns (uint256);
188 
189   function transferFrom(address _from, address _to, uint256 _value)
190     public returns (bool);
191 
192   function approve(address _spender, uint256 _value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * https://github.com/ethereum/EIPs/issues/20
207  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(
221     address _from,
222     address _to,
223     uint256 _value
224   )
225     public
226     returns (bool)
227   {
228     require(_value <= balances[_from]);
229     require(_value <= allowed[_from][msg.sender]);
230     require(_to != address(0));
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(
261     address _owner,
262     address _spender
263    )
264     public
265     view
266     returns (uint256)
267   {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint256 _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint256 oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue >= oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
322 
323 /**
324  * @title Burnable Token
325  * @dev Token that can be irreversibly burned (destroyed).
326  */
327 contract BurnableToken is BasicToken {
328 
329   event Burn(address indexed burner, uint256 value);
330 
331   /**
332    * @dev Burns a specific amount of tokens.
333    * @param _value The amount of token to be burned.
334    */
335   function burn(uint256 _value) public {
336     _burn(msg.sender, _value);
337   }
338 
339   function _burn(address _who, uint256 _value) internal {
340     require(_value <= balances[_who]);
341     // no need to require value <= totalSupply, since that would imply the
342     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
343 
344     balances[_who] = balances[_who].sub(_value);
345     totalSupply_ = totalSupply_.sub(_value);
346     emit Burn(_who, _value);
347     emit Transfer(_who, address(0), _value);
348   }
349 }
350 
351 // File: contracts/AirisuToken.sol
352 
353 /*
354  * AirisuToken is a standard ERC20 token with some additional functionalities:
355  * - Transfers are only enabled after contract owner enables it (after the ICO)
356  * - Contract sets 40% of the total supply as allowance for ICO contract
357  *
358  * Note: Token Offering == Initial Coin Offering(ICO)
359  */
360 
361 contract AirisuToken is StandardToken, BurnableToken, Ownable {
362 	string public constant symbol = "AIRISU";
363 	string public constant name = "AIRISU COIN";
364 	uint8 public constant decimals = 18;
365 	uint256 public constant INITIAL_SUPPLY = 18000000000 * (10 ** uint256(decimals));
366 	uint256 public constant TOKEN_OFFERING_ALLOWANCE = 7200000000 * (10 ** uint256(decimals));
367 	uint256 public constant ADMIN_ALLOWANCE = INITIAL_SUPPLY - TOKEN_OFFERING_ALLOWANCE;
368 
369 	// Address of token admin
370 	address public adminAddr;
371 	// Address of token offering
372 	address public tokenOfferingAddr;
373 	// Enable transfers after conclusion of token offering
374 	bool public transferEnabled = true;
375 
376 	/**
377 	 * Check if transfer is allowed
378 	 *
379 	 * Permissions:
380 	 *														Owner	Admin	OfferingContract	Others
381 	 * transfer (before transferEnabled is true)			x		x			x				x
382 	 * transferFrom (before transferEnabled is true)		x		o			o				x
383 	 * transfer/transferFrom(after transferEnabled is true)	o		x			x				o
384 	 */
385 	modifier onlyWhenTransferAllowed() {
386 		require(transferEnabled || msg.sender == adminAddr || msg.sender == tokenOfferingAddr);
387 		_;
388 	}
389 
390 	/**
391 	 * Check if token offering address is set or not
392 	 */
393 	modifier onlyTokenOfferingAddrNotSet() {
394 		require(tokenOfferingAddr == address(0x0));
395 		_;
396 	}
397 
398 	/**
399 	* Check if address is a valid destination to transfer tokens to
400 	* - must not be zero address
401 	* - must not be the token address
402 	* - must not be the owner's address
403 	* - must not be the admin's address
404 	* - must not be the token offering contract address
405 	*/
406 	modifier validDestination(address to) {
407 		require(to != address(0x0));
408 		require(to != address(this));
409 		require(to != owner);
410 		require(to != address(adminAddr));
411 		require(to != address(tokenOfferingAddr));
412 		_;
413 	}	
414 
415 	/**
416 	* Token contract constructor
417 	*
418 	* @param admin Address of admin account
419 	*/
420 	function AirisuToken(address admin) public {
421 		totalSupply_ = INITIAL_SUPPLY;
422 
423 		// Mint tokens
424 		balances[msg.sender] = totalSupply_;
425 		Transfer(address(0x0), msg.sender, totalSupply_);
426 
427 		// Approve allowance for admin account
428 		adminAddr = admin;
429 		approve(adminAddr, ADMIN_ALLOWANCE);
430 	}
431 
432 	/**
433 	* Set token offering to approve allowance for offering contract to distribute tokens
434 	*
435 	* @param offeringAddr Address of token offering contract
436 	* @param amountForSale Amount of tokens for sale, set 0 to max out
437 	*/
438 	function setTokenOffering(address offeringAddr, uint256 amountForSale) external onlyOwner onlyTokenOfferingAddrNotSet {
439 		require(!transferEnabled);
440 
441 		uint256 amount = (amountForSale == 0) ? TOKEN_OFFERING_ALLOWANCE : amountForSale;
442 		require(amount <= TOKEN_OFFERING_ALLOWANCE);
443 
444 		approve(offeringAddr, amount);
445 		tokenOfferingAddr = offeringAddr;
446 	}
447 
448 	/**
449 	* Enable transfers
450 	*/
451 	function enableTransfer() external onlyOwner {
452 		transferEnabled = true;
453 
454 		// End the offering
455 		approve(tokenOfferingAddr, 0);
456 	}
457 
458 	/**
459 	* Transfer from sender to another account
460 	*
461 	* @param to Destination address
462 	* @param value Amount of airisutokens to send
463 	*/
464 	function transfer(address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
465 		return super.transfer(to, value);
466 	}
467 
468 	/**
469 	* Transfer from `from` account to `to` account using allowance in `from` account to the sender
470 	*
471 	* @param from Origin address
472 	* @param to Destination address
473 	* @param value Amount of airisutokens to send
474 	*/
475 	function transferFrom(address from, address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
476 		return super.transferFrom(from, to, value);
477 	}
478 
479 	/**
480 	* Burn token, only owner is allowed to do this
481 	*
482 	* @param value Amount of tokens to burn
483 	*/
484 	function burn(uint256 value) public {
485 		require(transferEnabled || msg.sender == owner);
486 		super.burn(value);
487 	}
488 }