1 pragma solidity ^0.4.18;
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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 /**
92  * @title Claimable
93  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
94  * This allows the new owner to accept the transfer.
95  */
96 contract Claimable is Ownable {
97   address public pendingOwner;
98 
99   /**
100    * @dev Modifier throws if called by any account other than the pendingOwner.
101    */
102   modifier onlyPendingOwner() {
103     require(msg.sender == pendingOwner);
104     _;
105   }
106 
107   /**
108    * @dev Allows the current owner to set the pendingOwner address.
109    * @param newOwner The address to transfer ownership to.
110    */
111   function transferOwnership(address newOwner) onlyOwner public {
112     pendingOwner = newOwner;
113   }
114 
115   /**
116    * @dev Allows the pendingOwner address to finalize the transfer.
117    */
118   function claimOwnership() onlyPendingOwner public {
119     OwnershipTransferred(owner, pendingOwner);
120     owner = pendingOwner;
121     pendingOwner = address(0);
122   }
123 }
124 
125 
126 /**
127  * @title Pausable
128  * @dev Base contract which allows children to implement an emergency stop mechanism.
129  */
130 contract Pausable is Ownable {
131   event Pause();
132   event Unpause();
133 
134   bool public paused = false;
135 
136 
137   /**
138    * @dev Modifier to make a function callable only when the contract is not paused.
139    */
140   modifier whenNotPaused() {
141     require(!paused);
142     _;
143   }
144 
145   /**
146    * @dev Modifier to make a function callable only when the contract is paused.
147    */
148   modifier whenPaused() {
149     require(paused);
150     _;
151   }
152 
153   /**
154    * @dev called by the owner to pause, triggers stopped state
155    */
156   function pause() onlyOwner whenNotPaused public {
157     paused = true;
158     Pause();
159   }
160 
161   /**
162    * @dev called by the owner to unpause, returns to normal state
163    */
164   function unpause() onlyOwner whenPaused public {
165     paused = false;
166     Unpause();
167   }
168 }
169 
170 
171 /**
172  * @title ERC721 interface
173  * @dev see https://github.com/ethereum/eips/issues/721
174  */
175 contract ERC721 {
176   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
177   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
178 
179   function balanceOf(address _owner) public view returns (uint256 _balance);
180   function ownerOf(uint256 _tokenId) public view returns (address _owner);
181   function transfer(address _to, uint256 _tokenId) public;
182   function approve(address _to, uint256 _tokenId) public;
183   function takeOwnership(uint256 _tokenId) public;
184 }
185 
186 
187 /**
188  * @title ERC721Token
189  * Generic implementation for the required functionality of the ERC721 standard
190  */
191 contract ERC721Token is ERC721 {
192   using SafeMath for uint256;
193 
194   // Total amount of tokens
195   uint256 private totalTokens;
196 
197   // Mapping from token ID to owner
198   mapping (uint256 => address) private tokenOwner;
199 
200   // Mapping from token ID to approved address
201   mapping (uint256 => address) private tokenApprovals;
202 
203   // Mapping from owner to list of owned token IDs
204   mapping (address => uint256[]) private ownedTokens;
205 
206   // Mapping from token ID to index of the owner tokens list
207   mapping(uint256 => uint256) private ownedTokensIndex;
208 
209   /**
210   * @dev Guarantees msg.sender is owner of the given token
211   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
212   */
213   modifier onlyOwnerOf(uint256 _tokenId) {
214     require(ownerOf(_tokenId) == msg.sender);
215     _;
216   }
217 
218   /**
219   * @dev Gets the total amount of tokens stored by the contract
220   * @return uint256 representing the total amount of tokens
221   */
222   function totalSupply() public view returns (uint256) {
223     return totalTokens;
224   }
225 
226   /**
227   * @dev Gets the balance of the specified address
228   * @param _owner address to query the balance of
229   * @return uint256 representing the amount owned by the passed address
230   */
231   function balanceOf(address _owner) public view returns (uint256) {
232     return ownedTokens[_owner].length;
233   }
234 
235   /**
236   * @dev Gets the list of tokens owned by a given address
237   * @param _owner address to query the tokens of
238   * @return uint256[] representing the list of tokens owned by the passed address
239   */
240   function tokensOf(address _owner) public view returns (uint256[]) {
241     return ownedTokens[_owner];
242   }
243 
244   /**
245   * @dev Gets the owner of the specified token ID
246   * @param _tokenId uint256 ID of the token to query the owner of
247   * @return owner address currently marked as the owner of the given token ID
248   */
249   function ownerOf(uint256 _tokenId) public view returns (address) {
250     address owner = tokenOwner[_tokenId];
251     require(owner != address(0));
252     return owner;
253   }
254 
255   /**
256    * @dev Gets the approved address to take ownership of a given token ID
257    * @param _tokenId uint256 ID of the token to query the approval of
258    * @return address currently approved to take ownership of the given token ID
259    */
260   function approvedFor(uint256 _tokenId) public view returns (address) {
261     return tokenApprovals[_tokenId];
262   }
263 
264   /**
265   * @dev Transfers the ownership of a given token ID to another address
266   * @param _to address to receive the ownership of the given token ID
267   * @param _tokenId uint256 ID of the token to be transferred
268   */
269   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
270     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
271   }
272 
273   /**
274   * @dev Approves another address to claim for the ownership of the given token ID
275   * @param _to address to be approved for the given token ID
276   * @param _tokenId uint256 ID of the token to be approved
277   */
278   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
279     address owner = ownerOf(_tokenId);
280     require(_to != owner);
281     if (approvedFor(_tokenId) != 0 || _to != 0) {
282       tokenApprovals[_tokenId] = _to;
283       Approval(owner, _to, _tokenId);
284     }
285   }
286 
287   /**
288   * @dev Claims the ownership of a given token ID
289   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
290   */
291   function takeOwnership(uint256 _tokenId) public {
292     require(isApprovedFor(msg.sender, _tokenId));
293     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
294   }
295 
296   /**
297   * @dev Mint token function
298   * @param _to The address that will own the minted token
299   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
300   */
301   function _mint(address _to, uint256 _tokenId) internal {
302     require(_to != address(0));
303     addToken(_to, _tokenId);
304     Transfer(0x0, _to, _tokenId);
305   }
306 
307   /**
308   * @dev Burns a specific token
309   * @param _tokenId uint256 ID of the token being burned by the msg.sender
310   */
311   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
312     if (approvedFor(_tokenId) != 0) {
313       clearApproval(msg.sender, _tokenId);
314     }
315     removeToken(msg.sender, _tokenId);
316     Transfer(msg.sender, 0x0, _tokenId);
317   }
318 
319   /**
320    * @dev Tells whether the msg.sender is approved for the given token ID or not
321    * This function is not private so it can be extended in further implementations like the operatable ERC721
322    * @param _owner address of the owner to query the approval of
323    * @param _tokenId uint256 ID of the token to query the approval of
324    * @return bool whether the msg.sender is approved for the given token ID or not
325    */
326   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
327     return approvedFor(_tokenId) == _owner;
328   }
329 
330   /**
331   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
332   * @param _from address which you want to send tokens from
333   * @param _to address which you want to transfer the token to
334   * @param _tokenId uint256 ID of the token to be transferred
335   */
336   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
337     require(_to != address(0));
338     require(_to != ownerOf(_tokenId));
339     require(ownerOf(_tokenId) == _from);
340 
341     clearApproval(_from, _tokenId);
342     removeToken(_from, _tokenId);
343     addToken(_to, _tokenId);
344     Transfer(_from, _to, _tokenId);
345   }
346 
347   /**
348   * @dev Internal function to clear current approval of a given token ID
349   * @param _tokenId uint256 ID of the token to be transferred
350   */
351   function clearApproval(address _owner, uint256 _tokenId) private {
352     require(ownerOf(_tokenId) == _owner);
353     tokenApprovals[_tokenId] = 0;
354     Approval(_owner, 0, _tokenId);
355   }
356 
357   /**
358   * @dev Internal function to add a token ID to the list of a given address
359   * @param _to address representing the new owner of the given token ID
360   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
361   */
362   function addToken(address _to, uint256 _tokenId) private {
363     require(tokenOwner[_tokenId] == address(0));
364     tokenOwner[_tokenId] = _to;
365     uint256 length = balanceOf(_to);
366     ownedTokens[_to].push(_tokenId);
367     ownedTokensIndex[_tokenId] = length;
368     totalTokens = totalTokens.add(1);
369   }
370 
371   /**
372   * @dev Internal function to remove a token ID from the list of a given address
373   * @param _from address representing the previous owner of the given token ID
374   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
375   */
376   function removeToken(address _from, uint256 _tokenId) private {
377     require(ownerOf(_tokenId) == _from);
378 
379     uint256 tokenIndex = ownedTokensIndex[_tokenId];
380     uint256 lastTokenIndex = balanceOf(_from).sub(1);
381     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
382 
383     tokenOwner[_tokenId] = 0;
384     ownedTokens[_from][tokenIndex] = lastToken;
385     ownedTokens[_from][lastTokenIndex] = 0;
386     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
387     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
388     // the lastToken to the first position, and then dropping the element placed in the last position of the list
389 
390     ownedTokens[_from].length--;
391     ownedTokensIndex[_tokenId] = 0;
392     ownedTokensIndex[lastToken] = tokenIndex;
393     totalTokens = totalTokens.sub(1);
394   }
395 }
396 
397 
398 /**
399  * @title ERC20Basic
400  * @dev Simpler version of ERC20 interface
401  * @dev see https://github.com/ethereum/EIPs/issues/179
402  */
403 contract ERC20Basic {
404   function totalSupply() public view returns (uint256);
405   function balanceOf(address who) public view returns (uint256);
406   function transfer(address to, uint256 value) public returns (bool);
407   event Transfer(address indexed from, address indexed to, uint256 value);
408 }
409 
410 
411 /**
412  * @title ERC20 interface
413  * @dev see https://github.com/ethereum/EIPs/issues/20
414  */
415 contract ERC20 is ERC20Basic {
416   function allowance(address owner, address spender) public view returns (uint256);
417   function transferFrom(address from, address to, uint256 value) public returns (bool);
418   function approve(address spender, uint256 value) public returns (bool);
419   event Approval(address indexed owner, address indexed spender, uint256 value);
420 }
421 
422 
423 /**
424  * @title Basic token
425  * @dev Basic version of StandardToken, with no allowances.
426  */
427 contract BasicToken is ERC20Basic {
428   using SafeMath for uint256;
429 
430   mapping(address => uint256) balances;
431 
432   uint256 totalSupply_;
433 
434   /**
435   * @dev total number of tokens in existence
436   */
437   function totalSupply() public view returns (uint256) {
438     return totalSupply_;
439   }
440 
441   /**
442   * @dev transfer token for a specified address
443   * @param _to The address to transfer to.
444   * @param _value The amount to be transferred.
445   */
446   function transfer(address _to, uint256 _value) public returns (bool) {
447     require(_to != address(0));
448     require(_value <= balances[msg.sender]);
449 
450     // SafeMath.sub will throw if there is not enough balance.
451     balances[msg.sender] = balances[msg.sender].sub(_value);
452     balances[_to] = balances[_to].add(_value);
453     Transfer(msg.sender, _to, _value);
454     return true;
455   }
456 
457   /**
458   * @dev Gets the balance of the specified address.
459   * @param _owner The address to query the the balance of.
460   * @return An uint256 representing the amount owned by the passed address.
461   */
462   function balanceOf(address _owner) public view returns (uint256 balance) {
463     return balances[_owner];
464   }
465 
466 }
467 
468 
469 /**
470  * @title Standard ERC20 token
471  *
472  * @dev Implementation of the basic standard token.
473  * @dev https://github.com/ethereum/EIPs/issues/20
474  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
475  */
476 contract StandardToken is ERC20, BasicToken {
477 
478   mapping (address => mapping (address => uint256)) internal allowed;
479 
480 
481   /**
482    * @dev Transfer tokens from one address to another
483    * @param _from address The address which you want to send tokens from
484    * @param _to address The address which you want to transfer to
485    * @param _value uint256 the amount of tokens to be transferred
486    */
487   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
488     require(_to != address(0));
489     require(_value <= balances[_from]);
490     require(_value <= allowed[_from][msg.sender]);
491 
492     balances[_from] = balances[_from].sub(_value);
493     balances[_to] = balances[_to].add(_value);
494     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
495     Transfer(_from, _to, _value);
496     return true;
497   }
498 
499   /**
500    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
501    *
502    * Beware that changing an allowance with this method brings the risk that someone may use both the old
503    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
504    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
505    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
506    * @param _spender The address which will spend the funds.
507    * @param _value The amount of tokens to be spent.
508    */
509   function approve(address _spender, uint256 _value) public returns (bool) {
510     allowed[msg.sender][_spender] = _value;
511     Approval(msg.sender, _spender, _value);
512     return true;
513   }
514 
515   /**
516    * @dev Function to check the amount of tokens that an owner allowed to a spender.
517    * @param _owner address The address which owns the funds.
518    * @param _spender address The address which will spend the funds.
519    * @return A uint256 specifying the amount of tokens still available for the spender.
520    */
521   function allowance(address _owner, address _spender) public view returns (uint256) {
522     return allowed[_owner][_spender];
523   }
524 
525   /**
526    * @dev Increase the amount of tokens that an owner allowed to a spender.
527    *
528    * approve should be called when allowed[_spender] == 0. To increment
529    * allowed value is better to use this function to avoid 2 calls (and wait until
530    * the first transaction is mined)
531    * From MonolithDAO Token.sol
532    * @param _spender The address which will spend the funds.
533    * @param _addedValue The amount of tokens to increase the allowance by.
534    */
535   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
536     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
537     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
538     return true;
539   }
540 
541   /**
542    * @dev Decrease the amount of tokens that an owner allowed to a spender.
543    *
544    * approve should be called when allowed[_spender] == 0. To decrement
545    * allowed value is better to use this function to avoid 2 calls (and wait until
546    * the first transaction is mined)
547    * From MonolithDAO Token.sol
548    * @param _spender The address which will spend the funds.
549    * @param _subtractedValue The amount of tokens to decrease the allowance by.
550    */
551   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
552     uint oldValue = allowed[msg.sender][_spender];
553     if (_subtractedValue > oldValue) {
554       allowed[msg.sender][_spender] = 0;
555     } else {
556       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
557     }
558     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
559     return true;
560   }
561 
562 }
563 
564 
565 /**
566  * @title AccessDeposit
567  * @dev Adds grant/revoke functions to the contract.
568  */
569 contract AccessDeposit is Claimable {
570 
571   // Access for adding deposit.
572   mapping(address => bool) private depositAccess;
573 
574   // Modifier for accessibility to add deposit.
575   modifier onlyAccessDeposit {
576     require(msg.sender == owner || depositAccess[msg.sender] == true);
577     _;
578   }
579 
580   // @dev Grant acess to deposit heroes.
581   function grantAccessDeposit(address _address)
582     onlyOwner
583     public
584   {
585     depositAccess[_address] = true;
586   }
587 
588   // @dev Revoke acess to deposit heroes.
589   function revokeAccessDeposit(address _address)
590     onlyOwner
591     public
592   {
593     depositAccess[_address] = false;
594   }
595 
596 }
597 
598 
599 /**
600  * @title AccessDeploy
601  * @dev Adds grant/revoke functions to the contract.
602  */
603 contract AccessDeploy is Claimable {
604 
605   // Access for deploying heroes.
606   mapping(address => bool) private deployAccess;
607 
608   // Modifier for accessibility to deploy a hero on a location.
609   modifier onlyAccessDeploy {
610     require(msg.sender == owner || deployAccess[msg.sender] == true);
611     _;
612   }
613 
614   // @dev Grant acess to deploy heroes.
615   function grantAccessDeploy(address _address)
616     onlyOwner
617     public
618   {
619     deployAccess[_address] = true;
620   }
621 
622   // @dev Revoke acess to deploy heroes.
623   function revokeAccessDeploy(address _address)
624     onlyOwner
625     public
626   {
627     deployAccess[_address] = false;
628   }
629 
630 }
631 
632 /**
633  * @title AccessMint
634  * @dev Adds grant/revoke functions to the contract.
635  */
636 contract AccessMint is Claimable {
637 
638   // Access for minting new tokens.
639   mapping(address => bool) private mintAccess;
640 
641   // Modifier for accessibility to define new hero types.
642   modifier onlyAccessMint {
643     require(msg.sender == owner || mintAccess[msg.sender] == true);
644     _;
645   }
646 
647   // @dev Grant acess to mint heroes.
648   function grantAccessMint(address _address)
649     onlyOwner
650     public
651   {
652     mintAccess[_address] = true;
653   }
654 
655   // @dev Revoke acess to mint heroes.
656   function revokeAccessMint(address _address)
657     onlyOwner
658     public
659   {
660     mintAccess[_address] = false;
661   }
662 
663 }
664 
665 
666 /**
667  * @title Gold
668  * @dev ERC20 Token that can be minted.
669  */
670 contract Gold is StandardToken, Claimable, AccessMint {
671 
672   string public constant name = "Gold";
673   string public constant symbol = "G";
674   uint8 public constant decimals = 18;
675 
676   // Event that is fired when minted.
677   event Mint(
678     address indexed _to,
679     uint256 indexed _tokenId
680   );
681 
682   // @dev Mint tokens with _amount to the address.
683   function mint(address _to, uint256 _amount) 
684     onlyAccessMint
685     public 
686     returns (bool) 
687   {
688     totalSupply_ = totalSupply_.add(_amount);
689     balances[_to] = balances[_to].add(_amount);
690     Mint(_to, _amount);
691     Transfer(address(0), _to, _amount);
692     return true;
693   }
694 
695 }
696 
697 
698 /**
699  * @title CryptoSaga Card
700  * @dev ERC721 Token that repesents CryptoSaga's cards.
701  *  Buy consuming a card, players of CryptoSaga can get a heroe.
702  */
703 contract CryptoSagaCard is ERC721Token, Claimable, AccessMint {
704 
705   string public constant name = "CryptoSaga Card";
706   string public constant symbol = "CARD";
707 
708   // Rank of the token.
709   mapping(uint256 => uint8) public tokenIdToRank;
710 
711   // The number of tokens ever minted.
712   uint256 public numberOfTokenId;
713 
714   // The converter contract.
715   CryptoSagaCardSwap private swapContract;
716 
717   // Event that should be fired when card is converted.
718   event CardSwap(address indexed _by, uint256 _tokenId, uint256 _rewardId);
719 
720   // @dev Set the address of the contract that represents CryptoSaga Cards.
721   function setCryptoSagaCardSwapContract(address _contractAddress)
722     public
723     onlyOwner
724   {
725     swapContract = CryptoSagaCardSwap(_contractAddress);
726   }
727 
728   function rankOf(uint256 _tokenId) 
729     public view
730     returns (uint8)
731   {
732     return tokenIdToRank[_tokenId];
733   }
734 
735   // @dev Mint a new card.
736   function mint(address _beneficiary, uint256 _amount, uint8 _rank)
737     onlyAccessMint
738     public
739   {
740     for (uint256 i = 0; i < _amount; i++) {
741       _mint(_beneficiary, numberOfTokenId);
742       tokenIdToRank[numberOfTokenId] = _rank;
743       numberOfTokenId ++;
744     }
745   }
746 
747   // @dev Swap this card for reward.
748   //  The card will be burnt.
749   function swap(uint256 _tokenId)
750     onlyOwnerOf(_tokenId)
751     public
752     returns (uint256)
753   {
754     require(address(swapContract) != address(0));
755 
756     var _rank = tokenIdToRank[_tokenId];
757     var _rewardId = swapContract.swapCardForReward(this, _rank);
758     CardSwap(ownerOf(_tokenId), _tokenId, _rewardId);
759     _burn(_tokenId);
760     return _rewardId;
761   }
762 
763 }
764 
765 
766 /**
767  * @title The interface contract for Card-For-Hero swap functionality.
768  * @dev With this contract, a card holder can swap his/her CryptoSagaCard for reward.
769  *  This contract is intended to be inherited by CryptoSagaCardSwap implementation contracts.
770  */
771 contract CryptoSagaCardSwap is Ownable {
772 
773   // Card contract.
774   address internal cardAddess;
775 
776   // Modifier for accessibility to define new hero types.
777   modifier onlyCard {
778     require(msg.sender == cardAddess);
779     _;
780   }
781   
782   // @dev Set the address of the contract that represents ERC721 Card.
783   function setCardContract(address _contractAddress)
784     public
785     onlyOwner
786   {
787     cardAddess = _contractAddress;
788   }
789 
790   // @dev Convert card into reward.
791   //  This should be implemented by CryptoSagaCore later.
792   function swapCardForReward(address _by, uint8 _rank)
793     onlyCard
794     public 
795     returns (uint256);
796 
797 }
798 
799 
800 /**
801  * @title CryptoSagaHero
802  * @dev The token contract for the hero.
803  *  Also a superset of the ERC721 standard that allows for the minting
804  *  of the non-fungible tokens.
805  */
806 contract CryptoSagaHero is ERC721Token, Claimable, Pausable, AccessMint, AccessDeploy, AccessDeposit {
807 
808   string public constant name = "CryptoSaga Hero";
809   string public constant symbol = "HERO";
810   
811   struct HeroClass {
812     // ex) Soldier, Knight, Fighter...
813     string className;
814     // 0: Common, 1: Uncommon, 2: Rare, 3: Heroic, 4: Legendary.
815     uint8 classRank;
816     // 0: Human, 1: Celestial, 2: Demon, 3: Elf, 4: Dark Elf, 5: Yogoe, 6: Furry, 7: Dragonborn, 8: Undead, 9: Goblin, 10: Troll, 11: Slime, and more to come.
817     uint8 classRace;
818     // How old is this hero class? 
819     uint32 classAge;
820     // 0: Fighter, 1: Rogue, 2: Mage.
821     uint8 classType;
822 
823     // Possible max level of this class.
824     uint32 maxLevel; 
825     // 0: Water, 1: Fire, 2: Nature, 3: Light, 4: Darkness.
826     uint8 aura; 
827 
828     // Base stats of this hero type. 
829     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
830     uint32[5] baseStats;
831     // Minimum IVs for stats. 
832     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
833     uint32[5] minIVForStats;
834     // Maximum IVs for stats.
835     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
836     uint32[5] maxIVForStats;
837     
838     // Number of currently instanced heroes.
839     uint32 currentNumberOfInstancedHeroes;
840   }
841     
842   struct HeroInstance {
843     // What is this hero's type? ex) John, Sally, Mark...
844     uint32 heroClassId;
845     
846     // Individual hero's name.
847     string heroName;
848     
849     // Current level of this hero.
850     uint32 currentLevel;
851     // Current exp of this hero.
852     uint32 currentExp;
853 
854     // Where has this hero been deployed? (0: Never depolyed ever.) ex) Dungeon Floor #1, Arena #5...
855     uint32 lastLocationId;
856     // When a hero is deployed, it takes time for the hero to return to the base. This is in Unix epoch.
857     uint256 availableAt;
858 
859     // Current stats of this hero. 
860     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
861     uint32[5] currentStats;
862     // The individual value for this hero's stats. 
863     // This will affect the current stats of heroes.
864     // 0: ATK	1: DEF 2: AGL	3: LUK 4: HP.
865     uint32[5] ivForStats;
866   }
867 
868   // Required exp for level up will increase when heroes level up.
869   // This defines how the value will increase.
870   uint32 public requiredExpIncreaseFactor = 100;
871 
872   // Required Gold for level up will increase when heroes level up.
873   // This defines how the value will increase.
874   uint256 public requiredGoldIncreaseFactor = 1000000000000000000;
875 
876   // Existing hero classes.
877   mapping(uint32 => HeroClass) public heroClasses;
878   // The number of hero classes ever defined.
879   uint32 public numberOfHeroClasses;
880 
881   // Existing hero instances.
882   // The key is _tokenId.
883   mapping(uint256 => HeroInstance) public tokenIdToHeroInstance;
884   // The number of tokens ever minted. This works as the serial number.
885   uint256 public numberOfTokenIds;
886 
887   // Gold contract.
888   Gold public goldContract;
889 
890   // Deposit of players (in Gold).
891   mapping(address => uint256) public addressToGoldDeposit;
892 
893   // Random seed.
894   uint32 private seed = 0;
895 
896   // Event that is fired when a hero type defined.
897   event DefineType(
898     address indexed _by,
899     uint32 indexed _typeId,
900     string _className
901   );
902 
903   // Event that is fired when a hero is upgraded.
904   event LevelUp(
905     address indexed _by,
906     uint256 indexed _tokenId,
907     uint32 _newLevel
908   );
909 
910   // Event that is fired when a hero is deployed.
911   event Deploy(
912     address indexed _by,
913     uint256 indexed _tokenId,
914     uint32 _locationId,
915     uint256 _duration
916   );
917 
918   // @dev Get the class's entire infomation.
919   function getClassInfo(uint32 _classId)
920     external view
921     returns (string className, uint8 classRank, uint8 classRace, uint32 classAge, uint8 classType, uint32 maxLevel, uint8 aura, uint32[5] baseStats, uint32[5] minIVs, uint32[5] maxIVs) 
922   {
923     var _cl = heroClasses[_classId];
924     return (_cl.className, _cl.classRank, _cl.classRace, _cl.classAge, _cl.classType, _cl.maxLevel, _cl.aura, _cl.baseStats, _cl.minIVForStats, _cl.maxIVForStats);
925   }
926 
927   // @dev Get the class's name.
928   function getClassName(uint32 _classId)
929     external view
930     returns (string)
931   {
932     return heroClasses[_classId].className;
933   }
934 
935   // @dev Get the class's rank.
936   function getClassRank(uint32 _classId)
937     external view
938     returns (uint8)
939   {
940     return heroClasses[_classId].classRank;
941   }
942 
943   // @dev Get the heroes ever minted for the class.
944   function getClassMintCount(uint32 _classId)
945     external view
946     returns (uint32)
947   {
948     return heroClasses[_classId].currentNumberOfInstancedHeroes;
949   }
950 
951   // @dev Get the hero's entire infomation.
952   function getHeroInfo(uint256 _tokenId)
953     external view
954     returns (uint32 classId, string heroName, uint32 currentLevel, uint32 currentExp, uint32 lastLocationId, uint256 availableAt, uint32[5] currentStats, uint32[5] ivs, uint32 bp)
955   {
956     HeroInstance memory _h = tokenIdToHeroInstance[_tokenId];
957     var _bp = _h.currentStats[0] + _h.currentStats[1] + _h.currentStats[2] + _h.currentStats[3] + _h.currentStats[4];
958     return (_h.heroClassId, _h.heroName, _h.currentLevel, _h.currentExp, _h.lastLocationId, _h.availableAt, _h.currentStats, _h.ivForStats, _bp);
959   }
960 
961   // @dev Get the hero's class id.
962   function getHeroClassId(uint256 _tokenId)
963     external view
964     returns (uint32)
965   {
966     return tokenIdToHeroInstance[_tokenId].heroClassId;
967   }
968 
969   // @dev Get the hero's name.
970   function getHeroName(uint256 _tokenId)
971     external view
972     returns (string)
973   {
974     return tokenIdToHeroInstance[_tokenId].heroName;
975   }
976 
977   // @dev Get the hero's level.
978   function getHeroLevel(uint256 _tokenId)
979     external view
980     returns (uint32)
981   {
982     return tokenIdToHeroInstance[_tokenId].currentLevel;
983   }
984   
985   // @dev Get the hero's location.
986   function getHeroLocation(uint256 _tokenId)
987     external view
988     returns (uint32)
989   {
990     return tokenIdToHeroInstance[_tokenId].lastLocationId;
991   }
992 
993   // @dev Get the time when the hero become available.
994   function getHeroAvailableAt(uint256 _tokenId)
995     external view
996     returns (uint256)
997   {
998     return tokenIdToHeroInstance[_tokenId].availableAt;
999   }
1000 
1001   // @dev Get the hero's BP.
1002   function getHeroBP(uint256 _tokenId)
1003     public view
1004     returns (uint32)
1005   {
1006     var _tmp = tokenIdToHeroInstance[_tokenId].currentStats;
1007     return (_tmp[0] + _tmp[1] + _tmp[2] + _tmp[3] + _tmp[4]);
1008   }
1009 
1010   // @dev Get the hero's required gold for level up.
1011   function getHeroRequiredGoldForLevelUp(uint256 _tokenId)
1012     public view
1013     returns (uint256)
1014   {
1015     return (uint256(2) ** (tokenIdToHeroInstance[_tokenId].currentLevel / 10)) * requiredGoldIncreaseFactor;
1016   }
1017 
1018   // @dev Get the hero's required exp for level up.
1019   function getHeroRequiredExpForLevelUp(uint256 _tokenId)
1020     public view
1021     returns (uint32)
1022   {
1023     return ((tokenIdToHeroInstance[_tokenId].currentLevel + 2) * requiredExpIncreaseFactor);
1024   }
1025 
1026   // @dev Get the deposit of gold of the player.
1027   function getGoldDepositOfAddress(address _address)
1028     external view
1029     returns (uint256)
1030   {
1031     return addressToGoldDeposit[_address];
1032   }
1033 
1034   // @dev Get the token id of the player's #th token.
1035   function getTokenIdOfAddressAndIndex(address _address, uint256 _index)
1036     external view
1037     returns (uint256)
1038   {
1039     return tokensOf(_address)[_index];
1040   }
1041 
1042   // @dev Get the total BP of the player.
1043   function getTotalBPOfAddress(address _address)
1044     external view
1045     returns (uint32)
1046   {
1047     var _tokens = tokensOf(_address);
1048     uint32 _totalBP = 0;
1049     for (uint256 i = 0; i < _tokens.length; i ++) {
1050       _totalBP += getHeroBP(_tokens[i]);
1051     }
1052     return _totalBP;
1053   }
1054 
1055   // @dev Set the hero's name.
1056   function setHeroName(uint256 _tokenId, string _name)
1057     onlyOwnerOf(_tokenId)
1058     public
1059   {
1060     tokenIdToHeroInstance[_tokenId].heroName = _name;
1061   }
1062 
1063   // @dev Set the address of the contract that represents ERC20 Gold.
1064   function setGoldContract(address _contractAddress)
1065     onlyOwner
1066     public
1067   {
1068     goldContract = Gold(_contractAddress);
1069   }
1070 
1071   // @dev Set the required golds to level up a hero.
1072   function setRequiredExpIncreaseFactor(uint32 _value)
1073     onlyOwner
1074     public
1075   {
1076     requiredExpIncreaseFactor = _value;
1077   }
1078 
1079   // @dev Set the required golds to level up a hero.
1080   function setRequiredGoldIncreaseFactor(uint256 _value)
1081     onlyOwner
1082     public
1083   {
1084     requiredGoldIncreaseFactor = _value;
1085   }
1086 
1087   // @dev Contructor.
1088   function CryptoSagaHero(address _goldAddress)
1089     public
1090   {
1091     require(_goldAddress != address(0));
1092 
1093     // Assign Gold contract.
1094     setGoldContract(_goldAddress);
1095 
1096     // Initial heroes.
1097     // Name, Rank, Race, Age, Type, Max Level, Aura, Stats.
1098     defineType("Archangel", 4, 1, 13540, 0, 99, 3, [uint32(74), 75, 57, 99, 95], [uint32(8), 6, 8, 5, 5], [uint32(8), 10, 10, 6, 6]);
1099     defineType("Shadowalker", 3, 4, 134, 1, 75, 4, [uint32(45), 35, 60, 80, 40], [uint32(3), 2, 10, 4, 5], [uint32(5), 5, 10, 7, 5]);
1100     defineType("Pyromancer", 2, 0, 14, 2, 50, 1, [uint32(50), 28, 17, 40, 35], [uint32(5), 3, 2, 3, 3], [uint32(8), 4, 3, 4, 5]);
1101     defineType("Magician", 1, 3, 224, 2, 30, 0, [uint32(35), 15, 25, 25, 30], [uint32(3), 1, 2, 2, 2], [uint32(5), 2, 3, 3, 3]);
1102     defineType("Farmer", 0, 0, 59, 0, 15, 2, [uint32(10), 22, 8, 15, 25], [uint32(1), 2, 1, 1, 2], [uint32(1), 3, 1, 2, 3]);
1103   }
1104 
1105   // @dev Define a new hero type (class).
1106   function defineType(string _className, uint8 _classRank, uint8 _classRace, uint32 _classAge, uint8 _classType, uint32 _maxLevel, uint8 _aura, uint32[5] _baseStats, uint32[5] _minIVForStats, uint32[5] _maxIVForStats)
1107     onlyOwner
1108     public
1109   {
1110     require(_classRank < 5);
1111     require(_classType < 3);
1112     require(_aura < 5);
1113     require(_minIVForStats[0] <= _maxIVForStats[0] && _minIVForStats[1] <= _maxIVForStats[1] && _minIVForStats[2] <= _maxIVForStats[2] && _minIVForStats[3] <= _maxIVForStats[3] && _minIVForStats[4] <= _maxIVForStats[4]);
1114 
1115     HeroClass memory _heroType = HeroClass({
1116       className: _className,
1117       classRank: _classRank,
1118       classRace: _classRace,
1119       classAge: _classAge,
1120       classType: _classType,
1121       maxLevel: _maxLevel,
1122       aura: _aura,
1123       baseStats: _baseStats,
1124       minIVForStats: _minIVForStats,
1125       maxIVForStats: _maxIVForStats,
1126       currentNumberOfInstancedHeroes: 0
1127     });
1128 
1129     // Save the hero class.
1130     heroClasses[numberOfHeroClasses] = _heroType;
1131 
1132     // Fire event.
1133     DefineType(msg.sender, numberOfHeroClasses, _heroType.className);
1134 
1135     // Increment number of hero classes.
1136     numberOfHeroClasses ++;
1137 
1138   }
1139 
1140   // @dev Mint a new hero, with _heroClassId.
1141   function mint(address _owner, uint32 _heroClassId)
1142     onlyAccessMint
1143     public
1144     returns (uint256)
1145   {
1146     require(_owner != address(0));
1147     require(_heroClassId < numberOfHeroClasses);
1148 
1149     // The information of the hero's class.
1150     var _heroClassInfo = heroClasses[_heroClassId];
1151 
1152     // Mint ERC721 token.
1153     _mint(_owner, numberOfTokenIds);
1154 
1155     // Build random IVs for this hero instance.
1156     uint32[5] memory _ivForStats;
1157     uint32[5] memory _initialStats;
1158     for (uint8 i = 0; i < 5; i++) {
1159       _ivForStats[i] = (random(_heroClassInfo.maxIVForStats[i] + 1, _heroClassInfo.minIVForStats[i]));
1160       _initialStats[i] = _heroClassInfo.baseStats[i] + _ivForStats[i];
1161     }
1162 
1163     // Temporary hero instance.
1164     HeroInstance memory _heroInstance = HeroInstance({
1165       heroClassId: _heroClassId,
1166       heroName: "",
1167       currentLevel: 1,
1168       currentExp: 0,
1169       lastLocationId: 0,
1170       availableAt: now,
1171       currentStats: _initialStats,
1172       ivForStats: _ivForStats
1173     });
1174 
1175     // Save the hero instance.
1176     tokenIdToHeroInstance[numberOfTokenIds] = _heroInstance;
1177 
1178     // Increment number of token ids.
1179     // This will only increment when new token is minted, and will never be decemented when the token is burned.
1180     numberOfTokenIds ++;
1181 
1182      // Increment instanced number of heroes.
1183     _heroClassInfo.currentNumberOfInstancedHeroes ++;
1184 
1185     return numberOfTokenIds - 1;
1186   }
1187 
1188   // @dev Set where the heroes are deployed, and when they will return.
1189   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1190   function deploy(uint256 _tokenId, uint32 _locationId, uint256 _duration)
1191     onlyAccessDeploy
1192     public
1193     returns (bool)
1194   {
1195     // The hero should be possessed by anybody.
1196     require(ownerOf(_tokenId) != address(0));
1197 
1198     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1199 
1200     // The character should be avaiable. 
1201     require(_heroInstance.availableAt <= now);
1202 
1203     _heroInstance.lastLocationId = _locationId;
1204     _heroInstance.availableAt = now + _duration;
1205 
1206     // As the hero has been deployed to another place, fire event.
1207     Deploy(msg.sender, _tokenId, _locationId, _duration);
1208   }
1209 
1210   // @dev Add exp.
1211   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1212   function addExp(uint256 _tokenId, uint32 _exp)
1213     onlyAccessDeploy
1214     public
1215     returns (bool)
1216   {
1217     // The hero should be possessed by anybody.
1218     require(ownerOf(_tokenId) != address(0));
1219 
1220     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1221 
1222     var _newExp = _heroInstance.currentExp + _exp;
1223 
1224     // Sanity check to ensure we don't overflow.
1225     require(_newExp == uint256(uint128(_newExp)));
1226 
1227     _heroInstance.currentExp += _newExp;
1228 
1229   }
1230 
1231   // @dev Add deposit.
1232   //  This is intended to be called by Dungeon, Arena, Guild contracts.
1233   function addDeposit(address _to, uint256 _amount)
1234     onlyAccessDeposit
1235     public
1236   {
1237     // Increment deposit.
1238     addressToGoldDeposit[_to] += _amount;
1239   }
1240 
1241   // @dev Level up the hero with _tokenId.
1242   //  This function is called by the owner of the hero.
1243   function levelUp(uint256 _tokenId)
1244     onlyOwnerOf(_tokenId) whenNotPaused
1245     public
1246   {
1247 
1248     // Hero instance.
1249     var _heroInstance = tokenIdToHeroInstance[_tokenId];
1250 
1251     // The character should be avaiable. (Should have already returned from the dungeons, arenas, etc.)
1252     require(_heroInstance.availableAt <= now);
1253 
1254     // The information of the hero's class.
1255     var _heroClassInfo = heroClasses[_heroInstance.heroClassId];
1256 
1257     // Hero shouldn't level up exceed its max level.
1258     require(_heroInstance.currentLevel < _heroClassInfo.maxLevel);
1259 
1260     // Required Exp.
1261     var requiredExp = getHeroRequiredExpForLevelUp(_tokenId);
1262 
1263     // Need to have enough exp.
1264     require(_heroInstance.currentExp >= requiredExp);
1265 
1266     // Required Gold.
1267     var requiredGold = getHeroRequiredGoldForLevelUp(_tokenId);
1268 
1269     // Owner of token.
1270     var _ownerOfToken = ownerOf(_tokenId);
1271 
1272     // Need to have enough Gold balance.
1273     require(addressToGoldDeposit[_ownerOfToken] >= requiredGold);
1274 
1275     // Increase Level.
1276     _heroInstance.currentLevel += 1;
1277 
1278     // Increase Stats.
1279     for (uint8 i = 0; i < 5; i++) {
1280       _heroInstance.currentStats[i] = _heroClassInfo.baseStats[i] + (_heroInstance.currentLevel - 1) * _heroInstance.ivForStats[i];
1281     }
1282     
1283     // Deduct exp.
1284     _heroInstance.currentExp -= requiredExp;
1285 
1286     // Deduct gold.
1287     addressToGoldDeposit[_ownerOfToken] -= requiredGold;
1288 
1289     // Fire event.
1290     LevelUp(msg.sender, _tokenId, _heroInstance.currentLevel);
1291   }
1292 
1293   // @dev Transfer deposit (with the allowance pattern.)
1294   function transferDeposit(uint256 _amount)
1295     whenNotPaused
1296     public
1297   {
1298     require(goldContract.allowance(msg.sender, this) >= _amount);
1299 
1300     // Send msg.sender's Gold to this contract.
1301     if (goldContract.transferFrom(msg.sender, this, _amount)) {
1302        // Increment deposit.
1303       addressToGoldDeposit[msg.sender] += _amount;
1304     }
1305   }
1306 
1307   // @dev Withdraw deposit.
1308   function withdrawDeposit(uint256 _amount)
1309     public
1310   {
1311     require(addressToGoldDeposit[msg.sender] >= _amount);
1312 
1313     // Send deposit of Golds to msg.sender. (Rather minting...)
1314     if (goldContract.transfer(msg.sender, _amount)) {
1315       // Decrement deposit.
1316       addressToGoldDeposit[msg.sender] -= _amount;
1317     }
1318   }
1319 
1320   // @dev return a pseudo random number between lower and upper bounds
1321   function random(uint32 _upper, uint32 _lower)
1322     private
1323     returns (uint32)
1324   {
1325     require(_upper > _lower);
1326 
1327     seed = uint32(keccak256(keccak256(block.blockhash(block.number), seed), now));
1328     return seed % (_upper - _lower) + _lower;
1329   }
1330 
1331 }
1332 
1333 
1334 /**
1335  * @title CryptoSagaCorrectedHeroStats
1336  * @dev Corrected hero stats is needed to fix the bug in hero stats.
1337  */
1338 contract CryptoSagaCorrectedHeroStats {
1339 
1340   // The hero contract.
1341   CryptoSagaHero private heroContract;
1342 
1343   // @dev Constructor.
1344   function CryptoSagaCorrectedHeroStats(address _heroContractAddress)
1345     public
1346   {
1347     heroContract = CryptoSagaHero(_heroContractAddress);
1348   }
1349 
1350   // @dev Get the hero's stats and some other infomation.
1351   function getCorrectedStats(uint256 _tokenId)
1352     external view
1353     returns (uint32 currentLevel, uint32 currentExp, uint32[5] currentStats, uint32[5] ivs, uint32 bp)
1354   {
1355     var (, , _currentLevel, _currentExp, , , _currentStats, _ivs, ) = heroContract.getHeroInfo(_tokenId);
1356     
1357     if (_currentLevel != 1) {
1358       for (uint8 i = 0; i < 5; i ++) {
1359         _currentStats[i] += _ivs[i];
1360       }
1361     }
1362 
1363     var _bp = _currentStats[0] + _currentStats[1] + _currentStats[2] + _currentStats[3] + _currentStats[4];
1364     return (_currentLevel, _currentExp, _currentStats, _ivs, _bp);
1365   }
1366 
1367   // @dev Get corrected total BP of the address.
1368   function getCorrectedTotalBPOfAddress(address _address)
1369     external view
1370     returns (uint32)
1371   {
1372     var _balance = heroContract.balanceOf(_address);
1373 
1374     uint32 _totalBP = 0;
1375 
1376     for (uint256 i = 0; i < _balance; i ++) {
1377       var (, , _currentLevel, , , , _currentStats, _ivs, ) = heroContract.getHeroInfo(heroContract.getTokenIdOfAddressAndIndex(_address, i));
1378       if (_currentLevel != 1) {
1379         for (uint8 j = 0; j < 5; j ++) {
1380           _currentStats[j] += _ivs[j];
1381         }
1382       }
1383       _totalBP += (_currentStats[0] + _currentStats[1] + _currentStats[2] + _currentStats[3] + _currentStats[4]);
1384     }
1385 
1386     return _totalBP;
1387   }
1388 
1389   // @dev Get corrected total BP of the address.
1390   function getCorrectedTotalBPOfTokens(uint256[] _tokens)
1391     external view
1392     returns (uint32)
1393   {
1394     uint32 _totalBP = 0;
1395 
1396     for (uint256 i = 0; i < _tokens.length; i ++) {
1397       var (, , _currentLevel, , , , _currentStats, _ivs, ) = heroContract.getHeroInfo(_tokens[i]);
1398       if (_currentLevel != 1) {
1399         for (uint8 j = 0; j < 5; j ++) {
1400           _currentStats[j] += _ivs[j];
1401         }
1402       }
1403       _totalBP += (_currentStats[0] + _currentStats[1] + _currentStats[2] + _currentStats[3] + _currentStats[4]);
1404     }
1405 
1406     return _totalBP;
1407   }
1408 }
1409 
1410 
1411 /**
1412  * @title CryptoSagaDungeonProgress
1413  * @dev Storage contract for progress of dungeons.
1414  */
1415 contract CryptoSagaDungeonProgress is Claimable, AccessDeploy {
1416 
1417   // The progress of the player in dungeons.
1418   mapping(address => uint32[25]) public addressToProgress;
1419 
1420   // @dev Get progress.
1421   function getProgressOfAddressAndId(address _address, uint32 _id)
1422     external view
1423     returns (uint32)
1424   {
1425     var _progressList = addressToProgress[_address];
1426     return _progressList[_id];
1427   }
1428 
1429   // @dev Increment progress.
1430   function incrementProgressOfAddressAndId(address _address, uint32 _id)
1431     onlyAccessDeploy
1432     public
1433   {
1434     var _progressList = addressToProgress[_address];
1435     _progressList[_id]++;
1436     addressToProgress[_address] = _progressList;
1437   }
1438 }
1439 
1440 
1441 /**
1442  * @title CryptoSagaDungeonVer1
1443  * @dev The actual gameplay is done by this contract. Version 1.0.1.
1444  */
1445 contract CryptoSagaDungeonVer1 is Claimable, Pausable {
1446 
1447   struct EnemyCombination {
1448     // Is non-default combintion?
1449     bool isPersonalized;
1450     // Enemy slots' class Id.
1451     uint32[4] enemySlotClassIds;
1452   }
1453 
1454   struct PlayRecord {
1455     // This is needed for reconstructing the record.
1456     uint32 initialSeed;
1457     // The progress of the dugoeon when this play record made.
1458     uint32 progress;
1459     // Hero's token ids.
1460     uint256[4] tokenIds;
1461     // Unit's class ids. 0 ~ 3: Heroes. 4 ~ 7: Mobs.
1462     uint32[8] unitClassIds;
1463     // Unit's levels. 0 ~ 3: Heroes. 4 ~ 7: Mobs.
1464     uint32[8] unitLevels;
1465     // Exp reward given.
1466     uint32 expReward;
1467     // Gold Reward given.
1468     uint256 goldReward;
1469   }
1470 
1471   // This information can be reconstructed with seed and dateTime.
1472   // In order for the optimization this won't be really used.
1473   struct TurnInfo {
1474     // Number of turns before a team was vanquished.
1475     uint8 turnLength;
1476     // Turn order of units.
1477     uint8[8] turnOrder;
1478     // Defender list. (The unit that is attacked.)
1479     uint8[24] defenderList;
1480     // Damage list. (The damage given to the defender.)
1481     uint32[24] damageList;
1482     // Heroes' original Exps.
1483     uint32[4] originalExps;
1484   }
1485 
1486   // Progress contract.
1487   CryptoSagaDungeonProgress private progressContract;
1488 
1489   // The hero contract.
1490   CryptoSagaHero private heroContract;
1491 
1492   // Corrected hero stats contract.
1493   CryptoSagaCorrectedHeroStats private correctedHeroContract;
1494 
1495   // Gold contract.
1496   Gold public goldContract;
1497 
1498   // Card contract.
1499   CryptoSagaCard public cardContract;
1500 
1501   // The location Id of this contract.
1502   // Will be used when calling deploy function of hero contract.
1503   uint32 public locationId = 0;
1504 
1505   // The dungeon cooldown time. (Default value: 15 mins.)
1506   uint256 public coolDungeon = 900;
1507 
1508   // Hero cooldown time. (Default value: 60 mins.)
1509   uint256 public coolHero = 3600;
1510 
1511   // The exp reward when clearing this dungeon.
1512   uint32 public expReward = 100;
1513 
1514   // The Gold reward when clearing this dungeon.
1515   uint256 public goldReward = 1000000000000000000;
1516 
1517   // The previous dungeon that should be cleared.
1518   uint32 public previousDungeonId;
1519 
1520   // The progress of the previous dungeon that should be cleared.
1521   uint32 public requiredProgressOfPreviousDungeon;
1522 
1523   // Turn data save.
1524   bool public isTurnDataSaved = true;
1525 
1526   // The enemies in this dungeon for the player.
1527   mapping(address => EnemyCombination) public addressToEnemyCombination;
1528 
1529   // Last game's play datetime.
1530   mapping(address => uint256) public addressToPlayRecordDateTime;
1531 
1532   // Last game's record of the player.
1533   mapping(address => PlayRecord) public addressToPlayRecord;
1534 
1535   // Additional information on last game's record of the player.
1536   mapping(address => TurnInfo) public addressToTurnInfo;
1537 
1538   // List of the Mobs possibly appear in this dungeon.
1539   uint32[] public possibleMobClasses;
1540 
1541   // Initial enemy combination.
1542   // This will be shown when there's no play record.
1543   EnemyCombination public initialEnemyCombination;
1544 
1545   // Random seed.
1546   uint32 private seed = 0;
1547 
1548   // Event that is fired when a player try to clear this dungeon.
1549   event TryDungeon(
1550     address indexed _by,
1551     uint32 _tryingProgress,
1552     uint32 _progress,
1553     bool _isSuccess
1554   );
1555 
1556   // @dev Get enemy combination.
1557   function getEnemyCombinationOfAddress(address _address)
1558     external view
1559     returns (uint32[4])
1560   {
1561     // Retrieve enemy information.
1562     // Instead of null check, isPersonalized check will tell the personalized mobs for this player exist.
1563     var _enemyCombination = addressToEnemyCombination[_address];
1564     if (_enemyCombination.isPersonalized == false) {
1565       // Then let's use default value.
1566       _enemyCombination = initialEnemyCombination;
1567     }
1568     return _enemyCombination.enemySlotClassIds;
1569   }
1570 
1571   // @dev Get initial enemy combination.
1572   function getInitialEnemyCombination()
1573     external view
1574     returns (uint32[4])
1575   {
1576     return initialEnemyCombination.enemySlotClassIds;
1577   }
1578 
1579   // @dev Get play record's datetime.
1580   function getLastPlayDateTime(address _address)
1581     external view
1582     returns (uint256 dateTime)
1583   {
1584     return addressToPlayRecordDateTime[_address];
1585   }
1586 
1587   // @dev Get previous game record.
1588   function getPlayRecord(address _address)
1589     external view
1590     returns (uint32 initialSeed, uint32 progress, uint256[4] heroTokenIds, uint32[8] uintClassIds, uint32[8] unitLevels, uint32 expRewardGiven, uint256 goldRewardGiven, uint8 turnLength, uint8[8] turnOrder, uint8[24] defenderList, uint32[24] damageList)
1591   {
1592     PlayRecord memory _p = addressToPlayRecord[_address];
1593     TurnInfo memory _t = addressToTurnInfo[_address];
1594     return (_p.initialSeed, _p.progress, _p.tokenIds, _p.unitClassIds, _p.unitLevels, _p.expReward, _p.goldReward, _t.turnLength, _t.turnOrder, _t.defenderList, _t.damageList);
1595   }
1596 
1597   // @dev Get previous game record.
1598   function getPlayRecordNoTurnData(address _address)
1599     external view
1600     returns (uint32 initialSeed, uint32 progress, uint256[4] heroTokenIds, uint32[8] uintClassIds, uint32[8] unitLevels, uint32 expRewardGiven, uint256 goldRewardGiven)
1601   {
1602     PlayRecord memory _p = addressToPlayRecord[_address];
1603     return (_p.initialSeed, _p.progress, _p.tokenIds, _p.unitClassIds, _p.unitLevels, _p.expReward, _p.goldReward);
1604   }
1605 
1606   // @dev Set location id.
1607   function setLocationId(uint32 _value)
1608     onlyOwner
1609     public
1610   {
1611     locationId = _value;
1612   }
1613 
1614   // @dev Set cooldown of this dungeon.
1615   function setCoolDungeon(uint32 _value)
1616     onlyOwner
1617     public
1618   {
1619     coolDungeon = _value;
1620   }
1621 
1622   // @dev Set cooldown of heroes entered this dungeon.
1623   function setCoolHero(uint32 _value)
1624     onlyOwner
1625     public
1626   {
1627     coolHero = _value;
1628   }
1629 
1630   // @dev Set the Exp given to the player when clearing this dungeon.
1631   function setExpReward(uint32 _value)
1632     onlyOwner
1633     public
1634   {
1635     expReward = _value;
1636   }
1637 
1638   // @dev Set the Golds given to the player when clearing this dungeon.
1639   function setGoldReward(uint256 _value)
1640     onlyOwner
1641     public
1642   {
1643     goldReward = _value;
1644   }
1645 
1646   // @dev Set wether the turn data saved or not.
1647   function setIsTurnDataSaved(bool _value)
1648     onlyOwner
1649     public
1650   {
1651     isTurnDataSaved = _value;
1652   }
1653 
1654   // @dev Set initial enemy combination.
1655   function setInitialEnemyCombination(uint32[4] _enemySlotClassIds)
1656     onlyOwner
1657     public
1658   {
1659     initialEnemyCombination.isPersonalized = false;
1660     initialEnemyCombination.enemySlotClassIds = _enemySlotClassIds;
1661   }
1662 
1663   // @dev Set previous dungeon.
1664   function setPreviousDungeoonId(uint32 _dungeonId)
1665     onlyOwner
1666     public
1667   {
1668     previousDungeonId = _dungeonId;
1669   }
1670 
1671   // @dev Set required progress of previous dungeon.
1672   function setRequiredProgressOfPreviousDungeon(uint32 _progress)
1673     onlyOwner
1674     public
1675   {
1676     requiredProgressOfPreviousDungeon = _progress;
1677   }
1678 
1679   // @dev Set possible mobs in this dungeon.
1680   function setPossibleMobs(uint32[] _classIds)
1681     onlyOwner
1682     public
1683   {
1684     possibleMobClasses = _classIds;
1685   }
1686 
1687   // @dev Constructor.
1688   function CryptoSagaDungeonVer1(address _progressAddress, address _heroContractAddress, address _correctedHeroContractAddress, address _cardContractAddress, address _goldContractAddress, uint32 _locationId, uint256 _coolDungeon, uint256 _coolHero, uint32 _expReward, uint256 _goldReward, uint32 _previousDungeonId, uint32 _requiredProgressOfPreviousDungeon, uint32[4] _enemySlotClassIds, bool _isTurnDataSaved)
1689     public
1690   {
1691     progressContract = CryptoSagaDungeonProgress(_progressAddress);
1692     heroContract = CryptoSagaHero(_heroContractAddress);
1693     correctedHeroContract = CryptoSagaCorrectedHeroStats(_correctedHeroContractAddress);
1694     cardContract = CryptoSagaCard(_cardContractAddress);
1695     goldContract = Gold(_goldContractAddress);
1696     
1697     locationId = _locationId;
1698     coolDungeon = _coolDungeon;
1699     coolHero = _coolHero;
1700     expReward = _expReward;
1701     goldReward = _goldReward;
1702 
1703     previousDungeonId = _previousDungeonId;
1704     requiredProgressOfPreviousDungeon = _requiredProgressOfPreviousDungeon;
1705 
1706     initialEnemyCombination.isPersonalized = false;
1707     initialEnemyCombination.enemySlotClassIds = _enemySlotClassIds;
1708     
1709     isTurnDataSaved = _isTurnDataSaved;
1710   }
1711   
1712   // @dev Enter this dungeon.
1713   function enterDungeon(uint256[4] _tokenIds, uint32 _tryingProgress)
1714     whenNotPaused
1715     public
1716   {
1717     // Each hero should be different ids.
1718     require(_tokenIds[0] == 0 || (_tokenIds[0] != _tokenIds[1] && _tokenIds[0] != _tokenIds[2] && _tokenIds[0] != _tokenIds[3]));
1719     require(_tokenIds[1] == 0 || (_tokenIds[1] != _tokenIds[0] && _tokenIds[1] != _tokenIds[2] && _tokenIds[1] != _tokenIds[3]));
1720     require(_tokenIds[2] == 0 || (_tokenIds[2] != _tokenIds[0] && _tokenIds[2] != _tokenIds[1] && _tokenIds[2] != _tokenIds[3]));
1721     require(_tokenIds[3] == 0 || (_tokenIds[3] != _tokenIds[0] && _tokenIds[3] != _tokenIds[1] && _tokenIds[3] != _tokenIds[2]));
1722 
1723     // Check the previous dungeon's progress.
1724     if (requiredProgressOfPreviousDungeon != 0) {
1725       require(progressContract.getProgressOfAddressAndId(msg.sender, previousDungeonId) >= requiredProgressOfPreviousDungeon);
1726     }
1727 
1728     // 1 is the minimum prgress.
1729     require(_tryingProgress > 0);
1730 
1731     // Only up to 'progress + 1' is allowed.
1732     require(_tryingProgress <= progressContract.getProgressOfAddressAndId(msg.sender, locationId) + 1);
1733 
1734     // Check dungeon availability.
1735     require(addressToPlayRecordDateTime[msg.sender] + coolDungeon <= now);
1736 
1737     // Check ownership and availability check.
1738     require(checkOwnershipAndAvailability(msg.sender, _tokenIds));
1739 
1740     // Set play record datetime.
1741     addressToPlayRecordDateTime[msg.sender] = now;
1742 
1743     // Set seed.
1744     seed += uint32(now);
1745 
1746     // Define play record here.
1747     PlayRecord memory _playRecord;
1748     _playRecord.initialSeed = seed;
1749     _playRecord.progress = _tryingProgress;
1750     _playRecord.tokenIds[0] = _tokenIds[0];
1751     _playRecord.tokenIds[1] = _tokenIds[1];
1752     _playRecord.tokenIds[2] = _tokenIds[2];
1753     _playRecord.tokenIds[3] = _tokenIds[3];
1754 
1755     // The information that can give additional information.
1756     TurnInfo memory _turnInfo;
1757 
1758     // Step 1: Retrieve Hero information (0 ~ 3) & Enemy information (4 ~ 7).
1759 
1760     uint32[5][8] memory _unitStats; // Stats of units for given levels and class ids.
1761     uint8[2][8] memory _unitTypesAuras; // 0: Types of units for given levels and class ids. 1: Auras of units for given levels and class ids.
1762 
1763     // Retrieve deployed hero information.
1764     if (_tokenIds[0] != 0) {
1765       _playRecord.unitClassIds[0] = heroContract.getHeroClassId(_tokenIds[0]);
1766       (_playRecord.unitLevels[0], _turnInfo.originalExps[0], _unitStats[0], , ) = correctedHeroContract.getCorrectedStats(_tokenIds[0]);
1767       (, , , , _unitTypesAuras[0][0], , _unitTypesAuras[0][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[0]);
1768     }
1769     if (_tokenIds[1] != 0) {
1770       _playRecord.unitClassIds[1] = heroContract.getHeroClassId(_tokenIds[1]);
1771       (_playRecord.unitLevels[1], _turnInfo.originalExps[1], _unitStats[1], , ) = correctedHeroContract.getCorrectedStats(_tokenIds[1]);
1772       (, , , , _unitTypesAuras[1][0], , _unitTypesAuras[1][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[1]);
1773     }
1774     if (_tokenIds[2] != 0) {
1775       _playRecord.unitClassIds[2] = heroContract.getHeroClassId(_tokenIds[2]);
1776       (_playRecord.unitLevels[2], _turnInfo.originalExps[2], _unitStats[2], , ) = correctedHeroContract.getCorrectedStats(_tokenIds[2]);
1777       (, , , , _unitTypesAuras[2][0], , _unitTypesAuras[2][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[2]);
1778     }
1779     if (_tokenIds[3] != 0) {
1780       _playRecord.unitClassIds[3] = heroContract.getHeroClassId(_tokenIds[3]);
1781       (_playRecord.unitLevels[3], _turnInfo.originalExps[3], _unitStats[3], , ) = correctedHeroContract.getCorrectedStats(_tokenIds[3]);
1782       (, , , , _unitTypesAuras[3][0], , _unitTypesAuras[3][1], , , ) = heroContract.getClassInfo(_playRecord.unitClassIds[3]);
1783     }
1784 
1785     // Retrieve enemy information.
1786     // Instead of null check, isPersonalized check will tell the personalized mobs for this player exist.
1787     var _enemyCombination = addressToEnemyCombination[msg.sender];
1788     if (_enemyCombination.isPersonalized == false) {
1789       // Then let's use default value.
1790       _enemyCombination = initialEnemyCombination;
1791     }
1792 
1793     uint32[5][8] memory _tmpEnemyBaseStatsAndIVs; // 0 ~ 3: Temp value for getting enemy base stats. 4 ~ 7: Temp value for getting enemy IVs.
1794 
1795     // Retrieve mobs' class information. 
1796     (, , , , _unitTypesAuras[4][0], , _unitTypesAuras[4][1], _tmpEnemyBaseStatsAndIVs[0], _tmpEnemyBaseStatsAndIVs[4], ) = heroContract.getClassInfo(_enemyCombination.enemySlotClassIds[0]);
1797     (, , , , _unitTypesAuras[5][0], , _unitTypesAuras[5][1], _tmpEnemyBaseStatsAndIVs[1], _tmpEnemyBaseStatsAndIVs[5], ) = heroContract.getClassInfo(_enemyCombination.enemySlotClassIds[1]);
1798     (, , , , _unitTypesAuras[6][0], , _unitTypesAuras[6][1], _tmpEnemyBaseStatsAndIVs[2], _tmpEnemyBaseStatsAndIVs[6], ) = heroContract.getClassInfo(_enemyCombination.enemySlotClassIds[2]);
1799     (, , , , _unitTypesAuras[7][0], , _unitTypesAuras[7][1], _tmpEnemyBaseStatsAndIVs[3], _tmpEnemyBaseStatsAndIVs[7], ) = heroContract.getClassInfo(_enemyCombination.enemySlotClassIds[3]);
1800 
1801     _playRecord.unitClassIds[4] = _enemyCombination.enemySlotClassIds[0];
1802     _playRecord.unitClassIds[5] = _enemyCombination.enemySlotClassIds[1];
1803     _playRecord.unitClassIds[6] = _enemyCombination.enemySlotClassIds[2];
1804     _playRecord.unitClassIds[7] = _enemyCombination.enemySlotClassIds[3];
1805     
1806     // Set level for enemies.
1807     _playRecord.unitLevels[4] = _tryingProgress;
1808     _playRecord.unitLevels[5] = _tryingProgress;
1809     _playRecord.unitLevels[6] = _tryingProgress;
1810     _playRecord.unitLevels[7] = _tryingProgress;
1811 
1812     // With _tryingProgress, _tmpEnemyBaseStatsAndIVs, we can get the current stats of mobs.
1813     for (uint8 i = 0; i < 5; i ++) {
1814       _unitStats[4][i] = _tmpEnemyBaseStatsAndIVs[0][i] + _playRecord.unitLevels[4] * _tmpEnemyBaseStatsAndIVs[4][i];
1815       _unitStats[5][i] = _tmpEnemyBaseStatsAndIVs[1][i] + _playRecord.unitLevels[5] * _tmpEnemyBaseStatsAndIVs[5][i];
1816       _unitStats[6][i] = _tmpEnemyBaseStatsAndIVs[2][i] + _playRecord.unitLevels[6] * _tmpEnemyBaseStatsAndIVs[6][i];
1817       _unitStats[7][i] = _tmpEnemyBaseStatsAndIVs[3][i] + _playRecord.unitLevels[7] * _tmpEnemyBaseStatsAndIVs[7][i];
1818     }
1819 
1820     // Step 2. Run the battle logic.
1821     
1822     // Firstly, we need to assign the unit's turn order with AGLs of the units.
1823     uint32[8] memory _unitAGLs;
1824     for (i = 0; i < 8; i ++) {
1825       _unitAGLs[i] = _unitStats[i][2];
1826     }
1827     _turnInfo.turnOrder = getOrder(_unitAGLs);
1828     
1829     // Fight for 24 turns. (8 units x 3 rounds.)
1830     _turnInfo.turnLength = 24;
1831     for (i = 0; i < 24; i ++) {
1832       if (_unitStats[4][4] == 0 && _unitStats[5][4] == 0 && _unitStats[6][4] == 0 && _unitStats[7][4] == 0) {
1833         _turnInfo.turnLength = i;
1834         break;
1835       } else if (_unitStats[0][4] == 0 && _unitStats[1][4] == 0 && _unitStats[2][4] == 0 && _unitStats[3][4] == 0) {
1836         _turnInfo.turnLength = i;
1837         break;
1838       }
1839       
1840       var _slotId = _turnInfo.turnOrder[(i % 8)];
1841       if (_slotId < 4 && _tokenIds[_slotId] == 0) {
1842         // This means the slot is empty.
1843         // Defender should be default value.
1844         _turnInfo.defenderList[i] = 127;
1845       } else if (_unitStats[_slotId][4] == 0) {
1846         // This means the unit on this slot is dead.
1847         // Defender should be default value.
1848         _turnInfo.defenderList[i] = 128;
1849       } else {
1850         // 1) Check number of attack targets that are alive.
1851         uint8 _targetSlotId = 255;
1852         if (_slotId < 4) {
1853           if (_unitStats[4][4] > 0)
1854             _targetSlotId = 4;
1855           else if (_unitStats[5][4] > 0)
1856             _targetSlotId = 5;
1857           else if (_unitStats[6][4] > 0)
1858             _targetSlotId = 6;
1859           else if (_unitStats[7][4] > 0)
1860             _targetSlotId = 7;
1861         } else {
1862           if (_unitStats[0][4] > 0)
1863             _targetSlotId = 0;
1864           else if (_unitStats[1][4] > 0)
1865             _targetSlotId = 1;
1866           else if (_unitStats[2][4] > 0)
1867             _targetSlotId = 2;
1868           else if (_unitStats[3][4] > 0)
1869             _targetSlotId = 3;
1870         }
1871         
1872         // Target is the defender.
1873         _turnInfo.defenderList[i] = _targetSlotId;
1874         
1875         // Base damage. (Attacker's ATK * 1.5 - Defender's DEF).
1876         uint32 _damage = 10;
1877         if ((_unitStats[_slotId][0] * 150 / 100) > _unitStats[_targetSlotId][1])
1878           _damage = max((_unitStats[_slotId][0] * 150 / 100) - _unitStats[_targetSlotId][1], 10);
1879         else
1880           _damage = 10;
1881 
1882         // Check miss / success.
1883         if ((_unitStats[_slotId][3] * 150 / 100) > _unitStats[_targetSlotId][2]) {
1884           if (min(max(((_unitStats[_slotId][3] * 150 / 100) - _unitStats[_targetSlotId][2]), 75), 99) <= random(100, 0))
1885             _damage = _damage * 0;
1886         }
1887         else {
1888           if (75 <= random(100, 0))
1889             _damage = _damage * 0;
1890         }
1891 
1892         // Is the attack critical?
1893         if (_unitStats[_slotId][3] > _unitStats[_targetSlotId][3]) {
1894           if (min(max((_unitStats[_slotId][3] - _unitStats[_targetSlotId][3]), 5), 75) > random(100, 0))
1895             _damage = _damage * 150 / 100;
1896         }
1897         else {
1898           if (5 > random(100, 0))
1899             _damage = _damage * 150 / 100;
1900         }
1901 
1902         // Is attacker has the advantageous Type?
1903         if (_unitTypesAuras[_slotId][0] == 0 && _unitTypesAuras[_targetSlotId][0] == 1) // Fighter > Rogue
1904           _damage = _damage * 125 / 100;
1905         else if (_unitTypesAuras[_slotId][0] == 1 && _unitTypesAuras[_targetSlotId][0] == 2) // Rogue > Mage
1906           _damage = _damage * 125 / 100;
1907         else if (_unitTypesAuras[_slotId][0] == 2 && _unitTypesAuras[_targetSlotId][0] == 0) // Mage > Fighter
1908           _damage = _damage * 125 / 100;
1909 
1910         // Is attacker has the advantageous Aura?
1911         if (_unitTypesAuras[_slotId][1] == 0 && _unitTypesAuras[_targetSlotId][1] == 1) // Water > Fire
1912           _damage = _damage * 150 / 100;
1913         else if (_unitTypesAuras[_slotId][1] == 1 && _unitTypesAuras[_targetSlotId][1] == 2) // Fire > Nature
1914           _damage = _damage * 150 / 100;
1915         else if (_unitTypesAuras[_slotId][1] == 2 && _unitTypesAuras[_targetSlotId][1] == 0) // Nature > Water
1916           _damage = _damage * 150 / 100;
1917         else if (_unitTypesAuras[_slotId][1] == 3 && _unitTypesAuras[_targetSlotId][1] == 4) // Light > Darkness
1918           _damage = _damage * 150 / 100;
1919         else if (_unitTypesAuras[_slotId][1] == 4 && _unitTypesAuras[_targetSlotId][1] == 3) // Darkness > Light
1920           _damage = _damage * 150 / 100;
1921         
1922         // Apply damage so that reduce hp of defender.
1923         if(_unitStats[_targetSlotId][4] > _damage)
1924           _unitStats[_targetSlotId][4] -= _damage;
1925         else
1926           _unitStats[_targetSlotId][4] = 0;
1927 
1928         // Save damage to play record.
1929         _turnInfo.damageList[i] = _damage;
1930       }
1931     }
1932     
1933     // Step 3. Apply the result of this battle.
1934 
1935     // Set heroes deployed.
1936     if (_tokenIds[0] != 0)
1937       heroContract.deploy(_tokenIds[0], locationId, coolHero);
1938     if (_tokenIds[1] != 0)
1939       heroContract.deploy(_tokenIds[1], locationId, coolHero);
1940     if (_tokenIds[2] != 0)
1941       heroContract.deploy(_tokenIds[2], locationId, coolHero);
1942     if (_tokenIds[3] != 0)
1943       heroContract.deploy(_tokenIds[3], locationId, coolHero);
1944 
1945     uint8 _deadEnemies = 0;
1946 
1947     // Check result.
1948     if (_unitStats[4][4] == 0)
1949       _deadEnemies ++;
1950     if (_unitStats[5][4] == 0)
1951       _deadEnemies ++;
1952     if (_unitStats[6][4] == 0)
1953       _deadEnemies ++;
1954     if (_unitStats[7][4] == 0)
1955       _deadEnemies ++;
1956       
1957     if (_deadEnemies == 4) {
1958       // Fire TryDungeon event.
1959       TryDungeon(msg.sender, _tryingProgress, progressContract.getProgressOfAddressAndId(msg.sender, locationId), true);
1960       
1961       // Check for progress.
1962       if (_tryingProgress == progressContract.getProgressOfAddressAndId(msg.sender, locationId) + 1) {
1963         // Increment progress.
1964         progressContract.incrementProgressOfAddressAndId(msg.sender, locationId);
1965         // Rewards.
1966         (_playRecord.expReward, _playRecord.goldReward) = giveReward(_tokenIds, _tryingProgress, _deadEnemies, false, _turnInfo.originalExps);
1967         // For every 10th floor(progress), Dungeon Chest card is given.
1968         if (_tryingProgress % 10 == 0) {
1969           cardContract.mint(msg.sender, 1, 3);
1970         }
1971       } else {
1972         // Rewards for already cleared dungeon.
1973         (_playRecord.expReward, _playRecord.goldReward) = giveReward(_tokenIds, _tryingProgress, _deadEnemies, true, _turnInfo.originalExps);
1974       }
1975 
1976       // New enemy combination for the player.
1977       createNewCombination(msg.sender);
1978     }
1979     else {
1980       // Fire TryDungeon event.
1981       TryDungeon(msg.sender, _tryingProgress, progressContract.getProgressOfAddressAndId(msg.sender, locationId), false);
1982 
1983       // Rewards.
1984       (_playRecord.expReward, _playRecord.goldReward) = giveReward(_tokenIds, _tryingProgress, _deadEnemies, false, _turnInfo.originalExps);
1985     }
1986 
1987     // Save the result of this gameplay.
1988     addressToPlayRecord[msg.sender] = _playRecord;
1989 
1990     // Save the turn data.
1991     // This is commented as this information can be reconstructed with intitial seed and date time.
1992     // By commenting this, we can reduce about 400k gas.
1993     if (isTurnDataSaved) {
1994       addressToTurnInfo[msg.sender] = _turnInfo;
1995     }
1996   }
1997 
1998   // @dev Check ownership.
1999   function checkOwnershipAndAvailability(address _playerAddress, uint256[4] _tokenIds)
2000     private view
2001     returns(bool)
2002   {
2003     if ((_tokenIds[0] == 0 || heroContract.ownerOf(_tokenIds[0]) == _playerAddress) && (_tokenIds[1] == 0 || heroContract.ownerOf(_tokenIds[1]) == _playerAddress) && (_tokenIds[2] == 0 || heroContract.ownerOf(_tokenIds[2]) == _playerAddress) && (_tokenIds[3] == 0 || heroContract.ownerOf(_tokenIds[3]) == _playerAddress)) {
2004       
2005       // Retrieve avail time of heroes.
2006       uint256[4] memory _heroAvailAts;
2007       if (_tokenIds[0] != 0)
2008         ( , , , , , _heroAvailAts[0], , , ) = heroContract.getHeroInfo(_tokenIds[0]);
2009       if (_tokenIds[1] != 0)
2010         ( , , , , , _heroAvailAts[1], , , ) = heroContract.getHeroInfo(_tokenIds[1]);
2011       if (_tokenIds[2] != 0)
2012         ( , , , , , _heroAvailAts[2], , , ) = heroContract.getHeroInfo(_tokenIds[2]);
2013       if (_tokenIds[3] != 0)
2014         ( , , , , , _heroAvailAts[3], , , ) = heroContract.getHeroInfo(_tokenIds[3]);
2015 
2016       if (_heroAvailAts[0] <= now && _heroAvailAts[1] <= now && _heroAvailAts[2] <= now && _heroAvailAts[3] <= now) {
2017         return true;
2018       } else {
2019         return false;
2020       }
2021     } else {
2022       return false;
2023     }
2024   }
2025 
2026   // @dev New combination of mobs.
2027   //  The combination is personalized by players, and refreshed when the dungeon cleared.
2028   function createNewCombination(address _playerAddress)
2029     private
2030   {
2031     EnemyCombination memory _newCombination;
2032     _newCombination.isPersonalized = true;
2033     for (uint8 i = 0; i < 4; i++) {
2034       _newCombination.enemySlotClassIds[i] = possibleMobClasses[random(uint32(possibleMobClasses.length), 0)];
2035     }
2036     addressToEnemyCombination[_playerAddress] = _newCombination;
2037   }
2038 
2039   // @dev Give rewards.
2040   function giveReward(uint256[4] _heroes, uint32 _progress, uint8 _numberOfKilledEnemies, bool _isClearedBefore, uint32[4] _originalExps)
2041     private
2042     returns (uint32 expRewardGiven, uint256 goldRewardGiven)
2043   {
2044     uint256 _goldRewardGiven;
2045     uint32 _expRewardGiven;
2046     if (_numberOfKilledEnemies != 4) {
2047       // In case lost.
2048       // Give baseline gold reward.
2049       _goldRewardGiven = goldReward / 25 * sqrt(_progress);
2050       _expRewardGiven = expReward * _numberOfKilledEnemies / 4 / 5 * sqrt(_progress / 4 + 1);
2051     } else if (_isClearedBefore == true) {
2052       // Did win, but this progress has been already cleared before.
2053       _goldRewardGiven = goldReward / 5 * sqrt(_progress);
2054       _expRewardGiven = expReward / 5 * sqrt(_progress / 4 + 1);
2055     } else {
2056       // Firstly cleared the progress.
2057       _goldRewardGiven = goldReward * sqrt(_progress);
2058       _expRewardGiven = expReward * sqrt(_progress / 4 + 1);
2059     }
2060 
2061     // Give reward Gold.
2062     goldContract.mint(msg.sender, _goldRewardGiven);
2063     
2064     // Give reward EXP.
2065     if(_heroes[0] != 0)
2066       heroContract.addExp(_heroes[0], uint32(2)**32 - _originalExps[0] + _expRewardGiven);
2067     if(_heroes[1] != 0)
2068       heroContract.addExp(_heroes[1], uint32(2)**32 - _originalExps[1] + _expRewardGiven);
2069     if(_heroes[2] != 0)
2070       heroContract.addExp(_heroes[2], uint32(2)**32 - _originalExps[2] + _expRewardGiven);
2071     if(_heroes[3] != 0)
2072       heroContract.addExp(_heroes[3], uint32(2)**32 - _originalExps[3] + _expRewardGiven);
2073 
2074     return (_expRewardGiven, _goldRewardGiven);
2075   }
2076 
2077   // @dev Return a pseudo random number between lower and upper bounds
2078   function random(uint32 _upper, uint32 _lower)
2079     private
2080     returns (uint32)
2081   {
2082     require(_upper > _lower);
2083 
2084     seed = seed % uint32(1103515245) + 12345;
2085     return seed % (_upper - _lower) + _lower;
2086   }
2087 
2088   // @dev Retreive order based on given array _by.
2089   function getOrder(uint32[8] _by)
2090     private pure
2091     returns (uint8[8])
2092   {
2093     uint8[8] memory _order = [uint8(0), 1, 2, 3, 4, 5, 6, 7];
2094     for (uint8 i = 0; i < 8; i ++) {
2095       for (uint8 j = i + 1; j < 8; j++) {
2096         if (_by[i] < _by[j]) {
2097           uint32 tmp1 = _by[i];
2098           _by[i] = _by[j];
2099           _by[j] = tmp1;
2100           uint8 tmp2 = _order[i];
2101           _order[i] = _order[j];
2102           _order[j] = tmp2;
2103         }
2104       }
2105     }
2106     return _order;
2107   }
2108 
2109   // @return Bigger value of two uint32s.
2110   function max(uint32 _value1, uint32 _value2)
2111     private pure
2112     returns (uint32)
2113   {
2114     if(_value1 >= _value2)
2115       return _value1;
2116     else
2117       return _value2;
2118   }
2119 
2120   // @return Bigger value of two uint32s.
2121   function min(uint32 _value1, uint32 _value2)
2122     private pure
2123     returns (uint32)
2124   {
2125     if(_value2 >= _value1)
2126       return _value1;
2127     else
2128       return _value2;
2129   }
2130 
2131   // @return Square root of the given value.
2132   function sqrt(uint32 _value) 
2133     private pure
2134     returns (uint32) 
2135   {
2136     uint32 z = (_value + 1) / 2;
2137     uint32 y = _value;
2138     while (z < y) {
2139       y = z;
2140       z = (_value / z + z) / 2;
2141     }
2142     return y;
2143   }
2144 
2145 }