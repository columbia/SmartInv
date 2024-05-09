1 // solium-disable linebreak-style
2 pragma solidity ^0.4.24; 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title Basic token
19  * @dev Basic version of StandardToken, with no allowances.
20  */
21 contract BasicToken is ERC20Basic {
22   using SafeMath for uint256;
23 
24   mapping(address => uint256) internal balances;
25 
26   uint256 internal totalSupply_;
27 
28   /**
29   * @dev Total number of tokens in existence
30   */
31   function totalSupply() public view returns (uint256) {
32     return totalSupply_;
33   }
34 
35   /**
36   * @dev Transfer token for a specified address
37   * @param _to The address to transfer to.
38   * @param _value The amount to be transferred.
39   */
40   function transfer(address _to, uint256 _value) public returns (bool) {
41     require(_value <= balances[msg.sender]);
42     require(_to != address(0));
43 
44     balances[msg.sender] = balances[msg.sender].sub(_value);
45     balances[_to] = balances[_to].add(_value);
46     emit Transfer(msg.sender, _to, _value);
47     return true;
48   }
49 
50   /**
51   * @dev Gets the balance of the specified address.
52   * @param _owner The address to query the the balance of.
53   * @return An uint256 representing the amount owned by the passed address.
54   */
55   function balanceOf(address _owner) public view returns (uint256) {
56     return balances[_owner];
57   }
58 
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address _owner, address _spender)
67     public view returns (uint256);
68 
69   function transferFrom(address _from, address _to, uint256 _value)
70     public returns (bool);
71 
72   function approve(address _spender, uint256 _value) public returns (bool);
73   event Approval(
74     address indexed owner,
75     address indexed spender,
76     uint256 value
77   );
78 }
79 
80 
81 contract StandardToken is ERC20, BasicToken {
82 
83   mapping (address => mapping (address => uint256)) internal allowed;
84 
85 
86   /**
87    * @dev Transfer tokens from one address to another
88    * @param _from address The address which you want to send tokens from
89    * @param _to address The address which you want to transfer to
90    * @param _value uint256 the amount of tokens to be transferred
91    */
92   function transferFrom(
93     address _from,
94     address _to,
95     uint256 _value
96   )
97     public
98     returns (bool)
99   {
100     require(_value <= balances[_from]);
101     require(_value <= allowed[_from][msg.sender]);
102     require(_to != address(0));
103 
104     balances[_from] = balances[_from].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
107     emit Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
113    * Beware that changing an allowance with this method brings the risk that someone may use both the old
114    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
115    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
116    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117    * @param _spender The address which will spend the funds.
118    * @param _value The amount of tokens to be spent.
119    */
120   function approve(address _spender, uint256 _value) public returns (bool) {
121     allowed[msg.sender][_spender] = _value;
122     emit Approval(msg.sender, _spender, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Function to check the amount of tokens that an owner allowed to a spender.
128    * @param _owner address The address which owns the funds.
129    * @param _spender address The address which will spend the funds.
130    * @return A uint256 specifying the amount of tokens still available for the spender.
131    */
132   function allowance(
133     address _owner,
134     address _spender
135    )
136     public
137     view
138     returns (uint256)
139   {
140     return allowed[_owner][_spender];
141   }
142 
143   /**
144    * @dev Increase the amount of tokens that an owner allowed to a spender.
145    * approve should be called when allowed[_spender] == 0. To increment
146    * allowed value is better to use this function to avoid 2 calls (and wait until
147    * the first transaction is mined)
148    * From MonolithDAO Token.sol
149    * @param _spender The address which will spend the funds.
150    * @param _addedValue The amount of tokens to increase the allowance by.
151    */
152   function increaseApproval(
153     address _spender,
154     uint256 _addedValue
155   )
156     public
157     returns (bool)
158   {
159     allowed[msg.sender][_spender] = (
160       allowed[msg.sender][_spender].add(_addedValue));
161     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   /**
166    * @dev Decrease the amount of tokens that an owner allowed to a spender.
167    * approve should be called when allowed[_spender] == 0. To decrement
168    * allowed value is better to use this function to avoid 2 calls (and wait until
169    * the first transaction is mined)
170    * From MonolithDAO Token.sol
171    * @param _spender The address which will spend the funds.
172    * @param _subtractedValue The amount of tokens to decrease the allowance by.
173    */
174   function decreaseApproval(
175     address _spender,
176     uint256 _subtractedValue
177   )
178     public
179     returns (bool)
180   {
181     uint256 oldValue = allowed[msg.sender][_spender];
182     if (_subtractedValue >= oldValue) {
183       allowed[msg.sender][_spender] = 0;
184     } else {
185       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186     }
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191 }
192 
193 /**
194  * @title Ownable
195  * @dev The Ownable contract has an owner address, and provides basic authorization control
196  * functions, this simplifies the implementation of "user permissions".
197  */
198 contract Ownable {
199   address public owner;
200 
201 
202   event OwnershipRenounced(address indexed previousOwner);
203   event OwnershipTransferred(
204     address indexed previousOwner,
205     address indexed newOwner
206   );
207 
208 
209   /**
210    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
211    * account.
212    */
213   constructor() public {
214     owner = msg.sender;
215   }
216 
217   /**
218    * @dev Throws if called by any account other than the owner.
219    */
220   modifier onlyOwner() {
221     require(msg.sender == owner);
222     _;
223   }
224 
225   /**
226    * @dev Allows the current owner to relinquish control of the contract.
227    * @notice Renouncing to ownership will leave the contract without an owner.
228    * It will not be possible to call the functions with the `onlyOwner`
229    * modifier anymore.
230    */
231   function renounceOwnership() public onlyOwner {
232     emit OwnershipRenounced(owner);
233     owner = address(0);
234   }
235 
236   /**
237    * @dev Allows the current owner to transfer control of the contract to a newOwner.
238    * @param _newOwner The address to transfer ownership to.
239    */
240   function transferOwnership(address _newOwner) public onlyOwner {
241     _transferOwnership(_newOwner);
242   }
243 
244   /**
245    * @dev Transfers control of the contract to a newOwner.
246    * @param _newOwner The address to transfer ownership to.
247    */
248   function _transferOwnership(address _newOwner) internal {
249     require(_newOwner != address(0));
250     emit OwnershipTransferred(owner, _newOwner);
251     owner = _newOwner;
252   }
253 }
254 
255 
256 /**
257  * @title Pausable
258  * @dev Base contract which allows children to implement an emergency stop mechanism.
259  */
260 contract Pausable is Ownable {
261   event Pause();
262   event Unpause();
263 
264   bool public paused = false;
265 
266 
267   /**
268    * @dev Modifier to make a function callable only when the contract is not paused.
269    */
270   modifier whenNotPaused() {
271     require(!paused);
272     _;
273   }
274 
275   /**
276    * @dev Modifier to make a function callable only when the contract is paused.
277    */
278   modifier whenPaused() {
279     require(paused);
280     _;
281   }
282 
283   /**
284    * @dev called by the owner to pause, triggers stopped state
285    */
286   function pause() public onlyOwner whenNotPaused {
287     paused = true;
288     emit Pause();
289   }
290 
291   /**
292    * @dev called by the owner to unpause, returns to normal state
293    */
294   function unpause() public onlyOwner whenPaused {
295     paused = false;
296     emit Unpause();
297   }
298 }
299 
300 /**
301  * @title Pausable token
302  * @dev StandardToken modified with pausable transfers.
303  **/
304 contract PausableToken is StandardToken, Pausable {
305 
306   function transfer(
307     address _to,
308     uint256 _value
309   )
310     public
311     whenNotPaused
312     returns (bool)
313   {
314     return super.transfer(_to, _value);
315   }
316 
317   function transferFrom(
318     address _from,
319     address _to,
320     uint256 _value
321   )
322     public
323     whenNotPaused
324     returns (bool)
325   {
326     return super.transferFrom(_from, _to, _value);
327   }
328 
329   function approve(
330     address _spender,
331     uint256 _value
332   )
333     public
334     whenNotPaused
335     returns (bool)
336   {
337     return super.approve(_spender, _value);
338   }
339 
340   function increaseApproval(
341     address _spender,
342     uint _addedValue
343   )
344     public
345     whenNotPaused
346     returns (bool success)
347   {
348     return super.increaseApproval(_spender, _addedValue);
349   }
350 
351   function decreaseApproval(
352     address _spender,
353     uint _subtractedValue
354   )
355     public
356     whenNotPaused
357     returns (bool success)
358   {
359     return super.decreaseApproval(_spender, _subtractedValue);
360   }
361 }
362 
363 
364 
365 
366 
367 
368 
369 
370 
371 
372 /**
373  * @title SafeMath
374  * @dev Math operations with safety checks that throw on error
375  */
376 library SafeMath {
377 
378   /**
379   * @dev Multiplies two numbers, throws on overflow.
380   */
381   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
382     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
383     // benefit is lost if 'b' is also tested.
384     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
385     if (_a == 0) {
386       return 0;
387     }
388 
389     c = _a * _b;
390     assert(c / _a == _b);
391     return c;
392   }
393 
394   /**
395   * @dev Integer division of two numbers, truncating the quotient.
396   */
397   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
398     // assert(_b > 0); // Solidity automatically throws when dividing by 0
399     // uint256 c = _a / _b;
400     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
401     return _a / _b;
402   }
403 
404   /**
405   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
406   */
407   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
408     assert(_b <= _a);
409     return _a - _b;
410   }
411 
412   /**
413   * @dev Adds two numbers, throws on overflow.
414   */
415   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
416     c = _a + _b;
417     assert(c >= _a);
418     return c;
419   }
420 }
421 
422 /**
423  * @title DetailedERC20 token
424  * @dev The decimals are only for visualization purposes.
425  * All the operations are done using the smallest and indivisible token unit,
426  * just as on Ethereum all the operations are done in wei.
427  */
428 contract DetailedERC20 is ERC20 {
429   string public name;
430   string public symbol;
431   uint8 public decimals;
432 
433   constructor(string _name, string _symbol, uint8 _decimals) public {
434     name = _name;
435     symbol = _symbol;
436     decimals = _decimals;
437   }
438 }
439 
440 
441 /**
442  * @title Burnable Token
443  * @dev Token that can be irreversibly burned (destroyed).
444  */
445 contract BurnableToken is BasicToken {
446 
447   event Burn(address indexed burner, uint256 value);
448 
449   /**
450    * @dev Burns a specific amount of tokens.
451    * @param _value The amount of token to be burned.
452    */
453   function burn(uint256 _value) public {
454     _burn(msg.sender, _value);
455   }
456 
457   function _burn(address _who, uint256 _value) internal {
458     require(_value <= balances[_who]);
459     // no need to require value <= totalSupply, since that would imply the
460     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
461 
462     balances[_who] = balances[_who].sub(_value);
463     totalSupply_ = totalSupply_.sub(_value);
464     emit Burn(_who, _value);
465     emit Transfer(_who, address(0), _value);
466   }
467 }
468 contract ECTToken is DetailedERC20, BurnableToken , PausableToken {
469     
470     /**
471     * @dev Constructor that gives msg.sender all of existing tokens.
472     */
473     constructor() 
474     DetailedERC20("Ecoshare Community Token","ECT", 18)
475     public {
476         totalSupply_ = 1000000000 * (10 ** uint256(decimals));
477         balances[msg.sender] = totalSupply_;
478         paused = true;
479     }
480 }