1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
67 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
81 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address _owner, address _spender)
89     public view returns (uint256);
90 
91   function transferFrom(address _from, address _to, uint256 _value)
92     public returns (bool);
93 
94   function approve(address _spender, uint256 _value) public returns (bool);
95   event Approval(
96     address indexed owner,
97     address indexed spender,
98     uint256 value
99   );
100 }
101 
102 // File: contracts/Refundable.sol
103 
104 /**
105  * @title Refundable
106  * @dev Base contract that can refund funds(ETH and tokens) by owner.
107  * @dev Reference TokenDestructible(zeppelinand) TokenDestructible(zeppelin)
108  */
109 contract Refundable is Ownable {
110 	event RefundETH(address indexed owner, address indexed payee, uint256 amount);
111 	event RefundERC20(address indexed owner, address indexed payee, address indexed token, uint256 amount);
112 
113 	constructor() public payable {
114 	}
115 
116 	function refundETH(address payee, uint256 amount) onlyOwner public {
117 		require(payee != address(0));
118 		assert(payee.send(amount));
119 		emit RefundETH(owner, payee, amount);
120 	}
121 
122 	function refundERC20(address tokenContract, address payee, uint256 amount) onlyOwner public {
123 		require(payee != address(0));
124 		bool isContract;
125 		assembly {
126 			isContract := gt(extcodesize(tokenContract), 0)
127 		}
128 		require(isContract);
129 
130 		ERC20 token = ERC20(tokenContract);
131 		assert(token.transfer(payee, amount));
132 		emit RefundERC20(owner, payee, tokenContract, amount);
133 	}
134 }
135 
136 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
137 
138 /**
139  * @title SafeMath
140  * @dev Math operations with safety checks that throw on error
141  */
142 library SafeMath {
143 
144   /**
145   * @dev Multiplies two numbers, throws on overflow.
146   */
147   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
148     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
149     // benefit is lost if 'b' is also tested.
150     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
151     if (_a == 0) {
152       return 0;
153     }
154 
155     c = _a * _b;
156     assert(c / _a == _b);
157     return c;
158   }
159 
160   /**
161   * @dev Integer division of two numbers, truncating the quotient.
162   */
163   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
164     // assert(_b > 0); // Solidity automatically throws when dividing by 0
165     // uint256 c = _a / _b;
166     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
167     return _a / _b;
168   }
169 
170   /**
171   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
172   */
173   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
174     assert(_b <= _a);
175     return _a - _b;
176   }
177 
178   /**
179   * @dev Adds two numbers, throws on overflow.
180   */
181   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
182     c = _a + _b;
183     assert(c >= _a);
184     return c;
185   }
186 }
187 
188 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
189 
190 /**
191  * @title Basic token
192  * @dev Basic version of StandardToken, with no allowances.
193  */
194 contract BasicToken is ERC20Basic {
195   using SafeMath for uint256;
196 
197   mapping(address => uint256) internal balances;
198 
199   uint256 internal totalSupply_;
200 
201   /**
202   * @dev Total number of tokens in existence
203   */
204   function totalSupply() public view returns (uint256) {
205     return totalSupply_;
206   }
207 
208   /**
209   * @dev Transfer token for a specified address
210   * @param _to The address to transfer to.
211   * @param _value The amount to be transferred.
212   */
213   function transfer(address _to, uint256 _value) public returns (bool) {
214     require(_value <= balances[msg.sender]);
215     require(_to != address(0));
216 
217     balances[msg.sender] = balances[msg.sender].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     emit Transfer(msg.sender, _to, _value);
220     return true;
221   }
222 
223   /**
224   * @dev Gets the balance of the specified address.
225   * @param _owner The address to query the the balance of.
226   * @return An uint256 representing the amount owned by the passed address.
227   */
228   function balanceOf(address _owner) public view returns (uint256) {
229     return balances[_owner];
230   }
231 
232 }
233 
234 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
235 
236 /**
237  * @title Standard ERC20 token
238  *
239  * @dev Implementation of the basic standard token.
240  * https://github.com/ethereum/EIPs/issues/20
241  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
242  */
243 contract StandardToken is ERC20, BasicToken {
244 
245   mapping (address => mapping (address => uint256)) internal allowed;
246 
247 
248   /**
249    * @dev Transfer tokens from one address to another
250    * @param _from address The address which you want to send tokens from
251    * @param _to address The address which you want to transfer to
252    * @param _value uint256 the amount of tokens to be transferred
253    */
254   function transferFrom(
255     address _from,
256     address _to,
257     uint256 _value
258   )
259     public
260     returns (bool)
261   {
262     require(_value <= balances[_from]);
263     require(_value <= allowed[_from][msg.sender]);
264     require(_to != address(0));
265 
266     balances[_from] = balances[_from].sub(_value);
267     balances[_to] = balances[_to].add(_value);
268     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
269     emit Transfer(_from, _to, _value);
270     return true;
271   }
272 
273   /**
274    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
275    * Beware that changing an allowance with this method brings the risk that someone may use both the old
276    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
277    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
278    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279    * @param _spender The address which will spend the funds.
280    * @param _value The amount of tokens to be spent.
281    */
282   function approve(address _spender, uint256 _value) public returns (bool) {
283     allowed[msg.sender][_spender] = _value;
284     emit Approval(msg.sender, _spender, _value);
285     return true;
286   }
287 
288   /**
289    * @dev Function to check the amount of tokens that an owner allowed to a spender.
290    * @param _owner address The address which owns the funds.
291    * @param _spender address The address which will spend the funds.
292    * @return A uint256 specifying the amount of tokens still available for the spender.
293    */
294   function allowance(
295     address _owner,
296     address _spender
297    )
298     public
299     view
300     returns (uint256)
301   {
302     return allowed[_owner][_spender];
303   }
304 
305   /**
306    * @dev Increase the amount of tokens that an owner allowed to a spender.
307    * approve should be called when allowed[_spender] == 0. To increment
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _addedValue The amount of tokens to increase the allowance by.
313    */
314   function increaseApproval(
315     address _spender,
316     uint256 _addedValue
317   )
318     public
319     returns (bool)
320   {
321     allowed[msg.sender][_spender] = (
322       allowed[msg.sender][_spender].add(_addedValue));
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327   /**
328    * @dev Decrease the amount of tokens that an owner allowed to a spender.
329    * approve should be called when allowed[_spender] == 0. To decrement
330    * allowed value is better to use this function to avoid 2 calls (and wait until
331    * the first transaction is mined)
332    * From MonolithDAO Token.sol
333    * @param _spender The address which will spend the funds.
334    * @param _subtractedValue The amount of tokens to decrease the allowance by.
335    */
336   function decreaseApproval(
337     address _spender,
338     uint256 _subtractedValue
339   )
340     public
341     returns (bool)
342   {
343     uint256 oldValue = allowed[msg.sender][_spender];
344     if (_subtractedValue >= oldValue) {
345       allowed[msg.sender][_spender] = 0;
346     } else {
347       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
348     }
349     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353 }
354 
355 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
356 
357 /**
358  * @title Mintable token
359  * @dev Simple ERC20 Token example, with mintable token creation
360  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
361  */
362 contract MintableToken is StandardToken, Ownable {
363   event Mint(address indexed to, uint256 amount);
364   event MintFinished();
365 
366   bool public mintingFinished = false;
367 
368 
369   modifier canMint() {
370     require(!mintingFinished);
371     _;
372   }
373 
374   modifier hasMintPermission() {
375     require(msg.sender == owner);
376     _;
377   }
378 
379   /**
380    * @dev Function to mint tokens
381    * @param _to The address that will receive the minted tokens.
382    * @param _amount The amount of tokens to mint.
383    * @return A boolean that indicates if the operation was successful.
384    */
385   function mint(
386     address _to,
387     uint256 _amount
388   )
389     public
390     hasMintPermission
391     canMint
392     returns (bool)
393   {
394     totalSupply_ = totalSupply_.add(_amount);
395     balances[_to] = balances[_to].add(_amount);
396     emit Mint(_to, _amount);
397     emit Transfer(address(0), _to, _amount);
398     return true;
399   }
400 
401   /**
402    * @dev Function to stop minting new tokens.
403    * @return True if the operation was successful.
404    */
405   function finishMinting() public onlyOwner canMint returns (bool) {
406     mintingFinished = true;
407     emit MintFinished();
408     return true;
409   }
410 }
411 
412 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
413 
414 /**
415  * @title Burnable Token
416  * @dev Token that can be irreversibly burned (destroyed).
417  */
418 contract BurnableToken is BasicToken {
419 
420   event Burn(address indexed burner, uint256 value);
421 
422   /**
423    * @dev Burns a specific amount of tokens.
424    * @param _value The amount of token to be burned.
425    */
426   function burn(uint256 _value) public {
427     _burn(msg.sender, _value);
428   }
429 
430   function _burn(address _who, uint256 _value) internal {
431     require(_value <= balances[_who]);
432     // no need to require value <= totalSupply, since that would imply the
433     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
434 
435     balances[_who] = balances[_who].sub(_value);
436     totalSupply_ = totalSupply_.sub(_value);
437     emit Burn(_who, _value);
438     emit Transfer(_who, address(0), _value);
439   }
440 }
441 
442 contract TokenTemplate is MintableToken, BurnableToken, Refundable {
443     string public version = "1.1";
444 
445 	string public name;
446 	string public symbol;
447 	uint8 public decimals;
448         bool public mintable;
449 	bool public burnable;
450 	string public memo;
451 	uint256 public initSupply;
452 
453 	bool public canBurn;
454 
455 	constructor(
456 		address _owner, string _name, string _symbol, uint256 _initSupply, uint8 _decimals,
457 		bool _mintable, bool _burnable, string _memo
458 	) public {
459 		require(_owner != address(0));
460 		owner = _owner;
461 		name = _name;
462 		symbol = _symbol;
463         initSupply = _initSupply;
464 		decimals = _decimals;
465 		mintable = _mintable;
466 		burnable = _burnable;
467 		memo = _memo;
468 
469 		canBurn = burnable;
470 
471 		uint256 amount = _initSupply;
472 		totalSupply_ = totalSupply_.add(amount);
473 		balances[owner] = balances[owner].add(amount);
474 		emit Transfer(address(0), owner, amount);
475 
476 		if (!_mintable) {
477 			mintingFinished = true;
478 		}
479 	}
480 
481 	/**
482 	* @dev Burns a specific amount of tokens.
483 	* @param _value The amount of token to be burned.
484 	*/
485 	function burn(uint256 _value) public {
486 		require(canBurn);
487 		BurnableToken.burn(_value);
488 	}
489 
490 	function ownerSetCanBurn(bool _canBurn) onlyOwner public {
491 		canBurn = _canBurn;
492 	}
493 }