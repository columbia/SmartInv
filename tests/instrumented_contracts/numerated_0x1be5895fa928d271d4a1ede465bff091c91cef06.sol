1 pragma solidity ^0.5.12;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 /**
69  * Utility library of inline functions on addresses
70  */
71 library Address {
72     /**
73      * Returns whether the target address is a contract
74      * @dev This function will return false if invoked during the constructor of a contract,
75      * as the code is not actually created until after the constructor finishes.
76      * @param account address of the account to check
77      * @return whether the target address is a contract
78      */
79     function isContract(address account) internal view returns (bool) {
80         uint256 size;
81         // XXX Currently there is no better way to check if there is a contract in an address
82         // than to check the size of the code at that address.
83         // See https://ethereum.stackexchange.com/a/14016/36603
84         // for more details about how this works.
85         // TODO Check this again before the Serenity release, because all addresses will be
86         // contracts then.
87         // solhint-disable-next-line no-inline-assembly
88         assembly { size := extcodesize(account) }
89         return size > 0;
90     }
91 }
92 
93 
94 /**
95  * @title Counters
96  * @author Matt Condon (@shrugs)
97  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
98  * of elements in a mapping, issuing ERC721 ids, or counting request ids
99  *
100  * Include with `using Counter for Counter.Counter;`
101  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
102  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
103  * directly accessed.
104  */
105 library Counters {
106     using SafeMath for uint256;
107 
108     struct Counter {
109         // This variable should never be directly accessed by users of the library: interactions must be restricted to
110         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
111         // this feature: see https://github.com/ethereum/solidity/issues/4637
112         uint256 _value; // default: 0
113     }
114 
115     function current(Counter storage counter) internal view returns (uint256) {
116         return counter._value;
117     }
118     
119     function set(Counter storage counter, uint256 value) internal returns (uint256) {
120         counter._value = value;
121     }
122 
123     function increment(Counter storage counter) internal {
124         counter._value += 1;
125     }
126 
127     function decrement(Counter storage counter) internal {
128         counter._value = counter._value.sub(1);
129     }
130 }
131 
132 /**
133  * @title ERC721 token receiver interface
134  * @dev Interface for any contract that wants to support safeTransfers
135  * from ERC721 asset contracts.
136  */
137 contract IERC721Receiver {
138     /**
139      * @notice Handle the receipt of an NFT
140      * @dev The ERC721 smart contract calls this function on the recipient
141      * after a `safeTransfer`. This function MUST return the function selector,
142      * otherwise the caller will revert the transaction. The selector to be
143      * returned can be obtained as `this.onERC721Received.selector`. This
144      * function MAY throw to revert and reject the transfer.
145      * Note: the ERC721 contract address is always the message sender.
146      * @param operator The address which called `safeTransferFrom` function
147      * @param from The address which previously owned the token
148      * @param tokenId The NFT identifier which is being transferred
149      * @param data Additional data with no specified format
150      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
151      */
152     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
153     public returns (bytes4);
154 }
155 
156 /**
157  * @title CryptoTitties Implementation of ERC721
158  * @dev ERC721, ERC721Meta plus custom market implementation.
159  */
160 contract CryptoTitties {
161 
162     using SafeMath for uint;
163     using Address for address;
164     using Counters for Counters.Counter;
165     
166     // ----------------------------------------------------------------------------
167     // Contract ownership
168     // ----------------------------------------------------------------------------
169     
170     // - variables
171     address public _ownershipOwner;
172     address public _ownershipNewOwner;
173     
174     // - events
175     event OwnershipTransferred(address indexed _from, address indexed _to);
176     
177     // - modifiers
178     modifier onlyOwner {
179         require(msg.sender == _ownershipOwner, "Only contract owner is allowed.");
180         _;
181     }
182 
183     // - functions
184 
185 
186     /**
187      * @notice Initialize contract ownership transfer
188      * @dev This function can be called only by current contract owner, 
189      * to initialize ownership transfer to other address.
190      * @param newOwner The address of desired new owner
191      */
192     function ownershipTransfer(address newOwner) public onlyOwner {
193         _ownershipNewOwner = newOwner;
194     }
195 
196     /**
197      * @notice Finish contract ownership transfer
198      * @dev This function can be called only by new contract owner, 
199      * to accept ownership transfer.
200      */
201     function ownershipAccept() public {
202         require(msg.sender == _ownershipNewOwner, "Only new contract owner is allowed to accept.");
203         emit OwnershipTransferred(_ownershipOwner, _ownershipNewOwner);
204         _ownershipOwner = _ownershipNewOwner;
205         _ownershipNewOwner = address(0);
206     }
207     
208     
209     
210     // ----------------------------------------------------------------------------
211     // ERC165
212     // ----------------------------------------------------------------------------
213     
214     // - variables
215     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
216     mapping(bytes4 => bool) private _supportedInterfaces;
217     
218     // - functions
219     function _registerInterface(bytes4 interfaceId) internal {
220         require(interfaceId != 0xffffffff);
221         _supportedInterfaces[interfaceId] = true;
222     }
223     
224     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
225         return _supportedInterfaces[interfaceId];
226     }
227     
228     // ----------------------------------------------------------------------------
229     // ERC721
230     // based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
231     // ----------------------------------------------------------------------------
232    
233     // - variables
234 
235     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
236     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
237     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
238 
239     // Mapping from token ID to owner
240     mapping (uint256 => address) private _tokenOwner;
241 
242     // Mapping from token ID to approved address
243     mapping (uint256 => address) private _tokenApprovals;
244 
245     // Mapping from owner to number of owned token
246     mapping (address => Counters.Counter) private _ownedTokensCount;
247 
248     // Mapping from owner to operator approvals
249     mapping (address => mapping (address => bool)) private _operatorApprovals;
250 
251     /*
252      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
253      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
254      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
255      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
256      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
257      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
258      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
259      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
260      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
261      *
262      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
263      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
264      */
265     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
266     
267 
268     // - events
269     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
270     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
271     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
272     
273 
274 	// - functions
275 
276     /**
277      * @dev Gets the balance of the specified address.
278      * @param owner address to query the balance of
279      * @return uint256 representing the amount owned by the passed address
280      */
281     function balanceOf(address owner) public view returns (uint256) {
282         require(owner != address(0));
283         return _ownedTokensCount[owner].current();
284     }
285 
286     /**
287      * @dev Gets the owner of the specified token ID.
288      * @param tokenId uint256 ID of the token to query the owner of
289      * @return address currently marked as the owner of the given token ID
290      */
291     function ownerOf(uint256 tokenId) public view returns (address) {
292         require(_exists(tokenId), "Token does not exists.");
293         return _ownerOf(tokenId);
294     }
295 
296     /**
297      * @dev Approves another address to transfer the given token ID
298      * The zero address indicates there is no approved address.
299      * There can only be one approved address per token at a given time.
300      * Can only be called by the token owner or an approved operator.
301      * @param to address to be approved for the given token ID
302      * @param tokenId uint256 ID of the token to be approved
303      */
304     function approve(address to, uint256 tokenId) public {
305         address owner = _ownerOf(tokenId);
306         require(to != owner);
307         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
308 
309         _tokenApprovals[tokenId] = to;
310         emit Approval(owner, to, tokenId);
311     }
312 
313     /**
314      * @dev Gets the approved address for a token ID, or zero if no address set
315      * Reverts if the token ID does not exist.
316      * @param tokenId uint256 ID of the token to query the approval of
317      * @return address currently approved for the given token ID
318      */
319     function getApproved(uint256 tokenId) public view returns (address) {
320         require(_exists(tokenId));
321         return _tokenApprovals[tokenId];
322     }
323 
324     /**
325      * @dev Sets or unsets the approval of a given operator
326      * An operator is allowed to transfer all tokens of the sender on their behalf.
327      * @param to operator address to set the approval
328      * @param approved representing the status of the approval to be set
329      */
330     function setApprovalForAll(address to, bool approved) public {
331         require(to != msg.sender);
332         _operatorApprovals[msg.sender][to] = approved;
333         emit ApprovalForAll(msg.sender, to, approved);
334     }
335 
336     /**
337      * @dev Tells whether an operator is approved by a given owner.
338      * @param owner owner address which you want to query the approval of
339      * @param operator operator address which you want to query the approval of
340      * @return bool whether the given operator is approved by the given owner
341      */
342     function isApprovedForAll(address owner, address operator) public view returns (bool) {
343         return _operatorApprovals[owner][operator];
344     }
345 
346     /**
347      * @dev Transfers the ownership of a given token ID to another address.
348      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
349      * Requires the msg.sender to be the owner, approved, or operator.
350      * @param from current owner of the token
351      * @param to address to receive the ownership of the given token ID
352      * @param tokenId uint256 ID of the token to be transferred
353      */
354     function transferFrom(address from, address to, uint256 tokenId) public {
355         require(_isApprovedOrOwner(msg.sender, tokenId));
356 		require(!_marketOfferExists(tokenId), "Token is offered on market can't be transfered.");
357         require(!_marketAuctionExists(tokenId), "Token is in auction can't be transfered.");
358         
359         _transferFrom(from, to, tokenId);
360     }
361 
362     /**
363      * @dev Safely transfers the ownership of a given token ID to another address
364      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
365      * which is called upon a safe transfer, and return the magic value
366      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
367      * the transfer is reverted.
368      * Requires the msg.sender to be the owner, approved, or operator
369      * @param from current owner of the token
370      * @param to address to receive the ownership of the given token ID
371      * @param tokenId uint256 ID of the token to be transferred
372      */
373     function safeTransferFrom(address from, address to, uint256 tokenId) public {
374         safeTransferFrom(from, to, tokenId, "");
375     }
376 
377     /**
378      * @dev Safely transfers the ownership of a given token ID to another address
379      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
380      * which is called upon a safe transfer, and return the magic value
381      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
382      * the transfer is reverted.
383      * Requires the _msgSender() to be the owner, approved, or operator
384      * @param from current owner of the token
385      * @param to address to receive the ownership of the given token ID
386      * @param tokenId uint256 ID of the token to be transferred
387      * @param _data bytes data to send along with a safe transfer check
388      */
389     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
390         transferFrom(from, to, tokenId);
391         require(_checkOnERC721Received(from, to, tokenId, _data));
392     }
393     
394     // ----------------------------------------------------------------------------
395     // ERC721 Meta
396     // based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721Metadata.sol
397     // ----------------------------------------------------------------------------
398     
399 
400     // - variables
401 
402     // Token name
403     string private _name;
404     
405     // Token symbol
406     string private _symbol;
407 
408     // Base uri to generate tokenURI
409     string private _baseTokenURI;
410 
411     //hash to prove token images not changes in time
412     string private _imagesJsonHash;
413 
414     /*
415      *     bytes4(keccak256('name()')) == 0x06fdde03
416      *     bytes4(keccak256('symbol()')) == 0x95d89b41
417      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
418      *
419      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
420      */
421     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
422     
423 
424     // - functions 
425 
426     /**
427      * @dev Gets the token name.
428      * @return string representing the token name
429      */
430     function name() external view returns (string memory) {
431         return _name;
432     }
433 
434     /**
435      * @dev Gets the token symbol.
436      * @return string representing the token symbol
437      */
438     function symbol() external view returns (string memory) {
439         return _symbol;
440     }
441 
442     /**
443      * @dev Returns an URI for a given token ID.
444      * Throws if the token ID does not exist.
445      * @param tokenId uint256 ID of the token to query
446      */
447     function tokenURI(uint256 tokenId) external view returns (string memory) {
448         require(_exists(tokenId));
449         return string(abi.encodePacked(_baseTokenURI, uint2str(tokenId)));
450     }
451     
452     /**
453      * @dev Returns saved hash.
454      * Throws if the token ID does not exist.
455      */
456     function imagesJsonHash() external view returns (string memory){
457     	return _imagesJsonHash;
458     }
459     
460     // ----------------------------------------------------------------------------
461     // ERC721 Meta Total suply
462     // added totalSuply functionality
463     // ----------------------------------------------------------------------------
464     
465     // - vars
466 
467     //total suply
468     uint256 private _totalSupply;
469     
470     // - functions
471 
472     /**
473      * @dev Returns totalSupply.
474      */
475     function totalSupply() public view returns (uint256 _supply) {
476         return _totalSupply;
477     }
478     
479     // ----------------------------------------------------------------------------
480     // Build In Market
481     // ----------------------------------------------------------------------------    
482     
483     // - types     
484 
485     /**
486     * @title MarketOffer
487     * @dev Stores information about token market offer.
488     */
489     struct MarketOffer {
490         bool isOffer;
491         address owner;
492         uint256 price;
493     }
494 
495     /**
496     * @title MarketAuction
497     * @dev Stores information about token market auction.
498     */
499     struct MarketAuction {
500         bool isAuction;
501         address highestBidder;
502         uint256 highestBid;
503         uint256 initPrice;
504         uint endTime;
505     }
506     
507     // - variables
508 
509     // Mapping from token ID to MarketOffer
510     mapping (uint256 => MarketOffer) private _marketOffers;
511 
512     // Mapping from token ID to MarketAuction
513     mapping (uint256 => MarketAuction) private _marketAuctions;
514 
515     // Mapping from address to marketBalance (ETH)
516     mapping (address => uint256) private _marketBalances;
517 
518     //Mapping from token ID to First owner of token
519     mapping (uint256 => address) private _tokenFirstOwner;
520 
521     //Address allowed to place tokens owned by contract to auction
522     address private _auctionsAddress;
523 
524     //Address allowed to gift (transfer) tokens owned by contract
525     address private _giftsAddress;
526     
527     // - events 
528     event MarketOfferCreated(address indexed _from, uint256 _tokenId, uint256 _price);
529     event MarketOfferRemoved(address indexed _from, uint256 _tokenId);
530     event MarketOfferSold(address indexed _owner, address indexed _buyer, uint256 _tokenId, uint256 _price);
531     event MarketAuctionCreated(uint256 _tokenId, uint256 _initPrice, uint256 _starttime, uint256 _endtime);
532     event MarketAuctionBid(uint256 _tokenId, uint256 _bid, address _bidder, address _old_bidder); 
533     event MarketAuctionClaimed(uint256 _tokenId, uint256 _bid, address _bidder); 
534     
535     // - functions
536 
537     /**
538      * @dev Sets new _auctionsAddress allowed to place tokens owned by 
539      * contract to auction.
540      * Requires the msg.sender to be the contract owner
541      * @param auctionsAddress new _auctionsAddress
542      */
543     function setAuctionAddress(address auctionsAddress) public onlyOwner {
544         _auctionsAddress = auctionsAddress;
545     }
546 
547     /**
548      * @dev Sets new _giftsAddress allowed to place tokens owned by 
549      * contract to auction.
550      * Requires the msg.sender to be the contract owner
551      * @param giftsAddress new _giftsAddress
552      */
553     function setGiftsAddress(address giftsAddress) public onlyOwner {
554         _giftsAddress = giftsAddress;
555     }
556     
557     /**
558      * @dev Gets token market price, returns 0 for tokens not on market.
559      * Requires token existence
560      * @param _tokenId uint256 ID of the token
561      */
562     function marketOfferGetTokenPrice(uint256 _tokenId) public view returns (uint256 _price) {
563         require(_exists(_tokenId), "Token does not exists.");
564         return _marketOfferGetTokenPrice(_tokenId);
565     }
566     
567     /**
568      * @dev Gets token market price, returns 0 for tokens not on market.
569      * Internal implementation. For tokens owned by address(0), gets token 
570      * not from price _marketOffers[_tokenId], but from function 
571      * _countBasePrice(_tokenId)
572      * @param _tokenId uint256 ID of the token
573      */
574     function _marketOfferGetTokenPrice(uint256 _tokenId) private view returns (uint256 _price) {
575         if(_tokenOwner[_tokenId]==address(0)){
576             return _countBasePrice(_tokenId);
577         }
578         return _marketOffers[_tokenId].price;
579     }
580 
581     /**
582      * @dev Returns whatever token is offered on market or not.
583      * Requires token existence
584      * @param _tokenId uint256 ID of the token
585      */
586     function marketOfferExists(uint256 _tokenId) public view returns (bool) {
587         require(_exists(_tokenId), "Token does not exists.");
588         
589         return _marketOfferExists(_tokenId);
590     }
591     
592     /**
593      * @dev Returns whatever token is offered on market or not.
594      * Internal implementation. For tokens owned by address(0), gets token 
595      * not from price _marketOffers[_tokenId], but from function 
596      * _baseIsOnMarket(_tokenId)
597      * @param _tokenId uint256 ID of the token
598      */
599     function _marketOfferExists(uint256 _tokenId) private view returns (bool) {
600 
601         if(_tokenOwner[_tokenId]==address(0)){
602             return _baseIsOnMarket(_tokenId);
603         }
604 
605         return _marketOffers[_tokenId].isOffer;
606     }
607 
608     /**
609      * @dev Places token on internal market.
610      * Requires token existence. Requires token not offered and not in auction.
611      * Requires owner of token == msg.sender
612      * @param _tokenId uint256 ID of the token
613      * @param _price uint256 token price
614      */
615     function marketOfferCreate(uint256 _tokenId, uint256 _price) public {
616         require(_exists(_tokenId), "Token does not exists.");
617         require(!_marketOfferExists(_tokenId), "Token is allready offered.");
618         require(!_marketAuctionExists(_tokenId), "Token is allready in auction.");
619 
620         address _owner = _ownerOf(_tokenId);
621 
622         require(_owner==msg.sender, "Sender is not authorized.");
623 
624         _marketOffers[_tokenId].isOffer = true;
625         _marketOffers[_tokenId].owner = _owner;
626         _marketOffers[_tokenId].price = _price;
627         
628         if(_tokenOwner[_tokenId]==address(0)){
629         	_tokenOwner[_tokenId] = _owner;
630         }
631 
632         emit MarketOfferCreated(_owner, _tokenId, _price);
633     }
634 
635     /**
636      * @dev Removes token from internal market.
637      * Requires token existence. Requires token is offered .
638      * Requires owner of token == msg.sender
639      * @param _tokenId uint256 ID of the token
640      */
641     function marketOfferRemove(uint256 _tokenId) public {
642         require(_exists(_tokenId), "Token does not exists.");
643 
644         address _owner = _ownerOf(_tokenId);
645 
646         require(_owner==msg.sender, "Sender is not authorized.");
647         require(_marketOfferExists(_tokenId), "Token is not offered.");
648 
649         _marketOffers[_tokenId].isOffer = false;
650         _marketOffers[_tokenId].owner = address(0);
651         _marketOffers[_tokenId].price = 0;
652         
653         if(_tokenOwner[_tokenId]==address(0)){
654         	_tokenOwner[_tokenId] = _owner;
655         }
656 
657         //marketOffers[_tokenId] = MarketOffer(false, address(0),0);  
658         emit MarketOfferRemoved(_owner, _tokenId);
659     }
660 
661     /**
662      * @dev Buy token from internal market.
663      * Requires token existence. Requires token is offered.
664      * Requires owner of msg.value >= token price. 
665      * @param _tokenId uint256 ID of the token
666      */
667     function marketOfferBuy(uint256 _tokenId) public payable {
668         require(_exists(_tokenId), "Token does not exists.");
669         require(_marketOfferExists(_tokenId), "Token is not offered.");
670 
671         
672         uint256 _price =  _marketOfferGetTokenPrice(_tokenId);
673         uint256 _finalprice = _price;
674         uint256 _payed = msg.value;
675         address _buyer = msg.sender;
676         address _owner = _ownerOf(_tokenId);
677         uint256 fee_price = 0;
678         uint256 charger_fee = 0;
679         uint256 charity_fee = 0;
680         uint256 charity_price = 0;
681 
682         require(_price<=_payed, "Payed price is lower than market price.");
683         
684         //return balance to buyer if send more than price
685         if(_payed>_price){
686             _marketBalances[_buyer] = _marketBalances[_buyer].add(_payed.sub(_price));
687         }
688 
689         
690         if((_tokenOwner[_tokenId]==address(0)) || (_tokenOwner[_tokenId]==_ownershipOwner)){
691             // Primary market
692             if(_isCharityToken(_tokenId)){
693                 //charity token
694                 
695                 //full price payed to _charityOwnerAddress
696                 charity_price = _price;
697 
698                 //charity sets as first owner
699                 _tokenFirstOwner[_tokenId] = _charityOwnerAddress;
700             }else{
701                 //contract token
702 
703                 //10% to charity
704                 charity_fee = _price.div(10);
705 
706                 //90% to charger
707                 charger_fee = _price.sub(charity_fee);
708             }            
709             
710         }else{
711             //Secondary market
712             
713             //calculate 1 %
714             fee_price = _price.div(100);
715             
716             //1% to charity - final price subtracted by 1%
717             charity_fee = fee_price;            
718             _finalprice = _finalprice.sub(fee_price);
719             
720             //1% to first owner 
721             if(_tokenFirstOwner[_tokenId]!=address(0)){ 
722                 //added 1% to first owner               
723                 _marketBalances[_tokenFirstOwner[_tokenId]] = _marketBalances[_tokenFirstOwner[_tokenId]].add(fee_price);
724                 
725                 //final price subtracted by 1%
726                 _finalprice = _finalprice.sub(fee_price);
727             }
728             
729             //1% to charger - final price subtracted by 1%
730             charger_fee = fee_price;
731             _finalprice = _finalprice.sub(fee_price);
732             
733             //add final price to market balances of seller 97 or 98%
734             _marketBalances[_owner] = _marketBalances[_owner].add(_finalprice);
735         }
736 
737         //remove from market
738         _marketOffers[_tokenId].isOffer = false;
739         _marketOffers[_tokenId].owner = address(0);
740         _marketOffers[_tokenId].price = 0;
741 
742         //actual token transfer
743         _transferFrom(_owner, _buyer, _tokenId); 
744 
745         //eth transfers to _chargerAddress, _charityAddress, and _charityOwnerAddress
746         _charityAddBalance(charity_fee);
747         _chargerAddBalance(charger_fee);
748         _charityOwnerAddBalance(charity_price);
749 
750         //emit market sold event
751         emit MarketOfferSold(_owner, _buyer, _tokenId, _price);
752     }
753 
754     /**
755      * @dev Places token on internal auction.
756      * Requires token existence. 
757      * Requires token not offered and not in auction.
758      * Requires owner of token == msg.sender or if contract token _auctionsAddress == msg.sender. 
759      * Requires _initPrice > 0.
760      * @param _tokenId uint256 ID of the token
761      * @param _initPrice uint256 initial (minimal bid) price
762      * @param _duration uint256 auction duration in secconds
763      */
764     function marketAuctionCreate(uint256 _tokenId, uint256 _initPrice, uint _duration) public {
765         require(_exists(_tokenId), "Token does not exists.");
766         require(!_marketOfferExists(_tokenId), "Token is allready offered.");
767         require(!_marketAuctionExists(_tokenId), "Token is allready in auction.");
768 
769         address _owner = _ownerOf(_tokenId);
770 
771         //requre msg.sender to be owner
772         if(_owner!=msg.sender){
773             //OR require owner == _ownershipOwner
774             require(_owner==_ownershipOwner, "Sender is not authorized.");    
775             //AND msg.sender == _auctionsAddress        
776             require(_auctionsAddress==msg.sender, "Sender is not authorized.");
777         }
778 
779         require(_initPrice>0, "Auction Init price has to be bigger than 0.");
780         
781         //set auction parameters
782         _marketAuctions[_tokenId].isAuction = true;
783         _marketAuctions[_tokenId].highestBidder = address(0);
784         _marketAuctions[_tokenId].highestBid = 0;
785         _marketAuctions[_tokenId].initPrice = _initPrice;
786         _marketAuctions[_tokenId].endTime = block.timestamp+_duration;
787 
788         //emits MarketAuctionCreated
789         emit MarketAuctionCreated(_tokenId, _initPrice, block.timestamp, block.timestamp+_duration);
790     }
791 
792     /**
793      * @dev Bids on token in internal auction.
794      * Requires token existence. 
795      * Requires token in auction.
796      * Requires bid >= _initPrice.
797      * Requires bid > highestBid.
798      * @param _tokenId uint256 ID of the token
799      */
800     function marketAuctionBid(uint256 _tokenId) public payable {
801         require(_exists(_tokenId), "Token does not exists.");
802         require(_marketAuctionExists(_tokenId), "Token is not in auction.");        
803         require(_marketAuctions[_tokenId].highestBid < msg.value, "Bid has to be bigger than the current highest bid."); 
804         require(_marketAuctions[_tokenId].initPrice <= msg.value, "Bid has to be at least initPrice value.");
805 
806         address oldBidder = _marketAuctions[_tokenId].highestBidder;
807         address bidder = msg.sender;
808         uint256 bidValue = msg.value;
809 
810         //return old bidder bid his to market balances
811         if(oldBidder!=address(0)){
812             _marketBalances[oldBidder] += _marketAuctions[_tokenId].highestBid;
813         }
814 
815         //set new highest bid
816         _marketAuctions[_tokenId].highestBidder = bidder;
817         _marketAuctions[_tokenId].highestBid = bidValue;
818 
819         //emits MarketAuctionBid
820         emit MarketAuctionBid(_tokenId, bidValue, bidder, oldBidder);        
821     }   
822 
823     /**
824      * @dev Resolved internal auction. Auction can not be resolved automatically after
825      * duration expires. Transfer token to auction winner (if someone bids) and 
826      * remove token from auction.
827      * Requires token existence. 
828      * Requires _marketAuctions[_tokenId].isAuction.
829      * Requires _marketAuctions[_tokenId].endTime < block.timestamp - duration expired.
830      * @param _tokenId uint256 ID of the token
831      */
832     function marketAuctionClaim(uint256 _tokenId) public {
833         require(_exists(_tokenId), "Token does not exists.");
834         require(_marketAuctions[_tokenId].isAuction, "Token is not in auction.");
835         require(_marketAuctions[_tokenId].endTime < block.timestamp, "Auction not finished yet.");
836 
837         uint256 fee_price = 0;
838         uint256 charger_fee = 0;
839         uint256 charity_fee = 0;
840         uint256 charity_price = 0;
841         uint256 _price = _marketAuctions[_tokenId].highestBid;
842         uint256 _finalprice = _price;
843         address _buyer = _marketAuctions[_tokenId].highestBidder;
844         address _owner = _ownerOf(_tokenId);
845         
846         // if winner exist (if someone bids)
847         if(_buyer != address(0)){
848 
849             if(_tokenOwner[_tokenId]==address(0)){
850                 // Primary market
851                 if(_isCharityToken(_tokenId)){
852                     //charity token
853                 
854                     //full price payed to _charityOwnerAddress
855                     charity_price = _price;
856 
857                     //charity sets as first owner
858                     _tokenFirstOwner[_tokenId] = _charityOwnerAddress;
859                 }else{
860                     //contract token 
861 
862                     //10% to charity
863                     charity_fee = _price.div(10);
864 
865                     //90% to charger
866                     charger_fee = _price.sub(charity_fee);
867                 }
868             }else{
869                 //Secondary market
870                 
871                 //calculate 1 %
872                 fee_price = _price.div(100);
873                 
874                 //1% to charity - final price subtracted by 1%
875                 charity_fee = fee_price;
876                 _finalprice = _finalprice.sub(fee_price);
877                 
878                 //1% to first owner 
879                 if(_tokenFirstOwner[_tokenId]!=address(0)){
880                     //added 1% to first owner 
881                     _marketBalances[_tokenFirstOwner[_tokenId]] = _marketBalances[_tokenFirstOwner[_tokenId]].add(fee_price);
882                     
883                     //final price subtracted by 1%
884                     _finalprice = _finalprice.sub(fee_price);
885                 }
886                 
887                 //1% to charger - final price subtracted by 1%
888                 charger_fee = fee_price;
889                 _finalprice = _finalprice.sub(fee_price);
890                 
891                 //add final price to market balances of seller 97 or 98%
892                 _marketBalances[_owner] = _marketBalances[_owner].add(_finalprice);
893             }
894                
895             
896             //actual transfer to winner
897             _transferFrom(_owner, _buyer, _tokenId);
898 
899             //emit MarketAuctionClaimed
900             emit MarketAuctionClaimed(_tokenId, _price, _buyer);
901         }else{
902             //emit MarketAuctionClaimed - when no bidder/winner
903             emit MarketAuctionClaimed(_tokenId, 0, address(0));
904         }
905 
906         //remove auction
907         _marketAuctions[_tokenId].isAuction = false;
908         _marketAuctions[_tokenId].highestBidder = address(0);
909         _marketAuctions[_tokenId].highestBid = 0;
910 
911         //eth transfers to _chargerAddress, _charityAddress, and _charityOwnerAddress
912         _charityAddBalance(charity_fee);
913         _chargerAddBalance(charger_fee);
914         _charityOwnerAddBalance(charity_price);
915     } 
916 
917     /**
918      * @dev Gets current highest bid, returns 0 for tokens not in auction.
919      * Requires token existence
920      * @param _tokenId uint256 ID of the token
921      */
922     function marketAuctionGetTokenPrice(uint256 _tokenId) public view returns (uint256 _price) {
923         require(_exists(_tokenId), "Token does not exists.");
924 
925         return _marketAuctions[_tokenId].highestBid;
926     }
927 
928     /**
929      * @dev Gets address of current highest bidder, returns addres(0) for tokens not in auction.
930      * Requires token existence
931      * @param _tokenId uint256 ID of the token
932      */
933     function marketAuctionGetHighestBidder(uint256 _tokenId) public view returns (address _bidder) {
934         require(_exists(_tokenId), "Token does not exists.");
935 
936         return _marketAuctions[_tokenId].highestBidder;
937     }
938 
939     /**
940      * @dev Returns whatever token is in auction or not.
941      * @param _tokenId uint256 ID of the token
942      */
943     function marketAuctionExists(uint256 _tokenId) public view returns(bool _exists){
944         return _marketAuctionExists(_tokenId);
945     }  
946     
947     /**
948      * @dev Returns whatever token is in auction or not.
949      * Internal implementation. Check if endTime not expired.
950      * @param _tokenId uint256 ID of the token
951      */
952     function _marketAuctionExists(uint256 _tokenId) private view returns(bool _exists){
953         if(_marketAuctions[_tokenId].endTime < block.timestamp){
954             return false;
955         }
956         return _marketAuctions[_tokenId].isAuction;
957     }
958 
959     /**
960      * @dev Transfers market balance of msg.sender.
961      * Requires _marketBalances[msg.sender]>0
962      */
963     function marketWithdrawBalance() public {
964         uint amount = _marketBalances[msg.sender];
965         require(amount>0, "Sender has no market balance to withdraw.");
966 
967         _marketBalances[msg.sender] = 0;
968         msg.sender.transfer(amount);
969     }
970 
971     /**
972      * @dev Get ammount of _owner.
973      * @param _owner address Requested address;
974      */
975     function marketGetBalance(address _owner) public view returns(uint256 _balance){
976         return _marketBalances[_owner];
977     }
978 
979     /**
980      * @dev Send/transfer token.
981      * Requires token exist.
982      * Requires token is not offered or in auction.
983      * Requires token is owned by _ownershipOwner
984      * Requires msq.sender==_giftsAddress
985      * @param _tokenId uint256 ID of the token to send
986      * @param _to address to send token
987      */
988     function marketSendGift(uint256 _tokenId, address _to) public {
989         require(_exists(_tokenId), "Token does not exists.");
990         require(!_marketOfferExists(_tokenId), "Token is offered.");
991         require(!_marketAuctionExists(_tokenId), "Token is in auction.");
992 
993         require(_ownerOf(_tokenId)==_ownershipOwner, "Sender is not authorized.");            
994         require(_giftsAddress==msg.sender, "Sender is not authorized.");
995 
996         _transferFrom(_ownerOf(_tokenId), _to, _tokenId);
997     }
998 
999 
1000     // --------------------------
1001     // Safe transfers functions (transefer to kown adresses)
1002     // -------------------------
1003     
1004     address payable private _chargeAddress;
1005     address payable private _charityAddress;
1006     address payable private _charityOwnerAddress;
1007 
1008     /**
1009      * @dev Transfers eth to _charityAddress
1010      * @param _balance uint256 Ammount to transfer
1011      */
1012     function _charityAddBalance(uint256 _balance) internal {
1013         if(_balance>0){
1014             _charityAddress.transfer(_balance);
1015         }
1016     }
1017 
1018     /**
1019      * @dev Transfers eth to _charityOwnerAddress
1020      * @param _balance uint256 Ammount to transfer
1021      */
1022     function _charityOwnerAddBalance(uint256 _balance) internal {
1023         if(_balance>0){
1024             _charityOwnerAddress.transfer(_balance);
1025         }
1026     }
1027 
1028     /**
1029      * @dev Transfers eth to _chargeAddress
1030      * @param _balance uint256 Ammount to transfer
1031      */
1032     function _chargerAddBalance(uint256 _balance) internal {
1033         if(_balance>0){
1034             _chargeAddress.transfer(_balance);
1035         }
1036     }
1037     
1038 
1039 	// --------------------------
1040     // Internal functions
1041     // -------------------------
1042 	
1043     /**
1044      * @dev Internal function return owner of token _tokenOwner[_tokenId]. 
1045      * if _tokenOwner[_tokenId] == address(0), owner is _charityOwnerAddress 
1046      * OR _ownershipOwner (based on _isCharityToken(_tokenId))
1047      * @param _tokenId uint256 ID of the token
1048      */
1049     function _ownerOf(uint256 _tokenId) internal view returns (address _owner) {
1050         
1051         if(_tokenOwner[_tokenId]==address(0)){
1052             //token has no owner - owner is _charityOwnerAddress OR _ownershipOwner;
1053             if(_isCharityToken(_tokenId)){
1054                 //owner is _charityOwnerAddress
1055                 return _charityOwnerAddress;
1056             }
1057             //owner is _ownershipOwner
1058             return _ownershipOwner;
1059         }
1060         //owner is _tokenOwner[_tokenId]
1061         return _tokenOwner[_tokenId];
1062     }
1063 
1064     /**
1065      * @dev Returns whatever token is charity token or not
1066      * @param _tokenId uint256 ID of the token
1067      */
1068     function _isCharityToken(uint256 _tokenId) internal pure returns (bool _isCharity) {
1069         if(_tokenId>720 && _tokenId<=1320){
1070             return true;
1071         }
1072         return false;
1073     }
1074 	
1075     /**
1076      * @dev Returns whether the specified token exists.
1077      * @param _tokenId uint256 ID of the token to query the existence of
1078      * @return bool whether the token exists
1079      */
1080     function _exists(uint256 _tokenId) internal view returns(bool _tokenExistence) {
1081         //all tokens lower then supply exists
1082         return (_tokenId <= _totalSupply);
1083     }
1084 
1085     /**
1086      * @dev Returns whether the given spender can transfer a given token ID.
1087      * @param spender address of the spender to query
1088      * @param tokenId uint256 ID of the token to be transferred
1089      * @return bool whether the msg.sender is approved for the given token ID,
1090      * is an operator of the owner, or is the owner of the token
1091      */
1092     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1093         address owner = _ownerOf(tokenId);
1094         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1095     }
1096 
1097     /**
1098      * @dev Internal function to transfer ownership of a given token ID to another address.
1099      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1100      * @param from current owner of the token
1101      * @param to address to receive the ownership of the given token ID
1102      * @param tokenId uint256 ID of the token to be transferred
1103      */
1104     function _transferFrom(address from, address to, uint256 tokenId) internal {
1105         require(_ownerOf(tokenId) == from);
1106         require(to != address(0));
1107 
1108         _clearApproval(tokenId);
1109 
1110         _ownedTokensCount[from].decrement();
1111         _ownedTokensCount[to].increment();
1112 
1113 		if(_tokenFirstOwner[tokenId]==address(0)){
1114 			_tokenFirstOwner[tokenId] = to;
1115 		}
1116         _tokenOwner[tokenId] = to;
1117 
1118         emit Transfer(from, to, tokenId);
1119     }
1120     
1121     /**
1122      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1123      * The call is not executed if the target address is not a contract.
1124      *
1125      * This function is deprecated.
1126      * @param from address representing the previous owner of the given token ID
1127      * @param to target address that will receive the tokens
1128      * @param tokenId uint256 ID of the token to be transferred
1129      * @param _data bytes optional data to send along with the call
1130      * @return bool whether the call correctly returned the expected magic value
1131      */
1132     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1133         internal returns (bool)
1134     {
1135         if (!to.isContract()) {
1136             return true;
1137         }
1138 
1139         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1140         return (retval == _ERC721_RECEIVED);
1141     }
1142 
1143     /**
1144      * @dev Private function to clear current approval of a given token ID.
1145      * @param tokenId uint256 ID of the token to be transferred
1146      */
1147     function _clearApproval(uint256 tokenId) private {
1148         if (_tokenApprovals[tokenId] != address(0)) {
1149             _tokenApprovals[tokenId] = address(0);
1150         }
1151     }
1152     
1153     /**
1154      * @dev Converts uint256 number to string
1155      * @param i uint256
1156      */
1157     function uint2str(uint256 i) internal pure returns (string memory){
1158         uint256 _tmpN = i;
1159 
1160         if (_tmpN == 0) {
1161             return "0";
1162         }
1163 
1164         uint256 j = _tmpN;
1165         uint256 length = 0;
1166 
1167         while (j != 0){
1168             length++;
1169             j /= 10;
1170         }
1171 
1172         bytes memory bstr = new bytes(length);
1173         uint256 k = length - 1;
1174 
1175         while (_tmpN != 0) {
1176             bstr[k--] = byte(uint8(48 + _tmpN % 10));
1177             _tmpN /= 10;
1178         }
1179 
1180         return string(bstr);
1181     }
1182     
1183     /**
1184      * @dev Returns market price of token based on its id. 
1185      * Only used if tokenOwner == address(0)
1186      * @param _tokenId uint256 id of token
1187      * @return uint256 marketPrice 
1188      */
1189     function _countBasePrice(uint256 _tokenId) internal pure returns (uint256 _price) {
1190       
1191         if(_tokenId<=720){
1192             //reserved for gifts and auctions
1193             return 0;
1194         }
1195         if(_tokenId>720 && _tokenId<=1320){
1196             //charity owned on market
1197             return 100 * (uint256(10) ** 15);
1198         }
1199 
1200         if(_tokenId>1320 && _tokenId<=8020){
1201             // price 5
1202             return 34 * (uint256(10) ** 15);
1203         }
1204 
1205         if(_tokenId>=8021 && _tokenId<10920){
1206             // price 6
1207             return 40 * (uint256(10) ** 15);
1208         }
1209 
1210         if(_tokenId>=10920 && _tokenId<17720){
1211             // price 7
1212             return 47 * (uint256(10) ** 15);
1213         }
1214 
1215         if(_tokenId>=17720 && _tokenId<22920){
1216             // price 8
1217             return 54* (uint256(10) ** 15);
1218         }
1219 
1220         if(_tokenId>=22920 && _tokenId<29470){
1221             // price 10
1222             return 67 * (uint256(10) ** 15);
1223         }
1224 
1225         if(_tokenId>=29470 && _tokenId<30320){
1226             // price 11
1227             return 74 * (uint256(10) ** 15);
1228         }
1229 
1230         if(_tokenId>=30320 && _tokenId<32470){
1231             // price 12
1232             return 80 * (uint256(10) ** 15);
1233         }
1234 
1235         if(_tokenId>=32470 && _tokenId<35120){
1236             // price 13
1237             return 87 * (uint256(10) ** 15);
1238         }
1239 
1240         if(_tokenId>=35120 && _tokenId<35520){
1241             // price 14
1242             return 94 * (uint256(10) ** 15);
1243         }
1244 
1245         if(_tokenId>=35520 && _tokenId<42370){
1246             // price 15
1247             return 100 * (uint256(10) ** 15);
1248         }
1249 
1250         if(_tokenId>=42370 && _tokenId<46370){
1251             // price 18
1252             return 120 * (uint256(10) ** 15);
1253         }
1254 
1255         if(_tokenId>=46370 && _tokenId<55920){
1256             // price 20
1257             return 134 * (uint256(10) ** 15);
1258         }
1259 
1260         if(_tokenId>=55920 && _tokenId<59820){
1261             // price 22
1262             return 147 * (uint256(10) ** 15);
1263         }
1264 
1265         if(_tokenId>=59820 && _tokenId<63120){
1266             // price 25
1267             return 167 * (uint256(10) ** 15);
1268         }
1269 
1270         if(_tokenId>=63120 && _tokenId<78870){
1271             // price 30
1272             return 200 * (uint256(10) ** 15);
1273         }
1274 
1275         if(_tokenId>=78870 && _tokenId<79010){
1276             // price 35
1277             return 234 * (uint256(10) ** 15);
1278         }
1279 
1280         if(_tokenId>=79010 && _tokenId<84505){
1281             // price 40
1282             return 267 * (uint256(10) ** 15);
1283         }
1284 
1285         if(_tokenId>=84505 && _tokenId<84645){
1286             // price 45
1287             return 300 * (uint256(10) ** 15);
1288         }
1289 
1290         if(_tokenId>=84645 && _tokenId<85100){
1291             // price 50
1292             return 334 * (uint256(10) ** 15);
1293         }
1294 
1295         if(_tokenId>=85100 && _tokenId<85165){
1296             // price 60
1297             return 400 * (uint256(10) ** 15);
1298         }
1299 
1300         if(_tokenId>=85165 && _tokenId<85175){
1301             // price 65
1302             return 434 * (uint256(10) ** 15);
1303         }
1304 
1305         if(_tokenId>=85175 && _tokenId<85205){
1306             // price 70
1307             return 467 * (uint256(10) ** 15);
1308         }
1309 
1310         if(_tokenId>=85205 && _tokenId<85235){
1311             // price 80
1312             return 534 * (uint256(10) ** 15);
1313         }
1314 
1315         if(_tokenId>=85235 && _tokenId<85319){
1316             // price 90
1317             return 600 * (uint256(10) ** 15);
1318         }
1319 
1320         if(_tokenId>=85319 && _tokenId<85427){
1321             // price 100
1322             return 667 * (uint256(10) ** 15);
1323         }
1324 
1325         if(_tokenId>=85427 && _tokenId<85441){
1326             // price 110
1327             return 734 * (uint256(10) ** 15);
1328         }
1329 
1330         if(_tokenId>=85441 && _tokenId<85457){
1331             // price 120
1332             return 800 * (uint256(10) ** 15);
1333         }
1334 
1335         if(_tokenId>=85457 && _tokenId<85464){
1336             // price 130
1337             return 867 * (uint256(10) ** 15);
1338         }
1339 
1340         if(_tokenId>=85464 && _tokenId<85465){
1341             // price 140
1342             return 934 * (uint256(10) ** 15);
1343         }
1344 
1345         if(_tokenId>=85465 && _tokenId<85502){
1346             // price 150
1347             return 1000 * (uint256(10) ** 15);
1348         }
1349 
1350         if(_tokenId>=85502 && _tokenId<85506){
1351             // price 160
1352             return 1067 * (uint256(10) ** 15);
1353         }
1354 
1355         if(_tokenId==85506){
1356             // price 170
1357             return 1134 * (uint256(10) ** 15);
1358         }
1359 
1360         if(_tokenId==85507){
1361             // price 180
1362             return 1200 * (uint256(10) ** 15);
1363         }
1364 
1365         if(_tokenId>=85508 && _tokenId<85516){
1366             // price 200
1367             return 1334 * (uint256(10) ** 15);
1368         }
1369 
1370         if(_tokenId>=85516 && _tokenId<85518){
1371             // price 230
1372             return 1534 * (uint256(10) ** 15);
1373         }
1374 
1375         if(_tokenId>=85518 && _tokenId<85571){
1376             // price 250
1377             return 1667 * (uint256(10) ** 15);
1378         }
1379 
1380         if(_tokenId>=85571 && _tokenId<85587){
1381             // price 300
1382             return 2000 * (uint256(10) ** 15);
1383         }
1384 
1385         if(_tokenId>=85587 && _tokenId<85594){
1386             // price 350
1387             return 2334 * (uint256(10) ** 15);
1388         }
1389 
1390         if(_tokenId>=85594 && _tokenId<85597){
1391             // price 400
1392             return 2667 * (uint256(10) ** 15);
1393         }
1394 
1395         if(_tokenId>=85597 && _tokenId<85687){
1396             // price 500
1397             return 3334 * (uint256(10) ** 15);
1398         }
1399 
1400         if(_tokenId==85687){
1401             // price 550
1402             return 3667 * (uint256(10) ** 15);
1403         }
1404 
1405         if(_tokenId>=85688 && _tokenId<85692){
1406             // price 600
1407             return 4000 * (uint256(10) ** 15);
1408         }
1409 
1410         if(_tokenId==85692){
1411             // price 680
1412             return 4534 * (uint256(10) ** 15);
1413         }
1414 
1415         if(_tokenId>=85693 && _tokenId<85698){
1416             // price 700
1417             return 4667 * (uint256(10) ** 15);
1418         }
1419 
1420         if(_tokenId>=85698 && _tokenId<85700){
1421             // price 750
1422             return 5000 * (uint256(10) ** 15);
1423         }
1424 
1425         if(_tokenId==85700){
1426             // price 800
1427             return 5334 * (uint256(10) ** 15);
1428         }
1429 
1430         if(_tokenId==85701){
1431             // price 900
1432             return 6000 * (uint256(10) ** 15);
1433         }
1434 
1435         if(_tokenId>=85702 && _tokenId<85776){
1436             // price 1000
1437             return 6667 * (uint256(10) ** 15);
1438         }
1439 
1440         if(_tokenId==85776){
1441             // price 1100
1442             return 7334 * (uint256(10) ** 15);
1443         }
1444 
1445         if(_tokenId>=85777 && _tokenId<85788){
1446             // price 1500
1447             return 10000 * (uint256(10) ** 15);
1448         }
1449 
1450         if(_tokenId>=85788 && _tokenId<85795){
1451             // price 2000
1452             return 13334 * (uint256(10) ** 15);
1453         }
1454 
1455         if(_tokenId>=85795 && _tokenId<85798){
1456             // price 2500
1457             return 16667 * (uint256(10) ** 15);
1458         }
1459 
1460         if(_tokenId>=85798 && _tokenId<85803){
1461             // price 3000
1462             return 20000 * (uint256(10) ** 15);
1463         }
1464 
1465         if(_tokenId>=85803 && _tokenId<85806){
1466             // price 5000
1467             return 33334 * (uint256(10) ** 15);
1468         }
1469 
1470         if(_tokenId>=85806 && _tokenId<85807){
1471             // price 10000
1472             return 66667 * (uint256(10) ** 15);
1473         }
1474 
1475         if(_tokenId==85807){
1476             // price 50000
1477             return 333334 * (uint256(10) ** 15);
1478         }
1479     }
1480 
1481     /**
1482      * @dev Returns whatever token is offerd on market. 
1483      * Only used if tokenOwner == address(0)
1484      * @param _tokenId uint256 id of token
1485      */
1486     function _baseIsOnMarket(uint256 _tokenId) internal pure returns (bool _isOnMarket) {
1487         if(_tokenId<=720){
1488             //reserved for gits and auctions
1489             return false;
1490         }
1491         if(_tokenId>720 && _tokenId<=1320){
1492             //charity owned on market
1493             return true;
1494         }
1495 
1496         if(_tokenId>1320){
1497             //other on market
1498             return true;
1499         }
1500     }
1501 
1502     /**
1503      * @dev Constructor
1504      */
1505     constructor () public {
1506         // register the supported interfaces to conform to ERC721 via ERC165
1507     	_registerInterface(_INTERFACE_ID_ERC165);
1508         _registerInterface(_INTERFACE_ID_ERC721);
1509         
1510         //set metadata values
1511         _name = "Crypto Tittiez";
1512         _symbol = "CTT";
1513         
1514         // register the supported interfaces to conform to ERC721 ERC721_METADATA
1515         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1516         
1517         //set metadata values
1518         _baseTokenURI = "https://cryptotittiez.com/api/tokeninfo/";
1519         _totalSupply = 85807;
1520 
1521         //after tokens creation (allmost) all tokens pretends are owned by _ownershipOwner. Look at function _ownerOf
1522         _ownedTokensCount[msg.sender].set(85207);
1523 
1524         //sets known addresse
1525         _chargeAddress = address(0x03559A5AFC7F55F3d71619523d45889a6b0905c0);
1526         _charityAddress = address(0x40497Be989B8d6fb532a6A2f0Dbf759F5d644e76);
1527         _charityOwnerAddress = address(0x949577b216ee2D44d70d6DB210422275694cbA27);
1528         _auctionsAddress = address(0x6800B4f9A80a1fbA4674a5716A5554f3869b57Bf);
1529         _giftsAddress = address(0x3990e05DA96EFfF38b0aC9ddD495F41BB82Bf9a9);
1530 
1531         //after tokens creation 600 tokens pretends are owned by _charityOwnerAddress. Look at function _ownerOf
1532         _ownedTokensCount[_charityOwnerAddress].set(600);
1533         
1534         //sets json hash to prove images not change 
1535         _imagesJsonHash = "2485dabaebe62276c976e55b290438799f2b60cdb845c50053e2c2be43fa6fce";
1536        
1537         //set contract owner
1538         _ownershipOwner = msg.sender;
1539     }      
1540 }