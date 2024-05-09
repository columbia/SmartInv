1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 pragma solidity ^0.8.0;
5 
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55 /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         return msg.data;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/access/Ownable.sol
104 
105 
106 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 abstract contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor() {
132         _transferOwnership(_msgSender());
133     }
134 
135     /**
136      * @dev Returns the address of the current owner.
137      */
138     function owner() public view virtual returns (address) {
139         return _owner;
140     }
141 
142     /**
143      * @dev Throws if called by any account other than the owner.
144      */
145     modifier onlyOwner() {
146         require(owner() == _msgSender(), "Ownable: caller is not the owner");
147         _;
148     }
149 
150     /**
151      * @dev Leaves the contract without owner. It will not be possible to call
152      * `onlyOwner` functions anymore. Can only be called by the current owner.
153      *
154      * NOTE: Renouncing ownership will leave the contract without an owner,
155      * thereby removing any functionality that is only available to the owner.
156      */
157     function renounceOwnership() public virtual onlyOwner {
158         _transferOwnership(address(0));
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Can only be called by the current owner.
164      */
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         _transferOwnership(newOwner);
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Internal function without access restriction.
173      */
174     function _transferOwnership(address newOwner) internal virtual {
175         address oldOwner = _owner;
176         _owner = newOwner;
177         emit OwnershipTransferred(oldOwner, newOwner);
178     }
179 }
180 
181 
182 /**
183  * @dev Interface of the ERC165 standard, as defined in the
184  * https://eips.ethereum.org/EIPS/eip-165[EIP].
185  *
186  * Implementers can declare support of contract interfaces, which can then be
187  * queried by others ({ERC165Checker}).
188  *
189  * For an implementation, see {ERC165}.
190  */
191 interface IERC165 {
192     /**
193      * @dev Returns true if this contract implements the interface defined by
194      * `interfaceId`. See the corresponding
195      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
196      * to learn more about how these ids are created.
197      *
198      * This function call must use less than 30 000 gas.
199      */
200     function supportsInterface(bytes4 interfaceId) external view returns (bool);
201 }
202 
203 /**
204  * @dev Required interface of an ERC721 compliant contract.
205  */
206 interface IERC721 is IERC165 {
207     /**
208      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
209      */
210     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
211 
212     /**
213      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
214      */
215     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
216 
217     /**
218      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
219      */
220     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
221 
222     /**
223      * @dev Returns the number of tokens in ``owner``'s account.
224      */
225     function balanceOf(address owner) external view returns (uint256 balance);
226 
227     /**
228      * @dev Returns the owner of the `tokenId` token.
229      *
230      * Requirements:
231      *
232      * - `tokenId` must exist.
233      */
234     function ownerOf(uint256 tokenId) external view returns (address owner);
235 
236     /**
237      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
238      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
239      *
240      * Requirements:
241      *
242      * - `from` cannot be the zero address.
243      * - `to` cannot be the zero address.
244      * - `tokenId` token must exist and be owned by `from`.
245      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
246      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
247      *
248      * Emits a {Transfer} event.
249      */
250     function safeTransferFrom(
251         address from,
252         address to,
253         uint256 tokenId
254     ) external;
255 
256     /**
257      * @dev Transfers `tokenId` token from `from` to `to`.
258      *
259      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
260      *
261      * Requirements:
262      *
263      * - `from` cannot be the zero address.
264      * - `to` cannot be the zero address.
265      * - `tokenId` token must be owned by `from`.
266      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
267      *
268      * Emits a {Transfer} event.
269      */
270     function transferFrom(
271         address from,
272         address to,
273         uint256 tokenId
274     ) external;
275 
276     /**
277      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
278      * The approval is cleared when the token is transferred.
279      *
280      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
281      *
282      * Requirements:
283      *
284      * - The caller must own the token or be an approved operator.
285      * - `tokenId` must exist.
286      *
287      * Emits an {Approval} event.
288      */
289     function approve(address to, uint256 tokenId) external;
290 
291     /**
292      * @dev Returns the account approved for `tokenId` token.
293      *
294      * Requirements:
295      *
296      * - `tokenId` must exist.
297      */
298     function getApproved(uint256 tokenId) external view returns (address operator);
299 
300     /**
301      * @dev Approve or remove `operator` as an operator for the caller.
302      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
303      *
304      * Requirements:
305      *
306      * - The `operator` cannot be the caller.
307      *
308      * Emits an {ApprovalForAll} event.
309      */
310     function setApprovalForAll(address operator, bool _approved) external;
311 
312     /**
313      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
314      *
315      * See {setApprovalForAll}
316      */
317     function isApprovedForAll(address owner, address operator) external view returns (bool);
318 
319     /**
320      * @dev Safely transfers `tokenId` token from `from` to `to`.
321      *
322      * Requirements:
323      *
324      * - `from` cannot be the zero address.
325      * - `to` cannot be the zero address.
326      * - `tokenId` token must exist and be owned by `from`.
327      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
328      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
329      *
330      * Emits a {Transfer} event.
331      */
332     function safeTransferFrom(
333         address from,
334         address to,
335         uint256 tokenId,
336         bytes calldata data
337     ) external;
338 }
339 
340 interface IERC721Enumerable is IERC721 {
341     /**
342      * @dev Returns the total amount of tokens stored by the contract.
343      */
344     function totalSupply() external view returns (uint256);
345 
346     /**
347      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
348      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
349      */
350     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
351 
352     /**
353      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
354      * Use along with {totalSupply} to enumerate all tokens.
355      */
356     function tokenByIndex(uint256 index) external view returns (uint256);
357 }
358 
359 
360 contract StakingPool is Ownable{
361     //last time that tokens where retrieved
362     mapping(uint => uint256) public checkpoints;
363 
364     //see how many nfts are being staked
365     mapping(address => uint256[]) public stakedTokens;
366 
367     IERC721Enumerable public NFTCollection;
368     IERC20 public Token;
369 
370     uint public rewardPerDayBronze = 100000000000000000;
371     uint public rewardPerDaySilver = 200000000000000000;
372     uint public rewardPerDayGold = 300000000000000000;
373     uint public rewardPerDayPlatinum = 400000000000000000;
374 
375     //dummy address that we use to sign the withdraw transaction to verify the type of nft
376     address private dummy = address(0xc0A7Ee1ABb27c81ae51d9720a208B80881617e44);
377 
378     uint[] private tids;
379 
380     mapping(address => uint256) private balances;
381 
382     constructor() {
383         NFTCollection = IERC721Enumerable(0xB62E63c57d63f0812D5f2f583B733e3C5e6848f8);
384         Token = IERC20(0x5e4Efb364071C64Ee3641fe1E68cB5d2D5558709);
385     }
386 
387     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) {
388         require( isValidAccessMessage(msg.sender,_v,_r,_s), 'Invalid Signature' );
389         _;
390     }
391 
392     //set ERC721Enumerable
393     function setNFTInterface(address newInterface) public onlyOwner {
394         NFTCollection = IERC721Enumerable(newInterface);
395     }
396 
397     //set ERC20
398     function setTokenInterface(address newInterface) public onlyOwner {
399         Token = IERC20(newInterface);
400     }
401  
402     /* 
403     * @dev Verifies if message was signed by owner to give access to _add for this contract.
404     *      Assumes Geth signature prefix.
405     * @param _add Address of agent with access
406     * @param _v ECDSA signature parameter v.
407     * @param _r ECDSA signature parameters r.
408     * @param _s ECDSA signature parameters s.
409     * @return Validity of access message for a given address.
410     */
411     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s) view public returns (bool) {
412         bytes32 hash = keccak256(abi.encodePacked(address(this), _add));
413         return dummy == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s);
414     }
415 
416     function depositAll() external {
417         uint balance = NFTCollection.balanceOf(msg.sender);
418         require(balance > 0, "No tokens to stake!");
419 
420         delete tids;
421         for (uint i = 0; i < balance; i++) {
422             tids.push(NFTCollection.tokenOfOwnerByIndex(msg.sender, i));
423         }
424         for (uint i = 0; i < tids.length; i++) {
425             _deposit(tids[i]);
426         }
427         
428     }
429 
430     function deposit(uint tokenId) public {
431         //they have to be the owner of tokenID
432         require(msg.sender == NFTCollection.ownerOf(tokenId), 'Sender must be owner');
433         _deposit(tokenId);
434         
435     }
436 
437     function _deposit(uint tokenId) internal {
438         //set the time of staking to now
439         checkpoints[tokenId] = block.timestamp;
440 
441         //transfer NFT to contract
442         NFTCollection.transferFrom(msg.sender, address(this), tokenId);
443 
444         //add to their staked tokens
445         stakedTokens[msg.sender].push(tokenId);
446     }
447 
448     function withdrawAll(uint[] memory types_, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) external {
449         getAllRewards(types_, _v, _r, _s);
450 
451         for (uint i = 0; i < stakedTokens[msg.sender].length; i++) {
452             NFTCollection.transferFrom(address(this), msg.sender, stakedTokens[msg.sender][i]);
453             //popFromStakedTokens(stakedTokens[msg.sender][i]);
454             checkpoints[stakedTokens[msg.sender][i]] = block.timestamp; 
455         }
456         delete stakedTokens[msg.sender];
457     }
458 
459     function emergencyWithdrawAll() external {
460         require(stakedTokens[msg.sender].length > 0, "No tokens staked");
461         for (uint i = 0; i < stakedTokens[msg.sender].length; i++) {
462             NFTCollection.transferFrom(address(this), msg.sender, stakedTokens[msg.sender][i]);
463             //popFromStakedTokens(stakedTokens[msg.sender][i]);
464             checkpoints[stakedTokens[msg.sender][i]] = block.timestamp; 
465         }
466         delete stakedTokens[msg.sender];
467     }
468 
469     function withdraw(uint tokenId, uint type_, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s)  public {
470         bool check = false;
471         for (uint i = 0; i < stakedTokens[msg.sender].length; i++) {
472             if (stakedTokens[msg.sender][i] == tokenId) {
473                 check = true;
474                 break;
475             }
476         }
477         require(check == true, 'You have not staked this token!');
478 
479         _withdraw(tokenId, type_);
480         popFromStakedTokens(tokenId);
481         
482     }
483 
484     function emergencyWithdraw(uint tokenId) external {
485         bool check = false;
486         for (uint i = 0; i < stakedTokens[msg.sender].length; i++) {
487             if (stakedTokens[msg.sender][i] == tokenId) {
488                 check = true;
489                 break;
490             }
491         }
492         require(check == true, 'You have not staked this token!');
493 
494         NFTCollection.transferFrom(address(this), msg.sender, tokenId);
495         popFromStakedTokens(tokenId);
496         checkpoints[tokenId] = block.timestamp; 
497     }
498 
499     function popFromStakedTokens(uint tokenId) internal {
500         uint pos = positionInStakedTokens(tokenId);
501         
502         uint firstValue = stakedTokens[msg.sender][pos];
503         uint secondValue = stakedTokens[msg.sender][stakedTokens[msg.sender].length - 1];
504         stakedTokens[msg.sender][pos] = secondValue;
505         stakedTokens[msg.sender][stakedTokens[msg.sender].length - 1] = firstValue;
506         stakedTokens[msg.sender].pop();
507     }
508 
509     function positionInStakedTokens(uint tokenId) internal view returns(uint) {
510         uint index;
511         for (uint i = 0; i < stakedTokens[msg.sender].length; i++) {
512             if (stakedTokens[msg.sender][i] == tokenId) {
513                 index = i;
514                 break;
515             }
516         }
517         return index;
518     }
519 
520     function _withdraw(uint tokenId, uint type_) internal {
521         collect(tokenId, type_);
522         NFTCollection.transferFrom(address(this), msg.sender, tokenId);
523     }
524 
525     function getReward(uint tokenId, uint type_, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) public {
526         bool check = false;
527         for (uint i = 0; i < stakedTokens[msg.sender].length; i++) {
528             if (stakedTokens[msg.sender][i] == tokenId) {
529                 check = true;
530                 break;
531             }
532         }
533         require(check == true, 'You have not staked this token!');
534 
535         collect(tokenId, type_);
536     }
537 
538     function getAllRewards(uint[] memory types_, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) public {
539         require(stakedTokens[msg.sender].length > 0, "No tokens staked");
540         require(types_.length == stakedTokens[msg.sender].length, "Types and Tokens Staked do not match!");
541 
542         uint rewards = 0;
543         for (uint i = 0; i < types_.length; i++) {
544             rewards += calculateReward(stakedTokens[msg.sender][i], types_[i]);
545             checkpoints[stakedTokens[msg.sender][i]] = block.timestamp;
546         }
547 
548         require(rewards <= Token.balanceOf(address(this)), "Staking Contract does not have sufficient funds");
549         Token.transfer(msg.sender, rewards);
550     }
551 
552 
553     function collect(uint tokenId, uint type_) internal {
554         uint256 reward = calculateReward(tokenId, type_);     
555         //_mint(msg.sender, reward);
556         require(reward <= Token.balanceOf(address(this)), "Staking Contract does not have sufficient funds");
557         Token.transfer(msg.sender, reward);
558 
559         checkpoints[tokenId] = block.timestamp; 
560     }
561 
562     function calculateAllRewards(uint[] memory types_, address who) public view returns(uint256) {
563         require(stakedTokens[who].length > 0, "No tokens staked");
564         require(types_.length == stakedTokens[who].length, "Types and Tokens Staked do not match!");
565 
566         uint256 total;
567         for (uint i = 0; i < types_.length; i++) {
568             total += calculateReward(stakedTokens[who][i], types_[i]);
569         }
570         return total;
571     }
572 
573     function calculateReward(uint tokenId, uint type_) public view returns(uint256) {
574         require(type_ >= 0 && type_ < 5, "Invalid Type of Token!");
575         uint256 checkpoint = checkpoints[tokenId];
576 
577         if (type_ == 0) {
578             return 0;
579         }
580         else if (type_ == 1) {
581             return rewardPerDayBronze * ((block.timestamp-checkpoint) / 86400);
582         }
583         else if (type_ == 2) {
584             return rewardPerDaySilver * ((block.timestamp-checkpoint) / 86400);
585         }
586         else if (type_ == 3) {
587             return rewardPerDayGold * ((block.timestamp-checkpoint) / 86400);
588         }
589         else {
590             return rewardPerDayPlatinum * ((block.timestamp-checkpoint) / 86400);
591         }
592         
593     }
594 
595 
596 
597     function seeStakedTokens(address who) public view returns(uint256[] memory) {
598         return stakedTokens[who];
599     }
600 
601     function withdrawKatsumi() external onlyOwner {
602         uint256 balance = Token.balanceOf(address(this));
603         require(balance > 0, "No tokens to withdraw!");
604         Token.transfer(msg.sender, balance);
605     }
606     
607 }