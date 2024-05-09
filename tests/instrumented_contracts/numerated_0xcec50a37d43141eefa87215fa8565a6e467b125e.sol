1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title SafeERC20
55  * @dev Wrappers around ERC20 operations that throw on failure.
56  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
57  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
58  */
59 library SafeERC20 {
60   function safeTransfer(ERC20 token, address to, uint256 value) internal {
61     require(token.transfer(to, value));
62   }
63 }
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71   address public owner;
72 
73 
74   event OwnershipRenounced(address indexed previousOwner);
75   event OwnershipTransferred(
76     address indexed previousOwner,
77     address indexed newOwner
78   );
79 
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   constructor() public {
86     owner = msg.sender;
87   }
88 
89   /**
90    * @dev Throws if called by any account other than the owner.
91    */
92   modifier onlyOwner() {
93     require(msg.sender == owner);
94     _;
95   }
96 
97   /**
98    * @dev Allows the current owner to relinquish control of the contract.
99    * @notice Renouncing to ownership will leave the contract without an owner.
100    * It will not be possible to call the functions with the `onlyOwner`
101    * modifier anymore.
102    */
103   function renounceOwnership() public onlyOwner {
104     emit OwnershipRenounced(owner);
105     owner = address(0);
106   }
107 
108   /**
109    * @dev Allows the current owner to transfer control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address _newOwner) public onlyOwner {
113     _transferOwnership(_newOwner);
114   }
115 
116   /**
117    * @dev Transfers control of the contract to a newOwner.
118    * @param _newOwner The address to transfer ownership to.
119    */
120   function _transferOwnership(address _newOwner) internal {
121     require(_newOwner != address(0));
122     emit OwnershipTransferred(owner, _newOwner);
123     owner = _newOwner;
124   }
125 }
126 
127 /**
128  * @title ERC20Basic
129  * @dev Simpler version of ERC20 interface
130  * See https://github.com/ethereum/EIPs/issues/179
131  */
132 contract ERC20Basic {
133   function totalSupply() public view returns (uint256);
134   function balanceOf(address who) public view returns (uint256);
135   function transfer(address to, uint256 value) public returns (bool);
136   event Transfer(address indexed from, address indexed to, uint256 value);
137 }
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 contract ERC20 is ERC20Basic {
144   function allowance(address owner, address spender)
145     public view returns (uint256);
146 
147   function transferFrom(address from, address to, uint256 value)
148     public returns (bool);
149 
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(
152     address indexed owner,
153     address indexed spender,
154     uint256 value
155   );
156 }
157 
158 /**
159  * @title Basic token
160  * @dev Basic version of StandardToken, with no allowances.
161  */
162 contract BasicToken is ERC20Basic {
163   using SafeMath for uint256;
164 
165   mapping(address => uint256) balances;
166 
167   uint256 totalSupply_;
168 
169   /**
170   * @dev Total number of tokens in existence
171   */
172   function totalSupply() public view returns (uint256) {
173     return totalSupply_;
174   }
175 
176   /**
177   * @dev Transfer token for a specified address
178   * @param _to The address to transfer to.
179   * @param _value The amount to be transferred.
180   */
181   function transfer(address _to, uint256 _value) public returns (bool) {
182     require(_to != address(0));
183     require(_value <= balances[msg.sender]);
184 
185     balances[msg.sender] = balances[msg.sender].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     emit Transfer(msg.sender, _to, _value);
188     return true;
189   }
190 
191   /**
192   * @dev Gets the balance of the specified address.
193   * @param _owner The address to query the the balance of.
194   * @return An uint256 representing the amount owned by the passed address.
195   */
196   function balanceOf(address _owner) public view returns (uint256) {
197     return balances[_owner];
198   }
199 
200 }
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * https://github.com/ethereum/EIPs/issues/20
207  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom( address _from, address _to, uint256 _value ) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= balances[_from]);
223     require(_value <= allowed[_from][msg.sender]);
224 
225     balances[_from] = balances[_from].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228     emit Transfer(_from, _to, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     emit Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(
254     address _owner,
255     address _spender
256    )
257     public
258     view
259     returns (uint256)
260   {
261     return allowed[_owner][_spender];
262   }
263 
264   /**
265    * @dev Increase the amount of tokens that an owner allowed to a spender.
266    * approve should be called when allowed[_spender] == 0. To increment
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _addedValue The amount of tokens to increase the allowance by.
272    */
273   function increaseApproval( address _spender, uint256 _addedValue ) public returns (bool) {
274     allowed[msg.sender][_spender] = (
275       allowed[msg.sender][_spender].add(_addedValue));
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    * approve should be called when allowed[_spender] == 0. To decrement
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    * @param _spender The address which will spend the funds.
287    * @param _subtractedValue The amount of tokens to decrease the allowance by.
288    */
289   function decreaseApproval( address _spender, uint256 _subtractedValue ) public returns (bool) {
290     uint256 oldValue = allowed[msg.sender][_spender];
291     if (_subtractedValue > oldValue) {
292       allowed[msg.sender][_spender] = 0;
293     } else {
294       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295     }
296     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300 }
301 
302 /**
303  * @title Pausable
304  * @dev Base contract which allows children to implement an emergency stop mechanism.
305  */
306 contract Pausable is Ownable {
307   event Pause();
308   event Unpause();
309 
310   bool public paused = false;
311 
312 
313   /**
314    * @dev Modifier to make a function callable only when the contract is not paused.
315    */
316   modifier whenNotPaused() {
317     require(!paused);
318     _;
319   }
320 
321   /**
322    * @dev Modifier to make a function callable only when the contract is paused.
323    */
324   modifier whenPaused() {
325     require(paused);
326     _;
327   }
328 
329   /**
330    * @dev called by the owner to pause, triggers stopped state
331    */
332   function pause() onlyOwner whenNotPaused public {
333     paused = true;
334     emit Pause();
335   }
336 
337   /**
338    * @dev called by the owner to unpause, returns to normal state
339    */
340   function unpause() onlyOwner whenPaused public {
341     paused = false;
342     emit Unpause();
343   }
344 }
345 
346 /**
347  * @title Pausable token
348  * @dev StandardToken modified with pausable transfers.
349  **/
350 contract PausableToken is StandardToken, Pausable {
351 
352   function transfer(
353     address _to,
354     uint256 _value
355   )
356     public
357     whenNotPaused
358     returns (bool)
359   {
360     return super.transfer(_to, _value);
361   }
362 
363   function transferFrom(
364     address _from,
365     address _to,
366     uint256 _value
367   )
368     public
369     whenNotPaused
370     returns (bool)
371   {
372     return super.transferFrom(_from, _to, _value);
373   }
374 
375   function approve(
376     address _spender,
377     uint256 _value
378   )
379     public
380     whenNotPaused
381     returns (bool)
382   {
383     return super.approve(_spender, _value);
384   }
385 
386   function increaseApproval(
387     address _spender,
388     uint _addedValue
389   )
390     public
391     whenNotPaused
392     returns (bool success)
393   {
394     return super.increaseApproval(_spender, _addedValue);
395   }
396 
397   function decreaseApproval(
398     address _spender,
399     uint _subtractedValue
400   )
401     public
402     whenNotPaused
403     returns (bool success)
404   {
405     return super.decreaseApproval(_spender, _subtractedValue);
406   }
407 }
408 
409 /**
410  * @title Burnable Token
411  * @dev Token that can be irreversibly burned (destroyed).
412  */
413 contract BurnableToken is BasicToken {
414 
415   event Burn(address indexed burner, uint256 value);
416 
417   /**
418    * @dev Burns a specific amount of tokens.
419    * @param _value The amount of token to be burned.
420    */
421   function burn(uint256 _value) public {
422     _burn(msg.sender, _value);
423   }
424 
425   function _burn(address _who, uint256 _value) internal {
426     require(_value <= balances[_who]);
427     // no need to require value <= totalSupply, since that would imply the
428     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
429 
430     balances[_who] = balances[_who].sub(_value);
431     totalSupply_ = totalSupply_.sub(_value);
432     emit Burn(_who, _value);
433     emit Transfer(_who, address(0), _value);
434   }
435 }
436 
437 /**
438  * @title FreezableToken
439  */
440 contract FreezableToken is StandardToken, Ownable {
441     mapping (address => bool) public frozenAccounts;
442     event FrozenFunds(address target, bool frozen);
443 
444     function freezeAccount(address target) public onlyOwner {
445         frozenAccounts[target] = true;
446         emit FrozenFunds(target, true);
447     }
448 
449     function unFreezeAccount(address target) public onlyOwner {
450         frozenAccounts[target] = false;
451         emit FrozenFunds(target, false);
452     }
453 
454     function frozen(address _target) constant public returns (bool){
455         return frozenAccounts[_target];
456     }
457 
458     // @dev Limit token transfer if _sender is frozen.
459     modifier canTransfer(address _sender) {
460         require(!frozenAccounts[_sender]);
461         _;
462     }
463 
464     function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns (bool success) {
465         // Call StandardToken.transfer()
466         return super.transfer(_to, _value);
467     }
468 
469     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns (bool success) {
470         // Call StandardToken.transferForm()
471         return super.transferFrom(_from, _to, _value);
472     }
473 }
474 
475 /**
476  * @title LTXToken
477  */
478 contract LTXToken is FreezableToken, PausableToken, BurnableToken {
479     string public constant name = "Ltree";
480     string public constant symbol = "LTX";
481     uint8 public constant decimals = 18;
482 
483     uint256 public constant INITIAL_SUPPLY = 8000000000 * 1 ether; 
484 
485     /**
486      * @dev Constructor
487      */
488     constructor() public {
489         totalSupply_ = INITIAL_SUPPLY;
490 
491         balances[msg.sender] = totalSupply_;
492         emit Transfer(0x0, msg.sender, totalSupply_);
493     }
494 }