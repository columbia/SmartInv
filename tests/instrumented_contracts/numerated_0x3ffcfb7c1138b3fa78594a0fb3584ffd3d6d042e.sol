1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8;
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
101 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
102 
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
106 
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
110 
111 
112 
113 /**
114  * @dev Interface of the ERC165 standard, as defined in the
115  * https://eips.ethereum.org/EIPS/eip-165[EIP].
116  *
117  * Implementers can declare support of contract interfaces, which can then be
118  * queried by others ({ERC165Checker}).
119  *
120  * For an implementation, see {ERC165}.
121  */
122 interface IERC165 {
123     /**
124      * @dev Returns true if this contract implements the interface defined by
125      * `interfaceId`. See the corresponding
126      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
127      * to learn more about how these ids are created.
128      *
129      * This function call must use less than 30 000 gas.
130      */
131     function supportsInterface(bytes4 interfaceId) external view returns (bool);
132 }
133 
134 /**
135  * @dev Required interface of an ERC721 compliant contract.
136  */
137 interface IERC721 is IERC165 {
138     /**
139      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
140      */
141     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
145      */
146     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
147 
148     /**
149      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
150      */
151     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
152 
153     /**
154      * @dev Returns the number of tokens in ``owner``'s account.
155      */
156     function balanceOf(address owner) external view returns (uint256 balance);
157 
158     /**
159      * @dev Returns the owner of the `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function ownerOf(uint256 tokenId) external view returns (address owner);
166 
167     /**
168      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
169      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
186 
187     /**
188      * @dev Transfers `tokenId` token from `from` to `to`.
189      *
190      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must be owned by `from`.
197      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transferFrom(
202         address from,
203         address to,
204         uint256 tokenId
205     ) external;
206 
207     /**
208      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
209      * The approval is cleared when the token is transferred.
210      *
211      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
212      *
213      * Requirements:
214      *
215      * - The caller must own the token or be an approved operator.
216      * - `tokenId` must exist.
217      *
218      * Emits an {Approval} event.
219      */
220     function approve(address to, uint256 tokenId) external;
221 
222     /**
223      * @dev Returns the account approved for `tokenId` token.
224      *
225      * Requirements:
226      *
227      * - `tokenId` must exist.
228      */
229     function getApproved(uint256 tokenId) external view returns (address operator);
230 
231     /**
232      * @dev Approve or remove `operator` as an operator for the caller.
233      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
234      *
235      * Requirements:
236      *
237      * - The `operator` cannot be the caller.
238      *
239      * Emits an {ApprovalForAll} event.
240      */
241     function setApprovalForAll(address operator, bool _approved) external;
242 
243     /**
244      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
245      *
246      * See {setApprovalForAll}
247      */
248     function isApprovedForAll(address owner, address operator) external view returns (bool);
249 
250     /**
251      * @dev Safely transfers `tokenId` token from `from` to `to`.
252      *
253      * Requirements:
254      *
255      * - `from` cannot be the zero address.
256      * - `to` cannot be the zero address.
257      * - `tokenId` token must exist and be owned by `from`.
258      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
259      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
260      *
261      * Emits a {Transfer} event.
262      */
263     function safeTransferFrom(
264         address from,
265         address to,
266         uint256 tokenId,
267         bytes calldata data
268     ) external;
269 }
270 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
271 
272 
273 
274 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
275 
276 
277 
278 /**
279  * @dev Interface of the ERC20 standard as defined in the EIP.
280  */
281 interface IERC20 {
282     /**
283      * @dev Returns the amount of tokens in existence.
284      */
285     function totalSupply() external view returns (uint256);
286 
287     /**
288      * @dev Returns the amount of tokens owned by `account`.
289      */
290     function balanceOf(address account) external view returns (uint256);
291 
292     /**
293      * @dev Moves `amount` tokens from the caller's account to `to`.
294      *
295      * Returns a boolean value indicating whether the operation succeeded.
296      *
297      * Emits a {Transfer} event.
298      */
299     function transfer(address to, uint256 amount) external returns (bool);
300 
301     /**
302      * @dev Returns the remaining number of tokens that `spender` will be
303      * allowed to spend on behalf of `owner` through {transferFrom}. This is
304      * zero by default.
305      *
306      * This value changes when {approve} or {transferFrom} are called.
307      */
308     function allowance(address owner, address spender) external view returns (uint256);
309 
310     /**
311      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
312      *
313      * Returns a boolean value indicating whether the operation succeeded.
314      *
315      * IMPORTANT: Beware that changing an allowance with this method brings the risk
316      * that someone may use both the old and the new allowance by unfortunate
317      * transaction ordering. One possible solution to mitigate this race
318      * condition is to first reduce the spender's allowance to 0 and set the
319      * desired value afterwards:
320      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
321      *
322      * Emits an {Approval} event.
323      */
324     function approve(address spender, uint256 amount) external returns (bool);
325 
326     /**
327      * @dev Moves `amount` tokens from `from` to `to` using the
328      * allowance mechanism. `amount` is then deducted from the caller's
329      * allowance.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transferFrom(
336         address from,
337         address to,
338         uint256 amount
339     ) external returns (bool);
340 
341     /**
342      * @dev Emitted when `value` tokens are moved from one account (`from`) to
343      * another (`to`).
344      *
345      * Note that `value` may be zero.
346      */
347     event Transfer(address indexed from, address indexed to, uint256 value);
348 
349     /**
350      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
351      * a call to {approve}. `value` is the new allowance.
352      */
353     event Approval(address indexed owner, address indexed spender, uint256 value);
354 }
355 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
356 
357 
358 
359 /**
360  * @title ERC721 token receiver interface
361  * @dev Interface for any contract that wants to support safeTransfers
362  * from ERC721 asset contracts.
363  */
364 interface IERC721Receiver {
365     /**
366      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
367      * by `operator` from `from`, this function is called.
368      *
369      * It must return its Solidity selector to confirm the token transfer.
370      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
371      *
372      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
373      */
374     function onERC721Received(
375         address operator,
376         address from,
377         uint256 tokenId,
378         bytes calldata data
379     ) external returns (bytes4);
380 }
381 
382 contract BanditStaking is Ownable, IERC721Receiver {
383     IERC721 public banditNft;
384     IERC20 public xBandit;
385 
386     uint256 public rewardRate = 1;
387 
388     mapping(uint256 => uint256) private tokenIdToLastWithdrawTime;
389     mapping(uint256 => uint256) private tokenIdToInitialStakeTime;
390     mapping(uint256 => address) private tokenIdToOwner;
391     mapping(uint256 => uint256) private tokenIdToEarnedBalance;
392     mapping(uint256 => bool) private legendaries;
393 
394     constructor(address banditNftAddress, address xBanditAddress) {
395         banditNft = IERC721(banditNftAddress);
396         xBandit = IERC20(xBanditAddress);
397     }
398 
399     function stakedBy(uint256 tokenId) public view returns (address) {
400         return tokenIdToOwner[tokenId];
401     }
402 
403     function setBanditNftAddress(address newAddy) public onlyOwner {
404         banditNft = IERC721(newAddy);
405     }
406 
407     function setXBanditAddress(address newAddy) public onlyOwner {
408         xBandit = IERC20(newAddy);
409     }
410 
411     function onERC721Received(
412         address operator,
413         address from,
414         uint256 tokenId,
415         bytes calldata data
416     ) external override returns (bytes4) {
417         require(banditNft.ownerOf(tokenId) == address(this), "fuck off");
418         require(tokenIdToOwner[tokenId] == address(0), "fuck off");
419         tokenIdToLastWithdrawTime[tokenId] = block.timestamp;
420         tokenIdToInitialStakeTime[tokenId] = block.timestamp;
421         tokenIdToOwner[tokenId] = from;
422         tokenIdToEarnedBalance[tokenId] = 0;
423 
424         return BanditStaking.onERC721Received.selector;
425     }
426 
427     function earned(uint256 tokenId) public view returns (uint256) {
428         uint256 totalTimeStaked = block.timestamp -
429             tokenIdToInitialStakeTime[tokenId];
430 
431         uint256 rewardNumerator = 100;
432 
433         if (totalTimeStaked > 2592000 * 3) {
434             rewardNumerator = 130;
435         } else if (totalTimeStaked > 2592000 * 2) {
436             rewardNumerator = 120;
437         } else if (totalTimeStaked > 2592000) {
438             rewardNumerator = 110;
439         }
440 
441         if (isLegendary(tokenId)) {
442             rewardNumerator = rewardNumerator + (rewardNumerator / 4);
443         }
444 
445         return
446             ((block.timestamp - tokenIdToLastWithdrawTime[tokenId]) *
447                 rewardRate *
448                 rewardNumerator * 1e18) / (86 * 100);
449     }
450 
451     function claimRewardForToken(uint256 tokenId) public {
452         require(
453             banditNft.ownerOf(tokenId) == address(this),
454             "This token is not yet staked"
455         );
456         require(
457             tokenIdToOwner[tokenId] == msg.sender,
458             "You cannot claim rewards for a token you do not own"
459         );
460 
461         tokenIdToEarnedBalance[tokenId] = earned(tokenId);
462         tokenIdToLastWithdrawTime[tokenId] = block.timestamp;
463 
464         uint256 finalEarnedAmount = tokenIdToEarnedBalance[tokenId];
465         tokenIdToEarnedBalance[tokenId] = 0;
466 
467         xBandit.transfer(msg.sender, finalEarnedAmount);
468     }
469 
470     function withdraw(uint256 tokenId) external {
471         claimRewardForToken(tokenId);
472 
473         tokenIdToOwner[tokenId] = address(0);
474         banditNft.transferFrom(address(this), msg.sender, tokenId);
475     }
476 
477     function setLegendaryToken(uint256 tokenId) public {
478         legendaries[tokenId] = true;
479     }
480 
481     function isLegendary(uint256 tokenId) public view returns (bool) {
482         return legendaries[tokenId];
483     }
484 
485     function stakedTokensBy(address maybeOwner) public view returns (int256[] memory) {
486         int256[] memory fin = new int256[](3333);
487 
488         uint lastSet = 0;
489 
490         for (uint i = 0; i < 3333; i++) {
491             fin[i] = -1;
492             if (tokenIdToOwner[i] == maybeOwner) {
493                 fin[lastSet] = int(i);
494                 lastSet++;
495             }
496         }
497 
498         return fin;
499     }
500 
501     function timeStaked(uint256 tokenId) public view returns (uint256) {
502         require(tokenIdToOwner[tokenId] != address(0), "This token is not staked yet");
503 
504         return block.timestamp - tokenIdToInitialStakeTime[tokenId];
505     }
506 }
