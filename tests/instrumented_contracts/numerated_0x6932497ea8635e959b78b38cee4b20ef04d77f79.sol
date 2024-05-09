1 pragma solidity ^0.4.24;
2 /**
3  * Hello,
4  *
5  * thank you for choosing Gaia Tech Ventures.
6  * Please visit our https://gtvcoin.io for more information.
7  *
8  * Copyright Gaia Tech Ventures. All Rights Reserved.
9  */
10 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
11 /**
12  * @title ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/20
14  */
15 contract ERC20 {
16   function totalSupply() public view returns (uint256);
17   function balanceOf(address _who) public view returns (uint256);
18   function allowance(address _owner, address _spender)
19     public view returns (uint256);
20   function transfer(address _to, uint256 _value) public returns (bool);
21   function approve(address _spender, uint256 _value)
22     public returns (bool);
23   function transferFrom(address _from, address _to, uint256 _value)
24     public returns (bool);
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that revert on error
40  */
41 library SafeMath {
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (_a == 0) {
50       return 0;
51     }
52     uint256 c = _a * _b;
53     require(c / _a == _b);
54     return c;
55   }
56   /**
57   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
58   */
59   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
60     require(_b > 0); // Solidity only automatically asserts when dividing by 0
61     uint256 c = _a / _b;
62     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
63     return c;
64   }
65   /**
66   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
69     require(_b <= _a);
70     uint256 c = _a - _b;
71     return c;
72   }
73   /**
74   * @dev Adds two numbers, reverts on overflow.
75   */
76   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
77     uint256 c = _a + _b;
78     require(c >= _a);
79     return c;
80   }
81   /**
82   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
83   * reverts when dividing by zero.
84   */
85   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86     require(b != 0);
87     return a % b;
88   }
89 }
90 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
96  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20 {
99   using SafeMath for uint256;
100   mapping (address => uint256) private balances;
101   mapping (address => mapping (address => uint256)) private allowed;
102   uint256 private totalSupply_;
103   /**
104   * @dev Total number of tokens in existence
105   */
106   function totalSupply() public view returns (uint256) {
107     return totalSupply_;
108   }
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256) {
115     return balances[_owner];
116   }
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(
124     address _owner,
125     address _spender
126    )
127     public
128     view
129     returns (uint256)
130   {
131     return allowed[_owner][_spender];
132   }
133   /**
134   * @dev Transfer token for a specified address
135   * @param _to The address to transfer to.
136   * @param _value The amount to be transferred.
137   */
138   function transfer(address _to, uint256 _value) public returns (bool) {
139     require(_value <= balances[msg.sender]);
140     require(_to != address(0));
141     balances[msg.sender] = balances[msg.sender].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     emit Transfer(msg.sender, _to, _value);
144     return true;
145   }
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    * Beware that changing an allowance with this method brings the risk that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     emit Approval(msg.sender, _spender, _value);
158     return true;
159   }
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(
167     address _from,
168     address _to,
169     uint256 _value
170   )
171     public
172     returns (bool)
173   {
174     require(_value <= balances[_from]);
175     require(_value <= allowed[_from][msg.sender]);
176     require(_to != address(0));
177     balances[_from] = balances[_from].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180     emit Transfer(_from, _to, _value);
181     return true;
182   }
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(
193     address _spender,
194     uint256 _addedValue
195   )
196     public
197     returns (bool)
198   {
199     allowed[msg.sender][_spender] = (
200       allowed[msg.sender][_spender].add(_addedValue));
201     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204   /**
205    * @dev Decrease the amount of tokens that an owner allowed to a spender.
206    * approve should be called when allowed[_spender] == 0. To decrement
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _subtractedValue The amount of tokens to decrease the allowance by.
212    */
213   function decreaseApproval(
214     address _spender,
215     uint256 _subtractedValue
216   )
217     public
218     returns (bool)
219   {
220     uint256 oldValue = allowed[msg.sender][_spender];
221     if (_subtractedValue >= oldValue) {
222       allowed[msg.sender][_spender] = 0;
223     } else {
224       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229   /**
230    * @dev Internal function that mints an amount of the token and assigns it to
231    * an account. This encapsulates the modification of balances such that the
232    * proper events are emitted.
233    * @param _account The account that will receive the created tokens.
234    * @param _amount The amount that will be created.
235    */
236   function _mint(address _account, uint256 _amount) internal {
237     require(_account != 0);
238     totalSupply_ = totalSupply_.add(_amount);
239     balances[_account] = balances[_account].add(_amount);
240     emit Transfer(address(0), _account, _amount);
241   }
242   /**
243    * @dev Internal function that burns an amount of the token of a given
244    * account.
245    * @param _account The account whose tokens will be burnt.
246    * @param _amount The amount that will be burnt.
247    */
248   function _burn(address _account, uint256 _amount) internal {
249     require(_account != 0);
250     require(_amount <= balances[_account]);
251     totalSupply_ = totalSupply_.sub(_amount);
252     balances[_account] = balances[_account].sub(_amount);
253     emit Transfer(_account, address(0), _amount);
254   }
255   /**
256    * @dev Internal function that burns an amount of the token of a given
257    * account, deducting from the sender's allowance for said account. Uses the
258    * internal _burn function.
259    * @param _account The account whose tokens will be burnt.
260    * @param _amount The amount that will be burnt.
261    */
262   function _burnFrom(address _account, uint256 _amount) internal {
263     require(_amount <= allowed[_account][msg.sender]);
264     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
265     // this function needs to emit an event with the updated approval.
266     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
267     _burn(_account, _amount);
268   }
269 }
270 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
271 /**
272  * @title Ownable
273  * @dev The Ownable contract has an owner address, and provides basic authorization control
274  * functions, this simplifies the implementation of "user permissions".
275  */
276 contract Ownable {
277   address public owner;
278   event OwnershipRenounced(address indexed previousOwner);
279   event OwnershipTransferred(
280     address indexed previousOwner,
281     address indexed newOwner
282   );
283   /**
284    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
285    * account.
286    */
287   constructor() public {
288     owner = msg.sender;
289   }
290   /**
291    * @dev Throws if called by any account other than the owner.
292    */
293   modifier onlyOwner() {
294     require(msg.sender == owner);
295     _;
296   }
297   /**
298    * @dev Allows the current owner to relinquish control of the contract.
299    * @notice Renouncing to ownership will leave the contract without an owner.
300    * It will not be possible to call the functions with the `onlyOwner`
301    * modifier anymore.
302    */
303   function renounceOwnership() public onlyOwner {
304     emit OwnershipRenounced(owner);
305     owner = address(0);
306   }
307   /**
308    * @dev Allows the current owner to transfer control of the contract to a newOwner.
309    * @param _newOwner The address to transfer ownership to.
310    */
311   function transferOwnership(address _newOwner) public onlyOwner {
312     _transferOwnership(_newOwner);
313   }
314   /**
315    * @dev Transfers control of the contract to a newOwner.
316    * @param _newOwner The address to transfer ownership to.
317    */
318   function _transferOwnership(address _newOwner) internal {
319     require(_newOwner != address(0));
320     emit OwnershipTransferred(owner, _newOwner);
321     owner = _newOwner;
322   }
323 }
324 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
325 /**
326  * @title Pausable
327  * @dev Base contract which allows children to implement an emergency stop mechanism.
328  */
329 contract Pausable is Ownable {
330   event Pause();
331   event Unpause();
332   bool public paused = false;
333   /**
334    * @dev Modifier to make a function callable only when the contract is not paused.
335    */
336   modifier whenNotPaused() {
337     require(!paused);
338     _;
339   }
340   /**
341    * @dev Modifier to make a function callable only when the contract is paused.
342    */
343   modifier whenPaused() {
344     require(paused);
345     _;
346   }
347   /**
348    * @dev called by the owner to pause, triggers stopped state
349    */
350   function pause() public onlyOwner whenNotPaused {
351     paused = true;
352     emit Pause();
353   }
354   /**
355    * @dev called by the owner to unpause, returns to normal state
356    */
357   function unpause() public onlyOwner whenPaused {
358     paused = false;
359     emit Unpause();
360   }
361 }
362 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
363 /**
364  * @title Pausable token
365  * @dev StandardToken modified with pausable transfers.
366  **/
367 contract PausableToken is StandardToken, Pausable {
368   function transfer(
369     address _to,
370     uint256 _value
371   )
372     public
373     whenNotPaused
374     returns (bool)
375   {
376     return super.transfer(_to, _value);
377   }
378   function transferFrom(
379     address _from,
380     address _to,
381     uint256 _value
382   )
383     public
384     whenNotPaused
385     returns (bool)
386   {
387     return super.transferFrom(_from, _to, _value);
388   }
389   function approve(
390     address _spender,
391     uint256 _value
392   )
393     public
394     whenNotPaused
395     returns (bool)
396   {
397     return super.approve(_spender, _value);
398   }
399   function increaseApproval(
400     address _spender,
401     uint _addedValue
402   )
403     public
404     whenNotPaused
405     returns (bool success)
406   {
407     return super.increaseApproval(_spender, _addedValue);
408   }
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
420 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
421 /**
422  * @title Mintable token
423  * @dev Simple ERC20 Token example, with mintable token creation
424  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
425  */
426 contract MintableToken is StandardToken, Ownable {
427   event Mint(address indexed to, uint256 amount);
428   event MintFinished();
429   bool public mintingFinished = false;
430   modifier canMint() {
431     require(!mintingFinished);
432     _;
433   }
434   modifier hasMintPermission() {
435     require(msg.sender == owner);
436     _;
437   }
438   /**
439    * @dev Function to mint tokens
440    * @param _to The address that will receive the minted tokens.
441    * @param _amount The amount of tokens to mint.
442    * @return A boolean that indicates if the operation was successful.
443    */
444   function mint(
445     address _to,
446     uint256 _amount
447   )
448     public
449     hasMintPermission
450     canMint
451     returns (bool)
452   {
453     _mint(_to, _amount);
454     emit Mint(_to, _amount);
455     return true;
456   }
457   /**
458    * @dev Function to stop minting new tokens.
459    * @return True if the operation was successful.
460    */
461   function finishMinting() public onlyOwner canMint returns (bool) {
462     mintingFinished = true;
463     emit MintFinished();
464     return true;
465   }
466 }
467 /**
468  * @title Capped token
469  * @dev Mintable token with a token cap.
470  */
471 contract CappedToken is MintableToken {
472   uint256 public cap;
473   constructor(uint256 _cap) public {
474     require(_cap > 0);
475     cap = _cap;
476   }
477   /**
478    * @dev Function to mint tokens
479    * @param _to The address that will receive the minted tokens.
480    * @param _amount The amount of tokens to mint.
481    * @return A boolean that indicates if the operation was successful.
482    */
483   function mint(
484     address _to,
485     uint256 _amount
486   )
487     public
488     returns (bool)
489   {
490     require(totalSupply().add(_amount) <= cap);
491     return super.mint(_to, _amount);
492   }
493 }
494 contract GaiaTechVentures is CappedToken(6000000000000000000000000000) {
495   string public name = "Gaia Tech Ventures";
496   string public symbol = "GTV";
497   uint8 public decimals = 18;
498   
499   constructor() public {
500     _mint(msg.sender, 3000000000000000000000000000);
501   }
502   
503 }