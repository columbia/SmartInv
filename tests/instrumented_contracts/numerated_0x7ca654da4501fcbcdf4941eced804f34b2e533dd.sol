1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 /**
68  * @title Pausable
69  * @dev Base contract which allows children to implement an emergency stop mechanism.
70  */
71 contract Pausable is Ownable {
72   event Pause();
73   event Unpause();
74 
75   bool public paused = false;
76 
77 
78   /**
79    * @dev Modifier to make a function callable only when the contract is not paused.
80    */
81   modifier whenNotPaused() {
82     require(!paused);
83     _;
84   }
85 
86   /**
87    * @dev Modifier to make a function callable only when the contract is paused.
88    */
89   modifier whenPaused() {
90     require(paused);
91     _;
92   }
93 
94   /**
95    * @dev called by the owner to pause, triggers stopped state
96    */
97   function pause() onlyOwner whenNotPaused public {
98     paused = true;
99     emit Pause();
100   }
101 
102   /**
103    * @dev called by the owner to unpause, returns to normal state
104    */
105   function unpause() onlyOwner whenPaused public {
106     paused = false;
107     emit Unpause();
108   }
109 }
110 
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
162 
163 /**
164  * @title ERC20Basic
165  * @dev Simpler version of ERC20 interface
166  * See https://github.com/ethereum/EIPs/issues/179
167  */
168 contract ERC20Basic {
169   function totalSupply() public view returns (uint256);
170   function balanceOf(address who) public view returns (uint256);
171   function transfer(address to, uint256 value) public returns (bool);
172   event Transfer(address indexed from, address indexed to, uint256 value);
173 }
174 
175 
176 /**
177  * @title Basic token
178  * @dev Basic version of StandardToken, with no allowances.
179  */
180 contract BasicToken is ERC20Basic {
181   using SafeMath for uint256;
182 
183   mapping(address => uint256) balances;
184 
185   uint256 totalSupply_;
186 
187   /**
188   * @dev Total number of tokens in existence
189   */
190   function totalSupply() public view returns (uint256) {
191     return totalSupply_;
192   }
193 
194   /**
195   * @dev Transfer token for a specified address
196   * @param _to The address to transfer to.
197   * @param _value The amount to be transferred.
198   */
199   function transfer(address _to, uint256 _value) public returns (bool) {
200     require(_to != address(0));
201     require(_value <= balances[msg.sender]);
202 
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     emit Transfer(msg.sender, _to, _value);
206     return true;
207   }
208 
209   /**
210   * @dev Gets the balance of the specified address.
211   * @param _owner The address to query the the balance of.
212   * @return An uint256 representing the amount owned by the passed address.
213   */
214   function balanceOf(address _owner) public view returns (uint256) {
215     return balances[_owner];
216   }
217 
218 }
219 
220 
221 /**
222  * @title ERC20 interface
223  * @dev see https://github.com/ethereum/EIPs/issues/20
224  */
225 contract ERC20 is ERC20Basic {
226   function allowance(address owner, address spender)
227     public view returns (uint256);
228 
229   function transferFrom(address from, address to, uint256 value)
230     public returns (bool);
231 
232   function approve(address spender, uint256 value) public returns (bool);
233   event Approval(
234     address indexed owner,
235     address indexed spender,
236     uint256 value
237   );
238 }
239 
240 
241 /**
242  * @title Standard ERC20 token
243  *
244  * @dev Implementation of the basic standard token.
245  * https://github.com/ethereum/EIPs/issues/20
246  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
247  */
248 contract StandardToken is ERC20, BasicToken {
249 
250   mapping (address => mapping (address => uint256)) internal allowed;
251 
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(
260     address _from,
261     address _to,
262     uint256 _value
263   )
264     public
265     returns (bool)
266   {
267     require(_to != address(0));
268     require(_value <= balances[_from]);
269     require(_value <= allowed[_from][msg.sender]);
270 
271     balances[_from] = balances[_from].sub(_value);
272     balances[_to] = balances[_to].add(_value);
273     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
274     emit Transfer(_from, _to, _value);
275     return true;
276   }
277 
278   /**
279    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
280    * Beware that changing an allowance with this method brings the risk that someone may use both the old
281    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
282    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
283    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284    * @param _spender The address which will spend the funds.
285    * @param _value The amount of tokens to be spent.
286    */
287   function approve(address _spender, uint256 _value) public returns (bool) {
288     allowed[msg.sender][_spender] = _value;
289     emit Approval(msg.sender, _spender, _value);
290     return true;
291   }
292 
293   /**
294    * @dev Function to check the amount of tokens that an owner allowed to a spender.
295    * @param _owner address The address which owns the funds.
296    * @param _spender address The address which will spend the funds.
297    * @return A uint256 specifying the amount of tokens still available for the spender.
298    */
299   function allowance(
300     address _owner,
301     address _spender
302    )
303     public
304     view
305     returns (uint256)
306   {
307     return allowed[_owner][_spender];
308   }
309 
310   /**
311    * @dev Increase the amount of tokens that an owner allowed to a spender.
312    * approve should be called when allowed[_spender] == 0. To increment
313    * allowed value is better to use this function to avoid 2 calls (and wait until
314    * the first transaction is mined)
315    * From MonolithDAO Token.sol
316    * @param _spender The address which will spend the funds.
317    * @param _addedValue The amount of tokens to increase the allowance by.
318    */
319   function increaseApproval(
320     address _spender,
321     uint256 _addedValue
322   )
323     public
324     returns (bool)
325   {
326     allowed[msg.sender][_spender] = (
327       allowed[msg.sender][_spender].add(_addedValue));
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332   /**
333    * @dev Decrease the amount of tokens that an owner allowed to a spender.
334    * approve should be called when allowed[_spender] == 0. To decrement
335    * allowed value is better to use this function to avoid 2 calls (and wait until
336    * the first transaction is mined)
337    * From MonolithDAO Token.sol
338    * @param _spender The address which will spend the funds.
339    * @param _subtractedValue The amount of tokens to decrease the allowance by.
340    */
341   function decreaseApproval(
342     address _spender,
343     uint256 _subtractedValue
344   )
345     public
346     returns (bool)
347   {
348     uint256 oldValue = allowed[msg.sender][_spender];
349     if (_subtractedValue > oldValue) {
350       allowed[msg.sender][_spender] = 0;
351     } else {
352       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
353     }
354     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
355     return true;
356   }
357 
358 }
359 
360 
361 /**
362  * @title Pausable token
363  * @dev StandardToken modified with pausable transfers.
364  **/
365 contract PausableToken is StandardToken, Pausable {
366 
367   function transfer(
368     address _to,
369     uint256 _value
370   )
371     public
372     whenNotPaused
373     returns (bool)
374   {
375     return super.transfer(_to, _value);
376   }
377 
378   function transferFrom(
379     address _from,
380     address _to,
381     uint256 _value
382   )
383     public
384     whenNotPaused
385     returns (bool)
386   {
387     return super.transferFrom(_from, _to, _value);
388   }
389 
390   function approve(
391     address _spender,
392     uint256 _value
393   )
394     public
395     whenNotPaused
396     returns (bool)
397   {
398     return super.approve(_spender, _value);
399   }
400 
401   function increaseApproval(
402     address _spender,
403     uint _addedValue
404   )
405     public
406     whenNotPaused
407     returns (bool success)
408   {
409     return super.increaseApproval(_spender, _addedValue);
410   }
411 
412   function decreaseApproval(
413     address _spender,
414     uint _subtractedValue
415   )
416     public
417     whenNotPaused
418     returns (bool success)
419   {
420     return super.decreaseApproval(_spender, _subtractedValue);
421   }
422 }
423 
424 // File: contracts/MGtoken.sol
425 
426 contract MGtoken is PausableToken {
427 
428   string public constant name = "MGtoken";
429   string public constant symbol = "MG";
430   uint8 public constant decimals = 18;
431   uint256 public constant INITIAL_SUPPLY = 1e9 * 10**uint256(decimals);
432 
433   constructor() {
434     totalSupply_ = INITIAL_SUPPLY;
435     balances[msg.sender] = INITIAL_SUPPLY;
436     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
437   }
438 }