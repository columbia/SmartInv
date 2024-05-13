1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
10 import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
11 import '@openzeppelin/contracts/access/Ownable.sol';
12 import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
13 import '@openzeppelin/contracts/security/Pausable.sol';
14 
15 import './interfaces/ISherlock.sol';
16 
17 /// @title Sherlock core interface for stakers
18 /// @author Evert Kors
19 // This is the contract that manages staking actions
20 
21 contract Sherlock is ISherlock, ERC721, Ownable, Pausable {
22   using SafeERC20 for IERC20;
23 
24   // The minimal amount needed to mint a position
25   uint256 public constant MIN_STAKE = 10**6; // 1 USDC
26 
27   // The initial period for a staker to restake/withdraw without being auto-restaked
28   uint256 public constant ARB_RESTAKE_WAIT_TIME = 2 weeks;
29 
30   // The period during which the reward for restaking an account (after the inital period) grows
31   uint256 public constant ARB_RESTAKE_GROWTH_TIME = 1 weeks;
32 
33   // Anyone who gets auto-restaked is restaked for this period (26 weeks)
34   uint256 public constant ARB_RESTAKE_PERIOD = 26 weeks;
35 
36   // The percentage of someone's stake that can be paid to an arb for restaking
37   uint256 public constant ARB_RESTAKE_MAX_PERCENTAGE = (10**18 / 100) * 20; // 20%
38 
39   // USDC address
40   IERC20 public immutable token;
41 
42   // SHER token address
43   IERC20 public immutable sher;
44 
45   // Key is the staking period (3 months, 6 months, etc.), value will be whether it is allowed or not
46   mapping(uint256 => bool) public override stakingPeriods;
47 
48   // Key is a specific position ID (NFT ID), value represents the timestamp at which the position can be unstaked/restaked
49   mapping(uint256 => uint256) internal lockupEnd_;
50 
51   // Key is NFT ID, value is the amount of SHER rewards owed to that NFT position
52   mapping(uint256 => uint256) internal sherRewards_;
53 
54   // Key is NFT ID, value is the amount of shares representing the USDC owed to this position (includes principal, interest, etc.)
55   mapping(uint256 => uint256) internal stakeShares;
56 
57   // Total amount of shares that have been issued to all NFT positions
58   uint256 internal totalStakeShares;
59 
60   // Contract representing the current yield strategy (deposits staker funds into Aave, etc.)
61   IStrategyManager public override yieldStrategy;
62 
63   // Instances of relevant Sherlock contracts
64   ISherDistributionManager public override sherDistributionManager;
65   ISherlockProtocolManager public override sherlockProtocolManager;
66   ISherlockClaimManager public override sherlockClaimManager;
67 
68   // Address to which nonstaker payments are made
69   // This will start out as a multi-sig address, then become a contract address later
70   address public override nonStakersAddress;
71 
72   // Stores the ID of the most recently created NFT
73   // This variable is incremented by 1 to create a new NFT ID
74   uint256 internal nftCounter;
75 
76   string private constant baseURI = 'https://nft.sherlock.xyz/api/mainnet/';
77 
78   // Even though `_sherDistributionManager` can be removed once deployed, every initial deployment will have an active instance.
79   constructor(
80     IERC20 _token, // USDC address
81     IERC20 _sher, // SHER token address
82     string memory _name, // Token collection name (see ERC-721 docs)
83     string memory _symbol, // Token collection symbol (see ERC-721 docs)
84     IStrategyManager _yieldStrategy, // The active yield strategy contract
85     ISherDistributionManager _sherDistributionManager, // The active DistributionManager contract
86     address _nonStakersAddress, // The address to which nonstakers payments go
87     ISherlockProtocolManager _sherlockProtocolManager, // The address for the ProtocolManager contract
88     ISherlockClaimManager _sherlockClaimManager, // The address for the ClaimManager contract
89     uint256[] memory _initialstakingPeriods // The initial periods (3m, 6m, etc.) that someone can stake for
90   ) ERC721(_name, _symbol) {
91     if (address(_token) == address(0)) revert ZeroArgument();
92     if (address(_sher) == address(0)) revert ZeroArgument();
93     if (address(_yieldStrategy) == address(0)) revert ZeroArgument();
94     if (address(_sherDistributionManager) == address(0)) revert ZeroArgument();
95     if (_nonStakersAddress == address(0)) revert ZeroArgument();
96     if (address(_sherlockProtocolManager) == address(0)) revert ZeroArgument();
97     if (address(_sherlockClaimManager) == address(0)) revert ZeroArgument();
98 
99     token = _token;
100     sher = _sher;
101     yieldStrategy = _yieldStrategy;
102     sherDistributionManager = _sherDistributionManager;
103     nonStakersAddress = _nonStakersAddress;
104     sherlockProtocolManager = _sherlockProtocolManager;
105     sherlockClaimManager = _sherlockClaimManager;
106 
107     // Enabling the first set of staking periods that were provided in constructor args
108     for (uint256 i; i < _initialstakingPeriods.length; i++) {
109       enableStakingPeriod(_initialstakingPeriods[i]);
110     }
111 
112     emit YieldStrategyUpdated(IStrategyManager(address(0)), _yieldStrategy);
113     emit SherDistributionManagerUpdated(
114       ISherDistributionManager(address(0)),
115       _sherDistributionManager
116     );
117     emit NonStakerAddressUpdated(address(0), _nonStakersAddress);
118     emit ProtocolManagerUpdated(ISherlockProtocolManager(address(0)), _sherlockProtocolManager);
119     emit ClaimManagerUpdated(ISherlockClaimManager(address(0)), _sherlockClaimManager);
120   }
121 
122   //
123   // View functions
124   //
125 
126   // Returns the timestamp at which the position represented by _tokenID can first be unstaked/restaked
127   /// @notice View the current lockup end timestamp of `_tokenID`
128   /// @return Timestamp when NFT position unlocks
129   function lockupEnd(uint256 _tokenID) public view override returns (uint256) {
130     if (!_exists(_tokenID)) revert NonExistent();
131 
132     return lockupEnd_[_tokenID];
133   }
134 
135   // Returns the SHER rewards owed to this position
136   /// @notice View the current SHER reward of `_tokenID`
137   /// @return Amount of SHER rewarded to owner upon reaching the end of the lockup
138   function sherRewards(uint256 _tokenID) public view override returns (uint256) {
139     if (!_exists(_tokenID)) revert NonExistent();
140 
141     return sherRewards_[_tokenID];
142   }
143 
144   // Returns the tokens (USDC) owed to a position
145   /// @notice View the current token balance claimable upon reaching end of the lockup
146   /// @return Amount of tokens assigned to owner when unstaking position
147   function tokenBalanceOf(uint256 _tokenID) public view override returns (uint256) {
148     if (!_exists(_tokenID)) revert NonExistent();
149     // Finds the fraction of total shares owed to this position and multiplies by the total amount of tokens (USDC) owed to stakers
150     return (stakeShares[_tokenID] * totalTokenBalanceStakers()) / totalStakeShares;
151   }
152 
153   // Gets the total amount of tokens (USDC) owed to stakers
154   // Adds this contract's balance, the tokens in the yield strategy, and the claimable premiums in the protocol manager contract
155   /// @notice View the current TVL for all stakers
156   /// @return Total amount of tokens staked
157   /// @dev Adds principal + strategy + premiums
158   /// @dev Will calculate the most up to date value for each piece
159   function totalTokenBalanceStakers() public view override returns (uint256) {
160     return
161       token.balanceOf(address(this)) +
162       yieldStrategy.balanceOf() +
163       sherlockProtocolManager.claimablePremiums();
164   }
165 
166   //
167   // Gov functions
168   //
169 
170   // Allows governance to add a new staking period (4 months, etc.)
171   /// @notice Allows stakers to stake for `_period` of time
172   /// @param _period Period of time, in seconds,
173   /// @dev should revert if already enabled
174   function enableStakingPeriod(uint256 _period) public override onlyOwner {
175     if (_period == 0) revert ZeroArgument();
176     // Revert if staking period is already active
177     if (stakingPeriods[_period]) revert InvalidArgument();
178 
179     // Sets the staking period to true
180     stakingPeriods[_period] = true;
181     emit StakingPeriodEnabled(_period);
182   }
183 
184   // Allows governance to remove a staking period (4 months, etc.)
185   /// @notice Disallow stakers to stake for `_period` of time
186   /// @param _period Period of time, in seconds,
187   /// @dev should revert if already disabled
188   function disableStakingPeriod(uint256 _period) external override onlyOwner {
189     // Revert if staking period is already inactive
190     if (!stakingPeriods[_period]) revert InvalidArgument();
191 
192     // Sets the staking period to false
193     stakingPeriods[_period] = false;
194     emit StakingPeriodDisabled(_period);
195   }
196 
197   // Sets a new contract to be the active SHER distribution manager
198   /// @notice Update SHER distribution manager contract
199   /// @param _sherDistributionManager New adddress of the manager
200   /// @dev After updating the contract, call setSherlockCoreAddress() on the new contract
201   function updateSherDistributionManager(ISherDistributionManager _sherDistributionManager)
202     external
203     override
204     onlyOwner
205   {
206     if (address(_sherDistributionManager) == address(0)) revert ZeroArgument();
207     if (sherDistributionManager == _sherDistributionManager) revert InvalidArgument();
208 
209     emit SherDistributionManagerUpdated(sherDistributionManager, _sherDistributionManager);
210     sherDistributionManager = _sherDistributionManager;
211   }
212 
213   /// @notice Deletes the SHER distribution manager altogether (if Sherlock decides to no longer pay out SHER rewards)
214   function removeSherDistributionManager() external override onlyOwner {
215     if (address(sherDistributionManager) == address(0)) revert InvalidConditions();
216 
217     emit SherDistributionManagerUpdated(
218       sherDistributionManager,
219       ISherDistributionManager(address(0))
220     );
221     delete sherDistributionManager;
222   }
223 
224   // Sets a new address for nonstakers payments
225   /// @notice Update address eligible for non staker rewards from protocol premiums
226   /// @param _nonStakers Address eligible for non staker rewards
227   function updateNonStakersAddress(address _nonStakers) external override onlyOwner {
228     if (address(_nonStakers) == address(0)) revert ZeroArgument();
229     if (nonStakersAddress == _nonStakers) revert InvalidArgument();
230 
231     emit NonStakerAddressUpdated(nonStakersAddress, _nonStakers);
232     nonStakersAddress = _nonStakers;
233   }
234 
235   // Sets a new protocol manager contract
236   /// @notice Transfer protocol manager implementation address
237   /// @param _protocolManager new implementation address
238   /// @dev After updating the contract, call setSherlockCoreAddress() on the new contract
239   function updateSherlockProtocolManager(ISherlockProtocolManager _protocolManager)
240     external
241     override
242     onlyOwner
243   {
244     if (address(_protocolManager) == address(0)) revert ZeroArgument();
245     if (sherlockProtocolManager == _protocolManager) revert InvalidArgument();
246 
247     emit ProtocolManagerUpdated(sherlockProtocolManager, _protocolManager);
248     sherlockProtocolManager = _protocolManager;
249   }
250 
251   // Sets a new claim manager contract
252   /// @notice Transfer claim manager role to different address
253   /// @param _claimManager New address of claim manager
254   /// @dev After updating the contract, call setSherlockCoreAddress() on the new contract
255   function updateSherlockClaimManager(ISherlockClaimManager _claimManager)
256     external
257     override
258     onlyOwner
259   {
260     if (address(_claimManager) == address(0)) revert ZeroArgument();
261     if (sherlockClaimManager == _claimManager) revert InvalidArgument();
262 
263     emit ClaimManagerUpdated(sherlockClaimManager, _claimManager);
264     sherlockClaimManager = _claimManager;
265   }
266 
267   // Sets a new yield strategy manager contract
268   /// @notice Update yield strategy
269   /// @param _yieldStrategy New address of the strategy
270   /// @dev Call will fail if underlying withdrawAll call fails
271   /// @dev After updating the contract, call setSherlockCoreAddress() on the new contract
272   function updateYieldStrategy(IStrategyManager _yieldStrategy) external override onlyOwner {
273     if (address(_yieldStrategy) == address(0)) revert ZeroArgument();
274     if (yieldStrategy == _yieldStrategy) revert InvalidArgument();
275 
276     yieldStrategy.withdrawAll();
277 
278     emit YieldStrategyUpdated(yieldStrategy, _yieldStrategy);
279     yieldStrategy = _yieldStrategy;
280   }
281 
282   // Sets a new yield strategy manager contract
283   /// @notice Update yield strategy ignoring state of current strategy
284   /// @param _yieldStrategy New address of the strategy
285   /// @dev tries a yieldStrategyWithdrawAll() on old strategy, ignore failure
286   function updateYieldStrategyForce(IStrategyManager _yieldStrategy) external override onlyOwner {
287     if (address(_yieldStrategy) == address(0)) revert ZeroArgument();
288     if (yieldStrategy == _yieldStrategy) revert InvalidArgument();
289 
290     // This call is surrounded with a try catch as there is a non-zero chance the underlying yield protocol(s) will fail
291     // For example; the Aave V2 withdraw can fail in case there is not enough liquidity available for whatever reason.
292     // In case this happens. We still want the yield strategy to be updated.
293     // As the worst case could be that the Aave V2 withdraw will never work again, forcing us to never use a yield strategy ever again.
294     try yieldStrategy.withdrawAll() {} catch (bytes memory reason) {
295       emit YieldStrategyUpdateWithdrawAllError(reason);
296     }
297 
298     emit YieldStrategyUpdated(yieldStrategy, _yieldStrategy);
299     yieldStrategy = _yieldStrategy;
300   }
301 
302   // Deposits a chosen amount of tokens (USDC) into the active yield strategy
303   /// @notice Deposit `_amount` into active strategy
304   /// @param _amount Amount of tokens
305   /// @dev gov only
306   function yieldStrategyDeposit(uint256 _amount) external override onlyOwner {
307     if (_amount == 0) revert ZeroArgument();
308 
309     // Transfers any tokens owed to stakers from the protocol manager contract to this contract first
310     sherlockProtocolManager.claimPremiumsForStakers();
311     // Transfers the amount of tokens to the yield strategy contract
312     token.safeTransfer(address(yieldStrategy), _amount);
313     // Deposits all tokens in the yield strategy contract into the actual yield strategy
314     yieldStrategy.deposit();
315   }
316 
317   // Withdraws a chosen amount of tokens (USDC) from the yield strategy back into this contract
318   /// @notice Withdraw `_amount` from active strategy
319   /// @param _amount Amount of tokens
320   /// @dev gov only
321   function yieldStrategyWithdraw(uint256 _amount) external override onlyOwner {
322     if (_amount == 0) revert ZeroArgument();
323 
324     yieldStrategy.withdraw(_amount);
325   }
326 
327   // Withdraws all tokens from the yield strategy back into this contract
328   /// @notice Withdraw all funds from active strategy
329   /// @dev gov only
330   function yieldStrategyWithdrawAll() external override onlyOwner {
331     yieldStrategy.withdrawAll();
332   }
333 
334   /// @notice Pause external functions in all contracts
335   /// @dev A manager can still be replaced with a new contract in a `paused` state
336   /// @dev To ensure we are still able to pause all contracts, we check if the manager is unpaused
337   function pause() external onlyOwner {
338     _pause();
339     if (!Pausable(address(yieldStrategy)).paused()) yieldStrategy.pause();
340     // sherDistributionManager can be 0, pause isn't needed in that case
341     if (
342       address(sherDistributionManager) != address(0) &&
343       !Pausable(address(sherDistributionManager)).paused()
344     ) {
345       sherDistributionManager.pause();
346     }
347     if (!Pausable(address(sherlockProtocolManager)).paused()) sherlockProtocolManager.pause();
348     if (!Pausable(address(sherlockClaimManager)).paused()) sherlockClaimManager.pause();
349   }
350 
351   /// @notice Unpause external functions in all contracts
352   /// @dev A manager can still be replaced with a new contract in an `unpaused` state
353   /// @dev To ensure we are still able to unpause all contracts, we check if the manager is paused
354   function unpause() external onlyOwner {
355     _unpause();
356     if (Pausable(address(yieldStrategy)).paused()) yieldStrategy.unpause();
357     // sherDistributionManager can be 0, unpause isn't needed in that case
358     if (
359       address(sherDistributionManager) != address(0) &&
360       Pausable(address(sherDistributionManager)).paused()
361     ) {
362       sherDistributionManager.unpause();
363     }
364     if (Pausable(address(sherlockProtocolManager)).paused()) sherlockProtocolManager.unpause();
365     if (Pausable(address(sherlockClaimManager)).paused()) sherlockClaimManager.unpause();
366   }
367 
368   //
369   // Access control functions
370   //
371   function _beforeTokenTransfer(
372     address _from,
373     address _to,
374     uint256 _tokenID
375   ) internal override whenNotPaused {}
376 
377   function _baseURI() internal view virtual override returns (string memory) {
378     return baseURI;
379   }
380 
381   // Transfers specified amount of tokens to the address specified by the claim creator (protocol agent)
382   // This function is called by the Sherlock claim manager contract if a claim is approved
383   /// @notice Initiate a payout of `_amount` to `_receiver`
384   /// @param _receiver Receiver of payout
385   /// @param _amount Amount to send
386   /// @dev only payout manager should call this
387   /// @dev should pull money out of strategy
388   function payoutClaim(address _receiver, uint256 _amount) external override whenNotPaused {
389     // Can only be called by the Sherlock claim manager contract
390     if (msg.sender != address(sherlockClaimManager)) revert Unauthorized();
391 
392     if (_amount != 0) {
393       // Sends the amount of tokens to the receiver address (specified by the protocol agent who created the claim)
394       _transferTokensOut(_receiver, _amount);
395     }
396     emit ClaimPayout(_receiver, _amount);
397   }
398 
399   //
400   // Non-access control functions
401   //
402 
403   // Helper function for initial staking and restaking
404   // Sets the unlock period, mints and transfers SHER tokens to this contract, assigns SHER tokens to this NFT position
405   /// @notice Stakes `_amount` of tokens and locks up the `_id` position for `_period` seconds
406   /// @param _amount Amount of tokens to stake
407   /// @param _period Period of time for which funds get locked
408   /// @param _id ID for this NFT position
409   /// @param _receiver Address that will be linked to this position
410   /// @return _sher Amount of SHER tokens awarded to this position after `_period` ends
411   /// @dev `_period` needs to be whitelisted
412   function _stake(
413     uint256 _amount,
414     uint256 _period,
415     uint256 _id,
416     address _receiver
417   ) internal returns (uint256 _sher) {
418     // Sets the timestamp at which this position can first be unstaked/restaked
419     lockupEnd_[_id] = block.timestamp + _period;
420 
421     if (address(sherDistributionManager) == address(0)) return 0;
422     // Does not allow restaking of 0 tokens
423     if (_amount == 0) return 0;
424 
425     // Checks this amount of SHER tokens in this contract before we transfer new ones
426     uint256 before = sher.balanceOf(address(this));
427 
428     // pullReward() calcs then actually transfers the SHER tokens to this contract
429     // in case this call fails, whole (re)staking transaction fails
430     _sher = sherDistributionManager.pullReward(_amount, _period, _id, _receiver);
431 
432     // actualAmount should represent the amount of SHER tokens transferred to this contract for the current stake position
433     uint256 actualAmount = sher.balanceOf(address(this)) - before;
434     if (actualAmount != _sher) revert InvalidSherAmount(_sher, actualAmount);
435     // Assigns the newly created SHER tokens to the current stake position
436     if (_sher != 0) sherRewards_[_id] = _sher;
437   }
438 
439   // Checks to see if the NFT owner is the caller and that the position is unlockable
440   function _verifyUnlockableByOwner(uint256 _id) internal view {
441     if (ownerOf(_id) != msg.sender) revert Unauthorized();
442     if (lockupEnd_[_id] > block.timestamp) revert InvalidConditions();
443   }
444 
445   // Sends the SHER tokens associated with this NFT ID to the address of the NFT owner
446   function _sendSherRewardsToOwner(uint256 _id, address _nftOwner) internal {
447     uint256 sherReward = sherRewards_[_id];
448     if (sherReward == 0) return;
449 
450     // Deletes the SHER reward mapping for this NFT ID
451     delete sherRewards_[_id];
452 
453     // Transfers the SHER tokens associated with this NFT ID to the address of the NFT owner
454     sher.safeTransfer(_nftOwner, sherReward);
455   }
456 
457   // Transfers an amount of tokens to the receiver address
458   // This is the logic for a payout AND for an unstake (used by the payoutClaim() function above and in _redeemShares() below)
459   function _transferTokensOut(address _receiver, uint256 _amount) internal {
460     // Transfers any premiums owed to stakers from the protocol manager to this contract
461     sherlockProtocolManager.claimPremiumsForStakers();
462 
463     // The amount of tokens in this contract
464     uint256 mainBalance = token.balanceOf(address(this));
465 
466     // If the amount to transfer out is still greater than the amount of tokens in this contract,
467     // Withdraw yield strategy tokens to make up the difference
468     if (_amount > mainBalance) {
469       yieldStrategy.withdraw(_amount - mainBalance);
470     }
471 
472     token.safeTransfer(_receiver, _amount);
473   }
474 
475   // Returns the amount of USDC owed to this amount of stakeShares
476   function _redeemSharesCalc(uint256 _stakeShares) internal view returns (uint256) {
477     // Finds fraction that the given amount of stakeShares represents of the total
478     // Then multiplies it by the total amount of tokens (USDC) owed to all stakers
479     return (_stakeShares * totalTokenBalanceStakers()) / totalStakeShares;
480   }
481 
482   // Transfers USDC to the receiver (arbitrager OR NFT owner) based on the stakeShares inputted
483   // Also burns the requisite amount of shares associated with this NFT position
484   // Returns the amount of USDC owed to these shares
485   function _redeemShares(
486     uint256 _id,
487     uint256 _stakeShares,
488     address _receiver
489   ) internal returns (uint256 _amount) {
490     // Returns the amount of USDC owed to this amount of stakeShares
491     _amount = _redeemSharesCalc(_stakeShares);
492     // Transfers _amount of tokens to _receiver address
493     if (_amount != 0) _transferTokensOut(_receiver, _amount);
494 
495     // Subtracts this amount of stakeShares from the NFT position
496     stakeShares[_id] -= _stakeShares;
497     // Subtracts this amount of stakeShares from the total amount of stakeShares outstanding
498     totalStakeShares -= _stakeShares;
499   }
500 
501   // Helper function to restake an eligible NFT position on behalf of the NFT owner OR an arbitrager
502   // Restakes an NFT position (_id) for a given period (_period) and
503   // Sends any previously earned SHER rewards to the _nftOwner address
504   function _restake(
505     uint256 _id,
506     uint256 _period,
507     address _nftOwner
508   ) internal returns (uint256 _sher) {
509     // Sends the SHER tokens previously earned by this NFT ID to the address of the NFT owner
510     // NOTE This function deletes the SHER reward mapping for this NFT ID
511     _sendSherRewardsToOwner(_id, _nftOwner);
512 
513     // tokenBalanceOf() returns the USDC amount owed to this NFT ID
514     // _stake() restakes that amount of USDC for the period inputted
515     // We use the same ID that we just deleted the SHER rewards mapping for
516     // Resets the lockupEnd mapping and SHER token rewards mapping for this ID
517     // Note stakeShares for this position do not change so no need to update
518     _sher = _stake(tokenBalanceOf(_id), _period, _id, _nftOwner);
519 
520     emit Restaked(_id);
521   }
522 
523   // This function is called in the UI by anyone who is staking for the first time (not restaking a previous position)
524   /// @notice Stakes `_amount` of tokens and locks up for `_period` seconds, `_receiver` will receive the NFT receipt
525   /// @param _amount Amount of tokens to stake
526   /// @param _period Period of time, in seconds, to lockup your funds
527   /// @param _receiver Address that will receive the NFT representing the position
528   /// @return _id ID of the position
529   /// @return _sher Amount of SHER tokens to be released to this ID after `_period` ends
530   /// @dev `_period` needs to be whitelisted
531   function initialStake(
532     uint256 _amount,
533     uint256 _period,
534     address _receiver
535   ) external override whenNotPaused returns (uint256 _id, uint256 _sher) {
536     if (_amount == 0) revert ZeroArgument();
537     if (_amount < MIN_STAKE) revert InvalidArgument();
538     // Makes sure the period is a whitelisted period
539     if (!stakingPeriods[_period]) revert InvalidArgument();
540     if (address(_receiver) == address(0)) revert ZeroArgument();
541     // Adds 1 to the ID of the last NFT created for the new NFT ID
542     _id = ++nftCounter;
543 
544     // Transfers the USDC from the msg.sender to this contract for the amount specified (this is the staking action)
545     token.safeTransferFrom(msg.sender, address(this), _amount);
546 
547     uint256 stakeShares_;
548     uint256 totalStakeShares_ = totalStakeShares;
549     // _amount of tokens divided by the "before" total amount of tokens, multiplied by the "before" amount of stake shares
550     if (totalStakeShares_ != 0)
551       stakeShares_ = (_amount * totalStakeShares_) / (totalTokenBalanceStakers() - _amount);
552       // If this is the first stake ever, we just mint stake shares equal to the amount of USDC staked
553     else stakeShares_ = _amount;
554 
555     // Assigns this NFT ID the calc'd amount of stake shares above
556     stakeShares[_id] = stakeShares_;
557     // Adds the newly created stake shares to the total amount of stake shares
558     totalStakeShares += stakeShares_;
559 
560     // Locks up the USDC amount and calcs the SHER token amount to receive on unstake
561     _sher = _stake(_amount, _period, _id, _receiver);
562 
563     // This is an ERC-721 function that creates an NFT and sends it to the receiver
564     _safeMint(_receiver, _id);
565   }
566 
567   // This is how a staker unstakes and cashes out on their position
568   /// @notice Redeem NFT `_id` and receive `_amount` of tokens
569   /// @param _id TokenID of the position
570   /// @return _amount Amount of tokens (USDC) owed to NFT ID
571   /// @dev Only the owner of `_id` will be able to redeem their position
572   /// @dev The SHER rewards are sent to the NFT owner
573   /// @dev Can only be called after lockup `_period` has ended
574   function redeemNFT(uint256 _id) external override whenNotPaused returns (uint256 _amount) {
575     // Checks to make sure caller is the owner of the NFT position, and that the lockup period is over
576     _verifyUnlockableByOwner(_id);
577 
578     // This is the ERC-721 function to destroy an NFT (with owner's approval)
579     _burn(_id);
580 
581     // Transfers USDC to the NFT owner based on the stake shares associated with this NFT ID
582     // Also burns the requisite amount of shares associated with this NFT position
583     // Returns the amount of USDC owed to these shares
584     _amount = _redeemShares(_id, stakeShares[_id], msg.sender);
585 
586     // Sends the SHER tokens associated with this NFT ID to the NFT owner
587     _sendSherRewardsToOwner(_id, msg.sender);
588 
589     // Removes the unlock deadline associated with this NFT
590     delete lockupEnd_[_id];
591   }
592 
593   // This is how a staker restakes an expired position
594   /// @notice Owner restakes position with ID: `_id` for `_period` seconds
595   /// @param _id ID of the position
596   /// @param _period Period of time, in seconds, to lockup your funds
597   /// @return _sher Amount of SHER tokens to be released to owner address after `_period` ends
598   /// @dev Only the owner of `_id` will be able to restake their position using this call
599   /// @dev `_period` needs to be whitelisted
600   /// @dev Can only be called after lockup `_period` has ended
601   function ownerRestake(uint256 _id, uint256 _period)
602     external
603     override
604     whenNotPaused
605     returns (uint256 _sher)
606   {
607     // Checks to make sure caller is the owner of the NFT position, and that the lockup period is over
608     _verifyUnlockableByOwner(_id);
609 
610     // Checks to make sure the staking period is a whitelisted one
611     if (!stakingPeriods[_period]) revert InvalidArgument();
612 
613     // Sends the previously earned SHER token rewards to the owner and restakes the USDC value of the position
614     _sher = _restake(_id, _period, msg.sender);
615   }
616 
617   // Calcs the reward (in stake shares) an arb would get for restaking a position
618   // Takes the NFT ID as a param and outputs the stake shares (which can be redeemed for USDC) for the arb
619   function _calcSharesForArbRestake(uint256 _id) internal view returns (uint256, bool) {
620     // this is the first point at which an arb can restake a position (i.e. two weeks after the initial lockup ends)
621     uint256 initialArbTime = lockupEnd_[_id] + ARB_RESTAKE_WAIT_TIME;
622 
623     // If the initialArbTime has not passed, return 0 for the stake shares and false for whether an arb can restake the position
624     if (initialArbTime > block.timestamp) return (0, false);
625 
626     // The max rewards (as a % of the position's shares) for the arb are available at this timestamp
627     uint256 maxRewardArbTime = initialArbTime + ARB_RESTAKE_GROWTH_TIME;
628 
629     // Caps the timestamp at the maxRewardArbTime so the calc below never goes above 100%
630     uint256 targetTime = block.timestamp < maxRewardArbTime ? block.timestamp : maxRewardArbTime;
631 
632     // Scaled by 10**18
633     // Represents the max amount of stake shares that an arb could get from restaking this position
634     uint256 maxRewardScaled = ARB_RESTAKE_MAX_PERCENTAGE * stakeShares[_id];
635 
636     // Calcs what % of the max reward an arb gets based on the timestamp at which they call this function
637     // If targetTime == maxRewardArbTime, then the arb gets 100% of the maxRewardScaled
638     return (
639       ((targetTime - initialArbTime) * maxRewardScaled) / (ARB_RESTAKE_GROWTH_TIME) / 10**18,
640       true
641     );
642   }
643 
644   /// @notice Calculates the reward in tokens (USDC) that an arb would get for calling restake on a position
645   /// @return profit How much profit an arb would make in USDC
646   /// @return able If the transaction can be executed (the current timestamp is during an arb period, etc.)
647   function viewRewardForArbRestake(uint256 _id) external view returns (uint256 profit, bool able) {
648     if (!_exists(_id)) revert NonExistent();
649     // Returns the stake shares that an arb would get, and whether the position can currently be arbed
650     // `profit` variable is used to store the amount of shares
651     (profit, able) = _calcSharesForArbRestake(_id);
652     // Calculates the tokens (USDC) represented by that amount of stake shares
653     // Amount of shares stored in `profit` is used to calculate the reward in USDC, which is stored in `profit`
654     profit = _redeemSharesCalc(profit);
655   }
656 
657   /// @notice Allows someone who doesn't own the position (an arbitrager) to restake the position for 26 weeks (ARB_RESTAKE_PERIOD)
658   /// @param _id ID of the position
659   /// @return _sher Amount of SHER tokens to be released to position owner on expiry of the 26 weeks lockup
660   /// @return _arbReward Amount of tokens (USDC) sent to caller (the arbitrager) in return for calling the function
661   /// @dev Can only be called after lockup `_period` is more than 2 weeks in the past (assuming ARB_RESTAKE_WAIT_TIME is 2 weeks)
662   /// @dev Max 20% (ARB_RESTAKE_MAX_PERCENTAGE) of tokens associated with a position are used to incentivize arbs (x)
663   /// @dev During a 2 week period the reward ratio will move from 0% to 100% (* x)
664   function arbRestake(uint256 _id)
665     external
666     override
667     whenNotPaused
668     returns (uint256 _sher, uint256 _arbReward)
669   {
670     address nftOwner = ownerOf(_id);
671 
672     // Returns the stake shares that an arb would get, and whether the position can currently be arbed
673     (uint256 arbRewardShares, bool able) = _calcSharesForArbRestake(_id);
674     // Revert if not able to be arbed
675     if (!able) revert InvalidConditions();
676 
677     // Transfers USDC to the arbitrager based on the stake shares associated with the arb reward
678     // Also burns the requisite amount of shares associated with this NFT position
679     // Returns the amount of USDC paid to the arbitrager
680     _arbReward = _redeemShares(_id, arbRewardShares, msg.sender);
681 
682     // Restakes the tokens (USDC) associated with this position for the ARB_RESTAKE_PERIOD (26 weeks)
683     // Sends previously earned SHER rewards to the NFT owner address
684     _sher = _restake(_id, ARB_RESTAKE_PERIOD, nftOwner);
685 
686     emit ArbRestaked(_id, _arbReward);
687   }
688 }
