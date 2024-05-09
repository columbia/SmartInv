1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Poolin Miner Token' token contract
5 //
6 // Symbol      : PIN
7 // Name        : Poolin Miner Token
8 // Website     : https://www.poolin.com
9 // Total supply: 2100000000
10 // Decimals    : 18
11 //
12 // (c) poolin.com, 2018-07
13 // ----------------------------------------------------------------------------
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  *
19  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30     if (a == 0) {
31       return 0;
32     }
33 
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return a / b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 
68 /**
69  * @title ERC20Basic
70  * @dev Simpler version of ERC20 interface
71  * See https://github.com/ethereum/EIPs/issues/179
72  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
73  */
74 contract ERC20Basic {
75   function totalSupply()                          public view returns (uint256);
76   function balanceOf  (address who)               public view returns (uint256);
77   function transfer   (address to, uint256 value) public returns (bool);
78 
79   event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances.
85  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
86  */
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) balances;
91 
92   uint256 totalSupply_;
93 
94   /**
95   * @dev Total number of tokens in existence
96   */
97   function totalSupply() public view returns (uint256) {
98     return totalSupply_;
99   }
100 
101   /**
102   * @dev Transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     //require(_to    != address(0));
108     require(_value <= balances[msg.sender]);
109 
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to]        = balances[_to].add(_value);
112     emit Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of.
119   * @return An uint256 representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) public view returns (uint256) {
122     return balances[_owner];
123   }
124 }
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance   (address owner,  address spender)           public view returns (uint256);
133   function transferFrom(address from,   address to, uint256 value) public returns (bool);
134   function approve     (address spender, uint256 value)            public returns (bool);
135 
136   event Approval(
137     address indexed owner,
138     address indexed spender,
139     uint256 value
140   );
141 }
142 
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * https://github.com/ethereum/EIPs/issues/20
149  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) internal allowed;
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(
163     address _from,
164     address _to,
165     uint256 _value
166   )
167     public
168     returns (bool)
169   {
170     //require(_to    != address(0));
171     require(_value <= balances[_from]);
172     require(_value <= allowed[_from][msg.sender]);
173 
174     balances[_from] = balances[_from].sub(_value);
175     balances[_to]   = balances[_to].add(_value);
176 
177     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
178 
179     emit Transfer(_from, _to, _value);
180 
181     return true;
182   }
183 
184   /**
185    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     emit Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(
206     address _owner,
207     address _spender
208    )
209     public
210     view
211     returns (uint256)
212   {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217    * @dev Increase the amount of tokens that an owner allowed to a spender.
218    * approve should be called when allowed[_spender] == 0. To increment
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _addedValue The amount of tokens to increase the allowance by.
224    */
225   function increaseApproval(
226     address _spender,
227     uint256 _addedValue
228   )
229     public
230     returns (bool)
231   {
232     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(
247     address _spender,
248     uint256 _subtractedValue
249   )
250     public
251     returns (bool)
252   {
253     uint256 oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 }
263 
264 
265 /**
266  * @title Ownable
267  * @dev The Ownable contract has an owner address, and provides basic authorization control
268  * functions, this simplifies the implementation of "user permissions".
269  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
270  */
271 contract Ownable {
272   address public owner;
273 
274   event OwnershipTransferred(
275     address indexed previousOwner,
276     address indexed newOwner
277   );
278 
279   /**
280    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
281    * account.
282    */
283   constructor() public {
284     owner = msg.sender;
285   }
286 
287   /**
288    * @dev Throws if called by any account other than the owner.
289    */
290   modifier onlyOwner() {
291     require(msg.sender == owner);
292     _;
293   }
294 
295   /**
296    * @dev Allows the current owner to transfer control of the contract to a newOwner.
297    * @param _newOwner The address to transfer ownership to.
298    */
299   function transferOwnership(address _newOwner) public onlyOwner {
300     _transferOwnership(_newOwner);
301   }
302 
303   /**
304    * @dev Transfers control of the contract to a newOwner.
305    * @param _newOwner The address to transfer ownership to.
306    */
307   function _transferOwnership(address _newOwner) internal {
308     require(_newOwner != address(0));
309     emit OwnershipTransferred(owner, _newOwner);
310     owner = _newOwner;
311   }
312 }
313 
314 /**
315  * @title Pausable
316  * @dev Base contract which allows children to implement an emergency stop mechanism.
317  * See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol
318  */
319 contract Pausable is Ownable {
320   event Pause();
321   event Unpause();
322 
323   bool public paused = false;
324 
325   /**
326    * @dev Modifier to make a function callable only when the contract is not paused.
327    */
328   modifier whenNotPaused() {
329     require(!paused);
330     _;
331   }
332 
333   /**
334    * @dev Modifier to make a function callable only when the contract is paused.
335    */
336   modifier whenPaused() {
337     require(paused);
338     _;
339   }
340 
341   /**
342    * @dev called by the owner to pause, triggers stopped state
343    */
344   function pause() onlyOwner whenNotPaused public {
345     paused = true;
346     emit Pause();
347   }
348 
349   /**
350    * @dev called by the owner to unpause, returns to normal state
351    */
352   function unpause() onlyOwner whenPaused public {
353     paused = false;
354     emit Unpause();
355   }
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
422 // ----------------------------------------------------------------------------
423 
424 contract PoolinToken is PausableToken {
425   string public constant name     = "Poolin Miner Token";
426   string public constant symbol   = "PIN";
427   uint8  public constant decimals = 18;
428 
429   // total supply: 21 * 10^8 * 10^18
430   uint256 internal constant K_INITIAL_SUPPLY = 2100000000 * 10 ** uint256(decimals);
431 
432   /**
433    * Token Constructor
434    *
435    */
436   constructor() public {
437     totalSupply_         = K_INITIAL_SUPPLY;
438     balances[msg.sender] = K_INITIAL_SUPPLY;
439 
440     emit Transfer(address(0), msg.sender, K_INITIAL_SUPPLY);
441   }
442 }