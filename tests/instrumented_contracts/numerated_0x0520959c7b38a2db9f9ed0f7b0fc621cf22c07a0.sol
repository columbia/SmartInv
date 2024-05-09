1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     Unpause();
85   }
86 }
87 
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  */
93 library SafeMath {
94 
95   /**
96   * @dev Multiplies two numbers, throws on overflow.
97   */
98   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99     if (a == 0) {
100       return 0;
101     }
102     uint256 c = a * b;
103     assert(c / a == b);
104     return c;
105   }
106 
107   /**
108   * @dev Integer division of two numbers, truncating the quotient.
109   */
110   function div(uint256 a, uint256 b) internal pure returns (uint256) {
111     // assert(b > 0); // Solidity automatically throws when dividing by 0
112     uint256 c = a / b;
113     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114     return c;
115   }
116 
117   /**
118   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
119   */
120   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121     assert(b <= a);
122     return a - b;
123   }
124 
125   /**
126   * @dev Adds two numbers, throws on overflow.
127   */
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     assert(c >= a);
131     return c;
132   }
133 }
134 
135 /**
136  * @title ERC20Basic
137  * @dev Simpler version of ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/179
139  */
140 contract ERC20Basic {
141   function totalSupply() public view returns (uint256);
142   function balanceOf(address who) public view returns (uint256);
143   function transfer(address to, uint256 value) public returns (bool);
144   event Transfer(address indexed from, address indexed to, uint256 value);
145 }
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152   function allowance(address owner, address spender) public view returns (uint256);
153   function transferFrom(address from, address to, uint256 value) public returns (bool);
154   function approve(address spender, uint256 value) public returns (bool);
155   event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 /**
159  * @title SafeERC20
160  * @dev Wrappers around ERC20 operations that throw on failure.
161  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
162  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
163  */
164 library SafeERC20 {
165   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
166     assert(token.transfer(to, value));
167   }
168 
169   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
170     assert(token.transferFrom(from, to, value));
171   }
172 
173   function safeApprove(ERC20 token, address spender, uint256 value) internal {
174     assert(token.approve(spender, value));
175   }
176 }
177 /**
178  * @title Basic token
179  * @dev Basic version of StandardToken, with no allowances.
180  */
181 contract BasicToken is ERC20Basic {
182   using SafeMath for uint256;
183 
184   mapping(address => uint256) balances;
185 
186   uint256 totalSupply_;
187 
188   /**
189   * @dev total number of tokens in existence
190   */
191   function totalSupply() public view returns (uint256) {
192     return totalSupply_;
193   }
194 
195   /**
196   * @dev transfer token for a specified address
197   * @param _to The address to transfer to.
198   * @param _value The amount to be transferred.
199   */
200   function transfer(address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[msg.sender]);
203 
204     // SafeMath.sub will throw if there is not enough balance.
205     balances[msg.sender] = balances[msg.sender].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     Transfer(msg.sender, _to, _value);
208     return true;
209   }
210 
211   /**
212   * @dev Gets the balance of the specified address.
213   * @param _owner The address to query the the balance of.
214   * @return An uint256 representing the amount owned by the passed address.
215   */
216   function balanceOf(address _owner) public view returns (uint256 balance) {
217     return balances[_owner];
218   }
219 
220 }
221 
222 /**
223  * @title Standard ERC20 token
224  *
225  * @dev Implementation of the basic standard token.
226  * @dev https://github.com/ethereum/EIPs/issues/20
227  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
228  */
229 contract StandardToken is ERC20, BasicToken {
230 
231   mapping (address => mapping (address => uint256)) internal allowed;
232 
233 
234   /**
235    * @dev Transfer tokens from one address to another
236    * @param _from address The address which you want to send tokens from
237    * @param _to address The address which you want to transfer to
238    * @param _value uint256 the amount of tokens to be transferred
239    */
240   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
241     require(_to != address(0));
242     require(_value <= balances[_from]);
243     require(_value <= allowed[_from][msg.sender]);
244 
245     balances[_from] = balances[_from].sub(_value);
246     balances[_to] = balances[_to].add(_value);
247     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
248     Transfer(_from, _to, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
254    *
255    * Beware that changing an allowance with this method brings the risk that someone may use both the old
256    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259    * @param _spender The address which will spend the funds.
260    * @param _value The amount of tokens to be spent.
261    */
262   function approve(address _spender, uint256 _value) public returns (bool) {
263     allowed[msg.sender][_spender] = _value;
264     Approval(msg.sender, _spender, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Function to check the amount of tokens that an owner allowed to a spender.
270    * @param _owner address The address which owns the funds.
271    * @param _spender address The address which will spend the funds.
272    * @return A uint256 specifying the amount of tokens still available for the spender.
273    */
274   function allowance(address _owner, address _spender) public view returns (uint256) {
275     return allowed[_owner][_spender];
276   }
277 
278   /**
279    * @dev Increase the amount of tokens that an owner allowed to a spender.
280    *
281    * approve should be called when allowed[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   /**
295    * @dev Decrease the amount of tokens that an owner allowed to a spender.
296    *
297    * approve should be called when allowed[_spender] == 0. To decrement
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param _spender The address which will spend the funds.
302    * @param _subtractedValue The amount of tokens to decrease the allowance by.
303    */
304   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
305     uint oldValue = allowed[msg.sender][_spender];
306     if (_subtractedValue > oldValue) {
307       allowed[msg.sender][_spender] = 0;
308     } else {
309       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
310     }
311     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312     return true;
313   }
314 
315 }
316 
317 
318 /**
319  * @title Mintable token
320  * @dev Simple ERC20 Token example, with mintable token creation
321  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
322  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
323  */
324 contract MintableToken is StandardToken, Ownable {
325   event Mint(address indexed to, uint256 amount);
326   event MintFinished();
327 
328   bool public mintingFinished = false;
329 
330 
331   modifier canMint() {
332     require(!mintingFinished);
333     _;
334   }
335 
336   /**
337    * @dev Function to mint tokens
338    * @param _to The address that will receive the minted tokens.
339    * @param _amount The amount of tokens to mint.
340    * @return A boolean that indicates if the operation was successful.
341    */
342   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
343     totalSupply_ = totalSupply_.add(_amount);
344     balances[_to] = balances[_to].add(_amount);
345     Mint(_to, _amount);
346     Transfer(address(0), _to, _amount);
347     return true;
348   }
349 
350   /**
351    * @dev Function to stop minting new tokens.
352    * @return True if the operation was successful.
353    */
354   function finishMinting() onlyOwner canMint public returns (bool) {
355     mintingFinished = true;
356     MintFinished();
357     return true;
358   }
359 }
360 /**
361  * @title Pausable token
362  * @dev StandardToken modified with pausable transfers.
363  **/
364 contract PausableToken is StandardToken, Pausable {
365 
366   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
367     return super.transfer(_to, _value);
368   }
369 
370   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
371     return super.transferFrom(_from, _to, _value);
372   }
373 
374   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
375     return super.approve(_spender, _value);
376   }
377 
378   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
379     return super.increaseApproval(_spender, _addedValue);
380   }
381 
382   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
383     return super.decreaseApproval(_spender, _subtractedValue);
384   }
385 }
386 /**
387  * @title Capped token
388  * @dev Mintable token with a token cap.
389  */
390 contract CappedToken is MintableToken {
391 
392   uint256 public cap;
393 
394   function CappedToken(uint256 _cap) public {
395     require(_cap > 0);
396     cap = _cap;
397   }
398 
399   /**
400    * @dev Function to mint tokens
401    * @param _to The address that will receive the minted tokens.
402    * @param _amount The amount of tokens to mint.
403    * @return A boolean that indicates if the operation was successful.
404    */
405   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
406     require(totalSupply_.add(_amount) <= cap);
407 
408     return super.mint(_to, _amount);
409   }
410 
411 }
412 
413 contract CommunityCoin is CappedToken, PausableToken {
414 
415   using SafeMath for uint;
416 
417   string public constant symbol = "CTC";
418 
419   string public constant name = "Coin of The Community";
420 
421   uint8 public constant decimals = 18;
422 
423   uint public constant unit = 10 ** uint256(decimals);
424   
425   uint public lockPeriod = 90 days;
426   
427   uint public startTime;
428 
429   function CommunityCoin(uint _startTime,uint _tokenCap) CappedToken(_tokenCap.mul(unit)) public {
430       totalSupply_ = 0;
431       startTime=_startTime;
432       pause();
433     }
434     
435      function unpause() onlyOwner whenPaused public {
436     require(now > startTime + lockPeriod);
437     super.unpause();
438   }
439 
440   function setLockPeriod(uint _period) onlyOwner public {
441     lockPeriod = _period;
442   }
443 
444   function () payable public {
445         revert();
446     }
447 
448 
449 }
450 
451 
452 contract TokenLocker is Ownable, ERC20Basic {
453     using SafeERC20 for CommunityCoin;
454     using SafeMath for uint;
455 
456     CommunityCoin public token;
457 
458     string public constant symbol = "CTCX";
459 
460     string public constant name = "CTC(locked)";
461 
462     uint8 public constant decimals = 18;
463 
464     mapping(address => uint) balances;
465 
466     uint private pool;
467 
468     uint public releaseTime;
469 
470     uint constant public lockPeriod = 180 days;
471 
472     event TokenReleased(address _to, uint _value);
473     
474     
475     function TokenLocker(CommunityCoin _token) public {
476         token = _token;
477         releaseTime = token.startTime().add(lockPeriod);
478     }
479 
480     function totalSupply() view public returns(uint){
481         return pool;
482     }
483 
484     function balanceOf(address _who) view public returns(uint balance) {
485         return balances[_who];
486     }
487 
488     function deposite() public onlyOwner {
489         uint newPool = token.balanceOf(this);
490         require(newPool > pool);
491         uint amount = newPool.sub(pool);
492         pool = newPool;
493         balances[owner] = balances[owner].add(amount); 
494         Transfer(address(0), owner, amount);
495     }
496 
497     function transfer(address _to, uint256 _value) public returns (bool) {
498         require(_to != address(0));
499         require(_value <= balances[msg.sender]);
500 
501         // SafeMath.sub will throw if there is not enough balance.
502         balances[msg.sender] = balances[msg.sender].sub(_value);
503         balances[_to] = balances[_to].add(_value);
504         Transfer(msg.sender, _to, _value);
505         return true;
506     }
507 
508     function release() public {
509         require(now >= releaseTime);
510         uint amount = balances[msg.sender];
511         require(amount > 0);
512         require(pool >= amount);
513         balances[msg.sender] = 0;
514         pool = pool.sub(amount);
515         token.safeTransfer(msg.sender,amount);
516         Transfer(msg.sender,address(0), amount);
517         TokenReleased(msg.sender,amount);
518     }
519 
520     function setToken(address tokenAddress) onlyOwner public {
521         token = CommunityCoin(tokenAddress);
522     }
523 
524     function setReleaseTime(uint _time) onlyOwner public {
525         releaseTime = _time;
526     }
527 
528     function () payable public{
529         revert();
530     }
531 }