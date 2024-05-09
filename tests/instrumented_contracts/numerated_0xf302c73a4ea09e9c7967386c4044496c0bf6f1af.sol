1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address _who) public view returns (uint256);
65   function transfer(address _to, uint256 _value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
116 
117 /**
118  * @title Burnable Token
119  * @dev Token that can be irreversibly burned (destroyed).
120  */
121 contract BurnableToken is BasicToken {
122 
123   event Burn(address indexed burner, uint256 value);
124 
125   /**
126    * @dev Burns a specific amount of tokens.
127    * @param _value The amount of token to be burned.
128    */
129   function burn(uint256 _value) public {
130     _burn(msg.sender, _value);
131   }
132 
133   function _burn(address _who, uint256 _value) internal {
134     require(_value <= balances[_who]);
135     // no need to require value <= totalSupply, since that would imply the
136     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
137 
138     balances[_who] = balances[_who].sub(_value);
139     totalSupply_ = totalSupply_.sub(_value);
140     emit Burn(_who, _value);
141     emit Transfer(_who, address(0), _value);
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152   function allowance(address _owner, address _spender)
153     public view returns (uint256);
154 
155   function transferFrom(address _from, address _to, uint256 _value)
156     public returns (bool);
157 
158   function approve(address _spender, uint256 _value) public returns (bool);
159   event Approval(
160     address indexed owner,
161     address indexed spender,
162     uint256 value
163   );
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
167 
168 /**
169  * @title DetailedERC20 token
170  * @dev The decimals are only for visualization purposes.
171  * All the operations are done using the smallest and indivisible token unit,
172  * just as on Ethereum all the operations are done in wei.
173  */
174 contract DetailedERC20 is ERC20 {
175   string public name;
176   string public symbol;
177   uint8 public decimals;
178 
179   constructor(string _name, string _symbol, uint8 _decimals) public {
180     name = _name;
181     symbol = _symbol;
182     decimals = _decimals;
183   }
184 }
185 
186 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
187 
188 /**
189  * @title Ownable
190  * @dev The Ownable contract has an owner address, and provides basic authorization control
191  * functions, this simplifies the implementation of "user permissions".
192  */
193 contract Ownable {
194   address public owner;
195 
196 
197   event OwnershipRenounced(address indexed previousOwner);
198   event OwnershipTransferred(
199     address indexed previousOwner,
200     address indexed newOwner
201   );
202 
203 
204   /**
205    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206    * account.
207    */
208   constructor() public {
209     owner = msg.sender;
210   }
211 
212   /**
213    * @dev Throws if called by any account other than the owner.
214    */
215   modifier onlyOwner() {
216     require(msg.sender == owner);
217     _;
218   }
219 
220   /**
221    * @dev Allows the current owner to relinquish control of the contract.
222    * @notice Renouncing to ownership will leave the contract without an owner.
223    * It will not be possible to call the functions with the `onlyOwner`
224    * modifier anymore.
225    */
226   function renounceOwnership() public onlyOwner {
227     emit OwnershipRenounced(owner);
228     owner = address(0);
229   }
230 
231   /**
232    * @dev Allows the current owner to transfer control of the contract to a newOwner.
233    * @param _newOwner The address to transfer ownership to.
234    */
235   function transferOwnership(address _newOwner) public onlyOwner {
236     _transferOwnership(_newOwner);
237   }
238 
239   /**
240    * @dev Transfers control of the contract to a newOwner.
241    * @param _newOwner The address to transfer ownership to.
242    */
243   function _transferOwnership(address _newOwner) internal {
244     require(_newOwner != address(0));
245     emit OwnershipTransferred(owner, _newOwner);
246     owner = _newOwner;
247   }
248 }
249 
250 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
251 
252 /**
253  * @title Standard ERC20 token
254  *
255  * @dev Implementation of the basic standard token.
256  * https://github.com/ethereum/EIPs/issues/20
257  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
258  */
259 contract StandardToken is ERC20, BasicToken {
260 
261   mapping (address => mapping (address => uint256)) internal allowed;
262 
263 
264   /**
265    * @dev Transfer tokens from one address to another
266    * @param _from address The address which you want to send tokens from
267    * @param _to address The address which you want to transfer to
268    * @param _value uint256 the amount of tokens to be transferred
269    */
270   function transferFrom(
271     address _from,
272     address _to,
273     uint256 _value
274   )
275     public
276     returns (bool)
277   {
278     require(_value <= balances[_from]);
279     require(_value <= allowed[_from][msg.sender]);
280     require(_to != address(0));
281 
282     balances[_from] = balances[_from].sub(_value);
283     balances[_to] = balances[_to].add(_value);
284     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
285     emit Transfer(_from, _to, _value);
286     return true;
287   }
288 
289   /**
290    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
291    * Beware that changing an allowance with this method brings the risk that someone may use both the old
292    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
293    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
294    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
295    * @param _spender The address which will spend the funds.
296    * @param _value The amount of tokens to be spent.
297    */
298   function approve(address _spender, uint256 _value) public returns (bool) {
299     allowed[msg.sender][_spender] = _value;
300     emit Approval(msg.sender, _spender, _value);
301     return true;
302   }
303 
304   /**
305    * @dev Function to check the amount of tokens that an owner allowed to a spender.
306    * @param _owner address The address which owns the funds.
307    * @param _spender address The address which will spend the funds.
308    * @return A uint256 specifying the amount of tokens still available for the spender.
309    */
310   function allowance(
311     address _owner,
312     address _spender
313    )
314     public
315     view
316     returns (uint256)
317   {
318     return allowed[_owner][_spender];
319   }
320 
321   /**
322    * @dev Increase the amount of tokens that an owner allowed to a spender.
323    * approve should be called when allowed[_spender] == 0. To increment
324    * allowed value is better to use this function to avoid 2 calls (and wait until
325    * the first transaction is mined)
326    * From MonolithDAO Token.sol
327    * @param _spender The address which will spend the funds.
328    * @param _addedValue The amount of tokens to increase the allowance by.
329    */
330   function increaseApproval(
331     address _spender,
332     uint256 _addedValue
333   )
334     public
335     returns (bool)
336   {
337     allowed[msg.sender][_spender] = (
338       allowed[msg.sender][_spender].add(_addedValue));
339     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
340     return true;
341   }
342 
343   /**
344    * @dev Decrease the amount of tokens that an owner allowed to a spender.
345    * approve should be called when allowed[_spender] == 0. To decrement
346    * allowed value is better to use this function to avoid 2 calls (and wait until
347    * the first transaction is mined)
348    * From MonolithDAO Token.sol
349    * @param _spender The address which will spend the funds.
350    * @param _subtractedValue The amount of tokens to decrease the allowance by.
351    */
352   function decreaseApproval(
353     address _spender,
354     uint256 _subtractedValue
355   )
356     public
357     returns (bool)
358   {
359     uint256 oldValue = allowed[msg.sender][_spender];
360     if (_subtractedValue >= oldValue) {
361       allowed[msg.sender][_spender] = 0;
362     } else {
363       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
364     }
365     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
366     return true;
367   }
368 
369 }
370 
371 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
372 
373 /**
374  * @title Mintable token
375  * @dev Simple ERC20 Token example, with mintable token creation
376  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
377  */
378 contract MintableToken is StandardToken, Ownable {
379   event Mint(address indexed to, uint256 amount);
380   event MintFinished();
381 
382   bool public mintingFinished = false;
383 
384 
385   modifier canMint() {
386     require(!mintingFinished);
387     _;
388   }
389 
390   modifier hasMintPermission() {
391     require(msg.sender == owner);
392     _;
393   }
394 
395   /**
396    * @dev Function to mint tokens
397    * @param _to The address that will receive the minted tokens.
398    * @param _amount The amount of tokens to mint.
399    * @return A boolean that indicates if the operation was successful.
400    */
401   function mint(
402     address _to,
403     uint256 _amount
404   )
405     public
406     hasMintPermission
407     canMint
408     returns (bool)
409   {
410     totalSupply_ = totalSupply_.add(_amount);
411     balances[_to] = balances[_to].add(_amount);
412     emit Mint(_to, _amount);
413     emit Transfer(address(0), _to, _amount);
414     return true;
415   }
416 
417   /**
418    * @dev Function to stop minting new tokens.
419    * @return True if the operation was successful.
420    */
421   function finishMinting() public onlyOwner canMint returns (bool) {
422     mintingFinished = true;
423     emit MintFinished();
424     return true;
425   }
426 }
427 
428 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
429 
430 /**
431  * @title Pausable
432  * @dev Base contract which allows children to implement an emergency stop mechanism.
433  */
434 contract Pausable is Ownable {
435   event Pause();
436   event Unpause();
437 
438   bool public paused = false;
439 
440 
441   /**
442    * @dev Modifier to make a function callable only when the contract is not paused.
443    */
444   modifier whenNotPaused() {
445     require(!paused);
446     _;
447   }
448 
449   /**
450    * @dev Modifier to make a function callable only when the contract is paused.
451    */
452   modifier whenPaused() {
453     require(paused);
454     _;
455   }
456 
457   /**
458    * @dev called by the owner to pause, triggers stopped state
459    */
460   function pause() public onlyOwner whenNotPaused {
461     paused = true;
462     emit Pause();
463   }
464 
465   /**
466    * @dev called by the owner to unpause, returns to normal state
467    */
468   function unpause() public onlyOwner whenPaused {
469     paused = false;
470     emit Unpause();
471   }
472 }
473 
474 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
475 
476 /**
477  * @title Pausable token
478  * @dev StandardToken modified with pausable transfers.
479  **/
480 contract PausableToken is StandardToken, Pausable {
481 
482   function transfer(
483     address _to,
484     uint256 _value
485   )
486     public
487     whenNotPaused
488     returns (bool)
489   {
490     return super.transfer(_to, _value);
491   }
492 
493   function transferFrom(
494     address _from,
495     address _to,
496     uint256 _value
497   )
498     public
499     whenNotPaused
500     returns (bool)
501   {
502     return super.transferFrom(_from, _to, _value);
503   }
504 
505   function approve(
506     address _spender,
507     uint256 _value
508   )
509     public
510     whenNotPaused
511     returns (bool)
512   {
513     return super.approve(_spender, _value);
514   }
515 
516   function increaseApproval(
517     address _spender,
518     uint _addedValue
519   )
520     public
521     whenNotPaused
522     returns (bool success)
523   {
524     return super.increaseApproval(_spender, _addedValue);
525   }
526 
527   function decreaseApproval(
528     address _spender,
529     uint _subtractedValue
530   )
531     public
532     whenNotPaused
533     returns (bool success)
534   {
535     return super.decreaseApproval(_spender, _subtractedValue);
536   }
537 }
538 
539 // File: contracts/Takion.sol
540 
541 contract Takion is DetailedERC20, PausableToken, MintableToken, BurnableToken {
542 
543     uint256 public constant INITIAL_SUPPLY = 0;
544 
545     constructor() DetailedERC20("Takion", "TAKION", 18) public {
546         totalSupply_ = INITIAL_SUPPLY;
547         balances[msg.sender] = INITIAL_SUPPLY;
548         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
549     }
550 }