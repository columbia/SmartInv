1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender) public view returns (uint256);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 /**
253  * @title Mintable token
254  * @dev Simple ERC20 Token example, with mintable token creation
255  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
256  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
257  */
258 
259 contract MintableToken is StandardToken, Ownable {
260   event Mint(address indexed to, uint256 amount);
261   event MintFinished();
262 
263   uint public totalSupply;
264 
265   bool public mintingFinished = false;
266   mapping(address => bool) internal minters;
267 
268   modifier onlyRegistered() {
269     require(minters[msg.sender]);
270     _;
271   }
272 
273   modifier canMint() {
274     require(!mintingFinished);
275     _;
276   }
277 
278   function isMinterAllowed(address _address) view public returns (bool) {
279     return minters[_address];
280   }
281 
282   /**
283    * @dev Function to add a minter in the list of minters
284    * @param _contract The address to the contract that is allowed to mint token
285    * @return A boolean that indicates if the operation was successful.
286   */
287   function addMinter(address _contract) onlyOwner canMint public returns (bool) {
288     require(_contract != address(0));
289     require(!minters[_contract]);
290     minters[_contract] = true;
291     return true;
292   }
293 
294   /**
295    * @dev Function to revoke a minter
296    * @param  _contract The address to the contract that will be revoked to mint token
297    * @return A boolean that indicates if the operation was successful.
298   */
299   function revokeMinter(address _contract) onlyOwner canMint public returns (bool) {
300     require(_contract != address(0));
301     minters[_contract] = false;
302     return true;
303   }
304   /**
305    * @dev Function to self unregister minter
306   */
307   function leave() onlyRegistered canMint public {
308     minters[msg.sender] = false;
309   }
310 
311   /**
312    * @dev Function to mint tokens
313    * @param _to The address that will receive the minted tokens.
314    * @param _amount The amount of tokens to mint.
315    * @return A boolean that indicates if the operation was successful.
316    */
317   function mint(address _to, uint256 _amount) onlyRegistered canMint public returns (bool) {
318     totalSupply = totalSupply.add(_amount);
319     balances[_to] = balances[_to].add(_amount);
320     Mint(_to, _amount);
321     Transfer(address(0), _to, _amount);
322     return true;
323   }
324 
325   /**
326    * @dev Function to stop minting new tokens.
327    * @return True if the operation was successful.
328    */
329   function finishMinting() onlyOwner canMint public returns (bool) {
330     mintingFinished = true;
331     MintFinished();
332     return true;
333   }
334 }
335 
336 /**
337  * @title Pausable
338  * @dev Base contract which allows children to implement an emergency stop mechanism.
339  */
340 contract Pausable is Ownable {
341   event Pause();
342   event Unpause();
343 
344   bool public paused = false;
345 
346 
347   /**
348    * @dev Modifier to make a function callable only when the contract is not paused.
349    */
350   modifier whenNotPaused() {
351     require(!paused);
352     _;
353   }
354 
355   /**
356    * @dev Modifier to make a function callable only when the contract is paused.
357    */
358   modifier whenPaused() {
359     require(paused);
360     _;
361   }
362 
363   /**
364    * @dev called by the owner to pause, triggers stopped state
365    */
366   function pause() onlyOwner whenNotPaused public {
367     paused = true;
368     Pause();
369   }
370 
371   /**
372    * @dev called by the owner to unpause, returns to normal state
373    */
374   function unpause() onlyOwner whenPaused public {
375     paused = false;
376     Unpause();
377   }
378 }
379 
380 /**
381  * @title Pausable token
382  * @dev StandardToken modified with pausable transfers.
383  **/
384 contract PausableToken is StandardToken, Pausable {
385 
386   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
387     return super.transfer(_to, _value);
388   }
389 
390   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
391     return super.transferFrom(_from, _to, _value);
392   }
393 
394   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
395     return super.approve(_spender, _value);
396   }
397 
398   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
399     return super.increaseApproval(_spender, _addedValue);
400   }
401 
402   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
403     return super.decreaseApproval(_spender, _subtractedValue);
404   }
405 }
406 
407 /**
408    @title ERC827 interface, an extension of ERC20 token standard
409 
410    Interface of a ERC827 token, following the ERC20 standard with extra
411    methods to transfer value and data and execute calls in transfers and
412    approvals.
413  */
414 contract ERC827 is ERC20 {
415 
416   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
417   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
418   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
419 
420 }
421 
422 /**
423    @title ERC827, an extension of ERC20 token standard
424 
425    Implementation the ERC827, following the ERC20 standard with extra
426    methods to transfer value and data and execute calls in transfers and
427    approvals.
428    Uses OpenZeppelin StandardToken.
429  */
430 contract ERC827Token is ERC827, StandardToken {
431 
432   /**
433      @dev Addition to ERC20 token methods. It allows to
434      approve the transfer of value and execute a call with the sent data.
435 
436      Beware that changing an allowance with this method brings the risk that
437      someone may use both the old and the new allowance by unfortunate
438      transaction ordering. One possible solution to mitigate this race condition
439      is to first reduce the spender's allowance to 0 and set the desired value
440      afterwards:
441      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
442 
443      @param _spender The address that will spend the funds.
444      @param _value The amount of tokens to be spent.
445      @param _data ABI-encoded contract call to call `_to` address.
446 
447      @return true if the call function was executed successfully
448    */
449   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
450     require(_spender != address(this));
451 
452     super.approve(_spender, _value);
453 
454     require(_spender.call(_data));
455 
456     return true;
457   }
458 
459   /**
460      @dev Addition to ERC20 token methods. Transfer tokens to a specified
461      address and execute a call with the sent data on the same transaction
462 
463      @param _to address The address which you want to transfer to
464      @param _value uint256 the amout of tokens to be transfered
465      @param _data ABI-encoded contract call to call `_to` address.
466 
467      @return true if the call function was executed successfully
468    */
469   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
470     require(_to != address(this));
471 
472     super.transfer(_to, _value);
473 
474     require(_to.call(_data));
475     return true;
476   }
477 
478   /**
479      @dev Addition to ERC20 token methods. Transfer tokens from one address to
480      another and make a contract call on the same transaction
481 
482      @param _from The address which you want to send tokens from
483      @param _to The address which you want to transfer to
484      @param _value The amout of tokens to be transferred
485      @param _data ABI-encoded contract call to call `_to` address.
486 
487      @return true if the call function was executed successfully
488    */
489   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
490     require(_to != address(this));
491 
492     super.transferFrom(_from, _to, _value);
493 
494     require(_to.call(_data));
495     return true;
496   }
497 
498   /**
499    * @dev Addition to StandardToken methods. Increase the amount of tokens that
500    * an owner allowed to a spender and execute a call with the sent data.
501    *
502    * approve should be called when allowed[_spender] == 0. To increment
503    * allowed value is better to use this function to avoid 2 calls (and wait until
504    * the first transaction is mined)
505    * From MonolithDAO Token.sol
506    * @param _spender The address which will spend the funds.
507    * @param _addedValue The amount of tokens to increase the allowance by.
508    * @param _data ABI-encoded contract call to call `_spender` address.
509    */
510   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
511     require(_spender != address(this));
512 
513     super.increaseApproval(_spender, _addedValue);
514 
515     require(_spender.call(_data));
516 
517     return true;
518   }
519 
520   /**
521    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
522    * an owner allowed to a spender and execute a call with the sent data.
523    *
524    * approve should be called when allowed[_spender] == 0. To decrement
525    * allowed value is better to use this function to avoid 2 calls (and wait until
526    * the first transaction is mined)
527    * From MonolithDAO Token.sol
528    * @param _spender The address which will spend the funds.
529    * @param _subtractedValue The amount of tokens to decrease the allowance by.
530    * @param _data ABI-encoded contract call to call `_spender` address.
531    */
532   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
533     require(_spender != address(this));
534 
535     super.decreaseApproval(_spender, _subtractedValue);
536 
537     require(_spender.call(_data));
538 
539     return true;
540   }
541 
542 }
543 
544 contract PixinchToken is ERC827Token, MintableToken, PausableToken {
545 
546   string public constant name = "Pixinch";
547   string public constant symbol = "PIN";
548   uint8 public constant decimals = 8;
549 
550   function PixinchToken() public {
551     owner = msg.sender;
552   }
553 }