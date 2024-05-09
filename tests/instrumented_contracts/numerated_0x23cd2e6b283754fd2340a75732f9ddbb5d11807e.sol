1 // Copyright (c) 2022 EverRise Pte Ltd. All rights reserved.
2 // EverRise licenses this file to you under the MIT license.
3 /*
4  EverRise Staking NFTs are containers of Vote Escrowed (ve)EverRise 
5  weighted governance tokens. veRISE generates rewards from the 
6  auto-buyback with a market driven yield curve, based on the transaction
7  volume of EverRise trades and veEverRise sales.
8 
9  On sales of nftEverRise Staking NFTs a 10% royalty fee is collected:
10 
11  * 6% for token auto-buyback from the market, with bought back tokens
12       directly distributed as ve-staking rewards
13  * 4% for Business Development (Development, Sustainability and Marketing)
14 
15                            ________                              _______   __
16                           /        |                            /       \ /  |
17                           $$$$$$$$/__     __  ______    ______  $$$$$$$  |$$/   _______   ______  v3.14159265
18                           $$ |__  /  \   /  |/      \  /      \ $$ |__$$ |/  | /       | /      \
19                           $$    | $$  \ /$$//$$$$$$  |/$$$$$$  |$$    $$< $$ |/$$$$$$$/ /$$$$$$  |
20  _______ _______ _______  $$$$$/   $$  /$$/ $$    $$ |$$ |  $$/ $$$$$$$  |$$ |$$      \ $$    $$ |
21 |    |  |    ___|_     _| $$ |_____ $$ $$/  $$$$$$$$/ $$ |      $$ |  $$ |$$ | $$$$$$  |$$$$$$$$/
22 |       |    ___| |   |   $$       | $$$/   $$       |$$ |      $$ |  $$ |$$ |/     $$/ $$       |
23 |__|____|___|     |___|   $$$$$$$$/   $/     $$$$$$$/ $$/       $$/   $$/ $$/ $$$$$$$/   $$$$$$$/ Magnum opus
24 
25 Learn more about EverRise and the EverRise Ecosystem of dApps and
26 how our utilities and partners can help protect your investors
27 and help your project grow: https://everrise.com
28 */
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity 0.8.13;
33 
34 error NotZeroAddress();                    // 0x66385fa3
35 error CallerNotApproved();                 // 0x4014f1a5
36 error InvalidAddress();                    // 0xe6c4247b
37 error CallerNotOwner();
38 error WalletLocked();                      // 0xd550ed24
39 error DoesNotExist();                      // 0xb0ce7591
40 error AmountMustBeGreaterThanZero();       // 0x5e85ae73
41 error AmountOutOfRange();                  // 0xc64200e9
42 error StakeStillLocked();                  // 0x7f6699f6
43 error NotStakerAddress();                  // 0x2a310a0c
44 error AmountLargerThanAvailable();         // 0xbb296109
45 error StakeCanOnlyBeExtended();            // 0x73f7040a
46 error ArrayLengthsMismatch();              // 0x3b800a46
47 error NotSetup();                          // 0xb09c99c0
48 error NotAllowedToCreateRewards();         // 0xfdc42f29
49 error NotAllowedToDeliverRewards();        // 0x69a3e246
50 error ERC721ReceiverReject();              // 0xfa34343f
51 error ERC721ReceiverNotImplemented();      // 0xa89c6c0d
52 error NotEnoughToCoverStakeFee();          // 0x627554ed
53 error AmountLargerThanAllowance();         // 0x9b144c57
54 error AchievementNotClaimed();             // 0x3834dd9c
55 error AchievementAlreadyClaimed();         // 0x2d5345f4
56 error AmountMustBeAnInteger();             // 0x743aec61
57 error BrokenStatusesDiffer();              // 0x097b027d
58 error AchievementClaimStatusesDiffer();    // 0x6524e8b0
59 error UnlockedStakesMustBeSametimePeriod();// 0x42e227b0
60 error CannotMergeLockedAndUnlockedStakes();// 0x9efeef2c
61 error StakeUnlocked();                     // 0x6717a455
62 error NoRewardsToClaim();                  // 0x73380d99
63 error NotTransferrable();                  // 0x54ee5151
64 error Overflow();                          // 0x35278d12
65 error MergeNotEnabled();                   // 0x
66 
67 // File: EverRise-v3/Interfaces/IERC173-Ownable.sol
68 
69 interface IOwnable {
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71     function owner() external view returns (address);
72     function transferOwnership(address newOwner) external;
73 }
74 
75 // File: EverRise-v3/Abstract/Context.sol
76 
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address payable) {
79         return payable(msg.sender);
80     }
81 }
82 
83 // File: EverRise-v3/Abstract/ERC173-Ownable.sol
84 
85 contract Ownable is IOwnable, Context {
86     address public owner;
87 
88     function _onlyOwner() private view {
89         if (owner != _msgSender()) revert CallerNotOwner();
90     }
91 
92     modifier onlyOwner() {
93         _onlyOwner();
94         _;
95     }
96 
97     constructor() {
98         address msgSender = _msgSender();
99         owner = msgSender;
100         emit OwnershipTransferred(address(0), msgSender);
101     }
102 
103     // Allow contract ownership and access to contract onlyOwner functions
104     // to be locked using EverOwn with control gated by community vote.
105     //
106     // EverRise ($RISE) stakers become voting members of the
107     // decentralized autonomous organization (DAO) that controls access
108     // to the token contract via the EverRise Ecosystem dApp EverOwn
109     function transferOwnership(address newOwner) external virtual onlyOwner {
110         if (newOwner == address(0)) revert NotZeroAddress();
111 
112         emit OwnershipTransferred(owner, newOwner);
113         owner = newOwner;
114     }
115 }
116 
117 struct ApprovalChecks {
118     // Prevent permits being reused (IERC2612)
119     uint64 nonce;
120     // Allow revoke all spenders/operators approvals in single txn
121     uint32 nftCheck;
122     uint32 tokenCheck;
123     // Allow auto timeout on approvals
124     uint16 autoRevokeNftHours;
125     uint16 autoRevokeTokenHours;
126     // Allow full wallet locking of all transfers
127     uint48 unlockTimestamp;
128 }
129 
130 struct Allowance {
131     uint128 tokenAmount;
132     uint32 nftCheck;
133     uint32 tokenCheck;
134     uint48 timestamp;
135     uint8 nftApproval;
136     uint8 tokenApproval;
137 }
138 
139 interface IEverRiseWallet {
140     event RevokeAllApprovals(address indexed account, bool tokens, bool nfts);
141     event SetApprovalAutoTimeout(address indexed account, uint16 tokensHrs, uint16 nftsHrs);
142     event LockWallet(address indexed account, address altAccount, uint256 length);
143     event LockWalletExtend(address indexed account, uint256 length);
144 }
145 
146 // File: EverRise-v3/Interfaces/IERC20-Token.sol
147 
148 interface IERC20 {
149     event Transfer(address indexed from, address indexed to, uint256 value);
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151     function totalSupply() external view returns (uint256);
152     function balanceOf(address account) external view returns (uint256);
153     function transfer(address recipient, uint256 amount) external returns (bool);
154     function allowance(address owner, address spender) external view returns (uint256);
155     function approve(address spender, uint256 amount) external returns (bool);
156     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
157     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
158     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
159     function transferFromWithPermit(address sender, address recipient, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
160 }
161 
162 interface IERC20Metadata is IERC20 {
163     function name() external view returns (string memory);
164     function symbol() external view returns (string memory);
165     function decimals() external view returns (uint8);
166 }
167 
168 // File: EverRise-v3/Interfaces/IEverRise.sol
169 
170 interface IEverRise is IERC20Metadata {
171     function totalBuyVolume() external view returns (uint256);
172     function totalSellVolume() external view returns (uint256);
173     function holders() external view returns (uint256);
174     function uniswapV2Pair() external view returns (address);
175     function transferStake(address fromAddress, address toAddress, uint96 amountToTransfer) external;
176     function isWalletLocked(address fromAddress) external view returns (bool);
177     function setApprovalForAll(address fromAddress, address operator, bool approved) external;
178     function isApprovedForAll(address account, address operator) external view returns (bool);
179     function isExcludedFromFee(address account) external view returns (bool);
180 
181     function approvals(address operator) external view returns (ApprovalChecks memory);
182 }
183 
184 
185 // File: EverRise-v3/Interfaces/IERC721-Nft.sol
186 
187 interface IERC721 /* is ERC165 */ {
188     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
189     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
190     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
191     function balanceOf(address _owner) external view returns (uint256);
192     function ownerOf(uint256 _tokenId) external view returns (address);
193     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
194     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
195     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
196     function approve(address _approved, uint256 _tokenId) external payable;
197     function setApprovalForAll(address _operator, bool _approved) external;
198     function getApproved(uint256 _tokenId) external view returns (address);
199     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
200 }
201 
202 // File: EverRise-v3/Interfaces/InftEverRise.sol
203 
204 struct StakingDetails {
205     uint96 initialTokenAmount;    // Max 79 Bn tokens
206     uint96 withdrawnAmount;       // Max 79 Bn tokens
207     uint48 depositTime;           // 8 M years
208     uint8 numOfMonths;            // Max 256 month period
209     uint8 achievementClaimed;
210     // 256 bits, 20000 gwei gas
211     address stakerAddress;        // 160 bits (96 bits remaining)
212     uint32 nftId;                 // Max 4 Bn nfts issued
213     uint32 lookupIndex;           // Max 4 Bn active stakes
214     uint24 stakerIndex;           // Max 16 M active stakes per wallet
215     uint8 isActive;
216     // 256 bits, 20000 gwei gas
217 } // Total 768 bits, 40000 gwei gas
218 
219 interface InftEverRise is IERC721 {
220     function voteEscrowedBalance(address account) external view returns (uint256);
221     function unclaimedRewardsBalance(address account) external view returns (uint256);
222     function totalAmountEscrowed() external view returns (uint256);
223     function totalAmountVoteEscrowed() external view returns (uint256);
224     function totalRewardsDistributed() external view returns (uint256);
225     function totalRewardsUnclaimed() external view returns (uint256);
226 
227     function createRewards(uint256 tAmount) external;
228 
229     function getNftData(uint256 id) external view returns (StakingDetails memory);
230     function enterStaking(address fromAddress, uint96 amount, uint8 numOfMonths) external returns (uint32 nftId);
231     function leaveStaking(address fromAddress, uint256 id, bool overrideNotClaimed) external returns (uint96 amount);
232     function earlyWithdraw(address fromAddress, uint256 id, uint96 amount) external returns (uint32 newNftId, uint96 penaltyAmount);
233     function withdraw(address fromAddress, uint256 id, uint96 amount, bool overrideNotClaimed) external returns (uint32 newNftId);
234     function bridgeStakeNftOut(address fromAddress, uint256 id) external returns (uint96 amount);
235     function bridgeOrAirdropStakeNftIn(address toAddress, uint96 depositAmount, uint8 numOfMonths, uint48 depositTime, uint96 withdrawnAmount, uint96 rewards, bool achievementClaimed) external returns (uint32 nftId);
236     function addStaker(address staker, uint256 nftId) external;
237     function removeStaker(address staker, uint256 nftId) external;
238     function reissueStakeNft(address staker, uint256 oldNftId, uint256 newNftId) external;
239     function increaseStake(address staker, uint256 nftId, uint96 amount) external returns (uint32 newNftId, uint96 original, uint8 numOfMonths);
240     function splitStake(uint256 id, uint96 amount) external payable returns (uint32 newNftId0, uint32 newNftId1);
241     function claimAchievement(address staker, uint256 nftId) external returns (uint32 newNftId);
242     function stakeCreateCost() external view returns (uint256);
243     function approve(address owner, address _operator, uint256 nftId) external;
244 }
245 
246 // File: EverRise-v3/Abstract/virtualToken.sol
247 
248 abstract contract virtualToken is Ownable, IERC20, IERC20Metadata {
249     InftEverRise public veEverRise;
250 
251     uint8 public constant decimals = 18;
252     string public name;
253     string public symbol;
254   
255     constructor(string memory _name, string memory _symbol ) {
256         name = _name;
257         symbol = _symbol;
258         veEverRise = InftEverRise(owner);
259     }
260 
261     function transferFrom(address sender, address recipient, uint256 amount)
262         external returns (bool) {
263         
264         if (_msgSender() != owner) { 
265             notTransferrable();
266         }
267 
268         emit Transfer(sender, recipient, amount);
269         return true;
270     }
271 
272     function transfer(address, uint256) pure external returns (bool) {
273         notTransferrable();
274     }
275     function allowance(address, address) pure external returns (uint256) {
276         return 0;
277     }
278     function approve(address, uint256) pure external returns (bool) {
279         notTransferrable();
280     }
281     function increaseAllowance(address, uint256) pure external returns (bool) {
282         notTransferrable();
283     }
284     function decreaseAllowance(address, uint256) pure external returns (bool) {
285         notTransferrable();
286     }
287     function transferFromWithPermit(address, address, uint256, uint256, uint8, bytes32, bytes32) pure external returns (bool) {
288         notTransferrable();
289     }
290 
291     function notTransferrable() pure private {
292         revert NotTransferrable();
293     }
294 }
295 // File: EverRise-v3/claimRISE.sol
296 
297 // Copyright (c) 2022 EverRise Pte Ltd. All rights reserved.
298 // EverRise licenses this file to you under the MIT license.
299 /*
300  Virtual token that allows unclaimed rewards from EverRise Staking NFTs
301  and its Vote Escrowed (ve) EverRise to display in wallet balances.
302                                     ________                              _______   __
303                                    /        |                            /       \ /  |
304                                    $$$$$$$$/__     __  ______    ______  $$$$$$$  |$$/   _______   ______  v3.14159265
305                                    $$ |__  /  \   /  |/      \  /      \ $$ |__$$ |/  | /       | /      \
306       ______      _____            $$    | $$  \ /$$//$$$$$$  |/$$$$$$  |$$    $$< $$ |/$$$$$$$/ /$$$$$$  |
307 _________  /_____ ___(_)______ ___ $$$$$/   $$  /$$/ $$    $$ |$$ |  $$/ $$$$$$$  |$$ |$$      \ $$    $$ |
308 _  ___/_  /_  __ `/_  /__  __ `__ \$$ |_____ $$ $$/  $$$$$$$$/ $$ |      $$ |  $$ |$$ | $$$$$$  |$$$$$$$$/
309 / /__ _  / / /_/ /_  / _  / / / / /$$       | $$$/   $$       |$$ |      $$ |  $$ |$$ |/     $$/ $$       |
310 \___/ /_/  \__,_/ /_/  /_/ /_/ /_/ $$$$$$$$/   $/     $$$$$$$/ $$/       $$/   $$/ $$/ $$$$$$$/   $$$$$$$/
311 
312 Learn more about EverRise and the EverRise Ecosystem of dApps and
313 how our utilities and partners can help protect your investors
314 and help your project grow: https://www.everrise.com
315 */
316 
317 contract claimRise is virtualToken("EverRise Rewards", "claimRISE") {
318     function totalSupply() override external view returns (uint256) {
319         return veEverRise.totalRewardsUnclaimed();
320     }
321 
322     function balanceOf(address account) override external view returns (uint256) {
323         if (account == owner) return 0;
324         
325         return veEverRise.unclaimedRewardsBalance(account);
326     }
327 }
328 // File: EverRise-v3/veRISE.sol
329 
330 // Copyright (c) 2022 EverRise Pte Ltd. All rights reserved.
331 // EverRise licenses this file to you under the MIT license.
332 /*
333  Virtual token that allows the Vote Escrowed (ve) EverRise weigthed
334  governance tokens from EverRise Staking NFTs to display in
335  wallet balances.
336  
337              ________                              _______   __
338             /        |                            /       \ /  |
339             $$$$$$$$/__     __  ______    ______  $$$$$$$  |$$/   _______   ______  v3.14159265
340             $$ |__  /  \   /  |/      \  /      \ $$ |__$$ |/  | /       | /      \
341             $$    | $$  \ /$$//$$$$$$  |/$$$$$$  |$$    $$< $$ |/$$$$$$$/ /$$$$$$  |
342 __   _____  $$$$$/   $$  /$$/ $$    $$ |$$ |  $$/ $$$$$$$  |$$ |$$      \ $$    $$ |
343 \ \ / / _ \ $$ |_____ $$ $$/  $$$$$$$$/ $$ |      $$ |  $$ |$$ | $$$$$$  |$$$$$$$$/
344  \ V /  __/ $$       | $$$/   $$       |$$ |      $$ |  $$ |$$ |/     $$/ $$       |
345   \_/ \___| $$$$$$$$/   $/     $$$$$$$/ $$/       $$/   $$/ $$/ $$$$$$$/   $$$$$$$/
346 
347 Learn more about EverRise and the EverRise Ecosystem of dApps and
348 how our utilities and partners can help protect your investors
349 and help your project grow: https://www.everrise.com
350 */
351 
352 contract veRise is virtualToken("Vote-escrowed EverRise", "veRISE") {
353     function totalSupply() override external view returns (uint256) {
354         return veEverRise.totalAmountVoteEscrowed();
355     }
356 
357     function balanceOf(address account) override external view returns (uint256) {
358         if (account == owner) return 0;
359 
360         return veEverRise.voteEscrowedBalance(account);
361     }
362 }
363 
364 // File: EverRise-v3/Interfaces/IEverRoyaltySplitter.sol
365 
366 interface IEverRoyaltySplitter {
367     event RoyaltiesSplit(uint256 value);
368     event SplitUpdated(uint256 previous, uint256 current);
369     event UniswapV2RouterSet(address indexed previous, address indexed current);
370     event EverRiseEcosystemSet(address indexed previous, address indexed current);
371     event EverRiseTokenSet(address indexed previous, address indexed current);
372     event StableCoinSet(address indexed previous, address indexed current);
373 
374     function distribute() external;
375 }
376 
377 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
378 interface IERC721TokenReceiver {
379     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external view returns(bytes4);
380 }
381 
382 interface IERC721Metadata /* is ERC721 */ {
383     function name() external view returns (string memory _name);
384     function symbol() external view returns (string memory _symbol);
385     function tokenURI(uint256 _tokenId) external view returns (string memory);
386 }
387 
388 interface IERC721Enumerable /* is ERC721 */ {
389     function totalSupply() external view returns (uint256);
390     function tokenByIndex(uint256 _index) external view returns (uint256);
391     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
392 }
393 
394 // File: EverRise-v3/Interfaces/IEverRiseRenderer.sol
395 
396 interface IOpenSeaCollectible {
397     function contractURI() external view returns (string memory);
398 }
399 
400 interface IEverRiseRenderer is IOpenSeaCollectible {
401     event SetEverRiseNftStakes(address indexed addressStakes);
402     event SetEverRiseRendererGlyph(address indexed addressGlyphs);
403     
404     function tokenURI(uint256 _tokenId) external view returns (string memory);
405 
406     function everRiseNftStakes() external view returns (InftEverRise);
407     function setEverRiseNftStakes(address contractAddress) external;
408 }
409 
410 // File: EverRise-v3/Interfaces/IERC165-SupportsInterface.sol
411 
412 interface IERC165 {
413     function supportsInterface(bytes4 interfaceId) external view returns (bool);
414 }
415 // File: EverRise-v3/Abstract/ERC165-SupportsInterface.sol
416 
417 abstract contract ERC165 is IERC165 {
418     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
419         return interfaceId == type(IERC165).interfaceId;
420     }
421 }
422 
423 // File: EverRise-v3/Interfaces/IERC2981-Royalty.sol
424 
425 interface IERC2981 is IERC165 {
426     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (
427         address receiver,
428         uint256 royaltyAmount
429     );
430 }
431 
432 // File: EverRise-v3/nftEverRise.sol
433 
434 // Copyright (c) 2022 EverRise Pte Ltd. All rights reserved.
435 // EverRise licenses this file to you under the MIT license.
436 /*
437  EverRise Staking NFTs are Vote Escrowed (ve) EverRise weigthed governance tokens
438  which generate rewards with a market driven yield curve, based of the
439  transaction volume of EverRise trades and veEverRise sales.
440 
441  On sales of veEverRise Staking NFTs a 10% royalty fee is collected
442  * 6% for token Buyback from the market, 
443      with bought back tokens directly distributed as ve-staking rewards
444  * 4% for Business Development (Development, Sustainability and Marketing)
445 
446                            ________                              _______   __
447                           /        |                            /       \ /  |
448                           $$$$$$$$/__     __  ______    ______  $$$$$$$  |$$/   _______   ______  v3.14159265
449                           $$ |__  /  \   /  |/      \  /      \ $$ |__$$ |/  | /       | /      \
450                           $$    | $$  \ /$$//$$$$$$  |/$$$$$$  |$$    $$< $$ |/$$$$$$$/ /$$$$$$  |
451  _______ _______ _______  $$$$$/   $$  /$$/ $$    $$ |$$ |  $$/ $$$$$$$  |$$ |$$      \ $$    $$ |
452 |    |  |    ___|_     _| $$ |_____ $$ $$/  $$$$$$$$/ $$ |      $$ |  $$ |$$ | $$$$$$  |$$$$$$$$/
453 |       |    ___| |   |   $$       | $$$/   $$       |$$ |      $$ |  $$ |$$ |/     $$/ $$       |
454 |__|____|___|     |___|   $$$$$$$$/   $/     $$$$$$$/ $$/       $$/   $$/ $$/ $$$$$$$/   $$$$$$$/
455 
456 Learn more about EverRise and the EverRise Ecosystem of dApps and
457 how our utilities and partners can help protect your investors
458 and help your project grow: https://www.everrise.com
459 */
460 
461 contract EverRiseTokenOwned is Ownable {
462     IEverRise public everRiseToken;
463 
464     event EverRiseTokenSet(address indexed tokenAddress);
465     
466     function _onlyEverRiseToken(address senderAddress) private view {
467         if (address(everRiseToken) == address(0)) revert NotSetup();
468         if (address(everRiseToken) != senderAddress) revert CallerNotApproved();
469     }
470 
471     modifier onlyEverRiseToken() {
472         _onlyEverRiseToken(_msgSender());
473         _;
474     }
475 }
476 
477 struct IndividualAllowance {
478     address operator;
479     uint48 timestamp;
480     uint32 nftCheck;
481 }
482 
483 abstract contract nftEverRiseConfigurable is EverRiseTokenOwned, InftEverRise, ERC165, IERC2981, IERC721Metadata, IOpenSeaCollectible {
484     event AddRewardCreator(address indexed _address);
485     event RemoveRewardCreator(address indexed _address);
486     event SetAchievementNfts(address indexed _address);
487     event RoyaltyFeeUpdated(uint256 newValue);
488     event RoyaltyAddressUpdated(address indexed contractAddress);
489     event RendererAddressUpdated(address indexed contractAddress);
490     event StakeCreateCostUpdated(uint256 newValue);
491     event StakingParametersSet(uint256 withdrawPct, uint256 firstHalfPenality, uint256 secondHalfPenality, uint256 maxStakeMonths, bool mergeEnabled);
492  
493     IEverRiseRenderer public renderer;
494     IEverRoyaltySplitter public royaltySplitter;
495     uint256 public nftRoyaltySplit = 10;
496     address public currentAchievementNfts;
497     uint8 public maxEarlyWithdrawalPercent = 60;
498     uint8 public firstHalfPenality = 25;
499     uint8 public secondHalfPenality = 10;
500     uint8 public maxStakeMonths = 36;
501     uint256 public stakeCreateCost = 1 * 10**18 / (10**2);
502     uint256 public mergeEnabled = _FALSE;
503 
504     // Booleans are more expensive than uint256 or any type that takes up a full
505     // word because each write operation emits an extra SLOAD to first read the
506     // slot's contents, replace the bits taken up by the boolean, and then write
507     // back. This is the compiler's defense against contract upgrades and
508     // pointer aliasing, and it cannot be disabled.
509     uint256 constant _FALSE = 1;
510     uint256 constant _TRUE = 2;
511 
512     mapping (address => bool) internal _canCreateRewards;
513 
514     function setEverRiseToken(address tokenAddress) external onlyOwner {
515         if (tokenAddress == address(0)) revert NotZeroAddress();
516 
517         _removeAddressToCreate(address(everRiseToken));
518         addAddressToCreate(tokenAddress);
519 
520         everRiseToken = IEverRise(tokenAddress);
521 
522         emit EverRiseTokenSet(tokenAddress);
523     }
524 
525     function setStakeCreateCost(uint256 _stakeCreateCost, uint256 numOfDecimals)
526         external onlyOwner
527     {
528         // Catch typos, if decimals are pre-added
529         if (_stakeCreateCost > 1_000) revert AmountOutOfRange();
530 
531         stakeCreateCost = _stakeCreateCost * (10**18) / (10**numOfDecimals);
532         emit StakeCreateCostUpdated(_stakeCreateCost);
533     }
534     
535     function setAchievementNfts(address contractAddress) external onlyOwner() {
536         if (contractAddress == address(0)) revert NotZeroAddress();
537 
538         currentAchievementNfts = contractAddress;
539 
540         emit SetAchievementNfts(contractAddress);
541     }
542 
543     function addAddressToCreate(address account) public onlyOwner {
544         if (account == address(0)) revert NotZeroAddress();
545 
546         _canCreateRewards[account] = true;
547         emit AddRewardCreator(account);
548     }
549 
550     function removeAddressToCreate(address account) external onlyOwner {
551         if (account == address(0)) revert NotZeroAddress();
552 
553         _removeAddressToCreate(account);
554     }
555 
556     function _removeAddressToCreate(address account) private {
557         if (account != address(0)){
558             _canCreateRewards[account] = false;
559             emit RemoveRewardCreator(account);
560         }
561     }
562     
563     function setNftRoyaltyFeePercent(uint256 royaltySplitRate) external onlyOwner {
564         if (royaltySplitRate > 10) revert AmountOutOfRange();
565         nftRoyaltySplit = royaltySplitRate;
566 
567         emit RoyaltyFeeUpdated(royaltySplitRate);
568     }
569 
570     function setRoyaltyAddress(address newAddress) external onlyOwner {
571         if (newAddress == address(0)) revert NotZeroAddress();
572 
573         royaltySplitter = IEverRoyaltySplitter(newAddress);
574         emit RoyaltyAddressUpdated(newAddress);
575     }
576 
577     function setRendererAddress(address newAddress) external onlyOwner {
578         if (newAddress == address(0)) revert NotZeroAddress();
579 
580         renderer = IEverRiseRenderer(newAddress);
581         emit RendererAddressUpdated(newAddress);
582     }
583 
584     function setStakingParameters(uint8 _withdrawPercent, uint8 _firstHalfPenality, uint8 _secondHalfPenality, uint8 _maxStakeMonths, bool _mergEnabled)
585         external onlyOwner
586     {
587         if (_maxStakeMonths == 0 || _maxStakeMonths > 120) {
588             revert AmountOutOfRange();
589         }
590 
591         maxEarlyWithdrawalPercent = _withdrawPercent;
592         firstHalfPenality = _firstHalfPenality;
593         secondHalfPenality = _secondHalfPenality;
594         maxStakeMonths = _maxStakeMonths;
595         mergeEnabled = _mergEnabled ? _TRUE : _FALSE;
596 
597         emit StakingParametersSet(_withdrawPercent, _firstHalfPenality, _secondHalfPenality, _maxStakeMonths, _mergEnabled);
598     }
599 }
600 
601 contract nftEverRise is nftEverRiseConfigurable {
602     string public constant name = "EverRise NFT Stakes";
603     string public constant symbol = "nftRISE";
604 
605     uint256 public constant month = 30 days;
606 
607     uint256 private constant MAX = ~uint256(0);
608     uint8 public constant decimals = 0;
609     uint256 private constant totalStakeTokensSupply = 120_000_000 * 10**6 * 10**18;
610     uint8 constant _FALSE8 = 1;
611     uint8 constant _TRUE8 = 2;
612     
613     event RewardsWithdrawn(address indexed from, uint256 amount);
614     event ExcludedFromRewards(address indexed _address);
615     event IncludedToRewards(address indexed _address);
616 
617     mapping (address => bool) private _isExcludedFromReward;
618     mapping (address => uint256) private _rOwned;
619     mapping (address => uint256) private _tOwned;
620     mapping (address => uint256) private _withdrawnRewards;
621     mapping (uint256 => IndividualAllowance) private _individualApproval;
622 
623     address[] private _excludedList;
624 
625     uint256 private _rTotal = (MAX - (MAX % totalStakeTokensSupply));
626 
627     StakingDetails[] private _allStakeDetails;
628     mapping (address => uint256[]) private _individualStakes;
629     mapping (uint256 => uint256) private _stakeById;
630     uint256[] private _freeStakes;
631     mapping (address => uint256) public voteEscrowedBalance;
632     uint256 public totalAmountEscrowed;
633     uint256 public totalAmountVoteEscrowed;
634     uint256 public totalRewardsDistributed;
635     
636     uint32 private nextNftId = 1;
637     veRise public immutable veRiseToken;
638     claimRise public immutable claimRiseToken;
639 
640     constructor() {
641         veRiseToken = new veRise();
642         claimRiseToken = new claimRise();
643 
644         _rOwned[address(this)] = _rTotal;
645         
646         excludeFromReward(address(this));
647 
648         _allStakeDetails.push(StakingDetails({
649             initialTokenAmount: 0,
650             withdrawnAmount: 0,
651             depositTime: 0,
652             numOfMonths: 1,
653             achievementClaimed: 0,
654             stakerAddress: address(0),
655             nftId: 0,
656             lookupIndex: 0,
657             stakerIndex: 0,
658             isActive: _FALSE8
659         }));
660     }
661  
662     function _walletLock(address fromAddress) private view {
663         if (everRiseToken.isWalletLocked(fromAddress)) revert WalletLocked();
664     }
665 
666     modifier walletLock(address fromAddress) {
667         _walletLock(fromAddress);
668         _;
669     }
670 
671     function totalSupply() external view returns (uint256) {
672         return _allStakeDetails.length - _freeStakes.length - 1;
673     }
674 
675     function _onlyRewardCreator(address senderAddress) private view {
676         if (!_canCreateRewards[senderAddress]) revert CallerNotApproved();
677     }
678 
679     modifier onlyRewardCreator() {
680         _onlyRewardCreator(_msgSender());
681         _;
682     }
683 
684     /**
685      * @dev See {IERC165-supportsInterface}.
686      */
687     function supportsInterface(bytes4 interfaceId) public view virtual override (ERC165, IERC165) returns (bool) {
688         return 
689             interfaceId == type(IERC2981).interfaceId ||
690             interfaceId == type(IERC721).interfaceId ||
691             interfaceId == type(IERC721Metadata).interfaceId ||
692             super.supportsInterface(interfaceId);
693     }
694 
695     function contractURI() external view returns (string memory) {
696         return renderer.contractURI();
697     }
698 
699     function tokenURI(uint256 nftId) external view returns (string memory) {
700         return renderer.tokenURI(nftId);
701     }
702     
703     function createRewards(uint256 amount) external onlyRewardCreator() {
704         address sender = _msgSender();
705         if (_isExcludedFromReward[sender]) revert NotAllowedToDeliverRewards();
706         
707         _transferFromExcluded(address(this), sender, amount);
708 
709         totalRewardsDistributed += amount;
710         
711         uint256 rAmount = amount * _getRate();
712         _rOwned[sender] -= rAmount;
713         _rTotal -= rAmount;
714 
715         claimRiseToken.transferFrom(address(0), address(this), amount);
716     }
717 
718     function voteEscrowedAndRewards(address account) private view returns (uint256) {
719         if (account == address(0)) revert NotZeroAddress();
720 
721         if (_isExcludedFromReward[account]) return _tOwned[account];
722         return tokenFromRewards(_rOwned[account]);
723     }
724 
725     function totalRewardsUnclaimed() external view returns (uint256) {
726         return everRiseToken.balanceOf(address(this));
727     }
728 
729     function isExcludedFromReward(address account) external view returns (bool) {
730         if (account == address(0)) revert NotZeroAddress();
731 
732         return _isExcludedFromReward[account];
733     }
734     
735     function rewardsFromToken(uint256 tAmount) external view returns(uint256) {
736         if (tAmount > totalStakeTokensSupply) revert AmountOutOfRange();
737 
738         return tAmount * _getRate();
739     }
740 
741     function tokenFromRewards(uint256 rAmount) public view returns(uint256) {
742         if (rAmount > _rTotal) revert AmountOutOfRange();
743 
744         uint256 currentRate =  _getRate();
745         return rAmount / currentRate;
746     }
747     
748     function excludeFromReward(address account) public onlyOwner() {
749         if (account == address(0)) revert NotZeroAddress();
750         if (_isExcludedFromReward[account]) revert InvalidAddress();
751 
752         if(_rOwned[account] > 0) {
753             _tOwned[account] = tokenFromRewards(_rOwned[account]);
754         }
755         _isExcludedFromReward[account] = true;
756         _excludedList.push(account);
757 
758         emit ExcludedFromRewards(account);
759     }
760 
761     function includeInReward(address account) external onlyOwner() {
762         if (account == address(0)) revert NotZeroAddress();
763         if (!_isExcludedFromReward[account]) revert InvalidAddress();
764           
765         uint256 length = _excludedList.length;
766         for (uint256 i = 0; i < length;) {
767             if (_excludedList[i] == account) {
768                 _excludedList[i] = _excludedList[_excludedList.length - 1];
769                 _tOwned[account] = 0;
770                 _isExcludedFromReward[account] = false;
771                 _excludedList.pop();
772                 break;
773             }
774             unchecked {
775                 ++i;
776             }
777         }
778 
779         emit IncludedToRewards(account);
780     }
781     
782     function _transfer(
783         address sender,
784         address recipient,
785         uint256 amount,
786         bool emitEvent
787     ) private {
788         if (sender == address(0)) revert NotZeroAddress();
789         if (recipient == address(0)) revert NotZeroAddress();
790         if (amount == 0) revert AmountMustBeGreaterThanZero();
791         // One of the addresses has to be this contract
792         if (sender != address(this) && recipient != address(this)) revert InvalidAddress();
793 
794         if (_isExcludedFromReward[sender]) {
795             if (!_isExcludedFromReward[recipient]) {
796                 _transferFromExcluded(sender, recipient, amount);
797             } else {
798                 _transferBothExcluded(sender, recipient, amount);
799             }
800         } else if (_isExcludedFromReward[recipient]) {
801             _transferToExcluded(sender, recipient, amount);
802         } else {
803             _transferStandard(sender, recipient, amount);
804         }
805 
806         if (emitEvent) {
807             if (sender == address(this)) {
808                 veRiseToken.transferFrom(address(0), recipient, amount);
809             }
810             else if (recipient == address(this)) {
811                 veRiseToken.transferFrom(sender, address(0), amount);
812             }
813         }
814     }
815     
816     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
817         uint256 rAmount = tAmount * _getRate();
818         _rOwned[sender] -= rAmount;
819         _rOwned[recipient] += rAmount;
820     }
821 
822     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
823         uint256 rAmount = tAmount * _getRate();
824 	    _rOwned[sender] -= rAmount;
825         _tOwned[recipient] += tAmount;
826         _rOwned[recipient] += rAmount;           
827     }
828 
829     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
830         uint256 rAmount = tAmount * _getRate();
831     	_tOwned[sender] -= tAmount;
832         _rOwned[sender] -= rAmount;
833         _rOwned[recipient] += rAmount;   
834     }
835 
836     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
837         uint256 rAmount = tAmount * _getRate();
838     	_tOwned[sender] -= tAmount;
839         _rOwned[sender] -= rAmount;
840         _tOwned[recipient] += tAmount;
841         _rOwned[recipient] += rAmount;        
842     }
843     
844     function _getRate() private view returns(uint256) {
845         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
846         return rSupply / tSupply;
847     }
848 
849     function _getCurrentSupply() private view returns(uint256, uint256) {
850         uint256 rSupply = _rTotal;
851         uint256 tSupply = totalStakeTokensSupply;      
852         uint256 length = _excludedList.length;
853 
854         for (uint256 i = 0; i < length;) {
855             if (_rOwned[_excludedList[i]] > rSupply || _tOwned[_excludedList[i]] > tSupply) {
856                 return (_rTotal, totalStakeTokensSupply);
857             }
858             rSupply -= _rOwned[_excludedList[i]];
859             tSupply -= _tOwned[_excludedList[i]];
860             
861             unchecked {
862                 ++i;
863             }
864         }
865         if (rSupply < (_rTotal / totalStakeTokensSupply)) return (_rTotal, totalStakeTokensSupply);
866         return (rSupply, tSupply);
867     }
868 
869     function getStakeIndex(uint256 nftId) private view returns (uint256 lookupIndex) {
870         if (nftId == 0) revert DoesNotExist();
871         lookupIndex = _stakeById[nftId];
872         if (lookupIndex >= _allStakeDetails.length) revert DoesNotExist();
873         if (_allStakeDetails[lookupIndex].isActive != _TRUE8) revert DoesNotExist();
874     }
875 
876     function ownerOf(uint256 nftId) public view returns (address) {
877         uint256 lookupIndex = getStakeIndex(nftId);
878         StakingDetails storage stakeDetails = _allStakeDetails[lookupIndex];
879         
880         return stakeDetails.stakerAddress;
881     }
882 
883     function _getStake(uint256 nftId, address staker) private view returns (uint256 lookupIndex, StakingDetails storage stakeDetails) {
884         lookupIndex = getStakeIndex(nftId);
885         stakeDetails = _allStakeDetails[lookupIndex];
886 
887         if (stakeDetails.stakerAddress != staker) revert NotStakerAddress();
888 
889         assert(nftId == stakeDetails.nftId);
890     }
891 
892     function getStake(uint256 nftId, address staker) external view returns (StakingDetails memory stakeDetails) {
893         (, stakeDetails) = _getStake(nftId, staker);
894     }
895 
896     function getNftData(uint256 nftId) external view returns (StakingDetails memory) {
897         uint256 lookupIndex = getStakeIndex(nftId);
898         return _allStakeDetails[lookupIndex];
899     }
900 
901     function balanceOf(address account) external view returns (uint256) {
902         return _individualStakes[account].length;
903     }
904     
905     function unclaimedRewardsBalance(address account) public view returns (uint256) {
906         return voteEscrowedAndRewards(account) - voteEscrowedBalance[account];
907     }
908 
909     function getTotalRewards(address account) external view returns (uint256) {
910         return unclaimedRewardsBalance(account) + _withdrawnRewards[account];
911     }
912     
913     function tokenOfOwnerByIndex(address _owner, uint256 index) external view returns (uint32) {
914         uint256[] storage stakes = _individualStakes[_owner];
915         if (index > stakes.length) revert AmountOutOfRange();
916         uint256 lookupIndex = stakes[index];
917         return _allStakeDetails[lookupIndex].nftId;
918     }
919     
920     function enterStaking(address staker, uint96 amount, uint8 numOfMonths)
921         external onlyEverRiseToken returns (uint32 nftId) {
922         // Stake time period must be in valid range
923         if (numOfMonths == 0 || 
924             numOfMonths > maxStakeMonths || 
925             (numOfMonths > 12 && (numOfMonths % 12) > 0)
926         ) {
927             revert AmountOutOfRange();
928         }
929 
930         roundingCheck(amount, false);
931 
932         nftId = _createStake(staker, amount, 0, numOfMonths, uint48(block.timestamp), false);
933      }
934  
935     // Rewards withdrawal doesn't need token lock check as is adding to locked wallet not removing
936     function withdrawRewards() external {
937         address staker = _msgSender();
938         uint256 rewards = unclaimedRewardsBalance(staker);
939 
940         if (rewards == 0) revert NoRewardsToClaim();
941 
942         // Something to withdraw
943         _withdrawnRewards[staker] += rewards;
944         // Remove the veTokens for the rewards
945         _transfer(staker, address(this), rewards, false);
946         // Emit transfer
947         claimRiseToken.transferFrom(staker, address(0), rewards);
948         // Send RISE rewards
949         require(everRiseToken.transfer(staker, rewards));
950 
951         emit RewardsWithdrawn(staker, rewards);
952     }
953 
954     function checkNotLocked(uint256 depositTime, uint256 numOfMonths) private view {
955         if (depositTime + (numOfMonths * month) > block.timestamp) {
956             revert StakeStillLocked();
957         }
958     }
959 
960     function leaveStaking(address staker, uint256 nftId, bool overrideNotClaimed) external onlyEverRiseToken returns (uint96 amount) {
961         (uint256 lookupIndex, StakingDetails storage stakeDetails) = _getStake(nftId, staker);
962 
963         checkNotLocked(stakeDetails.depositTime, stakeDetails.numOfMonths);
964 
965         if (!overrideNotClaimed && stakeDetails.achievementClaimed != _TRUE8) {
966             revert AchievementNotClaimed();
967         }
968         
969         amount = _removeStake(staker, nftId, lookupIndex, stakeDetails);
970     }
971 
972     function withdraw(address staker, uint256 nftId, uint96 amount, bool overrideNotClaimed) external onlyEverRiseToken returns (uint32 newNftId) {
973         (uint256 lookupIndex, StakingDetails storage stakeDetails) = _getStake(nftId, staker);
974 
975         checkNotLocked(stakeDetails.depositTime, stakeDetails.numOfMonths);
976 
977         if (!overrideNotClaimed && stakeDetails.achievementClaimed != _TRUE8) {
978             revert AchievementNotClaimed();
979         }
980 
981         uint96 remaining = stakeDetails.initialTokenAmount - stakeDetails.withdrawnAmount;
982         if (amount > remaining) revert AmountLargerThanAvailable();
983         roundingCheck(amount, true);
984 
985         bool reissueNft = false;
986         if (amount > 0) {
987             decreaseVeAmount(staker, amount, stakeDetails.numOfMonths, true);
988             // Out of period, inital now becomes remaining
989             remaining -= amount;
990             reissueNft = true;
991         }
992         if (stakeDetails.initialTokenAmount != remaining) {
993             // Out of period, zero out the withdrawal amount
994             stakeDetails.initialTokenAmount = remaining;
995             stakeDetails.withdrawnAmount = 0;
996             reissueNft = true;
997         }
998 
999         if (reissueNft) {
1000             if (remaining == 0) {
1001                 _burnStake(staker, nftId, lookupIndex, stakeDetails);
1002                 newNftId = 0;
1003             } else {
1004                 newNftId = _reissueStakeNftId(nftId, lookupIndex);
1005                 stakeDetails.nftId = newNftId;
1006             }
1007         } else {
1008             // Nothing changed, keep the same nft
1009             newNftId = uint32(nftId);
1010         }
1011     }
1012 
1013     function claimAchievement(address staker, uint256 nftId) external returns (uint32 newNftId) {
1014         if (_msgSender() != currentAchievementNfts) revert CallerNotApproved();
1015 
1016         (uint256 lookupIndex, StakingDetails storage stakeDetails) = _getStake(nftId, staker);
1017 
1018         checkNotLocked(stakeDetails.depositTime, stakeDetails.numOfMonths);
1019 
1020         // Can only claim once
1021         if (stakeDetails.achievementClaimed == _TRUE8) {
1022             revert AchievementAlreadyClaimed();
1023         }
1024 
1025         // Reset broken status if unlocked
1026         if (stakeDetails.withdrawnAmount > 0) {
1027             stakeDetails.initialTokenAmount -= stakeDetails.withdrawnAmount;
1028             stakeDetails.withdrawnAmount = 0;
1029         }
1030 
1031         // Mark claimed
1032         stakeDetails.achievementClaimed = _TRUE8;
1033         // Get new id
1034         newNftId = _reissueStakeNftId(nftId, lookupIndex);
1035         // Set new id
1036         stakeDetails.nftId = newNftId;
1037         // Emit burn and mint events
1038         _reissueStakeNft(staker, nftId, newNftId);
1039     }
1040 
1041     function getTime() external view returns (uint256) {
1042         // Used to workout UI time drift from blockchain
1043         return block.timestamp;
1044     }
1045 
1046     function checkLocked(uint48 depositTime, uint8 numOfMonths) private view {
1047         if (depositTime + (numOfMonths * month) < block.timestamp) {
1048             revert StakeUnlocked();
1049         }
1050     }
1051 
1052     function earlyWithdraw(address staker, uint256 nftId, uint96 amount) external onlyEverRiseToken returns (uint32 newNftId, uint96 penaltyAmount) {
1053         (uint256 lookupIndex, StakingDetails storage stakeDetails) = _getStake(nftId, staker);
1054         
1055         checkLocked(stakeDetails.depositTime, stakeDetails.numOfMonths);
1056 
1057         uint256 remaingEarlyWithdrawal = (stakeDetails.initialTokenAmount * maxEarlyWithdrawalPercent) / 100 - stakeDetails.withdrawnAmount;
1058 
1059         if (amount > remaingEarlyWithdrawal) {
1060             revert AmountLargerThanAvailable();
1061         }
1062 
1063         roundingCheck(amount, false);
1064 
1065         decreaseVeAmount(staker, amount, stakeDetails.numOfMonths, true);
1066         
1067         penaltyAmount = calculateTax(amount, stakeDetails.depositTime, stakeDetails.numOfMonths); // calculate early penalty tax
1068 
1069         stakeDetails.withdrawnAmount += uint96(amount); // update the withdrawl amount
1070 
1071         newNftId = _reissueStakeNftId(nftId, lookupIndex);
1072         stakeDetails.nftId = newNftId;
1073     }
1074 
1075     function increaseStake(address staker, uint256 nftId, uint96 amount)
1076         external onlyEverRiseToken returns (uint32 newNftId, uint96 original, uint8 numOfMonths)
1077     {
1078         (uint256 lookupIndex, StakingDetails storage stakeDetails) = _getStake(nftId, staker);
1079 
1080         checkLocked(stakeDetails.depositTime, stakeDetails.numOfMonths);
1081 
1082         roundingCheck(amount, false);
1083         numOfMonths = stakeDetails.numOfMonths;
1084 
1085         increaseVeAmount(staker, amount, numOfMonths, true);
1086         // Get current amount for main contract change event
1087         original = stakeDetails.initialTokenAmount - stakeDetails.withdrawnAmount;
1088         // Take amount off the withdrawnAmount, "repairing" the stake
1089         if (amount > stakeDetails.withdrawnAmount) {
1090             // Take withdrawn off amount
1091             amount -= stakeDetails.withdrawnAmount;
1092             // Clear withdrawn
1093             stakeDetails.withdrawnAmount = 0;
1094             // Add remaining to initial
1095             stakeDetails.initialTokenAmount += amount;
1096         } else {
1097             // Just reduce amount withdrawn
1098             stakeDetails.withdrawnAmount -= amount;
1099         }
1100 
1101         // Relock
1102         stakeDetails.depositTime = uint48(block.timestamp);
1103 
1104         newNftId =  _reissueStakeNftId(nftId, lookupIndex);
1105         stakeDetails.nftId = newNftId;
1106         _reissueStakeNft(staker, nftId, newNftId);
1107     }
1108     
1109     function extendStake(uint256 nftId, uint8 numOfMonths) external walletLock(_msgSender()) returns (uint32 newNftId) {
1110         address staker = _msgSender();
1111         (uint256 lookupIndex, StakingDetails storage stakeDetails) = _getStake(nftId, staker);
1112         
1113         checkLocked(stakeDetails.depositTime, stakeDetails.numOfMonths);
1114 
1115         if (stakeDetails.numOfMonths >= numOfMonths) revert StakeCanOnlyBeExtended();
1116 
1117         // Stake time period must be in valid range
1118         if (numOfMonths > maxStakeMonths || 
1119             (numOfMonths > 12 && (numOfMonths % 12) > 0)
1120         ) {
1121             revert AmountOutOfRange();
1122         }
1123 
1124         uint8 extraMonths = numOfMonths - stakeDetails.numOfMonths;
1125         uint96 amount = (stakeDetails.initialTokenAmount - stakeDetails.withdrawnAmount);
1126         
1127         increaseVeAmount(staker, amount, extraMonths, true);
1128         
1129         stakeDetails.numOfMonths = numOfMonths;
1130         // Relock
1131         stakeDetails.depositTime = uint48(block.timestamp);
1132 
1133         newNftId =  _reissueStakeNftId(nftId, lookupIndex);
1134         stakeDetails.nftId = newNftId;
1135         _reissueStakeNft(staker, nftId, newNftId);
1136     }
1137 
1138     function toUint96(uint256 value) internal pure returns (uint96) {
1139         if (value > type(uint96).max) revert Overflow();
1140         return uint96(value);
1141     }
1142 
1143     function splitStake(uint256 nftId, uint96 amount) external payable walletLock(_msgSender()) returns (uint32 newNftId0, uint32 newNftId1) {
1144         address staker = _msgSender();
1145         
1146         if (msg.value < stakeCreateCost) revert NotEnoughToCoverStakeFee();
1147         roundingCheck(amount, false);
1148 
1149         // Transfer everything, easier than transferring extras later
1150         payable(address(everRiseToken)).transfer(address(this).balance);
1151 
1152         (uint256 lookupIndex, StakingDetails storage stakeDetails) = _getStake(nftId, staker);
1153 
1154         uint256 remainingAmount = stakeDetails.initialTokenAmount - stakeDetails.withdrawnAmount;
1155 
1156         if (amount >= remainingAmount) revert AmountLargerThanAvailable();
1157   
1158         newNftId0 = _reissueStakeNftId(nftId, lookupIndex);
1159         // Update the existing stake
1160         uint96 transferredWithdrawnAmount = toUint96(stakeDetails.withdrawnAmount * uint256(amount) / stakeDetails.initialTokenAmount);
1161 
1162         stakeDetails.initialTokenAmount -= amount;
1163         stakeDetails.withdrawnAmount -= transferredWithdrawnAmount;
1164         stakeDetails.nftId = newNftId0;
1165 
1166         // Create new stake
1167         newNftId1 = _addSplitStake(
1168             staker, 
1169             amount, // initialTokenAmount
1170             transferredWithdrawnAmount, // withdrawnAmount
1171             stakeDetails.depositTime,        // depositTime
1172             stakeDetails.numOfMonths,
1173             stakeDetails.achievementClaimed == _TRUE8 // achievementClaimed
1174         );
1175 
1176         _reissueStakeNft(staker, nftId, newNftId0);
1177         emit Transfer(address(0), staker, newNftId1);
1178     }
1179 
1180     function roundingCheck(uint96 amount, bool allowZero) private pure {
1181         // Round to nearest unit
1182         uint96 roundedAmount = amount - (amount % uint96(10**18));
1183 
1184         if (amount != roundedAmount || (!allowZero && amount == 0)) revert AmountMustBeAnInteger();
1185     }
1186 
1187     function mergeStakes(uint256 nftId0, uint256 nftId1, bool overrideStatuses)
1188         external walletLock(_msgSender())
1189         returns (uint32 newNftId)
1190     {
1191         if (mergeEnabled != _TRUE) revert MergeNotEnabled();
1192         
1193         address staker = _msgSender();
1194         (uint256 lookupIndex0, StakingDetails storage stakeDetails0) = _getStake(nftId0, staker);
1195         (uint256 lookupIndex1, StakingDetails storage stakeDetails1) = _getStake(nftId1, staker);
1196 
1197         bool unlocked0 = stakeDetails0.depositTime + (stakeDetails0.numOfMonths * month) < block.timestamp;
1198         bool unlocked1 = stakeDetails1.depositTime + (stakeDetails1.numOfMonths * month) < block.timestamp;
1199 
1200         if (unlocked0 == unlocked1) {
1201             if (stakeDetails0.numOfMonths != stakeDetails1.numOfMonths) {
1202                 revert UnlockedStakesMustBeSametimePeriod();
1203             }
1204             if (!overrideStatuses && stakeDetails0.achievementClaimed != stakeDetails1.achievementClaimed) {
1205                 revert AchievementClaimStatusesDiffer();
1206             }
1207             
1208             // Reset broken status if unlocked
1209             if (stakeDetails0.withdrawnAmount > 0) {
1210                 stakeDetails0.initialTokenAmount -= stakeDetails0.withdrawnAmount;
1211                 stakeDetails0.withdrawnAmount = 0;
1212             }
1213             if (stakeDetails1.withdrawnAmount > 0) {
1214                 stakeDetails1.initialTokenAmount -= stakeDetails1.withdrawnAmount;
1215                 stakeDetails1.withdrawnAmount = 0;
1216             }
1217         } else if (unlocked0 != unlocked1) {
1218             revert CannotMergeLockedAndUnlockedStakes();
1219         } else {
1220             // Both locked
1221             if (!overrideStatuses && (stakeDetails0.withdrawnAmount > 0) != (stakeDetails1.withdrawnAmount > 0)) {
1222                 revert BrokenStatusesDiffer();
1223             }
1224         }
1225 
1226         uint8 numOfMonths0 = stakeDetails0.numOfMonths;
1227         if (!unlocked0) {
1228             uint8 extraMonths = 0;
1229             uint96 amount = 0;
1230             // Must both be locked
1231             uint8 numOfMonths1 = stakeDetails1.numOfMonths;
1232             if (numOfMonths0 > numOfMonths1) {
1233                 extraMonths = numOfMonths0 - numOfMonths1;
1234                 amount = (stakeDetails1.initialTokenAmount - stakeDetails1.withdrawnAmount);
1235             } else if (numOfMonths0 < numOfMonths1) {
1236                 extraMonths = numOfMonths1 - numOfMonths0;
1237                 amount = (stakeDetails0.initialTokenAmount - stakeDetails0.withdrawnAmount);
1238                 numOfMonths0 = numOfMonths1;
1239             }
1240 
1241             if (extraMonths > 0 && amount > 0) {
1242                 // Give new tokens for time period
1243                 increaseVeAmount(staker, amount, extraMonths, true);
1244             }
1245         }
1246 
1247         stakeDetails0.initialTokenAmount += stakeDetails1.initialTokenAmount;
1248         stakeDetails0.withdrawnAmount += stakeDetails1.withdrawnAmount;
1249         if (unlocked0) {
1250             // For unlocked, use higher of two deposit times
1251             // Can't "age" and nft by merging an older one in
1252             stakeDetails0.depositTime = stakeDetails0.depositTime > stakeDetails1.depositTime ?
1253                 stakeDetails0.depositTime : stakeDetails1.depositTime;
1254         } else {
1255             // Re-lock starting now
1256             stakeDetails0.depositTime = uint48(block.timestamp);
1257         }
1258 
1259         stakeDetails0.numOfMonths = numOfMonths0;
1260         if (stakeDetails1.achievementClaimed == _TRUE8) {
1261             stakeDetails0.achievementClaimed = _TRUE8;
1262         }
1263         
1264         // Drop the second stake
1265         stakeDetails1.isActive = _FALSE8;
1266         uint24 stakerIndex = stakeDetails1.stakerIndex;
1267         _removeIndividualStake(staker, stakerIndex);
1268         // Clear the lookup for second
1269         _stakeById[nftId1] = 0;
1270         // Add to available data items
1271         _freeStakes.push(lookupIndex1);
1272         // Burn the second stake completely
1273         emit Transfer(staker, address(0), nftId1);
1274 
1275         // Renumber first stake
1276         newNftId = _reissueStakeNftId(nftId0, lookupIndex0);
1277         stakeDetails0.nftId = newNftId;
1278         _reissueStakeNft(staker, nftId0, newNftId);
1279     }
1280 
1281     function _addSplitStake(
1282         address staker, 
1283         uint96 initialTokenAmount,
1284         uint96 withdrawnAmount,
1285         uint48 depositTime,
1286         uint8 numOfMonths,
1287         bool achievementClaimed
1288     ) private returns (uint32 nftId) {
1289         uint256[] storage stakes = _individualStakes[staker];
1290         // Create new stake
1291         StakingDetails storage splitStakeDetails = _createStakeDetails(
1292             initialTokenAmount, // initialTokenAmount
1293             withdrawnAmount, // withdrawnAmount
1294             depositTime,        // depositTime
1295             numOfMonths,
1296             achievementClaimed, // achievementClaimed
1297             staker,
1298             uint24(stakes.length) // New staker's stake index
1299         );
1300 
1301         // Add new stake to individual's list
1302         stakes.push(splitStakeDetails.lookupIndex); 
1303         nftId = splitStakeDetails.nftId;
1304     }
1305 
1306     function bridgeStakeNftOut(address fromAddress, uint256 nftId) 
1307         external onlyEverRiseToken returns (uint96 amount)
1308     {
1309         (uint256 lookupIndex, StakingDetails storage stakeDetails) = _getStake(nftId, fromAddress);
1310 
1311         return _removeStake(fromAddress, nftId, lookupIndex, stakeDetails);
1312     }
1313 
1314     function bridgeOrAirdropStakeNftIn(address toAddress, uint96 depositAmount, uint8 numOfMonths, uint48 depositTime, uint96 withdrawnAmount, uint96 rewards, bool achievementClaimed) 
1315         external onlyEverRiseToken returns (uint32 nftId) {
1316             
1317         nftId = _createStake(toAddress, depositAmount, withdrawnAmount, numOfMonths, depositTime, achievementClaimed);
1318         if (rewards > 0) {
1319             _transfer(address(this), toAddress, rewards, false);
1320             // Emit event
1321             claimRiseToken.transferFrom(address(0), toAddress, rewards);
1322         }
1323     }
1324 
1325     function _createStakeDetails(
1326         uint96 initialTokenAmount,
1327         uint96 withdrawnAmount,
1328         uint48 depositTime,
1329         uint8 numOfMonths,
1330         bool achievementClaimed,
1331         address stakerAddress,
1332         uint24 stakerIndex
1333     ) private returns (StakingDetails storage stakeDetails) {
1334         uint256 index = _freeStakes.length;
1335         if (index > 0) {
1336             // Is an existing allocated StakingDetails
1337             // that we can reuse for cheaper gas
1338             index = _freeStakes[index - 1];
1339             _freeStakes.pop();
1340             stakeDetails = _allStakeDetails[index];
1341         } else {
1342             // None free, allocate a new StakingDetails
1343             index = _allStakeDetails.length;
1344             stakeDetails = _allStakeDetails.push();
1345         }
1346 
1347         // Set stake details
1348         stakeDetails.initialTokenAmount = initialTokenAmount;
1349         stakeDetails.withdrawnAmount = withdrawnAmount;
1350         stakeDetails.depositTime = depositTime;
1351         stakeDetails.numOfMonths = numOfMonths;
1352         stakeDetails.achievementClaimed = achievementClaimed ? _TRUE8 : _FALSE8;
1353 
1354         stakeDetails.stakerAddress = stakerAddress;
1355         stakeDetails.nftId = nextNftId;
1356         stakeDetails.lookupIndex = uint32(index);
1357         stakeDetails.stakerIndex = stakerIndex;
1358         stakeDetails.isActive = _TRUE8;
1359 
1360         // Set lookup
1361         _stakeById[nextNftId] = index;
1362         // Increase the next nft id
1363         ++nextNftId;
1364     }
1365 
1366     function _transferStake(address fromAddress, address toAddress, uint256 nftId) 
1367         private
1368     {
1369         (uint256 lookupIndex, StakingDetails storage stakeDetails) = _getStake(nftId, fromAddress);
1370         require(stakeDetails.withdrawnAmount == 0, "Broken, non-transferable");
1371 
1372         stakeDetails.stakerAddress = toAddress;
1373         // Full initial as withdrawn must be zero (above)
1374         uint96 amountToTransfer = stakeDetails.initialTokenAmount;
1375 
1376         uint8 numOfMonths = stakeDetails.numOfMonths;
1377         // Remove veTokens from sender (don't emit ve transfer event)
1378         decreaseVeAmount(fromAddress, amountToTransfer, numOfMonths, false);
1379         // Give veTokens to receiver (don't emit ve transfer event)
1380         increaseVeAmount(toAddress, amountToTransfer, numOfMonths, false);
1381         // Emit the ve transfer event
1382         veRiseToken.transferFrom(fromAddress, toAddress, amountToTransfer * numOfMonths);
1383 
1384         // Remove from previous owners list
1385         _removeIndividualStake(fromAddress, stakeDetails.stakerIndex);
1386         // Add to new owners list
1387         stakeDetails.stakerIndex = uint24(_individualStakes[toAddress].length);
1388         _individualStakes[toAddress].push(lookupIndex);
1389 
1390         everRiseToken.transferStake(fromAddress, toAddress, amountToTransfer);
1391     }
1392 
1393     function _removeIndividualStake(address staker, uint24 stakerIndex) private {
1394         uint256[] storage stakes = _individualStakes[staker];
1395 
1396         uint24 stakerLength = uint24(stakes.length);
1397 
1398         if (stakerLength >= stakerIndex + 1) {
1399             // Not last item, overwrite with last item from account stakes
1400             uint256 lastStakeIndex = stakes[stakerLength - 1];
1401             _allStakeDetails[lastStakeIndex].stakerIndex = stakerIndex;
1402             stakes[stakerIndex] = lastStakeIndex;
1403         }
1404         // Remove last item
1405         stakes.pop();
1406     }
1407 
1408     function _reissueStakeNftId(uint256 nftId, uint256 stakeIndex) private returns (uint32 newNftId) {
1409         // Burn the Stake NFT id
1410         _stakeById[nftId] = 0;
1411         // Reissue new Stake NFT id
1412         newNftId = nextNftId;
1413         _stakeById[newNftId] = stakeIndex;
1414         // Increase the next nft id
1415         ++nextNftId;
1416     }
1417 
1418     function increaseVeAmount(address staker, uint96 amount, uint8 numOfMonths, bool emitEvent) private {
1419         // Transfer vote escrowed tokens from contract to staker
1420         uint256 veTokens = amount * numOfMonths;
1421         totalAmountEscrowed += amount;
1422         totalAmountVoteEscrowed += veTokens;
1423         voteEscrowedBalance[staker] += veTokens; // increase the ve tokens amount
1424         _transfer(address(this), staker, veTokens, emitEvent);
1425     }
1426 
1427     function decreaseVeAmount(address staker, uint96 amount, uint8 numOfMonths, bool emitEvent) private {
1428         // Transfer vote escrowed tokens back to the contract
1429         uint256 veTokens = amount * numOfMonths;
1430         totalAmountEscrowed -= amount;
1431         totalAmountVoteEscrowed -= veTokens;
1432         voteEscrowedBalance[staker] -= veTokens; // decrease the ve tokens amount
1433         _transfer(staker, address(this), veTokens, emitEvent);
1434     }
1435 
1436     function _removeStake(address staker, uint256 nftId, uint256 lookupIndex, StakingDetails storage stakeDetails) private returns (uint96 amount) {        
1437         uint96 remainingAmount = stakeDetails.initialTokenAmount - stakeDetails.withdrawnAmount;
1438 
1439         decreaseVeAmount(staker, remainingAmount, stakeDetails.numOfMonths, true);
1440 
1441         _burnStake(staker, nftId, lookupIndex, stakeDetails);
1442 
1443         return remainingAmount;
1444     }
1445 
1446     function _burnStake(address staker, uint256 nftId, uint256 lookupIndex, StakingDetails storage stakeDetails) private {        
1447         stakeDetails.isActive = _FALSE8;
1448 
1449         uint24 stakerIndex = stakeDetails.stakerIndex;
1450         _removeIndividualStake(staker, stakerIndex);
1451 
1452         // Clear the lookup
1453         _stakeById[nftId] = 0;
1454         // Add to available data items
1455         _freeStakes.push(lookupIndex);
1456     }
1457 
1458     function _createStake(address staker, uint96 depositAmount, uint96 withdrawnAmount, uint8 numOfMonths, uint48 depositTime, bool achievementClaimed)
1459         private returns (uint32 nftId)
1460     {
1461         if (withdrawnAmount >= depositAmount) revert AmountOutOfRange();
1462         uint256[] storage stakes = _individualStakes[staker];
1463 
1464         // Create new stake
1465         StakingDetails storage stakeDetails = _createStakeDetails(
1466             depositAmount,   // initialTokenAmount
1467             withdrawnAmount, // withdrawnAmount
1468             depositTime,     // depositTime
1469             numOfMonths,
1470             achievementClaimed,           // achievementClaimed
1471             staker,
1472             uint24(stakes.length)   // New staker's stake index
1473         );
1474 
1475         // Add new stake to individual's list
1476         stakes.push(stakeDetails.lookupIndex);  
1477         
1478         uint96 remaining = depositAmount - withdrawnAmount;
1479         increaseVeAmount(staker, remaining, numOfMonths, true);
1480 
1481         // Mint new Stake NFT to staker
1482         nftId = stakeDetails.nftId;
1483     }
1484 
1485     function calculateTax(uint96 amount, uint256 depositTime, uint256 numOfMonths) public view returns (uint96) {
1486         return calculateTaxAt(amount, depositTime, numOfMonths, block.timestamp);
1487     }
1488 
1489     function calculateTaxAt(uint96 amount, uint256 depositTime, uint256 numOfMonths, uint256 timestamp) public view returns (uint96) {
1490         uint256 lockTime = depositTime + (numOfMonths * month);
1491         uint96 taxAmount = 0;
1492 
1493         if (timestamp < depositTime + (numOfMonths * month / 2)) {
1494             taxAmount = (amount * firstHalfPenality) / 100;
1495         } else if (timestamp < lockTime) {
1496             taxAmount = (amount * secondHalfPenality) / 100;
1497         }
1498 
1499         return taxAmount;
1500     }
1501 
1502     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (
1503         address receiver,
1504         uint256 royaltyAmount
1505     ) {
1506         if (_tokenId == 0) revert AmountMustBeGreaterThanZero();
1507 
1508         return (address(royaltySplitter), _salePrice / nftRoyaltySplit);
1509     }
1510     
1511     /**
1512      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1513      *
1514      * Emits an {ApprovalForAll} event.
1515      *
1516      * Requirements:
1517      *
1518      * - `operator` cannot be the caller.
1519      */
1520     function setApprovalForAll(address operator, bool approved) external {
1521         if (address(everRiseToken) == address(0)) revert NotSetup();
1522 
1523         address _owner = _msgSender();
1524         everRiseToken.setApprovalForAll(_owner, operator, approved);
1525 
1526         emit ApprovalForAll(_owner, operator, approved);
1527     }
1528 
1529     /**
1530      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1531      *
1532      * See {setApprovalForAll}.
1533      */
1534     function isApprovedForAll(address account, address operator) public view returns (bool) {
1535         return everRiseToken.isApprovedForAll(account, operator);
1536     }
1537 
1538     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external payable walletLock(_msgSender()) {
1539         address operator = _msgSender();
1540         _transferFrom(operator, from, to, tokenId);
1541         _doSafeERC721TransferAcceptanceCheck(operator, from, to, tokenId, data);
1542     }
1543     
1544     function safeTransferFrom(address from, address to, uint256 tokenId) external payable walletLock(_msgSender()) {
1545         address operator = _msgSender();
1546         _transferFrom(operator, from, to, tokenId);
1547         _doSafeERC721TransferAcceptanceCheck(operator, from, to, tokenId, new bytes(0));
1548     }
1549 
1550     function transferFrom(address from, address to, uint256 tokenId)
1551         external payable walletLock(_msgSender()) {
1552         address operator = _msgSender();
1553         _transferFrom(operator, from, to, tokenId);
1554     }
1555     
1556    function approve(address account, address _operator, uint256 nftId)
1557         external onlyEverRiseToken {
1558         _approve(account, _operator, nftId);
1559     }
1560 
1561     function approve(address _operator, uint256 nftId) external payable {
1562         _approve(_msgSender(), _operator, nftId);
1563     }
1564 
1565     function _approve(address account, address _operator, uint256 nftId) private {
1566         if (ownerOf(nftId) != account) revert NotStakerAddress();
1567 
1568         ApprovalChecks memory approvals = everRiseToken.approvals(account);
1569 
1570         _individualApproval[nftId] = IndividualAllowance({
1571             operator: _operator, 
1572             timestamp: approvals.autoRevokeNftHours == 0 ? 
1573                 type(uint48).max : // Don't timeout approval
1574                 uint48(block.timestamp) + approvals.autoRevokeNftHours * 1 hours, // Timeout after user chosen period,
1575             nftCheck: approvals.nftCheck
1576         });
1577     }
1578 
1579     function getApproved(uint256 nftId) external view returns (address) {
1580         getStakeIndex(nftId); // Reverts on not exist
1581         
1582         IndividualAllowance storage _allowance = _individualApproval[nftId];
1583         ApprovalChecks memory approvals = everRiseToken.approvals(ownerOf(nftId));
1584 
1585         if (block.timestamp > _allowance.timestamp ||
1586             approvals.nftCheck != _allowance.nftCheck)
1587         {
1588             return address(0);
1589         }
1590 
1591         return _allowance.operator;
1592     }
1593 
1594     function _isAddressApproved(address operator, uint256 nftId) private view returns (bool) {
1595         IndividualAllowance storage _allowance = _individualApproval[nftId];
1596         ApprovalChecks memory approvals = everRiseToken.approvals(ownerOf(nftId));
1597 
1598         if (_allowance.operator != operator ||
1599             block.timestamp > _allowance.timestamp ||
1600             approvals.nftCheck != _allowance.nftCheck)
1601         {
1602             return false;
1603         }
1604 
1605         return true;
1606     }
1607 
1608     function _transferFrom(
1609         address operator,
1610         address from,
1611         address to,
1612         uint256 nftId
1613     ) private {
1614         if (address(everRiseToken) == address(0)) revert NotSetup();
1615         if (from == address(0)) revert NotZeroAddress();
1616         if (to == address(0)) revert NotZeroAddress();
1617         if (operator != from && 
1618             !isApprovedForAll(from, operator) &&
1619             !_isAddressApproved(from, nftId)
1620         ) revert AmountLargerThanAllowance();
1621 
1622         // Clear any individual approvals
1623         delete _individualApproval[nftId];
1624         _transferStake(from, to, nftId);
1625 
1626         // Signal transfer complete
1627         emit Transfer(from, to, nftId);
1628     }
1629 
1630     function addStaker(address staker, uint256 nftId)
1631         external onlyEverRiseToken 
1632     {
1633         // Send event for new staking
1634         emit Transfer(address(0), staker, nftId);
1635     }
1636 
1637     function _doSafeERC721TransferAcceptanceCheck(
1638         address operator,
1639         address from,
1640         address to,
1641         uint256 id,
1642         bytes memory data
1643     ) private view {
1644         if (isContract(to)) {
1645             try IERC721TokenReceiver(to).onERC721Received(operator, from, id, data) returns (bytes4 response) {
1646                 if (response != IERC721TokenReceiver.onERC721Received.selector) {
1647                     revert ERC721ReceiverReject();
1648                 }
1649             } catch Error(string memory reason) {
1650                 revert(reason);
1651             } catch {
1652                 revert ERC721ReceiverNotImplemented();
1653             }
1654         }
1655     }
1656 
1657     function isContract(address account) private view returns (bool) {
1658         // This method relies on extcodesize/address.code.length, which returns 0
1659         // for contracts in construction, since the code is only stored at the end
1660         // of the constructor execution.
1661 
1662         return account.code.length > 0;
1663     }
1664 
1665     function removeStaker(address staker, uint256 nftId)
1666         external onlyEverRiseToken 
1667     {
1668         // Send event for left staking
1669         emit Transfer(staker, address(0), nftId);
1670     }
1671 
1672     function reissueStakeNft(address staker, uint256 oldNftId, uint256 newNftId)
1673         external onlyEverRiseToken 
1674     {
1675         _reissueStakeNft(staker, oldNftId, newNftId);
1676     }
1677 
1678     function _reissueStakeNft(address staker, uint256 oldNftId, uint256 newNftId)
1679         private
1680     {
1681         // Burn old Stake NFT
1682         emit Transfer(staker, address(0), oldNftId);
1683         // Reissue new Stake NFT
1684         emit Transfer(address(0), staker, newNftId);
1685     }
1686 
1687     // Admin for trapped tokens
1688 
1689     function transferExternalTokens(address tokenAddress, address toAddress) external onlyOwner {
1690         if (tokenAddress == address(0)) revert NotZeroAddress();
1691         if (toAddress == address(0)) revert NotZeroAddress();
1692         if (IERC20(tokenAddress).balanceOf(address(this)) == 0) revert AmountLargerThanAvailable();
1693 
1694         require(IERC20(tokenAddress).transfer(toAddress, IERC20(tokenAddress).balanceOf(address(this))));
1695     }
1696 
1697     function transferToAddressETH(address payable receipient) external onlyOwner {
1698         if (receipient == address(0)) revert NotZeroAddress();
1699 
1700         receipient.transfer(address(this).balance);
1701     }
1702 }