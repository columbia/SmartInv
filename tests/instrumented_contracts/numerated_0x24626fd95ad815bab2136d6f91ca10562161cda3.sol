1 pragma solidity ^0.4.25;
2 
3 /// @title Owner based access control
4 /// @author DigixGlobal
5 contract ACOwned {
6 
7   address public owner;
8   address public new_owner;
9   bool is_ac_owned_init;
10 
11   /// @dev Modifier to check if msg.sender is the contract owner
12   modifier if_owner() {
13     require(is_owner());
14     _;
15   }
16 
17   function init_ac_owned()
18            internal
19            returns (bool _success)
20   {
21     if (is_ac_owned_init == false) {
22       owner = msg.sender;
23       is_ac_owned_init = true;
24     }
25     _success = true;
26   }
27 
28   function is_owner()
29            private
30            constant
31            returns (bool _is_owner)
32   {
33     _is_owner = (msg.sender == owner);
34   }
35 
36   function change_owner(address _new_owner)
37            if_owner()
38            public
39            returns (bool _success)
40   {
41     new_owner = _new_owner;
42     _success = true;
43   }
44 
45   function claim_ownership()
46            public
47            returns (bool _success)
48   {
49     require(msg.sender == new_owner);
50     owner = new_owner;
51     _success = true;
52   }
53 }
54 
55 /// @title Some useful constants
56 /// @author DigixGlobal
57 contract Constants {
58   address constant NULL_ADDRESS = address(0x0);
59   uint256 constant ZERO = uint256(0);
60   bytes32 constant EMPTY = bytes32(0x0);
61 }
62 
63 /// @title Contract Name Registry
64 /// @author DigixGlobal
65 contract ContractResolver is ACOwned, Constants {
66 
67   mapping (bytes32 => address) contracts;
68   bool public locked_forever;
69 
70   modifier unless_registered(bytes32 _key) {
71     require(contracts[_key] == NULL_ADDRESS);
72     _;
73   }
74 
75   modifier if_owner_origin() {
76     require(tx.origin == owner);
77     _;
78   }
79 
80   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
81   /// @param _contract The resolver key
82   modifier if_sender_is(bytes32 _contract) {
83     require(msg.sender == get_contract(_contract));
84     _;
85   }
86 
87   modifier if_not_locked() {
88     require(locked_forever == false);
89     _;
90   }
91 
92   /// @dev ContractResolver constructor will perform the following: 1. Set msg.sender as the contract owner.
93   constructor() public
94   {
95     require(init_ac_owned());
96     locked_forever = false;
97   }
98 
99   /// @dev Called at contract initialization
100   /// @param _key bytestring for CACP name
101   /// @param _contract_address The address of the contract to be registered
102   /// @return _success if the operation is successful
103   function init_register_contract(bytes32 _key, address _contract_address)
104            if_owner_origin()
105            if_not_locked()
106            unless_registered(_key)
107            public
108            returns (bool _success)
109   {
110     require(_contract_address != NULL_ADDRESS);
111     contracts[_key] = _contract_address;
112     _success = true;
113   }
114 
115   /// @dev Lock the resolver from any further modifications.  This can only be called from the owner
116   /// @return _success if the operation is successful
117   function lock_resolver_forever()
118            if_owner
119            public
120            returns (bool _success)
121   {
122     locked_forever = true;
123     _success = true;
124   }
125 
126   /// @dev Get address of a contract
127   /// @param _key the bytestring name of the contract to look up
128   /// @return _contract the address of the contract
129   function get_contract(bytes32 _key)
130            public
131            view
132            returns (address _contract)
133   {
134     require(contracts[_key] != NULL_ADDRESS);
135     _contract = contracts[_key];
136   }
137 }
138 
139 /// @title Contract Resolver Interface
140 /// @author DigixGlobal
141 contract ResolverClient {
142 
143   /// The address of the resolver contract for this project
144   address public resolver;
145   bytes32 public key;
146 
147   /// Make our own address available to us as a constant
148   address public CONTRACT_ADDRESS;
149 
150   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
151   /// @param _contract The resolver key
152   modifier if_sender_is(bytes32 _contract) {
153     require(sender_is(_contract));
154     _;
155   }
156 
157   function sender_is(bytes32 _contract) internal view returns (bool _isFrom) {
158     _isFrom = msg.sender == ContractResolver(resolver).get_contract(_contract);
159   }
160 
161   modifier if_sender_is_from(bytes32[3] _contracts) {
162     require(sender_is_from(_contracts));
163     _;
164   }
165 
166   function sender_is_from(bytes32[3] _contracts) internal view returns (bool _isFrom) {
167     uint256 _n = _contracts.length;
168     for (uint256 i = 0; i < _n; i++) {
169       if (_contracts[i] == bytes32(0x0)) continue;
170       if (msg.sender == ContractResolver(resolver).get_contract(_contracts[i])) {
171         _isFrom = true;
172         break;
173       }
174     }
175   }
176 
177   /// Function modifier to check resolver's locking status.
178   modifier unless_resolver_is_locked() {
179     require(is_locked() == false);
180     _;
181   }
182 
183   /// @dev Initialize new contract
184   /// @param _key the resolver key for this contract
185   /// @return _success if the initialization is successful
186   function init(bytes32 _key, address _resolver)
187            internal
188            returns (bool _success)
189   {
190     bool _is_locked = ContractResolver(_resolver).locked_forever();
191     if (_is_locked == false) {
192       CONTRACT_ADDRESS = address(this);
193       resolver = _resolver;
194       key = _key;
195       require(ContractResolver(resolver).init_register_contract(key, CONTRACT_ADDRESS));
196       _success = true;
197     }  else {
198       _success = false;
199     }
200   }
201 
202   /// @dev Check if resolver is locked
203   /// @return _locked if the resolver is currently locked
204   function is_locked()
205            private
206            view
207            returns (bool _locked)
208   {
209     _locked = ContractResolver(resolver).locked_forever();
210   }
211 
212   /// @dev Get the address of a contract
213   /// @param _key the resolver key to look up
214   /// @return _contract the address of the contract
215   function get_contract(bytes32 _key)
216            public
217            view
218            returns (address _contract)
219   {
220     _contract = ContractResolver(resolver).get_contract(_key);
221   }
222 }
223 
224 /**
225   @title Bytes Iterator Interactive
226   @author DigixGlobal Pte Ltd
227 */
228 contract BytesIteratorInteractive {
229 
230   /**
231     @notice Lists a Bytes collection from start or end
232     @param _count Total number of Bytes items to return
233     @param _function_first Function that returns the First Bytes item in the list
234     @param _function_last Function that returns the last Bytes item in the list
235     @param _function_next Function that returns the Next Bytes item in the list
236     @param _function_previous Function that returns previous Bytes item in the list
237     @param _from_start whether to read from start (or end) of the list
238     @return {"_bytes_items" : "Collection of reversed Bytes list"}
239   */
240   function list_bytesarray(uint256 _count,
241                                  function () external constant returns (bytes32) _function_first,
242                                  function () external constant returns (bytes32) _function_last,
243                                  function (bytes32) external constant returns (bytes32) _function_next,
244                                  function (bytes32) external constant returns (bytes32) _function_previous,
245                                  bool _from_start)
246            internal
247            constant
248            returns (bytes32[] _bytes_items)
249   {
250     if (_from_start) {
251       _bytes_items = private_list_bytes_from_bytes(_function_first(), _count, true, _function_last, _function_next);
252     } else {
253       _bytes_items = private_list_bytes_from_bytes(_function_last(), _count, true, _function_first, _function_previous);
254     }
255   }
256 
257   /**
258     @notice Lists a Bytes collection from some `_current_item`, going forwards or backwards depending on `_from_start`
259     @param _current_item The current Item
260     @param _count Total number of Bytes items to return
261     @param _function_first Function that returns the First Bytes item in the list
262     @param _function_last Function that returns the last Bytes item in the list
263     @param _function_next Function that returns the Next Bytes item in the list
264     @param _function_previous Function that returns previous Bytes item in the list
265     @param _from_start whether to read in the forwards ( or backwards) direction
266     @return {"_bytes_items" :"Collection/list of Bytes"}
267   */
268   function list_bytesarray_from(bytes32 _current_item, uint256 _count,
269                                 function () external constant returns (bytes32) _function_first,
270                                 function () external constant returns (bytes32) _function_last,
271                                 function (bytes32) external constant returns (bytes32) _function_next,
272                                 function (bytes32) external constant returns (bytes32) _function_previous,
273                                 bool _from_start)
274            internal
275            constant
276            returns (bytes32[] _bytes_items)
277   {
278     if (_from_start) {
279       _bytes_items = private_list_bytes_from_bytes(_current_item, _count, false, _function_last, _function_next);
280     } else {
281       _bytes_items = private_list_bytes_from_bytes(_current_item, _count, false, _function_first, _function_previous);
282     }
283   }
284 
285   /**
286     @notice A private function to lists a Bytes collection starting from some `_current_item` (which could be included or excluded), in the forwards or backwards direction
287     @param _current_item The current Item
288     @param _count Total number of Bytes items to return
289     @param _including_current Whether the `_current_item` should be included in the result
290     @param _function_last Function that returns the bytes where we stop reading more bytes
291     @param _function_next Function that returns the next bytes to read after some bytes (could be backwards or forwards in the physical collection)
292     @return {"_address_items" :"Collection/list of Bytes"}
293   */
294   function private_list_bytes_from_bytes(bytes32 _current_item, uint256 _count, bool _including_current,
295                                  function () external constant returns (bytes32) _function_last,
296                                  function (bytes32) external constant returns (bytes32) _function_next)
297            private
298            constant
299            returns (bytes32[] _bytes32_items)
300   {
301     uint256 _i;
302     uint256 _real_count = 0;
303     bytes32 _last_item;
304 
305     _last_item = _function_last();
306     if (_count == 0 || _last_item == bytes32(0x0)) {
307       _bytes32_items = new bytes32[](0);
308     } else {
309       bytes32[] memory _items_temp = new bytes32[](_count);
310       bytes32 _this_item;
311       if (_including_current == true) {
312         _items_temp[0] = _current_item;
313         _real_count = 1;
314       }
315       _this_item = _current_item;
316       for (_i = _real_count; (_i < _count) && (_this_item != _last_item);_i++) {
317         _this_item = _function_next(_this_item);
318         if (_this_item != bytes32(0x0)) {
319           _real_count++;
320           _items_temp[_i] = _this_item;
321         }
322       }
323 
324       _bytes32_items = new bytes32[](_real_count);
325       for(_i = 0;_i < _real_count;_i++) {
326         _bytes32_items[_i] = _items_temp[_i];
327       }
328     }
329   }
330 
331 
332 
333 
334   ////// DEPRECATED FUNCTIONS (old versions)
335 
336   /**
337     @notice a private function to lists a Bytes collection starting from some `_current_item`, could be forwards or backwards
338     @param _current_item The current Item
339     @param _count Total number of Bytes items to return
340     @param _function_last Function that returns the bytes where we stop reading more bytes
341     @param _function_next Function that returns the next bytes to read after some bytes (could be backwards or forwards in the physical collection)
342     @return {"_bytes_items" :"Collection/list of Bytes"}
343   */
344   /*function list_bytes_from_bytes(bytes32 _current_item, uint256 _count,
345                                  function () external constant returns (bytes32) _function_last,
346                                  function (bytes32) external constant returns (bytes32) _function_next)
347            private
348            constant
349            returns (bytes32[] _bytes_items)
350   {
351     uint256 _i;
352     uint256 _real_count = 0;
353 
354     if (_count == 0) {
355       _bytes_items = new bytes32[](0);
356     } else {
357       bytes32[] memory _items_temp = new bytes32[](_count);
358 
359       bytes32 _start_item;
360       bytes32 _last_item;
361 
362       _last_item = _function_last();
363 
364       if (_last_item != _current_item) {
365         _start_item = _function_next(_current_item);
366         if (_start_item != bytes32(0x0)) {
367           _items_temp[0] = _start_item;
368           _real_count = 1;
369           for(_i = 1;(_i <= (_count - 1)) && (_start_item != _last_item);_i++) {
370             _start_item = _function_next(_start_item);
371             if (_start_item != bytes32(0x0)) {
372               _real_count++;
373               _items_temp[_i] = _start_item;
374             }
375           }
376           _bytes_items = new bytes32[](_real_count);
377           for(_i = 0;_i <= (_real_count - 1);_i++) {
378             _bytes_items[_i] = _items_temp[_i];
379           }
380         } else {
381           _bytes_items = new bytes32[](0);
382         }
383       } else {
384         _bytes_items = new bytes32[](0);
385       }
386     }
387   }*/
388 
389   /**
390     @notice private function to list a Bytes collection starting from the start or end of the list
391     @param _count Total number of Bytes item to return
392     @param _function_total Function that returns the Total number of Bytes item in the list
393     @param _function_first Function that returns the First Bytes item in the list
394     @param _function_next Function that returns the Next Bytes item in the list
395     @return {"_bytes_items" :"Collection/list of Bytes"}
396   */
397   /*function list_bytes_from_start_or_end(uint256 _count,
398                                  function () external constant returns (uint256) _function_total,
399                                  function () external constant returns (bytes32) _function_first,
400                                  function (bytes32) external constant returns (bytes32) _function_next)
401 
402            private
403            constant
404            returns (bytes32[] _bytes_items)
405   {
406     uint256 _i;
407     bytes32 _current_item;
408     uint256 _real_count = _function_total();
409 
410     if (_count > _real_count) {
411       _count = _real_count;
412     }
413 
414     bytes32[] memory _items_tmp = new bytes32[](_count);
415 
416     if (_count > 0) {
417       _current_item = _function_first();
418       _items_tmp[0] = _current_item;
419 
420       for(_i = 1;_i <= (_count - 1);_i++) {
421         _current_item = _function_next(_current_item);
422         if (_current_item != bytes32(0x0)) {
423           _items_tmp[_i] = _current_item;
424         }
425       }
426       _bytes_items = _items_tmp;
427     } else {
428       _bytes_items = new bytes32[](0);
429     }
430   }*/
431 }
432 
433 /**
434   @title Address Iterator Interactive
435   @author DigixGlobal Pte Ltd
436 */
437 contract AddressIteratorInteractive {
438 
439   /**
440     @notice Lists a Address collection from start or end
441     @param _count Total number of Address items to return
442     @param _function_first Function that returns the First Address item in the list
443     @param _function_last Function that returns the last Address item in the list
444     @param _function_next Function that returns the Next Address item in the list
445     @param _function_previous Function that returns previous Address item in the list
446     @param _from_start whether to read from start (or end) of the list
447     @return {"_address_items" : "Collection of reversed Address list"}
448   */
449   function list_addresses(uint256 _count,
450                                  function () external constant returns (address) _function_first,
451                                  function () external constant returns (address) _function_last,
452                                  function (address) external constant returns (address) _function_next,
453                                  function (address) external constant returns (address) _function_previous,
454                                  bool _from_start)
455            internal
456            constant
457            returns (address[] _address_items)
458   {
459     if (_from_start) {
460       _address_items = private_list_addresses_from_address(_function_first(), _count, true, _function_last, _function_next);
461     } else {
462       _address_items = private_list_addresses_from_address(_function_last(), _count, true, _function_first, _function_previous);
463     }
464   }
465 
466 
467 
468   /**
469     @notice Lists a Address collection from some `_current_item`, going forwards or backwards depending on `_from_start`
470     @param _current_item The current Item
471     @param _count Total number of Address items to return
472     @param _function_first Function that returns the First Address item in the list
473     @param _function_last Function that returns the last Address item in the list
474     @param _function_next Function that returns the Next Address item in the list
475     @param _function_previous Function that returns previous Address item in the list
476     @param _from_start whether to read in the forwards ( or backwards) direction
477     @return {"_address_items" :"Collection/list of Address"}
478   */
479   function list_addresses_from(address _current_item, uint256 _count,
480                                 function () external constant returns (address) _function_first,
481                                 function () external constant returns (address) _function_last,
482                                 function (address) external constant returns (address) _function_next,
483                                 function (address) external constant returns (address) _function_previous,
484                                 bool _from_start)
485            internal
486            constant
487            returns (address[] _address_items)
488   {
489     if (_from_start) {
490       _address_items = private_list_addresses_from_address(_current_item, _count, false, _function_last, _function_next);
491     } else {
492       _address_items = private_list_addresses_from_address(_current_item, _count, false, _function_first, _function_previous);
493     }
494   }
495 
496 
497   /**
498     @notice a private function to lists a Address collection starting from some `_current_item` (which could be included or excluded), in the forwards or backwards direction
499     @param _current_item The current Item
500     @param _count Total number of Address items to return
501     @param _including_current Whether the `_current_item` should be included in the result
502     @param _function_last Function that returns the address where we stop reading more address
503     @param _function_next Function that returns the next address to read after some address (could be backwards or forwards in the physical collection)
504     @return {"_address_items" :"Collection/list of Address"}
505   */
506   function private_list_addresses_from_address(address _current_item, uint256 _count, bool _including_current,
507                                  function () external constant returns (address) _function_last,
508                                  function (address) external constant returns (address) _function_next)
509            private
510            constant
511            returns (address[] _address_items)
512   {
513     uint256 _i;
514     uint256 _real_count = 0;
515     address _last_item;
516 
517     _last_item = _function_last();
518     if (_count == 0 || _last_item == address(0x0)) {
519       _address_items = new address[](0);
520     } else {
521       address[] memory _items_temp = new address[](_count);
522       address _this_item;
523       if (_including_current == true) {
524         _items_temp[0] = _current_item;
525         _real_count = 1;
526       }
527       _this_item = _current_item;
528       for (_i = _real_count; (_i < _count) && (_this_item != _last_item);_i++) {
529         _this_item = _function_next(_this_item);
530         if (_this_item != address(0x0)) {
531           _real_count++;
532           _items_temp[_i] = _this_item;
533         }
534       }
535 
536       _address_items = new address[](_real_count);
537       for(_i = 0;_i < _real_count;_i++) {
538         _address_items[_i] = _items_temp[_i];
539       }
540     }
541   }
542 
543 
544   /** DEPRECATED
545     @notice private function to list a Address collection starting from the start or end of the list
546     @param _count Total number of Address item to return
547     @param _function_total Function that returns the Total number of Address item in the list
548     @param _function_first Function that returns the First Address item in the list
549     @param _function_next Function that returns the Next Address item in the list
550     @return {"_address_items" :"Collection/list of Address"}
551   */
552   /*function list_addresses_from_start_or_end(uint256 _count,
553                                  function () external constant returns (uint256) _function_total,
554                                  function () external constant returns (address) _function_first,
555                                  function (address) external constant returns (address) _function_next)
556 
557            private
558            constant
559            returns (address[] _address_items)
560   {
561     uint256 _i;
562     address _current_item;
563     uint256 _real_count = _function_total();
564 
565     if (_count > _real_count) {
566       _count = _real_count;
567     }
568 
569     address[] memory _items_tmp = new address[](_count);
570 
571     if (_count > 0) {
572       _current_item = _function_first();
573       _items_tmp[0] = _current_item;
574 
575       for(_i = 1;_i <= (_count - 1);_i++) {
576         _current_item = _function_next(_current_item);
577         if (_current_item != address(0x0)) {
578           _items_tmp[_i] = _current_item;
579         }
580       }
581       _address_items = _items_tmp;
582     } else {
583       _address_items = new address[](0);
584     }
585   }*/
586 
587   /** DEPRECATED
588     @notice a private function to lists a Address collection starting from some `_current_item`, could be forwards or backwards
589     @param _current_item The current Item
590     @param _count Total number of Address items to return
591     @param _function_last Function that returns the bytes where we stop reading more bytes
592     @param _function_next Function that returns the next bytes to read after some bytes (could be backwards or forwards in the physical collection)
593     @return {"_address_items" :"Collection/list of Address"}
594   */
595   /*function list_addresses_from_byte(address _current_item, uint256 _count,
596                                  function () external constant returns (address) _function_last,
597                                  function (address) external constant returns (address) _function_next)
598            private
599            constant
600            returns (address[] _address_items)
601   {
602     uint256 _i;
603     uint256 _real_count = 0;
604 
605     if (_count == 0) {
606       _address_items = new address[](0);
607     } else {
608       address[] memory _items_temp = new address[](_count);
609 
610       address _start_item;
611       address _last_item;
612 
613       _last_item = _function_last();
614 
615       if (_last_item != _current_item) {
616         _start_item = _function_next(_current_item);
617         if (_start_item != address(0x0)) {
618           _items_temp[0] = _start_item;
619           _real_count = 1;
620           for(_i = 1;(_i <= (_count - 1)) && (_start_item != _last_item);_i++) {
621             _start_item = _function_next(_start_item);
622             if (_start_item != address(0x0)) {
623               _real_count++;
624               _items_temp[_i] = _start_item;
625             }
626           }
627           _address_items = new address[](_real_count);
628           for(_i = 0;_i <= (_real_count - 1);_i++) {
629             _address_items[_i] = _items_temp[_i];
630           }
631         } else {
632           _address_items = new address[](0);
633         }
634       } else {
635         _address_items = new address[](0);
636       }
637     }
638   }*/
639 }
640 
641 /**
642   @title Indexed Bytes Iterator Interactive
643   @author DigixGlobal Pte Ltd
644 */
645 contract IndexedBytesIteratorInteractive {
646 
647   /**
648     @notice Lists an indexed Bytes collection from start or end
649     @param _collection_index Index of the Collection to list
650     @param _count Total number of Bytes items to return
651     @param _function_first Function that returns the First Bytes item in the list
652     @param _function_last Function that returns the last Bytes item in the list
653     @param _function_next Function that returns the Next Bytes item in the list
654     @param _function_previous Function that returns previous Bytes item in the list
655     @param _from_start whether to read from start (or end) of the list
656     @return {"_bytes_items" : "Collection of reversed Bytes list"}
657   */
658   function list_indexed_bytesarray(bytes32 _collection_index, uint256 _count,
659                               function (bytes32) external constant returns (bytes32) _function_first,
660                               function (bytes32) external constant returns (bytes32) _function_last,
661                               function (bytes32, bytes32) external constant returns (bytes32) _function_next,
662                               function (bytes32, bytes32) external constant returns (bytes32) _function_previous,
663                               bool _from_start)
664            internal
665            constant
666            returns (bytes32[] _indexed_bytes_items)
667   {
668     if (_from_start) {
669       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _function_first(_collection_index), _count, true, _function_last, _function_next);
670     } else {
671       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _function_last(_collection_index), _count, true, _function_first, _function_previous);
672     }
673   }
674 
675   /**
676     @notice Lists an indexed Bytes collection from some `_current_item`, going forwards or backwards depending on `_from_start`
677     @param _collection_index Index of the Collection to list
678     @param _current_item The current Item
679     @param _count Total number of Bytes items to return
680     @param _function_first Function that returns the First Bytes item in the list
681     @param _function_last Function that returns the last Bytes item in the list
682     @param _function_next Function that returns the Next Bytes item in the list
683     @param _function_previous Function that returns previous Bytes item in the list
684     @param _from_start whether to read in the forwards ( or backwards) direction
685     @return {"_bytes_items" :"Collection/list of Bytes"}
686   */
687   function list_indexed_bytesarray_from(bytes32 _collection_index, bytes32 _current_item, uint256 _count,
688                                 function (bytes32) external constant returns (bytes32) _function_first,
689                                 function (bytes32) external constant returns (bytes32) _function_last,
690                                 function (bytes32, bytes32) external constant returns (bytes32) _function_next,
691                                 function (bytes32, bytes32) external constant returns (bytes32) _function_previous,
692                                 bool _from_start)
693            internal
694            constant
695            returns (bytes32[] _indexed_bytes_items)
696   {
697     if (_from_start) {
698       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _current_item, _count, false, _function_last, _function_next);
699     } else {
700       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _current_item, _count, false, _function_first, _function_previous);
701     }
702   }
703 
704   /**
705     @notice a private function to lists an indexed Bytes collection starting from some `_current_item` (which could be included or excluded), in the forwards or backwards direction
706     @param _collection_index Index of the Collection to list
707     @param _current_item The item where we start reading from the list
708     @param _count Total number of Bytes items to return
709     @param _including_current Whether the `_current_item` should be included in the result
710     @param _function_last Function that returns the bytes where we stop reading more bytes
711     @param _function_next Function that returns the next bytes to read after another bytes (could be backwards or forwards in the physical collection)
712     @return {"_bytes_items" :"Collection/list of Bytes"}
713   */
714   function private_list_indexed_bytes_from_bytes(bytes32 _collection_index, bytes32 _current_item, uint256 _count, bool _including_current,
715                                          function (bytes32) external constant returns (bytes32) _function_last,
716                                          function (bytes32, bytes32) external constant returns (bytes32) _function_next)
717            private
718            constant
719            returns (bytes32[] _indexed_bytes_items)
720   {
721     uint256 _i;
722     uint256 _real_count = 0;
723     bytes32 _last_item;
724 
725     _last_item = _function_last(_collection_index);
726     if (_count == 0 || _last_item == bytes32(0x0)) {  // if count is 0 or the collection is empty, returns empty array
727       _indexed_bytes_items = new bytes32[](0);
728     } else {
729       bytes32[] memory _items_temp = new bytes32[](_count);
730       bytes32 _this_item;
731       if (_including_current) {
732         _items_temp[0] = _current_item;
733         _real_count = 1;
734       }
735       _this_item = _current_item;
736       for (_i = _real_count; (_i < _count) && (_this_item != _last_item);_i++) {
737         _this_item = _function_next(_collection_index, _this_item);
738         if (_this_item != bytes32(0x0)) {
739           _real_count++;
740           _items_temp[_i] = _this_item;
741         }
742       }
743 
744       _indexed_bytes_items = new bytes32[](_real_count);
745       for(_i = 0;_i < _real_count;_i++) {
746         _indexed_bytes_items[_i] = _items_temp[_i];
747       }
748     }
749   }
750 
751 
752   // old function, DEPRECATED
753   /*function list_indexed_bytes_from_bytes(bytes32 _collection_index, bytes32 _current_item, uint256 _count,
754                                          function (bytes32) external constant returns (bytes32) _function_last,
755                                          function (bytes32, bytes32) external constant returns (bytes32) _function_next)
756            private
757            constant
758            returns (bytes32[] _indexed_bytes_items)
759   {
760     uint256 _i;
761     uint256 _real_count = 0;
762     if (_count == 0) {
763       _indexed_bytes_items = new bytes32[](0);
764     } else {
765       bytes32[] memory _items_temp = new bytes32[](_count);
766 
767       bytes32 _start_item;
768       bytes32 _last_item;
769 
770       _last_item = _function_last(_collection_index);
771 
772       if (_last_item != _current_item) {
773         _start_item = _function_next(_collection_index, _current_item);
774         if (_start_item != bytes32(0x0)) {
775           _items_temp[0] = _start_item;
776           _real_count = 1;
777           for(_i = 1;(_i <= (_count - 1)) && (_start_item != _last_item);_i++) {
778             _start_item = _function_next(_collection_index, _start_item);
779             if (_start_item != bytes32(0x0)) {
780               _real_count++;
781               _items_temp[_i] = _start_item;
782             }
783           }
784           _indexed_bytes_items = new bytes32[](_real_count);
785           for(_i = 0;_i <= (_real_count - 1);_i++) {
786             _indexed_bytes_items[_i] = _items_temp[_i];
787           }
788         } else {
789           _indexed_bytes_items = new bytes32[](0);
790         }
791       } else {
792         _indexed_bytes_items = new bytes32[](0);
793       }
794     }
795   }*/
796 }
797 
798 library DoublyLinkedList {
799 
800   struct Item {
801     bytes32 item;
802     uint256 previous_index;
803     uint256 next_index;
804   }
805 
806   struct Data {
807     uint256 first_index;
808     uint256 last_index;
809     uint256 count;
810     mapping(bytes32 => uint256) item_index;
811     mapping(uint256 => bool) valid_indexes;
812     Item[] collection;
813   }
814 
815   struct IndexedUint {
816     mapping(bytes32 => Data) data;
817   }
818 
819   struct IndexedAddress {
820     mapping(bytes32 => Data) data;
821   }
822 
823   struct IndexedBytes {
824     mapping(bytes32 => Data) data;
825   }
826 
827   struct Address {
828     Data data;
829   }
830 
831   struct Bytes {
832     Data data;
833   }
834 
835   struct Uint {
836     Data data;
837   }
838 
839   uint256 constant NONE = uint256(0);
840   bytes32 constant EMPTY_BYTES = bytes32(0x0);
841   address constant NULL_ADDRESS = address(0x0);
842 
843   function find(Data storage self, bytes32 _item)
844            public
845            constant
846            returns (uint256 _item_index)
847   {
848     if ((self.item_index[_item] == NONE) && (self.count == NONE)) {
849       _item_index = NONE;
850     } else {
851       _item_index = self.item_index[_item];
852     }
853   }
854 
855   function get(Data storage self, uint256 _item_index)
856            public
857            constant
858            returns (bytes32 _item)
859   {
860     if (self.valid_indexes[_item_index] == true) {
861       _item = self.collection[_item_index - 1].item;
862     } else {
863       _item = EMPTY_BYTES;
864     }
865   }
866 
867   function append(Data storage self, bytes32 _data)
868            internal
869            returns (bool _success)
870   {
871     if (find(self, _data) != NONE || _data == bytes32("")) { // rejects addition of empty values
872       _success = false;
873     } else {
874       uint256 _index = uint256(self.collection.push(Item({item: _data, previous_index: self.last_index, next_index: NONE})));
875       if (self.last_index == NONE) {
876         if ((self.first_index != NONE) || (self.count != NONE)) {
877           revert();
878         } else {
879           self.first_index = self.last_index = _index;
880           self.count = 1;
881         }
882       } else {
883         self.collection[self.last_index - 1].next_index = _index;
884         self.last_index = _index;
885         self.count++;
886       }
887       self.valid_indexes[_index] = true;
888       self.item_index[_data] = _index;
889       _success = true;
890     }
891   }
892 
893   function remove(Data storage self, uint256 _index)
894            internal
895            returns (bool _success)
896   {
897     if (self.valid_indexes[_index] == true) {
898       Item memory item = self.collection[_index - 1];
899       if (item.previous_index == NONE) {
900         self.first_index = item.next_index;
901       } else {
902         self.collection[item.previous_index - 1].next_index = item.next_index;
903       }
904 
905       if (item.next_index == NONE) {
906         self.last_index = item.previous_index;
907       } else {
908         self.collection[item.next_index - 1].previous_index = item.previous_index;
909       }
910       delete self.collection[_index - 1];
911       self.valid_indexes[_index] = false;
912       delete self.item_index[item.item];
913       self.count--;
914       _success = true;
915     } else {
916       _success = false;
917     }
918   }
919 
920   function remove_item(Data storage self, bytes32 _item)
921            internal
922            returns (bool _success)
923   {
924     uint256 _item_index = find(self, _item);
925     if (_item_index != NONE) {
926       require(remove(self, _item_index));
927       _success = true;
928     } else {
929       _success = false;
930     }
931     return _success;
932   }
933 
934   function total(Data storage self)
935            public
936            constant
937            returns (uint256 _total_count)
938   {
939     _total_count = self.count;
940   }
941 
942   function start(Data storage self)
943            public
944            constant
945            returns (uint256 _item_index)
946   {
947     _item_index = self.first_index;
948     return _item_index;
949   }
950 
951   function start_item(Data storage self)
952            public
953            constant
954            returns (bytes32 _item)
955   {
956     uint256 _item_index = start(self);
957     if (_item_index != NONE) {
958       _item = get(self, _item_index);
959     } else {
960       _item = EMPTY_BYTES;
961     }
962   }
963 
964   function end(Data storage self)
965            public
966            constant
967            returns (uint256 _item_index)
968   {
969     _item_index = self.last_index;
970     return _item_index;
971   }
972 
973   function end_item(Data storage self)
974            public
975            constant
976            returns (bytes32 _item)
977   {
978     uint256 _item_index = end(self);
979     if (_item_index != NONE) {
980       _item = get(self, _item_index);
981     } else {
982       _item = EMPTY_BYTES;
983     }
984   }
985 
986   function valid(Data storage self, uint256 _item_index)
987            public
988            constant
989            returns (bool _yes)
990   {
991     _yes = self.valid_indexes[_item_index];
992     //_yes = ((_item_index - 1) < self.collection.length);
993   }
994 
995   function valid_item(Data storage self, bytes32 _item)
996            public
997            constant
998            returns (bool _yes)
999   {
1000     uint256 _item_index = self.item_index[_item];
1001     _yes = self.valid_indexes[_item_index];
1002   }
1003 
1004   function previous(Data storage self, uint256 _current_index)
1005            public
1006            constant
1007            returns (uint256 _previous_index)
1008   {
1009     if (self.valid_indexes[_current_index] == true) {
1010       _previous_index = self.collection[_current_index - 1].previous_index;
1011     } else {
1012       _previous_index = NONE;
1013     }
1014   }
1015 
1016   function previous_item(Data storage self, bytes32 _current_item)
1017            public
1018            constant
1019            returns (bytes32 _previous_item)
1020   {
1021     uint256 _current_index = find(self, _current_item);
1022     if (_current_index != NONE) {
1023       uint256 _previous_index = previous(self, _current_index);
1024       _previous_item = get(self, _previous_index);
1025     } else {
1026       _previous_item = EMPTY_BYTES;
1027     }
1028   }
1029 
1030   function next(Data storage self, uint256 _current_index)
1031            public
1032            constant
1033            returns (uint256 _next_index)
1034   {
1035     if (self.valid_indexes[_current_index] == true) {
1036       _next_index = self.collection[_current_index - 1].next_index;
1037     } else {
1038       _next_index = NONE;
1039     }
1040   }
1041 
1042   function next_item(Data storage self, bytes32 _current_item)
1043            public
1044            constant
1045            returns (bytes32 _next_item)
1046   {
1047     uint256 _current_index = find(self, _current_item);
1048     if (_current_index != NONE) {
1049       uint256 _next_index = next(self, _current_index);
1050       _next_item = get(self, _next_index);
1051     } else {
1052       _next_item = EMPTY_BYTES;
1053     }
1054   }
1055 
1056   function find(Uint storage self, uint256 _item)
1057            public
1058            constant
1059            returns (uint256 _item_index)
1060   {
1061     _item_index = find(self.data, bytes32(_item));
1062   }
1063 
1064   function get(Uint storage self, uint256 _item_index)
1065            public
1066            constant
1067            returns (uint256 _item)
1068   {
1069     _item = uint256(get(self.data, _item_index));
1070   }
1071 
1072 
1073   function append(Uint storage self, uint256 _data)
1074            public
1075            returns (bool _success)
1076   {
1077     _success = append(self.data, bytes32(_data));
1078   }
1079 
1080   function remove(Uint storage self, uint256 _index)
1081            internal
1082            returns (bool _success)
1083   {
1084     _success = remove(self.data, _index);
1085   }
1086 
1087   function remove_item(Uint storage self, uint256 _item)
1088            public
1089            returns (bool _success)
1090   {
1091     _success = remove_item(self.data, bytes32(_item));
1092   }
1093 
1094   function total(Uint storage self)
1095            public
1096            constant
1097            returns (uint256 _total_count)
1098   {
1099     _total_count = total(self.data);
1100   }
1101 
1102   function start(Uint storage self)
1103            public
1104            constant
1105            returns (uint256 _index)
1106   {
1107     _index = start(self.data);
1108   }
1109 
1110   function start_item(Uint storage self)
1111            public
1112            constant
1113            returns (uint256 _start_item)
1114   {
1115     _start_item = uint256(start_item(self.data));
1116   }
1117 
1118 
1119   function end(Uint storage self)
1120            public
1121            constant
1122            returns (uint256 _index)
1123   {
1124     _index = end(self.data);
1125   }
1126 
1127   function end_item(Uint storage self)
1128            public
1129            constant
1130            returns (uint256 _end_item)
1131   {
1132     _end_item = uint256(end_item(self.data));
1133   }
1134 
1135   function valid(Uint storage self, uint256 _item_index)
1136            public
1137            constant
1138            returns (bool _yes)
1139   {
1140     _yes = valid(self.data, _item_index);
1141   }
1142 
1143   function valid_item(Uint storage self, uint256 _item)
1144            public
1145            constant
1146            returns (bool _yes)
1147   {
1148     _yes = valid_item(self.data, bytes32(_item));
1149   }
1150 
1151   function previous(Uint storage self, uint256 _current_index)
1152            public
1153            constant
1154            returns (uint256 _previous_index)
1155   {
1156     _previous_index = previous(self.data, _current_index);
1157   }
1158 
1159   function previous_item(Uint storage self, uint256 _current_item)
1160            public
1161            constant
1162            returns (uint256 _previous_item)
1163   {
1164     _previous_item = uint256(previous_item(self.data, bytes32(_current_item)));
1165   }
1166 
1167   function next(Uint storage self, uint256 _current_index)
1168            public
1169            constant
1170            returns (uint256 _next_index)
1171   {
1172     _next_index = next(self.data, _current_index);
1173   }
1174 
1175   function next_item(Uint storage self, uint256 _current_item)
1176            public
1177            constant
1178            returns (uint256 _next_item)
1179   {
1180     _next_item = uint256(next_item(self.data, bytes32(_current_item)));
1181   }
1182 
1183   function find(Address storage self, address _item)
1184            public
1185            constant
1186            returns (uint256 _item_index)
1187   {
1188     _item_index = find(self.data, bytes32(_item));
1189   }
1190 
1191   function get(Address storage self, uint256 _item_index)
1192            public
1193            constant
1194            returns (address _item)
1195   {
1196     _item = address(get(self.data, _item_index));
1197   }
1198 
1199 
1200   function find(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
1201            public
1202            constant
1203            returns (uint256 _item_index)
1204   {
1205     _item_index = find(self.data[_collection_index], bytes32(_item));
1206   }
1207 
1208   function get(IndexedUint storage self, bytes32 _collection_index, uint256 _item_index)
1209            public
1210            constant
1211            returns (uint256 _item)
1212   {
1213     _item = uint256(get(self.data[_collection_index], _item_index));
1214   }
1215 
1216 
1217   function append(IndexedUint storage self, bytes32 _collection_index, uint256 _data)
1218            public
1219            returns (bool _success)
1220   {
1221     _success = append(self.data[_collection_index], bytes32(_data));
1222   }
1223 
1224   function remove(IndexedUint storage self, bytes32 _collection_index, uint256 _index)
1225            internal
1226            returns (bool _success)
1227   {
1228     _success = remove(self.data[_collection_index], _index);
1229   }
1230 
1231   function remove_item(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
1232            public
1233            returns (bool _success)
1234   {
1235     _success = remove_item(self.data[_collection_index], bytes32(_item));
1236   }
1237 
1238   function total(IndexedUint storage self, bytes32 _collection_index)
1239            public
1240            constant
1241            returns (uint256 _total_count)
1242   {
1243     _total_count = total(self.data[_collection_index]);
1244   }
1245 
1246   function start(IndexedUint storage self, bytes32 _collection_index)
1247            public
1248            constant
1249            returns (uint256 _index)
1250   {
1251     _index = start(self.data[_collection_index]);
1252   }
1253 
1254   function start_item(IndexedUint storage self, bytes32 _collection_index)
1255            public
1256            constant
1257            returns (uint256 _start_item)
1258   {
1259     _start_item = uint256(start_item(self.data[_collection_index]));
1260   }
1261 
1262 
1263   function end(IndexedUint storage self, bytes32 _collection_index)
1264            public
1265            constant
1266            returns (uint256 _index)
1267   {
1268     _index = end(self.data[_collection_index]);
1269   }
1270 
1271   function end_item(IndexedUint storage self, bytes32 _collection_index)
1272            public
1273            constant
1274            returns (uint256 _end_item)
1275   {
1276     _end_item = uint256(end_item(self.data[_collection_index]));
1277   }
1278 
1279   function valid(IndexedUint storage self, bytes32 _collection_index, uint256 _item_index)
1280            public
1281            constant
1282            returns (bool _yes)
1283   {
1284     _yes = valid(self.data[_collection_index], _item_index);
1285   }
1286 
1287   function valid_item(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
1288            public
1289            constant
1290            returns (bool _yes)
1291   {
1292     _yes = valid_item(self.data[_collection_index], bytes32(_item));
1293   }
1294 
1295   function previous(IndexedUint storage self, bytes32 _collection_index, uint256 _current_index)
1296            public
1297            constant
1298            returns (uint256 _previous_index)
1299   {
1300     _previous_index = previous(self.data[_collection_index], _current_index);
1301   }
1302 
1303   function previous_item(IndexedUint storage self, bytes32 _collection_index, uint256 _current_item)
1304            public
1305            constant
1306            returns (uint256 _previous_item)
1307   {
1308     _previous_item = uint256(previous_item(self.data[_collection_index], bytes32(_current_item)));
1309   }
1310 
1311   function next(IndexedUint storage self, bytes32 _collection_index, uint256 _current_index)
1312            public
1313            constant
1314            returns (uint256 _next_index)
1315   {
1316     _next_index = next(self.data[_collection_index], _current_index);
1317   }
1318 
1319   function next_item(IndexedUint storage self, bytes32 _collection_index, uint256 _current_item)
1320            public
1321            constant
1322            returns (uint256 _next_item)
1323   {
1324     _next_item = uint256(next_item(self.data[_collection_index], bytes32(_current_item)));
1325   }
1326 
1327   function append(Address storage self, address _data)
1328            public
1329            returns (bool _success)
1330   {
1331     _success = append(self.data, bytes32(_data));
1332   }
1333 
1334   function remove(Address storage self, uint256 _index)
1335            internal
1336            returns (bool _success)
1337   {
1338     _success = remove(self.data, _index);
1339   }
1340 
1341 
1342   function remove_item(Address storage self, address _item)
1343            public
1344            returns (bool _success)
1345   {
1346     _success = remove_item(self.data, bytes32(_item));
1347   }
1348 
1349   function total(Address storage self)
1350            public
1351            constant
1352            returns (uint256 _total_count)
1353   {
1354     _total_count = total(self.data);
1355   }
1356 
1357   function start(Address storage self)
1358            public
1359            constant
1360            returns (uint256 _index)
1361   {
1362     _index = start(self.data);
1363   }
1364 
1365   function start_item(Address storage self)
1366            public
1367            constant
1368            returns (address _start_item)
1369   {
1370     _start_item = address(start_item(self.data));
1371   }
1372 
1373 
1374   function end(Address storage self)
1375            public
1376            constant
1377            returns (uint256 _index)
1378   {
1379     _index = end(self.data);
1380   }
1381 
1382   function end_item(Address storage self)
1383            public
1384            constant
1385            returns (address _end_item)
1386   {
1387     _end_item = address(end_item(self.data));
1388   }
1389 
1390   function valid(Address storage self, uint256 _item_index)
1391            public
1392            constant
1393            returns (bool _yes)
1394   {
1395     _yes = valid(self.data, _item_index);
1396   }
1397 
1398   function valid_item(Address storage self, address _item)
1399            public
1400            constant
1401            returns (bool _yes)
1402   {
1403     _yes = valid_item(self.data, bytes32(_item));
1404   }
1405 
1406   function previous(Address storage self, uint256 _current_index)
1407            public
1408            constant
1409            returns (uint256 _previous_index)
1410   {
1411     _previous_index = previous(self.data, _current_index);
1412   }
1413 
1414   function previous_item(Address storage self, address _current_item)
1415            public
1416            constant
1417            returns (address _previous_item)
1418   {
1419     _previous_item = address(previous_item(self.data, bytes32(_current_item)));
1420   }
1421 
1422   function next(Address storage self, uint256 _current_index)
1423            public
1424            constant
1425            returns (uint256 _next_index)
1426   {
1427     _next_index = next(self.data, _current_index);
1428   }
1429 
1430   function next_item(Address storage self, address _current_item)
1431            public
1432            constant
1433            returns (address _next_item)
1434   {
1435     _next_item = address(next_item(self.data, bytes32(_current_item)));
1436   }
1437 
1438   function append(IndexedAddress storage self, bytes32 _collection_index, address _data)
1439            public
1440            returns (bool _success)
1441   {
1442     _success = append(self.data[_collection_index], bytes32(_data));
1443   }
1444 
1445   function remove(IndexedAddress storage self, bytes32 _collection_index, uint256 _index)
1446            internal
1447            returns (bool _success)
1448   {
1449     _success = remove(self.data[_collection_index], _index);
1450   }
1451 
1452 
1453   function remove_item(IndexedAddress storage self, bytes32 _collection_index, address _item)
1454            public
1455            returns (bool _success)
1456   {
1457     _success = remove_item(self.data[_collection_index], bytes32(_item));
1458   }
1459 
1460   function total(IndexedAddress storage self, bytes32 _collection_index)
1461            public
1462            constant
1463            returns (uint256 _total_count)
1464   {
1465     _total_count = total(self.data[_collection_index]);
1466   }
1467 
1468   function start(IndexedAddress storage self, bytes32 _collection_index)
1469            public
1470            constant
1471            returns (uint256 _index)
1472   {
1473     _index = start(self.data[_collection_index]);
1474   }
1475 
1476   function start_item(IndexedAddress storage self, bytes32 _collection_index)
1477            public
1478            constant
1479            returns (address _start_item)
1480   {
1481     _start_item = address(start_item(self.data[_collection_index]));
1482   }
1483 
1484 
1485   function end(IndexedAddress storage self, bytes32 _collection_index)
1486            public
1487            constant
1488            returns (uint256 _index)
1489   {
1490     _index = end(self.data[_collection_index]);
1491   }
1492 
1493   function end_item(IndexedAddress storage self, bytes32 _collection_index)
1494            public
1495            constant
1496            returns (address _end_item)
1497   {
1498     _end_item = address(end_item(self.data[_collection_index]));
1499   }
1500 
1501   function valid(IndexedAddress storage self, bytes32 _collection_index, uint256 _item_index)
1502            public
1503            constant
1504            returns (bool _yes)
1505   {
1506     _yes = valid(self.data[_collection_index], _item_index);
1507   }
1508 
1509   function valid_item(IndexedAddress storage self, bytes32 _collection_index, address _item)
1510            public
1511            constant
1512            returns (bool _yes)
1513   {
1514     _yes = valid_item(self.data[_collection_index], bytes32(_item));
1515   }
1516 
1517   function previous(IndexedAddress storage self, bytes32 _collection_index, uint256 _current_index)
1518            public
1519            constant
1520            returns (uint256 _previous_index)
1521   {
1522     _previous_index = previous(self.data[_collection_index], _current_index);
1523   }
1524 
1525   function previous_item(IndexedAddress storage self, bytes32 _collection_index, address _current_item)
1526            public
1527            constant
1528            returns (address _previous_item)
1529   {
1530     _previous_item = address(previous_item(self.data[_collection_index], bytes32(_current_item)));
1531   }
1532 
1533   function next(IndexedAddress storage self, bytes32 _collection_index, uint256 _current_index)
1534            public
1535            constant
1536            returns (uint256 _next_index)
1537   {
1538     _next_index = next(self.data[_collection_index], _current_index);
1539   }
1540 
1541   function next_item(IndexedAddress storage self, bytes32 _collection_index, address _current_item)
1542            public
1543            constant
1544            returns (address _next_item)
1545   {
1546     _next_item = address(next_item(self.data[_collection_index], bytes32(_current_item)));
1547   }
1548 
1549 
1550   function find(Bytes storage self, bytes32 _item)
1551            public
1552            constant
1553            returns (uint256 _item_index)
1554   {
1555     _item_index = find(self.data, _item);
1556   }
1557 
1558   function get(Bytes storage self, uint256 _item_index)
1559            public
1560            constant
1561            returns (bytes32 _item)
1562   {
1563     _item = get(self.data, _item_index);
1564   }
1565 
1566 
1567   function append(Bytes storage self, bytes32 _data)
1568            public
1569            returns (bool _success)
1570   {
1571     _success = append(self.data, _data);
1572   }
1573 
1574   function remove(Bytes storage self, uint256 _index)
1575            internal
1576            returns (bool _success)
1577   {
1578     _success = remove(self.data, _index);
1579   }
1580 
1581 
1582   function remove_item(Bytes storage self, bytes32 _item)
1583            public
1584            returns (bool _success)
1585   {
1586     _success = remove_item(self.data, _item);
1587   }
1588 
1589   function total(Bytes storage self)
1590            public
1591            constant
1592            returns (uint256 _total_count)
1593   {
1594     _total_count = total(self.data);
1595   }
1596 
1597   function start(Bytes storage self)
1598            public
1599            constant
1600            returns (uint256 _index)
1601   {
1602     _index = start(self.data);
1603   }
1604 
1605   function start_item(Bytes storage self)
1606            public
1607            constant
1608            returns (bytes32 _start_item)
1609   {
1610     _start_item = start_item(self.data);
1611   }
1612 
1613 
1614   function end(Bytes storage self)
1615            public
1616            constant
1617            returns (uint256 _index)
1618   {
1619     _index = end(self.data);
1620   }
1621 
1622   function end_item(Bytes storage self)
1623            public
1624            constant
1625            returns (bytes32 _end_item)
1626   {
1627     _end_item = end_item(self.data);
1628   }
1629 
1630   function valid(Bytes storage self, uint256 _item_index)
1631            public
1632            constant
1633            returns (bool _yes)
1634   {
1635     _yes = valid(self.data, _item_index);
1636   }
1637 
1638   function valid_item(Bytes storage self, bytes32 _item)
1639            public
1640            constant
1641            returns (bool _yes)
1642   {
1643     _yes = valid_item(self.data, _item);
1644   }
1645 
1646   function previous(Bytes storage self, uint256 _current_index)
1647            public
1648            constant
1649            returns (uint256 _previous_index)
1650   {
1651     _previous_index = previous(self.data, _current_index);
1652   }
1653 
1654   function previous_item(Bytes storage self, bytes32 _current_item)
1655            public
1656            constant
1657            returns (bytes32 _previous_item)
1658   {
1659     _previous_item = previous_item(self.data, _current_item);
1660   }
1661 
1662   function next(Bytes storage self, uint256 _current_index)
1663            public
1664            constant
1665            returns (uint256 _next_index)
1666   {
1667     _next_index = next(self.data, _current_index);
1668   }
1669 
1670   function next_item(Bytes storage self, bytes32 _current_item)
1671            public
1672            constant
1673            returns (bytes32 _next_item)
1674   {
1675     _next_item = next_item(self.data, _current_item);
1676   }
1677 
1678   function append(IndexedBytes storage self, bytes32 _collection_index, bytes32 _data)
1679            public
1680            returns (bool _success)
1681   {
1682     _success = append(self.data[_collection_index], bytes32(_data));
1683   }
1684 
1685   function remove(IndexedBytes storage self, bytes32 _collection_index, uint256 _index)
1686            internal
1687            returns (bool _success)
1688   {
1689     _success = remove(self.data[_collection_index], _index);
1690   }
1691 
1692 
1693   function remove_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _item)
1694            public
1695            returns (bool _success)
1696   {
1697     _success = remove_item(self.data[_collection_index], bytes32(_item));
1698   }
1699 
1700   function total(IndexedBytes storage self, bytes32 _collection_index)
1701            public
1702            constant
1703            returns (uint256 _total_count)
1704   {
1705     _total_count = total(self.data[_collection_index]);
1706   }
1707 
1708   function start(IndexedBytes storage self, bytes32 _collection_index)
1709            public
1710            constant
1711            returns (uint256 _index)
1712   {
1713     _index = start(self.data[_collection_index]);
1714   }
1715 
1716   function start_item(IndexedBytes storage self, bytes32 _collection_index)
1717            public
1718            constant
1719            returns (bytes32 _start_item)
1720   {
1721     _start_item = bytes32(start_item(self.data[_collection_index]));
1722   }
1723 
1724 
1725   function end(IndexedBytes storage self, bytes32 _collection_index)
1726            public
1727            constant
1728            returns (uint256 _index)
1729   {
1730     _index = end(self.data[_collection_index]);
1731   }
1732 
1733   function end_item(IndexedBytes storage self, bytes32 _collection_index)
1734            public
1735            constant
1736            returns (bytes32 _end_item)
1737   {
1738     _end_item = bytes32(end_item(self.data[_collection_index]));
1739   }
1740 
1741   function valid(IndexedBytes storage self, bytes32 _collection_index, uint256 _item_index)
1742            public
1743            constant
1744            returns (bool _yes)
1745   {
1746     _yes = valid(self.data[_collection_index], _item_index);
1747   }
1748 
1749   function valid_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _item)
1750            public
1751            constant
1752            returns (bool _yes)
1753   {
1754     _yes = valid_item(self.data[_collection_index], bytes32(_item));
1755   }
1756 
1757   function previous(IndexedBytes storage self, bytes32 _collection_index, uint256 _current_index)
1758            public
1759            constant
1760            returns (uint256 _previous_index)
1761   {
1762     _previous_index = previous(self.data[_collection_index], _current_index);
1763   }
1764 
1765   function previous_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _current_item)
1766            public
1767            constant
1768            returns (bytes32 _previous_item)
1769   {
1770     _previous_item = bytes32(previous_item(self.data[_collection_index], bytes32(_current_item)));
1771   }
1772 
1773   function next(IndexedBytes storage self, bytes32 _collection_index, uint256 _current_index)
1774            public
1775            constant
1776            returns (uint256 _next_index)
1777   {
1778     _next_index = next(self.data[_collection_index], _current_index);
1779   }
1780 
1781   function next_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _current_item)
1782            public
1783            constant
1784            returns (bytes32 _next_item)
1785   {
1786     _next_item = bytes32(next_item(self.data[_collection_index], bytes32(_current_item)));
1787   }
1788 }
1789 
1790 /**
1791   @title Bytes Iterator Storage
1792   @author DigixGlobal Pte Ltd
1793 */
1794 contract BytesIteratorStorage {
1795 
1796   // Initialize Doubly Linked List of Bytes
1797   using DoublyLinkedList for DoublyLinkedList.Bytes;
1798 
1799   /**
1800     @notice Reads the first item from the list of Bytes
1801     @param _list The source list
1802     @return {"_item": "The first item from the list"}
1803   */
1804   function read_first_from_bytesarray(DoublyLinkedList.Bytes storage _list)
1805            internal
1806            constant
1807            returns (bytes32 _item)
1808   {
1809     _item = _list.start_item();
1810   }
1811 
1812   /**
1813     @notice Reads the last item from the list of Bytes
1814     @param _list The source list
1815     @return {"_item": "The last item from the list"}
1816   */
1817   function read_last_from_bytesarray(DoublyLinkedList.Bytes storage _list)
1818            internal
1819            constant
1820            returns (bytes32 _item)
1821   {
1822     _item = _list.end_item();
1823   }
1824 
1825   /**
1826     @notice Reads the next item on the list of Bytes
1827     @param _list The source list
1828     @param _current_item The current item to be used as base line
1829     @return {"_item": "The next item from the list based on the specieid `_current_item`"}
1830     TODO: Need to verify what happens if the specified `_current_item` is the last item from the list
1831   */
1832   function read_next_from_bytesarray(DoublyLinkedList.Bytes storage _list, bytes32 _current_item)
1833            internal
1834            constant
1835            returns (bytes32 _item)
1836   {
1837     _item = _list.next_item(_current_item);
1838   }
1839 
1840   /**
1841     @notice Reads the previous item on the list of Bytes
1842     @param _list The source list
1843     @param _current_item The current item to be used as base line
1844     @return {"_item": "The previous item from the list based on the spcified `_current_item`"}
1845     TODO: Need to verify what happens if the specified `_current_item` is the first item from the list
1846   */
1847   function read_previous_from_bytesarray(DoublyLinkedList.Bytes storage _list, bytes32 _current_item)
1848            internal
1849            constant
1850            returns (bytes32 _item)
1851   {
1852     _item = _list.previous_item(_current_item);
1853   }
1854 
1855   /**
1856     @notice Reads the list of Bytes and returns the length of the list
1857     @param _list The source list
1858     @return {"count": "`uint256` The lenght of the list"}
1859 
1860   */
1861   function read_total_bytesarray(DoublyLinkedList.Bytes storage _list)
1862            internal
1863            constant
1864            returns (uint256 _count)
1865   {
1866     _count = _list.total();
1867   }
1868 }
1869 
1870 /**
1871  * @title SafeMath
1872  * @dev Math operations with safety checks that throw on error
1873  */
1874 library SafeMath {
1875 
1876   /**
1877   * @dev Multiplies two numbers, throws on overflow.
1878   */
1879   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1880     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1881     // benefit is lost if 'b' is also tested.
1882     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1883     if (_a == 0) {
1884       return 0;
1885     }
1886 
1887     c = _a * _b;
1888     assert(c / _a == _b);
1889     return c;
1890   }
1891 
1892   /**
1893   * @dev Integer division of two numbers, truncating the quotient.
1894   */
1895   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1896     // assert(_b > 0); // Solidity automatically throws when dividing by 0
1897     // uint256 c = _a / _b;
1898     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1899     return _a / _b;
1900   }
1901 
1902   /**
1903   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1904   */
1905   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1906     assert(_b <= _a);
1907     return _a - _b;
1908   }
1909 
1910   /**
1911   * @dev Adds two numbers, throws on overflow.
1912   */
1913   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1914     c = _a + _b;
1915     assert(c >= _a);
1916     return c;
1917   }
1918 }
1919 
1920 contract DaoConstants {
1921     using SafeMath for uint256;
1922     bytes32 EMPTY_BYTES = bytes32(0x0);
1923     address EMPTY_ADDRESS = address(0x0);
1924 
1925 
1926     bytes32 PROPOSAL_STATE_PREPROPOSAL = "proposal_state_preproposal";
1927     bytes32 PROPOSAL_STATE_DRAFT = "proposal_state_draft";
1928     bytes32 PROPOSAL_STATE_MODERATED = "proposal_state_moderated";
1929     bytes32 PROPOSAL_STATE_ONGOING = "proposal_state_ongoing";
1930     bytes32 PROPOSAL_STATE_CLOSED = "proposal_state_closed";
1931     bytes32 PROPOSAL_STATE_ARCHIVED = "proposal_state_archived";
1932 
1933     uint256 PRL_ACTION_STOP = 1;
1934     uint256 PRL_ACTION_PAUSE = 2;
1935     uint256 PRL_ACTION_UNPAUSE = 3;
1936 
1937     uint256 COLLATERAL_STATUS_UNLOCKED = 1;
1938     uint256 COLLATERAL_STATUS_LOCKED = 2;
1939     uint256 COLLATERAL_STATUS_CLAIMED = 3;
1940 
1941     bytes32 INTERMEDIATE_DGD_IDENTIFIER = "inter_dgd_id";
1942     bytes32 INTERMEDIATE_MODERATOR_DGD_IDENTIFIER = "inter_mod_dgd_id";
1943     bytes32 INTERMEDIATE_BONUS_CALCULATION_IDENTIFIER = "inter_bonus_calculation_id";
1944 
1945     // interactive contracts
1946     bytes32 CONTRACT_DAO = "dao";
1947     bytes32 CONTRACT_DAO_SPECIAL_PROPOSAL = "dao:special:proposal";
1948     bytes32 CONTRACT_DAO_STAKE_LOCKING = "dao:stake-locking";
1949     bytes32 CONTRACT_DAO_VOTING = "dao:voting";
1950     bytes32 CONTRACT_DAO_VOTING_CLAIMS = "dao:voting:claims";
1951     bytes32 CONTRACT_DAO_SPECIAL_VOTING_CLAIMS = "dao:svoting:claims";
1952     bytes32 CONTRACT_DAO_IDENTITY = "dao:identity";
1953     bytes32 CONTRACT_DAO_REWARDS_MANAGER = "dao:rewards-manager";
1954     bytes32 CONTRACT_DAO_REWARDS_MANAGER_EXTRAS = "dao:rewards-extras";
1955     bytes32 CONTRACT_DAO_ROLES = "dao:roles";
1956     bytes32 CONTRACT_DAO_FUNDING_MANAGER = "dao:funding-manager";
1957     bytes32 CONTRACT_DAO_WHITELISTING = "dao:whitelisting";
1958     bytes32 CONTRACT_DAO_INFORMATION = "dao:information";
1959 
1960     // service contracts
1961     bytes32 CONTRACT_SERVICE_ROLE = "service:role";
1962     bytes32 CONTRACT_SERVICE_DAO_INFO = "service:dao:info";
1963     bytes32 CONTRACT_SERVICE_DAO_LISTING = "service:dao:listing";
1964     bytes32 CONTRACT_SERVICE_DAO_CALCULATOR = "service:dao:calculator";
1965 
1966     // storage contracts
1967     bytes32 CONTRACT_STORAGE_DAO = "storage:dao";
1968     bytes32 CONTRACT_STORAGE_DAO_COUNTER = "storage:dao:counter";
1969     bytes32 CONTRACT_STORAGE_DAO_UPGRADE = "storage:dao:upgrade";
1970     bytes32 CONTRACT_STORAGE_DAO_IDENTITY = "storage:dao:identity";
1971     bytes32 CONTRACT_STORAGE_DAO_POINTS = "storage:dao:points";
1972     bytes32 CONTRACT_STORAGE_DAO_SPECIAL = "storage:dao:special";
1973     bytes32 CONTRACT_STORAGE_DAO_CONFIG = "storage:dao:config";
1974     bytes32 CONTRACT_STORAGE_DAO_STAKE = "storage:dao:stake";
1975     bytes32 CONTRACT_STORAGE_DAO_REWARDS = "storage:dao:rewards";
1976     bytes32 CONTRACT_STORAGE_DAO_WHITELISTING = "storage:dao:whitelisting";
1977     bytes32 CONTRACT_STORAGE_INTERMEDIATE_RESULTS = "storage:intermediate:results";
1978 
1979     bytes32 CONTRACT_DGD_TOKEN = "t:dgd";
1980     bytes32 CONTRACT_DGX_TOKEN = "t:dgx";
1981     bytes32 CONTRACT_BADGE_TOKEN = "t:badge";
1982 
1983     uint8 ROLES_ROOT = 1;
1984     uint8 ROLES_FOUNDERS = 2;
1985     uint8 ROLES_PRLS = 3;
1986     uint8 ROLES_KYC_ADMINS = 4;
1987 
1988     uint256 QUARTER_DURATION = 90 days;
1989 
1990     bytes32 CONFIG_MINIMUM_LOCKED_DGD = "min_dgd_participant";
1991     bytes32 CONFIG_MINIMUM_DGD_FOR_MODERATOR = "min_dgd_moderator";
1992     bytes32 CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR = "min_reputation_moderator";
1993 
1994     bytes32 CONFIG_LOCKING_PHASE_DURATION = "locking_phase_duration";
1995     bytes32 CONFIG_QUARTER_DURATION = "quarter_duration";
1996     bytes32 CONFIG_VOTING_COMMIT_PHASE = "voting_commit_phase";
1997     bytes32 CONFIG_VOTING_PHASE_TOTAL = "voting_phase_total";
1998     bytes32 CONFIG_INTERIM_COMMIT_PHASE = "interim_voting_commit_phase";
1999     bytes32 CONFIG_INTERIM_PHASE_TOTAL = "interim_voting_phase_total";
2000 
2001     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR = "draft_quorum_fixed_numerator";
2002     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR = "draft_quorum_fixed_denominator";
2003     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR = "draft_quorum_sfactor_numerator";
2004     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR = "draft_quorum_sfactor_denominator";
2005     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR = "vote_quorum_fixed_numerator";
2006     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR = "vote_quorum_fixed_denominator";
2007     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR = "vote_quorum_sfactor_numerator";
2008     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR = "vote_quorum_sfactor_denominator";
2009     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR = "final_reward_sfactor_numerator";
2010     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR = "final_reward_sfactor_denominator";
2011 
2012     bytes32 CONFIG_DRAFT_QUOTA_NUMERATOR = "draft_quota_numerator";
2013     bytes32 CONFIG_DRAFT_QUOTA_DENOMINATOR = "draft_quota_denominator";
2014     bytes32 CONFIG_VOTING_QUOTA_NUMERATOR = "voting_quota_numerator";
2015     bytes32 CONFIG_VOTING_QUOTA_DENOMINATOR = "voting_quota_denominator";
2016 
2017     bytes32 CONFIG_MINIMAL_QUARTER_POINT = "minimal_qp";
2018     bytes32 CONFIG_QUARTER_POINT_SCALING_FACTOR = "quarter_point_scaling_factor";
2019     bytes32 CONFIG_REPUTATION_POINT_SCALING_FACTOR = "rep_point_scaling_factor";
2020 
2021     bytes32 CONFIG_MODERATOR_MINIMAL_QUARTER_POINT = "minimal_mod_qp";
2022     bytes32 CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR = "mod_qp_scaling_factor";
2023     bytes32 CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR = "mod_rep_point_scaling_factor";
2024 
2025     bytes32 CONFIG_QUARTER_POINT_DRAFT_VOTE = "quarter_point_draft_vote";
2026     bytes32 CONFIG_QUARTER_POINT_VOTE = "quarter_point_vote";
2027     bytes32 CONFIG_QUARTER_POINT_INTERIM_VOTE = "quarter_point_interim_vote";
2028 
2029     /// this is per 10000 ETHs
2030     bytes32 CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH = "q_p_milestone_completion";
2031 
2032     bytes32 CONFIG_BONUS_REPUTATION_NUMERATOR = "bonus_reputation_numerator";
2033     bytes32 CONFIG_BONUS_REPUTATION_DENOMINATOR = "bonus_reputation_denominator";
2034 
2035     bytes32 CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE = "special_proposal_commit_phase";
2036     bytes32 CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL = "special_proposal_phase_total";
2037 
2038     bytes32 CONFIG_SPECIAL_QUOTA_NUMERATOR = "config_special_quota_numerator";
2039     bytes32 CONFIG_SPECIAL_QUOTA_DENOMINATOR = "config_special_quota_denominator";
2040 
2041     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR = "special_quorum_numerator";
2042     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR = "special_quorum_denominator";
2043 
2044     bytes32 CONFIG_MAXIMUM_REPUTATION_DEDUCTION = "config_max_reputation_deduction";
2045     bytes32 CONFIG_PUNISHMENT_FOR_NOT_LOCKING = "config_punishment_not_locking";
2046 
2047     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_NUM = "config_rep_per_extra_qp_num";
2048     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_DEN = "config_rep_per_extra_qp_den";
2049 
2050     bytes32 CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION = "config_max_m_rp_deduction";
2051     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM = "config_rep_per_extra_m_qp_num";
2052     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN = "config_rep_per_extra_m_qp_den";
2053 
2054     bytes32 CONFIG_PORTION_TO_MODERATORS_NUM = "config_mod_portion_num";
2055     bytes32 CONFIG_PORTION_TO_MODERATORS_DEN = "config_mod_portion_den";
2056 
2057     bytes32 CONFIG_DRAFT_VOTING_PHASE = "config_draft_voting_phase";
2058 
2059     bytes32 CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE = "config_rp_boost_per_badge";
2060 
2061     bytes32 CONFIG_VOTE_CLAIMING_DEADLINE = "config_claiming_deadline";
2062 
2063     bytes32 CONFIG_PREPROPOSAL_COLLATERAL = "config_preproposal_collateral";
2064 
2065     bytes32 CONFIG_MAX_FUNDING_FOR_NON_DIGIX = "config_max_funding_nonDigix";
2066     bytes32 CONFIG_MAX_MILESTONES_FOR_NON_DIGIX = "config_max_milestones_nonDigix";
2067     bytes32 CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER = "config_nonDigix_proposal_cap";
2068 
2069     bytes32 CONFIG_PROPOSAL_DEAD_DURATION = "config_dead_duration";
2070     bytes32 CONFIG_CARBON_VOTE_REPUTATION_BONUS = "config_cv_reputation";
2071 }
2072 
2073 // This contract is basically created to restrict read access to
2074 // ethereum accounts, and whitelisted contracts
2075 contract DaoWhitelistingStorage is ResolverClient, DaoConstants {
2076 
2077     // we want to avoid the scenario in which an on-chain bribing contract
2078     // can be deployed to distribute funds in a trustless way by verifying
2079     // on-chain votes. This mapping marks whether a contract address is whitelisted
2080     // to read from the read functions in DaoStorage, DaoSpecialStorage, etc.
2081     mapping (address => bool) public whitelist;
2082 
2083     constructor(address _resolver)
2084         public
2085     {
2086         require(init(CONTRACT_STORAGE_DAO_WHITELISTING, _resolver));
2087     }
2088 
2089     function setWhitelisted(address _contractAddress, bool _senderIsAllowedToRead)
2090         public
2091     {
2092         require(sender_is(CONTRACT_DAO_WHITELISTING));
2093         whitelist[_contractAddress] = _senderIsAllowedToRead;
2094     }
2095 }
2096 
2097 contract DaoWhitelistingCommon is ResolverClient, DaoConstants {
2098 
2099     function daoWhitelistingStorage()
2100         internal
2101         view
2102         returns (DaoWhitelistingStorage _contract)
2103     {
2104         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
2105     }
2106 
2107     /**
2108     @notice Check if a certain address is whitelisted to read sensitive information in the storage layer
2109     @dev if the address is an account, it is allowed to read. If the address is a contract, it has to be in the whitelist
2110     */
2111     function senderIsAllowedToRead()
2112         internal
2113         view
2114         returns (bool _senderIsAllowedToRead)
2115     {
2116         // msg.sender is allowed to read only if its an EOA or a whitelisted contract
2117         _senderIsAllowedToRead = (msg.sender == tx.origin) || daoWhitelistingStorage().whitelist(msg.sender);
2118     }
2119 }
2120 
2121 library DaoStructs {
2122     using DoublyLinkedList for DoublyLinkedList.Bytes;
2123     using SafeMath for uint256;
2124     bytes32 constant EMPTY_BYTES = bytes32(0x0);
2125 
2126     struct PrlAction {
2127         // UTC timestamp at which the PRL action was done
2128         uint256 at;
2129 
2130         // IPFS hash of the document summarizing the action
2131         bytes32 doc;
2132 
2133         // Type of action
2134         // check PRL_ACTION_* in "./../common/DaoConstants.sol"
2135         uint256 actionId;
2136     }
2137 
2138     struct Voting {
2139         // UTC timestamp at which the voting round starts
2140         uint256 startTime;
2141 
2142         // Mapping of whether a commit was used in this voting round
2143         mapping (bytes32 => bool) usedCommits;
2144 
2145         // Mapping of commits by address. These are the commits during the commit phase in a voting round
2146         // This only stores the most recent commit in the voting round
2147         // In case a vote is edited, the previous commit is overwritten by the new commit
2148         // Only this new commit is verified at the reveal phase
2149         mapping (address => bytes32) commits;
2150 
2151         // This mapping is updated after the reveal phase, when votes are revealed
2152         // It is a mapping of address to weight of vote
2153         // Weight implies the lockedDGDStake of the address, at the time of revealing
2154         // If the address voted "NO", or didn't vote, this would be 0
2155         mapping (address => uint256) yesVotes;
2156 
2157         // This mapping is updated after the reveal phase, when votes are revealed
2158         // It is a mapping of address to weight of vote
2159         // Weight implies the lockedDGDStake of the address, at the time of revealing
2160         // If the address voted "YES", or didn't vote, this would be 0
2161         mapping (address => uint256) noVotes;
2162 
2163         // Boolean whether the voting round passed or not
2164         bool passed;
2165 
2166         // Boolean whether the voting round results were claimed or not
2167         // refer the claimProposalVotingResult function in "./../interative/DaoVotingClaims.sol"
2168         bool claimed;
2169 
2170         // Boolean whether the milestone following this voting round was funded or not
2171         // The milestone is funded when the proposer calls claimFunding in "./../interactive/DaoFundingManager.sol"
2172         bool funded;
2173     }
2174 
2175     struct ProposalVersion {
2176         // IPFS doc hash of this version of the proposal
2177         bytes32 docIpfsHash;
2178 
2179         // UTC timestamp at which this version was created
2180         uint256 created;
2181 
2182         // The number of milestones in the proposal as per this version
2183         uint256 milestoneCount;
2184 
2185         // The final reward asked by the proposer for completion of the entire proposal
2186         uint256 finalReward;
2187 
2188         // List of fundings required by the proposal as per this version
2189         // The numbers are in wei
2190         uint256[] milestoneFundings;
2191 
2192         // When a proposal is finalized (calling Dao.finalizeProposal), the proposer can no longer add proposal versions
2193         // However, they can still add more details to this final proposal version, in the form of IPFS docs.
2194         // These IPFS docs are stored in this array
2195         bytes32[] moreDocs;
2196     }
2197 
2198     struct Proposal {
2199         // ID of the proposal. Also the IPFS hash of the first ProposalVersion
2200         bytes32 proposalId;
2201 
2202         // current state of the proposal
2203         // refer PROPOSAL_STATE_* in "./../common/DaoConstants.sol"
2204         bytes32 currentState;
2205 
2206         // UTC timestamp at which the proposal was created
2207         uint256 timeCreated;
2208 
2209         // DoublyLinkedList of IPFS doc hashes of the various versions of the proposal
2210         DoublyLinkedList.Bytes proposalVersionDocs;
2211 
2212         // Mapping of version (IPFS doc hash) to ProposalVersion struct
2213         mapping (bytes32 => ProposalVersion) proposalVersions;
2214 
2215         // Voting struct for the draft voting round
2216         Voting draftVoting;
2217 
2218         // Mapping of voting round index (starts from 0) to Voting struct
2219         // votingRounds[0] is the Voting round of the proposal, which lasts for get_uint_config(CONFIG_VOTING_PHASE_TOTAL)
2220         // votingRounds[i] for i>0 are the Interim Voting rounds of the proposal, which lasts for get_uint_config(CONFIG_INTERIM_PHASE_TOTAL)
2221         mapping (uint256 => Voting) votingRounds;
2222 
2223         // Every proposal has a collateral tied to it with a value of
2224         // get_uint_config(CONFIG_PREPROPOSAL_COLLATERAL) (refer "./../storage/DaoConfigsStorage.sol")
2225         // Collateral can be in different states
2226         // refer COLLATERAL_STATUS_* in "./../common/DaoConstants.sol"
2227         uint256 collateralStatus;
2228         uint256 collateralAmount;
2229 
2230         // The final version of the proposal
2231         // Every proposal needs to be finalized before it can be voted on
2232         // This is the IPFS doc hash of the final version
2233         bytes32 finalVersion;
2234 
2235         // List of PrlAction structs
2236         // These are all the actions done by the PRL on the proposal
2237         PrlAction[] prlActions;
2238 
2239         // Address of the user who created the proposal
2240         address proposer;
2241 
2242         // Address of the moderator who endorsed the proposal
2243         address endorser;
2244 
2245         // Boolean whether the proposal is paused/stopped at the moment
2246         bool isPausedOrStopped;
2247 
2248         // Boolean whether the proposal was created by a founder role
2249         bool isDigix;
2250     }
2251 
2252     function countVotes(Voting storage _voting, address[] _allUsers)
2253         external
2254         view
2255         returns (uint256 _for, uint256 _against)
2256     {
2257         uint256 _n = _allUsers.length;
2258         for (uint256 i = 0; i < _n; i++) {
2259             if (_voting.yesVotes[_allUsers[i]] > 0) {
2260                 _for = _for.add(_voting.yesVotes[_allUsers[i]]);
2261             } else if (_voting.noVotes[_allUsers[i]] > 0) {
2262                 _against = _against.add(_voting.noVotes[_allUsers[i]]);
2263             }
2264         }
2265     }
2266 
2267     // get the list of voters who voted _vote (true-yes/false-no)
2268     function listVotes(Voting storage _voting, address[] _allUsers, bool _vote)
2269         external
2270         view
2271         returns (address[] memory _voters, uint256 _length)
2272     {
2273         uint256 _n = _allUsers.length;
2274         uint256 i;
2275         _length = 0;
2276         _voters = new address[](_n);
2277         if (_vote == true) {
2278             for (i = 0; i < _n; i++) {
2279                 if (_voting.yesVotes[_allUsers[i]] > 0) {
2280                     _voters[_length] = _allUsers[i];
2281                     _length++;
2282                 }
2283             }
2284         } else {
2285             for (i = 0; i < _n; i++) {
2286                 if (_voting.noVotes[_allUsers[i]] > 0) {
2287                     _voters[_length] = _allUsers[i];
2288                     _length++;
2289                 }
2290             }
2291         }
2292     }
2293 
2294     function readVote(Voting storage _voting, address _voter)
2295         public
2296         view
2297         returns (bool _vote, uint256 _weight)
2298     {
2299         if (_voting.yesVotes[_voter] > 0) {
2300             _weight = _voting.yesVotes[_voter];
2301             _vote = true;
2302         } else {
2303             _weight = _voting.noVotes[_voter]; // if _voter didnt vote at all, the weight will be 0 anyway
2304             _vote = false;
2305         }
2306     }
2307 
2308     function revealVote(
2309         Voting storage _voting,
2310         address _voter,
2311         bool _vote,
2312         uint256 _weight
2313     )
2314         public
2315     {
2316         if (_vote) {
2317             _voting.yesVotes[_voter] = _weight;
2318         } else {
2319             _voting.noVotes[_voter] = _weight;
2320         }
2321     }
2322 
2323     function readVersion(ProposalVersion storage _version)
2324         public
2325         view
2326         returns (
2327             bytes32 _doc,
2328             uint256 _created,
2329             uint256[] _milestoneFundings,
2330             uint256 _finalReward
2331         )
2332     {
2333         _doc = _version.docIpfsHash;
2334         _created = _version.created;
2335         _milestoneFundings = _version.milestoneFundings;
2336         _finalReward = _version.finalReward;
2337     }
2338 
2339     // read the funding for a particular milestone of a finalized proposal
2340     // if _milestoneId is the same as _milestoneCount, it returns the final reward
2341     function readProposalMilestone(Proposal storage _proposal, uint256 _milestoneIndex)
2342         public
2343         view
2344         returns (uint256 _funding)
2345     {
2346         bytes32 _finalVersion = _proposal.finalVersion;
2347         uint256 _milestoneCount = _proposal.proposalVersions[_finalVersion].milestoneFundings.length;
2348         require(_milestoneIndex <= _milestoneCount);
2349         require(_finalVersion != EMPTY_BYTES); // the proposal must have been finalized
2350 
2351         if (_milestoneIndex < _milestoneCount) {
2352             _funding = _proposal.proposalVersions[_finalVersion].milestoneFundings[_milestoneIndex];
2353         } else {
2354             _funding = _proposal.proposalVersions[_finalVersion].finalReward;
2355         }
2356     }
2357 
2358     function addProposalVersion(
2359         Proposal storage _proposal,
2360         bytes32 _newDoc,
2361         uint256[] _newMilestoneFundings,
2362         uint256 _finalReward
2363     )
2364         public
2365     {
2366         _proposal.proposalVersionDocs.append(_newDoc);
2367         _proposal.proposalVersions[_newDoc].docIpfsHash = _newDoc;
2368         _proposal.proposalVersions[_newDoc].created = now;
2369         _proposal.proposalVersions[_newDoc].milestoneCount = _newMilestoneFundings.length;
2370         _proposal.proposalVersions[_newDoc].milestoneFundings = _newMilestoneFundings;
2371         _proposal.proposalVersions[_newDoc].finalReward = _finalReward;
2372     }
2373 
2374     struct SpecialProposal {
2375         // ID of the special proposal
2376         // This is the IPFS doc hash of the proposal
2377         bytes32 proposalId;
2378 
2379         // UTC timestamp at which the proposal was created
2380         uint256 timeCreated;
2381 
2382         // Voting struct for the special proposal
2383         Voting voting;
2384 
2385         // List of the new uint256 configs as per the special proposal
2386         uint256[] uintConfigs;
2387 
2388         // List of the new address configs as per the special proposal
2389         address[] addressConfigs;
2390 
2391         // List of the new bytes32 configs as per the special proposal
2392         bytes32[] bytesConfigs;
2393 
2394         // Address of the user who created the special proposal
2395         // This address should also be in the ROLES_FOUNDERS group
2396         // refer "./../storage/DaoIdentityStorage.sol"
2397         address proposer;
2398     }
2399 
2400     // All configs are as per the DaoConfigsStorage values at the time when
2401     // calculateGlobalRewardsBeforeNewQuarter is called by founder in that quarter
2402     struct DaoQuarterInfo {
2403         // The minimum quarter points required
2404         // below this, reputation will be deducted
2405         uint256 minimalParticipationPoint;
2406 
2407         // The scaling factor for quarter point
2408         uint256 quarterPointScalingFactor;
2409 
2410         // The scaling factor for reputation point
2411         uint256 reputationPointScalingFactor;
2412 
2413         // The summation of effectiveDGDs in the previous quarter
2414         // The effectiveDGDs represents the effective participation in DigixDAO in a quarter
2415         // Which depends on lockedDGDStake, quarter point and reputation point
2416         // This value is the summation of all participant effectiveDGDs
2417         // It will be used to calculate the fraction of effectiveDGD a user has,
2418         // which will determine his portion of DGX rewards for that quarter
2419         uint256 totalEffectiveDGDPreviousQuarter;
2420 
2421         // The minimum moderator quarter point required
2422         // below this, reputation will be deducted for moderators
2423         uint256 moderatorMinimalParticipationPoint;
2424 
2425         // the scaling factor for moderator quarter point
2426         uint256 moderatorQuarterPointScalingFactor;
2427 
2428         // the scaling factor for moderator reputation point
2429         uint256 moderatorReputationPointScalingFactor;
2430 
2431         // The summation of effectiveDGDs (only specific to moderators)
2432         uint256 totalEffectiveModeratorDGDLastQuarter;
2433 
2434         // UTC timestamp from which the DGX rewards for the previous quarter are distributable to Holders
2435         uint256 dgxDistributionDay;
2436 
2437         // This is the rewards pool for the previous quarter. This is the sum of the DGX fees coming in from the collector, and the demurrage that has incurred
2438         // when user call claimRewards() in the previous quarter.
2439         // more graphical explanation: https://ipfs.io/ipfs/QmZDgFFMbyF3dvuuDfoXv5F6orq4kaDPo7m3QvnseUguzo
2440         uint256 dgxRewardsPoolLastQuarter;
2441 
2442         // The summation of all dgxRewardsPoolLastQuarter up until this quarter
2443         uint256 sumRewardsFromBeginning;
2444     }
2445 
2446     // There are many function calls where all calculations/summations cannot be done in one transaction
2447     // and require multiple transactions.
2448     // This struct stores the intermediate results in between the calculating transactions
2449     // These intermediate results are stored in IntermediateResultsStorage
2450     struct IntermediateResults {
2451         // weight of "FOR" votes counted up until the current calculation step
2452         uint256 currentForCount;
2453 
2454         // weight of "AGAINST" votes counted up until the current calculation step
2455         uint256 currentAgainstCount;
2456 
2457         // summation of effectiveDGDs up until the iteration of calculation
2458         uint256 currentSumOfEffectiveBalance;
2459 
2460         // Address of user until which the calculation has been done
2461         address countedUntil;
2462     }
2463 }
2464 
2465 contract DaoStorage is DaoWhitelistingCommon, BytesIteratorStorage {
2466     using DoublyLinkedList for DoublyLinkedList.Bytes;
2467     using DaoStructs for DaoStructs.Voting;
2468     using DaoStructs for DaoStructs.Proposal;
2469     using DaoStructs for DaoStructs.ProposalVersion;
2470 
2471     // List of all the proposals ever created in DigixDAO
2472     DoublyLinkedList.Bytes allProposals;
2473 
2474     // mapping of Proposal struct by its ID
2475     // ID is also the IPFS doc hash of the first ever version of this proposal
2476     mapping (bytes32 => DaoStructs.Proposal) proposalsById;
2477 
2478     // mapping from state of a proposal to list of all proposals in that state
2479     // proposals are added/removed from the state's list as their states change
2480     // eg. when proposal is endorsed, when proposal is funded, etc
2481     mapping (bytes32 => DoublyLinkedList.Bytes) proposalsByState;
2482 
2483     constructor(address _resolver) public {
2484         require(init(CONTRACT_STORAGE_DAO, _resolver));
2485     }
2486 
2487     /////////////////////////////// READ FUNCTIONS //////////////////////////////
2488 
2489     /// @notice read all information and details of proposal
2490     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc Proposal ID, i.e. hash of IPFS doc
2491     /// return {
2492     ///   "_doc": "Original IPFS doc of proposal, also ID of proposal",
2493     ///   "_proposer": "Address of the proposer",
2494     ///   "_endorser": "Address of the moderator that endorsed the proposal",
2495     ///   "_state": "Current state of the proposal",
2496     ///   "_timeCreated": "UTC timestamp at which proposal was created",
2497     ///   "_nVersions": "Number of versions of the proposal",
2498     ///   "_latestVersionDoc": "IPFS doc hash of the latest version of this proposal",
2499     ///   "_finalVersion": "If finalized, the version of the final proposal",
2500     ///   "_pausedOrStopped": "If the proposal is paused/stopped at the moment",
2501     ///   "_isDigixProposal": "If the proposal has been created by founder or not"
2502     /// }
2503     function readProposal(bytes32 _proposalId)
2504         public
2505         view
2506         returns (
2507             bytes32 _doc,
2508             address _proposer,
2509             address _endorser,
2510             bytes32 _state,
2511             uint256 _timeCreated,
2512             uint256 _nVersions,
2513             bytes32 _latestVersionDoc,
2514             bytes32 _finalVersion,
2515             bool _pausedOrStopped,
2516             bool _isDigixProposal
2517         )
2518     {
2519         require(senderIsAllowedToRead());
2520         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2521         _doc = _proposal.proposalId;
2522         _proposer = _proposal.proposer;
2523         _endorser = _proposal.endorser;
2524         _state = _proposal.currentState;
2525         _timeCreated = _proposal.timeCreated;
2526         _nVersions = read_total_bytesarray(_proposal.proposalVersionDocs);
2527         _latestVersionDoc = read_last_from_bytesarray(_proposal.proposalVersionDocs);
2528         _finalVersion = _proposal.finalVersion;
2529         _pausedOrStopped = _proposal.isPausedOrStopped;
2530         _isDigixProposal = _proposal.isDigix;
2531     }
2532 
2533     function readProposalProposer(bytes32 _proposalId)
2534         public
2535         view
2536         returns (address _proposer)
2537     {
2538         _proposer = proposalsById[_proposalId].proposer;
2539     }
2540 
2541     function readTotalPrlActions(bytes32 _proposalId)
2542         public
2543         view
2544         returns (uint256 _length)
2545     {
2546         _length = proposalsById[_proposalId].prlActions.length;
2547     }
2548 
2549     function readPrlAction(bytes32 _proposalId, uint256 _index)
2550         public
2551         view
2552         returns (uint256 _actionId, uint256 _time, bytes32 _doc)
2553     {
2554         DaoStructs.PrlAction[] memory _actions = proposalsById[_proposalId].prlActions;
2555         require(_index < _actions.length);
2556         _actionId = _actions[_index].actionId;
2557         _time = _actions[_index].at;
2558         _doc = _actions[_index].doc;
2559     }
2560 
2561     function readProposalDraftVotingResult(bytes32 _proposalId)
2562         public
2563         view
2564         returns (bool _result)
2565     {
2566         require(senderIsAllowedToRead());
2567         _result = proposalsById[_proposalId].draftVoting.passed;
2568     }
2569 
2570     function readProposalVotingResult(bytes32 _proposalId, uint256 _index)
2571         public
2572         view
2573         returns (bool _result)
2574     {
2575         require(senderIsAllowedToRead());
2576         _result = proposalsById[_proposalId].votingRounds[_index].passed;
2577     }
2578 
2579     function readProposalDraftVotingTime(bytes32 _proposalId)
2580         public
2581         view
2582         returns (uint256 _start)
2583     {
2584         require(senderIsAllowedToRead());
2585         _start = proposalsById[_proposalId].draftVoting.startTime;
2586     }
2587 
2588     function readProposalVotingTime(bytes32 _proposalId, uint256 _index)
2589         public
2590         view
2591         returns (uint256 _start)
2592     {
2593         require(senderIsAllowedToRead());
2594         _start = proposalsById[_proposalId].votingRounds[_index].startTime;
2595     }
2596 
2597     function readDraftVotingCount(bytes32 _proposalId, address[] _allUsers)
2598         external
2599         view
2600         returns (uint256 _for, uint256 _against)
2601     {
2602         require(senderIsAllowedToRead());
2603         return proposalsById[_proposalId].draftVoting.countVotes(_allUsers);
2604     }
2605 
2606     function readVotingCount(bytes32 _proposalId, uint256 _index, address[] _allUsers)
2607         external
2608         view
2609         returns (uint256 _for, uint256 _against)
2610     {
2611         require(senderIsAllowedToRead());
2612         return proposalsById[_proposalId].votingRounds[_index].countVotes(_allUsers);
2613     }
2614 
2615     function readVotingRoundVotes(bytes32 _proposalId, uint256 _index, address[] _allUsers, bool _vote)
2616         external
2617         view
2618         returns (address[] memory _voters, uint256 _length)
2619     {
2620         require(senderIsAllowedToRead());
2621         return proposalsById[_proposalId].votingRounds[_index].listVotes(_allUsers, _vote);
2622     }
2623 
2624     function readDraftVote(bytes32 _proposalId, address _voter)
2625         public
2626         view
2627         returns (bool _vote, uint256 _weight)
2628     {
2629         require(senderIsAllowedToRead());
2630         return proposalsById[_proposalId].draftVoting.readVote(_voter);
2631     }
2632 
2633     /// @notice returns the latest committed vote by a voter on a proposal
2634     /// @param _proposalId proposal ID
2635     /// @param _voter address of the voter
2636     /// @return {
2637     ///   "_commitHash": ""
2638     /// }
2639     function readComittedVote(bytes32 _proposalId, uint256 _index, address _voter)
2640         public
2641         view
2642         returns (bytes32 _commitHash)
2643     {
2644         require(senderIsAllowedToRead());
2645         _commitHash = proposalsById[_proposalId].votingRounds[_index].commits[_voter];
2646     }
2647 
2648     function readVote(bytes32 _proposalId, uint256 _index, address _voter)
2649         public
2650         view
2651         returns (bool _vote, uint256 _weight)
2652     {
2653         require(senderIsAllowedToRead());
2654         return proposalsById[_proposalId].votingRounds[_index].readVote(_voter);
2655     }
2656 
2657     /// @notice get all information and details of the first proposal
2658     /// return {
2659     ///   "_id": ""
2660     /// }
2661     function getFirstProposal()
2662         public
2663         view
2664         returns (bytes32 _id)
2665     {
2666         _id = read_first_from_bytesarray(allProposals);
2667     }
2668 
2669     /// @notice get all information and details of the last proposal
2670     /// return {
2671     ///   "_id": ""
2672     /// }
2673     function getLastProposal()
2674         public
2675         view
2676         returns (bytes32 _id)
2677     {
2678         _id = read_last_from_bytesarray(allProposals);
2679     }
2680 
2681     /// @notice get all information and details of proposal next to _proposalId
2682     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2683     /// return {
2684     ///   "_id": ""
2685     /// }
2686     function getNextProposal(bytes32 _proposalId)
2687         public
2688         view
2689         returns (bytes32 _id)
2690     {
2691         _id = read_next_from_bytesarray(
2692             allProposals,
2693             _proposalId
2694         );
2695     }
2696 
2697     /// @notice get all information and details of proposal previous to _proposalId
2698     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2699     /// return {
2700     ///   "_id": ""
2701     /// }
2702     function getPreviousProposal(bytes32 _proposalId)
2703         public
2704         view
2705         returns (bytes32 _id)
2706     {
2707         _id = read_previous_from_bytesarray(
2708             allProposals,
2709             _proposalId
2710         );
2711     }
2712 
2713     /// @notice get all information and details of the first proposal in state _stateId
2714     /// @param _stateId State ID of the proposal
2715     /// return {
2716     ///   "_id": ""
2717     /// }
2718     function getFirstProposalInState(bytes32 _stateId)
2719         public
2720         view
2721         returns (bytes32 _id)
2722     {
2723         require(senderIsAllowedToRead());
2724         _id = read_first_from_bytesarray(proposalsByState[_stateId]);
2725     }
2726 
2727     /// @notice get all information and details of the last proposal in state _stateId
2728     /// @param _stateId State ID of the proposal
2729     /// return {
2730     ///   "_id": ""
2731     /// }
2732     function getLastProposalInState(bytes32 _stateId)
2733         public
2734         view
2735         returns (bytes32 _id)
2736     {
2737         require(senderIsAllowedToRead());
2738         _id = read_last_from_bytesarray(proposalsByState[_stateId]);
2739     }
2740 
2741     /// @notice get all information and details of the next proposal to _proposalId in state _stateId
2742     /// @param _stateId State ID of the proposal
2743     /// return {
2744     ///   "_id": ""
2745     /// }
2746     function getNextProposalInState(bytes32 _stateId, bytes32 _proposalId)
2747         public
2748         view
2749         returns (bytes32 _id)
2750     {
2751         require(senderIsAllowedToRead());
2752         _id = read_next_from_bytesarray(
2753             proposalsByState[_stateId],
2754             _proposalId
2755         );
2756     }
2757 
2758     /// @notice get all information and details of the previous proposal to _proposalId in state _stateId
2759     /// @param _stateId State ID of the proposal
2760     /// return {
2761     ///   "_id": ""
2762     /// }
2763     function getPreviousProposalInState(bytes32 _stateId, bytes32 _proposalId)
2764         public
2765         view
2766         returns (bytes32 _id)
2767     {
2768         require(senderIsAllowedToRead());
2769         _id = read_previous_from_bytesarray(
2770             proposalsByState[_stateId],
2771             _proposalId
2772         );
2773     }
2774 
2775     /// @notice read proposal version details for a specific version
2776     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2777     /// @param _version Version of proposal, i.e. hash of IPFS doc for specific version
2778     /// return {
2779     ///   "_doc": "",
2780     ///   "_created": "",
2781     ///   "_milestoneFundings": ""
2782     /// }
2783     function readProposalVersion(bytes32 _proposalId, bytes32 _version)
2784         public
2785         view
2786         returns (
2787             bytes32 _doc,
2788             uint256 _created,
2789             uint256[] _milestoneFundings,
2790             uint256 _finalReward
2791         )
2792     {
2793         return proposalsById[_proposalId].proposalVersions[_version].readVersion();
2794     }
2795 
2796     /**
2797     @notice Read the fundings of a finalized proposal
2798     @return {
2799         "_fundings": "fundings for the milestones",
2800         "_finalReward": "the final reward"
2801     }
2802     */
2803     function readProposalFunding(bytes32 _proposalId)
2804         public
2805         view
2806         returns (uint256[] memory _fundings, uint256 _finalReward)
2807     {
2808         require(senderIsAllowedToRead());
2809         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
2810         require(_finalVersion != EMPTY_BYTES);
2811         _fundings = proposalsById[_proposalId].proposalVersions[_finalVersion].milestoneFundings;
2812         _finalReward = proposalsById[_proposalId].proposalVersions[_finalVersion].finalReward;
2813     }
2814 
2815     function readProposalMilestone(bytes32 _proposalId, uint256 _index)
2816         public
2817         view
2818         returns (uint256 _funding)
2819     {
2820         require(senderIsAllowedToRead());
2821         _funding = proposalsById[_proposalId].readProposalMilestone(_index);
2822     }
2823 
2824     /// @notice get proposal version details for the first version
2825     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2826     /// return {
2827     ///   "_version": ""
2828     /// }
2829     function getFirstProposalVersion(bytes32 _proposalId)
2830         public
2831         view
2832         returns (bytes32 _version)
2833     {
2834         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2835         _version = read_first_from_bytesarray(_proposal.proposalVersionDocs);
2836     }
2837 
2838     /// @notice get proposal version details for the last version
2839     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2840     /// return {
2841     ///   "_version": ""
2842     /// }
2843     function getLastProposalVersion(bytes32 _proposalId)
2844         public
2845         view
2846         returns (bytes32 _version)
2847     {
2848         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2849         _version = read_last_from_bytesarray(_proposal.proposalVersionDocs);
2850     }
2851 
2852     /// @notice get proposal version details for the next version to _version
2853     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2854     /// @param _version Version of proposal
2855     /// return {
2856     ///   "_nextVersion": ""
2857     /// }
2858     function getNextProposalVersion(bytes32 _proposalId, bytes32 _version)
2859         public
2860         view
2861         returns (bytes32 _nextVersion)
2862     {
2863         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2864         _nextVersion = read_next_from_bytesarray(
2865             _proposal.proposalVersionDocs,
2866             _version
2867         );
2868     }
2869 
2870     /// @notice get proposal version details for the previous version to _version
2871     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2872     /// @param _version Version of proposal
2873     /// return {
2874     ///   "_previousVersion": ""
2875     /// }
2876     function getPreviousProposalVersion(bytes32 _proposalId, bytes32 _version)
2877         public
2878         view
2879         returns (bytes32 _previousVersion)
2880     {
2881         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2882         _previousVersion = read_previous_from_bytesarray(
2883             _proposal.proposalVersionDocs,
2884             _version
2885         );
2886     }
2887 
2888     function isDraftClaimed(bytes32 _proposalId)
2889         public
2890         view
2891         returns (bool _claimed)
2892     {
2893         _claimed = proposalsById[_proposalId].draftVoting.claimed;
2894     }
2895 
2896     function isClaimed(bytes32 _proposalId, uint256 _index)
2897         public
2898         view
2899         returns (bool _claimed)
2900     {
2901         _claimed = proposalsById[_proposalId].votingRounds[_index].claimed;
2902     }
2903 
2904     function readProposalCollateralStatus(bytes32 _proposalId)
2905         public
2906         view
2907         returns (uint256 _status)
2908     {
2909         require(senderIsAllowedToRead());
2910         _status = proposalsById[_proposalId].collateralStatus;
2911     }
2912 
2913     function readProposalCollateralAmount(bytes32 _proposalId)
2914         public
2915         view
2916         returns (uint256 _amount)
2917     {
2918         _amount = proposalsById[_proposalId].collateralAmount;
2919     }
2920 
2921     /// @notice Read the additional docs that are added after the proposal is finalized
2922     /// @dev Will throw if the propsal is not finalized yet
2923     function readProposalDocs(bytes32 _proposalId)
2924         public
2925         view
2926         returns (bytes32[] _moreDocs)
2927     {
2928         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
2929         require(_finalVersion != EMPTY_BYTES);
2930         _moreDocs = proposalsById[_proposalId].proposalVersions[_finalVersion].moreDocs;
2931     }
2932 
2933     function readIfMilestoneFunded(bytes32 _proposalId, uint256 _milestoneId)
2934         public
2935         view
2936         returns (bool _funded)
2937     {
2938         require(senderIsAllowedToRead());
2939         _funded = proposalsById[_proposalId].votingRounds[_milestoneId].funded;
2940     }
2941 
2942     ////////////////////////////// WRITE FUNCTIONS //////////////////////////////
2943 
2944     function addProposal(
2945         bytes32 _doc,
2946         address _proposer,
2947         uint256[] _milestoneFundings,
2948         uint256 _finalReward,
2949         bool _isFounder
2950     )
2951         external
2952     {
2953         require(sender_is(CONTRACT_DAO));
2954         require(
2955           (proposalsById[_doc].proposalId == EMPTY_BYTES) &&
2956           (_doc != EMPTY_BYTES)
2957         );
2958 
2959         allProposals.append(_doc);
2960         proposalsByState[PROPOSAL_STATE_PREPROPOSAL].append(_doc);
2961         proposalsById[_doc].proposalId = _doc;
2962         proposalsById[_doc].proposer = _proposer;
2963         proposalsById[_doc].currentState = PROPOSAL_STATE_PREPROPOSAL;
2964         proposalsById[_doc].timeCreated = now;
2965         proposalsById[_doc].isDigix = _isFounder;
2966         proposalsById[_doc].addProposalVersion(_doc, _milestoneFundings, _finalReward);
2967     }
2968 
2969     function editProposal(
2970         bytes32 _proposalId,
2971         bytes32 _newDoc,
2972         uint256[] _newMilestoneFundings,
2973         uint256 _finalReward
2974     )
2975         external
2976     {
2977         require(sender_is(CONTRACT_DAO));
2978 
2979         proposalsById[_proposalId].addProposalVersion(_newDoc, _newMilestoneFundings, _finalReward);
2980     }
2981 
2982     /// @notice change fundings of a proposal
2983     /// @dev Will throw if the proposal is not finalized yet
2984     function changeFundings(bytes32 _proposalId, uint256[] _newMilestoneFundings, uint256 _finalReward)
2985         external
2986     {
2987         require(sender_is(CONTRACT_DAO));
2988 
2989         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
2990         require(_finalVersion != EMPTY_BYTES);
2991         proposalsById[_proposalId].proposalVersions[_finalVersion].milestoneFundings = _newMilestoneFundings;
2992         proposalsById[_proposalId].proposalVersions[_finalVersion].finalReward = _finalReward;
2993     }
2994 
2995     /// @dev Will throw if the proposal is not finalized yet
2996     function addProposalDoc(bytes32 _proposalId, bytes32 _newDoc)
2997         public
2998     {
2999         require(sender_is(CONTRACT_DAO));
3000 
3001         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
3002         require(_finalVersion != EMPTY_BYTES); //already checked in interactive layer, but why not
3003         proposalsById[_proposalId].proposalVersions[_finalVersion].moreDocs.push(_newDoc);
3004     }
3005 
3006     function finalizeProposal(bytes32 _proposalId)
3007         public
3008     {
3009         require(sender_is(CONTRACT_DAO));
3010 
3011         proposalsById[_proposalId].finalVersion = getLastProposalVersion(_proposalId);
3012     }
3013 
3014     function updateProposalEndorse(
3015         bytes32 _proposalId,
3016         address _endorser
3017     )
3018         public
3019     {
3020         require(sender_is(CONTRACT_DAO));
3021 
3022         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
3023         _proposal.endorser = _endorser;
3024         _proposal.currentState = PROPOSAL_STATE_DRAFT;
3025         proposalsByState[PROPOSAL_STATE_PREPROPOSAL].remove_item(_proposalId);
3026         proposalsByState[PROPOSAL_STATE_DRAFT].append(_proposalId);
3027     }
3028 
3029     function setProposalDraftPass(bytes32 _proposalId, bool _result)
3030         public
3031     {
3032         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3033 
3034         proposalsById[_proposalId].draftVoting.passed = _result;
3035         if (_result) {
3036             proposalsByState[PROPOSAL_STATE_DRAFT].remove_item(_proposalId);
3037             proposalsByState[PROPOSAL_STATE_MODERATED].append(_proposalId);
3038             proposalsById[_proposalId].currentState = PROPOSAL_STATE_MODERATED;
3039         } else {
3040             closeProposalInternal(_proposalId);
3041         }
3042     }
3043 
3044     function setProposalPass(bytes32 _proposalId, uint256 _index, bool _result)
3045         public
3046     {
3047         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3048 
3049         if (!_result) {
3050             closeProposalInternal(_proposalId);
3051         } else if (_index == 0) {
3052             proposalsByState[PROPOSAL_STATE_MODERATED].remove_item(_proposalId);
3053             proposalsByState[PROPOSAL_STATE_ONGOING].append(_proposalId);
3054             proposalsById[_proposalId].currentState = PROPOSAL_STATE_ONGOING;
3055         }
3056         proposalsById[_proposalId].votingRounds[_index].passed = _result;
3057     }
3058 
3059     function setProposalDraftVotingTime(
3060         bytes32 _proposalId,
3061         uint256 _time
3062     )
3063         public
3064     {
3065         require(sender_is(CONTRACT_DAO));
3066 
3067         proposalsById[_proposalId].draftVoting.startTime = _time;
3068     }
3069 
3070     function setProposalVotingTime(
3071         bytes32 _proposalId,
3072         uint256 _index,
3073         uint256 _time
3074     )
3075         public
3076     {
3077         require(sender_is_from([CONTRACT_DAO, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
3078 
3079         proposalsById[_proposalId].votingRounds[_index].startTime = _time;
3080     }
3081 
3082     function setDraftVotingClaim(bytes32 _proposalId, bool _claimed)
3083         public
3084     {
3085         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3086         proposalsById[_proposalId].draftVoting.claimed = _claimed;
3087     }
3088 
3089     function setVotingClaim(bytes32 _proposalId, uint256 _index, bool _claimed)
3090         public
3091     {
3092         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3093         proposalsById[_proposalId].votingRounds[_index].claimed = _claimed;
3094     }
3095 
3096     function setProposalCollateralStatus(bytes32 _proposalId, uint256 _status)
3097         public
3098     {
3099         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_FUNDING_MANAGER, CONTRACT_DAO]));
3100         proposalsById[_proposalId].collateralStatus = _status;
3101     }
3102 
3103     function setProposalCollateralAmount(bytes32 _proposalId, uint256 _amount)
3104         public
3105     {
3106         require(sender_is(CONTRACT_DAO));
3107         proposalsById[_proposalId].collateralAmount = _amount;
3108     }
3109 
3110     function updateProposalPRL(
3111         bytes32 _proposalId,
3112         uint256 _action,
3113         bytes32 _doc,
3114         uint256 _time
3115     )
3116         public
3117     {
3118         require(sender_is(CONTRACT_DAO));
3119         require(proposalsById[_proposalId].currentState != PROPOSAL_STATE_CLOSED);
3120 
3121         DaoStructs.PrlAction memory prlAction;
3122         prlAction.at = _time;
3123         prlAction.doc = _doc;
3124         prlAction.actionId = _action;
3125         proposalsById[_proposalId].prlActions.push(prlAction);
3126 
3127         if (_action == PRL_ACTION_PAUSE) {
3128           proposalsById[_proposalId].isPausedOrStopped = true;
3129         } else if (_action == PRL_ACTION_UNPAUSE) {
3130           proposalsById[_proposalId].isPausedOrStopped = false;
3131         } else { // STOP
3132           proposalsById[_proposalId].isPausedOrStopped = true;
3133           closeProposalInternal(_proposalId);
3134         }
3135     }
3136 
3137     function closeProposalInternal(bytes32 _proposalId)
3138         internal
3139     {
3140         bytes32 _currentState = proposalsById[_proposalId].currentState;
3141         proposalsByState[_currentState].remove_item(_proposalId);
3142         proposalsByState[PROPOSAL_STATE_CLOSED].append(_proposalId);
3143         proposalsById[_proposalId].currentState = PROPOSAL_STATE_CLOSED;
3144     }
3145 
3146     function addDraftVote(
3147         bytes32 _proposalId,
3148         address _voter,
3149         bool _vote,
3150         uint256 _weight
3151     )
3152         public
3153     {
3154         require(sender_is(CONTRACT_DAO_VOTING));
3155 
3156         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
3157         if (_vote) {
3158             _proposal.draftVoting.yesVotes[_voter] = _weight;
3159             if (_proposal.draftVoting.noVotes[_voter] > 0) { // minimize number of writes to storage, since EIP-1087 is not implemented yet
3160                 _proposal.draftVoting.noVotes[_voter] = 0;
3161             }
3162         } else {
3163             _proposal.draftVoting.noVotes[_voter] = _weight;
3164             if (_proposal.draftVoting.yesVotes[_voter] > 0) {
3165                 _proposal.draftVoting.yesVotes[_voter] = 0;
3166             }
3167         }
3168     }
3169 
3170     function commitVote(
3171         bytes32 _proposalId,
3172         bytes32 _hash,
3173         address _voter,
3174         uint256 _index
3175     )
3176         public
3177     {
3178         require(sender_is(CONTRACT_DAO_VOTING));
3179 
3180         proposalsById[_proposalId].votingRounds[_index].commits[_voter] = _hash;
3181     }
3182 
3183     function revealVote(
3184         bytes32 _proposalId,
3185         address _voter,
3186         bool _vote,
3187         uint256 _weight,
3188         uint256 _index
3189     )
3190         public
3191     {
3192         require(sender_is(CONTRACT_DAO_VOTING));
3193 
3194         proposalsById[_proposalId].votingRounds[_index].revealVote(_voter, _vote, _weight);
3195     }
3196 
3197     function closeProposal(bytes32 _proposalId)
3198         public
3199     {
3200         require(sender_is(CONTRACT_DAO));
3201         closeProposalInternal(_proposalId);
3202     }
3203 
3204     function archiveProposal(bytes32 _proposalId)
3205         public
3206     {
3207         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3208         bytes32 _currentState = proposalsById[_proposalId].currentState;
3209         proposalsByState[_currentState].remove_item(_proposalId);
3210         proposalsByState[PROPOSAL_STATE_ARCHIVED].append(_proposalId);
3211         proposalsById[_proposalId].currentState = PROPOSAL_STATE_ARCHIVED;
3212     }
3213 
3214     function setMilestoneFunded(bytes32 _proposalId, uint256 _milestoneId)
3215         public
3216     {
3217         require(sender_is(CONTRACT_DAO_FUNDING_MANAGER));
3218         proposalsById[_proposalId].votingRounds[_milestoneId].funded = true;
3219     }
3220 }
3221 
3222 /**
3223   @title Address Iterator Storage
3224   @author DigixGlobal Pte Ltd
3225   @notice See: [Doubly Linked List](/DoublyLinkedList)
3226 */
3227 contract AddressIteratorStorage {
3228 
3229   // Initialize Doubly Linked List of Address
3230   using DoublyLinkedList for DoublyLinkedList.Address;
3231 
3232   /**
3233     @notice Reads the first item from the list of Address
3234     @param _list The source list
3235     @return {"_item" : "The first item from the list"}
3236   */
3237   function read_first_from_addresses(DoublyLinkedList.Address storage _list)
3238            internal
3239            constant
3240            returns (address _item)
3241   {
3242     _item = _list.start_item();
3243   }
3244 
3245 
3246   /**
3247     @notice Reads the last item from the list of Address
3248     @param _list The source list
3249     @return {"_item" : "The last item from the list"}
3250   */
3251   function read_last_from_addresses(DoublyLinkedList.Address storage _list)
3252            internal
3253            constant
3254            returns (address _item)
3255   {
3256     _item = _list.end_item();
3257   }
3258 
3259   /**
3260     @notice Reads the next item on the list of Address
3261     @param _list The source list
3262     @param _current_item The current item to be used as base line
3263     @return {"_item" : "The next item from the list based on the specieid `_current_item`"}
3264   */
3265   function read_next_from_addresses(DoublyLinkedList.Address storage _list, address _current_item)
3266            internal
3267            constant
3268            returns (address _item)
3269   {
3270     _item = _list.next_item(_current_item);
3271   }
3272 
3273   /**
3274     @notice Reads the previous item on the list of Address
3275     @param _list The source list
3276     @param _current_item The current item to be used as base line
3277     @return {"_item" : "The previous item from the list based on the spcified `_current_item`"}
3278   */
3279   function read_previous_from_addresses(DoublyLinkedList.Address storage _list, address _current_item)
3280            internal
3281            constant
3282            returns (address _item)
3283   {
3284     _item = _list.previous_item(_current_item);
3285   }
3286 
3287   /**
3288     @notice Reads the list of Address and returns the length of the list
3289     @param _list The source list
3290     @return {"_count": "The lenght of the list"}
3291   */
3292   function read_total_addresses(DoublyLinkedList.Address storage _list)
3293            internal
3294            constant
3295            returns (uint256 _count)
3296   {
3297     _count = _list.total();
3298   }
3299 }
3300 
3301 contract DaoStakeStorage is ResolverClient, DaoConstants, AddressIteratorStorage {
3302     using DoublyLinkedList for DoublyLinkedList.Address;
3303 
3304     // This is the DGD stake of a user (one that is considered in the DAO)
3305     mapping (address => uint256) public lockedDGDStake;
3306 
3307     // This is the actual number of DGDs locked by user
3308     // may be more than the lockedDGDStake
3309     // in case they locked during the main phase
3310     mapping (address => uint256) public actualLockedDGD;
3311 
3312     // The total locked DGDs in the DAO (summation of lockedDGDStake)
3313     uint256 public totalLockedDGDStake;
3314 
3315     // The total locked DGDs by moderators
3316     uint256 public totalModeratorLockedDGDStake;
3317 
3318     // The list of participants in DAO
3319     // actual participants will be subset of this list
3320     DoublyLinkedList.Address allParticipants;
3321 
3322     // The list of moderators in DAO
3323     // actual moderators will be subset of this list
3324     DoublyLinkedList.Address allModerators;
3325 
3326     // Boolean to mark if an address has redeemed
3327     // reputation points for their DGD Badge
3328     mapping (address => bool) public redeemedBadge;
3329 
3330     // mapping to note whether an address has claimed their
3331     // reputation bonus for carbon vote participation
3332     mapping (address => bool) public carbonVoteBonusClaimed;
3333 
3334     constructor(address _resolver) public {
3335         require(init(CONTRACT_STORAGE_DAO_STAKE, _resolver));
3336     }
3337 
3338     function redeemBadge(address _user)
3339         public
3340     {
3341         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3342         redeemedBadge[_user] = true;
3343     }
3344 
3345     function setCarbonVoteBonusClaimed(address _user)
3346         public
3347     {
3348         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3349         carbonVoteBonusClaimed[_user] = true;
3350     }
3351 
3352     function updateTotalLockedDGDStake(uint256 _totalLockedDGDStake)
3353         public
3354     {
3355         require(sender_is_from([CONTRACT_DAO_STAKE_LOCKING, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
3356         totalLockedDGDStake = _totalLockedDGDStake;
3357     }
3358 
3359     function updateTotalModeratorLockedDGDs(uint256 _totalLockedDGDStake)
3360         public
3361     {
3362         require(sender_is_from([CONTRACT_DAO_STAKE_LOCKING, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
3363         totalModeratorLockedDGDStake = _totalLockedDGDStake;
3364     }
3365 
3366     function updateUserDGDStake(address _user, uint256 _actualLockedDGD, uint256 _lockedDGDStake)
3367         public
3368     {
3369         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3370         actualLockedDGD[_user] = _actualLockedDGD;
3371         lockedDGDStake[_user] = _lockedDGDStake;
3372     }
3373 
3374     function readUserDGDStake(address _user)
3375         public
3376         view
3377         returns (
3378             uint256 _actualLockedDGD,
3379             uint256 _lockedDGDStake
3380         )
3381     {
3382         _actualLockedDGD = actualLockedDGD[_user];
3383         _lockedDGDStake = lockedDGDStake[_user];
3384     }
3385 
3386     function addToParticipantList(address _user)
3387         public
3388         returns (bool _success)
3389     {
3390         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3391         _success = allParticipants.append(_user);
3392     }
3393 
3394     function removeFromParticipantList(address _user)
3395         public
3396         returns (bool _success)
3397     {
3398         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3399         _success = allParticipants.remove_item(_user);
3400     }
3401 
3402     function addToModeratorList(address _user)
3403         public
3404         returns (bool _success)
3405     {
3406         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3407         _success = allModerators.append(_user);
3408     }
3409 
3410     function removeFromModeratorList(address _user)
3411         public
3412         returns (bool _success)
3413     {
3414         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3415         _success = allModerators.remove_item(_user);
3416     }
3417 
3418     function isInParticipantList(address _user)
3419         public
3420         view
3421         returns (bool _is)
3422     {
3423         _is = allParticipants.find(_user) != 0;
3424     }
3425 
3426     function isInModeratorsList(address _user)
3427         public
3428         view
3429         returns (bool _is)
3430     {
3431         _is = allModerators.find(_user) != 0;
3432     }
3433 
3434     function readFirstModerator()
3435         public
3436         view
3437         returns (address _item)
3438     {
3439         _item = read_first_from_addresses(allModerators);
3440     }
3441 
3442     function readLastModerator()
3443         public
3444         view
3445         returns (address _item)
3446     {
3447         _item = read_last_from_addresses(allModerators);
3448     }
3449 
3450     function readNextModerator(address _current_item)
3451         public
3452         view
3453         returns (address _item)
3454     {
3455         _item = read_next_from_addresses(allModerators, _current_item);
3456     }
3457 
3458     function readPreviousModerator(address _current_item)
3459         public
3460         view
3461         returns (address _item)
3462     {
3463         _item = read_previous_from_addresses(allModerators, _current_item);
3464     }
3465 
3466     function readTotalModerators()
3467         public
3468         view
3469         returns (uint256 _total_count)
3470     {
3471         _total_count = read_total_addresses(allModerators);
3472     }
3473 
3474     function readFirstParticipant()
3475         public
3476         view
3477         returns (address _item)
3478     {
3479         _item = read_first_from_addresses(allParticipants);
3480     }
3481 
3482     function readLastParticipant()
3483         public
3484         view
3485         returns (address _item)
3486     {
3487         _item = read_last_from_addresses(allParticipants);
3488     }
3489 
3490     function readNextParticipant(address _current_item)
3491         public
3492         view
3493         returns (address _item)
3494     {
3495         _item = read_next_from_addresses(allParticipants, _current_item);
3496     }
3497 
3498     function readPreviousParticipant(address _current_item)
3499         public
3500         view
3501         returns (address _item)
3502     {
3503         _item = read_previous_from_addresses(allParticipants, _current_item);
3504     }
3505 
3506     function readTotalParticipant()
3507         public
3508         view
3509         returns (uint256 _total_count)
3510     {
3511         _total_count = read_total_addresses(allParticipants);
3512     }
3513 }
3514 
3515 /**
3516 @title Contract to list various storage states from DigixDAO
3517 @author Digix Holdings
3518 */
3519 contract DaoListingService is
3520     AddressIteratorInteractive,
3521     BytesIteratorInteractive,
3522     IndexedBytesIteratorInteractive,
3523     DaoWhitelistingCommon
3524 {
3525 
3526     /**
3527     @notice Constructor
3528     @param _resolver address of contract resolver
3529     */
3530     constructor(address _resolver) public {
3531         require(init(CONTRACT_SERVICE_DAO_LISTING, _resolver));
3532     }
3533 
3534     function daoStakeStorage()
3535         internal
3536         view
3537         returns (DaoStakeStorage _contract)
3538     {
3539         _contract = DaoStakeStorage(get_contract(CONTRACT_STORAGE_DAO_STAKE));
3540     }
3541 
3542     function daoStorage()
3543         internal
3544         view
3545         returns (DaoStorage _contract)
3546     {
3547         _contract = DaoStorage(get_contract(CONTRACT_STORAGE_DAO));
3548     }
3549 
3550     /**
3551     @notice function to list moderators
3552     @dev note that this list may include some additional entries that are
3553          not moderators in the current quarter. This may happen if they
3554          were moderators in the previous quarter, but have not confirmed
3555          their participation in the current quarter. For a single address,
3556          a better way to know if moderator or not is:
3557          Dao.isModerator(_user)
3558     @param _count number of addresses to list
3559     @param _from_start boolean, whether to list from start or end
3560     @return {
3561       "_moderators": "list of moderator addresses"
3562     }
3563     */
3564     function listModerators(uint256 _count, bool _from_start)
3565         public
3566         view
3567         returns (address[] _moderators)
3568     {
3569         _moderators = list_addresses(
3570             _count,
3571             daoStakeStorage().readFirstModerator,
3572             daoStakeStorage().readLastModerator,
3573             daoStakeStorage().readNextModerator,
3574             daoStakeStorage().readPreviousModerator,
3575             _from_start
3576         );
3577     }
3578 
3579     /**
3580     @notice function to list moderators from a particular moderator
3581     @dev note that this list may include some additional entries that are
3582          not moderators in the current quarter. This may happen if they
3583          were moderators in the previous quarter, but have not confirmed
3584          their participation in the current quarter. For a single address,
3585          a better way to know if moderator or not is:
3586          Dao.isModerator(_user)
3587 
3588          Another note: this function will start listing AFTER the _currentModerator
3589          For example: we have [address1, address2, address3, address4]. listModeratorsFrom(address1, 2, true) = [address2, address3]
3590     @param _currentModerator start the list after this moderator address
3591     @param _count number of addresses to list
3592     @param _from_start boolean, whether to list from start or end
3593     @return {
3594       "_moderators": "list of moderator addresses"
3595     }
3596     */
3597     function listModeratorsFrom(
3598         address _currentModerator,
3599         uint256 _count,
3600         bool _from_start
3601     )
3602         public
3603         view
3604         returns (address[] _moderators)
3605     {
3606         _moderators = list_addresses_from(
3607             _currentModerator,
3608             _count,
3609             daoStakeStorage().readFirstModerator,
3610             daoStakeStorage().readLastModerator,
3611             daoStakeStorage().readNextModerator,
3612             daoStakeStorage().readPreviousModerator,
3613             _from_start
3614         );
3615     }
3616 
3617     /**
3618     @notice function to list participants
3619     @dev note that this list may include some additional entries that are
3620          not participants in the current quarter. This may happen if they
3621          were participants in the previous quarter, but have not confirmed
3622          their participation in the current quarter. For a single address,
3623          a better way to know if participant or not is:
3624          Dao.isParticipant(_user)
3625     @param _count number of addresses to list
3626     @param _from_start boolean, whether to list from start or end
3627     @return {
3628       "_participants": "list of participant addresses"
3629     }
3630     */
3631     function listParticipants(uint256 _count, bool _from_start)
3632         public
3633         view
3634         returns (address[] _participants)
3635     {
3636         _participants = list_addresses(
3637             _count,
3638             daoStakeStorage().readFirstParticipant,
3639             daoStakeStorage().readLastParticipant,
3640             daoStakeStorage().readNextParticipant,
3641             daoStakeStorage().readPreviousParticipant,
3642             _from_start
3643         );
3644     }
3645 
3646     /**
3647     @notice function to list participants from a particular participant
3648     @dev note that this list may include some additional entries that are
3649          not participants in the current quarter. This may happen if they
3650          were participants in the previous quarter, but have not confirmed
3651          their participation in the current quarter. For a single address,
3652          a better way to know if participant or not is:
3653          contracts.dao.isParticipant(_user)
3654 
3655          Another note: this function will start listing AFTER the _currentParticipant
3656          For example: we have [address1, address2, address3, address4]. listParticipantsFrom(address1, 2, true) = [address2, address3]
3657     @param _currentParticipant list from AFTER this participant address
3658     @param _count number of addresses to list
3659     @param _from_start boolean, whether to list from start or end
3660     @return {
3661       "_participants": "list of participant addresses"
3662     }
3663     */
3664     function listParticipantsFrom(
3665         address _currentParticipant,
3666         uint256 _count,
3667         bool _from_start
3668     )
3669         public
3670         view
3671         returns (address[] _participants)
3672     {
3673         _participants = list_addresses_from(
3674             _currentParticipant,
3675             _count,
3676             daoStakeStorage().readFirstParticipant,
3677             daoStakeStorage().readLastParticipant,
3678             daoStakeStorage().readNextParticipant,
3679             daoStakeStorage().readPreviousParticipant,
3680             _from_start
3681         );
3682     }
3683 
3684     /**
3685     @notice function to list _count no. of proposals
3686     @param _count number of proposals to list
3687     @param _from_start boolean value, true if count from start, false if count from end
3688     @return {
3689       "_proposals": "the list of proposal IDs"
3690     }
3691     */
3692     function listProposals(
3693         uint256 _count,
3694         bool _from_start
3695     )
3696         public
3697         view
3698         returns (bytes32[] _proposals)
3699     {
3700         _proposals = list_bytesarray(
3701             _count,
3702             daoStorage().getFirstProposal,
3703             daoStorage().getLastProposal,
3704             daoStorage().getNextProposal,
3705             daoStorage().getPreviousProposal,
3706             _from_start
3707         );
3708     }
3709 
3710     /**
3711     @notice function to list _count no. of proposals from AFTER _currentProposal
3712     @param _currentProposal ID of proposal to list proposals from
3713     @param _count number of proposals to list
3714     @param _from_start boolean value, true if count forwards, false if count backwards
3715     @return {
3716       "_proposals": "the list of proposal IDs"
3717     }
3718     */
3719     function listProposalsFrom(
3720         bytes32 _currentProposal,
3721         uint256 _count,
3722         bool _from_start
3723     )
3724         public
3725         view
3726         returns (bytes32[] _proposals)
3727     {
3728         _proposals = list_bytesarray_from(
3729             _currentProposal,
3730             _count,
3731             daoStorage().getFirstProposal,
3732             daoStorage().getLastProposal,
3733             daoStorage().getNextProposal,
3734             daoStorage().getPreviousProposal,
3735             _from_start
3736         );
3737     }
3738 
3739     /**
3740     @notice function to list _count no. of proposals in state _stateId
3741     @param _stateId state of proposal
3742     @param _count number of proposals to list
3743     @param _from_start boolean value, true if count from start, false if count from end
3744     @return {
3745       "_proposals": "the list of proposal IDs"
3746     }
3747     */
3748     function listProposalsInState(
3749         bytes32 _stateId,
3750         uint256 _count,
3751         bool _from_start
3752     )
3753         public
3754         view
3755         returns (bytes32[] _proposals)
3756     {
3757         require(senderIsAllowedToRead());
3758         _proposals = list_indexed_bytesarray(
3759             _stateId,
3760             _count,
3761             daoStorage().getFirstProposalInState,
3762             daoStorage().getLastProposalInState,
3763             daoStorage().getNextProposalInState,
3764             daoStorage().getPreviousProposalInState,
3765             _from_start
3766         );
3767     }
3768 
3769     /**
3770     @notice function to list _count no. of proposals in state _stateId from AFTER _currentProposal
3771     @param _stateId state of proposal
3772     @param _currentProposal ID of proposal to list proposals from
3773     @param _count number of proposals to list
3774     @param _from_start boolean value, true if count forwards, false if count backwards
3775     @return {
3776       "_proposals": "the list of proposal IDs"
3777     }
3778     */
3779     function listProposalsInStateFrom(
3780         bytes32 _stateId,
3781         bytes32 _currentProposal,
3782         uint256 _count,
3783         bool _from_start
3784     )
3785         public
3786         view
3787         returns (bytes32[] _proposals)
3788     {
3789         require(senderIsAllowedToRead());
3790         _proposals = list_indexed_bytesarray_from(
3791             _stateId,
3792             _currentProposal,
3793             _count,
3794             daoStorage().getFirstProposalInState,
3795             daoStorage().getLastProposalInState,
3796             daoStorage().getNextProposalInState,
3797             daoStorage().getPreviousProposalInState,
3798             _from_start
3799         );
3800     }
3801 
3802     /**
3803     @notice function to list proposal versions
3804     @param _proposalId ID of the proposal
3805     @param _count number of proposal versions to list
3806     @param _from_start boolean, true to list from start, false to list from end
3807     @return {
3808       "_versions": "list of proposal versions"
3809     }
3810     */
3811     function listProposalVersions(
3812         bytes32 _proposalId,
3813         uint256 _count,
3814         bool _from_start
3815     )
3816         public
3817         view
3818         returns (bytes32[] _versions)
3819     {
3820         _versions = list_indexed_bytesarray(
3821             _proposalId,
3822             _count,
3823             daoStorage().getFirstProposalVersion,
3824             daoStorage().getLastProposalVersion,
3825             daoStorage().getNextProposalVersion,
3826             daoStorage().getPreviousProposalVersion,
3827             _from_start
3828         );
3829     }
3830 
3831     /**
3832     @notice function to list proposal versions from AFTER a particular version
3833     @param _proposalId ID of the proposal
3834     @param _currentVersion version to list _count versions from
3835     @param _count number of proposal versions to list
3836     @param _from_start boolean, true to list from start, false to list from end
3837     @return {
3838       "_versions": "list of proposal versions"
3839     }
3840     */
3841     function listProposalVersionsFrom(
3842         bytes32 _proposalId,
3843         bytes32 _currentVersion,
3844         uint256 _count,
3845         bool _from_start
3846     )
3847         public
3848         view
3849         returns (bytes32[] _versions)
3850     {
3851         _versions = list_indexed_bytesarray_from(
3852             _proposalId,
3853             _currentVersion,
3854             _count,
3855             daoStorage().getFirstProposalVersion,
3856             daoStorage().getLastProposalVersion,
3857             daoStorage().getNextProposalVersion,
3858             daoStorage().getPreviousProposalVersion,
3859             _from_start
3860         );
3861     }
3862 }
3863 
3864 /**
3865   @title Indexed Address IteratorStorage
3866   @author DigixGlobal Pte Ltd
3867   @notice This contract utilizes: [Doubly Linked List](/DoublyLinkedList)
3868 */
3869 contract IndexedAddressIteratorStorage {
3870 
3871   using DoublyLinkedList for DoublyLinkedList.IndexedAddress;
3872   /**
3873     @notice Reads the first item from an Indexed Address Doubly Linked List
3874     @param _list The source list
3875     @param _collection_index Index of the Collection to evaluate
3876     @return {"_item" : "First item on the list"}
3877   */
3878   function read_first_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
3879            internal
3880            constant
3881            returns (address _item)
3882   {
3883     _item = _list.start_item(_collection_index);
3884   }
3885 
3886   /**
3887     @notice Reads the last item from an Indexed Address Doubly Linked list
3888     @param _list The source list
3889     @param _collection_index Index of the Collection to evaluate
3890     @return {"_item" : "First item on the list"}
3891   */
3892   function read_last_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
3893            internal
3894            constant
3895            returns (address _item)
3896   {
3897     _item = _list.end_item(_collection_index);
3898   }
3899 
3900   /**
3901     @notice Reads the next item from an Indexed Address Doubly Linked List based on the specified `_current_item`
3902     @param _list The source list
3903     @param _collection_index Index of the Collection to evaluate
3904     @param _current_item The current item to use as base line
3905     @return {"_item": "The next item on the list"}
3906   */
3907   function read_next_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index, address _current_item)
3908            internal
3909            constant
3910            returns (address _item)
3911   {
3912     _item = _list.next_item(_collection_index, _current_item);
3913   }
3914 
3915   /**
3916     @notice Reads the previous item from an Index Address Doubly Linked List based on the specified `_current_item`
3917     @param _list The source list
3918     @param _collection_index Index of the Collection to evaluate
3919     @param _current_item The current item to use as base line
3920     @return {"_item" : "The previous item on the list"}
3921   */
3922   function read_previous_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index, address _current_item)
3923            internal
3924            constant
3925            returns (address _item)
3926   {
3927     _item = _list.previous_item(_collection_index, _current_item);
3928   }
3929 
3930 
3931   /**
3932     @notice Reads the total number of items in an Indexed Address Doubly Linked List
3933     @param _list  The source list
3934     @param _collection_index Index of the Collection to evaluate
3935     @return {"_count": "Length of the Doubly Linked list"}
3936   */
3937   function read_total_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
3938            internal
3939            constant
3940            returns (uint256 _count)
3941   {
3942     _count = _list.total(_collection_index);
3943   }
3944 }
3945 
3946 /**
3947   @title Uint Iterator Storage
3948   @author DigixGlobal Pte Ltd
3949 */
3950 contract UintIteratorStorage {
3951 
3952   using DoublyLinkedList for DoublyLinkedList.Uint;
3953 
3954   /**
3955     @notice Returns the first item from a `DoublyLinkedList.Uint` list
3956     @param _list The DoublyLinkedList.Uint list
3957     @return {"_item": "The first item"}
3958   */
3959   function read_first_from_uints(DoublyLinkedList.Uint storage _list)
3960            internal
3961            constant
3962            returns (uint256 _item)
3963   {
3964     _item = _list.start_item();
3965   }
3966 
3967   /**
3968     @notice Returns the last item from a `DoublyLinkedList.Uint` list
3969     @param _list The DoublyLinkedList.Uint list
3970     @return {"_item": "The last item"}
3971   */
3972   function read_last_from_uints(DoublyLinkedList.Uint storage _list)
3973            internal
3974            constant
3975            returns (uint256 _item)
3976   {
3977     _item = _list.end_item();
3978   }
3979 
3980   /**
3981     @notice Returns the next item from a `DoublyLinkedList.Uint` list based on the specified `_current_item`
3982     @param _list The DoublyLinkedList.Uint list
3983     @param _current_item The current item
3984     @return {"_item": "The next item"}
3985   */
3986   function read_next_from_uints(DoublyLinkedList.Uint storage _list, uint256 _current_item)
3987            internal
3988            constant
3989            returns (uint256 _item)
3990   {
3991     _item = _list.next_item(_current_item);
3992   }
3993 
3994   /**
3995     @notice Returns the previous item from a `DoublyLinkedList.Uint` list based on the specified `_current_item`
3996     @param _list The DoublyLinkedList.Uint list
3997     @param _current_item The current item
3998     @return {"_item": "The previous item"}
3999   */
4000   function read_previous_from_uints(DoublyLinkedList.Uint storage _list, uint256 _current_item)
4001            internal
4002            constant
4003            returns (uint256 _item)
4004   {
4005     _item = _list.previous_item(_current_item);
4006   }
4007 
4008   /**
4009     @notice Returns the total count of itemsfrom a `DoublyLinkedList.Uint` list
4010     @param _list The DoublyLinkedList.Uint list
4011     @return {"_count": "The total count of items"}
4012   */
4013   function read_total_uints(DoublyLinkedList.Uint storage _list)
4014            internal
4015            constant
4016            returns (uint256 _count)
4017   {
4018     _count = _list.total();
4019   }
4020 }
4021 
4022 /**
4023 @title Directory Storage contains information of a directory
4024 @author DigixGlobal
4025 */
4026 contract DirectoryStorage is IndexedAddressIteratorStorage, UintIteratorStorage {
4027 
4028   using DoublyLinkedList for DoublyLinkedList.IndexedAddress;
4029   using DoublyLinkedList for DoublyLinkedList.Uint;
4030 
4031   struct User {
4032     bytes32 document;
4033     bool active;
4034   }
4035 
4036   struct Group {
4037     bytes32 name;
4038     bytes32 document;
4039     uint256 role_id;
4040     mapping(address => User) members_by_address;
4041   }
4042 
4043   struct System {
4044     DoublyLinkedList.Uint groups;
4045     DoublyLinkedList.IndexedAddress groups_collection;
4046     mapping (uint256 => Group) groups_by_id;
4047     mapping (address => uint256) group_ids_by_address;
4048     mapping (uint256 => bytes32) roles_by_id;
4049     bool initialized;
4050     uint256 total_groups;
4051   }
4052 
4053   System system;
4054 
4055   /**
4056   @notice Initializes directory settings
4057   @return _success If directory initialization is successful
4058   */
4059   function initialize_directory()
4060            internal
4061            returns (bool _success)
4062   {
4063     require(system.initialized == false);
4064     system.total_groups = 0;
4065     system.initialized = true;
4066     internal_create_role(1, "root");
4067     internal_create_group(1, "root", "");
4068     _success = internal_update_add_user_to_group(1, tx.origin, "");
4069   }
4070 
4071   /**
4072   @notice Creates a new role with the given information
4073   @param _role_id Id of the new role
4074   @param _name Name of the new role
4075   @return {"_success": "If creation of new role is successful"}
4076   */
4077   function internal_create_role(uint256 _role_id, bytes32 _name)
4078            internal
4079            returns (bool _success)
4080   {
4081     require(_role_id > 0);
4082     require(_name != bytes32(0x0));
4083     system.roles_by_id[_role_id] = _name;
4084     _success = true;
4085   }
4086 
4087   /**
4088   @notice Returns the role's name of a role id
4089   @param _role_id Id of the role
4090   @return {"_name": "Name of the role"}
4091   */
4092   function read_role(uint256 _role_id)
4093            public
4094            constant
4095            returns (bytes32 _name)
4096   {
4097     _name = system.roles_by_id[_role_id];
4098   }
4099 
4100   /**
4101   @notice Creates a new group with the given information
4102   @param _role_id Role id of the new group
4103   @param _name Name of the new group
4104   @param _document Document of the new group
4105   @return {
4106     "_success": "If creation of the new group is successful",
4107     "_group_id: "Id of the new group"
4108   }
4109   */
4110   function internal_create_group(uint256 _role_id, bytes32 _name, bytes32 _document)
4111            internal
4112            returns (bool _success, uint256 _group_id)
4113   {
4114     require(_role_id > 0);
4115     require(read_role(_role_id) != bytes32(0x0));
4116     _group_id = ++system.total_groups;
4117     system.groups.append(_group_id);
4118     system.groups_by_id[_group_id].role_id = _role_id;
4119     system.groups_by_id[_group_id].name = _name;
4120     system.groups_by_id[_group_id].document = _document;
4121     _success = true;
4122   }
4123 
4124   /**
4125   @notice Returns the group's information
4126   @param _group_id Id of the group
4127   @return {
4128     "_role_id": "Role id of the group",
4129     "_name: "Name of the group",
4130     "_document: "Document of the group"
4131   }
4132   */
4133   function read_group(uint256 _group_id)
4134            public
4135            constant
4136            returns (uint256 _role_id, bytes32 _name, bytes32 _document, uint256 _members_count)
4137   {
4138     if (system.groups.valid_item(_group_id)) {
4139       _role_id = system.groups_by_id[_group_id].role_id;
4140       _name = system.groups_by_id[_group_id].name;
4141       _document = system.groups_by_id[_group_id].document;
4142       _members_count = read_total_indexed_addresses(system.groups_collection, bytes32(_group_id));
4143     } else {
4144       _role_id = 0;
4145       _name = "invalid";
4146       _document = "";
4147       _members_count = 0;
4148     }
4149   }
4150 
4151   /**
4152   @notice Adds new user with the given information to a group
4153   @param _group_id Id of the group
4154   @param _user Address of the new user
4155   @param _document Information of the new user
4156   @return {"_success": "If adding new user to a group is successful"}
4157   */
4158   function internal_update_add_user_to_group(uint256 _group_id, address _user, bytes32 _document)
4159            internal
4160            returns (bool _success)
4161   {
4162     if (system.groups_by_id[_group_id].members_by_address[_user].active == false && system.group_ids_by_address[_user] == 0 && system.groups_by_id[_group_id].role_id != 0) {
4163 
4164       system.groups_by_id[_group_id].members_by_address[_user].active = true;
4165       system.group_ids_by_address[_user] = _group_id;
4166       system.groups_collection.append(bytes32(_group_id), _user);
4167       system.groups_by_id[_group_id].members_by_address[_user].document = _document;
4168       _success = true;
4169     } else {
4170       _success = false;
4171     }
4172   }
4173 
4174   /**
4175   @notice Removes user from its group
4176   @param _user Address of the user
4177   @return {"_success": "If removing of user is successful"}
4178   */
4179   function internal_destroy_group_user(address _user)
4180            internal
4181            returns (bool _success)
4182   {
4183     uint256 _group_id = system.group_ids_by_address[_user];
4184     if ((_group_id == 1) && (system.groups_collection.total(bytes32(_group_id)) == 1)) {
4185       _success = false;
4186     } else {
4187       system.groups_by_id[_group_id].members_by_address[_user].active = false;
4188       system.group_ids_by_address[_user] = 0;
4189       delete system.groups_by_id[_group_id].members_by_address[_user];
4190       _success = system.groups_collection.remove_item(bytes32(_group_id), _user);
4191     }
4192   }
4193 
4194   /**
4195   @notice Returns the role id of a user
4196   @param _user Address of a user
4197   @return {"_role_id": "Role id of the user"}
4198   */
4199   function read_user_role_id(address _user)
4200            constant
4201            public
4202            returns (uint256 _role_id)
4203   {
4204     uint256 _group_id = system.group_ids_by_address[_user];
4205     _role_id = system.groups_by_id[_group_id].role_id;
4206   }
4207 
4208   /**
4209   @notice Returns the user's information
4210   @param _user Address of the user
4211   @return {
4212     "_group_id": "Group id of the user",
4213     "_role_id": "Role id of the user",
4214     "_document": "Information of the user"
4215   }
4216   */
4217   function read_user(address _user)
4218            public
4219            constant
4220            returns (uint256 _group_id, uint256 _role_id, bytes32 _document)
4221   {
4222     _group_id = system.group_ids_by_address[_user];
4223     _role_id = system.groups_by_id[_group_id].role_id;
4224     _document = system.groups_by_id[_group_id].members_by_address[_user].document;
4225   }
4226 
4227   /**
4228   @notice Returns the id of the first group
4229   @return {"_group_id": "Id of the first group"}
4230   */
4231   function read_first_group()
4232            view
4233            external
4234            returns (uint256 _group_id)
4235   {
4236     _group_id = read_first_from_uints(system.groups);
4237   }
4238 
4239   /**
4240   @notice Returns the id of the last group
4241   @return {"_group_id": "Id of the last group"}
4242   */
4243   function read_last_group()
4244            view
4245            external
4246            returns (uint256 _group_id)
4247   {
4248     _group_id = read_last_from_uints(system.groups);
4249   }
4250 
4251   /**
4252   @notice Returns the id of the previous group depending on the given current group
4253   @param _current_group_id Id of the current group
4254   @return {"_group_id": "Id of the previous group"}
4255   */
4256   function read_previous_group_from_group(uint256 _current_group_id)
4257            view
4258            external
4259            returns (uint256 _group_id)
4260   {
4261     _group_id = read_previous_from_uints(system.groups, _current_group_id);
4262   }
4263 
4264   /**
4265   @notice Returns the id of the next group depending on the given current group
4266   @param _current_group_id Id of the current group
4267   @return {"_group_id": "Id of the next group"}
4268   */
4269   function read_next_group_from_group(uint256 _current_group_id)
4270            view
4271            external
4272            returns (uint256 _group_id)
4273   {
4274     _group_id = read_next_from_uints(system.groups, _current_group_id);
4275   }
4276 
4277   /**
4278   @notice Returns the total number of groups
4279   @return {"_total_groups": "Total number of groups"}
4280   */
4281   function read_total_groups()
4282            view
4283            external
4284            returns (uint256 _total_groups)
4285   {
4286     _total_groups = read_total_uints(system.groups);
4287   }
4288 
4289   /**
4290   @notice Returns the first user of a group
4291   @param _group_id Id of the group
4292   @return {"_user": "Address of the user"}
4293   */
4294   function read_first_user_in_group(bytes32 _group_id)
4295            view
4296            external
4297            returns (address _user)
4298   {
4299     _user = read_first_from_indexed_addresses(system.groups_collection, bytes32(_group_id));
4300   }
4301 
4302   /**
4303   @notice Returns the last user of a group
4304   @param _group_id Id of the group
4305   @return {"_user": "Address of the user"}
4306   */
4307   function read_last_user_in_group(bytes32 _group_id)
4308            view
4309            external
4310            returns (address _user)
4311   {
4312     _user = read_last_from_indexed_addresses(system.groups_collection, bytes32(_group_id));
4313   }
4314 
4315   /**
4316   @notice Returns the next user of a group depending on the given current user
4317   @param _group_id Id of the group
4318   @param _current_user Address of the current user
4319   @return {"_user": "Address of the next user"}
4320   */
4321   function read_next_user_in_group(bytes32 _group_id, address _current_user)
4322            view
4323            external
4324            returns (address _user)
4325   {
4326     _user = read_next_from_indexed_addresses(system.groups_collection, bytes32(_group_id), _current_user);
4327   }
4328 
4329   /**
4330   @notice Returns the previous user of a group depending on the given current user
4331   @param _group_id Id of the group
4332   @param _current_user Address of the current user
4333   @return {"_user": "Address of the last user"}
4334   */
4335   function read_previous_user_in_group(bytes32 _group_id, address _current_user)
4336            view
4337            external
4338            returns (address _user)
4339   {
4340     _user = read_previous_from_indexed_addresses(system.groups_collection, bytes32(_group_id), _current_user);
4341   }
4342 
4343   /**
4344   @notice Returns the total number of users of a group
4345   @param _group_id Id of the group
4346   @return {"_total_users": "Total number of users"}
4347   */
4348   function read_total_users_in_group(bytes32 _group_id)
4349            view
4350            external
4351            returns (uint256 _total_users)
4352   {
4353     _total_users = read_total_indexed_addresses(system.groups_collection, bytes32(_group_id));
4354   }
4355 }
4356 
4357 contract DaoIdentityStorage is ResolverClient, DaoConstants, DirectoryStorage {
4358 
4359     // struct for KYC details
4360     // doc is the IPFS doc hash for any information regarding this KYC
4361     // id_expiration is the UTC timestamp at which this KYC will expire
4362     // at any time after this, the user's KYC is invalid, and that user
4363     // MUST re-KYC before doing any proposer related operation in DigixDAO
4364     struct KycDetails {
4365         bytes32 doc;
4366         uint256 id_expiration;
4367     }
4368 
4369     // a mapping of address to the KYC details
4370     mapping (address => KycDetails) kycInfo;
4371 
4372     constructor(address _resolver)
4373         public
4374     {
4375         require(init(CONTRACT_STORAGE_DAO_IDENTITY, _resolver));
4376         require(initialize_directory());
4377     }
4378 
4379     function create_group(uint256 _role_id, bytes32 _name, bytes32 _document)
4380         public
4381         returns (bool _success, uint256 _group_id)
4382     {
4383         require(sender_is(CONTRACT_DAO_IDENTITY));
4384         (_success, _group_id) = internal_create_group(_role_id, _name, _document);
4385         require(_success);
4386     }
4387 
4388     function create_role(uint256 _role_id, bytes32 _name)
4389         public
4390         returns (bool _success)
4391     {
4392         require(sender_is(CONTRACT_DAO_IDENTITY));
4393         _success = internal_create_role(_role_id, _name);
4394         require(_success);
4395     }
4396 
4397     function update_add_user_to_group(uint256 _group_id, address _user, bytes32 _document)
4398         public
4399         returns (bool _success)
4400     {
4401         require(sender_is(CONTRACT_DAO_IDENTITY));
4402         _success = internal_update_add_user_to_group(_group_id, _user, _document);
4403         require(_success);
4404     }
4405 
4406     function update_remove_group_user(address _user)
4407         public
4408         returns (bool _success)
4409     {
4410         require(sender_is(CONTRACT_DAO_IDENTITY));
4411         _success = internal_destroy_group_user(_user);
4412         require(_success);
4413     }
4414 
4415     function update_kyc(address _user, bytes32 _doc, uint256 _id_expiration)
4416         public
4417     {
4418         require(sender_is(CONTRACT_DAO_IDENTITY));
4419         kycInfo[_user].doc = _doc;
4420         kycInfo[_user].id_expiration = _id_expiration;
4421     }
4422 
4423     function read_kyc_info(address _user)
4424         public
4425         view
4426         returns (bytes32 _doc, uint256 _id_expiration)
4427     {
4428         _doc = kycInfo[_user].doc;
4429         _id_expiration = kycInfo[_user].id_expiration;
4430     }
4431 
4432     function is_kyc_approved(address _user)
4433         public
4434         view
4435         returns (bool _approved)
4436     {
4437         uint256 _id_expiration;
4438         (,_id_expiration) = read_kyc_info(_user);
4439         _approved = _id_expiration > now;
4440     }
4441 }
4442 
4443 contract IdentityCommon is DaoWhitelistingCommon {
4444 
4445     modifier if_root() {
4446         require(identity_storage().read_user_role_id(msg.sender) == ROLES_ROOT);
4447         _;
4448     }
4449 
4450     modifier if_founder() {
4451         require(is_founder());
4452         _;
4453     }
4454 
4455     function is_founder()
4456         internal
4457         view
4458         returns (bool _isFounder)
4459     {
4460         _isFounder = identity_storage().read_user_role_id(msg.sender) == ROLES_FOUNDERS;
4461     }
4462 
4463     modifier if_prl() {
4464         require(identity_storage().read_user_role_id(msg.sender) == ROLES_PRLS);
4465         _;
4466     }
4467 
4468     modifier if_kyc_admin() {
4469         require(identity_storage().read_user_role_id(msg.sender) == ROLES_KYC_ADMINS);
4470         _;
4471     }
4472 
4473     function identity_storage()
4474         internal
4475         view
4476         returns (DaoIdentityStorage _contract)
4477     {
4478         _contract = DaoIdentityStorage(get_contract(CONTRACT_STORAGE_DAO_IDENTITY));
4479     }
4480 }
4481 
4482 contract DaoConfigsStorage is ResolverClient, DaoConstants {
4483 
4484     // mapping of config name to config value
4485     // config names can be found in DaoConstants contract
4486     mapping (bytes32 => uint256) public uintConfigs;
4487 
4488     // mapping of config name to config value
4489     // config names can be found in DaoConstants contract
4490     mapping (bytes32 => address) public addressConfigs;
4491 
4492     // mapping of config name to config value
4493     // config names can be found in DaoConstants contract
4494     mapping (bytes32 => bytes32) public bytesConfigs;
4495 
4496     uint256 ONE_BILLION = 1000000000;
4497     uint256 ONE_MILLION = 1000000;
4498 
4499     constructor(address _resolver)
4500         public
4501     {
4502         require(init(CONTRACT_STORAGE_DAO_CONFIG, _resolver));
4503 
4504         uintConfigs[CONFIG_LOCKING_PHASE_DURATION] = 10 days;
4505         uintConfigs[CONFIG_QUARTER_DURATION] = QUARTER_DURATION;
4506         uintConfigs[CONFIG_VOTING_COMMIT_PHASE] = 14 days;
4507         uintConfigs[CONFIG_VOTING_PHASE_TOTAL] = 21 days;
4508         uintConfigs[CONFIG_INTERIM_COMMIT_PHASE] = 7 days;
4509         uintConfigs[CONFIG_INTERIM_PHASE_TOTAL] = 14 days;
4510 
4511 
4512 
4513         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR] = 5; // 5%
4514         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR] = 100; // 5%
4515         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR] = 35; // 35%
4516         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR] = 100; // 35%
4517 
4518 
4519         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR] = 5; // 5%
4520         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR] = 100; // 5%
4521         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR] = 25; // 25%
4522         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR] = 100; // 25%
4523 
4524         uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR] = 1; // >50%
4525         uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR] = 2; // >50%
4526         uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR] = 1; // >50%
4527         uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR] = 2; // >50%
4528 
4529 
4530         uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE] = ONE_BILLION;
4531         uintConfigs[CONFIG_QUARTER_POINT_VOTE] = ONE_BILLION;
4532         uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE] = ONE_BILLION;
4533 
4534         uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH] = 20000 * ONE_BILLION;
4535 
4536         uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR] = 15; // 15% bonus for consistent votes
4537         uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR] = 100; // 15% bonus for consistent votes
4538 
4539         uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE] = 28 days;
4540         uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL] = 35 days;
4541 
4542 
4543 
4544         uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR] = 1; // >50%
4545         uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR] = 2; // >50%
4546 
4547         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR] = 40; // 40%
4548         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR] = 100; // 40%
4549 
4550         uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION] = 8334 * ONE_MILLION;
4551 
4552         uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING] = 1666 * ONE_MILLION;
4553         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM] = 1; // 1 extra QP gains 1/1 RP
4554         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN] = 1;
4555 
4556 
4557         uintConfigs[CONFIG_MINIMAL_QUARTER_POINT] = 2 * ONE_BILLION;
4558         uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR] = 400 * ONE_BILLION;
4559         uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR] = 2000 * ONE_BILLION;
4560 
4561         uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT] = 4 * ONE_BILLION;
4562         uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR] = 400 * ONE_BILLION;
4563         uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR] = 2000 * ONE_BILLION;
4564 
4565         uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM] = 42; //4.2% of DGX to moderator voting activity
4566         uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN] = 1000;
4567 
4568         uintConfigs[CONFIG_DRAFT_VOTING_PHASE] = 7 days;
4569 
4570         uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE] = 412500 * ONE_MILLION;
4571 
4572         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR] = 7; // 7%
4573         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR] = 100; // 7%
4574 
4575         uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION] = 12500 * ONE_MILLION;
4576         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM] = 1;
4577         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN] = 1;
4578 
4579         uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE] = 10 days;
4580 
4581         uintConfigs[CONFIG_MINIMUM_LOCKED_DGD] = 10 * ONE_BILLION;
4582         uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR] = 842 * ONE_BILLION;
4583         uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR] = 400 * ONE_BILLION;
4584 
4585         uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL] = 2 ether;
4586 
4587         uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX] = 100 ether;
4588         uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX] = 5;
4589         uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER] = 80;
4590 
4591         uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION] = 90 days;
4592         uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS] = 10 * ONE_BILLION;
4593     }
4594 
4595     function updateUintConfigs(uint256[] _uintConfigs)
4596         external
4597     {
4598         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
4599         uintConfigs[CONFIG_LOCKING_PHASE_DURATION] = _uintConfigs[0];
4600         /*
4601         This used to be a config that can be changed. Now, _uintConfigs[1] is just a dummy config that doesnt do anything
4602         uintConfigs[CONFIG_QUARTER_DURATION] = _uintConfigs[1];
4603         */
4604         uintConfigs[CONFIG_VOTING_COMMIT_PHASE] = _uintConfigs[2];
4605         uintConfigs[CONFIG_VOTING_PHASE_TOTAL] = _uintConfigs[3];
4606         uintConfigs[CONFIG_INTERIM_COMMIT_PHASE] = _uintConfigs[4];
4607         uintConfigs[CONFIG_INTERIM_PHASE_TOTAL] = _uintConfigs[5];
4608         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR] = _uintConfigs[6];
4609         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR] = _uintConfigs[7];
4610         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR] = _uintConfigs[8];
4611         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[9];
4612         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR] = _uintConfigs[10];
4613         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR] = _uintConfigs[11];
4614         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR] = _uintConfigs[12];
4615         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[13];
4616         uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR] = _uintConfigs[14];
4617         uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR] = _uintConfigs[15];
4618         uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR] = _uintConfigs[16];
4619         uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR] = _uintConfigs[17];
4620         uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE] = _uintConfigs[18];
4621         uintConfigs[CONFIG_QUARTER_POINT_VOTE] = _uintConfigs[19];
4622         uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE] = _uintConfigs[20];
4623         uintConfigs[CONFIG_MINIMAL_QUARTER_POINT] = _uintConfigs[21];
4624         uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH] = _uintConfigs[22];
4625         uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR] = _uintConfigs[23];
4626         uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR] = _uintConfigs[24];
4627         uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE] = _uintConfigs[25];
4628         uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL] = _uintConfigs[26];
4629         uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR] = _uintConfigs[27];
4630         uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR] = _uintConfigs[28];
4631         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR] = _uintConfigs[29];
4632         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR] = _uintConfigs[30];
4633         uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION] = _uintConfigs[31];
4634         uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING] = _uintConfigs[32];
4635         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM] = _uintConfigs[33];
4636         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN] = _uintConfigs[34];
4637         uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR] = _uintConfigs[35];
4638         uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR] = _uintConfigs[36];
4639         uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT] = _uintConfigs[37];
4640         uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR] = _uintConfigs[38];
4641         uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR] = _uintConfigs[39];
4642         uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM] = _uintConfigs[40];
4643         uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN] = _uintConfigs[41];
4644         uintConfigs[CONFIG_DRAFT_VOTING_PHASE] = _uintConfigs[42];
4645         uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE] = _uintConfigs[43];
4646         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR] = _uintConfigs[44];
4647         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[45];
4648         uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION] = _uintConfigs[46];
4649         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM] = _uintConfigs[47];
4650         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN] = _uintConfigs[48];
4651         uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE] = _uintConfigs[49];
4652         uintConfigs[CONFIG_MINIMUM_LOCKED_DGD] = _uintConfigs[50];
4653         uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR] = _uintConfigs[51];
4654         uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR] = _uintConfigs[52];
4655         uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL] = _uintConfigs[53];
4656         uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX] = _uintConfigs[54];
4657         uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX] = _uintConfigs[55];
4658         uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER] = _uintConfigs[56];
4659         uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION] = _uintConfigs[57];
4660         uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS] = _uintConfigs[58];
4661     }
4662 
4663     function readUintConfigs()
4664         public
4665         view
4666         returns (uint256[])
4667     {
4668         uint256[] memory _uintConfigs = new uint256[](59);
4669         _uintConfigs[0] = uintConfigs[CONFIG_LOCKING_PHASE_DURATION];
4670         _uintConfigs[1] = uintConfigs[CONFIG_QUARTER_DURATION];
4671         _uintConfigs[2] = uintConfigs[CONFIG_VOTING_COMMIT_PHASE];
4672         _uintConfigs[3] = uintConfigs[CONFIG_VOTING_PHASE_TOTAL];
4673         _uintConfigs[4] = uintConfigs[CONFIG_INTERIM_COMMIT_PHASE];
4674         _uintConfigs[5] = uintConfigs[CONFIG_INTERIM_PHASE_TOTAL];
4675         _uintConfigs[6] = uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR];
4676         _uintConfigs[7] = uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR];
4677         _uintConfigs[8] = uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR];
4678         _uintConfigs[9] = uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR];
4679         _uintConfigs[10] = uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR];
4680         _uintConfigs[11] = uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR];
4681         _uintConfigs[12] = uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR];
4682         _uintConfigs[13] = uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR];
4683         _uintConfigs[14] = uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR];
4684         _uintConfigs[15] = uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR];
4685         _uintConfigs[16] = uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR];
4686         _uintConfigs[17] = uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR];
4687         _uintConfigs[18] = uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE];
4688         _uintConfigs[19] = uintConfigs[CONFIG_QUARTER_POINT_VOTE];
4689         _uintConfigs[20] = uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE];
4690         _uintConfigs[21] = uintConfigs[CONFIG_MINIMAL_QUARTER_POINT];
4691         _uintConfigs[22] = uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH];
4692         _uintConfigs[23] = uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR];
4693         _uintConfigs[24] = uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR];
4694         _uintConfigs[25] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE];
4695         _uintConfigs[26] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL];
4696         _uintConfigs[27] = uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR];
4697         _uintConfigs[28] = uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR];
4698         _uintConfigs[29] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR];
4699         _uintConfigs[30] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR];
4700         _uintConfigs[31] = uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION];
4701         _uintConfigs[32] = uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING];
4702         _uintConfigs[33] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM];
4703         _uintConfigs[34] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN];
4704         _uintConfigs[35] = uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR];
4705         _uintConfigs[36] = uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR];
4706         _uintConfigs[37] = uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT];
4707         _uintConfigs[38] = uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR];
4708         _uintConfigs[39] = uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR];
4709         _uintConfigs[40] = uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM];
4710         _uintConfigs[41] = uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN];
4711         _uintConfigs[42] = uintConfigs[CONFIG_DRAFT_VOTING_PHASE];
4712         _uintConfigs[43] = uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE];
4713         _uintConfigs[44] = uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR];
4714         _uintConfigs[45] = uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR];
4715         _uintConfigs[46] = uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION];
4716         _uintConfigs[47] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM];
4717         _uintConfigs[48] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN];
4718         _uintConfigs[49] = uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE];
4719         _uintConfigs[50] = uintConfigs[CONFIG_MINIMUM_LOCKED_DGD];
4720         _uintConfigs[51] = uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR];
4721         _uintConfigs[52] = uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR];
4722         _uintConfigs[53] = uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL];
4723         _uintConfigs[54] = uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX];
4724         _uintConfigs[55] = uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX];
4725         _uintConfigs[56] = uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER];
4726         _uintConfigs[57] = uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION];
4727         _uintConfigs[58] = uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS];
4728         return _uintConfigs;
4729     }
4730 }
4731 
4732 contract DaoProposalCounterStorage is ResolverClient, DaoConstants {
4733 
4734     constructor(address _resolver) public {
4735         require(init(CONTRACT_STORAGE_DAO_COUNTER, _resolver));
4736     }
4737 
4738     // This is to mark the number of proposals that have been funded in a specific quarter
4739     // this is to take care of the cap on the number of funded proposals in a quarter
4740     mapping (uint256 => uint256) public proposalCountByQuarter;
4741 
4742     function addNonDigixProposalCountInQuarter(uint256 _quarterNumber)
4743         public
4744     {
4745         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
4746         proposalCountByQuarter[_quarterNumber] = proposalCountByQuarter[_quarterNumber].add(1);
4747     }
4748 }
4749 
4750 contract DaoUpgradeStorage is ResolverClient, DaoConstants {
4751 
4752     // this UTC timestamp marks the start of the first quarter
4753     // of DigixDAO. All time related calculations in DaoCommon
4754     // depend on this value
4755     uint256 public startOfFirstQuarter;
4756 
4757     // this boolean marks whether the DAO contracts have been replaced
4758     // by newer versions or not. The process of migration is done by deploying
4759     // a new set of contracts, transferring funds from these contracts to the new ones
4760     // migrating some state variables, and finally setting this boolean to true
4761     // All operations in these contracts that may transfer tokens, claim ether,
4762     // boost one's reputation, etc. SHOULD fail if this is true
4763     bool public isReplacedByNewDao;
4764 
4765     // this is the address of the new Dao contract
4766     address public newDaoContract;
4767 
4768     // this is the address of the new DaoFundingManager contract
4769     // ether funds will be moved from the current version's contract to this
4770     // new contract
4771     address public newDaoFundingManager;
4772 
4773     // this is the address of the new DaoRewardsManager contract
4774     // DGX funds will be moved from the current version of contract to this
4775     // new contract
4776     address public newDaoRewardsManager;
4777 
4778     constructor(address _resolver) public {
4779         require(init(CONTRACT_STORAGE_DAO_UPGRADE, _resolver));
4780     }
4781 
4782     function setStartOfFirstQuarter(uint256 _start)
4783         public
4784     {
4785         require(sender_is(CONTRACT_DAO));
4786         startOfFirstQuarter = _start;
4787     }
4788 
4789 
4790     function setNewContractAddresses(
4791         address _newDaoContract,
4792         address _newDaoFundingManager,
4793         address _newDaoRewardsManager
4794     )
4795         public
4796     {
4797         require(sender_is(CONTRACT_DAO));
4798         newDaoContract = _newDaoContract;
4799         newDaoFundingManager = _newDaoFundingManager;
4800         newDaoRewardsManager = _newDaoRewardsManager;
4801     }
4802 
4803 
4804     function updateForDaoMigration()
4805         public
4806     {
4807         require(sender_is(CONTRACT_DAO));
4808         isReplacedByNewDao = true;
4809     }
4810 }
4811 
4812 contract DaoSpecialStorage is DaoWhitelistingCommon {
4813     using DoublyLinkedList for DoublyLinkedList.Bytes;
4814     using DaoStructs for DaoStructs.SpecialProposal;
4815     using DaoStructs for DaoStructs.Voting;
4816 
4817     // List of all the special proposals ever created in DigixDAO
4818     DoublyLinkedList.Bytes proposals;
4819 
4820     // mapping of the SpecialProposal struct by its ID
4821     // ID is also the IPFS doc hash of the proposal
4822     mapping (bytes32 => DaoStructs.SpecialProposal) proposalsById;
4823 
4824     constructor(address _resolver) public {
4825         require(init(CONTRACT_STORAGE_DAO_SPECIAL, _resolver));
4826     }
4827 
4828     function addSpecialProposal(
4829         bytes32 _proposalId,
4830         address _proposer,
4831         uint256[] _uintConfigs,
4832         address[] _addressConfigs,
4833         bytes32[] _bytesConfigs
4834     )
4835         public
4836     {
4837         require(sender_is(CONTRACT_DAO_SPECIAL_PROPOSAL));
4838         require(
4839           (proposalsById[_proposalId].proposalId == EMPTY_BYTES) &&
4840           (_proposalId != EMPTY_BYTES)
4841         );
4842         proposals.append(_proposalId);
4843         proposalsById[_proposalId].proposalId = _proposalId;
4844         proposalsById[_proposalId].proposer = _proposer;
4845         proposalsById[_proposalId].timeCreated = now;
4846         proposalsById[_proposalId].uintConfigs = _uintConfigs;
4847         proposalsById[_proposalId].addressConfigs = _addressConfigs;
4848         proposalsById[_proposalId].bytesConfigs = _bytesConfigs;
4849     }
4850 
4851     function readProposal(bytes32 _proposalId)
4852         public
4853         view
4854         returns (
4855             bytes32 _id,
4856             address _proposer,
4857             uint256 _timeCreated,
4858             uint256 _timeVotingStarted
4859         )
4860     {
4861         _id = proposalsById[_proposalId].proposalId;
4862         _proposer = proposalsById[_proposalId].proposer;
4863         _timeCreated = proposalsById[_proposalId].timeCreated;
4864         _timeVotingStarted = proposalsById[_proposalId].voting.startTime;
4865     }
4866 
4867     function readProposalProposer(bytes32 _proposalId)
4868         public
4869         view
4870         returns (address _proposer)
4871     {
4872         _proposer = proposalsById[_proposalId].proposer;
4873     }
4874 
4875     function readConfigs(bytes32 _proposalId)
4876         public
4877         view
4878         returns (
4879             uint256[] memory _uintConfigs,
4880             address[] memory _addressConfigs,
4881             bytes32[] memory _bytesConfigs
4882         )
4883     {
4884         _uintConfigs = proposalsById[_proposalId].uintConfigs;
4885         _addressConfigs = proposalsById[_proposalId].addressConfigs;
4886         _bytesConfigs = proposalsById[_proposalId].bytesConfigs;
4887     }
4888 
4889     function readVotingCount(bytes32 _proposalId, address[] _allUsers)
4890         external
4891         view
4892         returns (uint256 _for, uint256 _against)
4893     {
4894         require(senderIsAllowedToRead());
4895         return proposalsById[_proposalId].voting.countVotes(_allUsers);
4896     }
4897 
4898     function readVotingTime(bytes32 _proposalId)
4899         public
4900         view
4901         returns (uint256 _start)
4902     {
4903         require(senderIsAllowedToRead());
4904         _start = proposalsById[_proposalId].voting.startTime;
4905     }
4906 
4907     function commitVote(
4908         bytes32 _proposalId,
4909         bytes32 _hash,
4910         address _voter
4911     )
4912         public
4913     {
4914         require(sender_is(CONTRACT_DAO_VOTING));
4915         proposalsById[_proposalId].voting.commits[_voter] = _hash;
4916     }
4917 
4918     function readComittedVote(bytes32 _proposalId, address _voter)
4919         public
4920         view
4921         returns (bytes32 _commitHash)
4922     {
4923         require(senderIsAllowedToRead());
4924         _commitHash = proposalsById[_proposalId].voting.commits[_voter];
4925     }
4926 
4927     function setVotingTime(bytes32 _proposalId, uint256 _time)
4928         public
4929     {
4930         require(sender_is(CONTRACT_DAO_SPECIAL_PROPOSAL));
4931         proposalsById[_proposalId].voting.startTime = _time;
4932     }
4933 
4934     function readVotingResult(bytes32 _proposalId)
4935         public
4936         view
4937         returns (bool _result)
4938     {
4939         require(senderIsAllowedToRead());
4940         _result = proposalsById[_proposalId].voting.passed;
4941     }
4942 
4943     function setPass(bytes32 _proposalId, bool _result)
4944         public
4945     {
4946         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
4947         proposalsById[_proposalId].voting.passed = _result;
4948     }
4949 
4950     function setVotingClaim(bytes32 _proposalId, bool _claimed)
4951         public
4952     {
4953         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
4954         DaoStructs.SpecialProposal storage _proposal = proposalsById[_proposalId];
4955         _proposal.voting.claimed = _claimed;
4956     }
4957 
4958     function isClaimed(bytes32 _proposalId)
4959         public
4960         view
4961         returns (bool _claimed)
4962     {
4963         require(senderIsAllowedToRead());
4964         _claimed = proposalsById[_proposalId].voting.claimed;
4965     }
4966 
4967     function readVote(bytes32 _proposalId, address _voter)
4968         public
4969         view
4970         returns (bool _vote, uint256 _weight)
4971     {
4972         require(senderIsAllowedToRead());
4973         return proposalsById[_proposalId].voting.readVote(_voter);
4974     }
4975 
4976     function revealVote(
4977         bytes32 _proposalId,
4978         address _voter,
4979         bool _vote,
4980         uint256 _weight
4981     )
4982         public
4983     {
4984         require(sender_is(CONTRACT_DAO_VOTING));
4985         proposalsById[_proposalId].voting.revealVote(_voter, _vote, _weight);
4986     }
4987 }
4988 
4989 contract DaoPointsStorage is ResolverClient, DaoConstants {
4990 
4991     // struct for a non-transferrable token
4992     struct Token {
4993         uint256 totalSupply;
4994         mapping (address => uint256) balance;
4995     }
4996 
4997     // the reputation point token
4998     // since reputation is cumulative, we only need to store one value
4999     Token reputationPoint;
5000 
5001     // since quarter points are specific to quarters, we need a mapping from
5002     // quarter number to the quarter point token for that quarter
5003     mapping (uint256 => Token) quarterPoint;
5004 
5005     // the same is the case with quarter moderator points
5006     // these are specific to quarters
5007     mapping (uint256 => Token) quarterModeratorPoint;
5008 
5009     constructor(address _resolver)
5010         public
5011     {
5012         require(init(CONTRACT_STORAGE_DAO_POINTS, _resolver));
5013     }
5014 
5015     /// @notice add quarter points for a _participant for a _quarterNumber
5016     function addQuarterPoint(address _participant, uint256 _point, uint256 _quarterNumber)
5017         public
5018         returns (uint256 _newPoint, uint256 _newTotalPoint)
5019     {
5020         require(sender_is_from([CONTRACT_DAO_VOTING, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
5021         quarterPoint[_quarterNumber].totalSupply = quarterPoint[_quarterNumber].totalSupply.add(_point);
5022         quarterPoint[_quarterNumber].balance[_participant] = quarterPoint[_quarterNumber].balance[_participant].add(_point);
5023 
5024         _newPoint = quarterPoint[_quarterNumber].balance[_participant];
5025         _newTotalPoint = quarterPoint[_quarterNumber].totalSupply;
5026     }
5027 
5028     function addModeratorQuarterPoint(address _participant, uint256 _point, uint256 _quarterNumber)
5029         public
5030         returns (uint256 _newPoint, uint256 _newTotalPoint)
5031     {
5032         require(sender_is_from([CONTRACT_DAO_VOTING, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
5033         quarterModeratorPoint[_quarterNumber].totalSupply = quarterModeratorPoint[_quarterNumber].totalSupply.add(_point);
5034         quarterModeratorPoint[_quarterNumber].balance[_participant] = quarterModeratorPoint[_quarterNumber].balance[_participant].add(_point);
5035 
5036         _newPoint = quarterModeratorPoint[_quarterNumber].balance[_participant];
5037         _newTotalPoint = quarterModeratorPoint[_quarterNumber].totalSupply;
5038     }
5039 
5040     /// @notice get quarter points for a _participant in a _quarterNumber
5041     function getQuarterPoint(address _participant, uint256 _quarterNumber)
5042         public
5043         view
5044         returns (uint256 _point)
5045     {
5046         _point = quarterPoint[_quarterNumber].balance[_participant];
5047     }
5048 
5049     function getQuarterModeratorPoint(address _participant, uint256 _quarterNumber)
5050         public
5051         view
5052         returns (uint256 _point)
5053     {
5054         _point = quarterModeratorPoint[_quarterNumber].balance[_participant];
5055     }
5056 
5057     /// @notice get total quarter points for a particular _quarterNumber
5058     function getTotalQuarterPoint(uint256 _quarterNumber)
5059         public
5060         view
5061         returns (uint256 _totalPoint)
5062     {
5063         _totalPoint = quarterPoint[_quarterNumber].totalSupply;
5064     }
5065 
5066     function getTotalQuarterModeratorPoint(uint256 _quarterNumber)
5067         public
5068         view
5069         returns (uint256 _totalPoint)
5070     {
5071         _totalPoint = quarterModeratorPoint[_quarterNumber].totalSupply;
5072     }
5073 
5074     /// @notice add reputation points for a _participant
5075     function increaseReputation(address _participant, uint256 _point)
5076         public
5077         returns (uint256 _newPoint, uint256 _totalPoint)
5078     {
5079         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING]));
5080         reputationPoint.totalSupply = reputationPoint.totalSupply.add(_point);
5081         reputationPoint.balance[_participant] = reputationPoint.balance[_participant].add(_point);
5082 
5083         _newPoint = reputationPoint.balance[_participant];
5084         _totalPoint = reputationPoint.totalSupply;
5085     }
5086 
5087     /// @notice subtract reputation points for a _participant
5088     function reduceReputation(address _participant, uint256 _point)
5089         public
5090         returns (uint256 _newPoint, uint256 _totalPoint)
5091     {
5092         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
5093         uint256 _toDeduct = _point;
5094         if (reputationPoint.balance[_participant] > _point) {
5095             reputationPoint.balance[_participant] = reputationPoint.balance[_participant].sub(_point);
5096         } else {
5097             _toDeduct = reputationPoint.balance[_participant];
5098             reputationPoint.balance[_participant] = 0;
5099         }
5100 
5101         reputationPoint.totalSupply = reputationPoint.totalSupply.sub(_toDeduct);
5102 
5103         _newPoint = reputationPoint.balance[_participant];
5104         _totalPoint = reputationPoint.totalSupply;
5105     }
5106 
5107   /// @notice get reputation points for a _participant
5108   function getReputation(address _participant)
5109       public
5110       view
5111       returns (uint256 _point)
5112   {
5113       _point = reputationPoint.balance[_participant];
5114   }
5115 
5116   /// @notice get total reputation points distributed in the dao
5117   function getTotalReputation()
5118       public
5119       view
5120       returns (uint256 _totalPoint)
5121   {
5122       _totalPoint = reputationPoint.totalSupply;
5123   }
5124 }
5125 
5126 // this contract will receive DGXs fees from the DGX fees distributors
5127 contract DaoRewardsStorage is ResolverClient, DaoConstants {
5128     using DaoStructs for DaoStructs.DaoQuarterInfo;
5129 
5130     // DaoQuarterInfo is a struct that stores the quarter specific information
5131     // regarding totalEffectiveDGDs, DGX distribution day, etc. pls check
5132     // docs in lib/DaoStructs
5133     mapping(uint256 => DaoStructs.DaoQuarterInfo) public allQuartersInfo;
5134 
5135     // Mapping that stores the DGX that can be claimed as rewards by
5136     // an address (a participant of DigixDAO)
5137     mapping(address => uint256) public claimableDGXs;
5138 
5139     // This stores the total DGX value that has been claimed by participants
5140     // this can be done by calling the DaoRewardsManager.claimRewards method
5141     // Note that this value is the only outgoing DGX from DaoRewardsManager contract
5142     // Note that this value also takes into account the demurrage that has been paid
5143     // by participants for simply holding their DGXs in the DaoRewardsManager contract
5144     uint256 public totalDGXsClaimed;
5145 
5146     // The Quarter ID in which the user last participated in
5147     // To participate means they had locked more than CONFIG_MINIMUM_LOCKED_DGD
5148     // DGD tokens. In addition, they should not have withdrawn those tokens in the same
5149     // quarter. Basically, in the main phase of the quarter, if DaoCommon.isParticipant(_user)
5150     // was true, they were participants. And that quarter was their lastParticipatedQuarter
5151     mapping (address => uint256) public lastParticipatedQuarter;
5152 
5153     // This mapping is only used to update the lastParticipatedQuarter to the
5154     // previousLastParticipatedQuarter in case users lock and withdraw DGDs
5155     // within the same quarter's locking phase
5156     mapping (address => uint256) public previousLastParticipatedQuarter;
5157 
5158     // This number marks the Quarter in which the rewards were last updated for that user
5159     // Since the rewards calculation for a specific quarter is only done once that
5160     // quarter is completed, we need this value to note the last quarter when the rewards were updated
5161     // We then start adding the rewards for all quarters after that quarter, until the current quarter
5162     mapping (address => uint256) public lastQuarterThatRewardsWasUpdated;
5163 
5164     // Similar as the lastQuarterThatRewardsWasUpdated, but this is for reputation updates
5165     // Note that reputation can also be deducted for no participation (not locking DGDs)
5166     // This value is used to update the reputation based on all quarters from the lastQuarterThatReputationWasUpdated
5167     // to the current quarter
5168     mapping (address => uint256) public lastQuarterThatReputationWasUpdated;
5169 
5170     constructor(address _resolver)
5171            public
5172     {
5173         require(init(CONTRACT_STORAGE_DAO_REWARDS, _resolver));
5174     }
5175 
5176     function updateQuarterInfo(
5177         uint256 _quarterNumber,
5178         uint256 _minimalParticipationPoint,
5179         uint256 _quarterPointScalingFactor,
5180         uint256 _reputationPointScalingFactor,
5181         uint256 _totalEffectiveDGDPreviousQuarter,
5182 
5183         uint256 _moderatorMinimalQuarterPoint,
5184         uint256 _moderatorQuarterPointScalingFactor,
5185         uint256 _moderatorReputationPointScalingFactor,
5186         uint256 _totalEffectiveModeratorDGDLastQuarter,
5187 
5188         uint256 _dgxDistributionDay,
5189         uint256 _dgxRewardsPoolLastQuarter,
5190         uint256 _sumRewardsFromBeginning
5191     )
5192         public
5193     {
5194         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5195         allQuartersInfo[_quarterNumber].minimalParticipationPoint = _minimalParticipationPoint;
5196         allQuartersInfo[_quarterNumber].quarterPointScalingFactor = _quarterPointScalingFactor;
5197         allQuartersInfo[_quarterNumber].reputationPointScalingFactor = _reputationPointScalingFactor;
5198         allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter = _totalEffectiveDGDPreviousQuarter;
5199 
5200         allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint = _moderatorMinimalQuarterPoint;
5201         allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor = _moderatorQuarterPointScalingFactor;
5202         allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor = _moderatorReputationPointScalingFactor;
5203         allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter = _totalEffectiveModeratorDGDLastQuarter;
5204 
5205         allQuartersInfo[_quarterNumber].dgxDistributionDay = _dgxDistributionDay;
5206         allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter = _dgxRewardsPoolLastQuarter;
5207         allQuartersInfo[_quarterNumber].sumRewardsFromBeginning = _sumRewardsFromBeginning;
5208     }
5209 
5210     function updateClaimableDGX(address _user, uint256 _newClaimableDGX)
5211         public
5212     {
5213         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5214         claimableDGXs[_user] = _newClaimableDGX;
5215     }
5216 
5217     function updateLastParticipatedQuarter(address _user, uint256 _lastQuarter)
5218         public
5219     {
5220         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
5221         lastParticipatedQuarter[_user] = _lastQuarter;
5222     }
5223 
5224     function updatePreviousLastParticipatedQuarter(address _user, uint256 _lastQuarter)
5225         public
5226     {
5227         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
5228         previousLastParticipatedQuarter[_user] = _lastQuarter;
5229     }
5230 
5231     function updateLastQuarterThatRewardsWasUpdated(address _user, uint256 _lastQuarter)
5232         public
5233     {
5234         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING, EMPTY_BYTES]));
5235         lastQuarterThatRewardsWasUpdated[_user] = _lastQuarter;
5236     }
5237 
5238     function updateLastQuarterThatReputationWasUpdated(address _user, uint256 _lastQuarter)
5239         public
5240     {
5241         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING, EMPTY_BYTES]));
5242         lastQuarterThatReputationWasUpdated[_user] = _lastQuarter;
5243     }
5244 
5245     function addToTotalDgxClaimed(uint256 _dgxClaimed)
5246         public
5247     {
5248         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5249         totalDGXsClaimed = totalDGXsClaimed.add(_dgxClaimed);
5250     }
5251 
5252     function readQuarterInfo(uint256 _quarterNumber)
5253         public
5254         view
5255         returns (
5256             uint256 _minimalParticipationPoint,
5257             uint256 _quarterPointScalingFactor,
5258             uint256 _reputationPointScalingFactor,
5259             uint256 _totalEffectiveDGDPreviousQuarter,
5260 
5261             uint256 _moderatorMinimalQuarterPoint,
5262             uint256 _moderatorQuarterPointScalingFactor,
5263             uint256 _moderatorReputationPointScalingFactor,
5264             uint256 _totalEffectiveModeratorDGDLastQuarter,
5265 
5266             uint256 _dgxDistributionDay,
5267             uint256 _dgxRewardsPoolLastQuarter,
5268             uint256 _sumRewardsFromBeginning
5269         )
5270     {
5271         _minimalParticipationPoint = allQuartersInfo[_quarterNumber].minimalParticipationPoint;
5272         _quarterPointScalingFactor = allQuartersInfo[_quarterNumber].quarterPointScalingFactor;
5273         _reputationPointScalingFactor = allQuartersInfo[_quarterNumber].reputationPointScalingFactor;
5274         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5275         _moderatorMinimalQuarterPoint = allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint;
5276         _moderatorQuarterPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor;
5277         _moderatorReputationPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor;
5278         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5279         _dgxDistributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5280         _dgxRewardsPoolLastQuarter = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5281         _sumRewardsFromBeginning = allQuartersInfo[_quarterNumber].sumRewardsFromBeginning;
5282     }
5283 
5284     function readQuarterGeneralInfo(uint256 _quarterNumber)
5285         public
5286         view
5287         returns (
5288             uint256 _dgxDistributionDay,
5289             uint256 _dgxRewardsPoolLastQuarter,
5290             uint256 _sumRewardsFromBeginning
5291         )
5292     {
5293         _dgxDistributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5294         _dgxRewardsPoolLastQuarter = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5295         _sumRewardsFromBeginning = allQuartersInfo[_quarterNumber].sumRewardsFromBeginning;
5296     }
5297 
5298     function readQuarterModeratorInfo(uint256 _quarterNumber)
5299         public
5300         view
5301         returns (
5302             uint256 _moderatorMinimalQuarterPoint,
5303             uint256 _moderatorQuarterPointScalingFactor,
5304             uint256 _moderatorReputationPointScalingFactor,
5305             uint256 _totalEffectiveModeratorDGDLastQuarter
5306         )
5307     {
5308         _moderatorMinimalQuarterPoint = allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint;
5309         _moderatorQuarterPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor;
5310         _moderatorReputationPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor;
5311         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5312     }
5313 
5314     function readQuarterParticipantInfo(uint256 _quarterNumber)
5315         public
5316         view
5317         returns (
5318             uint256 _minimalParticipationPoint,
5319             uint256 _quarterPointScalingFactor,
5320             uint256 _reputationPointScalingFactor,
5321             uint256 _totalEffectiveDGDPreviousQuarter
5322         )
5323     {
5324         _minimalParticipationPoint = allQuartersInfo[_quarterNumber].minimalParticipationPoint;
5325         _quarterPointScalingFactor = allQuartersInfo[_quarterNumber].quarterPointScalingFactor;
5326         _reputationPointScalingFactor = allQuartersInfo[_quarterNumber].reputationPointScalingFactor;
5327         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5328     }
5329 
5330     function readDgxDistributionDay(uint256 _quarterNumber)
5331         public
5332         view
5333         returns (uint256 _distributionDay)
5334     {
5335         _distributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5336     }
5337 
5338     function readTotalEffectiveDGDLastQuarter(uint256 _quarterNumber)
5339         public
5340         view
5341         returns (uint256 _totalEffectiveDGDPreviousQuarter)
5342     {
5343         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5344     }
5345 
5346     function readTotalEffectiveModeratorDGDLastQuarter(uint256 _quarterNumber)
5347         public
5348         view
5349         returns (uint256 _totalEffectiveModeratorDGDLastQuarter)
5350     {
5351         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5352     }
5353 
5354     function readRewardsPoolOfLastQuarter(uint256 _quarterNumber)
5355         public
5356         view
5357         returns (uint256 _rewardsPool)
5358     {
5359         _rewardsPool = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5360     }
5361 }
5362 
5363 contract IntermediateResultsStorage is ResolverClient, DaoConstants {
5364     using DaoStructs for DaoStructs.IntermediateResults;
5365 
5366     constructor(address _resolver) public {
5367         require(init(CONTRACT_STORAGE_INTERMEDIATE_RESULTS, _resolver));
5368     }
5369 
5370     // There are scenarios in which we must loop across all participants/moderators
5371     // in a function call. For a big number of operations, the function call may be short of gas
5372     // To tackle this, we use an IntermediateResults struct to store the intermediate results
5373     // The same function is then called multiple times until all operations are completed
5374     // If the operations cannot be done in that iteration, the intermediate results are stored
5375     // else, the final outcome is returned
5376     // Please check the lib/DaoStructs for docs on this struct
5377     mapping (bytes32 => DaoStructs.IntermediateResults) allIntermediateResults;
5378 
5379     function getIntermediateResults(bytes32 _key)
5380         public
5381         view
5382         returns (
5383             address _countedUntil,
5384             uint256 _currentForCount,
5385             uint256 _currentAgainstCount,
5386             uint256 _currentSumOfEffectiveBalance
5387         )
5388     {
5389         _countedUntil = allIntermediateResults[_key].countedUntil;
5390         _currentForCount = allIntermediateResults[_key].currentForCount;
5391         _currentAgainstCount = allIntermediateResults[_key].currentAgainstCount;
5392         _currentSumOfEffectiveBalance = allIntermediateResults[_key].currentSumOfEffectiveBalance;
5393     }
5394 
5395     function resetIntermediateResults(bytes32 _key)
5396         public
5397     {
5398         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_SPECIAL_VOTING_CLAIMS]));
5399         allIntermediateResults[_key].countedUntil = address(0x0);
5400     }
5401 
5402     function setIntermediateResults(
5403         bytes32 _key,
5404         address _countedUntil,
5405         uint256 _currentForCount,
5406         uint256 _currentAgainstCount,
5407         uint256 _currentSumOfEffectiveBalance
5408     )
5409         public
5410     {
5411         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_SPECIAL_VOTING_CLAIMS]));
5412         allIntermediateResults[_key].countedUntil = _countedUntil;
5413         allIntermediateResults[_key].currentForCount = _currentForCount;
5414         allIntermediateResults[_key].currentAgainstCount = _currentAgainstCount;
5415         allIntermediateResults[_key].currentSumOfEffectiveBalance = _currentSumOfEffectiveBalance;
5416     }
5417 }
5418 
5419 library MathHelper {
5420 
5421   using SafeMath for uint256;
5422 
5423   function max(uint256 a, uint256 b) internal pure returns (uint256 _max){
5424       _max = b;
5425       if (a > b) {
5426           _max = a;
5427       }
5428   }
5429 
5430   function min(uint256 a, uint256 b) internal pure returns (uint256 _min){
5431       _min = b;
5432       if (a < b) {
5433           _min = a;
5434       }
5435   }
5436 
5437   function sumNumbers(uint256[] _numbers) internal pure returns (uint256 _sum) {
5438       for (uint256 i=0;i<_numbers.length;i++) {
5439           _sum = _sum.add(_numbers[i]);
5440       }
5441   }
5442 }
5443 
5444 contract DaoCommonMini is IdentityCommon {
5445 
5446     using MathHelper for MathHelper;
5447 
5448     /**
5449     @notice Check if the DAO contracts have been replaced by a new set of contracts
5450     @return _isNotReplaced true if it is not replaced, false if it has already been replaced
5451     */
5452     function isDaoNotReplaced()
5453         public
5454         view
5455         returns (bool _isNotReplaced)
5456     {
5457         _isNotReplaced = !daoUpgradeStorage().isReplacedByNewDao();
5458     }
5459 
5460     /**
5461     @notice Check if it is currently in the locking phase
5462     @dev No governance activities can happen in the locking phase. The locking phase is from t=0 to t=CONFIG_LOCKING_PHASE_DURATION-1
5463     @return _isLockingPhase true if it is in the locking phase
5464     */
5465     function isLockingPhase()
5466         public
5467         view
5468         returns (bool _isLockingPhase)
5469     {
5470         _isLockingPhase = currentTimeInQuarter() < getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
5471     }
5472 
5473     /**
5474     @notice Check if it is currently in a main phase.
5475     @dev The main phase is where all the governance activities could take plase. If the DAO is replaced, there can never be any more main phase.
5476     @return _isMainPhase true if it is in a main phase
5477     */
5478     function isMainPhase()
5479         public
5480         view
5481         returns (bool _isMainPhase)
5482     {
5483         _isMainPhase =
5484             isDaoNotReplaced() &&
5485             currentTimeInQuarter() >= getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
5486     }
5487 
5488     /**
5489     @notice Check if the calculateGlobalRewardsBeforeNewQuarter function has been done for a certain quarter
5490     @dev However, there is no need to run calculateGlobalRewardsBeforeNewQuarter for the first quarter
5491     */
5492     modifier ifGlobalRewardsSet(uint256 _quarterNumber) {
5493         if (_quarterNumber > 1) {
5494             require(daoRewardsStorage().readDgxDistributionDay(_quarterNumber) > 0);
5495         }
5496         _;
5497     }
5498 
5499     /**
5500     @notice require that it is currently during a phase, which is within _relativePhaseStart and _relativePhaseEnd seconds, after the _startingPoint
5501     */
5502     function requireInPhase(uint256 _startingPoint, uint256 _relativePhaseStart, uint256 _relativePhaseEnd)
5503         internal
5504         view
5505     {
5506         require(_startingPoint > 0);
5507         require(now < _startingPoint.add(_relativePhaseEnd));
5508         require(now >= _startingPoint.add(_relativePhaseStart));
5509     }
5510 
5511     /**
5512     @notice Get the current quarter index
5513     @dev Quarter indexes starts from 1
5514     @return _quarterNumber the current quarter index
5515     */
5516     function currentQuarterNumber()
5517         public
5518         view
5519         returns(uint256 _quarterNumber)
5520     {
5521         _quarterNumber = getQuarterNumber(now);
5522     }
5523 
5524     /**
5525     @notice Get the quarter index of a timestamp
5526     @dev Quarter indexes starts from 1
5527     @return _index the quarter index
5528     */
5529     function getQuarterNumber(uint256 _time)
5530         internal
5531         view
5532         returns (uint256 _index)
5533     {
5534         require(startOfFirstQuarterIsSet());
5535         _index =
5536             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
5537             .div(getUintConfig(CONFIG_QUARTER_DURATION))
5538             .add(1);
5539     }
5540 
5541     /**
5542     @notice Get the relative time in quarter of a timestamp
5543     @dev For example, the timeInQuarter of the first second of any quarter n-th is always 1
5544     */
5545     function timeInQuarter(uint256 _time)
5546         internal
5547         view
5548         returns (uint256 _timeInQuarter)
5549     {
5550         require(startOfFirstQuarterIsSet()); // must be already set
5551         _timeInQuarter =
5552             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
5553             % getUintConfig(CONFIG_QUARTER_DURATION);
5554     }
5555 
5556     /**
5557     @notice Check if the start of first quarter is already set
5558     @return _isSet true if start of first quarter is already set
5559     */
5560     function startOfFirstQuarterIsSet()
5561         internal
5562         view
5563         returns (bool _isSet)
5564     {
5565         _isSet = daoUpgradeStorage().startOfFirstQuarter() != 0;
5566     }
5567 
5568     /**
5569     @notice Get the current relative time in the quarter
5570     @dev For example: the currentTimeInQuarter of the first second of any quarter is 1
5571     @return _currentT the current relative time in the quarter
5572     */
5573     function currentTimeInQuarter()
5574         public
5575         view
5576         returns (uint256 _currentT)
5577     {
5578         _currentT = timeInQuarter(now);
5579     }
5580 
5581     /**
5582     @notice Get the time remaining in the quarter
5583     */
5584     function getTimeLeftInQuarter(uint256 _time)
5585         internal
5586         view
5587         returns (uint256 _timeLeftInQuarter)
5588     {
5589         _timeLeftInQuarter = getUintConfig(CONFIG_QUARTER_DURATION).sub(timeInQuarter(_time));
5590     }
5591 
5592     function daoListingService()
5593         internal
5594         view
5595         returns (DaoListingService _contract)
5596     {
5597         _contract = DaoListingService(get_contract(CONTRACT_SERVICE_DAO_LISTING));
5598     }
5599 
5600     function daoConfigsStorage()
5601         internal
5602         view
5603         returns (DaoConfigsStorage _contract)
5604     {
5605         _contract = DaoConfigsStorage(get_contract(CONTRACT_STORAGE_DAO_CONFIG));
5606     }
5607 
5608     function daoStakeStorage()
5609         internal
5610         view
5611         returns (DaoStakeStorage _contract)
5612     {
5613         _contract = DaoStakeStorage(get_contract(CONTRACT_STORAGE_DAO_STAKE));
5614     }
5615 
5616     function daoStorage()
5617         internal
5618         view
5619         returns (DaoStorage _contract)
5620     {
5621         _contract = DaoStorage(get_contract(CONTRACT_STORAGE_DAO));
5622     }
5623 
5624     function daoProposalCounterStorage()
5625         internal
5626         view
5627         returns (DaoProposalCounterStorage _contract)
5628     {
5629         _contract = DaoProposalCounterStorage(get_contract(CONTRACT_STORAGE_DAO_COUNTER));
5630     }
5631 
5632     function daoUpgradeStorage()
5633         internal
5634         view
5635         returns (DaoUpgradeStorage _contract)
5636     {
5637         _contract = DaoUpgradeStorage(get_contract(CONTRACT_STORAGE_DAO_UPGRADE));
5638     }
5639 
5640     function daoSpecialStorage()
5641         internal
5642         view
5643         returns (DaoSpecialStorage _contract)
5644     {
5645         _contract = DaoSpecialStorage(get_contract(CONTRACT_STORAGE_DAO_SPECIAL));
5646     }
5647 
5648     function daoPointsStorage()
5649         internal
5650         view
5651         returns (DaoPointsStorage _contract)
5652     {
5653         _contract = DaoPointsStorage(get_contract(CONTRACT_STORAGE_DAO_POINTS));
5654     }
5655 
5656     function daoRewardsStorage()
5657         internal
5658         view
5659         returns (DaoRewardsStorage _contract)
5660     {
5661         _contract = DaoRewardsStorage(get_contract(CONTRACT_STORAGE_DAO_REWARDS));
5662     }
5663 
5664     function intermediateResultsStorage()
5665         internal
5666         view
5667         returns (IntermediateResultsStorage _contract)
5668     {
5669         _contract = IntermediateResultsStorage(get_contract(CONTRACT_STORAGE_INTERMEDIATE_RESULTS));
5670     }
5671 
5672     function getUintConfig(bytes32 _configKey)
5673         public
5674         view
5675         returns (uint256 _configValue)
5676     {
5677         _configValue = daoConfigsStorage().uintConfigs(_configKey);
5678     }
5679 }
5680 
5681 contract DaoCommon is DaoCommonMini {
5682 
5683     using MathHelper for MathHelper;
5684 
5685     /**
5686     @notice Check if the transaction is called by the proposer of a proposal
5687     @return _isFromProposer true if the caller is the proposer
5688     */
5689     function isFromProposer(bytes32 _proposalId)
5690         internal
5691         view
5692         returns (bool _isFromProposer)
5693     {
5694         _isFromProposer = msg.sender == daoStorage().readProposalProposer(_proposalId);
5695     }
5696 
5697     /**
5698     @notice Check if the proposal can still be "editted", or in other words, added more versions
5699     @dev Once the proposal is finalized, it can no longer be editted. The proposer will still be able to add docs and change fundings though.
5700     @return _isEditable true if the proposal is editable
5701     */
5702     function isEditable(bytes32 _proposalId)
5703         internal
5704         view
5705         returns (bool _isEditable)
5706     {
5707         bytes32 _finalVersion;
5708         (,,,,,,,_finalVersion,,) = daoStorage().readProposal(_proposalId);
5709         _isEditable = _finalVersion == EMPTY_BYTES;
5710     }
5711 
5712     /**
5713     @notice returns the balance of DaoFundingManager, which is the wei in DigixDAO
5714     */
5715     function weiInDao()
5716         internal
5717         view
5718         returns (uint256 _wei)
5719     {
5720         _wei = get_contract(CONTRACT_DAO_FUNDING_MANAGER).balance;
5721     }
5722 
5723     /**
5724     @notice Check if it is after the draft voting phase of the proposal
5725     */
5726     modifier ifAfterDraftVotingPhase(bytes32 _proposalId) {
5727         uint256 _start = daoStorage().readProposalDraftVotingTime(_proposalId);
5728         require(_start > 0); // Draft voting must have started. In other words, proposer must have finalized the proposal
5729         require(now >= _start.add(getUintConfig(CONFIG_DRAFT_VOTING_PHASE)));
5730         _;
5731     }
5732 
5733     modifier ifCommitPhase(bytes32 _proposalId, uint8 _index) {
5734         requireInPhase(
5735             daoStorage().readProposalVotingTime(_proposalId, _index),
5736             0,
5737             getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE)
5738         );
5739         _;
5740     }
5741 
5742     modifier ifRevealPhase(bytes32 _proposalId, uint256 _index) {
5743       requireInPhase(
5744           daoStorage().readProposalVotingTime(_proposalId, _index),
5745           getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE),
5746           getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)
5747       );
5748       _;
5749     }
5750 
5751     modifier ifAfterProposalRevealPhase(bytes32 _proposalId, uint256 _index) {
5752       uint256 _start = daoStorage().readProposalVotingTime(_proposalId, _index);
5753       require(_start > 0);
5754       require(now >= _start.add(getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)));
5755       _;
5756     }
5757 
5758     modifier ifDraftVotingPhase(bytes32 _proposalId) {
5759         requireInPhase(
5760             daoStorage().readProposalDraftVotingTime(_proposalId),
5761             0,
5762             getUintConfig(CONFIG_DRAFT_VOTING_PHASE)
5763         );
5764         _;
5765     }
5766 
5767     modifier isProposalState(bytes32 _proposalId, bytes32 _STATE) {
5768         bytes32 _currentState;
5769         (,,,_currentState,,,,,,) = daoStorage().readProposal(_proposalId);
5770         require(_currentState == _STATE);
5771         _;
5772     }
5773 
5774     /**
5775     @notice Check if the DAO has enough ETHs for a particular funding request
5776     */
5777     modifier ifFundingPossible(uint256[] _fundings, uint256 _finalReward) {
5778         require(MathHelper.sumNumbers(_fundings).add(_finalReward) <= weiInDao());
5779         _;
5780     }
5781 
5782     modifier ifDraftNotClaimed(bytes32 _proposalId) {
5783         require(daoStorage().isDraftClaimed(_proposalId) == false);
5784         _;
5785     }
5786 
5787     modifier ifNotClaimed(bytes32 _proposalId, uint256 _index) {
5788         require(daoStorage().isClaimed(_proposalId, _index) == false);
5789         _;
5790     }
5791 
5792     modifier ifNotClaimedSpecial(bytes32 _proposalId) {
5793         require(daoSpecialStorage().isClaimed(_proposalId) == false);
5794         _;
5795     }
5796 
5797     modifier hasNotRevealed(bytes32 _proposalId, uint256 _index) {
5798         uint256 _voteWeight;
5799         (, _voteWeight) = daoStorage().readVote(_proposalId, _index, msg.sender);
5800         require(_voteWeight == uint(0));
5801         _;
5802     }
5803 
5804     modifier hasNotRevealedSpecial(bytes32 _proposalId) {
5805         uint256 _weight;
5806         (,_weight) = daoSpecialStorage().readVote(_proposalId, msg.sender);
5807         require(_weight == uint256(0));
5808         _;
5809     }
5810 
5811     modifier ifAfterRevealPhaseSpecial(bytes32 _proposalId) {
5812       uint256 _start = daoSpecialStorage().readVotingTime(_proposalId);
5813       require(_start > 0);
5814       require(now.sub(_start) >= getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL));
5815       _;
5816     }
5817 
5818     modifier ifCommitPhaseSpecial(bytes32 _proposalId) {
5819         requireInPhase(
5820             daoSpecialStorage().readVotingTime(_proposalId),
5821             0,
5822             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE)
5823         );
5824         _;
5825     }
5826 
5827     modifier ifRevealPhaseSpecial(bytes32 _proposalId) {
5828         requireInPhase(
5829             daoSpecialStorage().readVotingTime(_proposalId),
5830             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE),
5831             getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL)
5832         );
5833         _;
5834     }
5835 
5836     function daoWhitelistingStorage()
5837         internal
5838         view
5839         returns (DaoWhitelistingStorage _contract)
5840     {
5841         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
5842     }
5843 
5844     function getAddressConfig(bytes32 _configKey)
5845         public
5846         view
5847         returns (address _configValue)
5848     {
5849         _configValue = daoConfigsStorage().addressConfigs(_configKey);
5850     }
5851 
5852     function getBytesConfig(bytes32 _configKey)
5853         public
5854         view
5855         returns (bytes32 _configValue)
5856     {
5857         _configValue = daoConfigsStorage().bytesConfigs(_configKey);
5858     }
5859 
5860     /**
5861     @notice Check if a user is a participant in the current quarter
5862     */
5863     function isParticipant(address _user)
5864         public
5865         view
5866         returns (bool _is)
5867     {
5868         _is =
5869             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
5870             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_LOCKED_DGD));
5871     }
5872 
5873     /**
5874     @notice Check if a user is a moderator in the current quarter
5875     */
5876     function isModerator(address _user)
5877         public
5878         view
5879         returns (bool _is)
5880     {
5881         _is =
5882             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
5883             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_DGD_FOR_MODERATOR))
5884             && (daoPointsStorage().getReputation(_user) >= getUintConfig(CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR));
5885     }
5886 
5887     /**
5888     @notice Calculate the start of a specific milestone of a specific proposal.
5889     @dev This is calculated from the voting start of the voting round preceding the milestone
5890          This would throw if the voting start is 0 (the voting round has not started yet)
5891          Note that if the milestoneIndex is exactly the same as the number of milestones,
5892          This will just return the end of the last voting round.
5893     */
5894     function startOfMilestone(bytes32 _proposalId, uint256 _milestoneIndex)
5895         internal
5896         view
5897         returns (uint256 _milestoneStart)
5898     {
5899         uint256 _startOfPrecedingVotingRound = daoStorage().readProposalVotingTime(_proposalId, _milestoneIndex);
5900         require(_startOfPrecedingVotingRound > 0);
5901         // the preceding voting round must have started
5902 
5903         if (_milestoneIndex == 0) { // This is the 1st milestone, which starts after voting round 0
5904             _milestoneStart =
5905                 _startOfPrecedingVotingRound
5906                 .add(getUintConfig(CONFIG_VOTING_PHASE_TOTAL));
5907         } else { // if its the n-th milestone, it starts after voting round n-th
5908             _milestoneStart =
5909                 _startOfPrecedingVotingRound
5910                 .add(getUintConfig(CONFIG_INTERIM_PHASE_TOTAL));
5911         }
5912     }
5913 
5914     /**
5915     @notice Calculate the actual voting start for a voting round, given the tentative start
5916     @dev The tentative start is the ideal start. For example, when a proposer finish a milestone, it should be now
5917          However, sometimes the tentative start is too close to the end of the quarter, hence, the actual voting start should be pushed to the next quarter
5918     */
5919     function getTimelineForNextVote(
5920         uint256 _index,
5921         uint256 _tentativeVotingStart
5922     )
5923         internal
5924         view
5925         returns (uint256 _actualVotingStart)
5926     {
5927         uint256 _timeLeftInQuarter = getTimeLeftInQuarter(_tentativeVotingStart);
5928         uint256 _votingDuration = getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL);
5929         _actualVotingStart = _tentativeVotingStart;
5930         if (timeInQuarter(_tentativeVotingStart) < getUintConfig(CONFIG_LOCKING_PHASE_DURATION)) { // if the tentative start is during a locking phase
5931             _actualVotingStart = _tentativeVotingStart.add(
5932                 getUintConfig(CONFIG_LOCKING_PHASE_DURATION).sub(timeInQuarter(_tentativeVotingStart))
5933             );
5934         } else if (_timeLeftInQuarter < _votingDuration.add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE))) { // if the time left in quarter is not enough to vote and claim voting
5935             _actualVotingStart = _tentativeVotingStart.add(
5936                 _timeLeftInQuarter.add(getUintConfig(CONFIG_LOCKING_PHASE_DURATION)).add(1)
5937             );
5938         }
5939     }
5940 
5941     /**
5942     @notice Check if we can add another non-Digix proposal in this quarter
5943     @dev There is a max cap to the number of non-Digix proposals CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER
5944     */
5945     function checkNonDigixProposalLimit(bytes32 _proposalId)
5946         internal
5947         view
5948     {
5949         require(isNonDigixProposalsWithinLimit(_proposalId));
5950     }
5951 
5952     function isNonDigixProposalsWithinLimit(bytes32 _proposalId)
5953         internal
5954         view
5955         returns (bool _withinLimit)
5956     {
5957         bool _isDigixProposal;
5958         (,,,,,,,,,_isDigixProposal) = daoStorage().readProposal(_proposalId);
5959         _withinLimit = true;
5960         if (!_isDigixProposal) {
5961             _withinLimit = daoProposalCounterStorage().proposalCountByQuarter(currentQuarterNumber()) < getUintConfig(CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER);
5962         }
5963     }
5964 
5965     /**
5966     @notice If its a non-Digix proposal, check if the fundings are within limit
5967     @dev There is a max cap to the fundings and number of milestones for non-Digix proposals
5968     */
5969     function checkNonDigixFundings(uint256[] _milestonesFundings, uint256 _finalReward)
5970         internal
5971         view
5972     {
5973         if (!is_founder()) {
5974             require(_milestonesFundings.length <= getUintConfig(CONFIG_MAX_MILESTONES_FOR_NON_DIGIX));
5975             require(MathHelper.sumNumbers(_milestonesFundings).add(_finalReward) <= getUintConfig(CONFIG_MAX_FUNDING_FOR_NON_DIGIX));
5976         }
5977     }
5978 
5979     /**
5980     @notice Check if msg.sender can do operations as a proposer
5981     @dev Note that this function does not check if he is the proposer of the proposal
5982     */
5983     function senderCanDoProposerOperations()
5984         internal
5985         view
5986     {
5987         require(isMainPhase());
5988         require(isParticipant(msg.sender));
5989         require(identity_storage().is_kyc_approved(msg.sender));
5990     }
5991 }
5992 
5993 /// @title Digix Gold Token Demurrage Calculator
5994 /// @author Digix Holdings Pte Ltd
5995 /// @notice This contract is meant to be used by exchanges/other parties who want to calculate the DGX demurrage fees, provided an initial balance and the days elapsed
5996 contract DgxDemurrageCalculator {
5997     function calculateDemurrage(uint256 _initial_balance, uint256 _days_elapsed)
5998         public
5999         view
6000         returns (uint256 _demurrage_fees, bool _no_demurrage_fees);
6001 }
6002 
6003 contract DaoCalculatorService is DaoCommon {
6004 
6005     address public dgxDemurrageCalculatorAddress;
6006 
6007     using MathHelper for MathHelper;
6008 
6009     constructor(address _resolver, address _dgxDemurrageCalculatorAddress)
6010         public
6011     {
6012         require(init(CONTRACT_SERVICE_DAO_CALCULATOR, _resolver));
6013         dgxDemurrageCalculatorAddress = _dgxDemurrageCalculatorAddress;
6014     }
6015 
6016 
6017     /**
6018     @notice Calculate the additional lockedDGDStake, given the DGDs that the user has just locked in
6019     @dev The earlier the locking happens, the more lockedDGDStake the user will get
6020          The formula is: additionalLockedDGDStake = (90 - t)/80 * additionalDGD if t is more than 10. If t<=10, additionalLockedDGDStake = additionalDGD
6021     */
6022     function calculateAdditionalLockedDGDStake(uint256 _additionalDgd)
6023         public
6024         view
6025         returns (uint256 _additionalLockedDGDStake)
6026     {
6027         _additionalLockedDGDStake =
6028             _additionalDgd.mul(
6029                 getUintConfig(CONFIG_QUARTER_DURATION)
6030                 .sub(
6031                     MathHelper.max(
6032                         currentTimeInQuarter(),
6033                         getUintConfig(CONFIG_LOCKING_PHASE_DURATION)
6034                     )
6035                 )
6036             )
6037             .div(
6038                 getUintConfig(CONFIG_QUARTER_DURATION)
6039                 .sub(getUintConfig(CONFIG_LOCKING_PHASE_DURATION))
6040             );
6041     }
6042 
6043 
6044     // Quorum is in terms of lockedDGDStake
6045     function minimumDraftQuorum(bytes32 _proposalId)
6046         public
6047         view
6048         returns (uint256 _minQuorum)
6049     {
6050         uint256[] memory _fundings;
6051 
6052         (_fundings,) = daoStorage().readProposalFunding(_proposalId);
6053         _minQuorum = calculateMinQuorum(
6054             daoStakeStorage().totalModeratorLockedDGDStake(),
6055             getUintConfig(CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR),
6056             getUintConfig(CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR),
6057             getUintConfig(CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR),
6058             getUintConfig(CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR),
6059             _fundings[0]
6060         );
6061     }
6062 
6063 
6064     function draftQuotaPass(uint256 _for, uint256 _against)
6065         public
6066         view
6067         returns (bool _passed)
6068     {
6069         _passed = _for.mul(getUintConfig(CONFIG_DRAFT_QUOTA_DENOMINATOR))
6070                 > getUintConfig(CONFIG_DRAFT_QUOTA_NUMERATOR).mul(_for.add(_against));
6071     }
6072 
6073 
6074     // Quorum is in terms of lockedDGDStake
6075     function minimumVotingQuorum(bytes32 _proposalId, uint256 _milestone_id)
6076         public
6077         view
6078         returns (uint256 _minQuorum)
6079     {
6080         require(senderIsAllowedToRead());
6081         uint256[] memory _weiAskedPerMilestone;
6082         uint256 _finalReward;
6083         (_weiAskedPerMilestone,_finalReward) = daoStorage().readProposalFunding(_proposalId);
6084         require(_milestone_id <= _weiAskedPerMilestone.length);
6085         if (_milestone_id == _weiAskedPerMilestone.length) {
6086             // calculate quorum for the final voting round
6087             _minQuorum = calculateMinQuorum(
6088                 daoStakeStorage().totalLockedDGDStake(),
6089                 getUintConfig(CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR),
6090                 getUintConfig(CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR),
6091                 getUintConfig(CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR),
6092                 getUintConfig(CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR),
6093                 _finalReward
6094             );
6095         } else {
6096             // calculate quorum for a voting round
6097             _minQuorum = calculateMinQuorum(
6098                 daoStakeStorage().totalLockedDGDStake(),
6099                 getUintConfig(CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR),
6100                 getUintConfig(CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR),
6101                 getUintConfig(CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR),
6102                 getUintConfig(CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR),
6103                 _weiAskedPerMilestone[_milestone_id]
6104             );
6105         }
6106     }
6107 
6108 
6109     // Quorum is in terms of lockedDGDStake
6110     function minimumVotingQuorumForSpecial()
6111         public
6112         view
6113         returns (uint256 _minQuorum)
6114     {
6115       _minQuorum = getUintConfig(CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR).mul(
6116                        daoStakeStorage().totalLockedDGDStake()
6117                    ).div(
6118                        getUintConfig(CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR)
6119                    );
6120     }
6121 
6122 
6123     function votingQuotaPass(uint256 _for, uint256 _against)
6124         public
6125         view
6126         returns (bool _passed)
6127     {
6128         _passed = _for.mul(getUintConfig(CONFIG_VOTING_QUOTA_DENOMINATOR))
6129                 > getUintConfig(CONFIG_VOTING_QUOTA_NUMERATOR).mul(_for.add(_against));
6130     }
6131 
6132 
6133     function votingQuotaForSpecialPass(uint256 _for, uint256 _against)
6134         public
6135         view
6136         returns (bool _passed)
6137     {
6138         _passed =_for.mul(getUintConfig(CONFIG_SPECIAL_QUOTA_DENOMINATOR))
6139                 > getUintConfig(CONFIG_SPECIAL_QUOTA_NUMERATOR).mul(_for.add(_against));
6140     }
6141 
6142 
6143     function calculateMinQuorum(
6144         uint256 _totalStake,
6145         uint256 _fixedQuorumPortionNumerator,
6146         uint256 _fixedQuorumPortionDenominator,
6147         uint256 _scalingFactorNumerator,
6148         uint256 _scalingFactorDenominator,
6149         uint256 _weiAsked
6150     )
6151         internal
6152         view
6153         returns (uint256 _minimumQuorum)
6154     {
6155         uint256 _weiInDao = weiInDao();
6156         // add the fixed portion of the quorum
6157         _minimumQuorum = (_totalStake.mul(_fixedQuorumPortionNumerator)).div(_fixedQuorumPortionDenominator);
6158 
6159         // add the dynamic portion of the quorum
6160         _minimumQuorum = _minimumQuorum.add(_totalStake.mul(_weiAsked.mul(_scalingFactorNumerator)).div(_weiInDao.mul(_scalingFactorDenominator)));
6161     }
6162 
6163 
6164     function calculateUserEffectiveBalance(
6165         uint256 _minimalParticipationPoint,
6166         uint256 _quarterPointScalingFactor,
6167         uint256 _reputationPointScalingFactor,
6168         uint256 _quarterPoint,
6169         uint256 _reputationPoint,
6170         uint256 _lockedDGDStake
6171     )
6172         public
6173         pure
6174         returns (uint256 _effectiveDGDBalance)
6175     {
6176         uint256 _baseDGDBalance = MathHelper.min(_quarterPoint, _minimalParticipationPoint).mul(_lockedDGDStake).div(_minimalParticipationPoint);
6177         _effectiveDGDBalance =
6178             _baseDGDBalance
6179             .mul(_quarterPointScalingFactor.add(_quarterPoint).sub(_minimalParticipationPoint))
6180             .mul(_reputationPointScalingFactor.add(_reputationPoint))
6181             .div(_quarterPointScalingFactor.mul(_reputationPointScalingFactor));
6182     }
6183 
6184 
6185     function calculateDemurrage(uint256 _balance, uint256 _daysElapsed)
6186         public
6187         view
6188         returns (uint256 _demurrageFees)
6189     {
6190         (_demurrageFees,) = DgxDemurrageCalculator(dgxDemurrageCalculatorAddress).calculateDemurrage(_balance, _daysElapsed);
6191     }
6192 }
6193 
6194 /**
6195  * @title ERC20Basic
6196  * @dev Simpler version of ERC20 interface
6197  * See https://github.com/ethereum/EIPs/issues/179
6198  */
6199 contract ERC20Basic {
6200   function totalSupply() public view returns (uint256);
6201   function balanceOf(address _who) public view returns (uint256);
6202   function transfer(address _to, uint256 _value) public returns (bool);
6203   event Transfer(address indexed from, address indexed to, uint256 value);
6204 }
6205 
6206 /**
6207  * @title ERC20 interface
6208  * @dev see https://github.com/ethereum/EIPs/issues/20
6209  */
6210 contract ERC20 is ERC20Basic {
6211   function allowance(address _owner, address _spender)
6212     public view returns (uint256);
6213 
6214   function transferFrom(address _from, address _to, uint256 _value)
6215     public returns (bool);
6216 
6217   function approve(address _spender, uint256 _value) public returns (bool);
6218   event Approval(
6219     address indexed owner,
6220     address indexed spender,
6221     uint256 value
6222   );
6223 }
6224 
6225 library DaoIntermediateStructs {
6226 
6227     // Struct used in large functions to cut down on variables
6228     // store the summation of weights "FOR" proposal
6229     // store the summation of weights "AGAINST" proposal
6230     struct VotingCount {
6231         // weight of votes "FOR" the voting round
6232         uint256 forCount;
6233         // weight of votes "AGAINST" the voting round
6234         uint256 againstCount;
6235     }
6236 
6237     // Struct used in large functions to cut down on variables
6238     struct Users {
6239         // Length of the above list
6240         uint256 usersLength;
6241         // List of addresses, participants of DigixDAO
6242         address[] users;
6243     }
6244 }
6245 
6246 contract DaoRewardsManagerCommon is DaoCommonMini {
6247 
6248     using DaoStructs for DaoStructs.DaoQuarterInfo;
6249 
6250     // this is a struct that store information relevant for calculating the user rewards
6251     // for the last participating quarter
6252     struct UserRewards {
6253         uint256 lastParticipatedQuarter;
6254         uint256 lastQuarterThatRewardsWasUpdated;
6255         uint256 effectiveDGDBalance;
6256         uint256 effectiveModeratorDGDBalance;
6257         DaoStructs.DaoQuarterInfo qInfo;
6258     }
6259 
6260     // struct to store variables needed in the execution of calculateGlobalRewardsBeforeNewQuarter
6261     struct QuarterRewardsInfo {
6262         uint256 previousQuarter;
6263         uint256 totalEffectiveDGDPreviousQuarter;
6264         uint256 totalEffectiveModeratorDGDLastQuarter;
6265         uint256 dgxRewardsPoolLastQuarter;
6266         uint256 userCount;
6267         uint256 i;
6268         DaoStructs.DaoQuarterInfo qInfo;
6269         address currentUser;
6270         address[] users;
6271         bool doneCalculatingEffectiveBalance;
6272         bool doneCalculatingModeratorEffectiveBalance;
6273     }
6274 
6275     // get the struct for the relevant information for calculating a user's DGX rewards for the last participated quarter
6276     function getUserRewardsStruct(address _user)
6277         internal
6278         view
6279         returns (UserRewards memory _data)
6280     {
6281         _data.lastParticipatedQuarter = daoRewardsStorage().lastParticipatedQuarter(_user);
6282         _data.lastQuarterThatRewardsWasUpdated = daoRewardsStorage().lastQuarterThatRewardsWasUpdated(_user);
6283         _data.qInfo = readQuarterInfo(_data.lastParticipatedQuarter);
6284     }
6285 
6286     // read the DaoQuarterInfo struct of a certain quarter
6287     function readQuarterInfo(uint256 _quarterNumber)
6288         internal
6289         view
6290         returns (DaoStructs.DaoQuarterInfo _qInfo)
6291     {
6292         (
6293             _qInfo.minimalParticipationPoint,
6294             _qInfo.quarterPointScalingFactor,
6295             _qInfo.reputationPointScalingFactor,
6296             _qInfo.totalEffectiveDGDPreviousQuarter
6297         ) = daoRewardsStorage().readQuarterParticipantInfo(_quarterNumber);
6298         (
6299             _qInfo.moderatorMinimalParticipationPoint,
6300             _qInfo.moderatorQuarterPointScalingFactor,
6301             _qInfo.moderatorReputationPointScalingFactor,
6302             _qInfo.totalEffectiveModeratorDGDLastQuarter
6303         ) = daoRewardsStorage().readQuarterModeratorInfo(_quarterNumber);
6304         (
6305             _qInfo.dgxDistributionDay,
6306             _qInfo.dgxRewardsPoolLastQuarter,
6307             _qInfo.sumRewardsFromBeginning
6308         ) = daoRewardsStorage().readQuarterGeneralInfo(_quarterNumber);
6309     }
6310 }
6311 
6312 contract DaoRewardsManagerExtras is DaoRewardsManagerCommon {
6313 
6314     constructor(address _resolver) public {
6315         require(init(CONTRACT_DAO_REWARDS_MANAGER_EXTRAS, _resolver));
6316     }
6317 
6318     function daoCalculatorService()
6319         internal
6320         view
6321         returns (DaoCalculatorService _contract)
6322     {
6323         _contract = DaoCalculatorService(get_contract(CONTRACT_SERVICE_DAO_CALCULATOR));
6324     }
6325 
6326     // done
6327     // calculate dgx rewards; This is basically the DGXs that user has earned from participating in lastParticipatedQuarter, and can be withdrawn on the dgxDistributionDay of the (lastParticipatedQuarter + 1)
6328     // when user actually withdraw some time after that, he will be deducted demurrage.
6329     function calculateUserRewardsForLastParticipatingQuarter(address _user)
6330         public
6331         view
6332         returns (uint256 _dgxRewardsAsParticipant, uint256 _dgxRewardsAsModerator)
6333     {
6334         UserRewards memory data = getUserRewardsStruct(_user);
6335 
6336         data.effectiveDGDBalance = daoCalculatorService().calculateUserEffectiveBalance(
6337             data.qInfo.minimalParticipationPoint,
6338             data.qInfo.quarterPointScalingFactor,
6339             data.qInfo.reputationPointScalingFactor,
6340             daoPointsStorage().getQuarterPoint(_user, data.lastParticipatedQuarter),
6341 
6342             // RP has been updated at the beginning of the lastParticipatedQuarter in
6343             // a call to updateRewardsAndReputationBeforeNewQuarter(); It should not have changed since then
6344             daoPointsStorage().getReputation(_user),
6345 
6346             // lockedDGDStake should have stayed the same throughout since the lastParticipatedQuarter
6347             // if this participant has done anything (lock/unlock/continue) to change the lockedDGDStake,
6348             // updateUserRewardsForLastParticipatingQuarter, and hence this function, would have been called first before the lockedDGDStake is changed
6349             daoStakeStorage().lockedDGDStake(_user)
6350         );
6351 
6352         data.effectiveModeratorDGDBalance = daoCalculatorService().calculateUserEffectiveBalance(
6353             data.qInfo.moderatorMinimalParticipationPoint,
6354             data.qInfo.moderatorQuarterPointScalingFactor,
6355             data.qInfo.moderatorReputationPointScalingFactor,
6356             daoPointsStorage().getQuarterModeratorPoint(_user, data.lastParticipatedQuarter),
6357 
6358             // RP has been updated at the beginning of the lastParticipatedQuarter in
6359             // a call to updateRewardsAndReputationBeforeNewQuarter();
6360             daoPointsStorage().getReputation(_user),
6361 
6362             // lockedDGDStake should have stayed the same throughout since the lastParticipatedQuarter
6363             // if this participant has done anything (lock/unlock/continue) to change the lockedDGDStake,
6364             // updateUserRewardsForLastParticipatingQuarter would have been called first before the lockedDGDStake is changed
6365             daoStakeStorage().lockedDGDStake(_user)
6366         );
6367 
6368         // will not need to calculate if the totalEffectiveDGDLastQuarter is 0 (no one participated)
6369         if (daoRewardsStorage().readTotalEffectiveDGDLastQuarter(data.lastParticipatedQuarter.add(1)) > 0) {
6370             _dgxRewardsAsParticipant =
6371                 data.effectiveDGDBalance
6372                 .mul(daoRewardsStorage().readRewardsPoolOfLastQuarter(
6373                     data.lastParticipatedQuarter.add(1)
6374                 ))
6375                 .mul(
6376                     getUintConfig(CONFIG_PORTION_TO_MODERATORS_DEN)
6377                     .sub(getUintConfig(CONFIG_PORTION_TO_MODERATORS_NUM))
6378                 )
6379                 .div(daoRewardsStorage().readTotalEffectiveDGDLastQuarter(
6380                     data.lastParticipatedQuarter.add(1)
6381                 ))
6382                 .div(getUintConfig(CONFIG_PORTION_TO_MODERATORS_DEN));
6383         }
6384 
6385         // will not need to calculate if the totalEffectiveModeratorDGDLastQuarter is 0 (no one participated)
6386         if (daoRewardsStorage().readTotalEffectiveModeratorDGDLastQuarter(data.lastParticipatedQuarter.add(1)) > 0) {
6387             _dgxRewardsAsModerator =
6388                 data.effectiveModeratorDGDBalance
6389                 .mul(daoRewardsStorage().readRewardsPoolOfLastQuarter(
6390                     data.lastParticipatedQuarter.add(1)
6391                 ))
6392                 .mul(
6393                      getUintConfig(CONFIG_PORTION_TO_MODERATORS_NUM)
6394                 )
6395                 .div(daoRewardsStorage().readTotalEffectiveModeratorDGDLastQuarter(
6396                     data.lastParticipatedQuarter.add(1)
6397                 ))
6398                 .div(getUintConfig(CONFIG_PORTION_TO_MODERATORS_DEN));
6399         }
6400     }
6401 }
6402 
6403 /**
6404 @title Contract to manage DGX rewards
6405 @author Digix Holdings
6406 */
6407 contract DaoRewardsManager is DaoRewardsManagerCommon {
6408     using MathHelper for MathHelper;
6409     using DaoStructs for DaoStructs.DaoQuarterInfo;
6410     using DaoStructs for DaoStructs.IntermediateResults;
6411 
6412     // is emitted when calculateGlobalRewardsBeforeNewQuarter has been done in the beginning of the quarter
6413     // after which, all the other DAO activities could happen
6414     event StartNewQuarter(uint256 indexed _quarterNumber);
6415 
6416     address public ADDRESS_DGX_TOKEN;
6417 
6418     function daoCalculatorService()
6419         internal
6420         view
6421         returns (DaoCalculatorService _contract)
6422     {
6423         _contract = DaoCalculatorService(get_contract(CONTRACT_SERVICE_DAO_CALCULATOR));
6424     }
6425 
6426     function daoRewardsManagerExtras()
6427         internal
6428         view
6429         returns (DaoRewardsManagerExtras _contract)
6430     {
6431         _contract = DaoRewardsManagerExtras(get_contract(CONTRACT_DAO_REWARDS_MANAGER_EXTRAS));
6432     }
6433 
6434     /**
6435     @notice Constructor (set the DaoQuarterInfo struct for the first quarter)
6436     @param _resolver Address of the Contract Resolver contract
6437     @param _dgxAddress Address of the Digix Gold Token contract
6438     */
6439     constructor(address _resolver, address _dgxAddress)
6440         public
6441     {
6442         require(init(CONTRACT_DAO_REWARDS_MANAGER, _resolver));
6443         ADDRESS_DGX_TOKEN = _dgxAddress;
6444 
6445         // set the DaoQuarterInfo for the first quarter
6446         daoRewardsStorage().updateQuarterInfo(
6447             1,
6448             getUintConfig(CONFIG_MINIMAL_QUARTER_POINT),
6449             getUintConfig(CONFIG_QUARTER_POINT_SCALING_FACTOR),
6450             getUintConfig(CONFIG_REPUTATION_POINT_SCALING_FACTOR),
6451             0, // totalEffectiveDGDPreviousQuarter, Not Applicable, this value should not be used ever
6452             getUintConfig(CONFIG_MODERATOR_MINIMAL_QUARTER_POINT),
6453             getUintConfig(CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR),
6454             getUintConfig(CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR),
6455             0, // _totalEffectiveModeratorDGDLastQuarter , Not applicable, this value should not be used ever
6456 
6457             // _dgxDistributionDay, Not applicable, there shouldnt be any DGX rewards in the DAO now. The actual DGX fees that have been collected
6458             // before the deployment of DigixDAO contracts would be counted as part of the DGX fees incurred in the first quarter
6459             // this value should not be used ever
6460             now,
6461 
6462             0, // _dgxRewardsPoolLastQuarter, not applicable, this value should not be used ever
6463             0 // sumRewardsFromBeginning, which is 0
6464         );
6465     }
6466 
6467 
6468     /**
6469     @notice Function to transfer the claimableDGXs to the new DaoRewardsManager
6470     @dev This is done during the migrateToNewDao procedure
6471     @param _newDaoRewardsManager Address of the new daoRewardsManager contract
6472     */
6473     function moveDGXsToNewDao(address _newDaoRewardsManager)
6474         public
6475     {
6476         require(sender_is(CONTRACT_DAO));
6477         uint256 _dgxBalance = ERC20(ADDRESS_DGX_TOKEN).balanceOf(address(this));
6478         ERC20(ADDRESS_DGX_TOKEN).transfer(_newDaoRewardsManager, _dgxBalance);
6479     }
6480 
6481 
6482     /**
6483     @notice Function for users to claim the claimable DGX rewards
6484     @dev Will revert if _claimableDGX < MINIMUM_TRANSFER_AMOUNT of DGX.
6485          Can only be called after calculateGlobalRewardsBeforeNewQuarter() has been called in the current quarter
6486          This cannot be called once the current version of Dao contracts have been migrated to newer version
6487     */
6488     function claimRewards()
6489         public
6490         ifGlobalRewardsSet(currentQuarterNumber())
6491     {
6492         require(isDaoNotReplaced());
6493 
6494         address _user = msg.sender;
6495         uint256 _claimableDGX;
6496 
6497         // update rewards for the quarter that he last participated in
6498         (, _claimableDGX) = updateUserRewardsForLastParticipatingQuarter(_user);
6499 
6500         // withdraw from his claimableDGXs
6501         // This has to take into account demurrage
6502         // Basically, the value of claimableDGXs in the contract is for the dgxDistributionDay of (lastParticipatedQuarter + 1)
6503         // if now is after that, we need to deduct demurrage
6504         uint256 _days_elapsed = now
6505             .sub(
6506                 daoRewardsStorage().readDgxDistributionDay(
6507                     daoRewardsStorage().lastQuarterThatRewardsWasUpdated(_user).add(1) // lastQuarterThatRewardsWasUpdated should be the same as lastParticipatedQuarter now
6508                 )
6509             )
6510             .div(1 days);
6511 
6512          // similar logic as in the similar step in updateUserRewardsForLastParticipatingQuarter.
6513          // it is as if the user has withdrawn all _claimableDGX, and the demurrage is paid back into the DAO immediately
6514         daoRewardsStorage().addToTotalDgxClaimed(_claimableDGX);
6515 
6516         _claimableDGX = _claimableDGX.sub(
6517             daoCalculatorService().calculateDemurrage(
6518                 _claimableDGX,
6519                 _days_elapsed
6520             ));
6521 
6522         daoRewardsStorage().updateClaimableDGX(_user, 0);
6523         ERC20(ADDRESS_DGX_TOKEN).transfer(_user, _claimableDGX);
6524         // the _demurrageFees is implicitly "transfered" back into the DAO, and would be counted in the dgxRewardsPool of this quarter (in other words, dgxRewardsPoolLastQuarter of next quarter)
6525     }
6526 
6527 
6528     /**
6529     @notice Function to update DGX rewards of user. This is only called during locking/withdrawing DGDs, or continuing participation for new quarter
6530     @param _user Address of the DAO participant
6531     */
6532     function updateRewardsAndReputationBeforeNewQuarter(address _user)
6533         public
6534     {
6535         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
6536 
6537         updateUserRewardsForLastParticipatingQuarter(_user);
6538         updateUserReputationUntilPreviousQuarter(_user);
6539     }
6540 
6541 
6542     // This function would ALWAYS make sure that the user's Reputation Point is updated for ALL activities that has happened
6543     // BEFORE this current quarter. These activities include:
6544     //  - Reputation bonus/penalty due to participation in all of the previous quarters
6545     //  - Reputation penalty for not participating for a few quarters, up until and including the previous quarter
6546     //  - Badges redemption and carbon vote reputation redemption (that happens in the first time locking)
6547     // As such, after this function is called on quarter N, the updated reputation point of the user would tentatively be used to calculate the rewards for quarter N
6548     // Its tentative because the user can also redeem a badge during the period of quarter N to add to his reputation point.
6549     function updateUserReputationUntilPreviousQuarter (address _user)
6550         private
6551     {
6552         uint256 _lastParticipatedQuarter = daoRewardsStorage().lastParticipatedQuarter(_user);
6553         uint256 _lastQuarterThatReputationWasUpdated = daoRewardsStorage().lastQuarterThatReputationWasUpdated(_user);
6554         uint256 _reputationDeduction;
6555 
6556         // If the reputation was already updated until the previous quarter
6557         // nothing needs to be done
6558         if (
6559             _lastQuarterThatReputationWasUpdated.add(1) >= currentQuarterNumber()
6560         ) {
6561             return;
6562         }
6563 
6564         // first, we calculate and update the reputation change due to the user's governance activities in lastParticipatedQuarter, if it is not already updated.
6565         // reputation is not updated for lastParticipatedQuarter yet is equivalent to _lastQuarterThatReputationWasUpdated == _lastParticipatedQuarter - 1
6566         if (
6567             (_lastQuarterThatReputationWasUpdated.add(1) == _lastParticipatedQuarter)
6568         ) {
6569             updateRPfromQP(
6570                 _user,
6571                 daoPointsStorage().getQuarterPoint(_user, _lastParticipatedQuarter),
6572                 getUintConfig(CONFIG_MINIMAL_QUARTER_POINT),
6573                 getUintConfig(CONFIG_MAXIMUM_REPUTATION_DEDUCTION),
6574                 getUintConfig(CONFIG_REPUTATION_PER_EXTRA_QP_NUM),
6575                 getUintConfig(CONFIG_REPUTATION_PER_EXTRA_QP_DEN)
6576             );
6577 
6578             // this user is not a Moderator for current quarter
6579             // coz this step is done before updating the refreshModerator.
6580             // But may have been a Moderator before, and if was moderator in their
6581             // lastParticipatedQuarter, we will find them in the DoublyLinkedList.
6582             if (daoStakeStorage().isInModeratorsList(_user)) {
6583                 updateRPfromQP(
6584                     _user,
6585                     daoPointsStorage().getQuarterModeratorPoint(_user, _lastParticipatedQuarter),
6586                     getUintConfig(CONFIG_MODERATOR_MINIMAL_QUARTER_POINT),
6587                     getUintConfig(CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION),
6588                     getUintConfig(CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM),
6589                     getUintConfig(CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN)
6590                 );
6591             }
6592             _lastQuarterThatReputationWasUpdated = _lastParticipatedQuarter;
6593         }
6594 
6595         // at this point, the _lastQuarterThatReputationWasUpdated MUST be at least the _lastParticipatedQuarter already
6596         // Hence, any quarters between the _lastQuarterThatReputationWasUpdated and now must be a non-participating quarter,
6597         // and this participant should be penalized for those.
6598 
6599         // If this is their first ever participation, It is fine as well, as the reputation would be still be 0 after this step.
6600         // note that the carbon vote's reputation bonus will be added after this, so its fine
6601 
6602         _reputationDeduction =
6603             (currentQuarterNumber().sub(1).sub(_lastQuarterThatReputationWasUpdated))
6604             .mul(
6605                 getUintConfig(CONFIG_MAXIMUM_REPUTATION_DEDUCTION)
6606                 .add(getUintConfig(CONFIG_PUNISHMENT_FOR_NOT_LOCKING))
6607             );
6608 
6609         if (_reputationDeduction > 0) daoPointsStorage().reduceReputation(_user, _reputationDeduction);
6610         daoRewardsStorage().updateLastQuarterThatReputationWasUpdated(_user, currentQuarterNumber().sub(1));
6611     }
6612 
6613 
6614     // update ReputationPoint of a participant based on QuarterPoint/ModeratorQuarterPoint in a quarter
6615     function updateRPfromQP (
6616         address _user,
6617         uint256 _userQP,
6618         uint256 _minimalQP,
6619         uint256 _maxRPDeduction,
6620         uint256 _rpPerExtraQP_num,
6621         uint256 _rpPerExtraQP_den
6622     ) internal {
6623         uint256 _reputationDeduction;
6624         uint256 _reputationAddition;
6625         if (_userQP < _minimalQP) {
6626             _reputationDeduction =
6627                 _minimalQP.sub(_userQP)
6628                 .mul(_maxRPDeduction)
6629                 .div(_minimalQP);
6630 
6631             daoPointsStorage().reduceReputation(_user, _reputationDeduction);
6632         } else {
6633             _reputationAddition =
6634                 _userQP.sub(_minimalQP)
6635                 .mul(_rpPerExtraQP_num)
6636                 .div(_rpPerExtraQP_den);
6637 
6638             daoPointsStorage().increaseReputation(_user, _reputationAddition);
6639         }
6640     }
6641 
6642     // if the DGX rewards has not been calculated for the user's lastParticipatedQuarter, calculate and update it
6643     function updateUserRewardsForLastParticipatingQuarter(address _user)
6644         internal
6645         returns (bool _valid, uint256 _userClaimableDgx)
6646     {
6647         UserRewards memory data = getUserRewardsStruct(_user);
6648         _userClaimableDgx = daoRewardsStorage().claimableDGXs(_user);
6649 
6650         // There is nothing to do if:
6651         //   - The participant is already participating this quarter and hence this function has been called in this quarter
6652         //   - We have updated the rewards to the lastParticipatedQuarter
6653         // In ANY other cases: it means that the lastParticipatedQuarter is NOT this quarter, and its greater than lastQuarterThatRewardsWasUpdated, hence
6654         // This also means that this participant has ALREADY PARTICIPATED at least once IN THE PAST, and we have not calculated for this quarter
6655         // Thus, we need to calculate the Rewards for the lastParticipatedQuarter
6656         if (
6657             (currentQuarterNumber() == data.lastParticipatedQuarter) ||
6658             (data.lastParticipatedQuarter <= data.lastQuarterThatRewardsWasUpdated)
6659         ) {
6660             return (false, _userClaimableDgx);
6661         }
6662 
6663         // now we will calculate the user rewards based on info of the data.lastParticipatedQuarter
6664 
6665         // first we "deduct the demurrage" for the existing claimable DGXs for time period from
6666         // dgxDistributionDay of (lastQuarterThatRewardsWasUpdated + 1) to dgxDistributionDay of (lastParticipatedQuarter + 1)
6667         // (note that, when people participate in quarter n, the DGX rewards for quarter n is only released at the dgxDistributionDay of (n+1)th quarter)
6668         uint256 _days_elapsed = daoRewardsStorage().readDgxDistributionDay(data.lastParticipatedQuarter.add(1))
6669             .sub(daoRewardsStorage().readDgxDistributionDay(data.lastQuarterThatRewardsWasUpdated.add(1)))
6670             .div(1 days);
6671         uint256 _demurrageFees = daoCalculatorService().calculateDemurrage(
6672             _userClaimableDgx,
6673             _days_elapsed
6674         );
6675         _userClaimableDgx = _userClaimableDgx.sub(_demurrageFees);
6676         // this demurrage fees will not be accurate to the hours, but we will leave it as this.
6677 
6678         // this deducted demurrage is then added to the totalDGXsClaimed
6679         // This is as if, the user claims exactly _demurrageFees DGXs, which would be used immediately to pay for the demurrage on his claimableDGXs,
6680         // from dgxDistributionDay of (lastQuarterThatRewardsWasUpdated + 1) to dgxDistributionDay of (lastParticipatedQuarter + 1)
6681         // This is done as such, so that this _demurrageFees would "flow back into the DAO" and be counted in the dgxRewardsPool of this current quarter (in other words, dgxRewardsPoolLastQuarter of the next quarter, as will be calculated in calculateGlobalRewardsBeforeNewQuarter of the next quarter)
6682         // this is not 100% techinally correct as a demurrage concept, because this demurrage fees could have been incurred for the duration of the quarters in the past, but we will account them this way, as if its demurrage fees for this quarter, for simplicity.
6683         daoRewardsStorage().addToTotalDgxClaimed(_demurrageFees);
6684 
6685         uint256 _dgxRewardsAsParticipant;
6686         uint256 _dgxRewardsAsModerator;
6687         (_dgxRewardsAsParticipant, _dgxRewardsAsModerator) = daoRewardsManagerExtras().calculateUserRewardsForLastParticipatingQuarter(_user);
6688         _userClaimableDgx = _userClaimableDgx.add(_dgxRewardsAsParticipant).add(_dgxRewardsAsModerator);
6689 
6690         // update claimableDGXs. The calculation just now should have taken into account demurrage
6691         // such that the demurrage has been paid until dgxDistributionDay of (lastParticipatedQuarter + 1)
6692         daoRewardsStorage().updateClaimableDGX(_user, _userClaimableDgx);
6693 
6694         // update lastQuarterThatRewardsWasUpdated
6695         daoRewardsStorage().updateLastQuarterThatRewardsWasUpdated(_user, data.lastParticipatedQuarter);
6696         _valid = true;
6697     }
6698 
6699     /**
6700     @notice Function called by the founder after transfering the DGX fees into the DAO at the beginning of the quarter
6701     @dev This function needs to do lots of calculation, so it might not fit into one transaction
6702          As such, it could be done in multiple transactions, each time passing _operations which is the number of operations we want to calculate.
6703          When the value of _done is finally true, that's when the calculation is done.
6704          Only after this function runs, any other activities in the DAO could happen.
6705 
6706          Basically, if there were M participants and N moderators in the previous quarter, it takes M+N "operations".
6707 
6708          In summary, the function populates the DaoQuarterInfo of this quarter.
6709          The bulk of the calculation is to go through every participant in the previous quarter to calculate their effectiveDGDBalance and sum them to get the
6710          totalEffectiveDGDLastQuarter
6711     */
6712     function calculateGlobalRewardsBeforeNewQuarter(uint256 _operations)
6713         public
6714         if_founder()
6715         returns (bool _done)
6716     {
6717         require(isDaoNotReplaced());
6718         require(daoUpgradeStorage().startOfFirstQuarter() != 0); // start of first quarter must have been set already
6719         require(isLockingPhase());
6720         require(daoRewardsStorage().readDgxDistributionDay(currentQuarterNumber()) == 0); // throw if this function has already finished running this quarter
6721 
6722         QuarterRewardsInfo memory info;
6723         info.previousQuarter = currentQuarterNumber().sub(1);
6724         require(info.previousQuarter > 0); // throw if this is the first quarter
6725         info.qInfo = readQuarterInfo(info.previousQuarter);
6726 
6727         DaoStructs.IntermediateResults memory interResults;
6728         (
6729             interResults.countedUntil,,,
6730             info.totalEffectiveDGDPreviousQuarter
6731         ) = intermediateResultsStorage().getIntermediateResults(
6732             getIntermediateResultsIdForGlobalRewards(info.previousQuarter, false)
6733         );
6734 
6735         uint256 _operationsLeft = sumEffectiveBalance(info, false, _operations, interResults);
6736         // now we are left with _operationsLeft operations
6737         // the results is saved in interResults
6738 
6739         // if we have not done with calculating the effective balance, quit.
6740         if (!info.doneCalculatingEffectiveBalance) { return false; }
6741 
6742         (
6743             interResults.countedUntil,,,
6744             info.totalEffectiveModeratorDGDLastQuarter
6745         ) = intermediateResultsStorage().getIntermediateResults(
6746             getIntermediateResultsIdForGlobalRewards(info.previousQuarter, true)
6747         );
6748 
6749         sumEffectiveBalance(info, true, _operationsLeft, interResults);
6750 
6751         // if we have not done with calculating the moderator effective balance, quit.
6752         if (!info.doneCalculatingModeratorEffectiveBalance) { return false; }
6753 
6754         // we have done the heavey calculation, now save the quarter info
6755         processGlobalRewardsUpdate(info);
6756         _done = true;
6757 
6758         emit StartNewQuarter(currentQuarterNumber());
6759     }
6760 
6761 
6762     // get the Id for the intermediateResult for a quarter's global rewards calculation
6763     function getIntermediateResultsIdForGlobalRewards(uint256 _quarterNumber, bool _forModerator) internal view returns (bytes32 _id) {
6764         _id = keccak256(abi.encodePacked(
6765             _forModerator ? INTERMEDIATE_MODERATOR_DGD_IDENTIFIER : INTERMEDIATE_DGD_IDENTIFIER,
6766             _quarterNumber
6767         ));
6768     }
6769 
6770 
6771     // final step in calculateGlobalRewardsBeforeNewQuarter, which is to save the DaoQuarterInfo struct for this quarter
6772     function processGlobalRewardsUpdate(QuarterRewardsInfo memory info) internal {
6773         // calculate how much DGX rewards we got for this quarter
6774         info.dgxRewardsPoolLastQuarter =
6775             ERC20(ADDRESS_DGX_TOKEN).balanceOf(address(this))
6776             .add(daoRewardsStorage().totalDGXsClaimed())
6777             .sub(info.qInfo.sumRewardsFromBeginning);
6778 
6779         // starting new quarter, no one locked in DGDs yet
6780         daoStakeStorage().updateTotalLockedDGDStake(0);
6781         daoStakeStorage().updateTotalModeratorLockedDGDs(0);
6782 
6783         daoRewardsStorage().updateQuarterInfo(
6784             info.previousQuarter.add(1),
6785             getUintConfig(CONFIG_MINIMAL_QUARTER_POINT),
6786             getUintConfig(CONFIG_QUARTER_POINT_SCALING_FACTOR),
6787             getUintConfig(CONFIG_REPUTATION_POINT_SCALING_FACTOR),
6788             info.totalEffectiveDGDPreviousQuarter,
6789 
6790             getUintConfig(CONFIG_MODERATOR_MINIMAL_QUARTER_POINT),
6791             getUintConfig(CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR),
6792             getUintConfig(CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR),
6793             info.totalEffectiveModeratorDGDLastQuarter,
6794 
6795             now,
6796             info.dgxRewardsPoolLastQuarter,
6797             info.qInfo.sumRewardsFromBeginning.add(info.dgxRewardsPoolLastQuarter)
6798         );
6799     }
6800 
6801 
6802     // Sum the effective balance (could be effectiveDGDBalance or effectiveModeratorDGDBalance), given that we have _operations left
6803     function sumEffectiveBalance (
6804         QuarterRewardsInfo memory info,
6805         bool _badgeCalculation, // false if this is the first step, true if its the second step
6806         uint256 _operations,
6807         DaoStructs.IntermediateResults memory _interResults
6808     )
6809         internal
6810         returns (uint _operationsLeft)
6811     {
6812         if (_operations == 0) return _operations; // no more operations left, quit
6813 
6814         if (_interResults.countedUntil == EMPTY_ADDRESS) {
6815             // if this is the first time we are doing this calculation, we need to
6816             // get the list of the participants to calculate by querying the first _operations participants
6817             info.users = _badgeCalculation ?
6818                 daoListingService().listModerators(_operations, true)
6819                 : daoListingService().listParticipants(_operations, true);
6820         } else {
6821             info.users = _badgeCalculation ?
6822                 daoListingService().listModeratorsFrom(_interResults.countedUntil, _operations, true)
6823                 : daoListingService().listParticipantsFrom(_interResults.countedUntil, _operations, true);
6824 
6825             // if this list is the already empty, it means this is the first step (calculating effective balance), and its already done;
6826             if (info.users.length == 0) {
6827                 info.doneCalculatingEffectiveBalance = true;
6828                 return _operations;
6829             }
6830         }
6831 
6832         address _lastAddress;
6833         _lastAddress = info.users[info.users.length - 1];
6834 
6835         info.userCount = info.users.length;
6836         for (info.i=0;info.i<info.userCount;info.i++) {
6837             info.currentUser = info.users[info.i];
6838             // check if this participant really did participate in the previous quarter
6839             if (daoRewardsStorage().lastParticipatedQuarter(info.currentUser) != info.previousQuarter) {
6840                 continue;
6841             }
6842             if (_badgeCalculation) {
6843                 info.totalEffectiveModeratorDGDLastQuarter = info.totalEffectiveModeratorDGDLastQuarter.add(daoCalculatorService().calculateUserEffectiveBalance(
6844                     info.qInfo.moderatorMinimalParticipationPoint,
6845                     info.qInfo.moderatorQuarterPointScalingFactor,
6846                     info.qInfo.moderatorReputationPointScalingFactor,
6847                     daoPointsStorage().getQuarterModeratorPoint(info.currentUser, info.previousQuarter),
6848                     daoPointsStorage().getReputation(info.currentUser),
6849                     daoStakeStorage().lockedDGDStake(info.currentUser)
6850                 ));
6851             } else {
6852                 info.totalEffectiveDGDPreviousQuarter = info.totalEffectiveDGDPreviousQuarter.add(daoCalculatorService().calculateUserEffectiveBalance(
6853                     info.qInfo.minimalParticipationPoint,
6854                     info.qInfo.quarterPointScalingFactor,
6855                     info.qInfo.reputationPointScalingFactor,
6856                     daoPointsStorage().getQuarterPoint(info.currentUser, info.previousQuarter),
6857                     daoPointsStorage().getReputation(info.currentUser),
6858                     daoStakeStorage().lockedDGDStake(info.currentUser)
6859                 ));
6860             }
6861         }
6862 
6863         // check if we have reached the last guy in the current list
6864         if (_lastAddress == daoStakeStorage().readLastModerator() && _badgeCalculation) {
6865             info.doneCalculatingModeratorEffectiveBalance = true;
6866         }
6867         if (_lastAddress == daoStakeStorage().readLastParticipant() && !_badgeCalculation) {
6868             info.doneCalculatingEffectiveBalance = true;
6869         }
6870         // save to the intermediateResult storage
6871         intermediateResultsStorage().setIntermediateResults(
6872             getIntermediateResultsIdForGlobalRewards(info.previousQuarter, _badgeCalculation),
6873             _lastAddress,
6874             0,0,
6875             _badgeCalculation ? info.totalEffectiveModeratorDGDLastQuarter : info.totalEffectiveDGDPreviousQuarter
6876         );
6877 
6878         _operationsLeft = _operations.sub(info.userCount);
6879     }
6880 }
6881 
6882 /**
6883 @title Contract to claim voting results
6884 @author Digix Holdings
6885 */
6886 contract DaoVotingClaims is DaoCommon {
6887     using DaoIntermediateStructs for DaoIntermediateStructs.VotingCount;
6888     using DaoIntermediateStructs for DaoIntermediateStructs.Users;
6889     using DaoStructs for DaoStructs.IntermediateResults;
6890 
6891     function daoCalculatorService()
6892         internal
6893         view
6894         returns (DaoCalculatorService _contract)
6895     {
6896         _contract = DaoCalculatorService(get_contract(CONTRACT_SERVICE_DAO_CALCULATOR));
6897     }
6898 
6899     function daoFundingManager()
6900         internal
6901         view
6902         returns (DaoFundingManager _contract)
6903     {
6904         _contract = DaoFundingManager(get_contract(CONTRACT_DAO_FUNDING_MANAGER));
6905     }
6906 
6907     function daoRewardsManager()
6908         internal
6909         view
6910         returns (DaoRewardsManager _contract)
6911     {
6912         _contract = DaoRewardsManager(get_contract(CONTRACT_DAO_REWARDS_MANAGER));
6913     }
6914 
6915     constructor(address _resolver) public {
6916         require(init(CONTRACT_DAO_VOTING_CLAIMS, _resolver));
6917     }
6918 
6919 
6920     /**
6921     @notice Function to claim the draft voting result (can only be called by the proposal proposer)
6922     @dev The founder/or anyone is supposed to call this function after the claiming deadline has passed, to clean it up and close this proposal.
6923          If this voting fails, the collateral will be refunded
6924     @param _proposalId ID of the proposal
6925     @param _operations Number of operations to do in this call
6926     @return {
6927       "_passed": "Boolean, true if the draft voting has passed, false if the claiming deadline has passed or the voting has failed",
6928       "_done": "Boolean, true if the calculation has finished"
6929     }
6930     */
6931     function claimDraftVotingResult(
6932         bytes32 _proposalId,
6933         uint256 _operations
6934     )
6935         public
6936         ifDraftNotClaimed(_proposalId)
6937         ifAfterDraftVotingPhase(_proposalId)
6938         returns (bool _passed, bool _done)
6939     {
6940         // if after the claiming deadline, or the limit for non-digix proposals is reached, its auto failed
6941         if (now > daoStorage().readProposalDraftVotingTime(_proposalId)
6942                     .add(getUintConfig(CONFIG_DRAFT_VOTING_PHASE))
6943                     .add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE))
6944             || !isNonDigixProposalsWithinLimit(_proposalId))
6945         {
6946             daoStorage().setProposalDraftPass(_proposalId, false);
6947             daoStorage().setDraftVotingClaim(_proposalId, true);
6948             processCollateralRefund(_proposalId);
6949             return (false, true);
6950         }
6951         require(isFromProposer(_proposalId));
6952         senderCanDoProposerOperations();
6953 
6954         // get the previously stored intermediary state
6955         DaoStructs.IntermediateResults memory _currentResults;
6956         (
6957             _currentResults.countedUntil,
6958             _currentResults.currentForCount,
6959             _currentResults.currentAgainstCount,
6960         ) = intermediateResultsStorage().getIntermediateResults(_proposalId);
6961 
6962         // get the moderators to calculate in this transaction, based on intermediate state
6963         address[] memory _moderators;
6964         if (_currentResults.countedUntil == EMPTY_ADDRESS) {
6965             _moderators = daoListingService().listModerators(
6966                 _operations,
6967                 true
6968             );
6969         } else {
6970             _moderators = daoListingService().listModeratorsFrom(
6971                _currentResults.countedUntil,
6972                _operations,
6973                true
6974            );
6975         }
6976 
6977         // count the votes for this batch of moderators
6978         DaoIntermediateStructs.VotingCount memory _voteCount;
6979         (_voteCount.forCount, _voteCount.againstCount) = daoStorage().readDraftVotingCount(_proposalId, _moderators);
6980 
6981         _currentResults.countedUntil = _moderators[_moderators.length-1];
6982         _currentResults.currentForCount = _currentResults.currentForCount.add(_voteCount.forCount);
6983         _currentResults.currentAgainstCount = _currentResults.currentAgainstCount.add(_voteCount.againstCount);
6984 
6985         if (_moderators[_moderators.length-1] == daoStakeStorage().readLastModerator()) {
6986             // this is the last iteration
6987             _passed = processDraftVotingClaim(_proposalId, _currentResults);
6988             _done = true;
6989 
6990             // reset intermediate result for the proposal.
6991             intermediateResultsStorage().resetIntermediateResults(_proposalId);
6992         } else {
6993             // update intermediate results
6994             intermediateResultsStorage().setIntermediateResults(
6995                 _proposalId,
6996                 _currentResults.countedUntil,
6997                 _currentResults.currentForCount,
6998                 _currentResults.currentAgainstCount,
6999                 0
7000             );
7001         }
7002     }
7003 
7004 
7005     function processDraftVotingClaim(bytes32 _proposalId, DaoStructs.IntermediateResults _currentResults)
7006         internal
7007         returns (bool _passed)
7008     {
7009         if (
7010             (_currentResults.currentForCount.add(_currentResults.currentAgainstCount) > daoCalculatorService().minimumDraftQuorum(_proposalId)) &&
7011             (daoCalculatorService().draftQuotaPass(_currentResults.currentForCount, _currentResults.currentAgainstCount))
7012         ) {
7013             daoStorage().setProposalDraftPass(_proposalId, true);
7014 
7015             // set startTime of first voting round
7016             // and the start of first milestone.
7017             uint256 _idealStartTime = daoStorage().readProposalDraftVotingTime(_proposalId).add(getUintConfig(CONFIG_DRAFT_VOTING_PHASE));
7018             daoStorage().setProposalVotingTime(
7019                 _proposalId,
7020                 0,
7021                 getTimelineForNextVote(0, _idealStartTime)
7022             );
7023             _passed = true;
7024         } else {
7025             daoStorage().setProposalDraftPass(_proposalId, false);
7026             processCollateralRefund(_proposalId);
7027         }
7028 
7029         daoStorage().setDraftVotingClaim(_proposalId, true);
7030     }
7031 
7032     /// NOTE: Voting round i-th is before milestone index i-th
7033 
7034 
7035     /**
7036     @notice Function to claim the  voting round results
7037     @dev This function has two major steps:
7038          - Counting the votes
7039             + There is no need for this step if there are some conditions that makes the proposal auto failed
7040             + The number of operations needed for this step is the number of participants in the quarter
7041          - Calculating the bonus for the voters in the preceding round
7042             + We can skip this step if this is the Voting round 0 (there is no preceding voting round to calculate bonus)
7043             + The number of operations needed for this step is the number of participants who voted "correctly" in the preceding voting round
7044          Step 1 will have to finish first before step 2. The proposer is supposed to call this function repeatedly,
7045          until _done is true
7046 
7047          If the voting round fails, the collateral will be returned back to the proposer
7048     @param _proposalId ID of the proposal
7049     @param _index Index of the  voting round
7050     @param _operations Number of operations to do in this call
7051     @return {
7052       "_passed": "Boolean, true if the  voting round passed, false if failed"
7053     }
7054     */
7055     function claimProposalVotingResult(bytes32 _proposalId, uint256 _index, uint256 _operations)
7056         public
7057         ifNotClaimed(_proposalId, _index)
7058         ifAfterProposalRevealPhase(_proposalId, _index)
7059         returns (bool _passed, bool _done)
7060     {
7061         require(isMainPhase());
7062 
7063         // STEP 1
7064         // If the claiming deadline is over, the proposal is auto failed, and anyone can call this function
7065         // Here, _done is refering to whether STEP 1 is done
7066         _done = true;
7067         _passed = false; // redundant, put here just to emphasize that its false
7068         uint256 _operationsLeft = _operations;
7069         // In other words, we only need to do Step 1 if its before the deadline
7070         if (now < startOfMilestone(_proposalId, _index)
7071                     .add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE)))
7072         {
7073             (_operationsLeft, _passed, _done) = countProposalVote(_proposalId, _index, _operations);
7074             // from here on, _operationsLeft is the number of operations left, after Step 1 is done
7075             if (!_done) return (_passed, false); // haven't done Step 1 yet, return. The value of _passed here is irrelevant
7076         }
7077 
7078         // STEP 2
7079         // from this point onwards, _done refers to step 2
7080         _done = false;
7081 
7082         if (_index > 0) { // We only need to do bonus calculation if its a interim voting round
7083             _done = calculateVoterBonus(_proposalId, _index, _operationsLeft, _passed);
7084             if (!_done) return (_passed, false); // Step 2 is not done yet, return
7085         } else {
7086             // its the first voting round, we return the collateral if it fails, locks if it passes
7087 
7088             _passed = _passed && isNonDigixProposalsWithinLimit(_proposalId); // can only pass if its within the non-digix proposal limit
7089             if (_passed) {
7090                 daoStorage().setProposalCollateralStatus(
7091                     _proposalId,
7092                     COLLATERAL_STATUS_LOCKED
7093                 );
7094 
7095             } else {
7096                 processCollateralRefund(_proposalId);
7097             }
7098         }
7099 
7100         if (_passed) {
7101             processSuccessfulVotingClaim(_proposalId, _index);
7102         }
7103         daoStorage().setVotingClaim(_proposalId, _index, true);
7104         daoStorage().setProposalPass(_proposalId, _index, _passed);
7105         _done = true;
7106     }
7107 
7108 
7109     // do the necessary steps after a successful voting round.
7110     function processSuccessfulVotingClaim(bytes32 _proposalId, uint256 _index)
7111         internal
7112     {
7113         // clear the intermediate results for the proposal, so that next voting rounds can reuse the same key <proposal_id> for the intermediate results
7114         intermediateResultsStorage().resetIntermediateResults(_proposalId);
7115 
7116         // if this was the final voting round, unlock their original collateral
7117         uint256[] memory _milestoneFundings;
7118         (_milestoneFundings,) = daoStorage().readProposalFunding(_proposalId);
7119         if (_index == _milestoneFundings.length) {
7120             processCollateralRefund(_proposalId);
7121             daoStorage().archiveProposal(_proposalId);
7122         }
7123 
7124         // increase the non-digix proposal count accordingly
7125         bool _isDigixProposal;
7126         (,,,,,,,,,_isDigixProposal) = daoStorage().readProposal(_proposalId);
7127         if (_index == 0 && !_isDigixProposal) {
7128             daoProposalCounterStorage().addNonDigixProposalCountInQuarter(currentQuarterNumber());
7129         }
7130 
7131         // Add quarter point for the proposer
7132         uint256 _funding = daoStorage().readProposalMilestone(_proposalId, _index);
7133         daoPointsStorage().addQuarterPoint(
7134             daoStorage().readProposalProposer(_proposalId),
7135             getUintConfig(CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH).mul(_funding).div(10000 ether),
7136             currentQuarterNumber()
7137         );
7138     }
7139 
7140 
7141     function getInterResultKeyForBonusCalculation(bytes32 _proposalId) public view returns (bytes32 _key) {
7142         _key = keccak256(abi.encodePacked(
7143             _proposalId,
7144             INTERMEDIATE_BONUS_CALCULATION_IDENTIFIER
7145         ));
7146     }
7147 
7148 
7149     // calculate and update the bonuses for voters who voted "correctly" in the preceding voting round
7150     function calculateVoterBonus(bytes32 _proposalId, uint256 _index, uint256 _operations, bool _passed)
7151         internal
7152         returns (bool _done)
7153     {
7154         if (_operations == 0) return false;
7155         address _countedUntil;
7156         (_countedUntil,,,) = intermediateResultsStorage().getIntermediateResults(
7157             getInterResultKeyForBonusCalculation(_proposalId)
7158         );
7159 
7160         address[] memory _voterBatch;
7161         if (_countedUntil == EMPTY_ADDRESS) {
7162             _voterBatch = daoListingService().listParticipants(
7163                 _operations,
7164                 true
7165             );
7166         } else {
7167             _voterBatch = daoListingService().listParticipantsFrom(
7168                 _countedUntil,
7169                 _operations,
7170                 true
7171             );
7172         }
7173         address _lastVoter = _voterBatch[_voterBatch.length - 1]; // this will fail if _voterBatch is empty. However, there is at least the proposer as a participant in the quarter.
7174 
7175         DaoIntermediateStructs.Users memory _bonusVoters;
7176         if (_passed) {
7177 
7178             // give bonus points for all those who
7179             // voted YES in the previous round
7180             (_bonusVoters.users, _bonusVoters.usersLength) = daoStorage().readVotingRoundVotes(_proposalId, _index.sub(1), _voterBatch, true);
7181         } else {
7182             // give bonus points for all those who
7183             // voted NO in the previous round
7184             (_bonusVoters.users, _bonusVoters.usersLength) = daoStorage().readVotingRoundVotes(_proposalId, _index.sub(1), _voterBatch, false);
7185         }
7186 
7187         if (_bonusVoters.usersLength > 0) addBonusReputation(_bonusVoters.users, _bonusVoters.usersLength);
7188 
7189         if (_lastVoter == daoStakeStorage().readLastParticipant()) {
7190             // this is the last iteration
7191 
7192             intermediateResultsStorage().resetIntermediateResults(
7193                 getInterResultKeyForBonusCalculation(_proposalId)
7194             );
7195             _done = true;
7196         } else {
7197             // this is not the last iteration yet, save the intermediate results
7198             intermediateResultsStorage().setIntermediateResults(
7199                 getInterResultKeyForBonusCalculation(_proposalId),
7200                 _lastVoter, 0, 0, 0
7201             );
7202         }
7203     }
7204 
7205 
7206     // Count the votes for a Voting Round and find out if its passed
7207     /// @return _operationsLeft The number of operations left after the calculations in this function
7208     /// @return _passed Whether this voting round passed
7209     /// @return _done Whether the calculation for this step 1 is already done. If its not done, this function will need to run again in subsequent transactions
7210     /// until _done is true
7211     function countProposalVote(bytes32 _proposalId, uint256 _index, uint256 _operations)
7212         internal
7213         returns (uint256 _operationsLeft, bool _passed, bool _done)
7214     {
7215         senderCanDoProposerOperations();
7216         require(isFromProposer(_proposalId));
7217 
7218         DaoStructs.IntermediateResults memory _currentResults;
7219         (
7220             _currentResults.countedUntil,
7221             _currentResults.currentForCount,
7222             _currentResults.currentAgainstCount,
7223         ) = intermediateResultsStorage().getIntermediateResults(_proposalId);
7224         address[] memory _voters;
7225         if (_currentResults.countedUntil == EMPTY_ADDRESS) { // This is the first transaction to count votes for this voting round
7226             _voters = daoListingService().listParticipants(
7227                 _operations,
7228                 true
7229             );
7230         } else {
7231             _voters = daoListingService().listParticipantsFrom(
7232                 _currentResults.countedUntil,
7233                 _operations,
7234                 true
7235             );
7236 
7237             // If there's no voters left to count, this means that STEP 1 is already done, just return whether it was passed
7238             // Note that _currentResults should already be storing the final tally of votes for this voting round, as already calculated in previous iterations of this function
7239             if (_voters.length == 0) {
7240                 return (
7241                     _operations,
7242                     isVoteCountPassed(_currentResults, _proposalId, _index),
7243                     true
7244                 );
7245             }
7246         }
7247 
7248         address _lastVoter = _voters[_voters.length - 1];
7249 
7250         DaoIntermediateStructs.VotingCount memory _count;
7251         (_count.forCount, _count.againstCount) = daoStorage().readVotingCount(_proposalId, _index, _voters);
7252 
7253         _currentResults.currentForCount = _currentResults.currentForCount.add(_count.forCount);
7254         _currentResults.currentAgainstCount = _currentResults.currentAgainstCount.add(_count.againstCount);
7255         intermediateResultsStorage().setIntermediateResults(
7256             _proposalId,
7257             _lastVoter,
7258             _currentResults.currentForCount,
7259             _currentResults.currentAgainstCount,
7260             0
7261         );
7262 
7263         if (_lastVoter != daoStakeStorage().readLastParticipant()) {
7264             return (0, false, false); // hasn't done STEP 1 yet. The parent function (claimProposalVotingResult) should return after this. More transactions are needed to continue the calculation
7265         }
7266 
7267         // If it comes to here, this means all votes have already been counted
7268         // From this point, the IntermediateResults struct will store the total tally of the votes for this voting round until processSuccessfulVotingClaim() is called,
7269         // which will reset it.
7270 
7271         _operationsLeft = _operations.sub(_voters.length);
7272         _done = true;
7273 
7274         _passed = isVoteCountPassed(_currentResults, _proposalId, _index);
7275     }
7276 
7277 
7278     function isVoteCountPassed(DaoStructs.IntermediateResults _currentResults, bytes32 _proposalId, uint256 _index)
7279         internal
7280         view
7281         returns (bool _passed)
7282     {
7283         _passed = (_currentResults.currentForCount.add(_currentResults.currentAgainstCount) > daoCalculatorService().minimumVotingQuorum(_proposalId, _index))
7284                 && (daoCalculatorService().votingQuotaPass(_currentResults.currentForCount, _currentResults.currentAgainstCount));
7285     }
7286 
7287 
7288     function processCollateralRefund(bytes32 _proposalId)
7289         internal
7290     {
7291         daoStorage().setProposalCollateralStatus(_proposalId, COLLATERAL_STATUS_CLAIMED);
7292         require(daoFundingManager().refundCollateral(daoStorage().readProposalProposer(_proposalId), _proposalId));
7293     }
7294 
7295 
7296     // add bonus reputation for voters that voted "correctly" in the preceding voting round AND is currently participating this quarter
7297     function addBonusReputation(address[] _voters, uint256 _n)
7298         private
7299     {
7300         uint256 _qp = getUintConfig(CONFIG_QUARTER_POINT_VOTE);
7301         uint256 _rate = getUintConfig(CONFIG_BONUS_REPUTATION_NUMERATOR);
7302         uint256 _base = getUintConfig(CONFIG_BONUS_REPUTATION_DENOMINATOR);
7303 
7304         uint256 _bonus = _qp.mul(_rate).mul(getUintConfig(CONFIG_REPUTATION_PER_EXTRA_QP_NUM))
7305             .div(
7306                 _base.mul(getUintConfig(CONFIG_REPUTATION_PER_EXTRA_QP_DEN))
7307             );
7308 
7309         for (uint256 i = 0; i < _n; i++) {
7310             if (isParticipant(_voters[i])) { // only give bonus reputation to current participants
7311                 daoPointsStorage().increaseReputation(_voters[i], _bonus);
7312             }
7313         }
7314     }
7315 }
7316 
7317 /**
7318 @title Interactive DAO contract for creating/modifying/endorsing proposals
7319 @author Digix Holdings
7320 */
7321 contract Dao is DaoCommon {
7322 
7323     event NewProposal(bytes32 indexed _proposalId, address _proposer);
7324     event ModifyProposal(bytes32 indexed _proposalId, bytes32 _newDoc);
7325     event ChangeProposalFunding(bytes32 indexed _proposalId);
7326     event FinalizeProposal(bytes32 indexed _proposalId);
7327     event FinishMilestone(bytes32 indexed _proposalId, uint256 indexed _milestoneIndex);
7328     event AddProposalDoc(bytes32 indexed _proposalId, bytes32 _newDoc);
7329     event PRLAction(bytes32 indexed _proposalId, uint256 _actionId, bytes32 _doc);
7330     event CloseProposal(bytes32 indexed _proposalId);
7331 
7332     constructor(address _resolver) public {
7333         require(init(CONTRACT_DAO, _resolver));
7334     }
7335 
7336     function daoFundingManager()
7337         internal
7338         view
7339         returns (DaoFundingManager _contract)
7340     {
7341         _contract = DaoFundingManager(get_contract(CONTRACT_DAO_FUNDING_MANAGER));
7342     }
7343 
7344     function daoRewardsManager()
7345         internal
7346         view
7347         returns (DaoRewardsManager _contract)
7348     {
7349         _contract = DaoRewardsManager(get_contract(CONTRACT_DAO_REWARDS_MANAGER));
7350     }
7351 
7352     function daoVotingClaims()
7353         internal
7354         view
7355         returns (DaoVotingClaims _contract)
7356     {
7357         _contract = DaoVotingClaims(get_contract(CONTRACT_DAO_VOTING_CLAIMS));
7358     }
7359 
7360     /**
7361     @notice Set addresses for the new Dao and DaoFundingManager contracts
7362     @dev This is the first step of the 2-step migration
7363     @param _newDaoContract Address of the new Dao contract
7364     @param _newDaoFundingManager Address of the new DaoFundingManager contract
7365     @param _newDaoRewardsManager Address of the new daoRewardsManager contract
7366     */
7367     function setNewDaoContracts(
7368         address _newDaoContract,
7369         address _newDaoFundingManager,
7370         address _newDaoRewardsManager
7371     )
7372         public
7373         if_root()
7374     {
7375         require(daoUpgradeStorage().isReplacedByNewDao() == false);
7376         daoUpgradeStorage().setNewContractAddresses(
7377             _newDaoContract,
7378             _newDaoFundingManager,
7379             _newDaoRewardsManager
7380         );
7381     }
7382 
7383     /**
7384     @notice Migrate this DAO to a new DAO contract
7385     @dev This is the second step of the 2-step migration
7386          Migration can only be done during the locking phase, after the global rewards for current quarter are set.
7387          This is to make sure that there is no rewards calculation pending before the DAO is migrated to new contracts
7388          The addresses of the new Dao contracts have to be provided again, and be double checked against the addresses that were set in setNewDaoContracts()
7389     @param _newDaoContract Address of the new DAO contract
7390     @param _newDaoFundingManager Address of the new DaoFundingManager contract, which would receive the remaining ETHs in this DaoFundingManager
7391     @param _newDaoRewardsManager Address of the new daoRewardsManager contract, which would receive the claimableDGXs from this daoRewardsManager
7392     */
7393     function migrateToNewDao(
7394         address _newDaoContract,
7395         address _newDaoFundingManager,
7396         address _newDaoRewardsManager
7397     )
7398         public
7399         if_root()
7400         ifGlobalRewardsSet(currentQuarterNumber())
7401     {
7402         require(isLockingPhase());
7403         require(daoUpgradeStorage().isReplacedByNewDao() == false);
7404         require(
7405           (daoUpgradeStorage().newDaoContract() == _newDaoContract) &&
7406           (daoUpgradeStorage().newDaoFundingManager() == _newDaoFundingManager) &&
7407           (daoUpgradeStorage().newDaoRewardsManager() == _newDaoRewardsManager)
7408         );
7409         daoUpgradeStorage().updateForDaoMigration();
7410         daoFundingManager().moveFundsToNewDao(_newDaoFundingManager);
7411         daoRewardsManager().moveDGXsToNewDao(_newDaoRewardsManager);
7412     }
7413 
7414     /**
7415     @notice Call this function to mark the start of the DAO's first quarter. This can only be done once, by a founder
7416     @param _start Start time of the first quarter in the DAO
7417     */
7418     function setStartOfFirstQuarter(uint256 _start) public if_founder() {
7419         require(daoUpgradeStorage().startOfFirstQuarter() == 0);
7420         require(_start > 0);
7421         daoUpgradeStorage().setStartOfFirstQuarter(_start);
7422     }
7423 
7424     /**
7425     @notice Submit a new preliminary idea / Pre-proposal
7426     @dev The proposer has to send in a collateral == getUintConfig(CONFIG_PREPROPOSAL_COLLATERAL)
7427          which he could claim back in these scenarios:
7428           - Before the proposal is finalized, by calling closeProposal()
7429           - After all milestones are done and the final voting round is passed
7430 
7431     @param _docIpfsHash Hash of the IPFS doc containing details of proposal
7432     @param _milestonesFundings Array of fundings of the proposal milestones (in wei)
7433     @param _finalReward Final reward asked by proposer at successful completion of all milestones of proposal
7434     */
7435     function submitPreproposal(
7436         bytes32 _docIpfsHash,
7437         uint256[] _milestonesFundings,
7438         uint256 _finalReward
7439     )
7440         external
7441         payable
7442         ifFundingPossible(_milestonesFundings, _finalReward)
7443     {
7444         senderCanDoProposerOperations();
7445         bool _isFounder = is_founder();
7446 
7447         require(msg.value == getUintConfig(CONFIG_PREPROPOSAL_COLLATERAL));
7448         require(address(daoFundingManager()).call.gas(25000).value(msg.value)());
7449 
7450         checkNonDigixFundings(_milestonesFundings, _finalReward);
7451 
7452         daoStorage().addProposal(_docIpfsHash, msg.sender, _milestonesFundings, _finalReward, _isFounder);
7453         daoStorage().setProposalCollateralStatus(_docIpfsHash, COLLATERAL_STATUS_UNLOCKED);
7454         daoStorage().setProposalCollateralAmount(_docIpfsHash, msg.value);
7455 
7456         emit NewProposal(_docIpfsHash, msg.sender);
7457     }
7458 
7459     /**
7460     @notice Modify a proposal (this can be done only before setting the final version)
7461     @param _proposalId Proposal ID (hash of IPFS doc of the first version of the proposal)
7462     @param _docIpfsHash Hash of IPFS doc of the modified version of the proposal
7463     @param _milestonesFundings Array of fundings of the modified version of the proposal (in wei)
7464     @param _finalReward Final reward on successful completion of all milestones of the modified version of proposal (in wei)
7465     */
7466     function modifyProposal(
7467         bytes32 _proposalId,
7468         bytes32 _docIpfsHash,
7469         uint256[] _milestonesFundings,
7470         uint256 _finalReward
7471     )
7472         external
7473     {
7474         senderCanDoProposerOperations();
7475         require(isFromProposer(_proposalId));
7476 
7477         require(isEditable(_proposalId));
7478         bytes32 _currentState;
7479         (,,,_currentState,,,,,,) = daoStorage().readProposal(_proposalId);
7480         require(_currentState == PROPOSAL_STATE_PREPROPOSAL ||
7481           _currentState == PROPOSAL_STATE_DRAFT);
7482 
7483         checkNonDigixFundings(_milestonesFundings, _finalReward);
7484 
7485         daoStorage().editProposal(_proposalId, _docIpfsHash, _milestonesFundings, _finalReward);
7486 
7487         emit ModifyProposal(_proposalId, _docIpfsHash);
7488     }
7489 
7490     /**
7491     @notice Function to change the funding structure for a proposal
7492     @dev Proposers can only change fundings for the subsequent milestones,
7493     during the duration of an on-going milestone (so, cannot be before proposal finalization or during any voting phase)
7494     @param _proposalId ID of the proposal
7495     @param _milestonesFundings Array of fundings for milestones
7496     @param _finalReward Final reward needed for completion of proposal
7497     @param _currentMilestone the milestone number the proposal is currently in
7498     */
7499     function changeFundings(
7500         bytes32 _proposalId,
7501         uint256[] _milestonesFundings,
7502         uint256 _finalReward,
7503         uint256 _currentMilestone
7504     )
7505         external
7506     {
7507         senderCanDoProposerOperations();
7508         require(isFromProposer(_proposalId));
7509 
7510         checkNonDigixFundings(_milestonesFundings, _finalReward);
7511 
7512         uint256[] memory _currentFundings;
7513         (_currentFundings,) = daoStorage().readProposalFunding(_proposalId);
7514 
7515         // If there are N milestones, the milestone index must be < N. Otherwise, putting a milestone index of N will actually return a valid timestamp that is
7516         // right after the final voting round (voting round index N is the final voting round)
7517         // Which could be abused ( to add more milestones even after the final voting round)
7518         require(_currentMilestone < _currentFundings.length);
7519 
7520         uint256 _startOfCurrentMilestone = startOfMilestone(_proposalId, _currentMilestone);
7521 
7522         // must be after the start of the milestone, and the milestone has not been finished yet (next voting hasnt started)
7523         require(now > _startOfCurrentMilestone);
7524         require(daoStorage().readProposalVotingTime(_proposalId, _currentMilestone.add(1)) == 0);
7525 
7526         // can only modify the fundings after _currentMilestone
7527         // so, all the fundings from 0 to _currentMilestone must be the same
7528         for (uint256 i=0;i<=_currentMilestone;i++) {
7529             require(_milestonesFundings[i] == _currentFundings[i]);
7530         }
7531 
7532         daoStorage().changeFundings(_proposalId, _milestonesFundings, _finalReward);
7533 
7534         emit ChangeProposalFunding(_proposalId);
7535     }
7536 
7537     /**
7538     @notice Finalize a proposal
7539     @dev After finalizing a proposal, no more proposal version can be added. Proposer will only be able to change fundings and add more docs
7540          Right after finalizing a proposal, the draft voting round starts. The proposer would also not be able to closeProposal() anymore
7541          (hence, cannot claim back the collateral anymore, until the final voting round passes)
7542     @param _proposalId ID of the proposal
7543     */
7544     function finalizeProposal(bytes32 _proposalId)
7545         public
7546     {
7547         senderCanDoProposerOperations();
7548         require(isFromProposer(_proposalId));
7549         require(isEditable(_proposalId));
7550         checkNonDigixProposalLimit(_proposalId);
7551 
7552         // make sure we have reasonably enough time left in the quarter to conduct the Draft Voting.
7553         // Otherwise, the proposer must wait until the next quarter to finalize the proposal
7554         require(getTimeLeftInQuarter(now) > getUintConfig(CONFIG_DRAFT_VOTING_PHASE).add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE)));
7555         address _endorser;
7556         (,,_endorser,,,,,,,) = daoStorage().readProposal(_proposalId);
7557         require(_endorser != EMPTY_ADDRESS);
7558         daoStorage().finalizeProposal(_proposalId);
7559         daoStorage().setProposalDraftVotingTime(_proposalId, now);
7560 
7561         emit FinalizeProposal(_proposalId);
7562     }
7563 
7564     /**
7565     @notice Function to set milestone to be completed
7566     @dev This can only be called in the Main Phase of DigixDAO by the proposer. It sets the
7567          voting time for the next milestone, which is immediately, for most of the times. If there is not enough time left in the current
7568          quarter, then the next voting is postponed to the start of next quarter
7569     @param _proposalId ID of the proposal
7570     @param _milestoneIndex Index of the milestone. Index starts from 0 (for the first milestone)
7571     */
7572     function finishMilestone(bytes32 _proposalId, uint256 _milestoneIndex)
7573         public
7574     {
7575         senderCanDoProposerOperations();
7576         require(isFromProposer(_proposalId));
7577 
7578         uint256[] memory _currentFundings;
7579         (_currentFundings,) = daoStorage().readProposalFunding(_proposalId);
7580 
7581         // If there are N milestones, the milestone index must be < N. Otherwise, putting a milestone index of N will actually return a valid timestamp that is
7582         // right after the final voting round (voting round index N is the final voting round)
7583         // Which could be abused ( to "finish" a milestone even after the final voting round)
7584         require(_milestoneIndex < _currentFundings.length);
7585 
7586         // must be after the start of this milestone, and the milestone has not been finished yet (voting hasnt started)
7587         uint256 _startOfCurrentMilestone = startOfMilestone(_proposalId, _milestoneIndex);
7588         require(now > _startOfCurrentMilestone);
7589         require(daoStorage().readProposalVotingTime(_proposalId, _milestoneIndex.add(1)) == 0);
7590 
7591         daoStorage().setProposalVotingTime(
7592             _proposalId,
7593             _milestoneIndex.add(1),
7594             getTimelineForNextVote(_milestoneIndex.add(1), now)
7595         ); // set the voting time of next voting
7596 
7597         emit FinishMilestone(_proposalId, _milestoneIndex);
7598     }
7599 
7600     /**
7601     @notice Add IPFS docs to a proposal
7602     @dev This is allowed only after a proposal is finalized. Before finalizing
7603          a proposal, proposer can modifyProposal and basically create a different ProposalVersion. After the proposal is finalized,
7604          they can only allProposalDoc to the final version of that proposal
7605     @param _proposalId ID of the proposal
7606     @param _newDoc hash of the new IPFS doc
7607     */
7608     function addProposalDoc(bytes32 _proposalId, bytes32 _newDoc)
7609         public
7610     {
7611         senderCanDoProposerOperations();
7612         require(isFromProposer(_proposalId));
7613         bytes32 _finalVersion;
7614         (,,,,,,,_finalVersion,,) = daoStorage().readProposal(_proposalId);
7615         require(_finalVersion != EMPTY_BYTES);
7616         daoStorage().addProposalDoc(_proposalId, _newDoc);
7617 
7618         emit AddProposalDoc(_proposalId, _newDoc);
7619     }
7620 
7621     /**
7622     @notice Function to endorse a pre-proposal (can be called only by DAO Moderator)
7623     @param _proposalId ID of the proposal (hash of IPFS doc of the first version of the proposal)
7624     */
7625     function endorseProposal(bytes32 _proposalId)
7626         public
7627         isProposalState(_proposalId, PROPOSAL_STATE_PREPROPOSAL)
7628     {
7629         require(isMainPhase());
7630         require(isModerator(msg.sender));
7631         daoStorage().updateProposalEndorse(_proposalId, msg.sender);
7632     }
7633 
7634     /**
7635     @notice Function to update the PRL (regulatory status) status of a proposal
7636     @dev if a proposal is paused or stopped, the proposer wont be able to withdraw the funding
7637     @param _proposalId ID of the proposal
7638     @param _doc hash of IPFS uploaded document, containing details of PRL Action
7639     */
7640     function updatePRL(
7641         bytes32 _proposalId,
7642         uint256 _action,
7643         bytes32 _doc
7644     )
7645         public
7646         if_prl()
7647     {
7648         require(_action == PRL_ACTION_STOP || _action == PRL_ACTION_PAUSE || _action == PRL_ACTION_UNPAUSE);
7649         daoStorage().updateProposalPRL(_proposalId, _action, _doc, now);
7650 
7651         emit PRLAction(_proposalId, _action, _doc);
7652     }
7653 
7654     /**
7655     @notice Function to close proposal (also get back collateral)
7656     @dev Can only be closed if the proposal has not been finalized yet
7657     @param _proposalId ID of the proposal
7658     */
7659     function closeProposal(bytes32 _proposalId)
7660         public
7661     {
7662         senderCanDoProposerOperations();
7663         require(isFromProposer(_proposalId));
7664         bytes32 _finalVersion;
7665         bytes32 _status;
7666         (,,,_status,,,,_finalVersion,,) = daoStorage().readProposal(_proposalId);
7667         require(_finalVersion == EMPTY_BYTES);
7668         require(_status != PROPOSAL_STATE_CLOSED);
7669         require(daoStorage().readProposalCollateralStatus(_proposalId) == COLLATERAL_STATUS_UNLOCKED);
7670 
7671         daoStorage().closeProposal(_proposalId);
7672         daoStorage().setProposalCollateralStatus(_proposalId, COLLATERAL_STATUS_CLAIMED);
7673         emit CloseProposal(_proposalId);
7674         require(daoFundingManager().refundCollateral(msg.sender, _proposalId));
7675     }
7676 
7677     /**
7678     @notice Function for founders to close all the dead proposals
7679     @dev Dead proposals = all proposals who are not yet finalized, and been there for more than the threshold time
7680          The proposers of dead proposals will not get the collateral back
7681     @param _proposalIds Array of proposal IDs
7682     */
7683     function founderCloseProposals(bytes32[] _proposalIds)
7684         external
7685         if_founder()
7686     {
7687         uint256 _length = _proposalIds.length;
7688         uint256 _timeCreated;
7689         bytes32 _finalVersion;
7690         bytes32 _currentState;
7691         for (uint256 _i = 0; _i < _length; _i++) {
7692             (,,,_currentState,_timeCreated,,,_finalVersion,,) = daoStorage().readProposal(_proposalIds[_i]);
7693             require(_finalVersion == EMPTY_BYTES);
7694             require(
7695                 (_currentState == PROPOSAL_STATE_PREPROPOSAL) ||
7696                 (_currentState == PROPOSAL_STATE_DRAFT)
7697             );
7698             require(now > _timeCreated.add(getUintConfig(CONFIG_PROPOSAL_DEAD_DURATION)));
7699             emit CloseProposal(_proposalIds[_i]);
7700             daoStorage().closeProposal(_proposalIds[_i]);
7701         }
7702     }
7703 }
7704 
7705 /**
7706 @title Contract to manage DAO funds
7707 @author Digix Holdings
7708 */
7709 contract DaoFundingManager is DaoCommon {
7710 
7711     address public FUNDING_SOURCE;
7712 
7713     event ClaimFunding(bytes32 indexed _proposalId, uint256 indexed _votingRound, uint256 _funding);
7714 
7715     constructor(address _resolver, address _fundingSource) public {
7716         require(init(CONTRACT_DAO_FUNDING_MANAGER, _resolver));
7717         FUNDING_SOURCE = _fundingSource;
7718     }
7719 
7720     function dao()
7721         internal
7722         view
7723         returns (Dao _contract)
7724     {
7725         _contract = Dao(get_contract(CONTRACT_DAO));
7726     }
7727 
7728     /**
7729     @notice Check if a proposal is currently paused/stopped
7730     @dev If a proposal is paused/stopped (by the PRLs): proposer cannot call for voting, a current on-going voting round can still pass, but no funding can be withdrawn.
7731     @dev A paused proposal can still be unpaused
7732     @dev If a proposal is stopped, this function also returns true
7733     @return _isPausedOrStopped true if the proposal is paused(or stopped)
7734     */
7735     function isProposalPaused(bytes32 _proposalId)
7736         public
7737         view
7738         returns (bool _isPausedOrStopped)
7739     {
7740         (,,,,,,,,_isPausedOrStopped,) = daoStorage().readProposal(_proposalId);
7741     }
7742 
7743     /**
7744     @notice Function to set the source of DigixDAO funding
7745     @dev only this source address will be able to fund the DaoFundingManager contract, along with CONTRACT_DAO
7746     @param _fundingSource address of the funding source
7747     */
7748     function setFundingSource(address _fundingSource)
7749         public
7750         if_root()
7751     {
7752         FUNDING_SOURCE = _fundingSource;
7753     }
7754 
7755     /**
7756     @notice Call function to claim the ETH funding for a certain milestone
7757     @dev Note that the proposer can do this anytime, even in the locking phase
7758     @param _proposalId ID of the proposal
7759     @param _index Index of the proposal voting round that they got passed, which is also the same as the milestone index
7760     */
7761     function claimFunding(bytes32 _proposalId, uint256 _index)
7762         public
7763     {
7764         require(identity_storage().is_kyc_approved(msg.sender));
7765         require(isFromProposer(_proposalId));
7766 
7767         // proposal should not be paused/stopped
7768         require(!isProposalPaused(_proposalId));
7769 
7770         require(!daoStorage().readIfMilestoneFunded(_proposalId, _index));
7771 
7772         require(daoStorage().readProposalVotingResult(_proposalId, _index));
7773         require(daoStorage().isClaimed(_proposalId, _index));
7774 
7775         uint256 _funding = daoStorage().readProposalMilestone(_proposalId, _index);
7776 
7777         daoStorage().setMilestoneFunded(_proposalId, _index);
7778 
7779         msg.sender.transfer(_funding);
7780 
7781         emit ClaimFunding(_proposalId, _index, _funding);
7782     }
7783 
7784     /**
7785     @notice Function to refund the collateral to _receiver
7786     @dev Can only be called from the Dao contract
7787     @param _receiver The receiver of the funds
7788     @return {
7789       "_success": "Boolean, true if refund was successful"
7790     }
7791     */
7792     function refundCollateral(address _receiver, bytes32 _proposalId)
7793         public
7794         returns (bool _success)
7795     {
7796         require(sender_is_from([CONTRACT_DAO, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
7797         refundCollateralInternal(_receiver, _proposalId);
7798         _success = true;
7799     }
7800 
7801     function refundCollateralInternal(address _receiver, bytes32 _proposalId)
7802         internal
7803     {
7804         uint256 _collateralAmount = daoStorage().readProposalCollateralAmount(_proposalId);
7805         _receiver.transfer(_collateralAmount);
7806     }
7807 
7808     /**
7809     @notice Function to move funds to a new DAO
7810     @param _destinationForDaoFunds Ethereum contract address of the new DaoFundingManager
7811     */
7812     function moveFundsToNewDao(address _destinationForDaoFunds)
7813         public
7814     {
7815         require(sender_is(CONTRACT_DAO));
7816         uint256 _remainingBalance = address(this).balance;
7817         _destinationForDaoFunds.transfer(_remainingBalance);
7818     }
7819 
7820     /**
7821     @notice Payable fallback function to receive ETH funds from DigixDAO crowdsale contract
7822     @dev this contract can only receive funds from FUNDING_SOURCE address or CONTRACT_DAO (when proposal is created)
7823     */
7824     function () external payable {
7825         require(
7826             (msg.sender == FUNDING_SOURCE) ||
7827             (msg.sender == get_contract(CONTRACT_DAO))
7828         );
7829     }
7830 }