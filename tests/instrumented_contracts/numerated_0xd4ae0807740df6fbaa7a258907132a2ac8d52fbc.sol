1 pragma solidity ^0.4.23;
2 
3 
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
64 
65 /**
66  * @title Pausable
67  * @dev Base contract which allows children to implement an emergency stop mechanism.
68  */
69 contract Pausable is Ownable {
70   event Pause();
71   event Unpause();
72 
73   bool public paused = false;
74 
75 
76   /**
77    * @dev Modifier to make a function callable only when the contract is not paused.
78    */
79   modifier whenNotPaused() {
80     require(!paused);
81     _;
82   }
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is paused.
86    */
87   modifier whenPaused() {
88     require(paused);
89     _;
90   }
91 
92   /**
93    * @dev called by the owner to pause, triggers stopped state
94    */
95   function pause() onlyOwner whenNotPaused public {
96     paused = true;
97     emit Pause();
98   }
99 
100   /**
101    * @dev called by the owner to unpause, returns to normal state
102    */
103   function unpause() onlyOwner whenPaused public {
104     paused = false;
105     emit Unpause();
106   }
107 }
108 
109 
110 
111 /**
112  * @title SafeMath
113  * @dev Math operations with safety checks that throw on error
114  */
115 library SafeMath {
116 
117   /**
118   * @dev Multiplies two numbers, throws on overflow.
119   */
120   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
121     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
122     // benefit is lost if 'b' is also tested.
123     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
124     if (a == 0) {
125       return 0;
126     }
127 
128     c = a * b;
129     assert(c / a == b);
130     return c;
131   }
132 
133   /**
134   * @dev Integer division of two numbers, truncating the quotient.
135   */
136   function div(uint256 a, uint256 b) internal pure returns (uint256) {
137     // assert(b > 0); // Solidity automatically throws when dividing by 0
138     // uint256 c = a / b;
139     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
140     return a / b;
141   }
142 
143   /**
144   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
145   */
146   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147     assert(b <= a);
148     return a - b;
149   }
150 
151   /**
152   * @dev Adds two numbers, throws on overflow.
153   */
154   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
155     c = a + b;
156     assert(c >= a);
157     return c;
158   }
159 }
160 
161 
162 /**
163  * @title ERC20Basic
164  * @dev Simpler version of ERC20 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/179
166  */
167 contract ERC20Basic {
168   function totalSupply() public view returns (uint256);
169   function balanceOf(address who) public view returns (uint256);
170   function transfer(address to, uint256 value) public returns (bool);
171   event Transfer(address indexed from, address indexed to, uint256 value);
172 }
173 
174 
175 /**
176  * @title Basic token
177  * @dev Basic version of StandardToken, with no allowances.
178  */
179 contract BasicToken is ERC20Basic {
180   using SafeMath for uint256;
181 
182   mapping(address => uint256) balances;
183 
184   uint256 totalSupply_;
185 
186   /**
187   * @dev Total number of tokens in existence
188   */
189   function totalSupply() public view returns (uint256) {
190     return totalSupply_;
191   }
192 
193   /**
194   * @dev Transfer token for a specified address
195   * @param _to The address to transfer to.
196   * @param _value The amount to be transferred.
197   */
198   function transfer(address _to, uint256 _value) public returns (bool) {
199     require(_to != address(0));
200     require(_value <= balances[msg.sender]);
201 
202     balances[msg.sender] = balances[msg.sender].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     emit Transfer(msg.sender, _to, _value);
205     return true;
206   }
207 
208   /**
209   * @dev Gets the balance of the specified address.
210   * @param _owner The address to query the the balance of.
211   * @return An uint256 representing the amount owned by the passed address.
212   */
213   function balanceOf(address _owner) public view returns (uint256) {
214     return balances[_owner];
215   }
216 
217 }
218 
219 
220 /**
221  * @title ERC20 interface
222  * @dev see https://github.com/ethereum/EIPs/issues/20
223  */
224 contract ERC20 is ERC20Basic {
225   function allowance(address owner, address spender)
226     public view returns (uint256);
227 
228   function transferFrom(address from, address to, uint256 value)
229     public returns (bool);
230 
231   function approve(address spender, uint256 value) public returns (bool);
232   event Approval(
233     address indexed owner,
234     address indexed spender,
235     uint256 value
236   );
237   
238   function () public payable {
239          revert();
240      }
241 }
242 
243 /**
244  * @title Standard ERC20 token
245  *
246  * @dev Implementation of the basic standard token.
247  * @dev https://github.com/ethereum/EIPs/issues/20
248  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
249  */
250 contract StandardToken is ERC20, BasicToken {
251 
252   mapping (address => mapping (address => uint256)) internal allowed;
253 
254 
255   /**
256    * @dev Transfer tokens from one address to another
257    * @param _from address The address which you want to send tokens from
258    * @param _to address The address which you want to transfer to
259    * @param _value uint256 the amount of tokens to be transferred
260    */
261   function transferFrom(
262     address _from,
263     address _to,
264     uint256 _value
265   )
266     public 
267 
268     returns (bool)
269   {
270     require(_to != address(0));
271     require(_value <= balances[_from]);
272     require(_value <= allowed[_from][msg.sender]);
273 
274     balances[_from] = balances[_from].sub(_value);
275     balances[_to] = balances[_to].add(_value);
276     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
277     emit Transfer(_from, _to, _value);
278     return true;
279   }
280 
281   /**
282    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
283    *
284    * Beware that changing an allowance with this method brings the risk that someone may use both the old
285    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
286    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
287    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288    * @param _spender The address which will spend the funds.
289    * @param _value The amount of tokens to be spent.
290    */
291   function approve(address _spender, uint256 _value) public returns (bool) {
292     allowed[msg.sender][_spender] = _value;
293     emit Approval(msg.sender, _spender, _value);
294     return true;
295   }
296 
297   /**
298    * @dev Function to check the amount of tokens that an owner allowed to a spender.
299    * @param _owner address The address which owns the funds.
300    * @param _spender address The address which will spend the funds.
301    * @return A uint256 specifying the amount of tokens still available for the spender.
302    */
303   function allowance(
304     address _owner,
305     address _spender
306    )
307     public
308     view
309     returns (uint256)
310   {
311     return allowed[_owner][_spender];
312   }
313 
314   /**
315    * @dev Increase the amount of tokens that an owner allowed to a spender.
316    *
317    * approve should be called when allowed[_spender] == 0. To increment
318    * allowed value is better to use this function to avoid 2 calls (and wait until
319    * the first transaction is mined)
320    * From MonolithDAO Token.sol
321    * @param _spender The address which will spend the funds.
322    * @param _addedValue The amount of tokens to increase the allowance by.
323    */
324   function increaseApproval(
325     address _spender,
326     uint _addedValue
327   )
328     public
329     returns (bool)
330   {
331     allowed[msg.sender][_spender] = (
332       allowed[msg.sender][_spender].add(_addedValue));
333     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
334     return true;
335   }
336 
337   /**
338    * @dev Decrease the amount of tokens that an owner allowed to a spender.
339    *
340    * approve should be called when allowed[_spender] == 0. To decrement
341    * allowed value is better to use this function to avoid 2 calls (and wait until
342    * the first transaction is mined)
343    * From MonolithDAO Token.sol
344    * @param _spender The address which will spend the funds.
345    * @param _subtractedValue The amount of tokens to decrease the allowance by.
346    */
347   function decreaseApproval(
348     address _spender,
349     uint _subtractedValue
350   )
351     public
352     returns (bool)
353   {
354     uint oldValue = allowed[msg.sender][_spender];
355     if (_subtractedValue > oldValue) {
356       allowed[msg.sender][_spender] = 0;
357     } else {
358       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
359     }
360     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361     return true;
362   }
363 
364 }
365 
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
431  * @title SimpleToken
432  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
433  * Note they can later distribute these tokens as they wish using `transfer` and other
434  * `StandardToken` functions.
435  */
436 contract KEOSToken is StandardToken, PausableToken {
437 
438   string public constant name = "KEOSToken"; // solium-disable-line uppercase
439   string public constant symbol = "KEOS"; // solium-disable-line uppercase
440   uint8 public constant decimals = 18; // solium-disable-line uppercase
441 
442   uint256 public constant INITIAL_SUPPLY = 1500000000 * (10 ** uint256(decimals));
443 
444   /**
445    * @dev Constructor that gives msg.sender all of existing tokens.
446    */
447   constructor() public {
448     totalSupply_ = INITIAL_SUPPLY;
449     balances[msg.sender] = INITIAL_SUPPLY;
450     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
451   }
452 
453 }