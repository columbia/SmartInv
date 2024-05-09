1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
28 
29 
30 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 
105 // File openzeppelin-solidity/contracts/token/ERC20/IERC20.sol@v4.5.0
106 
107 
108 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
109 
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @dev Interface of the ERC20 standard as defined in the EIP.
114  */
115 interface IERC20 {
116     /**
117      * @dev Returns the amount of tokens in existence.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     /**
122      * @dev Returns the amount of tokens owned by `account`.
123      */
124     function balanceOf(address account) external view returns (uint256);
125 
126     /**
127      * @dev Moves `amount` tokens from the caller's account to `to`.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transfer(address to, uint256 amount) external returns (bool);
134 
135     /**
136      * @dev Returns the remaining number of tokens that `spender` will be
137      * allowed to spend on behalf of `owner` through {transferFrom}. This is
138      * zero by default.
139      *
140      * This value changes when {approve} or {transferFrom} are called.
141      */
142     function allowance(address owner, address spender) external view returns (uint256);
143 
144     /**
145      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * IMPORTANT: Beware that changing an allowance with this method brings the risk
150      * that someone may use both the old and the new allowance by unfortunate
151      * transaction ordering. One possible solution to mitigate this race
152      * condition is to first reduce the spender's allowance to 0 and set the
153      * desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      *
156      * Emits an {Approval} event.
157      */
158     function approve(address spender, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Moves `amount` tokens from `from` to `to` using the
162      * allowance mechanism. `amount` is then deducted from the caller's
163      * allowance.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a {Transfer} event.
168      */
169     function transferFrom(
170         address from,
171         address to,
172         uint256 amount
173     ) external returns (bool);
174 
175     /**
176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
177      * another (`to`).
178      *
179      * Note that `value` may be zero.
180      */
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     /**
184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
185      * a call to {approve}. `value` is the new allowance.
186      */
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 
191 // File openzeppelin-solidity/contracts/utils/introspection/IERC165.sol@v4.5.0
192 
193 
194 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev Interface of the ERC165 standard, as defined in the
200  * https://eips.ethereum.org/EIPS/eip-165[EIP].
201  *
202  * Implementers can declare support of contract interfaces, which can then be
203  * queried by others ({ERC165Checker}).
204  *
205  * For an implementation, see {ERC165}.
206  */
207 interface IERC165 {
208     /**
209      * @dev Returns true if this contract implements the interface defined by
210      * `interfaceId`. See the corresponding
211      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
212      * to learn more about how these ids are created.
213      *
214      * This function call must use less than 30 000 gas.
215      */
216     function supportsInterface(bytes4 interfaceId) external view returns (bool);
217 }
218 
219 
220 // File openzeppelin-solidity/contracts/token/ERC721/IERC721.sol@v4.5.0
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev Required interface of an ERC721 compliant contract.
229  */
230 interface IERC721 is IERC165 {
231     /**
232      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
235 
236     /**
237      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
238      */
239     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
240 
241     /**
242      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
243      */
244     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
245 
246     /**
247      * @dev Returns the number of tokens in ``owner``'s account.
248      */
249     function balanceOf(address owner) external view returns (uint256 balance);
250 
251     /**
252      * @dev Returns the owner of the `tokenId` token.
253      *
254      * Requirements:
255      *
256      * - `tokenId` must exist.
257      */
258     function ownerOf(uint256 tokenId) external view returns (address owner);
259 
260     /**
261      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
262      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `tokenId` token must exist and be owned by `from`.
269      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
270      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
271      *
272      * Emits a {Transfer} event.
273      */
274     function safeTransferFrom(
275         address from,
276         address to,
277         uint256 tokenId
278     ) external;
279 
280     /**
281      * @dev Transfers `tokenId` token from `from` to `to`.
282      *
283      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
284      *
285      * Requirements:
286      *
287      * - `from` cannot be the zero address.
288      * - `to` cannot be the zero address.
289      * - `tokenId` token must be owned by `from`.
290      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transferFrom(
295         address from,
296         address to,
297         uint256 tokenId
298     ) external;
299 
300     /**
301      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
302      * The approval is cleared when the token is transferred.
303      *
304      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
305      *
306      * Requirements:
307      *
308      * - The caller must own the token or be an approved operator.
309      * - `tokenId` must exist.
310      *
311      * Emits an {Approval} event.
312      */
313     function approve(address to, uint256 tokenId) external;
314 
315     /**
316      * @dev Returns the account approved for `tokenId` token.
317      *
318      * Requirements:
319      *
320      * - `tokenId` must exist.
321      */
322     function getApproved(uint256 tokenId) external view returns (address operator);
323 
324     /**
325      * @dev Approve or remove `operator` as an operator for the caller.
326      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
327      *
328      * Requirements:
329      *
330      * - The `operator` cannot be the caller.
331      *
332      * Emits an {ApprovalForAll} event.
333      */
334     function setApprovalForAll(address operator, bool _approved) external;
335 
336     /**
337      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
338      *
339      * See {setApprovalForAll}
340      */
341     function isApprovedForAll(address owner, address operator) external view returns (bool);
342 
343     /**
344      * @dev Safely transfers `tokenId` token from `from` to `to`.
345      *
346      * Requirements:
347      *
348      * - `from` cannot be the zero address.
349      * - `to` cannot be the zero address.
350      * - `tokenId` token must exist and be owned by `from`.
351      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
352      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
353      *
354      * Emits a {Transfer} event.
355      */
356     function safeTransferFrom(
357         address from,
358         address to,
359         uint256 tokenId,
360         bytes calldata data
361     ) external;
362 }
363 
364 
365 // File contracts/Sale.sol
366 
367 
368 pragma solidity ^0.8.4;
369 
370 
371 
372 interface NFTI {
373     function safeMint(address to, uint256 quantity) external;
374 }
375 
376 contract NFTSale is Ownable {
377     uint256 public sold = 0;
378     uint256 public freeNFTs = 6969;
379     uint256 public limit = 6969;
380     uint256 public price = 0 ether;
381     uint256 public limitPerMint = 3;
382     uint256 public limitPerUser = 3;
383     bool public saleActive = true;
384     mapping(address => uint256) mintByUser;
385 
386     NFTI public NFT;
387 
388     constructor(address _NFT) {
389         NFT = NFTI(_NFT);
390     }
391 
392     function isFreeTokenAvailable() public view returns (bool) {
393         return sold < freeNFTs;
394     }
395 
396     function freeTokensAvailable() public view returns (uint256) {
397         if (sold >= freeNFTs) return 0;
398         return freeNFTs - sold;
399     }
400 
401     function buyTokens(uint256 amount) public payable {
402         require(saleActive, "Sale not active");
403         require(amount <= limitPerMint, "Too much tokens to be minted");
404         require(sold <= limit, "Sale limit reached");
405         if (amount + sold >= limit) amount = limit - sold;
406 
407         require(amount + mintByUser[msg.sender] <= limitPerUser, "Mint limit passed");
408 
409         if (freeNFTs >= amount + sold) {
410             NFT.safeMint(msg.sender, amount);
411             sold += amount;
412         } else {
413             uint256 paidTokens;
414             if (freeNFTs >= sold) {
415                 paidTokens = sold + amount - freeNFTs;
416             } else {
417                 paidTokens = amount;
418             }
419 
420             require(msg.value == paidTokens * price, "Not enough ether paid");
421             NFT.safeMint(msg.sender, amount);
422             sold += amount;
423         }
424         mintByUser[msg.sender] += amount;
425     }
426 
427     //control functions
428     function setNFT(address _NFT) external onlyOwner {
429         NFT = NFTI(_NFT);
430     }
431 
432     function setFreeNFTs(uint256 _freeNFTs) external onlyOwner {
433         freeNFTs = _freeNFTs;
434     }
435 
436     function setLimit(uint256 _limit) external onlyOwner {
437         limit = _limit;
438     }
439 
440     function setPrice(uint256 _price) external onlyOwner {
441         price = _price;
442     }
443 
444     function setLimitPerMint(uint256 _limitPerMint) external onlyOwner {
445         limitPerMint = _limitPerMint;
446     }
447 
448     function setLimitByUser(uint256 _limit) external onlyOwner {
449         limitPerUser = _limit;
450     }
451 
452     function setSaleActive(bool _saleActive) external onlyOwner {
453         saleActive = _saleActive;
454     }
455 
456     // Emergency functions
457     function extractValue() external onlyOwner {
458         payable(msg.sender).transfer(address(this).balance);
459     }
460 
461     function extractToken(uint256 amount, address token) external onlyOwner {
462         IERC20(token).transfer(msg.sender, amount);
463     }
464 
465     function extractNFT(uint256 NFTID, address token) external onlyOwner {
466         IERC721(token).transferFrom(address(this), msg.sender, NFTID);
467     }
468 }