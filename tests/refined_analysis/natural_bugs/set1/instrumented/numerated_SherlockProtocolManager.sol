1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import './Manager.sol';
10 import '../interfaces/managers/ISherlockProtocolManager.sol';
11 
12 /// @title Sherlock core interface for protocols
13 /// @author Evert Kors
14 // This is the contract that manages covered protocols
15 
16 contract SherlockProtocolManager is ISherlockProtocolManager, Manager {
17   using SafeERC20 for IERC20;
18 
19   // Represents the token that protocols pay with (currently USDC)
20   IERC20 public immutable token;
21 
22   // This is the ceiling value that can be set for the threshold (based on USDC balance) at which a protocol can get removed
23   uint256 public constant MIN_BALANCE_SANITY_CEILING = 30_000 * 10**6; // 30k usdc
24 
25   // A removed protocol is still able to make a claim for this amount of time after its removal
26   uint256 public constant PROTOCOL_CLAIM_DEADLINE = 7 days;
27 
28   // This is the amount that cannot be withdrawn (measured in seconds of payment) if a protocol wants to remove active balance
29   uint256 public constant MIN_SECONDS_LEFT = 7 days;
30 
31   // Convenient for percentage calculations
32   uint256 internal constant HUNDRED_PERCENT = 10**18;
33 
34   // The minimum active "seconds of coverage left" a protocol must have before arbitragers can remove the protocol from coverage
35   // This value is calculated from a protocol's active balance divided by the premium per second the protocol is paying
36   uint256 public constant MIN_SECONDS_OF_COVERAGE = 12 hours;
37 
38   // This is an address that is controlled by a covered protocol (maybe its a multisig used by that protocol, etc.)
39   mapping(bytes32 => address) internal protocolAgent_;
40 
41   // The percentage of premiums that is NOT sent to stakers (set aside for security experts, reinsurance partners, etc.)
42   mapping(bytes32 => uint256) internal nonStakersPercentage;
43 
44   // The premium per second paid by each protocol is stored in this mapping
45   mapping(bytes32 => uint256) internal premiums_;
46 
47   // Each protocol should keep an active balance (in USDC) which is drawn against to pay stakers, nonstakers, etc.
48   // This "active balance" is really just an accounting concept, doesn't mean tokens have been transferred or not
49   mapping(bytes32 => uint256) internal activeBalances;
50 
51   // The timestamp at which Sherlock last ran this internal accounting (on the active balance) for each protocol
52   mapping(bytes32 => uint256) internal lastAccountedEachProtocol;
53 
54   // The amount that can be claimed by nonstakers for each protocol
55   // We need this value so we can track how much payment is coming from each protocol
56   mapping(bytes32 => uint256) internal nonStakersClaimableByProtocol;
57 
58   // The last time where the global accounting was run (to calc allPremiumsPerSecToStakers below)
59   uint256 internal lastAccountedGlobal;
60 
61   // This is the total amount of premiums paid (per second) by all the covered protocols (added up)
62   uint256 internal allPremiumsPerSecToStakers;
63 
64   // This is the amount that was claimable by stakers the last time the accounting was run
65   // The claimable amount presumably changes every second so this value is marked "last" because it is usually out-of-date
66   uint256 internal lastClaimablePremiumsForStakers;
67 
68   // The minimum active balance (measured in USDC) a protocol must keep before arbitragers can remove the protocol from coverage
69   // This is one of two criteria a protocol must meet in order to avoid removal (the other is MIN_SECONDS_OF_COVERAGE)
70   uint256 public override minActiveBalance;
71 
72   // Removed protocols can still make a claim up until this timestamp (will be 10 days or something)
73   mapping(bytes32 => uint256) internal removedProtocolClaimDeadline;
74 
75   // Mapping to store the protocolAgents for removed protocols (useful for claims made by a removed protocol)
76   mapping(bytes32 => address) internal removedProtocolAgent;
77 
78   // Current amount of coverage (i.e. 20M USDC) for a protocol
79   mapping(bytes32 => uint256) internal currentCoverage;
80 
81   // Previous amount of coverage for a protocol
82   // Previous is also tracked in case a protocol lowers their coverage amount but still needs to make a claim on the old, higher amount
83   mapping(bytes32 => uint256) internal previousCoverage;
84 
85   // Setting the token to USDC
86   constructor(IERC20 _token) {
87     if (address(_token) == address(0)) revert ZeroArgument();
88     token = _token;
89   }
90 
91   // Modifier used to ensure a protocol exists (has been instantiated and not removed)
92   modifier protocolExists(bytes32 _protocol) {
93     _verifyProtocolExists(_protocol);
94     _;
95   }
96 
97   /// @notice View current protocolAgent of `_protocol`
98   /// @param _protocol Protocol identifier
99   /// @return Address able to submit claims
100   function protocolAgent(bytes32 _protocol) external view override returns (address) {
101     address agent = protocolAgent_[_protocol];
102     if (agent != address(0)) return agent;
103 
104     // If a protocol has been removed but is still within the claim deadline, the protocolAgent is returned
105     // Note: Old protocol agent will never be address(0)
106     if (block.timestamp <= removedProtocolClaimDeadline[_protocol]) {
107       return removedProtocolAgent[_protocol];
108     }
109 
110     // If a protocol was never instantiated or was removed and the claim deadline has passed, this error is returned
111     revert ProtocolNotExists(_protocol);
112   }
113 
114   // Checks if the protocol exists, then returns the current premium per second being charged
115   /// @notice View current premium of protocol
116   /// @param _protocol Protocol identifier
117   /// @return Amount of premium `_protocol` pays per second
118   function premium(bytes32 _protocol)
119     external
120     view
121     override
122     protocolExists(_protocol)
123     returns (uint256)
124   {
125     return premiums_[_protocol];
126   }
127 
128   // Checks to see if a protocol has a protocolAgent assigned to it (we use this to check if a protocol exists)
129   // If a protocol has been removed, it will throw an error here no matter what (even if still within claim window)
130   function _verifyProtocolExists(bytes32 _protocol) internal view returns (address _protocolAgent) {
131     _protocolAgent = protocolAgent_[_protocol];
132     if (_protocolAgent == address(0)) revert ProtocolNotExists(_protocol);
133   }
134 
135   //
136   // View methods
137   //
138 
139   // Calcs the debt accrued by the protocol since it last had an accounting update
140   // This is the amount that needs to be removed from a protocol's active balance
141   function _calcIncrementalProtocolDebt(bytes32 _protocol) internal view returns (uint256) {
142     return (block.timestamp - lastAccountedEachProtocol[_protocol]) * premiums_[_protocol];
143   }
144 
145   /// @notice View the amount nonstakers can claim from this protocol
146   /// @param _protocol Protocol identifier
147   /// @return Amount of tokens claimable by nonstakers
148   /// @dev this reads from a storage variable + (now-lastsettled) * premiums
149   // Note: This function works even for removed protocols because of nonStakersClaimableByProtocol[_protocol]
150   // When a protocol gets removed, nonStakersClaimableByProtocol[_protocol] is updated and then doesn't change since the protocol has been removed
151   function nonStakersClaimable(bytes32 _protocol) external view override returns (uint256) {
152     // Calcs the debt of a protocol since the last accounting update
153     uint256 debt = _calcIncrementalProtocolDebt(_protocol);
154     // Gets the active balance of the protocol
155     uint256 balance = activeBalances[_protocol];
156     // The debt should never be higher than the balance (only happens if the arbitrages fail)
157     if (debt > balance) debt = balance;
158 
159     // Adds the incremental claimable amount owed to nonstakers to the total claimable amount
160     return
161       nonStakersClaimableByProtocol[_protocol] +
162       (nonStakersPercentage[_protocol] * debt) /
163       HUNDRED_PERCENT;
164   }
165 
166   /// @notice View current amount of all premiums that are owed to stakers
167   /// @return Premiums claimable
168   /// @dev Will increase every block
169   /// @dev base + (now - last_settled) * ps
170   function claimablePremiums() public view override returns (uint256) {
171     // Takes last balance and adds (number of seconds since last accounting update * total premiums per second)
172     return
173       lastClaimablePremiumsForStakers +
174       (block.timestamp - lastAccountedGlobal) *
175       allPremiumsPerSecToStakers;
176   }
177 
178   /// @notice View seconds of coverage left for `_protocol` before it runs out of active balance
179   /// @param _protocol Protocol identifier
180   /// @return Seconds of coverage left
181   function secondsOfCoverageLeft(bytes32 _protocol)
182     external
183     view
184     override
185     protocolExists(_protocol)
186     returns (uint256)
187   {
188     return _secondsOfCoverageLeft(_protocol);
189   }
190 
191   // Helper function to return seconds of coverage left for a protocol
192   // Gets the current active balance of the protocol and divides by the premium per second for the protocol
193   function _secondsOfCoverageLeft(bytes32 _protocol) internal view returns (uint256) {
194     uint256 premium = premiums_[_protocol];
195     if (premium == 0) return 0;
196     return _activeBalance(_protocol) / premium;
197   }
198 
199   /// @notice View current active balance of covered protocol
200   /// @param _protocol Protocol identifier
201   /// @return Active balance
202   /// @dev Accrued debt is subtracted from the stored active balance
203   function activeBalance(bytes32 _protocol)
204     external
205     view
206     override
207     protocolExists(_protocol)
208     returns (uint256)
209   {
210     return _activeBalance(_protocol);
211   }
212 
213   // Helper function to calc the active balance of a protocol at current time
214   function _activeBalance(bytes32 _protocol) internal view returns (uint256) {
215     uint256 debt = _calcIncrementalProtocolDebt(_protocol);
216     uint256 balance = activeBalances[_protocol];
217     // The debt should never be higher than the balance (only happens if the arbitrages fail)
218     if (debt > balance) return 0;
219     return balance - debt;
220   }
221 
222   //
223   // State methods
224   //
225 
226   /// @notice Helps set the premium per second for an individual protocol
227   /// @param _protocol Protocol identifier
228   /// @param _premium New premium per second
229   /// @return oldPremiumPerSecond and nonStakerPercentage are returned for gas savings in the calling function
230   function _setSingleProtocolPremium(bytes32 _protocol, uint256 _premium)
231     internal
232     returns (uint256 oldPremiumPerSecond, uint256 nonStakerPercentage)
233   {
234     // _settleProtocolDebt() subtracts debt from the protocol's active balance and updates the % due to nonstakers
235     // Also updates the last accounted timestamp for this protocol
236     // nonStakerPercentage is carried over from _settleProtocolDebt() for gas savings
237     // nonStakerPercentage represents the percentage that goes to nonstakers for this protocol
238     nonStakerPercentage = _settleProtocolDebt(_protocol);
239     // Stores the old premium before it gets updated
240     oldPremiumPerSecond = premiums_[_protocol];
241 
242     if (oldPremiumPerSecond != _premium) {
243       // Sets the protocol's premium per second to the new value
244       premiums_[_protocol] = _premium;
245       emit ProtocolPremiumChanged(_protocol, oldPremiumPerSecond, _premium);
246     }
247     // We check if the NEW premium causes the _secondsOfCoverageLeft for the protocol to be less than the threshold for arbing
248     // We don't need to check the min balance requirement for arbs because that value doesn't change like secondsOfCoverageLeft changes
249     // Effectively we just need to make sure we don't accidentally run a protocol's active balance down below the point
250     // Where arbs would no longer be incentivized to remove the protocol
251     // Because if a protocol is not removed by arbs before running out of active balance, this can cause problems
252     if (_premium != 0 && _secondsOfCoverageLeft(_protocol) < MIN_SECONDS_OF_COVERAGE) {
253       revert InsufficientBalance(_protocol);
254     }
255   }
256 
257   /// @notice Sets a single protocol's premium per second and also updates the global total of premiums per second
258   /// @param _protocol Protocol identifier
259   /// @param _premium New premium per second
260   function _setSingleAndGlobalProtocolPremium(bytes32 _protocol, uint256 _premium) internal {
261     // Sets the individual protocol's premium and returns oldPremiumPerSecond and nonStakerPercentage for gas savings
262     (uint256 oldPremiumPerSecond, uint256 nonStakerPercentage) = _setSingleProtocolPremium(
263       _protocol,
264       _premium
265     );
266     // Settling the total amount of premiums owed to stakers before a new premium per second gets set
267     _settleTotalDebt();
268     // This calculates the new global premium per second that gets paid to stakers
269     // We input the same nonStakerPercentage twice because we simply aren't updating that value in this function
270     allPremiumsPerSecToStakers = _calcGlobalPremiumPerSecForStakers(
271       oldPremiumPerSecond,
272       _premium,
273       nonStakerPercentage,
274       nonStakerPercentage,
275       allPremiumsPerSecToStakers
276     );
277   }
278 
279   // Internal function to set a new protocolAgent for a specific protocol
280   // _oldAgent is only included as part of emitting an event
281   function _setProtocolAgent(
282     bytes32 _protocol,
283     address _oldAgent,
284     address _protocolAgent
285   ) internal {
286     protocolAgent_[_protocol] = _protocolAgent;
287     emit ProtocolAgentTransfer(_protocol, _oldAgent, _protocolAgent);
288   }
289 
290   // Subtracts the accrued debt from a protocol's active balance
291   // Credits the amount that can be claimed by nonstakers for this protocol
292   // Takes the protocol ID as a param and returns the nonStakerPercentage for gas savings
293   // Most of this function is dealing with an edge case related to a protocol not being removed by arbs
294   function _settleProtocolDebt(bytes32 _protocol) internal returns (uint256 _nonStakerPercentage) {
295     // This calcs the accrued debt of the protocol since it was last updated
296     uint256 debt = _calcIncrementalProtocolDebt(_protocol);
297     // This pulls the percentage that is sent to nonstakers
298     _nonStakerPercentage = nonStakersPercentage[_protocol];
299     // In case the protocol has accrued debt, this code block will ensure the debt is settled properly
300     if (debt != 0) {
301       // Pulls the stored active balance of the protocol
302       uint256 balance = activeBalances[_protocol];
303       // This is the start of handling an edge case where arbitragers don't remove this protocol before debt becomes greater than active balance
304       // Economically speaking, this point should never be reached as arbs will get rewarded for removing the protocol before this point
305       // The arb would use forceRemoveByActiveBalance and forceRemoveBySecondsOfCoverage
306       // However, if arbs don't come in, the premium for this protocol should be set to 0 asap otherwise accounting for stakers/nonstakers gets messed up
307       if (debt > balance) {
308         // This error amount represents the magnitude of the mistake
309         uint256 error = debt - balance;
310         // Gets the latest value of claimable premiums for stakers
311         _settleTotalDebt();
312         // @note to production, set premium first to zero before solving accounting issue.
313         // otherwise the accounting error keeps increasing
314         uint256 lastClaimablePremiumsForStakers_ = lastClaimablePremiumsForStakers;
315 
316         // Figures out the amount due to stakers by subtracting the nonstaker percentage from 100%
317         uint256 claimablePremiumError = ((HUNDRED_PERCENT - _nonStakerPercentage) * error) /
318           HUNDRED_PERCENT;
319 
320         // This insufficient tokens var is simply how we know (emitted as an event) how many tokens the protocol is short
321         uint256 insufficientTokens;
322 
323         // The idea here is that lastClaimablePremiumsForStakers has gotten too big accidentally
324         // We need to decrease the balance of lastClaimablePremiumsForStakers by the amount that was added in error
325         // This first line can be true if claimPremiumsForStakers() has been called and
326         // lastClaimablePremiumsForStakers would be 0 but a faulty protocol could cause claimablePremiumError to be >0 still
327         if (claimablePremiumError > lastClaimablePremiumsForStakers_) {
328           insufficientTokens = claimablePremiumError - lastClaimablePremiumsForStakers_;
329           lastClaimablePremiumsForStakers = 0;
330         } else {
331           // If the error is not bigger than the claimable premiums, then we just decrease claimable premiums
332           // By the amount that was added in error (error) and insufficientTokens = 0
333           lastClaimablePremiumsForStakers =
334             lastClaimablePremiumsForStakers_ -
335             claimablePremiumError;
336         }
337 
338         // If two events are thrown, the values need to be summed up for the actual state.
339         // This means an error of this type will continue until it is handled
340         emit AccountingError(_protocol, claimablePremiumError, insufficientTokens);
341         // We set the debt equal to the balance, and in the next line we effectively set the protocol's active balance to 0 in this case
342         debt = balance;
343       }
344       // Subtracts the accrued debt (since last update) from the protocol's active balance and updates active balance
345       activeBalances[_protocol] = balance - debt;
346       // Adds the requisite amount of the debt to the balance claimable by nonstakers for this protocol
347       nonStakersClaimableByProtocol[_protocol] += (_nonStakerPercentage * debt) / HUNDRED_PERCENT;
348     }
349     // Updates the last accounted timestamp for this protocol
350     lastAccountedEachProtocol[_protocol] = block.timestamp;
351   }
352 
353   // Multiplies the total premium per second * number of seconds since the last global accounting update
354   // And adds it to the total claimable amount for stakers
355   function _settleTotalDebt() internal {
356     lastClaimablePremiumsForStakers +=
357       (block.timestamp - lastAccountedGlobal) *
358       allPremiumsPerSecToStakers;
359     lastAccountedGlobal = block.timestamp;
360   }
361 
362   // Calculates the global premium per second for stakers
363   // Takes a specific protocol's old and new values for premium per second and nonstaker percentage and the old global premium per second to stakers
364   // Subtracts out the old values of a protocol's premium per second and nonstaker percentage and adds the new ones
365   function _calcGlobalPremiumPerSecForStakers(
366     uint256 _premiumOld,
367     uint256 _premiumNew,
368     uint256 _nonStakerPercentageOld,
369     uint256 _nonStakerPercentageNew,
370     uint256 _inMemAllPremiumsPerSecToStakers
371   ) internal pure returns (uint256) {
372     return
373       _inMemAllPremiumsPerSecToStakers +
374       ((HUNDRED_PERCENT - _nonStakerPercentageNew) * _premiumNew) /
375       HUNDRED_PERCENT -
376       ((HUNDRED_PERCENT - _nonStakerPercentageOld) * _premiumOld) /
377       HUNDRED_PERCENT;
378   }
379 
380   // Helper function to remove and clean up a protocol from Sherlock
381   // Params are the protocol ID and the protocol agent to which funds should be sent and from which post-removal claims can be made
382   function _forceRemoveProtocol(bytes32 _protocol, address _agent) internal {
383     // Sets the individual protocol's premium to zero and updates the global premium variable for a zero premium at this protocol
384     _setSingleAndGlobalProtocolPremium(_protocol, 0);
385 
386     // Grabs the protocol's active balance
387     uint256 balance = activeBalances[_protocol];
388 
389     // If there's still some active balance, delete the entry and send the remaining balance to the protocol agent
390     if (balance != 0) {
391       delete activeBalances[_protocol];
392       token.safeTransfer(_agent, balance);
393 
394       emit ProtocolBalanceWithdrawn(_protocol, balance);
395     }
396 
397     // Sets the protocol agent to zero address (as part of clean up)
398     _setProtocolAgent(_protocol, _agent, address(0));
399 
400     // Cleans up other mappings for this protocol
401     delete nonStakersPercentage[_protocol];
402     delete lastAccountedEachProtocol[_protocol];
403     // `premiums_` mapping is not deleted here as it's already 0 because of the `_setSingleAndGlobalProtocolPremium` call above
404 
405     // Sets a deadline in the future until which this protocol agent can still make claims for this removed protocol
406     removedProtocolClaimDeadline[_protocol] = block.timestamp + PROTOCOL_CLAIM_DEADLINE;
407 
408     // This mapping allows Sherlock to verify the protocol agent making a claim after the protocol has been removed
409     // Remember, only the protocol agent can make claims on behalf of the protocol, so this must be checked
410     removedProtocolAgent[_protocol] = _agent;
411 
412     emit ProtocolUpdated(_protocol, bytes32(0), uint256(0), uint256(0));
413     emit ProtocolRemoved(_protocol);
414   }
415 
416   /// @notice Sets the minimum active balance before an arb can remove a protocol
417   /// @param _minActiveBalance Minimum balance needed (in USDC)
418   /// @dev Only gov
419   /// @dev This call should be subject to a timelock
420   function setMinActiveBalance(uint256 _minActiveBalance) external override onlyOwner {
421     // New value cannot be the same as current value
422     if (minActiveBalance == _minActiveBalance) revert InvalidArgument();
423     // Can't set a value that is too high to be reasonable
424     if (_minActiveBalance >= MIN_BALANCE_SANITY_CEILING) revert InvalidConditions();
425 
426     emit MinBalance(minActiveBalance, _minActiveBalance);
427     minActiveBalance = _minActiveBalance;
428   }
429 
430   // This function allows the nonstakers role to claim tokens owed to them by a specific protocol
431   /// @notice Choose an `_amount` of tokens that nonstakers (`_receiver` address) will receive from `_protocol`
432   /// @param _protocol Protocol identifier
433   /// @param _amount Amount of tokens
434   /// @param _receiver Address to receive tokens
435   /// @dev Only callable by nonstakers role
436   function nonStakersClaim(
437     bytes32 _protocol,
438     uint256 _amount,
439     address _receiver
440   ) external override whenNotPaused {
441     if (_protocol == bytes32(0)) revert ZeroArgument();
442     if (_amount == uint256(0)) revert ZeroArgument();
443     if (_receiver == address(0)) revert ZeroArgument();
444     // Only the nonstakers role (multisig or contract) can pull the funds
445     if (msg.sender != sherlockCore.nonStakersAddress()) revert Unauthorized();
446 
447     // Call can't be executed on protocol that is removed
448     if (protocolAgent_[_protocol] != address(0)) {
449       // Updates the amount that nonstakers can claim from this protocol
450       _settleProtocolDebt(_protocol);
451     }
452 
453     // Sets balance to the amount that is claimable by nonstakers for this specific protocol
454     uint256 balance = nonStakersClaimableByProtocol[_protocol];
455     // If the amount requested is more than what's owed to nonstakers, revert
456     if (_amount > balance) revert InsufficientBalance(_protocol);
457 
458     // Sets the claimable amount to whatever is left over after this amount is pulled
459     nonStakersClaimableByProtocol[_protocol] = balance - _amount;
460     // Transfers the amount requested to the `_receiver` address
461     token.safeTransfer(_receiver, _amount);
462   }
463 
464   // Transfers funds owed to stakers from this contract to the Sherlock core contract (where we handle paying out stakers)
465   /// @notice Transfer current claimable premiums (for stakers) to core Sherlock address
466   /// @dev Callable by everyone
467   /// @dev Funds will be transferred to Sherlock core contract
468   function claimPremiumsForStakers() external override whenNotPaused {
469     // Gets address of core Sherlock contract
470     address sherlock = address(sherlockCore);
471     // Revert if core Sherlock contract not initialized yet
472     if (sherlock == address(0)) revert InvalidConditions();
473 
474     // claimablePremiums is different from _settleTotalDebt() because it does not change state
475     // Retrieves current amount of all premiums that are owed to stakers
476     uint256 amount = claimablePremiums();
477 
478     // Transfers all the premiums owed to stakers to the Sherlock core contract
479     if (amount != 0) {
480       // Global value of premiums owed to stakers is set to zero since we are transferring the entire amount out
481       lastClaimablePremiumsForStakers = 0;
482       lastAccountedGlobal = block.timestamp;
483       token.safeTransfer(sherlock, amount);
484     }
485   }
486 
487   // Function is used in the SherlockClaimManager contract to decide if a proposed claim falls under either the current or previous coverage amounts
488   /// @param _protocol Protocol identifier
489   /// @return current and previous are the current and previous coverage amounts for this protocol
490   // Note For this process to work, a protocol's coverage amount should not be set more than once in the span of claim delay period (7 days or something)
491   function coverageAmounts(bytes32 _protocol)
492     external
493     view
494     override
495     returns (uint256 current, uint256 previous)
496   {
497     // Checks to see if the protocol has an active protocolAgent (protocol not removed)
498     // OR checks to see if the removed protocol is still within the claim window
499     // If so, gives the current and previous coverage, otherwise throws an error
500     if (
501       protocolAgent_[_protocol] != address(0) ||
502       block.timestamp <= removedProtocolClaimDeadline[_protocol]
503     ) {
504       return (currentCoverage[_protocol], previousCoverage[_protocol]);
505     }
506 
507     revert ProtocolNotExists(_protocol);
508   }
509 
510   /// @notice Add a new protocol to Sherlock
511   /// @param _protocol Protocol identifier
512   /// @param _protocolAgent Address able to submit a claim on behalf of the protocol
513   /// @param _coverage Hash referencing the active coverage agreement
514   /// @param _nonStakers Percentage of premium payments to nonstakers, scaled by 10**18
515   /// @param _coverageAmount Max amount claimable by this protocol
516   /// @dev Adding a protocol allows the `_protocolAgent` to submit a claim
517   /// @dev Coverage is not started yet as the protocol doesn't pay a premium at this point
518   /// @dev `_nonStakers` is scaled by 10**18
519   /// @dev Only callable by governance
520   function protocolAdd(
521     bytes32 _protocol,
522     address _protocolAgent,
523     bytes32 _coverage,
524     uint256 _nonStakers,
525     uint256 _coverageAmount
526   ) external override onlyOwner {
527     if (_protocol == bytes32(0)) revert ZeroArgument();
528     if (_protocolAgent == address(0)) revert ZeroArgument();
529     // Checks to make sure the protocol doesn't exist already
530     if (protocolAgent_[_protocol] != address(0)) revert InvalidConditions();
531 
532     // Updates the protocol agent and passes in the old agent which is 0 address in this case
533     _setProtocolAgent(_protocol, address(0), _protocolAgent);
534 
535     // Delete mappings that are potentially non default values
536     // From previous time protocol was added/removed
537     delete removedProtocolClaimDeadline[_protocol];
538     delete removedProtocolAgent[_protocol];
539     delete currentCoverage[_protocol];
540     delete previousCoverage[_protocol];
541 
542     emit ProtocolAdded(_protocol);
543 
544     // Most of the logic for actually adding a protocol in this function
545     protocolUpdate(_protocol, _coverage, _nonStakers, _coverageAmount);
546   }
547 
548   /// @notice Update info regarding a protocol
549   /// @param _protocol Protocol identifier
550   /// @param _coverage Hash referencing the active coverage agreement
551   /// @param _nonStakers Percentage of premium payments to nonstakers, scaled by 10**18
552   /// @param _coverageAmount Max amount claimable by this protocol
553   /// @dev Only callable by governance
554   /// @dev `_nonStakers` can be 0
555   function protocolUpdate(
556     bytes32 _protocol,
557     bytes32 _coverage,
558     uint256 _nonStakers,
559     uint256 _coverageAmount
560   ) public override onlyOwner {
561     if (_coverage == bytes32(0)) revert ZeroArgument();
562     if (_nonStakers > HUNDRED_PERCENT) revert InvalidArgument();
563     if (_coverageAmount == uint256(0)) revert ZeroArgument();
564 
565     // Checks to make sure the protocol has been assigned a protocol agent
566     _verifyProtocolExists(_protocol);
567 
568     // Subtracts the accrued debt from a protocol's active balance (if any)
569     // Updates the amount that can be claimed by nonstakers
570     _settleProtocolDebt(_protocol);
571 
572     // Updates the global claimable amount for stakers
573     _settleTotalDebt();
574 
575     // Gets the premium per second for this protocol
576     uint256 premium = premiums_[_protocol];
577 
578     // Updates allPremiumsPerSecToStakers (premium is not able to be updated in this function, but percentage to nonstakers can be)
579     allPremiumsPerSecToStakers = _calcGlobalPremiumPerSecForStakers(
580       premium,
581       premium,
582       nonStakersPercentage[_protocol],
583       _nonStakers,
584       allPremiumsPerSecToStakers
585     );
586 
587     // Updates the stored value of percentage of premiums that go to nonstakers
588     nonStakersPercentage[_protocol] = _nonStakers;
589 
590     // Updates previous coverage and current coverage amounts
591     previousCoverage[_protocol] = currentCoverage[_protocol];
592     currentCoverage[_protocol] = _coverageAmount;
593 
594     emit ProtocolUpdated(_protocol, _coverage, _nonStakers, _coverageAmount);
595   }
596 
597   /// @notice Remove a protocol from coverage
598   /// @param _protocol Protocol identifier
599   /// @dev Before removing a protocol the premium must be 0
600   /// @dev Removing a protocol basically stops the `_protocolAgent` from being active (can still submit claims until claim deadline though)
601   /// @dev Pays off debt + sends remaining balance to protocol agent
602   /// @dev This call should be subject to a timelock
603   /// @dev Only callable by governance
604   function protocolRemove(bytes32 _protocol) external override onlyOwner {
605     // checks to make sure the protocol actually has a protocol agent
606     address agent = _verifyProtocolExists(_protocol);
607 
608     // Removes a protocol from Sherlock and cleans up its data
609     // Params are the protocol ID and the protocol agent to which remaining active balance should be sent and from which post-removal claims can be made
610     _forceRemoveProtocol(_protocol, agent);
611   }
612 
613   /// @notice Remove a protocol with insufficient active balance
614   /// @param _protocol Protocol identifier
615   // msg.sender receives whatever is left of the insufficient active balance, this should incentivize arbs to call this function
616   /// @dev This call should be subject to a timelock
617   function forceRemoveByActiveBalance(bytes32 _protocol) external override whenNotPaused {
618     address agent = _verifyProtocolExists(_protocol);
619 
620     // Gets the latest value of the active balance at this protocol
621     _settleProtocolDebt(_protocol);
622     // Sets latest value of active balance to remainingBalance variable
623     uint256 remainingBalance = activeBalances[_protocol];
624 
625     // This means the protocol still has adequate active balance and thus cannot be removed
626     if (remainingBalance >= minActiveBalance) revert InvalidConditions();
627 
628     // Sets the protocol's active balance to 0
629     delete activeBalances[_protocol];
630     // Removes the protocol from coverage
631     _forceRemoveProtocol(_protocol, agent);
632 
633     if (remainingBalance != 0) {
634       // sends the remaining balance to msg.sender
635       token.safeTransfer(msg.sender, remainingBalance);
636     }
637     emit ProtocolRemovedByArb(_protocol, msg.sender, remainingBalance);
638   }
639 
640   /// @notice Calculate if arb is possible and what the reward would be
641   /// @param _protocol Protocol identifier
642   /// @return arbAmount Amount reward for arbing
643   /// @return able Indicator if arb call is even possible
644   /// @dev Doesn't subtract the current protocol debt from the active balance
645   function _calcForceRemoveBySecondsOfCoverage(bytes32 _protocol)
646     internal
647     view
648     returns (uint256 arbAmount, bool able)
649   {
650     uint256 secondsLeft = _secondsOfCoverageLeft(_protocol);
651 
652     // If arb is not possible return false
653     if (secondsLeft >= MIN_SECONDS_OF_COVERAGE) return (0, false);
654 
655     // This percentage scales over time
656     // Reaches 100% on 0 seconds of coverage left
657     uint256 percentageScaled = HUNDRED_PERCENT -
658       (secondsLeft * HUNDRED_PERCENT) /
659       MIN_SECONDS_OF_COVERAGE;
660 
661     able = true;
662     arbAmount = (activeBalances[_protocol] * percentageScaled) / HUNDRED_PERCENT;
663   }
664 
665   /// @notice Removes a protocol with insufficent seconds of coverage left
666   /// @param _protocol Protocol identifier
667   // Seconds of coverage is defined by the active balance of the protocol divided by the protocol's premium per second
668   function forceRemoveBySecondsOfCoverage(bytes32 _protocol) external override whenNotPaused {
669     // NOTE: We use _secondsOfCoverageLeft() below and include this check instead of secondsOfCoverageLeft() for gas savings
670     address agent = _verifyProtocolExists(_protocol);
671 
672     // NOTE: We don't give the arb the full remaining balance like we do in forceRemoveByActiveBalance()
673     // This is because we know the exact balance the arb will get in forceRemoveByActiveBalance()
674     // But when removing based on seconds of coverage left, the remainingBalance could still be quite large
675     // So it's better to scale the arb reward over time. It's a little complex because the remainingBalance
676     // Decreases over time also but reward will be highest at the midpoint of percentageScaled (50%)
677     _settleProtocolDebt(_protocol);
678     (uint256 arbAmount, bool able) = _calcForceRemoveBySecondsOfCoverage(_protocol);
679     if (able == false) revert InvalidConditions();
680 
681     if (arbAmount != 0) {
682       // subtracts the amount that will be paid to the arb from the active balance
683       activeBalances[_protocol] -= arbAmount;
684     }
685 
686     // Removes the protocol from coverage
687     // This function also pays the active balance to the protocol agent, so it's good we do this after subtracting arb amount above
688     _forceRemoveProtocol(_protocol, agent);
689 
690     // Done after removing protocol to mitigate reentrency pattern
691     // (In case token allows callback)
692     if (arbAmount != 0) {
693       token.safeTransfer(msg.sender, arbAmount);
694     }
695     emit ProtocolRemovedByArb(_protocol, msg.sender, arbAmount);
696   }
697 
698   /// @notice Set premium of `_protocol` to `_premium`
699   /// @param _protocol Protocol identifier
700   /// @param _premium Amount of premium `_protocol` pays per second
701   /// @dev The value 0 would mean inactive coverage
702   /// @dev Only callable by governance
703   function setProtocolPremium(bytes32 _protocol, uint256 _premium) external override onlyOwner {
704     // Checks to see if protocol has a protocol agent
705     _verifyProtocolExists(_protocol);
706 
707     // Updates individual protocol's premium and allPremiumsPerSecToStakers
708     _setSingleAndGlobalProtocolPremium(_protocol, _premium);
709   }
710 
711   /// @notice Set premium of multiple protocols
712   /// @param _protocol Array of protocol identifiers
713   /// @param _premium Array of premium amounts protocols pay per second
714   /// @dev The value 0 would mean inactive coverage
715   /// @dev Only callable by governance
716   function setProtocolPremiums(bytes32[] calldata _protocol, uint256[] calldata _premium)
717     external
718     override
719     onlyOwner
720   {
721     // Checks to make sure there are an equal amount of entries in each array
722     if (_protocol.length != _premium.length) revert UnequalArrayLength();
723     if (_protocol.length == 0) revert InvalidArgument();
724 
725     // Updates the global claimable amount for stakers
726     _settleTotalDebt();
727 
728     uint256 allPremiumsPerSecToStakers_ = allPremiumsPerSecToStakers;
729 
730     // Loops through the array of protocols and checks to make sure each has a protocol agent assigned
731     for (uint256 i; i < _protocol.length; i++) {
732       _verifyProtocolExists(_protocol[i]);
733 
734       // Sets the protocol premium for that specific protocol
735       // Function returns the old premium and nonStakerPercentage for that specific protocol
736       (uint256 oldPremiumPerSecond, uint256 nonStakerPercentage) = _setSingleProtocolPremium(
737         _protocol[i],
738         _premium[i]
739       );
740 
741       // Calculates the new global premium which adds up all premiums paid by all protocols
742       allPremiumsPerSecToStakers_ = _calcGlobalPremiumPerSecForStakers(
743         oldPremiumPerSecond,
744         _premium[i],
745         nonStakerPercentage,
746         nonStakerPercentage,
747         allPremiumsPerSecToStakers_
748       );
749     }
750 
751     // After the loop has finished, sets allPremiumsPerSecToStakers to the final temp value
752     allPremiumsPerSecToStakers = allPremiumsPerSecToStakers_;
753   }
754 
755   // This is how protocols pay for coverage by increasing their active balance
756   /// @notice Deposits `_amount` of token to the active balance of `_protocol`
757   /// @param _protocol Protocol identifier
758   /// @param _amount Amount of tokens to deposit
759   /// @dev Approval should be made before calling
760   function depositToActiveBalance(bytes32 _protocol, uint256 _amount)
761     external
762     override
763     whenNotPaused
764   {
765     if (_amount == uint256(0)) revert ZeroArgument();
766     _verifyProtocolExists(_protocol);
767 
768     // Transfers _amount to this contract
769     token.safeTransferFrom(msg.sender, address(this), _amount);
770     // Increases the active balance of the protocol by _amount
771     activeBalances[_protocol] += _amount;
772 
773     emit ProtocolBalanceDeposited(_protocol, _amount);
774   }
775 
776   // If a protocol has paid too much into the active balance (which is how a protocol pays the premium)
777   // Then the protocol can remove some of the active balance (up until there is 7 days worth of balance left)
778   /// @notice Withdraws `_amount` of token from the active balance of `_protocol`
779   /// @param _protocol Protocol identifier
780   /// @param _amount Amount of tokens to withdraw
781   /// @dev Only protocol agent is able to withdraw
782   /// @dev Balance can be withdrawn up until 7 days worth of active balance
783   function withdrawActiveBalance(bytes32 _protocol, uint256 _amount)
784     external
785     override
786     whenNotPaused
787   {
788     if (_amount == uint256(0)) revert ZeroArgument();
789     // Only the protocol agent can call this function
790     if (msg.sender != _verifyProtocolExists(_protocol)) revert Unauthorized();
791 
792     // Updates the active balance of the protocol
793     _settleProtocolDebt(_protocol);
794 
795     // Sets currentBalance to the active balance of the protocol
796     uint256 currentBalance = activeBalances[_protocol];
797     // Reverts if trying to withdraw more than the active balance
798     if (_amount > currentBalance) revert InsufficientBalance(_protocol);
799 
800     // Removes the _amount to be withdrawn from the active balance
801     activeBalances[_protocol] = currentBalance - _amount;
802     // Reverts if a protocol has less than 7 days worth of active balance left
803     if (_secondsOfCoverageLeft(_protocol) < MIN_SECONDS_LEFT) revert InsufficientBalance(_protocol);
804 
805     // Transfers the amount to the msg.sender (protocol agent)
806     token.safeTransfer(msg.sender, _amount);
807     emit ProtocolBalanceWithdrawn(_protocol, _amount);
808   }
809 
810   /// @notice Transfer protocol agent role
811   /// @param _protocol Protocol identifier
812   /// @param _protocolAgent Account able to submit a claim on behalf of the protocol
813   /// @dev Only the active protocolAgent is able to transfer the role
814   function transferProtocolAgent(bytes32 _protocol, address _protocolAgent)
815     external
816     override
817     whenNotPaused
818   {
819     if (_protocolAgent == address(0)) revert ZeroArgument();
820     // Can't set the new protocol agent to the caller address
821     if (msg.sender == _protocolAgent) revert InvalidArgument();
822     // Because the caller must be the current protocol agent
823     if (msg.sender != _verifyProtocolExists(_protocol)) revert Unauthorized();
824 
825     // Sets the protocol agent to the new address
826     _setProtocolAgent(_protocol, msg.sender, _protocolAgent);
827   }
828 
829   /// @notice Function used to check if this is the current active protocol manager
830   /// @return Boolean indicating it's active
831   /// @dev If inactive the owner can pull all ERC20s and ETH
832   /// @dev Will be checked by calling the sherlock contract
833   function isActive() public view returns (bool) {
834     return address(sherlockCore.sherlockProtocolManager()) == address(this);
835   }
836 
837   // Only contract owner can call this
838   // Sends all specified tokens in this contract to the receiver's address (as well as ETH)
839   function sweep(address _receiver, IERC20[] memory _extraTokens) external onlyOwner {
840     if (_receiver == address(0)) revert ZeroArgument();
841     // This contract must NOT be the current assigned protocol manager contract
842     if (isActive()) revert InvalidConditions();
843     // Executes the sweep for ERC-20s specified in _extraTokens as well as for ETH
844     _sweep(_receiver, _extraTokens);
845   }
846 }
