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
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
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
165  * See https://github.com/ethereum/EIPs/issues/179
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
176  * @title ERC20 interface
177  * @dev see https://github.com/ethereum/EIPs/issues/20
178  */
179 contract ERC20 is ERC20Basic {
180   function allowance(address owner, address spender)
181     public view returns (uint256);
182 
183   function transferFrom(address from, address to, uint256 value)
184     public returns (bool);
185 
186   function approve(address spender, uint256 value) public returns (bool);
187   event Approval(
188     address indexed owner,
189     address indexed spender,
190     uint256 value
191   );
192 }
193 
194 /**
195  * @title Basic token
196  * @dev Basic version of StandardToken, with no allowances.
197  */
198 contract BasicToken is ERC20Basic {
199   using SafeMath for uint256;
200 
201   mapping(address => uint256) balances;
202 
203   uint256 totalSupply_;
204 
205   /**
206   * @dev Total number of tokens in existence
207   */
208   function totalSupply() public view returns (uint256) {
209     return totalSupply_;
210   }
211 
212   /**
213   * @dev Transfer token for a specified address
214   * @param _to The address to transfer to.
215   * @param _value The amount to be transferred.
216   */
217   function transfer(address _to, uint256 _value) public returns (bool) {
218     require(_to != address(0));
219     require(_value <= balances[msg.sender]);
220 
221     balances[msg.sender] = balances[msg.sender].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     emit Transfer(msg.sender, _to, _value);
224     return true;
225   }
226 
227   /**
228   * @dev Gets the balance of the specified address.
229   * @param _owner The address to query the the balance of.
230   * @return An uint256 representing the amount owned by the passed address.
231   */
232   function balanceOf(address _owner) public view returns (uint256) {
233     return balances[_owner];
234   }
235 
236 }
237 
238 
239 /**
240  * @title Standard ERC20 token
241  *
242  * @dev Implementation of the basic standard token.
243  * https://github.com/ethereum/EIPs/issues/20
244  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
245  */
246 contract StandardToken is ERC20, BasicToken {
247 
248   mapping (address => mapping (address => uint256)) internal allowed;
249 
250 
251   /**
252    * @dev Transfer tokens from one address to another
253    * @param _from address The address which you want to send tokens from
254    * @param _to address The address which you want to transfer to
255    * @param _value uint256 the amount of tokens to be transferred
256    */
257   function transferFrom(
258     address _from,
259     address _to,
260     uint256 _value
261   )
262     public
263     returns (bool)
264   {
265     require(_to != address(0));
266     require(_value <= balances[_from]);
267     require(_value <= allowed[_from][msg.sender]);
268 
269     balances[_from] = balances[_from].sub(_value);
270     balances[_to] = balances[_to].add(_value);
271     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
272     emit Transfer(_from, _to, _value);
273     return true;
274   }
275 
276   /**
277    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
278    * Beware that changing an allowance with this method brings the risk that someone may use both the old
279    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
280    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
281    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282    * @param _spender The address which will spend the funds.
283    * @param _value The amount of tokens to be spent.
284    */
285   function approve(address _spender, uint256 _value) public returns (bool) {
286     allowed[msg.sender][_spender] = _value;
287     emit Approval(msg.sender, _spender, _value);
288     return true;
289   }
290 
291   /**
292    * @dev Function to check the amount of tokens that an owner allowed to a spender.
293    * @param _owner address The address which owns the funds.
294    * @param _spender address The address which will spend the funds.
295    * @return A uint256 specifying the amount of tokens still available for the spender.
296    */
297   function allowance(
298     address _owner,
299     address _spender
300    )
301     public
302     view
303     returns (uint256)
304   {
305     return allowed[_owner][_spender];
306   }
307 
308   /**
309    * @dev Increase the amount of tokens that an owner allowed to a spender.
310    * approve should be called when allowed[_spender] == 0. To increment
311    * allowed value is better to use this function to avoid 2 calls (and wait until
312    * the first transaction is mined)
313    * From MonolithDAO Token.sol
314    * @param _spender The address which will spend the funds.
315    * @param _addedValue The amount of tokens to increase the allowance by.
316    */
317   function increaseApproval(
318     address _spender,
319     uint256 _addedValue
320   )
321     public
322     returns (bool)
323   {
324     allowed[msg.sender][_spender] = (
325       allowed[msg.sender][_spender].add(_addedValue));
326     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
327     return true;
328   }
329 
330   /**
331    * @dev Decrease the amount of tokens that an owner allowed to a spender.
332    * approve should be called when allowed[_spender] == 0. To decrement
333    * allowed value is better to use this function to avoid 2 calls (and wait until
334    * the first transaction is mined)
335    * From MonolithDAO Token.sol
336    * @param _spender The address which will spend the funds.
337    * @param _subtractedValue The amount of tokens to decrease the allowance by.
338    */
339   function decreaseApproval(
340     address _spender,
341     uint256 _subtractedValue
342   )
343     public
344     returns (bool)
345   {
346     uint256 oldValue = allowed[msg.sender][_spender];
347     if (_subtractedValue > oldValue) {
348       allowed[msg.sender][_spender] = 0;
349     } else {
350       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
351     }
352     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
353     return true;
354   }
355 
356 }
357 
358 
359 /**
360  * @title Pausable token
361  * @dev StandardToken modified with pausable transfers.
362  **/
363 contract PausableToken is StandardToken, Pausable {
364 
365   function transfer(
366     address _to,
367     uint256 _value
368   )
369     public
370     whenNotPaused
371     returns (bool)
372   {
373     return super.transfer(_to, _value);
374   }
375 
376   function transferFrom(
377     address _from,
378     address _to,
379     uint256 _value
380   )
381     public
382     whenNotPaused
383     returns (bool)
384   {
385     return super.transferFrom(_from, _to, _value);
386   }
387 
388   function approve(
389     address _spender,
390     uint256 _value
391   )
392     public
393     whenNotPaused
394     returns (bool)
395   {
396     return super.approve(_spender, _value);
397   }
398 
399   function increaseApproval(
400     address _spender,
401     uint _addedValue
402   )
403     public
404     whenNotPaused
405     returns (bool success)
406   {
407     return super.increaseApproval(_spender, _addedValue);
408   }
409 
410   function decreaseApproval(
411     address _spender,
412     uint _subtractedValue
413   )
414     public
415     whenNotPaused
416     returns (bool success)
417   {
418     return super.decreaseApproval(_spender, _subtractedValue);
419   }
420 }
421 
422 
423 contract HrcToken is PausableToken {
424     string public name = "HRC Token";
425     string public symbol = "HRC";
426     uint256 public decimals = 18;
427     
428     constructor() public {
429         totalSupply_ = 1000000000 * (10**decimals);
430         balances[msg.sender] = totalSupply_;
431     }
432     
433 }