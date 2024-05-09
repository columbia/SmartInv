1 pragma solidity 0.4.24;
2 
3 // File: contracts/RealtyReturnsTokenInterface.sol
4 
5 contract RealtyReturnsTokenInterface {
6     function paused() public;
7     function unpause() public;
8     function finishMinting() public returns (bool);
9 }
10 
11 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
12 
13 /**
14  * @title ERC20Basic
15  * @dev Simpler version of ERC20 interface
16  * See https://github.com/ethereum/EIPs/issues/179
17  */
18 contract ERC20Basic {
19   function totalSupply() public view returns (uint256);
20   function balanceOf(address _who) public view returns (uint256);
21   function transfer(address _to, uint256 _value) public returns (bool);
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 }
24 
25 // File: zeppelin-solidity/contracts/math/SafeMath.sol
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
37     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
38     // benefit is lost if 'b' is also tested.
39     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40     if (_a == 0) {
41       return 0;
42     }
43 
44     c = _a * _b;
45     assert(c / _a == _b);
46     return c;
47   }
48 
49   /**
50   * @dev Integer division of two numbers, truncating the quotient.
51   */
52   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
53     // assert(_b > 0); // Solidity automatically throws when dividing by 0
54     // uint256 c = _a / _b;
55     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
56     return _a / _b;
57   }
58 
59   /**
60   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
63     assert(_b <= _a);
64     return _a - _b;
65   }
66 
67   /**
68   * @dev Adds two numbers, throws on overflow.
69   */
70   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
71     c = _a + _b;
72     assert(c >= _a);
73     return c;
74   }
75 }
76 
77 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) internal balances;
87 
88   uint256 internal totalSupply_;
89 
90   /**
91   * @dev Total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev Transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_value <= balances[msg.sender]);
104     require(_to != address(0));
105 
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     emit Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
124 
125 /**
126  * @title ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/20
128  */
129 contract ERC20 is ERC20Basic {
130   function allowance(address _owner, address _spender)
131     public view returns (uint256);
132 
133   function transferFrom(address _from, address _to, uint256 _value)
134     public returns (bool);
135 
136   function approve(address _spender, uint256 _value) public returns (bool);
137   event Approval(
138     address indexed owner,
139     address indexed spender,
140     uint256 value
141   );
142 }
143 
144 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  * https://github.com/ethereum/EIPs/issues/20
151  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(
165     address _from,
166     address _to,
167     uint256 _value
168   )
169     public
170     returns (bool)
171   {
172     require(_value <= balances[_from]);
173     require(_value <= allowed[_from][msg.sender]);
174     require(_to != address(0));
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     emit Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    * Beware that changing an allowance with this method brings the risk that someone may use both the old
186    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189    * @param _spender The address which will spend the funds.
190    * @param _value The amount of tokens to be spent.
191    */
192   function approve(address _spender, uint256 _value) public returns (bool) {
193     allowed[msg.sender][_spender] = _value;
194     emit Approval(msg.sender, _spender, _value);
195     return true;
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
207    )
208     public
209     view
210     returns (uint256)
211   {
212     return allowed[_owner][_spender];
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(
225     address _spender,
226     uint256 _addedValue
227   )
228     public
229     returns (bool)
230   {
231     allowed[msg.sender][_spender] = (
232       allowed[msg.sender][_spender].add(_addedValue));
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(
247     address _spender,
248     uint256 _subtractedValue
249   )
250     public
251     returns (bool)
252   {
253     uint256 oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue >= oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
266 
267 /**
268  * @title Ownable
269  * @dev The Ownable contract has an owner address, and provides basic authorization control
270  * functions, this simplifies the implementation of "user permissions".
271  */
272 contract Ownable {
273   address public owner;
274 
275 
276   event OwnershipRenounced(address indexed previousOwner);
277   event OwnershipTransferred(
278     address indexed previousOwner,
279     address indexed newOwner
280   );
281 
282 
283   /**
284    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
285    * account.
286    */
287   constructor() public {
288     owner = msg.sender;
289   }
290 
291   /**
292    * @dev Throws if called by any account other than the owner.
293    */
294   modifier onlyOwner() {
295     require(msg.sender == owner);
296     _;
297   }
298 
299   /**
300    * @dev Allows the current owner to relinquish control of the contract.
301    * @notice Renouncing to ownership will leave the contract without an owner.
302    * It will not be possible to call the functions with the `onlyOwner`
303    * modifier anymore.
304    */
305   function renounceOwnership() public onlyOwner {
306     emit OwnershipRenounced(owner);
307     owner = address(0);
308   }
309 
310   /**
311    * @dev Allows the current owner to transfer control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function transferOwnership(address _newOwner) public onlyOwner {
315     _transferOwnership(_newOwner);
316   }
317 
318   /**
319    * @dev Transfers control of the contract to a newOwner.
320    * @param _newOwner The address to transfer ownership to.
321    */
322   function _transferOwnership(address _newOwner) internal {
323     require(_newOwner != address(0));
324     emit OwnershipTransferred(owner, _newOwner);
325     owner = _newOwner;
326   }
327 }
328 
329 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
330 
331 /**
332  * @title Mintable token
333  * @dev Simple ERC20 Token example, with mintable token creation
334  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
335  */
336 contract MintableToken is StandardToken, Ownable {
337   event Mint(address indexed to, uint256 amount);
338   event MintFinished();
339 
340   bool public mintingFinished = false;
341 
342 
343   modifier canMint() {
344     require(!mintingFinished);
345     _;
346   }
347 
348   modifier hasMintPermission() {
349     require(msg.sender == owner);
350     _;
351   }
352 
353   /**
354    * @dev Function to mint tokens
355    * @param _to The address that will receive the minted tokens.
356    * @param _amount The amount of tokens to mint.
357    * @return A boolean that indicates if the operation was successful.
358    */
359   function mint(
360     address _to,
361     uint256 _amount
362   )
363     public
364     hasMintPermission
365     canMint
366     returns (bool)
367   {
368     totalSupply_ = totalSupply_.add(_amount);
369     balances[_to] = balances[_to].add(_amount);
370     emit Mint(_to, _amount);
371     emit Transfer(address(0), _to, _amount);
372     return true;
373   }
374 
375   /**
376    * @dev Function to stop minting new tokens.
377    * @return True if the operation was successful.
378    */
379   function finishMinting() public onlyOwner canMint returns (bool) {
380     mintingFinished = true;
381     emit MintFinished();
382     return true;
383   }
384 }
385 
386 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
387 
388 /**
389  * @title Pausable
390  * @dev Base contract which allows children to implement an emergency stop mechanism.
391  */
392 contract Pausable is Ownable {
393   event Pause();
394   event Unpause();
395 
396   bool public paused = false;
397 
398 
399   /**
400    * @dev Modifier to make a function callable only when the contract is not paused.
401    */
402   modifier whenNotPaused() {
403     require(!paused);
404     _;
405   }
406 
407   /**
408    * @dev Modifier to make a function callable only when the contract is paused.
409    */
410   modifier whenPaused() {
411     require(paused);
412     _;
413   }
414 
415   /**
416    * @dev called by the owner to pause, triggers stopped state
417    */
418   function pause() public onlyOwner whenNotPaused {
419     paused = true;
420     emit Pause();
421   }
422 
423   /**
424    * @dev called by the owner to unpause, returns to normal state
425    */
426   function unpause() public onlyOwner whenPaused {
427     paused = false;
428     emit Unpause();
429   }
430 }
431 
432 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
433 
434 /**
435  * @title Pausable token
436  * @dev StandardToken modified with pausable transfers.
437  **/
438 contract PausableToken is StandardToken, Pausable {
439 
440   function transfer(
441     address _to,
442     uint256 _value
443   )
444     public
445     whenNotPaused
446     returns (bool)
447   {
448     return super.transfer(_to, _value);
449   }
450 
451   function transferFrom(
452     address _from,
453     address _to,
454     uint256 _value
455   )
456     public
457     whenNotPaused
458     returns (bool)
459   {
460     return super.transferFrom(_from, _to, _value);
461   }
462 
463   function approve(
464     address _spender,
465     uint256 _value
466   )
467     public
468     whenNotPaused
469     returns (bool)
470   {
471     return super.approve(_spender, _value);
472   }
473 
474   function increaseApproval(
475     address _spender,
476     uint _addedValue
477   )
478     public
479     whenNotPaused
480     returns (bool success)
481   {
482     return super.increaseApproval(_spender, _addedValue);
483   }
484 
485   function decreaseApproval(
486     address _spender,
487     uint _subtractedValue
488   )
489     public
490     whenNotPaused
491     returns (bool success)
492   {
493     return super.decreaseApproval(_spender, _subtractedValue);
494   }
495 }
496 
497 // File: contracts/RealtyReturnsToken.sol
498 
499 /**
500  * @title Realty Coins contract - ERC20 compatible token contract.
501  * @author Gustavo Guimaraes - <gustavoguimaraes@gmail.com>
502  */
503 contract RealtyReturnsToken is PausableToken, MintableToken {
504     string public constant name = "Realty Returns Token";
505     string public constant symbol = "RRT";
506     uint8 public constant decimals = 18;
507 
508     constructor() public {
509         pause();
510     }
511 }