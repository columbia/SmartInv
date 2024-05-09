1 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 pragma solidity ^0.4.23;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 //File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
18 pragma solidity ^0.4.23;
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
32     // benefit is lost if 'b' is also tested.
33     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34     if (a == 0) {
35       return 0;
36     }
37 
38     c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     // uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return a / b;
51   }
52 
53   /**
54   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
65     c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
72 pragma solidity ^0.4.23;
73 
74 
75 
76 
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   uint256 totalSupply_;
89 
90   /**
91   * @dev total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105 
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     emit Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
124 pragma solidity ^0.4.23;
125 
126 
127 
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 is ERC20Basic {
134   function allowance(address owner, address spender)
135     public view returns (uint256);
136 
137   function transferFrom(address from, address to, uint256 value)
138     public returns (bool);
139 
140   function approve(address spender, uint256 value) public returns (bool);
141   event Approval(
142     address indexed owner,
143     address indexed spender,
144     uint256 value
145   );
146 }
147 
148 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
149 pragma solidity ^0.4.23;
150 
151 
152 
153 
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev https://github.com/ethereum/EIPs/issues/20
160  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) internal allowed;
165 
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param _from address The address which you want to send tokens from
170    * @param _to address The address which you want to transfer to
171    * @param _value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(
174     address _from,
175     address _to,
176     uint256 _value
177   )
178     public
179     returns (bool)
180   {
181     require(_to != address(0));
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     emit Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    *
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address _owner,
216     address _spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(
236     address _spender,
237     uint _addedValue
238   )
239     public
240     returns (bool)
241   {
242     allowed[msg.sender][_spender] = (
243       allowed[msg.sender][_spender].add(_addedValue));
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248   /**
249    * @dev Decrease the amount of tokens that an owner allowed to a spender.
250    *
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(
259     address _spender,
260     uint _subtractedValue
261   )
262     public
263     returns (bool)
264   {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 //File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
278 pragma solidity ^0.4.23;
279 
280 
281 /**
282  * @title Ownable
283  * @dev The Ownable contract has an owner address, and provides basic authorization control
284  * functions, this simplifies the implementation of "user permissions".
285  */
286 contract Ownable {
287   address public owner;
288 
289 
290   event OwnershipRenounced(address indexed previousOwner);
291   event OwnershipTransferred(
292     address indexed previousOwner,
293     address indexed newOwner
294   );
295 
296 
297   /**
298    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
299    * account.
300    */
301   constructor() public {
302     owner = msg.sender;
303   }
304 
305   /**
306    * @dev Throws if called by any account other than the owner.
307    */
308   modifier onlyOwner() {
309     require(msg.sender == owner);
310     _;
311   }
312 
313   /**
314    * @dev Allows the current owner to relinquish control of the contract.
315    */
316   function renounceOwnership() public onlyOwner {
317     emit OwnershipRenounced(owner);
318     owner = address(0);
319   }
320 
321   /**
322    * @dev Allows the current owner to transfer control of the contract to a newOwner.
323    * @param _newOwner The address to transfer ownership to.
324    */
325   function transferOwnership(address _newOwner) public onlyOwner {
326     _transferOwnership(_newOwner);
327   }
328 
329   /**
330    * @dev Transfers control of the contract to a newOwner.
331    * @param _newOwner The address to transfer ownership to.
332    */
333   function _transferOwnership(address _newOwner) internal {
334     require(_newOwner != address(0));
335     emit OwnershipTransferred(owner, _newOwner);
336     owner = _newOwner;
337   }
338 }
339 
340 //File: node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
341 pragma solidity ^0.4.23;
342 
343 
344 
345 
346 
347 /**
348  * @title Pausable
349  * @dev Base contract which allows children to implement an emergency stop mechanism.
350  */
351 contract Pausable is Ownable {
352   event Pause();
353   event Unpause();
354 
355   bool public paused = false;
356 
357 
358   /**
359    * @dev Modifier to make a function callable only when the contract is not paused.
360    */
361   modifier whenNotPaused() {
362     require(!paused);
363     _;
364   }
365 
366   /**
367    * @dev Modifier to make a function callable only when the contract is paused.
368    */
369   modifier whenPaused() {
370     require(paused);
371     _;
372   }
373 
374   /**
375    * @dev called by the owner to pause, triggers stopped state
376    */
377   function pause() onlyOwner whenNotPaused public {
378     paused = true;
379     emit Pause();
380   }
381 
382   /**
383    * @dev called by the owner to unpause, returns to normal state
384    */
385   function unpause() onlyOwner whenPaused public {
386     paused = false;
387     emit Unpause();
388   }
389 }
390 
391 //File: node_modules/openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
392 pragma solidity ^0.4.23;
393 
394 
395 
396 
397 
398 /**
399  * @title Pausable token
400  * @dev StandardToken modified with pausable transfers.
401  **/
402 contract PausableToken is StandardToken, Pausable {
403 
404   function transfer(
405     address _to,
406     uint256 _value
407   )
408     public
409     whenNotPaused
410     returns (bool)
411   {
412     return super.transfer(_to, _value);
413   }
414 
415   function transferFrom(
416     address _from,
417     address _to,
418     uint256 _value
419   )
420     public
421     whenNotPaused
422     returns (bool)
423   {
424     return super.transferFrom(_from, _to, _value);
425   }
426 
427   function approve(
428     address _spender,
429     uint256 _value
430   )
431     public
432     whenNotPaused
433     returns (bool)
434   {
435     return super.approve(_spender, _value);
436   }
437 
438   function increaseApproval(
439     address _spender,
440     uint _addedValue
441   )
442     public
443     whenNotPaused
444     returns (bool success)
445   {
446     return super.increaseApproval(_spender, _addedValue);
447   }
448 
449   function decreaseApproval(
450     address _spender,
451     uint _subtractedValue
452   )
453     public
454     whenNotPaused
455     returns (bool success)
456   {
457     return super.decreaseApproval(_spender, _subtractedValue);
458   }
459 }
460 
461 //File: contracts/token/Stoken.sol
462 pragma solidity ^0.4.24;
463 
464 
465 
466 contract SToken is PausableToken {
467     string public constant name = "S Token";
468     string public constant symbol = "SXX";
469     uint8 public constant decimals = 18;
470     uint256 public constant INITIAL_BALANCE = (10**6) * (10 ** uint256(decimals));
471 
472     constructor(address _owner) public {
473         owner = _owner;
474         totalSupply_ = INITIAL_BALANCE;
475         balances[owner] = INITIAL_BALANCE;
476         emit Transfer(address(0), owner, INITIAL_BALANCE);
477 
478         paused = true;
479     }
480 }