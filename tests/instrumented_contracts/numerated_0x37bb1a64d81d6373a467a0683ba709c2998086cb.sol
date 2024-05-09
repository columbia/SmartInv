1 pragma solidity ^0.4.23;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
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
115 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
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
145 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
146 
147 /**
148  * @title Ownable
149  * @dev The Ownable contract has an owner address, and provides basic authorization control
150  * functions, this simplifies the implementation of "user permissions".
151  */
152 contract Ownable {
153   address public owner;
154 
155 
156   event OwnershipRenounced(address indexed previousOwner);
157   event OwnershipTransferred(
158     address indexed previousOwner,
159     address indexed newOwner
160   );
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   constructor() public {
168     owner = msg.sender;
169   }
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev Allows the current owner to relinquish control of the contract.
181    */
182   function renounceOwnership() public onlyOwner {
183     emit OwnershipRenounced(owner);
184     owner = address(0);
185   }
186 
187   /**
188    * @dev Allows the current owner to transfer control of the contract to a newOwner.
189    * @param _newOwner The address to transfer ownership to.
190    */
191   function transferOwnership(address _newOwner) public onlyOwner {
192     _transferOwnership(_newOwner);
193   }
194 
195   /**
196    * @dev Transfers control of the contract to a newOwner.
197    * @param _newOwner The address to transfer ownership to.
198    */
199   function _transferOwnership(address _newOwner) internal {
200     require(_newOwner != address(0));
201     emit OwnershipTransferred(owner, _newOwner);
202     owner = _newOwner;
203   }
204 }
205 
206 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
207 
208 /**
209  * @title Pausable
210  * @dev Base contract which allows children to implement an emergency stop mechanism.
211  */
212 contract Pausable is Ownable {
213   event Pause();
214   event Unpause();
215 
216   bool public paused = false;
217 
218 
219   /**
220    * @dev Modifier to make a function callable only when the contract is not paused.
221    */
222   modifier whenNotPaused() {
223     require(!paused);
224     _;
225   }
226 
227   /**
228    * @dev Modifier to make a function callable only when the contract is paused.
229    */
230   modifier whenPaused() {
231     require(paused);
232     _;
233   }
234 
235   /**
236    * @dev called by the owner to pause, triggers stopped state
237    */
238   function pause() onlyOwner whenNotPaused public {
239     paused = true;
240     emit Pause();
241   }
242 
243   /**
244    * @dev called by the owner to unpause, returns to normal state
245    */
246   function unpause() onlyOwner whenPaused public {
247     paused = false;
248     emit Unpause();
249   }
250 }
251 
252 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
253 
254 /**
255  * @title ERC20 interface
256  * @dev see https://github.com/ethereum/EIPs/issues/20
257  */
258 contract ERC20 is ERC20Basic {
259   function allowance(address owner, address spender)
260     public view returns (uint256);
261 
262   function transferFrom(address from, address to, uint256 value)
263     public returns (bool);
264 
265   function approve(address spender, uint256 value) public returns (bool);
266   event Approval(
267     address indexed owner,
268     address indexed spender,
269     uint256 value
270   );
271 }
272 
273 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
274 
275 /**
276  * @title Standard ERC20 token
277  *
278  * @dev Implementation of the basic standard token.
279  * @dev https://github.com/ethereum/EIPs/issues/20
280  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
281  */
282 contract StandardToken is ERC20, BasicToken {
283 
284   mapping (address => mapping (address => uint256)) internal allowed;
285 
286 
287   /**
288    * @dev Transfer tokens from one address to another
289    * @param _from address The address which you want to send tokens from
290    * @param _to address The address which you want to transfer to
291    * @param _value uint256 the amount of tokens to be transferred
292    */
293   function transferFrom(
294     address _from,
295     address _to,
296     uint256 _value
297   )
298     public
299     returns (bool)
300   {
301     require(_to != address(0));
302     require(_value <= balances[_from]);
303     require(_value <= allowed[_from][msg.sender]);
304 
305     balances[_from] = balances[_from].sub(_value);
306     balances[_to] = balances[_to].add(_value);
307     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
308     emit Transfer(_from, _to, _value);
309     return true;
310   }
311 
312   /**
313    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
314    *
315    * Beware that changing an allowance with this method brings the risk that someone may use both the old
316    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
317    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
318    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
319    * @param _spender The address which will spend the funds.
320    * @param _value The amount of tokens to be spent.
321    */
322   function approve(address _spender, uint256 _value) public returns (bool) {
323     allowed[msg.sender][_spender] = _value;
324     emit Approval(msg.sender, _spender, _value);
325     return true;
326   }
327 
328   /**
329    * @dev Function to check the amount of tokens that an owner allowed to a spender.
330    * @param _owner address The address which owns the funds.
331    * @param _spender address The address which will spend the funds.
332    * @return A uint256 specifying the amount of tokens still available for the spender.
333    */
334   function allowance(
335     address _owner,
336     address _spender
337    )
338     public
339     view
340     returns (uint256)
341   {
342     return allowed[_owner][_spender];
343   }
344 
345   /**
346    * @dev Increase the amount of tokens that an owner allowed to a spender.
347    *
348    * approve should be called when allowed[_spender] == 0. To increment
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _addedValue The amount of tokens to increase the allowance by.
354    */
355   function increaseApproval(
356     address _spender,
357     uint _addedValue
358   )
359     public
360     returns (bool)
361   {
362     allowed[msg.sender][_spender] = (
363       allowed[msg.sender][_spender].add(_addedValue));
364     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
365     return true;
366   }
367 
368   /**
369    * @dev Decrease the amount of tokens that an owner allowed to a spender.
370    *
371    * approve should be called when allowed[_spender] == 0. To decrement
372    * allowed value is better to use this function to avoid 2 calls (and wait until
373    * the first transaction is mined)
374    * From MonolithDAO Token.sol
375    * @param _spender The address which will spend the funds.
376    * @param _subtractedValue The amount of tokens to decrease the allowance by.
377    */
378   function decreaseApproval(
379     address _spender,
380     uint _subtractedValue
381   )
382     public
383     returns (bool)
384   {
385     uint oldValue = allowed[msg.sender][_spender];
386     if (_subtractedValue > oldValue) {
387       allowed[msg.sender][_spender] = 0;
388     } else {
389       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
390     }
391     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
392     return true;
393   }
394 
395 }
396 
397 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
398 
399 /**
400  * @title Pausable token
401  * @dev StandardToken modified with pausable transfers.
402  **/
403 contract PausableToken is StandardToken, Pausable {
404 
405   function transfer(
406     address _to,
407     uint256 _value
408   )
409     public
410     whenNotPaused
411     returns (bool)
412   {
413     return super.transfer(_to, _value);
414   }
415 
416   function transferFrom(
417     address _from,
418     address _to,
419     uint256 _value
420   )
421     public
422     whenNotPaused
423     returns (bool)
424   {
425     return super.transferFrom(_from, _to, _value);
426   }
427 
428   function approve(
429     address _spender,
430     uint256 _value
431   )
432     public
433     whenNotPaused
434     returns (bool)
435   {
436     return super.approve(_spender, _value);
437   }
438 
439   function increaseApproval(
440     address _spender,
441     uint _addedValue
442   )
443     public
444     whenNotPaused
445     returns (bool success)
446   {
447     return super.increaseApproval(_spender, _addedValue);
448   }
449 
450   function decreaseApproval(
451     address _spender,
452     uint _subtractedValue
453   )
454     public
455     whenNotPaused
456     returns (bool success)
457   {
458     return super.decreaseApproval(_spender, _subtractedValue);
459   }
460 }
461 
462 // File: contracts/token/FOLIToken.sol
463 
464 // ----------------------------------------------------------------------------
465 // FOLIToken - ERC20 Token
466 //
467 // The MIT Licence.
468 // ----------------------------------------------------------------------------
469 
470 contract FOLIToken is PausableToken, BurnableToken {
471   
472   string public symbol = "FOLI";
473 
474   string public name = "Flower of Life Token";
475   
476   uint8 public decimals = 18;
477 
478   uint public constant INITIAL_SUPPLY = 120 * 10 ** 8 * 10 ** 18;
479 
480   function FOLIToken() public {
481     totalSupply_ = INITIAL_SUPPLY;
482     balances[msg.sender] = INITIAL_SUPPLY;
483     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
484   }
485 
486   function () payable public {
487     revert();
488   }
489 
490 }