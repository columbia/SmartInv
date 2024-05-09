1 pragma solidity ^0.4.23;
2 
3 pragma solidity ^0.4.23;
4 
5 interface BlockchainCutiesERC1155Interface
6 {
7     function mintNonFungibleSingleShort(uint128 _type, address _to) external;
8     function mintNonFungibleSingle(uint256 _type, address _to) external;
9     function mintNonFungibleShort(uint128 _type, address[] _to) external;
10     function mintNonFungible(uint256 _type, address[] _to) external;
11     function mintFungibleSingle(uint256 _id, address _to, uint256 _quantity) external;
12     function mintFungible(uint256 _id, address[] _to, uint256[] _quantities) external;
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
25     function proxyTransfer721(address _from, address _to, uint256 _tokenId, bytes _data) external;
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
48     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes _data) external;
49 }
50 
51 pragma solidity ^0.4.23;
52 
53 
54 pragma solidity ^0.4.23;
55 
56 pragma solidity ^0.4.23;
57 
58 // ----------------------------------------------------------------------------
59 contract ERC20 {
60 
61     // ERC Token Standard #223 Interface
62     // https://github.com/ethereum/EIPs/issues/223
63 
64     string public symbol;
65     string public  name;
66     uint8 public decimals;
67 
68     function transfer(address _to, uint _value, bytes _data) external returns (bool success);
69 
70     // approveAndCall
71     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
72 
73     // ERC Token Standard #20 Interface
74     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
75 
76 
77     function totalSupply() public view returns (uint);
78     function balanceOf(address tokenOwner) public view returns (uint balance);
79     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
80     function transfer(address to, uint tokens) public returns (bool success);
81     function approve(address spender, uint tokens) public returns (bool success);
82     function transferFrom(address from, address to, uint tokens) public returns (bool success);
83     event Transfer(address indexed from, address indexed to, uint tokens);
84     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
85 
86     // bulk operations
87     function transferBulk(address[] to, uint[] tokens) public;
88     function approveBulk(address[] spender, uint[] tokens) public;
89 }
90 
91 pragma solidity ^0.4.23;
92 
93 /// @title ERC-721 Non-Fungible Token Standard
94 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
95 ///  Note: the ERC-165 identifier for this interface is 0x6466353c
96 interface ERC721 /*is ERC165*/ {
97 
98     /// @notice Query if a contract implements an interface
99     /// @param interfaceID The interface identifier, as specified in ERC-165
100     /// @dev Interface identification is specified in ERC-165. This function
101     ///  uses less than 30,000 gas.
102     /// @return `true` if the contract implements `interfaceID` and
103     ///  `interfaceID` is not 0xffffffff, `false` otherwise
104     function supportsInterface(bytes4 interfaceID) external view returns (bool);
105 
106     /// @dev This emits when ownership of any NFT changes by any mechanism.
107     ///  This event emits when NFTs are created (`from` == 0) and destroyed
108     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
109     ///  may be created and assigned without emitting Transfer. At the time of
110     ///  any transfer, the approved address for that NFT (if any) is reset to none.
111     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
112 
113     /// @dev This emits when the approved address for an NFT is changed or
114     ///  reaffirmed. The zero address indicates there is no approved address.
115     ///  When a Transfer event emits, this also indicates that the approved
116     ///  address for that NFT (if any) is reset to none.
117     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
118 
119     /// @dev This emits when an operator is enabled or disabled for an owner.
120     ///  The operator can manage all NFTs of the owner.
121     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
122 
123     /// @notice Count all NFTs assigned to an owner
124     /// @dev NFTs assigned to the zero address are considered invalid, and this
125     ///  function throws for queries about the zero address.
126     /// @param _owner An address for whom to query the balance
127     /// @return The number of NFTs owned by `_owner`, possibly zero
128     function balanceOf(address _owner) external view returns (uint256);
129 
130     /// @notice Find the owner of an NFT
131     /// @param _tokenId The identifier for an NFT
132     /// @dev NFTs assigned to zero address are considered invalid, and queries
133     ///  about them do throw.
134     /// @return The address of the owner of the NFT
135     function ownerOf(uint256 _tokenId) external view returns (address);
136 
137     /// @notice Transfers the ownership of an NFT from one address to another address
138     /// @dev Throws unless `msg.sender` is the current owner, an authorized
139     ///  operator, or the approved address for this NFT. Throws if `_from` is
140     ///  not the current owner. Throws if `_to` is the zero address. Throws if
141     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
142     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
143     ///  `onERC721Received` on `_to` and throws if the return value is not
144     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
145     /// @param _from The current owner of the NFT
146     /// @param _to The new owner
147     /// @param _tokenId The NFT to transfer
148     /// @param data Additional data with no specified format, sent in call to `_to`
149     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
150     
151     /// @notice Transfers the ownership of an NFT from one address to another address
152     /// @dev This works identically to the other function with an extra data parameter,
153     ///  except this function just sets data to ""
154     /// @param _from The current owner of the NFT
155     /// @param _to The new owner
156     /// @param _tokenId The NFT to transfer
157     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
158 
159     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
160     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
161     ///  THEY MAY BE PERMANENTLY LOST
162     /// @dev Throws unless `msg.sender` is the current owner, an authorized
163     ///  operator, or the approved address for this NFT. Throws if `_from` is
164     ///  not the current owner. Throws if `_to` is the zero address. Throws if
165     ///  `_tokenId` is not a valid NFT.
166     /// @param _from The current owner of the NFT
167     /// @param _to The new owner
168     /// @param _tokenId The NFT to transfer
169     function transferFrom(address _from, address _to, uint256 _tokenId) external;
170 
171     /// @notice Set or reaffirm the approved address for an NFT
172     /// @dev The zero address indicates there is no approved address.
173     /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
174     ///  operator of the current owner.
175     /// @param _approved The new approved NFT controller
176     /// @param _tokenId The NFT to approve
177     function approve(address _approved, uint256 _tokenId) external;
178 
179     /// @notice Enable or disable approval for a third party ("operator") to manage
180     ///  all your asset.
181     /// @dev Emits the ApprovalForAll event
182     /// @param _operator Address to add to the set of authorized operators.
183     /// @param _approved True if the operators is approved, false to revoke approval
184     function setApprovalForAll(address _operator, bool _approved) external;
185 
186     /// @notice Get the approved address for a single NFT
187     /// @dev Throws if `_tokenId` is not a valid NFT
188     /// @param _tokenId The NFT to find the approved address for
189     /// @return The approved address for this NFT, or the zero address if there is none
190     function getApproved(uint256 _tokenId) external view returns (address);
191 
192     /// @notice Query if an address is an authorized operator for another address
193     /// @param _owner The address that owns the NFTs
194     /// @param _operator The address that acts on behalf of the owner
195     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
196     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
197 
198 
199    /// @notice A descriptive name for a collection of NFTs in this contract
200     function name() external pure returns (string _name);
201 
202     /// @notice An abbreviated name for NFTs in this contract
203     function symbol() external pure returns (string _symbol);
204 
205     
206     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
207     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
208     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
209     ///  Metadata JSON Schema".
210     function tokenURI(uint256 _tokenId) external view returns (string);
211 
212      /// @notice Count NFTs tracked by this contract
213     /// @return A count of valid NFTs tracked by this contract, where each one of
214     ///  them has an assigned and queryable owner not equal to the zero address
215     function totalSupply() external view returns (uint256);
216 
217     /// @notice Enumerate valid NFTs
218     /// @dev Throws if `_index` >= `totalSupply()`.
219     /// @param _index A counter less than `totalSupply()`
220     /// @return The token identifier for the `_index`th NFT,
221     ///  (sort order not specified)
222     function tokenByIndex(uint256 _index) external view returns (uint256);
223 
224     /// @notice Enumerate NFTs assigned to an owner
225     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
226     ///  `_owner` is the zero address, representing invalid NFTs.
227     /// @param _owner An address where we are interested in NFTs owned by them
228     /// @param _index A counter less than `balanceOf(_owner)`
229     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
230     ///   (sort order not specified)
231     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
232 
233     /// @notice Transfers a Cutie to another address. When transferring to a smart
234     ///  contract, ensure that it is aware of ERC-721 (or
235     ///  BlockchainCuties specifically), otherwise the Cutie may be lost forever.
236     /// @param _to The address of the recipient, can be a user or contract.
237     /// @param _cutieId The ID of the Cutie to transfer.
238     function transfer(address _to, uint256 _cutieId) external;
239 }
240 
241 pragma solidity ^0.4.23;
242 
243 pragma solidity ^0.4.23;
244 
245 
246 /**
247  * @title ERC165
248  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
249  */
250 interface ERC165 {
251 
252     /**
253      * @notice Query if a contract implements an interface
254      * @param _interfaceId The interface identifier, as specified in ERC-165
255      * @dev Interface identification is specified in ERC-165. This function
256      * uses less than 30,000 gas.
257      */
258     function supportsInterface(bytes4 _interfaceId)
259     external
260     view
261     returns (bool);
262 }
263 
264 
265 /**
266     @title ERC-1155 Multi Token Standard
267     @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
268     Note: The ERC-165 identifier for this interface is 0xd9b67a26.
269  */
270 interface IERC1155 /* is ERC165 */ {
271     /**
272         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
273         The `_operator` argument MUST be msg.sender.
274         The `_from` argument MUST be the address of the holder whose balance is decreased.
275         The `_to` argument MUST be the address of the recipient whose balance is increased.
276         The `_id` argument MUST be the token type being transferred.
277         The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
278         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
279         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
280     */
281     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
282 
283     /**
284         @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
285         The `_operator` argument MUST be msg.sender.
286         The `_from` argument MUST be the address of the holder whose balance is decreased.
287         The `_to` argument MUST be the address of the recipient whose balance is increased.
288         The `_ids` argument MUST be the list of tokens being transferred.
289         The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
290         When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
291         When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
292     */
293     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
294 
295     /**
296         @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absense of an event assumes disabled).
297     */
298     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
299 
300     /**
301         @dev MUST emit when the URI is updated for a token ID.
302         URIs are defined in RFC 3986.
303         The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
304 
305         The URI value allows for ID substitution by clients. If the string {id} exists in any URI,
306         clients MUST replace this with the actual token ID in hexadecimal form.
307     */
308     event URI(string _value, uint256 indexed _id);
309 
310     /**
311         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
312         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
313         MUST revert if `_to` is the zero address.
314         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
315         MUST revert on any other error.
316         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
317         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
318         @param _from    Source address
319         @param _to      Target address
320         @param _id      ID of the token type
321         @param _value   Transfer amount
322         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
323     */
324     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes _data) external;
325 
326     /**
327         @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
328         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
329         MUST revert if `_to` is the zero address.
330         MUST revert if length of `_ids` is not the same as length of `_values`.
331         MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
332         MUST revert on any other error.
333         MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
334         Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
335         After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
336         @param _from    Source address
337         @param _to      Target address
338         @param _ids     IDs of each token type (order and length must match _values array)
339         @param _values  Transfer amounts per token type (order and length must match _ids array)
340         @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
341     */
342     function safeBatchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values, bytes _data) external;
343 
344     /**
345         @notice Get the balance of an account's Tokens.
346         @param _owner  The address of the token holder
347         @param _id     ID of the Token
348         @return        The _owner's balance of the Token type requested
349      */
350     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
351 
352     /**
353         @notice Get the balance of multiple account/token pairs
354         @param _owners The addresses of the token holders
355         @param _ids    ID of the Tokens
356         @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
357      */
358     function balanceOfBatch(address[] _owners, uint256[] _ids) external view returns (uint256[] memory);
359 
360     /**
361         @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
362         @dev MUST emit the ApprovalForAll event on success.
363         @param _operator  Address to add to the set of authorized operators
364         @param _approved  True if the operator is approved, false to revoke approval
365     */
366     function setApprovalForAll(address _operator, bool _approved) external;
367 
368     /**
369         @notice Queries the approval status of an operator for a given owner.
370         @param _owner     The owner of the Tokens
371         @param _operator  Address of authorized operator
372         @return           True if the operator is approved, false if not
373     */
374     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
375 }
376 
377 
378 contract Operators
379 {
380     mapping (address=>bool) ownerAddress;
381     mapping (address=>bool) operatorAddress;
382 
383     constructor() public
384     {
385         ownerAddress[msg.sender] = true;
386     }
387 
388     modifier onlyOwner()
389     {
390         require(ownerAddress[msg.sender]);
391         _;
392     }
393 
394     function isOwner(address _addr) public view returns (bool) {
395         return ownerAddress[_addr];
396     }
397 
398     function addOwner(address _newOwner) external onlyOwner {
399         require(_newOwner != address(0));
400 
401         ownerAddress[_newOwner] = true;
402     }
403 
404     function removeOwner(address _oldOwner) external onlyOwner {
405         delete(ownerAddress[_oldOwner]);
406     }
407 
408     modifier onlyOperator() {
409         require(isOperator(msg.sender));
410         _;
411     }
412 
413     function isOperator(address _addr) public view returns (bool) {
414         return operatorAddress[_addr] || ownerAddress[_addr];
415     }
416 
417     function addOperator(address _newOperator) external onlyOwner {
418         require(_newOperator != address(0));
419 
420         operatorAddress[_newOperator] = true;
421     }
422 
423     function removeOperator(address _oldOperator) external onlyOwner {
424         delete(operatorAddress[_oldOperator]);
425     }
426 
427     function withdrawERC20(ERC20 _tokenContract) external onlyOwner
428     {
429         uint256 balance = _tokenContract.balanceOf(address(this));
430         _tokenContract.transfer(msg.sender, balance);
431     }
432 
433     function approveERC721(ERC721 _tokenContract) external onlyOwner
434     {
435         _tokenContract.setApprovalForAll(msg.sender, true);
436     }
437 
438     function approveERC1155(IERC1155 _tokenContract) external onlyOwner
439     {
440         _tokenContract.setApprovalForAll(msg.sender, true);
441     }
442 
443     function withdrawEth() external onlyOwner
444     {
445         if (address(this).balance > 0)
446         {
447             msg.sender.transfer(address(this).balance);
448         }
449     }
450 }
451 
452 
453 
454 /**
455  * @title Pausable
456  * @dev Base contract which allows children to implement an emergency stop mechanism.
457  */
458 contract PausableOperators is Operators {
459     event Pause();
460     event Unpause();
461 
462     bool public paused = false;
463 
464 
465     /**
466      * @dev Modifier to make a function callable only when the contract is not paused.
467      */
468     modifier whenNotPaused() {
469         require(!paused);
470         _;
471     }
472 
473     /**
474      * @dev Modifier to make a function callable only when the contract is paused.
475      */
476     modifier whenPaused() {
477         require(paused);
478         _;
479     }
480 
481     /**
482      * @dev called by the owner to pause, triggers stopped state
483      */
484     function pause() onlyOwner whenNotPaused public {
485         paused = true;
486         emit Pause();
487     }
488 
489     /**
490      * @dev called by the owner to unpause, returns to normal state
491      */
492     function unpause() onlyOwner whenPaused public {
493         paused = false;
494         emit Unpause();
495     }
496 }
497 
498 pragma solidity ^0.4.23;
499 
500 interface CutieGeneratorInterface
501 {
502     function generate(uint _genome, uint16 _generation, address[] _target) external;
503     function generateSingle(uint _genome, uint16 _generation, address _target) external returns (uint40 babyId);
504 }
505 
506 pragma solidity ^0.4.23;
507 
508 /**
509     Note: The ERC-165 identifier for this interface is 0x43b236a2.
510 */
511 interface IERC1155TokenReceiver {
512 
513     /**
514         @notice Handle the receipt of a single ERC1155 token type.
515         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
516         This function MUST return `bytes4(keccak256("accept_erc1155_tokens()"))` (i.e. 0x4dc21a2f) if it accepts the transfer.
517         This function MUST revert if it rejects the transfer.
518         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
519         @param _operator  The address which initiated the transfer (i.e. msg.sender)
520         @param _from      The address which previously owned the token
521         @param _id        The id of the token being transferred
522         @param _value     The amount of tokens being transferred
523         @param _data      Additional data with no specified format
524         @return           `bytes4(keccak256("accept_erc1155_tokens()"))`
525     */
526     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes _data) external returns(bytes4);
527 
528     /**
529         @notice Handle the receipt of multiple ERC1155 token types.
530         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
531         This function MUST return `bytes4(keccak256("accept_batch_erc1155_tokens()"))` (i.e. 0xac007889) if it accepts the transfer(s).
532         This function MUST revert if it rejects the transfer(s).
533         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
534         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
535         @param _from      The address which previously owned the token
536         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
537         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
538         @param _data      Additional data with no specified format
539         @return           `bytes4(keccak256("accept_batch_erc1155_tokens()"))`
540     */
541     function onERC1155BatchReceived(address _operator, address _from, uint256[] _ids, uint256[] _values, bytes _data) external returns(bytes4);
542 
543     /**
544         @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
545         @dev This function MUST return `bytes4(keccak256("isERC1155TokenReceiver()"))` (i.e. 0x0d912442).
546         This function MUST NOT consume more than 5,000 gas.
547         @return           `bytes4(keccak256("isERC1155TokenReceiver()"))`
548     */
549     function isERC1155TokenReceiver() external view returns (bytes4);
550 }
551 
552 pragma solidity ^0.4.23;
553 
554 /// @title BlockchainCuties Presale Contract
555 /// @author https://BlockChainArchitect.io
556 interface PresaleInterface
557 {
558     function bidWithPlugin(uint32 lotId, address purchaser, uint valueForEvent, address tokenForEvent) external payable;
559     function bidWithPluginReferrer(uint32 lotId, address purchaser, uint valueForEvent, address tokenForEvent, address referrer) external payable;
560 
561     function getLotNftFixedRewards(uint32 lotId) external view returns (
562         uint256 rewardsNFTFixedKind,
563         uint256 rewardsNFTFixedIndex
564     );
565     function getLotToken1155Rewards(uint32 lotId) external view returns (
566         uint256[10] memory rewardsToken1155tokenId,
567         uint256[10] memory rewardsToken1155count
568     );
569     function getLotCutieRewards(uint32 lotId) external view returns (
570         uint256[10] memory rewardsCutieGenome,
571         uint256[10] memory rewardsCutieGeneration
572     );
573     function getLotNftMintRewards(uint32 lotId) external view returns (
574         uint256[10] memory rewardsNFTMintNftKind
575     );
576 
577     function getLotToken1155RewardByIndex(uint32 lotId, uint index) external view returns (
578         uint256 rewardsToken1155tokenId,
579         uint256 rewardsToken1155count
580     );
581     function getLotCutieRewardByIndex(uint32 lotId, uint index) external view returns (
582         uint256 rewardsCutieGenome,
583         uint256 rewardsCutieGeneration
584     );
585     function getLotNftMintRewardByIndex(uint32 lotId, uint index) external view returns (
586         uint256 rewardsNFTMintNftKind
587     );
588 
589     function getLotToken1155RewardCount(uint32 lotId) external view returns (uint);
590     function getLotCutieRewardCount(uint32 lotId) external view returns (uint);
591     function getLotNftMintRewardCount(uint32 lotId) external view returns (uint);
592 
593     function getLotRewards(uint32 lotId) external view returns (
594         uint256[5] memory rewardsToken1155tokenId,
595         uint256[5] memory rewardsToken1155count,
596         uint256[5] memory rewardsNFTMintNftKind,
597         uint256[5] memory rewardsNFTFixedKind,
598         uint256[5] memory rewardsNFTFixedIndex,
599         uint256[5] memory rewardsCutieGenome,
600         uint256[5] memory rewardsCutieGeneration
601     );
602 }
603 
604 
605 /// @title BlockchainCuties Presale
606 /// @author https://BlockChainArchitect.io
607 contract Presale is PresaleInterface, PausableOperators, IERC1155TokenReceiver
608 {
609     struct RewardToken1155
610     {
611         uint tokenId;
612         uint count;
613     }
614 
615     struct RewardNFT
616     {
617         uint128 nftKind;
618         uint128 tokenIndex;
619     }
620 
621     struct RewardCutie
622     {
623         uint genome;
624         uint16 generation;
625     }
626 
627     uint32 constant RATE_SIGN = 0;
628     uint32 constant NATIVE = 1;
629 
630     struct Lot
631     {
632         RewardToken1155[] rewardsToken1155; // stackable
633         uint128[] rewardsNftMint; // stackable
634         RewardNFT[] rewardsNftFixed; // non stackable - one element per lot
635         RewardCutie[] rewardsCutie; // stackable
636         uint128 price;
637         uint128 leftCount;
638         uint128 priceMul;
639         uint128 priceAdd;
640         uint32 expireTime;
641         uint32 lotKind;
642     }
643 
644     mapping (uint32 => Lot) public lots;
645 
646     mapping (address => uint) public referrers;
647 
648     BlockchainCutiesERC1155Interface public token1155;
649     CutieGeneratorInterface public cutieGenerator;
650     address public signerAddress;
651 
652     event Bid(address indexed purchaser, uint32 indexed lotId, uint value, address indexed token);
653     event BidReferrer(address indexed purchaser, uint32 indexed lotId, uint value, address token, address indexed referrer);
654     event LotChange(uint32 indexed lotId);
655 
656     function setToken1155(BlockchainCutiesERC1155Interface _token1155) onlyOwner external
657     {
658         token1155 = _token1155;
659     }
660 
661     function setCutieGenerator(CutieGeneratorInterface _cutieGenerator) onlyOwner external
662     {
663         cutieGenerator = _cutieGenerator;
664     }
665 
666     function setLot(uint32 lotId, uint128 price, uint128 count, uint32 expireTime, uint128 priceMul, uint128 priceAdd, uint32 lotKind) external onlyOperator
667     {
668         delete lots[lotId];
669         Lot storage lot = lots[lotId];
670         lot.price = price;
671         lot.leftCount = count;
672         lot.expireTime = expireTime;
673         lot.priceMul = priceMul;
674         lot.priceAdd = priceAdd;
675         lot.lotKind = lotKind;
676         emit LotChange(lotId);
677     }
678 
679     function setLotLeftCount(uint32 lotId, uint128 count) external onlyOperator
680     {
681         Lot storage lot = lots[lotId];
682         lot.leftCount = count;
683         emit LotChange(lotId);
684     }
685 
686     function setExpireTime(uint32 lotId, uint32 expireTime) external onlyOperator
687     {
688         Lot storage lot = lots[lotId];
689         lot.expireTime = expireTime;
690         emit LotChange(lotId);
691     }
692 
693     function setPrice(uint32 lotId, uint128 price) external onlyOperator
694     {
695         lots[lotId].price = price;
696         emit LotChange(lotId);
697     }
698 
699     function deleteLot(uint32 lotId) external onlyOperator
700     {
701         delete lots[lotId];
702         emit LotChange(lotId);
703     }
704 
705     function addRewardToken1155(uint32 lotId, uint tokenId, uint count) external onlyOperator
706     {
707         lots[lotId].rewardsToken1155.push(RewardToken1155(tokenId, count));
708         emit LotChange(lotId);
709     }
710 
711     function setRewardToken1155(uint32 lotId, uint tokenId, uint count) external onlyOperator
712     {
713         delete lots[lotId].rewardsToken1155;
714         lots[lotId].rewardsToken1155.push(RewardToken1155(tokenId, count));
715         emit LotChange(lotId);
716     }
717 
718     function setRewardNftFixed(uint32 lotId, uint128 nftType, uint128 tokenIndex) external onlyOperator
719     {
720         delete lots[lotId].rewardsNftFixed;
721         lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex));
722         emit LotChange(lotId);
723     }
724 
725     function addRewardNftFixed(uint32 lotId, uint128 nftType, uint128 tokenIndex) external onlyOperator
726     {
727         lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex));
728         emit LotChange(lotId);
729     }
730 
731     function addRewardNftFixedBulk(uint32 lotId, uint128 nftType, uint128[] tokenIndex) external onlyOperator
732     {
733         for (uint i = 0; i < tokenIndex.length; i++)
734         {
735             lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex[i]));
736         }
737         emit LotChange(lotId);
738     }
739 
740     function addRewardNftMint(uint32 lotId, uint128 nftType) external onlyOperator
741     {
742         lots[lotId].rewardsNftMint.push(nftType);
743         emit LotChange(lotId);
744     }
745 
746     function setRewardNftMint(uint32 lotId, uint128 nftType) external onlyOperator
747     {
748         delete lots[lotId].rewardsNftMint;
749         lots[lotId].rewardsNftMint.push(nftType);
750         emit LotChange(lotId);
751     }
752 
753     function addRewardCutie(uint32 lotId, uint genome, uint16 generation) external onlyOperator
754     {
755         lots[lotId].rewardsCutie.push(RewardCutie(genome, generation));
756         emit LotChange(lotId);
757     }
758 
759     function setRewardCutie(uint32 lotId, uint genome, uint16 generation) external onlyOperator
760     {
761         delete lots[lotId].rewardsCutie;
762         lots[lotId].rewardsCutie.push(RewardCutie(genome, generation));
763         emit LotChange(lotId);
764     }
765 
766     function isAvailable(uint32 lotId) public view returns (bool)
767     {
768         Lot storage lot = lots[lotId];
769         return
770             lot.leftCount > 0 && lot.expireTime >= now;
771     }
772 
773     function getLot(uint32 lotId) external view returns (
774         uint256 price,
775         uint256 left,
776         uint256 expireTime,
777         uint256 lotKind
778     )
779     {
780         Lot storage p = lots[lotId];
781         price = p.price;
782         left = p.leftCount;
783         expireTime = p.expireTime;
784         lotKind = p.lotKind;
785     }
786 
787     function getLotRewards(uint32 lotId) external view returns (
788             uint256[5] memory rewardsToken1155tokenId,
789             uint256[5] memory rewardsToken1155count,
790             uint256[5] memory rewardsNFTMintNftKind,
791             uint256[5] memory rewardsNFTFixedKind,
792             uint256[5] memory rewardsNFTFixedIndex,
793             uint256[5] memory rewardsCutieGenome,
794             uint256[5] memory rewardsCutieGeneration
795         )
796     {
797         Lot storage p = lots[lotId];
798         uint i;
799         for (i = 0; i < p.rewardsToken1155.length; i++)
800         {
801             if (i >= 5) break;
802             rewardsToken1155tokenId[i] = p.rewardsToken1155[i].tokenId;
803             rewardsToken1155count[i] = p.rewardsToken1155[i].count;
804         }
805         for (i = 0; i < p.rewardsNftMint.length; i++)
806         {
807             if (i >= 5) break;
808             rewardsNFTMintNftKind[i] = p.rewardsNftMint[i];
809         }
810         for (i = 0; i < p.rewardsNftFixed.length; i++)
811         {
812             if (i >= 5) break;
813             rewardsNFTFixedKind[i] = p.rewardsNftFixed[i].nftKind;
814             rewardsNFTFixedIndex[i] = p.rewardsNftFixed[i].tokenIndex;
815         }
816         for (i = 0; i < p.rewardsCutie.length; i++)
817         {
818             if (i >= 5) break;
819             rewardsCutieGenome[i] = p.rewardsCutie[i].genome;
820             rewardsCutieGeneration[i] = p.rewardsCutie[i].generation;
821         }
822     }
823 
824     function getLotNftFixedRewards(uint32 lotId) external view returns (
825         uint256 rewardsNFTFixedKind,
826         uint256 rewardsNFTFixedIndex
827     )
828     {
829         Lot storage p = lots[lotId];
830 
831         if (p.rewardsNftFixed.length > 0)
832         {
833             rewardsNFTFixedKind = p.rewardsNftFixed[p.rewardsNftFixed.length-1].nftKind;
834             rewardsNFTFixedIndex = p.rewardsNftFixed[p.rewardsNftFixed.length-1].tokenIndex;
835         }
836     }
837 
838     function getLotToken1155Rewards(uint32 lotId) external view returns (
839         uint256[10] memory rewardsToken1155tokenId,
840         uint256[10] memory rewardsToken1155count
841     )
842     {
843         Lot storage p = lots[lotId];
844         for (uint i = 0; i < p.rewardsToken1155.length; i++)
845         {
846             if (i >= 10) break;
847             rewardsToken1155tokenId[i] = p.rewardsToken1155[i].tokenId;
848             rewardsToken1155count[i] = p.rewardsToken1155[i].count;
849         }
850     }
851 
852     function getLotCutieRewards(uint32 lotId) external view returns (
853         uint256[10] memory rewardsCutieGenome,
854         uint256[10] memory rewardsCutieGeneration
855     )
856     {
857         Lot storage p = lots[lotId];
858         for (uint i = 0; i < p.rewardsCutie.length; i++)
859         {
860             if (i >= 10) break;
861             rewardsCutieGenome[i] = p.rewardsCutie[i].genome;
862             rewardsCutieGeneration[i] = p.rewardsCutie[i].generation;
863         }
864     }
865 
866     function getLotNftMintRewards(uint32 lotId) external view returns (
867         uint256[10] memory rewardsNFTMintNftKind
868     )
869     {
870         Lot storage p = lots[lotId];
871         for (uint i = 0; i < p.rewardsNftMint.length; i++)
872         {
873             if (i >= 10) break;
874             rewardsNFTMintNftKind[i] = p.rewardsNftMint[i];
875         }
876     }
877 
878     function getLotToken1155RewardByIndex(uint32 lotId, uint index) external view returns (
879         uint256 rewardsToken1155tokenId,
880         uint256 rewardsToken1155count
881     )
882     {
883         Lot storage p = lots[lotId];
884         rewardsToken1155tokenId = p.rewardsToken1155[index].tokenId;
885         rewardsToken1155count = p.rewardsToken1155[index].count;
886     }
887 
888     function getLotCutieRewardByIndex(uint32 lotId, uint index) external view returns (
889         uint256 rewardsCutieGenome,
890         uint256 rewardsCutieGeneration
891     )
892     {
893         Lot storage p = lots[lotId];
894         rewardsCutieGenome = p.rewardsCutie[index].genome;
895         rewardsCutieGeneration = p.rewardsCutie[index].generation;
896     }
897 
898     function getLotNftMintRewardByIndex(uint32 lotId, uint index) external view returns (
899         uint256 rewardsNFTMintNftKind
900     )
901     {
902         Lot storage p = lots[lotId];
903         rewardsNFTMintNftKind = p.rewardsNftMint[index];
904     }
905 
906     function getLotToken1155RewardCount(uint32 lotId) external view returns (uint)
907     {
908         return lots[lotId].rewardsToken1155.length;
909     }
910     function getLotCutieRewardCount(uint32 lotId) external view returns (uint)
911     {
912         return lots[lotId].rewardsCutie.length;
913     }
914     function getLotNftMintRewardCount(uint32 lotId) external view returns (uint)
915     {
916         return lots[lotId].rewardsNftMint.length;
917     }
918 
919     function deleteRewards(uint32 lotId) external onlyOwner
920     {
921         delete lots[lotId].rewardsToken1155;
922         delete lots[lotId].rewardsNftMint;
923         delete lots[lotId].rewardsNftFixed;
924         delete lots[lotId].rewardsCutie;
925         emit LotChange(lotId);
926     }
927 
928     function bidWithPlugin(uint32 lotId, address purchaser, uint valueForEvent, address tokenForEvent) external payable onlyOperator
929     {
930         _bid(lotId, purchaser, valueForEvent, tokenForEvent, address(0x0));
931     }
932 
933     function bidWithPluginReferrer(uint32 lotId, address purchaser, uint valueForEvent, address tokenForEvent, address referrer) external payable onlyOperator
934     {
935         _bid(lotId, purchaser, valueForEvent, tokenForEvent, referrer);
936     }
937 
938     function _bid(uint32 lotId, address purchaser, uint valueForEvent, address tokenForEvent, address referrer) internal whenNotPaused
939     {
940         Lot storage p = lots[lotId];
941         require(isAvailable(lotId), "Lot is not available");
942 
943         if (referrer == address(0x0))
944         {
945             emit BidReferrer(purchaser, lotId, valueForEvent, tokenForEvent, referrer);
946         }
947         else
948         {
949             emit Bid(purchaser, lotId, valueForEvent, tokenForEvent);
950         }
951 
952         p.leftCount--;
953         p.price += uint128(uint256(p.price)*p.priceMul / 1000000);
954         p.price += p.priceAdd;
955 
956         issueRewards(p, purchaser);
957 
958         if (referrers[referrer] > 0)
959         {
960             uint referrerValue = valueForEvent * referrers[referrer] / 100;
961             referrer.transfer(referrerValue);
962         }
963     }
964 
965     function issueRewards(Lot storage p, address purchaser) internal
966     {
967         uint i;
968         for (i = 0; i < p.rewardsToken1155.length; i++)
969         {
970             mintToken1155(purchaser, p.rewardsToken1155[i]);
971         }
972         if (p.rewardsNftFixed.length > 0)
973         {
974             transferNFT(purchaser, p.rewardsNftFixed[p.rewardsNftFixed.length-1]);
975             p.rewardsNftFixed.length--;
976         }
977         for (i = 0; i < p.rewardsNftMint.length; i++)
978         {
979             mintNFT(purchaser, p.rewardsNftMint[i]);
980         }
981         for (i = 0; i < p.rewardsCutie.length; i++)
982         {
983             mintCutie(purchaser, p.rewardsCutie[i]);
984         }
985     }
986 
987     function mintToken1155(address purchaser, RewardToken1155 storage reward) internal
988     {
989         token1155.mintFungibleSingle(reward.tokenId, purchaser, reward.count);
990     }
991 
992     function mintNFT(address purchaser, uint128 nftKind) internal
993     {
994         token1155.mintNonFungibleSingleShort(nftKind, purchaser);
995     }
996 
997     function transferNFT(address purchaser, RewardNFT storage reward) internal
998     {
999         uint tokenId = (uint256(reward.nftKind) << 128) | (1 << 255) | reward.tokenIndex;
1000         token1155.safeTransferFrom(address(this), purchaser, tokenId, 1, "");
1001     }
1002 
1003     function mintCutie(address purchaser, RewardCutie storage reward) internal
1004     {
1005         cutieGenerator.generateSingle(reward.genome, reward.generation, purchaser);
1006     }
1007 
1008     function destroyContract() external onlyOwner {
1009         require(address(this).balance == 0);
1010         selfdestruct(msg.sender);
1011     }
1012 
1013     /// @dev Reject all Ether
1014     function() external payable {
1015         revert();
1016     }
1017 
1018     /// @dev The balance transfer to project owners
1019     function withdrawEthFromBalance(uint value) external onlyOwner
1020     {
1021         uint256 total = address(this).balance;
1022         if (total > value)
1023         {
1024             total = value;
1025         }
1026 
1027         msg.sender.transfer(total);
1028     }
1029 
1030     function bidNative(uint32 lotId, address referrer) external payable
1031     {
1032         Lot storage lot = lots[lotId];
1033         require(lot.price <= msg.value, "Not enough value provided");
1034         require(lot.lotKind == NATIVE, "Lot kind should be NATIVE");
1035 
1036         _bid(lotId, msg.sender, msg.value, address(0x0), referrer);
1037     }
1038 
1039     function bid(uint32 lotId, uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) external payable
1040     {
1041         bidReferrer(lotId, rate, expireAt, _v, _r, _s, address(0x0));
1042     }
1043 
1044     function bidReferrer(uint32 lotId, uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s, address referrer) public payable
1045     {
1046         Lot storage lot = lots[lotId];
1047         require(lot.lotKind == RATE_SIGN, "Lot kind should be RATE_SIGN");
1048 
1049         require(isValidSignature(rate, expireAt, _v, _r, _s));
1050         require(expireAt >= now, "Rate sign is expired");
1051 
1052 
1053         uint priceInWei = rate * lot.price;
1054         require(priceInWei <= msg.value, "Not enough value provided");
1055 
1056         _bid(lotId, msg.sender, priceInWei, address(0x0), referrer);
1057     }
1058 
1059     function setSigner(address _newSigner) public onlyOwner {
1060         signerAddress = _newSigner;
1061     }
1062 
1063     function isValidSignature(uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) public view returns (bool)
1064     {
1065         return getSigner(rate, expireAt, _v, _r, _s) == signerAddress;
1066     }
1067 
1068     function getSigner(uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address)
1069     {
1070         bytes32 msgHash = hashArguments(rate, expireAt);
1071         return ecrecover(msgHash, _v, _r, _s);
1072     }
1073 
1074     /// @dev Common function to be used also in backend
1075     function hashArguments(uint rate, uint expireAt) public pure returns (bytes32 msgHash)
1076     {
1077         msgHash = keccak256(abi.encode(rate, expireAt));
1078     }
1079 
1080     function isERC1155TokenReceiver() external view returns (bytes4) {
1081         return bytes4(keccak256("isERC1155TokenReceiver()"));
1082     }
1083 
1084     function onERC1155BatchReceived(address, address, uint256[], uint256[], bytes) external returns(bytes4)
1085     {
1086         return bytes4(keccak256("acrequcept_batch_erc1155_tokens()"));
1087     }
1088 
1089     function onERC1155Received(address, address, uint256, uint256, bytes) external returns(bytes4)
1090     {
1091         return bytes4(keccak256("accept_erc1155_tokens()"));
1092     }
1093 
1094     // 100 means 100%
1095     function setReferrer(address _address, uint _percent) external onlyOwner
1096     {
1097         require(_percent < 100);
1098         referrers[_address] = _percent;
1099     }
1100 
1101     function removeReferrer(address _address) external onlyOwner
1102     {
1103         delete referrers[_address];
1104     }
1105 
1106     function decreaseCount(uint32 lotId) external onlyOperator
1107     {
1108         Lot storage p = lots[lotId];
1109         if (p.leftCount > 0)
1110         {
1111             p.leftCount--;
1112         }
1113 
1114         emit LotChange(lotId);
1115     }
1116 }