1 // Author: Carl Williams - ecoshare network
2 // solium-disable linebreak-style
3 pragma solidity ^0.4.24; 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 /**
19  * @title Basic token
20  * @dev Basic version of StandardToken, with no allowances.
21  */
22 contract BasicToken is ERC20Basic {
23   using SafeMath for uint256;
24 
25   mapping(address => uint256) internal balances;
26 
27   uint256 internal totalSupply_;
28 
29   /**
30   * @dev Total number of tokens in existence
31   */
32   function totalSupply() public view returns (uint256) {
33     return totalSupply_;
34   }
35 
36   /**
37   * @dev Transfer token for a specified address
38   * @param _to The address to transfer to.
39   * @param _value The amount to be transferred.
40   */
41   function transfer(address _to, uint256 _value) public returns (bool) {
42     require(_value <= balances[msg.sender]);
43     require(_to != address(0));
44 
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     emit Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   /**
52   * @dev Gets the balance of the specified address.
53   * @param _owner The address to query the the balance of.
54   * @return An uint256 representing the amount owned by the passed address.
55   */
56   function balanceOf(address _owner) public view returns (uint256) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address _owner, address _spender)
68     public view returns (uint256);
69 
70   function transferFrom(address _from, address _to, uint256 _value)
71     public returns (bool);
72 
73   function approve(address _spender, uint256 _value) public returns (bool);
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 
82 contract StandardToken is ERC20, BasicToken {
83 
84   mapping (address => mapping (address => uint256)) internal allowed;
85 
86 
87   /**
88    * @dev Transfer tokens from one address to another
89    * @param _from address The address which you want to send tokens from
90    * @param _to address The address which you want to transfer to
91    * @param _value uint256 the amount of tokens to be transferred
92    */
93   function transferFrom(
94     address _from,
95     address _to,
96     uint256 _value
97   )
98     public
99     returns (bool)
100   {
101     require(_value <= balances[_from]);
102     require(_value <= allowed[_from][msg.sender]);
103     require(_to != address(0));
104 
105     balances[_from] = balances[_from].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108     emit Transfer(_from, _to, _value);
109     return true;
110   }
111 
112   /**
113    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
114    * Beware that changing an allowance with this method brings the risk that someone may use both the old
115    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
116    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
117    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118    * @param _spender The address which will spend the funds.
119    * @param _value The amount of tokens to be spent.
120    */
121   function approve(address _spender, uint256 _value) public returns (bool) {
122     allowed[msg.sender][_spender] = _value;
123     emit Approval(msg.sender, _spender, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Function to check the amount of tokens that an owner allowed to a spender.
129    * @param _owner address The address which owns the funds.
130    * @param _spender address The address which will spend the funds.
131    * @return A uint256 specifying the amount of tokens still available for the spender.
132    */
133   function allowance(
134     address _owner,
135     address _spender
136    )
137     public
138     view
139     returns (uint256)
140   {
141     return allowed[_owner][_spender];
142   }
143 
144   /**
145    * @dev Increase the amount of tokens that an owner allowed to a spender.
146    * approve should be called when allowed[_spender] == 0. To increment
147    * allowed value is better to use this function to avoid 2 calls (and wait until
148    * the first transaction is mined)
149    * From MonolithDAO Token.sol
150    * @param _spender The address which will spend the funds.
151    * @param _addedValue The amount of tokens to increase the allowance by.
152    */
153   function increaseApproval(
154     address _spender,
155     uint256 _addedValue
156   )
157     public
158     returns (bool)
159   {
160     allowed[msg.sender][_spender] = (
161       allowed[msg.sender][_spender].add(_addedValue));
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   /**
167    * @dev Decrease the amount of tokens that an owner allowed to a spender.
168    * approve should be called when allowed[_spender] == 0. To decrement
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    * From MonolithDAO Token.sol
172    * @param _spender The address which will spend the funds.
173    * @param _subtractedValue The amount of tokens to decrease the allowance by.
174    */
175   function decreaseApproval(
176     address _spender,
177     uint256 _subtractedValue
178   )
179     public
180     returns (bool)
181   {
182     uint256 oldValue = allowed[msg.sender][_spender];
183     if (_subtractedValue >= oldValue) {
184       allowed[msg.sender][_spender] = 0;
185     } else {
186       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187     }
188     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192 }
193 
194 /**
195  * @title Ownable
196  * @dev The Ownable contract has an owner address, and provides basic authorization control
197  * functions, this simplifies the implementation of "user permissions".
198  */
199 contract Ownable {
200   address public owner;
201 
202 
203   event OwnershipRenounced(address indexed previousOwner);
204   event OwnershipTransferred(
205     address indexed previousOwner,
206     address indexed newOwner
207   );
208 
209 
210   /**
211    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
212    * account.
213    */
214   constructor() public {
215     owner = msg.sender;
216   }
217 
218   /**
219    * @dev Throws if called by any account other than the owner.
220    */
221   modifier onlyOwner() {
222     require(msg.sender == owner);
223     _;
224   }
225 
226   /**
227    * @dev Allows the current owner to relinquish control of the contract.
228    * @notice Renouncing to ownership will leave the contract without an owner.
229    * It will not be possible to call the functions with the `onlyOwner`
230    * modifier anymore.
231    */
232   function renounceOwnership() public onlyOwner {
233     emit OwnershipRenounced(owner);
234     owner = address(0);
235   }
236 
237   /**
238    * @dev Allows the current owner to transfer control of the contract to a newOwner.
239    * @param _newOwner The address to transfer ownership to.
240    */
241   function transferOwnership(address _newOwner) public onlyOwner {
242     _transferOwnership(_newOwner);
243   }
244 
245   /**
246    * @dev Transfers control of the contract to a newOwner.
247    * @param _newOwner The address to transfer ownership to.
248    */
249   function _transferOwnership(address _newOwner) internal {
250     require(_newOwner != address(0));
251     emit OwnershipTransferred(owner, _newOwner);
252     owner = _newOwner;
253   }
254 }
255 
256 
257 /**
258  * @title Pausable
259  * @dev Base contract which allows children to implement an emergency stop mechanism.
260  */
261 contract Pausable is Ownable {
262   event Pause();
263   event Unpause();
264 
265   bool public paused = false;
266 
267 
268   /**
269    * @dev Modifier to make a function callable only when the contract is not paused.
270    */
271   modifier whenNotPaused() {
272     require(!paused);
273     _;
274   }
275 
276   /**
277    * @dev Modifier to make a function callable only when the contract is paused.
278    */
279   modifier whenPaused() {
280     require(paused);
281     _;
282   }
283 
284   /**
285    * @dev called by the owner to pause, triggers stopped state
286    */
287   function pause() public onlyOwner whenNotPaused {
288     paused = true;
289     emit Pause();
290   }
291 
292   /**
293    * @dev called by the owner to unpause, returns to normal state
294    */
295   function unpause() public onlyOwner whenPaused {
296     paused = false;
297     emit Unpause();
298   }
299 }
300 
301 /**
302  * @title Pausable token
303  * @dev StandardToken modified with pausable transfers.
304  **/
305 contract PausableToken is StandardToken, Pausable {
306 
307   function transfer(
308     address _to,
309     uint256 _value
310   )
311     public
312     whenNotPaused
313     returns (bool)
314   {
315     return super.transfer(_to, _value);
316   }
317 
318   function transferFrom(
319     address _from,
320     address _to,
321     uint256 _value
322   )
323     public
324     whenNotPaused
325     returns (bool)
326   {
327     return super.transferFrom(_from, _to, _value);
328   }
329 
330   function approve(
331     address _spender,
332     uint256 _value
333   )
334     public
335     whenNotPaused
336     returns (bool)
337   {
338     return super.approve(_spender, _value);
339   }
340 
341   function increaseApproval(
342     address _spender,
343     uint _addedValue
344   )
345     public
346     whenNotPaused
347     returns (bool success)
348   {
349     return super.increaseApproval(_spender, _addedValue);
350   }
351 
352   function decreaseApproval(
353     address _spender,
354     uint _subtractedValue
355   )
356     public
357     whenNotPaused
358     returns (bool success)
359   {
360     return super.decreaseApproval(_spender, _subtractedValue);
361   }
362 }
363 
364 
365 
366 
367 
368 
369 
370 
371 
372 
373 /**
374  * @title SafeMath
375  * @dev Math operations with safety checks that throw on error
376  */
377 library SafeMath {
378 
379   /**
380   * @dev Multiplies two numbers, throws on overflow.
381   */
382   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
383     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
384     // benefit is lost if 'b' is also tested.
385     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
386     if (_a == 0) {
387       return 0;
388     }
389 
390     c = _a * _b;
391     assert(c / _a == _b);
392     return c;
393   }
394 
395   /**
396   * @dev Integer division of two numbers, truncating the quotient.
397   */
398   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
399     // assert(_b > 0); // Solidity automatically throws when dividing by 0
400     // uint256 c = _a / _b;
401     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
402     return _a / _b;
403   }
404 
405   /**
406   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
407   */
408   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
409     assert(_b <= _a);
410     return _a - _b;
411   }
412 
413   /**
414   * @dev Adds two numbers, throws on overflow.
415   */
416   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
417     c = _a + _b;
418     assert(c >= _a);
419     return c;
420   }
421 }
422 
423 /**
424  * @title DetailedERC20 token
425  * @dev The decimals are only for visualization purposes.
426  * All the operations are done using the smallest and indivisible token unit,
427  * just as on Ethereum all the operations are done in wei.
428  */
429 contract DetailedERC20 is ERC20 {
430   string public name;
431   string public symbol;
432   uint8 public decimals;
433 
434   constructor(string _name, string _symbol, uint8 _decimals) public {
435     name = _name;
436     symbol = _symbol;
437     decimals = _decimals;
438   }
439 }
440 
441 
442 /**
443  * @title Burnable Token
444  * @dev Token that can be irreversibly burned (destroyed).
445  */
446 contract BurnableToken is BasicToken {
447 
448   event Burn(address indexed burner, uint256 value);
449 
450   /**
451    * @dev Burns a specific amount of tokens.
452    * @param _value The amount of token to be burned.
453    */
454   function burn(uint256 _value) public {
455     _burn(msg.sender, _value);
456   }
457 
458   function _burn(address _who, uint256 _value) internal {
459     require(_value <= balances[_who]);
460     // no need to require value <= totalSupply, since that would imply the
461     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
462 
463     balances[_who] = balances[_who].sub(_value);
464     totalSupply_ = totalSupply_.sub(_value);
465     emit Burn(_who, _value);
466     emit Transfer(_who, address(0), _value);
467   }
468 }
469 contract ECTToken is DetailedERC20, BurnableToken , PausableToken {
470     
471     /**
472     * @dev Constructor that gives msg.sender all of existing tokens.
473     */
474     constructor() 
475     DetailedERC20("Ecoshare Community Token","ECT", 18)
476     public {
477         totalSupply_ = 1000000000 * (10 ** uint256(decimals));
478         balances[msg.sender] = totalSupply_;
479         paused = true;
480     }
481 }