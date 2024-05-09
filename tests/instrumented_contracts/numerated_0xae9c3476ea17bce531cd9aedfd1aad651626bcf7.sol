1 pragma solidity ^0.4.23;
2 
3 pragma solidity ^0.4.23;
4 
5 pragma solidity ^0.4.23;
6 
7 
8 pragma solidity ^0.4.23;
9 
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     emit OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 
52 
53 /**
54  * @title Pausable
55  * @dev Base contract which allows children to implement an emergency stop mechanism.
56  */
57 contract Pausable is Ownable {
58   event Pause();
59   event Unpause();
60 
61   bool public paused = false;
62 
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is not paused.
66    */
67   modifier whenNotPaused() {
68     require(!paused);
69     _;
70   }
71 
72   /**
73    * @dev Modifier to make a function callable only when the contract is paused.
74    */
75   modifier whenPaused() {
76     require(paused);
77     _;
78   }
79 
80   /**
81    * @dev called by the owner to pause, triggers stopped state
82    */
83   function pause() onlyOwner whenNotPaused public {
84     paused = true;
85     emit Pause();
86   }
87 
88   /**
89    * @dev called by the owner to unpause, returns to normal state
90    */
91   function unpause() onlyOwner whenPaused public {
92     paused = false;
93     emit Unpause();
94   }
95 }
96 
97 pragma solidity ^0.4.23;
98 
99 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
100 contract PluginInterface
101 {
102     /// @dev simply a boolean to indicate this is the contract we expect to be
103     function isPluginInterface() public pure returns (bool);
104 
105     function onRemove() public;
106 
107     /// @dev Begins new feature.
108     /// @param _cutieId - ID of token to auction, sender must be owner.
109     /// @param _parameter - arbitrary parameter
110     /// @param _seller - Old owner, if not the message sender
111     function run(
112         uint40 _cutieId,
113         uint256 _parameter,
114         address _seller
115     )
116     public
117     payable;
118 
119     /// @dev Begins new feature, approved and signed by COO.
120     /// @param _cutieId - ID of token to auction, sender must be owner.
121     /// @param _parameter - arbitrary parameter
122     function runSigned(
123         uint40 _cutieId,
124         uint256 _parameter,
125         address _owner
126     ) external payable;
127 
128     function withdraw() external;
129 }
130 
131 pragma solidity ^0.4.23;
132 
133 pragma solidity ^0.4.23;
134 
135 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
136 /// @author https://BlockChainArchitect.io
137 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
138 interface ConfigInterface
139 {
140     function isConfig() external pure returns (bool);
141 
142     function getCooldownIndexFromGeneration(uint16 _generation, uint40 _cutieId) external view returns (uint16);
143     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 _cutieId) external view returns (uint40);
144     function getCooldownIndexFromGeneration(uint16 _generation) external view returns (uint16);
145     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) external view returns (uint40);
146 
147     function getCooldownIndexCount() external view returns (uint256);
148 
149     function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16);
150     function getBabyGen(uint16 _momGen, uint16 _dadGen) external pure returns (uint16);
151 
152     function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16);
153 
154     function getBreedingFee(uint40 _momId, uint40 _dadId) external view returns (uint256);
155 }
156 
157 
158 contract CutieCoreInterface
159 {
160     function isCutieCore() pure public returns (bool);
161 
162     ConfigInterface public config;
163 
164     function transferFrom(address _from, address _to, uint256 _cutieId) external;
165     function transfer(address _to, uint256 _cutieId) external;
166 
167     function ownerOf(uint256 _cutieId)
168         external
169         view
170         returns (address owner);
171 
172     function getCutie(uint40 _id)
173         external
174         view
175         returns (
176         uint256 genes,
177         uint40 birthTime,
178         uint40 cooldownEndTime,
179         uint40 momId,
180         uint40 dadId,
181         uint16 cooldownIndex,
182         uint16 generation
183     );
184 
185     function getGenes(uint40 _id)
186         public
187         view
188         returns (
189         uint256 genes
190     );
191 
192 
193     function getCooldownEndTime(uint40 _id)
194         public
195         view
196         returns (
197         uint40 cooldownEndTime
198     );
199 
200     function getCooldownIndex(uint40 _id)
201         public
202         view
203         returns (
204         uint16 cooldownIndex
205     );
206 
207 
208     function getGeneration(uint40 _id)
209         public
210         view
211         returns (
212         uint16 generation
213     );
214 
215     function getOptional(uint40 _id)
216         public
217         view
218         returns (
219         uint64 optional
220     );
221 
222 
223     function changeGenes(
224         uint40 _cutieId,
225         uint256 _genes)
226         public;
227 
228     function changeCooldownEndTime(
229         uint40 _cutieId,
230         uint40 _cooldownEndTime)
231         public;
232 
233     function changeCooldownIndex(
234         uint40 _cutieId,
235         uint16 _cooldownIndex)
236         public;
237 
238     function changeOptional(
239         uint40 _cutieId,
240         uint64 _optional)
241         public;
242 
243     function changeGeneration(
244         uint40 _cutieId,
245         uint16 _generation)
246         public;
247 
248     function createSaleAuction(
249         uint40 _cutieId,
250         uint128 _startPrice,
251         uint128 _endPrice,
252         uint40 _duration
253     )
254     public;
255 
256     function getApproved(uint256 _tokenId) external returns (address);
257     function totalSupply() view external returns (uint256);
258     function createPromoCutie(uint256 _genes, address _owner) external;
259     function checkOwnerAndApprove(address _claimant, uint40 _cutieId, address _pluginsContract) external view;
260     function breedWith(uint40 _momId, uint40 _dadId) public payable returns (uint40);
261     function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);
262     function restoreCutieToAddress(uint40 _cutieId, address _recipient) external;
263     function createGen0Auction(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration) external;
264     function createGen0AuctionWithTokens(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration, address[] allowedTokens) external;
265     function createPromoCutieWithGeneration(uint256 _genes, address _owner, uint16 _generation) external;
266     function createPromoCutieBulk(uint256[] _genes, address _owner, uint16 _generation) external;
267 }
268 
269 pragma solidity ^0.4.23;
270 
271 
272 pragma solidity ^0.4.23;
273 
274 pragma solidity ^0.4.23;
275 
276 // ----------------------------------------------------------------------------
277 contract ERC20 {
278 
279     // ERC Token Standard #223 Interface
280     // https://github.com/ethereum/EIPs/issues/223
281 
282     string public symbol;
283     string public  name;
284     uint8 public decimals;
285 
286     function transfer(address _to, uint _value, bytes _data) external returns (bool success);
287 
288     // approveAndCall
289     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
290 
291     // ERC Token Standard #20 Interface
292     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
293 
294 
295     function totalSupply() public view returns (uint);
296     function balanceOf(address tokenOwner) public view returns (uint balance);
297     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
298     function transfer(address to, uint tokens) public returns (bool success);
299     function approve(address spender, uint tokens) public returns (bool success);
300     function transferFrom(address from, address to, uint tokens) public returns (bool success);
301     event Transfer(address indexed from, address indexed to, uint tokens);
302     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
303 
304     // bulk operations
305     function transferBulk(address[] to, uint[] tokens) public;
306     function approveBulk(address[] spender, uint[] tokens) public;
307 }
308 
309 pragma solidity ^0.4.23;
310 
311 /// @title ERC-721 Non-Fungible Token Standard
312 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
313 ///  Note: the ERC-165 identifier for this interface is 0x6466353c
314 interface ERC721 /*is ERC165*/ {
315 
316     /// @notice Query if a contract implements an interface
317     /// @param interfaceID The interface identifier, as specified in ERC-165
318     /// @dev Interface identification is specified in ERC-165. This function
319     ///  uses less than 30,000 gas.
320     /// @return `true` if the contract implements `interfaceID` and
321     ///  `interfaceID` is not 0xffffffff, `false` otherwise
322     function supportsInterface(bytes4 interfaceID) external view returns (bool);
323 
324     /// @dev This emits when ownership of any NFT changes by any mechanism.
325     ///  This event emits when NFTs are created (`from` == 0) and destroyed
326     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
327     ///  may be created and assigned without emitting Transfer. At the time of
328     ///  any transfer, the approved address for that NFT (if any) is reset to none.
329     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
330 
331     /// @dev This emits when the approved address for an NFT is changed or
332     ///  reaffirmed. The zero address indicates there is no approved address.
333     ///  When a Transfer event emits, this also indicates that the approved
334     ///  address for that NFT (if any) is reset to none.
335     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
336 
337     /// @dev This emits when an operator is enabled or disabled for an owner.
338     ///  The operator can manage all NFTs of the owner.
339     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
340 
341     /// @notice Count all NFTs assigned to an owner
342     /// @dev NFTs assigned to the zero address are considered invalid, and this
343     ///  function throws for queries about the zero address.
344     /// @param _owner An address for whom to query the balance
345     /// @return The number of NFTs owned by `_owner`, possibly zero
346     function balanceOf(address _owner) external view returns (uint256);
347 
348     /// @notice Find the owner of an NFT
349     /// @param _tokenId The identifier for an NFT
350     /// @dev NFTs assigned to zero address are considered invalid, and queries
351     ///  about them do throw.
352     /// @return The address of the owner of the NFT
353     function ownerOf(uint256 _tokenId) external view returns (address);
354 
355     /// @notice Transfers the ownership of an NFT from one address to another address
356     /// @dev Throws unless `msg.sender` is the current owner, an authorized
357     ///  operator, or the approved address for this NFT. Throws if `_from` is
358     ///  not the current owner. Throws if `_to` is the zero address. Throws if
359     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
360     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
361     ///  `onERC721Received` on `_to` and throws if the return value is not
362     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
363     /// @param _from The current owner of the NFT
364     /// @param _to The new owner
365     /// @param _tokenId The NFT to transfer
366     /// @param data Additional data with no specified format, sent in call to `_to`
367     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
368     
369     /// @notice Transfers the ownership of an NFT from one address to another address
370     /// @dev This works identically to the other function with an extra data parameter,
371     ///  except this function just sets data to ""
372     /// @param _from The current owner of the NFT
373     /// @param _to The new owner
374     /// @param _tokenId The NFT to transfer
375     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
376 
377     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
378     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
379     ///  THEY MAY BE PERMANENTLY LOST
380     /// @dev Throws unless `msg.sender` is the current owner, an authorized
381     ///  operator, or the approved address for this NFT. Throws if `_from` is
382     ///  not the current owner. Throws if `_to` is the zero address. Throws if
383     ///  `_tokenId` is not a valid NFT.
384     /// @param _from The current owner of the NFT
385     /// @param _to The new owner
386     /// @param _tokenId The NFT to transfer
387     function transferFrom(address _from, address _to, uint256 _tokenId) external;
388 
389     /// @notice Set or reaffirm the approved address for an NFT
390     /// @dev The zero address indicates there is no approved address.
391     /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
392     ///  operator of the current owner.
393     /// @param _approved The new approved NFT controller
394     /// @param _tokenId The NFT to approve
395     function approve(address _approved, uint256 _tokenId) external;
396 
397     /// @notice Enable or disable approval for a third party ("operator") to manage
398     ///  all your asset.
399     /// @dev Emits the ApprovalForAll event
400     /// @param _operator Address to add to the set of authorized operators.
401     /// @param _approved True if the operators is approved, false to revoke approval
402     function setApprovalForAll(address _operator, bool _approved) external;
403 
404     /// @notice Get the approved address for a single NFT
405     /// @dev Throws if `_tokenId` is not a valid NFT
406     /// @param _tokenId The NFT to find the approved address for
407     /// @return The approved address for this NFT, or the zero address if there is none
408     function getApproved(uint256 _tokenId) external view returns (address);
409 
410     /// @notice Query if an address is an authorized operator for another address
411     /// @param _owner The address that owns the NFTs
412     /// @param _operator The address that acts on behalf of the owner
413     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
414     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
415 
416 
417    /// @notice A descriptive name for a collection of NFTs in this contract
418     function name() external pure returns (string _name);
419 
420     /// @notice An abbreviated name for NFTs in this contract
421     function symbol() external pure returns (string _symbol);
422 
423     
424     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
425     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
426     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
427     ///  Metadata JSON Schema".
428     function tokenURI(uint256 _tokenId) external view returns (string);
429 
430      /// @notice Count NFTs tracked by this contract
431     /// @return A count of valid NFTs tracked by this contract, where each one of
432     ///  them has an assigned and queryable owner not equal to the zero address
433     function totalSupply() external view returns (uint256);
434 
435     /// @notice Enumerate valid NFTs
436     /// @dev Throws if `_index` >= `totalSupply()`.
437     /// @param _index A counter less than `totalSupply()`
438     /// @return The token identifier for the `_index`th NFT,
439     ///  (sort order not specified)
440     function tokenByIndex(uint256 _index) external view returns (uint256);
441 
442     /// @notice Enumerate NFTs assigned to an owner
443     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
444     ///  `_owner` is the zero address, representing invalid NFTs.
445     /// @param _owner An address where we are interested in NFTs owned by them
446     /// @param _index A counter less than `balanceOf(_owner)`
447     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
448     ///   (sort order not specified)
449     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
450 
451     /// @notice Transfers a Cutie to another address. When transferring to a smart
452     ///  contract, ensure that it is aware of ERC-721 (or
453     ///  BlockchainCuties specifically), otherwise the Cutie may be lost forever.
454     /// @param _to The address of the recipient, can be a user or contract.
455     /// @param _cutieId The ID of the Cutie to transfer.
456     function transfer(address _to, uint256 _cutieId) external;
457 }
458 
459 pragma solidity ^0.4.23;
460 
461 pragma solidity ^0.4.23;
462 
463 
464 /**
465  * @title ERC165
466  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
467  */
468 interface ERC165 {
469 
470     /**
471      * @notice Query if a contract implements an interface
472      * @param _interfaceId The interface identifier, as specified in ERC-165
473      * @dev Interface identification is specified in ERC-165. This function
474      * uses less than 30,000 gas.
475      */
476     function supportsInterface(bytes4 _interfaceId)
477     external
478     view
479     returns (bool);
480 }
481 
482 
483 /**
484     @title ERC-1155 Multi Token Standard
485     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
486     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
487  */
488 interface IERC1155 /* is ERC165 */ {
489     /**
490         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
491         The `_operator` argument MUST be msg.sender.
492         The `_from` argument MUST be the address of the holder whose balance is decreased.
493         The `_to` argument MUST be the address of the recipient whose balance is increased.
494         The `_id` argument MUST be the token type being transferred.
495         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
496         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
497         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
498     */
499     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
500 
501     /**
502         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
503         The `_operator` argument MUST be msg.sender.
504         The `_from` argument MUST be the address of the holder whose balance is decreased.
505         The `_to` argument MUST be the address of the recipient whose balance is increased.
506         The `_ids` argument MUST be the list of tokens being transferred.
507         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
508         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
509         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
510     */
511     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
512 
513     /**
514         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
515     */
516     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
517 
518     /**
519         @dev MUST emit when the URI is updated for a token ID.
520         URIs are defined in RFC 3986.
521         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
522 
523         The URI value allows for ID substitution by clients. If the string {id} exists in any URI,
524         clients MUST replace this with the actual token ID in hexadecimal form.
525     */
526     event URI(string _value, uint256 indexed _id);
527 
528     /**
529         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
530         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
531         MUST revert if `_to` is the zero address.
532         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
533         MUST revert on any other error.
534         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
535         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
536         @param _from    Source address
537         @param _to      Target address
538         @param _id      ID of the token type
539         @param _value   Transfer amount
540         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
541     */
542     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes _data) external;
543 
544     /**
545         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
546         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
547         MUST revert if `_to` is the zero address.
548         MUST revert if length of `_ids` is not the same as length of `_values`.
549         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
550         MUST revert on any other error.
551         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
552         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
553         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
554         @param _from    Source address
555         @param _to      Target address
556         @param _ids     IDs of each token type (order and length must match _values array)
557         @param _values  Transfer amounts per token type (order and length must match _ids array)
558         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
559     */
560     function safeBatchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values, bytes _data) external;
561 
562     /**
563         @notice Get the balance of an account's Tokens.
564         @param _owner  The address of the token holder
565         @param _id     ID of the Token
566         @return        The _owner's balance of the Token type requested
567      */
568     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
569 
570     /**
571         @notice Get the balance of multiple account/token pairs
572         @param _owners The addresses of the token holders
573         @param _ids    ID of the Tokens
574         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
575      */
576     function balanceOfBatch(address[] _owners, uint256[] _ids) external view returns (uint256[] memory);
577 
578     /**
579         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
580         @dev MUST emit the ApprovalForAll event on success.
581         @param _operator  Address to add to the set of authorized operators
582         @param _approved  True if the operator is approved, false to revoke approval
583     */
584     function setApprovalForAll(address _operator, bool _approved) external;
585 
586     /**
587         @notice Queries the approval status of an operator for a given owner.
588         @param _owner     The owner of the Tokens
589         @param _operator  Address of authorized operator
590         @return           True if the operator is approved, false if not
591     */
592     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
593 }
594 
595 
596 contract Operators
597 {
598     mapping (address=>bool) ownerAddress;
599     mapping (address=>bool) operatorAddress;
600 
601     constructor() public
602     {
603         ownerAddress[msg.sender] = true;
604     }
605 
606     modifier onlyOwner()
607     {
608         require(ownerAddress[msg.sender]);
609         _;
610     }
611 
612     function isOwner(address _addr) public view returns (bool) {
613         return ownerAddress[_addr];
614     }
615 
616     function addOwner(address _newOwner) external onlyOwner {
617         require(_newOwner != address(0));
618 
619         ownerAddress[_newOwner] = true;
620     }
621 
622     function removeOwner(address _oldOwner) external onlyOwner {
623         delete(ownerAddress[_oldOwner]);
624     }
625 
626     modifier onlyOperator() {
627         require(isOperator(msg.sender));
628         _;
629     }
630 
631     function isOperator(address _addr) public view returns (bool) {
632         return operatorAddress[_addr] || ownerAddress[_addr];
633     }
634 
635     function addOperator(address _newOperator) external onlyOwner {
636         require(_newOperator != address(0));
637 
638         operatorAddress[_newOperator] = true;
639     }
640 
641     function removeOperator(address _oldOperator) external onlyOwner {
642         delete(operatorAddress[_oldOperator]);
643     }
644 
645     function withdrawERC20(ERC20 _tokenContract) external onlyOwner
646     {
647         uint256 balance = _tokenContract.balanceOf(address(this));
648         _tokenContract.transfer(msg.sender, balance);
649     }
650 
651     function approveERC721(ERC721 _tokenContract) external onlyOwner
652     {
653         _tokenContract.setApprovalForAll(msg.sender, true);
654     }
655 
656     function approveERC1155(IERC1155 _tokenContract) external onlyOwner
657     {
658         _tokenContract.setApprovalForAll(msg.sender, true);
659     }
660 
661     function withdrawEth() external onlyOwner
662     {
663         if (address(this).balance > 0)
664         {
665             msg.sender.transfer(address(this).balance);
666         }
667     }
668 }
669 
670 
671 
672 /**
673  * @title Pausable
674  * @dev Base contract which allows children to implement an emergency stop mechanism.
675  */
676 contract PausableOperators is Operators {
677     event Pause();
678     event Unpause();
679 
680     bool public paused = false;
681 
682 
683     /**
684      * @dev Modifier to make a function callable only when the contract is not paused.
685      */
686     modifier whenNotPaused() {
687         require(!paused);
688         _;
689     }
690 
691     /**
692      * @dev Modifier to make a function callable only when the contract is paused.
693      */
694     modifier whenPaused() {
695         require(paused);
696         _;
697     }
698 
699     /**
700      * @dev called by the owner to pause, triggers stopped state
701      */
702     function pause() onlyOwner whenNotPaused public {
703         paused = true;
704         emit Pause();
705     }
706 
707     /**
708      * @dev called by the owner to unpause, returns to normal state
709      */
710     function unpause() onlyOwner whenPaused public {
711         paused = false;
712         emit Unpause();
713     }
714 }
715 
716 
717 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
718 contract CutiePluginBase is PluginInterface, PausableOperators
719 {
720     function isPluginInterface() public pure returns (bool)
721     {
722         return true;
723     }
724 
725     // Reference to contract tracking NFT ownership
726     CutieCoreInterface public coreContract;
727     address public pluginsContract;
728 
729     // @dev Throws if called by any account other than the owner.
730     modifier onlyCore() {
731         require(msg.sender == address(coreContract));
732         _;
733     }
734 
735     modifier onlyPlugins() {
736         require(msg.sender == pluginsContract);
737         _;
738     }
739 
740     /// @dev Constructor creates a reference to the NFT ownership contract
741     ///  and verifies the owner cut is in the valid range.
742     /// @param _coreAddress - address of a deployed contract implementing
743     ///  the Nonfungible Interface.
744     function setup(address _coreAddress, address _pluginsContract) public onlyOwner {
745         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
746         require(candidateContract.isCutieCore());
747         coreContract = candidateContract;
748 
749         pluginsContract = _pluginsContract;
750     }
751 
752     /// @dev Returns true if the claimant owns the token.
753     /// @param _claimant - Address claiming to own the token.
754     /// @param _cutieId - ID of token whose ownership to verify.
755     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
756         return (coreContract.ownerOf(_cutieId) == _claimant);
757     }
758 
759     /// @dev Escrows the NFT, assigning ownership to this contract.
760     /// Throws if the escrow fails.
761     /// @param _owner - Current owner address of token to escrow.
762     /// @param _cutieId - ID of token whose approval to verify.
763     function _escrow(address _owner, uint40 _cutieId) internal {
764         // it will throw if transfer fails
765         coreContract.transferFrom(_owner, this, _cutieId);
766     }
767 
768     /// @dev Transfers an NFT owned by this contract to another address.
769     /// Returns true if the transfer succeeds.
770     /// @param _receiver - Address to transfer NFT to.
771     /// @param _cutieId - ID of token to transfer.
772     function _transfer(address _receiver, uint40 _cutieId) internal {
773         // it will throw if transfer fails
774         coreContract.transfer(_receiver, _cutieId);
775     }
776 
777     function withdraw() external
778     {
779         require(
780             isOwner(msg.sender) ||
781             msg.sender == address(coreContract) ||
782             msg.sender == pluginsContract
783         );
784         _withdraw();
785     }
786 
787     function _withdraw() internal
788     {
789         if (address(this).balance > 0)
790         {
791             address(coreContract).transfer(address(this).balance);
792         }
793     }
794 
795     function onRemove() public onlyPlugins
796     {
797         _withdraw();
798     }
799 
800     function run(uint40, uint256, address) public payable onlyCore
801     {
802         revert();
803     }
804 
805     function runSigned(uint40, uint256, address) external payable onlyCore
806     {
807         revert();
808     }
809 }
810 
811 
812 /// @dev Receives payments for payd features from players for Blockchain Cuties
813 /// @author https://BlockChainArchitect.io
814 contract CutieGenerator is CutiePluginBase
815 {
816     uint40[] public parents;
817     uint public parentIndex;
818     CutieCoreInterface public proxy;
819 
820     function setupGenerator(CutieCoreInterface _proxy, uint40 _parent1, uint40 _parent2) external onlyOwner
821     {
822         addParent(_parent1);
823         addParent(_parent2);
824         proxy = _proxy;
825     }
826 
827     function generateSingle(uint _genome, uint16 _generation, address _target) external onlyOperator returns (uint40 babyId)
828     {
829         return _generate(_genome, _generation, _target);
830     }
831 
832     function generateSingleBreed(uint _genome, uint16 _generation, address _target) external onlyOperator returns (uint40 babyId)
833     {
834         return _generateBreed(_genome, _generation, _target);
835     }
836 
837     function generateSinglePromo(uint _genome, uint16 _generation, address _target) external onlyOperator returns (uint40 babyId)
838     {
839         require(_generation == 0);
840         return _generatePromo(_genome, _target);
841     }
842 
843     function generate(uint _genome, uint16 _generation, address[] _target) external onlyOperator
844     {
845         for (uint i = 0; i < _target.length; i++)
846         {
847             _generate(_genome, _generation, _target[i]);
848         }
849     }
850 
851     function _generate(uint _genome, uint16 _generation, address _target) internal returns (uint40 babyId)
852     {
853         if (_generation == 0)
854         {
855             return _generatePromo(_genome, _target);
856         }
857         else
858         {
859             return uint40(_generateBreed(_genome, _generation, _target));
860         }
861     }
862 
863     function _generatePromo(uint _genome, address _target) internal returns (uint40 babyId)
864     {
865         proxy.createPromoCutie(_genome, _target);
866         return uint40(coreContract.totalSupply());
867     }
868 
869     function addParent(uint40 _newParent) public onlyOwner
870     {
871         parents.push(_newParent);
872     }
873 
874     function removeParent(uint40 _index) external onlyOwner
875     {
876         parents[_index] = parents[parents.length-1];
877         parents.length--;
878     }
879 
880     function addParents(uint40[] _newParents) external onlyOwner
881     {
882         for (uint i = 0; i < _newParents.length; i++)
883         {
884             parents.push(_newParents[i]);
885         }
886     }
887 
888     function _getNextParent() internal returns (uint40 parent)
889     {
890         parent = parents[parentIndex];
891         parentIndex++;
892         if (parentIndex >= parents.length)
893         {
894             parentIndex = 0;
895         }
896     }
897 
898     function _generateBreed(uint _genome, uint16 _generation, address _target) internal returns (uint40 babyId)
899     {
900         uint40 momId = _getNextParent();
901         uint40 dadId = _getNextParent();
902 
903         coreContract.changeCooldownEndTime(momId, 0);
904         coreContract.changeCooldownEndTime(dadId, 0);
905         coreContract.changeCooldownIndex(momId, 0);
906         coreContract.changeCooldownIndex(dadId, 0);
907 
908         babyId = coreContract.breedWith(momId, dadId);
909 
910         coreContract.changeCooldownIndex(babyId, _generation);
911         coreContract.changeGeneration(babyId, _generation);
912 
913         coreContract.changeGenes(babyId, _genome);
914 
915         coreContract.transfer(_target, babyId);
916 
917         return babyId;
918     }
919 
920     function recreate(uint40 _cutieId, uint _genome, uint16 _generation) external onlyOwner
921     {
922         coreContract.changeGeneration(_cutieId, _generation);
923         coreContract.changeGenes(_cutieId, _genome);
924     }
925 
926     function recoverCutie(uint40 _cutieId) external onlyOwner
927     {
928         coreContract.transfer(msg.sender, _cutieId);
929     }
930 }