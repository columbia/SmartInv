1 // SPDX-License-Identifier: MIT
2 // pragma solidity ^0.8.17;
3 // pragma experimental ABIEncoderV2;
4 
5 // import "@openzeppelin/contracts-upgradeable-8/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
6 // import "@openzeppelin/contracts-upgradeable-8/token/ERC20/IERC20Upgradeable.sol";
7 // import "@openzeppelin/contracts-upgradeable-8/proxy/utils/UUPSUpgradeable.sol";
8 // import "@openzeppelin/contracts-upgradeable-8/access/OwnableUpgradeable.sol";
9 // import "@openzeppelin/contracts-upgradeable-8/utils/math/MathUpgradeable.sol";
10 
11 // import "contracts/interfaces/IBeanstalk.sol";
12 // import "contracts/interfaces/IDelegation.sol";
13 
14 // /// @notice Silo deposit transfer
15 // /// @param token a whitelisted silo token address
16 // /// @param stems a list of deposit stems
17 // /// @param amounts a list of deposit amount
18 // struct DepositTransfer {
19 //     address token;
20 //     uint32[] stems;
21 //     uint256[] amounts;
22 // }
23 
24 // /// @title Root FDBDV
25 // /// @author 0xkokonut, mistermanifold, publius
26 // contract Root is UUPSUpgradeable, ERC20PermitUpgradeable, OwnableUpgradeable {
27 //     using MathUpgradeable for uint256;
28 
29 //     /// @notice This event will emit after the user mint Root token
30 //     /// @param account minting user
31 //     /// @param deposits silo deposits transferred into contract
32 //     /// @param bdv total bdv used for deposits
33 //     /// @param stalk total stalk for deposits
34 //     /// @param stalkPerBdvPerSeasons total stalkPerBdvPerSeasons for deposits
35 //     /// @param shares total shares minted
36 //     event Mint(
37 //         address indexed account,
38 //         DepositTransfer[] deposits,
39 //         uint256 bdv,
40 //         uint256 stalk,
41 //         uint256 stalkPerBdvPerSeasons,
42 //         uint256 shares
43 //     );
44 
45 //     /// @notice This event will emit after the user redeem Root token
46 //     /// @param account redeeming user
47 //     /// @param deposits silo deposits transferred to the user
48 //     /// @param bdv total bdv for deposits
49 //     /// @param stalk total stalk for deposits
50 //     /// @param stalkPerBdvPerSeasons total stalkPerBdvPerSeasons for deposits
51 //     /// @param shares total shares burned
52 //     event Redeem(
53 //         address indexed account,
54 //         DepositTransfer[] deposits,
55 //         uint256 bdv,
56 //         uint256 stalk,
57 //         uint256 stalkPerBdvPerSeasons,
58 //         uint256 shares
59 //     );
60 
61 //     /// @notice This event will emit after the owner whitelist a silo token
62 //     /// @param token address of a silo token
63 //     event AddWhitelistToken(address indexed token);
64 
65 //     /// @notice This event will emit after the owner remove a silo token from whitelist
66 //     /// @param token address of a silo token
67 //     event RemoveWhitelistToken(address indexed token);
68 
69 //     /// @notice Beanstalk address
70 //     address public constant BEANSTALK_ADDRESS =
71 //         0xC1E088fC1323b20BCBee9bd1B9fC9546db5624C5;
72 
73 //     /// @notice Decimal precision of this contract token
74 //     uint256 private constant PRECISION = 1e18;
75 
76 //     /// @notice A mapping of whitelisted token
77 //     /// @return whitelisted mapping of all whitelisted token
78 //     mapping(address => bool) public whitelisted;
79 
80 //     /// @notice The total bdv of the silo deposits in the contract
81 //     /// @dev only get updated on mint/earn/redeem
82 //     /// @return underlyingBdv total bdv of the silo deposit(s) in the contract
83 //     uint256 public underlyingBdv;
84 
85 //     /// @notice Nominated candidate to be the owner of the contract
86 //     /// @dev The nominated candidate need to call the claimOwnership function
87 //     /// @return ownerCandidate The nomindated candidate to become the new owner of the contract
88 //     address public ownerCandidate;
89 
90 //     /// @custom:oz-upgrades-unsafe-allow constructor
91 //     constructor() {
92 //         _disableInitializers();
93 //     }
94 
95 //     /// @notice Initialize the contract
96 //     /// @param name The name of this ERC-20 contract
97 //     /// @param symbol The symbol of this ERC-20 contract
98 //     function initialize(string calldata name, string calldata symbol)
99 //         external
100 //         initializer
101 //     {
102 //         __ERC20_init(name, symbol);
103 //         __ERC20Permit_init(name);
104 //         __Ownable_init();
105 //     }
106 
107 //     /// @notice Renounce ownership of contract
108 //     /// @dev Not possible with this smart contract
109 //     function renounceOwnership() public virtual override onlyOwner {
110 //         revert("Ownable: Can't renounceOwnership here");
111 //     }
112 
113 //     /// @notice Nominate a candidate to become the new owner of the contract
114 //     /// @dev The nominated candidate need to call claimOwnership function
115 //     function transferOwnership(address newOwner)
116 //         public
117 //         virtual
118 //         override
119 //         onlyOwner
120 //     {
121 //         require(
122 //             newOwner != address(0),
123 //             "Ownable: Non-zero owner address required"
124 //         );
125 //         ownerCandidate = newOwner;
126 //     }
127 
128 //     /// @notice Nominated candidate claim ownership
129 //     function claimOwnership() external {
130 //         require(
131 //             msg.sender == ownerCandidate,
132 //             "Ownable: sender must be ownerCandidate to accept ownership"
133 //         );
134 //         _transferOwnership(ownerCandidate);
135 //         ownerCandidate = address(0);
136 //     }
137 
138 //     function _authorizeUpgrade(address) internal override onlyOwner {}
139 
140 //     /// @notice Owner whitelist a silo token
141 //     /// @param token Silo token to be add to the whitelist
142 //     function addWhitelistToken(address token) external onlyOwner {
143 //         require(token != address(0), "Non-zero token address required");
144 //         whitelisted[token] = true;
145 //         emit AddWhitelistToken(token);
146 //     }
147 
148 //     /// @notice Remove silo token from the whitelist
149 //     /// @param token Silo token to be remove from the whitelist
150 //     function removeWhitelistToken(address token) external onlyOwner {
151 //         require(token != address(0), "Non-zero token address required");
152 //         delete whitelisted[token];
153 //         emit RemoveWhitelistToken(token);
154 //     }
155 
156 //     /// @notice Delegate snapshot voting power
157 //     /// @param _delegateContract snapshot delegate contract
158 //     /// @param _delegate account to delegate voting power
159 //     /// @param _snapshotId snapshot space key
160 //     function setDelegate(
161 //         address _delegateContract,
162 //         address _delegate,
163 //         bytes32 _snapshotId
164 //     ) external onlyOwner {
165 //         require(
166 //             _delegateContract != address(0),
167 //             "Non-zero delegate address required"
168 //         );
169 //         if (_delegate == address(0)) {
170 //             IDelegation(_delegateContract).clearDelegate(_snapshotId);
171 //         } else {
172 //             IDelegation(_delegateContract).setDelegate(_snapshotId, _delegate);
173 //         }
174 //     }
175 
176 //     /// @notice Update bdv of a silo deposit and underlyingBdv
177 //     /// @dev Will revert if bdv doesn't increase
178 //     function updateBdv(address token, uint32 stem) external {
179 //         _updateBdv(token, stem);
180 //     }
181 
182 //     /// @notice Update Bdv of multiple silo deposits and underlyingBdv
183 //     /// @dev Will revert if the bdv of the deposits doesn't increase
184 //     function updateBdvs(address[] calldata tokens, uint128[] calldata stems)
185 //         external
186 //     {
187 //         for (uint256 i; i < tokens.length; ++i) {
188 //             _updateBdv(tokens[i], stems[i]);
189 //         }
190 //     }
191 
192 //     /// @notice Update silo deposit bdv and underlyingBdv
193 //     /// @dev Will revert if the BDV doesn't increase
194 //     function _updateBdv(address token, uint32 stem) internal {
195 //         require(token != address(0), "Bdv: Non-zero token address required");
196 //         (uint256 amount, ) = IBeanstalk(BEANSTALK_ADDRESS).getDeposit(
197 //             address(this),
198 //             token,
199 //             stem
200 //         );
201 //         uint32[] memory stems = new uint32[](1);
202 //         stems[0] = stem;
203 //         uint256[] memory amounts = new uint256[](1);
204 //         amounts[0] = amount;
205 //         (, , , uint256 fromBdv, uint256 toBdv) = IBeanstalk(BEANSTALK_ADDRESS)
206 //             .convert(
207 //                 abi.encode(ConvertKind.LAMBDA_LAMBDA, amount, token),
208 //                 stems,
209 //                 amounts
210 //             );
211 //         underlyingBdv += toBdv - fromBdv;
212 //     }
213 
214 //     /// @notice Return the ratio of underlyingBdv per ROOT token
215 //     function bdvPerRoot() external view returns (uint256) {
216 //         return (underlyingBdv * PRECISION) / totalSupply();
217 //     }
218 
219 //     /// @notice Call plant function on Beanstalk
220 //     /// @dev Anyone can call this function on behalf of the contract
221 //     function earn() external {
222 //         uint256 beans = IBeanstalk(BEANSTALK_ADDRESS).plant();
223 //         underlyingBdv += beans;
224 //     }
225 
226 //     /// @dev return the min value of the three input values
227 //     function _min(
228 //         uint256 num1,
229 //         uint256 num2,
230 //         uint256 num3
231 //     ) internal pure returns (uint256) {
232 //         num1 = MathUpgradeable.min(num1, num2);
233 //         return MathUpgradeable.min(num1, num3);
234 //     }
235 
236 //     /// @dev return the max value of the three input values
237 //     function _max(
238 //         uint256 num1,
239 //         uint256 num2,
240 //         uint256 num3
241 //     ) internal pure returns (uint256) {
242 //         num1 = MathUpgradeable.max(num1, num2);
243 //         return MathUpgradeable.max(num1, num3);
244 //     }
245 
246 //     /// @notice Mint ROOT token using silo deposit(s) with a silo deposit permit
247 //     /// @dev Make sure any token inside of DepositTransfer have sufficient approval either via permit in the arg or existing approval
248 //     /// @param depositTransfers silo deposit(s) to mint ROOT token
249 //     /// @param mode Transfer ROOT token to
250 //     /// @param minRootsOut Minimum number of ROOT token to receive
251 //     /// @param token a silo deposit token address
252 //     /// @param value a silo deposit amount
253 //     /// @param deadline permit expiration
254 //     /// @param v permit signature
255 //     /// @param r permit signature
256 //     /// @param s permit signature
257 //     function mintWithTokenPermit(
258 //         DepositTransfer[] calldata depositTransfers,
259 //         To mode,
260 //         uint256 minRootsOut,
261 //         address token,
262 //         uint256 value,
263 //         uint256 deadline,
264 //         uint8 v,
265 //         bytes32 r,
266 //         bytes32 s
267 //     ) external virtual returns (uint256) {
268 //         IBeanstalk(BEANSTALK_ADDRESS).permitDeposit(
269 //             msg.sender,
270 //             address(this),
271 //             token,
272 //             value,
273 //             deadline,
274 //             v,
275 //             r,
276 //             s
277 //         );
278 
279 //         return _transferAndMint(depositTransfers, mode, minRootsOut);
280 //     }
281 
282 //     /// @notice Mint ROOT token using silo deposit(s) with silo deposit tokens and values permit
283 //     /// @param depositTransfers silo deposit(s) to mint ROOT token
284 //     /// @param mode Transfer ROOT token to
285 //     /// @param minRootsOut Minimum number of ROOT token to receive
286 //     /// @param tokens a list of silo deposit token address
287 //     /// @param values a list of silo deposit amount
288 //     /// @param deadline permit expiration
289 //     /// @param v permit signature
290 //     /// @param r permit signature
291 //     /// @param s permit signature
292 //     function mintWithTokensPermit(
293 //         DepositTransfer[] calldata depositTransfers,
294 //         To mode,
295 //         uint256 minRootsOut,
296 //         address[] calldata tokens,
297 //         uint256[] calldata values,
298 //         uint256 deadline,
299 //         uint8 v,
300 //         bytes32 r,
301 //         bytes32 s
302 //     ) external virtual returns (uint256) {
303 //         IBeanstalk(BEANSTALK_ADDRESS).permitDeposits(
304 //             msg.sender,
305 //             address(this),
306 //             tokens,
307 //             values,
308 //             deadline,
309 //             v,
310 //             r,
311 //             s
312 //         );
313 
314 //         return _transferAndMint(depositTransfers, mode, minRootsOut);
315 //     }
316 
317 //     /// @notice Mint ROOT token using silo deposit(s)
318 //     /// @param depositTransfers silo deposit(s) to mint ROOT token
319 //     /// @param mode Transfer ROOT token to
320 //     /// @param minRootsOut Minimum number of ROOT token to receive
321 //     function mint(
322 //         DepositTransfer[] calldata depositTransfers,
323 //         To mode,
324 //         uint256 minRootsOut
325 //     ) external virtual returns (uint256) {
326 //         return _transferAndMint(depositTransfers, mode, minRootsOut);
327 //     }
328 
329 //     /// @notice Redeem ROOT token for silo deposit(s) with farm balance permit
330 //     /// @param depositTransfers silo deposit(s) receive
331 //     /// @param mode Burn ROOT token from
332 //     /// @param maxRootsIn Maximum number of ROOT token to burn
333 //     /// @param token ROOT address
334 //     /// @param value amount of ROOT approved
335 //     /// @param deadline permit expiration
336 //     /// @param v permit signature
337 //     /// @param r permit signature
338 //     /// @param s permit signature
339 //     function redeemWithFarmBalancePermit(
340 //         DepositTransfer[] calldata depositTransfers,
341 //         From mode,
342 //         uint256 maxRootsIn,
343 //         address token,
344 //         uint256 value,
345 //         uint256 deadline,
346 //         uint8 v,
347 //         bytes32 r,
348 //         bytes32 s
349 //     ) external virtual returns (uint256) {
350 //         IBeanstalk(BEANSTALK_ADDRESS).permitToken(
351 //             msg.sender,
352 //             address(this),
353 //             token,
354 //             value,
355 //             deadline,
356 //             v,
357 //             r,
358 //             s
359 //         );
360 //         return _transferAndRedeem(depositTransfers, mode, maxRootsIn);
361 //     }
362 
363 //     /// @notice Redeem ROOT token for silo deposit(s)
364 //     /// @param depositTransfers silo deposit(s) receive
365 //     /// @param mode Burn ROOT token from
366 //     /// @param maxRootsIn Maximum number of ROOT token to burn
367 //     function redeem(
368 //         DepositTransfer[] calldata depositTransfers,
369 //         From mode,
370 //         uint256 maxRootsIn
371 //     ) external virtual returns (uint256) {
372 //         return _transferAndRedeem(depositTransfers, mode, maxRootsIn);
373 //     }
374 
375 //     /// @notice Burn ROOT token to exchange for silo deposit(s)
376 //     function _transferAndRedeem(
377 //         DepositTransfer[] calldata depositTransfers,
378 //         From mode,
379 //         uint256 maxRootsIn
380 //     ) internal returns (uint256) {
381 //         (
382 //             uint256 shares,
383 //             uint256 bdv,
384 //             uint256 stalk,
385 //             uint256 stalkPerBdvPerSeasons
386 //         ) = _transferDeposits(depositTransfers, false);
387 
388 //         require(
389 //             shares <= maxRootsIn,
390 //             "Redeem: shares is greater than maxRootsIn"
391 //         );
392 
393 //         // Default mode is EXTERNAL
394 //         address burnAddress = msg.sender;
395 //         // Transfer token from beanstalk internal to this contract and burn
396 //         if (mode == From.INTERNAL) {
397 //             burnAddress = address(this);
398 //             IBeanstalk(BEANSTALK_ADDRESS).transferInternalTokenFrom(
399 //                 this,
400 //                 msg.sender,
401 //                 burnAddress,
402 //                 shares,
403 //                 To.EXTERNAL
404 //             );
405 //         }
406 //         _burn(burnAddress, shares);
407 //         emit Redeem(msg.sender, depositTransfers, bdv, stalk, stalkPerBdvPerSeasons, shares);
408 //         return shares;
409 //     }
410 
411 //     /// @notice Transfer silo deposit(s) to exchange ROOT token
412 //     function _transferAndMint(
413 //         DepositTransfer[] calldata depositTransfers,
414 //         To mode,
415 //         uint256 minRootsOut
416 //     ) internal returns (uint256) {
417 //         (
418 //             uint256 shares,
419 //             uint256 bdv,
420 //             uint256 stalk,
421 //             uint256 stalkPerBdvPerSeasons
422 //         ) = _transferDeposits(depositTransfers, true);
423 
424 //         require(shares >= minRootsOut, "Mint: shares is less than minRootsOut");
425 
426 //         // Transfer mint tokens to beanstalk internal balance
427 //         if (mode == To.INTERNAL) {
428 //             _mint(address(this), shares);
429 //             _approve(address(this), BEANSTALK_ADDRESS, shares);
430 //             IBeanstalk(BEANSTALK_ADDRESS).transferToken(
431 //                 this,
432 //                 msg.sender,
433 //                 shares,
434 //                 From.EXTERNAL,
435 //                 To.INTERNAL
436 //             );
437 //         } else if (mode == To.EXTERNAL) {
438 //             _mint(msg.sender, shares);
439 //         }
440 
441 //         emit Mint(msg.sender, depositTransfers, bdv, stalk, stalkPerBdvPerSeasons, shares);
442 //         return shares;
443 //     }
444 
445 //     /// @notice Transfer Silo Deposit(s) between user/ROOT contract and update
446 //     /// @return shares number of shares will be mint/burn
447 //     /// @return bdv total bdv of depositTransfers
448 //     /// @return stalk total stalk of depositTransfers
449 //     function _transferDeposits(
450 //         DepositTransfer[] calldata depositTransfers,
451 //         bool isDeposit
452 //     )
453 //         internal
454 //         returns (
455 //             uint256 shares,
456 //             uint256 bdv,
457 //             uint256 stalk
458 //         )
459 //     {
460 //         IBeanstalk(BEANSTALK_ADDRESS).update(address(this));
461         
462 //         uint256 balanceOfStalkBefore = IBeanstalk(BEANSTALK_ADDRESS)
463 //             .balanceOfStalk(address(this));
464 
465 //         for (uint256 i; i < depositTransfers.length; ++i) {
466 //             require(
467 //                 whitelisted[depositTransfers[i].token],
468 //                 "Token is not whitelisted"
469 //             );
470 
471 //             uint256[] memory bdvs = _transferDeposit(
472 //                 depositTransfers[i],
473 //                 isDeposit
474 //             );
475 //             for (uint256 j; j < bdvs.length; ++j) {
476 //                 bdv += bdvs[j];
477 //             }
478 //         }
479 
480         
481 //         uint256 balanceOfStalkAfter = IBeanstalk(BEANSTALK_ADDRESS)
482 //             .balanceOfStalk(address(this));
483 
484 //         uint256 underlyingBdvAfter;
485 //         if (isDeposit) {
486 //             underlyingBdvAfter = underlyingBdv + bdv;
487 //             stalk = balanceOfStalkAfter - balanceOfStalkBefore;
488 //         } else {
489 //             underlyingBdvAfter = underlyingBdv - bdv;
490 //             stalk = balanceOfStalkBefore - balanceOfStalkAfter;
491 //         }
492 //         uint256 supply = totalSupply();
493 //         if (supply == 0) {
494 //             shares = stalk * 1e8; // Stalk is 1e10 so we want to initialize the initial supply to 1e18
495 //         } else if (isDeposit) {
496 //             shares =
497 //                 supply.mulDiv(
498 //                     _min(
499 //                         underlyingBdvAfter.mulDiv(
500 //                             PRECISION,
501 //                             underlyingBdv,
502 //                             MathUpgradeable.Rounding.Down
503 //                         ),
504 //                         balanceOfStalkAfter.mulDiv(
505 //                             PRECISION,
506 //                             balanceOfStalkBefore,
507 //                             MathUpgradeable.Rounding.Down
508 //                         )
509 //                     ),
510 //                     PRECISION,
511 //                     MathUpgradeable.Rounding.Down
512 //                 ) -
513 //                 supply;
514 //         } else {
515 //             shares =
516 //                 supply -
517 //                 supply.mulDiv(
518 //                     _min(
519 //                         underlyingBdvAfter.mulDiv(
520 //                             PRECISION,
521 //                             underlyingBdv,
522 //                             MathUpgradeable.Rounding.Up
523 //                         ),
524 //                         balanceOfStalkAfter.mulDiv(
525 //                             PRECISION,
526 //                             balanceOfStalkBefore,
527 //                             MathUpgradeable.Rounding.Up
528 //                         )
529 //                     ),
530 //                     PRECISION,
531 //                     MathUpgradeable.Rounding.Up
532 //                 );
533 //         }
534 
535 //         underlyingBdv = underlyingBdvAfter;
536 //     }
537 
538 //     /// @notice Transfer silo deposit(s) between contract/user
539 //     function _transferDeposit(
540 //         DepositTransfer calldata depositTransfer,
541 //         bool isDeposit
542 //     ) internal returns (uint256[] memory bdvs) {
543 //         bdvs = IBeanstalk(BEANSTALK_ADDRESS).transferDeposits(
544 //             isDeposit ? msg.sender : address(this),
545 //             isDeposit ? address(this) : msg.sender,
546 //             depositTransfer.token,
547 //             depositTransfer.amounts
548 //         );
549 //     }
550 // }
551 // 