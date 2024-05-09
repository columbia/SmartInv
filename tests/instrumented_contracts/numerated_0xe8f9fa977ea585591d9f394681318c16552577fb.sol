1 pragma solidity 0.4.24;
2 
3 // File: contracts/ZTXInterface.sol
4 
5 contract ZTXInterface {
6     function transferOwnership(address _newOwner) public;
7     function mint(address _to, uint256 amount) public returns (bool);
8     function balanceOf(address who) public view returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     function unpause() public;
11 }
12 
13 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
14 
15 /**
16  * @title ERC20Basic
17  * @dev Simpler version of ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/179
19  */
20 contract ERC20Basic {
21   function totalSupply() public view returns (uint256);
22   function balanceOf(address who) public view returns (uint256);
23   function transfer(address to, uint256 value) public returns (bool);
24   event Transfer(address indexed from, address indexed to, uint256 value);
25 }
26 
27 // File: zeppelin-solidity/contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, throws on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
40     // benefit is lost if 'b' is also tested.
41     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42     if (a == 0) {
43       return 0;
44     }
45 
46     c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers, truncating the quotient.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     // uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return a / b;
59   }
60 
61   /**
62   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   /**
70   * @dev Adds two numbers, throws on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   uint256 totalSupply_;
91 
92   /**
93   * @dev total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender)
133     public view returns (uint256);
134 
135   function transferFrom(address from, address to, uint256 value)
136     public returns (bool);
137 
138   function approve(address spender, uint256 value) public returns (bool);
139   event Approval(
140     address indexed owner,
141     address indexed spender,
142     uint256 value
143   );
144 }
145 
146 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(
167     address _from,
168     address _to,
169     uint256 _value
170   )
171     public
172     returns (bool)
173   {
174     require(_to != address(0));
175     require(_value <= balances[_from]);
176     require(_value <= allowed[_from][msg.sender]);
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181     emit Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    *
188    * Beware that changing an allowance with this method brings the risk that someone may use both the old
189    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     emit Approval(msg.sender, _spender, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Function to check the amount of tokens that an owner allowed to a spender.
203    * @param _owner address The address which owns the funds.
204    * @param _spender address The address which will spend the funds.
205    * @return A uint256 specifying the amount of tokens still available for the spender.
206    */
207   function allowance(
208     address _owner,
209     address _spender
210    )
211     public
212     view
213     returns (uint256)
214   {
215     return allowed[_owner][_spender];
216   }
217 
218   /**
219    * @dev Increase the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _addedValue The amount of tokens to increase the allowance by.
227    */
228   function increaseApproval(
229     address _spender,
230     uint _addedValue
231   )
232     public
233     returns (bool)
234   {
235     allowed[msg.sender][_spender] = (
236       allowed[msg.sender][_spender].add(_addedValue));
237     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(
252     address _spender,
253     uint _subtractedValue
254   )
255     public
256     returns (bool)
257   {
258     uint oldValue = allowed[msg.sender][_spender];
259     if (_subtractedValue > oldValue) {
260       allowed[msg.sender][_spender] = 0;
261     } else {
262       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
263     }
264     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268 }
269 
270 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
271 
272 /**
273  * @title Ownable
274  * @dev The Ownable contract has an owner address, and provides basic authorization control
275  * functions, this simplifies the implementation of "user permissions".
276  */
277 contract Ownable {
278   address public owner;
279 
280 
281   event OwnershipRenounced(address indexed previousOwner);
282   event OwnershipTransferred(
283     address indexed previousOwner,
284     address indexed newOwner
285   );
286 
287 
288   /**
289    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
290    * account.
291    */
292   constructor() public {
293     owner = msg.sender;
294   }
295 
296   /**
297    * @dev Throws if called by any account other than the owner.
298    */
299   modifier onlyOwner() {
300     require(msg.sender == owner);
301     _;
302   }
303 
304   /**
305    * @dev Allows the current owner to relinquish control of the contract.
306    */
307   function renounceOwnership() public onlyOwner {
308     emit OwnershipRenounced(owner);
309     owner = address(0);
310   }
311 
312   /**
313    * @dev Allows the current owner to transfer control of the contract to a newOwner.
314    * @param _newOwner The address to transfer ownership to.
315    */
316   function transferOwnership(address _newOwner) public onlyOwner {
317     _transferOwnership(_newOwner);
318   }
319 
320   /**
321    * @dev Transfers control of the contract to a newOwner.
322    * @param _newOwner The address to transfer ownership to.
323    */
324   function _transferOwnership(address _newOwner) internal {
325     require(_newOwner != address(0));
326     emit OwnershipTransferred(owner, _newOwner);
327     owner = _newOwner;
328   }
329 }
330 
331 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
332 
333 /**
334  * @title Mintable token
335  * @dev Simple ERC20 Token example, with mintable token creation
336  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
337  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
338  */
339 contract MintableToken is StandardToken, Ownable {
340   event Mint(address indexed to, uint256 amount);
341   event MintFinished();
342 
343   bool public mintingFinished = false;
344 
345 
346   modifier canMint() {
347     require(!mintingFinished);
348     _;
349   }
350 
351   modifier hasMintPermission() {
352     require(msg.sender == owner);
353     _;
354   }
355 
356   /**
357    * @dev Function to mint tokens
358    * @param _to The address that will receive the minted tokens.
359    * @param _amount The amount of tokens to mint.
360    * @return A boolean that indicates if the operation was successful.
361    */
362   function mint(
363     address _to,
364     uint256 _amount
365   )
366     hasMintPermission
367     canMint
368     public
369     returns (bool)
370   {
371     totalSupply_ = totalSupply_.add(_amount);
372     balances[_to] = balances[_to].add(_amount);
373     emit Mint(_to, _amount);
374     emit Transfer(address(0), _to, _amount);
375     return true;
376   }
377 
378   /**
379    * @dev Function to stop minting new tokens.
380    * @return True if the operation was successful.
381    */
382   function finishMinting() onlyOwner canMint public returns (bool) {
383     mintingFinished = true;
384     emit MintFinished();
385     return true;
386   }
387 }
388 
389 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
390 
391 /**
392  * @title Pausable
393  * @dev Base contract which allows children to implement an emergency stop mechanism.
394  */
395 contract Pausable is Ownable {
396   event Pause();
397   event Unpause();
398 
399   bool public paused = false;
400 
401 
402   /**
403    * @dev Modifier to make a function callable only when the contract is not paused.
404    */
405   modifier whenNotPaused() {
406     require(!paused);
407     _;
408   }
409 
410   /**
411    * @dev Modifier to make a function callable only when the contract is paused.
412    */
413   modifier whenPaused() {
414     require(paused);
415     _;
416   }
417 
418   /**
419    * @dev called by the owner to pause, triggers stopped state
420    */
421   function pause() onlyOwner whenNotPaused public {
422     paused = true;
423     emit Pause();
424   }
425 
426   /**
427    * @dev called by the owner to unpause, returns to normal state
428    */
429   function unpause() onlyOwner whenPaused public {
430     paused = false;
431     emit Unpause();
432   }
433 }
434 
435 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
436 
437 /**
438  * @title Pausable token
439  * @dev StandardToken modified with pausable transfers.
440  **/
441 contract PausableToken is StandardToken, Pausable {
442 
443   function transfer(
444     address _to,
445     uint256 _value
446   )
447     public
448     whenNotPaused
449     returns (bool)
450   {
451     return super.transfer(_to, _value);
452   }
453 
454   function transferFrom(
455     address _from,
456     address _to,
457     uint256 _value
458   )
459     public
460     whenNotPaused
461     returns (bool)
462   {
463     return super.transferFrom(_from, _to, _value);
464   }
465 
466   function approve(
467     address _spender,
468     uint256 _value
469   )
470     public
471     whenNotPaused
472     returns (bool)
473   {
474     return super.approve(_spender, _value);
475   }
476 
477   function increaseApproval(
478     address _spender,
479     uint _addedValue
480   )
481     public
482     whenNotPaused
483     returns (bool success)
484   {
485     return super.increaseApproval(_spender, _addedValue);
486   }
487 
488   function decreaseApproval(
489     address _spender,
490     uint _subtractedValue
491   )
492     public
493     whenNotPaused
494     returns (bool success)
495   {
496     return super.decreaseApproval(_spender, _subtractedValue);
497   }
498 }
499 
500 // File: contracts/ZTX.sol
501 
502 /**
503  * @title ZTX contract - ERC20 compatible token contract.
504  * @author Gustavo Guimaraes - <gustavo@zulurepublic.io>
505  */
506 contract ZTX is MintableToken, PausableToken {
507     string public constant name = "Zulu Republic Token";
508     string public constant symbol = "ZTX";
509     uint8 public constant decimals = 18;
510 
511     constructor() public {
512         pause();
513     }
514 }