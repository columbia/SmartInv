1 // File: contracts/commons/Ownable.sol
2 
3 pragma solidity ^0.5.12;
4 
5 
6 contract Ownable {
7     address internal _owner;
8 
9     event OwnershipTransferred(address indexed _from, address indexed _to);
10 
11     modifier onlyOwner() {
12         require(msg.sender == _owner, "The owner should be the sender");
13         _;
14     }
15 
16     constructor() public {
17         _owner = msg.sender;
18         emit OwnershipTransferred(address(0x0), msg.sender);
19     }
20 
21     function owner() external view returns (address) {
22         return _owner;
23     }
24 
25     /**
26         @dev Transfers the ownership of the contract.
27         @param _newOwner Address of the new owner
28     */
29     function transferOwnership(address _newOwner) external onlyOwner {
30         require(_newOwner != address(0), "0x0 Is not a valid owner");
31         emit OwnershipTransferred(_owner, _newOwner);
32         _owner = _newOwner;
33     }
34 }
35 
36 // File: contracts/utils/Math.sol
37 
38 pragma solidity ^0.5.12;
39 
40 
41 library Math {
42     function average(uint256 a, uint256 b) internal pure returns (uint256) {
43         // (a + b) / 2 can overflow, so we distribute
44         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
45     }
46 }
47 
48 // File: contracts/commons/SortedList.sol
49 
50 pragma solidity 0.5.12;
51 
52 
53 
54 /**
55  * @title SortedList
56  * @author Joaquin Gonzalez & Agustin Aguilar (jpgonzalezra@gmail.com & agusxrun@gmail.com)
57  * @dev An utility library for using sorted list data structures.
58  */
59 library SortedList {
60     using SortedList for SortedList.List;
61 
62     uint256 private constant HEAD = 0;
63 
64     struct List {
65         uint256 size;
66         mapping(uint256 => uint256) values;
67         mapping(uint256 => uint256) links;
68         mapping(uint256 => bool) exists;
69     }
70 
71     /**
72      * @dev Returns the value of a `_node`
73      * @param self stored linked list from contract
74      * @param _node a node to search value of
75      * @return value of the node
76      */
77     function get(List storage self, uint256 _node) internal view returns (uint256) {
78         return self.values[_node];
79     }
80 
81     /**
82      * @dev Insert node `_node` with a value
83      * @param self stored linked list from contract
84      * @param _node new node to insert
85      * @param _value value of the new `_node` to insert
86      * @notice If the `_node` does not exists, it's added to the list
87      *   if the `_node` already exists, it updates its value.
88      */
89     function set(List storage self, uint256 _node, uint256 _value) internal {
90         // Check if node previusly existed
91         if (self.exists[_node]) {
92 
93             // Load the new and old position
94             (uint256 leftOldPos, uint256 leftNewPos) = self.findOldAndNewLeftPosition(_node, _value);
95 
96             // If node position changed, we need to re-do the linking
97             if (leftOldPos != leftNewPos && _node != leftNewPos) {
98                 // Remove prev link
99                 self.links[leftOldPos] = self.links[_node];
100 
101                 // Create new link
102                 uint256 next = self.links[leftNewPos];
103                 self.links[leftNewPos] = _node;
104                 self.links[_node] = next;
105             }
106         } else {
107             // Update size of the list
108             self.size = self.size + 1;
109             // Set node as existing
110             self.exists[_node] = true;
111             // Find position for the new node and update the links
112             uint256 leftPosition = self.findLeftPosition(_value);
113             uint256 next = self.links[leftPosition];
114             self.links[leftPosition] = _node;
115             self.links[_node] = next;
116         }
117 
118         // Set the value for the node
119         self.values[_node] = _value;
120     }
121 
122     /**
123      * @dev Returns the previus node of a given `_node`
124      *   alongside to the previus node of a hypothetical new `_value`
125      * @param self stored linked list from contract
126      * @param _node a node to search for its left node
127      * @param _value a value to seach for its hypothetical left node
128      * @return `leftNodePost` the node previus to the given `_node` and
129      *   `leftValPost` the node previus to the hypothetical new `_value`
130      * @notice This method performs two seemingly unrelated tasks at the same time
131      *   because both of those tasks require a list iteration, thus saving gas.
132      */
133     function findOldAndNewLeftPosition(
134         List storage self,
135         uint256 _node,
136         uint256 _value
137     ) internal view returns (
138         uint256 leftNodePos,
139         uint256 leftValPos
140     ) {
141         // Find old and new value positions
142         bool foundNode;
143         bool foundVal;
144 
145         // Iterate links
146         uint256 c = HEAD;
147         while (!foundNode || !foundVal) {
148             uint256 next = self.links[c];
149 
150             // We should have found the old position
151             // the new one must be at the end
152             if (next == 0) {
153                 leftValPos = c;
154                 break;
155             }
156 
157             // If the next node is the current node
158             // we found the old position
159             if (next == _node) {
160                 leftNodePos = c;
161                 foundNode = true;
162             }
163 
164             // If the next value is higher and we didn't found one yet
165             // the next value if the position
166             if (self.values[next] > _value && !foundVal) {
167                 leftValPos = c;
168                 foundVal = true;
169             }
170 
171             c = next;
172         }
173     }
174 
175     /**
176      * @dev Get the left node for a given hypothetical `_value`
177      * @param self stored linked list from contract
178      * @param _value value to seek
179      * @return uint256 left node for the given value
180      */
181     function findLeftPosition(List storage self, uint256 _value) internal view returns (uint256) {
182         uint256 next = HEAD;
183         uint256 c;
184 
185         do {
186             c = next;
187             next = self.links[c];
188         } while(self.values[next] < _value && next != 0);
189 
190         return c;
191     }
192 
193     /**
194      * @dev Get the node on a given `_position`
195      * @param self stored linked list from contract
196      * @param _position node position to retrieve
197      * @return the node key
198      */
199     function nodeAt(List storage self, uint256 _position) internal view returns (uint256) {
200         uint256 next = self.links[HEAD];
201         for (uint256 i = 0; i < _position; i++) {
202             next = self.links[next];
203         }
204 
205         return next;
206     }
207 
208     /**
209      * @dev Removes an entry from the sorted list
210      * @param self stored linked list from contract
211      * @param _node node to remove from the list
212      */
213     function remove(List storage self, uint256 _node) internal {
214         require(self.exists[_node], "the node does not exists");
215 
216         uint256 c = self.links[HEAD];
217         while (c != 0) {
218             uint256 next = self.links[c];
219             if (next == _node) {
220                 break;
221             }
222 
223             c = next;
224         }
225 
226         self.size -= 1;
227         self.exists[_node] = false;
228         self.links[c] = self.links[_node];
229         delete self.links[_node];
230         delete self.values[_node];
231     }
232 
233     /**
234      * @dev Get median beetween entry from the sorted list
235      * @param self stored linked list from contract
236      * @return uint256 the median
237      */
238     function median(List storage self) internal view returns (uint256) {
239         uint256 elements = self.size;
240         if (elements % 2 == 0) {
241             uint256 node = self.nodeAt(elements / 2 - 1);
242             return Math.average(self.values[node], self.values[self.links[node]]);
243         } else {
244             return self.values[self.nodeAt(elements / 2)];
245         }
246     }
247 }
248 
249 // File: contracts/interfaces/RateOracle.sol
250 
251 pragma solidity ^0.5.12;
252 
253 
254 /**
255     @dev Defines the interface of a standard Diaspore RCN Oracle,
256     The contract should also implement it's ERC165 interface: 0xa265d8e0
257     @notice Each oracle can only support one currency
258     @author Agustin Aguilar
259 */
260 contract RateOracle {
261     uint256 public constant VERSION = 5;
262     bytes4 internal constant RATE_ORACLE_INTERFACE = 0xa265d8e0;
263 
264     /**
265         3 or 4 letters symbol of the currency, Ej: ETH
266     */
267     function symbol() external view returns (string memory);
268 
269     /**
270         Descriptive name of the currency, Ej: Ethereum
271     */
272     function name() external view returns (string memory);
273 
274     /**
275         The number of decimals of the currency represented by this Oracle,
276             it should be the most common number of decimal places
277     */
278     function decimals() external view returns (uint256);
279 
280     /**
281         The base token on which the sample is returned
282             should be the RCN Token address.
283     */
284     function token() external view returns (address);
285 
286     /**
287         The currency symbol encoded on a UTF-8 Hex
288     */
289     function currency() external view returns (bytes32);
290 
291     /**
292         The name of the Individual or Company in charge of this Oracle
293     */
294     function maintainer() external view returns (string memory);
295 
296     /**
297         Returns the url where the oracle exposes a valid "oracleData" if needed
298     */
299     function url() external view returns (string memory);
300 
301     /**
302         Returns a sample on how many token() are equals to how many currency()
303     */
304     function readSample(bytes calldata _data) external view returns (uint256 _tokens, uint256 _equivalent);
305 }
306 
307 // File: contracts/interfaces/PausedProvider.sol
308 
309 pragma solidity ^0.5.12;
310 
311 
312 interface PausedProvider {
313     function isPaused() external view returns (bool);
314 }
315 
316 // File: contracts/commons/Pausable.sol
317 
318 pragma solidity ^0.5.12;
319 
320 
321 
322 contract Pausable is Ownable {
323     mapping(address => bool) public canPause;
324     bool public paused;
325 
326     event Paused();
327     event Started();
328     event CanPause(address _pauser, bool _enabled);
329 
330     function setPauser(address _pauser, bool _enabled) external onlyOwner {
331         canPause[_pauser] = _enabled;
332         emit CanPause(_pauser, _enabled);
333     }
334 
335     function pause() external {
336         require(!paused, "already paused");
337 
338         require(
339             msg.sender == _owner ||
340             canPause[msg.sender],
341             "not authorized to pause"
342         );
343 
344         paused = true;
345         emit Paused();
346     }
347 
348     function start() external onlyOwner {
349         require(paused, "not paused");
350         paused = false;
351         emit Started();
352     }
353 }
354 
355 // File: contracts/utils/StringUtils.sol
356 
357 pragma solidity ^0.5.12;
358 
359 
360 library StringUtils {
361     function toBytes32(string memory _a) internal pure returns (bytes32 b) {
362         require(bytes(_a).length <= 32, "string too long");
363 
364         assembly {
365             let bi := mul(mload(_a), 8)
366             b := and(mload(add(_a, 32)), shl(sub(256, bi), sub(exp(2, bi), 1)))
367         }
368     }
369 }
370 
371 // File: contracts/MultiSourceOracle.sol
372 
373 pragma solidity ^0.5.12;
374 
375 
376 
377 
378 
379 
380 
381 
382 
383 contract MultiSourceOracle is RateOracle, Ownable, Pausable {
384     using SortedList for SortedList.List;
385     using StringUtils for string;
386 
387     uint256 public constant BASE = 10 ** 36;
388 
389     mapping(address => bool) public isSigner;
390     mapping(address => string) public nameOfSigner;
391     mapping(string => address) public signerWithName;
392 
393     SortedList.List private list;
394     RateOracle public upgrade;
395     PausedProvider public pausedProvider;
396 
397     string private isymbol;
398     string private iname;
399     uint256 private idecimals;
400     address private itoken;
401     bytes32 private icurrency;
402     string private imaintainer;
403 
404     constructor(
405         string memory _symbol,
406         string memory _name,
407         uint256 _decimals,
408         address _token,
409         string memory _maintainer
410     ) public {
411         // Create legacy bytes32 currency
412         bytes32 currency = _symbol.toBytes32();
413         // Save Oracle metadata
414         isymbol = _symbol;
415         iname = _name;
416         idecimals = _decimals;
417         itoken = _token;
418         icurrency = currency;
419         imaintainer = _maintainer;
420         pausedProvider = PausedProvider(msg.sender);
421     }
422 
423     function providedBy(address _signer) external view returns (uint256) {
424         return list.get(uint256(_signer));
425     }
426 
427     /**
428      * @return metadata, 3 or 4 letter symbol of the currency provided by this oracle
429      *   (ej: ARS)
430      * @notice Defined by the RCN RateOracle interface
431      */
432     function symbol() external view returns (string memory) {
433         return isymbol;
434     }
435 
436     /**
437      * @return metadata, full name of the currency provided by this oracle
438      *   (ej: Argentine Peso)
439      * @notice Defined by the RCN RateOracle interface
440      */
441     function name() external view returns (string memory) {
442         return iname;
443     }
444 
445     /**
446      * @return metadata, decimals to express the common denomination
447      *   of the currency provided by this oracle
448      * @notice Defined by the RCN RateOracle interface
449      */
450     function decimals() external view returns (uint256) {
451         return idecimals;
452     }
453 
454     /**
455      * @return metadata, token address of the currency provided by this oracle
456      * @notice Defined by the RCN RateOracle interface
457      */
458     function token() external view returns (address) {
459         return itoken;
460     }
461 
462     /**
463      * @return metadata, bytes32 code of the currency provided by this oracle
464      * @notice Defined by the RCN RateOracle interface
465      */
466     function currency() external view returns (bytes32) {
467         return icurrency;
468     }
469 
470     /**
471      * @return metadata, human readable name of the entity maintainer of this oracle
472      * @notice Defined by the RCN RateOracle interface
473      */
474     function maintainer() external view returns (string memory) {
475         return imaintainer;
476     }
477 
478     /**
479      * @dev Returns the URL required to retrieve the auxiliary data
480      *   as specified by the RateOracle spec, no auxiliary data is required
481      *   so it returns an empty string.
482      * @return An empty string, because the auxiliary data is not required
483      * @notice Defined by the RCN RateOracle interface
484      */
485     function url() external view returns (string memory) {
486         return "";
487     }
488 
489     /**
490      * @dev Updates the medatada of the oracle
491      * @param _name Name of the oracle currency
492      * @param _decimals Decimals for the common representation of the currency
493      * @param _maintainer Name of the maintainer entity of the Oracle
494      */
495     function setMetadata(
496         string calldata _name,
497         uint256 _decimals,
498         string calldata _maintainer
499     ) external onlyOwner {
500         iname = _name;
501         idecimals = _decimals;
502         imaintainer = _maintainer;
503     }
504 
505     /**
506      * @dev Updates the Oracle contract, all subsequent calls to `readSample` will be forwareded to `_upgrade`
507      * @param _upgrade Contract address of the new updated oracle
508      * @notice If the `upgrade` address is set to the address `0` the Oracle is considered not upgraded
509      */
510     function setUpgrade(RateOracle _upgrade) external onlyOwner {
511         upgrade = _upgrade;
512     }
513 
514     /**
515      * @dev Adds a `_signer` who is going to be able to provide a new rate
516      * @param _signer Address of the signer
517      * @param _name Metadata - Human readable name of the signer
518      */
519     function addSigner(address _signer, string calldata _name) external onlyOwner {
520         require(!isSigner[_signer], "signer already defined");
521         require(signerWithName[_name] == address(0), "name already in use");
522         require(bytes(_name).length > 0, "name can't be empty");
523         isSigner[_signer] = true;
524         signerWithName[_name] = _signer;
525         nameOfSigner[_signer] = _name;
526     }
527 
528     /**
529      * @dev Updates the `_name` metadata of a given `_signer`
530      * @param _signer Address of the signer
531      * @param _name Metadata - Human readable name of the signer
532      */
533     function setName(address _signer, string calldata _name) external onlyOwner {
534         require(isSigner[_signer], "signer not defined");
535         require(signerWithName[_name] == address(0), "name already in use");
536         require(bytes(_name).length > 0, "name can't be empty");
537         string memory oldName = nameOfSigner[_signer];
538         signerWithName[oldName] = address(0);
539         signerWithName[_name] = _signer;
540         nameOfSigner[_signer] = _name;
541     }
542 
543     /**
544      * @dev Removes an existing `_signer`, removing any provided rate
545      * @param _signer Address of the signer
546      */
547     function removeSigner(address _signer) external onlyOwner {
548         require(isSigner[_signer], "address is not a signer");
549         string memory signerName = nameOfSigner[_signer];
550 
551         isSigner[_signer] = false;
552         signerWithName[signerName] = address(0);
553         nameOfSigner[_signer] = "";
554 
555         // Only remove from list if it provided a value
556         if (list.exists[uint256(_signer)]) {
557             list.remove(uint256(_signer));
558         }
559     }
560 
561     /**
562      * @dev Provides a `_rate` for a given `_signer`
563      * @param _signer Address of the signer who is providing the rate
564      * @param _rate Rate to be provided
565      * @notice This method can only be called by the Owner and not by the signer
566      *   this is intended to allow the `OracleFactory.sol` to provide multiple rates
567      *   on a single call. The `OracleFactory.sol` contract has the responsability of
568      *   validating the signer address.
569      */
570     function provide(address _signer, uint256 _rate) external onlyOwner {
571         require(isSigner[_signer], "signer not valid");
572         require(_rate != 0, "rate can't be zero");
573         list.set(uint256(_signer), _rate);
574     }
575 
576     /**
577      * @dev Reads the rate provided by the Oracle
578      *   this being the median of the last rate provided by each signer
579      * @param _oracleData Oracle auxiliar data defined in the RCN Oracle spec
580      *   not used for this oracle, but forwarded in case of upgrade.
581      * @return `_equivalent` is the median of the values provided by the signer
582      *   `_tokens` are equivalent to `_equivalent` in the currency of the Oracle
583      */
584     function readSample(bytes memory _oracleData) public view returns (uint256 _tokens, uint256 _equivalent) {
585         // Check if paused
586         require(!paused && !pausedProvider.isPaused(), "contract paused");
587 
588         // Check if Oracle contract has been upgraded
589         RateOracle _upgrade = upgrade;
590         if (address(_upgrade) != address(0)) {
591             return _upgrade.readSample(_oracleData);
592         }
593 
594         // Tokens is always base
595         _tokens = BASE;
596         _equivalent = list.median();
597     }
598 
599     /**
600      * @dev Reads the rate provided by the Oracle
601      *   this being the median of the last rate provided by each signer
602      * @return `_equivalent` is the median of the values provided by the signer
603      *   `_tokens` are equivalent to `_equivalent` in the currency of the Oracle
604      * @notice This Oracle accepts reading the sample without auxiliary data
605      */
606     function readSample() external view returns (uint256 _tokens, uint256 _equivalent) {
607         (_tokens, _equivalent) = readSample(new bytes(0));
608     }
609 }
610 
611 // File: contracts/OracleFactory.sol
612 
613 pragma solidity ^0.5.12;
614 
615 
616 
617 
618 
619 
620 
621 contract OracleFactory is Ownable, Pausable, PausedProvider {
622     mapping(string => address) public symbolToOracle;
623     mapping(address => string) public oracleToSymbol;
624 
625     event NewOracle(
626         string _symbol,
627         address _oracle,
628         string _name,
629         uint256 _decimals,
630         address _token,
631         string _maintainer
632     );
633 
634     event Upgraded(
635         address indexed _oracle,
636         address _new
637     );
638 
639     event AddSigner(
640         address indexed _oracle,
641         address _signer,
642         string _name
643     );
644 
645     event RemoveSigner(
646         address indexed _oracle,
647         address _signer
648     );
649 
650     event UpdateSignerName(
651         address indexed _oracle,
652         address _signer,
653         string _newName
654     );
655 
656     event UpdatedMetadata(
657         address indexed _oracle,
658         string _name,
659         uint256 _decimals,
660         string _maintainer
661     );
662 
663     event Provide(
664         address indexed _oracle,
665         address _signer,
666         uint256 _rate
667     );
668 
669     event OraclePaused(
670         address indexed _oracle,
671         address _pauser
672     );
673 
674     event OracleStarted(
675         address indexed _oracle
676     );
677 
678     /**
679      * @dev Creates a new Oracle contract for a given `_symbol`
680      * @param _symbol metadata symbol for the currency of the oracle to create
681      * @param _name metadata name for the currency of the oracle
682      * @param _decimals metadata number of decimals to express the common denomination of the currency
683      * @param _token metadata token address of the currency
684      *   (if the currency has no token, it should be the address 0)
685      * @param _maintainer metadata maintener human readable name
686      * @notice Only one oracle by symbol can be created
687      */
688     function newOracle(
689         string calldata _symbol,
690         string calldata _name,
691         uint256 _decimals,
692         address _token,
693         string calldata _maintainer
694     ) external onlyOwner {
695         // Check for duplicated oracles
696         require(symbolToOracle[_symbol] == address(0), "Oracle already exists");
697         // Create oracle contract
698         MultiSourceOracle oracle = new MultiSourceOracle(
699             _symbol,
700             _name,
701             _decimals,
702             _token,
703             _maintainer
704         );
705         // Sanity check new oracle
706         assert(bytes(oracleToSymbol[address(oracle)]).length == 0);
707         // Save Oracle in registry
708         symbolToOracle[_symbol] = address(oracle);
709         oracleToSymbol[address(oracle)] = _symbol;
710         // Emit events
711         emit NewOracle(
712             _symbol,
713             address(oracle),
714             _name,
715             _decimals,
716             _token,
717             _maintainer
718         );
719     }
720 
721     /**
722      * @return true if the Oracle ecosystem is paused
723      * @notice Used by PausedProvided and readed by the Oracles on each `readSample()`
724      */
725     function isPaused() external view returns (bool) {
726         return paused;
727     }
728 
729     /**
730      * @dev Adds a `_signer` to a given `_oracle`
731      * @param _oracle Address of the oracle on which add the `_signer`
732      * @param _signer Address of the signer to be added
733      * @param _name Human readable metadata name of the `_signer`
734      * @notice Acts as a proxy of `_oracle.addSigner`
735      */
736     function addSigner(address _oracle, address _signer, string calldata _name) external onlyOwner {
737         MultiSourceOracle(_oracle).addSigner(_signer, _name);
738         emit AddSigner(_oracle, _signer, _name);
739     }
740 
741     /**
742      * @dev Adds a `_signer` to multiple `_oracles`
743      * @param _oracles List of oracles on which add the `_signer`
744      * @param _signer Address of the signer to be added
745      * @param _name Human readable metadata name of the `_signer`
746      * @notice Acts as a proxy for all the `_oracles` `_oracle.addSigner`
747      */
748     function addSignerToOracles(
749         address[] calldata _oracles,
750         address _signer,
751         string calldata _name
752     ) external onlyOwner {
753         for (uint256 i = 0; i < _oracles.length; i++) {
754             address oracle = _oracles[i];
755             MultiSourceOracle(oracle).addSigner(_signer, _name);
756             emit AddSigner(oracle, _signer, _name);
757         }
758     }
759 
760     /**
761      * @dev Updates the `_name` of a given `_signer`@`_oracle`
762      * @param _oracle Address of the oracle on which the `_signer` it's found
763      * @param _signer Address of the signer to be updated
764      * @param _name Human readable metadata name of the `_signer`
765      * @notice Acts as a proxy of `_oracle.setName`
766      */
767     function setName(address _oracle, address _signer, string calldata _name) external onlyOwner {
768         MultiSourceOracle(_oracle).setName(_signer, _name);
769         emit UpdateSignerName(
770             _oracle,
771             _signer,
772             _name
773         );
774     }
775 
776     /**
777      * @dev Removes a `_signer` to a given `_oracle`
778      * @param _oracle Address of the oracle on which remove the `_signer`
779      * @param _signer Address of the signer to be removed
780      * @notice Acts as a proxy of `_oracle.removeSigner`
781      */
782     function removeSigner(address _oracle, address _signer) external onlyOwner {
783         MultiSourceOracle(_oracle).removeSigner(_signer);
784         emit RemoveSigner(_oracle, _signer);
785     }
786 
787 
788     /**
789      * @dev Removes a `_signer` from multiple `_oracles`
790      * @param _oracles List of oracles on which remove the `_signer`
791      * @param _signer Address of the signer to be removed
792      * @notice Acts as a proxy for all the `_oracles` `_oracle.removeSigner`
793      */
794     function removeSignerFromOracles(
795         address[] calldata _oracles,
796         address _signer
797     ) external onlyOwner {
798         for (uint256 i = 0; i < _oracles.length; i++) {
799             address oracle = _oracles[i];
800             MultiSourceOracle(oracle).removeSigner(_signer);
801             emit RemoveSigner(oracle, _signer);
802         }
803     }
804 
805     /**
806      * @dev Provides a `_rate` for a given `_oracle`, msg.sener becomes the `signer`
807      * @param _oracle Address of the oracle on which provide the rate
808      * @param _rate Rate to be provided
809      * @notice Acts as a proxy of `_oracle.provide`, using the parameter `msg.sender` as signer
810      */
811     function provide(address _oracle, uint256 _rate) external {
812         MultiSourceOracle(_oracle).provide(msg.sender, _rate);
813         emit Provide(_oracle, msg.sender, _rate);
814     }
815 
816     /**
817      * @dev Provides multiple rates for a set of oracles, with the same signer
818      *   msg.sender becomes the signer for all the provides
819      *
820      * @param _oracles List of oracles to provide a rate for
821      * @param _rates List of rates to provide
822      * @notice Acts as a proxy for multiples `_oracle.provide`, using the parameter `msg.sender` as signer
823      */
824     function provideMultiple(
825         address[] calldata _oracles,
826         uint256[] calldata _rates
827     ) external {
828         uint256 length = _oracles.length;
829         require(length == _rates.length, "arrays should have the same size");
830 
831         for (uint256 i = 0; i < length; i++) {
832             address oracle = _oracles[i];
833             uint256 rate = _rates[i];
834             MultiSourceOracle(oracle).provide(msg.sender, rate);
835             emit Provide(oracle, msg.sender, rate);
836         }
837     }
838 
839     /**
840      * @dev Updates the Oracle contract, all subsequent calls to `readSample` will be forwareded to `_upgrade`
841      * @param _oracle oracle address to be upgraded
842      * @param _upgrade contract address of the new updated oracle
843      * @notice Acts as a proxy of `_oracle.setUpgrade`
844      */
845     function setUpgrade(address _oracle, address _upgrade) external onlyOwner {
846         MultiSourceOracle(_oracle).setUpgrade(RateOracle(_upgrade));
847         emit Upgraded(_oracle, _upgrade);
848     }
849 
850     /**
851      * @dev Pauses the given `_oracle`
852      * @param _oracle oracle address to be paused
853      * @notice Acts as a proxy of `_oracle.pause`
854      */
855     function pauseOracle(address _oracle) external {
856         require(
857             canPause[msg.sender] ||
858             msg.sender == _owner,
859             "not authorized to pause"
860         );
861 
862         MultiSourceOracle(_oracle).pause();
863         emit OraclePaused(_oracle, msg.sender);
864     }
865 
866     /**
867      * @dev Starts the given `_oracle`
868      * @param _oracle oracle address to be started
869      * @notice Acts as a proxy of `_oracle.start`
870      */
871     function startOracle(address _oracle) external onlyOwner {
872         MultiSourceOracle(_oracle).start();
873         emit OracleStarted(_oracle);
874     }
875 
876     /**
877      * @dev Updates the medatada of the oracle
878      * @param _oracle oracle address to update its metadata
879      * @param _name Name of the oracle currency
880      * @param _decimals Decimals for the common representation of the currency
881      * @param _maintainer Name of the maintainer entity of the Oracle
882      * @notice Acts as a proxy of `_oracle.setMetadata`
883      */
884     function setMetadata(
885         address _oracle,
886         string calldata _name,
887         uint256 _decimals,
888         string calldata _maintainer
889     ) external onlyOwner {
890         MultiSourceOracle(_oracle).setMetadata(
891             _name,
892             _decimals,
893             _maintainer
894         );
895 
896         emit UpdatedMetadata(
897             _oracle,
898             _name,
899             _decimals,
900             _maintainer
901         );
902     }
903 }