1 // PixelCoins Source code
2 pragma solidity ^0.4.11;
3 
4 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
5 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
6 contract ERC721 {
7     // Required methods
8     function totalSupply() public view returns (uint256 total);
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function ownerOf(uint256 _tokenId) external view returns (address owner);
11     function approve(address _to, uint256 _tokenId) external;
12     function transfer(address _to, uint256 _tokenId) external;
13     function transferFrom(address _from, address _to, uint256 _tokenId) external;
14 
15     // Events
16     event Transfer(address from, address to, uint256 tokenId);
17     event Approval(address owner, address approved, uint256 tokenId);
18 
19     // Optional
20     // function name() public view returns (string name);
21     // function symbol() public view returns (string symbol);
22     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
23     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
24 
25     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
26     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
27 }
28 
29 
30 /// @title A facet of PixelCore that manages special access privileges.
31 /// @author Oliver Schneider <info@pixelcoins.io> (https://pixelcoins.io)
32 contract PixelAuthority {
33 
34     /// @dev Emited when contract is upgraded
35     event ContractUpgrade(address newContract);
36 
37     address public authorityAddress;
38     uint public authorityBalance = 0;
39 
40     /// @dev Access modifier for authority-only functionality
41     modifier onlyAuthority() {
42         require(msg.sender == authorityAddress);
43         _;
44     }
45 
46     /// @dev Assigns a new address to act as the authority. Only available to the current authority.
47     /// @param _newAuthority The address of the new authority
48     function setAuthority(address _newAuthority) external onlyAuthority {
49         require(_newAuthority != address(0));
50         authorityAddress = _newAuthority;
51     }
52 
53 }
54 
55 
56 /// @title Base contract for PixelCoins. Holds all common structs, events and base variables.
57 /// @author Oliver Schneider <info@pixelcoins.io> (https://pixelcoins.io)
58 /// @dev See the PixelCore contract documentation to understand how the various contract facets are arranged.
59 contract PixelBase is PixelAuthority {
60     /*** EVENTS ***/
61 
62     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a Pixel
63     ///  ownership is assigned.
64     event Transfer(address from, address to, uint256 tokenId);
65 
66     /*** CONSTANTS ***/
67     uint32 public WIDTH = 1000;
68     uint32 public HEIGHT = 1000;
69 
70     /*** STORAGE ***/
71     /// @dev A mapping from pixel ids to the address that owns them. A pixel address of 0 means,
72     /// that the pixel can still be bought.
73     mapping (uint256 => address) public pixelIndexToOwner;
74     /// Address that is approved to change ownship
75     mapping (uint256 => address) public pixelIndexToApproved;
76     /// Stores the color of an pixel, indexed by pixelid
77     mapping (uint256 => uint32) public colors;
78     // @dev A mapping from owner address to count of tokens that address owns.
79     //  Used internally inside balanceOf() to resolve ownership count.
80     mapping (address => uint256) ownershipTokenCount;
81 
82     // Internal utility functions: These functions all assume that their input arguments
83     // are valid. We leave it to public methods to sanitize their inputs and follow
84     // the required logic.
85 
86     /// @dev Assigns ownership of a specific Pixel to an address.
87     function _transfer(address _from, address _to, uint256 _tokenId) internal {
88         // Can no overflowe since the number of Pixels is capped.
89         // transfer ownership
90         ownershipTokenCount[_to]++;
91         pixelIndexToOwner[_tokenId] = _to;
92         if (_from != address(0)) {
93             ownershipTokenCount[_from]--;
94             delete pixelIndexToApproved[_tokenId];
95         }
96         // Emit the transfer event.
97         Transfer(_from, _to, _tokenId);
98     }
99 
100     /// @dev Checks if a given address is the current owner of a particular Pixel.
101     /// @param _claimant the address we are validating against.
102     /// @param _tokenId Pixel id
103     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
104         return pixelIndexToOwner[_tokenId] == _claimant;
105     }
106 
107     /// @dev Checks if a given address currently has transferApproval for a particular Pixel.
108     /// @param _claimant the address we are confirming pixel is approved for.
109     /// @param _tokenId pixel id, only valid when > 0
110     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
111         return pixelIndexToApproved[_tokenId] == _claimant;
112     }
113 }
114 
115 
116 /// @title The facet of the PixelCoins core contract that manages ownership, ERC-721 (draft) compliant.
117 /// @author Oliver Schneider <info@pixelcoins.io> (https://pixelcoins.io), based on Axiom Zen (https://www.axiomzen.co)
118 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
119 ///  See the PixelCore contract documentation to understand how the various contract facets are arranged.
120 contract PixelOwnership is PixelBase, ERC721 {
121 
122     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
123     string public constant name = "PixelCoins";
124     string public constant symbol = "PXL";
125 
126 
127     bytes4 constant InterfaceSignature_ERC165 =
128         bytes4(keccak256('supportsInterface(bytes4)'));
129 
130     bytes4 constant InterfaceSignature_ERC721 =
131         bytes4(keccak256('name()')) ^
132         bytes4(keccak256('symbol()')) ^
133         bytes4(keccak256('totalSupply()')) ^
134         bytes4(keccak256('balanceOf(address)')) ^
135         bytes4(keccak256('ownerOf(uint256)')) ^
136         bytes4(keccak256('approve(address,uint256)')) ^
137         bytes4(keccak256('transfer(address,uint256)')) ^
138         bytes4(keccak256('transferFrom(address,address,uint256)')) ^
139         bytes4(keccak256('tokensOfOwner(address)')) ^
140         bytes4(keccak256('tokenMetadata(uint256,string)'));
141 
142 
143     string public metaBaseUrl = "https://pixelcoins.io/meta/";
144 
145 
146     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
147     ///  Returns true for any standardized interfaces implemented by this contract. We implement
148     ///  ERC-165 (obviously!) and ERC-721.
149     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
150         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
151     }
152 
153     /// @notice Returns the number ofd Pixels owned by a specific address.
154     /// @param _owner The owner address to check.
155     /// @dev Required for ERC-721 compliance
156     function balanceOf(address _owner) public view returns (uint256 count) {
157         return ownershipTokenCount[_owner];
158     }
159 
160     /// @notice Transfers a Pixel to another address. If transferring to a smart
161     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
162     ///  PixelCoins specifically) or your Pixel may be lost forever. Seriously.
163     /// @param _to The address of the recipient, can be a user or contract.
164     /// @param _tokenId The ID of the Pixel to transfer.
165     /// @dev Required for ERC-721 compliance.
166     function transfer(
167         address _to,
168         uint256 _tokenId
169     )
170         external
171     {
172         // Safety check to prevent against an unexpected 0x0 default.
173         require(_to != address(0));
174         // Disallow transfers to this contract to prevent accidental misuse.
175         // The contract should never own any pixel (except very briefly
176         // after a gen0 cat is created and before it goes on auction).
177         require(_to != address(this));
178 
179         // You can only send your own pixel.
180         require(_owns(msg.sender, _tokenId));
181         // address is not currently managed by the contract (it is in an auction)
182         require(pixelIndexToApproved[_tokenId] != address(this));
183 
184         // Reassign ownership, clear pending approvals, emit Transfer event.
185         _transfer(msg.sender, _to, _tokenId);
186     }
187 
188     /// @notice Grant another address the right to transfer a specific pixel via
189     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
190     /// @param _to The address to be granted transfer approval. Pass address(0) to
191     ///  clear all approvals.
192     /// @param _tokenId The ID of the pixel that can be transferred if this call succeeds.
193     /// @dev Required for ERC-721 compliance.
194     function approve(
195         address _to,
196         uint256 _tokenId
197     )
198         external
199     {
200         // Only an owner can grant transfer approval.
201         require(_owns(msg.sender, _tokenId));
202         // address is not currently managed by the contract (it is in an auction)
203         require(pixelIndexToApproved[_tokenId] != address(this));
204 
205         // Register the approval (replacing any previous approval).
206         pixelIndexToApproved[_tokenId] = _to;
207 
208         // Emit approval event.
209         Approval(msg.sender, _to, _tokenId);
210     }
211 
212     /// @notice Transfer a Pixel owned by another address, for which the calling address
213     ///  has previously been granted transfer approval by the owner.
214     /// @param _from The address that owns the pixel to be transfered.
215     /// @param _to The address that should take ownership of the Pixel. Can be any address,
216     ///  including the caller.
217     /// @param _tokenId The ID of the Pixel to be transferred.
218     /// @dev Required for ERC-721 compliance.
219     function transferFrom(
220         address _from,
221         address _to,
222         uint256 _tokenId
223     )
224         external
225     {
226         // Safety check to prevent against an unexpected 0x0 default.
227         require(_to != address(0));
228         // Disallow transfers to this contract to prevent accidental misuse.
229         // The contract should never own anyd Pixels (except very briefly
230         // after a gen0 cat is created and before it goes on auction).
231         require(_to != address(this));
232         // Check for approval and valid ownership
233         require(_approvedFor(msg.sender, _tokenId));
234         require(_owns(_from, _tokenId));
235 
236         // Reassign ownership (also clears pending approvals and emits Transfer event).
237         _transfer(_from, _to, _tokenId);
238     }
239 
240     /// @notice Returns the total number of pixels currently in existence.
241     /// @dev Required for ERC-721 compliance.
242     function totalSupply() public view returns (uint) {
243         return WIDTH * HEIGHT;
244     }
245 
246     /// @notice Returns the address currently assigned ownership of a given Pixel.
247     /// @dev Required for ERC-721 compliance.
248     function ownerOf(uint256 _tokenId)
249         external
250         view
251         returns (address owner)
252     {
253         owner = pixelIndexToOwner[_tokenId];
254         require(owner != address(0));
255     }
256 
257     /// @notice Returns the addresses currently assigned ownership of the given pixel area.
258     function ownersOfArea(uint256 x, uint256 y, uint256 x2, uint256 y2) external view returns (address[] result) {
259         require(x2 > x && y2 > y);
260         require(x2 <= WIDTH && y2 <= HEIGHT);
261         result = new address[]((y2 - y) * (x2 - x));
262 
263         uint256 r = 0;
264         for (uint256 i = y; i < y2; i++) {
265             uint256 tokenId = i * WIDTH;
266             for (uint256 j = x; j < x2; j++) {
267                 result[r] = pixelIndexToOwner[tokenId + j];
268                 r++;
269             }
270         }
271     }
272 
273     /// @notice Returns a list of all Pixel IDs assigned to an address.
274     /// @param _owner The owner whosed Pixels we are interested in.
275     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
276     ///  expensive (it walks the entire Pixel array looking for pixels belonging to owner),
277     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
278     ///  not contract-to-contract calls.
279     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
280         uint256 tokenCount = balanceOf(_owner);
281 
282         if (tokenCount == 0) {
283             // Return an empty array
284             return new uint256[](0);
285         } else {
286             uint256[] memory result = new uint256[](tokenCount);
287             uint256 totalPixels = totalSupply();
288             uint256 resultIndex = 0;
289 
290             // We count on the fact that all pixels have IDs starting at 0 and increasing
291             // sequentially up to the totalCat count.
292             uint256 pixelId;
293 
294             for (pixelId = 0; pixelId <= totalPixels; pixelId++) {
295                 if (pixelIndexToOwner[pixelId] == _owner) {
296                     result[resultIndex] = pixelId;
297                     resultIndex++;
298                 }
299             }
300 
301             return result;
302         }
303     }
304 
305     // Taken from https://ethereum.stackexchange.com/a/10929
306     function uintToString(uint v) constant returns (string str) {
307         uint maxlength = 100;
308         bytes memory reversed = new bytes(maxlength);
309         uint i = 0;
310         while (v != 0) {
311             uint remainder = v % 10;
312             v = v / 10;
313             reversed[i++] = byte(48 + remainder);
314         }
315         bytes memory s = new bytes(i);
316         for (uint j = 0; j < i; j++) {
317             s[j] = reversed[i - 1 - j];
318         }
319         str = string(s);
320     }
321 
322     // Taken from https://ethereum.stackexchange.com/a/10929
323     function appendUintToString(string inStr, uint v) constant returns (string str) {
324         uint maxlength = 100;
325         bytes memory reversed = new bytes(maxlength);
326         uint i = 0;
327         while (v != 0) {
328             uint remainder = v % 10;
329             v = v / 10;
330             reversed[i++] = byte(48 + remainder);
331         }
332         bytes memory inStrb = bytes(inStr);
333         bytes memory s = new bytes(inStrb.length + i);
334         uint j;
335         for (j = 0; j < inStrb.length; j++) {
336             s[j] = inStrb[j];
337         }
338         for (j = 0; j < i; j++) {
339             s[j + inStrb.length] = reversed[i - 1 - j];
340         }
341         str = string(s);
342     }
343 
344     function setMetaBaseUrl(string _metaBaseUrl) external onlyAuthority {
345         metaBaseUrl = _metaBaseUrl;
346     }
347 
348     /// @notice Returns a URI pointing to a metadata package for this token conforming to
349     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
350     /// @param _tokenId The ID number of the Pixel whose metadata should be returned.
351     function tokenMetadata(uint256 _tokenId) external view returns (string infoUrl) {
352         return appendUintToString(metaBaseUrl, _tokenId);
353     }
354 }
355 
356 contract PixelPainting is PixelOwnership {
357 
358     event Paint(uint256 tokenId, uint32 color);
359 
360     // Sets the color of an individual pixel
361     function setPixelColor(uint256 _tokenId, uint32 _color) external {
362         // check that the token id is in the range
363         require(_tokenId < HEIGHT * WIDTH);
364         // check that the sender is owner of the pixel
365         require(_owns(msg.sender, _tokenId));
366         colors[_tokenId] = _color;
367     }
368 
369     // Sets the color of the pixels in an area, left to right and then top to bottom
370     function setPixelAreaColor(uint256 x, uint256 y, uint256 x2, uint256 y2, uint32[] _colors) external {
371         require(x2 > x && y2 > y);
372         require(x2 <= WIDTH && y2 <= HEIGHT);
373         require(_colors.length == (y2 - y) * (x2 - x));
374         uint256 r = 0;
375         for (uint256 i = y; i < y2; i++) {
376             uint256 tokenId = i * WIDTH;
377             for (uint256 j = x; j < x2; j++) {
378                 if (_owns(msg.sender, tokenId + j)) {
379                     uint32 color = _colors[r];
380                     colors[tokenId + j] = color;
381                     Paint(tokenId + j, color);
382                 }
383                 r++;
384             }
385         }
386     }
387 
388     // Returns the color of a given pixel
389     function getPixelColor(uint256 _tokenId) external view returns (uint32 color) {
390         require(_tokenId < HEIGHT * WIDTH);
391         color = colors[_tokenId];
392     }
393 
394     // Returns the colors of the pixels in an area, left to right and then top to bottom
395     function getPixelAreaColor(uint256 x, uint256 y, uint256 x2, uint256 y2) external view returns (uint32[] result) {
396         require(x2 > x && y2 > y);
397         require(x2 <= WIDTH && y2 <= HEIGHT);
398         result = new uint32[]((y2 - y) * (x2 - x));
399         uint256 r = 0;
400         for (uint256 i = y; i < y2; i++) {
401             uint256 tokenId = i * WIDTH;
402             for (uint256 j = x; j < x2; j++) {
403                 result[r] = colors[tokenId + j];
404                 r++;
405             }
406         }
407     }
408 }
409 
410 
411 /// @title all functions for buying empty pixels
412 contract PixelMinting is PixelPainting {
413 
414     uint public pixelPrice = 3030 szabo;
415 
416     // Set the price for a pixel
417     function setNewPixelPrice(uint _pixelPrice) external onlyAuthority {
418         pixelPrice = _pixelPrice;
419     }
420     
421     // buy en empty pixel
422     function buyEmptyPixel(uint256 _tokenId) external payable {
423         require(msg.value == pixelPrice);
424         require(_tokenId < HEIGHT * WIDTH);
425         require(pixelIndexToOwner[_tokenId] == address(0));
426         // increase authority balance
427         authorityBalance += msg.value;
428         // This will assign ownership, and also emit the Transfer event as
429         // per ERC721 draft
430         _transfer(0, msg.sender, _tokenId);
431     }
432 
433     // buy an area of pixels, left to right, top to bottom
434     function buyEmptyPixelArea(uint256 x, uint256 y, uint256 x2, uint256 y2) external payable {
435         require(x2 > x && y2 > y);
436         require(x2 <= WIDTH && y2 <= HEIGHT);
437         require(msg.value == pixelPrice * (x2-x) * (y2-y));
438         
439         uint256 i;
440         uint256 tokenId;
441         uint256 j;
442         // check that all pixels to buy are available
443         for (i = y; i < y2; i++) {
444             tokenId = i * WIDTH;
445             for (j = x; j < x2; j++) {
446                 require(pixelIndexToOwner[tokenId + j] == address(0));
447             }
448         }
449 
450         authorityBalance += msg.value;
451 
452         // Do the actual transfer
453         for (i = y; i < y2; i++) {
454             tokenId = i * WIDTH;
455             for (j = x; j < x2; j++) {
456                 _transfer(0, msg.sender, tokenId + j);
457             }
458         }
459     }
460 
461 }
462 
463 /// @title all functions for managing pixel auctions
464 contract PixelAuction is PixelMinting {
465 
466     // Represents an auction on an NFT
467     struct Auction {
468          // Current state of the auction.
469         address highestBidder;
470         uint highestBid;
471         uint256 endTime;
472         bool live;
473     }
474 
475     // Map from token ID to their corresponding auction.
476     mapping (uint256 => Auction) tokenIdToAuction;
477     // Allowed withdrawals of previous bids
478     mapping (address => uint) pendingReturns;
479 
480     // Duration of an auction
481     uint256 public duration = 60 * 60 * 24 * 4;
482     // Auctions will be enabled later
483     bool public auctionsEnabled = false;
484 
485     // Change the duration for new auctions
486     function setDuration(uint _duration) external onlyAuthority {
487         duration = _duration;
488     }
489 
490     // Enable or disable auctions
491     function setAuctionsEnabled(bool _auctionsEnabled) external onlyAuthority {
492         auctionsEnabled = _auctionsEnabled;
493     }
494 
495     // create a new auctions for a given pixel, only owner or authority can do this
496     // The authority will only do this if pixels are misused or lost
497     function createAuction(
498         uint256 _tokenId
499     )
500         external payable
501     {
502         // only authority or owner can start auction
503         require(auctionsEnabled);
504         require(_owns(msg.sender, _tokenId) || msg.sender == authorityAddress);
505         // No auction is currently running
506         require(!tokenIdToAuction[_tokenId].live);
507 
508         uint startPrice = pixelPrice;
509         if (msg.sender == authorityAddress) {
510             startPrice = 0;
511         }
512 
513         require(msg.value == startPrice);
514         // this prevents transfers during the auction
515         pixelIndexToApproved[_tokenId] = address(this);
516 
517         tokenIdToAuction[_tokenId] = Auction(
518             msg.sender,
519             startPrice,
520             block.timestamp + duration,
521             true
522         );
523         AuctionStarted(_tokenId);
524     }
525 
526     // bid for an pixel auction
527     function bid(uint256 _tokenId) external payable {
528         // No arguments are necessary, all
529         // information is already part of
530         // the transaction. The keyword payable
531         // is required for the function to
532         // be able to receive Ether.
533         Auction storage auction = tokenIdToAuction[_tokenId];
534 
535         // Revert the call if the bidding
536         // period is over.
537         require(auction.live);
538         require(auction.endTime > block.timestamp);
539 
540         // If the bid is not higher, send the
541         // money back.
542         require(msg.value > auction.highestBid);
543 
544         if (auction.highestBidder != 0) {
545             // Sending back the money by simply using
546             // highestBidder.send(highestBid) is a security risk
547             // because it could execute an untrusted contract.
548             // It is always safer to let the recipients
549             // withdraw their money themselves.
550             pendingReturns[auction.highestBidder] += auction.highestBid;
551         }
552         
553         auction.highestBidder = msg.sender;
554         auction.highestBid = msg.value;
555 
556         HighestBidIncreased(_tokenId, msg.sender, msg.value);
557     }
558 
559     /// Withdraw a bid that was overbid.
560     function withdraw() external returns (bool) {
561         uint amount = pendingReturns[msg.sender];
562         if (amount > 0) {
563             // It is important to set this to zero because the recipient
564             // can call this function again as part of the receiving call
565             // before `send` returns.
566             pendingReturns[msg.sender] = 0;
567 
568             if (!msg.sender.send(amount)) {
569                 // No need to call throw here, just reset the amount owing
570                 pendingReturns[msg.sender] = amount;
571                 return false;
572             }
573         }
574         return true;
575     }
576 
577     // /// End the auction and send the highest bid
578     // /// to the beneficiary.
579     function endAuction(uint256 _tokenId) external {
580         // It is a good guideline to structure functions that interact
581         // with other contracts (i.e. they call functions or send Ether)
582         // into three phases:
583         // 1. checking conditions
584         // 2. performing actions (potentially changing conditions)
585         // 3. interacting with other contracts
586         // If these phases are mixed up, the other contract could call
587         // back into the current contract and modify the state or cause
588         // effects (ether payout) to be performed multiple times.
589         // If functions called internally include interaction with external
590         // contracts, they also have to be considered interaction with
591         // external contracts.
592 
593         Auction storage auction = tokenIdToAuction[_tokenId];
594 
595         // 1. Conditions
596         require(auction.endTime < block.timestamp);
597         require(auction.live); // this function has already been called
598 
599         // 2. Effects
600         auction.live = false;
601         AuctionEnded(_tokenId, auction.highestBidder, auction.highestBid);
602 
603         // 3. Interaction
604         address owner = pixelIndexToOwner[_tokenId];
605         // transfer money without 
606         uint amount = auction.highestBid * 9 / 10;
607         pendingReturns[owner] += amount;
608         authorityBalance += (auction.highestBid - amount);
609         // transfer token
610         _transfer(owner, auction.highestBidder, _tokenId);
611 
612        
613     }
614 
615     // // Events that will be fired on changes.
616     event AuctionStarted(uint256 _tokenId);
617     event HighestBidIncreased(uint256 _tokenId, address bidder, uint amount);
618     event AuctionEnded(uint256 _tokenId, address winner, uint amount);
619 
620 
621     /// @dev Returns auction info for an NFT on auction.
622     /// @param _tokenId - ID of NFT on auction.
623     function getAuction(uint256 _tokenId)
624         external
625         view
626         returns
627     (
628         address highestBidder,
629         uint highestBid,
630         uint endTime,
631         bool live
632     ) {
633         Auction storage auction = tokenIdToAuction[_tokenId];
634         return (
635             auction.highestBidder,
636             auction.highestBid,
637             auction.endTime,
638             auction.live
639         );
640     }
641 
642     /// @dev Returns the current price of an auction.
643     /// @param _tokenId - ID of the token price we are checking.
644     function getHighestBid(uint256 _tokenId)
645         external
646         view
647         returns (uint256)
648     {
649         Auction storage auction = tokenIdToAuction[_tokenId];
650         return auction.highestBid;
651     }
652 }
653 
654 
655 /// @title PixelCore: Pixels in the blockchain
656 /// @author Oliver Schneider <info@pixelcoins.io> (https://pixelcoins.io), based on Axiom Zen (https://www.axiomzen.co)
657 /// @dev The main PixelCoins contract
658 contract PixelCore is PixelAuction {
659 
660     // Set in case the core contract is broken and an upgrade is required
661     address public newContractAddress;
662 
663     /// @notice Creates the main PixelCore smart contract instance.
664     function PixelCore() public {
665         // the creator of the contract is the initial authority
666         authorityAddress = msg.sender;
667     }
668 
669     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
670     ///  breaking bug. This method does nothing but keep track of the new contract and
671     ///  emit a message indicating that the new address is set. It's up to clients of this
672     ///  contract to update to the new contract address in that case. (This contract will
673     ///  be paused indefinitely if such an upgrade takes place.)
674     /// @param _v2Address new address
675     function setNewAddress(address _v2Address) external onlyAuthority {
676         newContractAddress = _v2Address;
677         ContractUpgrade(_v2Address);
678     }
679 
680     // @dev Allows the authority to capture the balance available to the contract.
681     function withdrawBalance() external onlyAuthority returns (bool) {
682         uint amount = authorityBalance;
683         if (amount > 0) {
684             authorityBalance = 0;
685             if (!authorityAddress.send(amount)) {
686                 authorityBalance = amount;
687                 return false;
688             }
689         }
690         return true;
691     }
692 }