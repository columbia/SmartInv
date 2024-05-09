1 /**
2  *Submitted for verification at BscScan.com on 2022-08-09
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Interface of the ERC165 standard, as defined in the
16  * https://eips.ethereum.org/EIPS/eip-165[EIP].
17  *
18  * Implementers can declare support of contract interfaces, which can then be
19  * queried by others ({ERC165Checker}).
20  *
21  * For an implementation, see {ERC165}.
22  */
23 interface IERC165 {
24     /**
25      * @dev Returns true if this contract implements the interface defined by
26      * `interfaceId`. See the corresponding
27      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
28      * to learn more about how these ids are created.
29      *
30      * This function call must use less than 30 000 gas.
31      */
32     function supportsInterface(bytes4 interfaceId) external view returns (bool);
33 }
34 
35 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
36 
37 
38 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 
43 /**
44  * @dev Required interface of an ERC721 compliant contract.
45  */
46 interface IERC721 is IERC165 {
47     /**
48      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
49      */
50     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
54      */
55     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
56 
57     /**
58      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
59      */
60     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
61 
62     /**
63      * @dev Returns the number of tokens in ``owner``'s account.
64      */
65     function balanceOf(address owner) external view returns (uint256 balance);
66 
67     /**
68      * @dev Returns the owner of the `tokenId` token.
69      *
70      * Requirements:
71      *
72      * - `tokenId` must exist.
73      */
74     function ownerOf(uint256 tokenId) external view returns (address owner);
75 
76     /**
77      * @dev Safely transfers `tokenId` token from `from` to `to`.
78      *
79      * Requirements:
80      *
81      * - `from` cannot be the zero address.
82      * - `to` cannot be the zero address.
83      * - `tokenId` token must exist and be owned by `from`.
84      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
85      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
86      *
87      * Emits a {Transfer} event.
88      */
89     function safeTransferFrom(
90         address from,
91         address to,
92         uint256 tokenId,
93         bytes calldata data
94     ) external;
95 
96     /**
97      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
98      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
99      *
100      * Requirements:
101      *
102      * - `from` cannot be the zero address.
103      * - `to` cannot be the zero address.
104      * - `tokenId` token must exist and be owned by `from`.
105      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
107      *
108      * Emits a {Transfer} event.
109      */
110     function safeTransferFrom(
111         address from,
112         address to,
113         uint256 tokenId
114     ) external;
115 
116     /**
117      * @dev Transfers `tokenId` token from `from` to `to`.
118      *
119      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
120      *
121      * Requirements:
122      *
123      * - `from` cannot be the zero address.
124      * - `to` cannot be the zero address.
125      * - `tokenId` token must be owned by `from`.
126      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transferFrom(
131         address from,
132         address to,
133         uint256 tokenId
134     ) external;
135 
136     /**
137      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
138      * The approval is cleared when the token is transferred.
139      *
140      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
141      *
142      * Requirements:
143      *
144      * - The caller must own the token or be an approved operator.
145      * - `tokenId` must exist.
146      *
147      * Emits an {Approval} event.
148      */
149     function approve(address to, uint256 tokenId) external;
150 
151     /**
152      * @dev Approve or remove `operator` as an operator for the caller.
153      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
154      *
155      * Requirements:
156      *
157      * - The `operator` cannot be the caller.
158      *
159      * Emits an {ApprovalForAll} event.
160      */
161     function setApprovalForAll(address operator, bool _approved) external;
162 
163     /**
164      * @dev Returns the account approved for `tokenId` token.
165      *
166      * Requirements:
167      *
168      * - `tokenId` must exist.
169      */
170     function getApproved(uint256 tokenId) external view returns (address operator);
171 
172     /**
173      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
174      *
175      * See {setApprovalForAll}
176      */
177     function isApprovedForAll(address owner, address operator) external view returns (bool);
178 }
179 
180 // File: @openzeppelin/contracts/utils/Context.sol
181 
182 
183 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 /**
188  * @dev Provides information about the current execution context, including the
189  * sender of the transaction and its data. While these are generally available
190  * via msg.sender and msg.data, they should not be accessed in such a direct
191  * manner, since when dealing with meta-transactions the account sending and
192  * paying for execution may not be the actual sender (as far as an application
193  * is concerned).
194  *
195  * This contract is only required for intermediate, library-like contracts.
196  */
197 abstract contract Context {
198     function _msgSender() internal view virtual returns (address) {
199         return msg.sender;
200     }
201 
202     function _msgData() internal view virtual returns (bytes calldata) {
203         return msg.data;
204     }
205 }
206 
207 // File: @openzeppelin/contracts/access/Ownable.sol
208 
209 
210 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 
215 /**
216  * @dev Contract module which provides a basic access control mechanism, where
217  * there is an account (an owner) that can be granted exclusive access to
218  * specific functions.
219  *
220  * By default, the owner account will be the one that deploys the contract. This
221  * can later be changed with {transferOwnership}.
222  *
223  * This module is used through inheritance. It will make available the modifier
224  * `onlyOwner`, which can be applied to your functions to restrict their use to
225  * the owner.
226  */
227 abstract contract Ownable is Context {
228     address private _owner;
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232     /**
233      * @dev Initializes the contract setting the deployer as the initial owner.
234      */
235     constructor() {
236         _transferOwnership(_msgSender());
237     }
238 
239     /**
240      * @dev Throws if called by any account other than the owner.
241      */
242     modifier onlyOwner() {
243         _checkOwner();
244         _;
245     }
246 
247     /**
248      * @dev Returns the address of the current owner.
249      */
250     function owner() public view virtual returns (address) {
251         return _owner;
252     }
253 
254     /**
255      * @dev Throws if the sender is not the owner.
256      */
257     function _checkOwner() internal view virtual {
258         require(owner() == _msgSender(), "Ownable: caller is not the owner");
259     }
260 
261     /**
262      * @dev Leaves the contract without owner. It will not be possible to call
263      * `onlyOwner` functions anymore. Can only be called by the current owner.
264      *
265      * NOTE: Renouncing ownership will leave the contract without an owner,
266      * thereby removing any functionality that is only available to the owner.
267      */
268     function renounceOwnership() public virtual onlyOwner {
269         _transferOwnership(address(0));
270     }
271 
272     /**
273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
274      * Can only be called by the current owner.
275      */
276     function transferOwnership(address newOwner) public virtual onlyOwner {
277         require(newOwner != address(0), "Ownable: new owner is the zero address");
278         _transferOwnership(newOwner);
279     }
280 
281     /**
282      * @dev Transfers ownership of the contract to a new account (`newOwner`).
283      * Internal function without access restriction.
284      */
285     function _transferOwnership(address newOwner) internal virtual {
286         address oldOwner = _owner;
287         _owner = newOwner;
288         emit OwnershipTransferred(oldOwner, newOwner);
289     }
290 }
291 
292 // File: HaresGame/PlanetHareStaking.sol
293 
294 
295 pragma solidity ^0.8.0;
296 
297 
298 
299 contract PlanetHareStaking is Ownable {
300 
301     uint256 public lockPeriod = 300;
302     address public haresAddress1;
303     address public haresAddress2;
304 
305 
306     struct Staking {
307         uint256 tokenID;
308         address owner;
309         uint256 releaseAfter;
310     }
311 
312     uint256 public id;
313     mapping(uint256 => Staking) public stakings;
314     mapping(address => uint256) public count;
315 
316 
317     event Stake(uint256 indexed id, uint256 tokenID, address owner, uint256 releaseAfter);
318     event Redeem(uint256 indexed id);
319 
320     constructor (address _haresAddress1, address _haresAddress2) {
321         haresAddress1 = _haresAddress1;
322         haresAddress2 = _haresAddress2;
323     }
324 
325     function setHaresAddress(address _haresAddress1, address _haresAddress2) public onlyOwner {
326         haresAddress1 = _haresAddress1;
327         haresAddress2 = _haresAddress2;
328     }
329 
330     function setLockPeriod(uint256 _period) public onlyOwner {
331         lockPeriod = _period;
332     }
333 
334     function stake(uint256[] memory _tokenIDs) public {
335         require(count[msg.sender] + _tokenIDs.length <= 24, "Staking up to 24");
336 
337         IERC721 hares1 = IERC721(haresAddress1);
338         IERC721 hares2 = IERC721(haresAddress2);
339 
340         for (uint256 i=0;i < _tokenIDs.length;i++) {
341 
342             if (0 <= _tokenIDs[i] && _tokenIDs[i] <= 2499) {
343                 hares1.transferFrom(msg.sender, address(this), _tokenIDs[i]);
344             } else {
345                 hares2.transferFrom(msg.sender, address(this), _tokenIDs[i]);
346             }
347 
348             uint256 releaseAfter = block.timestamp + lockPeriod;
349 
350             stakings[id] = Staking(_tokenIDs[i], msg.sender, releaseAfter);
351             emit Stake(id, _tokenIDs[i], msg.sender, releaseAfter);
352             id++;
353         }
354         count[msg.sender] += _tokenIDs.length;
355     }
356 
357     function redeem(uint256[] memory _ids) public {
358         IERC721 hares1 = IERC721(haresAddress1);
359         IERC721 hares2 = IERC721(haresAddress2);
360         
361         for (uint256 i=0; i<_ids.length; i++) {
362             uint256 _id = _ids[i];
363 
364             Staking storage staking = stakings[_id];
365             require(staking.owner == msg.sender);
366             require(staking.releaseAfter < block.timestamp);
367 
368             if (0 <= staking.tokenID && staking.tokenID <= 2499) {
369                 hares1.transferFrom(address(this), msg.sender, staking.tokenID);
370             } else {
371                 hares2.transferFrom(address(this), msg.sender, staking.tokenID);
372             }
373 
374             delete stakings[_id];
375 
376             emit Redeem(_id);
377         }
378         count[msg.sender] -= _ids.length;
379 
380     }
381 }