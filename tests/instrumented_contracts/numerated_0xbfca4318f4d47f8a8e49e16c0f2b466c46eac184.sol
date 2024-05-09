1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 
26 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
27 
28 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 
170 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
171 
172 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @dev Provides information about the current execution context, including the
178  * sender of the transaction and its data. While these are generally available
179  * via msg.sender and msg.data, they should not be accessed in such a direct
180  * manner, since when dealing with meta-transactions the account sending and
181  * paying for execution may not be the actual sender (as far as an application
182  * is concerned).
183  *
184  * This contract is only required for intermediate, library-like contracts.
185  */
186 abstract contract Context {
187     function _msgSender() internal view virtual returns (address) {
188         return msg.sender;
189     }
190 
191     function _msgData() internal view virtual returns (bytes calldata) {
192         return msg.data;
193     }
194 }
195 
196 
197 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
198 
199 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
200 
201 pragma solidity ^0.8.0;
202 
203 /**
204  * @dev Contract module which provides a basic access control mechanism, where
205  * there is an account (an owner) that can be granted exclusive access to
206  * specific functions.
207  *
208  * By default, the owner account will be the one that deploys the contract. This
209  * can later be changed with {transferOwnership}.
210  *
211  * This module is used through inheritance. It will make available the modifier
212  * `onlyOwner`, which can be applied to your functions to restrict their use to
213  * the owner.
214  */
215 abstract contract Ownable is Context {
216     address private _owner;
217 
218     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
219 
220     /**
221      * @dev Initializes the contract setting the deployer as the initial owner.
222      */
223     constructor() {
224         _transferOwnership(_msgSender());
225     }
226 
227     /**
228      * @dev Returns the address of the current owner.
229      */
230     function owner() public view virtual returns (address) {
231         return _owner;
232     }
233 
234     /**
235      * @dev Throws if called by any account other than the owner.
236      */
237     modifier onlyOwner() {
238         require(owner() == _msgSender(), "Ownable: caller is not the owner");
239         _;
240     }
241 
242     /**
243      * @dev Leaves the contract without owner. It will not be possible to call
244      * `onlyOwner` functions anymore. Can only be called by the current owner.
245      *
246      * NOTE: Renouncing ownership will leave the contract without an owner,
247      * thereby removing any functionality that is only available to the owner.
248      */
249     function renounceOwnership() public virtual onlyOwner {
250         _transferOwnership(address(0));
251     }
252 
253     /**
254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
255      * Can only be called by the current owner.
256      */
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         _transferOwnership(newOwner);
260     }
261 
262     /**
263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
264      * Internal function without access restriction.
265      */
266     function _transferOwnership(address newOwner) internal virtual {
267         address oldOwner = _owner;
268         _owner = newOwner;
269         emit OwnershipTransferred(oldOwner, newOwner);
270     }
271 }
272 
273 
274 // File contracts/AxolittlesStakingV2.sol
275 
276 
277 pragma solidity ^0.8.10;
278 /// @title Interface to interact with Bubbles contract.
279 interface IBubbles {
280     function mint(address recipient, uint256 amount) external;
281 }
282 
283 /// @author The Axolittles Team
284 /// @title Contract V2 for staking axos to receive $BUBBLE
285 contract AxolittlesStakingV2 is Ownable {
286     address public AXOLITTLES = 0xf36446105fF682999a442b003f2224BcB3D82067;
287     address public TOKEN = 0x58f46F627C88a3b217abc80563B9a726abB873ba;
288     address public STAKING_V1 = 0x1cA6e4643062e67CCd555fB4F64Bee603340e0ea;
289     bool public stakingPaused;
290     bool public isVariableReward = true;
291     uint256 public stakeTarget = 6000;
292     // Amount of $BUBBLE generated each block, contains 18 decimals.
293     uint256 public emissionPerBlock = 15000000000000000;
294     uint256 internal totalStaked;
295 
296     /// @notice struct per owner address to store:
297     /// a. previously calced rewards, b. number staked, and block since last reward calculation.
298     struct staker {
299         // number of axolittles currently staked
300         uint256 numStaked;
301         // block since calcedReward was last updated
302         uint256 blockSinceLastCalc;
303         // previously calculated rewards
304         uint256 calcedReward;
305     }
306 
307     mapping(address => staker) public stakers;
308     mapping(uint256 => address) public stakedAxos;
309 
310     constructor() {}
311 
312     event Stake(address indexed owner, uint256[] tokenIds);
313     event Unstake(address indexed owner, uint256[] tokenIds);
314     event Claim(address indexed owner, uint256 totalReward);
315     event SetStakingPaused(bool _stakingPaused);
316     event SetVariableReward(bool _isVariableReward);
317     event SetStakeTarget(uint256 stakeTarget);
318     event AdminTransfer(uint256[] tokenIds);
319 
320     /// @notice Function to stake axos. Transfers axos from sender to this contract.
321     function stake(uint256[] memory tokenIds) external {
322         require(!stakingPaused, "Staking is paused");
323         require(tokenIds.length > 0, "Nothing to stake");
324         stakers[msg.sender].calcedReward = _checkRewardInternal(msg.sender);
325         stakers[msg.sender].numStaked += tokenIds.length;
326         stakers[msg.sender].blockSinceLastCalc = block.number;
327         totalStaked += tokenIds.length;
328         for (uint256 i = 0; i < tokenIds.length; i++) {
329             IERC721(AXOLITTLES).transferFrom(
330                 msg.sender,
331                 address(this),
332                 tokenIds[i]
333             );
334             stakedAxos[tokenIds[i]] = msg.sender;
335         }
336         emit Stake(msg.sender, tokenIds);
337     }
338 
339     /// @notice Function to unstake axos. Transfers axos from this contract back to sender address.
340     function unstake(uint256[] memory tokenIds) external {
341         require(tokenIds.length > 0, "Nothing to unstake");
342         require(
343             tokenIds.length <= stakers[msg.sender].numStaked,
344             "Not your axo!"
345         );
346         stakers[msg.sender].calcedReward = _checkRewardInternal(msg.sender);
347         stakers[msg.sender].numStaked -= tokenIds.length;
348         stakers[msg.sender].blockSinceLastCalc = block.number;
349         totalStaked -= tokenIds.length;
350         for (uint256 i = 0; i < tokenIds.length; i++) {
351             require(msg.sender == stakedAxos[tokenIds[i]], "Not your axo!");
352             delete stakedAxos[tokenIds[i]];
353             IERC721(AXOLITTLES).transferFrom(
354                 address(this),
355                 msg.sender,
356                 tokenIds[i]
357             );
358         }
359         emit Unstake(msg.sender, tokenIds);
360     }
361 
362     /// @notice Function to claim $BUBBLE.
363     function claim() external {
364         uint256 totalReward = _checkRewardInternal(msg.sender);
365         require(totalReward > 0, "Nothing to claim");
366         stakers[msg.sender].blockSinceLastCalc = block.number;
367         stakers[msg.sender].calcedReward = 0;
368         IBubbles(TOKEN).mint(msg.sender, totalReward);
369         emit Claim(msg.sender, totalReward);
370     }
371 
372     /// @notice Function to check rewards per staker address
373     function checkReward(address _staker_address)
374         external
375         view
376         returns (uint256)
377     {
378         return _checkRewardInternal(_staker_address);
379     }
380 
381     /// @notice Internal function to check rewards per staker address
382     function _checkRewardInternal(address _staker_address)
383         internal
384         view
385         returns (uint256)
386     {
387         uint256 newReward = stakers[_staker_address].numStaked *
388             emissionPerBlock *
389             (block.number - stakers[_staker_address].blockSinceLastCalc);
390         if (isVariableReward) {
391             uint256 bothStaked = totalStaked +
392                 IERC721(AXOLITTLES).balanceOf(STAKING_V1);
393             if (bothStaked >= stakeTarget) {
394                 newReward *= 2;
395             } else {
396                 newReward = (newReward * bothStaked) / stakeTarget;
397             }
398         }
399         return stakers[_staker_address].calcedReward + newReward;
400     }
401 
402     //ADMIN FUNCTIONS
403     /// @notice Function to change address of NFT
404     function setAxolittlesAddress(address _axolittlesAddress)
405         external
406         onlyOwner
407     {
408         AXOLITTLES = _axolittlesAddress;
409     }
410 
411     /// @notice Function to change address of reward token
412     function setTokenAddress(address _tokenAddress) external onlyOwner {
413         TOKEN = _tokenAddress;
414     }
415 
416     /// @notice Function to change amount of $BUBBLE generated each block per axo
417     function setEmissionPerBlock(uint256 _emissionPerBlock) external onlyOwner {
418         emissionPerBlock = _emissionPerBlock;
419     }
420 
421     /// @notice Function to prevent further staking
422     function setStakingPaused(bool _isPaused) external onlyOwner {
423         stakingPaused = _isPaused;
424         emit SetStakingPaused(stakingPaused);
425     }
426 
427     ///@notice Function to turn on variable rewards
428     function setVariableReward(bool _isVariableReward) external onlyOwner {
429         require(isVariableReward != _isVariableReward, "Nothing changed");
430         isVariableReward = _isVariableReward;
431         emit SetVariableReward(isVariableReward);
432     }
433 
434     ///@notice Function to change stake target for variable rewards
435     function setStakeTarget(uint256 _stakeTarget) external onlyOwner {
436         require(_stakeTarget > 0, "Please don't break the math!");
437         stakeTarget = _stakeTarget;
438         emit SetStakeTarget(stakeTarget);
439     }
440 
441     /// @notice Function for admin to transfer axos out of contract back to original owner
442     function adminTransfer(uint256[] memory tokenIds) external onlyOwner {
443         require(tokenIds.length > 0, "Nothing to unstake");
444         totalStaked -= tokenIds.length;
445         for (uint256 i = 0; i < tokenIds.length; i++) {
446             address owner = stakedAxos[tokenIds[i]];
447             require(owner != address(0), "Axo not found");
448             stakers[owner].numStaked--;
449             delete stakedAxos[tokenIds[i]];
450             IERC721(AXOLITTLES).transferFrom(address(this), owner, tokenIds[i]);
451         }
452         emit AdminTransfer(tokenIds);
453     }
454 }