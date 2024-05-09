1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
67 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
68 
69 /**
70  * @title Claimable
71  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
72  * This allows the new owner to accept the transfer.
73  */
74 contract Claimable is Ownable {
75   address public pendingOwner;
76 
77   /**
78    * @dev Modifier throws if called by any account other than the pendingOwner.
79    */
80   modifier onlyPendingOwner() {
81     require(msg.sender == pendingOwner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to set the pendingOwner address.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     pendingOwner = newOwner;
91   }
92 
93   /**
94    * @dev Allows the pendingOwner address to finalize the transfer.
95    */
96   function claimOwnership() public onlyPendingOwner {
97     emit OwnershipTransferred(owner, pendingOwner);
98     owner = pendingOwner;
99     pendingOwner = address(0);
100   }
101 }
102 
103 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
104 
105 /**
106  * @title ERC20Basic
107  * @dev Simpler version of ERC20 interface
108  * See https://github.com/ethereum/EIPs/issues/179
109  */
110 contract ERC20Basic {
111   function totalSupply() public view returns (uint256);
112   function balanceOf(address _who) public view returns (uint256);
113   function transfer(address _to, uint256 _value) public returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115 }
116 
117 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address _owner, address _spender)
125     public view returns (uint256);
126 
127   function transferFrom(address _from, address _to, uint256 _value)
128     public returns (bool);
129 
130   function approve(address _spender, uint256 _value) public returns (bool);
131   event Approval(
132     address indexed owner,
133     address indexed spender,
134     uint256 value
135   );
136 }
137 
138 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
139 
140 /**
141  * @title SafeERC20
142  * @dev Wrappers around ERC20 operations that throw on failure.
143  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
144  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
145  */
146 library SafeERC20 {
147   function safeTransfer(
148     ERC20Basic _token,
149     address _to,
150     uint256 _value
151   )
152     internal
153   {
154     require(_token.transfer(_to, _value));
155   }
156 
157   function safeTransferFrom(
158     ERC20 _token,
159     address _from,
160     address _to,
161     uint256 _value
162   )
163     internal
164   {
165     require(_token.transferFrom(_from, _to, _value));
166   }
167 
168   function safeApprove(
169     ERC20 _token,
170     address _spender,
171     uint256 _value
172   )
173     internal
174   {
175     require(_token.approve(_spender, _value));
176   }
177 }
178 
179 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
180 
181 /**
182  * @title Contracts that should be able to recover tokens
183  * @author SylTi
184  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
185  * This will prevent any accidental loss of tokens.
186  */
187 contract CanReclaimToken is Ownable {
188   using SafeERC20 for ERC20Basic;
189 
190   /**
191    * @dev Reclaim all ERC20Basic compatible tokens
192    * @param _token ERC20Basic The address of the token contract
193    */
194   function reclaimToken(ERC20Basic _token) external onlyOwner {
195     uint256 balance = _token.balanceOf(this);
196     _token.safeTransfer(owner, balance);
197   }
198 
199 }
200 
201 // File: contracts/utils/OwnableContract.sol
202 
203 // empty block is used as this contract just inherits others.
204 contract OwnableContract is CanReclaimToken, Claimable { } /* solhint-disable-line no-empty-blocks */
205 
206 // File: contracts/utils/OwnableContractOwner.sol
207 
208 contract OwnableContractOwner is OwnableContract {
209 
210     event CalledTransferOwnership(OwnableContract ownedContract, address newOwner);
211 
212     function callTransferOwnership(OwnableContract ownedContract, address newOwner) external onlyOwner returns (bool) {
213         require(newOwner != address(0), "invalid newOwner address");
214         ownedContract.transferOwnership(newOwner);
215         emit CalledTransferOwnership(ownedContract, newOwner);
216         return true;
217     }
218 
219     event CalledClaimOwnership(OwnableContract contractToOwn);
220 
221     function callClaimOwnership(OwnableContract contractToOwn) external onlyOwner returns (bool) {
222         contractToOwn.claimOwnership();
223         emit CalledClaimOwnership(contractToOwn);
224         return true;
225     }
226 
227     event CalledReclaimToken(OwnableContract ownedContract, ERC20 _token);
228 
229     function callReclaimToken(OwnableContract ownedContract, ERC20 _token) external onlyOwner returns (bool) {
230         require(_token != address(0), "invalid _token address");
231         ownedContract.reclaimToken(_token);
232         emit CalledReclaimToken(ownedContract, _token);
233         return true;
234     }
235 }
236 
237 // File: contracts/controller/ControllerInterface.sol
238 
239 interface ControllerInterface {
240     function mint(address to, uint amount) external returns (bool);
241     function burn(uint value) external returns (bool);
242     function isCustodian(address addr) external view returns (bool);
243     function isMerchant(address addr) external view returns (bool);
244     function getWBTC() external view returns (ERC20);
245 }
246 
247 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
248 
249 /**
250  * @title SafeMath
251  * @dev Math operations with safety checks that throw on error
252  */
253 library SafeMath {
254 
255   /**
256   * @dev Multiplies two numbers, throws on overflow.
257   */
258   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
259     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
260     // benefit is lost if 'b' is also tested.
261     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
262     if (_a == 0) {
263       return 0;
264     }
265 
266     c = _a * _b;
267     assert(c / _a == _b);
268     return c;
269   }
270 
271   /**
272   * @dev Integer division of two numbers, truncating the quotient.
273   */
274   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
275     // assert(_b > 0); // Solidity automatically throws when dividing by 0
276     // uint256 c = _a / _b;
277     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
278     return _a / _b;
279   }
280 
281   /**
282   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
283   */
284   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
285     assert(_b <= _a);
286     return _a - _b;
287   }
288 
289   /**
290   * @dev Adds two numbers, throws on overflow.
291   */
292   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
293     c = _a + _b;
294     assert(c >= _a);
295     return c;
296   }
297 }
298 
299 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
300 
301 /**
302  * @title Basic token
303  * @dev Basic version of StandardToken, with no allowances.
304  */
305 contract BasicToken is ERC20Basic {
306   using SafeMath for uint256;
307 
308   mapping(address => uint256) internal balances;
309 
310   uint256 internal totalSupply_;
311 
312   /**
313   * @dev Total number of tokens in existence
314   */
315   function totalSupply() public view returns (uint256) {
316     return totalSupply_;
317   }
318 
319   /**
320   * @dev Transfer token for a specified address
321   * @param _to The address to transfer to.
322   * @param _value The amount to be transferred.
323   */
324   function transfer(address _to, uint256 _value) public returns (bool) {
325     require(_value <= balances[msg.sender]);
326     require(_to != address(0));
327 
328     balances[msg.sender] = balances[msg.sender].sub(_value);
329     balances[_to] = balances[_to].add(_value);
330     emit Transfer(msg.sender, _to, _value);
331     return true;
332   }
333 
334   /**
335   * @dev Gets the balance of the specified address.
336   * @param _owner The address to query the the balance of.
337   * @return An uint256 representing the amount owned by the passed address.
338   */
339   function balanceOf(address _owner) public view returns (uint256) {
340     return balances[_owner];
341   }
342 
343 }
344 
345 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
346 
347 /**
348  * @title Standard ERC20 token
349  *
350  * @dev Implementation of the basic standard token.
351  * https://github.com/ethereum/EIPs/issues/20
352  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
353  */
354 contract StandardToken is ERC20, BasicToken {
355 
356   mapping (address => mapping (address => uint256)) internal allowed;
357 
358 
359   /**
360    * @dev Transfer tokens from one address to another
361    * @param _from address The address which you want to send tokens from
362    * @param _to address The address which you want to transfer to
363    * @param _value uint256 the amount of tokens to be transferred
364    */
365   function transferFrom(
366     address _from,
367     address _to,
368     uint256 _value
369   )
370     public
371     returns (bool)
372   {
373     require(_value <= balances[_from]);
374     require(_value <= allowed[_from][msg.sender]);
375     require(_to != address(0));
376 
377     balances[_from] = balances[_from].sub(_value);
378     balances[_to] = balances[_to].add(_value);
379     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
380     emit Transfer(_from, _to, _value);
381     return true;
382   }
383 
384   /**
385    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
386    * Beware that changing an allowance with this method brings the risk that someone may use both the old
387    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
388    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
389    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
390    * @param _spender The address which will spend the funds.
391    * @param _value The amount of tokens to be spent.
392    */
393   function approve(address _spender, uint256 _value) public returns (bool) {
394     allowed[msg.sender][_spender] = _value;
395     emit Approval(msg.sender, _spender, _value);
396     return true;
397   }
398 
399   /**
400    * @dev Function to check the amount of tokens that an owner allowed to a spender.
401    * @param _owner address The address which owns the funds.
402    * @param _spender address The address which will spend the funds.
403    * @return A uint256 specifying the amount of tokens still available for the spender.
404    */
405   function allowance(
406     address _owner,
407     address _spender
408    )
409     public
410     view
411     returns (uint256)
412   {
413     return allowed[_owner][_spender];
414   }
415 
416   /**
417    * @dev Increase the amount of tokens that an owner allowed to a spender.
418    * approve should be called when allowed[_spender] == 0. To increment
419    * allowed value is better to use this function to avoid 2 calls (and wait until
420    * the first transaction is mined)
421    * From MonolithDAO Token.sol
422    * @param _spender The address which will spend the funds.
423    * @param _addedValue The amount of tokens to increase the allowance by.
424    */
425   function increaseApproval(
426     address _spender,
427     uint256 _addedValue
428   )
429     public
430     returns (bool)
431   {
432     allowed[msg.sender][_spender] = (
433       allowed[msg.sender][_spender].add(_addedValue));
434     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
435     return true;
436   }
437 
438   /**
439    * @dev Decrease the amount of tokens that an owner allowed to a spender.
440    * approve should be called when allowed[_spender] == 0. To decrement
441    * allowed value is better to use this function to avoid 2 calls (and wait until
442    * the first transaction is mined)
443    * From MonolithDAO Token.sol
444    * @param _spender The address which will spend the funds.
445    * @param _subtractedValue The amount of tokens to decrease the allowance by.
446    */
447   function decreaseApproval(
448     address _spender,
449     uint256 _subtractedValue
450   )
451     public
452     returns (bool)
453   {
454     uint256 oldValue = allowed[msg.sender][_spender];
455     if (_subtractedValue >= oldValue) {
456       allowed[msg.sender][_spender] = 0;
457     } else {
458       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
459     }
460     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
461     return true;
462   }
463 
464 }
465 
466 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
467 
468 /**
469  * @title DetailedERC20 token
470  * @dev The decimals are only for visualization purposes.
471  * All the operations are done using the smallest and indivisible token unit,
472  * just as on Ethereum all the operations are done in wei.
473  */
474 contract DetailedERC20 is ERC20 {
475   string public name;
476   string public symbol;
477   uint8 public decimals;
478 
479   constructor(string _name, string _symbol, uint8 _decimals) public {
480     name = _name;
481     symbol = _symbol;
482     decimals = _decimals;
483   }
484 }
485 
486 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
487 
488 /**
489  * @title Mintable token
490  * @dev Simple ERC20 Token example, with mintable token creation
491  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
492  */
493 contract MintableToken is StandardToken, Ownable {
494   event Mint(address indexed to, uint256 amount);
495   event MintFinished();
496 
497   bool public mintingFinished = false;
498 
499 
500   modifier canMint() {
501     require(!mintingFinished);
502     _;
503   }
504 
505   modifier hasMintPermission() {
506     require(msg.sender == owner);
507     _;
508   }
509 
510   /**
511    * @dev Function to mint tokens
512    * @param _to The address that will receive the minted tokens.
513    * @param _amount The amount of tokens to mint.
514    * @return A boolean that indicates if the operation was successful.
515    */
516   function mint(
517     address _to,
518     uint256 _amount
519   )
520     public
521     hasMintPermission
522     canMint
523     returns (bool)
524   {
525     totalSupply_ = totalSupply_.add(_amount);
526     balances[_to] = balances[_to].add(_amount);
527     emit Mint(_to, _amount);
528     emit Transfer(address(0), _to, _amount);
529     return true;
530   }
531 
532   /**
533    * @dev Function to stop minting new tokens.
534    * @return True if the operation was successful.
535    */
536   function finishMinting() public onlyOwner canMint returns (bool) {
537     mintingFinished = true;
538     emit MintFinished();
539     return true;
540   }
541 }
542 
543 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
544 
545 /**
546  * @title Burnable Token
547  * @dev Token that can be irreversibly burned (destroyed).
548  */
549 contract BurnableToken is BasicToken {
550 
551   event Burn(address indexed burner, uint256 value);
552 
553   /**
554    * @dev Burns a specific amount of tokens.
555    * @param _value The amount of token to be burned.
556    */
557   function burn(uint256 _value) public {
558     _burn(msg.sender, _value);
559   }
560 
561   function _burn(address _who, uint256 _value) internal {
562     require(_value <= balances[_who]);
563     // no need to require value <= totalSupply, since that would imply the
564     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
565 
566     balances[_who] = balances[_who].sub(_value);
567     totalSupply_ = totalSupply_.sub(_value);
568     emit Burn(_who, _value);
569     emit Transfer(_who, address(0), _value);
570   }
571 }
572 
573 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
574 
575 /**
576  * @title Pausable
577  * @dev Base contract which allows children to implement an emergency stop mechanism.
578  */
579 contract Pausable is Ownable {
580   event Pause();
581   event Unpause();
582 
583   bool public paused = false;
584 
585 
586   /**
587    * @dev Modifier to make a function callable only when the contract is not paused.
588    */
589   modifier whenNotPaused() {
590     require(!paused);
591     _;
592   }
593 
594   /**
595    * @dev Modifier to make a function callable only when the contract is paused.
596    */
597   modifier whenPaused() {
598     require(paused);
599     _;
600   }
601 
602   /**
603    * @dev called by the owner to pause, triggers stopped state
604    */
605   function pause() public onlyOwner whenNotPaused {
606     paused = true;
607     emit Pause();
608   }
609 
610   /**
611    * @dev called by the owner to unpause, returns to normal state
612    */
613   function unpause() public onlyOwner whenPaused {
614     paused = false;
615     emit Unpause();
616   }
617 }
618 
619 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
620 
621 /**
622  * @title Pausable token
623  * @dev StandardToken modified with pausable transfers.
624  **/
625 contract PausableToken is StandardToken, Pausable {
626 
627   function transfer(
628     address _to,
629     uint256 _value
630   )
631     public
632     whenNotPaused
633     returns (bool)
634   {
635     return super.transfer(_to, _value);
636   }
637 
638   function transferFrom(
639     address _from,
640     address _to,
641     uint256 _value
642   )
643     public
644     whenNotPaused
645     returns (bool)
646   {
647     return super.transferFrom(_from, _to, _value);
648   }
649 
650   function approve(
651     address _spender,
652     uint256 _value
653   )
654     public
655     whenNotPaused
656     returns (bool)
657   {
658     return super.approve(_spender, _value);
659   }
660 
661   function increaseApproval(
662     address _spender,
663     uint _addedValue
664   )
665     public
666     whenNotPaused
667     returns (bool success)
668   {
669     return super.increaseApproval(_spender, _addedValue);
670   }
671 
672   function decreaseApproval(
673     address _spender,
674     uint _subtractedValue
675   )
676     public
677     whenNotPaused
678     returns (bool success)
679   {
680     return super.decreaseApproval(_spender, _subtractedValue);
681   }
682 }
683 
684 // File: contracts/token/WBTC.sol
685 
686 contract WBTC is StandardToken, DetailedERC20("Wrapped BTC", "WBTC", 8),
687     MintableToken, BurnableToken, PausableToken, OwnableContract {
688 
689     function burn(uint value) public onlyOwner {
690         super.burn(value);
691     }
692 
693     function finishMinting() public onlyOwner returns (bool) {
694         return false;
695     }
696 
697     function renounceOwnership() public onlyOwner {
698         revert("renouncing ownership is blocked");
699     }
700 }
701 
702 // File: contracts/factory/MembersInterface.sol
703 
704 interface MembersInterface {
705     function setCustodian(address _custodian) external returns (bool);
706     function addMerchant(address merchant) external returns (bool);
707     function removeMerchant(address merchant) external returns (bool);
708     function isCustodian(address addr) external view returns (bool);
709     function isMerchant(address addr) external view returns (bool);
710 }
711 
712 // File: contracts/controller/Controller.sol
713 
714 contract Controller is ControllerInterface, OwnableContract, OwnableContractOwner {
715 
716     WBTC public token;
717     MembersInterface public members;
718     address public factory;
719 
720     constructor(WBTC _token) public {
721         require(_token != address(0), "invalid _token address");
722         token = _token;
723     }
724 
725     modifier onlyFactory() {
726         require(msg.sender == factory, "sender not authorized for minting or burning.");
727         _;
728     }
729 
730     // setters
731     event MembersSet(MembersInterface indexed members);
732 
733     function setMembers(MembersInterface _members) external onlyOwner returns (bool) {
734         require(_members != address(0), "invalid _members address");
735         members = _members;
736         emit MembersSet(members);
737         return true;
738     }
739 
740     event FactorySet(address indexed factory);
741 
742     function setFactory(address _factory) external onlyOwner returns (bool) {
743         require(_factory != address(0), "invalid _factory address");
744         factory = _factory;
745         emit FactorySet(factory);
746         return true;
747     }
748 
749     // only owner actions on token
750     event Paused();
751 
752     function pause() external onlyOwner returns (bool) {
753         token.pause();
754         emit Paused();
755         return true;
756     }
757 
758     event Unpaused();
759 
760     function unpause() external onlyOwner returns (bool) {
761         token.unpause();
762         emit Unpaused();
763         return true;
764     }
765 
766     // only factory actions on token
767     function mint(address to, uint amount) external onlyFactory returns (bool) {
768         require(to != address(0), "invalid to address");
769         require(!token.paused(), "token is paused.");
770         require(token.mint(to, amount), "minting failed.");
771         return true;
772     }
773 
774     function burn(uint value) external onlyFactory returns (bool) {
775         require(!token.paused(), "token is paused.");
776         token.burn(value);
777         return true;
778     }
779 
780     // all accessible
781     function isCustodian(address addr) external view returns (bool) {
782         return members.isCustodian(addr);
783     }
784 
785     function isMerchant(address addr) external view returns (bool) {
786         return members.isMerchant(addr);
787     }
788 
789     function getWBTC() external view returns (ERC20) {
790         return token;
791     }
792 
793     // overriding
794     function renounceOwnership() public onlyOwner {
795         revert("renouncing ownership is blocked.");
796     }
797 }