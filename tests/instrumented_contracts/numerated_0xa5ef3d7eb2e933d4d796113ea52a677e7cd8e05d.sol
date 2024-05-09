1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 library Math {
8   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
9     return _a >= _b ? _a : _b;
10   }
11 
12   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
13     return _a < _b ? _a : _b;
14   }
15 
16   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
17     return _a >= _b ? _a : _b;
18   }
19 
20   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
21     return _a < _b ? _a : _b;
22   }
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
35     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38     if (_a == 0) {
39       return 0;
40     }
41 
42     c = _a * _b;
43     assert(c / _a == _b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     // assert(_b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = _a / _b;
53     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
54     return _a / _b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
61     assert(_b <= _a);
62     return _a - _b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
69     c = _a + _b;
70     assert(c >= _a);
71     return c;
72   }
73 }
74 
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * See https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address _who) public view returns (uint256);
84   function transfer(address _to, uint256 _value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address _owner, address _spender)
93     public view returns (uint256);
94 
95   function transferFrom(address _from, address _to, uint256 _value)
96     public returns (bool);
97 
98   function approve(address _spender, uint256 _value) public returns (bool);
99   event Approval(
100     address indexed owner,
101     address indexed spender,
102     uint256 value
103   );
104 }
105 /**
106  * @title SafeERC20
107  * @dev Wrappers around ERC20 operations that throw on failure.
108  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
109  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
110  */
111 library SafeERC20 {
112   function safeTransfer(
113     ERC20Basic _token,
114     address _to,
115     uint256 _value
116   )
117     internal
118   {
119     require(_token.transfer(_to, _value));
120   }
121 
122   function safeTransferFrom(
123     ERC20 _token,
124     address _from,
125     address _to,
126     uint256 _value
127   )
128     internal
129   {
130     require(_token.transferFrom(_from, _to, _value));
131   }
132 
133   function safeApprove(
134     ERC20 _token,
135     address _spender,
136     uint256 _value
137   )
138     internal
139   {
140     require(_token.approve(_spender, _value));
141   }
142 }
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipRenounced(address indexed previousOwner);
154   event OwnershipTransferred(
155     address indexed previousOwner,
156     address indexed newOwner
157   );
158 
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   constructor() public {
165     owner = msg.sender;
166   }
167 
168   /**
169    * @dev Throws if called by any account other than the owner.
170    */
171   modifier onlyOwner() {
172     require(msg.sender == owner);
173     _;
174   }
175 
176   /**
177    * @dev Allows the current owner to relinquish control of the contract.
178    * @notice Renouncing to ownership will leave the contract without an owner.
179    * It will not be possible to call the functions with the `onlyOwner`
180    * modifier anymore.
181    */
182   function renounceOwnership() public onlyOwner {
183     emit OwnershipRenounced(owner);
184     owner = address(0);
185   }
186 
187   /**
188    * @dev Allows the current owner to transfer control of the contract to a newOwner.
189    * @param _newOwner The address to transfer ownership to.
190    */
191   function transferOwnership(address _newOwner) public onlyOwner {
192     _transferOwnership(_newOwner);
193   }
194 
195   /**
196    * @dev Transfers control of the contract to a newOwner.
197    * @param _newOwner The address to transfer ownership to.
198    */
199   function _transferOwnership(address _newOwner) internal {
200     require(_newOwner != address(0));
201     emit OwnershipTransferred(owner, _newOwner);
202     owner = _newOwner;
203   }
204 }
205 /**
206  * @title Claimable
207  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
208  * This allows the new owner to accept the transfer.
209  */
210 contract Claimable is Ownable {
211   address public pendingOwner;
212 
213   /**
214    * @dev Modifier throws if called by any account other than the pendingOwner.
215    */
216   modifier onlyPendingOwner() {
217     require(msg.sender == pendingOwner);
218     _;
219   }
220 
221   /**
222    * @dev Allows the current owner to set the pendingOwner address.
223    * @param newOwner The address to transfer ownership to.
224    */
225   function transferOwnership(address newOwner) public onlyOwner {
226     pendingOwner = newOwner;
227   }
228 
229   /**
230    * @dev Allows the pendingOwner address to finalize the transfer.
231    */
232   function claimOwnership() public onlyPendingOwner {
233     emit OwnershipTransferred(owner, pendingOwner);
234     owner = pendingOwner;
235     pendingOwner = address(0);
236   }
237 }
238 
239 /**
240  * @title Basic token
241  * @dev Basic version of StandardToken, with no allowances.
242  */
243 contract BasicToken is ERC20Basic {
244   using SafeMath for uint256;
245 
246   mapping(address => uint256) internal balances;
247 
248   uint256 internal totalSupply_;
249 
250   /**
251   * @dev Total number of tokens in existence
252   */
253   function totalSupply() public view returns (uint256) {
254     return totalSupply_;
255   }
256 
257   /**
258   * @dev Transfer token for a specified address
259   * @param _to The address to transfer to.
260   * @param _value The amount to be transferred.
261   */
262   function transfer(address _to, uint256 _value) public returns (bool) {
263     require(_value <= balances[msg.sender]);
264     require(_to != address(0));
265 
266     balances[msg.sender] = balances[msg.sender].sub(_value);
267     balances[_to] = balances[_to].add(_value);
268     emit Transfer(msg.sender, _to, _value);
269     return true;
270   }
271 
272   /**
273   * @dev Gets the balance of the specified address.
274   * @param _owner The address to query the the balance of.
275   * @return An uint256 representing the amount owned by the passed address.
276   */
277   function balanceOf(address _owner) public view returns (uint256) {
278     return balances[_owner];
279   }
280 
281 }
282 
283 
284 /**
285  * @title Standard ERC20 token
286  *
287  * @dev Implementation of the basic standard token.
288  * https://github.com/ethereum/EIPs/issues/20
289  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
290  */
291 contract StandardToken is ERC20, BasicToken {
292 
293   mapping (address => mapping (address => uint256)) internal allowed;
294 
295 
296   /**
297    * @dev Transfer tokens from one address to another
298    * @param _from address The address which you want to send tokens from
299    * @param _to address The address which you want to transfer to
300    * @param _value uint256 the amount of tokens to be transferred
301    */
302   function transferFrom(
303     address _from,
304     address _to,
305     uint256 _value
306   )
307     public
308     returns (bool)
309   {
310     require(_value <= balances[_from]);
311     require(_value <= allowed[_from][msg.sender]);
312     require(_to != address(0));
313 
314     balances[_from] = balances[_from].sub(_value);
315     balances[_to] = balances[_to].add(_value);
316     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
317     emit Transfer(_from, _to, _value);
318     return true;
319   }
320 
321   /**
322    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
323    * Beware that changing an allowance with this method brings the risk that someone may use both the old
324    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
325    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
326    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
327    * @param _spender The address which will spend the funds.
328    * @param _value The amount of tokens to be spent.
329    */
330   function approve(address _spender, uint256 _value) public returns (bool) {
331     allowed[msg.sender][_spender] = _value;
332     emit Approval(msg.sender, _spender, _value);
333     return true;
334   }
335 
336   /**
337    * @dev Function to check the amount of tokens that an owner allowed to a spender.
338    * @param _owner address The address which owns the funds.
339    * @param _spender address The address which will spend the funds.
340    * @return A uint256 specifying the amount of tokens still available for the spender.
341    */
342   function allowance(
343     address _owner,
344     address _spender
345    )
346     public
347     view
348     returns (uint256)
349   {
350     return allowed[_owner][_spender];
351   }
352 
353   /**
354    * @dev Increase the amount of tokens that an owner allowed to a spender.
355    * approve should be called when allowed[_spender] == 0. To increment
356    * allowed value is better to use this function to avoid 2 calls (and wait until
357    * the first transaction is mined)
358    * From MonolithDAO Token.sol
359    * @param _spender The address which will spend the funds.
360    * @param _addedValue The amount of tokens to increase the allowance by.
361    */
362   function increaseApproval(
363     address _spender,
364     uint256 _addedValue
365   )
366     public
367     returns (bool)
368   {
369     allowed[msg.sender][_spender] = (
370       allowed[msg.sender][_spender].add(_addedValue));
371     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
372     return true;
373   }
374 
375   /**
376    * @dev Decrease the amount of tokens that an owner allowed to a spender.
377    * approve should be called when allowed[_spender] == 0. To decrement
378    * allowed value is better to use this function to avoid 2 calls (and wait until
379    * the first transaction is mined)
380    * From MonolithDAO Token.sol
381    * @param _spender The address which will spend the funds.
382    * @param _subtractedValue The amount of tokens to decrease the allowance by.
383    */
384   function decreaseApproval(
385     address _spender,
386     uint256 _subtractedValue
387   )
388     public
389     returns (bool)
390   {
391     uint256 oldValue = allowed[msg.sender][_spender];
392     if (_subtractedValue >= oldValue) {
393       allowed[msg.sender][_spender] = 0;
394     } else {
395       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
396     }
397     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
398     return true;
399   }
400 
401 }
402 
403 /**
404  * @title Burnable Token
405  * @dev Token that can be irreversibly burned (destroyed).
406  */
407 contract BurnableToken is BasicToken {
408 
409   event Burn(address indexed burner, uint256 value);
410 
411   /**
412    * @dev Burns a specific amount of tokens.
413    * @param _value The amount of token to be burned.
414    */
415   function burn(uint256 _value) public {
416     _burn(msg.sender, _value);
417   }
418 
419   function _burn(address _who, uint256 _value) internal {
420     require(_value <= balances[_who]);
421     // no need to require value <= totalSupply, since that would imply the
422     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
423 
424     balances[_who] = balances[_who].sub(_value);
425     totalSupply_ = totalSupply_.sub(_value);
426     emit Burn(_who, _value);
427     emit Transfer(_who, address(0), _value);
428   }
429 }
430 
431 
432 /**
433  * @title Mintable token
434  * @dev Simple ERC20 Token example, with mintable token creation
435  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
436  */
437 contract MintableToken is StandardToken, Ownable {
438   event Mint(address indexed to, uint256 amount);
439   event MintFinished();
440 
441   bool public mintingFinished = false;
442 
443 
444   modifier canMint() {
445     require(!mintingFinished);
446     _;
447   }
448 
449   modifier hasMintPermission() {
450     require(msg.sender == owner);
451     _;
452   }
453 
454   /**
455    * @dev Function to mint tokens
456    * @param _to The address that will receive the minted tokens.
457    * @param _amount The amount of tokens to mint.
458    * @return A boolean that indicates if the operation was successful.
459    */
460   function mint(
461     address _to,
462     uint256 _amount
463   )
464     public
465     hasMintPermission
466     canMint
467     returns (bool)
468   {
469     totalSupply_ = totalSupply_.add(_amount);
470     balances[_to] = balances[_to].add(_amount);
471     emit Mint(_to, _amount);
472     emit Transfer(address(0), _to, _amount);
473     return true;
474   }
475 
476   /**
477    * @dev Function to stop minting new tokens.
478    * @return True if the operation was successful.
479    */
480   function finishMinting() public onlyOwner canMint returns (bool) {
481     mintingFinished = true;
482     emit MintFinished();
483     return true;
484   }
485 }
486 
487 
488 /**
489  * @title Contracts that should not own Ether
490  * @author Remco Bloemen <remco@2π.com>
491  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
492  * in the contract, it will allow the owner to reclaim this Ether.
493  * @notice Ether can still be sent to this contract by:
494  * calling functions labeled `payable`
495  * `selfdestruct(contract_address)`
496  * mining directly to the contract address
497  */
498 contract HasNoEther is Ownable {
499 
500   /**
501   * @dev Constructor that rejects incoming Ether
502   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
503   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
504   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
505   * we could use assembly to access msg.value.
506   */
507   constructor() public payable {
508     require(msg.value == 0);
509   }
510 
511   /**
512    * @dev Disallows direct send by setting a default function without the `payable` flag.
513    */
514   function() external {
515   }
516 
517   /**
518    * @dev Transfer all Ether held by the contract to the owner.
519    */
520   function reclaimEther() external onlyOwner {
521     owner.transfer(address(this).balance);
522   }
523 }
524 
525 /**
526  * @title Contracts that should be able to recover tokens
527  * @author SylTi
528  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
529  * This will prevent any accidental loss of tokens.
530  */
531 contract CanReclaimToken is Ownable {
532   using SafeERC20 for ERC20Basic;
533 
534   /**
535    * @dev Reclaim all ERC20Basic compatible tokens
536    * @param _token ERC20Basic The address of the token contract
537    */
538   function reclaimToken(ERC20Basic _token) external onlyOwner {
539     uint256 balance = _token.balanceOf(this);
540     _token.safeTransfer(owner, balance);
541   }
542 
543 }
544 
545 /**
546  * @title Contracts that should not own Tokens
547  * @author Remco Bloemen <remco@2π.com>
548  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
549  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
550  * owner to reclaim the tokens.
551  */
552 contract HasNoTokens is CanReclaimToken {
553 
554  /**
555   * @dev Reject all ERC223 compatible tokens
556   * @param _from address The address that is transferring the tokens
557   * @param _value uint256 the amount of the specified token
558   * @param _data Bytes The data passed from the caller.
559   */
560   function tokenFallback(
561     address _from,
562     uint256 _value,
563     bytes _data
564   )
565     external
566     pure
567   {
568     _from;
569     _value;
570     _data;
571     revert();
572   }
573 
574 }
575 
576 
577 /**
578  * @title Contracts that should not own Contracts
579  * @author Remco Bloemen <remco@2π.com>
580  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
581  * of this contract to reclaim ownership of the contracts.
582  */
583 contract HasNoContracts is Ownable {
584 
585   /**
586    * @dev Reclaim ownership of Ownable contracts
587    * @param _contractAddr The address of the Ownable to be reclaimed.
588    */
589   function reclaimContract(address _contractAddr) external onlyOwner {
590     Ownable contractInst = Ownable(_contractAddr);
591     contractInst.transferOwnership(owner);
592   }
593 }
594 
595 /**
596  * @title Base contract for contracts that should not own things.
597  * @author Remco Bloemen <remco@2π.com>
598  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
599  * Owned contracts. See respective base contracts for details.
600  */
601 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
602 }
603 
604 /**
605  * @title Pausable Token
606  * @dev Token that can be paused and unpaused. Only whitelisted addresses can transfer when paused
607  */
608 contract PausableToken is StandardToken, Ownable {
609     event Pause();
610     event Unpause();
611 
612     bool public paused = false;
613     mapping(address => bool) public whitelist;
614 
615     /**
616     * @dev called by the owner to pause, triggers stopped state
617     */
618     function pause() onlyOwner public {
619         require(!paused);
620         paused = true;
621         emit Pause();
622     }
623 
624     /**
625     * @dev called by the owner to unpause, returns to normal state
626     */
627     function unpause() onlyOwner public {
628         require(paused);
629         paused = false;
630         emit Unpause();
631     }
632     /**
633      * @notice add/remove whitelisted addresses
634      * @param who Address which is added or removed
635      * @param allowTransfers allow or deny dtransfers when paused to the who
636      */
637     function setWhitelisted(address who, bool allowTransfers) onlyOwner public {
638         whitelist[who] = allowTransfers;
639     }
640 
641     function transfer(address _to, uint256 _value) public returns (bool){
642         require(!paused || whitelist[msg.sender]);
643         return super.transfer(_to, _value);
644     }
645 
646     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
647         require(!paused || whitelist[msg.sender] || whitelist[_from]);
648         return super.transferFrom(_from, _to, _value);
649     }
650 
651 }
652 
653 /**
654  * @title Revocable Token
655  * @dev Token that can be revokend until minting is not finished.
656  */
657 contract RevocableToken is MintableToken {
658 
659     event Revoke(address indexed from, uint256 value);
660 
661     modifier canRevoke() {
662         require(!mintingFinished);
663         _;
664     }
665 
666     /**
667      * @dev Revokes minted tokens
668      * @param _from The address whose tokens are revoked
669      * @param _value The amount of token to revoke
670      */
671     function revoke(address _from, uint256 _value) onlyOwner canRevoke public returns (bool) {
672         require(_value <= balances[_from]);
673         // no need to require value <= totalSupply, since that would imply the
674         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
675 
676         balances[_from] = balances[_from].sub(_value);
677         totalSupply_ = totalSupply_.sub(_value);
678 
679         emit Revoke(_from, _value);
680         emit Transfer(_from, address(0), _value);
681         return true;
682     }
683 }
684 
685 contract RewardsToken is RevocableToken, /*MintableToken,*/ PausableToken, BurnableToken, NoOwner {
686     string public symbol = 'RWRD';
687     string public name = 'Rewards Cash';
688     uint8 public constant decimals = 18;
689 
690     uint256 public hardCap = 10 ** (18 + 9); //1B tokens. Max amount of tokens which can be minted
691 
692     /**
693     * @notice Function to mint tokens
694     * @dev This function checks hardCap and calls MintableToken.mint()
695     * @param _to The address that will receive the minted tokens.
696     * @param _amount The amount of tokens to mint.
697     * @return A boolean that indicates if the operation was successful.
698     */
699     function mint(address _to, uint256 _amount) public returns (bool){
700         require(totalSupply_.add(_amount) <= hardCap);
701         return super.mint(_to, _amount);
702     }
703 
704 
705 }
706 contract RewardsMinter is Claimable, NoOwner {
707     using SafeMath for uint256;
708 
709     struct MintProposal {
710         address beneficiary;    //Who will receive tokens
711         uint256 amount;         //How much tokens will be minted
712         mapping(address => bool) signers;   //Who already signed
713         uint256 weight;         //Current proposal weight
714         bool minted;            //If tokens where already minted for this proposal
715     }
716 
717     RewardsToken public token;
718     mapping(address => uint256) public signers;     //Mapping of proposal signer to his weight
719     uint256 public requiredWeight;                  //Weight required for proposal to be confirmed
720 
721     MintProposal[] public mintProposals;
722 
723     event SignerWeightChange(address indexed signer, uint256 oldWeight, uint256 newWeight);
724     event RequiredWeightChange(uint256 oldWeight, uint256 newWeight);
725     event MintProposalCreated(uint256 proposalId, address indexed beneficiary, uint256 amount);
726     event MintProposalApproved(uint256 proposalId, address indexed signer);
727     event MintProposalCompleted(uint256 proposalId, address indexed beneficiary, uint256 amount);
728 
729     modifier onlySigner(){
730         require(signers[msg.sender] > 0 );
731         _;
732     }
733 
734     constructor(address _token, uint256 _requiredWeight, uint256 _ownerWeight) public {
735         if(_token == 0x0){
736             token = new RewardsToken();
737             token.setWhitelisted(address(this), true);
738             token.setWhitelisted(msg.sender, true);
739             token.pause();
740         }else{
741             token = RewardsToken(_token);
742         }
743 
744         requiredWeight = _requiredWeight;         //Requires at least one signer for proposal
745         signers[owner] = _ownerWeight;    //makes owner also the signer
746         emit SignerWeightChange(owner, 0, _ownerWeight);
747     }
748 
749     function mintProposalCount() view public returns(uint256){
750         return mintProposals.length;
751     }
752 
753     /**
754     * @notice Add/Remove/Change signer
755     */
756     function setSignerWeight(address signer, uint256 weight) onlyOwner external {
757         emit SignerWeightChange(signer, signers[signer], weight);
758         signers[signer] = weight;
759     }
760     function setRequiredWeight(uint256 weight) onlyOwner external {
761         requiredWeight = weight;
762     }
763 
764     /**
765     * @notice Create new proposal and vote for it
766     */
767     function createProposal(address _beneficiary, uint256 _amount) onlySigner external returns(uint256){
768         uint256 idx = mintProposals.length++;
769         mintProposals[idx].beneficiary = _beneficiary;
770         mintProposals[idx].amount = _amount;
771         mintProposals[idx].minted = false;
772         mintProposals[idx].signers[msg.sender] = true;
773         mintProposals[idx].weight = signers[msg.sender];
774         emit MintProposalCreated(idx, _beneficiary, _amount);
775         emit MintProposalApproved(idx, msg.sender);
776         mintIfWeightEnough(idx);
777         return idx;
778     }
779 
780     /**
781     * @notice Create new proposal and vote for it
782     */
783     function approveProposal(uint256 idx, address _beneficiary, uint256 _amount) onlySigner external {
784         require(mintProposals[idx].beneficiary == _beneficiary);
785         require(mintProposals[idx].amount == _amount);
786         require(mintProposals[idx].signers[msg.sender] == false);
787         mintProposals[idx].signers[msg.sender] = true;
788         mintProposals[idx].weight = mintProposals[idx].weight.add(signers[msg.sender]);
789         emit MintProposalApproved(idx, msg.sender);
790         mintIfWeightEnough(idx);
791     }
792 
793     /**
794     * @dev Check current proposal weight and mint if ready
795     */
796     function mintIfWeightEnough(uint256 idx) internal {
797         if(mintProposals[idx].weight >= requiredWeight && !mintProposals[idx].minted){
798             mint(mintProposals[idx].beneficiary, mintProposals[idx].amount);
799             mintProposals[idx].minted = true;
800             emit MintProposalCompleted(idx, mintProposals[idx].beneficiary, mintProposals[idx].amount);
801         }
802     }
803 
804     /**
805     * @dev Function to mint tokens
806     * @param _to The address that will receive the minted tokens.
807     * @param _amount The amount of tokens to mint.
808     * @return A boolean that indicates if the operation was successful.
809     */
810     function mint(address _to, uint256 _amount) internal returns (bool){
811         return token.mint(_to, _amount);
812     }
813 
814 
815     //Token management
816     function tokenPause() onlyOwner public {
817         token.pause();
818     }
819     function tokenUnpause() onlyOwner public {
820         token.unpause();
821     }
822     function tokenSetWhitelisted(address who, bool allowTransfers) onlyOwner public {
823         token.setWhitelisted(who, allowTransfers);
824     }
825     function tokenRevoke(address _from, uint256 _value) onlyOwner public {
826         token.revoke(_from, _value);
827     }
828     function tokenFinishMinting() onlyOwner public {
829         token.finishMinting();
830     }
831 }
832 
833 contract RevokeHandler is Claimable, NoOwner {
834     RewardsToken public token;
835     constructor(address _token) public {
836         token = RewardsToken(_token);
837     }
838     
839     function getTokenAmount(address _holder) private view returns (uint256){
840         return token.balanceOf(_holder);
841     }
842     
843     function revokeTokens(address[] _holders) public onlyOwner {
844        uint256 amount = 0;
845        require(_holders.length > 0, "Empty holder addresses");
846        for (uint i = 0; i < _holders.length; i++) {
847          amount = getTokenAmount(_holders[i]);
848          if(amount > 0) {
849              token.revoke(_holders[i], amount);
850          }
851        }
852    }
853 }