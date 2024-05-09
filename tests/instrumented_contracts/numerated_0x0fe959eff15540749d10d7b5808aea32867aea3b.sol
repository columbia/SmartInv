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
113 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP.
122  */
123 interface IERC20 {
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     /**
133      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134      * a call to {approve}. `value` is the new allowance.
135      */
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `to`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transfer(address to, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     /**
167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * IMPORTANT: Beware that changing an allowance with this method brings the risk
172      * that someone may use both the old and the new allowance by unfortunate
173      * transaction ordering. One possible solution to mitigate this race
174      * condition is to first reduce the spender's allowance to 0 and set the
175      * desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Moves `amount` tokens from `from` to `to` using the
184      * allowance mechanism. `amount` is then deducted from the caller's
185      * allowance.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(
192         address from,
193         address to,
194         uint256 amount
195     ) external returns (bool);
196 }
197 
198 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Interface of the ERC165 standard, as defined in the
207  * https://eips.ethereum.org/EIPS/eip-165[EIP].
208  *
209  * Implementers can declare support of contract interfaces, which can then be
210  * queried by others ({ERC165Checker}).
211  *
212  * For an implementation, see {ERC165}.
213  */
214 interface IERC165 {
215     /**
216      * @dev Returns true if this contract implements the interface defined by
217      * `interfaceId`. See the corresponding
218      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
219      * to learn more about how these ids are created.
220      *
221      * This function call must use less than 30 000 gas.
222      */
223     function supportsInterface(bytes4 interfaceId) external view returns (bool);
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 
234 /**
235  * @dev Required interface of an ERC721 compliant contract.
236  */
237 interface IERC721 is IERC165 {
238     /**
239      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
240      */
241     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
242 
243     /**
244      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
245      */
246     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
247 
248     /**
249      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
250      */
251     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
252 
253     /**
254      * @dev Returns the number of tokens in ``owner``'s account.
255      */
256     function balanceOf(address owner) external view returns (uint256 balance);
257 
258     /**
259      * @dev Returns the owner of the `tokenId` token.
260      *
261      * Requirements:
262      *
263      * - `tokenId` must exist.
264      */
265     function ownerOf(uint256 tokenId) external view returns (address owner);
266 
267     /**
268      * @dev Safely transfers `tokenId` token from `from` to `to`.
269      *
270      * Requirements:
271      *
272      * - `from` cannot be the zero address.
273      * - `to` cannot be the zero address.
274      * - `tokenId` token must exist and be owned by `from`.
275      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
276      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
277      *
278      * Emits a {Transfer} event.
279      */
280     function safeTransferFrom(
281         address from,
282         address to,
283         uint256 tokenId,
284         bytes calldata data
285     ) external;
286 
287     /**
288      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
289      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
290      *
291      * Requirements:
292      *
293      * - `from` cannot be the zero address.
294      * - `to` cannot be the zero address.
295      * - `tokenId` token must exist and be owned by `from`.
296      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
297      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
298      *
299      * Emits a {Transfer} event.
300      */
301     function safeTransferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external;
306 
307     /**
308      * @dev Transfers `tokenId` token from `from` to `to`.
309      *
310      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
311      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
312      * understand this adds an external call which potentially creates a reentrancy vulnerability.
313      *
314      * Requirements:
315      *
316      * - `from` cannot be the zero address.
317      * - `to` cannot be the zero address.
318      * - `tokenId` token must be owned by `from`.
319      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
320      *
321      * Emits a {Transfer} event.
322      */
323     function transferFrom(
324         address from,
325         address to,
326         uint256 tokenId
327     ) external;
328 
329     /**
330      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
331      * The approval is cleared when the token is transferred.
332      *
333      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
334      *
335      * Requirements:
336      *
337      * - The caller must own the token or be an approved operator.
338      * - `tokenId` must exist.
339      *
340      * Emits an {Approval} event.
341      */
342     function approve(address to, uint256 tokenId) external;
343 
344     /**
345      * @dev Approve or remove `operator` as an operator for the caller.
346      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
347      *
348      * Requirements:
349      *
350      * - The `operator` cannot be the caller.
351      *
352      * Emits an {ApprovalForAll} event.
353      */
354     function setApprovalForAll(address operator, bool _approved) external;
355 
356     /**
357      * @dev Returns the account approved for `tokenId` token.
358      *
359      * Requirements:
360      *
361      * - `tokenId` must exist.
362      */
363     function getApproved(uint256 tokenId) external view returns (address operator);
364 
365     /**
366      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
367      *
368      * See {setApprovalForAll}
369      */
370     function isApprovedForAll(address owner, address operator) external view returns (bool);
371 }
372 
373 // File: contracts/ClaimNothing.sol
374 
375 
376 pragma solidity ^0.8.0;
377 
378 
379 
380 
381 interface ISomethingToken is IERC721 {
382     function getAmountPaid(uint256 tokenId) external view returns (uint256);
383 }
384 
385 
386 contract ClaimNothing is Ownable {
387 
388     //  IOU token that holds amount of new tokens user is owed
389     ISomethingToken public iouToken = ISomethingToken(0xB9d31e3473929185112ce28871069f16961cAB8F); 
390 
391     //  New token to be claimed by user in exchange for an IOU
392     IERC20 public thingToken = IERC20(0xFfD822149fA6749176C7a1424e71a417F26189C8);
393 
394     bool public claimActive = false;
395     uint256 public burnedCount = 0;
396     uint256 public initialClaimableSupply = 64 * 1e10 * 1e18;
397 
398     constructor() {}
399 
400     receive() external payable {}
401 
402 
403     function claimAndBurn(uint256[] calldata tokenIds) external {
404 		require(claimActive, "Claim is not active");
405 
406         uint256 userTotalTokensClaimable = 0;
407 
408         for (uint256 i; i < tokenIds.length;) {
409             uint256 tokenId = tokenIds[i];
410             
411             require(iouToken.ownerOf(tokenId) == msg.sender, "Caller is not the owner of the token");
412 
413             //  Get the amount of tokens this IOU is worth, 
414             uint256 amountPaid = iouToken.getAmountPaid(tokenId);
415 
416             //  Burn the IOU by transferring it to burn wallet
417             iouToken.transferFrom(msg.sender, address(this), tokenId);
418 
419             //  Lastly, add amount that this IOU is worth to the running total of tokens user receives
420             //  This can't underflow, `amountPaid` is always positive and bounded by other contract
421             unchecked { userTotalTokensClaimable += amountPaid * 10**9; }  
422             unchecked { ++i; }
423         }
424         unchecked { burnedCount += tokenIds.length; }
425 
426         //  Transfer thing tokens to user, reverts tx if it fails
427         thingToken.transfer(msg.sender, userTotalTokensClaimable);
428 
429         //  Transfer ether to user based on how many tokens being claimed
430         payable(msg.sender).transfer(getAmountEtherClaimable(userTotalTokensClaimable));
431     }
432 
433     //  Just in case someone sends ERC20 tokens to this contract on accident
434     function withdrawToken(address _tokenAddress, uint256 _amount) public onlyOwner {
435         IERC20 tokenContract = IERC20(_tokenAddress);
436         
437         // transfer the token from address of this contract
438         // to address of tx sender (only owner is capable of executing the withdrawToken() function)
439         tokenContract.transfer(msg.sender, _amount);
440     }
441     
442     //  IOUs should be able to be redeemed indefinitely, but just in case 
443     function setClaimActive() public onlyOwner {
444         claimActive = !claimActive;
445     }
446 
447     function getCurrentClaimableSupply() public view returns (uint256) {
448         return thingToken.balanceOf(address(this));
449     }
450 
451     //  Returns amount of ether user will receive based on amount of tokens provided 
452     function getAmountEtherClaimable(uint256 amountTokens) public view returns (uint256) {
453         uint256 totalEther = 35.5 ether;
454         uint256 etherToTransfer = (totalEther * amountTokens) / initialClaimableSupply;
455         return etherToTransfer;
456     }
457 }