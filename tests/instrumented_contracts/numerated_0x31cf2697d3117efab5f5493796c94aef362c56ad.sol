1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     int256 constant private INT256_MIN = -2**255;
10 
11     /**
12     * @dev Multiplies two unsigned integers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Multiplies two signed integers, reverts on overflow.
30     */
31     function mul(int256 a, int256 b) internal pure returns (int256) {
32         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33         // benefit is lost if 'b' is also tested.
34         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35         if (a == 0) {
36             return 0;
37         }
38 
39         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
40 
41         int256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
61     */
62     function div(int256 a, int256 b) internal pure returns (int256) {
63         require(b != 0); // Solidity only automatically asserts when dividing by 0
64         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
65 
66         int256 c = a / b;
67 
68         return c;
69     }
70 
71     /**
72     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73     */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b <= a);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82     * @dev Subtracts two signed integers, reverts on overflow.
83     */
84     function sub(int256 a, int256 b) internal pure returns (int256) {
85         int256 c = a - b;
86         require((b >= 0 && c <= a) || (b < 0 && c > a));
87 
88         return c;
89     }
90 
91     /**
92     * @dev Adds two unsigned integers, reverts on overflow.
93     */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a);
97 
98         return c;
99     }
100 
101     /**
102     * @dev Adds two signed integers, reverts on overflow.
103     */
104     function add(int256 a, int256 b) internal pure returns (int256) {
105         int256 c = a + b;
106         require((b >= 0 && c >= a) || (b < 0 && c < a));
107 
108         return c;
109     }
110 
111     /**
112     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
113     * reverts when dividing by zero.
114     */
115     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b != 0);
117         return a % b;
118     }
119 }
120 
121 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
122 interface ERC721 {
123     // Required methods
124     function totalSupply() external view returns (uint256 total);
125 
126     function balanceOf(address _owner) external view returns (uint256 balance);
127 
128     function ownerOf(uint256 _tokenId) external view returns (address owner);
129 
130     function approve(address _to, uint256 _tokenId) external;
131 
132     function transfer(address _to, uint256 _tokenId) external;
133 
134     function transferFrom(address _from, address _to, uint256 _tokenId) external;
135 
136     // Events
137     event Transfer(address from, address to, uint256 tokenId);
138     event Approval(address owner, address approved, uint256 tokenId);
139 
140     // Optional
141     // function name() public view returns (string name);
142     // function symbol() public view returns (string symbol);
143     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
144     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
145 
146     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
147     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
148 }
149 
150 /// @title SEKRETOOOO
151 contract GeneScienceInterface {
152     /// @dev simply a boolean to indicate this is the contract we expect to be
153     function isGeneScience() public pure returns (bool);
154 
155     /// @dev given genes of pony 1 & 2, return a genetic combination - may have a random factor
156     /// @param genes1 genes of mom
157     /// @param genes2 genes of dad
158     /// @return the genes that are supposed to be passed down the child
159     function mixGenes(uint256 genes1, uint256 genes2, uint256 targetBlock) public returns (uint256);
160 
161     // calculate the cooldown of child pony
162     function processCooldown(uint16 childGen, uint256 targetBlock) public returns (uint16);
163 
164     // calculate the result for upgrading pony
165     function upgradePonyResult(uint8 unicornation, uint256 targetBlock) public returns (bool);
166     
167     function setMatingSeason(bool _isMatingSeason) public returns (bool);
168 }
169 
170 
171 
172 /// @title Interface for contracts conforming to ERC-20
173 interface ERC20 {
174     //core ERC20 functions
175     function transfer(address _to, uint _value) external returns (bool success);
176 
177     function balanceOf(address who) external view returns (uint256);
178 
179     function allowance(address owner, address spender) external view returns (uint256);
180 
181     function transferFrom(address from, address to, uint256 value) external returns (bool success);
182 
183     function transferPreSigned(bytes _signature, address _to, uint256 _value, uint256 _fee, uint256 _nonce) external returns (bool);
184 
185     function recoverSigner(bytes _signature, address _to, uint256 _value, uint256 _fee, uint256 _nonce) external view returns (address);
186 }
187 
188 /**
189  * @title Signature verifier
190  * @dev To verify C level actions
191  */
192 contract SignatureVerifier {
193 
194     function splitSignature(bytes sig)
195     internal
196     pure
197     returns (uint8, bytes32, bytes32)
198     {
199         require(sig.length == 65);
200 
201         bytes32 r;
202         bytes32 s;
203         uint8 v;
204 
205         assembly {
206         // first 32 bytes, after the length prefix
207             r := mload(add(sig, 32))
208         // second 32 bytes
209             s := mload(add(sig, 64))
210         // final byte (first byte of the next 32 bytes)
211             v := byte(0, mload(add(sig, 96)))
212         }
213         return (v, r, s);
214     }
215 
216     function recover(bytes32 hash, bytes sig) public pure returns (address) {
217         bytes32 r;
218         bytes32 s;
219         uint8 v;
220         //Check the signature length
221         if (sig.length != 65) {
222             return (address(0));
223         }
224         // Divide the signature in r, s and v variables
225         (v, r, s) = splitSignature(sig);
226         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
227         if (v < 27) {
228             v += 27;
229         }
230         // If the version is correct return the signer address
231         if (v != 27 && v != 28) {
232             return (address(0));
233         } else {
234             bytes memory prefix = "\x19Ethereum Signed Message:\n32";
235             bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
236             return ecrecover(prefixedHash, v, r, s);
237         }
238     }
239 }
240 
241 /**
242  * @title A DEKLA token access control
243  * @author DEKLA (https://www.dekla.io)
244  * @dev The Dekla token has 3 C level address to manage.
245  * They can execute special actions but it need to be approved by another C level address.
246  */
247 contract AccessControl is SignatureVerifier {
248     using SafeMath for uint256;
249 
250     // C level address that can execute special actions.
251     address public ceoAddress;
252     address public cfoAddress;
253     address public cooAddress;
254     address public systemAddress;
255     uint256 public CLevelTxCount_ = 0;
256     mapping(address => uint256) nonces;
257 
258     // @dev C level transaction must be approved with another C level address
259     modifier onlyCLevel() {
260         require(
261             msg.sender == cooAddress ||
262             msg.sender == ceoAddress ||
263             msg.sender == cfoAddress
264         );
265         _;
266     }
267 
268 
269     /// @dev Access modifier for CEO-only functionality
270     modifier onlyCEO() {
271         require(msg.sender == ceoAddress);
272         _;
273     }
274 
275     /// @dev Access modifier for CFO-only functionality
276     modifier onlyCFO() {
277         require(msg.sender == cfoAddress);
278         _;
279     }
280 
281     /// @dev Access modifier for COO-only functionality
282     modifier onlyCOO() {
283         require(msg.sender == cooAddress);
284         _;
285     }
286 
287     // @dev return true if transaction already signed by a C Level address
288     // @param _message The string to be verify
289     function signedByCLevel(
290         bytes32 _message,
291         bytes _sig
292     )
293     internal
294     view
295     onlyCLevel
296     returns (bool)
297     {
298         address signer = recover(_message, _sig);
299         require(signer != msg.sender);
300         return (
301         signer == cooAddress ||
302         signer == ceoAddress ||
303         signer == cfoAddress
304         );
305     }
306 
307     // @dev return true if transaction already signed by a C Level address
308     // @param _message The string to be verify
309     // @param _sig the signature from signing the _message with system key
310     function signedBySystem(
311         bytes32 _message,
312         bytes _sig
313     )
314     internal
315     view
316     returns (bool)
317     {
318         address signer = recover(_message, _sig);
319         require(signer != msg.sender);
320         return (
321         signer == systemAddress
322         );
323     }
324 
325     /**
326      * @notice Hash (keccak256) of the payload used by setCEO
327      * @param _newCEO address The address of the new CEO
328      * @param _nonce uint256 setCEO transaction number.
329      */
330     function getCEOHashing(address _newCEO, uint256 _nonce) public pure returns (bytes32) {
331         return keccak256(abi.encodePacked(bytes4(0x486A0E94), _newCEO, _nonce));
332     }
333 
334     // @dev Assigns a new address to act as the CEO. The C level transaction, must verify.
335     // @param _newCEO The address of the new CEO
336     // @param _sig the signature from signing the _message with CEO key
337     function setCEO(
338         address _newCEO,
339         bytes _sig
340     ) external onlyCLevel {
341         require(
342             _newCEO != address(0) &&
343             _newCEO != cfoAddress &&
344             _newCEO != cooAddress
345         );
346 
347         bytes32 hashedTx = getCEOHashing(_newCEO, nonces[msg.sender]);
348         require(signedByCLevel(hashedTx, _sig));
349         nonces[msg.sender]++;
350 
351         ceoAddress = _newCEO;
352         CLevelTxCount_++;
353     }
354 
355     /**
356      * @notice Hash (keccak256) of the payload used by setCFO
357      * @param _newCFO address The address of the new CFO
358      * @param _nonce uint256 setCFO transaction number.
359      */
360     function getCFOHashing(address _newCFO, uint256 _nonce) public pure returns (bytes32) {
361         return keccak256(abi.encodePacked(bytes4(0x486A0E95), _newCFO, _nonce));
362     }
363 
364     // @dev Assigns a new address to act as the CFO. The C level transaction, must verify.
365     // @param _newCFO The address of the new CFO
366     function setCFO(
367         address _newCFO,
368         bytes _sig
369     ) external onlyCLevel {
370         require(
371             _newCFO != address(0) &&
372             _newCFO != ceoAddress &&
373             _newCFO != cooAddress
374         );
375 
376         bytes32 hashedTx = getCFOHashing(_newCFO, nonces[msg.sender]);
377         require(signedByCLevel(hashedTx, _sig));
378         nonces[msg.sender]++;
379 
380         cfoAddress = _newCFO;
381         CLevelTxCount_++;
382     }
383 
384     /**
385      * @notice Hash (keccak256) of the payload used by setCOO
386      * @param _newCOO address The address of the new COO
387      * @param _nonce uint256 setCO transaction number.
388      */
389     function getCOOHashing(address _newCOO, uint256 _nonce) public pure returns (bytes32) {
390         return keccak256(abi.encodePacked(bytes4(0x486A0E96), _newCOO, _nonce));
391     }
392 
393     // @dev Assigns a new address to act as the COO. The C level transaction, must verify.
394     // @param _newCOO The address of the new COO, _sig signature used to verify COO address
395     // @param _sig the signature from signing the _newCOO with 1 of the C-level key
396     function setCOO(
397         address _newCOO,
398         bytes _sig
399     ) external onlyCLevel {
400         require(
401             _newCOO != address(0) &&
402             _newCOO != ceoAddress &&
403             _newCOO != cfoAddress
404         );
405 
406         bytes32 hashedTx = getCOOHashing(_newCOO, nonces[msg.sender]);
407         require(signedByCLevel(hashedTx, _sig));
408         nonces[msg.sender]++;
409 
410         cooAddress = _newCOO;
411         CLevelTxCount_++;
412     }
413 
414     function getNonces(address _sender) public view returns (uint256) {
415         return nonces[_sender];
416     }
417 }
418 
419 
420 /// @title A facet of PonyCore that manages special access privileges.
421 contract PonyAccessControl is AccessControl {
422     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
423     event ContractUpgrade(address newContract);
424 
425 
426     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
427     bool public paused = false;
428 
429 
430     /// @dev Modifier to allow actions only when the contract IS NOT paused
431     modifier whenNotPaused() {
432         require(!paused);
433         _;
434     }
435 
436     /// @dev Modifier to allow actions only when the contract IS paused
437     modifier whenPaused {
438         require(paused);
439         _;
440     }
441 
442     /// @dev Called by any "C-level" role to pause the contract. Used only when
443     ///  a bug or exploit is detected and we need to limit damage.
444     function pause() external onlyCLevel whenNotPaused {
445         paused = true;
446     }
447 
448     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
449     ///  one reason we may pause the contract is when CFO or COO accounts are
450     ///  compromised.
451     /// @notice This is public rather than external so it can be called by
452     ///  derived contracts.
453     function unpause() public onlyCEO whenPaused {
454         // can't unpause if contract was upgraded
455         paused = false;
456     }
457 }
458 
459 
460 /// @dev See the PonyCore contract documentation to understand how the various contract facets are arranged.
461 contract PonyBase is PonyAccessControl {
462     /*** EVENTS ***/
463 
464     /// @dev The Birth event is fired whenever a new pony comes into existence. This obviously
465     ///  includes any time a pony is created through the giveBirth method, but it is also called
466     ///  when a new gen0 pony is created.
467     event Birth(address owner, uint256 ponyId, uint256 matronId, uint256 sireId, uint256 genes);
468 
469     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a pony
470     ///  ownership is assigned, including births.
471     event Transfer(address from, address to, uint256 tokenId);
472 
473     /*** DATA TYPES ***/
474 
475     /// @dev The main Pony struct. Every pony in MyEtherPonies is represented by a copy
476     ///  of this structure, so great care was taken to ensure that it fits neatly into
477     ///  exactly two 256-bit words. Note that the order of the members in this structure
478     ///  is important because of the byte-packing rules used by Ethereum.
479     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
480     struct Pony {
481         // The Pony's genetic code is packed into these 256-bits, the format is
482         // sooper-sekret! A pony's genes never change.
483         uint256 genes;
484 
485         // The timestamp from the block when this pony came into existence.
486         uint64 birthTime;
487 
488         // The minimum timestamp after which this pony can engage in breeding
489         // activities again. This same timestamp is used for the pregnancy
490         // timer (for matrons) as well as the siring cooldown.
491         uint64 cooldownEndBlock;
492 
493         // The ID of the parents of this Pony, set to 0 for gen0 ponies.
494         // Note that using 32-bit unsigned integers limits us to a "mere"
495         // 4 billion ponies. This number might seem small until you realize
496         // that Ethereum currently has a limit of about 500 million
497         // transactions per year! So, this definitely won't be a problem
498         // for several years (even as Ethereum learns to scale).
499         uint32 matronId;
500         uint32 sireId;
501 
502         // Set to the ID of the sire pony for matrons that are pregnant,
503         // zero otherwise. A non-zero value here is how we know a pony
504         // is pregnant. Used to retrieve the genetic material for the new
505         // pony when the birth transpires.
506         uint32 matingWithId;
507 
508         // Set to the index in the cooldown array (see below) that represents
509         // the current cooldown duration for this Pony. This starts at zero
510         // for gen0 ponies, and is initialized to floor(generation/2) for others.
511         // Incremented by one for each successful breeding action, regardless
512         // of whether this ponies is acting as matron or sire.
513         uint16 cooldownIndex;
514 
515         // The "generation number" of this pony. ponies minted by the EP contract
516         // for sale are called "gen0" and have a generation number of 0. The
517         // generation number of all other ponies is the larger of the two generation
518         // numbers of their parents, plus one.
519         // (i.e. max(matron.generation, sire.generation) + 1)
520         uint16 generation;
521 
522         uint16 txCount;
523 
524         uint8 unicornation;
525 
526 
527     }
528 
529     /*** CONSTANTS ***/
530 
531     /// @dev A lookup table indicating the cooldown duration after any successful
532     ///  breeding action, called "pregnancy time" for matrons and "siring cooldown"
533     ///  for sires. Designed such that the cooldown roughly doubles each time a pony
534     ///  is bred, encouraging owners not to just keep breeding the same pony over
535     ///  and over again. Caps out at one week (a pony can breed an unbounded number
536     ///  of times, and the maximum cooldown is always seven days).
537     uint32[10] public cooldowns = [
538     uint32(1 minutes),
539     uint32(5 minutes),
540     uint32(30 minutes),
541     uint32(1 hours),
542     uint32(4 hours),
543     uint32(8 hours),
544     uint32(1 days),
545     uint32(2 days),
546     uint32(4 days),
547     uint32(7 days)
548     ];
549 
550     uint8[5] public incubators = [
551     uint8(5),
552     uint8(10),
553     uint8(15),
554     uint8(20),
555     uint8(25)
556     ];
557 
558     // An approximation of currently how many seconds are in between blocks.
559     uint256 public secondsPerBlock = 15;
560 
561     /*** STORAGE ***/
562 
563     /// @dev An array containing the Pony struct for all Ponies in existence. The ID
564     ///  of each pony is actually an index into this array. Note that ID 0 is a genesispony,
565     ///  the unPony, the mythical beast that is the parent of all gen0 ponies. A bizarre
566     ///  creature that is both matron and sire... to itself! Has an invalid genetic code.
567     ///  In other words, pony ID 0 is invalid... ;-)
568     Pony[] ponies;
569 
570     /// @dev A mapping from ponies IDs to the address that owns them. All ponies have
571     ///  some valid owner address, even gen0 ponies are created with a non-zero owner.
572     mapping(uint256 => address) public ponyIndexToOwner;
573 
574     // @dev A mapping from owner address to count of tokens that address owns.
575     //  Used internally inside balanceOf() to resolve ownership count.
576     mapping(address => uint256) ownershipTokenCount;
577 
578     /// @dev A mapping from PonyIDs to an address that has been approved to call
579     ///  transferFrom(). Each Pony can only have one approved address for transfer
580     ///  at any time. A zero value means no approval is outstanding.
581     mapping(uint256 => address) public ponyIndexToApproved;
582 
583     /// @dev A mapping from PonyIDs to an address that has been approved to use
584     ///  this Pony for siring via breedWith(). Each Pony can only have one approved
585     ///  address for siring at any time. A zero value means no approval is outstanding.
586     mapping(uint256 => address) public matingAllowedToAddress;
587 
588     mapping(address => bool) public hasIncubator;
589 
590     /// @dev The address of the ClockAuction contract that handles sales of Ponies. This
591     ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
592     ///  initiated every 15 minutes.
593     SaleClockAuction public saleAuction;
594 
595     /// @dev The address of a custom ClockAuction subclassed contract that handles siring
596     ///  auctions. Needs to be separate from saleAuction because the actions taken on success
597     ///  after a sales and siring auction are quite different.
598     SiringClockAuction public siringAuction;
599 
600 
601     BiddingClockAuction public biddingAuction;
602     /// @dev Assigns ownership of a specific Pony to an address.
603     function _transfer(address _from, address _to, uint256 _tokenId) internal {
604         // Since the number of ponies is capped to 2^32 we can't overflow this
605         ownershipTokenCount[_to]++;
606         // transfer ownership
607         ponyIndexToOwner[_tokenId] = _to;
608         // When creating new ponies _from is 0x0, but we can't account that address.
609         if (_from != address(0)) {
610             ownershipTokenCount[_from]--;
611             // once the pony is transferred also clear sire allowances
612             delete matingAllowedToAddress[_tokenId];
613             // clear any previously approved ownership exchange
614             delete ponyIndexToApproved[_tokenId];
615         }
616         // Emit the transfer event.
617         emit Transfer(_from, _to, _tokenId);
618     }
619 
620     /// @dev An internal method that creates a new Pony and stores it. This
621     ///  method doesn't do any checking and should only be called when the
622     ///  input data is known to be valid. Will generate both a Birth event
623     ///  and a Transfer event.
624     /// @param _matronId The Pony ID of the matron of this pony (zero for gen0)
625     /// @param _sireId The Pony ID of the sire of this pony (zero for gen0)
626     /// @param _generation The generation number of this pony, must be computed by caller.
627     /// @param _genes The Pony's genetic code.
628     /// @param _owner The inital owner of this pony, must be non-zero (except for the unPony, ID 0)
629     function _createPony(
630         uint256 _matronId,
631         uint256 _sireId,
632         uint256 _generation,
633         uint256 _genes,
634         address _owner,
635         uint16 _cooldownIndex
636     )
637     internal
638     returns (uint)
639     {
640         // These requires are not strictly necessary, our calling code should make
641         // sure that these conditions are never broken. However! _createPony() is already
642         // an expensive call (for storage), and it doesn't hurt to be especially careful
643         // to ensure our data structures are always valid.
644         require(_matronId == uint256(uint32(_matronId)));
645         require(_sireId == uint256(uint32(_sireId)));
646         require(_generation == uint256(uint16(_generation)));
647 
648 
649         Pony memory _pony = Pony({
650             genes : _genes,
651             birthTime : uint64(now),
652             cooldownEndBlock : 0,
653             matronId : uint32(_matronId),
654             sireId : uint32(_sireId),
655             matingWithId : 0,
656             cooldownIndex : _cooldownIndex,
657             generation : uint16(_generation),
658             unicornation : 0,
659             txCount : 0
660             });
661         uint256 newPonyId = ponies.push(_pony) - 1;
662 
663         require(newPonyId == uint256(uint32(newPonyId)));
664 
665         // emit the birth event
666         emit Birth(
667             _owner,
668             newPonyId,
669             uint256(_pony.matronId),
670             uint256(_pony.sireId),
671             _pony.genes
672         );
673 
674         // This will assign ownership, and also emit the Transfer event as
675         // per ERC721 draft
676         _transfer(0, _owner, newPonyId);
677 
678         return newPonyId;
679     }
680 
681     // Any C-level can fix how many seconds per blocks are currently observed.
682     function setSecondsPerBlock(uint256 secs) external onlyCLevel {
683         require(secs < cooldowns[0]);
684         secondsPerBlock = secs;
685     }
686 }
687 
688 
689 /// @title The facet of the EtherPonies core contract that manages ownership, ERC-721 (draft) compliant.
690 /// @author Dekla (https://www.dekla.io)
691 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
692 ///  See the PonyCore contract documentation to understand how the various contract facets are arranged.
693 contract PonyOwnership is PonyBase, ERC721 {
694 
695     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
696     string public constant name = "EtherPonies";
697     string public constant symbol = "EP";
698 
699     bytes4 constant InterfaceSignature_ERC165 =
700     bytes4(keccak256('supportsInterface(bytes4)'));
701 
702     bytes4 constant InterfaceSignature_ERC721 =
703     bytes4(keccak256('name()')) ^
704     bytes4(keccak256('symbol()')) ^
705     bytes4(keccak256('totalSupply()')) ^
706     bytes4(keccak256('balanceOf(address)')) ^
707     bytes4(keccak256('ownerOf(uint256)')) ^
708     bytes4(keccak256('approve(address,uint256)')) ^
709     bytes4(keccak256('transfer(address,uint256)')) ^
710     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
711     bytes4(keccak256('tokensOfOwner(address)')) ^
712     bytes4(keccak256('tokenMetadata(uint256,string)'));
713 
714     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
715     ///  Returns true for any standardized interfaces implemented by this contract. We implement
716     ///  ERC-165 (obviously!) and ERC-721.
717     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
718     {
719         // DEBUG ONLY
720         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
721 
722         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
723     }
724 
725     // Internal utility functions: These functions all assume that their input arguments
726     // are valid. We leave it to public methods to sanitize their inputs and follow
727     // the required logic.
728 
729     /// @dev Checks if a given address is the current owner of a particular Pony.
730     /// @param _claimant the address we are validating against.
731     /// @param _tokenId pony id, only valid when > 0
732     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
733         return ponyIndexToOwner[_tokenId] == _claimant;
734     }
735 
736     /// @dev Checks if a given address currently has transferApproval for a particular Pony.
737     /// @param _claimant the address we are confirming pony is approved for.
738     /// @param _tokenId pony id, only valid when > 0
739     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
740         return ponyIndexToApproved[_tokenId] == _claimant;
741     }
742 
743     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
744     ///  approval. Setting _approved to address(0) clears all transfer approval.
745     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
746     ///  _approve() and transferFrom() are used together for putting Ponies on auction, and
747     ///  there is no value in spamming the log with Approval events in that case.
748     function _approve(uint256 _tokenId, address _approved) internal {
749         ponyIndexToApproved[_tokenId] = _approved;
750     }
751 
752     /// @notice Returns the number of Ponies owned by a specific address.
753     /// @param _owner The owner address to check.
754     /// @dev Required for ERC-721 compliance
755     function balanceOf(address _owner) public view returns (uint256 count) {
756         return ownershipTokenCount[_owner];
757     }
758 
759     /// @notice Transfers a Pony to another address. If transferring to a smart
760     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
761     ///  EtherPonies specifically) or your Pony may be lost forever. Seriously.
762     /// @param _to The address of the recipient, can be a user or contract.
763     /// @param _tokenId The ID of the Pony to transfer.
764     /// @dev Required for ERC-721 compliance.
765     function transfer(
766         address _to,
767         uint256 _tokenId
768     )
769     external
770     whenNotPaused
771     {
772         // Safety check to prevent against an unexpected 0x0 default.
773         require(_to != address(0));
774         // Disallow transfers to this contract to prevent accidental misuse.
775         // The contract should never own any ponies (except very briefly
776         // after a gen0 pony is created and before it goes on auction).
777         require(_to != address(this));
778 
779 
780         // You can only send your own pony.
781         require(_owns(msg.sender, _tokenId));
782 
783         // Reassign ownership, clear pending approvals, emit Transfer event.
784         _transfer(msg.sender, _to, _tokenId);
785     }
786 
787     /// @notice Grant another address the right to transfer a specific Pony via
788     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
789     /// @param _to The address to be granted transfer approval. Pass address(0) to
790     ///  clear all approvals.
791     /// @param _tokenId The ID of the Pony that can be transferred if this call succeeds.
792     /// @dev Required for ERC-721 compliance.
793     function approve(
794         address _to,
795         uint256 _tokenId
796     )
797     external
798     whenNotPaused
799     {
800         // Only an owner can grant transfer approval.
801         require(_owns(msg.sender, _tokenId));
802 
803         // Register the approval (replacing any previous approval).
804         _approve(_tokenId, _to);
805 
806         // Emit approval event.
807         emit Approval(msg.sender, _to, _tokenId);
808     }
809 
810     /// @notice Transfer a Pony owned by another address, for which the calling address
811     ///  has previously been granted transfer approval by the owner.
812     /// @param _from The address that owns the Pony to be transfered.
813     /// @param _to The address that should take ownership of the Pony. Can be any address,
814     ///  including the caller.
815     /// @param _tokenId The ID of the Pony to be transferred.
816     /// @dev Required for ERC-721 compliance.
817     function transferFrom(
818         address _from,
819         address _to,
820         uint256 _tokenId
821     )
822     external
823     whenNotPaused
824     {
825         // Safety check to prevent against an unexpected 0x0 default.
826         require(_to != address(0));
827         // Disallow transfers to this contract to prevent accidental misuse.
828         // The contract should never own any Ponies (except very briefly
829         // after a gen0 pony is created and before it goes on auction).
830         require(_to != address(this));
831         // Check for approval and valid ownership
832         require(_approvedFor(msg.sender, _tokenId));
833         require(_owns(_from, _tokenId));
834 
835         // Reassign ownership (also clears pending approvals and emits Transfer event).
836         _transfer(_from, _to, _tokenId);
837     }
838 
839     /// @notice Returns the total number of Ponies currently in existence.
840     /// @dev Required for ERC-721 compliance.
841     function totalSupply() public view returns (uint) {
842         return ponies.length - 1;
843     }
844 
845     /// @notice Returns the address currently assigned ownership of a given Pony.
846     /// @dev Required for ERC-721 compliance.
847     function ownerOf(uint256 _tokenId)
848     external
849     view
850     returns (address owner)
851     {
852         owner = ponyIndexToOwner[_tokenId];
853 
854     }
855 
856     /// @notice Returns a list of all Pony IDs assigned to an address.
857     /// @param _owner The owner whose Ponies we are interested in.
858     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
859     ///  expensive (it walks the entire Pony array looking for ponies belonging to owner),
860     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
861     ///  not contract-to-contract calls.
862     function tokensOfOwner(address _owner) external view returns (uint256[] ownerTokens) {
863         uint256 tokenCount = balanceOf(_owner);
864 
865         if (tokenCount == 0) {
866             // Return an empty array
867             return new uint256[](0);
868         } else {
869             uint256[] memory result = new uint256[](tokenCount);
870             uint256 totalPonies = totalSupply();
871             uint256 resultIndex = 0;
872 
873             // We count on the fact that all ponies have IDs starting at 1 and increasing
874             // sequentially up to the totalPony count.
875             uint256 ponyId;
876 
877             for (ponyId = 1; ponyId <= totalPonies; ponyId++) {
878                 if (ponyIndexToOwner[ponyId] == _owner) {
879                     result[resultIndex] = ponyId;
880                     resultIndex++;
881                 }
882             }
883 
884             return result;
885         }
886     }
887 
888     function transferPreSignedHashing(
889         address _token,
890         address _to,
891         uint256 _id,
892         uint256 _nonce
893     )
894     public
895     pure
896     returns (bytes32)
897     {
898         return keccak256(abi.encodePacked(bytes4(0x486A0E97), _token, _to, _id, _nonce));
899     }
900 
901     function transferPreSigned(
902         bytes _signature,
903         address _to,
904         uint256 _id,
905         uint256 _nonce
906     )
907     public
908     {
909         require(_to != address(0));
910         // require(signatures[_signature] == false);
911         bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _id, _nonce);
912         address from = recover(hashedTx, _signature);
913         require(from != address(0));
914         require(_to != address(this));
915 
916         // You can only send your own pony.
917         require(_owns(from, _id));
918         nonces[from]++;
919         // Reassign ownership, clear pending approvals, emit Transfer event.
920         _transfer(from, _to, _id);
921     }
922 
923     function approvePreSignedHashing(
924         address _token,
925         address _spender,
926         uint256 _tokenId,
927         uint256 _nonce
928     )
929     public
930     pure
931     returns (bytes32)
932     {
933         return keccak256(abi.encodePacked(_token, _spender, _tokenId, _nonce));
934     }
935 
936     function approvePreSigned(
937         bytes _signature,
938         address _spender,
939         uint256 _tokenId,
940         uint256 _nonce
941     )
942     public
943     returns (bool)
944     {
945         require(_spender != address(0));
946         // require(signatures[_signature] == false);
947         bytes32 hashedTx = approvePreSignedHashing(address(this), _spender, _tokenId, _nonce);
948         address from = recover(hashedTx, _signature);
949         require(from != address(0));
950 
951         // Only an owner can grant transfer approval.
952         require(_owns(from, _tokenId));
953 
954         nonces[from]++;
955         // Register the approval (replacing any previous approval).
956         _approve(_tokenId, _spender);
957 
958         // Emit approval event.
959         emit Approval(from, _spender, _tokenId);
960         return true;
961     }
962 }
963 
964 
965 
966 /// @title A facet of PonyCore that manages Pony siring, gestation, and birth.
967 /// @author Dekla (https://www.dekla.io)
968 /// @dev See the PonyCore contract documentation to understand how the various contract facets are arranged.
969 contract PonyBreeding is PonyOwnership {
970 
971     /// @dev The Pregnant event is fired when two ponies successfully breed and the pregnancy
972     ///  timer begins for the matron.
973     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndBlock);
974 
975     /// @notice The minimum payment required to use breedWithAuto(). This fee goes towards
976     ///  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
977     ///  the COO role as the gas price changes.
978     uint256 public autoBirthFee = 2 finney;
979 
980     // Keeps track of number of pregnant Ponies.
981     uint256 public pregnantPonies;
982 
983     /// @dev The address of the sibling contract that is used to implement the sooper-sekret
984     ///  genetic combination algorithm.
985     GeneScienceInterface public geneScience;
986 
987     /// @dev Update the address of the genetic contract, can only be called by the CEO.
988     /// @param _address An address of a GeneScience contract instance to be used from this point forward.
989     function setGeneScienceAddress(address _address) external onlyCEO {
990         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
991 
992         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
993         require(candidateContract.isGeneScience());
994 
995         // Set the new contract address
996         geneScience = candidateContract;
997     }
998 
999     /// @dev Checks that a given pony is able to breed. Requires that the
1000     ///  current cooldown is finished (for sires) and also checks that there is
1001     ///  no pending pregnancy.
1002     function _isReadyToMate(Pony _pon) internal view returns (bool) {
1003         // In addition to checking the cooldownEndBlock, we also need to check to see if
1004         // the pony has a pending birth; there can be some period of time between the end
1005         // of the pregnacy timer and the birth event.
1006         return (_pon.matingWithId == 0) && (_pon.cooldownEndBlock <= uint64(block.number));
1007     }
1008 
1009     /// @dev Check if a sire has authorized breeding with this matron. True if both sire
1010     ///  and matron have the same owner, or if the sire has given siring permission to
1011     ///  the matron's owner (via approveSiring()).
1012     function _isMatingPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
1013         address matronOwner = ponyIndexToOwner[_matronId];
1014         address sireOwner = ponyIndexToOwner[_sireId];
1015 
1016         // Siring is okay if they have same owner, or if the matron's owner was given
1017         // permission to breed with this sire.
1018         return (matronOwner == sireOwner || matingAllowedToAddress[_sireId] == matronOwner);
1019     }
1020 
1021     /// @dev Set the cooldownEndTime for the given Pony, based on its current cooldownIndex.
1022     ///  Also increments the cooldownIndex (unless it has hit the cap).
1023     /// @param _pony A reference to the Pony in storage which needs its timer started.
1024     function _triggerCooldown(Pony storage _pony) internal {
1025         // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
1026         _pony.cooldownEndBlock = uint64((cooldowns[_pony.cooldownIndex] / secondsPerBlock) + block.number);
1027 
1028         // Increment the breeding count, clamping it at 13, which is the length of the
1029         // cooldowns array. We could check the array size dynamically, but hard-coding
1030         // this as a constant saves gas. Yay, Solidity!
1031         if (_pony.cooldownIndex < 13) {
1032             _pony.cooldownIndex += 1;
1033         }
1034     }
1035 
1036     function _triggerPregnant(Pony storage _pony, uint8 _incubator) internal {
1037         // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
1038 
1039         if (_incubator > 0) {
1040             uint64 initialCooldown = uint64(cooldowns[_pony.cooldownIndex] / secondsPerBlock);
1041             _pony.cooldownEndBlock = uint64((initialCooldown - (initialCooldown * incubators[_incubator] / 100)) + block.number);
1042 
1043         } else {
1044             _pony.cooldownEndBlock = uint64((cooldowns[_pony.cooldownIndex] / secondsPerBlock) + block.number);
1045         }
1046         // Increment the breeding count, clamping it at 13, which is the length of the
1047         // cooldowns array. We could check the array size dynamically, but hard-coding
1048         // this as a constant saves gas. Yay, Solidity!
1049         if (_pony.cooldownIndex < 13) {
1050             _pony.cooldownIndex += 1;
1051         }
1052     }
1053 
1054     /// @notice Grants approval to another user to sire with one of your Ponies.
1055     /// @param _addr The address that will be able to sire with your Pony. Set to
1056     ///  address(0) to clear all siring approvals for this Pony.
1057     /// @param _sireId A Pony that you own that _addr will now be able to sire with.
1058     function approveSiring(address _addr, uint256 _sireId)
1059     external
1060     whenNotPaused
1061     {
1062         require(_owns(msg.sender, _sireId));
1063         matingAllowedToAddress[_sireId] = _addr;
1064     }
1065 
1066     /// @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
1067     ///  be called by the COO address. (This fee is used to offset the gas cost incurred
1068     ///  by the autobirth daemon).
1069     function setAutoBirthFee(uint256 val) external onlyCOO {
1070         autoBirthFee = val;
1071     }
1072 
1073     /// @dev Checks to see if a given Pony is pregnant and (if so) if the gestation
1074     ///  period has passed.
1075     function _isReadyToGiveBirth(Pony _matron) private view returns (bool) {
1076         return (_matron.matingWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
1077     }
1078 
1079     /// @notice Checks that a given pony is able to breed (i.e. it is not pregnant or
1080     ///  in the middle of a siring cooldown).
1081     /// @param _ponyId reference the id of the pony, any user can inquire about it
1082     function isReadyToMate(uint256 _ponyId)
1083     public
1084     view
1085     returns (bool)
1086     {
1087         require(_ponyId > 0);
1088         Pony storage pon = ponies[_ponyId];
1089         return _isReadyToMate(pon);
1090     }
1091 
1092     /// @dev Checks whether a Pony is currently pregnant.
1093     /// @param _ponyId reference the id of the pony, any user can inquire about it
1094     function isPregnant(uint256 _ponyId)
1095     public
1096     view
1097     returns (bool)
1098     {
1099         require(_ponyId > 0);
1100         // A Pony is pregnant if and only if this field is set
1101         return ponies[_ponyId].matingWithId != 0;
1102     }
1103 
1104     /// @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
1105     ///  check ownership permissions (that is up to the caller).
1106     /// @param _matron A reference to the Pony struct of the potential matron.
1107     /// @param _matronId The matron's ID.
1108     /// @param _sire A reference to the Pony struct of the potential sire.
1109     /// @param _sireId The sire's ID
1110     function _isValidMatingPair(
1111         Pony storage _matron,
1112         uint256 _matronId,
1113         Pony storage _sire,
1114         uint256 _sireId
1115     )
1116     private
1117     view
1118     returns (bool)
1119     {
1120         // A Pony can't breed with itself!
1121         if (_matronId == _sireId) {
1122             return false;
1123         }
1124 
1125         // Ponies can't breed with their parents.
1126         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
1127             return false;
1128         }
1129         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
1130             return false;
1131         }
1132 
1133         // We can short circuit the sibling check (below) if either pony is
1134         // gen zero (has a matron ID of zero).
1135         if (_sire.matronId == 0 || _matron.matronId == 0) {
1136             return true;
1137         }
1138 
1139         // Ponies can't breed with full or half siblings.
1140         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
1141             return false;
1142         }
1143         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
1144             return false;
1145         }
1146 
1147         // Everything seems cool! Let's get DTF.
1148         return true;
1149     }
1150 
1151     /// @dev Internal check to see if a given sire and matron are a valid mating pair for
1152     ///  breeding via auction (i.e. skips ownership and siring approval checks).
1153     function canMateWithViaAuction(uint256 _matronId, uint256 _sireId)
1154     public
1155     view
1156     returns (bool)
1157     {
1158         Pony storage matron = ponies[_matronId];
1159         Pony storage sire = ponies[_sireId];
1160         return _isValidMatingPair(matron, _matronId, sire, _sireId);
1161     }
1162 
1163     /// @notice Checks to see if two ponies can breed together, including checks for
1164     ///  ownership and siring approvals. Does NOT check that both ponies are ready for
1165     ///  breeding (i.e. breedWith could still fail until the cooldowns are finished).
1166     ///  TODO: Shouldn't this check pregnancy and cooldowns?!?
1167     /// @param _matronId The ID of the proposed matron.
1168     /// @param _sireId The ID of the proposed sire.
1169     function canMateWith(uint256 _matronId, uint256 _sireId)
1170     external
1171     view
1172     returns (bool)
1173     {
1174         require(_matronId > 0);
1175         require(_sireId > 0);
1176         Pony storage matron = ponies[_matronId];
1177         Pony storage sire = ponies[_sireId];
1178         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
1179         _isMatingPermitted(_sireId, _matronId);
1180     }
1181 
1182     /// @dev Internal utility function to initiate breeding, assumes that all breeding
1183     ///  requirements have been checked.
1184     function _mateWith(uint256 _matronId, uint256 _sireId, uint8 _incubator) internal {
1185         // Grab a reference to the Ponies from storage.
1186         Pony storage sire = ponies[_sireId];
1187         Pony storage matron = ponies[_matronId];
1188 
1189         // Mark the matron as pregnant, keeping track of who the sire is.
1190         matron.matingWithId = uint32(_sireId);
1191 
1192         // Trigger the cooldown for both parents.
1193         _triggerCooldown(sire);
1194         _triggerPregnant(matron, _incubator);
1195 
1196         // Clear siring permission for both parents. This may not be strictly necessary
1197         // but it's likely to avoid confusion!
1198         delete matingAllowedToAddress[_matronId];
1199         delete matingAllowedToAddress[_sireId];
1200 
1201         // Every time a Pony gets pregnant, counter is incremented.
1202         pregnantPonies++;
1203 
1204         // Emit the pregnancy event.
1205 
1206         emit Pregnant(ponyIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock);
1207     }
1208 
1209     function getIncubatorHashing(
1210         address _sender,
1211         uint8 _incubator,
1212         uint256 txCount
1213     )
1214     public
1215     pure
1216     returns (bytes32)
1217     {
1218         return keccak256(abi.encodePacked(bytes4(0x486A0E98), _sender, _incubator, txCount));
1219     }
1220 
1221     /// @notice Breed a Pony you own (as matron) with a sire that you own, or for which you
1222     ///  have previously been given Siring approval. Will either make your pony pregnant, or will
1223     ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
1224     /// @param _matronId The ID of the Pony acting as matron (will end up pregnant if successful)
1225     /// @param _sireId The ID of the Pony acting as sire (will begin its siring cooldown if successful)
1226     function mateWithAuto(uint256 _matronId, uint256 _sireId, uint8 _incubator, bytes _sig)
1227     external
1228     payable
1229     whenNotPaused
1230     {
1231         // Checks for payment.
1232         require(msg.value >= autoBirthFee);
1233 
1234         // Caller must own the matron.
1235         require(_owns(msg.sender, _matronId));
1236 
1237         require(_isMatingPermitted(_sireId, _matronId));
1238 
1239         // Grab a reference to the potential matron
1240         Pony storage matron = ponies[_matronId];
1241 
1242         // Make sure matron isn't pregnant, or in the middle of a siring cooldown
1243         require(_isReadyToMate(matron));
1244 
1245         // Grab a reference to the potential sire
1246         Pony storage sire = ponies[_sireId];
1247 
1248         // Make sure sire isn't pregnant, or in the middle of a siring cooldown
1249         require(_isReadyToMate(sire));
1250 
1251         // Test that these ponies are a valid mating pair.
1252         require(
1253             _isValidMatingPair(matron, _matronId, sire, _sireId)
1254         );
1255 
1256         if (_incubator == 0 && hasIncubator[msg.sender]) {
1257             _mateWith(_matronId, _sireId, _incubator);
1258         } else {
1259             bytes32 hashedTx = getIncubatorHashing(msg.sender, _incubator, nonces[msg.sender]);
1260             require(signedBySystem(hashedTx, _sig));
1261             nonces[msg.sender]++;
1262 
1263             // All checks passed, Pony gets pregnant!
1264             if (!hasIncubator[msg.sender]) {
1265                 hasIncubator[msg.sender] = true;
1266             }
1267             _mateWith(_matronId, _sireId, _incubator);
1268         }
1269     }
1270 
1271     /// @notice Have a pregnant Pony give birth!
1272     /// @param _matronId A Pony ready to give birth.
1273     /// @return The Pony ID of the new pony.
1274     /// @dev Looks at a given Pony and, if pregnant and if the gestation period has passed,
1275     ///  combines the genes of the two parents to create a new pony. The new Pony is assigned
1276     ///  to the current owner of the matron. Upon successful completion, both the matron and the
1277     ///  new pony will be ready to breed again. Note that anyone can call this function (if they
1278     ///  are willing to pay the gas!), but the new pony always goes to the mother's owner.
1279     function giveBirth(uint256 _matronId)
1280     external
1281     whenNotPaused
1282     returns (uint256)
1283     {
1284         // Grab a reference to the matron in storage.
1285         Pony storage matron = ponies[_matronId];
1286 
1287         // Check that the matron is a valid pony.
1288         require(matron.birthTime != 0);
1289 
1290         // Check that the matron is pregnant, and that its time has come!
1291         require(_isReadyToGiveBirth(matron));
1292 
1293         // Grab a reference to the sire in storage.
1294         uint256 sireId = matron.matingWithId;
1295         Pony storage sire = ponies[sireId];
1296 
1297         // Determine the higher generation number of the two parents
1298         uint16 parentGen = matron.generation;
1299         if (sire.generation > matron.generation) {
1300             parentGen = sire.generation;
1301         }
1302 
1303         // Call the sooper-sekret gene mixing operation.
1304         uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);
1305         // New Pony starts with the same cooldown as parent gen/20
1306         uint16 cooldownIndex = geneScience.processCooldown(parentGen + 1, block.number);
1307         if (cooldownIndex > 13) {
1308             cooldownIndex = 13;
1309         }
1310         // Make the new pony!
1311         address owner = ponyIndexToOwner[_matronId];
1312         uint256 ponyId = _createPony(_matronId, matron.matingWithId, parentGen + 1, childGenes, owner, cooldownIndex);
1313 
1314         // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
1315         // set is what marks a matron as being pregnant.)
1316         delete matron.matingWithId;
1317 
1318         // Every time a Pony gives birth counter is decremented.
1319         pregnantPonies--;
1320 
1321         // Send the balance fee to the person who made birth happen.
1322         msg.sender.transfer(autoBirthFee);
1323 
1324         // return the new pony's ID
1325         return ponyId;
1326     }
1327     
1328     function  setMatingSeason(bool _isMatingSeason) external onlyCLevel {
1329         geneScience.setMatingSeason(_isMatingSeason);
1330     }
1331 }
1332 
1333 
1334 /// @title Auction Core
1335 /// @dev Contains models, variables, and internal methods for the auction.
1336 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1337 contract ClockAuctionBase {
1338 
1339     // Represents an auction on an NFT
1340     struct Auction {
1341         // Current owner of NFT
1342         address seller;
1343         uint256 price;
1344         bool allowPayDekla;
1345     }
1346 
1347     // Reference to contract tracking NFT ownership
1348     ERC721 public nonFungibleContract;
1349 
1350     ERC20 public tokens;
1351 
1352     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
1353     // Values 0-10,000 map to 0%-100%
1354     uint256 public ownerCut = 500;
1355 
1356     // Map from token ID to their corresponding auction.
1357     mapping(uint256 => Auction) tokenIdToAuction;
1358 
1359     event AuctionCreated(uint256 tokenId);
1360     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
1361     event AuctionCancelled(uint256 tokenId);
1362 
1363     /// @dev Returns true if the claimant owns the token.
1364     /// @param _claimant - Address claiming to own the token.
1365     /// @param _tokenId - ID of token whose ownership to verify.
1366     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1367         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
1368     }
1369 
1370     /// @dev Escrows the NFT, assigning ownership to this contract.
1371     /// Throws if the escrow fails.
1372     /// @param _owner - Current owner address of token to escrow.
1373     /// @param _tokenId - ID of token whose approval to verify.
1374     function _escrow(address _owner, uint256 _tokenId) internal {
1375         // it will throw if transfer fails
1376         nonFungibleContract.transferFrom(_owner, this, _tokenId);
1377     }
1378 
1379     /// @dev Transfers an NFT owned by this contract to another address.
1380     /// Returns true if the transfer succeeds.
1381     /// @param _receiver - Address to transfer NFT to.
1382     /// @param _tokenId - ID of token to transfer.
1383     function _transfer(address _receiver, uint256 _tokenId) internal {
1384         // it will throw if transfer fails
1385         nonFungibleContract.transfer(_receiver, _tokenId);
1386     }
1387 
1388     /// @dev Adds an auction to the list of open auctions. Also fires the
1389     ///  AuctionCreated event.
1390     /// @param _tokenId The ID of the token to be put on auction.
1391     /// @param _auction Auction to add.
1392     function _addAuction(uint256 _tokenId, Auction _auction) internal {
1393 
1394         tokenIdToAuction[_tokenId] = _auction;
1395 
1396         emit AuctionCreated(
1397             uint256(_tokenId)
1398         );
1399     }
1400 
1401 
1402     /// @dev Computes the price and transfers winnings.
1403     /// Does NOT transfer ownership of token.
1404     function _bidEth(uint256 _tokenId, uint256 _bidAmount)
1405     internal
1406     returns (uint256)
1407     {
1408         // Get a reference to the auction struct
1409         Auction storage auction = tokenIdToAuction[_tokenId];
1410 
1411         require(!auction.allowPayDekla);
1412         // Explicitly check that this auction is currently live.
1413         // (Because of how Ethereum mappings work, we can't just count
1414         // on the lookup above failing. An invalid _tokenId will just
1415         // return an auction object that is all zeros.)
1416         require(_isOnAuction(auction));
1417 
1418         // Check that the bid is greater than or equal to the current price
1419         uint256 price = auction.price;
1420         require(_bidAmount >= price);
1421 
1422         // Grab a reference to the seller before the auction struct
1423         // gets deleted.
1424         address seller = auction.seller;
1425 
1426         // The bid is good! Remove the auction before sending the fees
1427         // to the sender so we can't have a reentrancy attack.
1428         _removeAuction(_tokenId);
1429 
1430         // Transfer proceeds to seller (if there are any!)
1431         if (price > 0) {
1432             // Calculate the auctioneer's cut.
1433             // (NOTE: _computeCut() is guaranteed to return a
1434             // value <= price, so this subtraction can't go negative.)
1435             uint256 auctioneerCut = _computeCut(price);
1436             uint256 sellerProceeds = price - auctioneerCut;
1437 
1438             seller.transfer(sellerProceeds);
1439         }
1440 
1441         // Tell the world!
1442         emit AuctionSuccessful(_tokenId, price, msg.sender);
1443 
1444         return price;
1445     }
1446 
1447     /// @dev Computes the price and transfers winnings.
1448     /// Does NOT transfer ownership of token.
1449     function _bidDkl(uint256 _tokenId, uint256 _bidAmount)
1450     internal
1451     returns (uint256)
1452     {
1453         // Get a reference to the auction struct
1454         Auction storage auction = tokenIdToAuction[_tokenId];
1455 
1456         require(auction.allowPayDekla);
1457         // Explicitly check that this auction is currently live.
1458         // (Because of how Ethereum mappings work, we can't just count
1459         // on the lookup above failing. An invalid _tokenId will just
1460         // return an auction object that is all zeros.)
1461         require(_isOnAuction(auction));
1462 
1463         // Check that the bid is greater than or equal to the current price
1464         uint256 price = auction.price;
1465         require(_bidAmount >= price);
1466 
1467         // Grab a reference to the seller before the auction struct
1468         // gets deleted.
1469         address seller = auction.seller;
1470 
1471         // The bid is good! Remove the auction before sending the fees
1472         // to the sender so we can't have a reentrancy attack.
1473         _removeAuction(_tokenId);
1474 
1475         // Transfer proceeds to seller (if there are any!)
1476         if (price > 0) {
1477             // Calculate the auctioneer's cut.
1478             // (NOTE: _computeCut() is guaranteed to return a
1479             // value <= price, so this subtraction can't go negative.)
1480             uint256 auctioneerCut = _computeCut(price);
1481             uint256 sellerProceeds = price - auctioneerCut;
1482 
1483             tokens.transfer(seller, sellerProceeds);
1484         }
1485         // Tell the world!
1486         emit AuctionSuccessful(_tokenId, price, msg.sender);
1487 
1488         return price;
1489     }
1490 
1491 
1492     /// @dev Cancels an auction unconditionally.
1493     function _cancelAuction(uint256 _tokenId, address _seller) internal {
1494         _removeAuction(_tokenId);
1495         _transfer(_seller, _tokenId);
1496         emit AuctionCancelled(_tokenId);
1497     }
1498 
1499     /// @dev Returns true if the NFT is on auction.
1500     /// @param _auction - Auction to check.
1501     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
1502         return (_auction.price > 0);
1503     }
1504 
1505     /// @dev Removes an auction from the list of open auctions.
1506     /// @param _tokenId - ID of NFT on auction.
1507     function _removeAuction(uint256 _tokenId) internal {
1508         delete tokenIdToAuction[_tokenId];
1509     }
1510 
1511 
1512 
1513     /// @dev Computes owner's cut of a sale.
1514     /// @param _price - Sale price of NFT.
1515     function _computeCut(uint256 _price) internal view returns (uint256) {
1516         // NOTE: We don't use SafeMath (or similar) in this function because
1517         //  all of our entry functions carefully cap the maximum values for
1518         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
1519         //  statement in the ClockAuction constructor). The result of this
1520         //  function is always guaranteed to be <= _price.
1521         return _price * ownerCut / 10000;
1522     }
1523 
1524 }
1525 
1526 
1527 
1528 
1529 
1530 
1531 
1532 /**
1533  * @title Pausable
1534  * @dev Base contract which allows children to implement an emergency stop mechanism.
1535  */
1536 contract Pausable is AccessControl{
1537     event Pause();
1538     event Unpause();
1539 
1540     bool public paused = false;
1541 
1542     /**
1543      * @dev modifier to allow actions only when the contract IS paused
1544      */
1545     modifier whenNotPaused() {
1546         require(!paused);
1547         _;
1548     }
1549 
1550     /**
1551      * @dev modifier to allow actions only when the contract IS NOT paused
1552      */
1553     modifier whenPaused {
1554         require(paused);
1555         _;
1556     }
1557 
1558     /**
1559      * @dev called by the owner to pause, triggers stopped state
1560      */
1561     function pause() onlyCEO whenNotPaused public returns (bool) {
1562         paused = true;
1563         emit Pause();
1564         return true;
1565     }
1566 
1567     /**
1568      * @dev called by the owner to unpause, returns to normal state
1569      */
1570     function unpause() onlyCEO whenPaused public returns (bool) {
1571         paused = false;
1572         emit Unpause();
1573         return true;
1574     }
1575 }
1576 
1577 
1578 /// @title Clock auction for non-fungible tokens.
1579 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1580 contract ClockAuction is Pausable, ClockAuctionBase {
1581 
1582     /// @dev The ERC-165 interface signature for ERC-721.
1583     ///  Ref: https://github.com/ethereum/EIPs/issues/165
1584     ///  Ref: https://github.com/ethereum/EIPs/issues/721
1585     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
1586 
1587     /// @dev Constructor creates a reference to the NFT ownership contract
1588     ///  and verifies the owner cut is in the valid range.
1589     /// @param _nftAddress - address of a deployed contract implementing
1590     ///  the Nonfungible Interface.
1591     constructor(address _nftAddress, address _tokenAddress) public {
1592         ERC721 candidateContract = ERC721(_nftAddress);
1593         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1594         tokens = ERC20(_tokenAddress);
1595         nonFungibleContract = candidateContract;
1596     }
1597 
1598 
1599     /// @dev Cancels an auction that hasn't been won yet.
1600     ///  Returns the NFT to original owner.
1601     /// @notice This is a state-modifying function that can
1602     ///  be called while the contract is paused.
1603     /// @param _tokenId - ID of token on auction
1604     function cancelAuction(uint256 _tokenId)
1605     external
1606     {
1607         Auction storage auction = tokenIdToAuction[_tokenId];
1608         address seller = auction.seller;
1609         require(msg.sender == seller);
1610         _cancelAuction(_tokenId, seller);
1611     }
1612 
1613     /// @dev Cancels an auction when the contract is paused.
1614     ///  Only the owner may do this, and NFTs are returned to
1615     ///  the seller. This should only be used in emergencies.
1616     /// @param _tokenId - ID of the NFT on auction to cancel.
1617     function cancelAuctionWhenPaused(uint256 _tokenId)
1618     whenPaused
1619     onlyCEO
1620     external
1621     {
1622         Auction storage auction = tokenIdToAuction[_tokenId];
1623         _cancelAuction(_tokenId, auction.seller);
1624     }
1625 
1626     /// @dev Returns auction info for an NFT on auction.
1627     /// @param _tokenId - ID of NFT on auction.
1628     function getAuction(uint256 _tokenId)
1629     external
1630     view
1631     returns
1632     (
1633         address seller,
1634         uint256 price,
1635         bool allowPayDekla
1636 
1637     ) {
1638         Auction storage auction = tokenIdToAuction[_tokenId];
1639         return (
1640         auction.seller,
1641         auction.price,
1642         auction.allowPayDekla
1643         );
1644     }
1645 
1646     /// @dev Returns the current price of an auction.
1647     /// @param _tokenId - ID of the token price we are checking.
1648     function getCurrentPrice(uint256 _tokenId)
1649     external
1650     view
1651     returns (uint256)
1652     {
1653         Auction storage auction = tokenIdToAuction[_tokenId];
1654         require(_isOnAuction(auction));
1655         return auction.price;
1656     }
1657 
1658 }
1659 
1660 
1661 /// @title Reverse auction modified for siring
1662 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1663 contract SiringClockAuction is ClockAuction {
1664 
1665     // @dev Sanity check that allows us to ensure that we are pointing to the
1666     //  right auction in our setSiringAuctionAddress() call.
1667     bool public isSiringClockAuction = true;
1668 
1669     uint256 public prizeCut = 100;
1670 
1671     uint256 public tokenDiscount = 100;
1672 
1673     address prizeAddress;
1674 
1675     // Delegate constructor
1676     constructor(address _nftAddr, address _tokenAddress, address _prizeAddress) public
1677     ClockAuction(_nftAddr, _tokenAddress) {
1678         prizeAddress = _prizeAddress;
1679     }
1680 
1681     /// @dev Creates and begins a new auction. Since this function is wrapped,
1682     /// require sender to be PonyCore contract.
1683     /// @param _tokenId - ID of token to auction, sender must be owner.
1684     /// @param _seller - Seller, if not the message sender
1685     function createEthAuction(
1686         uint256 _tokenId,
1687         address _seller,
1688         uint256 _price
1689     )
1690     external
1691     {
1692 
1693         require(msg.sender == address(nonFungibleContract));
1694         require(_price > 0);
1695         _escrow(_seller, _tokenId);
1696         Auction memory auction = Auction(
1697             _seller,
1698             _price,
1699             false
1700         );
1701         _addAuction(_tokenId, auction);
1702     }
1703 
1704     /// @dev Creates and begins a new auction. Since this function is wrapped,
1705     /// require sender to be PonyCore contract.
1706     /// @param _tokenId - ID of token to auction, sender must be owner.
1707     /// @param _seller - Seller, if not the message sender
1708     function createDklAuction(
1709         uint256 _tokenId,
1710         address _seller,
1711         uint256 _price
1712     )
1713     external
1714     {
1715 
1716         require(msg.sender == address(nonFungibleContract));
1717         require(_price > 0);
1718         _escrow(_seller, _tokenId);
1719         Auction memory auction = Auction(
1720             _seller,
1721             _price,
1722             true
1723         );
1724         _addAuction(_tokenId, auction);
1725     }
1726 
1727     /// @dev Places a bid for siring. Requires the sender
1728     /// is the PonyCore contract because all bid methods
1729     /// should be wrapped. Also returns the pony to the
1730     /// seller rather than the winner.
1731     function bidEth(uint256 _tokenId)
1732     external
1733     payable
1734     {
1735         require(msg.sender == address(nonFungibleContract));
1736         address seller = tokenIdToAuction[_tokenId].seller;
1737         // _bid checks that token ID is valid and will throw if bid fails
1738         _bidEth(_tokenId, msg.value);
1739         // We transfer the pony back to the seller, the winner will get
1740         // the offspring
1741 
1742         uint256 prizeAmount = (msg.value * prizeCut) / 10000;
1743         prizeAddress.transfer(prizeAmount);
1744 
1745         _transfer(seller, _tokenId);
1746     }
1747 
1748 
1749     function bidDkl(uint256 _tokenId,
1750         uint256 _price,
1751         uint256 _fee,
1752         bytes _signature,
1753         uint256 _nonce)
1754     external
1755     whenNotPaused
1756     {
1757         address seller = tokenIdToAuction[_tokenId].seller;
1758         tokens.transferPreSigned(_signature, address(this), _price, _fee, _nonce);
1759         // _bid will throw if the bid or funds transfer fails
1760         _bidDkl(_tokenId, _price);
1761         tokens.transfer(msg.sender, _fee);
1762         address spender = tokens.recoverSigner(_signature, address(this), _price, _fee, _nonce);
1763         uint256 discountAmount = (_price * tokenDiscount) / 10000;
1764         uint256 prizeAmount = (_price * prizeCut) / 10000;
1765         tokens.transfer(prizeAddress, prizeAmount);
1766         tokens.transfer(spender, discountAmount);
1767         _transfer(seller, _tokenId);
1768     }
1769 
1770     function setCut(uint256 _prizeCut, uint256 _tokenDiscount)
1771     external
1772     {
1773         require(msg.sender == address(nonFungibleContract));
1774         require(_prizeCut + _tokenDiscount < ownerCut);
1775 
1776         prizeCut = _prizeCut;
1777         tokenDiscount = _tokenDiscount;
1778     }
1779 
1780     /// @dev Remove all Ether from the contract, which is the owner's cuts
1781     ///  as well as any Ether sent directly to the contract address.
1782     ///  Always transfers to the NFT contract, but can be called either by
1783     ///  the owner or the NFT contract.
1784     function withdrawBalance() external {
1785         address nftAddress = address(nonFungibleContract);
1786 
1787         require(
1788             msg.sender == nftAddress
1789         );
1790 
1791         nftAddress.transfer(address(this).balance);
1792     }
1793 
1794     function withdrawDklBalance() external {
1795         address nftAddress = address(nonFungibleContract);
1796 
1797         require(
1798             msg.sender == nftAddress
1799         );
1800 
1801         tokens.transfer(nftAddress, tokens.balanceOf(this));
1802     }
1803 }
1804 
1805 
1806 
1807 
1808 
1809 /// @title Clock auction modified for sale of Ponies
1810 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1811 contract SaleClockAuction is ClockAuction {
1812 
1813     // @dev Sanity check that allows us to ensure that we are pointing to the
1814     //  right auction in our setSaleAuctionAddress() call.
1815     bool public isSaleClockAuction = true;
1816 
1817     uint256 public prizeCut = 100;
1818 
1819     uint256 public tokenDiscount = 100;
1820 
1821     address prizeAddress;
1822 
1823     // Tracks last 5 sale price of gen0 Pony sales
1824     uint256 public gen0SaleCount;
1825     uint256[5] public lastGen0SalePrices;
1826 
1827     // Delegate constructor
1828     constructor(address _nftAddr, address _token, address _prizeAddress) public
1829     ClockAuction(_nftAddr, _token) {
1830         prizeAddress = _prizeAddress;
1831     }
1832 
1833     /// @dev Creates and begins a new auction.
1834     /// @param _tokenId - ID of token to auction, sender must be owner.
1835     /// @param _seller - Seller, if not the message sender
1836     function createEthAuction(
1837         uint256 _tokenId,
1838         address _seller,
1839         uint256 _price
1840     )
1841     external
1842     {
1843 
1844         require(msg.sender == address(nonFungibleContract));
1845         _escrow(_seller, _tokenId);
1846         Auction memory auction = Auction(
1847             _seller,
1848             _price,
1849             false
1850         );
1851         _addAuction(_tokenId, auction);
1852     }
1853 
1854     /// @dev Creates and begins a new auction.
1855     /// @param _tokenId - ID of token to auction, sender must be owner.
1856     /// @param _seller - Seller, if not the message sender
1857     function createDklAuction(
1858         uint256 _tokenId,
1859         address _seller,
1860         uint256 _price
1861     )
1862     external
1863     {
1864 
1865         require(msg.sender == address(nonFungibleContract));
1866         _escrow(_seller, _tokenId);
1867         Auction memory auction = Auction(
1868             _seller,
1869             _price,
1870             true
1871         );
1872         _addAuction(_tokenId, auction);
1873     }
1874 
1875 
1876     function bidEth(uint256 _tokenId)
1877     external
1878     payable
1879     whenNotPaused
1880     {
1881         // _bid will throw if the bid or funds transfer fails
1882         _bidEth(_tokenId, msg.value);
1883         uint256 prizeAmount = (msg.value * prizeCut) / 10000;
1884         prizeAddress.transfer(prizeAmount);
1885         _transfer(msg.sender, _tokenId);
1886     }
1887 
1888 
1889     function bidDkl(uint256 _tokenId,
1890         uint256 _price,
1891         uint256 _fee,
1892         bytes _signature,
1893         uint256 _nonce)
1894     external
1895     whenNotPaused
1896     {
1897         address buyer = tokens.recoverSigner(_signature, address(this), _price, _fee, _nonce);
1898         tokens.transferPreSigned(_signature, address(this), _price, _fee, _nonce);
1899         // _bid will throw if the bid or funds transfer fails
1900         _bidDkl(_tokenId, _price);
1901         uint256 prizeAmount = (_price * prizeCut) / 10000;
1902         uint256 discountAmount = (_price * tokenDiscount) / 10000;
1903         tokens.transfer(buyer, discountAmount);
1904         tokens.transfer(prizeAddress, prizeAmount);
1905         _transfer(buyer, _tokenId);
1906     }
1907 
1908     function setCut(uint256 _prizeCut, uint256 _tokenDiscount)
1909     external
1910     {
1911         require(msg.sender == address(nonFungibleContract));
1912         require(_prizeCut + _tokenDiscount < ownerCut);
1913 
1914         prizeCut = _prizeCut;
1915         tokenDiscount = _tokenDiscount;
1916     }
1917 
1918     /// @dev Remove all Ether from the contract, which is the owner's cuts
1919     ///  as well as any Ether sent directly to the contract address.
1920     ///  Always transfers to the NFT contract, but can be called either by
1921     ///  the owner or the NFT contract.
1922     function withdrawBalance() external {
1923         address nftAddress = address(nonFungibleContract);
1924 
1925         require(
1926             msg.sender == nftAddress
1927         );
1928 
1929         nftAddress.transfer(address(this).balance);
1930     }
1931 
1932     function withdrawDklBalance() external {
1933         address nftAddress = address(nonFungibleContract);
1934 
1935         require(
1936             msg.sender == nftAddress
1937         );
1938 
1939         tokens.transfer(nftAddress, tokens.balanceOf(this));
1940     }
1941 }
1942 
1943 
1944 /// @title Handles creating auctions for sale and siring of Ponies.
1945 ///  This wrapper of ReverseAuction exists only so that users can create
1946 ///  auctions with only one transaction.
1947 contract PonyAuction is PonyBreeding {
1948 
1949     // @notice The auction contract variables are defined in PonyBase to allow
1950     //  us to refer to them in PonyOwnership to prevent accidental transfers.
1951     // `saleAuction` refers to the auction for gen0 and p2p sale of Ponies.
1952     // `siringAuction` refers to the auction for siring rights of Ponies.
1953 
1954     /// @dev Sets the reference to the sale auction.
1955     /// @param _address - Address of sale contract.
1956     function setSaleAuctionAddress(address _address) external onlyCEO {
1957         SaleClockAuction candidateContract = SaleClockAuction(_address);
1958 
1959         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1960         require(candidateContract.isSaleClockAuction());
1961 
1962         // Set the new contract address
1963         saleAuction = candidateContract;
1964     }
1965 
1966     /// @dev Sets the reference to the siring auction.
1967     /// @param _address - Address of siring contract.
1968     function setSiringAuctionAddress(address _address) external onlyCEO {
1969         SiringClockAuction candidateContract = SiringClockAuction(_address);
1970 
1971         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1972         require(candidateContract.isSiringClockAuction());
1973 
1974         // Set the new contract address
1975         siringAuction = candidateContract;
1976     }
1977 
1978     /// @dev Sets the reference to the bidding auction.
1979     /// @param _address - Address of bidding contract.
1980     function setBiddingAuctionAddress(address _address) external onlyCEO {
1981         BiddingClockAuction candidateContract = BiddingClockAuction(_address);
1982 
1983         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1984         require(candidateContract.isBiddingClockAuction());
1985 
1986         // Set the new contract address
1987         biddingAuction = candidateContract;
1988     }
1989 
1990 
1991     /// @dev Put a Pony up for auction.
1992     ///  Does some ownership trickery to create auctions in one tx.
1993     function createEthSaleAuction(
1994         uint256 _PonyId,
1995         uint256 _price
1996     )
1997     external
1998     whenNotPaused
1999     {
2000         // Auction contract checks input sizes
2001         // If Pony is already on any auction, this will throw
2002         // because it will be owned by the auction contract.
2003         require(_owns(msg.sender, _PonyId));
2004         // Ensure the Pony is not pregnant to prevent the auction
2005         // contract accidentally receiving ownership of the child.
2006         // NOTE: the Pony IS allowed to be in a cooldown.
2007         require(!isPregnant(_PonyId));
2008         _approve(_PonyId, saleAuction);
2009         // Sale auction throws if inputs are invalid and clears
2010         // transfer and sire approval after escrowing the Pony.
2011         saleAuction.createEthAuction(
2012             _PonyId,
2013             msg.sender,
2014             _price
2015         );
2016     }
2017 
2018 
2019     /// @dev Put a Pony up for auction.
2020     ///  Does some ownership trickery to create auctions in one tx.
2021     function delegateDklSaleAuction(
2022         uint256 _tokenId,
2023         uint256 _price,
2024         bytes _ponySig,
2025         uint256 _nonce
2026     )
2027     external
2028     whenNotPaused
2029     {
2030         bytes32 hashedTx = approvePreSignedHashing(address(this), saleAuction, _tokenId, _nonce);
2031         address from = recover(hashedTx, _ponySig);
2032         // Auction contract checks input sizes
2033         // If Pony is already on any auction, this will throw
2034         // because it will be owned by the auction contract.
2035         require(_owns(from, _tokenId));
2036         // Ensure the Pony is not pregnant to prevent the auction
2037         // contract accidentally receiving ownership of the child.
2038         // NOTE: the Pony IS allowed to be in a cooldown.
2039         require(!isPregnant(_tokenId));
2040         approvePreSigned(_ponySig, saleAuction, _tokenId, _nonce);
2041         // Sale auction throws if inputs are invalid and clears
2042         // transfer and sire approval after escrowing the Pony.
2043         saleAuction.createDklAuction(
2044             _tokenId,
2045             from,
2046             _price
2047         );
2048     }
2049 
2050 
2051     /// @dev Put a Pony up for auction.
2052     ///  Does some ownership trickery to create auctions in one tx.
2053     function delegateDklSiringAuction(
2054         uint256 _tokenId,
2055         uint256 _price,
2056         bytes _ponySig,
2057         uint256 _nonce
2058     )
2059     external
2060     whenNotPaused
2061     {
2062         bytes32 hashedTx = approvePreSignedHashing(address(this), siringAuction, _tokenId, _nonce);
2063         address from = recover(hashedTx, _ponySig);
2064         // Auction contract checks input sizes
2065         // If Pony is already on any auction, this will throw
2066         // because it will be owned by the auction contract.
2067         require(_owns(from, _tokenId));
2068         // Ensure the Pony is not pregnant to prevent the auction
2069         // contract accidentally receiving ownership of the child.
2070         // NOTE: the Pony IS allowed to be in a cooldown.
2071         require(!isPregnant(_tokenId));
2072         approvePreSigned(_ponySig, siringAuction, _tokenId, _nonce);
2073         // Sale auction throws if inputs are invalid and clears
2074         // transfer and sire approval after escrowing the Pony.
2075         siringAuction.createDklAuction(
2076             _tokenId,
2077             from,
2078             _price
2079         );
2080     }
2081 
2082     /// @dev Put a Pony up for auction.
2083     ///  Does some ownership trickery to create auctions in one tx.
2084     function delegateDklBidAuction(
2085         uint256 _tokenId,
2086         uint256 _price,
2087         bytes _ponySig,
2088         uint256 _nonce,
2089         uint16 _durationIndex
2090     )
2091     external
2092     whenNotPaused
2093     {
2094         bytes32 hashedTx = approvePreSignedHashing(address(this), biddingAuction, _tokenId, _nonce);
2095         address from = recover(hashedTx, _ponySig);
2096         // Auction contract checks input sizes
2097         // If Pony is already on any auction, this will throw
2098         // because it will be owned by the auction contract.
2099         require(_owns(from, _tokenId));
2100         // Ensure the Pony is not pregnant to prevent the auction
2101         // contract accidentally receiving ownership of the child.
2102         // NOTE: the Pony IS allowed to be in a cooldown.
2103         require(!isPregnant(_tokenId));
2104         approvePreSigned(_ponySig, biddingAuction, _tokenId, _nonce);
2105         // Sale auction throws if inputs are invalid and clears
2106         // transfer and sire approval after escrowing the Pony.
2107         biddingAuction.createDklAuction(_tokenId, from, _durationIndex, _price);
2108     }
2109 
2110 
2111     /// @dev Put a Pony up for auction to be sire.
2112     ///  Performs checks to ensure the Pony can be sired, then
2113     ///  delegates to reverse auction.
2114     function createEthSiringAuction(
2115         uint256 _PonyId,
2116         uint256 _price
2117     )
2118     external
2119     whenNotPaused
2120     {
2121         // Auction contract checks input sizes
2122         // If Pony is already on any auction, this will throw
2123         // because it will be owned by the auction contract.
2124         require(_owns(msg.sender, _PonyId));
2125         require(isReadyToMate(_PonyId));
2126         _approve(_PonyId, siringAuction);
2127         // Siring auction throws if inputs are invalid and clears
2128         // transfer and sire approval after escrowing the Pony.
2129         siringAuction.createEthAuction(
2130             _PonyId,
2131             msg.sender,
2132             _price
2133         );
2134     }
2135 
2136     /// @dev Put a Pony up for auction.
2137     ///  Does some ownership trickery to create auctions in one tx.
2138     function createDklSaleAuction(
2139         uint256 _PonyId,
2140         uint256 _price
2141     )
2142     external
2143     whenNotPaused
2144     {
2145         // Auction contract checks input sizes
2146         // If Pony is already on any auction, this will throw
2147         // because it will be owned by the auction contract.
2148         require(_owns(msg.sender, _PonyId));
2149         // Ensure the Pony is not pregnant to prevent the auction
2150         // contract accidentally receiving ownership of the child.
2151         // NOTE: the Pony IS allowed to be in a cooldown.
2152         require(!isPregnant(_PonyId));
2153         _approve(_PonyId, saleAuction);
2154         // Sale auction throws if inputs are invalid and clears
2155         // transfer and sire approval after escrowing the Pony.
2156         saleAuction.createDklAuction(
2157             _PonyId,
2158             msg.sender,
2159             _price
2160         );
2161     }
2162 
2163     /// @dev Put a Pony up for auction to be sire.
2164     ///  Performs checks to ensure the Pony can be sired, then
2165     ///  delegates to reverse auction.
2166     function createDklSiringAuction(
2167         uint256 _PonyId,
2168         uint256 _price
2169     )
2170     external
2171     whenNotPaused
2172     {
2173         // Auction contract checks input sizes
2174         // If Pony is already on any auction, this will throw
2175         // because it will be owned by the auction contract.
2176         require(_owns(msg.sender, _PonyId));
2177         require(isReadyToMate(_PonyId));
2178         _approve(_PonyId, siringAuction);
2179         // Siring auction throws if inputs are invalid and clears
2180         // transfer and sire approval after escrowing the Pony.
2181         siringAuction.createDklAuction(
2182             _PonyId,
2183             msg.sender,
2184             _price
2185         );
2186     }
2187 
2188     function createEthBidAuction(
2189         uint256 _ponyId,
2190         uint256 _price,
2191         uint16 _durationIndex
2192     ) external whenNotPaused {
2193         require(_owns(msg.sender, _ponyId));
2194         _approve(_ponyId, biddingAuction);
2195         biddingAuction.createETHAuction(_ponyId, msg.sender, _durationIndex, _price);
2196     }
2197 
2198     function createDeklaBidAuction(
2199         uint256 _ponyId,
2200         uint256 _price,
2201         uint16 _durationIndex
2202     ) external whenNotPaused {
2203         require(_owns(msg.sender, _ponyId));
2204         _approve(_ponyId, biddingAuction);
2205         biddingAuction.createDklAuction(_ponyId, msg.sender, _durationIndex, _price);
2206     }
2207 
2208     /// @dev Completes a siring auction by bidding.
2209     ///  Immediately breeds the winning matron with the sire on auction.
2210     /// @param _sireId - ID of the sire on auction.
2211     /// @param _matronId - ID of the matron owned by the bidder.
2212     function bidOnEthSiringAuction(
2213         uint256 _sireId,
2214         uint256 _matronId,
2215         uint8 _incubator,
2216         bytes _sig
2217     )
2218     external
2219     payable
2220     whenNotPaused
2221     {
2222         // Auction contract checks input sizes
2223         require(_owns(msg.sender, _matronId));
2224         require(isReadyToMate(_matronId));
2225         require(canMateWithViaAuction(_matronId, _sireId));
2226 
2227         // Define the current price of the auction.
2228         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
2229         require(msg.value >= currentPrice + autoBirthFee);
2230 
2231         // Siring auction will throw if the bid fails.
2232         siringAuction.bidEth.value(msg.value - autoBirthFee)(_sireId);
2233         if (_incubator == 0 && hasIncubator[msg.sender]) {
2234             _mateWith(_matronId, _sireId, _incubator);
2235         } else {
2236             bytes32 hashedTx = getIncubatorHashing(msg.sender, _incubator, nonces[msg.sender]);
2237             require(signedBySystem(hashedTx, _sig));
2238             nonces[msg.sender]++;
2239 
2240             // All checks passed, Pony gets pregnant!
2241             if (!hasIncubator[msg.sender]) {
2242                 hasIncubator[msg.sender] = true;
2243             }
2244             _mateWith(_matronId, _sireId, _incubator);
2245         }
2246     }
2247 
2248     /// @dev Completes a siring auction by bidding.
2249     ///  Immediately breeds the winning matron with the sire on auction.
2250     /// @param _sireId - ID of the sire on auction.
2251     /// @param _matronId - ID of the matron owned by the bidder.
2252     function bidOnDklSiringAuction(
2253         uint256 _sireId,
2254         uint256 _matronId,
2255         uint8 _incubator,
2256         bytes _incubatorSig,
2257         uint256 _price,
2258         uint256 _fee,
2259         bytes _delegateSig,
2260         uint256 _nonce
2261 
2262     )
2263     external
2264     payable
2265     whenNotPaused
2266     {
2267         // Auction contract checks input sizes
2268         require(_owns(msg.sender, _matronId));
2269         require(isReadyToMate(_matronId));
2270         require(canMateWithViaAuction(_matronId, _sireId));
2271 
2272         // Define the current price of the auction.
2273         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
2274         require(msg.value >= autoBirthFee);
2275         require(_price >= currentPrice);
2276 
2277         // Siring auction will throw if the bid fails.
2278         siringAuction.bidDkl(_sireId, _price, _fee, _delegateSig, _nonce);
2279         if (_incubator == 0 && hasIncubator[msg.sender]) {
2280             _mateWith(_matronId, _sireId, _incubator);
2281         } else {
2282             bytes32 hashedTx = getIncubatorHashing(msg.sender, _incubator, nonces[msg.sender]);
2283             require(signedBySystem(hashedTx, _incubatorSig));
2284             nonces[msg.sender]++;
2285 
2286             // All checks passed, Pony gets pregnant!
2287             if (!hasIncubator[msg.sender]) {
2288                 hasIncubator[msg.sender] = true;
2289             }
2290             _mateWith(_matronId, _sireId, _incubator);
2291         }
2292     }
2293 
2294     /// @dev Transfers the balance of the sale auction contract
2295     /// to the PonyCore contract. We use two-step withdrawal to
2296     /// prevent two transfer calls in the auction bid function.
2297     function withdrawAuctionBalances() external onlyCLevel {
2298         saleAuction.withdrawBalance();
2299         siringAuction.withdrawBalance();
2300         biddingAuction.withdrawBalance();
2301     }
2302 
2303     function withdrawAuctionDklBalance() external onlyCLevel {
2304         saleAuction.withdrawDklBalance();
2305         siringAuction.withdrawDklBalance();
2306         biddingAuction.withdrawDklBalance();
2307     }
2308 
2309 
2310     function setBiddingRate(uint256 _prizeCut, uint256 _tokenDiscount) external onlyCLevel {
2311         biddingAuction.setCut(_prizeCut, _tokenDiscount);
2312     }
2313 
2314     function setSaleRate(uint256 _prizeCut, uint256 _tokenDiscount) external onlyCLevel {
2315         saleAuction.setCut(_prizeCut, _tokenDiscount);
2316     }
2317 
2318     function setSiringRate(uint256 _prizeCut, uint256 _tokenDiscount) external onlyCLevel {
2319         siringAuction.setCut(_prizeCut, _tokenDiscount);
2320     }
2321 }
2322 
2323 /// @title Auction Core
2324 /// @dev Contains models, variables, and internal methods for the auction.
2325 /// @notice We omit a fallback function to prevent accidental sends to this contract.
2326 contract BiddingAuctionBase {
2327     // An approximation of currently how many seconds are in between blocks.
2328     uint256 public secondsPerBlock = 15;
2329 
2330     // Represents an auction on an NFT
2331     struct Auction {
2332         // Current owner of NFT
2333         address seller;
2334         // Duration (in seconds) of auction
2335         uint16 durationIndex;
2336         // Time when auction started
2337         // NOTE: 0 if this auction has been concluded
2338         uint64 startedAt;
2339 
2340         uint64 auctionEndBlock;
2341         // Price (in wei) at beginning of auction
2342         uint256 startingPrice;
2343 
2344         bool allowPayDekla;
2345     }
2346 
2347     uint32[4] public auctionDuration = [
2348     //production
2349      uint32(2 days),
2350      uint32(3 days),
2351      uint32(4 days),
2352      uint32(5 days)
2353     ];
2354 
2355     // Reference to contract tracking NFT ownership
2356     ERC721 public nonFungibleContract;
2357 
2358 
2359     uint256 public ownerCut = 500;
2360 
2361     // Map from token ID to their corresponding auction.
2362     mapping(uint256 => Auction) public tokenIdToAuction;
2363 
2364     event AuctionCreated(uint256 tokenId);
2365     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
2366     event AuctionCancelled(uint256 tokenId);
2367 
2368     /// @dev Returns true if the claimant owns the token.
2369     /// @param _claimant - Address claiming to own the token.
2370     /// @param _tokenId - ID of token whose ownership to verify.
2371     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
2372         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
2373     }
2374 
2375     /// @dev Escrows the NFT, assigning ownership to this contract.
2376     /// Throws if the escrow fails.
2377     /// @param _owner - Current owner address of token to escrow.
2378     /// @param _tokenId - ID of token whose approval to verify.
2379     function _escrow(address _owner, uint256 _tokenId) internal {
2380         // it will throw if transfer fails
2381         nonFungibleContract.transferFrom(_owner, this, _tokenId);
2382     }
2383 
2384     /// @dev Transfers an NFT owned by this contract to another address.
2385     /// Returns true if the transfer succeeds.
2386     /// @param _receiver - Address to transfer NFT to.
2387     /// @param _tokenId - ID of token to transfer.
2388     function _transfer(address _receiver, uint256 _tokenId) internal {
2389         // it will throw if transfer fails
2390         nonFungibleContract.transfer(_receiver, _tokenId);
2391     }
2392 
2393     /// @dev Adds an auction to the list of open auctions. Also fires the
2394     ///  AuctionCreated event.
2395     /// @param _tokenId The ID of the token to be put on auction.
2396     /// @param _auction Auction to add.
2397     function _addAuction(uint256 _tokenId, Auction _auction) internal {
2398 
2399         tokenIdToAuction[_tokenId] = _auction;
2400 
2401         emit AuctionCreated(
2402             uint256(_tokenId)
2403         );
2404     }
2405 
2406     /// @dev Cancels an auction unconditionally.
2407     function _cancelAuction(uint256 _tokenId, address _seller) internal {
2408         _removeAuction(_tokenId);
2409         _transfer(_seller, _tokenId);
2410         emit AuctionCancelled(_tokenId);
2411     }
2412 
2413 
2414     /// @dev Removes an auction from the list of open auctions.
2415     /// @param _tokenId - ID of NFT on auction.
2416     function _removeAuction(uint256 _tokenId) internal {
2417         delete tokenIdToAuction[_tokenId];
2418     }
2419 
2420 
2421 
2422     /// @dev Computes owner's cut of a sale.
2423     /// @param _price - Sale price of NFT.
2424     function _computeCut(uint256 _price) internal view returns (uint256) {
2425         // NOTE: We don't use SafeMath (or similar) in this function because
2426         //  all of our entry functions carefully cap the maximum values for
2427         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
2428         //  statement in the ClockAuction constructor). The result of this
2429         //  function is always guaranteed to be <= _price.
2430         return _price * ownerCut / 10000;
2431     }
2432 
2433 }
2434 
2435 
2436 /// @title Clock auction for non-fungible tokens.
2437 /// @notice We omit a fallback function to prevent accidental sends to this contract.
2438 contract BiddingAuction is Pausable, BiddingAuctionBase {
2439     /// @dev The ERC-165 interface signature for ERC-721.
2440     ///  Ref: https://github.com/ethereum/EIPs/issues/165
2441     ///  Ref: https://github.com/ethereum/EIPs/issues/721
2442     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
2443 
2444 
2445 
2446     /// @dev Constructor creates a reference to the NFT ownership contract
2447     ///  and verifies the owner cut is in the valid range.
2448     /// @param _nftAddress - address of a deployed contract implementing
2449     ///  the Nonfungible Interface.
2450     constructor(address _nftAddress) public {
2451 
2452         ERC721 candidateContract = ERC721(_nftAddress);
2453         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
2454         nonFungibleContract = candidateContract;
2455     }
2456 
2457     function cancelAuctionHashing(
2458         uint256 _tokenId,
2459         uint64 _endblock
2460     )
2461     public
2462     pure
2463     returns (bytes32)
2464     {
2465         return keccak256(abi.encodePacked(bytes4(0x486A0E9E), _tokenId, _endblock));
2466     }
2467 
2468     /// @dev Cancels an auction that hasn't been won yet.
2469     ///  Returns the NFT to original owner.
2470     /// @notice This is a state-modifying function that can
2471     ///  be called while the contract is paused.
2472     /// @param _tokenId - ID of token on auction
2473     function cancelAuction(
2474         uint256 _tokenId,
2475         bytes _sig
2476     )
2477     external
2478     {
2479         Auction storage auction = tokenIdToAuction[_tokenId];
2480         address seller = auction.seller;
2481         uint64 endblock = auction.auctionEndBlock;
2482         require(msg.sender == seller);
2483         require(endblock < block.number);
2484 
2485         bytes32 hashedTx = cancelAuctionHashing(_tokenId, endblock);
2486         require(signedBySystem(hashedTx, _sig));
2487 
2488         _cancelAuction(_tokenId, seller);
2489     }
2490 
2491     /// @dev Cancels an auction when the contract is paused.
2492     ///  Only the owner may do this, and NFTs are returned to
2493     ///  the seller. This should only be used in emergencies.
2494     /// @param _tokenId - ID of the NFT on auction to cancel.
2495     function cancelAuctionWhenPaused(uint256 _tokenId)
2496     whenPaused
2497     onlyCLevel
2498     external
2499     {
2500         Auction storage auction = tokenIdToAuction[_tokenId];
2501         _cancelAuction(_tokenId, auction.seller);
2502     }
2503 
2504     /// @dev Returns auction info for an NFT on auction.
2505     /// @param _tokenId - ID of NFT on auction.
2506     function getAuction(uint256 _tokenId)
2507     external
2508     view
2509     returns
2510     (
2511         address seller,
2512         uint64 startedAt,
2513         uint16 durationIndex,
2514         uint64 auctionEndBlock,
2515         uint256 startingPrice,
2516         bool allowPayDekla
2517     ) {
2518         Auction storage auction = tokenIdToAuction[_tokenId];
2519         return (
2520         auction.seller,
2521         auction.startedAt,
2522         auction.durationIndex,
2523         auction.auctionEndBlock,
2524         auction.startingPrice,
2525         auction.allowPayDekla
2526         );
2527     }
2528 
2529     function setSecondsPerBlock(uint256 secs) external onlyCEO {
2530         secondsPerBlock = secs;
2531     }
2532 
2533 }
2534 
2535 
2536 contract BiddingWallet is AccessControl {
2537 
2538     //user balances is stored in this balances map and could be withdraw by owner at anytime
2539     mapping(address => uint) public EthBalances;
2540 
2541     mapping(address => uint) public DeklaBalances;
2542 
2543     ERC20 public tokens;
2544 
2545     //the limit of deposit and withdraw the minimum amount you can deposit is 0.05 eth
2546     //you also have to have at least 0.05 eth
2547     uint public EthLimit = 50000000000000000;
2548     uint public DeklaLimit = 100;
2549 
2550     uint256 public totalEthDeposit;
2551     uint256 public totalDklDeposit;
2552 
2553     event withdrawSuccess(address receiver, uint amount);
2554     event cancelPendingWithdrawSuccess(address sender);
2555 
2556     function getNonces(address _address) public view returns (uint256) {
2557         return nonces[_address];
2558     }
2559 
2560     function setSystemAddress(address _systemAddress, address _tokenAddress) internal {
2561         systemAddress = _systemAddress;
2562         tokens = ERC20(_tokenAddress);
2563     }
2564 
2565     //user will be assign an equivalent amount of bidding credit to bid
2566     function depositETH() payable external {
2567         require(msg.value >= EthLimit);
2568         EthBalances[msg.sender] = EthBalances[msg.sender] + msg.value;
2569         totalEthDeposit = totalEthDeposit + msg.value;
2570     }
2571 
2572     function depositDekla(
2573         uint256 _amount,
2574         uint256 _fee,
2575         bytes _signature,
2576         uint256 _nonce)
2577     external {
2578         address sender = tokens.recoverSigner(_signature, address(this), _amount, _fee, _nonce);
2579         tokens.transferPreSigned(_signature, address(this), _amount, _fee, _nonce);
2580         DeklaBalances[sender] = DeklaBalances[sender] + _amount;
2581         totalDklDeposit = totalDklDeposit + _amount;
2582     }
2583 
2584 
2585     function withdrawAmountHashing(uint256 _amount, uint256 _nonce) public pure returns (bytes32) {
2586         return keccak256(abi.encodePacked(bytes4(0x486A0E9B), _amount, _nonce));
2587     }
2588 
2589     // Withdraw all available eth back to user wallet, need co-verify
2590     function withdrawEth(
2591         uint256 _amount,
2592         bytes _sig
2593     ) external {
2594         require(EthBalances[msg.sender] >= _amount);
2595 
2596         bytes32 hashedTx = withdrawAmountHashing(_amount, nonces[msg.sender]);
2597         require(signedBySystem(hashedTx, _sig));
2598 
2599         EthBalances[msg.sender] = EthBalances[msg.sender] - _amount;
2600         totalEthDeposit = totalEthDeposit - _amount;
2601         msg.sender.transfer(_amount);
2602 
2603         nonces[msg.sender]++;
2604         emit withdrawSuccess(msg.sender, _amount);
2605     }
2606 
2607     // Withdraw all available dekla back to user wallet, need co-verify
2608     function withdrawDekla(
2609         uint256 _amount,
2610         bytes _sig
2611     ) external {
2612         require(DeklaBalances[msg.sender] >= _amount);
2613 
2614         bytes32 hashedTx = withdrawAmountHashing(_amount, nonces[msg.sender]);
2615         require(signedBySystem(hashedTx, _sig));
2616 
2617         DeklaBalances[msg.sender] = DeklaBalances[msg.sender] - _amount;
2618         totalDklDeposit = totalDklDeposit - _amount;
2619         tokens.transfer(msg.sender, _amount);
2620 
2621         nonces[msg.sender]++;
2622         emit withdrawSuccess(msg.sender, _amount);
2623     }
2624 
2625 
2626     event valueLogger(uint256 value);
2627     //bidding success tranfer eth to seller wallet
2628     function winBidEth(
2629         address winner,
2630         address seller,
2631         uint256 sellerProceeds,
2632         uint256 auctioneerCut
2633     ) internal {
2634         require(EthBalances[winner] >= sellerProceeds + auctioneerCut);
2635         seller.transfer(sellerProceeds);
2636         EthBalances[winner] = EthBalances[winner] - (sellerProceeds + auctioneerCut);
2637     }
2638 
2639     //bidding success tranfer eth to seller wallet
2640     function winBidDekla(
2641         address winner,
2642         address seller,
2643         uint256 sellerProceeds,
2644         uint256 auctioneerCut
2645     ) internal {
2646         require(DeklaBalances[winner] >= sellerProceeds + auctioneerCut);
2647         tokens.transfer(seller, sellerProceeds);
2648         DeklaBalances[winner] = DeklaBalances[winner] - (sellerProceeds + auctioneerCut);
2649     }
2650 
2651     function() public {
2652         revert();
2653     }
2654 }
2655 
2656 
2657 /// @title Reverse auction modified for siring
2658 /// @notice We omit a fallback function to prevent accidental sends to this contract.
2659 contract BiddingClockAuction is BiddingAuction, BiddingWallet {
2660 
2661     address public prizeAddress;
2662 
2663     uint256 public prizeCut = 100;
2664 
2665     uint256 public tokenDiscount = 100;
2666     // @dev Sanity check that allows us to ensure that we are pointing to the
2667     //  right auction in our setSiringAuctionAddress() call.
2668     bool public isBiddingClockAuction = true;
2669 
2670     modifier onlySystem() {
2671         require(msg.sender == systemAddress);
2672         _;
2673     }
2674 
2675     // Delegate constructor
2676     constructor(
2677         address _nftAddr,
2678         address _tokenAddress,
2679         address _prizeAddress,
2680         address _systemAddress,
2681         address _ceoAddress,
2682         address _cfoAddress,
2683         address _cooAddress)
2684     public
2685     BiddingAuction(_nftAddr) {
2686         // validate address
2687         require(_systemAddress != address(0));
2688         require(_tokenAddress != address(0));
2689         require(_ceoAddress != address(0));
2690         require(_cooAddress != address(0));
2691         require(_cfoAddress != address(0));
2692         require(_prizeAddress != address(0));
2693 
2694         setSystemAddress(_systemAddress, _tokenAddress);
2695 
2696         ceoAddress = _ceoAddress;
2697         cooAddress = _cooAddress;
2698         cfoAddress = _cfoAddress;
2699         prizeAddress = _prizeAddress;
2700     }
2701 
2702 
2703     /// @dev Creates and begins a new auction. Since this function is wrapped,
2704     /// require sender to be PonyCore contract.
2705     function createETHAuction(
2706         uint256 _tokenId,
2707         address _seller,
2708         uint16 _durationIndex,
2709         uint256 _startingPrice
2710     )
2711     external
2712     {
2713         require(msg.sender == address(nonFungibleContract));
2714         _escrow(_seller, _tokenId);
2715         uint64 auctionEndBlock = uint64((auctionDuration[_durationIndex] / secondsPerBlock) + block.number);
2716         Auction memory auction = Auction(
2717             _seller,
2718             _durationIndex,
2719             uint64(now),
2720             auctionEndBlock,
2721             _startingPrice,
2722             false
2723         );
2724         _addAuction(_tokenId, auction);
2725     }
2726 
2727     function setCut(uint256 _prizeCut, uint256 _tokenDiscount)
2728     external
2729     {
2730         require(msg.sender == address(nonFungibleContract));
2731         require(_prizeCut + _tokenDiscount < ownerCut);
2732 
2733         prizeCut = _prizeCut;
2734         tokenDiscount = _tokenDiscount;
2735     }
2736 
2737     /// @dev Creates and begins a new auction. Since this function is wrapped,
2738     /// require sender to be PonyCore contract.
2739     function createDklAuction(
2740         uint256 _tokenId,
2741         address _seller,
2742         uint16 _durationIndex,
2743         uint256 _startingPrice
2744     )
2745     external
2746 
2747     {
2748         require(msg.sender == address(nonFungibleContract));
2749         _escrow(_seller, _tokenId);
2750         uint64 auctionEndBlock = uint64((auctionDuration[_durationIndex] / secondsPerBlock) + block.number);
2751         Auction memory auction = Auction(
2752             _seller,
2753             _durationIndex,
2754             uint64(now),
2755             auctionEndBlock,
2756             _startingPrice,
2757             true
2758         );
2759         _addAuction(_tokenId, auction);
2760     }
2761 
2762     function getNonces(address _address) public view returns (uint256) {
2763         return nonces[_address];
2764     }
2765 
2766     function auctionEndHashing(uint _amount, uint256 _tokenId) public pure returns (bytes32) {
2767         return keccak256(abi.encodePacked(bytes4(0x486A0F0E), _tokenId, _amount));
2768     }
2769 
2770     function auctionEthEnd(address _winner, uint _amount, uint256 _tokenId, bytes _sig) public onlySystem {
2771         bytes32 hashedTx = auctionEndHashing(_amount, _tokenId);
2772         require(recover(hashedTx, _sig) == _winner);
2773         Auction storage auction = tokenIdToAuction[_tokenId];
2774         uint64 endblock = auction.auctionEndBlock;
2775         require(endblock < block.number);
2776         require(!auction.allowPayDekla);
2777         uint256 prize = _amount * prizeCut / 10000;
2778         uint256 auctioneerCut = _computeCut(_amount) - prize;
2779         uint256 sellerProceeds = _amount - auctioneerCut;
2780         winBidEth(_winner, auction.seller, sellerProceeds, auctioneerCut);
2781         prizeAddress.transfer(prize);
2782         _removeAuction(_tokenId);
2783         _transfer(_winner, _tokenId);
2784         emit AuctionSuccessful(_tokenId, _amount, _winner);
2785     }
2786 
2787     function auctionDeklaEnd(address _winner, uint _amount, uint256 _tokenId, bytes _sig) public onlySystem {
2788         bytes32 hashedTx = auctionEndHashing(_amount, _tokenId);
2789         require(recover(hashedTx, _sig) == _winner);
2790         Auction storage auction = tokenIdToAuction[_tokenId];
2791         uint64 endblock = auction.auctionEndBlock;
2792         require(endblock < block.number);
2793         require(auction.allowPayDekla);
2794         uint256 prize = _amount * prizeCut / 10000;
2795         uint256 discountAmount = _amount * tokenDiscount / 10000;
2796         uint256 auctioneerCut = _computeCut(_amount) - discountAmount - prizeCut;
2797         uint256 sellerProceeds = _amount - auctioneerCut;
2798         winBidDekla(_winner, auction.seller, sellerProceeds, auctioneerCut);
2799         tokens.transfer(prizeAddress, prize);
2800         tokens.transfer(_winner, discountAmount);
2801         _removeAuction(_tokenId);
2802         _transfer(_winner, _tokenId);
2803         emit AuctionSuccessful(_tokenId, _amount, _winner);
2804     }
2805 
2806     /// @dev Remove all Ether from the contract, which is the owner's cuts
2807     ///  as well as any Ether sent directly to the contract address.
2808     ///  Always transfers to the NFT contract, but can be called either by
2809     ///  the owner or the NFT contract.
2810     function withdrawBalance() external {
2811         address nftAddress = address(nonFungibleContract);
2812 
2813         require(
2814             msg.sender == nftAddress
2815         );
2816 
2817         nftAddress.transfer(address(this).balance - totalEthDeposit);
2818     }
2819 
2820     function withdrawDklBalance() external {
2821         address nftAddress = address(nonFungibleContract);
2822 
2823         require(
2824             msg.sender == nftAddress
2825         );
2826         tokens.transfer(nftAddress, tokens.balanceOf(this) - totalDklDeposit);
2827     }
2828 }
2829 
2830 /// @title all functions related to creating ponies
2831 contract PonyMinting is PonyAuction {
2832 
2833     // Limits the number of ponies the contract owner can ever create.
2834     uint256 public constant PROMO_CREATION_LIMIT = 50;
2835     uint256 public constant GEN0_CREATION_LIMIT = 4950;
2836 
2837 
2838     // Counts the number of ponies the contract owner has created.
2839     uint256 public promoCreatedCount;
2840     uint256 public gen0CreatedCount;
2841 
2842     /// @dev we can create promo ponies, up to a limit. Only callable by COO
2843     /// @param _genes the encoded genes of the pony to be created, any value is accepted
2844     /// @param _owner the future owner of the created ponies. Default to contract COO
2845     function createPromoPony(uint256 _genes, address _owner) external onlyCOO {
2846         address ponyOwner = _owner;
2847         if (ponyOwner == address(0)) {
2848             ponyOwner = cooAddress;
2849         }
2850         require(promoCreatedCount < PROMO_CREATION_LIMIT);
2851 
2852         promoCreatedCount++;
2853         _createPony(0, 0, 0, _genes, ponyOwner, 0);
2854     }
2855 
2856     /// @dev Creates a new gen0 Pony with the given genes and
2857     ///  creates an auction for it.
2858     function createGen0(uint256 _genes, uint256 _price, uint16 _durationIndex, bool _saleDKL ) external onlyCOO {
2859         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
2860 
2861         uint256 ponyId = _createPony(0, 0, 0, _genes, ceoAddress, 0);
2862 
2863         _approve(ponyId, biddingAuction);
2864 
2865         if(_saleDKL) {
2866             biddingAuction.createDklAuction(ponyId, ceoAddress, _durationIndex, _price);
2867         } else {
2868             biddingAuction.createETHAuction(ponyId, ceoAddress, _durationIndex, _price);
2869         }
2870         gen0CreatedCount++;
2871     }
2872 
2873 }
2874 
2875 
2876 contract PonyUpgrade is PonyMinting {
2877     event PonyUpgraded(uint256 upgradedPony, uint256 tributePony, uint8 unicornation);
2878 
2879     function upgradePonyHashing(uint256 _upgradeId, uint256 _txCount) public pure returns (bytes32) {
2880         return keccak256(abi.encodePacked(bytes4(0x486A0E9D), _upgradeId, _txCount));
2881     }
2882 
2883     function upgradePony(uint256 _upgradeId, uint256 _tributeId, bytes _sig)
2884     external
2885     whenNotPaused
2886     {
2887         require(_owns(msg.sender, _upgradeId));
2888         require(_upgradeId != _tributeId);
2889 
2890         Pony storage upPony = ponies[_upgradeId];
2891 
2892         bytes32 hashedTx = upgradePonyHashing(_upgradeId, upPony.txCount);
2893         require(signedBySystem(hashedTx, _sig));
2894 
2895         upPony.txCount += 1;
2896         if (upPony.unicornation == 0) {
2897             if (geneScience.upgradePonyResult(upPony.unicornation, block.number)) {
2898                 upPony.unicornation += 1;
2899                 emit PonyUpgraded(_upgradeId, _tributeId, upPony.unicornation);
2900             }
2901         }
2902         else if (upPony.unicornation > 0) {
2903             require(_owns(msg.sender, _tributeId));
2904 
2905             if (geneScience.upgradePonyResult(upPony.unicornation, block.number)) {
2906                 upPony.unicornation += 1;
2907                 _transfer(msg.sender, address(0), _tributeId);
2908                 emit PonyUpgraded(_upgradeId, _tributeId, upPony.unicornation);
2909             } else if (upPony.unicornation == 2) {
2910                 upPony.unicornation += 1;
2911                 _transfer(msg.sender, address(0), _tributeId);
2912                 emit PonyUpgraded(_upgradeId, _tributeId, upPony.unicornation);
2913             }
2914         }
2915     }
2916 }
2917 
2918 /// @title EtherPonies: Collectible, breedable, and oh-so-adorable ponies on the Ethereum blockchain.
2919 /// @author Dekla (https://www.dekla.io)
2920 /// @dev The main EtherPonies contract, keeps track of ponies so they don't wander around and get lost.
2921 contract PonyCore is PonyUpgrade {
2922 
2923     event WithdrawEthBalanceSuccessful(address sender, uint256 amount);
2924     event WithdrawDeklaBalanceSuccessful(address sender, uint256 amount);
2925 
2926     // This is the main MyEtherPonies contract. In order to keep our code seperated into logical sections,
2927     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
2928     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
2929     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
2930     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
2931     // Pony ownership. The genetic combination algorithm is kept seperate so we can open-source all of
2932     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
2933     // Don't worry, I'm sure someone will reverse engineer it soon enough!
2934     //
2935     // Secondly, we break the core contract into multiple files using inheritence, one for each major
2936     // facet of functionality of CK. This allows us to keep related code bundled together while still
2937     // avoiding a single giant file with everything in it. The breakdown is as follows:
2938     //
2939     //      - PonyBase: This is where we define the most fundamental code shared throughout the core
2940     //             functionality. This includes our main data storage, constants and data types, plus
2941     //             internal functions for managing these items.
2942     //
2943     //      - PonyAccessControl: This contract manages the various addresses and constraints for operations
2944     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
2945     //
2946     //      - PonyOwnership: This provides the methods required for basic non-fungible token
2947     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
2948     //
2949     //      - PonyBreeding: This file contains the methods necessary to breed ponies together, including
2950     //             keeping track of siring offers, and relies on an external genetic combination contract.
2951     //
2952     //      - PonyAuctions: Here we have the public methods for auctioning or bidding on ponies or siring
2953     //             services. The actual auction functionality is handled in two sibling contracts (one
2954     //             for sales and one for siring), while auction creation and bidding is mostly mediated
2955     //             through this facet of the core contract.
2956     //
2957     //      - PonyMinting: This final facet contains the functionality we use for creating new gen0 ponies.
2958     //             We can make up to 5000 "promo" ponies that can be given away (especially important when
2959     //             the community is new), and all others can only be created and then immediately put up
2960     //             for auction via an algorithmically determined starting price. Regardless of how they
2961     //             are created, there is a hard limit of 50k gen0 ponies. After that, it's all up to the
2962     //             community to breed, breed, breed!
2963 
2964     // Set in case the core contract is broken and an upgrade is required
2965     address public newContractAddress;
2966 
2967     // ERC20 basic token contract being held
2968     ERC20 public token;
2969 
2970     /// @notice Creates the main EtherPonies smart contract instance.
2971     constructor(
2972         address _ceoAddress,
2973         address _cfoAddress,
2974         address _cooAddress,
2975         address _systemAddress,
2976         address _tokenAddress
2977     ) public {
2978         // validate address
2979         require(_ceoAddress != address(0));
2980         require(_cooAddress != address(0));
2981         require(_cfoAddress != address(0));
2982         require(_systemAddress != address(0));
2983         require(_tokenAddress != address(0));
2984 
2985         // Starts paused.
2986         paused = true;
2987 
2988         // the creator of the contract is the initial CEO
2989         ceoAddress = _ceoAddress;
2990         cfoAddress = _cfoAddress;
2991         cooAddress = _cooAddress;
2992         systemAddress = _systemAddress;
2993         token = ERC20(_tokenAddress);
2994 
2995         // start with the mythical pony 0 - so we don't have generation-0 parent issues
2996         _createPony(0, 0, 0, uint256(- 1), address(0), 0);
2997     }
2998 
2999     //check that the token is set
3000     modifier validToken() {
3001         require(token != address(0));
3002         _;
3003     }
3004 
3005     function getTokenAddressHashing(address _token, uint256 _nonce) public pure returns (bytes32) {
3006         return keccak256(abi.encodePacked(bytes4(0x486A1216), _token, _nonce));
3007     }
3008 
3009     function setTokenAddress(address _token, bytes _sig) external onlyCLevel {
3010         bytes32 hashedTx = getTokenAddressHashing(_token, nonces[msg.sender]);
3011         require(signedByCLevel(hashedTx, _sig));
3012         nonces[msg.sender]++;
3013 
3014         token = ERC20(_token);
3015     }
3016 
3017     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
3018     ///  breaking bug. This method does nothing but keep track of the new contract and
3019     ///  emit a message indicating that the new address is set. It's up to clients of this
3020     ///  contract to update to the new contract address in that case. (This contract will
3021     ///  be paused indefinitely if such an upgrade takes place.)
3022     /// @param _v2Address new address
3023     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
3024         // See README.md for updgrade plan
3025         newContractAddress = _v2Address;
3026         emit ContractUpgrade(_v2Address);
3027     }
3028 
3029     /// @notice No tipping!
3030     /// @dev Reject all Ether from being sent here, unless it's from one of the
3031     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
3032     function() external payable {
3033     }
3034 
3035     /// @notice Returns all the relevant information about a specific Pony.
3036     /// @param _id The ID of the Pony of interest.
3037     function getPony(uint256 _id)
3038     external
3039     view
3040     returns (
3041         bool isGestating,
3042         bool isReady,
3043         uint256 cooldownIndex,
3044         uint256 nextActionAt,
3045         uint256 siringWithId,
3046         uint256 birthTime,
3047         uint256 matronId,
3048         uint256 sireId,
3049         uint256 generation,
3050         uint256 genes,
3051         uint16 upgradeIndex,
3052         uint8 unicornation
3053     ) {
3054         Pony storage pon = ponies[_id];
3055 
3056         // if this variable is 0 then it's not gestating
3057         isGestating = (pon.matingWithId != 0);
3058         isReady = (pon.cooldownEndBlock <= block.number);
3059         cooldownIndex = uint256(pon.cooldownIndex);
3060         nextActionAt = uint256(pon.cooldownEndBlock);
3061         siringWithId = uint256(pon.matingWithId);
3062         birthTime = uint256(pon.birthTime);
3063         matronId = uint256(pon.matronId);
3064         sireId = uint256(pon.sireId);
3065         generation = uint256(pon.generation);
3066         genes = pon.genes;
3067         upgradeIndex = pon.txCount;
3068         unicornation = pon.unicornation;
3069     }
3070 
3071     /// @dev Override unpause so it requires all external contract addresses
3072     ///  to be set before contract can be unpaused. Also, we can't have
3073     ///  newContractAddress set either, because then the contract was upgraded.
3074     /// @notice This is public rather than external so we can call super.unpause
3075     ///  without using an expensive CALL.
3076     function unpause() public onlyCEO whenPaused {
3077         require(geneScience != address(0));
3078         require(newContractAddress == address(0));
3079 
3080         // Actually unpause the contract.
3081         super.unpause();
3082     }
3083 
3084     function withdrawBalanceHashing(address _address, uint256 _nonce) public pure returns (bytes32) {
3085         return keccak256(abi.encodePacked(bytes4(0x486A1217), _address, _nonce));
3086     }
3087 
3088     function withdrawEthBalance(address _withdrawWallet, bytes _sig) external onlyCLevel {
3089         bytes32 hashedTx = withdrawBalanceHashing(_withdrawWallet, nonces[msg.sender]);
3090         require(signedByCLevel(hashedTx, _sig));
3091 
3092         uint256 balance = address(this).balance;
3093 
3094         // Subtract all the currently pregnant ponies we have, plus 1 of margin.
3095         uint256 subtractFees = (pregnantPonies + 1) * autoBirthFee;
3096         require(balance > 0);
3097         require(balance > subtractFees);
3098 
3099         nonces[msg.sender]++;
3100         _withdrawWallet.transfer(balance - subtractFees);
3101         emit WithdrawEthBalanceSuccessful(_withdrawWallet, balance - subtractFees);
3102     }
3103 
3104 
3105     function withdrawDeklaBalance(address _withdrawWallet, bytes _sig) external validToken onlyCLevel {
3106         bytes32 hashedTx = withdrawBalanceHashing(_withdrawWallet, nonces[msg.sender]);
3107         require(signedByCLevel(hashedTx, _sig));
3108 
3109         uint256 balance = token.balanceOf(this);
3110         require(balance > 0);
3111 
3112         nonces[msg.sender]++;
3113         token.transfer(_withdrawWallet, balance);
3114         emit WithdrawDeklaBalanceSuccessful(_withdrawWallet, balance);
3115     }
3116 }