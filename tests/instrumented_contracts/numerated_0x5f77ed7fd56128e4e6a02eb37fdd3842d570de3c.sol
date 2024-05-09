1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4   function totalSupply() public view returns (uint256);
5 
6   function balanceOf(address _who) public view returns (uint256);
7 
8   function allowance(address _owner, address _spender)
9     public view returns (uint256);
10 
11   function transfer(address _to, uint256 _value) public returns (bool);
12 
13   function approve(address _spender, uint256 _value)
14     public returns (bool);
15 
16   function transferFrom(address _from, address _to, uint256 _value)
17     public returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 library SafeERC20 {
33   function safeTransfer(
34     ERC20 _token,
35     address _to,
36     uint256 _value
37   )
38     internal
39   {
40     require(_token.transfer(_to, _value));
41   }
42 
43   function safeTransferFrom(
44     ERC20 _token,
45     address _from,
46     address _to,
47     uint256 _value
48   )
49     internal
50   {
51     require(_token.transferFrom(_from, _to, _value));
52   }
53 
54   function safeApprove(
55     ERC20 _token,
56     address _spender,
57     uint256 _value
58   )
59     internal
60   {
61     require(_token.approve(_spender, _value));
62   }
63 }
64 
65 contract StandardToken is ERC20 {
66   using SafeMath for uint256;
67   using SafeERC20 for ERC20;
68 
69   mapping(address => uint256) balances;
70 
71   mapping (address => mapping (address => uint256)) internal allowed;
72 
73   uint256 totalSupply_;
74 
75   /**
76   * @dev Total number of tokens in existence
77   */
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256) {
88     return balances[_owner];
89   }
90 
91   /**
92    * @dev Function to check the amount of tokens that an owner allowed to a spender.
93    * @param _owner address The address which owns the funds.
94    * @param _spender address The address which will spend the funds.
95    * @return A uint256 specifying the amount of tokens still available for the spender.
96    */
97   function allowance(
98     address _owner,
99     address _spender
100    )
101     public
102     view
103     returns (uint256)
104   {
105     return allowed[_owner][_spender];
106   }
107 
108   /**
109   * @dev Transfer token for a specified address.
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_value <= balances[msg.sender]);
115     require(_to != address(0));
116 
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     emit Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     emit Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(
145     address _from,
146     address _to,
147     uint256 _value
148   )
149     public
150     returns (bool)
151   {
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154     require(_to != address(0));
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     emit Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Increase the amount of tokens that an owner allowed to a spender.
165    * approve should be called when allowed[_spender] == 0. To increment
166    * allowed value is better to use this function to avoid 2 calls (and wait until
167    * the first transaction is mined)
168    * From MonolithDAO Token.sol
169    * @param _spender The address which will spend the funds.
170    * @param _addedValue The amount of tokens to increase the allowance by.
171    */
172   function increaseApproval(
173     address _spender,
174     uint256 _addedValue
175   )
176     public
177     returns (bool)
178   {
179     allowed[msg.sender][_spender] = (
180       allowed[msg.sender][_spender].add(_addedValue));
181     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185   /**
186    * @dev Decrease the amount of tokens that an owner allowed to a spender.
187    * approve should be called when allowed[_spender] == 0. To decrement
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _subtractedValue The amount of tokens to decrease the allowance by.
193    */
194   function decreaseApproval(
195     address _spender,
196     uint256 _subtractedValue
197   )
198     public
199     returns (bool)
200   {
201     uint256 oldValue = allowed[msg.sender][_spender];
202     if (_subtractedValue >= oldValue) {
203       allowed[msg.sender][_spender] = 0;
204     } else {
205       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206     }
207     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211 }
212 
213 contract Ownable {
214   address public owner;
215 
216 
217   event OwnershipRenounced(address indexed previousOwner);
218   event OwnershipTransferred(
219     address indexed previousOwner,
220     address indexed newOwner
221   );
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   constructor() public {
229     owner = msg.sender;
230   }
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to relinquish control of the contract.
242    * @notice Renouncing to ownership will leave the contract without an owner.
243    * It will not be possible to call the functions with the `onlyOwner`
244    * modifier anymore.
245    */
246   function renounceOwnership() public onlyOwner {
247     emit OwnershipRenounced(owner);
248     owner = address(0);
249   }
250 
251   /**
252    * @dev Allows the current owner to transfer control of the contract to a newOwner.
253    * @param _newOwner The address to transfer ownership to.
254    */
255   function transferOwnership(address _newOwner) public onlyOwner {
256     _transferOwnership(_newOwner);
257   }
258 
259   /**
260    * @dev Transfers control of the contract to a newOwner.
261    * @param _newOwner The address to transfer ownership to.
262    */
263   function _transferOwnership(address _newOwner) internal {
264     require(_newOwner != address(0));
265     emit OwnershipTransferred(owner, _newOwner);
266     owner = _newOwner;
267   }
268 }
269 
270 contract Pausable is Ownable {
271   event Pause();
272   event Unpause();
273 
274   bool public paused = false;
275 
276 
277   /**
278    * @dev Modifier to make a function callable only when the contract is not paused.
279    */
280   modifier whenNotPaused() {
281     require(!paused);
282     _;
283   }
284 
285   /**
286    * @dev Modifier to make a function callable only when the contract is paused.
287    */
288   modifier whenPaused() {
289     require(paused);
290     _;
291   }
292 
293   /**
294    * @dev called by the owner to pause, triggers stopped state
295    */
296   function pause() public onlyOwner whenNotPaused {
297     paused = true;
298     emit Pause();
299   }
300 
301   /**
302    * @dev called by the owner to unpause, returns to normal state
303    */
304   function unpause() public onlyOwner whenPaused {
305     paused = false;
306     emit Unpause();
307   }
308 }
309 
310 contract MintableToken is StandardToken, Ownable {
311   event Mint(address indexed to, uint256 amount);
312   event MintFinished();
313 
314   bool public mintingFinished = false;
315 
316 
317   modifier canMint() {
318     require(!mintingFinished);
319     _;
320   }
321 
322   modifier hasMintPermission() {
323     require(msg.sender == owner);
324     _;
325   }
326 
327   /**
328    * @dev Function to mint tokens
329    * @param _to The address that will receive the minted tokens.
330    * @param _amount The amount of tokens to mint.
331    * @return A boolean that indicates if the operation was successful.
332    */
333   function mint(
334     address _to,
335     uint256 _amount
336   )
337     public
338     hasMintPermission
339     canMint
340     returns (bool)
341   {
342     totalSupply_ = totalSupply_.add(_amount);
343     balances[_to] = balances[_to].add(_amount);
344     emit Mint(_to, _amount);
345     emit Transfer(address(0), _to, _amount);
346     return true;
347   }
348 
349   /**
350    * @dev Function to stop minting new tokens.
351    * @return True if the operation was successful.
352    */
353   function finishMinting() public onlyOwner canMint returns (bool) {
354     mintingFinished = true;
355     emit MintFinished();
356     return true;
357   }
358 }
359 
360 contract CappedToken is MintableToken {
361 
362   uint256 public cap;
363 
364   constructor(uint256 _cap) public {
365     require(_cap > 0);
366     cap = _cap;
367   }
368 
369   /**
370    * @dev Function to mint tokens
371    * @param _to The address that will receive the minted tokens.
372    * @param _amount The amount of tokens to mint.
373    * @return A boolean that indicates if the operation was successful.
374    */
375   function mint(
376     address _to,
377     uint256 _amount
378   )
379     public
380     returns (bool)
381   {
382     require(totalSupply_.add(_amount) <= cap);
383 
384     return super.mint(_to, _amount);
385   }
386 
387 }
388 
389 contract PausableToken is StandardToken, Pausable {
390 
391   function transfer(
392     address _to,
393     uint256 _value
394   )
395     public
396     whenNotPaused
397     returns (bool)
398   {
399     return super.transfer(_to, _value);
400   }
401 
402   function transferFrom(
403     address _from,
404     address _to,
405     uint256 _value
406   )
407     public
408     whenNotPaused
409     returns (bool)
410   {
411     return super.transferFrom(_from, _to, _value);
412   }
413 
414   function approve(
415     address _spender,
416     uint256 _value
417   )
418     public
419     whenNotPaused
420     returns (bool)
421   {
422     return super.approve(_spender, _value);
423   }
424 
425   function increaseApproval(
426     address _spender,
427     uint _addedValue
428   )
429     public
430     whenNotPaused
431     returns (bool success)
432   {
433     return super.increaseApproval(_spender, _addedValue);
434   }
435 
436   function decreaseApproval(
437     address _spender,
438     uint _subtractedValue
439   )
440     public
441     whenNotPaused
442     returns (bool success)
443   {
444     return super.decreaseApproval(_spender, _subtractedValue);
445   }
446 }
447 
448 contract ImpactOxygenToken is MintableToken, PausableToken, CappedToken {
449 
450   string public constant name = "Impact Oxygen Token";
451   string public constant symbol = "IO2";
452   uint8 public constant decimals = 18;
453   uint256 public constant decimalFactor = 10 ** uint256(decimals);
454   uint256 public cap =          114166666667 * decimalFactor; // There will be a total of 114,166,666,667 iO2 Tokens
455 
456   constructor() public
457     CappedToken(cap)
458   {
459 
460   }
461 
462 }
463 
464 library SafeMath {
465 
466   /**
467   * @dev Multiplies two numbers, throws on overflow.
468   */
469   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
470     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
471     // benefit is lost if 'b' is also tested.
472     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
473     if (_a == 0) {
474       return 0;
475     }
476 
477     c = _a * _b;
478     assert(c / _a == _b);
479     return c;
480   }
481 
482   /**
483   * @dev Integer division of two numbers, truncating the quotient.
484   */
485   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
486     // assert(_b > 0); // Solidity automatically throws when dividing by 0
487     // uint256 c = _a / _b;
488     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
489     return _a / _b;
490   }
491 
492   /**
493   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
494   */
495   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
496     assert(_b <= _a);
497     return _a - _b;
498   }
499 
500   /**
501   * @dev Adds two numbers, throws on overflow.
502   */
503   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
504     c = _a + _b;
505     assert(c >= _a);
506     return c;
507   }
508 
509   /**
510   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
511   * reverts when dividing by zero.
512   */
513   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
514     require(b != 0);
515     return a % b;
516   }
517 }