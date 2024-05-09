1 pragma solidity 0.5.11; // optimization runs: 200, evm version: petersburg
2 
3 
4 interface DharmaAccountRecoveryManagerInterface {
5   // Fires an event whenever a user signing key is recovered for an account.
6   event Recovery(
7     address indexed wallet, address oldUserSigningKey, address newUserSigningKey
8   );
9 
10   // Fire an event whenever account recovery is disabled for an account.
11   event RecoveryDisabled(address wallet);
12 
13   function initiateAccountRecovery(
14     address smartWallet, address userSigningKey, uint256 extraTime
15   ) external;
16 
17   function initiateAccountRecoveryDisablement(
18     address smartWallet, uint256 extraTime
19   ) external;
20 
21   function recover(address wallet, address newUserSigningKey) external;
22 
23   function disableAccountRecovery(address wallet) external;
24 
25   function accountRecoveryDisabled(
26     address wallet
27   ) external view returns (bool hasDisabledAccountRecovery);
28 }
29 
30 
31 interface DharmaAccountRecoveryManagerV2Interface {
32   // Fires an event whenever a pending account recovery is cancelled.
33   event RecoveryCancelled(
34     address indexed wallet, address cancelledUserSigningKey
35   );
36 
37   event RecoveryDisablementCancelled(address wallet);
38 
39   event RoleModified(Role indexed role, address account);
40 
41   event RolePaused(Role indexed role);
42 
43   event RoleUnpaused(Role indexed role);
44 
45   enum Role {
46     OPERATOR,
47     RECOVERER,
48     CANCELLER,
49     DISABLER,
50     PAUSER
51   }
52 
53   struct RoleStatus {
54     address account;
55     bool paused;
56   }
57 
58   function cancelAccountRecovery(
59     address smartWallet, address newUserSigningKey
60   ) external;
61 
62   function cancelAccountRecoveryDisablement(address smartWallet) external;
63 
64   function setRole(Role role, address account) external;
65 
66   function removeRole(Role role) external;
67 
68   function pause(Role role) external;
69 
70   function unpause(Role role) external;
71 
72   function isPaused(Role role) external view returns (bool paused);
73 
74   function isRole(Role role) external view returns (bool hasRole);
75 
76   function getOperator() external view returns (address operator);
77 
78   function getRecoverer() external view returns (address recoverer);
79 
80   function getCanceller() external view returns (address canceller);
81 
82   function getDisabler() external view returns (address disabler);
83 
84   function getPauser() external view returns (address pauser);
85 }
86 
87 
88 interface TimelockerInterface {
89   // Fire an event any time a timelock is initiated.
90   event TimelockInitiated(
91     bytes4 functionSelector, // selector of the function
92     uint256 timeComplete,    // timestamp at which the function can be called
93     bytes arguments,         // abi-encoded function arguments to call with
94     uint256 timeExpired      // timestamp where function can no longer be called
95   );
96 
97   // Fire an event any time a minimum timelock interval is modified.
98   event TimelockIntervalModified(
99     bytes4 functionSelector, // selector of the function
100     uint256 oldInterval,     // old minimum timelock interval for the function
101     uint256 newInterval      // new minimum timelock interval for the function
102   );
103 
104   // Fire an event any time a default timelock expiration is modified.
105   event TimelockExpirationModified(
106     bytes4 functionSelector, // selector of the function
107     uint256 oldExpiration,   // old default timelock expiration for the function
108     uint256 newExpiration    // new default timelock expiration for the function
109   );
110 
111   // Each timelock has timestamps for when it is complete and when it expires.
112   struct Timelock {
113     uint128 complete;
114     uint128 expires;
115   }
116 
117   // Functions have a timelock interval and time from completion to expiration.
118   struct TimelockDefaults {
119     uint128 interval;
120     uint128 expiration;
121   }
122 
123   function getTimelock(
124     bytes4 functionSelector, bytes calldata arguments
125   ) external view returns (
126     bool exists,
127     bool completed,
128     bool expired,
129     uint256 completionTime,
130     uint256 expirationTime
131   );
132 
133   function getDefaultTimelockInterval(
134     bytes4 functionSelector
135   ) external view returns (uint256 defaultTimelockInterval);
136 
137   function getDefaultTimelockExpiration(
138     bytes4 functionSelector
139   ) external view returns (uint256 defaultTimelockExpiration);
140 }
141 
142 
143 interface TimelockerModifiersInterface {
144   function initiateModifyTimelockInterval(
145     bytes4 functionSelector, uint256 newTimelockInterval, uint256 extraTime
146   ) external;
147 
148   function modifyTimelockInterval(
149     bytes4 functionSelector, uint256 newTimelockInterval
150   ) external;
151 
152   function initiateModifyTimelockExpiration(
153     bytes4 functionSelector, uint256 newTimelockExpiration, uint256 extraTime
154   ) external;
155 
156   function modifyTimelockExpiration(
157     bytes4 functionSelector, uint256 newTimelockExpiration
158   ) external;
159 }
160 
161 
162 interface DharmaSmartWalletRecoveryInterface {
163   function recover(address newUserSigningKey) external;
164   function getUserSigningKey() external view returns (address userSigningKey);
165 }
166 
167 
168 library SafeMath {
169   function add(uint256 a, uint256 b) internal pure returns (uint256) {
170     uint256 c = a + b;
171     require(c >= a, "SafeMath: addition overflow");
172 
173     return c;
174   }
175 
176   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177     require(b <= a, "SafeMath: subtraction overflow");
178     uint256 c = a - b;
179 
180     return c;
181   }
182 
183   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184     if (a == 0) {
185       return 0;
186     }
187 
188     uint256 c = a * b;
189     require(c / a == b, "SafeMath: multiplication overflow");
190 
191     return c;
192   }
193 
194   function div(uint256 a, uint256 b) internal pure returns (uint256) {
195     require(b > 0, "SafeMath: division by zero");
196     uint256 c = a / b;
197 
198     return c;
199   }
200 
201   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
202     require(b != 0, "SafeMath: modulo by zero");
203     return a % b;
204   }
205 }
206 
207 
208 /**
209  * @dev Contract module which provides a basic access control mechanism, where
210  * there is an account (an owner) that can be granted exclusive access to
211  * specific functions.
212  *
213  * This module is used through inheritance. It will make available the modifier
214  * `onlyOwner`, which can be aplied to your functions to restrict their use to
215  * the owner.
216  *
217  * In order to transfer ownership, a recipient must be specified, at which point
218  * the specified recipient can call `acceptOwnership` and take ownership.
219  */
220 contract TwoStepOwnable {
221   address private _owner;
222 
223   address private _newPotentialOwner;
224 
225   event OwnershipTransferred(
226     address indexed previousOwner,
227     address indexed newOwner
228   );
229 
230   /**
231    * @dev Initialize contract by setting transaction submitter as initial owner.
232    */
233   constructor() internal {
234     _owner = tx.origin;
235     emit OwnershipTransferred(address(0), _owner);
236   }
237 
238   /**
239    * @dev Returns the address of the current owner.
240    */
241   function owner() public view returns (address) {
242     return _owner;
243   }
244 
245   /**
246    * @dev Throws if called by any account other than the owner.
247    */
248   modifier onlyOwner() {
249     require(isOwner(), "TwoStepOwnable: caller is not the owner.");
250     _;
251   }
252 
253   /**
254    * @dev Returns true if the caller is the current owner.
255    */
256   function isOwner() public view returns (bool) {
257     return msg.sender == _owner;
258   }
259 
260   /**
261    * @dev Allows a new account (`newOwner`) to accept ownership.
262    * Can only be called by the current owner.
263    */
264   function transferOwnership(address newOwner) public onlyOwner {
265     require(
266       newOwner != address(0),
267       "TwoStepOwnable: new potential owner is the zero address."
268     );
269 
270     _newPotentialOwner = newOwner;
271   }
272 
273   /**
274    * @dev Cancel a transfer of ownership to a new account.
275    * Can only be called by the current owner.
276    */
277   function cancelOwnershipTransfer() public onlyOwner {
278     delete _newPotentialOwner;
279   }
280 
281   /**
282    * @dev Transfers ownership of the contract to the caller.
283    * Can only be called by a new potential owner set by the current owner.
284    */
285   function acceptOwnership() public {
286     require(
287       msg.sender == _newPotentialOwner,
288       "TwoStepOwnable: current owner must set caller as new potential owner."
289     );
290 
291     delete _newPotentialOwner;
292 
293     emit OwnershipTransferred(_owner, msg.sender);
294 
295     _owner = msg.sender;
296   }
297 }
298 
299 
300 /**
301  * @title TimelockerV2
302  * @author 0age
303  * @notice This contract allows contracts that inherit it to implement timelocks
304  * on functions, where the `_setTimelock` internal function must first be called
305  * and passed the target function selector and arguments. Then, a given time
306  * interval must first fully transpire before the timelock functions can be
307  * successfully called. Furthermore, once a timelock is complete, it will expire
308  * after a period of time. In order to change timelock intervals or expirations,
309  * the inheriting contract needs to implement `modifyTimelockInterval` and
310  * `modifyTimelockExpiration` functions, respectively, as well as functions that
311  * call `_setTimelock` in order to initiate the timelocks for those functions.
312  * To make a function timelocked, use the `_enforceTimelock` internal function.
313  * To set initial defult minimum timelock intervals and expirations, use the
314  * `_setInitialTimelockInterval` and `_setInitialTimelockExpiration` internal
315  * functions - they can only be used during contract creation. Additionally,
316  * there are three external getters (and internal equivalents): `getTimelock`,
317  * `getDefaultTimelockInterval`, and `getDefaultTimelockExpiration`. Finally,
318  * version two of the timelocker builds on version one by including an internal
319  * `_expireTimelock` function for expiring an existing timelock, which can then
320  * be reactivated as long as the completion time does not become shorter than
321  * the original completion time.
322  */
323 contract TimelockerV2 is TimelockerInterface {
324   using SafeMath for uint256;
325 
326   // Implement a timelock for each function and set of arguments.
327   mapping(bytes4 => mapping(bytes32 => Timelock)) private _timelocks;
328 
329   // Implement default timelock intervals and expirations for each function.
330   mapping(bytes4 => TimelockDefaults) private _timelockDefaults;
331 
332   // Only allow one new interval or expiration change at a time per function.
333   mapping(bytes4 => mapping(bytes4 => bytes32)) private _protectedTimelockIDs;
334 
335   // Store modifyTimelockInterval function selector as a constant.
336   bytes4 private constant _MODIFY_TIMELOCK_INTERVAL_SELECTOR = bytes4(
337     0xe950c085
338   );
339 
340   // Store modifyTimelockExpiration function selector as a constant.
341   bytes4 private constant _MODIFY_TIMELOCK_EXPIRATION_SELECTOR = bytes4(
342     0xd7ce3c6f
343   );
344 
345   // Set a ridiculously high duration in order to protect against overflows.
346   uint256 private constant _A_TRILLION_YEARS = 365000000000000 days;
347 
348   /**
349    * @notice In the constructor, confirm that selectors specified as constants
350    * are correct.
351    */
352   constructor() internal {
353     TimelockerModifiersInterface modifiers;
354 
355     bytes4 targetModifyInterval = modifiers.modifyTimelockInterval.selector;
356     require(
357       _MODIFY_TIMELOCK_INTERVAL_SELECTOR == targetModifyInterval,
358       "Incorrect modify timelock interval selector supplied."
359     );
360 
361     bytes4 targetModifyExpiration = modifiers.modifyTimelockExpiration.selector;
362     require(
363       _MODIFY_TIMELOCK_EXPIRATION_SELECTOR == targetModifyExpiration,
364       "Incorrect modify timelock expiration selector supplied."
365     );
366   }
367 
368   /**
369    * @notice View function to check if a timelock for the specified function and
370    * arguments has completed.
371    * @param functionSelector Function to be called.
372    * @param arguments The abi-encoded arguments of the function to be called.
373    * @return A boolean indicating if the timelock exists or not and the time at
374    * which the timelock completes if it does exist.
375    */
376   function getTimelock(
377     bytes4 functionSelector, bytes memory arguments
378   ) public view returns (
379     bool exists,
380     bool completed,
381     bool expired,
382     uint256 completionTime,
383     uint256 expirationTime
384   ) {
385     // Get information on the current timelock, if one exists.
386     (exists, completed, expired, completionTime, expirationTime) = _getTimelock(
387       functionSelector, arguments
388     );
389   }
390 
391   /**
392    * @notice View function to check the current minimum timelock interval on a
393    * given function.
394    * @param functionSelector Function to retrieve the timelock interval for.
395    * @return The current minimum timelock interval for the given function.
396    */
397   function getDefaultTimelockInterval(
398     bytes4 functionSelector
399   ) public view returns (uint256 defaultTimelockInterval) {
400     defaultTimelockInterval = _getDefaultTimelockInterval(functionSelector);
401   }
402 
403   /**
404    * @notice View function to check the current default timelock expiration on a
405    * given function.
406    * @param functionSelector Function to retrieve the timelock expiration for.
407    * @return The current default timelock expiration for the given function.
408    */
409   function getDefaultTimelockExpiration(
410     bytes4 functionSelector
411   ) public view returns (uint256 defaultTimelockExpiration) {
412     defaultTimelockExpiration = _getDefaultTimelockExpiration(functionSelector);
413   }
414 
415   /**
416    * @notice Internal function that sets a timelock so that the specified
417    * function can be called with the specified arguments. Note that existing
418    * timelocks may be extended, but not shortened - this can also be used as a
419    * method for "cancelling" a function call by extending the timelock to an
420    * arbitrarily long duration. Keep in mind that new timelocks may be created
421    * with a shorter duration on functions that already have other timelocks on
422    * them, but only if they have different arguments.
423    * @param functionSelector Selector of the function to be called.
424    * @param arguments The abi-encoded arguments of the function to be called.
425    * @param extraTime Additional time in seconds to add to the minimum timelock
426    * interval for the given function.
427    */
428   function _setTimelock(
429     bytes4 functionSelector, bytes memory arguments, uint256 extraTime
430   ) internal {
431     // Ensure that the specified extra time will not cause an overflow error.
432     require(extraTime < _A_TRILLION_YEARS, "Supplied extra time is too large.");
433 
434     // Get timelock ID using the supplied function arguments.
435     bytes32 timelockID = keccak256(abi.encodePacked(arguments));
436 
437     // For timelock interval or expiration changes, first drop any existing
438     // timelock for the function being modified if the argument has changed.
439     if (
440       functionSelector == _MODIFY_TIMELOCK_INTERVAL_SELECTOR ||
441       functionSelector == _MODIFY_TIMELOCK_EXPIRATION_SELECTOR
442     ) {
443       // Determine the function that will be modified by the timelock.
444       (bytes4 modifiedFunction, uint256 duration) = abi.decode(
445         arguments, (bytes4, uint256)
446       );
447 
448       // Ensure that the new timelock duration will not cause an overflow error.
449       require(
450         duration < _A_TRILLION_YEARS,
451         "Supplied default timelock duration to modify is too large."
452       );
453 
454       // Determine the current timelockID, if any, for the modified function.
455       bytes32 currentTimelockID = (
456         _protectedTimelockIDs[functionSelector][modifiedFunction]
457       );
458 
459       // Determine if current timelockID differs from what is currently set.
460       if (currentTimelockID != timelockID) {
461         // Drop existing timelock if one exists and has a different timelockID.
462         if (currentTimelockID != bytes32(0)) {
463           delete _timelocks[functionSelector][currentTimelockID];
464         }
465 
466         // Register the new timelockID as the current protected timelockID.
467         _protectedTimelockIDs[functionSelector][modifiedFunction] = timelockID;
468       }
469     }
470 
471     // Get timelock using current time, inverval for timelock ID, & extra time.
472     uint256 timelock = uint256(
473       _timelockDefaults[functionSelector].interval
474     ).add(now).add(extraTime);
475 
476     // Get expiration time using timelock duration plus default expiration time.
477     uint256 expiration = timelock.add(
478       uint256(_timelockDefaults[functionSelector].expiration)
479     );
480 
481     // Get the current timelock, if one exists.
482     Timelock storage timelockStorage = _timelocks[functionSelector][timelockID];
483 
484     // Determine the duration of the current timelock.
485     uint256 currentTimelock = uint256(timelockStorage.complete);
486 
487     // Ensure that the timelock duration does not decrease. Note that a new,
488     // shorter timelock may still be set up on the same function in the event
489     // that it is provided with different arguments. Also note that this can be
490     // circumvented when modifying intervals or expirations by setting a new
491     // timelock (removing the old one), then resetting the original timelock but
492     // with a shorter duration.
493     require(
494       currentTimelock == 0 || timelock > currentTimelock,
495       "Existing timelocks may only be extended."
496     );
497 
498     // Set timelock completion and expiration using timelock ID and extra time.
499     timelockStorage.complete = uint128(timelock);
500     timelockStorage.expires = uint128(expiration);
501 
502     // Emit an event with all of the relevant information.
503     emit TimelockInitiated(functionSelector, timelock, arguments, expiration);
504   }
505 
506   /**
507    * @notice Internal function for setting a new timelock interval for a given
508    * function selector. The default for this function may also be modified, but
509    * excessive values will cause the `modifyTimelockInterval` function to become
510    * unusable.
511    * @param functionSelector The selector of the function to set the timelock
512    * interval for.
513    * @param newTimelockInterval the new minimum timelock interval to set for the
514    * given function.
515    */
516   function _modifyTimelockInterval(
517     bytes4 functionSelector, uint256 newTimelockInterval
518   ) internal {
519     // Ensure that the timelock has been set and is completed.
520     _enforceTimelockPrivate(
521       _MODIFY_TIMELOCK_INTERVAL_SELECTOR,
522       abi.encode(functionSelector, newTimelockInterval)
523     );
524 
525     // Clear out the existing timelockID protection for the given function.
526     delete _protectedTimelockIDs[
527       _MODIFY_TIMELOCK_INTERVAL_SELECTOR
528     ][functionSelector];
529 
530     // Set new timelock interval and emit a `TimelockIntervalModified` event.
531     _setTimelockIntervalPrivate(functionSelector, newTimelockInterval);
532   }
533 
534   /**
535    * @notice Internal function for setting a new timelock expiration for a given
536    * function selector. Once the minimum interval has elapsed, the timelock will
537    * expire once the specified expiration time has elapsed. Setting this value
538    * too low will result in timelocks that are very difficult to execute
539    * correctly. Be sure to override the public version of this function with
540    * appropriate access controls.
541    * @param functionSelector The selector of the function to set the timelock
542    * expiration for.
543    * @param newTimelockExpiration The new minimum timelock expiration to set for
544    * the given function.
545    */
546   function _modifyTimelockExpiration(
547     bytes4 functionSelector, uint256 newTimelockExpiration
548   ) internal {
549     // Ensure that the timelock has been set and is completed.
550     _enforceTimelockPrivate(
551       _MODIFY_TIMELOCK_EXPIRATION_SELECTOR,
552       abi.encode(functionSelector, newTimelockExpiration)
553     );
554 
555     // Clear out the existing timelockID protection for the given function.
556     delete _protectedTimelockIDs[
557       _MODIFY_TIMELOCK_EXPIRATION_SELECTOR
558     ][functionSelector];
559 
560     // Set new default expiration and emit a `TimelockExpirationModified` event.
561     _setTimelockExpirationPrivate(functionSelector, newTimelockExpiration);
562   }
563 
564   /**
565    * @notice Internal function to set an initial timelock interval for a given
566    * function selector. Only callable during contract creation.
567    * @param functionSelector The selector of the function to set the timelock
568    * interval for.
569    * @param newTimelockInterval The new minimum timelock interval to set for the
570    * given function.
571    */
572   function _setInitialTimelockInterval(
573     bytes4 functionSelector, uint256 newTimelockInterval
574   ) internal {
575     // Ensure that this function is only callable during contract construction.
576     assembly { if extcodesize(address) { revert(0, 0) } }
577 
578     // Set the timelock interval and emit a `TimelockIntervalModified` event.
579     _setTimelockIntervalPrivate(functionSelector, newTimelockInterval);
580   }
581 
582   /**
583    * @notice Internal function to set an initial timelock expiration for a given
584    * function selector. Only callable during contract creation.
585    * @param functionSelector The selector of the function to set the timelock
586    * expiration for.
587    * @param newTimelockExpiration The new minimum timelock expiration to set for
588    * the given function.
589    */
590   function _setInitialTimelockExpiration(
591     bytes4 functionSelector, uint256 newTimelockExpiration
592   ) internal {
593     // Ensure that this function is only callable during contract construction.
594     assembly { if extcodesize(address) { revert(0, 0) } }
595 
596     // Set the timelock interval and emit a `TimelockExpirationModified` event.
597     _setTimelockExpirationPrivate(functionSelector, newTimelockExpiration);
598   }
599 
600   /**
601    * @notice Internal function to expire or cancel a timelock so it is no longer
602    * usable. Once it has been expired, the timelock in question will only be
603    * reactivated if the timelock is reset, and this operation is only permitted
604    * if the completion time is not shorter than the original completion time.
605    * @param functionSelector The function that the timelock to expire is set on.
606    * @param arguments The abi-encoded arguments of the timelocked function call
607    * to be expired.
608    */
609   function _expireTimelock(
610     bytes4 functionSelector, bytes memory arguments
611   ) internal {
612     // Get timelock ID using the supplied function arguments.
613     bytes32 timelockID = keccak256(abi.encodePacked(arguments));
614 
615     // Get the current timelock, if one exists.
616     Timelock storage timelock = _timelocks[functionSelector][timelockID];
617 
618     uint256 currentTimelock = uint256(timelock.complete);
619     uint256 expiration = uint256(timelock.expires);
620 
621     // Ensure a timelock is currently set for the given function and arguments.
622     require(currentTimelock != 0, "No timelock found for the given arguments.");
623 
624     // Ensure that the timelock has not already expired.
625     require(expiration > now, "Timelock has already expired.");
626 
627     // Mark the timelock as expired.
628     timelock.expires = uint128(0);
629   }
630 
631   /**
632    * @notice Internal function to ensure that a timelock is complete or expired
633    * and to clear the existing timelock if it is complete so it cannot later be
634    * reused. The function to enforce the timelock on is inferred from `msg.sig`.
635    * @param arguments The abi-encoded arguments of the function to be called.
636    */
637   function _enforceTimelock(bytes memory arguments) internal {
638     // Enforce the relevant timelock.
639     _enforceTimelockPrivate(msg.sig, arguments);
640   }
641 
642   /**
643    * @notice Internal view function to check if a timelock for the specified
644    * function and arguments has completed.
645    * @param functionSelector Function to be called.
646    * @param arguments The abi-encoded arguments of the function to be called.
647    * @return A boolean indicating if the timelock exists or not and the time at
648    * which the timelock completes if it does exist.
649    */
650   function _getTimelock(
651     bytes4 functionSelector, bytes memory arguments
652   ) internal view returns (
653     bool exists,
654     bool completed,
655     bool expired,
656     uint256 completionTime,
657     uint256 expirationTime
658   ) {
659     // Get timelock ID using the supplied function arguments.
660     bytes32 timelockID = keccak256(abi.encodePacked(arguments));
661 
662     // Get information on the current timelock, if one exists.
663     completionTime = uint256(_timelocks[functionSelector][timelockID].complete);
664     exists = completionTime != 0;
665     expirationTime = uint256(_timelocks[functionSelector][timelockID].expires);
666     completed = exists && now > completionTime;
667     expired = exists && now > expirationTime;
668   }
669 
670   /**
671    * @notice Internal view function to check the current minimum timelock
672    * interval on a given function.
673    * @param functionSelector Function to retrieve the timelock interval for.
674    * @return The current minimum timelock interval for the given function.
675    */
676   function _getDefaultTimelockInterval(
677     bytes4 functionSelector
678   ) internal view returns (uint256 defaultTimelockInterval) {
679     defaultTimelockInterval = uint256(
680       _timelockDefaults[functionSelector].interval
681     );
682   }
683 
684   /**
685    * @notice Internal view function to check the current default timelock
686    * expiration on a given function.
687    * @param functionSelector Function to retrieve the timelock expiration for.
688    * @return The current default timelock expiration for the given function.
689    */
690   function _getDefaultTimelockExpiration(
691     bytes4 functionSelector
692   ) internal view returns (uint256 defaultTimelockExpiration) {
693     defaultTimelockExpiration = uint256(
694       _timelockDefaults[functionSelector].expiration
695     );
696   }
697 
698   /**
699    * @notice Private function to ensure that a timelock is complete or expired
700    * and to clear the existing timelock if it is complete so it cannot later be
701    * reused.
702    * @param functionSelector Function to be called.
703    * @param arguments The abi-encoded arguments of the function to be called.
704    */
705   function _enforceTimelockPrivate(
706     bytes4 functionSelector, bytes memory arguments
707   ) private {
708     // Get timelock ID using the supplied function arguments.
709     bytes32 timelockID = keccak256(abi.encodePacked(arguments));
710 
711     // Get the current timelock, if one exists.
712     Timelock memory timelock = _timelocks[functionSelector][timelockID];
713 
714     uint256 currentTimelock = uint256(timelock.complete);
715     uint256 expiration = uint256(timelock.expires);
716 
717     // Ensure that the timelock is set and has completed.
718     require(
719       currentTimelock != 0 && currentTimelock <= now, "Timelock is incomplete."
720     );
721 
722     // Ensure that the timelock has not expired.
723     require(expiration > now, "Timelock has expired.");
724 
725     // Clear out the existing timelock so that it cannot be reused.
726     delete _timelocks[functionSelector][timelockID];
727   }
728 
729   /**
730    * @notice Private function for setting a new timelock interval for a given
731    * function selector.
732    * @param functionSelector the selector of the function to set the timelock
733    * interval for.
734    * @param newTimelockInterval the new minimum timelock interval to set for the
735    * given function.
736    */
737   function _setTimelockIntervalPrivate(
738     bytes4 functionSelector, uint256 newTimelockInterval
739   ) private {
740     // Ensure that the new timelock interval will not cause an overflow error.
741     require(
742       newTimelockInterval < _A_TRILLION_YEARS,
743       "Supplied minimum timelock interval is too large."
744     );
745 
746     // Get the existing timelock interval, if any.
747     uint256 oldTimelockInterval = uint256(
748       _timelockDefaults[functionSelector].interval
749     );
750 
751     // Update the timelock interval on the provided function.
752     _timelockDefaults[functionSelector].interval = uint128(newTimelockInterval);
753 
754     // Emit a `TimelockIntervalModified` event with the appropriate arguments.
755     emit TimelockIntervalModified(
756       functionSelector, oldTimelockInterval, newTimelockInterval
757     );
758   }
759 
760   /**
761    * @notice Private function for setting a new timelock expiration for a given
762    * function selector.
763    * @param functionSelector the selector of the function to set the timelock
764    * interval for.
765    * @param newTimelockExpiration the new default timelock expiration to set for
766    * the given function.
767    */
768   function _setTimelockExpirationPrivate(
769     bytes4 functionSelector, uint256 newTimelockExpiration
770   ) private {
771     // Ensure that the new timelock expiration will not cause an overflow error.
772     require(
773       newTimelockExpiration < _A_TRILLION_YEARS,
774       "Supplied default timelock expiration is too large."
775     );
776 
777     // Ensure that the new timelock expiration is not too short.
778     require(
779       newTimelockExpiration > 1 minutes,
780       "New timelock expiration is too short."
781     );
782 
783     // Get the existing timelock expiration, if any.
784     uint256 oldTimelockExpiration = uint256(
785       _timelockDefaults[functionSelector].expiration
786     );
787 
788     // Update the timelock expiration on the provided function.
789     _timelockDefaults[functionSelector].expiration = uint128(
790       newTimelockExpiration
791     );
792 
793     // Emit a `TimelockExpirationModified` event with the appropriate arguments.
794     emit TimelockExpirationModified(
795       functionSelector, oldTimelockExpiration, newTimelockExpiration
796     );
797   }
798 }
799 
800 
801 /**
802  * @title DharmaAccountRecoveryManagerV2
803  * @author 0age
804  * @notice This contract is owned by an Account Recovery multisig and manages
805  * resets to user signing keys when necessary. It implements a set of timelocked
806  * functions, where the `setTimelock` function must first be called, with the
807  * same arguments that the function will be supplied with. Then, a given time
808  * interval must first fully transpire before the timelock functions can be
809  * successfully called.
810  *
811  * The timelocked functions currently implemented include:
812  *  recover(address wallet, address newUserSigningKey)
813  *  disableAccountRecovery(address wallet)
814  *  modifyTimelockInterval(bytes4 functionSelector, uint256 newTimelockInterval)
815  *  modifyTimelockExpiration(
816  *    bytes4 functionSelector, uint256 newTimelockExpiration
817  *  )
818  *
819  * Note that special care should be taken to differentiate between lost keys and
820  * compromised keys, and that the danger of a user being impersonated is
821  * extremely high. Account recovery should progress to a system where the user
822  * builds their preferred account recovery procedure into a "key ring" smart
823  * contract at their signing address, reserving this "hard reset" for extremely
824  * unusual circumstances and eventually sunsetting it entirely.
825  *
826  * V2 of the Account Recovery Manager builds on V1 by introducing the concept of
827  * "roles" - these are dedicated accounts that can be modified by the owner, and
828  * that can trigger specific functionality on the manager. These roles are:
829  *  - operator: initiates timelocks for account recovery + disablement
830  *  - recoverer: triggers account recovery once timelock is complete
831  *  - disabler: triggers account recovery disablement once timelock is complete
832  *  - canceller: cancels account recovery and recovery disablement timelocks
833  *  - pauser: pauses any role (where only the owner is then able to unpause it)
834  *
835  * V2 also provides dedicated methods for cancelling timelocks related to
836  * account recovery or the disablement of account recovery, as well as functions
837  * for managing, pausing, and querying for the status of the various roles.
838  */
839 contract DharmaAccountRecoveryManagerV2 is
840   DharmaAccountRecoveryManagerInterface,
841   DharmaAccountRecoveryManagerV2Interface,
842   TimelockerModifiersInterface,
843   TwoStepOwnable,
844   TimelockerV2 {
845   using SafeMath for uint256;
846 
847   // Maintain a role status mapping with assigned accounts and paused states.
848   mapping(uint256 => RoleStatus) private _roles;
849 
850   // Maintain mapping of smart wallets that have opted out of account recovery.
851   mapping(address => bool) private _accountRecoveryDisabled;
852 
853   /**
854    * @notice In the constructor, set the initial owner to the transaction
855    * submitter and initial minimum timelock interval and default timelock
856    * expiration values.
857    */
858   constructor() public {
859     // Set initial minimum timelock interval values.
860     _setInitialTimelockInterval(this.modifyTimelockInterval.selector, 2 weeks);
861     _setInitialTimelockInterval(
862       this.modifyTimelockExpiration.selector, 2 weeks
863     );
864     _setInitialTimelockInterval(this.recover.selector, 3 days);
865     _setInitialTimelockInterval(this.disableAccountRecovery.selector, 3 days);
866 
867     // Set initial default timelock expiration values.
868     _setInitialTimelockExpiration(this.modifyTimelockInterval.selector, 7 days);
869     _setInitialTimelockExpiration(
870       this.modifyTimelockExpiration.selector, 7 days
871     );
872     _setInitialTimelockExpiration(this.recover.selector, 3 days);
873     _setInitialTimelockExpiration(this.disableAccountRecovery.selector, 3 days);
874   }
875 
876   /**
877    * @notice Initiates a timelocked account recovery process for a smart wallet
878    * user signing key. Only the owner or the designated operator may call this
879    * function. Once the timelock period is complete (and before it has expired)
880    * the owner or the designated recoverer may call `recover` to complete the
881    * process and reset the user's signing key.
882    * @param smartWallet The smart wallet address.
883    * @param userSigningKey The new user signing key.
884    * @param extraTime Additional time in seconds to add to the timelock.
885    */
886   function initiateAccountRecovery(
887     address smartWallet, address userSigningKey, uint256 extraTime
888   ) external onlyOwnerOr(Role.OPERATOR) {
889     require(smartWallet != address(0), "No smart wallet address provided.");
890     require(userSigningKey != address(0), "No new user signing key provided.");
891 
892     // Set the timelock and emit a `TimelockInitiated` event.
893     _setTimelock(
894       this.recover.selector, abi.encode(smartWallet, userSigningKey), extraTime
895     );
896   }
897 
898   /**
899    * @notice Timelocked function to set a new user signing key on a smart
900    * wallet. Only the owner or the designated recoverer may call this function.
901    * @param smartWallet Address of the smart wallet to recover a key on.
902    * @param newUserSigningKey Address of the new signing key for the user.
903    */
904   function recover(
905     address smartWallet, address newUserSigningKey
906   ) external onlyOwnerOr(Role.RECOVERER) {
907     require(smartWallet != address(0), "No smart wallet address provided.");
908     require(
909       newUserSigningKey != address(0),
910       "No new user signing key provided."
911     );
912 
913     // Ensure that the wallet in question has not opted out of account recovery.
914     require(
915       !_accountRecoveryDisabled[smartWallet],
916       "This wallet has elected to opt out of account recovery functionality."
917     );
918 
919     // Ensure that the timelock has been set and is completed.
920     _enforceTimelock(abi.encode(smartWallet, newUserSigningKey));
921 
922     // Declare the proper interface for the smart wallet in question.
923     DharmaSmartWalletRecoveryInterface walletInterface;
924 
925     // Attempt to get current signing key - a failure should not block recovery.
926     address oldUserSigningKey;
927     (bool ok, bytes memory data) = smartWallet.call.gas(gasleft() / 2)(
928       abi.encodeWithSelector(walletInterface.getUserSigningKey.selector)
929     );
930     if (ok && data.length == 32) {
931       oldUserSigningKey = abi.decode(data, (address));
932     }
933 
934     // Call the specified smart wallet and supply the new user signing key.
935     DharmaSmartWalletRecoveryInterface(smartWallet).recover(newUserSigningKey);
936 
937     // Emit an event to signify that the wallet in question was recovered.
938     emit Recovery(smartWallet, oldUserSigningKey, newUserSigningKey);
939   }
940 
941   /**
942    * @notice Initiates a timelocked account recovery disablement process for a
943    * smart wallet. Only the owner or the designated operator may call this
944    * function. Once the timelock period is complete (and before it has expired)
945    * the owner or the designated disabler may call `disableAccountRecovery` to
946    * complete the process and opt a smart wallet out of account recovery. Once
947    * account recovery has been disabled, it cannot be reenabled - the process is
948    * irreversible.
949    * @param smartWallet The smart wallet address.
950    * @param extraTime Additional time in seconds to add to the timelock.
951    */
952   function initiateAccountRecoveryDisablement(
953     address smartWallet, uint256 extraTime
954   ) external onlyOwnerOr(Role.OPERATOR) {
955     require(smartWallet != address(0), "No smart wallet address provided.");
956 
957     // Set the timelock and emit a `TimelockInitiated` event.
958     _setTimelock(
959       this.disableAccountRecovery.selector, abi.encode(smartWallet), extraTime
960     );
961   }
962 
963   /**
964    * @notice Timelocked function to opt a given wallet out of account recovery.
965    * This action cannot be undone - any future account recovery would require an
966    * upgrade to the smart wallet implementation itself and is not likely to be
967    * supported. Only the owner or the designated disabler may call this
968    * function.
969    * @param smartWallet Address of the smart wallet to disable account recovery
970    * for.
971    */
972   function disableAccountRecovery(
973     address smartWallet
974   ) external onlyOwnerOr(Role.DISABLER) {
975     require(smartWallet != address(0), "No smart wallet address provided.");
976 
977     // Ensure that the timelock has been set and is completed.
978     _enforceTimelock(abi.encode(smartWallet));
979 
980     // Register the specified wallet as having opted out of account recovery.
981     _accountRecoveryDisabled[smartWallet] = true;
982 
983     // Emit an event to signify the wallet in question is no longer recoverable.
984     emit RecoveryDisabled(smartWallet);
985   }
986 
987   /**
988    * @notice Cancel a pending timelock for setting a new user signing key on a
989    * smart wallet. Only the owner or the designated canceller may call this
990    * function.
991    * @param smartWallet Address of the smart wallet to cancel the recovery on.
992    * @param userSigningKey Address of the signing key supplied for the user.
993    */
994   function cancelAccountRecovery(
995     address smartWallet, address userSigningKey
996   ) external onlyOwnerOr(Role.CANCELLER) {
997     require(smartWallet != address(0), "No smart wallet address provided.");
998     require(userSigningKey != address(0), "No user signing key provided.");
999 
1000     // Expire the timelock for the account recovery in question if one exists.
1001     _expireTimelock(
1002       this.recover.selector, abi.encode(smartWallet, userSigningKey)
1003     );
1004 
1005     // Emit an event to signify that the recovery was cancelled.
1006     emit RecoveryCancelled(smartWallet, userSigningKey);
1007   }
1008 
1009   /**
1010    * @notice Cancel a pending timelock for disabling account recovery for a
1011    * smart wallet. Only the owner or the designated canceller may call this
1012    * function.
1013    * @param smartWallet Address of the smart wallet to cancel the recovery
1014    * disablement on.
1015    */
1016   function cancelAccountRecoveryDisablement(
1017     address smartWallet
1018   ) external onlyOwnerOr(Role.CANCELLER) {
1019     require(smartWallet != address(0), "No smart wallet address provided.");
1020 
1021     // Expire account recovery disablement timelock in question if one exists.
1022     _expireTimelock(
1023       this.disableAccountRecovery.selector, abi.encode(smartWallet)
1024     );
1025 
1026     // Emit an event to signify that the recovery disablement was cancelled.
1027     emit RecoveryDisablementCancelled(smartWallet);
1028   }
1029 
1030   /**
1031    * @notice Pause a currently unpaused role and emit a `RolePaused` event. Only
1032    * the owner or the designated pauser may call this function. Also, bear in
1033    * mind that only the owner may unpause a role once paused.
1034    * @param role The role to pause. Permitted roles are operator (0),
1035    * recoverer (1), canceller (2), disabler (3), and pauser (4).
1036    */
1037   function pause(Role role) external onlyOwnerOr(Role.PAUSER) {
1038     RoleStatus storage storedRoleStatus = _roles[uint256(role)];
1039     require(!storedRoleStatus.paused, "Role in question is already paused.");
1040     storedRoleStatus.paused = true;
1041     emit RolePaused(role);
1042   }
1043 
1044   /**
1045    * @notice Unause a currently paused role and emit a `RoleUnpaused` event.
1046    * Only the owner may call this function.
1047    * @param role The role to pause. Permitted roles are operator (0),
1048    * recoverer (1), canceller (2), disabler (3), and pauser (4).
1049    */
1050   function unpause(Role role) external onlyOwner {
1051     RoleStatus storage storedRoleStatus = _roles[uint256(role)];
1052     require(storedRoleStatus.paused, "Role in question is already unpaused.");
1053     storedRoleStatus.paused = false;
1054     emit RoleUnpaused(role);
1055   }
1056 
1057   /**
1058    * @notice Sets the timelock for a new timelock interval for a given function
1059    * selector. Only the owner may call this function.
1060    * @param functionSelector The selector of the function to set the timelock
1061    * interval for.
1062    * @param newTimelockInterval The new timelock interval to set for the given
1063    * function selector.
1064    * @param extraTime Additional time in seconds to add to the timelock.
1065    */
1066   function initiateModifyTimelockInterval(
1067     bytes4 functionSelector, uint256 newTimelockInterval, uint256 extraTime
1068   ) external onlyOwner {
1069     // Ensure that a function selector is specified (no 0x00000000 selector).
1070     require(
1071       functionSelector != bytes4(0),
1072       "Function selector cannot be empty."
1073     );
1074 
1075     // Ensure a timelock interval over eight weeks is not set on this function.
1076     if (functionSelector == this.modifyTimelockInterval.selector) {
1077       require(
1078         newTimelockInterval <= 8 weeks,
1079         "Timelock interval of modifyTimelockInterval cannot exceed eight weeks."
1080       );
1081     }
1082 
1083     // Set the timelock and emit a `TimelockInitiated` event.
1084     _setTimelock(
1085       this.modifyTimelockInterval.selector,
1086       abi.encode(functionSelector, newTimelockInterval),
1087       extraTime
1088     );
1089   }
1090 
1091   /**
1092    * @notice Sets a new timelock interval for a given function selector. The
1093    * default for this function may also be modified, but has a maximum allowable
1094    * value of eight weeks. Only the owner may call this function.
1095    * @param functionSelector The selector of the function to set the timelock
1096    * interval for.
1097    * @param newTimelockInterval The new timelock interval to set for the given
1098    * function selector.
1099    */
1100   function modifyTimelockInterval(
1101     bytes4 functionSelector, uint256 newTimelockInterval
1102   ) external onlyOwner {
1103     // Ensure that a function selector is specified (no 0x00000000 selector).
1104     require(
1105       functionSelector != bytes4(0),
1106       "Function selector cannot be empty."
1107     );
1108 
1109     // Continue via logic in the inherited `_modifyTimelockInterval` function.
1110     _modifyTimelockInterval(functionSelector, newTimelockInterval);
1111   }
1112 
1113   /**
1114    * @notice Sets a new timelock expiration for a given function selector. The
1115    * default Only the owner may call this function. New expiration durations may
1116    * not exceed one month.
1117    * @param functionSelector The selector of the function to set the timelock
1118    * expiration for.
1119    * @param newTimelockExpiration The new timelock expiration to set for the
1120    * given function selector.
1121    * @param extraTime Additional time in seconds to add to the timelock.
1122    */
1123   function initiateModifyTimelockExpiration(
1124     bytes4 functionSelector, uint256 newTimelockExpiration, uint256 extraTime
1125   ) external onlyOwner {
1126     // Ensure that a function selector is specified (no 0x00000000 selector).
1127     require(
1128       functionSelector != bytes4(0),
1129       "Function selector cannot be empty."
1130     );
1131 
1132     // Ensure that the supplied default expiration does not exceed 1 month.
1133     require(
1134       newTimelockExpiration <= 30 days,
1135       "New timelock expiration cannot exceed one month."
1136     );
1137 
1138     // Ensure a timelock expiration under one hour is not set on this function.
1139     if (functionSelector == this.modifyTimelockExpiration.selector) {
1140       require(
1141         newTimelockExpiration >= 60 minutes,
1142         "Expiration of modifyTimelockExpiration must be at least an hour long."
1143       );
1144     }
1145 
1146     // Set the timelock and emit a `TimelockInitiated` event.
1147     _setTimelock(
1148       this.modifyTimelockExpiration.selector,
1149       abi.encode(functionSelector, newTimelockExpiration),
1150       extraTime
1151     );
1152   }
1153 
1154   /**
1155    * @notice Sets a new timelock expiration for a given function selector. The
1156    * default for this function may also be modified, but has a minimum allowable
1157    * value of one hour. Only the owner may call this function.
1158    * @param functionSelector The selector of the function to set the timelock
1159    * expiration for.
1160    * @param newTimelockExpiration The new timelock expiration to set for the
1161    * given function selector.
1162    */
1163   function modifyTimelockExpiration(
1164     bytes4 functionSelector, uint256 newTimelockExpiration
1165   ) external onlyOwner {
1166     // Ensure that a function selector is specified (no 0x00000000 selector).
1167     require(
1168       functionSelector != bytes4(0),
1169       "Function selector cannot be empty."
1170     );
1171 
1172     // Continue via logic in the inherited `_modifyTimelockExpiration` function.
1173     _modifyTimelockExpiration(
1174       functionSelector, newTimelockExpiration
1175     );
1176   }
1177 
1178   /**
1179    * @notice Set a new account on a given role and emit a `RoleModified` event
1180    * if the role holder has changed. Only the owner may call this function.
1181    * @param role The role that the account will be set for. Permitted roles are
1182    * operator (0), recoverer (1), canceller (2), disabler (3), and pauser (4).
1183    * @param account The account to set as the designated role bearer.
1184    */
1185   function setRole(Role role, address account) external onlyOwner {
1186     require(account != address(0), "Must supply an account.");
1187     _setRole(role, account);
1188   }
1189 
1190   /**
1191    * @notice Remove any current role bearer for a given role and emit a
1192    * `RoleModified` event if a role holder was previously set. Only the owner
1193    * may call this function.
1194    * @param role The role that the account will be removed from. Permitted roles
1195    * are operator (0), recoverer (1), canceller (2), disabler (3), and
1196    * pauser (4).
1197    */
1198   function removeRole(Role role) external onlyOwner {
1199     _setRole(role, address(0));
1200   }
1201 
1202   /**
1203    * @notice External view function to check whether a given smart wallet has
1204    * disabled account recovery by opting out.
1205    * @param smartWallet Address of the smart wallet to check.
1206    * @return A boolean indicating if account recovery has been disabled for the
1207    * wallet in question.
1208    */
1209   function accountRecoveryDisabled(
1210     address smartWallet
1211   ) external view returns (bool hasDisabledAccountRecovery) {
1212     // Determine if the wallet in question has opted out of account recovery.
1213     hasDisabledAccountRecovery = _accountRecoveryDisabled[smartWallet];
1214   }
1215 
1216   /**
1217    * @notice External view function to check whether or not the functionality
1218    * associated with a given role is currently paused or not. The owner or the
1219    * pauser may pause any given role (including the pauser itself), but only the
1220    * owner may unpause functionality. Additionally, the owner may call paused
1221    * functions directly.
1222    * @param role The role to check the pause status on. Permitted roles are
1223    * operator (0), recoverer (1), canceller (2), disabler (3), and pauser (4).
1224    * @return A boolean to indicate if the functionality associated with the role
1225    * in question is currently paused.
1226    */
1227   function isPaused(Role role) external view returns (bool paused) {
1228     paused = _isPaused(role);
1229   }
1230 
1231   /**
1232    * @notice External view function to check whether the caller is the current
1233    * role holder.
1234    * @param role The role to check for. Permitted roles are operator (0),
1235    * recoverer (1), canceller (2), disabler (3), and pauser (4).
1236    * @return A boolean indicating if the caller has the specified role.
1237    */
1238   function isRole(Role role) external view returns (bool hasRole) {
1239     hasRole = _isRole(role);
1240   }
1241 
1242   /**
1243    * @notice External view function to check the account currently holding the
1244    * operator role. The operator can initiate timelocks for account recovery and
1245    * account recovery disablement.
1246    * @return The address of the current operator, or the null address if none is
1247    * set.
1248    */
1249   function getOperator() external view returns (address operator) {
1250     operator = _roles[uint256(Role.OPERATOR)].account;
1251   }
1252 
1253   /**
1254    * @notice External view function to check the account currently holding the
1255    * recoverer role. The recoverer can trigger smart wallet account recovery in
1256    * the event that a timelock has been initiated and is complete and not yet
1257    * expired.
1258    * @return The address of the current recoverer, or the null address if none
1259    * is set.
1260    */
1261   function getRecoverer() external view returns (address recoverer) {
1262     recoverer = _roles[uint256(Role.RECOVERER)].account;
1263   }
1264 
1265   /**
1266    * @notice External view function to check the account currently holding the
1267    * canceller role. The canceller can expire a timelock related to account
1268    * recovery or account recovery disablement prior to its execution.
1269    * @return The address of the current canceller, or the null address if none
1270    * is set.
1271    */
1272   function getCanceller() external view returns (address canceller) {
1273     canceller = _roles[uint256(Role.CANCELLER)].account;
1274   }
1275 
1276   /**
1277    * @notice External view function to check the account currently holding the
1278    * disabler role. The disabler can trigger permanent smart wallet account
1279    * recovery disablement in the event that a timelock has been initiated and is
1280    * complete and not yet expired.
1281    * @return The address of the current disabler, or the null address if none is
1282    * set.
1283    */
1284   function getDisabler() external view returns (address disabler) {
1285     disabler = _roles[uint256(Role.DISABLER)].account;
1286   }
1287 
1288   /**
1289    * @notice External view function to check the account currently holding the
1290    * pauser role. The pauser can pause any role from taking its standard action,
1291    * though the owner will still be able to call the associated function in the
1292    * interim and is the only entity able to unpause the given role once paused.
1293    * @return The address of the current pauser, or the null address if none is
1294    * set.
1295    */
1296   function getPauser() external view returns (address pauser) {
1297     pauser = _roles[uint256(Role.PAUSER)].account;
1298   }
1299 
1300   /**
1301    * @notice Internal function to set a new account on a given role and emit a
1302    * `RoleModified` event if the role holder has changed.
1303    * @param role The role that the account will be set for. Permitted roles are
1304    * operator (0), recoverer (1), canceller (2), disabler (3), and pauser (4).
1305    * @param account The account to set as the designated role bearer.
1306    */
1307   function _setRole(Role role, address account) internal {
1308     RoleStatus storage storedRoleStatus = _roles[uint256(role)];
1309 
1310     if (account != storedRoleStatus.account) {
1311       storedRoleStatus.account = account;
1312       emit RoleModified(role, account);
1313     }
1314   }
1315 
1316   /**
1317    * @notice Internal view function to check whether the caller is the current
1318    * role holder.
1319    * @param role The role to check for. Permitted roles are operator (0),
1320    * recoverer (1), canceller (2), disabler (3), and pauser (4).
1321    * @return A boolean indicating if the caller has the specified role.
1322    */
1323   function _isRole(Role role) internal view returns (bool hasRole) {
1324     hasRole = msg.sender == _roles[uint256(role)].account;
1325   }
1326 
1327   /**
1328    * @notice Internal view function to check whether the given role is paused or
1329    * not.
1330    * @param role The role to check for. Permitted roles are operator (0),
1331    * recoverer (1), canceller (2), disabler (3), and pauser (4).
1332    * @return A boolean indicating if the specified role is paused or not.
1333    */
1334   function _isPaused(Role role) internal view returns (bool paused) {
1335     paused = _roles[uint256(role)].paused;
1336   }
1337 
1338   /**
1339    * @notice Modifier that throws if called by any account other than the owner
1340    * or the supplied role, or if the caller is not the owner and the role in
1341    * question is paused.
1342    * @param role The role to require unless the caller is the owner. Permitted
1343    * roles are operator (0), recoverer (1), canceller (2), disabler (3), and
1344    * pauser (4).
1345    */
1346   modifier onlyOwnerOr(Role role) {
1347     if (!isOwner()) {
1348       require(_isRole(role), "Caller does not have a required role.");
1349       require(!_isPaused(role), "Role in question is currently paused.");
1350     }
1351     _;
1352   }
1353 }