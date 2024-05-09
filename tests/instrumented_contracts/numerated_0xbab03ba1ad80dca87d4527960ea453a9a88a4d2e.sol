1 pragma solidity 0.4.19;
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
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Basic token
28  * @dev Basic version of StandardToken, with no allowances.
29  */
30 contract BasicToken is ERC20Basic {
31   using SafeMath for uint256;
32 
33   mapping(address => uint256) balances;
34 
35   uint256 totalSupply_;
36 
37   /**
38   * @dev total number of tokens in existence
39   */
40   function totalSupply() public view returns (uint256) {
41     return totalSupply_;
42   }
43 
44   /**
45   * @dev transfer token for a specified address
46   * @param _to The address to transfer to.
47   * @param _value The amount to be transferred.
48   */
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51     require(_value <= balances[msg.sender]);
52 
53     // SafeMath.sub will throw if there is not enough balance.
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }
59 
60   /**
61   * @dev Gets the balance of the specified address.
62   * @param _owner The address to query the the balance of.
63   * @return An uint256 representing the amount owned by the passed address.
64   */
65   function balanceOf(address _owner) public view returns (uint256 balance) {
66     return balances[_owner];
67   }
68 
69 }
70 
71 /**
72    @title ERC827 interface, an extension of ERC20 token standard
73 
74    Interface of a ERC827 token, following the ERC20 standard with extra
75    methods to transfer value and data and execute calls in transfers and
76    approvals.
77  */
78 contract ERC827 is ERC20 {
79 
80   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
81   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
82   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
83 }
84 
85 /**
86  * @title Standard ERC20 token
87  *
88  * @dev Implementation of the basic standard token.
89  * @dev https://github.com/ethereum/EIPs/issues/20
90  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
91  */
92 contract StandardToken is ERC20, BasicToken {
93 
94   mapping (address => mapping (address => uint256)) internal allowed;
95 
96 
97   /**
98    * @dev Transfer tokens from one address to another
99    * @param _from address The address which you want to send tokens from
100    * @param _to address The address which you want to transfer to
101    * @param _value uint256 the amount of tokens to be transferred
102    */
103   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[_from]);
106     require(_value <= allowed[_from][msg.sender]);
107 
108     balances[_from] = balances[_from].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
111     Transfer(_from, _to, _value);
112     return true;
113   }
114 
115   /**
116    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
117    *
118    * Beware that changing an allowance with this method brings the risk that someone may use both the old
119    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
120    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
121    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122    * @param _spender The address which will spend the funds.
123    * @param _value The amount of tokens to be spent.
124    */
125   function approve(address _spender, uint256 _value) public returns (bool) {
126     allowed[msg.sender][_spender] = _value;
127     Approval(msg.sender, _spender, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Function to check the amount of tokens that an owner allowed to a spender.
133    * @param _owner address The address which owns the funds.
134    * @param _spender address The address which will spend the funds.
135    * @return A uint256 specifying the amount of tokens still available for the spender.
136    */
137   function allowance(address _owner, address _spender) public view returns (uint256) {
138     return allowed[_owner][_spender];
139   }
140 
141   /**
142    * @dev Increase the amount of tokens that an owner allowed to a spender.
143    *
144    * approve should be called when allowed[_spender] == 0. To increment
145    * allowed value is better to use this function to avoid 2 calls (and wait until
146    * the first transaction is mined)
147    * From MonolithDAO Token.sol
148    * @param _spender The address which will spend the funds.
149    * @param _addedValue The amount of tokens to increase the allowance by.
150    */
151   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
152     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
153     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154     return true;
155   }
156 
157   /**
158    * @dev Decrease the amount of tokens that an owner allowed to a spender.
159    *
160    * approve should be called when allowed[_spender] == 0. To decrement
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    * @param _spender The address which will spend the funds.
165    * @param _subtractedValue The amount of tokens to decrease the allowance by.
166    */
167   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
168     uint oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173     }
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 }
178 
179 /**
180    @title ERC827, an extension of ERC20 token standard
181 
182    Implementation the ERC827, following the ERC20 standard with extra
183    methods to transfer value and data and execute calls in transfers and
184    approvals.
185    Uses OpenZeppelin StandardToken.
186  */
187 contract ERC827Token is ERC827, StandardToken {
188 
189   /**
190      @dev Addition to ERC20 token methods. It allows to
191      approve the transfer of value and execute a call with the sent data.
192 
193      Beware that changing an allowance with this method brings the risk that
194      someone may use both the old and the new allowance by unfortunate
195      transaction ordering. One possible solution to mitigate this race condition
196      is to first reduce the spender's allowance to 0 and set the desired value
197      afterwards:
198      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199 
200      @param _spender The address that will spend the funds.
201      @param _value The amount of tokens to be spent.
202      @param _data ABI-encoded contract call to call `_to` address.
203 
204      @return true if the call function was executed successfully
205    */
206   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
207     require(_spender != address(this));
208 
209     super.approve(_spender, _value);
210 
211     require(_spender.call(_data));
212 
213     return true;
214   }
215 
216   /**
217      @dev Addition to ERC20 token methods. Transfer tokens to a specified
218      address and execute a call with the sent data on the same transaction
219 
220      @param _to address The address which you want to transfer to
221      @param _value uint256 the amout of tokens to be transfered
222      @param _data ABI-encoded contract call to call `_to` address.
223 
224      @return true if the call function was executed successfully
225    */
226   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
227     require(_to != address(this));
228 
229     super.transfer(_to, _value);
230 
231     require(_to.call(_data));
232     return true;
233   }
234 
235   /**
236      @dev Addition to ERC20 token methods. Transfer tokens from one address to
237      another and make a contract call on the same transaction
238 
239      @param _from The address which you want to send tokens from
240      @param _to The address which you want to transfer to
241      @param _value The amout of tokens to be transferred
242      @param _data ABI-encoded contract call to call `_to` address.
243 
244      @return true if the call function was executed successfully
245    */
246   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
247     require(_to != address(this));
248 
249     super.transferFrom(_from, _to, _value);
250 
251     require(_to.call(_data));
252     return true;
253   }
254 
255   /**
256    * @dev Addition to StandardToken methods. Increase the amount of tokens that
257    * an owner allowed to a spender and execute a call with the sent data.
258    *
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _addedValue The amount of tokens to increase the allowance by.
265    * @param _data ABI-encoded contract call to call `_spender` address.
266    */
267   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
268     require(_spender != address(this));
269 
270     super.increaseApproval(_spender, _addedValue);
271 
272     require(_spender.call(_data));
273 
274     return true;
275   }
276 
277   /**
278    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
279    * an owner allowed to a spender and execute a call with the sent data.
280    *
281    * approve should be called when allowed[_spender] == 0. To decrement
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _subtractedValue The amount of tokens to decrease the allowance by.
287    * @param _data ABI-encoded contract call to call `_spender` address.
288    */
289   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
290     require(_spender != address(this));
291 
292     super.decreaseApproval(_spender, _subtractedValue);
293 
294     require(_spender.call(_data));
295 
296     return true;
297   }
298 }
299 
300 /**
301  * @title Ownable
302  * @dev The Ownable contract has an owner address, and provides basic authorization control
303  * functions, this simplifies the implementation of "user permissions".
304  */
305 contract Ownable {
306   address public owner;
307 
308 
309   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
310 
311 
312   /**
313    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
314    * account.
315    */
316   function Ownable() public {
317     owner = msg.sender;
318   }
319 
320   /**
321    * @dev Throws if called by any account other than the owner.
322    */
323   modifier onlyOwner() {
324     require(msg.sender == owner);
325     _;
326   }
327 
328   /**
329    * @dev Allows the current owner to transfer control of the contract to a newOwner.
330    * @param newOwner The address to transfer ownership to.
331    */
332   function transferOwnership(address newOwner) public onlyOwner {
333     require(newOwner != address(0));
334     OwnershipTransferred(owner, newOwner);
335     owner = newOwner;
336   }
337 }
338 
339 /**
340  * @title Mintable token
341  * @dev Simple ERC20 Token example, with mintable token creation
342  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
343  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
344  */
345 contract MintableToken is StandardToken, Ownable {
346   event Mint(address indexed to, uint256 amount);
347   event MintFinished();
348 
349   bool public mintingFinished = false;
350 
351 
352   modifier canMint() {
353     require(!mintingFinished);
354     _;
355   }
356 
357   /**
358    * @dev Function to mint tokens
359    * @param _to The address that will receive the minted tokens.
360    * @param _amount The amount of tokens to mint.
361    * @return A boolean that indicates if the operation was successful.
362    */
363   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
364     totalSupply_ = totalSupply_.add(_amount);
365     balances[_to] = balances[_to].add(_amount);
366     Mint(_to, _amount);
367     Transfer(address(0), _to, _amount);
368     return true;
369   }
370 
371   /**
372    * @dev Function to stop minting new tokens.
373    * @return True if the operation was successful.
374    */
375   function finishMinting() onlyOwner canMint public returns (bool) {
376     mintingFinished = true;
377     MintFinished();
378     return true;
379   }
380 }
381 
382 /**
383  * @title Burnable Token
384  * @dev Token that can be irreversibly burned (destroyed).
385  */
386 contract BurnableToken is BasicToken {
387 
388   event Burn(address indexed burner, uint256 value);
389 
390   /**
391    * @dev Burns a specific amount of tokens.
392    * @param _value The amount of token to be burned.
393    */
394   function burn(uint256 _value) public {
395     require(_value <= balances[msg.sender]);
396     // no need to require value <= totalSupply, since that would imply the
397     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
398 
399     address burner = msg.sender;
400     balances[burner] = balances[burner].sub(_value);
401     totalSupply_ = totalSupply_.sub(_value);
402     Burn(burner, _value);
403   }
404 }
405 
406 /**
407  * @title Pausable
408  * @dev Base contract which allows children to implement an emergency stop mechanism.
409  */
410 contract Pausable is Ownable {
411   event Pause();
412   event Unpause();
413 
414   bool public paused = false;
415 
416 
417   /**
418    * @dev Modifier to make a function callable only when the contract is not paused.
419    */
420   modifier whenNotPaused() {
421     require(!paused);
422     _;
423   }
424 
425   /**
426    * @dev Modifier to make a function callable only when the contract is paused.
427    */
428   modifier whenPaused() {
429     require(paused);
430     _;
431   }
432 
433   /**
434    * @dev called by the owner to pause, triggers stopped state
435    */
436   function pause() onlyOwner whenNotPaused public {
437     paused = true;
438     Pause();
439   }
440 
441   /**
442    * @dev called by the owner to unpause, returns to normal state
443    */
444   function unpause() onlyOwner whenPaused public {
445     paused = false;
446     Unpause();
447   }
448 }
449 
450 /**
451  * @title Pausable token
452  * @dev StandardToken modified with pausable transfers.
453  **/
454 contract PausableToken is StandardToken, Pausable {
455 
456   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
457     return super.transfer(_to, _value);
458   }
459 
460   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
461     return super.transferFrom(_from, _to, _value);
462   }
463 
464   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
465     return super.approve(_spender, _value);
466   }
467 
468   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
469     return super.increaseApproval(_spender, _addedValue);
470   }
471 
472   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
473     return super.decreaseApproval(_spender, _subtractedValue);
474   }
475 }
476 
477 /**
478  * @title Recoverable token
479  * @dev Tokens can be recovered when sent to contract address.
480  **/
481 contract RecoverableToken is Ownable {
482 
483     function recoverLost(ERC20Basic token, address loser, uint amount) public onlyOwner returns (bool) {
484         return token.transfer(loser, amount);
485     }
486 
487 }
488 
489 /**
490  * @title SafeMath
491  * @dev Math operations with safety checks that throw on error
492  */
493 library SafeMath {
494 
495   /**
496   * @dev Multiplies two numbers, throws on overflow.
497   */
498   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
499     if (a == 0) {
500       return 0;
501     }
502     uint256 c = a * b;
503     assert(c / a == b);
504     return c;
505   }
506 
507   /**
508   * @dev Integer division of two numbers, truncating the quotient.
509   */
510   function div(uint256 a, uint256 b) internal pure returns (uint256) {
511     // assert(b > 0); // Solidity automatically throws when dividing by 0
512     uint256 c = a / b;
513     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
514     return c;
515   }
516 
517   /**
518   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
519   */
520   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
521     assert(b <= a);
522     return a - b;
523   }
524 
525   /**
526   * @dev Adds two numbers, throws on overflow.
527   */
528   function add(uint256 a, uint256 b) internal pure returns (uint256) {
529     uint256 c = a + b;
530     assert(c >= a);
531     return c;
532   }
533 }
534 
535 contract DeNetToken is ERC827Token, MintableToken, BurnableToken, PausableToken, RecoverableToken {
536     string public constant name = "DeNet";
537     string public constant symbol = "DNET";
538     uint8 public constant decimals = 18;
539 
540     function DeNetToken() public {
541         pause();
542     }
543 
544     function mintMany(address[] addresses, uint256[] amounts) public onlyOwner canMint {
545         require(addresses.length == amounts.length);
546         for (uint i = 0; i < addresses.length; i++) {
547             require(mint(addresses[i], amounts[i]));
548         }
549     }
550 
551 }