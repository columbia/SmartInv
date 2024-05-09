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
390         require(ownerAddress[msg.sender], "Access denied");
391         _;
392     }
393 
394     function isOwner(address _addr) public view returns (bool) {
395         return ownerAddress[_addr];
396     }
397 
398     function addOwner(address _newOwner) external onlyOwner {
399         require(_newOwner != address(0), "New owner is empty");
400 
401         ownerAddress[_newOwner] = true;
402     }
403 
404     function setOwner(address _newOwner) external onlyOwner {
405         require(_newOwner != address(0), "New owner is empty");
406 
407         ownerAddress[_newOwner] = true;
408         delete(ownerAddress[msg.sender]);
409     }
410 
411     function removeOwner(address _oldOwner) external onlyOwner {
412         delete(ownerAddress[_oldOwner]);
413     }
414 
415     modifier onlyOperator() {
416         require(isOperator(msg.sender), "Access denied");
417         _;
418     }
419 
420     function isOperator(address _addr) public view returns (bool) {
421         return operatorAddress[_addr] || ownerAddress[_addr];
422     }
423 
424     function addOperator(address _newOperator) external onlyOwner {
425         require(_newOperator != address(0), "New operator is empty");
426 
427         operatorAddress[_newOperator] = true;
428     }
429 
430     function removeOperator(address _oldOperator) external onlyOwner {
431         delete(operatorAddress[_oldOperator]);
432     }
433 
434     function withdrawERC20(ERC20 _tokenContract) external onlyOwner
435     {
436         uint256 balance = _tokenContract.balanceOf(address(this));
437         _tokenContract.transfer(msg.sender, balance);
438     }
439 
440     function approveERC721(ERC721 _tokenContract) external onlyOwner
441     {
442         _tokenContract.setApprovalForAll(msg.sender, true);
443     }
444 
445     function approveERC1155(IERC1155 _tokenContract) external onlyOwner
446     {
447         _tokenContract.setApprovalForAll(msg.sender, true);
448     }
449 
450     function withdrawEth() external onlyOwner
451     {
452         if (address(this).balance > 0)
453         {
454             msg.sender.transfer(address(this).balance);
455         }
456     }
457 }
458 
459 
460 
461 /**
462  * @title Pausable
463  * @dev Base contract which allows children to implement an emergency stop mechanism.
464  */
465 contract PausableOperators is Operators {
466     event Pause();
467     event Unpause();
468 
469     bool public paused = false;
470 
471 
472     /**
473      * @dev Modifier to make a function callable only when the contract is not paused.
474      */
475     modifier whenNotPaused() {
476         require(!paused);
477         _;
478     }
479 
480     /**
481      * @dev Modifier to make a function callable only when the contract is paused.
482      */
483     modifier whenPaused() {
484         require(paused);
485         _;
486     }
487 
488     /**
489      * @dev called by the owner to pause, triggers stopped state
490      */
491     function pause() onlyOwner whenNotPaused public {
492         paused = true;
493         emit Pause();
494     }
495 
496     /**
497      * @dev called by the owner to unpause, returns to normal state
498      */
499     function unpause() onlyOwner whenPaused public {
500         paused = false;
501         emit Unpause();
502     }
503 }
504 
505 pragma solidity ^0.4.23;
506 
507 interface CutieGeneratorInterface
508 {
509     function generate(uint _genome, uint16 _generation, address[] _target) external;
510     function generateSingle(uint _genome, uint16 _generation, address _target) external returns (uint40 babyId);
511 }
512 
513 pragma solidity ^0.4.23;
514 
515 /**
516     Note: The ERC-165 identifier for this interface is 0x43b236a2.
517 */
518 interface IERC1155TokenReceiver {
519 
520     /**
521         @notice Handle the receipt of a single ERC1155 token type.
522         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
523         This function MUST return `bytes4(keccak256("accept_erc1155_tokens()"))` (i.e. 0x4dc21a2f) if it accepts the transfer.
524         This function MUST revert if it rejects the transfer.
525         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
526         @param _operator  The address which initiated the transfer (i.e. msg.sender)
527         @param _from      The address which previously owned the token
528         @param _id        The id of the token being transferred
529         @param _value     The amount of tokens being transferred
530         @param _data      Additional data with no specified format
531         @return           `bytes4(keccak256("accept_erc1155_tokens()"))`
532     */
533     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes _data) external returns(bytes4);
534 
535     /**
536         @notice Handle the receipt of multiple ERC1155 token types.
537         @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
538         This function MUST return `bytes4(keccak256("accept_batch_erc1155_tokens()"))` (i.e. 0xac007889) if it accepts the transfer(s).
539         This function MUST revert if it rejects the transfer(s).
540         Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
541         @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
542         @param _from      The address which previously owned the token
543         @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
544         @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
545         @param _data      Additional data with no specified format
546         @return           `bytes4(keccak256("accept_batch_erc1155_tokens()"))`
547     */
548     function onERC1155BatchReceived(address _operator, address _from, uint256[] _ids, uint256[] _values, bytes _data) external returns(bytes4);
549 
550     /**
551         @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
552         @dev This function MUST return `bytes4(keccak256("isERC1155TokenReceiver()"))` (i.e. 0x0d912442).
553         This function MUST NOT consume more than 5,000 gas.
554         @return           `bytes4(keccak256("isERC1155TokenReceiver()"))`
555     */
556     function isERC1155TokenReceiver() external view returns (bytes4);
557 }
558 
559 pragma solidity ^0.4.23;
560 
561 
562 
563 /// @title BlockchainCuties Presale Contract
564 /// @author https://BlockChainArchitect.io
565 interface PresaleInterface
566 {
567     function bidWithPlugin(uint32 lotId, address purchaser, uint valueForEvent, address tokenForEvent) external payable;
568     function bidWithPluginReferrer(uint32 lotId, address purchaser, uint valueForEvent, address tokenForEvent, address referrer) external payable;
569 
570     function getLotNftFixedRewards(uint32 lotId) external view returns (
571         uint256 rewardsNFTFixedKind,
572         uint256 rewardsNFTFixedIndex
573     );
574     function getLotToken1155Rewards(uint32 lotId) external view returns (
575         uint256[10] memory rewardsToken1155tokenId,
576         uint256[10] memory rewardsToken1155count
577     );
578     function getLotCutieRewards(uint32 lotId) external view returns (
579         uint256[10] memory rewardsCutieGenome,
580         uint256[10] memory rewardsCutieGeneration
581     );
582     function getLotNftMintRewards(uint32 lotId) external view returns (
583         uint256[10] memory rewardsNFTMintNftKind
584     );
585 
586     function getLotToken1155RewardByIndex(uint32 lotId, uint index) external view returns (
587         uint256 rewardsToken1155tokenId,
588         uint256 rewardsToken1155count
589     );
590     function getLotCutieRewardByIndex(uint32 lotId, uint index) external view returns (
591         uint256 rewardsCutieGenome,
592         uint256 rewardsCutieGeneration
593     );
594     function getLotNftMintRewardByIndex(uint32 lotId, uint index) external view returns (
595         uint256 rewardsNFTMintNftKind
596     );
597 
598     function getLotToken1155RewardCount(uint32 lotId) external view returns (uint);
599     function getLotCutieRewardCount(uint32 lotId) external view returns (uint);
600     function getLotNftMintRewardCount(uint32 lotId) external view returns (uint);
601 
602     function getLotRewards(uint32 lotId) external view returns (
603         uint256[5] memory rewardsToken1155tokenId,
604         uint256[5] memory rewardsToken1155count,
605         uint256[5] memory rewardsNFTMintNftKind,
606         uint256[5] memory rewardsNFTFixedKind,
607         uint256[5] memory rewardsNFTFixedIndex,
608         uint256[5] memory rewardsCutieGenome,
609         uint256[5] memory rewardsCutieGeneration
610     );
611 
612     function bidWithToken(uint32 lotId, uint rate, uint expireAt, ERC20 paymentToken, uint8 _v, bytes32 _r, bytes32 _s, address referrer) external;
613     function bidNativeWithToken(uint32 lotId, address referrer, ERC20 paymentToken) external;
614 }
615 
616 pragma solidity ^0.4.23;
617 
618 
619 
620 interface TokenRegistryInterface
621 {
622     function getPriceInToken(ERC20 tokenContract, uint128 priceWei) external view returns (uint128);
623     function convertPriceFromTokensToWei(ERC20 tokenContract, uint priceTokens) external view returns (uint);
624     function areAllTokensAllowed(address[] tokens) external view returns (bool);
625     function isTokenInList(address[] allowedTokens, address currentToken) external pure returns (bool);
626     function getDefaultTokens() external view returns (address[]);
627     function getDefaultCreatorTokens() external view returns (address[]);
628     function onTokensReceived(ERC20 tokenContract, uint tokenCount) external;
629     function withdrawEthFromBalance() external;
630     function canConvertToEth(ERC20 tokenContract) external view returns (bool);
631     function convertTokensToEth(ERC20 tokenContract, address seller, uint sellerValue, uint fee) external;
632 }
633 
634 
635 /// @title BlockchainCuties Presale
636 /// @author https://BlockChainArchitect.io
637 contract Presale is PresaleInterface, PausableOperators, IERC1155TokenReceiver
638 {
639     struct RewardToken1155
640     {
641         uint tokenId;
642         uint count;
643     }
644 
645     struct RewardNFT
646     {
647         uint128 nftKind;
648         uint128 tokenIndex;
649     }
650 
651     struct RewardCutie
652     {
653         uint genome;
654         uint16 generation;
655     }
656 
657     uint32 constant RATE_SIGN = 0;
658     uint32 constant NATIVE = 1;
659 
660     struct Lot
661     {
662         RewardToken1155[] rewardsToken1155; // stackable
663         uint128[] rewardsNftMint; // stackable
664         RewardNFT[] rewardsNftFixed; // non stackable - one element per lot
665         RewardCutie[] rewardsCutie; // stackable
666         uint128 price;
667         uint128 leftCount;
668         uint128 priceMul;
669         uint128 priceAdd;
670         uint32 expireTime;
671         uint32 lotKind;
672         address priceInToken;
673     }
674 
675     mapping (uint32 => Lot) public lots;
676 
677     mapping (address => uint) public referrers;
678 
679     BlockchainCutiesERC1155Interface public token1155;
680     CutieGeneratorInterface public cutieGenerator;
681     TokenRegistryInterface public tokenRegistry;
682     address public signerAddress;
683 
684     event Bid(address indexed purchaser, uint32 indexed lotId, uint value, address indexed token);
685     event BidReferrer(address indexed purchaser, uint32 indexed lotId, uint value, address token, address indexed referrer);
686     event LotChange(uint32 indexed lotId);
687 
688     function setToken1155(BlockchainCutiesERC1155Interface _token1155) onlyOwner public
689     {
690         token1155 = _token1155;
691     }
692 
693     function setCutieGenerator(CutieGeneratorInterface _cutieGenerator) onlyOwner public
694     {
695         cutieGenerator = _cutieGenerator;
696     }
697 
698     function setTokenRegistry(TokenRegistryInterface _tokenRegistry) onlyOwner public
699     {
700         tokenRegistry = _tokenRegistry;
701     }
702 
703     function setup(
704         BlockchainCutiesERC1155Interface _token1155,
705         CutieGeneratorInterface _cutieGenerator,
706         TokenRegistryInterface _tokenRegistry) onlyOwner external
707     {
708         setToken1155(_token1155);
709         setCutieGenerator(_cutieGenerator);
710         setTokenRegistry(_tokenRegistry);
711     }
712 
713     function setLot(uint32 lotId, uint128 price, uint128 count, uint32 expireTime, uint128 priceMul, uint128 priceAdd, uint32 lotKind) external onlyOperator
714     {
715         delete lots[lotId];
716         Lot storage lot = lots[lotId];
717         lot.price = price;
718         lot.leftCount = count;
719         lot.expireTime = expireTime;
720         lot.priceMul = priceMul;
721         lot.priceAdd = priceAdd;
722         lot.lotKind = lotKind;
723         lot.priceInToken = address(0x0);
724         emit LotChange(lotId);
725     }
726 
727     function setLotWithToken(uint32 lotId, uint128 price, uint128 count, uint32 expireTime, uint128 priceMul, uint128 priceAdd, uint32 lotKind, address priceInToken) external onlyOperator
728     {
729         delete lots[lotId];
730         Lot storage lot = lots[lotId];
731         lot.price = price;
732         lot.leftCount = count;
733         lot.expireTime = expireTime;
734         lot.priceMul = priceMul;
735         lot.priceAdd = priceAdd;
736         lot.lotKind = lotKind;
737         lot.priceInToken = priceInToken;
738         emit LotChange(lotId);
739     }
740 
741     function setLotLeftCount(uint32 lotId, uint128 count) external onlyOperator
742     {
743         Lot storage lot = lots[lotId];
744         lot.leftCount = count;
745         emit LotChange(lotId);
746     }
747 
748     function setExpireTime(uint32 lotId, uint32 expireTime) external onlyOperator
749     {
750         Lot storage lot = lots[lotId];
751         lot.expireTime = expireTime;
752         emit LotChange(lotId);
753     }
754 
755     function setPrice(uint32 lotId, uint128 price) external onlyOperator
756     {
757         lots[lotId].price = price;
758         emit LotChange(lotId);
759     }
760 
761     function deleteLot(uint32 lotId) external onlyOperator
762     {
763         delete lots[lotId];
764         emit LotChange(lotId);
765     }
766 
767     function addRewardToken1155(uint32 lotId, uint tokenId, uint count) external onlyOperator
768     {
769         lots[lotId].rewardsToken1155.push(RewardToken1155(tokenId, count));
770         emit LotChange(lotId);
771     }
772 
773     function setRewardToken1155(uint32 lotId, uint tokenId, uint count) external onlyOperator
774     {
775         delete lots[lotId].rewardsToken1155;
776         lots[lotId].rewardsToken1155.push(RewardToken1155(tokenId, count));
777         emit LotChange(lotId);
778     }
779 
780     function setRewardNftFixed(uint32 lotId, uint128 nftType, uint128 tokenIndex) external onlyOperator
781     {
782         delete lots[lotId].rewardsNftFixed;
783         lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex));
784         emit LotChange(lotId);
785     }
786 
787     function addRewardNftFixed(uint32 lotId, uint128 nftType, uint128 tokenIndex) external onlyOperator
788     {
789         lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex));
790         emit LotChange(lotId);
791     }
792 
793     function addRewardNftFixedBulk(uint32 lotId, uint128 nftType, uint128[] tokenIndex) external onlyOperator
794     {
795         for (uint i = 0; i < tokenIndex.length; i++)
796         {
797             lots[lotId].rewardsNftFixed.push(RewardNFT(nftType, tokenIndex[i]));
798         }
799         emit LotChange(lotId);
800     }
801 
802     function addRewardNftMint(uint32 lotId, uint128 nftType) external onlyOperator
803     {
804         lots[lotId].rewardsNftMint.push(nftType);
805         emit LotChange(lotId);
806     }
807 
808     function setRewardNftMint(uint32 lotId, uint128 nftType) external onlyOperator
809     {
810         delete lots[lotId].rewardsNftMint;
811         lots[lotId].rewardsNftMint.push(nftType);
812         emit LotChange(lotId);
813     }
814 
815     function addRewardCutie(uint32 lotId, uint genome, uint16 generation) external onlyOperator
816     {
817         lots[lotId].rewardsCutie.push(RewardCutie(genome, generation));
818         emit LotChange(lotId);
819     }
820 
821     function setRewardCutie(uint32 lotId, uint genome, uint16 generation) external onlyOperator
822     {
823         delete lots[lotId].rewardsCutie;
824         lots[lotId].rewardsCutie.push(RewardCutie(genome, generation));
825         emit LotChange(lotId);
826     }
827 
828     function isAvailable(uint32 lotId) public view returns (bool)
829     {
830         Lot storage lot = lots[lotId];
831         return
832             lot.leftCount > 0 && lot.expireTime >= now;
833     }
834 
835     function getLot(uint32 lotId) external view returns (
836         uint256 price,
837         uint256 left,
838         uint256 expireTime,
839         uint256 lotKind
840     )
841     {
842         Lot storage p = lots[lotId];
843         price = p.price;
844         left = p.leftCount;
845         expireTime = p.expireTime;
846         lotKind = p.lotKind;
847     }
848 
849     function getLot2(uint32 lotId) external view returns (
850         uint256 price,
851         uint256 left,
852         uint256 expireTime,
853         uint256 lotKind,
854         address priceInToken
855     )
856     {
857         Lot storage p = lots[lotId];
858         price = p.price;
859         left = p.leftCount;
860         expireTime = p.expireTime;
861         lotKind = p.lotKind;
862         priceInToken = p.priceInToken;
863     }
864 
865     function getLotRewards(uint32 lotId) external view returns (
866             uint256[5] memory rewardsToken1155tokenId,
867             uint256[5] memory rewardsToken1155count,
868             uint256[5] memory rewardsNFTMintNftKind,
869             uint256[5] memory rewardsNFTFixedKind,
870             uint256[5] memory rewardsNFTFixedIndex,
871             uint256[5] memory rewardsCutieGenome,
872             uint256[5] memory rewardsCutieGeneration
873         )
874     {
875         Lot storage p = lots[lotId];
876         uint i;
877         for (i = 0; i < p.rewardsToken1155.length; i++)
878         {
879             if (i >= 5) break;
880             rewardsToken1155tokenId[i] = p.rewardsToken1155[i].tokenId;
881             rewardsToken1155count[i] = p.rewardsToken1155[i].count;
882         }
883         for (i = 0; i < p.rewardsNftMint.length; i++)
884         {
885             if (i >= 5) break;
886             rewardsNFTMintNftKind[i] = p.rewardsNftMint[i];
887         }
888         for (i = 0; i < p.rewardsNftFixed.length; i++)
889         {
890             if (i >= 5) break;
891             rewardsNFTFixedKind[i] = p.rewardsNftFixed[i].nftKind;
892             rewardsNFTFixedIndex[i] = p.rewardsNftFixed[i].tokenIndex;
893         }
894         for (i = 0; i < p.rewardsCutie.length; i++)
895         {
896             if (i >= 5) break;
897             rewardsCutieGenome[i] = p.rewardsCutie[i].genome;
898             rewardsCutieGeneration[i] = p.rewardsCutie[i].generation;
899         }
900     }
901 
902     function getLotNftFixedRewards(uint32 lotId) external view returns (
903         uint256 rewardsNFTFixedKind,
904         uint256 rewardsNFTFixedIndex
905     )
906     {
907         Lot storage p = lots[lotId];
908 
909         if (p.rewardsNftFixed.length > 0)
910         {
911             rewardsNFTFixedKind = p.rewardsNftFixed[p.rewardsNftFixed.length-1].nftKind;
912             rewardsNFTFixedIndex = p.rewardsNftFixed[p.rewardsNftFixed.length-1].tokenIndex;
913         }
914     }
915 
916     function getLotToken1155Rewards(uint32 lotId) external view returns (
917         uint256[10] memory rewardsToken1155tokenId,
918         uint256[10] memory rewardsToken1155count
919     )
920     {
921         Lot storage p = lots[lotId];
922         for (uint i = 0; i < p.rewardsToken1155.length; i++)
923         {
924             if (i >= 10) break;
925             rewardsToken1155tokenId[i] = p.rewardsToken1155[i].tokenId;
926             rewardsToken1155count[i] = p.rewardsToken1155[i].count;
927         }
928     }
929 
930     function getLotCutieRewards(uint32 lotId) external view returns (
931         uint256[10] memory rewardsCutieGenome,
932         uint256[10] memory rewardsCutieGeneration
933     )
934     {
935         Lot storage p = lots[lotId];
936         for (uint i = 0; i < p.rewardsCutie.length; i++)
937         {
938             if (i >= 10) break;
939             rewardsCutieGenome[i] = p.rewardsCutie[i].genome;
940             rewardsCutieGeneration[i] = p.rewardsCutie[i].generation;
941         }
942     }
943 
944     function getLotNftMintRewards(uint32 lotId) external view returns (
945         uint256[10] memory rewardsNFTMintNftKind
946     )
947     {
948         Lot storage p = lots[lotId];
949         for (uint i = 0; i < p.rewardsNftMint.length; i++)
950         {
951             if (i >= 10) break;
952             rewardsNFTMintNftKind[i] = p.rewardsNftMint[i];
953         }
954     }
955 
956     function getLotToken1155RewardByIndex(uint32 lotId, uint index) external view returns (
957         uint256 rewardsToken1155tokenId,
958         uint256 rewardsToken1155count
959     )
960     {
961         Lot storage p = lots[lotId];
962         rewardsToken1155tokenId = p.rewardsToken1155[index].tokenId;
963         rewardsToken1155count = p.rewardsToken1155[index].count;
964     }
965 
966     function getLotCutieRewardByIndex(uint32 lotId, uint index) external view returns (
967         uint256 rewardsCutieGenome,
968         uint256 rewardsCutieGeneration
969     )
970     {
971         Lot storage p = lots[lotId];
972         rewardsCutieGenome = p.rewardsCutie[index].genome;
973         rewardsCutieGeneration = p.rewardsCutie[index].generation;
974     }
975 
976     function getLotNftMintRewardByIndex(uint32 lotId, uint index) external view returns (
977         uint256 rewardsNFTMintNftKind
978     )
979     {
980         Lot storage p = lots[lotId];
981         rewardsNFTMintNftKind = p.rewardsNftMint[index];
982     }
983 
984     function getLotToken1155RewardCount(uint32 lotId) external view returns (uint)
985     {
986         return lots[lotId].rewardsToken1155.length;
987     }
988     function getLotCutieRewardCount(uint32 lotId) external view returns (uint)
989     {
990         return lots[lotId].rewardsCutie.length;
991     }
992     function getLotNftMintRewardCount(uint32 lotId) external view returns (uint)
993     {
994         return lots[lotId].rewardsNftMint.length;
995     }
996 
997     function deleteRewards(uint32 lotId) external onlyOwner
998     {
999         delete lots[lotId].rewardsToken1155;
1000         delete lots[lotId].rewardsNftMint;
1001         delete lots[lotId].rewardsNftFixed;
1002         delete lots[lotId].rewardsCutie;
1003         emit LotChange(lotId);
1004     }
1005 
1006     function bidWithPlugin(uint32 lotId, address purchaser, uint valueForEvent, address tokenForEvent) external payable onlyOperator
1007     {
1008         _bid(lotId, purchaser, valueForEvent, tokenForEvent, address(0x0));
1009     }
1010 
1011     function bidWithPluginReferrer(uint32 lotId, address purchaser, uint valueForEvent, address tokenForEvent, address referrer) external payable onlyOperator
1012     {
1013         _bid(lotId, purchaser, valueForEvent, tokenForEvent, referrer);
1014     }
1015 
1016     function _bid(uint32 lotId, address purchaser, uint valueForEvent, address tokenForEvent, address referrer) internal whenNotPaused
1017     {
1018         Lot storage p = lots[lotId];
1019         require(isAvailable(lotId), "Lot is not available");
1020 
1021         if (referrer == address(0x0))
1022         {
1023             emit BidReferrer(purchaser, lotId, valueForEvent, tokenForEvent, referrer);
1024         }
1025         else
1026         {
1027             emit Bid(purchaser, lotId, valueForEvent, tokenForEvent);
1028         }
1029 
1030         p.leftCount--;
1031         p.price += uint128(uint256(p.price)*p.priceMul / 1000000);
1032         p.price += p.priceAdd;
1033 
1034         issueRewards(p, purchaser);
1035 
1036         if (referrers[referrer] > 0)
1037         {
1038             uint referrerValue = valueForEvent * referrers[referrer] / 100;
1039             referrer.transfer(referrerValue);
1040         }
1041     }
1042 
1043     function issueRewards(Lot storage p, address purchaser) internal
1044     {
1045         uint i;
1046         for (i = 0; i < p.rewardsToken1155.length; i++)
1047         {
1048             mintToken1155(purchaser, p.rewardsToken1155[i]);
1049         }
1050         if (p.rewardsNftFixed.length > 0)
1051         {
1052             transferNFT(purchaser, p.rewardsNftFixed[p.rewardsNftFixed.length-1]);
1053             p.rewardsNftFixed.length--;
1054         }
1055         for (i = 0; i < p.rewardsNftMint.length; i++)
1056         {
1057             mintNFT(purchaser, p.rewardsNftMint[i]);
1058         }
1059         for (i = 0; i < p.rewardsCutie.length; i++)
1060         {
1061             mintCutie(purchaser, p.rewardsCutie[i]);
1062         }
1063     }
1064 
1065     function mintToken1155(address purchaser, RewardToken1155 storage reward) internal
1066     {
1067         token1155.mintFungibleSingle(reward.tokenId, purchaser, reward.count);
1068     }
1069 
1070     function mintNFT(address purchaser, uint128 nftKind) internal
1071     {
1072         token1155.mintNonFungibleSingleShort(nftKind, purchaser);
1073     }
1074 
1075     function transferNFT(address purchaser, RewardNFT storage reward) internal
1076     {
1077         uint tokenId = (uint256(reward.nftKind) << 128) | (1 << 255) | reward.tokenIndex;
1078         token1155.safeTransferFrom(address(this), purchaser, tokenId, 1, "");
1079     }
1080 
1081     function mintCutie(address purchaser, RewardCutie storage reward) internal
1082     {
1083         cutieGenerator.generateSingle(reward.genome, reward.generation, purchaser);
1084     }
1085 
1086     function destroyContract() external onlyOwner {
1087         require(address(this).balance == 0);
1088         selfdestruct(msg.sender);
1089     }
1090 
1091     /// @dev Reject all Ether
1092     function() external payable {
1093         revert();
1094     }
1095 
1096     /// @dev The balance transfer to project owners
1097     function withdrawEthFromBalance(uint value) external onlyOwner
1098     {
1099         uint256 total = address(this).balance;
1100         if (total > value)
1101         {
1102             total = value;
1103         }
1104 
1105         msg.sender.transfer(total);
1106     }
1107 
1108     function bidNative(uint32 lotId, address referrer) external payable
1109     {
1110         Lot storage lot = lots[lotId];
1111         require(lot.price <= msg.value, "Not enough value provided");
1112         require(lot.lotKind == NATIVE, "Lot kind should be NATIVE");
1113         require(lot.priceInToken == address(0x0), "Price in token is not supported");
1114 
1115         _bid(lotId, msg.sender, msg.value, address(0x0), referrer);
1116     }
1117 
1118     // https://github.com/BitGuildPlatform/Documentation/blob/master/README.md#2-required-game-smart-contract-changes
1119     // Function that is called when trying to use Token for payments from approveAndCall
1120     function receiveApproval(address _sender, uint256, address _tokenContract, bytes _extraData) external
1121     {
1122         uint32 lotId = getLotId(_extraData);
1123         _bidNativeWithToken(lotId, address(0x0), ERC20(_tokenContract), _sender);
1124     }
1125 
1126     function getLotId(bytes _extraData) pure internal returns (uint32)
1127     {
1128         require(_extraData.length == 4); // 32 bits
1129 
1130         return
1131             uint32(_extraData[0]) +
1132             uint32(_extraData[1]) * 0x100 +
1133             uint32(_extraData[2]) * 0x10000 +
1134             uint32(_extraData[3]) * 0x100000;
1135     }
1136 
1137     function bidNativeWithToken(uint32 lotId, address referrer, ERC20 paymentToken) external
1138     {
1139         _bidNativeWithToken(lotId, referrer, paymentToken, msg.sender);
1140     }
1141 
1142     function _bidNativeWithToken(uint32 lotId, address referrer, ERC20 paymentToken, address sender) internal
1143     {
1144         Lot storage lot = lots[lotId];
1145         require(lot.lotKind == NATIVE, "Lot kind should be NATIVE");
1146         require(isTokenAllowed(paymentToken), "Token is not allowed");
1147 
1148         uint priceInTokens;
1149 
1150         // do not convert if price is specified in same token as payment token
1151         if (lot.priceInToken == address(paymentToken))
1152         {
1153             priceInTokens = lot.price;
1154         }
1155         // convert from one token to another
1156         else if (lot.priceInToken != address(0x0))
1157         {
1158             uint priceInWei = convertPriceFromTokensToWei(ERC20(lot.priceInToken), lot.price);
1159             priceInTokens = convertPriceFromWeiToTokens(paymentToken, priceInWei);
1160         }
1161         else // price in ETH
1162         {
1163             uint priceInWei2 = lot.price;
1164             priceInTokens = convertPriceFromWeiToTokens(paymentToken, priceInWei2);
1165         }
1166         require(paymentToken.transferFrom(sender, address(tokenRegistry), priceInTokens), "Can't request tokens");
1167         tokenRegistry.onTokensReceived(paymentToken, priceInTokens);
1168 
1169         _bid(lotId, sender, priceInTokens, address(paymentToken), referrer);
1170     }
1171 
1172     function bid(uint32 lotId, uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) external payable
1173     {
1174         bidReferrer(lotId, rate, expireAt, _v, _r, _s, address(0x0));
1175     }
1176 
1177     function bidWithToken(uint32 lotId, uint rate, uint expireAt, ERC20 paymentToken, uint8 _v, bytes32 _r, bytes32 _s, address referrer) external
1178     {
1179         Lot storage lot = lots[lotId];
1180         require(lot.lotKind == RATE_SIGN, "Lot kind should be RATE_SIGN");
1181 
1182         require(isValidSignature(rate, expireAt, _v, _r, _s), "Signature is not valid");
1183         require(expireAt >= now, "Rate sign is expired");
1184         require(isTokenAllowed(paymentToken), "Token is not allowed");
1185 
1186         uint priceInTokens;
1187         // do not convert if price is specified in same token as payment token
1188         if (lot.priceInToken == address(paymentToken))
1189         {
1190             priceInTokens = lot.price;
1191         }
1192         // convert from one token to another
1193         else if (lot.priceInToken != address(0x0))
1194         {
1195             uint priceInWei = rate * lot.price;
1196             priceInTokens = convertPriceFromWeiToTokens(paymentToken, priceInWei);
1197         }
1198         else // price in ETH
1199         {
1200             uint priceInWei2 = rate * lot.price;
1201             priceInTokens = convertPriceFromWeiToTokens(paymentToken, priceInWei2);
1202         }
1203 
1204         require(paymentToken.transferFrom(msg.sender, address(tokenRegistry), priceInTokens), "Can't request tokens");
1205         tokenRegistry.onTokensReceived(paymentToken, priceInTokens);
1206 
1207         _bid(lotId, msg.sender, priceInTokens, address(paymentToken), referrer);
1208     }
1209 
1210     function bidReferrer(uint32 lotId, uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s, address referrer) public payable
1211     {
1212         Lot storage lot = lots[lotId];
1213         require(lot.lotKind == RATE_SIGN, "Lot kind should be RATE_SIGN");
1214 
1215         require(isValidSignature(rate, expireAt, _v, _r, _s));
1216         require(expireAt >= now, "Rate sign is expired");
1217 
1218         uint priceInWei = rate * lot.price;
1219         require(priceInWei <= msg.value, "Not enough value provided");
1220 
1221         _bid(lotId, msg.sender, priceInWei, address(0x0), referrer);
1222     }
1223 
1224     function setSigner(address _newSigner) public onlyOwner {
1225         signerAddress = _newSigner;
1226     }
1227 
1228     function isValidSignature(uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) public view returns (bool)
1229     {
1230         return getSigner(rate, expireAt, _v, _r, _s) == signerAddress;
1231     }
1232 
1233     function getSigner(uint rate, uint expireAt, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address)
1234     {
1235         bytes32 msgHash = hashArguments(rate, expireAt);
1236         return ecrecover(msgHash, _v, _r, _s);
1237     }
1238 
1239     /// @dev Common function to be used also in backend
1240     function hashArguments(uint rate, uint expireAt) public pure returns (bytes32 msgHash)
1241     {
1242         msgHash = keccak256(abi.encode(rate, expireAt));
1243     }
1244 
1245     function isERC1155TokenReceiver() external view returns (bytes4) {
1246         return bytes4(keccak256("isERC1155TokenReceiver()"));
1247     }
1248 
1249     function onERC1155BatchReceived(address, address, uint256[], uint256[], bytes) external returns(bytes4)
1250     {
1251         return bytes4(keccak256("acrequcept_batch_erc1155_tokens()"));
1252     }
1253 
1254     function onERC1155Received(address, address, uint256, uint256, bytes) external returns(bytes4)
1255     {
1256         return bytes4(keccak256("accept_erc1155_tokens()"));
1257     }
1258 
1259     // 100 means 100%
1260     function setReferrer(address _address, uint _percent) external onlyOwner
1261     {
1262         require(_percent < 100);
1263         referrers[_address] = _percent;
1264     }
1265 
1266     function removeReferrer(address _address) external onlyOwner
1267     {
1268         delete referrers[_address];
1269     }
1270 
1271     function decreaseCount(uint32 lotId) external onlyOperator
1272     {
1273         Lot storage p = lots[lotId];
1274         if (p.leftCount > 0)
1275         {
1276             p.leftCount--;
1277         }
1278 
1279         emit LotChange(lotId);
1280     }
1281 
1282     function isTokenAllowed(ERC20 token) view public returns (bool)
1283     {
1284         address[] memory arg = new address[](1);
1285         arg[0] = address(token);
1286         return tokenRegistry.areAllTokensAllowed(arg);
1287     }
1288 
1289     function convertPriceFromWeiToTokens(ERC20 token, uint valueInWei) view public returns (uint)
1290     {
1291         return uint(tokenRegistry.getPriceInToken(token, uint128(valueInWei)));
1292     }
1293 
1294     function convertPriceFromTokensToWei(ERC20 token, uint valueInTokens) view public returns (uint)
1295     {
1296         return tokenRegistry.convertPriceFromTokensToWei(token, valueInTokens);
1297     }
1298 }