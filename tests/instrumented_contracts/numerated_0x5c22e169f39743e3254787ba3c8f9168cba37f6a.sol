1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 
81 
82 
83 
84 /**
85  * @title SafeMath
86  * @dev Math operations with safety checks that throw on error
87  */
88 library SafeMath {
89 
90   /**
91   * @dev Multiplies two numbers, throws on overflow.
92   */
93   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
94     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
95     // benefit is lost if 'b' is also tested.
96     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
97     if (a == 0) {
98       return 0;
99     }
100 
101     c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     // uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return a / b;
114   }
115 
116   /**
117   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
128     c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 }
133 
134 
135 
136 
137 
138 
139 
140 
141 
142 
143 
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   uint256 totalSupply_;
155 
156   /**
157   * @dev Total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev Transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(_to != address(0));
170     require(_value <= balances[msg.sender]);
171 
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     emit Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner) public view returns (uint256) {
184     return balances[_owner];
185   }
186 
187 }
188 
189 
190 
191 
192 
193 
194 /**
195  * @title ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/20
197  */
198 contract ERC20 is ERC20Basic {
199   function allowance(address owner, address spender)
200     public view returns (uint256);
201 
202   function transferFrom(address from, address to, uint256 value)
203     public returns (bool);
204 
205   function approve(address spender, uint256 value) public returns (bool);
206   event Approval(
207     address indexed owner,
208     address indexed spender,
209     uint256 value
210   );
211 }
212 
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * @dev https://github.com/ethereum/EIPs/issues/20
219  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param _from address The address which you want to send tokens from
229    * @param _to address The address which you want to transfer to
230    * @param _value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(
233     address _from,
234     address _to,
235     uint256 _value
236   )
237     public
238     returns (bool)
239   {
240     require(_to != address(0));
241     require(_value <= balances[_from]);
242     require(_value <= allowed[_from][msg.sender]);
243 
244     balances[_from] = balances[_from].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
247     emit Transfer(_from, _to, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253    *
254    * Beware that changing an allowance with this method brings the risk that someone may use both the old
255    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
256    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
257    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258    * @param _spender The address which will spend the funds.
259    * @param _value The amount of tokens to be spent.
260    */
261   function approve(address _spender, uint256 _value) public returns (bool) {
262     allowed[msg.sender][_spender] = _value;
263     emit Approval(msg.sender, _spender, _value);
264     return true;
265   }
266 
267   /**
268    * @dev Function to check the amount of tokens that an owner allowed to a spender.
269    * @param _owner address The address which owns the funds.
270    * @param _spender address The address which will spend the funds.
271    * @return A uint256 specifying the amount of tokens still available for the spender.
272    */
273   function allowance(
274     address _owner,
275     address _spender
276    )
277     public
278     view
279     returns (uint256)
280   {
281     return allowed[_owner][_spender];
282   }
283 
284   /**
285    * @dev Increase the amount of tokens that an owner allowed to a spender.
286    *
287    * approve should be called when allowed[_spender] == 0. To increment
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    * @param _spender The address which will spend the funds.
292    * @param _addedValue The amount of tokens to increase the allowance by.
293    */
294   function increaseApproval(
295     address _spender,
296     uint _addedValue
297   )
298     public
299     returns (bool)
300   {
301     allowed[msg.sender][_spender] = (
302       allowed[msg.sender][_spender].add(_addedValue));
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307   /**
308    * @dev Decrease the amount of tokens that an owner allowed to a spender.
309    *
310    * approve should be called when allowed[_spender] == 0. To decrement
311    * allowed value is better to use this function to avoid 2 calls (and wait until
312    * the first transaction is mined)
313    * From MonolithDAO Token.sol
314    * @param _spender The address which will spend the funds.
315    * @param _subtractedValue The amount of tokens to decrease the allowance by.
316    */
317   function decreaseApproval(
318     address _spender,
319     uint _subtractedValue
320   )
321     public
322     returns (bool)
323   {
324     uint oldValue = allowed[msg.sender][_spender];
325     if (_subtractedValue > oldValue) {
326       allowed[msg.sender][_spender] = 0;
327     } else {
328       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
329     }
330     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
331     return true;
332   }
333 
334 }
335 
336 
337 
338 
339 
340 
341 
342 /**
343  * @title Pausable
344  * @dev Base contract which allows children to implement an emergency stop mechanism.
345  */
346 contract Pausable is Ownable {
347   event Pause();
348   event Unpause();
349 
350   bool public paused = false;
351 
352 
353   /**
354    * @dev Modifier to make a function callable only when the contract is not paused.
355    */
356   modifier whenNotPaused() {
357     require(!paused);
358     _;
359   }
360 
361   /**
362    * @dev Modifier to make a function callable only when the contract is paused.
363    */
364   modifier whenPaused() {
365     require(paused);
366     _;
367   }
368 
369   /**
370    * @dev called by the owner to pause, triggers stopped state
371    */
372   function pause() onlyOwner whenNotPaused public {
373     paused = true;
374     emit Pause();
375   }
376 
377   /**
378    * @dev called by the owner to unpause, returns to normal state
379    */
380   function unpause() onlyOwner whenPaused public {
381     paused = false;
382     emit Unpause();
383   }
384 }
385 
386 
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
451 
452 /**
453 * ERC20 compliant token for IndieOn ICO crowdfunding.
454 * Inital total supply is 1 billion token
455 */
456 contract IndieToken is PausableToken {
457 
458   string public constant name = "indieOn Token";
459   string public constant symbol = "NDI";
460   uint8 public constant decimals = 18;
461 
462   using SafeMath for uint256;
463   uint256 public constant TOTAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
464   uint256 public constant icoTokenAmount = 292222222 * (10 ** uint256(decimals));
465 
466   /**
467    * @dev Constructor that gives msg.sender all of existing tokens.
468    */
469   constructor() public {
470     totalSupply_ = TOTAL_SUPPLY;
471     balances[msg.sender] = TOTAL_SUPPLY;
472     emit Transfer(0x0, msg.sender, TOTAL_SUPPLY);
473   }
474 }