1 // SPDX-License-Identifier: UNLICENSE
2 pragma solidity 0.8.4;
3 
4 /**
5  * @dev Required interface of an ERC721 compliant contract.
6  */
7 interface IERC721 {
8     /**
9      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
10      */
11     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
12 
13     /**
14      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
15      */
16     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
17 
18     /**
19      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
20      */
21     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
22 
23     /**
24      * @dev Returns the number of tokens in ``owner``'s account.
25      */
26     function balanceOf(address owner) external view returns (uint256 balance);
27 
28     /**
29      * @dev Returns the owner of the `tokenId` token.
30      *
31      * Requirements:
32      *
33      * - `tokenId` must exist.
34      */
35     function ownerOf(uint256 tokenId) external view returns (address owner);
36 
37     /**
38      * @dev Safely transfers `tokenId` token from `from` to `to`.
39      *
40      * Requirements:
41      *
42      * - `from` cannot be the zero address.
43      * - `to` cannot be the zero address.
44      * - `tokenId` token must exist and be owned by `from`.
45      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
46      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
47      *
48      * Emits a {Transfer} event.
49      */
50     function safeTransferFrom(
51         address from,
52         address to,
53         uint256 tokenId,
54         bytes calldata data
55     ) external;
56 
57     /**
58      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
59      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
60      *
61      * Requirements:
62      *
63      * - `from` cannot be the zero address.
64      * - `to` cannot be the zero address.
65      * - `tokenId` token must exist and be owned by `from`.
66      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
67      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
68      *
69      * Emits a {Transfer} event.
70      */
71     function safeTransferFrom(
72         address from,
73         address to,
74         uint256 tokenId
75     ) external;
76 
77     /**
78      * @dev Transfers `tokenId` token from `from` to `to`.
79      *
80      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must be owned by `from`.
87      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(
92         address from,
93         address to,
94         uint256 tokenId
95     ) external;
96 
97     /**
98      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
99      * The approval is cleared when the token is transferred.
100      *
101      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
102      *
103      * Requirements:
104      *
105      * - The caller must own the token or be an approved operator.
106      * - `tokenId` must exist.
107      *
108      * Emits an {Approval} event.
109      */
110     function approve(address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Approve or remove `operator` as an operator for the caller.
114      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
115      *
116      * Requirements:
117      *
118      * - The `operator` cannot be the caller.
119      *
120      * Emits an {ApprovalForAll} event.
121      */
122     function setApprovalForAll(address operator, bool _approved) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
135      *
136      * See {setApprovalForAll}
137      */
138     function isApprovedForAll(address owner, address operator) external view returns (bool);
139 }
140 
141 /**
142  * @title ERC721 token receiver interface
143  * @dev Interface for any contract that wants to support safeTransfers
144  * from ERC721 asset contracts.
145  */
146 interface IERC721Receiver {
147     /**
148      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
149      * by `operator` from `from`, this function is called.
150      *
151      * It must return its Solidity selector to confirm the token transfer.
152      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
153      *
154      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
155      */
156     function onERC721Received(
157         address operator,
158         address from,
159         uint256 tokenId,
160         bytes calldata data
161     ) external returns (bytes4);
162 }
163 
164 /**
165  * @dev Provides information about the current execution context, including the
166  * sender of the transaction and its data. While these are generally available
167  * via msg.sender and msg.data, they should not be accessed in such a direct
168  * manner, since when dealing with meta-transactions the account sending and
169  * paying for execution may not be the actual sender (as far as an application
170  * is concerned).
171  *
172  * This contract is only required for intermediate, library-like contracts.
173  */
174 abstract contract Context {
175     function _msgSender() internal view virtual returns (address) {
176         return msg.sender;
177     }
178 
179     function _msgData() internal view virtual returns (bytes calldata) {
180         return msg.data;
181     }
182 }
183 
184 /**
185  * @dev Contract module which provides a basic access control mechanism, where
186  * there is an account (an owner) that can be granted exclusive access to
187  * specific functions.
188  *
189  * By default, the owner account will be the one that deploys the contract. This
190  * can later be changed with {transferOwnership}.
191  *
192  * This module is used through inheritance. It will make available the modifier
193  * `onlyOwner`, which can be applied to your functions to restrict their use to
194  * the owner.
195  */
196 abstract contract Ownable is Context {
197     address private _owner;
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     /**
202      * @dev Initializes the contract setting the deployer as the initial owner.
203      */
204     constructor() {
205         _transferOwnership(_msgSender());
206     }
207 
208     /**
209      * @dev Returns the address of the current owner.
210      */
211     function owner() public view virtual returns (address) {
212         return _owner;
213     }
214 
215     /**
216      * @dev Throws if called by any account other than the owner.
217      */
218     modifier onlyOwner() {
219         require(owner() == _msgSender(), "Ownable: caller is not the owner");
220         _;
221     }
222 
223     /**
224      * @dev Leaves the contract without owner. It will not be possible to call
225      * `onlyOwner` functions anymore. Can only be called by the current owner.
226      *
227      * NOTE: Renouncing ownership will leave the contract without an owner,
228      * thereby removing any functionality that is only available to the owner.
229      */
230     function renounceOwnership() public virtual onlyOwner {
231         _transferOwnership(address(0));
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Can only be called by the current owner.
237      */
238     function transferOwnership(address newOwner) public virtual onlyOwner {
239         require(newOwner != address(0), "Ownable: new owner is the zero address");
240         _transferOwnership(newOwner);
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Internal function without access restriction.
246      */
247     function _transferOwnership(address newOwner) internal virtual {
248         address oldOwner = _owner;
249         _owner = newOwner;
250         emit OwnershipTransferred(oldOwner, newOwner);
251     }
252 }
253 
254 /**
255  * @dev Contract module which allows children to implement an emergency stop
256  * mechanism that can be triggered by an authorized account.
257  *
258  * This module is used through inheritance. It will make available the
259  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
260  * the functions of your contract. Note that they will not be pausable by
261  * simply including this module, only once the modifiers are put in place.
262  */
263 abstract contract Pausable is Context {
264     /**
265      * @dev Emitted when the pause is triggered by `account`.
266      */
267     event Paused(address account);
268 
269     /**
270      * @dev Emitted when the pause is lifted by `account`.
271      */
272     event Unpaused(address account);
273 
274     bool private _paused;
275 
276     /**
277      * @dev Initializes the contract in unpaused state.
278      */
279     constructor() {
280         _paused = false;
281     }
282 
283     /**
284      * @dev Returns true if the contract is paused, and false otherwise.
285      */
286     function paused() public view virtual returns (bool) {
287         return _paused;
288     }
289 
290     /**
291      * @dev Modifier to make a function callable only when the contract is not paused.
292      *
293      * Requirements:
294      *
295      * - The contract must not be paused.
296      */
297     modifier whenNotPaused() {
298         require(!paused(), "Pausable: paused");
299         _;
300     }
301 
302     /**
303      * @dev Modifier to make a function callable only when the contract is paused.
304      *
305      * Requirements:
306      *
307      * - The contract must be paused.
308      */
309     modifier whenPaused() {
310         require(paused(), "Pausable: not paused");
311         _;
312     }
313 
314     /**
315      * @dev Triggers stopped state.
316      *
317      * Requirements:
318      *
319      * - The contract must not be paused.
320      */
321     function _pause() internal virtual whenNotPaused {
322         _paused = true;
323         emit Paused(_msgSender());
324     }
325 
326     /**
327      * @dev Returns to normal state.
328      *
329      * Requirements:
330      *
331      * - The contract must be paused.
332      */
333     function _unpause() internal virtual whenPaused {
334         _paused = false;
335         emit Unpaused(_msgSender());
336     }
337 }
338 
339 /**
340  * @dev Contract module that helps prevent reentrant calls to a function.
341  *
342  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
343  * available, which can be applied to functions to make sure there are no nested
344  * (reentrant) calls to them.
345  *
346  * Note that because there is a single `nonReentrant` guard, functions marked as
347  * `nonReentrant` may not call one another. This can be worked around by making
348  * those functions `private`, and then adding `external` `nonReentrant` entry
349  * points to them.
350  *
351  * TIP: If you would like to learn more about reentrancy and alternative ways
352  * to protect against it, check out our blog post
353  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
354  */
355 abstract contract ReentrancyGuard {
356     // Booleans are more expensive than uint256 or any type that takes up a full
357     // word because each write operation emits an extra SLOAD to first read the
358     // slot's contents, replace the bits taken up by the boolean, and then write
359     // back. This is the compiler's defense against contract upgrades and
360     // pointer aliasing, and it cannot be disabled.
361 
362     // The values being non-zero value makes deployment a bit more expensive,
363     // but in exchange the refund on every call to nonReentrant will be lower in
364     // amount. Since refunds are capped to a percentage of the total
365     // transaction's gas, it is best to keep them low in cases like this one, to
366     // increase the likelihood of the full refund coming into effect.
367     uint256 private constant _NOT_ENTERED = 1;
368     uint256 private constant _ENTERED = 2;
369 
370     uint256 private _status;
371 
372     constructor() {
373         _status = _NOT_ENTERED;
374     }
375 
376     /**
377      * @dev Prevents a contract from calling itself, directly or indirectly.
378      * Calling a `nonReentrant` function from another `nonReentrant`
379      * function is not supported. It is possible to prevent this from happening
380      * by making the `nonReentrant` function external, and making it call a
381      * `private` function that does the actual work.
382      */
383     modifier nonReentrant() {
384         // On the first call to nonReentrant, _notEntered will be true
385         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
386 
387         // Any calls to nonReentrant after this point will fail
388         _status = _ENTERED;
389 
390         _;
391 
392         // By storing the original value once again, a refund is triggered (see
393         // https://eips.ethereum.org/EIPS/eip-2200)
394         _status = _NOT_ENTERED;
395     }
396 }
397 
398 /**
399  * @dev Implementation of the {IERC721Receiver} interface.
400  *
401  * Accepts all token transfers.
402  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
403  */
404 contract ERC721Holder is IERC721Receiver {
405     /**
406      * @dev See {IERC721Receiver-onERC721Received}.
407      *
408      * Always returns `IERC721Receiver.onERC721Received.selector`.
409      */
410     function onERC721Received(
411         address,
412         address,
413         uint256,
414         bytes memory
415     ) public virtual override returns (bytes4) {
416         return this.onERC721Received.selector;
417     }
418 }
419 
420 contract InitialCoinOffering is Ownable, ReentrancyGuard, ERC721Holder, Pausable {    
421     enum Sale { preSale, publicSale, crowdSale}
422 
423     address public collarQuest;
424     uint128 public maxBuy = 2;
425     uint128 constant DIVISOR = 10000;
426     uint public currentSaleId = 0;
427     uint[3] public discount = [5000,2500,0];   
428     
429     struct Timestamp {
430         uint64 startTime;
431         uint64 endTime;
432     }
433 
434     struct NFTList {
435         address nftAddress;
436         uint price;
437         bool isActive;
438     }
439 
440     struct WhitelistInfo {
441         mapping(uint => uint8) buyCount;
442         bool isWhitelisted;
443     }
444 
445     Timestamp[2] public timestamp;
446     
447     mapping(uint => NFTList) public listedOnSale;
448     mapping(address => WhitelistInfo) public whiteList;
449 
450     event Buy(
451         address indexed account,
452         uint indexed nftId,
453         uint price,
454         uint64 timestamp,
455         uint8 saleType
456     );
457 
458     event AddedNFTs(
459         address indexed nftAddress,
460         uint indexed nftId,
461         uint64 timestamp
462     );
463 
464     event RemovedNFTs(
465         address indexed nftAddress,
466         uint indexed nftId,
467         uint64 timestamp
468     );
469 
470     constructor(address collarQuest_) {
471         collarQuest = collarQuest_;
472     }
473 
474     modifier onlyWhitelister() {
475         require(whiteList[_msgSender()].isWhitelisted, "Only whitelist");
476         _;
477     }
478 
479     /**
480      * @dev setting presale duration.
481      */
482     function setPresaleTimestamp( Timestamp calldata timestamp_) external onlyOwner {
483         require(timestamp[uint(Sale.publicSale)].endTime == 0, "InitialCoinOffering :: setPresaleTimestamp : public sale end time == 0");
484         require((timestamp_.startTime > 0) && (timestamp_.startTime > getBlockTimestamp()), "InitialCoinOffering :: setPresaleTimestamp : start time > block.timestamp");
485         require(timestamp_.endTime > timestamp_.startTime, "InitialCoinOffering :: setPresaleTimestamp : end time > start time");
486 
487         timestamp[uint(Sale.preSale)] = timestamp_;
488     }
489 
490     /**
491      * @dev setting public sale duration.
492      */
493     function setPublicSaleTimestamp( Timestamp calldata timestamp_) external onlyOwner {
494         require(timestamp[uint(Sale.preSale)].endTime > 0, "InitialCoinOffering :: setPublicSaleTimestamp : presale end time > 0");
495         require((timestamp_.startTime > 0) && (timestamp_.startTime > timestamp[uint(Sale.preSale)].endTime), "InitialCoinOffering :: setPublicSaleTimestamp : start time > presale end time");
496         require(timestamp_.endTime > timestamp_.startTime, "InitialCoinOffering :: setPublicSaleTimestamp : end time > start time");
497 
498         currentSaleId++;
499         timestamp[uint(Sale.publicSale)] = timestamp_;
500     }
501 
502     /**
503      * @dev reset both public and presale.
504      */
505     function resetSale() external onlyOwner {
506         require(timestamp[uint(Sale.publicSale)].endTime < getBlockTimestamp(),"InitialCoinOffering :: resetSale : wait till public sale end");
507         timestamp[uint(Sale.publicSale)] = Timestamp(0,0);
508         timestamp[uint(Sale.preSale)] = Timestamp(0,0);
509     }
510 
511     /**
512      * @dev setting maximum buy count for whitelisters in presale.
513      */
514     function updateMaxBuy( uint128 maxBuy_) external onlyOwner {
515         require(maxBuy_ != 0, "InitialCoinOffering :: updateMaxBuy : maxBuy != 0");
516         maxBuy = maxBuy_;
517     }
518 
519     /**
520      * @dev update collar quest nft address.
521      */
522     function updateCollarQuest( address collarQuest_) external onlyOwner {
523         require(collarQuest_ != address(0),"InitialCoinOffering :: updateCollarQuest : collarQuest_ != zero address");
524         collarQuest = collarQuest_;
525     }    
526 
527     /**
528      * @dev add nft to the sale list.
529      */
530     function addNftToList( uint[] memory nftId, uint[] memory price) external onlyOwner {
531         require(nftId.length == price.length, "invalid length");
532 
533         for(uint i=0;i<nftId.length;i++) {
534             require(price[i] > 0,"InitialCoinOffering :: addNftToList : price > 0");
535             require(!listedOnSale[nftId[i]].isActive,"InitialCoinOffering :: addNftToList : not active");
536 
537             listedOnSale[nftId[i]] = NFTList(
538             address(collarQuest),
539             price[i],
540             true
541             );
542 
543             IERC721(collarQuest).safeTransferFrom(
544                 owner(),
545                 address(this),
546                 nftId[i]
547             );
548 
549             emit AddedNFTs(
550                 collarQuest,
551                 nftId[i],
552                 uint64(block.timestamp)
553             );
554         }
555     }
556 
557     /**
558      * @dev update price of NFT added to the sale list.
559      */
560     function updateNftPrice( uint[] memory nftId, uint[] memory price) external onlyOwner {
561         require(nftId.length == price.length, "InitialCoinOffering :: updateNftPrice : invalid length");
562         for(uint i=0;i<nftId.length;i++) {
563             require(price[i] > 0,"InitialCoinOffering :: updateNftPrice : price > 0");
564             require(listedOnSale[nftId[i]].isActive,"InitialCoinOffering :: updateNftPrice : not active");
565 
566             listedOnSale[nftId[i]].price = price[i];
567         }
568     }
569 
570     /**
571      * @dev update discount of NFT added to the sale list.
572      */
573     function updateNftDiscount(uint sale, uint16 newDiscount) external onlyOwner {
574         require((newDiscount > 0) && (newDiscount < DIVISOR),"InitialCoinOffering :: updateNftDiscount : price > 0");
575         require(sale < discount.length,"InitialCoinOffering :: updateNftDiscount : price > 0");
576         discount[sale] = newDiscount;
577     }
578 
579     /**
580      * @dev remove NFT from the sale list
581      */
582     function removeNftToList( uint[] memory nftId) external onlyOwner {
583         require(nftId.length > 0, "InitialCoinOffering :: removeNftToList : length must be higher than zero");
584         for(uint i=0;i<nftId.length;i++) {
585             require(listedOnSale[nftId[i]].isActive,"InitialCoinOffering :: removeNftToList : nft should be active on sale");
586 
587             listedOnSale[nftId[i]].isActive = false;
588             IERC721(collarQuest).safeTransferFrom(
589                 address(this),
590                 owner(),
591                 nftId[i]
592             );
593 
594             emit RemovedNFTs(
595                 collarQuest,
596                 nftId[i],
597                 uint64(block.timestamp)
598             );
599         }
600     }
601 
602     /**
603      * @dev add whitelist address.
604      */
605     function addToWhitelist(address[] calldata addresses) external onlyOwner {
606         require(addresses.length > 0,"InitialCoinOffering :: addToWhitelist : addresses length");
607 
608         for(uint8 i=0; i<addresses.length; i++) {
609             if(!whiteList[addresses[i]].isWhitelisted) {
610                 whiteList[addresses[i]].isWhitelisted = true;
611             }
612         }
613     }
614 
615     /**
616      * @dev remove whitelist address.
617      */
618     function removeFromWhitelist(address[] calldata addresses) external onlyOwner {
619         require(addresses.length > 0,"InitialCoinOffering :: removeFromWhitelist : addresses length");
620 
621         for(uint8 i=0; i<addresses.length; i++) {
622             if(whiteList[addresses[i]].isWhitelisted) {
623                 whiteList[addresses[i]].isWhitelisted = false;
624             }
625         }
626     }
627 
628     /**
629      * @dev whitelist addresses can buy NFTs on presale at discount price.
630      */
631     function preSale( uint nftId) external payable onlyWhitelister whenNotPaused nonReentrant {
632         require(!_isContract(_msgSender()),"InitialCoinOffering :: preSale : not a contract ");
633         require(
634             (timestamp[uint(Sale.preSale)].startTime > 0) &&
635             (timestamp[uint(Sale.preSale)].startTime <= getBlockTimestamp()) &&
636             (timestamp[uint(Sale.preSale)].endTime >= getBlockTimestamp()),
637             "InitialCoinOffering :: preSale : presale sale not yet started or sale ended"
638         );
639         require(listedOnSale[nftId].isActive,"InitialCoinOffering :: preSale : nft is not active");
640         require(getBuyerCount(_msgSender(),currentSaleId) < maxBuy,"InitialCoinOffering :: preSale : buyCount < maxBuy");
641         require(IERC721(listedOnSale[nftId].nftAddress).ownerOf(nftId) == address(this),"InitialCoinOffering :: preSale : NFT is not owned by contract");
642         
643         whiteList[_msgSender()].buyCount[currentSaleId]++;
644         listedOnSale[nftId].isActive = false;
645 
646         uint value = getDiscountPrice( nftId, uint8(Sale.preSale));
647         require(msg.value == value,"InitialCoinOffering :: preSale : invalid price value");
648 
649         _buy(_msgSender(), nftId, value, uint8(Sale.preSale));
650     }
651 
652     /**
653      * @dev both public and whitelisted address can buy NFTs at discount price.
654      */
655     function publicSale( uint nftId) external payable whenNotPaused nonReentrant {
656         require(!_isContract(_msgSender()),"InitialCoinOffering :: publicSale : address should not be a contract address");
657         require(
658             (timestamp[uint(Sale.publicSale)].startTime > 0) &&
659             (timestamp[uint(Sale.publicSale)].startTime <= getBlockTimestamp()) &&
660             (timestamp[uint(Sale.publicSale)].endTime >= getBlockTimestamp()),
661             "InitialCoinOffering :: publicSale : public sale not yet started or sale ended"
662         );
663         require(listedOnSale[nftId].isActive,"InitialCoinOffering :: publicSale : nft is not active");
664         require(IERC721(listedOnSale[nftId].nftAddress).ownerOf(nftId) == address(this),"InitialCoinOffering :: publicSale : NFT is not owned by contract");
665         
666         uint value = getDiscountPrice(nftId,uint8(Sale.publicSale));
667         require(msg.value == value,"InitialCoinOffering :: publicSale : invalid price value");
668 
669         listedOnSale[nftId].isActive = false;
670         _buy(_msgSender(), nftId, value, uint8(Sale.publicSale));
671     }
672 
673     /**
674      * @dev Can only buy nft token without any discount offer.
675      */
676     function crowdSale( uint nftId) external payable whenNotPaused nonReentrant {
677         require(!_isContract(_msgSender()),"InitialCoinOffering :: crowdSale : address should not be a contract address");
678         require(
679             (timestamp[uint(Sale.publicSale)].endTime > 0) &&
680             (timestamp[uint(Sale.publicSale)].endTime <= getBlockTimestamp()),
681             "InitialCoinOffering :: crowdSale : public sale is not ended"
682         );
683         require(listedOnSale[nftId].isActive,"InitialCoinOffering :: crowdSale : nft is not active");
684         require(IERC721(listedOnSale[nftId].nftAddress).ownerOf(nftId) == address(this),"InitialCoinOffering :: crowdSale : NFT is not owned by contract");
685         
686         uint value = getDiscountPrice(nftId,uint8(Sale.crowdSale));
687         require(msg.value == value,"InitialCoinOffering :: crowdSale : invalid price value");
688 
689         listedOnSale[nftId].isActive = false;
690         _buy(_msgSender(), nftId, value, uint8(Sale.crowdSale));
691     }
692 
693     /**
694      * @dev Allow owner to claim locked ETH on the contract.
695      */
696     function emergencyRelease( uint amount) public onlyOwner {
697         address self = address(this);
698         require(self.balance >= amount, "InitialCoinOffering :: emergencyRelease : insufficient balance");
699 
700         _send(payable(owner()),amount);        
701     }
702 
703     /**
704      * @dev Pauses the sale.
705      */
706     function pause() public onlyOwner {
707         _pause();
708     }
709 
710     /**
711      * @dev Unpause the sale.
712      */
713     function unpause() public onlyOwner {
714         _unpause();
715     }
716 
717     /**
718      * @dev Transfers offer token to owner.
719      */
720     function _buy( address buyer, uint nftId, uint value, uint8 saleType) private {
721         _send(payable(owner()),value);
722 
723         IERC721(listedOnSale[nftId].nftAddress).safeTransferFrom(
724             address(this),
725             buyer,
726             nftId
727         );
728 
729         emit Buy(
730             buyer,
731             nftId,
732             value,
733             uint64(block.timestamp),
734             saleType
735         );
736     }
737 
738     /**
739      * @dev Send ether to the recipient address.
740      */
741     function _send(address payable recipient, uint256 amount) private {
742         require(address(this).balance >= amount, "Address: insufficient balance");
743 
744         (bool success, ) = recipient.call{value: amount}("");
745         require(success, "Address: unable to send value, recipient may have reverted");
746     }
747 
748     /**
749      * @dev Returns discount price.
750      */
751     function getDiscountPrice(uint nftId, uint sale) public view returns (uint discountPrice) {
752         discountPrice = listedOnSale[nftId].price * (DIVISOR - discount[sale]) / DIVISOR;
753     }
754 
755     /**
756      * @dev Returns buyer count.
757      */
758     function getBuyerCount(address buyer, uint saleId) public view returns (uint256) {
759         return whiteList[buyer].buyCount[saleId];
760     }
761 
762     /**
763      * @dev Returns current block time.
764      */
765     function getBlockTimestamp() private view returns (uint256) {
766         return block.timestamp;
767     }
768     
769     /**
770      * @dev Returns true if caller is an contract.
771      */
772     function _isContract(address account) private view returns (bool) {
773         return account.code.length > 0;
774     }    
775 }