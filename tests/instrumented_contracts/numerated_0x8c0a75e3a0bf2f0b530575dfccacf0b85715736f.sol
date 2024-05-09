1 // SPDX-License-Identifier: MIT
2 
3 // ⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 // ⠀⠀⠀⣠⡶⠛⠉⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢦⡀⠀⢀⣴⠞⠋⠉⠉⠉⠉⠙⠛⠶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 // ⠀⢀⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣶⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 // ⢠⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⠀⠸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 // ⠘⠀⠀⠀⠀⠀⠀⢀⣴⠖⠛⠋⠉⠉⠉⠉⠉⠉⠙⠛⠻⢦⣄⠀⠀⣀⣠⣤⣤⣤⣤⣤⣄⣀⠈⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 // ⠀⠀⠀⠀⠀⢠⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢻⣏⠉⠀⠀⠀⠀⠀⠀⠈⠉⠙⠲⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠻⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣀⣀⣀⣀⣤⣄⣤⣤⣄⣀⣀⣤⣀⡈⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⡈⢻⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 // ⠀⠀⠀⠀⠀⠀⢀⡴⠟⠉⣉⣉⣩⣭⣽⠥⠦⣤⣌⣉⠛⠿⢦⣄⠈⠛⢶⣗⠀⠀⠀⠀⠀⢰⣞⣻⣽⣽⣭⣭⣭⣽⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀
12 // ⠀⠀⠀⠀⢀⡴⢋⣠⠾⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢦⣄⡙⢷⣄⠀⠹⣧⡀⠀⢀⡶⠟⣫⣭⢿⡿⠿⠿⠷⣦⡉⢻⣿⡄⠀⠀⠀⠀⠀⠀⠀
13 // ⠀⠀⠀⠀⢻⣧⣾⣁⣤⡤⠴⠶⠖⣶⣶⣶⣶⣶⣶⣶⣶⠒⠛⠛⠳⣿⢷⣤⢺⣇⠀⠉⣢⣿⣿⣿⣾⣶⣶⣦⣄⡀⠹⣾⡏⠀⠀⠀⠀⠀⠀⠀⠀
14 // ⠀⠀⠀⠀⠀⠀⠀⠉⠙⡳⠶⣄⣼⣿⣷⢾⣿⡟⠋⠛⣿⡇⠀⠀⠀⠈⣷⠘⢷⡟⢀⡾⣿⣿⣩⣿⣿⠿⢿⣧⠈⠙⠳⢾⣇⠀⠀⠀⠀⠀⠀⠀⠀
15 // ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⡈⠻⢿⣿⣼⣿⣷⣦⣾⣿⠇⠀⠀⠀⠀⠘⣧⢸⢣⡟⠀⣿⣿⣟⣿⣿⣤⣾⡿⠀⢀⣴⢿⡟⠀⠀⠀⠀⠀⠀⠀⠀
16 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⣀⠀⠉⠉⠛⠿⠿⠿⢤⣤⣤⡴⠖⠛⢉⣿⠈⢹⡓⢿⠿⠿⠿⠿⠿⠿⠷⠞⠋⣡⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀
17 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠛⠛⠛⠳⠶⠤⠴⠶⢤⣴⠾⠋⠁⠀⠈⠛⠶⣤⡤⠤⠴⠆⢀⡾⢷⣾⢯⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 // ⠀⠀⠀⣴⡶⠶⠖⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠞⠁⠀⠀⠀⠀⠀⠀⠀⠈⢳⣄⠀⠀⠛⠛⠛⠁⠀⢻⣆⠀⠀⠀⠀⠀⠀⠀⠀
19 // ⠀⠀⣀⣠⣴⡶⠾⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⠶⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢧⠀⠀⠀⠀⠀⠀⠀⣿⣦⠀⠀⠀⠀⠀⠀⠀
20 // ⠀⣼⢏⣿⠛⠿⠶⢤⣄⣀⡀⠀⠀⠀⠀⠐⠻⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠇⢸⡇⠀⠀⠀⠀⠀⠀
21 // ⠀⠈⠘⣿⣄⠘⢷⣄⣀⠉⠙⠛⠒⠲⠶⣤⣤⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠃⣠⡟⠁⠀⠀⠀⠀⠀⠀
22 // ⠀⠀⠀⠈⠙⠷⣄⣈⠉⠙⠳⠶⢤⣄⣀⡀⠀⠀⠉⠉⠉⠛⠛⠳⠶⠶⠶⠶⠶⠶⠤⢤⣤⣤⣤⣤⣤⣤⡤⠶⠾⠋⣠⣾⡋⠀⠀⠀⠀⠀⠀⠀⠀
23 // ⠀⠀⠀⠀⠀⠀⠀⠙⠛⢦⣄⡀⠀⠈⠉⠙⠛⠛⠛⠛⠛⠛⠶⢦⣤⣤⣤⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣤⠾⠋⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀
24 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠳⢶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⣰⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀
25 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠶⠦⠤⠤⢤⣄⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣠⣤⣄⣀⣀⣠⡤⠞⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⣉⣭⣉⠁⠀⣠⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
27 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡶⠛⠉⠉⠙⢷⣴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
28 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡴⠛⠁⠀⠀⠀⠀⠀⠀⠹⠦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
29 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡶⠒⠳⣦⠾⠛⢷⡄⠀⠀⣠⡴⢶⣤⣄⠀⣠⡌⠙⠷⣄⡀⠀⠀⠀⠀⠀⠀
30 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣄⠀⠀⠹⣦⣠⣾⣃⡴⠟⢁⡼⢋⣴⣯⠞⠋⠀⠀⠀⠈⠻⣆⠀⠀⠀⠀⠀
31 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⡀⠀⠈⠉⢿⠁⢠⡼⣋⡴⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠙⢷⡄⠀⠀⠀
32 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⡄⠀⠀⢸⣶⢋⣼⠋⠀⠀⠀⠀⣀⡴⠟⠀⠀⠀⠀⠀⠀⢻⣄⠀⠀
33 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠙⠿⣧⡀⠀⠀⠀⣴⠏⠀⠀⠀⢀⣴⠆⠀⢀⠀⠻⣆⠀
34 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣇⠀⠀⠀⠀⠀⠈⠻⣦⣤⣼⠃⠀⠀⢀⣠⠞⠁⠀⣠⡾⠀⠀⠻⡆
35 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠟⠃⠹⠗⠀⠀⠀⠀⠀⠀⠀⠀⠙⠓⠀⠀⠾⠃⠀⠀⠸⠋⠀⠀⠀⠀⠿
36 
37 // ERC721A Contracts v3.3.0
38 // Creator: Chiru Labs
39 
40 pragma solidity ^0.8.4;
41 
42 /**
43  * @dev Interface of an ERC721A compliant contract.
44  */
45 interface IERC721A {
46     /**
47      * The caller must own the token or be an approved operator.
48      */
49     error ApprovalCallerNotOwnerNorApproved();
50 
51     /**
52      * The token does not exist.
53      */
54     error ApprovalQueryForNonexistentToken();
55 
56     /**
57      * The caller cannot approve to their own address.
58      */
59     error ApproveToCaller();
60 
61     /**
62      * The caller cannot approve to the current owner.
63      */
64     error ApprovalToCurrentOwner();
65 
66     /**
67      * Cannot query the balance for the zero address.
68      */
69     error BalanceQueryForZeroAddress();
70 
71     /**
72      * Cannot mint to the zero address.
73      */
74     error MintToZeroAddress();
75 
76     /**
77      * The quantity of tokens minted must be more than zero.
78      */
79     error MintZeroQuantity();
80 
81     /**
82      * The token does not exist.
83      */
84     error OwnerQueryForNonexistentToken();
85 
86     /**
87      * The caller must own the token or be an approved operator.
88      */
89     error TransferCallerNotOwnerNorApproved();
90 
91     /**
92      * The token must be owned by `from`.
93      */
94     error TransferFromIncorrectOwner();
95 
96     /**
97      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
98      */
99     error TransferToNonERC721ReceiverImplementer();
100 
101     /**
102      * Cannot transfer to the zero address.
103      */
104     error TransferToZeroAddress();
105 
106     /**
107      * The token does not exist.
108      */
109     error URIQueryForNonexistentToken();
110 
111     struct TokenOwnership {
112         // The address of the owner.
113         address addr;
114         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
115         uint64 startTimestamp;
116         // Whether the token has been burned.
117         bool burned;
118     }
119 
120     /**
121      * @dev Returns the total amount of tokens stored by the contract.
122      *
123      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
124      */
125     function totalSupply() external view returns (uint256);
126 
127     // ==============================
128     //            IERC165
129     // ==============================
130 
131     /**
132      * @dev Returns true if this contract implements the interface defined by
133      * `interfaceId`. See the corresponding
134      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
135      * to learn more about how these ids are created.
136      *
137      * This function call must use less than 30 000 gas.
138      */
139     function supportsInterface(bytes4 interfaceId) external view returns (bool);
140 
141     // ==============================
142     //            IERC721
143     // ==============================
144 
145     /**
146      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
147      */
148     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
149 
150     /**
151      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
152      */
153     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
154 
155     /**
156      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
157      */
158     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
159 
160     /**
161      * @dev Returns the number of tokens in ``owner``'s account.
162      */
163     function balanceOf(address owner) external view returns (uint256 balance);
164 
165     /**
166      * @dev Returns the owner of the `tokenId` token.
167      *
168      * Requirements:
169      *
170      * - `tokenId` must exist.
171      */
172     function ownerOf(uint256 tokenId) external view returns (address owner);
173 
174     /**
175      * @dev Safely transfers `tokenId` token from `from` to `to`.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must exist and be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId,
191         bytes calldata data
192     ) external;
193 
194     /**
195      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
196      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
197      *
198      * Requirements:
199      *
200      * - `from` cannot be the zero address.
201      * - `to` cannot be the zero address.
202      * - `tokenId` token must exist and be owned by `from`.
203      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
204      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
205      *
206      * Emits a {Transfer} event.
207      */
208     function safeTransferFrom(
209         address from,
210         address to,
211         uint256 tokenId
212     ) external;
213 
214     /**
215      * @dev Transfers `tokenId` token from `from` to `to`.
216      *
217      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
218      *
219      * Requirements:
220      *
221      * - `from` cannot be the zero address.
222      * - `to` cannot be the zero address.
223      * - `tokenId` token must be owned by `from`.
224      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transferFrom(
229         address from,
230         address to,
231         uint256 tokenId
232     ) external;
233 
234     /**
235      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
236      * The approval is cleared when the token is transferred.
237      *
238      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
239      *
240      * Requirements:
241      *
242      * - The caller must own the token or be an approved operator.
243      * - `tokenId` must exist.
244      *
245      * Emits an {Approval} event.
246      */
247     function approve(address to, uint256 tokenId) external;
248 
249     /**
250      * @dev Approve or remove `operator` as an operator for the caller.
251      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
252      *
253      * Requirements:
254      *
255      * - The `operator` cannot be the caller.
256      *
257      * Emits an {ApprovalForAll} event.
258      */
259     function setApprovalForAll(address operator, bool _approved) external;
260 
261     /**
262      * @dev Returns the account approved for `tokenId` token.
263      *
264      * Requirements:
265      *
266      * - `tokenId` must exist.
267      */
268     function getApproved(uint256 tokenId) external view returns (address operator);
269 
270     /**
271      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
272      *
273      * See {setApprovalForAll}
274      */
275     function isApprovedForAll(address owner, address operator) external view returns (bool);
276 
277     // ==============================
278     //        IERC721Metadata
279     // ==============================
280 
281     /**
282      * @dev Returns the token collection name.
283      */
284     function name() external view returns (string memory);
285 
286     /**
287      * @dev Returns the token collection symbol.
288      */
289     function symbol() external view returns (string memory);
290 
291     /**
292      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
293      */
294     function tokenURI(uint256 tokenId) external view returns (string memory);
295 }
296 
297 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
298 
299 
300 // ERC721A Contracts v3.3.0
301 // Creator: Chiru Labs
302 
303 pragma solidity ^0.8.4;
304 
305 
306 /**
307  * @dev ERC721 token receiver interface.
308  */
309 interface ERC721A__IERC721Receiver {
310     function onERC721Received(
311         address operator,
312         address from,
313         uint256 tokenId,
314         bytes calldata data
315     ) external returns (bytes4);
316 }
317 
318 /**
319  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
320  * the Metadata extension. Built to optimize for lower gas during batch mints.
321  *
322  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
323  *
324  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
325  *
326  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
327  */
328 contract ERC721A is IERC721A {
329     // Mask of an entry in packed address data.
330     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
331 
332     // The bit position of `numberMinted` in packed address data.
333     uint256 private constant BITPOS_NUMBER_MINTED = 64;
334 
335     // The bit position of `numberBurned` in packed address data.
336     uint256 private constant BITPOS_NUMBER_BURNED = 128;
337 
338     // The bit position of `aux` in packed address data.
339     uint256 private constant BITPOS_AUX = 192;
340 
341     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
342     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
343 
344     // The bit position of `startTimestamp` in packed ownership.
345     uint256 private constant BITPOS_START_TIMESTAMP = 160;
346 
347     // The bit mask of the `burned` bit in packed ownership.
348     uint256 private constant BITMASK_BURNED = 1 << 224;
349     
350     // The bit position of the `nextInitialized` bit in packed ownership.
351     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
352 
353     // The bit mask of the `nextInitialized` bit in packed ownership.
354     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
355 
356     // The tokenId of the next token to be minted.
357     uint256 private _currentIndex;
358 
359     // The number of tokens burned.
360     uint256 private _burnCounter;
361 
362     // Token name
363     string private _name;
364 
365     // Token symbol
366     string private _symbol;
367 
368     // Mapping from token ID to ownership details
369     // An empty struct value does not necessarily mean the token is unowned.
370     // See `_packedOwnershipOf` implementation for details.
371     //
372     // Bits Layout:
373     // - [0..159]   `addr`
374     // - [160..223] `startTimestamp`
375     // - [224]      `burned`
376     // - [225]      `nextInitialized`
377     mapping(uint256 => uint256) private _packedOwnerships;
378 
379     // Mapping owner address to address data.
380     //
381     // Bits Layout:
382     // - [0..63]    `balance`
383     // - [64..127]  `numberMinted`
384     // - [128..191] `numberBurned`
385     // - [192..255] `aux`
386     mapping(address => uint256) private _packedAddressData;
387 
388     // Mapping from token ID to approved address.
389     mapping(uint256 => address) private _tokenApprovals;
390 
391     // Mapping from owner to operator approvals
392     mapping(address => mapping(address => bool)) private _operatorApprovals;
393 
394     constructor(string memory name_, string memory symbol_) {
395         _name = name_;
396         _symbol = symbol_;
397         _currentIndex = _startTokenId();
398     }
399 
400     /**
401      * @dev Returns the starting token ID. 
402      * To change the starting token ID, please override this function.
403      */
404     function _startTokenId() internal view virtual returns (uint256) {
405         return 0;
406     }
407 
408     /**
409      * @dev Returns the next token ID to be minted.
410      */
411     function _nextTokenId() internal view returns (uint256) {
412         return _currentIndex;
413     }
414 
415     /**
416      * @dev Returns the total number of tokens in existence.
417      * Burned tokens will reduce the count. 
418      * To get the total number of tokens minted, please see `_totalMinted`.
419      */
420     function totalSupply() public view override returns (uint256) {
421         // Counter underflow is impossible as _burnCounter cannot be incremented
422         // more than `_currentIndex - _startTokenId()` times.
423         unchecked {
424             return _currentIndex - _burnCounter - _startTokenId();
425         }
426     }
427 
428     /**
429      * @dev Returns the total amount of tokens minted in the contract.
430      */
431     function _totalMinted() internal view returns (uint256) {
432         // Counter underflow is impossible as _currentIndex does not decrement,
433         // and it is initialized to `_startTokenId()`
434         unchecked {
435             return _currentIndex - _startTokenId();
436         }
437     }
438 
439     /**
440      * @dev Returns the total number of tokens burned.
441      */
442     function _totalBurned() internal view returns (uint256) {
443         return _burnCounter;
444     }
445 
446     /**
447      * @dev See {IERC165-supportsInterface}.
448      */
449     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
450         // The interface IDs are constants representing the first 4 bytes of the XOR of
451         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
452         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
453         return
454             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
455             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
456             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
457     }
458 
459     /**
460      * @dev See {IERC721-balanceOf}.
461      */
462     function balanceOf(address owner) public view override returns (uint256) {
463         if (owner == address(0)) revert BalanceQueryForZeroAddress();
464         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
465     }
466 
467     /**
468      * Returns the number of tokens minted by `owner`.
469      */
470     function _numberMinted(address owner) internal view returns (uint256) {
471         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
472     }
473 
474     /**
475      * Returns the number of tokens burned by or on behalf of `owner`.
476      */
477     function _numberBurned(address owner) internal view returns (uint256) {
478         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
479     }
480 
481     /**
482      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
483      */
484     function _getAux(address owner) internal view returns (uint64) {
485         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
486     }
487 
488     /**
489      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
490      * If there are multiple variables, please pack them into a uint64.
491      */
492     function _setAux(address owner, uint64 aux) internal {
493         uint256 packed = _packedAddressData[owner];
494         uint256 auxCasted;
495         assembly { // Cast aux without masking.
496             auxCasted := aux
497         }
498         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
499         _packedAddressData[owner] = packed;
500     }
501 
502     /**
503      * Returns the packed ownership data of `tokenId`.
504      */
505     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
506         uint256 curr = tokenId;
507 
508         unchecked {
509             if (_startTokenId() <= curr)
510                 if (curr < _currentIndex) {
511                     uint256 packed = _packedOwnerships[curr];
512                     // If not burned.
513                     if (packed & BITMASK_BURNED == 0) {
514                         // Invariant:
515                         // There will always be an ownership that has an address and is not burned
516                         // before an ownership that does not have an address and is not burned.
517                         // Hence, curr will not underflow.
518                         //
519                         // We can directly compare the packed value.
520                         // If the address is zero, packed is zero.
521                         while (packed == 0) {
522                             packed = _packedOwnerships[--curr];
523                         }
524                         return packed;
525                     }
526                 }
527         }
528         revert OwnerQueryForNonexistentToken();
529     }
530 
531     /**
532      * Returns the unpacked `TokenOwnership` struct from `packed`.
533      */
534     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
535         ownership.addr = address(uint160(packed));
536         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
537         ownership.burned = packed & BITMASK_BURNED != 0;
538     }
539 
540     /**
541      * Returns the unpacked `TokenOwnership` struct at `index`.
542      */
543     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
544         return _unpackedOwnership(_packedOwnerships[index]);
545     }
546 
547     /**
548      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
549      */
550     function _initializeOwnershipAt(uint256 index) internal {
551         if (_packedOwnerships[index] == 0) {
552             _packedOwnerships[index] = _packedOwnershipOf(index);
553         }
554     }
555 
556     /**
557      * Gas spent here starts off proportional to the maximum mint batch size.
558      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
559      */
560     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
561         return _unpackedOwnership(_packedOwnershipOf(tokenId));
562     }
563 
564     /**
565      * @dev See {IERC721-ownerOf}.
566      */
567     function ownerOf(uint256 tokenId) public view override returns (address) {
568         return address(uint160(_packedOwnershipOf(tokenId)));
569     }
570 
571     /**
572      * @dev See {IERC721Metadata-name}.
573      */
574     function name() public view virtual override returns (string memory) {
575         return _name;
576     }
577 
578     /**
579      * @dev See {IERC721Metadata-symbol}.
580      */
581     function symbol() public view virtual override returns (string memory) {
582         return _symbol;
583     }
584 
585     /**
586      * @dev See {IERC721Metadata-tokenURI}.
587      */
588     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
589         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
590 
591         string memory baseURI = _baseURI();
592         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
593     }
594 
595     /**
596      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
597      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
598      * by default, can be overriden in child contracts.
599      */
600     function _baseURI() internal view virtual returns (string memory) {
601         return '';
602     }
603 
604     /**
605      * @dev Casts the address to uint256 without masking.
606      */
607     function _addressToUint256(address value) private pure returns (uint256 result) {
608         assembly {
609             result := value
610         }
611     }
612 
613     /**
614      * @dev Casts the boolean to uint256 without branching.
615      */
616     function _boolToUint256(bool value) private pure returns (uint256 result) {
617         assembly {
618             result := value
619         }
620     }
621 
622     /**
623      * @dev See {IERC721-approve}.
624      */
625     function approve(address to, uint256 tokenId) public override {
626         address owner = address(uint160(_packedOwnershipOf(tokenId)));
627         if (to == owner) revert ApprovalToCurrentOwner();
628 
629         if (_msgSenderERC721A() != owner)
630             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
631                 revert ApprovalCallerNotOwnerNorApproved();
632             }
633 
634         _tokenApprovals[tokenId] = to;
635         emit Approval(owner, to, tokenId);
636     }
637 
638     /**
639      * @dev See {IERC721-getApproved}.
640      */
641     function getApproved(uint256 tokenId) public view override returns (address) {
642         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
643 
644         return _tokenApprovals[tokenId];
645     }
646 
647     /**
648      * @dev See {IERC721-setApprovalForAll}.
649      */
650     function setApprovalForAll(address operator, bool approved) public virtual override {
651         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
652 
653         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
654         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
655     }
656 
657     /**
658      * @dev See {IERC721-isApprovedForAll}.
659      */
660     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
661         return _operatorApprovals[owner][operator];
662     }
663 
664     /**
665      * @dev See {IERC721-transferFrom}.
666      */
667     function transferFrom(
668         address from,
669         address to,
670         uint256 tokenId
671     ) public virtual override {
672         _transfer(from, to, tokenId);
673     }
674 
675     /**
676      * @dev See {IERC721-safeTransferFrom}.
677      */
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) public virtual override {
683         safeTransferFrom(from, to, tokenId, '');
684     }
685 
686     /**
687      * @dev See {IERC721-safeTransferFrom}.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId,
693         bytes memory _data
694     ) public virtual override {
695         _transfer(from, to, tokenId);
696         if (to.code.length != 0)
697             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
698                 revert TransferToNonERC721ReceiverImplementer();
699             }
700     }
701 
702     /**
703      * @dev Returns whether `tokenId` exists.
704      *
705      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
706      *
707      * Tokens start existing when they are minted (`_mint`),
708      */
709     function _exists(uint256 tokenId) internal view returns (bool) {
710         return
711             _startTokenId() <= tokenId &&
712             tokenId < _currentIndex && // If within bounds,
713             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
714     }
715 
716     /**
717      * @dev Equivalent to `_safeMint(to, quantity, '')`.
718      */
719     function _safeMint(address to, uint256 quantity) internal {
720         _safeMint(to, quantity, '');
721     }
722 
723     /**
724      * @dev Safely mints `quantity` tokens and transfers them to `to`.
725      *
726      * Requirements:
727      *
728      * - If `to` refers to a smart contract, it must implement
729      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
730      * - `quantity` must be greater than 0.
731      *
732      * Emits a {Transfer} event.
733      */
734     function _safeMint(
735         address to,
736         uint256 quantity,
737         bytes memory _data
738     ) internal {
739         uint256 startTokenId = _currentIndex;
740         if (to == address(0)) revert MintToZeroAddress();
741         if (quantity == 0) revert MintZeroQuantity();
742 
743         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
744 
745         // Overflows are incredibly unrealistic.
746         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
747         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
748         unchecked {
749             // Updates:
750             // - `balance += quantity`.
751             // - `numberMinted += quantity`.
752             //
753             // We can directly add to the balance and number minted.
754             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
755 
756             // Updates:
757             // - `address` to the owner.
758             // - `startTimestamp` to the timestamp of minting.
759             // - `burned` to `false`.
760             // - `nextInitialized` to `quantity == 1`.
761             _packedOwnerships[startTokenId] =
762                 _addressToUint256(to) |
763                 (block.timestamp << BITPOS_START_TIMESTAMP) |
764                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
765 
766             uint256 updatedIndex = startTokenId;
767             uint256 end = updatedIndex + quantity;
768 
769             if (to.code.length != 0) {
770                 do {
771                     emit Transfer(address(0), to, updatedIndex);
772                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
773                         revert TransferToNonERC721ReceiverImplementer();
774                     }
775                 } while (updatedIndex < end);
776                 // Reentrancy protection
777                 if (_currentIndex != startTokenId) revert();
778             } else {
779                 do {
780                     emit Transfer(address(0), to, updatedIndex++);
781                 } while (updatedIndex < end);
782             }
783             _currentIndex = updatedIndex;
784         }
785         _afterTokenTransfers(address(0), to, startTokenId, quantity);
786     }
787 
788     /**
789      * @dev Mints `quantity` tokens and transfers them to `to`.
790      *
791      * Requirements:
792      *
793      * - `to` cannot be the zero address.
794      * - `quantity` must be greater than 0.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _mint(address to, uint256 quantity) internal {
799         uint256 startTokenId = _currentIndex;
800         if (to == address(0)) revert MintToZeroAddress();
801         if (quantity == 0) revert MintZeroQuantity();
802 
803         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
804 
805         // Overflows are incredibly unrealistic.
806         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
807         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
808         unchecked {
809             // Updates:
810             // - `balance += quantity`.
811             // - `numberMinted += quantity`.
812             //
813             // We can directly add to the balance and number minted.
814             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
815 
816             // Updates:
817             // - `address` to the owner.
818             // - `startTimestamp` to the timestamp of minting.
819             // - `burned` to `false`.
820             // - `nextInitialized` to `quantity == 1`.
821             _packedOwnerships[startTokenId] =
822                 _addressToUint256(to) |
823                 (block.timestamp << BITPOS_START_TIMESTAMP) |
824                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
825 
826             uint256 updatedIndex = startTokenId;
827             uint256 end = updatedIndex + quantity;
828 
829             do {
830                 emit Transfer(address(0), to, updatedIndex++);
831             } while (updatedIndex < end);
832 
833             _currentIndex = updatedIndex;
834         }
835         _afterTokenTransfers(address(0), to, startTokenId, quantity);
836     }
837 
838     /**
839      * @dev Transfers `tokenId` from `from` to `to`.
840      *
841      * Requirements:
842      *
843      * - `to` cannot be the zero address.
844      * - `tokenId` token must be owned by `from`.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _transfer(
849         address from,
850         address to,
851         uint256 tokenId
852     ) private {
853         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
854 
855         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
856 
857         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
858             isApprovedForAll(from, _msgSenderERC721A()) ||
859             getApproved(tokenId) == _msgSenderERC721A());
860 
861         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
862         if (to == address(0)) revert TransferToZeroAddress();
863 
864         _beforeTokenTransfers(from, to, tokenId, 1);
865 
866         // Clear approvals from the previous owner.
867         delete _tokenApprovals[tokenId];
868 
869         // Underflow of the sender's balance is impossible because we check for
870         // ownership above and the recipient's balance can't realistically overflow.
871         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
872         unchecked {
873             // We can directly increment and decrement the balances.
874             --_packedAddressData[from]; // Updates: `balance -= 1`.
875             ++_packedAddressData[to]; // Updates: `balance += 1`.
876 
877             // Updates:
878             // - `address` to the next owner.
879             // - `startTimestamp` to the timestamp of transfering.
880             // - `burned` to `false`.
881             // - `nextInitialized` to `true`.
882             _packedOwnerships[tokenId] =
883                 _addressToUint256(to) |
884                 (block.timestamp << BITPOS_START_TIMESTAMP) |
885                 BITMASK_NEXT_INITIALIZED;
886 
887             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
888             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
889                 uint256 nextTokenId = tokenId + 1;
890                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
891                 if (_packedOwnerships[nextTokenId] == 0) {
892                     // If the next slot is within bounds.
893                     if (nextTokenId != _currentIndex) {
894                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
895                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
896                     }
897                 }
898             }
899         }
900 
901         emit Transfer(from, to, tokenId);
902         _afterTokenTransfers(from, to, tokenId, 1);
903     }
904 
905     /**
906      * @dev Equivalent to `_burn(tokenId, false)`.
907      */
908     function _burn(uint256 tokenId) internal virtual {
909         _burn(tokenId, false);
910     }
911 
912     /**
913      * @dev Destroys `tokenId`.
914      * The approval is cleared when the token is burned.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must exist.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
923         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
924 
925         address from = address(uint160(prevOwnershipPacked));
926 
927         if (approvalCheck) {
928             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
929                 isApprovedForAll(from, _msgSenderERC721A()) ||
930                 getApproved(tokenId) == _msgSenderERC721A());
931 
932             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
933         }
934 
935         _beforeTokenTransfers(from, address(0), tokenId, 1);
936 
937         // Clear approvals from the previous owner.
938         delete _tokenApprovals[tokenId];
939 
940         // Underflow of the sender's balance is impossible because we check for
941         // ownership above and the recipient's balance can't realistically overflow.
942         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
943         unchecked {
944             // Updates:
945             // - `balance -= 1`.
946             // - `numberBurned += 1`.
947             //
948             // We can directly decrement the balance, and increment the number burned.
949             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
950             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
951 
952             // Updates:
953             // - `address` to the last owner.
954             // - `startTimestamp` to the timestamp of burning.
955             // - `burned` to `true`.
956             // - `nextInitialized` to `true`.
957             _packedOwnerships[tokenId] =
958                 _addressToUint256(from) |
959                 (block.timestamp << BITPOS_START_TIMESTAMP) |
960                 BITMASK_BURNED | 
961                 BITMASK_NEXT_INITIALIZED;
962 
963             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
964             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
965                 uint256 nextTokenId = tokenId + 1;
966                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
967                 if (_packedOwnerships[nextTokenId] == 0) {
968                     // If the next slot is within bounds.
969                     if (nextTokenId != _currentIndex) {
970                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
971                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
972                     }
973                 }
974             }
975         }
976 
977         emit Transfer(from, address(0), tokenId);
978         _afterTokenTransfers(from, address(0), tokenId, 1);
979 
980         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
981         unchecked {
982             _burnCounter++;
983         }
984     }
985 
986     /**
987      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
988      *
989      * @param from address representing the previous owner of the given token ID
990      * @param to target address that will receive the tokens
991      * @param tokenId uint256 ID of the token to be transferred
992      * @param _data bytes optional data to send along with the call
993      * @return bool whether the call correctly returned the expected magic value
994      */
995     function _checkContractOnERC721Received(
996         address from,
997         address to,
998         uint256 tokenId,
999         bytes memory _data
1000     ) private returns (bool) {
1001         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1002             bytes4 retval
1003         ) {
1004             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1005         } catch (bytes memory reason) {
1006             if (reason.length == 0) {
1007                 revert TransferToNonERC721ReceiverImplementer();
1008             } else {
1009                 assembly {
1010                     revert(add(32, reason), mload(reason))
1011                 }
1012             }
1013         }
1014     }
1015 
1016     /**
1017      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1018      * And also called before burning one token.
1019      *
1020      * startTokenId - the first token id to be transferred
1021      * quantity - the amount to be transferred
1022      *
1023      * Calling conditions:
1024      *
1025      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1026      * transferred to `to`.
1027      * - When `from` is zero, `tokenId` will be minted for `to`.
1028      * - When `to` is zero, `tokenId` will be burned by `from`.
1029      * - `from` and `to` are never both zero.
1030      */
1031     function _beforeTokenTransfers(
1032         address from,
1033         address to,
1034         uint256 startTokenId,
1035         uint256 quantity
1036     ) internal virtual {}
1037 
1038     /**
1039      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1040      * minting.
1041      * And also called after one token has been burned.
1042      *
1043      * startTokenId - the first token id to be transferred
1044      * quantity - the amount to be transferred
1045      *
1046      * Calling conditions:
1047      *
1048      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1049      * transferred to `to`.
1050      * - When `from` is zero, `tokenId` has been minted for `to`.
1051      * - When `to` is zero, `tokenId` has been burned by `from`.
1052      * - `from` and `to` are never both zero.
1053      */
1054     function _afterTokenTransfers(
1055         address from,
1056         address to,
1057         uint256 startTokenId,
1058         uint256 quantity
1059     ) internal virtual {}
1060 
1061     /**
1062      * @dev Returns the message sender (defaults to `msg.sender`).
1063      *
1064      * If you are writing GSN compatible contracts, you need to override this function.
1065      */
1066     function _msgSenderERC721A() internal view virtual returns (address) {
1067         return msg.sender;
1068     }
1069 
1070     /**
1071      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1072      */
1073     function _toString(uint256 value) internal pure returns (string memory ptr) {
1074         assembly {
1075             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1076             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1077             // We will need 1 32-byte word to store the length, 
1078             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1079             ptr := add(mload(0x40), 128)
1080             // Update the free memory pointer to allocate.
1081             mstore(0x40, ptr)
1082 
1083             // Cache the end of the memory to calculate the length later.
1084             let end := ptr
1085 
1086             // We write the string from the rightmost digit to the leftmost digit.
1087             // The following is essentially a do-while loop that also handles the zero case.
1088             // Costs a bit more than early returning for the zero case,
1089             // but cheaper in terms of deployment and overall runtime costs.
1090             for { 
1091                 // Initialize and perform the first pass without check.
1092                 let temp := value
1093                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1094                 ptr := sub(ptr, 1)
1095                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1096                 mstore8(ptr, add(48, mod(temp, 10)))
1097                 temp := div(temp, 10)
1098             } temp { 
1099                 // Keep dividing `temp` until zero.
1100                 temp := div(temp, 10)
1101             } { // Body of the for loop.
1102                 ptr := sub(ptr, 1)
1103                 mstore8(ptr, add(48, mod(temp, 10)))
1104             }
1105             
1106             let length := sub(end, ptr)
1107             // Move the pointer 32 bytes leftwards to make room for the length.
1108             ptr := sub(ptr, 32)
1109             // Store the length.
1110             mstore(ptr, length)
1111         }
1112     }
1113 }
1114 
1115 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1116 
1117 
1118 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1119 
1120 pragma solidity ^0.8.0;
1121 
1122 /**
1123  * @dev String operations.
1124  */
1125 library Strings {
1126     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1127     uint8 private constant _ADDRESS_LENGTH = 20;
1128 
1129     /**
1130      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1131      */
1132     function toString(uint256 value) internal pure returns (string memory) {
1133         // Inspired by OraclizeAPI's implementation - MIT licence
1134         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1135 
1136         if (value == 0) {
1137             return "0";
1138         }
1139         uint256 temp = value;
1140         uint256 digits;
1141         while (temp != 0) {
1142             digits++;
1143             temp /= 10;
1144         }
1145         bytes memory buffer = new bytes(digits);
1146         while (value != 0) {
1147             digits -= 1;
1148             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1149             value /= 10;
1150         }
1151         return string(buffer);
1152     }
1153 
1154     /**
1155      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1156      */
1157     function toHexString(uint256 value) internal pure returns (string memory) {
1158         if (value == 0) {
1159             return "0x00";
1160         }
1161         uint256 temp = value;
1162         uint256 length = 0;
1163         while (temp != 0) {
1164             length++;
1165             temp >>= 8;
1166         }
1167         return toHexString(value, length);
1168     }
1169 
1170     /**
1171      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1172      */
1173     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1174         bytes memory buffer = new bytes(2 * length + 2);
1175         buffer[0] = "0";
1176         buffer[1] = "x";
1177         for (uint256 i = 2 * length + 1; i > 1; --i) {
1178             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1179             value >>= 4;
1180         }
1181         require(value == 0, "Strings: hex length insufficient");
1182         return string(buffer);
1183     }
1184 
1185     /**
1186      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1187      */
1188     function toHexString(address addr) internal pure returns (string memory) {
1189         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1190     }
1191 }
1192 
1193 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1194 
1195 
1196 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1197 
1198 pragma solidity ^0.8.0;
1199 
1200 /**
1201  * @dev Provides information about the current execution context, including the
1202  * sender of the transaction and its data. While these are generally available
1203  * via msg.sender and msg.data, they should not be accessed in such a direct
1204  * manner, since when dealing with meta-transactions the account sending and
1205  * paying for execution may not be the actual sender (as far as an application
1206  * is concerned).
1207  *
1208  * This contract is only required for intermediate, library-like contracts.
1209  */
1210 abstract contract Context {
1211     function _msgSender() internal view virtual returns (address) {
1212         return msg.sender;
1213     }
1214 
1215     function _msgData() internal view virtual returns (bytes calldata) {
1216         return msg.data;
1217     }
1218 }
1219 
1220 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1221 
1222 
1223 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1224 
1225 pragma solidity ^0.8.0;
1226 
1227 
1228 /**
1229  * @dev Contract module which provides a basic access control mechanism, where
1230  * there is an account (an owner) that can be granted exclusive access to
1231  * specific functions.
1232  *
1233  * By default, the owner account will be the one that deploys the contract. This
1234  * can later be changed with {transferOwnership}.
1235  *
1236  * This module is used through inheritance. It will make available the modifier
1237  * `onlyOwner`, which can be applied to your functions to restrict their use to
1238  * the owner.
1239  */
1240 abstract contract Ownable is Context {
1241     address private _owner;
1242 
1243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1244 
1245     /**
1246      * @dev Initializes the contract setting the deployer as the initial owner.
1247      */
1248     constructor() {
1249         _transferOwnership(_msgSender());
1250     }
1251 
1252     /**
1253      * @dev Returns the address of the current owner.
1254      */
1255     function owner() public view virtual returns (address) {
1256         return _owner;
1257     }
1258 
1259     /**
1260      * @dev Throws if called by any account other than the owner.
1261      */
1262     modifier onlyOwner() {
1263         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1264         _;
1265     }
1266 
1267     /**
1268      * @dev Leaves the contract without owner. It will not be possible to call
1269      * `onlyOwner` functions anymore. Can only be called by the current owner.
1270      *
1271      * NOTE: Renouncing ownership will leave the contract without an owner,
1272      * thereby removing any functionality that is only available to the owner.
1273      */
1274     function renounceOwnership() public virtual onlyOwner {
1275         _transferOwnership(address(0));
1276     }
1277 
1278     /**
1279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1280      * Can only be called by the current owner.
1281      */
1282     function transferOwnership(address newOwner) public virtual onlyOwner {
1283         require(newOwner != address(0), "Ownable: new owner is the zero address");
1284         _transferOwnership(newOwner);
1285     }
1286 
1287     /**
1288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1289      * Internal function without access restriction.
1290      */
1291     function _transferOwnership(address newOwner) internal virtual {
1292         address oldOwner = _owner;
1293         _owner = newOwner;
1294         emit OwnershipTransferred(oldOwner, newOwner);
1295     }
1296 }
1297 
1298 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1299 
1300 
1301 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1302 
1303 pragma solidity ^0.8.1;
1304 
1305 /**
1306  * @dev Collection of functions related to the address type
1307  */
1308 library Address {
1309     /**
1310      * @dev Returns true if `account` is a contract.
1311      *
1312      * [IMPORTANT]
1313      * ====
1314      * It is unsafe to assume that an address for which this function returns
1315      * false is an externally-owned account (EOA) and not a contract.
1316      *
1317      * Among others, `isContract` will return false for the following
1318      * types of addresses:
1319      *
1320      *  - an externally-owned account
1321      *  - a contract in construction
1322      *  - an address where a contract will be created
1323      *  - an address where a contract lived, but was destroyed
1324      * ====
1325      *
1326      * [IMPORTANT]
1327      * ====
1328      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1329      *
1330      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1331      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1332      * constructor.
1333      * ====
1334      */
1335     function isContract(address account) internal view returns (bool) {
1336         // This method relies on extcodesize/address.code.length, which returns 0
1337         // for contracts in construction, since the code is only stored at the end
1338         // of the constructor execution.
1339 
1340         return account.code.length > 0;
1341     }
1342 
1343     /**
1344      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1345      * `recipient`, forwarding all available gas and reverting on errors.
1346      *
1347      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1348      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1349      * imposed by `transfer`, making them unable to receive funds via
1350      * `transfer`. {sendValue} removes this limitation.
1351      *
1352      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1353      *
1354      * IMPORTANT: because control is transferred to `recipient`, care must be
1355      * taken to not create reentrancy vulnerabilities. Consider using
1356      * {ReentrancyGuard} or the
1357      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1358      */
1359     function sendValue(address payable recipient, uint256 amount) internal {
1360         require(address(this).balance >= amount, "Address: insufficient balance");
1361 
1362         (bool success, ) = recipient.call{value: amount}("");
1363         require(success, "Address: unable to send value, recipient may have reverted");
1364     }
1365 
1366     /**
1367      * @dev Performs a Solidity function call using a low level `call`. A
1368      * plain `call` is an unsafe replacement for a function call: use this
1369      * function instead.
1370      *
1371      * If `target` reverts with a revert reason, it is bubbled up by this
1372      * function (like regular Solidity function calls).
1373      *
1374      * Returns the raw returned data. To convert to the expected return value,
1375      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1376      *
1377      * Requirements:
1378      *
1379      * - `target` must be a contract.
1380      * - calling `target` with `data` must not revert.
1381      *
1382      * _Available since v3.1._
1383      */
1384     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1385         return functionCall(target, data, "Address: low-level call failed");
1386     }
1387 
1388     /**
1389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1390      * `errorMessage` as a fallback revert reason when `target` reverts.
1391      *
1392      * _Available since v3.1._
1393      */
1394     function functionCall(
1395         address target,
1396         bytes memory data,
1397         string memory errorMessage
1398     ) internal returns (bytes memory) {
1399         return functionCallWithValue(target, data, 0, errorMessage);
1400     }
1401 
1402     /**
1403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1404      * but also transferring `value` wei to `target`.
1405      *
1406      * Requirements:
1407      *
1408      * - the calling contract must have an ETH balance of at least `value`.
1409      * - the called Solidity function must be `payable`.
1410      *
1411      * _Available since v3.1._
1412      */
1413     function functionCallWithValue(
1414         address target,
1415         bytes memory data,
1416         uint256 value
1417     ) internal returns (bytes memory) {
1418         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1419     }
1420 
1421     /**
1422      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1423      * with `errorMessage` as a fallback revert reason when `target` reverts.
1424      *
1425      * _Available since v3.1._
1426      */
1427     function functionCallWithValue(
1428         address target,
1429         bytes memory data,
1430         uint256 value,
1431         string memory errorMessage
1432     ) internal returns (bytes memory) {
1433         require(address(this).balance >= value, "Address: insufficient balance for call");
1434         require(isContract(target), "Address: call to non-contract");
1435 
1436         (bool success, bytes memory returndata) = target.call{value: value}(data);
1437         return verifyCallResult(success, returndata, errorMessage);
1438     }
1439 
1440     /**
1441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1442      * but performing a static call.
1443      *
1444      * _Available since v3.3._
1445      */
1446     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1447         return functionStaticCall(target, data, "Address: low-level static call failed");
1448     }
1449 
1450     /**
1451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1452      * but performing a static call.
1453      *
1454      * _Available since v3.3._
1455      */
1456     function functionStaticCall(
1457         address target,
1458         bytes memory data,
1459         string memory errorMessage
1460     ) internal view returns (bytes memory) {
1461         require(isContract(target), "Address: static call to non-contract");
1462 
1463         (bool success, bytes memory returndata) = target.staticcall(data);
1464         return verifyCallResult(success, returndata, errorMessage);
1465     }
1466 
1467     /**
1468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1469      * but performing a delegate call.
1470      *
1471      * _Available since v3.4._
1472      */
1473     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1474         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1475     }
1476 
1477     /**
1478      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1479      * but performing a delegate call.
1480      *
1481      * _Available since v3.4._
1482      */
1483     function functionDelegateCall(
1484         address target,
1485         bytes memory data,
1486         string memory errorMessage
1487     ) internal returns (bytes memory) {
1488         require(isContract(target), "Address: delegate call to non-contract");
1489 
1490         (bool success, bytes memory returndata) = target.delegatecall(data);
1491         return verifyCallResult(success, returndata, errorMessage);
1492     }
1493 
1494     /**
1495      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1496      * revert reason using the provided one.
1497      *
1498      * _Available since v4.3._
1499      */
1500     function verifyCallResult(
1501         bool success,
1502         bytes memory returndata,
1503         string memory errorMessage
1504     ) internal pure returns (bytes memory) {
1505         if (success) {
1506             return returndata;
1507         } else {
1508             // Look for revert reason and bubble it up if present
1509             if (returndata.length > 0) {
1510                 // The easiest way to bubble the revert reason is using memory via assembly
1511 
1512                 assembly {
1513                     let returndata_size := mload(returndata)
1514                     revert(add(32, returndata), returndata_size)
1515                 }
1516             } else {
1517                 revert(errorMessage);
1518             }
1519         }
1520     }
1521 }
1522 
1523 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1524 
1525 
1526 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1527 
1528 pragma solidity ^0.8.0;
1529 
1530 /**
1531  * @title ERC721 token receiver interface
1532  * @dev Interface for any contract that wants to support safeTransfers
1533  * from ERC721 asset contracts.
1534  */
1535 interface IERC721Receiver {
1536     /**
1537      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1538      * by `operator` from `from`, this function is called.
1539      *
1540      * It must return its Solidity selector to confirm the token transfer.
1541      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1542      *
1543      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1544      */
1545     function onERC721Received(
1546         address operator,
1547         address from,
1548         uint256 tokenId,
1549         bytes calldata data
1550     ) external returns (bytes4);
1551 }
1552 
1553 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1554 
1555 
1556 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1557 
1558 pragma solidity ^0.8.0;
1559 
1560 /**
1561  * @dev Interface of the ERC165 standard, as defined in the
1562  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1563  *
1564  * Implementers can declare support of contract interfaces, which can then be
1565  * queried by others ({ERC165Checker}).
1566  *
1567  * For an implementation, see {ERC165}.
1568  */
1569 interface IERC165 {
1570     /**
1571      * @dev Returns true if this contract implements the interface defined by
1572      * `interfaceId`. See the corresponding
1573      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1574      * to learn more about how these ids are created.
1575      *
1576      * This function call must use less than 30 000 gas.
1577      */
1578     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1579 }
1580 
1581 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1582 
1583 
1584 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 
1589 /**
1590  * @dev Implementation of the {IERC165} interface.
1591  *
1592  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1593  * for the additional interface id that will be supported. For example:
1594  *
1595  * ```solidity
1596  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1597  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1598  * }
1599  * ```
1600  *
1601  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1602  */
1603 abstract contract ERC165 is IERC165 {
1604     /**
1605      * @dev See {IERC165-supportsInterface}.
1606      */
1607     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1608         return interfaceId == type(IERC165).interfaceId;
1609     }
1610 }
1611 
1612 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1613 
1614 
1615 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1616 
1617 pragma solidity ^0.8.0;
1618 
1619 
1620 /**
1621  * @dev Required interface of an ERC721 compliant contract.
1622  */
1623 interface IERC721 is IERC165 {
1624     /**
1625      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1626      */
1627     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1628 
1629     /**
1630      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1631      */
1632     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1633 
1634     /**
1635      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1636      */
1637     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1638 
1639     /**
1640      * @dev Returns the number of tokens in ``owner``'s account.
1641      */
1642     function balanceOf(address owner) external view returns (uint256 balance);
1643 
1644     /**
1645      * @dev Returns the owner of the `tokenId` token.
1646      *
1647      * Requirements:
1648      *
1649      * - `tokenId` must exist.
1650      */
1651     function ownerOf(uint256 tokenId) external view returns (address owner);
1652 
1653     /**
1654      * @dev Safely transfers `tokenId` token from `from` to `to`.
1655      *
1656      * Requirements:
1657      *
1658      * - `from` cannot be the zero address.
1659      * - `to` cannot be the zero address.
1660      * - `tokenId` token must exist and be owned by `from`.
1661      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1662      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1663      *
1664      * Emits a {Transfer} event.
1665      */
1666     function safeTransferFrom(
1667         address from,
1668         address to,
1669         uint256 tokenId,
1670         bytes calldata data
1671     ) external;
1672 
1673     /**
1674      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1675      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1676      *
1677      * Requirements:
1678      *
1679      * - `from` cannot be the zero address.
1680      * - `to` cannot be the zero address.
1681      * - `tokenId` token must exist and be owned by `from`.
1682      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1683      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1684      *
1685      * Emits a {Transfer} event.
1686      */
1687     function safeTransferFrom(
1688         address from,
1689         address to,
1690         uint256 tokenId
1691     ) external;
1692 
1693     /**
1694      * @dev Transfers `tokenId` token from `from` to `to`.
1695      *
1696      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1697      *
1698      * Requirements:
1699      *
1700      * - `from` cannot be the zero address.
1701      * - `to` cannot be the zero address.
1702      * - `tokenId` token must be owned by `from`.
1703      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1704      *
1705      * Emits a {Transfer} event.
1706      */
1707     function transferFrom(
1708         address from,
1709         address to,
1710         uint256 tokenId
1711     ) external;
1712 
1713     /**
1714      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1715      * The approval is cleared when the token is transferred.
1716      *
1717      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1718      *
1719      * Requirements:
1720      *
1721      * - The caller must own the token or be an approved operator.
1722      * - `tokenId` must exist.
1723      *
1724      * Emits an {Approval} event.
1725      */
1726     function approve(address to, uint256 tokenId) external;
1727 
1728     /**
1729      * @dev Approve or remove `operator` as an operator for the caller.
1730      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1731      *
1732      * Requirements:
1733      *
1734      * - The `operator` cannot be the caller.
1735      *
1736      * Emits an {ApprovalForAll} event.
1737      */
1738     function setApprovalForAll(address operator, bool _approved) external;
1739 
1740     /**
1741      * @dev Returns the account approved for `tokenId` token.
1742      *
1743      * Requirements:
1744      *
1745      * - `tokenId` must exist.
1746      */
1747     function getApproved(uint256 tokenId) external view returns (address operator);
1748 
1749     /**
1750      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1751      *
1752      * See {setApprovalForAll}
1753      */
1754     function isApprovedForAll(address owner, address operator) external view returns (bool);
1755 }
1756 
1757 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1758 
1759 
1760 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1761 
1762 pragma solidity ^0.8.0;
1763 
1764 
1765 /**
1766  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1767  * @dev See https://eips.ethereum.org/EIPS/eip-721
1768  */
1769 interface IERC721Metadata is IERC721 {
1770     /**
1771      * @dev Returns the token collection name.
1772      */
1773     function name() external view returns (string memory);
1774 
1775     /**
1776      * @dev Returns the token collection symbol.
1777      */
1778     function symbol() external view returns (string memory);
1779 
1780     /**
1781      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1782      */
1783     function tokenURI(uint256 tokenId) external view returns (string memory);
1784 }
1785 
1786 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1787 
1788 
1789 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1790 
1791 pragma solidity ^0.8.0;
1792 
1793 
1794 
1795 
1796 
1797 
1798 
1799 
1800 /**
1801  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1802  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1803  * {ERC721Enumerable}.
1804  */
1805 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1806     using Address for address;
1807     using Strings for uint256;
1808 
1809     // Token name
1810     string private _name;
1811 
1812     // Token symbol
1813     string private _symbol;
1814 
1815     // Mapping from token ID to owner address
1816     mapping(uint256 => address) private _owners;
1817 
1818     // Mapping owner address to token count
1819     mapping(address => uint256) private _balances;
1820 
1821     // Mapping from token ID to approved address
1822     mapping(uint256 => address) private _tokenApprovals;
1823 
1824     // Mapping from owner to operator approvals
1825     mapping(address => mapping(address => bool)) private _operatorApprovals;
1826 
1827     /**
1828      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1829      */
1830     constructor(string memory name_, string memory symbol_) {
1831         _name = name_;
1832         _symbol = symbol_;
1833     }
1834 
1835     /**
1836      * @dev See {IERC165-supportsInterface}.
1837      */
1838     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1839         return
1840             interfaceId == type(IERC721).interfaceId ||
1841             interfaceId == type(IERC721Metadata).interfaceId ||
1842             super.supportsInterface(interfaceId);
1843     }
1844 
1845     /**
1846      * @dev See {IERC721-balanceOf}.
1847      */
1848     function balanceOf(address owner) public view virtual override returns (uint256) {
1849         require(owner != address(0), "ERC721: address zero is not a valid owner");
1850         return _balances[owner];
1851     }
1852 
1853     /**
1854      * @dev See {IERC721-ownerOf}.
1855      */
1856     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1857         address owner = _owners[tokenId];
1858         require(owner != address(0), "ERC721: owner query for nonexistent token");
1859         return owner;
1860     }
1861 
1862     /**
1863      * @dev See {IERC721Metadata-name}.
1864      */
1865     function name() public view virtual override returns (string memory) {
1866         return _name;
1867     }
1868 
1869     /**
1870      * @dev See {IERC721Metadata-symbol}.
1871      */
1872     function symbol() public view virtual override returns (string memory) {
1873         return _symbol;
1874     }
1875 
1876     /**
1877      * @dev See {IERC721Metadata-tokenURI}.
1878      */
1879     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1880         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1881 
1882         string memory baseURI = _baseURI();
1883         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1884     }
1885 
1886     /**
1887      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1888      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1889      * by default, can be overridden in child contracts.
1890      */
1891     function _baseURI() internal view virtual returns (string memory) {
1892         return "";
1893     }
1894 
1895     /**
1896      * @dev See {IERC721-approve}.
1897      */
1898     function approve(address to, uint256 tokenId) public virtual override {
1899         address owner = ERC721.ownerOf(tokenId);
1900         require(to != owner, "ERC721: approval to current owner");
1901 
1902         require(
1903             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1904             "ERC721: approve caller is not owner nor approved for all"
1905         );
1906 
1907         _approve(to, tokenId);
1908     }
1909 
1910     /**
1911      * @dev See {IERC721-getApproved}.
1912      */
1913     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1914         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1915 
1916         return _tokenApprovals[tokenId];
1917     }
1918 
1919     /**
1920      * @dev See {IERC721-setApprovalForAll}.
1921      */
1922     function setApprovalForAll(address operator, bool approved) public virtual override {
1923         _setApprovalForAll(_msgSender(), operator, approved);
1924     }
1925 
1926     /**
1927      * @dev See {IERC721-isApprovedForAll}.
1928      */
1929     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1930         return _operatorApprovals[owner][operator];
1931     }
1932 
1933     /**
1934      * @dev See {IERC721-transferFrom}.
1935      */
1936     function transferFrom(
1937         address from,
1938         address to,
1939         uint256 tokenId
1940     ) public virtual override {
1941         //solhint-disable-next-line max-line-length
1942         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1943 
1944         _transfer(from, to, tokenId);
1945     }
1946 
1947     /**
1948      * @dev See {IERC721-safeTransferFrom}.
1949      */
1950     function safeTransferFrom(
1951         address from,
1952         address to,
1953         uint256 tokenId
1954     ) public virtual override {
1955         safeTransferFrom(from, to, tokenId, "");
1956     }
1957 
1958     /**
1959      * @dev See {IERC721-safeTransferFrom}.
1960      */
1961     function safeTransferFrom(
1962         address from,
1963         address to,
1964         uint256 tokenId,
1965         bytes memory data
1966     ) public virtual override {
1967         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1968         _safeTransfer(from, to, tokenId, data);
1969     }
1970 
1971     /**
1972      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1973      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1974      *
1975      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1976      *
1977      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1978      * implement alternative mechanisms to perform token transfer, such as signature-based.
1979      *
1980      * Requirements:
1981      *
1982      * - `from` cannot be the zero address.
1983      * - `to` cannot be the zero address.
1984      * - `tokenId` token must exist and be owned by `from`.
1985      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1986      *
1987      * Emits a {Transfer} event.
1988      */
1989     function _safeTransfer(
1990         address from,
1991         address to,
1992         uint256 tokenId,
1993         bytes memory data
1994     ) internal virtual {
1995         _transfer(from, to, tokenId);
1996         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1997     }
1998 
1999     /**
2000      * @dev Returns whether `tokenId` exists.
2001      *
2002      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2003      *
2004      * Tokens start existing when they are minted (`_mint`),
2005      * and stop existing when they are burned (`_burn`).
2006      */
2007     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2008         return _owners[tokenId] != address(0);
2009     }
2010 
2011     /**
2012      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2013      *
2014      * Requirements:
2015      *
2016      * - `tokenId` must exist.
2017      */
2018     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2019         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2020         address owner = ERC721.ownerOf(tokenId);
2021         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2022     }
2023 
2024     /**
2025      * @dev Safely mints `tokenId` and transfers it to `to`.
2026      *
2027      * Requirements:
2028      *
2029      * - `tokenId` must not exist.
2030      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2031      *
2032      * Emits a {Transfer} event.
2033      */
2034     function _safeMint(address to, uint256 tokenId) internal virtual {
2035         _safeMint(to, tokenId, "");
2036     }
2037 
2038     /**
2039      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2040      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2041      */
2042     function _safeMint(
2043         address to,
2044         uint256 tokenId,
2045         bytes memory data
2046     ) internal virtual {
2047         _mint(to, tokenId);
2048         require(
2049             _checkOnERC721Received(address(0), to, tokenId, data),
2050             "ERC721: transfer to non ERC721Receiver implementer"
2051         );
2052     }
2053 
2054     /**
2055      * @dev Mints `tokenId` and transfers it to `to`.
2056      *
2057      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2058      *
2059      * Requirements:
2060      *
2061      * - `tokenId` must not exist.
2062      * - `to` cannot be the zero address.
2063      *
2064      * Emits a {Transfer} event.
2065      */
2066     function _mint(address to, uint256 tokenId) internal virtual {
2067         require(to != address(0), "ERC721: mint to the zero address");
2068         require(!_exists(tokenId), "ERC721: token already minted");
2069 
2070         _beforeTokenTransfer(address(0), to, tokenId);
2071 
2072         _balances[to] += 1;
2073         _owners[tokenId] = to;
2074 
2075         emit Transfer(address(0), to, tokenId);
2076 
2077         _afterTokenTransfer(address(0), to, tokenId);
2078     }
2079 
2080     /**
2081      * @dev Destroys `tokenId`.
2082      * The approval is cleared when the token is burned.
2083      *
2084      * Requirements:
2085      *
2086      * - `tokenId` must exist.
2087      *
2088      * Emits a {Transfer} event.
2089      */
2090     function _burn(uint256 tokenId) internal virtual {
2091         address owner = ERC721.ownerOf(tokenId);
2092 
2093         _beforeTokenTransfer(owner, address(0), tokenId);
2094 
2095         // Clear approvals
2096         _approve(address(0), tokenId);
2097 
2098         _balances[owner] -= 1;
2099         delete _owners[tokenId];
2100 
2101         emit Transfer(owner, address(0), tokenId);
2102 
2103         _afterTokenTransfer(owner, address(0), tokenId);
2104     }
2105 
2106     /**
2107      * @dev Transfers `tokenId` from `from` to `to`.
2108      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2109      *
2110      * Requirements:
2111      *
2112      * - `to` cannot be the zero address.
2113      * - `tokenId` token must be owned by `from`.
2114      *
2115      * Emits a {Transfer} event.
2116      */
2117     function _transfer(
2118         address from,
2119         address to,
2120         uint256 tokenId
2121     ) internal virtual {
2122         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2123         require(to != address(0), "ERC721: transfer to the zero address");
2124 
2125         _beforeTokenTransfer(from, to, tokenId);
2126 
2127         // Clear approvals from the previous owner
2128         _approve(address(0), tokenId);
2129 
2130         _balances[from] -= 1;
2131         _balances[to] += 1;
2132         _owners[tokenId] = to;
2133 
2134         emit Transfer(from, to, tokenId);
2135 
2136         _afterTokenTransfer(from, to, tokenId);
2137     }
2138 
2139     /**
2140      * @dev Approve `to` to operate on `tokenId`
2141      *
2142      * Emits an {Approval} event.
2143      */
2144     function _approve(address to, uint256 tokenId) internal virtual {
2145         _tokenApprovals[tokenId] = to;
2146         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2147     }
2148 
2149     /**
2150      * @dev Approve `operator` to operate on all of `owner` tokens
2151      *
2152      * Emits an {ApprovalForAll} event.
2153      */
2154     function _setApprovalForAll(
2155         address owner,
2156         address operator,
2157         bool approved
2158     ) internal virtual {
2159         require(owner != operator, "ERC721: approve to caller");
2160         _operatorApprovals[owner][operator] = approved;
2161         emit ApprovalForAll(owner, operator, approved);
2162     }
2163 
2164     /**
2165      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2166      * The call is not executed if the target address is not a contract.
2167      *
2168      * @param from address representing the previous owner of the given token ID
2169      * @param to target address that will receive the tokens
2170      * @param tokenId uint256 ID of the token to be transferred
2171      * @param data bytes optional data to send along with the call
2172      * @return bool whether the call correctly returned the expected magic value
2173      */
2174     function _checkOnERC721Received(
2175         address from,
2176         address to,
2177         uint256 tokenId,
2178         bytes memory data
2179     ) private returns (bool) {
2180         if (to.isContract()) {
2181             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2182                 return retval == IERC721Receiver.onERC721Received.selector;
2183             } catch (bytes memory reason) {
2184                 if (reason.length == 0) {
2185                     revert("ERC721: transfer to non ERC721Receiver implementer");
2186                 } else {
2187                     assembly {
2188                         revert(add(32, reason), mload(reason))
2189                     }
2190                 }
2191             }
2192         } else {
2193             return true;
2194         }
2195     }
2196 
2197     /**
2198      * @dev Hook that is called before any token transfer. This includes minting
2199      * and burning.
2200      *
2201      * Calling conditions:
2202      *
2203      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2204      * transferred to `to`.
2205      * - When `from` is zero, `tokenId` will be minted for `to`.
2206      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2207      * - `from` and `to` are never both zero.
2208      *
2209      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2210      */
2211     function _beforeTokenTransfer(
2212         address from,
2213         address to,
2214         uint256 tokenId
2215     ) internal virtual {}
2216 
2217     /**
2218      * @dev Hook that is called after any transfer of tokens. This includes
2219      * minting and burning.
2220      *
2221      * Calling conditions:
2222      *
2223      * - when `from` and `to` are both non-zero.
2224      * - `from` and `to` are never both zero.
2225      *
2226      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2227      */
2228     function _afterTokenTransfer(
2229         address from,
2230         address to,
2231         uint256 tokenId
2232     ) internal virtual {}
2233 }
2234 
2235 
2236 pragma solidity ^0.8.0;
2237 
2238 
2239 contract Pepespeepee is ERC721A, Ownable {
2240 
2241     using Strings for uint256;
2242 
2243     string private baseURI;
2244 
2245     uint256 public price = 0.0042 ether;
2246 
2247     uint256 public maxPerTx = 10;
2248 
2249     uint256 public maxFreePerWallet = 1;
2250 
2251     uint256 public totalFree = 5420;
2252 
2253     uint256 public maxSupply = 5420;
2254 
2255     bool public mintEnabled = false;
2256 
2257     mapping(address => uint256) private _mintedFreeAmount;
2258 
2259     constructor() ERC721A("Pepe's pee-pee", "PEEPEE") {
2260         _safeMint(msg.sender, 1);
2261         setBaseURI("ipfs://bafybeidrhfoqjcgndohn2jmu3icpgbn2w53zohy556o6gqhtwuhqld2tam/");
2262     }
2263 
2264     function mint(uint256 count) external payable {
2265         uint256 cost = price;
2266         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2267             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2268 
2269         if (isFree) {
2270             cost = 0;
2271         }
2272 
2273         require(msg.value >= count * cost, "Please send the exact amount.");
2274         require(totalSupply() + count < maxSupply + 1, "No more");
2275         require(mintEnabled, "Minting is not live yet");
2276         require(count < maxPerTx + 1, "Max per TX reached.");
2277 
2278         if (isFree) {
2279             _mintedFreeAmount[msg.sender] += count;
2280         }
2281 
2282         _safeMint(msg.sender, count);
2283     }
2284 
2285     function _baseURI() internal view virtual override returns (string memory) {
2286         return baseURI;
2287     }
2288 
2289     function tokenURI(uint256 tokenId)
2290         public
2291         view
2292         virtual
2293         override
2294         returns (string memory)
2295     {
2296         require(
2297             _exists(tokenId),
2298             "ERC721Metadata: URI query for nonexistent token"
2299         );
2300         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2301     }
2302 
2303     function setBaseURI(string memory uri) public onlyOwner {
2304         baseURI = uri;
2305     }
2306 
2307     function setFreeAmount(uint256 amount) external onlyOwner {
2308         totalFree = amount;
2309     }
2310 
2311     function setPrice(uint256 _newPrice) external onlyOwner {
2312         price = _newPrice;
2313     }
2314 
2315     function flipSale() external onlyOwner {
2316         mintEnabled = !mintEnabled;
2317     }
2318 
2319     function withdraw() external onlyOwner {
2320         (bool success, ) = payable(msg.sender).call{
2321             value: address(this).balance
2322         }("");
2323         require(success, "Transfer failed.");
2324     }
2325 }