1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 pragma solidity ^0.4.23;
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
28     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
29     // benefit is lost if 'b' is also tested.
30     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31     if (a == 0) {
32       return 0;
33     }
34 
35     c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   /**
41   * @dev Integer division of two numbers, truncating the quotient.
42   */
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     // uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return a / b;
48   }
49 
50   /**
51   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52   */
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   /**
59   * @dev Adds two numbers, throws on overflow.
60   */
61   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
62     c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 
69 pragma solidity ^0.4.23;
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 
116 pragma solidity ^0.4.23;
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender)
124     public view returns (uint256);
125 
126   function transferFrom(address from, address to, uint256 value)
127     public returns (bool);
128 
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(
131     address indexed owner,
132     address indexed spender,
133     uint256 value
134   );
135 }
136 
137 
138 pragma solidity ^0.4.23;
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) internal allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(
159     address _from,
160     address _to,
161     uint256 _value
162   )
163     public
164     returns (bool)
165   {
166     require(_to != address(0));
167     require(_value <= balances[_from]);
168     require(_value <= allowed[_from][msg.sender]);
169 
170     balances[_from] = balances[_from].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173     emit Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    *
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint256 _value) public returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     emit Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(
200     address _owner,
201     address _spender
202    )
203     public
204     view
205     returns (uint256)
206   {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211    * @dev Increase the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To increment
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _addedValue The amount of tokens to increase the allowance by.
219    */
220   function increaseApproval(
221     address _spender,
222     uint _addedValue
223   )
224     public
225     returns (bool)
226   {
227     allowed[msg.sender][_spender] = (
228       allowed[msg.sender][_spender].add(_addedValue));
229     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To decrement
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _subtractedValue The amount of tokens to decrease the allowance by.
242    */
243   function decreaseApproval(
244     address _spender,
245     uint _subtractedValue
246   )
247     public
248     returns (bool)
249   {
250     uint oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260 }
261 
262 
263 pragma solidity ^0.4.23;
264 
265 /**
266  * @title Ownable
267  * @dev The Ownable contract has an owner address, and provides basic authorization control
268  * functions, this simplifies the implementation of "user permissions".
269  */
270 contract Ownable {
271   address public owner;
272 
273 
274   event OwnershipRenounced(address indexed previousOwner);
275   event OwnershipTransferred(
276     address indexed previousOwner,
277     address indexed newOwner
278   );
279 
280 
281   /**
282    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
283    * account.
284    */
285   constructor() public {
286     owner = msg.sender;
287   }
288 
289   /**
290    * @dev Throws if called by any account other than the owner.
291    */
292   modifier onlyOwner() {
293     require(msg.sender == owner);
294     _;
295   }
296 
297   /**
298    * @dev Allows the current owner to relinquish control of the contract.
299    */
300   function renounceOwnership() public onlyOwner {
301     emit OwnershipRenounced(owner);
302     owner = address(0);
303   }
304 
305   /**
306    * @dev Allows the current owner to transfer control of the contract to a newOwner.
307    * @param _newOwner The address to transfer ownership to.
308    */
309   function transferOwnership(address _newOwner) public onlyOwner {
310     _transferOwnership(_newOwner);
311   }
312 
313   /**
314    * @dev Transfers control of the contract to a newOwner.
315    * @param _newOwner The address to transfer ownership to.
316    */
317   function _transferOwnership(address _newOwner) internal {
318     require(_newOwner != address(0));
319     emit OwnershipTransferred(owner, _newOwner);
320     owner = _newOwner;
321   }
322 }
323 
324 
325 pragma solidity ^0.4.23;
326 
327 /**
328  * @title Mintable token
329  * @dev Simple ERC20 Token example, with mintable token creation
330  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
331  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
332  */
333 contract MintableToken is StandardToken, Ownable {
334   event Mint(address indexed to, uint256 amount);
335   event MintFinished();
336 
337   bool public mintingFinished = false;
338 
339 
340   modifier canMint() {
341     require(!mintingFinished);
342     _;
343   }
344 
345   modifier hasMintPermission() {
346     require(msg.sender == owner);
347     _;
348   }
349 
350   /**
351    * @dev Function to mint tokens
352    * @param _to The address that will receive the minted tokens.
353    * @param _amount The amount of tokens to mint.
354    * @return A boolean that indicates if the operation was successful.
355    */
356   function mint(
357     address _to,
358     uint256 _amount
359   )
360     hasMintPermission
361     canMint
362     public
363     returns (bool)
364   {
365     totalSupply_ = totalSupply_.add(_amount);
366     balances[_to] = balances[_to].add(_amount);
367     emit Mint(_to, _amount);
368     emit Transfer(address(0), _to, _amount);
369     return true;
370   }
371 
372   /**
373    * @dev Function to stop minting new tokens.
374    * @return True if the operation was successful.
375    */
376   function finishMinting() onlyOwner canMint public returns (bool) {
377     mintingFinished = true;
378     emit MintFinished();
379     return true;
380   }
381 }
382 
383 
384 pragma solidity ^0.4.23;
385 
386 /**
387  * @title Pausable
388  * @dev Base contract which allows children to implement an emergency stop mechanism.
389  */
390 contract Pausable is Ownable {
391   event Pause();
392   event Unpause();
393 
394   bool public paused = false;
395 
396 
397   /**
398    * @dev Modifier to make a function callable only when the contract is not paused.
399    */
400   modifier whenNotPaused() {
401     require(!paused);
402     _;
403   }
404 
405   /**
406    * @dev Modifier to make a function callable only when the contract is paused.
407    */
408   modifier whenPaused() {
409     require(paused);
410     _;
411   }
412 
413   /**
414    * @dev called by the owner to pause, triggers stopped state
415    */
416   function pause() onlyOwner whenNotPaused public {
417     paused = true;
418     emit Pause();
419   }
420 
421   /**
422    * @dev called by the owner to unpause, returns to normal state
423    */
424   function unpause() onlyOwner whenPaused public {
425     paused = false;
426     emit Unpause();
427   }
428 }
429 
430 
431 pragma solidity ^0.4.23;
432 
433 /**
434  * @title Pausable token
435  * @dev StandardToken modified with pausable transfers.
436  **/
437 contract PausableToken is StandardToken, Pausable {
438 
439   function transfer(
440     address _to,
441     uint256 _value
442   )
443     public
444     whenNotPaused
445     returns (bool)
446   {
447     return super.transfer(_to, _value);
448   }
449 
450   function transferFrom(
451     address _from,
452     address _to,
453     uint256 _value
454   )
455     public
456     whenNotPaused
457     returns (bool)
458   {
459     return super.transferFrom(_from, _to, _value);
460   }
461 
462   function approve(
463     address _spender,
464     uint256 _value
465   )
466     public
467     whenNotPaused
468     returns (bool)
469   {
470     return super.approve(_spender, _value);
471   }
472 
473   function increaseApproval(
474     address _spender,
475     uint _addedValue
476   )
477     public
478     whenNotPaused
479     returns (bool success)
480   {
481     return super.increaseApproval(_spender, _addedValue);
482   }
483 
484   function decreaseApproval(
485     address _spender,
486     uint _subtractedValue
487   )
488     public
489     whenNotPaused
490     returns (bool success)
491   {
492     return super.decreaseApproval(_spender, _subtractedValue);
493   }
494 }
495 
496 
497 pragma solidity ^0.4.24;
498 
499 contract InvestmentToken is MintableToken, PausableToken {
500   string  public name;
501   string  public symbol;
502   uint256 public decimals;
503 
504   constructor() public {
505     name = "Investment Token";
506     symbol = "DINT";
507     decimals = 18;
508   }
509 }