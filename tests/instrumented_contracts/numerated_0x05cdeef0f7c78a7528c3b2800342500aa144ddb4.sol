1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 {
72   function totalSupply() public view returns (uint256);
73 
74   function balanceOf(address _who) public view returns (uint256);
75 
76   function allowance(address _owner, address _spender)
77     public view returns (uint256);
78 
79   function transfer(address _to, uint256 _value) public returns (bool);
80 
81   function approve(address _spender, uint256 _value)
82     public returns (bool);
83 
84   function transferFrom(address _from, address _to, uint256 _value)
85     public returns (bool);
86 
87   event Transfer(
88     address indexed from,
89     address indexed to,
90     uint256 value
91   );
92 
93   event Approval(
94     address indexed owner,
95     address indexed spender,
96     uint256 value
97   );
98 }
99 
100 
101 /**
102  * @title SafeMath
103  * @dev Math operations with safety checks that revert on error
104  */
105 library SafeMath {
106 
107   /**
108   * @dev Multiplies two numbers, reverts on overflow.
109   */
110   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
111     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
112     // benefit is lost if 'b' is also tested.
113     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
114     if (_a == 0) {
115       return 0;
116     }
117 
118     uint256 c = _a * _b;
119     require(c / _a == _b);
120 
121     return c;
122   }
123 
124   /**
125   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
126   */
127   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
128     require(_b > 0); // Solidity only automatically asserts when dividing by 0
129     uint256 c = _a / _b;
130     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
131 
132     return c;
133   }
134 
135   /**
136   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
137   */
138   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
139     require(_b <= _a);
140     uint256 c = _a - _b;
141 
142     return c;
143   }
144 
145   /**
146   * @dev Adds two numbers, reverts on overflow.
147   */
148   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
149     uint256 c = _a + _b;
150     require(c >= _a);
151 
152     return c;
153   }
154 
155   /**
156   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
157   * reverts when dividing by zero.
158   */
159   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160     require(b != 0);
161     return a % b;
162   }
163 }
164 
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
171  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20 {
174   using SafeMath for uint256;
175 
176   mapping (address => uint256) public balances;
177 
178   mapping (address => mapping (address => uint256)) public allowed;
179 
180   uint256 public totalSupply_;
181 
182   /**
183   * @dev Total number of tokens in existence
184   */
185   function totalSupply() public view returns (uint256) {
186     return totalSupply_;
187   }
188 
189   /**
190   * @dev Gets the balance of the specified address.
191   * @param _owner The address to query the the balance of.
192   * @return An uint256 representing the amount owned by the passed address.
193   */
194   function balanceOf(address _owner) public view returns (uint256) {
195     return balances[_owner];
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens that an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint256 specifying the amount of tokens still available for the spender.
203    */
204   function allowance(
205     address _owner,
206     address _spender
207   )
208   public
209   view
210   returns (uint256)
211   {
212     return allowed[_owner][_spender];
213   }
214 
215   /**
216   * @dev Transfer token for a specified address
217   * @param _to The address to transfer to.
218   * @param _value The amount to be transferred.
219   */
220   function transfer(address _to, uint256 _value) public returns (bool) {
221     require(_value <= balances[msg.sender]);
222     require(_to != address(0));
223 
224     balances[msg.sender] = balances[msg.sender].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     emit Transfer(msg.sender, _to, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    * Beware that changing an allowance with this method brings the risk that someone may use both the old
233    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    * @param _spender The address which will spend the funds.
237    * @param _value The amount of tokens to be spent.
238    */
239   function approve(address _spender, uint256 _value) public returns (bool) {
240     allowed[msg.sender][_spender] = _value;
241     emit Approval(msg.sender, _spender, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Transfer tokens from one address to another
247    * @param _from address The address which you want to send tokens from
248    * @param _to address The address which you want to transfer to
249    * @param _value uint256 the amount of tokens to be transferred
250    */
251   function transferFrom(
252     address _from,
253     address _to,
254     uint256 _value
255   )
256   public
257   returns (bool)
258   {
259     require(_value <= balances[_from]);
260     require(_value <= allowed[_from][msg.sender]);
261     require(_to != address(0));
262 
263     balances[_from] = balances[_from].sub(_value);
264     balances[_to] = balances[_to].add(_value);
265     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
266     emit Transfer(_from, _to, _value);
267     return true;
268   }
269 
270   /**
271    * @dev Increase the amount of tokens that an owner allowed to a spender.
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _addedValue The amount of tokens to increase the allowance by.
278    */
279   function increaseApproval(
280     address _spender,
281     uint256 _addedValue
282   )
283   public
284   returns (bool)
285   {
286     allowed[msg.sender][_spender] = (
287     allowed[msg.sender][_spender].add(_addedValue));
288     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Decrease the amount of tokens that an owner allowed to a spender.
294    * approve should be called when allowed[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseApproval(
302     address _spender,
303     uint256 _subtractedValue
304   )
305   public
306   returns (bool)
307   {
308     uint256 oldValue = allowed[msg.sender][_spender];
309     if (_subtractedValue >= oldValue) {
310       allowed[msg.sender][_spender] = 0;
311     } else {
312       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
313     }
314     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318   /**
319    * @dev Internal function that mints an amount of the token and assigns it to
320    * an account. This encapsulates the modification of balances such that the
321    * proper events are emitted.
322    * @param _account The account that will receive the created tokens.
323    * @param _amount The amount that will be created.
324    */
325   function _mint(address _account, uint256 _amount) internal {
326     require(_account != 0);
327     totalSupply_ = totalSupply_.add(_amount);
328     balances[_account] = balances[_account].add(_amount);
329     emit Transfer(address(0), _account, _amount);
330   }
331 
332   /**
333    * @dev Internal function that burns an amount of the token of a given
334    * account.
335    * @param _account The account whose tokens will be burnt.
336    * @param _amount The amount that will be burnt.
337    */
338   function _burn(address _account, uint256 _amount) internal {
339     require(_account != 0);
340     require(_amount <= balances[_account]);
341 
342     totalSupply_ = totalSupply_.sub(_amount);
343     balances[_account] = balances[_account].sub(_amount);
344     emit Transfer(_account, address(0), _amount);
345   }
346 
347   /**
348    * @dev Internal function that burns an amount of the token of a given
349    * account, deducting from the sender's allowance for said account. Uses the
350    * internal _burn function.
351    * @param _account The account whose tokens will be burnt.
352    * @param _amount The amount that will be burnt.
353    */
354   function _burnFrom(address _account, uint256 _amount) internal {
355     require(_amount <= allowed[_account][msg.sender]);
356 
357     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
358     // this function needs to emit an event with the updated approval.
359     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
360     _burn(_account, _amount);
361   }
362 }
363 
364 
365 contract AIRToken is StandardToken, Ownable {
366 
367 	event Mint(address indexed to, uint256 amount);
368 
369 	string public constant name = "AIR";
370 	string public constant symbol = "AIR";
371 	uint8 public constant decimals = 18;
372 	uint256 public constant INITIAL_SUPPLY = 1000 * 1000000 * (10 ** uint256(decimals));
373 	bool public mintingFinished = false;
374 	bool public lock = true;
375 
376 	modifier canMint() {
377 		require(!mintingFinished);
378 		_;
379 	}
380 
381 	modifier cantMint() {
382 		require(mintingFinished);
383 		_;
384 	}
385 
386 	modifier canTransfer() {
387 		require(!lock);
388 		_;
389 	}
390 
391 	modifier cantTransfer() {
392 		require(lock);
393 		_;
394 	}
395 
396 	constructor() public {
397 		totalSupply_ = INITIAL_SUPPLY;
398 		balances[msg.sender] = INITIAL_SUPPLY;
399 		emit Transfer(0x00, msg.sender, INITIAL_SUPPLY);
400 	}
401 
402 	function transfer(address _to, uint _value) public canTransfer returns(bool) {
403 		balances[msg.sender] = balances[msg.sender].sub(_value);
404 		balances[_to] = balances[_to].add(_value);
405 		emit Transfer(msg.sender, _to, _value);
406 		return true;
407 	}
408 
409 	/* A contract attempts to get the coins */
410 	function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns(bool success) {
411 		if (balances[_from] < _value)
412 			revert(); // Check if the sender has enough
413 		if (_value > allowed[_from][msg.sender])
414 			revert(); // Check allowance
415 		balances[_from] = balances[_from].sub(_value); // Subtract from the sender
416 		balances[_to] = balances[_to].add(_value); // Add the same to the recipient
417 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
418 		emit Transfer(_from, _to, _value);
419 		return true;
420 	}
421 
422 	function balanceOf(address _owner) public constant returns(uint balance) {
423 		return balances[_owner];
424 	}
425 
426 	function approve(address _spender, uint _value) public returns(bool) {
427 		allowed[msg.sender][_spender] = _value;
428 		emit Approval(msg.sender, _spender, _value);
429 		return true;
430 	}
431 
432 	function allowance(address _owner, address _spender) public constant returns(uint remaining) {
433 		return allowed[_owner][_spender];
434 	}
435 
436 	/**
437    * @dev Function to mint tokens
438    * @param _to The address that will receive the minted tokens.
439    * @param _amount The amount of tokens to mint.
440    * @return A boolean that indicates if the operation was successful.
441    */
442 	function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
443 		balances[msg.sender] = balances[msg.sender].sub(_amount);
444 		balances[_to] = balances[_to].add(_amount);
445 		emit Transfer(msg.sender, _to, _amount);
446 		emit Mint(_to, _amount);
447 		return true;
448 	}
449 
450 	/**
451      * @dev Function to stop minting new tokens.
452      * @return True if the operation was successful.
453      */
454 	function finishMinting() public onlyOwner canMint returns (bool) {
455 		mintingFinished = true;
456 		return true;
457 	}
458 
459 	/**
460      * @dev Function to resume minting new tokens.
461      * @return True if the operation was successful.
462      */
463 	function resumeMinting() public onlyOwner cantMint returns (bool) {
464 		mintingFinished = false;
465 		return true;
466 	}
467 
468 	/**
469      * @dev Function to unlock token transfer.
470      * @return True if the operation was successful.
471      */
472 	function unlockTokenTransfer() public onlyOwner cantTransfer returns (bool) {
473 		lock = false;
474 		return true;
475 	}
476 
477 	/**
478      * @dev Function to unlock token transfer.
479      * @return True if the operation was successful.
480      */
481 	function lockTokenTransfer() public onlyOwner canTransfer returns (bool) {
482 		lock = true;
483 		return true;
484 	}
485 }