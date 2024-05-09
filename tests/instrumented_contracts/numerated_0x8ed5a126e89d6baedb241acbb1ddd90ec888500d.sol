1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   uint256 totalSupply_;
80 
81   /**
82   * @dev Total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   /**
89   * @dev Transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_value <= balances[msg.sender]);
95     require(_to != address(0));
96 
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     emit Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 
115 /**
116  * @title Burnable Token
117  * @dev Token that can be irreversibly burned (destroyed).
118  */
119 contract BurnableToken is BasicToken {
120 
121   event Burn(address indexed burner, uint256 value);
122 
123   /**
124    * @dev Burns a specific amount of tokens.
125    * @param _value The amount of token to be burned.
126    */
127   function burn(uint256 _value) public {
128     _burn(msg.sender, _value);
129   }
130 
131   function _burn(address _who, uint256 _value) internal {
132     require(_value <= balances[_who]);
133     // no need to require value <= totalSupply, since that would imply the
134     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
135 
136     balances[_who] = balances[_who].sub(_value);
137     totalSupply_ = totalSupply_.sub(_value);
138     emit Burn(_who, _value);
139     emit Transfer(_who, address(0), _value);
140   }
141 }
142 
143 
144 
145 /**
146  * @title ERC20Basic
147  * @dev Simpler version of ERC20 interface
148  * See https://github.com/ethereum/EIPs/issues/179
149  */
150 
151 
152 /**
153  * @title ERC20 interface
154  * @dev see https://github.com/ethereum/EIPs/issues/20
155  */
156 contract ERC20 is ERC20Basic {
157   function allowance(address owner, address spender)
158     public view returns (uint256);
159 
160   function transferFrom(address from, address to, uint256 value)
161     public returns (bool);
162 
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(
165     address indexed owner,
166     address indexed spender,
167     uint256 value
168   );
169 }
170 
171 
172 /**
173  * @title Standard ERC20 token
174  *
175  * @dev Implementation of the basic standard token.
176  * https://github.com/ethereum/EIPs/issues/20
177  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
178  */
179 contract StandardToken is ERC20, BasicToken {
180 
181   mapping (address => mapping (address => uint256)) internal allowed;
182 
183 
184   /**
185    * @dev Transfer tokens from one address to another
186    * @param _from address The address which you want to send tokens from
187    * @param _to address The address which you want to transfer to
188    * @param _value uint256 the amount of tokens to be transferred
189    */
190   function transferFrom(
191     address _from,
192     address _to,
193     uint256 _value
194   )
195     public
196     returns (bool)
197   {
198     require(_value <= balances[_from]);
199     require(_value <= allowed[_from][msg.sender]);
200     require(_to != address(0));
201 
202     balances[_from] = balances[_from].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205     emit Transfer(_from, _to, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    * Beware that changing an allowance with this method brings the risk that someone may use both the old
212    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215    * @param _spender The address which will spend the funds.
216    * @param _value The amount of tokens to be spent.
217    */
218   function approve(address _spender, uint256 _value) public returns (bool) {
219     allowed[msg.sender][_spender] = _value;
220     emit Approval(msg.sender, _spender, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Function to check the amount of tokens that an owner allowed to a spender.
226    * @param _owner address The address which owns the funds.
227    * @param _spender address The address which will spend the funds.
228    * @return A uint256 specifying the amount of tokens still available for the spender.
229    */
230   function allowance(
231     address _owner,
232     address _spender
233    )
234     public
235     view
236     returns (uint256)
237   {
238     return allowed[_owner][_spender];
239   }
240 
241   /**
242    * @dev Increase the amount of tokens that an owner allowed to a spender.
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseApproval(
251     address _spender,
252     uint256 _addedValue
253   )
254     public
255     returns (bool)
256   {
257     allowed[msg.sender][_spender] = (
258       allowed[msg.sender][_spender].add(_addedValue));
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Decrease the amount of tokens that an owner allowed to a spender.
265    * approve should be called when allowed[_spender] == 0. To decrement
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _subtractedValue The amount of tokens to decrease the allowance by.
271    */
272   function decreaseApproval(
273     address _spender,
274     uint256 _subtractedValue
275   )
276     public
277     returns (bool)
278   {
279     uint256 oldValue = allowed[msg.sender][_spender];
280     if (_subtractedValue >= oldValue) {
281       allowed[msg.sender][_spender] = 0;
282     } else {
283       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
284     }
285     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286     return true;
287   }
288 
289 }
290 
291 
292 /**
293  * @title Standard Burnable Token
294  * @dev Adds burnFrom method to ERC20 implementations
295  */
296 contract StandardBurnableToken is BurnableToken, StandardToken {
297 
298   /**
299    * @dev Burns a specific amount of tokens from the target address and decrements allowance
300    * @param _from address The address which you want to send tokens from
301    * @param _value uint256 The amount of token to be burned
302    */
303   function burnFrom(address _from, uint256 _value) public {
304     require(_value <= allowed[_from][msg.sender]);
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
308     _burn(_from, _value);
309   }
310 }
311 
312 
313 /**
314  * @title Ownable
315  * @dev The Ownable contract has an owner address, and provides basic authorization control
316  * functions, this simplifies the implementation of "user permissions".
317  */
318 contract Ownable {
319   address public owner;
320 
321 
322   event OwnershipRenounced(address indexed previousOwner);
323   event OwnershipTransferred(
324     address indexed previousOwner,
325     address indexed newOwner
326   );
327 
328 
329   /**
330    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
331    * account.
332    */
333   constructor() public {
334     owner = msg.sender;
335   }
336 
337   /**
338    * @dev Throws if called by any account other than the owner.
339    */
340   modifier onlyOwner() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Allows the current owner to relinquish control of the contract.
347    * @notice Renouncing to ownership will leave the contract without an owner.
348    * It will not be possible to call the functions with the `onlyOwner`
349    * modifier anymore.
350    */
351   function renounceOwnership() public onlyOwner {
352     emit OwnershipRenounced(owner);
353     owner = address(0);
354   }
355 
356   /**
357    * @dev Allows the current owner to transfer control of the contract to a newOwner.
358    * @param _newOwner The address to transfer ownership to.
359    */
360   function transferOwnership(address _newOwner) public onlyOwner {
361     _transferOwnership(_newOwner);
362   }
363 
364   /**
365    * @dev Transfers control of the contract to a newOwner.
366    * @param _newOwner The address to transfer ownership to.
367    */
368   function _transferOwnership(address _newOwner) internal {
369     require(_newOwner != address(0));
370     emit OwnershipTransferred(owner, _newOwner);
371     owner = _newOwner;
372   }
373 }
374 
375 
376 /**
377  * @title Pausable
378  * @dev Base contract which allows children to implement an emergency stop mechanism.
379  */
380 contract Pausable is Ownable {
381   event Pause();
382   event Unpause();
383 
384   bool public paused = false;
385 
386 
387   /**
388    * @dev Modifier to make a function callable only when the contract is not paused.
389    */
390   modifier whenNotPaused() {
391     require(!paused);
392     _;
393   }
394 
395   /**
396    * @dev Modifier to make a function callable only when the contract is paused.
397    */
398   modifier whenPaused() {
399     require(paused);
400     _;
401   }
402 
403   /**
404    * @dev called by the owner to pause, triggers stopped state
405    */
406   function pause() onlyOwner whenNotPaused public {
407     paused = true;
408     emit Pause();
409   }
410 
411   /**
412    * @dev called by the owner to unpause, returns to normal state
413    */
414   function unpause() onlyOwner whenPaused public {
415     paused = false;
416     emit Unpause();
417   }
418 }
419 
420 
421 /**
422  * @title Pausable token
423  * @dev StandardToken modified with pausable transfers.
424  **/
425 contract PausableToken is StandardToken, Pausable {
426 
427   function transfer(
428     address _to,
429     uint256 _value
430   )
431     public
432     whenNotPaused
433     returns (bool)
434   {
435     return super.transfer(_to, _value);
436   }
437 
438   function transferFrom(
439     address _from,
440     address _to,
441     uint256 _value
442   )
443     public
444     whenNotPaused
445     returns (bool)
446   {
447     return super.transferFrom(_from, _to, _value);
448   }
449 
450   function approve(
451     address _spender,
452     uint256 _value
453   )
454     public
455     whenNotPaused
456     returns (bool)
457   {
458     return super.approve(_spender, _value);
459   }
460 
461   function increaseApproval(
462     address _spender,
463     uint _addedValue
464   )
465     public
466     whenNotPaused
467     returns (bool success)
468   {
469     return super.increaseApproval(_spender, _addedValue);
470   }
471 
472   function decreaseApproval(
473     address _spender,
474     uint _subtractedValue
475   )
476     public
477     whenNotPaused
478     returns (bool success)
479   {
480     return super.decreaseApproval(_spender, _subtractedValue);
481   }
482 }
483 
484 contract GoodGameCenterToken is StandardBurnableToken {
485     string public name;
486     string public symbol;
487     uint8 public decimals;
488 
489     constructor() public {
490         name = "GoodGameCenterToken";
491         symbol = "GGC";
492         decimals = 18;
493         totalSupply_ = 500000000*(10 ** uint256(decimals));
494         balances[msg.sender] = totalSupply_;
495     }
496 }