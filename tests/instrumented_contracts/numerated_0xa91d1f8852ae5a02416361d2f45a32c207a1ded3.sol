1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     require(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     require(_b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     require(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     require(c >= _a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   event OwnershipRenounced(address indexed previousOwner);
77   event OwnershipTransferred(
78     address indexed previousOwner,
79     address indexed newOwner
80   );
81 
82 
83   /**
84    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85    * account.
86    */
87   constructor() public {
88     owner = msg.sender;
89   }
90 
91   /**
92    * @dev Throws if called by any account other than the owner.
93    */
94   modifier onlyOwner() {
95     require(msg.sender == owner);
96     _;
97   }
98 
99   /**
100    * @dev Allows the current owner to relinquish control of the contract.
101    * @notice Renouncing to ownership will leave the contract without an owner.
102    * It will not be possible to call the functions with the `onlyOwner`
103    * modifier anymore.
104    */
105   function renounceOwnership() public onlyOwner {
106     emit OwnershipRenounced(owner);
107     owner = address(0);
108   }
109 
110   /**
111    * @dev Allows the current owner to transfer control of the contract to a newOwner.
112    * @param _newOwner The address to transfer ownership to.
113    */
114   function transferOwnership(address _newOwner) public onlyOwner {
115     _transferOwnership(_newOwner);
116   }
117 
118   /**
119    * @dev Transfers control of the contract to a newOwner.
120    * @param _newOwner The address to transfer ownership to.
121    */
122   function _transferOwnership(address _newOwner) internal {
123     require(_newOwner != address(0));
124     emit OwnershipTransferred(owner, _newOwner);
125     owner = _newOwner;
126   }
127 }
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 {
134   function totalSupply() public view returns (uint256);
135 
136   function balanceOf(address _who) public view returns (uint256);
137 
138   function allowance(address _owner, address _spender)
139     public view returns (uint256);
140 
141   function transfer(address _to, uint256 _value) public returns (bool);
142 
143   function approve(address _spender, uint256 _value)
144     public returns (bool);
145 
146   function transferFrom(address _from, address _to, uint256 _value)
147     public returns (bool);
148 
149   event Transfer(
150     address indexed from,
151     address indexed to,
152     uint256 value
153   );
154 
155   event Approval(
156     address indexed owner,
157     address indexed spender,
158     uint256 value
159   );
160 }
161 
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
167  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
168  */
169 contract StandardToken is ERC20 {
170   using SafeMath for uint256;
171 
172   mapping (address => uint256) private balances;
173 
174   mapping (address => mapping (address => uint256)) private allowed;
175 
176   uint256 private totalSupply_;
177 
178   /**
179   * @dev Total number of tokens in existence
180   */
181   function totalSupply() public view returns (uint256) {
182     return totalSupply_;
183   }
184 
185   /**
186   * @dev Gets the balance of the specified address.
187   * @param _owner The address to query the the balance of.
188   * @return An uint256 representing the amount owned by the passed address.
189   */
190   function balanceOf(address _owner) public view returns (uint256) {
191     return balances[_owner];
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(
201     address _owner,
202     address _spender
203    )
204     public
205     view
206     returns (uint256)
207   {
208     return allowed[_owner][_spender];
209   }
210 
211   /**
212   * @dev Transfer token for a specified address
213   * @param _to The address to transfer to.
214   * @param _value The amount to be transferred.
215   */
216   function transfer(address _to, uint256 _value) public returns (bool) {
217     require(_value <= balances[msg.sender]);
218     require(_to != address(0));
219 
220     balances[msg.sender] = balances[msg.sender].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     emit Transfer(msg.sender, _to, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     emit Approval(msg.sender, _spender, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Transfer tokens from one address to another
243    * @param _from address The address which you want to send tokens from
244    * @param _to address The address which you want to transfer to
245    * @param _value uint256 the amount of tokens to be transferred
246    */
247   function transferFrom(
248     address _from,
249     address _to,
250     uint256 _value
251   )
252     public
253     returns (bool)
254   {
255     require(_value <= balances[_from]);
256     require(_value <= allowed[_from][msg.sender]);
257     require(_to != address(0));
258 
259     balances[_from] = balances[_from].sub(_value);
260     balances[_to] = balances[_to].add(_value);
261     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
262     emit Transfer(_from, _to, _value);
263     return true;
264   }
265 
266   /**
267    * @dev Increase the amount of tokens that an owner allowed to a spender.
268    * approve should be called when allowed[_spender] == 0. To increment
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _addedValue The amount of tokens to increase the allowance by.
274    */
275   function increaseApproval(
276     address _spender,
277     uint256 _addedValue
278   )
279     public
280     returns (bool)
281   {
282     allowed[msg.sender][_spender] = (
283       allowed[msg.sender][_spender].add(_addedValue));
284     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288   /**
289    * @dev Decrease the amount of tokens that an owner allowed to a spender.
290    * approve should be called when allowed[_spender] == 0. To decrement
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _subtractedValue The amount of tokens to decrease the allowance by.
296    */
297   function decreaseApproval(
298     address _spender,
299     uint256 _subtractedValue
300   )
301     public
302     returns (bool)
303   {
304     uint256 oldValue = allowed[msg.sender][_spender];
305     if (_subtractedValue >= oldValue) {
306       allowed[msg.sender][_spender] = 0;
307     } else {
308       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
309     }
310     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314   /**
315    * @dev Internal function that mints an amount of the token and assigns it to
316    * an account. This encapsulates the modification of balances such that the
317    * proper events are emitted.
318    * @param _account The account that will receive the created tokens.
319    * @param _amount The amount that will be created.
320    */
321   function _mint(address _account, uint256 _amount) internal {
322     require(_account != 0);
323     totalSupply_ = totalSupply_.add(_amount);
324     balances[_account] = balances[_account].add(_amount);
325     emit Transfer(address(0), _account, _amount);
326   }
327 
328   /**
329    * @dev Internal function that burns an amount of the token of a given
330    * account.
331    * @param _account The account whose tokens will be burnt.
332    * @param _amount The amount that will be burnt.
333    */
334   function _burn(address _account, uint256 _amount) internal {
335     require(_account != 0);
336     require(_amount <= balances[_account]);
337 
338     totalSupply_ = totalSupply_.sub(_amount);
339     balances[_account] = balances[_account].sub(_amount);
340     emit Transfer(_account, address(0), _amount);
341   }
342 
343   /**
344    * @dev Internal function that burns an amount of the token of a given
345    * account, deducting from the sender's allowance for said account. Uses the
346    * internal _burn function.
347    * @param _account The account whose tokens will be burnt.
348    * @param _amount The amount that will be burnt.
349    */
350   function _burnFrom(address _account, uint256 _amount) internal {
351     require(_amount <= allowed[_account][msg.sender]);
352 
353     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
354     // this function needs to emit an event with the updated approval.
355     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
356     _burn(_account, _amount);
357   }
358 }
359 
360 /**
361  * @title Mintable token
362  * @dev Simple ERC20 Token example, with mintable token creation
363  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
364  */
365 contract MintableToken is StandardToken, Ownable {
366   event Mint(address indexed to, uint256 amount);
367   event MintFinished();
368 
369   bool public mintingFinished = false;
370 
371 
372   modifier canMint() {
373     require(!mintingFinished);
374     _;
375   }
376 
377   modifier hasMintPermission() {
378     require(msg.sender == owner);
379     _;
380   }
381 
382   /**
383    * @dev Function to mint tokens
384    * @param _to The address that will receive the minted tokens.
385    * @param _amount The amount of tokens to mint.
386    * @return A boolean that indicates if the operation was successful.
387    */
388   function mint(
389     address _to,
390     uint256 _amount
391   )
392     public
393     hasMintPermission
394     canMint
395     returns (bool)
396   {
397     _mint(_to, _amount);
398     emit Mint(_to, _amount);
399     return true;
400   }
401 
402   /**
403    * @dev Function to stop minting new tokens.
404    * @return True if the operation was successful.
405    */
406   function finishMinting() public onlyOwner canMint returns (bool) {
407     mintingFinished = true;
408     emit MintFinished();
409     return true;
410   }
411 }
412 
413 
414 
415 /**
416  * @title Capped token
417  * @dev Mintable token with a token cap.
418  */
419 contract CappedToken is MintableToken {
420 
421   uint256 public cap;
422 
423   constructor(uint256 _cap) public {
424     require(_cap > 0);
425     cap = _cap;
426   }
427 
428   /**
429    * @dev Function to mint tokens
430    * @param _to The address that will receive the minted tokens.
431    * @param _amount The amount of tokens to mint.
432    * @return A boolean that indicates if the operation was successful.
433    */
434   function mint(
435     address _to,
436     uint256 _amount
437   )
438     public
439     returns (bool)
440   {
441     require(totalSupply().add(_amount) <= cap);
442 
443     return super.mint(_to, _amount);
444   }
445 
446 }
447 
448 /**
449  * @title Burnable Token
450  * @dev Token that can be irreversibly burned (destroyed).
451  */
452 contract BurnableToken is StandardToken, Ownable {
453 
454     event Burn(address indexed burner, uint256 value);
455 
456     /**
457      * @dev Burns a specific amount of tokens. Allowed only for contract owner.
458      * @param _value The amount of token to be burned.
459      */
460     function burn(address _who, uint256 _value) public onlyOwner() {
461         _burn(_who, _value);
462     }
463 
464     /**
465      * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
466      * an additional Burn event.
467      */
468     function _burn(address _who, uint256 _value) internal {
469         super._burn(_who, _value);
470         emit Burn(_who, _value);
471     }
472 }
473 
474 
475 
476 /**
477  * @title Basic token
478  * @dev Basic version of StandardToken, with no allowances.
479  */
480 contract CitowiseToken is StandardToken, Ownable, MintableToken, BurnableToken, CappedToken {
481 
482     string public name;
483     string public symbol;
484     uint8 public decimals;
485 
486     uint256 constant public TOKENS_CAP = 500000000;
487     uint256 constant public ETHER = 1000000000000000000;
488 
489     constructor() public CappedToken(TOKENS_CAP * ETHER) {
490         name = "Citowise Token";
491         symbol = "CTW";
492         decimals = 18;
493     }
494 
495     function burn(address _who, uint256 _value) public onlyOwner() canMint() {
496         _burn(_who, _value);
497     }
498 
499 }