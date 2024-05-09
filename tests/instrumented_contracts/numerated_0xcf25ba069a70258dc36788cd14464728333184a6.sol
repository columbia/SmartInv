1 pragma solidity ^0.4.23;
2 
3 // File: contracts/ERC20Basic.sol
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
17 // File: contracts/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     if (a == 0) {
30       return 0;
31     }
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 // File: contracts/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 // File: contracts/BurnableToken.sol
112 
113 /**
114  * @title Burnable Token
115  * @dev Token that can be irreversibly burned (destroyed).
116  */
117 contract BurnableToken is BasicToken {
118 
119   event Burn(address indexed burner, uint256 value);
120 
121   /**
122    * @dev Burns a specific amount of tokens.
123    * @param _value The amount of token to be burned.
124    */
125   function burn(uint256 _value) public {
126     _burn(msg.sender, _value);
127   }
128 
129   function _burn(address _who, uint256 _value) internal {
130     require(_value <= balances[_who]);
131     // no need to require value <= totalSupply, since that would imply the
132     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
133 
134     balances[_who] = balances[_who].sub(_value);
135     totalSupply_ = totalSupply_.sub(_value);
136     emit Burn(_who, _value);
137     emit Transfer(_who, address(0), _value);
138   }
139 }
140 
141 // File: contracts/Ownable.sol
142 
143 /**
144  * @title Ownable
145  * @dev The Ownable contract has an owner address, and provides basic authorization control
146  * functions, this simplifies the implementation of "user permissions".
147  */
148 contract Ownable {
149   address public owner;
150 
151 
152   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154 
155   /**
156    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157    * account.
158    */
159   constructor() public {
160     owner = msg.sender;
161   }
162 
163   /**
164    * @dev Throws if called by any account other than the owner.
165    */
166   modifier onlyOwner() {
167     require(msg.sender == owner);
168     _;
169   }
170 
171   /**
172    * @dev Allows the current owner to transfer control of the contract to a newOwner.
173    * @param newOwner The address to transfer ownership to.
174    */
175   function transferOwnership(address newOwner) public onlyOwner {
176     require(newOwner != address(0));
177     emit OwnershipTransferred(owner, newOwner);
178     owner = newOwner;
179   }
180 
181 }
182 
183 // File: contracts/ERC20.sol
184 
185 /**
186  * @title ERC20 interface
187  * @dev see https://github.com/ethereum/EIPs/issues/20
188  */
189 contract ERC20 is ERC20Basic {
190   function allowance(address owner, address spender) public view returns (uint256);
191   function transferFrom(address from, address to, uint256 value) public returns (bool);
192   function approve(address spender, uint256 value) public returns (bool);
193   event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 // File: contracts/ERC223.sol
197 
198 /*
199   ERC223 additions to ERC20
200 
201   Interface wise is ERC20 + data paramenter to transfer and transferFrom.
202  */
203 
204 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20.sol";
205 
206 
207 contract ERC223 is ERC20 {
208   function transfer(address to, uint value, bytes data) public returns (bool ok);
209   function transferFrom(address from, address to, uint value, bytes data) public returns (bool ok);
210   
211   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
212 }
213 
214 // File: contracts/ERC223Receiver.sol
215 
216 /*
217 Base class contracts willing to accept ERC223 token transfers must conform to.
218 
219 Sender: msg.sender to the token contract, the address originating the token transfer.
220           - For user originated transfers sender will be equal to tx.origin
221           - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.
222 Origin: the origin address from whose balance the tokens are sent
223           - For transfer(), origin = msg.sender
224           - For transferFrom() origin = _from to token contract
225 Value is the amount of tokens sent
226 Data is arbitrary data sent with the token transfer. Simulates ether tx.data
227 
228 From, origin and value shouldn't be trusted unless the token contract is trusted.
229 If sender == tx.origin, it is safe to trust it regardless of the token.
230 */
231 
232 contract ERC223Receiver {
233   function tokenFallback(address _from, uint _value, bytes _data) public;
234 }
235 
236 // File: contracts/Pausable.sol
237 
238 /**
239  * @title Pausable
240  * @dev Base contract which allows children to implement an emergency stop mechanism.
241  */
242 contract Pausable is Ownable {
243   event Pause();
244   event Unpause();
245 
246   bool public paused = false;
247 
248 
249   /**
250    * @dev Modifier to make a function callable only when the contract is not paused.
251    */
252   modifier whenNotPaused() {
253     require(!paused);
254     _;
255   }
256 
257   /**
258    * @dev Modifier to make a function callable only when the contract is paused.
259    */
260   modifier whenPaused() {
261     require(paused);
262     _;
263   }
264 
265   /**
266    * @dev called by the owner to pause, triggers stopped state
267    */
268   function pause() onlyOwner whenNotPaused public {
269     paused = true;
270     emit Pause();
271   }
272 
273   /**
274    * @dev called by the owner to unpause, returns to normal state
275    */
276   function unpause() onlyOwner whenPaused public {
277     paused = false;
278     emit Unpause();
279   }
280 }
281 
282 // File: contracts/StandardToken.sol
283 
284 /**
285  * @title Standard ERC20 token
286  *
287  * @dev Implementation of the basic standard token.
288  * @dev https://github.com/ethereum/EIPs/issues/20
289  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
290  */
291 contract StandardToken is ERC20, BasicToken {
292 
293   mapping (address => mapping (address => uint256)) internal allowed;
294 
295 
296   /**
297    * @dev Transfer tokens from one address to another
298    * @param _from address The address which you want to send tokens from
299    * @param _to address The address which you want to transfer to
300    * @param _value uint256 the amount of tokens to be transferred
301    */
302   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
303     require(_to != address(0));
304     require(_value <= balances[_from]);
305     require(_value <= allowed[_from][msg.sender]);
306 
307     balances[_from] = balances[_from].sub(_value);
308     balances[_to] = balances[_to].add(_value);
309     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
310     emit Transfer(_from, _to, _value);
311     return true;
312   }
313 
314   /**
315    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
316    *
317    * Beware that changing an allowance with this method brings the risk that someone may use both the old
318    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
319    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
320    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
321    * @param _spender The address which will spend the funds.
322    * @param _value The amount of tokens to be spent.
323    */
324   function approve(address _spender, uint256 _value) public returns (bool) {
325     allowed[msg.sender][_spender] = _value;
326     emit Approval(msg.sender, _spender, _value);
327     return true;
328   }
329 
330   /**
331    * @dev Function to check the amount of tokens that an owner allowed to a spender.
332    * @param _owner address The address which owns the funds.
333    * @param _spender address The address which will spend the funds.
334    * @return A uint256 specifying the amount of tokens still available for the spender.
335    */
336   function allowance(address _owner, address _spender) public view returns (uint256) {
337     return allowed[_owner][_spender];
338   }
339 
340   /**
341    * @dev Increase the amount of tokens that an owner allowed to a spender.
342    *
343    * approve should be called when allowed[_spender] == 0. To increment
344    * allowed value is better to use this function to avoid 2 calls (and wait until
345    * the first transaction is mined)
346    * From MonolithDAO Token.sol
347    * @param _spender The address which will spend the funds.
348    * @param _addedValue The amount of tokens to increase the allowance by.
349    */
350   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
351     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
352     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
353     return true;
354   }
355 
356   /**
357    * @dev Decrease the amount of tokens that an owner allowed to a spender.
358    *
359    * approve should be called when allowed[_spender] == 0. To decrement
360    * allowed value is better to use this function to avoid 2 calls (and wait until
361    * the first transaction is mined)
362    * From MonolithDAO Token.sol
363    * @param _spender The address which will spend the funds.
364    * @param _subtractedValue The amount of tokens to decrease the allowance by.
365    */
366   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
367     uint oldValue = allowed[msg.sender][_spender];
368     if (_subtractedValue > oldValue) {
369       allowed[msg.sender][_spender] = 0;
370     } else {
371       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
372     }
373     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
374     return true;
375   }
376 
377 }
378 
379 // File: contracts/PausableToken.sol
380 
381 /**
382  * @title Pausable token
383  * @dev StandardToken modified with pausable transfers.
384  **/
385 contract PausableToken is StandardToken, Pausable {
386 
387   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
388     return super.transfer(_to, _value);
389   }
390 
391   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
392     return super.transferFrom(_from, _to, _value);
393   }
394 
395   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
396     return super.approve(_spender, _value);
397   }
398 
399   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
400     return super.increaseApproval(_spender, _addedValue);
401   }
402 
403   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
404     return super.decreaseApproval(_spender, _subtractedValue);
405   }
406 }
407 
408 // File: contracts/Pausable223Token.sol
409 
410 /* ERC223 additions to ERC20 */
411 
412 
413 
414 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/StandardToken.sol";
415 
416 
417 contract Pausable223Token is ERC223, PausableToken {
418   //function that is called when a user or another contract wants to transfer funds
419   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
420     //filtering if the target is a contract with bytecode inside it
421     if (!super.transfer(_to, _value)) revert(); // do a normal token transfer
422     if (isContract(_to)) contractFallback(msg.sender, _to, _value, _data);
423     emit Transfer(msg.sender, _to, _value, _data);
424     return true;
425   }
426 
427   function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool success) {
428     if (!super.transferFrom(_from, _to, _value)) revert(); // do a normal token transfer
429     if (isContract(_to)) contractFallback(_from, _to, _value, _data);
430     emit Transfer(_from, _to, _value, _data);
431     return true;
432   }
433 
434   function transfer(address _to, uint _value) public returns (bool success) {
435     return transfer(_to, _value, new bytes(0));
436   }
437 
438   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
439     return transferFrom(_from, _to, _value, new bytes(0));
440   }
441 
442   //function that is called when transaction target is a contract
443   function contractFallback(address _origin, address _to, uint _value, bytes _data) private {
444     ERC223Receiver reciever = ERC223Receiver(_to);
445     reciever.tokenFallback(_origin, _value, _data);
446   }
447 
448   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
449   function isContract(address _addr) private view returns (bool is_contract) {
450     // retrieve the size of the code on target address, this needs assembly
451     uint length;
452     assembly { length := extcodesize(_addr) }
453     return length > 0;
454   }
455 }
456 
457 // File: contracts/wolf.sol
458 
459 /*
460 Copyright (c) 2018 WiseWolf Ltd
461 Developed by https://adoriasoft.com
462 */
463 
464 pragma solidity ^0.4.23;
465 
466 
467 
468 
469 
470 
471 contract WOLF is BurnableToken, Pausable223Token
472 {
473     string public constant name = "TestToken";
474     string public constant symbol = "TTK";
475     uint8 public constant decimals = 18;
476     uint public constant DECIMALS_MULTIPLIER = 10**uint(decimals);
477     
478     function increaseSupply(uint value, address to) public onlyOwner returns (bool) {
479         totalSupply_ = totalSupply_.add(value);
480         balances[to] = balances[to].add(value);
481         emit Transfer(address(0), to, value);
482         return true;
483     }
484 
485     
486     function transferOwnership(address newOwner) public onlyOwner {
487         require(newOwner != address(0));
488         uint256 localOwnerBalance = balances[owner];
489         balances[newOwner] = balances[newOwner].add(localOwnerBalance);
490         balances[owner] = 0;
491         emit Transfer(owner, newOwner, localOwnerBalance);
492         super.transferOwnership(newOwner);
493     }
494     
495     constructor () public payable {
496       totalSupply_ = 1300000000 * DECIMALS_MULTIPLIER; //1000000000 + 20% bounty + 5% referal bonus + 5% team motivation
497       balances[owner] = totalSupply_;
498       emit Transfer(0x0, owner, totalSupply_);
499     }
500 }