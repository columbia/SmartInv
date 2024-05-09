1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title - Crypto Skully
5  * ███████╗██╗    ██╗ █████╗ ██████╗    ███████╗██╗  ██╗██╗   ██╗██╗     ██╗     ██╗   ██╗
6  * ██╔════╝██║    ██║██╔══██╗██╔══██╗   ██╔════╝██║ ██╔╝██║   ██║██║     ██║     ╚██╗ ██╔╝
7  * ███████╗██║ █╗ ██║███████║██████╔╝   ███████╗█████╔╝ ██║   ██║██║     ██║      ╚████╔╝
8  * ╚════██║██║███╗██║██╔══██║██╔═══╝    ╚════██║██╔═██╗ ██║   ██║██║     ██║       ╚██╔╝
9  * ███████║╚███╔███╔╝██║  ██║██║        ███████║██║  ██╗╚██████╔╝███████╗███████╗   ██║
10  * ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝        ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝   ╚═╝
11  * ---
12  *
13  * POWERED BY
14  *  __    ___   _     ___  _____  ___     _     ___
15  * / /`  | |_) \ \_/ | |_)  | |  / / \   | |\ |  ) )
16  * \_\_, |_| \  |_|  |_|    |_|  \_\_/   |_| \| _)_)
17  *
18  * Game at https://skullys.co/
19  **/
20  
21 contract SwapControl {
22     // This facet controls access control for CryptoSkullys. There are four roles managed here:
23     //
24     //     - The Admiral: The Admiral can reassign other roles and change the addresses of our dependent smart
25     //         contracts. It is also the only role that can unpause the smart contract. It is initially
26     //         set to the address that created the smart contract in the SkullyCore constructor.
27     //
28     //     - The Pilot: The Pilot can withdraw funds from SkullyCore and its auction contracts.
29     //
30     //     - The Captain: The Captain can release new minted skullys to auction, and mint promo skullys.
31     //
32     // It should be noted that these roles are distinct without overlap in their access abilities, the
33     // abilities listed for each role above are exhaustive. In particular, while the Admiral can assign any
34     // address to any role, the Admiral address itself doesn't have the ability to act in those roles. This
35     // restriction is intentional so that we aren't tempted to use the Admiral address frequently out of
36     // convenience. The less we use an address, the less likely it is that we somehow compromise the
37     // account.
38 
39     /// @dev Emitted when contract is upgraded - See README.md for upgrade plan
40     event ContractUpgrade(address newContract);
41 
42     // The addresses of the accounts (or contracts) that can execute actions within each roles.
43     address payable public admiralAddress;
44     address payable public pilotAddress;
45     address payable public captainAddress;
46 
47     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
48     bool public paused = false;
49 
50     /// @dev Access modifier for admiral-only functionality
51     modifier onlyAdmiral() {
52         require(msg.sender == admiralAddress);
53         _;
54     }
55 
56     /// @dev Access modifier for Pilot-only functionality
57     modifier onlyPilot() {
58         require(msg.sender == pilotAddress);
59         _;
60     }
61 
62     /// @dev Access modifier for Captain-only functionality
63     modifier onlyCaptain() {
64         require(msg.sender == captainAddress);
65         _;
66     }
67 
68     modifier onlyCLevel() {
69         require(
70             msg.sender == captainAddress ||
71             msg.sender == admiralAddress ||
72             msg.sender == pilotAddress);
73         _;
74     }
75 
76     /// @dev Assigns a new address to act as the admiral. Only available to the current admiral.
77     /// @param _newAdmiral The address of the new Admiral
78     function setAdmiral(address payable _newAdmiral) external onlyAdmiral {
79         require(_newAdmiral != address(0));
80 
81         admiralAddress = _newAdmiral;
82     }
83 
84     /// @dev Assigns a new address to act as the pilot. Only available to the current Admiral.
85     /// @param _newPilot The address of the new Pilot
86     function setPilot(address payable _newPilot) external onlyAdmiral {
87         require(_newPilot != address(0));
88 
89         pilotAddress = _newPilot;
90     }
91 
92     /// @dev Assigns a new address to act as the captain. Only available to the current Admiral.
93     /// @param _newCaptain The address of the new Captain
94     function setCaptain(address payable _newCaptain) external onlyAdmiral {
95         require(_newCaptain != address(0));
96 
97         captainAddress = _newCaptain;
98     }
99 
100     /*** Pausable functionality adapted from OpenZeppelin ***/
101 
102     /// @dev Modifier to allow actions only when the contract IS NOT paused
103     modifier whenNotPaused() {
104         require(!paused);
105         _;
106     }
107 
108     /// @dev Modifier to allow actions only when the contract IS paused
109     modifier whenPaused {
110         require(paused);
111         _;
112     }
113 
114     /// @dev Called by any "C-level" role to pause the contract. Used only when
115     ///  a bug or exploit is detected and we need to limit damage.
116     function pause() external onlyCLevel whenNotPaused {
117         paused = true;
118     }
119 
120     /// @dev Unpauses the smart contract. Can only be called by the Admiral, since
121     ///  one reason we may pause the contract is when Pilot or Captain accounts are
122     ///  compromised.
123     /// @notice This is public rather than external so it can be called by
124     ///  derived contracts.
125     function unpause() public onlyAdmiral whenPaused {
126         // can't unpause if contract was upgraded
127         paused = false;
128     }
129 }
130 
131 interface IERC165 {
132     /**
133      * @notice Query if a contract implements an interface
134      * @param interfaceId The interface identifier, as specified in ERC-165
135      * @dev Interface identification is specified in ERC-165. This function
136      * uses less than 30,000 gas.
137      */
138     function supportsInterface(bytes4 interfaceId) external view returns (bool);
139 }
140 contract ERC721 is IERC165 {
141 
142     // IERC721
143     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
144     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
145     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
146 
147     function balanceOf(address owner) public view returns (uint256 balance);
148     function ownerOf(uint256 tokenId) public view returns (address owner);
149 
150     function approve(address to, uint256 tokenId) public;
151     function getApproved(uint256 tokenId) public view returns (address operator);
152 
153     function setApprovalForAll(address operator, bool _approved) public;
154     function isApprovedForAll(address owner, address operator) public view returns (bool);
155 
156     function transferFrom(address from, address to, uint256 tokenId) public;
157     function safeTransferFrom(address from, address to, uint256 tokenId) public;
158 
159     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
160 
161     // IERC721Metadata
162     function name() external view returns (string memory);
163     function symbol() external view returns (string memory);
164     function tokenURI(uint256 tokenId) public view returns (string memory);
165 
166     // IERC721Enumerable
167     function totalSupply() public view returns (uint256);
168     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
169 
170     function tokenByIndex(uint256 index) public view returns (uint256);
171     
172     
173     ///-----For ERC721 using transfer() function ---///
174     function transfer(address _to, uint256 _tokenId) external;
175     
176     ///-------------------------------------------///
177     
178     function addNewCategory(uint256 _id, string calldata _newCategory) external;
179     
180     function changeCategory(uint256 _id, string calldata _newCategory) external;
181     
182     function updateSkill(uint256 _skullyId, uint256 _newAttack, uint256 _newDefend) external;
183     
184     function createPromoSkully(uint256 _skullyId, uint256 _attack, uint256 _defend, uint256 _category, address _owner) external;
185     
186     function createSaleAuction(uint256 _skullyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, uint _paymentBy) external;
187     
188     function createNewSkullyAuction(uint256 _newSkullyId, uint256 _category, uint256 _startingPrice, uint256 _endingPrice) public;
189 
190     function createNewSkullysAuction(uint256 _startId, uint256 _endId, uint256 _category, uint256 _startingPrice, uint256 _endingPrice) external;
191         
192     function createNewSkully(uint256 _newSkullyId, uint256 _category, address _owner) external;
193         
194     function createNewSkullys(uint256 _startId, uint256 _endId, uint256 _category, address _owner) external;
195         
196     function setGamePlayAddress(address _gameAddress) external;
197 }
198 
199 contract ERC20 {
200     function totalSupply() public view returns (uint256);
201     function balanceOf(address who) public view returns (uint256);
202     function transfer(address to, uint256 value) public;
203     function allowance(address owner, address spender) public view returns (uint256);
204     function transferFrom(address from, address to, uint256 value) public returns (bool);
205     function approve(address spender, uint256 value) public returns (bool);
206 
207     event Approval(address indexed owner, address indexed spender, uint256 value);
208     event Transfer(address indexed from, address indexed to, uint256 value);
209 }
210 
211 contract ClockAuction {
212     function cancelAuction(uint256 _tokenId) external;
213 }
214 
215 contract SkullyItems {
216     function setDiscount(uint256 _newDiscount) external returns (uint256);
217     
218     function createNewMainAccessory(string memory name) public;
219     
220     function createNewAccessory(
221         uint256 accessoryType,
222         uint256 accessoryId,
223         string memory name,
224         uint256 attack,
225         uint256 defend,
226         uint256 po8,
227         uint256 eth,
228         uint256 po8DailyMultiplier,
229         bool mustUnlock) public;
230         
231     function updateAccessoryInformation(
232         uint256 id,
233         string calldata newName,
234         uint256 newAttack,
235         uint256 newDefend,
236         uint256 newPO8,
237         uint256 newEth,
238         uint256 newPO8DailyMultiplier,
239         bool newMustUnlock) external returns (bool);
240         
241     function setAccessoryToSkully(uint256 skullyId, uint256 realAccessoryId) external;
242     
243     function setGamePlayAddress(address _gameAddress) external;
244     
245     function setNewRankPrice(uint8 rank, uint256 newPrice) public returns (bool);
246     
247     function setNewRankFlags(uint8 rank, uint256 newFlags) public returns (bool);
248     
249     function setExchangeRate(uint256 _newExchangeRate) external returns (uint256);
250     
251     function createNewBadge(uint256 badgeId, string memory description, uint256 po8) public;
252     
253     function setPO8OfBadge(uint256 badgeId, uint256 po8) public;
254     
255     function setClaimBadgeContract(address newAddress) external;
256     
257     function increaseSkullyExp(uint256 skullyId, uint256 flags) external;
258     
259     function setBadgeToSkully(uint256 skullyId, uint256 badgeId) external;
260 }
261 
262 contract ExchangeERC721 is SwapControl {
263     
264     /// @dev The ERC-165 interface signature for ERC-721.
265     ///  Ref: https://github.com/ethereum/EIPs/issues/165
266     ///  Ref: https://github.com/ethereum/EIPs/issues/721
267     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x80ac58cd);
268     ERC721 public skullyContract;
269     ClockAuction public auctionContract;
270     SkullyItems public itemContract;
271     
272     mapping(uint64 => address) public listERC721;
273     uint64 public totalERC721;
274     uint64 public plusFlags;
275     
276     bool public pureSwapState;
277 
278 	/* @notice This constructor of contract
279 	 * @param _nftAddress the address of skully core
280 	 * @param _auctionAdress the address of sale auction
281 	 * @param _itemAdress the address of skully item
282 	 * return none
283 	*/
284     constructor(address _nftAddress, address _auctionAdress, address _itemAdress) public {
285         ERC721 candidateContract = ERC721(_nftAddress);
286         require(candidateContract.supportsInterface(InterfaceSignature_ERC721), "The candidate contract must supports ERC721");
287         skullyContract = candidateContract;
288         
289         auctionContract = ClockAuction(_auctionAdress);
290         
291         itemContract = SkullyItems(_itemAdress);
292         
293         listERC721[0] = address(candidateContract);
294         totalERC721++;
295         
296         // the creator of the contract is the initial Admiral
297         admiralAddress = msg.sender;
298 
299         // the creator of the contract is the initial Pilot
300         pilotAddress = msg.sender;
301 
302         // the creator of the contract is also the initial Captain
303         captainAddress = msg.sender;
304         
305         pureSwapState = false;
306         plusFlags = 1000;
307     }
308     
309     event Swapped(uint256 _skullyId, uint256 _exchangeTokenId, uint64 _typeERC, uint256 _time);
310     event PureSwapped(uint256 _skullyId, uint256 _exchangeTokenId, uint64 _typeERC, uint256 _time);
311     
312 	/* @notice This function was invoked when user want to swap their collections with skully
313 	 * @param skullyId the id of skully that user want to swap
314 	 * @param exchangeTokenId the id of their collections
315 	 * @param typeERC the number of erc721 in the list of contract that allow to exchange with 
316 	 * return none - just emit a result to the network
317 	*/
318     function swap(uint256 skullyId, uint256 exchangeTokenId, uint64 typeERC) public whenNotPaused {
319         ERC721(listERC721[typeERC]).transferFrom(msg.sender, address(this), exchangeTokenId);
320         // cancel sale auction
321         auctionContract.cancelAuction(skullyId);
322         
323         // set flag
324         itemContract.increaseSkullyExp(skullyId, plusFlags);
325         
326         skullyContract.transferFrom(address(this), msg.sender, skullyId);
327         
328         emit Swapped(skullyId, exchangeTokenId, typeERC, block.timestamp);
329     }
330     
331 	/* @notice This function was invoked when user want to swap their collections with skully
332 	 * @param skullyId the id of skully that user want to swap
333 	 * @param exchangeTokenId the id of their collections
334 	 * @param typeERC the number of erc721 in the list of contract that allow to exchange with 
335 	 * return none - just emit a result to the network
336 	*/
337     function pureSwap(uint256 skullyId, uint256 exchangeTokenId, uint64 typeERC) public whenNotPaused {
338         require(pureSwapState == true);
339         ERC721(listERC721[typeERC]).transferFrom(msg.sender, address(this), exchangeTokenId);
340         skullyContract.transferFrom(address(this), msg.sender, skullyId);
341         
342         emit PureSwapped(skullyId, exchangeTokenId, typeERC, block.timestamp);
343     }
344     
345 	/* @notice
346 	 * @param
347 	 * return
348 	*/
349     function setPureSwapSate(bool _state) public onlyCaptain {
350         pureSwapState = _state;
351     }
352     
353 	/* @notice
354 	 * @param
355 	 * return
356 	*/
357     function setFlags(uint64 _newFlags) public onlyCaptain {
358         plusFlags = _newFlags;
359     }
360 	
361 	///------------------NFT-----------------------///
362     event NewNFTAdded(uint64 _id, address _newNFT);
363     event NFTDeleted(uint64 _id, address _nftDelete);
364     event NFTUpdated(uint64 _id, address _oldAddress, address _newAddress);
365     
366 	/* @notice
367 	 * @param
368 	 * return
369 	*/
370     function addNewNFT(address newNFTAddress) public onlyCaptain {
371         listERC721[totalERC721] = newNFTAddress;
372         emit NewNFTAdded(totalERC721, newNFTAddress);
373         totalERC721++;
374     }
375     
376 	/* @notice
377 	 * @param
378 	 * return
379 	*/
380     function addNewNFTs(address[] memory _newNFTsAddress) public onlyCaptain {
381         for(uint i = 0; i < _newNFTsAddress.length; i++)
382             addNewNFT(_newNFTsAddress[i]);
383     }
384     
385 	/* @notice
386 	 * @param
387 	 * return
388 	*/
389     function deleteNFT(uint64 _id) external onlyCaptain {
390         emit NFTDeleted(_id, listERC721[_id]);
391         listERC721[_id] = address(0);
392     }
393     
394 	/* @notice
395 	 * @param
396 	 * return
397 	*/
398     function updateNFT(uint64 _id, address updateNFTAddress) external onlyCaptain {
399         emit NFTUpdated(_id, listERC721[_id], updateNFTAddress);
400         listERC721[_id] = updateNFTAddress;
401     }
402 	
403 	
404     ///-----------------------------------------///
405     
406 	/* @notice
407 	 * @param
408 	 * return
409 	*/
410     function transferFromERC721ToCaptainWallet(uint256 tokenId, address erc721Adress) external onlyCaptain {
411         ERC721(erc721Adress).transferFrom(address(this), captainAddress, tokenId);
412     }
413     
414 	/* @notice
415 	 * @param
416 	 * return
417 	*/
418     function transferFromERC721sToCaptainWallet(uint256[] calldata tokenIds, address erc721Adress) external onlyCaptain {
419         for(uint256 i = 0; i < tokenIds.length; i++)
420             ERC721(erc721Adress).transferFrom(address(this), captainAddress, tokenIds[i]);
421     }
422     
423 	/* @notice
424 	 * @param
425 	 * return
426 	*/
427     function transferERC721ToCaptainWallet(uint256 tokenId, address erc721Adress) external onlyCaptain {
428         ERC721(erc721Adress).transfer(captainAddress, tokenId);
429     }
430     
431 	/* @notice
432 	 * @param
433 	 * return
434 	*/
435     function transferERC721sToCaptainWallet(uint256[] calldata tokenIds, address erc721Adress) external onlyCaptain {
436         for(uint256 i = 0; i < tokenIds.length; i++)
437             ERC721(erc721Adress).transfer(captainAddress, tokenIds[i]);
438     }
439     
440 	/* @notice
441 	 * @param
442 	 * return
443 	*/
444     function transferERC20ToCaptainWallet(address erc20Adress) external onlyCaptain {
445         ERC20 token = ERC20(erc20Adress);
446         token.transfer(captainAddress, token.balanceOf(address(this)));
447     }
448     
449     // @dev Allows the pilot to capture the balance available to the contract.
450     function withdrawBalance() external onlyCaptain {
451         uint256 balance = address(this).balance;
452 
453         captainAddress.transfer(balance);
454     }
455     
456 	// This contract address allow ether transfer in
457     function() external payable {}
458 	
459 	    
460     ///-----------------------------------------///
461     function createManySaleAuction(uint256[] calldata _listSkullyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, uint _paymentBy) external onlyCaptain {
462         for(uint i = 0; i < _listSkullyId.length; i++)
463             createSaleAuction(_listSkullyId[i], _startingPrice, _endingPrice, _duration, _paymentBy);
464     }
465     
466 	
467 	// Don't care the rest of function below
468 	// It's belong to captain features
469     ///-----------------ERC721------------------------///
470     
471     function setApprovalForAll(address operator, bool _approved) public onlyCaptain {
472         skullyContract.setApprovalForAll(operator, _approved);
473     }
474     
475     function addNewCategory(uint256 _id, string calldata _newCategory) external onlyCaptain {
476         skullyContract.addNewCategory(_id, _newCategory);
477     }
478     
479     function changeCategory(uint256 _id, string calldata _newCategory) external onlyCaptain {
480         skullyContract.changeCategory(_id, _newCategory);
481     }
482     
483     function updateSkill(uint256 _skullyId, uint256 _newAttack, uint256 _newDefend) external onlyCaptain {
484         skullyContract.updateSkill(_skullyId, _newAttack, _newDefend);
485     }
486     
487     function createPromoSkully(uint256 _skullyId, uint256 _attack, uint256 _defend, uint256 _category, address _owner) external onlyCaptain {
488         skullyContract.createPromoSkully(_skullyId, _attack, _defend, _category, _owner);
489     }
490     
491     function createSaleAuction(uint256 _skullyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration, uint _paymentBy) public onlyCaptain {
492         skullyContract.createSaleAuction(_skullyId, _startingPrice, _endingPrice, _duration, _paymentBy);
493     }
494     
495     function createNewSkullyAuction(uint256 _newSkullyId, uint256 _category, uint256 _startingPrice, uint256 _endingPrice) public onlyCaptain {
496         skullyContract.createNewSkullyAuction(_newSkullyId, _category, _startingPrice, _endingPrice);
497     }
498 
499     function createNewSkullysAuction(uint256 _startId, uint256 _endId, uint256 _category, uint256 _startingPrice, uint256 _endingPrice) external onlyCaptain {
500         skullyContract.createNewSkullysAuction(_startId, _endId, _category, _startingPrice, _endingPrice);
501     }
502         
503     function createNewSkully(uint256 _newSkullyId, uint256 _category, address _owner) external onlyCaptain {
504         skullyContract.createNewSkully(_newSkullyId, _category, _owner);
505     }
506         
507     function createNewSkullys(uint256 _startId, uint256 _endId, uint256 _category, address _owner) external onlyCaptain {
508         skullyContract.createNewSkullys(_startId, _endId, _category, _owner);
509     }
510         
511     function setGamePlayAddress(address _gameAddress) external onlyCaptain {
512         skullyContract.setGamePlayAddress(_gameAddress);
513     }
514     
515     ///-----------------ITEMS------------------------///
516     
517     function setDiscount(uint256 _newDiscount) external onlyCaptain returns (uint256) {
518         itemContract.setDiscount(_newDiscount);
519     }
520     
521     function createNewMainAccessory(string memory name) public onlyCaptain {
522         itemContract.createNewMainAccessory(name);
523     }
524     
525     function createNewAccessory(
526         uint256 accessoryType,
527         uint256 accessoryId,
528         string memory name,
529         uint256 attack,
530         uint256 defend,
531         uint256 po8,
532         uint256 eth,
533         uint256 po8DailyMultiplier,
534         bool mustUnlock) public onlyCaptain {
535         itemContract.createNewAccessory(accessoryType, accessoryId, name, attack, defend, po8, eth, po8DailyMultiplier, mustUnlock);
536         }
537         
538     function updateAccessoryInformation(
539         uint256 id,
540         string calldata newName,
541         uint256 newAttack,
542         uint256 newDefend,
543         uint256 newPO8,
544         uint256 newEth,
545         uint256 newPO8DailyMultiplier,
546         bool newMustUnlock) external onlyCaptain returns (bool) {
547         itemContract.updateAccessoryInformation(id, newName, newAttack, newDefend, newPO8, newEth, newPO8DailyMultiplier, newMustUnlock);
548         }
549         
550     function setAccessoryToSkully(uint256 skullyId, uint256 realAccessoryId) external onlyCaptain {
551         itemContract.setAccessoryToSkully(skullyId, realAccessoryId);
552     }
553     
554     function setItemGamePlayAddress(address _gameAddress) external onlyCaptain {
555         itemContract.setGamePlayAddress(_gameAddress);
556     }
557     
558     function setNewRankPrice(uint8 rank, uint256 newPrice) public onlyCaptain returns (bool) {
559         itemContract.setNewRankPrice(rank, newPrice);
560     }
561     
562     function setNewRankFlags(uint8 rank, uint256 newFlags) public  onlyCaptain returns (bool) {
563         itemContract.setNewRankFlags(rank, newFlags);
564     }
565     
566     function setExchangeRate(uint256 _newExchangeRate) external onlyCaptain returns (uint256) {
567         itemContract.setExchangeRate(_newExchangeRate);
568     }
569     
570     function createNewBadge(uint256 badgeId, string memory description, uint256 po8) public onlyCaptain {
571         itemContract.createNewBadge(badgeId, description, po8);
572     }
573     
574     function setPO8OfBadge(uint256 badgeId, uint256 po8) public onlyCaptain {
575         itemContract.setPO8OfBadge(badgeId, po8);
576     }
577     
578     function setClaimBadgeContract(address newAddress) external onlyCaptain {
579         itemContract.setClaimBadgeContract(newAddress);
580     }
581     
582     function increaseSkullyExp(uint256 skullyId, uint256 flags) external onlyCaptain {
583         itemContract.increaseSkullyExp(skullyId, flags);
584     }
585     
586     function setBadgeToSkully(uint256 skullyId, uint256 badgeId) external onlyCaptain {
587         itemContract.setBadgeToSkully(skullyId, badgeId);
588     }
589     
590     ///-------------------AUCTION----------------------///
591     
592     function cancelAuction(uint256 _tokenId) public onlyCaptain {
593         auctionContract.cancelAuction(_tokenId);
594     }
595     
596     function cancelManyAuction(uint256[] calldata _listTokenId) external onlyCaptain {
597         for(uint i = 0; i < _listTokenId.length; i++)
598             cancelAuction(_listTokenId[i]);
599     }
600 }