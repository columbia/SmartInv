1 pragma solidity ^0.4.18;
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
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
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
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
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
155 
156 /**
157  * @title Burnable Token
158  * @dev Token that can be irreversibly burned (destroyed).
159  */
160 contract BurnableToken is BasicToken {
161 
162   event Burn(address indexed burner, uint256 value);
163 
164   /**
165    * @dev Burns a specific amount of tokens.
166    * @param _value The amount of token to be burned.
167    */
168   function burn(uint256 _value) public {
169     require(_value <= balances[msg.sender]);
170     // no need to require value <= totalSupply, since that would imply the
171     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
172 
173     address burner = msg.sender;
174     balances[burner] = balances[burner].sub(_value);
175     totalSupply_ = totalSupply_.sub(_value);
176     Burn(burner, _value);
177   }
178 }
179 
180 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 contract ERC20 is ERC20Basic {
187   function allowance(address owner, address spender) public view returns (uint256);
188   function transferFrom(address from, address to, uint256 value) public returns (bool);
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
194 
195 /**
196  * @title Standard ERC20 token
197  *
198  * @dev Implementation of the basic standard token.
199  * @dev https://github.com/ethereum/EIPs/issues/20
200  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
201  */
202 contract StandardToken is ERC20, BasicToken {
203 
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217 
218     balances[_from] = balances[_from].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221     Transfer(_from, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    *
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     Approval(msg.sender, _spender, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Function to check the amount of tokens that an owner allowed to a spender.
243    * @param _owner address The address which owns the funds.
244    * @param _spender address The address which will spend the funds.
245    * @return A uint256 specifying the amount of tokens still available for the spender.
246    */
247   function allowance(address _owner, address _spender) public view returns (uint256) {
248     return allowed[_owner][_spender];
249   }
250 
251   /**
252    * @dev Increase the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To increment
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _addedValue The amount of tokens to increase the allowance by.
260    */
261   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
262     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
263     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Decrease the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
278     uint oldValue = allowed[msg.sender][_spender];
279     if (_subtractedValue > oldValue) {
280       allowed[msg.sender][_spender] = 0;
281     } else {
282       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
283     }
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288 }
289 
290 // File: contracts/ForestingToken.sol
291 
292 /*
293  * ForestingToken is a standard ERC20 token with some additional functionalities:
294  * - Transfers are only enabled after contract owner enables it (after the ICO)
295  * - Contract sets 40% of the total supply as allowance for ICO contract
296  *
297  * Note: Token Offering == Initial Coin Offering(ICO)
298  */
299 
300 contract ForestingToken is StandardToken, BurnableToken, Ownable {
301 	string public constant symbol = "PTON";
302 	string public constant name = "Foresting Token";
303 	uint8 public constant decimals = 18;
304 	uint256 public constant INITIAL_SUPPLY = 24000000000 * (10 ** uint256(decimals));
305 	uint256 public constant TOKEN_OFFERING_ALLOWANCE = 9600000000 * (10 ** uint256(decimals));
306 	uint256 public constant ADMIN_ALLOWANCE = INITIAL_SUPPLY - TOKEN_OFFERING_ALLOWANCE;
307 
308 	// Address of token admin
309 	address public adminAddr;
310 	// Address of token offering
311 	address public tokenOfferingAddr;
312 	// Enable transfers after conclusion of token offering
313 	bool public transferEnabled = true;
314 
315 	/**
316 	 * Check if transfer is allowed
317 	 *
318 	 * Permissions:
319 	 *														Owner	Admin	OfferingContract	Others
320 	 * transfer (before transferEnabled is true)			x		x			x				x
321 	 * transferFrom (before transferEnabled is true)		x		o			o				x
322 	 * transfer/transferFrom(after transferEnabled is true)	o		x			x				o
323 	 */
324 	modifier onlyWhenTransferAllowed() {
325 		require(transferEnabled || msg.sender == adminAddr || msg.sender == tokenOfferingAddr);
326 		_;
327 	}
328 
329 	/**
330 	 * Check if token offering address is set or not
331 	 */
332 	modifier onlyTokenOfferingAddrNotSet() {
333 		require(tokenOfferingAddr == address(0x0));
334 		_;
335 	}
336 
337 	/**
338 	* Check if address is a valid destination to transfer tokens to
339 	* - must not be zero address
340 	* - must not be the token address
341 	* - must not be the owner's address
342 	* - must not be the admin's address
343 	* - must not be the token offering contract address
344 	*/
345 	modifier validDestination(address to) {
346 		require(to != address(0x0));
347 		require(to != address(this));
348 		require(to != owner);
349 		require(to != address(adminAddr));
350 		require(to != address(tokenOfferingAddr));
351 		_;
352 	}	
353 
354 	/**
355 	* Token contract constructor
356 	*
357 	* @param admin Address of admin account
358 	*/
359 	function ForestingToken(address admin) public {
360 		totalSupply_ = INITIAL_SUPPLY;
361 
362 		// Mint tokens
363 		balances[msg.sender] = totalSupply_;
364 		Transfer(address(0x0), msg.sender, totalSupply_);
365 
366 		// Approve allowance for admin account
367 		adminAddr = admin;
368 		approve(adminAddr, ADMIN_ALLOWANCE);
369 	}
370 
371 	/**
372 	* Set token offering to approve allowance for offering contract to distribute tokens
373 	*
374 	* @param offeringAddr Address of token offering contract
375 	* @param amountForSale Amount of tokens for sale, set 0 to max out
376 	*/
377 	function setTokenOffering(address offeringAddr, uint256 amountForSale) external onlyOwner onlyTokenOfferingAddrNotSet {
378 		require(!transferEnabled);
379 
380 		uint256 amount = (amountForSale == 0) ? TOKEN_OFFERING_ALLOWANCE : amountForSale;
381 		require(amount <= TOKEN_OFFERING_ALLOWANCE);
382 
383 		approve(offeringAddr, amount);
384 		tokenOfferingAddr = offeringAddr;
385 	}
386 
387 	/**
388 	* Enable transfers
389 	*/
390 	function enableTransfer() external onlyOwner {
391 		transferEnabled = true;
392 
393 		// End the offering
394 		approve(tokenOfferingAddr, 0);
395 	}
396 
397 	/**
398 	* Transfer from sender to another account
399 	*
400 	* @param to Destination address
401 	* @param value Amount of forestingtokens to send
402 	*/
403 	function transfer(address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
404 		return super.transfer(to, value);
405 	}
406 
407 	/**
408 	* Transfer from `from` account to `to` account using allowance in `from` account to the sender
409 	*
410 	* @param from Origin address
411 	* @param to Destination address
412 	* @param value Amount of forestingtokens to send
413 	*/
414 	function transferFrom(address from, address to, uint256 value) public onlyWhenTransferAllowed validDestination(to) returns (bool) {
415 		return super.transferFrom(from, to, value);
416 	}
417 
418 	/**
419 	* Burn token, only owner is allowed to do this
420 	*
421 	* @param value Amount of tokens to burn
422 	*/
423 	function burn(uint256 value) public {
424 		require(transferEnabled || msg.sender == owner);
425 		super.burn(value);
426 	}
427 }