1 pragma solidity ^0.4.21;
2 
3 
4 
5 /**
6  * @title AddressTools
7  * @dev Useful tools for address type
8  */
9 library AddressTools {
10 	
11 	/**
12 	* @dev Returns true if given address is the contract address, otherwise - returns false
13 	*/
14 	function isContract(address a) internal view returns (bool) {
15 		if(a == address(0)) {
16 			return false;
17 		}
18 		
19 		uint codeSize;
20 		// solium-disable-next-line security/no-inline-assembly
21 		assembly {
22 			codeSize := extcodesize(a)
23 		}
24 		
25 		if(codeSize > 0) {
26 			return true;
27 		}
28 		
29 		return false;
30 	}
31 	
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40 	
41 	address public owner;
42 	address public potentialOwner;
43 	
44 	
45 	event OwnershipRemoved(address indexed previousOwner);
46 	event OwnershipTransfer(address indexed previousOwner, address indexed newOwner);
47 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 	
49 	
50 	/**
51 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52 	 * account.
53 	 */
54 	function Ownable() public {
55 		owner = msg.sender;
56 	}
57 	
58 	
59 	/**
60 	 * @dev Throws if called by any account other than the owner.
61 	 */
62 	modifier onlyOwner() {
63 		require(msg.sender == owner);
64 		_;
65 	}
66 	
67 	
68 	/**
69 	 * @dev Throws if called by any account other than the owner.
70 	 */
71 	modifier onlyPotentialOwner() {
72 		require(msg.sender == potentialOwner);
73 		_;
74 	}
75 	
76 	
77 	/**
78 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
79 	 * @param newOwner The address of potential new owner to transfer ownership to.
80 	 */
81 	function transferOwnership(address newOwner) public onlyOwner {
82 		require(newOwner != address(0));
83 		emit OwnershipTransfer(owner, newOwner);
84 		potentialOwner = newOwner;
85 	}
86 	
87 	
88 	/**
89 	 * @dev Allow the potential owner confirm ownership of the contract.
90 	 */
91 	function confirmOwnership() public onlyPotentialOwner {
92 		emit OwnershipTransferred(owner, potentialOwner);
93 		owner = potentialOwner;
94 		potentialOwner = address(0);
95 	}
96 	
97 	
98 	/**
99 	 * @dev Remove the contract owner permanently
100 	 */
101 	function removeOwnership() public onlyOwner {
102 		emit OwnershipRemoved(owner);
103 		owner = address(0);
104 	}
105 	
106 }
107 
108 /**
109  * @title SafeMath
110  * @dev Math operations with safety checks that throw on error
111  */
112 library SafeMath {
113 	
114 	/**
115 	* @dev Multiplies two numbers, throws on overflow.
116 	*/
117 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118 		if (a == 0) {
119 			return 0;
120 		}
121 		uint256 c = a * b;
122 		assert(c / a == b);
123 		return c;
124 	}
125 	
126 	
127 	/**
128 	* @dev Integer division of two numbers, truncating the quotient.
129 	*/
130 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
131 		uint256 c = a / b;
132 		return c;
133 	}
134 	
135 	
136 	/**
137 	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
138 	*/
139 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140 		assert(b <= a);
141 		return a - b;
142 	}
143 	
144 	
145 	/**
146 	* @dev Adds two numbers, throws on overflow.
147 	*/
148 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
149 		uint256 c = a + b;
150 		assert(c >= a);
151 		return c;
152 	}
153 	
154 	
155 	/**
156 	* @dev Powers the first number to the second, throws on overflow.
157 	*/
158 	function pow(uint a, uint b) internal pure returns (uint) {
159 		if (b == 0) {
160 			return 1;
161 		}
162 		uint c = a ** b;
163 		assert(c >= a);
164 		return c;
165 	}
166 	
167 	
168 	/**
169 	 * @dev Multiplies the given number by 10**decimals
170 	 */
171 	function withDecimals(uint number, uint decimals) internal pure returns (uint) {
172 		return mul(number, pow(10, decimals));
173 	}
174 	
175 }
176 
177 /**
178  * @title ERC20Basic
179  * @dev Simpler version of ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/179
181  */
182 contract ERC20Basic {
183 	function totalSupply() public view returns (uint256);
184 	function balanceOf(address who) public view returns (uint256);
185 	function transfer(address to, uint256 value) public returns (bool);
186 	event Transfer(address indexed from, address indexed to, uint256 value);
187 }
188 
189 /**
190  * @title Basic token
191  * @dev Basic version of StandardToken, with no allowances.
192  */
193 contract BasicToken is ERC20Basic {
194 	
195 	using SafeMath for uint256;
196 	
197 	mapping(address => uint256) public balances;
198 	
199 	uint256 public totalSupply_;
200 	
201 	
202 	/**
203 	* @dev total number of tokens in existence
204 	*/
205 	function totalSupply() public view returns (uint256) {
206 		return totalSupply_;
207 	}
208 	
209 	
210 	/**
211 	* @dev transfer token for a specified address
212 	* @param _to The address to transfer to.
213 	* @param _value The amount to be transferred.
214 	*/
215 	function transfer(address _to, uint256 _value) public returns (bool) {
216 		require(_to != address(0));
217 		require(_value <= balances[msg.sender]);
218 		
219 		// SafeMath.sub will throw if there is not enough balance.
220 		balances[msg.sender] = balances[msg.sender].sub(_value);
221 		balances[_to] = balances[_to].add(_value);
222 		emit Transfer(msg.sender, _to, _value);
223 		return true;
224 	}
225 	
226 	
227 	/**
228 	* @dev Gets the balance of the specified address.
229 	* @param _owner The address to query the the balance of.
230 	* @return An uint256 representing the amount owned by the passed address.
231 	*/
232 	function balanceOf(address _owner) public view returns (uint256 balance) {
233 		return balances[_owner];
234 	}
235 	
236 }
237 
238 /**
239  * @title Burnable Token
240  * @dev Token that can be irreversibly burned (destroyed).
241  */
242 contract BurnableToken is BasicToken {
243 	
244 	event Burn(address indexed burner, uint256 value);
245 	
246 	/**
247 	 * @dev Burns a specific amount of tokens.
248 	 * @param _value The amount of token to be burned.
249 	 */
250 	function burn(uint256 _value) public {
251 		require(_value <= balances[msg.sender]);
252 		// no need to require value <= totalSupply, since that would imply the
253 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
254 		
255 		address burner = msg.sender;
256 		balances[burner] = balances[burner].sub(_value);
257 		totalSupply_ = totalSupply_.sub(_value);
258 		emit Burn(burner, _value);
259 		emit Transfer(burner, address(0), _value);
260 	}
261 }
262 
263 /**
264  * @title ERC20 interface
265  * @dev see https://github.com/ethereum/EIPs/issues/20
266  */
267 contract ERC20 is ERC20Basic {
268 	function allowance(address owner, address spender) public view returns (uint256);
269 	function transferFrom(address from, address to, uint256 value) public returns (bool);
270 	function approve(address spender, uint256 value) public returns (bool);
271 	event Approval(address indexed owner, address indexed spender, uint256 value);
272 }
273 
274 /**
275  * @title ERC223 interface
276  * @dev see https://github.com/ethereum/EIPs/issues/223
277  */
278 contract ERC223 is ERC20 {
279 	function transfer(address to, uint256 value, bytes data) public returns (bool);
280 	event ERC223Transfer(address indexed from, address indexed to, uint256 value, bytes data);
281 }
282 
283 /**
284  * @title UKTTokenBasic
285  * @dev UKTTokenBasic interface
286  */
287 contract UKTTokenBasic is ERC223, BurnableToken {
288 	
289 	bool public isControlled = false;
290 	bool public isConfigured = false;
291 	bool public isAllocated = false;
292 	
293 	// mapping of string labels to initial allocated addresses
294 	mapping(bytes32 => address) public allocationAddressesTypes;
295 	// mapping of addresses to time lock period
296 	mapping(address => uint32) public timelockedAddresses;
297 	// mapping of addresses to lock flag
298 	mapping(address => bool) public lockedAddresses;
299 	
300 	
301 	function setConfiguration(string _name, string _symbol, uint _totalSupply) external returns (bool);
302 	function setInitialAllocation(address[] addresses, bytes32[] addressesTypes, uint[] amounts) external returns (bool);
303 	function setInitialAllocationLock(address allocationAddress ) external returns (bool);
304 	function setInitialAllocationUnlock(address allocationAddress ) external returns (bool);
305 	function setInitialAllocationTimelock(address allocationAddress, uint32 timelockTillDate ) external returns (bool);
306 	
307 	// fires when the token contract becomes controlled
308 	event Controlled(address indexed tokenController);
309 	// fires when the token contract becomes configured
310 	event Configured(string tokenName, string tokenSymbol, uint totalSupply);
311 	event InitiallyAllocated(address indexed owner, bytes32 addressType, uint balance);
312 	event InitiallAllocationLocked(address indexed owner);
313 	event InitiallAllocationUnlocked(address indexed owner);
314 	event InitiallAllocationTimelocked(address indexed owner, uint32 timestamp);
315 	
316 }
317 
318 /**
319  * @title  Basic controller contract for basic UKT token
320  * @author  Oleg Levshin <levshin@ucoz-team.net>
321  */
322 contract UKTTokenController is Ownable {
323 	
324 	using SafeMath for uint256;
325 	using AddressTools for address;
326 	
327 	bool public isFinalized = false;
328 	
329 	// address of the controlled token
330 	UKTTokenBasic public token;
331 	// finalize function type. One of two values is possible: "transfer" or "burn"
332 	bytes32 public finalizeType = "transfer";
333 	// address type where finalize function will transfer undistributed tokens
334 	bytes32 public finalizeTransferAddressType = "";
335 	// maximum quantity of addresses to distribute
336 	uint8 internal MAX_ADDRESSES_FOR_DISTRIBUTE = 100;
337 	// list of locked initial allocation addresses
338 	address[] internal lockedAddressesList;
339 	
340 	
341 	// fires when tokens distributed to holder
342 	event Distributed(address indexed holder, bytes32 indexed trackingId, uint256 amount);
343 	// fires when tokens distribution is finalized
344 	event Finalized();
345 	
346 	/**
347 	 * @dev The UKTTokenController constructor
348 	 */
349 	function UKTTokenController(
350 		bytes32 _finalizeType,
351 		bytes32 _finalizeTransferAddressType
352 	) public {
353 		require(_finalizeType == "transfer" || _finalizeType == "burn");
354 		
355 		if (_finalizeType == "transfer") {
356 			require(_finalizeTransferAddressType != "");
357 		} else if (_finalizeType == "burn") {
358 			require(_finalizeTransferAddressType == "");
359 		}
360 		
361 		finalizeType = _finalizeType;
362 		finalizeTransferAddressType = _finalizeTransferAddressType;
363 	}
364 	
365 	
366 	/**
367 	 * @dev Sets controlled token
368 	 */
369 	function setToken (
370 		address _token
371 	) public onlyOwner returns (bool) {
372 		require(token == address(0));
373 		require(_token.isContract());
374 		
375 		token = UKTTokenBasic(_token);
376 		
377 		return true;
378 	}
379 	
380 	
381 	/**
382 	 * @dev Configures controlled token params
383 	 */
384 	function configureTokenParams(
385 		string _name,
386 		string _symbol,
387 		uint _totalSupply
388 	) public onlyOwner returns (bool) {
389 		require(token != address(0));
390 		return token.setConfiguration(_name, _symbol, _totalSupply);
391 	}
392 	
393 	
394 	/**
395 	 * @dev Allocates initial ICO balances (like team, advisory tokens and others)
396 	 */
397 	function allocateInitialBalances(
398 		address[] addresses,
399 		bytes32[] addressesTypes,
400 		uint[] amounts
401 	) public onlyOwner returns (bool) {
402 		require(token != address(0));
403 		return token.setInitialAllocation(addresses, addressesTypes, amounts);
404 	}
405 	
406 	
407 	/**
408 	 * @dev Locks given allocation address
409 	 */
410 	function lockAllocationAddress(
411 		address allocationAddress
412 	) public onlyOwner returns (bool) {
413 		require(token != address(0));
414 		token.setInitialAllocationLock(allocationAddress);
415 		lockedAddressesList.push(allocationAddress);
416 		return true;
417 	}
418 	
419 	
420 	/**
421 	 * @dev Unlocks given allocation address
422 	 */
423 	function unlockAllocationAddress(
424 		address allocationAddress
425 	) public onlyOwner returns (bool) {
426 		require(token != address(0));
427 		
428 		token.setInitialAllocationUnlock(allocationAddress);
429 		
430 		for (uint idx = 0; idx < lockedAddressesList.length; idx++) {
431 			if (lockedAddressesList[idx] == allocationAddress) {
432 				lockedAddressesList[idx] = address(0);
433 				break;
434 			}
435 		}
436 		
437 		return true;
438 	}
439 	
440 	
441 	/**
442 	 * @dev Unlocks all allocation addresses
443 	 */
444 	function unlockAllAllocationAddresses() public onlyOwner returns (bool) {
445 		for(uint a = 0; a < lockedAddressesList.length; a++) {
446 			if (lockedAddressesList[a] == address(0)) {
447 				continue;
448 			}
449 			unlockAllocationAddress(lockedAddressesList[a]);
450 		}
451 		
452 		return true;
453 	}
454 	
455 	
456 	/**
457 	 * @dev Locks given allocation address with timestamp
458 	 */
459 	function timelockAllocationAddress(
460 		address allocationAddress,
461 		uint32 timelockTillDate
462 	) public onlyOwner returns (bool) {
463 		require(token != address(0));
464 		return token.setInitialAllocationTimelock(allocationAddress, timelockTillDate);
465 	}
466 	
467 	
468 	
469 	/**
470 	 * @dev Distributes tokens to holders (investors)
471 	 */
472 	function distribute(
473 		address[] addresses,
474 		uint[] amounts,
475 		bytes32[] trackingIds
476 	) public onlyOwner returns (bool) {
477 		require(token != address(0));
478 		// quantity of addresses should be less than MAX_ADDRESSES_FOR_DISTRIBUTE
479 		require(addresses.length < MAX_ADDRESSES_FOR_DISTRIBUTE);
480 		// the array of addresses should be the same length as the array of amounts
481 		require(addresses.length == amounts.length && addresses.length == trackingIds.length);
482 		
483 		for(uint a = 0; a < addresses.length; a++) {
484 			token.transfer(addresses[a], amounts[a]);
485 			emit Distributed(addresses[a], trackingIds[a], amounts[a]);
486 		}
487 		
488 		return true;
489 	}
490 	
491 	
492 	/**
493 	 * @dev Finalizes the ability to use the controller and destructs it
494 	 */
495 	function finalize() public onlyOwner {
496 		
497 		if (finalizeType == "transfer") {
498 			// transfer all undistributed tokens to particular address
499 			token.transfer(
500 				token.allocationAddressesTypes(finalizeTransferAddressType),
501 				token.balanceOf(this)
502 			);
503 		} else if (finalizeType == "burn") {
504 			// burn all undistributed tokens
505 			token.burn(token.balanceOf(this));
506 		}
507 		
508 		require(unlockAllAllocationAddresses());
509 		
510 		removeOwnership();
511 		
512 		isFinalized = true;
513 		emit Finalized();
514 	}
515 	
516 }