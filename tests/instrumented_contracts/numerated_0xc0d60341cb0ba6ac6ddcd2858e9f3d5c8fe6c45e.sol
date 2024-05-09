1 pragma solidity ^0.5.0;
2 
3 contract BuilderShop {
4    address[] builderInstances;
5    uint contractId = 0;
6 
7    //nifty registry is hard coded
8    address niftyRegistryContract = 0x6e53130dDfF21E3BC963Ee902005223b9A202106;
9 
10    modifier onlyValidSender() {
11        NiftyRegistry nftg_registry = NiftyRegistry(niftyRegistryContract);
12        bool is_valid = nftg_registry.isValidNiftySender(msg.sender);
13        require(is_valid==true);
14        _;
15    }
16 
17    mapping (address => bool) public BuilderShops;
18 
19    function isValidBuilderShop(address builder_shop) public view returns (bool isValid) {
20        //public function, allowing anyone to check if a contract address is a valid nifty gateway contract
21        return(BuilderShops[builder_shop]);
22    }
23 
24    event BuilderInstanceCreated(address new_contract_address, uint contractId);
25 
26    function createNewBuilderInstance(
27        string memory _name,
28        string memory _symbol,
29        uint num_nifties,
30        uint[] memory nifty_quantities,
31        string memory token_base_uri,
32        string memory creator_name)
33        public returns (NiftyBuilderInstance tokenAddress) { // <- must replace this !!!
34    //public onlyValidSender returns (NiftyBuilderInstance tokenAddress) {
35 
36        contractId = contractId + 1;
37 
38        NiftyBuilderInstance new_contract = new NiftyBuilderInstance(
39            _name,
40            _symbol,
41            contractId,
42            num_nifties,
43            nifty_quantities,
44            token_base_uri,
45            creator_name
46        );
47 
48        address externalId = address(new_contract);
49 
50        BuilderShops[externalId] = true;
51 
52        emit BuilderInstanceCreated(externalId, contractId);
53 
54        return (new_contract);
55     }
56 }
57 
58 /*
59 * @dev Provides information about the current execution context, including the
60 * sender of the transaction and its data. While these are generally available
61 * via msg.sender and msg.data, they should not be accessed in such a direct
62 * manner, since when dealing with GSN meta-transactions the account sending and
63 * paying for execution may not be the actual sender (as far as an application
64 * is concerned).
65 *
66 * This contract is only required for intermediate, library-like contracts.
67 */
68 contract Context {
69    // Empty internal constructor, to prevent people from mistakenly deploying
70    // an instance of this contract, which should be used via inheritance.
71    constructor () internal { }
72    // solhint-disable-previous-line no-empty-blocks
73 
74    function _msgSender() internal view returns (address payable) {
75        return msg.sender;
76    }
77 
78    function _msgData() internal view returns (bytes memory) {
79        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
80        return msg.data;
81    }
82 }
83 
84 /**
85 * @dev Interface of the ERC165 standard, as defined in the
86 * https://eips.ethereum.org/EIPS/eip-165[EIP].
87 *
88 * Implementers can declare support of contract interfaces, which can then be
89 * queried by others ({ERC165Checker}).
90 *
91 * For an implementation, see {ERC165}.
92 */
93 interface IERC165 {
94    /**
95     * @dev Returns true if this contract implements the interface defined by
96     * `interfaceId`. See the corresponding
97     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
98     * to learn more about how these ids are created.
99     *
100     * This function call must use less than 30 000 gas.
101     */
102    function supportsInterface(bytes4 interfaceId) external view returns (bool);
103 }
104 
105 /**
106 * @dev Implementation of the {IERC165} interface.
107 *
108 * Contracts may inherit from this and call {_registerInterface} to declare
109 * their support of an interface.
110 */
111 contract ERC165 is IERC165 {
112    /*
113     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
114     */
115    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
116 
117    /**
118     * @dev Mapping of interface ids to whether or not it's supported.
119     */
120    mapping(bytes4 => bool) private _supportedInterfaces;
121 
122    constructor () internal {
123        // Derived contracts need only register support for their own interfaces,
124        // we register support for ERC165 itself here
125        _registerInterface(_INTERFACE_ID_ERC165);
126    }
127 
128    /**
129     * @dev See {IERC165-supportsInterface}.
130     *
131     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
132     */
133    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
134        return _supportedInterfaces[interfaceId];
135    }
136 
137    /**
138     * @dev Registers the contract as an implementer of the interface defined by
139     * `interfaceId`. Support of the actual ERC165 interface is automatic and
140     * registering its interface id is not required.
141     *
142     * See {IERC165-supportsInterface}.
143     *
144     * Requirements:
145     *
146     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
147     */
148    function _registerInterface(bytes4 interfaceId) internal {
149        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
150        _supportedInterfaces[interfaceId] = true;
151    }
152 }
153 
154 /**
155 * @dev Required interface of an ERC721 compliant contract.
156 */
157 contract IERC721 is IERC165 {
158    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
159    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
160    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
161 
162    /**
163     * @dev Returns the number of NFTs in `owner`'s account.
164     */
165    function balanceOf(address owner) public view returns (uint256 balance);
166 
167    /**
168     * @dev Returns the owner of the NFT specified by `tokenId`.
169     */
170    function ownerOf(uint256 tokenId) public view returns (address owner);
171 
172    /**
173     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
174     * another (`to`).
175     *
176     *
177     *
178     * Requirements:
179     * - `from`, `to` cannot be zero.
180     * - `tokenId` must be owned by `from`.
181     * - If the caller is not `from`, it must be have been allowed to move this
182     * NFT by either {approve} or {setApprovalForAll}.
183     */
184    function safeTransferFrom(address from, address to, uint256 tokenId) public;
185    /**
186     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
187     * another (`to`).
188     *
189     * Requirements:
190     * - If the caller is not `from`, it must be approved to move this NFT by
191     * either {approve} or {setApprovalForAll}.
192     */
193    function transferFrom(address from, address to, uint256 tokenId) public;
194    function approve(address to, uint256 tokenId) public;
195    function getApproved(uint256 tokenId) public view returns (address operator);
196 
197    function setApprovalForAll(address operator, bool _approved) public;
198    function isApprovedForAll(address owner, address operator) public view returns (bool);
199 
200 
201    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
202 }
203 
204 /**
205 * @title ERC721 token receiver interface
206 * @dev Interface for any contract that wants to support safeTransfers
207 * from ERC721 asset contracts.
208 */
209 contract IERC721Receiver {
210    /**
211     * @notice Handle the receipt of an NFT
212     * @dev The ERC721 smart contract calls this function on the recipient
213     * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
214     * otherwise the caller will revert the transaction. The selector to be
215     * returned can be obtained as `this.onERC721Received.selector`. This
216     * function MAY throw to revert and reject the transfer.
217     * Note: the ERC721 contract address is always the message sender.
218     * @param operator The address which called `safeTransferFrom` function
219     * @param from The address which previously owned the token
220     * @param tokenId The NFT identifier which is being transferred
221     * @param data Additional data with no specified format
222     * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
223     */
224    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
225    public returns (bytes4);
226 }
227 
228 /**
229 * @title ERC721 Non-Fungible Token Standard basic implementation
230 * @dev see https://eips.ethereum.org/EIPS/eip-721
231 */
232 contract ERC721 is Context, ERC165, IERC721 {
233    using SafeMath for uint256;
234    using Address for address;
235    using Counters for Counters.Counter;
236 
237    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
238    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
239    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
240 
241    // Mapping from token ID to owner
242    mapping (uint256 => address) private _tokenOwner;
243 
244    // Mapping from token ID to approved address
245    mapping (uint256 => address) private _tokenApprovals;
246 
247    // Mapping from owner to number of owned token
248    mapping (address => Counters.Counter) private _ownedTokensCount;
249 
250    // Mapping from owner to operator approvals
251    mapping (address => mapping (address => bool)) private _operatorApprovals;
252 
253    /*
254     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
255     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
256     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
257     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
258     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
259     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
260     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
261     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
262     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
263     *
264     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
265     *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
266     */
267    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
268 
269    constructor () public {
270        // register the supported interfaces to conform to ERC721 via ERC165
271        _registerInterface(_INTERFACE_ID_ERC721);
272    }
273 
274    /**
275     * @dev Gets the balance of the specified address.
276     * @param owner address to query the balance of
277     * @return uint256 representing the amount owned by the passed address
278     */
279    function balanceOf(address owner) public view returns (uint256) {
280        require(owner != address(0), "ERC721: balance query for the zero address");
281 
282        return _ownedTokensCount[owner].current();
283    }
284 
285    /**
286     * @dev Gets the owner of the specified token ID.
287     * @param tokenId uint256 ID of the token to query the owner of
288     * @return address currently marked as the owner of the given token ID
289     */
290    function ownerOf(uint256 tokenId) public view returns (address) {
291        address owner = _tokenOwner[tokenId];
292        require(owner != address(0), "ERC721: owner query for nonexistent token");
293 
294        return owner;
295    }
296 
297    /**
298     * @dev Approves another address to transfer the given token ID
299     * The zero address indicates there is no approved address.
300     * There can only be one approved address per token at a given time.
301     * Can only be called by the token owner or an approved operator.
302     * @param to address to be approved for the given token ID
303     * @param tokenId uint256 ID of the token to be approved
304     */
305    function approve(address to, uint256 tokenId) public {
306        address owner = ownerOf(tokenId);
307        require(to != owner, "ERC721: approval to current owner");
308 
309        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
310            "ERC721: approve caller is not owner nor approved for all"
311        );
312 
313        _tokenApprovals[tokenId] = to;
314        emit Approval(owner, to, tokenId);
315    }
316 
317    /**
318     * @dev Gets the approved address for a token ID, or zero if no address set
319     * Reverts if the token ID does not exist.
320     * @param tokenId uint256 ID of the token to query the approval of
321     * @return address currently approved for the given token ID
322     */
323    function getApproved(uint256 tokenId) public view returns (address) {
324        require(_exists(tokenId), "ERC721: approved query for nonexistent token");
325 
326        return _tokenApprovals[tokenId];
327    }
328 
329    /**
330     * @dev Sets or unsets the approval of a given operator
331     * An operator is allowed to transfer all tokens of the sender on their behalf.
332     * @param to operator address to set the approval
333     * @param approved representing the status of the approval to be set
334     */
335    function setApprovalForAll(address to, bool approved) public {
336        require(to != _msgSender(), "ERC721: approve to caller");
337 
338        _operatorApprovals[_msgSender()][to] = approved;
339        emit ApprovalForAll(_msgSender(), to, approved);
340    }
341 
342    /**
343     * @dev Tells whether an operator is approved by a given owner.
344     * @param owner owner address which you want to query the approval of
345     * @param operator operator address which you want to query the approval of
346     * @return bool whether the given operator is approved by the given owner
347     */
348    function isApprovedForAll(address owner, address operator) public view returns (bool) {
349        return _operatorApprovals[owner][operator];
350    }
351 
352    /**
353     * @dev Transfers the ownership of a given token ID to another address.
354     * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
355     * Requires the msg.sender to be the owner, approved, or operator.
356     * @param from current owner of the token
357     * @param to address to receive the ownership of the given token ID
358     * @param tokenId uint256 ID of the token to be transferred
359     */
360    function transferFrom(address from, address to, uint256 tokenId) public {
361        //solhint-disable-next-line max-line-length
362        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
363 
364        _transferFrom(from, to, tokenId);
365    }
366 
367    /**
368     * @dev Safely transfers the ownership of a given token ID to another address
369     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
370     * which is called upon a safe transfer, and return the magic value
371     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
372     * the transfer is reverted.
373     * Requires the msg.sender to be the owner, approved, or operator
374     * @param from current owner of the token
375     * @param to address to receive the ownership of the given token ID
376     * @param tokenId uint256 ID of the token to be transferred
377     */
378    function safeTransferFrom(address from, address to, uint256 tokenId) public {
379        safeTransferFrom(from, to, tokenId, "");
380    }
381 
382    /**
383     * @dev Safely transfers the ownership of a given token ID to another address
384     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
385     * which is called upon a safe transfer, and return the magic value
386     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
387     * the transfer is reverted.
388     * Requires the _msgSender() to be the owner, approved, or operator
389     * @param from current owner of the token
390     * @param to address to receive the ownership of the given token ID
391     * @param tokenId uint256 ID of the token to be transferred
392     * @param _data bytes data to send along with a safe transfer check
393     */
394    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
395        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
396        _safeTransferFrom(from, to, tokenId, _data);
397    }
398 
399    /**
400     * @dev Safely transfers the ownership of a given token ID to another address
401     * If the target address is a contract, it must implement `onERC721Received`,
402     * which is called upon a safe transfer, and return the magic value
403     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
404     * the transfer is reverted.
405     * Requires the msg.sender to be the owner, approved, or operator
406     * @param from current owner of the token
407     * @param to address to receive the ownership of the given token ID
408     * @param tokenId uint256 ID of the token to be transferred
409     * @param _data bytes data to send along with a safe transfer check
410     */
411    function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
412        _transferFrom(from, to, tokenId);
413        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
414    }
415 
416    /**
417     * @dev Returns whether the specified token exists.
418     * @param tokenId uint256 ID of the token to query the existence of
419     * @return bool whether the token exists
420     */
421    function _exists(uint256 tokenId) internal view returns (bool) {
422        address owner = _tokenOwner[tokenId];
423        return owner != address(0);
424    }
425 
426    /**
427     * @dev Returns whether the given spender can transfer a given token ID.
428     * @param spender address of the spender to query
429     * @param tokenId uint256 ID of the token to be transferred
430     * @return bool whether the msg.sender is approved for the given token ID,
431     * is an operator of the owner, or is the owner of the token
432     */
433    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
434        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
435        address owner = ownerOf(tokenId);
436        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
437    }
438 
439    /**
440     * @dev Internal function to safely mint a new token.
441     * Reverts if the given token ID already exists.
442     * If the target address is a contract, it must implement `onERC721Received`,
443     * which is called upon a safe transfer, and return the magic value
444     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
445     * the transfer is reverted.
446     * @param to The address that will own the minted token
447     * @param tokenId uint256 ID of the token to be minted
448     */
449    function _safeMint(address to, uint256 tokenId) internal {
450        _safeMint(to, tokenId, "");
451    }
452 
453    /**
454     * @dev Internal function to safely mint a new token.
455     * Reverts if the given token ID already exists.
456     * If the target address is a contract, it must implement `onERC721Received`,
457     * which is called upon a safe transfer, and return the magic value
458     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
459     * the transfer is reverted.
460     * @param to The address that will own the minted token
461     * @param tokenId uint256 ID of the token to be minted
462     * @param _data bytes data to send along with a safe transfer check
463     */
464    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
465        _mint(to, tokenId);
466        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
467    }
468 
469    /**
470     * @dev Internal function to mint a new token.
471     * Reverts if the given token ID already exists.
472     * @param to The address that will own the minted token
473     * @param tokenId uint256 ID of the token to be minted
474     */
475    function _mint(address to, uint256 tokenId) internal {
476        require(to != address(0), "ERC721: mint to the zero address");
477        require(!_exists(tokenId), "ERC721: token already minted");
478 
479        _tokenOwner[tokenId] = to;
480        _ownedTokensCount[to].increment();
481 
482        emit Transfer(address(0), to, tokenId);
483    }
484 
485    /**
486     * @dev Internal function to burn a specific token.
487     * Reverts if the token does not exist.
488     * Deprecated, use {_burn} instead.
489     * @param owner owner of the token to burn
490     * @param tokenId uint256 ID of the token being burned
491     */
492    function _burn(address owner, uint256 tokenId) internal {
493        require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
494 
495        _clearApproval(tokenId);
496 
497        _ownedTokensCount[owner].decrement();
498        _tokenOwner[tokenId] = address(0);
499 
500        emit Transfer(owner, address(0), tokenId);
501    }
502 
503    /**
504     * @dev Internal function to burn a specific token.
505     * Reverts if the token does not exist.
506     * @param tokenId uint256 ID of the token being burned
507     */
508    function _burn(uint256 tokenId) internal {
509        _burn(ownerOf(tokenId), tokenId);
510    }
511 
512    /**
513     * @dev Internal function to transfer ownership of a given token ID to another address.
514     * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
515     * @param from current owner of the token
516     * @param to address to receive the ownership of the given token ID
517     * @param tokenId uint256 ID of the token to be transferred
518     */
519    function _transferFrom(address from, address to, uint256 tokenId) internal {
520        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
521        require(to != address(0), "ERC721: transfer to the zero address");
522 
523        _clearApproval(tokenId);
524 
525        _ownedTokensCount[from].decrement();
526        _ownedTokensCount[to].increment();
527 
528        _tokenOwner[tokenId] = to;
529 
530        emit Transfer(from, to, tokenId);
531    }
532 
533    /**
534     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
535     * The call is not executed if the target address is not a contract.
536     *
537     * This function is deprecated.
538     * @param from address representing the previous owner of the given token ID
539     * @param to target address that will receive the tokens
540     * @param tokenId uint256 ID of the token to be transferred
541     * @param _data bytes optional data to send along with the call
542     * @return bool whether the call correctly returned the expected magic value
543     */
544    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
545        internal returns (bool)
546    {
547        if (!to.isContract()) {
548            return true;
549        }
550 
551        bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
552        return (retval == _ERC721_RECEIVED);
553    }
554 
555    /**
556     * @dev Private function to clear current approval of a given token ID.
557     * @param tokenId uint256 ID of the token to be transferred
558     */
559    function _clearApproval(uint256 tokenId) private {
560        if (_tokenApprovals[tokenId] != address(0)) {
561            _tokenApprovals[tokenId] = address(0);
562        }
563    }
564 }
565 
566 /**
567 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
568 * @dev See https://eips.ethereum.org/EIPS/eip-721
569 */
570 contract IERC721Enumerable is IERC721 {
571    function totalSupply() public view returns (uint256);
572    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
573 
574    function tokenByIndex(uint256 index) public view returns (uint256);
575 }
576 
577 /**
578 * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
579 * @dev See https://eips.ethereum.org/EIPS/eip-721
580 */
581 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
582    // Mapping from owner to list of owned token IDs
583    mapping(address => uint256[]) private _ownedTokens;
584 
585    // Mapping from token ID to index of the owner tokens list
586    mapping(uint256 => uint256) private _ownedTokensIndex;
587 
588    // Array with all token ids, used for enumeration
589    uint256[] private _allTokens;
590 
591    // Mapping from token id to position in the allTokens array
592    mapping(uint256 => uint256) private _allTokensIndex;
593 
594    /*
595     *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
596     *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
597     *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
598     *
599     *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
600     */
601    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
602 
603    /**
604     * @dev Constructor function.
605     */
606    constructor () public {
607        // register the supported interface to conform to ERC721Enumerable via ERC165
608        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
609    }
610 
611    /**
612     * @dev Gets the token ID at a given index of the tokens list of the requested owner.
613     * @param owner address owning the tokens list to be accessed
614     * @param index uint256 representing the index to be accessed of the requested tokens list
615     * @return uint256 token ID at the given index of the tokens list owned by the requested address
616     */
617    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
618        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
619        return _ownedTokens[owner][index];
620    }
621 
622    /**
623     * @dev Gets the total amount of tokens stored by the contract.
624     * @return uint256 representing the total amount of tokens
625     */
626    function totalSupply() public view returns (uint256) {
627        return _allTokens.length;
628    }
629 
630    /**
631     * @dev Gets the token ID at a given index of all the tokens in this contract
632     * Reverts if the index is greater or equal to the total number of tokens.
633     * @param index uint256 representing the index to be accessed of the tokens list
634     * @return uint256 token ID at the given index of the tokens list
635     */
636    function tokenByIndex(uint256 index) public view returns (uint256) {
637        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
638        return _allTokens[index];
639    }
640 
641    /**
642     * @dev Internal function to transfer ownership of a given token ID to another address.
643     * As opposed to transferFrom, this imposes no restrictions on msg.sender.
644     * @param from current owner of the token
645     * @param to address to receive the ownership of the given token ID
646     * @param tokenId uint256 ID of the token to be transferred
647     */
648    function _transferFrom(address from, address to, uint256 tokenId) internal {
649        super._transferFrom(from, to, tokenId);
650 
651        _removeTokenFromOwnerEnumeration(from, tokenId);
652 
653        _addTokenToOwnerEnumeration(to, tokenId);
654    }
655 
656    /**
657     * @dev Internal function to mint a new token.
658     * Reverts if the given token ID already exists.
659     * @param to address the beneficiary that will own the minted token
660     * @param tokenId uint256 ID of the token to be minted
661     */
662    function _mint(address to, uint256 tokenId) internal {
663        super._mint(to, tokenId);
664 
665        _addTokenToOwnerEnumeration(to, tokenId);
666 
667        _addTokenToAllTokensEnumeration(tokenId);
668    }
669 
670    /**
671     * @dev Internal function to burn a specific token.
672     * Reverts if the token does not exist.
673     * Deprecated, use {ERC721-_burn} instead.
674     * @param owner owner of the token to burn
675     * @param tokenId uint256 ID of the token being burned
676     */
677    function _burn(address owner, uint256 tokenId) internal {
678        super._burn(owner, tokenId);
679 
680        _removeTokenFromOwnerEnumeration(owner, tokenId);
681        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
682        _ownedTokensIndex[tokenId] = 0;
683 
684        _removeTokenFromAllTokensEnumeration(tokenId);
685    }
686 
687    /**
688     * @dev Gets the list of token IDs of the requested owner.
689     * @param owner address owning the tokens
690     * @return uint256[] List of token IDs owned by the requested address
691     */
692    function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
693        return _ownedTokens[owner];
694    }
695 
696    /**
697     * @dev Private function to add a token to this extension's ownership-tracking data structures.
698     * @param to address representing the new owner of the given token ID
699     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
700     */
701    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
702        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
703        _ownedTokens[to].push(tokenId);
704    }
705 
706    /**
707     * @dev Private function to add a token to this extension's token tracking data structures.
708     * @param tokenId uint256 ID of the token to be added to the tokens list
709     */
710    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
711        _allTokensIndex[tokenId] = _allTokens.length;
712        _allTokens.push(tokenId);
713    }
714 
715    /**
716     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
717     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
718     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
719     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
720     * @param from address representing the previous owner of the given token ID
721     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
722     */
723    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
724        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
725        // then delete the last slot (swap and pop).
726 
727        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
728        uint256 tokenIndex = _ownedTokensIndex[tokenId];
729 
730        // When the token to delete is the last token, the swap operation is unnecessary
731        if (tokenIndex != lastTokenIndex) {
732            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
733 
734            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
735            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
736        }
737 
738        // This also deletes the contents at the last position of the array
739        _ownedTokens[from].length--;
740 
741        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
742        // lastTokenId, or just over the end of the array if the token was the last one).
743    }
744 
745    /**
746     * @dev Private function to remove a token from this extension's token tracking data structures.
747     * This has O(1) time complexity, but alters the order of the _allTokens array.
748     * @param tokenId uint256 ID of the token to be removed from the tokens list
749     */
750    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
751        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
752        // then delete the last slot (swap and pop).
753 
754        uint256 lastTokenIndex = _allTokens.length.sub(1);
755        uint256 tokenIndex = _allTokensIndex[tokenId];
756 
757        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
758        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
759        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
760        uint256 lastTokenId = _allTokens[lastTokenIndex];
761 
762        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
763        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
764 
765        // This also deletes the contents at the last position of the array
766        _allTokens.length--;
767        _allTokensIndex[tokenId] = 0;
768    }
769 }
770 
771 /**
772 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
773 * @dev See https://eips.ethereum.org/EIPS/eip-721
774 */
775 contract IERC721Metadata is IERC721 {
776    function name() external view returns (string memory);
777    function symbol() external view returns (string memory);
778    function tokenURI(uint256 tokenId) external view returns (string memory);
779 }
780 
781 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
782    // Token name
783    string private _name;
784 
785    // Token symbol
786    string private _symbol;
787 
788    // Optional mapping for token URIs
789    mapping(uint256 => string) private _tokenURIs;
790   
791    
792    //Optional mapping for IPFS link to canonical image file
793    mapping(uint256 => string) private _tokenIPFSHashes;
794 
795    /*
796     *     bytes4(keccak256('name()')) == 0x06fdde03
797     *     bytes4(keccak256('symbol()')) == 0x95d89b41
798     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
799     *
800     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
801     */
802    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
803 
804    /**
805     * @dev Constructor function
806     */
807    constructor (string memory name, string memory symbol) public {
808        _name = name;
809        _symbol = symbol;
810 
811        // register the supported interfaces to conform to ERC721 via ERC165
812        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
813    }
814 
815    /**
816     * @dev Gets the token name.
817     * @return string representing the token name
818     */
819    function name() external view returns (string memory) {
820        return _name;
821    }
822 
823    /**
824     * @dev Gets the token symbol.
825     * @return string representing the token symbol
826     */
827    function symbol() external view returns (string memory) {
828        return _symbol;
829    }
830 
831    /**
832     * @dev Returns an URI for a given token ID.
833     * Throws if the token ID does not exist. May return an empty string.
834     * @param tokenId uint256 ID of the token to query
835     */
836    function tokenURI(uint256 tokenId) external view returns (string memory) {
837        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
838        return _tokenURIs[tokenId];
839    }
840    
841    
842      /**
843     * @dev Returns an URI for a given token ID.
844     * Throws if the token ID does not exist. May return an empty string.
845     * @param tokenId uint256 ID of the token to query
846     */
847    function tokenIPFSHash(uint256 tokenId) external view returns (string memory) {
848        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
849        return _tokenIPFSHashes[tokenId];
850    }
851 
852    /**
853     * @dev Internal function to set the token URI for a given token.
854     * Reverts if the token ID does not exist.
855     * @param tokenId uint256 ID of the token to set its URI
856     * @param uri string URI to assign
857     */
858    function _setTokenURI(uint256 tokenId, string memory uri) internal {
859        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
860        _tokenURIs[tokenId] = uri;
861    }
862    
863       /**
864     * @dev Internal function to set the token IPFS hash for a given token.
865     * Reverts if the token ID does not exist.
866     * @param tokenId uint256 ID of the token to set its URI
867     * @param ipfs_hash string IPFS link to assign
868     */
869    function _setTokenIPFSHash(uint256 tokenId, string memory ipfs_hash) internal {
870        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
871        _tokenIPFSHashes[tokenId] = ipfs_hash;
872    }
873    
874    
875 
876    /**
877     * @dev Internal function to burn a specific token.
878     * Reverts if the token does not exist.
879     * Deprecated, use _burn(uint256) instead.
880     * @param owner owner of the token to burn
881     * @param tokenId uint256 ID of the token being burned by the msg.sender
882     */
883    function _burn(address owner, uint256 tokenId) internal {
884        super._burn(owner, tokenId);
885 
886        // Clear metadata (if any)
887        if (bytes(_tokenURIs[tokenId]).length != 0) {
888            delete _tokenURIs[tokenId];
889        }
890    }
891 }
892 
893 
894 /**
895 * @title Full ERC721 Token
896 * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
897 * Moreover, it includes approve all functionality using operator terminology.
898 *
899 * See https://eips.ethereum.org/EIPS/eip-721
900 */
901 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
902    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
903        // solhint-disable-previous-line no-empty-blocks
904    }
905 }
906 
907 
908 contract NiftyBuilderInstance is ERC721Full {
909 
910    //MODIFIERS
911 
912    modifier onlyValidSender() {
913        NiftyRegistry nftg_registry = NiftyRegistry(niftyRegistryContract);
914        bool is_valid = nftg_registry.isValidNiftySender(msg.sender);
915        require(is_valid==true);
916        _;
917    }
918 
919    //CONSTANTS
920 
921    // how many nifties this contract is selling
922    // used for metadat retrieval
923    uint public numNiftiesCurrentlyInContract;
924 
925    //id of this contract for metadata server
926    uint public contractId;
927 
928    //baseURI for metadata server
929    string public baseURI;
930 
931 //   //name of creator
932 //   string public creatorName;
933 
934    string public nameOfCreator;
935 
936    //nifty registry contract
937    address public niftyRegistryContract = 0x6e53130dDfF21E3BC963Ee902005223b9A202106;
938 
939    //master builder - ONLY DOES STATIC CALLS
940    address public masterBuilderContract = 0x6EFB06cF568253a53C7511BD3c31AB28BecB0192;
941 
942    using Counters for Counters.Counter;
943 
944    //MAPPINGS
945 
946    //mappings for token Ids
947    mapping (uint => Counters.Counter) public _numNiftyMinted;
948    mapping (uint => uint) public _numNiftyPermitted;
949    mapping (uint => uint) public _niftyPrice;
950    mapping (uint => string) public _niftyIPFSHashes;
951    mapping (uint => bool) public _IPFSHashHasBeenSet;
952 
953    //EVENTS
954 
955    //purchase + creation events
956    event NiftyPurchased(address _buyer, uint256 _amount, uint _tokenId);
957    event NiftyCreated(address new_owner, uint _niftyType, uint _tokenId);
958 
959    //CONSTRUCTOR FUNCTION
960 
961    constructor(
962        string memory _name,
963        string memory _symbol,
964        uint contract_id,
965        uint num_nifties,
966        uint[] memory nifty_quantities,
967        string memory base_uri,
968        string memory name_of_creator) ERC721Full(_name, _symbol) public {
969 
970        //set local variables based on inputs
971        contractId = contract_id;
972        numNiftiesCurrentlyInContract = num_nifties;
973        baseURI = base_uri;
974        nameOfCreator = name_of_creator;
975 
976        //offset starts at 1 - there is no niftyType of 0
977        for (uint i=0; i<(num_nifties); i++) {
978            _numNiftyPermitted[i+1] = nifty_quantities[i];
979        }
980    }
981    
982    function setNiftyIPFSHash(uint niftyType, 
983                             string memory ipfs_hash) onlyValidSender public {
984         //can only be set once
985         if (_IPFSHashHasBeenSet[niftyType] == true) {
986             revert("Can only be set once");
987         } else {
988             _niftyIPFSHashes[niftyType] = ipfs_hash;
989             _IPFSHashHasBeenSet[niftyType]  = true;
990         }
991     }
992 
993    function isNiftySoldOut(uint niftyType) public view returns (bool) {
994        if (niftyType > numNiftiesCurrentlyInContract) {
995            return true;
996        }
997        if (_numNiftyMinted[niftyType].current() > _numNiftyPermitted[niftyType]) {
998            return (true);
999        } else {
1000            return (false);
1001        }
1002    }
1003 
1004    function giftNifty(address collector_address, 
1005                       uint niftyType) onlyValidSender public {
1006        //master for static calls
1007        BuilderMaster bm = BuilderMaster(masterBuilderContract);
1008        _numNiftyMinted[niftyType].increment();
1009        //check if this nifty is sold out
1010        if (isNiftySoldOut(niftyType)==true) {
1011            revert("Nifty sold out!");
1012        }
1013        //mint a nifty
1014        uint specificTokenId = _numNiftyMinted[niftyType].current();
1015        uint tokenId = bm.encodeTokenId(contractId, niftyType, specificTokenId);
1016        string memory tokenIdStr = bm.uint2str(tokenId);
1017        string memory tokenURI = bm.strConcat(baseURI, tokenIdStr);
1018        string memory ipfsHash = _niftyIPFSHashes[niftyType];
1019        //mint token
1020        _mint(collector_address, tokenId);
1021        _setTokenURI(tokenId, tokenURI);
1022        _setTokenIPFSHash(tokenId, ipfsHash);
1023        //do events
1024        emit NiftyCreated(collector_address, niftyType, tokenId);
1025    }
1026 
1027 }
1028 
1029 contract NiftyRegistry {
1030    function isValidNiftySender(address sending_key) public view returns (bool);
1031    function isOwner(address owner_key) public view returns (bool);
1032 }
1033 
1034 contract BuilderMaster {
1035    function getContractId(uint tokenId) public view returns (uint);
1036    function getNiftyTypeId(uint tokenId) public view returns (uint);
1037    function getSpecificNiftyNum(uint tokenId) public view returns (uint);
1038    function encodeTokenId(uint contractId, uint niftyType, uint specificNiftyNum) public view returns (uint);
1039    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) public view returns (string memory);
1040    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) public view returns (string memory);
1041    function strConcat(string memory _a, string memory _b, string memory _c) public view returns (string memory);
1042    function strConcat(string memory _a, string memory _b) public view returns (string memory);
1043    function uint2str(uint _i) public view returns (string memory _uintAsString);
1044 }
1045 
1046 /**
1047 * Contracts and libraries below are from OpenZeppelin, except nifty builder instance
1048 **/
1049 
1050 
1051 /**
1052 * @dev Wrappers over Solidity's arithmetic operations with added overflow
1053 * checks.
1054 *
1055 * Arithmetic operations in Solidity wrap on overflow. This can easily result
1056 * in bugs, because programmers usually assume that an overflow raises an
1057 * error, which is the standard behavior in high level programming languages.
1058 * `SafeMath` restores this intuition by reverting the transaction when an
1059 * operation overflows.
1060 *
1061 * Using this library instead of the unchecked operations eliminates an entire
1062 * class of bugs, so it's recommended to use it always.
1063 */
1064 library SafeMath {
1065    /**
1066     * @dev Returns the addition of two unsigned integers, reverting on
1067     * overflow.
1068     *
1069     * Counterpart to Solidity's `+` operator.
1070     *
1071     * Requirements:
1072     * - Addition cannot overflow.
1073     */
1074    function add(uint256 a, uint256 b) internal pure returns (uint256) {
1075        uint256 c = a + b;
1076        require(c >= a, "SafeMath: addition overflow");
1077 
1078        return c;
1079    }
1080 
1081    /**
1082     * @dev Returns the subtraction of two unsigned integers, reverting on
1083     * overflow (when the result is negative).
1084     *
1085     * Counterpart to Solidity's `-` operator.
1086     *
1087     * Requirements:
1088     * - Subtraction cannot overflow.
1089     */
1090    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1091        return sub(a, b, "SafeMath: subtraction overflow");
1092    }
1093 
1094    /**
1095     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1096     * overflow (when the result is negative).
1097     *
1098     * Counterpart to Solidity's `-` operator.
1099     *
1100     * Requirements:
1101     * - Subtraction cannot overflow.
1102     *
1103     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1104     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1105     */
1106    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1107        require(b <= a, errorMessage);
1108        uint256 c = a - b;
1109 
1110        return c;
1111    }
1112 
1113    /**
1114     * @dev Returns the multiplication of two unsigned integers, reverting on
1115     * overflow.
1116     *
1117     * Counterpart to Solidity's `*` operator.
1118     *
1119     * Requirements:
1120     * - Multiplication cannot overflow.
1121     */
1122    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1123        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1124        // benefit is lost if 'b' is also tested.
1125        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1126        if (a == 0) {
1127            return 0;
1128        }
1129 
1130        uint256 c = a * b;
1131        require(c / a == b, "SafeMath: multiplication overflow");
1132 
1133        return c;
1134    }
1135 
1136    /**
1137     * @dev Returns the integer division of two unsigned integers. Reverts on
1138     * division by zero. The result is rounded towards zero.
1139     *
1140     * Counterpart to Solidity's `/` operator. Note: this function uses a
1141     * `revert` opcode (which leaves remaining gas untouched) while Solidity
1142     * uses an invalid opcode to revert (consuming all remaining gas).
1143     *
1144     * Requirements:
1145     * - The divisor cannot be zero.
1146     */
1147    function div(uint256 a, uint256 b) internal pure returns (uint256) {
1148        return div(a, b, "SafeMath: division by zero");
1149    }
1150 
1151    /**
1152     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1153     * division by zero. The result is rounded towards zero.
1154     *
1155     * Counterpart to Solidity's `/` operator. Note: this function uses a
1156     * `revert` opcode (which leaves remaining gas untouched) while Solidity
1157     * uses an invalid opcode to revert (consuming all remaining gas).
1158     *
1159     * Requirements:
1160     * - The divisor cannot be zero.
1161     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1162     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1163     */
1164    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1165        // Solidity only automatically asserts when dividing by 0
1166        require(b > 0, errorMessage);
1167        uint256 c = a / b;
1168        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1169 
1170        return c;
1171    }
1172 
1173    /**
1174     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1175     * Reverts when dividing by zero.
1176     *
1177     * Counterpart to Solidity's `%` operator. This function uses a `revert`
1178     * opcode (which leaves remaining gas untouched) while Solidity uses an
1179     * invalid opcode to revert (consuming all remaining gas).
1180     *
1181     * Requirements:
1182     * - The divisor cannot be zero.
1183     */
1184    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1185        return mod(a, b, "SafeMath: modulo by zero");
1186    }
1187 
1188    /**
1189     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1190     * Reverts with custom message when dividing by zero.
1191     *
1192     * Counterpart to Solidity's `%` operator. This function uses a `revert`
1193     * opcode (which leaves remaining gas untouched) while Solidity uses an
1194     * invalid opcode to revert (consuming all remaining gas).
1195     *
1196     * Requirements:
1197     * - The divisor cannot be zero.
1198     *
1199     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1200     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1201     */
1202    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1203        require(b != 0, errorMessage);
1204        return a % b;
1205    }
1206 }
1207 
1208 /**
1209 * @dev Collection of functions related to the address type
1210 */
1211 library Address {
1212    /**
1213     * @dev Returns true if `account` is a contract.
1214     *
1215     * This test is non-exhaustive, and there may be false-negatives: during the
1216     * execution of a contract's constructor, its address will be reported as
1217     * not containing a contract.
1218     *
1219     * IMPORTANT: It is unsafe to assume that an address for which this
1220     * function returns false is an externally-owned account (EOA) and not a
1221     * contract.
1222     */
1223    function isContract(address account) internal view returns (bool) {
1224        // This method relies in extcodesize, which returns 0 for contracts in
1225        // construction, since the code is only stored at the end of the
1226        // constructor execution.
1227 
1228        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1229        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1230        // for accounts without code, i.e. `keccak256('')`
1231        bytes32 codehash;
1232        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1233        // solhint-disable-next-line no-inline-assembly
1234        assembly { codehash := extcodehash(account) }
1235        return (codehash != 0x0 && codehash != accountHash);
1236    }
1237 
1238    /**
1239     * @dev Converts an `address` into `address payable`. Note that this is
1240     * simply a type cast: the actual underlying value is not changed.
1241     *
1242     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1243     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1244     */
1245    function toPayable(address account) internal pure returns (address payable) {
1246        return address(uint160(account));
1247    }
1248 
1249    /**
1250     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1251     * `recipient`, forwarding all available gas and reverting on errors.
1252     *
1253     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1254     * of certain opcodes, possibly making contracts go over the 2300 gas limit
1255     * imposed by `transfer`, making them unable to receive funds via
1256     * `transfer`. {sendValue} removes this limitation.
1257     *
1258     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1259     *
1260     * IMPORTANT: because control is transferred to `recipient`, care must be
1261     * taken to not create reentrancy vulnerabilities. Consider using
1262     * {ReentrancyGuard} or the
1263     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1264     */
1265    function sendValue(address payable recipient, uint256 amount) internal {
1266        require(address(this).balance >= amount, "Address: insufficient balance");
1267 
1268        // solhint-disable-next-line avoid-call-value
1269        (bool success, ) = recipient.call.value(amount)("");
1270        require(success, "Address: unable to send value, recipient may have reverted");
1271    }
1272 }
1273 
1274 /**
1275 * @title Counters
1276 * @author Matt Condon (@shrugs)
1277 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1278 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1279 *
1280 * Include with `using Counters for Counters.Counter;`
1281 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1282 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1283 * directly accessed.
1284 */
1285 library Counters {
1286    using SafeMath for uint256;
1287 
1288    struct Counter {
1289        // This variable should never be directly accessed by users of the library: interactions must be restricted to
1290        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1291        // this feature: see https://github.com/ethereum/solidity/issues/4637
1292        uint256 _value; // default: 0
1293    }
1294 
1295    function current(Counter storage counter) internal view returns (uint256) {
1296        return counter._value;
1297    }
1298 
1299    function increment(Counter storage counter) internal {
1300        // The {SafeMath} overflow check can be skipped here, see the comment at the top
1301        counter._value += 1;
1302    }
1303 
1304    function decrement(Counter storage counter) internal {
1305        counter._value = counter._value.sub(1);
1306    }
1307 }