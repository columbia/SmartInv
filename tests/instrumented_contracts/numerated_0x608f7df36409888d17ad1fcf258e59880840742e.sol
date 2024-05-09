1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
65 
66 /**
67  * @title Pausable
68  * @dev Base contract which allows children to implement an emergency stop mechanism.
69  */
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73 
74   bool public paused = false;
75 
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is not paused.
79    */
80   modifier whenNotPaused() {
81     require(!paused);
82     _;
83   }
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is paused.
87    */
88   modifier whenPaused() {
89     require(paused);
90     _;
91   }
92 
93   /**
94    * @dev called by the owner to pause, triggers stopped state
95    */
96   function pause() onlyOwner whenNotPaused public {
97     paused = true;
98     emit Pause();
99   }
100 
101   /**
102    * @dev called by the owner to unpause, returns to normal state
103    */
104   function unpause() onlyOwner whenPaused public {
105     paused = false;
106     emit Unpause();
107   }
108 }
109 
110 // File: zeppelin-solidity/contracts/math/SafeMath.sol
111 
112 /**
113  * @title SafeMath
114  * @dev Math operations with safety checks that throw on error
115  */
116 library SafeMath {
117 
118   /**
119   * @dev Multiplies two numbers, throws on overflow.
120   */
121   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
122     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
123     // benefit is lost if 'b' is also tested.
124     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
125     if (a == 0) {
126       return 0;
127     }
128 
129     c = a * b;
130     assert(c / a == b);
131     return c;
132   }
133 
134   /**
135   * @dev Integer division of two numbers, truncating the quotient.
136   */
137   function div(uint256 a, uint256 b) internal pure returns (uint256) {
138     // assert(b > 0); // Solidity automatically throws when dividing by 0
139     // uint256 c = a / b;
140     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
141     return a / b;
142   }
143 
144   /**
145   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
146   */
147   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148     assert(b <= a);
149     return a - b;
150   }
151 
152   /**
153   * @dev Adds two numbers, throws on overflow.
154   */
155   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
156     c = a + b;
157     assert(c >= a);
158     return c;
159   }
160 }
161 
162 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
163 
164 /**
165  * @title ERC20Basic
166  * @dev Simpler version of ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/179
168  */
169 contract ERC20Basic {
170   function totalSupply() public view returns (uint256);
171   function balanceOf(address who) public view returns (uint256);
172   function transfer(address to, uint256 value) public returns (bool);
173   event Transfer(address indexed from, address indexed to, uint256 value);
174 }
175 
176 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
177 
178 /**
179  * @title Basic token
180  * @dev Basic version of StandardToken, with no allowances.
181  */
182 contract BasicToken is ERC20Basic {
183   using SafeMath for uint256;
184 
185   mapping(address => uint256) balances;
186 
187   uint256 totalSupply_;
188 
189   /**
190   * @dev total number of tokens in existence
191   */
192   function totalSupply() public view returns (uint256) {
193     return totalSupply_;
194   }
195 
196   /**
197   * @dev transfer token for a specified address
198   * @param _to The address to transfer to.
199   * @param _value The amount to be transferred.
200   */
201   function transfer(address _to, uint256 _value) public returns (bool) {
202     require(_to != address(0));
203     require(_value <= balances[msg.sender]);
204 
205     balances[msg.sender] = balances[msg.sender].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     emit Transfer(msg.sender, _to, _value);
208     return true;
209   }
210 
211   /**
212   * @dev Gets the balance of the specified address.
213   * @param _owner The address to query the the balance of.
214   * @return An uint256 representing the amount owned by the passed address.
215   */
216   function balanceOf(address _owner) public view returns (uint256) {
217     return balances[_owner];
218   }
219 
220 }
221 
222 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
223 
224 /**
225  * @title ERC20 interface
226  * @dev see https://github.com/ethereum/EIPs/issues/20
227  */
228 contract ERC20 is ERC20Basic {
229   function allowance(address owner, address spender)
230     public view returns (uint256);
231 
232   function transferFrom(address from, address to, uint256 value)
233     public returns (bool);
234 
235   function approve(address spender, uint256 value) public returns (bool);
236   event Approval(
237     address indexed owner,
238     address indexed spender,
239     uint256 value
240   );
241 }
242 
243 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
244 
245 /**
246  * @title Standard ERC20 token
247  *
248  * @dev Implementation of the basic standard token.
249  * @dev https://github.com/ethereum/EIPs/issues/20
250  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
251  */
252 contract StandardToken is ERC20, BasicToken {
253 
254   mapping (address => mapping (address => uint256)) internal allowed;
255 
256 
257   /**
258    * @dev Transfer tokens from one address to another
259    * @param _from address The address which you want to send tokens from
260    * @param _to address The address which you want to transfer to
261    * @param _value uint256 the amount of tokens to be transferred
262    */
263   function transferFrom(
264     address _from,
265     address _to,
266     uint256 _value
267   )
268     public
269     returns (bool)
270   {
271     require(_to != address(0));
272     require(_value <= balances[_from]);
273     require(_value <= allowed[_from][msg.sender]);
274 
275     balances[_from] = balances[_from].sub(_value);
276     balances[_to] = balances[_to].add(_value);
277     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
278     emit Transfer(_from, _to, _value);
279     return true;
280   }
281 
282   /**
283    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
284    *
285    * Beware that changing an allowance with this method brings the risk that someone may use both the old
286    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
287    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
288    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289    * @param _spender The address which will spend the funds.
290    * @param _value The amount of tokens to be spent.
291    */
292   function approve(address _spender, uint256 _value) public returns (bool) {
293     allowed[msg.sender][_spender] = _value;
294     emit Approval(msg.sender, _spender, _value);
295     return true;
296   }
297 
298   /**
299    * @dev Function to check the amount of tokens that an owner allowed to a spender.
300    * @param _owner address The address which owns the funds.
301    * @param _spender address The address which will spend the funds.
302    * @return A uint256 specifying the amount of tokens still available for the spender.
303    */
304   function allowance(
305     address _owner,
306     address _spender
307    )
308     public
309     view
310     returns (uint256)
311   {
312     return allowed[_owner][_spender];
313   }
314 
315   /**
316    * @dev Increase the amount of tokens that an owner allowed to a spender.
317    *
318    * approve should be called when allowed[_spender] == 0. To increment
319    * allowed value is better to use this function to avoid 2 calls (and wait until
320    * the first transaction is mined)
321    * From MonolithDAO Token.sol
322    * @param _spender The address which will spend the funds.
323    * @param _addedValue The amount of tokens to increase the allowance by.
324    */
325   function increaseApproval(
326     address _spender,
327     uint _addedValue
328   )
329     public
330     returns (bool)
331   {
332     allowed[msg.sender][_spender] = (
333       allowed[msg.sender][_spender].add(_addedValue));
334     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 
338   /**
339    * @dev Decrease the amount of tokens that an owner allowed to a spender.
340    *
341    * approve should be called when allowed[_spender] == 0. To decrement
342    * allowed value is better to use this function to avoid 2 calls (and wait until
343    * the first transaction is mined)
344    * From MonolithDAO Token.sol
345    * @param _spender The address which will spend the funds.
346    * @param _subtractedValue The amount of tokens to decrease the allowance by.
347    */
348   function decreaseApproval(
349     address _spender,
350     uint _subtractedValue
351   )
352     public
353     returns (bool)
354   {
355     uint oldValue = allowed[msg.sender][_spender];
356     if (_subtractedValue > oldValue) {
357       allowed[msg.sender][_spender] = 0;
358     } else {
359       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
360     }
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365 }
366 
367 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
368 
369 /**
370  * @title Pausable token
371  * @dev StandardToken modified with pausable transfers.
372  **/
373 contract PausableToken is StandardToken, Pausable {
374 
375   function transfer(
376     address _to,
377     uint256 _value
378   )
379     public
380     whenNotPaused
381     returns (bool)
382   {
383     return super.transfer(_to, _value);
384   }
385 
386   function transferFrom(
387     address _from,
388     address _to,
389     uint256 _value
390   )
391     public
392     whenNotPaused
393     returns (bool)
394   {
395     return super.transferFrom(_from, _to, _value);
396   }
397 
398   function approve(
399     address _spender,
400     uint256 _value
401   )
402     public
403     whenNotPaused
404     returns (bool)
405   {
406     return super.approve(_spender, _value);
407   }
408 
409   function increaseApproval(
410     address _spender,
411     uint _addedValue
412   )
413     public
414     whenNotPaused
415     returns (bool success)
416   {
417     return super.increaseApproval(_spender, _addedValue);
418   }
419 
420   function decreaseApproval(
421     address _spender,
422     uint _subtractedValue
423   )
424     public
425     whenNotPaused
426     returns (bool success)
427   {
428     return super.decreaseApproval(_spender, _subtractedValue);
429   }
430 }
431 
432 // File: contracts/FusFund.sol
433 
434 /**
435  * @title SimpleToken
436  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
437  * Note they can later distribute these tokens as they wish using `transfer` and other
438  * `StandardToken` functions.
439  */
440 contract FusFund is PausableToken {
441   string public constant name = "FusFund"; // solium-disable-line uppercase
442   string public constant symbol = "FUND"; // solium-disable-line uppercase
443   uint8 public constant decimals = 18; // solium-disable-line uppercase
444 
445   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
446 
447   /**
448    * @dev Constructor that gives msg.sender all of existing tokens.
449    */
450   constructor() public {
451     totalSupply_ = INITIAL_SUPPLY;
452     balances[msg.sender] = INITIAL_SUPPLY;
453     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
454   }
455 }