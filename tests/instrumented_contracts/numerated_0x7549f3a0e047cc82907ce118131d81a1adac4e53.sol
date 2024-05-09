1 pragma solidity ^0.4.24;
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
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 /**
63  * @title SafeMath
64  * @dev Math operations with safety checks that throw on error
65  */
66 library SafeMath {
67 
68   /**
69   * @dev Multiplies two numbers, throws on overflow.
70   */
71   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
72     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
73     // benefit is lost if 'b' is also tested.
74     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
75     if (a == 0) {
76       return 0;
77     }
78 
79     c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     // uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return a / b;
92   }
93 
94   /**
95   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106     c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/179
116  */
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 /**
125  * @title Basic token
126  * @dev Basic version of StandardToken, with no allowances.
127  */
128 contract BasicToken is ERC20Basic {
129   using SafeMath for uint256;
130 
131   mapping(address => uint256) balances;
132 
133   uint256 totalSupply_;
134 
135   /**
136   * @dev total number of tokens in existence
137   */
138   function totalSupply() public view returns (uint256) {
139     return totalSupply_;
140   }
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[msg.sender]);
150 
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     emit Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public view returns (uint256) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 /**
169  * @title ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/20
171  */
172 contract ERC20 is ERC20Basic {
173   function allowance(address owner, address spender)
174     public view returns (uint256);
175 
176   function transferFrom(address from, address to, uint256 value)
177     public returns (bool);
178 
179   function approve(address spender, uint256 value) public returns (bool);
180   event Approval(
181     address indexed owner,
182     address indexed spender,
183     uint256 value
184   );
185 }
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * @dev https://github.com/ethereum/EIPs/issues/20
192  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(
206     address _from,
207     address _to,
208     uint256 _value
209   )
210     public
211     returns (bool)
212   {
213     require(_to != address(0));
214     require(_value <= balances[_from]);
215     require(_value <= allowed[_from][msg.sender]);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(
247     address _owner,
248     address _spender
249    )
250     public
251     view
252     returns (uint256)
253   {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(
268     address _spender,
269     uint _addedValue
270   )
271     public
272     returns (bool)
273   {
274     allowed[msg.sender][_spender] = (
275       allowed[msg.sender][_spender].add(_addedValue));
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue > oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
313  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
314  */
315 contract MintableToken is StandardToken, Ownable {
316   event Mint(address indexed to, uint256 amount);
317   event MintFinished();
318 
319   bool public mintingFinished = false;
320 
321 
322   modifier canMint() {
323     require(!mintingFinished);
324     _;
325   }
326 
327   modifier hasMintPermission() {
328     require(msg.sender == owner);
329     _;
330   }
331 
332   /**
333    * @dev Function to mint tokens
334    * @param _to The address that will receive the minted tokens.
335    * @param _amount The amount of tokens to mint.
336    * @return A boolean that indicates if the operation was successful.
337    */
338   function mint(
339     address _to,
340     uint256 _amount
341   )
342     hasMintPermission
343     canMint
344     public
345     returns (bool)
346   {
347     totalSupply_ = totalSupply_.add(_amount);
348     balances[_to] = balances[_to].add(_amount);
349     emit Mint(_to, _amount);
350     emit Transfer(address(0), _to, _amount);
351     return true;
352   }
353 
354   /**
355    * @dev Function to stop minting new tokens.
356    * @return True if the operation was successful.
357    */
358   function finishMinting() onlyOwner canMint public returns (bool) {
359     mintingFinished = true;
360     emit MintFinished();
361     return true;
362   }
363 }
364 
365 /**
366  * @title Pausable
367  * @dev Base contract which allows children to implement an emergency stop mechanism.
368  */
369 contract Pausable is Ownable {
370   event Pause();
371   event Unpause();
372 
373   bool public paused = false;
374 
375 
376   /**
377    * @dev Modifier to make a function callable only when the contract is not paused.
378    */
379   modifier whenNotPaused() {
380     require(!paused);
381     _;
382   }
383 
384   /**
385    * @dev Modifier to make a function callable only when the contract is paused.
386    */
387   modifier whenPaused() {
388     require(paused);
389     _;
390   }
391 
392   /**
393    * @dev called by the owner to pause, triggers stopped state
394    */
395   function pause() onlyOwner whenNotPaused public {
396     paused = true;
397     emit Pause();
398   }
399 
400   /**
401    * @dev called by the owner to unpause, returns to normal state
402    */
403   function unpause() onlyOwner whenPaused public {
404     paused = false;
405     emit Unpause();
406   }
407 }
408 
409 /**
410  * @title Pausable token
411  * @dev StandardToken modified with pausable transfers.
412  **/
413 contract PausableToken is StandardToken, Pausable {
414 
415   function transfer(
416     address _to,
417     uint256 _value
418   )
419     public
420     whenNotPaused
421     returns (bool)
422   {
423     return super.transfer(_to, _value);
424   }
425 
426   function transferFrom(
427     address _from,
428     address _to,
429     uint256 _value
430   )
431     public
432     whenNotPaused
433     returns (bool)
434   {
435     return super.transferFrom(_from, _to, _value);
436   }
437 
438   function approve(
439     address _spender,
440     uint256 _value
441   )
442     public
443     whenNotPaused
444     returns (bool)
445   {
446     return super.approve(_spender, _value);
447   }
448 
449   function increaseApproval(
450     address _spender,
451     uint _addedValue
452   )
453     public
454     whenNotPaused
455     returns (bool success)
456   {
457     return super.increaseApproval(_spender, _addedValue);
458   }
459 
460   function decreaseApproval(
461     address _spender,
462     uint _subtractedValue
463   )
464     public
465     whenNotPaused
466     returns (bool success)
467   {
468     return super.decreaseApproval(_spender, _subtractedValue);
469   }
470 }
471 
472 contract WirebitsToken is MintableToken, PausableToken {
473   string  public name;
474   string  public symbol;
475   uint256 public decimals;
476 
477   constructor() public {
478     name = "Wirebits";
479     symbol = "WRBT";
480     decimals = 18;
481   }
482 }
483 
484 contract WirebitsTipJar is Ownable {
485   using SafeMath for uint256;
486 
487   address public token;
488   address public wallet;
489   uint256 public feePercent;
490 
491   event Tip (
492     address indexed _sender,
493     address indexed _recipient,
494     address indexed _wallet,
495     uint256 _total,
496     uint256 _amount,
497     uint256 _fee,
498     uint256 _feePercent,
499     string _articleId,
500     uint256 _timestamp
501   );
502 
503   constructor(
504     address _token,
505     address _wallet,
506     uint256 _feePercent
507   )
508     public
509   {
510     token = _token;
511     wallet = _wallet;
512     feePercent = _feePercent;
513   }
514 
515   function sendTip(
516     address _recipient,
517     uint256 _tokens,
518     string _articleId
519   )
520     public
521     returns (bool)
522   {
523     uint256 _feeTokens = _tokens.mul(feePercent).div(100);
524     uint256 _recipientTokens = _tokens.sub(_feeTokens);
525 
526     WirebitsToken _token = WirebitsToken(address(token));
527     _token.transferFrom(msg.sender, wallet, _feeTokens);
528     _token.transferFrom(msg.sender, _recipient, _recipientTokens);
529 
530     emit Tip(
531       msg.sender,
532       _recipient,
533       wallet,
534       _tokens,
535       _recipientTokens,
536       _feeTokens,
537       feePercent,
538       _articleId,
539       block.timestamp
540     );
541 
542     return true;
543   }
544 
545   function setWallet(address _wallet) public onlyOwner returns(bool) {
546     wallet = _wallet;
547     return true;
548   }
549 
550   function setFeePercent(uint256 _feePercent) public onlyOwner returns(bool) {
551     feePercent = _feePercent;
552     return true;
553   }
554 }