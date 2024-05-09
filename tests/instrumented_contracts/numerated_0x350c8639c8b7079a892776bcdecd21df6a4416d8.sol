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
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @title ERC721 token receiver interface
115  * @dev Interface for any contract that wants to support safeTransfers
116  * from ERC721 asset contracts.
117  */
118 interface IERC721Receiver {
119     /**
120      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
121      * by `operator` from `from`, this function is called.
122      *
123      * It must return its Solidity selector to confirm the token transfer.
124      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
125      *
126      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
127      */
128     function onERC721Received(
129         address operator,
130         address from,
131         uint256 tokenId,
132         bytes calldata data
133     ) external returns (bytes4);
134 }
135 
136 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
137 
138 
139 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
140 
141 pragma solidity ^0.8.0;
142 
143 /**
144  * @dev Interface of the ERC165 standard, as defined in the
145  * https://eips.ethereum.org/EIPS/eip-165[EIP].
146  *
147  * Implementers can declare support of contract interfaces, which can then be
148  * queried by others ({ERC165Checker}).
149  *
150  * For an implementation, see {ERC165}.
151  */
152 interface IERC165 {
153     /**
154      * @dev Returns true if this contract implements the interface defined by
155      * `interfaceId`. See the corresponding
156      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
157      * to learn more about how these ids are created.
158      *
159      * This function call must use less than 30 000 gas.
160      */
161     function supportsInterface(bytes4 interfaceId) external view returns (bool);
162 }
163 
164 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
165 
166 
167 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Required interface of an ERC721 compliant contract.
174  */
175 interface IERC721 is IERC165 {
176     /**
177      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
180 
181     /**
182      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
183      */
184     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
185 
186     /**
187      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
188      */
189     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
190 
191     /**
192      * @dev Returns the number of tokens in ``owner``'s account.
193      */
194     function balanceOf(address owner) external view returns (uint256 balance);
195 
196     /**
197      * @dev Returns the owner of the `tokenId` token.
198      *
199      * Requirements:
200      *
201      * - `tokenId` must exist.
202      */
203     function ownerOf(uint256 tokenId) external view returns (address owner);
204 
205     /**
206      * @dev Safely transfers `tokenId` token from `from` to `to`.
207      *
208      * Requirements:
209      *
210      * - `from` cannot be the zero address.
211      * - `to` cannot be the zero address.
212      * - `tokenId` token must exist and be owned by `from`.
213      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
214      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
215      *
216      * Emits a {Transfer} event.
217      */
218     function safeTransferFrom(
219         address from,
220         address to,
221         uint256 tokenId,
222         bytes calldata data
223     ) external;
224 
225     /**
226      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
227      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
228      *
229      * Requirements:
230      *
231      * - `from` cannot be the zero address.
232      * - `to` cannot be the zero address.
233      * - `tokenId` token must exist and be owned by `from`.
234      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
235      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
236      *
237      * Emits a {Transfer} event.
238      */
239     function safeTransferFrom(
240         address from,
241         address to,
242         uint256 tokenId
243     ) external;
244 
245     /**
246      * @dev Transfers `tokenId` token from `from` to `to`.
247      *
248      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
249      *
250      * Requirements:
251      *
252      * - `from` cannot be the zero address.
253      * - `to` cannot be the zero address.
254      * - `tokenId` token must be owned by `from`.
255      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transferFrom(
260         address from,
261         address to,
262         uint256 tokenId
263     ) external;
264 
265     /**
266      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
267      * The approval is cleared when the token is transferred.
268      *
269      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
270      *
271      * Requirements:
272      *
273      * - The caller must own the token or be an approved operator.
274      * - `tokenId` must exist.
275      *
276      * Emits an {Approval} event.
277      */
278     function approve(address to, uint256 tokenId) external;
279 
280     /**
281      * @dev Approve or remove `operator` as an operator for the caller.
282      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
283      *
284      * Requirements:
285      *
286      * - The `operator` cannot be the caller.
287      *
288      * Emits an {ApprovalForAll} event.
289      */
290     function setApprovalForAll(address operator, bool _approved) external;
291 
292     /**
293      * @dev Returns the account approved for `tokenId` token.
294      *
295      * Requirements:
296      *
297      * - `tokenId` must exist.
298      */
299     function getApproved(uint256 tokenId) external view returns (address operator);
300 
301     /**
302      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
303      *
304      * See {setApprovalForAll}
305      */
306     function isApprovedForAll(address owner, address operator) external view returns (bool);
307 }
308 
309 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
310 
311 
312 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 
317 /**
318  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
319  * @dev See https://eips.ethereum.org/EIPS/eip-721
320  */
321 interface IERC721Enumerable is IERC721 {
322     /**
323      * @dev Returns the total amount of tokens stored by the contract.
324      */
325     function totalSupply() external view returns (uint256);
326 
327     /**
328      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
329      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
330      */
331     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
332 
333     /**
334      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
335      * Use along with {totalSupply} to enumerate all tokens.
336      */
337     function tokenByIndex(uint256 index) external view returns (uint256);
338 }
339 
340 // File: SherbetStaking.sol
341 
342 
343 pragma solidity ^0.8.7;
344 
345 
346 
347 
348 contract SherbetStaking is Ownable {
349     IERC721Enumerable nft;
350 
351     bool public stakingLive;
352     
353     mapping(uint256 => address) public tokenOwner;
354 
355     event Staked(address user, uint256 tokenId);
356     event Unstaked(address user, uint256 tokenId);
357 
358     constructor(IERC721Enumerable _sherbetNftAddress) {
359         nft = _sherbetNftAddress;
360     }
361 
362     function stake(uint256[] memory _tokenIds) external {
363         require(stakingLive, "Staking is not currently live.");
364         for (uint256 i = 0; i < _tokenIds.length; i++) {
365             uint256 tokenId = _tokenIds[i];
366             require(nft.ownerOf(tokenId) == msg.sender, "You do not own this token.");
367             nft.safeTransferFrom(msg.sender, address(this), tokenId);
368             tokenOwner[tokenId] = msg.sender;
369             emit Staked(msg.sender, _tokenIds[i]);
370         }
371     }
372 
373     function unstake(uint256[] memory _tokenIds) public {
374         for (uint256 i = 0; i < _tokenIds.length; i++) {
375             uint256 tokenId = _tokenIds[i];
376             require(tokenOwner[tokenId] == msg.sender, "You do not have this token staked.");
377             nft.safeTransferFrom(address(this), msg.sender, tokenId);
378             emit Unstaked(msg.sender, _tokenIds[i]);
379         }
380     }
381 
382     function setStakingStatus(bool _status) external onlyOwner {
383         stakingLive = _status;
384     }
385 
386     function onERC721Received(
387         address,
388         address,
389         uint256,
390         bytes calldata
391     ) external pure returns (bytes4) {
392         return
393             bytes4(
394                 keccak256("onERC721Received(address,address,uint256,bytes)")
395             );
396     }
397 }