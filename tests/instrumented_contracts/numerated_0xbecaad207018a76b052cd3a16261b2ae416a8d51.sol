1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     if (a == 0) {
26       return 0;
27     }
28     c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     // uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return a / b;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title SafeERC20
63  * @dev Wrappers around ERC20 operations that throw on failure.
64  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
65  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
66  */
67 library SafeERC20 {
68   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
69     require(token.transfer(to, value));
70   }
71 
72   function safeTransferFrom(
73     ERC20 token,
74     address from,
75     address to,
76     uint256 value
77   )
78     internal
79   {
80     require(token.transferFrom(from, to, value));
81   }
82 
83   function safeApprove(ERC20 token, address spender, uint256 value) internal {
84     require(token.approve(spender, value));
85   }
86 }
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender)
94     public view returns (uint256);
95 
96   function transferFrom(address from, address to, uint256 value)
97     public returns (bool);
98 
99   function approve(address spender, uint256 value) public returns (bool);
100   event Approval(
101     address indexed owner,
102     address indexed spender,
103     uint256 value
104   );
105 }
106 
107 /**
108  * @title Basic token
109  * @dev Basic version of StandardToken, with no allowances.
110  */
111 contract BasicToken is ERC20Basic {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115 
116   uint256 totalSupply_;
117 
118   /**
119   * @dev total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return totalSupply_;
123   }
124 
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value) public returns (bool) {
131     require(_to != address(0));
132     require(_value <= balances[msg.sender]);
133 
134     balances[msg.sender] = balances[msg.sender].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     emit Transfer(msg.sender, _to, _value);
137     return true;
138   }
139 
140   /**
141   * @dev Gets the balance of the specified address.
142   * @param _owner The address to query the the balance of.
143   * @return An uint256 representing the amount owned by the passed address.
144   */
145   function balanceOf(address _owner) public view returns (uint256) {
146     return balances[_owner];
147   }
148 
149 }
150 
151 /**
152  * @title Standard ERC20 token
153  *
154  * @dev Implementation of the basic standard token.
155  * @dev https://github.com/ethereum/EIPs/issues/20
156  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
157  */
158 contract StandardToken is ERC20, BasicToken {
159 
160   mapping (address => mapping (address => uint256)) internal allowed;
161 
162 
163   /**
164    * @dev Transfer tokens from one address to another
165    * @param _from address The address which you want to send tokens from
166    * @param _to address The address which you want to transfer to
167    * @param _value uint256 the amount of tokens to be transferred
168    */
169   function transferFrom(
170     address _from,
171     address _to,
172     uint256 _value
173   )
174     public
175     returns (bool)
176   {
177     require(_to != address(0));
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     emit Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    *
191    * Beware that changing an allowance with this method brings the risk that someone may use both the old
192    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195    * @param _spender The address which will spend the funds.
196    * @param _value The amount of tokens to be spent.
197    */
198   function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     emit Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210   function allowance(
211     address _owner,
212     address _spender
213    )
214     public
215     view
216     returns (uint256)
217   {
218     return allowed[_owner][_spender];
219   }
220 
221   /**
222    * @dev Increase the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To increment
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _addedValue The amount of tokens to increase the allowance by.
230    */
231   function increaseApproval(
232     address _spender,
233     uint _addedValue
234   )
235     public
236     returns (bool)
237   {
238     allowed[msg.sender][_spender] = (
239       allowed[msg.sender][_spender].add(_addedValue));
240     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244   /**
245    * @dev Decrease the amount of tokens that an owner allowed to a spender.
246    *
247    * approve should be called when allowed[_spender] == 0. To decrement
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _subtractedValue The amount of tokens to decrease the allowance by.
253    */
254   function decreaseApproval(
255     address _spender,
256     uint _subtractedValue
257   )
258     public
259     returns (bool)
260   {
261     uint oldValue = allowed[msg.sender][_spender];
262     if (_subtractedValue > oldValue) {
263       allowed[msg.sender][_spender] = 0;
264     } else {
265       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266     }
267     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271 }
272 
273 /**
274  * @title Ownable
275  * @dev The Ownable contract has an owner address, and provides basic authorization control
276  * functions, this simplifies the implementation of "user permissions".
277  */
278 contract Ownable {
279   address public owner;
280 
281 
282   event OwnershipRenounced(address indexed previousOwner);
283   event OwnershipTransferred(
284     address indexed previousOwner,
285     address indexed newOwner
286   );
287 
288 
289   /**
290    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
291    * account.
292    */
293   constructor() public {
294     owner = msg.sender;
295   }
296 
297   /**
298    * @dev Throws if called by any account other than the owner.
299    */
300   modifier onlyOwner() {
301     require(msg.sender == owner);
302     _;
303   }
304 
305   /**
306    * @dev Allows the current owner to transfer control of the contract to a newOwner.
307    * @param newOwner The address to transfer ownership to.
308    */
309   function transferOwnership(address newOwner) public onlyOwner {
310     require(newOwner != address(0));
311     emit OwnershipTransferred(owner, newOwner);
312     owner = newOwner;
313   }
314 
315   /**
316    * @dev Allows the current owner to relinquish control of the contract.
317    */
318   function renounceOwnership() public onlyOwner {
319     emit OwnershipRenounced(owner);
320     owner = address(0);
321   }
322 }
323 
324 /**
325  * @title Contracts that should be able to recover tokens
326  * @author SylTi
327  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
328  * This will prevent any accidental loss of tokens.
329  */
330 contract CanReclaimToken is Ownable {
331   using SafeERC20 for ERC20Basic;
332 
333   /**
334    * @dev Reclaim all ERC20Basic compatible tokens
335    * @param token ERC20Basic The address of the token contract
336    */
337   function reclaimToken(ERC20Basic token) external onlyOwner {
338     uint256 balance = token.balanceOf(this);
339     token.safeTransfer(owner, balance);
340   }
341 
342 }
343 
344 /**
345  * @title Pausable
346  * @dev Base contract which allows children to implement an emergency stop mechanism.
347  */
348 contract Pausable is CanReclaimToken {
349   event Pause();
350   event Unpause();
351 
352   bool public paused = false;
353 
354 
355   /**
356    * @dev Modifier to make a function callable only when the contract is not paused.
357    */
358   modifier whenNotPaused() {
359     require(!paused);
360     _;
361   }
362 
363   /**
364    * @dev Modifier to make a function callable only when the contract is paused.
365    */
366   modifier whenPaused() {
367     require(paused);
368     _;
369   }
370 
371   /**
372    * @dev called by the owner to pause, triggers stopped state
373    */
374   function pause() onlyOwner whenNotPaused public {
375     paused = true;
376     emit Pause();
377   }
378 
379   /**
380    * @dev called by the owner to unpause, returns to normal state
381    */
382   function unpause() onlyOwner whenPaused public {
383     paused = false;
384     emit Unpause();
385   }
386 }
387 
388 /**
389  * @title Pausable token
390  * @dev StandardToken modified with pausable transfers.
391  **/
392 contract PausableToken is StandardToken, Pausable {
393 
394   function transfer(
395     address _to,
396     uint256 _value
397   )
398     public
399     whenNotPaused
400     returns (bool)
401   {
402     return super.transfer(_to, _value);
403   }
404 
405   function transferFrom(
406     address _from,
407     address _to,
408     uint256 _value
409   )
410     public
411     whenNotPaused
412     returns (bool)
413   {
414     return super.transferFrom(_from, _to, _value);
415   }
416 
417   function approve(
418     address _spender,
419     uint256 _value
420   )
421     public
422     whenNotPaused
423     returns (bool)
424   {
425     return super.approve(_spender, _value);
426   }
427 
428   function increaseApproval(
429     address _spender,
430     uint _addedValue
431   )
432     public
433     whenNotPaused
434     returns (bool success)
435   {
436     return super.increaseApproval(_spender, _addedValue);
437   }
438 
439   function decreaseApproval(
440     address _spender,
441     uint _subtractedValue
442   )
443     public
444     whenNotPaused
445     returns (bool success)
446   {
447     return super.decreaseApproval(_spender, _subtractedValue);
448   }
449 }
450 
451 /**
452  * @title EWToken
453  */
454 contract EWToken is PausableToken {
455 
456   string public constant name = "EastWind"; 
457   string public constant symbol = "EWT1"; 
458   uint8 public constant decimals = 3; 
459 
460   uint256 public constant INITIAL_SUPPLY = 20000 * (10 ** uint256(decimals));
461 
462   /**
463    * @dev Constructor that gives msg.sender all of existing tokens.
464    */
465   constructor()  public {
466     totalSupply_ = INITIAL_SUPPLY;
467     balances[msg.sender] = INITIAL_SUPPLY;
468     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
469   }
470 
471 }