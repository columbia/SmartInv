1 // File: openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
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
29 // File: openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
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
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId,
87         bytes calldata data
88     ) external;
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 }
173 
174 // File: openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Enumerable is IERC721 {
187     /**
188      * @dev Returns the total amount of tokens stored by the contract.
189      */
190     function totalSupply() external view returns (uint256);
191 
192     /**
193      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
194      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
195      */
196     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
197 
198     /**
199      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
200      * Use along with {totalSupply} to enumerate all tokens.
201      */
202     function tokenByIndex(uint256 index) external view returns (uint256);
203 }
204 
205 // File: openzeppelin-contracts/contracts/utils/Context.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Provides information about the current execution context, including the
214  * sender of the transaction and its data. While these are generally available
215  * via msg.sender and msg.data, they should not be accessed in such a direct
216  * manner, since when dealing with meta-transactions the account sending and
217  * paying for execution may not be the actual sender (as far as an application
218  * is concerned).
219  *
220  * This contract is only required for intermediate, library-like contracts.
221  */
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes calldata) {
228         return msg.data;
229     }
230 }
231 
232 // File: openzeppelin-contracts/contracts/access/Ownable.sol
233 
234 
235 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 
240 /**
241  * @dev Contract module which provides a basic access control mechanism, where
242  * there is an account (an owner) that can be granted exclusive access to
243  * specific functions.
244  *
245  * By default, the owner account will be the one that deploys the contract. This
246  * can later be changed with {transferOwnership}.
247  *
248  * This module is used through inheritance. It will make available the modifier
249  * `onlyOwner`, which can be applied to your functions to restrict their use to
250  * the owner.
251  */
252 abstract contract Ownable is Context {
253     address private _owner;
254 
255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
256 
257     /**
258      * @dev Initializes the contract setting the deployer as the initial owner.
259      */
260     constructor() {
261         _transferOwnership(_msgSender());
262     }
263 
264     /**
265      * @dev Throws if called by any account other than the owner.
266      */
267     modifier onlyOwner() {
268         _checkOwner();
269         _;
270     }
271 
272     /**
273      * @dev Returns the address of the current owner.
274      */
275     function owner() public view virtual returns (address) {
276         return _owner;
277     }
278 
279     /**
280      * @dev Throws if the sender is not the owner.
281      */
282     function _checkOwner() internal view virtual {
283         require(owner() == _msgSender(), "Ownable: caller is not the owner");
284     }
285 
286     /**
287      * @dev Leaves the contract without owner. It will not be possible to call
288      * `onlyOwner` functions anymore. Can only be called by the current owner.
289      *
290      * NOTE: Renouncing ownership will leave the contract without an owner,
291      * thereby removing any functionality that is only available to the owner.
292      */
293     function renounceOwnership() public virtual onlyOwner {
294         _transferOwnership(address(0));
295     }
296 
297     /**
298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
299      * Can only be called by the current owner.
300      */
301     function transferOwnership(address newOwner) public virtual onlyOwner {
302         require(newOwner != address(0), "Ownable: new owner is the zero address");
303         _transferOwnership(newOwner);
304     }
305 
306     /**
307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
308      * Internal function without access restriction.
309      */
310     function _transferOwnership(address newOwner) internal virtual {
311         address oldOwner = _owner;
312         _owner = newOwner;
313         emit OwnershipTransferred(oldOwner, newOwner);
314     }
315 }
316 
317 // File: NFTStakeV2.sol
318 
319 
320 pragma solidity ^0.8.0;
321 
322 
323 
324 interface IMint{
325     function mint(address to, uint256 id, uint256 amount, bytes memory data) external;
326 }
327 
328 interface IV1{
329     struct StakeInfo{
330         uint32 stakeTime;
331         uint32 unstakeTime;
332         uint192 claimedReward;
333     }
334     function stakeNFT() external view returns(IERC721Enumerable);
335     function rewardNFT() external view returns(IMint);
336     function rewards(address) external view returns(uint192);
337     function stakeInfos(uint256) external view returns(StakeInfo memory);
338     function blackTokens(uint256) external view returns(bool);
339     function getPower(uint16) external view returns(uint8);
340     function getReward(uint256, uint256, uint256) external view returns(uint192);
341     function tokenIdsWithStakeInfo(address, uint256, uint256) external view returns(uint256, uint256[] memory, StakeInfo[] memory, uint192[] memory);
342 }
343 
344 contract NFTStakeV2 is Ownable{
345     struct StakeInfo{
346         address owner;
347         uint32 stakeTime;
348         uint192 claimedReward;
349     }
350     IV1 immutable public v1;
351     mapping(uint256 => StakeInfo) public _stakeInfos;
352     bool public stakeOpen = true;
353     mapping(address => uint192) public rewards;
354     
355     constructor(IV1 _v1){
356         v1 = _v1;
357     }
358     
359     modifier onlyOpen(){
360         require(stakeOpen, "Stake:notOpen");
361         _;
362     }
363     
364     function setStakeOpen(bool enable) external onlyOwner{
365         stakeOpen = enable;
366     }
367     
368     function nestingTransfer(uint256 tokenId) external pure returns(bool){
369         return true;
370     }
371     
372     function stakeInfos(uint256 tokenId) public view returns(StakeInfo memory infov2){
373         infov2 = _stakeInfos[tokenId];
374         if(infov2.owner == address(0)){
375             IV1.StakeInfo memory infov1 = v1.stakeInfos(tokenId);
376             infov2 = StakeInfo(v1.stakeNFT().ownerOf(tokenId), infov1.stakeTime, infov1.claimedReward);
377         }
378     }
379     
380     function _checkOwner(uint16 tokenId) internal view returns(address _owner){
381         _owner = v1.stakeNFT().ownerOf(tokenId);
382         require(_owner == msg.sender || owner() == msg.sender, "Stake:notOwner");
383     }
384     
385     function _stake(uint16 tokenId) internal{
386         address _owner = _checkOwner(tokenId);
387         StakeInfo memory infov2 = _stakeInfos[tokenId];
388         if(infov2.owner == address(0)){
389             IV1.StakeInfo memory infov1 = v1.stakeInfos(tokenId);
390             if(infov1.stakeTime > 0){
391                 _stakeInfos[tokenId] = StakeInfo(_owner, infov1.stakeTime, infov1.claimedReward);
392                 return;
393             }
394         }else if(infov2.owner == _owner){
395             require(infov2.stakeTime == 0, "Stake:staked");
396         }
397         _stakeInfos[tokenId] = StakeInfo(_owner, uint32(block.timestamp), 0);
398     }
399     
400     function stake(uint16 tokenId) external onlyOpen{
401         _stake(tokenId);
402     }
403     
404     function batchStake(uint16[] calldata tokenIds) external onlyOpen{
405         for(uint256 i = 0; i < tokenIds.length; i++){
406             _stake(tokenIds[i]);
407         }
408     }
409     
410     function stakeInfoAndReward(uint16 tokenId, address _owner) public view returns(uint192 totalReward, StakeInfo memory infov2){
411         infov2 = stakeInfos(tokenId);
412         if(v1.blackTokens(tokenId)){
413             totalReward = infov2.claimedReward;
414         }else if(infov2.owner == _owner && infov2.stakeTime > 0){
415             totalReward = v1.getReward(infov2.stakeTime, block.timestamp, v1.getPower(tokenId));
416         }
417     }
418     
419     function unstake(uint16 tokenId) public{
420         address _owner = _checkOwner(tokenId);
421         (uint192 totalReward, StakeInfo memory infov2) = stakeInfoAndReward(tokenId, _owner);
422         _stakeInfos[tokenId] = StakeInfo(_owner, 0, 0);
423         rewards[_owner] += (totalReward - infov2.claimedReward);
424     }
425     
426     function batchUnstake(uint16[] calldata tokenIds) external{
427         for(uint256 i = 0; i < tokenIds.length; i++){
428             unstake(tokenIds[i]);
429         }
430     }
431     
432     function _claimReward(uint16 tokenId) internal returns(uint192 reward){
433         address _owner = v1.stakeNFT().ownerOf(tokenId);
434         require(_owner == msg.sender, "Stake:notOwner");
435         (uint192 totalReward, StakeInfo memory infov2) = stakeInfoAndReward(tokenId, _owner);
436         reward = totalReward - infov2.claimedReward;
437         _stakeInfos[tokenId] = StakeInfo(_owner, infov2.stakeTime, totalReward);
438     }
439     
440     function _claim(uint192 reward) internal {
441         uint192 amount = reward / 1e18;
442         require(amount > 0, "Stake:notEnoughReward");
443         rewards[msg.sender] = reward % 1e18;
444         v1.rewardNFT().mint(msg.sender, 0, amount, "");
445     }
446     
447     function claim(uint16 tokenId) external{
448         uint192 reward = rewards[msg.sender] + _claimReward(tokenId);
449         _claim(reward);
450     }
451     
452     function batchClaim(uint16[] calldata tokenIds) external{
453         uint192 reward = rewards[msg.sender];
454         for(uint256 i = 0; i < tokenIds.length; i++){
455             reward += _claimReward(tokenIds[i]);
456         }
457         _claim(reward);
458     }
459     
460     function tokenIdsWithStakeInfo(address account, uint256 pageStart, uint256 pageSize) external view returns(
461         uint256 len, uint256[] memory tokenIds, StakeInfo[] memory stakeInfos_, uint192[] memory totalRewards){
462         IERC721Enumerable nft = v1.stakeNFT();
463         len = nft.balanceOf(account);
464         uint256 size;
465         if(pageStart < len){
466             size = len - pageStart;
467             if(size > pageSize) size = pageSize;
468         }
469         tokenIds = new uint256[](size);
470         stakeInfos_ = new StakeInfo[](size);
471         totalRewards = new uint192[](size);
472         for(uint256 i = 0; i < size; i++){
473             uint256 tokenId = nft.tokenOfOwnerByIndex(account, pageStart+i);
474             tokenIds[i] = tokenId;
475             (uint192 totalReward, StakeInfo memory infov2) = stakeInfoAndReward(uint16(tokenId), account);
476             stakeInfos_[i] = infov2;
477             totalRewards[i] = totalReward;
478         }
479     }
480     
481     function migrageReward(address[] calldata accounts, uint192[] calldata _rewards) external onlyOwner{
482         require(accounts.length == _rewards.length, "arrayNotMatch");
483         for(uint256 i = 0; i < accounts.length; i++){
484             rewards[accounts[i]] += _rewards[i];
485         }
486     }
487 }