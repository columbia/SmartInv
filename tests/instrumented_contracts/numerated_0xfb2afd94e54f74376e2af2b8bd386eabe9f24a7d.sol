1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'TEST Poolin Miner Token' token contract
5 //
6 // Symbol      : TEST-POOLIN / PIN
7 // Name        : TEST Poolin Miner Token
8 // Total supply: 2100000000
9 // Decimals    : 6
10 //
11 // (c) poolin.com, 2018-07
12 // ----------------------------------------------------------------------------
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  *
18  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
27     // benefit is lost if 'b' is also tested.
28     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29     if (a == 0) {
30       return 0;
31     }
32 
33     c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   /**
39   * @dev Integer division of two numbers, truncating the quotient.
40   */
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     // uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return a / b;
46   }
47 
48   /**
49   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50   */
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   /**
57   * @dev Adds two numbers, throws on overflow.
58   */
59   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
60     c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
66 
67 /**
68  * @title ERC20Basic
69  * @dev Simpler version of ERC20 interface
70  * See https://github.com/ethereum/EIPs/issues/179
71  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
72  */
73 contract ERC20Basic {
74   function totalSupply()                          public view returns (uint256);
75   function balanceOf  (address who)               public view returns (uint256);
76   function transfer   (address to, uint256 value) public returns (bool);
77 
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
85  */
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) balances;
90 
91   uint256 totalSupply_;
92 
93   /**
94   * @dev Total number of tokens in existence
95   */
96   function totalSupply() public view returns (uint256) {
97     return totalSupply_;
98   }
99 
100   /**
101   * @dev Transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105   function transfer(address _to, uint256 _value) public returns (bool) {
106     //require(_to    != address(0));
107     require(_value <= balances[msg.sender]);
108 
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to]        = balances[_to].add(_value);
111     emit Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) public view returns (uint256) {
121     return balances[_owner];
122   }
123 }
124 
125 /**
126  * @title ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/20
128  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance   (address owner,  address spender)           public view returns (uint256);
132   function transferFrom(address from,   address to, uint256 value) public returns (bool);
133   function approve     (address spender, uint256 value)            public returns (bool);
134 
135   event Approval(
136     address indexed owner,
137     address indexed spender,
138     uint256 value
139   );
140 }
141 
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * https://github.com/ethereum/EIPs/issues/20
148  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _value uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(
162     address _from,
163     address _to,
164     uint256 _value
165   )
166     public
167     returns (bool)
168   {
169     //require(_to    != address(0));
170     require(_value <= balances[_from]);
171     require(_value <= allowed[_from][msg.sender]);
172 
173     balances[_from] = balances[_from].sub(_value);
174     balances[_to]   = balances[_to].add(_value);
175 
176     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177 
178     emit Transfer(_from, _to, _value);
179 
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    * Beware that changing an allowance with this method brings the risk that someone may use both the old
186    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189    * @param _spender The address which will spend the funds.
190    * @param _value The amount of tokens to be spent.
191    */
192   function approve(address _spender, uint256 _value) public returns (bool) {
193     allowed[msg.sender][_spender] = _value;
194     emit Approval(msg.sender, _spender, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens that an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint256 specifying the amount of tokens still available for the spender.
203    */
204   function allowance(
205     address _owner,
206     address _spender
207    )
208     public
209     view
210     returns (uint256)
211   {
212     return allowed[_owner][_spender];
213   }
214 
215   /**
216    * @dev Increase the amount of tokens that an owner allowed to a spender.
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(
225     address _spender,
226     uint256 _addedValue
227   )
228     public
229     returns (bool)
230   {
231     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    * approve should be called when allowed[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(
246     address _spender,
247     uint256 _subtractedValue
248   )
249     public
250     returns (bool)
251   {
252     uint256 oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 }
262 
263 
264 /**
265  * @title Ownable
266  * @dev The Ownable contract has an owner address, and provides basic authorization control
267  * functions, this simplifies the implementation of "user permissions".
268  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
269  */
270 contract Ownable {
271   address public owner;
272 
273   event OwnershipRenounced(address indexed previousOwner);
274 
275   event OwnershipTransferred(
276     address indexed previousOwner,
277     address indexed newOwner
278   );
279 
280   /**
281    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
282    * account.
283    */
284   constructor() public {
285     owner = msg.sender;
286   }
287 
288   /**
289    * @dev Throws if called by any account other than the owner.
290    */
291   modifier onlyOwner() {
292     require(msg.sender == owner);
293     _;
294   }
295 
296   /**
297    * @dev Allows the current owner to relinquish control of the contract.
298    * @notice Renouncing to ownership will leave the contract without an owner.
299    * It will not be possible to call the functions with the `onlyOwner`
300    * modifier anymore.
301    */
302   function renounceOwnership() public onlyOwner {
303     emit OwnershipRenounced(owner);
304     owner = address(0);
305   }
306 
307   /**
308    * @dev Allows the current owner to transfer control of the contract to a newOwner.
309    * @param _newOwner The address to transfer ownership to.
310    */
311   function transferOwnership(address _newOwner) public onlyOwner {
312     _transferOwnership(_newOwner);
313   }
314 
315   /**
316    * @dev Transfers control of the contract to a newOwner.
317    * @param _newOwner The address to transfer ownership to.
318    */
319   function _transferOwnership(address _newOwner) internal {
320     require(_newOwner != address(0));
321     emit OwnershipTransferred(owner, _newOwner);
322     owner = _newOwner;
323   }
324 }
325 
326 /**
327  * @title Pausable
328  * @dev Base contract which allows children to implement an emergency stop mechanism.
329  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol
330  */
331 contract Pausable is Ownable {
332   event Pause();
333   event Unpause();
334 
335   bool public paused = false;
336 
337   /**
338    * @dev Modifier to make a function callable only when the contract is not paused.
339    */
340   modifier whenNotPaused() {
341     require(!paused);
342     _;
343   }
344 
345   /**
346    * @dev Modifier to make a function callable only when the contract is paused.
347    */
348   modifier whenPaused() {
349     require(paused);
350     _;
351   }
352 
353   /**
354    * @dev called by the owner to pause, triggers stopped state
355    */
356   function pause() onlyOwner whenNotPaused public {
357     paused = true;
358     emit Pause();
359   }
360 
361   /**
362    * @dev called by the owner to unpause, returns to normal state
363    */
364   function unpause() onlyOwner whenPaused public {
365     paused = false;
366     emit Unpause();
367   }
368 }
369 
370 
371 /**
372  * @title Pausable token
373  * @dev StandardToken modified with pausable transfers.
374  **/
375 contract PausableToken is StandardToken, Pausable {
376 
377   function transfer(
378     address _to,
379     uint256 _value
380   )
381     public
382     whenNotPaused
383     returns (bool)
384   {
385     return super.transfer(_to, _value);
386   }
387 
388   function transferFrom(
389     address _from,
390     address _to,
391     uint256 _value
392   )
393     public
394     whenNotPaused
395     returns (bool)
396   {
397     return super.transferFrom(_from, _to, _value);
398   }
399 
400   function approve(
401     address _spender,
402     uint256 _value
403   )
404     public
405     whenNotPaused
406     returns (bool)
407   {
408     return super.approve(_spender, _value);
409   }
410 
411   function increaseApproval(
412     address _spender,
413     uint _addedValue
414   )
415     public
416     whenNotPaused
417     returns (bool success)
418   {
419     return super.increaseApproval(_spender, _addedValue);
420   }
421 
422   function decreaseApproval(
423     address _spender,
424     uint _subtractedValue
425   )
426     public
427     whenNotPaused
428     returns (bool success)
429   {
430     return super.decreaseApproval(_spender, _subtractedValue);
431   }
432 }
433 
434 // ----------------------------------------------------------------------------
435 
436 contract PoolinTestToken is PausableToken {
437   string public constant name     = "TEST Poolin Miner Token";
438   string public constant symbol   = "TEST-POOLIN";
439   uint8  public constant decimals = 6;
440 
441   // total supply: 21*10^8
442   uint256 public constant K_INITIAL_SUPPLY = uint256(2100000000) * (uint256(10) ** decimals);
443 
444   /**
445    * Token Constructor
446    *
447    */
448   constructor() public {
449     totalSupply_         = K_INITIAL_SUPPLY;
450     balances[msg.sender] = K_INITIAL_SUPPLY;
451 
452     emit Transfer(address(0), msg.sender, K_INITIAL_SUPPLY);
453   }
454 }