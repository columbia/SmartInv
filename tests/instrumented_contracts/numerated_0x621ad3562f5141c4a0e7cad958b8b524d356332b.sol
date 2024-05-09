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
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 
92 /// @title Interface for contracts conforming to ERC-721: Deed Standard
93 /// @author William Entriken (https://phor.net), et al.
94 /// @dev Specification at https://github.com/ethereum/EIPs/pull/841 (DRAFT)
95 interface ERC721 {
96 
97     // COMPLIANCE WITH ERC-165 (DRAFT) /////////////////////////////////////////
98 
99     /// @dev ERC-165 (draft) interface signature for itself
100     // bytes4 internal constant INTERFACE_SIGNATURE_ERC165 = // 0x01ffc9a7
101     //     bytes4(keccak256('supportsInterface(bytes4)'));
102 
103     /// @dev ERC-165 (draft) interface signature for ERC721
104     // bytes4 internal constant INTERFACE_SIGNATURE_ERC721 = // 0xda671b9b
105     //     bytes4(keccak256('ownerOf(uint256)')) ^
106     //     bytes4(keccak256('countOfDeeds()')) ^
107     //     bytes4(keccak256('countOfDeedsByOwner(address)')) ^
108     //     bytes4(keccak256('deedOfOwnerByIndex(address,uint256)')) ^
109     //     bytes4(keccak256('approve(address,uint256)')) ^
110     //     bytes4(keccak256('takeOwnership(uint256)'));
111 
112     /// @notice Query a contract to see if it supports a certain interface
113     /// @dev Returns `true` the interface is supported and `false` otherwise,
114     ///  returns `true` for INTERFACE_SIGNATURE_ERC165 and
115     ///  INTERFACE_SIGNATURE_ERC721, see ERC-165 for other interface signatures.
116     function supportsInterface(bytes4 _interfaceID) external pure returns (bool);
117 
118     // PUBLIC QUERY FUNCTIONS //////////////////////////////////////////////////
119 
120     /// @notice Find the owner of a deed
121     /// @param _deedId The identifier for a deed we are inspecting
122     /// @dev Deeds assigned to zero address are considered destroyed, and
123     ///  queries about them do throw.
124     /// @return The non-zero address of the owner of deed `_deedId`, or `throw`
125     ///  if deed `_deedId` is not tracked by this contract
126     function ownerOf(uint256 _deedId) external view returns (address _owner);
127 
128     /// @notice Count deeds tracked by this contract
129     /// @return A count of the deeds tracked by this contract, where each one of
130     ///  them has an assigned and queryable owner
131     function countOfDeeds() public view returns (uint256 _count);
132 
133     /// @notice Count all deeds assigned to an owner
134     /// @dev Throws if `_owner` is the zero address, representing destroyed deeds.
135     /// @param _owner An address where we are interested in deeds owned by them
136     /// @return The number of deeds owned by `_owner`, possibly zero
137     function countOfDeedsByOwner(address _owner) public view returns (uint256 _count);
138 
139     /// @notice Enumerate deeds assigned to an owner
140     /// @dev Throws if `_index` >= `countOfDeedsByOwner(_owner)` or if
141     ///  `_owner` is the zero address, representing destroyed deeds.
142     /// @param _owner An address where we are interested in deeds owned by them
143     /// @param _index A counter between zero and `countOfDeedsByOwner(_owner)`,
144     ///  inclusive
145     /// @return The identifier for the `_index`th deed assigned to `_owner`,
146     ///   (sort order not specified)
147     function deedOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _deedId);
148 
149     // TRANSFER MECHANISM //////////////////////////////////////////////////////
150 
151     /// @dev This event emits when ownership of any deed changes by any
152     ///  mechanism. This event emits when deeds are created (`from` == 0) and
153     ///  destroyed (`to` == 0). Exception: during contract creation, any
154     ///  transfers may occur without emitting `Transfer`.
155     event Transfer(address indexed from, address indexed to, uint256 indexed deedId);
156 
157     /// @dev This event emits on any successful call to
158     ///  `approve(address _spender, uint256 _deedId)`. Exception: does not emit
159     ///  if an owner revokes approval (`_to` == 0x0) on a deed with no existing
160     ///  approval.
161     event Approval(address indexed owner, address indexed approved, uint256 indexed deedId);
162 
163     /// @notice Approve a new owner to take your deed, or revoke approval by
164     ///  setting the zero address. You may `approve` any number of times while
165     ///  the deed is assigned to you, only the most recent approval matters.
166     /// @dev Throws if `msg.sender` does not own deed `_deedId` or if `_to` ==
167     ///  `msg.sender`.
168     /// @param _deedId The deed you are granting ownership of
169     function approve(address _to, uint256 _deedId) external;
170 
171     /// @notice Become owner of a deed for which you are currently approved
172     /// @dev Throws if `msg.sender` is not approved to become the owner of
173     ///  `deedId` or if `msg.sender` currently owns `_deedId`.
174     /// @param _deedId The deed that is being transferred
175     function takeOwnership(uint256 _deedId) external;
176     
177     // SPEC EXTENSIONS /////////////////////////////////////////////////////////
178     
179     /// @notice Transfer a deed to a new owner.
180     /// @dev Throws if `msg.sender` does not own deed `_deedId` or if
181     ///  `_to` == 0x0.
182     /// @param _to The address of the new owner.
183     /// @param _deedId The deed you are transferring.
184     function transfer(address _to, uint256 _deedId) external;
185 }
186 
187 
188 /// @title The internal clock auction functionality.
189 /// Inspired by CryptoKitties' clock auction
190 contract ClockAuctionBase {
191 
192     // Address of the ERC721 contract this auction is linked to.
193     ERC721 public deedContract;
194 
195     // Fee per successful auction in 1/1000th of a percentage.
196     uint256 public fee;
197     
198     // Total amount of ether yet to be paid to auction beneficiaries.
199     uint256 public outstandingEther = 0 ether;
200     
201     // Amount of ether yet to be paid per beneficiary.
202     mapping (address => uint256) public addressToEtherOwed;
203     
204     /// @dev Represents a deed auction.
205     /// Care has been taken to ensure the auction fits in
206     /// two 256-bit words.
207     struct Auction {
208         address seller;
209         uint128 startPrice;
210         uint128 endPrice;
211         uint64 duration;
212         uint64 startedAt;
213     }
214 
215     mapping (uint256 => Auction) identifierToAuction;
216     
217     // Events
218     event AuctionCreated(address indexed seller, uint256 indexed deedId, uint256 startPrice, uint256 endPrice, uint256 duration);
219     event AuctionSuccessful(address indexed buyer, uint256 indexed deedId, uint256 totalPrice);
220     event AuctionCancelled(uint256 indexed deedId);
221     
222     /// @dev Modifier to check whether the value can be stored in a 64 bit uint.
223     modifier fitsIn64Bits(uint256 _value) {
224         require (_value == uint256(uint64(_value)));
225         _;
226     }
227     
228     /// @dev Modifier to check whether the value can be stored in a 128 bit uint.
229     modifier fitsIn128Bits(uint256 _value) {
230         require (_value == uint256(uint128(_value)));
231         _;
232     }
233     
234     function ClockAuctionBase(address _deedContractAddress, uint256 _fee) public {
235         deedContract = ERC721(_deedContractAddress);
236         
237         // Contract must indicate support for ERC721 through its interface signature.
238         require(deedContract.supportsInterface(0xda671b9b));
239         
240         // Fee must be between 0 and 100%.
241         require(0 <= _fee && _fee <= 100000);
242         fee = _fee;
243     }
244     
245     /// @dev Checks whether the given auction is active.
246     /// @param auction The auction to check for activity.
247     function _activeAuction(Auction storage auction) internal view returns (bool) {
248         return auction.startedAt > 0;
249     }
250     
251     /// @dev Put the deed into escrow, thereby taking ownership of it.
252     /// @param _deedId The identifier of the deed to place into escrow.
253     function _escrow(uint256 _deedId) internal {
254         // Throws if the transfer fails
255         deedContract.takeOwnership(_deedId);
256     }
257     
258     /// @dev Create the auction.
259     /// @param _deedId The identifier of the deed to create the auction for.
260     /// @param auction The auction to create.
261     function _createAuction(uint256 _deedId, Auction auction) internal {
262         // Add the auction to the auction mapping.
263         identifierToAuction[_deedId] = auction;
264         
265         // Trigger auction created event.
266         AuctionCreated(auction.seller, _deedId, auction.startPrice, auction.endPrice, auction.duration);
267     }
268     
269     /// @dev Bid on an auction.
270     /// @param _buyer The address of the buyer.
271     /// @param _value The value sent by the sender (in ether).
272     /// @param _deedId The identifier of the deed to bid on.
273     function _bid(address _buyer, uint256 _value, uint256 _deedId) internal {
274         Auction storage auction = identifierToAuction[_deedId];
275         
276         // The auction must be active.
277         require(_activeAuction(auction));
278         
279         // Calculate the auction's current price.
280         uint256 price = _currentPrice(auction);
281         
282         // Make sure enough funds were sent.
283         require(_value >= price);
284         
285         address seller = auction.seller;
286     
287         if (price > 0) {
288             uint256 totalFee = _calculateFee(price);
289             uint256 proceeds = price - totalFee;
290             
291             // Assign the proceeds to the seller.
292             // We do not send the proceeds directly, as to prevent
293             // malicious sellers from denying auctions (and burning
294             // the buyer's gas).
295             _assignProceeds(seller, proceeds);
296         }
297         
298         AuctionSuccessful(_buyer, _deedId, price);
299         
300         // The bid was won!
301         _winBid(seller, _buyer, _deedId, price);
302         
303         // Remove the auction (we do this at the end, as
304         // winBid might require some additional information
305         // that will be removed when _removeAuction is
306         // called. As we do not transfer funds here, we do
307         // not have to worry about re-entry attacks.
308         _removeAuction(_deedId);
309     }
310 
311     /// @dev Perform the bid win logic (in this case: transfer the deed).
312     /// @param _seller The address of the seller.
313     /// @param _winner The address of the winner.
314     /// @param _deedId The identifier of the deed.
315     /// @param _price The price the auction was bought at.
316     function _winBid(address _seller, address _winner, uint256 _deedId, uint256 _price) internal {
317         _transfer(_winner, _deedId);
318     }
319     
320     /// @dev Cancel an auction.
321     /// @param _deedId The identifier of the deed for which the auction should be cancelled.
322     /// @param auction The auction to cancel.
323     function _cancelAuction(uint256 _deedId, Auction auction) internal {
324         // Remove the auction
325         _removeAuction(_deedId);
326         
327         // Transfer the deed back to the seller
328         _transfer(auction.seller, _deedId);
329         
330         // Trigger auction cancelled event.
331         AuctionCancelled(_deedId);
332     }
333     
334     /// @dev Remove an auction.
335     /// @param _deedId The identifier of the deed for which the auction should be removed.
336     function _removeAuction(uint256 _deedId) internal {
337         delete identifierToAuction[_deedId];
338     }
339     
340     /// @dev Transfer a deed owned by this contract to another address.
341     /// @param _to The address to transfer the deed to.
342     /// @param _deedId The identifier of the deed.
343     function _transfer(address _to, uint256 _deedId) internal {
344         // Throws if the transfer fails
345         deedContract.transfer(_to, _deedId);
346     }
347     
348     /// @dev Assign proceeds to an address.
349     /// @param _to The address to assign proceeds to.
350     /// @param _value The proceeds to assign.
351     function _assignProceeds(address _to, uint256 _value) internal {
352         outstandingEther += _value;
353         addressToEtherOwed[_to] += _value;
354     }
355     
356     /// @dev Calculate the current price of an auction.
357     function _currentPrice(Auction storage _auction) internal view returns (uint256) {
358         require(now >= _auction.startedAt);
359         
360         uint256 secondsPassed = now - _auction.startedAt;
361         
362         if (secondsPassed >= _auction.duration) {
363             return _auction.endPrice;
364         } else {
365             // Negative if the end price is higher than the start price!
366             int256 totalPriceChange = int256(_auction.endPrice) - int256(_auction.startPrice);
367             
368             // Calculate the current price based on the total change over the entire
369             // auction duration, and the amount of time passed since the start of the
370             // auction.
371             int256 currentPriceChange = totalPriceChange * int256(secondsPassed) / int256(_auction.duration);
372             
373             // Calculate the final price. Note this once again
374             // is representable by a uint256, as the price can
375             // never be negative.
376             int256 price = int256(_auction.startPrice) + currentPriceChange;
377             
378             // This never throws.
379             assert(price >= 0);
380             
381             return uint256(price);
382         }
383     }
384     
385     /// @dev Calculate the fee for a given price.
386     /// @param _price The price to calculate the fee for.
387     function _calculateFee(uint256 _price) internal view returns (uint256) {
388         // _price is guaranteed to fit in a uint128 due to the createAuction entry
389         // modifiers, so this cannot overflow.
390         return _price * fee / 100000;
391     }
392 }
393 
394 
395 contract ClockAuction is ClockAuctionBase, Pausable {
396     function ClockAuction(address _deedContractAddress, uint256 _fee) 
397         ClockAuctionBase(_deedContractAddress, _fee)
398         public
399     {}
400     
401     /// @notice Update the auction fee.
402     /// @param _fee The new fee.
403     function setFee(uint256 _fee) external onlyOwner {
404         require(0 <= _fee && _fee <= 100000);
405     
406         fee = _fee;
407     }
408     
409     /// @notice Get the auction for the given deed.
410     /// @param _deedId The identifier of the deed to get the auction for.
411     /// @dev Throws if there is no auction for the given deed.
412     function getAuction(uint256 _deedId) external view returns (
413             address seller,
414             uint256 startPrice,
415             uint256 endPrice,
416             uint256 duration,
417             uint256 startedAt
418         )
419     {
420         Auction storage auction = identifierToAuction[_deedId];
421         
422         // The auction must be active
423         require(_activeAuction(auction));
424         
425         return (
426             auction.seller,
427             auction.startPrice,
428             auction.endPrice,
429             auction.duration,
430             auction.startedAt
431         );
432     }
433 
434     /// @notice Create an auction for a given deed.
435     /// Must previously have been given approval to take ownership of the deed.
436     /// @param _deedId The identifier of the deed to create an auction for.
437     /// @param _startPrice The starting price of the auction.
438     /// @param _endPrice The ending price of the auction.
439     /// @param _duration The duration in seconds of the dynamic pricing part of the auction.
440     function createAuction(uint256 _deedId, uint256 _startPrice, uint256 _endPrice, uint256 _duration)
441         public
442         fitsIn128Bits(_startPrice)
443         fitsIn128Bits(_endPrice)
444         fitsIn64Bits(_duration)
445         whenNotPaused
446     {
447         // Get the owner of the deed to be auctioned
448         address deedOwner = deedContract.ownerOf(_deedId);
449     
450         // Caller must either be the deed contract or the owner of the deed
451         // to prevent abuse.
452         require(
453             msg.sender == address(deedContract) ||
454             msg.sender == deedOwner
455         );
456     
457         // The duration of the auction must be at least 60 seconds.
458         require(_duration >= 60);
459     
460         // Throws if placing the deed in escrow fails (the contract requires
461         // transfer approval prior to creating the auction).
462         _escrow(_deedId);
463         
464         // Auction struct
465         Auction memory auction = Auction(
466             deedOwner,
467             uint128(_startPrice),
468             uint128(_endPrice),
469             uint64(_duration),
470             uint64(now)
471         );
472         
473         _createAuction(_deedId, auction);
474     }
475     
476     /// @notice Cancel an auction
477     /// @param _deedId The identifier of the deed to cancel the auction for.
478     function cancelAuction(uint256 _deedId) external whenNotPaused {
479         Auction storage auction = identifierToAuction[_deedId];
480         
481         // The auction must be active.
482         require(_activeAuction(auction));
483         
484         // The auction can only be cancelled by the seller
485         require(msg.sender == auction.seller);
486         
487         _cancelAuction(_deedId, auction);
488     }
489     
490     /// @notice Bid on an auction.
491     /// @param _deedId The identifier of the deed to bid on.
492     function bid(uint256 _deedId) external payable whenNotPaused {
493         // Throws if the bid does not succeed.
494         _bid(msg.sender, msg.value, _deedId);
495     }
496     
497     /// @dev Returns the current price of an auction.
498     /// @param _deedId The identifier of the deed to get the currency price for.
499     function getCurrentPrice(uint256 _deedId) external view returns (uint256) {
500         Auction storage auction = identifierToAuction[_deedId];
501         
502         // The auction must be active.
503         require(_activeAuction(auction));
504         
505         return _currentPrice(auction);
506     }
507     
508     /// @notice Withdraw ether owed to a beneficiary.
509     /// @param beneficiary The address to withdraw the auction balance for.
510     function withdrawAuctionBalance(address beneficiary) external {
511         // The sender must either be the beneficiary or the core deed contract.
512         require(
513             msg.sender == beneficiary ||
514             msg.sender == address(deedContract)
515         );
516         
517         uint256 etherOwed = addressToEtherOwed[beneficiary];
518         
519         // Ensure ether is owed to the beneficiary.
520         require(etherOwed > 0);
521          
522         // Set ether owed to 0   
523         delete addressToEtherOwed[beneficiary];
524         
525         // Subtract from total outstanding balance. etherOwed is guaranteed
526         // to be less than or equal to outstandingEther, so this cannot
527         // underflow.
528         outstandingEther -= etherOwed;
529         
530         // Transfer ether owed to the beneficiary (not susceptible to re-entry
531         // attack, as the ether owed is set to 0 before the transfer takes place).
532         beneficiary.transfer(etherOwed);
533     }
534     
535     /// @notice Withdraw (unowed) contract balance.
536     function withdrawFreeBalance() external {
537         // Calculate the free (unowed) balance. This never underflows, as
538         // outstandingEther is guaranteed to be less than or equal to the
539         // contract balance.
540         uint256 freeBalance = this.balance - outstandingEther;
541         
542         address deedContractAddress = address(deedContract);
543 
544         require(
545             msg.sender == owner ||
546             msg.sender == deedContractAddress
547         );
548         
549         deedContractAddress.transfer(freeBalance);
550     }
551 }
552 
553 
554 contract SaleAuction is ClockAuction {
555     function SaleAuction(address _deedContractAddress, uint256 _fee) ClockAuction(_deedContractAddress, _fee) public {}
556     
557     /// @dev Allows other contracts to check whether this is the expected contract.
558     bool public isSaleAuction = true;
559 }