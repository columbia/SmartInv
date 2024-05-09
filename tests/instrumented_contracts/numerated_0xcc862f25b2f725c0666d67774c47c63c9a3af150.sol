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
1334 
1335 /**
1336  * @title CryptoSagaCardSwapVer2
1337  * @dev This directly summons hero.
1338  */
1339 contract CryptoSagaCardSwapVer2 is CryptoSagaCardSwap, Pausable{
1340 
1341   // Eth will be sent to this wallet.
1342   address public wallet;
1343 
1344   // The hero contract.
1345   CryptoSagaHero public heroContract;
1346 
1347   // Gold contract.
1348   Gold public goldContract;
1349 
1350   // Eth-Summon price.
1351   uint256 public ethPrice = 20000000000000000; // 0.02 eth.
1352 
1353   // Gold-Summon price.
1354   uint256 public goldPrice = 100000000000000000000; // 100 G. Should worth around 0.00004 eth at launch.
1355 
1356   // Mileage Point Summon price.
1357   uint256 public mileagePointPrice = 100;
1358 
1359   // Blacklisted heroes.
1360   // This is needed in order to protect players, in case there exists any hero with critical issues.
1361   // We promise we will use this function carefully, and this won't be used for balancing the OP heroes.
1362   mapping(uint32 => bool) public blackList;
1363 
1364   // Mileage points of each player.
1365   mapping(address => uint256) public addressToMileagePoint;
1366 
1367   // Last timestamp of summoning a free hero.
1368   mapping(address => uint256) public addressToFreeSummonTimestamp;
1369 
1370   // Random seed.
1371   uint32 private seed = 0;
1372 
1373   // @dev Get the mileage points of given address.
1374   function getMileagePoint(address _address)
1375     public view
1376     returns (uint256)
1377   {
1378     return addressToMileagePoint[_address];
1379   }
1380 
1381   // @dev Get the summon timestamp of given address.
1382   function getFreeSummonTimestamp(address _address)
1383     public view
1384     returns (uint256)
1385   {
1386     return addressToFreeSummonTimestamp[_address];
1387   }
1388 
1389   // @dev Set the price of summoning a hero with Eth.
1390   function setEthPrice(uint256 _value)
1391     onlyOwner
1392     public
1393   {
1394     ethPrice = _value;
1395   }
1396 
1397   // @dev Set the price of summoning a hero with Gold.
1398   function setGoldPrice(uint256 _value)
1399     onlyOwner
1400     public
1401   {
1402     goldPrice = _value;
1403   }
1404 
1405   // @dev Set the price of summong a hero with Mileage Points.
1406   function setMileagePointPrice(uint256 _value)
1407     onlyOwner
1408     public
1409   {
1410     mileagePointPrice = _value;
1411   }
1412 
1413   // @dev Set blacklist.
1414   function setBlacklist(uint32 _classId, bool _value)
1415     onlyOwner
1416     public
1417   {
1418     blackList[_classId] = _value;
1419   }
1420 
1421   // @dev Increment mileage points.
1422   function addMileagePoint(address _beneficiary, uint256 _point)
1423     onlyOwner
1424     public
1425   {
1426     require(_beneficiary != address(0));
1427 
1428     addressToMileagePoint[_beneficiary] += _point;
1429   }
1430 
1431   // @dev Contructor.
1432   function CryptoSagaCardSwapVer2(address _heroAddress, address _goldAddress, address _cardAddress, address _walletAddress)
1433     public
1434   {
1435     require(_heroAddress != address(0));
1436     require(_goldAddress != address(0));
1437     require(_cardAddress != address(0));
1438     require(_walletAddress != address(0));
1439     
1440     wallet = _walletAddress;
1441 
1442     heroContract = CryptoSagaHero(_heroAddress);
1443     goldContract = Gold(_goldAddress);
1444     setCardContract(_cardAddress);
1445   }
1446 
1447   // @dev Swap a card for a hero.
1448   function swapCardForReward(address _by, uint8 _rank)
1449     onlyCard
1450     whenNotPaused
1451     public
1452     returns (uint256)
1453   {
1454     // This is becaue we need to use tx.origin here.
1455     // _by should be the beneficiary, but due to the bug that is already exist with CryptoSagaCard.sol,
1456     // tx.origin is used instead of _by.
1457     require(tx.origin != _by && tx.origin != msg.sender);
1458 
1459     // Get value 0 ~ 9999.
1460     var _randomValue = random(10000, 0);
1461 
1462     // We hard-code this in order to give credential to the players. 
1463     uint8 _heroRankToMint = 0; 
1464 
1465     if (_rank == 0) { // Origin Card. 85% Heroic, 15% Legendary.
1466       if (_randomValue < 8500) {
1467         _heroRankToMint = 3;
1468       } else {
1469         _heroRankToMint = 4;
1470       }
1471     } else if (_rank == 3) { // Dungeon Chest card.
1472       if (_randomValue < 6500) {
1473         _heroRankToMint = 1;
1474       } else if (_randomValue < 9945) {
1475         _heroRankToMint = 2;
1476       }  else if (_randomValue < 9995) {
1477         _heroRankToMint = 3;
1478       } else {
1479         _heroRankToMint = 4;
1480       }
1481     } else { // Do nothing here.
1482       _heroRankToMint = 0;
1483     }
1484     
1485     // Summon the hero.
1486     return summonHero(tx.origin, _heroRankToMint);
1487 
1488   }
1489 
1490   // @dev Pay with Eth.
1491   function payWithEth(uint256 _amount, address _referralAddress)
1492     whenNotPaused
1493     public
1494     payable
1495   {
1496     require(msg.sender != address(0));
1497     // Referral address shouldn't be the same address.
1498     require(msg.sender != _referralAddress);
1499     // Up to 5 purchases at once.
1500     require(_amount >= 1 && _amount <= 5);
1501 
1502     var _priceOfBundle = ethPrice * _amount;
1503 
1504     require(msg.value >= _priceOfBundle);
1505 
1506     // Send the raised eth to the wallet.
1507     wallet.transfer(_priceOfBundle);
1508 
1509     for (uint i = 0; i < _amount; i ++) {
1510       // Get value 0 ~ 9999.
1511       var _randomValue = random(10000, 0);
1512       
1513       // We hard-code this in order to give credential to the players. 
1514       uint8 _heroRankToMint = 0; 
1515 
1516       if (_randomValue < 5000) {
1517         _heroRankToMint = 1;
1518       } else if (_randomValue < 9550) {
1519         _heroRankToMint = 2;
1520       }  else if (_randomValue < 9950) {
1521         _heroRankToMint = 3;
1522       } else {
1523         _heroRankToMint = 4;
1524       }
1525 
1526       // Summon the hero.
1527       summonHero(msg.sender, _heroRankToMint);
1528 
1529       // In case there exists referral address...
1530       if (_referralAddress != address(0)) {
1531         // Add mileage to the referral address.
1532         addressToMileagePoint[_referralAddress] += 5;
1533         addressToMileagePoint[msg.sender] += 3;
1534       }
1535     }
1536   }
1537 
1538   // @dev Pay with Gold.
1539   function payWithGold(uint256 _amount)
1540     whenNotPaused
1541     public
1542   {
1543     require(msg.sender != address(0));
1544     // Up to 5 purchases at once.
1545     require(_amount >= 1 && _amount <= 5);
1546 
1547     var _priceOfBundle = goldPrice * _amount;
1548 
1549     require(goldContract.allowance(msg.sender, this) >= _priceOfBundle);
1550 
1551     if (goldContract.transferFrom(msg.sender, this, _priceOfBundle)) {
1552       for (uint i = 0; i < _amount; i ++) {
1553         // Get value 0 ~ 9999.
1554         var _randomValue = random(10000, 0);
1555         
1556         // We hard-code this in order to give credential to the players. 
1557         uint8 _heroRankToMint = 0; 
1558 
1559         if (_randomValue < 3000) {
1560           _heroRankToMint = 0;
1561         } else if (_randomValue < 7500) {
1562           _heroRankToMint = 1;
1563         } else if (_randomValue < 9945) {
1564           _heroRankToMint = 2;
1565         } else if (_randomValue < 9995) {
1566           _heroRankToMint = 3;
1567         } else {
1568           _heroRankToMint = 4;
1569         }
1570 
1571         // Summon the hero.
1572         summonHero(msg.sender, _heroRankToMint);
1573       }
1574     }
1575   }
1576 
1577   // @dev Pay with Mileage.
1578   function payWithMileagePoint(uint256 _amount)
1579     whenNotPaused
1580     public
1581   {
1582     require(msg.sender != address(0));
1583     // Up to 5 purchases at once.
1584     require(_amount >= 1 && _amount <= 5);
1585 
1586     var _priceOfBundle = mileagePointPrice * _amount;
1587 
1588     require(addressToMileagePoint[msg.sender] >= _priceOfBundle);
1589 
1590     // Decrement mileage point.
1591     addressToMileagePoint[msg.sender] -= _priceOfBundle;
1592 
1593     for (uint i = 0; i < _amount; i ++) {
1594       // Get value 0 ~ 9999.
1595       var _randomValue = random(10000, 0);
1596       
1597       // We hard-code this in order to give credential to the players. 
1598       uint8 _heroRankToMint = 0; 
1599 
1600       if (_randomValue < 5000) {
1601         _heroRankToMint = 1;
1602       } else if (_randomValue < 9050) {
1603         _heroRankToMint = 2;
1604       }  else if (_randomValue < 9950) {
1605         _heroRankToMint = 3;
1606       } else {
1607         _heroRankToMint = 4;
1608       }
1609 
1610       // Summon the hero.
1611       summonHero(msg.sender, _heroRankToMint);
1612     }
1613   }
1614 
1615   // @dev Free daily summon.
1616   function payWithDailyFreePoint()
1617     whenNotPaused
1618     public
1619   {
1620     require(msg.sender != address(0));
1621     // Only once a day.
1622     require(now > addressToFreeSummonTimestamp[msg.sender] + 1 days);
1623     addressToFreeSummonTimestamp[msg.sender] = now;
1624 
1625     // Get value 0 ~ 9999.
1626     var _randomValue = random(10000, 0);
1627     
1628     // We hard-code this in order to give credential to the players. 
1629     uint8 _heroRankToMint = 0; 
1630 
1631     if (_randomValue < 5500) {
1632       _heroRankToMint = 0;
1633     } else if (_randomValue < 9850) {
1634       _heroRankToMint = 1;
1635     } else {
1636       _heroRankToMint = 2;
1637     }
1638 
1639     // Summon the hero.
1640     summonHero(msg.sender, _heroRankToMint);
1641 
1642   }
1643 
1644   // @dev Summon a hero.
1645   // 0: Common, 1: Uncommon, 2: Rare, 3: Heroic, 4: Legendary
1646   function summonHero(address _to, uint8 _heroRankToMint)
1647     private
1648     returns (uint256)
1649   {
1650 
1651     // Get the list of hero classes.
1652     uint32 _numberOfClasses = heroContract.numberOfHeroClasses();
1653     uint32[] memory _candidates = new uint32[](_numberOfClasses);
1654     uint32 _count = 0;
1655     for (uint32 i = 0; i < _numberOfClasses; i ++) {
1656       if (heroContract.getClassRank(i) == _heroRankToMint && blackList[i] != true) {
1657         _candidates[_count] = i;
1658         _count++;
1659       }
1660     }
1661 
1662     require(_count != 0);
1663     
1664     return heroContract.mint(_to, _candidates[random(_count, 0)]);
1665   }
1666 
1667   // @dev return a pseudo random number between lower and upper bounds
1668   function random(uint32 _upper, uint32 _lower)
1669     private
1670     returns (uint32)
1671   {
1672     require(_upper > _lower);
1673 
1674     seed = uint32(keccak256(keccak256(block.blockhash(block.number - 1), seed), now));
1675     return seed % (_upper - _lower) + _lower;
1676   }
1677 
1678 }