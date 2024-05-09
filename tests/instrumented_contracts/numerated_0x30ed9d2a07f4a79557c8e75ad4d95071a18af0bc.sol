1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /**
46  * @title Claimable
47  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
48  * This allows the new owner to accept the transfer.
49  */
50 contract Claimable is Ownable {
51   address public pendingOwner;
52 
53   /**
54    * @dev Modifier throws if called by any account other than the pendingOwner.
55    */
56   modifier onlyPendingOwner() {
57     require(msg.sender == pendingOwner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to set the pendingOwner address.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner public {
66     pendingOwner = newOwner;
67   }
68 
69   /**
70    * @dev Allows the pendingOwner address to finalize the transfer.
71    */
72   function claimOwnership() onlyPendingOwner public {
73     OwnershipTransferred(owner, pendingOwner);
74     owner = pendingOwner;
75     pendingOwner = address(0);
76   }
77 }
78 
79 
80 /**
81  * @title Pausable
82  * @dev Base contract which allows children to implement an emergency stop mechanism.
83  */
84 contract Pausable is Ownable {
85   event Pause();
86   event Unpause();
87 
88   bool public paused = false;
89 
90 
91   /**
92    * @dev Modifier to make a function callable only when the contract is not paused.
93    */
94   modifier whenNotPaused() {
95     require(!paused);
96     _;
97   }
98 
99   /**
100    * @dev Modifier to make a function callable only when the contract is paused.
101    */
102   modifier whenPaused() {
103     require(paused);
104     _;
105   }
106 
107   /**
108    * @dev called by the owner to pause, triggers stopped state
109    */
110   function pause() onlyOwner whenNotPaused public {
111     paused = true;
112     Pause();
113   }
114 
115   /**
116    * @dev called by the owner to unpause, returns to normal state
117    */
118   function unpause() onlyOwner whenPaused public {
119     paused = false;
120     Unpause();
121   }
122 }
123 
124 
125 /**
126  * @title AccessDeploy
127  * @dev Adds grant/revoke functions to the contract.
128  */
129 contract AccessDeploy is Claimable {
130 
131   // Access for deploying heroes.
132   mapping(address => bool) private deployAccess;
133 
134   // Modifier for accessibility to deploy a hero on a location.
135   modifier onlyAccessDeploy {
136     require(msg.sender == owner || deployAccess[msg.sender] == true);
137     _;
138   }
139 
140   // @dev Grant acess to deploy heroes.
141   function grantAccessDeploy(address _address)
142     onlyOwner
143     public
144   {
145     deployAccess[_address] = true;
146   }
147 
148   // @dev Revoke acess to deploy heroes.
149   function revokeAccessDeploy(address _address)
150     onlyOwner
151     public
152   {
153     deployAccess[_address] = false;
154   }
155 
156 }
157 
158 
159 /**
160  * @title AccessDeposit
161  * @dev Adds grant/revoke functions to the contract.
162  */
163 contract AccessDeposit is Claimable {
164 
165   // Access for adding deposit.
166   mapping(address => bool) private depositAccess;
167 
168   // Modifier for accessibility to add deposit.
169   modifier onlyAccessDeposit {
170     require(msg.sender == owner || depositAccess[msg.sender] == true);
171     _;
172   }
173 
174   // @dev Grant acess to deposit heroes.
175   function grantAccessDeposit(address _address)
176     onlyOwner
177     public
178   {
179     depositAccess[_address] = true;
180   }
181 
182   // @dev Revoke acess to deposit heroes.
183   function revokeAccessDeposit(address _address)
184     onlyOwner
185     public
186   {
187     depositAccess[_address] = false;
188   }
189 
190 }
191 
192 
193 /**
194  * @title AccessMint
195  * @dev Adds grant/revoke functions to the contract.
196  */
197 contract AccessMint is Claimable {
198 
199   // Access for minting new tokens.
200   mapping(address => bool) private mintAccess;
201 
202   // Modifier for accessibility to define new hero types.
203   modifier onlyAccessMint {
204     require(msg.sender == owner || mintAccess[msg.sender] == true);
205     _;
206   }
207 
208   // @dev Grant acess to mint heroes.
209   function grantAccessMint(address _address)
210     onlyOwner
211     public
212   {
213     mintAccess[_address] = true;
214   }
215 
216   // @dev Revoke acess to mint heroes.
217   function revokeAccessMint(address _address)
218     onlyOwner
219     public
220   {
221     mintAccess[_address] = false;
222   }
223 
224 }
225 
226 
227 /**
228  * @title ERC721 interface
229  * @dev see https://github.com/ethereum/eips/issues/721
230  */
231 contract ERC721 {
232   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
233   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
234 
235   function balanceOf(address _owner) public view returns (uint256 _balance);
236   function ownerOf(uint256 _tokenId) public view returns (address _owner);
237   function transfer(address _to, uint256 _tokenId) public;
238   function approve(address _to, uint256 _tokenId) public;
239   function takeOwnership(uint256 _tokenId) public;
240 }
241 
242 
243 /**
244  * @title ERC721Token
245  * Generic implementation for the required functionality of the ERC721 standard
246  */
247 contract ERC721Token is ERC721 {
248   using SafeMath for uint256;
249 
250   // Total amount of tokens
251   uint256 private totalTokens;
252 
253   // Mapping from token ID to owner
254   mapping (uint256 => address) private tokenOwner;
255 
256   // Mapping from token ID to approved address
257   mapping (uint256 => address) private tokenApprovals;
258 
259   // Mapping from owner to list of owned token IDs
260   mapping (address => uint256[]) private ownedTokens;
261 
262   // Mapping from token ID to index of the owner tokens list
263   mapping(uint256 => uint256) private ownedTokensIndex;
264 
265   /**
266   * @dev Guarantees msg.sender is owner of the given token
267   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
268   */
269   modifier onlyOwnerOf(uint256 _tokenId) {
270     require(ownerOf(_tokenId) == msg.sender);
271     _;
272   }
273 
274   /**
275   * @dev Gets the total amount of tokens stored by the contract
276   * @return uint256 representing the total amount of tokens
277   */
278   function totalSupply() public view returns (uint256) {
279     return totalTokens;
280   }
281 
282   /**
283   * @dev Gets the balance of the specified address
284   * @param _owner address to query the balance of
285   * @return uint256 representing the amount owned by the passed address
286   */
287   function balanceOf(address _owner) public view returns (uint256) {
288     return ownedTokens[_owner].length;
289   }
290 
291   /**
292   * @dev Gets the list of tokens owned by a given address
293   * @param _owner address to query the tokens of
294   * @return uint256[] representing the list of tokens owned by the passed address
295   */
296   function tokensOf(address _owner) public view returns (uint256[]) {
297     return ownedTokens[_owner];
298   }
299 
300   /**
301   * @dev Gets the owner of the specified token ID
302   * @param _tokenId uint256 ID of the token to query the owner of
303   * @return owner address currently marked as the owner of the given token ID
304   */
305   function ownerOf(uint256 _tokenId) public view returns (address) {
306     address owner = tokenOwner[_tokenId];
307     require(owner != address(0));
308     return owner;
309   }
310 
311   /**
312    * @dev Gets the approved address to take ownership of a given token ID
313    * @param _tokenId uint256 ID of the token to query the approval of
314    * @return address currently approved to take ownership of the given token ID
315    */
316   function approvedFor(uint256 _tokenId) public view returns (address) {
317     return tokenApprovals[_tokenId];
318   }
319 
320   /**
321   * @dev Transfers the ownership of a given token ID to another address
322   * @param _to address to receive the ownership of the given token ID
323   * @param _tokenId uint256 ID of the token to be transferred
324   */
325   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
326     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
327   }
328 
329   /**
330   * @dev Approves another address to claim for the ownership of the given token ID
331   * @param _to address to be approved for the given token ID
332   * @param _tokenId uint256 ID of the token to be approved
333   */
334   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
335     address owner = ownerOf(_tokenId);
336     require(_to != owner);
337     if (approvedFor(_tokenId) != 0 || _to != 0) {
338       tokenApprovals[_tokenId] = _to;
339       Approval(owner, _to, _tokenId);
340     }
341   }
342 
343   /**
344   * @dev Claims the ownership of a given token ID
345   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
346   */
347   function takeOwnership(uint256 _tokenId) public {
348     require(isApprovedFor(msg.sender, _tokenId));
349     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
350   }
351 
352   /**
353   * @dev Mint token function
354   * @param _to The address that will own the minted token
355   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
356   */
357   function _mint(address _to, uint256 _tokenId) internal {
358     require(_to != address(0));
359     addToken(_to, _tokenId);
360     Transfer(0x0, _to, _tokenId);
361   }
362 
363   /**
364   * @dev Burns a specific token
365   * @param _tokenId uint256 ID of the token being burned by the msg.sender
366   */
367   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
368     if (approvedFor(_tokenId) != 0) {
369       clearApproval(msg.sender, _tokenId);
370     }
371     removeToken(msg.sender, _tokenId);
372     Transfer(msg.sender, 0x0, _tokenId);
373   }
374 
375   /**
376    * @dev Tells whether the msg.sender is approved for the given token ID or not
377    * This function is not private so it can be extended in further implementations like the operatable ERC721
378    * @param _owner address of the owner to query the approval of
379    * @param _tokenId uint256 ID of the token to query the approval of
380    * @return bool whether the msg.sender is approved for the given token ID or not
381    */
382   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
383     return approvedFor(_tokenId) == _owner;
384   }
385 
386   /**
387   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
388   * @param _from address which you want to send tokens from
389   * @param _to address which you want to transfer the token to
390   * @param _tokenId uint256 ID of the token to be transferred
391   */
392   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
393     require(_to != address(0));
394     require(_to != ownerOf(_tokenId));
395     require(ownerOf(_tokenId) == _from);
396 
397     clearApproval(_from, _tokenId);
398     removeToken(_from, _tokenId);
399     addToken(_to, _tokenId);
400     Transfer(_from, _to, _tokenId);
401   }
402 
403   /**
404   * @dev Internal function to clear current approval of a given token ID
405   * @param _tokenId uint256 ID of the token to be transferred
406   */
407   function clearApproval(address _owner, uint256 _tokenId) private {
408     require(ownerOf(_tokenId) == _owner);
409     tokenApprovals[_tokenId] = 0;
410     Approval(_owner, 0, _tokenId);
411   }
412 
413   /**
414   * @dev Internal function to add a token ID to the list of a given address
415   * @param _to address representing the new owner of the given token ID
416   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
417   */
418   function addToken(address _to, uint256 _tokenId) private {
419     require(tokenOwner[_tokenId] == address(0));
420     tokenOwner[_tokenId] = _to;
421     uint256 length = balanceOf(_to);
422     ownedTokens[_to].push(_tokenId);
423     ownedTokensIndex[_tokenId] = length;
424     totalTokens = totalTokens.add(1);
425   }
426 
427   /**
428   * @dev Internal function to remove a token ID from the list of a given address
429   * @param _from address representing the previous owner of the given token ID
430   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
431   */
432   function removeToken(address _from, uint256 _tokenId) private {
433     require(ownerOf(_tokenId) == _from);
434 
435     uint256 tokenIndex = ownedTokensIndex[_tokenId];
436     uint256 lastTokenIndex = balanceOf(_from).sub(1);
437     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
438 
439     tokenOwner[_tokenId] = 0;
440     ownedTokens[_from][tokenIndex] = lastToken;
441     ownedTokens[_from][lastTokenIndex] = 0;
442     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
443     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
444     // the lastToken to the first position, and then dropping the element placed in the last position of the list
445 
446     ownedTokens[_from].length--;
447     ownedTokensIndex[_tokenId] = 0;
448     ownedTokensIndex[lastToken] = tokenIndex;
449     totalTokens = totalTokens.sub(1);
450   }
451 }
452 
453 
454 /**
455  * @title ERC20Basic
456  * @dev Simpler version of ERC20 interface
457  * @dev see https://github.com/ethereum/EIPs/issues/179
458  */
459 contract ERC20Basic {
460   function totalSupply() public view returns (uint256);
461   function balanceOf(address who) public view returns (uint256);
462   function transfer(address to, uint256 value) public returns (bool);
463   event Transfer(address indexed from, address indexed to, uint256 value);
464 }
465 
466 
467 /**
468  * @title ERC20 interface
469  * @dev see https://github.com/ethereum/EIPs/issues/20
470  */
471 contract ERC20 is ERC20Basic {
472   function allowance(address owner, address spender) public view returns (uint256);
473   function transferFrom(address from, address to, uint256 value) public returns (bool);
474   function approve(address spender, uint256 value) public returns (bool);
475   event Approval(address indexed owner, address indexed spender, uint256 value);
476 }
477 
478 
479 /**
480  * @title SafeMath
481  * @dev Math operations with safety checks that throw on error
482  */
483 library SafeMath {
484 
485   /**
486   * @dev Multiplies two numbers, throws on overflow.
487   */
488   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
489     if (a == 0) {
490       return 0;
491     }
492     uint256 c = a * b;
493     assert(c / a == b);
494     return c;
495   }
496 
497   /**
498   * @dev Integer division of two numbers, truncating the quotient.
499   */
500   function div(uint256 a, uint256 b) internal pure returns (uint256) {
501     // assert(b > 0); // Solidity automatically throws when dividing by 0
502     uint256 c = a / b;
503     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
504     return c;
505   }
506 
507   /**
508   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
509   */
510   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
511     assert(b <= a);
512     return a - b;
513   }
514 
515   /**
516   * @dev Adds two numbers, throws on overflow.
517   */
518   function add(uint256 a, uint256 b) internal pure returns (uint256) {
519     uint256 c = a + b;
520     assert(c >= a);
521     return c;
522   }
523 }
524 
525 
526 /**
527  * @title Basic token
528  * @dev Basic version of StandardToken, with no allowances.
529  */
530 contract BasicToken is ERC20Basic {
531   using SafeMath for uint256;
532 
533   mapping(address => uint256) balances;
534 
535   uint256 totalSupply_;
536 
537   /**
538   * @dev total number of tokens in existence
539   */
540   function totalSupply() public view returns (uint256) {
541     return totalSupply_;
542   }
543 
544   /**
545   * @dev transfer token for a specified address
546   * @param _to The address to transfer to.
547   * @param _value The amount to be transferred.
548   */
549   function transfer(address _to, uint256 _value) public returns (bool) {
550     require(_to != address(0));
551     require(_value <= balances[msg.sender]);
552 
553     // SafeMath.sub will throw if there is not enough balance.
554     balances[msg.sender] = balances[msg.sender].sub(_value);
555     balances[_to] = balances[_to].add(_value);
556     Transfer(msg.sender, _to, _value);
557     return true;
558   }
559 
560   /**
561   * @dev Gets the balance of the specified address.
562   * @param _owner The address to query the the balance of.
563   * @return An uint256 representing the amount owned by the passed address.
564   */
565   function balanceOf(address _owner) public view returns (uint256 balance) {
566     return balances[_owner];
567   }
568 
569 }
570 
571 
572 /**
573  * @title Standard ERC20 token
574  *
575  * @dev Implementation of the basic standard token.
576  * @dev https://github.com/ethereum/EIPs/issues/20
577  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
578  */
579 contract StandardToken is ERC20, BasicToken {
580 
581   mapping (address => mapping (address => uint256)) internal allowed;
582 
583 
584   /**
585    * @dev Transfer tokens from one address to another
586    * @param _from address The address which you want to send tokens from
587    * @param _to address The address which you want to transfer to
588    * @param _value uint256 the amount of tokens to be transferred
589    */
590   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
591     require(_to != address(0));
592     require(_value <= balances[_from]);
593     require(_value <= allowed[_from][msg.sender]);
594 
595     balances[_from] = balances[_from].sub(_value);
596     balances[_to] = balances[_to].add(_value);
597     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
598     Transfer(_from, _to, _value);
599     return true;
600   }
601 
602   /**
603    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
604    *
605    * Beware that changing an allowance with this method brings the risk that someone may use both the old
606    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
607    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
608    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
609    * @param _spender The address which will spend the funds.
610    * @param _value The amount of tokens to be spent.
611    */
612   function approve(address _spender, uint256 _value) public returns (bool) {
613     allowed[msg.sender][_spender] = _value;
614     Approval(msg.sender, _spender, _value);
615     return true;
616   }
617 
618   /**
619    * @dev Function to check the amount of tokens that an owner allowed to a spender.
620    * @param _owner address The address which owns the funds.
621    * @param _spender address The address which will spend the funds.
622    * @return A uint256 specifying the amount of tokens still available for the spender.
623    */
624   function allowance(address _owner, address _spender) public view returns (uint256) {
625     return allowed[_owner][_spender];
626   }
627 
628   /**
629    * @dev Increase the amount of tokens that an owner allowed to a spender.
630    *
631    * approve should be called when allowed[_spender] == 0. To increment
632    * allowed value is better to use this function to avoid 2 calls (and wait until
633    * the first transaction is mined)
634    * From MonolithDAO Token.sol
635    * @param _spender The address which will spend the funds.
636    * @param _addedValue The amount of tokens to increase the allowance by.
637    */
638   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
639     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
640     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
641     return true;
642   }
643 
644   /**
645    * @dev Decrease the amount of tokens that an owner allowed to a spender.
646    *
647    * approve should be called when allowed[_spender] == 0. To decrement
648    * allowed value is better to use this function to avoid 2 calls (and wait until
649    * the first transaction is mined)
650    * From MonolithDAO Token.sol
651    * @param _spender The address which will spend the funds.
652    * @param _subtractedValue The amount of tokens to decrease the allowance by.
653    */
654   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
655     uint oldValue = allowed[msg.sender][_spender];
656     if (_subtractedValue > oldValue) {
657       allowed[msg.sender][_spender] = 0;
658     } else {
659       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
660     }
661     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
662     return true;
663   }
664 
665 }
666 
667 
668 /**
669  * @title Gold
670  * @dev ERC20 Token that can be minted.
671  */
672 contract Gold is StandardToken, Claimable, AccessMint {
673 
674   string public constant name = "Gold";
675   string public constant symbol = "G";
676   uint8 public constant decimals = 18;
677 
678   // Event that is fired when minted.
679   event Mint(
680     address indexed _to,
681     uint256 indexed _tokenId
682   );
683 
684   // @dev Mint tokens with _amount to the address.
685   function mint(address _to, uint256 _amount) 
686     onlyAccessMint
687     public 
688     returns (bool) 
689   {
690     totalSupply_ = totalSupply_.add(_amount);
691     balances[_to] = balances[_to].add(_amount);
692     Mint(_to, _amount);
693     Transfer(address(0), _to, _amount);
694     return true;
695   }
696 
697 }
698 
699 
700 /**
701  * @title CryptoSagaHero
702  * @dev The token contract for the hero.
703  *  Also a superset of the ERC721 standard that allows for the minting
704  *  of the non-fungible tokens.
705  */
706 contract CryptoSagaHero is ERC721Token, Claimable, Pausable, AccessMint, AccessDeploy, AccessDeposit {
707 
708   string public constant name = "CryptoSaga Hero";
709   string public constant symbol = "HERO";
710   
711   struct HeroClass {
712     // ex) Soldier, Knight, Fighter...
713     string className;
714     // 0: Common, 1: Uncommon, 2: Rare, 3: Heroic, 4: Legendary.
715     uint8 classRank;
716     // 0: Human, 1: Celestial, 2: Demon, 3: Elf, 4: Dark Elf, 5: Yogoe, 6: Furry, 7: Dragonborn, 8: Undead, 9: Goblin, 10: Troll, 11: Slime, and more to come.
717     uint8 classRace;
718     // How old is this hero class? 
719     uint32 classAge;
720     // 0: Fighter, 1: Rogue, 2: Mage.
721     uint8 classType;
722 
723     // Possible max level of this class.
724     uint32 maxLevel; 
725     // 0: Water, 1: Fire, 2: Nature, 3: Light, 4: Darkness.
726     uint8 aura; 
727 
728     // Base stats of this hero type. 
729     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
730     uint32[5] baseStats;
731     // Minimum IVs for stats. 
732     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
733     uint32[5] minIVForStats;
734     // Maximum IVs for stats.
735     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
736     uint32[5] maxIVForStats;
737     
738     // Number of currently instanced heroes.
739     uint32 currentNumberOfInstancedHeroes;
740   }
741     
742   struct HeroInstance {
743     // What is this hero's type? ex) John, Sally, Mark...
744     uint32 heroClassId;
745     
746     // Individual hero's name.
747     string heroName;
748     
749     // Current level of this hero.
750     uint32 currentLevel;
751     // Current exp of this hero.
752     uint32 currentExp;
753 
754     // Where has this hero been deployed? (0: Never depolyed ever.) ex) Dungeon Floor #1, Arena #5...
755     uint32 lastLocationId;
756     // When a hero is deployed, it takes time for the hero to return to the base. This is in Unix epoch.
757     uint256 availableAt;
758 
759     // Current stats of this hero. 
760     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
761     uint32[5] currentStats;
762     // The individual value for this hero's stats. 
763     // This will affect the current stats of heroes.
764     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
765     uint32[5] ivForStats;
766   }
767 
768   // Required exp for level up will increase when heroes level up.
769   // This defines how the value will increase.
770   uint32 public requiredExpIncreaseFactor = 100;
771 
772   // Required Gold for level up will increase when heroes level up.
773   // This defines how the value will increase.
774   uint256 public requiredGoldIncreaseFactor = 1000000000000000000;
775 
776   // Existing hero classes.
777   mapping(uint32 => HeroClass) public heroClasses;
778   // The number of hero classes ever defined.
779   uint32 public numberOfHeroClasses;
780 
781   // Existing hero instances.
782   // The key is _tokenId.
783   mapping(uint256 => HeroInstance) public tokenIdToHeroInstance;
784   // The number of tokens ever minted. This works as the serial number.
785   uint256 public numberOfTokenIds;
786 
787   // Gold contract.
788   Gold public goldContract;
789 
790   // Deposit of players (in Gold).
791   mapping(address => uint256) public addressToGoldDeposit;
792 
793   // Random seed.
794   uint32 private seed = 0;
795 
796   // Event that is fired when a hero type defined.
797   event DefineType(
798     address indexed _by,
799     uint32 indexed _typeId,
800     string _className
801   );
802 
803   // Event that is fired when a hero is upgraded.
804   event LevelUp(
805     address indexed _by,
806     uint256 indexed _tokenId,
807     uint32 _newLevel
808   );
809 
810   // Event that is fired when a hero is deployed.
811   event Deploy(
812     address indexed _by,
813     uint256 indexed _tokenId,
814     uint32 _locationId,
815     uint256 _duration
816   );
817 
818   // @dev Get the class's entire infomation.
819   function getClassInfo(uint32 _classId)
820     external view
821     returns (string className, uint8 classRank, uint8 classRace, uint32 classAge, uint8 classType, uint32 maxLevel, uint8 aura, uint32[5] baseStats, uint32[5] minIVs, uint32[5] maxIVs) 
822   {
823     var _cl = heroClasses[_classId];
824     return (_cl.className, _cl.classRank, _cl.classRace, _cl.classAge, _cl.classType, _cl.maxLevel, _cl.aura, _cl.baseStats, _cl.minIVForStats, _cl.maxIVForStats);
825   }
826 
827   // @dev Get the class's name.
828   function getClassName(uint32 _classId)
829     external view
830     returns (string)
831   {
832     return heroClasses[_classId].className;
833   }
834 
835   // @dev Get the class's rank.
836   function getClassRank(uint32 _classId)
837     external view
838     returns (uint8)
839   {
840     return heroClasses[_classId].classRank;
841   }
842 
843   // @dev Get the heroes ever minted for the class.
844   function getClassMintCount(uint32 _classId)
845     external view
846     returns (uint32)
847   {
848     return heroClasses[_classId].currentNumberOfInstancedHeroes;
849   }
850 
851   // @dev Get the hero's entire infomation.
852   function getHeroInfo(uint256 _tokenId)
853     external view
854     returns (uint32 classId, string heroName, uint32 currentLevel, uint32 currentExp, uint32 lastLocationId, uint256 availableAt, uint32[5] currentStats, uint32[5] ivs, uint32 bp)
855   {
856     HeroInstance memory _h = tokenIdToHeroInstance[_tokenId];
857     var _bp = _h.currentStats[0] + _h.currentStats[1] + _h.currentStats[2] + _h.currentStats[3] + _h.currentStats[4];
858     return (_h.heroClassId, _h.heroName, _h.currentLevel, _h.currentExp, _h.lastLocationId, _h.availableAt, _h.currentStats, _h.ivForStats, _bp);
859   }
860 
861   // @dev Get the hero's class id.
862   function getHeroClassId(uint256 _tokenId)
863     external view
864     returns (uint32)
865   {
866     return tokenIdToHeroInstance[_tokenId].heroClassId;
867   }
868 
869   // @dev Get the hero's name.
870   function getHeroName(uint256 _tokenId)
871     external view
872     returns (string)
873   {
874     return tokenIdToHeroInstance[_tokenId].heroName;
875   }
876 
877   // @dev Get the hero's level.
878   function getHeroLevel(uint256 _tokenId)
879     external view
880     returns (uint32)
881   {
882     return tokenIdToHeroInstance[_tokenId].currentLevel;
883   }
884   
885   // @dev Get the hero's location.
886   function getHeroLocation(uint256 _tokenId)
887     external view
888     returns (uint32)
889   {
890     return tokenIdToHeroInstance[_tokenId].lastLocationId;
891   }
892 
893   // @dev Get the time when the hero become available.
894   function getHeroAvailableAt(uint256 _tokenId)
895     external view
896     returns (uint256)
897   {
898     return tokenIdToHeroInstance[_tokenId].availableAt;
899   }
900 
901   // @dev Get the hero's BP.
902   function getHeroBP(uint256 _tokenId)
903     public view
904     returns (uint32)
905   {
906     var _tmp = tokenIdToHeroInstance[_tokenId].currentStats;
907     return (_tmp[0] + _tmp[1] + _tmp[2] + _tmp[3] + _tmp[4]);
908   }
909 
910   // @dev Get the hero's required gold for level up.
911   function getHeroRequiredGoldForLevelUp(uint256 _tokenId)
912     public view
913     returns (uint256)
914   {
915     return (uint256(2) ** (tokenIdToHeroInstance[_tokenId].currentLevel / 10)) * requiredGoldIncreaseFactor;
916   }
917 
918   // @dev Get the hero's required exp for level up.
919   function getHeroRequiredExpForLevelUp(uint256 _tokenId)
920     public view
921     returns (uint32)
922   {
923     return ((tokenIdToHeroInstance[_tokenId].currentLevel + 2) * requiredExpIncreaseFactor);
924   }
925 
926   // @dev Get the deposit of gold of the player.
927   function getGoldDepositOfAddress(address _address)
928     external view
929     returns (uint256)
930   {
931     return addressToGoldDeposit[_address];
932   }
933 
934   // @dev Get the token id of the player's #th token.
935   function getTokenIdOfAddressAndIndex(address _address, uint256 _index)
936     external view
937     returns (uint256)
938   {
939     return tokensOf(_address)[_index];
940   }
941 
942   // @dev Get the total BP of the player.
943   function getTotalBPOfAddress(address _address)
944     external view
945     returns (uint32)
946   {
947     var _tokens = tokensOf(_address);
948     uint32 _totalBP = 0;
949     for (uint256 i = 0; i < _tokens.length; i ++) {
950       _totalBP += getHeroBP(_tokens[i]);
951     }
952     return _totalBP;
953   }
954 
955   // @dev Set the hero's name.
956   function setHeroName(uint256 _tokenId, string _name)
957     onlyOwnerOf(_tokenId)
958     public
959   {
960     tokenIdToHeroInstance[_tokenId].heroName = _name;
961   }
962 
963   // @dev Set the address of the contract that represents ERC20 Gold.
964   function setGoldContract(address _contractAddress)
965     onlyOwner
966     public
967   {
968     goldContract = Gold(_contractAddress);
969   }
970 
971   // @dev Set the required golds to level up a hero.
972   function setRequiredExpIncreaseFactor(uint32 _value)
973     onlyOwner
974     public
975   {
976     requiredExpIncreaseFactor = _value;
977   }
978 
979   // @dev Set the required golds to level up a hero.
980   function setRequiredGoldIncreaseFactor(uint256 _value)
981     onlyOwner
982     public
983   {
984     requiredGoldIncreaseFactor = _value;
985   }
986 
987   // @dev Contructor.
988   function CryptoSagaHero(address _goldAddress)
989     public
990   {
991     require(_goldAddress != address(0));
992 
993     // Assign Gold contract.
994     setGoldContract(_goldAddress);
995 
996     // Initial heroes.
997     // Name, Rank, Race, Age, Type, Max Level, Aura, Stats.
998     defineType("Archangel", 4, 1, 13540, 0, 99, 3, [uint32(74), 75, 57, 99, 95], [uint32(8), 6, 8, 5, 5], [uint32(8), 10, 10, 6, 6]);
999     defineType("Shadowalker", 3, 4, 134, 1, 75, 4, [uint32(45), 35, 60, 80, 40], [uint32(3), 2, 10, 4, 5], [uint32(5), 5, 10, 7, 5]);
1000     defineType("Pyromancer", 2, 0, 14, 2, 50, 1, [uint32(50), 28, 17, 40, 35], [uint32(5), 3, 2, 3, 3], [uint32(8), 4, 3, 4, 5]);
1001     defineType("Magician", 1, 3, 224, 2, 30, 0, [uint32(35), 15, 25, 25, 30], [uint32(3), 1, 2, 2, 2], [uint32(5), 2, 3, 3, 3]);
1002     defineType("Farmer", 0, 0, 59, 0, 15, 2, [uint32(10), 22, 8, 15, 25], [uint32(1), 2, 1, 1, 2], [uint32(1), 3, 1, 2, 3]);
1003   }
1004 
1005   // @dev Define a new hero type (class).
1006   function defineType(string _className, uint8 _classRank, uint8 _classRace, uint32 _classAge, uint8 _classType, uint32 _maxLevel, uint8 _aura, uint32[5] _baseStats, uint32[5] _minIVForStats, uint32[5] _maxIVForStats)
1007     onlyOwner
1008     public
1009   {
1010     require(_classRank < 5);
1011     require(_classType < 3);
1012     require(_aura < 5);
1013     require(_minIVForStats[0] <= _maxIVForStats[0] && _minIVForStats[1] <= _maxIVForStats[1] && _minIVForStats[2] <= _maxIVForStats[2] && _minIVForStats[3] <= _maxIVForStats[3] && _minIVForStats[4] <= _maxIVForStats[4]);
1014 
1015     HeroClass memory _heroType = HeroClass({
1016       className: _className,
1017       classRank: _classRank,
1018       classRace: _classRace,
1019       classAge: _classAge,
1020       classType: _classType,
1021       maxLevel: _maxLevel,
1022       aura: _aura,
1023       baseStats: _baseStats,
1024       minIVForStats: _minIVForStats,
1025       maxIVForStats: _maxIVForStats,
1026       currentNumberOfInstancedHeroes: 0
1027     });
1028 
1029     // Save the hero class.
1030     heroClasses[numberOfHeroClasses] = _heroType;
1031 
1032     // Fire event.
1033     DefineType(msg.sender, numberOfHeroClasses, _heroType.className);
1034 
1035     // Increment number of hero classes.
1036     numberOfHeroClasses ++;
1037 
1038   }
1039 
1040   // @dev Mint a new hero, with _heroClassId.
1041   function mint(address _owner, uint32 _heroClassId)
1042     onlyAccessMint
1043     public
1044     returns (uint256)
1045   {
1046     require(_owner != address(0));
1047     require(_heroClassId < numberOfHeroClasses);
1048 
1049     // The information of the hero's class.
1050     var _heroClassInfo = heroClasses[_heroClassId];
1051 
1052     // Mint ERC721 token.
1053     _mint(_owner, numberOfTokenIds);
1054 
1055     // Build random IVs for this hero instance.
1056     uint32[5] memory _ivForStats;
1057     uint32[5] memory _initialStats;
1058     for (uint8 i = 0; i < 5; i++) {
1059       _ivForStats[i] = (random(_heroClassInfo.maxIVForStats[i] + 1, _heroClassInfo.minIVForStats[i]));
1060       _initialStats[i] = _heroClassInfo.baseStats[i] + _ivForStats[i];
1061     }
1062 
1063     // Temporary hero instance.
1064     HeroInstance memory _heroInstance = HeroInstance({
1065       heroClassId: _heroClassId,
1066       heroName: "",
1067       currentLevel: 1,
1068       currentExp: 0,
1069       lastLocationId: 0,
1070       availableAt: now,
1071       currentStats: _initialStats,
1072       ivForStats: _ivForStats
1073     });
1074 
1075     // Save the hero instance.
1076     tokenIdToHeroInstance[numberOfTokenIds] = _heroInstance;
1077 
1078     // Increment number of token ids.
1079     // This will only increment when new token is minted, and will never be decemented when the token is burned.
1080     numberOfTokenIds ++;
1081 
1082      // Increment instanced number of heroes.
1083     _heroClassInfo.currentNumberOfInstancedHeroes ++;
1084 
1085     return numberOfTokenIds - 1;
1086   }
1087 
1088   // @dev Set where the heroes are deployed, and when they will return.
1089   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1090   function deploy(uint256 _tokenId, uint32 _locationId, uint256 _duration)
1091     onlyAccessDeploy
1092     public
1093     returns (bool)
1094   {
1095     // The hero should be possessed by anybody.
1096     require(ownerOf(_tokenId) != address(0));
1097 
1098     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1099 
1100     // The character should be avaiable. 
1101     require(_heroInstance.availableAt <= now);
1102 
1103     _heroInstance.lastLocationId = _locationId;
1104     _heroInstance.availableAt = now + _duration;
1105 
1106     // As the hero has been deployed to another place, fire event.
1107     Deploy(msg.sender, _tokenId, _locationId, _duration);
1108   }
1109 
1110   // @dev Add exp.
1111   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1112   function addExp(uint256 _tokenId, uint32 _exp)
1113     onlyAccessDeploy
1114     public
1115     returns (bool)
1116   {
1117     // The hero should be possessed by anybody.
1118     require(ownerOf(_tokenId) != address(0));
1119 
1120     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1121 
1122     var _newExp = _heroInstance.currentExp + _exp;
1123 
1124     // Sanity check to ensure we don't overflow.
1125     require(_newExp == uint256(uint128(_newExp)));
1126 
1127     _heroInstance.currentExp += _newExp;
1128 
1129   }
1130 
1131   // @dev Add deposit.
1132   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1133   function addDeposit(address _to, uint256 _amount)
1134     onlyAccessDeposit
1135     public
1136   {
1137     // Increment deposit.
1138     addressToGoldDeposit[_to] += _amount;
1139   }
1140 
1141   // @dev Level up the hero with _tokenId.
1142   //  This function is called by the owner of the hero.
1143   function levelUp(uint256 _tokenId)
1144     onlyOwnerOf(_tokenId) whenNotPaused
1145     public
1146   {
1147 
1148     // Hero instance.
1149     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1150 
1151     // The character should be avaiable. (Should have already returned from the dungeons, arenas, etc.)
1152     require(_heroInstance.availableAt <= now);
1153 
1154     // The information of the hero's class.
1155     var _heroClassInfo = heroClasses[_heroInstance.heroClassId];
1156 
1157     // Hero shouldn't level up exceed its max level.
1158     require(_heroInstance.currentLevel < _heroClassInfo.maxLevel);
1159 
1160     // Required Exp.
1161     var requiredExp = getHeroRequiredExpForLevelUp(_tokenId);
1162 
1163     // Need to have enough exp.
1164     require(_heroInstance.currentExp >= requiredExp);
1165 
1166     // Required Gold.
1167     var requiredGold = getHeroRequiredGoldForLevelUp(_tokenId);
1168 
1169     // Owner of token.
1170     var _ownerOfToken = ownerOf(_tokenId);
1171 
1172     // Need to have enough Gold balance.
1173     require(addressToGoldDeposit[_ownerOfToken] >= requiredGold);
1174 
1175     // Increase Level.
1176     _heroInstance.currentLevel += 1;
1177 
1178     // Increase Stats.
1179     for (uint8 i = 0; i < 5; i++) {
1180       _heroInstance.currentStats[i] = _heroClassInfo.baseStats[i] + (_heroInstance.currentLevel - 1) * _heroInstance.ivForStats[i];
1181     }
1182     
1183     // Deduct exp.
1184     _heroInstance.currentExp -= requiredExp;
1185 
1186     // Deduct gold.
1187     addressToGoldDeposit[_ownerOfToken] -= requiredGold;
1188 
1189     // Fire event.
1190     LevelUp(msg.sender, _tokenId, _heroInstance.currentLevel);
1191   }
1192 
1193   // @dev Transfer deposit (with the allowance pattern.)
1194   function transferDeposit(uint256 _amount)
1195     whenNotPaused
1196     public
1197   {
1198     require(goldContract.allowance(msg.sender, this) >= _amount);
1199 
1200     // Send msg.sender's Gold to this contract.
1201     if (goldContract.transferFrom(msg.sender, this, _amount)) {
1202        // Increment deposit.
1203       addressToGoldDeposit[msg.sender] += _amount;
1204     }
1205   }
1206 
1207   // @dev Withdraw deposit.
1208   function withdrawDeposit(uint256 _amount)
1209     public
1210   {
1211     require(addressToGoldDeposit[msg.sender] >= _amount);
1212 
1213     // Send deposit of Golds to msg.sender. (Rather minting...)
1214     if (goldContract.transfer(msg.sender, _amount)) {
1215       // Decrement deposit.
1216       addressToGoldDeposit[msg.sender] -= _amount;
1217     }
1218   }
1219 
1220   // @dev return a pseudo random number between lower and upper bounds
1221   function random(uint32 _upper, uint32 _lower)
1222     private
1223     returns (uint32)
1224   {
1225     require(_upper > _lower);
1226 
1227     seed = uint32(keccak256(keccak256(block.blockhash(block.number), seed), now));
1228     return seed % (_upper - _lower) + _lower;
1229   }
1230 
1231 }
1232 
1233 /**
1234  * @title The interface contract for Card-For-Hero swap functionality.
1235  * @dev With this contract, a card holder can swap his/her CryptoSagaCard for reward.
1236  *  This contract is intended to be inherited by CryptoSagaCardSwap implementation contracts.
1237  */
1238 contract CryptoSagaCardSwap is Ownable {
1239 
1240   // Card contract.
1241   address internal cardAddess;
1242 
1243   // Modifier for accessibility to define new hero types.
1244   modifier onlyCard {
1245     require(msg.sender == cardAddess);
1246     _;
1247   }
1248   
1249   // @dev Set the address of the contract that represents ERC721 Card.
1250   function setCardContract(address _contractAddress)
1251     public
1252     onlyOwner
1253   {
1254     cardAddess = _contractAddress;
1255   }
1256 
1257   // @dev Convert card into reward.
1258   //  This should be implemented by CryptoSagaCore later.
1259   function swapCardForReward(address _by, uint8 _rank)
1260     onlyCard
1261     public 
1262     returns (uint256)
1263   {
1264     return 0;
1265   }
1266 
1267 }
1268 
1269 
1270 /**
1271  * @title CryptoSagaCardSwapVer1
1272  * @dev This implements CryptoSagaCardSwap interface.
1273  */
1274 contract CryptoSagaCardSwapVer1 is CryptoSagaCardSwap {
1275 
1276   // The hero contract.
1277   CryptoSagaHero private heroContract;
1278 
1279   // Random seed.
1280   uint32 private seed = 0;
1281 
1282   // @dev Blacklisted heroes.
1283   // This is needed in order to protect players, in case there exists any hero with critical issues.
1284   // We promise we will use this function carefully, and this won't be used for balancing the OP heroes.
1285   mapping(uint32 => bool) public blackList;
1286 
1287   // @dev Set blacklist.
1288   function setBlacklist(uint32 _classId, bool _value)
1289     onlyOwner
1290     public
1291   {
1292     blackList[_classId] = _value;
1293   }
1294 
1295   // @dev Set the address of the contract that represents CryptoSaga Cards.
1296   function setHeroContract(address _contractAddress)
1297     onlyOwner
1298     public
1299   {
1300     heroContract = CryptoSagaHero(_contractAddress);
1301   }
1302 
1303   // @dev Contructor.
1304   function CryptoSagaCardSwapVer1(address _heroAddress, address _cardAddress)
1305     public
1306   {
1307     require(_heroAddress != address(0));
1308     require(_cardAddress != address(0));
1309 
1310     setHeroContract(_heroAddress);
1311     setCardContract(_cardAddress);
1312   }
1313 
1314   // @dev Swap a card for a hero.
1315   //  When called by the Card contract, this will ask for 
1316   function swapCardForReward(address _by, uint8 _rank)
1317     onlyCard
1318     public
1319     returns (uint256)
1320   {
1321     // This is becaue we need to use tx.origin here.
1322     // _by should be the beneficiary, but due to the bug that is already exist with CryptoSagaCard.sol,
1323     // tx.origin is used instead of _by.
1324     require(tx.origin != _by && tx.origin != msg.sender);
1325 
1326     // Get value 0 ~ 99.
1327     var _randomValue = random(100, 0);
1328     
1329     // We hard-code this in order to give credential to the players.
1330     // 0: Common, 1: Uncommon, 2: Rare, 3: Heroic, 4: Legendary
1331     uint8 _heroRankToMint = 0; 
1332 
1333     if (_rank == 0) { // Origin Card. 85% Heroic, 15% Legendary.
1334       if (_randomValue < 85) {
1335         _heroRankToMint = 3;
1336       } else {
1337         _heroRankToMint = 4;
1338       }
1339     } else if (_rank == 1) { // Eth Card. 50% Uncommon, 30% Rare, 19% heroic, 1% Legendary.
1340       if (_randomValue < 50) {
1341         _heroRankToMint = 1;
1342       } else if (_randomValue < 80) {
1343         _heroRankToMint = 2;
1344       }  else if (_randomValue < 99) {
1345         _heroRankToMint = 3;
1346       } else {
1347         _heroRankToMint = 4;
1348       }
1349     } else if (_rank == 2) { // Gold Card. 50% Common, 35% Uncommon, 15% Rare.
1350       if (_randomValue < 50) {
1351         _heroRankToMint = 0;
1352       } else if (_randomValue < 85) {
1353         _heroRankToMint = 1;
1354       } else {
1355         _heroRankToMint = 2;
1356       }
1357     } else { // Do nothing here.
1358       _heroRankToMint = 0;
1359     }
1360 
1361     // Get the list of hero classes.
1362     uint32 _numberOfClasses = heroContract.numberOfHeroClasses();
1363     uint32[] memory _candidates = new uint32[](_numberOfClasses);
1364     uint32 _count = 0;
1365     for (uint32 i = 0; i < _numberOfClasses; i ++) {
1366       if (heroContract.getClassRank(i) == _heroRankToMint && blackList[i] != true) {
1367         _candidates[_count] = i;
1368         _count++;
1369       }
1370     }
1371 
1372     require(_count != 0);
1373     
1374     return heroContract.mint(tx.origin, _candidates[random(_count, 0)]);
1375   }
1376 
1377   // @dev return a pseudo random number between lower and upper bounds
1378   function random(uint32 _upper, uint32 _lower)
1379     private
1380     returns (uint32)
1381   {
1382     require(_upper > _lower);
1383 
1384     seed = uint32(keccak256(keccak256(block.blockhash(block.number), seed), now));
1385     return seed % (_upper - _lower) + _lower;
1386   }
1387 
1388 }