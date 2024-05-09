1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * See https://github.com/ethereum/EIPs/issues/179
60  */
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address _who) public view returns (uint256);
64   function transfer(address _to, uint256 _value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76   address public owner;
77 
78 
79   event OwnershipRenounced(address indexed previousOwner);
80   event OwnershipTransferred(
81     address indexed previousOwner,
82     address indexed newOwner
83   );
84 
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90   constructor() public {
91     owner = msg.sender;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to relinquish control of the contract.
104    * @notice Renouncing to ownership will leave the contract without an owner.
105    * It will not be possible to call the functions with the `onlyOwner`
106    * modifier anymore.
107    */
108   function renounceOwnership() public onlyOwner {
109     emit OwnershipRenounced(owner);
110     owner = address(0);
111   }
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address _newOwner) public onlyOwner {
118     _transferOwnership(_newOwner);
119   }
120 
121   /**
122    * @dev Transfers control of the contract to a newOwner.
123    * @param _newOwner The address to transfer ownership to.
124    */
125   function _transferOwnership(address _newOwner) internal {
126     require(_newOwner != address(0));
127     emit OwnershipTransferred(owner, _newOwner);
128     owner = _newOwner;
129   }
130 }
131 
132 
133 
134 
135 
136 
137 
138 
139 
140 
141 
142 
143 
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) internal balances;
153 
154   uint256 internal totalSupply_;
155 
156   /**
157   * @dev Total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev Transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(_value <= balances[msg.sender]);
170     require(_to != address(0));
171 
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     emit Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner) public view returns (uint256) {
184     return balances[_owner];
185   }
186 
187 }
188 
189 
190 
191 
192 
193 
194 /**
195  * @title ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/20
197  */
198 contract ERC20 is ERC20Basic {
199   function allowance(address _owner, address _spender)
200     public view returns (uint256);
201 
202   function transferFrom(address _from, address _to, uint256 _value)
203     public returns (bool);
204 
205   function approve(address _spender, uint256 _value) public returns (bool);
206   event Approval(
207     address indexed owner,
208     address indexed spender,
209     uint256 value
210   );
211 }
212 
213 
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * https://github.com/ethereum/EIPs/issues/20
220  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
221  */
222 contract StandardToken is ERC20, BasicToken {
223 
224   mapping (address => mapping (address => uint256)) internal allowed;
225 
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param _from address The address which you want to send tokens from
230    * @param _to address The address which you want to transfer to
231    * @param _value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(
234     address _from,
235     address _to,
236     uint256 _value
237   )
238     public
239     returns (bool)
240   {
241     require(_value <= balances[_from]);
242     require(_value <= allowed[_from][msg.sender]);
243     require(_to != address(0));
244 
245     balances[_from] = balances[_from].sub(_value);
246     balances[_to] = balances[_to].add(_value);
247     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
248     emit Transfer(_from, _to, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
254    * Beware that changing an allowance with this method brings the risk that someone may use both the old
255    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
256    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
257    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258    * @param _spender The address which will spend the funds.
259    * @param _value The amount of tokens to be spent.
260    */
261   function approve(address _spender, uint256 _value) public returns (bool) {
262     allowed[msg.sender][_spender] = _value;
263     emit Approval(msg.sender, _spender, _value);
264     return true;
265   }
266 
267   /**
268    * @dev Function to check the amount of tokens that an owner allowed to a spender.
269    * @param _owner address The address which owns the funds.
270    * @param _spender address The address which will spend the funds.
271    * @return A uint256 specifying the amount of tokens still available for the spender.
272    */
273   function allowance(
274     address _owner,
275     address _spender
276    )
277     public
278     view
279     returns (uint256)
280   {
281     return allowed[_owner][_spender];
282   }
283 
284   /**
285    * @dev Increase the amount of tokens that an owner allowed to a spender.
286    * approve should be called when allowed[_spender] == 0. To increment
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _addedValue The amount of tokens to increase the allowance by.
292    */
293   function increaseApproval(
294     address _spender,
295     uint256 _addedValue
296   )
297     public
298     returns (bool)
299   {
300     allowed[msg.sender][_spender] = (
301       allowed[msg.sender][_spender].add(_addedValue));
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306   /**
307    * @dev Decrease the amount of tokens that an owner allowed to a spender.
308    * approve should be called when allowed[_spender] == 0. To decrement
309    * allowed value is better to use this function to avoid 2 calls (and wait until
310    * the first transaction is mined)
311    * From MonolithDAO Token.sol
312    * @param _spender The address which will spend the funds.
313    * @param _subtractedValue The amount of tokens to decrease the allowance by.
314    */
315   function decreaseApproval(
316     address _spender,
317     uint256 _subtractedValue
318   )
319     public
320     returns (bool)
321   {
322     uint256 oldValue = allowed[msg.sender][_spender];
323     if (_subtractedValue >= oldValue) {
324       allowed[msg.sender][_spender] = 0;
325     } else {
326       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
327     }
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332 }
333 
334 
335 
336 
337 /**
338  * @title Mintable token
339  * @dev Simple ERC20 Token example, with mintable token creation
340  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
341  */
342 contract MintableToken is StandardToken, Ownable {
343   event Mint(address indexed to, uint256 amount);
344   event MintFinished();
345 
346   bool public mintingFinished = false;
347 
348 
349   modifier canMint() {
350     require(!mintingFinished);
351     _;
352   }
353 
354   modifier hasMintPermission() {
355     require(msg.sender == owner);
356     _;
357   }
358 
359   /**
360    * @dev Function to mint tokens
361    * @param _to The address that will receive the minted tokens.
362    * @param _amount The amount of tokens to mint.
363    * @return A boolean that indicates if the operation was successful.
364    */
365   function mint(
366     address _to,
367     uint256 _amount
368   )
369     public
370     hasMintPermission
371     canMint
372     returns (bool)
373   {
374     totalSupply_ = totalSupply_.add(_amount);
375     balances[_to] = balances[_to].add(_amount);
376     emit Mint(_to, _amount);
377     emit Transfer(address(0), _to, _amount);
378     return true;
379   }
380 
381   /**
382    * @dev Function to stop minting new tokens.
383    * @return True if the operation was successful.
384    */
385   function finishMinting() public onlyOwner canMint returns (bool) {
386     mintingFinished = true;
387     emit MintFinished();
388     return true;
389   }
390 }
391 
392 
393 
394 library SafeMath16 {
395   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
396     if (a == 0) {
397       return 0;
398     }
399     uint16 c = a * b;
400     assert(c / a == b);
401     return c;
402   }
403   function div(uint16 a, uint16 b) internal pure returns (uint16) {
404     // assert(b > 0); // Solidity automatically throws when dividing by 0
405     uint16 c = a / b;
406     // assert(a == b * c + a % b); // There is no case in which this doesn’t hold
407     return c;
408   }
409   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
410     assert(b <= a);
411     return a - b;
412   }
413   function add(uint16 a, uint16 b) internal pure returns (uint16) {
414     uint16 c = a + b;
415     assert(c >= a);
416     return c;
417   }
418 }
419 
420 
421 
422 /**
423  * @title MDAPPToken
424  * @dev Token for the Million Dollar Decentralized Application (MDAPP).
425  * Once a holder uses it to claim pixels the appropriate tokens are burned (1 Token <=> 10x10 pixel).
426  * If one releases his pixels new tokens are generated and credited to ones balance. Therefore, supply will
427  * vary between 0 and 10,000 tokens.
428  * Tokens are transferable once minting has finished.
429  * @dev Owned by MDAPP.sol
430  */
431 contract MDAPPToken is MintableToken {
432   using SafeMath16 for uint16;
433   using SafeMath for uint256;
434 
435   string public constant name = "MillionDollarDapp";
436   string public constant symbol = "MDAPP";
437   uint8 public constant decimals = 0;
438 
439   mapping (address => uint16) locked;
440 
441   bool public forceTransferEnable = false;
442 
443   /*********************************************************
444    *                                                       *
445    *                       Events                          *
446    *                                                       *
447    *********************************************************/
448 
449   // Emitted when owner force-allows transfers of tokens.
450   event AllowTransfer();
451 
452   /*********************************************************
453    *                                                       *
454    *                      Modifiers                        *
455    *                                                       *
456    *********************************************************/
457 
458   modifier hasLocked(address _account, uint16 _value) {
459     require(_value <= locked[_account], "Not enough locked tokens available.");
460     _;
461   }
462 
463   modifier hasUnlocked(address _account, uint16 _value) {
464     require(balanceOf(_account).sub(uint256(locked[_account])) >= _value, "Not enough unlocked tokens available.");
465     _;
466   }
467 
468   /**
469    * @dev Checks whether it can transfer or otherwise throws.
470    */
471   modifier canTransfer(address _sender, uint256 _value) {
472     require(_value <= transferableTokensOf(_sender), "Not enough unlocked tokens available.");
473     _;
474   }
475 
476 
477   /*********************************************************
478    *                                                       *
479    *                Limited Transfer Logic                 *
480    *            Taken from openzeppelin 1.3.0              *
481    *                                                       *
482    *********************************************************/
483 
484   function lockToken(address _account, uint16 _value) onlyOwner hasUnlocked(_account, _value) public {
485     locked[_account] = locked[_account].add(_value);
486   }
487 
488   function unlockToken(address _account, uint16 _value) onlyOwner hasLocked(_account, _value) public {
489     locked[_account] = locked[_account].sub(_value);
490   }
491 
492   /**
493    * @dev Checks modifier and allows transfer if tokens are not locked.
494    * @param _to The address that will receive the tokens.
495    * @param _value The amount of tokens to be transferred.
496    */
497   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
498     return super.transfer(_to, _value);
499   }
500 
501   /**
502   * @dev Checks modifier and allows transfer if tokens are not locked.
503   * @param _from The address that will send the tokens.
504   * @param _to The address that will receive the tokens.
505   * @param _value The amount of tokens to be transferred.
506   */
507   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
508     return super.transferFrom(_from, _to, _value);
509   }
510 
511   /**
512    * @dev Allow the holder to transfer his tokens only if every token in
513    * existence has already been distributed / minting is finished.
514    * Tokens which are locked for a claimed space cannot be transferred.
515    */
516   function transferableTokensOf(address _holder) public view returns (uint16) {
517     if (!mintingFinished && !forceTransferEnable) return 0;
518 
519     return uint16(balanceOf(_holder)).sub(locked[_holder]);
520   }
521 
522   /**
523    * @dev Get the number of pixel-locked tokens.
524    */
525   function lockedTokensOf(address _holder) public view returns (uint16) {
526     return locked[_holder];
527   }
528 
529   /**
530    * @dev Get the number of unlocked tokens usable for claiming pixels.
531    */
532   function unlockedTokensOf(address _holder) public view returns (uint256) {
533     return balanceOf(_holder).sub(uint256(locked[_holder]));
534   }
535 
536   // Allow transfer of tokens even if minting is not yet finished.
537   function allowTransfer() onlyOwner public {
538     require(forceTransferEnable == false, 'Transfer already force-allowed.');
539 
540     forceTransferEnable = true;
541     emit AllowTransfer();
542   }
543 }