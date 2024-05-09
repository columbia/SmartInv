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
1924 
1925 /// @title Contract Name Registry
1926 /// @author DigixGlobal
1927 contract ContractResolver is ACOwned, Constants {
1928 
1929   mapping (bytes32 => address) contracts;
1930   bool public locked_forever;
1931 
1932   modifier unless_registered(bytes32 _key) {
1933     require(contracts[_key] == NULL_ADDRESS);
1934     _;
1935   }
1936 
1937   modifier if_owner_origin() {
1938     require(tx.origin == owner);
1939     _;
1940   }
1941 
1942   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
1943   /// @param _contract The resolver key
1944   modifier if_sender_is(bytes32 _contract) {
1945     require(msg.sender == get_contract(_contract));
1946     _;
1947   }
1948 
1949   modifier if_not_locked() {
1950     require(locked_forever == false);
1951     _;
1952   }
1953 
1954   /// @dev ContractResolver constructor will perform the following: 1. Set msg.sender as the contract owner.
1955   constructor() public
1956   {
1957     require(init_ac_owned());
1958     locked_forever = false;
1959   }
1960 
1961   /// @dev Called at contract initialization
1962   /// @param _key bytestring for CACP name
1963   /// @param _contract_address The address of the contract to be registered
1964   /// @return _success if the operation is successful
1965   function init_register_contract(bytes32 _key, address _contract_address)
1966            if_owner_origin()
1967            if_not_locked()
1968            unless_registered(_key)
1969            public
1970            returns (bool _success)
1971   {
1972     require(_contract_address != NULL_ADDRESS);
1973     contracts[_key] = _contract_address;
1974     _success = true;
1975   }
1976 
1977   /// @dev Lock the resolver from any further modifications.  This can only be called from the owner
1978   /// @return _success if the operation is successful
1979   function lock_resolver_forever()
1980            if_owner
1981            public
1982            returns (bool _success)
1983   {
1984     locked_forever = true;
1985     _success = true;
1986   }
1987 
1988   /// @dev Get address of a contract
1989   /// @param _key the bytestring name of the contract to look up
1990   /// @return _contract the address of the contract
1991   function get_contract(bytes32 _key)
1992            public
1993            view
1994            returns (address _contract)
1995   {
1996     require(contracts[_key] != NULL_ADDRESS);
1997     _contract = contracts[_key];
1998   }
1999 }
2000 
2001 // File: @digix/cacp-contracts-dao/contracts/ResolverClient.sol
2002 /// @title Contract Resolver Interface
2003 /// @author DigixGlobal
2004 contract ResolverClient {
2005 
2006   /// The address of the resolver contract for this project
2007   address public resolver;
2008   bytes32 public key;
2009 
2010   /// Make our own address available to us as a constant
2011   address public CONTRACT_ADDRESS;
2012 
2013   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
2014   /// @param _contract The resolver key
2015   modifier if_sender_is(bytes32 _contract) {
2016     require(sender_is(_contract));
2017     _;
2018   }
2019 
2020   function sender_is(bytes32 _contract) internal view returns (bool _isFrom) {
2021     _isFrom = msg.sender == ContractResolver(resolver).get_contract(_contract);
2022   }
2023 
2024   modifier if_sender_is_from(bytes32[3] _contracts) {
2025     require(sender_is_from(_contracts));
2026     _;
2027   }
2028 
2029   function sender_is_from(bytes32[3] _contracts) internal view returns (bool _isFrom) {
2030     uint256 _n = _contracts.length;
2031     for (uint256 i = 0; i < _n; i++) {
2032       if (_contracts[i] == bytes32(0x0)) continue;
2033       if (msg.sender == ContractResolver(resolver).get_contract(_contracts[i])) {
2034         _isFrom = true;
2035         break;
2036       }
2037     }
2038   }
2039 
2040   /// Function modifier to check resolver's locking status.
2041   modifier unless_resolver_is_locked() {
2042     require(is_locked() == false);
2043     _;
2044   }
2045 
2046   /// @dev Initialize new contract
2047   /// @param _key the resolver key for this contract
2048   /// @return _success if the initialization is successful
2049   function init(bytes32 _key, address _resolver)
2050            internal
2051            returns (bool _success)
2052   {
2053     bool _is_locked = ContractResolver(_resolver).locked_forever();
2054     if (_is_locked == false) {
2055       CONTRACT_ADDRESS = address(this);
2056       resolver = _resolver;
2057       key = _key;
2058       require(ContractResolver(resolver).init_register_contract(key, CONTRACT_ADDRESS));
2059       _success = true;
2060     }  else {
2061       _success = false;
2062     }
2063   }
2064 
2065   /// @dev Check if resolver is locked
2066   /// @return _locked if the resolver is currently locked
2067   function is_locked()
2068            private
2069            view
2070            returns (bool _locked)
2071   {
2072     _locked = ContractResolver(resolver).locked_forever();
2073   }
2074 
2075   /// @dev Get the address of a contract
2076   /// @param _key the resolver key to look up
2077   /// @return _contract the address of the contract
2078   function get_contract(bytes32 _key)
2079            public
2080            view
2081            returns (address _contract)
2082   {
2083     _contract = ContractResolver(resolver).get_contract(_key);
2084   }
2085 }
2086 
2087 // File: contracts/storage/DaoWhitelistingStorage.sol
2088 // This contract is basically created to restrict read access to
2089 // ethereum accounts, and whitelisted contracts
2090 contract DaoWhitelistingStorage is ResolverClient, DaoConstants {
2091 
2092     // we want to avoid the scenario in which an on-chain bribing contract
2093     // can be deployed to distribute funds in a trustless way by verifying
2094     // on-chain votes. This mapping marks whether a contract address is whitelisted
2095     // to read from the read functions in DaoStorage, DaoSpecialStorage, etc.
2096     mapping (address => bool) public whitelist;
2097 
2098     constructor(address _resolver)
2099         public
2100     {
2101         require(init(CONTRACT_STORAGE_DAO_WHITELISTING, _resolver));
2102     }
2103 
2104     function setWhitelisted(address _contractAddress, bool _senderIsAllowedToRead)
2105         public
2106     {
2107         require(sender_is(CONTRACT_DAO_WHITELISTING));
2108         whitelist[_contractAddress] = _senderIsAllowedToRead;
2109     }
2110 }
2111 
2112 // File: contracts/common/DaoWhitelistingCommon.sol
2113 contract DaoWhitelistingCommon is ResolverClient, DaoConstants {
2114 
2115     function daoWhitelistingStorage()
2116         internal
2117         view
2118         returns (DaoWhitelistingStorage _contract)
2119     {
2120         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
2121     }
2122 
2123     /**
2124     @notice Check if a certain address is whitelisted to read sensitive information in the storage layer
2125     @dev if the address is an account, it is allowed to read. If the address is a contract, it has to be in the whitelist
2126     */
2127     function senderIsAllowedToRead()
2128         internal
2129         view
2130         returns (bool _senderIsAllowedToRead)
2131     {
2132         // msg.sender is allowed to read only if its an EOA or a whitelisted contract
2133         _senderIsAllowedToRead = (msg.sender == tx.origin) || daoWhitelistingStorage().whitelist(msg.sender);
2134     }
2135 }
2136 
2137 // File: contracts/lib/DaoStructs.sol
2138 library DaoStructs {
2139     using DoublyLinkedList for DoublyLinkedList.Bytes;
2140     using SafeMath for uint256;
2141     bytes32 constant EMPTY_BYTES = bytes32(0x0);
2142 
2143     struct PrlAction {
2144         // UTC timestamp at which the PRL action was done
2145         uint256 at;
2146 
2147         // IPFS hash of the document summarizing the action
2148         bytes32 doc;
2149 
2150         // Type of action
2151         // check PRL_ACTION_* in "./../common/DaoConstants.sol"
2152         uint256 actionId;
2153     }
2154 
2155     struct Voting {
2156         // UTC timestamp at which the voting round starts
2157         uint256 startTime;
2158 
2159         // Mapping of whether a commit was used in this voting round
2160         mapping (bytes32 => bool) usedCommits;
2161 
2162         // Mapping of commits by address. These are the commits during the commit phase in a voting round
2163         // This only stores the most recent commit in the voting round
2164         // In case a vote is edited, the previous commit is overwritten by the new commit
2165         // Only this new commit is verified at the reveal phase
2166         mapping (address => bytes32) commits;
2167 
2168         // This mapping is updated after the reveal phase, when votes are revealed
2169         // It is a mapping of address to weight of vote
2170         // Weight implies the lockedDGDStake of the address, at the time of revealing
2171         // If the address voted "NO", or didn't vote, this would be 0
2172         mapping (address => uint256) yesVotes;
2173 
2174         // This mapping is updated after the reveal phase, when votes are revealed
2175         // It is a mapping of address to weight of vote
2176         // Weight implies the lockedDGDStake of the address, at the time of revealing
2177         // If the address voted "YES", or didn't vote, this would be 0
2178         mapping (address => uint256) noVotes;
2179 
2180         // Boolean whether the voting round passed or not
2181         bool passed;
2182 
2183         // Boolean whether the voting round results were claimed or not
2184         // refer the claimProposalVotingResult function in "./../interative/DaoVotingClaims.sol"
2185         bool claimed;
2186 
2187         // Boolean whether the milestone following this voting round was funded or not
2188         // The milestone is funded when the proposer calls claimFunding in "./../interactive/DaoFundingManager.sol"
2189         bool funded;
2190     }
2191 
2192     struct ProposalVersion {
2193         // IPFS doc hash of this version of the proposal
2194         bytes32 docIpfsHash;
2195 
2196         // UTC timestamp at which this version was created
2197         uint256 created;
2198 
2199         // The number of milestones in the proposal as per this version
2200         uint256 milestoneCount;
2201 
2202         // The final reward asked by the proposer for completion of the entire proposal
2203         uint256 finalReward;
2204 
2205         // List of fundings required by the proposal as per this version
2206         // The numbers are in wei
2207         uint256[] milestoneFundings;
2208 
2209         // When a proposal is finalized (calling Dao.finalizeProposal), the proposer can no longer add proposal versions
2210         // However, they can still add more details to this final proposal version, in the form of IPFS docs.
2211         // These IPFS docs are stored in this array
2212         bytes32[] moreDocs;
2213     }
2214 
2215     struct Proposal {
2216         // ID of the proposal. Also the IPFS hash of the first ProposalVersion
2217         bytes32 proposalId;
2218 
2219         // current state of the proposal
2220         // refer PROPOSAL_STATE_* in "./../common/DaoConstants.sol"
2221         bytes32 currentState;
2222 
2223         // UTC timestamp at which the proposal was created
2224         uint256 timeCreated;
2225 
2226         // DoublyLinkedList of IPFS doc hashes of the various versions of the proposal
2227         DoublyLinkedList.Bytes proposalVersionDocs;
2228 
2229         // Mapping of version (IPFS doc hash) to ProposalVersion struct
2230         mapping (bytes32 => ProposalVersion) proposalVersions;
2231 
2232         // Voting struct for the draft voting round
2233         Voting draftVoting;
2234 
2235         // Mapping of voting round index (starts from 0) to Voting struct
2236         // votingRounds[0] is the Voting round of the proposal, which lasts for get_uint_config(CONFIG_VOTING_PHASE_TOTAL)
2237         // votingRounds[i] for i>0 are the Interim Voting rounds of the proposal, which lasts for get_uint_config(CONFIG_INTERIM_PHASE_TOTAL)
2238         mapping (uint256 => Voting) votingRounds;
2239 
2240         // Every proposal has a collateral tied to it with a value of
2241         // get_uint_config(CONFIG_PREPROPOSAL_COLLATERAL) (refer "./../storage/DaoConfigsStorage.sol")
2242         // Collateral can be in different states
2243         // refer COLLATERAL_STATUS_* in "./../common/DaoConstants.sol"
2244         uint256 collateralStatus;
2245         uint256 collateralAmount;
2246 
2247         // The final version of the proposal
2248         // Every proposal needs to be finalized before it can be voted on
2249         // This is the IPFS doc hash of the final version
2250         bytes32 finalVersion;
2251 
2252         // List of PrlAction structs
2253         // These are all the actions done by the PRL on the proposal
2254         PrlAction[] prlActions;
2255 
2256         // Address of the user who created the proposal
2257         address proposer;
2258 
2259         // Address of the moderator who endorsed the proposal
2260         address endorser;
2261 
2262         // Boolean whether the proposal is paused/stopped at the moment
2263         bool isPausedOrStopped;
2264 
2265         // Boolean whether the proposal was created by a founder role
2266         bool isDigix;
2267     }
2268 
2269     function countVotes(Voting storage _voting, address[] _allUsers)
2270         external
2271         view
2272         returns (uint256 _for, uint256 _against)
2273     {
2274         uint256 _n = _allUsers.length;
2275         for (uint256 i = 0; i < _n; i++) {
2276             if (_voting.yesVotes[_allUsers[i]] > 0) {
2277                 _for = _for.add(_voting.yesVotes[_allUsers[i]]);
2278             } else if (_voting.noVotes[_allUsers[i]] > 0) {
2279                 _against = _against.add(_voting.noVotes[_allUsers[i]]);
2280             }
2281         }
2282     }
2283 
2284     // get the list of voters who voted _vote (true-yes/false-no)
2285     function listVotes(Voting storage _voting, address[] _allUsers, bool _vote)
2286         external
2287         view
2288         returns (address[] memory _voters, uint256 _length)
2289     {
2290         uint256 _n = _allUsers.length;
2291         uint256 i;
2292         _length = 0;
2293         _voters = new address[](_n);
2294         if (_vote == true) {
2295             for (i = 0; i < _n; i++) {
2296                 if (_voting.yesVotes[_allUsers[i]] > 0) {
2297                     _voters[_length] = _allUsers[i];
2298                     _length++;
2299                 }
2300             }
2301         } else {
2302             for (i = 0; i < _n; i++) {
2303                 if (_voting.noVotes[_allUsers[i]] > 0) {
2304                     _voters[_length] = _allUsers[i];
2305                     _length++;
2306                 }
2307             }
2308         }
2309     }
2310 
2311     function readVote(Voting storage _voting, address _voter)
2312         public
2313         view
2314         returns (bool _vote, uint256 _weight)
2315     {
2316         if (_voting.yesVotes[_voter] > 0) {
2317             _weight = _voting.yesVotes[_voter];
2318             _vote = true;
2319         } else {
2320             _weight = _voting.noVotes[_voter]; // if _voter didnt vote at all, the weight will be 0 anyway
2321             _vote = false;
2322         }
2323     }
2324 
2325     function revealVote(
2326         Voting storage _voting,
2327         address _voter,
2328         bool _vote,
2329         uint256 _weight
2330     )
2331         public
2332     {
2333         if (_vote) {
2334             _voting.yesVotes[_voter] = _weight;
2335         } else {
2336             _voting.noVotes[_voter] = _weight;
2337         }
2338     }
2339 
2340     function readVersion(ProposalVersion storage _version)
2341         public
2342         view
2343         returns (
2344             bytes32 _doc,
2345             uint256 _created,
2346             uint256[] _milestoneFundings,
2347             uint256 _finalReward
2348         )
2349     {
2350         _doc = _version.docIpfsHash;
2351         _created = _version.created;
2352         _milestoneFundings = _version.milestoneFundings;
2353         _finalReward = _version.finalReward;
2354     }
2355 
2356     // read the funding for a particular milestone of a finalized proposal
2357     // if _milestoneId is the same as _milestoneCount, it returns the final reward
2358     function readProposalMilestone(Proposal storage _proposal, uint256 _milestoneIndex)
2359         public
2360         view
2361         returns (uint256 _funding)
2362     {
2363         bytes32 _finalVersion = _proposal.finalVersion;
2364         uint256 _milestoneCount = _proposal.proposalVersions[_finalVersion].milestoneFundings.length;
2365         require(_milestoneIndex <= _milestoneCount);
2366         require(_finalVersion != EMPTY_BYTES); // the proposal must have been finalized
2367 
2368         if (_milestoneIndex < _milestoneCount) {
2369             _funding = _proposal.proposalVersions[_finalVersion].milestoneFundings[_milestoneIndex];
2370         } else {
2371             _funding = _proposal.proposalVersions[_finalVersion].finalReward;
2372         }
2373     }
2374 
2375     function addProposalVersion(
2376         Proposal storage _proposal,
2377         bytes32 _newDoc,
2378         uint256[] _newMilestoneFundings,
2379         uint256 _finalReward
2380     )
2381         public
2382     {
2383         _proposal.proposalVersionDocs.append(_newDoc);
2384         _proposal.proposalVersions[_newDoc].docIpfsHash = _newDoc;
2385         _proposal.proposalVersions[_newDoc].created = now;
2386         _proposal.proposalVersions[_newDoc].milestoneCount = _newMilestoneFundings.length;
2387         _proposal.proposalVersions[_newDoc].milestoneFundings = _newMilestoneFundings;
2388         _proposal.proposalVersions[_newDoc].finalReward = _finalReward;
2389     }
2390 
2391     struct SpecialProposal {
2392         // ID of the special proposal
2393         // This is the IPFS doc hash of the proposal
2394         bytes32 proposalId;
2395 
2396         // UTC timestamp at which the proposal was created
2397         uint256 timeCreated;
2398 
2399         // Voting struct for the special proposal
2400         Voting voting;
2401 
2402         // List of the new uint256 configs as per the special proposal
2403         uint256[] uintConfigs;
2404 
2405         // List of the new address configs as per the special proposal
2406         address[] addressConfigs;
2407 
2408         // List of the new bytes32 configs as per the special proposal
2409         bytes32[] bytesConfigs;
2410 
2411         // Address of the user who created the special proposal
2412         // This address should also be in the ROLES_FOUNDERS group
2413         // refer "./../storage/DaoIdentityStorage.sol"
2414         address proposer;
2415     }
2416 
2417     // All configs are as per the DaoConfigsStorage values at the time when
2418     // calculateGlobalRewardsBeforeNewQuarter is called by founder in that quarter
2419     struct DaoQuarterInfo {
2420         // The minimum quarter points required
2421         // below this, reputation will be deducted
2422         uint256 minimalParticipationPoint;
2423 
2424         // The scaling factor for quarter point
2425         uint256 quarterPointScalingFactor;
2426 
2427         // The scaling factor for reputation point
2428         uint256 reputationPointScalingFactor;
2429 
2430         // The summation of effectiveDGDs in the previous quarter
2431         // The effectiveDGDs represents the effective participation in DigixDAO in a quarter
2432         // Which depends on lockedDGDStake, quarter point and reputation point
2433         // This value is the summation of all participant effectiveDGDs
2434         // It will be used to calculate the fraction of effectiveDGD a user has,
2435         // which will determine his portion of DGX rewards for that quarter
2436         uint256 totalEffectiveDGDPreviousQuarter;
2437 
2438         // The minimum moderator quarter point required
2439         // below this, reputation will be deducted for moderators
2440         uint256 moderatorMinimalParticipationPoint;
2441 
2442         // the scaling factor for moderator quarter point
2443         uint256 moderatorQuarterPointScalingFactor;
2444 
2445         // the scaling factor for moderator reputation point
2446         uint256 moderatorReputationPointScalingFactor;
2447 
2448         // The summation of effectiveDGDs (only specific to moderators)
2449         uint256 totalEffectiveModeratorDGDLastQuarter;
2450 
2451         // UTC timestamp from which the DGX rewards for the previous quarter are distributable to Holders
2452         uint256 dgxDistributionDay;
2453 
2454         // This is the rewards pool for the previous quarter. This is the sum of the DGX fees coming in from the collector, and the demurrage that has incurred
2455         // when user call claimRewards() in the previous quarter.
2456         // more graphical explanation: https://ipfs.io/ipfs/QmZDgFFMbyF3dvuuDfoXv5F6orq4kaDPo7m3QvnseUguzo
2457         uint256 dgxRewardsPoolLastQuarter;
2458 
2459         // The summation of all dgxRewardsPoolLastQuarter up until this quarter
2460         uint256 sumRewardsFromBeginning;
2461     }
2462 
2463     // There are many function calls where all calculations/summations cannot be done in one transaction
2464     // and require multiple transactions.
2465     // This struct stores the intermediate results in between the calculating transactions
2466     // These intermediate results are stored in IntermediateResultsStorage
2467     struct IntermediateResults {
2468         // weight of "FOR" votes counted up until the current calculation step
2469         uint256 currentForCount;
2470 
2471         // weight of "AGAINST" votes counted up until the current calculation step
2472         uint256 currentAgainstCount;
2473 
2474         // summation of effectiveDGDs up until the iteration of calculation
2475         uint256 currentSumOfEffectiveBalance;
2476 
2477         // Address of user until which the calculation has been done
2478         address countedUntil;
2479     }
2480 }
2481 
2482 // File: contracts/storage/DaoStorage.sol
2483 contract DaoStorage is DaoWhitelistingCommon, BytesIteratorStorage {
2484     using DoublyLinkedList for DoublyLinkedList.Bytes;
2485     using DaoStructs for DaoStructs.Voting;
2486     using DaoStructs for DaoStructs.Proposal;
2487     using DaoStructs for DaoStructs.ProposalVersion;
2488 
2489     // List of all the proposals ever created in DigixDAO
2490     DoublyLinkedList.Bytes allProposals;
2491 
2492     // mapping of Proposal struct by its ID
2493     // ID is also the IPFS doc hash of the first ever version of this proposal
2494     mapping (bytes32 => DaoStructs.Proposal) proposalsById;
2495 
2496     // mapping from state of a proposal to list of all proposals in that state
2497     // proposals are added/removed from the state's list as their states change
2498     // eg. when proposal is endorsed, when proposal is funded, etc
2499     mapping (bytes32 => DoublyLinkedList.Bytes) proposalsByState;
2500 
2501     constructor(address _resolver) public {
2502         require(init(CONTRACT_STORAGE_DAO, _resolver));
2503     }
2504 
2505     /////////////////////////////// READ FUNCTIONS //////////////////////////////
2506 
2507     /// @notice read all information and details of proposal
2508     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc Proposal ID, i.e. hash of IPFS doc
2509     /// return {
2510     ///   "_doc": "Original IPFS doc of proposal, also ID of proposal",
2511     ///   "_proposer": "Address of the proposer",
2512     ///   "_endorser": "Address of the moderator that endorsed the proposal",
2513     ///   "_state": "Current state of the proposal",
2514     ///   "_timeCreated": "UTC timestamp at which proposal was created",
2515     ///   "_nVersions": "Number of versions of the proposal",
2516     ///   "_latestVersionDoc": "IPFS doc hash of the latest version of this proposal",
2517     ///   "_finalVersion": "If finalized, the version of the final proposal",
2518     ///   "_pausedOrStopped": "If the proposal is paused/stopped at the moment",
2519     ///   "_isDigixProposal": "If the proposal has been created by founder or not"
2520     /// }
2521     function readProposal(bytes32 _proposalId)
2522         public
2523         view
2524         returns (
2525             bytes32 _doc,
2526             address _proposer,
2527             address _endorser,
2528             bytes32 _state,
2529             uint256 _timeCreated,
2530             uint256 _nVersions,
2531             bytes32 _latestVersionDoc,
2532             bytes32 _finalVersion,
2533             bool _pausedOrStopped,
2534             bool _isDigixProposal
2535         )
2536     {
2537         require(senderIsAllowedToRead());
2538         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2539         _doc = _proposal.proposalId;
2540         _proposer = _proposal.proposer;
2541         _endorser = _proposal.endorser;
2542         _state = _proposal.currentState;
2543         _timeCreated = _proposal.timeCreated;
2544         _nVersions = read_total_bytesarray(_proposal.proposalVersionDocs);
2545         _latestVersionDoc = read_last_from_bytesarray(_proposal.proposalVersionDocs);
2546         _finalVersion = _proposal.finalVersion;
2547         _pausedOrStopped = _proposal.isPausedOrStopped;
2548         _isDigixProposal = _proposal.isDigix;
2549     }
2550 
2551     function readProposalProposer(bytes32 _proposalId)
2552         public
2553         view
2554         returns (address _proposer)
2555     {
2556         _proposer = proposalsById[_proposalId].proposer;
2557     }
2558 
2559     function readTotalPrlActions(bytes32 _proposalId)
2560         public
2561         view
2562         returns (uint256 _length)
2563     {
2564         _length = proposalsById[_proposalId].prlActions.length;
2565     }
2566 
2567     function readPrlAction(bytes32 _proposalId, uint256 _index)
2568         public
2569         view
2570         returns (uint256 _actionId, uint256 _time, bytes32 _doc)
2571     {
2572         DaoStructs.PrlAction[] memory _actions = proposalsById[_proposalId].prlActions;
2573         require(_index < _actions.length);
2574         _actionId = _actions[_index].actionId;
2575         _time = _actions[_index].at;
2576         _doc = _actions[_index].doc;
2577     }
2578 
2579     function readProposalDraftVotingResult(bytes32 _proposalId)
2580         public
2581         view
2582         returns (bool _result)
2583     {
2584         require(senderIsAllowedToRead());
2585         _result = proposalsById[_proposalId].draftVoting.passed;
2586     }
2587 
2588     function readProposalVotingResult(bytes32 _proposalId, uint256 _index)
2589         public
2590         view
2591         returns (bool _result)
2592     {
2593         require(senderIsAllowedToRead());
2594         _result = proposalsById[_proposalId].votingRounds[_index].passed;
2595     }
2596 
2597     function readProposalDraftVotingTime(bytes32 _proposalId)
2598         public
2599         view
2600         returns (uint256 _start)
2601     {
2602         require(senderIsAllowedToRead());
2603         _start = proposalsById[_proposalId].draftVoting.startTime;
2604     }
2605 
2606     function readProposalVotingTime(bytes32 _proposalId, uint256 _index)
2607         public
2608         view
2609         returns (uint256 _start)
2610     {
2611         require(senderIsAllowedToRead());
2612         _start = proposalsById[_proposalId].votingRounds[_index].startTime;
2613     }
2614 
2615     function readDraftVotingCount(bytes32 _proposalId, address[] _allUsers)
2616         external
2617         view
2618         returns (uint256 _for, uint256 _against)
2619     {
2620         require(senderIsAllowedToRead());
2621         return proposalsById[_proposalId].draftVoting.countVotes(_allUsers);
2622     }
2623 
2624     function readVotingCount(bytes32 _proposalId, uint256 _index, address[] _allUsers)
2625         external
2626         view
2627         returns (uint256 _for, uint256 _against)
2628     {
2629         require(senderIsAllowedToRead());
2630         return proposalsById[_proposalId].votingRounds[_index].countVotes(_allUsers);
2631     }
2632 
2633     function readVotingRoundVotes(bytes32 _proposalId, uint256 _index, address[] _allUsers, bool _vote)
2634         external
2635         view
2636         returns (address[] memory _voters, uint256 _length)
2637     {
2638         require(senderIsAllowedToRead());
2639         return proposalsById[_proposalId].votingRounds[_index].listVotes(_allUsers, _vote);
2640     }
2641 
2642     function readDraftVote(bytes32 _proposalId, address _voter)
2643         public
2644         view
2645         returns (bool _vote, uint256 _weight)
2646     {
2647         require(senderIsAllowedToRead());
2648         return proposalsById[_proposalId].draftVoting.readVote(_voter);
2649     }
2650 
2651     /// @notice returns the latest committed vote by a voter on a proposal
2652     /// @param _proposalId proposal ID
2653     /// @param _voter address of the voter
2654     /// @return {
2655     ///   "_commitHash": ""
2656     /// }
2657     function readComittedVote(bytes32 _proposalId, uint256 _index, address _voter)
2658         public
2659         view
2660         returns (bytes32 _commitHash)
2661     {
2662         require(senderIsAllowedToRead());
2663         _commitHash = proposalsById[_proposalId].votingRounds[_index].commits[_voter];
2664     }
2665 
2666     function readVote(bytes32 _proposalId, uint256 _index, address _voter)
2667         public
2668         view
2669         returns (bool _vote, uint256 _weight)
2670     {
2671         require(senderIsAllowedToRead());
2672         return proposalsById[_proposalId].votingRounds[_index].readVote(_voter);
2673     }
2674 
2675     /// @notice get all information and details of the first proposal
2676     /// return {
2677     ///   "_id": ""
2678     /// }
2679     function getFirstProposal()
2680         public
2681         view
2682         returns (bytes32 _id)
2683     {
2684         _id = read_first_from_bytesarray(allProposals);
2685     }
2686 
2687     /// @notice get all information and details of the last proposal
2688     /// return {
2689     ///   "_id": ""
2690     /// }
2691     function getLastProposal()
2692         public
2693         view
2694         returns (bytes32 _id)
2695     {
2696         _id = read_last_from_bytesarray(allProposals);
2697     }
2698 
2699     /// @notice get all information and details of proposal next to _proposalId
2700     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2701     /// return {
2702     ///   "_id": ""
2703     /// }
2704     function getNextProposal(bytes32 _proposalId)
2705         public
2706         view
2707         returns (bytes32 _id)
2708     {
2709         _id = read_next_from_bytesarray(
2710             allProposals,
2711             _proposalId
2712         );
2713     }
2714 
2715     /// @notice get all information and details of proposal previous to _proposalId
2716     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2717     /// return {
2718     ///   "_id": ""
2719     /// }
2720     function getPreviousProposal(bytes32 _proposalId)
2721         public
2722         view
2723         returns (bytes32 _id)
2724     {
2725         _id = read_previous_from_bytesarray(
2726             allProposals,
2727             _proposalId
2728         );
2729     }
2730 
2731     /// @notice get all information and details of the first proposal in state _stateId
2732     /// @param _stateId State ID of the proposal
2733     /// return {
2734     ///   "_id": ""
2735     /// }
2736     function getFirstProposalInState(bytes32 _stateId)
2737         public
2738         view
2739         returns (bytes32 _id)
2740     {
2741         require(senderIsAllowedToRead());
2742         _id = read_first_from_bytesarray(proposalsByState[_stateId]);
2743     }
2744 
2745     /// @notice get all information and details of the last proposal in state _stateId
2746     /// @param _stateId State ID of the proposal
2747     /// return {
2748     ///   "_id": ""
2749     /// }
2750     function getLastProposalInState(bytes32 _stateId)
2751         public
2752         view
2753         returns (bytes32 _id)
2754     {
2755         require(senderIsAllowedToRead());
2756         _id = read_last_from_bytesarray(proposalsByState[_stateId]);
2757     }
2758 
2759     /// @notice get all information and details of the next proposal to _proposalId in state _stateId
2760     /// @param _stateId State ID of the proposal
2761     /// return {
2762     ///   "_id": ""
2763     /// }
2764     function getNextProposalInState(bytes32 _stateId, bytes32 _proposalId)
2765         public
2766         view
2767         returns (bytes32 _id)
2768     {
2769         require(senderIsAllowedToRead());
2770         _id = read_next_from_bytesarray(
2771             proposalsByState[_stateId],
2772             _proposalId
2773         );
2774     }
2775 
2776     /// @notice get all information and details of the previous proposal to _proposalId in state _stateId
2777     /// @param _stateId State ID of the proposal
2778     /// return {
2779     ///   "_id": ""
2780     /// }
2781     function getPreviousProposalInState(bytes32 _stateId, bytes32 _proposalId)
2782         public
2783         view
2784         returns (bytes32 _id)
2785     {
2786         require(senderIsAllowedToRead());
2787         _id = read_previous_from_bytesarray(
2788             proposalsByState[_stateId],
2789             _proposalId
2790         );
2791     }
2792 
2793     /// @notice read proposal version details for a specific version
2794     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2795     /// @param _version Version of proposal, i.e. hash of IPFS doc for specific version
2796     /// return {
2797     ///   "_doc": "",
2798     ///   "_created": "",
2799     ///   "_milestoneFundings": ""
2800     /// }
2801     function readProposalVersion(bytes32 _proposalId, bytes32 _version)
2802         public
2803         view
2804         returns (
2805             bytes32 _doc,
2806             uint256 _created,
2807             uint256[] _milestoneFundings,
2808             uint256 _finalReward
2809         )
2810     {
2811         return proposalsById[_proposalId].proposalVersions[_version].readVersion();
2812     }
2813 
2814     /**
2815     @notice Read the fundings of a finalized proposal
2816     @return {
2817         "_fundings": "fundings for the milestones",
2818         "_finalReward": "the final reward"
2819     }
2820     */
2821     function readProposalFunding(bytes32 _proposalId)
2822         public
2823         view
2824         returns (uint256[] memory _fundings, uint256 _finalReward)
2825     {
2826         require(senderIsAllowedToRead());
2827         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
2828         require(_finalVersion != EMPTY_BYTES);
2829         _fundings = proposalsById[_proposalId].proposalVersions[_finalVersion].milestoneFundings;
2830         _finalReward = proposalsById[_proposalId].proposalVersions[_finalVersion].finalReward;
2831     }
2832 
2833     function readProposalMilestone(bytes32 _proposalId, uint256 _index)
2834         public
2835         view
2836         returns (uint256 _funding)
2837     {
2838         require(senderIsAllowedToRead());
2839         _funding = proposalsById[_proposalId].readProposalMilestone(_index);
2840     }
2841 
2842     /// @notice get proposal version details for the first version
2843     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2844     /// return {
2845     ///   "_version": ""
2846     /// }
2847     function getFirstProposalVersion(bytes32 _proposalId)
2848         public
2849         view
2850         returns (bytes32 _version)
2851     {
2852         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2853         _version = read_first_from_bytesarray(_proposal.proposalVersionDocs);
2854     }
2855 
2856     /// @notice get proposal version details for the last version
2857     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2858     /// return {
2859     ///   "_version": ""
2860     /// }
2861     function getLastProposalVersion(bytes32 _proposalId)
2862         public
2863         view
2864         returns (bytes32 _version)
2865     {
2866         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2867         _version = read_last_from_bytesarray(_proposal.proposalVersionDocs);
2868     }
2869 
2870     /// @notice get proposal version details for the next version to _version
2871     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2872     /// @param _version Version of proposal
2873     /// return {
2874     ///   "_nextVersion": ""
2875     /// }
2876     function getNextProposalVersion(bytes32 _proposalId, bytes32 _version)
2877         public
2878         view
2879         returns (bytes32 _nextVersion)
2880     {
2881         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2882         _nextVersion = read_next_from_bytesarray(
2883             _proposal.proposalVersionDocs,
2884             _version
2885         );
2886     }
2887 
2888     /// @notice get proposal version details for the previous version to _version
2889     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2890     /// @param _version Version of proposal
2891     /// return {
2892     ///   "_previousVersion": ""
2893     /// }
2894     function getPreviousProposalVersion(bytes32 _proposalId, bytes32 _version)
2895         public
2896         view
2897         returns (bytes32 _previousVersion)
2898     {
2899         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2900         _previousVersion = read_previous_from_bytesarray(
2901             _proposal.proposalVersionDocs,
2902             _version
2903         );
2904     }
2905 
2906     function isDraftClaimed(bytes32 _proposalId)
2907         public
2908         view
2909         returns (bool _claimed)
2910     {
2911         _claimed = proposalsById[_proposalId].draftVoting.claimed;
2912     }
2913 
2914     function isClaimed(bytes32 _proposalId, uint256 _index)
2915         public
2916         view
2917         returns (bool _claimed)
2918     {
2919         _claimed = proposalsById[_proposalId].votingRounds[_index].claimed;
2920     }
2921 
2922     function readProposalCollateralStatus(bytes32 _proposalId)
2923         public
2924         view
2925         returns (uint256 _status)
2926     {
2927         require(senderIsAllowedToRead());
2928         _status = proposalsById[_proposalId].collateralStatus;
2929     }
2930 
2931     function readProposalCollateralAmount(bytes32 _proposalId)
2932         public
2933         view
2934         returns (uint256 _amount)
2935     {
2936         _amount = proposalsById[_proposalId].collateralAmount;
2937     }
2938 
2939     /// @notice Read the additional docs that are added after the proposal is finalized
2940     /// @dev Will throw if the propsal is not finalized yet
2941     function readProposalDocs(bytes32 _proposalId)
2942         public
2943         view
2944         returns (bytes32[] _moreDocs)
2945     {
2946         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
2947         require(_finalVersion != EMPTY_BYTES);
2948         _moreDocs = proposalsById[_proposalId].proposalVersions[_finalVersion].moreDocs;
2949     }
2950 
2951     function readIfMilestoneFunded(bytes32 _proposalId, uint256 _milestoneId)
2952         public
2953         view
2954         returns (bool _funded)
2955     {
2956         require(senderIsAllowedToRead());
2957         _funded = proposalsById[_proposalId].votingRounds[_milestoneId].funded;
2958     }
2959 
2960     ////////////////////////////// WRITE FUNCTIONS //////////////////////////////
2961 
2962     function addProposal(
2963         bytes32 _doc,
2964         address _proposer,
2965         uint256[] _milestoneFundings,
2966         uint256 _finalReward,
2967         bool _isFounder
2968     )
2969         external
2970     {
2971         require(sender_is(CONTRACT_DAO));
2972         require(
2973           (proposalsById[_doc].proposalId == EMPTY_BYTES) &&
2974           (_doc != EMPTY_BYTES)
2975         );
2976 
2977         allProposals.append(_doc);
2978         proposalsByState[PROPOSAL_STATE_PREPROPOSAL].append(_doc);
2979         proposalsById[_doc].proposalId = _doc;
2980         proposalsById[_doc].proposer = _proposer;
2981         proposalsById[_doc].currentState = PROPOSAL_STATE_PREPROPOSAL;
2982         proposalsById[_doc].timeCreated = now;
2983         proposalsById[_doc].isDigix = _isFounder;
2984         proposalsById[_doc].addProposalVersion(_doc, _milestoneFundings, _finalReward);
2985     }
2986 
2987     function editProposal(
2988         bytes32 _proposalId,
2989         bytes32 _newDoc,
2990         uint256[] _newMilestoneFundings,
2991         uint256 _finalReward
2992     )
2993         external
2994     {
2995         require(sender_is(CONTRACT_DAO));
2996 
2997         proposalsById[_proposalId].addProposalVersion(_newDoc, _newMilestoneFundings, _finalReward);
2998     }
2999 
3000     /// @notice change fundings of a proposal
3001     /// @dev Will throw if the proposal is not finalized yet
3002     function changeFundings(bytes32 _proposalId, uint256[] _newMilestoneFundings, uint256 _finalReward)
3003         external
3004     {
3005         require(sender_is(CONTRACT_DAO));
3006 
3007         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
3008         require(_finalVersion != EMPTY_BYTES);
3009         proposalsById[_proposalId].proposalVersions[_finalVersion].milestoneFundings = _newMilestoneFundings;
3010         proposalsById[_proposalId].proposalVersions[_finalVersion].finalReward = _finalReward;
3011     }
3012 
3013     /// @dev Will throw if the proposal is not finalized yet
3014     function addProposalDoc(bytes32 _proposalId, bytes32 _newDoc)
3015         public
3016     {
3017         require(sender_is(CONTRACT_DAO));
3018 
3019         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
3020         require(_finalVersion != EMPTY_BYTES); //already checked in interactive layer, but why not
3021         proposalsById[_proposalId].proposalVersions[_finalVersion].moreDocs.push(_newDoc);
3022     }
3023 
3024     function finalizeProposal(bytes32 _proposalId)
3025         public
3026     {
3027         require(sender_is(CONTRACT_DAO));
3028 
3029         proposalsById[_proposalId].finalVersion = getLastProposalVersion(_proposalId);
3030     }
3031 
3032     function updateProposalEndorse(
3033         bytes32 _proposalId,
3034         address _endorser
3035     )
3036         public
3037     {
3038         require(sender_is(CONTRACT_DAO));
3039 
3040         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
3041         _proposal.endorser = _endorser;
3042         _proposal.currentState = PROPOSAL_STATE_DRAFT;
3043         proposalsByState[PROPOSAL_STATE_PREPROPOSAL].remove_item(_proposalId);
3044         proposalsByState[PROPOSAL_STATE_DRAFT].append(_proposalId);
3045     }
3046 
3047     function setProposalDraftPass(bytes32 _proposalId, bool _result)
3048         public
3049     {
3050         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3051 
3052         proposalsById[_proposalId].draftVoting.passed = _result;
3053         if (_result) {
3054             proposalsByState[PROPOSAL_STATE_DRAFT].remove_item(_proposalId);
3055             proposalsByState[PROPOSAL_STATE_MODERATED].append(_proposalId);
3056             proposalsById[_proposalId].currentState = PROPOSAL_STATE_MODERATED;
3057         } else {
3058             closeProposalInternal(_proposalId);
3059         }
3060     }
3061 
3062     function setProposalPass(bytes32 _proposalId, uint256 _index, bool _result)
3063         public
3064     {
3065         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3066 
3067         if (!_result) {
3068             closeProposalInternal(_proposalId);
3069         } else if (_index == 0) {
3070             proposalsByState[PROPOSAL_STATE_MODERATED].remove_item(_proposalId);
3071             proposalsByState[PROPOSAL_STATE_ONGOING].append(_proposalId);
3072             proposalsById[_proposalId].currentState = PROPOSAL_STATE_ONGOING;
3073         }
3074         proposalsById[_proposalId].votingRounds[_index].passed = _result;
3075     }
3076 
3077     function setProposalDraftVotingTime(
3078         bytes32 _proposalId,
3079         uint256 _time
3080     )
3081         public
3082     {
3083         require(sender_is(CONTRACT_DAO));
3084 
3085         proposalsById[_proposalId].draftVoting.startTime = _time;
3086     }
3087 
3088     function setProposalVotingTime(
3089         bytes32 _proposalId,
3090         uint256 _index,
3091         uint256 _time
3092     )
3093         public
3094     {
3095         require(sender_is_from([CONTRACT_DAO, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
3096 
3097         proposalsById[_proposalId].votingRounds[_index].startTime = _time;
3098     }
3099 
3100     function setDraftVotingClaim(bytes32 _proposalId, bool _claimed)
3101         public
3102     {
3103         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3104         proposalsById[_proposalId].draftVoting.claimed = _claimed;
3105     }
3106 
3107     function setVotingClaim(bytes32 _proposalId, uint256 _index, bool _claimed)
3108         public
3109     {
3110         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3111         proposalsById[_proposalId].votingRounds[_index].claimed = _claimed;
3112     }
3113 
3114     function setProposalCollateralStatus(bytes32 _proposalId, uint256 _status)
3115         public
3116     {
3117         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_FUNDING_MANAGER, CONTRACT_DAO]));
3118         proposalsById[_proposalId].collateralStatus = _status;
3119     }
3120 
3121     function setProposalCollateralAmount(bytes32 _proposalId, uint256 _amount)
3122         public
3123     {
3124         require(sender_is(CONTRACT_DAO));
3125         proposalsById[_proposalId].collateralAmount = _amount;
3126     }
3127 
3128     function updateProposalPRL(
3129         bytes32 _proposalId,
3130         uint256 _action,
3131         bytes32 _doc,
3132         uint256 _time
3133     )
3134         public
3135     {
3136         require(sender_is(CONTRACT_DAO));
3137         require(proposalsById[_proposalId].currentState != PROPOSAL_STATE_CLOSED);
3138 
3139         DaoStructs.PrlAction memory prlAction;
3140         prlAction.at = _time;
3141         prlAction.doc = _doc;
3142         prlAction.actionId = _action;
3143         proposalsById[_proposalId].prlActions.push(prlAction);
3144 
3145         if (_action == PRL_ACTION_PAUSE) {
3146           proposalsById[_proposalId].isPausedOrStopped = true;
3147         } else if (_action == PRL_ACTION_UNPAUSE) {
3148           proposalsById[_proposalId].isPausedOrStopped = false;
3149         } else { // STOP
3150           proposalsById[_proposalId].isPausedOrStopped = true;
3151           closeProposalInternal(_proposalId);
3152         }
3153     }
3154 
3155     function closeProposalInternal(bytes32 _proposalId)
3156         internal
3157     {
3158         bytes32 _currentState = proposalsById[_proposalId].currentState;
3159         proposalsByState[_currentState].remove_item(_proposalId);
3160         proposalsByState[PROPOSAL_STATE_CLOSED].append(_proposalId);
3161         proposalsById[_proposalId].currentState = PROPOSAL_STATE_CLOSED;
3162     }
3163 
3164     function addDraftVote(
3165         bytes32 _proposalId,
3166         address _voter,
3167         bool _vote,
3168         uint256 _weight
3169     )
3170         public
3171     {
3172         require(sender_is(CONTRACT_DAO_VOTING));
3173 
3174         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
3175         if (_vote) {
3176             _proposal.draftVoting.yesVotes[_voter] = _weight;
3177             if (_proposal.draftVoting.noVotes[_voter] > 0) { // minimize number of writes to storage, since EIP-1087 is not implemented yet
3178                 _proposal.draftVoting.noVotes[_voter] = 0;
3179             }
3180         } else {
3181             _proposal.draftVoting.noVotes[_voter] = _weight;
3182             if (_proposal.draftVoting.yesVotes[_voter] > 0) {
3183                 _proposal.draftVoting.yesVotes[_voter] = 0;
3184             }
3185         }
3186     }
3187 
3188     function commitVote(
3189         bytes32 _proposalId,
3190         bytes32 _hash,
3191         address _voter,
3192         uint256 _index
3193     )
3194         public
3195     {
3196         require(sender_is(CONTRACT_DAO_VOTING));
3197 
3198         proposalsById[_proposalId].votingRounds[_index].commits[_voter] = _hash;
3199     }
3200 
3201     function revealVote(
3202         bytes32 _proposalId,
3203         address _voter,
3204         bool _vote,
3205         uint256 _weight,
3206         uint256 _index
3207     )
3208         public
3209     {
3210         require(sender_is(CONTRACT_DAO_VOTING));
3211 
3212         proposalsById[_proposalId].votingRounds[_index].revealVote(_voter, _vote, _weight);
3213     }
3214 
3215     function closeProposal(bytes32 _proposalId)
3216         public
3217     {
3218         require(sender_is(CONTRACT_DAO));
3219         closeProposalInternal(_proposalId);
3220     }
3221 
3222     function archiveProposal(bytes32 _proposalId)
3223         public
3224     {
3225         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3226         bytes32 _currentState = proposalsById[_proposalId].currentState;
3227         proposalsByState[_currentState].remove_item(_proposalId);
3228         proposalsByState[PROPOSAL_STATE_ARCHIVED].append(_proposalId);
3229         proposalsById[_proposalId].currentState = PROPOSAL_STATE_ARCHIVED;
3230     }
3231 
3232     function setMilestoneFunded(bytes32 _proposalId, uint256 _milestoneId)
3233         public
3234     {
3235         require(sender_is(CONTRACT_DAO_FUNDING_MANAGER));
3236         proposalsById[_proposalId].votingRounds[_milestoneId].funded = true;
3237     }
3238 }
3239 
3240 // File: @digix/solidity-collections/contracts/abstract/AddressIteratorStorage.sol
3241 /**
3242   @title Address Iterator Storage
3243   @author DigixGlobal Pte Ltd
3244   @notice See: [Doubly Linked List](/DoublyLinkedList)
3245 */
3246 contract AddressIteratorStorage {
3247 
3248   // Initialize Doubly Linked List of Address
3249   using DoublyLinkedList for DoublyLinkedList.Address;
3250 
3251   /**
3252     @notice Reads the first item from the list of Address
3253     @param _list The source list
3254     @return {"_item" : "The first item from the list"}
3255   */
3256   function read_first_from_addresses(DoublyLinkedList.Address storage _list)
3257            internal
3258            constant
3259            returns (address _item)
3260   {
3261     _item = _list.start_item();
3262   }
3263 
3264 
3265   /**
3266     @notice Reads the last item from the list of Address
3267     @param _list The source list
3268     @return {"_item" : "The last item from the list"}
3269   */
3270   function read_last_from_addresses(DoublyLinkedList.Address storage _list)
3271            internal
3272            constant
3273            returns (address _item)
3274   {
3275     _item = _list.end_item();
3276   }
3277 
3278   /**
3279     @notice Reads the next item on the list of Address
3280     @param _list The source list
3281     @param _current_item The current item to be used as base line
3282     @return {"_item" : "The next item from the list based on the specieid `_current_item`"}
3283   */
3284   function read_next_from_addresses(DoublyLinkedList.Address storage _list, address _current_item)
3285            internal
3286            constant
3287            returns (address _item)
3288   {
3289     _item = _list.next_item(_current_item);
3290   }
3291 
3292   /**
3293     @notice Reads the previous item on the list of Address
3294     @param _list The source list
3295     @param _current_item The current item to be used as base line
3296     @return {"_item" : "The previous item from the list based on the spcified `_current_item`"}
3297   */
3298   function read_previous_from_addresses(DoublyLinkedList.Address storage _list, address _current_item)
3299            internal
3300            constant
3301            returns (address _item)
3302   {
3303     _item = _list.previous_item(_current_item);
3304   }
3305 
3306   /**
3307     @notice Reads the list of Address and returns the length of the list
3308     @param _list The source list
3309     @return {"_count": "The lenght of the list"}
3310   */
3311   function read_total_addresses(DoublyLinkedList.Address storage _list)
3312            internal
3313            constant
3314            returns (uint256 _count)
3315   {
3316     _count = _list.total();
3317   }
3318 }
3319 
3320 // File: contracts/storage/DaoStakeStorage.sol
3321 contract DaoStakeStorage is ResolverClient, DaoConstants, AddressIteratorStorage {
3322     using DoublyLinkedList for DoublyLinkedList.Address;
3323 
3324     // This is the DGD stake of a user (one that is considered in the DAO)
3325     mapping (address => uint256) public lockedDGDStake;
3326 
3327     // This is the actual number of DGDs locked by user
3328     // may be more than the lockedDGDStake
3329     // in case they locked during the main phase
3330     mapping (address => uint256) public actualLockedDGD;
3331 
3332     // The total locked DGDs in the DAO (summation of lockedDGDStake)
3333     uint256 public totalLockedDGDStake;
3334 
3335     // The total locked DGDs by moderators
3336     uint256 public totalModeratorLockedDGDStake;
3337 
3338     // The list of participants in DAO
3339     // actual participants will be subset of this list
3340     DoublyLinkedList.Address allParticipants;
3341 
3342     // The list of moderators in DAO
3343     // actual moderators will be subset of this list
3344     DoublyLinkedList.Address allModerators;
3345 
3346     // Boolean to mark if an address has redeemed
3347     // reputation points for their DGD Badge
3348     mapping (address => bool) public redeemedBadge;
3349 
3350     // mapping to note whether an address has claimed their
3351     // reputation bonus for carbon vote participation
3352     mapping (address => bool) public carbonVoteBonusClaimed;
3353 
3354     constructor(address _resolver) public {
3355         require(init(CONTRACT_STORAGE_DAO_STAKE, _resolver));
3356     }
3357 
3358     function redeemBadge(address _user)
3359         public
3360     {
3361         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3362         redeemedBadge[_user] = true;
3363     }
3364 
3365     function setCarbonVoteBonusClaimed(address _user)
3366         public
3367     {
3368         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3369         carbonVoteBonusClaimed[_user] = true;
3370     }
3371 
3372     function updateTotalLockedDGDStake(uint256 _totalLockedDGDStake)
3373         public
3374     {
3375         require(sender_is_from([CONTRACT_DAO_STAKE_LOCKING, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
3376         totalLockedDGDStake = _totalLockedDGDStake;
3377     }
3378 
3379     function updateTotalModeratorLockedDGDs(uint256 _totalLockedDGDStake)
3380         public
3381     {
3382         require(sender_is_from([CONTRACT_DAO_STAKE_LOCKING, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
3383         totalModeratorLockedDGDStake = _totalLockedDGDStake;
3384     }
3385 
3386     function updateUserDGDStake(address _user, uint256 _actualLockedDGD, uint256 _lockedDGDStake)
3387         public
3388     {
3389         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3390         actualLockedDGD[_user] = _actualLockedDGD;
3391         lockedDGDStake[_user] = _lockedDGDStake;
3392     }
3393 
3394     function readUserDGDStake(address _user)
3395         public
3396         view
3397         returns (
3398             uint256 _actualLockedDGD,
3399             uint256 _lockedDGDStake
3400         )
3401     {
3402         _actualLockedDGD = actualLockedDGD[_user];
3403         _lockedDGDStake = lockedDGDStake[_user];
3404     }
3405 
3406     function addToParticipantList(address _user)
3407         public
3408         returns (bool _success)
3409     {
3410         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3411         _success = allParticipants.append(_user);
3412     }
3413 
3414     function removeFromParticipantList(address _user)
3415         public
3416         returns (bool _success)
3417     {
3418         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3419         _success = allParticipants.remove_item(_user);
3420     }
3421 
3422     function addToModeratorList(address _user)
3423         public
3424         returns (bool _success)
3425     {
3426         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3427         _success = allModerators.append(_user);
3428     }
3429 
3430     function removeFromModeratorList(address _user)
3431         public
3432         returns (bool _success)
3433     {
3434         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3435         _success = allModerators.remove_item(_user);
3436     }
3437 
3438     function isInParticipantList(address _user)
3439         public
3440         view
3441         returns (bool _is)
3442     {
3443         _is = allParticipants.find(_user) != 0;
3444     }
3445 
3446     function isInModeratorsList(address _user)
3447         public
3448         view
3449         returns (bool _is)
3450     {
3451         _is = allModerators.find(_user) != 0;
3452     }
3453 
3454     function readFirstModerator()
3455         public
3456         view
3457         returns (address _item)
3458     {
3459         _item = read_first_from_addresses(allModerators);
3460     }
3461 
3462     function readLastModerator()
3463         public
3464         view
3465         returns (address _item)
3466     {
3467         _item = read_last_from_addresses(allModerators);
3468     }
3469 
3470     function readNextModerator(address _current_item)
3471         public
3472         view
3473         returns (address _item)
3474     {
3475         _item = read_next_from_addresses(allModerators, _current_item);
3476     }
3477 
3478     function readPreviousModerator(address _current_item)
3479         public
3480         view
3481         returns (address _item)
3482     {
3483         _item = read_previous_from_addresses(allModerators, _current_item);
3484     }
3485 
3486     function readTotalModerators()
3487         public
3488         view
3489         returns (uint256 _total_count)
3490     {
3491         _total_count = read_total_addresses(allModerators);
3492     }
3493 
3494     function readFirstParticipant()
3495         public
3496         view
3497         returns (address _item)
3498     {
3499         _item = read_first_from_addresses(allParticipants);
3500     }
3501 
3502     function readLastParticipant()
3503         public
3504         view
3505         returns (address _item)
3506     {
3507         _item = read_last_from_addresses(allParticipants);
3508     }
3509 
3510     function readNextParticipant(address _current_item)
3511         public
3512         view
3513         returns (address _item)
3514     {
3515         _item = read_next_from_addresses(allParticipants, _current_item);
3516     }
3517 
3518     function readPreviousParticipant(address _current_item)
3519         public
3520         view
3521         returns (address _item)
3522     {
3523         _item = read_previous_from_addresses(allParticipants, _current_item);
3524     }
3525 
3526     function readTotalParticipant()
3527         public
3528         view
3529         returns (uint256 _total_count)
3530     {
3531         _total_count = read_total_addresses(allParticipants);
3532     }
3533 }
3534 
3535 // File: contracts/service/DaoListingService.sol
3536 /* import "@digix/cacp-contracts-dao/contracts/ResolverClient.sol"; */
3537 /**
3538 @title Contract to list various storage states from DigixDAO
3539 @author Digix Holdings
3540 */
3541 contract DaoListingService is
3542     AddressIteratorInteractive,
3543     BytesIteratorInteractive,
3544     IndexedBytesIteratorInteractive,
3545     DaoWhitelistingCommon
3546 {
3547 
3548     /**
3549     @notice Constructor
3550     @param _resolver address of contract resolver
3551     */
3552     constructor(address _resolver) public {
3553         require(init(CONTRACT_SERVICE_DAO_LISTING, _resolver));
3554     }
3555 
3556     function daoStakeStorage()
3557         internal
3558         view
3559         returns (DaoStakeStorage _contract)
3560     {
3561         _contract = DaoStakeStorage(get_contract(CONTRACT_STORAGE_DAO_STAKE));
3562     }
3563 
3564     function daoStorage()
3565         internal
3566         view
3567         returns (DaoStorage _contract)
3568     {
3569         _contract = DaoStorage(get_contract(CONTRACT_STORAGE_DAO));
3570     }
3571 
3572     /**
3573     @notice function to list moderators
3574     @dev note that this list may include some additional entries that are
3575          not moderators in the current quarter. This may happen if they
3576          were moderators in the previous quarter, but have not confirmed
3577          their participation in the current quarter. For a single address,
3578          a better way to know if moderator or not is:
3579          Dao.isModerator(_user)
3580     @param _count number of addresses to list
3581     @param _from_start boolean, whether to list from start or end
3582     @return {
3583       "_moderators": "list of moderator addresses"
3584     }
3585     */
3586     function listModerators(uint256 _count, bool _from_start)
3587         public
3588         view
3589         returns (address[] _moderators)
3590     {
3591         _moderators = list_addresses(
3592             _count,
3593             daoStakeStorage().readFirstModerator,
3594             daoStakeStorage().readLastModerator,
3595             daoStakeStorage().readNextModerator,
3596             daoStakeStorage().readPreviousModerator,
3597             _from_start
3598         );
3599     }
3600 
3601     /**
3602     @notice function to list moderators from a particular moderator
3603     @dev note that this list may include some additional entries that are
3604          not moderators in the current quarter. This may happen if they
3605          were moderators in the previous quarter, but have not confirmed
3606          their participation in the current quarter. For a single address,
3607          a better way to know if moderator or not is:
3608          Dao.isModerator(_user)
3609 
3610          Another note: this function will start listing AFTER the _currentModerator
3611          For example: we have [address1, address2, address3, address4]. listModeratorsFrom(address1, 2, true) = [address2, address3]
3612     @param _currentModerator start the list after this moderator address
3613     @param _count number of addresses to list
3614     @param _from_start boolean, whether to list from start or end
3615     @return {
3616       "_moderators": "list of moderator addresses"
3617     }
3618     */
3619     function listModeratorsFrom(
3620         address _currentModerator,
3621         uint256 _count,
3622         bool _from_start
3623     )
3624         public
3625         view
3626         returns (address[] _moderators)
3627     {
3628         _moderators = list_addresses_from(
3629             _currentModerator,
3630             _count,
3631             daoStakeStorage().readFirstModerator,
3632             daoStakeStorage().readLastModerator,
3633             daoStakeStorage().readNextModerator,
3634             daoStakeStorage().readPreviousModerator,
3635             _from_start
3636         );
3637     }
3638 
3639     /**
3640     @notice function to list participants
3641     @dev note that this list may include some additional entries that are
3642          not participants in the current quarter. This may happen if they
3643          were participants in the previous quarter, but have not confirmed
3644          their participation in the current quarter. For a single address,
3645          a better way to know if participant or not is:
3646          Dao.isParticipant(_user)
3647     @param _count number of addresses to list
3648     @param _from_start boolean, whether to list from start or end
3649     @return {
3650       "_participants": "list of participant addresses"
3651     }
3652     */
3653     function listParticipants(uint256 _count, bool _from_start)
3654         public
3655         view
3656         returns (address[] _participants)
3657     {
3658         _participants = list_addresses(
3659             _count,
3660             daoStakeStorage().readFirstParticipant,
3661             daoStakeStorage().readLastParticipant,
3662             daoStakeStorage().readNextParticipant,
3663             daoStakeStorage().readPreviousParticipant,
3664             _from_start
3665         );
3666     }
3667 
3668     /**
3669     @notice function to list participants from a particular participant
3670     @dev note that this list may include some additional entries that are
3671          not participants in the current quarter. This may happen if they
3672          were participants in the previous quarter, but have not confirmed
3673          their participation in the current quarter. For a single address,
3674          a better way to know if participant or not is:
3675          contracts.dao.isParticipant(_user)
3676 
3677          Another note: this function will start listing AFTER the _currentParticipant
3678          For example: we have [address1, address2, address3, address4]. listParticipantsFrom(address1, 2, true) = [address2, address3]
3679     @param _currentParticipant list from AFTER this participant address
3680     @param _count number of addresses to list
3681     @param _from_start boolean, whether to list from start or end
3682     @return {
3683       "_participants": "list of participant addresses"
3684     }
3685     */
3686     function listParticipantsFrom(
3687         address _currentParticipant,
3688         uint256 _count,
3689         bool _from_start
3690     )
3691         public
3692         view
3693         returns (address[] _participants)
3694     {
3695         _participants = list_addresses_from(
3696             _currentParticipant,
3697             _count,
3698             daoStakeStorage().readFirstParticipant,
3699             daoStakeStorage().readLastParticipant,
3700             daoStakeStorage().readNextParticipant,
3701             daoStakeStorage().readPreviousParticipant,
3702             _from_start
3703         );
3704     }
3705 
3706     /**
3707     @notice function to list _count no. of proposals
3708     @param _count number of proposals to list
3709     @param _from_start boolean value, true if count from start, false if count from end
3710     @return {
3711       "_proposals": "the list of proposal IDs"
3712     }
3713     */
3714     function listProposals(
3715         uint256 _count,
3716         bool _from_start
3717     )
3718         public
3719         view
3720         returns (bytes32[] _proposals)
3721     {
3722         _proposals = list_bytesarray(
3723             _count,
3724             daoStorage().getFirstProposal,
3725             daoStorage().getLastProposal,
3726             daoStorage().getNextProposal,
3727             daoStorage().getPreviousProposal,
3728             _from_start
3729         );
3730     }
3731 
3732     /**
3733     @notice function to list _count no. of proposals from AFTER _currentProposal
3734     @param _currentProposal ID of proposal to list proposals from
3735     @param _count number of proposals to list
3736     @param _from_start boolean value, true if count forwards, false if count backwards
3737     @return {
3738       "_proposals": "the list of proposal IDs"
3739     }
3740     */
3741     function listProposalsFrom(
3742         bytes32 _currentProposal,
3743         uint256 _count,
3744         bool _from_start
3745     )
3746         public
3747         view
3748         returns (bytes32[] _proposals)
3749     {
3750         _proposals = list_bytesarray_from(
3751             _currentProposal,
3752             _count,
3753             daoStorage().getFirstProposal,
3754             daoStorage().getLastProposal,
3755             daoStorage().getNextProposal,
3756             daoStorage().getPreviousProposal,
3757             _from_start
3758         );
3759     }
3760 
3761     /**
3762     @notice function to list _count no. of proposals in state _stateId
3763     @param _stateId state of proposal
3764     @param _count number of proposals to list
3765     @param _from_start boolean value, true if count from start, false if count from end
3766     @return {
3767       "_proposals": "the list of proposal IDs"
3768     }
3769     */
3770     function listProposalsInState(
3771         bytes32 _stateId,
3772         uint256 _count,
3773         bool _from_start
3774     )
3775         public
3776         view
3777         returns (bytes32[] _proposals)
3778     {
3779         require(senderIsAllowedToRead());
3780         _proposals = list_indexed_bytesarray(
3781             _stateId,
3782             _count,
3783             daoStorage().getFirstProposalInState,
3784             daoStorage().getLastProposalInState,
3785             daoStorage().getNextProposalInState,
3786             daoStorage().getPreviousProposalInState,
3787             _from_start
3788         );
3789     }
3790 
3791     /**
3792     @notice function to list _count no. of proposals in state _stateId from AFTER _currentProposal
3793     @param _stateId state of proposal
3794     @param _currentProposal ID of proposal to list proposals from
3795     @param _count number of proposals to list
3796     @param _from_start boolean value, true if count forwards, false if count backwards
3797     @return {
3798       "_proposals": "the list of proposal IDs"
3799     }
3800     */
3801     function listProposalsInStateFrom(
3802         bytes32 _stateId,
3803         bytes32 _currentProposal,
3804         uint256 _count,
3805         bool _from_start
3806     )
3807         public
3808         view
3809         returns (bytes32[] _proposals)
3810     {
3811         require(senderIsAllowedToRead());
3812         _proposals = list_indexed_bytesarray_from(
3813             _stateId,
3814             _currentProposal,
3815             _count,
3816             daoStorage().getFirstProposalInState,
3817             daoStorage().getLastProposalInState,
3818             daoStorage().getNextProposalInState,
3819             daoStorage().getPreviousProposalInState,
3820             _from_start
3821         );
3822     }
3823 
3824     /**
3825     @notice function to list proposal versions
3826     @param _proposalId ID of the proposal
3827     @param _count number of proposal versions to list
3828     @param _from_start boolean, true to list from start, false to list from end
3829     @return {
3830       "_versions": "list of proposal versions"
3831     }
3832     */
3833     function listProposalVersions(
3834         bytes32 _proposalId,
3835         uint256 _count,
3836         bool _from_start
3837     )
3838         public
3839         view
3840         returns (bytes32[] _versions)
3841     {
3842         _versions = list_indexed_bytesarray(
3843             _proposalId,
3844             _count,
3845             daoStorage().getFirstProposalVersion,
3846             daoStorage().getLastProposalVersion,
3847             daoStorage().getNextProposalVersion,
3848             daoStorage().getPreviousProposalVersion,
3849             _from_start
3850         );
3851     }
3852 
3853     /**
3854     @notice function to list proposal versions from AFTER a particular version
3855     @param _proposalId ID of the proposal
3856     @param _currentVersion version to list _count versions from
3857     @param _count number of proposal versions to list
3858     @param _from_start boolean, true to list from start, false to list from end
3859     @return {
3860       "_versions": "list of proposal versions"
3861     }
3862     */
3863     function listProposalVersionsFrom(
3864         bytes32 _proposalId,
3865         bytes32 _currentVersion,
3866         uint256 _count,
3867         bool _from_start
3868     )
3869         public
3870         view
3871         returns (bytes32[] _versions)
3872     {
3873         _versions = list_indexed_bytesarray_from(
3874             _proposalId,
3875             _currentVersion,
3876             _count,
3877             daoStorage().getFirstProposalVersion,
3878             daoStorage().getLastProposalVersion,
3879             daoStorage().getNextProposalVersion,
3880             daoStorage().getPreviousProposalVersion,
3881             _from_start
3882         );
3883     }
3884 }
3885 
3886 // File: @digix/solidity-collections/contracts/abstract/IndexedAddressIteratorStorage.sol
3887 /**
3888   @title Indexed Address IteratorStorage
3889   @author DigixGlobal Pte Ltd
3890   @notice This contract utilizes: [Doubly Linked List](/DoublyLinkedList)
3891 */
3892 contract IndexedAddressIteratorStorage {
3893 
3894   using DoublyLinkedList for DoublyLinkedList.IndexedAddress;
3895   /**
3896     @notice Reads the first item from an Indexed Address Doubly Linked List
3897     @param _list The source list
3898     @param _collection_index Index of the Collection to evaluate
3899     @return {"_item" : "First item on the list"}
3900   */
3901   function read_first_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
3902            internal
3903            constant
3904            returns (address _item)
3905   {
3906     _item = _list.start_item(_collection_index);
3907   }
3908 
3909   /**
3910     @notice Reads the last item from an Indexed Address Doubly Linked list
3911     @param _list The source list
3912     @param _collection_index Index of the Collection to evaluate
3913     @return {"_item" : "First item on the list"}
3914   */
3915   function read_last_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
3916            internal
3917            constant
3918            returns (address _item)
3919   {
3920     _item = _list.end_item(_collection_index);
3921   }
3922 
3923   /**
3924     @notice Reads the next item from an Indexed Address Doubly Linked List based on the specified `_current_item`
3925     @param _list The source list
3926     @param _collection_index Index of the Collection to evaluate
3927     @param _current_item The current item to use as base line
3928     @return {"_item": "The next item on the list"}
3929   */
3930   function read_next_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index, address _current_item)
3931            internal
3932            constant
3933            returns (address _item)
3934   {
3935     _item = _list.next_item(_collection_index, _current_item);
3936   }
3937 
3938   /**
3939     @notice Reads the previous item from an Index Address Doubly Linked List based on the specified `_current_item`
3940     @param _list The source list
3941     @param _collection_index Index of the Collection to evaluate
3942     @param _current_item The current item to use as base line
3943     @return {"_item" : "The previous item on the list"}
3944   */
3945   function read_previous_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index, address _current_item)
3946            internal
3947            constant
3948            returns (address _item)
3949   {
3950     _item = _list.previous_item(_collection_index, _current_item);
3951   }
3952 
3953 
3954   /**
3955     @notice Reads the total number of items in an Indexed Address Doubly Linked List
3956     @param _list  The source list
3957     @param _collection_index Index of the Collection to evaluate
3958     @return {"_count": "Length of the Doubly Linked list"}
3959   */
3960   function read_total_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
3961            internal
3962            constant
3963            returns (uint256 _count)
3964   {
3965     _count = _list.total(_collection_index);
3966   }
3967 }
3968 
3969 // File: @digix/solidity-collections/contracts/abstract/UintIteratorStorage.sol
3970 /**
3971   @title Uint Iterator Storage
3972   @author DigixGlobal Pte Ltd
3973 */
3974 contract UintIteratorStorage {
3975 
3976   using DoublyLinkedList for DoublyLinkedList.Uint;
3977 
3978   /**
3979     @notice Returns the first item from a `DoublyLinkedList.Uint` list
3980     @param _list The DoublyLinkedList.Uint list
3981     @return {"_item": "The first item"}
3982   */
3983   function read_first_from_uints(DoublyLinkedList.Uint storage _list)
3984            internal
3985            constant
3986            returns (uint256 _item)
3987   {
3988     _item = _list.start_item();
3989   }
3990 
3991   /**
3992     @notice Returns the last item from a `DoublyLinkedList.Uint` list
3993     @param _list The DoublyLinkedList.Uint list
3994     @return {"_item": "The last item"}
3995   */
3996   function read_last_from_uints(DoublyLinkedList.Uint storage _list)
3997            internal
3998            constant
3999            returns (uint256 _item)
4000   {
4001     _item = _list.end_item();
4002   }
4003 
4004   /**
4005     @notice Returns the next item from a `DoublyLinkedList.Uint` list based on the specified `_current_item`
4006     @param _list The DoublyLinkedList.Uint list
4007     @param _current_item The current item
4008     @return {"_item": "The next item"}
4009   */
4010   function read_next_from_uints(DoublyLinkedList.Uint storage _list, uint256 _current_item)
4011            internal
4012            constant
4013            returns (uint256 _item)
4014   {
4015     _item = _list.next_item(_current_item);
4016   }
4017 
4018   /**
4019     @notice Returns the previous item from a `DoublyLinkedList.Uint` list based on the specified `_current_item`
4020     @param _list The DoublyLinkedList.Uint list
4021     @param _current_item The current item
4022     @return {"_item": "The previous item"}
4023   */
4024   function read_previous_from_uints(DoublyLinkedList.Uint storage _list, uint256 _current_item)
4025            internal
4026            constant
4027            returns (uint256 _item)
4028   {
4029     _item = _list.previous_item(_current_item);
4030   }
4031 
4032   /**
4033     @notice Returns the total count of itemsfrom a `DoublyLinkedList.Uint` list
4034     @param _list The DoublyLinkedList.Uint list
4035     @return {"_count": "The total count of items"}
4036   */
4037   function read_total_uints(DoublyLinkedList.Uint storage _list)
4038            internal
4039            constant
4040            returns (uint256 _count)
4041   {
4042     _count = _list.total();
4043   }
4044 }
4045 
4046 // File: @digix/cdap/contracts/storage/DirectoryStorage.sol
4047 /**
4048 @title Directory Storage contains information of a directory
4049 @author DigixGlobal
4050 */
4051 contract DirectoryStorage is IndexedAddressIteratorStorage, UintIteratorStorage {
4052 
4053   using DoublyLinkedList for DoublyLinkedList.IndexedAddress;
4054   using DoublyLinkedList for DoublyLinkedList.Uint;
4055 
4056   struct User {
4057     bytes32 document;
4058     bool active;
4059   }
4060 
4061   struct Group {
4062     bytes32 name;
4063     bytes32 document;
4064     uint256 role_id;
4065     mapping(address => User) members_by_address;
4066   }
4067 
4068   struct System {
4069     DoublyLinkedList.Uint groups;
4070     DoublyLinkedList.IndexedAddress groups_collection;
4071     mapping (uint256 => Group) groups_by_id;
4072     mapping (address => uint256) group_ids_by_address;
4073     mapping (uint256 => bytes32) roles_by_id;
4074     bool initialized;
4075     uint256 total_groups;
4076   }
4077 
4078   System system;
4079 
4080   /**
4081   @notice Initializes directory settings
4082   @return _success If directory initialization is successful
4083   */
4084   function initialize_directory()
4085            internal
4086            returns (bool _success)
4087   {
4088     require(system.initialized == false);
4089     system.total_groups = 0;
4090     system.initialized = true;
4091     internal_create_role(1, "root");
4092     internal_create_group(1, "root", "");
4093     _success = internal_update_add_user_to_group(1, tx.origin, "");
4094   }
4095 
4096   /**
4097   @notice Creates a new role with the given information
4098   @param _role_id Id of the new role
4099   @param _name Name of the new role
4100   @return {"_success": "If creation of new role is successful"}
4101   */
4102   function internal_create_role(uint256 _role_id, bytes32 _name)
4103            internal
4104            returns (bool _success)
4105   {
4106     require(_role_id > 0);
4107     require(_name != bytes32(0x0));
4108     system.roles_by_id[_role_id] = _name;
4109     _success = true;
4110   }
4111 
4112   /**
4113   @notice Returns the role's name of a role id
4114   @param _role_id Id of the role
4115   @return {"_name": "Name of the role"}
4116   */
4117   function read_role(uint256 _role_id)
4118            public
4119            constant
4120            returns (bytes32 _name)
4121   {
4122     _name = system.roles_by_id[_role_id];
4123   }
4124 
4125   /**
4126   @notice Creates a new group with the given information
4127   @param _role_id Role id of the new group
4128   @param _name Name of the new group
4129   @param _document Document of the new group
4130   @return {
4131     "_success": "If creation of the new group is successful",
4132     "_group_id: "Id of the new group"
4133   }
4134   */
4135   function internal_create_group(uint256 _role_id, bytes32 _name, bytes32 _document)
4136            internal
4137            returns (bool _success, uint256 _group_id)
4138   {
4139     require(_role_id > 0);
4140     require(read_role(_role_id) != bytes32(0x0));
4141     _group_id = ++system.total_groups;
4142     system.groups.append(_group_id);
4143     system.groups_by_id[_group_id].role_id = _role_id;
4144     system.groups_by_id[_group_id].name = _name;
4145     system.groups_by_id[_group_id].document = _document;
4146     _success = true;
4147   }
4148 
4149   /**
4150   @notice Returns the group's information
4151   @param _group_id Id of the group
4152   @return {
4153     "_role_id": "Role id of the group",
4154     "_name: "Name of the group",
4155     "_document: "Document of the group"
4156   }
4157   */
4158   function read_group(uint256 _group_id)
4159            public
4160            constant
4161            returns (uint256 _role_id, bytes32 _name, bytes32 _document, uint256 _members_count)
4162   {
4163     if (system.groups.valid_item(_group_id)) {
4164       _role_id = system.groups_by_id[_group_id].role_id;
4165       _name = system.groups_by_id[_group_id].name;
4166       _document = system.groups_by_id[_group_id].document;
4167       _members_count = read_total_indexed_addresses(system.groups_collection, bytes32(_group_id));
4168     } else {
4169       _role_id = 0;
4170       _name = "invalid";
4171       _document = "";
4172       _members_count = 0;
4173     }
4174   }
4175 
4176   /**
4177   @notice Adds new user with the given information to a group
4178   @param _group_id Id of the group
4179   @param _user Address of the new user
4180   @param _document Information of the new user
4181   @return {"_success": "If adding new user to a group is successful"}
4182   */
4183   function internal_update_add_user_to_group(uint256 _group_id, address _user, bytes32 _document)
4184            internal
4185            returns (bool _success)
4186   {
4187     if (system.groups_by_id[_group_id].members_by_address[_user].active == false && system.group_ids_by_address[_user] == 0 && system.groups_by_id[_group_id].role_id != 0) {
4188 
4189       system.groups_by_id[_group_id].members_by_address[_user].active = true;
4190       system.group_ids_by_address[_user] = _group_id;
4191       system.groups_collection.append(bytes32(_group_id), _user);
4192       system.groups_by_id[_group_id].members_by_address[_user].document = _document;
4193       _success = true;
4194     } else {
4195       _success = false;
4196     }
4197   }
4198 
4199   /**
4200   @notice Removes user from its group
4201   @param _user Address of the user
4202   @return {"_success": "If removing of user is successful"}
4203   */
4204   function internal_destroy_group_user(address _user)
4205            internal
4206            returns (bool _success)
4207   {
4208     uint256 _group_id = system.group_ids_by_address[_user];
4209     if ((_group_id == 1) && (system.groups_collection.total(bytes32(_group_id)) == 1)) {
4210       _success = false;
4211     } else {
4212       system.groups_by_id[_group_id].members_by_address[_user].active = false;
4213       system.group_ids_by_address[_user] = 0;
4214       delete system.groups_by_id[_group_id].members_by_address[_user];
4215       _success = system.groups_collection.remove_item(bytes32(_group_id), _user);
4216     }
4217   }
4218 
4219   /**
4220   @notice Returns the role id of a user
4221   @param _user Address of a user
4222   @return {"_role_id": "Role id of the user"}
4223   */
4224   function read_user_role_id(address _user)
4225            constant
4226            public
4227            returns (uint256 _role_id)
4228   {
4229     uint256 _group_id = system.group_ids_by_address[_user];
4230     _role_id = system.groups_by_id[_group_id].role_id;
4231   }
4232 
4233   /**
4234   @notice Returns the user's information
4235   @param _user Address of the user
4236   @return {
4237     "_group_id": "Group id of the user",
4238     "_role_id": "Role id of the user",
4239     "_document": "Information of the user"
4240   }
4241   */
4242   function read_user(address _user)
4243            public
4244            constant
4245            returns (uint256 _group_id, uint256 _role_id, bytes32 _document)
4246   {
4247     _group_id = system.group_ids_by_address[_user];
4248     _role_id = system.groups_by_id[_group_id].role_id;
4249     _document = system.groups_by_id[_group_id].members_by_address[_user].document;
4250   }
4251 
4252   /**
4253   @notice Returns the id of the first group
4254   @return {"_group_id": "Id of the first group"}
4255   */
4256   function read_first_group()
4257            view
4258            external
4259            returns (uint256 _group_id)
4260   {
4261     _group_id = read_first_from_uints(system.groups);
4262   }
4263 
4264   /**
4265   @notice Returns the id of the last group
4266   @return {"_group_id": "Id of the last group"}
4267   */
4268   function read_last_group()
4269            view
4270            external
4271            returns (uint256 _group_id)
4272   {
4273     _group_id = read_last_from_uints(system.groups);
4274   }
4275 
4276   /**
4277   @notice Returns the id of the previous group depending on the given current group
4278   @param _current_group_id Id of the current group
4279   @return {"_group_id": "Id of the previous group"}
4280   */
4281   function read_previous_group_from_group(uint256 _current_group_id)
4282            view
4283            external
4284            returns (uint256 _group_id)
4285   {
4286     _group_id = read_previous_from_uints(system.groups, _current_group_id);
4287   }
4288 
4289   /**
4290   @notice Returns the id of the next group depending on the given current group
4291   @param _current_group_id Id of the current group
4292   @return {"_group_id": "Id of the next group"}
4293   */
4294   function read_next_group_from_group(uint256 _current_group_id)
4295            view
4296            external
4297            returns (uint256 _group_id)
4298   {
4299     _group_id = read_next_from_uints(system.groups, _current_group_id);
4300   }
4301 
4302   /**
4303   @notice Returns the total number of groups
4304   @return {"_total_groups": "Total number of groups"}
4305   */
4306   function read_total_groups()
4307            view
4308            external
4309            returns (uint256 _total_groups)
4310   {
4311     _total_groups = read_total_uints(system.groups);
4312   }
4313 
4314   /**
4315   @notice Returns the first user of a group
4316   @param _group_id Id of the group
4317   @return {"_user": "Address of the user"}
4318   */
4319   function read_first_user_in_group(bytes32 _group_id)
4320            view
4321            external
4322            returns (address _user)
4323   {
4324     _user = read_first_from_indexed_addresses(system.groups_collection, bytes32(_group_id));
4325   }
4326 
4327   /**
4328   @notice Returns the last user of a group
4329   @param _group_id Id of the group
4330   @return {"_user": "Address of the user"}
4331   */
4332   function read_last_user_in_group(bytes32 _group_id)
4333            view
4334            external
4335            returns (address _user)
4336   {
4337     _user = read_last_from_indexed_addresses(system.groups_collection, bytes32(_group_id));
4338   }
4339 
4340   /**
4341   @notice Returns the next user of a group depending on the given current user
4342   @param _group_id Id of the group
4343   @param _current_user Address of the current user
4344   @return {"_user": "Address of the next user"}
4345   */
4346   function read_next_user_in_group(bytes32 _group_id, address _current_user)
4347            view
4348            external
4349            returns (address _user)
4350   {
4351     _user = read_next_from_indexed_addresses(system.groups_collection, bytes32(_group_id), _current_user);
4352   }
4353 
4354   /**
4355   @notice Returns the previous user of a group depending on the given current user
4356   @param _group_id Id of the group
4357   @param _current_user Address of the current user
4358   @return {"_user": "Address of the last user"}
4359   */
4360   function read_previous_user_in_group(bytes32 _group_id, address _current_user)
4361            view
4362            external
4363            returns (address _user)
4364   {
4365     _user = read_previous_from_indexed_addresses(system.groups_collection, bytes32(_group_id), _current_user);
4366   }
4367 
4368   /**
4369   @notice Returns the total number of users of a group
4370   @param _group_id Id of the group
4371   @return {"_total_users": "Total number of users"}
4372   */
4373   function read_total_users_in_group(bytes32 _group_id)
4374            view
4375            external
4376            returns (uint256 _total_users)
4377   {
4378     _total_users = read_total_indexed_addresses(system.groups_collection, bytes32(_group_id));
4379   }
4380 }
4381 
4382 // File: contracts/storage/DaoIdentityStorage.sol
4383 contract DaoIdentityStorage is ResolverClient, DaoConstants, DirectoryStorage {
4384 
4385     // struct for KYC details
4386     // doc is the IPFS doc hash for any information regarding this KYC
4387     // id_expiration is the UTC timestamp at which this KYC will expire
4388     // at any time after this, the user's KYC is invalid, and that user
4389     // MUST re-KYC before doing any proposer related operation in DigixDAO
4390     struct KycDetails {
4391         bytes32 doc;
4392         uint256 id_expiration;
4393     }
4394 
4395     // a mapping of address to the KYC details
4396     mapping (address => KycDetails) kycInfo;
4397 
4398     constructor(address _resolver)
4399         public
4400     {
4401         require(init(CONTRACT_STORAGE_DAO_IDENTITY, _resolver));
4402         require(initialize_directory());
4403     }
4404 
4405     function create_group(uint256 _role_id, bytes32 _name, bytes32 _document)
4406         public
4407         returns (bool _success, uint256 _group_id)
4408     {
4409         require(sender_is(CONTRACT_DAO_IDENTITY));
4410         (_success, _group_id) = internal_create_group(_role_id, _name, _document);
4411         require(_success);
4412     }
4413 
4414     function create_role(uint256 _role_id, bytes32 _name)
4415         public
4416         returns (bool _success)
4417     {
4418         require(sender_is(CONTRACT_DAO_IDENTITY));
4419         _success = internal_create_role(_role_id, _name);
4420         require(_success);
4421     }
4422 
4423     function update_add_user_to_group(uint256 _group_id, address _user, bytes32 _document)
4424         public
4425         returns (bool _success)
4426     {
4427         require(sender_is(CONTRACT_DAO_IDENTITY));
4428         _success = internal_update_add_user_to_group(_group_id, _user, _document);
4429         require(_success);
4430     }
4431 
4432     function update_remove_group_user(address _user)
4433         public
4434         returns (bool _success)
4435     {
4436         require(sender_is(CONTRACT_DAO_IDENTITY));
4437         _success = internal_destroy_group_user(_user);
4438         require(_success);
4439     }
4440 
4441     function update_kyc(address _user, bytes32 _doc, uint256 _id_expiration)
4442         public
4443     {
4444         require(sender_is(CONTRACT_DAO_IDENTITY));
4445         kycInfo[_user].doc = _doc;
4446         kycInfo[_user].id_expiration = _id_expiration;
4447     }
4448 
4449     function read_kyc_info(address _user)
4450         public
4451         view
4452         returns (bytes32 _doc, uint256 _id_expiration)
4453     {
4454         _doc = kycInfo[_user].doc;
4455         _id_expiration = kycInfo[_user].id_expiration;
4456     }
4457 
4458     function is_kyc_approved(address _user)
4459         public
4460         view
4461         returns (bool _approved)
4462     {
4463         uint256 _id_expiration;
4464         (,_id_expiration) = read_kyc_info(_user);
4465         _approved = _id_expiration > now;
4466     }
4467 }
4468 
4469 // File: contracts/common/IdentityCommon.sol
4470 contract IdentityCommon is DaoWhitelistingCommon {
4471 
4472     modifier if_root() {
4473         require(identity_storage().read_user_role_id(msg.sender) == ROLES_ROOT);
4474         _;
4475     }
4476 
4477     modifier if_founder() {
4478         require(is_founder());
4479         _;
4480     }
4481 
4482     function is_founder()
4483         internal
4484         view
4485         returns (bool _isFounder)
4486     {
4487         _isFounder = identity_storage().read_user_role_id(msg.sender) == ROLES_FOUNDERS;
4488     }
4489 
4490     modifier if_prl() {
4491         require(identity_storage().read_user_role_id(msg.sender) == ROLES_PRLS);
4492         _;
4493     }
4494 
4495     modifier if_kyc_admin() {
4496         require(identity_storage().read_user_role_id(msg.sender) == ROLES_KYC_ADMINS);
4497         _;
4498     }
4499 
4500     function identity_storage()
4501         internal
4502         view
4503         returns (DaoIdentityStorage _contract)
4504     {
4505         _contract = DaoIdentityStorage(get_contract(CONTRACT_STORAGE_DAO_IDENTITY));
4506     }
4507 }
4508 
4509 // File: contracts/storage/DaoConfigsStorage.sol
4510 contract DaoConfigsStorage is ResolverClient, DaoConstants {
4511 
4512     // mapping of config name to config value
4513     // config names can be found in DaoConstants contract
4514     mapping (bytes32 => uint256) public uintConfigs;
4515 
4516     // mapping of config name to config value
4517     // config names can be found in DaoConstants contract
4518     mapping (bytes32 => address) public addressConfigs;
4519 
4520     // mapping of config name to config value
4521     // config names can be found in DaoConstants contract
4522     mapping (bytes32 => bytes32) public bytesConfigs;
4523 
4524     uint256 ONE_BILLION = 1000000000;
4525     uint256 ONE_MILLION = 1000000;
4526 
4527     constructor(address _resolver)
4528         public
4529     {
4530         require(init(CONTRACT_STORAGE_DAO_CONFIG, _resolver));
4531 
4532         uintConfigs[CONFIG_LOCKING_PHASE_DURATION] = 10 days;
4533         uintConfigs[CONFIG_QUARTER_DURATION] = QUARTER_DURATION;
4534         uintConfigs[CONFIG_VOTING_COMMIT_PHASE] = 14 days;
4535         uintConfigs[CONFIG_VOTING_PHASE_TOTAL] = 21 days;
4536         uintConfigs[CONFIG_INTERIM_COMMIT_PHASE] = 7 days;
4537         uintConfigs[CONFIG_INTERIM_PHASE_TOTAL] = 14 days;
4538 
4539 
4540 
4541         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR] = 5; // 5%
4542         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR] = 100; // 5%
4543         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR] = 35; // 35%
4544         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR] = 100; // 35%
4545 
4546 
4547         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR] = 5; // 5%
4548         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR] = 100; // 5%
4549         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR] = 25; // 25%
4550         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR] = 100; // 25%
4551 
4552         uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR] = 1; // >50%
4553         uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR] = 2; // >50%
4554         uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR] = 1; // >50%
4555         uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR] = 2; // >50%
4556 
4557 
4558         uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE] = ONE_BILLION;
4559         uintConfigs[CONFIG_QUARTER_POINT_VOTE] = ONE_BILLION;
4560         uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE] = ONE_BILLION;
4561 
4562         uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH] = 20000 * ONE_BILLION;
4563 
4564         uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR] = 15; // 15% bonus for consistent votes
4565         uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR] = 100; // 15% bonus for consistent votes
4566 
4567         uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE] = 28 days;
4568         uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL] = 35 days;
4569 
4570 
4571 
4572         uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR] = 1; // >50%
4573         uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR] = 2; // >50%
4574 
4575         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR] = 40; // 40%
4576         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR] = 100; // 40%
4577 
4578         uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION] = 8334 * ONE_MILLION;
4579 
4580         uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING] = 1666 * ONE_MILLION;
4581         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM] = 1; // 1 extra QP gains 1/1 RP
4582         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN] = 1;
4583 
4584 
4585         uintConfigs[CONFIG_MINIMAL_QUARTER_POINT] = 2 * ONE_BILLION;
4586         uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR] = 400 * ONE_BILLION;
4587         uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR] = 2000 * ONE_BILLION;
4588 
4589         uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT] = 4 * ONE_BILLION;
4590         uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR] = 400 * ONE_BILLION;
4591         uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR] = 2000 * ONE_BILLION;
4592 
4593         uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM] = 42; //4.2% of DGX to moderator voting activity
4594         uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN] = 1000;
4595 
4596         uintConfigs[CONFIG_DRAFT_VOTING_PHASE] = 10 days;
4597 
4598         uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE] = 412500 * ONE_MILLION;
4599 
4600         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR] = 7; // 7%
4601         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR] = 100; // 7%
4602 
4603         uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION] = 12500 * ONE_MILLION;
4604         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM] = 1;
4605         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN] = 1;
4606 
4607         uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE] = 10 days;
4608 
4609         uintConfigs[CONFIG_MINIMUM_LOCKED_DGD] = 10 * ONE_BILLION;
4610         uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR] = 842 * ONE_BILLION;
4611         uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR] = 400 * ONE_BILLION;
4612 
4613         uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL] = 2 ether;
4614 
4615         uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX] = 100 ether;
4616         uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX] = 5;
4617         uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER] = 80;
4618 
4619         uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION] = 90 days;
4620         uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS] = 10 * ONE_BILLION;
4621     }
4622 
4623     function updateUintConfigs(uint256[] _uintConfigs)
4624         external
4625     {
4626         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
4627         uintConfigs[CONFIG_LOCKING_PHASE_DURATION] = _uintConfigs[0];
4628         /*
4629         This used to be a config that can be changed. Now, _uintConfigs[1] is just a dummy config that doesnt do anything
4630         uintConfigs[CONFIG_QUARTER_DURATION] = _uintConfigs[1];
4631         */
4632         uintConfigs[CONFIG_VOTING_COMMIT_PHASE] = _uintConfigs[2];
4633         uintConfigs[CONFIG_VOTING_PHASE_TOTAL] = _uintConfigs[3];
4634         uintConfigs[CONFIG_INTERIM_COMMIT_PHASE] = _uintConfigs[4];
4635         uintConfigs[CONFIG_INTERIM_PHASE_TOTAL] = _uintConfigs[5];
4636         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR] = _uintConfigs[6];
4637         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR] = _uintConfigs[7];
4638         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR] = _uintConfigs[8];
4639         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[9];
4640         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR] = _uintConfigs[10];
4641         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR] = _uintConfigs[11];
4642         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR] = _uintConfigs[12];
4643         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[13];
4644         uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR] = _uintConfigs[14];
4645         uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR] = _uintConfigs[15];
4646         uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR] = _uintConfigs[16];
4647         uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR] = _uintConfigs[17];
4648         uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE] = _uintConfigs[18];
4649         uintConfigs[CONFIG_QUARTER_POINT_VOTE] = _uintConfigs[19];
4650         uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE] = _uintConfigs[20];
4651         uintConfigs[CONFIG_MINIMAL_QUARTER_POINT] = _uintConfigs[21];
4652         uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH] = _uintConfigs[22];
4653         uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR] = _uintConfigs[23];
4654         uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR] = _uintConfigs[24];
4655         uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE] = _uintConfigs[25];
4656         uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL] = _uintConfigs[26];
4657         uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR] = _uintConfigs[27];
4658         uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR] = _uintConfigs[28];
4659         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR] = _uintConfigs[29];
4660         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR] = _uintConfigs[30];
4661         uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION] = _uintConfigs[31];
4662         uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING] = _uintConfigs[32];
4663         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM] = _uintConfigs[33];
4664         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN] = _uintConfigs[34];
4665         uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR] = _uintConfigs[35];
4666         uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR] = _uintConfigs[36];
4667         uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT] = _uintConfigs[37];
4668         uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR] = _uintConfigs[38];
4669         uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR] = _uintConfigs[39];
4670         uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM] = _uintConfigs[40];
4671         uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN] = _uintConfigs[41];
4672         uintConfigs[CONFIG_DRAFT_VOTING_PHASE] = _uintConfigs[42];
4673         uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE] = _uintConfigs[43];
4674         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR] = _uintConfigs[44];
4675         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[45];
4676         uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION] = _uintConfigs[46];
4677         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM] = _uintConfigs[47];
4678         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN] = _uintConfigs[48];
4679         uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE] = _uintConfigs[49];
4680         uintConfigs[CONFIG_MINIMUM_LOCKED_DGD] = _uintConfigs[50];
4681         uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR] = _uintConfigs[51];
4682         uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR] = _uintConfigs[52];
4683         uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL] = _uintConfigs[53];
4684         uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX] = _uintConfigs[54];
4685         uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX] = _uintConfigs[55];
4686         uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER] = _uintConfigs[56];
4687         uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION] = _uintConfigs[57];
4688         uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS] = _uintConfigs[58];
4689     }
4690 
4691     function readUintConfigs()
4692         public
4693         view
4694         returns (uint256[])
4695     {
4696         uint256[] memory _uintConfigs = new uint256[](59);
4697         _uintConfigs[0] = uintConfigs[CONFIG_LOCKING_PHASE_DURATION];
4698         _uintConfigs[1] = uintConfigs[CONFIG_QUARTER_DURATION];
4699         _uintConfigs[2] = uintConfigs[CONFIG_VOTING_COMMIT_PHASE];
4700         _uintConfigs[3] = uintConfigs[CONFIG_VOTING_PHASE_TOTAL];
4701         _uintConfigs[4] = uintConfigs[CONFIG_INTERIM_COMMIT_PHASE];
4702         _uintConfigs[5] = uintConfigs[CONFIG_INTERIM_PHASE_TOTAL];
4703         _uintConfigs[6] = uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR];
4704         _uintConfigs[7] = uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR];
4705         _uintConfigs[8] = uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR];
4706         _uintConfigs[9] = uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR];
4707         _uintConfigs[10] = uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR];
4708         _uintConfigs[11] = uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR];
4709         _uintConfigs[12] = uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR];
4710         _uintConfigs[13] = uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR];
4711         _uintConfigs[14] = uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR];
4712         _uintConfigs[15] = uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR];
4713         _uintConfigs[16] = uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR];
4714         _uintConfigs[17] = uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR];
4715         _uintConfigs[18] = uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE];
4716         _uintConfigs[19] = uintConfigs[CONFIG_QUARTER_POINT_VOTE];
4717         _uintConfigs[20] = uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE];
4718         _uintConfigs[21] = uintConfigs[CONFIG_MINIMAL_QUARTER_POINT];
4719         _uintConfigs[22] = uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH];
4720         _uintConfigs[23] = uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR];
4721         _uintConfigs[24] = uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR];
4722         _uintConfigs[25] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE];
4723         _uintConfigs[26] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL];
4724         _uintConfigs[27] = uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR];
4725         _uintConfigs[28] = uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR];
4726         _uintConfigs[29] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR];
4727         _uintConfigs[30] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR];
4728         _uintConfigs[31] = uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION];
4729         _uintConfigs[32] = uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING];
4730         _uintConfigs[33] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM];
4731         _uintConfigs[34] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN];
4732         _uintConfigs[35] = uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR];
4733         _uintConfigs[36] = uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR];
4734         _uintConfigs[37] = uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT];
4735         _uintConfigs[38] = uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR];
4736         _uintConfigs[39] = uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR];
4737         _uintConfigs[40] = uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM];
4738         _uintConfigs[41] = uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN];
4739         _uintConfigs[42] = uintConfigs[CONFIG_DRAFT_VOTING_PHASE];
4740         _uintConfigs[43] = uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE];
4741         _uintConfigs[44] = uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR];
4742         _uintConfigs[45] = uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR];
4743         _uintConfigs[46] = uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION];
4744         _uintConfigs[47] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM];
4745         _uintConfigs[48] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN];
4746         _uintConfigs[49] = uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE];
4747         _uintConfigs[50] = uintConfigs[CONFIG_MINIMUM_LOCKED_DGD];
4748         _uintConfigs[51] = uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR];
4749         _uintConfigs[52] = uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR];
4750         _uintConfigs[53] = uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL];
4751         _uintConfigs[54] = uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX];
4752         _uintConfigs[55] = uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX];
4753         _uintConfigs[56] = uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER];
4754         _uintConfigs[57] = uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION];
4755         _uintConfigs[58] = uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS];
4756         return _uintConfigs;
4757     }
4758 }
4759 
4760 // File: contracts/storage/DaoProposalCounterStorage.sol
4761 contract DaoProposalCounterStorage is ResolverClient, DaoConstants {
4762 
4763     constructor(address _resolver) public {
4764         require(init(CONTRACT_STORAGE_DAO_COUNTER, _resolver));
4765     }
4766 
4767     // This is to mark the number of proposals that have been funded in a specific quarter
4768     // this is to take care of the cap on the number of funded proposals in a quarter
4769     mapping (uint256 => uint256) public proposalCountByQuarter;
4770 
4771     function addNonDigixProposalCountInQuarter(uint256 _quarterNumber)
4772         public
4773     {
4774         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
4775         proposalCountByQuarter[_quarterNumber] = proposalCountByQuarter[_quarterNumber].add(1);
4776     }
4777 }
4778 
4779 // File: contracts/storage/DaoUpgradeStorage.sol
4780 contract DaoUpgradeStorage is ResolverClient, DaoConstants {
4781 
4782     // this UTC timestamp marks the start of the first quarter
4783     // of DigixDAO. All time related calculations in DaoCommon
4784     // depend on this value
4785     uint256 public startOfFirstQuarter;
4786 
4787     // this boolean marks whether the DAO contracts have been replaced
4788     // by newer versions or not. The process of migration is done by deploying
4789     // a new set of contracts, transferring funds from these contracts to the new ones
4790     // migrating some state variables, and finally setting this boolean to true
4791     // All operations in these contracts that may transfer tokens, claim ether,
4792     // boost one's reputation, etc. SHOULD fail if this is true
4793     bool public isReplacedByNewDao;
4794 
4795     // this is the address of the new Dao contract
4796     address public newDaoContract;
4797 
4798     // this is the address of the new DaoFundingManager contract
4799     // ether funds will be moved from the current version's contract to this
4800     // new contract
4801     address public newDaoFundingManager;
4802 
4803     // this is the address of the new DaoRewardsManager contract
4804     // DGX funds will be moved from the current version of contract to this
4805     // new contract
4806     address public newDaoRewardsManager;
4807 
4808     constructor(address _resolver) public {
4809         require(init(CONTRACT_STORAGE_DAO_UPGRADE, _resolver));
4810     }
4811 
4812     function setStartOfFirstQuarter(uint256 _start)
4813         public
4814     {
4815         require(sender_is(CONTRACT_DAO));
4816         startOfFirstQuarter = _start;
4817     }
4818 
4819 
4820     function setNewContractAddresses(
4821         address _newDaoContract,
4822         address _newDaoFundingManager,
4823         address _newDaoRewardsManager
4824     )
4825         public
4826     {
4827         require(sender_is(CONTRACT_DAO));
4828         newDaoContract = _newDaoContract;
4829         newDaoFundingManager = _newDaoFundingManager;
4830         newDaoRewardsManager = _newDaoRewardsManager;
4831     }
4832 
4833 
4834     function updateForDaoMigration()
4835         public
4836     {
4837         require(sender_is(CONTRACT_DAO));
4838         isReplacedByNewDao = true;
4839     }
4840 }
4841 
4842 // File: contracts/storage/DaoSpecialStorage.sol
4843 contract DaoSpecialStorage is DaoWhitelistingCommon {
4844     using DoublyLinkedList for DoublyLinkedList.Bytes;
4845     using DaoStructs for DaoStructs.SpecialProposal;
4846     using DaoStructs for DaoStructs.Voting;
4847 
4848     // List of all the special proposals ever created in DigixDAO
4849     DoublyLinkedList.Bytes proposals;
4850 
4851     // mapping of the SpecialProposal struct by its ID
4852     // ID is also the IPFS doc hash of the proposal
4853     mapping (bytes32 => DaoStructs.SpecialProposal) proposalsById;
4854 
4855     constructor(address _resolver) public {
4856         require(init(CONTRACT_STORAGE_DAO_SPECIAL, _resolver));
4857     }
4858 
4859     function addSpecialProposal(
4860         bytes32 _proposalId,
4861         address _proposer,
4862         uint256[] _uintConfigs,
4863         address[] _addressConfigs,
4864         bytes32[] _bytesConfigs
4865     )
4866         public
4867     {
4868         require(sender_is(CONTRACT_DAO_SPECIAL_PROPOSAL));
4869         require(
4870           (proposalsById[_proposalId].proposalId == EMPTY_BYTES) &&
4871           (_proposalId != EMPTY_BYTES)
4872         );
4873         proposals.append(_proposalId);
4874         proposalsById[_proposalId].proposalId = _proposalId;
4875         proposalsById[_proposalId].proposer = _proposer;
4876         proposalsById[_proposalId].timeCreated = now;
4877         proposalsById[_proposalId].uintConfigs = _uintConfigs;
4878         proposalsById[_proposalId].addressConfigs = _addressConfigs;
4879         proposalsById[_proposalId].bytesConfigs = _bytesConfigs;
4880     }
4881 
4882     function readProposal(bytes32 _proposalId)
4883         public
4884         view
4885         returns (
4886             bytes32 _id,
4887             address _proposer,
4888             uint256 _timeCreated,
4889             uint256 _timeVotingStarted
4890         )
4891     {
4892         _id = proposalsById[_proposalId].proposalId;
4893         _proposer = proposalsById[_proposalId].proposer;
4894         _timeCreated = proposalsById[_proposalId].timeCreated;
4895         _timeVotingStarted = proposalsById[_proposalId].voting.startTime;
4896     }
4897 
4898     function readProposalProposer(bytes32 _proposalId)
4899         public
4900         view
4901         returns (address _proposer)
4902     {
4903         _proposer = proposalsById[_proposalId].proposer;
4904     }
4905 
4906     function readConfigs(bytes32 _proposalId)
4907         public
4908         view
4909         returns (
4910             uint256[] memory _uintConfigs,
4911             address[] memory _addressConfigs,
4912             bytes32[] memory _bytesConfigs
4913         )
4914     {
4915         _uintConfigs = proposalsById[_proposalId].uintConfigs;
4916         _addressConfigs = proposalsById[_proposalId].addressConfigs;
4917         _bytesConfigs = proposalsById[_proposalId].bytesConfigs;
4918     }
4919 
4920     function readVotingCount(bytes32 _proposalId, address[] _allUsers)
4921         external
4922         view
4923         returns (uint256 _for, uint256 _against)
4924     {
4925         require(senderIsAllowedToRead());
4926         return proposalsById[_proposalId].voting.countVotes(_allUsers);
4927     }
4928 
4929     function readVotingTime(bytes32 _proposalId)
4930         public
4931         view
4932         returns (uint256 _start)
4933     {
4934         require(senderIsAllowedToRead());
4935         _start = proposalsById[_proposalId].voting.startTime;
4936     }
4937 
4938     function commitVote(
4939         bytes32 _proposalId,
4940         bytes32 _hash,
4941         address _voter
4942     )
4943         public
4944     {
4945         require(sender_is(CONTRACT_DAO_VOTING));
4946         proposalsById[_proposalId].voting.commits[_voter] = _hash;
4947     }
4948 
4949     function readComittedVote(bytes32 _proposalId, address _voter)
4950         public
4951         view
4952         returns (bytes32 _commitHash)
4953     {
4954         require(senderIsAllowedToRead());
4955         _commitHash = proposalsById[_proposalId].voting.commits[_voter];
4956     }
4957 
4958     function setVotingTime(bytes32 _proposalId, uint256 _time)
4959         public
4960     {
4961         require(sender_is(CONTRACT_DAO_SPECIAL_PROPOSAL));
4962         proposalsById[_proposalId].voting.startTime = _time;
4963     }
4964 
4965     function readVotingResult(bytes32 _proposalId)
4966         public
4967         view
4968         returns (bool _result)
4969     {
4970         require(senderIsAllowedToRead());
4971         _result = proposalsById[_proposalId].voting.passed;
4972     }
4973 
4974     function setPass(bytes32 _proposalId, bool _result)
4975         public
4976     {
4977         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
4978         proposalsById[_proposalId].voting.passed = _result;
4979     }
4980 
4981     function setVotingClaim(bytes32 _proposalId, bool _claimed)
4982         public
4983     {
4984         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
4985         DaoStructs.SpecialProposal storage _proposal = proposalsById[_proposalId];
4986         _proposal.voting.claimed = _claimed;
4987     }
4988 
4989     function isClaimed(bytes32 _proposalId)
4990         public
4991         view
4992         returns (bool _claimed)
4993     {
4994         require(senderIsAllowedToRead());
4995         _claimed = proposalsById[_proposalId].voting.claimed;
4996     }
4997 
4998     function readVote(bytes32 _proposalId, address _voter)
4999         public
5000         view
5001         returns (bool _vote, uint256 _weight)
5002     {
5003         require(senderIsAllowedToRead());
5004         return proposalsById[_proposalId].voting.readVote(_voter);
5005     }
5006 
5007     function revealVote(
5008         bytes32 _proposalId,
5009         address _voter,
5010         bool _vote,
5011         uint256 _weight
5012     )
5013         public
5014     {
5015         require(sender_is(CONTRACT_DAO_VOTING));
5016         proposalsById[_proposalId].voting.revealVote(_voter, _vote, _weight);
5017     }
5018 }
5019 
5020 // File: contracts/storage/DaoPointsStorage.sol
5021 contract DaoPointsStorage is ResolverClient, DaoConstants {
5022 
5023     // struct for a non-transferrable token
5024     struct Token {
5025         uint256 totalSupply;
5026         mapping (address => uint256) balance;
5027     }
5028 
5029     // the reputation point token
5030     // since reputation is cumulative, we only need to store one value
5031     Token reputationPoint;
5032 
5033     // since quarter points are specific to quarters, we need a mapping from
5034     // quarter number to the quarter point token for that quarter
5035     mapping (uint256 => Token) quarterPoint;
5036 
5037     // the same is the case with quarter moderator points
5038     // these are specific to quarters
5039     mapping (uint256 => Token) quarterModeratorPoint;
5040 
5041     constructor(address _resolver)
5042         public
5043     {
5044         require(init(CONTRACT_STORAGE_DAO_POINTS, _resolver));
5045     }
5046 
5047     /// @notice add quarter points for a _participant for a _quarterNumber
5048     function addQuarterPoint(address _participant, uint256 _point, uint256 _quarterNumber)
5049         public
5050         returns (uint256 _newPoint, uint256 _newTotalPoint)
5051     {
5052         require(sender_is_from([CONTRACT_DAO_VOTING, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
5053         quarterPoint[_quarterNumber].totalSupply = quarterPoint[_quarterNumber].totalSupply.add(_point);
5054         quarterPoint[_quarterNumber].balance[_participant] = quarterPoint[_quarterNumber].balance[_participant].add(_point);
5055 
5056         _newPoint = quarterPoint[_quarterNumber].balance[_participant];
5057         _newTotalPoint = quarterPoint[_quarterNumber].totalSupply;
5058     }
5059 
5060     function addModeratorQuarterPoint(address _participant, uint256 _point, uint256 _quarterNumber)
5061         public
5062         returns (uint256 _newPoint, uint256 _newTotalPoint)
5063     {
5064         require(sender_is_from([CONTRACT_DAO_VOTING, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
5065         quarterModeratorPoint[_quarterNumber].totalSupply = quarterModeratorPoint[_quarterNumber].totalSupply.add(_point);
5066         quarterModeratorPoint[_quarterNumber].balance[_participant] = quarterModeratorPoint[_quarterNumber].balance[_participant].add(_point);
5067 
5068         _newPoint = quarterModeratorPoint[_quarterNumber].balance[_participant];
5069         _newTotalPoint = quarterModeratorPoint[_quarterNumber].totalSupply;
5070     }
5071 
5072     /// @notice get quarter points for a _participant in a _quarterNumber
5073     function getQuarterPoint(address _participant, uint256 _quarterNumber)
5074         public
5075         view
5076         returns (uint256 _point)
5077     {
5078         _point = quarterPoint[_quarterNumber].balance[_participant];
5079     }
5080 
5081     function getQuarterModeratorPoint(address _participant, uint256 _quarterNumber)
5082         public
5083         view
5084         returns (uint256 _point)
5085     {
5086         _point = quarterModeratorPoint[_quarterNumber].balance[_participant];
5087     }
5088 
5089     /// @notice get total quarter points for a particular _quarterNumber
5090     function getTotalQuarterPoint(uint256 _quarterNumber)
5091         public
5092         view
5093         returns (uint256 _totalPoint)
5094     {
5095         _totalPoint = quarterPoint[_quarterNumber].totalSupply;
5096     }
5097 
5098     function getTotalQuarterModeratorPoint(uint256 _quarterNumber)
5099         public
5100         view
5101         returns (uint256 _totalPoint)
5102     {
5103         _totalPoint = quarterModeratorPoint[_quarterNumber].totalSupply;
5104     }
5105 
5106     /// @notice add reputation points for a _participant
5107     function increaseReputation(address _participant, uint256 _point)
5108         public
5109         returns (uint256 _newPoint, uint256 _totalPoint)
5110     {
5111         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING]));
5112         reputationPoint.totalSupply = reputationPoint.totalSupply.add(_point);
5113         reputationPoint.balance[_participant] = reputationPoint.balance[_participant].add(_point);
5114 
5115         _newPoint = reputationPoint.balance[_participant];
5116         _totalPoint = reputationPoint.totalSupply;
5117     }
5118 
5119     /// @notice subtract reputation points for a _participant
5120     function reduceReputation(address _participant, uint256 _point)
5121         public
5122         returns (uint256 _newPoint, uint256 _totalPoint)
5123     {
5124         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
5125         uint256 _toDeduct = _point;
5126         if (reputationPoint.balance[_participant] > _point) {
5127             reputationPoint.balance[_participant] = reputationPoint.balance[_participant].sub(_point);
5128         } else {
5129             _toDeduct = reputationPoint.balance[_participant];
5130             reputationPoint.balance[_participant] = 0;
5131         }
5132 
5133         reputationPoint.totalSupply = reputationPoint.totalSupply.sub(_toDeduct);
5134 
5135         _newPoint = reputationPoint.balance[_participant];
5136         _totalPoint = reputationPoint.totalSupply;
5137     }
5138 
5139   /// @notice get reputation points for a _participant
5140   function getReputation(address _participant)
5141       public
5142       view
5143       returns (uint256 _point)
5144   {
5145       _point = reputationPoint.balance[_participant];
5146   }
5147 
5148   /// @notice get total reputation points distributed in the dao
5149   function getTotalReputation()
5150       public
5151       view
5152       returns (uint256 _totalPoint)
5153   {
5154       _totalPoint = reputationPoint.totalSupply;
5155   }
5156 }
5157 
5158 // File: contracts/storage/DaoRewardsStorage.sol
5159 // this contract will receive DGXs fees from the DGX fees distributors
5160 contract DaoRewardsStorage is ResolverClient, DaoConstants {
5161     using DaoStructs for DaoStructs.DaoQuarterInfo;
5162 
5163     // DaoQuarterInfo is a struct that stores the quarter specific information
5164     // regarding totalEffectiveDGDs, DGX distribution day, etc. pls check
5165     // docs in lib/DaoStructs
5166     mapping(uint256 => DaoStructs.DaoQuarterInfo) public allQuartersInfo;
5167 
5168     // Mapping that stores the DGX that can be claimed as rewards by
5169     // an address (a participant of DigixDAO)
5170     mapping(address => uint256) public claimableDGXs;
5171 
5172     // This stores the total DGX value that has been claimed by participants
5173     // this can be done by calling the DaoRewardsManager.claimRewards method
5174     // Note that this value is the only outgoing DGX from DaoRewardsManager contract
5175     // Note that this value also takes into account the demurrage that has been paid
5176     // by participants for simply holding their DGXs in the DaoRewardsManager contract
5177     uint256 public totalDGXsClaimed;
5178 
5179     // The Quarter ID in which the user last participated in
5180     // To participate means they had locked more than CONFIG_MINIMUM_LOCKED_DGD
5181     // DGD tokens. In addition, they should not have withdrawn those tokens in the same
5182     // quarter. Basically, in the main phase of the quarter, if DaoCommon.isParticipant(_user)
5183     // was true, they were participants. And that quarter was their lastParticipatedQuarter
5184     mapping (address => uint256) public lastParticipatedQuarter;
5185 
5186     // This mapping is only used to update the lastParticipatedQuarter to the
5187     // previousLastParticipatedQuarter in case users lock and withdraw DGDs
5188     // within the same quarter's locking phase
5189     mapping (address => uint256) public previousLastParticipatedQuarter;
5190 
5191     // This number marks the Quarter in which the rewards were last updated for that user
5192     // Since the rewards calculation for a specific quarter is only done once that
5193     // quarter is completed, we need this value to note the last quarter when the rewards were updated
5194     // We then start adding the rewards for all quarters after that quarter, until the current quarter
5195     mapping (address => uint256) public lastQuarterThatRewardsWasUpdated;
5196 
5197     // Similar as the lastQuarterThatRewardsWasUpdated, but this is for reputation updates
5198     // Note that reputation can also be deducted for no participation (not locking DGDs)
5199     // This value is used to update the reputation based on all quarters from the lastQuarterThatReputationWasUpdated
5200     // to the current quarter
5201     mapping (address => uint256) public lastQuarterThatReputationWasUpdated;
5202 
5203     constructor(address _resolver)
5204            public
5205     {
5206         require(init(CONTRACT_STORAGE_DAO_REWARDS, _resolver));
5207     }
5208 
5209     function updateQuarterInfo(
5210         uint256 _quarterNumber,
5211         uint256 _minimalParticipationPoint,
5212         uint256 _quarterPointScalingFactor,
5213         uint256 _reputationPointScalingFactor,
5214         uint256 _totalEffectiveDGDPreviousQuarter,
5215 
5216         uint256 _moderatorMinimalQuarterPoint,
5217         uint256 _moderatorQuarterPointScalingFactor,
5218         uint256 _moderatorReputationPointScalingFactor,
5219         uint256 _totalEffectiveModeratorDGDLastQuarter,
5220 
5221         uint256 _dgxDistributionDay,
5222         uint256 _dgxRewardsPoolLastQuarter,
5223         uint256 _sumRewardsFromBeginning
5224     )
5225         public
5226     {
5227         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5228         allQuartersInfo[_quarterNumber].minimalParticipationPoint = _minimalParticipationPoint;
5229         allQuartersInfo[_quarterNumber].quarterPointScalingFactor = _quarterPointScalingFactor;
5230         allQuartersInfo[_quarterNumber].reputationPointScalingFactor = _reputationPointScalingFactor;
5231         allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter = _totalEffectiveDGDPreviousQuarter;
5232 
5233         allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint = _moderatorMinimalQuarterPoint;
5234         allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor = _moderatorQuarterPointScalingFactor;
5235         allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor = _moderatorReputationPointScalingFactor;
5236         allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter = _totalEffectiveModeratorDGDLastQuarter;
5237 
5238         allQuartersInfo[_quarterNumber].dgxDistributionDay = _dgxDistributionDay;
5239         allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter = _dgxRewardsPoolLastQuarter;
5240         allQuartersInfo[_quarterNumber].sumRewardsFromBeginning = _sumRewardsFromBeginning;
5241     }
5242 
5243     function updateClaimableDGX(address _user, uint256 _newClaimableDGX)
5244         public
5245     {
5246         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5247         claimableDGXs[_user] = _newClaimableDGX;
5248     }
5249 
5250     function updateLastParticipatedQuarter(address _user, uint256 _lastQuarter)
5251         public
5252     {
5253         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
5254         lastParticipatedQuarter[_user] = _lastQuarter;
5255     }
5256 
5257     function updatePreviousLastParticipatedQuarter(address _user, uint256 _lastQuarter)
5258         public
5259     {
5260         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
5261         previousLastParticipatedQuarter[_user] = _lastQuarter;
5262     }
5263 
5264     function updateLastQuarterThatRewardsWasUpdated(address _user, uint256 _lastQuarter)
5265         public
5266     {
5267         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING, EMPTY_BYTES]));
5268         lastQuarterThatRewardsWasUpdated[_user] = _lastQuarter;
5269     }
5270 
5271     function updateLastQuarterThatReputationWasUpdated(address _user, uint256 _lastQuarter)
5272         public
5273     {
5274         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING, EMPTY_BYTES]));
5275         lastQuarterThatReputationWasUpdated[_user] = _lastQuarter;
5276     }
5277 
5278     function addToTotalDgxClaimed(uint256 _dgxClaimed)
5279         public
5280     {
5281         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5282         totalDGXsClaimed = totalDGXsClaimed.add(_dgxClaimed);
5283     }
5284 
5285     function readQuarterInfo(uint256 _quarterNumber)
5286         public
5287         view
5288         returns (
5289             uint256 _minimalParticipationPoint,
5290             uint256 _quarterPointScalingFactor,
5291             uint256 _reputationPointScalingFactor,
5292             uint256 _totalEffectiveDGDPreviousQuarter,
5293 
5294             uint256 _moderatorMinimalQuarterPoint,
5295             uint256 _moderatorQuarterPointScalingFactor,
5296             uint256 _moderatorReputationPointScalingFactor,
5297             uint256 _totalEffectiveModeratorDGDLastQuarter,
5298 
5299             uint256 _dgxDistributionDay,
5300             uint256 _dgxRewardsPoolLastQuarter,
5301             uint256 _sumRewardsFromBeginning
5302         )
5303     {
5304         _minimalParticipationPoint = allQuartersInfo[_quarterNumber].minimalParticipationPoint;
5305         _quarterPointScalingFactor = allQuartersInfo[_quarterNumber].quarterPointScalingFactor;
5306         _reputationPointScalingFactor = allQuartersInfo[_quarterNumber].reputationPointScalingFactor;
5307         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5308         _moderatorMinimalQuarterPoint = allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint;
5309         _moderatorQuarterPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor;
5310         _moderatorReputationPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor;
5311         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5312         _dgxDistributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5313         _dgxRewardsPoolLastQuarter = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5314         _sumRewardsFromBeginning = allQuartersInfo[_quarterNumber].sumRewardsFromBeginning;
5315     }
5316 
5317     function readQuarterGeneralInfo(uint256 _quarterNumber)
5318         public
5319         view
5320         returns (
5321             uint256 _dgxDistributionDay,
5322             uint256 _dgxRewardsPoolLastQuarter,
5323             uint256 _sumRewardsFromBeginning
5324         )
5325     {
5326         _dgxDistributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5327         _dgxRewardsPoolLastQuarter = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5328         _sumRewardsFromBeginning = allQuartersInfo[_quarterNumber].sumRewardsFromBeginning;
5329     }
5330 
5331     function readQuarterModeratorInfo(uint256 _quarterNumber)
5332         public
5333         view
5334         returns (
5335             uint256 _moderatorMinimalQuarterPoint,
5336             uint256 _moderatorQuarterPointScalingFactor,
5337             uint256 _moderatorReputationPointScalingFactor,
5338             uint256 _totalEffectiveModeratorDGDLastQuarter
5339         )
5340     {
5341         _moderatorMinimalQuarterPoint = allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint;
5342         _moderatorQuarterPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor;
5343         _moderatorReputationPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor;
5344         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5345     }
5346 
5347     function readQuarterParticipantInfo(uint256 _quarterNumber)
5348         public
5349         view
5350         returns (
5351             uint256 _minimalParticipationPoint,
5352             uint256 _quarterPointScalingFactor,
5353             uint256 _reputationPointScalingFactor,
5354             uint256 _totalEffectiveDGDPreviousQuarter
5355         )
5356     {
5357         _minimalParticipationPoint = allQuartersInfo[_quarterNumber].minimalParticipationPoint;
5358         _quarterPointScalingFactor = allQuartersInfo[_quarterNumber].quarterPointScalingFactor;
5359         _reputationPointScalingFactor = allQuartersInfo[_quarterNumber].reputationPointScalingFactor;
5360         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5361     }
5362 
5363     function readDgxDistributionDay(uint256 _quarterNumber)
5364         public
5365         view
5366         returns (uint256 _distributionDay)
5367     {
5368         _distributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5369     }
5370 
5371     function readTotalEffectiveDGDLastQuarter(uint256 _quarterNumber)
5372         public
5373         view
5374         returns (uint256 _totalEffectiveDGDPreviousQuarter)
5375     {
5376         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5377     }
5378 
5379     function readTotalEffectiveModeratorDGDLastQuarter(uint256 _quarterNumber)
5380         public
5381         view
5382         returns (uint256 _totalEffectiveModeratorDGDLastQuarter)
5383     {
5384         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5385     }
5386 
5387     function readRewardsPoolOfLastQuarter(uint256 _quarterNumber)
5388         public
5389         view
5390         returns (uint256 _rewardsPool)
5391     {
5392         _rewardsPool = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5393     }
5394 }
5395 
5396 // File: contracts/storage/IntermediateResultsStorage.sol
5397 contract IntermediateResultsStorage is ResolverClient, DaoConstants {
5398     using DaoStructs for DaoStructs.IntermediateResults;
5399 
5400     constructor(address _resolver) public {
5401         require(init(CONTRACT_STORAGE_INTERMEDIATE_RESULTS, _resolver));
5402     }
5403 
5404     // There are scenarios in which we must loop across all participants/moderators
5405     // in a function call. For a big number of operations, the function call may be short of gas
5406     // To tackle this, we use an IntermediateResults struct to store the intermediate results
5407     // The same function is then called multiple times until all operations are completed
5408     // If the operations cannot be done in that iteration, the intermediate results are stored
5409     // else, the final outcome is returned
5410     // Please check the lib/DaoStructs for docs on this struct
5411     mapping (bytes32 => DaoStructs.IntermediateResults) allIntermediateResults;
5412 
5413     function getIntermediateResults(bytes32 _key)
5414         public
5415         view
5416         returns (
5417             address _countedUntil,
5418             uint256 _currentForCount,
5419             uint256 _currentAgainstCount,
5420             uint256 _currentSumOfEffectiveBalance
5421         )
5422     {
5423         _countedUntil = allIntermediateResults[_key].countedUntil;
5424         _currentForCount = allIntermediateResults[_key].currentForCount;
5425         _currentAgainstCount = allIntermediateResults[_key].currentAgainstCount;
5426         _currentSumOfEffectiveBalance = allIntermediateResults[_key].currentSumOfEffectiveBalance;
5427     }
5428 
5429     function resetIntermediateResults(bytes32 _key)
5430         public
5431     {
5432         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_SPECIAL_VOTING_CLAIMS]));
5433         allIntermediateResults[_key].countedUntil = address(0x0);
5434     }
5435 
5436     function setIntermediateResults(
5437         bytes32 _key,
5438         address _countedUntil,
5439         uint256 _currentForCount,
5440         uint256 _currentAgainstCount,
5441         uint256 _currentSumOfEffectiveBalance
5442     )
5443         public
5444     {
5445         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_SPECIAL_VOTING_CLAIMS]));
5446         allIntermediateResults[_key].countedUntil = _countedUntil;
5447         allIntermediateResults[_key].currentForCount = _currentForCount;
5448         allIntermediateResults[_key].currentAgainstCount = _currentAgainstCount;
5449         allIntermediateResults[_key].currentSumOfEffectiveBalance = _currentSumOfEffectiveBalance;
5450     }
5451 }
5452 
5453 // File: contracts/lib/MathHelper.sol
5454 library MathHelper {
5455 
5456   using SafeMath for uint256;
5457 
5458   function max(uint256 a, uint256 b) internal pure returns (uint256 _max){
5459       _max = b;
5460       if (a > b) {
5461           _max = a;
5462       }
5463   }
5464 
5465   function min(uint256 a, uint256 b) internal pure returns (uint256 _min){
5466       _min = b;
5467       if (a < b) {
5468           _min = a;
5469       }
5470   }
5471 
5472   function sumNumbers(uint256[] _numbers) internal pure returns (uint256 _sum) {
5473       for (uint256 i=0;i<_numbers.length;i++) {
5474           _sum = _sum.add(_numbers[i]);
5475       }
5476   }
5477 }
5478 
5479 // File: contracts/common/DaoCommonMini.sol
5480 contract DaoCommonMini is IdentityCommon {
5481 
5482     using MathHelper for MathHelper;
5483 
5484     /**
5485     @notice Check if the DAO contracts have been replaced by a new set of contracts
5486     @return _isNotReplaced true if it is not replaced, false if it has already been replaced
5487     */
5488     function isDaoNotReplaced()
5489         public
5490         view
5491         returns (bool _isNotReplaced)
5492     {
5493         _isNotReplaced = !daoUpgradeStorage().isReplacedByNewDao();
5494     }
5495 
5496     /**
5497     @notice Check if it is currently in the locking phase
5498     @dev No governance activities can happen in the locking phase. The locking phase is from t=0 to t=CONFIG_LOCKING_PHASE_DURATION-1
5499     @return _isLockingPhase true if it is in the locking phase
5500     */
5501     function isLockingPhase()
5502         public
5503         view
5504         returns (bool _isLockingPhase)
5505     {
5506         _isLockingPhase = currentTimeInQuarter() < getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
5507     }
5508 
5509     /**
5510     @notice Check if it is currently in a main phase.
5511     @dev The main phase is where all the governance activities could take plase. If the DAO is replaced, there can never be any more main phase.
5512     @return _isMainPhase true if it is in a main phase
5513     */
5514     function isMainPhase()
5515         public
5516         view
5517         returns (bool _isMainPhase)
5518     {
5519         _isMainPhase =
5520             isDaoNotReplaced() &&
5521             currentTimeInQuarter() >= getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
5522     }
5523 
5524     /**
5525     @notice Check if the calculateGlobalRewardsBeforeNewQuarter function has been done for a certain quarter
5526     @dev However, there is no need to run calculateGlobalRewardsBeforeNewQuarter for the first quarter
5527     */
5528     modifier ifGlobalRewardsSet(uint256 _quarterNumber) {
5529         if (_quarterNumber > 1) {
5530             require(daoRewardsStorage().readDgxDistributionDay(_quarterNumber) > 0);
5531         }
5532         _;
5533     }
5534 
5535     /**
5536     @notice require that it is currently during a phase, which is within _relativePhaseStart and _relativePhaseEnd seconds, after the _startingPoint
5537     */
5538     function requireInPhase(uint256 _startingPoint, uint256 _relativePhaseStart, uint256 _relativePhaseEnd)
5539         internal
5540         view
5541     {
5542         require(_startingPoint > 0);
5543         require(now < _startingPoint.add(_relativePhaseEnd));
5544         require(now >= _startingPoint.add(_relativePhaseStart));
5545     }
5546 
5547     /**
5548     @notice Get the current quarter index
5549     @dev Quarter indexes starts from 1
5550     @return _quarterNumber the current quarter index
5551     */
5552     function currentQuarterNumber()
5553         public
5554         view
5555         returns(uint256 _quarterNumber)
5556     {
5557         _quarterNumber = getQuarterNumber(now);
5558     }
5559 
5560     /**
5561     @notice Get the quarter index of a timestamp
5562     @dev Quarter indexes starts from 1
5563     @return _index the quarter index
5564     */
5565     function getQuarterNumber(uint256 _time)
5566         internal
5567         view
5568         returns (uint256 _index)
5569     {
5570         require(startOfFirstQuarterIsSet());
5571         _index =
5572             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
5573             .div(getUintConfig(CONFIG_QUARTER_DURATION))
5574             .add(1);
5575     }
5576 
5577     /**
5578     @notice Get the relative time in quarter of a timestamp
5579     @dev For example, the timeInQuarter of the first second of any quarter n-th is always 1
5580     */
5581     function timeInQuarter(uint256 _time)
5582         internal
5583         view
5584         returns (uint256 _timeInQuarter)
5585     {
5586         require(startOfFirstQuarterIsSet()); // must be already set
5587         _timeInQuarter =
5588             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
5589             % getUintConfig(CONFIG_QUARTER_DURATION);
5590     }
5591 
5592     /**
5593     @notice Check if the start of first quarter is already set
5594     @return _isSet true if start of first quarter is already set
5595     */
5596     function startOfFirstQuarterIsSet()
5597         internal
5598         view
5599         returns (bool _isSet)
5600     {
5601         _isSet = daoUpgradeStorage().startOfFirstQuarter() != 0;
5602     }
5603 
5604     /**
5605     @notice Get the current relative time in the quarter
5606     @dev For example: the currentTimeInQuarter of the first second of any quarter is 1
5607     @return _currentT the current relative time in the quarter
5608     */
5609     function currentTimeInQuarter()
5610         public
5611         view
5612         returns (uint256 _currentT)
5613     {
5614         _currentT = timeInQuarter(now);
5615     }
5616 
5617     /**
5618     @notice Get the time remaining in the quarter
5619     */
5620     function getTimeLeftInQuarter(uint256 _time)
5621         internal
5622         view
5623         returns (uint256 _timeLeftInQuarter)
5624     {
5625         _timeLeftInQuarter = getUintConfig(CONFIG_QUARTER_DURATION).sub(timeInQuarter(_time));
5626     }
5627 
5628     function daoListingService()
5629         internal
5630         view
5631         returns (DaoListingService _contract)
5632     {
5633         _contract = DaoListingService(get_contract(CONTRACT_SERVICE_DAO_LISTING));
5634     }
5635 
5636     function daoConfigsStorage()
5637         internal
5638         view
5639         returns (DaoConfigsStorage _contract)
5640     {
5641         _contract = DaoConfigsStorage(get_contract(CONTRACT_STORAGE_DAO_CONFIG));
5642     }
5643 
5644     function daoStakeStorage()
5645         internal
5646         view
5647         returns (DaoStakeStorage _contract)
5648     {
5649         _contract = DaoStakeStorage(get_contract(CONTRACT_STORAGE_DAO_STAKE));
5650     }
5651 
5652     function daoStorage()
5653         internal
5654         view
5655         returns (DaoStorage _contract)
5656     {
5657         _contract = DaoStorage(get_contract(CONTRACT_STORAGE_DAO));
5658     }
5659 
5660     function daoProposalCounterStorage()
5661         internal
5662         view
5663         returns (DaoProposalCounterStorage _contract)
5664     {
5665         _contract = DaoProposalCounterStorage(get_contract(CONTRACT_STORAGE_DAO_COUNTER));
5666     }
5667 
5668     function daoUpgradeStorage()
5669         internal
5670         view
5671         returns (DaoUpgradeStorage _contract)
5672     {
5673         _contract = DaoUpgradeStorage(get_contract(CONTRACT_STORAGE_DAO_UPGRADE));
5674     }
5675 
5676     function daoSpecialStorage()
5677         internal
5678         view
5679         returns (DaoSpecialStorage _contract)
5680     {
5681         _contract = DaoSpecialStorage(get_contract(CONTRACT_STORAGE_DAO_SPECIAL));
5682     }
5683 
5684     function daoPointsStorage()
5685         internal
5686         view
5687         returns (DaoPointsStorage _contract)
5688     {
5689         _contract = DaoPointsStorage(get_contract(CONTRACT_STORAGE_DAO_POINTS));
5690     }
5691 
5692     function daoRewardsStorage()
5693         internal
5694         view
5695         returns (DaoRewardsStorage _contract)
5696     {
5697         _contract = DaoRewardsStorage(get_contract(CONTRACT_STORAGE_DAO_REWARDS));
5698     }
5699 
5700     function intermediateResultsStorage()
5701         internal
5702         view
5703         returns (IntermediateResultsStorage _contract)
5704     {
5705         _contract = IntermediateResultsStorage(get_contract(CONTRACT_STORAGE_INTERMEDIATE_RESULTS));
5706     }
5707 
5708     function getUintConfig(bytes32 _configKey)
5709         public
5710         view
5711         returns (uint256 _configValue)
5712     {
5713         _configValue = daoConfigsStorage().uintConfigs(_configKey);
5714     }
5715 }
5716 
5717 // File: contracts/common/DaoCommon.sol
5718 contract DaoCommon is DaoCommonMini {
5719 
5720     using MathHelper for MathHelper;
5721 
5722     /**
5723     @notice Check if the transaction is called by the proposer of a proposal
5724     @return _isFromProposer true if the caller is the proposer
5725     */
5726     function isFromProposer(bytes32 _proposalId)
5727         internal
5728         view
5729         returns (bool _isFromProposer)
5730     {
5731         _isFromProposer = msg.sender == daoStorage().readProposalProposer(_proposalId);
5732     }
5733 
5734     /**
5735     @notice Check if the proposal can still be "editted", or in other words, added more versions
5736     @dev Once the proposal is finalized, it can no longer be editted. The proposer will still be able to add docs and change fundings though.
5737     @return _isEditable true if the proposal is editable
5738     */
5739     function isEditable(bytes32 _proposalId)
5740         internal
5741         view
5742         returns (bool _isEditable)
5743     {
5744         bytes32 _finalVersion;
5745         (,,,,,,,_finalVersion,,) = daoStorage().readProposal(_proposalId);
5746         _isEditable = _finalVersion == EMPTY_BYTES;
5747     }
5748 
5749     /**
5750     @notice returns the balance of DaoFundingManager, which is the wei in DigixDAO
5751     */
5752     function weiInDao()
5753         internal
5754         view
5755         returns (uint256 _wei)
5756     {
5757         _wei = get_contract(CONTRACT_DAO_FUNDING_MANAGER).balance;
5758     }
5759 
5760     /**
5761     @notice Check if it is after the draft voting phase of the proposal
5762     */
5763     modifier ifAfterDraftVotingPhase(bytes32 _proposalId) {
5764         uint256 _start = daoStorage().readProposalDraftVotingTime(_proposalId);
5765         require(_start > 0); // Draft voting must have started. In other words, proposer must have finalized the proposal
5766         require(now >= _start.add(getUintConfig(CONFIG_DRAFT_VOTING_PHASE)));
5767         _;
5768     }
5769 
5770     modifier ifCommitPhase(bytes32 _proposalId, uint8 _index) {
5771         requireInPhase(
5772             daoStorage().readProposalVotingTime(_proposalId, _index),
5773             0,
5774             getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE)
5775         );
5776         _;
5777     }
5778 
5779     modifier ifRevealPhase(bytes32 _proposalId, uint256 _index) {
5780       requireInPhase(
5781           daoStorage().readProposalVotingTime(_proposalId, _index),
5782           getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE),
5783           getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)
5784       );
5785       _;
5786     }
5787 
5788     modifier ifAfterProposalRevealPhase(bytes32 _proposalId, uint256 _index) {
5789       uint256 _start = daoStorage().readProposalVotingTime(_proposalId, _index);
5790       require(_start > 0);
5791       require(now >= _start.add(getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)));
5792       _;
5793     }
5794 
5795     modifier ifDraftVotingPhase(bytes32 _proposalId) {
5796         requireInPhase(
5797             daoStorage().readProposalDraftVotingTime(_proposalId),
5798             0,
5799             getUintConfig(CONFIG_DRAFT_VOTING_PHASE)
5800         );
5801         _;
5802     }
5803 
5804     modifier isProposalState(bytes32 _proposalId, bytes32 _STATE) {
5805         bytes32 _currentState;
5806         (,,,_currentState,,,,,,) = daoStorage().readProposal(_proposalId);
5807         require(_currentState == _STATE);
5808         _;
5809     }
5810 
5811     modifier ifDraftNotClaimed(bytes32 _proposalId) {
5812         require(daoStorage().isDraftClaimed(_proposalId) == false);
5813         _;
5814     }
5815 
5816     modifier ifNotClaimed(bytes32 _proposalId, uint256 _index) {
5817         require(daoStorage().isClaimed(_proposalId, _index) == false);
5818         _;
5819     }
5820 
5821     modifier ifNotClaimedSpecial(bytes32 _proposalId) {
5822         require(daoSpecialStorage().isClaimed(_proposalId) == false);
5823         _;
5824     }
5825 
5826     modifier hasNotRevealed(bytes32 _proposalId, uint256 _index) {
5827         uint256 _voteWeight;
5828         (, _voteWeight) = daoStorage().readVote(_proposalId, _index, msg.sender);
5829         require(_voteWeight == uint(0));
5830         _;
5831     }
5832 
5833     modifier hasNotRevealedSpecial(bytes32 _proposalId) {
5834         uint256 _weight;
5835         (,_weight) = daoSpecialStorage().readVote(_proposalId, msg.sender);
5836         require(_weight == uint256(0));
5837         _;
5838     }
5839 
5840     modifier ifAfterRevealPhaseSpecial(bytes32 _proposalId) {
5841       uint256 _start = daoSpecialStorage().readVotingTime(_proposalId);
5842       require(_start > 0);
5843       require(now.sub(_start) >= getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL));
5844       _;
5845     }
5846 
5847     modifier ifCommitPhaseSpecial(bytes32 _proposalId) {
5848         requireInPhase(
5849             daoSpecialStorage().readVotingTime(_proposalId),
5850             0,
5851             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE)
5852         );
5853         _;
5854     }
5855 
5856     modifier ifRevealPhaseSpecial(bytes32 _proposalId) {
5857         requireInPhase(
5858             daoSpecialStorage().readVotingTime(_proposalId),
5859             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE),
5860             getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL)
5861         );
5862         _;
5863     }
5864 
5865     function daoWhitelistingStorage()
5866         internal
5867         view
5868         returns (DaoWhitelistingStorage _contract)
5869     {
5870         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
5871     }
5872 
5873     function getAddressConfig(bytes32 _configKey)
5874         public
5875         view
5876         returns (address _configValue)
5877     {
5878         _configValue = daoConfigsStorage().addressConfigs(_configKey);
5879     }
5880 
5881     function getBytesConfig(bytes32 _configKey)
5882         public
5883         view
5884         returns (bytes32 _configValue)
5885     {
5886         _configValue = daoConfigsStorage().bytesConfigs(_configKey);
5887     }
5888 
5889     /**
5890     @notice Check if a user is a participant in the current quarter
5891     */
5892     function isParticipant(address _user)
5893         public
5894         view
5895         returns (bool _is)
5896     {
5897         _is =
5898             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
5899             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_LOCKED_DGD));
5900     }
5901 
5902     /**
5903     @notice Check if a user is a moderator in the current quarter
5904     */
5905     function isModerator(address _user)
5906         public
5907         view
5908         returns (bool _is)
5909     {
5910         _is =
5911             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
5912             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_DGD_FOR_MODERATOR))
5913             && (daoPointsStorage().getReputation(_user) >= getUintConfig(CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR));
5914     }
5915 
5916     /**
5917     @notice Calculate the start of a specific milestone of a specific proposal.
5918     @dev This is calculated from the voting start of the voting round preceding the milestone
5919          This would throw if the voting start is 0 (the voting round has not started yet)
5920          Note that if the milestoneIndex is exactly the same as the number of milestones,
5921          This will just return the end of the last voting round.
5922     */
5923     function startOfMilestone(bytes32 _proposalId, uint256 _milestoneIndex)
5924         internal
5925         view
5926         returns (uint256 _milestoneStart)
5927     {
5928         uint256 _startOfPrecedingVotingRound = daoStorage().readProposalVotingTime(_proposalId, _milestoneIndex);
5929         require(_startOfPrecedingVotingRound > 0);
5930         // the preceding voting round must have started
5931 
5932         if (_milestoneIndex == 0) { // This is the 1st milestone, which starts after voting round 0
5933             _milestoneStart =
5934                 _startOfPrecedingVotingRound
5935                 .add(getUintConfig(CONFIG_VOTING_PHASE_TOTAL));
5936         } else { // if its the n-th milestone, it starts after voting round n-th
5937             _milestoneStart =
5938                 _startOfPrecedingVotingRound
5939                 .add(getUintConfig(CONFIG_INTERIM_PHASE_TOTAL));
5940         }
5941     }
5942 
5943     /**
5944     @notice Calculate the actual voting start for a voting round, given the tentative start
5945     @dev The tentative start is the ideal start. For example, when a proposer finish a milestone, it should be now
5946          However, sometimes the tentative start is too close to the end of the quarter, hence, the actual voting start should be pushed to the next quarter
5947     */
5948     function getTimelineForNextVote(
5949         uint256 _index,
5950         uint256 _tentativeVotingStart
5951     )
5952         internal
5953         view
5954         returns (uint256 _actualVotingStart)
5955     {
5956         uint256 _timeLeftInQuarter = getTimeLeftInQuarter(_tentativeVotingStart);
5957         uint256 _votingDuration = getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL);
5958         _actualVotingStart = _tentativeVotingStart;
5959         if (timeInQuarter(_tentativeVotingStart) < getUintConfig(CONFIG_LOCKING_PHASE_DURATION)) { // if the tentative start is during a locking phase
5960             _actualVotingStart = _tentativeVotingStart.add(
5961                 getUintConfig(CONFIG_LOCKING_PHASE_DURATION).sub(timeInQuarter(_tentativeVotingStart))
5962             );
5963         } else if (_timeLeftInQuarter < _votingDuration.add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE))) { // if the time left in quarter is not enough to vote and claim voting
5964             _actualVotingStart = _tentativeVotingStart.add(
5965                 _timeLeftInQuarter.add(getUintConfig(CONFIG_LOCKING_PHASE_DURATION)).add(1)
5966             );
5967         }
5968     }
5969 
5970     /**
5971     @notice Check if we can add another non-Digix proposal in this quarter
5972     @dev There is a max cap to the number of non-Digix proposals CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER
5973     */
5974     function checkNonDigixProposalLimit(bytes32 _proposalId)
5975         internal
5976         view
5977     {
5978         require(isNonDigixProposalsWithinLimit(_proposalId));
5979     }
5980 
5981     function isNonDigixProposalsWithinLimit(bytes32 _proposalId)
5982         internal
5983         view
5984         returns (bool _withinLimit)
5985     {
5986         bool _isDigixProposal;
5987         (,,,,,,,,,_isDigixProposal) = daoStorage().readProposal(_proposalId);
5988         _withinLimit = true;
5989         if (!_isDigixProposal) {
5990             _withinLimit = daoProposalCounterStorage().proposalCountByQuarter(currentQuarterNumber()) < getUintConfig(CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER);
5991         }
5992     }
5993 
5994     /**
5995     @notice If its a non-Digix proposal, check if the fundings are within limit
5996     @dev There is a max cap to the fundings and number of milestones for non-Digix proposals
5997     */
5998     function checkNonDigixFundings(uint256[] _milestonesFundings, uint256 _finalReward)
5999         internal
6000         view
6001     {
6002         if (!is_founder()) {
6003             require(_milestonesFundings.length <= getUintConfig(CONFIG_MAX_MILESTONES_FOR_NON_DIGIX));
6004             require(MathHelper.sumNumbers(_milestonesFundings).add(_finalReward) <= getUintConfig(CONFIG_MAX_FUNDING_FOR_NON_DIGIX));
6005         }
6006     }
6007 
6008     /**
6009     @notice Check if msg.sender can do operations as a proposer
6010     @dev Note that this function does not check if he is the proposer of the proposal
6011     */
6012     function senderCanDoProposerOperations()
6013         internal
6014         view
6015     {
6016         require(isMainPhase());
6017         require(isParticipant(msg.sender));
6018         require(identity_storage().is_kyc_approved(msg.sender));
6019     }
6020 }
6021 
6022 // File: contracts/interactive/DaoVoting.sol
6023 /**
6024 @title Contract for all voting operations of DAO
6025 @author Digix Holdings
6026 */
6027 contract DaoVoting is DaoCommon {
6028 
6029     constructor(address _resolver) public {
6030         require(init(CONTRACT_DAO_VOTING, _resolver));
6031     }
6032 
6033 
6034     /**
6035     @notice Function to vote on draft proposal (only Moderators can vote)
6036     @param _proposalId ID of the proposal
6037     @param _vote Boolean, true if voting for, false if voting against
6038     */
6039     function voteOnDraft(
6040         bytes32 _proposalId,
6041         bool _vote
6042     )
6043         public
6044         ifDraftVotingPhase(_proposalId)
6045     {
6046         require(isMainPhase());
6047         require(isModerator(msg.sender));
6048         address _moderator = msg.sender;
6049         uint256 _moderatorStake = daoStakeStorage().lockedDGDStake(_moderator);
6050 
6051         uint256 _voteWeight;
6052         (,_voteWeight) = daoStorage().readDraftVote(_proposalId, _moderator);
6053 
6054         daoStorage().addDraftVote(_proposalId, _moderator, _vote, _moderatorStake);
6055 
6056         if (_voteWeight == 0) { // just voted the first time
6057             daoPointsStorage().addModeratorQuarterPoint(_moderator, getUintConfig(CONFIG_QUARTER_POINT_DRAFT_VOTE), currentQuarterNumber());
6058         }
6059     }
6060 
6061 
6062     /**
6063     @notice Function to commit a vote on special proposal
6064     @param _proposalId ID of the proposal
6065     @param _commitHash Hash of the vote to commit (hash = SHA3(address(pub_address), bool(vote), bytes(random string)))
6066     @return {
6067       "_success": "Boolean, true if vote was committed successfully"
6068     }
6069     */
6070     function commitVoteOnSpecialProposal(
6071         bytes32 _proposalId,
6072         bytes32 _commitHash
6073     )
6074         public
6075         ifCommitPhaseSpecial(_proposalId)
6076     {
6077         require(isParticipant(msg.sender));
6078         daoSpecialStorage().commitVote(_proposalId, _commitHash, msg.sender);
6079     }
6080 
6081 
6082     /**
6083     @notice Function to reveal a committed vote on special proposal
6084     @dev The lockedDGDStake that would be counted behind a participant's vote is his lockedDGDStake when this function is called
6085     @param _proposalId ID of the proposal
6086     @param _vote Boolean, true if voted for, false if voted against
6087     @param _salt Random bytes used to commit vote
6088     */
6089     function revealVoteOnSpecialProposal(
6090         bytes32 _proposalId,
6091         bool _vote,
6092         bytes32 _salt
6093     )
6094         public
6095         ifRevealPhaseSpecial(_proposalId)
6096         hasNotRevealedSpecial(_proposalId)
6097     {
6098         require(isParticipant(msg.sender));
6099         require(keccak256(abi.encodePacked(msg.sender, _vote, _salt)) == daoSpecialStorage().readComittedVote(_proposalId, msg.sender));
6100         daoSpecialStorage().revealVote(_proposalId, msg.sender, _vote, daoStakeStorage().lockedDGDStake(msg.sender));
6101         daoPointsStorage().addQuarterPoint(msg.sender, getUintConfig(CONFIG_QUARTER_POINT_VOTE), currentQuarterNumber());
6102     }
6103 
6104 
6105     /**
6106     @notice Function to commit a vote on proposal (Voting Round)
6107     @param _proposalId ID of the proposal
6108     @param _index Index of the Voting Round
6109     @param _commitHash Hash of the vote to commit (hash = SHA3(address(pub_address), bool(vote), bytes32(random string)))
6110     */
6111     function commitVoteOnProposal(
6112         bytes32 _proposalId,
6113         uint8 _index,
6114         bytes32 _commitHash
6115     )
6116         public
6117         ifCommitPhase(_proposalId, _index)
6118     {
6119         require(isParticipant(msg.sender));
6120         daoStorage().commitVote(_proposalId, _commitHash, msg.sender, _index);
6121     }
6122 
6123 
6124     /**
6125     @notice Function to reveal a committed vote on proposal (Voting Round)
6126     @dev The lockedDGDStake that would be counted behind a participant's vote is his lockedDGDStake when this function is called
6127     @param _proposalId ID of the proposal
6128     @param _index Index of the Voting Round
6129     @param _vote Boolean, true if voted for, false if voted against
6130     @param _salt Random bytes used to commit vote
6131     */
6132     function revealVoteOnProposal(
6133         bytes32 _proposalId,
6134         uint8 _index,
6135         bool _vote,
6136         bytes32 _salt
6137     )
6138         public
6139         ifRevealPhase(_proposalId, _index)
6140         hasNotRevealed(_proposalId, _index)
6141     {
6142         require(isParticipant(msg.sender));
6143         require(keccak256(abi.encodePacked(msg.sender, _vote, _salt)) == daoStorage().readComittedVote(_proposalId, _index, msg.sender));
6144         daoStorage().revealVote(_proposalId, msg.sender, _vote, daoStakeStorage().lockedDGDStake(msg.sender), _index);
6145         daoPointsStorage().addQuarterPoint(
6146             msg.sender,
6147             getUintConfig(_index == 0 ? CONFIG_QUARTER_POINT_VOTE : CONFIG_QUARTER_POINT_INTERIM_VOTE),
6148             currentQuarterNumber()
6149         );
6150     }
6151 }