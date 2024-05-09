1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipRenounced(address indexed previousOwner);
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to relinquish control of the contract.
36    * @notice Renouncing to ownership will leave the contract without an owner.
37    * It will not be possible to call the functions with the `onlyOwner`
38    * modifier anymore.
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
110 /**
111  * @title SafeMath
112  * @dev Math operations with safety checks that throw on error
113  */
114 library SafeMath {
115 
116   /**
117   * @dev Multiplies two numbers, throws on overflow.
118   */
119   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
120     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
121     // benefit is lost if 'b' is also tested.
122     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
123     if (a == 0) {
124       return 0;
125     }
126 
127     c = a * b;
128     assert(c / a == b);
129     return c;
130   }
131 
132   /**
133   * @dev Integer division of two numbers, truncating the quotient.
134   */
135   function div(uint256 a, uint256 b) internal pure returns (uint256) {
136     // assert(b > 0); // Solidity automatically throws when dividing by 0
137     // uint256 c = a / b;
138     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139     return a / b;
140   }
141 
142   /**
143   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
144   */
145   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146     assert(b <= a);
147     return a - b;
148   }
149 
150   /**
151   * @dev Adds two numbers, throws on overflow.
152   */
153   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
154     c = a + b;
155     assert(c >= a);
156     return c;
157   }
158 }
159 
160 
161 /**
162  * @title ERC20Basic
163  * @dev Simpler version of ERC20 interface
164  * See https://github.com/ethereum/EIPs/issues/179
165  */
166 contract ERC20Basic {
167   function totalSupply() public view returns (uint256);
168   function balanceOf(address who) public view returns (uint256);
169   function transfer(address to, uint256 value) public returns (bool);
170   event Transfer(address indexed from, address indexed to, uint256 value);
171 }
172 
173 
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179   function allowance(address owner, address spender)
180     public view returns (uint256);
181 
182   function transferFrom(address from, address to, uint256 value)
183     public returns (bool);
184 
185   function approve(address spender, uint256 value) public returns (bool);
186   event Approval(
187     address indexed owner,
188     address indexed spender,
189     uint256 value
190   );
191 }
192 
193 /**
194  * @title Basic token
195  * @dev Basic version of StandardToken, with no allowances.
196  */
197 contract BasicToken is ERC20Basic {
198   using SafeMath for uint256;
199 
200   mapping(address => uint256) balances;
201 
202   uint256 totalSupply_;
203 
204   /**
205   * @dev Total number of tokens in existence
206   */
207   function totalSupply() public view returns (uint256) {
208     return totalSupply_;
209   }
210 
211   /**
212   * @dev Transfer token for a specified address
213   * @param _to The address to transfer to.
214   * @param _value The amount to be transferred.
215   */
216   function transfer(address _to, uint256 _value) public returns (bool) {
217     require(_to != address(0));
218     require(_value <= balances[msg.sender]);
219 
220     balances[msg.sender] = balances[msg.sender].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     emit Transfer(msg.sender, _to, _value);
223     return true;
224   }
225 
226   /**
227   * @dev Gets the balance of the specified address.
228   * @param _owner The address to query the the balance of.
229   * @return An uint256 representing the amount owned by the passed address.
230   */
231   function balanceOf(address _owner) public view returns (uint256) {
232     return balances[_owner];
233   }
234 
235 }
236 
237 /**
238  * @title Standard ERC20 token
239  *
240  * @dev Implementation of the basic standard token.
241  * https://github.com/ethereum/EIPs/issues/20
242  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
243  */
244 contract StandardToken is ERC20, BasicToken {
245 
246   mapping (address => mapping (address => uint256)) internal allowed;
247 
248   /**
249    * @dev Transfer tokens from one address to another
250    * @param _from address The address which you want to send tokens from
251    * @param _to address The address which you want to transfer to
252    * @param _value uint256 the amount of tokens to be transferred
253    */
254   function transferFrom(
255     address _from,
256     address _to,
257     uint256 _value
258   )
259     public
260     returns (bool)
261   {
262     require(_to != address(0));
263     require(_value <= balances[_from]);
264     require(_value <= allowed[_from][msg.sender]);
265 
266     balances[_from] = balances[_from].sub(_value);
267     balances[_to] = balances[_to].add(_value);
268     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
269     emit Transfer(_from, _to, _value);
270     return true;
271   }
272 
273   /**
274    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
275    * Beware that changing an allowance with this method brings the risk that someone may use both the old
276    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
277    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
278    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279    * @param _spender The address which will spend the funds.
280    * @param _value The amount of tokens to be spent.
281    */
282   function approve(address _spender, uint256 _value) public returns (bool) {
283     allowed[msg.sender][_spender] = _value;
284     emit Approval(msg.sender, _spender, _value);
285     return true;
286   }
287 
288   /**
289    * @dev Function to check the amount of tokens that an owner allowed to a spender.
290    * @param _owner address The address which owns the funds.
291    * @param _spender address The address which will spend the funds.
292    * @return A uint256 specifying the amount of tokens still available for the spender.
293    */
294   function allowance(
295     address _owner,
296     address _spender
297    )
298     public
299     view
300     returns (uint256)
301   {
302     return allowed[_owner][_spender];
303   }
304 
305   /**
306    * @dev Increase the amount of tokens that an owner allowed to a spender.
307    * approve should be called when allowed[_spender] == 0. To increment
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _addedValue The amount of tokens to increase the allowance by.
313    */
314   function increaseApproval(
315     address _spender,
316     uint256 _addedValue
317   )
318     public
319     returns (bool)
320   {
321     allowed[msg.sender][_spender] = (
322       allowed[msg.sender][_spender].add(_addedValue));
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327   /**
328    * @dev Decrease the amount of tokens that an owner allowed to a spender.
329    * approve should be called when allowed[_spender] == 0. To decrement
330    * allowed value is better to use this function to avoid 2 calls (and wait until
331    * the first transaction is mined)
332    * From MonolithDAO Token.sol
333    * @param _spender The address which will spend the funds.
334    * @param _subtractedValue The amount of tokens to decrease the allowance by.
335    */
336   function decreaseApproval(
337     address _spender,
338     uint256 _subtractedValue
339   )
340     public
341     returns (bool)
342   {
343     uint256 oldValue = allowed[msg.sender][_spender];
344     if (_subtractedValue > oldValue) {
345       allowed[msg.sender][_spender] = 0;
346     } else {
347       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
348     }
349     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353 }
354 
355 
356 /**
357  * @title Pausable token
358  * @dev StandardToken modified with pausable transfers.
359  **/
360 contract PausableToken is StandardToken, Pausable {
361 
362   function transfer(
363     address _to,
364     uint256 _value
365   )
366     public
367     whenNotPaused
368     returns (bool)
369   {
370     return super.transfer(_to, _value);
371   }
372 
373   function transferFrom(
374     address _from,
375     address _to,
376     uint256 _value
377   )
378     public
379     whenNotPaused
380     returns (bool)
381   {
382     return super.transferFrom(_from, _to, _value);
383   }
384 
385   function approve(
386     address _spender,
387     uint256 _value
388   )
389     public
390     whenNotPaused
391     returns (bool)
392   {
393     return super.approve(_spender, _value);
394   }
395 
396   function increaseApproval(
397     address _spender,
398     uint _addedValue
399   )
400     public
401     whenNotPaused
402     returns (bool success)
403   {
404     return super.increaseApproval(_spender, _addedValue);
405   }
406 
407   function decreaseApproval(
408     address _spender,
409     uint _subtractedValue
410   )
411     public
412     whenNotPaused
413     returns (bool success)
414   {
415     return super.decreaseApproval(_spender, _subtractedValue);
416   }
417 }
418 
419 
420 contract LJToken is PausableToken {
421     string public name = "LJ Token";
422     string public symbol = "LJT";
423     uint256 public decimals = 18;
424 
425     constructor() public {
426         totalSupply_ = 100000000 * (10**decimals);
427         balances[msg.sender] = totalSupply_;
428     }
429 }