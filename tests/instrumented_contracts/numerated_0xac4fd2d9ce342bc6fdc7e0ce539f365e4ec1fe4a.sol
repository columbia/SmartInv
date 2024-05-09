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
81 library SafeMath16 {
82   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
83     if (a == 0) {
84       return 0;
85     }
86     uint16 c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90   function div(uint16 a, uint16 b) internal pure returns (uint16) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     uint16 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn’t hold
94     return c;
95   }
96   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
97     assert(b <= a);
98     return a - b;
99   }
100   function add(uint16 a, uint16 b) internal pure returns (uint16) {
101     uint16 c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 }
106 
107 
108 
109 
110 
111 
112 
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address _owner, address _spender)
120     public view returns (uint256);
121 
122   function transferFrom(address _from, address _to, uint256 _value)
123     public returns (bool);
124 
125   function approve(address _spender, uint256 _value) public returns (bool);
126   event Approval(
127     address indexed owner,
128     address indexed spender,
129     uint256 value
130   );
131 }
132 
133 
134 
135 /**
136  * @title SafeERC20
137  * @dev Wrappers around ERC20 operations that throw on failure.
138  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
139  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
140  */
141 library SafeERC20 {
142   function safeTransfer(
143     ERC20Basic _token,
144     address _to,
145     uint256 _value
146   )
147     internal
148   {
149     require(_token.transfer(_to, _value));
150   }
151 
152   function safeTransferFrom(
153     ERC20 _token,
154     address _from,
155     address _to,
156     uint256 _value
157   )
158     internal
159   {
160     require(_token.transferFrom(_from, _to, _value));
161   }
162 
163   function safeApprove(
164     ERC20 _token,
165     address _spender,
166     uint256 _value
167   )
168     internal
169   {
170     require(_token.approve(_spender, _value));
171   }
172 }
173 /*****************************************************************
174  * Core contract of the Million Dollar Decentralized Application *
175  *****************************************************************/
176 
177 
178 
179 
180 
181 
182 /**
183  * @title SafeMath
184  * @dev Math operations with safety checks that throw on error
185  */
186 library SafeMath {
187 
188   /**
189   * @dev Multiplies two numbers, throws on overflow.
190   */
191   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
192     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
193     // benefit is lost if 'b' is also tested.
194     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
195     if (_a == 0) {
196       return 0;
197     }
198 
199     c = _a * _b;
200     assert(c / _a == _b);
201     return c;
202   }
203 
204   /**
205   * @dev Integer division of two numbers, truncating the quotient.
206   */
207   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
208     // assert(_b > 0); // Solidity automatically throws when dividing by 0
209     // uint256 c = _a / _b;
210     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
211     return _a / _b;
212   }
213 
214   /**
215   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
216   */
217   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
218     assert(_b <= _a);
219     return _a - _b;
220   }
221 
222   /**
223   * @dev Adds two numbers, throws on overflow.
224   */
225   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
226     c = _a + _b;
227     assert(c >= _a);
228     return c;
229   }
230 }
231 
232 
233 
234 
235 
236 
237 
238 /**
239  * @title Contracts that should not own Ether
240  * @author Remco Bloemen <remco@2π.com>
241  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
242  * in the contract, it will allow the owner to reclaim this Ether.
243  * @notice Ether can still be sent to this contract by:
244  * calling functions labeled `payable`
245  * `selfdestruct(contract_address)`
246  * mining directly to the contract address
247  */
248 contract HasNoEther is Ownable {
249 
250   /**
251   * @dev Constructor that rejects incoming Ether
252   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
253   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
254   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
255   * we could use assembly to access msg.value.
256   */
257   constructor() public payable {
258     require(msg.value == 0);
259   }
260 
261   /**
262    * @dev Disallows direct send by setting a default function without the `payable` flag.
263    */
264   function() external {
265   }
266 
267   /**
268    * @dev Transfer all Ether held by the contract to the owner.
269    */
270   function reclaimEther() external onlyOwner {
271     owner.transfer(address(this).balance);
272   }
273 }
274 
275 
276 
277 
278 
279 
280 
281 
282 /**
283  * @title Contracts that should be able to recover tokens
284  * @author SylTi
285  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
286  * This will prevent any accidental loss of tokens.
287  */
288 contract CanReclaimToken is Ownable {
289   using SafeERC20 for ERC20Basic;
290 
291   /**
292    * @dev Reclaim all ERC20Basic compatible tokens
293    * @param _token ERC20Basic The address of the token contract
294    */
295   function reclaimToken(ERC20Basic _token) external onlyOwner {
296     uint256 balance = _token.balanceOf(this);
297     _token.safeTransfer(owner, balance);
298   }
299 
300 }
301 
302 
303 
304 
305 
306 
307 
308 
309 
310 
311 
312 
313 
314 
315 
316 /**
317  * @title Basic token
318  * @dev Basic version of StandardToken, with no allowances.
319  */
320 contract BasicToken is ERC20Basic {
321   using SafeMath for uint256;
322 
323   mapping(address => uint256) internal balances;
324 
325   uint256 internal totalSupply_;
326 
327   /**
328   * @dev Total number of tokens in existence
329   */
330   function totalSupply() public view returns (uint256) {
331     return totalSupply_;
332   }
333 
334   /**
335   * @dev Transfer token for a specified address
336   * @param _to The address to transfer to.
337   * @param _value The amount to be transferred.
338   */
339   function transfer(address _to, uint256 _value) public returns (bool) {
340     require(_value <= balances[msg.sender]);
341     require(_to != address(0));
342 
343     balances[msg.sender] = balances[msg.sender].sub(_value);
344     balances[_to] = balances[_to].add(_value);
345     emit Transfer(msg.sender, _to, _value);
346     return true;
347   }
348 
349   /**
350   * @dev Gets the balance of the specified address.
351   * @param _owner The address to query the the balance of.
352   * @return An uint256 representing the amount owned by the passed address.
353   */
354   function balanceOf(address _owner) public view returns (uint256) {
355     return balances[_owner];
356   }
357 
358 }
359 
360 
361 
362 
363 /**
364  * @title Standard ERC20 token
365  *
366  * @dev Implementation of the basic standard token.
367  * https://github.com/ethereum/EIPs/issues/20
368  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
369  */
370 contract StandardToken is ERC20, BasicToken {
371 
372   mapping (address => mapping (address => uint256)) internal allowed;
373 
374 
375   /**
376    * @dev Transfer tokens from one address to another
377    * @param _from address The address which you want to send tokens from
378    * @param _to address The address which you want to transfer to
379    * @param _value uint256 the amount of tokens to be transferred
380    */
381   function transferFrom(
382     address _from,
383     address _to,
384     uint256 _value
385   )
386     public
387     returns (bool)
388   {
389     require(_value <= balances[_from]);
390     require(_value <= allowed[_from][msg.sender]);
391     require(_to != address(0));
392 
393     balances[_from] = balances[_from].sub(_value);
394     balances[_to] = balances[_to].add(_value);
395     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
396     emit Transfer(_from, _to, _value);
397     return true;
398   }
399 
400   /**
401    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
402    * Beware that changing an allowance with this method brings the risk that someone may use both the old
403    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
404    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
405    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
406    * @param _spender The address which will spend the funds.
407    * @param _value The amount of tokens to be spent.
408    */
409   function approve(address _spender, uint256 _value) public returns (bool) {
410     allowed[msg.sender][_spender] = _value;
411     emit Approval(msg.sender, _spender, _value);
412     return true;
413   }
414 
415   /**
416    * @dev Function to check the amount of tokens that an owner allowed to a spender.
417    * @param _owner address The address which owns the funds.
418    * @param _spender address The address which will spend the funds.
419    * @return A uint256 specifying the amount of tokens still available for the spender.
420    */
421   function allowance(
422     address _owner,
423     address _spender
424    )
425     public
426     view
427     returns (uint256)
428   {
429     return allowed[_owner][_spender];
430   }
431 
432   /**
433    * @dev Increase the amount of tokens that an owner allowed to a spender.
434    * approve should be called when allowed[_spender] == 0. To increment
435    * allowed value is better to use this function to avoid 2 calls (and wait until
436    * the first transaction is mined)
437    * From MonolithDAO Token.sol
438    * @param _spender The address which will spend the funds.
439    * @param _addedValue The amount of tokens to increase the allowance by.
440    */
441   function increaseApproval(
442     address _spender,
443     uint256 _addedValue
444   )
445     public
446     returns (bool)
447   {
448     allowed[msg.sender][_spender] = (
449       allowed[msg.sender][_spender].add(_addedValue));
450     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
451     return true;
452   }
453 
454   /**
455    * @dev Decrease the amount of tokens that an owner allowed to a spender.
456    * approve should be called when allowed[_spender] == 0. To decrement
457    * allowed value is better to use this function to avoid 2 calls (and wait until
458    * the first transaction is mined)
459    * From MonolithDAO Token.sol
460    * @param _spender The address which will spend the funds.
461    * @param _subtractedValue The amount of tokens to decrease the allowance by.
462    */
463   function decreaseApproval(
464     address _spender,
465     uint256 _subtractedValue
466   )
467     public
468     returns (bool)
469   {
470     uint256 oldValue = allowed[msg.sender][_spender];
471     if (_subtractedValue >= oldValue) {
472       allowed[msg.sender][_spender] = 0;
473     } else {
474       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
475     }
476     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
477     return true;
478   }
479 
480 }
481 
482 
483 
484 
485 /**
486  * @title Mintable token
487  * @dev Simple ERC20 Token example, with mintable token creation
488  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
489  */
490 contract MintableToken is StandardToken, Ownable {
491   event Mint(address indexed to, uint256 amount);
492   event MintFinished();
493 
494   bool public mintingFinished = false;
495 
496 
497   modifier canMint() {
498     require(!mintingFinished);
499     _;
500   }
501 
502   modifier hasMintPermission() {
503     require(msg.sender == owner);
504     _;
505   }
506 
507   /**
508    * @dev Function to mint tokens
509    * @param _to The address that will receive the minted tokens.
510    * @param _amount The amount of tokens to mint.
511    * @return A boolean that indicates if the operation was successful.
512    */
513   function mint(
514     address _to,
515     uint256 _amount
516   )
517     public
518     hasMintPermission
519     canMint
520     returns (bool)
521   {
522     totalSupply_ = totalSupply_.add(_amount);
523     balances[_to] = balances[_to].add(_amount);
524     emit Mint(_to, _amount);
525     emit Transfer(address(0), _to, _amount);
526     return true;
527   }
528 
529   /**
530    * @dev Function to stop minting new tokens.
531    * @return True if the operation was successful.
532    */
533   function finishMinting() public onlyOwner canMint returns (bool) {
534     mintingFinished = true;
535     emit MintFinished();
536     return true;
537   }
538 }
539 
540 
541 
542 
543 /**
544  * @title MDAPPToken
545  * @dev Token for the Million Dollar Decentralized Application (MDAPP).
546  * Once a holder uses it to claim pixels the appropriate tokens are burned (1 Token <=> 10x10 pixel).
547  * If one releases his pixels new tokens are generated and credited to ones balance. Therefore, supply will
548  * vary between 0 and 10,000 tokens.
549  * Tokens are transferable once minting has finished.
550  * @dev Owned by MDAPP.sol
551  */
552 contract MDAPPToken is MintableToken {
553   using SafeMath16 for uint16;
554   using SafeMath for uint256;
555 
556   string public constant name = "MillionDollarDapp";
557   string public constant symbol = "MDAPP";
558   uint8 public constant decimals = 0;
559 
560   mapping (address => uint16) locked;
561 
562   bool public forceTransferEnable = false;
563 
564   /*********************************************************
565    *                                                       *
566    *                       Events                          *
567    *                                                       *
568    *********************************************************/
569 
570   // Emitted when owner force-allows transfers of tokens.
571   event AllowTransfer();
572 
573   /*********************************************************
574    *                                                       *
575    *                      Modifiers                        *
576    *                                                       *
577    *********************************************************/
578 
579   modifier hasLocked(address _account, uint16 _value) {
580     require(_value <= locked[_account], "Not enough locked tokens available.");
581     _;
582   }
583 
584   modifier hasUnlocked(address _account, uint16 _value) {
585     require(balanceOf(_account).sub(uint256(locked[_account])) >= _value, "Not enough unlocked tokens available.");
586     _;
587   }
588 
589   /**
590    * @dev Checks whether it can transfer or otherwise throws.
591    */
592   modifier canTransfer(address _sender, uint256 _value) {
593     require(_value <= transferableTokensOf(_sender), "Not enough unlocked tokens available.");
594     _;
595   }
596 
597 
598   /*********************************************************
599    *                                                       *
600    *                Limited Transfer Logic                 *
601    *            Taken from openzeppelin 1.3.0              *
602    *                                                       *
603    *********************************************************/
604 
605   function lockToken(address _account, uint16 _value) onlyOwner hasUnlocked(_account, _value) public {
606     locked[_account] = locked[_account].add(_value);
607   }
608 
609   function unlockToken(address _account, uint16 _value) onlyOwner hasLocked(_account, _value) public {
610     locked[_account] = locked[_account].sub(_value);
611   }
612 
613   /**
614    * @dev Checks modifier and allows transfer if tokens are not locked.
615    * @param _to The address that will receive the tokens.
616    * @param _value The amount of tokens to be transferred.
617    */
618   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
619     return super.transfer(_to, _value);
620   }
621 
622   /**
623   * @dev Checks modifier and allows transfer if tokens are not locked.
624   * @param _from The address that will send the tokens.
625   * @param _to The address that will receive the tokens.
626   * @param _value The amount of tokens to be transferred.
627   */
628   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
629     return super.transferFrom(_from, _to, _value);
630   }
631 
632   /**
633    * @dev Allow the holder to transfer his tokens only if every token in
634    * existence has already been distributed / minting is finished.
635    * Tokens which are locked for a claimed space cannot be transferred.
636    */
637   function transferableTokensOf(address _holder) public view returns (uint16) {
638     if (!mintingFinished && !forceTransferEnable) return 0;
639 
640     return uint16(balanceOf(_holder)).sub(locked[_holder]);
641   }
642 
643   /**
644    * @dev Get the number of pixel-locked tokens.
645    */
646   function lockedTokensOf(address _holder) public view returns (uint16) {
647     return locked[_holder];
648   }
649 
650   /**
651    * @dev Get the number of unlocked tokens usable for claiming pixels.
652    */
653   function unlockedTokensOf(address _holder) public view returns (uint256) {
654     return balanceOf(_holder).sub(uint256(locked[_holder]));
655   }
656 
657   // Allow transfer of tokens even if minting is not yet finished.
658   function allowTransfer() onlyOwner public {
659     require(forceTransferEnable == false, 'Transfer already force-allowed.');
660 
661     forceTransferEnable = true;
662     emit AllowTransfer();
663   }
664 }
665 
666 
667 
668 
669 /**
670  * @title MDAPP
671  */
672 contract MDAPP is Ownable, HasNoEther, CanReclaimToken {
673   using SafeMath for uint256;
674   using SafeMath16 for uint16;
675 
676   // The tokens contract.
677   MDAPPToken public token;
678 
679   // The sales contracts address. Only it is allowed to to call the public mint function.
680   address public sale;
681 
682   // When are presale participants allowed to place ads?
683   uint256 public presaleAdStart;
684 
685   // When are all token owners allowed to place ads?
686   uint256 public allAdStart;
687 
688   // Quantity of tokens bought during presale.
689   mapping (address => uint16) presales;
690 
691   // Indicates whether a 10x10px block is claimed or not.
692   bool[80][125] grid;
693 
694   // Struct that represents an ad.
695   struct Ad {
696     address owner;
697     Rect rect;
698   }
699 
700   // Struct describing an rectangle area.
701   struct Rect {
702     uint16 x;
703     uint16 y;
704     uint16 width;
705     uint16 height;
706   }
707 
708   // Don't store ad details on blockchain. Use events as storage as they are significantly cheaper.
709   // ads are stored in an array, the id of an ad is its index in this array.
710   Ad[] ads;
711 
712   // The following holds a list of currently active ads (without holes between the indexes)
713   uint256[] adIds;
714 
715   // Holds the mapping from adID to its index in the above adIds array. If an ad gets released, we know which index to
716   // delete and being filled with the last element instead.
717   mapping (uint256 => uint256) adIdToIndex;
718 
719 
720   /*********************************************************
721    *                                                       *
722    *                       Events                          *
723    *                                                       *
724    *********************************************************/
725 
726   /*
727    * Event for claiming pixel blocks.
728    * @param id ID of the new ad
729    * @param owner Who owns the used tokens
730    * @param x Upper left corner x coordinate
731    * @param y Upper left corner y coordinate
732    * @param width Width of the claimed area
733    * @param height Height of the claimed area
734    */
735   event Claim(uint256 indexed id, address indexed owner, uint16 x, uint16 y, uint16 width, uint16 height);
736 
737   /*
738    * Event for releasing pixel blocks.
739    * @param id ID the fading ad
740    * @param owner Who owns the claimed blocks
741    */
742   event Release(uint256 indexed id, address indexed owner);
743 
744   /*
745    * Event for editing an ad.
746    * @param id ID of the ad
747    * @param owner Who owns the ad
748    * @param link A link
749    * @param title Title of the ad
750    * @param text Description of the ad
751    * @param NSFW Whether the ad is safe for work
752    * @param digest IPFS hash digest
753    * @param hashFunction IPFS hash function
754    * @param size IPFS length of digest
755    * @param storageEngine e.g. ipfs or swrm (swarm)
756    */
757   event EditAd(uint256 indexed id, address indexed owner, string link, string title, string text, string contact, bool NSFW, bytes32 indexed digest, bytes2 hashFunction, uint8 size, bytes4 storageEngine);
758 
759   event ForceNSFW(uint256 indexed id);
760 
761 
762   /*********************************************************
763    *                                                       *
764    *                      Modifiers                        *
765    *                                                       *
766    *********************************************************/
767 
768   modifier coordsValid(uint16 _x, uint16 _y, uint16 _width, uint16 _height) {
769     require((_x + _width - 1) < 125, "Invalid coordinates.");
770     require((_y + _height - 1) < 80, "Invalid coordinates.");
771 
772     _;
773   }
774 
775   modifier onlyAdOwner(uint256 _id) {
776     require(ads[_id].owner == msg.sender, "Access denied.");
777 
778     _;
779   }
780 
781   modifier enoughTokens(uint16 _width, uint16 _height) {
782     require(uint16(token.unlockedTokensOf(msg.sender)) >= _width.mul(_height), "Not enough unlocked tokens available.");
783 
784     _;
785   }
786 
787   modifier claimAllowed(uint16 _width, uint16 _height) {
788     require(_width > 0 &&_width <= 125 && _height > 0 && _height <= 80, "Invalid dimensions.");
789     require(now >= presaleAdStart, "Claim period not yet started.");
790 
791     if (now < allAdStart) {
792       // Sender needs enough presale tokens to claim at this point.
793       uint16 tokens = _width.mul(_height);
794       require(presales[msg.sender] >= tokens, "Not enough unlocked presale tokens available.");
795 
796       presales[msg.sender] = presales[msg.sender].sub(tokens);
797     }
798 
799     _;
800   }
801 
802   modifier onlySale() {
803     require(msg.sender == sale);
804     _;
805   }
806 
807   modifier adExists(uint256 _id) {
808     uint256 index = adIdToIndex[_id];
809     require(adIds[index] == _id, "Ad does not exist.");
810 
811     _;
812   }
813 
814   /*********************************************************
815    *                                                       *
816    *                   Initialization                      *
817    *                                                       *
818    *********************************************************/
819 
820   constructor(uint256 _presaleAdStart, uint256 _allAdStart, address _token) public {
821     require(_presaleAdStart >= now);
822     require(_allAdStart > _presaleAdStart);
823 
824     presaleAdStart = _presaleAdStart;
825     allAdStart = _allAdStart;
826     token = MDAPPToken(_token);
827   }
828 
829   function setMDAPPSale(address _mdappSale) onlyOwner external {
830     require(sale == address(0));
831     sale = _mdappSale;
832   }
833 
834   /*********************************************************
835    *                                                       *
836    *                       Logic                           *
837    *                                                       *
838    *********************************************************/
839 
840   // Proxy function to pass minting from sale contract to token contract.
841   function mint(address _beneficiary, uint256 _tokenAmount, bool isPresale) onlySale external {
842     if (isPresale) {
843       presales[_beneficiary] = presales[_beneficiary].add(uint16(_tokenAmount));
844     }
845     token.mint(_beneficiary, _tokenAmount);
846   }
847 
848   // Proxy function to pass finishMinting() from sale contract to token contract.
849   function finishMinting() onlySale external {
850     token.finishMinting();
851   }
852 
853 
854   // Public function proxy to forward single parameters as a struct.
855   function claim(uint16 _x, uint16 _y, uint16 _width, uint16 _height)
856     claimAllowed(_width, _height)
857     coordsValid(_x, _y, _width, _height)
858     external returns (uint)
859   {
860     Rect memory rect = Rect(_x, _y, _width, _height);
861     return claimShortParams(rect);
862   }
863 
864   // Claims pixels and requires to have the sender enough unlocked tokens.
865   // Has a modifier to take some of the "stack burden" from the proxy function.
866   function claimShortParams(Rect _rect)
867     enoughTokens(_rect.width, _rect.height)
868     internal returns (uint id)
869   {
870     token.lockToken(msg.sender, _rect.width.mul(_rect.height));
871 
872     // Check affected pixelblocks.
873     for (uint16 i = 0; i < _rect.width; i++) {
874       for (uint16 j = 0; j < _rect.height; j++) {
875         uint16 x = _rect.x.add(i);
876         uint16 y = _rect.y.add(j);
877 
878         if (grid[x][y]) {
879           revert("Already claimed.");
880         }
881 
882         // Mark block as claimed.
883         grid[x][y] = true;
884       }
885     }
886 
887     // Create placeholder ad.
888     id = createPlaceholderAd(_rect);
889 
890     emit Claim(id, msg.sender, _rect.x, _rect.y, _rect.width, _rect.height);
891     return id;
892   }
893 
894   // Delete an ad, unclaim pixelblocks and unlock tokens.
895   function release(uint256 _id) adExists(_id) onlyAdOwner(_id) external {
896     uint16 tokens = ads[_id].rect.width.mul(ads[_id].rect.height);
897 
898     // Mark blocks as unclaimed.
899     for (uint16 i = 0; i < ads[_id].rect.width; i++) {
900       for (uint16 j = 0; j < ads[_id].rect.height; j++) {
901         uint16 x = ads[_id].rect.x.add(i);
902         uint16 y = ads[_id].rect.y.add(j);
903 
904         // Mark block as unclaimed.
905         grid[x][y] = false;
906       }
907     }
908 
909     // Delete ad
910     delete ads[_id];
911     // Reorganize index array and map
912     uint256 key = adIdToIndex[_id];
913     // Fill gap with last element of adIds
914     adIds[key] = adIds[adIds.length - 1];
915     // Update adIdToIndex
916     adIdToIndex[adIds[key]] = key;
917     // Decrease length of adIds array by 1
918     adIds.length--;
919 
920     // Unlock tokens
921     if (now < allAdStart) {
922       // The ad must have locked presale tokens.
923       presales[msg.sender] = presales[msg.sender].add(tokens);
924     }
925     token.unlockToken(msg.sender, tokens);
926 
927     emit Release(_id, msg.sender);
928   }
929 
930   // The image must be an URL either of bzz, ipfs or http(s).
931   function editAd(uint _id, string _link, string _title, string _text, string _contact, bool _NSFW, bytes32 _digest, bytes2 _hashFunction, uint8 _size, bytes4 _storageEnginge) adExists(_id) onlyAdOwner(_id) public {
932     emit EditAd(_id, msg.sender, _link, _title, _text, _contact, _NSFW, _digest, _hashFunction, _size,  _storageEnginge);
933   }
934 
935   // Allows contract owner to set the NSFW flag for a given ad.
936   function forceNSFW(uint256 _id) onlyOwner adExists(_id) external {
937     emit ForceNSFW(_id);
938   }
939 
940   // Helper function for claim() to avoid a deep stack.
941   function createPlaceholderAd(Rect _rect) internal returns (uint id) {
942     Ad memory ad = Ad(msg.sender, _rect);
943     id = ads.push(ad) - 1;
944     uint256 key = adIds.push(id) - 1;
945     adIdToIndex[id] = key;
946     return id;
947   }
948 
949   // Returns remaining balance of tokens purchased during presale period qualifying for earlier claims.
950   function presaleBalanceOf(address _holder) public view returns (uint16) {
951     return presales[_holder];
952   }
953 
954   // Returns all currently active adIds.
955   function getAdIds() external view returns (uint256[]) {
956     return adIds;
957   }
958 
959   /*********************************************************
960    *                                                       *
961    *                       Other                           *
962    *                                                       *
963    *********************************************************/
964 
965   // Allow transfer of tokens even if minting is not yet finished.
966   function allowTransfer() onlyOwner external {
967     token.allowTransfer();
968   }
969 }