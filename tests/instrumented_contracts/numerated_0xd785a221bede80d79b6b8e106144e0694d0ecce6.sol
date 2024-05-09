1 pragma solidity ^0.4.24;
2 
3 /**
4 * Smart Token Contract
5 * Copyright © 2018 by Smartportfolio.io
6 */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (a == 0) {
22       return 0;
23     }
24 
25     c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return a / b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * See https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender)
78     public view returns (uint256);
79 
80   function transferFrom(address from, address to, uint256 value)
81     public returns (bool);
82 
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(
85     address indexed owner,
86     address indexed spender,
87     uint256 value
88   );
89 }
90 
91 
92 
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   uint256 totalSupply_;
104 
105   /**
106   * @dev Total number of tokens in existence
107   */
108   function totalSupply() public view returns (uint256) {
109     return totalSupply_;
110   }
111 
112   /**
113   * @dev Transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(_value <= balances[msg.sender]);
119     require(_to != address(0));
120 
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     emit Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 
139 
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * https://github.com/ethereum/EIPs/issues/20
146  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is ERC20, BasicToken {
149 
150   mapping (address => mapping (address => uint256)) internal allowed;
151 
152 
153   /**
154    * @dev Transfer tokens from one address to another
155    * @param _from address The address which you want to send tokens from
156    * @param _to address The address which you want to transfer to
157    * @param _value uint256 the amount of tokens to be transferred
158    */
159   function transferFrom(
160     address _from,
161     address _to,
162     uint256 _value
163   )
164     public
165     returns (bool)
166   {
167     require(_value <= balances[_from]);
168     require(_value <= allowed[_from][msg.sender]);
169     require(_to != address(0));
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174     emit Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint256 _value) public returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     emit Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(
200     address _owner,
201     address _spender
202    )
203     public
204     view
205     returns (uint256)
206   {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211    * @dev Increase the amount of tokens that an owner allowed to a spender.
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(
220     address _spender,
221     uint256 _addedValue
222   )
223     public
224     returns (bool)
225   {
226     allowed[msg.sender][_spender] = (
227       allowed[msg.sender][_spender].add(_addedValue));
228     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232   /**
233    * @dev Decrease the amount of tokens that an owner allowed to a spender.
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(
242     address _spender,
243     uint256 _subtractedValue
244   )
245     public
246     returns (bool)
247   {
248     uint256 oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue >= oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 
261 /**
262  * @title Ownable
263  * @dev The Ownable contract has an owner address, and provides basic authorization control
264  * functions, this simplifies the implementation of "user permissions".
265  */
266 contract Ownable {
267   address public owner;
268 
269 
270   event OwnershipRenounced(address indexed previousOwner);
271   event OwnershipTransferred(
272     address indexed previousOwner,
273     address indexed newOwner
274   );
275 
276 
277   /**
278    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
279    * account.
280    */
281   constructor() public {
282     owner = msg.sender;
283   }
284 
285   /**
286    * @dev Throws if called by any account other than the owner.
287    */
288   modifier onlyOwner() {
289     require(msg.sender == owner);
290     _;
291   }
292 
293   /**
294    * @dev Allows the current owner to relinquish control of the contract.
295    * @notice Renouncing to ownership will leave the contract without an owner.
296    * It will not be possible to call the functions with the `onlyOwner`
297    * modifier anymore.
298    */
299   function renounceOwnership() public onlyOwner {
300     emit OwnershipRenounced(owner);
301     owner = address(0);
302   }
303 
304   /**
305    * @dev Allows the current owner to transfer control of the contract to a newOwner.
306    * @param _newOwner The address to transfer ownership to.
307    */
308   function transferOwnership(address _newOwner) public onlyOwner {
309     _transferOwnership(_newOwner);
310   }
311 
312   /**
313    * @dev Transfers control of the contract to a newOwner.
314    * @param _newOwner The address to transfer ownership to.
315    */
316   function _transferOwnership(address _newOwner) internal {
317     require(_newOwner != address(0));
318     emit OwnershipTransferred(owner, _newOwner);
319     owner = _newOwner;
320   }
321 }
322 
323 /**
324  * @title Pausable
325  * @dev Base contract which allows children to implement an emergency stop mechanism.
326  */
327 contract Pausable is Ownable {
328   event Pause();
329   event Unpause();
330 
331   bool public paused = false;
332 
333 
334   /**
335    * @dev Modifier to make a function callable only when the contract is not paused.
336    */
337   modifier whenNotPaused() {
338     require(!paused);
339     _;
340   }
341 
342   /**
343    * @dev Modifier to make a function callable only when the contract is paused.
344    */
345   modifier whenPaused() {
346     require(paused);
347     _;
348   }
349 
350   /**
351    * @dev called by the owner to pause, triggers stopped state
352    */
353   function pause() onlyOwner whenNotPaused public {
354     paused = true;
355     emit Pause();
356   }
357 
358   /**
359    * @dev called by the owner to unpause, returns to normal state
360    */
361   function unpause() onlyOwner whenPaused public {
362     paused = false;
363     emit Unpause();
364   }
365 }
366 
367 /**
368  * @title Pausable token
369  * @dev StandardToken modified with pausable transfers.
370  **/
371 contract PausableToken is StandardToken, Pausable {
372 
373   function transfer(
374     address _to,
375     uint256 _value
376   )
377     public
378     whenNotPaused
379     returns (bool)
380   {
381     return super.transfer(_to, _value);
382   }
383 
384   function transferFrom(
385     address _from,
386     address _to,
387     uint256 _value
388   )
389     public
390     whenNotPaused
391     returns (bool)
392   {
393     return super.transferFrom(_from, _to, _value);
394   }
395 
396   function approve(
397     address _spender,
398     uint256 _value
399   )
400     public
401     whenNotPaused
402     returns (bool)
403   {
404     return super.approve(_spender, _value);
405   }
406 
407   function increaseApproval(
408     address _spender,
409     uint _addedValue
410   )
411     public
412     whenNotPaused
413     returns (bool success)
414   {
415     return super.increaseApproval(_spender, _addedValue);
416   }
417 
418   function decreaseApproval(
419     address _spender,
420     uint _subtractedValue
421   )
422     public
423     whenNotPaused
424     returns (bool success)
425   {
426     return super.decreaseApproval(_spender, _subtractedValue);
427   }
428 }
429 
430 /**
431  * @title Burnable Token
432  * @dev Token that can be irreversibly burned (destroyed).
433  */
434 contract BurnableToken is BasicToken {
435 
436   event Burn(address indexed burner, uint256 value);
437 
438   /**
439    * @dev Burns a specific amount of tokens.
440    * @param _value The amount of token to be burned.
441    */
442   function burn(uint256 _value) public {
443     _burn(msg.sender, _value);
444   }
445 
446   function _burn(address _who, uint256 _value) internal {
447     require(_value <= balances[_who]);
448     // no need to require value <= totalSupply, since that would imply the
449     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
450 
451     balances[_who] = balances[_who].sub(_value);
452     totalSupply_ = totalSupply_.sub(_value);
453     emit Burn(_who, _value);
454     emit Transfer(_who, address(0), _value);
455   }
456 }
457 
458 
459 
460 /**
461  * @title SPTToken
462  * @dev SPTToken with 1b Tokens max supply
463  * 
464  **/
465 contract SPTToken is PausableToken, BurnableToken {
466   string public constant version = "1.0";
467   string public constant name = "Smart Portfolio Token";
468   string public constant symbol = "SPT";
469   uint8 public constant decimals = 18;
470     
471     
472   /**
473    * @dev Constructor that gives msg.sender all of existing tokens. 
474    */
475   function SPTToken() {   
476     totalSupply_ = 1000000000 * 10**uint256(decimals); //make sure decimals is typecast to uint256
477     balances[msg.sender] = totalSupply_;
478   }
479  
480 }