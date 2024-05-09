1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 
81 
82 contract TokenReceiver {
83     /**
84     * @dev Method to be triggerred during approveAndCall execution
85     * @param _sender A wallet that initiated the operation
86     * @param _value Amount of approved tokens
87     * @param _data Additional arguments
88     */
89     function tokenFallback(address _sender, uint256 _value, bytes _data) external returns (bool);
90 }
91 
92 /**
93 * @title Timestamped
94 * @dev Timestamped contract has a separate method for receiving current timestamp.
95 * This simplifies derived contracts testability.
96 */
97 contract Timestamped {
98     /**
99     * @dev Returns current timestamp.
100     */
101     function _currentTime() internal view returns(uint256) {
102         // solium-disable-next-line security/no-block-members
103         return block.timestamp;
104     }
105 }
106 
107 
108 
109 
110 
111 /**
112  * @title SafeMath
113  * @dev Math operations with safety checks that throw on error
114  */
115 library SafeMath {
116 
117   /**
118   * @dev Multiplies two numbers, throws on overflow.
119   */
120   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
121     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
122     // benefit is lost if 'b' is also tested.
123     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
124     if (_a == 0) {
125       return 0;
126     }
127 
128     c = _a * _b;
129     assert(c / _a == _b);
130     return c;
131   }
132 
133   /**
134   * @dev Integer division of two numbers, truncating the quotient.
135   */
136   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
137     // assert(_b > 0); // Solidity automatically throws when dividing by 0
138     // uint256 c = _a / _b;
139     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
140     return _a / _b;
141   }
142 
143   /**
144   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
145   */
146   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
147     assert(_b <= _a);
148     return _a - _b;
149   }
150 
151   /**
152   * @dev Adds two numbers, throws on overflow.
153   */
154   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
155     c = _a + _b;
156     assert(c >= _a);
157     return c;
158   }
159 }
160 
161 
162 
163 
164 
165 
166 
167 
168 
169 
170 /**
171  * @title Basic token
172  * @dev Basic version of StandardToken, with no allowances.
173  */
174 contract BasicToken is ERC20Basic {
175   using SafeMath for uint256;
176 
177   mapping(address => uint256) internal balances;
178 
179   uint256 internal totalSupply_;
180 
181   /**
182   * @dev Total number of tokens in existence
183   */
184   function totalSupply() public view returns (uint256) {
185     return totalSupply_;
186   }
187 
188   /**
189   * @dev Transfer token for a specified address
190   * @param _to The address to transfer to.
191   * @param _value The amount to be transferred.
192   */
193   function transfer(address _to, uint256 _value) public returns (bool) {
194     require(_value <= balances[msg.sender]);
195     require(_to != address(0));
196 
197     balances[msg.sender] = balances[msg.sender].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     emit Transfer(msg.sender, _to, _value);
200     return true;
201   }
202 
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param _owner The address to query the the balance of.
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address _owner) public view returns (uint256) {
209     return balances[_owner];
210   }
211 
212 }
213 
214 
215 
216 
217 
218 
219 /**
220  * @title ERC20 interface
221  * @dev see https://github.com/ethereum/EIPs/issues/20
222  */
223 contract ERC20 is ERC20Basic {
224   function allowance(address _owner, address _spender)
225     public view returns (uint256);
226 
227   function transferFrom(address _from, address _to, uint256 _value)
228     public returns (bool);
229 
230   function approve(address _spender, uint256 _value) public returns (bool);
231   event Approval(
232     address indexed owner,
233     address indexed spender,
234     uint256 value
235   );
236 }
237 
238 
239 
240 /**
241  * @title Standard ERC20 token
242  *
243  * @dev Implementation of the basic standard token.
244  * https://github.com/ethereum/EIPs/issues/20
245  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
246  */
247 contract StandardToken is ERC20, BasicToken {
248 
249   mapping (address => mapping (address => uint256)) internal allowed;
250 
251 
252   /**
253    * @dev Transfer tokens from one address to another
254    * @param _from address The address which you want to send tokens from
255    * @param _to address The address which you want to transfer to
256    * @param _value uint256 the amount of tokens to be transferred
257    */
258   function transferFrom(
259     address _from,
260     address _to,
261     uint256 _value
262   )
263     public
264     returns (bool)
265   {
266     require(_value <= balances[_from]);
267     require(_value <= allowed[_from][msg.sender]);
268     require(_to != address(0));
269 
270     balances[_from] = balances[_from].sub(_value);
271     balances[_to] = balances[_to].add(_value);
272     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
273     emit Transfer(_from, _to, _value);
274     return true;
275   }
276 
277   /**
278    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
279    * Beware that changing an allowance with this method brings the risk that someone may use both the old
280    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
281    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
282    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
283    * @param _spender The address which will spend the funds.
284    * @param _value The amount of tokens to be spent.
285    */
286   function approve(address _spender, uint256 _value) public returns (bool) {
287     allowed[msg.sender][_spender] = _value;
288     emit Approval(msg.sender, _spender, _value);
289     return true;
290   }
291 
292   /**
293    * @dev Function to check the amount of tokens that an owner allowed to a spender.
294    * @param _owner address The address which owns the funds.
295    * @param _spender address The address which will spend the funds.
296    * @return A uint256 specifying the amount of tokens still available for the spender.
297    */
298   function allowance(
299     address _owner,
300     address _spender
301    )
302     public
303     view
304     returns (uint256)
305   {
306     return allowed[_owner][_spender];
307   }
308 
309   /**
310    * @dev Increase the amount of tokens that an owner allowed to a spender.
311    * approve should be called when allowed[_spender] == 0. To increment
312    * allowed value is better to use this function to avoid 2 calls (and wait until
313    * the first transaction is mined)
314    * From MonolithDAO Token.sol
315    * @param _spender The address which will spend the funds.
316    * @param _addedValue The amount of tokens to increase the allowance by.
317    */
318   function increaseApproval(
319     address _spender,
320     uint256 _addedValue
321   )
322     public
323     returns (bool)
324   {
325     allowed[msg.sender][_spender] = (
326       allowed[msg.sender][_spender].add(_addedValue));
327     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328     return true;
329   }
330 
331   /**
332    * @dev Decrease the amount of tokens that an owner allowed to a spender.
333    * approve should be called when allowed[_spender] == 0. To decrement
334    * allowed value is better to use this function to avoid 2 calls (and wait until
335    * the first transaction is mined)
336    * From MonolithDAO Token.sol
337    * @param _spender The address which will spend the funds.
338    * @param _subtractedValue The amount of tokens to decrease the allowance by.
339    */
340   function decreaseApproval(
341     address _spender,
342     uint256 _subtractedValue
343   )
344     public
345     returns (bool)
346   {
347     uint256 oldValue = allowed[msg.sender][_spender];
348     if (_subtractedValue >= oldValue) {
349       allowed[msg.sender][_spender] = 0;
350     } else {
351       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
352     }
353     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
354     return true;
355   }
356 
357 }
358 
359 
360 
361 
362 
363 
364 /**
365  * @title DetailedERC20 token
366  * @dev The decimals are only for visualization purposes.
367  * All the operations are done using the smallest and indivisible token unit,
368  * just as on Ethereum all the operations are done in wei.
369  */
370 contract DetailedERC20 is ERC20 {
371   string public name;
372   string public symbol;
373   uint8 public decimals;
374 
375   constructor(string _name, string _symbol, uint8 _decimals) public {
376     name = _name;
377     symbol = _symbol;
378     decimals = _decimals;
379   }
380 }
381 
382 
383 
384 
385 
386 
387 /**
388  * @title Contracts that should not own Ether
389  * @author Remco Bloemen <remco@2π.com>
390  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
391  * in the contract, it will allow the owner to reclaim this Ether.
392  * @notice Ether can still be sent to this contract by:
393  * calling functions labeled `payable`
394  * `selfdestruct(contract_address)`
395  * mining directly to the contract address
396  */
397 contract HasNoEther is Ownable {
398 
399   /**
400   * @dev Constructor that rejects incoming Ether
401   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
402   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
403   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
404   * we could use assembly to access msg.value.
405   */
406   constructor() public payable {
407     require(msg.value == 0);
408   }
409 
410   /**
411    * @dev Disallows direct send by setting a default function without the `payable` flag.
412    */
413   function() external {
414   }
415 
416   /**
417    * @dev Transfer all Ether held by the contract to the owner.
418    */
419   function reclaimEther() external onlyOwner {
420     owner.transfer(address(this).balance);
421   }
422 }
423 
424 
425 
426 
427 /**
428 * @title FlipNpikToken
429 * @dev The FlipNpikToken is a ERC20 token 
430 */
431 contract FlipNpikToken is Timestamped, StandardToken, DetailedERC20, HasNoEther {
432     using SafeMath for uint256;
433 
434     // A wallet that will hold tokens
435     address public mainWallet;
436     // A wallet that is required to unlock reserve tokens
437     address public financeWallet;
438 
439     // Locked reserve tokens amount is 500M FNP
440     uint256 public reserveSize = uint256(500000000).mul(10 ** 18);
441     // List of signatures required to unlock reserve tokens
442     mapping (address => bool) public reserveHolders;
443     // Total amount of unlocked reserve tokens
444     uint256 public totalUnlocked = 0;
445 
446     // Scheduled for minting reserve tokens amount is 575M FNP
447     uint256 public mintSize = uint256(575000000).mul(10 ** 18);
448     // Datetime when minting according to schedule becomes available
449     uint256 public mintStart;
450     // Total amount of minted reserve tokens
451     uint256 public totalMinted = 0;    
452 
453     /**
454     * Describes minting stage structure fields
455     * @param start Minting stage start date
456     * @param volumt Total tokens available for the stage
457     */
458     struct MintStage {
459         uint256 start;
460         uint256 volume;       
461     }
462 
463     // Array of stages
464     MintStage[] public stages;
465 
466     /**
467     * @dev Event for reserve tokens minting operation logging
468     * @param _amount Amount minted
469     */
470     event MintReserveLog(uint256 _amount);
471 
472     /**
473     * @dev Event for reserve tokens unlock operation logging
474     * @param _amount Amount unlocked
475     */
476     event UnlockReserveLog(uint256 _amount);
477 
478     /**
479     * @param _mintStart Datetime when minting according to schedule becomes available
480     * @param _mainWallet A wallet that will hold tokens
481     * @param _financeWallet A wallet that is required to unlock reserve tokens
482     * @param _owner Smart contract owner address
483     */
484     constructor (uint256 _mintStart, address _mainWallet, address _financeWallet, address _owner)
485         DetailedERC20("FlipNpik", "FNP", 18) public {
486 
487         require(_mainWallet != address(0), "Main address is invalid.");
488         mainWallet = _mainWallet;       
489 
490         require(_financeWallet != address(0), "Finance address is invalid.");
491         financeWallet = _financeWallet;        
492 
493         require(_owner != address(0), "Owner address is invalid.");
494         owner = _owner;
495 
496         _setStages(_mintStart);
497         _setReserveHolders();
498 
499         // 425M FNP should be minted initially
500         _mint(uint256(425000000).mul(10 ** 18));
501     }       
502 
503     /**
504     * @dev Mints reserved tokens
505     */
506     function mintReserve() public onlyOwner {
507         require(mintStart < _currentTime(), "Minting has not been allowed yet.");
508         require(totalMinted < mintSize, "No tokens are available for minting.");
509         
510         // Get stage based on current datetime
511         MintStage memory currentStage = _getCurrentStage();
512         // Get amount available for minting
513         uint256 mintAmount = currentStage.volume.sub(totalMinted);
514 
515         if (mintAmount > 0 && _mint(mintAmount)) {
516             emit MintReserveLog(mintAmount);
517             totalMinted = totalMinted.add(mintAmount);
518         }
519     }
520 
521     /**
522     * @dev Unlocks reserve
523     */
524     function unlockReserve() public {
525         require(msg.sender == owner || msg.sender == financeWallet, "Operation is not allowed for the wallet.");
526         require(totalUnlocked < reserveSize, "Reserve has been unlocked.");        
527         
528         // Save sender's signature for reserve tokens unlock
529         reserveHolders[msg.sender] = true;
530 
531         if (_isReserveUnlocked() && _mint(reserveSize)) {
532             emit UnlockReserveLog(reserveSize);
533             totalUnlocked = totalUnlocked.add(reserveSize);
534         }        
535     }
536 
537     /**
538     * @dev Executes regular token approve operation and trigger receiver SC accordingly
539     * @param _to Address (SC) that should receive approval and be triggerred
540     * @param _value Amount of tokens for approve operation
541     * @param _data Additional arguments to be passed to the contract
542     */
543     function approveAndCall(address _to, uint256 _value, bytes _data) public returns(bool) {
544         require(super.approve(_to, _value), "Approve operation failed.");
545 
546         // Check if destination address is SC
547         if (isContract(_to)) {
548             TokenReceiver receiver = TokenReceiver(_to);
549             return receiver.tokenFallback(msg.sender, _value, _data);
550         }
551 
552         return true;
553     } 
554 
555     /**
556     * @dev Mints tokens to main wallet balance
557     * @param _amount Amount to be minted
558     */
559     function _mint(uint256 _amount) private returns(bool) {
560         totalSupply_ = totalSupply_.add(_amount);
561         balances[mainWallet] = balances[mainWallet].add(_amount);
562 
563         emit Transfer(address(0), mainWallet, _amount);
564         return true;
565     }
566 
567     /**
568     * @dev Configures minting stages
569     * @param _mintStart Datetime when minting according to schedule becomes available
570     */
571     function _setStages(uint256 _mintStart) private {
572         require(_mintStart >= _currentTime(), "Mint start date is invalid.");
573         mintStart = _mintStart;
574 
575         stages.push(MintStage(_mintStart, uint256(200000000).mul(10 ** 18)));
576         stages.push(MintStage(_mintStart.add(365 days), uint256(325000000).mul(10 ** 18)));
577         stages.push(MintStage(_mintStart.add(2 * 365 days), uint256(450000000).mul(10 ** 18)));
578         stages.push(MintStage(_mintStart.add(3 * 365 days), uint256(575000000).mul(10 ** 18)));
579     }
580 
581     /**
582     * @dev Configures unlock signature holders list
583     */
584     function _setReserveHolders() private {
585         reserveHolders[mainWallet] = false;
586         reserveHolders[financeWallet] = false;
587     }
588 
589     /**
590     * @dev Finds current stage parameters according to the rules and current date and time
591     * @return Current stage parameters (stage start date and available volume of tokens)
592     */
593     function _getCurrentStage() private view returns (MintStage) {
594         uint256 index = 0;
595         uint256 time = _currentTime();        
596 
597         MintStage memory result;
598 
599         while (index < stages.length) {
600             MintStage memory activeStage = stages[index];
601 
602             if (time >= activeStage.start) {
603                 result = activeStage;
604             }
605 
606             index++;             
607         }
608 
609         return result;
610     }
611 
612     /**
613     * @dev Checks if an address is a SC
614     */
615     function isContract(address _addr) private view returns (bool) {
616         uint256 size;
617         // solium-disable-next-line security/no-inline-assembly
618         assembly { size := extcodesize(_addr) }
619         return size > 0;
620     }
621 
622     /**
623     * @dev Checks if reserve tokens have all required signatures for unlock operation
624     */
625     function _isReserveUnlocked() private view returns(bool) {
626         return reserveHolders[owner] == reserveHolders[financeWallet] && reserveHolders[owner];
627     }
628 }