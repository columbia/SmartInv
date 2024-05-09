1 pragma solidity ^0.4.18;
2 
3 interface ConflictResolutionInterface {
4     function minHouseStake(uint activeGames) public pure returns(uint);
5 
6     function maxBalance() public pure returns(int);
7 
8     function isValidBet(uint8 _gameType, uint _betNum, uint _betValue) public pure returns(bool);
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
19         public
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
31         public
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
43         public
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
79 
80     event LogOwnerShipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     /**
83      * @dev Modifier, which throws if called by other account than owner.
84      */
85     modifier onlyOwner {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     /**
91      * @dev Set contract creator as initial owner
92      */
93     function Ownable() public {
94         owner = msg.sender;
95     }
96 
97     /**
98      * @dev Allows the current owner to transfer control of the
99      * contract to a newOwner _newOwner.
100      * @param _newOwner The address to transfer ownership to.
101      */
102     function setOwner(address _newOwner) public onlyOwner {
103         require(_newOwner != address(0));
104         LogOwnerShipTransferred(owner, _newOwner);
105         owner = _newOwner;
106     }
107 }
108 
109 contract ConflictResolutionManager is Ownable {
110     /// @dev Conflict resolution contract.
111     ConflictResolutionInterface public conflictRes;
112 
113     /// @dev New Conflict resolution contract.
114     address public newConflictRes = 0;
115 
116     /// @dev Time update of new conflict resolution contract was initiated.
117     uint public updateTime = 0;
118 
119     /// @dev Min time before new conflict res contract can be activated after initiating update.
120     uint public constant MIN_TIMEOUT = 3 days;
121 
122     /// @dev Min time before new conflict res contract can be activated after initiating update.
123     uint public constant MAX_TIMEOUT = 6 days;
124 
125     /// @dev Update of conflict resolution contract was initiated.
126     event LogUpdatingConflictResolution(address newConflictResolutionAddress);
127 
128     /// @dev New conflict resolution contract is active.
129     event LogUpdatedConflictResolution(address newConflictResolutionAddress);
130 
131     /**
132      * @dev Constructor
133      * @param _conflictResAddress conflict resolution contract address.
134      */
135     function ConflictResolutionManager(address _conflictResAddress) public {
136         conflictRes = ConflictResolutionInterface(_conflictResAddress);
137     }
138 
139     /**
140      * @dev Initiate conflict resolution contract update.
141      * @param _newConflictResAddress New conflict resolution contract address.
142      */
143     function updateConflictResolution(address _newConflictResAddress) public onlyOwner {
144         newConflictRes = _newConflictResAddress;
145         updateTime = block.timestamp;
146 
147         LogUpdatingConflictResolution(_newConflictResAddress);
148     }
149 
150     /**
151      * @dev Active new conflict resolution contract.
152      */
153     function activateConflictResolution() public onlyOwner {
154         require(newConflictRes != 0);
155         require(updateTime != 0);
156         require(updateTime + MIN_TIMEOUT <= block.timestamp && block.timestamp <= updateTime + MAX_TIMEOUT);
157 
158         conflictRes = ConflictResolutionInterface(newConflictRes);
159         newConflictRes = 0;
160         updateTime = 0;
161 
162         LogUpdatedConflictResolution(newConflictRes);
163     }
164 }
165 
166 contract Pausable is Ownable {
167     /// @dev Is contract paused.
168     bool public paused = false;
169 
170     /// @dev Time pause was called
171     uint public timePaused = 0;
172 
173     /// @dev Modifier, which only allows function execution if not paused.
174     modifier onlyNotPaused() {
175         require(!paused);
176         _;
177     }
178 
179     /// @dev Modifier, which only allows function execution if paused.
180     modifier onlyPaused() {
181         require(paused);
182         _;
183     }
184 
185     /// @dev Modifier, which only allows function execution if paused longer than timeSpan.
186     modifier onlyPausedSince(uint timeSpan) {
187         require(paused && timePaused + timeSpan <= block.timestamp);
188         _;
189     }
190 
191     /// @dev Event is fired if paused.
192     event LogPause();
193 
194     /// @dev Event is fired if pause is ended.
195     event LogUnpause();
196 
197     /**
198      * @dev Pause contract. No new game sessions can be created.
199      */
200     function pause() public onlyOwner onlyNotPaused {
201         paused = true;
202         timePaused = block.timestamp;
203         LogPause();
204     }
205 
206     /**
207      * @dev Unpause contract.
208      */
209     function unpause() public onlyOwner onlyPaused {
210         paused = false;
211         timePaused = 0;
212         LogUnpause();
213     }
214 }
215 
216 contract Destroyable is Pausable {
217     /// @dev After pausing the contract for 20 days owner can selfdestruct it.
218     uint public constant TIMEOUT_DESTROY = 20 days;
219 
220     /**
221      * @dev Destroy contract and transfer ether to address _targetAddress.
222      */
223     function destroy() public onlyOwner onlyPausedSince(TIMEOUT_DESTROY) {
224         selfdestruct(owner);
225     }
226 }
227 
228 contract GameChannelBase is Destroyable, ConflictResolutionManager {
229     /// @dev Different game session states.
230     enum GameStatus {
231         ENDED, ///< @dev Game session is ended.
232         ACTIVE, ///< @dev Game session is active.
233         WAITING_FOR_SERVER, ///< @dev Waiting for server to accept game session.
234         PLAYER_INITIATED_END, ///< @dev Player initiated non regular end.
235         SERVER_INITIATED_END ///< @dev Server initiated non regular end.
236     }
237 
238     /// @dev Reason game session ended.
239     enum ReasonEnded {
240         REGULAR_ENDED, ///< @dev Game session is regularly ended.
241         END_FORCED_BY_SERVER, ///< @dev Player did not respond. Server forced end.
242         END_FORCED_BY_PLAYER, ///< @dev Server did not respond. Player forced end.
243         REJECTED_BY_SERVER, ///< @dev Server rejected game session.
244         CANCELLED_BY_PLAYER ///< @dev Player canceled game session before server accepted it.
245     }
246 
247     struct Game {
248         /// @dev Game session status.
249         GameStatus status;
250 
251         /// @dev Reason game session ended.
252         ReasonEnded reasonEnded;
253 
254         /// @dev Player's stake.
255         uint stake;
256 
257         /// @dev Last game round info if not regularly ended.
258         /// If game session is ended normally this data is not used.
259         uint8 gameType;
260         uint32 roundId;
261         uint16 betNum;
262         uint betValue;
263         int balance;
264         bytes32 playerSeed;
265         bytes32 serverSeed;
266         uint endInitiatedTime;
267     }
268 
269     /// @dev Minimal time span between profit transfer.
270     uint public constant MIN_TRANSFER_TIMESPAN = 1 days;
271 
272     /// @dev Maximal time span between profit transfer.
273     uint public constant MAX_TRANSFER_TIMSPAN = 6 * 30 days;
274 
275     /// @dev Current active game sessions.
276     uint public activeGames = 0;
277 
278     /// @dev Game session id counter. Points to next free game session slot. So gameIdCntr -1 is the
279     // number of game sessions created.
280     uint public gameIdCntr;
281 
282     /// @dev Only this address can accept and end games.
283     address public serverAddress;
284 
285     /// @dev Address to transfer profit to.
286     address public houseAddress;
287 
288     /// @dev Current house stake.
289     uint public houseStake = 0;
290 
291     /// @dev House profit since last profit transfer.
292     int public houseProfit = 0;
293 
294     /// @dev Min value player needs to deposit for creating game session.
295     uint public minStake;
296 
297     /// @dev Max value player can deposit for creating game session.
298     uint public maxStake;
299 
300     /// @dev Timeout until next profit transfer is allowed.
301     uint public profitTransferTimeSpan = 14 days;
302 
303     /// @dev Last time profit transferred to house.
304     uint public lastProfitTransferTimestamp;
305 
306     bytes32 public typeHash;
307 
308     /// @dev Maps gameId to game struct.
309     mapping (uint => Game) public gameIdGame;
310 
311     /// @dev Maps player address to current player game id.
312     mapping (address => uint) public playerGameId;
313 
314     /// @dev Maps player address to pending returns.
315     mapping (address => uint) public pendingReturns;
316 
317     /// @dev Modifier, which only allows to execute if house stake is high enough.
318     modifier onlyValidHouseStake(uint _activeGames) {
319         uint minHouseStake = conflictRes.minHouseStake(_activeGames);
320         require(houseStake >= minHouseStake);
321         _;
322     }
323 
324     /// @dev Modifier to check if value send fulfills player stake requirements.
325     modifier onlyValidValue() {
326         require(minStake <= msg.value && msg.value <= maxStake);
327         _;
328     }
329 
330     /// @dev Modifier, which only allows server to call function.
331     modifier onlyServer() {
332         require(msg.sender == serverAddress);
333         _;
334     }
335 
336     /// @dev Modifier, which only allows to set valid transfer timeouts.
337     modifier onlyValidTransferTimeSpan(uint transferTimeout) {
338         require(transferTimeout >= MIN_TRANSFER_TIMESPAN
339                 && transferTimeout <= MAX_TRANSFER_TIMSPAN);
340         _;
341     }
342 
343     /// @dev This event is fired when player creates game session.
344     event LogGameCreated(address indexed player, uint indexed gameId, uint stake, bytes32 endHash);
345 
346     /// @dev This event is fired when server rejects player's game.
347     event LogGameRejected(address indexed player, uint indexed gameId);
348 
349     /// @dev This event is fired when server accepts player's game.
350     event LogGameAccepted(address indexed player, uint indexed gameId, bytes32 endHash);
351 
352     /// @dev This event is fired when player requests conflict end.
353     event LogPlayerRequestedEnd(address indexed player, uint indexed gameId);
354 
355     /// @dev This event is fired when server requests conflict end.
356     event LogServerRequestedEnd(address indexed player, uint indexed gameId);
357 
358     /// @dev This event is fired when game session is ended.
359     event LogGameEnded(address indexed player, uint indexed gameId, ReasonEnded reason);
360 
361     /// @dev this event is fired when owner modifies player's stake limits.
362     event LogStakeLimitsModified(uint minStake, uint maxStake);
363 
364     /**
365      * @dev Contract constructor.
366      * @param _serverAddress Server address.
367      * @param _minStake Min value player needs to deposit to create game session.
368      * @param _maxStake Max value player can deposit to create game session.
369      * @param _conflictResAddress Conflict resolution contract address.
370      * @param _houseAddress House address to move profit to.
371      */
372     function GameChannelBase(
373         address _serverAddress,
374         uint _minStake,
375         uint _maxStake,
376         address _conflictResAddress,
377         address _houseAddress,
378         uint _gameIdCntr
379     )
380         public
381         ConflictResolutionManager(_conflictResAddress)
382     {
383         require(_minStake > 0 && _minStake <= _maxStake);
384         require(_gameIdCntr > 0);
385 
386         gameIdCntr = _gameIdCntr;
387         serverAddress = _serverAddress;
388         houseAddress = _houseAddress;
389         lastProfitTransferTimestamp = block.timestamp;
390         minStake = _minStake;
391         maxStake = _maxStake;
392 
393         typeHash = keccak256(
394             "uint32 Round Id",
395             "uint8 Game Type",
396             "uint16 Number",
397             "uint Value (Wei)",
398             "int Current Balance (Wei)",
399             "bytes32 Server Hash",
400             "bytes32 Player Hash",
401             "uint Game Id",
402             "address Contract Address"
403         );
404     }
405 
406     /**
407      * @notice Withdraw pending returns.
408      */
409     function withdraw() public {
410         uint toTransfer = pendingReturns[msg.sender];
411         require(toTransfer > 0);
412 
413         pendingReturns[msg.sender] = 0;
414         msg.sender.transfer(toTransfer);
415     }
416 
417     /**
418      * @notice Transfer house profit to houseAddress.
419      */
420     function transferProfitToHouse() public {
421         require(lastProfitTransferTimestamp + profitTransferTimeSpan <= block.timestamp);
422 
423         if (houseProfit <= 0) {
424             // update last transfer timestamp
425             lastProfitTransferTimestamp = block.timestamp;
426             return;
427         }
428 
429         // houseProfit is gt 0 => safe to cast
430         uint toTransfer = uint(houseProfit);
431         assert(houseStake >= toTransfer);
432 
433         houseProfit = 0;
434         lastProfitTransferTimestamp = block.timestamp;
435         houseStake = houseStake - toTransfer;
436 
437         houseAddress.transfer(toTransfer);
438     }
439 
440     /**
441      * @dev Set profit transfer time span.
442      */
443     function setProfitTransferTimeSpan(uint _profitTransferTimeSpan)
444         public
445         onlyOwner
446         onlyValidTransferTimeSpan(_profitTransferTimeSpan)
447     {
448         profitTransferTimeSpan = _profitTransferTimeSpan;
449     }
450 
451     /**
452      * @dev Increase house stake by msg.value
453      */
454     function addHouseStake() public payable onlyOwner {
455         houseStake += msg.value;
456     }
457 
458     /**
459      * @dev Withdraw house stake.
460      */
461     function withdrawHouseStake(uint value) public onlyOwner {
462         uint minHouseStake = conflictRes.minHouseStake(activeGames);
463 
464         require(value <= houseStake && houseStake - value >= minHouseStake);
465         require(houseProfit <= 0 || uint(houseProfit) <= houseStake - value);
466 
467         houseStake = houseStake - value;
468         owner.transfer(value);
469     }
470 
471     /**
472      * @dev Withdraw house stake and profit.
473      */
474     function withdrawAll() public onlyOwner onlyPausedSince(3 days) {
475         houseProfit = 0;
476         uint toTransfer = houseStake;
477         houseStake = 0;
478         owner.transfer(toTransfer);
479     }
480 
481     /**
482      * @dev Set new house address.
483      * @param _houseAddress New house address.
484      */
485     function setHouseAddress(address _houseAddress) public onlyOwner {
486         houseAddress = _houseAddress;
487     }
488 
489     /**
490      * @dev Set stake min and max value.
491      * @param _minStake Min stake.
492      * @param _maxStake Max stake.
493      */
494     function setStakeRequirements(uint _minStake, uint _maxStake) public onlyOwner {
495         require(_minStake > 0 && _minStake <= _maxStake);
496         minStake = _minStake;
497         maxStake = _maxStake;
498         LogStakeLimitsModified(minStake, maxStake);
499     }
500 
501     /**
502      * @dev Close game session.
503      * @param _game Game session data.
504      * @param _gameId Id of game session.
505      * @param _playerAddress Player's address of game session.
506      * @param _reason Reason for closing game session.
507      * @param _balance Game session balance.
508      */
509     function closeGame(
510         Game storage _game,
511         uint _gameId,
512         address _playerAddress,
513         ReasonEnded _reason,
514         int _balance
515     )
516         internal
517     {
518         _game.status = GameStatus.ENDED;
519         _game.reasonEnded = _reason;
520         _game.balance = _balance;
521 
522         assert(activeGames > 0);
523         activeGames = activeGames - 1;
524 
525         LogGameEnded(_playerAddress, _gameId, _reason);
526     }
527 
528     /**
529      * @dev End game by paying out player and server.
530      * @param _game Game session to payout.
531      * @param _playerAddress Player's address.
532      */
533     function payOut(Game storage _game, address _playerAddress) internal {
534         assert(_game.balance <= conflictRes.maxBalance());
535         assert(_game.status == GameStatus.ENDED);
536         assert(_game.stake <= maxStake);
537         assert((int(_game.stake) + _game.balance) >= 0);
538 
539         uint valuePlayer = uint(int(_game.stake) + _game.balance);
540 
541         if (_game.balance > 0 && int(houseStake) < _game.balance) {
542             // Should never happen!
543             // House is bankrupt.
544             // Payout left money.
545             valuePlayer = houseStake;
546         }
547 
548         houseProfit = houseProfit - _game.balance;
549 
550         int newHouseStake = int(houseStake) - _game.balance;
551         assert(newHouseStake >= 0);
552         houseStake = uint(newHouseStake);
553 
554         pendingReturns[_playerAddress] += valuePlayer;
555         if (pendingReturns[_playerAddress] > 0) {
556             safeSend(_playerAddress);
557         }
558     }
559 
560     /**
561      * @dev Send value of pendingReturns[_address] to _address.
562      * @param _address Address to send value to.
563      */
564     function safeSend(address _address) internal {
565         uint valueToSend = pendingReturns[_address];
566         assert(valueToSend > 0);
567 
568         pendingReturns[_address] = 0;
569         if (_address.send(valueToSend) == false) {
570             pendingReturns[_address] = valueToSend;
571         }
572     }
573 
574     /**
575      * @dev Verify signature of given data. Throws on verification failure.
576      * @param _sig Signature of given data in the form of rsv.
577      * @param _address Address of signature signer.
578      */
579     function verifySig(
580         uint32 _roundId,
581         uint8 _gameType,
582         uint16 _num,
583         uint _value,
584         int _balance,
585         bytes32 _serverHash,
586         bytes32 _playerHash,
587         uint _gameId,
588         address _contractAddress,
589         bytes _sig,
590         address _address
591     )
592         internal
593         view
594     {
595         // check if this is the correct contract
596         address contractAddress = this;
597         require(_contractAddress == contractAddress);
598 
599         bytes32 roundHash = calcHash(
600                 _roundId,
601                 _gameType,
602                 _num,
603                 _value,
604                 _balance,
605                 _serverHash,
606                 _playerHash,
607                 _gameId,
608                 _contractAddress
609         );
610 
611         verify(
612                 roundHash,
613                 _sig,
614                 _address
615         );
616     }
617 
618     /**
619      * @dev Calculate typed hash of given data (compare eth_signTypedData).
620      * @return Hash of given data.
621      */
622     function calcHash(
623         uint32 _roundId,
624         uint8 _gameType,
625         uint16 _num,
626         uint _value,
627         int _balance,
628         bytes32 _serverHash,
629         bytes32 _playerHash,
630         uint _gameId,
631         address _contractAddress
632     )
633         private
634         view
635         returns(bytes32)
636     {
637         bytes32 dataHash = keccak256(
638             _roundId,
639             _gameType,
640             _num,
641             _value,
642             _balance,
643             _serverHash,
644             _playerHash,
645             _gameId,
646             _contractAddress
647         );
648 
649         return keccak256(typeHash, dataHash);
650     }
651 
652      /**
653      * @dev Check if _sig is valid signature of _hash. Throws if invalid signature.
654      * @param _hash Hash to check signature of.
655      * @param _sig Signature of _hash.
656      * @param _address Address of signer.
657      */
658     function verify(
659         bytes32 _hash,
660         bytes _sig,
661         address _address
662     )
663         private
664         pure
665     {
666         var (r, s, v) = signatureSplit(_sig);
667         address addressRecover = ecrecover(_hash, v, r, s);
668         require(addressRecover == _address);
669     }
670 
671     /**
672      * @dev Split the given signature of the form rsv in r s v. v is incremented with 27 if
673      * it is below 2.
674      * @param _signature Signature to split.
675      * @return r s v
676      */
677     function signatureSplit(bytes _signature)
678         private
679         pure
680         returns (bytes32 r, bytes32 s, uint8 v)
681     {
682         require(_signature.length == 65);
683 
684         assembly {
685             r := mload(add(_signature, 32))
686             s := mload(add(_signature, 64))
687             v := and(mload(add(_signature, 65)), 0xff)
688         }
689         if (v < 2) {
690             v = v + 27;
691         }
692     }
693 }
694 
695 contract GameChannelConflict is GameChannelBase {
696     /**
697      * @dev Contract constructor.
698      * @param _serverAddress Server address.
699      * @param _minStake Min value player needs to deposit to create game session.
700      * @param _maxStake Max value player can deposit to create game session.
701      * @param _conflictResAddress Conflict resolution contract address
702      * @param _houseAddress House address to move profit to
703      */
704     function GameChannelConflict(
705         address _serverAddress,
706         uint _minStake,
707         uint _maxStake,
708         address _conflictResAddress,
709         address _houseAddress,
710         uint _gameIdCtr
711     )
712         public
713         GameChannelBase(_serverAddress, _minStake, _maxStake, _conflictResAddress, _houseAddress, _gameIdCtr)
714     {
715         // nothing to do
716     }
717 
718     /**
719      * @dev Used by server if player does not end game session.
720      * @param _roundId Round id of bet.
721      * @param _gameType Game type of bet.
722      * @param _num Number of bet.
723      * @param _value Value of bet.
724      * @param _balance Balance before this bet.
725      * @param _serverHash Hash of server seed for this bet.
726      * @param _playerHash Hash of player seed for this bet.
727      * @param _gameId Game session id.
728      * @param _contractAddress Address of this contract.
729      * @param _playerSig Player signature of this bet.
730      * @param _playerAddress Address of player.
731      * @param _serverSeed Server seed for this bet.
732      * @param _playerSeed Player seed for this bet.
733      */
734     function serverEndGameConflict(
735         uint32 _roundId,
736         uint8 _gameType,
737         uint16 _num,
738         uint _value,
739         int _balance,
740         bytes32 _serverHash,
741         bytes32 _playerHash,
742         uint _gameId,
743         address _contractAddress,
744         bytes _playerSig,
745         address _playerAddress,
746         bytes32 _serverSeed,
747         bytes32 _playerSeed
748     )
749         public
750         onlyServer
751     {
752         verifySig(
753                 _roundId,
754                 _gameType,
755                 _num,
756                 _value,
757                 _balance,
758                 _serverHash,
759                 _playerHash,
760                 _gameId,
761                 _contractAddress,
762                 _playerSig,
763                 _playerAddress
764         );
765 
766         serverEndGameConflictImpl(
767                 _roundId,
768                 _gameType,
769                 _num,
770                 _value,
771                 _balance,
772                 _serverHash,
773                 _playerHash,
774                 _serverSeed,
775                 _playerSeed,
776                 _gameId,
777                 _playerAddress
778         );
779     }
780 
781     /**
782      * @notice Can be used by player if server does not answer to the end game session request.
783      * @param _roundId Round id of bet.
784      * @param _gameType Game type of bet.
785      * @param _num Number of bet.
786      * @param _value Value of bet.
787      * @param _balance Balance before this bet.
788      * @param _serverHash Hash of server seed for this bet.
789      * @param _playerHash Hash of player seed for this bet.
790      * @param _gameId Game session id.
791      * @param _contractAddress Address of this contract.
792      * @param _serverSig Server signature of this bet.
793      * @param _playerSeed Player seed for this bet.
794      */
795     function playerEndGameConflict(
796         uint32 _roundId,
797         uint8 _gameType,
798         uint16 _num,
799         uint _value,
800         int _balance,
801         bytes32 _serverHash,
802         bytes32 _playerHash,
803         uint _gameId,
804         address _contractAddress,
805         bytes _serverSig,
806         bytes32 _playerSeed
807     )
808         public
809     {
810         verifySig(
811             _roundId,
812             _gameType,
813             _num,
814             _value,
815             _balance,
816             _serverHash,
817             _playerHash,
818             _gameId,
819             _contractAddress,
820             _serverSig,
821             serverAddress
822         );
823 
824         playerEndGameConflictImpl(
825             _roundId,
826             _gameType,
827             _num,
828             _value,
829             _balance,
830             _playerHash,
831             _playerSeed,
832             _gameId,
833             msg.sender
834         );
835     }
836 
837     /**
838      * @notice Cancel active game without playing. Useful if server stops responding before
839      * one game is played.
840      * @param _gameId Game session id.
841      */
842     function playerCancelActiveGame(uint _gameId) public {
843         address playerAddress = msg.sender;
844         uint gameId = playerGameId[playerAddress];
845         Game storage game = gameIdGame[gameId];
846 
847         require(gameId == _gameId);
848 
849         if (game.status == GameStatus.ACTIVE) {
850             game.endInitiatedTime = block.timestamp;
851             game.status = GameStatus.PLAYER_INITIATED_END;
852 
853             LogPlayerRequestedEnd(msg.sender, gameId);
854         } else if (game.status == GameStatus.SERVER_INITIATED_END && game.roundId == 0) {
855             closeGame(game, gameId, playerAddress, ReasonEnded.REGULAR_ENDED, 0);
856             payOut(game, playerAddress);
857         } else {
858             revert();
859         }
860     }
861 
862     /**
863      * @dev Cancel active game without playing. Useful if player starts game session and
864      * does not play.
865      * @param _playerAddress Players' address.
866      * @param _gameId Game session id.
867      */
868     function serverCancelActiveGame(address _playerAddress, uint _gameId) public onlyServer {
869         uint gameId = playerGameId[_playerAddress];
870         Game storage game = gameIdGame[gameId];
871 
872         require(gameId == _gameId);
873 
874         if (game.status == GameStatus.ACTIVE) {
875             game.endInitiatedTime = block.timestamp;
876             game.status = GameStatus.SERVER_INITIATED_END;
877 
878             LogServerRequestedEnd(msg.sender, gameId);
879         } else if (game.status == GameStatus.PLAYER_INITIATED_END && game.roundId == 0) {
880             closeGame(game, gameId, _playerAddress, ReasonEnded.REGULAR_ENDED, 0);
881             payOut(game, _playerAddress);
882         } else {
883             revert();
884         }
885     }
886 
887     /**
888     * @dev Force end of game if player does not respond. Only possible after a certain period of time
889     * to give the player a chance to respond.
890     * @param _playerAddress Player's address.
891     */
892     function serverForceGameEnd(address _playerAddress, uint _gameId) public onlyServer {
893         uint gameId = playerGameId[_playerAddress];
894         Game storage game = gameIdGame[gameId];
895 
896         require(gameId == _gameId);
897         require(game.status == GameStatus.SERVER_INITIATED_END);
898 
899         // theoretically we have enough data to calculate winner
900         // but as player did not respond assume he has lost.
901         int newBalance = conflictRes.serverForceGameEnd(
902             game.gameType,
903             game.betNum,
904             game.betValue,
905             game.balance,
906             game.stake,
907             game.endInitiatedTime
908         );
909 
910         closeGame(game, gameId, _playerAddress, ReasonEnded.END_FORCED_BY_SERVER, newBalance);
911         payOut(game, _playerAddress);
912     }
913 
914     /**
915     * @notice Force end of game if server does not respond. Only possible after a certain period of time
916     * to give the server a chance to respond.
917     */
918     function playerForceGameEnd(uint _gameId) public {
919         address playerAddress = msg.sender;
920         uint gameId = playerGameId[playerAddress];
921         Game storage game = gameIdGame[gameId];
922 
923         require(gameId == _gameId);
924         require(game.status == GameStatus.PLAYER_INITIATED_END);
925 
926         int newBalance = conflictRes.playerForceGameEnd(
927             game.gameType,
928             game.betNum,
929             game.betValue,
930             game.balance,
931             game.stake,
932             game.endInitiatedTime
933         );
934 
935         closeGame(game, gameId, playerAddress, ReasonEnded.END_FORCED_BY_PLAYER, newBalance);
936         payOut(game, playerAddress);
937     }
938 
939     /**
940      * @dev Conflict handling implementation. Stores game data and timestamp if game
941      * is active. If server has already marked conflict for game session the conflict
942      * resolution contract is used (compare conflictRes).
943      * @param _roundId Round id of bet.
944      * @param _gameType Game type of bet.
945      * @param _num Number of bet.
946      * @param _value Value of bet.
947      * @param _balance Balance before this bet.
948      * @param _playerHash Hash of player's seed for this bet.
949      * @param _playerSeed Player's seed for this bet.
950      * @param _gameId game Game session id.
951      * @param _playerAddress Player's address.
952      */
953     function playerEndGameConflictImpl(
954         uint32 _roundId,
955         uint8 _gameType,
956         uint16 _num,
957         uint _value,
958         int _balance,
959         bytes32 _playerHash,
960         bytes32 _playerSeed,
961         uint _gameId,
962         address _playerAddress
963     )
964         private
965     {
966         uint gameId = playerGameId[_playerAddress];
967         Game storage game = gameIdGame[gameId];
968         int maxBalance = conflictRes.maxBalance();
969 
970         require(gameId == _gameId);
971         require(_roundId > 0);
972         require(keccak256(_playerSeed) == _playerHash);
973         require(_value <= game.stake);
974         require(-int(game.stake) <= _balance && _balance <= maxBalance); // save to cast as ranges are fixed
975         require(int(game.stake) + _balance - int(_value) >= 0); // save to cast as ranges are fixed
976         require(conflictRes.isValidBet(_gameType, _num, _value));
977 
978         if (game.status == GameStatus.SERVER_INITIATED_END && game.roundId == _roundId) {
979             game.playerSeed = _playerSeed;
980             endGameConflict(game, gameId, _playerAddress);
981         } else if (game.status == GameStatus.ACTIVE
982                 || (game.status == GameStatus.SERVER_INITIATED_END && game.roundId < _roundId)) {
983             game.status = GameStatus.PLAYER_INITIATED_END;
984             game.endInitiatedTime = block.timestamp;
985             game.roundId = _roundId;
986             game.gameType = _gameType;
987             game.betNum = _num;
988             game.betValue = _value;
989             game.balance = _balance;
990             game.playerSeed = _playerSeed;
991             game.serverSeed = bytes32(0);
992 
993             LogPlayerRequestedEnd(msg.sender, gameId);
994         } else {
995             revert();
996         }
997     }
998 
999     /**
1000      * @dev Conflict handling implementation. Stores game data and timestamp if game
1001      * is active. If player has already marked conflict for game session the conflict
1002      * resolution contract is used (compare conflictRes).
1003      * @param _roundId Round id of bet.
1004      * @param _gameType Game type of bet.
1005      * @param _num Number of bet.
1006      * @param _value Value of bet.
1007      * @param _balance Balance before this bet.
1008      * @param _serverHash Hash of server's seed for this bet.
1009      * @param _playerHash Hash of player's seed for this bet.
1010      * @param _serverSeed Server's seed for this bet.
1011      * @param _playerSeed Player's seed for this bet.
1012      * @param _playerAddress Player's address.
1013      */
1014     function serverEndGameConflictImpl(
1015         uint32 _roundId,
1016         uint8 _gameType,
1017         uint16 _num,
1018         uint _value,
1019         int _balance,
1020         bytes32 _serverHash,
1021         bytes32 _playerHash,
1022         bytes32 _serverSeed,
1023         bytes32 _playerSeed,
1024         uint _gameId,
1025         address _playerAddress
1026     )
1027         private
1028     {
1029         uint gameId = playerGameId[_playerAddress];
1030         Game storage game = gameIdGame[gameId];
1031         int maxBalance = conflictRes.maxBalance();
1032 
1033         require(gameId == _gameId);
1034         require(_roundId > 0);
1035         require(keccak256(_serverSeed) == _serverHash);
1036         require(keccak256(_playerSeed) == _playerHash);
1037         require(_value <= game.stake);
1038         require(-int(game.stake) <= _balance && _balance <= maxBalance); // save to cast as ranges are fixed
1039         require(int(game.stake) + _balance - int(_value) >= 0); // save to cast as ranges are fixed
1040         require(conflictRes.isValidBet(_gameType, _num, _value));
1041 
1042 
1043         if (game.status == GameStatus.PLAYER_INITIATED_END && game.roundId == _roundId) {
1044             game.serverSeed = _serverSeed;
1045             endGameConflict(game, gameId, _playerAddress);
1046         } else if (game.status == GameStatus.ACTIVE
1047                 || (game.status == GameStatus.PLAYER_INITIATED_END && game.roundId < _roundId)) {
1048             game.status = GameStatus.SERVER_INITIATED_END;
1049             game.endInitiatedTime = block.timestamp;
1050             game.roundId = _roundId;
1051             game.gameType = _gameType;
1052             game.betNum = _num;
1053             game.betValue = _value;
1054             game.balance = _balance;
1055             game.serverSeed = _serverSeed;
1056             game.playerSeed = _playerSeed;
1057 
1058             LogServerRequestedEnd(_playerAddress, gameId);
1059         } else {
1060             revert();
1061         }
1062     }
1063 
1064     /**
1065      * @dev End conflicting game.
1066      * @param _game Game session data.
1067      * @param _gameId Game session id.
1068      * @param _playerAddress Player's address.
1069      */
1070     function endGameConflict(Game storage _game, uint _gameId, address _playerAddress) private {
1071         int newBalance = conflictRes.endGameConflict(
1072             _game.gameType,
1073             _game.betNum,
1074             _game.betValue,
1075             _game.balance,
1076             _game.stake,
1077             _game.serverSeed,
1078             _game.playerSeed
1079         );
1080 
1081         closeGame(_game, _gameId, _playerAddress, ReasonEnded.REGULAR_ENDED, newBalance);
1082         payOut(_game, _playerAddress);
1083     }
1084 }
1085 
1086 contract GameChannel is GameChannelConflict {
1087     /**
1088      * @dev contract constructor
1089      * @param _serverAddress Server address.
1090      * @param _minStake Min value player needs to deposit to create game session.
1091      * @param _maxStake Max value player can deposit to create game session.
1092      * @param _conflictResAddress Conflict resolution contract address.
1093      * @param _houseAddress House address to move profit to.
1094      */
1095     function GameChannel(
1096         address _serverAddress,
1097         uint _minStake,
1098         uint _maxStake,
1099         address _conflictResAddress,
1100         address _houseAddress,
1101         uint _gameIdCntr
1102     )
1103         public
1104         GameChannelConflict(_serverAddress, _minStake, _maxStake, _conflictResAddress, _houseAddress, _gameIdCntr)
1105     {
1106         // nothing to do
1107     }
1108 
1109     /**
1110      * @notice Create games session request. msg.value needs to be valid stake value.
1111      * @param _endHash Last hash of the hash chain generated by the player.
1112      */
1113     function createGame(bytes32 _endHash)
1114         public
1115         payable
1116         onlyValidValue
1117         onlyValidHouseStake(activeGames + 1)
1118         onlyNotPaused
1119     {
1120         address playerAddress = msg.sender;
1121         uint previousGameId = playerGameId[playerAddress];
1122         Game storage game = gameIdGame[previousGameId];
1123 
1124         require(game.status == GameStatus.ENDED);
1125 
1126         uint gameId = gameIdCntr++;
1127         playerGameId[playerAddress] = gameId;
1128         Game storage newGame = gameIdGame[gameId];
1129 
1130         newGame.stake = msg.value;
1131         newGame.status = GameStatus.WAITING_FOR_SERVER;
1132 
1133         activeGames = activeGames + 1;
1134 
1135         LogGameCreated(playerAddress, gameId, msg.value, _endHash);
1136     }
1137 
1138     /**
1139      * @notice Cancel game session waiting for server acceptance.
1140      * @param _gameId Game session id.
1141      */
1142     function cancelGame(uint _gameId) public {
1143         address playerAddress = msg.sender;
1144         uint gameId = playerGameId[playerAddress];
1145         Game storage game = gameIdGame[gameId];
1146 
1147         require(gameId == _gameId);
1148         require(game.status == GameStatus.WAITING_FOR_SERVER);
1149 
1150         closeGame(game, gameId, playerAddress, ReasonEnded.CANCELLED_BY_PLAYER, 0);
1151         payOut(game, playerAddress);
1152     }
1153 
1154     /**
1155      * @dev Called by the server to reject game session created by player with address
1156      * _playerAddress.
1157      * @param _playerAddress Players's address who created the game session.
1158      * @param _gameId Game session id.
1159      */
1160     function rejectGame(address _playerAddress, uint _gameId) public onlyServer {
1161         uint gameId = playerGameId[_playerAddress];
1162         Game storage game = gameIdGame[gameId];
1163 
1164         require(_gameId == gameId);
1165         require(game.status == GameStatus.WAITING_FOR_SERVER);
1166 
1167         closeGame(game, gameId, _playerAddress, ReasonEnded.REJECTED_BY_SERVER, 0);
1168         payOut(game, _playerAddress);
1169 
1170         LogGameRejected(_playerAddress, gameId);
1171     }
1172 
1173     /**
1174      * @dev Called by server to accept game session created by player with
1175      * address _playerAddress.
1176      * @param _playerAddress Player's address who created the game.
1177      * @param _gameId Game id of game session.
1178      * @param _endHash Last hash of the hash chain generated by the server.
1179      */
1180     function acceptGame(address _playerAddress, uint _gameId, bytes32 _endHash)
1181         public
1182         onlyServer
1183     {
1184         uint gameId = playerGameId[_playerAddress];
1185         Game storage game = gameIdGame[gameId];
1186 
1187         require(_gameId == gameId);
1188         require(game.status == GameStatus.WAITING_FOR_SERVER);
1189 
1190         game.status = GameStatus.ACTIVE;
1191 
1192         LogGameAccepted(_playerAddress, gameId, _endHash);
1193     }
1194 
1195     /**
1196      * @dev Regular end game session. Used if player and house have both
1197      * accepted current game session state.
1198      * The game session with gameId _gameId is closed
1199      * and the player paid out. This functions is called by the server after
1200      * the player requested the termination of the current game session.
1201      * @param _roundId Round id of bet.
1202      * @param _gameType Game type of bet.
1203      * @param _num Number of bet.
1204      * @param _value Value of bet.
1205      * @param _balance Current balance.
1206      * @param _serverHash Hash of server's seed for this bet.
1207      * @param _playerHash Hash of player's seed for this bet.
1208      * @param _gameId Game session id.
1209      * @param _contractAddress Address of this contract.
1210      * @param _playerAddress Address of player.
1211      * @param _playerSig Player's signature of this bet.
1212      */
1213     function serverEndGame(
1214         uint32 _roundId,
1215         uint8 _gameType,
1216         uint16 _num,
1217         uint _value,
1218         int _balance,
1219         bytes32 _serverHash,
1220         bytes32 _playerHash,
1221         uint _gameId,
1222         address _contractAddress,
1223         address _playerAddress,
1224         bytes _playerSig
1225     )
1226         public
1227         onlyServer
1228     {
1229         verifySig(
1230                 _roundId,
1231                 _gameType,
1232                 _num,
1233                 _value,
1234                 _balance,
1235                 _serverHash,
1236                 _playerHash,
1237                 _gameId,
1238                 _contractAddress,
1239                 _playerSig,
1240                 _playerAddress
1241         );
1242 
1243         regularEndGame(_playerAddress, _roundId, _gameType, _num, _value, _balance, _gameId, _contractAddress);
1244     }
1245 
1246     /**
1247      * @notice Regular end game session. Normally not needed as server ends game (@see serverEndGame).
1248      * Can be used by player if server does not end game session.
1249      * @param _roundId Round id of bet.
1250      * @param _gameType Game type of bet.
1251      * @param _num Number of bet.
1252      * @param _value Value of bet.
1253      * @param _balance Current balance.
1254      * @param _serverHash Hash of server's seed for this bet.
1255      * @param _playerHash Hash of player's seed for this bet.
1256      * @param _gameId Game session id.
1257      * @param _contractAddress Address of this contract.
1258      * @param _serverSig Server's signature of this bet.
1259      */
1260     function playerEndGame(
1261         uint32 _roundId,
1262         uint8 _gameType,
1263         uint16 _num,
1264         uint _value,
1265         int _balance,
1266         bytes32 _serverHash,
1267         bytes32 _playerHash,
1268         uint _gameId,
1269         address _contractAddress,
1270         bytes _serverSig
1271     )
1272         public
1273     {
1274         verifySig(
1275                 _roundId,
1276                 _gameType,
1277                 _num,
1278                 _value,
1279                 _balance,
1280                 _serverHash,
1281                 _playerHash,
1282                 _gameId,
1283                 _contractAddress,
1284                 _serverSig,
1285                 serverAddress
1286         );
1287 
1288         regularEndGame(msg.sender, _roundId, _gameType, _num, _value, _balance, _gameId, _contractAddress);
1289     }
1290 
1291     /**
1292      * @dev Regular end game session implementation. Used if player and house have both
1293      * accepted current game session state. The game session with gameId _gameId is closed
1294      * and the player paid out.
1295      * @param _playerAddress Address of player.
1296      * @param _gameType Game type of bet.
1297      * @param _num Number of bet.
1298      * @param _value Value of bet.
1299      * @param _balance Current balance.
1300      * @param _gameId Game session id.
1301      * @param _contractAddress Address of this contract.
1302      */
1303     function regularEndGame(
1304         address _playerAddress,
1305         uint32 _roundId,
1306         uint8 _gameType,
1307         uint16 _num,
1308         uint _value,
1309         int _balance,
1310         uint _gameId,
1311         address _contractAddress
1312     )
1313         private
1314     {
1315         uint gameId = playerGameId[_playerAddress];
1316         Game storage game = gameIdGame[gameId];
1317         address contractAddress = this;
1318         int maxBalance = conflictRes.maxBalance();
1319 
1320         require(_gameId == gameId);
1321         require(_roundId > 0);
1322         // save to cast as game.stake hash fixed range
1323         require(-int(game.stake) <= _balance && _balance <= maxBalance);
1324         require((_gameType == 0) && (_num == 0) && (_value == 0));
1325         require(_contractAddress == contractAddress);
1326         require(game.status == GameStatus.ACTIVE);
1327 
1328         closeGame(game, gameId, _playerAddress, ReasonEnded.REGULAR_ENDED, _balance);
1329         payOut(game, _playerAddress);
1330     }
1331 }