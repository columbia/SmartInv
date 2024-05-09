1 pragma solidity ^0.4.24;
2 
3 interface ConflictResolutionInterface {
4     function minHouseStake(uint activeGames) external pure returns(uint);
5 
6     function maxBalance() external pure returns(int);
7 
8     function conflictEndFine() external pure returns(int);
9 
10     function isValidBet(uint8 _gameType, uint _betNum, uint _betValue) external pure returns(bool);
11 
12     function endGameConflict(
13         uint8 _gameType,
14         uint _betNum,
15         uint _betValue,
16         int _balance,
17         uint _stake,
18         bytes32 _serverSeed,
19         bytes32 _userSeed
20     )
21         external
22         view
23         returns(int);
24 
25     function serverForceGameEnd(
26         uint8 gameType,
27         uint _betNum,
28         uint _betValue,
29         int _balance,
30         uint _stake,
31         uint _endInitiatedTime
32     )
33         external
34         view
35         returns(int);
36 
37     function userForceGameEnd(
38         uint8 _gameType,
39         uint _betNum,
40         uint _betValue,
41         int _balance,
42         uint _stake,
43         uint _endInitiatedTime
44     )
45         external
46         view
47         returns(int);
48 }
49 
50 library MathUtil {
51     /**
52      * @dev Returns the absolute value of _val.
53      * @param _val value
54      * @return The absolute value of _val.
55      */
56     function abs(int _val) internal pure returns(uint) {
57         if (_val < 0) {
58             return uint(-_val);
59         } else {
60             return uint(_val);
61         }
62     }
63 
64     /**
65      * @dev Calculate maximum.
66      */
67     function max(uint _val1, uint _val2) internal pure returns(uint) {
68         return _val1 >= _val2 ? _val1 : _val2;
69     }
70 
71     /**
72      * @dev Calculate minimum.
73      */
74     function min(uint _val1, uint _val2) internal pure returns(uint) {
75         return _val1 <= _val2 ? _val1 : _val2;
76     }
77 }
78 
79 contract Ownable {
80     address public owner;
81     address public pendingOwner;
82 
83     event LogOwnerShipTransferred(address indexed previousOwner, address indexed newOwner);
84     event LogOwnerShipTransferInitiated(address indexed previousOwner, address indexed newOwner);
85 
86     /**
87      * @dev Modifier, which throws if called by other account than owner.
88      */
89     modifier onlyOwner {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     /**
95      * @dev Modifier throws if called by any account other than the pendingOwner.
96      */
97     modifier onlyPendingOwner() {
98         require(msg.sender == pendingOwner);
99         _;
100     }
101 
102     /**
103      * @dev Set contract creator as initial owner
104      */
105     constructor() public {
106         owner = msg.sender;
107         pendingOwner = address(0);
108     }
109 
110     /**
111      * @dev Allows the current owner to set the pendingOwner address.
112      * @param _newOwner The address to transfer ownership to.
113      */
114     function transferOwnership(address _newOwner) public onlyOwner {
115         pendingOwner = _newOwner;
116         emit LogOwnerShipTransferInitiated(owner, _newOwner);
117     }
118 
119     /**
120      * @dev PendingOwner can accept ownership.
121      */
122     function claimOwnership() public onlyPendingOwner {
123         owner = pendingOwner;
124         pendingOwner = address(0);
125         emit LogOwnerShipTransferred(owner, pendingOwner);
126     }
127 }
128 
129 contract Activatable is Ownable {
130     bool public activated = false;
131 
132     /// @dev Event is fired if activated.
133     event LogActive();
134 
135     /// @dev Modifier, which only allows function execution if activated.
136     modifier onlyActivated() {
137         require(activated);
138         _;
139     }
140 
141     /// @dev Modifier, which only allows function execution if not activated.
142     modifier onlyNotActivated() {
143         require(!activated);
144         _;
145     }
146 
147     /// @dev activate contract, can be only called once by the contract owner.
148     function activate() public onlyOwner onlyNotActivated {
149         activated = true;
150         emit LogActive();
151     }
152 }
153 
154 contract ConflictResolutionManager is Ownable {
155     /// @dev Conflict resolution contract.
156     ConflictResolutionInterface public conflictRes;
157 
158     /// @dev New Conflict resolution contract.
159     address public newConflictRes = 0;
160 
161     /// @dev Time update of new conflict resolution contract was initiated.
162     uint public updateTime = 0;
163 
164     /// @dev Min time before new conflict res contract can be activated after initiating update.
165     uint public constant MIN_TIMEOUT = 3 days;
166 
167     /// @dev Min time before new conflict res contract can be activated after initiating update.
168     uint public constant MAX_TIMEOUT = 6 days;
169 
170     /// @dev Update of conflict resolution contract was initiated.
171     event LogUpdatingConflictResolution(address newConflictResolutionAddress);
172 
173     /// @dev New conflict resolution contract is active.
174     event LogUpdatedConflictResolution(address newConflictResolutionAddress);
175 
176     /**
177      * @dev Constructor
178      * @param _conflictResAddress conflict resolution contract address.
179      */
180     constructor(address _conflictResAddress) public {
181         conflictRes = ConflictResolutionInterface(_conflictResAddress);
182     }
183 
184     /**
185      * @dev Initiate conflict resolution contract update.
186      * @param _newConflictResAddress New conflict resolution contract address.
187      */
188     function updateConflictResolution(address _newConflictResAddress) public onlyOwner {
189         newConflictRes = _newConflictResAddress;
190         updateTime = block.timestamp;
191 
192         emit LogUpdatingConflictResolution(_newConflictResAddress);
193     }
194 
195     /**
196      * @dev Active new conflict resolution contract.
197      */
198     function activateConflictResolution() public onlyOwner {
199         require(newConflictRes != 0);
200         require(updateTime != 0);
201         require(updateTime + MIN_TIMEOUT <= block.timestamp && block.timestamp <= updateTime + MAX_TIMEOUT);
202 
203         conflictRes = ConflictResolutionInterface(newConflictRes);
204         newConflictRes = 0;
205         updateTime = 0;
206 
207         emit LogUpdatedConflictResolution(newConflictRes);
208     }
209 }
210 
211 contract Pausable is Activatable {
212     using SafeMath for uint;
213 
214     /// @dev Is contract paused. Initial it is paused.
215     bool public paused = true;
216 
217     /// @dev Time pause was called
218     uint public timePaused = block.timestamp;
219 
220     /// @dev Modifier, which only allows function execution if not paused.
221     modifier onlyNotPaused() {
222         require(!paused, "paused");
223         _;
224     }
225 
226     /// @dev Modifier, which only allows function execution if paused.
227     modifier onlyPaused() {
228         require(paused);
229         _;
230     }
231 
232     /// @dev Modifier, which only allows function execution if paused longer than timeSpan.
233     modifier onlyPausedSince(uint timeSpan) {
234         require(paused && (timePaused.add(timeSpan) <= block.timestamp));
235         _;
236     }
237 
238     /// @dev Event is fired if paused.
239     event LogPause();
240 
241     /// @dev Event is fired if pause is ended.
242     event LogUnpause();
243 
244     /**
245      * @dev Pause contract. No new game sessions can be created.
246      */
247     function pause() public onlyOwner onlyNotPaused {
248         paused = true;
249         timePaused = block.timestamp;
250         emit LogPause();
251     }
252 
253     /**
254      * @dev Unpause contract. Initial contract is paused and can only be unpaused after activating it.
255      */
256     function unpause() public onlyOwner onlyPaused onlyActivated {
257         paused = false;
258         timePaused = 0;
259         emit LogUnpause();
260     }
261 }
262 
263 contract Destroyable is Pausable {
264     /// @dev After pausing the contract for 20 days owner can selfdestruct it.
265     uint public constant TIMEOUT_DESTROY = 20 days;
266 
267     /**
268      * @dev Destroy contract and transfer ether to owner.
269      */
270     function destroy() public onlyOwner onlyPausedSince(TIMEOUT_DESTROY) {
271         selfdestruct(owner);
272     }
273 }
274 
275 contract GameChannelBase is Destroyable, ConflictResolutionManager {
276     using SafeCast for int;
277     using SafeCast for uint;
278     using SafeMath for int;
279     using SafeMath for uint;
280 
281 
282     /// @dev Different game session states.
283     enum GameStatus {
284         ENDED, ///< @dev Game session is ended.
285         ACTIVE, ///< @dev Game session is active.
286         USER_INITIATED_END, ///< @dev User initiated non regular end.
287         SERVER_INITIATED_END ///< @dev Server initiated non regular end.
288     }
289 
290     /// @dev Reason game session ended.
291     enum ReasonEnded {
292         REGULAR_ENDED, ///< @dev Game session is regularly ended.
293         SERVER_FORCED_END, ///< @dev User did not respond. Server forced end.
294         USER_FORCED_END, ///< @dev Server did not respond. User forced end.
295         CONFLICT_ENDED ///< @dev Server or user raised conflict ans pushed game state, opponent pushed same game state.
296     }
297 
298     struct Game {
299         /// @dev Game session status.
300         GameStatus status;
301 
302         /// @dev User's stake.
303         uint128 stake;
304 
305         /// @dev Last game round info if not regularly ended.
306         /// If game session is ended normally this data is not used.
307         uint8 gameType;
308         uint32 roundId;
309         uint betNum;
310         uint betValue;
311         int balance;
312         bytes32 userSeed;
313         bytes32 serverSeed;
314         uint endInitiatedTime;
315     }
316 
317     /// @dev Minimal time span between profit transfer.
318     uint public constant MIN_TRANSFER_TIMESPAN = 1 days;
319 
320     /// @dev Maximal time span between profit transfer.
321     uint public constant MAX_TRANSFER_TIMSPAN = 6 * 30 days;
322 
323     bytes32 public constant TYPE_HASH = keccak256(abi.encodePacked(
324         "uint32 Round Id",
325         "uint8 Game Type",
326         "uint16 Number",
327         "uint Value (Wei)",
328         "int Current Balance (Wei)",
329         "bytes32 Server Hash",
330         "bytes32 Player Hash",
331         "uint Game Id",
332         "address Contract Address"
333      ));
334 
335     /// @dev Current active game sessions.
336     uint public activeGames = 0;
337 
338     /// @dev Game session id counter. Points to next free game session slot. So gameIdCntr -1 is the
339     // number of game sessions created.
340     uint public gameIdCntr = 1;
341 
342     /// @dev Only this address can accept and end games.
343     address public serverAddress;
344 
345     /// @dev Address to transfer profit to.
346     address public houseAddress;
347 
348     /// @dev Current house stake.
349     uint public houseStake = 0;
350 
351     /// @dev House profit since last profit transfer.
352     int public houseProfit = 0;
353 
354     /// @dev Min value user needs to deposit for creating game session.
355     uint128 public minStake;
356 
357     /// @dev Max value user can deposit for creating game session.
358     uint128 public maxStake;
359 
360     /// @dev Timeout until next profit transfer is allowed.
361     uint public profitTransferTimeSpan = 14 days;
362 
363     /// @dev Last time profit transferred to house.
364     uint public lastProfitTransferTimestamp;
365 
366     /// @dev Maps gameId to game struct.
367     mapping (uint => Game) public gameIdGame;
368 
369     /// @dev Maps user address to current user game id.
370     mapping (address => uint) public userGameId;
371 
372     /// @dev Maps user address to pending returns.
373     mapping (address => uint) public pendingReturns;
374 
375     /// @dev Modifier, which only allows to execute if house stake is high enough.
376     modifier onlyValidHouseStake(uint _activeGames) {
377         uint minHouseStake = conflictRes.minHouseStake(_activeGames);
378         require(houseStake >= minHouseStake, "inv houseStake");
379         _;
380     }
381 
382     /// @dev Modifier to check if value send fulfills user stake requirements.
383     modifier onlyValidValue() {
384         require(minStake <= msg.value && msg.value <= maxStake, "inv stake");
385         _;
386     }
387 
388     /// @dev Modifier, which only allows server to call function.
389     modifier onlyServer() {
390         require(msg.sender == serverAddress);
391         _;
392     }
393 
394     /// @dev Modifier, which only allows to set valid transfer timeouts.
395     modifier onlyValidTransferTimeSpan(uint transferTimeout) {
396         require(transferTimeout >= MIN_TRANSFER_TIMESPAN
397                 && transferTimeout <= MAX_TRANSFER_TIMSPAN);
398         _;
399     }
400 
401     /// @dev This event is fired when user creates game session.
402     event LogGameCreated(address indexed user, uint indexed gameId, uint128 stake, bytes32 indexed serverEndHash, bytes32 userEndHash);
403 
404     /// @dev This event is fired when user requests conflict end.
405     event LogUserRequestedEnd(address indexed user, uint indexed gameId);
406 
407     /// @dev This event is fired when server requests conflict end.
408     event LogServerRequestedEnd(address indexed user, uint indexed gameId);
409 
410     /// @dev This event is fired when game session is ended.
411     event LogGameEnded(address indexed user, uint indexed gameId, uint32 roundId, int balance, ReasonEnded reason);
412 
413     /// @dev this event is fired when owner modifies user's stake limits.
414     event LogStakeLimitsModified(uint minStake, uint maxStake);
415 
416     /**
417      * @dev Contract constructor.
418      * @param _serverAddress Server address.
419      * @param _minStake Min value user needs to deposit to create game session.
420      * @param _maxStake Max value user can deposit to create game session.
421      * @param _conflictResAddress Conflict resolution contract address.
422      * @param _houseAddress House address to move profit to.
423      * @param _chainId Chain id for signature domain.
424      */
425     constructor(
426         address _serverAddress,
427         uint128 _minStake,
428         uint128 _maxStake,
429         address _conflictResAddress,
430         address _houseAddress,
431         uint _chainId
432     )
433         public
434         ConflictResolutionManager(_conflictResAddress)
435     {
436         require(_minStake > 0 && _minStake <= _maxStake);
437 
438         serverAddress = _serverAddress;
439         houseAddress = _houseAddress;
440         lastProfitTransferTimestamp = block.timestamp;
441         minStake = _minStake;
442         maxStake = _maxStake;
443     }
444 
445     /**
446      * @dev Set gameIdCntr. Can be only set before activating contract.
447      */
448     function setGameIdCntr(uint _gameIdCntr) public onlyOwner onlyNotActivated {
449         require(gameIdCntr > 0);
450         gameIdCntr = _gameIdCntr;
451     }
452 
453     /**
454      * @notice Withdraw pending returns.
455      */
456     function withdraw() public {
457         uint toTransfer = pendingReturns[msg.sender];
458         require(toTransfer > 0);
459 
460         pendingReturns[msg.sender] = 0;
461         msg.sender.transfer(toTransfer);
462     }
463 
464     /**
465      * @notice Transfer house profit to houseAddress.
466      */
467     function transferProfitToHouse() public {
468         require(lastProfitTransferTimestamp.add(profitTransferTimeSpan) <= block.timestamp);
469 
470         // update last transfer timestamp
471         lastProfitTransferTimestamp = block.timestamp;
472 
473         if (houseProfit <= 0) {
474             // no profit to transfer
475             return;
476         }
477 
478         uint toTransfer = houseProfit.castToUint();
479 
480         houseProfit = 0;
481         houseStake = houseStake.sub(toTransfer);
482 
483         houseAddress.transfer(toTransfer);
484     }
485 
486     /**
487      * @dev Set profit transfer time span.
488      */
489     function setProfitTransferTimeSpan(uint _profitTransferTimeSpan)
490         public
491         onlyOwner
492         onlyValidTransferTimeSpan(_profitTransferTimeSpan)
493     {
494         profitTransferTimeSpan = _profitTransferTimeSpan;
495     }
496 
497     /**
498      * @dev Increase house stake by msg.value
499      */
500     function addHouseStake() public payable onlyOwner {
501         houseStake = houseStake.add(msg.value);
502     }
503 
504     /**
505      * @dev Withdraw house stake.
506      */
507     function withdrawHouseStake(uint value) public onlyOwner {
508         uint minHouseStake = conflictRes.minHouseStake(activeGames);
509 
510         require(value <= houseStake && houseStake.sub(value) >= minHouseStake);
511         require(houseProfit <= 0 || houseProfit.castToUint() <= houseStake.sub(value));
512 
513         houseStake = houseStake.sub(value);
514         owner.transfer(value);
515     }
516 
517     /**
518      * @dev Withdraw house stake and profit.
519      */
520     function withdrawAll() public onlyOwner onlyPausedSince(3 days) {
521         houseProfit = 0;
522         uint toTransfer = houseStake;
523         houseStake = 0;
524         owner.transfer(toTransfer);
525     }
526 
527     /**
528      * @dev Set new house address.
529      * @param _houseAddress New house address.
530      */
531     function setHouseAddress(address _houseAddress) public onlyOwner {
532         houseAddress = _houseAddress;
533     }
534 
535     /**
536      * @dev Set stake min and max value.
537      * @param _minStake Min stake.
538      * @param _maxStake Max stake.
539      */
540     function setStakeRequirements(uint128 _minStake, uint128 _maxStake) public onlyOwner {
541         require(_minStake > 0 && _minStake <= _maxStake);
542         minStake = _minStake;
543         maxStake = _maxStake;
544         emit LogStakeLimitsModified(minStake, maxStake);
545     }
546 
547     /**
548      * @dev Close game session.
549      * @param _game Game session data.
550      * @param _gameId Id of game session.
551      * @param _userAddress User's address of game session.
552      * @param _reason Reason for closing game session.
553      * @param _balance Game session balance.
554      */
555     function closeGame(
556         Game storage _game,
557         uint _gameId,
558         uint32 _roundId,
559         address _userAddress,
560         ReasonEnded _reason,
561         int _balance
562     )
563         internal
564     {
565         _game.status = GameStatus.ENDED;
566 
567         activeGames = activeGames.sub(1);
568 
569         payOut(_userAddress, _game.stake, _balance);
570 
571         emit LogGameEnded(_userAddress, _gameId, _roundId, _balance, _reason);
572     }
573 
574     /**
575      * @dev End game by paying out user and server.
576      * @param _userAddress User's address.
577      * @param _stake User's stake.
578      * @param _balance User's balance.
579      */
580     function payOut(address _userAddress, uint128 _stake, int _balance) internal {
581         int stakeInt = _stake;
582         int houseStakeInt = houseStake.castToInt();
583 
584         assert(_balance <= conflictRes.maxBalance());
585         assert((stakeInt.add(_balance)) >= 0);
586 
587         if (_balance > 0 && houseStakeInt < _balance) {
588             // Should never happen!
589             // House is bankrupt.
590             // Payout left money.
591             _balance = houseStakeInt;
592         }
593 
594         houseProfit = houseProfit.sub(_balance);
595 
596         int newHouseStake = houseStakeInt.sub(_balance);
597         houseStake = newHouseStake.castToUint();
598 
599         uint valueUser = stakeInt.add(_balance).castToUint();
600         pendingReturns[_userAddress] += valueUser;
601         if (pendingReturns[_userAddress] > 0) {
602             safeSend(_userAddress);
603         }
604     }
605 
606     /**
607      * @dev Send value of pendingReturns[_address] to _address.
608      * @param _address Address to send value to.
609      */
610     function safeSend(address _address) internal {
611         uint valueToSend = pendingReturns[_address];
612         assert(valueToSend > 0);
613 
614         pendingReturns[_address] = 0;
615         if (_address.send(valueToSend) == false) {
616             pendingReturns[_address] = valueToSend;
617         }
618     }
619 
620     /**
621      * @dev Verify signature of given data. Throws on verification failure.
622      * @param _sig Signature of given data in the form of rsv.
623      * @param _address Address of signature signer.
624      */
625     function verifySig(
626         uint32 _roundId,
627         uint8 _gameType,
628         uint _num,
629         uint _value,
630         int _balance,
631         bytes32 _serverHash,
632         bytes32 _userHash,
633         uint _gameId,
634         address _contractAddress,
635         bytes _sig,
636         address _address
637     )
638         internal
639         view
640     {
641         // check if this is the correct contract
642         address contractAddress = this;
643         require(_contractAddress == contractAddress, "inv contractAddress");
644 
645         bytes32 roundHash = calcHash(
646                 _roundId,
647                 _gameType,
648                 _num,
649                 _value,
650                 _balance,
651                 _serverHash,
652                 _userHash,
653                 _gameId
654         );
655 
656         verify(
657                 roundHash,
658                 _sig,
659                 _address
660         );
661     }
662 
663      /**
664      * @dev Check if _sig is valid signature of _hash. Throws if invalid signature.
665      * @param _hash Hash to check signature of.
666      * @param _sig Signature of _hash.
667      * @param _address Address of signer.
668      */
669     function verify(
670         bytes32 _hash,
671         bytes _sig,
672         address _address
673     )
674         internal
675         pure
676     {
677         (bytes32 r, bytes32 s, uint8 v) = signatureSplit(_sig);
678         address addressRecover = ecrecover(_hash, v, r, s);
679         require(addressRecover == _address, "inv sig");
680     }
681 
682     /**
683      * @dev Calculate typed hash of given data (compare eth_signTypedData).
684      * @return Hash of given data.
685      */
686     function calcHash(
687         uint32 _roundId,
688         uint8 _gameType,
689         uint _num,
690         uint _value,
691         int _balance,
692         bytes32 _serverHash,
693         bytes32 _userHash,
694         uint _gameId
695     )
696         private
697         view
698         returns(bytes32)
699     {
700         bytes32 betHash = keccak256(abi.encodePacked(
701             _roundId,
702             _gameType,
703             uint16(_num),
704             _value,
705             _balance,
706             _serverHash,
707             _userHash,
708             _gameId,
709             address(this)
710         ));
711 
712         return keccak256(abi.encodePacked(
713             TYPE_HASH,
714             betHash
715         ));
716     }
717 
718     /**
719      * @dev Split the given signature of the form rsv in r s v. v is incremented with 27 if
720      * it is below 2.
721      * @param _signature Signature to split.
722      * @return r s v
723      */
724     function signatureSplit(bytes _signature)
725         private
726         pure
727         returns (bytes32 r, bytes32 s, uint8 v)
728     {
729         require(_signature.length == 65, "inv sig");
730 
731         assembly {
732             r := mload(add(_signature, 32))
733             s := mload(add(_signature, 64))
734             v := and(mload(add(_signature, 65)), 0xff)
735         }
736         if (v < 2) {
737             v = v + 27;
738         }
739     }
740 }
741 
742 contract GameChannelConflict is GameChannelBase {
743     using SafeCast for int;
744     using SafeCast for uint;
745     using SafeMath for int;
746     using SafeMath for uint;
747 
748     /**
749      * @dev Contract constructor.
750      * @param _serverAddress Server address.
751      * @param _minStake Min value user needs to deposit to create game session.
752      * @param _maxStake Max value user can deposit to create game session.
753      * @param _conflictResAddress Conflict resolution contract address
754      * @param _houseAddress House address to move profit to
755      * @param _chainId Chain id for signature domain.
756      */
757     constructor(
758         address _serverAddress,
759         uint128 _minStake,
760         uint128 _maxStake,
761         address _conflictResAddress,
762         address _houseAddress,
763         uint _chainId
764     )
765         public
766         GameChannelBase(_serverAddress, _minStake, _maxStake, _conflictResAddress, _houseAddress, _chainId)
767     {
768         // nothing to do
769     }
770 
771     /**
772      * @dev Used by server if user does not end game session.
773      * @param _roundId Round id of bet.
774      * @param _gameType Game type of bet.
775      * @param _num Number of bet.
776      * @param _value Value of bet.
777      * @param _balance Balance before this bet.
778      * @param _serverHash Hash of server seed for this bet.
779      * @param _userHash Hash of user seed for this bet.
780      * @param _gameId Game session id.
781      * @param _contractAddress Address of this contract.
782      * @param _userSig User signature of this bet.
783      * @param _userAddress Address of user.
784      * @param _serverSeed Server seed for this bet.
785      * @param _userSeed User seed for this bet.
786      */
787     function serverEndGameConflict(
788         uint32 _roundId,
789         uint8 _gameType,
790         uint _num,
791         uint _value,
792         int _balance,
793         bytes32 _serverHash,
794         bytes32 _userHash,
795         uint _gameId,
796         address _contractAddress,
797         bytes _userSig,
798         address _userAddress,
799         bytes32 _serverSeed,
800         bytes32 _userSeed
801     )
802         public
803         onlyServer
804     {
805         verifySig(
806                 _roundId,
807                 _gameType,
808                 _num,
809                 _value,
810                 _balance,
811                 _serverHash,
812                 _userHash,
813                 _gameId,
814                 _contractAddress,
815                 _userSig,
816                 _userAddress
817         );
818 
819         serverEndGameConflictImpl(
820                 _roundId,
821                 _gameType,
822                 _num,
823                 _value,
824                 _balance,
825                 _serverHash,
826                 _userHash,
827                 _serverSeed,
828                 _userSeed,
829                 _gameId,
830                 _userAddress
831         );
832     }
833 
834     /**
835      * @notice Can be used by user if server does not answer to the end game session request.
836      * @param _roundId Round id of bet.
837      * @param _gameType Game type of bet.
838      * @param _num Number of bet.
839      * @param _value Value of bet.
840      * @param _balance Balance before this bet.
841      * @param _serverHash Hash of server seed for this bet.
842      * @param _userHash Hash of user seed for this bet.
843      * @param _gameId Game session id.
844      * @param _contractAddress Address of this contract.
845      * @param _serverSig Server signature of this bet.
846      * @param _userSeed User seed for this bet.
847      */
848     function userEndGameConflict(
849         uint32 _roundId,
850         uint8 _gameType,
851         uint _num,
852         uint _value,
853         int _balance,
854         bytes32 _serverHash,
855         bytes32 _userHash,
856         uint _gameId,
857         address _contractAddress,
858         bytes _serverSig,
859         bytes32 _userSeed
860     )
861         public
862     {
863         verifySig(
864             _roundId,
865             _gameType,
866             _num,
867             _value,
868             _balance,
869             _serverHash,
870             _userHash,
871             _gameId,
872             _contractAddress,
873             _serverSig,
874             serverAddress
875         );
876 
877         userEndGameConflictImpl(
878             _roundId,
879             _gameType,
880             _num,
881             _value,
882             _balance,
883             _userHash,
884             _userSeed,
885             _gameId,
886             msg.sender
887         );
888     }
889 
890     /**
891      * @notice Cancel active game without playing. Useful if server stops responding before
892      * one game is played.
893      * @param _gameId Game session id.
894      */
895     function userCancelActiveGame(uint _gameId) public {
896         address userAddress = msg.sender;
897         uint gameId = userGameId[userAddress];
898         Game storage game = gameIdGame[gameId];
899 
900         require(gameId == _gameId, "inv gameId");
901 
902         if (game.status == GameStatus.ACTIVE) {
903             game.endInitiatedTime = block.timestamp;
904             game.status = GameStatus.USER_INITIATED_END;
905 
906             emit LogUserRequestedEnd(msg.sender, gameId);
907         } else if (game.status == GameStatus.SERVER_INITIATED_END && game.roundId == 0) {
908             cancelActiveGame(game, gameId, userAddress);
909         } else {
910             revert();
911         }
912     }
913 
914     /**
915      * @dev Cancel active game without playing. Useful if user starts game session and
916      * does not play.
917      * @param _userAddress Users' address.
918      * @param _gameId Game session id.
919      */
920     function serverCancelActiveGame(address _userAddress, uint _gameId) public onlyServer {
921         uint gameId = userGameId[_userAddress];
922         Game storage game = gameIdGame[gameId];
923 
924         require(gameId == _gameId, "inv gameId");
925 
926         if (game.status == GameStatus.ACTIVE) {
927             game.endInitiatedTime = block.timestamp;
928             game.status = GameStatus.SERVER_INITIATED_END;
929 
930             emit LogServerRequestedEnd(msg.sender, gameId);
931         } else if (game.status == GameStatus.USER_INITIATED_END && game.roundId == 0) {
932             cancelActiveGame(game, gameId, _userAddress);
933         } else {
934             revert();
935         }
936     }
937 
938     /**
939     * @dev Force end of game if user does not respond. Only possible after a certain period of time
940     * to give the user a chance to respond.
941     * @param _userAddress User's address.
942     */
943     function serverForceGameEnd(address _userAddress, uint _gameId) public onlyServer {
944         uint gameId = userGameId[_userAddress];
945         Game storage game = gameIdGame[gameId];
946 
947         require(gameId == _gameId, "inv gameId");
948         require(game.status == GameStatus.SERVER_INITIATED_END, "inv status");
949 
950         // theoretically we have enough data to calculate winner
951         // but as user did not respond assume he has lost.
952         int newBalance = conflictRes.serverForceGameEnd(
953             game.gameType,
954             game.betNum,
955             game.betValue,
956             game.balance,
957             game.stake,
958             game.endInitiatedTime
959         );
960 
961         closeGame(game, gameId, game.roundId, _userAddress, ReasonEnded.SERVER_FORCED_END, newBalance);
962     }
963 
964     /**
965     * @notice Force end of game if server does not respond. Only possible after a certain period of time
966     * to give the server a chance to respond.
967     */
968     function userForceGameEnd(uint _gameId) public {
969         address userAddress = msg.sender;
970         uint gameId = userGameId[userAddress];
971         Game storage game = gameIdGame[gameId];
972 
973         require(gameId == _gameId, "inv gameId");
974         require(game.status == GameStatus.USER_INITIATED_END, "inv status");
975 
976         int newBalance = conflictRes.userForceGameEnd(
977             game.gameType,
978             game.betNum,
979             game.betValue,
980             game.balance,
981             game.stake,
982             game.endInitiatedTime
983         );
984 
985         closeGame(game, gameId, game.roundId, userAddress, ReasonEnded.USER_FORCED_END, newBalance);
986     }
987 
988     /**
989      * @dev Conflict handling implementation. Stores game data and timestamp if game
990      * is active. If server has already marked conflict for game session the conflict
991      * resolution contract is used (compare conflictRes).
992      * @param _roundId Round id of bet.
993      * @param _gameType Game type of bet.
994      * @param _num Number of bet.
995      * @param _value Value of bet.
996      * @param _balance Balance before this bet.
997      * @param _userHash Hash of user's seed for this bet.
998      * @param _userSeed User's seed for this bet.
999      * @param _gameId game Game session id.
1000      * @param _userAddress User's address.
1001      */
1002     function userEndGameConflictImpl(
1003         uint32 _roundId,
1004         uint8 _gameType,
1005         uint _num,
1006         uint _value,
1007         int _balance,
1008         bytes32 _userHash,
1009         bytes32 _userSeed,
1010         uint _gameId,
1011         address _userAddress
1012     )
1013         private
1014     {
1015         uint gameId = userGameId[_userAddress];
1016         Game storage game = gameIdGame[gameId];
1017         int maxBalance = conflictRes.maxBalance();
1018         int gameStake = game.stake;
1019 
1020         require(gameId == _gameId, "inv gameId");
1021         require(_roundId > 0, "inv roundId");
1022         require(keccak256(abi.encodePacked(_userSeed)) == _userHash, "inv userSeed");
1023         require(-gameStake <= _balance && _balance <= maxBalance, "inv balance"); // game.stake save to cast as uint128
1024         require(conflictRes.isValidBet(_gameType, _num, _value), "inv bet");
1025         require(gameStake.add(_balance).sub(_value.castToInt()) >= 0, "value too high"); // game.stake save to cast as uint128
1026 
1027         if (game.status == GameStatus.SERVER_INITIATED_END && game.roundId == _roundId) {
1028             game.userSeed = _userSeed;
1029             endGameConflict(game, gameId, _userAddress);
1030         } else if (game.status == GameStatus.ACTIVE
1031                 || (game.status == GameStatus.SERVER_INITIATED_END && game.roundId < _roundId)) {
1032             game.status = GameStatus.USER_INITIATED_END;
1033             game.endInitiatedTime = block.timestamp;
1034             game.roundId = _roundId;
1035             game.gameType = _gameType;
1036             game.betNum = _num;
1037             game.betValue = _value;
1038             game.balance = _balance;
1039             game.userSeed = _userSeed;
1040             game.serverSeed = bytes32(0);
1041 
1042             emit LogUserRequestedEnd(msg.sender, gameId);
1043         } else {
1044             revert("inv state");
1045         }
1046     }
1047 
1048     /**
1049      * @dev Conflict handling implementation. Stores game data and timestamp if game
1050      * is active. If user has already marked conflict for game session the conflict
1051      * resolution contract is used (compare conflictRes).
1052      * @param _roundId Round id of bet.
1053      * @param _gameType Game type of bet.
1054      * @param _num Number of bet.
1055      * @param _value Value of bet.
1056      * @param _balance Balance before this bet.
1057      * @param _serverHash Hash of server's seed for this bet.
1058      * @param _userHash Hash of user's seed for this bet.
1059      * @param _serverSeed Server's seed for this bet.
1060      * @param _userSeed User's seed for this bet.
1061      * @param _userAddress User's address.
1062      */
1063     function serverEndGameConflictImpl(
1064         uint32 _roundId,
1065         uint8 _gameType,
1066         uint _num,
1067         uint _value,
1068         int _balance,
1069         bytes32 _serverHash,
1070         bytes32 _userHash,
1071         bytes32 _serverSeed,
1072         bytes32 _userSeed,
1073         uint _gameId,
1074         address _userAddress
1075     )
1076         private
1077     {
1078         uint gameId = userGameId[_userAddress];
1079         Game storage game = gameIdGame[gameId];
1080         int maxBalance = conflictRes.maxBalance();
1081         int gameStake = game.stake;
1082 
1083         require(gameId == _gameId, "inv gameId");
1084         require(_roundId > 0, "inv roundId");
1085         require(keccak256(abi.encodePacked(_serverSeed)) == _serverHash, "inv serverSeed");
1086         require(keccak256(abi.encodePacked(_userSeed)) == _userHash, "inv userSeed");
1087         require(-gameStake <= _balance && _balance <= maxBalance, "inv balance"); // game.stake save to cast as uint128
1088         require(conflictRes.isValidBet(_gameType, _num, _value), "inv bet");
1089         require(gameStake.add(_balance).sub(_value.castToInt()) >= 0, "too high value"); // game.stake save to cast as uin128
1090 
1091         if (game.status == GameStatus.USER_INITIATED_END && game.roundId == _roundId) {
1092             game.serverSeed = _serverSeed;
1093             endGameConflict(game, gameId, _userAddress);
1094         } else if (game.status == GameStatus.ACTIVE
1095                 || (game.status == GameStatus.USER_INITIATED_END && game.roundId < _roundId)) {
1096             game.status = GameStatus.SERVER_INITIATED_END;
1097             game.endInitiatedTime = block.timestamp;
1098             game.roundId = _roundId;
1099             game.gameType = _gameType;
1100             game.betNum = _num;
1101             game.betValue = _value;
1102             game.balance = _balance;
1103             game.serverSeed = _serverSeed;
1104             game.userSeed = _userSeed;
1105 
1106             emit LogServerRequestedEnd(_userAddress, gameId);
1107         } else {
1108             revert("inv state");
1109         }
1110     }
1111 
1112     /**
1113      * @dev End conflicting game without placed bets.
1114      * @param _game Game session data.
1115      * @param _gameId Game session id.
1116      * @param _userAddress User's address.
1117      */
1118     function cancelActiveGame(Game storage _game, uint _gameId, address _userAddress) private {
1119         // user need to pay a fee when conflict ended.
1120         // this ensures a malicious, rich user can not just generate game sessions and then wait
1121         // for us to end the game session and then confirm the session status, so
1122         // we would have to pay a high gas fee without profit.
1123         int newBalance = -conflictRes.conflictEndFine();
1124 
1125         // do not allow balance below user stake
1126         int stake = _game.stake;
1127         if (newBalance < -stake) {
1128             newBalance = -stake;
1129         }
1130         closeGame(_game, _gameId, 0, _userAddress, ReasonEnded.CONFLICT_ENDED, newBalance);
1131     }
1132 
1133     /**
1134      * @dev End conflicting game.
1135      * @param _game Game session data.
1136      * @param _gameId Game session id.
1137      * @param _userAddress User's address.
1138      */
1139     function endGameConflict(Game storage _game, uint _gameId, address _userAddress) private {
1140         int newBalance = conflictRes.endGameConflict(
1141             _game.gameType,
1142             _game.betNum,
1143             _game.betValue,
1144             _game.balance,
1145             _game.stake,
1146             _game.serverSeed,
1147             _game.userSeed
1148         );
1149 
1150         closeGame(_game, _gameId, _game.roundId, _userAddress, ReasonEnded.CONFLICT_ENDED, newBalance);
1151     }
1152 }
1153 
1154 contract GameChannel is GameChannelConflict {
1155     /**
1156      * @dev contract constructor
1157      * @param _serverAddress Server address.
1158      * @param _minStake Min value user needs to deposit to create game session.
1159      * @param _maxStake Max value user can deposit to create game session.
1160      * @param _conflictResAddress Conflict resolution contract address.
1161      * @param _houseAddress House address to move profit to.
1162      * @param _chainId Chain id for signature domain.
1163      */
1164     constructor(
1165         address _serverAddress,
1166         uint128 _minStake,
1167         uint128 _maxStake,
1168         address _conflictResAddress,
1169         address _houseAddress,
1170         uint _chainId
1171     )
1172         public
1173         GameChannelConflict(_serverAddress, _minStake, _maxStake, _conflictResAddress, _houseAddress, _chainId)
1174     {
1175         // nothing to do
1176     }
1177 
1178     /**
1179      * @notice Create games session request. msg.value needs to be valid stake value.
1180      * @param _userEndHash Last entry of users' hash chain.
1181      * @param _previousGameId User's previous game id, initial 0.
1182      * @param _createBefore Game can be only created before this timestamp.
1183      * @param _serverEndHash Last entry of server's hash chain.
1184      * @param _serverSig Server signature. See verifyCreateSig
1185      */
1186     function createGame(
1187         bytes32 _userEndHash,
1188         uint _previousGameId,
1189         uint _createBefore,
1190         bytes32 _serverEndHash,
1191         bytes _serverSig
1192     )
1193         public
1194         payable
1195         onlyValidValue
1196         onlyValidHouseStake(activeGames + 1)
1197         onlyNotPaused
1198     {
1199         uint previousGameId = userGameId[msg.sender];
1200         Game storage game = gameIdGame[previousGameId];
1201 
1202         require(game.status == GameStatus.ENDED, "prev game not ended");
1203         require(previousGameId == _previousGameId, "inv gamePrevGameId");
1204         require(block.timestamp < _createBefore, "expired");
1205 
1206         verifyCreateSig(msg.sender, _previousGameId, _createBefore, _serverEndHash, _serverSig);
1207 
1208         uint gameId = gameIdCntr++;
1209         userGameId[msg.sender] = gameId;
1210         Game storage newGame = gameIdGame[gameId];
1211 
1212         newGame.stake = uint128(msg.value); // It's safe to cast msg.value as it is limited, see onlyValidValue
1213         newGame.status = GameStatus.ACTIVE;
1214 
1215         activeGames = activeGames.add(1);
1216 
1217         // It's safe to cast msg.value as it is limited, see onlyValidValue
1218         emit LogGameCreated(msg.sender, gameId, uint128(msg.value), _serverEndHash,  _userEndHash);
1219     }
1220 
1221 
1222     /**
1223      * @dev Regular end game session. Used if user and house have both
1224      * accepted current game session state.
1225      * The game session with gameId _gameId is closed
1226      * and the user paid out. This functions is called by the server after
1227      * the user requested the termination of the current game session.
1228      * @param _roundId Round id of bet.
1229      * @param _balance Current balance.
1230      * @param _serverHash Hash of server's seed for this bet.
1231      * @param _userHash Hash of user's seed for this bet.
1232      * @param _gameId Game session id.
1233      * @param _contractAddress Address of this contract.
1234      * @param _userAddress Address of user.
1235      * @param _userSig User's signature of this bet.
1236      */
1237     function serverEndGame(
1238         uint32 _roundId,
1239         int _balance,
1240         bytes32 _serverHash,
1241         bytes32 _userHash,
1242         uint _gameId,
1243         address _contractAddress,
1244         address _userAddress,
1245         bytes _userSig
1246     )
1247         public
1248         onlyServer
1249     {
1250         verifySig(
1251                 _roundId,
1252                 0,
1253                 0,
1254                 0,
1255                 _balance,
1256                 _serverHash,
1257                 _userHash,
1258                 _gameId,
1259                 _contractAddress,
1260                 _userSig,
1261                 _userAddress
1262         );
1263 
1264         regularEndGame(_userAddress, _roundId, _balance, _gameId, _contractAddress);
1265     }
1266 
1267     /**
1268      * @notice Regular end game session. Normally not needed as server ends game (@see serverEndGame).
1269      * Can be used by user if server does not end game session.
1270      * @param _roundId Round id of bet.
1271      * @param _balance Current balance.
1272      * @param _serverHash Hash of server's seed for this bet.
1273      * @param _userHash Hash of user's seed for this bet.
1274      * @param _gameId Game session id.
1275      * @param _contractAddress Address of this contract.
1276      * @param _serverSig Server's signature of this bet.
1277      */
1278     function userEndGame(
1279         uint32 _roundId,
1280         int _balance,
1281         bytes32 _serverHash,
1282         bytes32 _userHash,
1283         uint _gameId,
1284         address _contractAddress,
1285         bytes _serverSig
1286     )
1287         public
1288     {
1289         verifySig(
1290                 _roundId,
1291                 0,
1292                 0,
1293                 0,
1294                 _balance,
1295                 _serverHash,
1296                 _userHash,
1297                 _gameId,
1298                 _contractAddress,
1299                 _serverSig,
1300                 serverAddress
1301         );
1302 
1303         regularEndGame(msg.sender, _roundId, _balance, _gameId, _contractAddress);
1304     }
1305 
1306     /**
1307      * @dev Verify server signature.
1308      * @param _userAddress User's address.
1309      * @param _previousGameId User's previous game id, initial 0.
1310      * @param _createBefore Game can be only created before this timestamp.
1311      * @param _serverEndHash Last entry of server's hash chain.
1312      * @param _serverSig Server signature.
1313      */
1314     function verifyCreateSig(
1315         address _userAddress,
1316         uint _previousGameId,
1317         uint _createBefore,
1318         bytes32 _serverEndHash,
1319         bytes _serverSig
1320     )
1321         private view
1322     {
1323         address contractAddress = this;
1324         bytes32 hash = keccak256(abi.encodePacked(
1325             contractAddress, _userAddress, _previousGameId, _createBefore, _serverEndHash
1326         ));
1327 
1328         verify(hash, _serverSig, serverAddress);
1329     }
1330 
1331     /**
1332      * @dev Regular end game session implementation. Used if user and house have both
1333      * accepted current game session state. The game session with gameId _gameId is closed
1334      * and the user paid out.
1335      * @param _userAddress Address of user.
1336      * @param _balance Current balance.
1337      * @param _gameId Game session id.
1338      * @param _contractAddress Address of this contract.
1339      */
1340     function regularEndGame(
1341         address _userAddress,
1342         uint32 _roundId,
1343         int _balance,
1344         uint _gameId,
1345         address _contractAddress
1346     )
1347         private
1348     {
1349         uint gameId = userGameId[_userAddress];
1350         Game storage game = gameIdGame[gameId];
1351         int maxBalance = conflictRes.maxBalance();
1352         int gameStake = game.stake;
1353 
1354         require(_gameId == gameId, "inv gameId");
1355         require(_roundId > 0, "inv roundId");
1356         // save to cast as game.stake hash fixed range
1357         require(-gameStake <= _balance && _balance <= maxBalance, "inv balance");
1358         require(game.status == GameStatus.ACTIVE, "inv status");
1359 
1360         assert(_contractAddress == address(this));
1361 
1362         closeGame(game, gameId, _roundId, _userAddress, ReasonEnded.REGULAR_ENDED, _balance);
1363     }
1364 }
1365 
1366 library SafeCast {
1367     /**
1368      * Cast unsigned a to signed a.
1369      */
1370     function castToInt(uint a) internal pure returns(int) {
1371         assert(a < (1 << 255));
1372         return int(a);
1373     }
1374 
1375     /**
1376      * Cast signed a to unsigned a.
1377      */
1378     function castToUint(int a) internal pure returns(uint) {
1379         assert(a >= 0);
1380         return uint(a);
1381     }
1382 }
1383 
1384 library SafeMath {
1385 
1386     /**
1387     * @dev Multiplies two unsigned integers, throws on overflow.
1388     */
1389     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1390         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1391         // benefit is lost if 'b' is also tested.
1392         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1393         if (a == 0) {
1394             return 0;
1395         }
1396 
1397         c = a * b;
1398         assert(c / a == b);
1399         return c;
1400     }
1401 
1402     /**
1403     * @dev Multiplies two signed integers, throws on overflow.
1404     */
1405     function mul(int256 a, int256 b) internal pure returns (int256) {
1406         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1407         // benefit is lost if 'b' is also tested.
1408         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1409         if (a == 0) {
1410             return 0;
1411         }
1412         int256 c = a * b;
1413         assert(c / a == b);
1414         return c;
1415     }
1416 
1417     /**
1418     * @dev Integer division of two unsigned integers, truncating the quotient.
1419     */
1420     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1421         // assert(b > 0); // Solidity automatically throws when dividing by 0
1422         // uint256 c = a / b;
1423         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1424         return a / b;
1425     }
1426 
1427     /**
1428     * @dev Integer division of two signed integers, truncating the quotient.
1429     */
1430     function div(int256 a, int256 b) internal pure returns (int256) {
1431         // assert(b > 0); // Solidity automatically throws when dividing by 0
1432         // Overflow only happens when the smallest negative int is multiplied by -1.
1433         int256 INT256_MIN = int256((uint256(1) << 255));
1434         assert(a != INT256_MIN || b != - 1);
1435         return a / b;
1436     }
1437 
1438     /**
1439     * @dev Subtracts two unsigned integers, throws on overflow (i.e. if subtrahend is greater than minuend).
1440     */
1441     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1442         assert(b <= a);
1443         return a - b;
1444     }
1445 
1446     /**
1447     * @dev Subtracts two signed integers, throws on overflow.
1448     */
1449     function sub(int256 a, int256 b) internal pure returns (int256) {
1450         int256 c = a - b;
1451         assert((b >= 0 && c <= a) || (b < 0 && c > a));
1452         return c;
1453     }
1454 
1455     /**
1456     * @dev Adds two unsigned integers, throws on overflow.
1457     */
1458     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1459         c = a + b;
1460         assert(c >= a);
1461         return c;
1462     }
1463 
1464     /**
1465     * @dev Adds two signed integers, throws on overflow.
1466     */
1467     function add(int256 a, int256 b) internal pure returns (int256) {
1468         int256 c = a + b;
1469         assert((b >= 0 && c >= a) || (b < 0 && c < a));
1470         return c;
1471     }
1472 }