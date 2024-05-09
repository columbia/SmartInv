1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title Math
6  * @dev Assorted math operations
7  */
8 library Math {
9   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
10     return a >= b ? a : b;
11   }
12 
13   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
14     return a < b ? a : b;
15   }
16 
17   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
18     return a >= b ? a : b;
19   }
20 
21   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
22     return a < b ? a : b;
23   }
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return c;
52   }
53 
54   /**
55   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79   address public owner;
80 
81 
82   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84 
85   /**
86    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87    * account.
88    */
89   function Ownable() public {
90     owner = msg.sender;
91   }
92 
93   /**
94    * @dev Throws if called by any account other than the owner.
95    */
96   modifier onlyOwner() {
97     require(msg.sender == owner);
98     _;
99   }
100 
101   /**
102    * @dev Allows the current owner to transfer control of the contract to a newOwner.
103    * @param newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address newOwner) public onlyOwner {
106     require(newOwner != address(0));
107     emit OwnershipTransferred(owner, newOwner);
108     owner = newOwner;
109   }
110 
111 }
112 
113 /**
114  * @title Claimable
115  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
116  * This allows the new owner to accept the transfer.
117  */
118 contract Claimable is Ownable {
119   address public pendingOwner;
120 
121   /**
122    * @dev Modifier throws if called by any account other than the pendingOwner.
123    */
124   modifier onlyPendingOwner() {
125     require(msg.sender == pendingOwner);
126     _;
127   }
128 
129   /**
130    * @dev Allows the current owner to set the pendingOwner address.
131    * @param newOwner The address to transfer ownership to.
132    */
133   function transferOwnership(address newOwner) onlyOwner public {
134     pendingOwner = newOwner;
135   }
136 
137   /**
138    * @dev Allows the pendingOwner address to finalize the transfer.
139    */
140   function claimOwnership() onlyPendingOwner public {
141     emit OwnershipTransferred(owner, pendingOwner);
142     owner = pendingOwner;
143     pendingOwner = address(0);
144   }
145 }
146 
147 
148 /**
149  * @title Pausable
150  * @dev Base contract which allows children to implement an emergency stop mechanism.
151  */
152 contract Pausable is Ownable {
153   event Pause();
154   event Unpause();
155 
156   bool public paused = false;
157 
158 
159   /**
160    * @dev Modifier to make a function callable only when the contract is not paused.
161    */
162   modifier whenNotPaused() {
163     require(!paused);
164     _;
165   }
166 
167   /**
168    * @dev Modifier to make a function callable only when the contract is paused.
169    */
170   modifier whenPaused() {
171     require(paused);
172     _;
173   }
174 
175   /**
176    * @dev called by the owner to pause, triggers stopped state
177    */
178   function pause() onlyOwner whenNotPaused public {
179     paused = true;
180     emit Pause();
181   }
182 
183   /**
184    * @dev called by the owner to unpause, returns to normal state
185    */
186   function unpause() onlyOwner whenPaused public {
187     paused = false;
188     emit Unpause();
189   }
190 }
191 
192 
193 /**
194  * @title ERC20Basic
195  * @dev Simpler version of ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/179
197  */
198 contract ERC20Basic {
199   function totalSupply() public view returns (uint256);
200   function balanceOf(address who) public view returns (uint256);
201   function transfer(address to, uint256 value) public returns (bool);
202   event Transfer(address indexed from, address indexed to, uint256 value);
203 }
204 
205 
206 /**
207  * @title ERC20 interface
208  * @dev see https://github.com/ethereum/EIPs/issues/20
209  */
210 contract ERC20 is ERC20Basic {
211   function allowance(address owner, address spender) public view returns (uint256);
212   function transferFrom(address from, address to, uint256 value) public returns (bool);
213   function approve(address spender, uint256 value) public returns (bool);
214   event Approval(address indexed owner, address indexed spender, uint256 value);
215 }
216 
217 /**
218  * @title Basic token
219  * @dev Basic version of StandardToken, with no allowances.
220  */
221 contract BasicToken is ERC20Basic {
222   using SafeMath for uint256;
223 
224   mapping(address => uint256) balances;
225 
226   uint256 totalSupply_;
227 
228   /**
229   * @dev total number of tokens in existence
230   */
231   function totalSupply() public view returns (uint256) {
232     return totalSupply_;
233   }
234 
235   /**
236   * @dev transfer token for a specified address
237   * @param _to The address to transfer to.
238   * @param _value The amount to be transferred.
239   */
240   function transfer(address _to, uint256 _value) public returns (bool) {
241     require(_to != address(0));
242     require(_value <= balances[msg.sender]);
243 
244     // SafeMath.sub will throw if there is not enough balance.
245     balances[msg.sender] = balances[msg.sender].sub(_value);
246     balances[_to] = balances[_to].add(_value);
247     emit Transfer(msg.sender, _to, _value);
248     return true;
249   }
250 
251   /**
252   * @dev Gets the balance of the specified address.
253   * @param _owner The address to query the the balance of.
254   * @return An uint256 representing the amount owned by the passed address.
255   */
256   function balanceOf(address _owner) public view returns (uint256 balance) {
257     return balances[_owner];
258   }
259 
260 }
261 
262 
263 /**
264  * @title Standard ERC20 token
265  *
266  * @dev Implementation of the basic standard token.
267  * @dev https://github.com/ethereum/EIPs/issues/20
268  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
269  */
270 contract StandardToken is ERC20, BasicToken {
271 
272   mapping (address => mapping (address => uint256)) internal allowed;
273 
274 
275   /**
276    * @dev Transfer tokens from one address to another
277    * @param _from address The address which you want to send tokens from
278    * @param _to address The address which you want to transfer to
279    * @param _value uint256 the amount of tokens to be transferred
280    */
281   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
282     require(_to != address(0));
283     require(_value <= balances[_from]);
284     require(_value <= allowed[_from][msg.sender]);
285 
286     balances[_from] = balances[_from].sub(_value);
287     balances[_to] = balances[_to].add(_value);
288     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
289     emit Transfer(_from, _to, _value);
290     return true;
291   }
292 
293   /**
294    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
295    *
296    * Beware that changing an allowance with this method brings the risk that someone may use both the old
297    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
298    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
299    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
300    * @param _spender The address which will spend the funds.
301    * @param _value The amount of tokens to be spent.
302    */
303   function approve(address _spender, uint256 _value) public returns (bool) {
304     allowed[msg.sender][_spender] = _value;
305     emit Approval(msg.sender, _spender, _value);
306     return true;
307   }
308 
309   /**
310    * @dev Function to check the amount of tokens that an owner allowed to a spender.
311    * @param _owner address The address which owns the funds.
312    * @param _spender address The address which will spend the funds.
313    * @return A uint256 specifying the amount of tokens still available for the spender.
314    */
315   function allowance(address _owner, address _spender) public view returns (uint256) {
316     return allowed[_owner][_spender];
317   }
318 
319   /**
320    * @dev Increase the amount of tokens that an owner allowed to a spender.
321    *
322    * approve should be called when allowed[_spender] == 0. To increment
323    * allowed value is better to use this function to avoid 2 calls (and wait until
324    * the first transaction is mined)
325    * From MonolithDAO Token.sol
326    * @param _spender The address which will spend the funds.
327    * @param _addedValue The amount of tokens to increase the allowance by.
328    */
329   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
330     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
331     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
332     return true;
333   }
334 
335   /**
336    * @dev Decrease the amount of tokens that an owner allowed to a spender.
337    *
338    * approve should be called when allowed[_spender] == 0. To decrement
339    * allowed value is better to use this function to avoid 2 calls (and wait until
340    * the first transaction is mined)
341    * From MonolithDAO Token.sol
342    * @param _spender The address which will spend the funds.
343    * @param _subtractedValue The amount of tokens to decrease the allowance by.
344    */
345   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
346     uint oldValue = allowed[msg.sender][_spender];
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
365   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
366     return super.transfer(_to, _value);
367   }
368 
369   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
370     return super.transferFrom(_from, _to, _value);
371   }
372 
373   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
374     return super.approve(_spender, _value);
375   }
376 
377   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
378     return super.increaseApproval(_spender, _addedValue);
379   }
380 
381   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
382     return super.decreaseApproval(_spender, _subtractedValue);
383   }
384 }
385 
386 
387 contract OperatableBasic {
388     function setPrimaryOperator (address addr) public;
389     function setSecondaryOperator (address addr) public;
390     function isPrimaryOperator(address addr) public view returns (bool);
391     function isSecondaryOperator(address addr) public view returns (bool);
392 }
393 
394 contract Operatable is Ownable, OperatableBasic {
395     address public primaryOperator;
396     address public secondaryOperator;
397 
398     modifier canOperate() {
399         require(msg.sender == primaryOperator || msg.sender == secondaryOperator || msg.sender == owner);
400         _;
401     }
402 
403     function Operatable() public {
404         primaryOperator = owner;
405         secondaryOperator = owner;
406     }
407 
408     function setPrimaryOperator (address addr) public onlyOwner {
409         primaryOperator = addr;
410     }
411 
412     function setSecondaryOperator (address addr) public onlyOwner {
413         secondaryOperator = addr;
414     }
415 
416     function isPrimaryOperator(address addr) public view returns (bool) {
417         return (addr == primaryOperator);
418     }
419 
420     function isSecondaryOperator(address addr) public view returns (bool) {
421         return (addr == secondaryOperator);
422     }
423 }
424 
425 
426 contract XClaimable is Claimable {
427 
428     function cancelOwnershipTransfer() onlyOwner public {
429         pendingOwner = owner;
430     }
431 
432 }
433 
434 
435 contract C3CTokenConfig {
436     string public constant NAME = "CryptoCoin Coin";
437     string public constant SYMBOL = "C3C";
438     uint8 public constant DECIMALS = 18;
439     uint public constant DECIMALSFACTOR = 10 ** uint(DECIMALS);
440     uint public constant TOTALSUPPLY = 42000000 * DECIMALSFACTOR;
441     uint public constant AIRDROP_MAX = 500000 * DECIMALSFACTOR;
442 }
443 
444 contract Salvageable is Operatable {
445     // Salvage other tokens that are accidentally sent into this token
446     function emergencyERC20Drain(ERC20 oddToken, uint amount) public canOperate {
447         if (address(oddToken) == address(0)) {
448             owner.transfer(amount);
449             return;
450         }
451         oddToken.transfer(owner, amount);
452     }
453 }
454 
455 
456 interface tokenRecipient { 
457     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
458 }
459 
460 
461 contract C3CToken is XClaimable, PausableToken, C3CTokenConfig, Salvageable { 
462     using SafeMath for uint;
463 
464     string public name = NAME;
465     string public symbol = SYMBOL;
466     uint8 public decimals = DECIMALS;
467     bool public mintingFinished = false;
468 
469     uint public airdropped;
470     
471 
472     event MintFinished();
473 
474     modifier canMint() {
475         require(!mintingFinished);
476         _;
477     }
478 
479     function mint(address _to, uint _amount) canOperate canMint public returns (bool) {
480         if (msg.sender == secondaryOperator) {
481             require(airdropped.add(_amount) <= AIRDROP_MAX);
482             airdropped = airdropped.add(_amount);
483         } 
484         require(totalSupply_.add(_amount) <= TOTALSUPPLY);
485         totalSupply_ = totalSupply_.add(_amount);
486         balances[_to] = balances[_to].add(_amount);
487         emit Transfer(address(0), _to, _amount);
488         return true;
489     }
490 
491     function finishMinting() onlyOwner canMint public returns (bool) {
492         mintingFinished = true;
493         emit MintFinished();
494         return true;
495     }
496 
497     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
498         public
499         returns (bool success) 
500     {
501         tokenRecipient spender = tokenRecipient(_spender);
502         if (approve(_spender, _value)) {
503             spender.receiveApproval(msg.sender, _value, this, _extraData);
504             return true;
505         }
506     }
507 
508 }