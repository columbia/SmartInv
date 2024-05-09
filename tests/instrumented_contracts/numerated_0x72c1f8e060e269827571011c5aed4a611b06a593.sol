1 contract Certifier {
2 	event Confirmed(address indexed who);
3 	event Revoked(address indexed who);
4 	function certified(address _who) view public returns (bool);
5 }
6 
7 /// @title Contract that supports the receival of ERC223 tokens.
8 contract ERC223ReceivingContract {
9 
10     /// @dev Standard ERC223 function that will handle incoming token transfers.
11     /// @param _from  Token sender address.
12     /// @param _value Amount of tokens.
13     /// @param _data  Transaction metadata.
14     function tokenFallback(address _from, uint _value, bytes _data) public;
15 
16 }
17 
18 
19 contract SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 contract ERC20Basic {
62   function totalSupply() public view returns (uint256);
63   function balanceOf(address who) public view returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 
69 contract ERC223Basic is ERC20Basic {
70 
71     /**
72       * @dev Transfer the specified amount of tokens to the specified address.
73       *      Now with a new parameter _data.
74       *
75       * @param _to    Receiver address.
76       * @param _value Amount of tokens that will be transferred.
77       * @param _data  Transaction metadata.
78       */
79     function transfer(address _to, uint _value, bytes _data) public returns (bool);
80 
81     /**
82       * @dev triggered when transfer is successfully called.
83       *
84       * @param _from  Sender address.
85       * @param _to    Receiver address.
86       * @param _value Amount of tokens that will be transferred.
87       * @param _data  Transaction metadata.
88       */
89     event Transfer(address indexed _from, address indexed _to, uint256 indexed _value, bytes _data);
90 }
91 
92 contract DetherAccessControl {
93     // This facet controls access control for Dether. There are four roles managed here:
94     //
95     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
96     //         contracts. It is also the only role that can unpause the smart contract.
97     //
98     //     - The CMO: The CMO is in charge to open or close activity in zone
99     //
100     // It should be noted that these roles are distinct without overlap in their access abilities, the
101     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
102     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
103     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
104     // convenience. The less we use an address, the less likely it is that we somehow compromise the
105     // account.
106 
107     /// @dev Emited when contract is upgraded
108     event ContractUpgrade(address newContract);
109 
110     // The addresses of the accounts (or contracts) that can execute actions within each roles.
111     address public ceoAddress;
112     address public cmoAddress;
113     address public csoAddress; // CHIEF SHOP OFFICER
114     address public cfoAddress; // CHIEF FINANCIAL OFFICER
115 	  mapping (address => bool) public shopModerators;   // centralised moderator, would become decentralised
116     mapping (address => bool) public tellerModerators;   // centralised moderator, would become decentralised
117 
118     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
119     bool public paused = false;
120 
121     /// @dev Access modifier for CEO-only functionality
122     modifier onlyCEO() {
123         require(msg.sender == ceoAddress);
124         _;
125     }
126 
127     /// @dev Access modifier for CMO-only functionality
128     modifier onlyCMO() {
129         require(msg.sender == cmoAddress);
130         _;
131     }
132 
133     modifier onlyCSO() {
134         require(msg.sender == csoAddress);
135         _;
136     }
137 
138     modifier onlyCFO() {
139         require(msg.sender == cfoAddress);
140         _;
141     }
142 
143     modifier isShopModerator(address _user) {
144       require(shopModerators[_user]);
145       _;
146     }
147     modifier isTellerModerator(address _user) {
148       require(tellerModerators[_user]);
149       _;
150     }
151 
152     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
153     /// @param _newCEO The address of the new CEO
154     function setCEO(address _newCEO) external onlyCEO {
155         require(_newCEO != address(0));
156         ceoAddress = _newCEO;
157     }
158 
159     /// @dev Assigns a new address to act as the CMO. Only available to the current CEO.
160     /// @param _newCMO The address of the new CMO
161     function setCMO(address _newCMO) external onlyCEO {
162         require(_newCMO != address(0));
163         cmoAddress = _newCMO;
164     }
165 
166     function setCSO(address _newCSO) external onlyCEO {
167         require(_newCSO != address(0));
168         csoAddress = _newCSO;
169     }
170 
171     function setCFO(address _newCFO) external onlyCEO {
172         require(_newCFO != address(0));
173         cfoAddress = _newCFO;
174     }
175 
176     function setShopModerator(address _moderator) external onlyCEO {
177       require(_moderator != address(0));
178       shopModerators[_moderator] = true;
179     }
180 
181     function removeShopModerator(address _moderator) external onlyCEO {
182       shopModerators[_moderator] = false;
183     }
184 
185     function setTellerModerator(address _moderator) external onlyCEO {
186       require(_moderator != address(0));
187       tellerModerators[_moderator] = true;
188     }
189 
190     function removeTellerModerator(address _moderator) external onlyCEO {
191       tellerModerators[_moderator] = false;
192     }
193     /*** Pausable functionality adapted from OpenZeppelin ***/
194 
195     /// @dev Modifier to allow actions only when the contract IS NOT paused
196     modifier whenNotPaused() {
197         require(!paused);
198         _;
199     }
200 
201     /// @dev Modifier to allow actions only when the contract IS paused
202     modifier whenPaused {
203         require(paused);
204         _;
205     }
206 
207     /// @dev Called by any "C-level" role to pause the contract. Used only when
208     ///  a bug or exploit is detected and we need to limit damage.
209     function pause() external onlyCEO whenNotPaused {
210         paused = true;
211     }
212 
213     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
214     ///  one reason we may pause the contract is when CMO account are
215     ///  compromised.
216     /// @notice This is public rather than external so it can be called by
217     ///  derived contracts.
218     function unpause() public onlyCEO whenPaused {
219         // can't unpause if contract was upgraded
220         paused = false;
221     }
222 }
223 
224 
225 contract DetherSetup is DetherAccessControl  {
226 
227   bool public run1 = false;
228   bool public run2 = false;
229   // -Need to be whitelisted to be able to register in the contract as a shop or
230   // teller, there is two level of identification.
231   // -This identification method are now centralised and processed by dether, but
232   // will be decentralised soon
233   Certifier public smsCertifier;
234   Certifier public kycCertifier;
235   // Zone need to be open by the CMO before accepting registration
236   // The bytes2 parameter wait for a country ID (ex: FR (0x4652 in hex) for france cf:README)
237   mapping(bytes2 => bool) public openedCountryShop;
238   mapping(bytes2 => bool) public openedCountryTeller;
239   // For registering in a zone you need to stake DTH
240   // The price can differ by country
241   // Uts now a fixed price by the CMO but the price will adjusted automatically
242   // regarding different factor in the futur smart contract
243   mapping(bytes2 => uint) public licenceShop;
244   mapping(bytes2 => uint) public licenceTeller;
245 
246   modifier tier1(address _user) {
247     require(smsCertifier.certified(_user));
248     _;
249   }
250   modifier tier2(address _user) {
251     require(kycCertifier.certified(_user));
252     _;
253   }
254   modifier isZoneShopOpen(bytes2 _country) {
255     require(openedCountryShop[_country]);
256     _;
257   }
258   modifier isZoneTellerOpen(bytes2 _country) {
259     require(openedCountryTeller[_country]);
260     _;
261   }
262 
263   function isTier1(address _user) public view returns(bool) {
264     return smsCertifier.certified(_user);
265   }
266   function isTier2(address _user) public view returns(bool) {
267     return kycCertifier.certified(_user);
268   }
269 
270   /**
271    * INIT
272    */
273   function setSmsCertifier (address _smsCertifier) external onlyCEO {
274     require(!run1);
275     smsCertifier = Certifier(_smsCertifier);
276     run1 = true;
277   }
278   /**
279    * CORE FUNCTION
280    */
281   function setKycCertifier (address _kycCertifier) external onlyCEO {
282     require(!run2);
283     kycCertifier = Certifier(_kycCertifier);
284     run2 = true;
285   }
286   function setLicenceShopPrice(bytes2 country, uint price) external onlyCMO {
287     licenceShop[country] = price;
288   }
289   function setLicenceTellerPrice(bytes2 country, uint price) external onlyCMO {
290     licenceTeller[country] = price;
291   }
292   function openZoneShop(bytes2 _country) external onlyCMO {
293     openedCountryShop[_country] = true;
294   }
295   function closeZoneShop(bytes2 _country) external onlyCMO {
296     openedCountryShop[_country] = false;
297   }
298   function openZoneTeller(bytes2 _country) external onlyCMO {
299     openedCountryTeller[_country] = true;
300   }
301   function closeZoneTeller(bytes2 _country) external onlyCMO {
302     openedCountryTeller[_country] = false;
303   }
304 }
305 
306 library BytesLib {
307     function concat(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bytes) {
308         bytes memory tempBytes;
309 
310         assembly {
311             // Get a location of some free memory and store it in tempBytes as
312             // Solidity does for memory variables.
313             tempBytes := mload(0x40)
314 
315             // Store the length of the first bytes array at the beginning of
316             // the memory for tempBytes.
317             let length := mload(_preBytes)
318             mstore(tempBytes, length)
319 
320             // Maintain a memory counter for the current write location in the
321             // temp bytes array by adding the 32 bytes for the array length to
322             // the starting location.
323             let mc := add(tempBytes, 0x20)
324             // Stop copying when the memory counter reaches the length of the
325             // first bytes array.
326             let end := add(mc, length)
327 
328             for {
329                 // Initialize a copy counter to the start of the _preBytes data,
330                 // 32 bytes into its memory.
331                 let cc := add(_preBytes, 0x20)
332             } lt(mc, end) {
333                 // Increase both counters by 32 bytes each iteration.
334                 mc := add(mc, 0x20)
335                 cc := add(cc, 0x20)
336             } {
337                 // Write the _preBytes data into the tempBytes memory 32 bytes
338                 // at a time.
339                 mstore(mc, mload(cc))
340             }
341 
342             // Add the length of _postBytes to the current length of tempBytes
343             // and store it as the new length in the first 32 bytes of the
344             // tempBytes memory.
345             length := mload(_postBytes)
346             mstore(tempBytes, add(length, mload(tempBytes)))
347 
348             // Move the memory counter back from a multiple of 0x20 to the
349             // actual end of the _preBytes data.
350             mc := end
351             // Stop copying when the memory counter reaches the new combined
352             // length of the arrays.
353             end := add(mc, length)
354 
355             for {
356                 let cc := add(_postBytes, 0x20)
357             } lt(mc, end) {
358                 mc := add(mc, 0x20)
359                 cc := add(cc, 0x20)
360             } {
361                 mstore(mc, mload(cc))
362             }
363 
364             // Update the free-memory pointer by padding our last write location
365             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
366             // next 32 byte block, then round down to the nearest multiple of
367             // 32. If the sum of the length of the two arrays is zero then add
368             // one before rounding down to leave a blank 32 bytes (the length block with 0).
369             mstore(0x40, and(
370               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
371               not(31) // Round down to the nearest 32 bytes.
372             ))
373         }
374 
375         return tempBytes;
376     }
377 
378     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
379         assembly {
380             // Read the first 32 bytes of _preBytes storage, which is the length
381             // of the array. (We don't need to use the offset into the slot
382             // because arrays use the entire slot.)
383             let fslot := sload(_preBytes_slot)
384             // Arrays of 31 bytes or less have an even value in their slot,
385             // while longer arrays have an odd value. The actual length is
386             // the slot divided by two for odd values, and the lowest order
387             // byte divided by two for even values.
388             // If the slot is even, bitwise and the slot with 255 and divide by
389             // two to get the length. If the slot is odd, bitwise and the slot
390             // with -1 and divide by two.
391             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
392             let mlength := mload(_postBytes)
393             let newlength := add(slength, mlength)
394             // slength can contain both the length and contents of the array
395             // if length < 32 bytes so let's prepare for that
396             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
397             switch add(lt(slength, 32), lt(newlength, 32))
398             case 2 {
399                 // Since the new array still fits in the slot, we just need to
400                 // update the contents of the slot.
401                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
402                 sstore(
403                     _preBytes_slot,
404                     // all the modifications to the slot are inside this
405                     // next block
406                     add(
407                         // we can just add to the slot contents because the
408                         // bytes we want to change are the LSBs
409                         fslot,
410                         add(
411                             mul(
412                                 div(
413                                     // load the bytes from memory
414                                     mload(add(_postBytes, 0x20)),
415                                     // zero all bytes to the right
416                                     exp(0x100, sub(32, mlength))
417                                 ),
418                                 // and now shift left the number of bytes to
419                                 // leave space for the length in the slot
420                                 exp(0x100, sub(32, newlength))
421                             ),
422                             // increase length by the double of the memory
423                             // bytes length
424                             mul(mlength, 2)
425                         )
426                     )
427                 )
428             }
429             case 1 {
430                 // The stored value fits in the slot, but the combined value
431                 // will exceed it.
432                 // get the keccak hash to get the contents of the array
433                 mstore(0x0, _preBytes_slot)
434                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
435 
436                 // save new length
437                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
438 
439                 // The contents of the _postBytes array start 32 bytes into
440                 // the structure. Our first read should obtain the `submod`
441                 // bytes that can fit into the unused space in the last word
442                 // of the stored array. To get this, we read 32 bytes starting
443                 // from `submod`, so the data we read overlaps with the array
444                 // contents by `submod` bytes. Masking the lowest-order
445                 // `submod` bytes allows us to add that value directly to the
446                 // stored value.
447 
448                 let submod := sub(32, slength)
449                 let mc := add(_postBytes, submod)
450                 let end := add(_postBytes, mlength)
451                 let mask := sub(exp(0x100, submod), 1)
452 
453                 sstore(
454                     sc,
455                     add(
456                         and(
457                             fslot,
458                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
459                         ),
460                         and(mload(mc), mask)
461                     )
462                 )
463 
464                 for {
465                     mc := add(mc, 0x20)
466                     sc := add(sc, 1)
467                 } lt(mc, end) {
468                     sc := add(sc, 1)
469                     mc := add(mc, 0x20)
470                 } {
471                     sstore(sc, mload(mc))
472                 }
473 
474                 mask := exp(0x100, sub(mc, end))
475 
476                 sstore(sc, mul(div(mload(mc), mask), mask))
477             }
478             default {
479                 // get the keccak hash to get the contents of the array
480                 mstore(0x0, _preBytes_slot)
481                 // Start copying to the last used word of the stored array.
482                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
483 
484                 // save new length
485                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
486 
487                 // Copy over the first `submod` bytes of the new data as in
488                 // case 1 above.
489                 let slengthmod := mod(slength, 32)
490                 let mlengthmod := mod(mlength, 32)
491                 let submod := sub(32, slengthmod)
492                 let mc := add(_postBytes, submod)
493                 let end := add(_postBytes, mlength)
494                 let mask := sub(exp(0x100, submod), 1)
495 
496                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
497 
498                 for {
499                     sc := add(sc, 1)
500                     mc := add(mc, 0x20)
501                 } lt(mc, end) {
502                     sc := add(sc, 1)
503                     mc := add(mc, 0x20)
504                 } {
505                     sstore(sc, mload(mc))
506                 }
507 
508                 mask := exp(0x100, sub(mc, end))
509 
510                 sstore(sc, mul(div(mload(mc), mask), mask))
511             }
512         }
513     }
514 
515     function slice(bytes _bytes, uint _start, uint _length) internal  pure returns (bytes) {
516         require(_bytes.length >= (_start + _length));
517 
518         bytes memory tempBytes;
519 
520         assembly {
521             switch iszero(_length)
522             case 0 {
523                 // Get a location of some free memory and store it in tempBytes as
524                 // Solidity does for memory variables.
525                 tempBytes := mload(0x40)
526 
527                 // The first word of the slice result is potentially a partial
528                 // word read from the original array. To read it, we calculate
529                 // the length of that partial word and start copying that many
530                 // bytes into the array. The first word we copy will start with
531                 // data we don't care about, but the last `lengthmod` bytes will
532                 // land at the beginning of the contents of the new array. When
533                 // we're done copying, we overwrite the full first word with
534                 // the actual length of the slice.
535                 let lengthmod := and(_length, 31)
536 
537                 // The multiplication in the next line is necessary
538                 // because when slicing multiples of 32 bytes (lengthmod == 0)
539                 // the following copy loop was copying the origin's length
540                 // and then ending prematurely not copying everything it should.
541                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
542                 let end := add(mc, _length)
543 
544                 for {
545                     // The multiplication in the next line has the same exact purpose
546                     // as the one above.
547                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
548                 } lt(mc, end) {
549                     mc := add(mc, 0x20)
550                     cc := add(cc, 0x20)
551                 } {
552                     mstore(mc, mload(cc))
553                 }
554 
555                 mstore(tempBytes, _length)
556 
557                 //update free-memory pointer
558                 //allocating the array padded to 32 bytes like the compiler does now
559                 mstore(0x40, and(add(mc, 31), not(31)))
560             }
561             //if we want a zero-length slice let's just return a zero-length array
562             default {
563                 tempBytes := mload(0x40)
564 
565                 mstore(0x40, add(tempBytes, 0x20))
566             }
567         }
568 
569         return tempBytes;
570     }
571 
572     function toAddress(bytes _bytes, uint _start) internal  pure returns (address) {
573         require(_bytes.length >= (_start + 20));
574         address tempAddress;
575 
576         assembly {
577             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
578         }
579 
580         return tempAddress;
581     }
582 
583     function toUint(bytes _bytes, uint _start) internal  pure returns (uint256) {
584         require(_bytes.length >= (_start + 32));
585         uint256 tempUint;
586 
587         assembly {
588             tempUint := mload(add(add(_bytes, 0x20), _start))
589         }
590 
591         return tempUint;
592     }
593 
594     function toBytes32(bytes _bytes, uint _start) internal  pure returns (bytes32) {
595         require(_bytes.length >= (_start + 32));
596         bytes32 tempBytes32;
597 
598         assembly {
599             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
600         }
601 
602         return tempBytes32;
603     }
604 
605     function toBytes16(bytes _bytes, uint _start) internal  pure returns (bytes16) {
606         require(_bytes.length >= (_start + 16));
607         bytes16 tempBytes16;
608 
609         assembly {
610             tempBytes16 := mload(add(add(_bytes, 0x20), _start))
611         }
612 
613         return tempBytes16;
614     }
615 
616     function toBytes2(bytes _bytes, uint _start) internal  pure returns (bytes2) {
617         require(_bytes.length >= (_start + 2));
618         bytes2 tempBytes2;
619 
620         assembly {
621             tempBytes2 := mload(add(add(_bytes, 0x20), _start))
622         }
623 
624         return tempBytes2;
625     }
626 
627     function toBytes4(bytes _bytes, uint _start) internal  pure returns (bytes4) {
628         require(_bytes.length >= (_start + 4));
629         bytes4 tempBytes4;
630 
631         assembly {
632             tempBytes4 := mload(add(add(_bytes, 0x20), _start))
633         }
634         return tempBytes4;
635     }
636 
637     function toBytes1(bytes _bytes, uint _start) internal  pure returns (bytes1) {
638         require(_bytes.length >= (_start + 1));
639         bytes1 tempBytes1;
640 
641         assembly {
642             tempBytes1 := mload(add(add(_bytes, 0x20), _start))
643         }
644 
645         return tempBytes1;
646     }
647 
648     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
649         bool success = true;
650 
651         assembly {
652             let length := mload(_preBytes)
653 
654             // if lengths don't match the arrays are not equal
655             switch eq(length, mload(_postBytes))
656             case 1 {
657                 // cb is a circuit breaker in the for loop since there's
658                 //  no said feature for inline assembly loops
659                 // cb = 1 - don't breaker
660                 // cb = 0 - break
661                 let cb := 1
662 
663                 let mc := add(_preBytes, 0x20)
664                 let end := add(mc, length)
665 
666                 for {
667                     let cc := add(_postBytes, 0x20)
668                 // the next line is the loop condition:
669                 // while(uint(mc < end) + cb == 2)
670                 } eq(add(lt(mc, end), cb), 2) {
671                     mc := add(mc, 0x20)
672                     cc := add(cc, 0x20)
673                 } {
674                     // if any of these checks fails then arrays are not equal
675                     if iszero(eq(mload(mc), mload(cc))) {
676                         // unsuccess:
677                         success := 0
678                         cb := 0
679                     }
680                 }
681             }
682             default {
683                 // unsuccess:
684                 success := 0
685             }
686         }
687 
688         return success;
689     }
690 
691     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
692         bool success = true;
693 
694         assembly {
695             // we know _preBytes_offset is 0
696             let fslot := sload(_preBytes_slot)
697             // Decode the length of the stored array like in concatStorage().
698             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
699             let mlength := mload(_postBytes)
700 
701             // if lengths don't match the arrays are not equal
702             switch eq(slength, mlength)
703             case 1 {
704                 // slength can contain both the length and contents of the array
705                 // if length < 32 bytes so let's prepare for that
706                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
707                 if iszero(iszero(slength)) {
708                     switch lt(slength, 32)
709                     case 1 {
710                         // blank the last byte which is the length
711                         fslot := mul(div(fslot, 0x100), 0x100)
712 
713                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
714                             // unsuccess:
715                             success := 0
716                         }
717                     }
718                     default {
719                         // cb is a circuit breaker in the for loop since there's
720                         //  no said feature for inline assembly loops
721                         // cb = 1 - don't breaker
722                         // cb = 0 - break
723                         let cb := 1
724 
725                         // get the keccak hash to get the contents of the array
726                         mstore(0x0, _preBytes_slot)
727                         let sc := keccak256(0x0, 0x20)
728 
729                         let mc := add(_postBytes, 0x20)
730                         let end := add(mc, mlength)
731 
732                         // the next line is the loop condition:
733                         // while(uint(mc < end) + cb == 2)
734                         for {} eq(add(lt(mc, end), cb), 2) {
735                             sc := add(sc, 1)
736                             mc := add(mc, 0x20)
737                         } {
738                             if iszero(eq(sload(sc), mload(mc))) {
739                                 // unsuccess:
740                                 success := 0
741                                 cb := 0
742                             }
743                         }
744                     }
745                 }
746             }
747             default {
748                 // unsuccess:
749                 success := 0
750             }
751         }
752 
753         return success;
754     }
755 }
756 contract ExchangeRateOracle {
757   function getWeiPriceOneUsd() external view returns(uint256);
758 }
759 
760 // only interface to save gas
761 contract DetherBank {
762   function withdrawDthTeller(address _receiver) external;
763   function withdrawDthShop(address _receiver) external;
764   function withdrawDthShopAdmin(address _from, address _receiver) external;
765   function addTokenShop(address _from, uint _value) external;
766   function addTokenTeller(address _from, uint _value) external;
767   function addEthTeller(address _from, uint _value) external payable returns (bool);
768   function withdrawEth(address _from, address _to, uint _amount) external;
769   function refundEth(address _from) external;
770   function getDthTeller(address _user) public view returns (uint);
771   function getDthShop(address _user) public view returns (uint);
772   function getEthBalTeller(address _user) public view returns (uint);
773   function getWeiSoldToday(address _user) public view returns (uint256 weiSoldToday);
774   function transferOwnership(address newOwner) public;
775 }
776 
777 contract DetherCore is DetherSetup, ERC223ReceivingContract, SafeMath {
778   using BytesLib for bytes;
779 
780   /**
781   * Event
782   */
783   // when a Teller is registered
784   event RegisterTeller(address indexed tellerAddress);
785   // when a teller is deleted
786   event DeleteTeller(address indexed tellerAddress);
787   // when teller update
788   event UpdateTeller(address indexed tellerAddress);
789   // when a teller send to a buyer
790   event Sent(address indexed _from, address indexed _to, uint amount);
791   // when a shop register
792   event RegisterShop(address shopAddress);
793   // when a shop delete
794   event DeleteShop(address shopAddress);
795   // when a moderator delete a shop
796   event DeleteShopModerator(address indexed moderator, address shopAddress);
797   // when a moderator delete a teller
798   event DeleteTellerModerator(address indexed moderator, address tellerAddress);
799 
800   /**
801    * Modifier
802    */
803   // if teller has staked enough dth to
804   modifier tellerHasStaked(uint amount) {
805     require(bank.getDthTeller(msg.sender) >= amount);
806     _;
807   }
808   // if shop has staked enough dth to
809   modifier shopHasStaked(uint amount) {
810     require(bank.getDthShop(msg.sender) >= amount);
811     _;
812   }
813 
814   /*
815    * External contract
816    */
817   // DTH contract
818   ERC223Basic public dth;
819   // bank contract where are stored ETH and DTH
820   DetherBank public bank;
821 
822   ExchangeRateOracle public priceOracle;
823 
824   // teller struct
825   struct Teller {
826     int32 lat;            // Latitude
827     int32 lng;            // Longitude
828     bytes2 countryId;     // countryID (in hexa), ISO ALPHA 2 https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
829     bytes16 postalCode;   // postalCode if present, in Hexa https://en.wikipedia.org/wiki/List_of_postal_codes
830 
831     int8 currencyId;      // 1 - 100 , cf README
832     bytes16 messenger;    // telegrame nickname
833     int8 avatarId;        // 1 - 100 , regarding the front-end app you use
834     int16 rates;          // margin of tellers , -999 - +9999 , corresponding to -99,9% x 10  , 999,9% x 10
835     bool buyer;           // appear as a buyer as well on the map
836     int16 buyRates;         // margin of tellers of
837 
838     uint zoneIndex;       // index of the zone mapping
839     uint generalIndex;    // index of general mapping
840     bool online;          // switch online/offline, if the tellers want to be inactive without deleting his point
841   }
842 
843   mapping(address => mapping(address => uint)) internal pairSellsLoyaltyPerc;
844   //      from               to         percentage of loyalty points from gets
845 
846   /*
847    * Reputation field V0.1
848    * Reputation is based on volume sell, volume buy, and number of transaction
849    */
850   mapping(address => uint) volumeBuy;
851   mapping(address => uint) volumeSell;
852   mapping(address => uint) nbTrade;
853   mapping(address => uint256) loyaltyPoints;
854 
855   // general mapping of teller
856   mapping(address => Teller) teller;
857   // mappoing of teller by COUNTRYCODE => POSTALCODE
858   mapping(bytes2 => mapping(bytes16 => address[])) tellerInZone;
859   // teller array currently registered
860   address[] public tellerIndex; // unordered list of teller register on it
861   bool isStarted = false;
862   // shop struct
863   struct Shop {
864     int32 lat;            // latitude
865     int32 lng;            // longitude
866     bytes2 countryId;     // countryID (in hexa char), ISO ALPHA 2 https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
867     bytes16 postalCode;   // postalCode if present (in hexa char), in Hexa https://en.wikipedia.org/wiki/List_of_postal_codes
868     bytes16 cat;          // Category of the shop (in hex char), will be used later for search engine and auction by zone
869     bytes16 name;         // name of the shop (in hex char)
870     bytes32 description;  // description of the shop
871     bytes16 opening;      // opening hours, cf README for the format
872 
873     uint zoneIndex;       // index of the zone mapping
874     uint generalIndex;    // index of general mapping
875     bool detherShop;      // bool if shop is registered by dether as business partnership (still required DTH)
876   }
877 
878   // general mapping of shop
879   mapping(address => Shop) shop;
880   // mapping of teller by COUNTRYCODE => POSTALCODE
881   mapping(bytes2 => mapping(bytes16 => address[])) shopInZone;
882   // shop array currently registered
883   address[] public shopIndex; // unordered list of shop register on it
884 
885   /*
886    * Instanciation
887    */
888   function DetherCore() {
889    ceoAddress = msg.sender;
890   }
891   function initContract (address _dth, address _bank) external onlyCEO {
892     require(!isStarted);
893     dth = ERC223Basic(_dth);
894     bank = DetherBank(_bank);
895     isStarted = true;
896   }
897 
898   function setPriceOracle (address _priceOracle) external onlyCFO {
899     priceOracle = ExchangeRateOracle(_priceOracle);
900   }
901 
902   /**
903    * Core fonction
904    */
905 
906   /**
907    * @dev Standard ERC223 function that will handle incoming token transfers.
908    * This is the main function to register SHOP or TELLER, its calling when you
909    * send token to the DTH contract and by passing data as bytes on the third
910    * parameter.
911    * Its not supposed to be use on its own but will only handle incoming DTH
912    * transaction.
913    * The _data will wait for
914    * [1st byte] 1 (0x31) for shop OR 2 (0x32) for teller
915    * FOR SHOP AND TELLER:
916    * 2sd to 5th bytes lat
917    * 6th to 9th bytes lng
918    * ...
919    * Modifier tier1: Check if address is whitelisted with the sms verification
920    */
921   function tokenFallback(address _from, uint _value, bytes _data) whenNotPaused tier1(_from ) {
922     // require than the token fallback is triggered from the dth token contract
923     require(msg.sender == address(dth));
924     // check first byte to know if its shop or teller registration
925     // 1 / 0x31 = shop // 2 / 0x32 = teller
926     bytes1 _func = _data.toBytes1(0);
927     int32 posLat = _data.toBytes1(1) == bytes1(0x01) ? int32(_data.toBytes4(2)) * -1 : int32(_data.toBytes4(2));
928     int32 posLng = _data.toBytes1(6) == bytes1(0x01) ? int32(_data.toBytes4(7)) * -1 : int32(_data.toBytes4(7));
929     if (_func == bytes1(0x31)) { // shop registration // GAS USED 311000
930       // require staked greater than licence price
931       require(_value >= licenceShop[_data.toBytes2(11)]);
932       // require its not already shop
933       require(!isShop(_from));
934       // require zone is open
935       require(openedCountryShop[_data.toBytes2(11)]);
936 
937       shop[_from].lat = posLat;
938       shop[_from].lng = posLng;
939       shop[_from].countryId = _data.toBytes2(11);
940       shop[_from].postalCode = _data.toBytes16(13);
941       shop[_from].cat = _data.toBytes16(29);
942       shop[_from].name = _data.toBytes16(45);
943       shop[_from].description = _data.toBytes32(61);
944       shop[_from].opening = _data.toBytes16(93);
945       shop[_from].generalIndex = shopIndex.push(_from) - 1;
946       shop[_from].zoneIndex = shopInZone[_data.toBytes2(11)][_data.toBytes16(13)].push(_from) - 1;
947       emit RegisterShop(_from);
948       bank.addTokenShop(_from,_value);
949       dth.transfer(address(bank), _value);
950     } else if (_func == bytes1(0x32)) { // teller registration -- GAS USED 310099
951       // require staked greater than licence price
952       require(_value >= licenceTeller[_data.toBytes2(11)]);
953       // require is not already a teller
954       require(!isTeller(_from));
955       // require zone is open
956       require(openedCountryTeller[_data.toBytes2(11)]);
957 
958       teller[_from].lat = posLat;
959       teller[_from].lng = posLng;
960       teller[_from].countryId = _data.toBytes2(11);
961       teller[_from].postalCode = _data.toBytes16(13);
962       teller[_from].avatarId = int8(_data.toBytes1(29));
963       teller[_from].currencyId = int8(_data.toBytes1(30));
964       teller[_from].messenger = _data.toBytes16(31);
965       teller[_from].rates = int16(_data.toBytes2(47));
966       teller[_from].buyer = _data.toBytes1(49) == bytes1(0x01) ? true : false;
967       teller[_from].buyRates = int16(_data.toBytes2(50));
968       teller[_from].generalIndex = tellerIndex.push(_from) - 1;
969       teller[_from].zoneIndex = tellerInZone[_data.toBytes2(11)][_data.toBytes16(13)].push(_from) - 1;
970       teller[_from].online = true;
971       emit RegisterTeller(_from);
972       bank.addTokenTeller(_from, _value);
973       dth.transfer(address(bank), _value);
974     } else if (_func == bytes1(0x33)) {  // shop bulk registration
975       // We need to have the possibility to register in bulk some shop
976       // For big retailer company willing to be listed on dether, we need to have a way to add
977       // all their shop from one address
978       // This functionnality will become available for anyone willing to list multiple shop
979       // in the futures contract
980 
981       // Only the CSO should be able to register shop in bulk
982       require(_from == csoAddress);
983       // Each shop still need his own staking
984       require(_value >= licenceShop[_data.toBytes2(11)]);
985       // require the addresses not already registered
986       require(!isShop(address(_data.toAddress(109))));
987       // require zone is open
988       require(openedCountryShop[_data.toBytes2(11)]);
989       address newShopAddress = _data.toAddress(109);
990       shop[newShopAddress].lat = posLat;
991       shop[newShopAddress].lng = posLng;
992       shop[newShopAddress].countryId = _data.toBytes2(11);
993       shop[newShopAddress].postalCode = _data.toBytes16(13);
994       shop[newShopAddress].cat = _data.toBytes16(29);
995       shop[newShopAddress].name = _data.toBytes16(45);
996       shop[newShopAddress].description = _data.toBytes32(61);
997       shop[newShopAddress].opening = _data.toBytes16(93);
998       shop[newShopAddress].generalIndex = shopIndex.push(newShopAddress) - 1;
999       shop[newShopAddress].zoneIndex = shopInZone[_data.toBytes2(11)][_data.toBytes16(13)].push(newShopAddress) - 1;
1000       shop[newShopAddress].detherShop = true;
1001       emit RegisterShop(newShopAddress);
1002       bank.addTokenShop(newShopAddress, _value);
1003       dth.transfer(address(bank), _value);
1004     }
1005   }
1006 
1007   /**
1008    * a teller can update his profile
1009    * If a teller want to change his location, he would need to delete and recreate
1010    * a new point
1011    */
1012   function updateTeller(
1013     int8 currencyId,
1014     bytes16 messenger,
1015     int8 avatarId,
1016     int16 rates,
1017     bool online
1018    ) public payable {
1019     require(isTeller(msg.sender));
1020     if (currencyId != teller[msg.sender].currencyId)
1021     teller[msg.sender].currencyId = currencyId;
1022     if (teller[msg.sender].messenger != messenger)
1023      teller[msg.sender].messenger = messenger;
1024     if (teller[msg.sender].avatarId != avatarId)
1025      teller[msg.sender].avatarId = avatarId;
1026     if (teller[msg.sender].rates != rates)
1027      teller[msg.sender].rates = rates;
1028     if (teller[msg.sender].online != online)
1029       teller[msg.sender].online = online;
1030     if (msg.value > 0) {
1031       bank.addEthTeller.value(msg.value)(msg.sender, msg.value);
1032     }
1033     emit UpdateTeller(msg.sender);
1034   }
1035 
1036   // mapping for limiting the sell amount
1037   //      tier             countryId usdDailyLimit
1038   mapping(uint => mapping (bytes2 => uint)) limitTier;
1039 
1040   function setSellDailyLimit(uint _tier, bytes2 _countryId, uint256 _limitUsd) public onlyCFO {
1041     limitTier[_tier][_countryId] = _limitUsd;
1042   }
1043   function getSellDailyLimit(uint _tier, bytes2 _countryId) public view returns(uint256 limitUsd) {
1044     limitUsd = limitTier[_tier][_countryId];
1045   }
1046 
1047   modifier doesNotExceedDailySellLimit(address _teller, uint256 _weiSellAmount) {
1048     // limits are set per country
1049     bytes2 countryId = teller[_teller].countryId;
1050 
1051     // user is always tier1, and could be tier2
1052     uint256 usdDailyLimit = getSellDailyLimit(isTier2(_teller) ? 2 : 1, countryId);
1053 
1054     // weiPriceOneUsd is set by the oracle (which runs every day at midnight)
1055     uint256 weiDailyLimit = SafeMath.mul(priceOracle.getWeiPriceOneUsd(), usdDailyLimit);
1056 
1057     // with each sell we update wei sold today for that user inside the Bank contract
1058     uint256 weiSoldToday = bank.getWeiSoldToday(_teller);
1059 
1060     uint256 newWeiSoldToday = SafeMath.add(weiSoldToday, _weiSellAmount);
1061 
1062     // we may not exceed the daily wei limit with this sell
1063     require(newWeiSoldToday <= weiDailyLimit);
1064     _;
1065   }
1066 
1067   function getPairSellLoyaltyPerc(address _from, address _to) public view returns(uint256) {
1068     return pairSellsLoyaltyPerc[_from][_to];
1069   }
1070 
1071   function getLoyaltyPoints(address who) public view returns (uint256) {
1072     return loyaltyPoints[who];
1073   }
1074 
1075   /**
1076    * SellEth
1077    * average gas cost: 123173
1078    * @param _to -> the address for the receiver
1079    * @param _amount -> the amount to send
1080    */
1081   function sellEth(address _to, uint _amount)
1082     whenNotPaused
1083     doesNotExceedDailySellLimit(msg.sender, _amount)
1084     external
1085   {
1086     require(isTeller(msg.sender));
1087     require(_to != msg.sender);
1088     // send eth to the receiver from the bank contract
1089     // this will also update eth amount sold 'today' by msg.sender
1090     bank.withdrawEth(msg.sender, _to, _amount);
1091 
1092     // increase reput for the buyer and the seller Only if the buyer is also whitelisted,
1093     // It's a way to incentive user to trade on the system
1094     if (smsCertifier.certified(_to)) {
1095       uint currentSellerLoyaltyPointsPerc = pairSellsLoyaltyPerc[msg.sender][_to];
1096       if (currentSellerLoyaltyPointsPerc == 0) {
1097         // this is the first sell between seller and buyer, set to 100%
1098         pairSellsLoyaltyPerc[msg.sender][_to] = 10000;
1099         currentSellerLoyaltyPointsPerc = 10000;
1100       }
1101 
1102       // add percentage of loyaltyPoints of this sell to seller's loyaltyPoints
1103       loyaltyPoints[msg.sender] = SafeMath.add(loyaltyPoints[msg.sender], SafeMath.mul(_amount, currentSellerLoyaltyPointsPerc) / 10000);
1104 
1105       // update the loyaltyPoints percentage of the seller, there will be a 21% decrease with every sell to the same buyer (100 - 21 = 79)
1106       pairSellsLoyaltyPerc[msg.sender][_to] = SafeMath.mul(currentSellerLoyaltyPointsPerc, 79) / 100;
1107 
1108       volumeBuy[_to] = SafeMath.add(volumeBuy[_to], _amount);
1109       volumeSell[msg.sender] = SafeMath.add(volumeSell[msg.sender], _amount);
1110       nbTrade[msg.sender] += 1;
1111     }
1112     emit Sent(msg.sender, _to, _amount);
1113   }
1114 
1115   /**
1116    * switchStatus
1117    * Turn status teller on/off
1118    */
1119   function switchStatus(bool _status) external {
1120     if (teller[msg.sender].online != _status)
1121      teller[msg.sender].online = _status;
1122   }
1123 
1124   /**
1125    * addFunds
1126    * teller can add more funds on his sellpoint
1127    */
1128   function addFunds() external payable {
1129     require(isTeller(msg.sender));
1130     require(bank.addEthTeller.value(msg.value)(msg.sender, msg.value));
1131   }
1132 
1133   // gas used 67841
1134   // a teller can delete a sellpoint
1135   function deleteTeller() external {
1136     require(isTeller(msg.sender));
1137     uint rowToDelete1 = teller[msg.sender].zoneIndex;
1138     address keyToMove1 = tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode][tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode].length - 1];
1139     tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode][rowToDelete1] = keyToMove1;
1140     teller[keyToMove1].zoneIndex = rowToDelete1;
1141     tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode].length--;
1142 
1143     uint rowToDelete2 = teller[msg.sender].generalIndex;
1144     address keyToMove2 = tellerIndex[tellerIndex.length - 1];
1145     tellerIndex[rowToDelete2] = keyToMove2;
1146     teller[keyToMove2].generalIndex = rowToDelete2;
1147     tellerIndex.length--;
1148     delete teller[msg.sender];
1149     bank.withdrawDthTeller(msg.sender);
1150     bank.refundEth(msg.sender);
1151     emit DeleteTeller(msg.sender);
1152   }
1153 
1154   // gas used 67841
1155   // A moderator can delete a sellpoint
1156   function deleteTellerMods(address _toDelete) isTellerModerator(msg.sender) external {
1157     require(isTeller(_toDelete));
1158     uint rowToDelete1 = teller[_toDelete].zoneIndex;
1159     address keyToMove1 = tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode][tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode].length - 1];
1160     tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode][rowToDelete1] = keyToMove1;
1161     teller[keyToMove1].zoneIndex = rowToDelete1;
1162     tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode].length--;
1163 
1164     uint rowToDelete2 = teller[_toDelete].generalIndex;
1165     address keyToMove2 = tellerIndex[tellerIndex.length - 1];
1166     tellerIndex[rowToDelete2] = keyToMove2;
1167     teller[keyToMove2].generalIndex = rowToDelete2;
1168     tellerIndex.length--;
1169     delete teller[_toDelete];
1170     bank.withdrawDthTeller(_toDelete);
1171     bank.refundEth(_toDelete);
1172     emit DeleteTellerModerator(msg.sender, _toDelete);
1173   }
1174 
1175   // gas used 67841
1176   // A shop owner can delete his point.
1177   function deleteShop() external {
1178     require(isShop(msg.sender));
1179     uint rowToDelete1 = shop[msg.sender].zoneIndex;
1180     address keyToMove1 = shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode][shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode].length - 1];
1181     shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode][rowToDelete1] = keyToMove1;
1182     shop[keyToMove1].zoneIndex = rowToDelete1;
1183     shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode].length--;
1184 
1185     uint rowToDelete2 = shop[msg.sender].generalIndex;
1186     address keyToMove2 = shopIndex[shopIndex.length - 1];
1187     shopIndex[rowToDelete2] = keyToMove2;
1188     shop[keyToMove2].generalIndex = rowToDelete2;
1189     shopIndex.length--;
1190     delete shop[msg.sender];
1191     bank.withdrawDthShop(msg.sender);
1192     emit DeleteShop(msg.sender);
1193   }
1194 
1195   // gas used 67841
1196   // Moderator can delete a shop point
1197   function deleteShopMods(address _toDelete) isShopModerator(msg.sender) external {
1198     uint rowToDelete1 = shop[_toDelete].zoneIndex;
1199     address keyToMove1 = shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode][shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode].length - 1];
1200     shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode][rowToDelete1] = keyToMove1;
1201     shop[keyToMove1].zoneIndex = rowToDelete1;
1202     shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode].length--;
1203 
1204     uint rowToDelete2 = shop[_toDelete].generalIndex;
1205     address keyToMove2 = shopIndex[shopIndex.length - 1];
1206     shopIndex[rowToDelete2] = keyToMove2;
1207     shop[keyToMove2].generalIndex = rowToDelete2;
1208     shopIndex.length--;
1209     if (!shop[_toDelete].detherShop)
1210       bank.withdrawDthShop(_toDelete);
1211     else
1212       bank.withdrawDthShopAdmin(_toDelete, csoAddress);
1213     delete shop[_toDelete];
1214     emit DeleteShopModerator(msg.sender, _toDelete);
1215   }
1216 
1217   /**
1218    *  GETTER
1219    */
1220 
1221   // get teller
1222   // return teller info
1223   function getTeller(address _teller) public view returns (
1224     int32 lat,
1225     int32 lng,
1226     bytes2 countryId,
1227     bytes16 postalCode,
1228     int8 currencyId,
1229     bytes16 messenger,
1230     int8 avatarId,
1231     int16 rates,
1232     uint balance,
1233     bool online,
1234     bool buyer,
1235     int16 buyRates
1236     ) {
1237     Teller storage theTeller = teller[_teller];
1238     lat = theTeller.lat;
1239     lng = theTeller.lng;
1240     countryId = theTeller.countryId;
1241     postalCode = theTeller.postalCode;
1242     currencyId = theTeller.currencyId;
1243     messenger = theTeller.messenger;
1244     avatarId = theTeller.avatarId;
1245     rates = theTeller.rates;
1246     online = theTeller.online;
1247     buyer = theTeller.buyer;
1248     buyRates = theTeller.buyRates;
1249     balance = bank.getEthBalTeller(_teller);
1250   }
1251 
1252   /*
1253    * Shop ----------------------------------
1254    * return Shop value
1255    */
1256   function getShop(address _shop) public view returns (
1257    int32 lat,
1258    int32 lng,
1259    bytes2 countryId,
1260    bytes16 postalCode,
1261    bytes16 cat,
1262    bytes16 name,
1263    bytes32 description,
1264    bytes16 opening
1265    ) {
1266     Shop storage theShop = shop[_shop];
1267     lat = theShop.lat;
1268     lng = theShop.lng;
1269     countryId = theShop.countryId;
1270     postalCode = theShop.postalCode;
1271     cat = theShop.cat;
1272     name = theShop.name;
1273     description = theShop.description;
1274     opening = theShop.opening;
1275    }
1276 
1277    // get reput
1278    // return reputation data from teller
1279   function getReput(address _teller) public view returns (
1280    uint buyVolume,
1281    uint sellVolume,
1282    uint numTrade,
1283    uint256 loyaltyPoints_
1284    ) {
1285      buyVolume = volumeBuy[_teller];
1286      sellVolume = volumeSell[_teller];
1287      numTrade = nbTrade[_teller];
1288      loyaltyPoints_ = loyaltyPoints[_teller];
1289   }
1290   // return balance of teller put in escrow
1291   function getTellerBalance(address _teller) public view returns (uint) {
1292     return bank.getEthBalTeller(_teller);
1293   }
1294 
1295   // return an array of address of all zone present on a zone
1296   // zone is a mapping COUNTRY => POSTALCODE
1297   function getZoneShop(bytes2 _country, bytes16 _postalcode) public view returns (address[]) {
1298      return shopInZone[_country][_postalcode];
1299   }
1300 
1301   // return array of address of all shop
1302   function getAllShops() public view returns (address[]) {
1303    return shopIndex;
1304   }
1305 
1306   function isShop(address _shop) public view returns (bool ){
1307    return (shop[_shop].countryId != bytes2(0x0));
1308   }
1309 
1310   // return an array of address of all teller present on a zone
1311   // zone is a mapping COUNTRY => POSTALCODE
1312   function getZoneTeller(bytes2 _country, bytes16 _postalcode) public view returns (address[]) {
1313      return tellerInZone[_country][_postalcode];
1314   }
1315 
1316   // return array of address of all teller
1317   function getAllTellers() public view returns (address[]) {
1318    return tellerIndex;
1319   }
1320 
1321   // return if teller or not
1322   function isTeller(address _teller) public view returns (bool ){
1323     return (teller[_teller].countryId != bytes2(0x0));
1324   }
1325 
1326   /*
1327    * misc
1328    */
1329    // return info about how much DTH the shop has staked
1330   function getStakedShop(address _shop) public view returns (uint) {
1331     return bank.getDthShop(_shop);
1332   }
1333   // return info about how much DTH the teller has staked
1334   function getStakedTeller(address _teller) public view returns (uint) {
1335     return bank.getDthTeller(_teller);
1336   }
1337   // give ownership to the bank contract
1338   function transferBankOwnership(address _newbankowner) external onlyCEO whenPaused {
1339     bank.transferOwnership(_newbankowner);
1340   }
1341 }