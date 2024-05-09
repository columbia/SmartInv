1 // File: @laborx/solidity-shared-lib/contracts/ERC20Interface.sol
2 
3 /**
4 * Copyright 2017–2018, LaborX PTY
5 * Licensed under the AGPL Version 3 license.
6 */
7 
8 pragma solidity ^0.4.23;
9 
10 
11 /// @title Defines an interface for EIP20 token smart contract
12 contract ERC20Interface {
13     
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed from, address indexed spender, uint256 value);
16 
17     string public symbol;
18 
19     function decimals() public view returns (uint8);
20     function totalSupply() public view returns (uint256 supply);
21 
22     function balanceOf(address _owner) public view returns (uint256 balance);
23     function transfer(address _to, uint256 _value) public returns (bool success);
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25     function approve(address _spender, uint256 _value) public returns (bool success);
26     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
27 }
28 
29 // File: @laborx/solidity-shared-lib/contracts/Owned.sol
30 
31 /**
32 * Copyright 2017–2018, LaborX PTY
33 * Licensed under the AGPL Version 3 license.
34 */
35 
36 pragma solidity ^0.4.23;
37 
38 
39 
40 /// @title Owned contract with safe ownership pass.
41 ///
42 /// Note: all the non constant functions return false instead of throwing in case if state change
43 /// didn't happen yet.
44 contract Owned {
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     address public contractOwner;
49     address public pendingContractOwner;
50 
51     modifier onlyContractOwner {
52         if (msg.sender == contractOwner) {
53             _;
54         }
55     }
56 
57     constructor()
58     public
59     {
60         contractOwner = msg.sender;
61     }
62 
63     /// @notice Prepares ownership pass.
64     /// Can only be called by current owner.
65     /// @param _to address of the next owner.
66     /// @return success.
67     function changeContractOwnership(address _to)
68     public
69     onlyContractOwner
70     returns (bool)
71     {
72         if (_to == 0x0) {
73             return false;
74         }
75         pendingContractOwner = _to;
76         return true;
77     }
78 
79     /// @notice Finalize ownership pass.
80     /// Can only be called by pending owner.
81     /// @return success.
82     function claimContractOwnership()
83     public
84     returns (bool)
85     {
86         if (msg.sender != pendingContractOwner) {
87             return false;
88         }
89 
90         emit OwnershipTransferred(contractOwner, pendingContractOwner);
91         contractOwner = pendingContractOwner;
92         delete pendingContractOwner;
93         return true;
94     }
95 
96     /// @notice Allows the current owner to transfer control of the contract to a newOwner.
97     /// @param newOwner The address to transfer ownership to.
98     function transferOwnership(address newOwner)
99     public
100     onlyContractOwner
101     returns (bool)
102     {
103         if (newOwner == 0x0) {
104             return false;
105         }
106 
107         emit OwnershipTransferred(contractOwner, newOwner);
108         contractOwner = newOwner;
109         delete pendingContractOwner;
110         return true;
111     }
112 
113     /// @notice Allows the current owner to transfer control of the contract to a newOwner.
114     /// @dev Backward compatibility only.
115     /// @param newOwner The address to transfer ownership to.
116     function transferContractOwnership(address newOwner)
117     public
118     returns (bool)
119     {
120         return transferOwnership(newOwner);
121     }
122 
123     /// @notice Withdraw given tokens from contract to owner.
124     /// This method is only allowed for contact owner.
125     function withdrawTokens(address[] tokens)
126     public
127     onlyContractOwner
128     {
129         address _contractOwner = contractOwner;
130         for (uint i = 0; i < tokens.length; i++) {
131             ERC20Interface token = ERC20Interface(tokens[i]);
132             uint balance = token.balanceOf(this);
133             if (balance > 0) {
134                 token.transfer(_contractOwner, balance);
135             }
136         }
137     }
138 
139     /// @notice Withdraw ether from contract to owner.
140     /// This method is only allowed for contact owner.
141     function withdrawEther()
142     public
143     onlyContractOwner
144     {
145         uint balance = address(this).balance;
146         if (balance > 0)  {
147             contractOwner.transfer(balance);
148         }
149     }
150 
151     /// @notice Transfers ether to another address.
152     /// Allowed only for contract owners.
153     /// @param _to recepient address
154     /// @param _value wei to transfer; must be less or equal to total balance on the contract
155     function transferEther(address _to, uint256 _value)
156     public
157     onlyContractOwner
158     {
159         require(_to != 0x0, "INVALID_ETHER_RECEPIENT_ADDRESS");
160         if (_value > address(this).balance) {
161             revert("INVALID_VALUE_TO_TRANSFER_ETHER");
162         }
163 
164         _to.transfer(_value);
165     }
166 }
167 
168 // File: @laborx/solidity-storage-lib/contracts/Storage.sol
169 
170 /**
171  * Copyright 2017–2018, LaborX PTY
172  * Licensed under the AGPL Version 3 license.
173  */
174 
175 pragma solidity ^0.4.23;
176 
177 
178 
179 contract Manager {
180     function isAllowed(address _actor, bytes32 _role) public view returns (bool);
181     function hasAccess(address _actor) public view returns (bool);
182 }
183 
184 
185 contract Storage is Owned {
186     struct Crate {
187         mapping(bytes32 => uint) uints;
188         mapping(bytes32 => address) addresses;
189         mapping(bytes32 => bool) bools;
190         mapping(bytes32 => int) ints;
191         mapping(bytes32 => uint8) uint8s;
192         mapping(bytes32 => bytes32) bytes32s;
193         mapping(bytes32 => AddressUInt8) addressUInt8s;
194         mapping(bytes32 => string) strings;
195     }
196 
197     struct AddressUInt8 {
198         address _address;
199         uint8 _uint8;
200     }
201 
202     mapping(bytes32 => Crate) internal crates;
203     Manager public manager;
204 
205     modifier onlyAllowed(bytes32 _role) {
206         if (!(msg.sender == address(this) || manager.isAllowed(msg.sender, _role))) {
207             revert("STORAGE_FAILED_TO_ACCESS_PROTECTED_FUNCTION");
208         }
209         _;
210     }
211 
212     function setManager(Manager _manager)
213     external
214     onlyContractOwner
215     returns (bool)
216     {
217         manager = _manager;
218         return true;
219     }
220 
221     function setUInt(bytes32 _crate, bytes32 _key, uint _value)
222     public
223     onlyAllowed(_crate)
224     {
225         _setUInt(_crate, _key, _value);
226     }
227 
228     function _setUInt(bytes32 _crate, bytes32 _key, uint _value)
229     internal
230     {
231         crates[_crate].uints[_key] = _value;
232     }
233 
234 
235     function getUInt(bytes32 _crate, bytes32 _key)
236     public
237     view
238     returns (uint)
239     {
240         return crates[_crate].uints[_key];
241     }
242 
243     function setAddress(bytes32 _crate, bytes32 _key, address _value)
244     public
245     onlyAllowed(_crate)
246     {
247         _setAddress(_crate, _key, _value);
248     }
249 
250     function _setAddress(bytes32 _crate, bytes32 _key, address _value)
251     internal
252     {
253         crates[_crate].addresses[_key] = _value;
254     }
255 
256     function getAddress(bytes32 _crate, bytes32 _key)
257     public
258     view
259     returns (address)
260     {
261         return crates[_crate].addresses[_key];
262     }
263 
264     function setBool(bytes32 _crate, bytes32 _key, bool _value)
265     public
266     onlyAllowed(_crate)
267     {
268         _setBool(_crate, _key, _value);
269     }
270 
271     function _setBool(bytes32 _crate, bytes32 _key, bool _value)
272     internal
273     {
274         crates[_crate].bools[_key] = _value;
275     }
276 
277     function getBool(bytes32 _crate, bytes32 _key)
278     public
279     view
280     returns (bool)
281     {
282         return crates[_crate].bools[_key];
283     }
284 
285     function setInt(bytes32 _crate, bytes32 _key, int _value)
286     public
287     onlyAllowed(_crate)
288     {
289         _setInt(_crate, _key, _value);
290     }
291 
292     function _setInt(bytes32 _crate, bytes32 _key, int _value)
293     internal
294     {
295         crates[_crate].ints[_key] = _value;
296     }
297 
298     function getInt(bytes32 _crate, bytes32 _key)
299     public
300     view
301     returns (int)
302     {
303         return crates[_crate].ints[_key];
304     }
305 
306     function setUInt8(bytes32 _crate, bytes32 _key, uint8 _value)
307     public
308     onlyAllowed(_crate)
309     {
310         _setUInt8(_crate, _key, _value);
311     }
312 
313     function _setUInt8(bytes32 _crate, bytes32 _key, uint8 _value)
314     internal
315     {
316         crates[_crate].uint8s[_key] = _value;
317     }
318 
319     function getUInt8(bytes32 _crate, bytes32 _key)
320     public
321     view
322     returns (uint8)
323     {
324         return crates[_crate].uint8s[_key];
325     }
326 
327     function setBytes32(bytes32 _crate, bytes32 _key, bytes32 _value)
328     public
329     onlyAllowed(_crate)
330     {
331         _setBytes32(_crate, _key, _value);
332     }
333 
334     function _setBytes32(bytes32 _crate, bytes32 _key, bytes32 _value)
335     internal
336     {
337         crates[_crate].bytes32s[_key] = _value;
338     }
339 
340     function getBytes32(bytes32 _crate, bytes32 _key)
341     public
342     view
343     returns (bytes32)
344     {
345         return crates[_crate].bytes32s[_key];
346     }
347 
348     function setAddressUInt8(bytes32 _crate, bytes32 _key, address _value, uint8 _value2)
349     public
350     onlyAllowed(_crate)
351     {
352         _setAddressUInt8(_crate, _key, _value, _value2);
353     }
354 
355     function _setAddressUInt8(bytes32 _crate, bytes32 _key, address _value, uint8 _value2)
356     internal
357     {
358         crates[_crate].addressUInt8s[_key] = AddressUInt8(_value, _value2);
359     }
360 
361     function getAddressUInt8(bytes32 _crate, bytes32 _key)
362     public
363     view
364     returns (address, uint8)
365     {
366         return (crates[_crate].addressUInt8s[_key]._address, crates[_crate].addressUInt8s[_key]._uint8);
367     }
368 
369     function setString(bytes32 _crate, bytes32 _key, string _value)
370     public
371     onlyAllowed(_crate)
372     {
373         _setString(_crate, _key, _value);
374     }
375 
376     function _setString(bytes32 _crate, bytes32 _key, string _value)
377     internal
378     {
379         crates[_crate].strings[_key] = _value;
380     }
381 
382     function getString(bytes32 _crate, bytes32 _key)
383     public
384     view
385     returns (string)
386     {
387         return crates[_crate].strings[_key];
388     }
389 }
390 
391 // File: @laborx/solidity-storage-lib/contracts/StorageInterface.sol
392 
393 /**
394  * Copyright 2017–2018, LaborX PTY
395  * Licensed under the AGPL Version 3 license.
396  */
397 
398 pragma solidity ^0.4.23;
399 
400 
401 
402 library StorageInterface {
403     struct Config {
404         Storage store;
405         bytes32 crate;
406     }
407 
408     struct UInt {
409         bytes32 id;
410     }
411 
412     struct UInt8 {
413         bytes32 id;
414     }
415 
416     struct Int {
417         bytes32 id;
418     }
419 
420     struct Address {
421         bytes32 id;
422     }
423 
424     struct Bool {
425         bytes32 id;
426     }
427 
428     struct Bytes32 {
429         bytes32 id;
430     }
431 
432     struct String {
433         bytes32 id;
434     }
435 
436     struct Mapping {
437         bytes32 id;
438     }
439 
440     struct StringMapping {
441         String id;
442     }
443 
444     struct UIntBoolMapping {
445         Bool innerMapping;
446     }
447 
448     struct UIntUIntMapping {
449         Mapping innerMapping;
450     }
451 
452     struct UIntBytes32Mapping {
453         Mapping innerMapping;
454     }
455 
456     struct UIntAddressMapping {
457         Mapping innerMapping;
458     }
459 
460     struct UIntEnumMapping {
461         Mapping innerMapping;
462     }
463 
464     struct AddressBoolMapping {
465         Mapping innerMapping;
466     }
467 
468     struct AddressUInt8Mapping {
469         bytes32 id;
470     }
471 
472     struct AddressUIntMapping {
473         Mapping innerMapping;
474     }
475 
476     struct AddressBytes32Mapping {
477         Mapping innerMapping;
478     }
479 
480     struct AddressAddressMapping {
481         Mapping innerMapping;
482     }
483 
484     struct Bytes32UIntMapping {
485         Mapping innerMapping;
486     }
487 
488     struct Bytes32UInt8Mapping {
489         UInt8 innerMapping;
490     }
491 
492     struct Bytes32BoolMapping {
493         Bool innerMapping;
494     }
495 
496     struct Bytes32Bytes32Mapping {
497         Mapping innerMapping;
498     }
499 
500     struct Bytes32AddressMapping {
501         Mapping innerMapping;
502     }
503 
504     struct Bytes32UIntBoolMapping {
505         Bool innerMapping;
506     }
507 
508     struct AddressAddressUInt8Mapping {
509         Mapping innerMapping;
510     }
511 
512     struct AddressAddressUIntMapping {
513         Mapping innerMapping;
514     }
515 
516     struct AddressUIntUIntMapping {
517         Mapping innerMapping;
518     }
519 
520     struct AddressUIntUInt8Mapping {
521         Mapping innerMapping;
522     }
523 
524     struct AddressBytes32Bytes32Mapping {
525         Mapping innerMapping;
526     }
527 
528     struct AddressBytes4BoolMapping {
529         Mapping innerMapping;
530     }
531 
532     struct AddressBytes4Bytes32Mapping {
533         Mapping innerMapping;
534     }
535 
536     struct UIntAddressUIntMapping {
537         Mapping innerMapping;
538     }
539 
540     struct UIntAddressAddressMapping {
541         Mapping innerMapping;
542     }
543 
544     struct UIntAddressBoolMapping {
545         Mapping innerMapping;
546     }
547 
548     struct UIntUIntAddressMapping {
549         Mapping innerMapping;
550     }
551 
552     struct UIntUIntBytes32Mapping {
553         Mapping innerMapping;
554     }
555 
556     struct UIntUIntUIntMapping {
557         Mapping innerMapping;
558     }
559 
560     struct Bytes32UIntUIntMapping {
561         Mapping innerMapping;
562     }
563 
564     struct AddressUIntUIntUIntMapping {
565         Mapping innerMapping;
566     }
567 
568     struct AddressUIntStructAddressUInt8Mapping {
569         AddressUInt8Mapping innerMapping;
570     }
571 
572     struct AddressUIntUIntStructAddressUInt8Mapping {
573         AddressUInt8Mapping innerMapping;
574     }
575 
576     struct AddressUIntUIntUIntStructAddressUInt8Mapping {
577         AddressUInt8Mapping innerMapping;
578     }
579 
580     struct AddressUIntUIntUIntUIntStructAddressUInt8Mapping {
581         AddressUInt8Mapping innerMapping;
582     }
583 
584     struct AddressUIntAddressUInt8Mapping {
585         Mapping innerMapping;
586     }
587 
588     struct AddressUIntUIntAddressUInt8Mapping {
589         Mapping innerMapping;
590     }
591 
592     struct AddressUIntUIntUIntAddressUInt8Mapping {
593         Mapping innerMapping;
594     }
595 
596     struct UIntAddressAddressBoolMapping {
597         Bool innerMapping;
598     }
599 
600     struct UIntUIntUIntBytes32Mapping {
601         Mapping innerMapping;
602     }
603 
604     struct Bytes32UIntUIntUIntMapping {
605         Mapping innerMapping;
606     }
607 
608     bytes32 constant SET_IDENTIFIER = "set";
609 
610     struct Set {
611         UInt count;
612         Mapping indexes;
613         Mapping values;
614     }
615 
616     struct AddressesSet {
617         Set innerSet;
618     }
619 
620     struct CounterSet {
621         Set innerSet;
622     }
623 
624     bytes32 constant ORDERED_SET_IDENTIFIER = "ordered_set";
625 
626     struct OrderedSet {
627         UInt count;
628         Bytes32 first;
629         Bytes32 last;
630         Mapping nextValues;
631         Mapping previousValues;
632     }
633 
634     struct OrderedUIntSet {
635         OrderedSet innerSet;
636     }
637 
638     struct OrderedAddressesSet {
639         OrderedSet innerSet;
640     }
641 
642     struct Bytes32SetMapping {
643         Set innerMapping;
644     }
645 
646     struct AddressesSetMapping {
647         Bytes32SetMapping innerMapping;
648     }
649 
650     struct UIntSetMapping {
651         Bytes32SetMapping innerMapping;
652     }
653 
654     struct Bytes32OrderedSetMapping {
655         OrderedSet innerMapping;
656     }
657 
658     struct UIntOrderedSetMapping {
659         Bytes32OrderedSetMapping innerMapping;
660     }
661 
662     struct AddressOrderedSetMapping {
663         Bytes32OrderedSetMapping innerMapping;
664     }
665 
666     // Can't use modifier due to a Solidity bug.
667     function sanityCheck(bytes32 _currentId, bytes32 _newId) internal pure {
668         if (_currentId != 0 || _newId == 0) {
669             revert();
670         }
671     }
672 
673     function init(Config storage self, Storage _store, bytes32 _crate) internal {
674         self.store = _store;
675         self.crate = _crate;
676     }
677 
678     function init(UInt8 storage self, bytes32 _id) internal {
679         sanityCheck(self.id, _id);
680         self.id = _id;
681     }
682 
683     function init(UInt storage self, bytes32 _id) internal {
684         sanityCheck(self.id, _id);
685         self.id = _id;
686     }
687 
688     function init(Int storage self, bytes32 _id) internal {
689         sanityCheck(self.id, _id);
690         self.id = _id;
691     }
692 
693     function init(Address storage self, bytes32 _id) internal {
694         sanityCheck(self.id, _id);
695         self.id = _id;
696     }
697 
698     function init(Bool storage self, bytes32 _id) internal {
699         sanityCheck(self.id, _id);
700         self.id = _id;
701     }
702 
703     function init(Bytes32 storage self, bytes32 _id) internal {
704         sanityCheck(self.id, _id);
705         self.id = _id;
706     }
707 
708     function init(String storage self, bytes32 _id) internal {
709         sanityCheck(self.id, _id);
710         self.id = _id;
711     }
712 
713     function init(Mapping storage self, bytes32 _id) internal {
714         sanityCheck(self.id, _id);
715         self.id = _id;
716     }
717 
718     function init(StringMapping storage self, bytes32 _id) internal {
719         init(self.id, _id);
720     }
721 
722     function init(UIntAddressMapping storage self, bytes32 _id) internal {
723         init(self.innerMapping, _id);
724     }
725 
726     function init(UIntUIntMapping storage self, bytes32 _id) internal {
727         init(self.innerMapping, _id);
728     }
729 
730     function init(UIntEnumMapping storage self, bytes32 _id) internal {
731         init(self.innerMapping, _id);
732     }
733 
734     function init(UIntBoolMapping storage self, bytes32 _id) internal {
735         init(self.innerMapping, _id);
736     }
737 
738     function init(UIntBytes32Mapping storage self, bytes32 _id) internal {
739         init(self.innerMapping, _id);
740     }
741 
742     function init(AddressAddressUIntMapping storage self, bytes32 _id) internal {
743         init(self.innerMapping, _id);
744     }
745 
746     function init(AddressBytes32Bytes32Mapping storage self, bytes32 _id) internal {
747         init(self.innerMapping, _id);
748     }
749 
750     function init(AddressUIntUIntMapping storage self, bytes32 _id) internal {
751         init(self.innerMapping, _id);
752     }
753 
754     function init(UIntAddressUIntMapping storage self, bytes32 _id) internal {
755         init(self.innerMapping, _id);
756     }
757 
758     function init(UIntAddressBoolMapping storage self, bytes32 _id) internal {
759         init(self.innerMapping, _id);
760     }
761 
762     function init(UIntUIntAddressMapping storage self, bytes32 _id) internal {
763         init(self.innerMapping, _id);
764     }
765 
766     function init(UIntAddressAddressMapping storage self, bytes32 _id) internal {
767         init(self.innerMapping, _id);
768     }
769 
770     function init(UIntUIntBytes32Mapping storage self, bytes32 _id) internal {
771         init(self.innerMapping, _id);
772     }
773 
774     function init(UIntUIntUIntMapping storage self, bytes32 _id) internal {
775         init(self.innerMapping, _id);
776     }
777 
778     function init(UIntAddressAddressBoolMapping storage self, bytes32 _id) internal {
779         init(self.innerMapping, _id);
780     }
781 
782     function init(UIntUIntUIntBytes32Mapping storage self, bytes32 _id) internal {
783         init(self.innerMapping, _id);
784     }
785 
786     function init(Bytes32UIntUIntMapping storage self, bytes32 _id) internal {
787         init(self.innerMapping, _id);
788     }
789 
790     function init(Bytes32UIntUIntUIntMapping storage self, bytes32 _id) internal {
791         init(self.innerMapping, _id);
792     }
793 
794     function init(AddressBoolMapping storage self, bytes32 _id) internal {
795         init(self.innerMapping, _id);
796     }
797 
798     function init(AddressUInt8Mapping storage self, bytes32 _id) internal {
799         sanityCheck(self.id, _id);
800         self.id = _id;
801     }
802 
803     function init(AddressUIntMapping storage self, bytes32 _id) internal {
804         init(self.innerMapping, _id);
805     }
806 
807     function init(AddressBytes32Mapping storage self, bytes32 _id) internal {
808         init(self.innerMapping, _id);
809     }
810 
811     function init(AddressAddressMapping  storage self, bytes32 _id) internal {
812         init(self.innerMapping, _id);
813     }
814 
815     function init(AddressAddressUInt8Mapping storage self, bytes32 _id) internal {
816         init(self.innerMapping, _id);
817     }
818 
819     function init(AddressUIntUInt8Mapping storage self, bytes32 _id) internal {
820         init(self.innerMapping, _id);
821     }
822 
823     function init(AddressBytes4BoolMapping storage self, bytes32 _id) internal {
824         init(self.innerMapping, _id);
825     }
826 
827     function init(AddressBytes4Bytes32Mapping storage self, bytes32 _id) internal {
828         init(self.innerMapping, _id);
829     }
830 
831     function init(AddressUIntUIntUIntMapping storage self, bytes32 _id) internal {
832         init(self.innerMapping, _id);
833     }
834 
835     function init(AddressUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
836         init(self.innerMapping, _id);
837     }
838 
839     function init(AddressUIntUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
840         init(self.innerMapping, _id);
841     }
842 
843     function init(AddressUIntUIntUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
844         init(self.innerMapping, _id);
845     }
846 
847     function init(AddressUIntUIntUIntUIntStructAddressUInt8Mapping storage self, bytes32 _id) internal {
848         init(self.innerMapping, _id);
849     }
850 
851     function init(AddressUIntAddressUInt8Mapping storage self, bytes32 _id) internal {
852         init(self.innerMapping, _id);
853     }
854 
855     function init(AddressUIntUIntAddressUInt8Mapping storage self, bytes32 _id) internal {
856         init(self.innerMapping, _id);
857     }
858 
859     function init(AddressUIntUIntUIntAddressUInt8Mapping storage self, bytes32 _id) internal {
860         init(self.innerMapping, _id);
861     }
862 
863     function init(Bytes32UIntMapping storage self, bytes32 _id) internal {
864         init(self.innerMapping, _id);
865     }
866 
867     function init(Bytes32UInt8Mapping storage self, bytes32 _id) internal {
868         init(self.innerMapping, _id);
869     }
870 
871     function init(Bytes32BoolMapping storage self, bytes32 _id) internal {
872         init(self.innerMapping, _id);
873     }
874 
875     function init(Bytes32Bytes32Mapping storage self, bytes32 _id) internal {
876         init(self.innerMapping, _id);
877     }
878 
879     function init(Bytes32AddressMapping  storage self, bytes32 _id) internal {
880         init(self.innerMapping, _id);
881     }
882 
883     function init(Bytes32UIntBoolMapping  storage self, bytes32 _id) internal {
884         init(self.innerMapping, _id);
885     }
886 
887     function init(Set storage self, bytes32 _id) internal {
888         init(self.count, keccak256(abi.encodePacked(_id, "count")));
889         init(self.indexes, keccak256(abi.encodePacked(_id, "indexes")));
890         init(self.values, keccak256(abi.encodePacked(_id, "values")));
891     }
892 
893     function init(AddressesSet storage self, bytes32 _id) internal {
894         init(self.innerSet, _id);
895     }
896 
897     function init(CounterSet storage self, bytes32 _id) internal {
898         init(self.innerSet, _id);
899     }
900 
901     function init(OrderedSet storage self, bytes32 _id) internal {
902         init(self.count, keccak256(abi.encodePacked(_id, "uint/count")));
903         init(self.first, keccak256(abi.encodePacked(_id, "uint/first")));
904         init(self.last, keccak256(abi.encodePacked(_id, "uint/last")));
905         init(self.nextValues, keccak256(abi.encodePacked(_id, "uint/next")));
906         init(self.previousValues, keccak256(abi.encodePacked(_id, "uint/prev")));
907     }
908 
909     function init(OrderedUIntSet storage self, bytes32 _id) internal {
910         init(self.innerSet, _id);
911     }
912 
913     function init(OrderedAddressesSet storage self, bytes32 _id) internal {
914         init(self.innerSet, _id);
915     }
916 
917     function init(Bytes32SetMapping storage self, bytes32 _id) internal {
918         init(self.innerMapping, _id);
919     }
920 
921     function init(AddressesSetMapping storage self, bytes32 _id) internal {
922         init(self.innerMapping, _id);
923     }
924 
925     function init(UIntSetMapping storage self, bytes32 _id) internal {
926         init(self.innerMapping, _id);
927     }
928 
929     function init(Bytes32OrderedSetMapping storage self, bytes32 _id) internal {
930         init(self.innerMapping, _id);
931     }
932 
933     function init(UIntOrderedSetMapping storage self, bytes32 _id) internal {
934         init(self.innerMapping, _id);
935     }
936 
937     function init(AddressOrderedSetMapping storage self, bytes32 _id) internal {
938         init(self.innerMapping, _id);
939     }
940 
941     /** `set` operation */
942 
943     function set(Config storage self, UInt storage item, uint _value) internal {
944         self.store.setUInt(self.crate, item.id, _value);
945     }
946 
947     function set(Config storage self, UInt storage item, bytes32 _salt, uint _value) internal {
948         self.store.setUInt(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
949     }
950 
951     function set(Config storage self, UInt8 storage item, uint8 _value) internal {
952         self.store.setUInt8(self.crate, item.id, _value);
953     }
954 
955     function set(Config storage self, UInt8 storage item, bytes32 _salt, uint8 _value) internal {
956         self.store.setUInt8(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
957     }
958 
959     function set(Config storage self, Int storage item, int _value) internal {
960         self.store.setInt(self.crate, item.id, _value);
961     }
962 
963     function set(Config storage self, Int storage item, bytes32 _salt, int _value) internal {
964         self.store.setInt(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
965     }
966 
967     function set(Config storage self, Address storage item, address _value) internal {
968         self.store.setAddress(self.crate, item.id, _value);
969     }
970 
971     function set(Config storage self, Address storage item, bytes32 _salt, address _value) internal {
972         self.store.setAddress(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
973     }
974 
975     function set(Config storage self, Bool storage item, bool _value) internal {
976         self.store.setBool(self.crate, item.id, _value);
977     }
978 
979     function set(Config storage self, Bool storage item, bytes32 _salt, bool _value) internal {
980         self.store.setBool(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
981     }
982 
983     function set(Config storage self, Bytes32 storage item, bytes32 _value) internal {
984         self.store.setBytes32(self.crate, item.id, _value);
985     }
986 
987     function set(Config storage self, Bytes32 storage item, bytes32 _salt, bytes32 _value) internal {
988         self.store.setBytes32(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
989     }
990 
991     function set(Config storage self, String storage item, string _value) internal {
992         self.store.setString(self.crate, item.id, _value);
993     }
994 
995     function set(Config storage self, String storage item, bytes32 _salt, string _value) internal {
996         self.store.setString(self.crate, keccak256(abi.encodePacked(item.id, _salt)), _value);
997     }
998 
999     function set(Config storage self, Mapping storage item, uint _key, uint _value) internal {
1000         self.store.setUInt(self.crate, keccak256(abi.encodePacked(item.id, _key)), _value);
1001     }
1002 
1003     function set(Config storage self, Mapping storage item, bytes32 _key, bytes32 _value) internal {
1004         self.store.setBytes32(self.crate, keccak256(abi.encodePacked(item.id, _key)), _value);
1005     }
1006 
1007     function set(Config storage self, StringMapping storage item, bytes32 _key, string _value) internal {
1008         set(self, item.id, _key, _value);
1009     }
1010 
1011     function set(Config storage self, AddressUInt8Mapping storage item, bytes32 _key, address _value1, uint8 _value2) internal {
1012         self.store.setAddressUInt8(self.crate, keccak256(abi.encodePacked(item.id, _key)), _value1, _value2);
1013     }
1014 
1015     function set(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _value) internal {
1016         set(self, item, keccak256(abi.encodePacked(_key, _key2)), _value);
1017     }
1018 
1019     function set(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _key3, bytes32 _value) internal {
1020         set(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)), _value);
1021     }
1022 
1023     function set(Config storage self, Bool storage item, bytes32 _key, bytes32 _key2, bytes32 _key3, bool _value) internal {
1024         set(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)), _value);
1025     }
1026 
1027     function set(Config storage self, UIntAddressMapping storage item, uint _key, address _value) internal {
1028         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
1029     }
1030 
1031     function set(Config storage self, UIntUIntMapping storage item, uint _key, uint _value) internal {
1032         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
1033     }
1034 
1035     function set(Config storage self, UIntBoolMapping storage item, uint _key, bool _value) internal {
1036         set(self, item.innerMapping, bytes32(_key), _value);
1037     }
1038 
1039     function set(Config storage self, UIntEnumMapping storage item, uint _key, uint8 _value) internal {
1040         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
1041     }
1042 
1043     function set(Config storage self, UIntBytes32Mapping storage item, uint _key, bytes32 _value) internal {
1044         set(self, item.innerMapping, bytes32(_key), _value);
1045     }
1046 
1047     function set(Config storage self, Bytes32UIntMapping storage item, bytes32 _key, uint _value) internal {
1048         set(self, item.innerMapping, _key, bytes32(_value));
1049     }
1050 
1051     function set(Config storage self, Bytes32UInt8Mapping storage item, bytes32 _key, uint8 _value) internal {
1052         set(self, item.innerMapping, _key, _value);
1053     }
1054 
1055     function set(Config storage self, Bytes32BoolMapping storage item, bytes32 _key, bool _value) internal {
1056         set(self, item.innerMapping, _key, _value);
1057     }
1058 
1059     function set(Config storage self, Bytes32Bytes32Mapping storage item, bytes32 _key, bytes32 _value) internal {
1060         set(self, item.innerMapping, _key, _value);
1061     }
1062 
1063     function set(Config storage self, Bytes32AddressMapping storage item, bytes32 _key, address _value) internal {
1064         set(self, item.innerMapping, _key, bytes32(_value));
1065     }
1066 
1067     function set(Config storage self, Bytes32UIntBoolMapping storage item, bytes32 _key, uint _key2, bool _value) internal {
1068         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)), _value);
1069     }
1070 
1071     function set(Config storage self, AddressUIntMapping storage item, address _key, uint _value) internal {
1072         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
1073     }
1074 
1075     function set(Config storage self, AddressBoolMapping storage item, address _key, bool _value) internal {
1076         set(self, item.innerMapping, bytes32(_key), toBytes32(_value));
1077     }
1078 
1079     function set(Config storage self, AddressBytes32Mapping storage item, address _key, bytes32 _value) internal {
1080         set(self, item.innerMapping, bytes32(_key), _value);
1081     }
1082 
1083     function set(Config storage self, AddressAddressMapping storage item, address _key, address _value) internal {
1084         set(self, item.innerMapping, bytes32(_key), bytes32(_value));
1085     }
1086 
1087     function set(Config storage self, AddressAddressUIntMapping storage item, address _key, address _key2, uint _value) internal {
1088         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1089     }
1090 
1091     function set(Config storage self, AddressUIntUIntMapping storage item, address _key, uint _key2, uint _value) internal {
1092         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1093     }
1094 
1095     function set(Config storage self, AddressAddressUInt8Mapping storage item, address _key, address _key2, uint8 _value) internal {
1096         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1097     }
1098 
1099     function set(Config storage self, AddressUIntUInt8Mapping storage item, address _key, uint _key2, uint8 _value) internal {
1100         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1101     }
1102 
1103     function set(Config storage self, AddressBytes32Bytes32Mapping storage item, address _key, bytes32 _key2, bytes32 _value) internal {
1104         set(self, item.innerMapping, bytes32(_key), _key2, _value);
1105     }
1106 
1107     function set(Config storage self, UIntAddressUIntMapping storage item, uint _key, address _key2, uint _value) internal {
1108         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1109     }
1110 
1111     function set(Config storage self, UIntAddressBoolMapping storage item, uint _key, address _key2, bool _value) internal {
1112         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), toBytes32(_value));
1113     }
1114 
1115     function set(Config storage self, UIntAddressAddressMapping storage item, uint _key, address _key2, address _value) internal {
1116         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1117     }
1118 
1119     function set(Config storage self, UIntUIntAddressMapping storage item, uint _key, uint _key2, address _value) internal {
1120         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1121     }
1122 
1123     function set(Config storage self, UIntUIntBytes32Mapping storage item, uint _key, uint _key2, bytes32 _value) internal {
1124         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), _value);
1125     }
1126 
1127     function set(Config storage self, UIntUIntUIntMapping storage item, uint _key, uint _key2, uint _value) internal {
1128         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_value));
1129     }
1130 
1131     function set(Config storage self, UIntAddressAddressBoolMapping storage item, uint _key, address _key2, address _key3, bool _value) internal {
1132         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3), _value);
1133     }
1134 
1135     function set(Config storage self, UIntUIntUIntBytes32Mapping storage item, uint _key, uint _key2,  uint _key3, bytes32 _value) internal {
1136         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3), _value);
1137     }
1138 
1139     function set(Config storage self, Bytes32UIntUIntMapping storage item, bytes32 _key, uint _key2, uint _value) internal {
1140         set(self, item.innerMapping, _key, bytes32(_key2), bytes32(_value));
1141     }
1142 
1143     function set(Config storage self, Bytes32UIntUIntUIntMapping storage item, bytes32 _key, uint _key2,  uint _key3, uint _value) internal {
1144         set(self, item.innerMapping, _key, bytes32(_key2), bytes32(_key3), bytes32(_value));
1145     }
1146 
1147     function set(Config storage self, AddressUIntUIntUIntMapping storage item, address _key, uint _key2,  uint _key3, uint _value) internal {
1148         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3), bytes32(_value));
1149     }
1150 
1151     function set(Config storage self, AddressUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, address _value, uint8 _value2) internal {
1152         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)), _value, _value2);
1153     }
1154 
1155     function set(Config storage self, AddressUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, address _value, uint8 _value2) internal {
1156         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3)), _value, _value2);
1157     }
1158 
1159     function set(Config storage self, AddressUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2,  uint _key3, uint _key4, address _value, uint8 _value2) internal {
1160         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4)), _value, _value2);
1161     }
1162 
1163     function set(Config storage self, AddressUIntUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2,  uint _key3, uint _key4, uint _key5, address _value, uint8 _value2) internal {
1164         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5)), _value, _value2);
1165     }
1166 
1167     function set(Config storage self, AddressUIntAddressUInt8Mapping storage item, address _key, uint _key2, address _key3, uint8 _value) internal {
1168         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3)), bytes32(_value));
1169     }
1170 
1171     function set(Config storage self, AddressUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, address _key4, uint8 _value) internal {
1172         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4)), bytes32(_value));
1173     }
1174 
1175     function set(Config storage self, AddressUIntUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2,  uint _key3, uint _key4, address _key5, uint8 _value) internal {
1176         set(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5)), bytes32(_value));
1177     }
1178 
1179     function set(Config storage self, AddressBytes4BoolMapping storage item, address _key, bytes4 _key2, bool _value) internal {
1180         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), toBytes32(_value));
1181     }
1182 
1183     function set(Config storage self, AddressBytes4Bytes32Mapping storage item, address _key, bytes4 _key2, bytes32 _value) internal {
1184         set(self, item.innerMapping, bytes32(_key), bytes32(_key2), _value);
1185     }
1186 
1187 
1188     /** `add` operation */
1189 
1190     function add(Config storage self, Set storage item, bytes32 _value) internal {
1191         add(self, item, SET_IDENTIFIER, _value);
1192     }
1193 
1194     function add(Config storage self, Set storage item, bytes32 _salt, bytes32 _value) private {
1195         if (includes(self, item, _salt, _value)) {
1196             return;
1197         }
1198         uint newCount = count(self, item, _salt) + 1;
1199         set(self, item.values, _salt, bytes32(newCount), _value);
1200         set(self, item.indexes, _salt, _value, bytes32(newCount));
1201         set(self, item.count, _salt, newCount);
1202     }
1203 
1204     function add(Config storage self, AddressesSet storage item, address _value) internal {
1205         add(self, item.innerSet, bytes32(_value));
1206     }
1207 
1208     function add(Config storage self, CounterSet storage item) internal {
1209         add(self, item.innerSet, bytes32(count(self, item) + 1));
1210     }
1211 
1212     function add(Config storage self, OrderedSet storage item, bytes32 _value) internal {
1213         add(self, item, ORDERED_SET_IDENTIFIER, _value);
1214     }
1215 
1216     function add(Config storage self, OrderedSet storage item, bytes32 _salt, bytes32 _value) private {
1217         if (_value == 0x0) { revert(); }
1218 
1219         if (includes(self, item, _salt, _value)) { return; }
1220 
1221         if (count(self, item, _salt) == 0x0) {
1222             set(self, item.first, _salt, _value);
1223         }
1224 
1225         if (get(self, item.last, _salt) != 0x0) {
1226             _setOrderedSetLink(self, item.nextValues, _salt, get(self, item.last, _salt), _value);
1227             _setOrderedSetLink(self, item.previousValues, _salt, _value, get(self, item.last, _salt));
1228         }
1229 
1230         _setOrderedSetLink(self, item.nextValues, _salt,  _value, 0x0);
1231         set(self, item.last, _salt, _value);
1232         set(self, item.count, _salt, get(self, item.count, _salt) + 1);
1233     }
1234 
1235     function add(Config storage self, Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal {
1236         add(self, item.innerMapping, _key, _value);
1237     }
1238 
1239     function add(Config storage self, AddressesSetMapping storage item, bytes32 _key, address _value) internal {
1240         add(self, item.innerMapping, _key, bytes32(_value));
1241     }
1242 
1243     function add(Config storage self, UIntSetMapping storage item, bytes32 _key, uint _value) internal {
1244         add(self, item.innerMapping, _key, bytes32(_value));
1245     }
1246 
1247     function add(Config storage self, Bytes32OrderedSetMapping storage item, bytes32 _key, bytes32 _value) internal {
1248         add(self, item.innerMapping, _key, _value);
1249     }
1250 
1251     function add(Config storage self, UIntOrderedSetMapping storage item, bytes32 _key, uint _value) internal {
1252         add(self, item.innerMapping, _key, bytes32(_value));
1253     }
1254 
1255     function add(Config storage self, AddressOrderedSetMapping storage item, bytes32 _key, address _value) internal {
1256         add(self, item.innerMapping, _key, bytes32(_value));
1257     }
1258 
1259     function add(Config storage self, OrderedUIntSet storage item, uint _value) internal {
1260         add(self, item.innerSet, bytes32(_value));
1261     }
1262 
1263     function add(Config storage self, OrderedAddressesSet storage item, address _value) internal {
1264         add(self, item.innerSet, bytes32(_value));
1265     }
1266 
1267     function set(Config storage self, Set storage item, bytes32 _oldValue, bytes32 _newValue) internal {
1268         set(self, item, SET_IDENTIFIER, _oldValue, _newValue);
1269     }
1270 
1271     function set(Config storage self, Set storage item, bytes32 _salt, bytes32 _oldValue, bytes32 _newValue) private {
1272         if (!includes(self, item, _salt, _oldValue)) {
1273             return;
1274         }
1275         uint index = uint(get(self, item.indexes, _salt, _oldValue));
1276         set(self, item.values, _salt, bytes32(index), _newValue);
1277         set(self, item.indexes, _salt, _newValue, bytes32(index));
1278         set(self, item.indexes, _salt, _oldValue, bytes32(0));
1279     }
1280 
1281     function set(Config storage self, AddressesSet storage item, address _oldValue, address _newValue) internal {
1282         set(self, item.innerSet, bytes32(_oldValue), bytes32(_newValue));
1283     }
1284 
1285     /** `remove` operation */
1286 
1287     function remove(Config storage self, Set storage item, bytes32 _value) internal {
1288         remove(self, item, SET_IDENTIFIER, _value);
1289     }
1290 
1291     function remove(Config storage self, Set storage item, bytes32 _salt, bytes32 _value) private {
1292         if (!includes(self, item, _salt, _value)) {
1293             return;
1294         }
1295         uint lastIndex = count(self, item, _salt);
1296         bytes32 lastValue = get(self, item.values, _salt, bytes32(lastIndex));
1297         uint index = uint(get(self, item.indexes, _salt, _value));
1298         if (index < lastIndex) {
1299             set(self, item.indexes, _salt, lastValue, bytes32(index));
1300             set(self, item.values, _salt, bytes32(index), lastValue);
1301         }
1302         set(self, item.indexes, _salt, _value, bytes32(0));
1303         set(self, item.values, _salt, bytes32(lastIndex), bytes32(0));
1304         set(self, item.count, _salt, lastIndex - 1);
1305     }
1306 
1307     function remove(Config storage self, AddressesSet storage item, address _value) internal {
1308         remove(self, item.innerSet, bytes32(_value));
1309     }
1310 
1311     function remove(Config storage self, CounterSet storage item, uint _value) internal {
1312         remove(self, item.innerSet, bytes32(_value));
1313     }
1314 
1315     function remove(Config storage self, OrderedSet storage item, bytes32 _value) internal {
1316         remove(self, item, ORDERED_SET_IDENTIFIER, _value);
1317     }
1318 
1319     function remove(Config storage self, OrderedSet storage item, bytes32 _salt, bytes32 _value) private {
1320         if (!includes(self, item, _salt, _value)) { return; }
1321 
1322         _setOrderedSetLink(self, item.nextValues, _salt, get(self, item.previousValues, _salt, _value), get(self, item.nextValues, _salt, _value));
1323         _setOrderedSetLink(self, item.previousValues, _salt, get(self, item.nextValues, _salt, _value), get(self, item.previousValues, _salt, _value));
1324 
1325         if (_value == get(self, item.first, _salt)) {
1326             set(self, item.first, _salt, get(self, item.nextValues, _salt, _value));
1327         }
1328 
1329         if (_value == get(self, item.last, _salt)) {
1330             set(self, item.last, _salt, get(self, item.previousValues, _salt, _value));
1331         }
1332 
1333         _deleteOrderedSetLink(self, item.nextValues, _salt, _value);
1334         _deleteOrderedSetLink(self, item.previousValues, _salt, _value);
1335 
1336         set(self, item.count, _salt, get(self, item.count, _salt) - 1);
1337     }
1338 
1339     function remove(Config storage self, OrderedUIntSet storage item, uint _value) internal {
1340         remove(self, item.innerSet, bytes32(_value));
1341     }
1342 
1343     function remove(Config storage self, OrderedAddressesSet storage item, address _value) internal {
1344         remove(self, item.innerSet, bytes32(_value));
1345     }
1346 
1347     function remove(Config storage self, Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal {
1348         remove(self, item.innerMapping, _key, _value);
1349     }
1350 
1351     function remove(Config storage self, AddressesSetMapping storage item, bytes32 _key, address _value) internal {
1352         remove(self, item.innerMapping, _key, bytes32(_value));
1353     }
1354 
1355     function remove(Config storage self, UIntSetMapping storage item, bytes32 _key, uint _value) internal {
1356         remove(self, item.innerMapping, _key, bytes32(_value));
1357     }
1358 
1359     function remove(Config storage self, Bytes32OrderedSetMapping storage item, bytes32 _key, bytes32 _value) internal {
1360         remove(self, item.innerMapping, _key, _value);
1361     }
1362 
1363     function remove(Config storage self, UIntOrderedSetMapping storage item, bytes32 _key, uint _value) internal {
1364         remove(self, item.innerMapping, _key, bytes32(_value));
1365     }
1366 
1367     function remove(Config storage self, AddressOrderedSetMapping storage item, bytes32 _key, address _value) internal {
1368         remove(self, item.innerMapping, _key, bytes32(_value));
1369     }
1370 
1371     /** 'copy` operation */
1372 
1373     function copy(Config storage self, Set storage source, Set storage dest) internal {
1374         uint _destCount = count(self, dest);
1375         bytes32[] memory _toRemoveFromDest = new bytes32[](_destCount);
1376         uint _idx;
1377         uint _pointer = 0;
1378         for (_idx = 0; _idx < _destCount; ++_idx) {
1379             bytes32 _destValue = get(self, dest, _idx);
1380             if (!includes(self, source, _destValue)) {
1381                 _toRemoveFromDest[_pointer++] = _destValue;
1382             }
1383         }
1384 
1385         uint _sourceCount = count(self, source);
1386         for (_idx = 0; _idx < _sourceCount; ++_idx) {
1387             add(self, dest, get(self, source, _idx));
1388         }
1389 
1390         for (_idx = 0; _idx < _pointer; ++_idx) {
1391             remove(self, dest, _toRemoveFromDest[_idx]);
1392         }
1393     }
1394 
1395     function copy(Config storage self, AddressesSet storage source, AddressesSet storage dest) internal {
1396         copy(self, source.innerSet, dest.innerSet);
1397     }
1398 
1399     function copy(Config storage self, CounterSet storage source, CounterSet storage dest) internal {
1400         copy(self, source.innerSet, dest.innerSet);
1401     }
1402 
1403     /** `get` operation */
1404 
1405     function get(Config storage self, UInt storage item) internal view returns (uint) {
1406         return self.store.getUInt(self.crate, item.id);
1407     }
1408 
1409     function get(Config storage self, UInt storage item, bytes32 salt) internal view returns (uint) {
1410         return self.store.getUInt(self.crate, keccak256(abi.encodePacked(item.id, salt)));
1411     }
1412 
1413     function get(Config storage self, UInt8 storage item) internal view returns (uint8) {
1414         return self.store.getUInt8(self.crate, item.id);
1415     }
1416 
1417     function get(Config storage self, UInt8 storage item, bytes32 salt) internal view returns (uint8) {
1418         return self.store.getUInt8(self.crate, keccak256(abi.encodePacked(item.id, salt)));
1419     }
1420 
1421     function get(Config storage self, Int storage item) internal view returns (int) {
1422         return self.store.getInt(self.crate, item.id);
1423     }
1424 
1425     function get(Config storage self, Int storage item, bytes32 salt) internal view returns (int) {
1426         return self.store.getInt(self.crate, keccak256(abi.encodePacked(item.id, salt)));
1427     }
1428 
1429     function get(Config storage self, Address storage item) internal view returns (address) {
1430         return self.store.getAddress(self.crate, item.id);
1431     }
1432 
1433     function get(Config storage self, Address storage item, bytes32 salt) internal view returns (address) {
1434         return self.store.getAddress(self.crate, keccak256(abi.encodePacked(item.id, salt)));
1435     }
1436 
1437     function get(Config storage self, Bool storage item) internal view returns (bool) {
1438         return self.store.getBool(self.crate, item.id);
1439     }
1440 
1441     function get(Config storage self, Bool storage item, bytes32 salt) internal view returns (bool) {
1442         return self.store.getBool(self.crate, keccak256(abi.encodePacked(item.id, salt)));
1443     }
1444 
1445     function get(Config storage self, Bytes32 storage item) internal view returns (bytes32) {
1446         return self.store.getBytes32(self.crate, item.id);
1447     }
1448 
1449     function get(Config storage self, Bytes32 storage item, bytes32 salt) internal view returns (bytes32) {
1450         return self.store.getBytes32(self.crate, keccak256(abi.encodePacked(item.id, salt)));
1451     }
1452 
1453     function get(Config storage self, String storage item) internal view returns (string) {
1454         return self.store.getString(self.crate, item.id);
1455     }
1456 
1457     function get(Config storage self, String storage item, bytes32 salt) internal view returns (string) {
1458         return self.store.getString(self.crate, keccak256(abi.encodePacked(item.id, salt)));
1459     }
1460 
1461     function get(Config storage self, Mapping storage item, uint _key) internal view returns (uint) {
1462         return self.store.getUInt(self.crate, keccak256(abi.encodePacked(item.id, _key)));
1463     }
1464 
1465     function get(Config storage self, Mapping storage item, bytes32 _key) internal view returns (bytes32) {
1466         return self.store.getBytes32(self.crate, keccak256(abi.encodePacked(item.id, _key)));
1467     }
1468 
1469     function get(Config storage self, StringMapping storage item, bytes32 _key) internal view returns (string) {
1470         return get(self, item.id, _key);
1471     }
1472 
1473     function get(Config storage self, AddressUInt8Mapping storage item, bytes32 _key) internal view returns (address, uint8) {
1474         return self.store.getAddressUInt8(self.crate, keccak256(abi.encodePacked(item.id, _key)));
1475     }
1476 
1477     function get(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2) internal view returns (bytes32) {
1478         return get(self, item, keccak256(abi.encodePacked(_key, _key2)));
1479     }
1480 
1481     function get(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _key3) internal view returns (bytes32) {
1482         return get(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)));
1483     }
1484 
1485     function get(Config storage self, Bool storage item, bytes32 _key, bytes32 _key2, bytes32 _key3) internal view returns (bool) {
1486         return get(self, item, keccak256(abi.encodePacked(_key, _key2, _key3)));
1487     }
1488 
1489     function get(Config storage self, UIntBoolMapping storage item, uint _key) internal view returns (bool) {
1490         return get(self, item.innerMapping, bytes32(_key));
1491     }
1492 
1493     function get(Config storage self, UIntEnumMapping storage item, uint _key) internal view returns (uint8) {
1494         return uint8(get(self, item.innerMapping, bytes32(_key)));
1495     }
1496 
1497     function get(Config storage self, UIntUIntMapping storage item, uint _key) internal view returns (uint) {
1498         return uint(get(self, item.innerMapping, bytes32(_key)));
1499     }
1500 
1501     function get(Config storage self, UIntAddressMapping storage item, uint _key) internal view returns (address) {
1502         return address(get(self, item.innerMapping, bytes32(_key)));
1503     }
1504 
1505     function get(Config storage self, Bytes32UIntMapping storage item, bytes32 _key) internal view returns (uint) {
1506         return uint(get(self, item.innerMapping, _key));
1507     }
1508 
1509     function get(Config storage self, Bytes32AddressMapping storage item, bytes32 _key) internal view returns (address) {
1510         return address(get(self, item.innerMapping, _key));
1511     }
1512 
1513     function get(Config storage self, Bytes32UInt8Mapping storage item, bytes32 _key) internal view returns (uint8) {
1514         return get(self, item.innerMapping, _key);
1515     }
1516 
1517     function get(Config storage self, Bytes32BoolMapping storage item, bytes32 _key) internal view returns (bool) {
1518         return get(self, item.innerMapping, _key);
1519     }
1520 
1521     function get(Config storage self, Bytes32Bytes32Mapping storage item, bytes32 _key) internal view returns (bytes32) {
1522         return get(self, item.innerMapping, _key);
1523     }
1524 
1525     function get(Config storage self, Bytes32UIntBoolMapping storage item, bytes32 _key, uint _key2) internal view returns (bool) {
1526         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)));
1527     }
1528 
1529     function get(Config storage self, UIntBytes32Mapping storage item, uint _key) internal view returns (bytes32) {
1530         return get(self, item.innerMapping, bytes32(_key));
1531     }
1532 
1533     function get(Config storage self, AddressUIntMapping storage item, address _key) internal view returns (uint) {
1534         return uint(get(self, item.innerMapping, bytes32(_key)));
1535     }
1536 
1537     function get(Config storage self, AddressBoolMapping storage item, address _key) internal view returns (bool) {
1538         return toBool(get(self, item.innerMapping, bytes32(_key)));
1539     }
1540 
1541     function get(Config storage self, AddressAddressMapping storage item, address _key) internal view returns (address) {
1542         return address(get(self, item.innerMapping, bytes32(_key)));
1543     }
1544 
1545     function get(Config storage self, AddressBytes32Mapping storage item, address _key) internal view returns (bytes32) {
1546         return get(self, item.innerMapping, bytes32(_key));
1547     }
1548 
1549     function get(Config storage self, UIntUIntBytes32Mapping storage item, uint _key, uint _key2) internal view returns (bytes32) {
1550         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2));
1551     }
1552 
1553     function get(Config storage self, UIntUIntAddressMapping storage item, uint _key, uint _key2) internal view returns (address) {
1554         return address(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
1555     }
1556 
1557     function get(Config storage self, UIntUIntUIntMapping storage item, uint _key, uint _key2) internal view returns (uint) {
1558         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
1559     }
1560 
1561     function get(Config storage self, Bytes32UIntUIntMapping storage item, bytes32 _key, uint _key2) internal view returns (uint) {
1562         return uint(get(self, item.innerMapping, _key, bytes32(_key2)));
1563     }
1564 
1565     function get(Config storage self, Bytes32UIntUIntUIntMapping storage item, bytes32 _key, uint _key2, uint _key3) internal view returns (uint) {
1566         return uint(get(self, item.innerMapping, _key, bytes32(_key2), bytes32(_key3)));
1567     }
1568 
1569     function get(Config storage self, AddressAddressUIntMapping storage item, address _key, address _key2) internal view returns (uint) {
1570         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
1571     }
1572 
1573     function get(Config storage self, AddressAddressUInt8Mapping storage item, address _key, address _key2) internal view returns (uint8) {
1574         return uint8(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
1575     }
1576 
1577     function get(Config storage self, AddressUIntUIntMapping storage item, address _key, uint _key2) internal view returns (uint) {
1578         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
1579     }
1580 
1581     function get(Config storage self, AddressUIntUInt8Mapping storage item, address _key, uint _key2) internal view returns (uint) {
1582         return uint8(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
1583     }
1584 
1585     function get(Config storage self, AddressBytes32Bytes32Mapping storage item, address _key, bytes32 _key2) internal view returns (bytes32) {
1586         return get(self, item.innerMapping, bytes32(_key), _key2);
1587     }
1588 
1589     function get(Config storage self, AddressBytes4BoolMapping storage item, address _key, bytes4 _key2) internal view returns (bool) {
1590         return toBool(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
1591     }
1592 
1593     function get(Config storage self, AddressBytes4Bytes32Mapping storage item, address _key, bytes4 _key2) internal view returns (bytes32) {
1594         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2));
1595     }
1596 
1597     function get(Config storage self, UIntAddressUIntMapping storage item, uint _key, address _key2) internal view returns (uint) {
1598         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
1599     }
1600 
1601     function get(Config storage self, UIntAddressBoolMapping storage item, uint _key, address _key2) internal view returns (bool) {
1602         return toBool(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
1603     }
1604 
1605     function get(Config storage self, UIntAddressAddressMapping storage item, uint _key, address _key2) internal view returns (address) {
1606         return address(get(self, item.innerMapping, bytes32(_key), bytes32(_key2)));
1607     }
1608 
1609     function get(Config storage self, UIntAddressAddressBoolMapping storage item, uint _key, address _key2, address _key3) internal view returns (bool) {
1610         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3));
1611     }
1612 
1613     function get(Config storage self, UIntUIntUIntBytes32Mapping storage item, uint _key, uint _key2, uint _key3) internal view returns (bytes32) {
1614         return get(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3));
1615     }
1616 
1617     function get(Config storage self, AddressUIntUIntUIntMapping storage item, address _key, uint _key2, uint _key3) internal view returns (uint) {
1618         return uint(get(self, item.innerMapping, bytes32(_key), bytes32(_key2), bytes32(_key3)));
1619     }
1620 
1621     function get(Config storage self, AddressUIntStructAddressUInt8Mapping storage item, address _key, uint _key2) internal view returns (address, uint8) {
1622         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2)));
1623     }
1624 
1625     function get(Config storage self, AddressUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3) internal view returns (address, uint8) {
1626         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3)));
1627     }
1628 
1629     function get(Config storage self, AddressUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, uint _key4) internal view returns (address, uint8) {
1630         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4)));
1631     }
1632 
1633     function get(Config storage self, AddressUIntUIntUIntUIntStructAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, uint _key4, uint _key5) internal view returns (address, uint8) {
1634         return get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5)));
1635     }
1636 
1637     function get(Config storage self, AddressUIntAddressUInt8Mapping storage item, address _key, uint _key2, address _key3) internal view returns (uint8) {
1638         return uint8(get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3))));
1639     }
1640 
1641     function get(Config storage self, AddressUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, address _key4) internal view returns (uint8) {
1642         return uint8(get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4))));
1643     }
1644 
1645     function get(Config storage self, AddressUIntUIntUIntAddressUInt8Mapping storage item, address _key, uint _key2, uint _key3, uint _key4, address _key5) internal view returns (uint8) {
1646         return uint8(get(self, item.innerMapping, keccak256(abi.encodePacked(_key, _key2, _key3, _key4, _key5))));
1647     }
1648 
1649     /** `includes` operation */
1650 
1651     function includes(Config storage self, Set storage item, bytes32 _value) internal view returns (bool) {
1652         return includes(self, item, SET_IDENTIFIER, _value);
1653     }
1654 
1655     function includes(Config storage self, Set storage item, bytes32 _salt, bytes32 _value) internal view returns (bool) {
1656         return get(self, item.indexes, _salt, _value) != 0;
1657     }
1658 
1659     function includes(Config storage self, AddressesSet storage item, address _value) internal view returns (bool) {
1660         return includes(self, item.innerSet, bytes32(_value));
1661     }
1662 
1663     function includes(Config storage self, CounterSet storage item, uint _value) internal view returns (bool) {
1664         return includes(self, item.innerSet, bytes32(_value));
1665     }
1666 
1667     function includes(Config storage self, OrderedSet storage item, bytes32 _value) internal view returns (bool) {
1668         return includes(self, item, ORDERED_SET_IDENTIFIER, _value);
1669     }
1670 
1671     function includes(Config storage self, OrderedSet storage item, bytes32 _salt, bytes32 _value) private view returns (bool) {
1672         return _value != 0x0 && (get(self, item.nextValues, _salt, _value) != 0x0 || get(self, item.last, _salt) == _value);
1673     }
1674 
1675     function includes(Config storage self, OrderedUIntSet storage item, uint _value) internal view returns (bool) {
1676         return includes(self, item.innerSet, bytes32(_value));
1677     }
1678 
1679     function includes(Config storage self, OrderedAddressesSet storage item, address _value) internal view returns (bool) {
1680         return includes(self, item.innerSet, bytes32(_value));
1681     }
1682 
1683     function includes(Config storage self, Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal view returns (bool) {
1684         return includes(self, item.innerMapping, _key, _value);
1685     }
1686 
1687     function includes(Config storage self, AddressesSetMapping storage item, bytes32 _key, address _value) internal view returns (bool) {
1688         return includes(self, item.innerMapping, _key, bytes32(_value));
1689     }
1690 
1691     function includes(Config storage self, UIntSetMapping storage item, bytes32 _key, uint _value) internal view returns (bool) {
1692         return includes(self, item.innerMapping, _key, bytes32(_value));
1693     }
1694 
1695     function includes(Config storage self, Bytes32OrderedSetMapping storage item, bytes32 _key, bytes32 _value) internal view returns (bool) {
1696         return includes(self, item.innerMapping, _key, _value);
1697     }
1698 
1699     function includes(Config storage self, UIntOrderedSetMapping storage item, bytes32 _key, uint _value) internal view returns (bool) {
1700         return includes(self, item.innerMapping, _key, bytes32(_value));
1701     }
1702 
1703     function includes(Config storage self, AddressOrderedSetMapping storage item, bytes32 _key, address _value) internal view returns (bool) {
1704         return includes(self, item.innerMapping, _key, bytes32(_value));
1705     }
1706 
1707     function getIndex(Config storage self, Set storage item, bytes32 _value) internal view returns (uint) {
1708         return getIndex(self, item, SET_IDENTIFIER, _value);
1709     }
1710 
1711     function getIndex(Config storage self, Set storage item, bytes32 _salt, bytes32 _value) private view returns (uint) {
1712         return uint(get(self, item.indexes, _salt, _value));
1713     }
1714 
1715     function getIndex(Config storage self, AddressesSet storage item, address _value) internal view returns (uint) {
1716         return getIndex(self, item.innerSet, bytes32(_value));
1717     }
1718 
1719     function getIndex(Config storage self, CounterSet storage item, uint _value) internal view returns (uint) {
1720         return getIndex(self, item.innerSet, bytes32(_value));
1721     }
1722 
1723     function getIndex(Config storage self, Bytes32SetMapping storage item, bytes32 _key, bytes32 _value) internal view returns (uint) {
1724         return getIndex(self, item.innerMapping, _key, _value);
1725     }
1726 
1727     function getIndex(Config storage self, AddressesSetMapping storage item, bytes32 _key, address _value) internal view returns (uint) {
1728         return getIndex(self, item.innerMapping, _key, bytes32(_value));
1729     }
1730 
1731     function getIndex(Config storage self, UIntSetMapping storage item, bytes32 _key, uint _value) internal view returns (uint) {
1732         return getIndex(self, item.innerMapping, _key, bytes32(_value));
1733     }
1734 
1735     /** `count` operation */
1736 
1737     function count(Config storage self, Set storage item) internal view returns (uint) {
1738         return count(self, item, SET_IDENTIFIER);
1739     }
1740 
1741     function count(Config storage self, Set storage item, bytes32 _salt) internal view returns (uint) {
1742         return get(self, item.count, _salt);
1743     }
1744 
1745     function count(Config storage self, AddressesSet storage item) internal view returns (uint) {
1746         return count(self, item.innerSet);
1747     }
1748 
1749     function count(Config storage self, CounterSet storage item) internal view returns (uint) {
1750         return count(self, item.innerSet);
1751     }
1752 
1753     function count(Config storage self, OrderedSet storage item) internal view returns (uint) {
1754         return count(self, item, ORDERED_SET_IDENTIFIER);
1755     }
1756 
1757     function count(Config storage self, OrderedSet storage item, bytes32 _salt) private view returns (uint) {
1758         return get(self, item.count, _salt);
1759     }
1760 
1761     function count(Config storage self, OrderedUIntSet storage item) internal view returns (uint) {
1762         return count(self, item.innerSet);
1763     }
1764 
1765     function count(Config storage self, OrderedAddressesSet storage item) internal view returns (uint) {
1766         return count(self, item.innerSet);
1767     }
1768 
1769     function count(Config storage self, Bytes32SetMapping storage item, bytes32 _key) internal view returns (uint) {
1770         return count(self, item.innerMapping, _key);
1771     }
1772 
1773     function count(Config storage self, AddressesSetMapping storage item, bytes32 _key) internal view returns (uint) {
1774         return count(self, item.innerMapping, _key);
1775     }
1776 
1777     function count(Config storage self, UIntSetMapping storage item, bytes32 _key) internal view returns (uint) {
1778         return count(self, item.innerMapping, _key);
1779     }
1780 
1781     function count(Config storage self, Bytes32OrderedSetMapping storage item, bytes32 _key) internal view returns (uint) {
1782         return count(self, item.innerMapping, _key);
1783     }
1784 
1785     function count(Config storage self, UIntOrderedSetMapping storage item, bytes32 _key) internal view returns (uint) {
1786         return count(self, item.innerMapping, _key);
1787     }
1788 
1789     function count(Config storage self, AddressOrderedSetMapping storage item, bytes32 _key) internal view returns (uint) {
1790         return count(self, item.innerMapping, _key);
1791     }
1792 
1793     function get(Config storage self, Set storage item) internal view returns (bytes32[] result) {
1794         result = get(self, item, SET_IDENTIFIER);
1795     }
1796 
1797     function get(Config storage self, Set storage item, bytes32 _salt) private view returns (bytes32[] result) {
1798         uint valuesCount = count(self, item, _salt);
1799         result = new bytes32[](valuesCount);
1800         for (uint i = 0; i < valuesCount; i++) {
1801             result[i] = get(self, item, _salt, i);
1802         }
1803     }
1804 
1805     function get(Config storage self, AddressesSet storage item) internal view returns (address[]) {
1806         return toAddresses(get(self, item.innerSet));
1807     }
1808 
1809     function get(Config storage self, CounterSet storage item) internal view returns (uint[]) {
1810         return toUInt(get(self, item.innerSet));
1811     }
1812 
1813     function get(Config storage self, Bytes32SetMapping storage item, bytes32 _key) internal view returns (bytes32[]) {
1814         return get(self, item.innerMapping, _key);
1815     }
1816 
1817     function get(Config storage self, AddressesSetMapping storage item, bytes32 _key) internal view returns (address[]) {
1818         return toAddresses(get(self, item.innerMapping, _key));
1819     }
1820 
1821     function get(Config storage self, UIntSetMapping storage item, bytes32 _key) internal view returns (uint[]) {
1822         return toUInt(get(self, item.innerMapping, _key));
1823     }
1824 
1825     function get(Config storage self, Set storage item, uint _index) internal view returns (bytes32) {
1826         return get(self, item, SET_IDENTIFIER, _index);
1827     }
1828 
1829     function get(Config storage self, Set storage item, bytes32 _salt, uint _index) private view returns (bytes32) {
1830         return get(self, item.values, _salt, bytes32(_index+1));
1831     }
1832 
1833     function get(Config storage self, AddressesSet storage item, uint _index) internal view returns (address) {
1834         return address(get(self, item.innerSet, _index));
1835     }
1836 
1837     function get(Config storage self, CounterSet storage item, uint _index) internal view returns (uint) {
1838         return uint(get(self, item.innerSet, _index));
1839     }
1840 
1841     function get(Config storage self, Bytes32SetMapping storage item, bytes32 _key, uint _index) internal view returns (bytes32) {
1842         return get(self, item.innerMapping, _key, _index);
1843     }
1844 
1845     function get(Config storage self, AddressesSetMapping storage item, bytes32 _key, uint _index) internal view returns (address) {
1846         return address(get(self, item.innerMapping, _key, _index));
1847     }
1848 
1849     function get(Config storage self, UIntSetMapping storage item, bytes32 _key, uint _index) internal view returns (uint) {
1850         return uint(get(self, item.innerMapping, _key, _index));
1851     }
1852 
1853     function getNextValue(Config storage self, OrderedSet storage item, bytes32 _value) internal view returns (bytes32) {
1854         return getNextValue(self, item, ORDERED_SET_IDENTIFIER, _value);
1855     }
1856 
1857     function getNextValue(Config storage self, OrderedSet storage item, bytes32 _salt, bytes32 _value) private view returns (bytes32) {
1858         return get(self, item.nextValues, _salt, _value);
1859     }
1860 
1861     function getNextValue(Config storage self, OrderedUIntSet storage item, uint _value) internal view returns (uint) {
1862         return uint(getNextValue(self, item.innerSet, bytes32(_value)));
1863     }
1864 
1865     function getNextValue(Config storage self, OrderedAddressesSet storage item, address _value) internal view returns (address) {
1866         return address(getNextValue(self, item.innerSet, bytes32(_value)));
1867     }
1868 
1869     function getPreviousValue(Config storage self, OrderedSet storage item, bytes32 _value) internal view returns (bytes32) {
1870         return getPreviousValue(self, item, ORDERED_SET_IDENTIFIER, _value);
1871     }
1872 
1873     function getPreviousValue(Config storage self, OrderedSet storage item, bytes32 _salt, bytes32 _value) private view returns (bytes32) {
1874         return get(self, item.previousValues, _salt, _value);
1875     }
1876 
1877     function getPreviousValue(Config storage self, OrderedUIntSet storage item, uint _value) internal view returns (uint) {
1878         return uint(getPreviousValue(self, item.innerSet, bytes32(_value)));
1879     }
1880 
1881     function getPreviousValue(Config storage self, OrderedAddressesSet storage item, address _value) internal view returns (address) {
1882         return address(getPreviousValue(self, item.innerSet, bytes32(_value)));
1883     }
1884 
1885     function toBool(bytes32 self) internal pure returns (bool) {
1886         return self != bytes32(0);
1887     }
1888 
1889     function toBytes32(bool self) internal pure returns (bytes32) {
1890         return bytes32(self ? 1 : 0);
1891     }
1892 
1893     function toAddresses(bytes32[] memory self) internal pure returns (address[]) {
1894         address[] memory result = new address[](self.length);
1895         for (uint i = 0; i < self.length; i++) {
1896             result[i] = address(self[i]);
1897         }
1898         return result;
1899     }
1900 
1901     function toUInt(bytes32[] memory self) internal pure returns (uint[]) {
1902         uint[] memory result = new uint[](self.length);
1903         for (uint i = 0; i < self.length; i++) {
1904             result[i] = uint(self[i]);
1905         }
1906         return result;
1907     }
1908 
1909     function _setOrderedSetLink(Config storage self, Mapping storage link, bytes32 _salt, bytes32 from, bytes32 to) private {
1910         if (from != 0x0) {
1911             set(self, link, _salt, from, to);
1912         }
1913     }
1914 
1915     function _deleteOrderedSetLink(Config storage self, Mapping storage link, bytes32 _salt, bytes32 from) private {
1916         if (from != 0x0) {
1917             set(self, link, _salt, from, 0x0);
1918         }
1919     }
1920 
1921     /** @title Structure to incapsulate and organize iteration through different kinds of collections */
1922     struct Iterator {
1923         uint limit;
1924         uint valuesLeft;
1925         bytes32 currentValue;
1926         bytes32 anchorKey;
1927     }
1928 
1929     function listIterator(Config storage self, OrderedSet storage item, bytes32 anchorKey, bytes32 startValue, uint limit) internal view returns (Iterator) {
1930         if (startValue == 0x0) {
1931             return listIterator(self, item, anchorKey, limit);
1932         }
1933 
1934         return createIterator(anchorKey, startValue, limit);
1935     }
1936 
1937     function listIterator(Config storage self, OrderedUIntSet storage item, bytes32 anchorKey, uint startValue, uint limit) internal view returns (Iterator) {
1938         return listIterator(self, item.innerSet, anchorKey, bytes32(startValue), limit);
1939     }
1940 
1941     function listIterator(Config storage self, OrderedAddressesSet storage item, bytes32 anchorKey, address startValue, uint limit) internal view returns (Iterator) {
1942         return listIterator(self, item.innerSet, anchorKey, bytes32(startValue), limit);
1943     }
1944 
1945     function listIterator(Config storage self, OrderedSet storage item, uint limit) internal view returns (Iterator) {
1946         return listIterator(self, item, ORDERED_SET_IDENTIFIER, limit);
1947     }
1948 
1949     function listIterator(Config storage self, OrderedSet storage item, bytes32 anchorKey, uint limit) internal view returns (Iterator) {
1950         return createIterator(anchorKey, get(self, item.first, anchorKey), limit);
1951     }
1952 
1953     function listIterator(Config storage self, OrderedUIntSet storage item, uint limit) internal view returns (Iterator) {
1954         return listIterator(self, item.innerSet, limit);
1955     }
1956 
1957     function listIterator(Config storage self, OrderedUIntSet storage item, bytes32 anchorKey, uint limit) internal view returns (Iterator) {
1958         return listIterator(self, item.innerSet, anchorKey, limit);
1959     }
1960 
1961     function listIterator(Config storage self, OrderedAddressesSet storage item, uint limit) internal view returns (Iterator) {
1962         return listIterator(self, item.innerSet, limit);
1963     }
1964 
1965     function listIterator(Config storage self, OrderedAddressesSet storage item, uint limit, bytes32 anchorKey) internal view returns (Iterator) {
1966         return listIterator(self, item.innerSet, anchorKey, limit);
1967     }
1968 
1969     function listIterator(Config storage self, OrderedSet storage item) internal view returns (Iterator) {
1970         return listIterator(self, item, ORDERED_SET_IDENTIFIER);
1971     }
1972 
1973     function listIterator(Config storage self, OrderedSet storage item, bytes32 anchorKey) internal view returns (Iterator) {
1974         return listIterator(self, item, anchorKey, get(self, item.count, anchorKey));
1975     }
1976 
1977     function listIterator(Config storage self, OrderedUIntSet storage item) internal view returns (Iterator) {
1978         return listIterator(self, item.innerSet);
1979     }
1980 
1981     function listIterator(Config storage self, OrderedUIntSet storage item, bytes32 anchorKey) internal view returns (Iterator) {
1982         return listIterator(self, item.innerSet, anchorKey);
1983     }
1984 
1985     function listIterator(Config storage self, OrderedAddressesSet storage item) internal view returns (Iterator) {
1986         return listIterator(self, item.innerSet);
1987     }
1988 
1989     function listIterator(Config storage self, OrderedAddressesSet storage item, bytes32 anchorKey) internal view returns (Iterator) {
1990         return listIterator(self, item.innerSet, anchorKey);
1991     }
1992 
1993     function listIterator(Config storage self, Bytes32OrderedSetMapping storage item, bytes32 _key) internal view returns (Iterator) {
1994         return listIterator(self, item.innerMapping, _key);
1995     }
1996 
1997     function listIterator(Config storage self, UIntOrderedSetMapping storage item, bytes32 _key) internal view returns (Iterator) {
1998         return listIterator(self, item.innerMapping, _key);
1999     }
2000 
2001     function listIterator(Config storage self, AddressOrderedSetMapping storage item, bytes32 _key) internal view returns (Iterator) {
2002         return listIterator(self, item.innerMapping, _key);
2003     }
2004 
2005     function createIterator(bytes32 anchorKey, bytes32 startValue, uint limit) internal pure returns (Iterator) {
2006         return Iterator({
2007             currentValue: startValue,
2008             limit: limit,
2009             valuesLeft: limit,
2010             anchorKey: anchorKey
2011         });
2012     }
2013 
2014     function getNextWithIterator(Config storage self, OrderedSet storage item, Iterator iterator) internal view returns (bytes32 _nextValue) {
2015         if (!canGetNextWithIterator(self, item, iterator)) { revert(); }
2016 
2017         _nextValue = iterator.currentValue;
2018 
2019         iterator.currentValue = getNextValue(self, item, iterator.anchorKey, iterator.currentValue);
2020         iterator.valuesLeft -= 1;
2021     }
2022 
2023     function getNextWithIterator(Config storage self, OrderedUIntSet storage item, Iterator iterator) internal view returns (uint _nextValue) {
2024         return uint(getNextWithIterator(self, item.innerSet, iterator));
2025     }
2026 
2027     function getNextWithIterator(Config storage self, OrderedAddressesSet storage item, Iterator iterator) internal view returns (address _nextValue) {
2028         return address(getNextWithIterator(self, item.innerSet, iterator));
2029     }
2030 
2031     function getNextWithIterator(Config storage self, Bytes32OrderedSetMapping storage item, Iterator iterator) internal view returns (bytes32 _nextValue) {
2032         return getNextWithIterator(self, item.innerMapping, iterator);
2033     }
2034 
2035     function getNextWithIterator(Config storage self, UIntOrderedSetMapping storage item, Iterator iterator) internal view returns (uint _nextValue) {
2036         return uint(getNextWithIterator(self, item.innerMapping, iterator));
2037     }
2038 
2039     function getNextWithIterator(Config storage self, AddressOrderedSetMapping storage item, Iterator iterator) internal view returns (address _nextValue) {
2040         return address(getNextWithIterator(self, item.innerMapping, iterator));
2041     }
2042 
2043     function canGetNextWithIterator(Config storage self, OrderedSet storage item, Iterator iterator) internal view returns (bool) {
2044         if (iterator.valuesLeft == 0 || !includes(self, item, iterator.anchorKey, iterator.currentValue)) {
2045             return false;
2046         }
2047 
2048         return true;
2049     }
2050 
2051     function canGetNextWithIterator(Config storage self, OrderedUIntSet storage item, Iterator iterator) internal view returns (bool) {
2052         return canGetNextWithIterator(self, item.innerSet, iterator);
2053     }
2054 
2055     function canGetNextWithIterator(Config storage self, OrderedAddressesSet storage item, Iterator iterator) internal view returns (bool) {
2056         return canGetNextWithIterator(self, item.innerSet, iterator);
2057     }
2058 
2059     function canGetNextWithIterator(Config storage self, Bytes32OrderedSetMapping storage item, Iterator iterator) internal view returns (bool) {
2060         return canGetNextWithIterator(self, item.innerMapping, iterator);
2061     }
2062 
2063     function canGetNextWithIterator(Config storage self, UIntOrderedSetMapping storage item, Iterator iterator) internal view returns (bool) {
2064         return canGetNextWithIterator(self, item.innerMapping, iterator);
2065     }
2066 
2067     function canGetNextWithIterator(Config storage self, AddressOrderedSetMapping storage item, Iterator iterator) internal view returns (bool) {
2068         return canGetNextWithIterator(self, item.innerMapping, iterator);
2069     }
2070 
2071     function count(Iterator iterator) internal pure returns (uint) {
2072         return iterator.valuesLeft;
2073     }
2074 }
2075 
2076 // File: @laborx/solidity-storage-lib/contracts/StorageAdapter.sol
2077 
2078 /**
2079  * Copyright 2017–2018, LaborX PTY
2080  * Licensed under the AGPL Version 3 license.
2081  */
2082 
2083 pragma solidity ^0.4.23;
2084 
2085 
2086 
2087 contract StorageAdapter {
2088 
2089     using StorageInterface for *;
2090 
2091     StorageInterface.Config internal store;
2092 
2093     constructor(Storage _store, bytes32 _crate) public {
2094         store.init(_store, _crate);
2095     }
2096 }
2097 
2098 // File: contracts/providers/AllowanceProxyProvider.sol
2099 
2100 /**
2101 * Copyright 2017–2018, LaborX PTY
2102 * Licensed under the AGPL Version 3 license.
2103 */
2104 
2105 pragma solidity ^0.4.21;
2106 
2107 
2108 
2109 
2110 
2111 contract AllowanceProxyProvider is Owned, StorageAdapter {
2112 
2113     uint constant OK = 1;
2114 
2115     StorageInterface.AddressesSet private allowanceProxiesStorage;
2116 
2117     constructor(Storage _platform, bytes32 _crate)
2118     StorageAdapter(_platform, _crate)
2119     public
2120     {
2121         allowanceProxiesStorage.init("allowanceProxies");
2122     }
2123 
2124     function addAllowanceProxy(address _allowanceProxy)
2125     external
2126     onlyContractOwner
2127     returns (uint)
2128     {
2129         store.add(allowanceProxiesStorage, _allowanceProxy);
2130         return OK;
2131     }
2132 
2133     function removeAllowanceProxy(address _allowanceProxy)
2134     external
2135     onlyContractOwner
2136     returns (uint)
2137     {
2138         store.remove(allowanceProxiesStorage, _allowanceProxy);
2139         return OK;
2140     }
2141 
2142     function isAllowanceProxy(address _checkProxy)
2143     public
2144     view
2145     returns (bool)
2146     {
2147         return store.includes(allowanceProxiesStorage, _checkProxy);
2148     }
2149 }