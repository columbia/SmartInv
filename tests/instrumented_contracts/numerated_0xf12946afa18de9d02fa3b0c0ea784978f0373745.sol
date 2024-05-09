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
145 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
181    * @notice Renouncing to ownership will leave the contract without an owner.
182    * It will not be possible to call the functions with the `onlyOwner`
183    * modifier anymore.
184    */
185   function renounceOwnership() public onlyOwner {
186     emit OwnershipRenounced(owner);
187     owner = address(0);
188   }
189 
190   /**
191    * @dev Allows the current owner to transfer control of the contract to a newOwner.
192    * @param _newOwner The address to transfer ownership to.
193    */
194   function transferOwnership(address _newOwner) public onlyOwner {
195     _transferOwnership(_newOwner);
196   }
197 
198   /**
199    * @dev Transfers control of the contract to a newOwner.
200    * @param _newOwner The address to transfer ownership to.
201    */
202   function _transferOwnership(address _newOwner) internal {
203     require(_newOwner != address(0));
204     emit OwnershipTransferred(owner, _newOwner);
205     owner = _newOwner;
206   }
207 }
208 
209 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
210 
211 /**
212  * @title Pausable
213  * @dev Base contract which allows children to implement an emergency stop mechanism.
214  */
215 contract Pausable is Ownable {
216   event Pause();
217   event Unpause();
218 
219   bool public paused = false;
220 
221 
222   /**
223    * @dev Modifier to make a function callable only when the contract is not paused.
224    */
225   modifier whenNotPaused() {
226     require(!paused);
227     _;
228   }
229 
230   /**
231    * @dev Modifier to make a function callable only when the contract is paused.
232    */
233   modifier whenPaused() {
234     require(paused);
235     _;
236   }
237 
238   /**
239    * @dev called by the owner to pause, triggers stopped state
240    */
241   function pause() public onlyOwner whenNotPaused {
242     paused = true;
243     emit Pause();
244   }
245 
246   /**
247    * @dev called by the owner to unpause, returns to normal state
248    */
249   function unpause() public onlyOwner whenPaused {
250     paused = false;
251     emit Unpause();
252   }
253 }
254 
255 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
256 
257 /**
258  * @title ERC20 interface
259  * @dev see https://github.com/ethereum/EIPs/issues/20
260  */
261 contract ERC20 is ERC20Basic {
262   function allowance(address _owner, address _spender)
263     public view returns (uint256);
264 
265   function transferFrom(address _from, address _to, uint256 _value)
266     public returns (bool);
267 
268   function approve(address _spender, uint256 _value) public returns (bool);
269   event Approval(
270     address indexed owner,
271     address indexed spender,
272     uint256 value
273   );
274 }
275 
276 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
277 
278 /**
279  * @title Standard ERC20 token
280  *
281  * @dev Implementation of the basic standard token.
282  * https://github.com/ethereum/EIPs/issues/20
283  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
284  */
285 contract StandardToken is ERC20, BasicToken {
286 
287   mapping (address => mapping (address => uint256)) internal allowed;
288 
289 
290   /**
291    * @dev Transfer tokens from one address to another
292    * @param _from address The address which you want to send tokens from
293    * @param _to address The address which you want to transfer to
294    * @param _value uint256 the amount of tokens to be transferred
295    */
296   function transferFrom(
297     address _from,
298     address _to,
299     uint256 _value
300   )
301     public
302     returns (bool)
303   {
304     require(_value <= balances[_from]);
305     require(_value <= allowed[_from][msg.sender]);
306     require(_to != address(0));
307 
308     balances[_from] = balances[_from].sub(_value);
309     balances[_to] = balances[_to].add(_value);
310     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
311     emit Transfer(_from, _to, _value);
312     return true;
313   }
314 
315   /**
316    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
317    * Beware that changing an allowance with this method brings the risk that someone may use both the old
318    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
319    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
320    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
321    * @param _spender The address which will spend the funds.
322    * @param _value The amount of tokens to be spent.
323    */
324   function approve(address _spender, uint256 _value) public returns (bool) {
325     allowed[msg.sender][_spender] = _value;
326     emit Approval(msg.sender, _spender, _value);
327     return true;
328   }
329 
330   /**
331    * @dev Function to check the amount of tokens that an owner allowed to a spender.
332    * @param _owner address The address which owns the funds.
333    * @param _spender address The address which will spend the funds.
334    * @return A uint256 specifying the amount of tokens still available for the spender.
335    */
336   function allowance(
337     address _owner,
338     address _spender
339    )
340     public
341     view
342     returns (uint256)
343   {
344     return allowed[_owner][_spender];
345   }
346 
347   /**
348    * @dev Increase the amount of tokens that an owner allowed to a spender.
349    * approve should be called when allowed[_spender] == 0. To increment
350    * allowed value is better to use this function to avoid 2 calls (and wait until
351    * the first transaction is mined)
352    * From MonolithDAO Token.sol
353    * @param _spender The address which will spend the funds.
354    * @param _addedValue The amount of tokens to increase the allowance by.
355    */
356   function increaseApproval(
357     address _spender,
358     uint256 _addedValue
359   )
360     public
361     returns (bool)
362   {
363     allowed[msg.sender][_spender] = (
364       allowed[msg.sender][_spender].add(_addedValue));
365     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
366     return true;
367   }
368 
369   /**
370    * @dev Decrease the amount of tokens that an owner allowed to a spender.
371    * approve should be called when allowed[_spender] == 0. To decrement
372    * allowed value is better to use this function to avoid 2 calls (and wait until
373    * the first transaction is mined)
374    * From MonolithDAO Token.sol
375    * @param _spender The address which will spend the funds.
376    * @param _subtractedValue The amount of tokens to decrease the allowance by.
377    */
378   function decreaseApproval(
379     address _spender,
380     uint256 _subtractedValue
381   )
382     public
383     returns (bool)
384   {
385     uint256 oldValue = allowed[msg.sender][_spender];
386     if (_subtractedValue >= oldValue) {
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
397 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
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
462 // File: contracts/HAToken.sol
463 
464 contract HAToken is BurnableToken, PausableToken {
465   string public name = "HA Diamond";
466   string public symbol = "HA";
467   uint public decimals = 18;
468 
469   uint public INITIAL_SUPPLY = 8000000000 * (10 ** decimals);
470 
471   constructor() public {
472     totalSupply_ = INITIAL_SUPPLY;
473 
474     balances[msg.sender] = INITIAL_SUPPLY;
475   }
476 }