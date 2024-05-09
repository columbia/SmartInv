1 /*
2 
3     Copyright 2020 dYdX Trading Inc.
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.16;
20 pragma experimental ABIEncoderV2;
21 
22 // File: @openzeppelin/contracts/GSN/Context.sol
23 
24 /*
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with GSN meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 contract Context {
35     // Empty internal constructor, to prevent people from mistakenly deploying
36     // an instance of this contract, which should be used via inheritance.
37     constructor () internal { }
38     // solhint-disable-previous-line no-empty-blocks
39 
40     function _msgSender() internal view returns (address payable) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view returns (bytes memory) {
45         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
46         return msg.data;
47     }
48 }
49 
50 // File: @openzeppelin/contracts/ownership/Ownable.sol
51 
52 /**
53  * @dev Contract module which provides a basic access control mechanism, where
54  * there is an account (an owner) that can be granted exclusive access to
55  * specific functions.
56  *
57  * This module is used through inheritance. It will make available the modifier
58  * `onlyOwner`, which can be applied to your functions to restrict their use to
59  * the owner.
60  */
61 contract Ownable is Context {
62     address private _owner;
63 
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     /**
67      * @dev Initializes the contract setting the deployer as the initial owner.
68      */
69     constructor () internal {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     /**
76      * @dev Returns the address of the current owner.
77      */
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     /**
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOwner() {
86         require(isOwner(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     /**
91      * @dev Returns true if the caller is the current owner.
92      */
93     function isOwner() public view returns (bool) {
94         return _msgSender() == _owner;
95     }
96 
97     /**
98      * @dev Leaves the contract without owner. It will not be possible to call
99      * `onlyOwner` functions anymore. Can only be called by the current owner.
100      *
101      * NOTE: Renouncing ownership will leave the contract without an owner,
102      * thereby removing any functionality that is only available to the owner.
103      */
104     function renounceOwnership() public onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Can only be called by the current owner.
112      */
113     function transferOwnership(address newOwner) public onlyOwner {
114         _transferOwnership(newOwner);
115     }
116 
117     /**
118      * @dev Transfers ownership of the contract to a new account (`newOwner`).
119      */
120     function _transferOwnership(address newOwner) internal {
121         require(newOwner != address(0), "Ownable: new owner is the zero address");
122         emit OwnershipTransferred(_owner, newOwner);
123         _owner = newOwner;
124     }
125 }
126 
127 // File: contracts/external/maker/I_MakerOracle.sol
128 
129 /**
130  * @title I_MakerOracle
131  * @author dYdX
132  *
133  * Interface for the MakerDAO Oracles V2 smart contrats.
134  */
135 interface I_MakerOracle {
136 
137     // ============ Getter Functions ============
138 
139     /**
140      * @notice Returns the current value as a bytes32.
141      */
142     function peek()
143         external
144         view
145         returns (bytes32, bool);
146 
147     /**
148      * @notice Requires a fresh price and then returns the current value.
149      */
150     function read()
151         external
152         view
153         returns (bytes32);
154 
155     /**
156      * @notice Returns the number of signers per poke.
157      */
158     function bar()
159         external
160         view
161         returns (uint256);
162 
163     /**
164      * @notice Returns the timetamp of the last update.
165      */
166     function age()
167         external
168         view
169         returns (uint32);
170 
171     /**
172      * @notice Returns 1 if the signer is authorized, and 0 otherwise.
173      */
174     function orcl(
175         address signer
176     )
177         external
178         view
179         returns (uint256);
180 
181     /**
182      * @notice Returns 1 if the address is authorized to read the oracle price, and 0 otherwise.
183      */
184     function bud(
185         address reader
186     )
187         external
188         view
189         returns (uint256);
190 
191     /**
192      * @notice A mapping from the first byte of an authorized signer's address to the signer.
193      */
194     function slot(
195         uint8 signerId
196     )
197         external
198         view
199         returns (address);
200 
201     // ============ State-Changing Functions ============
202 
203     /**
204      * @notice Updates the value of the oracle
205      */
206     function poke(
207         uint256[] calldata val_,
208         uint256[] calldata age_,
209         uint8[] calldata v,
210         bytes32[] calldata r,
211         bytes32[] calldata s
212     )
213         external;
214 
215     /**
216      * @notice Authorize an address to read the oracle price.
217      */
218     function kiss(
219         address reader
220     )
221         external;
222 
223     /**
224      * @notice Unauthorize an address so it can no longer read the oracle price.
225      */
226     function diss(
227         address reader
228     )
229         external;
230 
231     /**
232      * @notice Authorize addresses to read the oracle price.
233      */
234     function kiss(
235         address[] calldata readers
236     )
237         external;
238 
239     /**
240      * @notice Unauthorize addresses so they can no longer read the oracle price.
241      */
242     function diss(
243         address[] calldata readers
244     )
245         external;
246 }
247 
248 // File: contracts/protocol/v1/oracles/P1MirrorOracle.sol
249 
250 /**
251  * @title P1MirrorOracle
252  * @author dYdX
253  *
254  * Oracle which mirrors an underlying oracle.
255  */
256 contract P1MirrorOracle is
257     Ownable,
258     I_MakerOracle
259 {
260     // ============ Events ============
261 
262     event LogMedianPrice(
263         uint256 val,
264         uint256 age
265     );
266 
267     event LogSetSigner(
268         address signer,
269         bool authorized
270     );
271 
272     event LogSetBar(
273         uint256 bar
274     );
275 
276     event LogSetReader(
277         address reader,
278         bool authorized
279     );
280 
281     // ============ Mutable Storage ============
282 
283     // The oracle price.
284     uint128 internal _VAL_;
285 
286     // The timestamp of the last oracle update.
287     uint32 public _AGE_;
288 
289     // The number of signers required to update the oracle price.
290     uint256 public _BAR_;
291 
292     // Authorized signers. Value is equal to 0 or 1.
293     mapping (address => uint256) public _ORCL_;
294 
295     // Addresses with permission to get the oracle price. Value is equal to 0 or 1.
296     mapping (address => uint256) _READERS_;
297 
298     // Mapping for at most 256 signers.
299     // Each signer is identified by the first byte of their address.
300     mapping (uint8 => address) public _SLOT_;
301 
302     // ============ Immutable Storage ============
303 
304     // The underlying oracle.
305     address public _ORACLE_;
306 
307     // ============ Constructor ============
308 
309     constructor(
310         address oracle
311     )
312         public
313     {
314         _ORACLE_ = oracle;
315     }
316 
317     // ============ Getter Functions ============
318 
319     /**
320      * @notice Returns the current price, and a boolean indicating whether the price is nonzero.
321      */
322     function peek()
323         external
324         view
325         returns (bytes32, bool)
326     {
327         require(
328             _READERS_[msg.sender] == 1,
329             "P1MirrorOracle#peek: Sender not authorized to get price"
330         );
331         uint256 val = _VAL_;
332         return (bytes32(val), val > 0);
333     }
334 
335     /**
336      * @notice Requires the price to be nonzero, and returns the current price.
337      */
338     function read()
339         external
340         view
341         returns (bytes32)
342     {
343         require(
344             _READERS_[msg.sender] == 1,
345             "P1MirrorOracle#read: Sender not authorized to get price"
346         );
347         uint256 val = _VAL_;
348         require(
349             val > 0,
350             "P1MirrorOracle#read: Price is zero"
351         );
352         return bytes32(val);
353     }
354 
355     /**
356      * @notice Returns the number of signers per poke.
357      */
358     function bar()
359         external
360         view
361         returns (uint256)
362     {
363         return _BAR_;
364     }
365 
366     /**
367      * @notice Returns the timetamp of the last update.
368      */
369     function age()
370         external
371         view
372         returns (uint32)
373     {
374         return _AGE_;
375     }
376 
377     /**
378      * @notice Returns 1 if the signer is authorized, and 0 otherwise.
379      */
380     function orcl(
381         address signer
382     )
383         external
384         view
385         returns (uint256)
386     {
387         return _ORCL_[signer];
388     }
389 
390     /**
391      * @notice Returns 1 if the address is authorized to read the oracle price, and 0 otherwise.
392      */
393     function bud(
394         address reader
395     )
396         external
397         view
398         returns (uint256)
399     {
400         return _READERS_[reader];
401     }
402 
403     /**
404      * @notice A mapping from the first byte of an authorized signer's address to the signer.
405      */
406     function slot(
407         uint8 signerId
408     )
409         external
410         view
411         returns (address)
412     {
413         return _SLOT_[signerId];
414     }
415 
416     /**
417      * @notice Check whether the list of signers and required number of signers match the underlying
418      *  oracle.
419      *
420      * @return A bitmap of the IDs of signers that need to be added to the mirror.
421      * @return A bitmap of the IDs of signers that need to be removed from the mirror.
422      * @return False if the required number of signers (“bar”) matches, and true otherwise.
423      */
424     function checkSynced()
425         external
426         view
427         returns (uint256, uint256, bool)
428     {
429         uint256 signersToAdd = 0;
430         uint256 signersToRemove = 0;
431         bool barNeedsUpdate = _BAR_ != I_MakerOracle(_ORACLE_).bar();
432 
433         // Note that `i` cannot be a uint8 since it is incremented to 256 at the end of the loop.
434         for (uint256 i = 0; i < 256; i++) {
435             uint8 signerId = uint8(i);
436             uint256 signerBit = uint256(1) << signerId;
437             address ours = _SLOT_[signerId];
438             address theirs = I_MakerOracle(_ORACLE_).slot(signerId);
439             if (ours == address(0)) {
440                 if (theirs != address(0)) {
441                     signersToAdd = signersToAdd | signerBit;
442                 }
443             } else {
444                 if (theirs == address(0)) {
445                     signersToRemove = signersToRemove | signerBit;
446                 } else if (ours != theirs) {
447                     signersToAdd = signersToAdd | signerBit;
448                     signersToRemove = signersToRemove | signerBit;
449                 }
450             }
451         }
452 
453         return (signersToAdd, signersToRemove, barNeedsUpdate);
454     }
455 
456     // ============ State-Changing Functions ============
457 
458     /**
459      * @notice Send an array of signed messages to update the oracle value.
460      *  Must have exactly `_BAR_` number of messages.
461      */
462     function poke(
463         uint256[] calldata val_,
464         uint256[] calldata age_,
465         uint8[] calldata v,
466         bytes32[] calldata r,
467         bytes32[] calldata s
468     )
469         external
470     {
471         require(val_.length == _BAR_, "P1MirrorOracle#poke: Wrong number of messages");
472 
473         // Bitmap of signers, used to ensure that each message has a different signer.
474         uint256 bloom = 0;
475 
476         // Last message value, used to ensure messages are ordered by value.
477         uint256 last = 0;
478 
479         // Require that all messages are newer than the last oracle update.
480         uint256 zzz = _AGE_;
481 
482         for (uint256 i = 0; i < val_.length; i++) {
483             uint256 val_i = val_[i];
484             uint256 age_i = age_[i];
485 
486             // Verify that the message comes from an authorized signer.
487             address signer = recover(
488                 val_i,
489                 age_i,
490                 v[i],
491                 r[i],
492                 s[i]
493             );
494             require(_ORCL_[signer] == 1, "P1MirrorOracle#poke: Invalid signer");
495 
496             // Verify that the message is newer than the last oracle update.
497             require(age_i > zzz, "P1MirrorOracle#poke: Stale message");
498 
499             // Verify that the messages are ordered by value.
500             require(val_i >= last, "P1MirrorOracle#poke: Message out of order");
501             last = val_i;
502 
503             // Verify that each message has a different signer.
504             // Each signer is identified by the first byte of their address.
505             uint8 signerId = getSignerId(signer);
506             uint256 signerBit = uint256(1) << signerId;
507             require(bloom & signerBit == 0, "P1MirrorOracle#poke: Duplicate signer");
508             bloom = bloom | signerBit;
509         }
510 
511         // Set the oracle value to the median (note that val_.length is always odd).
512         _VAL_ = uint128(val_[val_.length >> 1]);
513 
514         // Set the timestamp of the oracle update.
515         _AGE_ = uint32(block.timestamp);
516 
517         emit LogMedianPrice(_VAL_, _AGE_);
518     }
519 
520     /**
521      * @notice Authorize new signers. The signers must be authorized on the underlying oracle.
522      */
523     function lift(
524         address[] calldata signers
525     )
526         external
527     {
528         for (uint256 i = 0; i < signers.length; i++) {
529             address signer = signers[i];
530             require(
531                 I_MakerOracle(_ORACLE_).orcl(signer) == 1,
532                 "P1MirrorOracle#lift: Signer not authorized on underlying oracle"
533             );
534 
535             // orcl and slot must both be empty.
536             // orcl is filled implies slot is filled, therefore slot is empty implies orcl is empty.
537             // Assume that the underlying oracle ensures that the signer cannot be the zero address.
538             uint8 signerId = getSignerId(signer);
539             require(
540                 _SLOT_[signerId] == address(0),
541                 "P1MirrorOracle#lift: Signer already authorized"
542             );
543 
544             _ORCL_[signer] = 1;
545             _SLOT_[signerId] = signer;
546 
547             emit LogSetSigner(signer, true);
548         }
549     }
550 
551     /**
552      * @notice Unauthorize signers. The signers must NOT be authorized on the underlying oracle.
553      */
554     function drop(
555         address[] calldata signers
556     )
557         external
558     {
559         for (uint256 i = 0; i < signers.length; i++) {
560             address signer = signers[i];
561             require(
562                 I_MakerOracle(_ORACLE_).orcl(signer) == 0,
563                 "P1MirrorOracle#drop: Signer is authorized on underlying oracle"
564             );
565 
566             // orcl and slot must both be filled.
567             // orcl is filled implies slot is filled.
568             require(
569                 _ORCL_[signer] != 0,
570                 "P1MirrorOracle#drop: Signer is already not authorized"
571             );
572 
573             uint8 signerId = getSignerId(signer);
574             _ORCL_[signer] = 0;
575             _SLOT_[signerId] = address(0);
576 
577             emit LogSetSigner(signer, false);
578         }
579     }
580 
581     /**
582      * @notice Sync `_BAR_` (the number of required signers) with the underyling oracle contract.
583      */
584     function setBar()
585         external
586     {
587         uint256 newBar = I_MakerOracle(_ORACLE_).bar();
588         _BAR_ = newBar;
589         emit LogSetBar(newBar);
590     }
591 
592     /**
593      * @notice Authorize an address to read the oracle price.
594      */
595     function kiss(
596         address reader
597     )
598         external
599         onlyOwner
600     {
601         _kiss(reader);
602     }
603 
604     /**
605      * @notice Unauthorize an address so it can no longer read the oracle price.
606      */
607     function diss(
608         address reader
609     )
610         external
611         onlyOwner
612     {
613         _diss(reader);
614     }
615 
616     /**
617      * @notice Authorize addresses to read the oracle price.
618      */
619     function kiss(
620         address[] calldata readers
621     )
622         external
623         onlyOwner
624     {
625         for (uint256 i = 0; i < readers.length; i++) {
626             _kiss(readers[i]);
627         }
628     }
629 
630     /**
631      * @notice Unauthorize addresses so they can no longer read the oracle price.
632      */
633     function diss(
634         address[] calldata readers
635     )
636         external
637         onlyOwner
638     {
639         for (uint256 i = 0; i < readers.length; i++) {
640             _diss(readers[i]);
641         }
642     }
643 
644     // ============ Internal Functions ============
645 
646     function wat()
647         internal
648         pure
649         returns (bytes32);
650 
651     function recover(
652         uint256 val_,
653         uint256 age_,
654         uint8 v,
655         bytes32 r,
656         bytes32 s
657     )
658         internal
659         pure
660         returns (address)
661     {
662         return ecrecover(
663             keccak256(
664                 abi.encodePacked("\x19Ethereum Signed Message:\n32",
665                 keccak256(abi.encodePacked(val_, age_, wat())))
666             ),
667             v,
668             r,
669             s
670         );
671     }
672 
673     function getSignerId(
674         address signer
675     )
676         internal
677         pure
678         returns (uint8)
679     {
680         return uint8(uint256(signer) >> 152);
681     }
682 
683     function _kiss(
684         address reader
685     )
686         private
687     {
688         _READERS_[reader] = 1;
689         emit LogSetReader(reader, true);
690     }
691 
692     function _diss(
693         address reader
694     )
695         private
696     {
697         _READERS_[reader] = 0;
698         emit LogSetReader(reader, false);
699     }
700 }
701 
702 // File: contracts/protocol/v1/oracles/P1MirrorOracleETHUSD.sol
703 
704 /**
705  * @title P1MirrorOracleETHUSD
706  * @author dYdX
707  *
708  * Oracle which mirrors the ETHUSD oracle.
709  */
710 contract P1MirrorOracleETHUSD is
711     P1MirrorOracle
712 {
713     bytes32 public constant WAT = "ETHUSD";
714 
715     constructor(
716         address oracle
717     )
718         P1MirrorOracle(oracle)
719         public
720     {
721     }
722 
723     function wat()
724         internal
725         pure
726         returns (bytes32)
727     {
728         return WAT;
729     }
730 }