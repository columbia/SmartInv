1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (_a == 0) {
83       return 0;
84     }
85 
86     c = _a * _b;
87     assert(c / _a == _b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
95     // assert(_b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = _a / _b;
97     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
98     return _a / _b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
105     assert(_b <= _a);
106     return _a - _b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
113     c = _a + _b;
114     assert(c >= _a);
115     return c;
116   }
117 }
118 
119 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) internal balances;
143 
144   uint256 internal totalSupply_;
145 
146   /**
147   * @dev Total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_value <= balances[msg.sender]);
160     require(_to != address(0));
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
180 
181 /**
182  * @title Burnable Token
183  * @dev Token that can be irreversibly burned (destroyed).
184  */
185 contract BurnableToken is BasicToken {
186 
187   event Burn(address indexed burner, uint256 value);
188 
189   /**
190    * @dev Burns a specific amount of tokens.
191    * @param _value The amount of token to be burned.
192    */
193   function burn(uint256 _value) public {
194     _burn(msg.sender, _value);
195   }
196 
197   function _burn(address _who, uint256 _value) internal {
198     require(_value <= balances[_who]);
199     // no need to require value <= totalSupply, since that would imply the
200     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
201 
202     balances[_who] = balances[_who].sub(_value);
203     totalSupply_ = totalSupply_.sub(_value);
204     emit Burn(_who, _value);
205     emit Transfer(_who, address(0), _value);
206   }
207 }
208 
209 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
210 
211 /**
212  * @title ERC20 interface
213  * @dev see https://github.com/ethereum/EIPs/issues/20
214  */
215 contract ERC20 is ERC20Basic {
216   function allowance(address _owner, address _spender)
217     public view returns (uint256);
218 
219   function transferFrom(address _from, address _to, uint256 _value)
220     public returns (bool);
221 
222   function approve(address _spender, uint256 _value) public returns (bool);
223   event Approval(
224     address indexed owner,
225     address indexed spender,
226     uint256 value
227   );
228 }
229 
230 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
231 
232 /**
233  * @title Standard ERC20 token
234  *
235  * @dev Implementation of the basic standard token.
236  * https://github.com/ethereum/EIPs/issues/20
237  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
238  */
239 contract StandardToken is ERC20, BasicToken {
240 
241   mapping (address => mapping (address => uint256)) internal allowed;
242 
243 
244   /**
245    * @dev Transfer tokens from one address to another
246    * @param _from address The address which you want to send tokens from
247    * @param _to address The address which you want to transfer to
248    * @param _value uint256 the amount of tokens to be transferred
249    */
250   function transferFrom(
251     address _from,
252     address _to,
253     uint256 _value
254   )
255     public
256     returns (bool)
257   {
258     require(_value <= balances[_from]);
259     require(_value <= allowed[_from][msg.sender]);
260     require(_to != address(0));
261 
262     balances[_from] = balances[_from].sub(_value);
263     balances[_to] = balances[_to].add(_value);
264     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
265     emit Transfer(_from, _to, _value);
266     return true;
267   }
268 
269   /**
270    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
271    * Beware that changing an allowance with this method brings the risk that someone may use both the old
272    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    * @param _spender The address which will spend the funds.
276    * @param _value The amount of tokens to be spent.
277    */
278   function approve(address _spender, uint256 _value) public returns (bool) {
279     allowed[msg.sender][_spender] = _value;
280     emit Approval(msg.sender, _spender, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Function to check the amount of tokens that an owner allowed to a spender.
286    * @param _owner address The address which owns the funds.
287    * @param _spender address The address which will spend the funds.
288    * @return A uint256 specifying the amount of tokens still available for the spender.
289    */
290   function allowance(
291     address _owner,
292     address _spender
293    )
294     public
295     view
296     returns (uint256)
297   {
298     return allowed[_owner][_spender];
299   }
300 
301   /**
302    * @dev Increase the amount of tokens that an owner allowed to a spender.
303    * approve should be called when allowed[_spender] == 0. To increment
304    * allowed value is better to use this function to avoid 2 calls (and wait until
305    * the first transaction is mined)
306    * From MonolithDAO Token.sol
307    * @param _spender The address which will spend the funds.
308    * @param _addedValue The amount of tokens to increase the allowance by.
309    */
310   function increaseApproval(
311     address _spender,
312     uint256 _addedValue
313   )
314     public
315     returns (bool)
316   {
317     allowed[msg.sender][_spender] = (
318       allowed[msg.sender][_spender].add(_addedValue));
319     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320     return true;
321   }
322 
323   /**
324    * @dev Decrease the amount of tokens that an owner allowed to a spender.
325    * approve should be called when allowed[_spender] == 0. To decrement
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _subtractedValue The amount of tokens to decrease the allowance by.
331    */
332   function decreaseApproval(
333     address _spender,
334     uint256 _subtractedValue
335   )
336     public
337     returns (bool)
338   {
339     uint256 oldValue = allowed[msg.sender][_spender];
340     if (_subtractedValue >= oldValue) {
341       allowed[msg.sender][_spender] = 0;
342     } else {
343       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
344     }
345     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346     return true;
347   }
348 
349 }
350 
351 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
352 
353 /**
354  * @title Mintable token
355  * @dev Simple ERC20 Token example, with mintable token creation
356  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
357  */
358 contract MintableToken is StandardToken, Ownable {
359   event Mint(address indexed to, uint256 amount);
360   event MintFinished();
361 
362   bool public mintingFinished = false;
363 
364 
365   modifier canMint() {
366     require(!mintingFinished);
367     _;
368   }
369 
370   modifier hasMintPermission() {
371     require(msg.sender == owner);
372     _;
373   }
374 
375   /**
376    * @dev Function to mint tokens
377    * @param _to The address that will receive the minted tokens.
378    * @param _amount The amount of tokens to mint.
379    * @return A boolean that indicates if the operation was successful.
380    */
381   function mint(
382     address _to,
383     uint256 _amount
384   )
385     public
386     hasMintPermission
387     canMint
388     returns (bool)
389   {
390     totalSupply_ = totalSupply_.add(_amount);
391     balances[_to] = balances[_to].add(_amount);
392     emit Mint(_to, _amount);
393     emit Transfer(address(0), _to, _amount);
394     return true;
395   }
396 
397   /**
398    * @dev Function to stop minting new tokens.
399    * @return True if the operation was successful.
400    */
401   function finishMinting() public onlyOwner canMint returns (bool) {
402     mintingFinished = true;
403     emit MintFinished();
404     return true;
405   }
406 }
407 
408 // File: contracts/Dcmc.sol
409 
410 contract Dcmc is MintableToken, BurnableToken{
411   string public name = 'Digital Currency Mining Coin';
412   string public symbol = 'DCMC';
413   uint public decimals = 18;
414   address public admin_wallet = 0xae9e15896fd32e59c7d89ce7a95a9352d6ebd70e;
415 
416   mapping(address => uint256) internal lockups;
417   event Lockup(address indexed to, uint256 lockuptime);
418   mapping (address => bool) public frozenAccount;
419   event FrozenFunds(address indexed target, bool frozen);
420   
421   mapping(address => uint256[7]) lockupBalances;
422   mapping(address => uint256[7]) releaseTimes;
423   constructor() public {
424   }
425 
426   function lockup(address _to, uint256 _lockupTimeUntil) public onlyOwner {
427     lockups[_to] = _lockupTimeUntil;
428     emit Lockup(_to, _lockupTimeUntil);
429   }
430   function lockupAccounts(address[] targets, uint256 _lockupTimeUntil) public onlyOwner {
431     require(targets.length > 0);
432     for (uint j = 0; j < targets.length; j++) {
433       require(targets[j] != 0x0);
434       lockups[targets[j]] = _lockupTimeUntil;
435       emit Lockup(targets[j], _lockupTimeUntil);
436     }
437   }
438 
439   function lockupOf(address _owner) public view returns (uint256) {
440     return lockups[_owner];
441   }
442 
443   function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
444     require(targets.length > 0);
445     for (uint j = 0; j < targets.length; j++) {
446       require(targets[j] != 0x0);
447       frozenAccount[targets[j]] = isFrozen;
448       emit FrozenFunds(targets[j], isFrozen);
449     }
450   }
451   function freezeOf(address _owner) public view returns (bool) {
452     return frozenAccount[_owner];
453   }
454 
455   function distribute(address _to, uint256 _first_release, uint256[] amount) onlyOwner external returns (bool) {
456     require(_to != address(0));
457     require(amount.length == 7);
458     _updateLockUpAmountOf(msg.sender);
459     uint256 __total = 0;
460     for(uint j = 0; j < amount.length; j++){
461       require(lockupBalances[_to][j] == 0);
462       __total = __total.add(amount[j]);
463       lockupBalances[_to][j] = lockupBalances[_to][j].add(amount[j]);
464       releaseTimes[_to][j] = _first_release + (j * 30 days) ;
465     }
466     balances[msg.sender] = balances[msg.sender].sub(__total);
467     emit Transfer(msg.sender, _to, __total);
468     return true;
469   }
470 
471   function lockupBalancesOf(address _address) public view returns(uint256[7]){
472     return ( lockupBalances[_address]);
473   }
474 
475   function releaseTimeOf(address _address) public view returns(uint256[7]){
476     return (releaseTimes[_address]);
477   }
478 
479   function _updateLockUpAmountOf(address _address) internal {
480     for(uint i = 0; i < 7; i++){
481       if(releaseTimes[_address][i] != 0 && now >= releaseTimes[_address][i]){
482         balances[_address] = balances[_address].add(lockupBalances[_address][i]);
483         lockupBalances[_address][i] = 0;
484         releaseTimes[_address][i] = 0;
485       }
486     }
487   }
488 
489   function retrieve(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
490     require(_value <= balances[_from]);
491     balances[_from] = balances[_from].sub(_value);
492     balances[_to] = balances[_to].add(_value);
493     emit Transfer(_from, _to, _value);
494     return true;
495   }
496 
497   function balanceOf(address _owner) public view returns (uint256) {
498     uint256 balance = 0;
499     balance = balance.add(balances[_owner]);
500     for(uint i = 0; i < 7; i++){
501       balance = balance.add(lockupBalances[_owner][i]);
502     }
503     return balance;
504   }
505 
506   function transfer(address _to, uint256 _value) public returns (bool) {
507     require(_to != address(0));
508     require(_to != address(this));
509     _updateLockUpAmountOf(msg.sender);
510     uint256 _fee = _value.mul(15).div(10000);
511     require(_value.add(_fee) <= balances[msg.sender]);
512     require(block.timestamp > lockups[msg.sender]);
513     require(block.timestamp > lockups[_to]);
514     require(frozenAccount[msg.sender] == false);
515     require(frozenAccount[_to] == false);
516 
517     balances[msg.sender] = balances[msg.sender].sub(_value.add(_fee));
518     balances[_to] = balances[_to].add(_value);
519     balances[admin_wallet] = balances[admin_wallet].add(_fee);
520     emit Transfer(msg.sender, _to, _value);
521     emit Transfer(msg.sender, admin_wallet, _fee);
522     return true;
523   }
524 }