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
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, throws on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return c;
70   }
71 
72   /**
73   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 /**
116    @title ERC827 interface, an extension of ERC20 token standard
117 
118    Interface of a ERC827 token, following the ERC20 standard with extra
119    methods to transfer value and data and execute calls in transfers and
120    approvals.
121  */
122 contract ERC827 is ERC20 {
123 
124   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
125   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
126   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
127 
128 }
129 
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139 
140   uint256 totalSupply_;
141 
142   /**
143   * @dev total number of tokens in existence
144   */
145   function totalSupply() public view returns (uint256) {
146     return totalSupply_;
147   }
148 
149   /**
150   * @dev transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[msg.sender]);
157 
158     // SafeMath.sub will throw if there is not enough balance.
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256 balance) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * @dev https://github.com/ethereum/EIPs/issues/20
182  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
184 contract StandardToken is ERC20, BasicToken {
185 
186   mapping (address => mapping (address => uint256)) internal allowed;
187 
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param _from address The address which you want to send tokens from
192    * @param _to address The address which you want to transfer to
193    * @param _value uint256 the amount of tokens to be transferred
194    */
195   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
196     require(_to != address(0));
197     require(_value <= balances[_from]);
198     require(_value <= allowed[_from][msg.sender]);
199 
200     balances[_from] = balances[_from].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203     Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    *
210    * Beware that changing an allowance with this method brings the risk that someone may use both the old
211    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214    * @param _spender The address which will spend the funds.
215    * @param _value The amount of tokens to be spent.
216    */
217   function approve(address _spender, uint256 _value) public returns (bool) {
218     allowed[msg.sender][_spender] = _value;
219     Approval(msg.sender, _spender, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Function to check the amount of tokens that an owner allowed to a spender.
225    * @param _owner address The address which owns the funds.
226    * @param _spender address The address which will spend the funds.
227    * @return A uint256 specifying the amount of tokens still available for the spender.
228    */
229   function allowance(address _owner, address _spender) public view returns (uint256) {
230     return allowed[_owner][_spender];
231   }
232 
233   /**
234    * @dev Increase the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To increment
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _addedValue The amount of tokens to increase the allowance by.
242    */
243   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
244     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
245     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   /**
250    * @dev Decrease the amount of tokens that an owner allowed to a spender.
251    *
252    * approve should be called when allowed[_spender] == 0. To decrement
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _subtractedValue The amount of tokens to decrease the allowance by.
258    */
259   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
260     uint oldValue = allowed[msg.sender][_spender];
261     if (_subtractedValue > oldValue) {
262       allowed[msg.sender][_spender] = 0;
263     } else {
264       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
265     }
266     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270 }
271 
272 /**
273    @title ERC827, an extension of ERC20 token standard
274 
275    Implementation the ERC827, following the ERC20 standard with extra
276    methods to transfer value and data and execute calls in transfers and
277    approvals.
278    Uses OpenZeppelin StandardToken.
279  */
280 contract ERC827Token is ERC827, StandardToken {
281 
282   /**
283      @dev Addition to ERC20 token methods. It allows to
284      approve the transfer of value and execute a call with the sent data.
285 
286      Beware that changing an allowance with this method brings the risk that
287      someone may use both the old and the new allowance by unfortunate
288      transaction ordering. One possible solution to mitigate this race condition
289      is to first reduce the spender's allowance to 0 and set the desired value
290      afterwards:
291      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292 
293      @param _spender The address that will spend the funds.
294      @param _value The amount of tokens to be spent.
295      @param _data ABI-encoded contract call to call `_to` address.
296 
297      @return true if the call function was executed successfully
298    */
299   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
300     require(_spender != address(this));
301 
302     super.approve(_spender, _value);
303 
304     require(_spender.call(_data));
305 
306     return true;
307   }
308 
309   /**
310      @dev Addition to ERC20 token methods. Transfer tokens to a specified
311      address and execute a call with the sent data on the same transaction
312 
313      @param _to address The address which you want to transfer to
314      @param _value uint256 the amout of tokens to be transfered
315      @param _data ABI-encoded contract call to call `_to` address.
316 
317      @return true if the call function was executed successfully
318    */
319   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
320     require(_to != address(this));
321 
322     super.transfer(_to, _value);
323 
324     require(_to.call(_data));
325     return true;
326   }
327 
328   /**
329      @dev Addition to ERC20 token methods. Transfer tokens from one address to
330      another and make a contract call on the same transaction
331 
332      @param _from The address which you want to send tokens from
333      @param _to The address which you want to transfer to
334      @param _value The amout of tokens to be transferred
335      @param _data ABI-encoded contract call to call `_to` address.
336 
337      @return true if the call function was executed successfully
338    */
339   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
340     require(_to != address(this));
341 
342     super.transferFrom(_from, _to, _value);
343 
344     require(_to.call(_data));
345     return true;
346   }
347 
348   /**
349    * @dev Addition to StandardToken methods. Increase the amount of tokens that
350    * an owner allowed to a spender and execute a call with the sent data.
351    *
352    * approve should be called when allowed[_spender] == 0. To increment
353    * allowed value is better to use this function to avoid 2 calls (and wait until
354    * the first transaction is mined)
355    * From MonolithDAO Token.sol
356    * @param _spender The address which will spend the funds.
357    * @param _addedValue The amount of tokens to increase the allowance by.
358    * @param _data ABI-encoded contract call to call `_spender` address.
359    */
360   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
361     require(_spender != address(this));
362 
363     super.increaseApproval(_spender, _addedValue);
364 
365     require(_spender.call(_data));
366 
367     return true;
368   }
369 
370   /**
371    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
372    * an owner allowed to a spender and execute a call with the sent data.
373    *
374    * approve should be called when allowed[_spender] == 0. To decrement
375    * allowed value is better to use this function to avoid 2 calls (and wait until
376    * the first transaction is mined)
377    * From MonolithDAO Token.sol
378    * @param _spender The address which will spend the funds.
379    * @param _subtractedValue The amount of tokens to decrease the allowance by.
380    * @param _data ABI-encoded contract call to call `_spender` address.
381    */
382   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
383     require(_spender != address(this));
384 
385     super.decreaseApproval(_spender, _subtractedValue);
386 
387     require(_spender.call(_data));
388 
389     return true;
390   }
391 
392 }
393 
394 
395 /**
396  * @title Mintable token
397  * @dev Simple ERC20 Token example, with mintable token creation
398  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
399  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
400  */
401 contract MintableToken is StandardToken, Ownable {
402   event Mint(address indexed to, uint256 amount);
403   event MintFinished();
404 
405   bool public mintingFinished = false;
406 
407 
408   modifier canMint() {
409     require(!mintingFinished);
410     _;
411   }
412 
413   /**
414    * @dev Function to mint tokens
415    * @param _to The address that will receive the minted tokens.
416    * @param _amount The amount of tokens to mint.
417    * @return A boolean that indicates if the operation was successful.
418    */
419   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
420     totalSupply_ = totalSupply_.add(_amount);
421     balances[_to] = balances[_to].add(_amount);
422     Mint(_to, _amount);
423     Transfer(address(0), _to, _amount);
424     return true;
425   }
426 
427   /**
428    * @dev Function to stop minting new tokens.
429    * @return True if the operation was successful.
430    */
431   function finishMinting() onlyOwner canMint public returns (bool) {
432     mintingFinished = true;
433     MintFinished();
434     return true;
435   }
436 }
437 
438 
439 /**
440  * @title Pausable
441  * @dev Base contract which allows children to implement an emergency stop mechanism.
442  */
443 contract Pausable is Ownable {
444   event Pause();
445   event Unpause();
446 
447   bool public paused = false;
448 
449 
450   /**
451    * @dev Modifier to make a function callable only when the contract is not paused.
452    */
453   modifier whenNotPaused() {
454     require(!paused);
455     _;
456   }
457 
458   /**
459    * @dev Modifier to make a function callable only when the contract is paused.
460    */
461   modifier whenPaused() {
462     require(paused);
463     _;
464   }
465 
466   /**
467    * @dev called by the owner to pause, triggers stopped state
468    */
469   function pause() onlyOwner whenNotPaused public {
470     paused = true;
471     Pause();
472   }
473 
474   /**
475    * @dev called by the owner to unpause, returns to normal state
476    */
477   function unpause() onlyOwner whenPaused public {
478     paused = false;
479     Unpause();
480   }
481 }
482 
483 
484 /**
485  * @title Pausable token
486  * @dev StandardToken modified with pausable transfers.
487  **/
488 contract PausableToken is StandardToken, Pausable {
489 
490   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
491     return super.transfer(_to, _value);
492   }
493 
494   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
495     return super.transferFrom(_from, _to, _value);
496   }
497 
498   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
499     return super.approve(_spender, _value);
500   }
501 
502   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
503     return super.increaseApproval(_spender, _addedValue);
504   }
505 
506   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
507     return super.decreaseApproval(_spender, _subtractedValue);
508   }
509 }
510 
511 
512 /**
513    @title Líf, the Winding Tree token
514 
515    Implementation of Líf, the ERC827 token for Winding Tree, an extension of the
516    ERC20 token with extra methods to transfer value and data to execute a call
517    on transfer.
518    Uses OpenZeppelin StandardToken, ERC827Token, MintableToken and PausableToken.
519  */
520 contract LifToken is StandardToken, ERC827Token, MintableToken, PausableToken {
521   // Token Name
522   string public constant NAME = "Líf";
523 
524   // Token Symbol
525   string public constant SYMBOL = "LIF";
526 
527   // Token decimals
528   uint public constant DECIMALS = 18;
529 
530   /**
531    * @dev Burns a specific amount of tokens.
532    *
533    * @param _value The amount of tokens to be burned.
534    */
535   function burn(uint256 _value) public whenNotPaused {
536 
537     require(_value <= balances[msg.sender]);
538 
539     balances[msg.sender] = balances[msg.sender].sub(_value);
540     totalSupply_ = totalSupply_.sub(_value);
541 
542     // a Transfer event to 0x0 can be useful for observers to keep track of
543     // all the Lif by just looking at those events
544     Transfer(msg.sender, address(0), _value);
545   }
546 
547   /**
548    * @dev Burns a specific amount of tokens of an address
549    * This function can be called only by the owner in the minting process
550    *
551    * @param _value The amount of tokens to be burned.
552    */
553   function burn(address burner, uint256 _value) public onlyOwner {
554 
555     require(!mintingFinished);
556 
557     require(_value <= balances[burner]);
558 
559     balances[burner] = balances[burner].sub(_value);
560     totalSupply_ = totalSupply_.sub(_value);
561 
562     // a Transfer event to 0x0 can be useful for observers to keep track of
563     // all the Lif by just looking at those events
564     Transfer(burner, address(0), _value);
565   }
566 }