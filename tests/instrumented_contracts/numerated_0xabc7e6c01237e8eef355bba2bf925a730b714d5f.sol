1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 /**
45  * @title Claimable
46  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
47  * This allows the new owner to accept the transfer.
48  */
49 contract Claimable is Ownable {
50   address public pendingOwner;
51 
52   /**
53    * @dev Modifier throws if called by any account other than the pendingOwner.
54    */
55   modifier onlyPendingOwner() {
56     require(msg.sender == pendingOwner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to set the pendingOwner address.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner public {
65     pendingOwner = newOwner;
66   }
67 
68   /**
69    * @dev Allows the pendingOwner address to finalize the transfer.
70    */
71   function claimOwnership() onlyPendingOwner public {
72     OwnershipTransferred(owner, pendingOwner);
73     owner = pendingOwner;
74     pendingOwner = address(0);
75   }
76 }
77 
78 
79 /**
80  * @title Pausable
81  * @dev Base contract which allows children to implement an emergency stop mechanism.
82  */
83 contract Pausable is Ownable {
84   event Pause();
85   event Unpause();
86 
87   bool public paused = false;
88 
89 
90   /**
91    * @dev Modifier to make a function callable only when the contract is not paused.
92    */
93   modifier whenNotPaused() {
94     require(!paused);
95     _;
96   }
97 
98   /**
99    * @dev Modifier to make a function callable only when the contract is paused.
100    */
101   modifier whenPaused() {
102     require(paused);
103     _;
104   }
105 
106   /**
107    * @dev called by the owner to pause, triggers stopped state
108    */
109   function pause() onlyOwner whenNotPaused public {
110     paused = true;
111     Pause();
112   }
113 
114   /**
115    * @dev called by the owner to unpause, returns to normal state
116    */
117   function unpause() onlyOwner whenPaused public {
118     paused = false;
119     Unpause();
120   }
121 }
122 
123 
124 /**
125  * @title AccessDeploy
126  * @dev Adds grant/revoke functions to the contract.
127  */
128 contract AccessDeploy is Claimable {
129 
130   // Access for deploying heroes.
131   mapping(address => bool) private deployAccess;
132 
133   // Modifier for accessibility to deploy a hero on a location.
134   modifier onlyAccessDeploy {
135     require(msg.sender == owner || deployAccess[msg.sender] == true);
136     _;
137   }
138 
139   // @dev Grant acess to deploy heroes.
140   function grantAccessDeploy(address _address)
141     onlyOwner
142     public
143   {
144     deployAccess[_address] = true;
145   }
146 
147   // @dev Revoke acess to deploy heroes.
148   function revokeAccessDeploy(address _address)
149     onlyOwner
150     public
151   {
152     deployAccess[_address] = false;
153   }
154 
155 }
156 
157 
158 /**
159  * @title AccessDeposit
160  * @dev Adds grant/revoke functions to the contract.
161  */
162 contract AccessDeposit is Claimable {
163 
164   // Access for adding deposit.
165   mapping(address => bool) private depositAccess;
166 
167   // Modifier for accessibility to add deposit.
168   modifier onlyAccessDeposit {
169     require(msg.sender == owner || depositAccess[msg.sender] == true);
170     _;
171   }
172 
173   // @dev Grant acess to deposit heroes.
174   function grantAccessDeposit(address _address)
175     onlyOwner
176     public
177   {
178     depositAccess[_address] = true;
179   }
180 
181   // @dev Revoke acess to deposit heroes.
182   function revokeAccessDeposit(address _address)
183     onlyOwner
184     public
185   {
186     depositAccess[_address] = false;
187   }
188 
189 }
190 
191 
192 /**
193  * @title AccessMint
194  * @dev Adds grant/revoke functions to the contract.
195  */
196 contract AccessMint is Claimable {
197 
198   // Access for minting new tokens.
199   mapping(address => bool) private mintAccess;
200 
201   // Modifier for accessibility to define new hero types.
202   modifier onlyAccessMint {
203     require(msg.sender == owner || mintAccess[msg.sender] == true);
204     _;
205   }
206 
207   // @dev Grant acess to mint heroes.
208   function grantAccessMint(address _address)
209     onlyOwner
210     public
211   {
212     mintAccess[_address] = true;
213   }
214 
215   // @dev Revoke acess to mint heroes.
216   function revokeAccessMint(address _address)
217     onlyOwner
218     public
219   {
220     mintAccess[_address] = false;
221   }
222 
223 }
224 
225 
226 /**
227  * @title ERC721 interface
228  * @dev see https://github.com/ethereum/eips/issues/721
229  */
230 contract ERC721 {
231   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
232   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
233 
234   function balanceOf(address _owner) public view returns (uint256 _balance);
235   function ownerOf(uint256 _tokenId) public view returns (address _owner);
236   function transfer(address _to, uint256 _tokenId) public;
237   function approve(address _to, uint256 _tokenId) public;
238   function takeOwnership(uint256 _tokenId) public;
239 }
240 
241 
242 /**
243  * @title ERC721Token
244  * Generic implementation for the required functionality of the ERC721 standard
245  */
246 contract ERC721Token is ERC721 {
247   using SafeMath for uint256;
248 
249   // Total amount of tokens
250   uint256 private totalTokens;
251 
252   // Mapping from token ID to owner
253   mapping (uint256 => address) private tokenOwner;
254 
255   // Mapping from token ID to approved address
256   mapping (uint256 => address) private tokenApprovals;
257 
258   // Mapping from owner to list of owned token IDs
259   mapping (address => uint256[]) private ownedTokens;
260 
261   // Mapping from token ID to index of the owner tokens list
262   mapping(uint256 => uint256) private ownedTokensIndex;
263 
264   /**
265   * @dev Guarantees msg.sender is owner of the given token
266   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
267   */
268   modifier onlyOwnerOf(uint256 _tokenId) {
269     require(ownerOf(_tokenId) == msg.sender);
270     _;
271   }
272 
273   /**
274   * @dev Gets the total amount of tokens stored by the contract
275   * @return uint256 representing the total amount of tokens
276   */
277   function totalSupply() public view returns (uint256) {
278     return totalTokens;
279   }
280 
281   /**
282   * @dev Gets the balance of the specified address
283   * @param _owner address to query the balance of
284   * @return uint256 representing the amount owned by the passed address
285   */
286   function balanceOf(address _owner) public view returns (uint256) {
287     return ownedTokens[_owner].length;
288   }
289 
290   /**
291   * @dev Gets the list of tokens owned by a given address
292   * @param _owner address to query the tokens of
293   * @return uint256[] representing the list of tokens owned by the passed address
294   */
295   function tokensOf(address _owner) public view returns (uint256[]) {
296     return ownedTokens[_owner];
297   }
298 
299   /**
300   * @dev Gets the owner of the specified token ID
301   * @param _tokenId uint256 ID of the token to query the owner of
302   * @return owner address currently marked as the owner of the given token ID
303   */
304   function ownerOf(uint256 _tokenId) public view returns (address) {
305     address owner = tokenOwner[_tokenId];
306     require(owner != address(0));
307     return owner;
308   }
309 
310   /**
311    * @dev Gets the approved address to take ownership of a given token ID
312    * @param _tokenId uint256 ID of the token to query the approval of
313    * @return address currently approved to take ownership of the given token ID
314    */
315   function approvedFor(uint256 _tokenId) public view returns (address) {
316     return tokenApprovals[_tokenId];
317   }
318 
319   /**
320   * @dev Transfers the ownership of a given token ID to another address
321   * @param _to address to receive the ownership of the given token ID
322   * @param _tokenId uint256 ID of the token to be transferred
323   */
324   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
325     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
326   }
327 
328   /**
329   * @dev Approves another address to claim for the ownership of the given token ID
330   * @param _to address to be approved for the given token ID
331   * @param _tokenId uint256 ID of the token to be approved
332   */
333   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
334     address owner = ownerOf(_tokenId);
335     require(_to != owner);
336     if (approvedFor(_tokenId) != 0 || _to != 0) {
337       tokenApprovals[_tokenId] = _to;
338       Approval(owner, _to, _tokenId);
339     }
340   }
341 
342   /**
343   * @dev Claims the ownership of a given token ID
344   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
345   */
346   function takeOwnership(uint256 _tokenId) public {
347     require(isApprovedFor(msg.sender, _tokenId));
348     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
349   }
350 
351   /**
352   * @dev Mint token function
353   * @param _to The address that will own the minted token
354   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
355   */
356   function _mint(address _to, uint256 _tokenId) internal {
357     require(_to != address(0));
358     addToken(_to, _tokenId);
359     Transfer(0x0, _to, _tokenId);
360   }
361 
362   /**
363   * @dev Burns a specific token
364   * @param _tokenId uint256 ID of the token being burned by the msg.sender
365   */
366   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
367     if (approvedFor(_tokenId) != 0) {
368       clearApproval(msg.sender, _tokenId);
369     }
370     removeToken(msg.sender, _tokenId);
371     Transfer(msg.sender, 0x0, _tokenId);
372   }
373 
374   /**
375    * @dev Tells whether the msg.sender is approved for the given token ID or not
376    * This function is not private so it can be extended in further implementations like the operatable ERC721
377    * @param _owner address of the owner to query the approval of
378    * @param _tokenId uint256 ID of the token to query the approval of
379    * @return bool whether the msg.sender is approved for the given token ID or not
380    */
381   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
382     return approvedFor(_tokenId) == _owner;
383   }
384 
385   /**
386   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
387   * @param _from address which you want to send tokens from
388   * @param _to address which you want to transfer the token to
389   * @param _tokenId uint256 ID of the token to be transferred
390   */
391   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
392     require(_to != address(0));
393     require(_to != ownerOf(_tokenId));
394     require(ownerOf(_tokenId) == _from);
395 
396     clearApproval(_from, _tokenId);
397     removeToken(_from, _tokenId);
398     addToken(_to, _tokenId);
399     Transfer(_from, _to, _tokenId);
400   }
401 
402   /**
403   * @dev Internal function to clear current approval of a given token ID
404   * @param _tokenId uint256 ID of the token to be transferred
405   */
406   function clearApproval(address _owner, uint256 _tokenId) private {
407     require(ownerOf(_tokenId) == _owner);
408     tokenApprovals[_tokenId] = 0;
409     Approval(_owner, 0, _tokenId);
410   }
411 
412   /**
413   * @dev Internal function to add a token ID to the list of a given address
414   * @param _to address representing the new owner of the given token ID
415   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
416   */
417   function addToken(address _to, uint256 _tokenId) private {
418     require(tokenOwner[_tokenId] == address(0));
419     tokenOwner[_tokenId] = _to;
420     uint256 length = balanceOf(_to);
421     ownedTokens[_to].push(_tokenId);
422     ownedTokensIndex[_tokenId] = length;
423     totalTokens = totalTokens.add(1);
424   }
425 
426   /**
427   * @dev Internal function to remove a token ID from the list of a given address
428   * @param _from address representing the previous owner of the given token ID
429   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
430   */
431   function removeToken(address _from, uint256 _tokenId) private {
432     require(ownerOf(_tokenId) == _from);
433 
434     uint256 tokenIndex = ownedTokensIndex[_tokenId];
435     uint256 lastTokenIndex = balanceOf(_from).sub(1);
436     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
437 
438     tokenOwner[_tokenId] = 0;
439     ownedTokens[_from][tokenIndex] = lastToken;
440     ownedTokens[_from][lastTokenIndex] = 0;
441     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
442     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
443     // the lastToken to the first position, and then dropping the element placed in the last position of the list
444 
445     ownedTokens[_from].length--;
446     ownedTokensIndex[_tokenId] = 0;
447     ownedTokensIndex[lastToken] = tokenIndex;
448     totalTokens = totalTokens.sub(1);
449   }
450 }
451 
452 
453 /**
454  * @title ERC20Basic
455  * @dev Simpler version of ERC20 interface
456  * @dev see https://github.com/ethereum/EIPs/issues/179
457  */
458 contract ERC20Basic {
459   function totalSupply() public view returns (uint256);
460   function balanceOf(address who) public view returns (uint256);
461   function transfer(address to, uint256 value) public returns (bool);
462   event Transfer(address indexed from, address indexed to, uint256 value);
463 }
464 
465 
466 /**
467  * @title ERC20 interface
468  * @dev see https://github.com/ethereum/EIPs/issues/20
469  */
470 contract ERC20 is ERC20Basic {
471   function allowance(address owner, address spender) public view returns (uint256);
472   function transferFrom(address from, address to, uint256 value) public returns (bool);
473   function approve(address spender, uint256 value) public returns (bool);
474   event Approval(address indexed owner, address indexed spender, uint256 value);
475 }
476 
477 
478 /**
479  * @title SafeMath
480  * @dev Math operations with safety checks that throw on error
481  */
482 library SafeMath {
483 
484   /**
485   * @dev Multiplies two numbers, throws on overflow.
486   */
487   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
488     if (a == 0) {
489       return 0;
490     }
491     uint256 c = a * b;
492     assert(c / a == b);
493     return c;
494   }
495 
496   /**
497   * @dev Integer division of two numbers, truncating the quotient.
498   */
499   function div(uint256 a, uint256 b) internal pure returns (uint256) {
500     // assert(b > 0); // Solidity automatically throws when dividing by 0
501     uint256 c = a / b;
502     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
503     return c;
504   }
505 
506   /**
507   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
508   */
509   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
510     assert(b <= a);
511     return a - b;
512   }
513 
514   /**
515   * @dev Adds two numbers, throws on overflow.
516   */
517   function add(uint256 a, uint256 b) internal pure returns (uint256) {
518     uint256 c = a + b;
519     assert(c >= a);
520     return c;
521   }
522 }
523 
524 
525 /**
526  * @title Basic token
527  * @dev Basic version of StandardToken, with no allowances.
528  */
529 contract BasicToken is ERC20Basic {
530   using SafeMath for uint256;
531 
532   mapping(address => uint256) balances;
533 
534   uint256 totalSupply_;
535 
536   /**
537   * @dev total number of tokens in existence
538   */
539   function totalSupply() public view returns (uint256) {
540     return totalSupply_;
541   }
542 
543   /**
544   * @dev transfer token for a specified address
545   * @param _to The address to transfer to.
546   * @param _value The amount to be transferred.
547   */
548   function transfer(address _to, uint256 _value) public returns (bool) {
549     require(_to != address(0));
550     require(_value <= balances[msg.sender]);
551 
552     // SafeMath.sub will throw if there is not enough balance.
553     balances[msg.sender] = balances[msg.sender].sub(_value);
554     balances[_to] = balances[_to].add(_value);
555     Transfer(msg.sender, _to, _value);
556     return true;
557   }
558 
559   /**
560   * @dev Gets the balance of the specified address.
561   * @param _owner The address to query the the balance of.
562   * @return An uint256 representing the amount owned by the passed address.
563   */
564   function balanceOf(address _owner) public view returns (uint256 balance) {
565     return balances[_owner];
566   }
567 
568 }
569 
570 
571 /**
572  * @title Standard ERC20 token
573  *
574  * @dev Implementation of the basic standard token.
575  * @dev https://github.com/ethereum/EIPs/issues/20
576  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
577  */
578 contract StandardToken is ERC20, BasicToken {
579 
580   mapping (address => mapping (address => uint256)) internal allowed;
581 
582 
583   /**
584    * @dev Transfer tokens from one address to another
585    * @param _from address The address which you want to send tokens from
586    * @param _to address The address which you want to transfer to
587    * @param _value uint256 the amount of tokens to be transferred
588    */
589   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
590     require(_to != address(0));
591     require(_value <= balances[_from]);
592     require(_value <= allowed[_from][msg.sender]);
593 
594     balances[_from] = balances[_from].sub(_value);
595     balances[_to] = balances[_to].add(_value);
596     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
597     Transfer(_from, _to, _value);
598     return true;
599   }
600 
601   /**
602    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
603    *
604    * Beware that changing an allowance with this method brings the risk that someone may use both the old
605    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
606    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
607    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
608    * @param _spender The address which will spend the funds.
609    * @param _value The amount of tokens to be spent.
610    */
611   function approve(address _spender, uint256 _value) public returns (bool) {
612     allowed[msg.sender][_spender] = _value;
613     Approval(msg.sender, _spender, _value);
614     return true;
615   }
616 
617   /**
618    * @dev Function to check the amount of tokens that an owner allowed to a spender.
619    * @param _owner address The address which owns the funds.
620    * @param _spender address The address which will spend the funds.
621    * @return A uint256 specifying the amount of tokens still available for the spender.
622    */
623   function allowance(address _owner, address _spender) public view returns (uint256) {
624     return allowed[_owner][_spender];
625   }
626 
627   /**
628    * @dev Increase the amount of tokens that an owner allowed to a spender.
629    *
630    * approve should be called when allowed[_spender] == 0. To increment
631    * allowed value is better to use this function to avoid 2 calls (and wait until
632    * the first transaction is mined)
633    * From MonolithDAO Token.sol
634    * @param _spender The address which will spend the funds.
635    * @param _addedValue The amount of tokens to increase the allowance by.
636    */
637   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
638     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
639     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
640     return true;
641   }
642 
643   /**
644    * @dev Decrease the amount of tokens that an owner allowed to a spender.
645    *
646    * approve should be called when allowed[_spender] == 0. To decrement
647    * allowed value is better to use this function to avoid 2 calls (and wait until
648    * the first transaction is mined)
649    * From MonolithDAO Token.sol
650    * @param _spender The address which will spend the funds.
651    * @param _subtractedValue The amount of tokens to decrease the allowance by.
652    */
653   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
654     uint oldValue = allowed[msg.sender][_spender];
655     if (_subtractedValue > oldValue) {
656       allowed[msg.sender][_spender] = 0;
657     } else {
658       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
659     }
660     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
661     return true;
662   }
663 
664 }
665 
666 
667 /**
668  * @title Gold
669  * @dev ERC20 Token that can be minted.
670  */
671 contract Gold is StandardToken, Claimable, AccessMint {
672 
673   string public constant name = "Gold";
674   string public constant symbol = "G";
675   uint8 public constant decimals = 18;
676 
677   // Event that is fired when minted.
678   event Mint(
679     address indexed _to,
680     uint256 indexed _tokenId
681   );
682 
683   // @dev Mint tokens with _amount to the address.
684   function mint(address _to, uint256 _amount) 
685     onlyAccessMint
686     public 
687     returns (bool) 
688   {
689     totalSupply_ = totalSupply_.add(_amount);
690     balances[_to] = balances[_to].add(_amount);
691     Mint(_to, _amount);
692     Transfer(address(0), _to, _amount);
693     return true;
694   }
695 
696 }
697 
698 
699 /**
700  * @title CryptoSagaHero
701  * @dev The token contract for the hero.
702  *  Also a superset of the ERC721 standard that allows for the minting
703  *  of the non-fungible tokens.
704  */
705 contract CryptoSagaHero is ERC721Token, Claimable, Pausable, AccessMint, AccessDeploy, AccessDeposit {
706 
707   string public constant name = "CryptoSaga Hero";
708   string public constant symbol = "HERO";
709   
710   struct HeroClass {
711     // ex) Soldier, Knight, Fighter...
712     string className;
713     // 0: Common, 1: Uncommon, 2: Rare, 3: Heroic, 4: Legendary.
714     uint8 classRank;
715     // 0: Human, 1: Celestial, 2: Demon, 3: Elf, 4: Dark Elf, 5: Yogoe, 6: Furry, 7: Dragonborn, 8: Undead, 9: Goblin, 10: Troll, 11: Slime, and more to come.
716     uint8 classRace;
717     // How old is this hero class? 
718     uint32 classAge;
719     // 0: Fighter, 1: Rogue, 2: Mage.
720     uint8 classType;
721 
722     // Possible max level of this class.
723     uint32 maxLevel; 
724     // 0: Water, 1: Fire, 2: Nature, 3: Light, 4: Darkness.
725     uint8 aura; 
726 
727     // Base stats of this hero type. 
728     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
729     uint32[5] baseStats;
730     // Minimum IVs for stats. 
731     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
732     uint32[5] minIVForStats;
733     // Maximum IVs for stats.
734     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
735     uint32[5] maxIVForStats;
736     
737     // Number of currently instanced heroes.
738     uint32 currentNumberOfInstancedHeroes;
739   }
740     
741   struct HeroInstance {
742     // What is this hero's type? ex) John, Sally, Mark...
743     uint32 heroClassId;
744     
745     // Individual hero's name.
746     string heroName;
747     
748     // Current level of this hero.
749     uint32 currentLevel;
750     // Current exp of this hero.
751     uint32 currentExp;
752 
753     // Where has this hero been deployed? (0: Never depolyed ever.) ex) Dungeon Floor #1, Arena #5...
754     uint32 lastLocationId;
755     // When a hero is deployed, it takes time for the hero to return to the base. This is in Unix epoch.
756     uint256 availableAt;
757 
758     // Current stats of this hero. 
759     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
760     uint32[5] currentStats;
761     // The individual value for this hero's stats. 
762     // This will affect the current stats of heroes.
763     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
764     uint32[5] ivForStats;
765   }
766 
767   // Required exp for level up will increase when heroes level up.
768   // This defines how the value will increase.
769   uint32 public requiredExpIncreaseFactor = 100;
770 
771   // Required Gold for level up will increase when heroes level up.
772   // This defines how the value will increase.
773   uint256 public requiredGoldIncreaseFactor = 1000000000000000000;
774 
775   // Existing hero classes.
776   mapping(uint32 => HeroClass) public heroClasses;
777   // The number of hero classes ever defined.
778   uint32 public numberOfHeroClasses;
779 
780   // Existing hero instances.
781   // The key is _tokenId.
782   mapping(uint256 => HeroInstance) public tokenIdToHeroInstance;
783   // The number of tokens ever minted. This works as the serial number.
784   uint256 public numberOfTokenIds;
785 
786   // Gold contract.
787   Gold public goldContract;
788 
789   // Deposit of players (in Gold).
790   mapping(address => uint256) public addressToGoldDeposit;
791 
792   // Random seed.
793   uint32 private seed = 0;
794 
795   // Event that is fired when a hero type defined.
796   event DefineType(
797     address indexed _by,
798     uint32 indexed _typeId,
799     string _className
800   );
801 
802   // Event that is fired when a hero is upgraded.
803   event LevelUp(
804     address indexed _by,
805     uint256 indexed _tokenId,
806     uint32 _newLevel
807   );
808 
809   // Event that is fired when a hero is deployed.
810   event Deploy(
811     address indexed _by,
812     uint256 indexed _tokenId,
813     uint32 _locationId,
814     uint256 _duration
815   );
816 
817   // @dev Get the class's entire infomation.
818   function getClassInfo(uint32 _classId)
819     external view
820     returns (string className, uint8 classRank, uint8 classRace, uint32 classAge, uint8 classType, uint32 maxLevel, uint8 aura, uint32[5] baseStats, uint32[5] minIVs, uint32[5] maxIVs) 
821   {
822     var _cl = heroClasses[_classId];
823     return (_cl.className, _cl.classRank, _cl.classRace, _cl.classAge, _cl.classType, _cl.maxLevel, _cl.aura, _cl.baseStats, _cl.minIVForStats, _cl.maxIVForStats);
824   }
825 
826   // @dev Get the class's name.
827   function getClassName(uint32 _classId)
828     external view
829     returns (string)
830   {
831     return heroClasses[_classId].className;
832   }
833 
834   // @dev Get the class's rank.
835   function getClassRank(uint32 _classId)
836     external view
837     returns (uint8)
838   {
839     return heroClasses[_classId].classRank;
840   }
841 
842   // @dev Get the heroes ever minted for the class.
843   function getClassMintCount(uint32 _classId)
844     external view
845     returns (uint32)
846   {
847     return heroClasses[_classId].currentNumberOfInstancedHeroes;
848   }
849 
850   // @dev Get the hero's entire infomation.
851   function getHeroInfo(uint256 _tokenId)
852     external view
853     returns (uint32 classId, string heroName, uint32 currentLevel, uint32 currentExp, uint32 lastLocationId, uint256 availableAt, uint32[5] currentStats, uint32[5] ivs, uint32 bp)
854   {
855     HeroInstance memory _h = tokenIdToHeroInstance[_tokenId];
856     var _bp = _h.currentStats[0] + _h.currentStats[1] + _h.currentStats[2] + _h.currentStats[3] + _h.currentStats[4];
857     return (_h.heroClassId, _h.heroName, _h.currentLevel, _h.currentExp, _h.lastLocationId, _h.availableAt, _h.currentStats, _h.ivForStats, _bp);
858   }
859 
860   // @dev Get the hero's class id.
861   function getHeroClassId(uint256 _tokenId)
862     external view
863     returns (uint32)
864   {
865     return tokenIdToHeroInstance[_tokenId].heroClassId;
866   }
867 
868   // @dev Get the hero's name.
869   function getHeroName(uint256 _tokenId)
870     external view
871     returns (string)
872   {
873     return tokenIdToHeroInstance[_tokenId].heroName;
874   }
875 
876   // @dev Get the hero's level.
877   function getHeroLevel(uint256 _tokenId)
878     external view
879     returns (uint32)
880   {
881     return tokenIdToHeroInstance[_tokenId].currentLevel;
882   }
883   
884   // @dev Get the hero's location.
885   function getHeroLocation(uint256 _tokenId)
886     external view
887     returns (uint32)
888   {
889     return tokenIdToHeroInstance[_tokenId].lastLocationId;
890   }
891 
892   // @dev Get the time when the hero become available.
893   function getHeroAvailableAt(uint256 _tokenId)
894     external view
895     returns (uint256)
896   {
897     return tokenIdToHeroInstance[_tokenId].availableAt;
898   }
899 
900   // @dev Get the hero's BP.
901   function getHeroBP(uint256 _tokenId)
902     public view
903     returns (uint32)
904   {
905     var _tmp = tokenIdToHeroInstance[_tokenId].currentStats;
906     return (_tmp[0] + _tmp[1] + _tmp[2] + _tmp[3] + _tmp[4]);
907   }
908 
909   // @dev Get the hero's required gold for level up.
910   function getHeroRequiredGoldForLevelUp(uint256 _tokenId)
911     public view
912     returns (uint256)
913   {
914     return (uint256(2) ** (tokenIdToHeroInstance[_tokenId].currentLevel / 10)) * requiredGoldIncreaseFactor;
915   }
916 
917   // @dev Get the hero's required exp for level up.
918   function getHeroRequiredExpForLevelUp(uint256 _tokenId)
919     public view
920     returns (uint32)
921   {
922     return ((tokenIdToHeroInstance[_tokenId].currentLevel + 2) * requiredExpIncreaseFactor);
923   }
924 
925   // @dev Get the deposit of gold of the player.
926   function getGoldDepositOfAddress(address _address)
927     external view
928     returns (uint256)
929   {
930     return addressToGoldDeposit[_address];
931   }
932 
933   // @dev Get the token id of the player's #th token.
934   function getTokenIdOfAddressAndIndex(address _address, uint256 _index)
935     external view
936     returns (uint256)
937   {
938     return tokensOf(_address)[_index];
939   }
940 
941   // @dev Get the total BP of the player.
942   function getTotalBPOfAddress(address _address)
943     external view
944     returns (uint32)
945   {
946     var _tokens = tokensOf(_address);
947     uint32 _totalBP = 0;
948     for (uint256 i = 0; i < _tokens.length; i ++) {
949       _totalBP += getHeroBP(_tokens[i]);
950     }
951     return _totalBP;
952   }
953 
954   // @dev Set the hero's name.
955   function setHeroName(uint256 _tokenId, string _name)
956     onlyOwnerOf(_tokenId)
957     public
958   {
959     tokenIdToHeroInstance[_tokenId].heroName = _name;
960   }
961 
962   // @dev Set the address of the contract that represents ERC20 Gold.
963   function setGoldContract(address _contractAddress)
964     onlyOwner
965     public
966   {
967     goldContract = Gold(_contractAddress);
968   }
969 
970   // @dev Set the required golds to level up a hero.
971   function setRequiredExpIncreaseFactor(uint32 _value)
972     onlyOwner
973     public
974   {
975     requiredExpIncreaseFactor = _value;
976   }
977 
978   // @dev Set the required golds to level up a hero.
979   function setRequiredGoldIncreaseFactor(uint256 _value)
980     onlyOwner
981     public
982   {
983     requiredGoldIncreaseFactor = _value;
984   }
985 
986   // @dev Contructor.
987   function CryptoSagaHero(address _goldAddress)
988     public
989   {
990     require(_goldAddress != address(0));
991 
992     // Assign Gold contract.
993     setGoldContract(_goldAddress);
994 
995     // Initial heroes.
996     // Name, Rank, Race, Age, Type, Max Level, Aura, Stats.
997     defineType("Archangel", 4, 1, 13540, 0, 99, 3, [uint32(74), 75, 57, 99, 95], [uint32(8), 6, 8, 5, 5], [uint32(8), 10, 10, 6, 6]);
998     defineType("Shadowalker", 3, 4, 134, 1, 75, 4, [uint32(45), 35, 60, 80, 40], [uint32(3), 2, 10, 4, 5], [uint32(5), 5, 10, 7, 5]);
999     defineType("Pyromancer", 2, 0, 14, 2, 50, 1, [uint32(50), 28, 17, 40, 35], [uint32(5), 3, 2, 3, 3], [uint32(8), 4, 3, 4, 5]);
1000     defineType("Magician", 1, 3, 224, 2, 30, 0, [uint32(35), 15, 25, 25, 30], [uint32(3), 1, 2, 2, 2], [uint32(5), 2, 3, 3, 3]);
1001     defineType("Farmer", 0, 0, 59, 0, 15, 2, [uint32(10), 22, 8, 15, 25], [uint32(1), 2, 1, 1, 2], [uint32(1), 3, 1, 2, 3]);
1002   }
1003 
1004   // @dev Define a new hero type (class).
1005   function defineType(string _className, uint8 _classRank, uint8 _classRace, uint32 _classAge, uint8 _classType, uint32 _maxLevel, uint8 _aura, uint32[5] _baseStats, uint32[5] _minIVForStats, uint32[5] _maxIVForStats)
1006     onlyOwner
1007     public
1008   {
1009     require(_classRank < 5);
1010     require(_classType < 3);
1011     require(_aura < 5);
1012     require(_minIVForStats[0] <= _maxIVForStats[0] && _minIVForStats[1] <= _maxIVForStats[1] && _minIVForStats[2] <= _maxIVForStats[2] && _minIVForStats[3] <= _maxIVForStats[3] && _minIVForStats[4] <= _maxIVForStats[4]);
1013 
1014     HeroClass memory _heroType = HeroClass({
1015       className: _className,
1016       classRank: _classRank,
1017       classRace: _classRace,
1018       classAge: _classAge,
1019       classType: _classType,
1020       maxLevel: _maxLevel,
1021       aura: _aura,
1022       baseStats: _baseStats,
1023       minIVForStats: _minIVForStats,
1024       maxIVForStats: _maxIVForStats,
1025       currentNumberOfInstancedHeroes: 0
1026     });
1027 
1028     // Save the hero class.
1029     heroClasses[numberOfHeroClasses] = _heroType;
1030 
1031     // Fire event.
1032     DefineType(msg.sender, numberOfHeroClasses, _heroType.className);
1033 
1034     // Increment number of hero classes.
1035     numberOfHeroClasses ++;
1036 
1037   }
1038 
1039   // @dev Mint a new hero, with _heroClassId.
1040   function mint(address _owner, uint32 _heroClassId)
1041     onlyAccessMint
1042     public
1043     returns (uint256)
1044   {
1045     require(_owner != address(0));
1046     require(_heroClassId < numberOfHeroClasses);
1047 
1048     // The information of the hero's class.
1049     var _heroClassInfo = heroClasses[_heroClassId];
1050 
1051     // Mint ERC721 token.
1052     _mint(_owner, numberOfTokenIds);
1053 
1054     // Build random IVs for this hero instance.
1055     uint32[5] memory _ivForStats;
1056     uint32[5] memory _initialStats;
1057     for (uint8 i = 0; i < 5; i++) {
1058       _ivForStats[i] = (random(_heroClassInfo.maxIVForStats[i] + 1, _heroClassInfo.minIVForStats[i]));
1059       _initialStats[i] = _heroClassInfo.baseStats[i] + _ivForStats[i];
1060     }
1061 
1062     // Temporary hero instance.
1063     HeroInstance memory _heroInstance = HeroInstance({
1064       heroClassId: _heroClassId,
1065       heroName: "",
1066       currentLevel: 1,
1067       currentExp: 0,
1068       lastLocationId: 0,
1069       availableAt: now,
1070       currentStats: _initialStats,
1071       ivForStats: _ivForStats
1072     });
1073 
1074     // Save the hero instance.
1075     tokenIdToHeroInstance[numberOfTokenIds] = _heroInstance;
1076 
1077     // Increment number of token ids.
1078     // This will only increment when new token is minted, and will never be decemented when the token is burned.
1079     numberOfTokenIds ++;
1080 
1081      // Increment instanced number of heroes.
1082     _heroClassInfo.currentNumberOfInstancedHeroes ++;
1083 
1084     return numberOfTokenIds - 1;
1085   }
1086 
1087   // @dev Set where the heroes are deployed, and when they will return.
1088   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1089   function deploy(uint256 _tokenId, uint32 _locationId, uint256 _duration)
1090     onlyAccessDeploy
1091     public
1092     returns (bool)
1093   {
1094     // The hero should be possessed by anybody.
1095     require(ownerOf(_tokenId) != address(0));
1096 
1097     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1098 
1099     // The character should be avaiable. 
1100     require(_heroInstance.availableAt <= now);
1101 
1102     _heroInstance.lastLocationId = _locationId;
1103     _heroInstance.availableAt = now + _duration;
1104 
1105     // As the hero has been deployed to another place, fire event.
1106     Deploy(msg.sender, _tokenId, _locationId, _duration);
1107   }
1108 
1109   // @dev Add exp.
1110   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1111   function addExp(uint256 _tokenId, uint32 _exp)
1112     onlyAccessDeploy
1113     public
1114     returns (bool)
1115   {
1116     // The hero should be possessed by anybody.
1117     require(ownerOf(_tokenId) != address(0));
1118 
1119     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1120 
1121     var _newExp = _heroInstance.currentExp + _exp;
1122 
1123     // Sanity check to ensure we don't overflow.
1124     require(_newExp == uint256(uint128(_newExp)));
1125 
1126     _heroInstance.currentExp += _newExp;
1127 
1128   }
1129 
1130   // @dev Add deposit.
1131   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1132   function addDeposit(address _to, uint256 _amount)
1133     onlyAccessDeposit
1134     public
1135   {
1136     // Increment deposit.
1137     addressToGoldDeposit[_to] += _amount;
1138   }
1139 
1140   // @dev Level up the hero with _tokenId.
1141   //  This function is called by the owner of the hero.
1142   function levelUp(uint256 _tokenId)
1143     onlyOwnerOf(_tokenId) whenNotPaused
1144     public
1145   {
1146 
1147     // Hero instance.
1148     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1149 
1150     // The character should be avaiable. (Should have already returned from the dungeons, arenas, etc.)
1151     require(_heroInstance.availableAt <= now);
1152 
1153     // The information of the hero's class.
1154     var _heroClassInfo = heroClasses[_heroInstance.heroClassId];
1155 
1156     // Hero shouldn't level up exceed its max level.
1157     require(_heroInstance.currentLevel < _heroClassInfo.maxLevel);
1158 
1159     // Required Exp.
1160     var requiredExp = getHeroRequiredExpForLevelUp(_tokenId);
1161 
1162     // Need to have enough exp.
1163     require(_heroInstance.currentExp >= requiredExp);
1164 
1165     // Required Gold.
1166     var requiredGold = getHeroRequiredGoldForLevelUp(_tokenId);
1167 
1168     // Owner of token.
1169     var _ownerOfToken = ownerOf(_tokenId);
1170 
1171     // Need to have enough Gold balance.
1172     require(addressToGoldDeposit[_ownerOfToken] >= requiredGold);
1173 
1174     // Increase Level.
1175     _heroInstance.currentLevel += 1;
1176 
1177     // Increase Stats.
1178     for (uint8 i = 0; i < 5; i++) {
1179       _heroInstance.currentStats[i] = _heroClassInfo.baseStats[i] + (_heroInstance.currentLevel - 1) * _heroInstance.ivForStats[i];
1180     }
1181     
1182     // Deduct exp.
1183     _heroInstance.currentExp -= requiredExp;
1184 
1185     // Deduct gold.
1186     addressToGoldDeposit[_ownerOfToken] -= requiredGold;
1187 
1188     // Fire event.
1189     LevelUp(msg.sender, _tokenId, _heroInstance.currentLevel);
1190   }
1191 
1192   // @dev Transfer deposit (with the allowance pattern.)
1193   function transferDeposit(uint256 _amount)
1194     whenNotPaused
1195     public
1196   {
1197     require(goldContract.allowance(msg.sender, this) >= _amount);
1198 
1199     // Send msg.sender's Gold to this contract.
1200     if (goldContract.transferFrom(msg.sender, this, _amount)) {
1201        // Increment deposit.
1202       addressToGoldDeposit[msg.sender] += _amount;
1203     }
1204   }
1205 
1206   // @dev Withdraw deposit.
1207   function withdrawDeposit(uint256 _amount)
1208     public
1209   {
1210     require(addressToGoldDeposit[msg.sender] >= _amount);
1211 
1212     // Send deposit of Golds to msg.sender. (Rather minting...)
1213     if (goldContract.transfer(msg.sender, _amount)) {
1214       // Decrement deposit.
1215       addressToGoldDeposit[msg.sender] -= _amount;
1216     }
1217   }
1218 
1219   // @dev return a pseudo random number between lower and upper bounds
1220   function random(uint32 _upper, uint32 _lower)
1221     private
1222     returns (uint32)
1223   {
1224     require(_upper > _lower);
1225 
1226     seed = uint32(keccak256(keccak256(block.blockhash(block.number), seed), now));
1227     return seed % (_upper - _lower) + _lower;
1228   }
1229 
1230 }