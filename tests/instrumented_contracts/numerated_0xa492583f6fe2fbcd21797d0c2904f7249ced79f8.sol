1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: erc721a/contracts/IERC721A.sol
114 
115 
116 // ERC721A Contracts v4.2.3
117 // Creator: Chiru Labs
118 
119 pragma solidity ^0.8.4;
120 
121 /**
122  * @dev Interface of ERC721A.
123  */
124 interface IERC721A {
125     /**
126      * The caller must own the token or be an approved operator.
127      */
128     error ApprovalCallerNotOwnerNorApproved();
129 
130     /**
131      * The token does not exist.
132      */
133     error ApprovalQueryForNonexistentToken();
134 
135     /**
136      * Cannot query the balance for the zero address.
137      */
138     error BalanceQueryForZeroAddress();
139 
140     /**
141      * Cannot mint to the zero address.
142      */
143     error MintToZeroAddress();
144 
145     /**
146      * The quantity of tokens minted must be more than zero.
147      */
148     error MintZeroQuantity();
149 
150     /**
151      * The token does not exist.
152      */
153     error OwnerQueryForNonexistentToken();
154 
155     /**
156      * The caller must own the token or be an approved operator.
157      */
158     error TransferCallerNotOwnerNorApproved();
159 
160     /**
161      * The token must be owned by `from`.
162      */
163     error TransferFromIncorrectOwner();
164 
165     /**
166      * Cannot safely transfer to a contract that does not implement the
167      * ERC721Receiver interface.
168      */
169     error TransferToNonERC721ReceiverImplementer();
170 
171     /**
172      * Cannot transfer to the zero address.
173      */
174     error TransferToZeroAddress();
175 
176     /**
177      * The token does not exist.
178      */
179     error URIQueryForNonexistentToken();
180 
181     /**
182      * The `quantity` minted with ERC2309 exceeds the safety limit.
183      */
184     error MintERC2309QuantityExceedsLimit();
185 
186     /**
187      * The `extraData` cannot be set on an unintialized ownership slot.
188      */
189     error OwnershipNotInitializedForExtraData();
190 
191     // =============================================================
192     //                            STRUCTS
193     // =============================================================
194 
195     struct TokenOwnership {
196         // The address of the owner.
197         address addr;
198         // Stores the start time of ownership with minimal overhead for tokenomics.
199         uint64 startTimestamp;
200         // Whether the token has been burned.
201         bool burned;
202         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
203         uint24 extraData;
204     }
205 
206     // =============================================================
207     //                         TOKEN COUNTERS
208     // =============================================================
209 
210     /**
211      * @dev Returns the total number of tokens in existence.
212      * Burned tokens will reduce the count.
213      * To get the total number of tokens minted, please see {_totalMinted}.
214      */
215     function totalSupply() external view returns (uint256);
216 
217     // =============================================================
218     //                            IERC165
219     // =============================================================
220 
221     /**
222      * @dev Returns true if this contract implements the interface defined by
223      * `interfaceId`. See the corresponding
224      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
225      * to learn more about how these ids are created.
226      *
227      * This function call must use less than 30000 gas.
228      */
229     function supportsInterface(bytes4 interfaceId) external view returns (bool);
230 
231     // =============================================================
232     //                            IERC721
233     // =============================================================
234 
235     /**
236      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
237      */
238     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
239 
240     /**
241      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
242      */
243     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
244 
245     /**
246      * @dev Emitted when `owner` enables or disables
247      * (`approved`) `operator` to manage all of its assets.
248      */
249     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
250 
251     /**
252      * @dev Returns the number of tokens in `owner`'s account.
253      */
254     function balanceOf(address owner) external view returns (uint256 balance);
255 
256     /**
257      * @dev Returns the owner of the `tokenId` token.
258      *
259      * Requirements:
260      *
261      * - `tokenId` must exist.
262      */
263     function ownerOf(uint256 tokenId) external view returns (address owner);
264 
265     /**
266      * @dev Safely transfers `tokenId` token from `from` to `to`,
267      * checking first that contract recipients are aware of the ERC721 protocol
268      * to prevent tokens from being forever locked.
269      *
270      * Requirements:
271      *
272      * - `from` cannot be the zero address.
273      * - `to` cannot be the zero address.
274      * - `tokenId` token must exist and be owned by `from`.
275      * - If the caller is not `from`, it must be have been allowed to move
276      * this token by either {approve} or {setApprovalForAll}.
277      * - If `to` refers to a smart contract, it must implement
278      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
279      *
280      * Emits a {Transfer} event.
281      */
282     function safeTransferFrom(
283         address from,
284         address to,
285         uint256 tokenId,
286         bytes calldata data
287     ) external payable;
288 
289     /**
290      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
291      */
292     function safeTransferFrom(
293         address from,
294         address to,
295         uint256 tokenId
296     ) external payable;
297 
298     /**
299      * @dev Transfers `tokenId` from `from` to `to`.
300      *
301      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
302      * whenever possible.
303      *
304      * Requirements:
305      *
306      * - `from` cannot be the zero address.
307      * - `to` cannot be the zero address.
308      * - `tokenId` token must be owned by `from`.
309      * - If the caller is not `from`, it must be approved to move this token
310      * by either {approve} or {setApprovalForAll}.
311      *
312      * Emits a {Transfer} event.
313      */
314     function transferFrom(
315         address from,
316         address to,
317         uint256 tokenId
318     ) external payable;
319 
320     /**
321      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
322      * The approval is cleared when the token is transferred.
323      *
324      * Only a single account can be approved at a time, so approving the
325      * zero address clears previous approvals.
326      *
327      * Requirements:
328      *
329      * - The caller must own the token or be an approved operator.
330      * - `tokenId` must exist.
331      *
332      * Emits an {Approval} event.
333      */
334     function approve(address to, uint256 tokenId) external payable;
335 
336     /**
337      * @dev Approve or remove `operator` as an operator for the caller.
338      * Operators can call {transferFrom} or {safeTransferFrom}
339      * for any token owned by the caller.
340      *
341      * Requirements:
342      *
343      * - The `operator` cannot be the caller.
344      *
345      * Emits an {ApprovalForAll} event.
346      */
347     function setApprovalForAll(address operator, bool _approved) external;
348 
349     /**
350      * @dev Returns the account approved for `tokenId` token.
351      *
352      * Requirements:
353      *
354      * - `tokenId` must exist.
355      */
356     function getApproved(uint256 tokenId) external view returns (address operator);
357 
358     /**
359      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
360      *
361      * See {setApprovalForAll}.
362      */
363     function isApprovedForAll(address owner, address operator) external view returns (bool);
364 
365     // =============================================================
366     //                        IERC721Metadata
367     // =============================================================
368 
369     /**
370      * @dev Returns the token collection name.
371      */
372     function name() external view returns (string memory);
373 
374     /**
375      * @dev Returns the token collection symbol.
376      */
377     function symbol() external view returns (string memory);
378 
379     /**
380      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
381      */
382     function tokenURI(uint256 tokenId) external view returns (string memory);
383 
384     // =============================================================
385     //                           IERC2309
386     // =============================================================
387 
388     /**
389      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
390      * (inclusive) is transferred from `from` to `to`, as defined in the
391      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
392      *
393      * See {_mintERC2309} for more details.
394      */
395     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
396 }
397 
398 // File: erc721a/contracts/interfaces/IERC721A.sol
399 
400 
401 // ERC721A Contracts v4.2.3
402 // Creator: Chiru Labs
403 
404 pragma solidity ^0.8.4;
405 
406 
407 // File: WeaponBurn.sol
408 
409 
410 pragma solidity ^0.8.18;
411 
412 
413 
414 interface ILoot {
415     function controlledBurn(address _from, uint256 _id, uint256 _amount) external;
416 }
417 
418 contract WeaponBurn is Ownable {
419     address public dragonsContract;
420     address public weaponsContract;
421     event Reroll(uint256[] _weaponIds, uint256[] _dragonIds);
422     constructor(address _dragonsContract, address _weaponsContract){
423         dragonsContract = _dragonsContract;
424         weaponsContract = _weaponsContract;
425     }
426 
427     function setDragonsContract(address _dragonsContract) public onlyOwner {
428         dragonsContract = _dragonsContract;
429     }
430 
431     function setLootContract(address _lootContract) public onlyOwner {
432         weaponsContract = _lootContract;
433     }
434 
435     function rerollDragons(uint256[] calldata _weaponIds, uint256[] calldata _dragonIds) public {
436         for (uint256 i = 0; i < _weaponIds.length; i++) {
437             require(IERC721A(dragonsContract).ownerOf(_dragonIds[i]) == msg.sender, "Dragon is not yours to re-roll!");
438             ILoot(weaponsContract).controlledBurn(msg.sender, _weaponIds[i], 1);
439         }
440         emit Reroll(_weaponIds, _dragonIds);
441     }
442 }