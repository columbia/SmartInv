1 pragma solidity ^0.5.0;
2 
3 // ==== Open Zeppelin Library  ====
4 // modified by pash7ka to be compatible with Solidity v0.5
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (a == 0) {
20       return 0;
21     }
22 
23     c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions".
60  */
61 contract Ownable {
62   address payable public owner;
63 
64 
65   event OwnershipRenounced(address indexed previousOwner);
66   event OwnershipTransferred(
67     address indexed previousOwner,
68     address indexed newOwner
69   );
70 
71 
72   /**
73    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74    * account.
75    */
76   constructor() public {
77     owner = msg.sender;
78   }
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88   /**
89    * @dev Allows the current owner to relinquish control of the contract.
90    * @notice Renouncing to ownership will leave the contract without an owner.
91    * It will not be possible to call the functions with the `onlyOwner`
92    * modifier anymore.
93    */
94   function renounceOwnership() public onlyOwner {
95     emit OwnershipRenounced(owner);
96     owner = address(0);
97   }
98 
99   /**
100    * @dev Allows the current owner to transfer control of the contract to a newOwner.
101    * @param _newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address payable _newOwner) public onlyOwner {
104     _transferOwnership(_newOwner);
105   }
106 
107   /**
108    * @dev Transfers control of the contract to a newOwner.
109    * @param _newOwner The address to transfer ownership to.
110    */
111   function _transferOwnership(address payable _newOwner) internal {
112     require(_newOwner != address(0));
113     emit OwnershipTransferred(owner, _newOwner);
114     owner = _newOwner;
115   }
116 }
117 
118 /**
119  * @title Claimable
120  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
121  * This allows the new owner to accept the transfer.
122  */
123 contract Claimable is Ownable {
124   address payable public  pendingOwner;
125 
126   /**
127    * @dev Modifier throws if called by any account other than the pendingOwner.
128    */
129   modifier onlyPendingOwner() {
130     require(msg.sender == pendingOwner);
131     _;
132   }
133 
134   /**
135    * @dev Allows the current owner to set the pendingOwner address.
136    * @param newOwner The address to transfer ownership to.
137    */
138   function transferOwnership(address payable newOwner) onlyOwner public {
139     pendingOwner = newOwner;
140   }
141 
142   /**
143    * @dev Allows the pendingOwner address to finalize the transfer.
144    */
145   function claimOwnership() onlyPendingOwner public {
146     emit OwnershipTransferred(owner, pendingOwner);
147     owner = pendingOwner;
148     pendingOwner = address(0);
149   }
150 }
151 
152 /**
153  * @title Contracts that should not own Ether
154  * @author Remco Bloemen <remco@2ПЂ.com>
155  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
156  * in the contract, it will allow the owner to reclaim this ether.
157  * @notice Ether can still be sent to this contract by:
158  * calling functions labeled `payable`
159  * `selfdestruct(contract_address)`
160  * mining directly to the contract address
161  */
162 contract HasNoEther is Ownable {
163 
164   /**
165   * @dev Constructor that rejects incoming Ether
166   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
167   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
168   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
169   * we could use assembly to access msg.value.
170   */
171   constructor() public payable {
172     require(msg.value == 0);
173   }
174 
175   /**
176    * @dev Disallows direct send by settings a default function without the `payable` flag.
177    */
178   function() external {
179   }
180 
181   /**
182    * @dev Transfer all Ether held by the contract to the owner.
183    */
184   function reclaimEther() external onlyOwner {
185     owner.transfer(address(this).balance);
186   }
187 }
188 
189 /**
190  * @title ERC20Basic
191  * @dev Simpler version of ERC20 interface
192  * See https://github.com/ethereum/EIPs/issues/179
193  */
194 contract ERC20Basic {
195   function totalSupply() public view returns (uint256);
196   function balanceOf(address who) public view returns (uint256);
197   function transfer(address to, uint256 value) public returns (bool);
198   event Transfer(address indexed from, address indexed to, uint256 value);
199 }
200 
201 /**
202  * @title ERC20 interface
203  * @dev see https://github.com/ethereum/EIPs/issues/20
204  */
205 contract ERC20 is ERC20Basic {
206   function allowance(address owner, address spender)
207     public view returns (uint256);
208 
209   function transferFrom(address from, address to, uint256 value)
210     public returns (bool);
211 
212   function approve(address spender, uint256 value) public returns (bool);
213   event Approval(
214     address indexed owner,
215     address indexed spender,
216     uint256 value
217   );
218 }
219 
220 /**
221  * @title SafeERC20
222  * @dev Wrappers around ERC20 operations that throw on failure.
223  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
224  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
225  */
226 library SafeERC20 {
227   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
228     require(token.transfer(to, value));
229   }
230 
231   function safeTransferFrom(
232     ERC20 token,
233     address from,
234     address to,
235     uint256 value
236   )
237     internal
238   {
239     require(token.transferFrom(from, to, value));
240   }
241 
242   function safeApprove(ERC20 token, address spender, uint256 value) internal {
243     require(token.approve(spender, value));
244   }
245 }
246 
247 /**
248  * @title Contracts that should be able to recover tokens
249  * @author SylTi
250  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
251  * This will prevent any accidental loss of tokens.
252  */
253 contract CanReclaimToken is Ownable {
254   using SafeERC20 for ERC20Basic;
255 
256   /**
257    * @dev Reclaim all ERC20Basic compatible tokens
258    * @param token ERC20Basic The address of the token contract
259    */
260   function reclaimToken(ERC20Basic token) external onlyOwner {
261     uint256 balance = token.balanceOf(address(this));
262     token.safeTransfer(owner, balance);
263   }
264 
265 }
266 
267 /**
268  * @title Contracts that should not own Tokens
269  * @author Remco Bloemen <remco@2ПЂ.com>
270  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
271  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
272  * owner to reclaim the tokens.
273  */
274 contract HasNoTokens is CanReclaimToken {
275 
276  /**
277   * @dev Reject all ERC223 compatible tokens
278   * @param from_ address The address that is transferring the tokens
279   * @param value_ uint256 the amount of the specified token
280   * @param data_ Bytes The data passed from the caller.
281   */
282   function tokenFallback(address from_, uint256 value_, bytes calldata data_) pure external {
283     from_;
284     value_;
285     data_;
286     revert();
287   }
288 
289 }
290 
291 /**
292  * @title Contracts that should not own Contracts
293  * @author Remco Bloemen <remco@2ПЂ.com>
294  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
295  * of this contract to reclaim ownership of the contracts.
296  */
297 contract HasNoContracts is Ownable {
298 
299   /**
300    * @dev Reclaim ownership of Ownable contracts
301    * @param contractAddr The address of the Ownable to be reclaimed.
302    */
303   function reclaimContract(address contractAddr) external onlyOwner {
304     Ownable contractInst = Ownable(contractAddr);
305     contractInst.transferOwnership(owner);
306   }
307 }
308 
309 /**
310  * @title Base contract for contracts that should not own things.
311  * @author Remco Bloemen <remco@2ПЂ.com>
312  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
313  * Owned contracts. See respective base contracts for details.
314  */
315 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
316 }
317 
318 /**
319  * @title Destructible
320  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
321  */
322 contract Destructible is Ownable {
323 
324   constructor() public payable { }
325 
326   /**
327    * @dev Transfers the current balance to the owner and terminates the contract.
328    */
329   function destroy() onlyOwner public {
330     selfdestruct(owner);
331   }
332 
333   function destroyAndSend(address payable _recipient) onlyOwner public {
334     selfdestruct(_recipient);
335   }
336 }
337 
338 /**
339  * @title Basic token
340  * @dev Basic version of StandardToken, with no allowances.
341  */
342 contract BasicToken is ERC20Basic {
343   using SafeMath for uint256;
344 
345   mapping(address => uint256) balances;
346 
347   uint256 totalSupply_;
348 
349   /**
350   * @dev Total number of tokens in existence
351   */
352   function totalSupply() public view returns (uint256) {
353     return totalSupply_;
354   }
355 
356   /**
357   * @dev Transfer token for a specified address
358   * @param _to The address to transfer to.
359   * @param _value The amount to be transferred.
360   */
361   function transfer(address _to, uint256 _value) public returns (bool) {
362     require(_to != address(0));
363     require(_value <= balances[msg.sender]);
364 
365     balances[msg.sender] = balances[msg.sender].sub(_value);
366     balances[_to] = balances[_to].add(_value);
367     emit Transfer(msg.sender, _to, _value);
368     return true;
369   }
370 
371   /**
372   * @dev Gets the balance of the specified address.
373   * @param _owner The address to query the the balance of.
374   * @return An uint256 representing the amount owned by the passed address.
375   */
376   function balanceOf(address _owner) public view returns (uint256) {
377     return balances[_owner];
378   }
379 
380 }
381 
382 /**
383  * @title Standard ERC20 token
384  *
385  * @dev Implementation of the basic standard token.
386  * https://github.com/ethereum/EIPs/issues/20
387  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
388  */
389 contract StandardToken is ERC20, BasicToken {
390 
391   mapping (address => mapping (address => uint256)) internal allowed;
392 
393 
394   /**
395    * @dev Transfer tokens from one address to another
396    * @param _from address The address which you want to send tokens from
397    * @param _to address The address which you want to transfer to
398    * @param _value uint256 the amount of tokens to be transferred
399    */
400   function transferFrom(
401     address _from,
402     address _to,
403     uint256 _value
404   )
405     public
406     returns (bool)
407   {
408     require(_to != address(0));
409     require(_value <= balances[_from]);
410     require(_value <= allowed[_from][msg.sender]);
411 
412     balances[_from] = balances[_from].sub(_value);
413     balances[_to] = balances[_to].add(_value);
414     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
415     emit Transfer(_from, _to, _value);
416     return true;
417   }
418 
419   /**
420    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
421    * Beware that changing an allowance with this method brings the risk that someone may use both the old
422    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
423    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
424    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
425    * @param _spender The address which will spend the funds.
426    * @param _value The amount of tokens to be spent.
427    */
428   function approve(address _spender, uint256 _value) public returns (bool) {
429     allowed[msg.sender][_spender] = _value;
430     emit Approval(msg.sender, _spender, _value);
431     return true;
432   }
433 
434   /**
435    * @dev Function to check the amount of tokens that an owner allowed to a spender.
436    * @param _owner address The address which owns the funds.
437    * @param _spender address The address which will spend the funds.
438    * @return A uint256 specifying the amount of tokens still available for the spender.
439    */
440   function allowance(
441     address _owner,
442     address _spender
443    )
444     public
445     view
446     returns (uint256)
447   {
448     return allowed[_owner][_spender];
449   }
450 
451   /**
452    * @dev Increase the amount of tokens that an owner allowed to a spender.
453    * approve should be called when allowed[_spender] == 0. To increment
454    * allowed value is better to use this function to avoid 2 calls (and wait until
455    * the first transaction is mined)
456    * From MonolithDAO Token.sol
457    * @param _spender The address which will spend the funds.
458    * @param _addedValue The amount of tokens to increase the allowance by.
459    */
460   function increaseApproval(
461     address _spender,
462     uint256 _addedValue
463   )
464     public
465     returns (bool)
466   {
467     allowed[msg.sender][_spender] = (
468       allowed[msg.sender][_spender].add(_addedValue));
469     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
470     return true;
471   }
472 
473   /**
474    * @dev Decrease the amount of tokens that an owner allowed to a spender.
475    * approve should be called when allowed[_spender] == 0. To decrement
476    * allowed value is better to use this function to avoid 2 calls (and wait until
477    * the first transaction is mined)
478    * From MonolithDAO Token.sol
479    * @param _spender The address which will spend the funds.
480    * @param _subtractedValue The amount of tokens to decrease the allowance by.
481    */
482   function decreaseApproval(
483     address _spender,
484     uint256 _subtractedValue
485   )
486     public
487     returns (bool)
488   {
489     uint256 oldValue = allowed[msg.sender][_spender];
490     if (_subtractedValue > oldValue) {
491       allowed[msg.sender][_spender] = 0;
492     } else {
493       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
494     }
495     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
496     return true;
497   }
498 
499 }
500 
501 /**
502  * @title Mintable token
503  * @dev Simple ERC20 Token example, with mintable token creation
504  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
505  */
506 contract MintableToken is StandardToken, Ownable {
507   event Mint(address indexed to, uint256 amount);
508   event MintFinished();
509 
510   bool public mintingFinished = false;
511 
512 
513   modifier canMint() {
514     require(!mintingFinished);
515     _;
516   }
517 
518   modifier hasMintPermission() {
519     require(msg.sender == owner);
520     _;
521   }
522 
523   /**
524    * @dev Function to mint tokens
525    * @param _to The address that will receive the minted tokens.
526    * @param _amount The amount of tokens to mint.
527    * @return A boolean that indicates if the operation was successful.
528    */
529   function mint(
530     address _to,
531     uint256 _amount
532   )
533     hasMintPermission
534     canMint
535     public
536     returns (bool)
537   {
538     totalSupply_ = totalSupply_.add(_amount);
539     balances[_to] = balances[_to].add(_amount);
540     emit Mint(_to, _amount);
541     emit Transfer(address(0), _to, _amount);
542     return true;
543   }
544 
545   /**
546    * @dev Function to stop minting new tokens.
547    * @return True if the operation was successful.
548    */
549   function finishMinting() onlyOwner canMint public returns (bool) {
550     mintingFinished = true;
551     emit MintFinished();
552     return true;
553   }
554 }
555 
556 // ===== APADS contracts ====
557 
558 contract APADSToken is MintableToken, NoOwner, Claimable {
559     string public symbol = 'APA';
560     string public name = 'APADS';
561     uint8 public constant decimals = 18;
562 
563     bool public transferEnabled;
564 
565     modifier canTransfer() {
566         require( transferEnabled || msg.sender == owner);
567         _;
568     }
569 
570     function setTransferEnabled(bool enable) onlyOwner public {
571         transferEnabled = enable;
572     }
573 
574     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
575         return super.transfer(_to, _value);
576     }
577 
578     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
579         return super.transferFrom(_from, _to, _value);
580     }
581 
582 }