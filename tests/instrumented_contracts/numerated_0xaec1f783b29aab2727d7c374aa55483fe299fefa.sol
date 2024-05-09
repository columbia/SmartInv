1 pragma solidity ^0.5.0;
2 
3 interface ConflictResolutionInterface {
4     function minHouseStake(uint activeGames) external view returns(uint);
5 
6     function maxBalance() external view returns(int);
7 
8     function conflictEndFine() external pure returns(int);
9 
10     function isValidBet(uint8 _gameType, uint _betNum, uint _betValue) external view returns(bool);
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
31         bytes32 _serverSeed,
32         bytes32 _userSeed,
33         uint _endInitiatedTime
34     )
35         external
36         view
37         returns(int);
38 
39     function userForceGameEnd(
40         uint8 _gameType,
41         uint _betNum,
42         uint _betValue,
43         int _balance,
44         uint _stake,
45         uint _endInitiatedTime
46     )
47         external
48         view
49         returns(int);
50 }
51 
52 library MathUtil {
53     /**
54      * @dev Returns the absolute value of _val.
55      * @param _val value
56      * @return The absolute value of _val.
57      */
58     function abs(int _val) internal pure returns(uint) {
59         if (_val < 0) {
60             return uint(-_val);
61         } else {
62             return uint(_val);
63         }
64     }
65 
66     /**
67      * @dev Calculate maximum.
68      */
69     function max(uint _val1, uint _val2) internal pure returns(uint) {
70         return _val1 >= _val2 ? _val1 : _val2;
71     }
72 
73     /**
74      * @dev Calculate minimum.
75      */
76     function min(uint _val1, uint _val2) internal pure returns(uint) {
77         return _val1 <= _val2 ? _val1 : _val2;
78     }
79 }
80 
81 contract Ownable {
82     address payable public owner;
83     address payable public pendingOwner;
84 
85     event LogOwnerShipTransferred(address indexed previousOwner, address indexed newOwner);
86     event LogOwnerShipTransferInitiated(address indexed previousOwner, address indexed newOwner);
87 
88     /**
89      * @dev Modifier, which throws if called by other account than owner.
90      */
91     modifier onlyOwner {
92         require(msg.sender == owner);
93         _;
94     }
95 
96     /**
97      * @dev Modifier throws if called by any account other than the pendingOwner.
98      */
99     modifier onlyPendingOwner() {
100         require(msg.sender == pendingOwner);
101         _;
102     }
103 
104     /**
105      * @dev Set contract creator as initial owner
106      */
107     constructor() public {
108         owner = msg.sender;
109         pendingOwner = address(0);
110     }
111 
112     /**
113      * @dev Allows the current owner to set the pendingOwner address.
114      * @param _newOwner The address to transfer ownership to.
115      */
116     function transferOwnership(address payable _newOwner) public onlyOwner {
117         pendingOwner = _newOwner;
118         emit LogOwnerShipTransferInitiated(owner, _newOwner);
119     }
120 
121     /**
122      * @dev PendingOwner can accept ownership.
123      */
124     function claimOwnership() public onlyPendingOwner {
125         owner = pendingOwner;
126         pendingOwner = address(0);
127         emit LogOwnerShipTransferred(owner, pendingOwner);
128     }
129 }
130 
131 contract Activatable is Ownable {
132     bool public activated = false;
133 
134     /// @dev Event is fired if activated.
135     event LogActive();
136 
137     /// @dev Modifier, which only allows function execution if activated.
138     modifier onlyActivated() {
139         require(activated);
140         _;
141     }
142 
143     /// @dev Modifier, which only allows function execution if not activated.
144     modifier onlyNotActivated() {
145         require(!activated);
146         _;
147     }
148 
149     /// @dev activate contract, can be only called once by the contract owner.
150     function activate() public onlyOwner onlyNotActivated {
151         activated = true;
152         emit LogActive();
153     }
154 }
155 
156 contract ConflictResolutionManager is Ownable {
157     /// @dev Conflict resolution contract.
158     ConflictResolutionInterface public conflictRes;
159 
160     /// @dev New Conflict resolution contract.
161     address public newConflictRes = address(0);
162 
163     /// @dev Time update of new conflict resolution contract was initiated.
164     uint public updateTime = 0;
165 
166     /// @dev Min time before new conflict res contract can be activated after initiating update.
167     uint public constant MIN_TIMEOUT = 3 days;
168 
169     /// @dev Min time before new conflict res contract can be activated after initiating update.
170     uint public constant MAX_TIMEOUT = 6 days;
171 
172     /// @dev Update of conflict resolution contract was initiated.
173     event LogUpdatingConflictResolution(address newConflictResolutionAddress);
174 
175     /// @dev New conflict resolution contract is active.
176     event LogUpdatedConflictResolution(address newConflictResolutionAddress);
177 
178     /**
179      * @dev Constructor
180      * @param _conflictResAddress conflict resolution contract address.
181      */
182     constructor(address _conflictResAddress) public {
183         conflictRes = ConflictResolutionInterface(_conflictResAddress);
184     }
185 
186     /**
187      * @dev Initiate conflict resolution contract update.
188      * @param _newConflictResAddress New conflict resolution contract address.
189      */
190     function updateConflictResolution(address _newConflictResAddress) public onlyOwner {
191         newConflictRes = _newConflictResAddress;
192         updateTime = block.timestamp;
193 
194         emit LogUpdatingConflictResolution(_newConflictResAddress);
195     }
196 
197     /**
198      * @dev Active new conflict resolution contract.
199      */
200     function activateConflictResolution() public onlyOwner {
201         require(newConflictRes != address(0));
202         require(updateTime != 0);
203         require(updateTime + MIN_TIMEOUT <= block.timestamp && block.timestamp <= updateTime + MAX_TIMEOUT);
204 
205         conflictRes = ConflictResolutionInterface(newConflictRes);
206         newConflictRes = address(0);
207         updateTime = 0;
208 
209         emit LogUpdatedConflictResolution(newConflictRes);
210     }
211 }
212 
213 contract Pausable is Activatable {
214     using SafeMath for uint;
215 
216     /// @dev Is contract paused. Initial it is paused.
217     bool public paused = true;
218 
219     /// @dev Time pause was called
220     uint public timePaused = block.timestamp;
221 
222     /// @dev Modifier, which only allows function execution if not paused.
223     modifier onlyNotPaused() {
224         require(!paused, "paused");
225         _;
226     }
227 
228     /// @dev Modifier, which only allows function execution if paused.
229     modifier onlyPaused() {
230         require(paused);
231         _;
232     }
233 
234     /// @dev Modifier, which only allows function execution if paused longer than timeSpan.
235     modifier onlyPausedSince(uint timeSpan) {
236         require(paused && (timePaused.add(timeSpan) <= block.timestamp));
237         _;
238     }
239 
240     /// @dev Event is fired if paused.
241     event LogPause();
242 
243     /// @dev Event is fired if pause is ended.
244     event LogUnpause();
245 
246     /**
247      * @dev Pause contract. No new game sessions can be created.
248      */
249     function pause() public onlyOwner onlyNotPaused {
250         paused = true;
251         timePaused = block.timestamp;
252         emit LogPause();
253     }
254 
255     /**
256      * @dev Unpause contract. Initial contract is paused and can only be unpaused after activating it.
257      */
258     function unpause() public onlyOwner onlyPaused onlyActivated {
259         paused = false;
260         timePaused = 0;
261         emit LogUnpause();
262     }
263 }
264 
265 contract Destroyable is Pausable {
266     /// @dev After pausing the contract for 20 days owner can selfdestruct it.
267     uint public constant TIMEOUT_DESTROY = 20 days;
268 
269     /**
270      * @dev Destroy contract and transfer ether to owner.
271      */
272     function destroy() public onlyOwner onlyPausedSince(TIMEOUT_DESTROY) {
273         selfdestruct(owner);
274     }
275 }
276 
277 contract GameChannelBase is Destroyable, ConflictResolutionManager {
278     using SafeCast for int;
279     using SafeCast for uint;
280     using SafeMath for int;
281     using SafeMath for uint;
282 
283 
284     /// @dev Different game session states.
285     enum GameStatus {
286         ENDED, ///< @dev Game session is ended.
287         ACTIVE, ///< @dev Game session is active.
288         USER_INITIATED_END, ///< @dev User initiated non regular end.
289         SERVER_INITIATED_END ///< @dev Server initiated non regular end.
290     }
291 
292     /// @dev Reason game session ended.
293     enum ReasonEnded {
294         REGULAR_ENDED, ///< @dev Game session is regularly ended.
295         SERVER_FORCED_END, ///< @dev User did not respond. Server forced end.
296         USER_FORCED_END, ///< @dev Server did not respond. User forced end.
297         CONFLICT_ENDED ///< @dev Server or user raised conflict ans pushed game state, opponent pushed same game state.
298     }
299 
300     struct Game {
301         /// @dev Game session status.
302         GameStatus status;
303 
304         /// @dev User's stake.
305         uint128 stake;
306 
307         /// @dev Last game round info if not regularly ended.
308         /// If game session is ended normally this data is not used.
309         uint8 gameType;
310         uint32 roundId;
311         uint betNum;
312         uint betValue;
313         int balance;
314         bytes32 userSeed;
315         bytes32 serverSeed;
316         uint endInitiatedTime;
317     }
318 
319     /// @dev Minimal time span between profit transfer.
320     uint public constant MIN_TRANSFER_TIMESPAN = 1 days;
321 
322     /// @dev Maximal time span between profit transfer.
323     uint public constant MAX_TRANSFER_TIMSPAN = 6 * 30 days;
324 
325     bytes32 public constant EIP712DOMAIN_TYPEHASH = keccak256(
326         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
327     );
328 
329     bytes32 public constant BET_TYPEHASH = keccak256(
330         "Bet(uint32 roundId,uint8 gameType,uint256 number,uint256 value,int256 balance,bytes32 serverHash,bytes32 userHash,uint256 gameId)"
331     );
332 
333     bytes32 public DOMAIN_SEPERATOR;
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
346     address payable public houseAddress;
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
430         address payable _houseAddress,
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
443 
444         DOMAIN_SEPERATOR =  keccak256(abi.encode(
445             EIP712DOMAIN_TYPEHASH,
446             keccak256("Dicether"),
447             keccak256("2"),
448             _chainId,
449             address(this)
450         ));
451     }
452 
453     /**
454      * @dev Set gameIdCntr. Can be only set before activating contract.
455      */
456     function setGameIdCntr(uint _gameIdCntr) public onlyOwner onlyNotActivated {
457         require(gameIdCntr > 0);
458         gameIdCntr = _gameIdCntr;
459     }
460 
461     /**
462      * @notice Withdraw pending returns.
463      */
464     function withdraw() public {
465         uint toTransfer = pendingReturns[msg.sender];
466         require(toTransfer > 0);
467 
468         pendingReturns[msg.sender] = 0;
469         msg.sender.transfer(toTransfer);
470     }
471 
472     /**
473      * @notice Transfer house profit to houseAddress.
474      */
475     function transferProfitToHouse() public {
476         require(lastProfitTransferTimestamp.add(profitTransferTimeSpan) <= block.timestamp);
477 
478         // update last transfer timestamp
479         lastProfitTransferTimestamp = block.timestamp;
480 
481         if (houseProfit <= 0) {
482             // no profit to transfer
483             return;
484         }
485 
486         uint toTransfer = houseProfit.castToUint();
487 
488         houseProfit = 0;
489         houseStake = houseStake.sub(toTransfer);
490 
491         houseAddress.transfer(toTransfer);
492     }
493 
494     /**
495      * @dev Set profit transfer time span.
496      */
497     function setProfitTransferTimeSpan(uint _profitTransferTimeSpan)
498         public
499         onlyOwner
500         onlyValidTransferTimeSpan(_profitTransferTimeSpan)
501     {
502         profitTransferTimeSpan = _profitTransferTimeSpan;
503     }
504 
505     /**
506      * @dev Increase house stake by msg.value
507      */
508     function addHouseStake() public payable onlyOwner {
509         houseStake = houseStake.add(msg.value);
510     }
511 
512     /**
513      * @dev Withdraw house stake.
514      */
515     function withdrawHouseStake(uint value) public onlyOwner {
516         uint minHouseStake = conflictRes.minHouseStake(activeGames);
517 
518         require(value <= houseStake && houseStake.sub(value) >= minHouseStake);
519         require(houseProfit <= 0 || houseProfit.castToUint() <= houseStake.sub(value));
520 
521         houseStake = houseStake.sub(value);
522         owner.transfer(value);
523     }
524 
525     /**
526      * @dev Withdraw house stake and profit.
527      */
528     function withdrawAll() public onlyOwner onlyPausedSince(3 days) {
529         houseProfit = 0;
530         uint toTransfer = houseStake;
531         houseStake = 0;
532         owner.transfer(toTransfer);
533     }
534 
535     /**
536      * @dev Set new house address.
537      * @param _houseAddress New house address.
538      */
539     function setHouseAddress(address payable _houseAddress) public onlyOwner {
540         houseAddress = _houseAddress;
541     }
542 
543     /**
544      * @dev Set stake min and max value.
545      * @param _minStake Min stake.
546      * @param _maxStake Max stake.
547      */
548     function setStakeRequirements(uint128 _minStake, uint128 _maxStake) public onlyOwner {
549         require(_minStake > 0 && _minStake <= _maxStake);
550         minStake = _minStake;
551         maxStake = _maxStake;
552         emit LogStakeLimitsModified(minStake, maxStake);
553     }
554 
555     /**
556      * @dev Close game session.
557      * @param _game Game session data.
558      * @param _gameId Id of game session.
559      * @param _userAddress User's address of game session.
560      * @param _reason Reason for closing game session.
561      * @param _balance Game session balance.
562      */
563     function closeGame(
564         Game storage _game,
565         uint _gameId,
566         uint32 _roundId,
567         address payable _userAddress,
568         ReasonEnded _reason,
569         int _balance
570     )
571         internal
572     {
573         _game.status = GameStatus.ENDED;
574 
575         activeGames = activeGames.sub(1);
576 
577         payOut(_userAddress, _game.stake, _balance);
578 
579         emit LogGameEnded(_userAddress, _gameId, _roundId, _balance, _reason);
580     }
581 
582     /**
583      * @dev End game by paying out user and server.
584      * @param _userAddress User's address.
585      * @param _stake User's stake.
586      * @param _balance User's balance.
587      */
588     function payOut(address payable _userAddress, uint128 _stake, int _balance) internal {
589         int stakeInt = _stake;
590         int houseStakeInt = houseStake.castToInt();
591 
592         assert(_balance <= conflictRes.maxBalance());
593         assert((stakeInt.add(_balance)) >= 0);
594 
595         if (_balance > 0 && houseStakeInt < _balance) {
596             // Should never happen!
597             // House is bankrupt.
598             // Payout left money.
599             _balance = houseStakeInt;
600         }
601 
602         houseProfit = houseProfit.sub(_balance);
603 
604         int newHouseStake = houseStakeInt.sub(_balance);
605         houseStake = newHouseStake.castToUint();
606 
607         uint valueUser = stakeInt.add(_balance).castToUint();
608         pendingReturns[_userAddress] += valueUser;
609         if (pendingReturns[_userAddress] > 0) {
610             safeSend(_userAddress);
611         }
612     }
613 
614     /**
615      * @dev Send value of pendingReturns[_address] to _address.
616      * @param _address Address to send value to.
617      */
618     function safeSend(address payable _address) internal {
619         uint valueToSend = pendingReturns[_address];
620         assert(valueToSend > 0);
621 
622         pendingReturns[_address] = 0;
623         if (_address.send(valueToSend) == false) {
624             pendingReturns[_address] = valueToSend;
625         }
626     }
627 
628     /**
629      * @dev Verify signature of given data. Throws on verification failure.
630      * @param _sig Signature of given data in the form of rsv.
631      * @param _address Address of signature signer.
632      */
633     function verifySig(
634         uint32 _roundId,
635         uint8 _gameType,
636         uint _num,
637         uint _value,
638         int _balance,
639         bytes32 _serverHash,
640         bytes32 _userHash,
641         uint _gameId,
642         address _contractAddress,
643         bytes memory _sig,
644         address _address
645     )
646         internal
647         view
648     {
649         // check if this is the correct contract
650         address contractAddress = address(this);
651         require(_contractAddress == contractAddress, "inv contractAddress");
652 
653         bytes32 roundHash = calcHash(
654                 _roundId,
655                 _gameType,
656                 _num,
657                 _value,
658                 _balance,
659                 _serverHash,
660                 _userHash,
661                 _gameId
662         );
663 
664         verify(
665                 roundHash,
666                 _sig,
667                 _address
668         );
669     }
670 
671      /**
672      * @dev Check if _sig is valid signature of _hash. Throws if invalid signature.
673      * @param _hash Hash to check signature of.
674      * @param _sig Signature of _hash.
675      * @param _address Address of signer.
676      */
677     function verify(
678         bytes32 _hash,
679         bytes memory _sig,
680         address _address
681     )
682         internal
683         pure
684     {
685         (bytes32 r, bytes32 s, uint8 v) = signatureSplit(_sig);
686         address addressRecover = ecrecover(_hash, v, r, s);
687         require(addressRecover == _address, "inv sig");
688     }
689 
690     /**
691      * @dev Calculate typed hash of given data (compare eth_signTypedData).
692      * @return Hash of given data.
693      */
694     function calcHash(
695         uint32 _roundId,
696         uint8 _gameType,
697         uint _num,
698         uint _value,
699         int _balance,
700         bytes32 _serverHash,
701         bytes32 _userHash,
702         uint _gameId
703     )
704         private
705         view
706         returns(bytes32)
707     {
708         bytes32 betHash = keccak256(abi.encode(
709             BET_TYPEHASH,
710             _roundId,
711             _gameType,
712             _num,
713             _value,
714             _balance,
715             _serverHash,
716             _userHash,
717             _gameId
718         ));
719 
720         return keccak256(abi.encodePacked(
721             "\x19\x01",
722             DOMAIN_SEPERATOR,
723             betHash
724         ));
725     }
726 
727     /**
728      * @dev Split the given signature of the form rsv in r s v. v is incremented with 27 if
729      * it is below 2.
730      * @param _signature Signature to split.
731      * @return r s v
732      */
733     function signatureSplit(bytes memory _signature)
734         private
735         pure
736         returns (bytes32 r, bytes32 s, uint8 v)
737     {
738         require(_signature.length == 65, "inv sig");
739 
740         assembly {
741             r := mload(add(_signature, 32))
742             s := mload(add(_signature, 64))
743             v := and(mload(add(_signature, 65)), 0xff)
744         }
745         if (v < 2) {
746             v = v + 27;
747         }
748     }
749 }
750 
751 contract GameChannelConflict is GameChannelBase {
752     using SafeCast for int;
753     using SafeCast for uint;
754     using SafeMath for int;
755     using SafeMath for uint;
756 
757     /**
758      * @dev Contract constructor.
759      * @param _serverAddress Server address.
760      * @param _minStake Min value user needs to deposit to create game session.
761      * @param _maxStake Max value user can deposit to create game session.
762      * @param _conflictResAddress Conflict resolution contract address
763      * @param _houseAddress House address to move profit to
764      * @param _chainId Chain id for signature domain.
765      */
766     constructor(
767         address _serverAddress,
768         uint128 _minStake,
769         uint128 _maxStake,
770         address _conflictResAddress,
771         address payable _houseAddress,
772         uint _chainId
773     )
774         public
775         GameChannelBase(_serverAddress, _minStake, _maxStake, _conflictResAddress, _houseAddress, _chainId)
776     {
777         // nothing to do
778     }
779 
780     /**
781      * @dev Used by server if user does not end game session.
782      * @param _roundId Round id of bet.
783      * @param _gameType Game type of bet.
784      * @param _num Number of bet.
785      * @param _value Value of bet.
786      * @param _balance Balance before this bet.
787      * @param _serverHash Hash of server seed for this bet.
788      * @param _userHash Hash of user seed for this bet.
789      * @param _gameId Game session id.
790      * @param _contractAddress Address of this contract.
791      * @param _userSig User signature of this bet.
792      * @param _userAddress Address of user.
793      * @param _serverSeed Server seed for this bet.
794      * @param _userSeed User seed for this bet.
795      */
796     function serverEndGameConflict(
797         uint32 _roundId,
798         uint8 _gameType,
799         uint _num,
800         uint _value,
801         int _balance,
802         bytes32 _serverHash,
803         bytes32 _userHash,
804         uint _gameId,
805         address _contractAddress,
806         bytes memory _userSig,
807         address payable _userAddress,
808         bytes32 _serverSeed,
809         bytes32 _userSeed
810     )
811         public
812         onlyServer
813     {
814         verifySig(
815                 _roundId,
816                 _gameType,
817                 _num,
818                 _value,
819                 _balance,
820                 _serverHash,
821                 _userHash,
822                 _gameId,
823                 _contractAddress,
824                 _userSig,
825                 _userAddress
826         );
827 
828         serverEndGameConflictImpl(
829                 _roundId,
830                 _gameType,
831                 _num,
832                 _value,
833                 _balance,
834                 _serverHash,
835                 _userHash,
836                 _serverSeed,
837                 _userSeed,
838                 _gameId,
839                 _userAddress
840         );
841     }
842 
843     /**
844      * @notice Can be used by user if server does not answer to the end game session request.
845      * @param _roundId Round id of bet.
846      * @param _gameType Game type of bet.
847      * @param _num Number of bet.
848      * @param _value Value of bet.
849      * @param _balance Balance before this bet.
850      * @param _serverHash Hash of server seed for this bet.
851      * @param _userHash Hash of user seed for this bet.
852      * @param _gameId Game session id.
853      * @param _contractAddress Address of this contract.
854      * @param _serverSig Server signature of this bet.
855      * @param _userSeed User seed for this bet.
856      */
857     function userEndGameConflict(
858         uint32 _roundId,
859         uint8 _gameType,
860         uint _num,
861         uint _value,
862         int _balance,
863         bytes32 _serverHash,
864         bytes32 _userHash,
865         uint _gameId,
866         address _contractAddress,
867         bytes memory _serverSig,
868         bytes32 _userSeed
869     )
870         public
871     {
872         verifySig(
873             _roundId,
874             _gameType,
875             _num,
876             _value,
877             _balance,
878             _serverHash,
879             _userHash,
880             _gameId,
881             _contractAddress,
882             _serverSig,
883             serverAddress
884         );
885 
886         userEndGameConflictImpl(
887             _roundId,
888             _gameType,
889             _num,
890             _value,
891             _balance,
892             _userHash,
893             _userSeed,
894             _gameId,
895             msg.sender
896         );
897     }
898 
899     /**
900      * @notice Cancel active game without playing. Useful if server stops responding before
901      * one game is played.
902      * @param _gameId Game session id.
903      */
904     function userCancelActiveGame(uint _gameId) public {
905         address payable userAddress = msg.sender;
906         uint gameId = userGameId[userAddress];
907         Game storage game = gameIdGame[gameId];
908 
909         require(gameId == _gameId, "inv gameId");
910 
911         if (game.status == GameStatus.ACTIVE) {
912             game.endInitiatedTime = block.timestamp;
913             game.status = GameStatus.USER_INITIATED_END;
914 
915             emit LogUserRequestedEnd(msg.sender, gameId);
916         } else if (game.status == GameStatus.SERVER_INITIATED_END && game.roundId == 0) {
917             cancelActiveGame(game, gameId, userAddress);
918         } else {
919             revert();
920         }
921     }
922 
923     /**
924      * @dev Cancel active game without playing. Useful if user starts game session and
925      * does not play.
926      * @param _userAddress Users' address.
927      * @param _gameId Game session id.
928      */
929     function serverCancelActiveGame(address payable _userAddress, uint _gameId) public onlyServer {
930         uint gameId = userGameId[_userAddress];
931         Game storage game = gameIdGame[gameId];
932 
933         require(gameId == _gameId, "inv gameId");
934 
935         if (game.status == GameStatus.ACTIVE) {
936             game.endInitiatedTime = block.timestamp;
937             game.status = GameStatus.SERVER_INITIATED_END;
938 
939             emit LogServerRequestedEnd(msg.sender, gameId);
940         } else if (game.status == GameStatus.USER_INITIATED_END && game.roundId == 0) {
941             cancelActiveGame(game, gameId, _userAddress);
942         } else {
943             revert();
944         }
945     }
946 
947     /**
948     * @dev Force end of game if user does not respond. Only possible after a certain period of time
949     * to give the user a chance to respond.
950     * @param _userAddress User's address.
951     */
952     function serverForceGameEnd(address payable _userAddress, uint _gameId) public onlyServer {
953         uint gameId = userGameId[_userAddress];
954         Game storage game = gameIdGame[gameId];
955 
956         require(gameId == _gameId, "inv gameId");
957         require(game.status == GameStatus.SERVER_INITIATED_END, "inv status");
958 
959         // theoretically we have enough data to calculate winner
960         // but as user did not respond assume he has lost.
961         int newBalance = conflictRes.serverForceGameEnd(
962             game.gameType,
963             game.betNum,
964             game.betValue,
965             game.balance,
966             game.stake,
967             game.serverSeed,
968             game.userSeed,
969             game.endInitiatedTime
970         );
971 
972         closeGame(game, gameId, game.roundId, _userAddress, ReasonEnded.SERVER_FORCED_END, newBalance);
973     }
974 
975     /**
976     * @notice Force end of game if server does not respond. Only possible after a certain period of time
977     * to give the server a chance to respond.
978     */
979     function userForceGameEnd(uint _gameId) public {
980         address payable userAddress = msg.sender;
981         uint gameId = userGameId[userAddress];
982         Game storage game = gameIdGame[gameId];
983 
984         require(gameId == _gameId, "inv gameId");
985         require(game.status == GameStatus.USER_INITIATED_END, "inv status");
986 
987         int newBalance = conflictRes.userForceGameEnd(
988             game.gameType,
989             game.betNum,
990             game.betValue,
991             game.balance,
992             game.stake,
993             game.endInitiatedTime
994         );
995 
996         closeGame(game, gameId, game.roundId, userAddress, ReasonEnded.USER_FORCED_END, newBalance);
997     }
998 
999     /**
1000      * @dev Conflict handling implementation. Stores game data and timestamp if game
1001      * is active. If server has already marked conflict for game session the conflict
1002      * resolution contract is used (compare conflictRes).
1003      * @param _roundId Round id of bet.
1004      * @param _gameType Game type of bet.
1005      * @param _num Number of bet.
1006      * @param _value Value of bet.
1007      * @param _balance Balance before this bet.
1008      * @param _userHash Hash of user's seed for this bet.
1009      * @param _userSeed User's seed for this bet.
1010      * @param _gameId game Game session id.
1011      * @param _userAddress User's address.
1012      */
1013     function userEndGameConflictImpl(
1014         uint32 _roundId,
1015         uint8 _gameType,
1016         uint _num,
1017         uint _value,
1018         int _balance,
1019         bytes32 _userHash,
1020         bytes32 _userSeed,
1021         uint _gameId,
1022         address payable _userAddress
1023     )
1024         private
1025     {
1026         uint gameId = userGameId[_userAddress];
1027         Game storage game = gameIdGame[gameId];
1028         int maxBalance = conflictRes.maxBalance();
1029         int gameStake = game.stake;
1030 
1031         require(gameId == _gameId, "inv gameId");
1032         require(_roundId > 0, "inv roundId");
1033         require(keccak256(abi.encodePacked(_userSeed)) == _userHash, "inv userSeed");
1034         require(-gameStake <= _balance && _balance <= maxBalance, "inv balance"); // game.stake save to cast as uint128
1035         require(conflictRes.isValidBet(_gameType, _num, _value), "inv bet");
1036         require(gameStake.add(_balance).sub(_value.castToInt()) >= 0, "value too high"); // game.stake save to cast as uint128
1037 
1038         if (game.status == GameStatus.SERVER_INITIATED_END && game.roundId == _roundId) {
1039             game.userSeed = _userSeed;
1040             endGameConflict(game, gameId, _userAddress);
1041         } else if (game.status == GameStatus.ACTIVE
1042                 || (game.status == GameStatus.SERVER_INITIATED_END && game.roundId < _roundId)) {
1043             game.status = GameStatus.USER_INITIATED_END;
1044             game.endInitiatedTime = block.timestamp;
1045             game.roundId = _roundId;
1046             game.gameType = _gameType;
1047             game.betNum = _num;
1048             game.betValue = _value;
1049             game.balance = _balance;
1050             game.userSeed = _userSeed;
1051             game.serverSeed = bytes32(0);
1052 
1053             emit LogUserRequestedEnd(msg.sender, gameId);
1054         } else {
1055             revert("inv state");
1056         }
1057     }
1058 
1059     /**
1060      * @dev Conflict handling implementation. Stores game data and timestamp if game
1061      * is active. If user has already marked conflict for game session the conflict
1062      * resolution contract is used (compare conflictRes).
1063      * @param _roundId Round id of bet.
1064      * @param _gameType Game type of bet.
1065      * @param _num Number of bet.
1066      * @param _value Value of bet.
1067      * @param _balance Balance before this bet.
1068      * @param _serverHash Hash of server's seed for this bet.
1069      * @param _userHash Hash of user's seed for this bet.
1070      * @param _serverSeed Server's seed for this bet.
1071      * @param _userSeed User's seed for this bet.
1072      * @param _userAddress User's address.
1073      */
1074     function serverEndGameConflictImpl(
1075         uint32 _roundId,
1076         uint8 _gameType,
1077         uint _num,
1078         uint _value,
1079         int _balance,
1080         bytes32 _serverHash,
1081         bytes32 _userHash,
1082         bytes32 _serverSeed,
1083         bytes32 _userSeed,
1084         uint _gameId,
1085         address payable _userAddress
1086     )
1087         private
1088     {
1089         uint gameId = userGameId[_userAddress];
1090         Game storage game = gameIdGame[gameId];
1091         int maxBalance = conflictRes.maxBalance();
1092         int gameStake = game.stake;
1093 
1094         require(gameId == _gameId, "inv gameId");
1095         require(_roundId > 0, "inv roundId");
1096         require(keccak256(abi.encodePacked(_serverSeed)) == _serverHash, "inv serverSeed");
1097         require(keccak256(abi.encodePacked(_userSeed)) == _userHash, "inv userSeed");
1098         require(-gameStake <= _balance && _balance <= maxBalance, "inv balance"); // game.stake save to cast as uint128
1099         require(conflictRes.isValidBet(_gameType, _num, _value), "inv bet");
1100         require(gameStake.add(_balance).sub(_value.castToInt()) >= 0, "too high value"); // game.stake save to cast as uin128
1101 
1102         if (game.status == GameStatus.USER_INITIATED_END && game.roundId == _roundId) {
1103             game.serverSeed = _serverSeed;
1104             endGameConflict(game, gameId, _userAddress);
1105         } else if (game.status == GameStatus.ACTIVE
1106                 || (game.status == GameStatus.USER_INITIATED_END && game.roundId < _roundId)) {
1107             game.status = GameStatus.SERVER_INITIATED_END;
1108             game.endInitiatedTime = block.timestamp;
1109             game.roundId = _roundId;
1110             game.gameType = _gameType;
1111             game.betNum = _num;
1112             game.betValue = _value;
1113             game.balance = _balance;
1114             game.serverSeed = _serverSeed;
1115             game.userSeed = _userSeed;
1116 
1117             emit LogServerRequestedEnd(_userAddress, gameId);
1118         } else {
1119             revert("inv state");
1120         }
1121     }
1122 
1123     /**
1124      * @dev End conflicting game without placed bets.
1125      * @param _game Game session data.
1126      * @param _gameId Game session id.
1127      * @param _userAddress User's address.
1128      */
1129     function cancelActiveGame(Game storage _game, uint _gameId, address payable _userAddress) private {
1130         // user need to pay a fee when conflict ended.
1131         // this ensures a malicious, rich user can not just generate game sessions and then wait
1132         // for us to end the game session and then confirm the session status, so
1133         // we would have to pay a high gas fee without profit.
1134         int newBalance = -conflictRes.conflictEndFine();
1135 
1136         // do not allow balance below user stake
1137         int stake = _game.stake;
1138         if (newBalance < -stake) {
1139             newBalance = -stake;
1140         }
1141         closeGame(_game, _gameId, 0, _userAddress, ReasonEnded.CONFLICT_ENDED, newBalance);
1142     }
1143 
1144     /**
1145      * @dev End conflicting game.
1146      * @param _game Game session data.
1147      * @param _gameId Game session id.
1148      * @param _userAddress User's address.
1149      */
1150     function endGameConflict(Game storage _game, uint _gameId, address payable _userAddress) private {
1151         int newBalance = conflictRes.endGameConflict(
1152             _game.gameType,
1153             _game.betNum,
1154             _game.betValue,
1155             _game.balance,
1156             _game.stake,
1157             _game.serverSeed,
1158             _game.userSeed
1159         );
1160 
1161         closeGame(_game, _gameId, _game.roundId, _userAddress, ReasonEnded.CONFLICT_ENDED, newBalance);
1162     }
1163 }
1164 
1165 contract GameChannel is GameChannelConflict {
1166     /**
1167      * @dev contract constructor
1168      * @param _serverAddress Server address.
1169      * @param _minStake Min value user needs to deposit to create game session.
1170      * @param _maxStake Max value user can deposit to create game session.
1171      * @param _conflictResAddress Conflict resolution contract address.
1172      * @param _houseAddress House address to move profit to.
1173      * @param _chainId Chain id for signature domain.
1174      */
1175     constructor(
1176         address _serverAddress,
1177         uint128 _minStake,
1178         uint128 _maxStake,
1179         address _conflictResAddress,
1180         address payable _houseAddress,
1181         uint _chainId
1182     )
1183         public
1184         GameChannelConflict(_serverAddress, _minStake, _maxStake, _conflictResAddress, _houseAddress, _chainId)
1185     {
1186         // nothing to do
1187     }
1188 
1189     /**
1190      * @notice Create games session request. msg.value needs to be valid stake value.
1191      * @param _userEndHash Last entry of users' hash chain.
1192      * @param _previousGameId User's previous game id, initial 0.
1193      * @param _createBefore Game can be only created before this timestamp.
1194      * @param _serverEndHash Last entry of server's hash chain.
1195      * @param _serverSig Server signature. See verifyCreateSig
1196      */
1197     function createGame(
1198         bytes32 _userEndHash,
1199         uint _previousGameId,
1200         uint _createBefore,
1201         bytes32 _serverEndHash,
1202         bytes memory _serverSig
1203     )
1204         public
1205         payable
1206         onlyValidValue
1207         onlyValidHouseStake(activeGames + 1)
1208         onlyNotPaused
1209     {
1210         uint previousGameId = userGameId[msg.sender];
1211         Game storage game = gameIdGame[previousGameId];
1212 
1213         require(game.status == GameStatus.ENDED, "prev game not ended");
1214         require(previousGameId == _previousGameId, "inv gamePrevGameId");
1215         require(block.timestamp < _createBefore, "expired");
1216 
1217         verifyCreateSig(msg.sender, _previousGameId, _createBefore, _serverEndHash, _serverSig);
1218 
1219         uint gameId = gameIdCntr++;
1220         userGameId[msg.sender] = gameId;
1221         Game storage newGame = gameIdGame[gameId];
1222 
1223         newGame.stake = uint128(msg.value); // It's safe to cast msg.value as it is limited, see onlyValidValue
1224         newGame.status = GameStatus.ACTIVE;
1225 
1226         activeGames = activeGames.add(1);
1227 
1228         // It's safe to cast msg.value as it is limited, see onlyValidValue
1229         emit LogGameCreated(msg.sender, gameId, uint128(msg.value), _serverEndHash,  _userEndHash);
1230     }
1231 
1232 
1233     /**
1234      * @dev Regular end game session. Used if user and house have both
1235      * accepted current game session state.
1236      * The game session with gameId _gameId is closed
1237      * and the user paid out. This functions is called by the server after
1238      * the user requested the termination of the current game session.
1239      * @param _roundId Round id of bet.
1240      * @param _balance Current balance.
1241      * @param _serverHash Hash of server's seed for this bet.
1242      * @param _userHash Hash of user's seed for this bet.
1243      * @param _gameId Game session id.
1244      * @param _contractAddress Address of this contract.
1245      * @param _userAddress Address of user.
1246      * @param _userSig User's signature of this bet.
1247      */
1248     function serverEndGame(
1249         uint32 _roundId,
1250         int _balance,
1251         bytes32 _serverHash,
1252         bytes32 _userHash,
1253         uint _gameId,
1254         address _contractAddress,
1255         address payable _userAddress,
1256         bytes memory _userSig
1257     )
1258         public
1259         onlyServer
1260     {
1261         verifySig(
1262                 _roundId,
1263                 0,
1264                 0,
1265                 0,
1266                 _balance,
1267                 _serverHash,
1268                 _userHash,
1269                 _gameId,
1270                 _contractAddress,
1271                 _userSig,
1272                 _userAddress
1273         );
1274 
1275         regularEndGame(_userAddress, _roundId, _balance, _gameId, _contractAddress);
1276     }
1277 
1278     /**
1279      * @notice Regular end game session. Normally not needed as server ends game (@see serverEndGame).
1280      * Can be used by user if server does not end game session.
1281      * @param _roundId Round id of bet.
1282      * @param _balance Current balance.
1283      * @param _serverHash Hash of server's seed for this bet.
1284      * @param _userHash Hash of user's seed for this bet.
1285      * @param _gameId Game session id.
1286      * @param _contractAddress Address of this contract.
1287      * @param _serverSig Server's signature of this bet.
1288      */
1289     function userEndGame(
1290         uint32 _roundId,
1291         int _balance,
1292         bytes32 _serverHash,
1293         bytes32 _userHash,
1294         uint _gameId,
1295         address _contractAddress,
1296         bytes memory _serverSig
1297     )
1298         public
1299     {
1300         verifySig(
1301                 _roundId,
1302                 0,
1303                 0,
1304                 0,
1305                 _balance,
1306                 _serverHash,
1307                 _userHash,
1308                 _gameId,
1309                 _contractAddress,
1310                 _serverSig,
1311                 serverAddress
1312         );
1313 
1314         regularEndGame(msg.sender, _roundId, _balance, _gameId, _contractAddress);
1315     }
1316 
1317     /**
1318      * @dev Verify server signature.
1319      * @param _userAddress User's address.
1320      * @param _previousGameId User's previous game id, initial 0.
1321      * @param _createBefore Game can be only created before this timestamp.
1322      * @param _serverEndHash Last entry of server's hash chain.
1323      * @param _serverSig Server signature.
1324      */
1325     function verifyCreateSig(
1326         address _userAddress,
1327         uint _previousGameId,
1328         uint _createBefore,
1329         bytes32 _serverEndHash,
1330         bytes memory _serverSig
1331     )
1332         private view
1333     {
1334         address contractAddress = address(this);
1335         bytes32 hash = keccak256(abi.encodePacked(
1336             contractAddress, _userAddress, _previousGameId, _createBefore, _serverEndHash
1337         ));
1338 
1339         verify(hash, _serverSig, serverAddress);
1340     }
1341 
1342     /**
1343      * @dev Regular end game session implementation. Used if user and house have both
1344      * accepted current game session state. The game session with gameId _gameId is closed
1345      * and the user paid out.
1346      * @param _userAddress Address of user.
1347      * @param _balance Current balance.
1348      * @param _gameId Game session id.
1349      * @param _contractAddress Address of this contract.
1350      */
1351     function regularEndGame(
1352         address payable _userAddress,
1353         uint32 _roundId,
1354         int _balance,
1355         uint _gameId,
1356         address _contractAddress
1357     )
1358         private
1359     {
1360         uint gameId = userGameId[_userAddress];
1361         Game storage game = gameIdGame[gameId];
1362         int maxBalance = conflictRes.maxBalance();
1363         int gameStake = game.stake;
1364 
1365         require(_gameId == gameId, "inv gameId");
1366         require(_roundId > 0, "inv roundId");
1367         // save to cast as game.stake hash fixed range
1368         require(-gameStake <= _balance && _balance <= maxBalance, "inv balance");
1369         require(game.status == GameStatus.ACTIVE, "inv status");
1370 
1371         assert(_contractAddress == address(this));
1372 
1373         closeGame(game, gameId, _roundId, _userAddress, ReasonEnded.REGULAR_ENDED, _balance);
1374     }
1375 }
1376 
1377 library SafeCast {
1378     /**
1379      * Cast unsigned a to signed a.
1380      */
1381     function castToInt(uint a) internal pure returns(int) {
1382         assert(a < (1 << 255));
1383         return int(a);
1384     }
1385 
1386     /**
1387      * Cast signed a to unsigned a.
1388      */
1389     function castToUint(int a) internal pure returns(uint) {
1390         assert(a >= 0);
1391         return uint(a);
1392     }
1393 }
1394 
1395 library SafeMath {
1396 
1397     /**
1398     * @dev Multiplies two unsigned integers, throws on overflow.
1399     */
1400     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1401         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1402         // benefit is lost if 'b' is also tested.
1403         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1404         if (a == 0) {
1405             return 0;
1406         }
1407 
1408         c = a * b;
1409         assert(c / a == b);
1410         return c;
1411     }
1412 
1413     /**
1414     * @dev Multiplies two signed integers, throws on overflow.
1415     */
1416     function mul(int256 a, int256 b) internal pure returns (int256) {
1417         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1418         // benefit is lost if 'b' is also tested.
1419         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1420         if (a == 0) {
1421             return 0;
1422         }
1423         int256 c = a * b;
1424         assert(c / a == b);
1425         return c;
1426     }
1427 
1428     /**
1429     * @dev Integer division of two unsigned integers, truncating the quotient.
1430     */
1431     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1432         // assert(b > 0); // Solidity automatically throws when dividing by 0
1433         // uint256 c = a / b;
1434         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1435         return a / b;
1436     }
1437 
1438     /**
1439     * @dev Integer division of two signed integers, truncating the quotient.
1440     */
1441     function div(int256 a, int256 b) internal pure returns (int256) {
1442         // assert(b > 0); // Solidity automatically throws when dividing by 0
1443         // Overflow only happens when the smallest negative int is multiplied by -1.
1444         int256 INT256_MIN = int256((uint256(1) << 255));
1445         assert(a != INT256_MIN || b != - 1);
1446         return a / b;
1447     }
1448 
1449     /**
1450     * @dev Subtracts two unsigned integers, throws on overflow (i.e. if subtrahend is greater than minuend).
1451     */
1452     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1453         assert(b <= a);
1454         return a - b;
1455     }
1456 
1457     /**
1458     * @dev Subtracts two signed integers, throws on overflow.
1459     */
1460     function sub(int256 a, int256 b) internal pure returns (int256) {
1461         int256 c = a - b;
1462         assert((b >= 0 && c <= a) || (b < 0 && c > a));
1463         return c;
1464     }
1465 
1466     /**
1467     * @dev Adds two unsigned integers, throws on overflow.
1468     */
1469     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1470         c = a + b;
1471         assert(c >= a);
1472         return c;
1473     }
1474 
1475     /**
1476     * @dev Adds two signed integers, throws on overflow.
1477     */
1478     function add(int256 a, int256 b) internal pure returns (int256) {
1479         int256 c = a + b;
1480         assert((b >= 0 && c >= a) || (b < 0 && c < a));
1481         return c;
1482     }
1483 }