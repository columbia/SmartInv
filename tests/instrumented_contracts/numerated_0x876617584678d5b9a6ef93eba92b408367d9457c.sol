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
785   // when a teller add funds for trade
786   event AddFunds(address indexed tellerAddress, uint amount);
787   // when a teller is deleted
788   event DeleteTeller(address indexed tellerAddress);
789   // when teller update
790   event UpdateTeller(address indexed tellerAddress);
791   // when a teller send to a buyer
792   event Sent(address indexed _from, address indexed _to, uint amount);
793   // when a shop register
794   event RegisterShop(address shopAddress);
795   // when a shop delete
796   event DeleteShop(address shopAddress);
797   // when a moderator delete a shop
798   event DeleteShopModerator(address indexed moderator, address shopAddress);
799   // when a moderator delete a teller
800   event DeleteTellerModerator(address indexed moderator, address tellerAddress);
801 
802   /**
803    * Modifier
804    */
805   // if teller has staked enough dth to
806   modifier tellerHasStaked(uint amount) {
807     require(bank.getDthTeller(msg.sender) >= amount);
808     _;
809   }
810   // if shop has staked enough dth to
811   modifier shopHasStaked(uint amount) {
812     require(bank.getDthShop(msg.sender) >= amount);
813     _;
814   }
815 
816   /*
817    * External contract
818    */
819   // DTH contract
820   ERC223Basic public dth;
821   // bank contract where are stored ETH and DTH
822   DetherBank public bank;
823 
824   ExchangeRateOracle public priceOracle;
825 
826   // teller struct
827   struct Teller {
828     int32 lat;            // Latitude
829     int32 lng;            // Longitude
830     bytes2 countryId;     // countryID (in hexa), ISO ALPHA 2 https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
831     bytes16 postalCode;   // postalCode if present, in Hexa https://en.wikipedia.org/wiki/List_of_postal_codes
832 
833     int8 currencyId;      // 1 - 100 , cf README
834     bytes16 messenger;    // telegrame nickname
835     int8 avatarId;        // 1 - 100 , regarding the front-end app you use
836     int16 rates;          // margin of tellers , -999 - +9999 , corresponding to -99,9% x 10  , 999,9% x 10
837     bool buyer;           // appear as a buyer as well on the map
838     int16 buyRates;         // margin of tellers of
839 
840     uint zoneIndex;       // index of the zone mapping
841     uint generalIndex;    // index of general mapping
842     bool online;          // switch online/offline, if the tellers want to be inactive without deleting his point
843   }
844 
845   mapping(address => mapping(address => uint)) internal pairSellsLoyaltyPerc;
846   //      from               to         percentage of loyalty points from gets
847 
848   /*
849    * Reputation field V0.1
850    * Reputation is based on volume sell, volume buy, and number of transaction
851    */
852   mapping(address => uint) volumeBuy;
853   mapping(address => uint) volumeSell;
854   mapping(address => uint) nbTrade;
855   mapping(address => uint256) loyaltyPoints;
856 
857   // general mapping of teller
858   mapping(address => Teller) teller;
859   // mappoing of teller by COUNTRYCODE => POSTALCODE
860   mapping(bytes2 => mapping(bytes16 => address[])) tellerInZone;
861   // teller array currently registered
862   address[] public tellerIndex; // unordered list of teller register on it
863   bool isStarted = false;
864   // shop struct
865   struct Shop {
866     int32 lat;            // latitude
867     int32 lng;            // longitude
868     bytes2 countryId;     // countryID (in hexa char), ISO ALPHA 2 https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
869     bytes16 postalCode;   // postalCode if present (in hexa char), in Hexa https://en.wikipedia.org/wiki/List_of_postal_codes
870     bytes16 cat;          // Category of the shop (in hex char), will be used later for search engine and auction by zone
871     bytes16 name;         // name of the shop (in hex char)
872     bytes32 description;  // description of the shop
873     bytes16 opening;      // opening hours, cf README for the format
874 
875     uint zoneIndex;       // index of the zone mapping
876     uint generalIndex;    // index of general mapping
877     bool detherShop;      // bool if shop is registered by dether as business partnership (still required DTH)
878   }
879 
880   // general mapping of shop
881   mapping(address => Shop) shop;
882   // mapping of teller by COUNTRYCODE => POSTALCODE
883   mapping(bytes2 => mapping(bytes16 => address[])) shopInZone;
884   // shop array currently registered
885   address[] public shopIndex; // unordered list of shop register on it
886 
887   /*
888    * Instanciation
889    */
890   function DetherCore() {
891    ceoAddress = msg.sender;
892   }
893   function initContract (address _dth, address _bank) external onlyCEO {
894     require(!isStarted);
895     dth = ERC223Basic(_dth);
896     bank = DetherBank(_bank);
897     isStarted = true;
898   }
899 
900   function setPriceOracle (address _priceOracle) external onlyCFO {
901     priceOracle = ExchangeRateOracle(_priceOracle);
902   }
903 
904   /**
905    * Core fonction
906    */
907 
908   /**
909    * @dev Standard ERC223 function that will handle incoming token transfers.
910    * This is the main function to register SHOP or TELLER, its calling when you
911    * send token to the DTH contract and by passing data as bytes on the third
912    * parameter.
913    * Its not supposed to be use on its own but will only handle incoming DTH
914    * transaction.
915    * The _data will wait for
916    * [1st byte] 1 (0x31) for shop OR 2 (0x32) for teller
917    * FOR SHOP AND TELLER:
918    * 2sd to 5th bytes lat
919    * 6th to 9th bytes lng
920    * ...
921    * Modifier tier1: Check if address is whitelisted with the sms verification
922    */
923   function tokenFallback(address _from, uint _value, bytes _data) whenNotPaused tier1(_from ) {
924     // require than the token fallback is triggered from the dth token contract
925     require(msg.sender == address(dth));
926     // check first byte to know if its shop or teller registration
927     // 1 / 0x31 = shop // 2 / 0x32 = teller
928     bytes1 _func = _data.toBytes1(0);
929     int32 posLat = _data.toBytes1(1) == bytes1(0x01) ? int32(_data.toBytes4(2)) * -1 : int32(_data.toBytes4(2));
930     int32 posLng = _data.toBytes1(6) == bytes1(0x01) ? int32(_data.toBytes4(7)) * -1 : int32(_data.toBytes4(7));
931     if (_func == bytes1(0x31)) { // shop registration // GAS USED 311000
932       // require staked greater than licence price
933       require(_value >= licenceShop[_data.toBytes2(11)]);
934       // require its not already shop
935       require(!isShop(_from));
936       // require zone is open
937       require(openedCountryShop[_data.toBytes2(11)]);
938 
939       shop[_from].lat = posLat;
940       shop[_from].lng = posLng;
941       shop[_from].countryId = _data.toBytes2(11);
942       shop[_from].postalCode = _data.toBytes16(13);
943       shop[_from].cat = _data.toBytes16(29);
944       shop[_from].name = _data.toBytes16(45);
945       shop[_from].description = _data.toBytes32(61);
946       shop[_from].opening = _data.toBytes16(93);
947       shop[_from].generalIndex = shopIndex.push(_from) - 1;
948       shop[_from].zoneIndex = shopInZone[_data.toBytes2(11)][_data.toBytes16(13)].push(_from) - 1;
949       emit RegisterShop(_from);
950       bank.addTokenShop(_from,_value);
951       dth.transfer(address(bank), _value);
952     } else if (_func == bytes1(0x32)) { // teller registration -- GAS USED 310099
953       // require staked greater than licence price
954       require(_value >= licenceTeller[_data.toBytes2(11)]);
955       // require is not already a teller
956       require(!isTeller(_from));
957       // require zone is open
958       require(openedCountryTeller[_data.toBytes2(11)]);
959 
960       teller[_from].lat = posLat;
961       teller[_from].lng = posLng;
962       teller[_from].countryId = _data.toBytes2(11);
963       teller[_from].postalCode = _data.toBytes16(13);
964       teller[_from].avatarId = int8(_data.toBytes1(29));
965       teller[_from].currencyId = int8(_data.toBytes1(30));
966       teller[_from].messenger = _data.toBytes16(31);
967       teller[_from].rates = int16(_data.toBytes2(47));
968       teller[_from].buyer = _data.toBytes1(49) == bytes1(0x01) ? true : false;
969       teller[_from].buyRates = int16(_data.toBytes2(50));
970       teller[_from].generalIndex = tellerIndex.push(_from) - 1;
971       teller[_from].zoneIndex = tellerInZone[_data.toBytes2(11)][_data.toBytes16(13)].push(_from) - 1;
972       teller[_from].online = true;
973       emit RegisterTeller(_from);
974       bank.addTokenTeller(_from, _value);
975       dth.transfer(address(bank), _value);
976     } else if (_func == bytes1(0x33)) {  // shop bulk registration
977       // We need to have the possibility to register in bulk some shop
978       // For big retailer company willing to be listed on dether, we need to have a way to add
979       // all their shop from one address
980       // This functionnality will become available for anyone willing to list multiple shop
981       // in the futures contract
982 
983       // Only the CSO should be able to register shop in bulk
984       require(_from == csoAddress);
985       // Each shop still need his own staking
986       require(_value >= licenceShop[_data.toBytes2(11)]);
987       // require the addresses not already registered
988       require(!isShop(address(_data.toAddress(109))));
989       // require zone is open
990       require(openedCountryShop[_data.toBytes2(11)]);
991       address newShopAddress = _data.toAddress(109);
992       shop[newShopAddress].lat = posLat;
993       shop[newShopAddress].lng = posLng;
994       shop[newShopAddress].countryId = _data.toBytes2(11);
995       shop[newShopAddress].postalCode = _data.toBytes16(13);
996       shop[newShopAddress].cat = _data.toBytes16(29);
997       shop[newShopAddress].name = _data.toBytes16(45);
998       shop[newShopAddress].description = _data.toBytes32(61);
999       shop[newShopAddress].opening = _data.toBytes16(93);
1000       shop[newShopAddress].generalIndex = shopIndex.push(newShopAddress) - 1;
1001       shop[newShopAddress].zoneIndex = shopInZone[_data.toBytes2(11)][_data.toBytes16(13)].push(newShopAddress) - 1;
1002       shop[newShopAddress].detherShop = true;
1003       emit RegisterShop(newShopAddress);
1004       bank.addTokenShop(newShopAddress, _value);
1005       dth.transfer(address(bank), _value);
1006     }
1007   }
1008 
1009   /**
1010    * a teller can update his profile
1011    * If a teller want to change his location, he would need to delete and recreate
1012    * a new point
1013    */
1014   function updateTeller(
1015     int8 currencyId,
1016     bytes16 messenger,
1017     int8 avatarId,
1018     int16 rates,
1019     bool online
1020    ) public payable {
1021     require(isTeller(msg.sender));
1022     if (currencyId != teller[msg.sender].currencyId)
1023     teller[msg.sender].currencyId = currencyId;
1024     if (teller[msg.sender].messenger != messenger)
1025      teller[msg.sender].messenger = messenger;
1026     if (teller[msg.sender].avatarId != avatarId)
1027      teller[msg.sender].avatarId = avatarId;
1028     if (teller[msg.sender].rates != rates)
1029      teller[msg.sender].rates = rates;
1030     if (teller[msg.sender].online != online)
1031       teller[msg.sender].online = online;
1032     if (msg.value > 0) {
1033       bank.addEthTeller.value(msg.value)(msg.sender, msg.value);
1034     }
1035     emit UpdateTeller(msg.sender);
1036   }
1037 
1038   // mapping for limiting the sell amount
1039   //      tier             countryId usdDailyLimit
1040   mapping(uint => mapping (bytes2 => uint)) limitTier;
1041 
1042   function setSellDailyLimit(uint _tier, bytes2 _countryId, uint256 _limitUsd) public onlyCFO {
1043     limitTier[_tier][_countryId] = _limitUsd;
1044   }
1045   function getSellDailyLimit(uint _tier, bytes2 _countryId) public view returns(uint256 limitUsd) {
1046     limitUsd = limitTier[_tier][_countryId];
1047   }
1048 
1049   modifier doesNotExceedDailySellLimit(address _teller, uint256 _weiSellAmount) {
1050     // limits are set per country
1051     bytes2 countryId = teller[_teller].countryId;
1052 
1053     // user is always tier1, and could be tier2
1054     uint256 usdDailyLimit = getSellDailyLimit(isTier2(_teller) ? 2 : 1, countryId);
1055 
1056     // weiPriceOneUsd is set by the oracle (which runs every day at midnight)
1057     uint256 weiDailyLimit = SafeMath.mul(priceOracle.getWeiPriceOneUsd(), usdDailyLimit);
1058 
1059     // with each sell we update wei sold today for that user inside the Bank contract
1060     uint256 weiSoldToday = bank.getWeiSoldToday(_teller);
1061 
1062     uint256 newWeiSoldToday = SafeMath.add(weiSoldToday, _weiSellAmount);
1063 
1064     // we may not exceed the daily wei limit with this sell
1065     require(newWeiSoldToday <= weiDailyLimit);
1066     _;
1067   }
1068 
1069   function getPairSellLoyaltyPerc(address _from, address _to) public view returns(uint256) {
1070     return pairSellsLoyaltyPerc[_from][_to];
1071   }
1072 
1073   function getLoyaltyPoints(address who) public view returns (uint256) {
1074     return loyaltyPoints[who];
1075   }
1076 
1077   /**
1078    * SellEth
1079    * average gas cost: 123173
1080    * @param _to -> the address for the receiver
1081    * @param _amount -> the amount to send
1082    */
1083   function sellEth(address _to, uint _amount)
1084     whenNotPaused
1085     doesNotExceedDailySellLimit(msg.sender, _amount)
1086     external
1087   {
1088     require(isTeller(msg.sender));
1089     require(_to != msg.sender);
1090     // send eth to the receiver from the bank contract
1091     // this will also update eth amount sold 'today' by msg.sender
1092     bank.withdrawEth(msg.sender, _to, _amount);
1093 
1094     // increase reput for the buyer and the seller Only if the buyer is also whitelisted,
1095     // It's a way to incentive user to trade on the system
1096     if (smsCertifier.certified(_to)) {
1097       uint currentSellerLoyaltyPointsPerc = pairSellsLoyaltyPerc[msg.sender][_to];
1098       if (currentSellerLoyaltyPointsPerc == 0) {
1099         // this is the first sell between seller and buyer, set to 100%
1100         pairSellsLoyaltyPerc[msg.sender][_to] = 10000;
1101         currentSellerLoyaltyPointsPerc = 10000;
1102       }
1103 
1104       // add percentage of loyaltyPoints of this sell to seller's loyaltyPoints
1105       loyaltyPoints[msg.sender] = SafeMath.add(loyaltyPoints[msg.sender], SafeMath.mul(_amount, currentSellerLoyaltyPointsPerc) / 10000);
1106 
1107       // update the loyaltyPoints percentage of the seller, there will be a 21% decrease with every sell to the same buyer (100 - 21 = 79)
1108       pairSellsLoyaltyPerc[msg.sender][_to] = SafeMath.mul(currentSellerLoyaltyPointsPerc, 79) / 100;
1109 
1110       volumeBuy[_to] = SafeMath.add(volumeBuy[_to], _amount);
1111       volumeSell[msg.sender] = SafeMath.add(volumeSell[msg.sender], _amount);
1112       nbTrade[msg.sender] += 1;
1113     }
1114     emit Sent(msg.sender, _to, _amount);
1115   }
1116 
1117   /**
1118    * switchStatus
1119    * Turn status teller on/off
1120    */
1121   function switchStatus(bool _status) external {
1122     if (teller[msg.sender].online != _status)
1123      teller[msg.sender].online = _status;
1124   }
1125 
1126   /**
1127    * addFunds
1128    * teller can add more funds on his sellpoint
1129    */
1130   function addFunds() external payable {
1131     require(isTeller(msg.sender));
1132     require(bank.addEthTeller.value(msg.value)(msg.sender, msg.value));
1133     emit AddFunds(msg.sender, msg.value);
1134   }
1135 
1136   // gas used 67841
1137   // a teller can delete a sellpoint
1138   function deleteTeller() external {
1139     require(isTeller(msg.sender));
1140     uint rowToDelete1 = teller[msg.sender].zoneIndex;
1141     address keyToMove1 = tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode][tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode].length - 1];
1142     tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode][rowToDelete1] = keyToMove1;
1143     teller[keyToMove1].zoneIndex = rowToDelete1;
1144     tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode].length--;
1145 
1146     uint rowToDelete2 = teller[msg.sender].generalIndex;
1147     address keyToMove2 = tellerIndex[tellerIndex.length - 1];
1148     tellerIndex[rowToDelete2] = keyToMove2;
1149     teller[keyToMove2].generalIndex = rowToDelete2;
1150     tellerIndex.length--;
1151     delete teller[msg.sender];
1152     bank.withdrawDthTeller(msg.sender);
1153     bank.refundEth(msg.sender);
1154     emit DeleteTeller(msg.sender);
1155   }
1156 
1157   // gas used 67841
1158   // A moderator can delete a sellpoint
1159   function deleteTellerMods(address _toDelete) isTellerModerator(msg.sender) external {
1160     require(isTeller(_toDelete));
1161     uint rowToDelete1 = teller[_toDelete].zoneIndex;
1162     address keyToMove1 = tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode][tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode].length - 1];
1163     tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode][rowToDelete1] = keyToMove1;
1164     teller[keyToMove1].zoneIndex = rowToDelete1;
1165     tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode].length--;
1166 
1167     uint rowToDelete2 = teller[_toDelete].generalIndex;
1168     address keyToMove2 = tellerIndex[tellerIndex.length - 1];
1169     tellerIndex[rowToDelete2] = keyToMove2;
1170     teller[keyToMove2].generalIndex = rowToDelete2;
1171     tellerIndex.length--;
1172     delete teller[_toDelete];
1173     bank.withdrawDthTeller(_toDelete);
1174     bank.refundEth(_toDelete);
1175     emit DeleteTellerModerator(msg.sender, _toDelete);
1176   }
1177 
1178   // gas used 67841
1179   // A shop owner can delete his point.
1180   function deleteShop() external {
1181     require(isShop(msg.sender));
1182     uint rowToDelete1 = shop[msg.sender].zoneIndex;
1183     address keyToMove1 = shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode][shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode].length - 1];
1184     shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode][rowToDelete1] = keyToMove1;
1185     shop[keyToMove1].zoneIndex = rowToDelete1;
1186     shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode].length--;
1187 
1188     uint rowToDelete2 = shop[msg.sender].generalIndex;
1189     address keyToMove2 = shopIndex[shopIndex.length - 1];
1190     shopIndex[rowToDelete2] = keyToMove2;
1191     shop[keyToMove2].generalIndex = rowToDelete2;
1192     shopIndex.length--;
1193     delete shop[msg.sender];
1194     bank.withdrawDthShop(msg.sender);
1195     emit DeleteShop(msg.sender);
1196   }
1197 
1198   // gas used 67841
1199   // Moderator can delete a shop point
1200   function deleteShopMods(address _toDelete) isShopModerator(msg.sender) external {
1201     uint rowToDelete1 = shop[_toDelete].zoneIndex;
1202     address keyToMove1 = shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode][shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode].length - 1];
1203     shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode][rowToDelete1] = keyToMove1;
1204     shop[keyToMove1].zoneIndex = rowToDelete1;
1205     shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode].length--;
1206 
1207     uint rowToDelete2 = shop[_toDelete].generalIndex;
1208     address keyToMove2 = shopIndex[shopIndex.length - 1];
1209     shopIndex[rowToDelete2] = keyToMove2;
1210     shop[keyToMove2].generalIndex = rowToDelete2;
1211     shopIndex.length--;
1212     if (!shop[_toDelete].detherShop)
1213       bank.withdrawDthShop(_toDelete);
1214     else
1215       bank.withdrawDthShopAdmin(_toDelete, csoAddress);
1216     delete shop[_toDelete];
1217     emit DeleteShopModerator(msg.sender, _toDelete);
1218   }
1219 
1220   /**
1221    *  GETTER
1222    */
1223 
1224   // get teller
1225   // return teller info
1226   function getTeller(address _teller) public view returns (
1227     int32 lat,
1228     int32 lng,
1229     bytes2 countryId,
1230     bytes16 postalCode,
1231     int8 currencyId,
1232     bytes16 messenger,
1233     int8 avatarId,
1234     int16 rates,
1235     uint balance,
1236     bool online,
1237     bool buyer,
1238     int16 buyRates
1239     ) {
1240     Teller storage theTeller = teller[_teller];
1241     lat = theTeller.lat;
1242     lng = theTeller.lng;
1243     countryId = theTeller.countryId;
1244     postalCode = theTeller.postalCode;
1245     currencyId = theTeller.currencyId;
1246     messenger = theTeller.messenger;
1247     avatarId = theTeller.avatarId;
1248     rates = theTeller.rates;
1249     online = theTeller.online;
1250     buyer = theTeller.buyer;
1251     buyRates = theTeller.buyRates;
1252     balance = bank.getEthBalTeller(_teller);
1253   }
1254 
1255   /*
1256    * Shop ----------------------------------
1257    * return Shop value
1258    */
1259   function getShop(address _shop) public view returns (
1260    int32 lat,
1261    int32 lng,
1262    bytes2 countryId,
1263    bytes16 postalCode,
1264    bytes16 cat,
1265    bytes16 name,
1266    bytes32 description,
1267    bytes16 opening
1268    ) {
1269     Shop storage theShop = shop[_shop];
1270     lat = theShop.lat;
1271     lng = theShop.lng;
1272     countryId = theShop.countryId;
1273     postalCode = theShop.postalCode;
1274     cat = theShop.cat;
1275     name = theShop.name;
1276     description = theShop.description;
1277     opening = theShop.opening;
1278    }
1279 
1280    // get reput
1281    // return reputation data from teller
1282   function getReput(address _teller) public view returns (
1283    uint buyVolume,
1284    uint sellVolume,
1285    uint numTrade,
1286    uint256 loyaltyPoints_
1287    ) {
1288      buyVolume = volumeBuy[_teller];
1289      sellVolume = volumeSell[_teller];
1290      numTrade = nbTrade[_teller];
1291      loyaltyPoints_ = loyaltyPoints[_teller];
1292   }
1293   // return balance of teller put in escrow
1294   function getTellerBalance(address _teller) public view returns (uint) {
1295     return bank.getEthBalTeller(_teller);
1296   }
1297 
1298   // return an array of address of all zone present on a zone
1299   // zone is a mapping COUNTRY => POSTALCODE
1300   function getZoneShop(bytes2 _country, bytes16 _postalcode) public view returns (address[]) {
1301      return shopInZone[_country][_postalcode];
1302   }
1303 
1304   // return array of address of all shop
1305   function getAllShops() public view returns (address[]) {
1306    return shopIndex;
1307   }
1308 
1309   function isShop(address _shop) public view returns (bool ){
1310    return (shop[_shop].countryId != bytes2(0x0));
1311   }
1312 
1313   // return an array of address of all teller present on a zone
1314   // zone is a mapping COUNTRY => POSTALCODE
1315   function getZoneTeller(bytes2 _country, bytes16 _postalcode) public view returns (address[]) {
1316      return tellerInZone[_country][_postalcode];
1317   }
1318 
1319   // return array of address of all teller
1320   function getAllTellers() public view returns (address[]) {
1321    return tellerIndex;
1322   }
1323 
1324   // return if teller or not
1325   function isTeller(address _teller) public view returns (bool ){
1326     return (teller[_teller].countryId != bytes2(0x0));
1327   }
1328 
1329   /*
1330    * misc
1331    */
1332    // return info about how much DTH the shop has staked
1333   function getStakedShop(address _shop) public view returns (uint) {
1334     return bank.getDthShop(_shop);
1335   }
1336   // return info about how much DTH the teller has staked
1337   function getStakedTeller(address _teller) public view returns (uint) {
1338     return bank.getDthTeller(_teller);
1339   }
1340   // give ownership to the bank contract
1341   function transferBankOwnership(address _newbankowner) external onlyCEO whenPaused {
1342     bank.transferOwnership(_newbankowner);
1343   }
1344 }