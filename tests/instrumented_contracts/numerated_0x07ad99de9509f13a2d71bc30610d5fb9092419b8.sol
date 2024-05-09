1 // File: contracts/interface/ISkvllbabiez.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 interface ISkvllbabiez {
7     function safeTransferFrom(address from, address to, uint256 tokenId) external;
8     function walletOfOwner(address _owner) external view returns(uint256[] memory);
9     function balanceOf(address owner) external view returns (uint256 balance);
10     function ownerOf(uint256 tokenId) external view returns (address owner);
11     function approve(address operator, uint256 tokenId) external;
12 }
13 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
14 
15 
16 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(
78         address sender,
79         address recipient,
80         uint256 amount
81     ) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Contract module that helps prevent reentrant calls to a function.
107  *
108  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
109  * available, which can be applied to functions to make sure there are no nested
110  * (reentrant) calls to them.
111  *
112  * Note that because there is a single `nonReentrant` guard, functions marked as
113  * `nonReentrant` may not call one another. This can be worked around by making
114  * those functions `private`, and then adding `external` `nonReentrant` entry
115  * points to them.
116  *
117  * TIP: If you would like to learn more about reentrancy and alternative ways
118  * to protect against it, check out our blog post
119  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
120  */
121 abstract contract ReentrancyGuard {
122     // Booleans are more expensive than uint256 or any type that takes up a full
123     // word because each write operation emits an extra SLOAD to first read the
124     // slot's contents, replace the bits taken up by the boolean, and then write
125     // back. This is the compiler's defense against contract upgrades and
126     // pointer aliasing, and it cannot be disabled.
127 
128     // The values being non-zero value makes deployment a bit more expensive,
129     // but in exchange the refund on every call to nonReentrant will be lower in
130     // amount. Since refunds are capped to a percentage of the total
131     // transaction's gas, it is best to keep them low in cases like this one, to
132     // increase the likelihood of the full refund coming into effect.
133     uint256 private constant _NOT_ENTERED = 1;
134     uint256 private constant _ENTERED = 2;
135 
136     uint256 private _status;
137 
138     constructor() {
139         _status = _NOT_ENTERED;
140     }
141 
142     /**
143      * @dev Prevents a contract from calling itself, directly or indirectly.
144      * Calling a `nonReentrant` function from another `nonReentrant`
145      * function is not supported. It is possible to prevent this from happening
146      * by making the `nonReentrant` function external, and making it call a
147      * `private` function that does the actual work.
148      */
149     modifier nonReentrant() {
150         // On the first call to nonReentrant, _notEntered will be true
151         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
152 
153         // Any calls to nonReentrant after this point will fail
154         _status = _ENTERED;
155 
156         _;
157 
158         // By storing the original value once again, a refund is triggered (see
159         // https://eips.ethereum.org/EIPS/eip-2200)
160         _status = _NOT_ENTERED;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/utils/Context.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @dev Provides information about the current execution context, including the
173  * sender of the transaction and its data. While these are generally available
174  * via msg.sender and msg.data, they should not be accessed in such a direct
175  * manner, since when dealing with meta-transactions the account sending and
176  * paying for execution may not be the actual sender (as far as an application
177  * is concerned).
178  *
179  * This contract is only required for intermediate, library-like contracts.
180  */
181 abstract contract Context {
182     function _msgSender() internal view virtual returns (address) {
183         return msg.sender;
184     }
185 
186     function _msgData() internal view virtual returns (bytes calldata) {
187         return msg.data;
188     }
189 }
190 
191 // File: @openzeppelin/contracts/access/Ownable.sol
192 
193 
194 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 
199 /**
200  * @dev Contract module which provides a basic access control mechanism, where
201  * there is an account (an owner) that can be granted exclusive access to
202  * specific functions.
203  *
204  * By default, the owner account will be the one that deploys the contract. This
205  * can later be changed with {transferOwnership}.
206  *
207  * This module is used through inheritance. It will make available the modifier
208  * `onlyOwner`, which can be applied to your functions to restrict their use to
209  * the owner.
210  */
211 abstract contract Ownable is Context {
212     address private _owner;
213 
214     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
215 
216     /**
217      * @dev Initializes the contract setting the deployer as the initial owner.
218      */
219     constructor() {
220         _transferOwnership(_msgSender());
221     }
222 
223     /**
224      * @dev Returns the address of the current owner.
225      */
226     function owner() public view virtual returns (address) {
227         return _owner;
228     }
229 
230     /**
231      * @dev Throws if called by any account other than the owner.
232      */
233     modifier onlyOwner() {
234         require(owner() == _msgSender(), "Ownable: caller is not the owner");
235         _;
236     }
237 
238     /**
239      * @dev Leaves the contract without owner. It will not be possible to call
240      * `onlyOwner` functions anymore. Can only be called by the current owner.
241      *
242      * NOTE: Renouncing ownership will leave the contract without an owner,
243      * thereby removing any functionality that is only available to the owner.
244      */
245     function renounceOwnership() public virtual onlyOwner {
246         _transferOwnership(address(0));
247     }
248 
249     /**
250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
251      * Can only be called by the current owner.
252      */
253     function transferOwnership(address newOwner) public virtual onlyOwner {
254         require(newOwner != address(0), "Ownable: new owner is the zero address");
255         _transferOwnership(newOwner);
256     }
257 
258     /**
259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
260      * Internal function without access restriction.
261      */
262     function _transferOwnership(address newOwner) internal virtual {
263         address oldOwner = _owner;
264         _owner = newOwner;
265         emit OwnershipTransferred(oldOwner, newOwner);
266     }
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @title ERC721 token receiver interface
278  * @dev Interface for any contract that wants to support safeTransfers
279  * from ERC721 asset contracts.
280  */
281 interface IERC721Receiver {
282     /**
283      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
284      * by `operator` from `from`, this function is called.
285      *
286      * It must return its Solidity selector to confirm the token transfer.
287      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
288      *
289      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
290      */
291     function onERC721Received(
292         address operator,
293         address from,
294         uint256 tokenId,
295         bytes calldata data
296     ) external returns (bytes4);
297 }
298 
299 // File: contracts/DaycareStaking.sol
300 
301 
302 pragma solidity ^0.8.0;
303 
304 
305 
306 
307 
308 
309 contract DaycareStaking is IERC721Receiver, Ownable, ReentrancyGuard {
310 
311     event SkvllbabyCheckedIn(address owner, uint256 skvllbabyId);
312     event SkvllbabyCheckedOut(address owner, uint256 skvllbabyId);
313     event RewardCollected(address owner, uint256 skvllbabyId, uint256 amount);
314     event DaycareOpen();
315     event DaycareClosed();
316 
317     struct Skvllbaby{
318         uint256 id;
319         address owner;
320         uint256 lastClaimTimestamp;
321         uint256 accruedBalance;
322         bool staked;
323     }
324 
325     uint256 private constant REWARD_PER_DAY = 4*10**18;
326     uint256 private constant REWARD_PER_SEC = REWARD_PER_DAY / 86400;
327 
328     ISkvllbabiez private SkvllpvnkzDaycare = ISkvllbabiez(0x40BCA1edDf13b5FFA8f6f1d470cabC78Ec2FC3bb);
329     IERC20 private SkvllpvnkzTreasury = IERC20(0xBcB6112292a9EE9C9cA876E6EAB0FeE7622445F1);
330     
331     bool public isDaycareOpen = false;
332 
333     mapping(uint256 => Skvllbaby) private skvllbabiez;
334     mapping(address => uint256[]) private skvllbabiezByOwner;
335     uint256[] private checkedInList;
336     
337     modifier daycareOpen {
338         require( isDaycareOpen, "Skvllpvnkz Daycare is closed" );
339         _;
340     }
341 
342     modifier isSkvllbaby(address contractAddress) {    
343         require( contractAddress == address(SkvllpvnkzDaycare), "Not a Skvllbaby!" );
344         _;
345     }
346     
347     function onERC721Received(address, address from, uint256 skvllbabyId, bytes memory) 
348         override external daycareOpen isSkvllbaby(msg.sender) returns(bytes4) { 
349             skvllbabiezByOwner[from].push(skvllbabyId);
350             skvllbabiez[skvllbabyId] = 
351                 Skvllbaby(
352                     skvllbabyId, 
353                     from, 
354                     block.timestamp, 
355                     0, 
356                     true); 
357             emit SkvllbabyCheckedIn( from, skvllbabyId );
358             return IERC721Receiver.onERC721Received.selector;
359     }
360     
361     function checkIn(uint256[] memory skvllbabyIds) external nonReentrant {
362         for (uint256 i; i < skvllbabyIds.length; i++){
363             SkvllpvnkzDaycare.safeTransferFrom( msg.sender, address(this), skvllbabyIds[i]);
364         }
365     }
366 
367     function checkOut(uint256[] memory skvllbabyIds) public daycareOpen nonReentrant {
368         require(skvllbabyIds.length > 0, "Need to provide at least 1 id");
369         uint256 rewardTimestamp = block.timestamp;
370         for (uint256 i; i < skvllbabyIds.length; i++){
371             require(msg.sender == skvllbabiez[skvllbabyIds[i]].owner, "Not your Skvllbaby");
372             skvllbabiez[skvllbabyIds[i]].accruedBalance = _calculateRewards(skvllbabyIds[i], rewardTimestamp );
373             skvllbabiez[skvllbabyIds[i]].staked = false;
374             SkvllpvnkzDaycare.safeTransferFrom( address(this), msg.sender, skvllbabyIds[i]);
375             updateSkvllbabiezByOwner(skvllbabyIds[i]);
376             emit SkvllbabyCheckedOut(msg.sender, skvllbabyIds[i]);
377         }
378     }
379 
380     function collectRewards(uint256[] memory skvllbabyIds) public daycareOpen nonReentrant{
381         uint256 rewardTimestamp = block.timestamp;
382         uint256 rewardAmount = 0;
383         for (uint256 i; i < skvllbabyIds.length; i++){
384             if (address(this) == SkvllpvnkzDaycare.ownerOf(skvllbabyIds[i])) {
385                 rewardAmount += _calculateRewards(skvllbabyIds[i], rewardTimestamp );
386                 rewardAmount += skvllbabiez[skvllbabyIds[i]].accruedBalance;             
387             } else {
388                 require(msg.sender == SkvllpvnkzDaycare.ownerOf(skvllbabyIds[i]), "Not your Skvllbaby");
389                 rewardAmount += skvllbabiez[skvllbabyIds[i]].accruedBalance;
390             }
391             skvllbabiez[skvllbabyIds[i]].accruedBalance = 0;
392             skvllbabiez[skvllbabyIds[i]].lastClaimTimestamp = rewardTimestamp;
393             emit RewardCollected(msg.sender, skvllbabyIds[i], rewardAmount);
394         }
395         _releasePayment(rewardAmount);
396     }
397 
398     function _calculateRewards(uint256 skvllbabyId, uint256 currentTime ) internal view returns (uint256){
399         return (currentTime - skvllbabiez[skvllbabyId].lastClaimTimestamp) * REWARD_PER_SEC;
400     }
401 
402     function _releasePayment(uint256 rewardAmount) internal {
403         require(rewardAmount > 0, "Nothing to collect");
404         require(SkvllpvnkzTreasury.balanceOf(address(this)) >= rewardAmount, "Not enough AMMO");
405         SkvllpvnkzTreasury.approve(address(this), rewardAmount); 
406         SkvllpvnkzTreasury.transfer(msg.sender, rewardAmount);
407     }
408     
409     function getSkvllbabyReport(uint256 skvllbabyId) public view returns (Skvllbaby memory ){
410         bool staked = address(this) == SkvllpvnkzDaycare.ownerOf(skvllbabyId);
411         return Skvllbaby(
412                     skvllbabyId,
413                     staked ? skvllbabiez[skvllbabyId].owner : SkvllpvnkzDaycare.ownerOf(skvllbabyId), 
414                     skvllbabiez[skvllbabyId].lastClaimTimestamp, 
415                     staked ? _calculateRewards(skvllbabyId, block.timestamp) : skvllbabiez[skvllbabyId].accruedBalance,
416                     staked);
417         
418     }
419 
420     function getWalletReport(address wallet) external view returns(Skvllbaby[] memory ){
421         uint256[] memory stakedIds = skvllbabiezByOwner[ wallet ];
422         uint256[] memory unstakedIds = SkvllpvnkzDaycare.walletOfOwner(wallet);
423         uint256[] memory ids = _concatArrays(stakedIds, unstakedIds);
424         require(ids.length > 0, "Wallet has no babiez");
425         Skvllbaby[] memory babiez = new Skvllbaby[](ids.length);
426         for (uint256 i; i < ids.length; i++){
427             babiez[i] = getSkvllbabyReport(ids[i]);
428         }
429         return babiez;
430         
431     }
432 
433     function getBatchPendingRewards(uint64[] memory tokenIds) external view returns(Skvllbaby[] memory) {
434         Skvllbaby[] memory allRewards = new Skvllbaby[](tokenIds.length);
435         for (uint64 i = 0; i < tokenIds.length; i++){
436             allRewards[i] = getSkvllbabyReport(tokenIds[i]);
437         }
438         return allRewards;
439     }
440 
441     function _concatArrays(uint256[] memory ids, uint256[] memory ids2) internal pure returns(uint256[] memory) {
442         uint256[] memory returnArr = new uint256[](ids.length + ids2.length);
443 
444         uint i=0;
445         for (; i < ids.length; i++) {
446             returnArr[i] = ids[i];
447         }
448 
449         uint j=0;
450         while (j < ids2.length) {
451             returnArr[i++] = ids2[j++];
452         }
453 
454         return returnArr;
455     }
456 
457     function updateSkvllbabiezByOwner(uint256 skvllbabyId) internal {
458         if (skvllbabiezByOwner[msg.sender].length == 1) {
459             delete skvllbabiezByOwner[msg.sender];
460         } else {
461             for (uint256 i; i < skvllbabiezByOwner[msg.sender].length; i++){
462                 if (skvllbabiezByOwner[msg.sender][i] == skvllbabyId) {
463                     skvllbabiezByOwner[msg.sender][i] = skvllbabiezByOwner[msg.sender][skvllbabiezByOwner[msg.sender].length - 1];
464                     skvllbabiezByOwner[msg.sender].pop();
465                 }
466             }
467         }
468     }
469 
470     function isSkvllbabyCheckedIn (uint256 skvllbabyId) external view returns (bool){
471         return SkvllpvnkzDaycare.ownerOf(skvllbabyId) == address(this) ? true : false;
472     }
473 
474     function openCloseDaycare() external onlyOwner {
475         isDaycareOpen = !isDaycareOpen;
476     }
477 
478     function withdraw(uint256 amount) external payable onlyOwner {
479         require(payable(msg.sender).send(amount), "Payment failed");
480     }
481 
482     function setTreasuryContract(address skvllpvnkzTreasury) external onlyOwner {
483         SkvllpvnkzTreasury = IERC20(skvllpvnkzTreasury);
484     }
485 
486     function setSkvllbabiezContract(address skvllpvnkzDaycare) external onlyOwner {
487         SkvllpvnkzDaycare = ISkvllbabiez(skvllpvnkzDaycare);
488     }
489 }