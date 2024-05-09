1 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.21;
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
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 // File: zeppelin-solidity/contracts/math/SafeMath.sol
47 
48 pragma solidity ^0.4.21;
49 
50 
51 /**
52  * @title SafeMath
53  * @dev Math operations with safety checks that throw on error
54  */
55 library SafeMath {
56 
57   /**
58   * @dev Multiplies two numbers, throws on overflow.
59   */
60   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     if (a == 0) {
62       return 0;
63     }
64     c = a * b;
65     assert(c / a == b);
66     return c;
67   }
68 
69   /**
70   * @dev Integer division of two numbers, truncating the quotient.
71   */
72   function div(uint256 a, uint256 b) internal pure returns (uint256) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     // uint256 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return a / b;
77   }
78 
79   /**
80   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   /**
88   * @dev Adds two numbers, throws on overflow.
89   */
90   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
91     c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 // File: contracts/Lockup.sol
98 
99 pragma solidity ^0.4.18;
100 
101 
102 
103 contract Lockup is Ownable{
104 	using SafeMath for uint256;
105 
106 	uint256 public lockupTime;
107 	mapping(address => bool) public lockup_list;
108 
109 	event UpdateLockup(address indexed owner, uint256 lockup_date);
110 
111 	event UpdateLockupList(address indexed owner, address indexed user_address, bool flag);
112 
113 	constructor(uint256 _lockupTime ) public
114 	{
115 		lockupTime = _lockupTime;
116 
117 		emit UpdateLockup(msg.sender, lockupTime);
118 	}
119 
120 	/**
121 	* @dev Function to get lockup date
122 	* @return A uint256 that indicates if the operation was successful.
123 	*/
124 	function getLockup()public view returns (uint256){
125 		return lockupTime;
126 	}
127 
128 	/**
129 	* @dev Function to check token locked date that is reach or not
130 	* @return A bool that indicates if the operation was successful.
131 	*/
132 	function isLockup() public view returns(bool){
133 		return (now < lockupTime);
134 	}
135 
136 	/**
137 	* @dev Function to update token lockup time
138 	* @param _newLockUpTime uint256 lockup date
139 	* @return A bool that indicates if the operation was successful.
140 	*/
141 	function updateLockup(uint256 _newLockUpTime) onlyOwner public returns(bool){
142 
143 		lockupTime = _newLockUpTime;
144 
145 		emit UpdateLockup(msg.sender, lockupTime);
146 		
147 		return true;
148 	}
149 
150 	/**
151 	* @dev Function get user's lockup status
152 	* @param _add address
153 	* @return A bool that indicates if the operation was successful.
154 	*/
155 	function inLockupList(address _add)public view returns(bool){
156 		return lockup_list[_add];
157 	}
158 
159 	/**
160 	* @dev Function update lockup status for purchaser, if user in the lockup list, they can only transfer token after lockup date
161 	* @param _add address
162 	* @param _flag bool this user's token should be lockup or not
163 	* @return A bool that indicates if the operation was successful.
164 	*/
165 	function updateLockupList(address _add, bool _flag)onlyOwner public returns(bool){
166 		lockup_list[_add] = _flag;
167 
168 		emit UpdateLockupList(msg.sender, _add, _flag);
169 
170 		return true;
171 	}
172 
173 }
174 
175 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
176 
177 pragma solidity ^0.4.21;
178 
179 
180 /**
181  * @title ERC20Basic
182  * @dev Simpler version of ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/179
184  */
185 contract ERC20Basic {
186   function totalSupply() public view returns (uint256);
187   function balanceOf(address who) public view returns (uint256);
188   function transfer(address to, uint256 value) public returns (bool);
189   event Transfer(address indexed from, address indexed to, uint256 value);
190 }
191 
192 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
193 
194 pragma solidity ^0.4.21;
195 
196 
197 
198 
199 /**
200  * @title Basic token
201  * @dev Basic version of StandardToken, with no allowances.
202  */
203 contract BasicToken is ERC20Basic {
204   using SafeMath for uint256;
205 
206   mapping(address => uint256) balances;
207 
208   uint256 totalSupply_;
209 
210   /**
211   * @dev total number of tokens in existence
212   */
213   function totalSupply() public view returns (uint256) {
214     return totalSupply_;
215   }
216 
217   /**
218   * @dev transfer token for a specified address
219   * @param _to The address to transfer to.
220   * @param _value The amount to be transferred.
221   */
222   function transfer(address _to, uint256 _value) public returns (bool) {
223     require(_to != address(0));
224     require(_value <= balances[msg.sender]);
225 
226     balances[msg.sender] = balances[msg.sender].sub(_value);
227     balances[_to] = balances[_to].add(_value);
228     emit Transfer(msg.sender, _to, _value);
229     return true;
230   }
231 
232   /**
233   * @dev Gets the balance of the specified address.
234   * @param _owner The address to query the the balance of.
235   * @return An uint256 representing the amount owned by the passed address.
236   */
237   function balanceOf(address _owner) public view returns (uint256) {
238     return balances[_owner];
239   }
240 
241 }
242 
243 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
244 
245 pragma solidity ^0.4.21;
246 
247 
248 
249 /**
250  * @title ERC20 interface
251  * @dev see https://github.com/ethereum/EIPs/issues/20
252  */
253 contract ERC20 is ERC20Basic {
254   function allowance(address owner, address spender) public view returns (uint256);
255   function transferFrom(address from, address to, uint256 value) public returns (bool);
256   function approve(address spender, uint256 value) public returns (bool);
257   event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
261 
262 pragma solidity ^0.4.21;
263 
264 
265 
266 
267 /**
268  * @title Standard ERC20 token
269  *
270  * @dev Implementation of the basic standard token.
271  * @dev https://github.com/ethereum/EIPs/issues/20
272  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
273  */
274 contract StandardToken is ERC20, BasicToken {
275 
276   mapping (address => mapping (address => uint256)) internal allowed;
277 
278 
279   /**
280    * @dev Transfer tokens from one address to another
281    * @param _from address The address which you want to send tokens from
282    * @param _to address The address which you want to transfer to
283    * @param _value uint256 the amount of tokens to be transferred
284    */
285   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
286     require(_to != address(0));
287     require(_value <= balances[_from]);
288     require(_value <= allowed[_from][msg.sender]);
289 
290     balances[_from] = balances[_from].sub(_value);
291     balances[_to] = balances[_to].add(_value);
292     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
293     emit Transfer(_from, _to, _value);
294     return true;
295   }
296 
297   /**
298    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
299    *
300    * Beware that changing an allowance with this method brings the risk that someone may use both the old
301    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
302    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
303    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
304    * @param _spender The address which will spend the funds.
305    * @param _value The amount of tokens to be spent.
306    */
307   function approve(address _spender, uint256 _value) public returns (bool) {
308     allowed[msg.sender][_spender] = _value;
309     emit Approval(msg.sender, _spender, _value);
310     return true;
311   }
312 
313   /**
314    * @dev Function to check the amount of tokens that an owner allowed to a spender.
315    * @param _owner address The address which owns the funds.
316    * @param _spender address The address which will spend the funds.
317    * @return A uint256 specifying the amount of tokens still available for the spender.
318    */
319   function allowance(address _owner, address _spender) public view returns (uint256) {
320     return allowed[_owner][_spender];
321   }
322 
323   /**
324    * @dev Increase the amount of tokens that an owner allowed to a spender.
325    *
326    * approve should be called when allowed[_spender] == 0. To increment
327    * allowed value is better to use this function to avoid 2 calls (and wait until
328    * the first transaction is mined)
329    * From MonolithDAO Token.sol
330    * @param _spender The address which will spend the funds.
331    * @param _addedValue The amount of tokens to increase the allowance by.
332    */
333   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
334     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
335     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
336     return true;
337   }
338 
339   /**
340    * @dev Decrease the amount of tokens that an owner allowed to a spender.
341    *
342    * approve should be called when allowed[_spender] == 0. To decrement
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO Token.sol
346    * @param _spender The address which will spend the funds.
347    * @param _subtractedValue The amount of tokens to decrease the allowance by.
348    */
349   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
350     uint oldValue = allowed[msg.sender][_spender];
351     if (_subtractedValue > oldValue) {
352       allowed[msg.sender][_spender] = 0;
353     } else {
354       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
355     }
356     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
357     return true;
358   }
359 
360 }
361 
362 // File: contracts/ERC223/ERC223Token.sol
363 
364 pragma solidity ^0.4.18;
365 
366 
367 contract ERC223Token is StandardToken{
368   function transfer(address to, uint256 value, bytes data) public returns (bool);
369   event TransferERC223(address indexed from, address indexed to, uint256 value, bytes data);
370 }
371 
372 // File: contracts/ERC223/ERC223ContractInterface.sol
373 
374 pragma solidity ^0.4.18;
375 
376 contract ERC223ContractInterface{
377   function tokenFallback(address from_, uint256 value_, bytes data_) external;
378 }
379 
380 // File: contracts/CIMCoin.sol
381 
382 pragma solidity ^0.4.18;
383 
384 
385 
386 
387 
388 
389 contract CIMCoin is ERC223Token, Ownable{
390 	using SafeMath for uint256;
391 
392 	string public constant name = 'CIMTOKEN';
393 	string public constant symbol = 'CIM';
394 	uint8 public constant decimals = 18;
395 	uint256 public constant INITIAL_SUPPLY = 25000000000 * (10 ** uint256(decimals));
396 	uint256 public constant INITIAL_SALE_SUPPLY = 11250000000 * (10 ** uint256(decimals));
397 	uint256 public constant INITIAL_UNSALE_SUPPLY = INITIAL_SUPPLY - INITIAL_SALE_SUPPLY;
398 
399 	address public owner_wallet;
400 	address public unsale_owner_wallet;
401 
402 	Lockup public lockup;
403 
404 	/**
405 	* @dev Constructor that gives msg.sender all of existing tokens.
406 	*/
407 	constructor(address _sale_owner_wallet, address _unsale_owner_wallet, Lockup _lockup) public {
408 		lockup = _lockup;
409 		owner_wallet = _sale_owner_wallet;
410 		unsale_owner_wallet = _unsale_owner_wallet;
411 		totalSupply_ = INITIAL_SUPPLY;
412 
413 		balances[owner_wallet] = INITIAL_SALE_SUPPLY;
414 		emit Transfer(0x0, owner_wallet, INITIAL_SALE_SUPPLY);
415 
416 		balances[unsale_owner_wallet] = INITIAL_UNSALE_SUPPLY;
417 		emit Transfer(0x0, unsale_owner_wallet, INITIAL_UNSALE_SUPPLY);
418 	}
419 
420 	/**
421 	* @dev transfer token for a specified address
422 	* @param _to The address to transfer to.
423 	* @param _value The amount to be transferred.
424 	*/
425 	function sendTokens(address _to, uint256 _value) onlyOwner public returns (bool) {
426 		require(_to != address(0));
427 		require(_value <= balances[owner_wallet]);
428 
429 		bytes memory empty;
430 		
431 		// SafeMath.sub will throw if there is not enough balance.
432 		balances[owner_wallet] = balances[owner_wallet].sub(_value);
433 		balances[_to] = balances[_to].add(_value);
434 
435 	    bool isUserAddress = false;
436 	    // solium-disable-next-line security/no-inline-assembly
437 	    assembly {
438 	      isUserAddress := iszero(extcodesize(_to))
439 	    }
440 
441 	    if (isUserAddress == false) {
442 	      ERC223ContractInterface receiver = ERC223ContractInterface(_to);
443 	      receiver.tokenFallback(msg.sender, _value, empty);
444 	    }
445 
446 		emit Transfer(owner_wallet, _to, _value);
447 		return true;
448 	}
449 
450 	/**
451 	* @dev transfer token for a specified address
452 	* @param _to The address to transfer to.
453 	* @param _value The amount to be transferred.
454 	*/
455 	function transfer(address _to, uint256 _value) public returns (bool) {
456 		require(_to != address(0));
457 		require(_value <= balances[msg.sender]);
458 		require(_value > 0);
459 
460 		bytes memory empty;
461 
462 		bool inLockupList = lockup.inLockupList(msg.sender);
463 
464 		//if user in the lockup list, they can only transfer token after lockup date
465 		if(inLockupList){
466 			require( lockup.isLockup() == false );
467 		}
468 
469 		// SafeMath.sub will throw if there is not enough balance.
470 		balances[msg.sender] = balances[msg.sender].sub(_value);
471 		balances[_to] = balances[_to].add(_value);
472 
473 	    bool isUserAddress = false;
474 	    // solium-disable-next-line security/no-inline-assembly
475 	    assembly {
476 	      isUserAddress := iszero(extcodesize(_to))
477 	    }
478 
479 	    if (isUserAddress == false) {
480 	      ERC223ContractInterface receiver = ERC223ContractInterface(_to);
481 	      receiver.tokenFallback(msg.sender, _value, empty);
482 	    }
483 
484 		emit Transfer(msg.sender, _to, _value);
485 		return true;
486 	}
487 
488 	/**
489 	* @dev transfer token for a specified address
490 	* @param _to The address to transfer to.
491 	* @param _value The amount to be transferred.
492 	* @param _data The data info.
493 	*/
494 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
495 		require(_to != address(0));
496 		require(_value <= balances[msg.sender]);
497 		require(_value > 0);
498 
499 		bool inLockupList = lockup.inLockupList(msg.sender);
500 
501 		//if user in the lockup list, they can only transfer token after lockup date
502 		if(inLockupList){
503 			require( lockup.isLockup() == false );
504 		}
505 
506 		// SafeMath.sub will throw if there is not enough balance.
507 		balances[msg.sender] = balances[msg.sender].sub(_value);
508 		balances[_to] = balances[_to].add(_value);
509 
510 	    bool isUserAddress = false;
511 	    // solium-disable-next-line security/no-inline-assembly
512 	    assembly {
513 	      isUserAddress := iszero(extcodesize(_to))
514 	    }
515 
516 	    if (isUserAddress == false) {
517 	      ERC223ContractInterface receiver = ERC223ContractInterface(_to);
518 	      receiver.tokenFallback(msg.sender, _value, _data);
519 	    }
520 
521 	    emit Transfer(msg.sender, _to, _value);
522 		emit TransferERC223(msg.sender, _to, _value, _data);
523 		return true;
524 	}	
525 }