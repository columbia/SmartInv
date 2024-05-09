1 /*
2 Copyright (c) 2018 WiseWolf Ltd
3 Developed by https://adoriasoft.com
4 */
5 
6 pragma solidity ^0.4.23;
7 
8 // File: contracts/ERC20Basic.sol
9 
10 /**
11  * @title ERC20Basic
12  * @dev Simpler version of ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/179
14  */
15 contract ERC20Basic {
16   function totalSupply() public view returns (uint256);
17   function balanceOf(address who) public view returns (uint256);
18   function transfer(address to, uint256 value) public returns (bool);
19   event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 // File: contracts/SafeMath.sol
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
34     if (a == 0) {
35       return 0;
36     }
37     c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     // uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return a / b;
50   }
51 
52   /**
53   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 // File: contracts/BasicToken.sol
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 // File: contracts/BurnableToken.sol
117 
118 /**
119  * @title Burnable Token
120  * @dev Token that can be irreversibly burned (destroyed).
121  */
122 contract BurnableToken is BasicToken {
123 
124   event Burn(address indexed burner, uint256 value);
125 
126   /**
127    * @dev Burns a specific amount of tokens.
128    * @param _value The amount of token to be burned.
129    */
130   function burn(uint256 _value) public {
131     _burn(msg.sender, _value);
132   }
133 
134   function _burn(address _who, uint256 _value) internal {
135     require(_value <= balances[_who]);
136     // no need to require value <= totalSupply, since that would imply the
137     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
138 
139     balances[_who] = balances[_who].sub(_value);
140     totalSupply_ = totalSupply_.sub(_value);
141     emit Burn(_who, _value);
142     emit Transfer(_who, address(0), _value);
143   }
144 }
145 
146 // File: contracts/Ownable.sol
147 
148 /**
149  * @title Ownable
150  * @dev The Ownable contract has an owner address, and provides basic authorization control
151  * functions, this simplifies the implementation of "user permissions".
152  */
153 contract Ownable {
154   address public owner;
155 
156 
157   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   constructor() public {
165     owner = msg.sender;
166   }
167 
168   /**
169    * @dev Throws if called by any account other than the owner.
170    */
171   modifier onlyOwner() {
172     require(msg.sender == owner);
173     _;
174   }
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) public onlyOwner {
181     require(newOwner != address(0));
182     emit OwnershipTransferred(owner, newOwner);
183     owner = newOwner;
184   }
185 
186 }
187 
188 // File: contracts/ERC20.sol
189 
190 /**
191  * @title ERC20 interface
192  * @dev see https://github.com/ethereum/EIPs/issues/20
193  */
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender) public view returns (uint256);
196   function transferFrom(address from, address to, uint256 value) public returns (bool);
197   function approve(address spender, uint256 value) public returns (bool);
198   event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 // File: contracts/ERC223.sol
202 
203 /*
204   ERC223 additions to ERC20
205 
206   Interface wise is ERC20 + data paramenter to transfer and transferFrom.
207  */
208 
209 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20.sol";
210 
211 
212 contract ERC223 is ERC20 {
213   function transfer(address to, uint value, bytes data) public returns (bool ok);
214   function transferFrom(address from, address to, uint value, bytes data) public returns (bool ok);
215   
216   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
217 }
218 
219 // File: contracts/ERC223Receiver.sol
220 
221 /*
222 Base class contracts willing to accept ERC223 token transfers must conform to.
223 
224 Sender: msg.sender to the token contract, the address originating the token transfer.
225           - For user originated transfers sender will be equal to tx.origin
226           - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.
227 Origin: the origin address from whose balance the tokens are sent
228           - For transfer(), origin = msg.sender
229           - For transferFrom() origin = _from to token contract
230 Value is the amount of tokens sent
231 Data is arbitrary data sent with the token transfer. Simulates ether tx.data
232 
233 From, origin and value shouldn't be trusted unless the token contract is trusted.
234 If sender == tx.origin, it is safe to trust it regardless of the token.
235 */
236 
237 contract ERC223Receiver {
238   function tokenFallback(address _from, uint _value, bytes _data) public;
239 }
240 
241 // File: contracts/Pausable.sol
242 
243 /**
244  * @title Pausable
245  * @dev Base contract which allows children to implement an emergency stop mechanism.
246  */
247 contract Pausable is Ownable {
248   event Pause();
249   event Unpause();
250 
251   bool public paused = false;
252 
253 
254   /**
255    * @dev Modifier to make a function callable only when the contract is not paused.
256    */
257   modifier whenNotPaused() {
258     require(!paused);
259     _;
260   }
261 
262   /**
263    * @dev Modifier to make a function callable only when the contract is paused.
264    */
265   modifier whenPaused() {
266     require(paused);
267     _;
268   }
269 
270   /**
271    * @dev called by the owner to pause, triggers stopped state
272    */
273   function pause() onlyOwner whenNotPaused public {
274     paused = true;
275     emit Pause();
276   }
277 
278   /**
279    * @dev called by the owner to unpause, returns to normal state
280    */
281   function unpause() onlyOwner whenPaused public {
282     paused = false;
283     emit Unpause();
284   }
285 }
286 
287 // File: contracts/StandardToken.sol
288 
289 /**
290  * @title Standard ERC20 token
291  *
292  * @dev Implementation of the basic standard token.
293  * @dev https://github.com/ethereum/EIPs/issues/20
294  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
295  */
296 contract StandardToken is ERC20, BasicToken {
297 
298   mapping (address => mapping (address => uint256)) internal allowed;
299 
300 
301   /**
302    * @dev Transfer tokens from one address to another
303    * @param _from address The address which you want to send tokens from
304    * @param _to address The address which you want to transfer to
305    * @param _value uint256 the amount of tokens to be transferred
306    */
307   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
308     require(_to != address(0));
309     require(_value <= balances[_from]);
310     require(_value <= allowed[_from][msg.sender]);
311 
312     balances[_from] = balances[_from].sub(_value);
313     balances[_to] = balances[_to].add(_value);
314     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
315     emit Transfer(_from, _to, _value);
316     return true;
317   }
318 
319   /**
320    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
321    *
322    * Beware that changing an allowance with this method brings the risk that someone may use both the old
323    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
324    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
325    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
326    * @param _spender The address which will spend the funds.
327    * @param _value The amount of tokens to be spent.
328    */
329   function approve(address _spender, uint256 _value) public returns (bool) {
330     allowed[msg.sender][_spender] = _value;
331     emit Approval(msg.sender, _spender, _value);
332     return true;
333   }
334 
335   /**
336    * @dev Function to check the amount of tokens that an owner allowed to a spender.
337    * @param _owner address The address which owns the funds.
338    * @param _spender address The address which will spend the funds.
339    * @return A uint256 specifying the amount of tokens still available for the spender.
340    */
341   function allowance(address _owner, address _spender) public view returns (uint256) {
342     return allowed[_owner][_spender];
343   }
344 
345   /**
346    * @dev Increase the amount of tokens that an owner allowed to a spender.
347    *
348    * approve should be called when allowed[_spender] == 0. To increment
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _addedValue The amount of tokens to increase the allowance by.
354    */
355   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
356     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
357     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358     return true;
359   }
360 
361   /**
362    * @dev Decrease the amount of tokens that an owner allowed to a spender.
363    *
364    * approve should be called when allowed[_spender] == 0. To decrement
365    * allowed value is better to use this function to avoid 2 calls (and wait until
366    * the first transaction is mined)
367    * From MonolithDAO Token.sol
368    * @param _spender The address which will spend the funds.
369    * @param _subtractedValue The amount of tokens to decrease the allowance by.
370    */
371   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
372     uint oldValue = allowed[msg.sender][_spender];
373     if (_subtractedValue > oldValue) {
374       allowed[msg.sender][_spender] = 0;
375     } else {
376       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
377     }
378     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
379     return true;
380   }
381 
382 }
383 
384 // File: contracts/PausableToken.sol
385 
386 /**
387  * @title Pausable token
388  * @dev StandardToken modified with pausable transfers.
389  **/
390 contract PausableToken is StandardToken, Pausable {
391 
392   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
393     return super.transfer(_to, _value);
394   }
395 
396   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
397     return super.transferFrom(_from, _to, _value);
398   }
399 
400   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
401     return super.approve(_spender, _value);
402   }
403 
404   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
405     return super.increaseApproval(_spender, _addedValue);
406   }
407 
408   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
409     return super.decreaseApproval(_spender, _subtractedValue);
410   }
411 }
412 
413 // File: contracts/Pausable223Token.sol
414 
415 /* ERC223 additions to ERC20 */
416 
417 
418 
419 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/StandardToken.sol";
420 
421 
422 contract Pausable223Token is ERC223, PausableToken {
423   //function that is called when a user or another contract wants to transfer funds
424   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
425     //filtering if the target is a contract with bytecode inside it
426     if (!super.transfer(_to, _value)) revert(); // do a normal token transfer
427     if (isContract(_to)) contractFallback(msg.sender, _to, _value, _data);
428     emit Transfer(msg.sender, _to, _value, _data);
429     return true;
430   }
431 
432   function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool success) {
433     if (!super.transferFrom(_from, _to, _value)) revert(); // do a normal token transfer
434     if (isContract(_to)) contractFallback(_from, _to, _value, _data);
435     emit Transfer(_from, _to, _value, _data);
436     return true;
437   }
438 
439   function transfer(address _to, uint _value) public returns (bool success) {
440     return transfer(_to, _value, new bytes(0));
441   }
442 
443   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
444     return transferFrom(_from, _to, _value, new bytes(0));
445   }
446 
447   //function that is called when transaction target is a contract
448   function contractFallback(address _origin, address _to, uint _value, bytes _data) private {
449     ERC223Receiver reciever = ERC223Receiver(_to);
450     reciever.tokenFallback(_origin, _value, _data);
451   }
452 
453   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
454   function isContract(address _addr) private view returns (bool is_contract) {
455     // retrieve the size of the code on target address, this needs assembly
456     uint length;
457     assembly { length := extcodesize(_addr) }
458     return length > 0;
459   }
460 }
461 
462 // File: contracts/wolf.sol
463 
464 /*
465 Copyright (c) 2018 WiseWolf Ltd
466 Developed by https://adoriasoft.com
467 */
468 
469 pragma solidity ^0.4.23;
470 
471 
472 
473 
474 
475 
476 contract WOLF is BurnableToken, Pausable223Token
477 {
478     string public constant name = "WiseWolf";
479     string public constant symbol = "WOLF";
480     uint8 public constant decimals = 18;
481     uint public constant DECIMALS_MULTIPLIER = 10**uint(decimals);
482     
483     function increaseSupply(uint value, address to) public onlyOwner returns (bool) {
484         totalSupply_ = totalSupply_.add(value);
485         balances[to] = balances[to].add(value);
486         emit Transfer(address(0), to, value);
487         return true;
488     }
489 
490     
491     function transferOwnership(address newOwner) public onlyOwner {
492         require(newOwner != address(0));
493         uint256 localOwnerBalance = balances[owner];
494         balances[newOwner] = balances[newOwner].add(localOwnerBalance);
495         balances[owner] = 0;
496         emit Transfer(owner, newOwner, localOwnerBalance);
497         super.transferOwnership(newOwner);
498     }
499     
500     constructor () public payable {
501       totalSupply_ = 1300000000 * DECIMALS_MULTIPLIER; //1000000000 + 20% bounty + 5% referal bonus + 5% team motivation
502       balances[owner] = totalSupply_;
503       emit Transfer(0x0, owner, totalSupply_);
504     }
505 }