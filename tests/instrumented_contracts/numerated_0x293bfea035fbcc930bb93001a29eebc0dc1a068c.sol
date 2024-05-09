1 // full contract sources : https://github.com/DigixGlobal/dao-contracts
2 
3 pragma solidity 0.4.25;
4 
5 // File: @digix/solidity-collections/contracts/abstract/AddressIteratorInteractive.sol
6 /**
7   @title Address Iterator Interactive
8   @author DigixGlobal Pte Ltd
9 */
10 contract AddressIteratorInteractive {
11 
12   /**
13     @notice Lists a Address collection from start or end
14     @param _count Total number of Address items to return
15     @param _function_first Function that returns the First Address item in the list
16     @param _function_last Function that returns the last Address item in the list
17     @param _function_next Function that returns the Next Address item in the list
18     @param _function_previous Function that returns previous Address item in the list
19     @param _from_start whether to read from start (or end) of the list
20     @return {"_address_items" : "Collection of reversed Address list"}
21   */
22   function list_addresses(uint256 _count,
23                                  function () external constant returns (address) _function_first,
24                                  function () external constant returns (address) _function_last,
25                                  function (address) external constant returns (address) _function_next,
26                                  function (address) external constant returns (address) _function_previous,
27                                  bool _from_start)
28            internal
29            constant
30            returns (address[] _address_items)
31   {
32     if (_from_start) {
33       _address_items = private_list_addresses_from_address(_function_first(), _count, true, _function_last, _function_next);
34     } else {
35       _address_items = private_list_addresses_from_address(_function_last(), _count, true, _function_first, _function_previous);
36     }
37   }
38 
39 
40 
41   /**
42     @notice Lists a Address collection from some `_current_item`, going forwards or backwards depending on `_from_start`
43     @param _current_item The current Item
44     @param _count Total number of Address items to return
45     @param _function_first Function that returns the First Address item in the list
46     @param _function_last Function that returns the last Address item in the list
47     @param _function_next Function that returns the Next Address item in the list
48     @param _function_previous Function that returns previous Address item in the list
49     @param _from_start whether to read in the forwards ( or backwards) direction
50     @return {"_address_items" :"Collection/list of Address"}
51   */
52   function list_addresses_from(address _current_item, uint256 _count,
53                                 function () external constant returns (address) _function_first,
54                                 function () external constant returns (address) _function_last,
55                                 function (address) external constant returns (address) _function_next,
56                                 function (address) external constant returns (address) _function_previous,
57                                 bool _from_start)
58            internal
59            constant
60            returns (address[] _address_items)
61   {
62     if (_from_start) {
63       _address_items = private_list_addresses_from_address(_current_item, _count, false, _function_last, _function_next);
64     } else {
65       _address_items = private_list_addresses_from_address(_current_item, _count, false, _function_first, _function_previous);
66     }
67   }
68 
69 
70   /**
71     @notice a private function to lists a Address collection starting from some `_current_item` (which could be included or excluded), in the forwards or backwards direction
72     @param _current_item The current Item
73     @param _count Total number of Address items to return
74     @param _including_current Whether the `_current_item` should be included in the result
75     @param _function_last Function that returns the address where we stop reading more address
76     @param _function_next Function that returns the next address to read after some address (could be backwards or forwards in the physical collection)
77     @return {"_address_items" :"Collection/list of Address"}
78   */
79   function private_list_addresses_from_address(address _current_item, uint256 _count, bool _including_current,
80                                  function () external constant returns (address) _function_last,
81                                  function (address) external constant returns (address) _function_next)
82            private
83            constant
84            returns (address[] _address_items)
85   {
86     uint256 _i;
87     uint256 _real_count = 0;
88     address _last_item;
89 
90     _last_item = _function_last();
91     if (_count == 0 || _last_item == address(0x0)) {
92       _address_items = new address[](0);
93     } else {
94       address[] memory _items_temp = new address[](_count);
95       address _this_item;
96       if (_including_current == true) {
97         _items_temp[0] = _current_item;
98         _real_count = 1;
99       }
100       _this_item = _current_item;
101       for (_i = _real_count; (_i < _count) && (_this_item != _last_item);_i++) {
102         _this_item = _function_next(_this_item);
103         if (_this_item != address(0x0)) {
104           _real_count++;
105           _items_temp[_i] = _this_item;
106         }
107       }
108 
109       _address_items = new address[](_real_count);
110       for(_i = 0;_i < _real_count;_i++) {
111         _address_items[_i] = _items_temp[_i];
112       }
113     }
114   }
115 
116 
117   /** DEPRECATED
118     @notice private function to list a Address collection starting from the start or end of the list
119     @param _count Total number of Address item to return
120     @param _function_total Function that returns the Total number of Address item in the list
121     @param _function_first Function that returns the First Address item in the list
122     @param _function_next Function that returns the Next Address item in the list
123     @return {"_address_items" :"Collection/list of Address"}
124   */
125   /*function list_addresses_from_start_or_end(uint256 _count,
126                                  function () external constant returns (uint256) _function_total,
127                                  function () external constant returns (address) _function_first,
128                                  function (address) external constant returns (address) _function_next)
129 
130            private
131            constant
132            returns (address[] _address_items)
133   {
134     uint256 _i;
135     address _current_item;
136     uint256 _real_count = _function_total();
137 
138     if (_count > _real_count) {
139       _count = _real_count;
140     }
141 
142     address[] memory _items_tmp = new address[](_count);
143 
144     if (_count > 0) {
145       _current_item = _function_first();
146       _items_tmp[0] = _current_item;
147 
148       for(_i = 1;_i <= (_count - 1);_i++) {
149         _current_item = _function_next(_current_item);
150         if (_current_item != address(0x0)) {
151           _items_tmp[_i] = _current_item;
152         }
153       }
154       _address_items = _items_tmp;
155     } else {
156       _address_items = new address[](0);
157     }
158   }*/
159 
160   /** DEPRECATED
161     @notice a private function to lists a Address collection starting from some `_current_item`, could be forwards or backwards
162     @param _current_item The current Item
163     @param _count Total number of Address items to return
164     @param _function_last Function that returns the bytes where we stop reading more bytes
165     @param _function_next Function that returns the next bytes to read after some bytes (could be backwards or forwards in the physical collection)
166     @return {"_address_items" :"Collection/list of Address"}
167   */
168   /*function list_addresses_from_byte(address _current_item, uint256 _count,
169                                  function () external constant returns (address) _function_last,
170                                  function (address) external constant returns (address) _function_next)
171            private
172            constant
173            returns (address[] _address_items)
174   {
175     uint256 _i;
176     uint256 _real_count = 0;
177 
178     if (_count == 0) {
179       _address_items = new address[](0);
180     } else {
181       address[] memory _items_temp = new address[](_count);
182 
183       address _start_item;
184       address _last_item;
185 
186       _last_item = _function_last();
187 
188       if (_last_item != _current_item) {
189         _start_item = _function_next(_current_item);
190         if (_start_item != address(0x0)) {
191           _items_temp[0] = _start_item;
192           _real_count = 1;
193           for(_i = 1;(_i <= (_count - 1)) && (_start_item != _last_item);_i++) {
194             _start_item = _function_next(_start_item);
195             if (_start_item != address(0x0)) {
196               _real_count++;
197               _items_temp[_i] = _start_item;
198             }
199           }
200           _address_items = new address[](_real_count);
201           for(_i = 0;_i <= (_real_count - 1);_i++) {
202             _address_items[_i] = _items_temp[_i];
203           }
204         } else {
205           _address_items = new address[](0);
206         }
207       } else {
208         _address_items = new address[](0);
209       }
210     }
211   }*/
212 }
213 
214 // File: @digix/solidity-collections/contracts/abstract/BytesIteratorInteractive.sol
215 /**
216   @title Bytes Iterator Interactive
217   @author DigixGlobal Pte Ltd
218 */
219 contract BytesIteratorInteractive {
220 
221   /**
222     @notice Lists a Bytes collection from start or end
223     @param _count Total number of Bytes items to return
224     @param _function_first Function that returns the First Bytes item in the list
225     @param _function_last Function that returns the last Bytes item in the list
226     @param _function_next Function that returns the Next Bytes item in the list
227     @param _function_previous Function that returns previous Bytes item in the list
228     @param _from_start whether to read from start (or end) of the list
229     @return {"_bytes_items" : "Collection of reversed Bytes list"}
230   */
231   function list_bytesarray(uint256 _count,
232                                  function () external constant returns (bytes32) _function_first,
233                                  function () external constant returns (bytes32) _function_last,
234                                  function (bytes32) external constant returns (bytes32) _function_next,
235                                  function (bytes32) external constant returns (bytes32) _function_previous,
236                                  bool _from_start)
237            internal
238            constant
239            returns (bytes32[] _bytes_items)
240   {
241     if (_from_start) {
242       _bytes_items = private_list_bytes_from_bytes(_function_first(), _count, true, _function_last, _function_next);
243     } else {
244       _bytes_items = private_list_bytes_from_bytes(_function_last(), _count, true, _function_first, _function_previous);
245     }
246   }
247 
248   /**
249     @notice Lists a Bytes collection from some `_current_item`, going forwards or backwards depending on `_from_start`
250     @param _current_item The current Item
251     @param _count Total number of Bytes items to return
252     @param _function_first Function that returns the First Bytes item in the list
253     @param _function_last Function that returns the last Bytes item in the list
254     @param _function_next Function that returns the Next Bytes item in the list
255     @param _function_previous Function that returns previous Bytes item in the list
256     @param _from_start whether to read in the forwards ( or backwards) direction
257     @return {"_bytes_items" :"Collection/list of Bytes"}
258   */
259   function list_bytesarray_from(bytes32 _current_item, uint256 _count,
260                                 function () external constant returns (bytes32) _function_first,
261                                 function () external constant returns (bytes32) _function_last,
262                                 function (bytes32) external constant returns (bytes32) _function_next,
263                                 function (bytes32) external constant returns (bytes32) _function_previous,
264                                 bool _from_start)
265            internal
266            constant
267            returns (bytes32[] _bytes_items)
268   {
269     if (_from_start) {
270       _bytes_items = private_list_bytes_from_bytes(_current_item, _count, false, _function_last, _function_next);
271     } else {
272       _bytes_items = private_list_bytes_from_bytes(_current_item, _count, false, _function_first, _function_previous);
273     }
274   }
275 
276   /**
277     @notice A private function to lists a Bytes collection starting from some `_current_item` (which could be included or excluded), in the forwards or backwards direction
278     @param _current_item The current Item
279     @param _count Total number of Bytes items to return
280     @param _including_current Whether the `_current_item` should be included in the result
281     @param _function_last Function that returns the bytes where we stop reading more bytes
282     @param _function_next Function that returns the next bytes to read after some bytes (could be backwards or forwards in the physical collection)
283     @return {"_address_items" :"Collection/list of Bytes"}
284   */
285   function private_list_bytes_from_bytes(bytes32 _current_item, uint256 _count, bool _including_current,
286                                  function () external constant returns (bytes32) _function_last,
287                                  function (bytes32) external constant returns (bytes32) _function_next)
288            private
289            constant
290            returns (bytes32[] _bytes32_items)
291   {
292     uint256 _i;
293     uint256 _real_count = 0;
294     bytes32 _last_item;
295 
296     _last_item = _function_last();
297     if (_count == 0 || _last_item == bytes32(0x0)) {
298       _bytes32_items = new bytes32[](0);
299     } else {
300       bytes32[] memory _items_temp = new bytes32[](_count);
301       bytes32 _this_item;
302       if (_including_current == true) {
303         _items_temp[0] = _current_item;
304         _real_count = 1;
305       }
306       _this_item = _current_item;
307       for (_i = _real_count; (_i < _count) && (_this_item != _last_item);_i++) {
308         _this_item = _function_next(_this_item);
309         if (_this_item != bytes32(0x0)) {
310           _real_count++;
311           _items_temp[_i] = _this_item;
312         }
313       }
314 
315       _bytes32_items = new bytes32[](_real_count);
316       for(_i = 0;_i < _real_count;_i++) {
317         _bytes32_items[_i] = _items_temp[_i];
318       }
319     }
320   }
321 
322 
323 
324 
325   ////// DEPRECATED FUNCTIONS (old versions)
326 
327   /**
328     @notice a private function to lists a Bytes collection starting from some `_current_item`, could be forwards or backwards
329     @param _current_item The current Item
330     @param _count Total number of Bytes items to return
331     @param _function_last Function that returns the bytes where we stop reading more bytes
332     @param _function_next Function that returns the next bytes to read after some bytes (could be backwards or forwards in the physical collection)
333     @return {"_bytes_items" :"Collection/list of Bytes"}
334   */
335   /*function list_bytes_from_bytes(bytes32 _current_item, uint256 _count,
336                                  function () external constant returns (bytes32) _function_last,
337                                  function (bytes32) external constant returns (bytes32) _function_next)
338            private
339            constant
340            returns (bytes32[] _bytes_items)
341   {
342     uint256 _i;
343     uint256 _real_count = 0;
344 
345     if (_count == 0) {
346       _bytes_items = new bytes32[](0);
347     } else {
348       bytes32[] memory _items_temp = new bytes32[](_count);
349 
350       bytes32 _start_item;
351       bytes32 _last_item;
352 
353       _last_item = _function_last();
354 
355       if (_last_item != _current_item) {
356         _start_item = _function_next(_current_item);
357         if (_start_item != bytes32(0x0)) {
358           _items_temp[0] = _start_item;
359           _real_count = 1;
360           for(_i = 1;(_i <= (_count - 1)) && (_start_item != _last_item);_i++) {
361             _start_item = _function_next(_start_item);
362             if (_start_item != bytes32(0x0)) {
363               _real_count++;
364               _items_temp[_i] = _start_item;
365             }
366           }
367           _bytes_items = new bytes32[](_real_count);
368           for(_i = 0;_i <= (_real_count - 1);_i++) {
369             _bytes_items[_i] = _items_temp[_i];
370           }
371         } else {
372           _bytes_items = new bytes32[](0);
373         }
374       } else {
375         _bytes_items = new bytes32[](0);
376       }
377     }
378   }*/
379 
380   /**
381     @notice private function to list a Bytes collection starting from the start or end of the list
382     @param _count Total number of Bytes item to return
383     @param _function_total Function that returns the Total number of Bytes item in the list
384     @param _function_first Function that returns the First Bytes item in the list
385     @param _function_next Function that returns the Next Bytes item in the list
386     @return {"_bytes_items" :"Collection/list of Bytes"}
387   */
388   /*function list_bytes_from_start_or_end(uint256 _count,
389                                  function () external constant returns (uint256) _function_total,
390                                  function () external constant returns (bytes32) _function_first,
391                                  function (bytes32) external constant returns (bytes32) _function_next)
392 
393            private
394            constant
395            returns (bytes32[] _bytes_items)
396   {
397     uint256 _i;
398     bytes32 _current_item;
399     uint256 _real_count = _function_total();
400 
401     if (_count > _real_count) {
402       _count = _real_count;
403     }
404 
405     bytes32[] memory _items_tmp = new bytes32[](_count);
406 
407     if (_count > 0) {
408       _current_item = _function_first();
409       _items_tmp[0] = _current_item;
410 
411       for(_i = 1;_i <= (_count - 1);_i++) {
412         _current_item = _function_next(_current_item);
413         if (_current_item != bytes32(0x0)) {
414           _items_tmp[_i] = _current_item;
415         }
416       }
417       _bytes_items = _items_tmp;
418     } else {
419       _bytes_items = new bytes32[](0);
420     }
421   }*/
422 }
423 
424 // File: @digix/solidity-collections/contracts/abstract/IndexedBytesIteratorInteractive.sol
425 /**
426   @title Indexed Bytes Iterator Interactive
427   @author DigixGlobal Pte Ltd
428 */
429 contract IndexedBytesIteratorInteractive {
430 
431   /**
432     @notice Lists an indexed Bytes collection from start or end
433     @param _collection_index Index of the Collection to list
434     @param _count Total number of Bytes items to return
435     @param _function_first Function that returns the First Bytes item in the list
436     @param _function_last Function that returns the last Bytes item in the list
437     @param _function_next Function that returns the Next Bytes item in the list
438     @param _function_previous Function that returns previous Bytes item in the list
439     @param _from_start whether to read from start (or end) of the list
440     @return {"_bytes_items" : "Collection of reversed Bytes list"}
441   */
442   function list_indexed_bytesarray(bytes32 _collection_index, uint256 _count,
443                               function (bytes32) external constant returns (bytes32) _function_first,
444                               function (bytes32) external constant returns (bytes32) _function_last,
445                               function (bytes32, bytes32) external constant returns (bytes32) _function_next,
446                               function (bytes32, bytes32) external constant returns (bytes32) _function_previous,
447                               bool _from_start)
448            internal
449            constant
450            returns (bytes32[] _indexed_bytes_items)
451   {
452     if (_from_start) {
453       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _function_first(_collection_index), _count, true, _function_last, _function_next);
454     } else {
455       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _function_last(_collection_index), _count, true, _function_first, _function_previous);
456     }
457   }
458 
459   /**
460     @notice Lists an indexed Bytes collection from some `_current_item`, going forwards or backwards depending on `_from_start`
461     @param _collection_index Index of the Collection to list
462     @param _current_item The current Item
463     @param _count Total number of Bytes items to return
464     @param _function_first Function that returns the First Bytes item in the list
465     @param _function_last Function that returns the last Bytes item in the list
466     @param _function_next Function that returns the Next Bytes item in the list
467     @param _function_previous Function that returns previous Bytes item in the list
468     @param _from_start whether to read in the forwards ( or backwards) direction
469     @return {"_bytes_items" :"Collection/list of Bytes"}
470   */
471   function list_indexed_bytesarray_from(bytes32 _collection_index, bytes32 _current_item, uint256 _count,
472                                 function (bytes32) external constant returns (bytes32) _function_first,
473                                 function (bytes32) external constant returns (bytes32) _function_last,
474                                 function (bytes32, bytes32) external constant returns (bytes32) _function_next,
475                                 function (bytes32, bytes32) external constant returns (bytes32) _function_previous,
476                                 bool _from_start)
477            internal
478            constant
479            returns (bytes32[] _indexed_bytes_items)
480   {
481     if (_from_start) {
482       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _current_item, _count, false, _function_last, _function_next);
483     } else {
484       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _current_item, _count, false, _function_first, _function_previous);
485     }
486   }
487 
488   /**
489     @notice a private function to lists an indexed Bytes collection starting from some `_current_item` (which could be included or excluded), in the forwards or backwards direction
490     @param _collection_index Index of the Collection to list
491     @param _current_item The item where we start reading from the list
492     @param _count Total number of Bytes items to return
493     @param _including_current Whether the `_current_item` should be included in the result
494     @param _function_last Function that returns the bytes where we stop reading more bytes
495     @param _function_next Function that returns the next bytes to read after another bytes (could be backwards or forwards in the physical collection)
496     @return {"_bytes_items" :"Collection/list of Bytes"}
497   */
498   function private_list_indexed_bytes_from_bytes(bytes32 _collection_index, bytes32 _current_item, uint256 _count, bool _including_current,
499                                          function (bytes32) external constant returns (bytes32) _function_last,
500                                          function (bytes32, bytes32) external constant returns (bytes32) _function_next)
501            private
502            constant
503            returns (bytes32[] _indexed_bytes_items)
504   {
505     uint256 _i;
506     uint256 _real_count = 0;
507     bytes32 _last_item;
508 
509     _last_item = _function_last(_collection_index);
510     if (_count == 0 || _last_item == bytes32(0x0)) {  // if count is 0 or the collection is empty, returns empty array
511       _indexed_bytes_items = new bytes32[](0);
512     } else {
513       bytes32[] memory _items_temp = new bytes32[](_count);
514       bytes32 _this_item;
515       if (_including_current) {
516         _items_temp[0] = _current_item;
517         _real_count = 1;
518       }
519       _this_item = _current_item;
520       for (_i = _real_count; (_i < _count) && (_this_item != _last_item);_i++) {
521         _this_item = _function_next(_collection_index, _this_item);
522         if (_this_item != bytes32(0x0)) {
523           _real_count++;
524           _items_temp[_i] = _this_item;
525         }
526       }
527 
528       _indexed_bytes_items = new bytes32[](_real_count);
529       for(_i = 0;_i < _real_count;_i++) {
530         _indexed_bytes_items[_i] = _items_temp[_i];
531       }
532     }
533   }
534 
535 
536   // old function, DEPRECATED
537   /*function list_indexed_bytes_from_bytes(bytes32 _collection_index, bytes32 _current_item, uint256 _count,
538                                          function (bytes32) external constant returns (bytes32) _function_last,
539                                          function (bytes32, bytes32) external constant returns (bytes32) _function_next)
540            private
541            constant
542            returns (bytes32[] _indexed_bytes_items)
543   {
544     uint256 _i;
545     uint256 _real_count = 0;
546     if (_count == 0) {
547       _indexed_bytes_items = new bytes32[](0);
548     } else {
549       bytes32[] memory _items_temp = new bytes32[](_count);
550 
551       bytes32 _start_item;
552       bytes32 _last_item;
553 
554       _last_item = _function_last(_collection_index);
555 
556       if (_last_item != _current_item) {
557         _start_item = _function_next(_collection_index, _current_item);
558         if (_start_item != bytes32(0x0)) {
559           _items_temp[0] = _start_item;
560           _real_count = 1;
561           for(_i = 1;(_i <= (_count - 1)) && (_start_item != _last_item);_i++) {
562             _start_item = _function_next(_collection_index, _start_item);
563             if (_start_item != bytes32(0x0)) {
564               _real_count++;
565               _items_temp[_i] = _start_item;
566             }
567           }
568           _indexed_bytes_items = new bytes32[](_real_count);
569           for(_i = 0;_i <= (_real_count - 1);_i++) {
570             _indexed_bytes_items[_i] = _items_temp[_i];
571           }
572         } else {
573           _indexed_bytes_items = new bytes32[](0);
574         }
575       } else {
576         _indexed_bytes_items = new bytes32[](0);
577       }
578     }
579   }*/
580 }
581 
582 // File: @digix/solidity-collections/contracts/lib/DoublyLinkedList.sol
583 library DoublyLinkedList {
584 
585   struct Item {
586     bytes32 item;
587     uint256 previous_index;
588     uint256 next_index;
589   }
590 
591   struct Data {
592     uint256 first_index;
593     uint256 last_index;
594     uint256 count;
595     mapping(bytes32 => uint256) item_index;
596     mapping(uint256 => bool) valid_indexes;
597     Item[] collection;
598   }
599 
600   struct IndexedUint {
601     mapping(bytes32 => Data) data;
602   }
603 
604   struct IndexedAddress {
605     mapping(bytes32 => Data) data;
606   }
607 
608   struct IndexedBytes {
609     mapping(bytes32 => Data) data;
610   }
611 
612   struct Address {
613     Data data;
614   }
615 
616   struct Bytes {
617     Data data;
618   }
619 
620   struct Uint {
621     Data data;
622   }
623 
624   uint256 constant NONE = uint256(0);
625   bytes32 constant EMPTY_BYTES = bytes32(0x0);
626   address constant NULL_ADDRESS = address(0x0);
627 
628   function find(Data storage self, bytes32 _item)
629            public
630            constant
631            returns (uint256 _item_index)
632   {
633     if ((self.item_index[_item] == NONE) && (self.count == NONE)) {
634       _item_index = NONE;
635     } else {
636       _item_index = self.item_index[_item];
637     }
638   }
639 
640   function get(Data storage self, uint256 _item_index)
641            public
642            constant
643            returns (bytes32 _item)
644   {
645     if (self.valid_indexes[_item_index] == true) {
646       _item = self.collection[_item_index - 1].item;
647     } else {
648       _item = EMPTY_BYTES;
649     }
650   }
651 
652   function append(Data storage self, bytes32 _data)
653            internal
654            returns (bool _success)
655   {
656     if (find(self, _data) != NONE || _data == bytes32("")) { // rejects addition of empty values
657       _success = false;
658     } else {
659       uint256 _index = uint256(self.collection.push(Item({item: _data, previous_index: self.last_index, next_index: NONE})));
660       if (self.last_index == NONE) {
661         if ((self.first_index != NONE) || (self.count != NONE)) {
662           revert();
663         } else {
664           self.first_index = self.last_index = _index;
665           self.count = 1;
666         }
667       } else {
668         self.collection[self.last_index - 1].next_index = _index;
669         self.last_index = _index;
670         self.count++;
671       }
672       self.valid_indexes[_index] = true;
673       self.item_index[_data] = _index;
674       _success = true;
675     }
676   }
677 
678   function remove(Data storage self, uint256 _index)
679            internal
680            returns (bool _success)
681   {
682     if (self.valid_indexes[_index] == true) {
683       Item memory item = self.collection[_index - 1];
684       if (item.previous_index == NONE) {
685         self.first_index = item.next_index;
686       } else {
687         self.collection[item.previous_index - 1].next_index = item.next_index;
688       }
689 
690       if (item.next_index == NONE) {
691         self.last_index = item.previous_index;
692       } else {
693         self.collection[item.next_index - 1].previous_index = item.previous_index;
694       }
695       delete self.collection[_index - 1];
696       self.valid_indexes[_index] = false;
697       delete self.item_index[item.item];
698       self.count--;
699       _success = true;
700     } else {
701       _success = false;
702     }
703   }
704 
705   function remove_item(Data storage self, bytes32 _item)
706            internal
707            returns (bool _success)
708   {
709     uint256 _item_index = find(self, _item);
710     if (_item_index != NONE) {
711       require(remove(self, _item_index));
712       _success = true;
713     } else {
714       _success = false;
715     }
716     return _success;
717   }
718 
719   function total(Data storage self)
720            public
721            constant
722            returns (uint256 _total_count)
723   {
724     _total_count = self.count;
725   }
726 
727   function start(Data storage self)
728            public
729            constant
730            returns (uint256 _item_index)
731   {
732     _item_index = self.first_index;
733     return _item_index;
734   }
735 
736   function start_item(Data storage self)
737            public
738            constant
739            returns (bytes32 _item)
740   {
741     uint256 _item_index = start(self);
742     if (_item_index != NONE) {
743       _item = get(self, _item_index);
744     } else {
745       _item = EMPTY_BYTES;
746     }
747   }
748 
749   function end(Data storage self)
750            public
751            constant
752            returns (uint256 _item_index)
753   {
754     _item_index = self.last_index;
755     return _item_index;
756   }
757 
758   function end_item(Data storage self)
759            public
760            constant
761            returns (bytes32 _item)
762   {
763     uint256 _item_index = end(self);
764     if (_item_index != NONE) {
765       _item = get(self, _item_index);
766     } else {
767       _item = EMPTY_BYTES;
768     }
769   }
770 
771   function valid(Data storage self, uint256 _item_index)
772            public
773            constant
774            returns (bool _yes)
775   {
776     _yes = self.valid_indexes[_item_index];
777     //_yes = ((_item_index - 1) < self.collection.length);
778   }
779 
780   function valid_item(Data storage self, bytes32 _item)
781            public
782            constant
783            returns (bool _yes)
784   {
785     uint256 _item_index = self.item_index[_item];
786     _yes = self.valid_indexes[_item_index];
787   }
788 
789   function previous(Data storage self, uint256 _current_index)
790            public
791            constant
792            returns (uint256 _previous_index)
793   {
794     if (self.valid_indexes[_current_index] == true) {
795       _previous_index = self.collection[_current_index - 1].previous_index;
796     } else {
797       _previous_index = NONE;
798     }
799   }
800 
801   function previous_item(Data storage self, bytes32 _current_item)
802            public
803            constant
804            returns (bytes32 _previous_item)
805   {
806     uint256 _current_index = find(self, _current_item);
807     if (_current_index != NONE) {
808       uint256 _previous_index = previous(self, _current_index);
809       _previous_item = get(self, _previous_index);
810     } else {
811       _previous_item = EMPTY_BYTES;
812     }
813   }
814 
815   function next(Data storage self, uint256 _current_index)
816            public
817            constant
818            returns (uint256 _next_index)
819   {
820     if (self.valid_indexes[_current_index] == true) {
821       _next_index = self.collection[_current_index - 1].next_index;
822     } else {
823       _next_index = NONE;
824     }
825   }
826 
827   function next_item(Data storage self, bytes32 _current_item)
828            public
829            constant
830            returns (bytes32 _next_item)
831   {
832     uint256 _current_index = find(self, _current_item);
833     if (_current_index != NONE) {
834       uint256 _next_index = next(self, _current_index);
835       _next_item = get(self, _next_index);
836     } else {
837       _next_item = EMPTY_BYTES;
838     }
839   }
840 
841   function find(Uint storage self, uint256 _item)
842            public
843            constant
844            returns (uint256 _item_index)
845   {
846     _item_index = find(self.data, bytes32(_item));
847   }
848 
849   function get(Uint storage self, uint256 _item_index)
850            public
851            constant
852            returns (uint256 _item)
853   {
854     _item = uint256(get(self.data, _item_index));
855   }
856 
857 
858   function append(Uint storage self, uint256 _data)
859            public
860            returns (bool _success)
861   {
862     _success = append(self.data, bytes32(_data));
863   }
864 
865   function remove(Uint storage self, uint256 _index)
866            internal
867            returns (bool _success)
868   {
869     _success = remove(self.data, _index);
870   }
871 
872   function remove_item(Uint storage self, uint256 _item)
873            public
874            returns (bool _success)
875   {
876     _success = remove_item(self.data, bytes32(_item));
877   }
878 
879   function total(Uint storage self)
880            public
881            constant
882            returns (uint256 _total_count)
883   {
884     _total_count = total(self.data);
885   }
886 
887   function start(Uint storage self)
888            public
889            constant
890            returns (uint256 _index)
891   {
892     _index = start(self.data);
893   }
894 
895   function start_item(Uint storage self)
896            public
897            constant
898            returns (uint256 _start_item)
899   {
900     _start_item = uint256(start_item(self.data));
901   }
902 
903 
904   function end(Uint storage self)
905            public
906            constant
907            returns (uint256 _index)
908   {
909     _index = end(self.data);
910   }
911 
912   function end_item(Uint storage self)
913            public
914            constant
915            returns (uint256 _end_item)
916   {
917     _end_item = uint256(end_item(self.data));
918   }
919 
920   function valid(Uint storage self, uint256 _item_index)
921            public
922            constant
923            returns (bool _yes)
924   {
925     _yes = valid(self.data, _item_index);
926   }
927 
928   function valid_item(Uint storage self, uint256 _item)
929            public
930            constant
931            returns (bool _yes)
932   {
933     _yes = valid_item(self.data, bytes32(_item));
934   }
935 
936   function previous(Uint storage self, uint256 _current_index)
937            public
938            constant
939            returns (uint256 _previous_index)
940   {
941     _previous_index = previous(self.data, _current_index);
942   }
943 
944   function previous_item(Uint storage self, uint256 _current_item)
945            public
946            constant
947            returns (uint256 _previous_item)
948   {
949     _previous_item = uint256(previous_item(self.data, bytes32(_current_item)));
950   }
951 
952   function next(Uint storage self, uint256 _current_index)
953            public
954            constant
955            returns (uint256 _next_index)
956   {
957     _next_index = next(self.data, _current_index);
958   }
959 
960   function next_item(Uint storage self, uint256 _current_item)
961            public
962            constant
963            returns (uint256 _next_item)
964   {
965     _next_item = uint256(next_item(self.data, bytes32(_current_item)));
966   }
967 
968   function find(Address storage self, address _item)
969            public
970            constant
971            returns (uint256 _item_index)
972   {
973     _item_index = find(self.data, bytes32(_item));
974   }
975 
976   function get(Address storage self, uint256 _item_index)
977            public
978            constant
979            returns (address _item)
980   {
981     _item = address(get(self.data, _item_index));
982   }
983 
984 
985   function find(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
986            public
987            constant
988            returns (uint256 _item_index)
989   {
990     _item_index = find(self.data[_collection_index], bytes32(_item));
991   }
992 
993   function get(IndexedUint storage self, bytes32 _collection_index, uint256 _item_index)
994            public
995            constant
996            returns (uint256 _item)
997   {
998     _item = uint256(get(self.data[_collection_index], _item_index));
999   }
1000 
1001 
1002   function append(IndexedUint storage self, bytes32 _collection_index, uint256 _data)
1003            public
1004            returns (bool _success)
1005   {
1006     _success = append(self.data[_collection_index], bytes32(_data));
1007   }
1008 
1009   function remove(IndexedUint storage self, bytes32 _collection_index, uint256 _index)
1010            internal
1011            returns (bool _success)
1012   {
1013     _success = remove(self.data[_collection_index], _index);
1014   }
1015 
1016   function remove_item(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
1017            public
1018            returns (bool _success)
1019   {
1020     _success = remove_item(self.data[_collection_index], bytes32(_item));
1021   }
1022 
1023   function total(IndexedUint storage self, bytes32 _collection_index)
1024            public
1025            constant
1026            returns (uint256 _total_count)
1027   {
1028     _total_count = total(self.data[_collection_index]);
1029   }
1030 
1031   function start(IndexedUint storage self, bytes32 _collection_index)
1032            public
1033            constant
1034            returns (uint256 _index)
1035   {
1036     _index = start(self.data[_collection_index]);
1037   }
1038 
1039   function start_item(IndexedUint storage self, bytes32 _collection_index)
1040            public
1041            constant
1042            returns (uint256 _start_item)
1043   {
1044     _start_item = uint256(start_item(self.data[_collection_index]));
1045   }
1046 
1047 
1048   function end(IndexedUint storage self, bytes32 _collection_index)
1049            public
1050            constant
1051            returns (uint256 _index)
1052   {
1053     _index = end(self.data[_collection_index]);
1054   }
1055 
1056   function end_item(IndexedUint storage self, bytes32 _collection_index)
1057            public
1058            constant
1059            returns (uint256 _end_item)
1060   {
1061     _end_item = uint256(end_item(self.data[_collection_index]));
1062   }
1063 
1064   function valid(IndexedUint storage self, bytes32 _collection_index, uint256 _item_index)
1065            public
1066            constant
1067            returns (bool _yes)
1068   {
1069     _yes = valid(self.data[_collection_index], _item_index);
1070   }
1071 
1072   function valid_item(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
1073            public
1074            constant
1075            returns (bool _yes)
1076   {
1077     _yes = valid_item(self.data[_collection_index], bytes32(_item));
1078   }
1079 
1080   function previous(IndexedUint storage self, bytes32 _collection_index, uint256 _current_index)
1081            public
1082            constant
1083            returns (uint256 _previous_index)
1084   {
1085     _previous_index = previous(self.data[_collection_index], _current_index);
1086   }
1087 
1088   function previous_item(IndexedUint storage self, bytes32 _collection_index, uint256 _current_item)
1089            public
1090            constant
1091            returns (uint256 _previous_item)
1092   {
1093     _previous_item = uint256(previous_item(self.data[_collection_index], bytes32(_current_item)));
1094   }
1095 
1096   function next(IndexedUint storage self, bytes32 _collection_index, uint256 _current_index)
1097            public
1098            constant
1099            returns (uint256 _next_index)
1100   {
1101     _next_index = next(self.data[_collection_index], _current_index);
1102   }
1103 
1104   function next_item(IndexedUint storage self, bytes32 _collection_index, uint256 _current_item)
1105            public
1106            constant
1107            returns (uint256 _next_item)
1108   {
1109     _next_item = uint256(next_item(self.data[_collection_index], bytes32(_current_item)));
1110   }
1111 
1112   function append(Address storage self, address _data)
1113            public
1114            returns (bool _success)
1115   {
1116     _success = append(self.data, bytes32(_data));
1117   }
1118 
1119   function remove(Address storage self, uint256 _index)
1120            internal
1121            returns (bool _success)
1122   {
1123     _success = remove(self.data, _index);
1124   }
1125 
1126 
1127   function remove_item(Address storage self, address _item)
1128            public
1129            returns (bool _success)
1130   {
1131     _success = remove_item(self.data, bytes32(_item));
1132   }
1133 
1134   function total(Address storage self)
1135            public
1136            constant
1137            returns (uint256 _total_count)
1138   {
1139     _total_count = total(self.data);
1140   }
1141 
1142   function start(Address storage self)
1143            public
1144            constant
1145            returns (uint256 _index)
1146   {
1147     _index = start(self.data);
1148   }
1149 
1150   function start_item(Address storage self)
1151            public
1152            constant
1153            returns (address _start_item)
1154   {
1155     _start_item = address(start_item(self.data));
1156   }
1157 
1158 
1159   function end(Address storage self)
1160            public
1161            constant
1162            returns (uint256 _index)
1163   {
1164     _index = end(self.data);
1165   }
1166 
1167   function end_item(Address storage self)
1168            public
1169            constant
1170            returns (address _end_item)
1171   {
1172     _end_item = address(end_item(self.data));
1173   }
1174 
1175   function valid(Address storage self, uint256 _item_index)
1176            public
1177            constant
1178            returns (bool _yes)
1179   {
1180     _yes = valid(self.data, _item_index);
1181   }
1182 
1183   function valid_item(Address storage self, address _item)
1184            public
1185            constant
1186            returns (bool _yes)
1187   {
1188     _yes = valid_item(self.data, bytes32(_item));
1189   }
1190 
1191   function previous(Address storage self, uint256 _current_index)
1192            public
1193            constant
1194            returns (uint256 _previous_index)
1195   {
1196     _previous_index = previous(self.data, _current_index);
1197   }
1198 
1199   function previous_item(Address storage self, address _current_item)
1200            public
1201            constant
1202            returns (address _previous_item)
1203   {
1204     _previous_item = address(previous_item(self.data, bytes32(_current_item)));
1205   }
1206 
1207   function next(Address storage self, uint256 _current_index)
1208            public
1209            constant
1210            returns (uint256 _next_index)
1211   {
1212     _next_index = next(self.data, _current_index);
1213   }
1214 
1215   function next_item(Address storage self, address _current_item)
1216            public
1217            constant
1218            returns (address _next_item)
1219   {
1220     _next_item = address(next_item(self.data, bytes32(_current_item)));
1221   }
1222 
1223   function append(IndexedAddress storage self, bytes32 _collection_index, address _data)
1224            public
1225            returns (bool _success)
1226   {
1227     _success = append(self.data[_collection_index], bytes32(_data));
1228   }
1229 
1230   function remove(IndexedAddress storage self, bytes32 _collection_index, uint256 _index)
1231            internal
1232            returns (bool _success)
1233   {
1234     _success = remove(self.data[_collection_index], _index);
1235   }
1236 
1237 
1238   function remove_item(IndexedAddress storage self, bytes32 _collection_index, address _item)
1239            public
1240            returns (bool _success)
1241   {
1242     _success = remove_item(self.data[_collection_index], bytes32(_item));
1243   }
1244 
1245   function total(IndexedAddress storage self, bytes32 _collection_index)
1246            public
1247            constant
1248            returns (uint256 _total_count)
1249   {
1250     _total_count = total(self.data[_collection_index]);
1251   }
1252 
1253   function start(IndexedAddress storage self, bytes32 _collection_index)
1254            public
1255            constant
1256            returns (uint256 _index)
1257   {
1258     _index = start(self.data[_collection_index]);
1259   }
1260 
1261   function start_item(IndexedAddress storage self, bytes32 _collection_index)
1262            public
1263            constant
1264            returns (address _start_item)
1265   {
1266     _start_item = address(start_item(self.data[_collection_index]));
1267   }
1268 
1269 
1270   function end(IndexedAddress storage self, bytes32 _collection_index)
1271            public
1272            constant
1273            returns (uint256 _index)
1274   {
1275     _index = end(self.data[_collection_index]);
1276   }
1277 
1278   function end_item(IndexedAddress storage self, bytes32 _collection_index)
1279            public
1280            constant
1281            returns (address _end_item)
1282   {
1283     _end_item = address(end_item(self.data[_collection_index]));
1284   }
1285 
1286   function valid(IndexedAddress storage self, bytes32 _collection_index, uint256 _item_index)
1287            public
1288            constant
1289            returns (bool _yes)
1290   {
1291     _yes = valid(self.data[_collection_index], _item_index);
1292   }
1293 
1294   function valid_item(IndexedAddress storage self, bytes32 _collection_index, address _item)
1295            public
1296            constant
1297            returns (bool _yes)
1298   {
1299     _yes = valid_item(self.data[_collection_index], bytes32(_item));
1300   }
1301 
1302   function previous(IndexedAddress storage self, bytes32 _collection_index, uint256 _current_index)
1303            public
1304            constant
1305            returns (uint256 _previous_index)
1306   {
1307     _previous_index = previous(self.data[_collection_index], _current_index);
1308   }
1309 
1310   function previous_item(IndexedAddress storage self, bytes32 _collection_index, address _current_item)
1311            public
1312            constant
1313            returns (address _previous_item)
1314   {
1315     _previous_item = address(previous_item(self.data[_collection_index], bytes32(_current_item)));
1316   }
1317 
1318   function next(IndexedAddress storage self, bytes32 _collection_index, uint256 _current_index)
1319            public
1320            constant
1321            returns (uint256 _next_index)
1322   {
1323     _next_index = next(self.data[_collection_index], _current_index);
1324   }
1325 
1326   function next_item(IndexedAddress storage self, bytes32 _collection_index, address _current_item)
1327            public
1328            constant
1329            returns (address _next_item)
1330   {
1331     _next_item = address(next_item(self.data[_collection_index], bytes32(_current_item)));
1332   }
1333 
1334 
1335   function find(Bytes storage self, bytes32 _item)
1336            public
1337            constant
1338            returns (uint256 _item_index)
1339   {
1340     _item_index = find(self.data, _item);
1341   }
1342 
1343   function get(Bytes storage self, uint256 _item_index)
1344            public
1345            constant
1346            returns (bytes32 _item)
1347   {
1348     _item = get(self.data, _item_index);
1349   }
1350 
1351 
1352   function append(Bytes storage self, bytes32 _data)
1353            public
1354            returns (bool _success)
1355   {
1356     _success = append(self.data, _data);
1357   }
1358 
1359   function remove(Bytes storage self, uint256 _index)
1360            internal
1361            returns (bool _success)
1362   {
1363     _success = remove(self.data, _index);
1364   }
1365 
1366 
1367   function remove_item(Bytes storage self, bytes32 _item)
1368            public
1369            returns (bool _success)
1370   {
1371     _success = remove_item(self.data, _item);
1372   }
1373 
1374   function total(Bytes storage self)
1375            public
1376            constant
1377            returns (uint256 _total_count)
1378   {
1379     _total_count = total(self.data);
1380   }
1381 
1382   function start(Bytes storage self)
1383            public
1384            constant
1385            returns (uint256 _index)
1386   {
1387     _index = start(self.data);
1388   }
1389 
1390   function start_item(Bytes storage self)
1391            public
1392            constant
1393            returns (bytes32 _start_item)
1394   {
1395     _start_item = start_item(self.data);
1396   }
1397 
1398 
1399   function end(Bytes storage self)
1400            public
1401            constant
1402            returns (uint256 _index)
1403   {
1404     _index = end(self.data);
1405   }
1406 
1407   function end_item(Bytes storage self)
1408            public
1409            constant
1410            returns (bytes32 _end_item)
1411   {
1412     _end_item = end_item(self.data);
1413   }
1414 
1415   function valid(Bytes storage self, uint256 _item_index)
1416            public
1417            constant
1418            returns (bool _yes)
1419   {
1420     _yes = valid(self.data, _item_index);
1421   }
1422 
1423   function valid_item(Bytes storage self, bytes32 _item)
1424            public
1425            constant
1426            returns (bool _yes)
1427   {
1428     _yes = valid_item(self.data, _item);
1429   }
1430 
1431   function previous(Bytes storage self, uint256 _current_index)
1432            public
1433            constant
1434            returns (uint256 _previous_index)
1435   {
1436     _previous_index = previous(self.data, _current_index);
1437   }
1438 
1439   function previous_item(Bytes storage self, bytes32 _current_item)
1440            public
1441            constant
1442            returns (bytes32 _previous_item)
1443   {
1444     _previous_item = previous_item(self.data, _current_item);
1445   }
1446 
1447   function next(Bytes storage self, uint256 _current_index)
1448            public
1449            constant
1450            returns (uint256 _next_index)
1451   {
1452     _next_index = next(self.data, _current_index);
1453   }
1454 
1455   function next_item(Bytes storage self, bytes32 _current_item)
1456            public
1457            constant
1458            returns (bytes32 _next_item)
1459   {
1460     _next_item = next_item(self.data, _current_item);
1461   }
1462 
1463   function append(IndexedBytes storage self, bytes32 _collection_index, bytes32 _data)
1464            public
1465            returns (bool _success)
1466   {
1467     _success = append(self.data[_collection_index], bytes32(_data));
1468   }
1469 
1470   function remove(IndexedBytes storage self, bytes32 _collection_index, uint256 _index)
1471            internal
1472            returns (bool _success)
1473   {
1474     _success = remove(self.data[_collection_index], _index);
1475   }
1476 
1477 
1478   function remove_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _item)
1479            public
1480            returns (bool _success)
1481   {
1482     _success = remove_item(self.data[_collection_index], bytes32(_item));
1483   }
1484 
1485   function total(IndexedBytes storage self, bytes32 _collection_index)
1486            public
1487            constant
1488            returns (uint256 _total_count)
1489   {
1490     _total_count = total(self.data[_collection_index]);
1491   }
1492 
1493   function start(IndexedBytes storage self, bytes32 _collection_index)
1494            public
1495            constant
1496            returns (uint256 _index)
1497   {
1498     _index = start(self.data[_collection_index]);
1499   }
1500 
1501   function start_item(IndexedBytes storage self, bytes32 _collection_index)
1502            public
1503            constant
1504            returns (bytes32 _start_item)
1505   {
1506     _start_item = bytes32(start_item(self.data[_collection_index]));
1507   }
1508 
1509 
1510   function end(IndexedBytes storage self, bytes32 _collection_index)
1511            public
1512            constant
1513            returns (uint256 _index)
1514   {
1515     _index = end(self.data[_collection_index]);
1516   }
1517 
1518   function end_item(IndexedBytes storage self, bytes32 _collection_index)
1519            public
1520            constant
1521            returns (bytes32 _end_item)
1522   {
1523     _end_item = bytes32(end_item(self.data[_collection_index]));
1524   }
1525 
1526   function valid(IndexedBytes storage self, bytes32 _collection_index, uint256 _item_index)
1527            public
1528            constant
1529            returns (bool _yes)
1530   {
1531     _yes = valid(self.data[_collection_index], _item_index);
1532   }
1533 
1534   function valid_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _item)
1535            public
1536            constant
1537            returns (bool _yes)
1538   {
1539     _yes = valid_item(self.data[_collection_index], bytes32(_item));
1540   }
1541 
1542   function previous(IndexedBytes storage self, bytes32 _collection_index, uint256 _current_index)
1543            public
1544            constant
1545            returns (uint256 _previous_index)
1546   {
1547     _previous_index = previous(self.data[_collection_index], _current_index);
1548   }
1549 
1550   function previous_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _current_item)
1551            public
1552            constant
1553            returns (bytes32 _previous_item)
1554   {
1555     _previous_item = bytes32(previous_item(self.data[_collection_index], bytes32(_current_item)));
1556   }
1557 
1558   function next(IndexedBytes storage self, bytes32 _collection_index, uint256 _current_index)
1559            public
1560            constant
1561            returns (uint256 _next_index)
1562   {
1563     _next_index = next(self.data[_collection_index], _current_index);
1564   }
1565 
1566   function next_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _current_item)
1567            public
1568            constant
1569            returns (bytes32 _next_item)
1570   {
1571     _next_item = bytes32(next_item(self.data[_collection_index], bytes32(_current_item)));
1572   }
1573 }
1574 
1575 // File: @digix/solidity-collections/contracts/abstract/BytesIteratorStorage.sol
1576 /**
1577   @title Bytes Iterator Storage
1578   @author DigixGlobal Pte Ltd
1579 */
1580 contract BytesIteratorStorage {
1581 
1582   // Initialize Doubly Linked List of Bytes
1583   using DoublyLinkedList for DoublyLinkedList.Bytes;
1584 
1585   /**
1586     @notice Reads the first item from the list of Bytes
1587     @param _list The source list
1588     @return {"_item": "The first item from the list"}
1589   */
1590   function read_first_from_bytesarray(DoublyLinkedList.Bytes storage _list)
1591            internal
1592            constant
1593            returns (bytes32 _item)
1594   {
1595     _item = _list.start_item();
1596   }
1597 
1598   /**
1599     @notice Reads the last item from the list of Bytes
1600     @param _list The source list
1601     @return {"_item": "The last item from the list"}
1602   */
1603   function read_last_from_bytesarray(DoublyLinkedList.Bytes storage _list)
1604            internal
1605            constant
1606            returns (bytes32 _item)
1607   {
1608     _item = _list.end_item();
1609   }
1610 
1611   /**
1612     @notice Reads the next item on the list of Bytes
1613     @param _list The source list
1614     @param _current_item The current item to be used as base line
1615     @return {"_item": "The next item from the list based on the specieid `_current_item`"}
1616     TODO: Need to verify what happens if the specified `_current_item` is the last item from the list
1617   */
1618   function read_next_from_bytesarray(DoublyLinkedList.Bytes storage _list, bytes32 _current_item)
1619            internal
1620            constant
1621            returns (bytes32 _item)
1622   {
1623     _item = _list.next_item(_current_item);
1624   }
1625 
1626   /**
1627     @notice Reads the previous item on the list of Bytes
1628     @param _list The source list
1629     @param _current_item The current item to be used as base line
1630     @return {"_item": "The previous item from the list based on the spcified `_current_item`"}
1631     TODO: Need to verify what happens if the specified `_current_item` is the first item from the list
1632   */
1633   function read_previous_from_bytesarray(DoublyLinkedList.Bytes storage _list, bytes32 _current_item)
1634            internal
1635            constant
1636            returns (bytes32 _item)
1637   {
1638     _item = _list.previous_item(_current_item);
1639   }
1640 
1641   /**
1642     @notice Reads the list of Bytes and returns the length of the list
1643     @param _list The source list
1644     @return {"count": "`uint256` The lenght of the list"}
1645 
1646   */
1647   function read_total_bytesarray(DoublyLinkedList.Bytes storage _list)
1648            internal
1649            constant
1650            returns (uint256 _count)
1651   {
1652     _count = _list.total();
1653   }
1654 }
1655 
1656 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
1657 /**
1658  * @title SafeMath
1659  * @dev Math operations with safety checks that throw on error
1660  */
1661 library SafeMath {
1662 
1663   /**
1664   * @dev Multiplies two numbers, throws on overflow.
1665   */
1666   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1667     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1668     // benefit is lost if 'b' is also tested.
1669     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1670     if (_a == 0) {
1671       return 0;
1672     }
1673 
1674     c = _a * _b;
1675     assert(c / _a == _b);
1676     return c;
1677   }
1678 
1679   /**
1680   * @dev Integer division of two numbers, truncating the quotient.
1681   */
1682   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1683     // assert(_b > 0); // Solidity automatically throws when dividing by 0
1684     // uint256 c = _a / _b;
1685     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1686     return _a / _b;
1687   }
1688 
1689   /**
1690   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1691   */
1692   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1693     assert(_b <= _a);
1694     return _a - _b;
1695   }
1696 
1697   /**
1698   * @dev Adds two numbers, throws on overflow.
1699   */
1700   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1701     c = _a + _b;
1702     assert(c >= _a);
1703     return c;
1704   }
1705 }
1706 
1707 // File: contracts/common/DaoConstants.sol
1708 contract DaoConstants {
1709     using SafeMath for uint256;
1710     bytes32 EMPTY_BYTES = bytes32(0x0);
1711     address EMPTY_ADDRESS = address(0x0);
1712 
1713 
1714     bytes32 PROPOSAL_STATE_PREPROPOSAL = "proposal_state_preproposal";
1715     bytes32 PROPOSAL_STATE_DRAFT = "proposal_state_draft";
1716     bytes32 PROPOSAL_STATE_MODERATED = "proposal_state_moderated";
1717     bytes32 PROPOSAL_STATE_ONGOING = "proposal_state_ongoing";
1718     bytes32 PROPOSAL_STATE_CLOSED = "proposal_state_closed";
1719     bytes32 PROPOSAL_STATE_ARCHIVED = "proposal_state_archived";
1720 
1721     uint256 PRL_ACTION_STOP = 1;
1722     uint256 PRL_ACTION_PAUSE = 2;
1723     uint256 PRL_ACTION_UNPAUSE = 3;
1724 
1725     uint256 COLLATERAL_STATUS_UNLOCKED = 1;
1726     uint256 COLLATERAL_STATUS_LOCKED = 2;
1727     uint256 COLLATERAL_STATUS_CLAIMED = 3;
1728 
1729     bytes32 INTERMEDIATE_DGD_IDENTIFIER = "inter_dgd_id";
1730     bytes32 INTERMEDIATE_MODERATOR_DGD_IDENTIFIER = "inter_mod_dgd_id";
1731     bytes32 INTERMEDIATE_BONUS_CALCULATION_IDENTIFIER = "inter_bonus_calculation_id";
1732 
1733     // interactive contracts
1734     bytes32 CONTRACT_DAO = "dao";
1735     bytes32 CONTRACT_DAO_SPECIAL_PROPOSAL = "dao:special:proposal";
1736     bytes32 CONTRACT_DAO_STAKE_LOCKING = "dao:stake-locking";
1737     bytes32 CONTRACT_DAO_VOTING = "dao:voting";
1738     bytes32 CONTRACT_DAO_VOTING_CLAIMS = "dao:voting:claims";
1739     bytes32 CONTRACT_DAO_SPECIAL_VOTING_CLAIMS = "dao:svoting:claims";
1740     bytes32 CONTRACT_DAO_IDENTITY = "dao:identity";
1741     bytes32 CONTRACT_DAO_REWARDS_MANAGER = "dao:rewards-manager";
1742     bytes32 CONTRACT_DAO_REWARDS_MANAGER_EXTRAS = "dao:rewards-extras";
1743     bytes32 CONTRACT_DAO_ROLES = "dao:roles";
1744     bytes32 CONTRACT_DAO_FUNDING_MANAGER = "dao:funding-manager";
1745     bytes32 CONTRACT_DAO_WHITELISTING = "dao:whitelisting";
1746     bytes32 CONTRACT_DAO_INFORMATION = "dao:information";
1747 
1748     // service contracts
1749     bytes32 CONTRACT_SERVICE_ROLE = "service:role";
1750     bytes32 CONTRACT_SERVICE_DAO_INFO = "service:dao:info";
1751     bytes32 CONTRACT_SERVICE_DAO_LISTING = "service:dao:listing";
1752     bytes32 CONTRACT_SERVICE_DAO_CALCULATOR = "service:dao:calculator";
1753 
1754     // storage contracts
1755     bytes32 CONTRACT_STORAGE_DAO = "storage:dao";
1756     bytes32 CONTRACT_STORAGE_DAO_COUNTER = "storage:dao:counter";
1757     bytes32 CONTRACT_STORAGE_DAO_UPGRADE = "storage:dao:upgrade";
1758     bytes32 CONTRACT_STORAGE_DAO_IDENTITY = "storage:dao:identity";
1759     bytes32 CONTRACT_STORAGE_DAO_POINTS = "storage:dao:points";
1760     bytes32 CONTRACT_STORAGE_DAO_SPECIAL = "storage:dao:special";
1761     bytes32 CONTRACT_STORAGE_DAO_CONFIG = "storage:dao:config";
1762     bytes32 CONTRACT_STORAGE_DAO_STAKE = "storage:dao:stake";
1763     bytes32 CONTRACT_STORAGE_DAO_REWARDS = "storage:dao:rewards";
1764     bytes32 CONTRACT_STORAGE_DAO_WHITELISTING = "storage:dao:whitelisting";
1765     bytes32 CONTRACT_STORAGE_INTERMEDIATE_RESULTS = "storage:intermediate:results";
1766 
1767     bytes32 CONTRACT_DGD_TOKEN = "t:dgd";
1768     bytes32 CONTRACT_DGX_TOKEN = "t:dgx";
1769     bytes32 CONTRACT_BADGE_TOKEN = "t:badge";
1770 
1771     uint8 ROLES_ROOT = 1;
1772     uint8 ROLES_FOUNDERS = 2;
1773     uint8 ROLES_PRLS = 3;
1774     uint8 ROLES_KYC_ADMINS = 4;
1775 
1776     uint256 QUARTER_DURATION = 90 days;
1777 
1778     bytes32 CONFIG_MINIMUM_LOCKED_DGD = "min_dgd_participant";
1779     bytes32 CONFIG_MINIMUM_DGD_FOR_MODERATOR = "min_dgd_moderator";
1780     bytes32 CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR = "min_reputation_moderator";
1781 
1782     bytes32 CONFIG_LOCKING_PHASE_DURATION = "locking_phase_duration";
1783     bytes32 CONFIG_QUARTER_DURATION = "quarter_duration";
1784     bytes32 CONFIG_VOTING_COMMIT_PHASE = "voting_commit_phase";
1785     bytes32 CONFIG_VOTING_PHASE_TOTAL = "voting_phase_total";
1786     bytes32 CONFIG_INTERIM_COMMIT_PHASE = "interim_voting_commit_phase";
1787     bytes32 CONFIG_INTERIM_PHASE_TOTAL = "interim_voting_phase_total";
1788 
1789     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR = "draft_quorum_fixed_numerator";
1790     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR = "draft_quorum_fixed_denominator";
1791     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR = "draft_quorum_sfactor_numerator";
1792     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR = "draft_quorum_sfactor_denominator";
1793     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR = "vote_quorum_fixed_numerator";
1794     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR = "vote_quorum_fixed_denominator";
1795     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR = "vote_quorum_sfactor_numerator";
1796     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR = "vote_quorum_sfactor_denominator";
1797     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR = "final_reward_sfactor_numerator";
1798     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR = "final_reward_sfactor_denominator";
1799 
1800     bytes32 CONFIG_DRAFT_QUOTA_NUMERATOR = "draft_quota_numerator";
1801     bytes32 CONFIG_DRAFT_QUOTA_DENOMINATOR = "draft_quota_denominator";
1802     bytes32 CONFIG_VOTING_QUOTA_NUMERATOR = "voting_quota_numerator";
1803     bytes32 CONFIG_VOTING_QUOTA_DENOMINATOR = "voting_quota_denominator";
1804 
1805     bytes32 CONFIG_MINIMAL_QUARTER_POINT = "minimal_qp";
1806     bytes32 CONFIG_QUARTER_POINT_SCALING_FACTOR = "quarter_point_scaling_factor";
1807     bytes32 CONFIG_REPUTATION_POINT_SCALING_FACTOR = "rep_point_scaling_factor";
1808 
1809     bytes32 CONFIG_MODERATOR_MINIMAL_QUARTER_POINT = "minimal_mod_qp";
1810     bytes32 CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR = "mod_qp_scaling_factor";
1811     bytes32 CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR = "mod_rep_point_scaling_factor";
1812 
1813     bytes32 CONFIG_QUARTER_POINT_DRAFT_VOTE = "quarter_point_draft_vote";
1814     bytes32 CONFIG_QUARTER_POINT_VOTE = "quarter_point_vote";
1815     bytes32 CONFIG_QUARTER_POINT_INTERIM_VOTE = "quarter_point_interim_vote";
1816 
1817     /// this is per 10000 ETHs
1818     bytes32 CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH = "q_p_milestone_completion";
1819 
1820     bytes32 CONFIG_BONUS_REPUTATION_NUMERATOR = "bonus_reputation_numerator";
1821     bytes32 CONFIG_BONUS_REPUTATION_DENOMINATOR = "bonus_reputation_denominator";
1822 
1823     bytes32 CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE = "special_proposal_commit_phase";
1824     bytes32 CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL = "special_proposal_phase_total";
1825 
1826     bytes32 CONFIG_SPECIAL_QUOTA_NUMERATOR = "config_special_quota_numerator";
1827     bytes32 CONFIG_SPECIAL_QUOTA_DENOMINATOR = "config_special_quota_denominator";
1828 
1829     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR = "special_quorum_numerator";
1830     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR = "special_quorum_denominator";
1831 
1832     bytes32 CONFIG_MAXIMUM_REPUTATION_DEDUCTION = "config_max_reputation_deduction";
1833     bytes32 CONFIG_PUNISHMENT_FOR_NOT_LOCKING = "config_punishment_not_locking";
1834 
1835     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_NUM = "config_rep_per_extra_qp_num";
1836     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_DEN = "config_rep_per_extra_qp_den";
1837 
1838     bytes32 CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION = "config_max_m_rp_deduction";
1839     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM = "config_rep_per_extra_m_qp_num";
1840     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN = "config_rep_per_extra_m_qp_den";
1841 
1842     bytes32 CONFIG_PORTION_TO_MODERATORS_NUM = "config_mod_portion_num";
1843     bytes32 CONFIG_PORTION_TO_MODERATORS_DEN = "config_mod_portion_den";
1844 
1845     bytes32 CONFIG_DRAFT_VOTING_PHASE = "config_draft_voting_phase";
1846 
1847     bytes32 CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE = "config_rp_boost_per_badge";
1848 
1849     bytes32 CONFIG_VOTE_CLAIMING_DEADLINE = "config_claiming_deadline";
1850 
1851     bytes32 CONFIG_PREPROPOSAL_COLLATERAL = "config_preproposal_collateral";
1852 
1853     bytes32 CONFIG_MAX_FUNDING_FOR_NON_DIGIX = "config_max_funding_nonDigix";
1854     bytes32 CONFIG_MAX_MILESTONES_FOR_NON_DIGIX = "config_max_milestones_nonDigix";
1855     bytes32 CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER = "config_nonDigix_proposal_cap";
1856 
1857     bytes32 CONFIG_PROPOSAL_DEAD_DURATION = "config_dead_duration";
1858     bytes32 CONFIG_CARBON_VOTE_REPUTATION_BONUS = "config_cv_reputation";
1859 }
1860 
1861 // File: @digix/cacp-contracts-dao/contracts/ACOwned.sol
1862 /// @title Owner based access control
1863 /// @author DigixGlobal
1864 contract ACOwned {
1865 
1866   address public owner;
1867   address public new_owner;
1868   bool is_ac_owned_init;
1869 
1870   /// @dev Modifier to check if msg.sender is the contract owner
1871   modifier if_owner() {
1872     require(is_owner());
1873     _;
1874   }
1875 
1876   function init_ac_owned()
1877            internal
1878            returns (bool _success)
1879   {
1880     if (is_ac_owned_init == false) {
1881       owner = msg.sender;
1882       is_ac_owned_init = true;
1883     }
1884     _success = true;
1885   }
1886 
1887   function is_owner()
1888            private
1889            constant
1890            returns (bool _is_owner)
1891   {
1892     _is_owner = (msg.sender == owner);
1893   }
1894 
1895   function change_owner(address _new_owner)
1896            if_owner()
1897            public
1898            returns (bool _success)
1899   {
1900     new_owner = _new_owner;
1901     _success = true;
1902   }
1903 
1904   function claim_ownership()
1905            public
1906            returns (bool _success)
1907   {
1908     require(msg.sender == new_owner);
1909     owner = new_owner;
1910     _success = true;
1911   }
1912 }
1913 
1914 // File: @digix/cacp-contracts-dao/contracts/Constants.sol
1915 /// @title Some useful constants
1916 /// @author DigixGlobal
1917 contract Constants {
1918   address constant NULL_ADDRESS = address(0x0);
1919   uint256 constant ZERO = uint256(0);
1920   bytes32 constant EMPTY = bytes32(0x0);
1921 }
1922 
1923 // File: @digix/cacp-contracts-dao/contracts/ContractResolver.sol
1924 /// @title Contract Name Registry
1925 /// @author DigixGlobal
1926 contract ContractResolver is ACOwned, Constants {
1927 
1928   mapping (bytes32 => address) contracts;
1929   bool public locked_forever;
1930 
1931   modifier unless_registered(bytes32 _key) {
1932     require(contracts[_key] == NULL_ADDRESS);
1933     _;
1934   }
1935 
1936   modifier if_owner_origin() {
1937     require(tx.origin == owner);
1938     _;
1939   }
1940 
1941   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
1942   /// @param _contract The resolver key
1943   modifier if_sender_is(bytes32 _contract) {
1944     require(msg.sender == get_contract(_contract));
1945     _;
1946   }
1947 
1948   modifier if_not_locked() {
1949     require(locked_forever == false);
1950     _;
1951   }
1952 
1953   /// @dev ContractResolver constructor will perform the following: 1. Set msg.sender as the contract owner.
1954   constructor() public
1955   {
1956     require(init_ac_owned());
1957     locked_forever = false;
1958   }
1959 
1960   /// @dev Called at contract initialization
1961   /// @param _key bytestring for CACP name
1962   /// @param _contract_address The address of the contract to be registered
1963   /// @return _success if the operation is successful
1964   function init_register_contract(bytes32 _key, address _contract_address)
1965            if_owner_origin()
1966            if_not_locked()
1967            unless_registered(_key)
1968            public
1969            returns (bool _success)
1970   {
1971     require(_contract_address != NULL_ADDRESS);
1972     contracts[_key] = _contract_address;
1973     _success = true;
1974   }
1975 
1976   /// @dev Lock the resolver from any further modifications.  This can only be called from the owner
1977   /// @return _success if the operation is successful
1978   function lock_resolver_forever()
1979            if_owner
1980            public
1981            returns (bool _success)
1982   {
1983     locked_forever = true;
1984     _success = true;
1985   }
1986 
1987   /// @dev Get address of a contract
1988   /// @param _key the bytestring name of the contract to look up
1989   /// @return _contract the address of the contract
1990   function get_contract(bytes32 _key)
1991            public
1992            view
1993            returns (address _contract)
1994   {
1995     require(contracts[_key] != NULL_ADDRESS);
1996     _contract = contracts[_key];
1997   }
1998 }
1999 
2000 // File: @digix/cacp-contracts-dao/contracts/ResolverClient.sol
2001 /// @title Contract Resolver Interface
2002 /// @author DigixGlobal
2003 contract ResolverClient {
2004 
2005   /// The address of the resolver contract for this project
2006   address public resolver;
2007   bytes32 public key;
2008 
2009   /// Make our own address available to us as a constant
2010   address public CONTRACT_ADDRESS;
2011 
2012   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
2013   /// @param _contract The resolver key
2014   modifier if_sender_is(bytes32 _contract) {
2015     require(sender_is(_contract));
2016     _;
2017   }
2018 
2019   function sender_is(bytes32 _contract) internal view returns (bool _isFrom) {
2020     _isFrom = msg.sender == ContractResolver(resolver).get_contract(_contract);
2021   }
2022 
2023   modifier if_sender_is_from(bytes32[3] _contracts) {
2024     require(sender_is_from(_contracts));
2025     _;
2026   }
2027 
2028   function sender_is_from(bytes32[3] _contracts) internal view returns (bool _isFrom) {
2029     uint256 _n = _contracts.length;
2030     for (uint256 i = 0; i < _n; i++) {
2031       if (_contracts[i] == bytes32(0x0)) continue;
2032       if (msg.sender == ContractResolver(resolver).get_contract(_contracts[i])) {
2033         _isFrom = true;
2034         break;
2035       }
2036     }
2037   }
2038 
2039   /// Function modifier to check resolver's locking status.
2040   modifier unless_resolver_is_locked() {
2041     require(is_locked() == false);
2042     _;
2043   }
2044 
2045   /// @dev Initialize new contract
2046   /// @param _key the resolver key for this contract
2047   /// @return _success if the initialization is successful
2048   function init(bytes32 _key, address _resolver)
2049            internal
2050            returns (bool _success)
2051   {
2052     bool _is_locked = ContractResolver(_resolver).locked_forever();
2053     if (_is_locked == false) {
2054       CONTRACT_ADDRESS = address(this);
2055       resolver = _resolver;
2056       key = _key;
2057       require(ContractResolver(resolver).init_register_contract(key, CONTRACT_ADDRESS));
2058       _success = true;
2059     }  else {
2060       _success = false;
2061     }
2062   }
2063 
2064   /// @dev Check if resolver is locked
2065   /// @return _locked if the resolver is currently locked
2066   function is_locked()
2067            private
2068            view
2069            returns (bool _locked)
2070   {
2071     _locked = ContractResolver(resolver).locked_forever();
2072   }
2073 
2074   /// @dev Get the address of a contract
2075   /// @param _key the resolver key to look up
2076   /// @return _contract the address of the contract
2077   function get_contract(bytes32 _key)
2078            public
2079            view
2080            returns (address _contract)
2081   {
2082     _contract = ContractResolver(resolver).get_contract(_key);
2083   }
2084 }
2085 
2086 // File: contracts/storage/DaoWhitelistingStorage.sol
2087 // This contract is basically created to restrict read access to
2088 // ethereum accounts, and whitelisted contracts
2089 contract DaoWhitelistingStorage is ResolverClient, DaoConstants {
2090 
2091     // we want to avoid the scenario in which an on-chain bribing contract
2092     // can be deployed to distribute funds in a trustless way by verifying
2093     // on-chain votes. This mapping marks whether a contract address is whitelisted
2094     // to read from the read functions in DaoStorage, DaoSpecialStorage, etc.
2095     mapping (address => bool) public whitelist;
2096 
2097     constructor(address _resolver)
2098         public
2099     {
2100         require(init(CONTRACT_STORAGE_DAO_WHITELISTING, _resolver));
2101     }
2102 
2103     function setWhitelisted(address _contractAddress, bool _senderIsAllowedToRead)
2104         public
2105     {
2106         require(sender_is(CONTRACT_DAO_WHITELISTING));
2107         whitelist[_contractAddress] = _senderIsAllowedToRead;
2108     }
2109 }
2110 
2111 // File: contracts/common/DaoWhitelistingCommon.sol
2112 contract DaoWhitelistingCommon is ResolverClient, DaoConstants {
2113 
2114     function daoWhitelistingStorage()
2115         internal
2116         view
2117         returns (DaoWhitelistingStorage _contract)
2118     {
2119         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
2120     }
2121 
2122     /**
2123     @notice Check if a certain address is whitelisted to read sensitive information in the storage layer
2124     @dev if the address is an account, it is allowed to read. If the address is a contract, it has to be in the whitelist
2125     */
2126     function senderIsAllowedToRead()
2127         internal
2128         view
2129         returns (bool _senderIsAllowedToRead)
2130     {
2131         // msg.sender is allowed to read only if its an EOA or a whitelisted contract
2132         _senderIsAllowedToRead = (msg.sender == tx.origin) || daoWhitelistingStorage().whitelist(msg.sender);
2133     }
2134 }
2135 
2136 // File: contracts/lib/DaoStructs.sol
2137 library DaoStructs {
2138     using DoublyLinkedList for DoublyLinkedList.Bytes;
2139     using SafeMath for uint256;
2140     bytes32 constant EMPTY_BYTES = bytes32(0x0);
2141 
2142     struct PrlAction {
2143         // UTC timestamp at which the PRL action was done
2144         uint256 at;
2145 
2146         // IPFS hash of the document summarizing the action
2147         bytes32 doc;
2148 
2149         // Type of action
2150         // check PRL_ACTION_* in "./../common/DaoConstants.sol"
2151         uint256 actionId;
2152     }
2153 
2154     struct Voting {
2155         // UTC timestamp at which the voting round starts
2156         uint256 startTime;
2157 
2158         // Mapping of whether a commit was used in this voting round
2159         mapping (bytes32 => bool) usedCommits;
2160 
2161         // Mapping of commits by address. These are the commits during the commit phase in a voting round
2162         // This only stores the most recent commit in the voting round
2163         // In case a vote is edited, the previous commit is overwritten by the new commit
2164         // Only this new commit is verified at the reveal phase
2165         mapping (address => bytes32) commits;
2166 
2167         // This mapping is updated after the reveal phase, when votes are revealed
2168         // It is a mapping of address to weight of vote
2169         // Weight implies the lockedDGDStake of the address, at the time of revealing
2170         // If the address voted "NO", or didn't vote, this would be 0
2171         mapping (address => uint256) yesVotes;
2172 
2173         // This mapping is updated after the reveal phase, when votes are revealed
2174         // It is a mapping of address to weight of vote
2175         // Weight implies the lockedDGDStake of the address, at the time of revealing
2176         // If the address voted "YES", or didn't vote, this would be 0
2177         mapping (address => uint256) noVotes;
2178 
2179         // Boolean whether the voting round passed or not
2180         bool passed;
2181 
2182         // Boolean whether the voting round results were claimed or not
2183         // refer the claimProposalVotingResult function in "./../interative/DaoVotingClaims.sol"
2184         bool claimed;
2185 
2186         // Boolean whether the milestone following this voting round was funded or not
2187         // The milestone is funded when the proposer calls claimFunding in "./../interactive/DaoFundingManager.sol"
2188         bool funded;
2189     }
2190 
2191     struct ProposalVersion {
2192         // IPFS doc hash of this version of the proposal
2193         bytes32 docIpfsHash;
2194 
2195         // UTC timestamp at which this version was created
2196         uint256 created;
2197 
2198         // The number of milestones in the proposal as per this version
2199         uint256 milestoneCount;
2200 
2201         // The final reward asked by the proposer for completion of the entire proposal
2202         uint256 finalReward;
2203 
2204         // List of fundings required by the proposal as per this version
2205         // The numbers are in wei
2206         uint256[] milestoneFundings;
2207 
2208         // When a proposal is finalized (calling Dao.finalizeProposal), the proposer can no longer add proposal versions
2209         // However, they can still add more details to this final proposal version, in the form of IPFS docs.
2210         // These IPFS docs are stored in this array
2211         bytes32[] moreDocs;
2212     }
2213 
2214     struct Proposal {
2215         // ID of the proposal. Also the IPFS hash of the first ProposalVersion
2216         bytes32 proposalId;
2217 
2218         // current state of the proposal
2219         // refer PROPOSAL_STATE_* in "./../common/DaoConstants.sol"
2220         bytes32 currentState;
2221 
2222         // UTC timestamp at which the proposal was created
2223         uint256 timeCreated;
2224 
2225         // DoublyLinkedList of IPFS doc hashes of the various versions of the proposal
2226         DoublyLinkedList.Bytes proposalVersionDocs;
2227 
2228         // Mapping of version (IPFS doc hash) to ProposalVersion struct
2229         mapping (bytes32 => ProposalVersion) proposalVersions;
2230 
2231         // Voting struct for the draft voting round
2232         Voting draftVoting;
2233 
2234         // Mapping of voting round index (starts from 0) to Voting struct
2235         // votingRounds[0] is the Voting round of the proposal, which lasts for get_uint_config(CONFIG_VOTING_PHASE_TOTAL)
2236         // votingRounds[i] for i>0 are the Interim Voting rounds of the proposal, which lasts for get_uint_config(CONFIG_INTERIM_PHASE_TOTAL)
2237         mapping (uint256 => Voting) votingRounds;
2238 
2239         // Every proposal has a collateral tied to it with a value of
2240         // get_uint_config(CONFIG_PREPROPOSAL_COLLATERAL) (refer "./../storage/DaoConfigsStorage.sol")
2241         // Collateral can be in different states
2242         // refer COLLATERAL_STATUS_* in "./../common/DaoConstants.sol"
2243         uint256 collateralStatus;
2244         uint256 collateralAmount;
2245 
2246         // The final version of the proposal
2247         // Every proposal needs to be finalized before it can be voted on
2248         // This is the IPFS doc hash of the final version
2249         bytes32 finalVersion;
2250 
2251         // List of PrlAction structs
2252         // These are all the actions done by the PRL on the proposal
2253         PrlAction[] prlActions;
2254 
2255         // Address of the user who created the proposal
2256         address proposer;
2257 
2258         // Address of the moderator who endorsed the proposal
2259         address endorser;
2260 
2261         // Boolean whether the proposal is paused/stopped at the moment
2262         bool isPausedOrStopped;
2263 
2264         // Boolean whether the proposal was created by a founder role
2265         bool isDigix;
2266     }
2267 
2268     function countVotes(Voting storage _voting, address[] _allUsers)
2269         external
2270         view
2271         returns (uint256 _for, uint256 _against)
2272     {
2273         uint256 _n = _allUsers.length;
2274         for (uint256 i = 0; i < _n; i++) {
2275             if (_voting.yesVotes[_allUsers[i]] > 0) {
2276                 _for = _for.add(_voting.yesVotes[_allUsers[i]]);
2277             } else if (_voting.noVotes[_allUsers[i]] > 0) {
2278                 _against = _against.add(_voting.noVotes[_allUsers[i]]);
2279             }
2280         }
2281     }
2282 
2283     // get the list of voters who voted _vote (true-yes/false-no)
2284     function listVotes(Voting storage _voting, address[] _allUsers, bool _vote)
2285         external
2286         view
2287         returns (address[] memory _voters, uint256 _length)
2288     {
2289         uint256 _n = _allUsers.length;
2290         uint256 i;
2291         _length = 0;
2292         _voters = new address[](_n);
2293         if (_vote == true) {
2294             for (i = 0; i < _n; i++) {
2295                 if (_voting.yesVotes[_allUsers[i]] > 0) {
2296                     _voters[_length] = _allUsers[i];
2297                     _length++;
2298                 }
2299             }
2300         } else {
2301             for (i = 0; i < _n; i++) {
2302                 if (_voting.noVotes[_allUsers[i]] > 0) {
2303                     _voters[_length] = _allUsers[i];
2304                     _length++;
2305                 }
2306             }
2307         }
2308     }
2309 
2310     function readVote(Voting storage _voting, address _voter)
2311         public
2312         view
2313         returns (bool _vote, uint256 _weight)
2314     {
2315         if (_voting.yesVotes[_voter] > 0) {
2316             _weight = _voting.yesVotes[_voter];
2317             _vote = true;
2318         } else {
2319             _weight = _voting.noVotes[_voter]; // if _voter didnt vote at all, the weight will be 0 anyway
2320             _vote = false;
2321         }
2322     }
2323 
2324     function revealVote(
2325         Voting storage _voting,
2326         address _voter,
2327         bool _vote,
2328         uint256 _weight
2329     )
2330         public
2331     {
2332         if (_vote) {
2333             _voting.yesVotes[_voter] = _weight;
2334         } else {
2335             _voting.noVotes[_voter] = _weight;
2336         }
2337     }
2338 
2339     function readVersion(ProposalVersion storage _version)
2340         public
2341         view
2342         returns (
2343             bytes32 _doc,
2344             uint256 _created,
2345             uint256[] _milestoneFundings,
2346             uint256 _finalReward
2347         )
2348     {
2349         _doc = _version.docIpfsHash;
2350         _created = _version.created;
2351         _milestoneFundings = _version.milestoneFundings;
2352         _finalReward = _version.finalReward;
2353     }
2354 
2355     // read the funding for a particular milestone of a finalized proposal
2356     // if _milestoneId is the same as _milestoneCount, it returns the final reward
2357     function readProposalMilestone(Proposal storage _proposal, uint256 _milestoneIndex)
2358         public
2359         view
2360         returns (uint256 _funding)
2361     {
2362         bytes32 _finalVersion = _proposal.finalVersion;
2363         uint256 _milestoneCount = _proposal.proposalVersions[_finalVersion].milestoneFundings.length;
2364         require(_milestoneIndex <= _milestoneCount);
2365         require(_finalVersion != EMPTY_BYTES); // the proposal must have been finalized
2366 
2367         if (_milestoneIndex < _milestoneCount) {
2368             _funding = _proposal.proposalVersions[_finalVersion].milestoneFundings[_milestoneIndex];
2369         } else {
2370             _funding = _proposal.proposalVersions[_finalVersion].finalReward;
2371         }
2372     }
2373 
2374     function addProposalVersion(
2375         Proposal storage _proposal,
2376         bytes32 _newDoc,
2377         uint256[] _newMilestoneFundings,
2378         uint256 _finalReward
2379     )
2380         public
2381     {
2382         _proposal.proposalVersionDocs.append(_newDoc);
2383         _proposal.proposalVersions[_newDoc].docIpfsHash = _newDoc;
2384         _proposal.proposalVersions[_newDoc].created = now;
2385         _proposal.proposalVersions[_newDoc].milestoneCount = _newMilestoneFundings.length;
2386         _proposal.proposalVersions[_newDoc].milestoneFundings = _newMilestoneFundings;
2387         _proposal.proposalVersions[_newDoc].finalReward = _finalReward;
2388     }
2389 
2390     struct SpecialProposal {
2391         // ID of the special proposal
2392         // This is the IPFS doc hash of the proposal
2393         bytes32 proposalId;
2394 
2395         // UTC timestamp at which the proposal was created
2396         uint256 timeCreated;
2397 
2398         // Voting struct for the special proposal
2399         Voting voting;
2400 
2401         // List of the new uint256 configs as per the special proposal
2402         uint256[] uintConfigs;
2403 
2404         // List of the new address configs as per the special proposal
2405         address[] addressConfigs;
2406 
2407         // List of the new bytes32 configs as per the special proposal
2408         bytes32[] bytesConfigs;
2409 
2410         // Address of the user who created the special proposal
2411         // This address should also be in the ROLES_FOUNDERS group
2412         // refer "./../storage/DaoIdentityStorage.sol"
2413         address proposer;
2414     }
2415 
2416     // All configs are as per the DaoConfigsStorage values at the time when
2417     // calculateGlobalRewardsBeforeNewQuarter is called by founder in that quarter
2418     struct DaoQuarterInfo {
2419         // The minimum quarter points required
2420         // below this, reputation will be deducted
2421         uint256 minimalParticipationPoint;
2422 
2423         // The scaling factor for quarter point
2424         uint256 quarterPointScalingFactor;
2425 
2426         // The scaling factor for reputation point
2427         uint256 reputationPointScalingFactor;
2428 
2429         // The summation of effectiveDGDs in the previous quarter
2430         // The effectiveDGDs represents the effective participation in DigixDAO in a quarter
2431         // Which depends on lockedDGDStake, quarter point and reputation point
2432         // This value is the summation of all participant effectiveDGDs
2433         // It will be used to calculate the fraction of effectiveDGD a user has,
2434         // which will determine his portion of DGX rewards for that quarter
2435         uint256 totalEffectiveDGDPreviousQuarter;
2436 
2437         // The minimum moderator quarter point required
2438         // below this, reputation will be deducted for moderators
2439         uint256 moderatorMinimalParticipationPoint;
2440 
2441         // the scaling factor for moderator quarter point
2442         uint256 moderatorQuarterPointScalingFactor;
2443 
2444         // the scaling factor for moderator reputation point
2445         uint256 moderatorReputationPointScalingFactor;
2446 
2447         // The summation of effectiveDGDs (only specific to moderators)
2448         uint256 totalEffectiveModeratorDGDLastQuarter;
2449 
2450         // UTC timestamp from which the DGX rewards for the previous quarter are distributable to Holders
2451         uint256 dgxDistributionDay;
2452 
2453         // This is the rewards pool for the previous quarter. This is the sum of the DGX fees coming in from the collector, and the demurrage that has incurred
2454         // when user call claimRewards() in the previous quarter.
2455         // more graphical explanation: https://ipfs.io/ipfs/QmZDgFFMbyF3dvuuDfoXv5F6orq4kaDPo7m3QvnseUguzo
2456         uint256 dgxRewardsPoolLastQuarter;
2457 
2458         // The summation of all dgxRewardsPoolLastQuarter up until this quarter
2459         uint256 sumRewardsFromBeginning;
2460     }
2461 
2462     // There are many function calls where all calculations/summations cannot be done in one transaction
2463     // and require multiple transactions.
2464     // This struct stores the intermediate results in between the calculating transactions
2465     // These intermediate results are stored in IntermediateResultsStorage
2466     struct IntermediateResults {
2467         // weight of "FOR" votes counted up until the current calculation step
2468         uint256 currentForCount;
2469 
2470         // weight of "AGAINST" votes counted up until the current calculation step
2471         uint256 currentAgainstCount;
2472 
2473         // summation of effectiveDGDs up until the iteration of calculation
2474         uint256 currentSumOfEffectiveBalance;
2475 
2476         // Address of user until which the calculation has been done
2477         address countedUntil;
2478     }
2479 }
2480 
2481 // File: contracts/storage/DaoStorage.sol
2482 contract DaoStorage is DaoWhitelistingCommon, BytesIteratorStorage {
2483     using DoublyLinkedList for DoublyLinkedList.Bytes;
2484     using DaoStructs for DaoStructs.Voting;
2485     using DaoStructs for DaoStructs.Proposal;
2486     using DaoStructs for DaoStructs.ProposalVersion;
2487 
2488     // List of all the proposals ever created in DigixDAO
2489     DoublyLinkedList.Bytes allProposals;
2490 
2491     // mapping of Proposal struct by its ID
2492     // ID is also the IPFS doc hash of the first ever version of this proposal
2493     mapping (bytes32 => DaoStructs.Proposal) proposalsById;
2494 
2495     // mapping from state of a proposal to list of all proposals in that state
2496     // proposals are added/removed from the state's list as their states change
2497     // eg. when proposal is endorsed, when proposal is funded, etc
2498     mapping (bytes32 => DoublyLinkedList.Bytes) proposalsByState;
2499 
2500     constructor(address _resolver) public {
2501         require(init(CONTRACT_STORAGE_DAO, _resolver));
2502     }
2503 
2504     /////////////////////////////// READ FUNCTIONS //////////////////////////////
2505 
2506     /// @notice read all information and details of proposal
2507     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc Proposal ID, i.e. hash of IPFS doc
2508     /// return {
2509     ///   "_doc": "Original IPFS doc of proposal, also ID of proposal",
2510     ///   "_proposer": "Address of the proposer",
2511     ///   "_endorser": "Address of the moderator that endorsed the proposal",
2512     ///   "_state": "Current state of the proposal",
2513     ///   "_timeCreated": "UTC timestamp at which proposal was created",
2514     ///   "_nVersions": "Number of versions of the proposal",
2515     ///   "_latestVersionDoc": "IPFS doc hash of the latest version of this proposal",
2516     ///   "_finalVersion": "If finalized, the version of the final proposal",
2517     ///   "_pausedOrStopped": "If the proposal is paused/stopped at the moment",
2518     ///   "_isDigixProposal": "If the proposal has been created by founder or not"
2519     /// }
2520     function readProposal(bytes32 _proposalId)
2521         public
2522         view
2523         returns (
2524             bytes32 _doc,
2525             address _proposer,
2526             address _endorser,
2527             bytes32 _state,
2528             uint256 _timeCreated,
2529             uint256 _nVersions,
2530             bytes32 _latestVersionDoc,
2531             bytes32 _finalVersion,
2532             bool _pausedOrStopped,
2533             bool _isDigixProposal
2534         )
2535     {
2536         require(senderIsAllowedToRead());
2537         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2538         _doc = _proposal.proposalId;
2539         _proposer = _proposal.proposer;
2540         _endorser = _proposal.endorser;
2541         _state = _proposal.currentState;
2542         _timeCreated = _proposal.timeCreated;
2543         _nVersions = read_total_bytesarray(_proposal.proposalVersionDocs);
2544         _latestVersionDoc = read_last_from_bytesarray(_proposal.proposalVersionDocs);
2545         _finalVersion = _proposal.finalVersion;
2546         _pausedOrStopped = _proposal.isPausedOrStopped;
2547         _isDigixProposal = _proposal.isDigix;
2548     }
2549 
2550     function readProposalProposer(bytes32 _proposalId)
2551         public
2552         view
2553         returns (address _proposer)
2554     {
2555         _proposer = proposalsById[_proposalId].proposer;
2556     }
2557 
2558     function readTotalPrlActions(bytes32 _proposalId)
2559         public
2560         view
2561         returns (uint256 _length)
2562     {
2563         _length = proposalsById[_proposalId].prlActions.length;
2564     }
2565 
2566     function readPrlAction(bytes32 _proposalId, uint256 _index)
2567         public
2568         view
2569         returns (uint256 _actionId, uint256 _time, bytes32 _doc)
2570     {
2571         DaoStructs.PrlAction[] memory _actions = proposalsById[_proposalId].prlActions;
2572         require(_index < _actions.length);
2573         _actionId = _actions[_index].actionId;
2574         _time = _actions[_index].at;
2575         _doc = _actions[_index].doc;
2576     }
2577 
2578     function readProposalDraftVotingResult(bytes32 _proposalId)
2579         public
2580         view
2581         returns (bool _result)
2582     {
2583         require(senderIsAllowedToRead());
2584         _result = proposalsById[_proposalId].draftVoting.passed;
2585     }
2586 
2587     function readProposalVotingResult(bytes32 _proposalId, uint256 _index)
2588         public
2589         view
2590         returns (bool _result)
2591     {
2592         require(senderIsAllowedToRead());
2593         _result = proposalsById[_proposalId].votingRounds[_index].passed;
2594     }
2595 
2596     function readProposalDraftVotingTime(bytes32 _proposalId)
2597         public
2598         view
2599         returns (uint256 _start)
2600     {
2601         require(senderIsAllowedToRead());
2602         _start = proposalsById[_proposalId].draftVoting.startTime;
2603     }
2604 
2605     function readProposalVotingTime(bytes32 _proposalId, uint256 _index)
2606         public
2607         view
2608         returns (uint256 _start)
2609     {
2610         require(senderIsAllowedToRead());
2611         _start = proposalsById[_proposalId].votingRounds[_index].startTime;
2612     }
2613 
2614     function readDraftVotingCount(bytes32 _proposalId, address[] _allUsers)
2615         external
2616         view
2617         returns (uint256 _for, uint256 _against)
2618     {
2619         require(senderIsAllowedToRead());
2620         return proposalsById[_proposalId].draftVoting.countVotes(_allUsers);
2621     }
2622 
2623     function readVotingCount(bytes32 _proposalId, uint256 _index, address[] _allUsers)
2624         external
2625         view
2626         returns (uint256 _for, uint256 _against)
2627     {
2628         require(senderIsAllowedToRead());
2629         return proposalsById[_proposalId].votingRounds[_index].countVotes(_allUsers);
2630     }
2631 
2632     function readVotingRoundVotes(bytes32 _proposalId, uint256 _index, address[] _allUsers, bool _vote)
2633         external
2634         view
2635         returns (address[] memory _voters, uint256 _length)
2636     {
2637         require(senderIsAllowedToRead());
2638         return proposalsById[_proposalId].votingRounds[_index].listVotes(_allUsers, _vote);
2639     }
2640 
2641     function readDraftVote(bytes32 _proposalId, address _voter)
2642         public
2643         view
2644         returns (bool _vote, uint256 _weight)
2645     {
2646         require(senderIsAllowedToRead());
2647         return proposalsById[_proposalId].draftVoting.readVote(_voter);
2648     }
2649 
2650     /// @notice returns the latest committed vote by a voter on a proposal
2651     /// @param _proposalId proposal ID
2652     /// @param _voter address of the voter
2653     /// @return {
2654     ///   "_commitHash": ""
2655     /// }
2656     function readComittedVote(bytes32 _proposalId, uint256 _index, address _voter)
2657         public
2658         view
2659         returns (bytes32 _commitHash)
2660     {
2661         require(senderIsAllowedToRead());
2662         _commitHash = proposalsById[_proposalId].votingRounds[_index].commits[_voter];
2663     }
2664 
2665     function readVote(bytes32 _proposalId, uint256 _index, address _voter)
2666         public
2667         view
2668         returns (bool _vote, uint256 _weight)
2669     {
2670         require(senderIsAllowedToRead());
2671         return proposalsById[_proposalId].votingRounds[_index].readVote(_voter);
2672     }
2673 
2674     /// @notice get all information and details of the first proposal
2675     /// return {
2676     ///   "_id": ""
2677     /// }
2678     function getFirstProposal()
2679         public
2680         view
2681         returns (bytes32 _id)
2682     {
2683         _id = read_first_from_bytesarray(allProposals);
2684     }
2685 
2686     /// @notice get all information and details of the last proposal
2687     /// return {
2688     ///   "_id": ""
2689     /// }
2690     function getLastProposal()
2691         public
2692         view
2693         returns (bytes32 _id)
2694     {
2695         _id = read_last_from_bytesarray(allProposals);
2696     }
2697 
2698     /// @notice get all information and details of proposal next to _proposalId
2699     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2700     /// return {
2701     ///   "_id": ""
2702     /// }
2703     function getNextProposal(bytes32 _proposalId)
2704         public
2705         view
2706         returns (bytes32 _id)
2707     {
2708         _id = read_next_from_bytesarray(
2709             allProposals,
2710             _proposalId
2711         );
2712     }
2713 
2714     /// @notice get all information and details of proposal previous to _proposalId
2715     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2716     /// return {
2717     ///   "_id": ""
2718     /// }
2719     function getPreviousProposal(bytes32 _proposalId)
2720         public
2721         view
2722         returns (bytes32 _id)
2723     {
2724         _id = read_previous_from_bytesarray(
2725             allProposals,
2726             _proposalId
2727         );
2728     }
2729 
2730     /// @notice get all information and details of the first proposal in state _stateId
2731     /// @param _stateId State ID of the proposal
2732     /// return {
2733     ///   "_id": ""
2734     /// }
2735     function getFirstProposalInState(bytes32 _stateId)
2736         public
2737         view
2738         returns (bytes32 _id)
2739     {
2740         require(senderIsAllowedToRead());
2741         _id = read_first_from_bytesarray(proposalsByState[_stateId]);
2742     }
2743 
2744     /// @notice get all information and details of the last proposal in state _stateId
2745     /// @param _stateId State ID of the proposal
2746     /// return {
2747     ///   "_id": ""
2748     /// }
2749     function getLastProposalInState(bytes32 _stateId)
2750         public
2751         view
2752         returns (bytes32 _id)
2753     {
2754         require(senderIsAllowedToRead());
2755         _id = read_last_from_bytesarray(proposalsByState[_stateId]);
2756     }
2757 
2758     /// @notice get all information and details of the next proposal to _proposalId in state _stateId
2759     /// @param _stateId State ID of the proposal
2760     /// return {
2761     ///   "_id": ""
2762     /// }
2763     function getNextProposalInState(bytes32 _stateId, bytes32 _proposalId)
2764         public
2765         view
2766         returns (bytes32 _id)
2767     {
2768         require(senderIsAllowedToRead());
2769         _id = read_next_from_bytesarray(
2770             proposalsByState[_stateId],
2771             _proposalId
2772         );
2773     }
2774 
2775     /// @notice get all information and details of the previous proposal to _proposalId in state _stateId
2776     /// @param _stateId State ID of the proposal
2777     /// return {
2778     ///   "_id": ""
2779     /// }
2780     function getPreviousProposalInState(bytes32 _stateId, bytes32 _proposalId)
2781         public
2782         view
2783         returns (bytes32 _id)
2784     {
2785         require(senderIsAllowedToRead());
2786         _id = read_previous_from_bytesarray(
2787             proposalsByState[_stateId],
2788             _proposalId
2789         );
2790     }
2791 
2792     /// @notice read proposal version details for a specific version
2793     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2794     /// @param _version Version of proposal, i.e. hash of IPFS doc for specific version
2795     /// return {
2796     ///   "_doc": "",
2797     ///   "_created": "",
2798     ///   "_milestoneFundings": ""
2799     /// }
2800     function readProposalVersion(bytes32 _proposalId, bytes32 _version)
2801         public
2802         view
2803         returns (
2804             bytes32 _doc,
2805             uint256 _created,
2806             uint256[] _milestoneFundings,
2807             uint256 _finalReward
2808         )
2809     {
2810         return proposalsById[_proposalId].proposalVersions[_version].readVersion();
2811     }
2812 
2813     /**
2814     @notice Read the fundings of a finalized proposal
2815     @return {
2816         "_fundings": "fundings for the milestones",
2817         "_finalReward": "the final reward"
2818     }
2819     */
2820     function readProposalFunding(bytes32 _proposalId)
2821         public
2822         view
2823         returns (uint256[] memory _fundings, uint256 _finalReward)
2824     {
2825         require(senderIsAllowedToRead());
2826         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
2827         require(_finalVersion != EMPTY_BYTES);
2828         _fundings = proposalsById[_proposalId].proposalVersions[_finalVersion].milestoneFundings;
2829         _finalReward = proposalsById[_proposalId].proposalVersions[_finalVersion].finalReward;
2830     }
2831 
2832     function readProposalMilestone(bytes32 _proposalId, uint256 _index)
2833         public
2834         view
2835         returns (uint256 _funding)
2836     {
2837         require(senderIsAllowedToRead());
2838         _funding = proposalsById[_proposalId].readProposalMilestone(_index);
2839     }
2840 
2841     /// @notice get proposal version details for the first version
2842     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2843     /// return {
2844     ///   "_version": ""
2845     /// }
2846     function getFirstProposalVersion(bytes32 _proposalId)
2847         public
2848         view
2849         returns (bytes32 _version)
2850     {
2851         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2852         _version = read_first_from_bytesarray(_proposal.proposalVersionDocs);
2853     }
2854 
2855     /// @notice get proposal version details for the last version
2856     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2857     /// return {
2858     ///   "_version": ""
2859     /// }
2860     function getLastProposalVersion(bytes32 _proposalId)
2861         public
2862         view
2863         returns (bytes32 _version)
2864     {
2865         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2866         _version = read_last_from_bytesarray(_proposal.proposalVersionDocs);
2867     }
2868 
2869     /// @notice get proposal version details for the next version to _version
2870     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2871     /// @param _version Version of proposal
2872     /// return {
2873     ///   "_nextVersion": ""
2874     /// }
2875     function getNextProposalVersion(bytes32 _proposalId, bytes32 _version)
2876         public
2877         view
2878         returns (bytes32 _nextVersion)
2879     {
2880         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2881         _nextVersion = read_next_from_bytesarray(
2882             _proposal.proposalVersionDocs,
2883             _version
2884         );
2885     }
2886 
2887     /// @notice get proposal version details for the previous version to _version
2888     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2889     /// @param _version Version of proposal
2890     /// return {
2891     ///   "_previousVersion": ""
2892     /// }
2893     function getPreviousProposalVersion(bytes32 _proposalId, bytes32 _version)
2894         public
2895         view
2896         returns (bytes32 _previousVersion)
2897     {
2898         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2899         _previousVersion = read_previous_from_bytesarray(
2900             _proposal.proposalVersionDocs,
2901             _version
2902         );
2903     }
2904 
2905     function isDraftClaimed(bytes32 _proposalId)
2906         public
2907         view
2908         returns (bool _claimed)
2909     {
2910         _claimed = proposalsById[_proposalId].draftVoting.claimed;
2911     }
2912 
2913     function isClaimed(bytes32 _proposalId, uint256 _index)
2914         public
2915         view
2916         returns (bool _claimed)
2917     {
2918         _claimed = proposalsById[_proposalId].votingRounds[_index].claimed;
2919     }
2920 
2921     function readProposalCollateralStatus(bytes32 _proposalId)
2922         public
2923         view
2924         returns (uint256 _status)
2925     {
2926         require(senderIsAllowedToRead());
2927         _status = proposalsById[_proposalId].collateralStatus;
2928     }
2929 
2930     function readProposalCollateralAmount(bytes32 _proposalId)
2931         public
2932         view
2933         returns (uint256 _amount)
2934     {
2935         _amount = proposalsById[_proposalId].collateralAmount;
2936     }
2937 
2938     /// @notice Read the additional docs that are added after the proposal is finalized
2939     /// @dev Will throw if the propsal is not finalized yet
2940     function readProposalDocs(bytes32 _proposalId)
2941         public
2942         view
2943         returns (bytes32[] _moreDocs)
2944     {
2945         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
2946         require(_finalVersion != EMPTY_BYTES);
2947         _moreDocs = proposalsById[_proposalId].proposalVersions[_finalVersion].moreDocs;
2948     }
2949 
2950     function readIfMilestoneFunded(bytes32 _proposalId, uint256 _milestoneId)
2951         public
2952         view
2953         returns (bool _funded)
2954     {
2955         require(senderIsAllowedToRead());
2956         _funded = proposalsById[_proposalId].votingRounds[_milestoneId].funded;
2957     }
2958 
2959     ////////////////////////////// WRITE FUNCTIONS //////////////////////////////
2960 
2961     function addProposal(
2962         bytes32 _doc,
2963         address _proposer,
2964         uint256[] _milestoneFundings,
2965         uint256 _finalReward,
2966         bool _isFounder
2967     )
2968         external
2969     {
2970         require(sender_is(CONTRACT_DAO));
2971         require(
2972           (proposalsById[_doc].proposalId == EMPTY_BYTES) &&
2973           (_doc != EMPTY_BYTES)
2974         );
2975 
2976         allProposals.append(_doc);
2977         proposalsByState[PROPOSAL_STATE_PREPROPOSAL].append(_doc);
2978         proposalsById[_doc].proposalId = _doc;
2979         proposalsById[_doc].proposer = _proposer;
2980         proposalsById[_doc].currentState = PROPOSAL_STATE_PREPROPOSAL;
2981         proposalsById[_doc].timeCreated = now;
2982         proposalsById[_doc].isDigix = _isFounder;
2983         proposalsById[_doc].addProposalVersion(_doc, _milestoneFundings, _finalReward);
2984     }
2985 
2986     function editProposal(
2987         bytes32 _proposalId,
2988         bytes32 _newDoc,
2989         uint256[] _newMilestoneFundings,
2990         uint256 _finalReward
2991     )
2992         external
2993     {
2994         require(sender_is(CONTRACT_DAO));
2995 
2996         proposalsById[_proposalId].addProposalVersion(_newDoc, _newMilestoneFundings, _finalReward);
2997     }
2998 
2999     /// @notice change fundings of a proposal
3000     /// @dev Will throw if the proposal is not finalized yet
3001     function changeFundings(bytes32 _proposalId, uint256[] _newMilestoneFundings, uint256 _finalReward)
3002         external
3003     {
3004         require(sender_is(CONTRACT_DAO));
3005 
3006         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
3007         require(_finalVersion != EMPTY_BYTES);
3008         proposalsById[_proposalId].proposalVersions[_finalVersion].milestoneFundings = _newMilestoneFundings;
3009         proposalsById[_proposalId].proposalVersions[_finalVersion].finalReward = _finalReward;
3010     }
3011 
3012     /// @dev Will throw if the proposal is not finalized yet
3013     function addProposalDoc(bytes32 _proposalId, bytes32 _newDoc)
3014         public
3015     {
3016         require(sender_is(CONTRACT_DAO));
3017 
3018         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
3019         require(_finalVersion != EMPTY_BYTES); //already checked in interactive layer, but why not
3020         proposalsById[_proposalId].proposalVersions[_finalVersion].moreDocs.push(_newDoc);
3021     }
3022 
3023     function finalizeProposal(bytes32 _proposalId)
3024         public
3025     {
3026         require(sender_is(CONTRACT_DAO));
3027 
3028         proposalsById[_proposalId].finalVersion = getLastProposalVersion(_proposalId);
3029     }
3030 
3031     function updateProposalEndorse(
3032         bytes32 _proposalId,
3033         address _endorser
3034     )
3035         public
3036     {
3037         require(sender_is(CONTRACT_DAO));
3038 
3039         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
3040         _proposal.endorser = _endorser;
3041         _proposal.currentState = PROPOSAL_STATE_DRAFT;
3042         proposalsByState[PROPOSAL_STATE_PREPROPOSAL].remove_item(_proposalId);
3043         proposalsByState[PROPOSAL_STATE_DRAFT].append(_proposalId);
3044     }
3045 
3046     function setProposalDraftPass(bytes32 _proposalId, bool _result)
3047         public
3048     {
3049         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3050 
3051         proposalsById[_proposalId].draftVoting.passed = _result;
3052         if (_result) {
3053             proposalsByState[PROPOSAL_STATE_DRAFT].remove_item(_proposalId);
3054             proposalsByState[PROPOSAL_STATE_MODERATED].append(_proposalId);
3055             proposalsById[_proposalId].currentState = PROPOSAL_STATE_MODERATED;
3056         } else {
3057             closeProposalInternal(_proposalId);
3058         }
3059     }
3060 
3061     function setProposalPass(bytes32 _proposalId, uint256 _index, bool _result)
3062         public
3063     {
3064         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3065 
3066         if (!_result) {
3067             closeProposalInternal(_proposalId);
3068         } else if (_index == 0) {
3069             proposalsByState[PROPOSAL_STATE_MODERATED].remove_item(_proposalId);
3070             proposalsByState[PROPOSAL_STATE_ONGOING].append(_proposalId);
3071             proposalsById[_proposalId].currentState = PROPOSAL_STATE_ONGOING;
3072         }
3073         proposalsById[_proposalId].votingRounds[_index].passed = _result;
3074     }
3075 
3076     function setProposalDraftVotingTime(
3077         bytes32 _proposalId,
3078         uint256 _time
3079     )
3080         public
3081     {
3082         require(sender_is(CONTRACT_DAO));
3083 
3084         proposalsById[_proposalId].draftVoting.startTime = _time;
3085     }
3086 
3087     function setProposalVotingTime(
3088         bytes32 _proposalId,
3089         uint256 _index,
3090         uint256 _time
3091     )
3092         public
3093     {
3094         require(sender_is_from([CONTRACT_DAO, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
3095 
3096         proposalsById[_proposalId].votingRounds[_index].startTime = _time;
3097     }
3098 
3099     function setDraftVotingClaim(bytes32 _proposalId, bool _claimed)
3100         public
3101     {
3102         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3103         proposalsById[_proposalId].draftVoting.claimed = _claimed;
3104     }
3105 
3106     function setVotingClaim(bytes32 _proposalId, uint256 _index, bool _claimed)
3107         public
3108     {
3109         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3110         proposalsById[_proposalId].votingRounds[_index].claimed = _claimed;
3111     }
3112 
3113     function setProposalCollateralStatus(bytes32 _proposalId, uint256 _status)
3114         public
3115     {
3116         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_FUNDING_MANAGER, CONTRACT_DAO]));
3117         proposalsById[_proposalId].collateralStatus = _status;
3118     }
3119 
3120     function setProposalCollateralAmount(bytes32 _proposalId, uint256 _amount)
3121         public
3122     {
3123         require(sender_is(CONTRACT_DAO));
3124         proposalsById[_proposalId].collateralAmount = _amount;
3125     }
3126 
3127     function updateProposalPRL(
3128         bytes32 _proposalId,
3129         uint256 _action,
3130         bytes32 _doc,
3131         uint256 _time
3132     )
3133         public
3134     {
3135         require(sender_is(CONTRACT_DAO));
3136         require(proposalsById[_proposalId].currentState != PROPOSAL_STATE_CLOSED);
3137 
3138         DaoStructs.PrlAction memory prlAction;
3139         prlAction.at = _time;
3140         prlAction.doc = _doc;
3141         prlAction.actionId = _action;
3142         proposalsById[_proposalId].prlActions.push(prlAction);
3143 
3144         if (_action == PRL_ACTION_PAUSE) {
3145           proposalsById[_proposalId].isPausedOrStopped = true;
3146         } else if (_action == PRL_ACTION_UNPAUSE) {
3147           proposalsById[_proposalId].isPausedOrStopped = false;
3148         } else { // STOP
3149           proposalsById[_proposalId].isPausedOrStopped = true;
3150           closeProposalInternal(_proposalId);
3151         }
3152     }
3153 
3154     function closeProposalInternal(bytes32 _proposalId)
3155         internal
3156     {
3157         bytes32 _currentState = proposalsById[_proposalId].currentState;
3158         proposalsByState[_currentState].remove_item(_proposalId);
3159         proposalsByState[PROPOSAL_STATE_CLOSED].append(_proposalId);
3160         proposalsById[_proposalId].currentState = PROPOSAL_STATE_CLOSED;
3161     }
3162 
3163     function addDraftVote(
3164         bytes32 _proposalId,
3165         address _voter,
3166         bool _vote,
3167         uint256 _weight
3168     )
3169         public
3170     {
3171         require(sender_is(CONTRACT_DAO_VOTING));
3172 
3173         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
3174         if (_vote) {
3175             _proposal.draftVoting.yesVotes[_voter] = _weight;
3176             if (_proposal.draftVoting.noVotes[_voter] > 0) { // minimize number of writes to storage, since EIP-1087 is not implemented yet
3177                 _proposal.draftVoting.noVotes[_voter] = 0;
3178             }
3179         } else {
3180             _proposal.draftVoting.noVotes[_voter] = _weight;
3181             if (_proposal.draftVoting.yesVotes[_voter] > 0) {
3182                 _proposal.draftVoting.yesVotes[_voter] = 0;
3183             }
3184         }
3185     }
3186 
3187     function commitVote(
3188         bytes32 _proposalId,
3189         bytes32 _hash,
3190         address _voter,
3191         uint256 _index
3192     )
3193         public
3194     {
3195         require(sender_is(CONTRACT_DAO_VOTING));
3196 
3197         proposalsById[_proposalId].votingRounds[_index].commits[_voter] = _hash;
3198     }
3199 
3200     function revealVote(
3201         bytes32 _proposalId,
3202         address _voter,
3203         bool _vote,
3204         uint256 _weight,
3205         uint256 _index
3206     )
3207         public
3208     {
3209         require(sender_is(CONTRACT_DAO_VOTING));
3210 
3211         proposalsById[_proposalId].votingRounds[_index].revealVote(_voter, _vote, _weight);
3212     }
3213 
3214     function closeProposal(bytes32 _proposalId)
3215         public
3216     {
3217         require(sender_is(CONTRACT_DAO));
3218         closeProposalInternal(_proposalId);
3219     }
3220 
3221     function archiveProposal(bytes32 _proposalId)
3222         public
3223     {
3224         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3225         bytes32 _currentState = proposalsById[_proposalId].currentState;
3226         proposalsByState[_currentState].remove_item(_proposalId);
3227         proposalsByState[PROPOSAL_STATE_ARCHIVED].append(_proposalId);
3228         proposalsById[_proposalId].currentState = PROPOSAL_STATE_ARCHIVED;
3229     }
3230 
3231     function setMilestoneFunded(bytes32 _proposalId, uint256 _milestoneId)
3232         public
3233     {
3234         require(sender_is(CONTRACT_DAO_FUNDING_MANAGER));
3235         proposalsById[_proposalId].votingRounds[_milestoneId].funded = true;
3236     }
3237 }
3238 
3239 // File: @digix/solidity-collections/contracts/abstract/AddressIteratorStorage.sol
3240 /**
3241   @title Address Iterator Storage
3242   @author DigixGlobal Pte Ltd
3243   @notice See: [Doubly Linked List](/DoublyLinkedList)
3244 */
3245 contract AddressIteratorStorage {
3246 
3247   // Initialize Doubly Linked List of Address
3248   using DoublyLinkedList for DoublyLinkedList.Address;
3249 
3250   /**
3251     @notice Reads the first item from the list of Address
3252     @param _list The source list
3253     @return {"_item" : "The first item from the list"}
3254   */
3255   function read_first_from_addresses(DoublyLinkedList.Address storage _list)
3256            internal
3257            constant
3258            returns (address _item)
3259   {
3260     _item = _list.start_item();
3261   }
3262 
3263 
3264   /**
3265     @notice Reads the last item from the list of Address
3266     @param _list The source list
3267     @return {"_item" : "The last item from the list"}
3268   */
3269   function read_last_from_addresses(DoublyLinkedList.Address storage _list)
3270            internal
3271            constant
3272            returns (address _item)
3273   {
3274     _item = _list.end_item();
3275   }
3276 
3277   /**
3278     @notice Reads the next item on the list of Address
3279     @param _list The source list
3280     @param _current_item The current item to be used as base line
3281     @return {"_item" : "The next item from the list based on the specieid `_current_item`"}
3282   */
3283   function read_next_from_addresses(DoublyLinkedList.Address storage _list, address _current_item)
3284            internal
3285            constant
3286            returns (address _item)
3287   {
3288     _item = _list.next_item(_current_item);
3289   }
3290 
3291   /**
3292     @notice Reads the previous item on the list of Address
3293     @param _list The source list
3294     @param _current_item The current item to be used as base line
3295     @return {"_item" : "The previous item from the list based on the spcified `_current_item`"}
3296   */
3297   function read_previous_from_addresses(DoublyLinkedList.Address storage _list, address _current_item)
3298            internal
3299            constant
3300            returns (address _item)
3301   {
3302     _item = _list.previous_item(_current_item);
3303   }
3304 
3305   /**
3306     @notice Reads the list of Address and returns the length of the list
3307     @param _list The source list
3308     @return {"_count": "The lenght of the list"}
3309   */
3310   function read_total_addresses(DoublyLinkedList.Address storage _list)
3311            internal
3312            constant
3313            returns (uint256 _count)
3314   {
3315     _count = _list.total();
3316   }
3317 }
3318 
3319 // File: contracts/storage/DaoStakeStorage.sol
3320 contract DaoStakeStorage is ResolverClient, DaoConstants, AddressIteratorStorage {
3321     using DoublyLinkedList for DoublyLinkedList.Address;
3322 
3323     // This is the DGD stake of a user (one that is considered in the DAO)
3324     mapping (address => uint256) public lockedDGDStake;
3325 
3326     // This is the actual number of DGDs locked by user
3327     // may be more than the lockedDGDStake
3328     // in case they locked during the main phase
3329     mapping (address => uint256) public actualLockedDGD;
3330 
3331     // The total locked DGDs in the DAO (summation of lockedDGDStake)
3332     uint256 public totalLockedDGDStake;
3333 
3334     // The total locked DGDs by moderators
3335     uint256 public totalModeratorLockedDGDStake;
3336 
3337     // The list of participants in DAO
3338     // actual participants will be subset of this list
3339     DoublyLinkedList.Address allParticipants;
3340 
3341     // The list of moderators in DAO
3342     // actual moderators will be subset of this list
3343     DoublyLinkedList.Address allModerators;
3344 
3345     // Boolean to mark if an address has redeemed
3346     // reputation points for their DGD Badge
3347     mapping (address => bool) public redeemedBadge;
3348 
3349     // mapping to note whether an address has claimed their
3350     // reputation bonus for carbon vote participation
3351     mapping (address => bool) public carbonVoteBonusClaimed;
3352 
3353     constructor(address _resolver) public {
3354         require(init(CONTRACT_STORAGE_DAO_STAKE, _resolver));
3355     }
3356 
3357     function redeemBadge(address _user)
3358         public
3359     {
3360         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3361         redeemedBadge[_user] = true;
3362     }
3363 
3364     function setCarbonVoteBonusClaimed(address _user)
3365         public
3366     {
3367         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3368         carbonVoteBonusClaimed[_user] = true;
3369     }
3370 
3371     function updateTotalLockedDGDStake(uint256 _totalLockedDGDStake)
3372         public
3373     {
3374         require(sender_is_from([CONTRACT_DAO_STAKE_LOCKING, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
3375         totalLockedDGDStake = _totalLockedDGDStake;
3376     }
3377 
3378     function updateTotalModeratorLockedDGDs(uint256 _totalLockedDGDStake)
3379         public
3380     {
3381         require(sender_is_from([CONTRACT_DAO_STAKE_LOCKING, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
3382         totalModeratorLockedDGDStake = _totalLockedDGDStake;
3383     }
3384 
3385     function updateUserDGDStake(address _user, uint256 _actualLockedDGD, uint256 _lockedDGDStake)
3386         public
3387     {
3388         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3389         actualLockedDGD[_user] = _actualLockedDGD;
3390         lockedDGDStake[_user] = _lockedDGDStake;
3391     }
3392 
3393     function readUserDGDStake(address _user)
3394         public
3395         view
3396         returns (
3397             uint256 _actualLockedDGD,
3398             uint256 _lockedDGDStake
3399         )
3400     {
3401         _actualLockedDGD = actualLockedDGD[_user];
3402         _lockedDGDStake = lockedDGDStake[_user];
3403     }
3404 
3405     function addToParticipantList(address _user)
3406         public
3407         returns (bool _success)
3408     {
3409         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3410         _success = allParticipants.append(_user);
3411     }
3412 
3413     function removeFromParticipantList(address _user)
3414         public
3415         returns (bool _success)
3416     {
3417         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3418         _success = allParticipants.remove_item(_user);
3419     }
3420 
3421     function addToModeratorList(address _user)
3422         public
3423         returns (bool _success)
3424     {
3425         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3426         _success = allModerators.append(_user);
3427     }
3428 
3429     function removeFromModeratorList(address _user)
3430         public
3431         returns (bool _success)
3432     {
3433         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3434         _success = allModerators.remove_item(_user);
3435     }
3436 
3437     function isInParticipantList(address _user)
3438         public
3439         view
3440         returns (bool _is)
3441     {
3442         _is = allParticipants.find(_user) != 0;
3443     }
3444 
3445     function isInModeratorsList(address _user)
3446         public
3447         view
3448         returns (bool _is)
3449     {
3450         _is = allModerators.find(_user) != 0;
3451     }
3452 
3453     function readFirstModerator()
3454         public
3455         view
3456         returns (address _item)
3457     {
3458         _item = read_first_from_addresses(allModerators);
3459     }
3460 
3461     function readLastModerator()
3462         public
3463         view
3464         returns (address _item)
3465     {
3466         _item = read_last_from_addresses(allModerators);
3467     }
3468 
3469     function readNextModerator(address _current_item)
3470         public
3471         view
3472         returns (address _item)
3473     {
3474         _item = read_next_from_addresses(allModerators, _current_item);
3475     }
3476 
3477     function readPreviousModerator(address _current_item)
3478         public
3479         view
3480         returns (address _item)
3481     {
3482         _item = read_previous_from_addresses(allModerators, _current_item);
3483     }
3484 
3485     function readTotalModerators()
3486         public
3487         view
3488         returns (uint256 _total_count)
3489     {
3490         _total_count = read_total_addresses(allModerators);
3491     }
3492 
3493     function readFirstParticipant()
3494         public
3495         view
3496         returns (address _item)
3497     {
3498         _item = read_first_from_addresses(allParticipants);
3499     }
3500 
3501     function readLastParticipant()
3502         public
3503         view
3504         returns (address _item)
3505     {
3506         _item = read_last_from_addresses(allParticipants);
3507     }
3508 
3509     function readNextParticipant(address _current_item)
3510         public
3511         view
3512         returns (address _item)
3513     {
3514         _item = read_next_from_addresses(allParticipants, _current_item);
3515     }
3516 
3517     function readPreviousParticipant(address _current_item)
3518         public
3519         view
3520         returns (address _item)
3521     {
3522         _item = read_previous_from_addresses(allParticipants, _current_item);
3523     }
3524 
3525     function readTotalParticipant()
3526         public
3527         view
3528         returns (uint256 _total_count)
3529     {
3530         _total_count = read_total_addresses(allParticipants);
3531     }
3532 }
3533 
3534 // File: contracts/service/DaoListingService.sol
3535 /**
3536 @title Contract to list various storage states from DigixDAO
3537 @author Digix Holdings
3538 */
3539 contract DaoListingService is
3540     AddressIteratorInteractive,
3541     BytesIteratorInteractive,
3542     IndexedBytesIteratorInteractive,
3543     DaoWhitelistingCommon
3544 {
3545 
3546     /**
3547     @notice Constructor
3548     @param _resolver address of contract resolver
3549     */
3550     constructor(address _resolver) public {
3551         require(init(CONTRACT_SERVICE_DAO_LISTING, _resolver));
3552     }
3553 
3554     function daoStakeStorage()
3555         internal
3556         view
3557         returns (DaoStakeStorage _contract)
3558     {
3559         _contract = DaoStakeStorage(get_contract(CONTRACT_STORAGE_DAO_STAKE));
3560     }
3561 
3562     function daoStorage()
3563         internal
3564         view
3565         returns (DaoStorage _contract)
3566     {
3567         _contract = DaoStorage(get_contract(CONTRACT_STORAGE_DAO));
3568     }
3569 
3570     /**
3571     @notice function to list moderators
3572     @dev note that this list may include some additional entries that are
3573          not moderators in the current quarter. This may happen if they
3574          were moderators in the previous quarter, but have not confirmed
3575          their participation in the current quarter. For a single address,
3576          a better way to know if moderator or not is:
3577          Dao.isModerator(_user)
3578     @param _count number of addresses to list
3579     @param _from_start boolean, whether to list from start or end
3580     @return {
3581       "_moderators": "list of moderator addresses"
3582     }
3583     */
3584     function listModerators(uint256 _count, bool _from_start)
3585         public
3586         view
3587         returns (address[] _moderators)
3588     {
3589         _moderators = list_addresses(
3590             _count,
3591             daoStakeStorage().readFirstModerator,
3592             daoStakeStorage().readLastModerator,
3593             daoStakeStorage().readNextModerator,
3594             daoStakeStorage().readPreviousModerator,
3595             _from_start
3596         );
3597     }
3598 
3599     /**
3600     @notice function to list moderators from a particular moderator
3601     @dev note that this list may include some additional entries that are
3602          not moderators in the current quarter. This may happen if they
3603          were moderators in the previous quarter, but have not confirmed
3604          their participation in the current quarter. For a single address,
3605          a better way to know if moderator or not is:
3606          Dao.isModerator(_user)
3607 
3608          Another note: this function will start listing AFTER the _currentModerator
3609          For example: we have [address1, address2, address3, address4]. listModeratorsFrom(address1, 2, true) = [address2, address3]
3610     @param _currentModerator start the list after this moderator address
3611     @param _count number of addresses to list
3612     @param _from_start boolean, whether to list from start or end
3613     @return {
3614       "_moderators": "list of moderator addresses"
3615     }
3616     */
3617     function listModeratorsFrom(
3618         address _currentModerator,
3619         uint256 _count,
3620         bool _from_start
3621     )
3622         public
3623         view
3624         returns (address[] _moderators)
3625     {
3626         _moderators = list_addresses_from(
3627             _currentModerator,
3628             _count,
3629             daoStakeStorage().readFirstModerator,
3630             daoStakeStorage().readLastModerator,
3631             daoStakeStorage().readNextModerator,
3632             daoStakeStorage().readPreviousModerator,
3633             _from_start
3634         );
3635     }
3636 
3637     /**
3638     @notice function to list participants
3639     @dev note that this list may include some additional entries that are
3640          not participants in the current quarter. This may happen if they
3641          were participants in the previous quarter, but have not confirmed
3642          their participation in the current quarter. For a single address,
3643          a better way to know if participant or not is:
3644          Dao.isParticipant(_user)
3645     @param _count number of addresses to list
3646     @param _from_start boolean, whether to list from start or end
3647     @return {
3648       "_participants": "list of participant addresses"
3649     }
3650     */
3651     function listParticipants(uint256 _count, bool _from_start)
3652         public
3653         view
3654         returns (address[] _participants)
3655     {
3656         _participants = list_addresses(
3657             _count,
3658             daoStakeStorage().readFirstParticipant,
3659             daoStakeStorage().readLastParticipant,
3660             daoStakeStorage().readNextParticipant,
3661             daoStakeStorage().readPreviousParticipant,
3662             _from_start
3663         );
3664     }
3665 
3666     /**
3667     @notice function to list participants from a particular participant
3668     @dev note that this list may include some additional entries that are
3669          not participants in the current quarter. This may happen if they
3670          were participants in the previous quarter, but have not confirmed
3671          their participation in the current quarter. For a single address,
3672          a better way to know if participant or not is:
3673          contracts.dao.isParticipant(_user)
3674 
3675          Another note: this function will start listing AFTER the _currentParticipant
3676          For example: we have [address1, address2, address3, address4]. listParticipantsFrom(address1, 2, true) = [address2, address3]
3677     @param _currentParticipant list from AFTER this participant address
3678     @param _count number of addresses to list
3679     @param _from_start boolean, whether to list from start or end
3680     @return {
3681       "_participants": "list of participant addresses"
3682     }
3683     */
3684     function listParticipantsFrom(
3685         address _currentParticipant,
3686         uint256 _count,
3687         bool _from_start
3688     )
3689         public
3690         view
3691         returns (address[] _participants)
3692     {
3693         _participants = list_addresses_from(
3694             _currentParticipant,
3695             _count,
3696             daoStakeStorage().readFirstParticipant,
3697             daoStakeStorage().readLastParticipant,
3698             daoStakeStorage().readNextParticipant,
3699             daoStakeStorage().readPreviousParticipant,
3700             _from_start
3701         );
3702     }
3703 
3704     /**
3705     @notice function to list _count no. of proposals
3706     @param _count number of proposals to list
3707     @param _from_start boolean value, true if count from start, false if count from end
3708     @return {
3709       "_proposals": "the list of proposal IDs"
3710     }
3711     */
3712     function listProposals(
3713         uint256 _count,
3714         bool _from_start
3715     )
3716         public
3717         view
3718         returns (bytes32[] _proposals)
3719     {
3720         _proposals = list_bytesarray(
3721             _count,
3722             daoStorage().getFirstProposal,
3723             daoStorage().getLastProposal,
3724             daoStorage().getNextProposal,
3725             daoStorage().getPreviousProposal,
3726             _from_start
3727         );
3728     }
3729 
3730     /**
3731     @notice function to list _count no. of proposals from AFTER _currentProposal
3732     @param _currentProposal ID of proposal to list proposals from
3733     @param _count number of proposals to list
3734     @param _from_start boolean value, true if count forwards, false if count backwards
3735     @return {
3736       "_proposals": "the list of proposal IDs"
3737     }
3738     */
3739     function listProposalsFrom(
3740         bytes32 _currentProposal,
3741         uint256 _count,
3742         bool _from_start
3743     )
3744         public
3745         view
3746         returns (bytes32[] _proposals)
3747     {
3748         _proposals = list_bytesarray_from(
3749             _currentProposal,
3750             _count,
3751             daoStorage().getFirstProposal,
3752             daoStorage().getLastProposal,
3753             daoStorage().getNextProposal,
3754             daoStorage().getPreviousProposal,
3755             _from_start
3756         );
3757     }
3758 
3759     /**
3760     @notice function to list _count no. of proposals in state _stateId
3761     @param _stateId state of proposal
3762     @param _count number of proposals to list
3763     @param _from_start boolean value, true if count from start, false if count from end
3764     @return {
3765       "_proposals": "the list of proposal IDs"
3766     }
3767     */
3768     function listProposalsInState(
3769         bytes32 _stateId,
3770         uint256 _count,
3771         bool _from_start
3772     )
3773         public
3774         view
3775         returns (bytes32[] _proposals)
3776     {
3777         require(senderIsAllowedToRead());
3778         _proposals = list_indexed_bytesarray(
3779             _stateId,
3780             _count,
3781             daoStorage().getFirstProposalInState,
3782             daoStorage().getLastProposalInState,
3783             daoStorage().getNextProposalInState,
3784             daoStorage().getPreviousProposalInState,
3785             _from_start
3786         );
3787     }
3788 
3789     /**
3790     @notice function to list _count no. of proposals in state _stateId from AFTER _currentProposal
3791     @param _stateId state of proposal
3792     @param _currentProposal ID of proposal to list proposals from
3793     @param _count number of proposals to list
3794     @param _from_start boolean value, true if count forwards, false if count backwards
3795     @return {
3796       "_proposals": "the list of proposal IDs"
3797     }
3798     */
3799     function listProposalsInStateFrom(
3800         bytes32 _stateId,
3801         bytes32 _currentProposal,
3802         uint256 _count,
3803         bool _from_start
3804     )
3805         public
3806         view
3807         returns (bytes32[] _proposals)
3808     {
3809         require(senderIsAllowedToRead());
3810         _proposals = list_indexed_bytesarray_from(
3811             _stateId,
3812             _currentProposal,
3813             _count,
3814             daoStorage().getFirstProposalInState,
3815             daoStorage().getLastProposalInState,
3816             daoStorage().getNextProposalInState,
3817             daoStorage().getPreviousProposalInState,
3818             _from_start
3819         );
3820     }
3821 
3822     /**
3823     @notice function to list proposal versions
3824     @param _proposalId ID of the proposal
3825     @param _count number of proposal versions to list
3826     @param _from_start boolean, true to list from start, false to list from end
3827     @return {
3828       "_versions": "list of proposal versions"
3829     }
3830     */
3831     function listProposalVersions(
3832         bytes32 _proposalId,
3833         uint256 _count,
3834         bool _from_start
3835     )
3836         public
3837         view
3838         returns (bytes32[] _versions)
3839     {
3840         _versions = list_indexed_bytesarray(
3841             _proposalId,
3842             _count,
3843             daoStorage().getFirstProposalVersion,
3844             daoStorage().getLastProposalVersion,
3845             daoStorage().getNextProposalVersion,
3846             daoStorage().getPreviousProposalVersion,
3847             _from_start
3848         );
3849     }
3850 
3851     /**
3852     @notice function to list proposal versions from AFTER a particular version
3853     @param _proposalId ID of the proposal
3854     @param _currentVersion version to list _count versions from
3855     @param _count number of proposal versions to list
3856     @param _from_start boolean, true to list from start, false to list from end
3857     @return {
3858       "_versions": "list of proposal versions"
3859     }
3860     */
3861     function listProposalVersionsFrom(
3862         bytes32 _proposalId,
3863         bytes32 _currentVersion,
3864         uint256 _count,
3865         bool _from_start
3866     )
3867         public
3868         view
3869         returns (bytes32[] _versions)
3870     {
3871         _versions = list_indexed_bytesarray_from(
3872             _proposalId,
3873             _currentVersion,
3874             _count,
3875             daoStorage().getFirstProposalVersion,
3876             daoStorage().getLastProposalVersion,
3877             daoStorage().getNextProposalVersion,
3878             daoStorage().getPreviousProposalVersion,
3879             _from_start
3880         );
3881     }
3882 }
3883 
3884 // File: @digix/solidity-collections/contracts/abstract/IndexedAddressIteratorStorage.sol
3885 /**
3886   @title Indexed Address IteratorStorage
3887   @author DigixGlobal Pte Ltd
3888   @notice This contract utilizes: [Doubly Linked List](/DoublyLinkedList)
3889 */
3890 contract IndexedAddressIteratorStorage {
3891 
3892   using DoublyLinkedList for DoublyLinkedList.IndexedAddress;
3893   /**
3894     @notice Reads the first item from an Indexed Address Doubly Linked List
3895     @param _list The source list
3896     @param _collection_index Index of the Collection to evaluate
3897     @return {"_item" : "First item on the list"}
3898   */
3899   function read_first_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
3900            internal
3901            constant
3902            returns (address _item)
3903   {
3904     _item = _list.start_item(_collection_index);
3905   }
3906 
3907   /**
3908     @notice Reads the last item from an Indexed Address Doubly Linked list
3909     @param _list The source list
3910     @param _collection_index Index of the Collection to evaluate
3911     @return {"_item" : "First item on the list"}
3912   */
3913   function read_last_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
3914            internal
3915            constant
3916            returns (address _item)
3917   {
3918     _item = _list.end_item(_collection_index);
3919   }
3920 
3921   /**
3922     @notice Reads the next item from an Indexed Address Doubly Linked List based on the specified `_current_item`
3923     @param _list The source list
3924     @param _collection_index Index of the Collection to evaluate
3925     @param _current_item The current item to use as base line
3926     @return {"_item": "The next item on the list"}
3927   */
3928   function read_next_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index, address _current_item)
3929            internal
3930            constant
3931            returns (address _item)
3932   {
3933     _item = _list.next_item(_collection_index, _current_item);
3934   }
3935 
3936   /**
3937     @notice Reads the previous item from an Index Address Doubly Linked List based on the specified `_current_item`
3938     @param _list The source list
3939     @param _collection_index Index of the Collection to evaluate
3940     @param _current_item The current item to use as base line
3941     @return {"_item" : "The previous item on the list"}
3942   */
3943   function read_previous_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index, address _current_item)
3944            internal
3945            constant
3946            returns (address _item)
3947   {
3948     _item = _list.previous_item(_collection_index, _current_item);
3949   }
3950 
3951 
3952   /**
3953     @notice Reads the total number of items in an Indexed Address Doubly Linked List
3954     @param _list  The source list
3955     @param _collection_index Index of the Collection to evaluate
3956     @return {"_count": "Length of the Doubly Linked list"}
3957   */
3958   function read_total_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
3959            internal
3960            constant
3961            returns (uint256 _count)
3962   {
3963     _count = _list.total(_collection_index);
3964   }
3965 }
3966 
3967 // File: @digix/solidity-collections/contracts/abstract/UintIteratorStorage.sol
3968 /**
3969   @title Uint Iterator Storage
3970   @author DigixGlobal Pte Ltd
3971 */
3972 contract UintIteratorStorage {
3973 
3974   using DoublyLinkedList for DoublyLinkedList.Uint;
3975 
3976   /**
3977     @notice Returns the first item from a `DoublyLinkedList.Uint` list
3978     @param _list The DoublyLinkedList.Uint list
3979     @return {"_item": "The first item"}
3980   */
3981   function read_first_from_uints(DoublyLinkedList.Uint storage _list)
3982            internal
3983            constant
3984            returns (uint256 _item)
3985   {
3986     _item = _list.start_item();
3987   }
3988 
3989   /**
3990     @notice Returns the last item from a `DoublyLinkedList.Uint` list
3991     @param _list The DoublyLinkedList.Uint list
3992     @return {"_item": "The last item"}
3993   */
3994   function read_last_from_uints(DoublyLinkedList.Uint storage _list)
3995            internal
3996            constant
3997            returns (uint256 _item)
3998   {
3999     _item = _list.end_item();
4000   }
4001 
4002   /**
4003     @notice Returns the next item from a `DoublyLinkedList.Uint` list based on the specified `_current_item`
4004     @param _list The DoublyLinkedList.Uint list
4005     @param _current_item The current item
4006     @return {"_item": "The next item"}
4007   */
4008   function read_next_from_uints(DoublyLinkedList.Uint storage _list, uint256 _current_item)
4009            internal
4010            constant
4011            returns (uint256 _item)
4012   {
4013     _item = _list.next_item(_current_item);
4014   }
4015 
4016   /**
4017     @notice Returns the previous item from a `DoublyLinkedList.Uint` list based on the specified `_current_item`
4018     @param _list The DoublyLinkedList.Uint list
4019     @param _current_item The current item
4020     @return {"_item": "The previous item"}
4021   */
4022   function read_previous_from_uints(DoublyLinkedList.Uint storage _list, uint256 _current_item)
4023            internal
4024            constant
4025            returns (uint256 _item)
4026   {
4027     _item = _list.previous_item(_current_item);
4028   }
4029 
4030   /**
4031     @notice Returns the total count of itemsfrom a `DoublyLinkedList.Uint` list
4032     @param _list The DoublyLinkedList.Uint list
4033     @return {"_count": "The total count of items"}
4034   */
4035   function read_total_uints(DoublyLinkedList.Uint storage _list)
4036            internal
4037            constant
4038            returns (uint256 _count)
4039   {
4040     _count = _list.total();
4041   }
4042 }
4043 
4044 // File: @digix/cdap/contracts/storage/DirectoryStorage.sol
4045 /**
4046 @title Directory Storage contains information of a directory
4047 @author DigixGlobal
4048 */
4049 contract DirectoryStorage is IndexedAddressIteratorStorage, UintIteratorStorage {
4050 
4051   using DoublyLinkedList for DoublyLinkedList.IndexedAddress;
4052   using DoublyLinkedList for DoublyLinkedList.Uint;
4053 
4054   struct User {
4055     bytes32 document;
4056     bool active;
4057   }
4058 
4059   struct Group {
4060     bytes32 name;
4061     bytes32 document;
4062     uint256 role_id;
4063     mapping(address => User) members_by_address;
4064   }
4065 
4066   struct System {
4067     DoublyLinkedList.Uint groups;
4068     DoublyLinkedList.IndexedAddress groups_collection;
4069     mapping (uint256 => Group) groups_by_id;
4070     mapping (address => uint256) group_ids_by_address;
4071     mapping (uint256 => bytes32) roles_by_id;
4072     bool initialized;
4073     uint256 total_groups;
4074   }
4075 
4076   System system;
4077 
4078   /**
4079   @notice Initializes directory settings
4080   @return _success If directory initialization is successful
4081   */
4082   function initialize_directory()
4083            internal
4084            returns (bool _success)
4085   {
4086     require(system.initialized == false);
4087     system.total_groups = 0;
4088     system.initialized = true;
4089     internal_create_role(1, "root");
4090     internal_create_group(1, "root", "");
4091     _success = internal_update_add_user_to_group(1, tx.origin, "");
4092   }
4093 
4094   /**
4095   @notice Creates a new role with the given information
4096   @param _role_id Id of the new role
4097   @param _name Name of the new role
4098   @return {"_success": "If creation of new role is successful"}
4099   */
4100   function internal_create_role(uint256 _role_id, bytes32 _name)
4101            internal
4102            returns (bool _success)
4103   {
4104     require(_role_id > 0);
4105     require(_name != bytes32(0x0));
4106     system.roles_by_id[_role_id] = _name;
4107     _success = true;
4108   }
4109 
4110   /**
4111   @notice Returns the role's name of a role id
4112   @param _role_id Id of the role
4113   @return {"_name": "Name of the role"}
4114   */
4115   function read_role(uint256 _role_id)
4116            public
4117            constant
4118            returns (bytes32 _name)
4119   {
4120     _name = system.roles_by_id[_role_id];
4121   }
4122 
4123   /**
4124   @notice Creates a new group with the given information
4125   @param _role_id Role id of the new group
4126   @param _name Name of the new group
4127   @param _document Document of the new group
4128   @return {
4129     "_success": "If creation of the new group is successful",
4130     "_group_id: "Id of the new group"
4131   }
4132   */
4133   function internal_create_group(uint256 _role_id, bytes32 _name, bytes32 _document)
4134            internal
4135            returns (bool _success, uint256 _group_id)
4136   {
4137     require(_role_id > 0);
4138     require(read_role(_role_id) != bytes32(0x0));
4139     _group_id = ++system.total_groups;
4140     system.groups.append(_group_id);
4141     system.groups_by_id[_group_id].role_id = _role_id;
4142     system.groups_by_id[_group_id].name = _name;
4143     system.groups_by_id[_group_id].document = _document;
4144     _success = true;
4145   }
4146 
4147   /**
4148   @notice Returns the group's information
4149   @param _group_id Id of the group
4150   @return {
4151     "_role_id": "Role id of the group",
4152     "_name: "Name of the group",
4153     "_document: "Document of the group"
4154   }
4155   */
4156   function read_group(uint256 _group_id)
4157            public
4158            constant
4159            returns (uint256 _role_id, bytes32 _name, bytes32 _document, uint256 _members_count)
4160   {
4161     if (system.groups.valid_item(_group_id)) {
4162       _role_id = system.groups_by_id[_group_id].role_id;
4163       _name = system.groups_by_id[_group_id].name;
4164       _document = system.groups_by_id[_group_id].document;
4165       _members_count = read_total_indexed_addresses(system.groups_collection, bytes32(_group_id));
4166     } else {
4167       _role_id = 0;
4168       _name = "invalid";
4169       _document = "";
4170       _members_count = 0;
4171     }
4172   }
4173 
4174   /**
4175   @notice Adds new user with the given information to a group
4176   @param _group_id Id of the group
4177   @param _user Address of the new user
4178   @param _document Information of the new user
4179   @return {"_success": "If adding new user to a group is successful"}
4180   */
4181   function internal_update_add_user_to_group(uint256 _group_id, address _user, bytes32 _document)
4182            internal
4183            returns (bool _success)
4184   {
4185     if (system.groups_by_id[_group_id].members_by_address[_user].active == false && system.group_ids_by_address[_user] == 0 && system.groups_by_id[_group_id].role_id != 0) {
4186 
4187       system.groups_by_id[_group_id].members_by_address[_user].active = true;
4188       system.group_ids_by_address[_user] = _group_id;
4189       system.groups_collection.append(bytes32(_group_id), _user);
4190       system.groups_by_id[_group_id].members_by_address[_user].document = _document;
4191       _success = true;
4192     } else {
4193       _success = false;
4194     }
4195   }
4196 
4197   /**
4198   @notice Removes user from its group
4199   @param _user Address of the user
4200   @return {"_success": "If removing of user is successful"}
4201   */
4202   function internal_destroy_group_user(address _user)
4203            internal
4204            returns (bool _success)
4205   {
4206     uint256 _group_id = system.group_ids_by_address[_user];
4207     if ((_group_id == 1) && (system.groups_collection.total(bytes32(_group_id)) == 1)) {
4208       _success = false;
4209     } else {
4210       system.groups_by_id[_group_id].members_by_address[_user].active = false;
4211       system.group_ids_by_address[_user] = 0;
4212       delete system.groups_by_id[_group_id].members_by_address[_user];
4213       _success = system.groups_collection.remove_item(bytes32(_group_id), _user);
4214     }
4215   }
4216 
4217   /**
4218   @notice Returns the role id of a user
4219   @param _user Address of a user
4220   @return {"_role_id": "Role id of the user"}
4221   */
4222   function read_user_role_id(address _user)
4223            constant
4224            public
4225            returns (uint256 _role_id)
4226   {
4227     uint256 _group_id = system.group_ids_by_address[_user];
4228     _role_id = system.groups_by_id[_group_id].role_id;
4229   }
4230 
4231   /**
4232   @notice Returns the user's information
4233   @param _user Address of the user
4234   @return {
4235     "_group_id": "Group id of the user",
4236     "_role_id": "Role id of the user",
4237     "_document": "Information of the user"
4238   }
4239   */
4240   function read_user(address _user)
4241            public
4242            constant
4243            returns (uint256 _group_id, uint256 _role_id, bytes32 _document)
4244   {
4245     _group_id = system.group_ids_by_address[_user];
4246     _role_id = system.groups_by_id[_group_id].role_id;
4247     _document = system.groups_by_id[_group_id].members_by_address[_user].document;
4248   }
4249 
4250   /**
4251   @notice Returns the id of the first group
4252   @return {"_group_id": "Id of the first group"}
4253   */
4254   function read_first_group()
4255            view
4256            external
4257            returns (uint256 _group_id)
4258   {
4259     _group_id = read_first_from_uints(system.groups);
4260   }
4261 
4262   /**
4263   @notice Returns the id of the last group
4264   @return {"_group_id": "Id of the last group"}
4265   */
4266   function read_last_group()
4267            view
4268            external
4269            returns (uint256 _group_id)
4270   {
4271     _group_id = read_last_from_uints(system.groups);
4272   }
4273 
4274   /**
4275   @notice Returns the id of the previous group depending on the given current group
4276   @param _current_group_id Id of the current group
4277   @return {"_group_id": "Id of the previous group"}
4278   */
4279   function read_previous_group_from_group(uint256 _current_group_id)
4280            view
4281            external
4282            returns (uint256 _group_id)
4283   {
4284     _group_id = read_previous_from_uints(system.groups, _current_group_id);
4285   }
4286 
4287   /**
4288   @notice Returns the id of the next group depending on the given current group
4289   @param _current_group_id Id of the current group
4290   @return {"_group_id": "Id of the next group"}
4291   */
4292   function read_next_group_from_group(uint256 _current_group_id)
4293            view
4294            external
4295            returns (uint256 _group_id)
4296   {
4297     _group_id = read_next_from_uints(system.groups, _current_group_id);
4298   }
4299 
4300   /**
4301   @notice Returns the total number of groups
4302   @return {"_total_groups": "Total number of groups"}
4303   */
4304   function read_total_groups()
4305            view
4306            external
4307            returns (uint256 _total_groups)
4308   {
4309     _total_groups = read_total_uints(system.groups);
4310   }
4311 
4312   /**
4313   @notice Returns the first user of a group
4314   @param _group_id Id of the group
4315   @return {"_user": "Address of the user"}
4316   */
4317   function read_first_user_in_group(bytes32 _group_id)
4318            view
4319            external
4320            returns (address _user)
4321   {
4322     _user = read_first_from_indexed_addresses(system.groups_collection, bytes32(_group_id));
4323   }
4324 
4325   /**
4326   @notice Returns the last user of a group
4327   @param _group_id Id of the group
4328   @return {"_user": "Address of the user"}
4329   */
4330   function read_last_user_in_group(bytes32 _group_id)
4331            view
4332            external
4333            returns (address _user)
4334   {
4335     _user = read_last_from_indexed_addresses(system.groups_collection, bytes32(_group_id));
4336   }
4337 
4338   /**
4339   @notice Returns the next user of a group depending on the given current user
4340   @param _group_id Id of the group
4341   @param _current_user Address of the current user
4342   @return {"_user": "Address of the next user"}
4343   */
4344   function read_next_user_in_group(bytes32 _group_id, address _current_user)
4345            view
4346            external
4347            returns (address _user)
4348   {
4349     _user = read_next_from_indexed_addresses(system.groups_collection, bytes32(_group_id), _current_user);
4350   }
4351 
4352   /**
4353   @notice Returns the previous user of a group depending on the given current user
4354   @param _group_id Id of the group
4355   @param _current_user Address of the current user
4356   @return {"_user": "Address of the last user"}
4357   */
4358   function read_previous_user_in_group(bytes32 _group_id, address _current_user)
4359            view
4360            external
4361            returns (address _user)
4362   {
4363     _user = read_previous_from_indexed_addresses(system.groups_collection, bytes32(_group_id), _current_user);
4364   }
4365 
4366   /**
4367   @notice Returns the total number of users of a group
4368   @param _group_id Id of the group
4369   @return {"_total_users": "Total number of users"}
4370   */
4371   function read_total_users_in_group(bytes32 _group_id)
4372            view
4373            external
4374            returns (uint256 _total_users)
4375   {
4376     _total_users = read_total_indexed_addresses(system.groups_collection, bytes32(_group_id));
4377   }
4378 }
4379 
4380 // File: contracts/storage/DaoIdentityStorage.sol
4381 contract DaoIdentityStorage is ResolverClient, DaoConstants, DirectoryStorage {
4382 
4383     // struct for KYC details
4384     // doc is the IPFS doc hash for any information regarding this KYC
4385     // id_expiration is the UTC timestamp at which this KYC will expire
4386     // at any time after this, the user's KYC is invalid, and that user
4387     // MUST re-KYC before doing any proposer related operation in DigixDAO
4388     struct KycDetails {
4389         bytes32 doc;
4390         uint256 id_expiration;
4391     }
4392 
4393     // a mapping of address to the KYC details
4394     mapping (address => KycDetails) kycInfo;
4395 
4396     constructor(address _resolver)
4397         public
4398     {
4399         require(init(CONTRACT_STORAGE_DAO_IDENTITY, _resolver));
4400         require(initialize_directory());
4401     }
4402 
4403     function create_group(uint256 _role_id, bytes32 _name, bytes32 _document)
4404         public
4405         returns (bool _success, uint256 _group_id)
4406     {
4407         require(sender_is(CONTRACT_DAO_IDENTITY));
4408         (_success, _group_id) = internal_create_group(_role_id, _name, _document);
4409         require(_success);
4410     }
4411 
4412     function create_role(uint256 _role_id, bytes32 _name)
4413         public
4414         returns (bool _success)
4415     {
4416         require(sender_is(CONTRACT_DAO_IDENTITY));
4417         _success = internal_create_role(_role_id, _name);
4418         require(_success);
4419     }
4420 
4421     function update_add_user_to_group(uint256 _group_id, address _user, bytes32 _document)
4422         public
4423         returns (bool _success)
4424     {
4425         require(sender_is(CONTRACT_DAO_IDENTITY));
4426         _success = internal_update_add_user_to_group(_group_id, _user, _document);
4427         require(_success);
4428     }
4429 
4430     function update_remove_group_user(address _user)
4431         public
4432         returns (bool _success)
4433     {
4434         require(sender_is(CONTRACT_DAO_IDENTITY));
4435         _success = internal_destroy_group_user(_user);
4436         require(_success);
4437     }
4438 
4439     function update_kyc(address _user, bytes32 _doc, uint256 _id_expiration)
4440         public
4441     {
4442         require(sender_is(CONTRACT_DAO_IDENTITY));
4443         kycInfo[_user].doc = _doc;
4444         kycInfo[_user].id_expiration = _id_expiration;
4445     }
4446 
4447     function read_kyc_info(address _user)
4448         public
4449         view
4450         returns (bytes32 _doc, uint256 _id_expiration)
4451     {
4452         _doc = kycInfo[_user].doc;
4453         _id_expiration = kycInfo[_user].id_expiration;
4454     }
4455 
4456     function is_kyc_approved(address _user)
4457         public
4458         view
4459         returns (bool _approved)
4460     {
4461         uint256 _id_expiration;
4462         (,_id_expiration) = read_kyc_info(_user);
4463         _approved = _id_expiration > now;
4464     }
4465 }
4466 
4467 // File: contracts/common/IdentityCommon.sol
4468 contract IdentityCommon is DaoWhitelistingCommon {
4469 
4470     modifier if_root() {
4471         require(identity_storage().read_user_role_id(msg.sender) == ROLES_ROOT);
4472         _;
4473     }
4474 
4475     modifier if_founder() {
4476         require(is_founder());
4477         _;
4478     }
4479 
4480     function is_founder()
4481         internal
4482         view
4483         returns (bool _isFounder)
4484     {
4485         _isFounder = identity_storage().read_user_role_id(msg.sender) == ROLES_FOUNDERS;
4486     }
4487 
4488     modifier if_prl() {
4489         require(identity_storage().read_user_role_id(msg.sender) == ROLES_PRLS);
4490         _;
4491     }
4492 
4493     modifier if_kyc_admin() {
4494         require(identity_storage().read_user_role_id(msg.sender) == ROLES_KYC_ADMINS);
4495         _;
4496     }
4497 
4498     function identity_storage()
4499         internal
4500         view
4501         returns (DaoIdentityStorage _contract)
4502     {
4503         _contract = DaoIdentityStorage(get_contract(CONTRACT_STORAGE_DAO_IDENTITY));
4504     }
4505 }
4506 
4507 // File: contracts/storage/DaoConfigsStorage.sol
4508 contract DaoConfigsStorage is ResolverClient, DaoConstants {
4509 
4510     // mapping of config name to config value
4511     // config names can be found in DaoConstants contract
4512     mapping (bytes32 => uint256) public uintConfigs;
4513 
4514     // mapping of config name to config value
4515     // config names can be found in DaoConstants contract
4516     mapping (bytes32 => address) public addressConfigs;
4517 
4518     // mapping of config name to config value
4519     // config names can be found in DaoConstants contract
4520     mapping (bytes32 => bytes32) public bytesConfigs;
4521 
4522     uint256 ONE_BILLION = 1000000000;
4523     uint256 ONE_MILLION = 1000000;
4524 
4525     constructor(address _resolver)
4526         public
4527     {
4528         require(init(CONTRACT_STORAGE_DAO_CONFIG, _resolver));
4529 
4530         uintConfigs[CONFIG_LOCKING_PHASE_DURATION] = 10 days;
4531         uintConfigs[CONFIG_QUARTER_DURATION] = QUARTER_DURATION;
4532         uintConfigs[CONFIG_VOTING_COMMIT_PHASE] = 14 days;
4533         uintConfigs[CONFIG_VOTING_PHASE_TOTAL] = 21 days;
4534         uintConfigs[CONFIG_INTERIM_COMMIT_PHASE] = 7 days;
4535         uintConfigs[CONFIG_INTERIM_PHASE_TOTAL] = 14 days;
4536 
4537 
4538 
4539         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR] = 5; // 5%
4540         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR] = 100; // 5%
4541         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR] = 35; // 35%
4542         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR] = 100; // 35%
4543 
4544 
4545         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR] = 5; // 5%
4546         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR] = 100; // 5%
4547         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR] = 25; // 25%
4548         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR] = 100; // 25%
4549 
4550         uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR] = 1; // >50%
4551         uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR] = 2; // >50%
4552         uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR] = 1; // >50%
4553         uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR] = 2; // >50%
4554 
4555 
4556         uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE] = ONE_BILLION;
4557         uintConfigs[CONFIG_QUARTER_POINT_VOTE] = ONE_BILLION;
4558         uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE] = ONE_BILLION;
4559 
4560         uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH] = 20000 * ONE_BILLION;
4561 
4562         uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR] = 15; // 15% bonus for consistent votes
4563         uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR] = 100; // 15% bonus for consistent votes
4564 
4565         uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE] = 28 days;
4566         uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL] = 35 days;
4567 
4568 
4569 
4570         uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR] = 1; // >50%
4571         uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR] = 2; // >50%
4572 
4573         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR] = 40; // 40%
4574         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR] = 100; // 40%
4575 
4576         uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION] = 8334 * ONE_MILLION;
4577 
4578         uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING] = 1666 * ONE_MILLION;
4579         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM] = 1; // 1 extra QP gains 1/1 RP
4580         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN] = 1;
4581 
4582 
4583         uintConfigs[CONFIG_MINIMAL_QUARTER_POINT] = 2 * ONE_BILLION;
4584         uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR] = 400 * ONE_BILLION;
4585         uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR] = 2000 * ONE_BILLION;
4586 
4587         uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT] = 4 * ONE_BILLION;
4588         uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR] = 400 * ONE_BILLION;
4589         uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR] = 2000 * ONE_BILLION;
4590 
4591         uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM] = 42; //4.2% of DGX to moderator voting activity
4592         uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN] = 1000;
4593 
4594         uintConfigs[CONFIG_DRAFT_VOTING_PHASE] = 10 days;
4595 
4596         uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE] = 412500 * ONE_MILLION;
4597 
4598         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR] = 7; // 7%
4599         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR] = 100; // 7%
4600 
4601         uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION] = 12500 * ONE_MILLION;
4602         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM] = 1;
4603         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN] = 1;
4604 
4605         uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE] = 10 days;
4606 
4607         uintConfigs[CONFIG_MINIMUM_LOCKED_DGD] = 10 * ONE_BILLION;
4608         uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR] = 842 * ONE_BILLION;
4609         uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR] = 400 * ONE_BILLION;
4610 
4611         uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL] = 2 ether;
4612 
4613         uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX] = 100 ether;
4614         uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX] = 5;
4615         uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER] = 80;
4616 
4617         uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION] = 90 days;
4618         uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS] = 10 * ONE_BILLION;
4619     }
4620 
4621     function updateUintConfigs(uint256[] _uintConfigs)
4622         external
4623     {
4624         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
4625         uintConfigs[CONFIG_LOCKING_PHASE_DURATION] = _uintConfigs[0];
4626         /*
4627         This used to be a config that can be changed. Now, _uintConfigs[1] is just a dummy config that doesnt do anything
4628         uintConfigs[CONFIG_QUARTER_DURATION] = _uintConfigs[1];
4629         */
4630         uintConfigs[CONFIG_VOTING_COMMIT_PHASE] = _uintConfigs[2];
4631         uintConfigs[CONFIG_VOTING_PHASE_TOTAL] = _uintConfigs[3];
4632         uintConfigs[CONFIG_INTERIM_COMMIT_PHASE] = _uintConfigs[4];
4633         uintConfigs[CONFIG_INTERIM_PHASE_TOTAL] = _uintConfigs[5];
4634         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR] = _uintConfigs[6];
4635         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR] = _uintConfigs[7];
4636         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR] = _uintConfigs[8];
4637         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[9];
4638         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR] = _uintConfigs[10];
4639         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR] = _uintConfigs[11];
4640         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR] = _uintConfigs[12];
4641         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[13];
4642         uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR] = _uintConfigs[14];
4643         uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR] = _uintConfigs[15];
4644         uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR] = _uintConfigs[16];
4645         uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR] = _uintConfigs[17];
4646         uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE] = _uintConfigs[18];
4647         uintConfigs[CONFIG_QUARTER_POINT_VOTE] = _uintConfigs[19];
4648         uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE] = _uintConfigs[20];
4649         uintConfigs[CONFIG_MINIMAL_QUARTER_POINT] = _uintConfigs[21];
4650         uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH] = _uintConfigs[22];
4651         uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR] = _uintConfigs[23];
4652         uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR] = _uintConfigs[24];
4653         uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE] = _uintConfigs[25];
4654         uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL] = _uintConfigs[26];
4655         uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR] = _uintConfigs[27];
4656         uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR] = _uintConfigs[28];
4657         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR] = _uintConfigs[29];
4658         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR] = _uintConfigs[30];
4659         uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION] = _uintConfigs[31];
4660         uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING] = _uintConfigs[32];
4661         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM] = _uintConfigs[33];
4662         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN] = _uintConfigs[34];
4663         uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR] = _uintConfigs[35];
4664         uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR] = _uintConfigs[36];
4665         uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT] = _uintConfigs[37];
4666         uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR] = _uintConfigs[38];
4667         uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR] = _uintConfigs[39];
4668         uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM] = _uintConfigs[40];
4669         uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN] = _uintConfigs[41];
4670         uintConfigs[CONFIG_DRAFT_VOTING_PHASE] = _uintConfigs[42];
4671         uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE] = _uintConfigs[43];
4672         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR] = _uintConfigs[44];
4673         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[45];
4674         uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION] = _uintConfigs[46];
4675         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM] = _uintConfigs[47];
4676         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN] = _uintConfigs[48];
4677         uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE] = _uintConfigs[49];
4678         uintConfigs[CONFIG_MINIMUM_LOCKED_DGD] = _uintConfigs[50];
4679         uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR] = _uintConfigs[51];
4680         uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR] = _uintConfigs[52];
4681         uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL] = _uintConfigs[53];
4682         uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX] = _uintConfigs[54];
4683         uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX] = _uintConfigs[55];
4684         uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER] = _uintConfigs[56];
4685         uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION] = _uintConfigs[57];
4686         uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS] = _uintConfigs[58];
4687     }
4688 
4689     function readUintConfigs()
4690         public
4691         view
4692         returns (uint256[])
4693     {
4694         uint256[] memory _uintConfigs = new uint256[](59);
4695         _uintConfigs[0] = uintConfigs[CONFIG_LOCKING_PHASE_DURATION];
4696         _uintConfigs[1] = uintConfigs[CONFIG_QUARTER_DURATION];
4697         _uintConfigs[2] = uintConfigs[CONFIG_VOTING_COMMIT_PHASE];
4698         _uintConfigs[3] = uintConfigs[CONFIG_VOTING_PHASE_TOTAL];
4699         _uintConfigs[4] = uintConfigs[CONFIG_INTERIM_COMMIT_PHASE];
4700         _uintConfigs[5] = uintConfigs[CONFIG_INTERIM_PHASE_TOTAL];
4701         _uintConfigs[6] = uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR];
4702         _uintConfigs[7] = uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR];
4703         _uintConfigs[8] = uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR];
4704         _uintConfigs[9] = uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR];
4705         _uintConfigs[10] = uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR];
4706         _uintConfigs[11] = uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR];
4707         _uintConfigs[12] = uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR];
4708         _uintConfigs[13] = uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR];
4709         _uintConfigs[14] = uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR];
4710         _uintConfigs[15] = uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR];
4711         _uintConfigs[16] = uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR];
4712         _uintConfigs[17] = uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR];
4713         _uintConfigs[18] = uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE];
4714         _uintConfigs[19] = uintConfigs[CONFIG_QUARTER_POINT_VOTE];
4715         _uintConfigs[20] = uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE];
4716         _uintConfigs[21] = uintConfigs[CONFIG_MINIMAL_QUARTER_POINT];
4717         _uintConfigs[22] = uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH];
4718         _uintConfigs[23] = uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR];
4719         _uintConfigs[24] = uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR];
4720         _uintConfigs[25] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE];
4721         _uintConfigs[26] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL];
4722         _uintConfigs[27] = uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR];
4723         _uintConfigs[28] = uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR];
4724         _uintConfigs[29] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR];
4725         _uintConfigs[30] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR];
4726         _uintConfigs[31] = uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION];
4727         _uintConfigs[32] = uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING];
4728         _uintConfigs[33] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM];
4729         _uintConfigs[34] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN];
4730         _uintConfigs[35] = uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR];
4731         _uintConfigs[36] = uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR];
4732         _uintConfigs[37] = uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT];
4733         _uintConfigs[38] = uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR];
4734         _uintConfigs[39] = uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR];
4735         _uintConfigs[40] = uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM];
4736         _uintConfigs[41] = uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN];
4737         _uintConfigs[42] = uintConfigs[CONFIG_DRAFT_VOTING_PHASE];
4738         _uintConfigs[43] = uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE];
4739         _uintConfigs[44] = uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR];
4740         _uintConfigs[45] = uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR];
4741         _uintConfigs[46] = uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION];
4742         _uintConfigs[47] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM];
4743         _uintConfigs[48] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN];
4744         _uintConfigs[49] = uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE];
4745         _uintConfigs[50] = uintConfigs[CONFIG_MINIMUM_LOCKED_DGD];
4746         _uintConfigs[51] = uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR];
4747         _uintConfigs[52] = uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR];
4748         _uintConfigs[53] = uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL];
4749         _uintConfigs[54] = uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX];
4750         _uintConfigs[55] = uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX];
4751         _uintConfigs[56] = uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER];
4752         _uintConfigs[57] = uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION];
4753         _uintConfigs[58] = uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS];
4754         return _uintConfigs;
4755     }
4756 }
4757 
4758 // File: contracts/storage/DaoProposalCounterStorage.sol
4759 contract DaoProposalCounterStorage is ResolverClient, DaoConstants {
4760 
4761     constructor(address _resolver) public {
4762         require(init(CONTRACT_STORAGE_DAO_COUNTER, _resolver));
4763     }
4764 
4765     // This is to mark the number of proposals that have been funded in a specific quarter
4766     // this is to take care of the cap on the number of funded proposals in a quarter
4767     mapping (uint256 => uint256) public proposalCountByQuarter;
4768 
4769     function addNonDigixProposalCountInQuarter(uint256 _quarterNumber)
4770         public
4771     {
4772         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
4773         proposalCountByQuarter[_quarterNumber] = proposalCountByQuarter[_quarterNumber].add(1);
4774     }
4775 }
4776 
4777 // File: contracts/storage/DaoUpgradeStorage.sol
4778 contract DaoUpgradeStorage is ResolverClient, DaoConstants {
4779 
4780     // this UTC timestamp marks the start of the first quarter
4781     // of DigixDAO. All time related calculations in DaoCommon
4782     // depend on this value
4783     uint256 public startOfFirstQuarter;
4784 
4785     // this boolean marks whether the DAO contracts have been replaced
4786     // by newer versions or not. The process of migration is done by deploying
4787     // a new set of contracts, transferring funds from these contracts to the new ones
4788     // migrating some state variables, and finally setting this boolean to true
4789     // All operations in these contracts that may transfer tokens, claim ether,
4790     // boost one's reputation, etc. SHOULD fail if this is true
4791     bool public isReplacedByNewDao;
4792 
4793     // this is the address of the new Dao contract
4794     address public newDaoContract;
4795 
4796     // this is the address of the new DaoFundingManager contract
4797     // ether funds will be moved from the current version's contract to this
4798     // new contract
4799     address public newDaoFundingManager;
4800 
4801     // this is the address of the new DaoRewardsManager contract
4802     // DGX funds will be moved from the current version of contract to this
4803     // new contract
4804     address public newDaoRewardsManager;
4805 
4806     constructor(address _resolver) public {
4807         require(init(CONTRACT_STORAGE_DAO_UPGRADE, _resolver));
4808     }
4809 
4810     function setStartOfFirstQuarter(uint256 _start)
4811         public
4812     {
4813         require(sender_is(CONTRACT_DAO));
4814         startOfFirstQuarter = _start;
4815     }
4816 
4817 
4818     function setNewContractAddresses(
4819         address _newDaoContract,
4820         address _newDaoFundingManager,
4821         address _newDaoRewardsManager
4822     )
4823         public
4824     {
4825         require(sender_is(CONTRACT_DAO));
4826         newDaoContract = _newDaoContract;
4827         newDaoFundingManager = _newDaoFundingManager;
4828         newDaoRewardsManager = _newDaoRewardsManager;
4829     }
4830 
4831 
4832     function updateForDaoMigration()
4833         public
4834     {
4835         require(sender_is(CONTRACT_DAO));
4836         isReplacedByNewDao = true;
4837     }
4838 }
4839 
4840 // File: contracts/storage/DaoSpecialStorage.sol
4841 contract DaoSpecialStorage is DaoWhitelistingCommon {
4842     using DoublyLinkedList for DoublyLinkedList.Bytes;
4843     using DaoStructs for DaoStructs.SpecialProposal;
4844     using DaoStructs for DaoStructs.Voting;
4845 
4846     // List of all the special proposals ever created in DigixDAO
4847     DoublyLinkedList.Bytes proposals;
4848 
4849     // mapping of the SpecialProposal struct by its ID
4850     // ID is also the IPFS doc hash of the proposal
4851     mapping (bytes32 => DaoStructs.SpecialProposal) proposalsById;
4852 
4853     constructor(address _resolver) public {
4854         require(init(CONTRACT_STORAGE_DAO_SPECIAL, _resolver));
4855     }
4856 
4857     function addSpecialProposal(
4858         bytes32 _proposalId,
4859         address _proposer,
4860         uint256[] _uintConfigs,
4861         address[] _addressConfigs,
4862         bytes32[] _bytesConfigs
4863     )
4864         public
4865     {
4866         require(sender_is(CONTRACT_DAO_SPECIAL_PROPOSAL));
4867         require(
4868           (proposalsById[_proposalId].proposalId == EMPTY_BYTES) &&
4869           (_proposalId != EMPTY_BYTES)
4870         );
4871         proposals.append(_proposalId);
4872         proposalsById[_proposalId].proposalId = _proposalId;
4873         proposalsById[_proposalId].proposer = _proposer;
4874         proposalsById[_proposalId].timeCreated = now;
4875         proposalsById[_proposalId].uintConfigs = _uintConfigs;
4876         proposalsById[_proposalId].addressConfigs = _addressConfigs;
4877         proposalsById[_proposalId].bytesConfigs = _bytesConfigs;
4878     }
4879 
4880     function readProposal(bytes32 _proposalId)
4881         public
4882         view
4883         returns (
4884             bytes32 _id,
4885             address _proposer,
4886             uint256 _timeCreated,
4887             uint256 _timeVotingStarted
4888         )
4889     {
4890         _id = proposalsById[_proposalId].proposalId;
4891         _proposer = proposalsById[_proposalId].proposer;
4892         _timeCreated = proposalsById[_proposalId].timeCreated;
4893         _timeVotingStarted = proposalsById[_proposalId].voting.startTime;
4894     }
4895 
4896     function readProposalProposer(bytes32 _proposalId)
4897         public
4898         view
4899         returns (address _proposer)
4900     {
4901         _proposer = proposalsById[_proposalId].proposer;
4902     }
4903 
4904     function readConfigs(bytes32 _proposalId)
4905         public
4906         view
4907         returns (
4908             uint256[] memory _uintConfigs,
4909             address[] memory _addressConfigs,
4910             bytes32[] memory _bytesConfigs
4911         )
4912     {
4913         _uintConfigs = proposalsById[_proposalId].uintConfigs;
4914         _addressConfigs = proposalsById[_proposalId].addressConfigs;
4915         _bytesConfigs = proposalsById[_proposalId].bytesConfigs;
4916     }
4917 
4918     function readVotingCount(bytes32 _proposalId, address[] _allUsers)
4919         external
4920         view
4921         returns (uint256 _for, uint256 _against)
4922     {
4923         require(senderIsAllowedToRead());
4924         return proposalsById[_proposalId].voting.countVotes(_allUsers);
4925     }
4926 
4927     function readVotingTime(bytes32 _proposalId)
4928         public
4929         view
4930         returns (uint256 _start)
4931     {
4932         require(senderIsAllowedToRead());
4933         _start = proposalsById[_proposalId].voting.startTime;
4934     }
4935 
4936     function commitVote(
4937         bytes32 _proposalId,
4938         bytes32 _hash,
4939         address _voter
4940     )
4941         public
4942     {
4943         require(sender_is(CONTRACT_DAO_VOTING));
4944         proposalsById[_proposalId].voting.commits[_voter] = _hash;
4945     }
4946 
4947     function readComittedVote(bytes32 _proposalId, address _voter)
4948         public
4949         view
4950         returns (bytes32 _commitHash)
4951     {
4952         require(senderIsAllowedToRead());
4953         _commitHash = proposalsById[_proposalId].voting.commits[_voter];
4954     }
4955 
4956     function setVotingTime(bytes32 _proposalId, uint256 _time)
4957         public
4958     {
4959         require(sender_is(CONTRACT_DAO_SPECIAL_PROPOSAL));
4960         proposalsById[_proposalId].voting.startTime = _time;
4961     }
4962 
4963     function readVotingResult(bytes32 _proposalId)
4964         public
4965         view
4966         returns (bool _result)
4967     {
4968         require(senderIsAllowedToRead());
4969         _result = proposalsById[_proposalId].voting.passed;
4970     }
4971 
4972     function setPass(bytes32 _proposalId, bool _result)
4973         public
4974     {
4975         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
4976         proposalsById[_proposalId].voting.passed = _result;
4977     }
4978 
4979     function setVotingClaim(bytes32 _proposalId, bool _claimed)
4980         public
4981     {
4982         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
4983         DaoStructs.SpecialProposal storage _proposal = proposalsById[_proposalId];
4984         _proposal.voting.claimed = _claimed;
4985     }
4986 
4987     function isClaimed(bytes32 _proposalId)
4988         public
4989         view
4990         returns (bool _claimed)
4991     {
4992         require(senderIsAllowedToRead());
4993         _claimed = proposalsById[_proposalId].voting.claimed;
4994     }
4995 
4996     function readVote(bytes32 _proposalId, address _voter)
4997         public
4998         view
4999         returns (bool _vote, uint256 _weight)
5000     {
5001         require(senderIsAllowedToRead());
5002         return proposalsById[_proposalId].voting.readVote(_voter);
5003     }
5004 
5005     function revealVote(
5006         bytes32 _proposalId,
5007         address _voter,
5008         bool _vote,
5009         uint256 _weight
5010     )
5011         public
5012     {
5013         require(sender_is(CONTRACT_DAO_VOTING));
5014         proposalsById[_proposalId].voting.revealVote(_voter, _vote, _weight);
5015     }
5016 }
5017 
5018 // File: contracts/storage/DaoPointsStorage.sol
5019 contract DaoPointsStorage is ResolverClient, DaoConstants {
5020 
5021     // struct for a non-transferrable token
5022     struct Token {
5023         uint256 totalSupply;
5024         mapping (address => uint256) balance;
5025     }
5026 
5027     // the reputation point token
5028     // since reputation is cumulative, we only need to store one value
5029     Token reputationPoint;
5030 
5031     // since quarter points are specific to quarters, we need a mapping from
5032     // quarter number to the quarter point token for that quarter
5033     mapping (uint256 => Token) quarterPoint;
5034 
5035     // the same is the case with quarter moderator points
5036     // these are specific to quarters
5037     mapping (uint256 => Token) quarterModeratorPoint;
5038 
5039     constructor(address _resolver)
5040         public
5041     {
5042         require(init(CONTRACT_STORAGE_DAO_POINTS, _resolver));
5043     }
5044 
5045     /// @notice add quarter points for a _participant for a _quarterNumber
5046     function addQuarterPoint(address _participant, uint256 _point, uint256 _quarterNumber)
5047         public
5048         returns (uint256 _newPoint, uint256 _newTotalPoint)
5049     {
5050         require(sender_is_from([CONTRACT_DAO_VOTING, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
5051         quarterPoint[_quarterNumber].totalSupply = quarterPoint[_quarterNumber].totalSupply.add(_point);
5052         quarterPoint[_quarterNumber].balance[_participant] = quarterPoint[_quarterNumber].balance[_participant].add(_point);
5053 
5054         _newPoint = quarterPoint[_quarterNumber].balance[_participant];
5055         _newTotalPoint = quarterPoint[_quarterNumber].totalSupply;
5056     }
5057 
5058     function addModeratorQuarterPoint(address _participant, uint256 _point, uint256 _quarterNumber)
5059         public
5060         returns (uint256 _newPoint, uint256 _newTotalPoint)
5061     {
5062         require(sender_is_from([CONTRACT_DAO_VOTING, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
5063         quarterModeratorPoint[_quarterNumber].totalSupply = quarterModeratorPoint[_quarterNumber].totalSupply.add(_point);
5064         quarterModeratorPoint[_quarterNumber].balance[_participant] = quarterModeratorPoint[_quarterNumber].balance[_participant].add(_point);
5065 
5066         _newPoint = quarterModeratorPoint[_quarterNumber].balance[_participant];
5067         _newTotalPoint = quarterModeratorPoint[_quarterNumber].totalSupply;
5068     }
5069 
5070     /// @notice get quarter points for a _participant in a _quarterNumber
5071     function getQuarterPoint(address _participant, uint256 _quarterNumber)
5072         public
5073         view
5074         returns (uint256 _point)
5075     {
5076         _point = quarterPoint[_quarterNumber].balance[_participant];
5077     }
5078 
5079     function getQuarterModeratorPoint(address _participant, uint256 _quarterNumber)
5080         public
5081         view
5082         returns (uint256 _point)
5083     {
5084         _point = quarterModeratorPoint[_quarterNumber].balance[_participant];
5085     }
5086 
5087     /// @notice get total quarter points for a particular _quarterNumber
5088     function getTotalQuarterPoint(uint256 _quarterNumber)
5089         public
5090         view
5091         returns (uint256 _totalPoint)
5092     {
5093         _totalPoint = quarterPoint[_quarterNumber].totalSupply;
5094     }
5095 
5096     function getTotalQuarterModeratorPoint(uint256 _quarterNumber)
5097         public
5098         view
5099         returns (uint256 _totalPoint)
5100     {
5101         _totalPoint = quarterModeratorPoint[_quarterNumber].totalSupply;
5102     }
5103 
5104     /// @notice add reputation points for a _participant
5105     function increaseReputation(address _participant, uint256 _point)
5106         public
5107         returns (uint256 _newPoint, uint256 _totalPoint)
5108     {
5109         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING]));
5110         reputationPoint.totalSupply = reputationPoint.totalSupply.add(_point);
5111         reputationPoint.balance[_participant] = reputationPoint.balance[_participant].add(_point);
5112 
5113         _newPoint = reputationPoint.balance[_participant];
5114         _totalPoint = reputationPoint.totalSupply;
5115     }
5116 
5117     /// @notice subtract reputation points for a _participant
5118     function reduceReputation(address _participant, uint256 _point)
5119         public
5120         returns (uint256 _newPoint, uint256 _totalPoint)
5121     {
5122         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
5123         uint256 _toDeduct = _point;
5124         if (reputationPoint.balance[_participant] > _point) {
5125             reputationPoint.balance[_participant] = reputationPoint.balance[_participant].sub(_point);
5126         } else {
5127             _toDeduct = reputationPoint.balance[_participant];
5128             reputationPoint.balance[_participant] = 0;
5129         }
5130 
5131         reputationPoint.totalSupply = reputationPoint.totalSupply.sub(_toDeduct);
5132 
5133         _newPoint = reputationPoint.balance[_participant];
5134         _totalPoint = reputationPoint.totalSupply;
5135     }
5136 
5137   /// @notice get reputation points for a _participant
5138   function getReputation(address _participant)
5139       public
5140       view
5141       returns (uint256 _point)
5142   {
5143       _point = reputationPoint.balance[_participant];
5144   }
5145 
5146   /// @notice get total reputation points distributed in the dao
5147   function getTotalReputation()
5148       public
5149       view
5150       returns (uint256 _totalPoint)
5151   {
5152       _totalPoint = reputationPoint.totalSupply;
5153   }
5154 }
5155 
5156 // File: contracts/storage/DaoRewardsStorage.sol
5157 // this contract will receive DGXs fees from the DGX fees distributors
5158 contract DaoRewardsStorage is ResolverClient, DaoConstants {
5159     using DaoStructs for DaoStructs.DaoQuarterInfo;
5160 
5161     // DaoQuarterInfo is a struct that stores the quarter specific information
5162     // regarding totalEffectiveDGDs, DGX distribution day, etc. pls check
5163     // docs in lib/DaoStructs
5164     mapping(uint256 => DaoStructs.DaoQuarterInfo) public allQuartersInfo;
5165 
5166     // Mapping that stores the DGX that can be claimed as rewards by
5167     // an address (a participant of DigixDAO)
5168     mapping(address => uint256) public claimableDGXs;
5169 
5170     // This stores the total DGX value that has been claimed by participants
5171     // this can be done by calling the DaoRewardsManager.claimRewards method
5172     // Note that this value is the only outgoing DGX from DaoRewardsManager contract
5173     // Note that this value also takes into account the demurrage that has been paid
5174     // by participants for simply holding their DGXs in the DaoRewardsManager contract
5175     uint256 public totalDGXsClaimed;
5176 
5177     // The Quarter ID in which the user last participated in
5178     // To participate means they had locked more than CONFIG_MINIMUM_LOCKED_DGD
5179     // DGD tokens. In addition, they should not have withdrawn those tokens in the same
5180     // quarter. Basically, in the main phase of the quarter, if DaoCommon.isParticipant(_user)
5181     // was true, they were participants. And that quarter was their lastParticipatedQuarter
5182     mapping (address => uint256) public lastParticipatedQuarter;
5183 
5184     // This mapping is only used to update the lastParticipatedQuarter to the
5185     // previousLastParticipatedQuarter in case users lock and withdraw DGDs
5186     // within the same quarter's locking phase
5187     mapping (address => uint256) public previousLastParticipatedQuarter;
5188 
5189     // This number marks the Quarter in which the rewards were last updated for that user
5190     // Since the rewards calculation for a specific quarter is only done once that
5191     // quarter is completed, we need this value to note the last quarter when the rewards were updated
5192     // We then start adding the rewards for all quarters after that quarter, until the current quarter
5193     mapping (address => uint256) public lastQuarterThatRewardsWasUpdated;
5194 
5195     // Similar as the lastQuarterThatRewardsWasUpdated, but this is for reputation updates
5196     // Note that reputation can also be deducted for no participation (not locking DGDs)
5197     // This value is used to update the reputation based on all quarters from the lastQuarterThatReputationWasUpdated
5198     // to the current quarter
5199     mapping (address => uint256) public lastQuarterThatReputationWasUpdated;
5200 
5201     constructor(address _resolver)
5202            public
5203     {
5204         require(init(CONTRACT_STORAGE_DAO_REWARDS, _resolver));
5205     }
5206 
5207     function updateQuarterInfo(
5208         uint256 _quarterNumber,
5209         uint256 _minimalParticipationPoint,
5210         uint256 _quarterPointScalingFactor,
5211         uint256 _reputationPointScalingFactor,
5212         uint256 _totalEffectiveDGDPreviousQuarter,
5213 
5214         uint256 _moderatorMinimalQuarterPoint,
5215         uint256 _moderatorQuarterPointScalingFactor,
5216         uint256 _moderatorReputationPointScalingFactor,
5217         uint256 _totalEffectiveModeratorDGDLastQuarter,
5218 
5219         uint256 _dgxDistributionDay,
5220         uint256 _dgxRewardsPoolLastQuarter,
5221         uint256 _sumRewardsFromBeginning
5222     )
5223         public
5224     {
5225         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5226         allQuartersInfo[_quarterNumber].minimalParticipationPoint = _minimalParticipationPoint;
5227         allQuartersInfo[_quarterNumber].quarterPointScalingFactor = _quarterPointScalingFactor;
5228         allQuartersInfo[_quarterNumber].reputationPointScalingFactor = _reputationPointScalingFactor;
5229         allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter = _totalEffectiveDGDPreviousQuarter;
5230 
5231         allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint = _moderatorMinimalQuarterPoint;
5232         allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor = _moderatorQuarterPointScalingFactor;
5233         allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor = _moderatorReputationPointScalingFactor;
5234         allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter = _totalEffectiveModeratorDGDLastQuarter;
5235 
5236         allQuartersInfo[_quarterNumber].dgxDistributionDay = _dgxDistributionDay;
5237         allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter = _dgxRewardsPoolLastQuarter;
5238         allQuartersInfo[_quarterNumber].sumRewardsFromBeginning = _sumRewardsFromBeginning;
5239     }
5240 
5241     function updateClaimableDGX(address _user, uint256 _newClaimableDGX)
5242         public
5243     {
5244         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5245         claimableDGXs[_user] = _newClaimableDGX;
5246     }
5247 
5248     function updateLastParticipatedQuarter(address _user, uint256 _lastQuarter)
5249         public
5250     {
5251         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
5252         lastParticipatedQuarter[_user] = _lastQuarter;
5253     }
5254 
5255     function updatePreviousLastParticipatedQuarter(address _user, uint256 _lastQuarter)
5256         public
5257     {
5258         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
5259         previousLastParticipatedQuarter[_user] = _lastQuarter;
5260     }
5261 
5262     function updateLastQuarterThatRewardsWasUpdated(address _user, uint256 _lastQuarter)
5263         public
5264     {
5265         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING, EMPTY_BYTES]));
5266         lastQuarterThatRewardsWasUpdated[_user] = _lastQuarter;
5267     }
5268 
5269     function updateLastQuarterThatReputationWasUpdated(address _user, uint256 _lastQuarter)
5270         public
5271     {
5272         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING, EMPTY_BYTES]));
5273         lastQuarterThatReputationWasUpdated[_user] = _lastQuarter;
5274     }
5275 
5276     function addToTotalDgxClaimed(uint256 _dgxClaimed)
5277         public
5278     {
5279         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5280         totalDGXsClaimed = totalDGXsClaimed.add(_dgxClaimed);
5281     }
5282 
5283     function readQuarterInfo(uint256 _quarterNumber)
5284         public
5285         view
5286         returns (
5287             uint256 _minimalParticipationPoint,
5288             uint256 _quarterPointScalingFactor,
5289             uint256 _reputationPointScalingFactor,
5290             uint256 _totalEffectiveDGDPreviousQuarter,
5291 
5292             uint256 _moderatorMinimalQuarterPoint,
5293             uint256 _moderatorQuarterPointScalingFactor,
5294             uint256 _moderatorReputationPointScalingFactor,
5295             uint256 _totalEffectiveModeratorDGDLastQuarter,
5296 
5297             uint256 _dgxDistributionDay,
5298             uint256 _dgxRewardsPoolLastQuarter,
5299             uint256 _sumRewardsFromBeginning
5300         )
5301     {
5302         _minimalParticipationPoint = allQuartersInfo[_quarterNumber].minimalParticipationPoint;
5303         _quarterPointScalingFactor = allQuartersInfo[_quarterNumber].quarterPointScalingFactor;
5304         _reputationPointScalingFactor = allQuartersInfo[_quarterNumber].reputationPointScalingFactor;
5305         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5306         _moderatorMinimalQuarterPoint = allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint;
5307         _moderatorQuarterPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor;
5308         _moderatorReputationPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor;
5309         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5310         _dgxDistributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5311         _dgxRewardsPoolLastQuarter = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5312         _sumRewardsFromBeginning = allQuartersInfo[_quarterNumber].sumRewardsFromBeginning;
5313     }
5314 
5315     function readQuarterGeneralInfo(uint256 _quarterNumber)
5316         public
5317         view
5318         returns (
5319             uint256 _dgxDistributionDay,
5320             uint256 _dgxRewardsPoolLastQuarter,
5321             uint256 _sumRewardsFromBeginning
5322         )
5323     {
5324         _dgxDistributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5325         _dgxRewardsPoolLastQuarter = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5326         _sumRewardsFromBeginning = allQuartersInfo[_quarterNumber].sumRewardsFromBeginning;
5327     }
5328 
5329     function readQuarterModeratorInfo(uint256 _quarterNumber)
5330         public
5331         view
5332         returns (
5333             uint256 _moderatorMinimalQuarterPoint,
5334             uint256 _moderatorQuarterPointScalingFactor,
5335             uint256 _moderatorReputationPointScalingFactor,
5336             uint256 _totalEffectiveModeratorDGDLastQuarter
5337         )
5338     {
5339         _moderatorMinimalQuarterPoint = allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint;
5340         _moderatorQuarterPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor;
5341         _moderatorReputationPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor;
5342         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5343     }
5344 
5345     function readQuarterParticipantInfo(uint256 _quarterNumber)
5346         public
5347         view
5348         returns (
5349             uint256 _minimalParticipationPoint,
5350             uint256 _quarterPointScalingFactor,
5351             uint256 _reputationPointScalingFactor,
5352             uint256 _totalEffectiveDGDPreviousQuarter
5353         )
5354     {
5355         _minimalParticipationPoint = allQuartersInfo[_quarterNumber].minimalParticipationPoint;
5356         _quarterPointScalingFactor = allQuartersInfo[_quarterNumber].quarterPointScalingFactor;
5357         _reputationPointScalingFactor = allQuartersInfo[_quarterNumber].reputationPointScalingFactor;
5358         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5359     }
5360 
5361     function readDgxDistributionDay(uint256 _quarterNumber)
5362         public
5363         view
5364         returns (uint256 _distributionDay)
5365     {
5366         _distributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5367     }
5368 
5369     function readTotalEffectiveDGDLastQuarter(uint256 _quarterNumber)
5370         public
5371         view
5372         returns (uint256 _totalEffectiveDGDPreviousQuarter)
5373     {
5374         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5375     }
5376 
5377     function readTotalEffectiveModeratorDGDLastQuarter(uint256 _quarterNumber)
5378         public
5379         view
5380         returns (uint256 _totalEffectiveModeratorDGDLastQuarter)
5381     {
5382         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5383     }
5384 
5385     function readRewardsPoolOfLastQuarter(uint256 _quarterNumber)
5386         public
5387         view
5388         returns (uint256 _rewardsPool)
5389     {
5390         _rewardsPool = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5391     }
5392 }
5393 
5394 // File: contracts/storage/IntermediateResultsStorage.sol
5395 contract IntermediateResultsStorage is ResolverClient, DaoConstants {
5396     using DaoStructs for DaoStructs.IntermediateResults;
5397 
5398     constructor(address _resolver) public {
5399         require(init(CONTRACT_STORAGE_INTERMEDIATE_RESULTS, _resolver));
5400     }
5401 
5402     // There are scenarios in which we must loop across all participants/moderators
5403     // in a function call. For a big number of operations, the function call may be short of gas
5404     // To tackle this, we use an IntermediateResults struct to store the intermediate results
5405     // The same function is then called multiple times until all operations are completed
5406     // If the operations cannot be done in that iteration, the intermediate results are stored
5407     // else, the final outcome is returned
5408     // Please check the lib/DaoStructs for docs on this struct
5409     mapping (bytes32 => DaoStructs.IntermediateResults) allIntermediateResults;
5410 
5411     function getIntermediateResults(bytes32 _key)
5412         public
5413         view
5414         returns (
5415             address _countedUntil,
5416             uint256 _currentForCount,
5417             uint256 _currentAgainstCount,
5418             uint256 _currentSumOfEffectiveBalance
5419         )
5420     {
5421         _countedUntil = allIntermediateResults[_key].countedUntil;
5422         _currentForCount = allIntermediateResults[_key].currentForCount;
5423         _currentAgainstCount = allIntermediateResults[_key].currentAgainstCount;
5424         _currentSumOfEffectiveBalance = allIntermediateResults[_key].currentSumOfEffectiveBalance;
5425     }
5426 
5427     function resetIntermediateResults(bytes32 _key)
5428         public
5429     {
5430         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_SPECIAL_VOTING_CLAIMS]));
5431         allIntermediateResults[_key].countedUntil = address(0x0);
5432     }
5433 
5434     function setIntermediateResults(
5435         bytes32 _key,
5436         address _countedUntil,
5437         uint256 _currentForCount,
5438         uint256 _currentAgainstCount,
5439         uint256 _currentSumOfEffectiveBalance
5440     )
5441         public
5442     {
5443         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_SPECIAL_VOTING_CLAIMS]));
5444         allIntermediateResults[_key].countedUntil = _countedUntil;
5445         allIntermediateResults[_key].currentForCount = _currentForCount;
5446         allIntermediateResults[_key].currentAgainstCount = _currentAgainstCount;
5447         allIntermediateResults[_key].currentSumOfEffectiveBalance = _currentSumOfEffectiveBalance;
5448     }
5449 }
5450 
5451 // File: contracts/lib/MathHelper.sol
5452 library MathHelper {
5453 
5454   using SafeMath for uint256;
5455 
5456   function max(uint256 a, uint256 b) internal pure returns (uint256 _max){
5457       _max = b;
5458       if (a > b) {
5459           _max = a;
5460       }
5461   }
5462 
5463   function min(uint256 a, uint256 b) internal pure returns (uint256 _min){
5464       _min = b;
5465       if (a < b) {
5466           _min = a;
5467       }
5468   }
5469 
5470   function sumNumbers(uint256[] _numbers) internal pure returns (uint256 _sum) {
5471       for (uint256 i=0;i<_numbers.length;i++) {
5472           _sum = _sum.add(_numbers[i]);
5473       }
5474   }
5475 }
5476 
5477 // File: contracts/common/DaoCommonMini.sol
5478 contract DaoCommonMini is IdentityCommon {
5479 
5480     using MathHelper for MathHelper;
5481 
5482     /**
5483     @notice Check if the DAO contracts have been replaced by a new set of contracts
5484     @return _isNotReplaced true if it is not replaced, false if it has already been replaced
5485     */
5486     function isDaoNotReplaced()
5487         public
5488         view
5489         returns (bool _isNotReplaced)
5490     {
5491         _isNotReplaced = !daoUpgradeStorage().isReplacedByNewDao();
5492     }
5493 
5494     /**
5495     @notice Check if it is currently in the locking phase
5496     @dev No governance activities can happen in the locking phase. The locking phase is from t=0 to t=CONFIG_LOCKING_PHASE_DURATION-1
5497     @return _isLockingPhase true if it is in the locking phase
5498     */
5499     function isLockingPhase()
5500         public
5501         view
5502         returns (bool _isLockingPhase)
5503     {
5504         _isLockingPhase = currentTimeInQuarter() < getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
5505     }
5506 
5507     /**
5508     @notice Check if it is currently in a main phase.
5509     @dev The main phase is where all the governance activities could take plase. If the DAO is replaced, there can never be any more main phase.
5510     @return _isMainPhase true if it is in a main phase
5511     */
5512     function isMainPhase()
5513         public
5514         view
5515         returns (bool _isMainPhase)
5516     {
5517         _isMainPhase =
5518             isDaoNotReplaced() &&
5519             currentTimeInQuarter() >= getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
5520     }
5521 
5522     /**
5523     @notice Check if the calculateGlobalRewardsBeforeNewQuarter function has been done for a certain quarter
5524     @dev However, there is no need to run calculateGlobalRewardsBeforeNewQuarter for the first quarter
5525     */
5526     modifier ifGlobalRewardsSet(uint256 _quarterNumber) {
5527         if (_quarterNumber > 1) {
5528             require(daoRewardsStorage().readDgxDistributionDay(_quarterNumber) > 0);
5529         }
5530         _;
5531     }
5532 
5533     /**
5534     @notice require that it is currently during a phase, which is within _relativePhaseStart and _relativePhaseEnd seconds, after the _startingPoint
5535     */
5536     function requireInPhase(uint256 _startingPoint, uint256 _relativePhaseStart, uint256 _relativePhaseEnd)
5537         internal
5538         view
5539     {
5540         require(_startingPoint > 0);
5541         require(now < _startingPoint.add(_relativePhaseEnd));
5542         require(now >= _startingPoint.add(_relativePhaseStart));
5543     }
5544 
5545     /**
5546     @notice Get the current quarter index
5547     @dev Quarter indexes starts from 1
5548     @return _quarterNumber the current quarter index
5549     */
5550     function currentQuarterNumber()
5551         public
5552         view
5553         returns(uint256 _quarterNumber)
5554     {
5555         _quarterNumber = getQuarterNumber(now);
5556     }
5557 
5558     /**
5559     @notice Get the quarter index of a timestamp
5560     @dev Quarter indexes starts from 1
5561     @return _index the quarter index
5562     */
5563     function getQuarterNumber(uint256 _time)
5564         internal
5565         view
5566         returns (uint256 _index)
5567     {
5568         require(startOfFirstQuarterIsSet());
5569         _index =
5570             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
5571             .div(getUintConfig(CONFIG_QUARTER_DURATION))
5572             .add(1);
5573     }
5574 
5575     /**
5576     @notice Get the relative time in quarter of a timestamp
5577     @dev For example, the timeInQuarter of the first second of any quarter n-th is always 1
5578     */
5579     function timeInQuarter(uint256 _time)
5580         internal
5581         view
5582         returns (uint256 _timeInQuarter)
5583     {
5584         require(startOfFirstQuarterIsSet()); // must be already set
5585         _timeInQuarter =
5586             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
5587             % getUintConfig(CONFIG_QUARTER_DURATION);
5588     }
5589 
5590     /**
5591     @notice Check if the start of first quarter is already set
5592     @return _isSet true if start of first quarter is already set
5593     */
5594     function startOfFirstQuarterIsSet()
5595         internal
5596         view
5597         returns (bool _isSet)
5598     {
5599         _isSet = daoUpgradeStorage().startOfFirstQuarter() != 0;
5600     }
5601 
5602     /**
5603     @notice Get the current relative time in the quarter
5604     @dev For example: the currentTimeInQuarter of the first second of any quarter is 1
5605     @return _currentT the current relative time in the quarter
5606     */
5607     function currentTimeInQuarter()
5608         public
5609         view
5610         returns (uint256 _currentT)
5611     {
5612         _currentT = timeInQuarter(now);
5613     }
5614 
5615     /**
5616     @notice Get the time remaining in the quarter
5617     */
5618     function getTimeLeftInQuarter(uint256 _time)
5619         internal
5620         view
5621         returns (uint256 _timeLeftInQuarter)
5622     {
5623         _timeLeftInQuarter = getUintConfig(CONFIG_QUARTER_DURATION).sub(timeInQuarter(_time));
5624     }
5625 
5626     function daoListingService()
5627         internal
5628         view
5629         returns (DaoListingService _contract)
5630     {
5631         _contract = DaoListingService(get_contract(CONTRACT_SERVICE_DAO_LISTING));
5632     }
5633 
5634     function daoConfigsStorage()
5635         internal
5636         view
5637         returns (DaoConfigsStorage _contract)
5638     {
5639         _contract = DaoConfigsStorage(get_contract(CONTRACT_STORAGE_DAO_CONFIG));
5640     }
5641 
5642     function daoStakeStorage()
5643         internal
5644         view
5645         returns (DaoStakeStorage _contract)
5646     {
5647         _contract = DaoStakeStorage(get_contract(CONTRACT_STORAGE_DAO_STAKE));
5648     }
5649 
5650     function daoStorage()
5651         internal
5652         view
5653         returns (DaoStorage _contract)
5654     {
5655         _contract = DaoStorage(get_contract(CONTRACT_STORAGE_DAO));
5656     }
5657 
5658     function daoProposalCounterStorage()
5659         internal
5660         view
5661         returns (DaoProposalCounterStorage _contract)
5662     {
5663         _contract = DaoProposalCounterStorage(get_contract(CONTRACT_STORAGE_DAO_COUNTER));
5664     }
5665 
5666     function daoUpgradeStorage()
5667         internal
5668         view
5669         returns (DaoUpgradeStorage _contract)
5670     {
5671         _contract = DaoUpgradeStorage(get_contract(CONTRACT_STORAGE_DAO_UPGRADE));
5672     }
5673 
5674     function daoSpecialStorage()
5675         internal
5676         view
5677         returns (DaoSpecialStorage _contract)
5678     {
5679         _contract = DaoSpecialStorage(get_contract(CONTRACT_STORAGE_DAO_SPECIAL));
5680     }
5681 
5682     function daoPointsStorage()
5683         internal
5684         view
5685         returns (DaoPointsStorage _contract)
5686     {
5687         _contract = DaoPointsStorage(get_contract(CONTRACT_STORAGE_DAO_POINTS));
5688     }
5689 
5690     function daoRewardsStorage()
5691         internal
5692         view
5693         returns (DaoRewardsStorage _contract)
5694     {
5695         _contract = DaoRewardsStorage(get_contract(CONTRACT_STORAGE_DAO_REWARDS));
5696     }
5697 
5698     function intermediateResultsStorage()
5699         internal
5700         view
5701         returns (IntermediateResultsStorage _contract)
5702     {
5703         _contract = IntermediateResultsStorage(get_contract(CONTRACT_STORAGE_INTERMEDIATE_RESULTS));
5704     }
5705 
5706     function getUintConfig(bytes32 _configKey)
5707         public
5708         view
5709         returns (uint256 _configValue)
5710     {
5711         _configValue = daoConfigsStorage().uintConfigs(_configKey);
5712     }
5713 }
5714 
5715 // File: contracts/common/DaoCommon.sol
5716 contract DaoCommon is DaoCommonMini {
5717 
5718     using MathHelper for MathHelper;
5719 
5720     /**
5721     @notice Check if the transaction is called by the proposer of a proposal
5722     @return _isFromProposer true if the caller is the proposer
5723     */
5724     function isFromProposer(bytes32 _proposalId)
5725         internal
5726         view
5727         returns (bool _isFromProposer)
5728     {
5729         _isFromProposer = msg.sender == daoStorage().readProposalProposer(_proposalId);
5730     }
5731 
5732     /**
5733     @notice Check if the proposal can still be "editted", or in other words, added more versions
5734     @dev Once the proposal is finalized, it can no longer be editted. The proposer will still be able to add docs and change fundings though.
5735     @return _isEditable true if the proposal is editable
5736     */
5737     function isEditable(bytes32 _proposalId)
5738         internal
5739         view
5740         returns (bool _isEditable)
5741     {
5742         bytes32 _finalVersion;
5743         (,,,,,,,_finalVersion,,) = daoStorage().readProposal(_proposalId);
5744         _isEditable = _finalVersion == EMPTY_BYTES;
5745     }
5746 
5747     /**
5748     @notice returns the balance of DaoFundingManager, which is the wei in DigixDAO
5749     */
5750     function weiInDao()
5751         internal
5752         view
5753         returns (uint256 _wei)
5754     {
5755         _wei = get_contract(CONTRACT_DAO_FUNDING_MANAGER).balance;
5756     }
5757 
5758     /**
5759     @notice Check if it is after the draft voting phase of the proposal
5760     */
5761     modifier ifAfterDraftVotingPhase(bytes32 _proposalId) {
5762         uint256 _start = daoStorage().readProposalDraftVotingTime(_proposalId);
5763         require(_start > 0); // Draft voting must have started. In other words, proposer must have finalized the proposal
5764         require(now >= _start.add(getUintConfig(CONFIG_DRAFT_VOTING_PHASE)));
5765         _;
5766     }
5767 
5768     modifier ifCommitPhase(bytes32 _proposalId, uint8 _index) {
5769         requireInPhase(
5770             daoStorage().readProposalVotingTime(_proposalId, _index),
5771             0,
5772             getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE)
5773         );
5774         _;
5775     }
5776 
5777     modifier ifRevealPhase(bytes32 _proposalId, uint256 _index) {
5778       requireInPhase(
5779           daoStorage().readProposalVotingTime(_proposalId, _index),
5780           getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE),
5781           getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)
5782       );
5783       _;
5784     }
5785 
5786     modifier ifAfterProposalRevealPhase(bytes32 _proposalId, uint256 _index) {
5787       uint256 _start = daoStorage().readProposalVotingTime(_proposalId, _index);
5788       require(_start > 0);
5789       require(now >= _start.add(getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)));
5790       _;
5791     }
5792 
5793     modifier ifDraftVotingPhase(bytes32 _proposalId) {
5794         requireInPhase(
5795             daoStorage().readProposalDraftVotingTime(_proposalId),
5796             0,
5797             getUintConfig(CONFIG_DRAFT_VOTING_PHASE)
5798         );
5799         _;
5800     }
5801 
5802     modifier isProposalState(bytes32 _proposalId, bytes32 _STATE) {
5803         bytes32 _currentState;
5804         (,,,_currentState,,,,,,) = daoStorage().readProposal(_proposalId);
5805         require(_currentState == _STATE);
5806         _;
5807     }
5808 
5809     modifier ifDraftNotClaimed(bytes32 _proposalId) {
5810         require(daoStorage().isDraftClaimed(_proposalId) == false);
5811         _;
5812     }
5813 
5814     modifier ifNotClaimed(bytes32 _proposalId, uint256 _index) {
5815         require(daoStorage().isClaimed(_proposalId, _index) == false);
5816         _;
5817     }
5818 
5819     modifier ifNotClaimedSpecial(bytes32 _proposalId) {
5820         require(daoSpecialStorage().isClaimed(_proposalId) == false);
5821         _;
5822     }
5823 
5824     modifier hasNotRevealed(bytes32 _proposalId, uint256 _index) {
5825         uint256 _voteWeight;
5826         (, _voteWeight) = daoStorage().readVote(_proposalId, _index, msg.sender);
5827         require(_voteWeight == uint(0));
5828         _;
5829     }
5830 
5831     modifier hasNotRevealedSpecial(bytes32 _proposalId) {
5832         uint256 _weight;
5833         (,_weight) = daoSpecialStorage().readVote(_proposalId, msg.sender);
5834         require(_weight == uint256(0));
5835         _;
5836     }
5837 
5838     modifier ifAfterRevealPhaseSpecial(bytes32 _proposalId) {
5839       uint256 _start = daoSpecialStorage().readVotingTime(_proposalId);
5840       require(_start > 0);
5841       require(now.sub(_start) >= getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL));
5842       _;
5843     }
5844 
5845     modifier ifCommitPhaseSpecial(bytes32 _proposalId) {
5846         requireInPhase(
5847             daoSpecialStorage().readVotingTime(_proposalId),
5848             0,
5849             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE)
5850         );
5851         _;
5852     }
5853 
5854     modifier ifRevealPhaseSpecial(bytes32 _proposalId) {
5855         requireInPhase(
5856             daoSpecialStorage().readVotingTime(_proposalId),
5857             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE),
5858             getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL)
5859         );
5860         _;
5861     }
5862 
5863     function daoWhitelistingStorage()
5864         internal
5865         view
5866         returns (DaoWhitelistingStorage _contract)
5867     {
5868         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
5869     }
5870 
5871     function getAddressConfig(bytes32 _configKey)
5872         public
5873         view
5874         returns (address _configValue)
5875     {
5876         _configValue = daoConfigsStorage().addressConfigs(_configKey);
5877     }
5878 
5879     function getBytesConfig(bytes32 _configKey)
5880         public
5881         view
5882         returns (bytes32 _configValue)
5883     {
5884         _configValue = daoConfigsStorage().bytesConfigs(_configKey);
5885     }
5886 
5887     /**
5888     @notice Check if a user is a participant in the current quarter
5889     */
5890     function isParticipant(address _user)
5891         public
5892         view
5893         returns (bool _is)
5894     {
5895         _is =
5896             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
5897             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_LOCKED_DGD));
5898     }
5899 
5900     /**
5901     @notice Check if a user is a moderator in the current quarter
5902     */
5903     function isModerator(address _user)
5904         public
5905         view
5906         returns (bool _is)
5907     {
5908         _is =
5909             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
5910             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_DGD_FOR_MODERATOR))
5911             && (daoPointsStorage().getReputation(_user) >= getUintConfig(CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR));
5912     }
5913 
5914     /**
5915     @notice Calculate the start of a specific milestone of a specific proposal.
5916     @dev This is calculated from the voting start of the voting round preceding the milestone
5917          This would throw if the voting start is 0 (the voting round has not started yet)
5918          Note that if the milestoneIndex is exactly the same as the number of milestones,
5919          This will just return the end of the last voting round.
5920     */
5921     function startOfMilestone(bytes32 _proposalId, uint256 _milestoneIndex)
5922         internal
5923         view
5924         returns (uint256 _milestoneStart)
5925     {
5926         uint256 _startOfPrecedingVotingRound = daoStorage().readProposalVotingTime(_proposalId, _milestoneIndex);
5927         require(_startOfPrecedingVotingRound > 0);
5928         // the preceding voting round must have started
5929 
5930         if (_milestoneIndex == 0) { // This is the 1st milestone, which starts after voting round 0
5931             _milestoneStart =
5932                 _startOfPrecedingVotingRound
5933                 .add(getUintConfig(CONFIG_VOTING_PHASE_TOTAL));
5934         } else { // if its the n-th milestone, it starts after voting round n-th
5935             _milestoneStart =
5936                 _startOfPrecedingVotingRound
5937                 .add(getUintConfig(CONFIG_INTERIM_PHASE_TOTAL));
5938         }
5939     }
5940 
5941     /**
5942     @notice Calculate the actual voting start for a voting round, given the tentative start
5943     @dev The tentative start is the ideal start. For example, when a proposer finish a milestone, it should be now
5944          However, sometimes the tentative start is too close to the end of the quarter, hence, the actual voting start should be pushed to the next quarter
5945     */
5946     function getTimelineForNextVote(
5947         uint256 _index,
5948         uint256 _tentativeVotingStart
5949     )
5950         internal
5951         view
5952         returns (uint256 _actualVotingStart)
5953     {
5954         uint256 _timeLeftInQuarter = getTimeLeftInQuarter(_tentativeVotingStart);
5955         uint256 _votingDuration = getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL);
5956         _actualVotingStart = _tentativeVotingStart;
5957         if (timeInQuarter(_tentativeVotingStart) < getUintConfig(CONFIG_LOCKING_PHASE_DURATION)) { // if the tentative start is during a locking phase
5958             _actualVotingStart = _tentativeVotingStart.add(
5959                 getUintConfig(CONFIG_LOCKING_PHASE_DURATION).sub(timeInQuarter(_tentativeVotingStart))
5960             );
5961         } else if (_timeLeftInQuarter < _votingDuration.add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE))) { // if the time left in quarter is not enough to vote and claim voting
5962             _actualVotingStart = _tentativeVotingStart.add(
5963                 _timeLeftInQuarter.add(getUintConfig(CONFIG_LOCKING_PHASE_DURATION)).add(1)
5964             );
5965         }
5966     }
5967 
5968     /**
5969     @notice Check if we can add another non-Digix proposal in this quarter
5970     @dev There is a max cap to the number of non-Digix proposals CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER
5971     */
5972     function checkNonDigixProposalLimit(bytes32 _proposalId)
5973         internal
5974         view
5975     {
5976         require(isNonDigixProposalsWithinLimit(_proposalId));
5977     }
5978 
5979     function isNonDigixProposalsWithinLimit(bytes32 _proposalId)
5980         internal
5981         view
5982         returns (bool _withinLimit)
5983     {
5984         bool _isDigixProposal;
5985         (,,,,,,,,,_isDigixProposal) = daoStorage().readProposal(_proposalId);
5986         _withinLimit = true;
5987         if (!_isDigixProposal) {
5988             _withinLimit = daoProposalCounterStorage().proposalCountByQuarter(currentQuarterNumber()) < getUintConfig(CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER);
5989         }
5990     }
5991 
5992     /**
5993     @notice If its a non-Digix proposal, check if the fundings are within limit
5994     @dev There is a max cap to the fundings and number of milestones for non-Digix proposals
5995     */
5996     function checkNonDigixFundings(uint256[] _milestonesFundings, uint256 _finalReward)
5997         internal
5998         view
5999     {
6000         if (!is_founder()) {
6001             require(_milestonesFundings.length <= getUintConfig(CONFIG_MAX_MILESTONES_FOR_NON_DIGIX));
6002             require(MathHelper.sumNumbers(_milestonesFundings).add(_finalReward) <= getUintConfig(CONFIG_MAX_FUNDING_FOR_NON_DIGIX));
6003         }
6004     }
6005 
6006     /**
6007     @notice Check if msg.sender can do operations as a proposer
6008     @dev Note that this function does not check if he is the proposer of the proposal
6009     */
6010     function senderCanDoProposerOperations()
6011         internal
6012         view
6013     {
6014         require(isMainPhase());
6015         require(isParticipant(msg.sender));
6016         require(identity_storage().is_kyc_approved(msg.sender));
6017     }
6018 }
6019 
6020 // File: contracts/interactive/DaoSpecialProposal.sol
6021 contract DaoSpecialProposal is DaoCommon {
6022 
6023     event StartSpecialProposal(bytes32 indexed _specialProposalId);
6024 
6025     constructor(address _resolver) public {
6026         require(init(CONTRACT_DAO_SPECIAL_PROPOSAL, _resolver));
6027     }
6028 
6029     /**
6030     @notice Function to create a Special Proposal (can only be created by the founders)
6031     @param _doc hash of the IPFS doc of the special proposal details
6032     @param _uintConfigs Array of the new UINT256 configs
6033     @param _addressConfigs Array of the new Address configs
6034     @param _bytesConfigs Array of the new Bytes32 configs
6035     @return {
6036       "_success": "true if created special successfully"
6037     }
6038     */
6039     function createSpecialProposal(
6040         bytes32 _doc,
6041         uint256[] _uintConfigs,
6042         address[] _addressConfigs,
6043         bytes32[] _bytesConfigs
6044     )
6045         external
6046         if_founder()
6047         returns (bool _success)
6048     {
6049         require(isMainPhase());
6050         address _proposer = msg.sender;
6051         daoSpecialStorage().addSpecialProposal(
6052             _doc,
6053             _proposer,
6054             _uintConfigs,
6055             _addressConfigs,
6056             _bytesConfigs
6057         );
6058         _success = true;
6059     }
6060 
6061     /**
6062     @notice Function to set start of voting round for special proposal
6063     @param _proposalId ID of the special proposal
6064     */
6065     function startSpecialProposalVoting(
6066         bytes32 _proposalId
6067     )
6068         public
6069     {
6070         require(isMainPhase());
6071         require(daoSpecialStorage().readProposalProposer(_proposalId) == msg.sender);
6072         require(daoSpecialStorage().readVotingTime(_proposalId) == 0); // voting hasnt started yet
6073         require(getTimeLeftInQuarter(now) > getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL).add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE)));
6074         daoSpecialStorage().setVotingTime(_proposalId, now);
6075 
6076         emit StartSpecialProposal(_proposalId);
6077     }
6078 }