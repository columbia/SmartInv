1 pragma solidity 0.4.24;
2 
3 
4 
5 
6 
7 
8 
9 
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * See https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
36     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
37     // benefit is lost if 'b' is also tested.
38     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39     if (a == 0) {
40       return 0;
41     }
42 
43     c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   /**
49   * @dev Integer division of two numbers, truncating the quotient.
50   */
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     // uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return a / b;
56   }
57 
58   /**
59   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
60   */
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   /**
67   * @dev Adds two numbers, throws on overflow.
68   */
69   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
70     c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances.
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) balances;
86 
87   uint256 totalSupply_;
88 
89   /**
90   * @dev Total number of tokens in existence
91   */
92   function totalSupply() public view returns (uint256) {
93     return totalSupply_;
94   }
95 
96   /**
97   * @dev Transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[msg.sender]);
104 
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     emit Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 
123 
124 
125 
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender)
133     public view returns (uint256);
134 
135   function transferFrom(address from, address to, uint256 value)
136     public returns (bool);
137 
138   function approve(address spender, uint256 value) public returns (bool);
139   event Approval(
140     address indexed owner,
141     address indexed spender,
142     uint256 value
143   );
144 }
145 
146 
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * https://github.com/ethereum/EIPs/issues/20
153  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(
167     address _from,
168     address _to,
169     uint256 _value
170   )
171     public
172     returns (bool)
173   {
174     require(_to != address(0));
175     require(_value <= balances[_from]);
176     require(_value <= allowed[_from][msg.sender]);
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181     emit Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param _spender The address which will spend the funds.
192    * @param _value The amount of tokens to be spent.
193    */
194   function approve(address _spender, uint256 _value) public returns (bool) {
195     allowed[msg.sender][_spender] = _value;
196     emit Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param _owner address The address which owns the funds.
203    * @param _spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(
207     address _owner,
208     address _spender
209    )
210     public
211     view
212     returns (uint256)
213   {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * @dev Increase the amount of tokens that an owner allowed to a spender.
219    * approve should be called when allowed[_spender] == 0. To increment
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _addedValue The amount of tokens to increase the allowance by.
225    */
226   function increaseApproval(
227     address _spender,
228     uint256 _addedValue
229   )
230     public
231     returns (bool)
232   {
233     allowed[msg.sender][_spender] = (
234       allowed[msg.sender][_spender].add(_addedValue));
235     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    * approve should be called when allowed[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseApproval(
249     address _spender,
250     uint256 _subtractedValue
251   )
252     public
253     returns (bool)
254   {
255     uint256 oldValue = allowed[msg.sender][_spender];
256     if (_subtractedValue > oldValue) {
257       allowed[msg.sender][_spender] = 0;
258     } else {
259       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
260     }
261     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 
265 }
266 
267 
268 
269 
270 
271 
272 
273 
274 /**
275  * @title Ownable
276  * @dev The Ownable contract has an owner address, and provides basic authorization control
277  * functions, this simplifies the implementation of "user permissions".
278  */
279 contract Ownable {
280   address public owner;
281 
282 
283   event OwnershipRenounced(address indexed previousOwner);
284   event OwnershipTransferred(
285     address indexed previousOwner,
286     address indexed newOwner
287   );
288 
289 
290   /**
291    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
292    * account.
293    */
294   constructor() public {
295     owner = msg.sender;
296   }
297 
298   /**
299    * @dev Throws if called by any account other than the owner.
300    */
301   modifier onlyOwner() {
302     require(msg.sender == owner);
303     _;
304   }
305 
306   /**
307    * @dev Allows the current owner to relinquish control of the contract.
308    * @notice Renouncing to ownership will leave the contract without an owner.
309    * It will not be possible to call the functions with the `onlyOwner`
310    * modifier anymore.
311    */
312   function renounceOwnership() public onlyOwner {
313     emit OwnershipRenounced(owner);
314     owner = address(0);
315   }
316 
317   /**
318    * @dev Allows the current owner to transfer control of the contract to a newOwner.
319    * @param _newOwner The address to transfer ownership to.
320    */
321   function transferOwnership(address _newOwner) public onlyOwner {
322     _transferOwnership(_newOwner);
323   }
324 
325   /**
326    * @dev Transfers control of the contract to a newOwner.
327    * @param _newOwner The address to transfer ownership to.
328    */
329   function _transferOwnership(address _newOwner) internal {
330     require(_newOwner != address(0));
331     emit OwnershipTransferred(owner, _newOwner);
332     owner = _newOwner;
333   }
334 }
335 
336 
337 
338 /**
339  * @title Contracts that should not own Ether
340  * @author Remco Bloemen <remco@2π.com>
341  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
342  * in the contract, it will allow the owner to reclaim this ether.
343  * @notice Ether can still be sent to this contract by:
344  * calling functions labeled `payable`
345  * `selfdestruct(contract_address)`
346  * mining directly to the contract address
347  */
348 contract HasNoEther is Ownable {
349 
350   /**
351   * @dev Constructor that rejects incoming Ether
352   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
353   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
354   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
355   * we could use assembly to access msg.value.
356   */
357   constructor() public payable {
358     require(msg.value == 0);
359   }
360 
361   /**
362    * @dev Disallows direct send by settings a default function without the `payable` flag.
363    */
364   function() external {
365   }
366 
367   /**
368    * @dev Transfer all Ether held by the contract to the owner.
369    */
370   function reclaimEther() external onlyOwner {
371     owner.transfer(address(this).balance);
372   }
373 }
374 
375 
376 
377 
378 
379 
380 
381 
382 
383 
384 
385 
386 
387 /**
388  * @title SafeERC20
389  * @dev Wrappers around ERC20 operations that throw on failure.
390  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
391  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
392  */
393 library SafeERC20 {
394   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
395     require(token.transfer(to, value));
396   }
397 
398   function safeTransferFrom(
399     ERC20 token,
400     address from,
401     address to,
402     uint256 value
403   )
404     internal
405   {
406     require(token.transferFrom(from, to, value));
407   }
408 
409   function safeApprove(ERC20 token, address spender, uint256 value) internal {
410     require(token.approve(spender, value));
411   }
412 }
413 
414 
415 
416 /**
417  * @title Contracts that should be able to recover tokens
418  * @author SylTi
419  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
420  * This will prevent any accidental loss of tokens.
421  */
422 contract CanReclaimToken is Ownable {
423   using SafeERC20 for ERC20Basic;
424 
425   /**
426    * @dev Reclaim all ERC20Basic compatible tokens
427    * @param token ERC20Basic The address of the token contract
428    */
429   function reclaimToken(ERC20Basic token) external onlyOwner {
430     uint256 balance = token.balanceOf(this);
431     token.safeTransfer(owner, balance);
432   }
433 
434 }
435 
436 
437 
438 /**
439  * @title Contracts that should not own Tokens
440  * @author Remco Bloemen <remco@2π.com>
441  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
442  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
443  * owner to reclaim the tokens.
444  */
445 contract HasNoTokens is CanReclaimToken {
446 
447  /**
448   * @dev Reject all ERC223 compatible tokens
449   * @param from_ address The address that is transferring the tokens
450   * @param value_ uint256 the amount of the specified token
451   * @param data_ Bytes The data passed from the caller.
452   */
453   function tokenFallback(address from_, uint256 value_, bytes data_) external {
454     from_;
455     value_;
456     data_;
457     revert();
458   }
459 
460 }
461 
462 
463 
464 
465 
466 
467 /**
468  * @title Contracts that should not own Contracts
469  * @author Remco Bloemen <remco@2π.com>
470  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
471  * of this contract to reclaim ownership of the contracts.
472  */
473 contract HasNoContracts is Ownable {
474 
475   /**
476    * @dev Reclaim ownership of Ownable contracts
477    * @param contractAddr The address of the Ownable to be reclaimed.
478    */
479   function reclaimContract(address contractAddr) external onlyOwner {
480     Ownable contractInst = Ownable(contractAddr);
481     contractInst.transferOwnership(owner);
482   }
483 }
484 
485 
486 
487 /**
488  * @title Base contract for contracts that should not own things.
489  * @author Remco Bloemen <remco@2π.com>
490  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
491  * Owned contracts. See respective base contracts for details.
492  */
493 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
494 }
495 
496 
497 
498 
499 
500 
501 /**
502  * @title Burnable Token
503  * @dev Token that can be irreversibly burned (destroyed).
504  */
505 contract BurnableToken is BasicToken {
506 
507   event Burn(address indexed burner, uint256 value);
508 
509   /**
510    * @dev Burns a specific amount of tokens.
511    * @param _value The amount of token to be burned.
512    */
513   function burn(uint256 _value) public {
514     _burn(msg.sender, _value);
515   }
516 
517   function _burn(address _who, uint256 _value) internal {
518     require(_value <= balances[_who]);
519     // no need to require value <= totalSupply, since that would imply the
520     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
521 
522     balances[_who] = balances[_who].sub(_value);
523     totalSupply_ = totalSupply_.sub(_value);
524     emit Burn(_who, _value);
525     emit Transfer(_who, address(0), _value);
526   }
527 }
528 
529 
530 
531 
532 /*
533 Copyright 2018 Vibeo
534 
535 Licensed under the Apache License, Version 2.0 (the "License");
536 you may not use this file except in compliance with the License.
537 You may obtain a copy of the License at
538 
539     http://www.apache.org/licenses/LICENSE-2.0
540 
541 Unless required by applicable law or agreed to in writing, software
542 distributed under the License is distributed on an "AS IS" BASIS,
543 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
544 See the License for the specific language governing permissions and
545 limitations under the License.
546  */
547 
548 
549 
550 
551 
552 contract CustomWhitelist is Ownable {
553   mapping(address => bool) public whitelist;
554   uint256 public numberOfWhitelists;
555 
556   event WhitelistedAddressAdded(address _addr);
557   event WhitelistedAddressRemoved(address _addr);
558 
559   /**
560    * @dev Throws if called by any account that's not whitelisted.
561    */
562   modifier onlyWhitelisted() {
563     require(whitelist[msg.sender] || msg.sender == owner);
564     _;
565   }
566 
567   constructor() public {
568     whitelist[msg.sender] = true;
569     numberOfWhitelists = 1;
570     emit WhitelistedAddressAdded(msg.sender);
571   }
572   /**
573    * @dev add an address to the whitelist
574    * @param _addr address
575    */
576   function addAddressToWhitelist(address _addr) onlyWhitelisted  public {
577     require(_addr != address(0));
578     require(!whitelist[_addr]);
579 
580     whitelist[_addr] = true;
581     numberOfWhitelists++;
582 
583     emit WhitelistedAddressAdded(_addr);
584   }
585 
586   /**
587    * @dev remove an address from the whitelist
588    * @param _addr address
589    */
590   function removeAddressFromWhitelist(address _addr) onlyWhitelisted  public {
591     require(_addr != address(0));
592     require(whitelist[_addr]);
593     //the owner can not be unwhitelisted
594     require(_addr != owner);
595 
596     whitelist[_addr] = false;
597     numberOfWhitelists--;
598 
599     emit WhitelistedAddressRemoved(_addr);
600   }
601 
602 }
603 
604 
605 
606 /**
607  * @title Pausable
608  * @dev Base contract which allows children to implement an emergency stop mechanism.
609  */
610 contract CustomPausable is CustomWhitelist {
611   event Pause();
612   event Unpause();
613 
614   bool public paused = false;
615 
616   /**
617    * @dev Modifier to make a function callable only when the contract is not paused.
618    */
619   modifier whenNotPaused() {
620     require(!paused);
621     _;
622   }
623 
624   /**
625    * @dev Modifier to make a function callable only when the contract is paused.
626    */
627   modifier whenPaused() {
628     require(paused);
629     _;
630   }
631 
632   /**
633    * @dev called by the owner to pause, triggers stopped state
634    */
635   function pause() onlyWhitelisted whenNotPaused public {
636     paused = true;
637     emit Pause();
638   }
639 
640   /**
641    * @dev called by the owner to unpause, returns to normal state
642    */
643   function unpause() onlyWhitelisted whenPaused public {
644     paused = false;
645     emit Unpause();
646   }
647 }
648 
649 
650 /**
651  * @title Vibeo: A new era of Instant Messaging/Social app allowing access to a blockchain community.
652  */
653 contract VibeoToken is StandardToken, BurnableToken, NoOwner, CustomPausable {
654   string public constant name = "Vibeo";
655   string public constant symbol = "VBEO";
656   uint8 public constant decimals = 18;
657 
658   uint256 public constant MAX_SUPPLY = 950000000 * (10 ** uint256(decimals)); //950 M
659 
660   ///@notice When transfers are disabled, no one except the transfer agents can use the transfer function.
661   bool public transfersEnabled;
662 
663   ///@notice This signifies that the ICO was successful.
664   bool public softCapReached;
665 
666   mapping(bytes32 => bool) private mintingList;
667 
668   ///@notice Transfer agents are allowed to perform transfers regardless of the transfer state.
669   mapping(address => bool) private transferAgents;
670 
671   ///@notice The end date of the crowdsale. 
672   uint256 public icoEndDate;
673   uint256 private year = 365 * 1 days;
674 
675   event TransferAgentSet(address agent, bool state);
676   event BulkTransferPerformed(address[] _destinations, uint256[] _amounts);
677 
678   constructor() public {
679     mintTokens(msg.sender, 453000000);
680     setTransferAgent(msg.sender, true);
681   }
682 
683   ///@notice Checks if the supplied address is able to perform transfers.
684   ///@param _from The address to check against if the transfer is allowed.
685   modifier canTransfer(address _from) {
686     if (!transfersEnabled && !transferAgents[_from]) {
687       revert();
688     }
689     _;
690   }
691 
692   ///@notice Computes keccak256 hash of the supplied value.
693   ///@param _key The string value to compute hash from.
694   function computeHash(string _key) private pure returns(bytes32){
695     return keccak256(abi.encodePacked(_key));
696   }
697 
698   ///@notice Check if the minting for the supplied key was already performed.
699   ///@param _key The key or category name of minting.
700   modifier whenNotMinted(string _key) {
701     if(mintingList[computeHash(_key)]) {
702       revert();
703     }
704     
705     _;
706   }
707 
708   ///@notice This function enables the whitelisted application (internal application) to set the ICO end date and can only be used once.
709   ///@param _date The date to set as the ICO end date.
710   function setICOEndDate(uint256 _date) public whenNotPaused onlyWhitelisted {
711     require(icoEndDate == 0);
712     icoEndDate = _date;
713   }
714 
715   ///@notice This function enables the whitelisted application (internal application) to set whether or not the softcap was reached.
716   //This function can only be used once.
717   function setSoftCapReached() public onlyWhitelisted {
718     require(!softCapReached);
719     softCapReached = true;
720   }
721 
722   ///@notice This function enables token transfers for everyone. Can only be enabled after the end of the ICO.
723   function enableTransfers() public onlyWhitelisted {
724     require(icoEndDate > 0);
725     require(now >= icoEndDate);
726     require(!transfersEnabled);
727     transfersEnabled = true;
728   }
729 
730   ///@notice This function disables token transfers for everyone.
731   function disableTransfers() public onlyWhitelisted {
732     require(transfersEnabled);
733     transfersEnabled = false;
734   }
735 
736   ///@notice Mints the tokens only once against the supplied key (category).
737   ///@param _key The key or the category of the allocation to mint the tokens for.
738   ///@param _amount The amount of tokens to mint.
739   function mintOnce(string _key, address _to, uint256 _amount) private whenNotPaused whenNotMinted(_key) {
740     mintTokens(_to, _amount);
741     mintingList[computeHash(_key)] = true;
742   }
743 
744   ///@notice Mints the below-mentioned amount of tokens allocated to the Vibeo team. 
745   //The tokens are only available to the team after 1 year of the ICO end.
746   function mintTeamTokens() public onlyWhitelisted {
747     require(icoEndDate > 0);
748     require(softCapReached);
749     
750     if(now < icoEndDate + year) {
751       revert("Access is denied. The team tokens are locked for 1 year from the ICO end date.");
752     }
753 
754     mintOnce("team", msg.sender, 50000000);
755   }
756 
757   ///@notice Mints the below-mentioned amount of tokens allocated to the Vibeo treasury wallet. 
758   //The tokens are available only when the softcap is reached and the ICO end date is specified.
759   function mintTreasuryTokens() public onlyWhitelisted {
760     require(icoEndDate > 0);
761     require(softCapReached);
762 
763     mintOnce("treasury", msg.sender, 90000000);
764   }
765 
766   ///@notice Mints the below-mentioned amount of tokens allocated to the Vibeo board advisors. 
767   //The tokens are only available to the team after 1 year of the ICO end.
768   function mintAdvisorTokens() public onlyWhitelisted {
769     require(icoEndDate > 0);
770 
771     if(now < icoEndDate + year) {
772       revert("Access is denied. The advisor tokens are locked for 1 year from the ICO end date.");
773     }
774 
775     mintOnce("advisorsTokens", msg.sender, 80000000);
776   }
777 
778   ///@notice Mints the below-mentioned amount of tokens allocated to the Vibeo partners. 
779   //The tokens are immediately available once the softcap is reached.
780   function mintPartnershipTokens() public onlyWhitelisted {
781     require(softCapReached);
782     mintOnce("partnerships", msg.sender, 60000000);
783   }
784 
785   ///@notice Mints the below-mentioned amount of tokens allocated to reward the Vibeo community. 
786   //The tokens are immediately available once the softcap is reached.
787   function mintCommunityRewards() public onlyWhitelisted {
788     require(softCapReached);
789     mintOnce("communityRewards", msg.sender, 90000000);
790   }
791 
792   ///@notice Mints the below-mentioned amount of tokens allocated to Vibeo user adoption. 
793   //The tokens are immediately available once the softcap is reached and ICO end date is specified.
794   function mintUserAdoptionTokens() public onlyWhitelisted {
795     require(icoEndDate > 0);
796     require(softCapReached);
797 
798     mintOnce("useradoption", msg.sender, 95000000);
799   }
800 
801   ///@notice Mints the below-mentioned amount of tokens allocated to the Vibeo marketing channel. 
802   //The tokens are immediately available once the softcap is reached.
803   function mintMarketingTokens() public onlyWhitelisted {
804     require(softCapReached);
805     mintOnce("marketing", msg.sender, 32000000);
806   }
807 
808   ///@notice Enables or disables the specified address to become a transfer agent.
809   //Transfer agents are such wallet addresses which can perform transfers even when transfer state is disabled.
810   ///@param _agent The wallet address of the transfer agent to assign or update.
811   ///@param _state Sets the status of the supplied wallet address to be a transfer agent. 
812   ///When this is set to false, the address will no longer be considered as a transfer agent.
813   function setTransferAgent(address _agent, bool _state) public whenNotPaused onlyWhitelisted {
814     transferAgents[_agent] = _state;
815     emit TransferAgentSet(_agent, _state);
816   }
817 
818   ///@notice Checks if the specified address is a transfer agent.
819   ///@param _address The wallet address of the transfer agent to assign or update.
820   ///When this is set to false, the address will no longer be considered as a transfer agent.
821   function isTransferAgent(address _address) public constant onlyWhitelisted returns(bool) {
822     return transferAgents[_address];
823   }
824 
825   ///@notice Transfers the specified value of tokens to the destination address. 
826   //Transfers can only happen when the tranfer state is enabled. 
827   //Transfer state can only be enabled after the end of the crowdsale.
828   ///@param _to The destination wallet address to transfer funds to.
829   ///@param _value The amount of tokens to send to the destination address.
830   function transfer(address _to, uint256 _value) public whenNotPaused canTransfer(msg.sender) returns (bool) {
831     require(_to != address(0));
832     return super.transfer(_to, _value);
833   }
834 
835   ///@notice Mints the supplied value of the tokens to the destination address.
836   //Minting cannot be performed any further once the maximum supply is reached.
837   //This function is private and cannot be used by anyone except for this contract.
838   ///@param _to The address which will receive the minted tokens.
839   ///@param _value The amount of tokens to mint.
840   function mintTokens(address _to, uint256 _value) private {
841     require(_to != address(0));
842     _value = _value.mul(10 ** uint256(decimals));
843     require(totalSupply_.add(_value) <= MAX_SUPPLY);
844 
845     totalSupply_ = totalSupply_.add(_value);
846     balances[_to] = balances[_to].add(_value);
847   }
848 
849   ///@notice Transfers tokens from a specified wallet address.
850   ///@dev This function is overriden to leverage transfer state feature.
851   ///@param _from The address to transfer funds from.
852   ///@param _to The address to transfer funds to.
853   ///@param _value The amount of tokens to transfer.
854   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) public returns (bool) {
855     require(_to != address(0));
856     return super.transferFrom(_from, _to, _value);
857   }
858 
859   ///@notice Approves a wallet address to spend on behalf of the sender.
860   ///@dev This function is overriden to leverage transfer state feature.
861   ///@param _spender The address which is approved to spend on behalf of the sender.
862   ///@param _value The amount of tokens approve to spend. 
863   function approve(address _spender, uint256 _value) public canTransfer(msg.sender) returns (bool) {
864     require(_spender != address(0));
865     return super.approve(_spender, _value);
866   }
867 
868 
869   ///@notice Increases the approval of the spender.
870   ///@dev This function is overriden to leverage transfer state feature.
871   ///@param _spender The address which is approved to spend on behalf of the sender.
872   ///@param _addedValue The added amount of tokens approved to spend.
873   function increaseApproval(address _spender, uint256 _addedValue) public canTransfer(msg.sender) returns(bool) {
874     require(_spender != address(0));
875     return super.increaseApproval(_spender, _addedValue);
876   }
877 
878   ///@notice Decreases the approval of the spender.
879   ///@dev This function is overriden to leverage transfer state feature.
880   ///@param _spender The address of the spender to decrease the allocation from.
881   ///@param _subtractedValue The amount of tokens to subtract from the approved allocation.
882   function decreaseApproval(address _spender, uint256 _subtractedValue) public canTransfer(msg.sender) whenNotPaused returns (bool) {
883     require(_spender != address(0));
884     return super.decreaseApproval(_spender, _subtractedValue);
885   }
886 
887   ///@notice Returns the sum of supplied values.
888   ///@param _values The collection of values to create the sum from.  
889   function sumOf(uint256[] _values) private pure returns(uint256) {
890     uint256 total = 0;
891 
892     for (uint256 i = 0; i < _values.length; i++) {
893       total = total.add(_values[i]);
894     }
895 
896     return total;
897   }
898 
899   ///@notice Allows only the admins and/or whitelisted applications to perform bulk transfer operation.
900   ///@param _destinations The destination wallet addresses to send funds to.
901   ///@param _amounts The respective amount of fund to send to the specified addresses. 
902   function bulkTransfer(address[] _destinations, uint256[] _amounts) public onlyWhitelisted {
903     require(_destinations.length == _amounts.length);
904 
905     //Saving gas by determining if the sender has enough balance
906     //to post this transaction.
907     uint256 requiredBalance = sumOf(_amounts);
908     require(balances[msg.sender] >= requiredBalance);
909     
910     for (uint256 i = 0; i < _destinations.length; i++) {
911      transfer(_destinations[i], _amounts[i]);
912     }
913 
914     emit BulkTransferPerformed(_destinations, _amounts);
915   }
916 
917   ///@notice Burns the coins held by the sender.
918   ///@param _value The amount of coins to burn.
919   ///@dev This function is overriden to leverage Pausable feature.
920   function burn(uint256 _value) public whenNotPaused {
921     super.burn(_value);
922   }
923 }