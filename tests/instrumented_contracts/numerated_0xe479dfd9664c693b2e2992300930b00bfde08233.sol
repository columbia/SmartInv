1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/access/Roles.sol
80 
81 pragma solidity ^0.4.24;
82 
83 /**
84  * @title Roles
85  * @dev Library for managing addresses assigned to a Role.
86  */
87 library Roles {
88   struct Role {
89     mapping (address => bool) bearer;
90   }
91 
92   /**
93    * @dev give an account access to this role
94    */
95   function add(Role storage role, address account) internal {
96     require(account != address(0));
97     require(!has(role, account));
98 
99     role.bearer[account] = true;
100   }
101 
102   /**
103    * @dev remove an account's access to this role
104    */
105   function remove(Role storage role, address account) internal {
106     require(account != address(0));
107     require(has(role, account));
108 
109     role.bearer[account] = false;
110   }
111 
112   /**
113    * @dev check if an account has this role
114    * @return bool
115    */
116   function has(Role storage role, address account)
117     internal
118     view
119     returns (bool)
120   {
121     require(account != address(0));
122     return role.bearer[account];
123   }
124 }
125 
126 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
127 
128 pragma solidity ^0.4.24;
129 
130 
131 contract PauserRole {
132   using Roles for Roles.Role;
133 
134   event PauserAdded(address indexed account);
135   event PauserRemoved(address indexed account);
136 
137   Roles.Role private pausers;
138 
139   constructor() internal {
140     _addPauser(msg.sender);
141   }
142 
143   modifier onlyPauser() {
144     require(isPauser(msg.sender));
145     _;
146   }
147 
148   function isPauser(address account) public view returns (bool) {
149     return pausers.has(account);
150   }
151 
152   function addPauser(address account) public onlyPauser {
153     _addPauser(account);
154   }
155 
156   function renouncePauser() public {
157     _removePauser(msg.sender);
158   }
159 
160   function _addPauser(address account) internal {
161     pausers.add(account);
162     emit PauserAdded(account);
163   }
164 
165   function _removePauser(address account) internal {
166     pausers.remove(account);
167     emit PauserRemoved(account);
168   }
169 }
170 
171 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
172 
173 pragma solidity ^0.4.24;
174 
175 
176 /**
177  * @title Pausable
178  * @dev Base contract which allows children to implement an emergency stop mechanism.
179  */
180 contract Pausable is PauserRole {
181   event Paused(address account);
182   event Unpaused(address account);
183 
184   bool private _paused;
185 
186   constructor() internal {
187     _paused = false;
188   }
189 
190   /**
191    * @return true if the contract is paused, false otherwise.
192    */
193   function paused() public view returns(bool) {
194     return _paused;
195   }
196 
197   /**
198    * @dev Modifier to make a function callable only when the contract is not paused.
199    */
200   modifier whenNotPaused() {
201     require(!_paused);
202     _;
203   }
204 
205   /**
206    * @dev Modifier to make a function callable only when the contract is paused.
207    */
208   modifier whenPaused() {
209     require(_paused);
210     _;
211   }
212 
213   /**
214    * @dev called by the owner to pause, triggers stopped state
215    */
216   function pause() public onlyPauser whenNotPaused {
217     _paused = true;
218     emit Paused(msg.sender);
219   }
220 
221   /**
222    * @dev called by the owner to unpause, returns to normal state
223    */
224   function unpause() public onlyPauser whenPaused {
225     _paused = false;
226     emit Unpaused(msg.sender);
227   }
228 }
229 
230 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
231 
232 pragma solidity ^0.4.24;
233 
234 /**
235  * @title SafeMath
236  * @dev Math operations with safety checks that revert on error
237  */
238 library SafeMath {
239 
240   /**
241   * @dev Multiplies two numbers, reverts on overflow.
242   */
243   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
244     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
245     // benefit is lost if 'b' is also tested.
246     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
247     if (a == 0) {
248       return 0;
249     }
250 
251     uint256 c = a * b;
252     require(c / a == b);
253 
254     return c;
255   }
256 
257   /**
258   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
259   */
260   function div(uint256 a, uint256 b) internal pure returns (uint256) {
261     require(b > 0); // Solidity only automatically asserts when dividing by 0
262     uint256 c = a / b;
263     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
264 
265     return c;
266   }
267 
268   /**
269   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
270   */
271   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
272     require(b <= a);
273     uint256 c = a - b;
274 
275     return c;
276   }
277 
278   /**
279   * @dev Adds two numbers, reverts on overflow.
280   */
281   function add(uint256 a, uint256 b) internal pure returns (uint256) {
282     uint256 c = a + b;
283     require(c >= a);
284 
285     return c;
286   }
287 
288   /**
289   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
290   * reverts when dividing by zero.
291   */
292   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
293     require(b != 0);
294     return a % b;
295   }
296 }
297 
298 // File: openzeppelin-solidity/contracts/utils/Address.sol
299 
300 pragma solidity ^0.4.24;
301 
302 /**
303  * Utility library of inline functions on addresses
304  */
305 library Address {
306 
307   /**
308    * Returns whether the target address is a contract
309    * @dev This function will return false if invoked during the constructor of a contract,
310    * as the code is not actually created until after the constructor finishes.
311    * @param account address of the account to check
312    * @return whether the target address is a contract
313    */
314   function isContract(address account) internal view returns (bool) {
315     uint256 size;
316     // XXX Currently there is no better way to check if there is a contract in an address
317     // than to check the size of the code at that address.
318     // See https://ethereum.stackexchange.com/a/14016/36603
319     // for more details about how this works.
320     // TODO Check this again before the Serenity release, because all addresses will be
321     // contracts then.
322     // solium-disable-next-line security/no-inline-assembly
323     assembly { size := extcodesize(account) }
324     return size > 0;
325   }
326 
327 }
328 
329 // File: contracts/bid/ERC721BidStorage.sol
330 
331 pragma solidity ^0.4.24;
332 
333 
334 /**
335  * @title Interface for contracts conforming to ERC-20
336  */
337 contract ERC20Interface {
338     function balanceOf(address from) public view returns (uint256);
339     function transferFrom(address from, address to, uint tokens) public returns (bool);
340     function allowance(address owner, address spender) public view returns (uint256);
341 }
342 
343 
344 /**
345  * @title Interface for contracts conforming to ERC-721
346  */
347 contract ERC721Interface {
348     function ownerOf(uint256 _tokenId) public view returns (address _owner);
349     function transferFrom(address _from, address _to, uint256 _tokenId) public;
350     function supportsInterface(bytes4) public view returns (bool);
351 }
352 
353 
354 contract ERC721Verifiable is ERC721Interface {
355     function verifyFingerprint(uint256, bytes memory) public view returns (bool);
356 }
357 
358 
359 contract ERC721BidStorage {
360     // 182 days - 26 weeks - 6 months
361     uint256 public constant MAX_BID_DURATION = 182 days;
362     uint256 public constant MIN_BID_DURATION = 1 minutes;
363     uint256 public constant ONE_MILLION = 1000000;
364     bytes4 public constant ERC721_Interface = 0x80ac58cd;
365     bytes4 public constant ERC721_Received = 0x150b7a02;
366     bytes4 public constant ERC721Composable_ValidateFingerprint = 0x8f9f4b63;
367     
368     struct Bid {
369         // Bid Id
370         bytes32 id;
371         // Bidder address 
372         address bidder;
373         // ERC721 address
374         address tokenAddress;
375         // ERC721 token id
376         uint256 tokenId;
377         // Price for the bid in wei 
378         uint256 price;
379         // Time when this bid ends 
380         uint256 expiresAt;
381         // Fingerprint for composable
382         bytes fingerprint;
383     }
384 
385     // MANA token
386     ERC20Interface public manaToken;
387 
388     // Bid by token address => token id => bid index => bid
389     mapping(address => mapping(uint256 => mapping(uint256 => Bid))) internal bidsByToken;
390     // Bid count by token address => token id => bid counts
391     mapping(address => mapping(uint256 => uint256)) public bidCounterByToken;
392     // Index of the bid at bidsByToken mapping by bid id => bid index
393     mapping(bytes32 => uint256) public bidIndexByBidId;
394     // Bid id by token address => token id => bidder address => bidId
395     mapping(address => mapping(uint256 => mapping(address => bytes32))) 
396     public 
397     bidIdByTokenAndBidder;
398 
399 
400     uint256 public ownerCutPerMillion;
401 
402     // EVENTS
403     event BidCreated(
404       bytes32 _id,
405       address indexed _tokenAddress,
406       uint256 indexed _tokenId,
407       address indexed _bidder,
408       uint256 _price,
409       uint256 _expiresAt,
410       bytes _fingerprint
411     );
412     
413     event BidAccepted(
414       bytes32 _id,
415       address indexed _tokenAddress,
416       uint256 indexed _tokenId,
417       address _bidder,
418       address indexed _seller,
419       uint256 _price,
420       uint256 _fee
421     );
422 
423     event BidCancelled(
424       bytes32 _id,
425       address indexed _tokenAddress,
426       uint256 indexed _tokenId,
427       address indexed _bidder
428     );
429 
430     event ChangedOwnerCutPerMillion(uint256 _ownerCutPerMillion);
431 }
432 
433 // File: contracts/bid/ERC721Bid.sol
434 
435 pragma solidity ^0.4.24;
436 
437 
438 
439 
440 
441 
442 
443 contract ERC721Bid is Ownable, Pausable, ERC721BidStorage {
444     using SafeMath for uint256;
445     using Address for address;
446 
447     /**
448     * @dev Constructor of the contract.
449     * @param _manaToken - address of the mana token
450     * @param _owner - address of the owner for the contract
451     */
452     constructor(address _manaToken, address _owner) Ownable() Pausable() public {
453         manaToken = ERC20Interface(_manaToken);
454         // Set owner
455         transferOwnership(_owner);
456     }
457 
458     /**
459     * @dev Place a bid for an ERC721 token.
460     * @param _tokenAddress - address of the ERC721 token
461     * @param _tokenId - uint256 of the token id
462     * @param _price - uint256 of the price for the bid
463     * @param _duration - uint256 of the duration in seconds for the bid
464     */
465     function placeBid(
466         address _tokenAddress, 
467         uint256 _tokenId,
468         uint256 _price,
469         uint256 _duration
470     )
471         public
472     {
473         _placeBid(
474             _tokenAddress, 
475             _tokenId,
476             _price,
477             _duration,
478             ""
479         );
480     }
481 
482     /**
483     * @dev Place a bid for an ERC721 token with fingerprint.
484     * @param _tokenAddress - address of the ERC721 token
485     * @param _tokenId - uint256 of the token id
486     * @param _price - uint256 of the price for the bid
487     * @param _duration - uint256 of the duration in seconds for the bid
488     * @param _fingerprint - bytes of ERC721 token fingerprint 
489     */
490     function placeBid(
491         address _tokenAddress, 
492         uint256 _tokenId,
493         uint256 _price,
494         uint256 _duration,
495         bytes _fingerprint
496     )
497         public
498     {
499         _placeBid(
500             _tokenAddress, 
501             _tokenId,
502             _price,
503             _duration,
504             _fingerprint 
505         );
506     }
507 
508     /**
509     * @dev Place a bid for an ERC721 token with fingerprint.
510     * @notice Tokens can have multiple bids by different users.
511     * Users can have only one bid per token.
512     * If the user places a bid and has an active bid for that token,
513     * the older one will be replaced with the new one.
514     * @param _tokenAddress - address of the ERC721 token
515     * @param _tokenId - uint256 of the token id
516     * @param _price - uint256 of the price for the bid
517     * @param _duration - uint256 of the duration in seconds for the bid
518     * @param _fingerprint - bytes of ERC721 token fingerprint 
519     */
520     function _placeBid(
521         address _tokenAddress, 
522         uint256 _tokenId,
523         uint256 _price,
524         uint256 _duration,
525         bytes memory _fingerprint
526     )
527         private
528         whenNotPaused()
529     {
530         _requireERC721(_tokenAddress);
531         _requireComposableERC721(_tokenAddress, _tokenId, _fingerprint);
532 
533         require(_price > 0, "Price should be bigger than 0");
534 
535         _requireBidderBalance(msg.sender, _price);       
536 
537         require(
538             _duration >= MIN_BID_DURATION, 
539             "The bid should be last longer than a minute"
540         );
541 
542         require(
543             _duration <= MAX_BID_DURATION, 
544             "The bid can not last longer than 6 months"
545         );
546 
547         ERC721Interface token = ERC721Interface(_tokenAddress);
548         address tokenOwner = token.ownerOf(_tokenId);
549         require(
550             tokenOwner != address(0) && tokenOwner != msg.sender,
551             "The token should have an owner different from the sender"
552         );
553 
554         uint256 expiresAt = block.timestamp.add(_duration);
555 
556         bytes32 bidId = keccak256(
557             abi.encodePacked(
558                 block.timestamp,
559                 msg.sender,
560                 _tokenAddress,
561                 _tokenId,
562                 _price,
563                 _duration,
564                 _fingerprint
565             )
566         );
567 
568         uint256 bidIndex;
569 
570         if (_bidderHasABid(_tokenAddress, _tokenId, msg.sender)) {
571             bytes32 oldBidId;
572             (bidIndex, oldBidId,,,) = getBidByBidder(_tokenAddress, _tokenId, msg.sender);
573             
574             // Delete old bid reference
575             delete bidIndexByBidId[oldBidId];
576         } else {
577             // Use the bid counter to assign the index if there is not an active bid. 
578             bidIndex = bidCounterByToken[_tokenAddress][_tokenId];  
579             // Increase bid counter 
580             bidCounterByToken[_tokenAddress][_tokenId]++;
581         }
582 
583         // Set bid references
584         bidIdByTokenAndBidder[_tokenAddress][_tokenId][msg.sender] = bidId;
585         bidIndexByBidId[bidId] = bidIndex;
586 
587         // Save Bid
588         bidsByToken[_tokenAddress][_tokenId][bidIndex] = Bid({
589             id: bidId,
590             bidder: msg.sender,
591             tokenAddress: _tokenAddress,
592             tokenId: _tokenId,
593             price: _price,
594             expiresAt: expiresAt,
595             fingerprint: _fingerprint
596         });
597 
598         emit BidCreated(
599             bidId,
600             _tokenAddress,
601             _tokenId,
602             msg.sender,
603             _price,
604             expiresAt,
605             _fingerprint     
606         );
607     }
608 
609     /**
610     * @dev Used as the only way to accept a bid. 
611     * The token owner should send the token to this contract using safeTransferFrom.
612     * The last parameter (bytes) should be the bid id.
613     * @notice  The ERC721 smart contract calls this function on the recipient
614     * after a `safetransfer`. This function MAY throw to revert and reject the
615     * transfer. Return of other than the magic value MUST result in the
616     * transaction being reverted.
617     * Note: 
618     * Contract address is always the message sender.
619     * This method should be seen as 'acceptBid'.
620     * It validates that the bid id matches an active bid for the bid token.
621     * @param _from The address which previously owned the token
622     * @param _tokenId The NFT identifier which is being transferred
623     * @param _data Additional data with no specified format
624     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
625     */
626     function onERC721Received(
627         address _from,
628         address /*_to*/,
629         uint256 _tokenId,
630         bytes memory _data
631     )
632         public
633         whenNotPaused()
634         returns (bytes4)
635     {
636         bytes32 bidId = _bytesToBytes32(_data);
637         uint256 bidIndex = bidIndexByBidId[bidId];
638 
639         Bid memory bid = _getBid(msg.sender, _tokenId, bidIndex);
640 
641         // Check if the bid is valid.
642         require(
643             // solium-disable-next-line operator-whitespace
644             bid.id == bidId &&
645             bid.expiresAt >= block.timestamp, 
646             "Invalid bid"
647         );
648 
649         address bidder = bid.bidder;
650         uint256 price = bid.price;
651         
652         // Check fingerprint if necessary
653         _requireComposableERC721(msg.sender, _tokenId, bid.fingerprint);
654 
655         // Check if bidder has funds
656         _requireBidderBalance(bidder, price);
657 
658         // Delete bid references from contract storage
659         delete bidsByToken[msg.sender][_tokenId][bidIndex];
660         delete bidIndexByBidId[bidId];
661         delete bidIdByTokenAndBidder[msg.sender][_tokenId][bidder];
662 
663         // Reset bid counter to invalidate other bids placed for the token
664         delete bidCounterByToken[msg.sender][_tokenId];
665         
666         // Transfer token to bidder
667         ERC721Interface(msg.sender).transferFrom(address(this), bidder, _tokenId);
668 
669         uint256 saleShareAmount = 0;
670         if (ownerCutPerMillion > 0) {
671             // Calculate sale share
672             saleShareAmount = price.mul(ownerCutPerMillion).div(ONE_MILLION);
673             // Transfer share amount to the bid conctract Owner
674             require(
675                 manaToken.transferFrom(bidder, owner(), saleShareAmount),
676                 "Transfering the cut to the bid contract owner failed"
677             );
678         }
679 
680         // Transfer MANA from bidder to seller
681         require(
682             manaToken.transferFrom(bidder, _from, price.sub(saleShareAmount)),
683             "Transfering MANA to owner failed"
684         );
685        
686         emit BidAccepted(
687             bidId,
688             msg.sender,
689             _tokenId,
690             bidder,
691             _from,
692             price,
693             saleShareAmount
694         );
695 
696         return ERC721_Received;
697     }
698 
699     /**
700     * @dev Remove expired bids
701     * @param _tokenAddresses - address[] of the ERC721 tokens
702     * @param _tokenIds - uint256[] of the token ids
703     * @param _bidders - address[] of the bidders
704     */
705     function removeExpiredBids(address[] _tokenAddresses, uint256[] _tokenIds, address[] _bidders)
706     public 
707     {
708         uint256 loopLength = _tokenAddresses.length;
709 
710         require(loopLength == _tokenIds.length, "Parameter arrays should have the same length");
711         require(loopLength == _bidders.length, "Parameter arrays should have the same length");
712 
713         for (uint256 i = 0; i < loopLength; i++) {
714             _removeExpiredBid(_tokenAddresses[i], _tokenIds[i], _bidders[i]);
715         }
716     }
717     
718     /**
719     * @dev Remove expired bid
720     * @param _tokenAddress - address of the ERC721 token
721     * @param _tokenId - uint256 of the token id
722     * @param _bidder - address of the bidder
723     */
724     function _removeExpiredBid(address _tokenAddress, uint256 _tokenId, address _bidder)
725     internal 
726     {
727         (uint256 bidIndex, bytes32 bidId,,,uint256 expiresAt) = getBidByBidder(
728             _tokenAddress, 
729             _tokenId,
730             _bidder
731         );
732         
733         require(expiresAt < block.timestamp, "The bid to remove should be expired");
734 
735         _cancelBid(
736             bidIndex, 
737             bidId, 
738             _tokenAddress, 
739             _tokenId, 
740             _bidder
741         );
742     }
743 
744     /**
745     * @dev Cancel a bid for an ERC721 token
746     * @param _tokenAddress - address of the ERC721 token
747     * @param _tokenId - uint256 of the token id
748     */
749     function cancelBid(address _tokenAddress, uint256 _tokenId) public whenNotPaused() {
750         // Get active bid
751         (uint256 bidIndex, bytes32 bidId,,,) = getBidByBidder(
752             _tokenAddress, 
753             _tokenId,
754             msg.sender
755         );
756 
757         _cancelBid(
758             bidIndex, 
759             bidId, 
760             _tokenAddress, 
761             _tokenId, 
762             msg.sender
763         );
764     }
765 
766     /**
767     * @dev Cancel a bid for an ERC721 token
768     * @param _bidIndex - uint256 of the index of the bid
769     * @param _bidId - bytes32 of the bid id
770     * @param _tokenAddress - address of the ERC721 token
771     * @param _tokenId - uint256 of the token id
772     * @param _bidder - address of the bidder
773     */
774     function _cancelBid(
775         uint256 _bidIndex,
776         bytes32 _bidId, 
777         address _tokenAddress,
778         uint256 _tokenId, 
779         address _bidder
780     ) 
781         internal 
782     {
783         // Delete bid references
784         delete bidIndexByBidId[_bidId];
785         delete bidIdByTokenAndBidder[_tokenAddress][_tokenId][_bidder];
786         
787         // Check if the bid is at the end of the mapping
788         uint256 lastBidIndex = bidCounterByToken[_tokenAddress][_tokenId].sub(1);
789         if (lastBidIndex != _bidIndex) {
790             // Move last bid to the removed place
791             Bid storage lastBid = bidsByToken[_tokenAddress][_tokenId][lastBidIndex];
792             bidsByToken[_tokenAddress][_tokenId][_bidIndex] = lastBid;
793             bidIndexByBidId[lastBid.id] = _bidIndex;
794         }
795         
796         // Delete empty index
797         delete bidsByToken[_tokenAddress][_tokenId][lastBidIndex];
798 
799         // Decrease bids counter
800         bidCounterByToken[_tokenAddress][_tokenId]--;
801 
802         // emit BidCancelled event
803         emit BidCancelled(
804             _bidId,
805             _tokenAddress,
806             _tokenId,
807             _bidder
808         );
809     }
810 
811      /**
812     * @dev Check if the bidder has a bid for an specific token.
813     * @param _tokenAddress - address of the ERC721 token
814     * @param _tokenId - uint256 of the token id
815     * @param _bidder - address of the bidder
816     * @return bool whether the bidder has an active bid
817     */
818     function _bidderHasABid(address _tokenAddress, uint256 _tokenId, address _bidder) 
819         internal
820         view 
821         returns (bool)
822     {
823         bytes32 bidId = bidIdByTokenAndBidder[_tokenAddress][_tokenId][_bidder];
824         uint256 bidIndex = bidIndexByBidId[bidId];
825         // Bid index should be inside bounds
826         if (bidIndex < bidCounterByToken[_tokenAddress][_tokenId]) {
827             Bid memory bid = bidsByToken[_tokenAddress][_tokenId][bidIndex];
828             return bid.bidder == _bidder;
829         }
830         return false;
831     }
832 
833     /**
834     * @dev Get the active bid id and index by a bidder and an specific token. 
835     * @notice If the bidder has not a valid bid, the transaction will be reverted.
836     * @param _tokenAddress - address of the ERC721 token
837     * @param _tokenId - uint256 of the token id
838     * @param _bidder - address of the bidder
839     * @return uint256 of the bid index to be used within bidsByToken mapping
840     * @return bytes32 of the bid id
841     * @return address of the bidder address
842     * @return uint256 of the bid price
843     * @return uint256 of the expiration time
844     */
845     function getBidByBidder(address _tokenAddress, uint256 _tokenId, address _bidder) 
846         public
847         view 
848         returns (
849             uint256 bidIndex, 
850             bytes32 bidId, 
851             address bidder, 
852             uint256 price, 
853             uint256 expiresAt
854         ) 
855     {
856         bidId = bidIdByTokenAndBidder[_tokenAddress][_tokenId][_bidder];
857         bidIndex = bidIndexByBidId[bidId];
858         (bidId, bidder, price, expiresAt) = getBidByToken(_tokenAddress, _tokenId, bidIndex);
859         if (_bidder != bidder) {
860             revert("Bidder has not an active bid for this token");
861         }
862     }
863 
864     /**
865     * @dev Get an ERC721 token bid by index
866     * @param _tokenAddress - address of the ERC721 token
867     * @param _tokenId - uint256 of the token id
868     * @param _index - uint256 of the index
869     * @return uint256 of the bid index to be used within bidsByToken mapping
870     * @return bytes32 of the bid id
871     * @return address of the bidder address
872     * @return uint256 of the bid price
873     * @return uint256 of the expiration time
874     */
875     function getBidByToken(address _tokenAddress, uint256 _tokenId, uint256 _index) 
876         public 
877         view
878         returns (bytes32, address, uint256, uint256) 
879     {
880         
881         Bid memory bid = _getBid(_tokenAddress, _tokenId, _index);
882         return (
883             bid.id,
884             bid.bidder,
885             bid.price,
886             bid.expiresAt
887         );
888     }
889 
890     /**
891     * @dev Get the active bid id and index by a bidder and an specific token. 
892     * @notice If the index is not valid, it will revert.
893     * @param _tokenAddress - address of the ERC721 token
894     * @param _tokenId - uint256 of the index
895     * @param _index - uint256 of the index
896     * @return Bid
897     */
898     function _getBid(address _tokenAddress, uint256 _tokenId, uint256 _index) 
899         internal 
900         view 
901         returns (Bid memory)
902     {
903         require(_index < bidCounterByToken[_tokenAddress][_tokenId], "Invalid index");
904         return bidsByToken[_tokenAddress][_tokenId][_index];
905     }
906 
907     /**
908     * @dev Sets the share cut for the owner of the contract that's
909     * charged to the seller on a successful sale
910     * @param _ownerCutPerMillion - Share amount, from 0 to 999,999
911     */
912     function setOwnerCutPerMillion(uint256 _ownerCutPerMillion) external onlyOwner {
913         require(_ownerCutPerMillion < ONE_MILLION, "The owner cut should be between 0 and 999,999");
914 
915         ownerCutPerMillion = _ownerCutPerMillion;
916         emit ChangedOwnerCutPerMillion(ownerCutPerMillion);
917     }
918 
919     /**
920     * @dev Convert bytes to bytes32
921     * @param _data - bytes
922     * @return bytes32
923     */
924     function _bytesToBytes32(bytes memory _data) internal pure returns (bytes32) {
925         require(_data.length == 32, "The data should be 32 bytes length");
926 
927         bytes32 bidId;
928         // solium-disable-next-line security/no-inline-assembly
929         assembly {
930             bidId := mload(add(_data, 0x20))
931         }
932         return bidId;
933     }
934 
935     /**
936     * @dev Check if the token has a valid ERC721 implementation
937     * @param _tokenAddress - address of the token
938     */
939     function _requireERC721(address _tokenAddress) internal view {
940         require(_tokenAddress.isContract(), "Token should be a contract");
941 
942         ERC721Interface token = ERC721Interface(_tokenAddress);
943         require(
944             token.supportsInterface(ERC721_Interface),
945             "Token has an invalid ERC721 implementation"
946         );
947     }
948 
949     /**
950     * @dev Check if the token has a valid Composable ERC721 implementation
951     * And its fingerprint is valid
952     * @param _tokenAddress - address of the token
953     * @param _tokenId - uint256 of the index
954     * @param _fingerprint - bytes of the fingerprint
955     */
956     function _requireComposableERC721(
957         address _tokenAddress,
958         uint256 _tokenId,
959         bytes memory _fingerprint
960     )
961         internal
962         view
963     {
964         ERC721Verifiable composableToken = ERC721Verifiable(_tokenAddress);
965         if (composableToken.supportsInterface(ERC721Composable_ValidateFingerprint)) {
966             require(
967                 composableToken.verifyFingerprint(_tokenId, _fingerprint),
968                 "Token fingerprint is not valid"
969             );
970         }
971     }
972 
973     /**
974     * @dev Check if the bidder has balance and the contract has enough allowance
975     * to use bidder MANA on his belhalf
976     * @param _bidder - address of bidder
977     * @param _amount - uint256 of amount
978     */
979     function _requireBidderBalance(address _bidder, uint256 _amount) internal view {
980         require(
981             manaToken.balanceOf(_bidder) >= _amount,
982             "Insufficient funds"
983         );
984         require(
985             manaToken.allowance(_bidder, address(this)) >= _amount,
986             "The contract is not authorized to use MANA on bidder behalf"
987         );        
988     }
989 }