1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 // File: @openzeppelin/contracts/utils/Context.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Provides information about the current execution context, including the
183  * sender of the transaction and its data. While these are generally available
184  * via msg.sender and msg.data, they should not be accessed in such a direct
185  * manner, since when dealing with meta-transactions the account sending and
186  * paying for execution may not be the actual sender (as far as an application
187  * is concerned).
188  *
189  * This contract is only required for intermediate, library-like contracts.
190  */
191 abstract contract Context {
192     function _msgSender() internal view virtual returns (address) {
193         return msg.sender;
194     }
195 
196     function _msgData() internal view virtual returns (bytes calldata) {
197         return msg.data;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/access/Ownable.sol
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @dev Contract module which provides a basic access control mechanism, where
211  * there is an account (an owner) that can be granted exclusive access to
212  * specific functions.
213  *
214  * By default, the owner account will be the one that deploys the contract. This
215  * can later be changed with {transferOwnership}.
216  *
217  * This module is used through inheritance. It will make available the modifier
218  * `onlyOwner`, which can be applied to your functions to restrict their use to
219  * the owner.
220  */
221 abstract contract Ownable is Context {
222     address private _owner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     /**
227      * @dev Initializes the contract setting the deployer as the initial owner.
228      */
229     constructor() {
230         _transferOwnership(_msgSender());
231     }
232 
233     /**
234      * @dev Returns the address of the current owner.
235      */
236     function owner() public view virtual returns (address) {
237         return _owner;
238     }
239 
240     /**
241      * @dev Throws if called by any account other than the owner.
242      */
243     modifier onlyOwner() {
244         require(owner() == _msgSender(), "Ownable: caller is not the owner");
245         _;
246     }
247 
248     /**
249      * @dev Leaves the contract without owner. It will not be possible to call
250      * `onlyOwner` functions anymore. Can only be called by the current owner.
251      *
252      * NOTE: Renouncing ownership will leave the contract without an owner,
253      * thereby removing any functionality that is only available to the owner.
254      */
255     function renounceOwnership() public virtual onlyOwner {
256         _transferOwnership(address(0));
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      * Can only be called by the current owner.
262      */
263     function transferOwnership(address newOwner) public virtual onlyOwner {
264         require(newOwner != address(0), "Ownable: new owner is the zero address");
265         _transferOwnership(newOwner);
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Internal function without access restriction.
271      */
272     function _transferOwnership(address newOwner) internal virtual {
273         address oldOwner = _owner;
274         _owner = newOwner;
275         emit OwnershipTransferred(oldOwner, newOwner);
276     }
277 }
278 
279 // File: ChillBearStaking.sol
280 
281 
282 pragma solidity ^0.8.7;
283 
284 
285 
286 contract CBCStaking is Ownable {
287 
288     address public constant CBC_ADDRESS = 0xc7b76846De3DB54DB45c8b5deBCabfF4b0834F78;
289     bool public stakingLive = false;
290     bool public unlockAll = false;
291     uint256 public stakingLockPeriod = 2592000;  // 30 days in seconds
292 
293     mapping(uint256 => address) internal tokenIdToAddress;
294     mapping(address => uint256[]) internal addressToTokenIds;
295     mapping(uint256 => uint256) internal tokenLockedUntil;
296 
297     event LockPeriodChanged(uint indexed prevLockPeriod, uint indexed newLockPeriod);
298     
299    
300     IERC721 private constant _IERC721 = IERC721(CBC_ADDRESS);
301 
302     constructor() {
303     }
304 
305     modifier stakingEnabled {
306         require(stakingLive, "Staking not live yet");
307         _;
308     }
309 
310     function getCBCStaked(address staker) public view returns (uint256[] memory) {
311         return addressToTokenIds[staker];
312     }
313     
314     function getStakedCount(address staker) public view returns (uint256) {
315         return addressToTokenIds[staker].length;
316     }
317 
318     function removeTokenIdFromArray(uint256[] storage array, uint256 tokenId) internal {
319         uint256 length = array.length;
320         for (uint256 i = 0; i < length; i++) {
321             if (array[i] == tokenId) {
322                 length--;
323                 if (i < length) {
324                     array[i] = array[length];
325                 }
326                 array.pop();
327                 break;
328             }
329         }
330     }
331 
332     function stakeByIds(uint256[] memory tokenIds) public stakingEnabled {
333 
334         for (uint256 i = 0; i < tokenIds.length; i++) {
335             uint256 id = tokenIds[i];
336             require(_IERC721.ownerOf(id) == msg.sender && tokenIdToAddress[id] == address(0), "You do not own the token!");
337             _IERC721.transferFrom(msg.sender, address(this), id);
338 
339             addressToTokenIds[msg.sender].push(id);
340             tokenIdToAddress[id] = msg.sender;
341             
342             uint256 lockUntil = block.timestamp + stakingLockPeriod;
343             tokenLockedUntil[id] = lockUntil;
344         }
345     }
346 
347     function unstakeByIds(uint256[] memory tokenIds) public {
348 
349         for (uint256 i = 0; i < tokenIds.length; i++) {
350             uint256 id = tokenIds[i];
351             require(tokenIdToAddress[id] == msg.sender, "You are not the owner of this token!");
352             require(tokenLockedUntil[id] < block.timestamp || unlockAll == true, "Token is still locked");
353 
354             _IERC721.transferFrom(address(this), msg.sender, id);
355 
356             removeTokenIdFromArray(addressToTokenIds[msg.sender], id);
357             tokenIdToAddress[id] = address(0);
358         }
359     }
360 
361 
362     function getTokenOwner(uint256 tokenId) public view returns (address) {
363         return tokenIdToAddress[tokenId];
364     }
365 
366     function getLockedUntil(uint256 tokenId) public view returns (uint256) {
367         return tokenLockedUntil[tokenId];
368     }
369 
370     function toggleStaking() external onlyOwner {
371         stakingLive = !stakingLive;
372     }
373 
374     function toggleUnlockAll() external onlyOwner {
375         unlockAll = !unlockAll;
376     }
377 
378     function setLockPeriod(uint newLockPeriod) external onlyOwner {
379         uint prevLockPeriod = stakingLockPeriod;
380         stakingLockPeriod = newLockPeriod;
381         emit LockPeriodChanged(prevLockPeriod, newLockPeriod);
382     }
383 }