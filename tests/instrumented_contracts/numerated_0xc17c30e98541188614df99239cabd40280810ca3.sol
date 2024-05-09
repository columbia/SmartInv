1 // Copyright (c) 2022 EverRise Pte Ltd. All rights reserved.
2 // EverRise licenses this file to you under the MIT license.
3 /*
4  The EverRise token is the keystone in the EverRise Ecosytem of dApps
5  and the overaching key that unlocks multi-blockchain unification via
6  the EverBridge.
7 
8  On EverRise token transactions 6% buyback and business development fees are collected:
9 
10  * 4% for token Buyback from the market, with bought back tokens directly
11       distributed as ve-staking rewards
12  * 2% for Business Development (Development, Sustainability and Marketing)
13   ________                              _______   __
14  /        |                            /       \ /  |
15  $$$$$$$$/__     __  ______    ______  $$$$$$$  |$$/   _______   ______  v3.14159265
16  $$ |__  /  \   /  |/      \  /      \ $$ |__$$ |/  | /       | /      \
17  $$    | $$  \ /$$//$$$$$$  |/$$$$$$  |$$    $$< $$ |/$$$$$$$/ /$$$$$$  |
18  $$$$$/   $$  /$$/ $$    $$ |$$ |  $$/ $$$$$$$  |$$ |$$      \ $$    $$ |
19  $$ |_____ $$ $$/  $$$$$$$$/ $$ |      $$ |  $$ |$$ | $$$$$$  |$$$$$$$$/
20  $$       | $$$/   $$       |$$ |      $$ |  $$ |$$ |/     $$/ $$       |
21  $$$$$$$$/   $/     $$$$$$$/ $$/       $$/   $$/ $$/ $$$$$$$/   $$$$$$$/ Magnum opus
22 
23  Learn more about EverRise and the EverRise Ecosystem of dApps and
24  how our utilities and partners can help protect your investors
25  and help your project grow: https://everrise.com
26 */
27 
28 // SPDX-License-Identifier: MIT
29 
30 pragma solidity 0.8.13;
31 
32 error NotContractAddress();             // 0xd9716e43
33 error NoSameBlockSandwichTrades();      // 0x5fe87cb3
34 error TransferTooLarge();               // 0x1b97a875
35 error AmountLargerThanUnlockedAmount(); // 0x170abf7c
36 error TokenNotStarted();                // 0xd87a63e0
37 error TokenAlreadyStarted();            // 0xe529091f
38 error SandwichTradesAreDisallowed();    // 0xe069ee1d
39 error AmountLargerThanAvailable();      // 0xbb296109
40 error StakeCanOnlyBeExtended();         // 0x73f7040a
41 error NotStakeContractRequesting();     // 0x2ace6531
42 error NotEnoughToCoverStakeFee();       // 0x627554ed
43 error NotZeroAddress();                 // 0x66385fa3
44 error CallerNotApproved();              // 0x4014f1a5
45 error InvalidAddress();                 // 0xe6c4247b
46 error CallerNotOwner();                 // 0x5cd83192
47 error NotZero();                        // 0x0295aa98
48 error LiquidityIsLocked();              // 0x6bac637f
49 error LiquidityAddOwnerOnly();          // 0x878d6363
50 error Overflow();                       // 0x35278d12
51 error WalletLocked();                   // 0xd550ed24
52 error LockTimeTooLong();                // 0xb660e89a
53 error LockTimeTooShort();               // 0x6badcecf
54 error NotLocked();                      // 0x1834e265
55 error AmountMustBeGreaterThanZero();    // 0x5e85ae73
56 error Expired();                        // 0x203d82d8
57 error InvalidSignature();               // 0x8baa579f
58 error AmountLargerThanAllowance();      // 0x9b144c57
59 error AmountOutOfRange();               // 0xc64200e9
60 error Unlocked();                       // 0x19aad371
61 error FailedEthSend();                  // 0xb5747cc7
62 
63 // File: EverRise-v3/Interfaces/IERC2612-Permit.sol
64 
65 pragma solidity 0.8.13;
66 interface IERC2612 {
67     function permit(
68         address owner,
69         address spender,
70         uint256 value,
71         uint256 deadline,
72         uint8 v,
73         bytes32 r,
74         bytes32 s
75     ) external;
76     function nonces(address owner) external view returns (uint256);
77     function DOMAIN_SEPARATOR() external view returns (bytes32);
78 }
79 
80 // File: EverRise-v3/Interfaces/IERC173-Ownable.sol
81 
82 interface IOwnable {
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84     function owner() external view returns (address);
85     function transferOwnership(address newOwner) external;
86 }
87 
88 // File: EverRise-v3/Abstract/Context.sol
89 
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address payable) {
92         return payable(msg.sender);
93     }
94 }
95 
96 
97 // File: EverRise-v3/Interfaces/IERC721-Nft.sol
98 
99 interface IERC721 /* is ERC165 */ {
100     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
101     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
102     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
103     function balanceOf(address _owner) external view returns (uint256);
104     function ownerOf(uint256 _tokenId) external view returns (address);
105     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
106     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
107     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
108     function approve(address _approved, uint256 _tokenId) external payable;
109     function setApprovalForAll(address _operator, bool _approved) external;
110     function getApproved(uint256 _tokenId) external view returns (address);
111     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
112 }
113 
114 // File: EverRise-v3/Interfaces/InftEverRise.sol
115 
116 struct StakingDetails {
117     uint96 initialTokenAmount;    // Max 79 Bn tokens
118     uint96 withdrawnAmount;       // Max 79 Bn tokens
119     uint48 depositTime;           // 8 M years
120     uint8 numOfMonths;            // Max 256 month period
121     uint8 achievementClaimed;
122     // 256 bits, 20000 gwei gas
123     address stakerAddress;        // 160 bits (96 bits remaining)
124     uint32 nftId;                 // Max 4 Bn nfts issued
125     uint32 lookupIndex;           // Max 4 Bn active stakes
126     uint24 stakerIndex;           // Max 16 M active stakes per wallet
127     uint8 isActive;
128     // 256 bits, 20000 gwei gas
129 } // Total 512 bits, 40000 gwei gas
130 
131 interface InftEverRise is IERC721 {
132     function voteEscrowedBalance(address account) external view returns (uint256);
133     function unclaimedRewardsBalance(address account) external view returns (uint256);
134     function totalAmountEscrowed() external view returns (uint256);
135     function totalAmountVoteEscrowed() external view returns (uint256);
136     function totalRewardsDistributed() external view returns (uint256);
137     function totalRewardsUnclaimed() external view returns (uint256);
138 
139     function createRewards(uint256 tAmount) external;
140 
141     function getNftData(uint256 id) external view returns (StakingDetails memory);
142     function enterStaking(address fromAddress, uint96 amount, uint8 numOfMonths) external returns (uint32 nftId);
143     function leaveStaking(address fromAddress, uint256 id, bool overrideNotClaimed) external returns (uint96 amount);
144     function earlyWithdraw(address fromAddress, uint256 id, uint96 amount) external returns (uint32 newNftId, uint96 penaltyAmount);
145     function withdraw(address fromAddress, uint256 id, uint96 amount, bool overrideNotClaimed) external returns (uint32 newNftId);
146     function bridgeStakeNftOut(address fromAddress, uint256 id) external returns (uint96 amount);
147     function bridgeOrAirdropStakeNftIn(address toAddress, uint96 depositAmount, uint8 numOfMonths, uint48 depositTime, uint96 withdrawnAmount, uint96 rewards, bool achievementClaimed) external returns (uint32 nftId);
148     function addStaker(address staker, uint256 nftId) external;
149     function removeStaker(address staker, uint256 nftId) external;
150     function reissueStakeNft(address staker, uint256 oldNftId, uint256 newNftId) external;
151     function increaseStake(address staker, uint256 nftId, uint96 amount) external returns (uint32 newNftId, uint96 original, uint8 numOfMonths);
152     function splitStake(uint256 id, uint96 amount) external payable returns (uint32 newNftId0, uint32 newNftId1);
153     function claimAchievement(address staker, uint256 nftId) external returns (uint32 newNftId);
154     function stakeCreateCost() external view returns (uint256);
155     function approve(address owner, address _operator, uint256 nftId) external;
156 }
157 // File: EverRise-v3/Interfaces/IEverRiseWallet.sol
158 
159 struct ApprovalChecks {
160     // Prevent permits being reused (IERC2612)
161     uint64 nonce;
162     // Allow revoke all spenders/operators approvals in single txn
163     uint32 nftCheck;
164     uint32 tokenCheck;
165     // Allow auto timeout on approvals
166     uint16 autoRevokeNftHours;
167     uint16 autoRevokeTokenHours;
168     // Allow full wallet locking of all transfers
169     uint48 unlockTimestamp;
170 }
171 
172 struct Allowance {
173     uint128 tokenAmount;
174     uint32 nftCheck;
175     uint32 tokenCheck;
176     uint48 timestamp;
177     uint8 nftApproval;
178     uint8 tokenApproval;
179 }
180 
181 interface IEverRiseWallet {
182     event RevokeAllApprovals(address indexed account, bool tokens, bool nfts);
183     event SetApprovalAutoTimeout(address indexed account, uint16 tokensHrs, uint16 nftsHrs);
184     event LockWallet(address indexed account, address altAccount, uint256 length);
185     event LockWalletExtend(address indexed account, uint256 length);
186 }
187 // File: EverRise-v3/Interfaces/IUniswap.sol
188 
189 interface IUniswapV2Factory {
190     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
191     function createPair(address tokenA, address tokenB) external returns (address pair);
192     function setFeeTo(address) external;
193     function setFeeToSetter(address) external;
194     function feeTo() external view returns (address);
195     function feeToSetter() external view returns (address);
196     function getPair(address tokenA, address tokenB) external view returns (address pair);
197     function allPairs(uint256) external view returns (address pair);
198     function allPairsLength() external view returns (uint256);
199 }
200 
201 interface IUniswapV2Pair {
202     event Approval(address indexed owner, address indexed spender, uint256 value);
203     event Transfer(address indexed from, address indexed to, uint256 value);
204     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
205     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
206     event Sync(uint112 reserve0, uint112 reserve1);
207     function approve(address spender, uint256 value) external returns (bool);
208     function transfer(address to, uint256 value) external returns (bool);
209     function transferFrom(address from, address to, uint256 value) external returns (bool);
210     function burn(address to) external returns (uint256 amount0, uint256 amount1);
211     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
212     function skim(address to) external;
213     function sync() external;
214     function initialize(address, address) external;
215     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r,bytes32 s) external;
216     function totalSupply() external view returns (uint256);
217     function balanceOf(address owner) external view returns (uint256);
218     function allowance(address owner, address spender) external view returns (uint256);
219     function DOMAIN_SEPARATOR() external view returns (bytes32);
220     function nonces(address owner) external view returns (uint256);
221     function factory() external view returns (address);
222     function token0() external view returns (address);
223     function token1() external view returns (address);
224     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
225     function price0CumulativeLast() external view returns (uint256);
226     function price1CumulativeLast() external view returns (uint256);
227     function kLast() external view returns (uint256);
228     function name() external pure returns (string memory);
229     function symbol() external pure returns (string memory);
230     function decimals() external pure returns (uint8);
231     function PERMIT_TYPEHASH() external pure returns (bytes32);
232     function MINIMUM_LIQUIDITY() external pure returns (uint256);
233 }
234 
235 interface IUniswapV2Router01 {
236     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
237     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);
238     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);
239     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
240     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB);
241     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH);
242     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB);
243     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH);
244     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
245     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
246     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
247     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
248     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
249     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
250     function factory() external pure returns (address);
251     function WETH() external pure returns (address);
252     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);
253     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut);
254     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn);
255 }
256 
257 interface IUniswapV2Router02 is IUniswapV2Router01 {
258     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH);
259     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);
260     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
261     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;
262     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline ) external;
263 }
264 // File: EverRise-v3/Abstract/ErrorNotZeroAddress.sol
265 
266 contract Ownable is IOwnable, Context {
267     address public owner;
268 
269     function _onlyOwner() private view {
270         if (owner != _msgSender()) revert CallerNotOwner();
271     }
272 
273     modifier onlyOwner() {
274         _onlyOwner();
275         _;
276     }
277 
278     constructor() {
279         address msgSender = _msgSender();
280         owner = msgSender;
281         emit OwnershipTransferred(address(0), msgSender);
282     }
283 
284     // Allow contract ownership and access to contract onlyOwner functions
285     // to be locked using EverOwn with control gated by community vote.
286     //
287     // EverRise ($RISE) stakers become voting members of the
288     // decentralized autonomous organization (DAO) that controls access
289     // to the token contract via the EverRise Ecosystem dApp EverOwn
290     function transferOwnership(address newOwner) external virtual onlyOwner {
291         if (newOwner == address(0)) revert NotZeroAddress();
292 
293         emit OwnershipTransferred(owner, newOwner);
294         owner = newOwner;
295     }
296 }
297 // File: EverRise-v3/Abstract/EverRiseRoles.sol
298 
299 
300 abstract contract EverRiseRoles is Ownable {
301     mapping (Role => mapping (address => bool)) public roles;
302 
303     enum Role 
304     { 
305         NotValidRole, 
306         BuyBack, 
307         NftBridge,
308         Limits, 
309         Liquidity, 
310         Fees,
311         Exchanges,
312         CrossChainBuyback,
313         Upgrader
314     }
315 
316     event ControlAdded(address indexed controller, Role indexed role);
317     event ControlRemoved(address indexed controller, Role indexed role);
318     
319     function _onlyController(Role role) private view {
320         if (!roles[role][_msgSender()]) revert CallerNotApproved();
321     }
322     
323     modifier onlyController(Role role) {
324         _onlyController(role);
325         _;
326     }
327 
328     constructor() {
329         address deployer = _msgSender();
330         ownerRoles(deployer, true);
331     }
332     
333     function transferOwnership(address newOwner) override external onlyOwner {
334         if (newOwner == address(0)) revert NotZeroAddress();
335 
336         address previousOwner = owner;
337         ownerRoles(previousOwner, false);
338         ownerRoles(newOwner, true);
339 
340         owner = newOwner;
341 
342         emit OwnershipTransferred(previousOwner, newOwner);
343     }
344 
345     function ownerRoles(address _owner, bool enable) private {
346         roles[Role.BuyBack][_owner] = enable;
347         roles[Role.NftBridge][_owner] = enable;
348         roles[Role.Limits][_owner] = enable;
349         roles[Role.Liquidity][_owner] = enable;
350         roles[Role.Fees][_owner] = enable;
351         roles[Role.Exchanges][_owner] = enable;
352         roles[Role.CrossChainBuyback][_owner] = enable;
353         roles[Role.Upgrader][_owner] = enable;
354     }
355 
356     function addControlRole(address newController, Role role) external onlyOwner
357     {
358         if (role == Role.NotValidRole) revert NotZero();
359         if (newController == address(0)) revert NotZeroAddress();
360 
361         roles[role][newController] = true;
362 
363         emit ControlAdded(newController, role);
364     }
365 
366     function removeControlRole(address oldController, Role role) external onlyOwner
367     {
368         if (role == Role.NotValidRole) revert NotZero();
369         if (oldController == address(0)) revert NotZeroAddress();
370 
371         roles[role][oldController] = false;
372 
373         emit ControlRemoved(oldController, role);
374     }
375 }
376 // File: EverRise-v3/Abstract/EverRiseLib.sol
377 
378 library EverRiseAddressNumberLib {
379     function toUint96(uint256 value) internal pure returns (uint96) {
380         if (value > type(uint96).max) revert Overflow();
381         return uint96(value);
382     }
383 
384     function isContract(address account) internal view returns (bool) {
385         // This method relies on extcodesize/address.code.length, which returns 0
386         // for contracts in construction, since the code is only stored at the end
387         // of the constructor execution.
388 
389         return account.code.length > 0;
390     }
391 
392     bytes private constant token0Selector =
393         abi.encodeWithSelector(IUniswapV2Pair.token0.selector);
394     bytes private constant token1Selector =
395         abi.encodeWithSelector(IUniswapV2Pair.token1.selector);
396 
397     function pairTokens(address pair) internal view returns (address token0, address token1) {
398         // Do not check if pair is not a contract to avoid warning in txn log
399         if (!isContract(pair)) return (address(0), address(0)); 
400 
401         return (tokenLookup(pair, token0Selector), tokenLookup(pair, token1Selector));
402     }
403 
404     function tokenLookup(address pair, bytes memory selector)
405         private
406         view
407         returns (address)
408     {
409         (bool success, bytes memory data) = pair.staticcall(selector);
410 
411         if (success && data.length >= 32) {
412             return abi.decode(data, (address));
413         }
414         
415         return address(0);
416     }
417 
418 }
419 
420 library EverRiseLib {
421     function swapTokensForEth(
422         IUniswapV2Router02 uniswapV2Router,
423         uint256 tokenAmount
424     ) external {
425         address tokenAddress = address(this);
426         // generate the uniswap pair path of token -> weth
427         address[] memory path = new address[](2);
428         path[0] = tokenAddress;
429         path[1] = uniswapV2Router.WETH();
430 
431         // make the swap
432         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
433             tokenAmount,
434             0, // accept any amount of ETH
435             path,
436             tokenAddress, // The contract
437             block.timestamp
438         );
439     }
440 
441     function swapETHForTokensNoFee(
442         IUniswapV2Router02 uniswapV2Router,
443         address toAddress, 
444         uint256 amount
445     ) external {
446         // generate the uniswap pair path of token -> weth
447         address[] memory path = new address[](2);
448         path[0] = uniswapV2Router.WETH();
449         path[1] = address(this);
450 
451         // make the swap
452         uniswapV2Router.swapExactETHForTokens{
453             value: amount
454         }(
455             0, // accept any amount of Tokens
456             path,
457             toAddress, // The contract
458             block.timestamp
459         );
460     }
461 }
462 // File: EverRise-v3/Interfaces/IEverDrop.sol
463 
464 interface IEverDrop {
465     function mirgateV1V2Holder(address holder, uint96 amount) external returns(bool);
466     function mirgateV2Staker(address toAddress, uint96 rewards, uint96 depositTokens, uint8 numOfMonths, uint48 depositTime, uint96 withdrawnAmount) external returns(uint256 nftId);
467 }
468 // File: EverRise-v3/Interfaces/IERC20-Token.sol
469 
470 interface IERC20 {
471     event Transfer(address indexed from, address indexed to, uint256 value);
472     event Approval(address indexed owner, address indexed spender, uint256 value);
473     function totalSupply() external view returns (uint256);
474     function balanceOf(address account) external view returns (uint256);
475     function transfer(address recipient, uint256 amount) external returns (bool);
476     function allowance(address owner, address spender) external view returns (uint256);
477     function approve(address spender, uint256 amount) external returns (bool);
478     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
479     function transferFromWithPermit(address sender, address recipient, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
480 }
481 
482 interface IERC20Metadata is IERC20 {
483     function name() external view returns (string memory);
484     function symbol() external view returns (string memory);
485     function decimals() external view returns (uint8);
486 }
487 // File: EverRise-v3/Abstract/EverRiseWallet.sol
488 
489 abstract contract EverRiseWallet is Context, IERC2612, IEverRiseWallet, IERC20Metadata {
490     using EverRiseAddressNumberLib for address;
491 
492     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
493     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
494     // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
495     bytes32 public constant DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
496 
497     mapping (address => ApprovalChecks) internal _approvals;
498     mapping (address => mapping (address => Allowance)) public allowances;
499     //Lock related fields
500     mapping(address => address) private _userUnlocks;
501 
502     function _walletLock(address fromAddress) internal view {
503         if (_isWalletLocked(fromAddress)) revert WalletLocked();
504     }
505 
506     modifier walletLock(address fromAddress) {
507         _walletLock(fromAddress);
508         _;
509     }
510     
511     function _isWalletLocked(address fromAddress) internal view returns (bool) {
512         return _approvals[fromAddress].unlockTimestamp > block.timestamp;
513     }
514 
515     function DOMAIN_SEPARATOR() public view returns (bytes32) {
516         // Unique DOMAIN_SEPARATOR per user nbased on their current token check
517         uint32 tokenCheck = _approvals[_msgSender()].tokenCheck;
518 
519         return keccak256(
520             abi.encode(
521                 DOMAIN_TYPEHASH,
522                 keccak256(bytes(name())),
523                 keccak256(abi.encodePacked(tokenCheck)),
524                 block.chainid,
525                 address(this)
526             )
527         );
528     }
529 
530     function name() public virtual view returns (string memory);
531 
532     function nonces(address owner) external view returns (uint256) {
533         return _approvals[owner].nonce;
534     }
535 
536     /**
537      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
538      *
539      * Emits an {ApprovalForAll} event.
540      *
541      * Requirements:
542      *
543      * - `operator` cannot be the caller.
544      */
545     function _setApprovalForAll(address owner, address operator, bool approved) internal {
546         if (operator == address(0)) revert NotZeroAddress();
547 
548         Allowance storage _allowance = allowances[owner][operator];
549         ApprovalChecks storage _approval = _approvals[owner];
550         if (approved) {
551 
552             uint16 autoRevokeNftHours = _approval.autoRevokeNftHours;
553             uint48 timestamp = autoRevokeNftHours == 0 ? 
554                 type(uint48).max : // Don't timeout approval
555                 uint48(block.timestamp) + autoRevokeNftHours * 1 hours; // Timeout after user chosen period
556 
557             _allowance.nftCheck = _approval.nftCheck;
558             _allowance.timestamp = timestamp;
559             _allowance.nftApproval = 1;
560         } else {
561             unchecked {
562                 // nftCheck gets incremented, so set one behind approval
563                 _allowance.nftCheck = _approval.nftCheck - 1;
564             }
565             _allowance.nftApproval = 0;
566         }
567     }
568 
569     function permit(
570         address owner,
571         address spender,
572         uint256 value,
573         uint256 deadline,
574         uint8 v,
575         bytes32 r,
576         bytes32 s
577     ) public {
578         if (spender == address(0)) revert NotZeroAddress();
579         if (deadline < block.timestamp) revert Expired();
580 
581         ApprovalChecks storage _approval = _approvals[owner];
582         uint64 nonce = _approval.nonce;
583 
584         bytes32 digest = keccak256(
585             abi.encodePacked(
586                 "\x19\x01",
587                 DOMAIN_SEPARATOR(),
588                 keccak256(
589                     abi.encode(
590                         PERMIT_TYPEHASH,
591                         owner,
592                         spender,
593                         value,
594                         nonce,
595                         deadline
596                     )
597                 )
598             )
599         );
600 
601         unchecked {
602             // Nonces can wrap
603             ++nonce;
604         }
605 
606         _approval.nonce = nonce;
607         
608         if (v < 27) {
609             v += 27;
610         } else if (v > 30) {
611             digest = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", digest));
612         }
613 
614         address recoveredAddress = ecrecover(digest, v, r, s);
615         if (recoveredAddress == address(0) || recoveredAddress != owner) revert InvalidSignature();
616         
617         _approve(owner, spender, value, true);
618     }
619 
620     function approve(address spender, uint256 amount) external returns (bool) {
621         return _approve(_msgSender(), spender, amount, true);
622     }
623 
624     function _approve(
625         address owner,
626         address spender,
627         uint256 amount,
628         bool extend
629     ) internal returns (bool) {
630         if (owner == address(0)) revert NotZeroAddress();
631         if (spender == address(0)) revert NotZeroAddress();
632 
633         if (amount > type(uint128).max) amount = type(uint128).max;
634 
635         ApprovalChecks storage _approval = _approvals[owner];
636         Allowance storage _allowance = allowances[owner][spender];
637 
638         _allowance.tokenAmount = uint128(amount);
639         _allowance.tokenCheck = _approval.tokenCheck;
640         if (extend) {
641             uint48 autoRevokeTokenHours = _approval.autoRevokeTokenHours;
642             // Time extention approval
643             _allowance.timestamp = autoRevokeTokenHours == 0 ? 
644                 type(uint48).max : // Don't timeout approval
645                 uint48(block.timestamp) + autoRevokeTokenHours * 1 hours; // Timeout after user chosen period
646         }
647 
648         _allowance.tokenApproval = 1;
649         
650         emit Approval(owner, spender, amount);
651         return true;
652     }
653 
654     function allowance(address owner, address spender) public view returns (uint256) {
655         uint32 tokenCheck = _approvals[owner].tokenCheck;
656         Allowance storage allowanceSettings = allowances[owner][spender];
657 
658         if (tokenCheck != allowanceSettings.tokenCheck ||
659             block.timestamp > allowanceSettings.timestamp ||
660             allowanceSettings.tokenApproval != 1)
661         {
662             return 0;
663         }
664 
665         return allowanceSettings.tokenAmount;
666     }
667 
668     function transfer(address recipient, uint256 amount)
669         external
670         override
671         returns (bool)
672     {
673         _transfer(_msgSender(), recipient, amount);
674         return true;
675     }
676 
677     function transferFrom(
678         address sender,
679         address recipient,
680         uint256 amount
681     ) public override returns (bool) {
682 
683         _transfer(sender, recipient, amount);
684 
685         uint256 _allowance = allowance(sender, _msgSender());
686         if (amount > _allowance) revert AmountLargerThanAllowance();
687         unchecked {
688             _allowance -= amount;
689         }
690         _approve(sender, _msgSender(), _allowance, false);
691         return true;
692     }
693 
694     function transferFromWithPermit(
695         address sender,
696         address recipient,
697         uint256 amount,
698         uint256 deadline,
699         uint8 v,
700         bytes32 r,
701         bytes32 s
702     ) external returns (bool) {
703         permit(sender, _msgSender(), amount, deadline, v, r, s);
704 
705         return transferFrom(sender, recipient, amount);
706     }
707 
708     function lockTokensAndNfts(address altAccount, uint48 length) external walletLock(_msgSender()) {
709         if (altAccount == address(0)) revert NotZeroAddress();
710         if (length / 1 days > 10 * 365 days) revert LockTimeTooLong();
711 
712         _approvals[_msgSender()].unlockTimestamp = uint48(block.timestamp) + length;
713         _userUnlocks[_msgSender()] = altAccount;
714 
715         emit LockWallet(_msgSender(), altAccount, length);
716     }
717 
718     function extendLockTokensAndNfts(uint48 length) external {
719         if (length / 1 days > 10 * 365 days) revert LockTimeTooLong();
720         uint48 currentLock = _approvals[_msgSender()].unlockTimestamp;
721 
722         if (currentLock < block.timestamp) revert Unlocked();
723 
724         uint48 newLock = uint48(block.timestamp) + length;
725         if (currentLock > newLock) revert LockTimeTooShort();
726         _approvals[_msgSender()].unlockTimestamp = newLock;
727 
728         emit LockWalletExtend(_msgSender(), length);
729     }
730 
731     function unlockTokensAndNfts(address actualAccount) external {
732         if (_userUnlocks[actualAccount] != _msgSender()) revert CallerNotApproved();
733         uint48 currentLock = _approvals[_msgSender()].unlockTimestamp;
734 
735         if (currentLock < block.timestamp) revert Unlocked();
736 
737         _approvals[_msgSender()].unlockTimestamp = 1;
738     }
739 
740     function revokeApprovals(bool tokens, bool nfts) external {
741         address account = _msgSender();
742         ApprovalChecks storage _approval = _approvals[account];
743 
744         unchecked {
745             // Nonces can wrap
746             if (nfts) {
747                 ++_approval.nftCheck;
748             }
749             if (tokens) {
750                 ++_approval.tokenCheck;
751             }
752         }
753 
754         emit RevokeAllApprovals(account, tokens, nfts);
755     }
756 
757     function setAutoTimeout(uint16 tokensHrs, uint16 nftsHrs) external {
758         address account = _msgSender();
759         ApprovalChecks storage _approval = _approvals[account];
760 
761         _approval.autoRevokeNftHours = nftsHrs;
762         _approval.autoRevokeTokenHours = tokensHrs;
763 
764         emit SetApprovalAutoTimeout(account, tokensHrs, nftsHrs);
765     }
766 
767     /**
768      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
769      *
770      * See {setApprovalForAll}.
771      */
772     function _isApprovedForAll(address account, address operator) internal view returns (bool) {
773         uint32 nftCheck = _approvals[account].nftCheck;
774         Allowance storage _allowance = allowances[account][operator];
775 
776         if (nftCheck != _allowance.nftCheck ||
777             block.timestamp > _allowance.timestamp ||
778             _allowance.nftApproval != 1)
779         {
780             return false;
781         }
782 
783         return true;
784     }
785 
786     function _transfer(
787         address from,
788         address to,
789         uint256 amount
790     ) internal virtual;
791 }
792 // File: EverRise-v3/Interfaces/IEverRise.sol
793 
794 interface IEverRise is IERC20Metadata {
795     function totalBuyVolume() external view returns (uint256);
796     function totalSellVolume() external view returns (uint256);
797     function holders() external view returns (uint256);
798     function uniswapV2Pair() external view returns (address);
799     function transferStake(address fromAddress, address toAddress, uint96 amountToTransfer) external;
800     function isWalletLocked(address fromAddress) external view returns (bool);
801     function setApprovalForAll(address fromAddress, address operator, bool approved) external;
802     function isApprovedForAll(address account, address operator) external view returns (bool);
803     function isExcludedFromFee(address account) external view returns (bool);
804 
805     function approvals(address account) external view returns (ApprovalChecks memory);
806 }
807 // File: EverRise-v3/Abstract/EverRiseConfigurable.sol
808 
809 abstract contract EverRiseConfigurable is EverRiseRoles, EverRiseWallet, IEverRise {
810     using EverRiseAddressNumberLib for uint256;
811 
812     event BuyBackEnabledUpdated(bool enabled);
813     event SwapEnabledUpdated(bool enabled);
814 
815     event ExcludeFromFeeUpdated(address account);
816     event IncludeInFeeUpdated(address account);
817 
818     event LiquidityFeeUpdated(uint256 newValue);
819     event TransactionCapUpdated(uint256 newValue);
820     event MinStakeSizeUpdated(uint256 newValue);
821 
822     event BusinessDevelopmentDivisorUpdated(uint256 newValue);
823     event MinTokensBeforeSwapUpdated(uint256 newValue);
824     event BuybackMinAvailabilityUpdated(uint256 newValue);
825     event MinBuybackAmountUpdated(uint256 newvalue);
826     event MaxBuybackAmountUpdated(uint256 newvalue);
827 
828     event BuybackUpperLimitUpdated(uint256 newValue);
829     event BuyBackTriggerTokenLimitUpdated(uint256 newValue);
830     event BuybackBlocksUpdated(uint256 newValue);
831 
832     event BridgeVaultAddressUpdated(address indexed contractAddress);
833     event BurnAddressUpdated(address indexed deadAddress);
834     event OffChainBalanceExcluded(bool enable);
835     event RouterAddressUpdated(address indexed newAddress);
836     event BusinessDevelopmentAddressUpdated(address indexed newAddress);
837     event StakingAddressUpdated(address indexed contractAddress);
838 
839     event LiquidityLocked(bool isLocked);
840     event AutoBurnEnabled(bool enabled);
841     event BurnableTokensZeroed();
842 
843     event ExchangeHotWalletAdded(address indexed exchangeHotWallet);
844     event ExchangeHotWalletRemoved(address indexed exchangeHotWallet);
845     event BuyBackTriggered();
846     event BuyBackCrossChainTriggered();
847 
848     address payable public businessDevelopmentAddress =
849         payable(0x24D8DAbebD6c0d5CcC88EC40D95Bf8eB64F0CF9E); // Business Development Address
850     address public everBridgeVault;
851     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
852     
853     mapping (address => bool) internal _isExcludedFromFee;
854     mapping (address => bool) internal _exchangeHotWallet;
855 
856     uint8 public constant decimals = 18;
857     // Golden supply
858     uint96 internal immutable _totalSupply = uint96(7_1_618_033_988 * 10**decimals);
859 
860     function totalSupply() external view returns (uint256) {
861         return _totalSupply;
862     }
863 
864     // Fee and max txn are set by setTradingEnabled
865     // to allow upgrading balances to arrange their wallets
866     // and stake their assets before trading start
867 
868     uint256 public totalBuyVolume;
869     uint256 public totalSellVolume;
870     uint256 public transactionCap;
871     uint96 public liquidityFee = 6;
872 
873     uint256 public businessDevelopmentDivisor = 2;
874 
875     uint96 internal _minimumTokensBeforeSwap = uint96(5 * 10**6 * 10**decimals);
876     uint256 internal _buyBackUpperLimit = 10 * 10**18;
877     uint256 internal _buyBackTriggerTokenLimit = 1 * 10**6 * 10**decimals;
878     uint256 internal _buyBackMinAvailability = 1 * 10**18; //1 BNB
879 
880     uint256 internal _nextBuybackAmount;
881     uint256 internal _latestBuybackBlock;
882     uint256 internal _numberOfBlocks = 1000;
883     uint256 internal _minBuybackAmount = 1 * 10**18 / (10**1);
884     uint256 internal _maxBuybackAmount = 1 * 10**18;
885 
886     // Booleans are more expensive than uint256 or any type that takes up a full
887     // word because each write operation emits an extra SLOAD to first read the
888     // slot's contents, replace the bits taken up by the boolean, and then write
889     // back. This is the compiler's defense against contract upgrades and
890     // pointer aliasing, and it cannot be disabled.
891     uint256 constant _FALSE = 1;
892     uint256 constant _TRUE = 2;
893 
894     // The values being non-zero value makes deployment a bit more expensive,
895     // but in exchange the refund on every call to modifiers will be lower in
896     // amount. Since refunds are capped to a percentage of the total
897     // transaction's gas, it is best to keep them low in cases like this one, to
898     // increase the likelihood of the full refund coming into effect.
899     uint256 internal _inSwap = _FALSE;
900     uint256 internal _swapEnabled = _FALSE;
901     uint256 internal _buyBackEnabled = _FALSE;
902     uint256 internal _liquidityLocked = _TRUE;
903     uint256 internal _offchainBalanceExcluded = _FALSE;
904     uint256 internal _autoBurn = _FALSE;
905     uint256 internal _burnableTokens = 1;
906 
907     IUniswapV2Router02 public uniswapV2Router;
908     address public uniswapV2Pair;
909     
910     InftEverRise public stakeToken;
911 
912     function swapEnabled() external view returns (bool) {
913         return _swapEnabled == _TRUE;
914     }
915     function offchainBalanceExcluded() external view returns (bool) {
916         return _offchainBalanceExcluded == _TRUE;
917     }
918     function buyBackEnabled() external view returns (bool) {
919         return _buyBackEnabled == _TRUE;
920     }
921     function liquidityLocked() external view returns (bool) {
922         return _liquidityLocked == _TRUE;
923     }
924     function autoBurn() external view returns (bool) {
925         return _autoBurn == _TRUE;
926     }
927 
928     function setBurnableTokensZero() external onlyController(Role.Liquidity)  {
929         // set to 1 rather than zero to save on gas
930         _burnableTokens = 1;
931         emit BurnableTokensZeroed();
932     }
933     function setBurnAddress(address _burnAddress) external onlyController(Role.Liquidity)  {
934         // May be bridgable burn (so only send to actual burn address on one chain)
935         burnAddress = _burnAddress;
936         emit BurnAddressUpdated(_burnAddress);
937     }
938 
939     function setOffchainBalanceExcluded(bool _enabled) external onlyOwner {
940         _offchainBalanceExcluded = _enabled ? _TRUE : _FALSE;
941         emit OffChainBalanceExcluded(_enabled);
942     }
943 
944     function setLiquidityLock(bool _enabled) public onlyController(Role.Liquidity) {
945         _liquidityLocked = _enabled ? _TRUE : _FALSE;
946         emit LiquidityLocked(_enabled);
947     }
948 
949     function setAutoBurn(bool _enabled) external onlyController(Role.Liquidity) {
950         _autoBurn = _enabled ? _TRUE : _FALSE;
951         emit AutoBurnEnabled(_enabled);
952     }
953 
954     function excludeFromFee(address account) public onlyController(Role.Fees) {
955         if (_isExcludedFromFee[account]) revert InvalidAddress();
956         
957         _isExcludedFromFee[account] = true;
958         emit ExcludeFromFeeUpdated(account);
959     }
960 
961     function addExchangeHotWallet(address account) external onlyController(Role.Exchanges) {
962         _exchangeHotWallet[account] = true;
963         emit ExchangeHotWalletAdded(account);
964     }
965 
966     function removeExchangeHotWallet(address account) external onlyController(Role.Exchanges) {
967         _exchangeHotWallet[account] = false;
968         emit ExchangeHotWalletRemoved(account);
969     }
970 
971     function isExchangeHotWallet(address account) public view returns(bool) {
972         return _exchangeHotWallet[account];
973     }
974 
975     function includeInFee(address account) external onlyController(Role.Fees) {
976         if (!_isExcludedFromFee[account]) revert InvalidAddress();
977 
978         _isExcludedFromFee[account] = false;
979         emit IncludeInFeeUpdated(account);
980     }
981 
982     function setTransactionCap(uint256 txAmount) external onlyController(Role.Limits) {
983         // Never under 0.001%
984         if (txAmount < _totalSupply / 100_000) revert AmountOutOfRange();
985 
986         transactionCap = txAmount;
987         emit TransactionCapUpdated(txAmount);
988     }
989 
990     function setNumberOfBlocksForBuyback(uint256 value) external onlyController(Role.BuyBack){
991         if (value < 100 || value > 1_000_000) revert AmountOutOfRange();
992         _numberOfBlocks = value;
993         emit BuybackBlocksUpdated(value);
994     }
995 
996     function setBusinessDevelopmentDivisor(uint256 divisor) external onlyController(Role.Liquidity) {
997         if (divisor > liquidityFee) revert AmountOutOfRange();
998 
999         businessDevelopmentDivisor = divisor;
1000         emit BusinessDevelopmentDivisorUpdated(divisor);
1001     }
1002 
1003     function setNumTokensSellToAddToLiquidity(uint96 minimumTokensBeforeSwap)
1004         external
1005         onlyController(Role.Liquidity)
1006     {
1007         if (minimumTokensBeforeSwap > 1_000_000_000) revert AmountOutOfRange();
1008 
1009         _minimumTokensBeforeSwap = uint96(minimumTokensBeforeSwap * (10**uint256(decimals)));
1010         emit MinTokensBeforeSwapUpdated(minimumTokensBeforeSwap);
1011     }
1012 
1013     function setBuybackUpperLimit(uint256 buyBackLimit, uint256 numOfDecimals)
1014         external
1015         onlyController(Role.BuyBack)
1016     {
1017         // Catch typos, if decimals are pre-added
1018         if (buyBackLimit > 1_000_000_000) revert AmountOutOfRange();
1019 
1020         _buyBackUpperLimit = buyBackLimit * (10**18) / (10**numOfDecimals);
1021         emit BuybackUpperLimitUpdated(_buyBackUpperLimit);
1022     }
1023 
1024     function setMinBuybackAmount(uint256 minAmount, uint256 numOfDecimals)
1025         external
1026         onlyController(Role.BuyBack)
1027     {
1028         // Catch typos, if decimals are pre-added
1029         if (minAmount > 1_000) revert AmountOutOfRange();
1030 
1031         _minBuybackAmount = minAmount * (10**18) / (10**numOfDecimals);
1032         emit MinBuybackAmountUpdated(minAmount);
1033     }
1034 
1035     function setMaxBuybackAmountUpdated(uint256 maxAmount, uint256 numOfDecimals)
1036         external
1037         onlyController(Role.BuyBack)
1038     {
1039         // Catch typos, if decimals are pre-added
1040         if (maxAmount > 1_000_000) revert AmountOutOfRange();
1041 
1042         _maxBuybackAmount = maxAmount * (10**18) / (10**numOfDecimals);
1043         emit MaxBuybackAmountUpdated(maxAmount);
1044     }
1045 
1046     function setBuybackTriggerTokenLimit(uint256 buyBackTriggerLimit)
1047         external
1048         onlyController(Role.BuyBack)
1049     {
1050         if (buyBackTriggerLimit > 100_000_000) revert AmountOutOfRange();
1051         
1052         _buyBackTriggerTokenLimit = buyBackTriggerLimit * (10**uint256(decimals));
1053         emit BuyBackTriggerTokenLimitUpdated(_buyBackTriggerTokenLimit);
1054     }
1055 
1056     function setBuybackMinAvailability(uint256 amount, uint256 numOfDecimals)
1057         external
1058         onlyController(Role.BuyBack)
1059     {
1060         if (amount > 100_000) revert AmountOutOfRange();
1061 
1062         _buyBackMinAvailability = amount * (10**18) / (10**numOfDecimals);
1063         emit BuybackMinAvailabilityUpdated(_buyBackMinAvailability);
1064     }
1065 
1066     function setBuyBackEnabled(bool _enabled) external onlyController(Role.BuyBack) {
1067         _buyBackEnabled = _enabled ? _TRUE : _FALSE;
1068         emit BuyBackEnabledUpdated(_enabled);
1069     }
1070 
1071     function setBusinessDevelopmentAddress(address newAddress)
1072         external
1073         onlyController(Role.Liquidity)
1074     {
1075         if (newAddress == address(0)) revert NotZeroAddress();
1076 
1077         businessDevelopmentAddress = payable(newAddress);
1078         emit BusinessDevelopmentAddressUpdated(newAddress);
1079     }
1080 
1081     function setEverBridgeVaultAddress(address contractAddress)
1082         external
1083         onlyOwner
1084     {
1085         
1086         excludeFromFee(contractAddress);
1087         
1088         everBridgeVault = contractAddress;
1089         emit BridgeVaultAddressUpdated(contractAddress);
1090     }
1091 
1092     function setStakingAddress(address contractAddress) external onlyOwner {
1093         stakeToken = InftEverRise(contractAddress);
1094 
1095         excludeFromFee(contractAddress);
1096 
1097         emit StakingAddressUpdated(contractAddress);
1098     }
1099 
1100     function setRouterAddress(address newAddress) external onlyController(Role.Liquidity) {
1101         if (newAddress == address(0)) revert NotZeroAddress();
1102 
1103         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newAddress); 
1104         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(
1105             address(this),
1106             _uniswapV2Router.WETH()
1107         );
1108 
1109         uniswapV2Router = _uniswapV2Router;
1110         emit RouterAddressUpdated(newAddress);
1111     }
1112 
1113     function isExcludedFromFee(address account) external view returns (bool) {
1114         return _isExcludedFromFee[account];
1115     }
1116 
1117     function setSwapEnabled(bool _enabled) external onlyOwner {
1118         _swapEnabled = _enabled ? _TRUE : _FALSE;
1119         emit SwapEnabledUpdated(_enabled);
1120     }
1121 
1122     function hasTokenStarted() public view returns (bool) {
1123         return transactionCap > 0;
1124     }
1125 
1126     function setLiquidityFeePercent(uint96 liquidityFeeRate) external onlyController(Role.Liquidity) {
1127         if (liquidityFeeRate > 10) revert AmountOutOfRange();
1128         liquidityFee = liquidityFeeRate;
1129         emit LiquidityFeeUpdated(liquidityFeeRate);
1130     }
1131 }
1132 // File: EverRise-v3/EverRise.sol
1133 
1134 // Copyright (c) 2022 EverRise Pte Ltd. All rights reserved.
1135 // EverRise licenses this file to you under the MIT license.
1136 /*
1137  The EverRise token is the keystone in the EverRise Ecosytem of dApps
1138  and the overaching key that unlocks multi-blockchain unification via
1139  the EverBridge.
1140 
1141  On EverRise token txns 6% buyback and business development fees are collected
1142  * 4% for token Buyback from the market, 
1143      with bought back tokens directly distributed as ve-staking rewards
1144  * 2% for Business Development (Development, Sustainability and Marketing)
1145 
1146   ________                              _______   __
1147  /        |                            /       \ /  |
1148  $$$$$$$$/__     __  ______    ______  $$$$$$$  |$$/   _______   ______  v3.14159265
1149  $$ |__  /  \   /  |/      \  /      \ $$ |__$$ |/  | /       | /      \
1150  $$    | $$  \ /$$//$$$$$$  |/$$$$$$  |$$    $$< $$ |/$$$$$$$/ /$$$$$$  |
1151  $$$$$/   $$  /$$/ $$    $$ |$$ |  $$/ $$$$$$$  |$$ |$$      \ $$    $$ |
1152  $$ |_____ $$ $$/  $$$$$$$$/ $$ |      $$ |  $$ |$$ | $$$$$$  |$$$$$$$$/
1153  $$       | $$$/   $$       |$$ |      $$ |  $$ |$$ |/     $$/ $$       |
1154  $$$$$$$$/   $/     $$$$$$$/ $$/       $$/   $$/ $$/ $$$$$$$/   $$$$$$$/
1155 
1156  Learn more about EverRise and the EverRise Ecosystem of dApps and
1157  how our utilities and partners can help protect your investors
1158  and help your project grow: https://www.everrise.com
1159 */
1160 
1161 // 2^96 is 79 * 10**10 * 10**18
1162 struct TransferDetails {
1163     uint96 balance0;
1164     address to;
1165 
1166     uint96 balance1;
1167     address origin;
1168 
1169     uint32 blockNumber;
1170 }
1171 
1172 contract EverRise is EverRiseConfigurable, IEverDrop {
1173     using EverRiseAddressNumberLib for address;
1174     using EverRiseAddressNumberLib for uint256;
1175 
1176     event BuybackTokensWithETH(uint256 amountIn, uint256 amountOut);
1177     event ConvertTokensForETH(uint256 amountIn, uint256 amountOut);
1178 
1179     event TokenStarted();
1180     event RewardStakers(uint256 amount);
1181     event AutoBurn(uint256 amount);
1182 
1183     event StakingIncreased(address indexed from, uint256 amount, uint8 numberOfmonths);
1184     event StakingDecreased(address indexed from, uint256 amount);
1185 
1186     event RiseBridgedIn(address indexed contractAddress, address indexed to, uint256 amount);
1187     event RiseBridgedOut(address indexed contractAddress, address indexed from, uint256 amount);
1188     event NftBridgedIn(address indexed contractAddress, address indexed operator, address indexed to, uint256 id, uint256 value);
1189     event NftBridgedOut(address indexed contractAddress, address indexed operator, address indexed from, uint256 id, uint256 value);
1190     event TransferExternalTokens(address indexed tokenAddress, address indexed to, uint256 count);
1191 
1192     // Holder count
1193     uint256 private _holders;
1194     // Balance and locked (staked) balance
1195     mapping (address => uint96) private _tOwned;
1196     mapping (address => uint96) private _amountLocked;
1197 
1198     // Tracking for protections against sandwich trades
1199     // and rogue LP pairs
1200     mapping (address => uint256) private _lastTrade;
1201     TransferDetails private _lastTransfer;
1202 
1203     string public constant symbol = "RISE";
1204     function name() public override (EverRiseWallet, IERC20Metadata) pure returns (string memory) {
1205         return "EverRise";
1206     }
1207 
1208     modifier lockTheSwap() {
1209         require(_inSwap != _TRUE);
1210         _inSwap = _TRUE;
1211         _;
1212         // By storing the original value once again, a refund is triggered (see
1213         // https://eips.ethereum.org/EIPS/eip-2200)
1214         _inSwap = _FALSE;
1215     }
1216 
1217     constructor(address routerAddress) {
1218         if (routerAddress == address(0)) revert NotZeroAddress();
1219 
1220         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerAddress);
1221         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //Pancakeswap router mainnet - BSC
1222         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1); //Testnet
1223         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xa5e0829caced8ffdd4de3c43696c57f7d7a678ff); //Quickswap V2 router mainnet - Polygon
1224         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506); //Sushiswap router mainnet - Polygon
1225         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uniswap V2 router mainnet - ETH
1226         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1227             .createPair(address(this), _uniswapV2Router.WETH());
1228 
1229         uniswapV2Router = _uniswapV2Router;
1230   
1231         _isExcludedFromFee[owner] = true;
1232         _isExcludedFromFee[address(this)] = true;
1233 
1234         // Put all tokens in contract so we can airdrop
1235         _tOwned[address(this)] = _totalSupply;
1236         emit Transfer(address(0), address(this), _totalSupply);
1237 
1238         _holders = 1;
1239     }
1240 
1241     // Function to receive ETH when msg.data is be empty
1242     receive() external payable {}
1243 
1244     // Balances
1245     function isWalletLocked(address fromAddress) override (IEverRise) external view returns (bool) {
1246         return _isWalletLocked(fromAddress);
1247     }
1248 
1249     function holders() external view returns (uint256) {
1250         return _holders;
1251     }
1252 
1253     function getAmountLocked(address account) external view returns (uint256) {
1254         return _amountLocked[account];
1255     }
1256 
1257     function _balanceOf(address account) private view returns (uint256) {
1258         return _tOwned[account];
1259     }
1260 
1261     function bridgeVaultLockedBalance() external view returns (uint256) {
1262         return _balanceOf(everBridgeVault);
1263     }
1264 
1265     function balanceOf(address account) external view override returns (uint256) {
1266         // Bridge vault balances are on other chains
1267         if (account == everBridgeVault && _offchainBalanceExcluded == _TRUE) return 0;
1268 
1269         uint256 balance = _balanceOf(account);
1270         if (_inSwap != _TRUE &&
1271             _lastTransfer.blockNumber == uint32(block.number) &&
1272             account.isContract() &&
1273             !_isExcludedFromFee[account]
1274         ) {
1275             // Balance being checked is same address as last to in _transfer
1276             // check if likely same txn and a Liquidity Add
1277             _validateIfLiquidityChange(account, uint112(balance));
1278         }
1279 
1280         return balance;
1281     }
1282 
1283     // Transfers
1284 
1285     function approvals(address account) external view returns (ApprovalChecks memory) {
1286         return _approvals[account]; 
1287     }
1288     
1289     function _transfer(
1290         address from,
1291         address to,
1292         uint256 amount
1293     ) internal override walletLock(from) {
1294         if (from == address(0) || to == address(0)) revert NotZeroAddress();
1295         if (amount == 0) revert AmountMustBeGreaterThanZero();
1296         if (amount > (_balanceOf(from) - _amountLocked[from])) revert AmountLargerThanUnlockedAmount();
1297 
1298         bool isIgnoredAddress = _isExcludedFromFee[from] || _isExcludedFromFee[to];
1299 
1300         bool notInSwap = _inSwap != _TRUE;
1301         bool hasStarted = hasTokenStarted();
1302         address pair = uniswapV2Pair;
1303         bool isSell = to == pair;
1304         bool isBuy = from == pair;
1305         if (!isIgnoredAddress) {
1306             if (to == address(this)) revert NotContractAddress();
1307             if (amount > transactionCap) revert TransferTooLarge();
1308             if (!hasStarted) revert TokenNotStarted();
1309             if (notInSwap) {
1310                 // Disallow multiple same source trades in same block
1311                 if ((isSell || isBuy) && _lastTrade[tx.origin] == block.number) {
1312                     revert SandwichTradesAreDisallowed();
1313                 }
1314 
1315                 _lastTrade[tx.origin] = block.number;
1316 
1317                 // Following block is for the contract to convert the tokens to ETH and do the buy back
1318                 if (isSell && _swapEnabled == _TRUE) {
1319                     uint96 swapTokens = _minimumTokensBeforeSwap;
1320                     if (_balanceOf(address(this)) > swapTokens) {
1321                         // Greater than to always leave at least 1 token in contract
1322                         // reducing gas from switching from 0 to not-zero and not tracking
1323                         // token in holder count changes.
1324                         _convertTokens(swapTokens);
1325                     }
1326 
1327                     if (_buyback()) {
1328                         emit BuyBackTriggered();
1329                     }
1330                 }
1331             }
1332         }
1333 
1334         if (hasStarted) {
1335             if (isBuy) {
1336                 totalBuyVolume += amount;
1337             } else if (isSell) { 
1338                 totalSellVolume += amount;
1339                 if (amount > _buyBackTriggerTokenLimit) {
1340                     // Start at 1% of balance
1341                     uint256 amountToAdd = address(this).balance / 100;
1342                     uint256 maxToAdd = _buyBackUpperLimit / 100;
1343                     // Don't add more than the 1% of the upper limit
1344                     if (amountToAdd > maxToAdd) amountToAdd = maxToAdd;
1345                     // Add to next buyback
1346                     _nextBuybackAmount += amountToAdd;
1347                 }
1348             }
1349         }
1350 
1351         // If any account belongs to _isExcludedFromFee account then remove the fee
1352         bool takeFee = true;
1353         if (isIgnoredAddress || isExchangeHotWallet(to)) {
1354             takeFee = false;
1355         }
1356         
1357         // For safety Liquidity Adds should only be done by an owner, 
1358         // and transfers to and from EverRise Ecosystem contracts
1359         // are not considered LP adds
1360         if (notInSwap) {
1361             if (isIgnoredAddress) {
1362                 // Just set blocknumber to 1 to clear, to save gas on changing back
1363                 _lastTransfer.blockNumber = 1;
1364             } else {
1365                 // Not in a swap during a LP add, so record the transfer details
1366                 _recordPotentialLiquidityChangeTransaction(to);
1367             }
1368         }
1369 
1370         _tokenTransfer(from, to, uint96(amount), takeFee);
1371     }
1372 
1373     function _tokenTransfer(
1374         address sender,
1375         address recipient,
1376         uint96 amount,
1377         bool takeFee
1378     ) private {
1379         uint96 fromAfter = _tOwned[sender] - amount;
1380         _tOwned[sender] = fromAfter;
1381 
1382         uint96 tLiquidity = takeFee ? amount * liquidityFee / (10**2) : 0;
1383         uint96 tTransferAmount = amount - tLiquidity;
1384 
1385         uint96 toBefore = _tOwned[recipient]; 
1386         _tOwned[recipient] = toBefore + tTransferAmount;
1387 
1388         if (tLiquidity > 0) {
1389             // Skip writing to save gas if unchanged
1390             _tOwned[address(this)] += tLiquidity;
1391         }
1392 
1393         _trackHolders(fromAfter, toBefore);
1394         if (sender == everBridgeVault) {
1395             emit RiseBridgedIn(everBridgeVault, recipient, amount);
1396         } else if (recipient == everBridgeVault) {
1397             emit RiseBridgedOut(everBridgeVault, sender, amount);
1398         }
1399 
1400         emit Transfer(sender, recipient, tTransferAmount);
1401     }
1402 
1403     function _lockedTokenTransfer(
1404         address sender,
1405         address recipient,
1406         uint96 amount
1407     ) private {
1408         // Do the locked token transfer
1409         _decreaseLockedAmount(sender, amount, false);
1410         uint96 fromAfter = _tOwned[sender] - amount;
1411         _tOwned[sender] = fromAfter;
1412         
1413         uint96 toBefore = _tOwned[recipient]; 
1414         _tOwned[recipient] = toBefore + amount;
1415         _increaseLockedAmount(recipient, amount);
1416 
1417         _trackHolders(fromAfter, toBefore);
1418 
1419         emit Transfer(sender, recipient, amount);
1420     }
1421 
1422     function _trackHolders(uint96 fromAfter, uint96 toBefore) private {
1423         uint256 startHolderCount = _holders;
1424         uint256 holderCount = startHolderCount;
1425         
1426         if (fromAfter == 0) --holderCount;
1427         if (toBefore == 0) ++holderCount;
1428 
1429         if (startHolderCount != holderCount) {
1430             // Skip writing to save gas if unchanged
1431             _holders = holderCount;
1432         }
1433     }
1434 
1435     // Buyback
1436     function crossChainBuyback() external onlyController(Role.CrossChainBuyback) {
1437         if (_buyback()) {
1438             emit BuyBackCrossChainTriggered();
1439         }
1440 
1441         // Is autoburn on?
1442         if (_autoBurn == _TRUE) {
1443             uint96 swapTokens = _minimumTokensBeforeSwap;
1444             // Have we collected enough tokens to burn?
1445             if (_burnableTokens > swapTokens) {
1446                 unchecked {
1447                     // Just confirmed is valid above
1448                     _burnableTokens -= swapTokens;
1449                 }
1450                 // Burn the tokens
1451                 _tokenTransfer(uniswapV2Pair, burnAddress, swapTokens, false);
1452                 // Reset LP balances
1453                 IUniswapV2Pair(uniswapV2Pair).sync();
1454 
1455                 emit AutoBurn(swapTokens);
1456             }
1457         }
1458     }
1459 
1460     function _buyback() private returns (bool boughtBack) {
1461         if (_buyBackEnabled == _TRUE) {
1462             uint256 balance = address(this).balance;
1463             if (balance > _buyBackMinAvailability &&
1464                 block.number > _latestBuybackBlock + _numberOfBlocks 
1465             ) {
1466                 // Max of 10% of balance
1467                 balance /= 10;
1468                 uint256 buybackAmount = _nextBuybackAmount;
1469                 if (buybackAmount > _maxBuybackAmount) {
1470                     buybackAmount = _maxBuybackAmount;
1471                 }
1472                 if (buybackAmount > balance) {
1473                     // Don't try to buyback more than is available.
1474                     buybackAmount = balance;
1475                 }
1476 
1477                 if (buybackAmount > 0) {
1478                     boughtBack = _buyBackTokens(buybackAmount);
1479                 }
1480             }
1481         }
1482     }
1483 
1484     function _buyBackTokens(uint256 amount) private lockTheSwap returns (bool boughtBack) {
1485         _nextBuybackAmount = _minBuybackAmount; // reset the next buyback amount, set non-zero to save on future gas
1486 
1487         if (amount > 0) {
1488             uint256 tokensBefore = _balanceOf(address(stakeToken));
1489             EverRiseLib.swapETHForTokensNoFee(uniswapV2Router, address(stakeToken), amount);
1490             // Don't trust the return value; calculate it ourselves
1491             uint256 tokensReceived = _balanceOf(address(stakeToken)) - tokensBefore;
1492 
1493             emit BuybackTokensWithETH(amount, tokensReceived);
1494             _latestBuybackBlock = block.number;
1495             //Distribute the rewards to the staking pool
1496             _distributeStakingRewards(tokensReceived);
1497 
1498             boughtBack = true;
1499         }
1500     }
1501     
1502     // Non-EverSwap LP conversion
1503     function _convertTokens(uint256 tokenAmount) private lockTheSwap {
1504         uint256 initialETHBalance = address(this).balance;
1505 
1506         _approve(address(this), address(uniswapV2Router), tokenAmount, true);
1507         // Mark the tokens as available to burn
1508         _burnableTokens += uint96(tokenAmount);
1509 
1510         EverRiseLib.swapTokensForEth(uniswapV2Router, tokenAmount);
1511 
1512         uint256 transferredETHBalance = address(this).balance - initialETHBalance;
1513         emit ConvertTokensForETH(tokenAmount, transferredETHBalance);
1514 
1515         // Send split to Business Development address
1516         transferredETHBalance = transferredETHBalance * businessDevelopmentDivisor / liquidityFee;
1517         sendEthViaCall(businessDevelopmentAddress, transferredETHBalance);
1518     }
1519 
1520     // Staking
1521 
1522     function _distributeStakingRewards(uint256 amount) private {
1523         if (amount > 0) {
1524             stakeToken.createRewards(amount);
1525 
1526             emit RewardStakers(amount);
1527         }
1528     }
1529     
1530     function transferStake(address fromAddress, address toAddress, uint96 amountToTransfer) external walletLock(fromAddress) {
1531         if (_msgSender() != address(stakeToken)) revert NotStakeContractRequesting();
1532 
1533         _lockedTokenTransfer(fromAddress, toAddress, amountToTransfer);
1534     }
1535 
1536     function enterStaking(uint96 amount, uint8 numOfMonths) external payable walletLock(_msgSender()) {
1537         address staker = _msgSender();
1538         if (msg.value < stakeToken.stakeCreateCost()) revert NotEnoughToCoverStakeFee();
1539 
1540         uint32 nftId = stakeToken.enterStaking(staker, amount, numOfMonths);
1541 
1542         _lockAndAddStaker(staker, amount, numOfMonths, nftId);
1543     }
1544 
1545     function increaseStake(uint256 nftId, uint96 amount)
1546         external walletLock(_msgSender())
1547     {
1548         address staker = _msgSender();
1549         _increaseLockedAmount(staker, amount);
1550 
1551         uint8 numOfMonths;
1552         uint96 original;
1553         (, original, numOfMonths) = stakeToken.increaseStake(staker, nftId, amount);
1554 
1555         emit StakingDecreased(staker, original);
1556         emit StakingIncreased(staker, original + amount, numOfMonths);
1557     }
1558 
1559     function _increaseLockedAmount(address staker, uint96 amount) private {
1560         uint96 lockedAmount = _amountLocked[staker] + amount;
1561         if (lockedAmount > _balanceOf(staker)) revert AmountLargerThanUnlockedAmount();
1562         _amountLocked[staker] = lockedAmount;
1563         
1564         emit Transfer(staker, staker, amount);
1565     }
1566 
1567     function _decreaseLockedAmount(address staker, uint96 amount, bool emitEvent) private {
1568         _amountLocked[staker] -= amount;
1569         if (emitEvent) {
1570             emit StakingDecreased(staker, amount);
1571             emit Transfer(staker, staker, amount);
1572         }
1573     }
1574 
1575     function leaveStaking(uint256 nftId, bool overrideNotClaimed) external walletLock(_msgSender()) {
1576         address staker = _msgSender();
1577 
1578         uint96 amount = stakeToken.leaveStaking(staker, nftId, overrideNotClaimed);
1579         _decreaseLockedAmount(staker, amount, true);
1580         stakeToken.removeStaker(staker, nftId);
1581     }
1582 
1583     function earlyWithdraw(uint256 nftId, uint96 amount) external walletLock(_msgSender()) {
1584         address staker = _msgSender();
1585 
1586         (uint32 newNftId, uint96 penaltyAmount) = stakeToken.earlyWithdraw(staker, nftId, amount);
1587         _decreaseLockedAmount(staker, amount, true);
1588         
1589         if (penaltyAmount > 0) {
1590             _tokenTransfer(staker, address(stakeToken), penaltyAmount, false);
1591             _distributeStakingRewards(penaltyAmount);
1592         }
1593 
1594         stakeToken.reissueStakeNft(staker, nftId, newNftId);
1595     }
1596 
1597     function withdraw(uint256 nftId, uint96 amount, bool overrideNotClaimed) external walletLock(_msgSender()) {
1598         address staker = _msgSender();
1599 
1600         (uint32 newNftId) = stakeToken.withdraw(staker, nftId, amount, overrideNotClaimed);
1601         if (amount > 0) {
1602             _decreaseLockedAmount(staker, amount, true);
1603         }
1604         if (nftId != newNftId && newNftId != 0) {
1605             stakeToken.reissueStakeNft(staker, nftId, newNftId);
1606         }
1607     }
1608 
1609     function setApprovalForAll(address fromAddress, address operator, bool approved) external {
1610         if (_msgSender() != address(stakeToken)) revert NotStakeContractRequesting();
1611 
1612         _setApprovalForAll(fromAddress, operator, approved);
1613     }
1614 
1615     function isApprovedForAll(address account, address operator) external view returns (bool) {
1616         if (_msgSender() != address(stakeToken)) revert NotStakeContractRequesting();
1617 
1618         return _isApprovedForAll(account, operator);
1619     }
1620     
1621     // Nft bridging
1622     function approveNFTAndTokens(address bridgeAddress, uint256 nftId, uint256 tokenAmount) external {
1623         if (!roles[Role.NftBridge][bridgeAddress]) revert NotContractAddress();
1624 
1625         stakeToken.approve(_msgSender(), bridgeAddress, nftId);
1626         _approve(_msgSender(), bridgeAddress, tokenAmount, true);
1627     }
1628 
1629     function bridgeStakeNftOut(address fromAddress, uint256 nftId) external onlyController(Role.NftBridge) {
1630         if (stakeToken.getApproved(nftId) != _msgSender() && !stakeToken.isApprovedForAll(_msgSender(), fromAddress)) {
1631             revert CallerNotApproved();
1632         }
1633         
1634         _walletLock(fromAddress);
1635 
1636         uint96 amount = stakeToken.bridgeStakeNftOut(fromAddress, nftId);
1637         _decreaseLockedAmount(fromAddress, amount, true);
1638         // Send tokens to vault
1639         _tokenTransfer(fromAddress, everBridgeVault, amount, false);
1640 
1641         stakeToken.removeStaker(fromAddress, nftId);
1642         emit NftBridgedOut(address(this), everBridgeVault, fromAddress, nftId, amount);
1643     }
1644 
1645     function bridgeStakeNftIn(address toAddress, uint96 depositTokens, uint8 numOfMonths, uint48 depositTime, uint96 withdrawnAmount, bool achievementClaimed) external onlyController(Role.NftBridge) returns (uint256 nftId)
1646     {
1647         nftId = stakeToken.bridgeOrAirdropStakeNftIn(toAddress, depositTokens, numOfMonths, depositTime, withdrawnAmount, 0, achievementClaimed);
1648 
1649         uint96 amount = depositTokens - withdrawnAmount;
1650         //Send the tokens from Vault
1651         _tokenTransfer(everBridgeVault, toAddress, amount, false);
1652 
1653         _lockAndAddStaker(toAddress, amount, numOfMonths, nftId);
1654 
1655         emit NftBridgedIn(address(this), everBridgeVault, toAddress, nftId, amount);
1656     }
1657 
1658     function _lockAndAddStaker(address toAddress, uint96 amount, uint8 numOfMonths, uint256 nftId) private {
1659         _increaseLockedAmount(toAddress, amount);
1660         stakeToken.addStaker(toAddress, nftId);
1661 
1662         emit StakingIncreased(toAddress, amount, numOfMonths);
1663     }
1664 
1665     // Liquidity
1666 
1667     function _recordPotentialLiquidityChangeTransaction(address to) private {
1668         uint96 balance0 = uint96(_balanceOf(to));
1669         (address token0, address token1) = to.pairTokens();
1670         if (token1 == address(this)) {
1671             // Switch token so token1 is always other side of pair
1672             token1 = token0;
1673         } 
1674         
1675         if (token1 == address(0)) {
1676             // Not LP pair, just set blocknumber to 1 to clear, to save gas on changing back
1677             _lastTransfer.blockNumber = 1;
1678             return;
1679         }
1680         
1681         uint96 balance1 = uint96(IERC20(token1).balanceOf(to));
1682 
1683         _lastTransfer = TransferDetails({
1684             balance0: balance0,
1685             to: to,
1686             balance1: balance1,
1687             origin: tx.origin,
1688             blockNumber: uint32(block.number)
1689         });
1690     }
1691 
1692     // account must be recorded in _transfer and same block
1693     function _validateIfLiquidityChange(address account, uint112 balance0) private view {
1694         if (_lastTransfer.origin != tx.origin ||
1695             account != _lastTransfer.to) {
1696             // Not same txn, or not LP addETH
1697             return;
1698         }
1699 
1700         // Check if LP change using the data recorded in _transfer
1701         // May be same transaction as _transfer
1702         (address token0, address token1) = account.pairTokens();
1703         // Not LP pair
1704         if (token1 == address(0)) return;
1705         bool switchTokens;
1706         if (token1 == address(this)) {
1707             // Switch token so token1 is always other side of pair
1708             token1 = token0;
1709             switchTokens = true;
1710         } else if (token0 != address(this)) {
1711             // Not LP for this token
1712             return;
1713         }
1714 
1715         uint256 balance1 = IERC20(token1).balanceOf(account);
1716         // Test to see if this tx is part of a liquidity add
1717         if (balance0 > _lastTransfer.balance0 &&
1718             balance1 > _lastTransfer.balance1) {
1719             // Both pair balances have increased, this is a Liquidty Add
1720             // Will block addETH and where other token address sorts higher
1721             revert LiquidityAddOwnerOnly();
1722         }
1723     }
1724 
1725     // Admin
1726 
1727     function upgradeComplete() external onlyOwner {
1728         // Can only be called before start
1729         if (hasTokenStarted()) revert TokenAlreadyStarted();
1730 
1731         // We will keep one token always in contract
1732         // so we don't need to track it in holder changes
1733         _tokenTransfer(address(this), _msgSender(), _tOwned[address(this)] - 1, false);
1734 
1735         _buyBackEnabled = _TRUE;
1736         _swapEnabled = _TRUE;
1737         transactionCap = _totalSupply / 1000; // Max txn 0.1% of supply
1738 
1739         emit TokenStarted();
1740     }
1741 
1742     function sendEthViaCall(address payable to, uint256 amount) private {
1743         (bool sent, ) = to.call{value: amount}("");
1744         if (!sent) revert FailedEthSend();
1745     }
1746 
1747     function transferBalance(uint256 amount) external onlyOwner {
1748         sendEthViaCall(_msgSender(), amount);
1749     }
1750 
1751     function transferExternalTokens(address tokenAddress, address to, uint256 amount) external onlyOwner {
1752         if (tokenAddress == address(0)) revert NotZeroAddress();
1753 
1754         transferTokens(tokenAddress, to, amount);
1755     }
1756 
1757     function transferTokens(address tokenAddress, address to, uint256 amount) private {
1758         IERC20(tokenAddress).transfer(to, amount);
1759 
1760         emit TransferExternalTokens(tokenAddress, to, amount);
1761     }
1762 
1763     function mirgateV2Staker(address toAddress, uint96 rewards,uint96 depositTokens, uint8 numOfMonths, uint48 depositTime, uint96 withdrawnAmount) external onlyController(Role.Upgrader) returns(uint256 nftId)
1764     {
1765         nftId = stakeToken.bridgeOrAirdropStakeNftIn(toAddress, depositTokens, numOfMonths, depositTime, withdrawnAmount, rewards, false);
1766 
1767         uint96 amount = depositTokens - withdrawnAmount;
1768 
1769         _tokenTransfer(address(this), toAddress, amount, false);
1770         if (rewards > 0) {
1771             _tokenTransfer(address(this), address(stakeToken), rewards, false);
1772         }
1773         
1774         _lockAndAddStaker(toAddress, amount, numOfMonths, nftId);
1775     }
1776 
1777     function mirgateV1V2Holder(address holder, uint96 amount) external onlyController(Role.Upgrader) returns(bool) {
1778         _tokenTransfer(address(this), holder, amount, false);
1779         return true;
1780     }
1781 }