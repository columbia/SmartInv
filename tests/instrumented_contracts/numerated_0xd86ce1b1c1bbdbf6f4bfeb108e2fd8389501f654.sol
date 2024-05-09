1 pragma solidity ^0.5.0;
2 
3 pragma solidity ^0.5.0;
4 
5 interface BlockchainCutiesERC1155Interface
6 {
7     function mintNonFungibleSingleShort(uint128 _type, address _to) external;
8     function mintNonFungibleSingle(uint256 _type, address _to) external;
9     function mintNonFungibleShort(uint128 _type, address[] calldata _to) external;
10     function mintNonFungible(uint256 _type, address[] calldata _to) external;
11     function mintFungibleSingle(uint256 _id, address _to, uint256 _quantity) external;
12     function mintFungible(uint256 _id, address[] calldata _to, uint256[] calldata _quantities) external;
13     function isNonFungible(uint256 _id) external pure returns(bool);
14     function ownerOf(uint256 _id) external view returns (address);
15     function totalSupplyNonFungible(uint256 _type) view external returns (uint256);
16     function totalSupplyNonFungibleShort(uint128 _type) view external returns (uint256);
17 
18     /**
19         @notice A distinct Uniform Resource Identifier (URI) for a given token.
20         @dev URIs are defined in RFC 3986.
21         The URI may point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
22         @return URI string
23     */
24     function uri(uint256 _id) external view returns (string memory);
25     function proxyTransfer721(address _from, address _to, uint256 _tokenId, bytes calldata _data) external;
26     function proxyTransfer20(address _from, address _to, uint256 _tokenId, uint256 _value) external;
27     /**
28         @notice Get the balance of an account's Tokens.
29         @param _owner  The address of the token holder
30         @param _id     ID of the Token
31         @return        The _owner's balance of the Token type requested
32      */
33     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
34     /**
35         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
36         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
37         MUST revert if `_to` is the zero address.
38         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
39         MUST revert on any other error.
40         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
41         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
42         @param _from    Source address
43         @param _to      Target address
44         @param _id      ID of the token type
45         @param _value   Transfer amount
46         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
47     */
48     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
49 }
50 
51 pragma solidity ^0.5.0;
52 
53 
54 pragma solidity ^0.5.0;
55 
56 contract Operators
57 {
58     mapping (address=>bool) ownerAddress;
59     mapping (address=>bool) operatorAddress;
60 
61     constructor() public
62     {
63         ownerAddress[msg.sender] = true;
64     }
65 
66     modifier onlyOwner()
67     {
68         require(ownerAddress[msg.sender]);
69         _;
70     }
71 
72     function isOwner(address _addr) public view returns (bool) {
73         return ownerAddress[_addr];
74     }
75 
76     function addOwner(address _newOwner) external onlyOwner {
77         require(_newOwner != address(0));
78 
79         ownerAddress[_newOwner] = true;
80     }
81 
82     function removeOwner(address _oldOwner) external onlyOwner {
83         delete(ownerAddress[_oldOwner]);
84     }
85 
86     modifier onlyOperator() {
87         require(isOperator(msg.sender));
88         _;
89     }
90 
91     function isOperator(address _addr) public view returns (bool) {
92         return operatorAddress[_addr] || ownerAddress[_addr];
93     }
94 
95     function addOperator(address _newOperator) external onlyOwner {
96         require(_newOperator != address(0));
97 
98         operatorAddress[_newOperator] = true;
99     }
100 
101     function removeOperator(address _oldOperator) external onlyOwner {
102         delete(operatorAddress[_oldOperator]);
103     }
104 }
105 
106 
107 
108 /**
109  * @title Pausable
110  * @dev Base contract which allows children to implement an emergency stop mechanism.
111  */
112 contract Pausable is Operators {
113     event Pause();
114     event Unpause();
115 
116     bool public paused = false;
117 
118 
119     /**
120      * @dev Modifier to make a function callable only when the contract is not paused.
121      */
122     modifier whenNotPaused() {
123         require(!paused);
124         _;
125     }
126 
127     /**
128      * @dev Modifier to make a function callable only when the contract is paused.
129      */
130     modifier whenPaused() {
131         require(paused);
132         _;
133     }
134 
135     /**
136      * @dev called by the owner to pause, triggers stopped state
137      */
138     function pause() onlyOwner whenNotPaused public {
139         paused = true;
140         emit Pause();
141     }
142 
143     /**
144      * @dev called by the owner to unpause, returns to normal state
145      */
146     function unpause() onlyOwner whenPaused public {
147         paused = false;
148         emit Unpause();
149     }
150 }
151 
152 pragma solidity ^0.5.0;
153 
154 interface CutieGeneratorInterface
155 {
156     function generate(uint _genome, uint16 _generation, address[] calldata _target) external;
157     function generateSingle(uint _genome, uint16 _generation, address _target) external returns (uint40 babyId);
158 }
159 
160 pragma solidity ^0.5.0;
161 
162 /**
163     Note: The ERC-165 identifier for this interface is 0x43b236a2.
164 */
165 interface IERC1155TokenReceiver {
166 
167     /**
168         @notice Handle the receipt of a single ERC1155 token type.
169         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
170         This function MUST return `bytes4(keccak256("accept_erc1155_tokens()"))` (i.e. 0x4dc21a2f) if it accepts the transfer.
171         This function MUST revert if it rejects the transfer.
172         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
173         @param _operator  The address which initiated the transfer (i.e. msg.sender)
174         @param _from      The address which previously owned the token
175         @param _id        The id of the token being transferred
176         @param _value     The amount of tokens being transferred
177         @param _data      Additional data with no specified format
178         @return           `bytes4(keccak256("accept_erc1155_tokens()"))`
179     */
180     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);
181 
182     /**
183         @notice Handle the receipt of multiple ERC1155 token types.
184         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
185         This function MUST return `bytes4(keccak256("accept_batch_erc1155_tokens()"))` (i.e. 0xac007889) if it accepts the transfer(s).
186         This function MUST revert if it rejects the transfer(s).
187         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
188         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
189         @param _from      The address which previously owned the token
190         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
191         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
192         @param _data      Additional data with no specified format
193         @return           `bytes4(keccak256("accept_batch_erc1155_tokens()"))`
194     */
195     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);
196 
197     /**
198         @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
199         @dev This function MUST return `bytes4(keccak256("isERC1155TokenReceiver()"))` (i.e. 0x0d912442).
200         This function MUST NOT consume more than 5,000 gas.
201         @return           `bytes4(keccak256("isERC1155TokenReceiver()"))`
202     */
203     function isERC1155TokenReceiver() external view returns (bytes4);
204 }
205 
206 pragma solidity ^0.5.0;
207 
208 // ----------------------------------------------------------------------------
209 contract ERC20 {
210 
211     function balanceOf(address tokenOwner) external view returns (uint balance);
212     function transfer(address to, uint tokens) external returns (bool success);
213 }
214 
215 
216 /// @title BlockchainCuties Presale
217 /// @author https://BlockChainArchitect.io
218 contract Sale is Pausable, IERC1155TokenReceiver
219 {
220     struct RewardToken1155
221     {
222         uint tokenId;
223         uint count;
224     }
225 
226     struct RewardNFT
227     {
228         uint128 nftKind;
229         uint128 tokenIndex;
230     }
231 
232     struct RewardCutie
233     {
234         uint genome;
235         uint16 generation;
236     }
237 
238     uint32 constant RATE_SIGN = 0;
239     uint32 constant NATIVE = 1;
240 
241     struct Lot
242     {
243         RewardToken1155[] rewardsToken1155; // stackable
244         uint128[] rewardsNftMint; // stackable
245         RewardNFT[] rewardsNftFixed; // non stackable - one element per lot
246         RewardCutie[] rewardsCutie; // stackable
247         uint128 price;
248         uint128 leftCount;
249         uint128 priceMul;
250         uint128 priceAdd;
251         uint32 expireTime;
252         uint32 lotKind;
253     }
254 
255     mapping (uint32 => Lot) public lots;
256 
257     BlockchainCutiesERC1155Interface public token1155;
258     CutieGeneratorInterface public cutieGenerator;
259     address public signerAddress;
260 
261     event Bid(address indexed purchaser, uint32 indexed lotId, uint value, address indexed token);
262     event LotChange(uint32 indexed lotId);
263 
264     function setToken1155(BlockchainCutiesERC1155Interface _token1155) onlyOwner external
265     {
266         token1155 = _token1155;
267     }
268 
269     function setCutieGenerator(CutieGeneratorInterface _cutieGenerator) onlyOwner external
270     {
271         cutieGenerator = _cutieGenerator;
272     }
273 
274     function setLot(uint32 lotId, uint128 price, uint128 count, uint32 expireTime, uint128 priceMul, uint128 priceAdd, uint32 lotKind) external onlyOperator
275     {
276         Lot storage lot = lots[lotId];
277         lot.price = price;
278         lot.leftCount = count;
279         lot.expireTime = expireTime;
280         lot.priceMul = priceMul;
281         lot.priceAdd = priceAdd;
282         lot.lotKind = lotKind;
283         emit LotChange(lotId);
284     }
285 
286     function setLotLeftCount(uint32 lotId, uint128 count) external onlyOperator
287     {
288         Lot storage lot = lots[lotId];
289         lot.leftCount = count;
290         emit LotChange(lotId);
291     }
292 
293     function setExpireTime(uint32 lotId, uint32 expireTime) external onlyOperator
294     {
295         Lot storage lot = lots[lotId];
296         lot.expireTime = expireTime;
297         emit LotChange(lotId);
298     }
299 
300     function setPrice(uint32 lotId, uint128 price) external onlyOperator
301     {
302         lots[lotId].price = price;
303         emit LotChange(lotId);
304     }
305 
306     function deleteLot(uint32 lotId) external onlyOperator
307     {
308         delete lots[lotId];
309         emit LotChange(lotId);
310     }
311 
312     function addRewardToken1155(uint32 lotId, uint tokenId, uint count) external onlyOperator
313     {
314         lots[lotId].rewardsToken1155.push(RewardToken1155(tokenId, count));
315         emit LotChange(lotId);
316     }
317 
318     function setRewardToken1155(uint32 lotId, uint tokenId, uint count) external onlyOwner
319     {
320         delete lots[lotId].rewardsToken1155;
321         lots[lotId].rewardsToken1155.push(RewardToken1155(tokenId, count));
322         emit LotChange(lotId);
323     }
324 
325     function setRewardNftFixed(uint32 lotId, uint128 nftType, uint128 tokenIndex) external onlyOperator
326     {
327         delete lots[lotId].rewardsNftFixed;
328         lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex));
329         emit LotChange(lotId);
330     }
331 
332     function addRewardNftFixed(uint32 lotId, uint128 nftType, uint128 tokenIndex) external onlyOperator
333     {
334         lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex));
335         emit LotChange(lotId);
336     }
337 
338     function addRewardNftFixedBulk(uint32 lotId, uint128 nftType, uint128[] calldata tokenIndex) external onlyOperator
339     {
340         for (uint i = 0; i < tokenIndex.length; i++)
341         {
342             lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex[i]));
343         }
344         emit LotChange(lotId);
345     }
346 
347     function addRewardNftMint(uint32 lotId, uint128 nftType) external onlyOperator
348     {
349         lots[lotId].rewardsNftMint.push(nftType);
350         emit LotChange(lotId);
351     }
352 
353     function setRewardNftMint(uint32 lotId, uint128 nftType) external onlyOperator
354     {
355         delete lots[lotId].rewardsNftMint;
356         lots[lotId].rewardsNftMint.push(nftType);
357         emit LotChange(lotId);
358     }
359 
360     function addRewardCutie(uint32 lotId, uint genome, uint16 generation) external onlyOperator
361     {
362         lots[lotId].rewardsCutie.push(RewardCutie(genome, generation));
363         emit LotChange(lotId);
364     }
365 
366     function setRewardCutie(uint32 lotId, uint genome, uint16 generation) external onlyOperator
367     {
368         delete lots[lotId].rewardsCutie;
369         lots[lotId].rewardsCutie.push(RewardCutie(genome, generation));
370         emit LotChange(lotId);
371     }
372 
373     function isAvailable(uint32 lotId) public view returns (bool)
374     {
375         Lot storage lot = lots[lotId];
376         return
377             lot.leftCount > 0 && lot.expireTime >= now;
378     }
379 
380     function getLot(uint32 lotId) external view returns (
381         uint256 price,
382         uint256 left,
383         uint256 expireTime,
384         uint256 lotKind
385     )
386     {
387         Lot storage p = lots[lotId];
388         price = p.price;
389         left = p.leftCount;
390         expireTime = p.expireTime;
391         lotKind = p.lotKind;
392     }
393 
394     function getLotRewards(uint32 lotId) external view returns (
395             uint256 price,
396             uint256 left,
397             uint256 expireTime,
398             uint128 priceMul,
399             uint128 priceAdd,
400             uint256[5] memory rewardsToken1155tokenId,
401             uint256[5] memory rewardsToken1155count,
402             uint256[5] memory rewardsNFTMintNftKind,
403             uint256[5] memory rewardsNFTFixedKind,
404             uint256[5] memory rewardsNFTFixedIndex,
405             uint256[5] memory rewardsCutieGenome,
406             uint256[5] memory rewardsCutieGeneration
407         )
408     {
409         Lot storage p = lots[lotId];
410         price = p.price;
411         left = p.leftCount;
412         expireTime = p.expireTime;
413         priceAdd = p.priceAdd;
414         priceMul = p.priceMul;
415         uint i;
416         for (i = 0; i < p.rewardsToken1155.length; i++)
417         {
418             rewardsToken1155tokenId[i] = p.rewardsToken1155[i].tokenId;
419             rewardsToken1155count[i] = p.rewardsToken1155[i].count;
420         }
421         for (i = 0; i < p.rewardsNftMint.length; i++)
422         {
423             rewardsNFTMintNftKind[i] = p.rewardsNftMint[i];
424         }
425         for (i = 0; i < p.rewardsNftFixed.length; i++)
426         {
427             rewardsNFTFixedKind[i] = p.rewardsNftFixed[i].nftKind;
428             rewardsNFTFixedIndex[i] = p.rewardsNftFixed[i].tokenIndex;
429         }
430         for (i = 0; i < p.rewardsCutie.length; i++)
431         {
432             rewardsCutieGenome[i] = p.rewardsCutie[i].genome;
433             rewardsCutieGeneration[i] = p.rewardsCutie[i].generation;
434         }
435     }
436 
437     function deleteRewards(uint32 lotId) external onlyOwner
438     {
439         delete lots[lotId].rewardsToken1155;
440         delete lots[lotId].rewardsNftMint;
441         delete lots[lotId].rewardsNftFixed;
442         delete lots[lotId].rewardsCutie;
443         emit LotChange(lotId);
444     }
445 
446     function bidWithPlugin(uint32 lotId, uint valueForEvent, address tokenForEvent) external payable onlyOperator
447     {
448         _bid(lotId, valueForEvent, tokenForEvent);
449     }
450 
451     function _bid(uint32 lotId, uint valueForEvent, address tokenForEvent) internal whenNotPaused
452     {
453         Lot storage p = lots[lotId];
454         require(isAvailable(lotId), "Lot is not available");
455 
456         emit Bid(msg.sender, lotId, valueForEvent, tokenForEvent);
457 
458         p.leftCount--;
459         p.price += uint128(uint256(p.price)*p.priceMul / 1000000);
460         p.price += p.priceAdd;
461         uint i;
462         for (i = 0; i < p.rewardsToken1155.length; i++)
463         {
464             mintToken1155(msg.sender, p.rewardsToken1155[i]);
465         }
466         if (p.rewardsNftFixed.length > 0)
467         {
468             transferNFT(msg.sender, p.rewardsNftFixed[p.rewardsNftFixed.length-1]);
469             p.rewardsNftFixed.length--;
470         }
471         for (i = 0; i < p.rewardsNftMint.length; i++)
472         {
473             mintNFT(msg.sender, p.rewardsNftMint[i]);
474         }
475         for (i = 0; i < p.rewardsCutie.length; i++)
476         {
477             mintCutie(msg.sender, p.rewardsCutie[i]);
478         }
479     }
480 
481     function mintToken1155(address purchaser, RewardToken1155 storage reward) internal
482     {
483         token1155.mintFungibleSingle(reward.tokenId, purchaser, reward.count);
484     }
485 
486     function mintNFT(address purchaser, uint128 nftKind) internal
487     {
488         token1155.mintNonFungibleSingleShort(nftKind, purchaser);
489     }
490 
491     function transferNFT(address purchaser, RewardNFT storage reward) internal
492     {
493         uint tokenId = (uint256(reward.nftKind) << 128) | (1 << 255) | reward.tokenIndex;
494         token1155.safeTransferFrom(address(this), purchaser, tokenId, 1, "");
495     }
496 
497     function mintCutie(address purchaser, RewardCutie storage reward) internal
498     {
499         cutieGenerator.generateSingle(reward.genome, reward.generation, purchaser);
500     }
501 
502     function destroyContract() external onlyOwner {
503         require(address(this).balance == 0);
504         selfdestruct(msg.sender);
505     }
506 
507     /// @dev Reject all Ether
508     function() external payable {
509         revert();
510     }
511 
512     /// @dev The balance transfer to project owners
513     function withdrawEthFromBalance(uint value) external onlyOwner
514     {
515         uint256 total = address(this).balance;
516         if (total > value)
517         {
518             total = value;
519         }
520 
521         msg.sender.transfer(total);
522     }
523 
524     function bidNative(uint32 lotId) external payable
525     {
526         Lot storage lot = lots[lotId];
527         require(lot.price <= msg.value, "Not enough value provided");
528         require(lot.lotKind == NATIVE, "Lot kind should be NATIVE");
529 
530         _bid(lotId, msg.value, address(0x0));
531     }
532 
533     function bid(uint32 lotId, uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) external payable
534     {
535         Lot storage lot = lots[lotId];
536         require(lot.lotKind == RATE_SIGN, "Lot kind should be RATE_SIGN");
537 
538         require(isValidSignature(rate, expireAt, _v, _r, _s));
539         require(expireAt >= now, "Rate sign is expired");
540 
541 
542         uint priceInWei = rate * lot.price;
543         require(priceInWei <= msg.value, "Not enough value provided");
544 
545         _bid(lotId, priceInWei, address(0x0));
546     }
547 
548     function setSigner(address _newSigner) public onlyOwner {
549         signerAddress = _newSigner;
550     }
551 
552     function isValidSignature(uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) public view returns (bool)
553     {
554         return getSigner(rate, expireAt, _v, _r, _s) == signerAddress;
555     }
556 
557     function getSigner(uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address)
558     {
559         bytes32 msgHash = hashArguments(rate, expireAt);
560         return ecrecover(msgHash, _v, _r, _s);
561     }
562 
563     /// @dev Common function to be used also in backend
564     function hashArguments(uint rate, uint expireAt) public pure returns (bytes32 msgHash)
565     {
566         msgHash = keccak256(abi.encode(rate, expireAt));
567     }
568 
569     function withdrawERC20FromBalance(ERC20 _tokenContract) external onlyOwner
570     {
571         uint256 balance = _tokenContract.balanceOf(address(this));
572         _tokenContract.transfer(msg.sender, balance);
573     }
574 
575     function withdrawERC1155FromBalance(BlockchainCutiesERC1155Interface _tokenContract, uint tokenId) external onlyOwner
576     {
577         uint256 balance = _tokenContract.balanceOf(address(this), tokenId);
578         _tokenContract.safeTransferFrom(address(this), msg.sender, tokenId, balance, "");
579     }
580 
581     function isERC1155TokenReceiver() external view returns (bytes4) {
582         return bytes4(keccak256("isERC1155TokenReceiver()"));
583     }
584 
585     function onERC1155BatchReceived(address, address, uint256[] calldata, uint256[] calldata, bytes calldata) external returns(bytes4)
586     {
587         return bytes4(keccak256("acrequcept_batch_erc1155_tokens()"));
588     }
589 
590     function onERC1155Received(address, address, uint256, uint256, bytes calldata) external returns(bytes4)
591     {
592         return bytes4(keccak256("accept_erc1155_tokens()"));
593     }
594 }