1 contract Certifier {
2 	event Confirmed(address indexed who);
3 	event Revoked(address indexed who);
4 	function certified(address _who) view public returns (bool);
5 }
6 
7 contract ERC223ReceivingContract {
8 
9     /// @dev Standard ERC223 function that will handle incoming token transfers.
10     /// @param _from  Token sender address.
11     /// @param _value Amount of tokens.
12     /// @param _data  Transaction metadata.
13     function tokenFallback(address _from, uint _value, bytes _data) public;
14 
15 }
16 
17 contract ERC20Basic {
18   function totalSupply() public view returns (uint256);
19   function balanceOf(address who) public view returns (uint256);
20   function transfer(address to, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 contract ERC223Basic is ERC20Basic {
25 
26     /**
27       * @dev Transfer the specified amount of tokens to the specified address.
28       *      Now with a new parameter _data.
29       *
30       * @param _to    Receiver address.
31       * @param _value Amount of tokens that will be transferred.
32       * @param _data  Transaction metadata.
33       */
34     function transfer(address _to, uint _value, bytes _data) public returns (bool);
35 
36     /**
37       * @dev triggered when transfer is successfully called.
38       *
39       * @param _from  Sender address.
40       * @param _to    Receiver address.
41       * @param _value Amount of tokens that will be transferred.
42       * @param _data  Transaction metadata.
43       */
44     event Transfer(address indexed _from, address indexed _to, uint256 indexed _value, bytes _data);
45 }
46 
47 
48 contract SafeMath {
49 
50   /**
51   * @dev Multiplies two numbers, throws on overflow.
52   */
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return c;
70   }
71 
72   /**
73   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 contract Ownable {
91   address public owner;
92 
93 
94   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95 
96 
97   /**
98    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99    * account.
100    */
101   function Ownable() public {
102     owner = msg.sender;
103   }
104 
105   /**
106    * @dev Throws if called by any account other than the owner.
107    */
108   modifier onlyOwner() {
109     require(msg.sender == owner);
110     _;
111   }
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address newOwner) public onlyOwner {
118     require(newOwner != address(0));
119     OwnershipTransferred(owner, newOwner);
120     owner = newOwner;
121   }
122 
123 }
124 
125 
126 contract DetherBank is ERC223ReceivingContract, Ownable, SafeMath  {
127   using BytesLib for bytes;
128 
129   /*
130    * Event
131    */
132   event receiveDth(address _from, uint amount);
133   event receiveEth(address _from, uint amount);
134   event sendDth(address _from, uint amount);
135   event sendEth(address _from, uint amount);
136 
137   mapping(address => uint) public dthShopBalance;
138   mapping(address => uint) public dthTellerBalance;
139   mapping(address => uint) public ethShopBalance;
140   mapping(address => uint) public ethTellerBalance;
141 
142   ERC223Basic public dth;
143   bool public isInit = false;
144 
145   /**
146    * INIT
147    */
148   function setDth (address _dth) external onlyOwner {
149     require(!isInit);
150     dth = ERC223Basic(_dth);
151     isInit = true;
152   }
153 
154   /**
155    * Core fonction
156    */
157   // withdraw DTH when teller delete
158   function withdrawDthTeller(address _receiver) external onlyOwner {
159     require(dthTellerBalance[_receiver] > 0);
160     uint tosend = dthTellerBalance[_receiver];
161     dthTellerBalance[_receiver] = 0;
162     require(dth.transfer(_receiver, tosend));
163   }
164   // withdraw DTH when shop delete
165   function withdrawDthShop(address _receiver) external onlyOwner  {
166     require(dthShopBalance[_receiver] > 0);
167     uint tosend = dthShopBalance[_receiver];
168     dthShopBalance[_receiver] = 0;
169     require(dth.transfer(_receiver, tosend));
170   }
171   // withdraw DTH when a shop add by admin is delete
172   function withdrawDthShopAdmin(address _from, address _receiver) external onlyOwner  {
173     require(dthShopBalance[_from]  > 0);
174     uint tosend = dthShopBalance[_from];
175     dthShopBalance[_from] = 0;
176     require(dth.transfer(_receiver, tosend));
177   }
178 
179   // add DTH when shop register
180   function addTokenShop(address _from, uint _value) external onlyOwner {
181     dthShopBalance[_from] = SafeMath.add(dthShopBalance[_from], _value);
182   }
183   // add DTH when token register
184   function addTokenTeller(address _from, uint _value) external onlyOwner{
185     dthTellerBalance[_from] = SafeMath.add(dthTellerBalance[_from], _value);
186   }
187   // add ETH for escrow teller
188   function addEthTeller(address _from, uint _value) external payable onlyOwner returns (bool) {
189     ethTellerBalance[_from] = SafeMath.add(ethTellerBalance[_from] ,_value);
190     return true;
191   }
192   // withdraw ETH for teller escrow
193   function withdrawEth(address _from, address _to, uint _amount) external onlyOwner {
194     require(ethTellerBalance[_from] >= _amount);
195     ethTellerBalance[_from] = SafeMath.sub(ethTellerBalance[_from], _amount);
196     _to.transfer(_amount);
197   }
198   // refund all ETH from teller contract
199   function refundEth(address _from) external onlyOwner {
200     uint toSend = ethTellerBalance[_from];
201     if (toSend > 0) {
202       ethTellerBalance[_from] = 0;
203       _from.transfer(toSend);
204     }
205   }
206 
207   /**
208    * GETTER
209    */
210   function getDthTeller(address _user) public view returns (uint) {
211     return dthTellerBalance[_user];
212   }
213   function getDthShop(address _user) public view returns (uint) {
214     return dthShopBalance[_user];
215   }
216 
217   function getEthBalTeller(address _user) public view returns (uint) {
218     return ethTellerBalance[_user];
219   }
220   /// @dev Standard ERC223 function that will handle incoming token transfers.
221   // DO NOTHING but allow to receive token when addToken* function are called
222   // by the dethercore contract
223   function tokenFallback(address _from, uint _value, bytes _data) {
224     require(msg.sender == address(dth));
225   }
226 
227 }
228 
229 
230 contract DetherAccessControl {
231     // This facet controls access control for Dether. There are four roles managed here:
232     //
233     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
234     //         contracts. It is also the only role that can unpause the smart contract.
235     //
236     //     - The CMO: The CMO is in charge to open or close activity in zone
237     //
238     // It should be noted that these roles are distinct without overlap in their access abilities, the
239     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
240     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
241     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
242     // convenience. The less we use an address, the less likely it is that we somehow compromise the
243     // account.
244 
245     /// @dev Emited when contract is upgraded
246     event ContractUpgrade(address newContract);
247 
248     // The addresses of the accounts (or contracts) that can execute actions within each roles.
249     address public ceoAddress;
250     address public cmoAddress;
251     address public csoAddress; // CHIEF SHOP OFFICER
252 	  mapping (address => bool) public shopModerators;   // centralised moderator, would become decentralised
253     mapping (address => bool) public tellerModerators;   // centralised moderator, would become decentralised
254 
255     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
256     bool public paused = false;
257 
258     /// @dev Access modifier for CEO-only functionality
259     modifier onlyCEO() {
260         require(msg.sender == ceoAddress);
261         _;
262     }
263 
264     /// @dev Access modifier for CMO-only functionality
265     modifier onlyCMO() {
266         require(msg.sender == cmoAddress);
267         _;
268     }
269 
270     function isCSO(address _addr) public view returns (bool) {
271       return (_addr == csoAddress);
272     }
273 
274 
275     modifier isShopModerator(address _user) {
276       require(shopModerators[_user]);
277       _;
278     }
279     modifier isTellerModerator(address _user) {
280       require(tellerModerators[_user]);
281       _;
282     }
283 
284     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
285     /// @param _newCEO The address of the new CEO
286     function setCEO(address _newCEO) external onlyCEO {
287         require(_newCEO != address(0));
288         ceoAddress = _newCEO;
289     }
290 
291     /// @dev Assigns a new address to act as the CMO. Only available to the current CEO.
292     /// @param _newCMO The address of the new CMO
293     function setCMO(address _newCMO) external onlyCEO {
294         require(_newCMO != address(0));
295         cmoAddress = _newCMO;
296     }
297 
298     function setCSO(address _newCSO) external onlyCEO {
299         require(_newCSO != address(0));
300         csoAddress = _newCSO;
301     }
302 
303     function setShopModerator(address _moderator) external onlyCEO {
304       require(_moderator != address(0));
305       shopModerators[_moderator] = true;
306     }
307 
308     function removeShopModerator(address _moderator) external onlyCEO {
309       shopModerators[_moderator] = false;
310     }
311 
312     function setTellerModerator(address _moderator) external onlyCEO {
313       require(_moderator != address(0));
314       tellerModerators[_moderator] = true;
315     }
316 
317     function removeTellerModerator(address _moderator) external onlyCEO {
318       tellerModerators[_moderator] = false;
319     }
320     /*** Pausable functionality adapted from OpenZeppelin ***/
321 
322     /// @dev Modifier to allow actions only when the contract IS NOT paused
323     modifier whenNotPaused() {
324         require(!paused);
325         _;
326     }
327 
328     /// @dev Modifier to allow actions only when the contract IS paused
329     modifier whenPaused {
330         require(paused);
331         _;
332     }
333 
334     /// @dev Called by any "C-level" role to pause the contract. Used only when
335     ///  a bug or exploit is detected and we need to limit damage.
336     function pause() external onlyCEO whenNotPaused {
337         paused = true;
338     }
339 
340     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
341     ///  one reason we may pause the contract is when CMO account are
342     ///  compromised.
343     /// @notice This is public rather than external so it can be called by
344     ///  derived contracts.
345     function unpause() public onlyCEO whenPaused {
346         // can't unpause if contract was upgraded
347         paused = false;
348     }
349 }
350 
351 contract DetherSetup is DetherAccessControl  {
352 
353   bool public run1 = false;
354   bool public run2 = false;
355   // -Need to be whitelisted to be able to register in the contract as a shop or
356   // teller, there is two level of identification.
357   // -This identification method are now centralised and processed by dether, but
358   // will be decentralised soon
359   Certifier public smsCertifier;
360   Certifier public kycCertifier;
361   // Zone need to be open by the CMO before accepting registration
362   // The bytes2 parameter wait for a country ID (ex: FR (0x4652 in hex) for france cf:README)
363   mapping(bytes2 => bool) public openedCountryShop;
364   mapping(bytes2 => bool) public openedCountryTeller;
365   // For registering in a zone you need to stake DTH
366   // The price can differ by country
367   // Uts now a fixed price by the CMO but the price will adjusted automatically
368   // regarding different factor in the futur smart contract
369   mapping(bytes2 => uint) public licenceShop;
370   mapping(bytes2 => uint) public licenceTeller;
371 
372   modifier tier1(address _user) {
373     require(smsCertifier.certified(_user));
374     _;
375   }
376   modifier tier2(address _user) {
377     require(kycCertifier.certified(_user));
378     _;
379   }
380   modifier isZoneShopOpen(bytes2 _country) {
381     require(openedCountryShop[_country]);
382     _;
383   }
384   modifier isZoneTellerOpen(bytes2 _country) {
385     require(openedCountryTeller[_country]);
386     _;
387   }
388 
389   /**
390    * INIT
391    */
392   function setSmsCertifier (address _smsCertifier) external onlyCEO {
393     require(!run1);
394     smsCertifier = Certifier(_smsCertifier);
395     run1 = true;
396   }
397   /**
398    * CORE FUNCTION
399    */
400   function setKycCertifier (address _kycCertifier) external onlyCEO {
401     require(!run2);
402     kycCertifier = Certifier(_kycCertifier);
403     run2 = true;
404   }
405   function setLicenceShopPrice(bytes2 country, uint price) external onlyCMO {
406     licenceShop[country] = price;
407   }
408   function setLicenceTellerPrice(bytes2 country, uint price) external onlyCMO {
409     licenceTeller[country] = price;
410   }
411   function openZoneShop(bytes2 _country) external onlyCMO {
412     openedCountryShop[_country] = true;
413   }
414   function closeZoneShop(bytes2 _country) external onlyCMO {
415     openedCountryShop[_country] = false;
416   }
417   function openZoneTeller(bytes2 _country) external onlyCMO {
418     openedCountryTeller[_country] = true;
419   }
420   function closeZoneTeller(bytes2 _country) external onlyCMO {
421     openedCountryTeller[_country] = false;
422   }
423 }
424 
425 
426 
427 library BytesLib {
428     function concat(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bytes) {
429         bytes memory tempBytes;
430 
431         assembly {
432             // Get a location of some free memory and store it in tempBytes as
433             // Solidity does for memory variables.
434             tempBytes := mload(0x40)
435 
436             // Store the length of the first bytes array at the beginning of
437             // the memory for tempBytes.
438             let length := mload(_preBytes)
439             mstore(tempBytes, length)
440 
441             // Maintain a memory counter for the current write location in the
442             // temp bytes array by adding the 32 bytes for the array length to
443             // the starting location.
444             let mc := add(tempBytes, 0x20)
445             // Stop copying when the memory counter reaches the length of the
446             // first bytes array.
447             let end := add(mc, length)
448 
449             for {
450                 // Initialize a copy counter to the start of the _preBytes data,
451                 // 32 bytes into its memory.
452                 let cc := add(_preBytes, 0x20)
453             } lt(mc, end) {
454                 // Increase both counters by 32 bytes each iteration.
455                 mc := add(mc, 0x20)
456                 cc := add(cc, 0x20)
457             } {
458                 // Write the _preBytes data into the tempBytes memory 32 bytes
459                 // at a time.
460                 mstore(mc, mload(cc))
461             }
462 
463             // Add the length of _postBytes to the current length of tempBytes
464             // and store it as the new length in the first 32 bytes of the
465             // tempBytes memory.
466             length := mload(_postBytes)
467             mstore(tempBytes, add(length, mload(tempBytes)))
468 
469             // Move the memory counter back from a multiple of 0x20 to the
470             // actual end of the _preBytes data.
471             mc := end
472             // Stop copying when the memory counter reaches the new combined
473             // length of the arrays.
474             end := add(mc, length)
475 
476             for {
477                 let cc := add(_postBytes, 0x20)
478             } lt(mc, end) {
479                 mc := add(mc, 0x20)
480                 cc := add(cc, 0x20)
481             } {
482                 mstore(mc, mload(cc))
483             }
484 
485             // Update the free-memory pointer by padding our last write location
486             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
487             // next 32 byte block, then round down to the nearest multiple of
488             // 32. If the sum of the length of the two arrays is zero then add
489             // one before rounding down to leave a blank 32 bytes (the length block with 0).
490             mstore(0x40, and(
491               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
492               not(31) // Round down to the nearest 32 bytes.
493             ))
494         }
495 
496         return tempBytes;
497     }
498 
499     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
500         assembly {
501             // Read the first 32 bytes of _preBytes storage, which is the length
502             // of the array. (We don't need to use the offset into the slot
503             // because arrays use the entire slot.)
504             let fslot := sload(_preBytes_slot)
505             // Arrays of 31 bytes or less have an even value in their slot,
506             // while longer arrays have an odd value. The actual length is
507             // the slot divided by two for odd values, and the lowest order
508             // byte divided by two for even values.
509             // If the slot is even, bitwise and the slot with 255 and divide by
510             // two to get the length. If the slot is odd, bitwise and the slot
511             // with -1 and divide by two.
512             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
513             let mlength := mload(_postBytes)
514             let newlength := add(slength, mlength)
515             // slength can contain both the length and contents of the array
516             // if length < 32 bytes so let's prepare for that
517             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
518             switch add(lt(slength, 32), lt(newlength, 32))
519             case 2 {
520                 // Since the new array still fits in the slot, we just need to
521                 // update the contents of the slot.
522                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
523                 sstore(
524                     _preBytes_slot,
525                     // all the modifications to the slot are inside this
526                     // next block
527                     add(
528                         // we can just add to the slot contents because the
529                         // bytes we want to change are the LSBs
530                         fslot,
531                         add(
532                             mul(
533                                 div(
534                                     // load the bytes from memory
535                                     mload(add(_postBytes, 0x20)),
536                                     // zero all bytes to the right
537                                     exp(0x100, sub(32, mlength))
538                                 ),
539                                 // and now shift left the number of bytes to
540                                 // leave space for the length in the slot
541                                 exp(0x100, sub(32, newlength))
542                             ),
543                             // increase length by the double of the memory
544                             // bytes length
545                             mul(mlength, 2)
546                         )
547                     )
548                 )
549             }
550             case 1 {
551                 // The stored value fits in the slot, but the combined value
552                 // will exceed it.
553                 // get the keccak hash to get the contents of the array
554                 mstore(0x0, _preBytes_slot)
555                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
556 
557                 // save new length
558                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
559 
560                 // The contents of the _postBytes array start 32 bytes into
561                 // the structure. Our first read should obtain the `submod`
562                 // bytes that can fit into the unused space in the last word
563                 // of the stored array. To get this, we read 32 bytes starting
564                 // from `submod`, so the data we read overlaps with the array
565                 // contents by `submod` bytes. Masking the lowest-order
566                 // `submod` bytes allows us to add that value directly to the
567                 // stored value.
568 
569                 let submod := sub(32, slength)
570                 let mc := add(_postBytes, submod)
571                 let end := add(_postBytes, mlength)
572                 let mask := sub(exp(0x100, submod), 1)
573 
574                 sstore(
575                     sc,
576                     add(
577                         and(
578                             fslot,
579                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
580                         ),
581                         and(mload(mc), mask)
582                     )
583                 )
584 
585                 for {
586                     mc := add(mc, 0x20)
587                     sc := add(sc, 1)
588                 } lt(mc, end) {
589                     sc := add(sc, 1)
590                     mc := add(mc, 0x20)
591                 } {
592                     sstore(sc, mload(mc))
593                 }
594 
595                 mask := exp(0x100, sub(mc, end))
596 
597                 sstore(sc, mul(div(mload(mc), mask), mask))
598             }
599             default {
600                 // get the keccak hash to get the contents of the array
601                 mstore(0x0, _preBytes_slot)
602                 // Start copying to the last used word of the stored array.
603                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
604 
605                 // save new length
606                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
607 
608                 // Copy over the first `submod` bytes of the new data as in
609                 // case 1 above.
610                 let slengthmod := mod(slength, 32)
611                 let mlengthmod := mod(mlength, 32)
612                 let submod := sub(32, slengthmod)
613                 let mc := add(_postBytes, submod)
614                 let end := add(_postBytes, mlength)
615                 let mask := sub(exp(0x100, submod), 1)
616 
617                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
618 
619                 for {
620                     sc := add(sc, 1)
621                     mc := add(mc, 0x20)
622                 } lt(mc, end) {
623                     sc := add(sc, 1)
624                     mc := add(mc, 0x20)
625                 } {
626                     sstore(sc, mload(mc))
627                 }
628 
629                 mask := exp(0x100, sub(mc, end))
630 
631                 sstore(sc, mul(div(mload(mc), mask), mask))
632             }
633         }
634     }
635 
636     function slice(bytes _bytes, uint _start, uint _length) internal  pure returns (bytes) {
637         require(_bytes.length >= (_start + _length));
638 
639         bytes memory tempBytes;
640 
641         assembly {
642             switch iszero(_length)
643             case 0 {
644                 // Get a location of some free memory and store it in tempBytes as
645                 // Solidity does for memory variables.
646                 tempBytes := mload(0x40)
647 
648                 // The first word of the slice result is potentially a partial
649                 // word read from the original array. To read it, we calculate
650                 // the length of that partial word and start copying that many
651                 // bytes into the array. The first word we copy will start with
652                 // data we don't care about, but the last `lengthmod` bytes will
653                 // land at the beginning of the contents of the new array. When
654                 // we're done copying, we overwrite the full first word with
655                 // the actual length of the slice.
656                 let lengthmod := and(_length, 31)
657 
658                 // The multiplication in the next line is necessary
659                 // because when slicing multiples of 32 bytes (lengthmod == 0)
660                 // the following copy loop was copying the origin's length
661                 // and then ending prematurely not copying everything it should.
662                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
663                 let end := add(mc, _length)
664 
665                 for {
666                     // The multiplication in the next line has the same exact purpose
667                     // as the one above.
668                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
669                 } lt(mc, end) {
670                     mc := add(mc, 0x20)
671                     cc := add(cc, 0x20)
672                 } {
673                     mstore(mc, mload(cc))
674                 }
675 
676                 mstore(tempBytes, _length)
677 
678                 //update free-memory pointer
679                 //allocating the array padded to 32 bytes like the compiler does now
680                 mstore(0x40, and(add(mc, 31), not(31)))
681             }
682             //if we want a zero-length slice let's just return a zero-length array
683             default {
684                 tempBytes := mload(0x40)
685 
686                 mstore(0x40, add(tempBytes, 0x20))
687             }
688         }
689 
690         return tempBytes;
691     }
692 
693     function toAddress(bytes _bytes, uint _start) internal  pure returns (address) {
694         require(_bytes.length >= (_start + 20));
695         address tempAddress;
696 
697         assembly {
698             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
699         }
700 
701         return tempAddress;
702     }
703 
704     function toUint(bytes _bytes, uint _start) internal  pure returns (uint256) {
705         require(_bytes.length >= (_start + 32));
706         uint256 tempUint;
707 
708         assembly {
709             tempUint := mload(add(add(_bytes, 0x20), _start))
710         }
711 
712         return tempUint;
713     }
714 
715     function toBytes32(bytes _bytes, uint _start) internal  pure returns (bytes32) {
716         require(_bytes.length >= (_start + 32));
717         bytes32 tempBytes32;
718 
719         assembly {
720             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
721         }
722 
723         return tempBytes32;
724     }
725 
726     function toBytes16(bytes _bytes, uint _start) internal  pure returns (bytes16) {
727         require(_bytes.length >= (_start + 16));
728         bytes16 tempBytes16;
729 
730         assembly {
731             tempBytes16 := mload(add(add(_bytes, 0x20), _start))
732         }
733 
734         return tempBytes16;
735     }
736 
737     function toBytes2(bytes _bytes, uint _start) internal  pure returns (bytes2) {
738         require(_bytes.length >= (_start + 2));
739         bytes2 tempBytes2;
740 
741         assembly {
742             tempBytes2 := mload(add(add(_bytes, 0x20), _start))
743         }
744 
745         return tempBytes2;
746     }
747 
748     function toBytes4(bytes _bytes, uint _start) internal  pure returns (bytes4) {
749         require(_bytes.length >= (_start + 4));
750         bytes4 tempBytes4;
751 
752         assembly {
753             tempBytes4 := mload(add(add(_bytes, 0x20), _start))
754         }
755         return tempBytes4;
756     }
757 
758     function toBytes1(bytes _bytes, uint _start) internal  pure returns (bytes1) {
759         require(_bytes.length >= (_start + 1));
760         bytes1 tempBytes1;
761 
762         assembly {
763             tempBytes1 := mload(add(add(_bytes, 0x20), _start))
764         }
765 
766         return tempBytes1;
767     }
768 
769     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
770         bool success = true;
771 
772         assembly {
773             let length := mload(_preBytes)
774 
775             // if lengths don't match the arrays are not equal
776             switch eq(length, mload(_postBytes))
777             case 1 {
778                 // cb is a circuit breaker in the for loop since there's
779                 //  no said feature for inline assembly loops
780                 // cb = 1 - don't breaker
781                 // cb = 0 - break
782                 let cb := 1
783 
784                 let mc := add(_preBytes, 0x20)
785                 let end := add(mc, length)
786 
787                 for {
788                     let cc := add(_postBytes, 0x20)
789                 // the next line is the loop condition:
790                 // while(uint(mc < end) + cb == 2)
791                 } eq(add(lt(mc, end), cb), 2) {
792                     mc := add(mc, 0x20)
793                     cc := add(cc, 0x20)
794                 } {
795                     // if any of these checks fails then arrays are not equal
796                     if iszero(eq(mload(mc), mload(cc))) {
797                         // unsuccess:
798                         success := 0
799                         cb := 0
800                     }
801                 }
802             }
803             default {
804                 // unsuccess:
805                 success := 0
806             }
807         }
808 
809         return success;
810     }
811 
812     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
813         bool success = true;
814 
815         assembly {
816             // we know _preBytes_offset is 0
817             let fslot := sload(_preBytes_slot)
818             // Decode the length of the stored array like in concatStorage().
819             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
820             let mlength := mload(_postBytes)
821 
822             // if lengths don't match the arrays are not equal
823             switch eq(slength, mlength)
824             case 1 {
825                 // slength can contain both the length and contents of the array
826                 // if length < 32 bytes so let's prepare for that
827                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
828                 if iszero(iszero(slength)) {
829                     switch lt(slength, 32)
830                     case 1 {
831                         // blank the last byte which is the length
832                         fslot := mul(div(fslot, 0x100), 0x100)
833 
834                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
835                             // unsuccess:
836                             success := 0
837                         }
838                     }
839                     default {
840                         // cb is a circuit breaker in the for loop since there's
841                         //  no said feature for inline assembly loops
842                         // cb = 1 - don't breaker
843                         // cb = 0 - break
844                         let cb := 1
845 
846                         // get the keccak hash to get the contents of the array
847                         mstore(0x0, _preBytes_slot)
848                         let sc := keccak256(0x0, 0x20)
849 
850                         let mc := add(_postBytes, 0x20)
851                         let end := add(mc, mlength)
852 
853                         // the next line is the loop condition:
854                         // while(uint(mc < end) + cb == 2)
855                         for {} eq(add(lt(mc, end), cb), 2) {
856                             sc := add(sc, 1)
857                             mc := add(mc, 0x20)
858                         } {
859                             if iszero(eq(sload(sc), mload(mc))) {
860                                 // unsuccess:
861                                 success := 0
862                                 cb := 0
863                             }
864                         }
865                     }
866                 }
867             }
868             default {
869                 // unsuccess:
870                 success := 0
871             }
872         }
873 
874         return success;
875     }
876 }
877 
878 
879 contract DetherCore is DetherSetup, ERC223ReceivingContract, SafeMath {
880   using BytesLib for bytes;
881 
882   /**
883   * Event
884   */
885   // when a Teller is registered
886   event RegisterTeller(address indexed tellerAddress);
887   // when a teller is deleted
888   event DeleteTeller(address indexed tellerAddress);
889   // when teller update
890   event UpdateTeller(address indexed tellerAddress);
891   // when a teller send to a buyer
892   event Sent(address indexed _from, address indexed _to, uint amount);
893   // when a shop register
894   event RegisterShop(address shopAddress);
895   // when a shop delete
896   event DeleteShop(address shopAddress);
897   // when a moderator delete a shop
898   event DeleteShopModerator(address indexed moderator, address shopAddress);
899   // when a moderator delete a teller
900   event DeleteTellerModerator(address indexed moderator, address tellerAddress);
901 
902   /**
903    * Modifier
904    */
905   // if teller has staked enough dth to
906   modifier tellerHasStaked(uint amount) {
907     require(bank.getDthTeller(msg.sender) >= amount);
908     _;
909   }
910   // if shop has staked enough dth to
911   modifier shopHasStaked(uint amount) {
912     require(bank.getDthShop(msg.sender) >= amount);
913     _;
914   }
915 
916   /*
917    * External contract
918    */
919   // DTH contract
920   ERC223Basic public dth;
921   // bank contract where are stored ETH and DTH
922   DetherBank public bank;
923 
924   // teller struct
925   struct Teller {
926     int32 lat;            // Latitude
927     int32 lng;            // Longitude
928     bytes2 countryId;     // countryID (in hexa), ISO ALPHA 2 https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
929     bytes16 postalCode;   // postalCode if present, in Hexa https://en.wikipedia.org/wiki/List_of_postal_codes
930 
931     int8 currencyId;      // 1 - 100 , cf README
932     bytes16 messenger;    // telegrame nickname
933     int8 avatarId;        // 1 - 100 , regarding the front-end app you use
934     int16 rates;          // margin of tellers , -999 - +9999 , corresponding to -99,9% x 10  , 999,9% x 10
935 
936     uint zoneIndex;       // index of the zone mapping
937     uint generalIndex;    // index of general mapping
938     bool online;          // switch online/offline, if the tellers want to be inactive without deleting his point
939   }
940 
941   /*
942    * Reputation field V0.1
943    * Reputation is based on volume sell, volume buy, and number of transaction
944    */
945   mapping(address => uint) volumeBuy;
946   mapping(address => uint) volumeSell;
947   mapping(address => uint) nbTrade;
948 
949   // general mapping of teller
950   mapping(address => Teller) teller;
951   // mappoing of teller by COUNTRYCODE => POSTALCODE
952   mapping(bytes2 => mapping(bytes16 => address[])) tellerInZone;
953   // teller array currently registered
954   address[] public tellerIndex; // unordered list of teller register on it
955   bool isStarted = false;
956   // shop struct
957   struct Shop {
958     int32 lat;            // latitude
959     int32 lng;            // longitude
960     bytes2 countryId;     // countryID (in hexa char), ISO ALPHA 2 https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
961     bytes16 postalCode;   // postalCode if present (in hexa char), in Hexa https://en.wikipedia.org/wiki/List_of_postal_codes
962     bytes16 cat;          // Category of the shop (in hex char), will be used later for search engine and auction by zone
963     bytes16 name;         // name of the shop (in hex char)
964     bytes32 description;  // description of the shop
965     bytes16 opening;      // opening hours, cf README for the format
966 
967     uint zoneIndex;       // index of the zone mapping
968     uint generalIndex;    // index of general mapping
969     bool detherShop;      // bool if shop is registered by dether as business partnership (still required DTH)
970   }
971 
972   // general mapping of shop
973   mapping(address => Shop) shop;
974   // mapping of teller by COUNTRYCODE => POSTALCODE
975   mapping(bytes2 => mapping(bytes16 => address[])) shopInZone;
976   // shop array currently registered
977   address[] public shopIndex; // unordered list of shop register on it
978 
979   /*
980    * Instanciation
981    */
982   function DetherCore() {
983    ceoAddress = msg.sender;
984   }
985   function initContract (address _dth, address _bank) external onlyCEO {
986     require(!isStarted);
987     dth = ERC223Basic(_dth);
988     bank = DetherBank(_bank);
989     isStarted = true;
990   }
991 
992   /**
993    * Core fonction
994    */
995 
996   /**
997    * @dev Standard ERC223 function that will handle incoming token transfers.
998    * This is the main function to register SHOP or TELLER, its calling when you
999    * send token to the DTH contract and by passing data as bytes on the third
1000    * parameter.
1001    * Its not supposed to be use on its own but will only handle incoming DTH
1002    * transaction.
1003    * The _data will wait for
1004    * [1st byte] 1 (0x31) for shop OR 2 (0x32) for teller
1005    * FOR SHOP AND TELLER:
1006    * 2sd to 5th bytes lat
1007    * 6th to 9th bytes lng
1008    * ...
1009    * Modifier tier1: Check if address is whitelisted with the sms verification
1010    */
1011   function tokenFallback(address _from, uint _value, bytes _data) whenNotPaused tier1(_from ) {
1012     // require than the token fallback is triggered from the dth token contract
1013     require(msg.sender == address(dth));
1014     // check first byte to know if its shop or teller registration
1015     // 1 / 0x31 = shop // 2 / 0x32 = teller
1016     bytes1 _func = _data.toBytes1(0);
1017     int32 posLat = _data.toBytes1(1) == bytes1(0x01) ? int32(_data.toBytes4(2)) * -1 : int32(_data.toBytes4(2));
1018     int32 posLng = _data.toBytes1(6) == bytes1(0x01) ? int32(_data.toBytes4(7)) * -1 : int32(_data.toBytes4(7));
1019     if (_func == bytes1(0x31)) { // shop registration
1020       // require staked greater than licence price
1021       require(_value >= licenceShop[_data.toBytes2(11)]);
1022       // require its not already shop
1023       require(!isShop(_from));
1024       // require zone is open
1025       require(openedCountryShop[_data.toBytes2(11)]);
1026 
1027       shop[_from].lat = posLat;
1028       shop[_from].lng = posLng;
1029       shop[_from].countryId = _data.toBytes2(11);
1030       shop[_from].postalCode = _data.toBytes16(13);
1031       shop[_from].cat = _data.toBytes16(29);
1032       shop[_from].name = _data.toBytes16(45);
1033       shop[_from].description = _data.toBytes32(61);
1034       shop[_from].opening = _data.toBytes16(93);
1035       shop[_from].generalIndex = shopIndex.push(_from) - 1;
1036       shop[_from].zoneIndex = shopInZone[_data.toBytes2(11)][_data.toBytes16(13)].push(_from) - 1;
1037       emit RegisterShop(_from);
1038       bank.addTokenShop(_from,_value);
1039       dth.transfer(address(bank), _value);
1040     } else if (_func == bytes1(0x32)) { // teller registration
1041       // require staked greater than licence price
1042       require(_value >= licenceTeller[_data.toBytes2(11)]);
1043       // require is not already a teller
1044       require(!isTeller(_from));
1045       // require zone is open
1046       require(openedCountryTeller[_data.toBytes2(11)]);
1047 
1048       teller[_from].lat = posLat;
1049       teller[_from].lng = posLng;
1050       teller[_from].countryId = _data.toBytes2(11);
1051       teller[_from].postalCode = _data.toBytes16(13);
1052       teller[_from].avatarId = int8(_data.toBytes1(29));
1053       teller[_from].currencyId = int8(_data.toBytes1(30));
1054       teller[_from].messenger = _data.toBytes16(31);
1055       teller[_from].rates = int16(_data.toBytes2(47));
1056       teller[_from].generalIndex = tellerIndex.push(_from) - 1;
1057       teller[_from].zoneIndex = tellerInZone[_data.toBytes2(11)][_data.toBytes16(13)].push(_from) - 1;
1058       teller[_from].online = true;
1059       emit RegisterTeller(_from);
1060       bank.addTokenTeller(_from, _value);
1061       dth.transfer(address(bank), _value);
1062     } else if (_func == bytes1(0x33)) {  // shop bulk registration
1063       // We need to have the possibility to register in bulk some shop
1064       // For big retailer company willing to be listed on dether, we need to have a way to add
1065       // all their shop from one address
1066       // This functionnality will become available for anyone willing to list multiple shop
1067       // in the futures contract
1068 
1069       // Only the CSO should be able to register shop in bulk
1070       require(_from == csoAddress);
1071       // Each shop still need his own staking
1072       require(_value >= licenceShop[_data.toBytes2(11)]);
1073       // require the addresses not already registered
1074       require(!isShop(address(_data.toAddress(109))));
1075       // require zone is open
1076       require(openedCountryShop[_data.toBytes2(11)]);
1077       address newShopAddress = _data.toAddress(109);
1078       shop[newShopAddress].lat = posLat;
1079       shop[newShopAddress].lng = posLng;
1080       shop[newShopAddress].countryId = _data.toBytes2(11);
1081       shop[newShopAddress].postalCode = _data.toBytes16(13);
1082       shop[newShopAddress].cat = _data.toBytes16(29);
1083       shop[newShopAddress].name = _data.toBytes16(45);
1084       shop[newShopAddress].description = _data.toBytes32(61);
1085       shop[newShopAddress].opening = _data.toBytes16(93);
1086       shop[newShopAddress].generalIndex = shopIndex.push(newShopAddress) - 1;
1087       shop[newShopAddress].zoneIndex = shopInZone[_data.toBytes2(11)][_data.toBytes16(13)].push(newShopAddress) - 1;
1088       shop[newShopAddress].detherShop = true;
1089       emit RegisterShop(newShopAddress);
1090       bank.addTokenShop(newShopAddress, _value);
1091       dth.transfer(address(bank), _value);
1092     }
1093   }
1094 
1095   /**
1096    * a teller can update his profile
1097    * If a teller want to change his location, he would need to delete and recreate
1098    * a new point
1099    */
1100   function updateTeller(
1101     int8 currencyId,
1102     bytes16 messenger,
1103     int8 avatarId,
1104     int16 rates,
1105     bool online
1106    ) public payable {
1107     require(isTeller(msg.sender));
1108     if (currencyId != teller[msg.sender].currencyId)
1109     teller[msg.sender].currencyId = currencyId;
1110     if (teller[msg.sender].messenger != messenger)
1111      teller[msg.sender].messenger = messenger;
1112     if (teller[msg.sender].avatarId != avatarId)
1113      teller[msg.sender].avatarId = avatarId;
1114     if (teller[msg.sender].rates != rates)
1115      teller[msg.sender].rates = rates;
1116     if (teller[msg.sender].online != online)
1117       teller[msg.sender].online = online;
1118     if (msg.value > 0) {
1119       bank.addEthTeller.value(msg.value)(msg.sender, msg.value);
1120     }
1121     emit UpdateTeller(msg.sender);
1122   }
1123 
1124   /**
1125    * SellEth
1126    * @param _to -> the address for the receiver
1127    * @param _amount -> the amount to send
1128    */
1129   function sellEth(address _to, uint _amount) whenNotPaused external {
1130     require(isTeller(msg.sender));
1131     require(_to != msg.sender);
1132     // send eth to the receiver from the bank contract
1133     bank.withdrawEth(msg.sender, _to, _amount);
1134     // increase reput for the buyer and the seller Only if the buyer is also whitelisted,
1135     // It's a way to incentive user to trade on the system
1136     if (smsCertifier.certified(_to)) {
1137       volumeBuy[_to] = SafeMath.add(volumeBuy[_to], _amount);
1138       volumeSell[msg.sender] = SafeMath.add(volumeSell[msg.sender], _amount);
1139       nbTrade[msg.sender] += 1;
1140     }
1141     emit Sent(msg.sender, _to, _amount);
1142   }
1143 
1144   /**
1145    * switchStatus
1146    * Turn status teller on/off
1147    */
1148   function switchStatus(bool _status) external {
1149     if (teller[msg.sender].online != _status)
1150      teller[msg.sender].online = _status;
1151   }
1152 
1153   /**
1154    * addFunds
1155    * teller can add more funds on his sellpoint
1156    */
1157   function addFunds() external payable {
1158     require(isTeller(msg.sender));
1159     require(bank.addEthTeller.value(msg.value)(msg.sender, msg.value));
1160   }
1161 
1162   // gas used 67841
1163   // a teller can delete a sellpoint
1164   function deleteTeller() external {
1165     require(isTeller(msg.sender));
1166     uint rowToDelete1 = teller[msg.sender].zoneIndex;
1167     address keyToMove1 = tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode][tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode].length - 1];
1168     tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode][rowToDelete1] = keyToMove1;
1169     teller[keyToMove1].zoneIndex = rowToDelete1;
1170     tellerInZone[teller[msg.sender].countryId][teller[msg.sender].postalCode].length--;
1171 
1172     uint rowToDelete2 = teller[msg.sender].generalIndex;
1173     address keyToMove2 = tellerIndex[tellerIndex.length - 1];
1174     tellerIndex[rowToDelete2] = keyToMove2;
1175     teller[keyToMove2].generalIndex = rowToDelete2;
1176     tellerIndex.length--;
1177     delete teller[msg.sender];
1178     bank.withdrawDthTeller(msg.sender);
1179     bank.refundEth(msg.sender);
1180     emit DeleteTeller(msg.sender);
1181   }
1182 
1183   // gas used 67841
1184   // A moderator can delete a sellpoint
1185   function deleteTellerMods(address _toDelete) isTellerModerator(msg.sender) external {
1186     uint rowToDelete1 = teller[_toDelete].zoneIndex;
1187     address keyToMove1 = tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode][tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode].length - 1];
1188     tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode][rowToDelete1] = keyToMove1;
1189     teller[keyToMove1].zoneIndex = rowToDelete1;
1190     tellerInZone[teller[_toDelete].countryId][teller[_toDelete].postalCode].length--;
1191 
1192     uint rowToDelete2 = teller[_toDelete].generalIndex;
1193     address keyToMove2 = tellerIndex[tellerIndex.length - 1];
1194     tellerIndex[rowToDelete2] = keyToMove2;
1195     teller[keyToMove2].generalIndex = rowToDelete2;
1196     tellerIndex.length--;
1197     delete teller[_toDelete];
1198     bank.withdrawDthTeller(_toDelete);
1199     bank.refundEth(_toDelete);
1200     emit DeleteTellerModerator(msg.sender, _toDelete);
1201   }
1202 
1203   // gas used 67841
1204   // A shop owner can delete his point.
1205   function deleteShop() external {
1206     require(isShop(msg.sender));
1207     uint rowToDelete1 = shop[msg.sender].zoneIndex;
1208     address keyToMove1 = shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode][shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode].length - 1];
1209     shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode][rowToDelete1] = keyToMove1;
1210     shop[keyToMove1].zoneIndex = rowToDelete1;
1211     shopInZone[shop[msg.sender].countryId][shop[msg.sender].postalCode].length--;
1212 
1213     uint rowToDelete2 = shop[msg.sender].generalIndex;
1214     address keyToMove2 = shopIndex[shopIndex.length - 1];
1215     shopIndex[rowToDelete2] = keyToMove2;
1216     shop[keyToMove2].generalIndex = rowToDelete2;
1217     shopIndex.length--;
1218     delete shop[msg.sender];
1219     bank.withdrawDthShop(msg.sender);
1220     emit DeleteShop(msg.sender);
1221   }
1222 
1223   // gas used 67841
1224   // Moderator can delete a shop point
1225   function deleteShopMods(address _toDelete) isShopModerator(msg.sender) external {
1226     uint rowToDelete1 = shop[_toDelete].zoneIndex;
1227     address keyToMove1 = shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode][shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode].length - 1];
1228     shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode][rowToDelete1] = keyToMove1;
1229     shop[keyToMove1].zoneIndex = rowToDelete1;
1230     shopInZone[shop[_toDelete].countryId][shop[_toDelete].postalCode].length--;
1231 
1232     uint rowToDelete2 = shop[_toDelete].generalIndex;
1233     address keyToMove2 = shopIndex[shopIndex.length - 1];
1234     shopIndex[rowToDelete2] = keyToMove2;
1235     shop[keyToMove2].generalIndex = rowToDelete2;
1236     shopIndex.length--;
1237     if (!shop[_toDelete].detherShop)
1238       bank.withdrawDthShop(_toDelete);
1239     else
1240       bank.withdrawDthShopAdmin(_toDelete, csoAddress);
1241     delete shop[_toDelete];
1242     emit DeleteShopModerator(msg.sender, _toDelete);
1243   }
1244 
1245   /**
1246    *  GETTER
1247    */
1248 
1249   // get teller
1250   // return teller info
1251   function getTeller(address _teller) public view returns (
1252     int32 lat,
1253     int32 lng,
1254     bytes2 countryId,
1255     bytes16 postalCode,
1256     int8 currencyId,
1257     bytes16 messenger,
1258     int8 avatarId,
1259     int16 rates,
1260     uint balance,
1261     bool online,
1262     uint sellVolume,
1263     uint numTrade
1264     ) {
1265     Teller storage theTeller = teller[_teller];
1266     lat = theTeller.lat;
1267     lng = theTeller.lng;
1268     countryId = theTeller.countryId;
1269     postalCode = theTeller.postalCode;
1270     currencyId = theTeller.currencyId;
1271     messenger = theTeller.messenger;
1272     avatarId = theTeller.avatarId;
1273     rates = theTeller.rates;
1274     online = theTeller.online;
1275     sellVolume = volumeSell[_teller];
1276     numTrade = nbTrade[_teller];
1277     balance = bank.getEthBalTeller(_teller);
1278   }
1279 
1280   /*
1281    * Shop ----------------------------------
1282    * return Shop value
1283    */
1284   function getShop(address _shop) public view returns (
1285    int32 lat,
1286    int32 lng,
1287    bytes2 countryId,
1288    bytes16 postalCode,
1289    bytes16 cat,
1290    bytes16 name,
1291    bytes32 description,
1292    bytes16 opening
1293    ) {
1294     Shop storage theShop = shop[_shop];
1295     lat = theShop.lat;
1296     lng = theShop.lng;
1297     countryId = theShop.countryId;
1298     postalCode = theShop.postalCode;
1299     cat = theShop.cat;
1300     name = theShop.name;
1301     description = theShop.description;
1302     opening = theShop.opening;
1303    }
1304 
1305    // get reput
1306    // return reputation data from teller
1307   function getReput(address _teller) public view returns (
1308    uint buyVolume,
1309    uint sellVolume,
1310    uint numTrade
1311    ) {
1312      buyVolume = volumeBuy[_teller];
1313      sellVolume = volumeSell[_teller];
1314      numTrade = nbTrade[_teller];
1315   }
1316   // return balance of teller put in escrow
1317   function getTellerBalance(address _teller) public view returns (uint) {
1318     return bank.getEthBalTeller(_teller);
1319   }
1320 
1321   // return an array of address of all zone present on a zone
1322   // zone is a mapping COUNTRY => POSTALCODE
1323   function getZoneShop(bytes2 _country, bytes16 _postalcode) public view returns (address[]) {
1324      return shopInZone[_country][_postalcode];
1325   }
1326 
1327   // return array of address of all shop
1328   function getAllShops() public view returns (address[]) {
1329    return shopIndex;
1330   }
1331 
1332   function isShop(address _shop) public view returns (bool ){
1333    return (shop[_shop].countryId != bytes2(0x0));
1334   }
1335 
1336   // return an array of address of all teller present on a zone
1337   // zone is a mapping COUNTRY => POSTALCODE
1338   function getZoneTeller(bytes2 _country, bytes16 _postalcode) public view returns (address[]) {
1339      return tellerInZone[_country][_postalcode];
1340   }
1341 
1342   // return array of address of all teller
1343   function getAllTellers() public view returns (address[]) {
1344    return tellerIndex;
1345   }
1346 
1347   // return if teller or not
1348   function isTeller(address _teller) public view returns (bool ){
1349     return (teller[_teller].countryId != bytes2(0x0));
1350   }
1351 
1352   /*
1353    * misc
1354    */
1355    // return info about how much DTH the shop has staked
1356   function getStakedShop(address _shop) public view returns (uint) {
1357     return bank.getDthShop(_shop);
1358   }
1359   // return info about how much DTH the teller has staked
1360   function getStakedTeller(address _teller) public view returns (uint) {
1361     return bank.getDthTeller(_teller);
1362   }
1363   // give ownership to the bank contract
1364   function transferBankOwnership(address _newbankowner) external onlyCEO whenPaused {
1365     bank.transferOwnership(_newbankowner);
1366   }
1367 }