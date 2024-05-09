1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
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
55         _setOwner(_msgSender());
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
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @title ERC721 token receiver interface
108  * @dev Interface for any contract that wants to support safeTransfers
109  * from ERC721 asset contracts.
110  */
111 interface IERC721Receiver {
112     /**
113      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
114      * by `operator` from `from`, this function is called.
115      *
116      * It must return its Solidity selector to confirm the token transfer.
117      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
118      *
119      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
120      */
121     function onERC721Received(
122         address operator,
123         address from,
124         uint256 tokenId,
125         bytes calldata data
126     ) external returns (bytes4);
127 }
128 
129 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
130 
131 
132 
133 pragma solidity ^0.8.0;
134 
135 /**
136  * @dev Interface of the ERC165 standard, as defined in the
137  * https://eips.ethereum.org/EIPS/eip-165[EIP].
138  *
139  * Implementers can declare support of contract interfaces, which can then be
140  * queried by others ({ERC165Checker}).
141  *
142  * For an implementation, see {ERC165}.
143  */
144 interface IERC165 {
145     /**
146      * @dev Returns true if this contract implements the interface defined by
147      * `interfaceId`. See the corresponding
148      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
149      * to learn more about how these ids are created.
150      *
151      * This function call must use less than 30 000 gas.
152      */
153     function supportsInterface(bytes4 interfaceId) external view returns (bool);
154 }
155 
156 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
157 
158 
159 
160 pragma solidity ^0.8.0;
161 
162 
163 /**
164  * @dev Required interface of an ERC721 compliant contract.
165  */
166 interface IERC721 is IERC165 {
167     /**
168      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
169      */
170     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
171 
172     /**
173      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
174      */
175     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
176 
177     /**
178      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
179      */
180     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
181 
182     /**
183      * @dev Returns the number of tokens in ``owner``'s account.
184      */
185     function balanceOf(address owner) external view returns (uint256 balance);
186 
187     /**
188      * @dev Returns the owner of the `tokenId` token.
189      *
190      * Requirements:
191      *
192      * - `tokenId` must exist.
193      */
194     function ownerOf(uint256 tokenId) external view returns (address owner);
195 
196     /**
197      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
198      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must exist and be owned by `from`.
205      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
206      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
207      *
208      * Emits a {Transfer} event.
209      */
210     function safeTransferFrom(
211         address from,
212         address to,
213         uint256 tokenId
214     ) external;
215 
216     /**
217      * @dev Transfers `tokenId` token from `from` to `to`.
218      *
219      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
220      *
221      * Requirements:
222      *
223      * - `from` cannot be the zero address.
224      * - `to` cannot be the zero address.
225      * - `tokenId` token must be owned by `from`.
226      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
227      *
228      * Emits a {Transfer} event.
229      */
230     function transferFrom(
231         address from,
232         address to,
233         uint256 tokenId
234     ) external;
235 
236     /**
237      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
238      * The approval is cleared when the token is transferred.
239      *
240      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
241      *
242      * Requirements:
243      *
244      * - The caller must own the token or be an approved operator.
245      * - `tokenId` must exist.
246      *
247      * Emits an {Approval} event.
248      */
249     function approve(address to, uint256 tokenId) external;
250 
251     /**
252      * @dev Returns the account approved for `tokenId` token.
253      *
254      * Requirements:
255      *
256      * - `tokenId` must exist.
257      */
258     function getApproved(uint256 tokenId) external view returns (address operator);
259 
260     /**
261      * @dev Approve or remove `operator` as an operator for the caller.
262      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
263      *
264      * Requirements:
265      *
266      * - The `operator` cannot be the caller.
267      *
268      * Emits an {ApprovalForAll} event.
269      */
270     function setApprovalForAll(address operator, bool _approved) external;
271 
272     /**
273      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
274      *
275      * See {setApprovalForAll}
276      */
277     function isApprovedForAll(address owner, address operator) external view returns (bool);
278 
279     /**
280      * @dev Safely transfers `tokenId` token from `from` to `to`.
281      *
282      * Requirements:
283      *
284      * - `from` cannot be the zero address.
285      * - `to` cannot be the zero address.
286      * - `tokenId` token must exist and be owned by `from`.
287      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
288      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
289      *
290      * Emits a {Transfer} event.
291      */
292     function safeTransferFrom(
293         address from,
294         address to,
295         uint256 tokenId,
296         bytes calldata data
297     ) external;
298 }
299 
300 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
301 
302 
303 
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @dev Interface of the ERC20 standard as defined in the EIP.
308  */
309 interface IERC20 {
310     /**
311      * @dev Returns the amount of tokens in existence.
312      */
313     function totalSupply() external view returns (uint256);
314 
315     /**
316      * @dev Returns the amount of tokens owned by `account`.
317      */
318     function balanceOf(address account) external view returns (uint256);
319 
320     /**
321      * @dev Moves `amount` tokens from the caller's account to `recipient`.
322      *
323      * Returns a boolean value indicating whether the operation succeeded.
324      *
325      * Emits a {Transfer} event.
326      */
327     function transfer(address recipient, uint256 amount) external returns (bool);
328 
329     /**
330      * @dev Returns the remaining number of tokens that `spender` will be
331      * allowed to spend on behalf of `owner` through {transferFrom}. This is
332      * zero by default.
333      *
334      * This value changes when {approve} or {transferFrom} are called.
335      */
336     function allowance(address owner, address spender) external view returns (uint256);
337 
338     /**
339      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
340      *
341      * Returns a boolean value indicating whether the operation succeeded.
342      *
343      * IMPORTANT: Beware that changing an allowance with this method brings the risk
344      * that someone may use both the old and the new allowance by unfortunate
345      * transaction ordering. One possible solution to mitigate this race
346      * condition is to first reduce the spender's allowance to 0 and set the
347      * desired value afterwards:
348      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349      *
350      * Emits an {Approval} event.
351      */
352     function approve(address spender, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Moves `amount` tokens from `sender` to `recipient` using the
356      * allowance mechanism. `amount` is then deducted from the caller's
357      * allowance.
358      *
359      * Returns a boolean value indicating whether the operation succeeded.
360      *
361      * Emits a {Transfer} event.
362      */
363     function transferFrom(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) external returns (bool);
368 
369     /**
370      * @dev Emitted when `value` tokens are moved from one account (`from`) to
371      * another (`to`).
372      *
373      * Note that `value` may be zero.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 value);
376 
377     /**
378      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
379      * a call to {approve}. `value` is the new allowance.
380      */
381     event Approval(address indexed owner, address indexed spender, uint256 value);
382 }
383 
384 // File: contracts/inbetweeners/EuropaRedemption.sol
385 
386 
387 pragma solidity ^0.8.0;
388 
389 
390 
391 
392 
393 interface IMysteryBox is IERC721 {
394     function userBurn(uint256 tokenId) external;
395 }
396 
397 contract EuropaERC721Redemption is Ownable, IERC721Receiver {
398 
399     IERC721 public ticketNft;
400     IMysteryBox public mysteryBoxNft;
401 
402     address payable public ethReceiver;
403     uint public redemptionFee;
404 
405     mapping(uint => bool) public usedTickets;
406 
407     event TokenRedeemed(address indexed account, uint indexed mysteryBoxId, uint indexed ticketId, uint amount, bytes metadata);
408     event ErrorMoneySend();
409 
410     constructor(IERC721 _ticketNft, IMysteryBox _mysteryBoxNft, address payable _ethReceiver, uint _redemptionFee) {
411         ticketNft = _ticketNft;
412         mysteryBoxNft = _mysteryBoxNft;
413         ethReceiver = _ethReceiver;
414         redemptionFee = _redemptionFee;
415     }
416 
417     function redeem(uint ticketTokenId, uint mysteryBoxTokenId, bytes memory metadata) external payable {
418         require(msg.value == redemptionFee, "invalid redemption fee");
419         require(ticketNft.ownerOf(ticketTokenId) == msg.sender, "ticketNft doesn't belongs to sender");
420         require(!usedTickets[ticketTokenId], "ticket already used");
421 
422         usedTickets[ticketTokenId] = true;
423 
424         (bool success, ) = ethReceiver.call{value: address(this).balance}("");
425         if(!success) {
426             emit ErrorMoneySend();
427         }
428 
429         mysteryBoxNft.safeTransferFrom(msg.sender, address(this), mysteryBoxTokenId);
430         mysteryBoxNft.userBurn(mysteryBoxTokenId);
431 
432         emit TokenRedeemed(msg.sender, mysteryBoxTokenId, ticketTokenId, 1, metadata);
433     }
434 
435     function checkTickets(uint[] memory ticketIds) public view returns(bool[] memory res) {
436         res = new bool[](ticketIds.length);
437 
438         for(uint i = 0; i < ticketIds.length; i++) {
439             res[i] = usedTickets[ticketIds[i]];
440         }
441 
442         return res;
443     }
444 
445     function onERC721Received(
446         address /*operator*/,
447         address /*from*/,
448         uint256 /*tokenId*/,
449         bytes calldata /*data*/
450     ) external pure returns (bytes4) {
451         return IERC721Receiver.onERC721Received.selector;
452     }
453 
454     function withdrawMoney(address payable to, address tokenAddress) external onlyOwner {
455         if(tokenAddress == address(0)) {
456             (bool success, ) = to.call{value: address(this).balance}("");
457             require(success, "Withdraw failed.");
458             return;
459         }
460 
461         IERC20(tokenAddress).transfer(to, IERC20(tokenAddress).balanceOf(address(this)));
462     } 
463 }