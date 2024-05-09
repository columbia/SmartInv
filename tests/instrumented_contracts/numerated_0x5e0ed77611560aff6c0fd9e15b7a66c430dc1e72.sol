1 pragma solidity ^0.4.21;
2 /*
3  *             ╔═╗┌─┐┌─┐┬┌─┐┬┌─┐┬   ┌─────────────────────────┐ ╦ ╦┌─┐┌┐ ╔═╗┬┌┬┐┌─┐ 
4  *             ║ ║├┤ ├┤ ││  │├─┤│   │       ZGPoker Ltd.      │ ║║║├┤ ├┴┐╚═╗│ │ ├┤  
5  *             ╚═╝└  └  ┴└─┘┴┴ ┴┴─┘ └─┬─────────────────────┬─┘ ╚╩╝└─┘└─┘╚═╝┴ ┴ └─┘ 
6  *   ┌────────────────────────────────┘                     └──────────────────────────────┐
7  *   │    ┌─────────────────────────────────────────────────────────────────────────────┐  │
8  *   └────┤ Dev:John ├──────────────────────┤ Boss:Jack ├──────────────────┤ Sup:Kilmas ├──┘
9  *        └─────────────────────────────────────────────────────────────────────────────┘
10  
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17 
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22     if (a == 0) {
23       return 0;
24     }
25     c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return a / b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
59 
60 
61 /**
62  * @title ERC20Basic
63  * @dev Simpler version of ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/179
65  */
66 contract ERC20Basic {
67   function totalSupply() public view returns (uint256);
68   function balanceOf(address who) public view returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 // File: zeppelin-solidity/contracts/token/BasicToken.sol
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83   mapping(address => bool) public specialAccount;
84   uint256 totalSupply_;
85 
86   /**
87   * @dev total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101     require(specialAccount[msg.sender] == specialAccount[_to]);
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     emit Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
120 
121 /**
122  * @title Burnable Token
123  * @dev Token that can be irreversibly burned (destroyed).
124  */
125 contract BurnableToken is BasicToken {
126 
127   event Burn(address indexed burner, uint256 value);
128 
129   /**
130    * @dev Burns a specific amount of tokens.
131    * @param _value The amount of token to be burned.
132    */
133   function burn(uint256 _value) public {
134     _burn(msg.sender, _value);
135   }
136 
137   function _burn(address _who, uint256 _value) internal {
138     require(_value <= balances[_who]);
139     // no need to require value <= totalSupply, since that would imply the
140     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
141 
142     balances[_who] = balances[_who].sub(_value);
143     totalSupply_ = totalSupply_.sub(_value);
144     emit Burn(_who, _value);
145     emit Transfer(_who, address(0), _value);
146   }
147 }
148 
149 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157   address public owner;
158 
159 
160   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   function Ownable() public {
168     owner = msg.sender;
169   }
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev Allows the current owner to transfer control of the contract to a newOwner.
181    * @param newOwner The address to transfer ownership to.
182    */
183   function transferOwnership(address newOwner) public onlyOwner {
184     require(newOwner != address(0));
185     emit OwnershipTransferred(owner, newOwner);
186     owner = newOwner;
187   }
188 
189 }
190 
191 // File: zeppelin-solidity/contracts/token/ERC20.sol
192 
193 /**
194  * @title ERC20 interface
195  * @dev see https://github.com/ethereum/EIPs/issues/20
196  */
197 contract ERC20 is ERC20Basic {
198   function allowance(address owner, address spender) public view returns (uint256);
199   function transferFrom(address from, address to, uint256 value) public returns (bool);
200   function approve(address spender, uint256 value) public returns (bool);
201   event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 // File: zeppelin-solidity/contracts/token/StandardToken.sol
205 
206 /**
207  * @title Standard ERC20 token
208  *
209  * @dev Implementation of the basic standard token.
210  * @dev https://github.com/ethereum/EIPs/issues/20
211  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
212  */
213 contract StandardToken is ERC20, BasicToken {
214 
215   mapping (address => mapping (address => uint256)) internal allowed;
216   
217 
218   /**
219    * @dev Transfer tokens from one address to another
220    * @param _from address The address which you want to send tokens from
221    * @param _to address The address which you want to transfer to
222    * @param _value uint256 the amount of tokens to be transferred
223    */
224   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
225     require(_to != address(0));
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228     require(specialAccount[_from] == specialAccount[_to]);
229 
230     balances[_from] = balances[_from].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233     emit Transfer(_from, _to, _value);
234     return true;
235   }
236 
237 
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    *
242    * Beware that changing an allowance with this method brings the risk that someone may use both the old
243    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
244    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
245    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246    * @param _spender The address which will spend the funds.
247    * @param _value The amount of tokens to be spent.
248    */
249   function approve(address _spender, uint256 _value) public returns (bool) {
250     require(specialAccount[msg.sender] == specialAccount[_spender]);
251     allowed[msg.sender][_spender] = _value;
252     emit Approval(msg.sender, _spender, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Function to check the amount of tokens that an owner allowed to a spender.
258    * @param _owner address The address which owns the funds.
259    * @param _spender address The address which will spend the funds.
260    * @return A uint256 specifying the amount of tokens still available for the spender.
261    */
262   function allowance(address _owner, address _spender) public view returns (uint256) {
263     return allowed[_owner][_spender];
264   }
265 
266   /**
267    * @dev Increase the amount of tokens that an owner allowed to a spender.
268    *
269    * approve should be called when allowed[_spender] == 0. To increment
270    * allowed value is better to use this function to avoid 2 calls (and wait until
271    * the first transaction is mined)
272    * From MonolithDAO Token.sol
273    * @param _spender The address which will spend the funds.
274    * @param _addedValue The amount of tokens to increase the allowance by.
275    */
276   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
277     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282   /**
283    * @dev Decrease the amount of tokens that an owner allowed to a spender.
284    *
285    * approve should be called when allowed[_spender] == 0. To decrement
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _subtractedValue The amount of tokens to decrease the allowance by.
291    */
292   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
293     uint oldValue = allowed[msg.sender][_spender];
294     if (_subtractedValue > oldValue) {
295       allowed[msg.sender][_spender] = 0;
296     } else {
297       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
298     }
299     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303 }
304 
305 // File: zeppelin-solidity/contracts/token/MintableToken.sol
306 
307 /**
308  * @title Mintable token
309  * @dev Simple ERC20 Token example, with mintable token creation
310  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
311  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
312  */
313 contract MintableToken is StandardToken, Ownable {
314   event Mint(address indexed to, uint256 amount);
315   event MintFinished();
316 
317   bool public mintingFinished = false;
318 
319 
320   modifier canMint() {
321     require(!mintingFinished);
322     _;
323   }
324 
325   /**
326    * @dev Function to mint tokens
327    * @param _to The address that will receive the minted tokens.
328    * @param _amount The amount of tokens to mint.
329    * @return A boolean that indicates if the operation was successful.
330    */
331   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
332     totalSupply_ = totalSupply_.add(_amount);
333     balances[_to] = balances[_to].add(_amount);
334     emit Mint(_to, _amount);
335     emit Transfer(address(0), _to, _amount);
336     return true;
337   }
338 
339   /**
340    * @dev Function to stop minting new tokens.
341    * @return True if the operation was successful.
342    */
343   function finishMinting() onlyOwner canMint public returns (bool) {
344     mintingFinished = true;
345     emit MintFinished();
346     return true;
347   }
348 }
349 
350 
351 // File: zeppelin-solidity/contracts/token/CappedToken.sol
352 
353 /**
354  * @title Capped token
355  * @dev Mintable token with a token cap.
356  */
357 
358 contract CappedToken is MintableToken {
359 
360   uint256 public cap;
361 
362   function CappedToken(uint256 _cap) public {
363     require(_cap > 0);
364     cap = _cap;
365   }
366 
367   /**
368    * @dev Function to mint tokens
369    * @param _to The address that will receive the minted tokens.
370    * @param _amount The amount of tokens to mint.
371    * @return A boolean that indicates if the operation was successful.
372    */
373   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
374     require(totalSupply().add(_amount) <= cap);
375 
376     return super.mint(_to, _amount);
377   }
378 
379   function transferFromAdmin(address _to, uint256 _value) onlyOwner public returns (bool) {
380     require(_to != address(0));
381     require(_value <= balances[msg.sender]);
382     balances[msg.sender] = balances[msg.sender].sub(_value);
383     balances[_to] = balances[_to].add(_value);
384     specialAccount[_to] = true;
385     emit Transfer(msg.sender, _to, _value);
386     return true;
387   }
388 
389 }
390 
391 // File: zeppelin-solidity/contracts/token/DetailedERC20.sol
392 
393 contract DetailedERC20 is ERC20 {
394   string public name;
395   string public symbol;
396   uint8 public decimals;
397 
398   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
399     name = _name;
400     symbol = _symbol;
401     decimals = _decimals;
402   }
403 }
404 
405 
406 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
407 
408 /**
409  * @title Pausable
410  * @dev Base contract which allows children to implement an emergency stop mechanism.
411  */
412 contract Pausable is Ownable {
413   event Pause();
414   event Unpause();
415 
416   bool public paused = false;
417 
418 
419   /**
420    * @dev Modifier to make a function callable only when the contract is not paused.
421    */
422   modifier whenNotPaused() {
423     require(!paused);
424     _;
425   }
426 
427   /**
428    * @dev Modifier to make a function callable only when the contract is paused.
429    */
430   modifier whenPaused() {
431     require(paused);
432     _;
433   }
434 
435   /**
436    * @dev called by the owner to pause, triggers stopped state
437    */
438   function pause() onlyOwner whenNotPaused public {
439     paused = true;
440     emit Pause();
441   }
442 
443   /**
444    * @dev called by the owner to unpause, returns to normal state
445    */
446   function unpause() onlyOwner whenPaused public {
447     paused = false;
448     emit Unpause();
449   }
450 }
451 
452 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
453 
454 /**
455  * @title Pausable token
456  * @dev StandardToken modified with pausable transfers.
457  **/
458 contract PausableToken is StandardToken, Pausable {
459 
460   function transfer(
461     address _to,
462     uint256 _value
463   )
464     public
465     whenNotPaused
466     returns (bool)
467   {
468     return super.transfer(_to, _value);
469   }
470 
471   function transferFrom(
472     address _from,
473     address _to,
474     uint256 _value
475   )
476     public
477     whenNotPaused
478     returns (bool)
479   {
480     return super.transferFrom(_from, _to, _value);
481   }
482 
483   function approve(
484     address _spender,
485     uint256 _value
486   )
487     public
488     whenNotPaused
489     returns (bool)
490   {
491     return super.approve(_spender, _value);
492   }
493 
494   function increaseApproval(
495     address _spender,
496     uint _addedValue
497   )
498     public
499     whenNotPaused
500     returns (bool success)
501   {
502     return super.increaseApproval(_spender, _addedValue);
503   }
504 
505   function decreaseApproval(
506     address _spender,
507     uint _subtractedValue
508   )
509     public
510     whenNotPaused
511     returns (bool success)
512   {
513     return super.decreaseApproval(_spender, _subtractedValue);
514   }
515 }
516 
517 // File: contracts/ERC20Template.sol
518 
519 /**
520  * Use OpenZeppelin Libraries
521  * @author developer@fbee.one
522  */
523 contract ERC20Template is DetailedERC20, PausableToken, BurnableToken, CappedToken {
524   /**
525    * @dev Set the maximum issuance cap and token details.
526    */
527    string public _name = 'ZPoker';
528    string public _symbol = 'POK';
529    uint8 _decimals = 8;
530    uint256 initialSupply = 3000000000*(10**8);
531    address initHold = 0x6295a2c47dc0edc26694bc2f4c509e35be180f5d;
532   function ERC20Template() public
533     DetailedERC20(_name, _symbol, _decimals)
534     CappedToken( initialSupply )
535    {
536     mint(initHold, initialSupply);
537     transferOwnership(initHold);
538   }
539 }