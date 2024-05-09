1 pragma solidity ^0.4.23;
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
45 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 // File: zeppelin-solidity/contracts/math/SafeMath.sol
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71     if (a == 0) {
72       return 0;
73     }
74     uint256 c = a * b;
75     assert(c / a == b);
76     return c;
77   }
78 
79   /**
80   * @dev Integer division of two numbers, truncating the quotient.
81   */
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return c;
87   }
88 
89   /**
90   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   /**
98   * @dev Adds two numbers, throws on overflow.
99   */
100   function add(uint256 a, uint256 b) internal pure returns (uint256) {
101     uint256 c = a + b;
102     assert(c >= a);
103     return c;
104   }
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
154 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
265 
266 /**
267  * @title Burnable Token
268  * @dev Token that can be irreversibly burned (destroyed).
269  */
270 contract BurnableToken is BasicToken {
271 
272   event Burn(address indexed burner, uint256 value);
273 
274   /**
275    * @dev Burns a specific amount of tokens.
276    * @param _value The amount of token to be burned.
277    */
278   function burn(uint256 _value) public {
279     require(_value <= balances[msg.sender]);
280     // no need to require value <= totalSupply, since that would imply the
281     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
282 
283     address burner = msg.sender;
284     balances[burner] = balances[burner].sub(_value);
285     totalSupply_ = totalSupply_.sub(_value);
286     Burn(burner, _value);
287   }
288 }
289 
290 // File: contracts/HygenerToken.sol
291 
292 /*
293  * HygenerToken is a standard ERC20 token with some additional functionalities:
294  * - Transfers are only enabled after contract owner enables it (after the ICO)
295  * - Contract sets 40% of the total supply as allowance for ICO contract
296  *
297  * Note: Token Offering == Initial Coin Offering(ICO)
298  */
299 
300 contract HygenerToken is StandardToken, BurnableToken, Ownable {
301 	string public constant symbol = "HGC";
302 	string public constant name = "HYGENERCOIN";
303 	uint8 public constant decimals = 18;
304 	uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
305 	uint256 public constant TOKEN_OFFERING_ALLOWANCE = 4000000000 * (10 ** uint256(decimals));
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
359 	function HygenerToken(address admin) public {
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
401 	* @param value Amount of hygenertokens to send
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
412 	* @param value Amount of hygenertokens to send
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