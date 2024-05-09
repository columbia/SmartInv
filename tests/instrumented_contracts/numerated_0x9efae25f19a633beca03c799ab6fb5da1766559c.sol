1 /**
2 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
3 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@@@@@
5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@00@@@@@@@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@C;1@@@@@@@00@@0@0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@0;;;;;;;;i@0@@@@@0@@@0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@0;;;;;;;;;;;;;;;@0@@@@0@@@00@0@@@@@@@@@@@@@@@@@@@@@@@@@@
9 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@@t;;;;;;;;;;;;;;;;;;;;@00@@@@@@@118@@@@@@@0@@0@@@@@@@@@@@@@@@
10 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8@@L;;;;;;;;;;;;;;;;;;;;;;;;;;@0@@@@@@@@@@@@80@@0@@@@@@@@@@@@@@@@@@@
11 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@C;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1@@@@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@@@@
12 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@0;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;@0@@@@@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@
13 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@0;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;@0@@@@@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@@@@@@@@@@@@@@00@@0@0@@00@@@t;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;@0@0@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@@@
15 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@@@L;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;G@@@@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@@@@
16 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@811tfffLGGCCCC888800@@@00;;;;;;;;;;;;;;@@@@@@@@@@@@@t;;0@@@@@@@@@@@0@@@@@@@@@@@@@0@@@@@@@@@@@@
17 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@;;;;;;;;;;;;0@0fC@8::::;@@@;;;;;;;;;i@@@@i,,,,,,;@@@@@@@@@@@@@@@@@@00@@@CLG8@@@@@@@@@@@@@@@@@@
18 @@@@@@@@@@@@@@@@@@@@@@@@0@@@00;;;LC@@@@@@@@@@@@@@00::::G@,f@1;;;;;f@@@@@@0,,,,@0@@@@@@@@@@@@@@@0@@LLLLLLL8@0LL@0@@@@@@@@@@@@@
19 @@@@@@@@@@@@@@@@@@@@@0@C;;C@@@8i@                  1@@::@L,,G@;;;;@8@@@@@@,,:@0@@@@@@@@@@@@@@@@0LLLLLLL@0LLLLLL@@@@@@@@@@@@@@
20 @@@@@@@@@@@@@@@@@@@@00@@C;;;;;t@                      @;:@,,,,@;;;@ @@@@@G,@0@@@@@@@@@@@@@@@@0@GLLLLLLLLLLLLC0@@@@@@000@@@@@@
21 @@@@@@@@@@@@@@00@@0@@it@@0;;;1@         @@            @::1@,,.@@;;@@@@@@1,@0@@@@@@@@@@@@@@@@@@@0@CLLLLLLLLLLL0@@@@@@@@@@@@@@@
22 @@@@@@@@@@@@@@@@0@::@1;;;;;;;@         L@@.         8@@@@C8@,,,@L;@@@@i,0@@@@@@@@@@@@@@@@@@@@@@@@0@LLLLLLLL@@@@@@@@@@@@@@@@@@
23 @@@@@@@@@@@@@@@00::::C@1;;;i@.                   i@0;;;;;;;@1,,:@;@i,,.@@@::@@@@@@@@@@@@@@@@@@@@@@@0@LLG@@@@@@@@@@@@@@@@@@@@@
24 @@@@@@@@@@@@@@@0@::::@;;;;;@0                L@@@t1:,,,,,,,,@,,,@;@G,8@@G:::@@@@@@@@@@@@@@@@@@@@@@@@@00@@@@@@@@@@@@@@@@@@@@@@
25 @@@@@@@@@@@@@@@@@@@800;;;;;@          1@@@@C1t1@f1,,,,,,,,,,1@,,@LC0@L@8;:::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
26 @@@@@@@@@@@@@@@@@@@@00L0@@@@@@@@@0GLf1fff111f1@81,,,,,,,,,,,,00,08L@108:::::::::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@00@@@@@@
27 @@@@@@@@@@@@@@@@@@@@@@;;;;;;C@1ft11tt1tt1t1ftf@11,,,,,,,,,,,,,@;t@t@C@::::::::::@@@@@@@0@0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@@@@@
28 @@@@@@@@@@@@@@@@@@@@@@@0;;;;;@ft1t11ftfftf1ft@G111,,,,,,,,,,,,,@@@1@@::::::::::@@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8@@@@@@
29 @@@@@@@@@@@@@@@@@@@@@@@@0@@@C8@f1ff1f1ffff1tf@11101:,,,,,,,,,,,,;@i@f:::::::::@@@@@@@@@@@0@@@@@@@@@@@@@@@@@@@@@@@@@@@@G@@@@@@
30 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ff1f1f1f1ffft@01111@0111;,,,,;111@@1@::::::::@@@@@@@@@@@@@@0@0@@@@@0@@@0@@@@@@@@@@@@@@@G@0@@@@
31 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0Ltf1tff1tftft@f111111G@@@@00@@@@fG@1@:::::;@@@8@0@@@@@@@@@00@@0@@@@@@@@@@@@@@@@@@@@@@@@C8@@@@@
32 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@1ftft1fff1ft@111111111111111111108t@:1@@8GGGGGGC@0000@@@@8C00CC@8CCGGGC@0@@@@@@@@@@@@00C@@@@@
33 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@1ftttf1fft1f@111111111@C@G111111@Gt@0GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG0@@@@@@@@@@@@@GG@@@@@
34 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@1f1t1ftttf1t@11111118@;;;L@t1111@;t@GLLGGGGG@8G8@GGGGGGGGGGGGGGGGGGGGGLGGG@0@@@@@@@@@GGG@0@@@
35 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0Ltft1ftttf1f@111111@C;;;C@G11111@;t@LGGGGGGGGGGGGGGGGGGGGf;GGGGGGGG;;GGi;GG@0@@@@@@@GGLG@0@@@
36 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@00ff1tf1tf11f@1111C@;;i@@1111111t@;L@LGGGGLLGGGGGGGGGGGGGGi1GGG@GG;fGGGGGL;GG@@@@0@GGGLLG00@@@
37 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@081f1tff1t11f@L11110@@t11111111100;80GGGGLGGGGLGGGGGGGGGGG;LGG@GGGGGG@@i@GtLGC@@@CGLGLLGG0@@@@
38 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@11ft1tffttf1L@110@GG0CCft1@f:1@@f;@8GGGGLGGGLGGGGGGGGGGGG;GGG8@GG@@:,@::@GGGG@@GGLGGGGC@0@@@@
39 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@f1ff1ff1f1ff0@01tfttttf1110@:@@;;@0GGGGGGGGLGGGGGGGGGGGG;GGG@GGCC0@@:8@:@GGGC@GLGLLG@0@@@@@@
40 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@1ttf1f1f11t1t11ft11t11f1tf@G@;;@0GGGGGGG8@@GGGGC@8GGGG;LGGC@@8GGG8@8@0@@GGG@CGGLGC@@@@@@@@
41 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@C0@@@@f@1iii@t11111ft1f1tff1f111@@;;0@@@@@@@@0@8GLG@@GGGG@GGi;GGGGGC@8G0@CGGGGGG0@GLLG00@@@@@@@
42 @@@@@@@@@@@@@@@@@@@@@@@@@@@0tiiiii@@iiiiiiii@f1f1111f1ft1f1ftt1@G;@8CCCCCCCC@fffff0@8@@@GGGG;iGGGGC@GGGGGGGGGGC@GLGG@0@@@@@@@
43 @@@@@@@@@@@@@@@@@@@@@@@@@@0Liiiiiiiii1fG0000@@1ft11ftt1fftf1f11tG@CCCCCCCCC@ffffff8@@G@8GGGGG;GGGGG@GGGGGGGGGGG@GGG8@@@@@@@@@
44 @@@@@@@@@@@@@@@@@@@@@@@@@@00ttttttttttttttttGLf1f11tf1ftf1fC@@@@@0CCCCCCCC@0fffffff@00GC@@GGG;GGGGC@GGGGGGGGGGG@GG0@@@@@@@@@@
45 @@@@@@@@@@@@@@@@@@@@@@@@@@ttttttttttttttttt@1ft11f111tf11@8CCCCCCCCCCCCCCC@ffffffff@C0@GGG@0GGGGGGC@GGGGGGGGG0@@@0@@@@@@@@@@@
46 @@@@@@@@@@@@@@@@@@@@@@@@@@0@Ltttttttttttt@81f11ttf1t111f@8CCCCCCCCCCCCCCC@fffffffff00C0@GGG@C8@@@@@GGGGGGGG0@0@@@@@@@@@@@@@@@
47 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@8@000t00@C@01111ttfftff@8CCCCCCCCCCCCCCC00ffffffffff@CC0@GGGGGGGGGGGGGGGG@@@@@@@@@@@@@@@@@@@@
48 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@CCCCC80@LLLGC0@0CCCCCCCCCCCCCCCC@fffffffffff@CCC0@GGGGGGGGGGGG0@0@@@@@@@@@@@@@@@@@@@@
49 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0CCCCCCCC@0ffffff0@CCCCCCCCCCCCCC@Lfffffffffff@0CCC8@0CGGGGG0@@0@@@@@@@@@@@@@@@@@@@@@@@
50 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0CCCCCCCCCC@8ffffff0@CCCCCCCCCCCC8@ffffffffLLffL@CCCC8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
51 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8CCCCCCCCCCCC@8ffffff8@CCCCCCCCCCC@ffffffff@CCCCCCCCCCCC@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
52 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8CCCCCCCCCCCCCC@8ffffffC@CCCCCCCCC0@fffffff@8CCCCCCCCCCCCC@@@@@@@00@@@0@@@@@@@@@@@@@@@@@@@
53 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@8CCCCCCCCCCCCCCC8@fffffffG@CCCCCCCC@fffffff00CCCCCCCCCCCCCCC@@0@@8CCCCC@@@@@@@@@@@@@@@@@@@@
54 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@CCCCCCCCCCCCCCCC0@ffffffffff@CCCCCC@Cffffff8@CCCCCCCC@CCCCCCCCCCCCCCCCCC@0@@@@@@@@@@@@@@@@@@
55 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@CCCCCCCC00CCCCCCC@Cffffffffffff@CCCC8@ffffffL@CCCCCCCCCC@CCCCCCCCCCCCCCCCCC@@@@@@@@@@@@@@@@@@@
56 @@@@@@@@@@@@@@@@@@@@@@@@@@0@0CCCCCCCCC00CCCCCC8@fffffffffffffff@CCC@fffffff@CCCCCCCCCCC0@CCCCCCCCCCCCCCCCC@0@@@@@@@@@@@@@@@@@
57 @@@@@@@@@@@@@@@@@@@@@@@@@@8CCCCCCCCCC8@CCCCCC@0ttttfttffffffffff@0@fffffff@CCCCCCCCCCCCC@8CCCCCCCCCCCCCCCC8@@@@@@@@@@@@@@@@@@
58 @@@@@@@@@@@@@@@@@@@@@@@@0@CCCCCCCCCCC@0CCCCCCCCCCCCCCCCCCCC800@@@@fffffff@0CCCCCCCCCCCCCC@CCCCCCCCCCCCCCCCC@@@@@@@@@@@@@@@@@@
59 @@@@@@@@@@@@@@@@@@@@@@@@@0@CCCCCCCCCC8@CCCCCCCCCCCCCCCCCCCCCCC@CC@ffffffL@CCCCCCCCCCCCCCCC@0CCCCCCCCCCCCCCC@0@@@@@@@@@@@@@@@@
60 @@@@@@@@@@@@@@@@@@@@@@@@@@0@CCCCCCCCCC@CCCCCCCCCCCCCCCCCCCCCCC088@ffffff@CCCCCCCCCCCCCCCCCCC@CCCCCCCCCCCCCC8@@@@@@@@@@@@@@@@@
61 @@@@@@@@@@@@@@@@@@@@@@@@@@@0@CCCCCCCCC0@CCCCCCCCCCCCCCCCCCCCCC0800fffff00CCCCCCCCCCCCCCCCCCC@CCCCCCCCCCCCCCC@@@@@@@@@@@@@@@@@
62 @@@@@@@@@@@@@@@@@@@@@@@@@@@@00CCCCCCCCC@CCCCCCCCCCCCCCCCCCCCCC@C00ffffC@CCCCCCCCCCCCCCCCCCCC00CCCCCCCCCCCCCC@0@@@@@@@@@@@@@@@
63 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@00CCCCCCCC8@CCCCCCCCCCCCCCCCCCCCCCC00ffff@CCCCCCCCCCCCCCCCCCCCC8@CCCCCCCCCCCCCC00@@@@@@@@@@@@@@@
64 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0@CCCCCCCC@8CCCCCCCCCCCCCCCCCCCC@C00fff@8CCCCCCCCCCCCCCCCCCCCCC@CCCCCCCCCCCCCCC@@@@@@@@@@@@@@@@
65 */
66 // SPDX-License-Identifier: MIT
67 // File: @openzeppelin/contracts/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/access/Ownable.sol
95 
96 
97 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     /**
127      * @dev Throws if called by any account other than the owner.
128      */
129     modifier onlyOwner() {
130         _checkOwner();
131         _;
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if the sender is not the owner.
143      */
144     function _checkOwner() internal view virtual {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: erc721a/contracts/IERC721A.sol
180 
181 
182 // ERC721A Contracts v4.1.0
183 // Creator: Chiru Labs
184 
185 pragma solidity ^0.8.4;
186 
187 /**
188  * @dev Interface of an ERC721A compliant contract.
189  */
190 interface IERC721A {
191     /**
192      * The caller must own the token or be an approved operator.
193      */
194     error ApprovalCallerNotOwnerNorApproved();
195 
196     /**
197      * The token does not exist.
198      */
199     error ApprovalQueryForNonexistentToken();
200 
201     /**
202      * The caller cannot approve to their own address.
203      */
204     error ApproveToCaller();
205 
206     /**
207      * Cannot query the balance for the zero address.
208      */
209     error BalanceQueryForZeroAddress();
210 
211     /**
212      * Cannot mint to the zero address.
213      */
214     error MintToZeroAddress();
215 
216     /**
217      * The quantity of tokens minted must be more than zero.
218      */
219     error MintZeroQuantity();
220 
221     /**
222      * The token does not exist.
223      */
224     error OwnerQueryForNonexistentToken();
225 
226     /**
227      * The caller must own the token or be an approved operator.
228      */
229     error TransferCallerNotOwnerNorApproved();
230 
231     /**
232      * The token must be owned by `from`.
233      */
234     error TransferFromIncorrectOwner();
235 
236     /**
237      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
238      */
239     error TransferToNonERC721ReceiverImplementer();
240 
241     /**
242      * Cannot transfer to the zero address.
243      */
244     error TransferToZeroAddress();
245 
246     /**
247      * The token does not exist.
248      */
249     error URIQueryForNonexistentToken();
250 
251     /**
252      * The `quantity` minted with ERC2309 exceeds the safety limit.
253      */
254     error MintERC2309QuantityExceedsLimit();
255 
256     /**
257      * The `extraData` cannot be set on an unintialized ownership slot.
258      */
259     error OwnershipNotInitializedForExtraData();
260 
261     struct TokenOwnership {
262         // The address of the owner.
263         address addr;
264         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
265         uint64 startTimestamp;
266         // Whether the token has been burned.
267         bool burned;
268         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
269         uint24 extraData;
270     }
271 
272     /**
273      * @dev Returns the total amount of tokens stored by the contract.
274      *
275      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
276      */
277     function totalSupply() external view returns (uint256);
278 
279     // ==============================
280     //            IERC165
281     // ==============================
282 
283     /**
284      * @dev Returns true if this contract implements the interface defined by
285      * `interfaceId`. See the corresponding
286      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
287      * to learn more about how these ids are created.
288      *
289      * This function call must use less than 30 000 gas.
290      */
291     function supportsInterface(bytes4 interfaceId) external view returns (bool);
292 
293     // ==============================
294     //            IERC721
295     // ==============================
296 
297     /**
298      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
299      */
300     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
301 
302     /**
303      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
304      */
305     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
306 
307     /**
308      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
309      */
310     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
311 
312     /**
313      * @dev Returns the number of tokens in ``owner``'s account.
314      */
315     function balanceOf(address owner) external view returns (uint256 balance);
316 
317     /**
318      * @dev Returns the owner of the `tokenId` token.
319      *
320      * Requirements:
321      *
322      * - `tokenId` must exist.
323      */
324     function ownerOf(uint256 tokenId) external view returns (address owner);
325 
326     /**
327      * @dev Safely transfers `tokenId` token from `from` to `to`.
328      *
329      * Requirements:
330      *
331      * - `from` cannot be the zero address.
332      * - `to` cannot be the zero address.
333      * - `tokenId` token must exist and be owned by `from`.
334      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
335      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
336      *
337      * Emits a {Transfer} event.
338      */
339     function safeTransferFrom(
340         address from,
341         address to,
342         uint256 tokenId,
343         bytes calldata data
344     ) external;
345 
346     /**
347      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
348      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
349      *
350      * Requirements:
351      *
352      * - `from` cannot be the zero address.
353      * - `to` cannot be the zero address.
354      * - `tokenId` token must exist and be owned by `from`.
355      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
356      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
357      *
358      * Emits a {Transfer} event.
359      */
360     function safeTransferFrom(
361         address from,
362         address to,
363         uint256 tokenId
364     ) external;
365 
366     /**
367      * @dev Transfers `tokenId` token from `from` to `to`.
368      *
369      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
370      *
371      * Requirements:
372      *
373      * - `from` cannot be the zero address.
374      * - `to` cannot be the zero address.
375      * - `tokenId` token must be owned by `from`.
376      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transferFrom(
381         address from,
382         address to,
383         uint256 tokenId
384     ) external;
385 
386     /**
387      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
388      * The approval is cleared when the token is transferred.
389      *
390      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
391      *
392      * Requirements:
393      *
394      * - The caller must own the token or be an approved operator.
395      * - `tokenId` must exist.
396      *
397      * Emits an {Approval} event.
398      */
399     function approve(address to, uint256 tokenId) external;
400 
401     /**
402      * @dev Approve or remove `operator` as an operator for the caller.
403      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
404      *
405      * Requirements:
406      *
407      * - The `operator` cannot be the caller.
408      *
409      * Emits an {ApprovalForAll} event.
410      */
411     function setApprovalForAll(address operator, bool _approved) external;
412 
413     /**
414      * @dev Returns the account approved for `tokenId` token.
415      *
416      * Requirements:
417      *
418      * - `tokenId` must exist.
419      */
420     function getApproved(uint256 tokenId) external view returns (address operator);
421 
422     /**
423      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
424      *
425      * See {setApprovalForAll}
426      */
427     function isApprovedForAll(address owner, address operator) external view returns (bool);
428 
429     // ==============================
430     //        IERC721Metadata
431     // ==============================
432 
433     /**
434      * @dev Returns the token collection name.
435      */
436     function name() external view returns (string memory);
437 
438     /**
439      * @dev Returns the token collection symbol.
440      */
441     function symbol() external view returns (string memory);
442 
443     /**
444      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
445      */
446     function tokenURI(uint256 tokenId) external view returns (string memory);
447 
448     // ==============================
449     //            IERC2309
450     // ==============================
451 
452     /**
453      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
454      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
455      */
456     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
457 }
458 
459 // File: erc721a/contracts/ERC721A.sol
460 
461 
462 // ERC721A Contracts v4.1.0
463 // Creator: Chiru Labs
464 
465 pragma solidity ^0.8.4;
466 
467 
468 /**
469  * @dev ERC721 token receiver interface.
470  */
471 interface ERC721A__IERC721Receiver {
472     function onERC721Received(
473         address operator,
474         address from,
475         uint256 tokenId,
476         bytes calldata data
477     ) external returns (bytes4);
478 }
479 
480 /**
481  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
482  * including the Metadata extension. Built to optimize for lower gas during batch mints.
483  *
484  * Assumes serials are sequentially minted starting at `_startTokenId()`
485  * (defaults to 0, e.g. 0, 1, 2, 3..).
486  *
487  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
488  *
489  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
490  */
491 contract ERC721A is IERC721A {
492     // Mask of an entry in packed address data.
493     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
494 
495     // The bit position of `numberMinted` in packed address data.
496     uint256 private constant BITPOS_NUMBER_MINTED = 64;
497 
498     // The bit position of `numberBurned` in packed address data.
499     uint256 private constant BITPOS_NUMBER_BURNED = 128;
500 
501     // The bit position of `aux` in packed address data.
502     uint256 private constant BITPOS_AUX = 192;
503 
504     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
505     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
506 
507     // The bit position of `startTimestamp` in packed ownership.
508     uint256 private constant BITPOS_START_TIMESTAMP = 160;
509 
510     // The bit mask of the `burned` bit in packed ownership.
511     uint256 private constant BITMASK_BURNED = 1 << 224;
512 
513     // The bit position of the `nextInitialized` bit in packed ownership.
514     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
515 
516     // The bit mask of the `nextInitialized` bit in packed ownership.
517     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
518 
519     // The bit position of `extraData` in packed ownership.
520     uint256 private constant BITPOS_EXTRA_DATA = 232;
521 
522     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
523     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
524 
525     // The mask of the lower 160 bits for addresses.
526     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
527 
528     // The maximum `quantity` that can be minted with `_mintERC2309`.
529     // This limit is to prevent overflows on the address data entries.
530     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
531     // is required to cause an overflow, which is unrealistic.
532     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
533 
534     // The tokenId of the next token to be minted.
535     uint256 private _currentIndex;
536 
537     // The number of tokens burned.
538     uint256 private _burnCounter;
539 
540     // Token name
541     string private _name;
542 
543     // Token symbol
544     string private _symbol;
545 
546     // Mapping from token ID to ownership details
547     // An empty struct value does not necessarily mean the token is unowned.
548     // See `_packedOwnershipOf` implementation for details.
549     //
550     // Bits Layout:
551     // - [0..159]   `addr`
552     // - [160..223] `startTimestamp`
553     // - [224]      `burned`
554     // - [225]      `nextInitialized`
555     // - [232..255] `extraData`
556     mapping(uint256 => uint256) private _packedOwnerships;
557 
558     // Mapping owner address to address data.
559     //
560     // Bits Layout:
561     // - [0..63]    `balance`
562     // - [64..127]  `numberMinted`
563     // - [128..191] `numberBurned`
564     // - [192..255] `aux`
565     mapping(address => uint256) private _packedAddressData;
566 
567     // Mapping from token ID to approved address.
568     mapping(uint256 => address) private _tokenApprovals;
569 
570     // Mapping from owner to operator approvals
571     mapping(address => mapping(address => bool)) private _operatorApprovals;
572 
573     constructor(string memory name_, string memory symbol_) {
574         _name = name_;
575         _symbol = symbol_;
576         _currentIndex = _startTokenId();
577     }
578 
579     /**
580      * @dev Returns the starting token ID.
581      * To change the starting token ID, please override this function.
582      */
583     function _startTokenId() internal view virtual returns (uint256) {
584         return 0;
585     }
586 
587     /**
588      * @dev Returns the next token ID to be minted.
589      */
590     function _nextTokenId() internal view returns (uint256) {
591         return _currentIndex;
592     }
593 
594     /**
595      * @dev Returns the total number of tokens in existence.
596      * Burned tokens will reduce the count.
597      * To get the total number of tokens minted, please see `_totalMinted`.
598      */
599     function totalSupply() public view override returns (uint256) {
600         // Counter underflow is impossible as _burnCounter cannot be incremented
601         // more than `_currentIndex - _startTokenId()` times.
602         unchecked {
603             return _currentIndex - _burnCounter - _startTokenId();
604         }
605     }
606 
607     /**
608      * @dev Returns the total amount of tokens minted in the contract.
609      */
610     function _totalMinted() internal view returns (uint256) {
611         // Counter underflow is impossible as _currentIndex does not decrement,
612         // and it is initialized to `_startTokenId()`
613         unchecked {
614             return _currentIndex - _startTokenId();
615         }
616     }
617 
618     /**
619      * @dev Returns the total number of tokens burned.
620      */
621     function _totalBurned() internal view returns (uint256) {
622         return _burnCounter;
623     }
624 
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
629         // The interface IDs are constants representing the first 4 bytes of the XOR of
630         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
631         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
632         return
633             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
634             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
635             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
636     }
637 
638     /**
639      * @dev See {IERC721-balanceOf}.
640      */
641     function balanceOf(address owner) public view override returns (uint256) {
642         if (owner == address(0)) revert BalanceQueryForZeroAddress();
643         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
644     }
645 
646     /**
647      * Returns the number of tokens minted by `owner`.
648      */
649     function _numberMinted(address owner) internal view returns (uint256) {
650         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
651     }
652 
653     /**
654      * Returns the number of tokens burned by or on behalf of `owner`.
655      */
656     function _numberBurned(address owner) internal view returns (uint256) {
657         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
658     }
659 
660     /**
661      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
662      */
663     function _getAux(address owner) internal view returns (uint64) {
664         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
665     }
666 
667     /**
668      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
669      * If there are multiple variables, please pack them into a uint64.
670      */
671     function _setAux(address owner, uint64 aux) internal {
672         uint256 packed = _packedAddressData[owner];
673         uint256 auxCasted;
674         // Cast `aux` with assembly to avoid redundant masking.
675         assembly {
676             auxCasted := aux
677         }
678         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
679         _packedAddressData[owner] = packed;
680     }
681 
682     /**
683      * Returns the packed ownership data of `tokenId`.
684      */
685     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
686         uint256 curr = tokenId;
687 
688         unchecked {
689             if (_startTokenId() <= curr)
690                 if (curr < _currentIndex) {
691                     uint256 packed = _packedOwnerships[curr];
692                     // If not burned.
693                     if (packed & BITMASK_BURNED == 0) {
694                         // Invariant:
695                         // There will always be an ownership that has an address and is not burned
696                         // before an ownership that does not have an address and is not burned.
697                         // Hence, curr will not underflow.
698                         //
699                         // We can directly compare the packed value.
700                         // If the address is zero, packed is zero.
701                         while (packed == 0) {
702                             packed = _packedOwnerships[--curr];
703                         }
704                         return packed;
705                     }
706                 }
707         }
708         revert OwnerQueryForNonexistentToken();
709     }
710 
711     /**
712      * Returns the unpacked `TokenOwnership` struct from `packed`.
713      */
714     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
715         ownership.addr = address(uint160(packed));
716         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
717         ownership.burned = packed & BITMASK_BURNED != 0;
718         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
719     }
720 
721     /**
722      * Returns the unpacked `TokenOwnership` struct at `index`.
723      */
724     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
725         return _unpackedOwnership(_packedOwnerships[index]);
726     }
727 
728     /**
729      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
730      */
731     function _initializeOwnershipAt(uint256 index) internal {
732         if (_packedOwnerships[index] == 0) {
733             _packedOwnerships[index] = _packedOwnershipOf(index);
734         }
735     }
736 
737     /**
738      * Gas spent here starts off proportional to the maximum mint batch size.
739      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
740      */
741     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
742         return _unpackedOwnership(_packedOwnershipOf(tokenId));
743     }
744 
745     /**
746      * @dev Packs ownership data into a single uint256.
747      */
748     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
749         assembly {
750             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
751             owner := and(owner, BITMASK_ADDRESS)
752             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
753             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
754         }
755     }
756 
757     /**
758      * @dev See {IERC721-ownerOf}.
759      */
760     function ownerOf(uint256 tokenId) public view override returns (address) {
761         return address(uint160(_packedOwnershipOf(tokenId)));
762     }
763 
764     /**
765      * @dev See {IERC721Metadata-name}.
766      */
767     function name() public view virtual override returns (string memory) {
768         return _name;
769     }
770 
771     /**
772      * @dev See {IERC721Metadata-symbol}.
773      */
774     function symbol() public view virtual override returns (string memory) {
775         return _symbol;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-tokenURI}.
780      */
781     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
782         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
783 
784         string memory baseURI = _baseURI();
785         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
786     }
787 
788     /**
789      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
790      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
791      * by default, it can be overridden in child contracts.
792      */
793     function _baseURI() internal view virtual returns (string memory) {
794         return '';
795     }
796 
797     /**
798      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
799      */
800     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
801         // For branchless setting of the `nextInitialized` flag.
802         assembly {
803             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
804             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
805         }
806     }
807 
808     /**
809      * @dev See {IERC721-approve}.
810      */
811     function approve(address to, uint256 tokenId) public override {
812         address owner = ownerOf(tokenId);
813 
814         if (_msgSenderERC721A() != owner)
815             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
816                 revert ApprovalCallerNotOwnerNorApproved();
817             }
818 
819         _tokenApprovals[tokenId] = to;
820         emit Approval(owner, to, tokenId);
821     }
822 
823     /**
824      * @dev See {IERC721-getApproved}.
825      */
826     function getApproved(uint256 tokenId) public view override returns (address) {
827         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
828 
829         return _tokenApprovals[tokenId];
830     }
831 
832     /**
833      * @dev See {IERC721-setApprovalForAll}.
834      */
835     function setApprovalForAll(address operator, bool approved) public virtual override {
836         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
837 
838         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
839         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
840     }
841 
842     /**
843      * @dev See {IERC721-isApprovedForAll}.
844      */
845     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
846         return _operatorApprovals[owner][operator];
847     }
848 
849     /**
850      * @dev See {IERC721-safeTransferFrom}.
851      */
852     function safeTransferFrom(
853         address from,
854         address to,
855         uint256 tokenId
856     ) public virtual override {
857         safeTransferFrom(from, to, tokenId, '');
858     }
859 
860     /**
861      * @dev See {IERC721-safeTransferFrom}.
862      */
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) public virtual override {
869         transferFrom(from, to, tokenId);
870         if (to.code.length != 0)
871             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
872                 revert TransferToNonERC721ReceiverImplementer();
873             }
874     }
875 
876     /**
877      * @dev Returns whether `tokenId` exists.
878      *
879      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
880      *
881      * Tokens start existing when they are minted (`_mint`),
882      */
883     function _exists(uint256 tokenId) internal view returns (bool) {
884         return
885             _startTokenId() <= tokenId &&
886             tokenId < _currentIndex && // If within bounds,
887             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
888     }
889 
890     /**
891      * @dev Equivalent to `_safeMint(to, quantity, '')`.
892      */
893     function _safeMint(address to, uint256 quantity) internal {
894         _safeMint(to, quantity, '');
895     }
896 
897     /**
898      * @dev Safely mints `quantity` tokens and transfers them to `to`.
899      *
900      * Requirements:
901      *
902      * - If `to` refers to a smart contract, it must implement
903      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
904      * - `quantity` must be greater than 0.
905      *
906      * See {_mint}.
907      *
908      * Emits a {Transfer} event for each mint.
909      */
910     function _safeMint(
911         address to,
912         uint256 quantity,
913         bytes memory _data
914     ) internal {
915         _mint(to, quantity);
916 
917         unchecked {
918             if (to.code.length != 0) {
919                 uint256 end = _currentIndex;
920                 uint256 index = end - quantity;
921                 do {
922                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
923                         revert TransferToNonERC721ReceiverImplementer();
924                     }
925                 } while (index < end);
926                 // Reentrancy protection.
927                 if (_currentIndex != end) revert();
928             }
929         }
930     }
931 
932     /**
933      * @dev Mints `quantity` tokens and transfers them to `to`.
934      *
935      * Requirements:
936      *
937      * - `to` cannot be the zero address.
938      * - `quantity` must be greater than 0.
939      *
940      * Emits a {Transfer} event for each mint.
941      */
942     function _mint(address to, uint256 quantity) internal {
943         uint256 startTokenId = _currentIndex;
944         if (to == address(0)) revert MintToZeroAddress();
945         if (quantity == 0) revert MintZeroQuantity();
946 
947         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
948 
949         // Overflows are incredibly unrealistic.
950         // `balance` and `numberMinted` have a maximum limit of 2**64.
951         // `tokenId` has a maximum limit of 2**256.
952         unchecked {
953             // Updates:
954             // - `balance += quantity`.
955             // - `numberMinted += quantity`.
956             //
957             // We can directly add to the `balance` and `numberMinted`.
958             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
959 
960             // Updates:
961             // - `address` to the owner.
962             // - `startTimestamp` to the timestamp of minting.
963             // - `burned` to `false`.
964             // - `nextInitialized` to `quantity == 1`.
965             _packedOwnerships[startTokenId] = _packOwnershipData(
966                 to,
967                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
968             );
969 
970             uint256 tokenId = startTokenId;
971             uint256 end = startTokenId + quantity;
972             do {
973                 emit Transfer(address(0), to, tokenId++);
974             } while (tokenId < end);
975 
976             _currentIndex = end;
977         }
978         _afterTokenTransfers(address(0), to, startTokenId, quantity);
979     }
980 
981     /**
982      * @dev Mints `quantity` tokens and transfers them to `to`.
983      *
984      * This function is intended for efficient minting only during contract creation.
985      *
986      * It emits only one {ConsecutiveTransfer} as defined in
987      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
988      * instead of a sequence of {Transfer} event(s).
989      *
990      * Calling this function outside of contract creation WILL make your contract
991      * non-compliant with the ERC721 standard.
992      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
993      * {ConsecutiveTransfer} event is only permissible during contract creation.
994      *
995      * Requirements:
996      *
997      * - `to` cannot be the zero address.
998      * - `quantity` must be greater than 0.
999      *
1000      * Emits a {ConsecutiveTransfer} event.
1001      */
1002     function _mintERC2309(address to, uint256 quantity) internal {
1003         uint256 startTokenId = _currentIndex;
1004         if (to == address(0)) revert MintToZeroAddress();
1005         if (quantity == 0) revert MintZeroQuantity();
1006         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1007 
1008         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1009 
1010         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1011         unchecked {
1012             // Updates:
1013             // - `balance += quantity`.
1014             // - `numberMinted += quantity`.
1015             //
1016             // We can directly add to the `balance` and `numberMinted`.
1017             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1018 
1019             // Updates:
1020             // - `address` to the owner.
1021             // - `startTimestamp` to the timestamp of minting.
1022             // - `burned` to `false`.
1023             // - `nextInitialized` to `quantity == 1`.
1024             _packedOwnerships[startTokenId] = _packOwnershipData(
1025                 to,
1026                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1027             );
1028 
1029             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1030 
1031             _currentIndex = startTokenId + quantity;
1032         }
1033         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1034     }
1035 
1036     /**
1037      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1038      */
1039     function _getApprovedAddress(uint256 tokenId)
1040         private
1041         view
1042         returns (uint256 approvedAddressSlot, address approvedAddress)
1043     {
1044         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1045         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1046         assembly {
1047             // Compute the slot.
1048             mstore(0x00, tokenId)
1049             mstore(0x20, tokenApprovalsPtr.slot)
1050             approvedAddressSlot := keccak256(0x00, 0x40)
1051             // Load the slot's value from storage.
1052             approvedAddress := sload(approvedAddressSlot)
1053         }
1054     }
1055 
1056     /**
1057      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1058      */
1059     function _isOwnerOrApproved(
1060         address approvedAddress,
1061         address from,
1062         address msgSender
1063     ) private pure returns (bool result) {
1064         assembly {
1065             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1066             from := and(from, BITMASK_ADDRESS)
1067             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1068             msgSender := and(msgSender, BITMASK_ADDRESS)
1069             // `msgSender == from || msgSender == approvedAddress`.
1070             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1071         }
1072     }
1073 
1074     /**
1075      * @dev Transfers `tokenId` from `from` to `to`.
1076      *
1077      * Requirements:
1078      *
1079      * - `to` cannot be the zero address.
1080      * - `tokenId` token must be owned by `from`.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function transferFrom(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) public virtual override {
1089         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1090 
1091         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1092 
1093         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1094 
1095         // The nested ifs save around 20+ gas over a compound boolean condition.
1096         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1097             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1098 
1099         if (to == address(0)) revert TransferToZeroAddress();
1100 
1101         _beforeTokenTransfers(from, to, tokenId, 1);
1102 
1103         // Clear approvals from the previous owner.
1104         assembly {
1105             if approvedAddress {
1106                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1107                 sstore(approvedAddressSlot, 0)
1108             }
1109         }
1110 
1111         // Underflow of the sender's balance is impossible because we check for
1112         // ownership above and the recipient's balance can't realistically overflow.
1113         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1114         unchecked {
1115             // We can directly increment and decrement the balances.
1116             --_packedAddressData[from]; // Updates: `balance -= 1`.
1117             ++_packedAddressData[to]; // Updates: `balance += 1`.
1118 
1119             // Updates:
1120             // - `address` to the next owner.
1121             // - `startTimestamp` to the timestamp of transfering.
1122             // - `burned` to `false`.
1123             // - `nextInitialized` to `true`.
1124             _packedOwnerships[tokenId] = _packOwnershipData(
1125                 to,
1126                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1127             );
1128 
1129             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1130             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1131                 uint256 nextTokenId = tokenId + 1;
1132                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1133                 if (_packedOwnerships[nextTokenId] == 0) {
1134                     // If the next slot is within bounds.
1135                     if (nextTokenId != _currentIndex) {
1136                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1137                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1138                     }
1139                 }
1140             }
1141         }
1142 
1143         emit Transfer(from, to, tokenId);
1144         _afterTokenTransfers(from, to, tokenId, 1);
1145     }
1146 
1147     /**
1148      * @dev Equivalent to `_burn(tokenId, false)`.
1149      */
1150     function _burn(uint256 tokenId) internal virtual {
1151         _burn(tokenId, false);
1152     }
1153 
1154     /**
1155      * @dev Destroys `tokenId`.
1156      * The approval is cleared when the token is burned.
1157      *
1158      * Requirements:
1159      *
1160      * - `tokenId` must exist.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1165         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1166 
1167         address from = address(uint160(prevOwnershipPacked));
1168 
1169         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1170 
1171         if (approvalCheck) {
1172             // The nested ifs save around 20+ gas over a compound boolean condition.
1173             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1174                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1175         }
1176 
1177         _beforeTokenTransfers(from, address(0), tokenId, 1);
1178 
1179         // Clear approvals from the previous owner.
1180         assembly {
1181             if approvedAddress {
1182                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1183                 sstore(approvedAddressSlot, 0)
1184             }
1185         }
1186 
1187         // Underflow of the sender's balance is impossible because we check for
1188         // ownership above and the recipient's balance can't realistically overflow.
1189         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1190         unchecked {
1191             // Updates:
1192             // - `balance -= 1`.
1193             // - `numberBurned += 1`.
1194             //
1195             // We can directly decrement the balance, and increment the number burned.
1196             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1197             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1198 
1199             // Updates:
1200             // - `address` to the last owner.
1201             // - `startTimestamp` to the timestamp of burning.
1202             // - `burned` to `true`.
1203             // - `nextInitialized` to `true`.
1204             _packedOwnerships[tokenId] = _packOwnershipData(
1205                 from,
1206                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1207             );
1208 
1209             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1210             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1211                 uint256 nextTokenId = tokenId + 1;
1212                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1213                 if (_packedOwnerships[nextTokenId] == 0) {
1214                     // If the next slot is within bounds.
1215                     if (nextTokenId != _currentIndex) {
1216                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1217                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1218                     }
1219                 }
1220             }
1221         }
1222 
1223         emit Transfer(from, address(0), tokenId);
1224         _afterTokenTransfers(from, address(0), tokenId, 1);
1225 
1226         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1227         unchecked {
1228             _burnCounter++;
1229         }
1230     }
1231 
1232     /**
1233      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1234      *
1235      * @param from address representing the previous owner of the given token ID
1236      * @param to target address that will receive the tokens
1237      * @param tokenId uint256 ID of the token to be transferred
1238      * @param _data bytes optional data to send along with the call
1239      * @return bool whether the call correctly returned the expected magic value
1240      */
1241     function _checkContractOnERC721Received(
1242         address from,
1243         address to,
1244         uint256 tokenId,
1245         bytes memory _data
1246     ) private returns (bool) {
1247         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1248             bytes4 retval
1249         ) {
1250             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1251         } catch (bytes memory reason) {
1252             if (reason.length == 0) {
1253                 revert TransferToNonERC721ReceiverImplementer();
1254             } else {
1255                 assembly {
1256                     revert(add(32, reason), mload(reason))
1257                 }
1258             }
1259         }
1260     }
1261 
1262     /**
1263      * @dev Directly sets the extra data for the ownership data `index`.
1264      */
1265     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1266         uint256 packed = _packedOwnerships[index];
1267         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1268         uint256 extraDataCasted;
1269         // Cast `extraData` with assembly to avoid redundant masking.
1270         assembly {
1271             extraDataCasted := extraData
1272         }
1273         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1274         _packedOwnerships[index] = packed;
1275     }
1276 
1277     /**
1278      * @dev Returns the next extra data for the packed ownership data.
1279      * The returned result is shifted into position.
1280      */
1281     function _nextExtraData(
1282         address from,
1283         address to,
1284         uint256 prevOwnershipPacked
1285     ) private view returns (uint256) {
1286         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1287         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1288     }
1289 
1290     /**
1291      * @dev Called during each token transfer to set the 24bit `extraData` field.
1292      * Intended to be overridden by the cosumer contract.
1293      *
1294      * `previousExtraData` - the value of `extraData` before transfer.
1295      *
1296      * Calling conditions:
1297      *
1298      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1299      * transferred to `to`.
1300      * - When `from` is zero, `tokenId` will be minted for `to`.
1301      * - When `to` is zero, `tokenId` will be burned by `from`.
1302      * - `from` and `to` are never both zero.
1303      */
1304     function _extraData(
1305         address from,
1306         address to,
1307         uint24 previousExtraData
1308     ) internal view virtual returns (uint24) {}
1309 
1310     /**
1311      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1312      * This includes minting.
1313      * And also called before burning one token.
1314      *
1315      * startTokenId - the first token id to be transferred
1316      * quantity - the amount to be transferred
1317      *
1318      * Calling conditions:
1319      *
1320      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1321      * transferred to `to`.
1322      * - When `from` is zero, `tokenId` will be minted for `to`.
1323      * - When `to` is zero, `tokenId` will be burned by `from`.
1324      * - `from` and `to` are never both zero.
1325      */
1326     function _beforeTokenTransfers(
1327         address from,
1328         address to,
1329         uint256 startTokenId,
1330         uint256 quantity
1331     ) internal virtual {}
1332 
1333     /**
1334      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1335      * This includes minting.
1336      * And also called after one token has been burned.
1337      *
1338      * startTokenId - the first token id to be transferred
1339      * quantity - the amount to be transferred
1340      *
1341      * Calling conditions:
1342      *
1343      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1344      * transferred to `to`.
1345      * - When `from` is zero, `tokenId` has been minted for `to`.
1346      * - When `to` is zero, `tokenId` has been burned by `from`.
1347      * - `from` and `to` are never both zero.
1348      */
1349     function _afterTokenTransfers(
1350         address from,
1351         address to,
1352         uint256 startTokenId,
1353         uint256 quantity
1354     ) internal virtual {}
1355 
1356     /**
1357      * @dev Returns the message sender (defaults to `msg.sender`).
1358      *
1359      * If you are writing GSN compatible contracts, you need to override this function.
1360      */
1361     function _msgSenderERC721A() internal view virtual returns (address) {
1362         return msg.sender;
1363     }
1364 
1365     /**
1366      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1367      */
1368     function _toString(uint256 value) internal pure returns (string memory ptr) {
1369         assembly {
1370             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1371             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1372             // We will need 1 32-byte word to store the length,
1373             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1374             ptr := add(mload(0x40), 128)
1375             // Update the free memory pointer to allocate.
1376             mstore(0x40, ptr)
1377 
1378             // Cache the end of the memory to calculate the length later.
1379             let end := ptr
1380 
1381             // We write the string from the rightmost digit to the leftmost digit.
1382             // The following is essentially a do-while loop that also handles the zero case.
1383             // Costs a bit more than early returning for the zero case,
1384             // but cheaper in terms of deployment and overall runtime costs.
1385             for {
1386                 // Initialize and perform the first pass without check.
1387                 let temp := value
1388                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1389                 ptr := sub(ptr, 1)
1390                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1391                 mstore8(ptr, add(48, mod(temp, 10)))
1392                 temp := div(temp, 10)
1393             } temp {
1394                 // Keep dividing `temp` until zero.
1395                 temp := div(temp, 10)
1396             } {
1397                 // Body of the for loop.
1398                 ptr := sub(ptr, 1)
1399                 mstore8(ptr, add(48, mod(temp, 10)))
1400             }
1401 
1402             let length := sub(end, ptr)
1403             // Move the pointer 32 bytes leftwards to make room for the length.
1404             ptr := sub(ptr, 32)
1405             // Store the length.
1406             mstore(ptr, length)
1407         }
1408     }
1409 }
1410 
1411 // File: contracts/StrangeMeInNFT.sol
1412 
1413 
1414 
1415 pragma solidity ^0.8.0;
1416 
1417 /**
1418  * @dev String operations.
1419  */
1420 library Strings {
1421     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1422 
1423     /**
1424      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1425      */
1426     function toString(uint256 value) internal pure returns (string memory) {
1427         // Inspired by OraclizeAPI's implementation - MIT licence
1428         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1429 
1430         if (value == 0) {
1431             return "0";
1432         }
1433         uint256 temp = value;
1434         uint256 digits;
1435         while (temp != 0) {
1436             digits++;
1437             temp /= 10;
1438         }
1439         bytes memory buffer = new bytes(digits);
1440         while (value != 0) {
1441             digits -= 1;
1442             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1443             value /= 10;
1444         }
1445         return string(buffer);
1446     }
1447 
1448     /**
1449      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1450      */
1451     function toHexString(uint256 value) internal pure returns (string memory) {
1452         if (value == 0) {
1453             return "0x00";
1454         }
1455         uint256 temp = value;
1456         uint256 length = 0;
1457         while (temp != 0) {
1458             length++;
1459             temp >>= 8;
1460         }
1461         return toHexString(value, length);
1462     }
1463 
1464     /**
1465      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1466      */
1467     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1468         bytes memory buffer = new bytes(2 * length + 2);
1469         buffer[0] = "0";
1470         buffer[1] = "x";
1471         for (uint256 i = 2 * length + 1; i > 1; --i) {
1472             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1473             value >>= 4;
1474         }
1475         require(value == 0, "Strings: hex length insufficient");
1476         return string(buffer);
1477     }
1478 }
1479 
1480 
1481 
1482 
1483 pragma solidity ^0.8.0;
1484 
1485 
1486 
1487 contract StrangeMeInNFT is ERC721A, Ownable {
1488 	using Strings for uint;
1489 
1490 	uint public constant MINT_PRICE = 0.007 ether;
1491 	uint public constant MAX_NFT_PER_TRAN = 10;
1492     uint public constant MAX_PER_WALLET = 100;
1493 	uint public maxSupply = 10000;
1494 
1495 	bool public isPaused = true;
1496     bool public isMetadataFinal;
1497     string private _baseURL = "ipfs://QmbmmPsKaEjyzMuHbgRbPf1b6L3iVgyenbdcRLkGoxhzMQ/";
1498 	string public prerevealURL = '';
1499 	mapping(address => uint) private _walletMintedCount;
1500 
1501 	constructor()
1502     // Name
1503 	ERC721A('Strange Me In NFT', 'SMIF') {
1504     }
1505 
1506 	function _baseURI() internal view override returns (string memory) {
1507 		return _baseURL;
1508 	}
1509 
1510 	function _startTokenId() internal pure override returns (uint) {
1511 		return 1;
1512 	}
1513 
1514 	function contractURI() public pure returns (string memory) {
1515 		return "";
1516 	}
1517 
1518     function finalizeMetadata() external onlyOwner {
1519         isMetadataFinal = true;
1520     }
1521 
1522 	function reveal(string memory url) external onlyOwner {
1523         require(!isMetadataFinal, "Metadata is finalized");
1524 		_baseURL = url;
1525 	}
1526 
1527     function mintedCount(address owner) external view returns (uint) {
1528         return _walletMintedCount[owner];
1529     }
1530 
1531 	function setPause(bool value) external onlyOwner {
1532 		isPaused = value;
1533 	}
1534 
1535 	function withdraw() external onlyOwner {
1536 		(bool success, ) = payable(msg.sender).call{
1537             value: address(this).balance
1538         }("");
1539         require(success);
1540 	}
1541 
1542 	function devMint(address to, uint count) external onlyOwner {
1543 		require(
1544 			_totalMinted() + count <= maxSupply,
1545 			'Exceeds max supply'
1546 		);
1547 		_safeMint(to, count);
1548 	}
1549 
1550 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
1551 		maxSupply = newMaxSupply;
1552 	}
1553 
1554 	function tokenURI(uint tokenId)
1555 		public
1556 		view
1557 		override
1558 		returns (string memory)
1559 	{
1560         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1561 
1562         return bytes(_baseURI()).length > 0 
1563             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1564             : prerevealURL;
1565 	}
1566 
1567 	function mint(uint count) external payable {
1568 		require(!isPaused, 'Sales are off');
1569 		require(count <= MAX_NFT_PER_TRAN,'Exceeds NFT per transaction limit');
1570 		require(_totalMinted() + count <= maxSupply,'Exceeds max supply');
1571         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET,'Exceeds max per wallet');
1572 
1573         uint payForCount = count;
1574         uint mintedSoFar = _walletMintedCount[msg.sender];
1575         if(mintedSoFar < 2) {
1576             uint remainingFreeMints = 2 - mintedSoFar;
1577             if(count > remainingFreeMints) {
1578                 payForCount = count - remainingFreeMints;
1579             }
1580             else {
1581                 payForCount = 0;
1582             }
1583         }
1584 
1585 		require(
1586 			msg.value >= payForCount * MINT_PRICE,
1587 			'Ether value sent is not sufficient'
1588 		);
1589 
1590 		_walletMintedCount[msg.sender] += count;
1591 		_safeMint(msg.sender, count);
1592 	}
1593 
1594 }