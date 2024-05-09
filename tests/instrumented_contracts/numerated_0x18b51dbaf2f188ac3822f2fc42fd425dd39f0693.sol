1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 Interface
5  * @dev https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   function allowance(address owner, address spender) public view returns (uint256);
12   function approve(address spender, uint256 value) public returns (bool);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 
19 /**
20  * @title Ownable
21  * @dev The Ownable contract has an owner address, and provides basic authorization control
22  * functions, this simplifies the implementation of "user permissions".
23  */
24 contract Ownable {
25   address public owner;
26 
27 
28   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   constructor() public {
36     owner = msg.sender;
37   }
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     emit OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
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
69   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70     if (a == 0) {
71       return 0;
72     }
73     uint256 c = a * b;
74     assert(c / a == b);
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers, truncating the quotient.
80   */
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     // uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return a / b;
86   }
87 
88   /**
89   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   /**
97   * @dev Adds two numbers, throws on overflow.
98   */
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 
107 /**
108  * @title Standard ERC20 token
109  *
110  * @dev Implementation of the basic standard token.
111  * @dev https://github.com/ethereum/EIPs/issues/20
112  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113  */
114 contract StandardToken is ERC20 {
115   using SafeMath for uint256;
116 
117   uint256 totalSupply_;
118   mapping (address => uint256) balances;
119   mapping (address => mapping (address => uint256)) internal allowed;
120 
121   /**
122   * @dev total number of tokens in existence
123   */
124   function totalSupply() public view returns (uint256) {
125     return totalSupply_;
126   }
127 
128   /**
129   * @dev transfer token for a specified address
130   * @param _to The address to transfer to.
131   * @param _value The amount to be transferred.
132   */
133   function transfer(address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[msg.sender]);
136 
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     emit Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[_from]);
161     require(_value <= allowed[_from][msg.sender]);
162 
163     balances[_from] = balances[_from].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166     emit Transfer(_from, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    *
173    * To avoid the following issue, check if allowance is set to 0.  Only when it's set 0, it can update the allowance.
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     require(allowed[msg.sender][_spender] == 0 || _value == 0);
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) public view returns (uint256) {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To decrement
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _subtractedValue The amount of tokens to decrease the allowance by.
220    */
221   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
222     uint oldValue = allowed[msg.sender][_spender];
223     if (_subtractedValue > oldValue) {
224       allowed[msg.sender][_spender] = 0;
225     } else {
226       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227     }
228     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232 }
233 
234 
235 /**
236  * @title Mintable token
237  * @dev Simple ERC20 Token example, with mintable token creation
238  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
239  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
240  */
241 contract MintableToken is StandardToken, Ownable {
242   event Mint(address indexed to, uint256 amount);
243   event MintFinished();
244 
245   bool public mintingFinished = false;
246 
247 
248   modifier canMint() {
249     require(!mintingFinished);
250     _;
251   }
252 
253   /**
254    * @dev Function to mint tokens
255    * @param _to The address that will receive the minted tokens.
256    * @param _amount The amount of tokens to mint.
257    * @return A boolean that indicates if the operation was successful.
258    */
259   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
260     totalSupply_ = totalSupply_.add(_amount);
261     balances[_to] = balances[_to].add(_amount);
262     emit Mint(_to, _amount);
263     emit Transfer(address(0), _to, _amount);
264     return true;
265   }
266 
267   /**
268    * @dev Function to stop minting new tokens.
269    * @return True if the operation was successful.
270    */
271   function finishMinting() onlyOwner canMint public returns (bool) {
272     mintingFinished = true;
273     emit MintFinished();
274     return true;
275   }
276 }
277 
278 
279 /**
280  * @title Capped token
281  * @dev Mintable token with a token cap.
282  */
283 contract CappedToken is MintableToken {
284 
285   uint256 public cap;
286 
287   constructor(uint256 _cap) public {
288     require(_cap > 0);
289     cap = _cap;
290   }
291 
292   /**
293    * @dev Function to mint tokens
294    * @param _to The address that will receive the minted tokens.
295    * @param _amount The amount of tokens to mint.
296    * @return A boolean that indicates if the operation was successful.
297    */
298   function mint(
299     address _to,
300     uint256 _amount
301   )
302     public
303     returns (bool)
304   {
305     require(totalSupply_.add(_amount) <= cap);
306 
307     return super.mint(_to, _amount);
308   }
309 
310 }
311 
312 
313 /**
314  * @title Pausable
315  * @dev Base contract which allows children to implement an emergency stop mechanism.
316  */
317 contract Pausable is Ownable {
318   event Pause();
319   event Unpause();
320 
321   bool public paused = false;
322 
323 
324   /**
325    * @dev Modifier to make a function callable only when the contract is not paused.
326    */
327   modifier whenNotPaused() {
328     require(!paused);
329     _;
330   }
331 
332   /**
333    * @dev Modifier to make a function callable only when the contract is paused.
334    */
335   modifier whenPaused() {
336     require(paused);
337     _;
338   }
339 
340   /**
341    * @dev called by the owner to pause, triggers stopped state
342    */
343   function pause() onlyOwner whenNotPaused public {
344     paused = true;
345     emit Pause();
346   }
347 
348   /**
349    * @dev called by the owner to unpause, returns to normal state
350    */
351   function unpause() onlyOwner whenPaused public {
352     paused = false;
353     emit Unpause();
354   }
355 }
356 
357 
358 /**
359  * @title Pausable token
360  * @dev StandardToken modified with pausable transfers.
361  **/
362 contract PausableToken is StandardToken, Pausable {
363 
364   function transfer(
365     address _to,
366     uint256 _value
367   )
368     public
369     whenNotPaused
370     returns (bool)
371   {
372     return super.transfer(_to, _value);
373   }
374 
375   function transferFrom(
376     address _from,
377     address _to,
378     uint256 _value
379   )
380     public
381     whenNotPaused
382     returns (bool)
383   {
384     return super.transferFrom(_from, _to, _value);
385   }
386 
387   function approve(
388     address _spender,
389     uint256 _value
390   )
391     public
392     whenNotPaused
393     returns (bool)
394   {
395     return super.approve(_spender, _value);
396   }
397 
398   function increaseApproval(
399     address _spender,
400     uint _addedValue
401   )
402     public
403     whenNotPaused
404     returns (bool success)
405   {
406     return super.increaseApproval(_spender, _addedValue);
407   }
408 
409   function decreaseApproval(
410     address _spender,
411     uint _subtractedValue
412   )
413     public
414     whenNotPaused
415     returns (bool success)
416   {
417     return super.decreaseApproval(_spender, _subtractedValue);
418   }
419 }
420 
421 
422 /**
423  * @title Terminateable
424  * @dev Base contract which allows children to implement an permanent stop mechanism.
425  */
426 contract Terminateable is Ownable {
427   event Terminate();
428 
429   bool public terminated = false;
430   
431   /**
432    * @dev Modifier to make a function callable only when the contract is not terminated.
433    */
434   modifier whenNotTerminated() {
435     require(!terminated);
436     _;
437   }
438 
439   /**
440    * @dev called by the owner to pause, triggers stopped state
441    */
442   function terminate() onlyOwner public {
443     terminated = true;
444     emit Terminate();
445   }
446 
447 }
448 
449 
450 /**
451  * @title Pausable token
452  * @dev StandardToken modified with pausable transfers.
453  **/
454 contract TerminateableToken is MintableToken, Terminateable {
455 
456   function mint(
457     address _to,
458     uint256 _value
459   ) 
460     public
461     whenNotTerminated
462     returns (bool)
463   {
464     return super.mint(_to, _value);
465   }
466 
467   function transfer(
468     address _to,
469     uint256 _value
470   )
471     public
472     whenNotTerminated
473     returns (bool)
474   {
475     return super.transfer(_to, _value);
476   }
477 
478   function transferFrom(
479     address _from,
480     address _to,
481     uint256 _value
482   )
483     public
484     whenNotTerminated
485     returns (bool)
486   {
487     return super.transferFrom(_from, _to, _value);
488   }
489 
490   function approve(
491     address _spender,
492     uint256 _value
493   )
494     public
495     whenNotTerminated
496     returns (bool)
497   {
498     return super.approve(_spender, _value);
499   }
500 
501   function increaseApproval(
502     address _spender,
503     uint _addedValue
504   )
505     public
506     whenNotTerminated
507     returns (bool success)
508   {
509     return super.increaseApproval(_spender, _addedValue);
510   }
511 
512   function decreaseApproval(
513     address _spender,
514     uint _subtractedValue
515   )
516     public
517     whenNotTerminated
518     returns (bool success)
519   {
520     return super.decreaseApproval(_spender, _subtractedValue);
521   }
522 }
523 
524 contract OSEToken is PausableToken, TerminateableToken, CappedToken {
525     string public name = "OSE-V";
526     string public symbol = "OSEV";
527     uint8 public decimals = 8;
528     string public icon = "QmdXK2rRCQkQtRm2YZpVsDG3ERn3yqtpFetPEjiNQquQFx";
529 
530     constructor () public CappedToken(50000000000000000){}
531 }