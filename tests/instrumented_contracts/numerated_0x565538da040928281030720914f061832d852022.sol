1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
39 
40 /**
41  * @title DetailedERC20 token
42  * @dev The decimals are only for visualization purposes.
43  * All the operations are done using the smallest and indivisible token unit,
44  * just as on Ethereum all the operations are done in wei.
45  */
46 contract DetailedERC20 is ERC20 {
47   string public name;
48   string public symbol;
49   uint8 public decimals;
50 
51   constructor(string _name, string _symbol, uint8 _decimals) public {
52     name = _name;
53     symbol = _symbol;
54     decimals = _decimals;
55   }
56 }
57 
58 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
70     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
71     // benefit is lost if 'b' is also tested.
72     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
73     if (a == 0) {
74       return 0;
75     }
76 
77     c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     // uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return a / b;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
104     c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 
110 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   uint256 totalSupply_;
122 
123   /**
124   * @dev total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _value
180   )
181     public
182     returns (bool)
183   {
184     require(_to != address(0));
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    *
198    * Beware that changing an allowance with this method brings the risk that someone may use both the old
199    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) public returns (bool) {
206     allowed[msg.sender][_spender] = _value;
207     emit Approval(msg.sender, _spender, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifying the amount of tokens still available for the spender.
216    */
217   function allowance(
218     address _owner,
219     address _spender
220    )
221     public
222     view
223     returns (uint256)
224   {
225     return allowed[_owner][_spender];
226   }
227 
228   /**
229    * @dev Increase the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _addedValue The amount of tokens to increase the allowance by.
237    */
238   function increaseApproval(
239     address _spender,
240     uint _addedValue
241   )
242     public
243     returns (bool)
244   {
245     allowed[msg.sender][_spender] = (
246       allowed[msg.sender][_spender].add(_addedValue));
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   /**
252    * @dev Decrease the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(
262     address _spender,
263     uint _subtractedValue
264   )
265     public
266     returns (bool)
267   {
268     uint oldValue = allowed[msg.sender][_spender];
269     if (_subtractedValue > oldValue) {
270       allowed[msg.sender][_spender] = 0;
271     } else {
272       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273     }
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278 }
279 
280 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
281 
282 /**
283  * @title Ownable
284  * @dev The Ownable contract has an owner address, and provides basic authorization control
285  * functions, this simplifies the implementation of "user permissions".
286  */
287 contract Ownable {
288   address public owner;
289 
290 
291   event OwnershipRenounced(address indexed previousOwner);
292   event OwnershipTransferred(
293     address indexed previousOwner,
294     address indexed newOwner
295   );
296 
297 
298   /**
299    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
300    * account.
301    */
302   constructor() public {
303     owner = msg.sender;
304   }
305 
306   /**
307    * @dev Throws if called by any account other than the owner.
308    */
309   modifier onlyOwner() {
310     require(msg.sender == owner);
311     _;
312   }
313 
314   /**
315    * @dev Allows the current owner to relinquish control of the contract.
316    */
317   function renounceOwnership() public onlyOwner {
318     emit OwnershipRenounced(owner);
319     owner = address(0);
320   }
321 
322   /**
323    * @dev Allows the current owner to transfer control of the contract to a newOwner.
324    * @param _newOwner The address to transfer ownership to.
325    */
326   function transferOwnership(address _newOwner) public onlyOwner {
327     _transferOwnership(_newOwner);
328   }
329 
330   /**
331    * @dev Transfers control of the contract to a newOwner.
332    * @param _newOwner The address to transfer ownership to.
333    */
334   function _transferOwnership(address _newOwner) internal {
335     require(_newOwner != address(0));
336     emit OwnershipTransferred(owner, _newOwner);
337     owner = _newOwner;
338   }
339 }
340 
341 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
342 
343 /**
344  * @title Mintable token
345  * @dev Simple ERC20 Token example, with mintable token creation
346  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
347  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
348  */
349 contract MintableToken is StandardToken, Ownable {
350   event Mint(address indexed to, uint256 amount);
351   event MintFinished();
352 
353   bool public mintingFinished = false;
354 
355 
356   modifier canMint() {
357     require(!mintingFinished);
358     _;
359   }
360 
361   modifier hasMintPermission() {
362     require(msg.sender == owner);
363     _;
364   }
365 
366   /**
367    * @dev Function to mint tokens
368    * @param _to The address that will receive the minted tokens.
369    * @param _amount The amount of tokens to mint.
370    * @return A boolean that indicates if the operation was successful.
371    */
372   function mint(
373     address _to,
374     uint256 _amount
375   )
376     hasMintPermission
377     canMint
378     public
379     returns (bool)
380   {
381     totalSupply_ = totalSupply_.add(_amount);
382     balances[_to] = balances[_to].add(_amount);
383     emit Mint(_to, _amount);
384     emit Transfer(address(0), _to, _amount);
385     return true;
386   }
387 
388   /**
389    * @dev Function to stop minting new tokens.
390    * @return True if the operation was successful.
391    */
392   function finishMinting() onlyOwner canMint public returns (bool) {
393     mintingFinished = true;
394     emit MintFinished();
395     return true;
396   }
397 }
398 
399 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
400 
401 /**
402  * @title Pausable
403  * @dev Base contract which allows children to implement an emergency stop mechanism.
404  */
405 contract Pausable is Ownable {
406   event Pause();
407   event Unpause();
408 
409   bool public paused = false;
410 
411 
412   /**
413    * @dev Modifier to make a function callable only when the contract is not paused.
414    */
415   modifier whenNotPaused() {
416     require(!paused);
417     _;
418   }
419 
420   /**
421    * @dev Modifier to make a function callable only when the contract is paused.
422    */
423   modifier whenPaused() {
424     require(paused);
425     _;
426   }
427 
428   /**
429    * @dev called by the owner to pause, triggers stopped state
430    */
431   function pause() onlyOwner whenNotPaused public {
432     paused = true;
433     emit Pause();
434   }
435 
436   /**
437    * @dev called by the owner to unpause, returns to normal state
438    */
439   function unpause() onlyOwner whenPaused public {
440     paused = false;
441     emit Unpause();
442   }
443 }
444 
445 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
446 
447 /**
448  * @title Pausable token
449  * @dev StandardToken modified with pausable transfers.
450  **/
451 contract PausableToken is StandardToken, Pausable {
452 
453   function transfer(
454     address _to,
455     uint256 _value
456   )
457     public
458     whenNotPaused
459     returns (bool)
460   {
461     return super.transfer(_to, _value);
462   }
463 
464   function transferFrom(
465     address _from,
466     address _to,
467     uint256 _value
468   )
469     public
470     whenNotPaused
471     returns (bool)
472   {
473     return super.transferFrom(_from, _to, _value);
474   }
475 
476   function approve(
477     address _spender,
478     uint256 _value
479   )
480     public
481     whenNotPaused
482     returns (bool)
483   {
484     return super.approve(_spender, _value);
485   }
486 
487   function increaseApproval(
488     address _spender,
489     uint _addedValue
490   )
491     public
492     whenNotPaused
493     returns (bool success)
494   {
495     return super.increaseApproval(_spender, _addedValue);
496   }
497 
498   function decreaseApproval(
499     address _spender,
500     uint _subtractedValue
501   )
502     public
503     whenNotPaused
504     returns (bool success)
505   {
506     return super.decreaseApproval(_spender, _subtractedValue);
507   }
508 }
509 
510 // File: contracts/ThriftToken.sol
511 
512 contract ThriftToken is MintableToken, PausableToken, DetailedERC20 {
513     constructor(string _name, string _symbol, uint8 _decimals)
514         DetailedERC20(_name, _symbol, _decimals)
515         public
516     {
517 
518     }
519 }