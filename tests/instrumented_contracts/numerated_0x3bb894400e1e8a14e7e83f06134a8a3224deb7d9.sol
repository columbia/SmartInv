1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
5 
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
102 
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
106 
107 
108 
109 /**
110  * @dev Interface of the ERC165 standard, as defined in the
111  * https://eips.ethereum.org/EIPS/eip-165[EIP].
112  *
113  * Implementers can declare support of contract interfaces, which can then be
114  * queried by others ({ERC165Checker}).
115  *
116  * For an implementation, see {ERC165}.
117  */
118 interface IERC165 {
119     /**
120      * @dev Returns true if this contract implements the interface defined by
121      * `interfaceId`. See the corresponding
122      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
123      * to learn more about how these ids are created.
124      *
125      * This function call must use less than 30 000 gas.
126      */
127     function supportsInterface(bytes4 interfaceId) external view returns (bool);
128 }
129 
130 /**
131  * @dev Required interface of an ERC721 compliant contract.
132  */
133 interface IERC721 is IERC165 {
134     /**
135      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
136      */
137     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
138 
139     /**
140      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
141      */
142     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
143 
144     /**
145      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
146      */
147     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
148 
149     /**
150      * @dev Returns the number of tokens in ``owner``'s account.
151      */
152     function balanceOf(address owner) external view returns (uint256 balance);
153 
154     /**
155      * @dev Returns the owner of the `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function ownerOf(uint256 tokenId) external view returns (address owner);
162 
163     /**
164      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
165      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
173      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId
181     ) external;
182 
183     /**
184      * @dev Transfers `tokenId` token from `from` to `to`.
185      *
186      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
187      *
188      * Requirements:
189      *
190      * - `from` cannot be the zero address.
191      * - `to` cannot be the zero address.
192      * - `tokenId` token must be owned by `from`.
193      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transferFrom(
198         address from,
199         address to,
200         uint256 tokenId
201     ) external;
202 
203     /**
204      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
205      * The approval is cleared when the token is transferred.
206      *
207      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
208      *
209      * Requirements:
210      *
211      * - The caller must own the token or be an approved operator.
212      * - `tokenId` must exist.
213      *
214      * Emits an {Approval} event.
215      */
216     function approve(address to, uint256 tokenId) external;
217 
218     /**
219      * @dev Returns the account approved for `tokenId` token.
220      *
221      * Requirements:
222      *
223      * - `tokenId` must exist.
224      */
225     function getApproved(uint256 tokenId) external view returns (address operator);
226 
227     /**
228      * @dev Approve or remove `operator` as an operator for the caller.
229      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
230      *
231      * Requirements:
232      *
233      * - The `operator` cannot be the caller.
234      *
235      * Emits an {ApprovalForAll} event.
236      */
237     function setApprovalForAll(address operator, bool _approved) external;
238 
239     /**
240      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
241      *
242      * See {setApprovalForAll}
243      */
244     function isApprovedForAll(address owner, address operator) external view returns (bool);
245 
246     /**
247      * @dev Safely transfers `tokenId` token from `from` to `to`.
248      *
249      * Requirements:
250      *
251      * - `from` cannot be the zero address.
252      * - `to` cannot be the zero address.
253      * - `tokenId` token must exist and be owned by `from`.
254      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
255      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
256      *
257      * Emits a {Transfer} event.
258      */
259     function safeTransferFrom(
260         address from,
261         address to,
262         uint256 tokenId,
263         bytes calldata data
264     ) external;
265 }
266 
267 interface IDelegatedMintable {
268   function mint(address recipient, uint256 tokenId) external;
269   function mintMany(address recipient, uint256 tokenIdStart, uint256 count) external;
270   function totalSupply() external view returns(uint256);
271 }
272 
273 contract StonezMigrator is Ownable {
274   /**
275    * @notice The token is not migratable. This should only happen for
276    * tokens that are outside the migratable range, which means that the token
277    * was minted *after* the migration was enabled.
278    */
279   error Unmigratable();
280 
281   /**
282    * @notice The migration has been paused.
283    */
284   error Paused();
285 
286   /**
287    * @notice The address used to burn MetaStonez NFTs.
288    */
289   address constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;
290 
291   /**
292    * @notice The old MetaStonez contract.
293    */
294   IERC721 public metaStonezV1;
295 
296   /**
297    * @notice The max Genesis token ID that can be migrated (non-inclusive).
298    */
299   uint256 public GENESIS_CUTOFF;
300   /**
301    * @notice The new Genesis contract.
302    */
303   IDelegatedMintable public genesis;
304 
305   /**
306    * @notice The max Origins token ID that can be migrated (non-inclusive).
307    */
308   uint256 public ORIGINS_CUTOFF;
309   /**
310    * @notice The new Origins contract.
311    */
312   IDelegatedMintable public origins;
313 
314   /**
315    * @notice Whether or not the migration has been paused.
316    */
317   bool public paused;
318 
319   constructor(
320     address _metaStonezV1,
321     address _genesis,
322     uint256 _genesisCutoff,
323     address _origins,
324     uint256 _originsCutoff
325   ) {
326     // Old MetaStonez contract
327     metaStonezV1 = IERC721(_metaStonezV1);
328 
329     // New Genesis parameters
330     genesis = IDelegatedMintable(_genesis);
331     GENESIS_CUTOFF = _genesisCutoff;
332 
333     // New Origins parameters
334     origins = IDelegatedMintable(_origins);
335     ORIGINS_CUTOFF = _originsCutoff;
336   }
337 
338   /**
339    * @notice Migrate old MetaStonez tokens into the new contract.
340    * Genesis and Origins are split off into separate contracts.
341    * Migration gives you another Origins for free per migrated token.
342    * Note: To use this function you must approve the token to be burned first.
343    */
344   function migrate(uint256[] calldata tokenIds) public {
345     if (paused) {
346       revert Paused();
347     }
348 
349     for (uint256 i = 0; i < tokenIds.length; i++) {
350       uint256 tokenId = tokenIds[i];
351 
352       if (tokenId >= ORIGINS_CUTOFF) {
353         revert Unmigratable();
354       }
355 
356       // burn the old one
357       metaStonezV1.transferFrom(msg.sender, BURN_ADDRESS, tokenId);
358 
359       // mint a new one
360       if (tokenId < GENESIS_CUTOFF) {
361         genesis.mint(msg.sender, tokenId);
362       } else {
363         origins.mint(msg.sender, origins.totalSupply());
364       }
365 
366       // mint an additional origins
367       origins.mint(msg.sender, origins.totalSupply());
368     }
369   }
370 
371   /**
372    * @notice Pause or unpause the contract.
373    */
374   function setPaused(bool pause) public onlyOwner {
375     paused = pause;
376   }
377 }