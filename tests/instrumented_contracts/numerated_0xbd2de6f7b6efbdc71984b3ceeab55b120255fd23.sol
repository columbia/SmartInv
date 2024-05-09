1 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.18;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
47 
48 pragma solidity ^0.4.18;
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 // File: zeppelin-solidity/contracts/math/SafeMath.sol
64 
65 pragma solidity ^0.4.18;
66 
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73 
74   /**
75   * @dev Multiplies two numbers, throws on overflow.
76   */
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     if (a == 0) {
79       return 0;
80     }
81     uint256 c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   /**
87   * @dev Integer division of two numbers, truncating the quotient.
88   */
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return c;
94   }
95 
96   /**
97   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98   */
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   /**
105   * @dev Adds two numbers, throws on overflow.
106   */
107   function add(uint256 a, uint256 b) internal pure returns (uint256) {
108     uint256 c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
115 
116 pragma solidity ^0.4.18;
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
148     // SafeMath.sub will throw if there is not enough balance.
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164 }
165 
166 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
167 
168 pragma solidity ^0.4.18;
169 
170 
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  */
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender) public view returns (uint256);
178   function transferFrom(address from, address to, uint256 value) public returns (bool);
179   function approve(address spender, uint256 value) public returns (bool);
180   event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
184 
185 pragma solidity ^0.4.18;
186 
187 
188 
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * @dev https://github.com/ethereum/EIPs/issues/20
195  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[_from]);
211     require(_value <= allowed[_from][msg.sender]);
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216     Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public view returns (uint256) {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _addedValue The amount of tokens to increase the allowance by.
255    */
256   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
257     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262   /**
263    * @dev Decrease the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To decrement
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _subtractedValue The amount of tokens to decrease the allowance by.
271    */
272   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
273     uint oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue > oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
286 
287 pragma solidity ^0.4.18;
288 
289 
290 
291 /**
292  * @title Burnable Token
293  * @dev Token that can be irreversibly burned (destroyed).
294  */
295 contract BurnableToken is BasicToken {
296 
297   event Burn(address indexed burner, uint256 value);
298 
299   /**
300    * @dev Burns a specific amount of tokens.
301    * @param _value The amount of token to be burned.
302    */
303   function burn(uint256 _value) public {
304     require(_value <= balances[msg.sender]);
305     // no need to require value <= totalSupply, since that would imply the
306     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
307 
308     address burner = msg.sender;
309     balances[burner] = balances[burner].sub(_value);
310     totalSupply_ = totalSupply_.sub(_value);
311     Burn(burner, _value);
312   }
313 }
314 
315 // File: contracts/ApcToken.sol
316 
317 pragma solidity ^0.4.23;
318 
319 
320 
321 
322 
323 /*
324  * ApcToken is a standard ERC20 token with some additional functionalities:
325  * - Transfers are only enabled after contract owner enables it (after the ICO)
326  * - Contract sets 40% of the total supply as allowance for ICO contract
327  *
328  * Note: Token Offering == Initial Coin Offering(ICO)
329  */
330 
331 contract ApcToken is StandardToken, BurnableToken, Ownable {
332 	string public constant symbol = "APC";
333 	string public constant name = "Agro Paradise Coin";
334 	uint8 public constant decimals = 18;
335 	uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
336 	uint256 public constant TOKEN_OFFERING_ALLOWANCE = 4000000000 * (10 ** uint256(decimals));
337 	uint256 public constant ADMIN_ALLOWANCE = INITIAL_SUPPLY - TOKEN_OFFERING_ALLOWANCE;
338 
339 	// Address of token admin
340 	address public adminAddr;
341 	// Address of token offering
342 	address public tokenOfferingAddr;
343 	// Enable transfers after conclusion of token offering
344 	bool public transferEnabled = true;
345 
346 	/**
347 	 * Check if transfer is allowed
348 	 *
349 	 * Permissions:
350 	 *														Owner	Admin	OfferingContract	Others
351 	 * transfer (before transferEnabled is true)			x		x			x				x
352 	 * transferFrom (before transferEnabled is true)		x		o			o				x
353 	 * transfer/transferFrom(after transferEnabled is true)	o		x			x				o
354 	 */
355 	modifier onlyWhenTransferAllowed() {
356 		require(transferEnabled || msg.sender == adminAddr || msg.sender == tokenOfferingAddr);
357 		_;
358 	}
359 
360 	/**
361 	 * Check if token offering address is set or not
362 	 */
363 	modifier onlyTokenOfferingAddrNotSet() {
364 		require(tokenOfferingAddr == address(0x0));
365 		_;
366 	}
367 
368 	/**
369 	* Check if address is a valid destination to transfer tokens to
370 	* - must not be zero address
371 	* - must not be the token address
372 	* - must not be the owner's address
373 	* - must not be the admin's address
374 	* - must not be the token offering contract address
375 	*/
376 	modifier validDestination(address to) {
377 		require(to != address(0x0));
378 		require(to != address(this));
379 		require(to != owner);
380 		require(to != address(adminAddr));
381 		require(to != address(tokenOfferingAddr));
382 		_;
383 	}	
384 
385 	/**
386 	* Token contract constructor
387 	*
388 	* @param admin Address of admin account
389 	*/
390 	function ApcToken(address admin) public {
391 		totalSupply_ = INITIAL_SUPPLY;
392 
393 		// Mint tokens
394 		balances[msg.sender] = totalSupply_;
395 		Transfer(address(0x0), msg.sender, totalSupply_);
396 
397 		// Approve allowance for admin account
398 		adminAddr = admin;
399 		approve(adminAddr, ADMIN_ALLOWANCE);
400 	}
401 
402 	/**
403 	* Set token offering to approve allowance for offering contract to distribute tokens
404 	*
405 	* @param offeringAddr Address of token offering contract
406 	* @param amountForSale Amount of tokens for sale, set 0 to max out
407 	*/
408 	function setTokenOffering(address offeringAddr, uint256 amountForSale) external onlyOwner onlyTokenOfferingAddrNotSet {
409 		require(!transferEnabled);
410 
411 		uint256 amount = (amountForSale == 0) ? TOKEN_OFFERING_ALLOWANCE : amountForSale;
412 		require(amount <= TOKEN_OFFERING_ALLOWANCE);
413 
414 		approve(offeringAddr, amount);
415 		tokenOfferingAddr = offeringAddr;
416 	}
417 
418 	/**
419 	* Enable transfers
420 	*/
421 	function enableTransfer() external onlyOwner {
422 		transferEnabled = true;
423 
424 		// End the offering
425 		approve(tokenOfferingAddr, 0);
426 	}
427 
428 	/**
429 	* Transfer from sender to another account
430 	*
431 	* @param to Destination address
432 	* @param value Amount of apctokens to send
433 	*/
434 	function transfer(address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
435 		return super.transfer(to, value);
436 	}
437 
438 	/**
439 	* Transfer from `from` account to `to` account using allowance in `from` account to the sender
440 	*
441 	* @param from Origin address
442 	* @param to Destination address
443 	* @param value Amount of apctokens to send
444 	*/
445 	function transferFrom(address from, address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
446 		return super.transferFrom(from, to, value);
447 	}
448 
449 	/**
450 	* Burn token, only owner is allowed to do this
451 	*
452 	* @param value Amount of tokens to burn
453 	*/
454 	function burn(uint256 value) public {
455 		require(transferEnabled || msg.sender == owner);
456 		super.burn(value);
457 	}
458 }