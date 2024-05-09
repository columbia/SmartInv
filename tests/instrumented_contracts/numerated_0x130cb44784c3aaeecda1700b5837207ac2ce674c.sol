1 pragma solidity ^0.4.24;
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
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    */
39   function renounceOwnership() public onlyOwner {
40     emit OwnershipRenounced(owner);
41     owner = address(0);
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param _newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address _newOwner) public onlyOwner {
49     _transferOwnership(_newOwner);
50   }
51 
52   /**
53    * @dev Transfers control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function _transferOwnership(address _newOwner) internal {
57     require(_newOwner != address(0));
58     emit OwnershipTransferred(owner, _newOwner);
59     owner = _newOwner;
60   }
61 }
62 
63 /**
64  * @title SafeMath
65  * @dev Math operations with safety checks that throw on error
66  */
67 library SafeMath {
68 
69   /**
70   * @dev Multiplies two numbers, throws on overflow.
71   */
72   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
74     // benefit is lost if 'b' is also tested.
75     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
76     if (a == 0) {
77       return 0;
78     }
79 
80     c = a * b;
81     assert(c / a == b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // assert(b > 0); // Solidity automatically throws when dividing by 0
90     // uint256 c = a / b;
91     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92     return a / b;
93   }
94 
95   /**
96   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
107     c = a + b;
108     assert(c >= a);
109     return c;
110   }
111 }
112 
113 
114 /**
115  * @title ERC20Basic
116  * @dev Simpler version of ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/179
118  */
119 contract ERC20Basic {
120   function totalSupply() public view returns (uint256);
121   function balanceOf(address who) public view returns (uint256);
122   function transfer(address to, uint256 value) public returns (bool);
123   event Transfer(address indexed from, address indexed to, uint256 value);
124 }
125 
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
146 
147 /**
148  * @title Basic token
149  * @dev Basic version of StandardToken, with no allowances.
150  */
151 contract BasicToken is ERC20Basic {
152   using SafeMath for uint256;
153 
154   mapping(address => uint256) balances;
155 
156   uint256 totalSupply_;
157 
158   /**
159   * @dev total number of tokens in existence
160   */
161   function totalSupply() public view returns (uint256) {
162     return totalSupply_;
163   }
164 
165   /**
166   * @dev transfer token for a specified address
167   * @param _to The address to transfer to.
168   * @param _value The amount to be transferred.
169   */
170   function transfer(address _to, uint256 _value) public returns (bool) {
171     require(_to != address(0));
172     require(_value <= balances[msg.sender]);
173 
174     balances[msg.sender] = balances[msg.sender].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     emit Transfer(msg.sender, _to, _value);
177     return true;
178   }
179 
180   /**
181   * @dev Gets the balance of the specified address.
182   * @param _owner The address to query the the balance of.
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address _owner) public view returns (uint256) {
186     return balances[_owner];
187   }
188 
189 }
190 
191 
192 /**
193  * @title Standard ERC20 token
194  *
195  * @dev Implementation of the basic standard token.
196  * @dev https://github.com/ethereum/EIPs/issues/20
197  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
198  */
199 contract StandardToken is ERC20, BasicToken {
200 
201   mapping (address => mapping (address => uint256)) internal allowed;
202 
203 
204   /**
205    * @dev Transfer tokens from one address to another
206    * @param _from address The address which you want to send tokens from
207    * @param _to address The address which you want to transfer to
208    * @param _value uint256 the amount of tokens to be transferred
209    */
210   function transferFrom(
211     address _from,
212     address _to,
213     uint256 _value
214   )
215     public
216     returns (bool)
217   {
218     require(_to != address(0));
219     require(_value <= balances[_from]);
220     require(_value <= allowed[_from][msg.sender]);
221 
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     emit Transfer(_from, _to, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231    *
232    * Beware that changing an allowance with this method brings the risk that someone may use both the old
233    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    * @param _spender The address which will spend the funds.
237    * @param _value The amount of tokens to be spent.
238    */
239   function approve(address _spender, uint256 _value) public returns (bool) {
240     allowed[msg.sender][_spender] = _value;
241     emit Approval(msg.sender, _spender, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(
252     address _owner,
253     address _spender
254    )
255     public
256     view
257     returns (uint256)
258   {
259     return allowed[_owner][_spender];
260   }
261 
262   /**
263    * @dev Increase the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To increment
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _addedValue The amount of tokens to increase the allowance by.
271    */
272   function increaseApproval(
273     address _spender,
274     uint _addedValue
275   )
276     public
277     returns (bool)
278   {
279     allowed[msg.sender][_spender] = (
280       allowed[msg.sender][_spender].add(_addedValue));
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285   /**
286    * @dev Decrease the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To decrement
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _subtractedValue The amount of tokens to decrease the allowance by.
294    */
295   function decreaseApproval(
296     address _spender,
297     uint _subtractedValue
298   )
299     public
300     returns (bool)
301   {
302     uint oldValue = allowed[msg.sender][_spender];
303     if (_subtractedValue > oldValue) {
304       allowed[msg.sender][_spender] = 0;
305     } else {
306       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
307     }
308     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312 }
313 
314 
315 /**
316  * @title Burnable Token
317  * @dev Token that can be irreversibly burned (destroyed).
318  */
319 contract BurnableToken is BasicToken {
320 
321   event Burn(address indexed burner, uint256 value);
322 
323   /**
324    * @dev Burns a specific amount of tokens.
325    * @param _value The amount of token to be burned.
326    */
327   function burn(uint256 _value) public {
328     _burn(msg.sender, _value);
329   }
330 
331   function _burn(address _who, uint256 _value) internal {
332     require(_value <= balances[_who]);
333     // no need to require value <= totalSupply, since that would imply the
334     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
335 
336     balances[_who] = balances[_who].sub(_value);
337     totalSupply_ = totalSupply_.sub(_value);
338     emit Burn(_who, _value);
339     emit Transfer(_who, address(0), _value);
340   }
341 }
342 
343 /**
344  * @title Pausable
345  * @dev Base contract which allows children to implement an emergency stop mechanism.
346  */
347 contract Pausable is Ownable {
348   event Pause();
349   event Unpause();
350 
351   bool public paused = false;
352 
353 
354   /**
355    * @dev Modifier to make a function callable only when the contract is not paused.
356    */
357   modifier whenNotPaused() {
358     require(!paused);
359     _;
360   }
361 
362   /**
363    * @dev Modifier to make a function callable only when the contract is paused.
364    */
365   modifier whenPaused() {
366     require(paused);
367     _;
368   }
369 
370   /**
371    * @dev called by the owner to pause, triggers stopped state
372    */
373   function pause() public onlyOwner whenNotPaused {
374     paused = true;
375     emit Pause();
376   }
377 
378   /**
379    * @dev called by the owner to unpause, returns to normal state
380    */
381   function unpause() public onlyOwner whenPaused {
382     paused = false;
383     emit Unpause();
384   }
385 }
386 
387 /**
388  * @title Pausable token
389  * @dev StandardToken modified with pausable transfers.
390  **/
391 contract PausableToken is StandardToken, Pausable {
392 
393   function transfer(
394     address _to,
395     uint256 _value
396   )
397     public
398     whenNotPaused
399     returns (bool)
400   {
401     return super.transfer(_to, _value);
402   }
403 
404   function transferFrom(
405     address _from,
406     address _to,
407     uint256 _value
408   )
409     public
410     whenNotPaused
411     returns (bool)
412   {
413     return super.transferFrom(_from, _to, _value);
414   }
415 
416   function approve(
417     address _spender,
418     uint256 _value
419   )
420     public
421     whenNotPaused
422     returns (bool)
423   {
424     return super.approve(_spender, _value);
425   }
426 
427   function increaseApproval(
428     address _spender,
429     uint _addedValue
430   )
431     public
432     whenNotPaused
433     returns (bool success)
434   {
435     return super.increaseApproval(_spender, _addedValue);
436   }
437 
438   function decreaseApproval(
439     address _spender,
440     uint _subtractedValue
441   )
442     public
443     whenNotPaused
444     returns (bool success)
445   {
446     return super.decreaseApproval(_spender, _subtractedValue);
447   }
448 }
449 
450  
451 contract Token  is StandardToken, PausableToken , BurnableToken {
452  mapping(address => bool) internal locks;
453  mapping(address => uint256) internal timelocks;
454  mapping(address => uint256) internal valuelocks;
455 
456 
457   string public  name; 
458   string public  symbol; 
459   uint8 public decimals;
460   address public wallet;
461 
462 
463     constructor( uint256 _initialSupply, string _name, string _symbol, uint8 _decimals,address admin) public {
464         owner = msg.sender;
465         totalSupply_ = _initialSupply;
466         balances[admin] = _initialSupply;
467         wallet = admin;
468         name = _name;
469         symbol = _symbol;
470         decimals = _decimals;
471     }
472 
473     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
474       require(locks[msg.sender] == false);
475       require(timelocks[msg.sender] == 0 ||
476       timelocks[msg.sender] < now ||  
477       balanceOf(msg.sender).sub(valuelocks[msg.sender]) >= _value);
478       super.transfer(_to, _value);
479     }
480 
481     function lock(address addr) public onlyOwner returns (bool) {
482     require(locks[addr] == false);
483     locks[addr] = true;  
484     return true;
485   }
486 
487   function unlock(address addr) public onlyOwner returns (bool) {
488     require(locks[addr] == true);
489     locks[addr] = false; 
490     return true;
491   }
492 
493   function showLock(address addr) public view returns (bool) {
494     return locks[addr];
495   }
496 
497    function resetTimeLockValue(address addr) public onlyOwner returns (bool) {
498     require(locks[addr] == false);
499     require(timelocks[addr] < now); 
500     valuelocks[addr] = 0;
501     return true;
502   }
503 
504   function timelock(address addr, uint256 _releaseTime, uint256 _value) public onlyOwner returns (bool) {
505   require(locks[addr] == false);
506   require(_releaseTime > now); 
507 
508   require(_releaseTime >= timelocks[addr]);
509   require(balanceOf(addr) >= _value); 
510   
511   timelocks[addr] = _releaseTime;
512   valuelocks[addr] = _value; 
513   return true;
514   }
515 
516   function showTimeLock(address addr) public view returns (uint256) {
517     return timelocks[addr];
518   }
519 
520 function showTimeLockValue(address addr) public view returns (uint256) {
521     return valuelocks[addr];
522   }
523 
524   function showTokenValue(address addr) public view returns (uint256) {
525     return balanceOf(addr); 
526   }
527   
528   function Now() public view returns (uint256){
529     return now;
530   }
531 
532     function () public payable {
533     revert();
534   }
535 
536 }