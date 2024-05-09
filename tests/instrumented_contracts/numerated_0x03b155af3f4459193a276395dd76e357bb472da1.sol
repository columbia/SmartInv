1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract Pausable is Ownable {
107   event Pause();
108   event Unpause();
109 
110   bool public paused = false;
111 
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is not paused.
115    */
116   modifier whenNotPaused() {
117     require(!paused);
118     _;
119   }
120 
121   /**
122    * @dev Modifier to make a function callable only when the contract is paused.
123    */
124   modifier whenPaused() {
125     require(paused);
126     _;
127   }
128 
129   /**
130    * @dev called by the owner to pause, triggers stopped state
131    */
132   function pause() public onlyOwner whenNotPaused {
133     paused = true;
134     emit Pause();
135   }
136 
137   /**
138    * @dev called by the owner to unpause, returns to normal state
139    */
140   function unpause() public onlyOwner whenPaused {
141     paused = false;
142     emit Unpause();
143   }
144 }
145 
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address _who) public view returns (uint256);
149   function transfer(address _to, uint256 _value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 contract BasicToken is ERC20Basic {
154   using SafeMath for uint256;
155 
156   mapping(address => uint256) internal balances;
157 
158   uint256 internal totalSupply_;
159 
160   /**
161   * @dev Total number of tokens in existence
162   */
163   function totalSupply() public view returns (uint256) {
164     return totalSupply_;
165   }
166 
167   /**
168   * @dev Transfer token for a specified address
169   * @param _to The address to transfer to.
170   * @param _value The amount to be transferred.
171   */
172   function transfer(address _to, uint256 _value) public returns (bool) {
173     require(_value <= balances[msg.sender]);
174     require(_to != address(0));
175 
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     emit Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public view returns (uint256) {
188     return balances[_owner];
189   }
190 
191 }
192 
193 contract ERC20 is ERC20Basic {
194   function allowance(address _owner, address _spender)
195     public view returns (uint256);
196 
197   function transferFrom(address _from, address _to, uint256 _value)
198     public returns (bool);
199 
200   function approve(address _spender, uint256 _value) public returns (bool);
201   event Approval(
202     address indexed owner,
203     address indexed spender,
204     uint256 value
205   );
206 }
207 
208 contract DetailedERC20 is ERC20 {
209   string public name;
210   string public symbol;
211   uint8 public decimals;
212 
213   constructor(string _name, string _symbol, uint8 _decimals) public {
214     name = _name;
215     symbol = _symbol;
216     decimals = _decimals;
217   }
218 }
219 
220 contract StandardToken is ERC20, BasicToken {
221 
222   mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(
232     address _from,
233     address _to,
234     uint256 _value
235   )
236     public
237     returns (bool)
238   {
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241     require(_to != address(0));
242 
243     balances[_from] = balances[_from].sub(_value);
244     balances[_to] = balances[_to].add(_value);
245     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246     emit Transfer(_from, _to, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     emit Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(
272     address _owner,
273     address _spender
274    )
275     public
276     view
277     returns (uint256)
278   {
279     return allowed[_owner][_spender];
280   }
281 
282   /**
283    * @dev Increase the amount of tokens that an owner allowed to a spender.
284    * approve should be called when allowed[_spender] == 0. To increment
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param _spender The address which will spend the funds.
289    * @param _addedValue The amount of tokens to increase the allowance by.
290    */
291   function increaseApproval(
292     address _spender,
293     uint256 _addedValue
294   )
295     public
296     returns (bool)
297   {
298     allowed[msg.sender][_spender] = (
299       allowed[msg.sender][_spender].add(_addedValue));
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304   /**
305    * @dev Decrease the amount of tokens that an owner allowed to a spender.
306    * approve should be called when allowed[_spender] == 0. To decrement
307    * allowed value is better to use this function to avoid 2 calls (and wait until
308    * the first transaction is mined)
309    * From MonolithDAO Token.sol
310    * @param _spender The address which will spend the funds.
311    * @param _subtractedValue The amount of tokens to decrease the allowance by.
312    */
313   function decreaseApproval(
314     address _spender,
315     uint256 _subtractedValue
316   )
317     public
318     returns (bool)
319   {
320     uint256 oldValue = allowed[msg.sender][_spender];
321     if (_subtractedValue >= oldValue) {
322       allowed[msg.sender][_spender] = 0;
323     } else {
324       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
325     }
326     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
327     return true;
328   }
329 
330 }
331 
332 contract MintableToken is StandardToken, Ownable {
333   event Mint(address indexed to, uint256 amount);
334   event MintFinished();
335 
336   bool public mintingFinished = false;
337 
338 
339   modifier canMint() {
340     require(!mintingFinished);
341     _;
342   }
343 
344   modifier hasMintPermission() {
345     require(msg.sender == owner);
346     _;
347   }
348 
349   /**
350    * @dev Function to mint tokens
351    * @param _to The address that will receive the minted tokens.
352    * @param _amount The amount of tokens to mint.
353    * @return A boolean that indicates if the operation was successful.
354    */
355   function mint(
356     address _to,
357     uint256 _amount
358   )
359     public
360     hasMintPermission
361     canMint
362     returns (bool)
363   {
364     totalSupply_ = totalSupply_.add(_amount);
365     balances[_to] = balances[_to].add(_amount);
366     emit Mint(_to, _amount);
367     emit Transfer(address(0), _to, _amount);
368     return true;
369   }
370 
371   /**
372    * @dev Function to stop minting new tokens.
373    * @return True if the operation was successful.
374    */
375   function finishMinting() public onlyOwner canMint returns (bool) {
376     mintingFinished = true;
377     emit MintFinished();
378     return true;
379   }
380 }
381 
382 contract CappedToken is MintableToken {
383 
384   uint256 public cap;
385 
386   constructor(uint256 _cap) public {
387     require(_cap > 0);
388     cap = _cap;
389   }
390 
391   /**
392    * @dev Function to mint tokens
393    * @param _to The address that will receive the minted tokens.
394    * @param _amount The amount of tokens to mint.
395    * @return A boolean that indicates if the operation was successful.
396    */
397   function mint(
398     address _to,
399     uint256 _amount
400   )
401     public
402     returns (bool)
403   {
404     require(totalSupply_.add(_amount) <= cap);
405 
406     return super.mint(_to, _amount);
407   }
408 
409 }
410 
411 contract PausableToken is StandardToken, Pausable {
412 
413   function transfer(
414     address _to,
415     uint256 _value
416   )
417     public
418     whenNotPaused
419     returns (bool)
420   {
421     return super.transfer(_to, _value);
422   }
423 
424   function transferFrom(
425     address _from,
426     address _to,
427     uint256 _value
428   )
429     public
430     whenNotPaused
431     returns (bool)
432   {
433     return super.transferFrom(_from, _to, _value);
434   }
435 
436   function approve(
437     address _spender,
438     uint256 _value
439   )
440     public
441     whenNotPaused
442     returns (bool)
443   {
444     return super.approve(_spender, _value);
445   }
446 
447   function increaseApproval(
448     address _spender,
449     uint _addedValue
450   )
451     public
452     whenNotPaused
453     returns (bool success)
454   {
455     return super.increaseApproval(_spender, _addedValue);
456   }
457 
458   function decreaseApproval(
459     address _spender,
460     uint _subtractedValue
461   )
462     public
463     whenNotPaused
464     returns (bool success)
465   {
466     return super.decreaseApproval(_spender, _subtractedValue);
467   }
468 }
469 
470 contract SwaceToken is DetailedERC20, PausableToken, CappedToken {
471   event ChangeVestingAgent(address indexed oldVestingAgent, address indexed newVestingAgent);
472 
473   uint256 private constant TOKEN_UNIT = 10 ** uint256(18);
474   uint256 public constant TOTAL_SUPPLY = 2.7e9 * TOKEN_UNIT;
475 
476   uint256 public constant VESTING_SUPPLY = 5.67e8 * TOKEN_UNIT;
477   uint256 public constant IEO_SUPPLY = 1.35e8 * TOKEN_UNIT;
478 
479   address public ieoWallet;
480   address public vestingAgent;
481 
482   modifier onlyVestingAgent() {
483     require(msg.sender == vestingAgent, "Sender not authorized to be as vesting agent");
484     _;
485   }
486 
487   constructor(
488     address _vestingWallet,
489     address _ieoWallet
490   )
491     public
492     DetailedERC20("Swace", "SWACE", 18)
493     CappedToken(TOTAL_SUPPLY)
494   {
495     // solium-disable-next-line security/no-block-members
496     require(_vestingWallet != address(0), "Vesting wallet can not be empty");
497     require(_ieoWallet != address(0), "IEO wallet can not be empty");
498 
499     ieoWallet = _ieoWallet;
500 
501     //Team wallet is actually vesting agent contract
502     changeVestingAgent(_vestingWallet);
503 
504     //Mint tokens to defined wallets
505     mint(_vestingWallet, VESTING_SUPPLY);
506     mint(_ieoWallet, IEO_SUPPLY);
507 
508     //Mint owner with the rest of tokens
509     mint(owner, TOTAL_SUPPLY.sub(totalSupply_));
510 
511     //Finish minting because we minted everything already
512     finishMinting();
513   }
514 
515   /**
516    * @dev Original ERC20 approve with additional security mesure.
517    * @param _spender The address which will spend the funds.
518    * @param _value The amount of tokens to be spent.
519    * @return A boolean that indicates if the operation was successful.
520    */
521   function approve(address _spender, uint256 _value)
522     public
523     returns (bool)
524   {
525     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
526     require((_value == 0) || (allowed[msg.sender][_spender] == 0), "Approval can not be granted");
527 
528     return super.approve(_spender, _value);
529   }
530 
531   /**
532    * TODO: add check if _vestingAgent is contract address
533    * @dev Allow to change vesting agent.
534    * @param _vestingAgent The address of new vesting agent.
535    */
536   function changeVestingAgent(address _vestingAgent)
537     public
538     onlyOwner
539   {
540     address oldVestingAgent = vestingAgent;
541     vestingAgent = _vestingAgent;
542 
543     emit ChangeVestingAgent(oldVestingAgent, _vestingAgent);
544   }
545 }