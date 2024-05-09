1 pragma solidity ^0.4.24;
2 
3 interface ConflictResolutionInterface {
4     function minHouseStake(uint activeGames) external pure returns(uint);
5 
6     function maxBalance() external pure returns(int);
7 
8     function isValidBet(uint8 _gameType, uint _betNum, uint _betValue) external pure returns(bool);
9 
10     function endGameConflict(
11         uint8 _gameType,
12         uint _betNum,
13         uint _betValue,
14         int _balance,
15         uint _stake,
16         bytes32 _serverSeed,
17         bytes32 _playerSeed
18     )
19         external
20         view
21         returns(int);
22 
23     function serverForceGameEnd(
24         uint8 gameType,
25         uint _betNum,
26         uint _betValue,
27         int _balance,
28         uint _stake,
29         uint _endInitiatedTime
30     )
31         external
32         view
33         returns(int);
34 
35     function playerForceGameEnd(
36         uint8 _gameType,
37         uint _betNum,
38         uint _betValue,
39         int _balance,
40         uint _stake,
41         uint _endInitiatedTime
42     )
43         external
44         view
45         returns(int);
46 }
47 
48 library MathUtil {
49     /**
50      * @dev Returns the absolute value of _val.
51      * @param _val value
52      * @return The absolute value of _val.
53      */
54     function abs(int _val) internal pure returns(uint) {
55         if (_val < 0) {
56             return uint(-_val);
57         } else {
58             return uint(_val);
59         }
60     }
61 
62     /**
63      * @dev Calculate maximum.
64      */
65     function max(uint _val1, uint _val2) internal pure returns(uint) {
66         return _val1 >= _val2 ? _val1 : _val2;
67     }
68 
69     /**
70      * @dev Calculate minimum.
71      */
72     function min(uint _val1, uint _val2) internal pure returns(uint) {
73         return _val1 <= _val2 ? _val1 : _val2;
74     }
75 }
76 
77 contract Ownable {
78     address public owner;
79     address public pendingOwner;
80 
81     event LogOwnerShipTransferred(address indexed previousOwner, address indexed newOwner);
82     event LogOwnerShipTransferInitiated(address indexed previousOwner, address indexed newOwner);
83 
84     /**
85      * @dev Modifier, which throws if called by other account than owner.
86      */
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     /**
93      * @dev Modifier throws if called by any account other than the pendingOwner.
94      */
95     modifier onlyPendingOwner() {
96         require(msg.sender == pendingOwner);
97         _;
98     }
99 
100     /**
101      * @dev Set contract creator as initial owner
102      */
103     constructor() public {
104         owner = msg.sender;
105         pendingOwner = address(0);
106     }
107 
108     /**
109      * @dev Allows the current owner to set the pendingOwner address.
110      * @param _newOwner The address to transfer ownership to.
111      */
112     function transferOwnership(address _newOwner) public onlyOwner {
113         pendingOwner = _newOwner;
114         emit LogOwnerShipTransferInitiated(owner, _newOwner);
115     }
116 
117     /**
118      * @dev New owner can accpet ownership.
119      */
120     function claimOwnership() public onlyPendingOwner {
121         emit LogOwnerShipTransferred(owner, pendingOwner);
122         owner = pendingOwner;
123         pendingOwner = address(0);
124     }
125 }
126 
127 contract ConflictResolutionManager is Ownable {
128     /// @dev Conflict resolution contract.
129     ConflictResolutionInterface public conflictRes;
130 
131     /// @dev New Conflict resolution contract.
132     address public newConflictRes = 0;
133 
134     /// @dev Time update of new conflict resolution contract was initiated.
135     uint public updateTime = 0;
136 
137     /// @dev Min time before new conflict res contract can be activated after initiating update.
138     uint public constant MIN_TIMEOUT = 3 days;
139 
140     /// @dev Min time before new conflict res contract can be activated after initiating update.
141     uint public constant MAX_TIMEOUT = 6 days;
142 
143     /// @dev Update of conflict resolution contract was initiated.
144     event LogUpdatingConflictResolution(address newConflictResolutionAddress);
145 
146     /// @dev New conflict resolution contract is active.
147     event LogUpdatedConflictResolution(address newConflictResolutionAddress);
148 
149     /**
150      * @dev Constructor
151      * @param _conflictResAddress conflict resolution contract address.
152      */
153     constructor(address _conflictResAddress) public {
154         conflictRes = ConflictResolutionInterface(_conflictResAddress);
155     }
156 
157     /**
158      * @dev Initiate conflict resolution contract update.
159      * @param _newConflictResAddress New conflict resolution contract address.
160      */
161     function updateConflictResolution(address _newConflictResAddress) public onlyOwner {
162         newConflictRes = _newConflictResAddress;
163         updateTime = block.timestamp;
164 
165         emit LogUpdatingConflictResolution(_newConflictResAddress);
166     }
167 
168     /**
169      * @dev Active new conflict resolution contract.
170      */
171     function activateConflictResolution() public onlyOwner {
172         require(newConflictRes != 0);
173         require(updateTime != 0);
174         require(updateTime + MIN_TIMEOUT <= block.timestamp && block.timestamp <= updateTime + MAX_TIMEOUT);
175 
176         conflictRes = ConflictResolutionInterface(newConflictRes);
177         newConflictRes = 0;
178         updateTime = 0;
179 
180         emit LogUpdatedConflictResolution(newConflictRes);
181     }
182 }
183 
184 contract Pausable is Ownable {
185     /// @dev Is contract paused.
186     bool public paused = false;
187 
188     /// @dev Time pause was called
189     uint public timePaused = 0;
190 
191     /// @dev Modifier, which only allows function execution if not paused.
192     modifier onlyNotPaused() {
193         require(!paused);
194         _;
195     }
196 
197     /// @dev Modifier, which only allows function execution if paused.
198     modifier onlyPaused() {
199         require(paused);
200         _;
201     }
202 
203     /// @dev Modifier, which only allows function execution if paused longer than timeSpan.
204     modifier onlyPausedSince(uint timeSpan) {
205         require(paused && timePaused + timeSpan <= block.timestamp);
206         _;
207     }
208 
209     /// @dev Event is fired if paused.
210     event LogPause();
211 
212     /// @dev Event is fired if pause is ended.
213     event LogUnpause();
214 
215     /**
216      * @dev Pause contract. No new game sessions can be created.
217      */
218     function pause() public onlyOwner onlyNotPaused {
219         paused = true;
220         timePaused = block.timestamp;
221         emit LogPause();
222     }
223 
224     /**
225      * @dev Unpause contract.
226      */
227     function unpause() public onlyOwner onlyPaused {
228         paused = false;
229         timePaused = 0;
230         emit LogUnpause();
231     }
232 }
233 
234 contract Destroyable is Pausable {
235     /// @dev After pausing the contract for 20 days owner can selfdestruct it.
236     uint public constant TIMEOUT_DESTROY = 20 days;
237 
238     /**
239      * @dev Destroy contract and transfer ether to address _targetAddress.
240      */
241     function destroy() public onlyOwner onlyPausedSince(TIMEOUT_DESTROY) {
242         selfdestruct(owner);
243     }
244 }
245 
246 contract GameChannelBase is Destroyable, ConflictResolutionManager {
247     /// @dev Different game session states.
248     enum GameStatus {
249         ENDED, ///< @dev Game session is ended.
250         ACTIVE, ///< @dev Game session is active.
251         PLAYER_INITIATED_END, ///< @dev Player initiated non regular end.
252         SERVER_INITIATED_END ///< @dev Server initiated non regular end.
253     }
254 
255     /// @dev Reason game session ended.
256     enum ReasonEnded {
257         REGULAR_ENDED, ///< @dev Game session is regularly ended.
258         END_FORCED_BY_SERVER, ///< @dev Player did not respond. Server forced end.
259         END_FORCED_BY_PLAYER ///< @dev Server did not respond. Player forced end.
260     }
261 
262     struct Game {
263         /// @dev Game session status.
264         GameStatus status;
265 
266         /// @dev Player's stake.
267         uint128 stake;
268 
269         /// @dev Last game round info if not regularly ended.
270         /// If game session is ended normally this data is not used.
271         uint8 gameType;
272         uint32 roundId;
273         uint16 betNum;
274         uint betValue;
275         int balance;
276         bytes32 playerSeed;
277         bytes32 serverSeed;
278         uint endInitiatedTime;
279     }
280 
281     /// @dev Minimal time span between profit transfer.
282     uint public constant MIN_TRANSFER_TIMESPAN = 1 days;
283 
284     /// @dev Maximal time span between profit transfer.
285     uint public constant MAX_TRANSFER_TIMSPAN = 6 * 30 days;
286 
287     bytes32 public constant TYPE_HASH = keccak256(abi.encodePacked(
288         "uint32 Round Id",
289         "uint8 Game Type",
290         "uint16 Number",
291         "uint Value (Wei)",
292         "int Current Balance (Wei)",
293         "bytes32 Server Hash",
294         "bytes32 Player Hash",
295         "uint Game Id",
296         "address Contract Address"
297      ));
298 
299     /// @dev Current active game sessions.
300     uint public activeGames = 0;
301 
302     /// @dev Game session id counter. Points to next free game session slot. So gameIdCntr -1 is the
303     // number of game sessions created.
304     uint public gameIdCntr;
305 
306     /// @dev Only this address can accept and end games.
307     address public serverAddress;
308 
309     /// @dev Address to transfer profit to.
310     address public houseAddress;
311 
312     /// @dev Current house stake.
313     uint public houseStake = 0;
314 
315     /// @dev House profit since last profit transfer.
316     int public houseProfit = 0;
317 
318     /// @dev Min value player needs to deposit for creating game session.
319     uint128 public minStake;
320 
321     /// @dev Max value player can deposit for creating game session.
322     uint128 public maxStake;
323 
324     /// @dev Timeout until next profit transfer is allowed.
325     uint public profitTransferTimeSpan = 14 days;
326 
327     /// @dev Last time profit transferred to house.
328     uint public lastProfitTransferTimestamp;
329 
330     /// @dev Maps gameId to game struct.
331     mapping (uint => Game) public gameIdGame;
332 
333     /// @dev Maps player address to current player game id.
334     mapping (address => uint) public playerGameId;
335 
336     /// @dev Maps player address to pending returns.
337     mapping (address => uint) public pendingReturns;
338 
339     /// @dev Modifier, which only allows to execute if house stake is high enough.
340     modifier onlyValidHouseStake(uint _activeGames) {
341         uint minHouseStake = conflictRes.minHouseStake(_activeGames);
342         require(houseStake >= minHouseStake);
343         _;
344     }
345 
346     /// @dev Modifier to check if value send fulfills player stake requirements.
347     modifier onlyValidValue() {
348         require(minStake <= msg.value && msg.value <= maxStake);
349         _;
350     }
351 
352     /// @dev Modifier, which only allows server to call function.
353     modifier onlyServer() {
354         require(msg.sender == serverAddress);
355         _;
356     }
357 
358     /// @dev Modifier, which only allows to set valid transfer timeouts.
359     modifier onlyValidTransferTimeSpan(uint transferTimeout) {
360         require(transferTimeout >= MIN_TRANSFER_TIMESPAN
361                 && transferTimeout <= MAX_TRANSFER_TIMSPAN);
362         _;
363     }
364 
365     /// @dev This event is fired when player creates game session.
366     event LogGameCreated(address indexed player, uint indexed gameId, uint128 stake, bytes32 indexed serverEndHash, bytes32 playerEndHash);
367 
368     /// @dev This event is fired when player requests conflict end.
369     event LogPlayerRequestedEnd(address indexed player, uint indexed gameId);
370 
371     /// @dev This event is fired when server requests conflict end.
372     event LogServerRequestedEnd(address indexed player, uint indexed gameId);
373 
374     /// @dev This event is fired when game session is ended.
375     event LogGameEnded(address indexed player, uint indexed gameId, uint32 roundId, int balance, ReasonEnded reason);
376 
377     /// @dev this event is fired when owner modifies player's stake limits.
378     event LogStakeLimitsModified(uint minStake, uint maxStake);
379 
380     /**
381      * @dev Contract constructor.
382      * @param _serverAddress Server address.
383      * @param _minStake Min value player needs to deposit to create game session.
384      * @param _maxStake Max value player can deposit to create game session.
385      * @param _conflictResAddress Conflict resolution contract address.
386      * @param _houseAddress House address to move profit to.
387      */
388     constructor(
389         address _serverAddress,
390         uint128 _minStake,
391         uint128 _maxStake,
392         address _conflictResAddress,
393         address _houseAddress,
394         uint _gameIdCntr
395     )
396         public
397         ConflictResolutionManager(_conflictResAddress)
398     {
399         require(_minStake > 0 && _minStake <= _maxStake);
400         require(_gameIdCntr > 0);
401 
402         gameIdCntr = _gameIdCntr;
403         serverAddress = _serverAddress;
404         houseAddress = _houseAddress;
405         lastProfitTransferTimestamp = block.timestamp;
406         minStake = _minStake;
407         maxStake = _maxStake;
408     }
409 
410     /**
411      * @notice Withdraw pending returns.
412      */
413     function withdraw() public {
414         uint toTransfer = pendingReturns[msg.sender];
415         require(toTransfer > 0);
416 
417         pendingReturns[msg.sender] = 0;
418         msg.sender.transfer(toTransfer);
419     }
420 
421     /**
422      * @notice Transfer house profit to houseAddress.
423      */
424     function transferProfitToHouse() public {
425         require(lastProfitTransferTimestamp + profitTransferTimeSpan <= block.timestamp);
426 
427         // update last transfer timestamp
428         lastProfitTransferTimestamp = block.timestamp;
429 
430         if (houseProfit <= 0) {
431             // no profit to transfer
432             return;
433         }
434 
435         // houseProfit is gt 0 => safe to cast
436         uint toTransfer = uint(houseProfit);
437         assert(houseStake >= toTransfer);
438 
439         houseProfit = 0;
440         houseStake = houseStake - toTransfer;
441 
442         houseAddress.transfer(toTransfer);
443     }
444 
445     /**
446      * @dev Set profit transfer time span.
447      */
448     function setProfitTransferTimeSpan(uint _profitTransferTimeSpan)
449         public
450         onlyOwner
451         onlyValidTransferTimeSpan(_profitTransferTimeSpan)
452     {
453         profitTransferTimeSpan = _profitTransferTimeSpan;
454     }
455 
456     /**
457      * @dev Increase house stake by msg.value
458      */
459     function addHouseStake() public payable onlyOwner {
460         houseStake += msg.value;
461     }
462 
463     /**
464      * @dev Withdraw house stake.
465      */
466     function withdrawHouseStake(uint value) public onlyOwner {
467         uint minHouseStake = conflictRes.minHouseStake(activeGames);
468 
469         require(value <= houseStake && houseStake - value >= minHouseStake);
470         require(houseProfit <= 0 || uint(houseProfit) <= houseStake - value);
471 
472         houseStake = houseStake - value;
473         owner.transfer(value);
474     }
475 
476     /**
477      * @dev Withdraw house stake and profit.
478      */
479     function withdrawAll() public onlyOwner onlyPausedSince(3 days) {
480         houseProfit = 0;
481         uint toTransfer = houseStake;
482         houseStake = 0;
483         owner.transfer(toTransfer);
484     }
485 
486     /**
487      * @dev Set new house address.
488      * @param _houseAddress New house address.
489      */
490     function setHouseAddress(address _houseAddress) public onlyOwner {
491         houseAddress = _houseAddress;
492     }
493 
494     /**
495      * @dev Set stake min and max value.
496      * @param _minStake Min stake.
497      * @param _maxStake Max stake.
498      */
499     function setStakeRequirements(uint128 _minStake, uint128 _maxStake) public onlyOwner {
500         require(_minStake > 0 && _minStake <= _maxStake);
501         minStake = _minStake;
502         maxStake = _maxStake;
503         emit LogStakeLimitsModified(minStake, maxStake);
504     }
505 
506     /**
507      * @dev Close game session.
508      * @param _game Game session data.
509      * @param _gameId Id of game session.
510      * @param _playerAddress Player's address of game session.
511      * @param _reason Reason for closing game session.
512      * @param _balance Game session balance.
513      */
514     function closeGame(
515         Game storage _game,
516         uint _gameId,
517         uint32 _roundId,
518         address _playerAddress,
519         ReasonEnded _reason,
520         int _balance
521     )
522         internal
523     {
524         _game.status = GameStatus.ENDED;
525 
526         assert(activeGames > 0);
527         activeGames = activeGames - 1;
528 
529         payOut(_playerAddress, _game.stake, _balance);
530 
531         emit LogGameEnded(_playerAddress, _gameId, _roundId, _balance, _reason);
532     }
533 
534     /**
535      * @dev End game by paying out player and server.
536      * @param _playerAddress Player's address.
537      * @param _stake Player's stake.
538      * @param _balance Player's balance.
539      */
540     function payOut(address _playerAddress, uint128 _stake, int _balance) internal {
541         assert(_balance <= conflictRes.maxBalance());
542         assert((int(_stake) + _balance) >= 0); // safe as _balance (see line above), _stake ranges are fixed.
543 
544         uint valuePlayer = uint(int(_stake) + _balance); // safe as _balance, _stake ranges are fixed.
545 
546         if (_balance > 0 && int(houseStake) < _balance) { // safe to cast houseStake is limited.
547             // Should never happen!
548             // House is bankrupt.
549             // Payout left money.
550             valuePlayer = houseStake;
551         }
552 
553         houseProfit = houseProfit - _balance;
554 
555         int newHouseStake = int(houseStake) - _balance; // safe to cast and sub as houseStake, balance ranges are fixed
556         assert(newHouseStake >= 0);
557         houseStake = uint(newHouseStake);
558 
559         pendingReturns[_playerAddress] += valuePlayer;
560         if (pendingReturns[_playerAddress] > 0) {
561             safeSend(_playerAddress);
562         }
563     }
564 
565     /**
566      * @dev Send value of pendingReturns[_address] to _address.
567      * @param _address Address to send value to.
568      */
569     function safeSend(address _address) internal {
570         uint valueToSend = pendingReturns[_address];
571         assert(valueToSend > 0);
572 
573         pendingReturns[_address] = 0;
574         if (_address.send(valueToSend) == false) {
575             pendingReturns[_address] = valueToSend;
576         }
577     }
578 
579     /**
580      * @dev Verify signature of given data. Throws on verification failure.
581      * @param _sig Signature of given data in the form of rsv.
582      * @param _address Address of signature signer.
583      */
584     function verifySig(
585         uint32 _roundId,
586         uint8 _gameType,
587         uint16 _num,
588         uint _value,
589         int _balance,
590         bytes32 _serverHash,
591         bytes32 _playerHash,
592         uint _gameId,
593         address _contractAddress,
594         bytes _sig,
595         address _address
596     )
597         internal
598         view
599     {
600         // check if this is the correct contract
601         address contractAddress = this;
602         require(_contractAddress == contractAddress);
603 
604         bytes32 roundHash = calcHash(
605                 _roundId,
606                 _gameType,
607                 _num,
608                 _value,
609                 _balance,
610                 _serverHash,
611                 _playerHash,
612                 _gameId,
613                 _contractAddress
614         );
615 
616         verify(
617                 roundHash,
618                 _sig,
619                 _address
620         );
621     }
622 
623      /**
624      * @dev Check if _sig is valid signature of _hash. Throws if invalid signature.
625      * @param _hash Hash to check signature of.
626      * @param _sig Signature of _hash.
627      * @param _address Address of signer.
628      */
629     function verify(
630         bytes32 _hash,
631         bytes _sig,
632         address _address
633     )
634         internal
635         pure
636     {
637         bytes32 r;
638         bytes32 s;
639         uint8 v;
640 
641         (r, s, v) = signatureSplit(_sig);
642         address addressRecover = ecrecover(_hash, v, r, s);
643         require(addressRecover == _address);
644     }
645 
646     /**
647      * @dev Calculate typed hash of given data (compare eth_signTypedData).
648      * @return Hash of given data.
649      */
650     function calcHash(
651         uint32 _roundId,
652         uint8 _gameType,
653         uint16 _num,
654         uint _value,
655         int _balance,
656         bytes32 _serverHash,
657         bytes32 _playerHash,
658         uint _gameId,
659         address _contractAddress
660     )
661         private
662         pure
663         returns(bytes32)
664     {
665         bytes32 dataHash = keccak256(abi.encodePacked(
666             _roundId,
667             _gameType,
668             _num,
669             _value,
670             _balance,
671             _serverHash,
672             _playerHash,
673             _gameId,
674             _contractAddress
675         ));
676 
677         return keccak256(abi.encodePacked(
678             TYPE_HASH,
679             dataHash
680         ));
681     }
682 
683     /**
684      * @dev Split the given signature of the form rsv in r s v. v is incremented with 27 if
685      * it is below 2.
686      * @param _signature Signature to split.
687      * @return r s v
688      */
689     function signatureSplit(bytes _signature)
690         private
691         pure
692         returns (bytes32 r, bytes32 s, uint8 v)
693     {
694         require(_signature.length == 65);
695 
696         assembly {
697             r := mload(add(_signature, 32))
698             s := mload(add(_signature, 64))
699             v := and(mload(add(_signature, 65)), 0xff)
700         }
701         if (v < 2) {
702             v = v + 27;
703         }
704     }
705 }
706 
707 contract GameChannelConflict is GameChannelBase {
708     /**
709      * @dev Contract constructor.
710      * @param _serverAddress Server address.
711      * @param _minStake Min value player needs to deposit to create game session.
712      * @param _maxStake Max value player can deposit to create game session.
713      * @param _conflictResAddress Conflict resolution contract address
714      * @param _houseAddress House address to move profit to
715      */
716     constructor(
717         address _serverAddress,
718         uint128 _minStake,
719         uint128 _maxStake,
720         address _conflictResAddress,
721         address _houseAddress,
722         uint _gameIdCtr
723     )
724         public
725         GameChannelBase(_serverAddress, _minStake, _maxStake, _conflictResAddress, _houseAddress, _gameIdCtr)
726     {
727         // nothing to do
728     }
729 
730     /**
731      * @dev Used by server if player does not end game session.
732      * @param _roundId Round id of bet.
733      * @param _gameType Game type of bet.
734      * @param _num Number of bet.
735      * @param _value Value of bet.
736      * @param _balance Balance before this bet.
737      * @param _serverHash Hash of server seed for this bet.
738      * @param _playerHash Hash of player seed for this bet.
739      * @param _gameId Game session id.
740      * @param _contractAddress Address of this contract.
741      * @param _playerSig Player signature of this bet.
742      * @param _playerAddress Address of player.
743      * @param _serverSeed Server seed for this bet.
744      * @param _playerSeed Player seed for this bet.
745      */
746     function serverEndGameConflict(
747         uint32 _roundId,
748         uint8 _gameType,
749         uint16 _num,
750         uint _value,
751         int _balance,
752         bytes32 _serverHash,
753         bytes32 _playerHash,
754         uint _gameId,
755         address _contractAddress,
756         bytes _playerSig,
757         address _playerAddress,
758         bytes32 _serverSeed,
759         bytes32 _playerSeed
760     )
761         public
762         onlyServer
763     {
764         verifySig(
765                 _roundId,
766                 _gameType,
767                 _num,
768                 _value,
769                 _balance,
770                 _serverHash,
771                 _playerHash,
772                 _gameId,
773                 _contractAddress,
774                 _playerSig,
775                 _playerAddress
776         );
777 
778         serverEndGameConflictImpl(
779                 _roundId,
780                 _gameType,
781                 _num,
782                 _value,
783                 _balance,
784                 _serverHash,
785                 _playerHash,
786                 _serverSeed,
787                 _playerSeed,
788                 _gameId,
789                 _playerAddress
790         );
791     }
792 
793     /**
794      * @notice Can be used by player if server does not answer to the end game session request.
795      * @param _roundId Round id of bet.
796      * @param _gameType Game type of bet.
797      * @param _num Number of bet.
798      * @param _value Value of bet.
799      * @param _balance Balance before this bet.
800      * @param _serverHash Hash of server seed for this bet.
801      * @param _playerHash Hash of player seed for this bet.
802      * @param _gameId Game session id.
803      * @param _contractAddress Address of this contract.
804      * @param _serverSig Server signature of this bet.
805      * @param _playerSeed Player seed for this bet.
806      */
807     function playerEndGameConflict(
808         uint32 _roundId,
809         uint8 _gameType,
810         uint16 _num,
811         uint _value,
812         int _balance,
813         bytes32 _serverHash,
814         bytes32 _playerHash,
815         uint _gameId,
816         address _contractAddress,
817         bytes _serverSig,
818         bytes32 _playerSeed
819     )
820         public
821     {
822         verifySig(
823             _roundId,
824             _gameType,
825             _num,
826             _value,
827             _balance,
828             _serverHash,
829             _playerHash,
830             _gameId,
831             _contractAddress,
832             _serverSig,
833             serverAddress
834         );
835 
836         playerEndGameConflictImpl(
837             _roundId,
838             _gameType,
839             _num,
840             _value,
841             _balance,
842             _playerHash,
843             _playerSeed,
844             _gameId,
845             msg.sender
846         );
847     }
848 
849     /**
850      * @notice Cancel active game without playing. Useful if server stops responding before
851      * one game is played.
852      * @param _gameId Game session id.
853      */
854     function playerCancelActiveGame(uint _gameId) public {
855         address playerAddress = msg.sender;
856         uint gameId = playerGameId[playerAddress];
857         Game storage game = gameIdGame[gameId];
858 
859         require(gameId == _gameId);
860 
861         if (game.status == GameStatus.ACTIVE) {
862             game.endInitiatedTime = block.timestamp;
863             game.status = GameStatus.PLAYER_INITIATED_END;
864 
865             emit LogPlayerRequestedEnd(msg.sender, gameId);
866         } else if (game.status == GameStatus.SERVER_INITIATED_END && game.roundId == 0) {
867             closeGame(game, gameId, 0, playerAddress, ReasonEnded.REGULAR_ENDED, 0);
868         } else {
869             revert();
870         }
871     }
872 
873     /**
874      * @dev Cancel active game without playing. Useful if player starts game session and
875      * does not play.
876      * @param _playerAddress Players' address.
877      * @param _gameId Game session id.
878      */
879     function serverCancelActiveGame(address _playerAddress, uint _gameId) public onlyServer {
880         uint gameId = playerGameId[_playerAddress];
881         Game storage game = gameIdGame[gameId];
882 
883         require(gameId == _gameId);
884 
885         if (game.status == GameStatus.ACTIVE) {
886             game.endInitiatedTime = block.timestamp;
887             game.status = GameStatus.SERVER_INITIATED_END;
888 
889             emit LogServerRequestedEnd(msg.sender, gameId);
890         } else if (game.status == GameStatus.PLAYER_INITIATED_END && game.roundId == 0) {
891             closeGame(game, gameId, 0, _playerAddress, ReasonEnded.REGULAR_ENDED, 0);
892         } else {
893             revert();
894         }
895     }
896 
897     /**
898     * @dev Force end of game if player does not respond. Only possible after a certain period of time
899     * to give the player a chance to respond.
900     * @param _playerAddress Player's address.
901     */
902     function serverForceGameEnd(address _playerAddress, uint _gameId) public onlyServer {
903         uint gameId = playerGameId[_playerAddress];
904         Game storage game = gameIdGame[gameId];
905 
906         require(gameId == _gameId);
907         require(game.status == GameStatus.SERVER_INITIATED_END);
908 
909         // theoretically we have enough data to calculate winner
910         // but as player did not respond assume he has lost.
911         int newBalance = conflictRes.serverForceGameEnd(
912             game.gameType,
913             game.betNum,
914             game.betValue,
915             game.balance,
916             game.stake,
917             game.endInitiatedTime
918         );
919 
920         closeGame(game, gameId, game.roundId, _playerAddress, ReasonEnded.END_FORCED_BY_SERVER, newBalance);
921     }
922 
923     /**
924     * @notice Force end of game if server does not respond. Only possible after a certain period of time
925     * to give the server a chance to respond.
926     */
927     function playerForceGameEnd(uint _gameId) public {
928         address playerAddress = msg.sender;
929         uint gameId = playerGameId[playerAddress];
930         Game storage game = gameIdGame[gameId];
931 
932         require(gameId == _gameId);
933         require(game.status == GameStatus.PLAYER_INITIATED_END);
934 
935         int newBalance = conflictRes.playerForceGameEnd(
936             game.gameType,
937             game.betNum,
938             game.betValue,
939             game.balance,
940             game.stake,
941             game.endInitiatedTime
942         );
943 
944         closeGame(game, gameId, game.roundId, playerAddress, ReasonEnded.END_FORCED_BY_PLAYER, newBalance);
945     }
946 
947     /**
948      * @dev Conflict handling implementation. Stores game data and timestamp if game
949      * is active. If server has already marked conflict for game session the conflict
950      * resolution contract is used (compare conflictRes).
951      * @param _roundId Round id of bet.
952      * @param _gameType Game type of bet.
953      * @param _num Number of bet.
954      * @param _value Value of bet.
955      * @param _balance Balance before this bet.
956      * @param _playerHash Hash of player's seed for this bet.
957      * @param _playerSeed Player's seed for this bet.
958      * @param _gameId game Game session id.
959      * @param _playerAddress Player's address.
960      */
961     function playerEndGameConflictImpl(
962         uint32 _roundId,
963         uint8 _gameType,
964         uint16 _num,
965         uint _value,
966         int _balance,
967         bytes32 _playerHash,
968         bytes32 _playerSeed,
969         uint _gameId,
970         address _playerAddress
971     )
972         private
973     {
974         uint gameId = playerGameId[_playerAddress];
975         Game storage game = gameIdGame[gameId];
976         int maxBalance = conflictRes.maxBalance();
977 
978         require(gameId == _gameId);
979         require(_roundId > 0);
980         require(keccak256(abi.encodePacked(_playerSeed)) == _playerHash);
981         require(-int(game.stake) <= _balance && _balance <= maxBalance); // save to cast as ranges are fixed
982         require(conflictRes.isValidBet(_gameType, _num, _value));
983         require(int(game.stake) + _balance - int(_value) >= 0); // save to cast as ranges are fixed
984 
985         if (game.status == GameStatus.SERVER_INITIATED_END && game.roundId == _roundId) {
986             game.playerSeed = _playerSeed;
987             endGameConflict(game, gameId, _playerAddress);
988         } else if (game.status == GameStatus.ACTIVE
989                 || (game.status == GameStatus.SERVER_INITIATED_END && game.roundId < _roundId)) {
990             game.status = GameStatus.PLAYER_INITIATED_END;
991             game.endInitiatedTime = block.timestamp;
992             game.roundId = _roundId;
993             game.gameType = _gameType;
994             game.betNum = _num;
995             game.betValue = _value;
996             game.balance = _balance;
997             game.playerSeed = _playerSeed;
998             game.serverSeed = bytes32(0);
999 
1000             emit LogPlayerRequestedEnd(msg.sender, gameId);
1001         } else {
1002             revert();
1003         }
1004     }
1005 
1006     /**
1007      * @dev Conflict handling implementation. Stores game data and timestamp if game
1008      * is active. If player has already marked conflict for game session the conflict
1009      * resolution contract is used (compare conflictRes).
1010      * @param _roundId Round id of bet.
1011      * @param _gameType Game type of bet.
1012      * @param _num Number of bet.
1013      * @param _value Value of bet.
1014      * @param _balance Balance before this bet.
1015      * @param _serverHash Hash of server's seed for this bet.
1016      * @param _playerHash Hash of player's seed for this bet.
1017      * @param _serverSeed Server's seed for this bet.
1018      * @param _playerSeed Player's seed for this bet.
1019      * @param _playerAddress Player's address.
1020      */
1021     function serverEndGameConflictImpl(
1022         uint32 _roundId,
1023         uint8 _gameType,
1024         uint16 _num,
1025         uint _value,
1026         int _balance,
1027         bytes32 _serverHash,
1028         bytes32 _playerHash,
1029         bytes32 _serverSeed,
1030         bytes32 _playerSeed,
1031         uint _gameId,
1032         address _playerAddress
1033     )
1034         private
1035     {
1036         uint gameId = playerGameId[_playerAddress];
1037         Game storage game = gameIdGame[gameId];
1038         int maxBalance = conflictRes.maxBalance();
1039 
1040         require(gameId == _gameId);
1041         require(_roundId > 0);
1042         require(keccak256(abi.encodePacked(_serverSeed)) == _serverHash);
1043         require(keccak256(abi.encodePacked(_playerSeed)) == _playerHash);
1044         require(-int(game.stake) <= _balance && _balance <= maxBalance); // save to cast as ranges are fixed
1045         require(conflictRes.isValidBet(_gameType, _num, _value));
1046         require(int(game.stake) + _balance - int(_value) >= 0); // save to cast as ranges are fixed
1047 
1048         if (game.status == GameStatus.PLAYER_INITIATED_END && game.roundId == _roundId) {
1049             game.serverSeed = _serverSeed;
1050             endGameConflict(game, gameId, _playerAddress);
1051         } else if (game.status == GameStatus.ACTIVE
1052                 || (game.status == GameStatus.PLAYER_INITIATED_END && game.roundId < _roundId)) {
1053             game.status = GameStatus.SERVER_INITIATED_END;
1054             game.endInitiatedTime = block.timestamp;
1055             game.roundId = _roundId;
1056             game.gameType = _gameType;
1057             game.betNum = _num;
1058             game.betValue = _value;
1059             game.balance = _balance;
1060             game.serverSeed = _serverSeed;
1061             game.playerSeed = _playerSeed;
1062 
1063             emit LogServerRequestedEnd(_playerAddress, gameId);
1064         } else {
1065             revert();
1066         }
1067     }
1068 
1069     /**
1070      * @dev End conflicting game.
1071      * @param _game Game session data.
1072      * @param _gameId Game session id.
1073      * @param _playerAddress Player's address.
1074      */
1075     function endGameConflict(Game storage _game, uint _gameId, address _playerAddress) private {
1076         int newBalance = conflictRes.endGameConflict(
1077             _game.gameType,
1078             _game.betNum,
1079             _game.betValue,
1080             _game.balance,
1081             _game.stake,
1082             _game.serverSeed,
1083             _game.playerSeed
1084         );
1085 
1086         closeGame(_game, _gameId, _game.roundId, _playerAddress, ReasonEnded.REGULAR_ENDED, newBalance);
1087     }
1088 }
1089 
1090 contract GameChannel is GameChannelConflict {
1091     /**
1092      * @dev contract constructor
1093      * @param _serverAddress Server address.
1094      * @param _minStake Min value player needs to deposit to create game session.
1095      * @param _maxStake Max value player can deposit to create game session.
1096      * @param _conflictResAddress Conflict resolution contract address.
1097      * @param _houseAddress House address to move profit to.
1098      */
1099     constructor(
1100         address _serverAddress,
1101         uint128 _minStake,
1102         uint128 _maxStake,
1103         address _conflictResAddress,
1104         address _houseAddress,
1105         uint _gameIdCntr
1106     )
1107         public
1108         GameChannelConflict(_serverAddress, _minStake, _maxStake, _conflictResAddress, _houseAddress, _gameIdCntr)
1109     {
1110         // nothing to do
1111     }
1112 
1113     /**
1114      * @notice Create games session request. msg.value needs to be valid stake value.
1115      * @param _playerEndHash last entry of players' hash chain.
1116      * @param _previousGameId player's previous game id, initial 0.
1117      * @param _createBefore game can be only created before this timestamp.
1118      * @param _serverEndHash last entry of server's hash chain.
1119      * @param _serverSig server signature. See verifyCreateSig
1120      */
1121     function createGame(
1122         bytes32 _playerEndHash,
1123         uint _previousGameId,
1124         uint _createBefore,
1125         bytes32 _serverEndHash,
1126         bytes _serverSig
1127     )
1128         public
1129         payable
1130         onlyValidValue
1131         onlyValidHouseStake(activeGames + 1)
1132         onlyNotPaused
1133     {
1134         uint previousGameId = playerGameId[msg.sender];
1135         Game storage game = gameIdGame[previousGameId];
1136 
1137         require(game.status == GameStatus.ENDED);
1138         require(previousGameId == _previousGameId);
1139         require(block.timestamp < _createBefore);
1140 
1141         verifyCreateSig(msg.sender, _previousGameId, _createBefore, _serverEndHash, _serverSig);
1142 
1143         uint gameId = gameIdCntr++;
1144         playerGameId[msg.sender] = gameId;
1145         Game storage newGame = gameIdGame[gameId];
1146 
1147         newGame.stake = uint128(msg.value); // It's safe to cast msg.value as it is limited, see onlyValidValue
1148         newGame.status = GameStatus.ACTIVE;
1149 
1150         activeGames = activeGames + 1;
1151 
1152         // It's safe to cast msg.value as it is limited, see onlyValidValue
1153         emit LogGameCreated(msg.sender, gameId, uint128(msg.value), _serverEndHash,  _playerEndHash);
1154     }
1155 
1156 
1157     /**
1158      * @dev Regular end game session. Used if player and house have both
1159      * accepted current game session state.
1160      * The game session with gameId _gameId is closed
1161      * and the player paid out. This functions is called by the server after
1162      * the player requested the termination of the current game session.
1163      * @param _roundId Round id of bet.
1164      * @param _gameType Game type of bet.
1165      * @param _num Number of bet.
1166      * @param _value Value of bet.
1167      * @param _balance Current balance.
1168      * @param _serverHash Hash of server's seed for this bet.
1169      * @param _playerHash Hash of player's seed for this bet.
1170      * @param _gameId Game session id.
1171      * @param _contractAddress Address of this contract.
1172      * @param _playerAddress Address of player.
1173      * @param _playerSig Player's signature of this bet.
1174      */
1175     function serverEndGame(
1176         uint32 _roundId,
1177         uint8 _gameType,
1178         uint16 _num,
1179         uint _value,
1180         int _balance,
1181         bytes32 _serverHash,
1182         bytes32 _playerHash,
1183         uint _gameId,
1184         address _contractAddress,
1185         address _playerAddress,
1186         bytes _playerSig
1187     )
1188         public
1189         onlyServer
1190     {
1191         verifySig(
1192                 _roundId,
1193                 _gameType,
1194                 _num,
1195                 _value,
1196                 _balance,
1197                 _serverHash,
1198                 _playerHash,
1199                 _gameId,
1200                 _contractAddress,
1201                 _playerSig,
1202                 _playerAddress
1203         );
1204 
1205         regularEndGame(_playerAddress, _roundId, _gameType, _num, _value, _balance, _gameId, _contractAddress);
1206     }
1207 
1208     /**
1209      * @notice Regular end game session. Normally not needed as server ends game (@see serverEndGame).
1210      * Can be used by player if server does not end game session.
1211      * @param _roundId Round id of bet.
1212      * @param _gameType Game type of bet.
1213      * @param _num Number of bet.
1214      * @param _value Value of bet.
1215      * @param _balance Current balance.
1216      * @param _serverHash Hash of server's seed for this bet.
1217      * @param _playerHash Hash of player's seed for this bet.
1218      * @param _gameId Game session id.
1219      * @param _contractAddress Address of this contract.
1220      * @param _serverSig Server's signature of this bet.
1221      */
1222     function playerEndGame(
1223         uint32 _roundId,
1224         uint8 _gameType,
1225         uint16 _num,
1226         uint _value,
1227         int _balance,
1228         bytes32 _serverHash,
1229         bytes32 _playerHash,
1230         uint _gameId,
1231         address _contractAddress,
1232         bytes _serverSig
1233     )
1234         public
1235     {
1236         verifySig(
1237                 _roundId,
1238                 _gameType,
1239                 _num,
1240                 _value,
1241                 _balance,
1242                 _serverHash,
1243                 _playerHash,
1244                 _gameId,
1245                 _contractAddress,
1246                 _serverSig,
1247                 serverAddress
1248         );
1249 
1250         regularEndGame(msg.sender, _roundId, _gameType, _num, _value, _balance, _gameId, _contractAddress);
1251     }
1252 
1253     /**
1254      * @dev Verify server signature.
1255      * @param _playerAddress player's address.
1256      * @param _previousGameId player's previous game id, initial 0.
1257      * @param _createBefore game can be only created before this timestamp.
1258      * @param _serverEndHash last entry of server's hash chain.
1259      * @param _serverSig server signature.
1260      */
1261     function verifyCreateSig(
1262         address _playerAddress,
1263         uint _previousGameId,
1264         uint _createBefore,
1265         bytes32 _serverEndHash,
1266         bytes _serverSig
1267     )
1268         private view
1269     {
1270         address contractAddress = this;
1271         bytes32 hash = keccak256(abi.encodePacked(
1272             contractAddress, _playerAddress, _previousGameId, _createBefore, _serverEndHash
1273         ));
1274 
1275         verify(hash, _serverSig, serverAddress);
1276     }
1277 
1278     /**
1279      * @dev Regular end game session implementation. Used if player and house have both
1280      * accepted current game session state. The game session with gameId _gameId is closed
1281      * and the player paid out.
1282      * @param _playerAddress Address of player.
1283      * @param _gameType Game type of bet.
1284      * @param _num Number of bet.
1285      * @param _value Value of bet.
1286      * @param _balance Current balance.
1287      * @param _gameId Game session id.
1288      * @param _contractAddress Address of this contract.
1289      */
1290     function regularEndGame(
1291         address _playerAddress,
1292         uint32 _roundId,
1293         uint8 _gameType,
1294         uint16 _num,
1295         uint _value,
1296         int _balance,
1297         uint _gameId,
1298         address _contractAddress
1299     )
1300         private
1301     {
1302         uint gameId = playerGameId[_playerAddress];
1303         Game storage game = gameIdGame[gameId];
1304         address contractAddress = this;
1305         int maxBalance = conflictRes.maxBalance();
1306 
1307         require(_gameId == gameId);
1308         require(_roundId > 0);
1309         // save to cast as game.stake hash fixed range
1310         require(-int(game.stake) <= _balance && _balance <= maxBalance);
1311         require((_gameType == 0) && (_num == 0) && (_value == 0));
1312         require(game.status == GameStatus.ACTIVE);
1313 
1314         assert(_contractAddress == contractAddress);
1315 
1316         closeGame(game, gameId, _roundId, _playerAddress, ReasonEnded.REGULAR_ENDED, _balance);
1317     }
1318 }