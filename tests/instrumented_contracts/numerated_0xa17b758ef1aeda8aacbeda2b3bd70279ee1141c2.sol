1 pragma solidity ^0.4.25;
2 
3 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
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
67 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * See https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address _who) public view returns (uint256);
77   function transfer(address _to, uint256 _value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
93     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
94     // benefit is lost if 'b' is also tested.
95     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
96     if (_a == 0) {
97       return 0;
98     }
99 
100     c = _a * _b;
101     assert(c / _a == _b);
102     return c;
103   }
104 
105   /**
106   * @dev Integer division of two numbers, truncating the quotient.
107   */
108   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
109     // assert(_b > 0); // Solidity automatically throws when dividing by 0
110     // uint256 c = _a / _b;
111     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
112     return _a / _b;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
119     assert(_b <= _a);
120     return _a - _b;
121   }
122 
123   /**
124   * @dev Adds two numbers, throws on overflow.
125   */
126   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
127     c = _a + _b;
128     assert(c >= _a);
129     return c;
130   }
131 }
132 
133 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
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
179 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
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
209 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
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
230 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
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
351 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardBurnableToken.sol
352 
353 /**
354  * @title Standard Burnable Token
355  * @dev Adds burnFrom method to ERC20 implementations
356  */
357 contract StandardBurnableToken is BurnableToken, StandardToken {
358 
359   /**
360    * @dev Burns a specific amount of tokens from the target address and decrements allowance
361    * @param _from address The address which you want to send tokens from
362    * @param _value uint256 The amount of token to be burned
363    */
364   function burnFrom(address _from, uint256 _value) public {
365     require(_value <= allowed[_from][msg.sender]);
366     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
367     // this function needs to emit an event with the updated approval.
368     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
369     _burn(_from, _value);
370   }
371 }
372 
373 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\MintableToken.sol
374 
375 /**
376  * @title Mintable token
377  * @dev Simple ERC20 Token example, with mintable token creation
378  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
379  */
380 contract MintableToken is StandardToken, Ownable {
381   event Mint(address indexed to, uint256 amount);
382   event MintFinished();
383 
384   bool public mintingFinished = false;
385 
386 
387   modifier canMint() {
388     require(!mintingFinished);
389     _;
390   }
391 
392   modifier hasMintPermission() {
393     require(msg.sender == owner);
394     _;
395   }
396 
397   /**
398    * @dev Function to mint tokens
399    * @param _to The address that will receive the minted tokens.
400    * @param _amount The amount of tokens to mint.
401    * @return A boolean that indicates if the operation was successful.
402    */
403   function mint(
404     address _to,
405     uint256 _amount
406   )
407     public
408     hasMintPermission
409     canMint
410     returns (bool)
411   {
412     totalSupply_ = totalSupply_.add(_amount);
413     balances[_to] = balances[_to].add(_amount);
414     emit Mint(_to, _amount);
415     emit Transfer(address(0), _to, _amount);
416     return true;
417   }
418 
419   /**
420    * @dev Function to stop minting new tokens.
421    * @return True if the operation was successful.
422    */
423   function finishMinting() public onlyOwner canMint returns (bool) {
424     mintingFinished = true;
425     emit MintFinished();
426     return true;
427   }
428 }
429 
430 // File: contracts\GPA.sol
431 
432 /**
433  * @title GPA Token
434  * @dev The main GPA token contract
435  */
436 contract GPAToken is StandardBurnableToken, MintableToken {
437 
438   string public name = "Game Platform Accelerator Token";
439   string public symbol = "GPA";
440   uint8 public decimals = 18;
441   uint256 constant MAX_CAP = 10000000000;
442 
443   bool public pubTrade = false;
444 
445   mapping(address => bool) private freezeList;
446   address[] private indexFreezeList;
447 
448   event AddFreezeUser(address indexed addr);
449   event RemoveFreezeUser(address indexed addr);
450   event PublicTrade(bool pubTrade);
451 
452   /**
453    * @dev modifier that throws if trading has not started yet
454    */
455   modifier allowedTrade() {
456     require(pubTrade || owner == msg.sender);
457     require(!_isFreezeList());
458     _;
459   }
460 
461   /*
462  * @dev Fix for the ERC20 short address attack
463  */
464  modifier onlyPayloadSize(uint size) {
465    assert(msg.data.length >= size + 4);
466    _;
467  }
468 
469   function _isFreezeList() internal view returns (bool) {
470       return (freezeList[msg.sender] ? freezeList[msg.sender] : false);
471   }
472 
473   /**
474    * @dev Checking if you are a freeze member.
475    */
476   function checkFreeze(address _addr) public view returns (bool) {
477       return freezeList[_addr];
478   }
479 
480   /**
481    * @dev Get a list of freeze members.
482    */
483   function getFreezeList() public view onlyOwner returns (address[]) {
484       return indexFreezeList;
485   }
486 
487   /**
488    * @dev Adding as a freeze member.
489    */
490   function addFreeze(address _addr) public onlyOwner {
491       if(!freezeList[_addr]) {
492         indexFreezeList.push(_addr);
493       }
494       freezeList[_addr] = true;
495       emit AddFreezeUser(_addr);
496   }
497 
498   /**
499    * @dev Removing from freeze member.
500    */
501   function removeFreeze(address _addr) public onlyOwner {
502       freezeList[_addr] = false;
503       emit RemoveFreezeUser(_addr);
504   }
505 
506   /**
507    * @dev Allows the owner to enable the public trading.
508    */
509   function startPubTrade() public onlyOwner {
510     pubTrade = true;
511     emit PublicTrade(pubTrade);
512   }
513 
514   /**
515    * @dev Allows the owner to disable the trading.
516    */
517   function stopPubTrade() public onlyOwner {
518     pubTrade = false;
519     emit PublicTrade(pubTrade);
520   }
521 
522   /**
523   * @dev Function to mint tokens
524   * @param _to The address that will receive the minted tokens.
525   * @param _amount The amount of tokens to mint.
526   * @return A boolean that indicates if the operation was successful.
527   */
528   function mint(address _to, uint256 _amount) public onlyOwner onlyPayloadSize(2 * 32) returns (bool) {
529     require(totalSupply().add(_amount) <= MAX_CAP.mul(10 ** uint256(decimals)));
530     return super.mint(_to, _amount);
531   }
532 
533   /**
534   * @dev Transfer token for a specified address
535   * @param _to The address to transfer to.
536   * @param _value The amount to be transferred.
537   */
538   function transfer(address _to, uint256 _value) public allowedTrade onlyPayloadSize(2 * 32) returns (bool) {
539     return super.transfer(_to, _value);
540   }
541 
542   /**
543    * @dev Transfer tokens from one address to another
544    * @param _from address The address which you want to send tokens from
545    * @param _to address The address which you want to transfer to
546    * @param _value uint256 the amount of tokens to be transferred
547    */
548   function transferFrom(address _from, address _to, uint256 _value) public allowedTrade onlyPayloadSize(2 * 32) returns (bool) {
549     return super.transferFrom(_from, _to, _value);
550   }
551 
552 }