1 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title ERC721 token receiver interface
9  * @dev Interface for any contract that wants to support safeTransfers
10  * from ERC721 asset contracts.
11  */
12 interface IERC721Receiver {
13     /**
14      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
15      * by `operator` from `from`, this function is called.
16      *
17      * It must return its Solidity selector to confirm the token transfer.
18      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
19      *
20      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
21      */
22     function onERC721Received(
23         address operator,
24         address from,
25         uint256 tokenId,
26         bytes calldata data
27     ) external returns (bytes4);
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
31 
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address sender,
95         address recipient,
96         uint256 amount
97     ) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
115 
116 
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC165 standard, as defined in the
122  * https://eips.ethereum.org/EIPS/eip-165[EIP].
123  *
124  * Implementers can declare support of contract interfaces, which can then be
125  * queried by others ({ERC165Checker}).
126  *
127  * For an implementation, see {ERC165}.
128  */
129 interface IERC165 {
130     /**
131      * @dev Returns true if this contract implements the interface defined by
132      * `interfaceId`. See the corresponding
133      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
134      * to learn more about how these ids are created.
135      *
136      * This function call must use less than 30 000 gas.
137      */
138     function supportsInterface(bytes4 interfaceId) external view returns (bool);
139 }
140 
141 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
142 
143 
144 
145 pragma solidity ^0.8.0;
146 
147 
148 /**
149  * @dev Required interface of an ERC721 compliant contract.
150  */
151 interface IERC721 is IERC165 {
152     /**
153      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
156 
157     /**
158      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
159      */
160     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
161 
162     /**
163      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
164      */
165     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
166 
167     /**
168      * @dev Returns the number of tokens in ``owner``'s account.
169      */
170     function balanceOf(address owner) external view returns (uint256 balance);
171 
172     /**
173      * @dev Returns the owner of the `tokenId` token.
174      *
175      * Requirements:
176      *
177      * - `tokenId` must exist.
178      */
179     function ownerOf(uint256 tokenId) external view returns (address owner);
180 
181     /**
182      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
183      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must exist and be owned by `from`.
190      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
191      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
192      *
193      * Emits a {Transfer} event.
194      */
195     function safeTransferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external;
200 
201     /**
202      * @dev Transfers `tokenId` token from `from` to `to`.
203      *
204      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must be owned by `from`.
211      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(
216         address from,
217         address to,
218         uint256 tokenId
219     ) external;
220 
221     /**
222      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
223      * The approval is cleared when the token is transferred.
224      *
225      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
226      *
227      * Requirements:
228      *
229      * - The caller must own the token or be an approved operator.
230      * - `tokenId` must exist.
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address to, uint256 tokenId) external;
235 
236     /**
237      * @dev Returns the account approved for `tokenId` token.
238      *
239      * Requirements:
240      *
241      * - `tokenId` must exist.
242      */
243     function getApproved(uint256 tokenId) external view returns (address operator);
244 
245     /**
246      * @dev Approve or remove `operator` as an operator for the caller.
247      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
248      *
249      * Requirements:
250      *
251      * - The `operator` cannot be the caller.
252      *
253      * Emits an {ApprovalForAll} event.
254      */
255     function setApprovalForAll(address operator, bool _approved) external;
256 
257     /**
258      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
259      *
260      * See {setApprovalForAll}
261      */
262     function isApprovedForAll(address owner, address operator) external view returns (bool);
263 
264     /**
265      * @dev Safely transfers `tokenId` token from `from` to `to`.
266      *
267      * Requirements:
268      *
269      * - `from` cannot be the zero address.
270      * - `to` cannot be the zero address.
271      * - `tokenId` token must exist and be owned by `from`.
272      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
273      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
274      *
275      * Emits a {Transfer} event.
276      */
277     function safeTransferFrom(
278         address from,
279         address to,
280         uint256 tokenId,
281         bytes calldata data
282     ) external;
283 }
284 
285 // File: prayerhands/prayerStake.sol
286 
287 pragma solidity 0.8.7;
288 //SPDX-License-Identifier: UNLICENSED
289 
290 
291 
292 
293 contract PrayerStake is IERC721Receiver {
294      IERC721 public nft_address;
295      IERC20 public ft_address;
296 
297     uint256 public blocks_per_day = 6500;
298     uint256 public rewards_per_day = 11 * 10**18;
299     struct NFTData {
300         uint256 id;
301         uint256 stakingBlock; // time when the NFT was staked
302     }
303 
304     mapping(uint256 => address) NftIdToOwner;
305     mapping(address => uint256[]) NftOwnerToIds;
306     mapping(uint256 => NFTData) NftIdToData;
307     mapping(uint256 => uint256) redeemedFtBalancePerNft;
308 
309     mapping(address => uint256) redeemedFtBalance;
310 
311     address[] stakers;
312 
313     uint numStakers = 0;
314 
315     constructor(address nft, address ft) {
316         nft_address = IERC721(nft);
317         ft_address = IERC20(ft);
318     }
319 
320     function stake(uint256 id) public {
321         require(nft_address.ownerOf(id) == msg.sender);
322         nft_address.safeTransferFrom(msg.sender, address(this), id, "");
323         require(nft_address.ownerOf(id) == address(this), "Staking contract must own the NFT");
324 
325         NFTData memory data;
326         data.id = id;
327         data.stakingBlock = block.number;
328         NftIdToData[id] = data;
329 
330         NftIdToOwner[id] = msg.sender;
331         NftOwnerToIds[msg.sender].push(id);
332 
333         stakers.push(msg.sender);
334 
335         numStakers += 1;
336     }
337 
338     function unstake(uint256 id) public {
339         require(nft_address.ownerOf(id) == address(this));
340         require(NftIdToOwner[id] == msg.sender);
341         require(NftOwnerToIds[msg.sender].length > 0);
342 
343         this.withdrawTokens(id);
344 
345         for (uint i =0; i < NftOwnerToIds[msg.sender].length; i++){
346             if (NftOwnerToIds[msg.sender][i] == id){
347                 delete NftOwnerToIds[msg.sender][i];
348             }
349         }
350 
351         delete NftIdToOwner[id];
352         delete NftIdToData[id];
353         
354         nft_address.safeTransferFrom(address(this), msg.sender, id, "");
355 
356         numStakers -= 1;
357 
358         redeemedFtBalance[tx.origin] -= redeemedFtBalancePerNft[id];
359         redeemedFtBalancePerNft[id] = 0;
360     }
361 
362     function getStakedNfts(address owner) public view returns( uint256[] memory ) {
363 
364         return NftOwnerToIds[owner];
365     }
366 
367     function getRedeemedFtBalance(address owner) public view returns(uint256) {
368 
369         return redeemedFtBalance[owner];
370     }
371 
372     function getStakingBlock(uint256 id) public view returns(uint256) {
373 
374         return NftIdToData[id].stakingBlock;
375     }
376     
377     function getStakers() public view returns(address[] memory) {
378         return stakers;
379     }
380 
381     function getNumStakers() public view returns(uint256) {
382         
383         return numStakers;
384     }
385 
386     event withdrew(address indexed _from, uint _value);
387 
388     function withdrawTokens(uint256 id) public {
389         require(NftIdToOwner[id] == tx.origin, "origin doesnt own nft");
390 
391         uint256 totalStakedBlocks = block.number - NftIdToData[id].stakingBlock;
392 
393         uint256 rewardAmount = (totalStakedBlocks * rewards_per_day) / blocks_per_day - redeemedFtBalancePerNft[id];
394                 
395         redeemedFtBalance[tx.origin] += rewardAmount;
396         redeemedFtBalancePerNft[id] += rewardAmount;
397 
398         require(ft_address.balanceOf(address(this)) >= rewardAmount, "contract doesn't own enough rewards");
399         
400         emit withdrew(tx.origin, rewardAmount);
401 
402         ft_address.transfer(tx.origin, rewardAmount);
403 
404     }
405 
406     function  onERC721Received(
407         address operator,
408         address from,
409         uint256 tokenId,
410         bytes calldata data
411     ) override external returns (bytes4){
412         return this.onERC721Received.selector;
413     }
414 }