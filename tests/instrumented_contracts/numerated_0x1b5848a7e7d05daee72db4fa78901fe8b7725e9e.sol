1 // Full Contract Sources : https://github.com/DigixGlobal/dao-contracts
2 // File: @digix/cacp-contracts-dao/contracts/ACOwned.sol
3 pragma solidity ^0.4.25;
4 /// @title Owner based access control
5 /// @author DigixGlobal
6 contract ACOwned {
7 
8   address public owner;
9   address public new_owner;
10   bool is_ac_owned_init;
11 
12   /// @dev Modifier to check if msg.sender is the contract owner
13   modifier if_owner() {
14     require(is_owner());
15     _;
16   }
17 
18   function init_ac_owned()
19            internal
20            returns (bool _success)
21   {
22     if (is_ac_owned_init == false) {
23       owner = msg.sender;
24       is_ac_owned_init = true;
25     }
26     _success = true;
27   }
28 
29   function is_owner()
30            private
31            constant
32            returns (bool _is_owner)
33   {
34     _is_owner = (msg.sender == owner);
35   }
36 
37   function change_owner(address _new_owner)
38            if_owner()
39            public
40            returns (bool _success)
41   {
42     new_owner = _new_owner;
43     _success = true;
44   }
45 
46   function claim_ownership()
47            public
48            returns (bool _success)
49   {
50     require(msg.sender == new_owner);
51     owner = new_owner;
52     _success = true;
53   }
54 }
55 
56 // File: @digix/cacp-contracts-dao/contracts/Constants.sol
57 /// @title Some useful constants
58 /// @author DigixGlobal
59 contract Constants {
60   address constant NULL_ADDRESS = address(0x0);
61   uint256 constant ZERO = uint256(0);
62   bytes32 constant EMPTY = bytes32(0x0);
63 }
64 
65 // File: @digix/cacp-contracts-dao/contracts/ContractResolver.sol
66 /// @title Contract Name Registry
67 /// @author DigixGlobal
68 contract ContractResolver is ACOwned, Constants {
69 
70   mapping (bytes32 => address) contracts;
71   bool public locked_forever;
72 
73   modifier unless_registered(bytes32 _key) {
74     require(contracts[_key] == NULL_ADDRESS);
75     _;
76   }
77 
78   modifier if_owner_origin() {
79     require(tx.origin == owner);
80     _;
81   }
82 
83   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
84   /// @param _contract The resolver key
85   modifier if_sender_is(bytes32 _contract) {
86     require(msg.sender == get_contract(_contract));
87     _;
88   }
89 
90   modifier if_not_locked() {
91     require(locked_forever == false);
92     _;
93   }
94 
95   /// @dev ContractResolver constructor will perform the following: 1. Set msg.sender as the contract owner.
96   constructor() public
97   {
98     require(init_ac_owned());
99     locked_forever = false;
100   }
101 
102   /// @dev Called at contract initialization
103   /// @param _key bytestring for CACP name
104   /// @param _contract_address The address of the contract to be registered
105   /// @return _success if the operation is successful
106   function init_register_contract(bytes32 _key, address _contract_address)
107            if_owner_origin()
108            if_not_locked()
109            unless_registered(_key)
110            public
111            returns (bool _success)
112   {
113     require(_contract_address != NULL_ADDRESS);
114     contracts[_key] = _contract_address;
115     _success = true;
116   }
117 
118   /// @dev Lock the resolver from any further modifications.  This can only be called from the owner
119   /// @return _success if the operation is successful
120   function lock_resolver_forever()
121            if_owner
122            public
123            returns (bool _success)
124   {
125     locked_forever = true;
126     _success = true;
127   }
128 
129   /// @dev Get address of a contract
130   /// @param _key the bytestring name of the contract to look up
131   /// @return _contract the address of the contract
132   function get_contract(bytes32 _key)
133            public
134            view
135            returns (address _contract)
136   {
137     require(contracts[_key] != NULL_ADDRESS);
138     _contract = contracts[_key];
139   }
140 }
141 
142 // File: @digix/cacp-contracts-dao/contracts/ResolverClient.sol
143 /// @title Contract Resolver Interface
144 /// @author DigixGlobal
145 contract ResolverClient {
146 
147   /// The address of the resolver contract for this project
148   address public resolver;
149   bytes32 public key;
150 
151   /// Make our own address available to us as a constant
152   address public CONTRACT_ADDRESS;
153 
154   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
155   /// @param _contract The resolver key
156   modifier if_sender_is(bytes32 _contract) {
157     require(sender_is(_contract));
158     _;
159   }
160 
161   function sender_is(bytes32 _contract) internal view returns (bool _isFrom) {
162     _isFrom = msg.sender == ContractResolver(resolver).get_contract(_contract);
163   }
164 
165   modifier if_sender_is_from(bytes32[3] _contracts) {
166     require(sender_is_from(_contracts));
167     _;
168   }
169 
170   function sender_is_from(bytes32[3] _contracts) internal view returns (bool _isFrom) {
171     uint256 _n = _contracts.length;
172     for (uint256 i = 0; i < _n; i++) {
173       if (_contracts[i] == bytes32(0x0)) continue;
174       if (msg.sender == ContractResolver(resolver).get_contract(_contracts[i])) {
175         _isFrom = true;
176         break;
177       }
178     }
179   }
180 
181   /// Function modifier to check resolver's locking status.
182   modifier unless_resolver_is_locked() {
183     require(is_locked() == false);
184     _;
185   }
186 
187   /// @dev Initialize new contract
188   /// @param _key the resolver key for this contract
189   /// @return _success if the initialization is successful
190   function init(bytes32 _key, address _resolver)
191            internal
192            returns (bool _success)
193   {
194     bool _is_locked = ContractResolver(_resolver).locked_forever();
195     if (_is_locked == false) {
196       CONTRACT_ADDRESS = address(this);
197       resolver = _resolver;
198       key = _key;
199       require(ContractResolver(resolver).init_register_contract(key, CONTRACT_ADDRESS));
200       _success = true;
201     }  else {
202       _success = false;
203     }
204   }
205 
206   /// @dev Check if resolver is locked
207   /// @return _locked if the resolver is currently locked
208   function is_locked()
209            private
210            view
211            returns (bool _locked)
212   {
213     _locked = ContractResolver(resolver).locked_forever();
214   }
215 
216   /// @dev Get the address of a contract
217   /// @param _key the resolver key to look up
218   /// @return _contract the address of the contract
219   function get_contract(bytes32 _key)
220            public
221            view
222            returns (address _contract)
223   {
224     _contract = ContractResolver(resolver).get_contract(_key);
225   }
226 }
227 
228 // File: @digix/solidity-collections/contracts/lib/DoublyLinkedList.sol
229 library DoublyLinkedList {
230 
231   struct Item {
232     bytes32 item;
233     uint256 previous_index;
234     uint256 next_index;
235   }
236 
237   struct Data {
238     uint256 first_index;
239     uint256 last_index;
240     uint256 count;
241     mapping(bytes32 => uint256) item_index;
242     mapping(uint256 => bool) valid_indexes;
243     Item[] collection;
244   }
245 
246   struct IndexedUint {
247     mapping(bytes32 => Data) data;
248   }
249 
250   struct IndexedAddress {
251     mapping(bytes32 => Data) data;
252   }
253 
254   struct IndexedBytes {
255     mapping(bytes32 => Data) data;
256   }
257 
258   struct Address {
259     Data data;
260   }
261 
262   struct Bytes {
263     Data data;
264   }
265 
266   struct Uint {
267     Data data;
268   }
269 
270   uint256 constant NONE = uint256(0);
271   bytes32 constant EMPTY_BYTES = bytes32(0x0);
272   address constant NULL_ADDRESS = address(0x0);
273 
274   function find(Data storage self, bytes32 _item)
275            public
276            constant
277            returns (uint256 _item_index)
278   {
279     if ((self.item_index[_item] == NONE) && (self.count == NONE)) {
280       _item_index = NONE;
281     } else {
282       _item_index = self.item_index[_item];
283     }
284   }
285 
286   function get(Data storage self, uint256 _item_index)
287            public
288            constant
289            returns (bytes32 _item)
290   {
291     if (self.valid_indexes[_item_index] == true) {
292       _item = self.collection[_item_index - 1].item;
293     } else {
294       _item = EMPTY_BYTES;
295     }
296   }
297 
298   function append(Data storage self, bytes32 _data)
299            internal
300            returns (bool _success)
301   {
302     if (find(self, _data) != NONE || _data == bytes32("")) { // rejects addition of empty values
303       _success = false;
304     } else {
305       uint256 _index = uint256(self.collection.push(Item({item: _data, previous_index: self.last_index, next_index: NONE})));
306       if (self.last_index == NONE) {
307         if ((self.first_index != NONE) || (self.count != NONE)) {
308           revert();
309         } else {
310           self.first_index = self.last_index = _index;
311           self.count = 1;
312         }
313       } else {
314         self.collection[self.last_index - 1].next_index = _index;
315         self.last_index = _index;
316         self.count++;
317       }
318       self.valid_indexes[_index] = true;
319       self.item_index[_data] = _index;
320       _success = true;
321     }
322   }
323 
324   function remove(Data storage self, uint256 _index)
325            internal
326            returns (bool _success)
327   {
328     if (self.valid_indexes[_index] == true) {
329       Item memory item = self.collection[_index - 1];
330       if (item.previous_index == NONE) {
331         self.first_index = item.next_index;
332       } else {
333         self.collection[item.previous_index - 1].next_index = item.next_index;
334       }
335 
336       if (item.next_index == NONE) {
337         self.last_index = item.previous_index;
338       } else {
339         self.collection[item.next_index - 1].previous_index = item.previous_index;
340       }
341       delete self.collection[_index - 1];
342       self.valid_indexes[_index] = false;
343       delete self.item_index[item.item];
344       self.count--;
345       _success = true;
346     } else {
347       _success = false;
348     }
349   }
350 
351   function remove_item(Data storage self, bytes32 _item)
352            internal
353            returns (bool _success)
354   {
355     uint256 _item_index = find(self, _item);
356     if (_item_index != NONE) {
357       require(remove(self, _item_index));
358       _success = true;
359     } else {
360       _success = false;
361     }
362     return _success;
363   }
364 
365   function total(Data storage self)
366            public
367            constant
368            returns (uint256 _total_count)
369   {
370     _total_count = self.count;
371   }
372 
373   function start(Data storage self)
374            public
375            constant
376            returns (uint256 _item_index)
377   {
378     _item_index = self.first_index;
379     return _item_index;
380   }
381 
382   function start_item(Data storage self)
383            public
384            constant
385            returns (bytes32 _item)
386   {
387     uint256 _item_index = start(self);
388     if (_item_index != NONE) {
389       _item = get(self, _item_index);
390     } else {
391       _item = EMPTY_BYTES;
392     }
393   }
394 
395   function end(Data storage self)
396            public
397            constant
398            returns (uint256 _item_index)
399   {
400     _item_index = self.last_index;
401     return _item_index;
402   }
403 
404   function end_item(Data storage self)
405            public
406            constant
407            returns (bytes32 _item)
408   {
409     uint256 _item_index = end(self);
410     if (_item_index != NONE) {
411       _item = get(self, _item_index);
412     } else {
413       _item = EMPTY_BYTES;
414     }
415   }
416 
417   function valid(Data storage self, uint256 _item_index)
418            public
419            constant
420            returns (bool _yes)
421   {
422     _yes = self.valid_indexes[_item_index];
423     //_yes = ((_item_index - 1) < self.collection.length);
424   }
425 
426   function valid_item(Data storage self, bytes32 _item)
427            public
428            constant
429            returns (bool _yes)
430   {
431     uint256 _item_index = self.item_index[_item];
432     _yes = self.valid_indexes[_item_index];
433   }
434 
435   function previous(Data storage self, uint256 _current_index)
436            public
437            constant
438            returns (uint256 _previous_index)
439   {
440     if (self.valid_indexes[_current_index] == true) {
441       _previous_index = self.collection[_current_index - 1].previous_index;
442     } else {
443       _previous_index = NONE;
444     }
445   }
446 
447   function previous_item(Data storage self, bytes32 _current_item)
448            public
449            constant
450            returns (bytes32 _previous_item)
451   {
452     uint256 _current_index = find(self, _current_item);
453     if (_current_index != NONE) {
454       uint256 _previous_index = previous(self, _current_index);
455       _previous_item = get(self, _previous_index);
456     } else {
457       _previous_item = EMPTY_BYTES;
458     }
459   }
460 
461   function next(Data storage self, uint256 _current_index)
462            public
463            constant
464            returns (uint256 _next_index)
465   {
466     if (self.valid_indexes[_current_index] == true) {
467       _next_index = self.collection[_current_index - 1].next_index;
468     } else {
469       _next_index = NONE;
470     }
471   }
472 
473   function next_item(Data storage self, bytes32 _current_item)
474            public
475            constant
476            returns (bytes32 _next_item)
477   {
478     uint256 _current_index = find(self, _current_item);
479     if (_current_index != NONE) {
480       uint256 _next_index = next(self, _current_index);
481       _next_item = get(self, _next_index);
482     } else {
483       _next_item = EMPTY_BYTES;
484     }
485   }
486 
487   function find(Uint storage self, uint256 _item)
488            public
489            constant
490            returns (uint256 _item_index)
491   {
492     _item_index = find(self.data, bytes32(_item));
493   }
494 
495   function get(Uint storage self, uint256 _item_index)
496            public
497            constant
498            returns (uint256 _item)
499   {
500     _item = uint256(get(self.data, _item_index));
501   }
502 
503 
504   function append(Uint storage self, uint256 _data)
505            public
506            returns (bool _success)
507   {
508     _success = append(self.data, bytes32(_data));
509   }
510 
511   function remove(Uint storage self, uint256 _index)
512            internal
513            returns (bool _success)
514   {
515     _success = remove(self.data, _index);
516   }
517 
518   function remove_item(Uint storage self, uint256 _item)
519            public
520            returns (bool _success)
521   {
522     _success = remove_item(self.data, bytes32(_item));
523   }
524 
525   function total(Uint storage self)
526            public
527            constant
528            returns (uint256 _total_count)
529   {
530     _total_count = total(self.data);
531   }
532 
533   function start(Uint storage self)
534            public
535            constant
536            returns (uint256 _index)
537   {
538     _index = start(self.data);
539   }
540 
541   function start_item(Uint storage self)
542            public
543            constant
544            returns (uint256 _start_item)
545   {
546     _start_item = uint256(start_item(self.data));
547   }
548 
549 
550   function end(Uint storage self)
551            public
552            constant
553            returns (uint256 _index)
554   {
555     _index = end(self.data);
556   }
557 
558   function end_item(Uint storage self)
559            public
560            constant
561            returns (uint256 _end_item)
562   {
563     _end_item = uint256(end_item(self.data));
564   }
565 
566   function valid(Uint storage self, uint256 _item_index)
567            public
568            constant
569            returns (bool _yes)
570   {
571     _yes = valid(self.data, _item_index);
572   }
573 
574   function valid_item(Uint storage self, uint256 _item)
575            public
576            constant
577            returns (bool _yes)
578   {
579     _yes = valid_item(self.data, bytes32(_item));
580   }
581 
582   function previous(Uint storage self, uint256 _current_index)
583            public
584            constant
585            returns (uint256 _previous_index)
586   {
587     _previous_index = previous(self.data, _current_index);
588   }
589 
590   function previous_item(Uint storage self, uint256 _current_item)
591            public
592            constant
593            returns (uint256 _previous_item)
594   {
595     _previous_item = uint256(previous_item(self.data, bytes32(_current_item)));
596   }
597 
598   function next(Uint storage self, uint256 _current_index)
599            public
600            constant
601            returns (uint256 _next_index)
602   {
603     _next_index = next(self.data, _current_index);
604   }
605 
606   function next_item(Uint storage self, uint256 _current_item)
607            public
608            constant
609            returns (uint256 _next_item)
610   {
611     _next_item = uint256(next_item(self.data, bytes32(_current_item)));
612   }
613 
614   function find(Address storage self, address _item)
615            public
616            constant
617            returns (uint256 _item_index)
618   {
619     _item_index = find(self.data, bytes32(_item));
620   }
621 
622   function get(Address storage self, uint256 _item_index)
623            public
624            constant
625            returns (address _item)
626   {
627     _item = address(get(self.data, _item_index));
628   }
629 
630 
631   function find(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
632            public
633            constant
634            returns (uint256 _item_index)
635   {
636     _item_index = find(self.data[_collection_index], bytes32(_item));
637   }
638 
639   function get(IndexedUint storage self, bytes32 _collection_index, uint256 _item_index)
640            public
641            constant
642            returns (uint256 _item)
643   {
644     _item = uint256(get(self.data[_collection_index], _item_index));
645   }
646 
647 
648   function append(IndexedUint storage self, bytes32 _collection_index, uint256 _data)
649            public
650            returns (bool _success)
651   {
652     _success = append(self.data[_collection_index], bytes32(_data));
653   }
654 
655   function remove(IndexedUint storage self, bytes32 _collection_index, uint256 _index)
656            internal
657            returns (bool _success)
658   {
659     _success = remove(self.data[_collection_index], _index);
660   }
661 
662   function remove_item(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
663            public
664            returns (bool _success)
665   {
666     _success = remove_item(self.data[_collection_index], bytes32(_item));
667   }
668 
669   function total(IndexedUint storage self, bytes32 _collection_index)
670            public
671            constant
672            returns (uint256 _total_count)
673   {
674     _total_count = total(self.data[_collection_index]);
675   }
676 
677   function start(IndexedUint storage self, bytes32 _collection_index)
678            public
679            constant
680            returns (uint256 _index)
681   {
682     _index = start(self.data[_collection_index]);
683   }
684 
685   function start_item(IndexedUint storage self, bytes32 _collection_index)
686            public
687            constant
688            returns (uint256 _start_item)
689   {
690     _start_item = uint256(start_item(self.data[_collection_index]));
691   }
692 
693 
694   function end(IndexedUint storage self, bytes32 _collection_index)
695            public
696            constant
697            returns (uint256 _index)
698   {
699     _index = end(self.data[_collection_index]);
700   }
701 
702   function end_item(IndexedUint storage self, bytes32 _collection_index)
703            public
704            constant
705            returns (uint256 _end_item)
706   {
707     _end_item = uint256(end_item(self.data[_collection_index]));
708   }
709 
710   function valid(IndexedUint storage self, bytes32 _collection_index, uint256 _item_index)
711            public
712            constant
713            returns (bool _yes)
714   {
715     _yes = valid(self.data[_collection_index], _item_index);
716   }
717 
718   function valid_item(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
719            public
720            constant
721            returns (bool _yes)
722   {
723     _yes = valid_item(self.data[_collection_index], bytes32(_item));
724   }
725 
726   function previous(IndexedUint storage self, bytes32 _collection_index, uint256 _current_index)
727            public
728            constant
729            returns (uint256 _previous_index)
730   {
731     _previous_index = previous(self.data[_collection_index], _current_index);
732   }
733 
734   function previous_item(IndexedUint storage self, bytes32 _collection_index, uint256 _current_item)
735            public
736            constant
737            returns (uint256 _previous_item)
738   {
739     _previous_item = uint256(previous_item(self.data[_collection_index], bytes32(_current_item)));
740   }
741 
742   function next(IndexedUint storage self, bytes32 _collection_index, uint256 _current_index)
743            public
744            constant
745            returns (uint256 _next_index)
746   {
747     _next_index = next(self.data[_collection_index], _current_index);
748   }
749 
750   function next_item(IndexedUint storage self, bytes32 _collection_index, uint256 _current_item)
751            public
752            constant
753            returns (uint256 _next_item)
754   {
755     _next_item = uint256(next_item(self.data[_collection_index], bytes32(_current_item)));
756   }
757 
758   function append(Address storage self, address _data)
759            public
760            returns (bool _success)
761   {
762     _success = append(self.data, bytes32(_data));
763   }
764 
765   function remove(Address storage self, uint256 _index)
766            internal
767            returns (bool _success)
768   {
769     _success = remove(self.data, _index);
770   }
771 
772 
773   function remove_item(Address storage self, address _item)
774            public
775            returns (bool _success)
776   {
777     _success = remove_item(self.data, bytes32(_item));
778   }
779 
780   function total(Address storage self)
781            public
782            constant
783            returns (uint256 _total_count)
784   {
785     _total_count = total(self.data);
786   }
787 
788   function start(Address storage self)
789            public
790            constant
791            returns (uint256 _index)
792   {
793     _index = start(self.data);
794   }
795 
796   function start_item(Address storage self)
797            public
798            constant
799            returns (address _start_item)
800   {
801     _start_item = address(start_item(self.data));
802   }
803 
804 
805   function end(Address storage self)
806            public
807            constant
808            returns (uint256 _index)
809   {
810     _index = end(self.data);
811   }
812 
813   function end_item(Address storage self)
814            public
815            constant
816            returns (address _end_item)
817   {
818     _end_item = address(end_item(self.data));
819   }
820 
821   function valid(Address storage self, uint256 _item_index)
822            public
823            constant
824            returns (bool _yes)
825   {
826     _yes = valid(self.data, _item_index);
827   }
828 
829   function valid_item(Address storage self, address _item)
830            public
831            constant
832            returns (bool _yes)
833   {
834     _yes = valid_item(self.data, bytes32(_item));
835   }
836 
837   function previous(Address storage self, uint256 _current_index)
838            public
839            constant
840            returns (uint256 _previous_index)
841   {
842     _previous_index = previous(self.data, _current_index);
843   }
844 
845   function previous_item(Address storage self, address _current_item)
846            public
847            constant
848            returns (address _previous_item)
849   {
850     _previous_item = address(previous_item(self.data, bytes32(_current_item)));
851   }
852 
853   function next(Address storage self, uint256 _current_index)
854            public
855            constant
856            returns (uint256 _next_index)
857   {
858     _next_index = next(self.data, _current_index);
859   }
860 
861   function next_item(Address storage self, address _current_item)
862            public
863            constant
864            returns (address _next_item)
865   {
866     _next_item = address(next_item(self.data, bytes32(_current_item)));
867   }
868 
869   function append(IndexedAddress storage self, bytes32 _collection_index, address _data)
870            public
871            returns (bool _success)
872   {
873     _success = append(self.data[_collection_index], bytes32(_data));
874   }
875 
876   function remove(IndexedAddress storage self, bytes32 _collection_index, uint256 _index)
877            internal
878            returns (bool _success)
879   {
880     _success = remove(self.data[_collection_index], _index);
881   }
882 
883 
884   function remove_item(IndexedAddress storage self, bytes32 _collection_index, address _item)
885            public
886            returns (bool _success)
887   {
888     _success = remove_item(self.data[_collection_index], bytes32(_item));
889   }
890 
891   function total(IndexedAddress storage self, bytes32 _collection_index)
892            public
893            constant
894            returns (uint256 _total_count)
895   {
896     _total_count = total(self.data[_collection_index]);
897   }
898 
899   function start(IndexedAddress storage self, bytes32 _collection_index)
900            public
901            constant
902            returns (uint256 _index)
903   {
904     _index = start(self.data[_collection_index]);
905   }
906 
907   function start_item(IndexedAddress storage self, bytes32 _collection_index)
908            public
909            constant
910            returns (address _start_item)
911   {
912     _start_item = address(start_item(self.data[_collection_index]));
913   }
914 
915 
916   function end(IndexedAddress storage self, bytes32 _collection_index)
917            public
918            constant
919            returns (uint256 _index)
920   {
921     _index = end(self.data[_collection_index]);
922   }
923 
924   function end_item(IndexedAddress storage self, bytes32 _collection_index)
925            public
926            constant
927            returns (address _end_item)
928   {
929     _end_item = address(end_item(self.data[_collection_index]));
930   }
931 
932   function valid(IndexedAddress storage self, bytes32 _collection_index, uint256 _item_index)
933            public
934            constant
935            returns (bool _yes)
936   {
937     _yes = valid(self.data[_collection_index], _item_index);
938   }
939 
940   function valid_item(IndexedAddress storage self, bytes32 _collection_index, address _item)
941            public
942            constant
943            returns (bool _yes)
944   {
945     _yes = valid_item(self.data[_collection_index], bytes32(_item));
946   }
947 
948   function previous(IndexedAddress storage self, bytes32 _collection_index, uint256 _current_index)
949            public
950            constant
951            returns (uint256 _previous_index)
952   {
953     _previous_index = previous(self.data[_collection_index], _current_index);
954   }
955 
956   function previous_item(IndexedAddress storage self, bytes32 _collection_index, address _current_item)
957            public
958            constant
959            returns (address _previous_item)
960   {
961     _previous_item = address(previous_item(self.data[_collection_index], bytes32(_current_item)));
962   }
963 
964   function next(IndexedAddress storage self, bytes32 _collection_index, uint256 _current_index)
965            public
966            constant
967            returns (uint256 _next_index)
968   {
969     _next_index = next(self.data[_collection_index], _current_index);
970   }
971 
972   function next_item(IndexedAddress storage self, bytes32 _collection_index, address _current_item)
973            public
974            constant
975            returns (address _next_item)
976   {
977     _next_item = address(next_item(self.data[_collection_index], bytes32(_current_item)));
978   }
979 
980 
981   function find(Bytes storage self, bytes32 _item)
982            public
983            constant
984            returns (uint256 _item_index)
985   {
986     _item_index = find(self.data, _item);
987   }
988 
989   function get(Bytes storage self, uint256 _item_index)
990            public
991            constant
992            returns (bytes32 _item)
993   {
994     _item = get(self.data, _item_index);
995   }
996 
997 
998   function append(Bytes storage self, bytes32 _data)
999            public
1000            returns (bool _success)
1001   {
1002     _success = append(self.data, _data);
1003   }
1004 
1005   function remove(Bytes storage self, uint256 _index)
1006            internal
1007            returns (bool _success)
1008   {
1009     _success = remove(self.data, _index);
1010   }
1011 
1012 
1013   function remove_item(Bytes storage self, bytes32 _item)
1014            public
1015            returns (bool _success)
1016   {
1017     _success = remove_item(self.data, _item);
1018   }
1019 
1020   function total(Bytes storage self)
1021            public
1022            constant
1023            returns (uint256 _total_count)
1024   {
1025     _total_count = total(self.data);
1026   }
1027 
1028   function start(Bytes storage self)
1029            public
1030            constant
1031            returns (uint256 _index)
1032   {
1033     _index = start(self.data);
1034   }
1035 
1036   function start_item(Bytes storage self)
1037            public
1038            constant
1039            returns (bytes32 _start_item)
1040   {
1041     _start_item = start_item(self.data);
1042   }
1043 
1044 
1045   function end(Bytes storage self)
1046            public
1047            constant
1048            returns (uint256 _index)
1049   {
1050     _index = end(self.data);
1051   }
1052 
1053   function end_item(Bytes storage self)
1054            public
1055            constant
1056            returns (bytes32 _end_item)
1057   {
1058     _end_item = end_item(self.data);
1059   }
1060 
1061   function valid(Bytes storage self, uint256 _item_index)
1062            public
1063            constant
1064            returns (bool _yes)
1065   {
1066     _yes = valid(self.data, _item_index);
1067   }
1068 
1069   function valid_item(Bytes storage self, bytes32 _item)
1070            public
1071            constant
1072            returns (bool _yes)
1073   {
1074     _yes = valid_item(self.data, _item);
1075   }
1076 
1077   function previous(Bytes storage self, uint256 _current_index)
1078            public
1079            constant
1080            returns (uint256 _previous_index)
1081   {
1082     _previous_index = previous(self.data, _current_index);
1083   }
1084 
1085   function previous_item(Bytes storage self, bytes32 _current_item)
1086            public
1087            constant
1088            returns (bytes32 _previous_item)
1089   {
1090     _previous_item = previous_item(self.data, _current_item);
1091   }
1092 
1093   function next(Bytes storage self, uint256 _current_index)
1094            public
1095            constant
1096            returns (uint256 _next_index)
1097   {
1098     _next_index = next(self.data, _current_index);
1099   }
1100 
1101   function next_item(Bytes storage self, bytes32 _current_item)
1102            public
1103            constant
1104            returns (bytes32 _next_item)
1105   {
1106     _next_item = next_item(self.data, _current_item);
1107   }
1108 
1109   function append(IndexedBytes storage self, bytes32 _collection_index, bytes32 _data)
1110            public
1111            returns (bool _success)
1112   {
1113     _success = append(self.data[_collection_index], bytes32(_data));
1114   }
1115 
1116   function remove(IndexedBytes storage self, bytes32 _collection_index, uint256 _index)
1117            internal
1118            returns (bool _success)
1119   {
1120     _success = remove(self.data[_collection_index], _index);
1121   }
1122 
1123 
1124   function remove_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _item)
1125            public
1126            returns (bool _success)
1127   {
1128     _success = remove_item(self.data[_collection_index], bytes32(_item));
1129   }
1130 
1131   function total(IndexedBytes storage self, bytes32 _collection_index)
1132            public
1133            constant
1134            returns (uint256 _total_count)
1135   {
1136     _total_count = total(self.data[_collection_index]);
1137   }
1138 
1139   function start(IndexedBytes storage self, bytes32 _collection_index)
1140            public
1141            constant
1142            returns (uint256 _index)
1143   {
1144     _index = start(self.data[_collection_index]);
1145   }
1146 
1147   function start_item(IndexedBytes storage self, bytes32 _collection_index)
1148            public
1149            constant
1150            returns (bytes32 _start_item)
1151   {
1152     _start_item = bytes32(start_item(self.data[_collection_index]));
1153   }
1154 
1155 
1156   function end(IndexedBytes storage self, bytes32 _collection_index)
1157            public
1158            constant
1159            returns (uint256 _index)
1160   {
1161     _index = end(self.data[_collection_index]);
1162   }
1163 
1164   function end_item(IndexedBytes storage self, bytes32 _collection_index)
1165            public
1166            constant
1167            returns (bytes32 _end_item)
1168   {
1169     _end_item = bytes32(end_item(self.data[_collection_index]));
1170   }
1171 
1172   function valid(IndexedBytes storage self, bytes32 _collection_index, uint256 _item_index)
1173            public
1174            constant
1175            returns (bool _yes)
1176   {
1177     _yes = valid(self.data[_collection_index], _item_index);
1178   }
1179 
1180   function valid_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _item)
1181            public
1182            constant
1183            returns (bool _yes)
1184   {
1185     _yes = valid_item(self.data[_collection_index], bytes32(_item));
1186   }
1187 
1188   function previous(IndexedBytes storage self, bytes32 _collection_index, uint256 _current_index)
1189            public
1190            constant
1191            returns (uint256 _previous_index)
1192   {
1193     _previous_index = previous(self.data[_collection_index], _current_index);
1194   }
1195 
1196   function previous_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _current_item)
1197            public
1198            constant
1199            returns (bytes32 _previous_item)
1200   {
1201     _previous_item = bytes32(previous_item(self.data[_collection_index], bytes32(_current_item)));
1202   }
1203 
1204   function next(IndexedBytes storage self, bytes32 _collection_index, uint256 _current_index)
1205            public
1206            constant
1207            returns (uint256 _next_index)
1208   {
1209     _next_index = next(self.data[_collection_index], _current_index);
1210   }
1211 
1212   function next_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _current_item)
1213            public
1214            constant
1215            returns (bytes32 _next_item)
1216   {
1217     _next_item = bytes32(next_item(self.data[_collection_index], bytes32(_current_item)));
1218   }
1219 }
1220 
1221 // File: @digix/solidity-collections/contracts/abstract/IndexedAddressIteratorStorage.sol
1222 /**
1223   @title Indexed Address IteratorStorage
1224   @author DigixGlobal Pte Ltd
1225   @notice This contract utilizes: [Doubly Linked List](/DoublyLinkedList)
1226 */
1227 contract IndexedAddressIteratorStorage {
1228 
1229   using DoublyLinkedList for DoublyLinkedList.IndexedAddress;
1230   /**
1231     @notice Reads the first item from an Indexed Address Doubly Linked List
1232     @param _list The source list
1233     @param _collection_index Index of the Collection to evaluate
1234     @return {"_item" : "First item on the list"}
1235   */
1236   function read_first_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
1237            internal
1238            constant
1239            returns (address _item)
1240   {
1241     _item = _list.start_item(_collection_index);
1242   }
1243 
1244   /**
1245     @notice Reads the last item from an Indexed Address Doubly Linked list
1246     @param _list The source list
1247     @param _collection_index Index of the Collection to evaluate
1248     @return {"_item" : "First item on the list"}
1249   */
1250   function read_last_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
1251            internal
1252            constant
1253            returns (address _item)
1254   {
1255     _item = _list.end_item(_collection_index);
1256   }
1257 
1258   /**
1259     @notice Reads the next item from an Indexed Address Doubly Linked List based on the specified `_current_item`
1260     @param _list The source list
1261     @param _collection_index Index of the Collection to evaluate
1262     @param _current_item The current item to use as base line
1263     @return {"_item": "The next item on the list"}
1264   */
1265   function read_next_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index, address _current_item)
1266            internal
1267            constant
1268            returns (address _item)
1269   {
1270     _item = _list.next_item(_collection_index, _current_item);
1271   }
1272 
1273   /**
1274     @notice Reads the previous item from an Index Address Doubly Linked List based on the specified `_current_item`
1275     @param _list The source list
1276     @param _collection_index Index of the Collection to evaluate
1277     @param _current_item The current item to use as base line
1278     @return {"_item" : "The previous item on the list"}
1279   */
1280   function read_previous_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index, address _current_item)
1281            internal
1282            constant
1283            returns (address _item)
1284   {
1285     _item = _list.previous_item(_collection_index, _current_item);
1286   }
1287 
1288 
1289   /**
1290     @notice Reads the total number of items in an Indexed Address Doubly Linked List
1291     @param _list  The source list
1292     @param _collection_index Index of the Collection to evaluate
1293     @return {"_count": "Length of the Doubly Linked list"}
1294   */
1295   function read_total_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
1296            internal
1297            constant
1298            returns (uint256 _count)
1299   {
1300     _count = _list.total(_collection_index);
1301   }
1302 }
1303 
1304 // File: @digix/solidity-collections/contracts/abstract/UintIteratorStorage.sol
1305 /**
1306   @title Uint Iterator Storage
1307   @author DigixGlobal Pte Ltd
1308 */
1309 contract UintIteratorStorage {
1310 
1311   using DoublyLinkedList for DoublyLinkedList.Uint;
1312 
1313   /**
1314     @notice Returns the first item from a `DoublyLinkedList.Uint` list
1315     @param _list The DoublyLinkedList.Uint list
1316     @return {"_item": "The first item"}
1317   */
1318   function read_first_from_uints(DoublyLinkedList.Uint storage _list)
1319            internal
1320            constant
1321            returns (uint256 _item)
1322   {
1323     _item = _list.start_item();
1324   }
1325 
1326   /**
1327     @notice Returns the last item from a `DoublyLinkedList.Uint` list
1328     @param _list The DoublyLinkedList.Uint list
1329     @return {"_item": "The last item"}
1330   */
1331   function read_last_from_uints(DoublyLinkedList.Uint storage _list)
1332            internal
1333            constant
1334            returns (uint256 _item)
1335   {
1336     _item = _list.end_item();
1337   }
1338 
1339   /**
1340     @notice Returns the next item from a `DoublyLinkedList.Uint` list based on the specified `_current_item`
1341     @param _list The DoublyLinkedList.Uint list
1342     @param _current_item The current item
1343     @return {"_item": "The next item"}
1344   */
1345   function read_next_from_uints(DoublyLinkedList.Uint storage _list, uint256 _current_item)
1346            internal
1347            constant
1348            returns (uint256 _item)
1349   {
1350     _item = _list.next_item(_current_item);
1351   }
1352 
1353   /**
1354     @notice Returns the previous item from a `DoublyLinkedList.Uint` list based on the specified `_current_item`
1355     @param _list The DoublyLinkedList.Uint list
1356     @param _current_item The current item
1357     @return {"_item": "The previous item"}
1358   */
1359   function read_previous_from_uints(DoublyLinkedList.Uint storage _list, uint256 _current_item)
1360            internal
1361            constant
1362            returns (uint256 _item)
1363   {
1364     _item = _list.previous_item(_current_item);
1365   }
1366 
1367   /**
1368     @notice Returns the total count of itemsfrom a `DoublyLinkedList.Uint` list
1369     @param _list The DoublyLinkedList.Uint list
1370     @return {"_count": "The total count of items"}
1371   */
1372   function read_total_uints(DoublyLinkedList.Uint storage _list)
1373            internal
1374            constant
1375            returns (uint256 _count)
1376   {
1377     _count = _list.total();
1378   }
1379 }
1380 
1381 // File: @digix/cdap/contracts/storage/DirectoryStorage.sol
1382 /**
1383 @title Directory Storage contains information of a directory
1384 @author DigixGlobal
1385 */
1386 contract DirectoryStorage is IndexedAddressIteratorStorage, UintIteratorStorage {
1387 
1388   using DoublyLinkedList for DoublyLinkedList.IndexedAddress;
1389   using DoublyLinkedList for DoublyLinkedList.Uint;
1390 
1391   struct User {
1392     bytes32 document;
1393     bool active;
1394   }
1395 
1396   struct Group {
1397     bytes32 name;
1398     bytes32 document;
1399     uint256 role_id;
1400     mapping(address => User) members_by_address;
1401   }
1402 
1403   struct System {
1404     DoublyLinkedList.Uint groups;
1405     DoublyLinkedList.IndexedAddress groups_collection;
1406     mapping (uint256 => Group) groups_by_id;
1407     mapping (address => uint256) group_ids_by_address;
1408     mapping (uint256 => bytes32) roles_by_id;
1409     bool initialized;
1410     uint256 total_groups;
1411   }
1412 
1413   System system;
1414 
1415   /**
1416   @notice Initializes directory settings
1417   @return _success If directory initialization is successful
1418   */
1419   function initialize_directory()
1420            internal
1421            returns (bool _success)
1422   {
1423     require(system.initialized == false);
1424     system.total_groups = 0;
1425     system.initialized = true;
1426     internal_create_role(1, "root");
1427     internal_create_group(1, "root", "");
1428     _success = internal_update_add_user_to_group(1, tx.origin, "");
1429   }
1430 
1431   /**
1432   @notice Creates a new role with the given information
1433   @param _role_id Id of the new role
1434   @param _name Name of the new role
1435   @return {"_success": "If creation of new role is successful"}
1436   */
1437   function internal_create_role(uint256 _role_id, bytes32 _name)
1438            internal
1439            returns (bool _success)
1440   {
1441     require(_role_id > 0);
1442     require(_name != bytes32(0x0));
1443     system.roles_by_id[_role_id] = _name;
1444     _success = true;
1445   }
1446 
1447   /**
1448   @notice Returns the role's name of a role id
1449   @param _role_id Id of the role
1450   @return {"_name": "Name of the role"}
1451   */
1452   function read_role(uint256 _role_id)
1453            public
1454            constant
1455            returns (bytes32 _name)
1456   {
1457     _name = system.roles_by_id[_role_id];
1458   }
1459 
1460   /**
1461   @notice Creates a new group with the given information
1462   @param _role_id Role id of the new group
1463   @param _name Name of the new group
1464   @param _document Document of the new group
1465   @return {
1466     "_success": "If creation of the new group is successful",
1467     "_group_id: "Id of the new group"
1468   }
1469   */
1470   function internal_create_group(uint256 _role_id, bytes32 _name, bytes32 _document)
1471            internal
1472            returns (bool _success, uint256 _group_id)
1473   {
1474     require(_role_id > 0);
1475     require(read_role(_role_id) != bytes32(0x0));
1476     _group_id = ++system.total_groups;
1477     system.groups.append(_group_id);
1478     system.groups_by_id[_group_id].role_id = _role_id;
1479     system.groups_by_id[_group_id].name = _name;
1480     system.groups_by_id[_group_id].document = _document;
1481     _success = true;
1482   }
1483 
1484   /**
1485   @notice Returns the group's information
1486   @param _group_id Id of the group
1487   @return {
1488     "_role_id": "Role id of the group",
1489     "_name: "Name of the group",
1490     "_document: "Document of the group"
1491   }
1492   */
1493   function read_group(uint256 _group_id)
1494            public
1495            constant
1496            returns (uint256 _role_id, bytes32 _name, bytes32 _document, uint256 _members_count)
1497   {
1498     if (system.groups.valid_item(_group_id)) {
1499       _role_id = system.groups_by_id[_group_id].role_id;
1500       _name = system.groups_by_id[_group_id].name;
1501       _document = system.groups_by_id[_group_id].document;
1502       _members_count = read_total_indexed_addresses(system.groups_collection, bytes32(_group_id));
1503     } else {
1504       _role_id = 0;
1505       _name = "invalid";
1506       _document = "";
1507       _members_count = 0;
1508     }
1509   }
1510 
1511   /**
1512   @notice Adds new user with the given information to a group
1513   @param _group_id Id of the group
1514   @param _user Address of the new user
1515   @param _document Information of the new user
1516   @return {"_success": "If adding new user to a group is successful"}
1517   */
1518   function internal_update_add_user_to_group(uint256 _group_id, address _user, bytes32 _document)
1519            internal
1520            returns (bool _success)
1521   {
1522     if (system.groups_by_id[_group_id].members_by_address[_user].active == false && system.group_ids_by_address[_user] == 0 && system.groups_by_id[_group_id].role_id != 0) {
1523 
1524       system.groups_by_id[_group_id].members_by_address[_user].active = true;
1525       system.group_ids_by_address[_user] = _group_id;
1526       system.groups_collection.append(bytes32(_group_id), _user);
1527       system.groups_by_id[_group_id].members_by_address[_user].document = _document;
1528       _success = true;
1529     } else {
1530       _success = false;
1531     }
1532   }
1533 
1534   /**
1535   @notice Removes user from its group
1536   @param _user Address of the user
1537   @return {"_success": "If removing of user is successful"}
1538   */
1539   function internal_destroy_group_user(address _user)
1540            internal
1541            returns (bool _success)
1542   {
1543     uint256 _group_id = system.group_ids_by_address[_user];
1544     if ((_group_id == 1) && (system.groups_collection.total(bytes32(_group_id)) == 1)) {
1545       _success = false;
1546     } else {
1547       system.groups_by_id[_group_id].members_by_address[_user].active = false;
1548       system.group_ids_by_address[_user] = 0;
1549       delete system.groups_by_id[_group_id].members_by_address[_user];
1550       _success = system.groups_collection.remove_item(bytes32(_group_id), _user);
1551     }
1552   }
1553 
1554   /**
1555   @notice Returns the role id of a user
1556   @param _user Address of a user
1557   @return {"_role_id": "Role id of the user"}
1558   */
1559   function read_user_role_id(address _user)
1560            constant
1561            public
1562            returns (uint256 _role_id)
1563   {
1564     uint256 _group_id = system.group_ids_by_address[_user];
1565     _role_id = system.groups_by_id[_group_id].role_id;
1566   }
1567 
1568   /**
1569   @notice Returns the user's information
1570   @param _user Address of the user
1571   @return {
1572     "_group_id": "Group id of the user",
1573     "_role_id": "Role id of the user",
1574     "_document": "Information of the user"
1575   }
1576   */
1577   function read_user(address _user)
1578            public
1579            constant
1580            returns (uint256 _group_id, uint256 _role_id, bytes32 _document)
1581   {
1582     _group_id = system.group_ids_by_address[_user];
1583     _role_id = system.groups_by_id[_group_id].role_id;
1584     _document = system.groups_by_id[_group_id].members_by_address[_user].document;
1585   }
1586 
1587   /**
1588   @notice Returns the id of the first group
1589   @return {"_group_id": "Id of the first group"}
1590   */
1591   function read_first_group()
1592            view
1593            external
1594            returns (uint256 _group_id)
1595   {
1596     _group_id = read_first_from_uints(system.groups);
1597   }
1598 
1599   /**
1600   @notice Returns the id of the last group
1601   @return {"_group_id": "Id of the last group"}
1602   */
1603   function read_last_group()
1604            view
1605            external
1606            returns (uint256 _group_id)
1607   {
1608     _group_id = read_last_from_uints(system.groups);
1609   }
1610 
1611   /**
1612   @notice Returns the id of the previous group depending on the given current group
1613   @param _current_group_id Id of the current group
1614   @return {"_group_id": "Id of the previous group"}
1615   */
1616   function read_previous_group_from_group(uint256 _current_group_id)
1617            view
1618            external
1619            returns (uint256 _group_id)
1620   {
1621     _group_id = read_previous_from_uints(system.groups, _current_group_id);
1622   }
1623 
1624   /**
1625   @notice Returns the id of the next group depending on the given current group
1626   @param _current_group_id Id of the current group
1627   @return {"_group_id": "Id of the next group"}
1628   */
1629   function read_next_group_from_group(uint256 _current_group_id)
1630            view
1631            external
1632            returns (uint256 _group_id)
1633   {
1634     _group_id = read_next_from_uints(system.groups, _current_group_id);
1635   }
1636 
1637   /**
1638   @notice Returns the total number of groups
1639   @return {"_total_groups": "Total number of groups"}
1640   */
1641   function read_total_groups()
1642            view
1643            external
1644            returns (uint256 _total_groups)
1645   {
1646     _total_groups = read_total_uints(system.groups);
1647   }
1648 
1649   /**
1650   @notice Returns the first user of a group
1651   @param _group_id Id of the group
1652   @return {"_user": "Address of the user"}
1653   */
1654   function read_first_user_in_group(bytes32 _group_id)
1655            view
1656            external
1657            returns (address _user)
1658   {
1659     _user = read_first_from_indexed_addresses(system.groups_collection, bytes32(_group_id));
1660   }
1661 
1662   /**
1663   @notice Returns the last user of a group
1664   @param _group_id Id of the group
1665   @return {"_user": "Address of the user"}
1666   */
1667   function read_last_user_in_group(bytes32 _group_id)
1668            view
1669            external
1670            returns (address _user)
1671   {
1672     _user = read_last_from_indexed_addresses(system.groups_collection, bytes32(_group_id));
1673   }
1674 
1675   /**
1676   @notice Returns the next user of a group depending on the given current user
1677   @param _group_id Id of the group
1678   @param _current_user Address of the current user
1679   @return {"_user": "Address of the next user"}
1680   */
1681   function read_next_user_in_group(bytes32 _group_id, address _current_user)
1682            view
1683            external
1684            returns (address _user)
1685   {
1686     _user = read_next_from_indexed_addresses(system.groups_collection, bytes32(_group_id), _current_user);
1687   }
1688 
1689   /**
1690   @notice Returns the previous user of a group depending on the given current user
1691   @param _group_id Id of the group
1692   @param _current_user Address of the current user
1693   @return {"_user": "Address of the last user"}
1694   */
1695   function read_previous_user_in_group(bytes32 _group_id, address _current_user)
1696            view
1697            external
1698            returns (address _user)
1699   {
1700     _user = read_previous_from_indexed_addresses(system.groups_collection, bytes32(_group_id), _current_user);
1701   }
1702 
1703   /**
1704   @notice Returns the total number of users of a group
1705   @param _group_id Id of the group
1706   @return {"_total_users": "Total number of users"}
1707   */
1708   function read_total_users_in_group(bytes32 _group_id)
1709            view
1710            external
1711            returns (uint256 _total_users)
1712   {
1713     _total_users = read_total_indexed_addresses(system.groups_collection, bytes32(_group_id));
1714   }
1715 }
1716 
1717 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
1718 /**
1719  * @title SafeMath
1720  * @dev Math operations with safety checks that throw on error
1721  */
1722 library SafeMath {
1723 
1724   /**
1725   * @dev Multiplies two numbers, throws on overflow.
1726   */
1727   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1728     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1729     // benefit is lost if 'b' is also tested.
1730     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1731     if (_a == 0) {
1732       return 0;
1733     }
1734 
1735     c = _a * _b;
1736     assert(c / _a == _b);
1737     return c;
1738   }
1739 
1740   /**
1741   * @dev Integer division of two numbers, truncating the quotient.
1742   */
1743   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1744     // assert(_b > 0); // Solidity automatically throws when dividing by 0
1745     // uint256 c = _a / _b;
1746     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1747     return _a / _b;
1748   }
1749 
1750   /**
1751   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1752   */
1753   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1754     assert(_b <= _a);
1755     return _a - _b;
1756   }
1757 
1758   /**
1759   * @dev Adds two numbers, throws on overflow.
1760   */
1761   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1762     c = _a + _b;
1763     assert(c >= _a);
1764     return c;
1765   }
1766 }
1767 
1768 // File: contracts/common/DaoConstants.sol
1769 contract DaoConstants {
1770     using SafeMath for uint256;
1771     bytes32 EMPTY_BYTES = bytes32(0x0);
1772     address EMPTY_ADDRESS = address(0x0);
1773 
1774 
1775     bytes32 PROPOSAL_STATE_PREPROPOSAL = "proposal_state_preproposal";
1776     bytes32 PROPOSAL_STATE_DRAFT = "proposal_state_draft";
1777     bytes32 PROPOSAL_STATE_MODERATED = "proposal_state_moderated";
1778     bytes32 PROPOSAL_STATE_ONGOING = "proposal_state_ongoing";
1779     bytes32 PROPOSAL_STATE_CLOSED = "proposal_state_closed";
1780     bytes32 PROPOSAL_STATE_ARCHIVED = "proposal_state_archived";
1781 
1782     uint256 PRL_ACTION_STOP = 1;
1783     uint256 PRL_ACTION_PAUSE = 2;
1784     uint256 PRL_ACTION_UNPAUSE = 3;
1785 
1786     uint256 COLLATERAL_STATUS_UNLOCKED = 1;
1787     uint256 COLLATERAL_STATUS_LOCKED = 2;
1788     uint256 COLLATERAL_STATUS_CLAIMED = 3;
1789 
1790     bytes32 INTERMEDIATE_DGD_IDENTIFIER = "inter_dgd_id";
1791     bytes32 INTERMEDIATE_MODERATOR_DGD_IDENTIFIER = "inter_mod_dgd_id";
1792     bytes32 INTERMEDIATE_BONUS_CALCULATION_IDENTIFIER = "inter_bonus_calculation_id";
1793 
1794     // interactive contracts
1795     bytes32 CONTRACT_DAO = "dao";
1796     bytes32 CONTRACT_DAO_SPECIAL_PROPOSAL = "dao:special:proposal";
1797     bytes32 CONTRACT_DAO_STAKE_LOCKING = "dao:stake-locking";
1798     bytes32 CONTRACT_DAO_VOTING = "dao:voting";
1799     bytes32 CONTRACT_DAO_VOTING_CLAIMS = "dao:voting:claims";
1800     bytes32 CONTRACT_DAO_SPECIAL_VOTING_CLAIMS = "dao:svoting:claims";
1801     bytes32 CONTRACT_DAO_IDENTITY = "dao:identity";
1802     bytes32 CONTRACT_DAO_REWARDS_MANAGER = "dao:rewards-manager";
1803     bytes32 CONTRACT_DAO_REWARDS_MANAGER_EXTRAS = "dao:rewards-extras";
1804     bytes32 CONTRACT_DAO_ROLES = "dao:roles";
1805     bytes32 CONTRACT_DAO_FUNDING_MANAGER = "dao:funding-manager";
1806     bytes32 CONTRACT_DAO_WHITELISTING = "dao:whitelisting";
1807     bytes32 CONTRACT_DAO_INFORMATION = "dao:information";
1808 
1809     // service contracts
1810     bytes32 CONTRACT_SERVICE_ROLE = "service:role";
1811     bytes32 CONTRACT_SERVICE_DAO_INFO = "service:dao:info";
1812     bytes32 CONTRACT_SERVICE_DAO_LISTING = "service:dao:listing";
1813     bytes32 CONTRACT_SERVICE_DAO_CALCULATOR = "service:dao:calculator";
1814 
1815     // storage contracts
1816     bytes32 CONTRACT_STORAGE_DAO = "storage:dao";
1817     bytes32 CONTRACT_STORAGE_DAO_COUNTER = "storage:dao:counter";
1818     bytes32 CONTRACT_STORAGE_DAO_UPGRADE = "storage:dao:upgrade";
1819     bytes32 CONTRACT_STORAGE_DAO_IDENTITY = "storage:dao:identity";
1820     bytes32 CONTRACT_STORAGE_DAO_POINTS = "storage:dao:points";
1821     bytes32 CONTRACT_STORAGE_DAO_SPECIAL = "storage:dao:special";
1822     bytes32 CONTRACT_STORAGE_DAO_CONFIG = "storage:dao:config";
1823     bytes32 CONTRACT_STORAGE_DAO_STAKE = "storage:dao:stake";
1824     bytes32 CONTRACT_STORAGE_DAO_REWARDS = "storage:dao:rewards";
1825     bytes32 CONTRACT_STORAGE_DAO_WHITELISTING = "storage:dao:whitelisting";
1826     bytes32 CONTRACT_STORAGE_INTERMEDIATE_RESULTS = "storage:intermediate:results";
1827 
1828     bytes32 CONTRACT_DGD_TOKEN = "t:dgd";
1829     bytes32 CONTRACT_DGX_TOKEN = "t:dgx";
1830     bytes32 CONTRACT_BADGE_TOKEN = "t:badge";
1831 
1832     uint8 ROLES_ROOT = 1;
1833     uint8 ROLES_FOUNDERS = 2;
1834     uint8 ROLES_PRLS = 3;
1835     uint8 ROLES_KYC_ADMINS = 4;
1836 
1837     uint256 QUARTER_DURATION = 90 days;
1838 
1839     bytes32 CONFIG_MINIMUM_LOCKED_DGD = "min_dgd_participant";
1840     bytes32 CONFIG_MINIMUM_DGD_FOR_MODERATOR = "min_dgd_moderator";
1841     bytes32 CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR = "min_reputation_moderator";
1842 
1843     bytes32 CONFIG_LOCKING_PHASE_DURATION = "locking_phase_duration";
1844     bytes32 CONFIG_QUARTER_DURATION = "quarter_duration";
1845     bytes32 CONFIG_VOTING_COMMIT_PHASE = "voting_commit_phase";
1846     bytes32 CONFIG_VOTING_PHASE_TOTAL = "voting_phase_total";
1847     bytes32 CONFIG_INTERIM_COMMIT_PHASE = "interim_voting_commit_phase";
1848     bytes32 CONFIG_INTERIM_PHASE_TOTAL = "interim_voting_phase_total";
1849 
1850     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR = "draft_quorum_fixed_numerator";
1851     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR = "draft_quorum_fixed_denominator";
1852     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR = "draft_quorum_sfactor_numerator";
1853     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR = "draft_quorum_sfactor_denominator";
1854     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR = "vote_quorum_fixed_numerator";
1855     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR = "vote_quorum_fixed_denominator";
1856     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR = "vote_quorum_sfactor_numerator";
1857     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR = "vote_quorum_sfactor_denominator";
1858     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR = "final_reward_sfactor_numerator";
1859     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR = "final_reward_sfactor_denominator";
1860 
1861     bytes32 CONFIG_DRAFT_QUOTA_NUMERATOR = "draft_quota_numerator";
1862     bytes32 CONFIG_DRAFT_QUOTA_DENOMINATOR = "draft_quota_denominator";
1863     bytes32 CONFIG_VOTING_QUOTA_NUMERATOR = "voting_quota_numerator";
1864     bytes32 CONFIG_VOTING_QUOTA_DENOMINATOR = "voting_quota_denominator";
1865 
1866     bytes32 CONFIG_MINIMAL_QUARTER_POINT = "minimal_qp";
1867     bytes32 CONFIG_QUARTER_POINT_SCALING_FACTOR = "quarter_point_scaling_factor";
1868     bytes32 CONFIG_REPUTATION_POINT_SCALING_FACTOR = "rep_point_scaling_factor";
1869 
1870     bytes32 CONFIG_MODERATOR_MINIMAL_QUARTER_POINT = "minimal_mod_qp";
1871     bytes32 CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR = "mod_qp_scaling_factor";
1872     bytes32 CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR = "mod_rep_point_scaling_factor";
1873 
1874     bytes32 CONFIG_QUARTER_POINT_DRAFT_VOTE = "quarter_point_draft_vote";
1875     bytes32 CONFIG_QUARTER_POINT_VOTE = "quarter_point_vote";
1876     bytes32 CONFIG_QUARTER_POINT_INTERIM_VOTE = "quarter_point_interim_vote";
1877 
1878     /// this is per 10000 ETHs
1879     bytes32 CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH = "q_p_milestone_completion";
1880 
1881     bytes32 CONFIG_BONUS_REPUTATION_NUMERATOR = "bonus_reputation_numerator";
1882     bytes32 CONFIG_BONUS_REPUTATION_DENOMINATOR = "bonus_reputation_denominator";
1883 
1884     bytes32 CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE = "special_proposal_commit_phase";
1885     bytes32 CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL = "special_proposal_phase_total";
1886 
1887     bytes32 CONFIG_SPECIAL_QUOTA_NUMERATOR = "config_special_quota_numerator";
1888     bytes32 CONFIG_SPECIAL_QUOTA_DENOMINATOR = "config_special_quota_denominator";
1889 
1890     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR = "special_quorum_numerator";
1891     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR = "special_quorum_denominator";
1892 
1893     bytes32 CONFIG_MAXIMUM_REPUTATION_DEDUCTION = "config_max_reputation_deduction";
1894     bytes32 CONFIG_PUNISHMENT_FOR_NOT_LOCKING = "config_punishment_not_locking";
1895 
1896     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_NUM = "config_rep_per_extra_qp_num";
1897     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_DEN = "config_rep_per_extra_qp_den";
1898 
1899     bytes32 CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION = "config_max_m_rp_deduction";
1900     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM = "config_rep_per_extra_m_qp_num";
1901     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN = "config_rep_per_extra_m_qp_den";
1902 
1903     bytes32 CONFIG_PORTION_TO_MODERATORS_NUM = "config_mod_portion_num";
1904     bytes32 CONFIG_PORTION_TO_MODERATORS_DEN = "config_mod_portion_den";
1905 
1906     bytes32 CONFIG_DRAFT_VOTING_PHASE = "config_draft_voting_phase";
1907 
1908     bytes32 CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE = "config_rp_boost_per_badge";
1909 
1910     bytes32 CONFIG_VOTE_CLAIMING_DEADLINE = "config_claiming_deadline";
1911 
1912     bytes32 CONFIG_PREPROPOSAL_COLLATERAL = "config_preproposal_collateral";
1913 
1914     bytes32 CONFIG_MAX_FUNDING_FOR_NON_DIGIX = "config_max_funding_nonDigix";
1915     bytes32 CONFIG_MAX_MILESTONES_FOR_NON_DIGIX = "config_max_milestones_nonDigix";
1916     bytes32 CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER = "config_nonDigix_proposal_cap";
1917 
1918     bytes32 CONFIG_PROPOSAL_DEAD_DURATION = "config_dead_duration";
1919     bytes32 CONFIG_CARBON_VOTE_REPUTATION_BONUS = "config_cv_reputation";
1920 }
1921 
1922 // File: contracts/storage/DaoIdentityStorage.sol
1923 contract DaoIdentityStorage is ResolverClient, DaoConstants, DirectoryStorage {
1924 
1925     // struct for KYC details
1926     // doc is the IPFS doc hash for any information regarding this KYC
1927     // id_expiration is the UTC timestamp at which this KYC will expire
1928     // at any time after this, the user's KYC is invalid, and that user
1929     // MUST re-KYC before doing any proposer related operation in DigixDAO
1930     struct KycDetails {
1931         bytes32 doc;
1932         uint256 id_expiration;
1933     }
1934 
1935     // a mapping of address to the KYC details
1936     mapping (address => KycDetails) kycInfo;
1937 
1938     constructor(address _resolver)
1939         public
1940     {
1941         require(init(CONTRACT_STORAGE_DAO_IDENTITY, _resolver));
1942         require(initialize_directory());
1943     }
1944 
1945     function create_group(uint256 _role_id, bytes32 _name, bytes32 _document)
1946         public
1947         returns (bool _success, uint256 _group_id)
1948     {
1949         require(sender_is(CONTRACT_DAO_IDENTITY));
1950         (_success, _group_id) = internal_create_group(_role_id, _name, _document);
1951         require(_success);
1952     }
1953 
1954     function create_role(uint256 _role_id, bytes32 _name)
1955         public
1956         returns (bool _success)
1957     {
1958         require(sender_is(CONTRACT_DAO_IDENTITY));
1959         _success = internal_create_role(_role_id, _name);
1960         require(_success);
1961     }
1962 
1963     function update_add_user_to_group(uint256 _group_id, address _user, bytes32 _document)
1964         public
1965         returns (bool _success)
1966     {
1967         require(sender_is(CONTRACT_DAO_IDENTITY));
1968         _success = internal_update_add_user_to_group(_group_id, _user, _document);
1969         require(_success);
1970     }
1971 
1972     function update_remove_group_user(address _user)
1973         public
1974         returns (bool _success)
1975     {
1976         require(sender_is(CONTRACT_DAO_IDENTITY));
1977         _success = internal_destroy_group_user(_user);
1978         require(_success);
1979     }
1980 
1981     function update_kyc(address _user, bytes32 _doc, uint256 _id_expiration)
1982         public
1983     {
1984         require(sender_is(CONTRACT_DAO_IDENTITY));
1985         kycInfo[_user].doc = _doc;
1986         kycInfo[_user].id_expiration = _id_expiration;
1987     }
1988 
1989     function read_kyc_info(address _user)
1990         public
1991         view
1992         returns (bytes32 _doc, uint256 _id_expiration)
1993     {
1994         _doc = kycInfo[_user].doc;
1995         _id_expiration = kycInfo[_user].id_expiration;
1996     }
1997 
1998     function is_kyc_approved(address _user)
1999         public
2000         view
2001         returns (bool _approved)
2002     {
2003         uint256 _id_expiration;
2004         (,_id_expiration) = read_kyc_info(_user);
2005         _approved = _id_expiration > now;
2006     }
2007 }
2008 
2009 // File: contracts/storage/DaoWhitelistingStorage.sol
2010 // This contract is basically created to restrict read access to
2011 // ethereum accounts, and whitelisted contracts
2012 contract DaoWhitelistingStorage is ResolverClient, DaoConstants {
2013 
2014     // we want to avoid the scenario in which an on-chain bribing contract
2015     // can be deployed to distribute funds in a trustless way by verifying
2016     // on-chain votes. This mapping marks whether a contract address is whitelisted
2017     // to read from the read functions in DaoStorage, DaoSpecialStorage, etc.
2018     mapping (address => bool) public whitelist;
2019 
2020     constructor(address _resolver)
2021         public
2022     {
2023         require(init(CONTRACT_STORAGE_DAO_WHITELISTING, _resolver));
2024     }
2025 
2026     function setWhitelisted(address _contractAddress, bool _senderIsAllowedToRead)
2027         public
2028     {
2029         require(sender_is(CONTRACT_DAO_WHITELISTING));
2030         whitelist[_contractAddress] = _senderIsAllowedToRead;
2031     }
2032 }
2033 
2034 // File: contracts/common/DaoWhitelistingCommon.sol
2035 contract DaoWhitelistingCommon is ResolverClient, DaoConstants {
2036 
2037     function daoWhitelistingStorage()
2038         internal
2039         view
2040         returns (DaoWhitelistingStorage _contract)
2041     {
2042         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
2043     }
2044 
2045     /**
2046     @notice Check if a certain address is whitelisted to read sensitive information in the storage layer
2047     @dev if the address is an account, it is allowed to read. If the address is a contract, it has to be in the whitelist
2048     */
2049     function senderIsAllowedToRead()
2050         internal
2051         view
2052         returns (bool _senderIsAllowedToRead)
2053     {
2054         // msg.sender is allowed to read only if its an EOA or a whitelisted contract
2055         _senderIsAllowedToRead = (msg.sender == tx.origin) || daoWhitelistingStorage().whitelist(msg.sender);
2056     }
2057 }
2058 
2059 // File: contracts/common/IdentityCommon.sol
2060 contract IdentityCommon is DaoWhitelistingCommon {
2061 
2062     modifier if_root() {
2063         require(identity_storage().read_user_role_id(msg.sender) == ROLES_ROOT);
2064         _;
2065     }
2066 
2067     modifier if_founder() {
2068         require(is_founder());
2069         _;
2070     }
2071 
2072     function is_founder()
2073         internal
2074         view
2075         returns (bool _isFounder)
2076     {
2077         _isFounder = identity_storage().read_user_role_id(msg.sender) == ROLES_FOUNDERS;
2078     }
2079 
2080     modifier if_prl() {
2081         require(identity_storage().read_user_role_id(msg.sender) == ROLES_PRLS);
2082         _;
2083     }
2084 
2085     modifier if_kyc_admin() {
2086         require(identity_storage().read_user_role_id(msg.sender) == ROLES_KYC_ADMINS);
2087         _;
2088     }
2089 
2090     function identity_storage()
2091         internal
2092         view
2093         returns (DaoIdentityStorage _contract)
2094     {
2095         _contract = DaoIdentityStorage(get_contract(CONTRACT_STORAGE_DAO_IDENTITY));
2096     }
2097 }
2098 
2099 // File: contracts/interactive/DaoIdentity.sol
2100 /**
2101 @title Contract to manage the admin roles in DAO (founders, prls, kyc admins)
2102 @author Digix Holdings
2103 */
2104 contract DaoIdentity is IdentityCommon {
2105 
2106     /**
2107     @notice Constructor (create initial roles, groups)
2108     @param _resolver Address of Contract Resolver
2109     */
2110     constructor(address _resolver)
2111         public
2112     {
2113         require(init(CONTRACT_DAO_IDENTITY, _resolver));
2114         // create the three roles and the three corresponding groups
2115         // the root role, and root group are already created, with only the contract deployer in it
2116         // After deployment, the contract deployer will call addGroupUser to add a multi-sig to be another root
2117         // The multi-sig will then call removeGroupUser to remove the contract deployer from root role
2118         // From then on, the multi-sig will be the only root account
2119         identity_storage().create_role(ROLES_FOUNDERS, "founders");
2120         identity_storage().create_role(ROLES_PRLS, "prls");
2121         identity_storage().create_role(ROLES_KYC_ADMINS, "kycadmins");
2122         identity_storage().create_group(ROLES_FOUNDERS, "founders_group", ""); // group_id = 2
2123         identity_storage().create_group(ROLES_PRLS, "prls_group", ""); // group_id = 3
2124         identity_storage().create_group(ROLES_KYC_ADMINS, "kycadmins_group", ""); // group_id = 4
2125     }
2126 
2127     /**
2128     @notice Function to add an address to a group (only root can call this function)
2129     @param _group_id ID of the group to be added in
2130     @param _user Ethereum address of the user
2131     @param _doc hash of IPFS doc containing details of this user
2132     */
2133     function addGroupUser(uint256 _group_id, address _user, bytes32 _doc)
2134         public
2135         if_root()
2136     {
2137         identity_storage().update_add_user_to_group(_group_id, _user, _doc);
2138     }
2139 
2140     /**
2141     @notice Function to remove a user from group (only root can call this)
2142     @param _user Ethereum address of the user to be removed from their group
2143     */
2144     function removeGroupUser(address _user)
2145         public
2146         if_root()
2147     {
2148         identity_storage().update_remove_group_user(_user);
2149     }
2150 
2151     /**
2152     @notice Function to update the KYC data of user (expiry data of valid KYC) (can only be called by the KYC ADMIN role)
2153     @param _user Ethereum address of the user
2154     @param _doc hash of the IPFS doc containing kyc information about this user
2155     @param _id_expiration expiry date of the KYC
2156     */
2157     function updateKyc(address _user, bytes32 _doc, uint256 _id_expiration)
2158         public
2159         if_kyc_admin()
2160     {
2161         privateUpdateKyc(_user, _doc, _id_expiration);
2162     }
2163 
2164     /**
2165     @notice Function to update the KYC data of multiple users (expiry data of valid KYC) (can only be called by the KYC ADMIN role)
2166     @param _users Ethereum addresses of the users
2167     @param _docs hashes of the IPFS docs containing kyc information about these users
2168     @param _id_expirations expiry dates of the KYC docs for these users
2169     */
2170     function bulkUpdateKyc(address[] _users, bytes32[] _docs, uint256[] _id_expirations)
2171         external
2172         if_kyc_admin()
2173     {
2174         uint256 _n = _users.length;
2175         for (uint256 _i = 0; _i < _n; _i++) {
2176             privateUpdateKyc(_users[_i], _docs[_i], _id_expirations[_i]);
2177         }
2178     }
2179 
2180     function privateUpdateKyc(address _user, bytes32 _doc, uint256 _id_expiration)
2181         private
2182     {
2183         identity_storage().update_kyc(_user, _doc, _id_expiration);
2184     }
2185 }