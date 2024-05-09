1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
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
57         _setOwner(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _setOwner(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _setOwner(newOwner);
93     }
94 
95     function _setOwner(address newOwner) private {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
103 
104 
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Interface of the ERC165 standard, as defined in the
110  * https://eips.ethereum.org/EIPS/eip-165[EIP].
111  *
112  * Implementers can declare support of contract interfaces, which can then be
113  * queried by others ({ERC165Checker}).
114  *
115  * For an implementation, see {ERC165}.
116  */
117 interface IERC165 {
118     /**
119      * @dev Returns true if this contract implements the interface defined by
120      * `interfaceId`. See the corresponding
121      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
122      * to learn more about how these ids are created.
123      *
124      * This function call must use less than 30 000 gas.
125      */
126     function supportsInterface(bytes4 interfaceId) external view returns (bool);
127 }
128 
129 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
130 
131 
132 
133 pragma solidity ^0.8.0;
134 
135 
136 /**
137  * @dev Required interface of an ERC721 compliant contract.
138  */
139 interface IERC721 is IERC165 {
140     /**
141      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
144 
145     /**
146      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
147      */
148     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
149 
150     /**
151      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
152      */
153     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
154 
155     /**
156      * @dev Returns the number of tokens in ``owner``'s account.
157      */
158     function balanceOf(address owner) external view returns (uint256 balance);
159 
160     /**
161      * @dev Returns the owner of the `tokenId` token.
162      *
163      * Requirements:
164      *
165      * - `tokenId` must exist.
166      */
167     function ownerOf(uint256 tokenId) external view returns (address owner);
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
171      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) external;
188 
189     /**
190      * @dev Transfers `tokenId` token from `from` to `to`.
191      *
192      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must be owned by `from`.
199      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external;
208 
209     /**
210      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
211      * The approval is cleared when the token is transferred.
212      *
213      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
214      *
215      * Requirements:
216      *
217      * - The caller must own the token or be an approved operator.
218      * - `tokenId` must exist.
219      *
220      * Emits an {Approval} event.
221      */
222     function approve(address to, uint256 tokenId) external;
223 
224     /**
225      * @dev Returns the account approved for `tokenId` token.
226      *
227      * Requirements:
228      *
229      * - `tokenId` must exist.
230      */
231     function getApproved(uint256 tokenId) external view returns (address operator);
232 
233     /**
234      * @dev Approve or remove `operator` as an operator for the caller.
235      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
236      *
237      * Requirements:
238      *
239      * - The `operator` cannot be the caller.
240      *
241      * Emits an {ApprovalForAll} event.
242      */
243     function setApprovalForAll(address operator, bool _approved) external;
244 
245     /**
246      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
247      *
248      * See {setApprovalForAll}
249      */
250     function isApprovedForAll(address owner, address operator) external view returns (bool);
251 
252     /**
253      * @dev Safely transfers `tokenId` token from `from` to `to`.
254      *
255      * Requirements:
256      *
257      * - `from` cannot be the zero address.
258      * - `to` cannot be the zero address.
259      * - `tokenId` token must exist and be owned by `from`.
260      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
261      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
262      *
263      * Emits a {Transfer} event.
264      */
265     function safeTransferFrom(
266         address from,
267         address to,
268         uint256 tokenId,
269         bytes calldata data
270     ) external;
271 }
272 
273 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
274 
275 
276 
277 pragma solidity ^0.8.0;
278 
279 
280 /**
281  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
282  * @dev See https://eips.ethereum.org/EIPS/eip-721
283  */
284 interface IERC721Enumerable is IERC721 {
285     /**
286      * @dev Returns the total amount of tokens stored by the contract.
287      */
288     function totalSupply() external view returns (uint256);
289 
290     /**
291      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
292      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
293      */
294     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
295 
296     /**
297      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
298      * Use along with {totalSupply} to enumerate all tokens.
299      */
300     function tokenByIndex(uint256 index) external view returns (uint256);
301 }
302 
303 // File: contracts/Staking.sol
304 
305 
306 pragma solidity ^0.8.9;
307 
308 
309 contract DTSPool is Ownable {
310     event DepositNFT(address indexed from, address indexed tokenContract, uint256 indexed tokenID);
311     event WithdrawNFT(address indexed from, address indexed tokenContract, uint256 indexed tokenID);
312     
313     // DAO Turtles Staking Pool
314     address constant public DTS_VAULT = 0xA3ACd9eD1334b6c33E3b1D88394e1E2b771A5795;
315     
316     bool public canDepositNFT = true;
317     bool public canWithdrawNFT = true;
318     
319     // map each NFT contract to map of tokenID: stakerAddress 
320     mapping (address => mapping (uint256 => address)) public NFTStakers;
321     
322     function flipDepositNFT() external onlyOwner {
323         canDepositNFT = !canDepositNFT;
324     }
325     
326     function flipWithdrawNFT() external onlyOwner {
327         canWithdrawNFT = !canWithdrawNFT;
328     }
329     
330     function depositNFT(address tokenContract, uint256 tokenID) external {
331         require(canDepositNFT, "Closed for deposits");
332         IERC721Enumerable ITokenContract = IERC721Enumerable(tokenContract);
333         require(ITokenContract.ownerOf(tokenID) == msg.sender, "Token not owned");
334         ITokenContract.safeTransferFrom(msg.sender, DTS_VAULT, tokenID);
335         NFTStakers[tokenContract][tokenID] = msg.sender;
336         emit DepositNFT(msg.sender, tokenContract, tokenID);
337     }
338     
339     function depositMultipleNFTs(address tokenContract, uint256 amount, uint256[] calldata tokenIDList) external {
340         require(canDepositNFT, "Closed for deposits");
341         require(amount <= 10, "Too many NFTs");
342         IERC721Enumerable ITokenContract = IERC721Enumerable(tokenContract);
343         uint256 tokenID;
344         for (uint256 i=0; i<amount; i++) {
345             tokenID = tokenIDList[i];
346             require(ITokenContract.ownerOf(tokenID) == msg.sender, "Token not owned");
347             ITokenContract.safeTransferFrom(msg.sender, DTS_VAULT, tokenID);
348             NFTStakers[tokenContract][tokenID] = msg.sender;
349             emit DepositNFT(msg.sender, tokenContract, tokenID);
350         }
351     }
352 
353     function withdrawNFT(address tokenContract, uint256 tokenID) external {
354         require(canWithdrawNFT, "Closed for withdrawals");
355         // Token staker must be the caller
356         require(NFTStakers[tokenContract][tokenID] == msg.sender, "Token not owned");
357         IERC721Enumerable(tokenContract).safeTransferFrom(DTS_VAULT, msg.sender, tokenID);
358         delete NFTStakers[tokenContract][tokenID];
359         emit WithdrawNFT(msg.sender, tokenContract, tokenID);
360     }
361     
362     function withdrawMultipleNFT(address tokenContract, uint256 amount, uint256[] calldata tokenIDList) external {
363         require(canWithdrawNFT, "Closed for withdrawals");
364         require(amount <= 10, "Too many NFTs");
365         IERC721Enumerable ITokenContract = IERC721Enumerable(tokenContract);
366         uint256 tokenID;
367         for (uint256 i=0; i<amount; i++) {
368             tokenID = tokenIDList[i];
369             require(NFTStakers[tokenContract][tokenID] == msg.sender, "Token not owned");
370             ITokenContract.safeTransferFrom(DTS_VAULT, msg.sender, tokenID);
371             delete NFTStakers[tokenContract][tokenID];
372             emit WithdrawNFT(msg.sender, tokenContract, tokenID);
373         }
374     }
375 
376     function getNumberOfStakedTokens(address staker, address tokenContract) public view returns (uint256) {
377         uint256 count;
378         uint256 maxTokens = IERC721Enumerable(tokenContract).totalSupply();
379         for (uint256 i=0; i < maxTokens; i++) {
380             if (NFTStakers[tokenContract][i] == staker) {
381                 count++;
382             }
383         }
384         return count;
385         
386     }
387 
388     function getStakedTokens(address staker, address tokenContract) external view returns (uint256[] memory) {
389         uint256 count = getNumberOfStakedTokens(staker, tokenContract);
390         uint256 maxTokens = IERC721Enumerable(tokenContract).totalSupply();
391         uint256[] memory tokens = new uint256[](count);
392         uint256 n;
393         for (uint256 i=0; i < maxTokens; i++) {
394             if (NFTStakers[tokenContract][i] == staker) {
395                 tokens[n] = i;
396                 n++;
397             }
398         }
399         return tokens;
400     }
401 
402     function getUnstakedTokens(address staker, address tokenContract) external view returns (uint256[] memory) {
403         IERC721Enumerable ITokenContract = IERC721Enumerable(tokenContract);
404         uint256 count = ITokenContract.balanceOf(staker);
405         uint256 maxTokens = ITokenContract.totalSupply();
406         uint256[] memory tokens = new uint256[](count);
407         uint256 n;
408         for (uint256 i=0; i < maxTokens; i++) {
409             if (ITokenContract.ownerOf(i) == staker) {
410                 tokens[n] = i;
411                 n++;
412             }
413         }
414         return tokens;
415     }
416     
417     function isStakedByAddress(address staker, address tokenContract, uint256 tokenID) external view returns (bool){
418         if (NFTStakers[tokenContract][tokenID] == staker) {
419             return true;
420         } else {
421             return false;
422         }
423     }
424 }