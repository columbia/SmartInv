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
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that revert on error
68  */
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, reverts on overflow.
73   */
74   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
75     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (_a == 0) {
79       return 0;
80     }
81 
82     uint256 c = _a * _b;
83     require(c / _a == _b);
84 
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
90   */
91   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
92     require(_b > 0); // Solidity only automatically asserts when dividing by 0
93     uint256 c = _a / _b;
94     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
95 
96     return c;
97   }
98 
99   /**
100   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
101   */
102   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
103     require(_b <= _a);
104     uint256 c = _a - _b;
105 
106     return c;
107   }
108 
109   /**
110   * @dev Adds two numbers, reverts on overflow.
111   */
112   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
113     uint256 c = _a + _b;
114     require(c >= _a);
115 
116     return c;
117   }
118 
119   /**
120   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
121   * reverts when dividing by zero.
122   */
123   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124     require(b != 0);
125     return a % b;
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
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
166  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20 {
169   using SafeMath for uint256;
170 
171   mapping (address => uint256) private balances;
172 
173   mapping (address => mapping (address => uint256)) private allowed;
174 
175   uint256 private totalSupply_;
176 
177   /**
178   * @dev Total number of tokens in existence
179   */
180   function totalSupply() public view returns (uint256) {
181     return totalSupply_;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public view returns (uint256) {
190     return balances[_owner];
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(
200     address _owner,
201     address _spender
202    )
203     public
204     view
205     returns (uint256)
206   {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211   * @dev Transfer token for a specified address
212   * @param _to The address to transfer to.
213   * @param _value The amount to be transferred.
214   */
215   function transfer(address _to, uint256 _value) public returns (bool) {
216     require(_value <= balances[msg.sender]);
217     require(_to != address(0));
218 
219     balances[msg.sender] = balances[msg.sender].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     emit Transfer(msg.sender, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
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
241    * @dev Transfer tokens from one address to another
242    * @param _from address The address which you want to send tokens from
243    * @param _to address The address which you want to transfer to
244    * @param _value uint256 the amount of tokens to be transferred
245    */
246   function transferFrom(
247     address _from,
248     address _to,
249     uint256 _value
250   )
251     public
252     returns (bool)
253   {
254     require(_value <= balances[_from]);
255     require(_value <= allowed[_from][msg.sender]);
256     require(_to != address(0));
257 
258     balances[_from] = balances[_from].sub(_value);
259     balances[_to] = balances[_to].add(_value);
260     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
261     emit Transfer(_from, _to, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Increase the amount of tokens that an owner allowed to a spender.
267    * approve should be called when allowed[_spender] == 0. To increment
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param _spender The address which will spend the funds.
272    * @param _addedValue The amount of tokens to increase the allowance by.
273    */
274   function increaseApproval(
275     address _spender,
276     uint256 _addedValue
277   )
278     public
279     returns (bool)
280   {
281     allowed[msg.sender][_spender] = (
282       allowed[msg.sender][_spender].add(_addedValue));
283     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   /**
288    * @dev Decrease the amount of tokens that an owner allowed to a spender.
289    * approve should be called when allowed[_spender] == 0. To decrement
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _subtractedValue The amount of tokens to decrease the allowance by.
295    */
296   function decreaseApproval(
297     address _spender,
298     uint256 _subtractedValue
299   )
300     public
301     returns (bool)
302   {
303     uint256 oldValue = allowed[msg.sender][_spender];
304     if (_subtractedValue >= oldValue) {
305       allowed[msg.sender][_spender] = 0;
306     } else {
307       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
308     }
309     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310     return true;
311   }
312 
313   /**
314    * @dev Internal function that mints an amount of the token and assigns it to
315    * an account. This encapsulates the modification of balances such that the
316    * proper events are emitted.
317    * @param _account The account that will receive the created tokens.
318    * @param _amount The amount that will be created.
319    */
320   function _mint(address _account, uint256 _amount) internal {
321     require(_account != 0);
322     totalSupply_ = totalSupply_.add(_amount);
323     balances[_account] = balances[_account].add(_amount);
324     emit Transfer(address(0), _account, _amount);
325   }
326 
327   /**
328    * @dev Internal function that burns an amount of the token of a given
329    * account.
330    * @param _account The account whose tokens will be burnt.
331    * @param _amount The amount that will be burnt.
332    */
333   function _burn(address _account, uint256 _amount) internal {
334     require(_account != 0);
335     require(_amount <= balances[_account]);
336 
337     totalSupply_ = totalSupply_.sub(_amount);
338     balances[_account] = balances[_account].sub(_amount);
339     emit Transfer(_account, address(0), _amount);
340   }
341 
342   /**
343    * @dev Internal function that burns an amount of the token of a given
344    * account, deducting from the sender's allowance for said account. Uses the
345    * internal _burn function.
346    * @param _account The account whose tokens will be burnt.
347    * @param _amount The amount that will be burnt.
348    */
349   function _burnFrom(address _account, uint256 _amount) internal {
350     require(_amount <= allowed[_account][msg.sender]);
351 
352     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
353     // this function needs to emit an event with the updated approval.
354     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
355     _burn(_account, _amount);
356   }
357 }
358 
359 /**
360  * @title Mintable token
361  * @dev Simple ERC20 Token example, with mintable token creation
362  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
363  */
364 contract MintableToken is StandardToken, Ownable {
365   event Mint(address indexed to, uint256 amount);
366   event MintFinished();
367 
368   bool public mintingFinished = false;
369 
370 
371   modifier canMint() {
372     require(!mintingFinished);
373     _;
374   }
375 
376   modifier hasMintPermission() {
377     require(msg.sender == owner);
378     _;
379   }
380 
381   /**
382    * @dev Function to mint tokens
383    * @param _to The address that will receive the minted tokens.
384    * @param _amount The amount of tokens to mint.
385    * @return A boolean that indicates if the operation was successful.
386    */
387   function mint(
388     address _to,
389     uint256 _amount
390   )
391     public
392     hasMintPermission
393     canMint
394     returns (bool)
395   {
396     _mint(_to, _amount);
397     emit Mint(_to, _amount);
398     return true;
399   }
400 
401   /**
402    * @dev Function to stop minting new tokens.
403    * @return True if the operation was successful.
404    */
405   function finishMinting() public onlyOwner canMint returns (bool) {
406     mintingFinished = true;
407     emit MintFinished();
408     return true;
409   }
410 }
411 
412 /**
413  * @title Burnable Token
414  * @dev Token that can be irreversibly burned (destroyed).
415  */
416 contract BurnableToken is StandardToken {
417 
418   event Burn(address indexed burner, uint256 value);
419 
420   /**
421    * @dev Burns a specific amount of tokens.
422    * @param _value The amount of token to be burned.
423    */
424   function burn(uint256 _value) public {
425     _burn(msg.sender, _value);
426   }
427 
428   /**
429    * @dev Burns a specific amount of tokens from the target address and decrements allowance
430    * @param _from address The address which you want to send tokens from
431    * @param _value uint256 The amount of token to be burned
432    */
433   function burnFrom(address _from, uint256 _value) public {
434     _burnFrom(_from, _value);
435   }
436 
437   /**
438    * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
439    * an additional Burn event.
440    */
441   function _burn(address _who, uint256 _value) internal {
442     super._burn(_who, _value);
443     emit Burn(_who, _value);
444   }
445 }
446 
447 contract CiderZero is StandardToken , MintableToken , BurnableToken{
448 
449   string public constant name = "CiderZero";
450   string public constant symbol = "CIDER0";
451   uint8 public constant decimals = 18;
452   uint256 public INITIAL_SUPPLY = 8e9 * 1e18;
453 
454   /**
455    * @dev Constructor that gives msg.sender all of existing tokens.
456    */
457   constructor() public {
458     _mint(msg.sender, INITIAL_SUPPLY);
459   }
460 
461  function drop(address[] _toAddresses, uint256[] _amounts) public onlyOwner{
462             /* Ensures _toAddresses array is less than or equal to 255 */
463             require(_toAddresses.length <= 255);
464             /* Ensures _toAddress and _amounts have the same number of entries. */
465             require(_toAddresses.length == _amounts.length);
466 
467             for (uint8 i = 0; i < _toAddresses.length; i++) {
468                 transfer(_toAddresses[i], _amounts[i]);
469             }
470         }
471 }