1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev total number of tokens in existence
76   */
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender)
113     public view returns (uint256);
114 
115   function transferFrom(address from, address to, uint256 value)
116     public returns (bool);
117 
118   function approve(address spender, uint256 value) public returns (bool);
119   event Approval(
120     address indexed owner,
121     address indexed spender,
122     uint256 value
123   );
124 }
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(
145     address _from,
146     address _to,
147     uint256 _value
148   )
149     public
150     returns (bool)
151   {
152     require(_to != address(0));
153     require(_value <= balances[_from]);
154     require(_value <= allowed[_from][msg.sender]);
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     emit Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    *
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) public returns (bool) {
174     allowed[msg.sender][_spender] = _value;
175     emit Approval(msg.sender, _spender, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(
186     address _owner,
187     address _spender
188    )
189     public
190     view
191     returns (uint256)
192   {
193     return allowed[_owner][_spender];
194   }
195 
196   /**
197    * @dev Increase the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To decrement
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _subtractedValue The amount of tokens to decrease the allowance by.
228    */
229   function decreaseApproval(
230     address _spender,
231     uint _subtractedValue
232   )
233     public
234     returns (bool)
235   {
236     uint oldValue = allowed[msg.sender][_spender];
237     if (_subtractedValue > oldValue) {
238       allowed[msg.sender][_spender] = 0;
239     } else {
240       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241     }
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246 }
247 
248 
249 /**
250  * @title Ownable
251  * @dev The Ownable contract has an owner address, and provides basic authorization control
252  * functions, this simplifies the implementation of "user permissions".
253  */
254 contract Ownable {
255   address public owner;
256 
257 
258   event OwnershipRenounced(address indexed previousOwner);
259   event OwnershipTransferred(
260     address indexed previousOwner,
261     address indexed newOwner
262   );
263 
264 
265   /**
266    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
267    * account.
268    */
269   constructor() public {
270     owner = msg.sender;
271   }
272 
273   /**
274    * @dev Throws if called by any account other than the owner.
275    */
276   modifier onlyOwner() {
277     require(msg.sender == owner);
278     _;
279   }
280 
281   /**
282    * @dev Allows the current owner to transfer control of the contract to a newOwner.
283    * @param newOwner The address to transfer ownership to.
284    */
285   function transferOwnership(address newOwner) public onlyOwner {
286     require(newOwner != address(0));
287     emit OwnershipTransferred(owner, newOwner);
288     owner = newOwner;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    */
294   function renounceOwnership() public onlyOwner {
295     emit OwnershipRenounced(owner);
296     owner = address(0);
297   }
298 }
299 
300 
301 /**
302  * @title Pausable
303  * @dev Base contract which allows children to implement an emergency stop mechanism.
304  */
305 contract Pausable is Ownable {
306   event Pause();
307   event Unpause();
308 
309   bool public paused = false;
310 
311 
312   /**
313    * @dev Modifier to make a function callable only when the contract is not paused.
314    */
315   modifier whenNotPaused() {
316     require(!paused);
317     _;
318   }
319 
320   /**
321    * @dev Modifier to make a function callable only when the contract is paused.
322    */
323   modifier whenPaused() {
324     require(paused);
325     _;
326   }
327 
328   /**
329    * @dev called by the owner to pause, triggers stopped state
330    */
331   function pause() onlyOwner whenNotPaused public {
332     paused = true;
333     emit Pause();
334   }
335 
336   /**
337    * @dev called by the owner to unpause, returns to normal state
338    */
339   function unpause() onlyOwner whenPaused public {
340     paused = false;
341     emit Unpause();
342   }
343 }
344 
345 contract Lockable is Ownable{
346   uint public creationTime;
347 
348 
349   mapping( address => bool ) public lockaddress;
350 
351   event Locked(address lockaddress,bool status);
352 
353   modifier checkLock {
354       if (lockaddress[msg.sender]) {
355           revert();
356       }
357       _;
358   }
359 
360   constructor () public {creationTime = now;}
361 
362   function lockAddress (address target, bool status) 
363     external 
364     onlyOwner 
365     { 
366       lockaddress[target] = status;
367       emit Locked(target, status);
368     } 
369 }
370 
371 /**
372  * @title Pausable token
373  * @dev StandardToken modified with pausable transfers.
374  **/
375 contract PausableToken is StandardToken, Pausable, Lockable {
376 
377   function transfer(
378     address _to,
379     uint256 _value
380   )
381     public
382     whenNotPaused
383     checkLock
384     returns (bool)
385   {
386     return super.transfer(_to, _value);
387   }
388 
389   function transferFrom(
390     address _from,
391     address _to,
392     uint256 _value
393   )
394     public
395     whenNotPaused
396     checkLock
397     returns (bool)
398   {
399     return super.transferFrom(_from, _to, _value);
400   }
401 
402   function approve(
403     address _spender,
404     uint256 _value
405   )
406     public
407     whenNotPaused
408     checkLock
409     returns (bool)
410   {
411     return super.approve(_spender, _value);
412   }
413 
414   function increaseApproval(
415     address _spender,
416     uint _addedValue
417   )
418     public
419     whenNotPaused
420     checkLock
421     returns (bool success)
422   {
423     return super.increaseApproval(_spender, _addedValue);
424   }
425 
426   function decreaseApproval(
427     address _spender,
428     uint _subtractedValue
429   )
430     public
431     whenNotPaused
432     checkLock
433     returns (bool success)
434   {
435     return super.decreaseApproval(_spender, _subtractedValue);
436   }
437 }
438 
439 
440 contract CELL is PausableToken {
441 
442   string public constant name = "Healthy Cell Chain"; // solium-disable-line uppercase
443   string public constant symbol = "CELL"; // solium-disable-line uppercase
444   uint8 public constant decimals = 18; // solium-disable-line uppercase
445 
446   uint256 public constant INITIAL_SUPPLY = 1 * 1000 * 1000 * 1000 * (10 ** uint256(decimals));
447 
448   /**
449    * @dev Constructor that gives msg.sender all of existing tokens.
450    */
451   constructor() public {
452     totalSupply_ = INITIAL_SUPPLY;
453     balances[msg.sender] = INITIAL_SUPPLY;
454     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
455   }
456 
457 }