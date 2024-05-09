1 pragma solidity ^0.5.0;
2 
3 contract PackBuilderShop {
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
32        string memory creator_name) public onlyValidSender returns (NiftyBuilderInstance tokenAddress) {
33 
34        contractId = contractId + 1;
35 
36        NiftyBuilderInstance new_contract = new NiftyBuilderInstance(
37            _name,
38            _symbol,
39            contractId,
40            num_nifties,
41            nifty_quantities,
42            token_base_uri,
43            creator_name
44        );
45 
46        address externalId = address(new_contract);
47 
48        BuilderShops[externalId] = true;
49 
50        emit BuilderInstanceCreated(externalId, contractId);
51 
52        return (new_contract);
53     }
54 }
55 
56 /*
57 * @dev Provides information about the current execution context, including the
58 * sender of the transaction and its data. While these are generally available
59 * via msg.sender and msg.data, they should not be accessed in such a direct
60 * manner, since when dealing with GSN meta-transactions the account sending and
61 * paying for execution may not be the actual sender (as far as an application
62 * is concerned).
63 *
64 * This contract is only required for intermediate, library-like contracts.
65 */
66 contract Context {
67    // Empty internal constructor, to prevent people from mistakenly deploying
68    // an instance of this contract, which should be used via inheritance.
69    constructor () internal { }
70    // solhint-disable-previous-line no-empty-blocks
71 
72    function _msgSender() internal view returns (address payable) {
73        return msg.sender;
74    }
75 
76    function _msgData() internal view returns (bytes memory) {
77        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
78        return msg.data;
79    }
80 }
81 
82 /**
83 * @dev Interface of the ERC165 standard, as defined in the
84 * https://eips.ethereum.org/EIPS/eip-165[EIP].
85 *
86 * Implementers can declare support of contract interfaces, which can then be
87 * queried by others ({ERC165Checker}).
88 *
89 * For an implementation, see {ERC165}.
90 */
91 interface IERC165 {
92    /**
93     * @dev Returns true if this contract implements the interface defined by
94     * `interfaceId`. See the corresponding
95     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
96     * to learn more about how these ids are created.
97     *
98     * This function call must use less than 30 000 gas.
99     */
100    function supportsInterface(bytes4 interfaceId) external view returns (bool);
101 }
102 
103 /**
104 * @dev Implementation of the {IERC165} interface.
105 *
106 * Contracts may inherit from this and call {_registerInterface} to declare
107 * their support of an interface.
108 */
109 contract ERC165 is IERC165 {
110    /*
111     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
112     */
113    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
114 
115    /**
116     * @dev Mapping of interface ids to whether or not it's supported.
117     */
118    mapping(bytes4 => bool) private _supportedInterfaces;
119 
120    constructor () internal {
121        // Derived contracts need only register support for their own interfaces,
122        // we register support for ERC165 itself here
123        _registerInterface(_INTERFACE_ID_ERC165);
124    }
125 
126    /**
127     * @dev See {IERC165-supportsInterface}.
128     *
129     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
130     */
131    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
132        return _supportedInterfaces[interfaceId];
133    }
134 
135    /**
136     * @dev Registers the contract as an implementer of the interface defined by
137     * `interfaceId`. Support of the actual ERC165 interface is automatic and
138     * registering its interface id is not required.
139     *
140     * See {IERC165-supportsInterface}.
141     *
142     * Requirements:
143     *
144     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
145     */
146    function _registerInterface(bytes4 interfaceId) internal {
147        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
148        _supportedInterfaces[interfaceId] = true;
149    }
150 }
151 
152 /**
153 * @dev Required interface of an ERC721 compliant contract.
154 */
155 contract IERC721 is IERC165 {
156    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
157    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
158    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
159 
160    /**
161     * @dev Returns the number of NFTs in `owner`'s account.
162     */
163    function balanceOf(address owner) public view returns (uint256 balance);
164 
165    /**
166     * @dev Returns the owner of the NFT specified by `tokenId`.
167     */
168    function ownerOf(uint256 tokenId) public view returns (address owner);
169 
170    /**
171     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
172     * another (`to`).
173     *
174     *
175     *
176     * Requirements:
177     * - `from`, `to` cannot be zero.
178     * - `tokenId` must be owned by `from`.
179     * - If the caller is not `from`, it must be have been allowed to move this
180     * NFT by either {approve} or {setApprovalForAll}.
181     */
182    function safeTransferFrom(address from, address to, uint256 tokenId) public;
183    /**
184     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
185     * another (`to`).
186     *
187     * Requirements:
188     * - If the caller is not `from`, it must be approved to move this NFT by
189     * either {approve} or {setApprovalForAll}.
190     */
191    function transferFrom(address from, address to, uint256 tokenId) public;
192    function approve(address to, uint256 tokenId) public;
193    function getApproved(uint256 tokenId) public view returns (address operator);
194 
195    function setApprovalForAll(address operator, bool _approved) public;
196    function isApprovedForAll(address owner, address operator) public view returns (bool);
197 
198 
199    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
200 }
201 
202 /**
203 * @title ERC721 token receiver interface
204 * @dev Interface for any contract that wants to support safeTransfers
205 * from ERC721 asset contracts.
206 */
207 contract IERC721Receiver {
208    /**
209     * @notice Handle the receipt of an NFT
210     * @dev The ERC721 smart contract calls this function on the recipient
211     * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
212     * otherwise the caller will revert the transaction. The selector to be
213     * returned can be obtained as `this.onERC721Received.selector`. This
214     * function MAY throw to revert and reject the transfer.
215     * Note: the ERC721 contract address is always the message sender.
216     * @param operator The address which called `safeTransferFrom` function
217     * @param from The address which previously owned the token
218     * @param tokenId The NFT identifier which is being transferred
219     * @param data Additional data with no specified format
220     * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
221     */
222    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
223    public returns (bytes4);
224 }
225 
226 /**
227 * @title ERC721 Non-Fungible Token Standard basic implementation
228 * @dev see https://eips.ethereum.org/EIPS/eip-721
229 */
230 contract ERC721 is Context, ERC165, IERC721 {
231    using SafeMath for uint256;
232    using Address for address;
233    using Counters for Counters.Counter;
234 
235    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
236    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
237    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
238 
239    // Mapping from token ID to owner
240    mapping (uint256 => address) private _tokenOwner;
241 
242    // Mapping from token ID to approved address
243    mapping (uint256 => address) private _tokenApprovals;
244 
245    // Mapping from owner to number of owned token
246    mapping (address => Counters.Counter) private _ownedTokensCount;
247 
248    // Mapping from owner to operator approvals
249    mapping (address => mapping (address => bool)) private _operatorApprovals;
250 
251    /*
252     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
253     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
254     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
255     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
256     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
257     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
258     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
259     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
260     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
261     *
262     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
263     *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
264     */
265    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
266 
267    constructor () public {
268        // register the supported interfaces to conform to ERC721 via ERC165
269        _registerInterface(_INTERFACE_ID_ERC721);
270    }
271 
272    /**
273     * @dev Gets the balance of the specified address.
274     * @param owner address to query the balance of
275     * @return uint256 representing the amount owned by the passed address
276     */
277    function balanceOf(address owner) public view returns (uint256) {
278        require(owner != address(0), "ERC721: balance query for the zero address");
279 
280        return _ownedTokensCount[owner].current();
281    }
282 
283    /**
284     * @dev Gets the owner of the specified token ID.
285     * @param tokenId uint256 ID of the token to query the owner of
286     * @return address currently marked as the owner of the given token ID
287     */
288    function ownerOf(uint256 tokenId) public view returns (address) {
289        address owner = _tokenOwner[tokenId];
290        require(owner != address(0), "ERC721: owner query for nonexistent token");
291 
292        return owner;
293    }
294 
295    /**
296     * @dev Approves another address to transfer the given token ID
297     * The zero address indicates there is no approved address.
298     * There can only be one approved address per token at a given time.
299     * Can only be called by the token owner or an approved operator.
300     * @param to address to be approved for the given token ID
301     * @param tokenId uint256 ID of the token to be approved
302     */
303    function approve(address to, uint256 tokenId) public {
304        address owner = ownerOf(tokenId);
305        require(to != owner, "ERC721: approval to current owner");
306 
307        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
308            "ERC721: approve caller is not owner nor approved for all"
309        );
310 
311        _tokenApprovals[tokenId] = to;
312        emit Approval(owner, to, tokenId);
313    }
314 
315    /**
316     * @dev Gets the approved address for a token ID, or zero if no address set
317     * Reverts if the token ID does not exist.
318     * @param tokenId uint256 ID of the token to query the approval of
319     * @return address currently approved for the given token ID
320     */
321    function getApproved(uint256 tokenId) public view returns (address) {
322        require(_exists(tokenId), "ERC721: approved query for nonexistent token");
323 
324        return _tokenApprovals[tokenId];
325    }
326 
327    /**
328     * @dev Sets or unsets the approval of a given operator
329     * An operator is allowed to transfer all tokens of the sender on their behalf.
330     * @param to operator address to set the approval
331     * @param approved representing the status of the approval to be set
332     */
333    function setApprovalForAll(address to, bool approved) public {
334        require(to != _msgSender(), "ERC721: approve to caller");
335 
336        _operatorApprovals[_msgSender()][to] = approved;
337        emit ApprovalForAll(_msgSender(), to, approved);
338    }
339 
340    /**
341     * @dev Tells whether an operator is approved by a given owner.
342     * @param owner owner address which you want to query the approval of
343     * @param operator operator address which you want to query the approval of
344     * @return bool whether the given operator is approved by the given owner
345     */
346    function isApprovedForAll(address owner, address operator) public view returns (bool) {
347        return _operatorApprovals[owner][operator];
348    }
349 
350    /**
351     * @dev Transfers the ownership of a given token ID to another address.
352     * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
353     * Requires the msg.sender to be the owner, approved, or operator.
354     * @param from current owner of the token
355     * @param to address to receive the ownership of the given token ID
356     * @param tokenId uint256 ID of the token to be transferred
357     */
358    function transferFrom(address from, address to, uint256 tokenId) public {
359        //solhint-disable-next-line max-line-length
360        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
361 
362        _transferFrom(from, to, tokenId);
363    }
364 
365    /**
366     * @dev Safely transfers the ownership of a given token ID to another address
367     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
368     * which is called upon a safe transfer, and return the magic value
369     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
370     * the transfer is reverted.
371     * Requires the msg.sender to be the owner, approved, or operator
372     * @param from current owner of the token
373     * @param to address to receive the ownership of the given token ID
374     * @param tokenId uint256 ID of the token to be transferred
375     */
376    function safeTransferFrom(address from, address to, uint256 tokenId) public {
377        safeTransferFrom(from, to, tokenId, "");
378    }
379 
380    /**
381     * @dev Safely transfers the ownership of a given token ID to another address
382     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
383     * which is called upon a safe transfer, and return the magic value
384     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
385     * the transfer is reverted.
386     * Requires the _msgSender() to be the owner, approved, or operator
387     * @param from current owner of the token
388     * @param to address to receive the ownership of the given token ID
389     * @param tokenId uint256 ID of the token to be transferred
390     * @param _data bytes data to send along with a safe transfer check
391     */
392    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
393        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
394        _safeTransferFrom(from, to, tokenId, _data);
395    }
396 
397    /**
398     * @dev Safely transfers the ownership of a given token ID to another address
399     * If the target address is a contract, it must implement `onERC721Received`,
400     * which is called upon a safe transfer, and return the magic value
401     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
402     * the transfer is reverted.
403     * Requires the msg.sender to be the owner, approved, or operator
404     * @param from current owner of the token
405     * @param to address to receive the ownership of the given token ID
406     * @param tokenId uint256 ID of the token to be transferred
407     * @param _data bytes data to send along with a safe transfer check
408     */
409    function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
410        _transferFrom(from, to, tokenId);
411        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
412    }
413 
414    /**
415     * @dev Returns whether the specified token exists.
416     * @param tokenId uint256 ID of the token to query the existence of
417     * @return bool whether the token exists
418     */
419    function _exists(uint256 tokenId) internal view returns (bool) {
420        address owner = _tokenOwner[tokenId];
421        return owner != address(0);
422    }
423 
424    /**
425     * @dev Returns whether the given spender can transfer a given token ID.
426     * @param spender address of the spender to query
427     * @param tokenId uint256 ID of the token to be transferred
428     * @return bool whether the msg.sender is approved for the given token ID,
429     * is an operator of the owner, or is the owner of the token
430     */
431    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
432        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
433        address owner = ownerOf(tokenId);
434        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
435    }
436 
437    /**
438     * @dev Internal function to safely mint a new token.
439     * Reverts if the given token ID already exists.
440     * If the target address is a contract, it must implement `onERC721Received`,
441     * which is called upon a safe transfer, and return the magic value
442     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
443     * the transfer is reverted.
444     * @param to The address that will own the minted token
445     * @param tokenId uint256 ID of the token to be minted
446     */
447    function _safeMint(address to, uint256 tokenId) internal {
448        _safeMint(to, tokenId, "");
449    }
450 
451    /**
452     * @dev Internal function to safely mint a new token.
453     * Reverts if the given token ID already exists.
454     * If the target address is a contract, it must implement `onERC721Received`,
455     * which is called upon a safe transfer, and return the magic value
456     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
457     * the transfer is reverted.
458     * @param to The address that will own the minted token
459     * @param tokenId uint256 ID of the token to be minted
460     * @param _data bytes data to send along with a safe transfer check
461     */
462    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
463        _mint(to, tokenId);
464        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
465    }
466 
467    /**
468     * @dev Internal function to mint a new token.
469     * Reverts if the given token ID already exists.
470     * @param to The address that will own the minted token
471     * @param tokenId uint256 ID of the token to be minted
472     */
473    function _mint(address to, uint256 tokenId) internal {
474        require(to != address(0), "ERC721: mint to the zero address");
475        require(!_exists(tokenId), "ERC721: token already minted");
476 
477        _tokenOwner[tokenId] = to;
478        _ownedTokensCount[to].increment();
479 
480        emit Transfer(address(0), to, tokenId);
481    }
482 
483    /**
484     * @dev Internal function to burn a specific token.
485     * Reverts if the token does not exist.
486     * Deprecated, use {_burn} instead.
487     * @param owner owner of the token to burn
488     * @param tokenId uint256 ID of the token being burned
489     */
490    function _burn(address owner, uint256 tokenId) internal {
491        require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
492 
493        _clearApproval(tokenId);
494 
495        _ownedTokensCount[owner].decrement();
496        _tokenOwner[tokenId] = address(0);
497 
498        emit Transfer(owner, address(0), tokenId);
499    }
500 
501    /**
502     * @dev Internal function to burn a specific token.
503     * Reverts if the token does not exist.
504     * @param tokenId uint256 ID of the token being burned
505     */
506    function _burn(uint256 tokenId) internal {
507        _burn(ownerOf(tokenId), tokenId);
508    }
509 
510    /**
511     * @dev Internal function to transfer ownership of a given token ID to another address.
512     * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
513     * @param from current owner of the token
514     * @param to address to receive the ownership of the given token ID
515     * @param tokenId uint256 ID of the token to be transferred
516     */
517    function _transferFrom(address from, address to, uint256 tokenId) internal {
518        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
519        require(to != address(0), "ERC721: transfer to the zero address");
520 
521        _clearApproval(tokenId);
522 
523        _ownedTokensCount[from].decrement();
524        _ownedTokensCount[to].increment();
525 
526        _tokenOwner[tokenId] = to;
527 
528        emit Transfer(from, to, tokenId);
529    }
530 
531    /**
532     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
533     * The call is not executed if the target address is not a contract.
534     *
535     * This function is deprecated.
536     * @param from address representing the previous owner of the given token ID
537     * @param to target address that will receive the tokens
538     * @param tokenId uint256 ID of the token to be transferred
539     * @param _data bytes optional data to send along with the call
540     * @return bool whether the call correctly returned the expected magic value
541     */
542    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
543        internal returns (bool)
544    {
545        if (!to.isContract()) {
546            return true;
547        }
548 
549        bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
550        return (retval == _ERC721_RECEIVED);
551    }
552 
553    /**
554     * @dev Private function to clear current approval of a given token ID.
555     * @param tokenId uint256 ID of the token to be transferred
556     */
557    function _clearApproval(uint256 tokenId) private {
558        if (_tokenApprovals[tokenId] != address(0)) {
559            _tokenApprovals[tokenId] = address(0);
560        }
561    }
562 }
563 
564 /**
565 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
566 * @dev See https://eips.ethereum.org/EIPS/eip-721
567 */
568 contract IERC721Enumerable is IERC721 {
569    function totalSupply() public view returns (uint256);
570    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
571 
572    function tokenByIndex(uint256 index) public view returns (uint256);
573 }
574 
575 /**
576 * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
577 * @dev See https://eips.ethereum.org/EIPS/eip-721
578 */
579 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
580    // Mapping from owner to list of owned token IDs
581    mapping(address => uint256[]) private _ownedTokens;
582 
583    // Mapping from token ID to index of the owner tokens list
584    mapping(uint256 => uint256) private _ownedTokensIndex;
585 
586    // Array with all token ids, used for enumeration
587    uint256[] private _allTokens;
588 
589    // Mapping from token id to position in the allTokens array
590    mapping(uint256 => uint256) private _allTokensIndex;
591 
592    /*
593     *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
594     *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
595     *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
596     *
597     *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
598     */
599    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
600 
601    /**
602     * @dev Constructor function.
603     */
604    constructor () public {
605        // register the supported interface to conform to ERC721Enumerable via ERC165
606        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
607    }
608 
609    /**
610     * @dev Gets the token ID at a given index of the tokens list of the requested owner.
611     * @param owner address owning the tokens list to be accessed
612     * @param index uint256 representing the index to be accessed of the requested tokens list
613     * @return uint256 token ID at the given index of the tokens list owned by the requested address
614     */
615    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
616        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
617        return _ownedTokens[owner][index];
618    }
619 
620    /**
621     * @dev Gets the total amount of tokens stored by the contract.
622     * @return uint256 representing the total amount of tokens
623     */
624    function totalSupply() public view returns (uint256) {
625        return _allTokens.length;
626    }
627 
628    /**
629     * @dev Gets the token ID at a given index of all the tokens in this contract
630     * Reverts if the index is greater or equal to the total number of tokens.
631     * @param index uint256 representing the index to be accessed of the tokens list
632     * @return uint256 token ID at the given index of the tokens list
633     */
634    function tokenByIndex(uint256 index) public view returns (uint256) {
635        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
636        return _allTokens[index];
637    }
638 
639    /**
640     * @dev Internal function to transfer ownership of a given token ID to another address.
641     * As opposed to transferFrom, this imposes no restrictions on msg.sender.
642     * @param from current owner of the token
643     * @param to address to receive the ownership of the given token ID
644     * @param tokenId uint256 ID of the token to be transferred
645     */
646    function _transferFrom(address from, address to, uint256 tokenId) internal {
647        super._transferFrom(from, to, tokenId);
648 
649        _removeTokenFromOwnerEnumeration(from, tokenId);
650 
651        _addTokenToOwnerEnumeration(to, tokenId);
652    }
653 
654    /**
655     * @dev Internal function to mint a new token.
656     * Reverts if the given token ID already exists.
657     * @param to address the beneficiary that will own the minted token
658     * @param tokenId uint256 ID of the token to be minted
659     */
660    function _mint(address to, uint256 tokenId) internal {
661        super._mint(to, tokenId);
662 
663        _addTokenToOwnerEnumeration(to, tokenId);
664 
665        _addTokenToAllTokensEnumeration(tokenId);
666    }
667 
668    /**
669     * @dev Internal function to burn a specific token.
670     * Reverts if the token does not exist.
671     * Deprecated, use {ERC721-_burn} instead.
672     * @param owner owner of the token to burn
673     * @param tokenId uint256 ID of the token being burned
674     */
675    function _burn(address owner, uint256 tokenId) internal {
676        super._burn(owner, tokenId);
677 
678        _removeTokenFromOwnerEnumeration(owner, tokenId);
679        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
680        _ownedTokensIndex[tokenId] = 0;
681 
682        _removeTokenFromAllTokensEnumeration(tokenId);
683    }
684 
685    /**
686     * @dev Gets the list of token IDs of the requested owner.
687     * @param owner address owning the tokens
688     * @return uint256[] List of token IDs owned by the requested address
689     */
690    function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
691        return _ownedTokens[owner];
692    }
693 
694    /**
695     * @dev Private function to add a token to this extension's ownership-tracking data structures.
696     * @param to address representing the new owner of the given token ID
697     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
698     */
699    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
700        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
701        _ownedTokens[to].push(tokenId);
702    }
703 
704    /**
705     * @dev Private function to add a token to this extension's token tracking data structures.
706     * @param tokenId uint256 ID of the token to be added to the tokens list
707     */
708    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
709        _allTokensIndex[tokenId] = _allTokens.length;
710        _allTokens.push(tokenId);
711    }
712 
713    /**
714     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
715     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
716     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
717     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
718     * @param from address representing the previous owner of the given token ID
719     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
720     */
721    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
722        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
723        // then delete the last slot (swap and pop).
724 
725        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
726        uint256 tokenIndex = _ownedTokensIndex[tokenId];
727 
728        // When the token to delete is the last token, the swap operation is unnecessary
729        if (tokenIndex != lastTokenIndex) {
730            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
731 
732            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
733            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
734        }
735 
736        // This also deletes the contents at the last position of the array
737        _ownedTokens[from].length--;
738 
739        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
740        // lastTokenId, or just over the end of the array if the token was the last one).
741    }
742 
743    /**
744     * @dev Private function to remove a token from this extension's token tracking data structures.
745     * This has O(1) time complexity, but alters the order of the _allTokens array.
746     * @param tokenId uint256 ID of the token to be removed from the tokens list
747     */
748    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
749        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
750        // then delete the last slot (swap and pop).
751 
752        uint256 lastTokenIndex = _allTokens.length.sub(1);
753        uint256 tokenIndex = _allTokensIndex[tokenId];
754 
755        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
756        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
757        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
758        uint256 lastTokenId = _allTokens[lastTokenIndex];
759 
760        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
761        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
762 
763        // This also deletes the contents at the last position of the array
764        _allTokens.length--;
765        _allTokensIndex[tokenId] = 0;
766    }
767 }
768 
769 /**
770 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
771 * @dev See https://eips.ethereum.org/EIPS/eip-721
772 */
773 contract IERC721Metadata is IERC721 {
774    function name() external view returns (string memory);
775    function symbol() external view returns (string memory);
776    function tokenURI(uint256 tokenId) external view returns (string memory);
777 }
778 
779 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
780    // Token name
781    string private _name;
782 
783    // Token symbol
784    string private _symbol;
785 
786    // Optional mapping for token URIs
787    mapping(uint256 => string) private _tokenURIs;
788   
789    
790    //Optional mapping for IPFS link to canonical image file
791    mapping(uint256 => string) private _tokenIPFSHashes;
792 
793    /*
794     *     bytes4(keccak256('name()')) == 0x06fdde03
795     *     bytes4(keccak256('symbol()')) == 0x95d89b41
796     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
797     *
798     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
799     */
800    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
801 
802    /**
803     * @dev Constructor function
804     */
805    constructor (string memory name, string memory symbol) public {
806        _name = name;
807        _symbol = symbol;
808 
809        // register the supported interfaces to conform to ERC721 via ERC165
810        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
811    }
812 
813    /**
814     * @dev Gets the token name.
815     * @return string representing the token name
816     */
817    function name() external view returns (string memory) {
818        return _name;
819    }
820 
821    /**
822     * @dev Gets the token symbol.
823     * @return string representing the token symbol
824     */
825    function symbol() external view returns (string memory) {
826        return _symbol;
827    }
828 
829    /**
830     * @dev Returns an URI for a given token ID.
831     * Throws if the token ID does not exist. May return an empty string.
832     * @param tokenId uint256 ID of the token to query
833     */
834    function tokenURI(uint256 tokenId) external view returns (string memory) {
835        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
836        return _tokenURIs[tokenId];
837    }
838    
839    
840      /**
841     * @dev Returns an URI for a given token ID.
842     * Throws if the token ID does not exist. May return an empty string.
843     * @param tokenId uint256 ID of the token to query
844     */
845    function tokenIPFSHash(uint256 tokenId) external view returns (string memory) {
846        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
847        return _tokenIPFSHashes[tokenId];
848    }
849 
850    /**
851     * @dev Internal function to set the token URI for a given token.
852     * Reverts if the token ID does not exist.
853     * @param tokenId uint256 ID of the token to set its URI
854     * @param uri string URI to assign
855     */
856    function _setTokenURI(uint256 tokenId, string memory uri) internal {
857        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
858        _tokenURIs[tokenId] = uri;
859    }
860    
861       /**
862     * @dev Internal function to set the token IPFS hash for a given token.
863     * Reverts if the token ID does not exist.
864     * @param tokenId uint256 ID of the token to set its URI
865     * @param ipfs_hash string IPFS link to assign
866     */
867    function _setTokenIPFSHash(uint256 tokenId, string memory ipfs_hash) internal {
868        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
869        _tokenIPFSHashes[tokenId] = ipfs_hash;
870    }
871    
872    
873 
874    /**
875     * @dev Internal function to burn a specific token.
876     * Reverts if the token does not exist.
877     * Deprecated, use _burn(uint256) instead.
878     * @param owner owner of the token to burn
879     * @param tokenId uint256 ID of the token being burned by the msg.sender
880     */
881    function _burn(address owner, uint256 tokenId) internal {
882        super._burn(owner, tokenId);
883 
884        // Clear metadata (if any)
885        if (bytes(_tokenURIs[tokenId]).length != 0) {
886            delete _tokenURIs[tokenId];
887        }
888    }
889 }
890 
891 
892 /**
893 * @title Full ERC721 Token
894 * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
895 * Moreover, it includes approve all functionality using operator terminology.
896 *
897 * See https://eips.ethereum.org/EIPS/eip-721
898 */
899 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
900    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
901        // solhint-disable-previous-line no-empty-blocks
902    }
903 }
904 
905 
906 contract NiftyBuilderInstance is ERC721Full {
907 
908    //MODIFIERS
909 
910    modifier onlyValidSender() {
911        NiftyRegistry nftg_registry = NiftyRegistry(niftyRegistryContract);
912        bool is_valid = nftg_registry.isValidNiftySender(msg.sender);
913        require(is_valid==true);
914        _;
915    }
916 
917    //CONSTANTS
918 
919    // how many nifties this contract is selling
920    // used for metadat retrieval
921    uint public numNiftiesCurrentlyInContract;
922 
923    //id of this contract for metadata server
924    uint public contractId;
925 
926    //baseURI for metadata server
927    string public baseURI;
928 
929 //   //name of creator
930 //   string public creatorName;
931 
932    string public nameOfCreator;
933 
934    //nifty registry contract
935    address public niftyRegistryContract = 0x6e53130dDfF21E3BC963Ee902005223b9A202106;
936 
937    //master builder - ONLY DOES STATIC CALLS
938    address public masterBuilderContract = 0x6EFB06cF568253a53C7511BD3c31AB28BecB0192;
939 
940    using Counters for Counters.Counter;
941 
942    //MAPPINGS
943 
944    //mappings for token Ids
945    mapping (uint => Counters.Counter) public _numNiftyMinted;
946    mapping (uint => uint) public _numNiftyPermitted;
947    mapping (uint => string) public _niftyIPFSHashes;
948    mapping (uint => bool) public _IPFSHashHasBeenSet;
949 
950    //EVENTS
951 
952    //purchase + creation events
953    event NiftyPurchased(address _buyer, uint256 _amount, uint _tokenId);
954    event NiftyCreated(address new_owner, uint _niftyType, uint _tokenId);
955 
956    //CONSTRUCTOR FUNCTION
957 
958    constructor(
959        string memory _name,
960        string memory _symbol,
961        uint contract_id,
962        uint num_nifties,
963        uint[] memory nifty_quantities,
964        string memory base_uri,
965        string memory name_of_creator) ERC721Full(_name, _symbol) public {
966 
967        //set local variables based on inputs
968        contractId = contract_id;
969        numNiftiesCurrentlyInContract = num_nifties;
970        baseURI = base_uri;
971        nameOfCreator = name_of_creator;
972        //offset starts at 1 - there is no niftyType of 0
973        for (uint i=0; i<(num_nifties); i++) {
974            _numNiftyPermitted[i+1] = nifty_quantities[i];
975        }
976    }
977    
978    function setNiftyIPFSHash(uint niftyType, 
979                             string memory ipfs_hash) onlyValidSender public {
980         //can only be set once
981         if (_IPFSHashHasBeenSet[niftyType] == true) {
982             revert("Can only be set once");
983         } else {
984             _niftyIPFSHashes[niftyType] = ipfs_hash;
985             _IPFSHashHasBeenSet[niftyType]  = true;
986         }
987     }
988 
989    function isNiftySoldOut(uint niftyType) public view returns (bool) {
990        if (niftyType > numNiftiesCurrentlyInContract) {
991            return true;
992        }
993        if (_numNiftyMinted[niftyType].current() > _numNiftyPermitted[niftyType]) {
994            return (true);
995        } else {
996            return (false);
997        }
998    }
999 
1000    function _giftNifty(address collector_address, 
1001                       uint niftyType) private {
1002        //master for static calls
1003        BuilderMaster bm = BuilderMaster(masterBuilderContract);
1004        _numNiftyMinted[niftyType].increment();
1005        //check if this nifty is sold out
1006        if (isNiftySoldOut(niftyType)==true) {
1007            revert("Nifty sold out!");
1008        }
1009        //mint a nifty
1010        uint specificTokenId = _numNiftyMinted[niftyType].current();
1011        uint tokenId = bm.encodeTokenId(contractId, niftyType, specificTokenId);
1012        string memory tokenIdStr = bm.uint2str(tokenId);
1013        string memory tokenURI = bm.strConcat(baseURI, tokenIdStr);
1014        string memory ipfsHash = _niftyIPFSHashes[niftyType];
1015        //mint token
1016        _mint(collector_address, tokenId);
1017        _setTokenURI(tokenId, tokenURI);
1018        _setTokenIPFSHash(tokenId, ipfsHash);
1019        //do events
1020        emit NiftyCreated(collector_address, niftyType, tokenId);
1021    }
1022    
1023    function createNifties(address collector_address, 
1024                       uint[] memory listOfNiftyTypes) onlyValidSender public {
1025         //loop through array and create nifties
1026         for (uint i=0; i < listOfNiftyTypes.length; i++) {
1027             _giftNifty(collector_address,listOfNiftyTypes[i]);
1028         }
1029                           
1030     }
1031 
1032 }
1033 
1034 contract NiftyRegistry {
1035    function isValidNiftySender(address sending_key) public view returns (bool);
1036    function isOwner(address owner_key) public view returns (bool);
1037 }
1038 
1039 contract BuilderMaster {
1040    function getContractId(uint tokenId) public view returns (uint);
1041    function getNiftyTypeId(uint tokenId) public view returns (uint);
1042    function getSpecificNiftyNum(uint tokenId) public view returns (uint);
1043    function encodeTokenId(uint contractId, uint niftyType, uint specificNiftyNum) public view returns (uint);
1044    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) public view returns (string memory);
1045    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) public view returns (string memory);
1046    function strConcat(string memory _a, string memory _b, string memory _c) public view returns (string memory);
1047    function strConcat(string memory _a, string memory _b) public view returns (string memory);
1048    function uint2str(uint _i) public view returns (string memory _uintAsString);
1049 }
1050 
1051 /**
1052 * Contracts and libraries below are from OpenZeppelin, except nifty builder instance
1053 **/
1054 
1055 
1056 /**
1057 * @dev Wrappers over Solidity's arithmetic operations with added overflow
1058 * checks.
1059 *
1060 * Arithmetic operations in Solidity wrap on overflow. This can easily result
1061 * in bugs, because programmers usually assume that an overflow raises an
1062 * error, which is the standard behavior in high level programming languages.
1063 * `SafeMath` restores this intuition by reverting the transaction when an
1064 * operation overflows.
1065 *
1066 * Using this library instead of the unchecked operations eliminates an entire
1067 * class of bugs, so it's recommended to use it always.
1068 */
1069 library SafeMath {
1070    /**
1071     * @dev Returns the addition of two unsigned integers, reverting on
1072     * overflow.
1073     *
1074     * Counterpart to Solidity's `+` operator.
1075     *
1076     * Requirements:
1077     * - Addition cannot overflow.
1078     */
1079    function add(uint256 a, uint256 b) internal pure returns (uint256) {
1080        uint256 c = a + b;
1081        require(c >= a, "SafeMath: addition overflow");
1082 
1083        return c;
1084    }
1085 
1086    /**
1087     * @dev Returns the subtraction of two unsigned integers, reverting on
1088     * overflow (when the result is negative).
1089     *
1090     * Counterpart to Solidity's `-` operator.
1091     *
1092     * Requirements:
1093     * - Subtraction cannot overflow.
1094     */
1095    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1096        return sub(a, b, "SafeMath: subtraction overflow");
1097    }
1098 
1099    /**
1100     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1101     * overflow (when the result is negative).
1102     *
1103     * Counterpart to Solidity's `-` operator.
1104     *
1105     * Requirements:
1106     * - Subtraction cannot overflow.
1107     *
1108     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1109     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1110     */
1111    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1112        require(b <= a, errorMessage);
1113        uint256 c = a - b;
1114 
1115        return c;
1116    }
1117 
1118    /**
1119     * @dev Returns the multiplication of two unsigned integers, reverting on
1120     * overflow.
1121     *
1122     * Counterpart to Solidity's `*` operator.
1123     *
1124     * Requirements:
1125     * - Multiplication cannot overflow.
1126     */
1127    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1128        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1129        // benefit is lost if 'b' is also tested.
1130        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1131        if (a == 0) {
1132            return 0;
1133        }
1134 
1135        uint256 c = a * b;
1136        require(c / a == b, "SafeMath: multiplication overflow");
1137 
1138        return c;
1139    }
1140 
1141    /**
1142     * @dev Returns the integer division of two unsigned integers. Reverts on
1143     * division by zero. The result is rounded towards zero.
1144     *
1145     * Counterpart to Solidity's `/` operator. Note: this function uses a
1146     * `revert` opcode (which leaves remaining gas untouched) while Solidity
1147     * uses an invalid opcode to revert (consuming all remaining gas).
1148     *
1149     * Requirements:
1150     * - The divisor cannot be zero.
1151     */
1152    function div(uint256 a, uint256 b) internal pure returns (uint256) {
1153        return div(a, b, "SafeMath: division by zero");
1154    }
1155 
1156    /**
1157     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1158     * division by zero. The result is rounded towards zero.
1159     *
1160     * Counterpart to Solidity's `/` operator. Note: this function uses a
1161     * `revert` opcode (which leaves remaining gas untouched) while Solidity
1162     * uses an invalid opcode to revert (consuming all remaining gas).
1163     *
1164     * Requirements:
1165     * - The divisor cannot be zero.
1166     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1167     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1168     */
1169    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1170        // Solidity only automatically asserts when dividing by 0
1171        require(b > 0, errorMessage);
1172        uint256 c = a / b;
1173        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1174 
1175        return c;
1176    }
1177 
1178    /**
1179     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1180     * Reverts when dividing by zero.
1181     *
1182     * Counterpart to Solidity's `%` operator. This function uses a `revert`
1183     * opcode (which leaves remaining gas untouched) while Solidity uses an
1184     * invalid opcode to revert (consuming all remaining gas).
1185     *
1186     * Requirements:
1187     * - The divisor cannot be zero.
1188     */
1189    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1190        return mod(a, b, "SafeMath: modulo by zero");
1191    }
1192 
1193    /**
1194     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1195     * Reverts with custom message when dividing by zero.
1196     *
1197     * Counterpart to Solidity's `%` operator. This function uses a `revert`
1198     * opcode (which leaves remaining gas untouched) while Solidity uses an
1199     * invalid opcode to revert (consuming all remaining gas).
1200     *
1201     * Requirements:
1202     * - The divisor cannot be zero.
1203     *
1204     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1205     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1206     */
1207    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1208        require(b != 0, errorMessage);
1209        return a % b;
1210    }
1211 }
1212 
1213 /**
1214 * @dev Collection of functions related to the address type
1215 */
1216 library Address {
1217    /**
1218     * @dev Returns true if `account` is a contract.
1219     *
1220     * This test is non-exhaustive, and there may be false-negatives: during the
1221     * execution of a contract's constructor, its address will be reported as
1222     * not containing a contract.
1223     *
1224     * IMPORTANT: It is unsafe to assume that an address for which this
1225     * function returns false is an externally-owned account (EOA) and not a
1226     * contract.
1227     */
1228    function isContract(address account) internal view returns (bool) {
1229        // This method relies in extcodesize, which returns 0 for contracts in
1230        // construction, since the code is only stored at the end of the
1231        // constructor execution.
1232 
1233        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1234        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1235        // for accounts without code, i.e. `keccak256('')`
1236        bytes32 codehash;
1237        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1238        // solhint-disable-next-line no-inline-assembly
1239        assembly { codehash := extcodehash(account) }
1240        return (codehash != 0x0 && codehash != accountHash);
1241    }
1242 
1243    /**
1244     * @dev Converts an `address` into `address payable`. Note that this is
1245     * simply a type cast: the actual underlying value is not changed.
1246     *
1247     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1248     * @dev Get it via `npm install @openzeppelin/contracts@next`.
1249     */
1250    function toPayable(address account) internal pure returns (address payable) {
1251        return address(uint160(account));
1252    }
1253 
1254    /**
1255     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1256     * `recipient`, forwarding all available gas and reverting on errors.
1257     *
1258     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1259     * of certain opcodes, possibly making contracts go over the 2300 gas limit
1260     * imposed by `transfer`, making them unable to receive funds via
1261     * `transfer`. {sendValue} removes this limitation.
1262     *
1263     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1264     *
1265     * IMPORTANT: because control is transferred to `recipient`, care must be
1266     * taken to not create reentrancy vulnerabilities. Consider using
1267     * {ReentrancyGuard} or the
1268     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1269     */
1270    function sendValue(address payable recipient, uint256 amount) internal {
1271        require(address(this).balance >= amount, "Address: insufficient balance");
1272 
1273        // solhint-disable-next-line avoid-call-value
1274        (bool success, ) = recipient.call.value(amount)("");
1275        require(success, "Address: unable to send value, recipient may have reverted");
1276    }
1277 }
1278 
1279 /**
1280 * @title Counters
1281 * @author Matt Condon (@shrugs)
1282 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1283 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1284 *
1285 * Include with `using Counters for Counters.Counter;`
1286 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1287 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1288 * directly accessed.
1289 */
1290 library Counters {
1291    using SafeMath for uint256;
1292 
1293    struct Counter {
1294        // This variable should never be directly accessed by users of the library: interactions must be restricted to
1295        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1296        // this feature: see https://github.com/ethereum/solidity/issues/4637
1297        uint256 _value; // default: 0
1298    }
1299 
1300    function current(Counter storage counter) internal view returns (uint256) {
1301        return counter._value;
1302    }
1303 
1304    function increment(Counter storage counter) internal {
1305        // The {SafeMath} overflow check can be skipped here, see the comment at the top
1306        counter._value += 1;
1307    }
1308 
1309    function decrement(Counter storage counter) internal {
1310        counter._value = counter._value.sub(1);
1311    }
1312 }