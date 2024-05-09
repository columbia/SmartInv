1 pragma solidity ^0.4.24;
2 
3 //=== OpenZeppelin library ===
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * See https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender)
73     public view returns (uint256);
74 
75   function transferFrom(address from, address to, uint256 value)
76     public returns (bool);
77 
78   function approve(address spender, uint256 value) public returns (bool);
79   event Approval(
80     address indexed owner,
81     address indexed spender,
82     uint256 value
83   );
84 }
85 
86 /**
87  * @title SafeERC20
88  * @dev Wrappers around ERC20 operations that throw on failure.
89  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
90  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
91  */
92 library SafeERC20 {
93   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
94     require(token.transfer(to, value));
95   }
96 
97   function safeTransferFrom(
98     ERC20 token,
99     address from,
100     address to,
101     uint256 value
102   )
103     internal
104   {
105     require(token.transferFrom(from, to, value));
106   }
107 
108   function safeApprove(ERC20 token, address spender, uint256 value) internal {
109     require(token.approve(spender, value));
110   }
111 }
112 
113 
114 
115 /**
116  * @title Ownable
117  * @dev The Ownable contract has an owner address, and provides basic authorization control
118  * functions, this simplifies the implementation of "user permissions".
119  */
120 contract Ownable {
121   address public owner;
122 
123 
124   event OwnershipRenounced(address indexed previousOwner);
125   event OwnershipTransferred(
126     address indexed previousOwner,
127     address indexed newOwner
128   );
129 
130 
131   /**
132    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133    * account.
134    */
135   constructor() public {
136     owner = msg.sender;
137   }
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147   /**
148    * @dev Allows the current owner to relinquish control of the contract.
149    * @notice Renouncing to ownership will leave the contract without an owner.
150    * It will not be possible to call the functions with the `onlyOwner`
151    * modifier anymore.
152    */
153   function renounceOwnership() public onlyOwner {
154     emit OwnershipRenounced(owner);
155     owner = address(0);
156   }
157 
158   /**
159    * @dev Allows the current owner to transfer control of the contract to a newOwner.
160    * @param _newOwner The address to transfer ownership to.
161    */
162   function transferOwnership(address _newOwner) public onlyOwner {
163     _transferOwnership(_newOwner);
164   }
165 
166   /**
167    * @dev Transfers control of the contract to a newOwner.
168    * @param _newOwner The address to transfer ownership to.
169    */
170   function _transferOwnership(address _newOwner) internal {
171     require(_newOwner != address(0));
172     emit OwnershipTransferred(owner, _newOwner);
173     owner = _newOwner;
174   }
175 }
176 
177 /**
178  * @title Claimable
179  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
180  * This allows the new owner to accept the transfer.
181  */
182 contract Claimable is Ownable {
183   address public pendingOwner;
184 
185   /**
186    * @dev Modifier throws if called by any account other than the pendingOwner.
187    */
188   modifier onlyPendingOwner() {
189     require(msg.sender == pendingOwner);
190     _;
191   }
192 
193   /**
194    * @dev Allows the current owner to set the pendingOwner address.
195    * @param newOwner The address to transfer ownership to.
196    */
197   function transferOwnership(address newOwner) onlyOwner public {
198     pendingOwner = newOwner;
199   }
200 
201   /**
202    * @dev Allows the pendingOwner address to finalize the transfer.
203    */
204   function claimOwnership() onlyPendingOwner public {
205     emit OwnershipTransferred(owner, pendingOwner);
206     owner = pendingOwner;
207     pendingOwner = address(0);
208   }
209 }
210 
211 /**
212  * @title Contracts that should not own Ether
213  * @author Remco Bloemen <remco@2π.com>
214  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
215  * in the contract, it will allow the owner to reclaim this ether.
216  * @notice Ether can still be sent to this contract by:
217  * calling functions labeled `payable`
218  * `selfdestruct(contract_address)`
219  * mining directly to the contract address
220  */
221 contract HasNoEther is Ownable {
222 
223   /**
224   * @dev Constructor that rejects incoming Ether
225   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
226   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
227   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
228   * we could use assembly to access msg.value.
229   */
230   constructor() public payable {
231     require(msg.value == 0);
232   }
233 
234   /**
235    * @dev Disallows direct send by settings a default function without the `payable` flag.
236    */
237   function() external {
238   }
239 
240   /**
241    * @dev Transfer all Ether held by the contract to the owner.
242    */
243   function reclaimEther() external onlyOwner {
244     owner.transfer(address(this).balance);
245   }
246 }
247 
248 /**
249  * @title Contracts that should not own Contracts
250  * @author Remco Bloemen <remco@2π.com>
251  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
252  * of this contract to reclaim ownership of the contracts.
253  */
254 contract HasNoContracts is Ownable {
255 
256   /**
257    * @dev Reclaim ownership of Ownable contracts
258    * @param contractAddr The address of the Ownable to be reclaimed.
259    */
260   function reclaimContract(address contractAddr) external onlyOwner {
261     Ownable contractInst = Ownable(contractAddr);
262     contractInst.transferOwnership(owner);
263   }
264 }
265 
266 /**
267  * @title Contracts that should be able to recover tokens
268  * @author SylTi
269  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
270  * This will prevent any accidental loss of tokens.
271  */
272 contract CanReclaimToken is Ownable {
273   using SafeERC20 for ERC20Basic;
274 
275   /**
276    * @dev Reclaim all ERC20Basic compatible tokens
277    * @param token ERC20Basic The address of the token contract
278    */
279   function reclaimToken(ERC20Basic token) external onlyOwner {
280     uint256 balance = token.balanceOf(this);
281     token.safeTransfer(owner, balance);
282   }
283 
284 }
285 
286 /**
287  * @title Contracts that should not own Tokens
288  * @author Remco Bloemen <remco@2π.com>
289  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
290  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
291  * owner to reclaim the tokens.
292  */
293 contract HasNoTokens is CanReclaimToken {
294 
295  /**
296   * @dev Reject all ERC223 compatible tokens
297   * @param from_ address The address that is transferring the tokens
298   * @param value_ uint256 the amount of the specified token
299   * @param data_ Bytes The data passed from the caller.
300   */
301   function tokenFallback(address from_, uint256 value_, bytes data_) external {
302     from_;
303     value_;
304     data_;
305     revert();
306   }
307 
308 }
309 
310 /**
311  * @title Base contract for contracts that should not own things.
312  * @author Remco Bloemen <remco@2π.com>
313  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
314  * Owned contracts. See respective base contracts for details.
315  */
316 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
317 }
318 
319 /**
320  * @title Destructible
321  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
322  */
323 contract Destructible is Ownable {
324 
325   constructor() public payable { }
326 
327   /**
328    * @dev Transfers the current balance to the owner and terminates the contract.
329    */
330   function destroy() onlyOwner public {
331     selfdestruct(owner);
332   }
333 
334   function destroyAndSend(address _recipient) onlyOwner public {
335     selfdestruct(_recipient);
336   }
337 }
338 
339 /**
340  * @title Basic token
341  * @dev Basic version of StandardToken, with no allowances.
342  */
343 contract BasicToken is ERC20Basic {
344   using SafeMath for uint256;
345 
346   mapping(address => uint256) balances;
347 
348   uint256 totalSupply_;
349 
350   /**
351   * @dev Total number of tokens in existence
352   */
353   function totalSupply() public view returns (uint256) {
354     return totalSupply_;
355   }
356 
357   /**
358   * @dev Transfer token for a specified address
359   * @param _to The address to transfer to.
360   * @param _value The amount to be transferred.
361   */
362   function transfer(address _to, uint256 _value) public returns (bool) {
363     require(_to != address(0));
364     require(_value <= balances[msg.sender]);
365 
366     balances[msg.sender] = balances[msg.sender].sub(_value);
367     balances[_to] = balances[_to].add(_value);
368     emit Transfer(msg.sender, _to, _value);
369     return true;
370   }
371 
372   /**
373   * @dev Gets the balance of the specified address.
374   * @param _owner The address to query the the balance of.
375   * @return An uint256 representing the amount owned by the passed address.
376   */
377   function balanceOf(address _owner) public view returns (uint256) {
378     return balances[_owner];
379   }
380 
381 }
382 
383 /**
384  * @title Standard ERC20 token
385  *
386  * @dev Implementation of the basic standard token.
387  * https://github.com/ethereum/EIPs/issues/20
388  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
389  */
390 contract StandardToken is ERC20, BasicToken {
391 
392   mapping (address => mapping (address => uint256)) internal allowed;
393 
394 
395   /**
396    * @dev Transfer tokens from one address to another
397    * @param _from address The address which you want to send tokens from
398    * @param _to address The address which you want to transfer to
399    * @param _value uint256 the amount of tokens to be transferred
400    */
401   function transferFrom(
402     address _from,
403     address _to,
404     uint256 _value
405   )
406     public
407     returns (bool)
408   {
409     require(_to != address(0));
410     require(_value <= balances[_from]);
411     require(_value <= allowed[_from][msg.sender]);
412 
413     balances[_from] = balances[_from].sub(_value);
414     balances[_to] = balances[_to].add(_value);
415     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
416     emit Transfer(_from, _to, _value);
417     return true;
418   }
419 
420   /**
421    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
422    * Beware that changing an allowance with this method brings the risk that someone may use both the old
423    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
424    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
425    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
426    * @param _spender The address which will spend the funds.
427    * @param _value The amount of tokens to be spent.
428    */
429   function approve(address _spender, uint256 _value) public returns (bool) {
430     allowed[msg.sender][_spender] = _value;
431     emit Approval(msg.sender, _spender, _value);
432     return true;
433   }
434 
435   /**
436    * @dev Function to check the amount of tokens that an owner allowed to a spender.
437    * @param _owner address The address which owns the funds.
438    * @param _spender address The address which will spend the funds.
439    * @return A uint256 specifying the amount of tokens still available for the spender.
440    */
441   function allowance(
442     address _owner,
443     address _spender
444    )
445     public
446     view
447     returns (uint256)
448   {
449     return allowed[_owner][_spender];
450   }
451 
452   /**
453    * @dev Increase the amount of tokens that an owner allowed to a spender.
454    * approve should be called when allowed[_spender] == 0. To increment
455    * allowed value is better to use this function to avoid 2 calls (and wait until
456    * the first transaction is mined)
457    * From MonolithDAO Token.sol
458    * @param _spender The address which will spend the funds.
459    * @param _addedValue The amount of tokens to increase the allowance by.
460    */
461   function increaseApproval(
462     address _spender,
463     uint256 _addedValue
464   )
465     public
466     returns (bool)
467   {
468     allowed[msg.sender][_spender] = (
469       allowed[msg.sender][_spender].add(_addedValue));
470     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
471     return true;
472   }
473 
474   /**
475    * @dev Decrease the amount of tokens that an owner allowed to a spender.
476    * approve should be called when allowed[_spender] == 0. To decrement
477    * allowed value is better to use this function to avoid 2 calls (and wait until
478    * the first transaction is mined)
479    * From MonolithDAO Token.sol
480    * @param _spender The address which will spend the funds.
481    * @param _subtractedValue The amount of tokens to decrease the allowance by.
482    */
483   function decreaseApproval(
484     address _spender,
485     uint256 _subtractedValue
486   )
487     public
488     returns (bool)
489   {
490     uint256 oldValue = allowed[msg.sender][_spender];
491     if (_subtractedValue > oldValue) {
492       allowed[msg.sender][_spender] = 0;
493     } else {
494       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
495     }
496     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
497     return true;
498   }
499 
500 }
501 
502 /**
503  * @title Mintable token
504  * @dev Simple ERC20 Token example, with mintable token creation
505  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
506  */
507 contract MintableToken is StandardToken, Ownable {
508   event Mint(address indexed to, uint256 amount);
509   event MintFinished();
510 
511   bool public mintingFinished = false;
512 
513 
514   modifier canMint() {
515     require(!mintingFinished);
516     _;
517   }
518 
519   modifier hasMintPermission() {
520     require(msg.sender == owner);
521     _;
522   }
523 
524   /**
525    * @dev Function to mint tokens
526    * @param _to The address that will receive the minted tokens.
527    * @param _amount The amount of tokens to mint.
528    * @return A boolean that indicates if the operation was successful.
529    */
530   function mint(
531     address _to,
532     uint256 _amount
533   )
534     hasMintPermission
535     canMint
536     public
537     returns (bool)
538   {
539     totalSupply_ = totalSupply_.add(_amount);
540     balances[_to] = balances[_to].add(_amount);
541     emit Mint(_to, _amount);
542     emit Transfer(address(0), _to, _amount);
543     return true;
544   }
545 
546   /**
547    * @dev Function to stop minting new tokens.
548    * @return True if the operation was successful.
549    */
550   function finishMinting() onlyOwner canMint public returns (bool) {
551     mintingFinished = true;
552     emit MintFinished();
553     return true;
554   }
555 }
556 
557 //=== WOLFEX Contracts ===
558 
559 /**
560  * @title WOLFEX Token
561  */
562 contract WOLFEXToken is MintableToken, NoOwner, Claimable {
563     string public symbol = 'WOLFEX';
564     string public name = 'WOLF EXCHANGE';
565     uint8 public constant decimals = 18;
566 
567     bool public transferEnabled;
568 
569     modifier canTransfer() {
570         require( transferEnabled || msg.sender == owner);
571         _;
572     }
573 
574     function setTransferEnabled(bool enable) onlyOwner public {
575         transferEnabled = enable;
576     }
577 
578     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
579         return super.transfer(_to, _value);
580     }
581 
582     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
583         return super.transferFrom(_from, _to, _value);
584     }
585 
586 }
587 
588 /**
589  * @title WOLFEX Distribution
590  */
591 contract WOLFEXDistribution is Claimable, NoOwner, Destructible {
592     WOLFEXToken public token;
593 
594     constructor() public {
595         token = new WOLFEXToken(); 
596         token.setTransferEnabled(false);
597     }
598 
599 
600     /**
601     * @notice Bulk mint tokens (same amount)
602     * @param beneficiaries array whom to send tokend
603     * @param amount how much tokens to send
604     */
605     function bulkTokenMint(address[] beneficiaries, uint256 amount) onlyOwner external {
606         for(uint32 i=0; i < beneficiaries.length; i++){
607             require(token.mint(beneficiaries[i], amount));
608         }
609     }
610 
611     /**
612     * @notice Bulk mint tokens (different amounts)
613     * @param beneficiaries array whom to send tokend
614     * @param amounts array how much tokens to send
615     */
616     function bulkTokenMint(address[] beneficiaries, uint256[] amounts) onlyOwner external {
617         require(beneficiaries.length == amounts.length);
618         for(uint32 i=0; i < beneficiaries.length; i++){
619             require(token.mint(beneficiaries[i], amounts[i]));
620         }
621     }
622 
623 
624     /**
625     * @notice Bulk send tokens (same amount)
626     * @param beneficiaries array whom to send tokend
627     * @param amount how much tokens to send
628     */
629     function bulkTokenSend(address[] beneficiaries, uint256 amount) onlyOwner external {
630         for(uint32 i=0; i < beneficiaries.length; i++){
631             require(token.transferFrom(msg.sender, beneficiaries[i], amount));
632         }
633     }
634 
635     /**
636     * @notice Bulk send tokens (different amounts)
637     * @param beneficiaries array whom to send tokend
638     * @param amounts array how much tokens to send
639     */
640     function bulkTokenSend(address[] beneficiaries, uint256[] amounts) onlyOwner external {
641         require(beneficiaries.length == amounts.length);
642         for(uint32 i=0; i < beneficiaries.length; i++){
643             require(token.transferFrom(msg.sender, beneficiaries[i], amounts[i]));
644         }
645     }
646 
647     /**
648      * @notice Allows to enable or dissable token transfers
649      */
650     function setTransferEnabled(bool enable) onlyOwner public {
651         token.setTransferEnabled(enable);
652     }
653 
654     /**
655      * @notice Finish token minting. NO NEW TOKENS can be created after calling this
656      */
657     function finishTokenMinting() onlyOwner public {
658         token.finishMinting();
659     }
660 
661 
662     /**
663      * @notice Transfers token ownership to this contract owner
664      */
665     function claimToken() onlyOwner public {
666         token.transferOwnership(owner);
667     }
668 
669     /**
670      * @notice Finish token minting, enable transfers and transfer token ownership
671      */
672     function finishDistribution() onlyOwner public {
673         token.finishMinting();
674         token.setTransferEnabled(true);
675         token.transferOwnership(owner);
676     }
677 
678     /**
679      * @notice Allows transfer token ownership back to distribution contract
680      */
681     function reclaimTokenOwnership() onlyOwner public {
682         token.claimOwnership();
683     }
684 }