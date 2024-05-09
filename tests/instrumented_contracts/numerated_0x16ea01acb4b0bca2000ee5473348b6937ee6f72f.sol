1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address _who) public view returns (uint256);
11   function transfer(address _to, uint256 _value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (_a == 0) {
29       return 0;
30     }
31 
32     c = _a * _b;
33     assert(c / _a == _b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     // assert(_b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = _a / _b;
43     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
44     return _a / _b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     assert(_b <= _a);
52     return _a - _b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
59     c = _a + _b;
60     assert(c >= _a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) internal balances;
73 
74   uint256 internal totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_value <= balances[msg.sender]);
90     require(_to != address(0));
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address _owner, address _spender)
115     public view returns (uint256);
116 
117   function transferFrom(address _from, address _to, uint256 _value)
118     public returns (bool);
119 
120   function approve(address _spender, uint256 _value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_value <= balances[_from]);
155     require(_value <= allowed[_from][msg.sender]);
156     require(_to != address(0));
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue >= oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipRenounced(address indexed previousOwner);
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   constructor() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to relinquish control of the contract.
281    * @notice Renouncing to ownership will leave the contract without an owner.
282    * It will not be possible to call the functions with the `onlyOwner`
283    * modifier anymore.
284    */
285   function renounceOwnership() public onlyOwner {
286     emit OwnershipRenounced(owner);
287     owner = address(0);
288   }
289 
290   /**
291    * @dev Allows the current owner to transfer control of the contract to a newOwner.
292    * @param _newOwner The address to transfer ownership to.
293    */
294   function transferOwnership(address _newOwner) public onlyOwner {
295     _transferOwnership(_newOwner);
296   }
297 
298   /**
299    * @dev Transfers control of the contract to a newOwner.
300    * @param _newOwner The address to transfer ownership to.
301    */
302   function _transferOwnership(address _newOwner) internal {
303     require(_newOwner != address(0));
304     emit OwnershipTransferred(owner, _newOwner);
305     owner = _newOwner;
306   }
307 }
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
313  */
314 contract MintableToken is StandardToken, Ownable {
315   event Mint(address indexed to, uint256 amount);
316   event MintFinished();
317 
318   bool public mintingFinished = false;
319 
320 
321   modifier canMint() {
322     require(!mintingFinished);
323     _;
324   }
325 
326   modifier hasMintPermission() {
327     require(msg.sender == owner);
328     _;
329   }
330 
331   /**
332    * @dev Function to mint tokens
333    * @param _to The address that will receive the minted tokens.
334    * @param _amount The amount of tokens to mint.
335    * @return A boolean that indicates if the operation was successful.
336    */
337   function mint(
338     address _to,
339     uint256 _amount
340   )
341     public
342     hasMintPermission
343     canMint
344     returns (bool)
345   {
346     totalSupply_ = totalSupply_.add(_amount);
347     balances[_to] = balances[_to].add(_amount);
348     emit Mint(_to, _amount);
349     emit Transfer(address(0), _to, _amount);
350     return true;
351   }
352 
353   /**
354    * @dev Function to stop minting new tokens.
355    * @return True if the operation was successful.
356    */
357   function finishMinting() public onlyOwner canMint returns (bool) {
358     mintingFinished = true;
359     emit MintFinished();
360     return true;
361   }
362 }
363 
364 /**
365  * @title Capped token
366  * @dev Mintable token with a token cap.
367  */
368 contract CappedToken is MintableToken {
369 
370   uint256 public cap;
371 
372   constructor(uint256 _cap) public {
373     require(_cap > 0);
374     cap = _cap;
375   }
376 
377   /**
378    * @dev Function to mint tokens
379    * @param _to The address that will receive the minted tokens.
380    * @param _amount The amount of tokens to mint.
381    * @return A boolean that indicates if the operation was successful.
382    */
383   function mint(
384     address _to,
385     uint256 _amount
386   )
387     public
388     returns (bool)
389   {
390     require(totalSupply_.add(_amount) <= cap);
391 
392     return super.mint(_to, _amount);
393   }
394 
395 }
396 
397 /**
398  * @title Pausable
399  * @dev Base contract which allows children to implement an emergency stop mechanism.
400  */
401 contract Pausable is Ownable {
402   event Pause();
403   event Unpause();
404 
405   bool public paused = false;
406 
407 
408   /**
409    * @dev Modifier to make a function callable only when the contract is not paused.
410    */
411   modifier whenNotPaused() {
412     require(!paused);
413     _;
414   }
415 
416   /**
417    * @dev Modifier to make a function callable only when the contract is paused.
418    */
419   modifier whenPaused() {
420     require(paused);
421     _;
422   }
423 
424   /**
425    * @dev called by the owner to pause, triggers stopped state
426    */
427   function pause() public onlyOwner whenNotPaused {
428     paused = true;
429     emit Pause();
430   }
431 
432   /**
433    * @dev called by the owner to unpause, returns to normal state
434    */
435   function unpause() public onlyOwner whenPaused {
436     paused = false;
437     emit Unpause();
438   }
439 }
440 
441 /**
442  * @title Pausable token
443  * @dev StandardToken modified with pausable transfers.
444  **/
445 contract PausableToken is StandardToken, Pausable {
446 
447   function transfer(
448     address _to,
449     uint256 _value
450   )
451     public
452     whenNotPaused
453     returns (bool)
454   {
455     return super.transfer(_to, _value);
456   }
457 
458   function transferFrom(
459     address _from,
460     address _to,
461     uint256 _value
462   )
463     public
464     whenNotPaused
465     returns (bool)
466   {
467     return super.transferFrom(_from, _to, _value);
468   }
469 
470   function approve(
471     address _spender,
472     uint256 _value
473   )
474     public
475     whenNotPaused
476     returns (bool)
477   {
478     return super.approve(_spender, _value);
479   }
480 
481   function increaseApproval(
482     address _spender,
483     uint _addedValue
484   )
485     public
486     whenNotPaused
487     returns (bool success)
488   {
489     return super.increaseApproval(_spender, _addedValue);
490   }
491 
492   function decreaseApproval(
493     address _spender,
494     uint _subtractedValue
495   )
496     public
497     whenNotPaused
498     returns (bool success)
499   {
500     return super.decreaseApproval(_spender, _subtractedValue);
501   }
502 }
503 
504 /**
505  * @title ENQ Token Smart Contract
506  * @author GeekHack t.me/GeekHack
507  */
508 contract Token is CappedToken, PausableToken {
509 	/* solhint-disable const-name-snakecase */
510 	string public constant name = "Enecuum"; // solium-disable-line uppercase
511 	string public constant symbol = "ENQ"; // solium-disable-line uppercase
512 	uint8 public constant decimals = 10; // solium-disable-line uppercase
513 	/* solhint-enable const-name-snakecase */
514 	uint256 public cap = 687566880 * (10 ** uint256(decimals));
515 
516 	// solium-disable-next-line max-len
517 	uint256 public constant INITIAL_SUPPLY = 99901437 * (10 ** uint256(decimals)); // solhint-disable-line max-line-length
518 
519 	constructor(
520 		address _wallet
521 	)
522 	public
523 	CappedToken(cap)
524 	{ // solhint-disable-line bracket-align
525 		require(_wallet != address(0));
526 		totalSupply_ = INITIAL_SUPPLY;
527 		balances[_wallet] = INITIAL_SUPPLY;
528 		emit Transfer(address(0), _wallet, INITIAL_SUPPLY);
529 	}
530 }